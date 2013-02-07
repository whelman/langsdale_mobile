<cfinclude template="templates/_head.cfm" />

<cfoutput>
<cfset title = 'UB Book Search' />
<div data-role="page" data-theme="#theme#" data-title="#title#">
	<cfinclude template="templates/_header.cfm" />
	<div data-role="content">		
		
	<cfform id="bookSearchForm" name="bookSearchForm" action="#CGI.SCRIPT_NAME#" method="post" scriptsrc="http://www.ubalt.edu/CFIDE/scripts/">
		
				<select name="type">
					<option value="wrd" selected="selected">Word/s anywhere</option>
					<option value="ttl">Title beginning with...</option>
					<option value="wti">Title word/s</option>
					<option value="aut">Author beginning with...</option>
					<option value="wau">Author word/s</option>
					<option value="sub">Subject beginning with...</option>
					<option value="wsu">Subject word/s</option>
					<option value="lci">Call number</option>
				</select>
				<p>
					<!--- input type="text" name="term" / --->
					<input type="search" name="term" />
					<input type="submit" name="submit" value="Search" />
				</p>
		</cfform>
			
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
		
		<h3 style="color:red;">#term#</h3>
		<br />
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
			
	<ul data-role="listview">
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
						<cfif #holdings['circ-status']['item-data'][k]['sub-library'].XmlText# EQ 'University of Baltimore' AND #holdings['circ-status']['item-data'][k]['collection'].XmlText# EQ 'Stacks - 3rd floor' AND #holdings['circ-status']['item-data'][k]['due-date'].XmlText# EQ 'On Shelf'>
									<cfset titleReverse = '#reverse(alephRecord.present.record.metadata.oai_marc.varfield[j].subfield.XmlText)#' />
									<cfset titleReverse = '#RemoveChars(titleReverse,1,2)#' />
									<cfset title = '#reverse(titleReverse)#' />
									<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-d">#CountVar#. #title#</li>
									<li>
										<a href="book-locator-display.html?cn=#holdings['circ-status']['item-data'][k]['location'].XmlText#&bt=#title#"  data-ajax="false" target="_blank">
										<h3>#holdings['circ-status']['item-data'][k]['location'].XmlText#</h3>
										<p>
											<strong>Status: #holdings['circ-status']['item-data'][k]['due-date'].XmlText#</strong>
										</p>
										<p>Location:  #holdings['circ-status']['item-data'][k]['collection'].XmlText#</p>
										<cfset firstLetter = '#left(holdings['circ-status']['item-data'][k]['location'].XmlText,1)#' />
										</a>
										<!---a href="book-locator-display.html?cn=#holdings['circ-status']['item-data'][k]['location'].XmlText#&bt=#title#"  data-ajax="false">#holdings['circ-status']['item-data'][k]['location'].XmlText#</a --->
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
			<br />
			<p>
				<cfif IsDefined('URL.term')><a href="javascript: history.go(-1)" data-ajax="false">&laquo;&nbsp;Previous</a> | </cfif><cfif NOT IsDefined('end')><a href="?recnum=#i#&count=#CountVar#&term=#term#&type=#type#" data-ajax="false">Next&nbsp;&raquo;</a><cfelse>No more records</cfif>
			</p>
		</cfif>
		
		</cfif><!---end if form is submitted--->

		<!--- p>
			<a href="answer.cfm?itemid=callnumbers&categoryid=howdoi">reading call numbers</a>
				<br />
			<a href="catalogAbout.cfm">about this catalog</a>
		</p --->
	</div><!---end mobileStyle div--->
<cfinclude template="templates/_footer.cfm" />
</div>
</cfoutput>
<cfinclude template="templates/_close.cfm" />