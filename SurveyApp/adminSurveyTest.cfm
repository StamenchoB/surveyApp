	<cfsetting showDebugOutput="NO">

<cfset encrypted_logout = Encrypt("true","#application.encryptKey#","AES","Hex")>
<cfset this.loginServices = createObject("component","SurveyApp.components.loginServices")>

<cfset this.UserGateway = createObject("component","SurveyApp.gateway.UserGateway") />
<cfset this.SurveysGateway = createObject("component","SurveyApp.gateway.SurveysGateway")>
<cfset this.GeneralQuestionsGateway = createObject("component","SurveyApp.gateway.GeneralQuestionsGateway")>
<cfset this.SpecificQuestionsGateway = createObject("component","SurveyApp.gateway.SpecificQuestionsGateway")>
<cfset this.AnswersGateway = createObject("component","SurveyApp.gateway.AnswersGateway")>
<cfset this.PeriodsGateway = createObject("component","SurveyApp.gateway.PeriodsGateway")>
<cfset this.OfferedAnswersGateway = createObject("component","SurveyApp.gateway.OfferedAnswersGateway")>

<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Survey</title>
	<link href="css/indexStyle.css" type="text/css" rel="stylesheet">
	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
	<script src="https://momentjs.com/downloads/moment.js"></script>
	<!--- Jquery UI --->
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet">
	<!--- Form Validation --->
	<!--- <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.1/dist/additional-methods.min.js"></script> --->
	<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.1/dist/jquery.validate.min.js"></script>
	</head>
			<cfif structKeyExists(session,"UserID")>
				<cfset userID = "#session.UserID#">
				<cfset qUser = this.UserGateway.getUsersData(ID = "#userID#")>
				<!--- Check if there is SurveyID and this link was accesed by a url send to their email --->
				<cfif qUser.Admin EQ 1>
					<cfif structKeyExists(form,"surveyID") and form.surveyID NEQ "">
						<cfset surveyID = "#form.surveyID#">
						<cfset qSurvey = this.SurveysGateway.getSurveyData(ID = "#surveyID#")>
						<!--- <cfdump var = "#qSurvey#"><cfabort> --->

						<!--- Getting all the Answers from the current Survey and LoggedIn User --->
						<cfset qAnswers = this.AnswersGateway.getAnswersData(SurveyID = "#surveyID#",AnsweredByUserID = "#surveyID#")>
							<script>
									$(document).ready(function (){

											$("#FormQ").validate({
												errorPlacement: function(error, element) {
										            if (element.attr("type") == "radio") {
										                error.insertBefore(element);
										                error.wrap("<p>");
										            } else {
										                error.insertAfter(element);
										            }
										        }
											});

											$('a[href*="#"]').click(function(){
										        $($(this).attr("href")).effect("highlight", {}, 1500);
										    });
										});
									</script>
									<style>
											.error {
										      color: red;
										   }
											.requiredSign:after {
											    color: #e32;
											    content: ' *';
											    display:inline;

											}
											.isMultipleAnswersSign{
												color:#008000;
											}
									</style>
									<body>
								    <cfset qOfferedAnswers = this.OfferedAnswersGateway.getOfferedAnswersData()>

									<!--- Site Wrapper --->
									<div class="d-flex" id="wrapper">
									<!--- Sidebar --->
								    <div class="bg-light border-right main-sidebar" id="sidebar-wrapper">
								      <div class="sidebar-heading"><strong>Questions</strong></div><br /><br />
								      <div class="list-group list-group-flush" id="dropdownQuestions">
								        <cfset specifiedQuestions = this.SpecificQuestionsGateway.getQuestionsData(Reference = "#surveyID#")>
								        <!--- <cfdump var="#questions#"><cfabort> --->
									        <cfset counter = 1>
									        <cfloop query="#specifiedQuestions#">
										        <a href="#<cfoutput>#counter#</cfoutput>" class="list-group-item list-group-item-action bg-light"><cfoutput>#specifiedQuestions.QUESTION#</cfoutput></a>
										        <cfset counter++>
											</cfloop>
										<!--- <cfdump var="#counter#"> --->

								      </div>
								    </div>
								    <!--- /Sidebar --->

								    <!--- Page Content --->
								    <div id="page-content-wrapper">
									<!--- Top navbar --->
								      <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
								        <button class="btn btn-primary" id="menu-toggle">Questions Overview</button>

								        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
								          <span class="navbar-toggler-icon"></span>
								        </button>

								        <div class="collapse navbar-collapse" id="navbarSupportedContent">
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
										<br /><br />
								      <div class="container-fluid">
										  <div class="page-wrapper bg-gra-03 p-t-45 p-b-50">
											<div class="wrapper wrapper--w790">
												<div class="card card-5" style="width:70%;margin:0 auto">
													<div class="card-body">
															<cfset counter1 = 1>
															<!--- LOADING QUESTIONS --->
															<h3><strong><cfoutput>#qSurvey.Name#</cfoutput></strong></h3>
																<form class="md-form" name="FormQ" id="FormQ" method="POST" action="preview.cfm">
																	<input type="hidden" name="surveyID" value="<cfoutput>#surveyID#</cfoutput>">
																	<h6 style="color:red;text-align:right"> * <span>Required</span></h6>
																	<cfset questionsPerPage = "#qSurvey.QuestionsPerPage#">
																	<!--- <cfdump var = "#questionsPerPage#"><cfabort> --->
																	<br />
																	<cfloop query="specifiedQuestions">
																			<cfif #specifiedQuestions.IsRequired#>
																				<cfif specifiedQuestions.IsMultipleChoices>
																					<p id="<cfoutput>#counter1#</cfoutput>" class="requiredSign"><cfoutput>#specifiedQuestions.Question#</cfoutput></p>
																					<p class="isMultipleAnswersSign" style="padding-left:30px"><em>| Multiple Answers Allowed |</em></p>
																					<br />
																				<cfelse>
																					<p id="<cfoutput>#counter1#</cfoutput>" class="requiredSign"><cfoutput>#specifiedQuestions.Question#</cfoutput></p><br />
																				</cfif>
																				<cfif #specifiedQuestions.IsYesNo# EQ 1>
																					<div class="custom-control custom-radio">
																					    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1">
																					    <label>Yes</label>
																				  	</div>
																				  	<div class="custom-control custom-radio">
																					    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0">
																					    <label>No</label>
																				  	</div>
																				</cfif>
																				<cfif specifiedQuestions.AllowEditor EQ 1>
																					<textarea name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control required" rows="3"></textarea>
																				</cfif>
																				<cfif specifiedQuestions.IsMultipleAnswers EQ 1>
																					<cfif specifiedQuestions.IsMultipleChoices EQ 1>
																						<cfloop query="qOfferedAnswers">
																							<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																								<div class="form-check">
																								  <input name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-check-input required" type="checkbox" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" id="<cfoutput>#qOfferedAnswers.ID#</cfoutput>">
																								  <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																								</div><br />
																							</cfif>
																						</cfloop>
																					<cfelse>
																						<cfloop query="qOfferedAnswers">
																							<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																								<div class="custom-control custom-radio">
																								    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>">
																								    <label><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label>
																							  	</div>
																							</cfif>
																						</cfloop>
																					</cfif>
																					<cfif specifiedQuestions.AllowComment EQ 1>
																						<br />
																						<p><em>Comment :</em></p>
																						<textarea name="comment<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control required" rows="1"></textarea>
																					</cfif>
																				</cfif>
																			<cfelse>
																				<cfif specifiedQuestions.IsMultipleChoices>
																					<p id="<cfoutput>#counter1#</cfoutput>"><cfoutput>#specifiedQuestions.Question#</cfoutput></p>
																					<p class="isMultipleAnswersSign"><em>| Multiple Answers Allowed |</em></p>
																					<br />
																				<cfelse>
																					<p id="<cfoutput>#counter1#</cfoutput>"><cfoutput>#specifiedQuestions.Question#</cfoutput></p><br />
																				</cfif>
																				<cfif #specifiedQuestions.IsYesNo# EQ 1>
																					<div class="custom-control custom-radio">
																					    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1">
																					    <label>Yes</label>
																				  	</div>
																				  	<div class="custom-control custom-radio">
																					    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0">
																					    <label>No</label>
																				  	</div>
																				</cfif>
																				<cfif specifiedQuestions.AllowEditor EQ 1>
																					<textarea name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control" rows="3"></textarea>
																				</cfif>
																				<cfif specifiedQuestions.IsMultipleAnswers EQ 1>
																						<cfif specifiedQuestions.IsMultipleChoices EQ 1>
																							<cfloop query="qOfferedAnswers">
																								<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																									<div class="form-check" style="padding-left:30px">
																									  <input class="form-check-input" type="checkbox" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" id="<cfoutput>#qOfferedAnswers.ID#</cfoutput>">
																									  <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																									</div><br />
																								</cfif>
																							</cfloop>
																						<cfelse>
																							<cfloop query="qOfferedAnswers">
																								<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																									<div class="custom-control custom-radio">
																									    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>">
																									    <label><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label>
																								  	</div>
																								</cfif>
																							</cfloop>
																						</cfif>
																						<cfif specifiedQuestions.AllowComment EQ 1>
																							<br />
																							<p><em>Comment :</em></p>
																							<textarea name="comment<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control" rows="1"></textarea>
																						</cfif>
																				</cfif>
																			</cfif>
																			<br /><br /><br />
																			<cfset counter1 = counter1 + 1>
																	</cfloop>
																	<div id="formBtns" style="float:right">
																		<input type="submit" class="btn btn-primary" name="submit" id="submit" value="Preview"><br /><br />
																	</div>
																</form>
														</div>
													</div>
												</div>
											</div>
									    </div>
								    <br /><br />
								    <!--- /Page Content --->

								  </div>
								  <!--- /Wrapper --->

								<!--- Sidebar Toggle Script --->
								  <script>
								    $("#menu-toggle").click(function(e) {
								      e.preventDefault();
								      $("#wrapper").toggleClass("toggled");
								    });

								  </script>
					<cfelse>
						<cflocation url="adminPage.cfm" addtoken="false">
					</cfif>
			<cfelse>
				<cflocation url="index.cfm" addtoken="false">
			</cfif>
	<cfelse>
		<cfset accessDenied = Encrypt("true","#application.encryptKey#","AES","Hex")>
		<cflocation url="loginForm.cfm?A=#accessDenied#" addtoken="false">
	</cfif>
				<!--- For the datepicker --->
				<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
				<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
				<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />

				<!--- For the whole page --->
				<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-lite/1.1.0/material.min.css">
				<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
				<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
				<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" crossorigin="anonymous">
	  </body>
	</html>
