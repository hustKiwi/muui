nobone = require 'nobone'
expand = require 'glob-expand'
yakuUtils = require 'yaku/lib/utils'

{
    kit,
    renderer
} = nobone(renderer: {})

{
    _, Promise, log, remove,
    path: { join, relative, sep }
} = kit

class Builder
    constructor: ->
        @rootPath = rootPath = process.cwd()
        @srcPath = join rootPath, 'public'
        @distPath = join rootPath, 'dist'
        @bowerPath = join rootPath, 'bower_components'
        @nobonePath = join rootPath, '.nobone'

    build: ->
        log '>> Build start.'.cyan

        self = @
        startTime = Date.now()
        compiler = require './compiler'

        renderer.fileHandlers['.css'] = compiler.cssHandler
        renderer.fileHandlers['.js'] = compiler.jsHandler

        Promise.all([
            remove self.distPath
            remove self.nobonePath
        ]).then ->
            log '>> Clean dist.'.cyan
        .then ->
            Promise.all [
                self.batchCompile 'coffee', 'js', 'js'
                self.batchCompile 'styl', 'css', 'css', {
                    exclude: 'core/**/*.styl'
                }
                self.batchCompile 'coffee', 'js', 'ui'
                self.batchCompile 'styl', 'css', 'ui'
                self.batchCompile 'html', 'html', 'ui'
            ]
        .then ->
            self.cleanUseless()
        .then ->
            self.copyFiles()
        .then ->
            log '>> Build done. Takes '.green + "#{(Date.now() - startTime) / 1000}".yellow + ' seconds.'.green
        .catch (err) ->
            kit.err err

    batchCompile: (extSrc, extBin, srcDir, options = {}) ->
        self = @
        defaults =
            exclude: ''
            srcPath: @srcPath
            distPath: @distPath

        opts = _.defaults options, defaults
        rootPath = @rootPath
        exclude = opts.exclude

        args = [
            {
                cwd: opts.srcPath
            },
            "#{srcDir}/**/*.#{extSrc}"
        ]

        if exclude
            if _.isArray exclude
                args = args.concat(
                    _.map exclude, (item) ->
                        "!#{srcDir}/#{item}"
                )
            else
                args.push "!#{srcDir}/#{exclude}"

        Promise.resolve(expand.apply(null, args)).then (paths) ->
            log "\n\n>> Begin to compile #{paths.length} #{extSrc} files in #{srcDir} directory.".yellow

            Promise.all(_.map paths, (path) ->
                srcPath = join(opts.srcPath, path)
                distPath = join(opts.distPath, path)
                    .replace new RegExp("\\.#{extSrc}$"), ".#{extBin}"

                log '>> Compile: '.cyan + srcPath.replace(rootPath, '') + ' -> '.grey + distPath.replace(rootPath, '')

                renderer.render(srcPath, ".#{extBin}").then (code) ->
                    kit.outputFile(distPath, code) if code
            )

    cleanUseless: ->
        { rootPath, distPath } = @

        files = [
            'build.txt'
        ]

        yakuUtils.async ->
            f = files.pop()
            if f
                f = join(distPath, f)
                remove(f).then ->
                    log ">> Remove: #{f.replace(rootPath, '')}".blue
            else
                yakuUtils.end

    copyFiles: ->
        log '>> Copy files.'.cyan

        self = @
        { rootPath, srcPath, distPath, bowerPath } = @

        copy = (from, to, filter) ->
            kit.copy(from, to, filter).then ->
                log '>> Copy: '.cyan + from.replace(rootPath, '') + ' -> '.grey + to.replace(rootPath, '')

        files = [
            join(srcPath, 'img', '**', '*')
            join(srcPath, 'ui', '**', '*.+(png|jpg)')
        ]

        bowerFiles = [
            join(bowerPath, 'eventEmitter', 'eventEmitter.js')
            join(bowerPath, 'tinycarousel', 'lib', 'jquery.tinycarousel.js')
            join(bowerPath, 'bootstrap', 'js', '*.js')
        ]

        files.push join(srcPath, 'js', '*+(init.js)')

        kit.glob(files).then (paths) ->
            yakuUtils.async ->
                path = paths.pop()
                if path
                    from = path
                    to = join(distPath, relative(srcPath, path))
                    copy(from, to, {
                        isForce: true
                    })
                else
                    yakuUtils.end
            .catch (err) ->
                kit.err err

        kit.glob(bowerFiles).then (paths) ->
            yakuUtils.async ->
                path = paths.pop()
                if path
                    path = relative bowerPath, path
                    items = path.split(sep)
                    toPath = [items[0], items[items.length - 1]].join(sep)
                    copy join(bowerPath, path), join(distPath, 'ui', 'lib', toPath), (src) ->
                        not /\.min\.js$/.test(src)
                else
                    yakuUtils.end
            .catch (err) ->
                kit.err err

module.exports = new Builder
