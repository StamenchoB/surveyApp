<cfsetting showDebugOutput="NO">

<cfset encrypted_logout = Encrypt("true","#application.encryptKey#","AES","Hex")>
<!--- <cfset this.loginServices = createObject("component","SurveyApp.components.loginServices")> --->
<cfset this.UserGateway = createObject("component","SurveyApp.gateway.UserGateway") />

<cfset this.SurveysGateway = createObject("component","SurveyApp.gateway.SurveysGateway")>
<cfset this.GeneralQuestionsGateway = createObject("component","SurveyApp.gateway.GeneralQuestionsGateway")>
<cfset this.SpecificQuestionsGateway = createObject("component","SurveyApp.gateway.SpecificQuestionsGateway")>
<cfset this.AnswersGateway = createObject("component","SurveyApp.gateway.AnswersGateway")>
<cfif structKeyExists(session,"userID")>
	<cfset userID = "#session.UserID#">
	<cfset qUser = this.UserGateway.getUsersData(ID = "#userID#")>
	<cfif qUser.Admin EQ 1>
	<!doctype html>
	<html>
	  <head>
		    <meta charset="utf-8">
		    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		    <title>Administrator [Survey Edit]</title>
			<link href="css/indexStyle.css" type="text/css" rel="stylesheet">
			<link href="css/formStyle.css" rel="stylesheet">
			<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
			<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
			<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
			<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
			<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
			<!--- Form Validation --->
			<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.1/dist/jquery.validate.min.js"></script>
			<!--- Redirect Plugin --->
			<script src="https://cdn.rawgit.com/mgalante/jquery.redirect/master/jquery.redirect.js"></script>

		</head>
		<body>
			<script>
				$(document).ready(function (){

					<!--- EditForm Validation --->
						$('#editForm').validate({
						rules: {
							name: "required",
							startDate: "required",
							endDate: "required",
							descriptionShort: "required",
							description: "required",
							thankYouMessage: "required",
							requestedBy: "required",
							active: "required",
							createDate: "required",
							createdBy: "required",
							allowMultiplePeriods: "required",
							questionsPerPage: "required",
							firstnameMandatory: "required",
							lastnameMandatory: "required",
							emailMandatory: "required",
							phoneNumberMandatory: "required",
							organisationMandatory: "required",
							allowAdditionalContactInfo: "required"
						},
						messages: {
							name: "Please fill in the field",
							startDate: "Please fill in the field",
							endDate: "Please fill in the field",
							descriptionShort: "Please fill in the field",
							description: "Please fill in the field",
							thankYouMessage: "Please fill in the field",
							requestedBy: "Please fill in the field",
							active: "Please pick a choice",
							createDate: "Please fill in the field",
							createdBy: "Please fill in the field",
							allowMultiplePeriods: "Please pick a choice",
							questionsPerPage: "Please fill in the field",
							firstnameMandatory: "Please pick a choice",
							lastnameMandatory: "Please pick a choice",
							emailMandatory: "Please pick a choice",
							phoneNumberMandatory: "Please pick a choice",
							organisationMandatory: "Please pick a choice",
							allowAdditionalContactInfo: "Please pick a choice"
						},
						highlight: function (element) {
	           					 $(element).parent().addClass('error')
	       				 },
	        			unhighlight: function (element) {
	           					 $(element).parent().removeClass('error')
	        			}
					});

				});
			</script>
			<style>
				#editForm .error {
   					color: red;
				}
			</style>
			<!--- Site Wrapper --->
				<div class="d-flex" id="wrapper">

				    <!--- Page Content --->
				    <div id="page-content-wrapper">
					<!--- Top navbar --->
				      <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">

				        <div class="collapse navbar-collapse" id="navbarSupportedContent">
					      <ul class="navbar-nav">
						      <button class="btn btn-primary" name="backBtn" id="backBtn" onclick="window.location.href='index.cfm'">Go Back</button>
							</ul>
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
						  <div class="row">
						      <div class="col-sm-9 col-md-7 col-lg-5" style="margin-top:10px;margin-left:32%">
						        <div class="card card-signin my-5">
						          <div class="card-body">
									<cfif structKeyExists(form,"editSurvey") AND form.editSurvey NEQ "">
										<cfset EditSurvey = form.editSurvey>
										<cfset qSurvey = this.SurveysGateway.getSurveyData(Name = "#EditSurvey#")>

										<h3 style="text-align:center"><strong>EDIT SURVEY</strong></h3><br /><br />
										<form name="editForm" id="editForm" method="POST" action="editSurveyForm.cfm" autocomplete="off">
											<input type="hidden" name="SurveyID" value="<cfoutput>#qSurvey.ID#</cfoutput>">
												<div class="form-row">
													<div class="col-md-8 mb-3">
														<label for="name"><strong>Name: </strong></label><br />
														<input class="form-control" type="text" name="name" id="name" value="<cfoutput>#qSurvey.Name#</cfoutput>">
													</div>
												</div>
												<br />
												<div class="form-row">
													<div class="col-md-4 mb-3">
														<label for="startDate"><strong>Start Date: </strong></label><br />
														<input class="form-control" type="date" name="startDate" id="startDate" min='1899-01-01' value="<cfoutput>#qSurvey.StartDate#</cfoutput>">
													</div>
													<div class="col-md-4 mb-3">
														<label for="endDate"><strong>End Date: </strong></label><br />
														<input class="form-control" type="date" name="endDate" id="endDate" min='1899-01-01' value="<cfoutput>#qSurvey.EndDate#</cfoutput>">
													</div>
												</div>
												<label for="descriptionShort"><strong>Description(short): </strong></label><br />
												<textarea name="descriptionShort" id="descriptionShort" rows="4" cols="100"><cfoutput>#qSurvey.DescriptionShort#</cfoutput></textarea>
												<br /><br />
												<label for="description"><strong>Description: </strong></label><br />
												<textarea name="description" id="description" rows="7" cols="100"><cfoutput>#qSurvey.Description#</cfoutput></textarea>
												<br /><br />
												<label for="thankYouMessage"><strong>Thank you message(after submit): </strong></label><br />
												<textarea name="thankYouMessage" id="thankYouMessage" rows="3" cols="100"><cfoutput>#qSurvey.ThankYouMessage#</cfoutput></textarea>
												<br /><br />
												<!--- <div class="form-row">
													<div class="col-md-3 mb-2">
														<label for="requestedBy"><strong>Requested By:</strong></label><br />
														<input class="form-control" type="text" name="requestedBy" id="requestedBy">
													</div>
												</div>
												<br /><br /> --->
												<div class="form-row">
												<div class="col-md-3 mb-2">
														<label for="allowMultiplePeriods"><strong>Allow Multiple Periods: </strong></label><br />
														<select class="custom-select" name="allowMultiplePeriods" id="allowMultiplePeriods">
																<cfif #qSurvey.AllowMultiplePeriods# EQ 1>
																	<option value="1" selected>Allow</option>
		        													<option value="0">Not Allow</option>
																<cfelse>
																	<option value="1">Allow</option>
		        													<option value="0" selected>Not Allow</option>
																</cfif>
														</select>
													</div>
													<div class="col-md-4 mb-2">
														<label for="allowAdditionalContactInfo"><strong>Allow Additional Contact Info: </strong></label><br />
														<select class="custom-select" name="allowAdditionalContactInfo" id="allowAdditionalContactInfo">
																<cfif #qSurvey.AllowAdditionalContactInfo# EQ 1>
																	<option value="1" selected>Allow</option>
		        													<option value="0">Not Allow</option>
																<cfelse>
																	<option value="1">Allow</option>
		        													<option value="0" selected>Not Allow</option>
																</cfif>
														</select>
													</div>
													<div class="col-md-3 mb-4">
														<label for="questionsPerPage"><strong>Question Per Page:</strong></label><br />
														<input class="form-control" type="text" name="questionsPerPage" id="questionsPerPage" value="<cfoutput>#qSurvey.QuestionsPerPage#</cfoutput>">
													</div>
												</div><br /><br />
												<h5><strong>Required Settings</strong></h5>
												<hr>
												<!--- Mandatory Settings --->
												<div class="form-row">
													<div class="col-md-3 mb-2">
														<label for="firstnameMandatory"><strong>Firstname (Required): </strong></label><br />
														<select class="custom-select" name="firstnameMandatory" id="firstnameMandatory">
																<cfif #qSurvey.FirstnameMandatory# EQ 1>
																	<option value="1" selected>Allow</option>
		        													<option value="0">Not Allow</option>
																<cfelse>
																	<option value="1">Allow</option>
		        													<option value="0" selected>Not Allow</option>
																</cfif>
														</select>
													</div>
													<div class="col-md-3 mb-2">
														<label for="lastnameMandatory"><strong>Lastname (Required): </strong></label><br />
														<select class="custom-select" name="lastnameMandatory" id="lastnameMandatory">
																<cfif #qSurvey.LastnameMandatory# EQ 1>
																	<option value="1" selected>Allow</option>
		        													<option value="0">Not Allow</option>
																<cfelse>
																	<option value="1">Allow</option>
		        													<option value="0" selected>Not Allow</option>
																</cfif>
														</select>
													</div>
													<div class="col-md-3 mb-2">
														<label for="emailMandatory"><strong>Email Adress (Required): </strong></label><br />
														<select class="custom-select" name="emailMandatory" id="emailMandatory">
																<cfif #qSurvey.EmailMandatory# EQ 1>
																	<option value="1" selected>Allow</option>
		        													<option value="0">Not Allow</option>
																<cfelse>
																	<option value="1">Allow</option>
		        													<option value="0" selected>Not Allow</option>
																</cfif>
														</select>
													</div>
													<div class="col-md-3 mb-2">
														<label for="phoneNumberMandatory"><strong>Phone Num. (Required) :</strong></label><br />
														<select class="custom-select" name="phoneNumberMandatory" id="phoneNumberMandatory">
																<cfif #qSurvey.PhoneNumberMandatory# EQ 1>
																	<option value="1" selected>Allow</option>
		        													<option value="0">Not Allow</option>
																<cfelse>
																	<option value="1">Allow</option>
		        													<option value="0" selected>Not Allow</option>
																</cfif>
														</select>
													</div>
												</div><br />
												<div class="form-row">
													<div class="col-md-3 mb-2">
														<label for="organisationMandatory"><strong>Organisation (Required) :</strong></label><br />
														<select class="custom-select" name="organisationMandatory" id="organisationMandatory">
																<cfif #qSurvey.OrganisationMandatory# EQ 1>
																	<option value="1" selected>Allow</option>
		        													<option value="0">Not Allow</option>
																<cfelse>
																	<option value="1">Allow</option>
		        													<option value="0" selected>Not Allow</option>
																</cfif>
														</select>
													</div>
												</div>
												<br /><br /><br />
													<button class="btn btn-lg btn-primary btn-block text-uppercase" name="editSumbit" id="submit" type="submit">Update</button>
											</form>
										<br /><br />
										<button class="btn btn-secondary" name="backBtn" id="backBtn" onclick="window.location.href='index.cfm'">Back</button>
										<cfelse>
											<cfif structKeyExists(form,"editSumbit")>
											<!--- 	<cfdump var="#form#"><cfabort> --->
												<!--- Updating Survey --->
												<cfset this.SurveysGateway.updateSurveyData(ID = "#form.SurveyID#",Name = "#form.name#",StartDate = "#form.startDate#",EndDate = "#form.endDate#",
														DescriptionShort = "#form.descriptionShort#",Description = "#form.description#",ThankYouMessage = "#form.thankYouMessage#",
														AllowAdditionalContactInfo = "#form.allowAdditionalContactInfo#",AllowMultiplePeriods = "#form.allowMultiplePeriods#",
														QuestionsPerPage = "#form.questionsPerPage#",FirstnameMandatory = "#form.firstnameMandatory#",LastnameMandatory = "#form.lastnameMandatory#",
														EmailMandatory = "#form.emailMandatory#",PhoneNumberMandatory = "#form.phoneNumberMandatory#",OrganisationMandatory = "#form.organisationMandatory#")>
												<!--- Displaying that the EDIT was Successful --->
												<h3 style="text-align:center;color:green">The survey was successfully Updated.</h3><br />
												<h5 style="text-align:center">You will be redirected to the administrator's page.</h5>
												<script>
													setTimeout(function(){ window.location = "adminPage.cfm" }, 3000);
												</script>
											<cfelse>
												<div id="error404Survey" class="alert alert-danger" role="alert" style="text-align:center">
											      <h3>ERROR</h3>
											      <h5>No Selected Survey for Editing</h5><br />
											      <p>Redirecting to Administrator's Page.</p>
										      	</div>
										      	<script>
													setTimeout(function(){ window.location = "adminPage.cfm" }, 3000);
												</script>
											</cfif>
										</cfif>
									</div>
								</div>
							</div>
						</div>
				    </div>
				    <!--- /Page Content --->

				  </div>
				  <!--- /Wrapper --->

			 	 <!--- For the datepicker --->
				<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
				<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
				<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />


				<!--- For the whole Page --->
				<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-lite/1.1.0/material.min.css">
				<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
				<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
				<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" crossorigin="anonymous">
		</body>
		<cfelse>
			<cflocation url="index.cfm" addtoken="false">
	</cfif>
	<cfelse>
		<cfset accessDenied = Encrypt("true","#application.encryptKey#","AES","Hex")>
		<cflocation url="loginForm.cfm?A=#accessDenied#" addtoken="false">
	</cfif>
</html>