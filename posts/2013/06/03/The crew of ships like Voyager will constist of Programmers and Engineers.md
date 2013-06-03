Captains Log - Star Date <strong>-309579.20506722486</strong> (That's <strong>June 3,  2013, Time: 14:09:48</strong>, check it !)

<center>
<img src="http://thetrektrek.files.wordpress.com/2012/06/tttvoyager.jpg" style="width:90%;" />

<a href="http://thetrektrek.files.wordpress.com/2012/06/tttvoyager.jpg">http://thetrektrek.files.wordpress.com/2012/06/tttvoyager.jpg</a>
</center>

Star Trek has always made me think. How do does the crew allow the ship to do dozens of unique actions with only their few buttons... 

	DISCLAIMER - this is my PERSONAL view on how we would build such a system. I'm not qualified in form of aerial engineering so don't be too harsh !

So I think I finally came up with a solution. 

The entire crew were proficient in programming and interacted with Voyager through programming subroutines for the ship to handle some kind of situation / perform some custom action or control the existing systems. 

<center>

<img src="http://thecomicking.net/wp-content/uploads/2011/11/voyscd.jpg" style="width:90%;" />

<a href="http://thecomicking.net/wp-content/uploads/2011/11/voyscd.jpg">http://thecomicking.net/wp-content/uploads/2011/11/voyscd.jpg</a>

</center>

How do you reconfigure the shields to operate on a different frequency while only using 80% of power so the rest can be diverted to the medical bay ? Do we create numerous scenarios like these and compile a huge list that the crew would need to choose from ? No ! When your in deep space you need something that will do exactly what you want and not some pre-defined behavior that only does sort of what you want and get's a few people killed. My thinking is that each crew member of Voyager would need to have their field of expertise and a set of good programming skills. 

For these examples I took JavaScript as it's a easy to use language and can imagine these sub-systems writing in a language like JavaScript. And borrowing from Node as it would actually be a good fit for something like this !

	Say the security officer wants to close all the bay doors and not allow anyone but senior crew members to access them

<pre class="prettyprint">

// This block of code
var context = this;

// Put the ship in Yellow Alert
ship.status.change( ship.states.YELLOW );

// Close all the doors
ship.bays.forEach(function(bay_obj){
	
	// Close the Door
	bay_obj.doors.closeAll();

});

// Handle Authorize Requests
ship.doors.on('open_request', function(personal_obj, door_obj, target_room){
	
	// Done, 5 = Cargo Bay
	return target_room.type == 5 && personal_obj.level > 10;

});

// Listen for ship states
ship.status.on('change', function(status_obj){
	
	// Remove the restrictions again
	// and remove the program from the main computer
	context.dispose();

});

</pre>

	The ship's senior crew would then able to access the main system and view all the programs running and stop / delete them based on their permissions. And what if the Security Officer want to restrict all crew to quarters but wants the security staff to be able to open all doors while the alert level is on red.

<pre class="prettyprint">

// This block of code
var context = this;

// Put the ship in Yellow Alert
ship.status.change( ship.states.RED );

// Handle Autherize Requests
ship.doors.on('open_request', function(personal_obj, door_obj, target_room){
	
	// Done, 5 = Cargo Bay, 6 = security team
	return personal_obj.team == 6;

});

// Liten for ship states
ship.status.on('change', function(status_obj){
	
	// Remove the restrictions again
	// and remove the program from the main computer
	context.dispose();

});

</pre>

	What if the bridge encounters a spacial anomily that forces the crew to shutdown life support on lower levels and divert that power to the first 3 levels and direct more power to the shields to provide better protection while they travel through the raditian for the next 3 days.

<pre class="prettyprint">

// This block of code
var context = this;

// Put the ship in Yellow Alert
ship.status.change( ship.states.BLUE );

// Floors to direct power from
var floors = [];

// Handle Autherize Requests
ship.floors.forEach(function(floor_obj){
	
	// If lower level
	if(floor_obj.level > 5) {

		// Shutdown Life support
		floor_obj.lifesupport.shutdown();

		// Shutdown shields on that level
		floor_obj.level.shutdown();

		// Add as a valid floor
		floors.push(floor_obj);

	}

});

// Direct power form those levels to shields
ship.shields.direct_power_from(floors);

// Stop Crew from entering door that lead to rooms that have had their life support disabled.
ship.floors.on('open_request', function(personal_obj, door_obj, target_room){
	
	// Is life support enabled in this room ?
	return target_room.lifesupport.enabled == true;

});

// Liten for ship states
ship.status.on('change', function(status_obj){
	
	// Remove the restrictions again
	// and remove the program from the main computer
	context.dispose();

});

</pre>

The ship would operate in various levels. Where the the ship would mantain core system with a strict set of rules that would keep the crew alive, no parts exploding and act as safety net if the crew try to go beyond what the ship is capable off. To sum it up the architecture of Voyager would like this: With the Main Computer handling the core functions while the crew are free to replace / or temprary run new code to exibit new actions. This makes you think of a ship app store much like Android. Where their would be a database with prebuilt script's that contain all the code which the ship would then install. The ship would then be operating as a operating system like Android does. So we would be coding against a large set of API's. 

The ship would supply a constant stream of data and our code would be responsible to parse that code. Our code could then act on these data events or we could change attributes of these systems. 

	Let's think about having to alter data before we sent it to our Internal Neural Network for processing from new a star that we have encoutered for the first time ?

<pre class="prettyprint">

interem_stream = new Stream();

ship.sensors.long_range.pipe(interem_stream);
interem_stream.pipe(ship.processing.senors.long_range);

// Change what we receive
interem_stream.on('data', function(data){
	
	// Change all & to 1.2 ?
	data = data.replace('&', '1.2');

	// Write on
	this.write(data);

});

</pre>

So the ship would be flying itself and keeping it's system running with the crew only acting as coordinators and programmers to change functions or start certain functions for the ship to perform. The more I think about this the more it makes sense. Why build a ship with predefined functions when you can build a ship that you can program ? The first general purpose galactic ship ! Of course this requires actually inputting this logic. 

So if you are in the heat of battle it's going to be another case for one of the crew to type sensible code ! So that's where the long list of predefined code blocks would help the crew defeat the enemy only requiring code if they need to do something special. 

That was my though experiment into a Start Trek ship and how we could achieve the same extensibility in a ship. What do you think ?

And to be honest the show would be very boring if it was all just a bunch of programmers trying to outwit each other !


