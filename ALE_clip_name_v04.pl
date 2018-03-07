# script to format clips names in ALE
# by Chuck Kahn
# 2017-01-09

# $/ = "\r";   # set delimiter


$name = "Day 65.ale";	# name ALE  <------------- change ALE filename here!!!
$name_new = "New " . $name;

open ALE_OLD, $name or die $!;	# open ALE's
open ALE_NEW, ">$name_new";

$record = <ALE_OLD>;

print ALE_NEW $record;			# copy first line to new ALE

do {							
	$record = <ALE_OLD>;
	print ALE_NEW $record;		# copy Global Header to new ALE
} until ($record =~ /Column/);

$record = <ALE_OLD>;			# read in Column headings

if ( $record =~ /\tTracks\t/ )
{
	$tracks_h = "";
	$tracks_d = "";
}
else
{
	$tracks_h = "Tracks\t";
	$tracks_d = "V\t";
}

print ALE_NEW $tracks_h . "Comments\t" . $record;		# add Tracks and/or Comments to new ALE

@columns = split ( /\t/, $record );

do {
	$record = <ALE_OLD>;
	print ALE_NEW  $record;							# add ALE lines until Data line to new ALE
} until ($record =~ /Data/);

while ($record = <ALE_OLD>)
{
	print  "old $record";

	@data{@columns} = split ( /\t/, $record );
 
	$letter = lc (substr $data{'Reel name'}, 0, 1);
	$NewName = $data{'Name'} . $letter;
	
	$NewName =~ s/ //g;

	print "new ";

	$new_record = $record;
	$data{'Name'} =~ s/\?/X/g;
	$new_record =~ s/$data{'Name'}/$NewName/ ;

	print  "$new_record";
	print ALE_NEW $tracks_d . "$NewName\t" . "$new_record";		# add tabbed data lines to new ALE with 

}

close ALE_OLD;
close ALE_NEW;
