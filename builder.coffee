fs = require 'fs'
express = require 'express'
jade = require 'jade'
util = require 'util'

###
@author Johann du Toit
###
template_parse = (filename, locals, fn) ->

	file = __dirname + '/views/' + filename
	file_content = fs.readFileSync(file,'utf8')
	output = jade.compile file_content, {filename: file}
	locals.asset_url = '/'
	locals.base_asset_dir = __dirname + '/public/templates/' + template_name + '/assets/'
	locals.base_template_dir = __dirname + '/public/templates/' + template_name + '/layout/'

	fn undefined, output(locals)

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

app.get '/', (req, res) ->
	res.render 'home.jade', {title: 'Johann du Toit', description: "My Blog", posts: [{title:"THis is me Testing this and bla", url:'/2012/01/29/testing', date: new Date()}]}

app.get '/:year/:month/:date/:title', (req, res) ->
	res.render 'post.jade', {title: 'Doing this and that | Johann du Toit', description: '',recent_posts: [], post: {title: 'Testin Title', content: 'Post Content'}}

app.get '/jjjj', (req, res) ->
	res.render 'post.jade'

port = process.env.PORT or 3000
app.listen port, -> console.log 'Listening on Port ' + port + "..."