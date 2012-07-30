<cfinclude template="templates/_head.cfm" />

<cfoutput>
<cfset title = 'UB Book Search' />
<div data-role="page" data-theme="#theme#" data-title="#title#">
	<cfinclude template="templates/_header.cfm" />
	<div data-role="content">		
		
		<cfform id="bookSearchForm" name="bookSearchForm" action="#CGI.SCRIPT_NAME#" method="post" scriptsrc="http://www.ubalt.edu/CFIDE/scripts/">
		
				<select name="type">
					<option value="wrd" selected="selected">word/s anywhere</option>
					<option value="ttl">title beginning with...</option>
					<option value="wti">title word/s</option>
					<option value="aut">author beginning with...</option>
					<option value="wau">author word/s</option>
					<option value="sub">subject beginning with...</option>
					<option value="wsu">subject word/s</option>
					<option value="lci">call number</option>
				</select>
				<p>
					<!--- input type="text" name="term" / --->
					<input type="search" name="term" />
					<input type="submit" name="submit" value="Search" />
				</p>
		</cfform>
<!---
--->	
		<cfif IsDefined('form.term') OR IsDefined('URL.term')>
			<cfif IsDefined('form.term')>
					<cfset term = '#form.term#' />
					<cfset type = '#form.type#' />
				<cfelseif IsDefined('URL.term')>
					<cfset term = '#URL.term#' />
					<cfset type = '#URL.type#' />
			</cfif>
			<cfhttp url="http://catalog.umd.edu/X?op=find&code=#type#&request=#term#&base=UB">
			<cfset aleph=XmlParse(cfhttp.Filecontent) />

		<p>#url#</p>
	</div><!---end mobileStyle div--->
<cfinclude template="templates/_footer.cfm" />
</div>
</cfoutput>
<cfinclude template="templates/_close.cfm" />