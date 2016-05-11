# LEMP-Vagrant
Linux, Nginx, MySQL, PHP development Vagrant Config.

Please install Vagrant and Virtualbox before even bothering with this.

This should work on all host operating systems and runs Ubuntu 14.04 LTS as guest.

##Set Up
1. Clone this repo
2. `vagrant up` in the vagrant sub directory
3. Wait for it to provision.
4. Create project folders in the www directory
5. Add `192.168.33.13	phpmyadmin.vagrant` to your local hosts file
6. Add `192.168.33.13	{folder-name}.vagrant` to your hosts file for each project you add
7. Browse to http://{folder-name}.vagrant to run each project
8. Browse to [http://phpmyadmin.vagrant](http://phpmyadmin.vagrant) to access PHPMyAdmin (U:root P:[blank])

I hope you like this, please contact me at [techcapetown.co.za](https://techcapetown.co.za) or [@thelifeofbyron](https://twitter.com/thelifeofbyron) if you have any comments.
