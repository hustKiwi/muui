require.config({
    baseUrl: '/st/js'

    paths:
        tmpl: '/st/tmpl'
        jquery: '/st/bower/jquery/dist/jquery.min'
        lodash: '/st/bower/lodash/dist/lodash.min'

    shim:
        'core/utils': ['jquery', 'lodash']
        'ui/tab': ['core/utils']
})
