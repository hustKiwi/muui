nobone = require 'nobone'
coffeelint_config = require '../coffeelint.json'

{
    renderer,
    kit,
    kit: { Promise, _, path }
} = nobone()

cwd_path = process.cwd()
css_path = path.join(cwd_path, './public/css')
bower_path = path.join(cwd_path, './bower_components')
views_path = path.join(cwd_path, './views')

module.exports =
    html_handler:
        extSrc: ['.html', '.jade']
        compiler: (str, path, data) ->
            if @ext is '.html'
                return str
            renderer.fileHandlers['.html'].compiler
                .apply(@, [str, path, data])

    css_handler:
        extSrc: ['.styl']
        dependencyReg: /@(?:import|require)\s+([^\r\n]+)/
        dependencyRoots: [css_path]
        compiler: (str, path) ->
            nib = require 'nib'
            stylus = require 'stylus'

            path = kit.path.join(cwd_path, path)

            new Promise (resolve, reject) ->
                stylus(str)
                    .set 'filename', path
                    .set 'compress', kit.isProduction()
                    .set 'paths', [css_path, bower_path]
                    .set 'cache', false
                    .set 'include css', true
                    .use nib()
                    .import 'nib'
                    .import 'core/base'
                    .render (err, css) ->
                        if err
                            reject(err)
                        else
                            resolve(css)

    js_handler:
        extSrc: ['.js', '.coffee']
        compiler: (str, path) ->
            if @ext is '.js'
                return str

            # Lint
            coffeelint = require 'coffeelint'
            lint_results = coffeelint.lint str, coffeelint_config
            if lint_results.length > 0
                kit.err 'Coffeelint Error:'.red
                kit.spawn "#{cwd_path}/node_modules/.bin/coffeelint", [
                    '-f', "#{cwd_path}/coffeelint.json", "#{cwd_path}/#{path}"
                ]

            coffee = require 'coffee-script'
            code = coffee.compile str, {
                bare: true
            }

            if kit.isProduction()
                ug = require 'uglify-js'
                ug.minify(code, {
                    fromString: true
                }).code
            else
                code
