process.env.NODE_ENV = 'production'

gulp = require 'gulp'
nobone = require 'nobone'
expand = require 'glob-expand'
gulp_uglify = require 'gulp-uglify'

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
        @ui_path = 'ui'
        @js_path = 'js'
        @css_path = 'css'

    build: ->
        log '>> Build start.'.cyan

        self = @
        start_time = Date.now()
        compiler = require './compiler'

        renderer.file_handlers['.css'] = compiler.css_handler
        renderer.file_handlers['.js'] = compiler.js_handler

        remove self.dist_path
        .then ->
            log '>> Clean dist.'.cyan
        .then ->
            Promise.all [
                self.batch_compile 'coffee', 'js', self.js_path
                self.batch_compile 'styl', 'css', self.css_path, {
                    exclude: 'core/**/*.styl'
                }
                self.batch_compile 'coffee', 'js', self.ui_path
                self.batch_compile 'styl', 'css', self.ui_path
                self.batch_compile 'html', 'html', self.ui_path
            ]
        .then ->
            self.clean_useless()
        .then ->
            self.copy_files()
        .catch (err) ->
            kit.err err.stack.red
        .done ->
            log '>> Build done. Takes '.green + "#{(Date.now() - start_time) / 1000}".yellow + ' seconds.'.green

    batch_compile: (ext_src, ext_bin, src_dir, options = {}) ->
        self = @
        defaults =
            exclude: ''
            src_path: @src_path
            dist_path: @dist_path

        opts = _.defaults options, defaults
        root_path = @root_path
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

            Promise.all(_.map paths, (path) ->
                src_path = join(opts.src_path, path)
                dist_path = join(opts.dist_path, path)
                    .replace new RegExp("\\.#{ext_src}$"), ".#{ext_bin}"

                log '>> Compile: '.cyan + src_path.replace(root_path, '') + ' -> '.grey + dist_path.replace(root_path, '')

                renderer.render(src_path, ".#{ext_bin}").then (code) ->
                    kit.outputFile(dist_path, code) if code
            )

    clean_useless: ->
        root_path = @root_path
        Promise.all _.map [
            join @dist_path, 'build.txt'
            join @dist_path, 'js'
        ], (path) ->
            remove path
            log ">> Remove: #{path.replace(root_path, '')}".blue

    copy_files: ->
        log ">> Copy files.".cyan

        self = @
        root_path = @root_path

        files = [
            join(@src_path, 'img', '**', '*')
            join(@src_path, 'ui', '**', '*.+(png|jpg)')
        ]

        if process.env.NODE_ENV is 'production'
            gulp.src(join @src_path, 'js', '*init.js')
                .pipe(gulp_uglify())
                .pipe(gulp.dest join(@dist_path, 'js'))
        else
            files.push join(@src_path, 'js', '*+(init.js)')

        kit.glob(files).then (paths) ->
            Promise.all(_.map paths, (path) ->
                path = relative self.src_path, path
                from = join self.src_path, path
                to = join self.dist_path, path
                kit.copy(from, to).then ->
                    log '>> Copy: '.cyan + from.replace(root_path, '') + ' -> '.grey + to.replace(root_path, '')
            )

module.exports = new Builder
