<cfsetting showdebugoutput="no">
<cfset this.SurveysGateway = createObject("component","SurveyApp.gateway.SurveysGateway")>
<!--- <cfset this.registrationServices = createObject("component","SurveyApp.components.registrationServices")> --->


<cfif structKeyExists(url,"S") OR structKeyExists(session,"SurveyID")>
	<cfif structKeyExists(url,"S") AND #url.S# NEQ "">
		<cfset SurveyID = Decrypt("#url.S#","#application.encryptKey#","AES","Hex")>
	</cfif>
	<cfif structKeyExists(session,"SurveyID") AND #session.SurveyID# NEQ "">
		<cfset SurveyID = "#session.SurveyID#">
	</cfif>

	<cfset qSurvey = this.SurveysGateway.getSurveyData(ID = "#SurveyID#")>
	<!--- <cfdump var = "#qSurvey#"><cfabort> --->
		<!DOCTYPE html>
		<html>
			<head>
				<title>Regisration</title>
				<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
				<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
				<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
				<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
				<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
				<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.1/dist/jquery.validate.js"></script>

				<link href="css/formStyle.css" rel="stylesheet">
				<script>
					$(document).ready(function (){


						$('#register-form').validate({
							rules: {
								<cfif #qSurvey.FirstnameMandatory# EQ 1>
									firstname: "required",
								</cfif>
								<cfif #qSurvey.LastnameMandatory# EQ 1>
									lastname: "required",
								</cfif>
								<cfif #qSurvey.EmailMandatory# EQ 1>
									email: {
										required: true,
										email:true
									},
								</cfif>
								username:{
									required: true,
									minlength: 6
								},
								password:{
									required: true,
									minlength: 10,
									maxlength: 25
								},
								<cfif #qSurvey.PhoneNumberMandatory# EQ 1>
									phoneNumber:{
										required:true,
										digits:true
									},
								</cfif>
								<cfif #qSurvey.OrganisationMandatory# EQ 1>
									organisation:{
										required:true,
									},
									country:{
										required:true,
									},
								</cfif>
								<cfif #qSurvey.AllowAdditionalContactInfo# EQ 1>
									firstnameContact:"required",
									lastnameContact:"required",
									emailContact:{
										required:true,
										email:true
									},
									phoneNumberContact:{
										required:true,
										digits:true
									}
								</cfif>
							},
							messages: {
								firstname: "Please enter a firstname",
								lastname: "Please enter a lastname",
								email:{
									required: "Please enter an email",
									email:"Enter a valid E-mail Adress"
								},
								username:{
									required: "Please enter a username",
									minlength: "Please enter a username longer than 6 characters"
								},
								password:{
									required: "Please enter a password",
									minlength: "Please enter a password longer than 8 characters",
									maxlength: "Please enter a password shorter than 25 characters"
								},
								phoneNumber:{
									required:"Please enter a Phone Number",
									digits:"Enter a valid Phone Number"
								},
								organisation: "Please enter a Organisation",
								country: "Please enter a Country",
								firstnameContact: "Please enter a firstname of your contact",
								lastnameContact: "Please enter a lastname of your contact",
								emailContact:{
									required: "Please enter an email",
									email: "Enter a valid E-mail Address"
								},
								phoneNumberContact:{
									required:"Please enter a Phone Number of your contact",
									digits:"Enter a valid phone number"
								}
							},
							highlight: function (element) {
		           					 $(element).parent().addClass('error')
		       				 },
		        			unhighlight: function (element) {
		           					 $(element).parent().removeClass('error')
		        			}
						});
					})
				</script>
				<style>
					#register-form .error {
		   							 color: red;
						}
				</style>
			</head>
			<body>
				<div class="container">
			    	<div class="row">
				      <div class="col-sm-9 col-md-7 col-lg-5" style="margin-top:10px;margin-left:32%">
				        <div class="card card-signin my-5">
				          <div class="card-body">
				            <h5 class="card-title text-center"><strong>Registration</strong></h5><br />
				            <form id="register-form" name="register-form" action="registerForm.cfm" method="POST" class="form-signin" autocomplete="off">
					         	 <div class="row">
									<div class="col">
						              <p class="col-md-6"><strong>Firstname:</strong></p>
						              <div class="form-label-group">
						                <input type="text" name="firstname" id="firstname" class="form-control">
						              </div>
						            </div>
						           	<div class="col">
										<p class="col-md-6"><strong>Lastname:</strong></p>
							              <div class="form-label-group">
							                <input type="text" id="lastname" name="lastname" class="form-control">
							              </div>
							        </div>
						         </div>
						              <p class="col-md-6"><strong>Email:</strong></p>
						              <div class="form-label-group">
						                <input type="text" name="email" id="email" class="form-control">
						              </div>
									<p class="col-md-6"><strong>Username:</strong></p>
						              <div class="form-label-group">
						                <input type="text" id="username" name="username" class="form-control">
						              </div>
						              <p class="col-md-6"><strong>Password:</strong></p>
						              <div class="form-label-group">
						                <input type="password" name="password" id="pasword" class="form-control">
						              </div>
									<p class="col-md-6"><strong>Phone Number:</strong></p>
						              <div class="form-label-group">
						                <input type="text" id="phoneNumber" name="phoneNumber" class="form-control">
						              </div>
						            <div class="row">
										<div class="col">
								            <p class="col-md-6"><strong>Organisation:</strong></p>
								              <div class="form-label-group">
								                <input type="text" id="organisation" name="organisation" class="form-control">
								              </div>
								        </div>
								        <div class="col">
								            <p class="col-md-6"><strong>Country:</strong></p>
								              <div class="form-label-group">
								                <input type="text" id="country" name="country" class="form-control">
								              </div>
								        </div>
								    </div>
										<br />
									<cfif #qSurvey.AllowAdditionalContactInfo# EQ 1>
							             <!--- Option for additional contact Info --->
							            <button type="button" class="btn-secondary btn-sm" style="border-radius: 5rem;transition: all 0.2s;" data-toggle="collapse" data-target="#collapseExample" aria-expanded="false" aria-controls="collapseExample">
					    						Additional Contact Info(+)
					 					</button>
										<div class="collapse" id="collapseExample">
											<br />
					  						<div class="card card-body">
												<p style="text-align:center"><strong>Contact Information</strong></p><br />
													<div class="row">
														<div class="col">
											            	<p class="col-md-6"><strong>Firtsname:</strong></p>
												              <div class="form-label-group">
												                <input type="text" id="firstnameContact" name="firstnameContact" class="form-control">
												              </div>
												        </div>
												        <div class="col">
										            	  <p class="col-md-6"><strong>Lastname:</strong></p>
											              <div class="form-label-group">
											                <input type="text" id="lastnameContact" name="lastnameContact" class="form-control">
											              </div>
														</div>
													</div>
													<div class="row">
														<div class="col">
														  <div class="form-label-group">
															 	<p class="col-md-6"><strong>Email:</strong></p>
													            <div class="form-label-group">
													            <input type="text" name="emailContact" id="emailContact" class="form-control">
												           		</div>
																<p class="col-md-6"><strong>Phone Number:</strong></p>
												              	<div class="form-label-group">
												                <input type="text" id="phoneNumberContact" name="phoneNumberContact" class="form-control">
												             	</div>
													        </div>
														</div>
													</div>
											</div>
										</div>
									</cfif>
									<br /><br />
						              <button class="btn btn-lg btn-primary btn-block text-uppercase" name="submit" id="submit" type="submit">Registration</button>
			               </form>
			               <br />
			               <cfif structKeyExists(form,'submit')>
									<cfset errorMessages = application.registrationServices.registerUser(form = form)>
									<cfloop array=#errorMessages# index="msg">
										<cfoutput>#msg#</cfoutput>
										<br/>
									</cfloop>
									<!--- <cfdump var = "#errorMessages[1]#"><cfabort> --->
									<cfif "#errorMessages[1]#" EQ '<span style="color:green;margin-left:20px"><strong>Successfull Registration.</strong></span>'>
										<script>
											setTimeout(function(){ window.location = "loginForm.cfm"; }, 5000);
										</script>
									</cfif>
							</cfif>
			               <br />
			               <button type="button" class="btn btn-sm btn-secondaty" onclick="window.location='loginForm.cfm'">Go back</button>
				          </div>
				        </div>
				      </div>
				    </div>
				  </div>
			</body>
		</html>
<cfelse>
	<cfset accessDenied = Encrypt("true","#application.encryptKey#","AES","Hex")>
	<cflocation url="loginForm.cfm?A=#accessDenied#" addtoken="false">
</cfif>