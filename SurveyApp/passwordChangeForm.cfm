<cfsetting showDebugOutput="no">

<!--- <cfset this.UserGateway = createObject("component","Website.gateway.UserGateway")>
<cfset  this.encryptKey = 'R/zaXK2D+Puf73sUbfXaeA=='> --->

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
						password:"required",
						confirmPassword:{
							required: true,
							equalTo: "#password"
						}
					},
					messages:{
						password:"Field is empty",
						confirmPassword:{
							required:"Field is empty",
							equalTo:"Your password don't match"
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
			<!--- Proverka dali postojat parametrite vo url --->
	<cfif structKeyExists(url,"L")>
		<!--- <cfdump var = "#url.L#"><cfabort> --->
		<cfset decrypted_uniqueUrl = Decrypt("#url.L#","#application.encryptKey#","AES","Hex")>
		<!--- <cfdump var = z"#decrypted_uniqueUrl#"><cfabort> --->
		<cfset urlArray = listToArray ("#decrypted_uniqueUrl#", "|",false,false)>
		<!--- <cfdump var = "#urlArray#"><cfabort> --->
		<cfset undecoded_userID = "#urlArray[1]#">
		<cfset undecoded_passkey = "#urlArray[2]#">
		<cfset undecoded_ID = "#urlArray[3]#">
		<!--- <cfdump var = "#undecoded_userID#">
		<cfdump var = "#undecoded_passkey#"> --->
		<!--- <cfdump var = "#undecoded_ID#"><cfabort> --->
		<cfset qUser = application.UserGateway.getDataPasswordHistory(user_id = "#undecoded_userID#",passkey = "#undecoded_passkey#")>
		<!--- <cfdump  var = "#qUser#"><cfabort> --->
		<!--- proverakta za dali e used da se napravi uste tuka da ne se vleguva vo formata --->
		<cfif qUser.used EQ 1>
			 <div class="container">
				<div class="row">
					<div class="col-sm-9 col-md-7 col-lg-5" style="margin-top:10px;margin-left:32%">
						 <div class="card card-signin my-5">
							<div class="card-body">
								<h3 class="text-center pt-5">The recovery link has already been used</h3><br />
						   		<!--- <button class="btn btn-lg btn-primary btn-block text-uppercase" onclick="window.location.href = 'passwordChangeRequest.cfm'">Try again</button> --->
						   		<p class="text-center">You'll be redirected</p>
			   					<script>
									setTimeout(function(){ window.location = "loginForm.cfm"; }, 5000);
								</script>
							</div>
						</div>
					</div>
				</div>
			</div>
		<cfelse>
			<!--- Proverka dali dobieniot passkey e istiot i vo databzata --->
			<cfif undecoded_passkey EQ qUser.passkey AND qUser.expired NEQ 1>
				<!--- Proverka dali e isteceno vremeto --->
				<cfset diff = DateDiff("s", qUser.passkeyexpiration, now())>
				<!--- <cfdump var = "#diff#"><cfabort> --->
				<cfif diff LTE 0>
						<body>
							 <div class="container">
						    	<div class="row">
							      <div class="col-sm-9 col-md-7 col-lg-5 mx-auto" style="margin-top:10%">
							        <div class="card card-signin my-5">
							          <div class="card-body">
							          		<h5 class="card-title text-center">Password Change</h5>
											<form method="post" action="passwordChangeResponse.cfm" name="changePass-form" id="changePass-form" class="form-signin" autocomplete="off">
												<input type="hidden" name="user_id" id="user_id" value="<cfoutput>#qUser.user_id#</cfoutput>">
							                    <input type="hidden" name="ID" id="ID" value="<cfoutput>#qUser.ID#</cfoutput>">
												<p class="col-md-7"><strong>Password:</strong></p>
												<div class="form-label-group">
												     <input type="password" name="password" id="password" class="form-control">
												</div>
												<p class="col-md-6"><strong>Confrim Password:</strong></p>
												<div class="form-label-group">
												     <input type="password" id="confirmPassword" name="confirmPassword" class="form-control">
												</div>
												<button class="btn btn-lg btn-primary btn-block text-uppercase" type="submit">Change</button>
											</form><br />
										    <div class="form-group">
											</div>
										</div>
									</div>
								</div>
							</div>
						</body>
						<!--- Password used da ne se updatira tuka tuku vo passChangeResponse otkako korsinikot kje klikne change na formata za da go smeni passwordot --->
					<cfelse>
						<cfset application.UserGateway.updateExpired(user_id = "#qUser.user_id#")>
						<div class="container">
							<div class="row">
								<div class="col-sm-9 col-md-7 col-lg-5 mx-auto" style="margin-top:10%">
									 <div class="card card-signin my-5">
										<div class="card-body">
											<h3 class="text-center pt-5">There passkey has expired</h3><br />
						   					<!--- <button class="btn btn-lg btn-primary btn-block text-uppercase" onclick="window.location.href = 'passwordChangeRequest.cfm'">Try again</button> --->
						   					<p class="text-center">You'll be redirected</p>
						   					<script>
												setTimeout(function(){ window.location = "loginForm.cfm"; }, 5000);
											</script>
										</div>
									</div>
								</div>
							</div>
						</div>
					</cfif>
				</cfif>
			</cfif>
		<cfelse>
			<cfset accessDenied = Encrypt("true","#application.encryptKey#","AES","Hex")>
			<cflocation url="loginForm.cfm?A=#accessDenied#" addtoken="false">
		</cfif>
	</body>
</html>