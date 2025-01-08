[[ $- =~ i ]] && {
    echo "\033[0;30m[$(date "+%a %d %b %Y %T")] \033[0mWelcome on \033[1;3<<HOST-COLOR>>m$HOST\033[0m, $USER!"
    echo "<<WELCOME-IMAGE>>"
}
