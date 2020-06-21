<cfcomponent>
<!--- 	<cfset this.utility = createObject("component","SurveyApp.components.utility") />
	<cfset this.UserGateway = createObject("component","SurveyApp.UserGateway.UserGateway") /> --->

	<cffunction name="vallidateUser" access="public" returntype="void">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">

		<cfset var qUser = application.UserGateway.getUsersData(username = "#arguments.username#")>
		<cfset var salt = "#qUser.Salt#">
		<cfset var pass = application.utility.generatePassword("#arguments.password#","#qUser.Salt#")>

		<cfif "#pass#" EQ "#qUser.Password#">
			<cfset session.UserID = qUser.ID>
		<cfelse>
			<cfset wrongEntry = Encrypt("true","#application.encryptKey#","AES","HEX")>
			<cflocation url="loginForm.cfm?WE=#wrongEntry#" addtoken="false">
		</cfif>
	</cffunction>

</cfcomponent>