BEGIN {
	inVendorTable="false";	# Are we in the context of the html table containing the supplier info
	parsedHeader="false"	# Used to indicate if we have skipped the first <td> tag that contains the label (each row has 2 columns, 1 label, 1 value)
	parsingValue="false"	# Used to indicate that we are processing a <td> element containing a value (required as address spans multiple lines)
}


/<\/tr>/ {
	# reset at the end of a row	
	inVendorTable="false"
	parsedHeader="false"
	parsedValue="false"
}

/<tr class="vendor-table-/ {
	inVendorTable="true"
}

inVendorTable=="true" && parsedHeader=="true" {
	start = match($0, "<td>");
	end = match($0, "</td>")
	result = substr($0, start+4, end-start-4);
	
	gsub(/<br\/>/, ",", result);	# remove html breaks from the address
	sub(/^[ \t]+/, "", result)		# remove leading whitespace from the address fields
	
	# Parse the link if necessary
	start = match(result, "href='");
	if(start >0) {
		end = match(result, "'>")
		result = substr(result, start+6, end-start-6);
	}
	
	printf result
}

/<\/td>/ && inVendorTable=="true" && parsedHeader=="true" {
	print ""
}

/<td>/ && inVendorTable=="true" && parsedHeader=="false" {
	parsedHeader="true"
	
	if(headers=="true") {
		start = match($0, "<td>");
		end = match($0, "</td>")
		result = substr($0, start+4, end-start-4);
		printf (result  "\t");
	}	
}





