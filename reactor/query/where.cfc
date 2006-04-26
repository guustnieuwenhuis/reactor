<cfcomponent hint="I am an object used to create wheres for where statements">
	<!---
		Sean 3/7/2006: since we pool where objects (as part of query objects), there's
		no point in initializing variables in the pseudo-constructor
	<cfset variables.mode = "and" />
	<cfset variables.where = ArrayNew(1) />
	<cfset variables.query = 0 />
	--->

	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the criteria object" output="false" returntype="reactor.query.where">
		<cfargument name="query" hint="I am the query this where expression is in." required="yes" type="reactor.query.query">
		
		<!---
			Sean 3/7/2006: where objects remain part of pooled query objects now
			need to re-init everything because we rely on the query object re-running our init()
		--->
		<cfset variables.mode = "and" />
		<cfset variables.where = ArrayNew(1) />
		<cfset setQuery(arguments.query) />
		
		<cfreturn this />
	</cffunction>

	<!--- createWhere --->
	<cffunction name="createWhere" access="public" hint="I return a new where to be used with complex queries." returntype="reactor.query.where">
		<cfreturn CreateObject("Component", "reactor.query.where").init(getQuery()) />
	</cffunction>

	<!--- query --->
    <cffunction name="setQuery" access="private" output="false" returntype="void">
		<cfargument name="query" hint="I am the query this where expression is in." required="yes" type="reactor.query.query" />
		<cfset variables.query = arguments.query />
    </cffunction>
    <cffunction name="getQuery" access="private" output="false" returntype="reactor.query.query">
		<cfreturn variables.query />
    </cffunction>
	
	<!--- validateField --->
	<cffunction name="validateField" access="private" output="false" returntype="void">
		<cfargument name="object" hint="I am the alias of the object of the field should be in" required="yes" type="string" />
		<cfargument name="field" hint="I am the name of the field to validate" required="yes" type="string" />
		
		<cfset getQuery().findObject(arguments.object).getObjectMetadata().getField(arguments.field) />
	</cffunction>

	<!---<cffunction name="dump" access="public" hint="I am a debugging method.  I dump the current where statement's data." output="false" returntype="void">
		<cfset getQuery().verifyInitialized() />
		<cfdump var="#getWhere()#" /><cfabort>
	</cffunction>--->
	
	<cffunction name="appendNode" access="private" hint="I append a node to the where expression" output="false" returntype="reactor.query.where">
		<cfargument name="node" hint="I am the node to append" required="yes" type="struct" />
		<cfargument name="comparison" hint="I am the comparison" required="yes" type="string" />
		<cfset var where = getWhere() />
		<cfset var mode = getMode() />
		
		<cfset node.alias = node.field />
		<cfset node.field = getQuery().findObject(node.object).getObjectMetadata().getField(node.field).name />
		
		<cfif ArrayLen(where) GT 0>
			<cfset ArrayAppend(where, mode) />
		</cfif>
				
		<cfset arguments.node.comparison = arguments.comparison />
		
		<cfset ArrayAppend(where, node) />	
		
		<cfset setWhere(where) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addWhere" access="public" hint="I return an where which is the conjunction of the current where and the provided where. where AND/OR (where)." output="false" returntype="reactor.query.where">
		<cfargument name="Where1" hint="I am the where to add " required="yes" type="reactor.query.where" />
		<cfset var where = getWhere() />
		
		<cfif ArrayLen(where) GT 0>
			<cfset ArrayAppend(where, mode) />
		</cfif>
		
		<cfset where = appendWhere(where, arguments.Where1) />
		
		<cfset setWhere(where) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="negateWhere" access="public" hint="I return the negation of an where." output="false" returntype="reactor.query.where">
		<cfargument name="Where1" hint="I am the first where" required="yes" type="reactor.query.where" />
		
		<cfset appendNode(StructNew(), "negate") />
		<cfset appendWhere(arguments.Where1) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="appendWhere" access="private" hint="I append another where into this where." output="false" returntype="array">
		<cfargument name="expression" hint="I am the array of where expressions to append to" required="yes" type="array" />
		<cfargument name="Where2" hint="I am the where to append" required="yes" type="reactor.query.where" />
		<cfset var x = 0 />
		<cfset var appendExpression = 0 />

		<cfset getQuery().verifyInitialized() />
		
		<cfset appendExpression = arguments.Where2.getWhere() />
		
		<cfset ArrayAppend(arguments.expression, "(") />	
		
		<cfloop from="1" to="#ArrayLen(appendExpression)#" index="x">
			<cfset ArrayAppend(arguments.expression, appendExpression[x]) />	
		</cfloop>
		
		<cfset ArrayAppend(arguments.expression, ")") />	
				
		<cfreturn arguments.expression />
	</cffunction>
				
	<cffunction name="isBetween" access="public" hint="I return an where which checks if a field is between two other values." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value1" hint="I am the first value" required="yes" type="string" />
		<cfargument name="value2" hint="I am the second value" required="yes" type="string" />
				
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfreturn appendNode(arguments, "isBetween") />
	</cffunction>
			
	<cffunction name="isBetweenFields" access="public" hint="I return an where which checks if a field is between two other fields." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="compareToObject1" hint="I am the alias of the object the first comparison field is in" required="yes" type="string" />
		<cfargument name="compareToField1" hint="I am the first comparison field to compare" required="yes" type="string" />
		<cfargument name="compareToObject2" hint="I am the alias of the object the second comparison field is in" required="yes" type="string" />
		<cfargument name="compareToField2" hint="I am the second comparison field to compare" required="yes" type="string" />
				
		<cfset validateField(arguments.object, arguments.field) />
		<cfset validateField(arguments.compareToObject1, arguments.compareToField1) />
		<cfset validateField(arguments.compareToObject2, arguments.compareToField2) />
		
		<cfreturn appendNode(arguments, "isBetweenFields") />
	</cffunction>
	
	<cffunction name="isEqual" access="public" hint="I return an where which checks if a fields equals a value." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the alias of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare" required="yes" type="string" />
				
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfreturn appendNode(arguments, "isEqual") />
	</cffunction>
	
	<cffunction name="isEqualField" access="public" hint="I return an where which checks if two fields in the query are equal." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="compareToObject1" hint="I am the alias of the object the first comparison field is in" required="yes" type="string" />
		<cfargument name="compareToField1" hint="I am the first comparison field to compare" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		<cfset validateField(arguments.compareToObject1, arguments.compareToField1) />
		
		<cfreturn appendNode(arguments, "isEqualField") />
	</cffunction>
	
	<cffunction name="isNotEqual" access="public" hint="I return an where which checks if a field does not equal a value." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfreturn appendNode(arguments, "isNotEqual") />
	</cffunction>
	
	<cffunction name="isNotEqualField" access="public" hint="I return an where which checks if two fields in the query are not equal." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="compareToObject1" hint="I am the alias of the object the first comparison field is in" required="yes" type="string" />
		<cfargument name="compareToField1" hint="I am the first comparison field to compare" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		<cfset validateField(arguments.compareToObject1, arguments.compareToField1) />
		
		<cfreturn appendNode(arguments, "isNotEqualField") />
	</cffunction>
	
	<cffunction name="isGte" access="public" hint="I return an where which checks if a field is greater than or equal to a value." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfreturn appendNode(arguments, "isGte") />
	</cffunction>
	
	<cffunction name="isGteField" access="public" hint="I return an where which checks if a field is greater than or equal to another field." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="compareToObject1" hint="I am the alias of the object the first comparison field is in" required="yes" type="string" />
		<cfargument name="compareToField1" hint="I am the first comparison field to compare" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		<cfset validateField(arguments.compareToObject1, arguments.compareToField1) />
		
		<cfreturn appendNode(arguments, "isGteField") />
	</cffunction>
	
	<cffunction name="isGt" access="public" hint="I return an where which checks if a field is greater than a value." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfreturn appendNode(arguments, "isGt") />
	</cffunction>
	
	<cffunction name="isGtField" access="public" hint="I return an where which checks if a field is greater than another field." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="compareToObject1" hint="I am the alias of the object the first comparison field is in" required="yes" type="string" />
		<cfargument name="compareToField1" hint="I am the first comparison field to compare" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		<cfset validateField(arguments.compareToObject1, arguments.compareToField1) />
		
		<cfreturn appendNode(arguments, "isGtField") />
	</cffunction>
	
	<cffunction name="isLike" access="public" hint="I return an where which checks if a field is 'like' a value." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		<cfargument name="mode" hint="I am the mode of the like comparison.  Options are: Anywhere, Left, All, Right" required="no" type="string" default="anywhere" />
		
		<cfset validateField(arguments.object, arguments.field) />

		<cfif NOT ListFindNoCase("Anywhere,Left,All,Right", arguments.mode)>
			<cfthrow message="Invalid Mode" detail="The 'mode' argument is invalid.  This must be one of: Anywhere, Left, All, Right" />
		</cfif>
		
		<cfreturn appendNode(arguments, "isLike") />
	</cffunction>
	
	<cffunction name="isNotLike" access="public" hint="I return an where which checks if a field is 'not like' a value." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		<cfargument name="mode" hint="I am the mode of the like comparison.  Options are: Anywhere, Left, All, Right" required="no" type="string" default="anywhere" />
		
		<cfset validateField(arguments.object, arguments.field) />

		<cfif NOT ListFindNoCase("Anywhere,Left,All,Right", arguments.mode)>
			<cfthrow message="Invalid Mode" detail="The 'mode' argument is invalid.  This must be one of: Anywhere, Left, All, Right" />
		</cfif>
		
		<cfreturn appendNode(arguments, "isNotLike") />
	</cffunction>
	
	<cffunction name="isIn" access="public" hint="I return an where which checks if a field's value is in a list of values." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="values" hint="I am a comma delimited list of values to compare against" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfreturn appendNode(arguments, "isIn") />
	</cffunction>
	
	<cffunction name="isNotIn" access="public" hint="I return an where which checks if a field's value is not in a list of values." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="values" hint="I am a comma delimited list of values to compare against" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfreturn appendNode(arguments, "isNotIn") />
	</cffunction>
	
	<cffunction name="isNotNull" access="public" hint="I return an where which checks if a field's is not null." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfreturn appendNode(arguments, "isNotNull") />
	</cffunction>
	
	<cffunction name="isNull" access="public" hint="I return an where which checks if a field's is null." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfreturn appendNode(arguments, "isNull") />
	</cffunction>
	
	<cffunction name="isLte" access="public" hint="I return an where which checks if a field is greater than or equal to a value." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the name of the field" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfreturn appendNode(arguments, "isLte") />
	</cffunction>
	
	<cffunction name="isLteField" access="public" hint="I return an where which checks if a field is greater than or equal to another field." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="compareToObject1" hint="I am the alias of the object the first comparison field is in" required="yes" type="string" />
		<cfargument name="compareToField1" hint="I am the first comparison field to compare" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		<cfset validateField(arguments.compareToObject1, arguments.compareToField1) />
		
		<cfreturn appendNode(arguments, "isLteField") />
	</cffunction>
	
	<cffunction name="isLt" access="public" hint="I return an where which checks if a field is greater than a value." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="value" hint="I am the value to compare against" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		
		<cfreturn appendNode(arguments, "isLt") />
	</cffunction>
	
	<cffunction name="isLtField" access="public" hint="I return an where which checks if a field is greater than another field." output="false" returntype="reactor.query.where">
		<cfargument name="object" hint="I am the alias of the object the field is in" required="yes" type="string" />
		<cfargument name="field" hint="I am the field to compare" required="yes" type="string" />
		<cfargument name="compareToObject1" hint="I am the alias of the object the first comparison field is in" required="yes" type="string" />
		<cfargument name="compareToField1" hint="I am the first comparison field to compare" required="yes" type="string" />
		
		<cfset validateField(arguments.object, arguments.field) />
		<cfset validateField(arguments.compareToObject1, arguments.compareToField1) />
		
		<cfreturn appendNode(arguments, "isLtField") />
	</cffunction>
	
	<!--- mode --->
    <cffunction name="setMode" access="public" output="false" returntype="reactor.query.where">
		<cfargument name="mode" hint="I am the type of 'junction' mode to use when adding wheres" required="yes" type="string" />

		<cfset getQuery().verifyInitialized() />
		
		<cfif NOT ListFindNoCase("Or,And", arguments.mode)>
			<cfthrow message="Invalid Mode" detail="The 'mode' argument is invalid.  This must be one of: Or, And" />
		</cfif>
			
		<cfset variables.mode = arguments.mode />
		
		<cfreturn this />
    </cffunction>
	
	<cffunction name="getMode" access="private" output="false" returntype="string">
		<cfreturn variables.mode />
	</cffunction>
	
	<!--- where --->
    <cffunction name="setWhere" access="public" output="false" returntype="void">
		<cfargument name="where" hint="I am the where's array of statements." required="yes" type="array" />
		
		<cfset getQuery().verifyInitialized() />
		
		<cfset variables.where = arguments.where />
    </cffunction>
    <cffunction name="getWhere" access="public" output="false" returntype="array">
		<cfset var field = 0 />
		
		<cfset getQuery().verifyInitialized() />
		
		<cfloop from="1" to="#ArrayLen(variables.where)#" index="x">
			
			<cfif IsStruct(variables.where[x])>
				<cfset field = getQuery().getField(variables.where[x].object, variables.where[x].alias) />
				
				<cfif StructKeyExists(field, "expression")>
					<cfset variables.where[x].expression = field.expression />
				</cfif>
				
				<!--- if there's a compareToField1 or compareToField2 then get their expressions too --->
				<cfif StructKeyExists(variables.where[x], "compareToField1")>
					<cfset field = getQuery().getField(variables.where[x].compareToObject1, variables.where[x].compareToField1) />
					
					<cfif StructKeyExists(field, "expression")>
						<cfset variables.where[x].compareToExpression1 = field.expression />
					</cfif>
				</cfif>
				<cfif StructKeyExists(variables.where[x], "compareToField2")>
					<cfset field = getQuery().getField(variables.where[x].compareToObject2, variables.where[x].compareToField2) />
					
					<cfif StructKeyExists(field, "expression")>
						<cfset variables.where[x].compareToExpression2 = field.expression />
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn variables.where />
    </cffunction>
	
</cfcomponent>

<!---<cffunction name="andWhere" access="public" hint="I return an where which is the conjunction of two wheres (where1 AND where2)." output="false" returntype="reactor.query.where">
		<cfargument name="Where1" hint="I am the first where" required="yes" type="reactor.query.where" />
		<cfargument name="Where2" hint="I am the first where" required="yes" type="reactor.query.where" />
		<cfset var where = getWhere() />
		<cfset var mode = getMode() />
		
		<cfif ArrayLen(where) GT 0>
			<cfset ArrayAppend(where, mode) />
		</cfif>
			
		<cfset where = appendWhere(where, arguments.Where1) />
		<cfset ArrayAppend(where, "and") />
		<cfset where = appendWhere(where, arguments.Where2) />
		
		<cfset setWhere(where) />
		
		<cfreturn this />
	</cffunction>--->
	
	<!---<cffunction name="orWhere" access="public" hint="I return an where which is the disjunction of two wheres (where1 OR where2)." output="false" returntype="reactor.query.where">
		<cfargument name="Where1" hint="I am the first where" required="yes" type="reactor.query.where" />
		<cfargument name="Where2" hint="I am the second where" required="yes" type="reactor.query.where" />
		<cfset var where = getWhere() />
		<cfset var mode = getMode() />
		
		<cfif ArrayLen(where) GT 0>
			<cfset ArrayAppend(where, mode) />
		</cfif>
			
		<cfset where = appendWhere(where, arguments.Where1) />
		<cfset ArrayAppend(where, "or") />
		<cfset where = appendWhere(where, arguments.Where2) />
		
		<cfset setWhere(where) />
		
		<cfreturn this />
	</cffunction>--->