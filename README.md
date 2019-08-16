# citation-parser
XML/XSLT for processing a list of plain text references into a) their constituent DOIs, b) a valid resource list for Crossref deposit

Crossref requires that members use resource DOIs wherever possible. When assigning a DOI to an article, the list of references must also have DOIs. These tools help identify those DOIs and create the properly formed \<citation\_list\> XML for inclusion in a Metadata deposit [https://support.crossref.org/hc/en-us/articles/214169586](https://support.crossref.org/hc/en-us/articles/214169586) or Resource deposit [https://support.crossref.org/hc/en-us/articles/216009323-Resource-deposit-schema-4-3-6](https://support.crossref.org/hc/en-us/articles/216009323-Resource-deposit-schema-4-3-6).

## Required:

  XML editor/parser (Oxygen)  
  Text Editor (Sublime Text, Textwrangler)

  citation.parser.plus.0.2.php
  citations.processed.xsl (+ crossref.results.xml)

## ARTICLE-LEVEL WORK

In Oxygen, **open citations.processed.xsl. Create crossref.results.xml**

**Import all references, in order, to a text editor.** QC: Review this list to ensure that each line contains only one reference. **One reference to a line, very important.**

**Paste this list in the input box in citation.parser.plus.0.2.php** (you'll need to mount this somewhere it can make http requests and return data). Include the doi of the article you're processing. Submit. Wait (can take a good long time, failed at 100 citations, worked for up to 40. Break up the list accordingly.)

When results post, open up the page source and **copy all the XML output** (browser may not display the XML tags-- you need them). **Paste entirely over the contents of crossref.results.xml**. Save crossref.results.xml.

For each \<citation\> in crossref.results.xml.

- Compare \<raw_string\> to the two \<reference\> elements.

- If one of these is a match, change the flag attribute in the associated \<result\> element to TRUE. Otherwise, leave both alone.

- You might need to test a doi at https://doi.org/[doi] to see if it goes where you think

- You can edit fields directly here; add an \<edition_number\>, \<series_title\>, or \<issue\>, change \<raw_string\> to \<unstructured_citation\> if necessary

- Wiley, Springer, and Elsevier imprints may sometimes have a DOI that can be found through their respective sites

- Sometimes both \<reference\>s will match \<raw_string\>, and the task is to determine the better doi

**After you've gone entirely through each \<citation\>, save crossref.results.xml.**

**Transform crossref.results.xml in an XML parser using citations.processed.xsl**

**Copy all \<citation\> elements (minus the header). Paste into your working file** (wherever you're building your XML deposit document).
