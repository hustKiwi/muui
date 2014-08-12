require 'colors'
Q = require 'q'
_ = require 'lodash'
os = require '../lib/os'
gaze = require 'gaze'

coffee_bin = './node_modules/.bin/coffee'
component_bin = './node_modules/.bin/component'

class Builder
    constructor: ->
        @scripts_path = 'scripts'
        @styles_path = 'styles'

    start: ->
        Q.fcall =>
            Q.all([
                @compile_all_coffee()
                @compile_all_sass()
                @compile_all_tmpl()
            ])
        .done ->
            console.log '>> Build done.'.yellow
            os.spawn(component_bin, [
                'build'
            ])

    watch: ->
        {compile_coffee, compile_tmpl} = @

        gaze "#{scripts_path}/**/*.coffee", (err, watch) ->
            @on 'changed', compile_coffee

        gaze 'tmpl/**/*.html', (err, watch) ->
            @on 'changed', compile_tmpl

        os.spawn('compass', [
            'watch'
            '--sass-dir', @styles_path
            '--css-dir', @styles_path
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
            os.glob os.path.join(@scripts_path, '**', '*.coffee')
        .then (coffee_list) =>
            Q.all(
                _.flatten(coffee_list).map @compile_coffee
            )

    compile_all_sass: ->
        Q.fcall =>
            os.spawn('compass', [
                'compile'
                '--sass-dir', @styles_path
                '--css-dir', @styles_path
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
            os.glob os.path.join('tmpl', '**', '*.html')
        .then (tmpl_list) =>
            Q.all(
                _.flatten(tmpl_list).map @compile_tmpl
            )

module.exports = new Builder
