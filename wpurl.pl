#!/usr/bin/env perl
# Description: This will interact with the database fields for home and siteurl in WordPress databases.
# Use:
# wpurl - Running this script with no arguments will print out the current home and siteurl fields from the database.
# -n) wpurl -n https://www.wordpress.org - This will update both the home and siteurl fields.
# -h) wpurl -h https://www.wordpress.org - This will only update the home field.
# -s) wpurl -s https://www.wordpress.org - This will only update the site field.
# Author: Marcus Hancock-Gaillard

use strict;
use warnings;
use DBI;

######################### Help Menu ########################
my $help_message = qq|Description: This will interact with the database fields for home and siteurl in WordPress databases.
Use:
wpurl - Running this script with no arguments will print out the current home and siteurl fields from the database.
-n) wpurl -n https://www.wordpress.org - This will update both the home and siteurl fields.
-h) wpurl -h https://www.wordpress.org - This will only update the home field.
-s) wpurl -s https://www.wordpress.org - This will only update the site field.|;



my $file = "wp-config.php";
my $dbname;
my $prefix;
my $dbhost;
my $dbuser;
my $dbpass;

if (-f $file) {
	open(my $fh, '<', $file) or die "Couldn't open file: $!";
	while (my $line = <$fh>) {
		chomp $line;
		# Stop the while loop if both variables are not empty
		if ($dbname && $prefix) {
			last;
		}
		# Grabs the database name
		if (($line =~ /^define\(\s*['"]DB_NAME['"],\s*['"](.*)['"]/) && (!$dbname)) {
			$dbname = $1;
			next;
		}
		# Grabs the table prefix
		if (($line =~ /table_prefix\s+= '(.*)'/) && (!$prefix)) {
			$prefix = $1;
			next;
		}
		if (($line =~ /^define\(\s*['"]DB_HOST['"],\s*['"](.*)['"]/) && (!$dbhost)) {
			$dbhost = $1;
			next;
		}
		if (($line =~ /^define\(\s*['"]DB_USER['"],\s*['"](.*)['"]/) && (!$dbhost)) {
                        $dbuser = $1;
                        next;
                }
		if (($line =~ /^define\(\s*['"]DB_PASSWORD['"],\s*['"](.*)['"]/) && (!$dbhost)) {
                        $dbpass = $1;
                        next;
                }
	}
	# say $dbname;
	# say $prefix;
	close $fh;
} else {
	print "File Error: No wp-config.php in CWD.\n";
	exit;
}

# check if the user running the script is root && start database connection
my $dbh;
$dbh = DBI->connect("DBI:mysql:$dbname;host=$dbhost", $dbuser, $dbpass, { RaiseError => 1 })
	or die "Couldn't connect to $dbname: " . DBI->errstr;

if (@ARGV) {
	# arguments passed to the script
	# looking for [-n], [-h], and [-s] for the first argument
	my $flag = shift;
	my $url = shift;
	if ($flag eq "-n") {
		if ($url) {
			run_query($url);
		} else {
			print "URL parameter is empty!\n"
		}
	} elsif ($flag eq "-h") {
		if ($url) {
			target_query($url, "home");
		} else {
			print "URL parameter is empty!\n"
		}
	} elsif ($flag eq "-s") {
		if ($url) {
			target_query($url, "siteurl");
		} else {
			print "URL parameter is empty!\n"
		}
	} else {
		# TODO will need to add a help/usage message explaining basic usage of the script.
		print $help_message . "\n";
		exit;
	}
} else {
	# no arguments passed just print out the home and siteurl fields
	display_urls();
}

################################################## Functions #######################################################

sub display_urls {
	my $sth = $dbh->prepare("SELECT option_name, option_value FROM ${prefix}options WHERE option_name = 'siteurl' OR option_name = 'home'")
		or die "Couldn't prepare statement: " . $dbh->errstr;
	$sth->execute() or die "Couldn't execute statement: " . $sth->errstr;
	while (my @data = $sth->fetchrow_array()) {
		my $option_name = uc $data[0];
		printf("%-7s: ", $option_name);
		print $data[1] . "\n";
	}
}

# will update both siteurl and home fields
sub run_query {
	my $url = shift;
	my $sth = $dbh->prepare("UPDATE ${prefix}options SET option_value = ? WHERE option_name = 'siteurl' OR option_name = 'home'")
		or die "Couldn't prepare statement: " . $dbh->errstr;
	$sth->execute($url) or die "Couldn't execute statement: " . $sth->errstr;
	display_urls();
}

# will target either home or siteurl fields
sub target_query {
	my $url = shift;
	my $option_name = shift;
	my $sth = $dbh->prepare("UPDATE ${prefix}options SET option_value = ? WHERE option_name = ?")
		or die "Couldn't prepare statement: " . $dbh->errstr;
	$sth->execute($url, $option_name) or die "Couldn't execute statement: " . $sth->errstr;
	display_urls();
}
