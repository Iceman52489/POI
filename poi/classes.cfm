<!--- Check to see which version of the tag we are executing. --->
<cfswitch expression="#THISTAG.ExecutionMode#">
	<cfcase value="Start">
	</cfcase>

	<cfcase value="End">
		<cfinclude template="../../../../includes/POIClasses.cfm">
		<!--- Debugging Purposes --->
		<!---
		<cfset VARIABLES.DocumentTag = GetBaseTagData( "cf_document" ) />
		<cfdump var="#VARIABLES.DocumentTag.Classes#">
		<cfabort>
		 --->
	</cfcase>
</cfswitch>