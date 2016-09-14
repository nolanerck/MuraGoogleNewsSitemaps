<cfsilent>
	<!--- headers --->
	<cfoutput>
	</cfoutput>
</cfsilent><cfoutput>
<!--- global menu --->
<!--- begin content --->
<div id="meld-body">
	<!-- CONTENT HERE -->
<h3>About Mura Google News Sitemaps</h3>
<p>Mura Google News Sitemaps adds automated Google News sitemap generation to your Mura CMS website.</p>

<h3><strong>Status: </strong> <cfif structKeyExists(rc.settings,"enabled") and rc.settings.enabled eq true>Enabled<cfelse><div style="display: inline;color: ##800000;font-weight: bold">Auto-generation disabled</div></cfif></h3>

<h4>Functionality</h4>
<p>Mura Google News Sitemaps automatically generates a Google sitemap_news.xml file by using the configuration information found under the &quot;Extended Attributes&quot; tab for a Mura page.
These settings are:</p>
<ul>
  <li><strong>Exclude From News Sitemap</strong>
    <ul>
      <li><em>Inherit: </em>will travel up the parent pages until it finds a page that indicates whether to include or exclude the page</li>
      <li><em>Yes</em>: will exclude this page from the news sitemap</li>
      <li><em>No:</em> will not exclude the page from the news sitemap</li>
    </ul>
  </li>
  <li><strong>Change Frequency</strong>
    <ul>
      <li>A news sitemap-specific setting, indicating how often the page content gets updated</li>
    </ul>
  </li>
  <li><strong>Priority</strong>
    <ul>
      <li>A news sitemap-specific setting, telling the search engine how important this page is <em>relative to </em>other pages on your site</li>
    </ul>
  </li>
</ul>
<p>To enable news sitemap generation for a site, click on the <em>Settings</em> menu item, then <em>Edit Settings.</em></p>
<ul>
  <li><strong>News Sitemap Enabled</strong> 
    <ul>
      <li>The news sitemap will be generated on a scheduled basis</li>
    </ul>
  </li>
  <li><strong>Location</strong></li>
  <ul>
    <li><em>Web Root:</em> The news sitemap will be located in the base of the web site (do not use if you have multiple sites setup in Mura)</li>
    <li><em>Site Folder: </em>The news sitemap will be located in the site folder, i.e. /default/sitemap_news.xml</li>
  </ul>
  <li><strong>Frequency</strong>
    <ul>
      <li>How often the news sitemap will be automatically generated</li>
    </ul>
  </li>
  <li><strong>Time of Day</strong>
    <ul>
      <li>The time of day the news sitemap will be generated</li>
    </ul>
  </li>
  <li><strong>Email</strong>
    <ul>
      <li>If you want to be notified of when a news sitemap is generated, enter an Email address here (and ensure your Mura Email settings are configured properly)</li>
    </ul>
  </li>
</ul>
<h4>How It Works </h4>
<p>By definition (noted here: https://support.google.com/news/publisher/answer/74288?hl=en), the Google News sitemap should only store content that was created in the last 48 hours.</p>
<p>In Mura, each Page has an "Official Release Date" field which notes the date of publication.  This plugin will look at the Official Release Date for site content and use that to determine which information is added to the News Sitemap XML file.  By default this field is left blank; it may be convenient to add the following to your eventHander.cfc:
<br />
<pre>
&lt;cffunction name="onBeforePageArticleSave" access="public" output="false" returntype="any"&gt;
	&lt;cfargument name="$" /&gt;
		
	&lt;cfset var newContentBean 		 = $.event( "newBean" ) /&gt;
	&lt;cfset var releaseDate = newContentBean.get( "releaseDate" ) /&gt;
		
	&lt;cfif Len( Trim( releaseDate ) ) eq 0&gt;
		&lt;cfset newContentBean.set( "releaseDate", dateFormat( now(), "long" ) ) /&gt;
	&lt;/cfif&gt;
		
&lt;/cffunction&gt;	
</pre>
</p>  
<p>Mura Google News Sitemaps creates a scheduled task that will move through your Mura CMS pages and add pages to the sitemap_news.xml file according to the settings set in the
<em>Extended Attributes</em> tab. </p>
<p>Note that it is a good idea (though not strictly necessary) to register your Google News sitemap with search engines. To do this with Google, for instance, visit Google's
<a href="http://www.google.com/webmasters/tools/" target="_blank">Webmaster/Site owner tools</a>.</p>
<p>&nbsp;</p>


</div>	
<!--- end content --->
</cfoutput> 