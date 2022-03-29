lexer grammar FerrousLexer;

/*
 * Official ANTLR grammar file for the Ferrous programming
 * language by Karma Krafts & associates.
 *
 * Version: 1.0
 * Author(s):
 *	Alexander 'KitsuneAlex' Hinze
 */

// ------------------------------ Whitespace and comments (getting rid of them)
LINE_COMMENT:	'//' ~[\r\n]*                   -> channel(HIDDEN);
BLOCK_COMMENT:  '/*' (BLOCK_COMMENT | .)*? '*/' -> channel(HIDDEN);
WS:             [\u0020\u0009\u000C]            -> skip;
NL:             ('\n' | ('\r' '\n'?))           -> skip;

// ------------------------------ Quoted stuff
RAW_STRING:     'R"' -> pushMode(M_RAW_STRING);
DOUBLE_QUOTE:   '"' -> pushMode(M_STRING);

// ------------------------------ Parenthese of all variations
L_PAREN:		'(' -> pushMode(M_INSIDE);
R_PAREN:		')' -> popMode;
L_CRL_PAREN:	'{' -> pushMode(M_INSIDE);
R_CRL_PAREN:    '}' -> popMode;
L_SQR_PAREN:	'[' -> pushMode(M_INSIDE);
R_SQR_PAREN:	']' -> popMode;

// ------------------------------ Pre-Compiler Keywords
PC_KW_CONTINUE:	'!continue';
PC_KW_DISCARD:  '!discard';
PC_KW_DEFINE:   '!define';
PC_KW_ASSERT:	'!assert';
PC_KW_YIELD:    '!yield';
PC_KW_UNDEF:	'!undef';
PC_KW_BREAK:	'!break';
PC_KW_MACRO:	'!macro';
PC_KW_WHEN:     '!when';
PC_KW_ELIF:	    '!elif';
PC_KW_ELSE:		'!else';
PC_KW_CONJ:		'!conj';
PC_KW_DISJ:		'!disj';
PC_KW_END:		'!end';
PC_KW_FOR:		'!for';
PC_KW_FIR:		'!fir';
PC_KW_IF:		'!if';

// ------------------------------ Built-in type keywords
KW_TYPE_NUINT:  'nuint';    // Unsigned platform-dependent size type (size_t in C/C++), only usable in conjunction with unsafe
KW_TYPE_NINT:   'nint';     // Signed platform-dependent size type (offset_t in C/C++), only usable in conjunction with unsafe
KW_TYPE_VOID:   'void';     // u0, praise the king!
KW_TYPE_BOOL:   'bool';    
KW_TYPE_CHAR:   'char';     // This is the only implicitly platform-dependent type; 16 bits on the JVM, 32 bits on bare metal
KW_TYPE_I64:    'i64';
KW_TYPE_I32:    'i32';
KW_TYPE_I16:    'i16';
KW_TYPE_I8:     'i8';
KW_TYPE_U64:    'u64';
KW_TYPE_U32:    'u32';
KW_TYPE_U16:    'u16';
KW_TYPE_U8:     'u8';
KW_TYPE_F64:    'f64';
KW_TYPE_F32:    'f32';

// ------------------------------ Keywords
KW_STACKALLOC:  'stackalloc';
KW_UNMANAGED:   'unmanaged';
KW_CONSTRUCT:   'construct';
KW_INTERFACE:   'interface';
KW_BITFIELD:    'bitfield';
KW_CONTINUE:    'continue';
KW_DESTRUCT:    'destruct';
KW_ABSTRACT:    'abstract';
KW_OVERRIDE:    'override';
KW_DISCARD:     'discard';
KW_ALIGNOF:     'alignof';
KW_LITERAL:     'literal';
KW_RETURN:      'return';
KW_INTERN:      'intern';
KW_GLOBAL:      'global';
KW_STATIC:      'static';
KW_EXTERN:      'extern';
KW_UNSAFE:      'unsafe';
KW_STRUCT:      'struct';
KW_ATTRIB:      'attrib';
KW_RECORD:      'record';
KW_OBJECT:      'object';
KW_TYPEOF:      'typeof';
KW_SIZEOF:      'sizeof';
KW_DELETE:      'delete';
KW_ALIGN:       'align';
KW_IDENT:       'ident';
KW_TRAIT:       'trait';
KW_BREAK:       'break';
KW_YIELD:       'yield';
KW_CLASS:       'class';
KW_ALLOC:       'alloc';
KW_CONST:       'const';
KW_TYPE:        'type';
KW_EXPR:        'expr';
KW_NULL:        'null';
KW_FREE:        'free';
KW_ENUM:        'enum';
KW_WHEN:        'when';
KW_OPEN:        'open';
KW_THIS:        'this';
KW_SELF:        'self';
KW_ELSE:        'else';
KW_PRIV:        'priv';
KW_PROT:        'prot';
KW_INL:         'inl';
KW_PUB:         'pub';
KW_NEW:         'new';
KW_OUT:         'out';
KW_LET:         'let';
KW_MUT:         'mut';
KW_IF:          'if';
KW_FN:          'fn';
KW_OP:          'op';
KW_AS_SAFE:     'as?';
KW_AS:          'as';
KW_IS_NOT:      '!is';
KW_IS:          'is';
KW_IN_NOT:      '!in';
KW_IN:          'in';

// ------------------------------ General non-alphanumerical character (combinations) reused throughout the language
TRIPLE_EQ: 			'===';
ARROW:				'->';
DOUBLE_ARROW:		'=>';
DOUBLE_EQ: 			'==';
ASSIGN: 			'=';
TRIPLE_DOT:			'...';
DOUBLE_DOT:			'..';
DOT:				'.';
DOUBLE_COLON:		'::';
COLON:				':';
DOUBLE_SEMICOLON:	';;';
SEMICOLON:			';';

// ---------- Null-safety related operators, as well as NOT because lexing precedence..
OP_IFN_ASSIGN:		'??=';
OP_IFN:				'??';
OP_NASRT:			'!!';
OP_NOT:				'!';

// ---------- Various other high-precedence operators that use <, > and/or =
OP_SPACESHIP:		'<=>';
OP_L_SHIFT:			'<<';
OP_LEQ:				'<=';
OP_R_SHIFT:			'>>';
OP_GEQ:				'>=';

// ---------- Angle brackets, because they not only do maths!
L_ANGLE:			'<';
R_ANGLE:			'>';

// ---------- All types of arithmetic operators sorted by precedence
OP_POW_ASSIGN:		'**=';
OP_POW:				'**';
OP_TIMES_ASSIGN:	'*=';
OP_TIMES:			'*';
OP_DIV_ASSIGN:		'/=';
OP_DIV:				'/';
OP_MOD_ASSIGN:		'%=';
OP_MOD:				'%';
OP_PLUS_ASSIGN:		'+=';
OP_PLUS:			'+';
OP_MINUS_ASSIGN:	'-=';
OP_MINUS:			'-';

// ---------- Logical operators for bit & boolean operations
OP_CONJ_AND:		'&&';
OP_AMP:				'&';
OP_DISJ_OR:			'||';
OP_OR:				'|';
OP_XOR:				'^';
OP_INV_ASSIGN:		'~~';
OP_INV:				'~';

// ------------------------------ Inside lexing mode
mode M_INSIDE;

INSIDE_L_PAREN:     L_PAREN     -> pushMode(M_INSIDE), type(L_PAREN);
INSIDE_R_PAREN:     R_PAREN     -> popMode, type(R_PAREN);
INSIDE_L_CRL_PAREN: L_CRL_PAREN -> pushMode(M_INSIDE), type(L_CRL_PAREN);
INSIDE_R_CRL_PAREN: R_CRL_PAREN -> popMode, type(R_CRL_PAREN);
INSIDE_L_SQR_PAREN: L_SQR_PAREN -> pushMode(M_INSIDE), type(L_SQR_PAREN);
INSIDE_R_SQR_PAREN: R_SQR_PAREN -> popMode, type(R_SQR_PAREN);

// ------------------------------ Raw String lexing mode
mode M_RAW_STRING;

// Exit lexing mode when reaching the next unescaped double-quote, don't eat the token
RAW_STRING_DOUBLE_QUOTE: DOUBLE_QUOTE -> popMode, type(DOUBLE_QUOTE);

// ------------------------------ String lexing mode
mode M_STRING;

// Exit lexing mode when reaching the next unescaped double-quote, don't eat the token
STRING_DOUBLE_QUOTE: DOUBLE_QUOTE -> popMode, type(DOUBLE_QUOTE);