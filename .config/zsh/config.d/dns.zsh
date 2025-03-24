digall() {
	local domain=$1
	local -a types=(A AAAA CNAME MX NS TXT)

	echo "🔍 resolving $domain"
	for type in $types; do
		echo "\n$type records:"
		dog $domain $type
	done
}
