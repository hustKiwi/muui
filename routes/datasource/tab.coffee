module.exports = (req, res) ->
    res.jsonp({
        cur: '.rock-panel'
        items: [
            {
                target: '.rec-panel'
                name: '推荐'
            },
            {
                target: '.pop-panel'
                name: '流行'
            },
            {
                target: '.rock-panel'
                name: '摇滚'
            },
            {
                target: '.hiphop-panel'
                name: 'HipHop/说唱'
            }
        ]
    })
