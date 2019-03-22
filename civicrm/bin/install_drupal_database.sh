#!/usr/bin/env bash

# Wait for MySQL to wake from its slumber
sleep 30

cp /info.php .

# Setup Drupal
# drush si --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@mysql/${MYSQL_DRUPAL_DATABASE} --locale=uk --account-mail=${DRUPAL_ACCOUNT_MAIL} --account-name=${DRUPAL_ACCOUNT_NAME} --account-pass=${DRUPAL_ACCOUNT_PASS} --site-mail=${DRUPAL_SITE_MAIL} --site-name="${DRUPAL_SITE_NAME}" -y
php -d sendmail_path=`which true` /usr/local/bin/drush si --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@${MYSQL_HOST}/${MYSQL_DRUPAL_DATABASE} --locale=uk --account-mail=${DRUPAL_ACCOUNT_MAIL} --account-name=${DRUPAL_ACCOUNT_NAME} --account-pass=${DRUPAL_ACCOUNT_PASS} --site-mail=${DRUPAL_SITE_MAIL} --site-name="${DRUPAL_SITE_NAME}" -y

# Setup CiviCRM
drush --include=sites/all/modules/civicrm/drupal/drush civicrm-install --dbname=${MYSQL_CIVICRM_DATABASE} --dbpass=${MYSQL_PASSWORD} --dbuser=${MYSQL_USER} --dbhost=${MYSQL_HOST} --destination=sites/all/modules --site_url=localhost

# Set the base URL for civi
sed -i.bak 's/http:\/\/localhost/http:\/\/'"$BASE_URL"'/g' /var/www/html/sites/default/civicrm.settings.php

## Enable the module
drush pm-enable ctools -y
drush pm-enable devel -y
drush pm-enable views -y
drush pm-enable datatables -y
drush pm-enable dblib -y

drush up

# Create Cron User
drush user-create cronsystem --mail="donotreply@uhl-tr.nhs.uk"

# Set up external databases
ln -s /lcbru_civicrm/settings/external_databases.php /var/www/html/sites/default/
printf "\n\ninclude 'external_databases.php';\n\n" >> /var/www/html/sites/default/settings.php
