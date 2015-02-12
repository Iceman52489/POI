<cfcomponent hint="Handles CSS utility functions.">
	<cfset VARIABLES.JavaLoader = SERVER[APPLICATION.javaLoaderKey]>
	<!---
		Set up the default CSS properties for this rule. This will
		be used to create other hash maps.
	--->
	<cfset VARIABLES.CSS = {} />
	<cfset VARIABLES.CSS["background-attachment"] = "" />
	<cfset VARIABLES.CSS["background-color"] = "" />
	<cfset VARIABLES.CSS["background-image"] = "" />
	<cfset VARIABLES.CSS["background-position"] = "" />
	<cfset VARIABLES.CSS["background-repeat"] = "" />
	<cfset VARIABLES.CSS["border-top-width"] = "" />
	<cfset VARIABLES.CSS["border-top-color"] = "" />
	<cfset VARIABLES.CSS["border-top-style"] = "" />
	<cfset VARIABLES.CSS["border-right-width"] = "" />
	<cfset VARIABLES.CSS["border-right-color"] = "" />
	<cfset VARIABLES.CSS["border-right-style"] = "" />
	<cfset VARIABLES.CSS["border-bottom-width"] = "" />
	<cfset VARIABLES.CSS["border-bottom-color"] = "" />
	<cfset VARIABLES.CSS["border-bottom-style"] = "" />
	<cfset VARIABLES.CSS["border-left-width"] = "" />
	<cfset VARIABLES.CSS["border-left-color"] = "" />
	<cfset VARIABLES.CSS["border-left-style"] = "" />
	<cfset VARIABLES.CSS["bottom"] = "" />
	<cfset VARIABLES.CSS["color"] = "" />
	<cfset VARIABLES.CSS["display"] = "" />
	<cfset VARIABLES.CSS["font-family"] = "" />
	<cfset VARIABLES.CSS["font-size"] = "" />
	<cfset VARIABLES.CSS["font-style"] = "" />
	<cfset VARIABLES.CSS["font-weight"] = "" />
	<cfset VARIABLES.CSS["height"] = "" />
	<cfset VARIABLES.CSS["left"] = "" />
	<cfset VARIABLES.CSS["list-style-image"] = "" />
	<cfset VARIABLES.CSS["list-style-position"] = "" />
	<cfset VARIABLES.CSS["list-style-type"] = "" />
	<cfset VARIABLES.CSS["margin-top"] = "" />
	<cfset VARIABLES.CSS["margin-right"] = "" />
	<cfset VARIABLES.CSS["margin-bottom"] = "" />
	<cfset VARIABLES.CSS["margin-left"] = "" />
	<cfset VARIABLES.CSS["padding-top"] = "" />
	<cfset VARIABLES.CSS["padding-right"] = "" />
	<cfset VARIABLES.CSS["padding-bottom"] = "" />
	<cfset VARIABLES.CSS["padding-left"] = "" />
	<cfset VARIABLES.CSS["position"] = "" />
	<cfset VARIABLES.CSS["right"] = "" />
	<cfset VARIABLES.CSS["text-align"] = "" />
	<cfset VARIABLES.CSS["text-decoration"] = "" />
	<cfset VARIABLES.CSS["top"] = "" />
	<cfset VARIABLES.CSS["vertical-align"] = "" />
	<cfset VARIABLES.CSS["white-space"] = "" />
	<cfset VARIABLES.CSS["width"] = "" />
	<cfset VARIABLES.CSS["z-index"] = "" />

	<!---
		Set up the validation rules for the CSS properties. Each
		property must fit in a certain format. These formats
		will be defined using regular expressions and will be
		used to match the entire value (no partial matching).
	--->
	<cfset VARIABLES.CSSValidation = {} />
	<cfset VARIABLES.CSSValidation["background-attachment"] = "scroll|fixed" />
	<cfset VARIABLES.CSSValidation["background-color"] = "\w+|##[0-9ABCDEF]{6}" />
	<cfset VARIABLES.CSSValidation["background-image"] = "url\([^\)]+\)" />
	<cfset VARIABLES.CSSValidation["background-position"] = "(top|right|bottom|left|\d+(\.\d+)?(px|%|em)) (top|right|bottom|left|\d+(\.\d+)?(px|%|em))" />
	<cfset VARIABLES.CSSValidation["background-repeat"] = "(no-)?repeat(-x|-y)?" />
	<cfset VARIABLES.CSSValidation["border-top-width"] = "\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation["border-top-color"] = "\w+|##[0-9ABCDEF]{6}" />
	<cfset VARIABLES.CSSValidation["border-top-style"] = "none|dotted|dashed|solid|double|groove" />
	<cfset VARIABLES.CSSValidation["border-right-width"] = "\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation["border-right-color"] = "\w+|##[0-9ABCDEF]{6}" />
	<cfset VARIABLES.CSSValidation["border-right-style"] = "none|dotted|dashed|solid|double|groove" />
	<cfset VARIABLES.CSSValidation["border-bottom-width"] = "\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation["border-bottom-color"] = "\w+|##[0-9ABCDEF]{6}" />
	<cfset VARIABLES.CSSValidation["border-bottom-style"] = "none|dotted|dashed|solid|double|groove" />
	<cfset VARIABLES.CSSValidation["border-left-width"] = "\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation["border-left-color"] = "\w+|##[0-9ABCDEF]{6}" />
	<cfset VARIABLES.CSSValidation["border-left-style"] = "none|dotted|dashed|solid|double|groove" />
	<cfset VARIABLES.CSSValidation["bottom"] = "-?\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation["color"] = "\w+|##[0-9ABCDEF]{6}" />
	<cfset VARIABLES.CSSValidation["display"] = "inline|block|block" />
	<cfset VARIABLES.CSSValidation["font-family"] = "((\w+|""[^""]""+)(\s*,\s*)?)+" />
	<cfset VARIABLES.CSSValidation["font-size"] = "\d+(\.\d+)?(px|pt|em|%)" />
	<cfset VARIABLES.CSSValidation["font-style"] = "normal|italic" />
	<cfset VARIABLES.CSSValidation["font-weight"] = "normal|lighter|bold|bolder|[1-9]00" />
	<cfset VARIABLES.CSSValidation["height"] = "\d+(\.\d+)?(px|pt|em|%)" />
	<cfset VARIABLES.CSSValidation["left"] = "-?\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation["list-style-image"] = "none|url\([^\)]+\)" />
	<cfset VARIABLES.CSSValidation["list-style-position"] = "inside|outside" />
	<cfset VARIABLES.CSSValidation["list-style-type"] = "disc|circle|square|none" />
	<cfset VARIABLES.CSSValidation["margin-top"] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation["margin-right"] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation["margin-bottom"] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation["margin-left"] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation["padding-top"] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation["padding-right"] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation["padding-bottom"] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation["padding-left"] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation["position"] = "static|relative|absolute|fixed" />
	<cfset VARIABLES.CSSValidation["right"] = "-?\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation["text-align"] = "left|right|center|justify" />
	<cfset VARIABLES.CSSValidation["text-decoration"] = "none|underline|overline|line-through" />
	<cfset VARIABLES.CSSValidation["top"] = "-?\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation["vertical-align"] = "bottom|middle|top" />
	<cfset VARIABLES.CSSValidation["white-space"] = "normal|pre|nowrap" />
	<cfset VARIABLES.CSSValidation["width"] = "\d+(\.\d+)?(px|pt|em|%)|auto" />
	<cfset VARIABLES.CSSValidation["z-index"] = "\d+" />

	<!--- Here is an array of the alpha-sorted keys. --->
	<cfset VARIABLES.SortedPropertyKeys = StructKeyArray( VARIABLES.CSS ) />

	<!--- Sort the keys alphabetically. --->
	<cfset ArraySort( VARIABLES.SortedPropertyKeys, "textnocase", "asc" ) />

	<!---
		This is going to be a cached value of CSS strings. I am doing this
		because if someone has a "style" inside of a large loop, I don't want
		to be re-parsing that every single time.
	--->
	<cfset VARIABLES.CSSCache = {} />

	<!--- Create a struct of valid colors. --->
	<cfset VARIABLES.POIColors = {
		AQUA = true,
		BLACK = true,
		BLUE = true,
		BLUE_GREY = true,
		BRIGHT_GREEN = true,
		BROWN = true,
		CORAL = true,
		CORNFLOWER_BLUE = true,
		DARK_BLUE = true,
		DARK_GREEN = true,
		DARK_RED = true,
		DARK_TEAL = true,
		DARK_YELLOW = true,
		GOLD = true,
		GREEN = true,
		GREY_25_PERCENT = true,
		GREY_40_PERCENT = true,
		GREY_50_PERCENT = true,
		GREY_80_PERCENT = true,
		INDIGO = true,
		LAVENDER = true,
		LEMON_CHIFFON = true,
		LIGHT_BLUE = true,
		LIGHT_CORNFLOWER_BLUE = true,
		LIGHT_GREEN = true,
		LIGHT_ORANGE = true,
		LIGHT_TURQUOISE = true,
		LIGHT_YELLOW = true,
		LIME = true,
		MAROON = true,
		OLIVE_GREEN = true,
		ORANGE = true,
		ORCHID = true,
		PALE_BLUE = true,
		PINK = true,
		PLUM = true,
		RED = true,
		ROSE = true,
		ROYAL_BLUE = true,
		SEA_GREEN = true,
		SKY_BLUE = true,
		TAN = true,
		TEAL = true,
		TURQUOISE = true,
		VIOLET = true,
		WHITE = true,
		YELLOW = true,
		CUSTOM = {}
	} />

	<cffunction name="Init" access="public" returntype="any" output="false" hint="Returns an initialized component.">
		<!--- Return THIS reference. --->
		<cfreturn THIS />
	</cffunction>

	<cffunction name="AddCSS" access="public" returntype="struct" hint="Adds CSS properties to passed-in css hash map returns it.">
		<!--- Define arguments. --->
		<cfargument name="PropertyMap" type="struct" required="true" hint="I am the CSS hash map being updated." />
		<cfargument name="CSS" type="string" required="true" hint="CSS properties for to be added to the given map (may have multiple properties separated by semi-colons)." />
		<cfscript>
			// Set up local scope.
			var LOCAL = {};

			// Check to see if this CSS string has already been cached. If not,
			// then we want to cache it locally first, then add it to the struct.
			if( NOT StructKeyExists( VARIABLES.CSSCache, ARGUMENTS.CSS ) ) {
				// Create a local property map.
				LOCAL.CachedPropertyMap = {};

				// Loop over the list of properties passed in.
				for( LOCAL.Property IN ListToArray(ARGUMENTS.CSS, ";") ) {
					// Add this property to the css map.
					THIS.AddProperty( LOCAL.CachedPropertyMap, Trim( LOCAL.Property ) );
				}

				// Cache this property map.
				VARIABLES.CSSCache[ARGUMENTS.CSS] = LOCAL.CachedPropertyMap;
			}

			// ASSERT: At this point, we know that no matter what CSS string was
			// passed-in, we now have a version of it parsed and stored in the cache.

			//  Add the cached property map.
			ARGUMENTS.PropertyMap.putAll( VARIABLES.CSSCache[ARGUMENTS.CSS] );

			// Return the updated map.
			return ARGUMENTS.PropertyMap;
		</cfscript>
	</cffunction>

	<cffunction name="AddProperty" access="public" returntype="boolean" output="false" hint="Parses the given property and adds it to the given CSS property map.">
		<!--- Define arguments. --->
		<cfargument name="PropertyMap" type="struct" required="true" hint="I am the CSS hash map being updated." />
		<cfargument name="Property" type="string" required="true" hint="The name-value pair property that will be added to the CSS rule." />
		<cfscript>
			// Set up local scope.
			var LOCAL = {};

			// The property should be in name=value pair format. Break up the property into the two parts.
			// Also, make sure that we only have one property being set (as delimited by ";").
			LOCAL.Pair = ListToArray( Trim( ListFirst( ARGUMENTS.Property , ";" ) ), ":" );

			// Check to see if we have two parts. If we have anything but two parts,
			// then this is not a valid name-value pair.
			if(ArrayLen( LOCAL.Pair ) EQ 2) {
				// Trim both parts of the pair.
				LOCAL.Name = Trim( LOCAL.Pair[1] );
				LOCAL.Value = Trim( LOCAL.Pair[2] );

				// When it comes to parsing the property, they might be using a simple one that we have.
				// If not, we have to get a little more creative with the parsing.
				if( THIS.IsValidValue( LOCAL.Name, LOCAL.Value ) ) {
					// This value has validated. Add it to the CSS properties.
					ARGUMENTS.PropertyMap[LOCAL.Name] = LOCAL.Value;

					// Return true for success.
					return true;
				} else {
					// We were not given a simple value; we were given a value that
					// we will have to parse out into the individual properties.
					Switch(LOCAL.Name) {
						case "background":
							THIS.SetBackground( ARGUMENTS.PropertyMap, LOCAL.Value );
							break;

						case "border":
						case "border-top":
						case "border-right":
						case "border-bottom":
						case "border-left":
							THIS.SetBorder( ARGUMENTS.PropertyMap, LOCAL.Name, LOCAL.Value );
							break;

						case "font":
							THIS.SetFont( ARGUMENTS.PropertyMap, LOCAL.Value );
							break;

						case "list-style":
							THIS.SetListStyle( ARGUMENTS.PropertyMap, LOCAL.Value );
							break;

						case "margin":
							THIS.SetMargin( ARGUMENTS.PropertyMap, LOCAL.Value );
							break;

						case "padding":
							THIS.SetPadding( ARGUMENTS.PropertyMap, LOCAL.Value );
							break;
					}
				}
			}

			// Return out. If we made it this far, then we didn't add a valid property.
			return false;
		</cfscript>
	</cffunction>

	<cffunction name="ApplyToCellStyle" access="public" returntype="any" output="false" hint="Applies the current CSS property map to the given HSSFCellStyle object.">
		<!--- Define arguments. --->
		<cfargument name="PropertyMap" type="struct" required="true" hint="I am the CSS hash map being updated." />
		<cfargument name="Workbook" type="any" required="true" hint="The workbook containing this cell style." />
		<cfargument name="CellStyle" type="any" required="true" hint="The HSSFCellStyle instance to which we are applying the CSS property rules." />

		<!--- Define the local scope. --->
		<cfscript>
			var LOCAL = {};
				LOCAL.HSSFPalette = ARGUMENTS.WorkBook.getCustomPalette();

			// Loop through CSS Properties and create new Colors as needed
			if( FindNoCase("color", StructKeyList(ARGUMENTS.PropertyMap)) ) {
				for(ARGUMENTS.PropertyKey IN ARGUMENTS.PropertyMap) {
					if( FindNoCase("color", ARGUMENTS.PropertyKey) AND FindNoCase("##", ARGUMENTS.PropertyMap[ARGUMENTS.PropertyKey] ) ) {
						LOCAL.ColorBytes = HexToByteArray(ARGUMENTS.PropertyMap[ARGUMENTS.PropertyKey]);

						LOCAL.HSSFColorName = REReplace( ARGUMENTS.PropertyMap[ARGUMENTS.PropertyKey], "##", "" );
						LOCAL.HSSFColorValue = LOCAL.HSSFPalette.findSimilarColor(
							LOCAL.ColorBytes[1],
							LOCAL.ColorBytes[2],
							LOCAL.ColorBytes[3]
						);

						VARIABLES.POIColors.Custom[LOCAL.HSSFColorName] = LOCAL.HSSFColorValue;
					}
				}
			}

			// Create a local copy of the full CSS definition. --->
			LOCAL.PropertyMap = StructCopy( VARIABLES.CSS );

			// Now, append the passed in property map to this local one. That will give
			// us a full CSS property map with only the relatvant values filled in.
			LOCAL.PropertyMap.putAll( ARGUMENTS.PropertyMap );
			// Get a new font object from the workbook. --->
			LOCAL.Font = ARGUMENTS.WorkBook.CreateFont();
			// Check to see if we have an appropriate background color; Excel won't
			// just use any color - it has to be one of their index colors.

			if(	Len( LOCAL.PropertyMap["background-color"] ) AND (
					StructKeyExists( VARIABLES.POIColors, LOCAL.PropertyMap["background-color"] ) OR
					StructKeyExists( VARIABLES.POIColors.Custom, ReplaceNoCase(LOCAL.PropertyMap["background-color"], "##", "", "All") ) )) {

				LOCAL.CellColorKey = UCase(ReplaceNoCase(LOCAL.PropertyMap["background-color"], "##", "", "All"));
				LOCAL.HSSFColor = StructKeyExists( VARIABLES.POIColors.Custom, LOCAL.CellColorKey) ?
					VARIABLES.POIColors.Custom[LOCAL.CellColorKey].getIndex() :
					VARIABLES.JavaLoader.Create("org.apache.poi.hssf.util.HSSFColor$#LOCAL.CellColorKey#").GetIndex();

				// Set the foreground color using the background color. We will need to create
				// an instance of the HSSFColor inner class to get the index value of the color.
				ARGUMENTS.CellStyle.SetFillForegroundColor( LOCAL.HSSFColor );

				// Set a solid background fill. --->
				ARGUMENTS.CellStyle.SetFillPattern( ARGUMENTS.CellStyle.SOLID_FOREGROUND );
			} else if(LOCAL.PropertyMap["background-color"] EQ "transparent") {
				// The user has requested no background color.
				ARGUMENTS.CellStyle.SetFillPattern( ARGUMENTS.CellStyle.NO_FILL );
			}

			// Loop over the four border directions.
			for(LOCAL.BorderSide IN ListToArray("top,right,bottom,left")) {
				// Check to see if there is a width.
				if( Len( LOCAL.PropertyMap["border-#LOCAL.BorderSide#-width"] ) ) {
					// Check for the style.
					Switch(LOCAL.PropertyMap['border-#LOCAL.BorderSide#-style']) {
						case "dotted":
							Switch( Val( LOCAL.PropertyMap['border-#LOCAL.BorderSide#-width'] ) ) {
								case 0:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_NONE;
									break;
								case 1:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_DOTTED;
									break;
								case 2:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_DASH_DOT_DOT;
									break;
								default:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_MEDIUM_DASH_DOT_DOT;
							}
							break;
						case "dashed":
							Switch( Val( LOCAL.PropertyMap['border-#LOCAL.BorderSide#-width'] ) ) {
								case 0:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_NONE;
									break;
								case 1:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_DASHED;
									break;
								default:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_MEDIUM_DASHED;
							}
							break;
						case "double":
							Switch( Val( LOCAL.PropertyMap['border-#LOCAL.BorderSide#-width'] ) ) {
								case 0:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_NONE;
									break;
								default:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_DOUBLE;
							}
							break;
						// Default to solid border.
						default:
							Switch( Val( LOCAL.PropertyMap['border-#LOCAL.BorderSide#-width'] ) ) {
								case 0:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_NONE;
									break;
								case 1:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_HAIR;
									break;
								case 2:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_THIN;
									break;
								case 3:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_MEDIUM;
									break;
								default:
									LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_THICK;
							}
					}

					LOCAL.CellColorKey = "BLACK";

					// Check to see if we have a border color.
					if( Len( LOCAL.PropertyMap["border-#LOCAL.BorderSide#-color"] ) ) {
						LOCAL.CellColorKey = UCase( Replace( LOCAL.PropertyMap["border-#LOCAL.BorderSide#-color"], "##", "", "All" ) );

						if( StructKeyExists(VARIABLES.POIColors, LOCAL.PropertyMap["border-#LOCAL.BorderSide#-color"]) )
							LOCAL.BorderColor = VARIABLES.JavaLoader.Create("org.apache.poi.hssf.util.HSSFColor$#LOCAL.CellColorKey#").GetIndex();
						else if( StructKeyExists(VARIABLES.POIColors.Custom, LOCAL.CellColorKey) )
							LOCAL.BorderColor = VARIABLES.POIColors.Custom[LOCAL.CellColorKey].getIndex();

					}

					// Check to see which direction we are working width. --->
					Switch(LOCAL.BorderSide) {
						case "top":
							// Set border style.
							ARGUMENTS.CellStyle.SetBorderTop( LOCAL.BorderStyle );
							// Set border color.
							ARGUMENTS.CellStyle.SetTopBorderColor( LOCAL.BorderColor );
							break;
						case "right":
							// Set border style.
							ARGUMENTS.CellStyle.SetBorderRight( LOCAL.BorderStyle );
							// Set border color.
							ARGUMENTS.CellStyle.SetRightBorderColor( LOCAL.BorderColor );
							break;
						case "bottom":
							// Set border style.
							ARGUMENTS.CellStyle.SetBorderBottom( LOCAL.BorderStyle );
							// Set border color.
							ARGUMENTS.CellStyle.SetBottomBorderColor( LOCAL.BorderColor );
							break;
						case "left":
							// Set border style.
							ARGUMENTS.CellStyle.SetBorderLeft( LOCAL.BorderStyle );
							// Set border color.
							ARGUMENTS.CellStyle.SetLeftBorderColor( LOCAL.BorderColor );
							break;
					}
				}
			}

			// Check to see if we have an appropriate text color; Excel won't
			// just use any color - it has to be one of their index colors.

			// Edited by Kevin Chiu - POI HSSF Will Take any 8 bit color. XSSF accepts 32 bit colors
			// POI Extension has been updated to allow this feature
			LOCAL.CellColorKey = UCase(Replace(LOCAL.PropertyMap["color"], "##", "", "All"));

			if( Len(LOCAL.CellColorKey) AND (
					StructKeyExists(VARIABLES.POIColors, LOCAL.CellColorKey) OR
					StructKeyExists(VARIABLES.POIColors.Custom, LOCAL.CellColorKey) ) ) {

				// Set the font color.
				LOCAL.HSSFColor = StructKeyExists(VARIABLES.POIColors, LOCAL.CellColorKey) ?
					VARIABLES.JavaLoader.Create("org.apache.poi.hssf.util.HSSFColor$#LOCAL.CellColorKey#").GetIndex() :
					VARIABLES.POIColors.Custom[LOCAL.CellColorKey];

				LOCAL.Font.SetColor( LOCAL.HSSFColor );
			}

			// Check for font family.
			if( Len( LOCAL.PropertyMap["font-family"] ) ) {
				LOCAL.Font.SetFontName(JavaCast( "string", LOCAL.PropertyMap["font-family"] ) );
			}

			// Check for font style.
			Switch(LOCAL.PropertyMap['font-style'] ) {
				case "italic":
					LOCAL.Font.SetItalic( JavaCast( "boolean", true ) );
					break;
			}

			// Check for font weight.
			Switch(LOCAL.PropertyMap['font-weight']) {
				case "bold":
				case "600":
				case "700":
				case "800":
				case "900":
					LOCAL.Font.SetBoldWeight( LOCAL.Font.BOLDWEIGHT_BOLD );
					break;
				case "normal":
				case "100":
				case "200":
				case "300":
				case "400":
				case "500":
					LOCAL.Font.SetBoldWeight( LOCAL.Font.BOLDWEIGHT_NORMAL );
					break;
			}

			// Check for font size.
			if( Val( LOCAL.PropertyMap["font-size"] ) ) {
				LOCAL.Font.SetFontHeightInPoints(JavaCast( "int", Val( LOCAL.PropertyMap["font-size"] ) ) );
			}

			// Check to see if we have any text alignment.
			Switch( LOCAL.PropertyMap['text-align'] ) {
				case "right":
					ARGUMENTS.CellStyle.SetAlignment( ARGUMENTS.CellStyle.ALIGN_RIGHT );
					break;
				case "center":
					ARGUMENTS.CellStyle.SetAlignment( ARGUMENTS.CellStyle.ALIGN_CENTER );
					break;
				case "justify":
					ARGUMENTS.CellStyle.SetAlignment( ARGUMENTS.CellStyle.ALIGN_JUSTIFY );
					break;
				case "left":
					ARGUMENTS.CellStyle.SetAlignment( ARGUMENTS.CellStyle.ALIGN_LEFT );
					break;
			}

			// Check to see if we have any vertical alignment.
			Switch(LOCAL.PropertyMap['vertical-align']) {
				case "bottom":
					ARGUMENTS.CellStyle.SetVerticalAlignment( ARGUMENTS.CellStyle.VERTICAL_BOTTOM );
					break;
				case "middle":
					ARGUMENTS.CellStyle.SetVerticalAlignment( ARGUMENTS.CellStyle.VERTICAL_CENTER );
					break;
				case "center":
					ARGUMENTS.CellStyle.SetVerticalAlignment( ARGUMENTS.CellStyle.VERTICAL_CENTER );
					break;
				case "justify":
					ARGUMENTS.CellStyle.SetVerticalAlignment( ARGUMENTS.CellStyle.VERTICAL_JUSTIFY );
					break;
				case "top":
					ARGUMENTS.CellStyle.SetVerticalAlignment( ARGUMENTS.CellStyle.VERTICAL_TOP );
					break;
			}

			// Check for white space. If we have normal, which is the default, then let's turn
			// on the text wrap. If we have anything else, then turn off the text wrap.
			Switch( LOCAL.PropertyMap['white-space'] ) {
				case "nowrap":
				case "pre":
					ARGUMENTS.CellStyle.SetWrapText( JavaCast( "boolean", false ) );
					break;
				// Default is "normal", which will turn it on.
				default:
					ARGUMENTS.CellStyle.SetWrapText( JavaCast( "boolean", true ) );
			}

			// Apply the font to the current style.
			ARGUMENTS.CellStyle.SetFont( LOCAL.Font );

			// Return the updated cell style object.
			return ARGUMENTS.CellStyle;
		</cfscript>
	</cffunction>
	<!---
		This has been moved out into the actual POI tag code. Currently, we are using the underyling
		method, .HashCode() of structures (which are actually HashTables in Java).
	--->
	<!---
	<cffunction name="GetHash" access="public" returntype="string" output="false"
				hint="Gets the hashed version of the given CSS property map. This creates a unique and easily comparable version of the map.">

		<!--- Define arguments. --->
		<cfargument name="PropertyMap" type="struct" required="true" hint="I am the CSS hash map for which we are getting the hash." />

		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />

		<!--- Create a buffer for the pre-hash value. --->
		<cfset LOCAL.Buffer = "" />

		<!--- Now, loop over the array and create out pre-hash value. --->
		<cfloop index="LOCAL.PropertyKey" array="#VARIABLES.SortedPropertyKeys#">
			<!--- Add the property / value pair. --->
			<cfset LOCAL.Buffer &= "#LOCAL.PropertyKey#:#ARGUMENTS.PropertyMap[LOCAL.PropertyKey]#&" />
		</cfloop>

		<!--- Return the hash. --->
		<cfreturn Hash( LOCAL.Buffer, "SHA-256" ) />
	</cffunction>
	--->

	<cffunction name="GetPropertyTokens" access="public" returntype="array" output="false"
				hint="Parsese the property value into individual tokens.">
		<!------------------------->
		<!--- Define arguments. --->
		<!------------------------->
		<cfargument name="Value" type="string" required="true" hint="The value we want to parse into an array of tokens." />

		<!---
			Get the tokens. These are the smallest meaningful
			pieces of any CSS property.
		--->
		<cfset regex = 	"(?i)" &
						"url\([^\)]+\)|" &
						"""[^""]+""|" &
						"##[0-9ABCDEF]{6}|" &
						"([\w\.\-%]+(\s*,\s*)?)+">
		<cfreturn REMatch(regex, ARGUMENTS.Value ) />
	</cffunction>

	<cffunction name="IsValidValue" access="public" returntype="boolean" output="false"
				hint="Checks to see if the given value validated for a given property.">
		<!------------------------->
		<!--- Define arguments. --->
		<!------------------------->
		<cfargument name="Property" type="string" required="true" hint="The property we are checking for." />
		<cfargument name="Value" type="string" required="true" hint="The value we are checking for validity." />

		<!---
			Return whether it validates. If the property is not
			valid, we are returning false (same as an invalid value).
		--->
		<cfreturn (
			StructKeyExists( VARIABLES.CSS, ARGUMENTS.Property ) AND
			REFind( "(?i)^#VARIABLES.CSSValidation[ARGUMENTS.Property]#$", ARGUMENTS.Value )
		) />
	</cffunction>

	<cffunction name="ParseQuadMetric" access="public" returntype="array" output="false" hint="Takes a quad metric and returns a four-point array.">
		<!--- Define arguments. --->
		<cfargument name="Value" type="string" required="true" hint="The metric which may have between one and four values." />

		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />

		<!--- Grab metric values. --->
		<cfset LOCAL.Values = REMatch( "\d+(\.\d+)?(px|em)", ARGUMENTS.Value ) />

		<!--- Set up the return array. --->
		<cfset LOCAL.Return = ["", "", "", ""] />

		<!--- Check to see how many values we have. --->
		<cfif (ArrayLen( LOCAL.Values ) EQ 1)>
			<!--- Copy to all positions. --->
			<cfset ArraySet( LOCAL.Return, 1, 4, LOCAL.Values[1] ) />
		<cfelseif (ArrayLen( LOCAL.Values ) EQ 2)>
			<!--- Copy 2 and 2. --->
			<cfset LOCAL.Return[1] = LOCAL.Values[1] />
			<cfset LOCAL.Return[2] = LOCAL.Values[2] />
			<cfset LOCAL.Return[3] = LOCAL.Values[1] />
			<cfset LOCAL.Return[4] = LOCAL.Values[2] />
		<cfelseif (ArrayLen( LOCAL.Values ) EQ 3)>
			<!--- Copy 3 and 1. --->
			<cfset LOCAL.Return[1] = LOCAL.Values[1] />
			<cfset LOCAL.Return[2] = LOCAL.Values[2] />
			<cfset LOCAL.Return[3] = LOCAL.Values[3] />
			<cfset LOCAL.Return[4] = LOCAL.Values[1] />
		<cfelseif (ArrayLen( LOCAL.Values ) GTE 4)>
			<!--- Copy first four values. --->
			<cfset LOCAL.Return[1] = LOCAL.Values[1] />
			<cfset LOCAL.Return[2] = LOCAL.Values[2] />
			<cfset LOCAL.Return[3] = LOCAL.Values[3] />
			<cfset LOCAL.Return[4] = LOCAL.Values[4] />

		</cfif>

		<!--- Return results. --->
		<cfreturn LOCAL.Return />
	</cffunction>

	<cffunction name="SetBackground" access="public" returntype="void" output="false"
				hint="Parses the background short-hand and sets the equivalent CSS properties.">

		<!--- Define arguments. --->
		<cfargument name="PropertyMap" type="struct" required="true" hint="I am the CSS hash map being updated." />
		<cfargument name="Value" type="string" required="true" hint="The background short hand value." />

		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />

		<!--- Set up base properties that make up the background short hand. --->
		<cfset LOCAL.CSS["background-attachment"] = "" />
		<cfset LOCAL.CSS["background-color"] = "" />
		<cfset LOCAL.CSS["background-image"] = "" />
		<cfset LOCAL.CSS["background-position"] = "" />
		<cfset LOCAL.CSS["background-repeat"] = "" />

		<!--- Get property tokens. --->
		<cfset LOCAL.Tokens = THIS.GetPropertyTokens( ARGUMENTS.Value ) />

		<!---
			Now that we have all of our tokens, we are going to loop over the
			tokens and the properties and try to apply each. We want to apply
			tokens with the hardest to accomodate first.
		--->
		<cfloop index="LOCAL.Token" array="#LOCAL.Tokens#">
			<!--- Loop over properties, most restrictive first. --->
			<cfloop index="LOCAL.Property"
					list="background-attachment,background-position,background-repeat,background-image,background-color"
					delimiters=",">

				<!---
					Check to see if this value is valid. If this property
					already has a value, then skip.
				--->
				<cfif (( NOT Len( LOCAL.CSS[LOCAL.Property] )) AND THIS.IsValidValue( LOCAL.Property, LOCAL.Token ))>
					<!--- Assign to property. --->
					<cfset LOCAL.CSS[LOCAL.Property] = LOCAL.Token />
					<!--- Move to next token. --->
					<cfbreak />
				</cfif>
			</cfloop>
		</cfloop>

		<!--- Loop over local CSS to apply property. --->
		<cfloop item="LOCAL.Property" collection="#LOCAL.CSS#">
			<!--- Set properties. --->
			<cfif Len( LOCAL.CSS[LOCAL.Property] )>
				<cfset ARGUMENTS.PropertyMap[LOCAL.Property] = LOCAL.CSS[LOCAL.Property] />
			</cfif>
		</cfloop>
		<!--- Return out. --->
		<cfreturn />
	</cffunction>

	<cffunction name="SetBorder" access="public" returntype="void" output="false"
				hint="Parses the border short-hand and sets the equivalent CSS properties.">

		<!--- Define arguments. --->
		<cfargument name="PropertyMap" type="struct" required="true" hint="I am the CSS hash map being updated." />
		<cfargument name="Name" type="string" required="true" hint="The name of the pseudo property that we want to set." />
		<cfargument name="Value" type="string" required="true" hint="The border short hand value." />

		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />

		<!---
			Set up base properties. We will use the top-border as our base
			since all borders act the same and we have validation set up for it.
		--->
		<cfset LOCAL.CSS = {} />
		<cfset LOCAL.CSS["border-top-width"] = "" />
		<cfset LOCAL.CSS["border-top-color"] = "" />
		<cfset LOCAL.CSS["border-top-style"] = "" />

		<!--- Get property tokens. --->
		<cfset LOCAL.Tokens = THIS.GetPropertyTokens( ARGUMENTS.Value ) />

		<!---
			Now that we have all of our tokens, we are going to loop over the
			tokens and the properties and try to apply each. We want to apply
			tokens with the hardest to accomodate first.
		--->
		<cfloop index="LOCAL.Token" array="#LOCAL.Tokens#">
			<!--- Loop over properties, most restrictive first. --->
			<cfloop index="LOCAL.Property" list="border-top-style,border-top-width,border-top-color" delimiters=",">
				<!---
					Check to see if this value is valid. If this property
					already has a value, then skip.
				--->
				<cfif ( (NOT Len( LOCAL.CSS[LOCAL.Property] )) AND THIS.IsValidValue( LOCAL.Property, LOCAL.Token ) )>
					<!--- Assign to property. --->
					<cfset LOCAL.CSS[LOCAL.Property] = LOCAL.Token />
					<!--- Move to next token. --->
					<cfbreak />
				</cfif>
			</cfloop>
		</cfloop>

		<!---
			If we are dealing with the main border, then we have to apply
			these results to all four borders. Otherwise, we are only dealing
			with the given property.
		--->
		<cfif (ARGUMENTS.Name EQ "border")>
			<!--- All four borders. --->
			<cfset LOCAL.PropertyList = "border-top,border-right,border-bottom,border-left" />
		<cfelse>
			<!--- Just the given property. --->
			<cfset LOCAL.PropertyList = ARGUMENTS.Name />
		</cfif>

		<!--- Loop over list to apply CSS. --->
		<cfloop index="LOCAL.Property" list="#LOCAL.PropertyList#" delimiters=",">
			<!--- Set properties. --->
			<cfif Len( LOCAL.CSS["border-top-color"] )>
				<cfset ARGUMENTS.PropertyMap["#LOCAL.Property#-color"] = LOCAL.CSS["border-top-color"] />
			</cfif>
			<cfif Len( LOCAL.CSS["border-top-style"] )>
				<cfset ARGUMENTS.PropertyMap["#LOCAL.Property#-style"] = LOCAL.CSS["border-top-style"] />
			</cfif>
			<cfif Len( LOCAL.CSS["border-top-width"] )>
				<cfset ARGUMENTS.PropertyMap["#LOCAL.Property#-width"] = LOCAL.CSS["border-top-width"] />
			</cfif>
		</cfloop>

		<!--- Return out. --->
		<cfreturn />
	</cffunction>

	<cffunction name="SetFont" access="public" returntype="void" output="false"
				hint="Parses the font short-hand and sets the equivalent CSS properties.">

		<!--- Define arguments. --->
		<cfargument name="PropertyMap" type="struct" required="true" hint="I am the CSS hash map being updated." />

		<cfargument name="Value" type="string" required="true" hint="The font short hand value." />

		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />

		<!--- Set up base properties that make up the font short hand. --->
		<cfset LOCAL.CSS["font-family"] = "" />
		<cfset LOCAL.CSS["font-size"] = "" />
		<cfset LOCAL.CSS["font-style"] = "" />
		<cfset LOCAL.CSS["font-weight"] = "" />

		<!--- Get property tokens. --->
		<cfset LOCAL.Tokens = THIS.GetPropertyTokens( ARGUMENTS.Value ) />

		<!---
			Now that we have all of our tokens, we are going to loop over the
			tokens and the properties and try to apply each. We want to apply
			tokens with the hardest to accomodate first.
		--->
		<cfloop index="LOCAL.Token" array="#LOCAL.Tokens#">
			<!--- Loop over properties, most restrictive first. --->
			<cfloop index="LOCAL.Property" list="font-style,font-size,font-weight,font-family" delimiters=",">
				<!---
					Check to see if this value is valid. If this property
					already has a value, then skip.
				--->
				<cfif ( (NOT Len( LOCAL.CSS[LOCAL.Property] )) AND THIS.IsValidValue( LOCAL.Property, LOCAL.Token ) )>
					<!--- Assign to property. --->
					<cfset LOCAL.CSS[LOCAL.Property] = LOCAL.Token />
					<!--- Move to next token. --->
					<cfbreak />
				</cfif>
			</cfloop>
		</cfloop>

		<!--- Loop over local CSS to apply property. --->
		<cfloop item="LOCAL.Property" collection="#LOCAL.CSS#">
			<!--- Set properties. --->
			<cfif Len( LOCAL.CSS[LOCAL.Property] )>
				<cfset ARGUMENTS.PropertyMap[LOCAL.Property] = LOCAL.CSS[LOCAL.Property] />
			</cfif>
		</cfloop>
		<!--- Return out. --->
		<cfreturn />
	</cffunction>

	<cffunction name="SetListStyle" access="public" returntype="void" output="false"
				hint="Parses the list style short-hand and sets the equivalent CSS properties.">

		<!--- Define arguments. --->
		<cfargument name="PropertyMap" type="struct" required="true" hint="I am the CSS hash map being updated." />
		<cfargument name="Value" type="string" required="true" hint="The list style short hand value." />

		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />

		<!--- Set up base properties that make up the list style short hand. --->
		<cfset LOCAL.CSS["list-style-image"] = "" />
		<cfset LOCAL.CSS["list-style-position"] = "" />
		<cfset LOCAL.CSS["list-style-type"] = "" />

		<!--- Get property tokens. --->
		<cfset LOCAL.Tokens = THIS.GetPropertyTokens( ARGUMENTS.Value ) />

		<!---
			Now that we have all of our tokens, we are going to loop over the
			tokens and the properties and try to apply each. We want to apply
			tokens with the hardest to accomodate first.
		--->
		<cfloop index="LOCAL.Token" array="#LOCAL.Tokens#">
			<!--- Loop over properties, most restrictive first. --->
			<cfloop index="LOCAL.Property" list="list-style-type,list-style-image,list-style-position" delimiters=",">
				<!---
					Check to see if this value is valid. If this property
					already has a value, then skip.
				--->
				<cfif ( (NOT Len( LOCAL.CSS[LOCAL.Property] )) AND THIS.IsValidValue( LOCAL.Property, LOCAL.Token ) )>
					<!--- Assign to property. --->
					<cfset LOCAL.CSS[LOCAL.Property] = LOCAL.Token />
					<!--- Move to next token. --->
					<cfbreak />
				</cfif>
			</cfloop>
		</cfloop>

		<!--- Loop over local CSS to apply property. --->
		<cfloop item="LOCAL.Property" collection="#LOCAL.CSS#">
			<!--- Set properties. --->
			<cfif Len( LOCAL.CSS[LOCAL.Property] )>
				<cfset ARGUMENTS.PropertyMap[LOCAL.Property] = LOCAL.CSS[LOCAL.Property] />
			</cfif>
		</cfloop>
		<!--- Return out. --->
		<cfreturn />
	</cffunction>

	<cffunction name="SetMargin" access="public" returntype="void" output="false"
				hint="Parses the margin short hand and sets the equivalent properties.">

		<!--- Define arguments. --->
		<cfargument name="PropertyMap" type="struct" required="true" hint="I am the CSS hash map being updated." />
		<cfargument name="Value" type="string" required="true" hint="The margin short hand value." />

		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />

		<!--- Parse the quad metric value. --->
		<cfset LOCAL.Metrics = THIS.ParseQuadMetric( ARGUMENTS.Value ) />

		<!--- Set properties. --->
		<cfif IsValidValue( "margin-top", LOCAL.Metrics[1] )>
			<cfset ARGUMENTS.PropertyMap["margin-top"] = LOCAL.Metrics[1] />
		</cfif>

		<cfif IsValidValue( "margin-right", LOCAL.Metrics[2] )>
			<cfset ARGUMENTS.PropertyMap["margin-right"] = LOCAL.Metrics[2] />
		</cfif>

		<cfif IsValidValue( "margin-bottom", LOCAL.Metrics[3] )>
			<cfset ARGUMENTS.PropertyMap["margin-bottom"] = LOCAL.Metrics[3] />
		</cfif>

		<cfif IsValidValue( "margin-left", LOCAL.Metrics[4] )>
			<cfset ARGUMENTS.PropertyMap["margin-left"] = LOCAL.Metrics[4] />
		</cfif>

		<!--- Return out. --->
		<cfreturn />
	</cffunction>

	<cffunction name="SetPadding" access="public" returntype="void" output="false"
				hint="Parses the padding short hand and sets the equivalent properties.">

		<!--- Define arguments. --->
		<cfargument name="PropertyMap" type="struct" required="true" hint="I am the CSS hash map being updated." />
		<cfargument name="Value" type="string" required="true" hint="The padding short hand value." />

		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />

		<!--- Parse the quad metric value. --->
		<cfset LOCAL.Metrics = THIS.ParseQuadMetric( ARGUMENTS.Value ) />

		<!--- Set properties. --->
		<cfif IsValidValue( "padding-top", LOCAL.Metrics[1] )>
			<cfset ARGUMENTS.PropertyMap["padding-top"] = LOCAL.Metrics[1] />
		</cfif>

		<cfif IsValidValue( "padding-right", LOCAL.Metrics[2] )>
			<cfset ARGUMENTS.PropertyMap["padding-right"] = LOCAL.Metrics[2] />
		</cfif>

		<cfif IsValidValue( "padding-bottom", LOCAL.Metrics[3] )>
			<cfset ARGUMENTS.PropertyMap["padding-bottom"] = LOCAL.Metrics[3] />
		</cfif>

		<cfif IsValidValue( "padding-left", LOCAL.Metrics[4] )>
			<cfset ARGUMENTS.PropertyMap["padding-left"] = LOCAL.Metrics[4] />
		</cfif>

		<!--- Return out. --->
		<cfreturn />
	</cffunction>

	<!---------------------------------------------------------------->
	<!--- Convert Color Hexidecimal Strings to Byte[] for POI HSSF --->
	<!---------------------------------------------------------------->
	<cffunction name="HexToByteArray">
		<cfargument name="HexString" type="string" required="true" />
		<cfscript>
			var LOCAL = {};
			var intByte = 0;

			LOCAL.HexColor = Replace(ARGUMENTS.HexString, "##", "", "All");
			LOCAL.rgba = HexToRGB(ARGUMENTS.HexString);
			LOCAL.Bytes = [];
			// Java (Byte) type has 8 bits while Java (Int) has 32 bits. 
			// A conversion needs to be done before the hexidecimal string can be used
			LOCAL.BigInteger = CreateObject("java", "java.math.BigInteger");
			LOCAL.Characters = CreateObject("java", "java.lang.Character");
			LOCAL.Bytes = [
				JavaCast("int", LOCAL.rgba.r).bytevalue(),
				JavaCast("int", LOCAL.rgba.g).bytevalue(),
				JavaCast("int", LOCAL.rgba.b).bytevalue()
			];

			return LOCAL.Bytes;
		</cfscript>
	</cffunction>

	<!---------------------------------------------------->
	<!--- Convert Color Hexidecimal Strings RGB Values --->
	<!---------------------------------------------------->
	<cffunction name="HexToRGB" access="public" output="false" returntype="struct" hint="hex to struct r,g,b,a">
		<cfargument name="hex" type="string" required="true" hint="3 or 6 digit hex value (valid examples: ##FFF, FFF, ##FFFFFF, FFFFFF)">
		<cfscript>
			var retVal = {};
			var i = 0;
			var o = 0;
			var offset = 0;

			// cheaper in time to look for a leading '#' and set an offset than burn a call to removeChars
			if(Mid(ARGUMENTS.hex, 1, 1) EQ Chr(35)) {
				offset = 1;
			}

			// Remove non-hex values. the following is faster than regex
			for(i = (1 + offset); i <= Len(ARGUMENTS.hex); i++) {
				if(Find(Mid(ARGUMENTS.hex, i + o, 1), '0123456789ABCDEFabcdef') EQ 0) {
					ARGUMENTS.hex = RemoveChars(ARGUMENTS.hex, i + o, 1);
					o = o - 1;
				}
			}

			if(Len(ARGUMENTS.hex) EQ (3 + offset)) {
				retVal.r = InputBaseN(Mid(ARGUMENTS.hex, 1 + offset, 1) & Mid(ARGUMENTS.hex, 1 + offset, 1), 16);
				retVal.g = InputBaseN(Mid(ARGUMENTS.hex, 2 + offset, 1) & Mid(ARGUMENTS.hex, 2 + offset, 1), 16);
				retVal.b = InputBaseN(Mid(ARGUMENTS.hex, 3 + offset, 1) & Mid(ARGUMENTS.hex, 3 + offset, 1), 16);
			} else {
				retVal.r = InputBaseN(Mid(ARGUMENTS.hex, 1 + offset, 2), 16);
				retVal.g = InputBaseN(Mid(ARGUMENTS.hex, 3 + offset, 2), 16);
				retVal.b = InputBaseN(Mid(ARGUMENTS.hex, 5 + offset, 2), 16);
			}

			retVal.a = 255;

			return retVal;
		</cfscript>
	</cffunction>
</cfcomponent>