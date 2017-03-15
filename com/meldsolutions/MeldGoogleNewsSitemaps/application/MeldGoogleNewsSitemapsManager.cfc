<!---
This file is part of the The Mura Google News Sitemaps Plugin.

The Mura Google News Sitemaps Plugin is licensed under the GPL 2.0 license
Copyright (C) 2016 Nolan Erck (http://www.southofshasta.com/) and Meld Solutions Inc. http://www.meldsolutions.com/

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation, version 2 of that license..

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 --->
<cfcomponent displayname="MeldGoogleNewsSitemapsManager" output="false" hint="Main Manager">

	<cfset variables.instance = StructNew()>

	<cffunction name="init" returntype="MeldGoogleNewsSitemapsManager" access="public" output="false">
		<cfargument name="MeldGoogleConfig" type="any" required="true">

		<cfset variables.MeldGoogleConfig = arguments.MeldGoogleConfig />

		<cfset structAppend(variables.instance,structCopy(variables.MeldGoogleConfig.getAllValues()),true) />
		<cfset structAppend(variables,structCopy(variables.MeldGoogleConfig.getAllValues()),true) />

		<cfreturn this>
	</cffunction>

	<cffunction name="getSitemapXML" returntype="xml" access="public" output="false">
		<cfargument name="$" type="any" required="true" />
		<cfargument name="siteID" type="string" required="false" />

		<cfreturn xmlParse( getSiteMap( argumentCollection=arguments ) ) />
	</cffunction>


	<cffunction name="getSitemap" returntype="string" access="public" output="false">
		<cfargument name="$" type="any" required="true" />
		<cfargument name="siteID" type="string" required="false" />

		<cfset var useSiteID	= iif( structKeyExists(arguments,"siteID"),de(arguments.siteID),de($.event('siteID')) ) />
		<cfset var qAtts		= "" />
		<cfset var qList		= "" />
		<cfset var qValues		= "" />
		<cfset var sValues		= StructNew() />
		<cfset var xmlStr		= "" />
		<cfset var isExempt		= false />
		<cfset var strXML		= "" />
		<cfset var strXMLBlock	= "" />
		<cfset var sitemapXML 	= XmlNew(true)>
		<cfset var exemptHash	= StructNew()>
		<cfset var valueHash	= StructNew()>
		<cfset var siteProtocol = $.getBean('settingsManager').getSite(arguments.siteID).getUseSSL() ? 'https://' : 'http://'>
		
		<cfset var todaysDate = CreateODBCDateTime( Now() ) />
		<cfset var twoDaysAgo = DateAdd( "d", -2, todaysDate ) />
		
		<cfset var sitemapsObject		= createObject("component","mura.extend.extendObject").init(Type="Custom",SubType="MeldGoogleNewsSitemaps",SiteID = arguments.siteID)>
		
		<cfset sitemapsObject.setType( "Custom" )>
		<cfset sitemapsObject.setSubType( "MeldGoogleNewsSitemaps" )>
		<cfset sitemapsObject.setSiteID( arguments.siteID )>
		<cfset sitemapsObject.setID( arguments.siteID ) />	
		<cfset sitemapsObject.getAllValues() />
		
		<cfset var lstExcludedSubtypes = sitemapsObject.getValue( 'ListExcludedSubtypes' ) />

		<cfif useSiteID neq arguments.$.event().getValue('siteid')>
			<cfset arguments.$ = application.serviceFactory.getBean('muraScope').init(useSiteID) />
		</cfif>

<cfsavecontent variable="strXML"><cfoutput><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
xmlns:news="http://www.google.com/schemas/sitemap-news/0.9"></cfoutput></cfsavecontent>

		<cfquery name="qAtts" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			SELECT
				tclassextenddata.baseID,tclassextenddata.attributeID,tclassextenddata.attributeValue,tclassextendattributes.name
			FROM
				tclassextenddata
			JOIN
				tclassextendattributes
				ON
					tclassextendattributes.attributeID = tclassextenddata.attributeID
			JOIN
				tclassextendsets
				ON
					tclassextendsets.extendSetID = tclassextendattributes.extendSetID
			JOIN
				tclassextend
				ON
					tclassextend.subTypeID = tclassextendsets.subTypeID
				AND
					tclassextend.subtype = 'Default'
			AND
				(
					tclassextend.type = 'Page'
<!---				OR
					tclassextend.type = 'Portal'
				OR
					tclassextend.type = 'Folder'
				OR
					tclassextend.type = 'Calendar'
				OR
					tclassextend.type = 'Gallery'
				OR
					tclassextend.type = 'File'--->
				)
			WHERE
				tclassextendattributes.siteid = <cfqueryparam value="#useSiteID#" cfsqltype="cf_sql_varchar" maxlength="25">
			AND
				tclassextenddata.baseID != <cfqueryparam value="#useSiteID#" cfsqltype="cf_sql_varchar" maxlength="25">
		</cfquery>

		<cfquery name="qList" datasource="#variables.dsn#" username="#variables.dsnusername#" password="#variables.dsnpassword#">
			SELECT tcontent.title, 
				   tcontent.contentID, 
				   tcontent.contentHistID,
				   tcontent.filename,
				   tcontent.lastupdate,
				   tclassextenddata.attributeValue AS isExclude,
				   tcontent.path,
				   tcontent.ReleaseDate,
				   tcontent.metakeywords,
				   tcontent.displaystart
			FROM
				tcontent
			JOIN
				tclassextend
				ON
					tclassextend.siteID = <cfqueryparam value="#useSiteID#" cfsqltype="cf_sql_varchar" maxlength="25">
				AND
					tcontent.type = tclassextend.type
				AND
					tclassextend.subtype = 'Default'
			JOIN
				tclassextendsets
				ON
					( tclassextend.subTypeID = tclassextendsets.subTypeID
					AND tclassextendsets.name = 'Google News Sitemaps' )					
			JOIN
				tclassextendattributes
				ON
					tclassextendsets.extendsetID = tclassextendattributes.extendsetID
				AND
					tclassextendattributes.name = 'newsxml_exclude'
			LEFT JOIN
				tclassextenddata
				ON
					tclassextendattributes.attributeID = tclassextenddata.attributeID
				AND
					tclassextenddata.baseID = tcontent.contentHistID
			WHERE
				tcontent.siteid = <cfqueryparam value="#useSiteID#" cfsqltype="cf_sql_varchar" maxlength="25">
			AND
				(
					tclassextend.type = 'Page'
<!---				OR
					tclassextend.type = 'Portal'
				OR
					tclassextend.type = 'Folder'
				OR
					tclassextend.type = 'Calendar'
				OR
					tclassextend.type = 'Gallery'
				OR
					tclassextend.type = 'File'--->
				)
			AND
				tcontent.approved = 1
			AND
				tcontent.active = 1
			AND
			(
				( 
					   tcontent.display = 1 
					OR tcontent.display = 2 
				)
				AND 
				(
					<!--- Google news feed rules say we should only include the last 2 days worth of "stuff" --->
				    tcontent.ReleaseDate <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#todaysDate#" />
					AND tcontent.ReleaseDate >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#twoDaysAgo#" />
				)
			)
			<cfif Len( lstExcludedSubtypes )>
				AND tcontent.subtype NOT IN ( #ListQualify( lstExcludedSubtypes, "'" )# )
			</cfif>
		</cfquery>

		<cfloop query="qList">
			<cfset sValues = StructNew() />
			<cfif len(qList.isExclude)>
				<cfif qList.isExclude eq 'inherit'>
					<cfif qList.path eq qList.contentID>
						<cfset isExempt = qList.contentHistID />
					<cfelse>
						<cfset isExempt = getInherit( qAtts,qList,qList.path,exemptHash )>
					</cfif>
				<cfelseif qList.isExclude eq 'no'>
					<cfset isExempt = false />
					<cfset sValues = getValues( qAtts,qList.contentHistID,valueHash ) />
				<cfelse>
					<cfset isExempt = true />
				</cfif>
			<cfelse>
				<cfset isExempt = getInherit( qAtts,qList,qList.path,exemptHash )>
			</cfif>

			<cfif isExempt eq true>
				<!--- skip, do nothing --->
			<cfelseif isExempt eq false>
				<cfset sValues = getValues( qAtts,qList.contentHistID,valueHash ) />
			<cfelse>
				<cfset sValues = getValues( qAtts,isExempt,valueHash ) />
			</cfif>

			<cfif not StructKeyExists( sValues,'newsxml_priority' )>
				<cfset sValues.newsxml_priority = "0.5" />
			</cfif>
			<cfif not StructKeyExists( sValues,'newsxml_changefrequency' )>
				<cfset sValues.newsxml_changefrequency = "monthly" />
			</cfif>
			<cfif not StructKeyExists( sValues,'newsxml_language')>
				<cfset sValues.newsxml_language = 'en' />
			</cfif>
			<cfif not StructKeyExists( sValues, 'newsxml_genres' )>
				<cfset sValues.newsxml_genres = "" />
			</cfif>
			<cfif not StructKeyExists( sValues, 'newsxml_stock_tickers' )>
				<cfset sValues.newsxml_stock_tickers = "" />
			</cfif>			

			<!--- Properly formatted "Titles" cannot include any trailing parentheticals, so lop it off if it exists.
			      (There's probably a cleaner way to do this with RegEx.) --->
			<cfset var formattedTitle = "" />
			<cfif Right( qList.title, 1 ) eq ")">
				<cfset formattedTitle = Mid( qlist.title, 1, FindNoCase( "(", qList.title ) - 1 ) />
			<cfelse>
				<cfset formattedTitle = qList.title /> 
			</cfif>

			<cfif isExempt neq true>
				<!--- Normally I'd probably "minify" the XML file to get rid of extra whitespace, but since there are several if/else statements in here for the optional fields,
				      I think it's better to make the code easier to read rather than worry about whitepace in an XML file that's only ready by a site crawler engine. --->
				<cfsavecontent variable="strXMLBlock">
					<cfoutput>
						<url>
							<loc>#siteProtocol##arguments.$.getBean('settingsManager').getSite(arguments.siteID).getDomain()##arguments.$.globalConfig().getContext()##arguments.$.getContentRenderer().getURLStem(useSiteID,qList.filename)#</loc>
							<news:news>
								<news:publication>
									<news:name>#formattedTitle#</news:name>
									<news:language>#sValues.newsxml_language#</news:language>
								</news:publication>
								<cfif Len( sValues.newsxml_genres )>
									<news:genres>#sValues.newsxml_genres#</news:genres>
								</cfif>
								
								<news:publication_date>#DateFormat( qList.ReleaseDate, "yyyy-mm-dd" )#</news:publication_date>
								
								<news:title>#qList.title#</news:title>
								<cfif Len( Trim( qList.metakeywords ) )>
									<news:keywords>#qList.metakeywords#</news:keywords>
								</cfif>
								<cfif Len( Trim( sValues.newsxml_stock_tickers ) )>	
									<news:stock_tickers>#sValues.newsxml_stock_tickers#</news:stock_tickers>
								</cfif>
							</news:news>
						</url>
					</cfoutput>
				</cfsavecontent>
				<cfset strXML = strXML & strXMLBlock />
			</cfif>
		</cfloop>

		<cfset strXML = strXML & "
</urlset>" />
		<cfreturn trim(strXML) />
	</cffunction>

	<cffunction name="getValues" returntype="Struct" access="public" output="false">
		<cfargument name="qAtts" type="query" required="true" />
		<cfargument name="contentHistID" type="string" required="true" />
		<cfargument name="valueHash" type="struct" required="true" />

		<cfset var qValues	= "" />
		<cfset var sValues	= StructNew() />

		<cfquery name="qValues" dbtype="query">
			SELECT
				attributeValue,name
			FROM
				arguments.qAtts
			WHERE
				baseID = <cfqueryparam value="#arguments.contentHistID#" cfsqltype="cf_sql_varchar" maxlength="35">
		</cfquery>

		<cfif qValues.RecordCount>
			<cfloop query="qValues">
				<cfset sValues[qValues.name] = qValues.attributeValue />
			</cfloop>
		</cfif>

		<cfreturn sValues />
	</cffunction>

	<cffunction name="getInherit" returntype="string" access="public" output="false">
		<cfargument name="qAtts" type="query" required="true" />
		<cfargument name="qList" type="query" required="true" />
		<cfargument name="contentHistIDList" type="string" required="true" />
		<cfargument name="exemptHash" type="struct" required="true" />

		<cfset var aIDList		= listToArray( arguments.contentHistIDList ) />
		<cfset var iiX			= "" />
		<cfset var qContentID	= "" />
		<cfset var qStatus		= "" />
		<cfset var isExempt		= "" />

		<cfloop from="#ArrayLen(aIDList)#" to="1" step="-1" index="iiX">
			<cfif StructKeyExists( exemptHash,aIDList[iiX] )>
				<cfset isExempt = exemptHash[ aIDList[iiX] ] />
			<cfelse>
				<cfquery name="qContentID" dbtype="query" maxrows="1">
					SELECT
						contentHistID
					FROM
						arguments.qList
					WHERE
						contentID = <cfqueryparam value="#aIDList[iiX]#" cfsqltype="cf_sql_varchar" maxlength="35">
				</cfquery>
				<cfquery name="qStatus" dbtype="query" maxrows="1">
					SELECT
						attributeValue AS isExclude
					FROM
						arguments.qAtts
					WHERE
						baseID = <cfqueryparam value="#qContentID.contentHistID#" cfsqltype="cf_sql_varchar" maxlength="35">
					AND
						name = 'newsxml_exclude'
				</cfquery>
				<cfif qStatus.recordCount>
					<cfset exemptHash[ aIDList[iiX] ] = qStatus.isExclude />
				<cfelse>
					<cfset exemptHash[ aIDList[iiX] ] = "null" />
				</cfif>
			</cfif>

			<cfset isExempt = exemptHash[ aIDList[iiX] ] />

			<cfif isExempt neq "null">
				<cfif isExempt eq 'Yes'>
					<cfreturn true />
					<cfbreak />
				<cfelseif isExempt eq 'No'>
					<cfreturn isExempt />
					<cfbreak />
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn false />
	</cffunction>

	<cffunction name="setValue" access="public" output="false" returntype="any">
		<cfargument name="key" type="string" required="true">
		<cfargument name="value" type="any" required="true">

		<cfset variables.instance[lcase(arguments.key)] = arguments.value />
	</cffunction>


	<cffunction name="removeValue" access="public" output="false" returntype="any">
		<cfargument name="key" type="string" required="true">
		<cfargument name="value" type="any" required="true">

		<cfset structDelete(variables.instance,arguments.key) />
	</cffunction>

	<cffunction name="getValue" access="public" output="false" returntype="any">
		<cfargument name="key" type="string" required="true">

		<cfif structkeyexists( variables.instance,arguments.key)>
			<cfreturn variables.instance[arguments.key] />
		</cfif>

		<cfreturn "" />
	</cffunction>

	<cffunction name="setValues" access="public" output="false" returntype="any">
		<cfargument name="valueStruct" type="struct" required="true">

		<cfset structAppend(variables.instance,structCopy(arguments.valueStruct),true) />

		<cfreturn this />
	</cffunction>

	<cffunction name="getAllValues" access="public" output="false" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>

</cfcomponent>
