<xsl:stylesheet version = '1.0'
     xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

<xsl:template match="/article">
    <html>
        <head>
            <title><xsl:value-of select="title"/></title>        
        </head>
        <xsl:apply-templates select="section"/>
    </html>
</xsl:template>

<xsl:template match="section">
    <section style="padding-inline-start:1%">
        <xsl:if test=".[@id]">
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
    </section>
</xsl:template>

<xsl:template match="para">
    <p>
        <xsl:apply-templates select="node()"/>
    </p>
</xsl:template>

<xsl:template match="orderedlist">
    <ol>
        <xsl:apply-templates select="para"/>
        <xsl:for-each select="listitem">
            <li>
                <xsl:apply-templates/>
            </li>
        </xsl:for-each>
    </ol>
</xsl:template>

<xsl:template match="itemizedlist">
    <ul>
        <xsl:apply-templates select="para"/>
        <xsl:for-each select="listitem">
            <li>
                <div>
                    <xsl:apply-templates/>
                </div>
            </li>
        </xsl:for-each>
    </ul>
</xsl:template>

<xsl:template match="title">
    <h2>
        <xsl:attribute name="id">
            <xsl:value-of select="@id"/>
        </xsl:attribute>
        <xsl:value-of select="."/>
    </h2>
</xsl:template>

<xsl:template match="code">
    <code><xsl:apply-templates/></code>
</xsl:template>

<xsl:template match="keycap">
    <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="emphasis">
    <i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="link">
    <a>
        <xsl:attribute name="style">
            <xsl:text>color:green</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="@linkend"/>
        </xsl:attribute>
        <xsl:attribute name="title">
            <xsl:variable name="TXT" select="string(@endterm)"/>
            <!--Couldn't figure out how to do this, leaving this so you know I tried.-->
            <xsl:value-of select="$TXT"/>
            <!--<xsl:value-of select="//h2[matches(@id,$TXT)]/text()"/>    doesn't work, dunno why-->
        </xsl:attribute>
        <xsl:apply-templates/>
    </a>
</xsl:template>

<xsl:template match="ulink">
    <a>
        <xsl:attribute name="style">
            <xsl:text>color:green</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="href">
            <xsl:value-of select="@url"/>
        </xsl:attribute>
        <xsl:apply-templates/>
    </a>
</xsl:template>

<xsl:template match="text()">
    <xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>