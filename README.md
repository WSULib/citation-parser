# citation-parser
XML/XSLT for processing a list of plain text references into a) their constituent DOIs, b) a valid resource list for Crossref deposit

Crossref requires that members use resource DOIs wherever possible. When assigning a DOI to an article, the list of references must also have DOIs. These tools help identify those DOIs and create the properly formed \<citation\_list\> XML for inclusion in a Metadata deposit [https://support.crossref.org/hc/en-us/articles/214169586](https://support.crossref.org/hc/en-us/articles/214169586) or Resource deposit [https://support.crossref.org/hc/en-us/articles/216009323-Resource-deposit-schema-4-3-6](https://support.crossref.org/hc/en-us/articles/216009323-Resource-deposit-schema-4-3-6).

## Required:

  XML editor/parser (Oxygen)  
  Text Editor (Sublime Text, Textwrangler)

  citation.parser.plus.0.2.php  
  citations.xsl (+ freecite.data.xml)  
  citations.processed.xsl (+ freecite.data.processed.xml)

## ARTICLE-LEVEL WORK

In Oxygen, **open citations.xsl, citations.processed.xsl. Create freecite.data.xml and freecite.data.processed.xml**

**Import all references, in order, to a text editor.** QC: Review this list to ensure that each line contains only one reference. **One reference to a line, very important.**

**Paste this list in the input box in citation.parser.plus.0.2.php** (you'll need to mount this somewhere it can make http requests and return data). Submit. Wait (can take a good long time, failed at 100 citations, worked for up to 40. Break up the list accordingly.)

When results post, open up the page source and **copy all the XML output** (browser may not display the XML tags-- you need them). **Paste entirely over the contents of freecite.data.xml**. Save freecite.data.xml.

Crossref deposit will require that the key for each \<citation\> element reference the DOI of the associated article. This can be updated in citations.xsl, in the article\_doi variable. **Transform freecite.data.xml in an XML parser using citations.xsl.**

**Copy the results and paste entirely over the contents of freecite.data.processed.xml.**

For each \<citation\> in freecite.data.processed.xml

- Compare \<raw_string\> to the two \<full_citation\> elements.

- If one of these is a match, change the name of the associated \<doi\> element to \<doi_yes\>. You can just paste '_yes' after the name. Otherwise, leave both alone.

- You might need to test a doi at https://doi.org/[doi] to see if it goes where you think

- You can edit fields directly here; add an \<edition_number\>, \<series_title\>, or \<issue\>, change \<raw_string\> to \<unstructured_citation\> if necessary

- Wiley, Springer, and Elsevier imprints may sometimes have a DOI that can be found through their respective sites

- Sometimes both \<full_citations\> will match \<raw_string\>, and the task is to determine the better doi

**After you've gone entirely through each \<citation\>, save freecite.data.processed.xml.**

**Transform freecite.data.processed.xml in an XML parser using citations.processed.xsl**

**Copy all \<citation\> elements (minus the header). Paste into your working file** (wherever you're building your XML deposit document).
