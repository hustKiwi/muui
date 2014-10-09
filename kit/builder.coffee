process.env.NODE_ENV = 'production'

nobone = require 'nobone'
expand = require 'glob-expand'

{
    kit,
    renderer,
    kit: { Promise, _ }
} = nobone { renderer: {} }

relative = kit.path.relative

class Builder
    constructor: ->
        @cwd_path = cwd_path = process.cwd()
        @src_path = "#{cwd_path}/public"
        @dist_path = "#{cwd_path}/dist"
        @ui_path = 'ui'
        @js_path = 'js'
        @css_path = 'css'

    copy: (from, to) ->
        kit.copy(from, to).then ->
            kit.log '>> Copy: '.cyan + from + ' -> '.green + to

    build: ->
        compiler = require './compiler'
        self = @

        kit.log '>> Build start.'.cyan

        Promise.resolve().then ->
            kit.log '>> Clean dist.'.cyan
            kit.remove self.dist_path
        .then ->
            renderer.file_handlers['.css'] = compiler.css_handler
            renderer.file_handlers['.js'] = compiler.js_handler

            Promise.all [
                self.batch_compile 'coffee', 'js', self.js_path
                self.batch_compile 'styl', 'css', self.css_path, 'core/**/*.styl'
                self.batch_compile 'coffee', 'js', self.ui_path
                self.batch_compile 'styl', 'css', self.ui_path
                self.batch_compile 'html', 'html', self.ui_path
            ]
        .catch (err) ->
            kit.err err.stack.red
        .done ->
            kit.log '>> Build done.'.green

    batch_compile: (ext_src, ext_bin, src_dir, exclude = null) ->
        self = @
        new Promise (resolve, reject) ->
            args = [
                {
                    cwd: self.src_path
                },
                "#{src_dir}/**/*.#{ext_src}"
            ]

            if exclude
                if _.isArray exclude
                    args.concat(
                        _.map exclude, (item) ->
                            "!#{src_dir}/#{item}"
                    )
                else
                    args.push "!#{src_dir}/#{exclude}"

            resolve expand.apply(null, args)
        .then (paths) ->
            Promise.all paths.map (path) ->
                src_path = kit.path.join self.src_path, path
                dist_path = kit.path.join(self.dist_path, path)
                    .replace new RegExp("\\.#{ext_src}$"), ".#{ext_bin}"

                kit.log '>> Compile: '.cyan + src_path + ' -> '.grey + dist_path

                renderer.render src_path, ".#{ext_bin}"
                .then (code) ->
                    if code
                        kit.outputFile dist_path, code
        .then ->
            kit.log ">> All #{ext_src} in #{src_dir} directory has been compiled.".cyan

module.exports = new Builder
