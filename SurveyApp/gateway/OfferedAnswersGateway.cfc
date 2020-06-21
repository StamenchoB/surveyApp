<cfcomponent>
	<!--- Get Offered Answers --->
	<cffunction name="getOfferedAnswersData" access="public" datasource="SurveyApp" returntype="query">
		<cfset var qOfferedAnswers = "">
		<cfquery name="qOfferedAnswers">
			SELECT *
			FROM OfferedAnswers
			WHERE 1 = 1
			<cfif structKeyExists(arguments,'ID') AND arguments.ID NEQ "">
				AND OfferedAnswers.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'QuestionID') AND arguments.QuestionID NEQ "">
				AND OfferedAnswers.QuestionID = <cfqueryparam value="#arguments.QuestionID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'OfferedAnswer') AND arguments.OfferedAnswer NEQ "">
				AND OfferedAnswers.OfferedAnswer = <cfqueryparam value="#arguments.OfferedAnswer#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'CreatedDate') AND arguments.CreatedDate NEQ "">
				AND OfferedAnswers.CreatedDate = <cfqueryparam value="#arguments.CreatedDate#" cfsqltype="cf_sql_date">
			</cfif>
		</cfquery>
		<cfreturn qOfferedAnswers>
	</cffunction>


	<!--- Insert Offered Answers --->
	<cffunction name="insertOfferedAnswers" access="public" datasource="SurveyApp" output="false">
		<cfargument name="QuestionID" type="numeric" required="true">
		<cfargument name="OfferedAnswer" type="string" required="true">

		<cfset var createDateSurvey = now()>
		<cfquery>
			INSERT INTO OfferedAnswers (QuestionID,OfferedAnswer,CreatedDate)
			VALUES (
						<cfqueryparam value="#arguments.QuestionID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.OfferedAnswer#" cfsqltype="cf_sql_nvarchar">,
						<cfqueryparam value="#createDateSurvey#" cfsqltype="cf_sql_date">
					)
		</cfquery>
	</cffunction>
</cfcomponent>