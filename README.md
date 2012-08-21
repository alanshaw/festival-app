Festival app
============
This is a [phonegap](http://phonegap.com/) application.


Quickstart
----------

### Get the code

    git clone git@github.com:alanshaw/festival-app.git

### Compile the app for devices

The code in the festival-app git repository is cross platform HTML/CSS and JS. In order to use the application it must be compiled for specific devices.

Follow the relevant [getting started guide](http://docs.phonegap.com/en/2.0.0/guide_getting-started_index.md.html) from the phonegap website.

The cross platform HTML/CSS and JS needs to be built using Maven, you'll need to run a mvn package to compile the coffeescript and LESS files.

In the future, you'll need to activate the relevant maven profile to get the compiled festival app of your choice - glastonbury for example.

Next delete the sample www directory in your project and symlink to the directory where you cloned the festival-app code.

     cd /path/to/device/specific/project
     rm -R www
     ln -s /path/to/cloned/festival-app/target/festival-app-1.0-SNAPSHOT www

You should now be able to compile and run the app in the relevant simulator/device.
