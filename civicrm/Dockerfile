FROM php:5-apache
MAINTAINER Richard Bramley <rabramley@gmail.com>

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev mysql-client vim \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql zip mysql

RUN php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush
RUN php drush core-status
RUN chmod +x drush
RUN mv drush /usr/local/bin

RUN drush init -y

ADD civicrm-4.6.26-drupal.tar.gz /civicrm
ADD info.php /

# Install script to run at start up
COPY bin /usr/local/bin
CMD /usr/local/bin/install_drupal_modules.sh