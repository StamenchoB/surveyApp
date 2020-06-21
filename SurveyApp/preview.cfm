<cfsetting showDebugOutput="NO">

<cfset encrypted_logout = Encrypt("true","#application.encryptKey#","AES","Hex")>
<!--- <cfset this.loginServices = createObject("component","SurveyApp.components.loginServices")> --->
<cfset this.UserGateway = createObject("component","SurveyApp.gateway.UserGateway") />

<cfset this.SurveysGateway = createObject("component","SurveyApp.gateway.SurveysGateway")>
<cfset this.GeneralQuestionsGateway = createObject("component","SurveyApp.gateway.GeneralQuestionsGateway")>
<cfset this.SpecificQuestionsGateway = createObject("component","SurveyApp.gateway.SpecificQuestionsGateway")>
<cfset this.AnswersGateway = createObject("component","SurveyApp.gateway.AnswersGateway")>
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
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.2/jquery.validate.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.2/additional-methods.js"></script>
	</head>
	<cfif structKeyExists(session,"UserID")>
			<cfif structKeyExists(form,"SUBMIT")>
				<cfset userID = "#session.UserID#">
				<cfset qUser = this.UserGateway.getUsersData(ID = "#userID#")>
				<!--- Check if there is SurveyID and this link was accesed by a url send to their email --->

					<cfif structKeyExists(form,"SurveyID") and form.SurveyID NEQ "">
						<cfset surveyID = "#form.SurveyID#">
						<cfset qSurvey = this.SurveysGateway.getSurveyData(ID = "#surveyID#")>
						<!--- <cfdump var = "#qSurvey#"><cfabort> --->

							<script>
								$(document).ready(function (){
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
							</style>
							<body>

							<!--- Site Wrapper --->
							<div class="d-flex" id="wrapper">
							<!--- Sidebar --->
						    <div class="bg-light border-right main-sidebar" id="sidebar-wrapper">
						      <div class="sidebar-heading"><strong>Questions</strong></div><br /><br />
						      <div class="list-group list-group-flush" id="dropdownQuestions">
								<cfset specifiedQuestions = this.SpecificQuestionsGateway.getQuestionsData(Reference = "#surveyID#")>
						        <!--- <cfdump var="#questions#"><cfabort> --->
						         <cfset qOfferedAnswers = this.OfferedAnswersGateway.getOfferedAnswersData()>
						        <cfset counter = 1>
								<!--- <cfdump var="#counter#"> --->
						        <cfloop query="#specifiedQuestions#">
							        <a href="#<cfoutput>#counter#</cfoutput>" class="list-group-item list-group-item-action bg-light"><cfoutput>#specifiedQuestions.QUESTION#</cfoutput></a>
							        <cfset counter++>
								</cfloop>
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

												<form class="md-form" name="FormQ" id="FormQ" method="POST" action="surveySubmitResponse.cfm">
													<input type="hidden" name="surveyID" value="<cfoutput>#form.SurveyID#</cfoutput>">
													<cfset counter2 = 1>
														<div id="ReferencedQuestions">
															<cfloop query="#specifiedQuestions#">
														        <br /><label id="<cfoutput>#counter2#</cfoutput>"><strong><cfoutput>#specifiedQuestions.QUESTION#</cfoutput></strong></label><br />
														        <cfset questionID2 = "#specifiedQuestions.ID#">
														        <cfif specifiedQuestions.IsYesNo EQ 1>
														        	<cfif structKeyExists(form,"#questionID2#")>
																       <cfif "#Evaluate('form.#questionID2#')#" EQ 1>
																	       <br />
																	        <input type="hidden" name="<cfoutput>#questionID2#</cfoutput>" value="1">
																			<div class="custom-control custom-radio">
																			    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1" checked disabled>
																			    <label>Yes</label>
																		  	</div>
																		  	<div class="custom-control custom-radio">
																			    <input type="radio" class="required"name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0" disabled>
																			    <label>No</label>
																		  	</div>
																		  	<br />
																	   <cfelse>
																	   		<br />
																			<input type="hidden" name="<cfoutput>#questionID2#</cfoutput>" value="0">
																			<div class="custom-control custom-radio">
																			    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1" disabled>
																			    <label>Yes</label>
																		  	</div>
																		  	<div class="custom-control custom-radio">
																			    <input type="radio" class="required"name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0" checked disabled>
																			    <label>No</label>
																		  	</div>
																		  	<br />
																	  	</cfif>
																	<cfelse>
																		<br />
																		<input type="hidden" name="<cfoutput>#questionID2#</cfoutput>" value="0">
																		<div class="custom-control custom-radio">
																		    <input type="radio" class="required" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="1" disabled>
																		    <label>Yes</label>
																	  	</div>
																	  	<div class="custom-control custom-radio">
																		    <input type="radio" class="required"name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="0" disabled>
																		    <label>No</label>
																	  	</div>
																   </cfif>
															    </cfif>
															    <cfif specifiedQuestions.AllowEditor EQ 1>
																    <br />
														        	<textarea class="form-control" rows="4" name="<cfoutput>#questionID2#</cfoutput>" readonly><cfif structKeyExists(form,"#questionID2#")><cfoutput>#Evaluate('form.#questionID2#')#</cfoutput></cfif></textarea>
														        	<br />
																</cfif>
														        <cfif specifiedQuestions.IsMultipleAnswers EQ 1>
																		<cfif specifiedQuestions.IsMultipleChoices EQ 1>
																			 <br />
																			 <cfif structKeyExists(form,"#questionID2#")>
																				 <cfset checkedString = "#Evaluate('form.#questionID2#')#">
																				 <input type="hidden" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#checkedString#</cfoutput>">
																			</cfif>
																			<cfloop query="qOfferedAnswers">
																				<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																					<cfif structKeyExists(form,"#questionID2#")>
																						<cfset checkedValuesArray = ListToArray("#checkedString#",",",false,false)>
																						<!--- <cfdump var = "#checkedValuesArray#"> --->
																						<cfset flag2 = 0>
																						<cfloop array="#checkedValuesArray#" index="i">
																							<cfif "#i#" EQ "#qOfferedAnswers.OfferedAnswer#">
																								<cfset flag2 = 1>
																							</cfif>
																						</cfloop>
																						<cfif flag2 EQ 1>
																							<div class="form-check">
																								 <input class="form-check-input" type="checkbox" checked disabled>
																						 		 <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																							</div><br />
																						<cfelse>
																							<div class="form-check">
																									 <input class="form-check-input" type="checkbox" disabled>
																							 		 <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																								</div><br />
																						</cfif>
																					<cfelse>
																						<div class="form-check">
																							<input type="hidden" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="">
																						  <input class="form-check-input" type="checkbox" id="<cfoutput>#qOfferedAnswers.ID#</cfoutput>" disabled>
																						  <label class="form-check-label" for="<cfoutput>#qOfferedAnswers.ID#</cfoutput>"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></label><br />
																						</div><br />
																					</cfif>
																				</cfif>
																			</cfloop>
																			<br />
																		<cfelse>
																			<cfloop query="qOfferedAnswers">
																				<cfif qOfferedAnswers.QuestionID EQ specifiedQuestions.ID>
																					<cfif "#Evaluate('form.#questionID2#')#" EQ "#qOfferedAnswers.OfferedAnswer#">
																						<br />
																						<div class="custom-control custom-radio">
																							<input type="hidden" name="<cfoutput>#specifiedQuestions.ID#</cfoutput>" value="<cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput>">
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
																			<br />
																		</cfif>
																		<cfif specifiedQuestions.AllowComment>
																			<textarea name="comment<cfoutput>#specifiedQuestions.ID#</cfoutput>" class="form-control" rows="1" readonly><cfif structKeyExists(form,"comment#questionID2#")><cfoutput>#Evaluate('form.comment#questionID2#')#</cfoutput></cfif></textarea>
																		</cfif>
																</cfif>
														        <cfset counter2++>
															</cfloop>
															<br /><br />
														</div>
														<a href="index.cfm"><button class="btn btn-danger">Cancel</button></a>
														<input type="submit" class="btn btn-primary" name="submit" id="submit" value="Submit"><br /><br />
												</form>
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
						<div id="error404Survey" class="alert alert-danger" role="alert" style="text-align:center">
					      <h3>ERROR</h3>
					      <h5>There was an error while loading preview.</h5><br />
					      <p>Try again or contact the administrator</p>
				      </div>
						<!--- <cflocation url="index.cfm" addtoken="false"> --->
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
