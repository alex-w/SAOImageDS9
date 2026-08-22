%{
%}
#include def.tin

#include yesno.tin
#include numeric.tin
#include string.tin

%start command

%token BAR_
%token SPLIT_

%%

#include yes-no.trl
#include numeric.trl

command : reveal 
 | reveal {global ds9; if {!$ds9(init)} {YYERROR} else {yyclearin; YYACCEPT}} STRING_
 ;

reveal : {ProcessCmdSet current display reveal DisplayMode}
 | yes {ProcessCmdSet current display reveal DisplayMode}
 | no {ProcessCmdSet current display single DisplayMode}
 | SPLIT_ numeric {ProcessCmdSet reveal split $2 RevealUpdateClip}
 | BAR_ revealBar {ProcessCmdSet view reveal,bar $2 RevealBarUpdate}
 ;

revealBar : {set _ 1}
 | yes {set _ 1}
 | no {set _ 0}
 ;

%%

proc reveal::yyerror {msg} {
     variable yycnt
     variable yy_current_buffer
     variable index_

     ParserError $msg $yycnt $yy_current_buffer $index_
}
