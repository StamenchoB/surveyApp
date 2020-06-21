<cfcomponent>


	<cfset this.salt = 'fmkJX4@@hcY50}Z~' />

	<!--- Funkcija za Hashiranje na password --->
	 <cffunction name="makeHash" access="public" output="true" returntype="string">
		<cfargument name="item" required="yes" type="string">

		<cfset var salt = this.salt/>
		<cfset var returnItem = Hash(trim(arguments.item) & salt, 'SHA-512' )/>

		<cfloop from="1" to="1025" index="i">
			<cfset returnItem = hash(returnItem & salt, 'SHA-512') />
		</cfloop>

		<cfreturn returnItem/>
	</cffunction>

	<!--- Funckija za generiranje na passwordi --->
	<cffunction name="generatePassword" access="public" output="true" returntype="string">
		<cfargument name="item" required="yes" type="string">
		<cfargument name="salt" required="yes" type="string">

		<cfset var new_salt = arguments.salt />

		<cfset var password = Hash(trim(arguments.item) & new_salt, 'SHA-512' )/>


		<cfloop from="1" to="1025" index="i">
			<cfset password = hash(password & new_salt, 'SHA-512') />
		</cfloop>

		<cfreturn password />
	</cffunction>
</cfcomponent>