COMMAND='
CREATE DATABASE db;
USE db;

CREATE TABLE mytable 
( 
    id int, 
    name char(20)
);

LOAD DATA INFILE "/var/lib/mysql-files/mytable.csv" INTO TABLE mytable FIELDS TERMINATED BY "," IGNORE 1 LINES;'

mysql --user=root --password=root --execute="$COMMAND"