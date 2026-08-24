%{
%}
#include def.tin

%start revealsend

%token BAR_
%token SPLIT_

%%

revealsend : {RevealSendCmd}
 | SPLIT_ {RevealSendCmdSplit}
 | BAR_ {RevealSendCmdBar}
 ;

%%

proc revealsend::yyerror {msg} {
     variable yycnt
     variable yy_current_buffer
     variable index_

     ParserError $msg $yycnt $yy_current_buffer $index_
}
