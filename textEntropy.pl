#!/usr/bin/perl

use strict;	# Enforce some good programming rules
use Getopt::Long;

#
# textEntropy.pl
#
# by Theron Trowbridge
# http://therontrowbridge.com
#
# version 0.11
#
# analyze the character frequency in a text file
# output a report of character combinations/counts
# generate text output randomized with the same entropy
#
# based on disparate scripts (analyze.pl, generate.pl, report.pl)
# combining functionality into a single script
# with optional modes of operation
#
# created 2017-01-22
# modified 2017-01-27
#
# original script last modified 2013-07-07
# created some unknown time before that (it's old)
# 

my ( $input_param, $output_param, $order_param, $length_param, $report_param );
my ( $version_param, $help_param, $debug_param );
my ( $line, $length, $char, $array_length, $analysis_string );
my ( $key, $key_string, $key_ord, $value );
my $count = 0;
my $total_count = 0;
my $output_count = 0;

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
	print "textEntropy.pl\n";
	print "version 0.11\n";
	print "parameters:\n";
	print "\t--input | -i <input_file>\n";
	print "\t\trequried\n";
	print "\t--output | -o <output_file>\n";
	print "\t\toptional, if not specified, no output will be generated\n";
	print "\t--order <order>\n";
	print "\t\tnumber of analysis orders (default is 1)\n";
	print "\t--length <output_length>\n";
	print "\t\tdesired output length (default is 1000)\n";
	print "\t--[no]report\n";
	print "\t\toutput analysis report\n";
	print "\t--help | -?\n";
	print "\t\tdisplay this message\n";
	print "\t--version | -v\n";
	print "\t\tdisplay version\n";
	print "\t--debug\n";
	print "\t\tdisplay debug messages (default off)\n";
	exit;
}

if ( $version_param ) {
	print "textEntropy.pl version 0.11\n";
	exit;
}

# error checking

# input file is required
if ( $input_param eq undef ) {
	$input_param = @ARGV[0];
	if ( $input_param eq undef ) { die "Please specify an input file\n"; }
}

# set parameter defaults
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


## analyze the input file
if ( $debug_param ) { print "DEBUG: Starting analysis\n"; }
analyze_input( $order_param );
if ( $debug_param ) { print "DEBUG: analysis done\n\n"; }


## if a report is requested, output the analysis
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



###
### if --output we go through the process of randomizing
### 	do a 1st order analysis
###		select a random character from the 1st order analysis
### 	add to our output
### 	do a 2nd order analysis
### 	go through the 2nd order hash (if requested order > 1)
### 		do a second hash of entries whose first character matches the last character of our output 
### 		randomize amongst those
### 		add the last character of selected to our output
### 	go through the 3rd order hash (if requested order > 2)
### 		do a second hash of entries whose first two characters match the last two characters of our output
### 		randomize amongst those
### 		add the last character of selected to our output
### 	and so on, up to the specified order
### 	then repeat until we reach desired output length
### 	if at any point we don't find any matches, go back to 1st order
### 



## output

if ( $output_param ) {
	if ( $debug_param ) { print "DEBUG: generating output\n"; }
	
	# open output file
	open( OUTPUT_FILE, ">", $output_param ) or die "Can't open output file $output_param\n";
	if ( $debug_param ) { print "DEBUG: opening output file $output_param\n"; }
	
	if ( $debug_param ) { print "DEBUG: current order is $current_order\n"; }
	
	# get a random character from a first order analysis
	$output_buffer .= get_random_character();
	
	if ( $debug_param ) { print "DEBUG: random character: $output_buffer\n"; }
	
	## OK
	## we have one character now
	## if our order is 1, do get_random_character() a bunch of times
	## if our order is 2 or higher
	## 	for i = 2 > order
	## 		do order i analysis
	## 		count number of items whose first i-2 characters match last i-2 characters of output
	## 			maybe make another hash of these
	## 		randomly choose among these
	## 		add last character of choice to output hash
	
#	$current_order = 1;
#	analyze_input( $current_order );		# do a first-order analysis
#	$hash_count = sum_hash();			# get the number of items in the hash
	
	# choose
		
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
}


if ( $debug_param ) { print "DEBUG: closing input file $input_param\n"; }
close( INPUT_FILE );


# get_random_character()
#
# do a level 1 analysis and pick a random character based on the overall distribution
#
sub get_random_character {
	my $ptr = 0;
	my $found = 0;

	if ( $debug_param ) { print "DEBUG: get_random_character()\n"; }
	
	analyze_input( 1 );			# do first-order analysis
	$hash_count = sum_hash();	# get the number of items in the hash
	
	# choose random number between 1 and total count
	$random_number = int( rand( $hash_count - 1 ) );
	if ( $debug_param ) { print "DEBUG: random number: $random_number\n"; }
	
	# step through the hash and add up the counts until we hit or exceed the random number
	# return the character
	
	foreach my $key ( keys %analysis_hash ) {
		
		if ( $debug_param ) { print "DEBUG: analysis key: $key\n"; }
		
		$ptr += $analysis_hash{ $key };
		
		if ( $debug_param ) { print "DEBUG: analysis value: ". $analysis_hash{ $key } . "\n"; }
		
		if ( $debug_param ) { print "DEBUG: analysis ptr: $ptr\n"; }
		
		if ( $ptr >= $random_number ) {
			if ( !$found ) {
				if ( $debug_param ) { print "DEBUG: found our number!\n"; }
				$random_character = $key;
				$found = 1;
			}
		}
	}
	
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
		# reads file one line at a time
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
