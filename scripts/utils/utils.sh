# Common functions

set -e
set -u

export OK="0"
export FAIL="1"

check_status() {
	local ERR=$?
	echo -en "\e[65G"
        echo -en "["
	if [ $ERR = 0 ]; then
		echo -en "\e[1;32m"
                echo -en "  OK  "
	else
		echo -en "\e[1;31m"
                echo -en "FAILED"
	fi
	echo -en "\e[0;0m"
        echo -e "]"
}

show_status() {
        echo -en "\e[65G"
        echo -en "["
        if [ $1 = 0 ]; then
                echo -en "\e[1;32m"
                echo -en "  OK  "
        else
                echo -en "\e[1;31m"
                echo -en "FAILED"
        fi
        echo -en "\e[0;0m"
        echo -e "]"
}

locate_package() {
    echo $(find ${PACKAGES}/ -type d -name "$1")
}

#####
# Export functions
#####
export -f check_status
export -f show_status
export -f locate_package

