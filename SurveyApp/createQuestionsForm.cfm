<cfsetting showDebugOutput="NO">

<cfset encrypted_logout = Encrypt("true","#application.encryptKey#","AES","Hex")>
<!--- <cfset this.loginServices = createObject("component","SurveyApp.components.loginServices")> --->
<cfset this.UserGateway = createObject("component","SurveyApp.gateway.UserGateway") />

<cfset this.SurveysGateway = createObject("component","SurveyApp.gateway.SurveysGateway")>
<cfset this.GeneralQuestionsGateway = createObject("component","SurveyApp.gateway.GeneralQuestionsGateway")>
<cfset this.SpecificQuestionsGateway = createObject("component","SurveyApp.gateway.SpecificQuestionsGateway")>
<cfset this.AnswersGateway = createObject("component","SurveyApp.gateway.AnswersGateway")>
<cfset this.OfferedAnswersGateway = createObject("component","SurveyApp.gateway.OfferedAnswersGateway")>
<cfif structKeyExists(session,"userID")>
	<cfset userID = "#session.UserID#">
	<cfset qUser = this.UserGateway.getUsersData(ID = "#userID#")>
	<cfif qUser.Admin EQ 1>
	<!doctype html>
	<html>
	  <head>
		    <meta charset="utf-8">
		    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		    <title>Admin</title>
			<link href="css/indexStyle.css" type="text/css" rel="stylesheet">
			<link href="css/formStyle.css" rel="stylesheet">

			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
		  <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
		  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
		  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
			<!--- Form Validation --->
			<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.1/dist/jquery.validate.js"></script>
			<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.1/dist/additional-methods.min.js"></script>
			<!--- Meterial Questions --->
			<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
			<!--- Jquery Confirm,Alert... Plugin --->
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
			<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>
			<!--- Jquery Redirect --->
			<script src="https://cdn.rawgit.com/mgalante/jquery.redirect/master/jquery.redirect.js"></script>
			<!--- Datatables Plugin --->
			<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
			<script src="https://cdn.datatables.net/1.10.21/js/dataTables.bootstrap4.min.js"></script>
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css">
			<link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css">


			<script>


				<!--- Bad way to solve this --->
				$(function (){
					var status = localStorage.getItem('checked');
		      	if(localStorage.checked == 'true')
					{
						$("#changeSwitch").prop("checked", true);
						 $("#generalQuestions").css("display", "block");
					}else{
						$("#changeSwitch").prop("checked", false);
						$("#generalQuestions").css("display", "none");
					}
				});

				$(document).ready(function (){

				<!--- CREATE GENERAL QUESTION VALIDATION --->
				$("#createGeneralQuestion").validate({
					rules: {
						question:"required"
					},
					messages: {
						question:"Please fill in this field"
					},
					highlight: function (element) {
           					 $(element).parent().addClass('error')
       				 },
        			unhighlight: function (element) {
           					 $(element).parent().removeClass('error')
        			}
				});

				<!--- CREATE SPECIFIC QUESTION VALIDATION --->
				$("#createSpecificQuestion").validate({
					rules: {
						question:"required"
					},
					messages: {
						question:"Please fill in this field"
					},
					highlight: function (element) {
           					 $(element).parent().addClass('error')
       				 },
        			unhighlight: function (element) {
           					 $(element).parent().removeClass('error')
        			}
				});


				var dataTableQuestions = $('#generalQuestionsTable').DataTable({
												"processing": true,
							        			"serverSide": true,
							        			"bInfo": false,
											    "ajax":{
													        method: "GET",
													        url: "components/AjaxDataQuestions.cfc",
													        dataSrc:"data",
													        dataType: "json",
													        data:{
													        		"method":"getQuestions",
													        		"isReusable":1
													        		<cfif structKeyExists(form,"SurveyID")>
													        			,"SurveyID":"<cfoutput>#form.SurveyID#</cfoutput>"
													        		</cfif>
													        	}
												},
												lengthMenu: [5, 10, 20, 50],
							   					columns: [
											        { data: 'Question' },
											         { data: 'IsRequired' },
											        { data: 'IsTitle' },
											        { data: 'IsYesNo' },
											        { data: 'AllowEditor' },
											        { data: 'IsMultipleAnswers' },
											        { data: 'IsMultipleChoices' },
											        { data: 'AllowComment' },
											        {"data": null,className: "center",defaultContent: '<button class="BtnAsLink buttonChange" style="color:#2196F3"><a class="addQuestionsToSurvey"><i class="material-icons">add_circle</i></a></button>'}
											    ],
											    "columnDefs": [
							                      {
							                          "render": function (data, type, row) {
							                              return (data == 1) ? '<span>YES</span>' : '<span>NO</span>';
							                          },
							                          "targets": [ 1, 2, 3, 4, 5, 6, 7]
							                      }
							                  ]
										});

		 		//Add question to the Survey Table2
			    $('#generalQuestionsTable').on( 'click', '.addQuestionsToSurvey', function () {
				        var data = dataTableQuestions.row( $(this).parents('tr') ).data();
				        var ID = data["ID"];
				        //console.log(ID);
				       	$.confirm({
							    title: 'Question to Survey',
							    content: 'Are you sure you want to add the question to the Survey ?',
							    buttons: {
							        confirm: function () {
							        	<cfif structKeyExists(form,"SurveyID")>
							            	$.redirect('createQuestionsForm.cfm', {"addQuestionID":ID,"SurveyID":"<cfoutput>#form.SurveyID#</cfoutput>" });
							            </cfif>
							        },
							        cancel: function () {}
							    }
						});
				});

				<!--- Add General Questions --->
				<!--- $('.editor_create').on('click', function () {
					var myModal = $('#createGeneralQuestionModal');
			       	var currentRow=$(this).closest("tr");  // Finds the closest row <tr>
	                var Question=currentRow.find("td:eq(0)").text(); // get current row 1st TD value
				    console.log(Question);
			        myModal.modal({ show: true });
			    	return false;
				}); --->


			});
			</script>
			<style>
					#createGeneralQuestion .error {
	   					color: red;
					}
					#createSpecificQuestion .error {
	   					color: red;
					}
					.BtnAsLink{
				 		background: none!important;
						border: none;
						padding: 0!important;
				 	}
				 	.normalLink{
				 		  color: #2196F3;
				 	}
				 	.deleteLink{
				 		color: #F44336;
				 	}
				 	.NoDataMsg{
				 		text-align:center;
						font-size:40px;
						color:#CD5C5C;
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
									<cfif structKeyExists(form,"submitTotal")>
											<!--- Creating a new survey in database --->
											<!--- <cfdump var="#form#"><cfabort> --->
											<h3 style="text-align:center;color:green">The Survey was successfully created.</h3><br />
											<h5 style="text-align:center">You will be redirected to the Administrator's page.</h5>
											<script>
												window.localStorage.removeItem('checked');
												setTimeout(function(){ window.location = "adminPage.cfm" }, 3000);
											</script>
										<cfelse>
											<cfif structKeyExists(form,"SurveyID") AND form.SurveyID NEQ "">
												<cfset counter = 1>
												<cfset surveyID = "#form.SurveyID#">
												<cfset qSurvey = this.SurveysGateway.getSurveyData(ID = "#surveyID#")>

												<!--- <cfdump var="#surveyID#"><cfabort> --->
												<h3 style="text-align:center"><strong>QUESTIONS FOR SURVEY:</strong></h3><br />
												<h5 style="text-align:center"><strong><cfoutput>#qSurvey.Name#</cfoutput></strong></h5>
												<br /><br /><br />
												<h5><strong>General </strong>Questions</h5>
												<hr>
												<br />
												<!--- Loading the general question from database --->
												<cfset generalQuestions = this.GeneralQuestionsGateway.getQuestionsData()>
												<!--- <cfdump var="#generalQuestions#"><cfabort> --->
												<!--- Bad way of handling this --->
												<div class="checkboxEnable">
													<p><strong>Add General Questions to your Survey :</strong></p>
													<form name="totalForm" method="POST" action="createQuestionsForm.cfm">
														<div class="custom-control custom-switch" style="">
														    <input type="checkbox" name="includeGeneralQuestions" class="custom-control-input" id="changeSwitch" value="true">
														    <label class="custom-control-label" for="changeSwitch">Enable General Questions</label>
														  </div>
												</div>
												<br />
												<div id="generalQuestions" style="display:none">
													<span id="#CreateBtn">
														<p>Select to add a question: </p>
														<button type="button" id="createGenericQuestionBtn" class="btn btn-primary editor_create" data-toggle="modal" data-target="#createGeneralQuestionModal">Create General Question</button>
													</span>
													<br /><br />
													<div id="tableQuestionsContainer">
															<table id="generalQuestionsTable" class="table table-striped table-bordered" style="width:100%">
															    <thead>
															        <tr>
															            <th>Question</th>
															            <th>Required</th>
															            <th>Title</th>
															            <th>Yes/No</th>
															            <th>Editor</th>
															            <th>Multiple Answers</th>
															            <th>Multiple Choices</th>
															            <th>Allow Comment</th>
															            <th>Actions</th>
															        </tr>
															    </thead>
															    <tbody>
															    </tbody>
															    <tfoot></tfoot>
															</table>
													</div>


											<!--- <cfloop>
														<table class="table table-bordered" width="30px">
															<thead class="thead-dark">
																 <tr>
																    <th scope="col">Question</th>
													                <th scope="col">Required</th>
													                <th scope="col">Yes/No</th>
													                <th scope="col">Editor</th>
													                <th scope="col">Multiple Answers</th>
													                <th scope="col">Multiple Choices</th>
													                <th scope="col">Offered Answers</th>
													                <th scope="col">Actions</th>
																</tr>
															</thead>
															<tbody>
																<cfset ItemsPerRow1 = generalQuestions.recordCount>
																<cfif #ItemsPerRow1# EQ 0>
																	<td class="NoDataMsg" colspan="6" height="100px">No data to display</td>
																<cfelse>
																	<cfloop query="#generalQuestions#">
																		<tr>
																		<cfif currentrow mod ItemsPerRow1 is 0>
																		</tr><tr>
																		<cfelseif currentrow is recordcount>
																		</tr>
																		</cfif>
																		<td><cfoutput><strong>#generalQuestions.QUESTION#</strong></cfoutput></td>
																		<td>
																			<cfif "#generalQuestions.IsRequired#" EQ 1>
																				<cfoutput>Yes</cfoutput>
																			<cfelse>
																				<cfoutput>No</cfoutput>
																			</cfif>
																		</td>
																		<td>
																			<cfif "#generalQuestions.IsYesNo#" EQ 1>
																				<cfoutput>Yes</cfoutput>
																			<cfelse>
																				<cfoutput>No</cfoutput>
																			</cfif>
																		</td>
																		<td>
																			<cfif "#generalQuestions.AllowEditor#" EQ 1>
																				<cfoutput>Yes</cfoutput>
																			<cfelse>
																				<cfoutput>No</cfoutput>
																			</cfif>
																		</td>
																		<td>
																			<cfif "#generalQuestions.IsMultipleAnswers#" EQ 1>
																				<cfoutput>Yes</cfoutput>
																			<cfelse>
																				<cfoutput>No</cfoutput>
																			</cfif>
																		</td>
																		<td>
																			<cfif "#generalQuestions.IsMultipleChoices#" EQ 1>
																				<cfoutput>Yes</cfoutput>
																			<cfelse>
																				<cfoutput>No</cfoutput>
																			</cfif>
																		</td>
																		<td>
																			<cfif "#generalQuestions.IsMultipleAnswers#" EQ 1>
																				<table id="offeredAnswers1">
																					<cfloop from="1" index="i" to="5">
																						<tr><cfoutput>#i#</cfoutput></tr>
																					</cfloop>
																				</table>
																			<cfelse>
																				<cfoutput><em>Option Not Allowed</em></cfoutput>
																			</cfif>
																		</td>
																		<td>
																			<button type="button" class="BtnAsLink addQuestion normalLink"><a title="Add Question to Survey"><i class="material-icons">add_circle</i></a></button>
																		</td>
																	</cfloop>
																</cfif>
															</tbody>
														</table>
													</cfloop> --->
												</div>
												<br /><br />
												<h5><strong>Specific </strong>Questions</h5>
												<hr>
												<br />
												<!--- Loading the general question from database --->
												<cfset specificQuestions = this.SpecificQuestionsGateway.getQuestionsData(Reference = "#surveyID#")>
												<!--- <cfdump var="#generalQuestions#"><cfabort> --->
												<div id="specificQuestions">
													<span id="#CreateBtn">
														<button type="button" id="createSpecificQuestionBtn" class="btn btn-primary editor_create" data-toggle="modal" data-target="#createSpecificQuestionModal">Create Specific Question</button>
													</span>
													<br /><br />
													<cfloop>
														<table class="table table-bordered" width="30px">
															<thead class="thead-dark">
																 <tr>
																    <th scope="col" width="1000px">Question</th>
													                <th scope="col">Required</th>
													                <th scope="col">Yes/No</th>
													                <th scope="col">Editor</th>
													                <th scope="col">Multiple Answers</th>
													                <th scope="col">Multiple Choices</th>
													                <th scope="col">Comment</th>
													                <th scope="col" width="500px">Offered Answers</th>
													                <th scope="col">Actions</th>
																</tr>
															</thead>
															<tbody>
																<cfset ItemsPerRow2 = specificQuestions.recordCount>
																<cfif #ItemsPerRow2# EQ 0>
																	<td class="NoDataMsg" colspan="9" height="100px">NO QUESTIONS AVAILABLE</td>
																<cfelse>
																	<cfloop query="#specificQuestions#">
																		<tr>
																		<cfif currentrow mod ItemsPerRow2 is 0>
																		</tr><tr>
																		<cfelseif currentrow is recordcount>
																		</tr>
																		</cfif>
																		<td style="width:300px"><cfoutput><strong>#specificQuestions.QUESTION#</strong></cfoutput></td>
																		<td>
																			<cfif "#specificQuestions.IsRequired#" EQ 1>
																				<cfoutput>Yes</cfoutput>
																			<cfelse>
																				<cfoutput>No</cfoutput>
																			</cfif>
																		</td>
																		<td>
																			<cfif "#specificQuestions.IsYesNo#" EQ 1>
																				<cfoutput>Yes</cfoutput>
																			<cfelse>
																				<cfoutput>No</cfoutput>
																			</cfif>
																		</td>
																		<td>
																			<cfif "#specificQuestions.AllowEditor#" EQ 1>
																				<cfoutput>Yes</cfoutput>
																			<cfelse>
																				<cfoutput>No</cfoutput>
																			</cfif>
																		</td>
																		<td>
																			<cfif "#specificQuestions.IsMultipleAnswers#" EQ 1>
																				<cfoutput>Yes</cfoutput>
																			<cfelse>
																				<cfoutput>No</cfoutput>
																			</cfif>
																		</td>
																		<td>
																			<cfif "#specificQuestions.IsMultipleChoices#" EQ 1>
																				<cfoutput>Yes</cfoutput>
																			<cfelse>
																				<cfoutput>No</cfoutput>
																			</cfif>
																		</td>
																		<td>
																			<cfif "#specificQuestions.AllowComment#" EQ 1>
																				<cfoutput>Yes</cfoutput>
																			<cfelse>
																				<cfoutput>No</cfoutput>
																			</cfif>
																		</td>
																		<td width="300px">
																			<cfif "#specificQuestions.IsMultipleAnswers#" EQ 1>
																				<cfset qOfferedAnswers = this.OfferedAnswersGateway.getOfferedAnswersData(QuestionID = "#specificQuestions.ID#")>
																				<table id="offeredAnswers1">
																					<cfloop query="qOfferedAnswers">
																						<tr><td width="300px"><cfoutput>#qOfferedAnswers.OfferedAnswer#</cfoutput></td></tr>
																					</cfloop>
																				</table>
																				<br />
																				<button type="button" class="BtnAsLink OfferedAnswers" data-toggle="modal" data-target="#addOfferedAnswers"><a title="Choice Report Preferences"><i class="material-icons">add_comment</i></a></button>
																			<cfelse>
																				<cfoutput><em>Option Not Allowed</em></cfoutput>
																			</cfif>
																		</td>
																		<td>
																			<button type="button" class="BtnAsLink deleteLink"><a class="deleteQuestion" title="Delete Question"><i class="material-icons">delete</i></a></button>
																		</td>
																	</cfloop>
																</cfif>
															</tbody>
														</table>
													</cfloop>
												</div>
												</div>
												<br /><br />
												<button type="submit" name="submitTotal" class="btn btn-success" title="Finsh Creating Survey">FINISH</button>
												</form>
												<br /><br />
											</div>

											<!--- FOR GENERAL QUESTIONS --->
											<cfif structKeyExists(form,"Question") AND structKeyExists(form,"isTitle") AND structKeyExists(form,"isYesNo") AND structKeyExists(form,"allowEditor")
													AND structKeyExists(form,"isMultipleAnswers")AND structKeyExists(form,"addGeneralQuestionBtn") AND structKeyExists(form,"isMultipleChoices") AND structKeyExists(form,"allowComment")  AND structKeyExists(form,"isRequired") AND structKeyExists(form,"SurveyID") AND
													form.Question NEQ "" AND form.isTitle NEQ "" AND form.isYesNo NEQ "" AND form.allowEditor NEQ "" AND form.isMultipleAnswers NEQ "" AND
													form.isMultipleChoices NEQ "" AND form.isRequired NEQ "" AND form.SurveyID NEQ "">

												<cfset duplicateQuestion = 0>

												<!--- looping over general questions to check for a duplicate --->
												<cfloop query="#generalQuestions#">
													<cfif ("#generalQuestions.Question#" EQ "#form.Question#") AND ("#generalQuestions.IsTitle#" EQ "#form.isTitle#") AND
														("#generalQuestions.IsRequired#" EQ "#form.isRequired#") AND ("#generalQuestions.IsYesNo#" EQ "#form.isYesNo#") AND
														("#generalQuestions.AllowEditor#" EQ "#form.allowEditor#") AND ("#generalQuestions.IsMultipleAnswers#" EQ "#form.isMultipleAnswers#") AND
														("#generalQuestions.IsMultipleChoices#" EQ "#form.isMultipleChoices#") AND ("#generalQuestions.AllowComment#" EQ "#form.allowComment#")>
														<cfset duplicateQuestion = 1>
													</cfif>
												</cfloop>
												<cfif duplicateQuestion EQ 1>
													<script>
														$.confirm({
														    title: 'Duplicate Question',
														    content: "There is a question like this one in our database of General Questions [HINT:INCLUDE IT]",
														    buttons: {
														        info: {
														        	text: 'OK',
														        	action: function(){
														        		<!--- Refreshing the page  --->
														            	$.redirect('createQuestionsForm.cfm', {"SurveyID":<cfoutput>#form.SurveyID#</cfoutput>});
														        	}
													        }
														   }
														});
													</script>
												<cfelse>
													<cfset this.GeneralQuestionsGateway.insertQuestion(Question = "#form.Question#",Reference = 0,Number = "#counter#",IsTitle = "#form.isTitle#",
													IsRequired = "#form.isRequired#",IsYesNo = "#form.isYesNo#",AllowEditor = "#form.allowEditor#",IsMultipleAnswers = "#form.isMultipleAnswers#",IsMultipleChoices = "#form.IsMultipleChoices#",AllowComment = "#form.allowComment#")>
													<!--- GENERAL QUESTION FOR OTHER SURVEYS --->
													<cfset this.SpecificQuestionsGateway.insertQuestion(Question = "#form.Question#",Reference = "#form.SurveyID#",Number = "#counter#",IsTitle = "#form.isTitle#",
													IsRequired = "#form.isRequired#",IsYesNo = "#form.isYesNo#",AllowEditor = "#form.allowEditor#",IsMultipleAnswers = "#form.isMultipleAnswers#",IsMultipleChoices = "#form.IsMultipleChoices#",AllowComment = "#form.allowComment#")>
													<cfset counter = counter + 1>
													<script>
														$.confirm({
														    title: 'Successful',
														    content: "The question you created was successfully inserted",
														    buttons: {
														        info: {
														        	text: 'OK',
														        	action: function(){
														        		<!--- Refreshing the page  --->
														            	$.redirect('createQuestionsForm.cfm', {"SurveyID":<cfoutput>#form.SurveyID#</cfoutput>});
														        	}
													        }
														   }
														});
													</script>
												</cfif>
												<cfset structClear(form)>
											</cfif>

											<!--- FOR SPECIFIC QUESTIONS --->
											<cfif structKeyExists(form,"Question") AND structKeyExists(form,"isTitle") AND structKeyExists(form,"isYesNo") AND structKeyExists(form,"allowEditor")
													AND structKeyExists(form,"isMultipleAnswers")AND structKeyExists(form,"addSpecificQuestionBtn") AND structKeyExists(form,"allowComment") AND structKeyExists(form,"isMultipleChoices") AND structKeyExists(form,"isRequired") AND structKeyExists(form,"SurveyID") AND
													form.Question NEQ "" AND form.isTitle NEQ "" AND form.isYesNo NEQ "" AND form.allowEditor NEQ "" AND form.isMultipleAnswers NEQ "" AND
													form.isMultipleChoices NEQ "" AND form.isRequired NEQ "" AND form.SurveyID NEQ "">
												<cfset duplicateQuestion = 0>
												<!--- looping over general questions to check for a duplicate --->
												<cfloop query="#specificQuestions#">
													<cfif ("#specificQuestions.Question#" EQ "#form.Question#") AND ("#specificQuestions.IsTitle#" EQ "#form.isTitle#") AND
														("#specificQuestions.IsRequired#" EQ "#form.isRequired#") AND ("#specificQuestions.IsYesNo#" EQ "#form.isYesNo#") AND
														("#specificQuestions.AllowEditor#" EQ "#form.allowEditor#") AND ("#specificQuestions.IsMultipleAnswers#" EQ "#form.isMultipleAnswers#") AND
														("#specificQuestions.IsMultipleChoices#" EQ "#form.isMultipleChoices#") AND ("#specificQuestions.AllowComment#" EQ "#form.allowComment#")>
														<cfset duplicateQuestion = 1>
													</cfif>
												</cfloop>
												<cfif duplicateQuestion EQ 1>
													<script>
														$.confirm({
														    title: 'Duplicate Question',
														    content: "There is a question like this one in our database of Specific Questions for this Survey [HINT: INCLUDE IT]",
														    buttons: {
														        info: {
														        	text: 'OK',
														        	action: function(){
														        		<!--- Refreshing the page  --->
														            	$.redirect('createQuestionsForm.cfm', {"SurveyID":<cfoutput>#form.SurveyID#</cfoutput>});
														        	}
													        }
														   }
														});
													</script>
												<cfelse>
													<cfset this.SpecificQuestionsGateway.insertQuestion(Question = "#form.Question#",Reference = "#form.SurveyID#",Number = "#counter#",IsTitle = "#form.isTitle#",
													IsRequired = "#form.isRequired#",IsYesNo = "#form.isYesNo#",AllowEditor = "#form.allowEditor#",IsMultipleAnswers = "#form.isMultipleAnswers#",IsMultipleChoices = "#form.isMultipleChoices#",AllowComment = "#form.allowComment#")>
													<cfset counter = counter + 1>
													<script>
														$.confirm({
														    title: 'Successful',
														    content: "The question you created was successfully inserted",
														    buttons: {
														        info: {
														        	text: 'OK',
														        	action: function(){
														        		<!--- Refreshing the page  --->
														            	$.redirect('createQuestionsForm.cfm', {"SurveyID":<cfoutput>#form.SurveyID#</cfoutput>});
														        	}
													        }
														   }
														});
													</script>
												</cfif>
												<cfset structClear(form)>
											</cfif>


											<!--- FOR DELETING QUESTION IN SPECIFIC QUESTIONS TABLE --->
											<cfif structKeyExists(form,"deleteQuestionName") AND structKeyExists(form,"SurveyID") AND structKeyExists(form,"deleteQuestionRequired")
													AND structKeyExists(form,"deleteQuestionYesNo") AND structKeyExists(form,"deleteQuestionAllowEditor") AND structKeyExists(form,"deleteQuestionIsMultipleAnswers")
													AND structKeyExists(form,"deleteQuestionIsMultipleChoices") AND structKeyExists(form,"deleteQuestionAllowComment")>
													<!--- Changing Values from YES/NO to BOOLEAN TYPE --->
													<cfif "#form.deleteQuestionRequired#" EQ "YES">
														<cfset isRequired = 1>
													<cfelse>
														<cfset isRequired = 0>
													</cfif>
													<cfif "#form.deleteQuestionYesNo#" EQ "YES">
														<cfset isYesNo = 1>
													<cfelse>
														<cfset isYesNo = 0>
													</cfif>
													<cfif "#form.deleteQuestionAllowEditor#" EQ "YES">
														<cfset allowEditor = 1>
													<cfelse>
														<cfset allowEditor = 0>
													</cfif>
													<cfif "#form.deleteQuestionIsMultipleAnswers#" EQ "YES">
														<cfset isMultipleAnswers = 1>
													<cfelse>
														<cfset isMultipleAnswers = 0>
													</cfif>
													<cfif "#form.deleteQuestionIsMultipleChoices#" EQ "YES">
														<cfset isMultipleChoices = 1>
													<cfelse>
														<cfset isMultipleChoices = 0>
													</cfif>
													<cfif "#form.deleteQuestionIsMultipleChoices#" EQ "YES">
														<cfset allowComment = 1>
													<cfelse>
														<cfset allowComment = 0>
													</cfif>
													<cfif "#form.deleteQuestionAllowComment#" EQ "YES">
														<cfset allowComment = 1>
													<cfelse>
														<cfset allowComment = 0>
													</cfif>

													<cfset qQuestion = this.SpecificQuestionsGateway.getQuestionsData(Question = "#form.deleteQuestionName#",Reference = "#form.SurveyID#",IsRequired = "#isRequired#",IsYesNo = "#isYesNo#",AllowEditor = "#allowEditor#",IsMultipleAnswers = "#isMultipleAnswers#",IsMultipleChoices = "#isMultipleChoices#",AllowComment = "#allowComment#")>
													<!--- DELETING THE QUESTION USING IT'S ID NUM --->
													<cfset this.SpecificQuestionsGateway.deleteQuestion(ID = "#qQuestion.ID#")>
													<script>
														$.redirect('createQuestionsForm.cfm', {"SurveyID":<cfoutput>#form.SurveyID#</cfoutput>});
													</script>
													<cfset structClear(form)>
											</cfif>


											<!--- FOR ADDING QUESTION TO SURVEY TABLE --->
											<cfif structKeyExists(form,"addQuestionID") AND structKeyExists(form,"SurveyID")>
												<cfset qQuestion = this.GeneralQuestionsGateway.getQuestionsData(ID = "#form.addQuestionID#")>
												<!--- <cfdump var = "#qQuestion#"> --->
													<cfset this.SpecificQuestionsGateway.insertQuestion(Question = "#qQuestion.Question#",Reference = "#form.SurveyID#",Number = "#qQuestion.Number#",
																IsTitle = "#qQuestion.IsTitle#",IsRequired = "#qQuestion.IsRequired#",IsYesNo = "#qQuestion.IsYesNo#",AllowEditor = "#qQuestion.AllowEditor#",
																IsMultipleAnswers = "#qQuestion.IsMultipleAnswers#",IsMultipleChoices = "#qQuestion.IsMultipleChoices#",AllowComment = "#qQuestion.AllowComment#")>
													<script>

														$.redirect('createQuestionsForm.cfm', {"SurveyID":<cfoutput>#form.SurveyID#</cfoutput>});
													</script>
													<cfset structClear(form)>
											</cfif>


											<!--- FOR ADDING OFFERED ANSWERS --->
											<cfif structKeyExists(form,"AddOfferedAnswerSubmit") AND structKeyExists(form,"OfferedAnswers") AND structKeyExists(form,"SurveyID") AND structKeyExists(form,"Question")>
												<!--- <cfdump var = "#form#"> --->
												<cfset qQuestion = this.SpecificQuestionsGateway.getQuestionsData(Question = "#form.Question#",Reference = "#form.SurveyID#")>
												<!--- <cfdump var = "#qQuestion#"> --->
												<cfset this.OfferedAnswersGateway.insertOfferedAnswers(QuestionID = "#qQuestion.ID#",OfferedAnswer = "#form.OfferedAnswers#")>
												<script>
													$.confirm({
														    title: 'Offered Answer Added',
														    content: "The Offered Answer was added for the Question you selected.",
														    buttons: {
														        info: {
														        	text: 'OK',
														        	action: function(){
														        		<!--- Refreshing the page  --->
														            	$.redirect('createQuestionsForm.cfm', {"SurveyID":<cfoutput>#form.SurveyID#</cfoutput>});
														        	}
													        }
														   }
														});
												</script>
												<cfset structClear(form)>
											</cfif>

											<!--- Modal for creating GENERAL QUESTIONS  --->
											<div class="modal fade" id="createGeneralQuestionModal" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
											  <div class="modal-dialog modal-dialog-centered">
											    <div class="modal-content">
											      <div class="modal-header">
											        <h3 class="modal-title" id="staticBackdropLabel">Create Question <strong>[GENERAL Q.]</strong></h3>
											        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
											          <span aria-hidden="true">&times;</span>
											        </button>
											      </div>
											      <div class="modal-body">
											      	<p>Add your <strong>General Question</strong> Here :</p>
													 <form name="createGeneralQuestion" id="createGeneralQuestion" method="POST" action="createQuestionsForm.cfm" autocomplete="off">
														 <input type="hidden" name="SurveyID" value="<cfoutput>#surveyID#</cfoutput>">
															<div class="row">
																<div class="col-sm-12">
																	<label for="question1"><strong>Question: </strong></label><br />
																	<textarea class="form-control" name="question" id="question1" rows="7" cols="60"></textarea>
																</div>
															</div>
															<br />
															<div class="form-row">
																<div class="col-4">
																	<p><strong>Required :</strong></p>
																	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input" id="isRequired1" name="isRequired" value="1">
																    	<label class="custom-control-label" for="isRequired1">Yes</label>
																  	</div>
																  	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input" id="isRequired2" name="isRequired" value="0" checked>
																    	<label class="custom-control-label" for="isRequired2">No</label>
																	</div>
																</div>
																<div class="col-4">
																	<p><strong>Title :</strong></p>
																	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input" id="isTitle1" name="isTitle" value="1">
																    	<label class="custom-control-label" for="isTitle1">Yes</label>
																  	</div>
																  	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input" id="isTitle2" name="isTitle" value="0" checked>
																    	<label class="custom-control-label" for="isTitle2">No</label>
																	</div>
																</div>
															</div>
															<br />
															<hr>
															<div class="form-row">
																<div class="col">
																	<p><strong>Yes/No :</strong></p>
																	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input checkRadioBtns1" id="isYesNo1" name="isYesNo" value="1" checked>
																    	<label class="custom-control-label" for="isYesNo1">Yes</label>
																  	</div>
																  	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input checkRadioBtns1" id="isYesNo2" name="isYesNo" value="0">
																    	<label class="custom-control-label" for="isYesNo2">No</label>
																	</div>
																</div>
																<div class="col">
																	<p><strong>Allow Editor :</strong></p>
																	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input checkRadioBtns1" id="allowEditor1" name="allowEditor" value="1" disabled>
																    	<label class="custom-control-label" for="allowEditor1">Yes</label>
																  	</div>
																  	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input checkRadioBtns1" id="allowEditor2" name="allowEditor" value="0" disabled checked>
																    	<label class="custom-control-label" for="allowEditor2">No</label>
																	</div>
																</div>
																<div class="col">
																	<p><strong>Multiple Answers :</strong></p>
																	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input checkRadioBtns1" id="isMultipleAnswers1" name="isMultipleAnswers" value="1" disabled>
																    	<label class="custom-control-label" for="isMultipleAnswers1">Yes</label>
																  	</div>
																  	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input checkRadioBtns1" id="isMultipleAnswers2" name="isMultipleAnswers" value="0" disabled checked>
																    	<label class="custom-control-label" for="isMultipleAnswers2">No</label>
																	</div>
																</div>
															</div>
															<br />
															<p class="errorDisplay1" style="color:red"></p>
															<!--- <p><strong>Multiple Answers [:ENABLED] Option</strong></p> --->
															<hr>
															<div class="form-row">
																<div class="col-4">
																	<p><strong>Multiple Choices :</strong></p>
																	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input" id="isMultipleChoices1" name="isMultipleChoices" value="1" disabled>
																    	<label class="custom-control-label" for="isMultipleChoices1">Yes</label>
																  	</div>
																  	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input" id="isMultipleChoices2" name="isMultipleChoices" value="0" disabled checked>
																    	<label class="custom-control-label" for="isMultipleChoices2">No</label>
																	</div>
																</div>
																<div class="col-4">
																	<p><strong>Allow Comment :</strong></p>
																	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input" id="allowComment1" name="allowComment" value="1" disabled>
																    	<label class="custom-control-label" for="allowComment1">Yes</label>
																  	</div>
																  	<div class="custom-control custom-radio custom-control-inline">
																    	<input type="radio" class="custom-control-input" id="allowComment2" name="allowComment" value="0" disabled checked>
																    	<label class="custom-control-label" for="allowComment2">No</label>
																	</div>
																</div>
															</div>
															<br />
												      </div>
												      <div class="modal-footer">
												       	<button class="btn btn-primary text-uppercase" name="addGeneralQuestionBtn" id="addGeneralQuestionBtn" type="submit">ADD</button>
											      	</div>
											    </form>
										    </div>
										  </div>
										</div>

											<!--- Modal for creating SPECIFIC QUESTIONS --->
											<div class="modal fade" id="createSpecificQuestionModal" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
												  <div class="modal-dialog modal-dialog-centered">
												    <div class="modal-content">
												      <div class="modal-header">
												        <h3 class="modal-title" id="staticBackdropLabel">Create Question <strong>[SPECIFIC Q.]</strong></h3>
												        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
												          <span aria-hidden="true">&times;</span>
												        </button>
												      </div>
												      <div class="modal-body" style="padding-left:20px">
												      	<p>Add your <strong>Specific Question</strong> Here :</p>
														 <form name="createSpecificQuestion" id="createSpecificQuestion" method="POST" action="createQuestionsForm.cfm" autocomplete="off">
															 <input type="hidden" name="SurveyID" value="<cfoutput>#surveyID#</cfoutput>">
																<div class="row">
																	<div class="col-sm-12">
																		<label for="question1"><strong>Question: </strong></label><br />
																		<textarea class="form-control" name="question" id="question2" rows="7" cols="60"></textarea>
																	</div>
																</div>
																<br />
																<div class="form-row">
																	<div class="col-4">
																		<p><strong>Required :</strong></p>
																		<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input" id="isRequired3" name="isRequired" value="1">
																	    	<label class="custom-control-label" for="isRequired3">Yes</label>
																	  	</div>
																	  	<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input" id="isRequired4" name="isRequired" value="0" checked>
																	    	<label class="custom-control-label" for="isRequired4">No</label>
																		</div>
																	</div>
																	<div class="col-4">
																		<p><strong>Title :</strong></p>
																		<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input" id="isTitle3" name="isTitle" value="1">
																	    	<label class="custom-control-label" for="isTitle3">Yes</label>
																	  	</div>
																	  	<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input" id="isTitle4" name="isTitle" value="0" checked>
																	    	<label class="custom-control-label" for="isTitle4">No</label>
																		</div>
																	</div>
																</div>
																<br />
																<hr>
																<div class="form-row">
																	<div class="col">
																		<p><strong>Yes/No :</strong></p>
																		<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input checkRadioBtns2" id="isYesNo3" name="isYesNo" value="1" checked>
																	    	<label class="custom-control-label" for="isYesNo3">Yes</label>
																	  	</div>
																	  	<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input checkRadioBtns2" id="isYesNo4" name="isYesNo" value="0">
																	    	<label class="custom-control-label" for="isYesNo4">No</label>
																		</div>
																	</div>
																	<div class="col">
																		<p><strong>Allow Editor :</strong></p>
																		<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input checkRadioBtns2" id="allowEditor3" name="allowEditor" value="1" disabled>
																	    	<label class="custom-control-label" for="allowEditor3">Yes</label>
																	  	</div>
																	  	<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input checkRadioBtns2" id="allowEditor4" name="allowEditor" value="0" disabled checked>
																	    	<label class="custom-control-label" for="allowEditor4">No</label>
																		</div>
																	</div>
																	<div class="col">
																		<p><strong>Multiple Answers :</strong></p>
																		<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input checkRadioBtns2" id="isMultipleAnswers3" name="isMultipleAnswers" value="1" disabled>
																	    	<label class="custom-control-label" for="isMultipleAnswers3">Yes</label>
																	  	</div>
																	  	<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input checkRadioBtns2" id="isMultipleAnswers4" name="isMultipleAnswers" value="0" disabled checked>
																	    	<label class="custom-control-label" for="isMultipleAnswers4">No</label>
																		</div>
																	</div>
																</div>
																<br />
																<p class="errorDisplay2" style="color:red"></p>
																<!--- <p><strong>Multiple Answers [:ENABLED] Option</strong></p> --->
																<hr>
																<div class="form-row">
																	<div class="col-4">
																		<p><strong>Multiple Choices :</strong></p>
																		<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input" id="isMultipleChoices3" name="isMultipleChoices" value="1" disabled>
																	    	<label class="custom-control-label" for="isMultipleChoices3">Yes</label>
																	  	</div>
																	  	<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input" id="isMultipleChoices4" name="isMultipleChoices" value="0" disabled checked>
																	    	<label class="custom-control-label" for="isMultipleChoices4">No</label>
																		</div>
																	</div>
																	<div class="col-4">
																		<p><strong>Allow Comment :</strong></p>
																		<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input" id="allowComment3" name="allowComment" value="1" disabled>
																	    	<label class="custom-control-label" for="allowComment3">Yes</label>
																	  	</div>
																	  	<div class="custom-control custom-radio custom-control-inline">
																	    	<input type="radio" class="custom-control-input" id="allowComment4" name="allowComment" value="0" disabled checked>
																	    	<label class="custom-control-label" for="allowComment4">No</label>
																		</div>
																	</div>
																</div>
																<br />
													      </div>
													      <div class="modal-footer">
													       	<button class="btn btn-primary text-uppercase" name="addSpecificQuestionBtn" id="addBtn" type="submit">ADD</button>
												      	</div>
												    </form>
											    </div>
											  </div>
											</div>

											<!--- Modal for adding OFFERED ANSWERS  --->
											<div class="modal fade" id="addOfferedAnswers" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
											  <div class="modal-dialog modal-dialog-centered">
											    <div class="modal-content">
											      <div class="modal-header">
												      <h3 class="modal-title" id="staticBackdropLabel">Offered Answers</h3>
												      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
													       <span aria-hidden="true">&times;</span>
													  </button>
											      </div>
											      <div class="modal-body">
											      		<h5><em class="QuestionDisplay"></em></h5><br />
													      <p>Adding <strong>Offered Answers</strong> for the Selected Question here :</p><br />
															<form id="createOfferedAnswers" method="POST" action="createQuestionsForm.cfm" autocomplete="off">
																<input type="hidden" name="SurveyID" value="<cfoutput>#surveyID#</cfoutput>">
																<input type="hidden" class="QuestionFull" name="Question" value="">
																 <div class="form-row">
																	<div class="col-sm-9">
																		<label for="offeredAnswerInput"><strong>Type Offered Answer :</strong></label><br />
																		<input class="form-control" type="text" name="offeredAnswers" id="offeredAnswerInput">
																	</div>
																</div>
																<br /><br />
																<button class="btn btn-primary text-uppercase" name="addOfferedAnswerSubmit" id="addAnswerBtn" type="submit">ADD</button>
															</form>
												  </div>
												</div>
											  </div>
											</div>
											<cfelse>
												 <div id="error404Survey" class="alert alert-danger" role="alert" style="text-align:center">
											      <h3>ERROR</h3>
											      <h5>There was an error while creating the survey.You'll be redirected.</h5><br />
											     <!---  <script>
												      setTimeout(function(){ window.location = "adminPage.cfm"; }, 3000);
												</script> --->
										      </div>
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
				<!--- Sidebar Toggle Script --->
				  <script>



					    $('#changeSwitch').change(function () {
					        if ($(this).is(':checked')) {
					            $("#generalQuestions").css("display", "block");
					            localStorage.checked = true;
					        } else {
					            $("#generalQuestions").css("display", "none");
					            localStorage.checked = false;
					        }
					    });

					    <!--- BEFORE SUBMIT ON FORMS IN MODALS CHANGE DISABLE TO FALSE --->
					    $("#createGeneralQuestion").submit(function(){
						   // Let's find the input to check
						   var $input = $(this).find("input:disabled");
						   //console.log($input);
						   $input.each(function () {
						       $(this).removeAttr('disabled');
						    });
						});

						$("#createSpecificQuestion").submit(function(){
						   // Let's find the input to check
						   var $input = $(this).find("input:disabled");
						   console.log($input);
						   $input.each(function () {
						       $(this).removeAttr('disabled');
						    });
						});


					    <!--- Logic Validation for Form(createGeneralQuestion) --->
			    		$("#createGeneralQuestion input[name$='isYesNo']").click(function() {
					        var test = $(this).val();
					        if(test == 0)
					        {
					        	$("#createGeneralQuestion input[name$='allowEditor']").prop("disabled", false);
					        	$("#createGeneralQuestion input[name$='isMultipleAnswers']").prop("disabled", false);
					        	$("#createGeneralQuestion input[name$='isMultipleChoices']").prop("disabled", true);
					        	$("#createGeneralQuestion input[name$='allowComment']").prop("disabled", true);
					        }else{
					        	$("#createGeneralQuestion input[name$='allowEditor']").prop("disabled", true);
					        	$("#createGeneralQuestion input[name$='isMultipleAnswers']").prop("disabled", true);
					        	$("#createGeneralQuestion input[name$='isMultipleChoices']").prop("disabled", true);
					        	$("#createGeneralQuestion input[name$='allowComment']").prop("disabled", true);
					        }

					    });

					    $("#createGeneralQuestion input[name$='allowEditor']").click(function() {
					        var test = $(this).val();
					        if(test == 0)
					        {
					        	$("#createGeneralQuestion input[name$='isYesNo']").prop("disabled", false);
					        	$("#createGeneralQuestion input[name$='isMultipleAnswers']").prop("disabled", false);
					        	$("#createGeneralQuestion input[name$='isMultipleChoices']").prop("disabled", true);
					        	$("#createGeneralQuestion input[name$='allowComment']").prop("disabled", true);
					        }else{
					        	$("#createGeneralQuestion input[name$='isYesNo']").prop("disabled", true);
					        	$("#createGeneralQuestion input[name$='isMultipleAnswers']").prop("disabled", true);
					        	$("#createGeneralQuestion input[name$='isMultipleChoices']").prop("disabled", true);
					        	$("#createGeneralQuestion input[name$='allowComment']").prop("disabled", true);
					        }

					    });

					    $("#createGeneralQuestion input[name$='isMultipleAnswers']").click(function() {
					        var test = $(this).val();
					        if(test == 0)
					        {
					        	$("#createGeneralQuestion input[name$='isYesNo']").prop("disabled", false);
					        	$("#createGeneralQuestion input[name$='allowEditor']").prop("disabled", false);
					        	$("#createGeneralQuestion input[name$='isMultipleChoices']").prop("disabled", true);
					        	$("#createGeneralQuestion input[name$='allowComment']").prop("disabled", true);
					        }else{
					        	$("#createGeneralQuestion input[name$='isYesNo']").prop("disabled", true);
					        	$("#createGeneralQuestion input[name$='allowEditor']").prop("disabled", true);
					        	$("#createGeneralQuestion input[name$='isMultipleChoices']").prop("disabled", false);
					        	$("#createGeneralQuestion input[name$='allowComment']").prop("disabled", false);
					        }

					    });

					    $("#createGeneralQuestion .checkRadioBtns1").click(function() {
					       	var YesNoValue = $("#createGeneralQuestion input[name='isYesNo']:checked").val();
					       	var allowEditorValue = $("#createGeneralQuestion input[name='allowEditor']:checked").val();
					       	var isMultipleAnswersValues = $("#createGeneralQuestion input[name='isMultipleAnswers']:checked").val();
					        if(YesNoValue == 0 && allowEditorValue == 0 && isMultipleAnswersValues == 0)
					        {
					        	$("#createGeneralQuestion .errorDisplay1").text("Must Enable One");
					        }else{
					        	$("#createGeneralQuestion .errorDisplay1").text("");
					        }

					    });

					    <!--- Logic validation for Form(CREATESPECIFICQUESTION) --->
					    $("#createSpecificQuestion input[name$='isYesNo']").click(function() {
					        var test = $(this).val();
					        if(test == 0)
					        {
					        	$("#createSpecificQuestion input[name$='allowEditor']").prop("disabled", false);
					        	$("#createSpecificQuestion input[name$='isMultipleAnswers']").prop("disabled", false);
					        	$("#createSpecificQuestion input[name$='isMultipleChoices']").prop("disabled", true);
					        	$("#createSpecificQuestion input[name$='allowComment']").prop("disabled", true);
					        }else{
					        	$("#createSpecificQuestion input[name$='allowEditor']").prop("disabled", true);
					        	$("#createSpecificQuestion input[name$='isMultipleAnswers']").prop("disabled", true);
					        	$("#createSpecificQuestion input[name$='isMultipleChoices']").prop("disabled", true);
					        	$("#createSpecificQuestion input[name$='allowComment']").prop("disabled", true);
					        }

					    });

					    $("#createSpecificQuestion input[name$='allowEditor']").click(function() {
					        var test = $(this).val();
					        if(test == 0)
					        {
					        	$("#createSpecificQuestion input[name$='isYesNo']").prop("disabled", false);
					        	$("#createSpecificQuestion input[name$='isMultipleAnswers']").prop("disabled", false);
					        	$("#createSpecificQuestion input[name$='isMultipleChoices']").prop("disabled", true);
					        	$("#createSpecificQuestion input[name$='allowComment']").prop("disabled", true);
					        }else{
					        	$("#createSpecificQuestion input[name$='isYesNo']").prop("disabled", true);
					        	$("#createSpecificQuestion input[name$='isMultipleAnswers']").prop("disabled", true);
					        	$("#createSpecificQuestion input[name$='isMultipleChoices']").prop("disabled", true);
					        	$("#createSpecificQuestion input[name$='allowComment']").prop("disabled", true);
					        }

					    });

					    $("#createSpecificQuestion input[name$='isMultipleAnswers']").click(function() {
					        var test = $(this).val();
					        if(test == 0)
					        {
					        	$("#createSpecificQuestion input[name$='isYesNo']").prop("disabled", false);
					        	$("#createSpecificQuestion input[name$='allowEditor']").prop("disabled", false);
					        	$("#createSpecificQuestion input[name$='isMultipleChoices']").prop("disabled", true);
					        	$("#createSpecificQuestion input[name$='allowComment']").prop("disabled", true);
					        }else{
					        	$("#createSpecificQuestion input[name$='isYesNo']").prop("disabled", true);
					        	$("#createSpecificQuestion input[name$='allowEditor']").prop("disabled", true);
					        	$("#createSpecificQuestion input[name$='isMultipleChoices']").prop("disabled", false);
					        	$("#createSpecificQuestion input[name$='allowComment']").prop("disabled", false);
					        }

					    });

					    $("#createSpecificQuestion .checkRadioBtns2").click(function() {
					       	var YesNoValue2 = $("#createSpecificQuestion input[name='isYesNo']:checked").val();
					       	var allowEditorValue2 = $("#createSpecificQuestion input[name='allowEditor']:checked").val();
					       	var isMultipleAnswersValues2 = $("#createSpecificQuestion input[name='isMultipleAnswers']:checked").val();
					        if(YesNoValue2 == 0 && allowEditorValue2 == 0 && isMultipleAnswersValues2 == 0)
					        {
					        	$("#createSpecificQuestion .errorDisplay2").text("Must Enable One");
					        }else{
					        	$("#createSpecificQuestion .errorDisplay2").text("");
					        }

					    });

						$(document).ready(function (){

							$("#menu-toggle").click(function(e) {
					     		 e.preventDefault();
					      	$("#wrapper").toggleClass("toggled");

					   });


					    $('.OfferedAnswers').on('click', function () {
							var myModal = $('#periodAddModal');
					       	var currentRow=$(this).closest("tr");  // Finds the closest row <tr>
		                    var Question=currentRow.find("td:eq(0)").text(); // get current row 1st TD value
						    //console.log(Question);
						    $('.QuestionDisplay').text(Question);
							$('.QuestionFull').val(Question);
						    myModal.modal('show');
					    	return false;
		                    $('#periodAddModal').on('shown.bs.modal', function () {

		                    });
					    });



					    //Add question to SurveyTable
						 $(".deleteQuestion").click(function() {
					    	var currentRow=$(this).closest("tr");  // Finds the closest row <tr>
	                       	var deleteQuestionName = currentRow.find("td:eq(0)").text(); // get current row 1st TD value
	                       	var deleteQuestionRequired = currentRow.find("td:eq(1)").text();
	                       	var deleteQuestionYesNo = currentRow.find("td:eq(2)").text();
	                       	var deleteQuestionAllowEditor = currentRow.find("td:eq(3)").text();
	                       	var deleteQuestionIsMultipleAnswers = currentRow.find("td:eq(4)").text();
	                       	var deleteQuestionIsMultipleChoices=currentRow.find("td:eq(5)").text();
	                       	var deleteQuestionAllowComment=currentRow.find("td:eq(6)").text();
					       	//console.log(deleteQuestionRequired);
					       	$.confirm({
									    title: 'Delete Question',
									    content: 'Are you sure you want to delete this question ?',
									    buttons: {
									        confirm: function () {
									            $.redirect('createQuestionsForm.cfm', {"deleteQuestionName":deleteQuestionName,<cfif structKeyExists(form,"SurveyID")>"SurveyID":"<cfoutput>#form.SurveyID#</cfoutput>"</cfif>,
									            										"deleteQuestionRequired":deleteQuestionRequired,"deleteQuestionYesNo":deleteQuestionYesNo,
									            										"deleteQuestionAllowEditor":deleteQuestionAllowEditor,"deleteQuestionIsMultipleAnswers":deleteQuestionIsMultipleAnswers,
									            										"deleteQuestionIsMultipleChoices":deleteQuestionIsMultipleChoices,"deleteQuestionAllowComment":deleteQuestionAllowComment});
									        },
									        cancel: function () {
									        }
									    }
									});

					    });

					});
				  </script>
				  <style>
					input[type=checkbox].css-checkbox {
						position:absolute; z-index:-1000; left:-1000px; overflow: hidden; clip: rect(0 0 0 0); height:1px; width:1px; margin:-1px; padding:0; border:0;
					}

					input[type=checkbox].css-checkbox + label.css-label {
						padding-left:30px;
						height:25px;
						display:inline-block;
						line-height:25px;
						background-repeat:no-repeat;
						background-position: 0 0;
						font-size:20px;
						vertical-align:middle;
						cursor:pointer;

					}

					input[type=checkbox].css-checkbox:checked + label.css-label {
						background-position: 0 -25px;
					}
					label.css-label {
						background-image:url(http://csscheckbox.com/checkboxes/u/csscheckbox_391ce065f36b1460c4845fa9b5173fba.png);
						-webkit-touch-callout: none;
						-webkit-user-select: none;
						-khtml-user-select: none;
						-moz-user-select: none;
						-ms-user-select: none;
						user-select: none;
					}
				 </style>
			 	 <!--- For the datepicker --->
				<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
				<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
				<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
				<!--- For the whole Page --->
				<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
				<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-lite/1.1.0/material.min.css">
				<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
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