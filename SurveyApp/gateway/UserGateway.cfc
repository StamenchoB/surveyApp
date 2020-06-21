<cfcomponent>

	<cffunction name="getUsersData" access="public" datasource="SurveyApp" returntype="query">
		<cfset var qUsers = "">
		<cfquery name="qUsers">
			SELECT *
			FROM Users
			WHERE 1 = 1
			<cfif structKeyExists(arguments,'ID') AND arguments.ID NEQ "">
				AND Users.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'firstname') AND arguments.firstname NEQ "">
				AND Users.Firstname = <cfqueryparam value="#arguments.firstname#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'lastname') AND arguments.lastname NEQ "">
				AND Users.Lastname = <cfqueryparam value="#arguments.lastname#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'email') AND arguments.email NEQ "">
				AND Users.Email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'username') AND arguments.username NEQ "">
				AND Users.Username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'password') AND arguments.password NEQ "">
				AND Users.Password = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'phoneNumber') AND arguments.phoneNumber NEQ "">
				AND Users.PhoneNumber = <cfqueryparam value="#arguments.phoneNumber#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'organisation') AND arguments.organisation NEQ "">
				AND Users.Organisation = <cfqueryparam value="#arguments.organisation#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'country') AND arguments.country NEQ "">
				AND Users.Country = <cfqueryparam value="#arguments.country#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'firstnameContact') AND arguments.firstnameContact NEQ "">
				AND Users.FirstnameContact = <cfqueryparam value="#arguments.firstnameContact#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'lastnameContact') AND arguments.lastnameContact NEQ "">
				AND Users.LastnameContact = <cfqueryparam value="#arguments.lastnameContact#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'emailContact') AND arguments.emailContact NEQ "">
				AND Users.EmailContact = <cfqueryparam value="#arguments.emailContact#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'phoneNumberContact') AND arguments.phoneNumberContact NEQ "">
				AND Users.PhoneNumberContact = <cfqueryparam value="#arguments.phoneNumberContact#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'Admin') AND arguments.Admin NEQ "">
				AND Users.Admin = <cfqueryparam value="#arguments.Admin#" cfsqltype="cf_sql_bit">
			</cfif>
		</cfquery>
		<cfreturn qUsers>
	</cffunction>

	<cffunction name="UpdatePasswordDataAdmins" access="public" dasource="SurveyApp" returntype="void">
		<cfargument name="user_id">
		<cfargument name="new_salt" type="string">
		<cfargument name="new_password" type="string">
		<cfargument name="username" type="string">

		<cfquery datasource="SurveyApp">
			UPDATE Users
			SET Users.Password = <cfqueryparam value="#arguments.new_password#" cfsqltype="cf_sql_nvarchar">,
				Users.Salt = <cfqueryparam value="#arguments.new_salt#" cfsqltype="cf_sql_nvarchar">
			WHERE Users.ID = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cffunction>


	<cffunction name="getDataPasswordHistory" access="public" datasource="SurveyApp" returntype="query">
		<cfset var qUser = "">
		<cfquery name="qUser">
			SELECT *
			FROM UsersPasswordHistory
			WHERE 1=1
			<cfif structKeyExists(arguments,'user_id') AND arguments.user_id NEQ "">
				AND UsersPasswordHistory.User_ID = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'ID') AND arguments.ID NEQ "">
				AND UsersPasswordHistory.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'passkey') AND arguments.passkey NEQ "">
				AND UsersPasswordHistory.Passkey = <cfqueryparam value="#arguments.passkey#" cfsqltype="cf_sql_nvarchar">
			</cfif>
		</cfquery>
		<cfreturn qUser>
	</cffunction>

	<!--- Za update na passkeyto i passkeyexpiration vo tabelata UsersPasswordHistory --->
	<cffunction name="updatePasskeyExTime" access="public" datasource="SurveyApp" returntype="void">
  		<cfargument name="user_id" require="true">
		<cfargument name="passkey" required="true">

		<cfset var expiration_time = DateAdd("h",1,Now()) />
		<cfquery>
			UPDATE UsersPasswordHistory
			SET Passkey = <cfqueryparam value="#arguments.passkey#" cfsqltype="cf_sql_nvarchar">,
				PassKeyExpiration = <cfqueryparam value="#expiration_time#" cfsqltype="CF_SQL_TIMESTAMP">,
				Used = <cfqueryparam value=0 cfsqltype="cf_sql_bit">,
				Expired = <cfqueryparam value=0 cfsqltype="cf_sql_bit">
			WHERE UsersPasswordHistory.User_ID = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer"> AND UsersPasswordHistory.Active = <cfqueryparam value=1 cfsqltype="cf_sql_nvarchar">
		</cfquery>
	</cffunction>

	<!--- Za update posle kliknatiot link deka used = 1 --->
	<cffunction name="updateUsed" access="public" datasource="SurveyApp" returntype="void">
		<cfargument name="ID" required="true">

		<cfquery>
			UPDATE UsersPasswordHistory
			SET Used = 1
			WHERE UsersPasswordHistory.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cffunction>

	<!--- Za update na  expired link--->
	<cffunction name="updateExpired" acces="public" datasource="SurveyApp" returntype="void">
		<cfargument name="user_id" required="true">
		<cfquery>
			UPDATE UsersPasswordHistory
			SET Expired = 1
			WHERE UsersPasswordHistory.User_ID = <cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cffunction>



	<!--- Pri promena na password se zapisuva noviot kako nov red vo UserPasswordHistory --->
	<cffunction name="insertDataPasswordHistory" access="public" datasource="SurveyApp" returntype="void">

		<cfargument name="user_id" required="true">
		<cfargument name="password" type="string" required="true">

		<cfset var expiration_date = DateAdd("d",7,Now()) >
		<cfquery>
			INSERT INTO UsersPasswordHistory (User_ID,Password,DateCreated,DateExpire,Active)
			VALUES
					(
						<cfqueryparam value="#arguments.user_id#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_nvarchar">,
						<cfqueryparam value="#now()#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#expiration_date#" cfsqltype="cf_sql_date">,
						<cfqueryparam value=1 cfsqltype="cf_sql_bit">
					)
		</cfquery>
	</cffunction>


</cfcomponent>