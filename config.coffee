{ kit, kit: { Q, _ } } = require 'nobone'
coffeelint_config = require './coffeelint.json'

module.exports = {
    stylus_handler: {
        ext_src: ['.styl']
        dependency_reg: /@(?:import|require)\s+([^\r\n]+)/
        compiler: (str, path) ->
            nib = kit.require 'nib'
            stylus = kit.require 'stylus'
            deferred = Q.defer()

            abs_path = kit.path.join(process.cwd(), path)

            stylus(str)
                .set 'filename', abs_path
                .set 'compress', process.env.NODE_ENV is 'production'
                .set 'paths', ['public/css']
                .use nib()
                .import 'nib'
                .import 'core/base'
                .render (err, css) ->
                    if err
                        deferred.reject(err)
                    else
                        deferred.resolve(css)

            deferred.promise
    }

    coffee_handler: {
        ext_src: '.coffee'
        compiler: (str, path, data = {}) ->
            # Lint
            coffeelint = kit.require 'coffeelint'
            lint_results = coffeelint.lint str, coffeelint_config
            if lint_results.length > 0
                info = "node_modules/.bin/coffeelint -f coffeelint.json #{path}".cyan
                kit.err '\nCoffeeLint Warning: '.red + path +
                    "\nUse '#{info}' to lint the file."

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
    }
}

