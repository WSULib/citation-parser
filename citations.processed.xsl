<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:output method="xml" indent="yes" encoding="utf-8"/>
    
    <!--    MADE 2017, JOSHUA NEDS-FOX,
            CONSIDER THIS COMMENT
            YOUR EXPLICIT, NON-EXCLUSIVE LICENSE
            TO USE AND ADAPT AS NECESSARY
            AS LONG AS YOU CREDIT THE SOURCE    -->
    
    <xsl:template match="/citations">
        
        <xsl:for-each select="citation">
            
            <xsl:element name="citation">
                <xsl:attribute name="key">
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                
            <xsl:choose>
                <xsl:when test="doi_yes">
                    <xsl:element name="doi">
                        <xsl:value-of select="doi_yes"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="unstructured_citation">
                            <xsl:element name="unstructured_citation">
                                <xsl:value-of select="unstructured_citation"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="journal_title">
                            <xsl:element name="journal_title">
                                <xsl:value-of select="journal_title"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="article_title">
                            <xsl:element name="article_title">
                                <xsl:value-of select="article_title"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="volume_title">
                            <xsl:element name="volume_title">
                                <xsl:value-of select="volume_title"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="series_title">
                            <xsl:element name="series_title">
                                <xsl:value-of select="series_title"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="volume">
                            <xsl:element name="volume">
                                <xsl:value-of select="volume"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="issue">
                            <xsl:element name="issue">
                                <xsl:value-of select="issue"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="edition_number">
                            <xsl:element name="edition_number">
                                <xsl:value-of select="edition_number"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="author">
                            <xsl:element name="author">
                                <xsl:value-of select="author"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="cYear">
                            <xsl:element name="cYear">
                                <xsl:value-of select="cYear"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="first_page">
                            <xsl:element name="first_page">
                                <xsl:value-of select="first_page"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="isbn">
                            <xsl:element name="isbn">
                                <xsl:value-of select="isbn"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose> 
            
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>