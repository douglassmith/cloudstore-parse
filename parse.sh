#!/bin/sh


SERVICE_IDS=$1

rm attr_results.tsv
rm supp_results.tsv


# Loop through IDs, fetch the html and parse
IFS=',' read -ra IDS <<< "$SERVICE_IDS"
for i in "${IDS[@]}"; do
	
	# retrieve the html
	wget "http://govstore.service.gov.uk/cloudstore/"$i
	
	
	#### Parse Supplier Attributes
	# if first time, parse the headers
	if [[ ! -f attr_results.tsv ]]; then
		cat $i | awk -v headers=true -f gcloud_attributes.awk > attr_results.tsv
	fi

	# parse the attributes
	cat $i | awk -f gcloud_attributes.awk > attributes.tsv

	# append the attributes to our results
	cp attr_results.tsv working.tsv
	paste --delimiters="\t" working.tsv attributes.tsv > attr_results.tsv
	
	
	
	#### Parse Supplier info
	# parse the supplier info
	if [[ ! -f supp_results.tsv ]]; then
		cat $i | awk -v headers=true -f gcloud_supplier.awk > supp_results.tsv
	else
		cat $i | awk -f gcloud_supplier.awk > supplier.tsv
		cp supp_results.tsv working.tsv
		paste --delimiters="\t" working.tsv supplier.tsv > supp_results.tsv
	fi
	
done