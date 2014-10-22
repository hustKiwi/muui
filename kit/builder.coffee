process.env.NODE_ENV = 'production'

nobone = require 'nobone'
expand = require 'glob-expand'

{
    kit,
    renderer
} = nobone(renderer: {})

{
    _,
    Promise,
    log,
    remove,
    path: { join, relative }
} = kit

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
        log '>> Build start.'.cyan

        self = @
        compiler = require './compiler'

        renderer.file_handlers['.css'] = compiler.css_handler
        renderer.file_handlers['.js'] = compiler.js_handler

        remove self.dist_path
        .then ->
            log '>> Clean dist.'.cyan
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
            Promise.all _.map [
                self.js_temp_path
                join(self.dist_path, 'build.txt')
                join(self.dist_path, 'js', 'core', 'build_cfg.js')
            ], (path) ->
                remove path
                log ">> Remove: #{path}".blue
        .then ->
            log '>> Build done.'.green
        .catch (err) ->
            kit.err err.stack.red

    fix_requirejs_main_cfg: ->
        path = join(@js_temp_path, 'js', 'core', 'cfg.js')
        kit.readFile(path, 'utf8').then (code) ->
            code = code.replace(/\/st\/ui/, '../ui').replace(/\/st\/bower/g, '../../bower_components')
            kit.outputFile(path.replace(/cfg\.js$/, 'build_cfg.js'), code)

    build_optimize_options: ->
        self = @

        appDir = @js_temp_path
        baseUrl = join appDir, 'js'
        dir = join @dist_path
        mainConfigFile = join baseUrl, 'core', 'build_cfg.js'

        options =
            appDir: appDir
            baseUrl: baseUrl
            dir: dir
            mainConfigFile: mainConfigFile
            keepBuildDir: true
            optimize: 'none'
            optimizeCss: 'none'
            fileExclusionRegExp: /^\./

        if process.env.NODE_ENV is 'production'
            _.extend options, {
                optimize: 'uglify2'
                optimizeCss: 'standard'
            }

        kit.glob join(@js_temp_path, 'ui', '**', '*.js')
        .then (paths) ->
            options.modules = _.map paths, (path) ->
                {
                    name: 'mu' + relative(self.js_temp_path, path).slice(0, -3)
                    exclude: ['jquery', 'lodash']
                }

            # ref: https://github.com/jrburke/r.js/blob/master/build/example.build.js
            Promise.resolve options

    compress_client_js: (options) ->
        log ">> Compile client js with requirejs ...".cyan

        requirejs = kit.require 'requirejs'

        new Promise (resolve, reject) ->
            requirejs.optimize(options, (r) ->
                log r
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
            log "\n\n>> Begin to compile #{paths.length} #{ext_src} files in #{src_dir} directory.".yellow

            Promise.all _.map(paths, (path) ->
                src_path = join(opts.src_path, path)
                dist_path = join(opts.dist_path, path)
                    .replace new RegExp("\\.#{ext_src}$"), ".#{ext_bin}"

                log '>> Compile: '.cyan + src_path + ' -> '.grey + dist_path

                renderer.render(src_path, ".#{ext_bin}").then (code) ->
                    kit.outputFile(dist_path, code) if code
            )
        .then ->
            log ">> All #{ext_src} in #{src_dir} directory has been compiled.".cyan

module.exports = new Builder
