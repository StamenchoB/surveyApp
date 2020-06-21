<cfsetting showdebugoutput="no">
<cfset this.UserGateway = createObject("component","SurveyApp.gateway.UserGateway") />
<cfset this.SurveysGateway = createObject("component","SurveyApp.gateway.SurveysGateway")>
<cfset this.AnswersGateway = createObject("component","SurveyApp.gateway.AnswersGateway")>
<cfset this.GeneralQuestionsGateway = createObject("component","SurveyApp.gateway.GeneralQuestionsGateway")>
<cfset this.SpecificQuestionsGateway = createObject("component","SurveyApp.gateway.SpecificQuestionsGateway")>


	<cfif StructKeyExists(session,"userID")>
		    <cfset userID = "#session.userID#">
		    <!--- USER LOGGED IN --->
			<cfset qUser = this.UserGateway.getUsersData(ID = "#session.UserID#")>
			<!--- SURVEY DATA --->
			<!--- <cfcontent type="application/octet-stream" file="#expandPath('.')#\review.pdf"> --->
			<cfset expiration_time = DateAdd("n",20,Now()) />
			<cfset folder = "C:\ColdFusion2018\cfusion\">
			<cfif StructKeyExists(url,"FN") AND structKeyExists(url,"S")>
				<cfset surveyID = Decrypt("#url.S#","#application.encryptKey#","AES","Hex")>
				<cfset qSurvey = this.SurveysGateway.getSurveyData(ID = "#surveyID#")>
			    <cfset filename = Decrypt("#url.FN#","#application.encryptKey#","AES","Hex")& ".pdf">
			    <cfset fileInfo = GetFileInfo(folder & filename)>
			    <cfset mimeType = getPageContext().getServletContext().getMimeType(folder & filename)>
			    <cfheader name="Content-Disposition" value="attachment; filename=""#filename#""">
			    <cfheader name="Expires" value="#expiration_time#">
			    <cfheader name="Content-Length" value="#fileInfo.size#">
			    <cfcontent type="#mimeType#" file="#folder##filename#" deletefile="No">
			<cfelse>
				<cflocation url="surveySubmitResponse.cfm" addtoken="false">
			</cfif>
	<cfelse>
		<cfset accessDenied = Encrypt("true","#application.encryptKey#","AES","Hex")>
		<cflocation url="loginForm.cfm?A=#accessDenied#" addtoken="false">
	</cfif>