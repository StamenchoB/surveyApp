<cfsetting showDebugOutput="no">

<!--- <cfset .utility = createObject("component","SurveyApp.components.utility")>
<cfset .UserGateway = createObject("component","SurveyApp.UserGateway.UserGateway")> --->
<!--- <cfset  .encryptKey = "zMmNebTYHnlvdC41iXsKuw=="> --->
<!DOCTYPE html>
<html>
	<head>
		<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
		<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
		<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.1/dist/jquery.validate.js"></script>

		<link href="css/formStyle.css" rel="stylesheet">
		<title>Password Change</title>
		<script>
			$(document).ready(function (){
				$('#changePass-form').validate({
					rules:{
						username:"required",
						email:{
							required: true,
							email: true
						}
					},
					messages:{
						username:"Please enter a username",
						email:{
							required:"Please enter a email adress",
							email: "Please provide an valid email adress"
						}
					},
					highlight: function (element) {
           					 $(element).parent().addClass('error')
       				 },
        			unhighlight: function (element) {
           					 $(element).parent().removeClass('error')
        			}
				})
			})
		</script>
		<style>
			#changePass-form .error {
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
					    <cfset msg = arrayNew(1)>
					    <cfif structKeyExists(form,"email") AND structKeyExists(form,"username")>
					    	<cfset qUser_Users = application.UserGateway.getUsersData(email = "#form.email#",username = "#form.username#")>
					    	<!--- <cfdump var = "#qUser_Users#"><cfabort> --->
							<cfif qUser_Users.recordCount EQ 1>

									<!--- <cfdump var = "#encryptionSalt#"><cfabort> --->
									<cfset pass_key = CreateUUID()>
									<cfset user_userID = "#qUser_Users.ID#">
									<cfset application.UserGateway.updatePasskeyExTime(user_id = "#user_userID#",passkey = "#pass_key#")>
									<cfset qUser_PasswordHistory = application.UserGateway.getDataPasswordHistory(user_id = "#user_userID#",passkey = "#pass_key#")>
								<!--- 	<cfdump var="#qUser_PasswordHistory#"><cfabort> --->
									<cfset uniqueUrl = "#user_userID#"& "|" & "#pass_key#" & "|" & "#qUser_PasswordHistory.ID#"><!--- Delimiter pomegju userId i passkey --->
									<!--- <cfdump var = "#unique_url#"><cfabort> --->

									<cfset encrypted_uniqueUrl = Encrypt("#uniqueUrl#","#application.encryptKey#","AES","Hex")>
									<!--- <cfdump var="#encrypted_uniqueUrl#"><cfabort> --->

							    	<cfmail from="s.bogdanovski@axeltra" to="#form.email#" subject="Password Recovery" server="smtp.gmail.com"

							     				port="465" username="s.bogdanovski@axeltra.com" password="Bogdanovski123" usessl="true">
							     				<cfmailpart type="text/html">
								     				<h3>You have requesteed a <strong>password change</strong>.
							     					Please follow the link to change you existing passwod : <a href="http://127.0.0.1:8500/SurveyApp/passwordChangeForm.cfm?L=<cfoutput>#encrypted_uniqueUrl#</cfoutput>"><br />http://127.0.0.1:8500/SurveyApp/passwordChangeForm.cfm?L=<cfoutput>#encrypted_uniqueUrl#</cfoutput></a><!--- link with encrypted user_id and passkey --->
													</h3>
												</cfmailpart>
									</cfmail>
									<cfset arrayAppend(msg,"<span style='color:green;margin-left:20px'><strong>An email has been sent to your provided email adress</strong></span>")>
							<cfelse>
									<cfset arrayAppend(msg,"<span style='color:red;margin-left:20px'><strong>Username or Email is not existing</strong></span>")>
							</cfif>
						</cfif>
					    <h5 class="card-title text-center">Password Recovery</h5>
						    <form method="post" action="passwordChangeRequest.cfm" name="changePass-form" id="changePass-form" class="form-signin" autocomplete="off" >
									<p class="col-md-7"><strong>Username:</strong></p>
									<div class="form-label-group">
									     <input type="text" name="username" id="username" class="form-control">
									</div>
									<p class="col-md-6"><strong>Email:</strong></p>
									<div class="form-label-group">
									     <input type="text" id="email" name="email" class="form-control">
									</div>
									<button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit">Send Email</button>
							</form><br />
						    <div class="form-group">
						        <cfloop array="#msg#" index="i">
						              <cfoutput>#i#</cfoutput>
						              	<cfif "#i#" EQ "<span style='color:green;margin-left:20px'><strong>An email has been sent to your provided email adress</strong></span>">
							              	<cfset structClear(form)>
						   					<!--- <script>
												setTimeout(function(){ window.location = "loginForm.cfm"; }, 10000);
											</script> --->
										</cfif>
						        </cfloop>
							</div>
							<br />
	               				<button type="button" class="btn btn-sm btn-secondaty" onclick="window.location='loginForm.cfm'">Go back</button>
							</div>
		        		</div>
		     		 </div>
		    	</div>
		 	 </div>
	</body>
</html>