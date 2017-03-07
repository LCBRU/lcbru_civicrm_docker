CREATE DATABASE civicrm;

GRANT ALL PRIVILEGES ON civicrm.* TO 'civicrm_user'@'%' WITH GRANT OPTION;
GRANT SELECT, PROCESS ON *.* TO 'civicrm_user'@'%';
