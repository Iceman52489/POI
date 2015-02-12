<!--- Check to see which version of the tag we are executing. --->
<cfswitch expression="#THISTAG.ExecutionMode#">
	<cfcase value="Start">
		<!--- Get a reference to the document tag context. --->
		<cfset VARIABLES.DocumentTag = GetBaseTagData( "cf_document" ) />
		<!--- Get a reference to the sheet tag context. --->
		<cfset VARIABLES.SheetTag = GetBaseTagData( "cf_sheet" ) />

		<!--- PARAM tag attributes. --->

		<!--- This is the index of the row we are about to create. --->
		<cfparam name="ATTRIBUTES.Index" type="numeric" default="#VARIABLES.SheetTag.RowIndex#" />
		<!--- Default CSS class name(s). --->
		<cfparam name="ATTRIBUTES.Class" type="string" default="" />

		<!--- Overriding CSS style values. --->
		<cfparam name="ATTRIBUTES.Style" type="string" default="" />
		<!---
			A boolean for the freeze attribute of the sheet. This will override
			any existing freeze ROW value that has been set.
		--->
		<cfparam name="ATTRIBUTES.Freeze" type="boolean" default="false" />
		<!--- Sets the Height in Points of the Row --->
		<cfparam name="ATTRIBUTES.height" default="12.75" type="any" />

		<!---
			If the Poi was used without the use of any Poi CSS class rules,	
			make a manual call to Poi:Classes.
		--->
		<cfif NOT VARIABLES.DocumentTag.intClasses>
			<cf_classes></cf_classes>
		</cfif>

		<cfscript>
			if(ATTRIBUTES.height IS "auto")
				VARIABLES.height = 0;
			else if(IsNumeric(ATTRIBUTES.height))
				VARIABLES.height = ATTRIBUTES.height;
			else Throw("[POI Usage Error] Attribute height values accepted are [numeric,'auto'].");

			// Set the row index on the sheet to be the same as the index of the current row (given by the user). 
			// This seems like a silly fix to make given the default above, but if the user jumps to a new index, 
			// we will keep the row index proper.
			VARIABLES.SheetTag.RowIndex = ATTRIBUTES.Index;

			// <!--- Create the new row. --->
			VARIABLES.Row = VARIABLES.SheetTag.Sheet.CreateRow(
				JavaCast("int", (VARIABLES.SheetTag.RowIndex - 1))
			);

			// Create a variable for the current cell index. There are hooks for this value into the Row object, 
			// but they seem to be buggy, so I am gonna run my own index to make sure that I really know what's
			// going on. This cell index holdes the INDEX OF THE CURRENT CELL.
			VARIABLES.CellIndex = 1;

			// Let's create cell style for this cell. We are going to start off by creating a duplicate of the global 
			// cell style. Then, we will add to that CSS representation.
			VARIABLES.Style = StructCopy( VARIABLES.DocumentTag.Classes[ "@cell" ] );

			// Loop over the passed class value as a space-delimited list. This will allow us to prepend any existing styles.
			for(VARIABLES.ClassName IN ListToArray(ATTRIBUTES.Class, " ")) {
				// <!--- Check to see if this class name exists in the document. --->
				if(StructKeyExists(VARIABLES.DocumentTag.Classes, VARIABLES.ClassName)) {
					// <!--- Append the class to the current CSS. --->
					VARIABLES.Style.putAll(VARIABLES.DocumentTag.Classes[ VARIABLES.ClassName ]);
				}
			}

			// Now, check to see if there are any passed-in styles. We are only going to parse this if a style was actually set.
			if(Len(ATTRIBUTES.Style)) {
				// <!--- Add row styles. --->
				VARIABLES.DocumentTag.CSSRule.AddCSS(VARIABLES.Style, ATTRIBUTES.Style);
			}

			// <!--- Get the row height property to see if has been set. --->
			if(StructKeyExists(VARIABLES.Style, "height")) {
				// <!--- If style attribute height is passed in, set height of row = Max(height attribute, style attribute height)
				VARIABLES.Height = Max(VARIABLES.Height, REReplaceNoCase(VARIABLES.Style.height, "[a-z]", "", "All"));
			}

			VARIABLES.Row.SetHeightInPoints(
				JavaCast( "float", Val(VARIABLES.Height) )
			);

			// Check to see if we need to overrid the freeze row property of the sheet for this row.
			if(ATTRIBUTES.Freeze) {
				// <!--- Store this row index as the freeze property of the parent sheet. --->
				VARIABLES.SheetTag.FreezeRow = VARIABLES.SheetTag.RowIndex;
			}
		</cfscript>
	</cfcase>

	<cfcase value="End">
		<cfscript>
			// Auto Height once dynamic height calculation of each cell is finished
			if(REFindNoCase("auto", ATTRIBUTES.height)) {
				VARIABLES.Row.setHeightInPoints(
					JavaCast("float", Val(VARIABLES.Height))
				);
			}

			// <!--- Update the row count. --->
			VARIABLES.SheetTag.RowIndex++;
		</cfscript>
	</cfcase>
</cfswitch>