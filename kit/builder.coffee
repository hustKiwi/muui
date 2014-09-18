process.env.NODE_ENV = 'production'

config = require '../config'
nobone = require 'nobone'
{ kit, renderer } = nobone { renderer: {} }
{
    Q
    _
    path: { relative }
} = kit


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
                kit.glob kit.path.join(self.js_path, '**', '*.js')
                kit.glob kit.path.join(self.css_path, '**', '*.css')
                kit.glob kit.path.join(self.img_path, '**', '*.*')
                kit.glob kit.path.join(self.tmpl_path, '**', '*.html')
            ])
        .then (file_list) ->
            Q.all _.flatten(file_list).map (file) ->
                self.copy file, self.dist_path + '/' + relative(self.src_path, file)
        .then ->
            kit.log '>> Build done.'.red
        .catch (err) ->
            kit.err err.stack.red

    find_all: (file_type, callback) ->
        Q.fcall =>
            kit.glob kit.path.join(@src_path, '**', "*.#{file_type}")
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
            kit.log ">> Error: #{relative(@root_path, path)}".red
            kit.err e.stack.red

    compile_all_coffee: ->
        @find_all('coffee', @compile_coffee)

    compile_all_stylus: ->
        { root_path, css_path } = @

        renderer.file_handlers['.css'] = config.stylus_handler

        kit.glob css_path + '/**/*.styl'
        .then (paths) ->
            Q.all paths.map (path) ->
                kit.log '>> Compile: '.cyan + relative(root_path, path)
                renderer.render path, '.css'
                .then (code) ->
                    kit.outputFile path.replace(/\.styl$/, '.css'), code
                .catch (err) ->
                    kit.err err.stack.red
        .then ->
            kit.log '>> Stylus compiled.'.green
        .catch (err) ->
            kit.err err.stack.red

module.exports = new Builder
