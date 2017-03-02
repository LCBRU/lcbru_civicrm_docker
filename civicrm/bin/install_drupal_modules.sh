#!/usr/bin/env bash

# Wait for MySQL to wake from its slumber

mysql_error=1

while [ $mysql_error -gt 0 ]
do
	sleep 30
	echo "MySQL waiting..."
	mysql -h mysql -u root -p$MYSQL_ROOT_PASSWORD -e "SELECT 1" 1&2>/dev/null
	mysql_error=$?
done

echo "MySQL found!"

cd ..
rm -fr html

# Configue Drupal
drush dl drupal-7.54
mv drupal-7.54 html
cd html
cp /info.php .

drush si --db-url=mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@mysql/${MYSQL_DRUPAL_DATABASE} --locale=uk --account-mail=${DRUPAL_ACCOUNT_MAIL} --account-name=${DRUPAL_ACCOUNT_NAME} --account-pass=${DRUPAL_ACCOUNT_PASS} --site-mail=${DRUPAL_SITE_MAIL} --site-name="${DRUPAL_SITE_NAME}" -y

drush up

# Install CiviCRM
ln -s /civicrm/civicrm /var/www/html/sites/all/modules/

drush --include=sites/all/modules/civicrm/drupal/drush civicrm-install --dbname=civicrm --dbpass=${MYSQL_PASSWORD} --dbuser=${MYSQL_USER} --dbhost=mysql --destination=sites/all/modules --site_url=localhost

chown -R www-data:www-data sites

a2enmod rewrite
apache2-foreground