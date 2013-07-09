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
# modified 2013-07-07
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
my $hash_count;
my ( $random_number, $random_character );
my $output_buffer = "";
my $done = 0;

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
if ( $length_param eq undef ) { $length_param = 1000; }


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



if ( $debug_param ) { print "DEBUG: Opening input file $input_param\n"; }
open( INPUT_FILE, "<", $input_param ) or die "Could not open input file $input_param\n";


### output

if ( $output_param ) {
	if ( $debug_param ) { print "DEBUG: generating output\n"; }
	
	# open output file
	open( OUTPUT_FILE, ">", $output_param ) or die "Can't open output file $output_param\n";
	if ( $debug_param ) { print "DEBUG: opening output file $output_param\n"; }
	
	if ( $debug_param ) { print "DEBUG: current order is $current_order\n"; }
		
# 	analyze_input( 1 );	# do first-order analysis
# 	$hash_count = sum_hash();			# get the number of items in the hash
# 	
# 	if ( $debug_param ) { print "DEBUG: hash count: $hash_count\n"; }
# 	
# 	# choose random number between 1 and total count
# 	$random_number = int( rand( $hash_count - 1 ) );
# 	if ( $debug_param ) { print "DEBUG: random number: $random_number\n"; }
# 	
# 	# step through the hash and pick out the resulting character
# 	# use the last character of the bit
# 	$random_character = substr( hash_index_value( $random_number ), -1, 1 );
# 	if ( $debug_param ) { print "DEBUG: random character is $random_character\n"; }
#	
#	$output_buffer .= $random_character;		# output to our output buffer
	
	$output_buffer .= get_random_character();

	push( @prev_chars, $random_character );		# push on @prev_chars array
	if ( $debug_param ) { print "DEBUG: prev_chars: " . join( '', @prev_chars ) . "\n"; }
	
	while ( ! $done ) {
		if ( $current_order < $order_param ) {
			$current_order++;
		}
		
		
		##### TEMPORARY - to avoid an infinite loop
		$done = 1;
		#####
	}
	
	
	## here's the logic:
	
	# we have two limits:
	#	the order we want to be at
	# 	the number of characters we want to generate
	# order goes from 1 .. order
	# each character we generate, we increment output character counter
	# 
	# we should make sure length > order
	# we step through order 1..order, get one character each step
	# then keep going at the target level until we hit our limit
	#
	# probably need to create a sub that selects the character
	# remember, for orders > 1, we need to find all hash keys that start with @prev_chars
	# the tricky thing is that the level 1 hash is different from level > 1
	
	
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
	
	
	# write output buffer to the output file
	print OUTPUT_FILE $output_buffer;
	
	# close output file
	close( OUTPUT_FILE );
	if ( $debug_param ) { print "DEBUG: closing output file $output_param\n"; }
} else {
	
	## analyze the input file
	if ( $debug_param ) { print "DEBUG: Starting analysis\n"; }
	analyze_input( $order_param );
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

}


if ( $debug_param ) { print "DEBUG: closing input file $input_param\n"; }
close( INPUT_FILE );


# get_random_character()
#
# do a level 1 analysis and pick a random character based on the overall distribution
#
sub get_random_character {
	analyze_input( 1 );			# do first-order analysis
	$hash_count = sum_hash();	# get the number of items in the hash
	
	# choose random number between 1 and total count
	$random_number = int( rand( $hash_count - 1 ) );
	if ( $debug_param ) { print "DEBUG: random number: $random_number\n"; }
	
	# step through the hash and pick out the resulting character
	# use the last character of the bit
	$random_character = substr( hash_index_value( $random_number ), -1, 1 );
	if ( $debug_param ) { print "DEBUG: random character is $random_character\n"; }
	
	return( $random_character );
}

sub get_order_characters {
	# OK
	# go through the analysis hash
	# compare the first order-1 characters of the key to @prev_chars
	# if it matches, move the key/value pair into another hash?
	# 	maybe make the key the just the last character
	# then sum that hash, grab a random number in the range of the sum
	# and pull the index from the intermediate hash and return the key
	# 
	# if the sum of the intermediate hash is 0
	# 	get_random_character()
	# 
	
	return;
}


sub sum_hash {
	my $total_count = 0;
	foreach my $key ( keys %analysis_hash ) { $total_count += $analysis_hash{ $key }; }
	return( $total_count );
}


sub hash_index_value {
	my $index = shift();
	my $count = 0;
	if ( $debug_param ) { print "DEBUG: hash_index_value() - looking for $index\n"; }
	foreach my $key ( keys %analysis_hash ) {
		$count += $analysis_hash{ $key };
		if ( $debug_param ) { print "DEBUG: hash_index_value() - count is $count\n"; }
		if ( $count > $index ) {
			if ( $debug_param ) {
				print "DEBUG: hash_index_value() - HIT!\n";
				print "DEBUG: hash_index_value() - return value is $key\n";
			}
			return( $key );
		}
	}
}


sub analyze_input {
	my $analyze_order = shift();
	if ( $analyze_order eq undef ) { return( 0 ); }
	
	if ( $debug_param ) { print "DEBUG: starting analysis ($analyze_order)\n"; }
	
	if ( $analyze_order != $current_order ) {
		seek( INPUT_FILE, 0, 0 );		# rewind the input file
		if ( $debug_param ) { print "DEBUG: rewinding input file\n"; }
		
		# clear out the current hash
		%analysis_hash = ();
		if ( $debug_param ) { print "DEBUG: clearing analysis hash\n"; }
		
		# go through the file and analyze it
		while( <INPUT_FILE> ) {
			$line = $_;
			$length = length( $line );
			
#			if ( $debug_param ) { print "DEBUG: input line: $line\n"; }
			
			for ( $count = 0; $count < length; $count++ ) {
				#grab the appropriate character from the data
				$char = substr( $line, $count, 1 );
				
				# add the character to our character array
				$array_length = push( @prev_chars, $char );
				
				# if we have more items after the push than we want,
				# shift the first item off the array
				while ( $array_length > $order_param ) {
					shift @prev_chars;
					$array_length--;
				}
				
				# make the @prev_chars array into a string and put it into $analysis_string
				$analysis_string = join( '', @prev_chars );
				
				# add a tick to the appropriate hash value
				$analysis_hash{ "$analysis_string" } += 1;
			}
		}
		$current_order = $analyze_order;
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
