Recently learned how to configure spring security and then connect it with a database to provide me authentication.

The thing is, I did not find a clear how to. Tried the Spring Reference guide but could not get it up and running. Then a Collegue guided me through setting up a basic provider. So I thought why not share this experience with anyone who wants to listen?

In this tutorial:

* Setup a simple JSP site
* Build a authentication provider  that will provide any type of user
* Setup the Provider to connect to a database and authenticate the user from.

### 1. Setup a Simple JSP Site

I'm going to assume you know a bit of JSP. And if you don't it's not quite that hard so do try and follow along if your up to it ? If you know your way around Eclipse and Java just skip to 2.

First we need to create a new project and setup spring with it.

I'm in Eclipse so I'm going to go to <code>File -> New -> Project</code> and Select a JSP (Dynamic Web) Site.

<center>
	<img src="/img/posts/spring/eclipse_new_dynamic_web.png" style="width:90%;" />
</center>

Right, so now we have a basic JSP site and if we run it we get.

### 2. Build a Simple Allow All Authentication Provider

<img src="#" />

Now let's add the spring libraries. Go to <a href="#">Here (Update URL)</a> and download the latest stable version of Spring 3. We then include all these libraries in our project. Ok so now we're referencing spring.

Spring requires configuration, which among other things, tells it what to:
* Authenticate Against
* What Url Patterns are secured and who can access them
* Data connections (I like to have Spring send me a pre-made connection pool)

These config files are include in your project.

<img src="#" />

We have now configured spring to use our application's provider and secured our user url. As the perceptive of you may have notice our Configured Authentication Provider is configured to <code>org.johann.spring.security.SimpleAuthenticationProvider</code>, this is our path to the class that spring will load to authenticate our request. Simple enough right.

So let's create the class that spring points to. A Provider in string must implement the <code>AuthenticationProvider (CHeck this)</code> and implement the functions from the interface. These functions are what Spring will call to do what it needs to do.

<pre class="prettyprint">
public class SimpleAuthenticationProvider implements AuthenticationProvider {
	public Authentication Authenticate(Authentication auth_request) {
		return null;
	}
}
</pre>

Let's go through this. The Authenticate method is what Spring calls when a Authentication request is received. This request contains a few things we will use.

* The Name / Username / E-Mail / User Identifier to identify the user
* Credientials (Password) to authenticate the user.

The request contains other paramters but that's a bit beyond our simple Spring Tutorial. For our simple provider we want to use the <code>getName()</code> and <code>getCredidentials()<code> method to produce which we will use to check the information against the data contained in our database.

The reponse from this Method is what tells Spring how the Authentication Request went.

Now that we are returning a basic Authentication Response, let's start adding some information to the user. Spring provides us with a UserDetails Interface which we can use to Implement our own instance of UserDetails which will be assecible to our JSP site. Cool huh ?

To create a simple user object with a Nickname paramter we do the following.

<pre class="prettyprint">
public class SimpleUserDetails implements UserDetails {
}
</pre>