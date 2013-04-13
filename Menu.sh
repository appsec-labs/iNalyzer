#!/bin/sh


list=$( /Applications/iNalyzer5.app/listApp.sh | tr '\n' '#' | tr ' ' '~'| tr '#' '\n' )
for f in ${list}
do
name=$( echo ${f} | tr '~' ' ' )
htmlList=$( echo ${htmlList}"<option>${name}</option>" )
done
#echo ${list}
#echo ${htmlList}
echo '<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>iNalyzer5 Packager</title>
<meta content="width=device-width,initial-scale=1.0" name="viewport">

<style>
* {
	margin:0;
	padding:0;
	box-sizing:border-box;
	-webkit-box-sizing:border-box;
	-moz-box-sizing:border-box;
	-webkit-font-smoothing:antialiased;
	-moz-font-smoothing:antialiased;
	-o-font-smoothing:antialiased;
	font-smoothing:antialiased;
	text-rendering:optimizeLegibility;
	z-index:10;
}
body {
	font:400 12px/1.625 "Helvetica Neue", Helvetica, Arial, sans-serif;
	color:#444;
	background:#001542;
	background-image:linear-gradient(left , #001542 0%, #0000CC 52%, #001542 100%);
	background-image:-moz-linear-gradient(left , #001542 0%, #0000CC 52%, #001542 100%);
	background-image:-webkit-linear-gradient(left , #001542 0%, #0000CC 52%, #001542 100%);
}
.wrapper {
	max-width:500px;
	width:95%;
	margin:0 auto;
	position:relative;
}
#contact-form input[type="text"],
#contact-form input[type="email"],
#contact-form input[type="tel"],
#contact-form input[type="url"],
#contact-form textarea,
#contact-form button[type="submit"] {
	font:400 12px/12px "Helvetica Neue", Helvetica, Arial, sans-serif;
}
#contact-form {
	text-shadow:0 1px 0 #FFF;
	border-radius:4px;
	-webkit-border-radius:4px;
	-moz-border-radius:4px;
	background:#F9F9F9;
	padding:25px;
}
#contact-form h3 {
	color:#001D57;
	display:block;
	font-size:28px;
}
#contact-form h4 {
	margin:5px 0 15px;
	display:block;
	font-size:13px;
}
#contact-form label span {
	cursor:pointer;
	color:#001D57;
	display:block;
	margin:5px 0;
	font-weight:900;
}
#contact-form input[type="text"],
#contact-form input[type="email"],
#contact-form input[type="tel"],
#contact-form input[type="url"],
#contact-form textarea {
	width:100%;
	box-shadow:inset 0 1px 2px #DDD, 0 1px 0 #FFF;
	-webkit-box-shadow:inset 0 1px 2px #DDD, 0 1px 0 #FFF;
	-moz-box-shadow:inset 0 1px 2px #DDD, 0 1px 0 #FFF;
	border:1px solid #CCC;
	background:#FFF;
	margin:0 0 5px;
	padding:10px;
	border-radius:5px;
}
#contact-form input[type="text"]:hover,
#contact-form input[type="email"]:hover,
#contact-form input[type="tel"]:hover,
#contact-form input[type="url"]:hover,
#contact-form textarea:hover {
	-webkit-transition:border-color 0.3s ease-in-out;
	-moz-transition:border-color 0.3s ease-in-out;
	transition:border-color 0.3s ease-in-out;
	border:1px solid #AAA;
}
#contact-form textarea {
	height:100px;
	max-width:100%;
}
#contact-form button[type="submit"] {
	cursor:pointer;
	width:100%;
	border:none;
	background:#001D57;
	background-image:linear-gradient(bottom, #001C50 0%, #001D57 52%);
	background-image:-moz-linear-gradient(bottom, #001C50 0%, #001D57 52%);
	background-image:-webkit-linear-gradient(bottom, #001C50 0%, #001D57 52%);
	color:#FFF;
	margin:0 0 5px;
	padding:10px;
	border-radius:5px;
}
#contact-form button[type="submit"]:hover {
	background-image:linear-gradient(bottom, #00215A 0%, #000067 52%);
	background-image:-moz-linear-gradient(bottom, #00215A 0%, #000067 52%);
	background-image:-webkit-linear-gradient(bottom, #00215A 0%, #000067 52%);
	-webkit-transition:background 0.3s ease-in-out;
	-moz-transition:background 0.3s ease-in-out;
	transition:background-color 0.3s ease-in-out;
}
#contact-form button[type="submit"]:active {
	box-shadow:inset 0 1px 3px rgba(0,0,0,0.5);
}
#contact-form input:focus,
#contact-form textarea:focus {
	outline:0;
	border:1px solid #999;
}
::-webkit-input-placeholder {
    color:#888;
}
:-moz-placeholder {
    color:#888;
}
::-moz-placeholder {
    color:#888;
}
:-ms-input-placeholder {
    color:#888;
}
#spinner {
    position: absolute;
    width: 100%;
    height: 100%;
    z-index: 99999; // puts your div on top on others
}
</style>
</head>
<body>	

<div class="wrapper">
<div id="main" style="padding:50px 0 0 0;"><div><center><canvas id="tutorial" width="150" height="150" style="position: absolute; top: 125px; left: 150px; width: 200px;     height: 200px; z-index:-9;">
			<img src="wheel.gif" />
		</canvas></center></div>
<form id="contact-form" method="get" action="/iNalyzer?">
<h1>iNalyzer Packager <img alt="" src="data:image/gif;base64,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" / width="50%"></h1>
<h2>How to use:</h2>
<h4>1. Install <a href="http://www.graphviz.org/download..php" target="_blank">GraphViz-Dot</a> on PC/Laptop<br>2. Install <a href="http://www.stack.nl/~dimitri/doxygen/download.html#srcbin" target="_blank">DoxyGen</a> on PC/Laptop<br>3. Choose Application from the list and click Package</h4>
<div>
<label>
<center><span>Choose application to Pack: 
<select name="App"  required="" tabindex="4" placeholder="Begin with http://">'
########
########

echo ${htmlList}
########
########
echo '
</select></span>
</label></center>
</div>

<div>
<label>
<span></span>
<!--textarea  required="" tabindex="5" placeholder="Include all the details you can"></textarea-->
</label>
</div>
<div style="z-index:auto;">
<button id="contact-submit" type="submit" name="EOFname" >Package</button>
<center><h5>Be patient as package creation can take a while</h5></center></div>
<h4>4. Save .zip to disk and extract<BR>5. Run Setup.bat(Win) or Setup.sh(Other) </h4>
</form>
</div>
</div>
<script>(function() {
	//init();
	// Create input element for testing
	var inputs = document.createElement("input");
	
	// Create the supports object
	var supports = {};
	
	supports.autofocus   = "autofocus" in inputs;
	supports.required    = "required" in inputs;
	supports.placeholder = "placeholder" in inputs;

	// Fallback for autofocus attribute
	if(!supports.autofocus) {
		
	}
	
	// Fallback for required attribute
	if(!supports.required) {
		
	}

	// Fallback for placeholder attribute
	if(!supports.placeholder) {
		
	}
	
	// Change text inside send button on submit
	var send = document.getElementById("contact-submit");
	if(send) {
		send.onclick = function () {
		send.innerHTML="Packaging"
		init();
		}
	}
			var ctx;
			var drawIntervalID;
			var spokes = 20;	// Number of spokes on the wheel
			function init() {
				var canvas = document.getElementById("tutorial");
				canvas.style.zIndex=9999;
				if (canvas.getContext){  
					ctx = canvas.getContext("2d");
					ctx.translate(75,75);	// Center the origin
					ctx.lineWidth = 3.5;
					ctx.lineCap = "round"
					drawIntervalID = setInterval(draw,75);
					return drawIntervalID;
				}
			}
			function draw(){
				ctx.clearRect(-75,-75,150,150);		// Clear the image
				ctx.rotate(Math.PI*2/spokes);	// Rotate the origin
				for (var i=0; i<spokes; i++) {
					ctx.rotate(Math.PI*2/spokes);	// Rotate the origin
					ctx.strokeStyle = "rgba(0,0,0,"+ i/spokes +")";	// Set transparency
					ctx.beginPath();
					ctx.moveTo(0,30);
					ctx.lineTo(0,60);
					ctx.stroke();
				}
			}  

})();</script>
</body>
</html>'