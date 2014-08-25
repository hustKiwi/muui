require 'colors'
Q = require 'q'
_ = require 'lodash'
os = require '../lib/os'
gaze = require 'gaze'

path = os.path
relative = path.relative
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
                @compile_all_tmpl()
            ])
        .then =>
            Q.all([
                os.glob path.join(@js_path, '**', '*.js')
                os.glob path.join(@css_path, '**', '*.css')
                os.glob path.join(@img_path, '**', '*.*')
                os.glob path.join(@tmpl_path, '**', '*.js')
            ])
        .then (file_list) =>
            Q.all _.flatten(file_list).map (file) =>
                @copy file, @dist_path + '/' + relative(@src_path, file)
        .done ->
            console.log '>> Build done.'.yellow

    watch: ->
        {lint_coffee, compile_coffee, compile_tmpl} = @

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

    find_all: (file_type, callback) ->
        Q.fcall =>
            os.glob path.join(@src_path, '**', "*.#{file_type}")
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
