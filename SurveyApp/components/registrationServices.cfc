<cfcomponent>
<!--- <cfset this.utility = createObject("component","SurveyApp.components.utility")>
<cfset this.UserGateway = createObject('component',"SurveyApp.UserGateway.UserGateway")> --->

	<!--- Za registracija i proverka na polinjata vo registrationForm.cfm --->
	<cffunction name="registerUser" access="public" returntype="array">
		<cfargument name="form" type="struct" required="true">
		<cfset var errorMessages = arrayNew(1)>

		<!--- Vrati ja errorMessages porano dokolku ima nekoj problem pred da vneses  vo baza --->
		<cfif ArrayLen(errorMessages)>
			<cfreturn errorMessages>
		</cfif>

		<cfset var qUser = application.UserGateway.getUsersData(email = "#arguments.form.email#",username = "#arguments.form.username#")>

		<cfif qUser.recordCount GT 0>
			<!--- Proverka za dali postoi isti USERNAME vo databazata --->
			<cfif arguments.form.username EQ qUser.username>
				<cfset arrayAppend(errorMessages,'<span style="color:red;margin-left:20px;"><strong>Username</strong> is already taken.Provide a unique one.</span>')>
			</cfif>
			<!--- Proverka za dali postoi isti EMAIL vo databazata --->
			<!--- <cfif arguments.form.email EQ qUser.email>
				<cfset arrayAppend(errorMessages,'<span style="color:red;margin-left:20px;"><strong>Email</strong> is already taken.Provide a unique one.</span>')>
			</cfif> --->
			<cfreturn errorMessages>
		<cfelse>
			<!--- Generiranje na random salt parametar za da go vnesam vo baza --->
			<cfset var salt = Hash(GenerateSecretKey("AES"), "SHA-512")>
			<!--- Generiranje na noviot password za noviot user --->
			<cfset var pass = application.utility.generatePassword("#arguments.form.password#",'#salt#')>

			<!--- Input a new user into the database SurveyApp(table Users) --->
			<cfquery datasource="SurveyApp" name="registeredUser">
				INSERT INTO Users (Firstname,Lastname,Email,Username,Password,DateCreated,PhoneNumber,Organisation,Country,FirstnameContact,LastnameContact,EmailContact,PhoneNumberContact,Salt,Admin)
				VALUES (
							<cfqueryparam value="#form.firstname#" cfsqltype="cf_sql_nvarchar">,
							<cfqueryparam value="#form.lastname#" cfsqltype="cf_sql_nvarchar">,
							<cfqueryparam value="#form.email#" cfsqltype="cf_sql_nvarchar">,
							<cfqueryparam value="#form.username#" cfsqltype="cf_sql_nvarchar">,
							<cfqueryparam value="#pass#" cfsqltype="cf_sql_nvarchar">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#form.phoneNumber#" cfsqltype="cf_sql_nvarchar">,
							<cfqueryparam value="#form.organisation#" cfsqltype="cf_sql_nvarchar">,
							<cfqueryparam value="#form.country#" cfsqltype="cf_sql_nvarchar">,
							<cfif structKeyExists(form,"firtsnameContact") AND form.firtsnameContact NEQ "">
								<cfqueryparam value="#form.firtsnameContact#" cfsqltype="cf_sql_nvarchar">,
							<cfelse>
								<cfqueryparam value="''" cfsqltype="cf_sql_nvarchar" null="yes">,
							</cfif>
							<cfif structKeyExists(form,"lastnameContact") AND form.lastnameContact NEQ "">
								<cfqueryparam value="#form.lastnameContact#" cfsqltype="cf_sql_nvarchar">,
							<cfelse>
								<cfqueryparam value="" cfsqltype="cf_sql_nvarchar" null="yes">,
							</cfif>
							<cfif structKeyExists(form,"emailContact") AND form.emailContact NEQ "">
								<cfqueryparam value="#form.emailContact#" cfsqltype="cf_sql_nvarchar">,
							<cfelse>
								<cfqueryparam value="''" cfsqltype="cf_sql_nvarchar" null="yes">,
							</cfif>
							<cfif structKeyExists(form,"phoneNumberContact") AND form.phoneNumberContact NEQ "">
								<cfqueryparam value="#form.phoneNumberContact#" cfsqltype="cf_sql_nvarchar">,
							<cfelse>
								<cfqueryparam value="''" cfsqltype="cf_sql_nvarchar" null="yes">,
							</cfif>
							<cfqueryparam value="#salt#" cfsqltype="cf_sql_nvarchar">,
							<cfqueryparam value=0 cfsqltype="cf_sql_bit">

						)
				SELECT @@IDENTITY AS user_id
			</cfquery>
			<!--- tuka treba insert vo adminuserpasswrod history--->
			<cfset expiration_date = DateAdd("d",7,Now()) ><!--- Edna nedela posle datum na registracija na korisnikot--->
			<!--- <cfdump var = "#registeredUser#"><cfabort> --->
			<cfquery datasource="SurveyApp">
					INSERT INTO UsersPasswordHistory (User_ID,Password,DateCreated,DateExpire,Active)
					VALUES (
								<cfqueryparam value="#registeredUser.user_id#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#pass#" cfsqltype="cf_sql_nvarchar">,
								<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#expiration_date#" cfsqltype="cf_sql_date">,
								<cfqueryparam value=1 cfsqltype="cf_sql_bit">
							)

			</cfquery>
			<cfmail to="#form.email#" from="s.bogdanovski@axeltra.com"  subject="Successful Registration" server="smtp.gmail.com" port="465" username="s.bogdanovski@axeltra.com" password="Bogdanovski123" usessl="true">
					<cfmailpart type="text/html">
							 Dear <strong>#form.firstname# #form.lastname#</strong><br />
							 You have been successfully registered on our site.Please follow the <a href="http://127.0.0.1:8500/SurveyApp/loginForm.cfm">link</a> to login.You username : <strong>#form.username#</strong>
					</cfmailpart>
			</cfmail>
			<cfset arrayAppend(errorMessages,'<span style="color:green;margin-left:20px"><strong>Successfull Registration.</strong></span>')>
		</cfif>
		<cfreturn errorMessages>
	</cffunction>
</cfcomponent>