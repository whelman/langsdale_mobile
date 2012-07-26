
<cfoutput>

	<div data-role="page" id="index">

		<div data-role="header" data-position="fixed" id="my_header">
			<a href="index.html" data-role="button" data-inline="true" data-icon="arrow-l" data-ajax="false">Back</a>
			<h1>Feedback Submitted!</h1>
		</div><!-- /header -->

		<div data-role="content">

			<p>&nbsp;</p>
			<p>&nbsp;</p>
				<div class="ui-body ui-body-d ui-corner-all">
					<h2>Thank you for your feedback!</h2>
					<p>The following has been submitted to staff at Langsdale Library.</p>
					<p>
	         			<strong>Name:</strong>	#form.name# <br/>
		         		<strong>Email address:</strong> #form.email# <br/>		
						<strong>Comments:</strong>	#form.comments# 
		       		</p>
				</div>

		</div><!-- /content -->
		
			<div data-role="footer" data-position="fixed">
				<div data-role="navbar">
					<ul>
						<li><a href="index.html" data-icon="home" class="ui-btn-active" data-ajax="false">Home</a></li>
						<li><a href="http://langsdale.ubalt.edu" data-icon="grid" data-ajax="false">Full site</a></li> 
					</ul>
				</div><!-- /navbar -->
			</div><!-- /footer -->

	</div><!-- /page -->			
				
</cfoutput>
		
<cfmail to="whelman@ubalt.edu" from="#form.Email#" subject="Mobile Feedback from #form.Name#" type="html">
	<p>
		<strong>Name:</strong>	#form.name# <br/>
	    <strong>Email address:</strong> #form.email# <br/>			
		<strong>Comments:</strong>	#form.comments# 
	</p>
</cfmail>
	   