<cfsetting showdebugoutput="no">

<cfset this.UserGateway = createObject("component","SurveyApp.gateway.UserGateway") />
<cfset this.SurveysGateway = createObject("component","SurveyApp.gateway.SurveysGateway")>
<cfset this.PeriodsGateway = createObject("component","SurveyApp.gateway.PeriodsGateway")>
<cfset this.GeneralQuestionsGateway = createObject("component","SurveyApp.gateway.GeneralQuestionsGateway")>
<cfset this.SpecificQuestionsGateway = createObject("component","SurveyApp.gateway.SpecificQuestionsGateway")>
<cfset this.AnswersGateway = createObject("component","SurveyApp.gateway.AnswersGateway")>


<cfif structKeyExists(url,"ActiveSurveyName") OR structKeyExists(url,"startDatePicked") AND structKeyExists(url,"endDatePicked") AND structKeyExists(url,"SurveyName")>

	<cfswitch expression="#url.method#">
		<!--- CFCASE for returning the questions for the given survey --->
		<!--- <cfcase value="getQuestions">
		<cfset reusable = "#url.isReusable#">
		<cfquery name="qQuestions">
			SELECT *
			FROM Questions
			WHERE Questions.isReusable = #reusable#
		</cfquery>
		<cfset result = serializeJSON(qQuestions,'struct')>
		<cfoutput>#result#</cfoutput>
		</cfcase> --->


		<cfcase value="getSurveyPeriods">
			<cfset qSurvey = this.SurveysGateway.getSurveyData(Name = "#url.ActiveSurveyName#")>
			<cfset qSurveyPeriods = this.PeriodsGateway.getPeriodsData(SurveyID = "#qSurvey.ID#")>

			<cfset result1 = serializeJSON(qSurveyPeriods,'struct')>
			<cfoutput>#result1#</cfoutput>
		</cfcase>

		<cfcase value="getPeriodsDatePicked">
			<!--- <cfdump var = "#url.SurveyName#"><cfabort> --->
			<cfset qSurvey = this.SurveysGateway.getSurveyData(Name = "#url.SurveyName#")>
			<cfquery name="qPeriods">
				SELECT *
				FROM SurveyPeriods
				WHERE SurveyPeriods.SurveyID = <cfqueryparam value="#qSurvey.ID#" cfsqltype="cf_sql_integer"> AND (SurveyPeriods.StartDatePeriod >= <cfqueryparam value="#url.startDatePicked#" cfsqltype="date"> AND SurveyPeriods.EndDatePeriod <= <cfqueryparam value="#url.endDatePicked#" cfsqltype="date">)
			</cfquery>
			<cfset result2= serializeJSON(qPeriods,'struct')>
			<cfoutput>#result2#</cfoutput>
		</cfcase>
	</cfswitch>
</cfif>



