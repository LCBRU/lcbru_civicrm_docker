FROM php:5-apache
MAINTAINER Richard Bramley <rabramley@gmail.com>


# Change where Drupal is loaded
ENV APACHE_DOCUMENT_ROOT /var/local/civicrm/drupal

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# install the PHP extensions we need
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y libpng-dev libjpeg-dev libpq-dev mysql-client vim wget zip cron supervisor ssmtp acl libldap2-dev
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr
RUN docker-php-ext-install gd
RUN docker-php-ext-install mbstring pdo pdo_mysql pdo_pgsql zip mysql mysqli sockets
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-install ldap

# supervisord config file
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Needed for pdo_dblib install because otherwise it doesn't find it
RUN apt-get install -y freetds-dev
RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/
RUN docker-php-ext-install pdo_dblib

RUN rm -rf /var/lib/apt/lists/*

RUN php -r "readfile('https://github.com/drush-ops/drush/releases/download/8.1.17/drush.phar');" > drush
RUN php drush core-status
RUN chmod +x drush
RUN mv drush /usr/local/bin

RUN drush init -y

ADD civicrm-4.7.17-drupal.tar.gz /civicrm
ADD antonelli-7.x-1.0-rc1.tar.gz /antonelli
ADD settings /settings
ADD info.php /
ADD modules /modules

# Install script to run at start up
COPY bin /usr/local/bin

RUN mkdir /var/local/civicrm

WORKDIR /var/local/civicrm

# Download Drupal
RUN drush dl drupal-7.54
RUN mv drupal-7.54 drupal

WORKDIR /var/local/civicrm/drupal

# Give apache access to the files
RUN chown -R www-data:www-data sites
RUN chown -R www-data:www-data /civicrm
RUN chown -R www-data:www-data /antonelli
RUN chown -R www-data:www-data /settings

# Copy CiviCRM into place
RUN ln -s /civicrm/civicrm /var/local/civicrm/drupal/sites/all/modules/
RUN ln -s /antonelli/antonelli /var/local/civicrm/drupal/sites/all/themes/

#
# TO DO:
#
# The specific sub-folder will have to be set on a per instance basis
ADD colors.css /var/local/civicrm/drupal/sites/default/files/color/antonelli-d1bee6f5/
ADD images.jpeg /var/local/civicrm/drupal/sites/default/files/

# Install Drupal modules
RUN drush dl ctools datatables devel views -y

## The datatables module needs you to download the JQuery
## plugin separately
RUN wget http://datatables.net/releases/DataTables-1.9.3.zip
RUN unzip DataTables-1.9.3.zip
RUN mv DataTables-1.9.3 sites/all/modules/datatables/dataTables
RUN rm DataTables-1.9.3.zip

RUN cp -r /modules/* /var/local/civicrm/drupal/sites/all/modules/
RUN ln -s /var/local/civicrm/drupal/sites/all/modules/dblib_driver_for_sql_server/dblib /var/local/civicrm/drupal/includes/database/

# Give apache access to the files
RUN chown -R www-data:www-data sites
RUN chown -R www-data:www-data /civicrm

CMD /usr/local/bin/configure_drupal_and_civi.sh