#!/usr/bin/perl
use strict;	# Enforce some good programming rules

#
# analyze.pl
#
# analyze character frequency in a text file
# generate dbm files to store the analysis
#
# created ???? (it's old)
# modified 2013-07-03
#

my %analysis_hash;
my ( $line, $length, $char, $array_length, $analysis_string );
my $count = 0;
my $total_count = 0;
my $order = 1;
my @prev_chars;

my $filename = @ARGV[0];
my $basename = $filename;
$basename =~ s/\..*$//;

if ( $basename eq undef ) { die "Please specify a text file\n"; }

open( INPUT_FILE, "<", $filename );

while( <INPUT_FILE> ) {
	$line = $_;
	$length = length( $line );
	
	for ( $count = 0; $count < $length; $count++ ) {
		#grab the appropriate character from the data
		$char = substr( $line, $count, 1 );
		
		# add the character to our character array
		$array_length = push( @prev_chars, $char );
		
		# if we have nine items after the push, forget nine characters ago
		if ( $array_length > $order ) {
			shift @prev_chars;
			$array_length--;
		}
		
		$analysis_string = join( '', @prev_chars );
		
		# do the first order analysis
		$analysis_hash{ "$analysis_string" } += 1;
	}
}



my $key;

$count = 0;
$total_count = 0;
foreach my $key ( sort { "\L$a" cmp "\L$b" } keys %analysis_hash ) {
	printf "%-5s = %5g\n", $key, $analysis_hash{ $key };
	$count++;
	$total_count += $analysis_hash{ $key };
}
printf "first-order analysis counted %g combinations.\n", $count;
printf "for a total of %g items.\n", $total_count;





exit();


my ( %FIRST_ORDER, %SECOND_ORDER, %THIRD_ORDER, %FOURTH_ORDER );
my ( %FIFTH_ORDER, %SIXTH_ORDER, %SEVENTH_ORDER, %EIGHTH_ORDER );
my ( $line, $length, $char, $array_length, $analysis_string );
my $count = 0;
my @prev_chars;

# get a basename for the database from the first argument
# if no arguments present, prompt for input and quit
my $basename = "$ARGV[0]";
$basename =~ s/\..*$//;	# lop off everything from the last period on
if ( $basename eq undef ) { die "Please specify a text file\n"; }

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

# check to see if there are any DBM files present with that basename
# on Windows, these are <basename>.dir and <basename>.pag
# I'm using the first-order database, which might not quite be accurate
# but it should do.
if ( -e "$order1_basename.pag" ) {
	print "Database \"$basename\" already exists, overwrite? (yes/no) ";
	chomp ( my $confirm = <STDIN> );
	die "Terminating analysis.\n"
		unless ( $confirm =~ /yes|y/i );
}

# create DBM files
dbmopen( %FIRST_ORDER, $order1_basename, 0644 )
	or die "Cannot create database $basename: $!";
dbmopen( %SECOND_ORDER, $order2_basename, 0644 )
	or die "Cannot create database $basename: $!";
dbmopen( %THIRD_ORDER, $order3_basename, 0644 )
	or die "Cannot create database $basename: $!";
dbmopen( %FOURTH_ORDER, $order4_basename, 0644 )
	or die "Cannot create database $basename: $!";
dbmopen( %FIFTH_ORDER, $order5_basename, 0644 )
	or die "Cannot create database $basename: $!";
dbmopen( %SIXTH_ORDER, $order6_basename, 0644 )
	or die "Cannot create database $basename: $!";
dbmopen( %SEVENTH_ORDER, $order7_basename, 0644 )
	or die "Cannot create database $basename: $!";
dbmopen( %EIGHTH_ORDER, $order8_basename, 0644 )
	or die "Cannot create database $basename: $!";

# empty out the databases
%FIRST_ORDER = ();
%SECOND_ORDER = ();
%THIRD_ORDER = ();
%FOURTH_ORDER = ();
%FIFTH_ORDER = ();
%SIXTH_ORDER = ();
%SEVENTH_ORDER = ();
%EIGHTH_ORDER = ();

# walk through each line of the input and build database
while ( <> ) {	## should probably properly open the file and be all explicit
	##
	## lets' try an experiment
	##
#	chomp();
	##
	$line = $_; # put the line into a more convenient variable
	$length = length $line;
	for ( $count = 0; $count < $length; $count++ ) {
		#grab the appropriate character from the data
		$char = substr( $line, $count, 1 );
		
		# add the character to our character array
		$array_length = push @prev_chars, $char;
		
		# if we have nine items after the push, forget nine characters ago
		if ( $array_length > 8 ) {
			shift @prev_chars;
			$array_length--;
		}
		
		$analysis_string = $char;
		
		# do the first order analysis
		$FIRST_ORDER{ "$analysis_string" } += 1;
		
		# do the second-order analysis
		if ( $array_length > 1 ) {
			$analysis_string = $prev_chars[$array_length - 2] . "$analysis_string";
			$SECOND_ORDER{ $analysis_string } += 1;
		}
		
		# do the third-order analysis
		if ( $array_length > 2 ) {
			$analysis_string = $prev_chars[$array_length - 3] . $analysis_string;
			$THIRD_ORDER{ $analysis_string } += 1;
		}
		
		# do the fourth-order analysis
		if ( $array_length > 3 ) {
			$analysis_string = $prev_chars[$array_length - 4] . $analysis_string;
			$FOURTH_ORDER{ $analysis_string } += 1;
		}
		
		# do the fifth-order analysis
		if ( $array_length > 4 ) {
			$analysis_string = $prev_chars[$array_length - 5] . $analysis_string;
			$FIFTH_ORDER{ $analysis_string } += 1;
		}
		
		# do the sixth-order analysis
		if ( $array_length > 5 ) {
			$analysis_string = $prev_chars[$array_length - 6] . $analysis_string;
			$SIXTH_ORDER{ $analysis_string } += 1;
		}
		
		# do the seventh-order analysis
		if ( $array_length > 6 ) {
			$analysis_string = $prev_chars[$array_length - 7] . $analysis_string;
			$SEVENTH_ORDER{ $analysis_string } += 1;
		}

		# do the eighth-order analysis
		if ( $array_length > 7 ) {
			$analysis_string = $prev_chars[$array_length - 8] . $analysis_string;
			$EIGHTH_ORDER{ $analysis_string } += 1;
		}
	}
}

dbmclose( %FIRST_ORDER );
dbmclose( %SECOND_ORDER );
dbmclose( %THIRD_ORDER );
dbmclose( %FOURTH_ORDER );
dbmclose( %FIFTH_ORDER );
dbmclose( %SIXTH_ORDER );
dbmclose( %SEVENTH_ORDER );
dbmclose( %EIGHTH_ORDER );

print "Done!\n";
