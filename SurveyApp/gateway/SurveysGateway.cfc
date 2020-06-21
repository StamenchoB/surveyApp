<cfcomponent>

	<!--- For returning data about the Survey --->
	<cffunction name="getSurveyData" access="public" datasource="SurveyApp" returntype="query">
		<cfset var qSurvey = "">
		<cfquery name="qSurvey">
			SELECT *
			FROM Surveys
			WHERE 1 = 1
			<cfif structKeyExists(arguments,'ID') AND arguments.ID NEQ "">
				AND Surveys.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'Name') AND arguments.Name NEQ "">
				AND Surveys.Name = <cfqueryparam value="#arguments.Name#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'DescriptionShort') AND arguments.DescriptionShort NEQ "">
				AND Surveys.DescriptionShort = <cfqueryparam value="#arguments.DescriptionShort#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'Description') AND arguments.Description NEQ "">
				AND Surveys.Description = <cfqueryparam value="#arguments.Description#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'StartDate') AND arguments.StartDate NEQ "">
				AND Surveys.StartDate = <cfqueryparam value="#arguments.StartDate#" cfsqltype="cf_sql_datetime">
			</cfif>
			<cfif structKeyExists(arguments,'EndDate') AND arguments.EndDate NEQ "">
				AND Surveys.EndDate = <cfqueryparam value="#arguments.EndDate#" cfsqltype="cf_sql_datetime">
			</cfif>
			<cfif structKeyExists(arguments,'RequestedBy') AND arguments.RequestedBy NEQ "">
				AND Surveys.RequestedBy = <cfqueryparam value="#arguments.RequestedBy#" cfsqltype="cf_sql_nvarchar">
			</cfif>
			<cfif structKeyExists(arguments,'Active') AND arguments.Active NEQ "">
				AND Surveys.ActiveD = <cfqueryparam value="#arguments.Active#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'CreateDate') AND arguments.CreateDate NEQ "">
				AND Surveys.CreateDate = <cfqueryparam value="#arguments.CreateDate#" cfsqltype="cf_sql_datetime">
			</cfif>
			<cfif structKeyExists(arguments,'AllowMultiplePeriods') AND arguments.AllowMultiplePeriods NEQ "">
				AND Surveys.AllowMultiplePeriods = <cfqueryparam value="#arguments.AllowMultiplePeriods#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'QuestionsPerPage') AND arguments.QuestionsPerPage NEQ "">
				AND Surveys.QuestionsPerPage = <cfqueryparam value="#arguments.QuestionsPerPage#" cfsqltype="cf_sql_integer">
			</cfif>
			<cfif structKeyExists(arguments,'FirstnameMandatory') AND arguments.FirstnameMandatory NEQ "">
				AND Surveys.FirstnameMandatory = <cfqueryparam value="#arguments.FirstnameMandatory#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'LastnameMandatory') AND arguments.LastnameMandatory NEQ "">
				AND Surveys.LastnameMandatory = <cfqueryparam value="#arguments.LastnameMandatory#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'EmailMandatory') AND arguments.EmailMandatory NEQ "">
				AND Surveys.EmailMandatory = <cfqueryparam value="#arguments.EmailMandatory#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'PhoneNumberMandatory') AND arguments.PhoneNumberMandatory NEQ "">
				AND Surveys.PhoneNumberMandatory = <cfqueryparam value="#arguments.PhoneNumberMandatory#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'OrganisationMandatory') AND arguments.OrganisationMandatory NEQ "">
				AND Surveys.OrganisationMandatory = <cfqueryparam value="#arguments.OrganisationMandatory#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'AllowAdditionalContactInfo') AND arguments.AllowAdditionalContactInfo NEQ "">
				AND Surveys.AllowAdditionalContactInfo = <cfqueryparam value="#arguments.AllowAdditionalContactInfo#" cfsqltype="cf_sql_bit">
			</cfif>
			<cfif structKeyExists(arguments,'UseGeneralQuestions') AND arguments.UseGeneralQuestions NEQ "">
				AND Surveys.UseGeneralQuestions = <cfqueryparam value="#arguments.UseGeneralQuestions#" cfsqltype="cf_sql_bit">
			</cfif>
		</cfquery>
		<cfreturn qSurvey>
	</cffunction>

	<!--- For updating data after editing the survey --->
	<cffunction name="createSurveyData" access="public" datasource="SurveyApp" returntype="void">
		<cfargument name="Name" type="string" required="true">
		<cfargument name="StartDate" required="true">
		<cfargument name="EndDate" required="true">
		<cfargument name="DescriptionShort" type="string" required="true">
		<cfargument name="Description" type="string" required="true">
		<cfargument name="ThankYouMessage" type="string" required="true">
		<!--- <cfargument name="RequestedBy" type="string" required="true"> --->
		<cfargument name="AllowAdditionalContactInfo" required="true">
		<cfargument name="CreatedBy" type="numeric" required="true">
		<cfargument name="AllowMultiplePeriods" required="true">
		<cfargument name="QuestionsPerPage" required="true">
		<cfargument name="FirstnameMandatory" required="true">
		<cfargument name="LastnameMandatory" required="true">
		<cfargument name="EmailMandatory" required="true">
		<cfargument name="PhoneNumberMandatory" required="true">
		<cfargument name="OrganisationMandatory" required="true">
		<!--- <cfargument name="ShowPreviousAnswers" required="true">
		<cfargument name="EditPreviousAnswers" required="true"> --->


		<cfset var createDateSurvey = now()>
		<cfquery datasource="SurveyApp" name="createdSurvey">
			INSERT INTO Surveys (Name,StartDate,EndDate,DescriptionShort,Description,
								ThankYouMessage,Active,CreateDate,CreatedBy,AllowMultiplePeriods,
								QuestionsPerPage,FirstnameMandatory,LastnameMandatory,EmailMandatory,
								PhoneNumberMandatory,OrganisationMandatory,AllowAdditionalContactInfo)
			VALUES (
						<cfqueryparam value="#arguments.Name#" cfsqltype="cf_sql_nvarchar">,
						<cfqueryparam value="#arguments.StartDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.EndDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.DescriptionShort#" cfsqltype="cf_sql_nvarchar">,
						<cfqueryparam value="#arguments.Description#" cfsqltype="cf_sql_nvarchar">,
						<cfqueryparam value="#arguments.ThankYouMessage#" cfsqltype="cf_sql_nvarchar">,
						<!--- <cfqueryparam value="#arguments.RequestedBy#" cfsqltype="cf_sql_nvarchar">, --->
						<cfqueryparam value=1 cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#createDateSurvey#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.CreatedBy#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.AllowMultiplePeriods#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.QuestionsPerPage#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.FirstnameMandatory#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.LastnameMandatory#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.EmailMandatory#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.PhoneNumberMandatory#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.OrganisationMandatory#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.AllowAdditionalContactInfo#" cfsqltype="cf_sql_bit">
					)
			SELECT @@IDENTITY AS SurveyID
		</cfquery>
		<cfquery>
			INSERT INTO SurveyPeriods (SurveyID,StartDatePeriod,EndDatePeriod,ShowPreviousAnswers,EditPreviousAnswers,PeriodExpired,CreatedDate)
			VALUES (
						<cfqueryparam value="#createdSurvey.SurveyID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.StartDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.EndDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#arguments.ShowPreviousAnswers#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#arguments.EditPreviousAnswers#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value=0 cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#createDateSurvey#" cfsqltype="cf_sql_date">
					)
		</cfquery>

	</cffunction>

	<!--- For deleting Surveys --->
	<!--- <cffunction name="deleteSurvey" access="public" datasource="SurveyApp" output="false">
		<cfargument name="ID" required="true">
		<cfquery>
			DELETE FROM Surveys
			WHERE Surveys.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cffunction> --->

	<!--- For Updating Survey's Data --->
	<cffunction name="updateSurveyData" access="public" datasource="SurveyApp" output="false">
		<cfargument name="ID" type="numeric" required="true">
		<cfargument name="Name" type="string" required="true">
		<cfargument name="StartDate" required="true" type="date">
		<cfargument name="EndDate" required="true" type="date">
		<cfargument name="DescriptionShort" type="string" required="true">
		<cfargument name="Description" type="string" required="true">
		<cfargument name="ThankYouMessage" type="string" required="true">
		<!--- <cfargument name="RequestedBy" type="string" required="true"> --->
		<cfargument name="AllowAdditionalContactInfo" required="true">
		<cfargument name="AllowMultiplePeriods" required="true">
		<cfargument name="QuestionsPerPage" required="true">
		<cfargument name="FirstnameMandatory" required="true">
		<cfargument name="LastnameMandatory" required="true">
		<cfargument name="EmailMandatory" required="true">
		<cfargument name="PhoneNumberMandatory" required="true">
		<cfargument name="OrganisationMandatory" required="true">

		<cfquery datasource="SurveyApp">
			UPDATE Surveys
			SET	Surveys.Name = <cfqueryparam value="#arguments.Name#" cfsqltype="cf_sql_nvarchar">,
				Surveys.StartDate = <cfqueryparam value="#arguments.StartDate#" cfsqltype="cf_sql_date">,
				Surveys.EndDate = <cfqueryparam value="#arguments.EndDate#" cfsqltype="cf_sql_date">,
				Surveys.DescriptionShort = <cfqueryparam value="#arguments.DescriptionShort#" cfsqltype="cf_sql_nvarchar">,
				Surveys.Description = <cfqueryparam value="#arguments.Description#" cfsqltype="cf_sql_nvarchar">,
				Surveys.ThankYouMessage = <cfqueryparam value="#arguments.ThankYouMessage#" cfsqltype="cf_sql_nvarchar">,
				Surveys.AllowAdditionalContactInfo = <cfqueryparam value="#arguments.AllowAdditionalContactInfo#" cfsqltype="cf_sql_bit">,
				Surveys.AllowMultiplePeriods = <cfqueryparam value="#arguments.AllowMultiplePeriods#" cfsqltype="cf_sql_bit">,
				Surveys.QuestionsPerPage = <cfqueryparam value="#arguments.QuestionsPerPage#" cfsqltype="cf_sql_bit">,
				Surveys.FirstnameMandatory = <cfqueryparam value="#arguments.FirstnameMandatory#" cfsqltype="cf_sql_bit">,
				Surveys.LastnameMandatory = <cfqueryparam value="#arguments.LastnameMandatory#" cfsqltype="cf_sql_bit">,
				Surveys.EmailMandatory = <cfqueryparam value="#arguments.EmailMandatory#" cfsqltype="cf_sql_bit">,
				Surveys.PhoneNumberMandatory = <cfqueryparam value="#arguments.PhoneNumberMandatory#" cfsqltype="cf_sql_bit">,
				Surveys.OrganisationMandatory = <cfqueryparam value="#arguments.OrganisationMandatory#" cfsqltype="cf_sql_bit">
			WHERE Surveys.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cffunction>

	<!--- Updating Active Status --->
	<cffunction name="updateNotActive" access="public" datasource="SurveyApp" output="false">

		<cfargument name="ID" required="true">

		<cfquery datasource="SurveyApp">
			UPDATE Surveys
			SET Active = 0
			WHERE Surveys.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
		</cfquery>

	</cffunction>

	<!--- Updating the Active Status to 1 if there is a period active compared to today's Date --->
	<cffunction name="updateActive" access="public" datasource="SurveyApp" output="false">

		<cfargument name="ID" required="true">

		<cfquery datasource="SurveyApp">
			UPDATE Surveys
			SET Active = 1
			WHERE Surveys.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
		</cfquery>

	</cffunction>

	<!--- Changing Active Status --->
	<cffunction name="changeActiveStatus" access="public" datasource="SurveyApp" output="false">

		<cfargument name="Name" required="true">

		<cfquery name="qSurvey">
			SELECT Active
			FROM Surveys
			WHERE Surveys.Name = <cfqueryparam value="#arguments.Name#" cfsqltype="cf_sql_nvarchar">
		</cfquery>

		<cfif qSurvey.Active EQ 1>
			<cfquery datasource="SurveyApp">
				UPDATE Surveys
				SET Active = 0
				WHERE Surveys.Name = <cfqueryparam value="#arguments.Name#" cfsqltype="cf_sql_nvarchar">
			</cfquery>
		<cfelse>
			<cfquery>
				UPDATE Surveys
				SET Active = 1
				WHERE Surveys.Name = <cfqueryparam value="#arguments.Name#" cfsqltype="cf_sql_nvarchar">
			</cfquery>
		</cfif>

	</cffunction>

	<!--- Update StartDate and EndDate of the Survey --->
	<cffunction name="updateStartEndDate" access="public" datasource="SurveyApp" output="false">
		<cfargument name="ID" required="true">
		<cfargument name="StartDate" required="true">
		<cfargument name="EndDate" required="true">

		<cfquery datasource="SurveyApp">
			UPDATE Surveys
			SET Surveys.StartDate = <cfqueryparam value="#arguments.StartDate#" cfsqltype="cf_sql_date">,
				Surveys.EndDate = <cfqueryparam value="#arguments.EndDate#" cfsqltype="cf_sql_date">
			WHERE Surveys.ID = <cfqueryparam value="#arguments.ID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cffunction>


</cfcomponent>