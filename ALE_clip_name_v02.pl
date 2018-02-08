# script to format clips names in ALE
# by Chuck Kahn
# 2017-01-09

# $/ = "\r";   # set delimiter


$name = "Day 45.ale";			# name ALE
$name_new = "New " . $name;

open ALE_OLD, $name or die $!;	# open ALE's
open ALE_NEW, ">$name_new";

$record = <ALE_OLD>;

print ALE_NEW $record;			# print to new ALE

do {							# don't change headers
	$record = <ALE_OLD>;
	print ALE_NEW $record;
} until ($record =~ /Column/);

$record = <ALE_OLD>;
print ALE_NEW "Tracks\tComments\t" . $record;


@columns = split ( /\t/, $record );

do {
	$record = <ALE_OLD>;
	print ALE_NEW  $record;
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
	print ALE_NEW "V\t$NewName\t" . "$new_record";

}

close ALE_OLD;
close ALE_NEW;
