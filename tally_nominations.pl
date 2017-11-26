#!/usr/bin/perl

use strict;
use v5.10;
use warnings;
use DBI;
use Data::Dumper;

my $dbh = DBI->connect('dbi:Pg:dbname=voting','voting_user','');

my $sth = $dbh->prepare('select id,name from campaign where active = true order by genesis desc');
$sth->execute();
my $campaigns = $sth->fetchall_arrayref({});

say 'Current campaigns. Pick one';
my $index = 0;
foreach my $row (@{$campaigns}){
	say "($index)" . $row->{'name'};
}
print 'Choice: ';
my $selected_campaign = <STDIN>;
chomp($selected_campaign);
$sth = $dbh->prepare('select n.name,o.name as office_name, count(n.name) as votes from nominations n join offices o on n.office = o.id where n.campaign = ? group by n.name,office_name');
$sth->execute($campaigns->[$selected_campaign]->{'id'});
my $totals = $sth->fetchall_hashref('office_name');

print Dumper $totals;