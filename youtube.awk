#
# youtube.awk: Small program to separate the audio and videos for download
#              using youtube-dl.
#              It parses the output of "youtebe-dl -F"
#
@include "getopt"

BEGIN {
    otype = "default"
    ofmt["default"] = "id: %s\naudio: %d\nvideo: %d\n"
    ofmt["csv"    ] = "%s,%d,%d\n"
    ofmt["json"   ] = "{ \"id\": \"%s\", \"audio\": %d, \"video\": %d }\n"
    ofmt["xml"    ] = "<id>%s</id><audio>%d</audio><video>%d</video>\n"

    while (c = getopt(ARGC, ARGV, "cjx") != -1) {
        switch (Optopt) {
            case "c" : otype = "csv"  ; break
            case "j" : otype = "json" ; break
            case "x" : otype = "xml"  ; break
            case "?" :
            default :
                print "Warning: Invalid Option: " Optopt
                print "       : " Opterr
        }
    }
    # clear the arguments list
    for (i = 1; i < Optind; i++) {
        ARGV[i] = ""
    }
}

"[youtube]" == $1 { id = substr($2, 1, length($2)-1) }
/audio only/      { audio[$2] = $1 }
/mp4|webm/  &&
"medium" == $4    { video[$2] = $1 }

END {
    acode = audio["webm"] ? audio["webm"] : audio["m4a"] ? audio["m4a"] : 0
    vcode = video["webm"] ? video["webm"] : video["mp4"] ? video["mp4"] : 0
    printf(ofmt[otype], id, acode, vcode)
}
