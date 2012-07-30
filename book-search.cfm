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

		<!---
		<cfdump var="#aleph#" />
		--->

		<h3>Books in the library</h3>
		<h4>(search: #term#)</h4>
		<cfif #IsDefined('aleph.find.error.XmlText')#>
		No results were retrieved for this search
		<cfelse>

			<cfif NOT IsDefined('count')>
				<cfset CountVar = 1 />
				<cfset i = 1 />
				<cfset range = 5 />
			<cfelse>
				<cfset CountVar = #URL.count# />
				<cfset i = #URL.recnum# />
				<cfset range = #CountVar# + 4 />
			</cfif>
			
			<cfset stacks4 = 'N,O,P,Q,R,S,T,U,V,X,Y,Z' />
			<cfset stacks5 = 'A,B,C,D,E,F,G,H,I,J,K,L,M' />
	<ul data-role="listview" data-inset="true">
		<cftry>
		<cfloop condition="#CountVar# LTE #range#">
		<cfhttp url="http://catalog.umd.edu/X?op=present&set_entry=#i#&set_number=#aleph.find.set_number.XmlText#" />
		<cfset alephRecord = XmlParse(cfhttp.Filecontent) />
		<!---
		<cfdump var="#alephRecord#" />
		<cfoutput>#arrayLen(alephRecord.present.record.metadata.oai_marc.varfield)#</cfoutput>
		--->
			<cfloop from="1" to="#arrayLen(alephRecord.present.record.metadata.oai_marc.varfield)#" index="j">
				<cfif #alephRecord.present.record.metadata.oai_marc.varfield[j].XmlAttributes.id# EQ 245>
					<cfhttp url="http://catalog.umd.edu/X?op=circ-status&sys_no=#alephRecord.present.record.doc_number.XmlText#&library=MAI01" />
					<cfset holdings=XmlParse(cfhttp.Filecontent) />
					<cfloop from="1" to="#arrayLen(holdings['circ-status']['item-data'])#" index="k">
						<cfif #holdings['circ-status']['item-data'][k]['sub-library'].XmlText# EQ 'University of Baltimore' AND #holdings['circ-status']['item-data'][k]['collection'].XmlText# EQ 'Stacks' AND #holdings['circ-status']['item-data'][k]['due-date'].XmlText# EQ 'On Shelf'>
									<cfset titleReverse = '#reverse(alephRecord.present.record.metadata.oai_marc.varfield[j].subfield.XmlText)#' />
									<cfset titleReverse = '#RemoveChars(titleReverse,1,2)#' />
									<cfset title = '#reverse(titleReverse)#' />
									<li data-role="list-divider">#CountVar#: #title#</li>
									<li>
										#holdings['circ-status']['item-data'][k]['due-date'].XmlText#
										<cfset firstLetter = '#left(holdings['circ-status']['item-data'][k]['location'].XmlText,1)#' />
										<cfif #ListContainsNoCase(stacks4, firstLetter)# GT 0>
												(4th floor)
											<cfelseif #ListContainsNoCase(stacks5, firstLetter)# GT 1>
												(5th floor)
										</cfif>
													<br />
										#holdings['circ-status']['item-data'][k]['collection'].XmlText# #holdings['circ-status']['item-data'][k]['location'].XmlText#
									</li>
							<cfset CountVar = CountVar + 1 />
						</cfif>
					</cfloop>	
					
				</cfif>		
			</cfloop>	
		<cfset i = i + 1 />
		</cfloop>
			<cfcatch type="any">
				<cfset end = 'true' />
			</cfcatch>
		</cftry>
	</ul>
			
			<p>
				<cfif IsDefined('URL.term')><a href="javascript: history.go(-1)">Previous</a> | </cfif><cfif NOT IsDefined('end')><a href="?recnum=#i#&count=#CountVar#&term=#term#&type=#type#">Next</a><cfelse>No more records</cfif>
			</p>
		</cfif>
		
		</cfif><!---end if form is submitted--->

		<!--- p>
			<a href="answer.cfm?itemid=callnumbers&categoryid=howdoi">reading call numbers</a>
				<br />
			<a href="catalogAbout.cfm">about this catalog</a>
		</p --->
		<p>
			<a href="">test locator</a>
		</p>
	</div><!---end mobileStyle div--->
<cfinclude template="templates/_footer.cfm" />
</div>
</cfoutput>
<cfinclude template="templates/_close.cfm" />