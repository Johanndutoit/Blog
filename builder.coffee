fs = require 'fs'
jade = require 'jade'
util = require 'util'
md = require("node-markdown").Markdown;
path = require 'path'
wrench = require 'wrench'
RSS = require 'rss'

###
@author Johann du Toit
###
view_parse = (filename, locals, fn) ->

	file = __dirname + '/views/' + filename
	file_content = fs.readFileSync(file,'utf8')
	output = jade.compile file_content, {filename: file}

	locals.current_year = 2012 # Need to automate this!

	fn undefined, output(locals)

###
Parse the Posts Folder and extract the blog posts.

This function also builds objects with the parsed content from markdown.

@author Johann du Toit
####
read_blog_posts = (fn) ->
	posts = []
	years = []

	years = fs.readdirSync __dirname + "/posts/"

	for year in years

		if year.indexOf('.') != -1

			if 1*year not in years
				years.push 

			months = fs.readdirSync __dirname + "/posts/" + year

			for month in months
				if month.indexOf('.') is not -1

					days = fs.readdirSync __dirname + "/posts/" + year + "/" + month

					for day in days

						if day.indexOf('.') is not -1

							post_files = fs.readdirSync __dirname + "/posts/" + year + "/" + month + "/" + day + "/"

							for post_name in post_files
								if post_name.indexOf('.draft') is -1
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

site_dir = 'site'

###
Let's execute the Blog Read Method.
@author Johann du Toit
###
read_blog_posts (posts, years) ->
	# Now that we have the posts start creating the files.

	path.exists 'site', (site_dir_exists) ->
		if site_dir_exists == false
			fs.mkdirSync 'site', 2

		wrench.copyDirSyncRecursive(__dirname + '/assets', __dirname + '/' + site_dir + "/");

		# Create the Homepage
		view_parse 'home.jade', {title: 'Johann du Toit', description: "I have real passion for technology and making systems that help others in their day-to-day lives. Currently based in Stellenbosch, South-Africa.", posts: posts.slice(0, 8)}, (err, output) ->
			fs.writeFile site_dir + '/index.html', output, 'utf8', ->
				true

		# Create the Atom Feed
		feed = new RSS({
			title: 'Johann du Toit',
			description: 'description',
			feed_url: 'http://www.johanndutoit.net/atom.xml',
			site_url: 'http://www.johanndutoit.net',
			image_url: 'http://www.johanndutoit.net/img/logo.png',
			author: 'Johann du Toit'
		})

		feed_posts = posts.slice 0, 20
		feed_posts.forEach (post) ->
			feed.item({
				title:  post.title,
				description: post.content,
				url: post.url,
				date: 'May 27, 2012' 
			})

		fs.writeFile site_dir + '/atom.xml', feed.xml(), 'utf8', ->
			true

		# Creat the Archive Page
		view_parse 'archive.jade', {title: 'Johann du Toit', description: "View all my Blogs Posts in a single Page", posts: posts, 'years' : years}, (err, output) ->
			fs.writeFile site_dir + '/archive.html', output, 'utf8', ->
				true

		# Create a Page for all Posts
		posts.forEach (post) ->
			path.exists 'site/' + post.year + "/" + post.month + "/" + post.day , (post_dir_exists) ->
				if post_dir_exists == false
					wrench.mkdirSyncRecursive 'site/' + post.year + "/" + post.month + "/" + post.day, 777

				summary = post.content.substring(0, Math.min(255,post.content.length)) + "..."

				view_parse 'post.jade', {title: post.title + ' | Johann du Toit', description: summary, post: post, recent_posts:posts.slice(0, 8)}, (err, output) ->
					fs.writeFile __dirname + "/" + site_dir + '/' + post.path, output, 'utf8', (err, a) ->
						true
			













