<xsl:stylesheet version = '3.0'
     xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>

<xsl:template match="/article">
    <html>
        <xsl:apply-templates select="title" mode="newpage"/>
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
                <xsl:choose>
                    <xsl:when test="@id">
                        <xsl:value-of select="@id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="lower-case(translate(title/text(),' ','-'))"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>.html</xsl:text>
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
    <xsl:variable name="linkref">
        <xsl:choose>
            <xsl:when test="@id">
                <xsl:value-of select="@id"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="lower-case(translate(title/text(),' ','-'))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:result-document href="{$linkref}.html" method="html">
        <html>
            <xsl:apply-templates select="title" mode="newpage"/>
            <body>
                <nav>
                    <xsl:if test="preceding-sibling::*[name()='section']">
                        <a>
                            <xsl:variable name="previous" select="preceding-sibling::*[name()='section'][1]"/>
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="$previous/@id">
                                        <xsl:value-of select="$previous/@id"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="lower-case(translate($previous/title/text(),' ','-'))"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>.html</xsl:text>
                            </xsl:attribute>
                            Previous
                        </a>
                        |
                    </xsl:if>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="..=/article">
                                    <xsl:text>index</xsl:text>
                                </xsl:when>
                                <xsl:when test="../@id">
                                    <xsl:value-of select="../@id"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="lower-case(translate(../title/text(),' ','-'))"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:text>.html</xsl:text>
                        </xsl:attribute>
                        Parent
                    </a>
                    <xsl:if test="following-sibling::*[name()='section']">
                        |
                        <a>
                            <xsl:variable name="next" select="following-sibling::*[name()='section'][1]"/>
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="$next/@id">
                                        <xsl:value-of select="$next/@id"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="lower-case(translate($next/title/text(),' ','-'))"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:text>.html</xsl:text>
                            </xsl:attribute>
                            Next
                        </a>
                    </xsl:if>
                </nav>
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
                    <xsl:if test="section">
                        <div>
                            <h4>Child topics</h4>
                            <ol>
                                <xsl:apply-templates select="section" mode="toc"/>
                            </ol>
                        </div>
                    </xsl:if>
                    <xsl:apply-templates/>
                </section>
            </body>
        </html>
    </xsl:result-document>
</xsl:template>

<xsl:template match="title" mode="newpage">
    <head>
        <title><xsl:value-of select="."/></title>
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
        <xsl:variable name="linkend" select="string(@linkend)"/>
        <xsl:variable name="element" select="//*[@id=$linkend]"/>
            <xsl:attribute name="href">
                <xsl:if test="$element">
                    <xsl:variable name="pagecontaining" select="$element/ancestor-or-self::*[name()='section'][1]"/>
                    <xsl:choose>
                        <xsl:when test="$pagecontaining=/article">
                            <xsl:text>index</xsl:text>
                        </xsl:when>
                        <xsl:when test="$pagecontaining/@id">
                            <xsl:value-of select="$pagecontaining/@id"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="lower-case(translate($pagecontaining/title/text(),' ','-'))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>.html</xsl:text>
                    <xsl:if test="not($linkend=$pagecontaining/@id)">
                        <xsl:text>#</xsl:text>
                        <xsl:value-of select="$linkend"/>
                    </xsl:if>
                </xsl:if>
            </xsl:attribute>
        <xsl:if test="@endterm">
            <xsl:attribute name="title">
                <xsl:variable name="endterm" select="string(@endterm)"/>
                <xsl:value-of select="//title[@id=$endterm][1]/text()"/>
            </xsl:attribute>
        </xsl:if>
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