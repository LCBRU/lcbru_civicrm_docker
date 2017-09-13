#!/usr/bin/env bash

if [ -n "$INSTALL_DATABASE" ]
then
	echo "+++++++++++++++++++ Installing Drupal and CiviCRM +++++++++++++++++++++"
    install_drupal_database.sh
else
	echo "+++++++++++++++++++ NOT Installing Anything! +++++++++++++++++++++"
fi

# Link to the LCBRU modules and custom code
ln -s /lcbru_civicrm/lcbru_custom /var/www/html/sites/all/
ln -s /lcbru_civicrm/lcbru_modules /var/www/html/sites/all/modules/
chown -R www-data:www-data /lcbru_civicrm

# Set up external databases
ln -s /lcbru_civicrm/settings/external_databases.php /var/www/html/sites/default/
printf "\n\ninclude 'external_databases.php';\n\n" >> /var/www/html/sites/default/settings.php

# Ensure that www-data can access all data created by the install
chown -R www-data:www-data sites

# Start apache with the rewrite module enabled
a2enmod rewrite

# Setup Drupal and CiviCRM Cron
{ crontab -u www-data -l ; echo "* * * * * export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && export PHP_INI_DIR=/usr/local/etc/php && cd /var/www/html/ && /usr/local/bin/drush cron >> /var/log/cron.log 2>&1"; } | crontab -u www-data -
{ crontab -u www-data -l ; echo "* * * * * export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && export PHP_INI_DIR=/usr/local/etc/php && cd /var/www/html/ && /usr/local/bin/drush civicrm-api -u 1 job.execute >> /var/log/cron.log 2>&1"; } | crontab -u www-data -

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf