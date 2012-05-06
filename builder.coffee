fs = require 'fs'
express = require 'express'
jade = require 'jade'
util = require 'util'

app = module.exports = express.createServer()

app.set('view engine', 'jade')
app.use(express.static(__dirname + '/public'))
app.set('views', __dirname + '/views');
app.set('view options', { layout: false }) # Will do that on my own, thanks!
app.use(express.methodOverride())
app.use(express.bodyParser())
app.use(app.router)

app.configure('development', ->
	app.use express.errorHandler({ dumpExceptions: true, showStack: true })
);

app.configure('production', ->
	app.use express.errorHandler()
);

###
We setup a small page that displays docs etc. as we are already using jade for templates.
###
app.get '/', (req, res) ->
	res.render 'home.jade', {title: 'Johann du Toit', description: "My Blog"}

###
We setup a small page that displays docs etc. as we are already using jade for templates.
###
app.get '/:year/:month/:date/:title', (req, res) ->
	res.render 'post.jade', {title: '', description: ''}

###
We setup a small page that displays docs etc. as we are already using jade for templates.
###
app.get '/', (req, res) ->
	res.render 'post.jade'

port = process.env.PORT or 3000
app.listen port, -> console.log 'Listening on Port ' + port + "..."