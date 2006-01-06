
<cfcomponent hint="I am the base record representing the User table.  I am generated.  DO NOT EDIT ME."
	extends="reactor.base.abstractRecord" >
	
	<cfset variables.signature = "F7ADEC7185C05ADD1F4892545ADBE65C" />
	
	<cffunction name="init" access="public" hint="I configure and return this record object." output="false" returntype="ReactorBlogData.Record.mysql.base.UserRecord">
		
			<cfargument name="UserId" hint="I am the default value for the  UserId field." required="no" type="string" default="0" />
		
			<cfargument name="Username" hint="I am the default value for the  Username field." required="no" type="string" default="" />
		
			<cfargument name="Password" hint="I am the default value for the  Password field." required="no" type="string" default="" />
		
			<cfargument name="FirstName" hint="I am the default value for the  FirstName field." required="no" type="string" default="" />
		
			<cfargument name="LastName" hint="I am the default value for the  LastName field." required="no" type="string" default="" />
		
			<cfset setUserId(arguments.UserId) />
		
			<cfset setUsername(arguments.Username) />
		
			<cfset setPassword(arguments.Password) />
		
			<cfset setFirstName(arguments.FirstName) />
		
			<cfset setLastName(arguments.LastName) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="validate" access="public" hint="I validate this object and populate and return a ValidationErrorCollection object." output="false" returntype="reactor.util.ValidationErrorCollection">
		<cfargument name="ValidationErrorCollection" hint="I am the ValidationErrorCollection to populate." required="no" type="reactor.util.ValidationErrorCollection" default="#createErrorCollection()#" />
		<cfset var ErrorManager = CreateObject("Component", "reactor.core.ErrorManager").init(expandPath("#_getConfig().getMapping()#/ErrorMessages.xml")) />
		
		
					
					<!--- validate UserId is numeric --->
					<cfif Len(Trim(getUserId())) AND NOT IsNumeric(getUserId())>
						<cfset ValidationErrorCollection.addError("UserId", ErrorManager.getError("User", "UserId", "invalidType")) />
					</cfif>					
				
						<!--- validate Username is provided --->
						<cfif NOT Len(Trim(getUsername()))>
							<cfset ValidationErrorCollection.addError("Username", ErrorManager.getError("User", "Username", "notProvided")) />
						</cfif>
					
					
					<!--- validate Username is string --->
					<cfif NOT IsSimpleValue(getUsername())>
						<cfset ValidationErrorCollection.addError("Username", ErrorManager.getError("User", "Username", "invalidType")) />
					</cfif>
					
					<!--- validate Username length --->
					<cfif Len(getUsername()) GT 20 >
						<cfset ValidationErrorCollection.addError("Username", ErrorManager.getError("User", "Username", "invalidLength")) />
					</cfif>					
				
						<!--- validate Password is provided --->
						<cfif NOT Len(Trim(getPassword()))>
							<cfset ValidationErrorCollection.addError("Password", ErrorManager.getError("User", "Password", "notProvided")) />
						</cfif>
					
					
					<!--- validate Password is string --->
					<cfif NOT IsSimpleValue(getPassword())>
						<cfset ValidationErrorCollection.addError("Password", ErrorManager.getError("User", "Password", "invalidType")) />
					</cfif>
					
					<!--- validate Password length --->
					<cfif Len(getPassword()) GT 20 >
						<cfset ValidationErrorCollection.addError("Password", ErrorManager.getError("User", "Password", "invalidLength")) />
					</cfif>					
				
						<!--- validate FirstName is provided --->
						<cfif NOT Len(Trim(getFirstName()))>
							<cfset ValidationErrorCollection.addError("FirstName", ErrorManager.getError("User", "FirstName", "notProvided")) />
						</cfif>
					
					
					<!--- validate FirstName is string --->
					<cfif NOT IsSimpleValue(getFirstName())>
						<cfset ValidationErrorCollection.addError("FirstName", ErrorManager.getError("User", "FirstName", "invalidType")) />
					</cfif>
					
					<!--- validate FirstName length --->
					<cfif Len(getFirstName()) GT 20 >
						<cfset ValidationErrorCollection.addError("FirstName", ErrorManager.getError("User", "FirstName", "invalidLength")) />
					</cfif>					
				
						<!--- validate LastName is provided --->
						<cfif NOT Len(Trim(getLastName()))>
							<cfset ValidationErrorCollection.addError("LastName", ErrorManager.getError("User", "LastName", "notProvided")) />
						</cfif>
					
					
					<!--- validate LastName is string --->
					<cfif NOT IsSimpleValue(getLastName())>
						<cfset ValidationErrorCollection.addError("LastName", ErrorManager.getError("User", "LastName", "invalidType")) />
					</cfif>
					
					<!--- validate LastName length --->
					<cfif Len(getLastName()) GT 20 >
						<cfset ValidationErrorCollection.addError("LastName", ErrorManager.getError("User", "LastName", "invalidLength")) />
					</cfif>					
				
		<cfreturn arguments.ValidationErrorCollection />
	</cffunction>
	
	
		<!--- UserId --->
		<cffunction name="setUserId" access="public" output="false" returntype="void">
			<cfargument name="UserId" hint="I am this record's UserId value." required="yes" type="string" />
			<cfset _getTo().UserId = arguments.UserId />
		</cffunction>
		<cffunction name="getUserId" access="public" output="false" returntype="string">
			<cfreturn _getTo().UserId />
		</cffunction>	
	
		<!--- Username --->
		<cffunction name="setUsername" access="public" output="false" returntype="void">
			<cfargument name="Username" hint="I am this record's Username value." required="yes" type="string" />
			<cfset _getTo().Username = arguments.Username />
		</cffunction>
		<cffunction name="getUsername" access="public" output="false" returntype="string">
			<cfreturn _getTo().Username />
		</cffunction>	
	
		<!--- Password --->
		<cffunction name="setPassword" access="public" output="false" returntype="void">
			<cfargument name="Password" hint="I am this record's Password value." required="yes" type="string" />
			<cfset _getTo().Password = arguments.Password />
		</cffunction>
		<cffunction name="getPassword" access="public" output="false" returntype="string">
			<cfreturn _getTo().Password />
		</cffunction>	
	
		<!--- FirstName --->
		<cffunction name="setFirstName" access="public" output="false" returntype="void">
			<cfargument name="FirstName" hint="I am this record's FirstName value." required="yes" type="string" />
			<cfset _getTo().FirstName = arguments.FirstName />
		</cffunction>
		<cffunction name="getFirstName" access="public" output="false" returntype="string">
			<cfreturn _getTo().FirstName />
		</cffunction>	
	
		<!--- LastName --->
		<cffunction name="setLastName" access="public" output="false" returntype="void">
			<cfargument name="LastName" hint="I am this record's LastName value." required="yes" type="string" />
			<cfset _getTo().LastName = arguments.LastName />
		</cffunction>
		<cffunction name="getLastName" access="public" output="false" returntype="string">
			<cfreturn _getTo().LastName />
		</cffunction>	
	
	
	<cffunction name="load" access="public" hint="I load the User record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().read(_getTo()) />
	</cffunction>	
	
	<cffunction name="save" access="public" hint="I save the User record.  All of the Primary Key and required values must be provided and valid for this to work." output="false" returntype="void">
		<cfset _getDao().save(_getTo()) />
	</cffunction>	
	
	<cffunction name="delete" access="public" hint="I delete the User record.  All of the Primary Key values must be provided for this to work." output="false" returntype="void">
		<cfset _getDao().delete(_getTo()) />
		<!--- reset the to --->
		<cfset _setTo(_getReactorFactory().createTo("User")) />
	</cffunction>
	
	
			
	<!--- to --->
	<cffunction name="_setTo" access="public" output="false" returntype="void">
	    <cfargument name="to" hint="I am this record's transfer object." required="yes" type="ReactorBlogData.To.mysql.UserTo" />
	    <cfset variables.to = arguments.to />
	</cffunction>
	<cffunction name="_getTo" access="public" output="false" returntype="ReactorBlogData.To.mysql.UserTo">
		<cfreturn variables.to />
	</cffunction>	
	
	<!--- dao --->
	<cffunction name="_setDao" access="private" output="false" returntype="void">
	    <cfargument name="dao" hint="I am the Dao this Record uses to load and save itself." required="yes" type="ReactorBlogData.Dao.mysql.UserDao" />
	    <cfset variables.dao = arguments.dao />
	</cffunction>
	<cffunction name="_getDao" access="private" output="false" returntype="ReactorBlogData.Dao.mysql.UserDao">
	    <cfreturn variables.dao />
	</cffunction>
	
</cfcomponent>
	