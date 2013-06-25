#!/usr/bin/perl
use strict;	# Enforce some good programming rules

my ( %FIRST_ORDER, %SECOND_ORDER, %THIRD_ORDER, %FOURTH_ORDER );
my ( %FIFTH_ORDER, %SIXTH_ORDER, %SEVENTH_ORDER, %EIGHTH_ORDER );
my ( $count, $total_count );

# get a basename for the database from the first argument
# if no arguments present, use a default
my $basename = "$ARGV[0]";
$basename =~ s/\..*$//;	# lop off everything from the last period on
if ( $basename eq undef ) {
	$basename = "default";
}

# we will use the following convention to describe first, second, etc. order databases
# basename_1, basename_2, basename_3, etc.
my $order1_basename = "$basename\_1";
my $order2_basename = "$basename\_2";
my $order3_basename = "$basename\_3";
my $order4_basename = "$basename\_4";
my $order5_basename = "$basename\_5";
my $order6_basename = "$basename\_6";
my $order7_basename = "$basename\_7";
my $order8_basename = "$basename\_8";

# open DBM file
dbmopen( %FIRST_ORDER, $order1_basename, undef )
	or die "Cannot create database $basename: $!";
dbmopen( %SECOND_ORDER, $order2_basename, undef )
	or die "Cannot create database $basename: $!";
dbmopen( %THIRD_ORDER, $order3_basename, undef )
	or die "Cannot create database $basename: $!";
dbmopen( %FOURTH_ORDER, $order4_basename, undef )
	or die "Cannot create database $basename: $!";
dbmopen( %FIFTH_ORDER, $order5_basename, undef )
	or die "Cannot create database $basename: $!";
dbmopen( %SIXTH_ORDER, $order6_basename, undef )
	or die "Cannot create database $basename: $!";
dbmopen( %SEVENTH_ORDER, $order7_basename, undef )
	or die "Cannot create database $basename: $!";
dbmopen( %EIGHTH_ORDER, $order8_basename, undef )
	or die "Cannot create database $basename: $!";

unless ( $ARGV[1] eq undef ) {
	open OUTPUT, ">$ARGV[1]"
		or die "Could not open output file\n";
	select OUTPUT;
}

# walk through each entry in the database and report on it
## I should search the print string and replace tabs, newlines with display characters
$count = 0;
$total_count = 0;
foreach my $key ( sort { "\L$a" cmp "\L$b" } keys %FIRST_ORDER ) {
	printf "%-5s = %5g\n", $key, $FIRST_ORDER{ $key };
	$count++;
	$total_count += $FIRST_ORDER{ $key };
}
printf "first-order analysis counted %g combinations.\n", $count;
printf "for a total of %g items.\n", $total_count;

$count = 0;
foreach my $key ( sort { "\L$a" cmp "\L$b" } keys %SECOND_ORDER ) {
	printf "%-5s = %5g\n", $key, $SECOND_ORDER{ $key };
	$count++;
	$total_count += $SECOND_ORDER{ $key };
}
printf "second-order analysis counted %g combinations.\n", $count;
printf "for a total of %g items.\n", $total_count;

$count = 0;
foreach my $key ( sort { "\L$a" cmp "\L$b" } keys %THIRD_ORDER ) {
	printf "%-5s = %5g\n", $key, $THIRD_ORDER{ $key };
	$count++;
	$total_count += $THIRD_ORDER{ $key };
}
printf "third-order analysis counted %g combinations.\n", $count;
printf "for a total of %g characters.\n", $total_count;

$count = 0;
foreach my $key ( sort { "\L$a" cmp "\L$b" } keys %FOURTH_ORDER ) {
	printf "%-5s = %5g\n", $key, $FOURTH_ORDER{ $key };
	$count++;
	$total_count += $FOURTH_ORDER{ $key };
}
printf "fourth-order analysis counted %g combinations.\n", $count;
printf "for a total of %g items.\n", $total_count;

$count = 0;
foreach my $key ( sort { "\L$a" cmp "\L$b" } keys %FIFTH_ORDER ) {
	printf "%-5s = %5g\n", $key, $FIFTH_ORDER{ $key };
	$count++;
	$total_count += $FIFTH_ORDER{ $key };
}
printf "fifth-order analysis counted %g combinations.\n", $count;
printf "for a total of %g items.\n", $total_count;

$count = 0;
foreach my $key ( sort { "\L$a" cmp "\L$b" } keys %SIXTH_ORDER ) {
	printf "%-5s = %5g\n", $key, $SIXTH_ORDER{ $key };
	$count++;
	$total_count += $SIXTH_ORDER{ $key };
}
printf "sixth-order analysis counted %g combinations.\n", $count;
printf "for a total of %g items.\n", $total_count;

$count = 0;
foreach my $key ( sort { "\L$a" cmp "\L$b" } keys %SEVENTH_ORDER ) {
	printf "%-5s = %5g\n", $key, $SEVENTH_ORDER{ $key };
	$count++;
	$total_count += $SEVENTH_ORDER{ $key };
}
printf "seventh-order analysis counted %g combinations.\n", $count;
printf "for a total of %g items.\n", $total_count;

$count = 0;
foreach my $key ( sort { "\L$a" cmp "\L$b" } keys %EIGHTH_ORDER ) {
	printf "%-5s = %5g\n", $key, $EIGHTH_ORDER{ $key };
	$count++;
	$total_count += $EIGHTH_ORDER{ $key };
}
printf "eighth-order analysis counted %g combinations.\n", $count;
printf "for a total of %g items.\n", $total_count;

# should I close the OUTPUT filehandle?

# close the DBM file
dbmclose( %FIRST_ORDER );
dbmclose( %SECOND_ORDER );
dbmclose( %THIRD_ORDER );
dbmclose( %FOURTH_ORDER );
dbmclose( %FIFTH_ORDER );
dbmclose( %SIXTH_ORDER );
dbmclose( %SEVENTH_ORDER );
dbmclose( %EIGHTH_ORDER );

select STDOUT;

print "Done!\n";
