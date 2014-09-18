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
        @src_path = "public"
        @dist_path = "dist"

        @js_path = "js"
        @css_path = "css"
        @img_path = "img"
        @tmpl_path = "tmpl"

    copy: (from, to) =>
        kit.copy(from, to).then =>
            kit.log '>> Copy: '.cyan + from + ' -> '.green + to

    build: ->
        self = @

        kit.log '>> Build start.'.cyan

        Q.fcall ->
            kit.log '>> Clean dist.'.cyan
            kit.remove self.dist_path
        .then ->
            Q.all [
                self.batch_compile 'coffee', 'js', self.js_path
                self.batch_compile 'styl', 'css', self.css_path
            ]
        .then ->
            kit.log '>> Build done.'.green
        .catch (err) ->
            kit.err err.stack.red

    batch_compile: (ext_src, ext_bin, src_dir) ->
        self = @
        kit.glob(
            kit.path.join(src_dir, "**/*.#{ext_src}")
            { cwd: @src_path }
        ).then (paths) ->
            Q.all paths.map (path) ->
                src_path = kit.path.join self.src_path, path
                dist_path = kit.path.join(self.dist_path, path)
                    .replace new RegExp("\\.#{ext_src}$"), ".#{ext_bin}"

                kit.log '>> Compile: '.cyan + src_path + ' -> '.grey + dist_path

                renderer.render src_path, ".#{ext_bin}"
                .then (code) ->
                    kit.outputFile dist_path, code
        .then ->
            kit.log ">> All #{ext_src} compiled.".cyan

module.exports = new Builder
