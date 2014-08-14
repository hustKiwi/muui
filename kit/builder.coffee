require 'colors'
Q = require 'q'
_ = require 'lodash'
os = require '../lib/os'
gaze = require 'gaze'

coffee_bin = './node_modules/.bin/coffee'

class Builder
    constructor: ->
        @src_path = "#{__dirname}/../src"
        @build_path = "#{__dirname}/../build"
        @js_path = "#{@src_path}/js"
        @css_path = "#{@src_path}/css"
        @tmpl_path = "#{@src_path}/tmpl"

    start: ->
        Q.fcall =>
            os.remove @build_path
        .then =>
            Q.all([
                @compile_all_coffee()
                @compile_all_sass()
                @compile_all_tmpl()
                os.mkdir @build_path
            ])
        .then =>
            Q.all([
                os.symlink "#{@js_path}/index.js", 'build/index.js'
                os.symlink "#{@css_path}/index.css", 'build/index.css'
            ])
        .done ->
            console.log '>> Build done.'.yellow

    watch: ->
        {compile_coffee, compile_tmpl} = @

        gaze "#{@js_path}/**/*.coffee", (err, watch) ->
            @on 'changed', compile_coffee

        gaze "#{@tmpl_path}/**/*.html", (err, watch) ->
            @on 'changed', compile_tmpl

        os.spawn('compass', [
            'watch'
            '--sass-dir', @css_path
            '--css-dir', @css_path
        ])

    compile_coffee: (path) ->
        try
            os.spawn coffee_bin, [
                '-c'
                '-b'
                path
            ]
            console.log '>> Compiled: '.cyan + path
        catch e
            console.log ">> Error: #{path} \n#{e}".red

    compile_all_coffee: ->
        Q.fcall =>
            os.glob os.path.join(@js_path, '**', '*.coffee')
        .then (coffee_list) =>
            Q.all(
                _.flatten(coffee_list).map @compile_coffee
            )

    compile_all_sass: ->
        Q.fcall =>
            os.spawn('compass', [
                'compile'
                '--sass-dir', @css_path
                '--css-dir', @css_path
            ])

    compile_tmpl: (path) ->
        js_path = path.replace(/(\.html)$/, '') + '.js'

        Q.fcall =>
            os.readFile(path, 'utf8')
        .then (str) ->
            _.template(str)
        .then (code) ->
            Q.fcall ->
                # 包装成AMD方式
                code = _.template("""
                    define(function() {
                        return <%= code %>
                    });
                """, code: code)
                os.outputFile(js_path,  code)
            .then ->
                console.log '>> Compiled: '.cyan + path

    compile_all_tmpl: ->
        Q.fcall =>
            os.glob os.path.join(@tmpl_path, '**', '*.html')
        .then (tmpl_list) =>
            Q.all(
                _.flatten(tmpl_list).map @compile_tmpl
            )

module.exports = new Builder
