#!/usr/bin/env bash

# Wait for MySQL to wake from its slumber

sleep 30

cd ..
rm -fr html

# Configue Drupal
drush dl drupal-7.54
mv drupal-7.54 html
cd html
cp /info.php .

drush si --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@mysql/${MYSQL_DRUPAL_DATABASE} --locale=uk --account-mail=${DRUPAL_ACCOUNT_MAIL} --account-name=${DRUPAL_ACCOUNT_NAME} --account-pass=${DRUPAL_ACCOUNT_PASS} --site-mail=${DRUPAL_SITE_MAIL} --site-name="${DRUPAL_SITE_NAME}" -y

# Install CiviCRM
ln -s /civicrm/civicrm /var/www/html/sites/all/modules/

drush --include=sites/all/modules/civicrm/drupal/drush civicrm-install --dbname=civicrm --dbpass=${MYSQL_PASSWORD} --dbuser=${MYSQL_USER} --dbhost=mysql --destination=sites/all/modules --site_url=localhost

drush dl ctools datatables devel views -y
drush pm-enable ctools -y
drush pm-enable devel -y
drush pm-enable views -y
drush pm-enable datatables -y

drush up

ln -s /lcbru_civicrm/lcbru_custom /var/www/html/sites/all/
ln -s /lcbru_civicrm/lcbru_modules /var/www/html/sites/all/modules/

chown -R www-data:www-data sites
chown -R www-data:www-data /lcbru_civicrm
chown -R www-data:www-data /civicrm

drush pm-enable lcbru -y

chown -R www-data:www-data sites

a2enmod rewrite
apache2-foreground