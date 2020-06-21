<cfcomponent>

	<cfset this.applicationTimeout = createtimespan(0,8,0,0) />
	<cfset this.datasource = 'SurveyApp' />
	<cfset this.sessionManagement = true />
	<cfset this.sessionTimeout = createTimespan(0,2,0,0) />

	<!--- <cfset  application.encryptKey = "b_.CDt(|i;2(%'s`|]cZWGl)qRDXKg"> --->

	<cffunction name="onApplicationStart" returntype="boolean">
		<cfset application.loginServices = createObject("component","SurveyApp.components.loginServices")>
		<cfset application.utility = createObject("component","SurveyApp.components.utility")>
		<cfset application.UserGateway = createObject("component","SurveyApp.gateway.UserGateway")>
		<cfset application.SurveysGateway = createObject("component","SurveyApp.gateway.SurveysGateway")>
		<cfset this.GeneralQuestionsGateway = createObject("component","SurveyApp.gateway.GeneralQuestionsGateway")>
		<cfset this.SpecificQuestionsGateway = createObject("component","SurveyApp.gateway.SpecificQuestionsGateway")>
		<cfset application.AnswersGateway = createObject("component","SurveyApp.gateway.AnswersGateway")>
		<cfset application.registrationServices = createObject("component","SurveyApp.components.registrationServices")>
		<cfset application.encryptKey = "zMmNebTYHnlvdC41iXsKuw==">

		<cfreturn true>
	</cffunction>

	<cffunction name="onRequestStart" returntype="boolean">
		<cfreturn true>
	</cffunction>

	<cffunction name="onApplicationStop">
		<cfset structClear(session)>
	</cffunction>

</cfcomponent>