{ kit, kit: { Q } } = require 'nobone'

module.exports = {
    stylus_handler: {
        ext_src: ['.styl']
        dependency_reg: /@(?:import|require)\s+([^\r\n]+)/
        compiler: (str, path) ->
            nib = kit.require 'nib'
            stylus = kit.require 'stylus'
            deferred = Q.defer()
            stylus(str)
                .set 'filename', path
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
}

