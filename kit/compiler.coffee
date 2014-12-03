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
            nib = kit.require 'nib'
            stylus = kit.require 'stylus'

            path = kit.path.join(cwd_path, path)

            new Promise (resolve, reject) ->
                stylus(str)
                    .set 'filename', path
                    .set 'compress', process.env.NODE_ENV is 'production'
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
        compiler: (str, path, data = {}) ->
            if @ext is '.js'
                return str

            # Lint
            coffeelint = kit.require 'coffeelint'
            lint_results = coffeelint.lint str, coffeelint_config
            if lint_results.length > 0
                kit.err 'Coffeelint Error:'.red
                kit.spawn "#{cwd_path}/node_modules/.bin/coffeelint", [
                    '-f', "#{cwd_path}/coffeelint.json", "#{cwd_path}/#{path}"
                ]

            coffee = kit.require 'coffee-script'
            code = coffee.compile str, _.defaults(data, {
                bare: true
                compress: process.env.NODE_ENV == 'production'
                compress_opts: { fromString: true }
            })

            if data.compress
                ug = kit.require 'uglify-js'
                ug.minify(code, data.compress_opts).code
            else
                code
