# Hosting my Blog on Github

As part of Spring cleaning I've decided to move my little blog over to Github Pages.

Much nicer setup now and I can even see my static file history in the repo.

## How to setup Custom Domains and a {yourusername}.github.io domain

It's actually very easy.

You create a repo under your organization / user name that matches your username and the github.com url.

For instance for <a href="http://github.com/johanndutoit">github.com/johanndutoit</a> I created <a href="github.com/johanndutoit/johanndutoit.github.com">github.com/johanndutoit/johanndutoit.github.com</a>. 

When you've done that. The next step is to commit and push a index.html file for your pages. I've only tested index.html, not sure about index.htm. Try it and let me know !

When you've create your HTML you then add another file named <pre>CNAME</pre>, like that extacly. In this file you add <pre>yourdomain.com</pre>. This is how Github finds your domain when you hit the server with it.

Next, head over to your DNS management interface and change your A (yourdomain.com) to <pre>204.232.175.78</pre> (Shown on <a href="https://help.github.com/articles/setting-up-a-custom-domain-with-pages">Github Pages Docs</a> as 13 April 2013). Also remember to add point the www CNAME to your A record.

Then give it a day or two and you'll be seeing your github pages when you visit yourdomain.com. Very nice another service I don't have to worry about !