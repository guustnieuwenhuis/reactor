
<!--- create the reactorFactory --->
<cfset Reactor = CreateObject("Component", "reactor.reactorFactory").init(expandPath("reactor.xml")) />

<!--- create an invoice record --->
<cfset InvoiceRecord = Reactor.createRecord("Invoice") />
<cfset InvoiceRecord.setInvoiceId(1) />
<cfset InvoiceRecord.load() />

<!--- output all the products on this invoice --->

<!--- get all of the Invoice Product Records --->
<cfset ProductQuery = InvoiceRecord.getProductQuery() />

<!--- get all the products on this invoice --->
<cfdump var="#ProductQuery#" />