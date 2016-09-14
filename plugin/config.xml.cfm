<plugin>
<name>Google News Sitemaps</name>
<package>MuraGoogleNewsSitemaps</package>
<directoryFormat>packageOnly</directoryFormat>
<version>1.0.0</version>
<autoDeploy>true</autoDeploy>
<siteid>default</siteid>
<provider>Nolan Erck / Meld Solutions</provider>
<providerURL>http://www.southofshasta.com</providerURL>
<category>Utility</category>
<settings>
</settings>
<scripts></scripts>
<eventHandlers>
	<eventHandler event="onApplicationLoad" component="events.eventHandler" persist="false"/>
</eventHandlers>
<displayobjects location="global">
</displayobjects>
<extensions>
	<extension type="Page" subtype="Default">
		<attributeset name="Google News Sitemaps">
			<attribute name="exclude"
				label="Exclude From News Sitemap"
				hint="Exclude this page from the news sitemap"
				type="SelectBox"
				defaultValue="inherit"
				required="false"
				validation=""
				regex=""
				message=""
				optionList="inherit^no^yes"
				optionLabelList="Inherit^No^Yes" />
			<attribute name="changefrequency"
				label="Change Frequency"
				hint="The change frequency for the page"
				type="SelectBox"
				defaultValue="monthly"
				required="false"
				validation=""
				regex=""
				message=""
				optionList="daily^weekly^monthly^yearly"
				optionLabelList="Daily^Weekly^Monthly^Yearly" />
			<attribute name="priority"
				label="Priority"
				hint="The relative importance of the page to the site"
				type="SelectBox"
				defaultValue="inherit"
				required="false"
				validation=""
				regex=""
				message=""
				optionList="0.1^0.2^0.3^0.4^0.5^0.6^0.7^0.8^0.9^1.0"
				optionLabelList="0.1^0.2^0.3^0.4^0.5^0.6^0.7^0.8^0.9^1.0" />
			<attribute name="genres"
				label="Genres"
				hint="A list of properties characterizing the content of the article."
				type="MultiSelectBox"
				defaultValue=""
				required="false"
				optionList="PressRelease^Satire^Blog^OpEd^Opinion^UserGenerated"
				optionLabelList="Official Press Release^Satire^Blog^Op-Ed^Opinion (not on Op-Ed page)^User-generated newsworthy content" />
			<attribute name="language"
				label="Language"
				hint="ISO 639 Language Code for this publication"
				type="TextBox"
				defaultValue="en"
				required="false" />
			<attribute name="stock_tickers"
				label="Stock Tickers"
				hint="A comma-separated list of up to 5 stock tickers of the companies, mutual funds, or other financial entities that are the main subject of the article."
				type="text"
				defaultValue=""
				required="false" />				
		</attributeset>
	</extension>
	<extension type="Custom" subtype="MeldGoogleNewsSitemaps">
		<attributeset name="MeldGoogleNewsSitemaps">
			<attribute name="Location"
				label="News Sitemap Location"
				type="TextBox"
				defaultValue="site" />
			<attribute name="Frequency"
				label="Frequency"
				type="TextBox"
				defaultValue="weekly" />
			<attribute name="Enabled"
				label="Enabled"
				type="TextBox"
				validation="Numeric"
				defaultValue="0" />
			<attribute name="Email"
				label="Email"
				type="TextBox" />
			<attribute name="DateLastCreate"
				label="DateLastCreate"
				type="TextBox"
				validation="Date" />
			<attribute name="TimeOfDay"
				label="TimeOfDay"
				type="TextBox"
				validation="Date" />
		</attributeset>
	</extension>
</extensions>
</plugin>
