<cfsetting showDebugOutput="YES">

<cfset encrypted_logout = Encrypt("true","#application.encryptKey#","AES","Hex")>
<!--- <cfset this.loginServices = createObject("component","SurveyApp.components.loginServices")> --->
<cfset this.UserGateway = createObject("component","SurveyApp.gateway.UserGateway") />

<cfset this.SurveysGateway = createObject("component","SurveyApp.gateway.SurveysGateway")>
<cfset this.GeneralQuestionsGateway = createObject("component","SurveyApp.gateway.GeneralQuestionsGateway")>
<cfset this.SpecificQuestionsGateway = createObject("component","SurveyApp.gateway.SpecificQuestionsGateway")>
<cfset this.AnswersGateway = createObject("component","SurveyApp.gateway.AnswersGateway")>
<cfset this.PeriodsGateway = createObject("component","SurveyApp.gateway.PeriodsGateway")>
<cfif structKeyExists(session,"userID")>
	<cfset userID = "#session.UserID#">
	<cfset qUser = this.UserGateway.getUsersData(ID = "#userID#")>
	<cfif qUser.Admin EQ 1>
	<!doctype html>
	<html>
	  <head>
		    <meta charset="utf-8">
		    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		    <title>Administration Page</title>
		    <link href="css/indexStyle.css" type="text/css" rel="stylesheet">
		    <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
			<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
			<script src="https://momentjs.com/downloads/moment.js"></script>
			<!--- Form Validation --->
			<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.1/dist/jquery.validate.js"></script>
			<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.1/dist/additional-methods.min.js"></script>
			<!--- Redirect Plugin --->
			<script src="https://cdn.rawgit.com/mgalante/jquery.redirect/master/jquery.redirect.js"></script>
			<!--- AlertifyJS --->
			<script src="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/alertify.min.js"></script>
			<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/alertify.min.css"/>
			<link rel="stylesheet" href="//cdn.jsdelivr.net/npm/alertifyjs@1.13.1/build/css/themes/bootstrap.min.css"/>
			<!--- For the dataTables with Surveys --->
			<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
			<link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css">
			<!--- DataTables Bootstrap Styling --->
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.1.3/css/bootstrap.css">
			<!--- JQuery UI --->
			<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
			<link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet">
			<!--- Jquery Confirm,Alert... Plugin --->
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
			<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>
			<!--- Table sciprts and css files--->
			<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round">
			<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
			<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
			<link rel="stylesheet" href="css/tableStyle.css">
		</head>

		<body>
			<script>

						<!--- Sidenav divs loading and hiding --->

						<!--- /Sidenav divs loading and hiding --->

						<!--- Table with all the surveys --->
						$(document).ready(function (){

							<!--- JQUERY VALIDATION --->
							$("#formPeriod").validate({
								rules: {
									startDatePeriod:"required",
									endDatePeriod:{
											required:true,
											greaterThan: "#startDatePeriod"
									},
									showPreviousAnswers:"required",
									editPreviousAnswers:"required"

								},
								messages: {
									startDatePeriod:"Please fill in this field",
									endDatePeriod: {
											required:"Please fill in this field",
											greaterThan:"End Date must be grater than the Start Date"
										},
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

							<!--- Report Modal Form Validation --->
							$("#reportFormDate").validate({
								rules: {
									startDatePeriodReport:"required",
									endDatePeriodReport:{
											required:true,
											greaterThan: "#startDatePeriodReport"
									},
									reportFormat:"required"
								},
								messages: {
									startDatePeriodReport:"Please choose a date",
									endDatePeriodReport: {
											required:"Please choose a date",
											greaterThan:"End Date must be grater than the Start Date"
										},
									reportFormat:"Please fill in this field",

								},
								highlight: function (element) {
			           					 $(element).parent().addClass('error')
			       				 },
			        			unhighlight: function (element) {
			           					 $(element).parent().removeClass('error')
			        			}
							});

							$("#reportFormPeriods").validate({
								rules: {
									reportFormat:"required"
								},
								messages: {
									reportFormat:"Please fill in this field"

								},
								highlight: function (element) {
			           					 $(element).parent().addClass('error')
			       				 },
			        			unhighlight: function (element) {
			           					 $(element).parent().removeClass('error')
			        			}
							});




							<!--- $("#SurveysLink").click(function (){
								$("#surveyDiv").css("display","block");
								$("#reportsDiv").css("display","none");
							});

							$("#ReportsLink").click(function (){

								$("#surveyDiv").css("display","none");
								$("#reportsDiv").css("display","block");
							}); --->

							<!--- DataTable Ajax Option for loading Surveys --->
							<!--- var surveyDataTable = $('#surveysData').DataTable( {
													"processing":true,
													"serverSide":true,
											        "ajax": {
													            url: "components/surveysDataTable.cfc",
													            dataSrc:"data",
													            data:{
													            		method:'SurveysData'
													            	}
											        		},
													"columns": [
														            { "data": "NAME" },
														            { "data": "STARTDATE"},
														            { "data": "ENDDATE" },
														            { "data": "ACTIVE",
														            	"render": function (data, type, row){
														            		return (data == true) ? '<strong>Active</strong>' : '<strong>Not Active</strong>'
														            	}
														            },
														            { "data": "CREATEDATE"},
														            { "data": "CREATEDBY" },
														            {
														                data: null,
														                className: "center",
														                defaultContent: '<button class="editor_add_period btn btn-primary">Add Period</button> <!--- <button class="editor_remove btn btn-primary">Delete</button> ---> <button class="editor_deactivate_activate btn btn-primary">Change Active-Status</button>'
														            }
														        ],
													columnDefs:[
													{
														targets:[1,2,4], render:function(data){
		      											return moment(data).format('MMMM Do YYYY');
		    											}
													},
													<!--- {

														targets:5,render:function(data){
															<cfset qUserIDName = this.UserGateway.getUsersData("")>
															return
														}
													}, --->
		    										{
										                targets: [ 0, 3 ],
										                className: 'mdl-data-table__cell--non-numeric'
										            }
		    										],
												}); --->

							<!--- /Table with all the surveys --->

						    //Deactivate or Activate method
						    $(".editActive").click(function() {
						    	var currentRow=$(this).closest("tr");  // Finds the closest row <tr>
		                       	var changeActiveSurvey=currentRow.find("td:eq(0)").text(); // get current row 1st TD value
						         //console.log(changeActiveSurvey);
						          $.confirm({
								    title: 'Change Active Status of Survey',
								    content: 'Are you sure you want to change status: ',
								    buttons: {
								        confirm: function () {
								            $.redirect('adminPage.cfm', {"changeActiveSurveyName":changeActiveSurvey});
								        },
								        cancel: function () {
								        }
								    }
								});

						    });

							//Info About Disabled Multiple Period Surveys
							$(".disabledMultipleRecords").click(function() {
							    $.confirm({
									    title: 'Multiple Period (DISABLED)',
									    content: "There Multiple Period Option is disabled for Selected Survey",
									    buttons: {
									        info: {
									        	text: 'OK',
									        	action: function(){}
								        }
									   }
									});
							});

							//Refresh Active Status
							 $(".checkActiveStatus").click(function() {
						    	var currentRow=$(this).closest("tr");  // Finds the closest row <tr>
		                       	var refreshActiveName=currentRow.find("td:eq(0)").text(); // get current row 1st TD value
						         //console.log(changeActiveSurvey);
						          $.confirm({
								    title: '',
								    content: 'Active Status of this Survey will be refreshed: ',
								    buttons: {
								        info:{
								        	text:"OK",
								        	action:function () {
								            	$.redirect('adminPage.cfm', {"refreshActiveName":refreshActiveName});
								        	}
								        }

								    }
								});

						    });


							//Edit Survey Click Handler
							 $(".editSurvey").click(function() {
						    	var currentRow=$(this).closest("tr");  // Finds the closest row <tr>
		                       	var editSurvey=currentRow.find("td:eq(0)").text(); // get current row 1st TD value
						         //console.log(changeActiveSurvey);
								$.redirect('editSurveyForm.cfm', {"editSurvey":editSurvey});
						    });

					});

			</script>
			<style>
				#formPeriod .error {
		   			color: red;
				}
				#reportFormDate .error{
					color: red;
				}
				#reportFormPeriods .error{
					color: red;
				}
				.activeDiv{
					background-color: #666;
				}
			</style>
			<!--- Getting all the Surveys --->
			<cfset qSurveys = this.SurveysGateway.getSurveyData()>
			<!--- <cfdump var = "#qSurveys#"><cfabort> --->
			<!--- Getting all the users that are ADMINS --->
			<cfset qUsersAdmins = this.UserGateway.getUsersData(Admin = 1)>
			<!--- <cfdump var = "#qUsersAdmins#"><cfabort> --->

			<!--- Getting all the periods that the Surveys are having --->
			<cfset qPeriods = this.PeriodsGateway.getPeriodsData()>
			<!--- <cfdump var = "#qPeriods#"><cfabort> --->


			<!--- Site Wrapper --->
				<div class="d-flex" id="wrapper">
					<!--- Sidebar --->
				    <div class="bg-light border-right" id="sidebar-wrapper">
				      <div class="sidebar-heading"><strong>Menu</strong></div>
				      <hr>
				      <div class="list-group list-group-flush" id="sidenav">
					      <a id="SurveysLink" class="list-group-item list-group-item-action bg-light" style="cursor:pointer">Surveys</a>
					      <!--- <a id="ReportsLink" class="list-group-item list-group-item-action bg-light" style="cursor:pointer">Reports</a> --->
				      </div>
				 	</div>
				    <!--- /Sidebar --->

				    <!--- Page Content --->
				    <div id="page-content-wrapper">
					<!--- Top navbar --->
				      <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
				        <button class="btn btn-primary" id="menu-toggle">Collapse</button>

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

				      <div class="container-fluid">
						  <div class="page-wrapper bg-gra-03 p-t-45 p-b-50">
							<div class="wrapper wrapper--w790">
								<br />
								<div class="container">
							        <div id="surveyDiv" class="table-wrapper">
							            <div class="table-title">
							                <div class="row">
							                    <div class="col-sm-6">
													<h2>Manage <b>Surveys</b></h2>
												</div>
												<div class="col-sm-6">
													<a href="createSurveyForm.cfm" class="btn btn-success"><i class="material-icons">&#xE147;</i> <span>Create New Survey</span></a>
												</div>
							                </div>
							            </div>
							            <table class="table table-bordered table-hover">
							                <thead>
							                    <tr>
								                    <th>Name</th>
									                <th width="230px">Periods</th>
									                <th>Active</th>
									                <th>CreateDate</th>
									                <th>CreatedBy</th>
									                <th>Actions</th>
									                <th>Reports/Testing</th>
							                    </tr>
							                </thead>
							                <tbody>
							                    <cfloop query="#qSurveys#">
							                    	<cfset qPeriodsForSurvey = this.PeriodsGateway.getPeriodsData(SurveyID = "#qSurveys.ID#")>
							                    	<!--- <cfdump var = "#qPeriodsForSurvey#"> --->
								                    <tr>
									                    <td><cfoutput><strong>#qSurveys.Name#</strong></cfoutput></td>
								                        <td>
									                        <cfloop query="qPeriodsForSurvey">
										                        <cfoutput><u>#qPeriodsForSurvey.StartDatePeriod#</u></cfoutput> <span class="material-icons" style="font-size:12px"><strong>arrow_right_alt</strong></span> <cfoutput><u>#qPeriodsForSurvey.EndDatePeriod#</u></cfoutput><br />
															</cfloop>
														</td>
														<td>
															<cfif "#qSurveys.Active#" EQ 1>
																<cfoutput>ACTIVE</cfoutput>
															<cfelse>
																<cfoutput>NOT ACTIVE</cfoutput>
															</cfif>
														</td>
								                        <td><cfoutput>#qSurveys.CreateDate#</cfoutput></td>
								                        <td>
									                        <cfloop query="#qUsersAdmins#">
									                        	<cfif "#qSurveys.CreatedBy#" EQ "#qUsersAdmins.ID#">
										                        	<cfoutput>#qUsersAdmins.Firstname# #qUsersAdmins.Lastname#</cfoutput>
									                        	</cfif>
									                        </cfloop>
														</td>
								                        <td>
															<button class="BtnAsLink"><a type="button" class="edit editSurvey" title="Edit Survey"><i class="material-icons">create</i></a></button>
								                            <!--- Enabled ADD PERIOD ONLY IF SURVEY HAS ALLOWMULTIPLEPERIODS --->
								                            <cfif "#qSurveys.AllowMultiplePeriods#" EQ 1>
								                            	<button type="button" class="BtnAsLink dateRange" data-toggle="modal" data-target="#periodAddModal"><a class="date" title="Add Period"><i class="material-icons">settings</i></a></button>
								                            <cfelse>
								                            	<button type="button" class="BtnAsLink periodChange" data-toggle="modal" data-target="#periodChangePerference"><a class="date" title="Change Period Preferences"><i class="material-icons">settings</i></a></button>
															</cfif>
															<button class="BtnAsLink"><a type="button" class="settings editActive" title="Change Active Status"><i class="material-icons">redo</i></a></button>
								                            <!--- <button type="button" class="BtnAsLink checkActiveStatus"><a class="refresh" title="Refresh Active Status"><i class="material-icons">settings_backup_restore</i></a></button> --->
								                        </td>
								                        <td>
									                         <button type="button" class="BtnAsLink surevyAdminTest"><a title="Test Survey"><i class="material-icons">biotech</i></a></button>
									                        <button type="button" class="BtnAsLink reportGenerate" data-toggle="modal" data-target="#reportsModal"><a class="settings" title="Choice Report Preferences"><i class="material-icons">assignment</i></a></button>
														</td>
							                    	</tr>
												</cfloop>
							                </tbody>
							            </table>
										<!--- <div class="clearfix">
							                <div class="hint-text">Showing <b>5</b> out of <b>25</b> entries</div>
							                <ul class="pagination">
							                    <li class="page-item disabled"><a href="#">Previous</a></li>
							                    <li class="page-item"><a href="#" class="page-link">1</a></li>
							                    <li class="page-item"><a href="#" class="page-link">2</a></li>
							                    <li class="page-item active"><a href="#" class="page-link">3</a></li>
							                    <li class="page-item"><a href="#" class="page-link">4</a></li>
							                    <li class="page-item"><a href="#" class="page-link">5</a></li>
							                    <li class="page-item"><a href="#" class="page-link">Next</a></li>
							                </ul>
							            </div> --->
							        </div>
							    </div>
								<br />
								<!--- Refresh Active Status --->
								<cfif structKeyExists(form,"refreshActiveName") AND form.refreshActiveName NEQ "">
									<cfset qSurveyCheck = this.SurveysGateway.getSurveyData(Name = "#form.refreshActiveName#")>
									<cfset refreshActiveID = "#qSurveyCheck.ID#">
									<!--- <cfdump var = "#refreshActiveID#"> --->
									<cfset qPeriodsSurvey = this.PeriodsGateway.getPeriodsData(SurveyID = "#refreshActiveID#")>
									<!--- <cfdump var = "#qPeriodsSurvey#"> --->
									<cfset surveyActive = 0>
									<cfset todaysDate = DateFormat(now(),"yyyy-mm-dd")>
									<cfloop query="#qPeriodsSurvey#">
										<cfset startDate = "#qPeriodsSurvey.STARTDATEPERIOD#">
										<cfset endDate = "#qPeriodsSurvey.ENDDATEPERIOD#">
										<!--- checking if Survey is ACTIVE and the dates of the survey --->
										<cfif startDate LTE todaysDate AND endDate GTE todaysDate>
											<cfset surveyActive = 1>
											<cfset this.SurveysGateway.updateStartEndDate(ID = "#refreshActiveID#",StartDate = "#startDate#",EndDate = "#endDate#")>
										<cfelse>
											<cfif todaysDate GT startDate AND todaysDate GT endDate>
												<cfset this.PeriodsGateway.updatePeriodExpired(ID = "#qPeriodsSurvey.ID#")>
											</cfif>
										</cfif>
									</cfloop>
									<!--- <cfdump var = "#surveyActive#"> --->
									<cfif #surveyActive# EQ 1>
										<cfset this.SurveysGateway.updateActive(ID = "#refreshActiveID#")>
									<cfelse>
										<cfset this.SurveysGateway.updateNotActive(ID = "#refreshActiveID#")>
									</cfif>
									<cfset structClear(form)>
									<!--- Refreshing the page  --->
									<script>
										window.location.href = "http://localhost:8500/SurveyApp/adminPage.cfm";
									</script>
								</cfif>

								<!--- Changing Active Status --->
								<cfif structKeyExists(form,"CHANGEACTIVESURVEYNAME") AND form.CHANGEACTIVESURVEYNAME NEQ "">
									<cfset deactivateSurveyName = "#form.CHANGEACTIVESURVEYNAME#">
									<!--- <cfdump var="#deactivateSurveyName#"><cfabort> --->
									<cfset this.SurveysGateway.changeActiveStatus(Name = "#deactivateSurveyName#")>
									<cfset structClear(form)>
									<!--- Refreshing the page  --->
									<script>
										window.location.href = "http://localhost:8500/SurveyApp/adminPage.cfm";
									</script>
								</cfif>

								<!--- Adding Period to the Selected Survey --->
								<cfif structKeyExists(form,"startDatePeriod") AND structKeyExists(form,"endDatePeriod") AND structKeyExists(form,"surveyName") AND structKeyExists(form,"showPreviousAnswers")
														AND form.startDatePeriod NEQ "" AND form.endDatePeriod NEQ "" AND form.surveyName NEQ "" AND form.showPreviousAnswers NEQ "">
									<cfset qSurveyCheck = this.SurveysGateway.getSurveyData(Name = "#form.surveyName#")>
									<!--- <cfdump var = "#qSurveyCheck#"> --->
									<cfset SurveyCheckID = "#qSurveyCheck.ID#">
									<!--- <cfdump var = "#SurveyCheckID#"> --->
									<cfset qPeriodsSurvey = this.PeriodsGateway.getPeriodsData(SurveyID = "#SurveyCheckID#")>
									<!--- <cfdump var = "#qPeriodsSurvey#"> --->
									<cfloop query="#qPeriodsSurvey#">
										<cfset InsertedStartPeriod = "#form.startDatePeriod#">
										<cfset InsertedEndPeriod = "#form.endDatePeriod#">
										<cfset loopingStartPeriod = "#qPeriodsSurvey.StartDatePeriod#">
										<cfset loopingEndPeriod = "#qPeriodsSurvey.EndDatePeriod#">
										<!--- this CFIF checks if there is any overlaping dates with the other periods of that Survey--->
										<cfset dateOverlap = 0>
										<cfif (InsertedStartPeriod LTE loopingEndPeriod) AND (InsertedEndPeriod GTE loopingStartPeriod)>
											<cfset dateOverlap = 1>
											<cfbreak>
										</cfif>
									</cfloop>
									<cfif "#dateOverlap#" EQ 1>
										<script>
											$.confirm({
											    title: 'Error',
											    content: "There was an error while inserting you're selected Period (hint: Overlaping)",
											    buttons: {
											        info: {
											        	text: 'OK',
											        	action: function(){
											        		<!--- Refreshing the page  --->
											            		window.location.href = "http://localhost:8500/SurveyApp/adminPage.cfm";
											        		}
										        }
											   }
											});
										</script>
									<cfelse>
										<cfset todaysDate = DateFormat(now(),"yyyy-mm-dd")>
										<!--- Checks if the user enabled ShowPreviousAnswers and entered a value in EditPreviousAnswers OR did not enable ShowPreviousAnswers --->
										<cfif structKeyExists(form,"editPreviousAnswers") AND form.editPreviousAnswers NEQ "">
											<cfset this.PeriodsGateway.insertPeriod(SurveyID = "#SurveyCheckID#",StartDatePeriod = "#form.startDatePeriod#",EndDatePeriod = "#form.endDatePeriod#",ShowPreviousAnswers = "#form.showPreviousAnswers#",EditPreviousAnswers = "#form.editPreviousAnswers#",PeriodExpired = 0,CreatedDate = "#todaysDate#")>
											<cfset this.SurveysGateway.updateActive(ID = "#SurveyCheckID#")>
										<cfelse>
											<cfset this.PeriodsGateway.insertPeriod(SurveyID = "#SurveyCheckID#",StartDatePeriod = "#form.startDatePeriod#",EndDatePeriod = "#form.endDatePeriod#",ShowPreviousAnswers = "#form.showPreviousAnswers#",EditPreviousAnswers = 0,PeriodExpired = 0,CreatedDate = "#todaysDates#")>
											<cfset this.SurveysGateway.updateActive(ID = "#SurveyCheckID#")>
										</cfif>
										<!--- Displaying that the period was made --->
											<script>
												$.confirm({
												    title: 'Succesfull',
												    content: "The Period entered was created succefully.Please refresh the status of your survey.",
												    buttons: {
												        info: {
												        	text: 'OK',
												        	action: function(){
												        		<!--- Refreshing the page  --->
												            	window.location.href = "http://localhost:8500/SurveyApp/adminPage.cfm";
												        		}
											        }
												   }
												});
											</script>
									</cfif>
								</cfif>


								<!--- For Deleting Period in MODAL --->
								<cfif structKeyExists(form,"deletePeriodID") AND deletePeriodID NEQ "">
									<cfset qSurveyPeriod = this.PeriodsGateway.getPeriodsData(ID = "#form.deletePeriodID#")>
									<cfset qSurvetPeriodsCheck = this.PeriodsGateway.getPeriodsData(SurveyID = "#qSurveyPeriod.SurveyID#")>
									<!--- <cfdump var = "#qSurvetPeriodsCheck#"> --->
									<cfset todaysDate = DateFormat(now(),"yyyy-mm-dd")>
									<cfset startDate = "#qSurveyPeriod.StartDatePeriod#">
									<cfset endDate = "#qSurveyPeriod.EndDatePeriod#">
									<cfif todaysDate GTE startDate AND todaysDate LTE endDate>
										<cfset structClear(form)>
										<script>
												$.confirm({
												    title: 'Period Not Deleted',
												    content: "You cannot delete an <strong>ACTIVE</strong> Survey's Period.",
												    buttons: {
													        info:{
													        	text:"OK",
													        	action:function () {
																	window.location.href = "http://localhost:8500/SurveyApp/adminPage.cfm";
													        	}
													        }
													    }
												});
										</script>
									<cfelse>
										<cfif qSurvetPeriodsCheck.recordCount EQ 1>
											<script>
												$.confirm({
												    title: 'Period Not Deleted',
												    content: 'This Survey has only one period.Cannot delete the last period of a Survey.',
												    buttons: {
													        info:{
													        	text:"OK",
													        	action:function () {
																	window.location.href = "http://localhost:8500/SurveyApp/adminPage.cfm";
													        	}
													        }
													    }
												});
											</script>
										<cfelse>
											<cfset this.PeriodsGateway.deletePeriod(ID = "#form.deletePeriodID#")>
											<cfset structClear(form)>
											<script>
												$.confirm({
												    title: 'Deleted Period',
												    content: 'The period was deleted.',
												    buttons: {
													        info:{
													        	text:"OK",
													        	action:function () {
																	window.location.href = "http://localhost:8500/SurveyApp/adminPage.cfm";
													        	}
													        }

													    }
												});
											</script>
										</cfif>
									</cfif>
								</cfif>


								<!--- For Changing Survey's Period Preferences --->
								<cfif structKeyExists(form,"editPeriodID") AND structKeyExists(form,"changePeriodShowAnswers") AND structKeyExists(form,"changePeriodEditAnswers")>
									<cfset this.PeriodsGateway.changePeriodPreferences(ID = "#form.editPeriodID#",ShowPreviousAnswers = "#changePeriodShowAnswers#",EditPreviousAnswers = "#changePeriodEditAnswers#")>
									<cfset structClear(form)>
									<script>
										$.confirm({
												    title: 'Period Preferences Change',
												    content: 'The Period preferences were successfully <strong>changed</strong>.',
												    buttons: {
													        info:{
													        	text:"OK",
													        	action:function () {
																	window.location.href = "http://localhost:8500/SurveyApp/adminPage.cfm";
													        	}
													        }

													    }
												});
									</script>
								</cfif>

								<!--- Generating report on PERIODS SELECTED --->
								<cfif structKeyExists(form,"periodReportSubmit") AND structKeyExists(form,"reportFormat")>
									<!--- <cfdump var = "#form#"><cfabort> --->
									<cfif structKeyExists(form,"periodChoosen")>
										<!--- <cfdump var="#form#"> --->
										<!--- <cfset periods = listToArray ("#form.periodChoosen#", ",",false,false)> --->
										<!--- <cfdump var = "#periods#"> --->
										<!--- <cfdump var = "#periods#"> --->
										<cfset periodsEncrypted = Encrypt("#form.periodChoosen#","#application.encryptKey#","AES","Hex")>
										<cfset fileFormat = Encrypt("#form.reportFormat#","#application.encryptKey#","AES","Hex")>
										<cfset structClear(form)>
										<script>
											window.open('http://localhost:8500/SurveyApp/reportDownload.cfm?P=<cfoutput>#periodsEncrypted#</cfoutput>&F=<cfoutput>#fileFormat#</cfoutput>');
											window.location.href="http://localhost:8500/SurveyApp/adminPage.cfm";
										</script>
									<cfelse>
										<cfset structClear(form)>
										<script>
											$.confirm({
												    title: 'Period(s) Not Choosen',
												    content: "You didn't choose any of the given periods.",
												    buttons: {
													        info:{
													        	text:"OK",
													        	action:function () {
																	window.location.href = "http://localhost:8500/SurveyApp/adminPage.cfm";
													        	}
													        }

													    }
												});
										</script>
									</cfif>
								</cfif>

								<!--- Genrating Report on DATERANGE SELECTED --->
								<cfif structKeyExists(form,"DATERANGEREPORTSUBMIT") AND structKeyExists(form,"reportFormat")>
									<cfdump var = "#form#">
									<cfif structKeyExists(form,"dateRangePeriod")>
										<cfset periodIDEncrypted = Encrypt("#form.dateRangePeriod#","#application.encryptKey#","AES","Hex")>
										<cfset reportFormatEncrypted = Encrypt("#form.reportFormat#","#application.encryptKey#","AES","Hex")>
										<script>
											window.open('http://localhost:8500/SurveyApp/reportDownload.cfm?P=<cfoutput>#periodIDEncrypted#</cfoutput>&F=<cfoutput>#reportFormatEncrypted#</cfoutput>');
											window.location.href="http://localhost:8500/SurveyApp/adminPage.cfm";
										</script>
									<cfelse>
										<cfset structClear(form)>
										<script>
											$.confirm({
												    title: 'Period(s) Not Choosen',
												    content: "You didn't choose any of the given periods.",
												    buttons: {
													        info:{
													        	text:"OK",
													        	action:function () {
																	window.location.href = "http://localhost:8500/SurveyApp/adminPage.cfm";
													        	}
													        }

													    }
												});
										</script>
									</cfif>

								</cfif>

								<!--- GETTING ID FOR THE SELECTED SURVEY --->
								<cfif structKeyExists(form,"testSurveyID") AND form.testSurveyID NEQ "">
									<cfset qSurvey = this.SurveysGateway.getSurveyData(Name = "#form.testSurveyID#")>
									<cfset surveyID = "#qSurvey.ID#">
									<cfset structClear(form)>
									<script>
										 var msg = alertify.message('Default message');
										 msg.delay(4).setContent('<strong><em>Loading Testing Site...</em></strong>');
										setTimeout(function(){ $.redirect('adminSurveyTest.cfm', {"surveyID": "<cfoutput>#surveyID#</cfoutput>" }); }, 4000);
									</script>
								</cfif>
								<!--- ALERTING FOR PROBLEM WHILE TRYING TO LOAD SURVEY --->
								<cfif structKeyExists(url,"TSP") AND url.TSP NEQ "">
									<cfset value=Decrypt("#url.TSP#","#application.encryptKey#","AES","Hex")>
									<cfset structClear(url)>
									<script>
										$.confirm({
											    title: 'Survey Testing Failed',
											    content: "There was a problem while executing Survey testing.",
											    buttons: {
												        info:{
												        	text:"OK",
												        	action:function () {
												        	}
												        }

												    }
											});
									</script>
								</cfif>
							</div>
						</div>
					</div>
				  </div>

				  	<!-- MODAL FOR PERIOD CHANGE ON ISMULTIPLEPERIOD : FALSE -->
				  	 <div class="modal fade" id="periodChangePerference" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
						<div class="modal-dialog modal-dialog-centered modal-lg">
						    <div class="modal-content">
							      <div class="modal-header">
							        <h5 class="modal-title"><strong>PERIODS</strong></h5>
							        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
							          <span aria-hidden="true">&times;</span>
							        </button>
							      </div>
							      <div class="modal-body">
							      	<p style="padding-left:10px;padding-right:20px">Edit or create Periods for the selected Survey:</p>
							      	<h2 class="displaySurveyName" style="padding-left:10px;padding-right:20px"></h2>
							      	<br />
								      	<p style="padding-left:10px;padding-right:20px"><strong>Current Periods :</strong></p>
							      	<table id="periodTableModal" class="table table-bordered">
							          <thead>
								          	<th width="300px">Period</th>
								          	<th>Active Status</th>
								          	<th>Show Previous Answers</th>
								          	<th>Edit Previous Answers</th>
								          	<th width="100px">Actions</th>
								      </thead>
							          <tbody>
							          </tbody>
							        </table>
							        <br />
								 </div>
							</div>
						</div>
					</div>




				    <!-- Modal for adding periods -->
				    <div class="modal fade" id="periodAddModal" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
					  <div class="modal-dialog modal-dialog-centered modal-lg">
					    <div class="modal-content">
						      <div class="modal-header">
						        <h5 class="modal-title"><strong>PERIODS</strong></h5>
						        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
						          <span aria-hidden="true">&times;</span>
						        </button>
						      </div>
						      <div class="modal-body">
						      	<p style="padding-left:10px;padding-right:20px">Edit or create Periods for the selected Survey:</p>
						      	<h2 class="displaySurveyName" style="padding-left:10px;padding-right:20px"></h2>
						      	<br />
							      	<p style="padding-left:10px;padding-right:20px"><strong>Current Periods :</strong></p>
						      	<table id="periodTableModal" class="table table-bordered">
						          <thead>
							          	<th width="300px">Period</th>
							          	<th>Active Status</th>
							          	<th>Show Previous Answers</th>
							          	<th>Edit Previous Answers</th>
							          	<th width="100px">Actions</th>
							      </thead>
						          <tbody>
						          </tbody>
						        </table>
						        <br />
						        <hr>
						        <br />
						        <div id="#addPeriod">
							        <h5 style="padding-left:10px;padding-right:20px"><strong>ADD PERIOD</strong></h5>
							        <p style="padding-left:10px;padding-right:20px">You can Add an additional period for your selected survey:</p>
							      	<form name="formPeriod" id="formPeriod" method="POST" action="adminPage.cfm">
								      	<input type="hidden" class="surveyName" name="surveyName">
								        <div class=".col-md-6 .ml-auto" style="padding-left:10px;padding-right:20px">
											<label for="startDatePeriod"><strong>START DATE PERIOD: </strong></label><br />
											<input class="form-control" type="date" name="startDatePeriod" id="startDatePeriod" min='1899-01-01'>
										</div>
										<br />
										<div class=".col-md-6 .ml-auto" style="padding-left:10px;padding-right:20px">
											<label for="endDatePeriod"><strong>END DATE PERIOD: </strong></label><br />
											<input class="form-control" type="date" name="endDatePeriod" id="endDatePeriod" min='1899-01-01' >
										</div>
										<br />
								    	<div class="form-row" style="padding-left:15px">
									      	<div clas=".col-md-6 .ml-auto">
												<label for="showPreviousAnswers"><strong>Show Previous Answers: </strong></label><br />
												<select class="custom-select" name="showPreviousAnswers" id="showPreviousAnswers" onchange="CheckEnabled();">
														<option value="" selected disabled hidden>Select</option>
														<option value="1">Yes</option>
		     											<option value="0">No</option>
												</select>
											</div>
											<div class=".col-md-6 .ml-auto">
												<label for="editPreviousAnswers"><strong>Edit Previous Answers: </strong></label><br />
												<select class="custom-select" name="editPreviousAnswers" id="editPreviousAnswers" disabled>
														<option value="" selected disabled hidden>Select</option>
														<option value="1">Yes</option>
	      												<option value="0">No</option>
												</select>
											</div>
										</div>
										<br />
										<button type="submit" name="periodSubmit" name="periodSubmitBtn" class="btn btn-primary" style="margin-left:10px"><i style="font-size:14px" class="material-icons">add_box</i><span>  ADD</span></button>
										</form>
										<br /><br />
									</div>
							</div>
					    </div>
					  </div>
					</div>

					<!-- Modal for Reports -->
					<div class="modal fade" id="reportsModal" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
					  <div class="modal-dialog modal-dialog-centered">
					    <div class="modal-content">
					      <div class="modal-header">
						      <h3 class="modal-title">Report Preferences</h3>
						      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
							       <span aria-hidden="true">&times;</span>
							  </button>
					      </div>
					      <div class="modal-body">
						      <p>Select your preferences for the <strong>Report</strong> about the Survey you choiced :</p>
						      	<h4 id="reportSurveyName"></h4>
						      	<br />
						      	<div class="custom-control custom-radio custom-control-inline">
								  <input type="radio" id="dateRangeReport" name="reportOption" class="custom-control-input reportType" value="dateRangeOption">
								  <label class="custom-control-label" for="dateRangeReport">Date Range</label>
								</div>
								<div class="custom-control custom-radio custom-control-inline">
								  <input type="radio" id="periodChoiceReport" name="reportOption" class="custom-control-input reportType" value="periodChooseOption">
								  <label class="custom-control-label" for="periodChoiceReport">All Periods</label>
								</div>
								<br /><br /><br />
								<div id="periodChooseOption" style="display:none">
									<form id="reportFormPeriods" method="POST" action="adminPage.cfm" autocomplete="off">
										 <!--- <input type="hidden" name="SurveyID" value="<cfoutput>#surveyID#</cfoutput>"> --->
										 <p>Choose from one of the Periods :</p>
										 <div class="form-row">
											<table id="tablePeriodsReport" class="table table-bordered">
												<thead>
													<th width="500px">Period</th>
													<th>Active Status</th>
													<th>Action</th>
												</thead>
												<tbody>
												</tbody>
											</table>
										</div>
										<br />
										<hr>
										<div class="form-row">
											<div class="col-sm-9">
												<label for="reportFormat"><strong>Format of the Report: </strong></label><br />
												<select class="custom-select" name="reportFormat" id="reportFormat1">
														<option value="" selected disabled hidden>Select</option>
														<option value="pdf">PDF</option>
	      												<option value="excel">Excel</option>
														<option value="word">Word</option>
												</select>
											</div>
										</div>
										<br />
										<button type="submit" name="periodReportSubmit" class="btn btn-primary" style="margin-left:2px"><i style="font-size:14px" class="material-icons">get_app</i><span>  Generate</span></button>
									</form>
								</div>
								<div id="dateRangeOption" style="display:none">
									<form id="reportFormDate" method="POST" action="adminPage.cfm" autocomplete="off">
										 <!--- <input type="hidden" name="SurveyID" value="<cfoutput>#surveyID#</cfoutput>"> --->
										 <p>Pick the Date Range for the Period :</p>
										 <div class="form-row">
											 <div class=".col-6">
												 <label for="startDatePeriodReport"><strong>START DATE: </strong></label><br />
												<input class="form-control" type="date" name="startDatePeriodReport" id="startDatePeriodReport" min='1899-01-01'>
											</div>
											<div class=".col-6">
												<label for="endDatePeriodReport"><strong>END DATE: </strong></label><br />
												<input class="form-control" type="date" name="endDatePeriodReport" id="endDatePeriodReport">
											</div>
										</div>
										<p id="datePickerError" style="color:red"></p>
										<div class="form-row">
											<span style="margin-left:5px;float:right"><button type="button" class="btn btn-outline-secondary" id="dateRangePeriodPick">Reveal</button></span>
										</div>
										<br />
										<div class="form-row">
											<table id="datePickedPeriodTable" class="table table-bordered" style="display:none">
												<thead>
													<th width="500px">Period</th>
													<th>Active Status</th>
													<th>Action</th>
												</thead>
												<tbody>
												</tbody>
											</table>
											<br />
										</div>
										<hr>
										<div class="form-row">
											<div class="col-sm-9">
												<label for="reportFormat"><strong>Format of the Report: </strong></label><br />
												<select class="custom-select" name="reportFormat" id="reportFormat2">
														<option value="" selected disabled hidden>Select</option>
														<option value="pdf">PDF</option>
	      												<option value="excel">Excel</option>
														<option value="word">Word</option>
												</select>
											</div>
										</div>
										<br />
										<button type="submit" name="dateRangeReportSubmit" class="btn btn-primary" style="margin-left:2px"><i style="font-size:14px" class="material-icons">get_app</i><span>  Generate</span></button>
									</form>
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
					  <!--- OnChange ShowPreviousAnswers Enable the EditPreviousAnswers SELECT --->
					  function CheckEnabled() {
				    		var checkValue = $("#showPreviousAnswers").children("option:selected").val();
				    		//console.log(checkValue);
						    if (checkValue == 1) {
						        $("#editPreviousAnswers").prop( "disabled", false );
						    } else {
						        $("#editPreviousAnswers").prop( "disabled", true );
						    }
						}

					<!--- OnChange Check for the ShowPReviousAnswers and EditPreviousAnswers SELECTS --->
					function CheckEnabledModal() {
				    		var checkValue = $(".showPreviousAnswersSelect").children("option:selected").val();
				    		//console.log(checkValue);
						    if (checkValue == 1) {
						        $(".editPreviousAnswersSelect").prop( "disabled", false );
						    } else {
						        $(".editPreviousAnswersSelect").prop( "disabled", true );
						        $('.editPreviousAnswersSelect option[value="0"]').prop('selected', true);
						    }
						}
					function CheckEnabledModalForEdit() {
						var checkValueShow = $(".showPreviousAnswersSelect").children("option:selected").val();
			    		var checkValueEdit = $(".editPreviousAnswersSelect").children("option:selected").val();
			    		//console.log(checkValueShow);
			    		//console.log(checkValueEdit);
					    if (checkValueShow == 1) {
					        $(".editPreviousAnswersSelect").prop( "disabled", false );
					    } else {
					        $(".editPreviousAnswersSelect").prop( "disabled", true );
					        $('.editPreviousAnswersSelect option[value="0"]').prop('selected', true);
					    }
					}

					$(document).ready(function (){
						$("#menu-toggle").click(function(e) {
				     		 e.preventDefault();
				      	$("#wrapper").toggleClass("toggled");



					    });

					    <!--- Date periods modal --->
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
						//console.log(today);
						document.getElementById("startDatePeriod").setAttribute("min", today);
						document.getElementById("endDatePeriod").setAttribute("min", today);

						//SURVEY TEST
						$('.surevyAdminTest').on('click', function (){
							var currentRow=$(this).closest("tr");  // Finds the closest row <tr>
		                    var SurveyName=currentRow.find("td:eq(0)").text();
		                    //console.log(SurveyName);
		                    $.confirm({
							    title: 'Survey Testing',
							    content: 'Are you sure you want to test the survey ?',
							    buttons: {
							        confirm: function () {
							            $.redirect('adminPage.cfm', {"testSurveyID":SurveyName});
							        },
							        cancel: function () {
							        }
							    }
							});

						});


						<!-- FOR REPORTS GENERATING MODAL -->
					    $('.reportGenerate').on('click', function () {
							var modalReports = $('#reportsModal');
					       	var currentRow=$(this).closest("tr");  // Finds the closest row <tr>
		                    var ReportSurveyName=currentRow.find("td:eq(0)").text();
		                    $("#reportSurveyName").text(ReportSurveyName);
		                     // get current row 1st TD value
		                     modalReports.modal({ show: true });
					    	return false;

						});

						$('#reportsModal').on('shown.bs.modal', function () {

								var ReportSurveyName = $("#reportSurveyName").text();
		                    	//console.log(ReportSurveyName);
								$("#datePickedPeriodTable").css("display", "none");

								//FOR DATE RANGE PICK (REPORT MODAL)
		                    	$("#dateRangePeriodPick").click(function (){
									var startDate =	$("#startDatePeriodReport").val();
									var endDate = $("#endDatePeriodReport").val();
									var SurveyName = $("#reportSurveyName").text();
									//console.log(SurveyName);
									//console.log(startDate);
									//console.log(endDate);

									if(startDate == '' || endDate == '')
									{
										$("#datePickerError").text("Choose the dates");
									}else{

										$("#datePickerError").text("");
										$('#datePickedPeriodTable').css("display", "block");
										$.ajax({
								            url:"components/AjaxData.cfm",
								            method: "GET",
								            data:{
												"method":"getPeriodsDatePicked",
								            	"startDatePicked":startDate,
								            	"endDatePicked":endDate,
								            	"SurveyName":SurveyName
								            },
								            dataType:"JSON",
								            success:function(data)
								            {
												var tableData = "";
								            	$.each(data, function (index,value){

													tableData += "<tr><td style='display:none;'>"+ value['ID'] +"</td>";
													var today = new Date();
													var dd = String(today.getDate()).padStart(2, '0');
													var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
													var yyyy = today.getFullYear();
													today = mm + '-' + dd + '-' + yyyy;
													var startDatePeriodCheck = $.datepicker.formatDate('mm-dd-yy', new Date(value['STARTDATEPERIOD']));
													var endDatePeriodCheck = $.datepicker.formatDate('mm-dd-yy', new Date(value['ENDDATEPERIOD']));
													var startDatePeriod =  $.datepicker.formatDate('MM dd, yy', new Date(value['STARTDATEPERIOD']));
													var endDatePeriod = $.datepicker.formatDate('MM dd, yy', new Date(value['ENDDATEPERIOD']));
													tableData += "<td><em>"+ startDatePeriod + " - " + endDatePeriod +"</em></td>";
													if(startDatePeriodCheck <= today && endDatePeriodCheck >= today){
														tableData += "<td style='color:green'><em><strong>Active</strong></em></td>";
														tableData += "<td class='actions'>";
														tableData += '<input type="radio" name="dateRangePeriod" value="'+ value['ID'] +'" disabled>';
														tableData += "</td>";


													}else{
														if(today < startDatePeriodCheck){
															tableData += "<td style='color:red'><em><strong>Not Active</strong><br />(no data)</em></td>";
															tableData += "<td class='actions'>";
															tableData += '<input  type="radio" name="dateRangePeriod" value="'+ value['ID'] +'" disabled>';
															tableData += "</td>";

														}else{
															tableData += "<td style='color:red'><em><strong>Not Active</strong></em></td>";
															tableData += "<td class='actions'>";
															tableData += '<input  type="radio" name="dateRangePeriod" value="'+ value['ID'] +'">';
															tableData += "</td>";
														}
													}
													tableData += "</tr>";
								            	});
									            $("#datePickedPeriodTable tbody").html(tableData);
								            	}
								        	});

									}
		                    	});

		                    	//TYPE OF REPORT SELECTION
								$(".reportType").click(function () {
						    		var option = $("input[name='reportOption']:checked").val();
						    		//console.log(option);
						    		if(option == 'periodChooseOption'){
										$("#periodChooseOption").css( "display", "block");
										$("#dateRangeOption").css( "display", "none");

						    		}else{
										$("#dateRangeOption").css( "display", "block");
										$("#periodChooseOption").css( "display", "none");
						    		}
								});
								<!--- Loading Periods into tablePeriodsReport --->
								$.ajax({
					            url:"components/AjaxData.cfm",
					            method: "GET",
					            data:{
									"method":"getSurveyPeriods",
					            	"ActiveSurveyName":ReportSurveyName
					            },
					            dataType:"JSON",
					            success:function(data)
					            {
									var tableData = "";
					            	$.each(data, function (index,value){

										tableData += "<tr><td style='display:none;'>"+ value['ID'] +"</td>";
										var today = new Date();
										var dd = String(today.getDate()).padStart(2, '0');
										var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
										var yyyy = today.getFullYear();
										today = mm + '-' + dd + '-' + yyyy;
										var startDatePeriodCheck = $.datepicker.formatDate('mm-dd-yy', new Date(value['STARTDATEPERIOD']));
										var endDatePeriodCheck = $.datepicker.formatDate('mm-dd-yy', new Date(value['ENDDATEPERIOD']));
										var startDatePeriod =  $.datepicker.formatDate('MM dd, yy', new Date(value['STARTDATEPERIOD']));
										var endDatePeriod = $.datepicker.formatDate('MM dd, yy', new Date(value['ENDDATEPERIOD']));
										//console.log(startDatePeriodCheck);
										//console.log(endDatePeriodCheck);
										//console.log(today);
										tableData += "<td><em>"+ startDatePeriod + " - " + endDatePeriod +"</em></td>";
										if(startDatePeriodCheck <= today && endDatePeriodCheck >= today){
											tableData += "<td style='color:green'><em><strong>Active</strong></em></td>";
											tableData += "<td class='actions'>";
											tableData += '<input class="{ checkSelectedPeriods: true }" type="radio" name="periodChoosen" value="'+ value['ID'] +'" disabled>';
											tableData += "</td>";


										}else{
											if(today < startDatePeriodCheck){
												tableData += "<td style='color:red'><em><strong>Not Active</strong><br />(no data)</em></td>";
												tableData += "<td class='actions'>";
												tableData += '<input  type="radio" name="periodChoosen" value="'+ value['ID'] +'" disabled>';
												tableData += "</td>";

											}else{
												tableData += "<td style='color:red'><em><strong>Not Active</strong></em></td>";
												tableData += "<td class='actions'>";
												tableData += '<input  type="radio" name="periodChoosen" value="'+ value['ID'] +'">';
												tableData += "</td>";
											}
										}
										tableData += "</tr>";
					            	});
						            $("#tablePeriodsReport tbody").html(tableData);
					            	}
					        	});

							});



							<!-- FOR SURVEYS WITH ISMULTIPLEPERIODS: DISABLED -->
							$('.periodChange').on('click', function () {
								var myModal = $('#periodChangePerference');
						       	var currentRow=$(this).closest("tr");  // Finds the closest row <tr>
			                    var ActiveSurveyName=currentRow.find("td:eq(0)").text(); // get current row 1st TD value
						        $('#periodChangePerference .modal-body .surveyName').val(ActiveSurveyName);
						        $('#periodChangePerference .modal-body .displaySurveyName').text(ActiveSurveyName);
						        $.ajax({
						            url:"components/AjaxData.cfm",
						            method: "GET",
						            data:{
										"method":"getSurveyPeriods",
						            	"ActiveSurveyName":ActiveSurveyName
						            },
						            dataType:"JSON",
						            success:function(data)
						            {
										var tableData = "";
						            	$.each(data, function (index,value){

											tableData += "<tr><td style='display:none;'>"+ value['ID'] +"</td>";
											var today = new Date();
											var dd = String(today.getDate()).padStart(2, '0');
											var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
											var yyyy = today.getFullYear();
											today = mm + '-' + dd + '-' + yyyy;
											var startDatePeriodCheck = $.datepicker.formatDate('mm-dd-yy', new Date(value['STARTDATEPERIOD']));
											var endDatePeriodCheck = $.datepicker.formatDate('mm-dd-yy', new Date(value['ENDDATEPERIOD']));
											var startDatePeriod =  $.datepicker.formatDate('MM dd, yy', new Date(value['STARTDATEPERIOD']));
											var endDatePeriod = $.datepicker.formatDate('MM dd, yy', new Date(value['ENDDATEPERIOD']));
											//console.log(startDatePeriodCheck);
											//console.log(endDatePeriodCheck);
											//console.log(today);

											tableData += "<td><em>"+ startDatePeriod + " - " + endDatePeriod +"</em></td>";

											if(startDatePeriodCheck <= today && endDatePeriodCheck >= today){
												tableData += "<td style='color:green'><em><strong>Active</strong></em></td>";
											}else{
												tableData += "<td style='color:red'><em><strong>Not Active</strong></em></td>";
											}

											if(value['SHOWPREVIOUSANSWERS'] == true){
												tableData += "<td class='editable1'><em>YES</em></td>";
											}else{
												tableData += "<td class='editable1'><em>NO</em></td>";
											}

											if(value['EDITPREVIOUSANSWERS'] == true){
												tableData += "<td class='editable2'><em>YES</em></td>";
											}else{
												tableData += "<td class='editable2'><em>NO</em></td>";
											}

											tableData += "<td class='actions'>";
											tableData += "<button type='button' class='BtnAsLink buttonChange' style='color:#2196F3'><a class='editPeriod'><i class='material-icons'>create</i></a></button>";
											tableData += "</td>";
											tableData += "</tr>";
						            	});
						            	$("#periodChangePerference tbody").html(tableData);
						            }
							      });
							    myModal.modal({ show: true });
							    return false;
							  });

							  $('#periodChangePerference').on('shown.bs.modal', function () {

										// For editPeriod BTN
									   $(".editPeriod").click(function () {
								    	var currentRow=$(this).closest("tr");
								    	var editPeriodID=currentRow.find("td:eq(0)").text();
								    	//console.log(editPeriodID);
								    	var editableShowAnswersValue = currentRow.find(".editable1").text();
								    	var editableEditAnswersValue = currentRow.find(".editable2").text();
								    	//console.log(editableShowAnswers);
								    	//console.log(editableEditAnswers);
										if(editableShowAnswersValue == "YES"){
											var input1 = '<select class="custom-select showPreviousAnswersSelect" name="showPreviousAnswers" onchange="CheckEnabledModal();"><option value="1" selected>YES</option><option value="0">NO</option></select>';
										}else{
											var input1 = '<select class="custom-select showPreviousAnswersSelect" name="showPreviousAnswers" onchange="CheckEnabledModal()"><option value="1">YES</option><option value="0" selected>NO</option></select>';
										}
										if(editableEditAnswersValue == "YES"){
											var input2 = '<select class="custom-select editPreviousAnswersSelect" name="editPreviousAnswers" onchange="CheckEnabledModalForEdit()"><option value="1" selected>YES</option><option value="0">NO</option></select>';
										}else{
											var input2 = '<select class="custom-select editPreviousAnswersSelect" name="editPreviousAnswers" onchange="CheckEnabledModalForEdit()"><option value="1">YES</option><option value="0" selected>NO</option></select>';
										}
								    	currentRow.find(".editable1").html(input1);
								    	currentRow.find(".editable2").html(input2);
								    	currentRow.find(".buttonChange").html("<a class='submitChange'><i class='material-icons'>check_circle</i></a>");

									    	$(".submitChange").click(function() {
												//alert("done");
												var editableShowAnswersValue1 = currentRow.find(".showPreviousAnswersSelect option:selected").val();
									    		var editableEditAnswersValue1 = currentRow.find(".editPreviousAnswersSelect option:selected").val();
									    		//console.log(editableShowAnswersValue1);
									    		//console.log(editableEditAnswersValue1);
									    		$.confirm({
												    title: 'Period Preferences Change',
												    content: 'Are you sure you want to change the preferences of this Period ?',
												    buttons: {
												        confirm: function () {
												            $.redirect('adminPage.cfm', {"editPeriodID":editPeriodID,"changePeriodShowAnswers":editableShowAnswersValue1,"changePeriodEditAnswers":editableEditAnswersValue1});
												        },
												        cancel: function () {
												        }
												    }
												});
											});
								    	});

								    	//For DeletePeriod BTN
								    	$(".deletePeriod").click(function () {
								   		//alert("DONE");
								    	var currentRow=$(this).closest("tr");
								    	var deletePeriodID=currentRow.find("td:eq(0)").text();
								    	//console.log(deletePeriodID);
								    	$.confirm({
										    title: 'Delete Period',
										    content: 'Are you sure you want to delete this period ?',
										    buttons: {
										        confirm: function () {
										            $.redirect('adminPage.cfm', {"deletePeriodID":deletePeriodID});
										        },
										        cancel: function () {
										        }
										    }
										});
								    });

								});


							<!-- FOR MODAL WITH ADDING PERIOS -->
							$('.dateRange').on('click', function () {
								var myModal = $('#periodAddModal');
						       	var currentRow=$(this).closest("tr");  // Finds the closest row <tr>
			                    var ActiveSurveyName=currentRow.find("td:eq(0)").text(); // get current row 1st TD value
						        $('#periodAddModal .modal-body .surveyName').val(ActiveSurveyName);
						        $('#periodAddModal .modal-body .displaySurveyName').text(ActiveSurveyName);
						        $.ajax({
						            url:"components/AjaxData.cfm",
						            method: "GET",
						            data:{
										"method":"getSurveyPeriods",
						            	"ActiveSurveyName":ActiveSurveyName
						            },
						            dataType:"JSON",
						            success:function(data)
						            {
										var tableData = "";
						            	$.each(data, function (index,value){

											tableData += "<tr><td style='display:none;'>"+ value['ID'] +"</td>";
											var today = new Date();
											var dd = String(today.getDate()).padStart(2, '0');
											var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
											var yyyy = today.getFullYear();
											today = mm + '-' + dd + '-' + yyyy;
											var startDatePeriodCheck = $.datepicker.formatDate('mm-dd-yy', new Date(value['STARTDATEPERIOD']));
											var endDatePeriodCheck = $.datepicker.formatDate('mm-dd-yy', new Date(value['ENDDATEPERIOD']));
											var startDatePeriod =  $.datepicker.formatDate('MM dd, yy', new Date(value['STARTDATEPERIOD']));
											var endDatePeriod = $.datepicker.formatDate('MM dd, yy', new Date(value['ENDDATEPERIOD']));
											//console.log(startDatePeriodCheck);
											//console.log(endDatePeriodCheck);
											//console.log(today);

											tableData += "<td><em>"+ startDatePeriod + " - " + endDatePeriod +"</em></td>";

											if(startDatePeriodCheck <= today && endDatePeriodCheck >= today){
												tableData += "<td style='color:green'><em><strong>Active</strong></em></td>";
											}else{
												tableData += "<td style='color:red'><em><strong>Not Active</strong></em></td>";
											}

											if(value['SHOWPREVIOUSANSWERS'] == true){
												tableData += "<td class='editable1'><em>YES</em></td>";
											}else{
												tableData += "<td class='editable1'><em>NO</em></td>";
											}

											if(value['EDITPREVIOUSANSWERS'] == true){
												tableData += "<td class='editable2'><em>YES</em></td>";
											}else{
												tableData += "<td class='editable2'><em>NO</em></td>";
											}

											tableData += "<td class='actions'>";
											tableData += "<button type='button' class='BtnAsLink buttonChange' style='color:#2196F3'><a class='editPeriod'><i class='material-icons'>create</i></a></button>";
											tableData += "<button type='button' class='BtnAsLink' style='color:#F44336'><a class='deletePeriod'><i class='material-icons'>delete</i></a></button>";
											tableData += "</td>";
											tableData += "</tr>";
						            	});
						            	$("#periodTableModal tbody").html(tableData);
						            }
							      });
							    myModal.modal({ show: true });
							    return false;
							  });

						    	//Edit SurveyPeriod in Modal
								$('#periodAddModal').on('shown.bs.modal', function () {

										// For editPeriod BTN
									   $(".editPeriod").click(function () {
								    	var currentRow=$(this).closest("tr");
								    	var editPeriodID=currentRow.find("td:eq(0)").text();
								    	//console.log(editPeriodID);
								    	var editableShowAnswersValue = currentRow.find(".editable1").text();
								    	var editableEditAnswersValue = currentRow.find(".editable2").text();
								    	//console.log(editableShowAnswers);
								    	//console.log(editableEditAnswers);
										if(editableShowAnswersValue == "YES"){
											var input1 = '<select class="custom-select showPreviousAnswersSelect" name="showPreviousAnswers" onchange="CheckEnabledModal();"><option value="1" selected>YES</option><option value="0">NO</option></select>';
										}else{
											var input1 = '<select class="custom-select showPreviousAnswersSelect" name="showPreviousAnswers" onchange="CheckEnabledModal()"><option value="1">YES</option><option value="0" selected>NO</option></select>';
										}
										if(editableEditAnswersValue == "YES"){
											var input2 = '<select class="custom-select editPreviousAnswersSelect" name="editPreviousAnswers" onchange="CheckEnabledModalForEdit()"><option value="1" selected>YES</option><option value="0">NO</option></select>';
										}else{
											var input2 = '<select class="custom-select editPreviousAnswersSelect" name="editPreviousAnswers" onchange="CheckEnabledModalForEdit()"><option value="1">YES</option><option value="0" selected>NO</option></select>';
										}
								    	currentRow.find(".editable1").html(input1);
								    	currentRow.find(".editable2").html(input2);
								    	currentRow.find(".buttonChange").html("<a class='submitChange'><i class='material-icons'>check_circle</i></a>");

									    	$(".submitChange").click(function() {
												//alert("done");
												var editableShowAnswersValue1 = currentRow.find(".showPreviousAnswersSelect option:selected").val();
									    		var editableEditAnswersValue1 = currentRow.find(".editPreviousAnswersSelect option:selected").val();
									    		//console.log(editableShowAnswersValue1);
									    		//console.log(editableEditAnswersValue1);
									    		$.confirm({
												    title: 'Period Preferences Change',
												    content: 'Are you sure you want to change the preferences of this Period ?',
												    buttons: {
												        confirm: function () {
												            $.redirect('adminPage.cfm', {"editPeriodID":editPeriodID,"changePeriodShowAnswers":editableShowAnswersValue1,"changePeriodEditAnswers":editableEditAnswersValue1});
												        },
												        cancel: function () {
												        }
												    }
												});
											});
								    	});

								    	//For DeletePeriod BTN
								    	$(".deletePeriod").click(function () {
								   		//alert("DONE");
								    	var currentRow=$(this).closest("tr");
								    	var deletePeriodID=currentRow.find("td:eq(0)").text();
								    	//console.log(deletePeriodID);
								    	$.confirm({
										    title: 'Delete Period',
										    content: 'Are you sure you want to delete this period ?',
										    buttons: {
										        confirm: function () {
										            $.redirect('adminPage.cfm', {"deletePeriodID":deletePeriodID});
										        },
										        cancel: function () {
										        }
										    }
										});
								    });

								});
					});

				  </script>
				<!--- For the whole Page --->
    			<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
				<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-design-lite/1.1.0/material.min.css">
				<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
		</body>
		<cfelse>
			<cflocation url="index.cfm" addtoken="false">
	</cfif>
	<cfelse>
		<cfset accessDenied = Encrypt("true","#application.encryptKey#","AES","Hex")>
		<cflocation url="loginForm.cfm?A=#accessDenied#" addtoken="false">
	</cfif>
</html>