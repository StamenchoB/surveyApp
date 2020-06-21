<cfsetting showdebugoutput="no">

<!--- EncryptKey on the fly.I will place it in application.cfc --->
<!--- <cfset  this.encryptKey = "zMmNebTYHnlvdC41iXsKuw=="> --->

<!DOCTYPE html>
<html>
	<head>
		<title>Survey</title>
		<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
		<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
		<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.1/dist/jquery.validate.js"></script>

		<link href="css/formStyle.css" rel="stylesheet">

		<script>
			$(document).ready(function (){
				$('#login-form').validate({
					rules:{
						username:{
							required: true,
							minlength:6
						},
						password:{
							required: true,
						}
					},
					messages:{
						username:{
									required:"Please enter a username",
									minlength:"The username is too short"
								},
						password:{
							required:"Please enter a password"
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
			#login-form .error {
   							 color: red;
				}
		</style>
	</head>
	<body>
		<cfif structKeyExists(url,"L")>
			<cfset decrepted_logout = Decrypt("#url.L#","#application.encryptKey#","AES","HEX")>
			<!--- <cfdump var="#decrepted_logout#"><cfabort> --->
			<cfif decrepted_logout>
				<cfset structDelete(session,"UserID")>
			</cfif>
		</cfif>
		<cfif structKeyexists(session,"userID") AND structKeyExists(session,"surveyID")>
			<cflocation url="index.cfm" addtoken="false">
		</cfif>
		<cfif structKeyExists(url,"S") AND url.S NEQ "">
         	<cfset decrypted_surveyID = Decrypt("#url.S#","#application.encryptKey#","AES","Hex")>
        	<cfset session.SurveyID = "#decrypted_surveyID#">
        </cfif>
			<div class="container">
		    	<div class="row">
			      <div class="col-sm-9 col-md-7 col-lg-5" style="margin-top:10px;margin-left:32%">
			        <div class="card card-signin my-5">
			          <div class="card-body">
			            <h5 class="card-title text-center">Sign In</h5>
			            <form method="POST" action="index.cfm" name="login-form" id="login-form" class="form-signin" autocomplete="off">

				            	<input type="hidden" name="surveyID" id="surveyID" value='0'>

				        <p class="col-md-6"><strong>Username:</strong></p>
	 		              <div class="form-label-group">
				             <!--- <label for="username">Username</label> --->
			                <input type="text" name="username" id="username" class="form-control" autofocus>

			              </div>
						<p class="col-md-6"><strong>Password:</strong></p>
			              <div class="form-label-group">
			                <input type="password" id="password" name="password" class="form-control">
			              </div>

			              <div class="custom-control mb-3" style="padding-left:-20px">
			                <a href="passwordChangeRequest.cfm">Forgot Password?</a>
			                <!--- Displaying error for wrong username OR password --->
			                <span style="float:right;padding-left:20px">
				               <cfif structKeyExists(url,"WE") AND url.WE NEQ "">
									<cfset wrongEntry = Decrypt("#url.WE#","#application.encryptKey#","AES","HEX")>
									<cfif wrongEntry EQ true>
										<p style="color:red">Incorrect Username/Password</p>
									</cfif>
								</cfif>
								<cfif structKeyExists(url,"A") AND url.A NEQ "">
									<cfset accessDenied = Decrypt("#url.A#","#application.encryptKey#","AES","HEX")>
									<cfif accessDenied EQ true>
										<p style="color:red">Access Denied</p>
									</cfif>
								</cfif>
							</span>
							<br /><br />
			              </div>
			              <button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit">Sign in</button>
			            </form>
			            <hr class="my-4">
			              <h6 style="text-align:center">Not a user?</h6><br />
			              	<cfif structKeyExists(session,"SurveyID") >
				              <cfset encryptedSurveyID = Encrypt("#session.SurveyID#","#application.encryptKey#","AES","Hex")>
				              <button class="btn btn-lg btn btn-dark btn-block text-uppercase" onclick="window.location='registerForm.cfm?S=<cfoutput>#encryptedSurveyID#</cfoutput>'">Register</button>
				          	<cfelse>
				          		<button class="btn btn-lg btn btn-dark btn-block text-uppercase" onclick="window.location='registerForm.cfm'">Register</button>
							</cfif>
			          </div>
			        </div>
			      </div>
			    </div>
			  </div>
	</body>
</html>