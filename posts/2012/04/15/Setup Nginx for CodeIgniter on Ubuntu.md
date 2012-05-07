I recently launched my site - <a href="http://www.curriculumvitae.co.za/" target="_blank">Curriculum Vitae</a> - which is built , mostly, with PHP and MySQL, the regular LAMP stack. And of course I used the great Twitter Bootstrap and Codeigniter Frameworks.<br />
<div>
<br /></div>
<div>
The site is running a on a VPS with Ubuntu 11.10. It all was very easy to setup as at first I used Apache2 which is a great server and the site was running for 2 weeks with this configuration but I kept reading on Nginx and saw a real benefit to having a reverse proxy already setup handling requests.</div>
<div>
<br /></div>
<div>
So I set out create a server that would run my CodeIgniter Site and keep PHP as fast as I could.<br />
<br /></div>
<div>
<h3>















Step 1 - Updating Apt with sources</h3>
</div>
<div>
As we are running Ubuntu (But this should work in Debian too, worth a try right?) we would want to use apt. So first let's get a fresh package list.</div>
<div>
<br /></div>
<div>
<pre style="background-color: #eeeeee; border: 1px dashed #999999; color: black; font-family: Andale Mono, Lucida Console, Monaco, fixed, monospace; font-size: 12px; line-height: 14px; overflow: auto; padding: 5px; width: 98%;"><code>sudo apt-get update</code></pre>
</div>
<div>
<h3>
<br /></h3>
<h3>















Step 2 - Installing Nginx</h3>
<div>
Thanks to apt this is really easy.<br />
<br /></div>
<div>
<div>
<pre style="background-color: #eeeeee; border: 1px dashed #999999; color: black; font-family: Andale Mono, Lucida Console, Monaco, fixed, monospace; font-size: 12px; line-height: 14px; overflow: auto; padding: 5px; width: 98%;"><code>sudo apt-get install nginx</code></pre>
</div>
</div>
</div>
<div>
<br />
That just too easy isn't it no need to compile! Test that you Nginx is indeed working by going to localhost:80, if not use some Google-fu.<br />
<br />
<h3>













Step 3 - Installing PHP5</h3>
</div>
<div>
Again thanks to Apt this is just as easy. This is the&nbsp;usual&nbsp;suite of modules that I install so customize to your own needs.</div>
<div>
<br /></div>
<div>
<pre style="background-color: #eeeeee; border: 1px dashed #999999; color: black; font-family: Andale Mono, Lucida Console, Monaco, fixed, monospace; font-size: 12px; line-height: 14px; overflow: auto; padding: 5px; width: 98%;"><code>sudo apt-get install php5-mysql php5-curl php5-gd php5-idn php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl
</code></pre>
</div>
<div>
<br />
Check if install by&nbsp;successful by issues the command<br />
<br />
<pre style="background-color: #eeeeee; border: 1px dashed #999999; color: black; font-family: Andale Mono, Lucida Console, Monaco, fixed, monospace; font-size: 12px; line-height: 14px; overflow: auto; padding: 5px; width: 98%;"><code>php -v
</code></pre>
<br />
If your Version of PHP is shown all is OK if not, check for any errors that may have&nbsp;occurred&nbsp;during install.<br />
<br />
<h3>









Step 4 - Installing PHP-FPM</h3>
Nginx is quite diffrent from Apache. First and foremost it's non-blocking while Apache is blocks, but for our context Nginx does not run PHP itself. Nginx was built as a reverse proxy, so it simply forwards requests to the specified url / address. So to run PHP we need a container that would run the PHP and act as the host where Nginx is sending requests to.<br />
<br />
This is where PHP-FPM comes in. PHP runs as a container and runs the PHP files when requests come in. Great so lets install it!<br />
<br />
<pre style="background-color: #eeeeee; border: 1px dashed #999999; color: black; font-family: Andale Mono, Lucida Console, Monaco, fixed, monospace; font-size: 12px; line-height: 14px; overflow: auto; padding: 5px; width: 98%;"><code>apt-get install php5-fpm
</code></pre>
<br />
That should install FPM and start the service. Great so we are half-way there!<br />
<br />
<h3>








Step 5 - Configure Nginx to forward requests for PHP to PHP-FPM</h3>
</div>
<div>
Now we have a default installation of Nginx and PHP-FPM running. Wow!</div>
<div>
<br /></div>
<div>
Let's configure Nginx to forward requests to PHP-FPM and in a way that would allow CodeIgniter to run just as it would have on Apache with Rewrite. I'm assuming your using Rewrite and no Query String Url.</div>
<div>
<br /></div>
<div>
Edit Nginx's Site Configuration at&nbsp;<b>/etc/nginx/sites-available/default </b>and include the following configuration:</div>
<div>
<br /></div>
<div>
<pre style="background-color: #eeeeee; border: 1px dashed #999999; color: black; font-family: Andale Mono, Lucida Console, Monaco, fixed, monospace; font-size: 12px; line-height: 14px; overflow: auto; padding: 5px; width: 98%;"><code>server {
    server_name example.com;
    root path_to_your_public_root_dir;
    
    index index.html index.php index.htm;

    # set expiration of assets to MAX for caching
    location ~* \.(ico|css|js|gif|jpe?g|png)(\?[0-9]+)?$ {
        expires max;
        log_not_found off;
    }

    location / {
        # Check if a file exists, or route it to index.php.
        try_files $uri $uri/ /index.php;
    }

    location ~* \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_split_path_info ^(.+\.php)(.*)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

}
</code></pre>
</div>
<div>
<br />
Replace <b>server_name</b>, <b>root</b>, <b>fastcgi_pass </b>with your enviroment values.<br />
<br />
If you plan on hosting multiple CodeIgniter sites with this Instance, think about moving the common settings to a file and including the file.<br />
<br />
So the&nbsp;
<b>/etc/nginx/sites-available/default</b>&nbsp;would contain:<br />
<br />
<pre style="background-color: #eeeeee; border-bottom-color: rgb(153, 153, 153); border-bottom-style: dashed; border-bottom-width: 1px; border-image: initial; border-left-color: rgb(153, 153, 153); border-left-style: dashed; border-left-width: 1px; border-right-color: rgb(153, 153, 153); border-right-style: dashed; border-right-width: 1px; border-top-color: rgb(153, 153, 153); border-top-style: dashed; border-top-width: 1px; font-family: 'Andale Mono', 'Lucida Console', Monaco, fixed, monospace; font-size: 12px; line-height: 14px; overflow-x: auto; overflow-y: auto; padding-bottom: 5px; padding-left: 5px; padding-right: 5px; padding-top: 5px; width: 98%;"><code>server {
    server_name example.com;
    root path_to_your_public_root_dir;
    include /etc/nginx/ci_host;
}</code></pre>
</div>
<div>
<br />
and <b>/etc/nginx/ci_host</b> would contain:<br />
<br />
<pre style="background-color: #eeeeee; border: 1px dashed #999999; color: black; font-family: Andale Mono, Lucida Console, Monaco, fixed, monospace; font-size: 12px; line-height: 14px; overflow: auto; padding: 5px; width: 98%;"><code>index index.html index.php index.htm;

# set expiration of assets to MAX for caching
location ~* \.(ico|css|js|gif|jpe?g|png)(\?[0-9]+)?$ {
    expires max;
    log_not_found off;
}

location / {
    # Check if a file exists, or route it to index.php.
    try_files $uri $uri/ /index.php;
}

location ~* \.php$ {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_split_path_info ^(.+\.php)(.*)$;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}
</code></pre>
</div>
<div>
<h3>
<br /></h3>
<h3>


Step 6 - Restart and Rejoice !</h3>
</div>
<div>
After all the configration is done restart Nginx by using:</div>
<div>
<br /></div>
<div>
<pre style="background-color: #eeeeee; border: 1px dashed #999999; color: black; font-family: Andale Mono, Lucida Console, Monaco, fixed, monospace; font-size: 12px; line-height: 14px; overflow: auto; padding: 5px; width: 100%;"><code>sudo service nginx restart
</code></pre>
</div>
<div>
<br />
If you visit your configured site you it should show and behave just like to would have under Apache 2 with Rewrites. Good Job!<br />
<br />
For a bit of a speed boost consider install PHP-APC too. The combination of Nginx, PHP-FPM and PHP APC is very fast!<br />
<br />
Leave comments about common issues so we can help each other out!</div>
