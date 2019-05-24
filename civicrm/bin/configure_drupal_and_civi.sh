#!/usr/bin/env bash

if [ -z "$INSTALL_DATABASE" ]
then
        INSTALL_DATABASE=0
fi

if [ $INSTALL_DATABASE -gt 0 ]
then
	echo "+++++++++++++++++++ Installing Drupal and CiviCRM +++++++++++++++++++++"
    install_drupal_database.sh
fi

echo "+++++++++++++++++++ Installing Settings +++++++++++++++++++++"
cp /settings/* /var/local/civicrm/drupal/sites/default

# Link to the LCBRU modules and custom code
rm -f /var/local/civicrm/drupal/sites/all/lcbru_custom
rm -f /var/local/civicrm/drupal/sites/all/modules/lcbru_modules
ln -s /lcbru_civicrm/lcbru_custom /var/local/civicrm/drupal/sites/all/
ln -s /lcbru_civicrm/lcbru_modules /var/local/civicrm/drupal/sites/all/modules/

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

if [ -z "$INSTALL_TEST_DATA" ]
then
        INSTALL_TEST_DATA=0
fi

if [ $INSTALL_TEST_DATA -gt 0 ]
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

drush up

chown -R www-data:www-data /var/local/civicrm/drupal/sites
chown -R www-data:www-data /civicrm
chown -R www-data:www-data /var/local/civicrm/drupal/sites/all/lcbru_custom/civicrm_extensions

# Complains if the LDAP version has changed
drush sql-query "DELETE FROM authmap;"

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf