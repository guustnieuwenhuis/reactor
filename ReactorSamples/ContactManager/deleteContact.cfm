
<!--- load the emailAddress record --->
<cfset ContactRecord = Application.Reactor.createRecord("Contact").load(contactId=url.contactId) />

<!--- delete the contact's email addresses --->
<cfset ContactEmailAddressArray = ContactRecord.getEmailAddressIterator().getArray() />
<cfloop from="1" to="#ArrayLen(ContactEmailAddressArray)#" index="x">
	<cfset ContactEmailAddressArray[x].delete() />
</cfloop>

<!--- delete the contact's addresses --->
<cfset ContactAddressArray = ContactRecord.getAddressIterator().getArray() />
<cfloop from="1" to="#ArrayLen(ContactAddressArray)#" index="x">
	<cfset ContactAddressArray[x].delete() />
</cfloop>

<!--- delete the contact's phone number --->
<cfset ContactPhoneNumberArray = ContactRecord.getPhoneNumberIterator().getArray() />
<cfloop from="1" to="#ArrayLen(ContactPhoneNumberArray)#" index="x">
	<cfset ContactPhoneNumberArray[x].delete() />
</cfloop>

<cfset ContactRecord.delete() />

<cflocation url="index.cfm" />