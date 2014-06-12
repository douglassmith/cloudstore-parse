BEGIN{
	if(headers == "true") {
		element="th"
	} else {
		element="td"
	}
}

/id='full-attributes-table/ {
	max = split($0, rows, "<tr>")
	
	
	# Note: ignoring first row as it is a header (Details)
	for (x = 2; x <= max; x++) {
		a = match(rows[x], "<"element">");
		b = match(rows[x], "</"element">")
		result = substr(rows[x], a+4, b-a-4);
		print (result);		
	}
}
