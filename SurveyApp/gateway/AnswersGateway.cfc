<cfcomponent>

	<!--- getting Answers from Database --->
	<cffunction name="getAnswersData" access="public" datasource="SurveyApp" returntype="query">
		<cfset var qAnswers = "">
		<cfquery name="qAnswers">
			SELECT *
			FROM Answers
			WHERE 1 = 1
			<cfif structKeyExists(arguments,'ID') AND arguments.ID NEQ "">
				AND Answers.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'SurveyID') AND arguments.SurveyID NEQ "">
				AND Answers.SurveyID = <cfqueryparam value="#arguments.SurveyID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'QuestionID') AND arguments.QuestionID NEQ "">
				AND Answers.QuestionID = <cfqueryparam value="#arguments.QuestionID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'Answer') AND arguments.Answer NEQ "">
				AND Answers.Answer = <cfqueryparam value="#arguments.Answer#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'AnsweredByUserID') AND arguments.AnsweredByUserID NEQ "">
				AND Answers.AnsweredByUserID = <cfqueryparam value="#arguments.AnsweredByUserID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'IsComment') AND arguments.IsComment NEQ "">
				AND Answers.IsComment = <cfqueryparam value="#arguments.IsComment#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'CreatedDate') AND arguments.CreatedDate NEQ "">
				AND Answers.CreatedDate = <cfqueryparam value="#arguments.CreatedDate#" cfsqltype="cf_sql_integer">
			</cfif>
		</cfquery>
		<cfreturn qAnswers>
	</cffunction>

	<!--- Storing the answers from the SURVEY --->
	<cffunction name="storeAnswers" access="public" datasource="SurveyApp" output="false">
		<cfargument name="QuestionID" required>
		<cfargument name="SurveyID" required>
		<cfargument name="Answer" required>
		<cfargument name="AnsweredByUserID" required>

		<cfset var createDateSurvey = now()>
		<cfquery>
			INSERT INTO Answers (QuestionID,SurveyID,Answer,AnsweredByUserID,IsComment,CreatedDate)
			VALUES (
						<cfqueryparam value="#arguments.QuestionID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.SurveyID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.Answer#" cfsqltype="cf_sql_nvarchar">,
						<cfqueryparam value="#arguments.AnsweredByUserID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.IsComment#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#createDateSurvey#" cfsqltype="cf_sql_date">

					)
		</cfquery>


		<cfloop >
		</cfloop>
	</cffunction>

	<!--- Updating Answers --->
	<cffunction name="updateAnswers" access="public" datasource="SurveyApp" output="false">
		<cfargument name="QuestionID" required>
		<cfargument name="SurveyID" required>
		<cfargument name="Answer" required>
		<cfargument name="AnsweredByUserID" required>
		<cfargument name="IsComment" required>

		<cfset var createDateSurvey = now()>
		<cfquery>
			UPDATE Answers
			SET 	Answers.Answer = <cfqueryparam value="#arguments.Answer#" cfsqltype="cf_sql_nvarchar">,
					 Answers.CreatedDate = <cfqueryparam value="#createDateSurvey#" cfsqltype="cf_sql_date">

			WHERE	Answers.QuestionID = <cfqueryparam value="#arguments.QuestionID#" cfsqltype="cf_sql_integer">
					AND Answers.SurveyID = <cfqueryparam value="#arguments.SurveyID#" cfsqltype="cf_sql_integer">
					AND Answers.AnsweredByUserID = <cfqueryparam value="#arguments.AnsweredByUserID#" cfsqltype="cf_sql_integer">
					AND Answers.IsComment = <cfqueryparam value="#arguments.IsComment#" cfsqltype="cf_sql_bit">
		</cfquery>


		<cfloop >
		</cfloop>
	</cffunction>
</cfcomponent>