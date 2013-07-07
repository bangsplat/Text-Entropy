#!/usr/bin/perl
use strict;

my %my_hash;

# load some values into the hash

print "size of hash: " . keys( %my_hash ) . "\n";

$my_hash{ 1 } = "foo";
$my_hash{ 2 } = "foo";
$my_hash{ 1 } = "blah";

print "size of hash: " . keys( %my_hash ) . "\n";

%my_hash = ();

print "size of hash: " . keys( %my_hash ) . "\n";
