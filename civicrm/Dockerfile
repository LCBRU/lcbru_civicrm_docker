FROM php:5-apache
MAINTAINER Richard Bramley <rabramley@gmail.com>

# install the PHP extensions we need
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y libpng12-dev libjpeg-dev libpq-dev mysql-client vim wget zip cron supervisor ssmtp
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr
RUN docker-php-ext-install gd
RUN docker-php-ext-install mbstring pdo pdo_mysql pdo_pgsql zip mysql mysqli sockets

# supervisord config file
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Needed for pdo_dblib install because otherwise it doesn't find it
RUN apt-get install -y freetds-dev
RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/
RUN docker-php-ext-install pdo_dblib

RUN rm -rf /var/lib/apt/lists/*

RUN php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush
RUN php drush core-status
RUN chmod +x drush
RUN mv drush /usr/local/bin

RUN drush init -y

ADD civicrm-4.7.17-drupal.tar.gz /civicrm
ADD info.php /
ADD dblib_driver_for_sql_server /dblib_driver_for_sql_server

#RUN sed -i.bak 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php5/apache2/php.ini
#RUN sed -i.bak 's/memory_limit = 128M/memory_limit = 1024M/g' /etc/php5/apache2/php.ini

# Install script to run at start up
COPY bin /usr/local/bin

WORKDIR /var/www/
RUN rm -fR html

# Download Drupal
RUN drush dl drupal-7.54
RUN mv drupal-7.54 html

WORKDIR /var/www/html

# Copy CiviCRM into place
RUN ln -s /civicrm/civicrm /var/www/html/sites/all/modules/

# Install Drupal modules
RUN drush dl ctools datatables devel views -y

## The datatables module needs you to download the JQuery
## plugin separately
RUN wget http://datatables.net/releases/DataTables-1.9.3.zip
RUN unzip DataTables-1.9.3.zip
RUN mv DataTables-1.9.3 sites/all/modules/datatables/dataTables
RUN rm DataTables-1.9.3.zip

RUN cp -r /dblib_driver_for_sql_server /var/www/html/sites/all/modules/
RUN ln -s /var/www/html/sites/all/modules/dblib_driver_for_sql_server/dblib /var/www/html/includes/database/

# Give apache access to the files
RUN chown -R www-data:www-data sites
RUN chown -R www-data:www-data /civicrm
RUN chown -R www-data:www-data /var/www/html/sites/all/modules/dblib_driver_for_sql_server/
RUN chown -R www-data:www-data /var/www/html/includes/database/dblib

CMD /usr/local/bin/configure_drupal_and_civi.sh