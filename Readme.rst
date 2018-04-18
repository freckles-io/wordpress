##################################
Wordpress adapter for 'freckelize'
##################################

Init
====

freckelize -pw false -r frkl:wordpress -f blueprint:wordpress -t /home/markus/freckles --no-run

cd freckle folder

docker:

frocker build

.freckelize/utils/init_wordpress_blueprint.sh

frocker run

localhost:8080

frocker backup-site

freckelize -pw false --host freckles@dev.frkl.io -r frkl:wordpress -f backups/site/wordpress_site_backup_latest.tar.bz2 -t /var/lib/freckles


vagrant:

vagrant up

localhost:8080

vagrant ssh -c 'frecklecute /vagrant/.freckelize/utils/wordpress-backup /vagrant'
