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

Next delete the sample www directory in your project and symlink to the directory where you cloned the festival-app code.

     cd /path/to/device/specific/project
     rm -R www
     ln -s /path/to/cloned/festival-app www

You should now be able to compile and run the app in the relevant simulator/device.
