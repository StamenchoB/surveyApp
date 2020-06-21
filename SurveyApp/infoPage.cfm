<cfsetting showdebugoutput="no">
<cfset this.SurveysGateway = createObject("component","SurveyApp.gateway.SurveysGateway")>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>Survey</title>

	<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
	<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.4.1.js"></script>

    <!-- Custom styles for this template -->
    <link href="css/infoPage.css" rel="stylesheet">


  </head>

  <body>
	<!--- Check the url vo ID for a given Survey --->
	<cfif structKeyExists(url,"S") AND url.S NEQ "">
		<cfset decrypted_surveyID = Decrypt("#url.S#","#application.encryptKey#","AES","Hex")>
		<!--- <cfdump var = "#decrypted_surveyID#"><cfabort> --->
		<cfset qSurvey = this.SurveysGateway.getSurveyData(ID = "#decrypted_surveyID#")>
		<!--- <cfdump var ="#qSurvey#"><cfabort> --->

	   <div class="site-wrapper">
	      <div class="site-wrapper-inner">
	        <div class="cover-container">
				<div calss="jumbotron">
		          <div class="inner cover">
		            <h1 class="cover-heading">Survey <strong><u><cfoutput>#qSurvey.Name#</cfoutput></u></strong></h1>
		            <br /><br />
		            <p class="lead"><cfoutput>#qSurvey.DescriptionShort#</cfoutput></p>
		            <p class="lead">
						<br /><br />
						<!--- <form name="surveyIDform" id="surveyIDform" method="post" action="loginForm.cfm">
							<input type="hidden" name="surveyID" id="surveyID" value="<cfoutput>#decrypted_surveyID#</cfoutput>">
							<input type="submit" name="submit" id="submit" class="btn btn-lg btn-secondary btn btn-ligh" value="Next">
						</form> --->
		              <a href="loginForm.cfm?S=<cfoutput>#url.S#</cfoutput>" class="btn btn-lg btn-secondary btn btn-ligh">Next</a>
		            </p>
		          </div>
				</div>
	        </div>
	      </div>
	    </div>
	<cfelse>
		<cfif structKeyExists(session,"SurveyID") AND session.SurveyID NEQ "">
			<cfset qSurvey = this.SurveysGateway.getSurveyData(ID = "#session.SurveyID#")>
			<cfset ecnryptSurveyID = Encrypt("#session.SurveyID#","#application.encryptKey#","AES","Hex")>
			<div class="site-wrapper">
		      <div class="site-wrapper-inner">
		        <div class="cover-container">
					<div calss="jumbotron">
			          <div class="inner cover">
			            <h1 class="cover-heading">Survey <strong><u><cfoutput>#qSurvey.Name#</cfoutput></u></strong></h1>
			            <br /><br />
			            <p class="lead"><cfoutput>#qSurvey.DescriptionShort#</cfoutput></p>
			            <p class="lead">
							<br /><br />
							<!--- <form name="surveyIDform" id="surveyIDform" method="post" action="loginForm.cfm">
								<input type="hidden" name="surveyID" id="surveyID" value="<cfoutput>#decrypted_surveyID#</cfoutput>">
								<input type="submit" name="submit" id="submit" class="btn btn-lg btn-secondary btn btn-ligh" value="Next">
							</form> --->
			              <a href="loginForm.cfm?S=<cfoutput>#ecnryptSurveyID#</cfoutput>" class="btn btn-lg btn-secondary btn btn-ligh">Next</a>
			            </p>
			          </div>
					</div>
		        </div>
		      </div>
		    </div>
		<cfelse>
			<script>
				window.location.href = "index.cfm"
			</script>
		</cfif>
	</cfif>
	<!-- Bootstrap core JavaScript
	    ================================================== -->
	    <!-- Placed at the end of the document so the pages load faster -->
	    <script src="https://code.jquery.com/jquery-3.1.1.slim.min.js" integrity="sha384-A7FZj7v+d/sdmMqp/nOQwliLvUsJfDHW+k9Omg/a/EheAdgtzNs3hpfag6Ed950n" crossorigin="anonymous"></script>
	    <script>window.jQuery || document.write('<script src="../../assets/js/vendor/jquery.min.js"><\/script>')</script>
	    <script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb" crossorigin="anonymous"></script>
	    <script src="../../dist/js/bootstrap.min.js"></script>
	    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
	    <script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>
  </body>
</html>
