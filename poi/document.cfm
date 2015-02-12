<cfsetting showDebugOutput="false">
<cfsilent>
	<!--- Check to see which version of the tag we are executing. --->
	<!-------------------------------->
	<!--- POI Document *START* Tag --->
	<!-------------------------------->
	<cfswitch expression="#THISTAG.ExecutionMode#">
		<cfcase value="Start">
			<cfscript>
				/*---------------------------------*/
				/*--- Param the tag attributes. ---*/
				/*---------------------------------*/
				// The CALLER-scoped variable into which the Excel binary will be stored. 
				// If this is used, a Java ByteArrayOutputStream will be used to hold the final document value.
				param name="ATTRIBUTES.Name" type="string" default="";
				// The Expanded file path at which the Excel file will be saved.
				// This can be used in conjunction with the Name value.
				param name="ATTRIBUTES.File" type="string" default="";
				// The Expanded file path of the template to be used. We will not write to this template, 
				// but rather create a copy of it for our base document.
				param name="ATTRIBUTES.Template" type="string" default="";
				// This is the default style that will be applied as the base format for each cell in the workbook.
				param name="ATTRIBUTES.Style" type="string" default="";
				// Excel Export File Name
				param name="ATTRIBUTES.FileName" type="string" default="ExcelExport.xls";
				// Number of Sheets for Download Progress Bar
				param name="ATTRIBUTES.NumberOfSheets" type="string" default="1";
				// Use File Storage (The path to the directory needs to be passed in!)
				// NOTE: If when this method parameter is set, the POI module will NOT spit the file back out through a CFContent!!
				param name="ATTRIBUTES.WriteTo" type="string" default="";

				// JavaLoader Java Library Server Cache Mapping
				VARIABLES.JavaLoader = SERVER[APPLICATION.javaLoaderKey];
				VARIABLES.Images = [];

				ExportDirectory = Replace(ExpandPath("/#APPLICATION.applicationName#/usmc_excel/exports/"), "/", "\", "All");

				if(NOT DirectoryExists(ExportDirectory)) {
					DirectoryCreate(ExportDirectory);
				}

				if(NOT Len(ATTRIBUTES.File)) {
					ATTRIBUTES.File = ExportDirectory & ATTRIBUTES.FileName;
				}

				// Make sure that we have the proper attributes.
				if(NOT IsValid( "variablename", ATTRIBUTES.Name)) {
					// Throw attribute validation error. --->
					Throw(type="Document.InvalidAttributes" message="Invalid attributes on the Document tag." detail="The DOCUMENT tag requires either a NAME and/or FILE attribute.");
				}

				// Create the Excel workbook to which we will be writing. Check to see if we 
				// are creating a totally new workbook, or if we want to use an existing template.
				if(Len(ATTRIBUTES.Template)) {
					//Read in existing workbook.
					VARIABLES.WorkBook = VARIABLES.JavaLoader
						.Create("org.apache.poi.hssf.usermodel.HSSFWorkbook")
						.Create(VARIABLES.JavaLoader.Create("java.io.FileInputStream")
						.Init(JavaCast("string", ATTRIBUTES.Template)));
				} else {
					// Create a new workbook.
					VARIABLES.WorkBook = VARIABLES.JavaLoader.Create("org.apache.poi.hssf.usermodel.HSSFWorkbook" ).Init();
				}

				// Create a data formatter utility object (we will need this to get the formatting index later on when we set the cell styles).
				VARIABLES.DataFormat = VARIABLES.JavaLoader.Create("org.apache.poi.hssf.usermodel.HSSFDataFormat");
				VARIABLES.Format = VARIABLES.WorkBook.getCreationHelper().CreateDataFormat();

				/*---------------------------*/
				/*---- POI Number Formats ---*/
				/*---------------------------*/
				// Create an index of available number formats.
				VARIABLES.NumberFormats = {};
				VARIABLES.NumberFormats[ "General" ] = true;
				VARIABLES.NumberFormats[ "0" ] = true;
				VARIABLES.NumberFormats[ "00" ] = true;
				VARIABLES.NumberFormats[ "000" ] = true;
				VARIABLES.NumberFormats[ "0000" ] = true;
				VARIABLES.NumberFormats[ "00000" ] = true;
				VARIABLES.NumberFormats[ "000000" ] = true;
				VARIABLES.NumberFormats[ "0.00" ] = true;
				VARIABLES.NumberFormats[ "##,####0" ] = true;
				VARIABLES.NumberFormats[ "##,####0.00" ] = true;
				VARIABLES.NumberFormats[ "##,####0.000" ] = true;
				VARIABLES.NumberFormats[ "$##,####0_);($##,####0)" ] = true;
				VARIABLES.NumberFormats[ "##,####0.000_);[Red](##,####0.000)" ] = true;
				VARIABLES.NumberFormats[ "($##,####0_);[Red]($##,####0)" ] = true;
				VARIABLES.NumberFormats[ "($##,####0.00);($##,####0.00)" ] = true;
				VARIABLES.NumberFormats[ "($##,####0.00_);[Red]($##,####0.00)" ] = true;
				VARIABLES.NumberFormats[ "(##,####0.000_);[Red](##,####0.000)" ] = true;
				VARIABLES.NumberFormats[ "0%" ] = true;
				VARIABLES.NumberFormats[ "0.0%" ] = true;
				VARIABLES.NumberFormats[ "0.00%" ] = true;
				VARIABLES.NumberFormats[ "0.000%" ] = true;
				VARIABLES.NumberFormats[ "0.00E+00" ] = true;
				VARIABLES.NumberFormats[ "## ?/?" ] = true;
				VARIABLES.NumberFormats[ "## ??/??" ] = true;
				VARIABLES.NumberFormats[ "(##,####0_);[Red](##,####0)" ] = true;
				VARIABLES.NumberFormats[ "(##,####0.00_);(##,####0.00)" ] = true;
				VARIABLES.NumberFormats[ "(##,####0.00_);[Red](##,####0.00)" ] = true;
				VARIABLES.NumberFormats[ "_(*##,####0_);_(*(##,####0);_(* \""-\""_);_(@_)" ] = true;
				VARIABLES.NumberFormats[ "_($*##,####0_);_($*(##,####0);_($* \""-\""_);_(@_)" ] = true;
				VARIABLES.NumberFormats[ "_(*##,####0.00_);_(*(##,####0.00);_(*\""-\""??_);_(@_)" ] = true;
				VARIABLES.NumberFormats[ "_($*##,####0.00_);_($*(##,####0.00);_($*\""-\""??_);_(@_)" ] = true;
				VARIABLES.NumberFormats[ "####0.0E+0" ] = true;
				VARIABLES.NumberFormats[ "@" ] = true; 																// This is text format.
				VARIABLES.NumberFormats[ "text" ] = true; 															// Alias for "@"

				/*-------------------------*/
				/*---- POI Date Formats ---*/
				/*-------------------------*/
				// Create an index of avilable date formates.
				VARIABLES.DateFormats = {};
				VARIABLES.DateFormats[ "General" ] = true;
				VARIABLES.DateFormats[ "yyyy" ] = true;
				VARIABLES.DateFormats[ "m/d/yy" ] = true;
				VARIABLES.DateFormats[ "d-mmm-yy" ] = true;
				VARIABLES.DateFormats[ "d-mmm" ] = true;
				VARIABLES.DateFormats[ "mmm-yy" ] = true;
				VARIABLES.DateFormats[ "h:mm AM/PM" ] = true;
				VARIABLES.DateFormats[ "h:mm:ss AM/PM" ] = true;
				VARIABLES.DateFormats[ "h:mm" ] = true;
				VARIABLES.DateFormats[ "h:mm:ss" ] = true;
				VARIABLES.DateFormats[ "m/d/yy h:mm" ] = true;
				VARIABLES.DateFormats[ "mm:ss" ] = true;
				VARIABLES.DateFormats[ "[h]:mm:ss" ] = true;
				VARIABLES.DateFormats[ "mm:ss.0" ] = true;

				// Create an index for the column look up. We will need this when defining the cell aliases in forumlas.
				VARIABLES.ColumnLookup = ListToArray( "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z" );
				// Create a structure for storing cell aliases.
				VARIABLES.CellAliases = {};

				// Create a instance of the utiltiy object, CSSRule. This will be use used by this tag and its child tags 
				// to parse CSS as well as manipulate it.
				VARIABLES.CSSRule = CreateObject("component", "CSSRule").Init();

				// Create a struct to hold the CSS classes by name. These classes will be the Structures holding the basic css properties.
				VARIABLES.Classes = StructNew();
				VARIABLES.intClasses = 0;

				// Create default CSS classes for the different cells.
				VARIABLES.Classes[ "@cell" ] = VARIABLES.CSSRule.AddCSS(StructNew(), ATTRIBUTES.Style);

				// Create a cache of cell format objects (Java objects use in the POI cell formatting). This is done to get around the 
				// "too many fonts" issue that is caused with larger documents. We are going to be using the "style" struct to cache the 
				// Java style sobjects in a Java Hashtable. 
				VARIABLES.CellStyles = VARIABLES.JavaLoader.Create("java.util.Hashtable").Init();

				// Create a variable for the current sheet index. This will become important when we are using an existing template rather than
				// creating a new workbook from scratch. This contains the VALUE OF THE CURRENT SHEET.
				VARIABLES.SheetIndex = 1;
			</cfscript>
		</cfcase>

		<!-------------------------------->
		<!--- POI Document *END* Tag --->
		<!-------------------------------->
		<cfcase value="End">
			<cfscript>
				// At this point, we have created our Excel document. Now, we need to write it to the output variable(s). 
				// Check to see if we have a file name to write to.
				if(Len(ATTRIBUTES.File)) {
					// Create the file output stream.
					VARIABLES.FileOutputStream = VARIABLES.JavaLoader.Create("java.io.FileOutputStream").Init(JavaCast( "string", ATTRIBUTES.File ));
					// Write the Excel workbook contents to the output stream.
					VARIABLES.WorkBook.Write(VARIABLES.FileOutputStream);

					// Close the file output stream to make sure that all locks on the file are released.
					VARIABLES.FileOutputStream.Close();
				}

				// Check to add images in using CFSpreadsheet if needed. Long story short, CFSpreadsheet is used because Batik 
				// is already by default loaded into Coldfusion and if we use the new POI to generate the chart image, a 
				// parentLoader conflict will occur and the image basically won't get generated. 
				// To avoid this, we just use the parent's Batik class instead of the one we dynamically load in.
				if(StructKeyExists(VARIABLES, "images") AND ArrayLen(VARIABLES.images)) {
					intImage = 0;
					SpreadsheetObject = SpreadsheetRead(ATTRIBUTES.File);

					for(Image IN VARIABLES.Images) {
						intImage++;
						SpreadsheetSetActiveSheet(SpreadsheetObject, Image.SheetName);
						Image.Anchor = "#image.StartRow#,#image.StartCol#,#image.EndRow#,#image.EndCol#";
						SpreadsheetAddImage(SpreadsheetObject, Image.FilePath, Image.Anchor);
					}

					SpreadsheetWrite(SpreadsheetObject, ATTRIBUTES.File, true);
				}
			</cfscript>

			<cfif Len(ATTRIBUTES.WriteTo) AND DirectoryExists(ATTRIBUTES.WriteTo)>
				<cfscript>
					ATTRIBUTES.File = ListAppend(ATTRIBUTES.WriteTo, ATTRIBUTES.Filename, "/");
					VARIABLES.WorkBook = VARIABLES.JavaLoader
						.Create("org.apache.poi.hssf.usermodel.HSSFWorkbook")
						.Init(
							VARIABLES.JavaLoader
								.Create("java.io.FileInputStream")
								.Init( JavaCast("string", ATTRIBUTES.File) )
						);
				</cfscript>
			<cfelse>
				<cfscript>
					// Check to see if we have a variable to return the workbook to.
					if(Len(ATTRIBUTES.Name)) {
						VARIABLES.WorkBook = VARIABLES.JavaLoader
							.Create("org.apache.poi.hssf.usermodel.HSSFWorkbook")
							.Init(
								VARIABLES.JavaLoader
									.Create("java.io.FileInputStream")
									.Init( JavaCast("string", ATTRIBUTES.File) )
							);

						// Create the byte array output stream so that we can write the binary contents to a RAM-stored array.
						VARIABLES.ByteArrayOutputStream = VARIABLES.JavaLoader.Create("java.io.ByteArrayOutputStream").Init();

						// Write the Excel workbook contents to the output stream.
						VARIABLES.WorkBook.Write(VARIABLES.ByteArrayOutputStream);

						ATTRIBUTES.name = REREplace(ATTRIBUTES.Name, "\&|\,|\'|\\|\/", "", "All");

						// Store the byte array into the CALLER-scoped variable.
						CALLER[ATTRIBUTES.Name] = VARIABLES.ByteArrayOutputStream;

						FileDelete(ATTRIBUTES.File);
					}

					tmpExcel = CALLER[ATTRIBUTES.Name];

					// Before we return out, we want to make sure to clear out any generated content produced by the tag.
					THISTAG.GeneratedContent = "";
					ATTRIBUTES.name = REREplace(ATTRIBUTES.Name, "\&|\,|\'|\\|\/", "", "All");

					// Store the byte array into the CALLER-scoped variable.
					CALLER[ATTRIBUTES.Name] = VARIABLES.ByteArrayOutputStream;

					tmpExcel = CALLER[ATTRIBUTES.Name];
					
					// Before we return out, we want to make sure to clear out any generated content produced by the tag.
					SESSION.progressDownload = 100;
					THISTAG.GeneratedContent = "";
				</cfscript>

				<cfheader name="Set-Cookie" value="usmcFileExport=true; path=/">
				<cfheader name="content-disposition" value="attachment; filename=#ATTRIBUTES.fileName#">
				<cfheader name="content-length" value="#tmpExcel.Size()#">
				<cfcontent type="application/msexcel" variable="#tmpExcel.ToByteArray()#">
			</cfif>
		</cfcase>
	</cfswitch>
</cfsilent>