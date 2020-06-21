<cfcomponent>
	<cffunction name="getPeriodsData" access="public" datasource="SurveyApp" returntype="query">
		<cfset var qPeriods = "">
		<cfquery name="qPeriods">
			SELECT *
			FROM SurveyPeriods
			WHERE 1 = 1
			<cfif structKeyExists(arguments,'ID') AND arguments.ID NEQ "">
				AND SurveyPeriods.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'SurveyID') AND arguments.SurveyID NEQ "">
				AND SurveyPeriods.SurveyID = <cfqueryparam value="#arguments.SurveyID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'StartDatePeriod') AND arguments.StartDatePeriod NEQ "">
				AND SurveyPeriods.StartDatePeriod = <cfqueryparam value="#arguments.StartDatePeriod#" cfsqltype="cf_sql_date">
			</cfif>
			<cfif structKeyExists(arguments,'EndDatePeriod') AND arguments.EndDatePeriod NEQ "">
				AND SurveyPeriods.EndDatePeriod = <cfqueryparam value="#arguments.EndDatePeriod#" cfsqltype="cf_sql_date">
			</cfif>
			<cfif structKeyExists(arguments,'ShowPreviousAnswers') AND arguments.ShowPreviousAnswers NEQ "">
				AND SurveyPeriods.ShowPreviousAnswers = <cfqueryparam value="#arguments.ShowPreviousAnswers#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'EditPreviousAnswers') AND arguments.EditPreviousAnswers NEQ "">
				AND SurveyPeriods.EditPreviousAnswers = <cfqueryparam value="#arguments.EditPreviousAnswers#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'PeriodExpired') AND arguments.PeriodExpired NEQ "">
				AND SurveyPeriods.PeriodExpired = <cfqueryparam value="#arguments.PeriodExpired#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'CreatedDate') AND arguments.CreatedDate NEQ "">
				AND SurveyPeriods.CreatedDate = <cfqueryparam value="#arguments.CreatedDate#" cfsqltype="cf_sql_bit">
			</cfif>
		</cfquery>
		<cfreturn qPeriods>
	</cffunction>

	<cffunction name="insertPeriod" access="public" datasource="SurveyApp" output="false">
		<cfargument name="SurveyID" required="true">
		<cfargument name="StartDatePeriod" required="true">
		<cfargument name="EndDatePeriod" required="true">
		<cfargument name="ShowPreviousAnswers" required="true">
		<cfargument name="EditPreviousAnswers" required="true">
		<cfargument name="PeriodExpired" required="true">
		<cfargument name="CreatedDate" required="true" type="date">

		<cfquery>
			INSERT INTO SurveyPeriods (SurveyID,StartDatePeriod,EndDatePeriod,ShowPreviousAnswers,EditPreviousAnswers,PeriodExpired,CreatedDate)
			VALUES (
						<cfqueryparam value="#arguments.SurveyID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.StartDatePeriod#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.EndDatePeriod#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.ShowPreviousAnswers#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.EditPreviousAnswers#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.PeriodExpired#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.CreatedDate#" cfsqltype="cf_sql_date">
					)
		</cfquery>
	</cffunction>

	<cffunction name="updatePeriodExpired" access="public" datasource="SurveyApp" output="false">
		<cfargument name="ID" required="true">

		<cfquery>
			UPDATE SurveyPeriods
			SET SurveyPeriods.PeriodExpired = 1
			WHERE SurveyPeriods.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
		</cfquery>

	</cffunction>

	<cffunction name="deletePeriod" access="public" datasource="SurveyApp" output="false">
		<cfargument name="ID" type="numeric" required="true">

		<cfquery datasource="SurveyApp">
			DELETE FROM SurveyPeriods
			WHERE SurveyPeriods.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cffunction>

	<cffunction name="changePeriodPreferences" access="public" datasource="SurveyApp" output="false">
		<cfargument name="ID" type="numeric" required="true">
		<cfargument name="ShowPreviousAnswers" type="boolean" required="true">
		<cfargument name="EditPreviousAnswers" type="boolean" required="true">

		<cfquery datasource="SurveyApp">
			UPDATE SurveyPeriods
			SET SurveyPeriods.ShowPreviousAnswers = <cfqueryparam value="#arguments.ShowPreviousAnswers#" cfsqltype="cf_sql_bit">,
				SurveyPeriods.EditPreviousAnswers = <cfqueryparam value="#arguments.EditPreviousAnswers#" cfsqltype="cf_sql_bit">
			WHERE SurveyPeriods.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
		</cfquery>

	</cffunction>
</cfcomponent>