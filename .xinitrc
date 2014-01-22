setxkbmap -option ctrl:nocaps
redshift -m randr -d 4500K:3700K -l +30:+97 2>/dev/null &
go run ~/src/go/auscult/auscult.go "!!" &
exec i3
