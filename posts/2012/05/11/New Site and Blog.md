Was using Blogger for a while and it all works great, <strong>BUT</strong> I don't like having no control and it all just seems too much.

So what does any self-respecting programmer do ? Build his / her own! So I set out to build me a small blog that could be:

* Versioned using Git
* Fast and requiring almost no resources
* Easy to update
* SIMPLE

This is how I built the script that generates the blog.

### But first a Q & A

#### How the Blog is setup

I have a repo up on github that I keep the script and my blog posts - Named surprisingly <a href="https://github.com/Johanndutoit/Blog">Blog</a> ...

This is where I host my articles, script and assets.

Posts are listed under posts and as a I wanted to organize my posts each child of posts/ represents a year.

So a normal listing would be:

* posts/2012/
* posts/2011/

Under each year we have months, who saw that coming ? And under each month we have a dates that are also folders So my posts would be organized by year, month and date.

Then under that tree we would have the Blog post in a file "Blog Post.md", where the filename is the title.

An Example of this Directory tree would be:

<ul>
	<li>
		2012
		<ul>
			<li>
				01
				<ul>
					<li>
						15
						<ul>
							<li>
								Blog Post #1.md
							</li>
						</ul>
					</li>
					<li>
						29
						<ul>
							<li>
								Blog Post #2.draft.md
							</li>
						</ul>
					</li>
				</ul>
			</li>
		</ul>
	</li>
	<li>
		2011
		<ul>
			<li>
				04
				<ul>
					<li>
						20
						<ul>
							<li>
								Blog Post #3.md
							</li>
						</ul>
					</li>
				</ul>
			</li>
		</ul>
	</li>
</ul>

As you can see the blog post is a Markdown file. Much easier to create, update and parse into various formats for me. Adding a draft function right after launch. So I could mark a file as .draft.md as to demonstrate that I was still working on this post and not to publish it.

So now I have my blog posts in markdown files and my assets under assets/. What now? Well when I want to update my blog I do a quick <code>coffee builder.coffee</code> that creates a site/ directory with all my assets, parsed blog posts, Atom Feed, Archive Page and Homepage.

> Nothing more. No rocket science here!

I then take the generated site and update my online page.

Going to be implementing hooks so everytime I commit a blog post the site is updated. Cool huh ?
<br />
#### Why a Static Site?

I don't need a bloated platform to write. I simply want something that will allow me write without restrictions such as Admin Backends etc...

Another reason would be that this site is purely for me to express myself. I don't need any sessions, cookies or users. My Site, My Script My Rules.

Thanks to the entire site being only html Nginx really serves this at a heart racing speed!

#### I Like this! Where can I get the code ?

The Entire blog is open source. Check it out at <a href="https://github.com/Johanndutoit/Blog">Blog</a>.

Want your own blog just like this ? Fork the repo, edit it to your liking and put it online!

### So how did I build this?

Thought I'd write a guide on how I went about this and what I learned along the way. 

> Follow my <a href="https://github.com/Johanndutoit/Blog/commits/master">Commit Log</a> over on <a href="https://github.com">Github</a>.

#### First Steps

So we've decided to do this. Lets create a empty nodejs project for us to use. I creat a package.json file to npm to manage all my dependencies. <b>No I didn't know what I wanted at the start but don't want to seperate this file, to give a complete example</b>

<pre class="prettyprint">
{
  "name": "JDT-Blog",
  "version": "0.0.1",
  "engines": {
    "node": "0.6.x",
    "npm":  "1.0.x"
  },
  "description": "My Personal Blog Generation Tool. Customize it to your own needs!",
  "author": {
    "name": "Johann du Toit"
  },
  "dependencies": {
    "coffee-script": ">= 1.x.x",
    "jade": ">= 0.25.0",
    "wrench": ">= 1.3.8",
    "node-markdown": ">= 0.1.0",
    "rss" : ">= 0.0.3"
  }
}
</pre>

Change the name and description to your own Project. Or leave it as is, I don't care!

So lets use that npm package declaration and install all the dependencies by executing:

<pre class="prettyprint">
npm install
</pre>

Maybe think about globally installing CoffeeScript, to do that execute:

<pre class="prettyprint">
npm install -g coffeescript
</pre>

Ok so now that we have a basic layout I created the posts file and the first blog post in <code>posts/2012/05/11/New Site and Blog.md</code>. Then fill this file with some super words of you and save it.

Now to create all the boilerplate:

* assets/css
* assets/js
* assets/img
* views/

Now let's start building the script that will actually assemble our site. Let's create a file called <code>builder.coffee</code> and start by inserting the follow to import all our dependencies.

<pre class="prettyprint">
fs = require 'fs'
jade = require 'jade'
util = require 'util'
md = require("node-markdown").Markdown;
path = require 'path'
wrench = require 'wrench'
RSS = require 'rss'
</pre>

Ok now that we have our references, let's create a function parse our jade files. This will make use of the Jade Lib, this is how we will build our templates.

<pre class="prettyprint">
###
Parses the Jade File used to Create .html pages of our site. Basicly the template
@author Johann du Toit
###
view_parse = (filename, locals, fn) ->

	file = __dirname + '/views/' + filename
	file_content = fs.readFileSync(file,'utf8')
	output = jade.compile file_content, {filename: file}

	locals.current_year = 2012 # Need to automate this!

	fn undefined, output(locals)
</pre>

Now let's parse the Blog Posts. Just a Loop on each level of the tree. We then parse and create objects we can work with them later.

<pre class="prettyprint">
###
Parse all the Blog Posts, Their Date and available Years.
@author Johann du Toit
###
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
					if(post_name.indexOf('.draft') == -1)
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
</pre>

This is where most of the logic would take place. Write each seperate post to file, create the homepage, create the archive page and create a RSS Feed.

<pre class="prettyprint">
site_dir = 'site'

read_blog_posts (posts, years) ->
	# Now that we have the posts start creating the files.

	path.exists 'site', (site_dir_exists) ->
		if site_dir_exists == false
			fs.mkdirSync 'site', 2

		wrench.copyDirSyncRecursive(__dirname + '/assets', __dirname + '/' + site_dir + "/");

		# Create the Homepage
		view_parse 'home.jade', {title: 'Johann du Toit', description: "My Blog!", posts: posts.slice(0, 8)}, (err, output) ->
			fs.writeFile site_dir + '/index.html', output, 'utf8', ->
				true

		# Create the Atom Feed
		feed = new RSS({
			title: 'Johann du Toit',
			description: 'description',
			feed_url: 'http://www.johanndutoit.co.za/rss.xml',
			site_url: 'http://www.johanndutoit.co.za',
			image_url: 'http://www.johanndutoit.co.za/img/logo.png',
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
		view_parse 'archive.jade', {title: 'Johann du Toit', description: "Testing", posts: posts, 'years' : years}, (err, output) ->
			fs.writeFile site_dir + '/archive.html', output, 'utf8', ->
				true

		# Create a Page for all Posts
		posts.forEach (post) ->
			path.exists 'site/' + post.year + "/" + post.month + "/" + post.day , (post_dir_exists) ->
				if post_dir_exists == false
					wrench.mkdirSyncRecursive 'site/' + post.year + "/" + post.month + "/" + post.day, 777

				view_parse 'post.jade', {title: post.title + ' | Johann du Toit', description: "Testing", post: post, recent_posts:posts.slice(0, 8)}, (err, output) ->
					fs.writeFile __dirname + "/" + site_dir + '/' + post.path, output, 'utf8', (err, a) ->
						true
</pre>

