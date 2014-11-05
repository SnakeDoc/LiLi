# Common functions

export OK="0"
export FAIL="1"

check_status() {
	local ERR=$?
	echo -en "\e[65G"
        echo -en "["
	if [ $ERR = 0 ]; then
		echo -en "\e[1;92m"
                echo -en "  OK  "
	else
		echo -en "\e[1;91m"
                echo -en "FAILED"
	fi
	echo -en "\e[0;0m"
        echo -e "]"
}

show_status() {
        echo -en "\e[65G"
        echo -en "["
        if [ $1 = 0 ]; then
                echo -en "\e[1;92m"
                echo -en "  OK  "
        else
                echo -en "\e[1;91m"
                echo -en "FAILED"
        fi
        echo -en "\e[0;0m"
        echo -e "]"
}

error() {
    echo "$1"
    echo "Error Code: $3"
    echo -n "Build $2: "
    show_status ${FAIL}
}

locate_package() {
    echo $(find ${PACKAGES}/ -type d -name "$1")
}

#####
# Export functions
#####
export -f check_status
export -f show_status
export -f error
export -f locate_package

