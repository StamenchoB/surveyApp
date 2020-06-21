<cfsetting showDebugOutput="no">

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
		    <title>Administrator [Survey Create]</title>
			<link href="css/indexStyle.css" type="text/css" rel="stylesheet">
			<link href="css/formStyle.css" rel="stylesheet">
			<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
			<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
			<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
			<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
			<!--- Form Validation --->
			<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.1/dist/jquery.validate.js"></script>
			<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.1/dist/additional-methods.min.js"></script>
			<!--- Jquery Redirect --->
			<script src="https://cdn.rawgit.com/mgalante/jquery.redirect/master/jquery.redirect.js"></script>
			<!--- Jquery Confirm,Alert... Plugin --->
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
			<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>

			<script>
				$(document).ready(function (){
					$("#createForm").validate({
					rules: {
						name:"required",
						startDate:"required",
						endDate:{
								required:true,
								greaterThan: "#startDate"
						},
						descriptionShort:"required",
						description:"required",
						thankYouMessage:"required",
						RequestedBy:"required",
						requestedBy:"required",
						allowMultiplePeriods:"required",
						allowAdditionalContactInfo:"required",
						questionsPerPage:"required",
						firstnameMandatory:"required",
						lastnameMandatory:"required",
						emailMandatory:"required",
						phoneNumberMandatory:"required",
						organisationMandatory:"required",
						editPreviousAnswers:"required",
						showPreviousAnswers:"required"

					},
					messages: {
						name:"Please fill in this field",
						startDate:"Please fill in this field",
						endDate: {
								required:"Please fill in this field",
								greaterThan:"End Date must be grater than the Start Date"
						},
						descriptionShort:"Please fill in this field",
						description:"Please fill in this field",
						thankYouMessage:"Please fill in this field",
						RequestedBy:"Please fill in this field",
						requestedBy:"Please fill in this field",
						allowMultiplePeriods:"Please fill in this field",
						allowAdditionalContactInfo:"Please fill in this field",
						questionsPerPage:"Please fill in this field",
						firstnameMandatory:"Please fill in this field",
						lastnameMandatory:"Please fill in this field",
						emailMandatory:"Please fill in this field",
						phoneNumberMandatory:"Please fill in this field",
						organisationMandatory:"Please fill in this field",
						showPreviousAnswers:"Please fill in this field",
						editPreviousAnswers:"Please fill in this field"
					},
					highlight: function (element) {
           					 $(element).parent().addClass('error')
       				 },
        			unhighlight: function (element) {
           					 $(element).parent().removeClass('error')
        			}
				});

				var today = new Date();
				var dd = today.getDate();
				var mm = today.getMonth()+1; //January is 0!
				var yyyy = today.getFullYear();
				 if(dd<10){
				        dd='0'+dd
				    }
				    if(mm<10){
				        mm='0'+mm
				    }

				today = yyyy+'-'+mm+'-'+dd;
				console.log(today);
				document.getElementById("startDate").setAttribute("min", today);
				document.getElementById("endDate").setAttribute("min", today);
			});
			</script>
			<style>
				#createForm .error {
   					color: red;
				}
			</style>
		</head>
		<body>

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

				      <div class="container-fluid">
						  <div class="row">
						      <div class="col-sm-9 col-md-7 col-lg-5" style="margin-top:10px;margin-left:32%">
						        <div class="card card-signin my-5">
						          <div class="card-body">
									<cfif structKeyExists(form,"CreateSubmit")>
											<!--- Creating a new survey in database --->
											<cfset this.SurveysGateway.createSurveyData(Name = "#form.name#",StartDate = "#form.startDate#",EndDate = "#form.endDate#",DescriptionShort = "#form.descriptionShort#",Description = "#form.description#",
														ThankYouMessage = "#form.thankYouMessage#",CreatedBy = "#session.userID#",
														AllowMultiplePeriods = "#form.allowMultiplePeriods#",QuestionsPerPage = "#form.questionsPerPage#",
														FirstnameMandatory = "#form.firstnameMandatory#",LastnameMandatory = "#form.lastnameMandatory#",EmailMandatory = "#form.emailMandatory#",
														PhoneNumberMandatory = "#form.phoneNumberMandatory#",OrganisationMandatory = "#form.organisationMandatory#",AllowAdditionalContactInfo = "#form.allowAdditionalContactInfo#",
														ShowPreviousAnswers = 0,EditPreviousAnswers = 0)>

											<cfset qCreatedSurvey = this.SurveysGateway.getSurveyData(Name = "#form.Name#",DescriptionShort = "#form.DescriptionShort#",Description = "#form.Description#",ThankYouMessage = "#form.ThankYouMessage#")>
											<cfif qCreatedSurvey.recordCount GT 1>
												<script>
													$.confirm({
													    title: 'Survey [DUPLICATE]',
													    content: "There is already a like this one in our database",
													    buttons: {
													        info: {
													        	text: 'OK',
													        	action: function(){}
												        }
													   }
													});
												</script>
											<cfelse>
												<cfset createdSurveyID = "#qCreatedSurvey.ID#">
												<!--- <cfdump var="#createdSurveyID#"><cfabort> --->
												<!--- Displaying an success msg for creating a Survey in database --->
												<h3 style="text-align:center;color:green">The survey was successfully created.</h3><br />
												<h5 style="text-align:center">You will be redirected to populate the survey with questions</h5>
												<script>
													var surveyID = "<cfoutput>#createdSurveyID#</cfoutput>";
													setTimeout(function(){ $.redirect('createQuestionsForm.cfm', {"SurveyID":surveyID}); }, 3000);
												</script>
											</cfif>

										<cfelse>
											<h3 style="text-align:center"><strong>CREATE SURVEY</strong></h3><br /><br />
											<form name="createForm" id="createForm" method="POST" action="createSurveyForm.cfm" autocomplete="off">
												<div class="form-row">
													<div class="col-md-8 mb-3">
														<label for="name"><strong>Name: </strong></label><br />
														<input class="form-control" type="text" name="name" id="name">
													</div>
												</div>
												<br />
												<div class="form-row">
													<div class="col-md-4 mb-3">
														<label for="startDate"><strong>Start Date: </strong></label><br />
														<input class="form-control" type="date" name="startDate" id="startDate" min='1899-01-01'>
													</div>
													<div class="col-md-4 mb-3">
														<label for="endDate"><strong>End Date: </strong></label><br />
														<input class="form-control" type="date" name="endDate" id="endDate" min='1899-01-01' >
													</div>
												</div>
												<label for="descriptionShort"><strong>Description(short): </strong></label><br />
												<textarea name="descriptionShort" id="descriptionShort" rows="4" cols="100"></textarea>
												<br /><br />
												<label for="description"><strong>Description: </strong></label><br />
												<textarea name="description" id="description" rows="7" cols="100"></textarea>
												<br /><br />
												<label for="thankYouMessage"><strong>Thank you message(after submit): </strong></label><br />
												<textarea name="thankYouMessage" id="thankYouMessage" rows="3" cols="100"></textarea>
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
																<option value="" selected disabled hidden>Select</option>
																<option value="1">Allow</option>
	        													<option value="0">Not Allow</option>
														</select>
													</div>
													<div class="col-md-4 mb-2">
														<label for="allowAdditionalContactInfo"><strong>Allow Additional Contact Info: </strong></label><br />
														<select class="custom-select" name="allowAdditionalContactInfo" id="allowAdditionalContactInfo">
																<option value="" selected disabled hidden>Select</option>
																<option value="1">Allow</option>
	        													<option value="0">Not Allow</option>
														</select>
													</div>
													<div class="col-md-3 mb-4">
														<label for="questionsPerPage"><strong>Question Per Page:</strong></label><br />
														<input class="form-control" type="text" name="questionsPerPage" id="questionsPerPage">
													</div>
												</div><br /><br />
												<h5><strong>Required Settings</strong></h5>
												<hr>
												<!--- Mandatory Settings --->
												<div class="form-row">
													<div class="col-md-3 mb-2">
														<label for="firstnameMandatory"><strong>Firstname (Required): </strong></label><br />
														<select class="custom-select" name="firstnameMandatory" id="firstnameMandatory">
																<option value="" selected disabled hidden>Select</option>
																<option value="1">Yes</option>
	        													<option value="0">No</option>
														</select>
													</div>
													<div class="col-md-3 mb-2">
														<label for="lastnameMandatory"><strong>Lastname (Required): </strong></label><br />
														<select class="custom-select" name="lastnameMandatory" id="lastnameMandatory">
																<option value="" selected disabled hidden>Select</option>
																<option value="1">Yes</option>
	        													<option value="0">No</option>
														</select>
													</div>
													<div class="col-md-3 mb-2">
														<label for="emailMandatory"><strong>Email Adress (Required): </strong></label><br />
														<select class="custom-select" name="emailMandatory" id="emailMandatory">
																<option value="" selected disabled hidden>Select</option>
																<option value="1">Yes</option>
	        													<option value="0">No</option>
														</select>
													</div>
													<div class="col-md-3 mb-2">
														<label for="phoneNumberMandatory"><strong>Phone Num. (Required) :</strong></label><br />
														<select class="custom-select" name="phoneNumberMandatory" id="phoneNumberMandatory">
																<option value="" selected disabled hidden>Select</option>
																<option value="1">Yes</option>
	        													<option value="0">No</option>
														</select>
													</div>
												</div><br />
												<div class="form-row">
													<div class="col-md-3 mb-2">
														<label for="organisationMandatory"><strong>Organisation (Required) :</strong></label><br />
														<select class="custom-select" name="organisationMandatory" id="organisationMandatory">
																<option value="" selected disabled hidden>Select</option>
																<option value="1">Yes</option>
	        													<option value="0">No</option>
														</select>
													</div>
												</div>
												<br /><br /><br />
													<button class="btn btn-lg btn-primary btn-block text-uppercase" name="CreateSubmit" id="submit" type="submit">Create</button>
											</form>
											<br />
											<a href="adminPage.cfm"><button class="btn btn-lg btn-secondary btn-block text-uppercase" id="cancel">Cancel</button></a>
										</cfif>
									</div>
								</div>
							</div>
						</div>
				    </div>
				    <!--- /Page Content --->

					<br /><br />
				  </div>
				  <!--- /Wrapper --->
				<!--- Sidebar Toggle Script --->
				  <script>
					$(document).ready(function (){
						$("#menu-toggle").click(function(e) {
				     		 e.preventDefault();
				      	$("#wrapper").toggleClass("toggled");
					    });

					});
				  </script>
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