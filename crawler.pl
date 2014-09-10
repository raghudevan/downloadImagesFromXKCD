use strict;
use warnings;

use LWP::Simple;
use Image::Grab;



my $startIndex = 1;

#print "Enter start Index : ";
$startIndex = $ARGV[0];

my $endIndex = 2;
#print "Enter end Index : ";
$endIndex = $ARGV[1];

chomp($startIndex);
chomp($endIndex);

my $defoutPath = "C:\\Users\\Raghudevan.S\\Desktop\\perl_test\\images\\";
#print "Enter outpath : ";
my $outPath = $ARGV[2];

my $startTime = time();

if($outPath eq "def"){
	$outPath = $defoutPath;
}


mkdir($outPath) or die "Invalid directory : $outPath\n";

my $basePath = "http://xkcd.com/";
my $comic = "comics/";
my $png = "\.";

chdir $outPath;
print "Downloading to : ".$outPath."\n";

local $| = 1;
 
my $denom = $endIndex - $startIndex + 1;
my $num = 1;

my $progress = "Download Status : $num/$denom";

my $top = $num;

while( $denom >= $num ){
	my $link = $basePath.$startIndex;
	$startIndex++;
	
	my $source = get($link) or print "\rDid not get link to $link\n";
	
	if(defined $source){
		my $startString = 'http://imgs.xkcd.com/comics';

		my $intermediateString = substr $source, index($source, $startString), length($source);

		my $finalString = substr $intermediateString, 0, index($intermediateString, '"');
		
		#print $finalString."\n";


		my $imageName = substr $finalString, index($finalString, $comic)+7, length($finalString)-4;

		#print $imageName."\n";
		
		my $image = new Image::Grab;

		$image -> url($finalString);
		$image -> grab;

		open(IMAGE, ">".$imageName) || die "Unable to download - ".$imageName."\n";
		binmode IMAGE;  # for MSDOS derivations.
		print IMAGE $image -> image;
		close IMAGE;
		$top++;
	}
		
	$num++;
	print "\r".$progress;
	$progress = "Download Status : $top/$denom";
}

my $timeTaken = time() - $startTime;

print "\nDownload Complete! Time Taken : $timeTaken seconds";









