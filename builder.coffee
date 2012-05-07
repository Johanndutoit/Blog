fs = require 'fs'
jade = require 'jade'
util = require 'util'
md = require("node-markdown").Markdown;
path = require 'path'
wrench = require 'wrench'

###
@author Johann du Toit
###
view_parse = (filename, locals, fn) ->

	file = __dirname + '/views/' + filename
	file_content = fs.readFileSync(file,'utf8')
	output = jade.compile file_content, {filename: file}

	locals.current_year = 2012 # Need to automate this!

	fn undefined, output(locals)

read_blog_posts = (fn) ->
	posts = []
	years = []

	years = fs.readdirSync __dirname + "/posts/"

	for year in years
		if 1*year not in years
			years.push 

		months = fs.readdirSync __dirname + "/posts/" + year

		for month in months
			days = fs.readdirSync __dirname + "/posts/" + year + "/" + month

			for day in days
				post_files = fs.readdirSync __dirname + "/posts/" + year + "/" + month + "/" + day + "/"

				for post_name in post_files
					post = {}
					post.title = post_name.substr( 0, post_name.lastIndexOf( "." ) )
					post.date = year + "/" + month + "/" + day
					post.year = year
					post.month = month
					post.day = day
					post.filename = post.title.toLowerCase().replace(/\ /g, '-') + ".html"
					post.path = year + "/" + month + "/" + day + "/" + post.filename
					post.url = '/' + post.path
					post.content = md fs.readFileSync __dirname + "/posts/" + year + "/" + month + "/" + day + "/" + post_name, 'UTF-8'
					posts.push post

	# Sort the Blog Posts
	posts.reverse (a, b) ->
		((1*b.year) + (1*b.month) + (1*b.day)) - ((1*a.year) + (1*a.month) + (1*a.day))

	years.sort (a, b) ->
		b - a

	fn posts, years

# res.render 'home.jade', {title: 'Johann du Toit', description: "My Blog", posts: [{title:"THis is me Testing this and bla", url:'/2012/01/29/testing', date: new Date()}]}

# res.render 'post.jade', {title: 'Doing this and that | Johann du Toit', description: '',recent_posts: [], post: {title: 'Testin Title', content: 'Post Content'}}

site_dir = 'site'

read_blog_posts (posts, years) ->
	# Now that we have the posts start creating the files.

	path.exists 'site', (site_dir_exists) ->
		if site_dir_exists == false
			fs.mkdirSync 'site', 2

		wrench.copyDirSyncRecursive(__dirname + '/assets', __dirname + '/' + site_dir + "/");

		# Create the Homepage
		view_parse 'home.jade', {title: 'Johann du Toit', description: "Testing", posts: posts.slice(0, 8)}, (err, output) ->
			fs.writeFile site_dir + '/index.html', output, 'utf8', ->
				true

		view_parse 'archive.jade', {title: 'Johann du Toit', description: "Testing", posts: posts, 'years' : years}, (err, output) ->
			fs.writeFile site_dir + '/archive.html', output, 'utf8', ->
				true

		posts.forEach (post) ->
			path.exists 'site/' + post.year + "/" + post.month + "/" + post.day , (post_dir_exists) ->
				if post_dir_exists == false
					wrench.mkdirSyncRecursive 'site/' + post.year + "/" + post.month + "/" + post.day, 777

				view_parse 'post.jade', {title: post.title + ' | Johann du Toit', description: "Testing", post: post, recent_posts:posts.slice(0, 8)}, (err, output) ->
					fs.writeFile __dirname + "/" + site_dir + '/' + post.path, output, 'utf8', (err, a) ->
						true
			













