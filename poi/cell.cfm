	<!--- Check to see which version of the tag we are executing. --->
<cfswitch expression="#THISTAG.ExecutionMode#">
	<cfcase value="Start">
		<cfset VARIABLES.JavaLoader = SERVER[APPLICATION.javaLoaderKey]>

		<!--- Get a reference to the document tag context. --->
		<cfset VARIABLES.DocumentTag = GetBaseTagData( "cf_document" ) />

		<!--- Get a reference to the sheet tag context. --->
		<cfset VARIABLES.SheetTag = GetBaseTagData( "cf_sheet" ) />

		<!--- Get a reference to the row tag context. --->
		<cfset VARIABLES.RowTag = GetBaseTagData( "cf_row" ) />

		<!--- Param tag attributes. --->

		<!--- The data type for this cell. --->
		<cfparam name="ATTRIBUTES.Type" type="string" default="string" />

		<!---
			The index at which this cell will be created. Defaults to be
			appended to the row.
		--->
		<cfparam name="ATTRIBUTES.Index" type="numeric" default="#VARIABLES.RowTag.CellIndex#" />
		<!---
			The number of columns to span with this cell (ie. how many
			merged cells are we going to create).
		--->
		<cfparam name="ATTRIBUTES.ColSpan" type="numeric" default="1" />
		<!---
			The number of columns to span with this cell (ie. how many
			merged cells are we going to create).
		--->
		<cfparam name="ATTRIBUTES.RowSpan" type="numeric" default="1" />

		<!--- Default number format mask. --->
		<cfparam name="ATTRIBUTES.NumberFormat" type="string" default="0.00" />

		<!--- Default date format mask. --->
		<cfparam name="ATTRIBUTES.DateFormat" type="string" default="d-mmm-yy" />

		<!--- Default CSS class name(s). --->
		<cfparam name="ATTRIBUTES.Class" type="string" default="" />

		<!--- Overriding CSS style values. --->
		<cfparam name="ATTRIBUTES.Style" type="string" default="" />

		<!--- Alias for this cell (for use with in other cell's formulas). --->
		<cfparam name="ATTRIBUTES.Alias" type="string" default="" />

		<cfif ATTRIBUTES.type IS "image">
			<cfparam name="ATTRIBUTES.ImageHeight" type="numeric" default="1" />
			<cfparam name="ATTRIBUTES.x1" type="numeric" default="1" />
			<cfparam name="ATTRIBUTES.x2" type="numeric" default="1" />
		</cfif>

		<!--- If the user provided a number format, check to see if it is valid. --->
		<cfif NOT StructKeyExists( VARIABLES.DocumentTag.NumberFormats, ATTRIBUTES.NumberFormat )>
			<!--- The number format was not valid, so throw an exception. --->
			<cfthrow
				type="Cell.InvalidNumberFormat"
				message="Invalid number format provided."
				detail="The number format that you provided, #ATTRIBUTES.NumberFormat#, is not a valid format."
				/>
		</cfif>

		<!--- If the user provided a date format, check to see if it is valid. --->
		<cfif NOT StructKeyExists( VARIABLES.DocumentTag.DateFormats, ATTRIBUTES.DateFormat )>
			<!--- The number format was not valid, so throw an exception. --->
			<cfthrow
				type="Cell.InvalidDateFormat"
				message="Invalid date format provided."
				detail="The date format that you provided, #ATTRIBUTES.DateFormat#, is not a valid format."
				/>
		</cfif>

		<!---
			Set the cell index on the row to be the sam e as the index
			of the current cell (given by the user). This seems like a silly
			fix to make given the default above, but if the user jumps to a
			new index, we will keep the cell index proper.
		--->
		<cfset VARIABLES.RowTag.CellIndex = ATTRIBUTES.Index />

		<!---
			Next, we have to move as high up the chain as possible. Start with the
			columns - check to see if we have a column definition for this column.
		--->
		<cfif StructKeyExists( VARIABLES.SheetTag.ColumnClasses, ATTRIBUTES.Index )>
			<!--- We have the column index, so append its styles. --->
			<cfset VARIABLES.Style = StructCopy( VARIABLES.SheetTag.ColumnClasses[ ATTRIBUTES.Index ] ) />

			<!--- Next, append the row styles. --->
			<cfset StructAppend( VARIABLES.Style, VARIABLES.RowTag.Style ) />
		<cfelse>
			<!---
				If we don't have a column class, then just start out duplicating
				the row styles.
			--->
			<cfset VARIABLES.Style = StructCopy( VARIABLES.RowTag.Style ) />
		</cfif>

		<!---
			Loop over the passed class value as a space-delimited list. This
			will allow us to prepend any existing styles.
		--->
		<cfloop index="VARIABLES.ClassName" list="#ATTRIBUTES.Class#" delimiters=" ">
			<!--- Check to see if this class name exists in the document. --->
			<cfif StructKeyExists( VARIABLES.DocumentTag.Classes, VARIABLES.ClassName )>
				<!--- Append the class to the current style. --->
				<cfset StructAppend(VARIABLES.Style, VARIABLES.DocumentTag.Classes[ VARIABLES.ClassName ]) />
			</cfif>
		</cfloop>

		<!---
			Now, check to see if we have any passed-in styles. If so, let's
			add that CSS to the row styles.
		--->
		<cfif Len( ATTRIBUTES.Style )>
			<!--- Add cell styles. --->
			<cfset VARIABLES.DocumentTag.CSSRule.AddCSS(VARIABLES.Style, ATTRIBUTES.Style) />
		</cfif>

		<!---
			At this point, we have applied all the CSS we can to this
			particular CSS. That means that cell-instance of the CSSRule.cfc
			has been finished being updated.

			We are going to be using the Style object as the key in our
			cached style Hashtable; howevman this is a nice feelinger, the value formatting is also
			part of this, so, we have to hadd the value formatting to our
			style struct even though it will never be refefenced.
		--->
		<cfset VARIABLES.Style.Type = ATTRIBUTES.Type />
		<cfset VARIABLES.Style.NumberFormat = ATTRIBUTES.NumberFormat />
		<cfset VARIABLES.Style.DateFormat = ATTRIBUTES.DateFormat />

		<!---
			Check to see if we have an alias. If so, then we have to store the
			Column/Row value in the document tag.
		--->
		<cfif Len( ATTRIBUTES.Alias )>
			<!---
				Store the alias in "column/row" format. When storing the alias name,
				we are going to store it using an "@" sign to make the lookup / replace
				easier on processing.

				When getting the column value, we need to see if we are in a column
				that is larger than 26. If so, then we need to start MOD'ing our
				column value to get the proper lookup.
			--->
			<cfif (VARIABLES.RowTag.CellIndex GT ArrayLen( VARIABLES.DocumentTag.ColumnLookup ))>
				<!--- Use MOD'ing on column lookup. --->
				<cfset VARIABLES.DocumentTag.CellAliases[ "@#ATTRIBUTES.Alias#" ] = (
					VARIABLES.DocumentTag.ColumnLookup[ Fix( VARIABLES.RowTag.CellIndex / ArrayLen( VARIABLES.DocumentTag.ColumnLookup ) ) ] &
					VARIABLES.DocumentTag.ColumnLookup[ VARIABLES.RowTag.CellIndex MOD ArrayLen( VARIABLES.DocumentTag.ColumnLookup ) ] &
					VARIABLES.SheetTag.RowIndex
					) />
			<cfelse>
				<!--- Store in single column lookup. --->
				<cfset VARIABLES.DocumentTag.CellAliases[ "@#ATTRIBUTES.Alias#" ] = (VARIABLES.DocumentTag.ColumnLookup[ VARIABLES.RowTag.CellIndex ] & VARIABLES.SheetTag.RowIndex) />
			</cfif>
		</cfif>

		<cfscript>
			if(ATTRIBUTES.Type IS "image") {
				if(Len(ATTRIBUTES.value)) {
					ATTRIBUTES.ImageHeight = Round(ATTRIBUTES.ImageHeight);
					ATTRIBUTES.StartRow = VARIABLES.SheetTag.RowIndex + 1;
					ATTRIBUTES.EndRow = VARIABLES.SheetTag.RowIndex + ATTRIBUTES.ImageHeight;

					VARIABLES.DocumentTag.Images.add({
						"FilePath" = ATTRIBUTES.Value,
						"StartRow" = ATTRIBUTES.StartRow,
						"EndRow" = ATTRIBUTES.EndRow,
						"StartCol" = ATTRIBUTES.x1,
						"EndCol" = ATTRIBUTES.x2 + 1,
						"SheetName" = VARIABLES.SheetTag.Sheet.getSheetName()
					});
				} else {
					Throw(type="Cell.InvalidValue", message="For IMAGE cell types, the value passed in must be an absolute path to the image!");
				}
			}
		</cfscript>
	</cfcase>

	<cfcase value="End">
		<!---
			Check to see if the Value attribute was supplied. If it was,
			then we will use that value rather than the generated content
			of the tag.
		--->
		<cfif (StructKeyExists( ATTRIBUTES, "Value" ) AND IsSimpleValue( ATTRIBUTES.Value ))>
			<!--- Store value into generated content. --->
			<cfset THISTAG.GeneratedContent = ATTRIBUTES.Value />
		</cfif>

		<!---
			ASSERT: At this point, no matter where the value is coming
			from, we know that the value we want to work with is stored
			in the Generated Content.
		--->
		<cfloop from="0" to="#ATTRIBUTES.colspan - 1#" index="intCol">
			<!--- Create a cell. --->
			<cfset VARIABLES.Cell = VARIABLES.RowTag.Row.CreateCell(JavaCast( "int", (ATTRIBUTES.Index - 1 + intCol) )) />
			<!---
				Check to make sure we have a value to output. If we don't
				have a value, then our data type casting will error.
			--->
			<cfif Len(THISTAG.GeneratedContent) OR (ATTRIBUTES.type IS "image" AND Len(ARGUMENTS.value))>
				<cfset THISTAG.GeneratedContent = REReplace(THISTAG.GeneratedContent, "<br>|<br \/>|<br\/>|\\n", "#chr(10)#", "All") />

				<!--- Check to see which type of value we are setting. --->
				<cfif intCol EQ 0>
					<cfswitch expression="#ATTRIBUTES.Type#">
						<cfcase value="date">
							<!--- Create calendar object. --->
							<cfset VARIABLES.Date = CreateObject( "java", "java.util.GregorianCalendar" ).Init(
								JavaCast( "int", Year( THISTAG.GeneratedContent ) ),
								JavaCast( "int", (Month( THISTAG.GeneratedContent ) - 1) ),
								JavaCast( "int", Day( THISTAG.GeneratedContent ) ),
								JavaCast( "int", Hour( THISTAG.GeneratedContent ) ),
								JavaCast( "int", Minute( THISTAG.GeneratedContent ) ),
								JavaCast( "int", Second( THISTAG.GeneratedContent ) )
							) />
							<!--- Set date value. --->
							<cfset VARIABLES.Cell.SetCellValue(VARIABLES.Date) />
						</cfcase>

						<cfcase value="numeric">
							<!--- Set numeric value. --->
							<cfset VARIABLES.Cell.SetCellValue(JavaCast( "double", THISTAG.GeneratedContent)) />
						</cfcase>

						<cfcase value="formula">
							<!--- Check to see if this fomula has any aliases. --->
							<cfset VARIABLES.Aliases = REMatch( "@[\w_-]+", THISTAG.GeneratedContent ) />

							<!--- Loop over any aliases that we have. --->
							<cfloop index="VARIABLES.Alias" array="#VARIABLES.Aliases#">
								<!--- Check to make sure that this alias is a valid alias in our document. --->
								<cfif StructKeyExists( VARIABLES.DocumentTag.CellAliases, VARIABLES.Alias )>

									<!--- Replace the alias with the actual value. --->
									<cfset THISTAG.GeneratedContent = REReplace(
										THISTAG.GeneratedContent, "(?i)#VARIABLES.Alias#\b", VARIABLES.DocumentTag.CellAliases[ VARIABLES.Alias ], "all"
										) />
								</cfif>
							</cfloop>

							<!--- Try to set the value. If it fails, just set a string value. --->
							<cftry>
								<!--- Set numeric value. --->
								<cfset VARIABLES.Cell.SetCellFormula(JavaCast( "string", THISTAG.GeneratedContent )) />

								<!--- The formula was invalid. Set it as a string. --->
								<cfcatch>
									<!---
										Reset the cell type so that the formula does not cause
										any errors to be thrown.
									--->
									<cfset VARIABLES.Cell.SetCellType( VARIABLES.Cell.CELL_TYPE_STRING ) />

									<!--- Set string value. --->
									<cfset VARIABLES.Cell.SetCellValue(JavaCast( "string", Trim(THISTAG.GeneratedContent) )) />
								</cfcatch>
							</cftry>
						</cfcase>

						<cfcase value="image">
							<cfscript>
								ATTRIBUTES.ImageHeight = Round(ATTRIBUTES.ImageHeight);

								ATTRIBUTES.StartRow = VARIABLES.SheetTag.RowIndex + 1;
								ATTRIBUTES.EndRow = VARIABLES.SheetTag.RowIndex + ATTRIBUTES.ImageHeight;

								// Inserts Empty Rows as Placeholder for Images
								for(intRow = 0; intRow LTE ATTRIBUTES.ImageHeight; intRow++) {
									if(intRow GT 0) {
										VARIABLES.SheetTag.RowIndex++;

										VARIABLES.RowTag.Row = VARIABLES.SheetTag.Sheet.CreateRow(JavaCast( "int", (VARIABLES.SheetTag.RowIndex - 1)));
										VARIABLES.RowTag.CellIndex = 1;
									}

									VARIABLES.SheetTag.Sheet.AddMergedRegion(
										VARIABLES.javaLoader.create("org.apache.poi.hssf.util.CellRangeAddress").Init(
											JavaCast("int", (VARIABLES.SheetTag.RowIndex - 1)),
											JavaCast("int", (VARIABLES.SheetTag.RowIndex - 1)),
											JavaCast("int", (ATTRIBUTES.x1 - 1)),
											JavaCast("int", (ATTRIBUTES.x2 - 1))
										)
									);
								}
							</cfscript>
						</cfcase>

						<!--- The default case will always be the string case. --->
						<cfdefaultcase>
							<!--- Set string value. --->
							<cfset VARIABLES.Cell.SetCellValue( JavaCast("string", Trim(THISTAG.GeneratedContent)) ) />
						</cfdefaultcase>
					</cfswitch>
				<cfelse>
					<cfset VARIABLES.Cell.SetCellValue(JavaCast("string", "")) />
				</cfif>
			</cfif>

			<!---
				Now that we have the cell, we have to get a cell style object for it. Let's
				check to see if this cell is using a format that is shared by another cell.
				If so, we can just grab the existing cell format. This will help us to avoid
				the "too many fonts" problem.

				Use the current style struct as the key in our HashTable cache. (NOTE: If the
				CellStyle has not been created, our return variable will be destroyed).
			--->
			<cfset VARIABLES.CellStyle = VARIABLES.DocumentTag.CellStyles.Get(VARIABLES.Style) />
			<!---
				Check to see if the CellStyle variable still exists. If it does, then we
				successfully retrieved a cached value; if not, then we need to create a new
				CellStyle object.
			--->
			<cfif NOT StructKeyExists(VARIABLES, "CellStyle") AND intCol EQ 0>
				<!---
					This combination of CSS / formatting properties has not yet been used.
					Let's get a new cell style for this and cache it for future use.
				--->
				<cfset VARIABLES.CellStyle = VARIABLES.DocumentTag.WorkBook.CreateCellStyle() />
				<!---
					Cache the style instance (after we cache it, we can still update
					the value by reference).
				--->
				<cfset VARIABLES.DocumentTag.CellStyles.Put(VARIABLES.Style, VARIABLES.CellStyle) />

				<!--- Apply the CSS rules to the cell style. --->
				<cfset VARIABLES.CellStyle = VARIABLES.DocumentTag.CSSRule.ApplyToCellStyle(
					VARIABLES.Style,
					VARIABLES.DocumentTag.Workbook,
					VARIABLES.CellStyle
				) />

				<!--- Check to see which type of formatting we need to apply. --->
				<cfswitch expression="#ATTRIBUTES.Type#">
					<cfcase value="date">
						<!--- Use the user-defined format. --->
						<cfset VARIABLES.CellStyle.SetDataFormat(
								VARIABLES.DocumentTag.Format.getFormat(ATTRIBUTES.DateFormat)
							) />
					</cfcase>

					<cfcase value="numeric">
						<cfif ListFindNoCase("00|000|0000|00000|000000|$##,####0.00|0.000%", ATTRIBUTES.numberFormat, "|") OR
								StructKeyExists(VARIABLES.DocumentTag.NumberFormats, ATTRIBUTES.NumberFormat)>
							<cfset VARIABLES.CellStyle.setDataFormat(
								VARIABLES.DocumentTag.Format.getFormat(ATTRIBUTES.numberFormat)
								)>
						<cfelse>
							<!--- Use the user-defined format. --->
							<cfset VARIABLES.CellStyle.SetDataFormat(
								VARIABLES.DocumentTag.DataFormat.GetBuiltinFormat( JavaCast( "string", ATTRIBUTES.NumberFormat ) )
								) />
						</cfif>
					</cfcase>

					<cfcase value="formula">
						<!---
							We are going to assume that for formulas, we are going to
							use the number formatting.
						--->
						<cfset VARIABLES.CellStyle.SetDataFormat(
							VARIABLES.DocumentTag.DataFormat.GetBuiltinFormat( JavaCast("string", ATTRIBUTES.NumberFormat) )
						) />
					</cfcase>
				</cfswitch>
			</cfif>

			<!---
				ASSERT: At this point, this combination of CSS and formatting
				properties has a cell style cached in the document.
			--->
			<!---
				At this point, we have made all the cell style formatting updates
				to the cell style. Now, apply it to the cell.
			--->
			<cfset VARIABLES.Cell.SetCellStyle( VARIABLES.CellStyle ) />
		</cfloop>

		<!--- Check to see if we have more than one colspan on this cell. --->
		<cfif (ATTRIBUTES.ColSpan GT 1) AND ATTRIBUTES.RowSpan EQ 1>
			<cfset VARIABLES.SheetTag.Sheet.AddMergedRegion(
				VARIABLES.javaLoader.create("org.apache.poi.hssf.util.Region").Init(
					JavaCast( "int", (VARIABLES.SheetTag.RowIndex - 1) ),
					JavaCast( "short", (ATTRIBUTES.Index - 1) ),
					JavaCast( "int", (VARIABLES.SheetTag.RowIndex - 1) ),
					JavaCast( "short", ((ATTRIBUTES.Index - 1) + ATTRIBUTES.ColSpan - 1) )
				)
			) />
		</cfif>

		<cfif (ATTRIBUTES.RowSpan GT 1)>
			<cfset VARIABLES.SheetTag.RowSpan = {
				"StartRow" = VARIABLES.SheetTag.RowIndex,
				"EndRow" = VARIABLES.SheetTag.RowIndex + (ATTRIBUTES.RowSpan - 1),
				"StartCol" = ATTRIBUTES.Index,
				"EndCol" = ATTRIBUTES.Index + (ATTRIBUTES.ColSpan - 1),
				"CellStyle" = VARIABLES.CellStyle
			}>
		</cfif>

		<cfscript>
			ATTRIBUTES.WrapText = (
				StructKeyExists(VARIABLES.style, "white-space") AND 
				REFindNoCase("normal", VARIABLES.style['white-space']) AND 
				NOT REFindNoCase("numeric", ATTRIBUTES.type)
			);

			VARIABLES.CellStyle.setWrapText(JavaCast("boolean", ATTRIBUTES.WrapText));

			// Calculate Cell's new row height if text is wrapped
			if(!VARIABLES.SheetTag.FreezeRow OR (VARIABLES.SheetTag.FreezeRow AND VARIABLES.SheetTag.RowIndex > 1)) {
				if(VARIABLES.CellStyle.getWrapText() AND REFindNoCase("auto", VARIABLES.RowTag.attributes.height)) {
					ATTRIBUTES.JavaLoader = VARIABLES.DocumentTag.JavaLoader;

					ATTRIBUTES.ParentRow = VARIABLES.Cell.getRow();
					ATTRIBUTES.HSSFFont = VARIABLES.DocumentTag.Workbook.getFontAt(VARIABLES.Cell.getCellStyle().getFontIndex());

					ATTRIBUTES.Font = CreateObject("java", "java.awt.Font");
					ATTRIBUTES.FontName = ATTRIBUTES.HSSFFont.getFontName();
					ATTRIBUTES.FontStyle = ATTRIBUTES.Font.PLAIN;
					ATTRIBUTES.FontSize = ATTRIBUTES.HSSFFont.getFontHeightInPoints();

					if(ATTRIBUTES.HSSFFont.getBoldWeight() > 400)
						ATTRIBUTES.FontStyle += ATTRIBUTES.Font.BOLD;
					if(ATTRIBUTES.HSSFFont.getItalic())
						ATTRIBUTES.FontStyle += ATTRIBUTES.Font.ITALIC;

					ATTRIBUTES.Font = ATTRIBUTES.Font.Init(ATTRIBUTES.FontName, ATTRIBUTES.FontStyle, ATTRIBUTES.FontSize);
					ATTRIBUTES.BufferedImage = CreateObject("java", "java.awt.image.BufferedImage");

					if(StructKeyExists(VARIABLES.SheetTag.ColumnClasses[ VARIABLES.RowTag.CellIndex ], "width")) {
						if(VARIABLES.SheetTag.ColumnClasses[ VARIABLES.RowTag.CellIndex ]['width'] IS "auto") {
							VARIABLES.SheetTag.Sheet.AutoSizeColumn(JavaCast( "short", VARIABLES.RowTag.CellIndex - 1 ));
						} else {
							VARIABLES.SheetTag.Sheet.SetColumnWidth(
								JavaCast( "short", (VARIABLES.RowTag.CellIndex - 1) ),
								JavaCast( "short", Min( 32767, (Val( VARIABLES.SheetTag.ColumnClasses[VARIABLES.RowTag.CellIndex]['width'] ) * 37) ) )
							);
						}
					}

					ATTRIBUTES.ColumnWidth = Int(VARIABLES.SheetTag.Sheet.getColumnWidth(VARIABLES.RowTag.CellIndex - 1) / 37);
					ATTRIBUTES.TextWidth = ATTRIBUTES.BufferedImage
												.Init(1, 1, ATTRIBUTES.BufferedImage.TYPE_INT_ARGB)
												.getGraphics()
												.getFontMetrics(ATTRIBUTES.Font)
												.stringWidth(VARIABLES.Cell.getStringCellValue());

					// Measured in Characters
					ATTRIBUTES.LineCount = Ceiling(ATTRIBUTES.TextWidth / ATTRIBUTES.ColumnWidth) + 1;
					ATTRIBUTES.RowHeight = ATTRIBUTES.ParentRow.getHeightInPoints() * ATTRIBUTES.LineCount;

					// If the row height is adjusted each cell iteration, the row height will increase at an imcremental amount
					// To avoid this, we set VARIABLES.RowTag.height to the Max of each cell's height and we set it in the parent
					// Row's END tag.
					VARIABLES.RowTag.height = Max(VARIABLES.RowTag.height, ATTRIBUTES.RowHeight);

				}
			}
		</cfscript>

		<!--- Update the cell count. --->
		<cfset VARIABLES.RowTag.CellIndex += ATTRIBUTES.ColSpan />

		<!---
			Eliminate the GenerateContent Output from the Custom Tag
			(To help with file buffer by eliminating request output)
		--->
		<cfset THISTAG.GeneratedContent = "">
	</cfcase>
</cfswitch>