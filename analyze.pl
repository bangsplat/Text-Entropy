#!/usr/bin/perl

use strict;	# Enforce some good programming rules
use Getopt::Long;

#
# analyze.pl
#
# analyze character frequency in a text file
# optionally report the combinations
#
# created ???? (it's old)
# modified 2013-07-05
#

my ( $input_param, $output_param, $order_param, $length_param, $report_param );
my ( $version_param, $help_param, $debug_param );
my ( $line, $length, $char, $array_length, $analysis_string );
my ( $key, $key_string, $key_ord, $value );
my $count = 0;
my $total_count = 0;

my @prev_chars;
my %analysis_hash;
my $current_order = 0;

GetOptions( 'input|i=s'		=>	\$input_param,
			'output|o=s'	=>	\$output_param,
			'order=i'		=>	\$order_param,
			'length=i'		=>	\$length_param,
			'report!'		=>	\$report_param,
			'help|?'		=>	\$help_param,
			'version|v'		=>	\$version_param,
			'debug!'		=>	\$debug_param );

if ( $debug_param ) {
	print "DEBUG: Passed parameters:\n";
	print "\$input_param: $input_param\n";
	print "\$output_param: $output_param\n";
	print "\$order_param: $order_param\n";
	print "\$length_param: $length_param\n";
	print "\$report_param: $report_param\n";
	print "\$help_param: $help_param\n";
	print "\$version_param: $version_param\n";
	print "\$debug_param: $debug_param\n";
	print "\n";
}

if ( $help_param ) {
	print "HELP!\n";
}

if ( $version_param ) {
	print "VERSION\n";
}

if ( $input_param eq undef ) {
	$input_param = @ARGV[0];
	if ( $input_param eq undef ) { die "Please specify an input file\n"; }
}

if ( $order_param eq undef ) { $order_param = 1; }


if ( $debug_param ) {
	print "DEBUG: Adjusted parameters:\n";
	print "\$input_param: $input_param\n";
	print "\$output_param: $output_param\n";
	print "\$order_param: $order_param\n";
	print "\$length_param: $length_param\n";
	print "\$report_param: $report_param\n";
	print "\$help_param: $help_param\n";
	print "\$version_param: $version_param\n";
	print "\$debug_param: $debug_param\n";
	print "\n";
}



## analyze the input file

##### make this into a subroutine
##### that first clears out the global analysis hash
##### and then fills it
##### maybe returns the total count

if ( $debug_param ) { print "DEBUG: Starting analysis\n"; }

if ( $debug_param ) { print "DEBUG: Opening input file $input_param\n"; }
open( INPUT_FILE, "<", $input_param );

while( <INPUT_FILE> ) {
	$line = $_;
	$length = length( $line );
	
	for ( $count = 0; $count < $length; $count++ ) {
		#grab the appropriate character from the data
		$char = substr( $line, $count, 1 );
		
		# add the character to our character array
		$array_length = push( @prev_chars, $char );
		
		# if we have more items after the push than we want,
		# shift the first item off the array
		if ( $array_length > $order_param ) {
			shift @prev_chars;
			$array_length--;
		}
		
		$analysis_string = join( '', @prev_chars );
		
		# add a tick to the appropriate hash value
		$analysis_hash{ "$analysis_string" } += 1;
	}
}

if ( $debug_param ) { print "DEBUG: analysis done\n\n"; }



### report on the findings

if ( $report_param ) {

	if ( $debug_param ) { print "DEBUG: output report\n"; }

	$count = 0;
	$total_count = 0;
	foreach my $key ( sort { "\L$a" cmp "\L$b" } keys %analysis_hash ) {
		my $key_string = $key;
		$key_string =~ s/ /{sp}/g;
		$key_string =~ s/[\n\r]/{br}/g;
		$key_ord = ord( $key );
	
		$value = $analysis_hash{ $key };
	
		printf "%-12s = %8g\n", $key_string, $value;
		
		$count++;
		$total_count += $analysis_hash{ $key };
	}

	print "$order_param order analysis counted $count combinations\n";
	print "for a total of $total_count items\n";

}


### output

if ( $output_param ) {
	if ( $debug_param ) { print "DEBUG: generating output\n"; }
	
	# open output file
	
	# do first-order analysis
	# choose random number between 1 and total count
	# step through the hash and pick out the resulting character
	# output to our output buffer
	# push on @prev_chars array
	
	# for i = 1..order-1
	# do order i analysis
	# step through hash and look for entries
	# 	that match the first i characters of @prev_chars
	# add up the number of hits from each
	# choose random number in that range
	# choose appropriate character
	# output to our output buffer
	# push on @prev_chars array
	
	# when we get to our requested order
	# do order analysis
	# step through hash (as above)

	# if we don't have a match, reset back to order 1 and start over
	
	# if length of output file is less than $length_param, repeat
	
	# close output file
}


if ( $debug_param ) { print "DEBUG: closing input file $input_param\n"; }
close( INPUT_FILE );



sub analyze_input {
	my $analyze_order = shift();
	if ( $analyze_order eq undef ) { return( 0 ); }
	
	# global variables to use
	#	 INPUT_FILE
	#	 $current_order
	#	 %analysis_hash
	
	
	if ( $analysis_order != $current_order ) {
	
	}
	# otherwise, we're good, no analysis needed
}



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
