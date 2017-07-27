<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:output method="xml" indent="yes" encoding="utf-8"/>
    <xsl:template match="/citations">
    
    <citations>
        
        <xsl:for-each select="citation">
            
            <xsl:variable name="citation_number">
                <xsl:number/>
            </xsl:variable>
            
            <xsl:variable name="article_doi">10.22237/crp/1498867260</xsl:variable>
            
            <xsl:element name="citation">
                <xsl:attribute name="key">
                    <xsl:value-of select="concat('key-', $article_doi, '-', $citation_number)"/>
                </xsl:attribute>
                
            <xsl:choose>
                <xsl:when test="journal != ''"> <!-- IF IT's A JOURNAL -->
                    <xsl:element name="journal_title">
                        <xsl:value-of select="journal"/>
                    </xsl:element>
                    <xsl:element name="article_title">
                        <xsl:value-of select="title"/>
                    </xsl:element>
                    <xsl:choose>
                        <xsl:when test="volume != ''">
                            <xsl:element name="volume">
                                <xsl:value-of select="volume"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="issue != ''">
                            <xsl:element name="issue">
                                <xsl:value-of select="issue"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:when>
                <xsl:otherwise> <!-- OTHERWISE IT'S A BOOK? -->
                    <xsl:choose>
                        <xsl:when test="editor != ''">
                            <xsl:element name="article_title">
                                <xsl:value-of select="title"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="volume_title">
                                <xsl:value-of select="title"/>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

                
            <xsl:choose>
                <xsl:when test="year != ''">
                    <xsl:element name="cYear">
                        <xsl:value-of select="year"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
            
            <xsl:choose>
                <xsl:when test="authors/author != ''">
                    <xsl:element name="author">
                        
                        <xsl:variable name="author_string_length"><xsl:value-of select="string-length(authors/author)"/></xsl:variable>
                        <xsl:variable name="author_string_length_minus_spaces"><xsl:value-of select="string-length(translate(authors/author,' ',''))"/></xsl:variable>
                        <xsl:variable name="number_of_spaces"><xsl:value-of select="$author_string_length - $author_string_length_minus_spaces"/></xsl:variable>
                        
                        <xsl:choose>
                            <!-- WHEN THE AUTHOR STRING HAS SPACES IN IT -->
                            <xsl:when test="$author_string_length != $author_string_length_minus_spaces">
                                
                                <!-- SPLIT THE AUTHOR STRING LENGTH INTO TWO -->
                                
                                <!-- [SUBSTRING-BEFORE() WILL NEVER HAVE A SPACE IN IT] -->
                                <xsl:variable name="first_chars"><xsl:value-of select="substring-before(authors/author, ' ')"/></xsl:variable>
                                <xsl:variable name="second_chars"><xsl:value-of select="substring-after(authors/author, ' ')"/></xsl:variable>
                                
                                <!-- TEST TO SEE IF YOU NEED TO KEEP THE WHOLE AUTHOR STRING -->
                                <xsl:choose>
                                    
                                    <!-- IF ONE SPACE (THIS WORKS) -->
                                    <xsl:when test="$number_of_spaces = 1">
                                        <xsl:choose>
                                            <xsl:when test="(string-length($first_chars) > 1) and (string-length($second_chars) > 1)">
                                                <!-- AND BOTH SIDES ARE MULTIPLE CHARACTERS -->
                                                <!-- KEEP THE WHOLE AUTHOR STRING -->
                                                <xsl:value-of select="authors/author"/>
                                                
                                                
                                            </xsl:when>
                                            <xsl:otherwise>
                                                
                                                <!-- A SMITH or SMITH A -->
                                                
                                                <xsl:choose>
                                                    <!-- IF THE FIRST CHARACTER IS SINGLE -->
                                                    <xsl:when test="string-length(substring-before(authors/author, ' ')) = 1">
                                                        <!-- TAKE THE SECOND SET OF CHARACTERS -->
                                                        <xsl:value-of select="substring-after(authors/author, ' ')"/>
                                                    </xsl:when>
                                                    <!-- OTHERWISE -->
                                                    <xsl:otherwise>
                                                        <!-- TAKE THE FIRST SET OF CHARACTERS -->
                                                        <xsl:element name="is_it_here">
                                                            <xsl:value-of select="$first_chars"/>
                                                        </xsl:element>
                                                        <xsl:value-of select="substring-before(authors/author, ' ')"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                
                                                
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    
                                    <!-- IF MORE THAN ONE SPACE -->
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <!-- IF THE FIRST SUBSTRING IS MULTIPLE CHARACTERS -->
                                            <xsl:when test="string-length($first_chars) > 1">
                                                <!-- TEST THE NEXT SUBSTRING -->
                                                <!-- [SUBSTRING-BEFORE() WILL NEVER HAVE A SPACE IN IT] -->
                                                <xsl:variable name="second_chars_pt_1"><xsl:value-of select="substring-before($second_chars, ' ')"/></xsl:variable>
                                                <xsl:variable name="second_chars_pt_2"><xsl:value-of select="substring-after($second_chars, ' ')"/></xsl:variable>
                                                <!-- AND THE SECOND SUBSTRING IS MULTIPLE CHARACTERS -->
                                                <xsl:choose>
                                                    <xsl:when test="string-length($second_chars_pt_1) > 1">
                                                        <!-- KEEP THE WHOLE AUTHOR STRING -->
                                                        <xsl:value-of select="authors/author"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <!-- OTHERWISE KEEP JUST THE FIRST SUBSTRING (MULTIPLE CHARS) -->
                                                        <xsl:value-of select="$first_chars"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                
                                                <xsl:if test="$number_of_spaces = 2">
                                                    <xsl:choose>
                                                        <!-- IF THE FIRST HALF, BEFORE THE FIRST SPACE, IS MULTIPLE CHARACTERS -->
                                                        <xsl:when test="string-length(substring-before(authors/author, ' ')) != 1">
                                                            <xsl:value-of select="substring-before(authors/author, ' ')"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:variable name="tripartate_part_two"><xsl:value-of select="substring-before(substring-after(authors/author, ' '), ' ')"/></xsl:variable>
                                                            <xsl:variable name="tripartate_part_three"><xsl:value-of select="substring-after(substring-after(authors/author, ' '), ' ')"/></xsl:variable>
                                                            <xsl:choose>
                                                                <xsl:when test="string-length($tripartate_part_two) > 1">
                                                                    <xsl:value-of select="$tripartate_part_two"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                    <xsl:value-of select="$tripartate_part_three"/>
                                                                </xsl:otherwise>
                                                            </xsl:choose>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:if>
                                                
                                                <xsl:if test="$number_of_spaces = 3">
                                                    <xsl:choose>
                                                        <!-- IF THE FIRST QUARTER, BEFORE THE FIRST SPACE, IS MULTIPLE CHARACTERS -->
                                                        <xsl:when test="string-length(substring-before(authors/author, ' ')) != 1">
                                                            <xsl:value-of select="substring-before(authors/author, ' ')"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:variable name="second_quarter"><xsl:value-of select="substring-before(substring-after(authors/author, ' '), ' ')"/></xsl:variable>
                                                            <xsl:variable name="third_and_fourth_quarter"><xsl:value-of select="substring-after(substring-after(authors/author, ' '), ' ')"/></xsl:variable>
                                                            <xsl:variable name="third_quarter"><xsl:value-of select="substring-before($third_and_fourth_quarter, ' ')"/></xsl:variable>
                                                            <xsl:variable name="fourth_quarter"><xsl:value-of select="substring-after($third_and_fourth_quarter, ' ')"/></xsl:variable>
                                                            
                                                            <xsl:if test="string-length($second_quarter) > 1"><xsl:value-of select="$second_quarter"/></xsl:if>
                                                            <xsl:if test="string-length($third_quarter) > 1"><xsl:value-of select="$third_quarter"/></xsl:if>
                                                            <xsl:if test="string-length($fourth_quarter) > 1"><xsl:value-of select="$fourth_quarter"/></xsl:if>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:if>
                                                
                                                <xsl:if test="$number_of_spaces = 4">
                                                    <xsl:choose>
                                                        <!-- IF THE FIRST FIFTH, BEFORE THE FIRST SPACE, IS MULTIPLE CHARACTERS -->
                                                        <xsl:when test="string-length(substring-before(authors/author, ' ')) != 1">
                                                            <xsl:value-of select="substring-before(authors/author, ' ')"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:variable name="second_fifth"><xsl:value-of select="substring-before(substring-after(authors/author, ' '), ' ')"/></xsl:variable>
                                                            <xsl:variable name="third_through_fifth_fifth"><xsl:value-of select="substring-after(substring-after(authors/author, ' '), ' ')"/></xsl:variable>
                                                            <xsl:variable name="third_fifth"><xsl:value-of select="substring-before($third_through_fifth_fifth, ' ')"/></xsl:variable>
                                                            <xsl:variable name="fourth_and_fifth_fifth"><xsl:value-of select="substring-after($third_through_fifth_fifth, ' ')"/></xsl:variable>
                                                            <xsl:variable name="fourth_fifth"><xsl:value-of select="substring-before($fourth_and_fifth_fifth, ' ')"/></xsl:variable>
                                                            <xsl:variable name="fifth_fifth"><xsl:value-of select="substring-after($fourth_and_fifth_fifth, ' ')"/></xsl:variable>
                                                            
                                                            <xsl:if test="string-length($second_fifth) > 1"><xsl:value-of select="$second_fifth"/></xsl:if>
                                                            <xsl:if test="string-length($third_fifth) > 1"><xsl:value-of select="$third_fifth"/></xsl:if>
                                                            <xsl:if test="string-length($fourth_fifth) > 1"><xsl:value-of select="$fourth_fifth"/></xsl:if>
                                                            <xsl:if test="string-length($fifth_fifth) > 1"><xsl:value-of select="$fifth_fifth"/></xsl:if>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:if>
                                                
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="authors/author"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:element> <!-- AUTHOR -->
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
            
            <xsl:choose>
                <xsl:when test="pages != ''">
                    <xsl:choose>
                        <xsl:when test="substring-before(pages, '-') != ''">
                            <xsl:element name="first_page">
                                <xsl:value-of select="substring-before(pages, '-')"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
            
            <raw_string>
                <xsl:value-of select="raw_string"/>
            </raw_string>
            
            <xsl:for-each select="dois">
                <full_citation>
                    <xsl:value-of select="fullcitation"/>
                </full_citation>
                <doi>
                    <xsl:value-of select="substring-after(doi, 'http://dx.doi.org/')"/>
                </doi>
            </xsl:for-each>
            
            </xsl:element>

        </xsl:for-each>
    </citations>
    </xsl:template>
</xsl:stylesheet>