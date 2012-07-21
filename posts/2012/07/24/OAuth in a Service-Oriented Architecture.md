While creating the new version of Curriculum Vitae I have decided to devide the entire system up into diffrent parts that each have a job. I was aiming for a service orientated architecture.

Which sounds very good on paper but it's a bit harder when you add in that your users are authenticating with OAuth 2.0 too. So now what? How do I created a service that supports OAuth 2.0 for developers but still allow me to build sites that authenticate using sites like facebook etc.

So in this post I'm going to be guiding you through what I did. It might not be the best way, but it's my way and it worked.

Here's a basic Flow Chart of the entire process of Authenticating a Registering, obviously skipping a few if's but you get the picture.

<center>
<img src="/img/posts/curriculumvitae/ApiServiceOverview.png" alt="Flow Chart of Authentication and Registering" style="width:90%;" />
</center>

### 1. Authentication and Autherization

I went searching around the internet for the solution to this problem.

I found a ton of useful reads as such as http://stackoverflow.com/questions/4574868/securing-my-rest-api-with-oauth-while-still-allowing-authentication-via-third-pa, which all tries to bring across the same message. There is a difference between Authentication and Authorization. Which had me stretching my head a few times?

What's so important about this difference?

Then one day while doing some more searching it hit me. OAuth 2.0 allows you to authorize other applications to certain parts of a user’s profile. And it does not matter that I login using other providers as it's still just OAuth 2.0. 

So the process would be: 

* Request Authorization from the API with your Client application. 
* The API checks that everything is in order and redirects us to the OAuth Authorization Screen. 
* We check if the user is logged in. If not we redirect them to the 'connect' page. This page shows various options for logging in with providers such as Facebook, Google and Twitter. * We then let the user login, and once they are logged in we send them back to the authorization page. 
* The page then lets the user authorize the application and we do all the callbacks to finish the transaction.

Quite simply, except for the time it took me to understand what they all mean. So the important part is that it shouldn’t matter what we are using for authentication, I know OAuth 2.0 was never meant to be used for authentication but we're all just sheep following Google, Twitter and Facebook so there!, as we only want to authorize so authentication has nothing to do with the authorization call. We simply provide it responses and the clients get access or not.

### 2. Handling your Internal Apps

Great so now we have the process figured out. Let’s get coding.... oh wait how are we going to be handling internal apps.

If all of our sites and app are just consumers of the numerous apes how are we going to allow only our website to register new users? And how do we know if a user was actually registered with us?

Well I found a couple of solutions and ended up with a pretty basic one.

The API allows authorization in 2 ways: * either provide an access token which would represent a user. * Or authorize the request as one made from an application.

For authorization a user’s request we followed Facebook were we pass an access token which identifies the user. While for application authentication I quite liked HTTP-Signature by Joyent - https://github.com/joyent/node-http-signature. So for applications we only allow authorization through HTTP-Signature, helping us with some security. 

To control which applications are allowed to call functions such as 'register' we added a flag to the application. 'Internal', if an application is marked with this flag the application is one of our internal applications that are allowed to call functions such as register. We still do a lot of checking but allow us to control who calls what. Still thinking of providing something more than a Boolean as to allow only certain apps to do some action but for now we have it working.

### 3. Authenticating & Registering Users through the same service

Now that we have:

* An OAuth Authorization Enabled Service
* Applications marked as 'internal' to allow only internal apps to perform actions such as 'register'

Now we have to authenticate and registers users. To do this I built two handlers.

These handlers are 'auth/authenticate' and 'auth/register', only internal applications may access these. The 'auth/authenticate' handles all authentication from an app. The app will have the same keys and secrets as the API and authenticate the user. 

The login process is as follows: 

* User views the Connect page and decides which provider to use to login. 
* The user goes through the entire process of authenticating with the provider. 
* When the user gets the response with the access token for the user in that provider we call the 'auth/authenticate' method of the API. This method takes the access token and verifies that it's our app and that the token is valid by calling the API of the providers. 
* The API then creates / updates the account and checks for a user. If no user is found the API will return a response with the user as false, telling the website to redirect the user over to the profile registration page. If the account is already linked to a user we send a response with the user and the access token for the current application to access the user with.

And that's it we are authenticated. All requests made from this point will be made with the access token returned by the 'authenticate' response if a user was returned already.

To register we do a simple post with the account id and user's details. The service does a few checks for availability and then creates the profile and returns a response with the access token for the application to use.

#### Not that hard but no-one gave me clear instructions so I thought I'd share my experience.