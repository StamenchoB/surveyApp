<cfcomponent>
	<cfset this.GeneralQuestionsGateway = createObject("component","SurveyApp.gateway.GeneralQuestionsGateway")>
	<cfset this.SpecificQuestionsGateway = createObject("component","SurveyApp.gateway.SpecificQuestionsGateway")>

	<cffunction name="getQuestions" access="remote" output="false" returnformat="JSON">

	<cfif structKeyExists(url,"draw") AND structKeyExists(url,"start") AND structKeyExists(url,"length") AND structKeyExists(url,"isReusable") AND structKeyExists(url,"SurveyID")>
		<cfset draw = "#url.draw#">
		<cfset offset = "#url.start#">
		<cfset length = "#url.length#">
		<cfset limit = #length# + #offset#>
		<!--- <cfdump var = "#offset#">
		<cfdump var = "#length#">
		<cfdump var = "#limit#"> --->
		<cfset GeneralQuestions = this.GeneralQuestionsGateway.getQuestionsData(Reference = 0)>
		<cfset GeneralQuestionsCnt = GeneralQuestions.recordCount>

		<cfset allQuestions2 = this.SpecificQuestionsGateway.getQuestionsData(Reference = "#url.SurveyID#")>

		<!--- <cfdump var ="#allQuestionsCnt#"> --->

		<cfquery name="allQuestions" datasource="SurveyApp">
			SELECT *
			FROM GeneralQuestions
			ORDER BY GeneralQuestions.ID DESC OFFSET #offset# ROWS FETCH NEXT #length# ROWS ONLY
		</cfquery>

		<cfset allQuestionsCnt = allQuestions.recordCount>
		<!--- Pravenje na querito vo array so cel da bide vo format kako za vo DataTables --->
		<cfset dataset = [] />
		<cfloop query="allQuestions">
		    <cfset record = {} />
		    <cfset check = 1>
		    <cfloop query="allQuestions2">
			    <cfif #allQuestions.Question# EQ #allQuestions2.Question# AND #allQuestions.IsYesNo# EQ #allQuestions2.IsYesNo# AND #allQuestions.AllowEditor# EQ #allQuestions2.AllowEditor# AND #allQuestions.IsMultipleAnswers# EQ #allQuestions2.IsMultipleAnswers# AND #allQuestions.IsMultipleChoices# EQ #allQuestions2.IsMultipleChoices#>
				    <cfset check = 0>
				</cfif>
			</cfloop>
				<cfif check EQ 1>
					<cfset record["ID"] = allQuestions.ID />
				    <cfset record["Question"] = allQuestions.Question />
				    <cfset record["Reference"] = allQuestions.Reference />
				    <cfset record["Sort"] = allQuestions.Sort />
				    <cfset record["Number"] = allQuestions.Number />
				    <cfset record["IsTitle"] = allQuestions.IsTitle />
				    <cfset record["IsRequired"] = allQuestions.IsRequired />
				    <cfset record["IsYesNo"] = allQuestions.IsYesNo />
				    <cfset record["AllowEditor"] = allQuestions.AllowEditor />
				    <cfset record["IsMultipleAnswers"] = allQuestions.IsMultipleAnswers />
				    <cfset record["IsMultipleChoices"] = allQuestions.IsMultipleChoices />
				    <cfset record["AllowComment"] = allQuestions.AllowComment />
				    <cfset record["CreateDate"] = allQuestions.CreateDate />
				    <cfset ArrayAppend(dataset, record) />
				</cfif>
		</cfloop>
		<!--- <cfdump var = "#dataset#"><cfabort> --->
		<cfset Datasetcnt = ArrayLen(dataset)>
		<cfset structResult = StructNew()>
		<cfset structResult = {'recordsFiltered':#GeneralQuestionsCnt#,'recordsTotal':#GeneralQuestionsCnt#,'draw':#draw#,'data':#dataset#}>
		<cfset result = serializeJSON(structResult,'struct')>

		<!--- <cfdump var="#result#"><cfabort> --->
		<cfreturn result>
	</cfif>
	</cffunction>
</cfcomponent>