nib = require 'nib'
stylus = require 'stylus'
{ kit } = require 'nobone'

{ Q, _ } = kit

kit_path = kit.path
relative = kit_path.relative

coffee_bin = './node_modules/.bin/coffee'
coffee_lint_bin = './node_modules/.bin/coffeelint'

class Builder
    constructor: ->
        @root_path = root_path = "#{__dirname}/.."
        @src_path = "#{root_path}/public"
        @js_path = "#{@src_path}/js"
        @css_path = "#{@src_path}/css"
        @img_path = "#{@src_path}/img"
        @tmpl_path = "#{@src_path}/tmpl"
        @dist_path = "#{root_path}/dist"

    copy: (from, to) =>
        kit.copy(from, to).then =>
            kit.log '>> Copy: '.cyan + relative(@root_path, from) + ' -> '.green + relative(@root_path, to)

    build: ->
        self = @
        Q.fcall ->
            kit.log '>> Build start.'.red
        .then ->
            kit.remove self.dist_path
            kit.log '>> Clean dist.'.green
        .then ->
            self.lint_all_coffee()
        .then ->
            Q.all [
                self.compile_all_coffee()
                self.compile_all_stylus()
            ]
        .then ->
            Q.all([
                kit.glob kit_path.join(self.js_path, '**', '*.js')
                kit.glob kit_path.join(self.css_path, '**', '*.css')
                kit.glob kit_path.join(self.img_path, '**', '*.*')
                kit.glob kit_path.join(self.tmpl_path, '**', '*.html')
            ])
        .then (file_list) ->
            Q.all _.flatten(file_list).map (file) ->
                self.copy file, self.dist_path + '/' + relative(self.src_path, file)
        .then ->
            kit.log '>> Build done.'.red

    find_all: (file_type, callback) ->
        Q.fcall =>
            kit.glob kit_path.join(@src_path, '**', "*.#{file_type}")
        .then (file_list) =>
            Q.all(
                _.flatten(file_list).map callback
            )

    lint_coffee: (path) =>
        kit.spawn coffee_lint_bin, [
            '-f',
            "#{@root_path}/coffeelint.json"
            path
        ]

    lint_all_coffee: ->
        @find_all('coffee', @lint_coffee)

    compile_coffee: (path) =>
        try
            kit.spawn coffee_bin, [
                '-c'
                '-b'
                path
            ]
            kit.log '>> Compiled: '.cyan + relative(@root_path, path)
        catch e
            kit.log ">> Error: #{relative(@root_path, path)} \n#{e}".red

    compile_all_coffee: ->
        @find_all('coffee', @compile_coffee)

    compile_all_stylus: ->
        { root_path, css_path } = @

        kit.glob css_path + '/**/*.styl'
        .then (paths) ->
            Q.all paths.map (path) ->
                kit.log '>> Compile: '.cyan + relative(root_path, path)
                kit.readFile path, 'utf8'
                .then (str) ->
                    #Q.invoke stylus, 'render', str, { filename: path }
                    deferred = Q.defer()
                    stylus(str)
                        .set 'filename', path
                        .set 'compress', process.env.NODE_ENV is 'production'
                        .set 'paths', [css_path]
                        .use nib()
                        .import 'nib'
                        .import 'core/base'
                        .render (err, css) ->
                            if err
                                deferred.reject(err)
                            else
                                deferred.resolve(css)
                    deferred.promise

                .then (code) ->
                    kit.outputFile path.replace(/\.styl$/, '.css'), code if code

                .catch (err) ->
                    kit.log err, 'error'
        .then ->
            kit.log '>> Stylus compiled.'.green
        .catch (err) ->
            kit.log err, 'error'

module.exports = new Builder
