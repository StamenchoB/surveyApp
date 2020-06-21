<cfsetting showdebugoutput="no">
<cfset this.UserGateway = createObject("component","SurveyApp.gateway.UserGateway") />
<cfset this.SurveysGateway = createObject("component","SurveyApp.gateway.SurveysGateway")>
<cfset this.AnswersGateway = createObject("component","SurveyApp.gateway.AnswersGateway")>
<cfset this.GeneralQuestionsGateway = createObject("component","SurveyApp.gateway.GeneralQuestionsGateway")>
<cfset this.SpecificQuestionsGateway = createObject("component","SurveyApp.gateway.SpecificQuestionsGateway")>
<cfset this.PeriodsGateway = createObject("component","SurveyApp.gateway.PeriodsGateway")>

	<cfif StructKeyExists(session,"userID")>
		    <cfset userID = "#session.userID#">
		    <!--- USER LOGGED IN --->
			<cfset qUser = this.UserGateway.getUsersData(ID = "#session.userID#")>
			<!--- <cfset expiration_time = DateAdd("n",20,Now()) /> --->

		    <!--- <cfheader name="Expires" value="#expiration_time#"> --->

			<cfif structKeyExists(url,"F") AND structKeyExists(url,"P")>
				<cfset FormatFile = Decrypt("#url.F#","#application.encryptKey#","AES","Hex")>
				<!--- <cfdump var = "#FormatFile#"><cfabort> --->
				<cfset periodsURL = Decrypt("#url.P#","#application.encryptKey#","AES","Hex")>
				<!--- <cfset periods = ListToArray("#periodsURL#",",",false,false)> --->
				<cfset qPeriod = this.PeriodsGateway.getPeriodsData(ID = "#periodsURL#")>
				<!--- <cfdump var = "#qPeriod#"> --->
				<cfset surveyID = "#qPeriod.SurveyID#">
				<!--- SURVEY DATA --->
				<cfset qSurvey = this.SurveysGateway.getSurveyData(ID = "#surveyID#")>
				<!--- QUESTIONS --->
				<cfset qQuestions = this.SpecificQuestionsGateway.getQuestionsData(Reference = "#surveyID#")>
				<!--- <cfdump var = "#qQuestions#"> --->

				<!--- ALL THE ANSWERS IN THIS PERIOD AND IN THAT SURVEY --->
				<cfquery name="qAnswersPeriod">
					SELECT *
					FROM Answers
					WHERE Answers.SurveyID = '#qPeriod.SurveyID#' AND Answers.CreatedDate >= '#qPeriod.StartDatePeriod#' AND Answers.CreatedDate <= '#qPeriod.EndDatePeriod#'
				</cfquery>
				<!--- <cfdump var = "#qAnswersPeriod#"><cfabort> --->

				<!--- ALL THE USERS THAT HAVE ANSWERS IN THIS PERIOD --->
				<cfset usersInvolved = ArrayNew(1)>
				<cfloop query="qAnswersPeriod">
					<cfset user = "#qAnswersPeriod.AnsweredByUserID#">
					<!--- <cfoutput>#user#</cfoutput> --->
					<cfset check = ArrayContains(usersInvolved,"#user#")>
					<cfif check EQ 1>
						<!--- DO NOTHING --->
					<cfelse>
						<cfset ArrayAppend(usersInvolved, #user#)>
					</cfif>
				</cfloop>

				<!--- ADIING ALL INFO ABOUT USERS IN ONE QUERY --->
				<cfset UsersInfo = QueryNew("ID, Firstname, Lastname, Email, Organisation, Country","Integer, VarChar, VarChar, VarChar, VarChar, VarChar")>
				<cfloop array="#usersInvolved#" index="i">
					<cfquery name="InfoAboutUsers">
						SELECT ID,Firstname,Lastname,Email,Organisation,Country
						FROM Users
						WHERE Users.ID = #i# AND Users.Admin = 0
					</cfquery>
					<cfif InfoAboutUsers.recordCount GT 0>
						<cfset QueryAddRow(UsersInfo,[{ID="#InfoAboutUsers.ID#",Firstname="#InfoAboutUsers.Firstname#",Lastname="#InfoAboutUsers.Lastname#",Email="#InfoAboutUsers.Email#",Organisation="#InfoAboutUsers.Organisation#",Country="#InfoAboutUsers.Country#"}])>
					</cfif>
				</cfloop>
				<!--- <cfdump var = "#UsersInfo#"><cfabort> --->

				<!--- PDF REPORT --->
				<cfif "#FormatFile#" EQ "pdf">
					<cfcontent type="application/pdf">
					<cfdocument format="pdf" pagetype="A4" orientation="portrait" filename="C:\ColdFusion2018\cfusion\report(#qSurvey.Name#).pdf" overwrite="true">

						<div style="font-size:11px">
							<span style="float:right"><strong>Periods :</strong></span><br />
							<span style="float:right;margin-top:10px"><cfoutput>#qPeriod.StartDatePeriod# - #qPeriod.EndDatePeriod#</cfoutput></span>
						  	<cfoutput>
							  <em>Requested by:</em><br /><br />
							  <strong>#qUser.Firstname# #qUser.Lastname#</strong><br />
							  <strong>Organisation:</strong> #qUser.Organisation#, #qUser.Country#<br />
							  <strong>E-mail:</strong> #qUser.Email#
							</cfoutput>

						</div>
						<br /><br />
						<h2 style="text-align:center">REPORT</h2>
						<p style="text-align:center"><cfoutput>#qSurvey.Name#</cfoutput></p>
						<br /><br /><br />
						<cfloop query="UsersInfo">
							<cfoutput>
								<h4 style="text-decoration:underline"><em>&bull Section: User's Information</em></h4>
								<br />
								<p style="font-size:13px"><strong>Name: </strong><em>#UsersInfo.Firstname# #UsersInfo.Lastname#</em></p>
								<p style="font-size:13px"><strong>Email: </strong><em>#UsersInfo.Email#</em></p>
								<p style="font-size:13px"><strong>Organisation: </strong><em>#UsersInfo.Organisation#, #UsersInfo.Country#</em></p>
								<br />
								<h4 style="text-decoration:underline"><em>&bull Section: Survey Activities</em></h4><br />
								<cfloop query="qQuestions">
									<p><strong>#qQuestions.Question#</strong></p><br />
									<cfloop query="qAnswersPeriod">
										<cfif "#qQuestions.ID#" EQ "#qAnswersPeriod.QuestionID#" AND "#UsersInfo.ID#" EQ "#qAnswersPeriod.AnsweredByUserID#">
											<cfif "#qAnswersPeriod.Answer#" EQ 1>
												<p><em>Yes</em></p><br />
											<cfelseif "#qAnswersPeriod.Answer#" EQ 0>
												<p><em>No</em></p><br />
											<cfelseif "#qAnswersPeriod.Answer#" EQ "">
												<p><em>NO ANSWER</em></p><br />
											<cfelse>
												<p><em>#qAnswersPeriod.Answer#</em></p><br />
											</cfif>
										</cfif>
									</cfloop>
								</cfloop>
								<br /><hr><br /><br />
							</cfoutput>
						</cfloop>
						<br />
					</cfdocument>
				 	<!--- <cfcontent type="application/octet-stream" file="#expandPath('.')#\review.pdf"> --->
					<cfset filename = "report(#qSurvey.Name#).pdf">
					<cfset folder = "C:\ColdFusion2018\cfusion\">
				    <cfset fileInfo = GetFileInfo(folder & filename)>
				    <cfset mimeType = getPageContext().getServletContext().getMimeType(folder & filename)>
				    <cfheader name="Content-Disposition" value="attachment; filename=""#filename#""">
				    <cfheader name="Expires" value="#Now()#">
				    <cfheader name="Content-Length" value="#fileInfo.size#">
				    <cfcontent type="#mimeType#" file="#folder##filename#" deletefile="No">
				</cfif>
				<!--- EXCEL REPORT --->
				<cfif "#FormatFile#" EQ "excel">
					<cfset report = spreadsheetNew()>
					<cfloop query="UsersInfo">
							<cfset spreadsheetAddRow(report, "Firstname,Lastname,Email,Organisation,Country")>
							<cfset spreadsheetFormatRow(report, { bold=true, fgcolor="lemon_chiffon", fontsize=14 }, 1)>
							<cfoutput>
								<cfset spreadSheetAddRow(report,"#UsersInfo.Firstname#,#UsersInfo.Lastname#,#UsersInfo.Email#,#UsersInfo.Organisation#,#UsersInfo.Country#")>
								<cfset spreadSheetAddRow(report,"Questions & Answers")>
								<cfset spreadsheetFormatRow(report, { bold=true, fgcolor="lemon_chiffon", fontsize=14 }, 3)>
								<cfloop query="qQuestions">
									<cfset spreadSheetAddRow(report,"'#qQuestions.Question#'")>
									<cfloop query="qAnswersPeriod">
										<cfset spreadsheetFormatRow(report, { bold=true, fgcolor="lemon_chiffon", fontsize=14 },3)>
										<cfif "#qQuestions.ID#" EQ "#qAnswersPeriod.QuestionID#" AND "#UsersInfo.ID#" EQ "#qAnswersPeriod.AnsweredByUserID#">
											<cfif "#qAnswersPeriod.Answer#" EQ 1>
												<cfset spreadSheetAddRow(report,"Yes")>
											<cfelseif "#qAnswersPeriod.Answer#" EQ 0>
												<cfset spreadSheetAddRow(report,"No")>
											<cfelseif "#qAnswersPeriod.Answer#" EQ "">
												<cfset spreadSheetAddRow(report,"''NO ANSWER'")>
											<cfelse>
												<cfset spreadSheetAddRow(report,"'#qAnswersPeriod.Answer#'",true)>
											</cfif>
										</cfif>
									</cfloop>
								</cfloop>
							</cfoutput>
							<cfset spreadSheetAddRow(report,"")>
						</cfloop>
					<!--- <cfset spreadsheetWrite(report, filename, true)> --->
					<cfheader name="Content-Disposition" value="attachment; filename=report.xls">
					<cfcontent type="application/vnd.ms-excel" variable="#SpreadsheetReadBinary( report )#">
				</cfif>
				<!--- MS WORD --->
				<cfif "#FormatFile#" EQ "word">
				</cfif>
			<cfelse>
				<cflocation url="adminPage.cfm" addtoken="false">
			</cfif>
	<cfelse>
		<cfset accessDenied = Encrypt("true","#application.encryptKey#","AES","Hex")>
		<cflocation url="loginForm.cfm?A=#accessDenied#" addtoken="false">
	</cfif>