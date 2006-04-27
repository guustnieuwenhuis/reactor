<cfcomponent hint="I am an abstract Validator.  I am used to define an interface and for validation objects." extends="reactor.base.abstractObject">
	
	<cffunction name="createErrorCollection" access="public" hint="I create and return an error collection" output="false" returntype="reactor.util.ErrorCollection">
		<cfargument name="Dictionary" hint="I am the dictionary to use to translate errors." required="yes" type="reactor.dictionary.dictionary" />
		
		<cfreturn CreateObject("Component", "reactor.util.ErrorCollection").init(arguments.Dictionary) />
	</cffunction>
	
</cfcomponent>