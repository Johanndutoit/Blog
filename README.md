# My Personal Blog that I run

Was using Blogger for a while and it all works great, <strong>BUT</strong> I don't like having no control and it all just seems too much.

So what does any self-respecting programmer do ? Build his / her own! So I set out to build me a small blog that could be:

* Versioned using Git
* Fast and requiring almost no resources
* Easy to update
* SIMPLE

This is how I built the script that generates the blog.

### But first a Q & A

<hr />

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

<br />
I don't need a bloated platform to write. I simply want something that will allow me write without restrictions such as Admin Backends etc...

Another reason would be that this site is purely for me to express myself. I don't need any sessions, cookies or users. My Site, My Script My Rules.

Thanks to the entire site being only html Nginx really serves this at a heart racing speed!

#### I Like this! Where can I get the code ?

The Entire blog is open source. Check it out at <a href="https://github.com/Johanndutoit/Blog">Blog</a>.

Want your own blog just like this ? Fork the repo, edit it to your liking and put it online!

<hr />

Copyright (C) 2012 Johann du Toit

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.