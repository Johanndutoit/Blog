Was trying to import a CSV file into Mongo but keep getting the error.

<pre class="prettyprint">exception:Invalid UTF8 character detected</pre>

After a heart racing 30 minutes I found the solution.

First run:

<pre class="prettyprint">iconv -f ISO-8859-1 -t utf-8 a.txt %3E a8.txt</pre>

This command simply convert the file to UTF-8. You can then run the normal Mongo Import:

<pre class="prettyprint">./bin/mongoimport -d {db_name} -c {collection} --type csv --file a8.txt --headerline

Just remember to change the filenames to your own !