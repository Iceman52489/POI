<cfswitch expression="#THISTAG.ExecutionMode#">
	<cfcase value="Start">
		<cfimport taglib="./" prefix="" />

		<cfparam name="ATTRIBUTES.Colspan" type="Numeric" default="" />

		<cfset CellAttributes = StructNew()>
		<cfset CellAttributes.colspan = ATTRIBUTES.Colspan>
		<cfset CellAttributes.style = "white-space:nowrap;" />
		<cfset CellAttributes.value = "" />

		<cf_row attributeCollection="#ATTRIBUTES#">
			<cf_cell attributeCollection="#CellAttributes#" />
		</cf_row>
	</cfcase>

	<cfcase value="End"></cfcase>
</cfswitch>