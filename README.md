Festival app
============
This is a [phonegap](http://phonegap.com/) application.


Quickstart
----------

### Requirements

- [Git](http://git-scm.com/)
- [Maven 3](http://maven.apache.org/download.html)
- [JDK 7](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1637583.html)

### Get the code

    git clone git@github.com:alanshaw/festival-app.git

### Compile the app for devices

The code in the festival-app git repository is cross platform HTML/CSS and JS. In order to use the application it must be compiled for specific devices.

Follow the relevant [getting started guide](http://docs.phonegap.com/en/2.0.0/guide_getting-started_index.md.html) from the phonegap website.

#### Install PhoneGap plugins

The following PhoneGap plugins should be installed:

- Torch (https://github.com/purplecabbage/phonegap-plugins/)<br/>
  iOS - Not mentioned in the documentation is that you need to add the Torch plugin to the Plugins dictionary in your cordova.plist. To get it to compile under Xcode 4 you'll need to remove all the IFDEFs in the .h and .m file, keeping only the code for CORDOVA_FRAMEWORK. 

The cross platform HTML/CSS and JS needs to be built using Maven, you'll need to run a mvn package to compile the coffeescript and LESS files.

In the future, you'll need to activate the relevant maven profile to get the compiled festival app of your choice - glastonbury for example.

Next delete the sample www directory in your project and symlink to the directory where you cloned the festival-app code.

     cd /path/to/device/specific/project
     rm -R www
     ln -s /path/to/cloned/festival-app/target/festival-app-1.0-SNAPSHOT www

You should now be able to compile and run the app in the relevant simulator/device.


Directory structure
-------------------

This is somewhat up in the air at the moment but for the time being the following directory structure is being used:

* js - Shared JavaScript/CoffeeScript for use with the application
* js/lib - Shared JavaScript/CoffeeScript libraries including the festival library
* mod - Directory for application modules
* mod/*/js - CoffeeScript(s) to make the module work
* mod/*/css - Default LESS stylesheet(s) for the module
* mod/*/xxx.html - Module HTML
* festival - Directory for festival specific files
* festival/*/css - Theme CSS/LESS files
* festival/*/mod/*/js - (Not usually used) Overridden module CoffeeScript(s) for the festival
* festival/*/mod/*/css - Themed CSS/LESS stylesheet(s) for the module
* festival/*/mod/*/xxx.html - (Not usually used) Overridden module HTML for the festival
