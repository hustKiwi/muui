require 'colors'
Q = require 'q'
_ = require 'lodash'
os = require '../lib/os'
gaze = require 'gaze'
stylus = require 'stylus'

os_path = os.path
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
        os.copy(from, to).then =>
            console.log '>> Copy: '.cyan + relative(@root_path, from) + ' -> '.green + relative(@root_path, to)

    start: ->
        Q.fcall =>
            os.remove @dist_path
        .then =>
            @lint_all_coffee()
        .then =>
            Q.all([
                @compile_all_coffee()
                @compile_all_sass()
                @compile_all_stylus()
                @compile_all_tmpl()
            ])
        .then =>
            Q.all([
                os.glob os_path.join(@js_path, '**', '*.js')
                os.glob os_path.join(@css_path, '**', '*.css')
                os.glob os_path.join(@img_path, '**', '*.*')
                os.glob os_path.join(@css_styl_path, '**', '*.css')
                os.glob os_path.join(@tmpl_path, '**', '*.js')
            ])
        .then (file_list) =>
            Q.all _.flatten(file_list).map (file) =>
                @copy file, @dist_path + '/' + relative(@src_path, file)
                os.remove @css_styl_path
                # os.remove @css_path
        .done ->
            console.log '>> Build done.'.yellow

    watch: ->
        {lint_coffee, compile_coffee, compile_tmpl, compile_all_stylus} = @
        self = @

        gaze "#{@js_path}/**/*.coffee", (err, watch) ->
            @on 'changed', (path) ->
                Q.fcall ->
                    lint_coffee path
                .then ->
                    compile_coffee path

        gaze "#{@tmpl_path}/**/*.html", (err, watch) ->
            @on 'changed', compile_tmpl

        os.spawn('compass', [
            'watch'
            '--sass-dir', @css_path
            '--css-dir', @css_path
        ])

        gaze "#{@stylus_path}/**/*.styl", (err, watch) ->
            @on 'changed', (path) ->
                self.compile_all_stylus path

        console.log 'Waiting...>>> ' + 'watching for changes.'.green +  ' Press Ctrl-C to Stop.'.red

    find_all: (file_type, callback) ->
        Q.fcall =>
            os.glob os_path.join(@src_path, '**', "*.#{file_type}")
        .then (file_list) =>
            Q.all(
                _.flatten(file_list).map callback
            )

    lint_coffee: (path) =>
        os.spawn coffee_lint_bin, [
            '-f',
            "#{@root_path}/coffeelint.json"
            path
        ]

    lint_all_coffee: ->
        @find_all('coffee', @lint_coffee)

    compile_coffee: (path) =>
        try
            os.spawn coffee_bin, [
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
            os.spawn('compass', [
                'compile'
                '--sass-dir', @css_path
                '--css-dir', @css_path
            ])

    compile_all_stylus: (path) ->
        rootPath = @root_path

        os.glob @stylus_path + "/**/*.styl"
        .then (paths) ->
            if path
                paths = []
                paths.push path
            Q.all paths.map (path) ->
                console.log '>> Compile: '.cyan + relative(rootPath, path)
                os.readFile path, 'utf8'
                .then (str) ->
                    Q.invoke stylus, 'render', str, { filename: path }

                .then (code) ->
                    os.outputFile path.replace(/\/stylus\//, '/css_styl/').replace(/\.styl$/, '.css'), code if core

                .catch (error) ->
                    console.log error
        .then ->
            console.log '>> Stylus Compiled.'.green
        .catch (error) ->
            console.log error


    compile_tmpl: (path) =>
        js_path = path.replace(/(\.html)$/, '') + '.js'

        Q.fcall ->
            os.readFile(path, 'utf8')
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
                os.outputFile(js_path,  code)
            .then =>
                console.log '>> Compiled: '.cyan + relative(@root_path, path)
        .fail (err) =>
            console.log ">> Compile #{relative(@root_path, path)} fail.".red

    compile_all_tmpl: ->
        @find_all('html', @compile_tmpl)

module.exports = new Builder
