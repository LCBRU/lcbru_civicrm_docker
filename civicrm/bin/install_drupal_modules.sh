#!/usr/bin/env bash

# Wait for MySQL to wake from its slumber

sleep 30

cp /info.php .

# Setup Drupal
drush si --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@mysql/${MYSQL_DRUPAL_DATABASE} --locale=uk --account-mail=${DRUPAL_ACCOUNT_MAIL} --account-name=${DRUPAL_ACCOUNT_NAME} --account-pass=${DRUPAL_ACCOUNT_PASS} --site-mail=${DRUPAL_SITE_MAIL} --site-name="${DRUPAL_SITE_NAME}" -y

# Setup CiviCRM
drush --include=sites/all/modules/civicrm/drupal/drush civicrm-install --dbname=civicrm --dbpass=${MYSQL_PASSWORD} --dbuser=${MYSQL_USER} --dbhost=mysql --destination=sites/all/modules --site_url=localhost

## Enable the module
drush pm-enable ctools -y
drush pm-enable devel -y
drush pm-enable views -y
drush pm-enable datatables -y
drush pm-enable dblib -y

drush up

# Link to the LCBRU modules and custom code
ln -s /lcbru_civicrm/lcbru_custom /var/www/html/sites/all/
ln -s /lcbru_civicrm/lcbru_modules /var/www/html/sites/all/modules/
chown -R www-data:www-data /lcbru_civicrm

# Set up external databases
ln -s /lcbru_civicrm/settings/external_databases.php /var/www/html/sites/default/
printf "\n\ninclude 'external_databases.php';\n\n" >> /var/www/html/sites/default/settings.php

# Set the locations of the custom code directories
drush cvapi Setting.create sequential=1 customPHPPathDir="/var/www/html/sites/all/lcbru_custom/civicrm_php/"
drush cvapi Setting.create sequential=1 customTemplateDir="/var/www/html/sites/all/lcbru_custom/civicrm_templates/"
drush cvapi Setting.create sequential=1 extensionsDir="/var/www/html/sites/all/lcbru_custom/civicrm_extensions/" 


# Enable each of the modules in the semi-colon
# delimited list of packages in the ENABLED_PACKAGES
# environment variable provided by docker-compose.yml
IFS=';' read -ra PACKAGES <<< "$ENABLED_PACKAGES"
for i in "${PACKAGES[@]}"; do
	echo "----- $i ------"
	drush pm-enable $i -y
done

# Start apache with the rewrite module enabled
a2enmod rewrite
apache2-foreground