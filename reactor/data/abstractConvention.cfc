<cfcomponent hint="I am an abstract convention object used to define the convention object's interface.">

	<cffunction name="lastInsertedIdSyntax" access="public" hint="I return a simple query which can be used to get the last ID inserted into the database." output="false" returntype="any">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="any" />
		
	</cffunction>
	
	<cffunction name="formatObjectAlias" access="public" hint="I format the object name" output="false" returntype="any">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="any" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="any" />
		
	</cffunction>
	
	<cffunction name="formatObjectName" access="public" hint="I format the object" output="false" returntype="any">
		<cfargument name="ObjectMetadata" hint="I am the metadata to use." required="yes" type="any" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="any" />
		
	</cffunction>
	
	<cffunction name="formatFieldName" access="public" hint="I format the field name" output="false" returntype="any">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="any" />
		<cfargument name="alias" hint="I am this object's alias" required="yes" type="any" />
		
	</cffunction>
	
	<cffunction name="formatUpdateFieldName" access="public" hint="I format the field name" output="false" returntype="any">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="any" />
		
	</cffunction>
	
	<cffunction name="formatFieldAlias" access="public" hint="I format the field name" output="false" returntype="any">
		<cfargument name="fieldName" hint="I am the field name." required="yes" type="any" />
		<cfargument name="alias" hint="I am this object's alias" required="no" type="any" default="" />
		
	</cffunction>
	
	<cffunction name="formatValue" access="public" hint="I format a value based on it's type." output="false" returntype="any">
		<cfargument name="value" hint="I am the value to format" required="yes" type="any" />
		<cfargument name="dbDataType" hint="I am the type of data in the database" required="yes" type="any" />
		
	</cffunction>	
	
</cfcomponent>