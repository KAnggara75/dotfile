IDEA=''

main() {
	echo '#!/bin/sh' >bin/idea
	echo '' >>bin/idea

	# Check Idea CE or Ultimate
	if ls /Applications | grep -q 'IntelliJ IDEA.app'; then
		IDEA='open -na "IntelliJ IDEA.app" --args nosplash "$@"'
	elif ls /Applications | grep -q 'IntelliJ IDEA CE.app'; then
		IDEA='open -na "IntelliJ IDEA CE.app" --args nosplash "$@"'
	fi

	echo $IDEA >>bin/idea

	chmod +x bin/idea
}

main
