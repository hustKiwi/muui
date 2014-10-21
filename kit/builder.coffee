process.env.NODE_ENV = 'production'

nobone = require 'nobone'
expand = require 'glob-expand'

{
    kit,
    renderer,
    kit: { Promise, _ }
} = nobone(renderer: {})

class Builder
    constructor: ->
        @root_path = root_path = process.cwd()
        @src_path = "#{root_path}/public"
        @dist_path = "#{root_path}/dist"
        @js_temp_path = "#{root_path}/js_temp"
        @ui_path = 'ui'
        @js_path = 'js'
        @css_path = 'css'

    build: ->
        kit.log '>> Build start.'.cyan

        self = @
        compiler = require './compiler'

        renderer.file_handlers['.css'] = compiler.css_handler
        renderer.file_handlers['.js'] = compiler.js_handler

        kit.remove self.dist_path
        .then ->
            kit.log '>> Clean dist.'.cyan
        .then ->
            Promise.all [
                self.batch_compile 'coffee', 'js', self.js_path, {
                    dist_path: self.js_temp_path
                }
                self.batch_compile 'styl', 'css', self.css_path, {
                    exclude: 'core/**/*.styl'
                }
                self.batch_compile 'coffee', 'js', self.ui_path, {
                    dist_path: self.js_temp_path
                }
                self.batch_compile 'styl', 'css', self.ui_path
                self.batch_compile 'html', 'html', self.ui_path
            ]
        .then ->
            self.fix_requirejs_main_cfg()
        .then ->
            self.build_optimize_options()
        .then (options) ->
            self.compress_client_js options
        .then ->
            kit.remove self.js_temp_path
        .then ->
            kit.log '>> Build done.'.green
        .catch (err) ->
            kit.err err.stack.red

    fix_requirejs_main_cfg: ->
        kit.glob(
            kit.path.join(@js_temp_path, 'js', 'core', '*cfg.js')
        ).then (paths) ->
            Promise.all paths.map (path) ->
                kit.readFile(path, 'utf8').then (code) ->
                    code = code.replace(/\/st\/bower/g, '../../bower_components')
                    kit.outputFile(path, code)

    build_optimize_options: ->
        self = @
        relative = kit.path.relative

        appDir = @js_temp_path
        baseUrl = kit.path.join appDir, 'js'
        dir = kit.path.join @dist_path
        mainConfigFile = kit.path.join baseUrl, 'core', 'cfg.js'

        options =
            appDir: @js_temp_path
            baseUrl: kit.path.join appDir, 'js'
            dir: kit.path.join @dist_path
            mainConfigFile: kit.path.join baseUrl, 'core', 'cfg.js'
            keepBuildDir: true
            optimize: 'none'
            optimizeCss: 'none'
            modules: [
                {
                    name: 'muui/tab/index'
                    exclude: ['jquery', 'lodash']
                }
            ]

        if process.env.NODE_ENV is 'production'
            _.extend options, {
                optimize: 'uglify2'
                optimizeCss: 'standard'
            }

        kit.glob(
            kit.path.join(@js_temp_path, 'ui', '**', '*.js')
        ).then (paths) ->
            options.modules = _.map paths, (path) ->
                {
                    name: 'mu' + relative(self.js_temp_path, path).slice(0, -3)
                    exclude: ['jquery', 'lodash']
                }

            # ref: https://github.com/jrburke/r.js/blob/master/build/example.build.js
            Promise.resolve options

    compress_client_js: (options) ->
        kit.log ">> Compile client js with requirejs ...".cyan

        requirejs = kit.require 'requirejs'

        new Promise (resolve, reject) ->
            requirejs.optimize(options, (r) ->
                kit.log ">> Compile client js done.".green
                resolve r
            , (err) ->
                reject err
            )

    batch_compile: (ext_src, ext_bin, src_dir, options = {}) ->
        self = @
        defaults =
            exclude: ''
            src_path: self.src_path
            dist_path: self.dist_path

        opts = _.defaults options, defaults
        exclude = opts.exclude

        args = [
            {
                cwd: opts.src_path
            },
            "#{src_dir}/**/*.#{ext_src}"
        ]

        if exclude
            if _.isArray exclude
                args = args.concat(
                    _.map exclude, (item) ->
                        "!#{src_dir}/#{item}"
                )
            else
                args.push "!#{src_dir}/#{exclude}"

        Promise.resolve(expand.apply(null, args)).then (paths) ->
            kit.log "\n\n>> Begin to compile #{paths.length} #{ext_src} files in #{src_dir} directory.".yellow

            Promise.all paths.map (path) ->
                src_path = kit.path.join(opts.src_path, path)
                dist_path = kit.path.join(opts.dist_path, path)
                    .replace new RegExp("\\.#{ext_src}$"), ".#{ext_bin}"

                kit.log '>> Compile: '.cyan + src_path + ' -> '.grey + dist_path

                renderer.render(src_path, ".#{ext_bin}").then (code) ->
                    kit.outputFile(dist_path, code) if code
        .then ->
            kit.log ">> All #{ext_src} in #{src_dir} directory has been compiled.".cyan

module.exports = new Builder
