<cfcomponent>
	<cffunction name="getQuestionsData" access="public" datasource="SurveyApp" returntype="query">
		<cfset var qQuestions = "">
		<cfquery name="qQuestions">
			SELECT *
			FROM SpecificQuestions
			WHERE 1 = 1
			<cfif structKeyExists(arguments,'ID') AND arguments.ID NEQ "">
				AND SpecificQuestions.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'Question') AND arguments.Question NEQ "">
				AND SpecificQuestions.Question = <cfqueryparam value="#arguments.Question#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'Reference') AND arguments.Reference NEQ "">
				AND SpecificQuestions.Reference = <cfqueryparam value="#arguments.Reference#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'Sort') AND arguments.Sort NEQ "">
				AND SpecificQuestions.Sort = <cfqueryparam value="#arguments.Sort#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'Number') AND arguments.Number NEQ "">
				AND SpecificQuestions.Number = <cfqueryparam value="#arguments.Number#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'IsTitle') AND arguments.EndDate NEQ "">
				AND SpecificQuestions.EndDate = <cfqueryparam value="#arguments.EndDate#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'IsRequired') AND arguments.isRequired NEQ "">
				AND SpecificQuestions.isRequired = <cfqueryparam value="#arguments.isRequired#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'IsYesNo') AND arguments.isYesNo NEQ "">
				AND SpecificQuestions.isYesNo = <cfqueryparam value="#arguments.isYesNo#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'AllowEditor') AND arguments.AllowEditor NEQ "">
				AND SpecificQuestions.AllowEditor = <cfqueryparam value="#arguments.AllowEditor#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'IsMultipleAnswer') AND arguments.isMultipleAnswer NEQ "">
				AND SpecificQuestions.isMultipleAnswer = <cfqueryparam value="#arguments.isMultipleAnswer#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'IsMultipleChoices') AND arguments.isMultipleChoices NEQ "">
				AND SpecificQuestions.isMultipleChoices = <cfqueryparam value="#arguments.isMultipleChoices#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'AllowComment') AND arguments.AllowComment NEQ "">
				AND SpecificQuestions.AllowComment = <cfqueryparam value="#arguments.AllowComment#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'CreateDate') AND arguments.CreateDate NEQ "">
				AND SpecificQuestions.CreateDate = <cfqueryparam value="#arguments.CreateDate#" cfsqltype="cf_sql_date">
			</cfif>
		</cfquery>
		<cfreturn qQuestions>
	</cffunction>

	<cffunction name="insertQuestion" access="public" datasource="SurveyApp" output="false">
		<cfargument name="Question" required="true">
		<cfargument name="Reference" required="true">
		<cfargument name="Number" required="true">
		<cfargument name="IsTitle" required="true">
		<cfargument name="IsRequired" required="true">
		<cfargument name="IsYesNo" required="true">
		<cfargument name="AllowEditor" required="true">
		<cfargument name="IsMultipleAnswers" required="true">
		<cfargument name="IsMultipleChoices" required="true">
		<cfargument name="AllowComment" required="true">

		<cfset var createDateSurvey = now()>
		<cfquery>
			INSERT INTO SpecificQuestions (Question,Reference,Number,IsTitle,IsRequired,IsYesNo,AllowEditor,IsMultipleAnswers,IsMultipleChoices,AllowComment,CreateDate)
			VALUES (
						<cfqueryparam value="#arguments.Question#" cfsqltype="cf_sql_nvarchar">,
						<cfqueryparam value="#arguments.Reference#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.Number#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.IsTitle#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.IsRequired#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.IsYesNo#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.AllowEditor#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.IsMultipleAnswers#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.IsMultipleChoices#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.AllowComment#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#createDateSurvey#" cfsqltype="cf_sql_date">
					)
		</cfquery>


	</cffunction>

	<cffunction name="deleteQuestion" access="public" datasource="SurveyApp" output="false">
		<cfargument name="ID" required="true" type="numeric">

		<cfquery>
			DELETE FROM SpecificQuestions
			WHERE SpecificQuestions.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
		</cfquery>

	</cffunction>
</cfcomponent>