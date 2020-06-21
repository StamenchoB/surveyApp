<cfsetting showDebugOutput="no">
<!--- <cfset this.utility = createObject("component","Website.components.utility")>
<cfset this.UserGateway = createObject("component","Website.gateway.UserGateway")> --->
<!DOCTYPE html>
		<html>
		<head>
		<meta content="text/html; charset=utf-8" />
		<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
		<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
		<script src="https://code.jquery.com/jquery-3.4.1.js"></script>

		<link href="css/formStyle.css" rel="stylesheet">

		<title>Password Change</title>
		</head>
		<body>
			<div class="container">
				<div class="row">
					<div class="col-sm-9 col-md-7 col-lg-5 mx-auto" style="margin-top:10%">
						<div class="card card-signin my-5">
							<div class="card-body">
								<cfif structkeyExists(form,"password") AND structKeyExists(form,"confirmPassword") AND structKeyExists(form,"user_id")>
										<!--- Tuka povik do vaza ne treba da mi gi dava site tuka samo select top5 za da gi proveram so passwordite i so recordCount ako vrati nekoj da kaze deka go ima vekje passwordot --->
										<cfset qUser = application.UserGateway.getUsersData(ID = "#form.user_id#")>
										<cfset user_salt = "#qUser.salt#">
										<!--- <cfdump var = "#user_salt#"><cfabort> --->
										<cfset oldPassword = application.utility.generatePassword(item = "#form.password#",salt = "#user_salt#")>
										<!--- <cfdump var = "#oldPassword#"><cfabort> --->
										<cfquery name="qUserPasswordHistory" datasource="SurveyApp">
											SELECT TOP 5 *
											FROM UsersPasswordHistory
											WHERE UsersPasswordHistory.password = <cfqueryparam value="#oldPassword#" cfsqltype="cf_sql_nvarchar">
										</cfquery>
										<!--- Proverka dali ima ist password kako prethodnite 5 --->
											<cfif qUserPasswordHistory.recordCount EQ 0>
												<!--- Se vnesuva noviot password vo Admins --->
												<cfquery datasource="SurveyApp" name="qUser">
													SELECT *
													FROM Users
													WHERE ID = <cfqueryparam value="#form.user_id#" cfsqltype="cf_sql_integer">
												</cfquery>
												<cfquery>
													UPDATE UsersPasswordHistory
													SET UsersPasswordHistory.active = <cfqueryparam value=0 cfsqltype="cf_sql_bit">
													WHERE user_id = <cfqueryparam value="#form.user_id#" cfsqltype="cf_sql_integer">
												</cfquery>
												<!--- Go pravime USED = 1 bidejki go iskoristuvame toj link --->
											<cfif structKeyExists(form,"ID")>
												<cfset application.UserGateway.updateUsed(ID = "#form.ID#")>
											</cfif>
												<cfset salt = "#qUser.salt#">
												<!--- Generiranje na nov password so stariot salt parametar --->
												<cfset new_password = application.utility.generatePassword("#form.password#","#salt#")>

												<!--- Update na passwordot vo Admins tabelata --->
												<cfset application.UserGateway.UpdatePasswordDataAdmins("#form.user_id#","#salt#","#new_password#")>
												<!--- Insert na noviot password kako nova redica vo UsersPasswordHitory tabelata --->
												<cfset application.UserGateway.insertDataPasswordHistory(user_id = "#form.user_id#",password = "#new_password#")>


										        <h3 class="text-center pt-5">Your password has been changed</h3><br /><br />
										        <cfset structClear(session)>
							   					<!--- <button class="btn btn-lg btn-primary btn-block text-uppercase" onclick="window.location.href = 'loginForm.cfm';RedirectLogin()">Sign In</button> --->
							   					<p class="text-center">You'll be redirected</p>
							   					<script>
													setTimeout(function(){ window.location = "loginForm.cfm"; }, 5000);
												</script>
										 <cfelse>
										 		<h3 class="text-center pt-5">You entered a password like one of the previous 5 you had</h3><br /><br />
										 		<p class="text-center">You'll be redirected</p>
										 		<!--- <button class="btn btn-lg btn-primary btn-block text-uppercase" onclick="window.location.href = 'passwordChangeRequest.cfm'">Try again</button> --->
										 		<script>
													setTimeout(function(){ window.location = "passwordChangeRequest.cfm"; }, 5000);
												</script>
										 </cfif>
							   	<cfelse>
							   		<div id="error404Survey" class="alert alert-danger" role="alert" style="text-align:center">
								      <h3>ERROR</h3><br />
								      <p>There was an error during password change.You'be redirected</p>
						      		</div>
							   		<!--- <button class="btn btn-lg btn-primary btn-block text-uppercase" onclick="window.location.href = 'passwordChangeRequest.cfm'">Try again</button> --->
							   		<script>
											setTimeout(function(){ window.location = "passwordChangeRequest.cfm"; }, 3000);
									</script>
								</cfif>
							</div>
						</div>
					</div>
				</div>
			</div>
		</body>
		</html>