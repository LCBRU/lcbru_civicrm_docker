CREATE USER 'civicrm_user'@'%' IDENTIFIED BY 'Nipon';

GRANT ALL PRIVILEGES ON *.* TO 'civicrm_user'@'%' IDENTIFIED BY 'Nipon' WITH GRANT OPTION;

FLUSH PRIVILEGES;

SET PASSWORD FOR 'civicrm_user'@'%' = PASSWORD('Nipon');