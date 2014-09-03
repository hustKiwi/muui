stylus = require 'stylus'

{ kit } = require 'nobone'

{ Q, _ } = kit

os_path = kit.path
relative = os_path.relative
coffee_bin = './node_modules/.bin/coffee'
coffee_lint_bin = './node_modules/.bin/coffeelint'

class Builder
    constructor: ->
        @root_path = root_path = "#{__dirname}/.."
        @src_path = "#{root_path}/public"
        @js_path = "#{@src_path}/js"
        @css_path = "#{@src_path}/css"
        @stylus_path = "#{@src_path}/stylus"
        @css_styl_path = "#{@src_path}/css_styl"
        @img_path = "#{@src_path}/img"
        @tmpl_path = "#{@src_path}/tmpl"
        @dist_path = "#{root_path}/dist"

    copy: (from, to) =>
        kit.copy(from, to).then =>
            console.log '>> Copy: '.cyan + relative(@root_path, from) + ' -> '.green + relative(@root_path, to)

    build: ->
        self = @
        @start().done ->
            Q.fcall =>
                console.log '>> Build start.'.red
                kit.remove self.dist_path
            .then =>
                Q.all([
                    kit.glob os_path.join(self.js_path, '**', '*.js')
                    kit.glob os_path.join(self.css_path, '**', '*.css')
                    kit.glob os_path.join(self.img_path, '**', '*.*')
                    kit.glob os_path.join(self.css_styl_path, '**', '*.css')
                    kit.glob os_path.join(self.tmpl_path, '**', '*.js')
                ])
            .then (file_list) =>
                Q.all _.flatten(file_list).map (file) =>
                    self.copy file, self.dist_path + '/' + relative(self.src_path, file)
            .done ->
                kit.remove self.css_styl_path
                console.log '>> Build Done.'.red

    find_all: (file_type, callback) ->
        Q.fcall =>
            kit.glob os_path.join(@src_path, '**', "*.#{file_type}")
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
            console.log '>> Compiled: '.cyan + relative(@root_path, path)
        catch e
            console.log ">> Error: #{relative(@root_path, path)} \n#{e}".red

    compile_all_coffee: ->
        @find_all('coffee', @compile_coffee)

    compile_all_sass: ->
        Q.fcall =>
            kit.spawn('compass', [
                'compile'
                '--sass-dir', @css_path
                '--css-dir', @css_path
            ])

    compile_all_stylus: (path) ->
        rootPath = @root_path

        kit.glob @stylus_path + "/**/*.styl"
        .then (paths) ->
            if path
                paths = []
                paths.push path
            Q.all paths.map (path) ->
                console.log '>> Compile: '.cyan + relative(rootPath, path)
                kit.readFile path, 'utf8'
                .then (str) ->
                    Q.invoke stylus, 'render', str, { filename: path }

                .then (code) ->
                    kit.outputFile path.replace(/\/stylus\//, '/css_styl/').replace(/\.styl$/, '.css'), code if code

                .catch (error) ->
                    console.log error
        .then ->
            console.log '>> Stylus Compiled.'.green
        .catch (error) ->
            console.log error

    compile_tmpl: (path) =>
        js_path = path.replace(/(\.html)$/, '') + '.js'

        Q.fcall ->
            kit.readFile(path, 'utf8')
        .then (str) ->
            _.template(str)
        .then (code) =>
            Q.fcall ->
                # 包装成AMD方式
                code = _.template("""
                    define(function() {
                        return <%= code %>
                    });
                """, code: code)
                kit.outputFile(js_path,  code)
            .then =>
                console.log '>> Compiled: '.cyan + relative(@root_path, path)
        .fail (err) =>
            console.log ">> Compile #{relative(@root_path, path)} fail.".red

    compile_all_tmpl: ->
        @find_all('html', @compile_tmpl)

module.exports = new Builder
