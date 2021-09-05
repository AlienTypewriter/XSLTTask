<xsl:stylesheet version = '3.0'
     xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

<xsl:template match="/article">
    <html>
        <head>
            <title><xsl:value-of select="title"/></title>
            <style>
            ol {
                counter-reset: item;
            }
            ol > li {
                display: block;
                position: relative;
            }
            ol > li:before {
                content: counters(item, ".")".";
                counter-increment: item;
                position: absolute;
                margin-right: 100%;
                right: 10px;
            }
            section { padding-inline-start:0.5% }
            a { color: green }
            </style>        
        </head>
        <h3>Table of contents</h3>
        <ol>
            <xsl:apply-templates select="section" mode="toc"/>
        </ol>
        <xsl:apply-templates select="section"/>
    </html>
</xsl:template>

<xsl:template match="section" mode="toc">
    <li>
        <a>
            <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="lower-case(translate(title/text(),' ','-'))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="title"/>
        </a>
        <xsl:if test="section">
            <ol>
                <xsl:apply-templates select="section" mode="toc"/>
            </ol>
        </xsl:if>
    </li>
</xsl:template>

<xsl:template match="section">
    <section>
        <xsl:attribute name="id">
            <xsl:choose>
                <xsl:when test="@id">
                    <xsl:value-of select="@id"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="lower-case(translate(title/text(),' ','-'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates/>
    </section>
</xsl:template>

<xsl:template match="title">
    <h2>
        <xsl:if test="@id">
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
    </h2>
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
                <xsl:apply-templates/>
            </li>
        </xsl:for-each>
    </ul>
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
        <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="@linkend"/>
        </xsl:attribute>
        <xsl:attribute name="title">
            <xsl:variable name="TXT" select="string(@endterm)"/>
            <xsl:value-of select="//title[@id=$TXT][1]/text()"/>
        </xsl:attribute>
        <xsl:apply-templates/>
    </a>
</xsl:template>

<xsl:template match="ulink">
    <a>
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