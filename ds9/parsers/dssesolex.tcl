package provide DS9 1.0

######
# Begin autogenerated fickle (version 2.1) routines.
# Although fickle itself is protected by the GNU Public License (GPL)
# all user-supplied functions are protected by their respective
# author's license.  See http://mini.net/tcl/fickle for other details.
######

namespace eval dsseso {
    variable yylval

    variable yytext {}
    variable yyleng 0
    variable yyin stdin
    variable yyout stdout
    variable yy_current_buffer {}

    variable yylineno 1

    variable index_ 0
    variable done_ 0
}

# ECHO copies yytext to the scanner's output if no arguments are
# given.  The scanner writes its ECHO output to the yyout global
# (default, stdout), which may be redefined by the user simply by
# assigning it to some other channel.
#   -- from the flex(1) man page
proc dsseso::ECHO {{s ""}} {
    variable yytext
    variable yyout

    if {$s == ""} {
        puts -nonewline $yyout $yytext
    } else {
        puts -nonewline $yyout $s
    }
}

# YY_FLUSH_BUFFER flushes the scanner's internal buffer so that the
# next time the scanner attempts to match a token, it will first
# refill the buffer using YY_INPUT.
#   -- from the flex(1) man page
proc dsseso::YY_FLUSH_BUFFER {} {
    variable yy_current_buffer
    variable index_
    variable done_

    set yy_current_buffer ""
    set index_ 0
    set done_ 0
}

# yyrestart(new_file) may be called to point yyin at the new input
# file.  The switch-over to the new file is immediate (any previously
# buffered-up input is lost).  Note that calling yyrestart with yyin
# as an argument thus throws away the current input buffer and
# continues scanning the same input file.
#   -- from the flex(1) man page
proc dsseso::yyrestart {new_file} {
    variable yyin

    set yyin $new_file
    YY_FLUSH_BUFFER
}

# The nature of how it gets its input can be controlled by defining
# the YY_INPUT macro.  YY_INPUT's calling sequence is
# "YY_INPUT(buf,result,max_size)".  Its action is to place up to
# max_size characters in the character array buf and return in the
# integer variable result either the number of characters read or the
# constant YY_NULL (0 on Unix systems) to indicate EOF.  The default
# YY_INPUT reads from the global file-pointer "yyin".
#   -- from the flex(1) man page
proc dsseso::YY_INPUT {buf result max_size} {
    variable yyin

    upvar $result ret_val
    upvar $buf new_data
    if {$yyin != ""} {
        set new_data [read $yyin $max_size]
        set ret_val [string length $new_data]
    } else {
        set new_data ""
        set ret_val 0
    }
}

# yy_scan_string sets up input buffers for scanning in-memory
# strings instead of files.  Note that switching input sources does
# not change the start condition.
#   -- from the flex(1) man page
proc dsseso::yy_scan_string {str} {
    variable yy_current_buffer
    variable yyin

    append yy_current_buffer $str
    set yyin ""
}

# unput(c) puts the character c back onto the input stream.  It will
# be the next character scanned.
#   -- from the flex(1) man page
proc dsseso::unput {c} {
    variable yy_current_buffer
    variable index_

    set s [string range $yy_current_buffer 0 [expr {$index_ - 1}]]
    append s $c
    set yy_current_buffer [append s [string range $yy_current_buffer $index_ end]]
}

# Returns all but the first n characters of the current token back to
# the input stream, where they will be rescanned when the scanner
# looks for the next match.  yytext and yyleng are adjusted
# appropriately.
#   -- from the flex(1) man page
proc dsseso::yyless {n} {
    variable yy_current_buffer
    variable index_
    variable yytext
    variable yyleng

    set s [string range $yy_current_buffer 0 [expr {$index_ - 1}]]
    append s [string range $yytext $n end]
    set yy_current_buffer [append s [string range $yy_current_buffer $index_ end]]
    set yytext [string range $yytext 0 [expr {$n - 1}]]
    set yyleng [string length $yytext]
}

# input() reads the next character from the input stream.
#   -- from the flex(1) man page
proc dsseso::input {} {
    variable yy_current_buffer
    variable index_
    variable done_

    if {[string length $yy_current_buffer] - $index_ < 1024} {
       set new_buffer ""
       set new_buffer_size 0
       if {$done_ == 0} {
           YY_INPUT new_buffer new_buffer_size 1024
           append yy_current_buffer $new_buffer
           if {$new_buffer_size == 0} {
               set done_ 1
           }
       }
       if $done_ {
           if {[string length $yy_current_buffer] - $index_ == 0} {
               return {}
           }
        }
    }
    set c [string index $yy_current_buffer $index_]
    incr index_
    return $c
}

######
# autogenerated yylex function created by fickle
######

# Whenever yylex() is called, it scans tokens from the global input
# file yyin (which defaults to stdin).  It continues until it either
# reaches an end-of-file (at which point it returns the value 0) or
# one of its actions executes a return statement.
#   -- from the flex(1) man page
proc dsseso::yylex {} {
    variable yylval

    variable yytext
    variable yylineno
    variable yyleng
    variable yy_current_buffer
    variable yy_flex_debug

    variable index_
    variable done_
    variable state_table_

set YES_ 257
set NO_ 258
set ON_ 259
set OFF_ 260
set TRUE_ 261
set FALSE_ 262
set CLEAR_ 263
set CLOSE_ 264
set COORD_ 265
set CROSSHAIR_ 266
set CURRENT_ 267
set FRAME_ 268
set NAME_ 269
set NEW_ 270
set OPEN_ 271
set UPDATE_ 272
set SAVE_ 273
set SIZE_ 274
set SURVEY_ 275
set DEGREES_ 276
set ARCMIN_ 277
set ARCSEC_ 278
set SEXAGESIMAL_ 279
set SEXSTR_ 280
set INT_ 281
set REAL_ 282
set STRING_ 283
set DSS1_ 284
set DSS2_RED_ 285
set DSS2_BLUE_ 286
set DSS2_INFRARED_ 287

    while {1} {
        if {[string length $yy_current_buffer] - $index_ < 1024} {
            if {$done_ == 0} {
	        set buffer_size 0
                set new_buffer ""
                YY_INPUT new_buffer buffer_size 1024
                append yy_current_buffer $new_buffer
                if {$buffer_size == 0 && \
                        [string length $yy_current_buffer] - $index_ == 0} {
                    set done_ 1
                }
            }
            if $done_ {
                if {[string length $yy_current_buffer] - $index_ == 0} {
                    break
                }
            }            
        }
        set yyleng 0
        set matched_rule -1
        # rule 0: dss1
        if {[regexp -start $index_ -indices -line -nocase -- {\A(dss1)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 0
        }
        # rule 1: dss2-red
        if {[regexp -start $index_ -indices -line -nocase -- {\A(dss2-red)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 1
        }
        # rule 2: dss2-blue
        if {[regexp -start $index_ -indices -line -nocase -- {\A(dss2-blue)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 2
        }
        # rule 3: dss2-infrared
        if {[regexp -start $index_ -indices -line -nocase -- {\A(dss2-infrared)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 3
        }
        # rule 4: yes
        if {[regexp -start $index_ -indices -line -nocase -- {\A(yes)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 4
        }
        # rule 5: no
        if {[regexp -start $index_ -indices -line -nocase -- {\A(no)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 5
        }
        # rule 6: on
        if {[regexp -start $index_ -indices -line -nocase -- {\A(on)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 6
        }
        # rule 7: off
        if {[regexp -start $index_ -indices -line -nocase -- {\A(off)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 7
        }
        # rule 8: true
        if {[regexp -start $index_ -indices -line -nocase -- {\A(true)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 8
        }
        # rule 9: false
        if {[regexp -start $index_ -indices -line -nocase -- {\A(false)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 9
        }
        # rule 10: clear
        if {[regexp -start $index_ -indices -line -nocase -- {\A(clear)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 10
        }
        # rule 11: close
        if {[regexp -start $index_ -indices -line -nocase -- {\A(close)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 11
        }
        # rule 12: coord
        if {[regexp -start $index_ -indices -line -nocase -- {\A(coord)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 12
        }
        # rule 13: crosshair
        if {[regexp -start $index_ -indices -line -nocase -- {\A(crosshair)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 13
        }
        # rule 14: current
        if {[regexp -start $index_ -indices -line -nocase -- {\A(current)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 14
        }
        # rule 15: frame
        if {[regexp -start $index_ -indices -line -nocase -- {\A(frame)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 15
        }
        # rule 16: name
        if {[regexp -start $index_ -indices -line -nocase -- {\A(name)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 16
        }
        # rule 17: new
        if {[regexp -start $index_ -indices -line -nocase -- {\A(new)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 17
        }
        # rule 18: open
        if {[regexp -start $index_ -indices -line -nocase -- {\A(open)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 18
        }
        # rule 19: save
        if {[regexp -start $index_ -indices -line -nocase -- {\A(save)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 19
        }
        # rule 20: size
        if {[regexp -start $index_ -indices -line -nocase -- {\A(size)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 20
        }
        # rule 21: survey
        if {[regexp -start $index_ -indices -line -nocase -- {\A(survey)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 21
        }
        # rule 22: update
        if {[regexp -start $index_ -indices -line -nocase -- {\A(update)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 22
        }
        # rule 23: degrees
        if {[regexp -start $index_ -indices -line -nocase -- {\A(degrees)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 23
        }
        # rule 24: arcmin
        if {[regexp -start $index_ -indices -line -nocase -- {\A(arcmin)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 24
        }
        # rule 25: arcsec
        if {[regexp -start $index_ -indices -line -nocase -- {\A(arcsec)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 25
        }
        # rule 26: sexagesimal
        if {[regexp -start $index_ -indices -line -nocase -- {\A(sexagesimal)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 26
        }
        # rule 27: [+-]?{D}+:{D}+:{D}+\.?
        if {[regexp -start $index_ -indices -line -nocase -- {\A([+-]?([0-9])+:([0-9])+:([0-9])+\.?)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 27
        }
        # rule 28: [+-]?{D}+:{D}+:{D}*\.{D}+
        if {[regexp -start $index_ -indices -line -nocase -- {\A([+-]?([0-9])+:([0-9])+:([0-9])*\.([0-9])+)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 28
        }
        # rule 29: [+-]?{D}+
        if {[regexp -start $index_ -indices -line -nocase -- {\A([+-]?([0-9])+)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 29
        }
        # rule 30: [+-]?{D}+\.?({E})?
        if {[regexp -start $index_ -indices -line -nocase -- {\A([+-]?([0-9])+\.?(([Ee][+-]?([0-9])+))?)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 30
        }
        # rule 31: [+-]?{D}*\.{D}+({E})?
        if {[regexp -start $index_ -indices -line -nocase -- {\A([+-]?([0-9])*\.([0-9])+(([Ee][+-]?([0-9])+))?)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 31
        }
        # rule 32: \"[^\"]*\"
        if {[regexp -start $index_ -indices -line -nocase -- {\A(\"[^\"]*\")} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 32
        }
        # rule 33: \'[^\']*\'
        if {[regexp -start $index_ -indices -line -nocase -- {\A(\'[^\']*\')} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 33
        }
        # rule 34: \{[^\}]*\}
        if {[regexp -start $index_ -indices -line -nocase -- {\A(\{[^\}]*\})} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 34
        }
        # rule 35: \S+\S+
        if {[regexp -start $index_ -indices -line -nocase -- {\A(\S+\S+)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 35
        }
        # rule 36: \s
        if {[regexp -start $index_ -indices -line -nocase -- {\A(\s)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 36
        }
        # rule 37: .
        if {[regexp -start $index_ -indices -line -nocase -- {\A(.)} $yy_current_buffer match] > 0 && \
                [lindex $match 1] - $index_ + 1 > $yyleng} {
            set yytext [string range $yy_current_buffer $index_ [lindex $match 1]]
            set yyleng [string length $yytext]
            set matched_rule 37
        }
        if {$matched_rule == -1} {
            set yytext [string index $yy_current_buffer $index_]
            set yyleng 1
        }
        incr index_ $yyleng
        # workaround for Tcl's circumflex behavior
        if {[string index $yytext end] == "\n"} {
            set yy_current_buffer [string range $yy_current_buffer $index_ end]
            set index_ 0
        }
        set numlines [expr {[llength [split $yytext "\n"]] - 1}]
        switch -- $matched_rule {
            0 {
return $DSS1_
            }
            1 {
return $DSS2_RED_
            }
            2 {
return $DSS2_BLUE_
            }
            3 {
return $DSS2_INFRARED_
            }
            4 {
return $YES_
            }
            5 {
return $NO_
            }
            6 {
return $ON_
            }
            7 {
return $OFF_
            }
            8 {
return $TRUE_
            }
            9 {
return $FALSE_
            }
            10 {
return $CLEAR_
            }
            11 {
return $CLOSE_
            }
            12 {
return $COORD_
            }
            13 {
return $CROSSHAIR_
            }
            14 {
return $CURRENT_
            }
            15 {
return $FRAME_
            }
            16 {
return $NAME_
            }
            17 {
return $NEW_
            }
            18 {
return $OPEN_
            }
            19 {
return $SAVE_
            }
            20 {
return $SIZE_
            }
            21 {
return $SURVEY_
            }
            22 {
return $UPDATE_
            }
            23 {
return $DEGREES_
            }
            24 {
return $ARCMIN_
            }
            25 {
return $ARCSEC_
            }
            26 {
return $SEXAGESIMAL_
            }
            27 -
            28 {
set yylval $yytext; return $SEXSTR_
            }
            29 {
set yylval $yytext; return $INT_
            }
            30 -
            31 {
set yylval $yytext; return $REAL_
            }
            32 {
set yylval [string range $yytext 1 end-1]; return $STRING_
            }
            33 {
set yylval [string range $yytext 1 end-1]; return $STRING_
            }
            34 {
set yylval [string range $yytext 1 end-1]; return $STRING_
            }
            35 {
set yylval $yytext; return $STRING_
            }
            36 {
# ignore whitespace
            }
            37 {
set yylval $yytext; return $yylval
            }
            default
                { puts stderr "unmatched token: $yytext"; exit -1 }
        }
        incr yylineno $numlines
    }
    return 0
}
######
# end autogenerated fickle functions
######

