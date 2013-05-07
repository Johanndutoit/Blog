Was working with the Tridion System, not that I know much about it, and something my <a href="http://www.linkedin.com/in/nicoesterhuyse">colleague</a> mentioned has been resonating in my head.

He called it:

> Shotgun Programming

Quite simply it is the act of sprinkling various outputs such as File Writes, Console Writes and Logging Action in your Logic to find where an error is occurring.
Remember I always used to do this in school, while I did not know about debugging. 

But it seems it is not just for programmers who dont know about debugging. This Tridion Extension had to fire off an E-Mail after a Workflow was finished. And we couldnt use debugging in Visual Studio as the Debugger was leaving references to the database connection and this started causing problems in Tridion. 

So what did we do?

Well we had to write out a file for each stage of the program so we can see variables and error. Not very elegant.

An example would be:

<pre class="prettyprint">
public static void main(String[] args) {
	String a = "a";
	String b = "10";
	int final_number = Integer.parseInt(a) + Integer.parseInt(b);
	System.out.println("Final Number: " + final_number);
}
</pre>

but oh no! We got a runtime exception! Run for the hills! 

Ok, maybe not we know what the problem is. String a is not a number! But lets pretend we dont know so now we need to find out what is going astray. Shotgun programming would have us do something like this:

<pre class="prettyprint">
public static void main(String[] args) {
	System.out.println("Before A");
	String a = "a";
	System.out.println("Before B");
	String b = "10";
	System.out.println("Before Sum");
	int final_number = Integer.parseInt(a) + Integer.parseInt(b);
	System.out.println("Before Out");
	System.out.println("Final Number: " + final_number);
}
</pre>

So we can see the error occurs right after "Before Sum". Which narrows the error range quite a bit.

You may say that this is madness. Yes we should probally be locked up for this as the compiler would even tell us which line to check for the exception. But if you cant get the STD-Out of the Program ? I cant see anyone having much choice?

But there you have it <code>Shotgun Programming</code> use it wisely.
