#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use DBI;


# 空のテーブル準備
my $dbh = DBI->connect('dbi:mysql:demo:localhost', 'root', '', { mysql_enable_utf8 => 1 });
$dbh->do('drop table if exists T1');
$dbh->do('create table T1 (a INTEGER)');


# 明示的にトランザクションを張りつつテーブルに200行挿入していく
$dbh->do('begin');
for (my $i = 0; $i < 200; ++$i) {
    $dbh->do('insert into T1 values(777)');  # トランザクションが1回 => 速い
}
$dbh->do('commit');


# 挿入した行数表示
my $n = $dbh->selectall_arrayref('select count(*) from T1')->[0][0];
print "Inserted $n records\n";
