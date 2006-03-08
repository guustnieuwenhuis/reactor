<cfcomponent hint="I am a component used to define ad-hoc queries.">
	<!---
		Sean 3/7/2006: since we pool query objects, there's no point in
		initializing variables in the pseudo-constructor, except for creating
		the where and order objects - uninitialized (createObject() is the
		expense we're trying to avoid for future initializations!)

	< !--- the from object --- >
	<cfset variables.From = 0 />

	< !--- query parts --- >
	<cfset variables.maxRows = -1 />
	<cfset variables.distinct = false />	
	
	< !--- fields --- >
	<cfset variables.returnFields = ArrayNew(1) />
	--->
	
	<!--- default where object (initialized in init() below) --->
	<cfset variables.where = CreateObject("Component", "reactor.query.where") />

	<!--- default order object (initialized in init() below)  --->
	<cfset variables.order = CreateObject("Component", "reactor.query.order") />
 
	<!--- init --->
	<cffunction name="init" access="public" hint="I configure and return the criteria object" output="false" returntype="reactor.query.query">
		<cfargument name="BaseObjectMetadata" hint="I am the Metadata for the base object being queried" required="yes" type="reactor.base.abstractMetadata">
		<cfset var Object = 0 />
		
		<!---
			Sean 3/7/2006: query objects are pooled now, so we do not create new
			where and order objects each time we are initialized (only when we are
			first created - see pseudo-constructor above)
			
			that also means we must initialize all our instance data here
		--->

		<!--- the from object --->
		<cfset variables.From = 0 />
	
		<!--- query parts --->
		<cfset variables.maxRows = -1 />
		<cfset variables.distinct = false />	
		
		<!--- fields --->
		<cfset variables.returnFields = ArrayNew(1) />
		
		<!--- where --->
		<cfset variables.where.init(this) />
	
		<!--- order --->
		<cfset variables.order.init(this) />

		<cfset Object = CreateObject("Component", "reactor.query.object").init(arguments.BaseObjectMetadata, arguments.BaseObjectMetadata.getAlias()) />
		
		<cfset setFrom(Object) />
		
		<!--- <cfset joinSuper(Object) /> --->

		<cfreturn this />
	</cffunction>
	
	<!--- returnObjectFields --->
	<cffunction name="returnObjectFields" access="public" hint="I specify a particular object from which all fields should be returned. When this or returnField() is first called cause only the specified column to be returned.  Additional columns can be added with multiple calls." output="false" returntype="reactor.query.query">
		<cfargument name="alias" hint="I am the alias of the object." required="yes" type="string" />
		<cfset var fields = findObject(arguments.alias).getObjectMetadata().getFields() />
		<cfset var x = 0 />
		
		<cfloop from="1" to="#ArrayLen(fields)#" index="x">
			<cfset returnField(arguments.alias, fields[x].alias) />
		</cfloop>
		
		<cfreturn this />
	</cffunction>
	
	<!--- returnField --->
	<cffunction name="returnField" access="public" hint="I specify a particular field a query should return.  When this or returnObjectFields() is first called I cause only the specified column to be returned.  Additional columns can be added with multiple calls." output="false" returntype="reactor.query.query">
		<cfargument name="object" hint="I am the alias of the object." required="yes" type="string" />
		<cfargument name="field" hint="I am the alias of the field." required="yes" type="string" />
		<cfset var fieldStruct = getField(arguments.object, arguments.field) />
		<cfset var returnFields = getReturnFields() />
		
		<!--- add a field to return --->
		<cfset ArrayAppend(returnFields, CreateObject("Component", "reactor.query.field").init(arguments.object, fieldStruct.name, fieldStruct.alias)) />
		<cfset setReturnFields(returnFields) />
		
		<cfreturn this />
	</cffunction>
	
	<!--- from --->
    <cffunction name="setFrom" access="private" output="false" returntype="void">
       <cfargument name="from" hint="I am the to from statement" required="yes" type="reactor.query.object" />
       <cfset variables.from = arguments.from />
    </cffunction>
    <cffunction name="getFrom" access="public" output="false" returntype="reactor.query.object">
       <cfreturn variables.from />
    </cffunction>
	
	<!--- getFromAsString --->
	<cffunction name="getFromAsString" access="public" hint="I convert the from objects to a sql from fragment." output="false" returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="reactor.data.abstractConvention" />
		<cfreturn getFrom().getFromAsString(arguments.Convention) />
	</cffunction>
	
	<!--- getSelectAsString --->
	<cffunction name="getSelectAsString" access="public" hint="I convert the from objects to a sql select fragment" output="false" returntype="string">
		<cfargument name="Convention" hint="I am the convention object to use." required="yes" type="reactor.data.abstractConvention" />
		<cfreturn getFrom().getSelectAsString(arguments.Convention, getReturnFields()) />
	</cffunction>
	
	<!--- findObject --->
	<cffunction name="findObject" access="package" hint="I find an object in the query" output="false" returntype="reactor.query.object">
		<cfargument name="alias" hint="I am the alias of a object being searched for." required="yes" type="string" />
		<cfset var Object = getFrom().findObject(arguments.alias) />
		
		<cfif IsObject(Object)>
			<cfreturn Object />
		</cfif>

		<cfthrow message="Can Not Find Object" detail="Can not find the object '#arguments.alias#' as an alias or name within the query." type="reactor.findObject.CanNotFindObject" />
	</cffunction>
	
	<!--- joinSuper
	<cffunction name="joinSuper" access="private" hint="I join any super objects." output="false" returntype="void">
		<cfargument name="Object" hint="I am the object to join onto supers." required="yes" type="reactor.query.object" />
		<cfset var ObjectMetadata = arguments.Object.getObjectMetadata() />
		
		<cfif ObjectMetadata.hasSuper()>
			<cfset join(arguments.Object.getAlias(), ObjectMetadata.getSuperAlias()) />
		</cfif>		
	</cffunction> --->
	
	<!--- join --->
	<cffunction name="join" access="public" hint="I join one object to another." output="false" returntype="reactor.query.query">
		<cfargument name="from" hint="I am the alias of a object being joined from." required="yes" type="string" />
		<cfargument name="to" hint="I am the alias of an object being joined to." required="yes" type="string" />
		<cfargument name="toPrefix" hint="I am an optional prefix appended to all fields in the to Object which are returned in this query." required="no" type="string" default="" />
		<cfargument name="type" hint="I am the type of join. Options are: left, right, full" required="no" type="string" default="inner" />
		<cfset var FromObject = findObject(arguments.from) />
		<cfset var ToObject = FromObject.getRelatedObject(arguments.to) />
		<cfset FromObject.join(ToObject, arguments.toPrefix, arguments.type) />
		
		<!---<cfset joinSuper(ToObject) />--->
		
		<cfreturn this />
	</cffunction>
	
	<!--- maxrows --->
    <cffunction name="setMaxrows" hint="I configure the number of rows returned by the query." access="public" output="false" returntype="void">
       <cfargument name="maxrows" hint="I set the maximum number of rows to return. If -1 all rows are returned." required="yes" type="numeric" />
       <cfset variables.maxrows = arguments.maxrows />
    </cffunction>
    <cffunction name="getMaxrows" access="public" output="false" returntype="numeric">
       <cfreturn variables.maxrows />
    </cffunction>
	
	<!--- distinct --->
    <cffunction name="setDistinct" hint="I indicate if only distinct rows should be returned" access="public" output="false" returntype="void">
       <cfargument name="distinct" hint="I indicate if the query should only return distinct matches" required="yes" type="boolean" />
       <cfset variables.distinct = arguments.distinct />
    </cffunction>
    <cffunction name="getDistinct" access="public" output="false" returntype="boolean">
       <cfreturn variables.distinct />
    </cffunction>
			
	<!--- where --->
    <cffunction name="setWhere" access="public" output="false" returntype="void">
       <cfargument name="where" hint="I am the query's where experssion" required="yes" type="reactor.query.where" />
       <cfset variables.where = arguments.where />
    </cffunction>
    <cffunction name="getWhere" access="public" output="false" returntype="reactor.query.where">
       <cfreturn variables.where />
    </cffunction>
	<cffunction name="resetWhere" access="public" output="false" returntype="void">
		<cfset variables.where = CreateObject("Component", "reactor.query.where").init(this) />
	</cffunction>
	
	<!--- getField --->
	<cffunction name="getField" access="public" hint="I get a column based on the provided object name/alias and field name" output="false" returntype="struct">
		<cfargument name="object" hint="I am the alias of the object." required="yes" type="string" />
		<cfargument name="field" hint="I am the name of the field." required="yes" type="string" />
		<cfreturn findObject(arguments.object).getObjectMetadata().getField(arguments.field) />
	</cffunction>
	
	<!--- order --->
    <cffunction name="setOrder" access="public" output="false" returntype="void">
       <cfargument name="order" hint="I am the order expression" required="yes" type="reactor.query.order" />
       <cfset variables.order = arguments.order />
    </cffunction>
    <cffunction name="getOrder" access="public" output="false" returntype="reactor.query.order">
       <cfreturn variables.order />
    </cffunction>
	<cffunction name="resetOrder" access="public" output="false" returntype="void">
		<cfset variables.order = CreateObject("Component", "reactor.query.order").init(this) />
	</cffunction>
	
	<!--- returnFields --->
    <cffunction name="setReturnFields" access="private" output="false" returntype="void">
       <cfargument name="returnFields" hint="I am an array of fields to return.  If empty all fields are returned." required="yes" type="array" />
       <cfset variables.returnFields = arguments.returnFields />
    </cffunction>
    <cffunction name="getReturnFields" access="private" output="false" returntype="array">
       <cfreturn variables.returnFields />
    </cffunction>
	<cffunction name="resetReturnFields" access="public" output="false" returntype="void">
		<cfset variables.returnFields = ArrayNew(1) />
	</cffunction>
</cfcomponent>
