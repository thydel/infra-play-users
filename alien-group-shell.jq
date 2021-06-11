if .done == false then "ssh root@\(.node) adduser \(.user) \(.group)" else empty end
