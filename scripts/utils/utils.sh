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

pkg_error() {
    if [ -z "${ERR_MSG}" ]; then
        ERR_MSG="ERROR"
    fi
    if [ -z "${ERR_LOC}" ]; then
        ERR_LOC=""
    fi
    if [ -z "${ERR_ID}" ]; then
        ERR_ID=""
    fi
    error "${ERR_MSG} ${ERR_LOC} ${ERR_ID}"
}

fail_on_error() {
    ERR_ID="${1}"
    if [ "${ERR_ID}" != "0" ]; then
        pkg_error
    fi
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
export -f pkg_error
export -f fail_on_error
export -f locate_package

