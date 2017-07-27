<?php

/*	MADE 2017, JOSHUA NEDS-FOX,
	CONSIDER THIS COMMENT
	YOUR EXPLICIT, NON-EXCLUSIVE LICENSE
	TO USE AND ADAPT AS NECESSARY
	AS LONG AS YOU CREDIT THE SOURCE */

if (($_POST['submit'] != FALSE) && ($_POST['crunk'] == 
	'change_this_password')) {

$citationdata = $_POST['citations'];
$citationdata = str_replace('&', 'and', $citationdata);
$citations = explode("\n", $citationdata);

// $citations IS AN ARRAY OF INDIVIDUAL CITATIONS

$freecite_parsed = "curl -H 'Accept: text/xml' -d \"";
$dois = array();
$output_dois = array();

foreach ($citations as $citation) {
	$citation = rtrim(ltrim($citation)); // TRIM THE WHITESPACE OFF
	$freecite_parsed .= "citation[]=" . $citation . "&"; // FOR FREECITE, EACH CITATION BECOMES A URL KEY-VALUE PAIR
	$crossref_parsed = "curl http://api.crossref.org/works?query=" . urlencode($citation); // FOR CROSSREF, APPEND QUERY TO THE API /WORKS COMMAND
//	$crossref_parsed .= "&rows=2"; // LIMIT RESULTS FROM CROSSREF

	ob_start();
	passthru($crossref_parsed);
	$crossref_parsed_citations = ob_get_contents();
	ob_end_clean();

	$dois = json_decode($crossref_parsed_citations,true);

	$item1 = $dois['message']['items'][0];
	$item2 = $dois['message']['items'][1];

	$thisItem['doi1'] = $item1['URL'];
	$thisItem['doi2'] = $item2['URL'];
	$thisItem['citation1'] = "{$item1['author'][0]['family']}, {$item1['author'][0]['given']}. {$item1['published-print']['date-parts'][0][0]}. {$item1['title'][0]}. {$item1['container-title'][0]}, {$item1['volume']}({$item1['issue']}), {$item1['page']}.";
	$thisItem['citation2'] = "{$item2['author'][0]['family']}, {$item2['author'][0]['given']}. {$item2['published-print']['date-parts'][0][0]}. {$item2['title'][0]}. {$item2['container-title'][0]}, {$item2['volume']}({$item2['issue']}), {$item2['page']}.";

	$output_dois[] = $thisItem;

}

$freecite_parsed = rtrim($freecite_parsed, "&");
$freecite_parsed .= "\" http://freecite.library.brown.edu/citations/create";
$freecite_parsed = str_replace("\n", "", $freecite_parsed);

//echo($to_be_parsed);

ob_start();
passthru($freecite_parsed);
$freecite_parsed_citations = ob_get_contents();
ob_end_clean();

// echo($freecite_parsed_citations);

/* WE NOW HAVE
   1. AN ARRAY ($OUTPUT_DOIS) OF ARRAYS (1 FOR EACH CITATION),
      EACH WITH 2 POSSIBLE DOIS FOR EACH CITATION
   2. XML FIELDS FOR EACH CITATION ($FREECITE_PARSED_CITATIONS) */



$xmlData = "<?xml version='1.0' encoding='UTF-8'?>" . $freecite_parsed_citations;
$parsed_citations =  new SimpleXMLElement($xmlData);
$i = 0;
foreach ($parsed_citations->citation as $citation) {
	$doi = $citation->addChild('dois');
	$doi->addChild('doi', $output_dois[$i][doi1]);
	$doi->addChild('fullCitation', $output_dois[$i][citation1]);
	$doi = $citation->addChild('dois');
	$doi->addChild('doi', $output_dois[$i][doi2]);
	$doi->addChild('fullCitation', $output_dois[$i][citation2]);
	$i = $i + 1;
}

$freecite_parsed_citations = $parsed_citations->asXML();

/* WE NOW HAVE
   1. XML FIELDS FOR EACH CITATION
      WITH TWO POSSIBLE DOIS, ACCOMPANIED BY
      A FULL CITATION FOR THOSE DOIS */



echo($freecite_parsed_citations);

} else { ?><form name="citation_parser" method="post" action="citation.parser.plus.0.2.php">
<textarea name="citations"></textarea>
<input type="password" name="crunk" />
<input type="submit" name="submit" value="Submit" />
</form><?php

}



?>