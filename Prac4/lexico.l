D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include <stdio.h>

%}

%%
"/*"			{ printf("<comment>"); }

"auto"			{ printf("<auto>"); }
"break"			{ printf("<break>"); }
"case"			{ printf("<case>"); }
"char"			{ printf("<char>"); }
"const"			{ printf("<const>"); }
"continue"		{ printf("<continue>"); }
"default"		{ printf("<default>"); }
"do"			{ printf("<do>"); }
"double"		{ printf("<double>"); }
"else"			{ printf("<else>"); }
"enum"			{ printf("<enum>"); }
"extern"		{ printf("<extern>"); }
"float"			{ printf("<float>"); }
"for"			{ printf("<for>"); }
"goto"			{ printf("<goto>"); }
"if"			{ printf("<if>"); }
"int"			{ printf("<int>"); }
"long"			{ printf("<long>"); }
"register"		{ printf("<register>"); }
"return"		{ printf("<return>"); }
"short"			{ printf("<short>"); }
"signed"		{ printf("<signed>"); }
"sizeof"		{ printf("<sizeof>"); }
"static"		{ printf("<static>"); }
"struct"		{ printf("<struct>"); }
"switch"		{ printf("<switch>"); }
"typedef"		{ printf("<typedef>"); }
"union"			{ printf("<union>"); }
"unsigned"		{ printf("<unsigned>"); }
"void"			{ printf("<void>"); }
"volatile"		{ printf("<volatile>"); }
"while"			{ printf("<while>"); }

{L}({L}|{D})*		{ printf("<var>"); }

0[xX]{H}+{IS}?		{ printf("<constant>"); }
0{D}+{IS}?		{ printf("<constant>"); }
{D}+{IS}?		{ printf("<constant>"); }
L?'(\\.|[^\\'])+'	{ printf("<constant>"); }

{D}+{E}{FS}?		{ printf("<constant>"); }
{D}*"."{D}+({E})?{FS}?	{ printf("<constant>"); }
{D}+"."{D}*({E})?{FS}?	{ printf("<constant>"); }

L?\"(\\.|[^\\"])*\"	{ printf("<string_literal>"); }

"..."			{ printf("<ellipsis>"); }
">>="			{ printf("<right_assign>"); }
"<<="			{ printf("<left_assign>"); }
"+="			{ printf("<add_assign>"); }
"-="			{ printf("<sub_assign>"); }
"*="			{ printf("<mul_assign>"); }
"/="			{ printf("<div_assign>"); }
"%="			{ printf("<mod_assign>"); }
"&="			{ printf("<and_assign>"); }
"^="			{ printf("<xor_assign>"); }
"|="			{ printf("<or_assign>"); }
">>"			{ printf("<right_op>"); }
"<<"			{ printf("<left_op>"); }
"++"			{ printf("<inc_op>"); }
"--"			{ printf("<dec_op>"); }
"->"			{ printf("<ptr_op>"); }
"&&"			{ printf("<and_op>"); }
"||"			{ printf("<or_op>"); }
"<="			{ printf("<le_op>"); }
">="			{ printf("<ge_op>"); }
"=="			{ printf("<eq_op>"); }
"!="			{ printf("<ne_op>"); }
";"			{ printf("<;>"); }
("{"|"<%")		{ printf("{"); }
("}"|"%>")		{ printf("}"); }
","			{ printf(","); }
":"			{ printf(":"); }
"="			{ printf("="); }
"("			{ printf("("); }
")"			{ printf(")"); }
("["|"<:")		{ printf("["); }
("]"|":>")		{ printf("]"); }
"."			{ printf("."); }
"&"			{ printf("&"); }
"!"			{ printf("!"); }
"~"			{ printf("~"); }
"-"			{ printf("-"); }
"+"			{ printf("+"); }
"*"			{ printf("*"); }
"/"			{ printf("/"); }
"%"			{ printf("%"); }
"<"			{ printf("<"); }
">"			{ printf(">"); }
"^"			{ printf("^"); }
"|"			{ printf("|"); }
"?"			{ printf("?"); }

[ \t\v\n\f]		{ printf(""); }
.			{ /* ignore bad characters */ }

%%

yywrap(){
	return (1);
}