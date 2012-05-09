Was working on my&nbsp;site&nbsp;-&nbsp;<a href="http://www.curriculumvitae.co.za/">Curriculum Vitae</a>&nbsp;-&nbsp;and needed to generate PDF's and extract data from PDF files for the users to download their CV in PDF Format.

### Had the following Requirements for the Project:

* Generate a PDF Document from HTML. Had to be able to generate PDF Documents that look just like the HTML Templates I created.</li>
* Generate a Image from HTML. Used for Previews of your CV.</li>
* Extract a Image from a PDF. Need one big image of the entire document, going to use this to add attachments documents to all generated CV's.</li>

### So how are we going to do this?

Was using a good old Python Script I wrote a couple of years ago but this just seems clanky:

<pre class="prettyprint">
from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtWebKit import *

app = QApplication(sys.argv)

web = QWebView()

if "http://" in sys.argv[1]:
    web.load(QUrl(sys.argv[1]))
else:
    f = open(sys.argv[1], 'rb')
    content = "".join(f.readlines())
    web.setHtml(content)

printer = QPrinter()
printer.setPageSize(QPrinter.A4)
printer.setOutputFormat(QPrinter.PdfFormat)
printer.setFullPage(True)
printer.setOutputFileName(sys.argv[2])

import os

def convertIt():

    print sys.argv[2]

    QApplication.exit()

QObject.connect(web, SIGNAL("loadFinished(bool)"), convertIt)

sys.exit(app.exec_())
</pre>

This worked for the problem requirements and <a href="http://www.pyside.org/" target="_blank">PySide</a> is a brilliant and fast binding for Python but wanted a solution where I did not want to write a temporary file and did not want to keep this old script floating above the water. I't needs to retire some time.

Then I found <a href="http://code.google.com/p/wkhtmltopdf/" target="_blank">WKHtmlToPDF</a>. Was very excited , finally someone created a binary that would do what I've been doing with the <a href="http://www.pyside.org/" target="_blank">PySide</a>&nbsp;binding.

Checked the documentation and the binary even allowed input and output with stdin and stdout! Which I could have done with Python too, but that's more effort on my time. This allowed me to create a PDF that I could easily write out to the client. Bingo!

### Required Actions before we can start

* Download&nbsp;<a href="http://code.google.com/p/wkhtmltopdf/" target="_blank">WKHtmlToPDF</a>&nbsp;or&nbsp;<a href="http://code.google.com/p/wkhtmltopdf/" target="_blank">WKHtmlToImage</a>&nbsp;and remember to get the static qt patch version.
* Create a alias for wkhtmltopdf or / and wkhtmltopdf which points to the binaries.
* Install GhostScript to generate Images from PDF. Ensure the Convert command is available.

### How to do this in PHP
<hr />
The site is mostly written in PHP so did a PHP wrapper first.

#### Generate a PDF from HTML

<pre class="prettyprint">
/**
* Returns the Binary Content of the Generated PDF from the HTML
* @author Johann du Toit
*/
function pdf_from_html($html) {
    $descriptorspec = array(
        0 =&gt; array('pipe', 'r'), // stdin
        1 =&gt; array('pipe', 'w'), // stdout
        2 =&gt; array('pipe', 'w'), // stderr
    );
    $process = proc_open('wkhtmltopdf --margin-top 10 --no-outline -q - -', $descriptorspec, $pipes);

    // Send the HTML on stdin
    fwrite($pipes[0], $html);
    fclose($pipes[0]);
    
    // Read the outputs
    $contents = stream_get_contents($pipes[1]);
    $errors = stream_get_contents($pipes[2]);

    fclose($pipes[1]);
    $return_value = proc_close($process);
    
    return $contents;
}
</pre>

#### Generate a Image FROM HTML

<pre class="prettyprint">
    /**
* Returns the Binary Content of the Image from the HTML
* @author Johann du Toit
*/
function image_from_html($html) {
    $descriptorspec = array(
        0 =&gt; array('pipe', 'r'), // stdin
        1 =&gt; array('pipe', 'w'), // stdout
        2 =&gt; array('pipe', 'w'), // stderr
    );
    $process = proc_open('wkhtmltoimage -q - -', $descriptorspec, $pipes);

    // Send the HTML on stdin
    fwrite($pipes[0], $html);
    fclose($pipes[0]);
    
    // Read the outputs
    $contents = stream_get_contents($pipes[1]);
    $errors = stream_get_contents($pipes[2]);

    fclose($pipes[1]);
    $return_value = proc_close($process);
    
    return $contents;
}
</pre>

#### Generate a Image of a Document from PDF

<pre class="prettyprint">
/**
* Returns the Binary Content of a Image Generated from a PDF
* @author Johann du Toit
*/
function image_from_pdf($pdf_path) {
    $descriptorspec = array(
        0 =&gt; array('pipe', 'r'), // stdin
        1 =&gt; array('pipe', 'w'), // stdout
        2 =&gt; array('pipe', 'w'), // stderr
    );
    $process = proc_open('convert -density 350% -quality 85 -append pdf:- png:-', $descriptorspec, $pipes);

    // Send the HTML on stdin
    fwrite($pipes[0], file_get_contents($pdf_path));
    fclose($pipes[0]);
    
    // Read the outputs
    $contents = stream_get_contents($pipes[1]);
    $errors = stream_get_contents($pipes[2]);

    fclose($pipes[1]);
    $return_value = proc_close($process);
    
    return $contents;
}
</pre>

### How to do this in NodeJS</h3>

<hr />

#### Generate a PDF from HTML

<pre class="prettyprint">
    var util  = require('util'),
    spawn = require('child_process').spawn;

/**
* Returns the Binary Content of the PDF Generated from the HTML
* @author Johann du Toit
*/
function html_to_pdf(html, fn, err) {

    var child_process = spawn('wkhtmltopdf', ['--margin-top', '10', '--no-outline', '-q', '-', '-']);

    var dt = false;

    child_process.on('exit', function (code) {
        if(code == 0) fn(dt);
        else err(dt);
    });

    child_process.stdout.on('data', function (data) {
        dt = data;
    });

    child_process.stderr.on('data', function (data) {
        dt = data;
    });

    child_process.stdin.write(html);
    child_process.stdin.end();
}
</pre>

#### Generate a Image FROM HTML</h4>

<pre class="prettyprint">
var util  = require('util'),
spawn = require('child_process').spawn;

/**
* Returns a Image created from the HTML given to the method.
* @author Johann du Toit
*/
function html_to_image(html, fn, err) {

    var child_process = spawn('wkhtmltoimage', ['-', '-']);

    var dt = false;

    child_process.on('exit', function (code) {
        if(code == 0) fn(dt);
        else err(dt);
    });

    child_process.stdout.on('data', function (data) {
        dt = data;
    });

    child_process.stderr.on('data', function (data) {
        dt = data;
    });

    child_process.stdin.write(html);
    child_process.stdin.end();
}
</pre>

#### Generate a Image of a Document from PDF</h4>

<pre class="prettyprint">
var util  = require('util'),
spawn = require('child_process').spawn;

/**
* Returns the Binary Content of a Image Generated from a PDF
* @author Johann du Toit
*/
function pdf_to_image(pdf_content, fn, err) {

    var child_process = spawn('convert', ['-density', '350%', '-quality', '85', '-append', 'pdf:-', 'png:-']);

    var dt = false;

    child_process.on('exit', function (code) {
        if(code == 0) fn(dt);
        else err(dt);
    });

    child_process.stdout.on('data', function (data) {
        dt = data;
    });

    child_process.stderr.on('data', function (data) {
        dt = data;
    });

    child_process.stdin.write(pdf_content);
    child_process.stdin.end();
}
</pre>

### And that's it
There you have, generate PDF Document from Various Input in PHP and NodeJS. Not anything advance but always good to have in your toolbox.

Have a better way ? Let me know !
