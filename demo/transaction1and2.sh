#!/bin/bash

mysql -uroot <<EOF

create database if not exists demo;
use demo;

drop table if exists User;
create table User (
  id   INTEGER PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(32),
  age  INTEGER
);

insert into User (name, age) values ('しょう', 25);

EOF

mysql -uroot demo
