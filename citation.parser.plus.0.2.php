<?php

   /*	    MADE 2019, JOSHUA NEDS-FOX,
            CONSIDER THIS COMMENT
            YOUR EXPLICIT, NON-EXCLUSIVE LICENSE
            TO USE AND ADAPT AS NECESSARY
            AS LONG AS YOU CREDIT THE SOURCE    */

if (($_POST['submit'] != FALSE) && ($_POST['crunk'] == 
	'change_this_password')) {

//#################################//
//########## FUNCTIONS ############//
//#################################//

//receiveCitations CREATES AN ARRAY OF ALL REFERENCES PASTED INTO THE WEBFORM
function receiveCitations($citationdata) {
	$citationdata = str_replace('&', 'and', $citationdata);
	$citationdata = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $citationdata); //REMOVE ANY BLANK LINES
	$citations = explode("\n", $citationdata); //BREAK REFERENCES INTO AN ARRAY
	return $citations;
}

//queryCrossref QUERIES CROSSREF FOR ONE REFERENCE, RETURNS
//AN ARRAY OF THE TOP TWO RESULTS AS PHP OBJECTS FROM THEIR DATABASE
function queryCrossref($single_reference) {
	//BASED ON THE CROSSREF REST API https://github.com/CrossRef/rest-api-doc
	$url = "https://api.crossref.org/works?query.bibliographic=".urlencode($single_reference)."&rows=5&sort=score&order=desc";
	$query = "curl -X GET ".$url." -H 'User-Agent: citation-parser/0.2 (https://github.com/WSULib/citation-parser; mailto:[your_email])'";
	ob_start();
	passthru($query);
	$crossref_results = ob_get_contents();
	ob_end_clean();
	$crossref_results = json_decode($crossref_results); //TURNS JSON INTO PHP OBJECT
	$top_two_results = array();
	$top_two_results[] = $crossref_results->message->items[0];
	$top_two_results[] = $crossref_results->message->items[1];
	return $top_two_results;
}

//queryAnyStyle QUERIES ANYSTYLE FOR ALL REFERENCES, RETURNS
//A PHP ARRAY WITH CITATION PARTS FOR ALL REFERENCES
function queryAnyStyle($citations) {
	//TAKE THE ARRAY RETURNED BY receiveCitations,
	//MAKE A JSON-STYLE STRING INSTEAD
	$citationList = "[";
	foreach ($citations as $citation) {
		$citationList .= "\"";
		$citationList .= $citation;
		$citationList .= "\",";
	}
	$citationList = substr($citationList,0,-1);
	$citationList .= "]";

	//QUERY anystyle.io WITH THE LIST
	$query  = "curl -d '{\"access_token\":\"[YOU'LL NEED AN ACCESS TOKEN FROM ANYSTYLE.IO]\",".
	$query .= 			"\"references\":".$citationList.",\"format\":\"json\"}' ";
	$query .= "-H \"Content-Type: application/json;charset=UTF-8\" ";
	$query .= "-X POST https://anystyle.io/parse/references.json";
	ob_start();
	passthru($query);
	$anystyle_results = ob_get_contents();
	ob_end_clean();

	//RETURN A PHP ARRAY OF THE RESULTS
	$anystyle_results = json_decode($anystyle_results, TRUE); //JSON -> PHP ARRAY
	return $anystyle_results;
}

//processReferences GETS TWO POTENTIAL DOI MATCHES FOR EACH REFERENCE PASTED INTO THE WEBFORM
//AND MERGES THEM WITH THE REFERENCE PARTS OF EACH REFERENCE
function processReferences($citations) {
	$dois = array(); $references = array();
	$i=0;
	
	$reference_parts = queryAnyStyle($citations);
	
	foreach ($citations as $citation) {
		$dois[$i] = queryCrossref($citation);
		$dois[$i][2] = $citation;
		$i = $i+1;
		sleep(1);
	}
	
	$dois_and_parts = array($dois,$reference_parts);

	$i=0;
	foreach ($dois_and_parts[0] as $reference) {
		$references[$i] = array($reference,$reference_parts[$i]);
		$i++;
	}

	return $references;
}

//buildXML TAKES OUTPUT OF processReferences, 
//MAKES A HUMAN READABLE DOI CHECKER FOR EACH REFERENCE,
//REQUIRES A DOI OR A DUMMY DOI FOR THE PARENT ARTICLE
function buildXML($dois, $article_doi) {
	$xml = "<citations>\r\n";
	$i=1;
	foreach ($dois as $item) {
		$j=0;
		$xml .= "<citation key=\"key-".$article_doi."-".$i."\">\r\n";
		//THE ORIGINAL REFERENCE
		$xml .= "<raw_string>".$item[0][2]."</raw_string>\r\n";
		//CONSTRUCT REFERENCES FOR THE TWO POSSIBLE MATCHES
		while ($j<=1) {
			$number=$j+1;
			if ($item[0][$j]->type != "journal-article") {
				$reconstructed_reference = "{$item[0][$j]->author[0]->family} {$item[0][$j]->author[0]->given}. ("
					.$item[0][$j]->issued->{'date-parts'}[0][0]."). {$item[0][$j]->title[0]}. "
					.$item[0][$j]->publisher;
			} else {
				$reconstructed_reference = "{$item[0][$j]->author[0]->family} {$item[0][$j]->author[0]->given}. ("
					.$item[0][$j]->issued->{'date-parts'}[0][0]."). {$item[0][$j]->title[0]}. "
					.$item[0][$j]->{'container-title'}[0].", {$item[0][$j]->volume}({$item[0][$j]->issue}), "
					.$item[0][$j]->page;
			}
			$xml .= "<reference{$number}>".$reconstructed_reference."</reference{$number}>\r\n";
			$j=$j+1;
		}
		//CONSTRUCT METADATA FOR THOSE TWO POSSIBLE MATCHES
		$j=0;
		while ($j<=1) {
			$number=$j+1; $flag = "";
			//SCORES OF 100 OR GREATER SEEM TO INDICATE A SURE MATCH
			if ($item[0][$j]->score >= 100) {$flag = "TRUE";} else {$flag = "FALSE";}
			$xml .= "<result number=\"{$number}\" flag=\"{$flag}\">\r\n";
			$xml .= "<type>".$item[0][$j]->type."</type>\r\n";
			$xml .= "<doi>".$item[0][$j]->DOI."</doi>\r\n";
			$xml .= "<title>".$item[0][$j]->title[0]."</title>\r\n";
			$xml .= "<author>".$item[0][$j]->author[0]->family."</author>\r\n";
			$xml .= "<score>".$item[0][$j]->score."</score>\r\n";
			$xml .= "</result>\r\n";
			$j=$j+1;
		}
		//CONSTRUCT THE FIELDS FROM THE ORIGINAL REFERENCE
		$xml .= "<reference_parts>\r\n";
		foreach ($item[1] as $key => $value) {
			$xml .= "<".$key.">".$value."</".$key.">\r\n";
		}
		$xml .= "</reference_parts>\r\n";
		$xml .= "</citation>\r\n";
		//INCREASE THE CITATION LIST COUNT BY 1
		$i = $i+1;
	}
	$xml .= "</citations>";
	return $xml;
}

//#################################//
//########## PROCESSING ###########//
//#################################//

$citations = receiveCitations($_POST['citations']);
// $citations IS AN ARRAY OF INDIVIDUAL REFERENCES

$references = processReferences($citations);
// GET TWO DOIS FOR EVERY REFERENCE, PLUS REFERENCE PARTS

$xml = buildXML($references, $_POST['article_doi']);

/* WE NOW HAVE
   AN XML DOCUMENT OF CITATIONS,
   WITH EACH CITATION CONTAINING
   1. THE ORIGINAL RAW_STRING,
   2. TWO POSSIBLE DOI MATCHES,
   3. AND THE BIBLIOGRAPHIC PARTS OF THE ORIGINAL REFERENCE */

echo($xml);

} else { ?>
<form name="citation_parser" method="post" action="citation.parser.plus.0.2.php">
<textarea name="citations"></textarea> [citations]<br />
<input type="password" name="crunk" /> [crunk]<br />
<input type="text" name="article_doi" /> [article doi]<br />
<input type="submit" name="submit" value="Submit" />
</form><?php

}

?>