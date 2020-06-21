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
	<script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
	<script src="https://momentjs.com/downloads/moment.js"></script>
	<!--- Jquery UI --->
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet">
	<!--- Form Validation --->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.2/jquery.validate.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.2/additional-methods.js"></script>
	</head>
	<cfif structkeyExists(form,'username') AND structkeyExists(form,"password")>
		<cfset this.loginServices.vallidateUser(form.username,form.password)>
	</cfif>
			<cfif structKeyExists(session,"UserID")>
				<cfset userID = "#session.UserID#">
				<cfset qUser = this.UserGateway.getUsersData(ID = "#userID#")>
				<!--- Check if there is SurveyID and this link was accesed by a url send to their email --->
				<cfif qUser.Admin EQ 0>
					<cfif structKeyExists(session,"SurveyID") and session.SurveyID NEQ "">
						<cfset surveyID = "#session.SurveyID#">
						<cfset qSurvey = this.SurveysGateway.getSurveyData(ID = "#surveyID#")>
						<!--- <cfdump var = "#qSurvey#"><cfabort> --->

						<!--- Getting all the Answers from the current Survey and LoggedIn User --->
						<cfset qAnswers = this.AnswersGateway.getAnswersData(SurveyID = "#surveyID#",AnsweredByUserID = "#userID#",IsComment = 0)>
						<!--- <cfdump var = "#qAnswers#"><cfabort> --->

						<cfset qComments = this.AnswersGateway.getAnswersData(SurveyID = "#surveyID#",AnsweredByUserID = "#userID#",IsComment = 1)>

						<cfset qPeriods = this.PeriodsGateway.getPeriodsData(SurveyID = "#surveyID#",PeriodExpired = 0)>
						<!--- <cfdump var="#qPeriods#"><cfabort> --->

						<!--- Checking the Active Period of the survey --->
						<cfset todayDate = DateFormat(now(),"yyyy-mm-dd")>
						<!--- <cfdump var = "#todayDate#"> --->
						<!--- Making a flag variable to see if there is any active period --->
						<cfset surveyActive = 0>
						<!--- Looping over all the Periods --->
						<cfloop query="#qPeriods#">
							<cfset startDate = "#qPeriods.StartDatePeriod#">
							<cfset endDate = "#qPeriods.EndDatePeriod#">
							<!--- checking if Survey is ACTIVE and the dates of the survey --->
							<cfif startDate LTE todayDate AND endDate GTE todayDate>
								<cfset surveyActive = 1>
								<cfset qCurrentPeriodID = "#qPeriods.ID#">
								<cfset this.SurveysGateway.updateActive(ID = "#qSurvey.ID#")>
							<cfelse>
								<cfif todayDate GT startDate AND todayDate GT endDate>
									<cfset this.PeriodsGateway.updatePeriodExpired(ID = "#qPeriods.ID#")>
								</cfif>
							</cfif>
						</cfloop>
						<cfif #surveyActive# EQ 1>
								<script>
									$(document).ready(function (){

											$("#FormQ").validate({
												errorPlacement: function(error, element) {
										            if (element.attr("type") == "radio" || element.attr("type") == "checkbox") {
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

									 <cfset qCurrentPeriod = this.PeriodsGateway.getPeriodsData(ID = "#qCurrentPeriodID#")>
								    <!--- <cfdump var = "#qCurrentPeriod#"><cfabort> --->
								    <cfset qOfferedAnswers = this.OfferedAnswersGateway.getOfferedAnswersData()>

									<!--- Site Wrapper --->
									<div class="d-flex" id="wrapper">
									<!--- Sidebar --->
								    <div class="bg-light border-right main-sidebar" id="sidebar-wrapper">
								      <div class="sidebar-heading"><strong>Questions</strong></div><br /><br />
								      <div class="list-group list-group-flush" id="dropdownQuestions">
								        <cfset specifiedQuestions = this.SpecificQuestionsGateway.getQuestionsData(Reference = "#surveyID#")>
								        <!--- <cfdump var="#questions#"><cfabort> --->
								        <cfif qCurrentPeriod.ShowPreviousAnswers EQ 1>
									        <cfset counter = 1>
									        <cfloop query="#specifiedQuestions#">
										        <a href="#<cfoutput>#counter#</cfoutput>" class="list-group-item list-group-item-action bg-light"><cfoutput>#specifiedQuestions.QUESTION#</cfoutput></a>
										        <cfset counter++>
											</cfloop>
								        <cfelse>
								        	<cfif qAnswers.recordCount EQ 0>
									        	<cfset counter = 1>
										        <cfloop query="#specifiedQuestions#">
											        <a href="#<cfoutput>#counter#</cfoutput>" class="list-group-item list-group-item-action bg-light"><cfoutput>#specifiedQuestions.QUESTION#</cfoutput></a>
											        <cfset counter++>
												</cfloop>
									        <cfelse>
									        	<a class="list-group-item list-group-item-action bg-light disabled">NO QUESTIONS</a>
											</cfif>
										</cfif>
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
															<!--- Checking if ShowPreviousAnswers is ENABLED and EditPreviousAnswers --->
															<cfif #qCurrentPeriod.ShowPreviousAnswers# EQ 1>
																<!--- <cfset qAnswers = this.AnswersGateway.getAnswersData(SurveyID = "#session.surveyid#",AnsweredByUserID = "#session.userid#",IsComment = 0)> --->
																<!--- Checking if Edit Answers is enabled ---->
																<!--- <cfdump var = "#qAnswers#">
																<cfdump var = "#qAnswers.recordCount#"> --->
																<cfif #qCurrentPeriod.EditPreviousAnswers# EQ 1>
																	<cfif qAnswers.recordCount EQ 0>
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
																	<cfelse>
																	<!--- SHOW PREVIOUS ANSWERS AND EDIT PREVIOUS ANSWERS WITH ANSWERS IN DATABASE --->
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
																						<p class="isMultipleAnswersSign"><em>| Multiple Answers Allowed |</em></p>
																						<br />
																					<cfelse>
																						<p id="<cfoutput>#counter1#</cfoutput>" class="requiredSign"><cfoutput>#specifiedQuestions.Question#</cfoutput></p><br />
																					</cfif>
																					<cfif #specifiedQuestions.IsYesNo# EQ 1>
																						<cfloop query="qAnswers">
																							<cfif qAnswers.QuestionID EQ specifiedQuestions.ID>
																								<cfif "#qAnswers.Answer#" EQ 1>
																									<div class="custom-control custom-radio">
																									    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1"  checked>
																									    <label>Yes</label>
																								  	</div>
																								  	<div class="custom-control custom-radio">
																									    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0">
																									    <label>No</label>
																								  	</div>
																								<cfelse>
																									<div class="custom-control custom-radio">
																									    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1">
																									    <label>Yes</label>
																								  	</div>
																								  	<div class="custom-control custom-radio">
																									    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0"  checked>
																									    <label>No</label>
																								  	</div>
																								</cfif>
																							</cfif>
																						</cfloop>
																					</cfif>
																					<cfif specifiedQuestions.AllowEditor EQ 1>
																						<cfloop query="qAnswers">
																							<cfif qAnswers.QuestionID EQ specifiedQuestions.ID>
																								<textarea name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control required" rows="3"><cfoutput>#qAnswers.Answer#</cfoutput></textarea>
																							</cfif>
																						</cfloop>
																					</cfif>
																					<cfif specifiedQuestions.IsMultipleAnswers EQ 1>
																						<cfif specifiedQuestions.IsMultipleChoices EQ 1>
																								<cfloop query="qOfferedAnswers">
																									<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																										<cfloop query="qAnswers">
																											<cfif "#qAnswers.QuestionID#" EQ "#specifiedQuestions.ID#">
																												<!--- <cfdump var = "#qAnswers.Answer#"> --->
																												<cfset answersenteredList = "#qAnswers.Answer#">
																												<cfset answersEnteredArray = ListToArray("#qAnswers.Answer#",",",false,false)>
																												<cfset flag = 0>
																												<cfloop array="#answersEnteredArray#" index="i">
																													<cfif "#i#" EQ "#qOfferedAnswers.OfferedAnswer#">
																														<cfset flag = 1>
																													</cfif>
																												</cfloop>
																											</cfif>
																										</cfloop>
																										<cfif flag EQ 1>
																											<div class="form-check">
																											  <input name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-check-input required" type="checkbox" id="<cfoutput>#qOfferedAnswers.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" checked>
																											  <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																											</div><br />
																										<cfelse>
																											<div class="form-check">
																											  <input name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-check-input required" type="checkbox" id="<cfoutput>#qOfferedAnswers.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>">
																											  <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																											</div><br />
																										</cfif>
																									</cfif>
																								</cfloop>
																							<cfelse>
																								<cfloop query="qOfferedAnswers">
																									<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																										<cfset flag = 0>
																										<cfloop query="qAnswers">
																											<cfif "#qAnswers.Answer#" EQ "#qOfferedAnswers.OfferedAnswer#">
																												<cfset flag = 1>
																											</cfif>
																										</cfloop>
																										<cfif flag EQ 1>
																											<br />
																											<div class="custom-control custom-radio">
																											    <input class="required" type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" checked>
																											    <label><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label>
																										  	</div>
																										<cfelse>
																											<br />
																											 <div class="custom-control custom-radio">
																											    <input class="required" type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>">
																											    <label><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label>
																										  	</div>
																										</cfif>
																									</cfif>
																								</cfloop>
																							</cfif>
																							<cfif specifiedQuestions.AllowComment EQ 1>
																								<cfloop query="qComments">
																									<cfif qComments.QuestionID EQ specifiedQuestions.ID>
																										<br />
																										<p><em>Comment :</em></p>
																										<textarea name="comment<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control required" rows="1"><cfoutput>#qComments.Answer#</cfoutput></textarea>
																									</cfif>
																								</cfloop>
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
																						<cfloop query="qAnswers">
																							<cfif qAnswers.QuestionID EQ specifiedQuestions.ID>
																								<cfif "#qAnswers.Answer#" EQ 1>
																									<div class="custom-control custom-radio">
																									    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1"  checked>
																									    <label>Yes</label>
																								  	</div>
																								  	<div class="custom-control custom-radio">
																									    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0">
																									    <label>No</label>
																								  	</div>
																								<cfelse>
																									<div class="custom-control custom-radio">
																									    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1">
																									    <label>Yes</label>
																								  	</div>
																								  	<div class="custom-control custom-radio">
																									    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0"  checked>
																									    <label>No</label>
																								  	</div>
																								</cfif>
																							</cfif>
																						</cfloop>
																					</cfif>
																					<cfif specifiedQuestions.AllowEditor EQ 1>
																						<cfloop query="qAnswers">
																							<cfif qAnswers.QuestionID EQ specifiedQuestions.ID>
																								<textarea name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control" rows="3"><cfoutput>#qAnswers.Answer#</cfoutput></textarea>
																							</cfif>
																						</cfloop>
																					</cfif>
																					<cfif specifiedQuestions.IsMultipleAnswers EQ 1>
																						<cfif specifiedQuestions.IsMultipleChoices EQ 1>
																								<cfloop query="qOfferedAnswers">
																									<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																									<cfloop query="qAnswers">
																											<cfif "#qAnswers.QuestionID#" EQ "#specifiedQuestions.ID#">
																												<!--- <cfdump var = "#qAnswers.Answer#"> --->
																												<cfset answersenteredList = "#qAnswers.Answer#">
																												<cfset answersEnteredArray = ListToArray("#qAnswers.Answer#",",",false,false)>
																												<cfset flag = 0>
																												<cfloop array="#answersEnteredArray#" index="i">
																													<cfif "#i#" EQ "#qOfferedAnswers.OfferedAnswer#">
																														<cfset flag = 1>
																													</cfif>
																												</cfloop>
																											</cfif>
																										</cfloop>
																										<cfif flag EQ 1>
																											<div class="form-check">
																											  <input name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-check-input" type="checkbox" id="<cfoutput>#qOfferedAnswers.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" checked>
																											  <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																											</div><br />
																										<cfelse>
																											<div class="form-check">
																											  <input name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-check-input" type="checkbox" id="<cfoutput>#qOfferedAnswers.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>">
																											  <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																											</div><br />
																										</cfif>
																									</cfif>
																								</cfloop>
																							<cfelse>
																								<cfloop query="qOfferedAnswers">
																									<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																										<cfset flag = 0>
																										<cfloop query="qAnswers">
																											<cfif "#qAnswers.Answer#" EQ "#qOfferedAnswers.OfferedAnswer#">
																												<cfset flag = 1>
																											</cfif>
																										</cfloop>
																										<cfif flag EQ 1>
																											<br />
																											<div class="custom-control custom-radio">
																											    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" checked>
																											    <label><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label>
																										  	</div>
																										<cfelse>
																											<br />
																											 <div class="custom-control custom-radio">
																											    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>">
																											    <label><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label>
																										  	</div>
																										</cfif>
																									</cfif>
																								</cfloop>
																							</cfif>
																							<cfif specifiedQuestions.AllowComment EQ 1>
																								<cfloop query="qComments">
																									<cfif qComments.QuestionID EQ specifiedQuestions.ID>
																										<br />
																										<p><em>Comment :</em></p>
																										<textarea name="comment<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control" rows="1"><cfoutput>#qComments.Answer#</cfoutput></textarea>
																									</cfif>
																								</cfloop>
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
																	</cfif>
																<cfelse>
																<!--- SHOW PREVIOUS ANSWERS ENABLED / EDIT PREVOIUS ANSWERS DISABLED WITH NO DATA IN DATABSE ---->
																	<cfif qAnswers.recordCount EQ 0>
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
																	<cfelse>
																		<!--- SHOW PREVIOUS ANSWERS ENABLED / EDIT PREVOIUS ANSWERS DISABLED WITH ANSWERED DATA IN DATABSE ---->
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
																						<p class="isMultipleAnswersSign"><em>| Multiple Answers Allowed |</em></p>
																						<br />
																					<cfelse>
																						<p id="<cfoutput>#counter1#</cfoutput>" class="requiredSign"><cfoutput>#specifiedQuestions.Question#</cfoutput></p><br />
																					</cfif>
																					<cfif #specifiedQuestions.IsYesNo# EQ 1>
																						<cfloop query="qAnswers">
																							<cfif qAnswers.QuestionID EQ specifiedQuestions.ID>
																								<input type="hidden" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qAnswers.Answer#</cfoutput>">
																								<cfif "#qAnswers.Answer#" EQ 1>
																									<div class="custom-control custom-radio">
																									    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1"  checked disabled>
																									    <label>Yes</label>
																								  	</div>
																								  	<div class="custom-control custom-radio">
																									    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0" disabled>
																									    <label>No</label>
																								  	</div>
																								<cfelse>
																									<div class="custom-control custom-radio">
																									    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1" disabled>
																									    <label>Yes</label>
																								  	</div>
																								  	<div class="custom-control custom-radio">
																									    <input type="radio" class="required"name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0"  checked disabled>
																									    <label>No</label>
																								  	</div>
																								</cfif>
																							</cfif>
																						</cfloop>
																					</cfif>
																					<cfif specifiedQuestions.AllowEditor EQ 1>
																						<textarea name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control required" rows="3" readonly><cfloop query="qAnswers"><cfif qAnswers.QuestionID EQ specifiedQuestions.ID><cfoutput>#qAnswers.Answer#</cfoutput></cfif></cfloop></textarea>
																					</cfif>
																					<cfif specifiedQuestions.IsMultipleAnswers EQ 1>
																						<cfif specifiedQuestions.IsMultipleChoices EQ 1>
																								<cfloop query="qOfferedAnswers">
																									<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																									<cfloop query="qAnswers">
																											<cfif "#qAnswers.QuestionID#" EQ "#specifiedQuestions.ID#">
																												<!--- <cfdump var = "#qAnswers.Answer#"> --->
																												<cfset answersenteredList = "#qAnswers.Answer#">
																												<cfset answersEnteredArray = ListToArray("#qAnswers.Answer#",",",false,false)>
																												<cfset flag = 0>
																												<cfloop array="#answersEnteredArray#" index="i">
																													<cfif "#i#" EQ "#qOfferedAnswers.OfferedAnswer#">
																														<cfset flag = 1>
																													</cfif>
																												</cfloop>
																											</cfif>
																										</cfloop>
																										<cfif flag EQ 1>
																											<input type="hidden" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#answersenteredList#</cfoutput>">
																											<div class="form-check">
																											  <input name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-check-input required" type="checkbox" id="<cfoutput>#qOfferedAnswers.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" disabled checked>
																											  <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																											</div><br />
																										<cfelse>
																											<div class="form-check">
																											  <input name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-check-input required" type="checkbox" id="<cfoutput>#qOfferedAnswers.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" disabled>
																											  <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																											</div><br />
																										</cfif>
																									</cfif>
																								</cfloop>
																							<cfelse>
																								<cfloop query="qOfferedAnswers">
																									<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																										<cfset flag = 0>
																										<cfloop query="qAnswers">
																											<cfif "#qAnswers.Answer#" EQ "#qOfferedAnswers.OfferedAnswer#">
																												<cfset flag = 1>
																											</cfif>
																										</cfloop>
																										<cfif flag EQ 1>
																											<input type="hidden" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>">
																											<br />
																											<div class="custom-control custom-radio">
																											    <input class="required" type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" disabled checked>
																											    <label><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label>
																										  	</div>
																										<cfelse>
																											<br />
																											 <div class="custom-control custom-radio">
																											    <input class="required" type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" disabled>
																											    <label><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label>
																										  	</div>
																										</cfif>
																									</cfif>
																								</cfloop>
																							</cfif>
																							<cfif specifiedQuestions.AllowComment EQ 1>
																									<cfloop query="qComments">
																										<cfif qComments.QuestionID EQ specifiedQuestions.ID>
																											<br />
																											<p><em>Comment :</em></p>
																											<textarea name="comment<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control required" rows="1" readonly><cfoutput>#qComments.Answer#</cfoutput></textarea>
																										</cfif>
																									</cfloop>
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
																						<cfloop query="qAnswers">
																							<cfif qAnswers.QuestionID EQ specifiedQuestions.ID>
																								<input type="hidden" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qAnswers.Answer#</cfoutput>">
																								<cfif "#qAnswers.Answer#" EQ 1>
																									<div class="custom-control custom-radio">
																									    <input type="radio"  name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1"  checked disabled>
																									    <label>Yes</label>
																								  	</div>
																								  	<div class="custom-control custom-radio">
																									    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0" disabled>
																									    <label>No</label>
																								  	</div>
																								<cfelse>
																									<div class="custom-control custom-radio">
																									    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1" disabled>
																									    <label>Yes</label>
																								  	</div>
																								  	<div class="custom-control custom-radio">
																									    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0" checked disabled>
																									    <label>No</label>
																								  	</div>
																								</cfif>
																							</cfif>
																						</cfloop>
																					</cfif>
																					<cfif specifiedQuestions.AllowEditor EQ 1>
																						<textarea name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control" rows="3" readonly><cfloop query="qAnswers"><cfif qAnswers.QuestionID EQ specifiedQuestions.ID><cfoutput>#qAnswers.Answer#</cfoutput></cfif></cfloop></textarea>
																					</cfif>
																					<cfif specifiedQuestions.IsMultipleAnswers EQ 1>
																							<cfif specifiedQuestions.IsMultipleChoices EQ 1>
																								<cfloop query="qOfferedAnswers">
																									<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																									<cfloop query="qAnswers">
																											<cfif "#qAnswers.QuestionID#" EQ "#specifiedQuestions.ID#">
																												<cfset answersenteredList = "#qAnswers.Answer#">
																												<!--- <cfdump var = "#answersenteredList#"> --->
																												<cfset answersEnteredArray = ListToArray("#qAnswers.Answer#",",",false,false)>
																												<!--- <cfdump var = "#qAnswers.Answer#"> --->
																												<cfset flag = 0>
																												<cfloop array="#answersEnteredArray#" index="i">
																													<cfif "#i#" EQ "#qOfferedAnswers.OfferedAnswer#">
																														<cfset flag = 1>
																													</cfif>
																												</cfloop>
																											</cfif>
																										</cfloop>
																										<cfif flag EQ 1>
																											<input type="hidden" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#answersenteredList#</cfoutput>">
																											<div class="form-check">
																											  <input name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-check-input required" type="checkbox" id="<cfoutput>#qOfferedAnswers.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" disabled checked>
																											  <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																											</div><br />
																										<cfelse>
																											<div class="form-check">
																											  <input name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-check-input required" type="checkbox" id="<cfoutput>#qOfferedAnswers.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" disabled>
																											  <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																											</div><br />
																										</cfif>
																									</cfif>
																								</cfloop>
																							<cfelse>
																								<cfloop query="qOfferedAnswers">
																									<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																										<cfset flag = 0>
																										<cfloop query="qAnswers">
																											<cfif "#qAnswers.Answer#" EQ "#qOfferedAnswers.OfferedAnswer#">
																												<cfset flag = 1>
																											</cfif>
																										</cfloop>
																										<cfif flag EQ 1>
																											<input type="hidden" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>">
																											<br />
																											<div class="custom-control custom-radio">
																											    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" disabled checked>
																											    <label><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label>
																										  	</div>
																										<cfelse>
																											<br />
																											 <div class="custom-control custom-radio">
																											    <input type="radio" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>" disabled>
																											    <label><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label>
																										  	</div>
																										</cfif>
																									</cfif>
																								</cfloop>
																							</cfif>
																							<cfif specifiedQuestions.AllowComment EQ 1>
																								<cfloop query="qComments">
																									<cfif qComments.QuestionID EQ specifiedQuestions.ID>
																										<br />
																										<p><em>Comment :</em></p>
																										<textarea name="comment<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control" rows="1" readonly><cfoutput>#qComments.Answer#</cfoutput></textarea>
																									</cfif>
																								</cfloop>
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
																	</cfif>
																</cfif>
															<cfelse>
																<!--- IF HE ANSWERED THE SURVEY AND SHOW PREVIOUS ANSWERS IS NOT ENABLED (NOT SHOWING ANSWERS) --->
																<cfif qAnswers.recordCount EQ 0>
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
																<cfelse>
																	 <div id="error404Survey" class="alert alert-success" role="alert" style="text-align:center">
																	      <h3>SURVEY ANSWERED</h3>
																	      <h5>You already answered this Survey</h5><br />
																	      <p>If you want to have option to view your answers or edit them contract the administrator</p>
																      </div>
																</cfif>
															</cfif>
															<!--- <div class="tab-pane" role="tabpanel">
												                <ul>
																	<cfloop query="#specifiedQuestions#">
																		<cfset counter = 1>
																			<cfoutput>
																				<li><label>#specifiedQuestions.Question#</label></li>
																				<br /><br />
																				<li><input class="form-control" type="text" name="#specifiedQuestions.Question#"></li>
																				<br /><br /><hr>
																				<!--- <li><button type="button" class="btn btn-default prev-step">Previous</button></li>
															                    <li><button type="button" class="btn btn-default next-step">Skip</button></li>
															                    <li><button type="button" class="btn btn-primary btn-info-full next-step">Save and continue</button></li> --->
												                    		</cfoutput>
																	</cfloop>
											                    </ul>
											                </div> --->

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
						<!--- Survey is not active or the period of the active suvey is missed --->
						<cfset this.SurveysGateway.updateNotActive(ID = "#surveyID#")>
						<div id="page-content-wrapper">
							<nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">

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
									<div id="error404Survey" class="alert alert-danger" role="alert" style="text-align:center">
									      <h3>ERROR</h3>
									      <h5>Survey no longer <strong>ACTIVE</strong></h5><br />
									      <p>Contact administrator to see if the survey will be activated again in the future.</p>
									</div>
							</div>

						</cfif>
					<cfelse>
					<!--- If a User tries to access the survey not from the provided link --->
						<div id="page-content-wrapper">
							<nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">

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
						      <br /><br />
						      <div id="error404Survey" class="alert alert-danger" role="alert" style="text-align:center">
							      <h3>ERROR</h3>
							      <h5>Survey not found</h5><br />
							      <p>Acces the survey from the provided link.</p>
						      </div>
						</div>
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
	<cfelse>
		<!--- The bottom is the page for the administrator --->
		<cflocation url="adminPage.cfm" addtoken="false">
	</cfif>

<cfelse>
	<cfset accessDenied = Encrypt("true","#application.encryptKey#","AES","Hex")>
	<cflocation url="loginForm.cfm?A=#accessDenied#" addtoken="false">
</cfif>

