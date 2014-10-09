nobone = require 'nobone'
coffeelint_config = require '../coffeelint.json'

{
    renderer,
    kit,
    kit: { Q, _, path }
} = nobone()

cwd_path = process.cwd()
css_path = path.join(cwd_path, './public/css')
bower_path = path.join(cwd_path, './bower_components')
views_path = path.join(cwd_path, './views')

module.exports =
    html_handler:
        ext_src: ['.html', '.jade']
        compiler: (str, path, data) ->
            if @ext is '.html'
                return str
            renderer.file_handlers['.html'].compiler
                .apply(@, [str, path, data])

    css_handler:
        ext_src: ['.styl']
        dependency_reg: /@(?:import|require)\s+([^\r\n]+)/
        dependency_roots: [css_path]
        compiler: (str, path) ->
            nib = kit.require 'nib'
            stylus = kit.require 'stylus'
            deferred = Q.defer()

            path = kit.path.join(cwd_path, path)

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
                        deferred.reject(err)
                    else
                        deferred.resolve(css)

            deferred.promise

    js_handler:
        ext_src: ['.js', '.coffee']
        compiler: (str, path, data = {}) ->
            if @ext is '.js'
                return str

            coffeelint = kit.require 'coffeelint'

            # Lint
            lint_results = coffeelint.lint str, coffeelint_config
            if lint_results.length > 0
                kit.err 'Coffeelint Error:'.red
                kit.spawn "#{cwd}/node_modules/.bin/coffeelint", [
                    '-f', "#{cwd}/coffeelint.json", "#{cwd}/#{path}"
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
