# iNalyzer - iOS Penetration Testing Framework
by Chilik Tamir @_coreDump

https://appsec-labs.com/inalyzer/


Introduction
------
iNalyzer5 is a framework for security proffessionals that targets iOS applicaiton. 


Installation - Device
------
To install iNalyzer5, you can
  
  * Add appsec-labs repository (http://appsec-labs.com/cydia) to Cydia, then search and install "iNalyzer5",
  * Or manually download at the [Release Tab](https://github.com/appsec-labs/iNalyzer/releases) and install by iFile or dpkg.
  * After installation, reboot your iDevice and press on the iNalyzer5 icon to toggle it on (you should see the tag changes to :5544)


Installation - Laptop/PC
------
  * iNalyzer5 requiers GrapViz to work, install [GraphViz-Dot](http://www.graphviz.org/download..php)
  * iNalyzer5 requiers DoxyGen engin to work, install [DoxyGen](http://www.stack.nl/~dimitri/doxygen/download.html#srcbin)

How to use:
-------
When iNalyzer5 is running, open your browser to your iDevice ip:5544 eg http://iDeviceIP:5544
 
 1. Choose Application or Process from the list and click Package menu - Be patient as package creation can take a while
 2. Save .zip to disk and extract
 3. Run doxMe.bat (Win) or doxMe.sh (Other) or use the Wizard on dox.template that is located inside the deflated Doxygen folder
 4. Once DoxyGen finishes, open main dashboard page at Doxygen/html/index.html with FireFox
 5. To toggle Cycript console on and off double press the left-arrow keyboard key, make sure to set the iDevice IP to your target and to swich to your application when trying to communicate with it



If you find any issue after installing this tool, just uninstall it in Cydia.


Manual
------
Download User-guide from [here](https://appsec-labs.com/tools/iNalyzer-User-Guide.pdf)

iOS Support
------
iNalyzer5 officially supports iOS 8.4



License
------
Licensed under [GPLv3](http://www.gnu.org/copyleft/gpl.html).

Contact
------
iNalyzer @ appsec-labs.com
