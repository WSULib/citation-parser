<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:output method="xml" indent="yes" encoding="utf-8"/>
    
    <!--    MADE 2019, JOSHUA NEDS-FOX,
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
                <xsl:when test="./result[@flag='TRUE']">
                    <xsl:element name="doi">
                        <xsl:value-of select="./result/doi"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="./unstructured_citation">
                            <xsl:element name="unstructured_citation">
                                <xsl:value-of select="./unstructured_citation"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="./reference_parts/author">
                                    <xsl:element name="author">
                                        <xsl:value-of select="substring-before(./reference_parts/author, ',')"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise></xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="./reference_parts/date">
                                    <xsl:element name="cYear">
                                        <xsl:value-of select="./reference_parts/date"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise></xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="./reference_parts/type='article'">
                                    <xsl:element name="article_title">
                                        <xsl:value-of select="./reference_parts/title"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="volume_title">
                                        <xsl:value-of select="./reference_parts/title"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="./reference_parts/journal">
                                    <xsl:element name="journal_title">
                                        <xsl:value-of select="./reference_parts/journal"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise></xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="./reference_parts/volume">
                                    <xsl:element name="volume">
                                        <xsl:value-of select="./reference_parts/volume"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise></xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="./reference_parts/number">
                                    <xsl:element name="issue">
                                        <xsl:value-of select="./reference_parts/number"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise></xsl:otherwise>
                            </xsl:choose>
                            <xsl:choose>
                                <xsl:when test="./reference_parts/pages">
                                    <xsl:element name="first_page">
                                        <xsl:value-of select="substring-before(./reference_parts/pages, '–')"/>
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