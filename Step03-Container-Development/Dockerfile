FROM    alpine:3.20.1
RUN     apk update && apk add figlet
add     ./message /message
CMD     cat /message | figlet
