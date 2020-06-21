<cfsetting showdebugoutput="NO">
<cfset encrypted_logout = Encrypt("true","#application.encryptKey#","AES","Hex")>
<cfset this.SurveysGateway = createObject("component","SurveyApp.gateway.SurveysGateway")>
<cfset this.AnswersGateway = createObject("component","SurveyApp.gateway.AnswersGateway")>
<cfset this.GeneralQuestionsGateway = createObject("component","SurveyApp.gateway.GeneralQuestionsGateway")>
<cfset this.SpecificQuestionsGateway = createObject("component","SurveyApp.gateway.SpecificQuestionsGateway")>
<cfset this.UserGateway = createObject("component","SurveyApp.gateway.UserGateway") />

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
	<cfif structKeyExists(session,"userID") AND session.userID NEQ "">
			<!--- Check the url vo ID for a given Survey --->
			<cfif structKeyExists(form,"submit") AND structKeyExists(form,"SurveyID")>
				<cfset surveyID = "#form.SurveyID#">
				<cfset qUser = this.UserGateway.getUsersData(ID = "#session.UserID#")>
				<cfset qSurvey = this.SurveysGateway.getSurveyData(ID = "#surveyID#")>
				<cfset qSpecifiedQuestions = this.SpecificQuestionsGateway.getQuestionsData(Reference = "#surveyID#")>
				<cfset qAnswers = this.AnswersGateway.getAnswersData(SurveyID = "#surveyID#",AnsweredByUserID = "#session.userid#",IsComment = 0)>
				<!--- <cfdump var = "#form#"><cfabort> --->
				<!--- <cfset this.AnswersGateway.storeAnswers(answersForm = form)> --->
				<cfif qUser.Admin NEQ 1>
					<cfloop collection="#form#" item="key">
						<cfif isNumeric("#key#")>
							<cfset check2 = this.SpecificQuestionsGateway.getQuestionsData(ID = "#key#")>
							<cfif check2.recordCount EQ 1>
								<!--- <cfdump var = "#check#"> --->
								<cfset questionID = "#check2.ID#">
								<cfset surveyID = "#surveyID#">
								<cfset answer = "#Evaluate('form.#check2.ID#')#">
								<cfset userID = "#session.userID#">
								<cfset questionAnswered = this.AnswersGateway.getAnswersData(SurveyID = "#surveyID#",QuestionID = "#questionID#",AnsweredByUserID = "#userID#",IsComment = 0)>
								<cfif questionAnswered.recordCount EQ 1 OR questionAnswered.recordCount GT 1>
									<cfset this.AnswersGateway.updateAnswers(QuestionID = "#questionID#",SurveyID = "#surveyID#",Answer = "#answer#",AnsweredByUserID = "#userID#",IsComment = 0)>
								<cfelse>
									<cfset this.AnswersGateway.storeAnswers(QuestionID = "#questionID#",SurveyID = "#surveyID#",Answer = "#answer#",AnsweredByUserID = "#userID#",IsComment = 0)>
								</cfif>

								<cfset commentEntered = this.AnswersGateway.getAnswersData(SurveyID = "#surveyID#",QuestionID = "#questionID#",AnsweredByUserID = "#session.userID#",IsComment = 1)>
								<!--- <cfdump var = "#commentEntered#"> --->
								<cfif commentEntered.recordCount EQ 1>
									<cfset this.AnswersGateway.updateAnswers(QuestionID = "#questionID#",SurveyID = "#surveyID#",Answer = "#Evaluate('comment#questionID#')#",AnsweredByUserID = "#session.userID#",IsComment = 1)>
								<cfelse>
									<cfif structKeyExists(form,"comment#questionID#")>
										<cfset this.AnswersGateway.storeAnswers(QuestionID = "#questionID#",SurveyID = "#surveyID#",Answer = "#Evaluate('comment#questionID#')#",AnsweredByUserID = "#session.userID#",IsComment = 1)>
									</cfif>
								</cfif>
							</cfif>
						<cfelse>

						</cfif>
					</cfloop>
				</cfif>
				<!--- Top navbar --->
				      <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
				        <div class="collapse navbar-collapse" id="navbarSupportedContent">
					        <cfif qUser.Admin EQ 1>
						        <li class="nav-item">
						        	<button name="backBtn" onclick="window.location='adminPage.cfm'" class="btn btn-secondary btn-large">Admin page</button>
								</li>
							</cfif>
				          <ul class="navbar-nav ml-auto mt-2 mt-lg-0">
				            <li class="nav-item">
				              <p class="nav-link disabled"><cfoutput>#qUser.Firstname# #qUser.Lastname#</cfoutput></p>
				            </li>
				            <li class="nav-item">
				              <a class="nav-link"><button name="logoutBtn" id="logoutBtn" onclick="window.location='loginForm.cfm?L=<cfoutput>#encrypted_logout#</cfoutput>'" class="btn btn-dark btn-large">Logout</button></a>
				            </li>
				          </ul>
				        </div>
				      </nav>
				<!--- /Top navbar --->

				    <div class="site-wrapper">
				      <div class="site-wrapper-inner">
				        <div class="cover-container">
							<div calss="jumbotron">
					          <div class="inner cover" >
					            <p class="lead" style="font-size:24px"><cfoutput><strong>#qSurvey.ThankYouMessage#</strong></cfoutput></p>
					            <p class="lead">
					            	<br />
					              	<!--- Download survey answers link PDF --->
					              	<cfset filenameEncrypted = Encrypt("#qUser.Firstname##qUser.Lastname#","#application.encryptKey#","AES","Hex")>
					              	<cfset surveyIDEncrypted = Encrypt("#surveyID#","#application.encryptKey#","AES","Hex")>
					              	<!--- <cfdump var = "#filenameEncrypted#"> --->
					              	<cfset expiration_time = DateAdd("n",20,Now()) />
								    <cfheader name="Expires" value="#expiration_time#">
								    <cfset qAnswersUpdated = this.AnswersGateway.getAnswersData(SurveyID = "#surveyID#",AnsweredByUserID = "#userID#",IsComment = 0)>
								    <cfset qCommentsUpdated = this.AnswersGateway.getAnswersData(SurveyID = "#surveyID#",AnsweredByUserID = "#session.userid#",IsComment = 1)>
								   <!---  <cfcontent type="application/pdf">
									<cfheader name="Content-Disposition" value="inline;filename=review.pdf"> --->
									<cfdocument format="pdf" pagetype="A4" orientation="portrait" filename="C:\ColdFusion2018\cfusion\#qUser.Firstname##qUser.Lastname#.pdf" overwrite="true">
											<div style="font-size:11px">
											  	<cfoutput>
												  <strong>#qUser.Firstname# #qUser.Lastname#</strong><br /><br />
												  <strong>Organisation:</strong> #qUser.Organisation#, #qUser.Country#<br />
												  <strong>E-mail:</strong> #qUser.Email#
												</cfoutput>
											</div>
											<br /><br />
											<cfoutput><h2 style="text-align:center">#qSurvey.Name# Survey</h2></cfoutput>
											<br /><br /><br />
											<p><strong>Your answers from the <cfoutput>#qSurvey.Name#</cfoutput> Survey</strong></p><br />
											<hr><br />
											<cfloop query="#qSpecifiedQuestions#">
										        <p><strong><cfoutput>#qSpecifiedQuestions.Question#</cfoutput></strong></p>
										      	<cfloop query="#qAnswersUpdated#">
											      	<cfif "#qSpecifiedQuestions.ID#" EQ "#qAnswersUpdated.QuestionID#">
												      	<cfif isNumeric(#qAnswersUpdated.Answer#)>
															<cfif #qAnswersUpdated.Answer# EQ 1>
																<p><em>YES</em></p>
															<cfelse>
																<p><em>NO</em></p>
															</cfif>
													     <cfelse>
													     	<p><cfoutput><em>#qAnswersUpdated.Answer#</em></cfoutput></p>
														</cfif>
														<cfif #qAnswersUpdated.Answer# EQ "">
															<p><cfoutput><em>Not Answered</em></cfoutput></p>
														</cfif>
													</cfif>
												</cfloop>
												<cfloop query="qCommentsUpdated">
													<cfif "#qSpecifiedQuestions.ID#" EQ "#qCommentsUpdated.QuestionID#">
														<p><em>Comment:</em></p>
														<p><cfoutput>#qCommentsUpdated.Answer#</cfoutput></p>
													</cfif>
												</cfloop>
												<cfif qUser.Admin EQ 1>
													 <p><cfoutput>ADMINISTRATOR'S ANSWER</cfoutput></p>
												</cfif>
												<br />
											</cfloop>
											<br />
									</cfdocument>
					              	<p>Here is a PDF file with all your answers:</p>
									<button name="pdfBtn" id="pdfBtn" onclick="window.open('http://localhost:8500/SurveyApp/fileDownloadPDF.cfm?FN=<cfoutput>#filenameEncrypted#</cfoutput>&S=<cfoutput>#surveyIDEncrypted#</cfoutput>')" class="btn btn-dark btn-large">Download</button>
					            </p>
					          </div>
							</div>
				        </div>
				      </div>
				    </div>
			<cfelse>
				<div class="site-wrapper">
					<div class="site-wrapper-inner">
				        <div class="cover-container">
							<div calss="jumbotron">
								<div id="error404Survey" class="alert alert-danger" role="alert" style="text-align:center">
							      <h3>ERROR</h3>
							      <h5>An error occured while submiting the form</h5><br />
							      <p>You'll be redirected</p>
							     	<script>
										setTimeout(function(){ window.location = "index.cfm"; }, 3000);
									</script>
						      	</div>
							</div>
						</div>
					</div>
				</div>
			</cfif>
		<cfelse>
			<cfset accessDenied = Encrypt("true","#application.encryptKey#","AES","Hex")>
			<cflocation url="loginForm.cfm?A=#accessDenied#" addtoken="false">
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
