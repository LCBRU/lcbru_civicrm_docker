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

# Set the locations of the custom code directories
drush cvapi Setting.create sequential=1 customPHPPathDir="/var/www/html/sites/all/lcbru_custom/civicrm_php/"
drush cvapi Setting.create sequential=1 customTemplateDir="/var/www/html/sites/all/lcbru_custom/civicrm_templates/"
drush cvapi Setting.create sequential=1 extensionsDir="/var/www/html/sites/all/lcbru_custom/civicrm_extensions/" 

# Enable each of the modules in the semi-colon
# delimited list of packages in the ENABLED_PACKAGES
# environment variable provided by docker-compose.yml
IFS=';' read -ra PACKAGES <<< "$ENABLED_PACKAGES"
for i in "${PACKAGES[@]}"; do
    if [ "$i" != "test_data" ]
    then
        echo "----- $i ------"
        drush pm-enable $i -y
    fi
done

if [ -n "$INSTALL_TEST_DATA" ]
then
	echo "+++++++++++++++++++ Installing Test Data +++++++++++++++++++++"
    drush pm-enable test_data -y
else
	echo "+++++++++++++++++ NOT Installing Test Data +++++++++++++++++++"
fi

# Ensure that www-data can access all data created by the install
setfacl --recursive -m u:www-data:rwx sites

# Start apache with the rewrite module enabled
a2enmod rewrite

# Setup Drupal and CiviCRM Cron
{ crontab -u www-data -l ; echo "* * * * * export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && export PHP_INI_DIR=/usr/local/etc/php && cd /var/www/html/ && /usr/local/bin/drush cron >> /var/log/cron.log 2>&1"; } | crontab -u www-data -
{ crontab -u www-data -l ; echo "* * * * * export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin && export PHP_INI_DIR=/usr/local/etc/php && cd /var/www/html/ && /usr/local/bin/drush civicrm-api -u 1 job.execute >> /var/log/cron.log 2>&1"; } | crontab -u www-data -

chown -R www-data:www-data /var/www/html/sites
chown -R www-data:www-data /civicrm
chown -R www-data:www-data /var/www/html/sites/all/lcbru_custom/civicrm_extensions

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf