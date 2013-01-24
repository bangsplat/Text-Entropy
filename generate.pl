#!perl
use strict;	# Enforce some good programming rules

# randomly generate text that has the same frequency
# characteristics as indicated in the database
# arguments:
# 	output length (required?  if missing, use some default value, like 1000?)
# 	database name (if missing, try "default")
# 	number of orders to process (if missing, figure out how many exist and use that)
#	output name (if missing, use standard output)
# if there is just one argument, and it is "help" or "h", display syntax message

# variables
my ( %FIRST_ORDER, %SECOND_ORDER, %THIRD_ORDER, %FOURTH_ORDER );
my ( %FIFTH_ORDER, %SIXTH_ORDER, %SEVENTH_ORDER, %EIGHTH_ORDER, %temp_hash );
#my ( $first_order_count, $second_order_count, $third_order_count, $fourth_order_count );
my ( $i, $key );
my @prev_chars;

# subroutines

sub count_total {
	my $hash_ref = $_[0];
	my $hash_total = 0;
	foreach my $hash_key ( keys %$hash_ref ) {
		$hash_total += $$hash_ref{ $hash_key };
	}
	return $hash_total;
}

sub random_element {
	my $hash_ref = $_[0];
	my $hash_total = &count_total( $hash_ref );

	# generate random number between 1 and hash total	
	my $hash_rand = int( 1 + rand( $hash_total ) );
	
	# step through the hash and find the appropriate value
	my $hash_count = 0;
	foreach my $hash_key ( keys %$hash_ref ) {
		$hash_count += $$hash_ref{ $hash_key };
		if ( $hash_count >= $hash_rand ) {
			return substr( $hash_key, -1 ,1 );
		}
	}
	
	# there is always a chance that we will hit a combination
	# for which no hash entry will be found
	# in this event, we have to return something or get stuck in a loop
	# so we revert to a first-order lookup - completely random
	# but we run the risk that we will choose something that will create
	# a combination that will not have an entry, either
	# but I see no easy way out of this
	# ideally, we should follow up with a second order search, etc
	# but I can't figure out how to make that happen easily
	# so we go with this, and hope we hit upon a combination that works
	# however, the more complex the source, the less likely this is to be a problem

	# recursively call ourselves again and choose a new first-order choice
#
#	warn "random_element failed, reverting to first-order search.\n";
#
	return random_element( \%FIRST_ORDER );
}

# main

# grab the first argument
# take "help" or "h" or "?" or empty to be a help request
# otherwise take it to be output length
my $output_length = "$ARGV[0]";
if ( $output_length =~ /^help$|^h$|^\?$|^$/i ) {
	print "generate.pl <out_length> [<database> <orders> <output_file>]\n";
	exit 0;
}

# grab the second argument (database basename)
my $basename = "$ARGV[1]";
$basename = "default"
	if ( $basename =~ /^$/ );

# grab the third argument (number of orders to process)
my $num_orders = $ARGV[2];

# figure out if the appropriate database files exist
my $testfile = $basename . "_" . $num_orders . ".pag";
die "Could not open database file $basename.\n"
	unless ( -e $testfile );

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

# open the first order DBM file
dbmopen( %FIRST_ORDER, $order1_basename, undef )
	or die "Cannot open database $basename: $!\n";
# open the second order DBM file if necessary
if ( $num_orders > 1 ) {
	dbmopen( %SECOND_ORDER, $order2_basename, undef )
		or die "Cannot open database $basename: $!\n";
}
# open the third order DBM file if necessary
if ( $num_orders > 2 ) {
	dbmopen( %THIRD_ORDER, $order3_basename, undef )
		or die "Cannot open database $basename: $!\n";
}
# open the fourth order DBM file if necessary
if ( $num_orders > 3 ) {
	dbmopen( %FOURTH_ORDER, $order4_basename, undef )
		or die "Cannot open database $basename: $!\n";
}
# open the fifth order DBM file if necessary
if ( $num_orders > 4 ) {
	dbmopen( %FIFTH_ORDER, $order5_basename, undef )
		or die "Cannot open database $basename: $!\n";
}
# open the sixth order DBM file if necessary
if ( $num_orders > 5 ) {
	dbmopen( %SIXTH_ORDER, $order6_basename, undef )
		or die "Cannot open database $basename: $!\n";
}
# open the seventh order DBM file if necessary
if ( $num_orders > 6 ) {
	dbmopen( %SEVENTH_ORDER, $order7_basename, undef )
		or die "Cannot open database $basename: $!\n";
}
if ( $num_orders > 7 ) {
	dbmopen( %EIGHTH_ORDER, $order8_basename, undef )
		or die "Cannot open database $basename: $!\n";
}

# grab the fourth argument (output filename)
# if undefined, output to standard out
unless ( $ARGV[3] eq undef ) {
	open OUTPUT, ">$ARGV[3]"
		or die "Could not open output file\n";
	select OUTPUT;
}

# we are all ready to go!

# in each case, we will develop a hash of possible candidates,
# count the number of values in each element of the hash,
# generate a random number between 1 and that number,
# step through the hash, adding the values until the running sum is higher than total
# the element which matches or betters it is the winner

@prev_chars = (); # empty out our array of peviously-used characters

if ( $num_orders == 1 ) {	# first-order generation
	# loop for all characters of output
	for ( $i = 0; $i < $output_length; $i++ ) {
		print random_element( \%FIRST_ORDER );
	}
} elsif ( $num_orders == 2 ) {	# second-order generation
	# first character must be a first-order choice
	push @prev_chars, random_element( \%FIRST_ORDER );
	print $prev_chars[0];

	# loop for remaining characters, perform second-order lookup for each
	for ( $i = 1; $i < $output_length; $i++ ) {
		%temp_hash = ();
		# go through second-order database and pull every first-character match
		# into another hash, then do the same thing as a first-order choice on that
		foreach $key ( keys %SECOND_ORDER ) {
			$temp_hash{ $key } = $SECOND_ORDER{ $key }
				if substr( $key, 0, 1 ) eq $prev_chars[0];
		}

		# use the last character from the selected key
		push @prev_chars, random_element( \%temp_hash );
		shift @prev_chars;
		print $prev_chars[0];
	}
} elsif ( $num_orders == 3 ) {
	# first character must be a first-order choice
	push @prev_chars, random_element( \%FIRST_ORDER );
	print $prev_chars[0];
	# second character must be a second-order choice
	%temp_hash = ();
	foreach $key ( keys %SECOND_ORDER ) {
		$temp_hash{ $key } = $SECOND_ORDER{ $key }
			if substr( $key, 0, 1 ) eq $prev_chars[0];
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[1];
	# now we may do a series of third-order lookups
	for ( $i = 0; $i < $output_length; $i++ ) {
		%temp_hash = (); # empty out our temporary hash
		foreach $key ( keys %THIRD_ORDER ) {
			$temp_hash{ $key } = $THIRD_ORDER{ $key }
				if substr( $key, 0, 2 ) eq ( substr( join( "", @prev_chars ), 0, 2 ) );
		}
		push @prev_chars, random_element( \%temp_hash );
		shift @prev_chars;
		print $prev_chars[1];
	}
} elsif ( $num_orders == 4 ) {
	# first character must be a first-order choice
	push @prev_chars, random_element( \%FIRST_ORDER );
	print $prev_chars[0];
	# second character must be a second-order choice
	%temp_hash = ();
	foreach $key ( keys %SECOND_ORDER ) {
		$temp_hash{ $key } = $SECOND_ORDER{ $key }
			if substr( $key, 0, 1 ) eq $prev_chars[0];
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[1];
	# third character must be a third-order choice
	%temp_hash = ();
	foreach $key ( keys %THIRD_ORDER ) {
		$temp_hash{ $key } = $THIRD_ORDER{ $key }
			if substr( $key, 0, 2 ) eq ( substr( join( "", @prev_chars ), 0, 2 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[2];
	# now we may do a series of fourth-order choices
	for ( $i = 0; $i < $output_length; $i++ ) {
		%temp_hash = (); # empty out our temporary hash
		foreach $key ( keys %FOURTH_ORDER ) {
			$temp_hash{ $key } = $FOURTH_ORDER{ $key }
				if substr( $key, 0, 3 ) eq ( substr( join( "", @prev_chars ), 0, 3 ) );
		}
		push @prev_chars, random_element( \%temp_hash );
		shift @prev_chars;
		print $prev_chars[2];
	}
} elsif ( $num_orders == 5 ) {
	# first character must be a first-order choice
	push @prev_chars, random_element( \%FIRST_ORDER );
	print $prev_chars[0];
	# second character must be a second-order choice
	%temp_hash = ();
	foreach $key ( keys %SECOND_ORDER ) {
		$temp_hash{ $key } = $SECOND_ORDER{ $key }
			if substr( $key, 0, 1 ) eq $prev_chars[0];
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[1];
	# third character must be a third-order choice
	%temp_hash = ();
	foreach $key ( keys %THIRD_ORDER ) {
		$temp_hash{ $key } = $THIRD_ORDER{ $key }
			if substr( $key, 0, 2 ) eq ( substr( join( "", @prev_chars ), 0, 2 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[2];
	# fourth character must be a fourth-order choice
	%temp_hash = ();
	foreach $key ( keys %FOURTH_ORDER ) {
		$temp_hash{ $key } = $FOURTH_ORDER{ $key }
			if substr( $key, 0, 3 ) eq ( substr( join( "", @prev_chars ), 0, 3 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[3];
	# now we may do a series of fifth-order choices
	for ( $i = 0; $i < $output_length; $i++ ) {
		%temp_hash = ();
		foreach $key ( keys %FIFTH_ORDER ) {
			$temp_hash{ $key } = $FIFTH_ORDER{ $key }
				if substr( $key, 0, 4 ) eq ( substr( join( "", @prev_chars ), 0, 4 ) );
		}
		push @prev_chars, random_element( \%temp_hash );
		shift @prev_chars;
		print $prev_chars[3];
	}
} elsif ( $num_orders == 6 ) {
	# first character must be a first-order choice
	push @prev_chars, random_element( \%FIRST_ORDER );
	print $prev_chars[0];
	# second character must be a second-order choice
	%temp_hash = ();
	foreach $key ( keys %SECOND_ORDER ) {
		$temp_hash{ $key } = $SECOND_ORDER{ $key }
			if substr( $key, 0, 1 ) eq $prev_chars[0];
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[1];
	# third character must be a third-order choice
	%temp_hash = ();
	foreach $key ( keys %THIRD_ORDER ) {
		$temp_hash{ $key } = $THIRD_ORDER{ $key }
			if substr( $key, 0, 2 ) eq ( substr( join( "", @prev_chars ), 0, 2 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[2];
	# fourth character must be a fourth-order choice
	%temp_hash = ();
	foreach $key ( keys %FOURTH_ORDER ) {
		$temp_hash{ $key } = $FOURTH_ORDER{ $key }
			if substr( $key, 0, 3 ) eq ( substr( join( "", @prev_chars ), 0, 3 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[3];
	# fifth character must be fifth-order choice
	%temp_hash = ();
	foreach $key ( keys %FIFTH_ORDER ) {
		$temp_hash{ $key } = $FIFTH_ORDER{ $key }
			if substr( $key, 0, 4 ) eq ( substr( join( "", @prev_chars ), 0, 4 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[4];
	# now we may do a series of sixth-order choices
	for ( $i = 0; $i < $output_length; $i++ ) {
		%temp_hash = ();
		foreach $key ( keys %SIXTH_ORDER ) {
			$temp_hash{ $key } = $SIXTH_ORDER{ $key }
				if substr( $key, 0, 5 ) eq ( substr( join( "", @prev_chars ), 0, 5 ) );
		}
		push @prev_chars, random_element( \%temp_hash );
		shift @prev_chars;
		print $prev_chars[4];
	}
} elsif ( $num_orders == 7 ) {
	# first character must be a first-order choice
	push @prev_chars, random_element( \%FIRST_ORDER );
	print $prev_chars[0];
	# second character must be a second-order choice
	%temp_hash = ();
	foreach $key ( keys %SECOND_ORDER ) {
		$temp_hash{ $key } = $SECOND_ORDER{ $key }
			if substr( $key, 0, 1 ) eq $prev_chars[0];
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[1];
	# third character must be a third-order choice
	%temp_hash = ();
	foreach $key ( keys %THIRD_ORDER ) {
		$temp_hash{ $key } = $THIRD_ORDER{ $key }
			if substr( $key, 0, 2 ) eq ( substr( join( "", @prev_chars ), 0, 2 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[2];
	# fourth character must be a fourth-order choice
	%temp_hash = ();
	foreach $key ( keys %FOURTH_ORDER ) {
		$temp_hash{ $key } = $FOURTH_ORDER{ $key }
			if substr( $key, 0, 3 ) eq ( substr( join( "", @prev_chars ), 0, 3 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[3];
	# fifth character must be fifth-order choice
	%temp_hash = ();
	foreach $key ( keys %FIFTH_ORDER ) {
		$temp_hash{ $key } = $FIFTH_ORDER{ $key }
			if substr( $key, 0, 4 ) eq ( substr( join( "", @prev_chars ), 0, 4 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[4];
	#sixth character must be a sixth-order choice
	%temp_hash = ();
	foreach $key ( keys %SIXTH_ORDER ) {
		$temp_hash{ $key } = $SIXTH_ORDER{ $key }
			if substr( $key, 0, 5 ) eq ( substr( join( "", @prev_chars ), 0, 5 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[5];
	# now we may do a series of seventh-order choices
	for ( $i = 0; $i < $output_length; $i++ ) {
		%temp_hash = ();
		foreach $key ( keys %SEVENTH_ORDER ) {
			$temp_hash{ $key } = $SEVENTH_ORDER{ $key }
				if substr( $key, 0, 6 ) eq ( substr( join( "", @prev_chars ), 0, 6 ) );
		}
		push @prev_chars, random_element( \%temp_hash );
		shift @prev_chars;
		print $prev_chars[5];
	}
} elsif ( $num_orders == 8 ) {
	# first character must be a first-order choice
	push @prev_chars, random_element( \%FIRST_ORDER );
	print $prev_chars[0];
	# second character must be a second-order choice
	%temp_hash = ();
	foreach $key ( keys %SECOND_ORDER ) {
		$temp_hash{ $key } = $SECOND_ORDER{ $key }
			if substr( $key, 0, 1 ) eq $prev_chars[0];
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[1];
	# third character must be a third-order choice
	%temp_hash = ();
	foreach $key ( keys %THIRD_ORDER ) {
		$temp_hash{ $key } = $THIRD_ORDER{ $key }
			if substr( $key, 0, 2 ) eq ( substr( join( "", @prev_chars ), 0, 2 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[2];
	# fourth character must be a fourth-order choice
	%temp_hash = ();
	foreach $key ( keys %FOURTH_ORDER ) {
		$temp_hash{ $key } = $FOURTH_ORDER{ $key }
			if substr( $key, 0, 3 ) eq ( substr( join( "", @prev_chars ), 0, 3 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[3];
	# fifth character must be fifth-order choice
	%temp_hash = ();
	foreach $key ( keys %FIFTH_ORDER ) {
		$temp_hash{ $key } = $FIFTH_ORDER{ $key }
			if substr( $key, 0, 4 ) eq ( substr( join( "", @prev_chars ), 0, 4 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[4];
	# sixth character must be a sixth-order choice
	%temp_hash = ();
	foreach $key ( keys %SIXTH_ORDER ) {
		$temp_hash{ $key } = $SIXTH_ORDER{ $key }
			if substr( $key, 0, 5 ) eq ( substr( join( "", @prev_chars ), 0, 5 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[5];
	# seventh character must be a seventh-order choice
	%temp_hash = ();
	foreach $key ( keys %SEVENTH_ORDER ) {
		$temp_hash{ $key } = $SEVENTH_ORDER{ $key }
			if substr( $key, 0, 6 ) eq ( substr( join( "", @prev_chars ), 0, 6 ) );
	}
	push @prev_chars, random_element( \%temp_hash );
	print $prev_chars[6];
	# now we may do a series of eighth-order choices
	for ( $i = 0; $i < $output_length; $i++ ) {
		%temp_hash = ();
		foreach $key ( keys %EIGHTH_ORDER ) {
			$temp_hash{ $key } = $EIGHTH_ORDER{ $key }
				if substr( $key, 0, 7 ) eq ( substr( join( "", @prev_chars ), 0, 7 ) );
		}
		push @prev_chars, random_element( \%temp_hash );
		shift @prev_chars;
		print $prev_chars[6];
	}
}

	# I think I know how to make this work better

print "\n"; # be a nice program and put a linefeed at the end of output


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
