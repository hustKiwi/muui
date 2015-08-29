nobone = require 'nobone'
coffeelintConfig = require '../coffeelint.json'

{
    renderer,
    kit,
    kit: { Promise, _, path }
} = nobone()

cwdPath = process.cwd()
cssPath = path.join(cwdPath, './public/css')
bowerPath = path.join(cwdPath, './bower_components')
viewsPath = path.join(cwdPath, './views')

module.exports =
    htmlHandler:
        extSrc: ['.html', '.jade']
        compiler: (str, path, data) ->
            if @ext is '.html'
                return str
            renderer.fileHandlers['.html'].compiler
                .apply(@, [str, path, data])

    cssHandler:
        extSrc: ['.styl']
        dependencyReg: /@(?:import|require)\s+([^\r\n]+)/
        dependencyRoots: [cssPath]
        compiler: (str, path) ->
            nib = require 'nib'
            stylus = require 'stylus'

            path = kit.path.join(cwdPath, path)

            new Promise (resolve, reject) ->
                stylus(str)
                    .set 'filename', path
                    .set 'compress', kit.isProduction()
                    .set 'paths', [cssPath, bowerPath]
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

    jsHandler:
        extSrc: ['.js', '.coffee']
        compiler: (str, path) ->
            if @ext is '.js'
                return str

            # Lint
            coffeelint = require 'coffeelint'
            lintResults = coffeelint.lint str, coffeelintConfig
            if lintResults.length > 0
                kit.err 'Coffeelint Error:'.red
                kit.spawn "#{cwdPath}/node_modules/.bin/coffeelint", [
                    '-f', "#{cwdPath}/coffeelint.json", "#{cwdPath}/#{path}"
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
