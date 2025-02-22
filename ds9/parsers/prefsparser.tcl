package provide DS9 1.0

######
# Begin autogenerated taccle (version 1.3) routines.
# Although taccle itself is protected by the GNU Public License (GPL)
# all user-supplied functions are protected by their respective
# author's license.  See http://mini.net/tcl/taccle for other details.
######

namespace eval prefs {
    variable yylval {}
    variable table
    variable rules
    variable token {}
    variable yycnt 0
    variable yyerr 0
    variable save_state 0

    namespace export yylex
}

proc prefs::YYABORT {} {
    return -code return 1
}

proc prefs::YYACCEPT {} {
    return -code return 0
}

proc prefs::YYERROR {} {
    variable yyerr
    set yyerr 1
}

proc prefs::yyclearin {} {
    variable token
    variable yycnt
    set token {}
    incr yycnt -1
}

proc prefs::yyerror {s} {
    puts stderr $s
}

proc prefs::setupvalues {stack pointer numsyms} {
    upvar 1 1 y
    set y {}
    for {set i 1} {$i <= $numsyms} {incr i} {
        upvar 1 $i y
        set y [lindex $stack $pointer]
        incr pointer
    }
}

proc prefs::unsetupvalues {numsyms} {
    for {set i 1} {$i <= $numsyms} {incr i} {
        upvar 1 $i y
        unset y
    }
}

array set prefs::table {
  47:265 reduce
  27:0 reduce
  40:264,target 46
  9:288 goto
  8:287,target 27
  29:288 goto
  17:265 reduce
  23:265,target 31
  7:283,target 25
  0:275,target 13
  6:0,target 9
  2:0 reduce
  6:265 reduce
  12:265,target 16
  7:262,target 6
  34:263,target 43
  26:265 reduce
  24:0 reduce
  41:0,target 33
  45:0 reduce
  33:0,target 29
  46:265,target 2
  25:0,target 30
  3:265,target 5
  17:0,target 18
  9:268,target 29
  35:265 reduce
  35:265,target 27
  7:259,target 3
  7:260,target 4
  14:257 shift
  21:0 accept
  32:273,target 40
  14:258 shift
  14:259 shift
  14:260 shift
  42:0 reduce
  14:261 shift
  24:265,target 23
  14:262 shift
  8:283,target 25
  14:265 reduce
  53:263 shift
  13:265,target 17
  0:271,target 11
  8:262,target 6
  3:265 reduce
  7:257,target 1
  17:0 reduce
  23:265 reduce
  47:265,target 34
  38:0 reduce
  32:257 shift
  32:258 shift
  4:265,target 8
  32:260 shift
  32:259 shift
  32:261 shift
  3:0,target 5
  32:262 shift
  36:265,target 28
  32:265 reduce
  14:283 goto
  32:289,target 42
  8:259,target 3
  8:260,target 4
  45:0,target 1
  14:0 reduce
  30:0,target 22
  25:265,target 30
  22:0,target 10
  35:0 reduce
  14:0,target 3
  32:273 shift
  41:265 reduce
  24:261,target 5
  14:265,target 3
  0:257 shift
  0:258 shift
  50:263 shift
  49:263 shift
  0:260 shift
  0:259 shift
  0:261 shift
  0:266,target 7
  8:257,target 1
  32:283 goto
  0:262 shift
  32:0 reduce
  0:265 reduce
  5:265,target 6
  11:272 shift
  19:263 shift
  0:266 shift
  8:257 shift
  0:267 shift
  8:258 shift
  20:265 reduce
  32:289 goto
  24:258,target 2
  8:259 shift
  8:260 shift
  0:270 shift
  0:269 shift
  8:261 shift
  37:265,target 44
  0:271 shift
  8:262 shift
  0:274 shift
  8:265 shift
  0:275 shift
  6:0 reduce
  28:265 reduce
  0:276 shift
  26:265,target 19
  0:277 shift
  0:278 shift
  48:263,target 49
  28:0 reduce
  0:280 shift
  0:279 shift
  7:0,target 3
  0:281 shift
  0:0,target 13
  0:283 goto
  0:284 goto
  15:265,target 15
  37:265 shift
  0:286 goto
  0:283,target 20
  42:0,target 25
  14:261,target 5
  26:0,target 19
  3:0 reduce
  32:283,target 41
  0:262,target 6
  8:283 goto
  6:265,target 9
  46:265 reduce
  25:0 reduce
  8:287 goto
  46:0 reduce
  32:262,target 6
  16:263 shift
  38:265,target 20
  0:281,target 19
  14:258,target 2
  0:0 reduce
  27:265,target 21
  5:265 reduce
  50:263,target 51
  49:263,target 50
  0:260,target 4
  0:259,target 3
  25:265 reduce
  22:0 reduce
  22:285,target 37
  32:260,target 4
  32:259,target 3
  34:263 shift
  0:278,target 16
  4:0,target 8
  7:265,target 23
  0:257,target 1
  43:263 shift
  54:0,target 26
  39:265,target 23
  39:0 reduce
  46:0,target 2
  16:263,target 34
  38:0,target 20
  32:257,target 1
  31:0,target 24
  23:0,target 31
  13:265 reduce
  15:0,target 15
  52:263 shift
  28:265,target 32
  0:276,target 14
  51:263,target 52
  15:0 reduce
  2:265 reduce
  29:288,target 39
  17:265,target 18
  36:0 reduce
  22:265 reduce
  40:263,target 45
  0:274,target 12
  8:265,target 23
  31:265 reduce
  24:287,target 38
  40:282,target 47
  7:261,target 5
  12:0 reduce
  41:265,target 33
  33:0 reduce
  9:288,target 30
  40:263 shift
  40:264 shift
  54:0 reduce
  39:265 reduce
  30:265,target 22
  29:265,target 28
  8:0,target 3
  22:285 goto
  1:0,target 4
  52:263,target 53
  10:265 shift
  48:263 shift
  7:0 reduce
  7:258,target 2
  18:265,target 35
  35:0,target 27
  30:0 reduce
  27:0,target 21
  7:257 shift
  20:0,target 14
  7:258 shift
  12:0,target 16
  18:265 shift
  7:259 shift
  7:260 shift
  40:282 goto
  7:261 shift
  7:262 shift
  9:265,target 28
  0:270,target 10
  0:269,target 9
  4:0 reduce
  7:265 shift
  8:261,target 5
  42:265,target 25
  27:265 reduce
  24:283,target 25
  7:268 shift
  26:0 reduce
  47:0 reduce
  24:262,target 6
  10:288 goto
  31:265,target 24
  53:263,target 54
  36:265 reduce
  1:0 reduce
  0:267,target 8
  8:258,target 2
  20:265,target 14
  7:283 goto
  23:0 reduce
  45:265 reduce
  44:0 reduce
  5:0,target 6
  7:287 goto
  54:265,target 26
  24:260,target 4
  24:259,target 3
  0:286,target 22
  15:265 reduce
  24:257 shift
  24:258 shift
  54:265 reduce
  47:0,target 34
  24:260 shift
  24:259 shift
  10:288,target 31
  39:0,target 23
  24:261 shift
  32:0,target 3
  24:262 shift
  0:265,target 13
  11:272,target 32
  19:263,target 36
  4:265 reduce
  24:0,target 3
  20:0 reduce
  24:265 shift
  41:0 reduce
  32:265,target 3
  14:283,target 33
  24:257,target 1
  0:284,target 21
  14:262,target 6
  33:265 reduce
  43:263,target 48
  10:265,target 28
  42:265 reduce
  24:283 goto
  24:287 goto
  12:265 reduce
  14:259,target 3
  14:260,target 4
  51:263 shift
  1:265,target 4
  7:268,target 24
  0:261,target 5
  13:0 reduce
  2:0,target 7
  33:265,target 29
  1:265 reduce
  32:261,target 5
  44:0,target 12
  7:287,target 26
  36:0,target 28
  22:265,target 11
  28:0,target 32
  0:280,target 18
  0:279,target 17
  9:265 shift
  14:257,target 1
  21:0,target 0
  13:0,target 17
  30:265 reduce
  29:265 shift
  8:0 reduce
  9:268 shift
  0:258,target 2
  31:0 reduce
  32:258,target 2
  38:265 reduce
  45:265,target 1
  2:265,target 7
  0:277,target 15
  5:0 reduce
}

array set prefs::rules {
  9,l 283
  11,l 285
  32,l 288
  6,l 283
  28,l 286
  3,l 283
  25,l 286
  0,l 290
  22,l 286
  18,l 286
  15,l 286
  12,l 284
  33,l 289
  7,l 283
  29,l 286
  30,l 287
  4,l 283
  26,l 286
  1,l 282
  23,l 286
  19,l 286
  20,l 286
  16,l 286
  13,l 286
  34,l 289
  8,l 283
  10,l 284
  31,l 287
  5,l 283
  27,l 286
  2,l 282
  24,l 286
  21,l 286
  17,l 286
  14,l 286
}

array set prefs::rules {
  12,dc 3
  26,dc 10
  3,dc 0
  18,dc 1
  33,dc 1
  9,dc 1
  11,dc 0
  25,dc 3
  2,dc 1
  17,dc 1
  32,dc 1
  8,dc 1
  10,dc 1
  24,dc 2
  1,dc 1
  16,dc 1
  31,dc 1
  7,dc 1
  23,dc 3
  0,dc 1
  15,dc 1
  29,dc 2
  30,dc 1
  6,dc 1
  22,dc 2
  14,dc 1
  28,dc 2
  5,dc 1
  21,dc 2
  13,dc 0
  27,dc 2
  4,dc 1
  19,dc 2
  20,dc 3
  34,dc 2
}

array set prefs::rules {
  7,line 62
  4,line 59
  34,line 103
  1,line 55
  31,line 96
  27,line 90
  24,line 86
  21,line 82
  17,line 77
  14,line 74
  11,line 67
  9,line 64
  6,line 61
  3,line 58
  33,line 102
  29,line 92
  30,line 95
  26,line 89
  23,line 84
  19,line 80
  20,line 81
  16,line 76
  13,line 72
  10,line 67
  8,line 63
  5,line 60
  2,line 56
  32,line 99
  28,line 91
  25,line 87
  22,line 83
  18,line 79
  15,line 75
  12,line 68
  11,e 1
}

array set prefs::lr1_table {
  35 {{27 {0 265} 2}}
  36 {{28 {0 265} 2}}
  14,trans {{257 1} {258 2} {259 3} {260 4} {261 5} {262 6} {283 33}}
  33,trans {}
  37 {{12 0 2}}
  52,trans {{263 53}}
  38 {{20 {0 265} 3}}
  40 {{34 {0 265} 1} {1 {0 265} 0} {2 {0 265} 0}}
  39 {{23 {0 265} 3}}
  41 {{33 {0 265} 1}}
  18,trans {{265 35}}
  1,trans {}
  37,trans {{265 44}}
  42 {{25 {0 265} 3}}
  43 {{26 {0 265} 3}}
  44 {{12 0 3}}
  45 {{1 {0 265} 1}}
  23,trans {}
  5,trans {}
  42,trans {}
  46 {{2 {0 265} 1}}
  47 {{34 {0 265} 2}}
  48 {{26 {0 265} 4}}
  50 {{26 {0 265} 6}}
  49 {{26 {0 265} 5}}
  27,trans {}
  9,trans {{265 28} {268 29} {288 30}}
  51 {{26 {0 265} 7}}
  46,trans {}
  52 {{26 {0 265} 8}}
  53 {{26 {0 265} 9}}
  13,trans {}
  54 {{26 {0 265} 10}}
  32,trans {{257 1} {258 2} {259 3} {260 4} {261 5} {262 6} {273 40} {283 41} {289 42}}
  51,trans {{263 52}}
  17,trans {}
  0,trans {{257 1} {258 2} {259 3} {260 4} {261 5} {262 6} {266 7} {267 8} {269 9} {270 10} {271 11} {274 12} {275 13} {276 14} {277 15} {278 16} {279 17} {280 18} {281 19} {283 20} {284 21} {286 22}}
  36,trans {}
  22,trans {{285 37}}
  4,trans {}
  41,trans {}
  26,trans {}
  8,trans {{257 1} {258 2} {259 3} {260 4} {261 5} {262 6} {265 23} {283 25} {287 27}}
  45,trans {}
  12,trans {}
  31,trans {}
  50,trans {{263 51}}
  49,trans {{263 50}}
  16,trans {{263 34}}
  35,trans {}
  54,trans {}
  21,trans {}
  3,trans {}
  40,trans {{263 45} {264 46} {282 47}}
  39,trans {}
  10 {{24 {0 265} 1} {32 {0 265} 0}}
  11 {{25 {0 265} 1}}
  25,trans {}
  12 {{16 {0 265} 1}}
  7,trans {{257 1} {258 2} {259 3} {260 4} {261 5} {262 6} {265 23} {268 24} {283 25} {287 26}}
  44,trans {}
  13 {{17 {0 265} 1}}
  14 {{29 {0 265} 1} {3 {0 265} 0} {4 {0 265} 0} {5 {0 265} 0} {6 {0 265} 0} {7 {0 265} 0} {8 {0 265} 0} {9 {0 265} 0}}
  15 {{15 {0 265} 1}}
  11,trans {{272 32}}
  30,trans {}
  29,trans {{265 28} {288 39}}
  16 {{26 {0 265} 1}}
  48,trans {{263 49}}
  0 {{0 0 0} {10 0 0} {12 0 0} {13 {0 265} 0} {14 {0 265} 0} {15 {0 265} 0} {16 {0 265} 0} {17 {0 265} 0} {18 {0 265} 0} {19 {0 265} 0} {20 {0 265} 0} {21 {0 265} 0} {22 {0 265} 0} {23 {0 265} 0} {24 {0 265} 0} {25 {0 265} 0} {26 {0 265} 0} {27 {0 265} 0} {28 {0 265} 0} {29 {0 265} 0} {3 {0 265} 0} {4 {0 265} 0} {5 {0 265} 0} {6 {0 265} 0} {7 {0 265} 0} {8 {0 265} 0} {9 {0 265} 0}}
  17 {{18 {0 265} 1}}
  1 {{4 {0 265} 1}}
  18 {{27 {0 265} 1}}
  15,trans {}
  2 {{7 {0 265} 1}}
  19 {{28 {0 265} 1}}
  20 {{14 {0 265} 1}}
  34,trans {{263 43}}
  3 {{5 {0 265} 1}}
  21 {{0 0 1}}
  53,trans {{263 54}}
  4 {{8 {0 265} 1}}
  22 {{10 0 1} {12 0 1} {11 265 0}}
  5 {{6 {0 265} 1}}
  23 {{31 {0 265} 1}}
  20,trans {}
  19,trans {{263 36}}
  6 {{9 {0 265} 1}}
  2,trans {}
  24 {{20 {0 265} 2} {30 {0 265} 0} {31 {0 265} 0} {3 {0 265} 0} {4 {0 265} 0} {5 {0 265} 0} {6 {0 265} 0} {7 {0 265} 0} {8 {0 265} 0} {9 {0 265} 0}}
  38,trans {}
  7 {{19 {0 265} 1} {20 {0 265} 1} {30 {0 265} 0} {31 {0 265} 0} {3 {0 265} 0} {4 {0 265} 0} {5 {0 265} 0} {6 {0 265} 0} {7 {0 265} 0} {8 {0 265} 0} {9 {0 265} 0}}
  25 {{30 {0 265} 1}}
  8 {{21 {0 265} 1} {30 {0 265} 0} {31 {0 265} 0} {3 {0 265} 0} {4 {0 265} 0} {5 {0 265} 0} {6 {0 265} 0} {7 {0 265} 0} {8 {0 265} 0} {9 {0 265} 0}}
  26 {{19 {0 265} 2}}
  9 {{22 {0 265} 1} {23 {0 265} 1} {32 {0 265} 0}}
  27 {{21 {0 265} 2}}
  24,trans {{257 1} {258 2} {259 3} {260 4} {261 5} {262 6} {265 23} {283 25} {287 38}}
  6,trans {}
  28 {{32 {0 265} 1}}
  43,trans {{263 48}}
  29 {{23 {0 265} 2} {32 {0 265} 0}}
  30 {{22 {0 265} 2}}
  31 {{24 {0 265} 2}}
  10,trans {{265 28} {288 31}}
  32 {{25 {0 265} 2} {33 {0 265} 0} {34 {0 265} 0} {3 {0 265} 0} {4 {0 265} 0} {5 {0 265} 0} {6 {0 265} 0} {7 {0 265} 0} {8 {0 265} 0} {9 {0 265} 0}}
  28,trans {}
  33 {{29 {0 265} 2}}
  47,trans {}
  34 {{26 {0 265} 2}}
}

array set prefs::token_id_table {
  286,t 1
  286 prefs
  280,title THEME
  279,title SAVE
  264,line 17
  287 bg
  270,t 0
  269,t 0
  288 nan
  290 start'
  289 autosave
  276,line 34
  265,title string
  284,title {}
  274,t 0
  261,line 11
  288,line 98
  257,t 0
  270,title NANCOLOR
  269,title NAN
  288,title {}
  273,line 31
  278,t 0
  257,line 7
  262,t 0
  285,line 67
  274,title CLEAR
  283,t 1
  270,line 27
  269,line 26
  259,title ON
  260,title OFF
  266,t 0
  278,title PRECISION
  282,line 54
  287,t 1
  error error
  271,t 0
  264,title float
  266,line 23
  283,title {}
  278,line 36
  error,line 53
  275,t 0
  268,title COLOR
  287,title {}
  258,t 0
  263,line 16
  error,title {}
  280,t 0
  279,t 0
  275,line 33
  273,title INTERVAL
  263,t 0
  259,line 9
  260,line 10
  287,line 94
  258,title NO
  284,t 1
  277,title OPEN
  272,line 30
  267,t 0
  263,title integer
  288,t 1
  284,line 66
  282,title {}
  272,t 0
  268,line 25
  267,title BGCOLOR
  286,title {}
  257 YES_
  281,line 39
  276,t 0
  258 NO_
  259,t 0
  259 ON_
  260 OFF_
  260,t 0
  272,title RECOVERY
  261 TRUE_
  265,line 19
  262 FALSE_
  281,t 0
  263 INT_
  277,line 35
  257,title YES
  264 REAL_
  264,t 0
  276,title IRAFALIGN
  265 STRING_
  262,line 12
  266 BACKGROUND_
  290,line 104
  289,line 101
  285,t 1
  267 BGCOLOR_
  0,t 0
  0 {$}
  262,title FALSE
  268 COLOR_
  268,t 0
  281,title THREADS
  274,line 32
  270 NANCOLOR_
  269 NAN_
  error,t 0
  271 AUTO_
  290,t 1
  289,t 1
  272 RECOVERY_
  258,line 8
  286,line 70
  273,t 0
  273 INTERVAL_
  266,title BACKGROUND
  285,title {}
  274 CLEAR_
  275 CLOSE_
  271,line 29
  276 IRAFALIGN_
  277,t 0
  277 OPEN_
  271,title AUTO
  290,title {}
  289,title {}
  283,line 57
  278 PRECISION_
  261,t 0
  280 THEME_
  279 SAVE_
  281 THREADS_
  267,line 24
  282,t 1
  282 numeric
  275,title CLOSE
  283 yesno
  265,t 0
  284 command
  280,line 38
  279,line 37
  285 @PSEUDO1
  261,title TRUE
}

proc prefs::yyparse {} {
    variable yylval
    variable table
    variable rules
    variable token
    variable yycnt
    variable lr1_table
    variable token_id_table
    variable yyerr
    variable save_state

    set yycnt 0
    set state_stack {0}
    set value_stack {{}}
    set token ""
    set accepted 0
    set yyerr 0
    set save_state 0

    while {$accepted == 0} {
        set state [lindex $state_stack end]
        if {$token == ""} {
            set yylval ""
            set token [yylex]
            set buflval $yylval
	    if {$token>0} {
	        incr yycnt
            }
        }
        if {![info exists table($state:$token)] || $yyerr} {
	    if {!$yyerr} {
	        set save_state $state
	    }
            # pop off states until error token accepted
            while {[llength $state_stack] > 0 && \
                       ![info exists table($state:error)]} {
                set state_stack [lrange $state_stack 0 end-1]
                set value_stack [lrange $value_stack 0 \
                                       [expr {[llength $state_stack] - 1}]]
                set state [lindex $state_stack end]
            }
            if {[llength $state_stack] == 0} {
 
	        set rr { }
                if {[info exists lr1_table($save_state,trans)] && [llength $lr1_table($save_state,trans)] >= 1} {
                    foreach trans $lr1_table($save_state,trans) {
                        foreach {tok_id nextstate} $trans {
			    set ss $token_id_table($tok_id,title)
			    if {$ss != {}} {
			        append rr "$ss, "
                            }
                        }
                    }
                }
		set rr [string trimleft $rr { }]
		set rr [string trimright $rr {, }]
                yyerror "parse error, expecting: $rr"


                return 1
            }
            lappend state_stack [set state $table($state:error,target)]
            lappend value_stack {}
            # consume tokens until it finds an acceptable one
            while {![info exists table($state:$token)]} {
                if {$token == 0} {
                    yyerror "end of file while recovering from error"
                    return 1
                }
                set yylval {}
                set token [yylex]
                set buflval $yylval
            }
            continue
        }
        switch -- $table($state:$token) {
            shift {
                lappend state_stack $table($state:$token,target)
                lappend value_stack $buflval
                set token ""
            }
            reduce {
                set rule $table($state:$token,target)
                set ll $rules($rule,l)
                if {[info exists rules($rule,e)]} {
                    set dc $rules($rule,e)
                } else {
                    set dc $rules($rule,dc)
                }
                set stackpointer [expr {[llength $state_stack]-$dc}]
                setupvalues $value_stack $stackpointer $dc
                set _ $1
                set yylval [lindex $value_stack end]
                switch -- $rule {
                    1 { set _ $1 }
                    2 { set _ $1 }
                    3 { set _ 1 }
                    4 { set _ 1 }
                    5 { set _ 1 }
                    6 { set _ 1 }
                    7 { set _ 0 }
                    8 { set _ 0 }
                    9 { set _ 0 }
                    11 { global ds9; if {!$ds9(init)} {YYERROR} else {yyclearin; YYACCEPT} }
                    13 { PrefsDialog }
                    15 { PrefsDialog }
                    16 { ClearPrefs }
                    17 { PrefsDialogClose }
                    18 { PrefsDialogSave }
                    26 { ProcessCmdSet pds9 prec,linear $2; ProcessCmdSet pds9 prec,deg $3; ProcessCmdSet pds9 prec,hms $4; ProcessCmdSet pds9 prec,dms $5; ProcessCmdSet pds9 prec,len,linear $6; ProcessCmdSet pds9 prec,len,deg $7; ProcessCmdSet pds9 prec,len,arcmin $8; ProcessCmdSet pds9 prec,len,arcsec $9; ProcessCmdSet pds9 prec,angle $10; PrefsPrecision }
                    27 { ProcessCmdSet pds9 theme $2 ThemeChange }
                    28 { ProcessCmdSet ds9 threads $2 ChangeThreads }
                    29 { ProcessCmdSet pds9 iraf $2 PrefsIRAFAlign }
                    30 { ProcessCmdSet pds9 bg,use $1 PrefsBgColor }
                    31 { ProcessCmdSet pds9 bg $1 PrefsBgColor }
                    32 { ProcessCmdSet pds9 nan $1 PrefsNanColor }
                    33 { ProcessCmdSet pds9 autosave $1; AutoSave }
                    34 { ProcessCmdSet pds9 autosave,interval $2; AutoSave }
                }
                unsetupvalues $dc
                # pop off tokens from the stack if normal rule
                if {![info exists rules($rule,e)]} {
                    incr stackpointer -1
                    set state_stack [lrange $state_stack 0 $stackpointer]
                    set value_stack [lrange $value_stack 0 $stackpointer]
                }
                # now do the goto transition
                lappend state_stack $table([lindex $state_stack end]:$ll,target)
                lappend value_stack $_
            }
            accept {
                set accepted 1
            }
            goto -
            default {
                puts stderr "Internal parser error: illegal command $table($state:$token)"
                return 2
            }
        }
    }
    return 0
}

######
# end autogenerated taccle functions
######

proc prefs::yyerror {msg} {
     variable yycnt
     variable yy_current_buffer
     variable index_

     ParserError $msg $yycnt $yy_current_buffer $index_
}
