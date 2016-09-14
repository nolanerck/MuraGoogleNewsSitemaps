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
<cfsilent>
	<!--- headers --->
	<cfset local.timeofday			= rc.sitemapsObject.getExtendedData().getAttribute('timeofday',true,'object')>
</cfsilent><cfoutput>
<!--- global menu --->
<!--- begin content --->
<div id="meld-body">
	<!-- CONTENT HERE -->
	<div id="meld-actions" class="section clearfix">
		#view("settings/includes/default_actions")#
	</div>
	<ul class="metadata">
		<li>
			<strong>#rc.mmRBF.key('sitemapenabled')#:</strong> <cfif rc.sData.enabled>Yes<cfelse>No</cfif>
		</li>
		<li>
			<strong>#rc.mmRBF.key('frequency')#:</strong> #rc.sData.frequency#, #timeFormat(local.timeofday,"hh:mm TT")#
		</li>
		<li>
			<strong>#rc.mmRBF.key('emailnotifications')#:</strong> <cfif len(rc.sData.email)>#rc.sData.email#</cfif>
		</li>
	</ul>
</div>	
<!--- end content --->
</cfoutput> 