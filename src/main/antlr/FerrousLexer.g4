lexer grammar FerrousLexer;

/*
 * Reference implementation of a lexer for the Ferrous
 * programming language.
 */

// ------------------------------ Whitespace and comments (getting rid of them)
LINE_COMMENT:   '//' ~[\r\n]*                       -> channel(HIDDEN);
BLOCK_COMMENT:  '/*' (BLOCK_COMMENT | .)*? '*/'     -> channel(HIDDEN);
WS:             [\u0020\u0009\u000C]                -> channel(HIDDEN);
NL:             ('\n' | ('\r' '\n'?));

fragment F_HIDDEN: LINE_COMMENT | BLOCK_COMMENT | WS;

// ------------------------------ String stuff
EMPTY_RAW_STRING:   '#""#';
RAW_STRING:         '#"' -> pushMode(M_RAW_STRING);
EMPTY_STRING:       '""';
DOUBLE_QUOTE:       '"' -> pushMode(M_STRING);
DOLLAR:             '$';

// ------------------------------ Parenthese of all variations
L_PAREN:        '(' -> pushMode(M_INSIDE);
R_PAREN:        ')' -> popMode;
L_CRL_PAREN:    '{' -> pushMode(M_INSIDE);
R_CRL_PAREN:    '}' -> popMode;
L_SQR_PAREN:    '[' -> pushMode(M_INSIDE);
R_SQR_PAREN:    ']' -> popMode;

// ------------------------------ Pre-Compiler Keywords
PC_KW_CONTINUE: '!continue';
PC_KW_NAMEOF:   '!nameof';
PC_KW_DEFINE:   '!define';
PC_KW_ASSERT:   '!assert';
PC_KW_UNDEF:    '!undef';
PC_KW_BREAK:    '!break';
PC_KW_MACRO:    '!macro';
PC_KW_WHILE:    '!while';
PC_KW_ELIF:     '!elif';
PC_KW_ELSE:     '!else';
PC_KW_CONJ:     '!conj';
PC_KW_DISJ:     '!disj';
PC_KW_FOR:      '!for';
PC_KW_FIR:      '!fir';
PC_KW_IF:       '!if';
PC_KW_DO:       '!do';

// ------------------------------ Primitive literals
LITERAL_I8:     F_IMPL_INT_LITERAL KW_TYPE_I8;
LITERAL_I16:    F_IMPL_INT_LITERAL KW_TYPE_I16;
LITERAL_I32:    F_IMPL_INT_LITERAL KW_TYPE_I32?;
LITERAL_I64:    F_IMPL_INT_LITERAL KW_TYPE_I64;

LITERAL_U8:     F_IMPL_INT_LITERAL KW_TYPE_U8;
LITERAL_U16:    F_IMPL_INT_LITERAL KW_TYPE_U16;
LITERAL_U32:    F_IMPL_INT_LITERAL KW_TYPE_U32;
LITERAL_U64:    F_IMPL_INT_LITERAL KW_TYPE_U64;

LITERAL_F32:    F_IMPL_REAL_LITERAL KW_TYPE_F32?;
LITERAL_F64:    F_IMPL_REAL_LITERAL KW_TYPE_F64;

// ------------------------------ Built-in type keywords
KW_TYPE_USIZE:  'usize';    // Unsigned platform-dependent size type (size_t in C/C++), only usable in conjunction with unsafe
KW_TYPE_ISIZE:  'isize';    // Signed platform-dependent size type (offset_t in C/C++), only usable in conjunction with unsafe
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
KW_TYPE_STR:    'str';

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
KW_PACKAGE:     'package';
KW_DISCARD:     'discard';
KW_ALIGNOF:     'alignof';
KW_LITERAL:     'literal';
KW_DEFAULT:     'default';
KW_NAMEOF:      'nameof';
KW_IMPORT:      'import';
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
KW_THROWS:      'throws';
KW_WHERE:       'where';
KW_SUPER:       'super';
KW_THROW:       'throw';
KW_CATCH:       'catch';
KW_VALUE:       'value';
KW_ALIGN:       'align';
KW_IDENT:       'ident';
KW_TRAIT:       'trait';
KW_BREAK:       'break';
KW_YIELD:       'yield';
KW_CLASS:       'class';
KW_CONST:       'const';
KW_FALSE:       'false';
KW_WHILE:       'while';
KW_GOTO:        'goto';
KW_LATE:        'late';
KW_TRUE:        'true';
KW_TYPE:        'type';
KW_EXPR:        'expr';
KW_NULL:        'null';
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
KW_GET:         'get';
KW_SET:         'set';
KW_TRY:         'try';
KW_FOR:         'for';
KW_DO:          'do';
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
COMMA:              ',';
DOUBLE_COLON:		'::';
COLON:				':';
DOUBLE_SEMICOLON:	';;';
SEMICOLON:			';';
SINGLE_QUOTE:       '\'';
HASH:               '#';
UNDERSCORE:         '_';

// ---------- Null-safety related operators, as well as NOT because lexing precedence..
OP_IFN_ASSIGN:		'??=';
OP_IFN:				'??';
OP_SAFE_CALL:       '?.';
OP_SAFE_DEREF:      '?->';
OP_NEQ:             '!=';
OP_NASRT:			'!!';
OP_NOT:				'!';
QMK:                '?';

// ---------- Various other high-precedence operators that use <, > and/or =
OP_SPACESHIP:		'<=>';
OP_SWAP:            '<->';
OP_L_SHIFT_ASSIGN:  '<<=';
OP_L_SHIFT:			'<<';
OP_LEQ:				'<=';
OP_R_SHIFT_ASSIGN:  '>>=';
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
OP_INCREMENT:       '++';
OP_PLUS_ASSIGN:		'+=';
OP_PLUS:			'+';
OP_DECREMENT:       '--';
OP_MINUS_ASSIGN:	'-=';
OP_MINUS:			'-';

// ---------- Logical operators for bit & boolean operations
OP_CONJ_AND:		'&&';
OP_AND_ASSIGN:      '&=';
OP_AMP:				'&';
OP_DISJ_OR:			'||';
OP_OR_ASSIGN:       '|=';
OP_OR:				'|';
OP_XOR:				'^';
OP_XOR_ASSIGN:      '^=';
OP_INV_ASSIGN:		'~~';
OP_INV:				'~';

// ---------- Attribute usage sites
AUS_FIELD:          '@field:';
AUS_FILE:           '@file:';
AT:                 '@';

// ------------------------------ More Literals

LITERAL_CHAR:       SINGLE_QUOTE (F_ESCAPED_CHAR | .) SINGLE_QUOTE;
IDENTIFIER:         (F_LETTER | '_')(F_LETTER | '_' | F_DEC_DIGIT)*
                    | '`' ~('`')+ '`'
                    ;

// ------------------------------ Shared fragments

fragment F_OCT_DIGIT:     [0-7];
fragment F_DEC_DIGIT:     [0-9];
fragment F_DEC_DIGIT_NZ:  [1-9];
fragment F_HEX_DIGIT:     [0-9a-fA-F];
fragment F_BIN_DIGIT:     [0-1];
fragment F_LETTER:        [a-zA-Z];
fragment F_ALPHA_NUM:     F_LETTER | F_DEC_DIGIT;
fragment F_ESCAPED_CHAR:  '\\' [tbrn'"\\$];

fragment F_IMPL_HEX_LITERAL:  '0' [xX] F_HEX_DIGIT (F_HEX_DIGIT | '_')*;
fragment F_IMPL_BIN_LITERAL:  '0' [bB] F_BIN_DIGIT (F_BIN_DIGIT | '_')*;
fragment F_IMPL_OCT_LITERAL:  '0' [oO] F_OCT_DIGIT (F_OCT_DIGIT | '_')*;

fragment F_IMPL_REAL_LITERAL:  ((F_DEC_DIGIT_NZ F_DEC_DIGIT* | '0')? '.'
                    | (F_DEC_DIGIT_NZ (F_DEC_DIGIT | '_')* F_DEC_DIGIT)? '.')(F_DEC_DIGIT+
                    | F_DEC_DIGIT (F_DEC_DIGIT | '_')+ F_DEC_DIGIT
                    | F_DEC_DIGIT+ [eE] ('+' | '-')? F_DEC_DIGIT+
                    | F_DEC_DIGIT+ [eE] ('+' | '-')? F_DEC_DIGIT (F_DEC_DIGIT | '_')+ F_DEC_DIGIT
                    | F_DEC_DIGIT (F_DEC_DIGIT | '_')+ F_DEC_DIGIT [eE] ('+' | '-')? F_DEC_DIGIT+
                    | F_DEC_DIGIT (F_DEC_DIGIT | '_')+ F_DEC_DIGIT [eE] ('+' | '-')? F_DEC_DIGIT (F_DEC_DIGIT | '_')+ F_DEC_DIGIT)
                    ;

fragment F_IMPL_INT_LITERAL:   ('0'
                    | F_DEC_DIGIT_NZ F_DEC_DIGIT*
                    | F_DEC_DIGIT_NZ (F_DEC_DIGIT | '_')+ F_DEC_DIGIT
                    | F_DEC_DIGIT_NZ F_DEC_DIGIT* [eE] ('+' | '-')? F_DEC_DIGIT+
                    | F_DEC_DIGIT_NZ F_DEC_DIGIT* [eE] ('+' | '-')? F_DEC_DIGIT (F_DEC_DIGIT | '_')+ F_DEC_DIGIT
                    | F_DEC_DIGIT_NZ (F_DEC_DIGIT | '_')+ F_DEC_DIGIT [eE] ('+' | '-')? F_DEC_DIGIT+
                    | F_DEC_DIGIT_NZ (F_DEC_DIGIT | '_')+ F_DEC_DIGIT [eE] ('+' | '-')? F_DEC_DIGIT (F_DEC_DIGIT | '_')+ F_DEC_DIGIT)
                    | F_IMPL_HEX_LITERAL
                    | F_IMPL_BIN_LITERAL
                    | F_IMPL_OCT_LITERAL
                    ;

// ------------------------------ Inside lexing mode
mode M_INSIDE;

// ---------- Nested rules for recursive parsing
M_INSIDE_L_PAREN:           L_PAREN             -> pushMode(M_INSIDE), type(L_PAREN);
M_INSIDE_R_PAREN:           R_PAREN             -> popMode, type(R_PAREN);
M_INSIDE_L_CRL_PAREN:       L_CRL_PAREN         -> pushMode(M_INSIDE), type(L_CRL_PAREN);
M_INSIDE_R_CRL_PAREN:       R_CRL_PAREN         -> popMode, type(R_CRL_PAREN);
M_INSIDE_L_SQR_PAREN:       L_SQR_PAREN         -> pushMode(M_INSIDE), type(L_SQR_PAREN);
M_INSIDE_R_SQR_PAREN:       R_SQR_PAREN         -> popMode, type(R_SQR_PAREN);
// ---------- Pre-compiler keywords
M_INSIDE_PC_KW_CONTINUE:    PC_KW_CONTINUE      -> type(PC_KW_CONTINUE);
M_INSIDE_PC_KW_NAMEOF:      PC_KW_NAMEOF        -> type(PC_KW_NAMEOF);
M_INSIDE_PC_KW_DEFINE:      PC_KW_DEFINE        -> type(PC_KW_DEFINE);
M_INSIDE_PC_KW_ASSERT:      PC_KW_ASSERT        -> type(PC_KW_ASSERT);
M_INSIDE_PC_KW_UNDEF:       PC_KW_UNDEF         -> type(PC_KW_UNDEF);
M_INSIDE_PC_KW_BREAK:       PC_KW_BREAK         -> type(PC_KW_BREAK);
M_INSIDE_PC_KW_MACRO:       PC_KW_MACRO         -> type(PC_KW_MACRO);
M_INSIDE_PC_KW_WHILE:       PC_KW_WHILE         -> type(PC_KW_WHILE);
M_INSIDE_PC_KW_ELIF:        PC_KW_ELIF          -> type(PC_KW_ELIF);
M_INSIDE_PC_KW_ELSE:        PC_KW_ELSE          -> type(PC_KW_ELSE);
M_INSIDE_PC_KW_CONJ:        PC_KW_CONJ          -> type(PC_KW_CONJ);
M_INSIDE_PC_KW_DISJ:        PC_KW_DISJ          -> type(PC_KW_DISJ);
M_INSIDE_PC_KW_FOR:         PC_KW_FOR           -> type(PC_KW_FOR);
M_INSIDE_PC_KW_FIR:         PC_KW_FIR           -> type(PC_KW_FIR);
M_INSIDE_PC_KW_IF:          PC_KW_IF            -> type(PC_KW_IF);
M_INSIDE_PC_KW_DO:          PC_KW_DO            -> type(PC_KW_DO);
// ---------- String literals
M_INSIDE_DOUBLE_QUOTE:      DOUBLE_QUOTE        -> pushMode(M_STRING), type(DOUBLE_QUOTE);
M_INSIDE_RAW_STRING:        RAW_STRING          -> pushMode(M_RAW_STRING), type(RAW_STRING);
M_INSIDE_EMPTY_RAW_STRING:  EMPTY_RAW_STRING    -> type(EMPTY_RAW_STRING);
M_INSIDE_EMPTY_STRING:      EMPTY_STRING        -> type(EMPTY_STRING);
M_INSIDE_DOLLAR:            DOLLAR              -> type(DOLLAR);
// ---------- Primitive literals
M_INSIDE_LITERAL_I8:        LITERAL_I8          -> type(LITERAL_I8);
M_INSIDE_LITERAL_I16:       LITERAL_I16         -> type(LITERAL_I16);
M_INSIDE_LITERAL_I32:       LITERAL_I32         -> type(LITERAL_I32);
M_INSIDE_LITERAL_I64:       LITERAL_I64         -> type(LITERAL_I64);
M_INSIDE_LITERAL_U8:        LITERAL_U8          -> type(LITERAL_U8);
M_INSIDE_LITERAL_U16:       LITERAL_U16         -> type(LITERAL_U16);
M_INSIDE_LITERAL_U32:       LITERAL_U32         -> type(LITERAL_U32);
M_INSIDE_LITERAL_U64:       LITERAL_U64         -> type(LITERAL_U64);
M_INSIDE_LITERAL_F32:       LITERAL_F32         -> type(LITERAL_F32);
M_INSIDE_LITERAL_F64:       LITERAL_F64         -> type(LITERAL_F64);
// ---------- Primitive types
M_INSIDE_KW_TYPE_USIZE:     KW_TYPE_USIZE       -> type(KW_TYPE_USIZE);
M_INSIDE_KW_TYPE_ISIZE:     KW_TYPE_ISIZE       -> type(KW_TYPE_ISIZE);
M_INSIDE_KW_TYPE_VOID:      KW_TYPE_VOID        -> type(KW_TYPE_VOID);
M_INSIDE_KW_TYPE_BOOL:      KW_TYPE_BOOL        -> type(KW_TYPE_BOOL);
M_INSIDE_KW_TYPE_CHAR:      KW_TYPE_CHAR        -> type(KW_TYPE_CHAR);
M_INSIDE_KW_TYPE_I64:       KW_TYPE_I64         -> type(KW_TYPE_I64);
M_INSIDE_KW_TYPE_I32:       KW_TYPE_I32         -> type(KW_TYPE_I32);
M_INSIDE_KW_TYPE_I16:       KW_TYPE_I16         -> type(KW_TYPE_I16);
M_INSIDE_KW_TYPE_I8:        KW_TYPE_I8          -> type(KW_TYPE_I8);
M_INSIDE_KW_TYPE_U64:       KW_TYPE_U64         -> type(KW_TYPE_U64);
M_INSIDE_KW_TYPE_U32:       KW_TYPE_U32         -> type(KW_TYPE_U32);
M_INSIDE_KW_TYPE_U16:       KW_TYPE_U16         -> type(KW_TYPE_U16);
M_INSIDE_KW_TYPE_U8:        KW_TYPE_U8          -> type(KW_TYPE_U8);
M_INSIDE_KW_TYPE_F64:       KW_TYPE_F64         -> type(KW_TYPE_F64);
M_INSIDE_KW_TYPE_F32:       KW_TYPE_F32         -> type(KW_TYPE_F32);
M_INSIDE_KW_TYPE_STR:       KW_TYPE_STR         -> type(KW_TYPE_STR);
// ---------- Keywords
M_INSIDE_KW_STACKALLOC:     KW_STACKALLOC       -> type(KW_STACKALLOC);
M_INSIDE_KW_UNMANAGED:      KW_UNMANAGED        -> type(KW_UNMANAGED);
M_INSIDE_KW_CONSTRUCT:      KW_CONSTRUCT        -> type(KW_CONSTRUCT);
M_INSIDE_KW_INTERFACE:      KW_INTERFACE        -> type(KW_INTERFACE);
M_INSIDE_KW_BITFIELD:       KW_BITFIELD         -> type(KW_BITFIELD);
M_INSIDE_KW_CONTINUE:       KW_CONTINUE         -> type(KW_CONTINUE);
M_INSIDE_KW_DESTRUCT:       KW_DESTRUCT         -> type(KW_DESTRUCT);
M_INSIDE_KW_ABSTRACT:       KW_ABSTRACT         -> type(KW_ABSTRACT);
M_INSIDE_KW_OVERRIDE:       KW_OVERRIDE         -> type(KW_OVERRIDE);
M_INSIDE_KW_PACKAGE:        KW_PACKAGE          -> type(KW_PACKAGE);
M_INSIDE_KW_DISCARD:        KW_DISCARD          -> type(KW_DISCARD);
M_INSIDE_KW_ALIGNOF:        KW_ALIGNOF          -> type(KW_ALIGNOF);
M_INSIDE_KW_LITERAL:        KW_LITERAL          -> type(KW_LITERAL);
M_INSIDE_KW_DEFAULT:        KW_DEFAULT          -> type(KW_DEFAULT);
M_INSIDE_KW_NAMEOF:         KW_NAMEOF           -> type(KW_NAMEOF);
M_INSIDE_KW_IMPORT:         KW_IMPORT           -> type(KW_IMPORT);
M_INSIDE_KW_RETURN:         KW_RETURN           -> type(KW_RETURN);
M_INSIDE_KW_INTERN:         KW_INTERN           -> type(KW_INTERN);
M_INSIDE_KW_GLOBAL:         KW_GLOBAL           -> type(KW_GLOBAL);
M_INSIDE_KW_STATIC:         KW_STATIC           -> type(KW_STATIC);
M_INSIDE_KW_EXTERN:         KW_EXTERN           -> type(KW_EXTERN);
M_INSIDE_KW_UNSAFE:         KW_UNSAFE           -> type(KW_UNSAFE);
M_INSIDE_KW_STRUCT:         KW_STRUCT           -> type(KW_STRUCT);
M_INSIDE_KW_ATTRIB:         KW_ATTRIB           -> type(KW_ATTRIB);
M_INSIDE_KW_RECORD:         KW_RECORD           -> type(KW_RECORD);
M_INSIDE_KW_OBJECT:         KW_OBJECT           -> type(KW_OBJECT);
M_INSIDE_KW_TYPEOF:         KW_TYPEOF           -> type(KW_TYPEOF);
M_INSIDE_KW_SIZEOF:         KW_SIZEOF           -> type(KW_SIZEOF);
M_INSIDE_KW_DELETE:         KW_DELETE           -> type(KW_DELETE);
M_INSIDE_KW_THROWS:         KW_THROWS           -> type(KW_THROWS);
M_INSIDE_KW_ALIGN:          KW_ALIGN            -> type(KW_ALIGN);
M_INSIDE_KW_IDENT:          KW_IDENT            -> type(KW_IDENT);
M_INSIDE_KW_TRAIT:          KW_TRAIT            -> type(KW_TRAIT);
M_INSIDE_KW_BREAK:          KW_BREAK            -> type(KW_BREAK);
M_INSIDE_KW_YIELD:          KW_YIELD            -> type(KW_YIELD);
M_INSIDE_KW_CLASS:          KW_CLASS            -> type(KW_CLASS);
M_INSIDE_KW_CONST:          KW_CONST            -> type(KW_CONST);
M_INSIDE_KW_FALSE:          KW_FALSE            -> type(KW_FALSE);
M_INSIDE_KW_WHILE:          KW_WHILE            -> type(KW_WHILE);
M_INSIDE_KW_VALUE:          KW_VALUE            -> type(KW_VALUE);
M_INSIDE_KW_WHERE:          KW_WHERE            -> type(KW_WHERE);
M_INSIDE_KW_SUPER:          KW_SUPER            -> type(KW_SUPER);
M_INSIDE_KW_THROW:          KW_THROW            -> type(KW_THROW);
M_INSIDE_KW_CATCH:          KW_CATCH            -> type(KW_CATCH);
M_INSIDE_KW_LATE:           KW_LATE             -> type(KW_LATE);
M_INSIDE_KW_GOTO:           KW_GOTO             -> type(KW_GOTO);
M_INSIDE_KW_TRUE:           KW_TRUE             -> type(KW_TRUE);
M_INSIDE_KW_TYPE:           KW_TYPE             -> type(KW_TYPE);
M_INSIDE_KW_EXPR:           KW_EXPR             -> type(KW_EXPR);
M_INSIDE_KW_NULL:           KW_NULL             -> type(KW_NULL);
M_INSIDE_KW_ENUM:           KW_ENUM             -> type(KW_ENUM);
M_INSIDE_KW_WHEN:           KW_WHEN             -> type(KW_WHEN);
M_INSIDE_KW_OPEN:           KW_OPEN             -> type(KW_OPEN);
M_INSIDE_KW_THIS:           KW_THIS             -> type(KW_THIS);
M_INSIDE_KW_SELF:           KW_SELF             -> type(KW_SELF);
M_INSIDE_KW_ELSE:           KW_ELSE             -> type(KW_ELSE);
M_INSIDE_KW_PRIV:           KW_PRIV             -> type(KW_PRIV);
M_INSIDE_KW_PROT:           KW_PROT             -> type(KW_PROT);
M_INSIDE_KW_INL:            KW_INL              -> type(KW_INL);
M_INSIDE_KW_PUB:            KW_PUB              -> type(KW_PUB);
M_INSIDE_KW_NEW:            KW_NEW              -> type(KW_NEW);
M_INSIDE_KW_OUT:            KW_OUT              -> type(KW_OUT);
M_INSIDE_KW_LET:            KW_LET              -> type(KW_LET);
M_INSIDE_KW_MUT:            KW_MUT              -> type(KW_MUT);
M_INSIDE_KW_GET:            KW_GET              -> type(KW_GET);
M_INSIDE_KW_SET:            KW_SET              -> type(KW_SET);
M_INSIDE_KW_TRY:            KW_TRY              -> type(KW_TRY);
M_INSIDE_KW_FOR:            KW_FOR              -> type(KW_FOR);
M_INSIDE_KW_DO:             KW_DO               -> type(KW_DO);
M_INSIDE_KW_IF:             KW_IF               -> type(KW_IF);
M_INSIDE_KW_FN:             KW_FN               -> type(KW_FN);
M_INSIDE_KW_OP:             KW_OP               -> type(KW_OP);
M_INSIDE_KW_AS_SAFE:        KW_AS_SAFE          -> type(KW_AS_SAFE);
M_INSIDE_KW_AS:             KW_AS               -> type(KW_AS);
M_INSIDE_KW_IS_NOT:         KW_IS_NOT           -> type(KW_IS_NOT);
M_INSIDE_KW_IS:             KW_IS               -> type(KW_IS);
M_INSIDE_KW_IN_NOT:         KW_IN_NOT           -> type(KW_IN_NOT);
M_INSIDE_KW_IN:             KW_IN               -> type(KW_IN);
// ---------- Operators
M_INSIDE_TRIPLE_EQ: 	    TRIPLE_EQ           -> type(TRIPLE_EQ);
M_INSIDE_ARROW:				ARROW               -> type(ARROW);
M_INSIDE_DOUBLE_ARROW:		DOUBLE_ARROW        -> type(DOUBLE_ARROW);
M_INSIDE_DOUBLE_EQ: 	    DOUBLE_EQ           -> type(DOUBLE_EQ);
M_INSIDE_ASSIGN: 			ASSIGN              -> type(ASSIGN);
M_INSIDE_TRIPLE_DOT:		TRIPLE_DOT          -> type(TRIPLE_DOT);
M_INSIDE_DOUBLE_DOT:		DOUBLE_DOT          -> type(DOUBLE_DOT);
M_INSIDE_DOT:				DOT                 -> type(DOT);
M_INSIDE_COMMA:             COMMA               -> type(COMMA);
M_INSIDE_DOUBLE_COLON:	    DOUBLE_COLON        -> type(DOUBLE_COLON);
M_INSIDE_COLON:				COLON               -> type(COLON);
M_INSIDE_DOUBLE_SEMICOLON:  DOUBLE_SEMICOLON    -> type(DOUBLE_SEMICOLON);
M_INSIDE_SEMICOLON:         SEMICOLON           -> type(SEMICOLON);
M_INSIDE_SINGLE_QUOTE:      SINGLE_QUOTE        -> type(SINGLE_QUOTE);
M_INSIDE_HASH:              HASH                -> type(HASH);
M_INSIDE_UNDERSCORE:        UNDERSCORE          -> type(UNDERSCORE);
M_INSIDE_OP_IFN_ASSIGN:     OP_IFN_ASSIGN       -> type(OP_IFN_ASSIGN);
M_INSIDE_OP_IFN:            OP_IFN              -> type(OP_IFN);
M_INSIDE_OP_NEQ:            OP_NEQ              -> type(OP_NEQ);
M_INSIDE_OP_SAFE_CALL:      OP_SAFE_CALL        -> type(OP_SAFE_CALL);
M_INSIDE_OP_SAFE_DEREF:     OP_SAFE_DEREF       -> type(OP_SAFE_DEREF);
M_INSIDE_OP_NASRT:          OP_NASRT            -> type(OP_NASRT);
M_INSIDE_OP_NOT:            OP_NOT              -> type(OP_NOT);
M_INSIDE_QMK:               QMK                 -> type(QMK);
M_INSIDE_OP_SPACESHIP:      OP_SPACESHIP        -> type(OP_SPACESHIP);
M_INSIDE_OP_SWAP:           OP_SWAP             -> type(OP_SWAP);
M_INSIDE_OP_L_SHIFT_ASSIGN: OP_L_SHIFT_ASSIGN   -> type(OP_L_SHIFT_ASSIGN);
M_INSIDE_OP_L_SHIFT:        OP_L_SHIFT          -> type(OP_L_SHIFT);
M_INSIDE_OP_LEQ:            OP_LEQ              -> type(OP_LEQ);
M_INSIDE_OP_R_SHIFT_ASSIGN: OP_R_SHIFT_ASSIGN   -> type(OP_R_SHIFT_ASSIGN);
M_INSIDE_OP_R_SHIFT:        OP_R_SHIFT          -> type(OP_R_SHIFT);
M_INSIDE_OP_GEQ:            OP_GEQ              -> type(OP_GEQ);
M_INSIDE_L_ANGLE:           L_ANGLE             -> type(L_ANGLE);
M_INSIDE_R_ANGLE:           R_ANGLE             -> type(R_ANGLE);
M_INSIDE_OP_POW_ASSIGN:     OP_POW_ASSIGN       -> type(OP_POW_ASSIGN);
M_INSIDE_OP_POW:            OP_POW              -> type(OP_POW);
M_INSIDE_OP_TIMES_ASSIGN:   OP_TIMES_ASSIGN     -> type(OP_TIMES_ASSIGN);
M_INSIDE_OP_TIMES:          OP_TIMES            -> type(OP_TIMES);
M_INSIDE_OP_DIV_ASSIGN:     OP_DIV_ASSIGN       -> type(OP_DIV_ASSIGN);
M_INSIDE_OP_DIV:            OP_DIV              -> type(OP_DIV);
M_INSIDE_OP_MOD_ASSIGN:     OP_MOD_ASSIGN       -> type(OP_MOD_ASSIGN);
M_INSIDE_OP_MOD:            OP_MOD              -> type(OP_MOD);
M_INSIDE_OP_INCREMENT:      OP_INCREMENT        -> type(OP_INCREMENT);
M_INSIDE_OP_PLUS_ASSIGN:    OP_PLUS_ASSIGN      -> type(OP_PLUS_ASSIGN);
M_INSIDE_OP_PLUS:           OP_PLUS             -> type(OP_PLUS);
M_INSIDE_OP_DECREMENT:      OP_DECREMENT        -> type(OP_DECREMENT);
M_INSIDE_OP_MINUS_ASSIGN:   OP_MINUS_ASSIGN     -> type(OP_MINUS_ASSIGN);
M_INSIDE_OP_MINUS:          OP_MINUS            -> type(OP_MINUS);
M_INSIDE_OP_CONJ_AND:       OP_CONJ_AND         -> type(OP_CONJ_AND);
M_INSIDE_OP_AND_ASSIGN:     OP_AND_ASSIGN       -> type(OP_AND_ASSIGN);
M_INSIDE_OP_AMP:            OP_AMP              -> type(OP_AMP);
M_INSIDE_OP_DISJ_OR:        OP_DISJ_OR          -> type(OP_DISJ_OR);
M_INSIDE_OP_OR_ASSIGN:      OP_OR_ASSIGN        -> type(OP_OR_ASSIGN);
M_INSIDE_OP_OR:             OP_OR               -> type(OP_OR);
M_INSIDE_OP_XOR:            OP_XOR              -> type(OP_XOR);
M_INSIDE_OP_XOR_ASSIGN:     OP_XOR_ASSIGN       -> type(OP_XOR_ASSIGN);
M_INSIDE_OP_INV_ASSIGN:     OP_INV_ASSIGN       -> type(OP_INV_ASSIGN);
M_INSIDE_OP_INV:            OP_INV              -> type(OP_INV);
// ---------- Attribute usage sites
M_INSIDE_AUS_FIELD:         AUS_FIELD           -> type(AUS_FIELD);
M_INSIDE_AUS_FILE:          AUS_FILE            -> type(AUS_FILE);
M_INSIDE_AT:                AT                  -> type(AT);
// ---------- Identifiers
M_INSIDE_IDENTIFIER:        IDENTIFIER          -> type(IDENTIFIER);
M_INSIDE_LINE_COMMENT:      LINE_COMMENT        -> channel(HIDDEN);
M_INSIDE_BLOCK_COMMENT:     BLOCK_COMMENT       -> channel(HIDDEN);
M_INSIDE_WS:                WS                  -> channel(HIDDEN);
M_INSIDE_NL:                NL                  -> channel(HIDDEN);

// ------------------------------ Raw String lexing mode
mode M_RAW_STRING;

// ---------- Nested rules for recursive parsing
M_RAW_STRING_ESCAPED_END:   '\\"#'          -> type(M_RAW_STRING_ESCAPED_END);
M_RAW_STRING_END:           '"#'            -> popMode, type(M_RAW_STRING_END);
M_RAW_STRING_INTERP:        '${'            -> pushMode(M_INTERP_STRING);
M_RAW_STRING_TEXT:          ~('\\' | '"' | '$')+ | '$';

// ------------------------------ String lexing mode
mode M_STRING;

// ---------- Nested rules for recursive parsing
M_STRING_DOUBLE_QUOTE:  DOUBLE_QUOTE    -> popMode, type(DOUBLE_QUOTE);
M_STRING_INTERP:        '${'            -> pushMode(M_INTERP_STRING);
M_STRING_TEXT:          ~('\\' | '"' | '$')+ | '$';

// ------------------------------ Interpolated String lexing mode
mode M_INTERP_STRING;

// ---------- Nested rules for recursive parsing
M_INTERP_STRING_R_CRL_PAREN:    R_CRL_PAREN     -> popMode, type(R_CRL_PAREN);
M_INTERP_STRING_DOUBLE_QUOTE:   DOUBLE_QUOTE    -> pushMode(M_STRING), type(DOUBLE_QUOTE);
M_INTERP_STRING_RAW_STRING:     RAW_STRING      -> pushMode(M_RAW_STRING), type(RAW_STRING);

M_INTERP_L_PAREN:           L_PAREN             -> pushMode(M_INSIDE), type(L_PAREN);
M_INTERP_R_PAREN:           R_PAREN             -> popMode, type(R_PAREN);
M_INTERP_L_CRL_PAREN:       L_CRL_PAREN         -> pushMode(M_INSIDE), type(L_CRL_PAREN);
M_INTERP_R_CRL_PAREN:       R_CRL_PAREN         -> popMode, type(R_CRL_PAREN);
M_INTERP_L_SQR_PAREN:       L_SQR_PAREN         -> pushMode(M_INSIDE), type(L_SQR_PAREN);
M_INTERP_R_SQR_PAREN:       R_SQR_PAREN         -> popMode, type(R_SQR_PAREN);
// ---------- Pre-compiler keywords
M_INTERP_PC_KW_CONTINUE:    PC_KW_CONTINUE      -> type(PC_KW_CONTINUE);
M_INTERP_PC_KW_NAMEOF:      PC_KW_NAMEOF        -> type(PC_KW_NAMEOF);
M_INTERP_PC_KW_DEFINE:      PC_KW_DEFINE        -> type(PC_KW_DEFINE);
M_INTERP_PC_KW_ASSERT:      PC_KW_ASSERT        -> type(PC_KW_ASSERT);
M_INTERP_PC_KW_UNDEF:       PC_KW_UNDEF         -> type(PC_KW_UNDEF);
M_INTERP_PC_KW_BREAK:       PC_KW_BREAK         -> type(PC_KW_BREAK);
M_INTERP_PC_KW_MACRO:       PC_KW_MACRO         -> type(PC_KW_MACRO);
M_INTERP_PC_KW_WHILE:       PC_KW_WHILE         -> type(PC_KW_WHILE);
M_INTERP_PC_KW_ELIF:        PC_KW_ELIF          -> type(PC_KW_ELIF);
M_INTERP_PC_KW_ELSE:        PC_KW_ELSE          -> type(PC_KW_ELSE);
M_INTERP_PC_KW_CONJ:        PC_KW_CONJ          -> type(PC_KW_CONJ);
M_INTERP_PC_KW_DISJ:        PC_KW_DISJ          -> type(PC_KW_DISJ);
M_INTERP_PC_KW_FOR:         PC_KW_FOR           -> type(PC_KW_FOR);
M_INTERP_PC_KW_FIR:         PC_KW_FIR           -> type(PC_KW_FIR);
M_INTERP_PC_KW_IF:          PC_KW_IF            -> type(PC_KW_IF);
M_INTERP_PC_KW_DO:          PC_KW_DO            -> type(PC_KW_DO);
// ---------- String literals
M_INTERP_DOUBLE_QUOTE:      DOUBLE_QUOTE        -> pushMode(M_STRING), type(DOUBLE_QUOTE);
M_INTERP_RAW_STRING:        RAW_STRING          -> pushMode(M_RAW_STRING), type(RAW_STRING);
M_INTERP_EMPTY_RAW_STRING:  EMPTY_RAW_STRING    -> type(EMPTY_RAW_STRING);
M_INTERP_EMPTY_STRING:      EMPTY_STRING        -> type(EMPTY_STRING);
M_INTERP_DOLLAR:            DOLLAR              -> type(DOLLAR);
// ---------- Primitive literals
M_INTERP_LITERAL_I8:        LITERAL_I8          -> type(LITERAL_I8);
M_INTERP_LITERAL_I16:       LITERAL_I16         -> type(LITERAL_I16);
M_INTERP_LITERAL_I32:       LITERAL_I32         -> type(LITERAL_I32);
M_INTERP_LITERAL_I64:       LITERAL_I64         -> type(LITERAL_I64);
M_INTERP_LITERAL_U8:        LITERAL_U8          -> type(LITERAL_U8);
M_INTERP_LITERAL_U16:       LITERAL_U16         -> type(LITERAL_U16);
M_INTERP_LITERAL_U32:       LITERAL_U32         -> type(LITERAL_U32);
M_INTERP_LITERAL_U64:       LITERAL_U64         -> type(LITERAL_U64);
M_INTERP_LITERAL_F32:       LITERAL_F32         -> type(LITERAL_F32);
M_INTERP_LITERAL_F64:       LITERAL_F64         -> type(LITERAL_F64);
// ---------- Primitive types
M_INTERP_KW_TYPE_USIZE:     KW_TYPE_USIZE       -> type(KW_TYPE_USIZE);
M_INTERP_KW_TYPE_ISIZE:     KW_TYPE_ISIZE       -> type(KW_TYPE_ISIZE);
M_INTERP_KW_TYPE_VOID:      KW_TYPE_VOID        -> type(KW_TYPE_VOID);
M_INTERP_KW_TYPE_BOOL:      KW_TYPE_BOOL        -> type(KW_TYPE_BOOL);
M_INTERP_KW_TYPE_CHAR:      KW_TYPE_CHAR        -> type(KW_TYPE_CHAR);
M_INTERP_KW_TYPE_I64:       KW_TYPE_I64         -> type(KW_TYPE_I64);
M_INTERP_KW_TYPE_I32:       KW_TYPE_I32         -> type(KW_TYPE_I32);
M_INTERP_KW_TYPE_I16:       KW_TYPE_I16         -> type(KW_TYPE_I16);
M_INTERP_KW_TYPE_I8:        KW_TYPE_I8          -> type(KW_TYPE_I8);
M_INTERP_KW_TYPE_U64:       KW_TYPE_U64         -> type(KW_TYPE_U64);
M_INTERP_KW_TYPE_U32:       KW_TYPE_U32         -> type(KW_TYPE_U32);
M_INTERP_KW_TYPE_U16:       KW_TYPE_U16         -> type(KW_TYPE_U16);
M_INTERP_KW_TYPE_U8:        KW_TYPE_U8          -> type(KW_TYPE_U8);
M_INTERP_KW_TYPE_F64:       KW_TYPE_F64         -> type(KW_TYPE_F64);
M_INTERP_KW_TYPE_F32:       KW_TYPE_F32         -> type(KW_TYPE_F32);
M_INTERP_KW_TYPE_STR:       KW_TYPE_STR         -> type(KW_TYPE_STR);
// ---------- Keywords
M_INTERP_KW_STACKALLOC:     KW_STACKALLOC       -> type(KW_STACKALLOC);
M_INTERP_KW_UNMANAGED:      KW_UNMANAGED        -> type(KW_UNMANAGED);
M_INTERP_KW_CONSTRUCT:      KW_CONSTRUCT        -> type(KW_CONSTRUCT);
M_INTERP_KW_INTERFACE:      KW_INTERFACE        -> type(KW_INTERFACE);
M_INTERP_KW_BITFIELD:       KW_BITFIELD         -> type(KW_BITFIELD);
M_INTERP_KW_CONTINUE:       KW_CONTINUE         -> type(KW_CONTINUE);
M_INTERP_KW_DESTRUCT:       KW_DESTRUCT         -> type(KW_DESTRUCT);
M_INTERP_KW_ABSTRACT:       KW_ABSTRACT         -> type(KW_ABSTRACT);
M_INTERP_KW_OVERRIDE:       KW_OVERRIDE         -> type(KW_OVERRIDE);
M_INTERP_KW_PACKAGE:        KW_PACKAGE          -> type(KW_PACKAGE);
M_INTERP_KW_DISCARD:        KW_DISCARD          -> type(KW_DISCARD);
M_INTERP_KW_ALIGNOF:        KW_ALIGNOF          -> type(KW_ALIGNOF);
M_INTERP_KW_LITERAL:        KW_LITERAL          -> type(KW_LITERAL);
M_INTERP_KW_DEFAULT:        KW_DEFAULT          -> type(KW_DEFAULT);
M_INTERP_KW_NAMEOF:         KW_NAMEOF           -> type(KW_NAMEOF);
M_INTERP_KW_IMPORT:         KW_IMPORT           -> type(KW_IMPORT);
M_INTERP_KW_RETURN:         KW_RETURN           -> type(KW_RETURN);
M_INTERP_KW_INTERN:         KW_INTERN           -> type(KW_INTERN);
M_INTERP_KW_GLOBAL:         KW_GLOBAL           -> type(KW_GLOBAL);
M_INTERP_KW_STATIC:         KW_STATIC           -> type(KW_STATIC);
M_INTERP_KW_EXTERN:         KW_EXTERN           -> type(KW_EXTERN);
M_INTERP_KW_UNSAFE:         KW_UNSAFE           -> type(KW_UNSAFE);
M_INTERP_KW_STRUCT:         KW_STRUCT           -> type(KW_STRUCT);
M_INTERP_KW_ATTRIB:         KW_ATTRIB           -> type(KW_ATTRIB);
M_INTERP_KW_RECORD:         KW_RECORD           -> type(KW_RECORD);
M_INTERP_KW_OBJECT:         KW_OBJECT           -> type(KW_OBJECT);
M_INTERP_KW_TYPEOF:         KW_TYPEOF           -> type(KW_TYPEOF);
M_INTERP_KW_SIZEOF:         KW_SIZEOF           -> type(KW_SIZEOF);
M_INTERP_KW_DELETE:         KW_DELETE           -> type(KW_DELETE);
M_INTERP_KW_THROWS:         KW_THROWS           -> type(KW_THROWS);
M_INTERP_KW_ALIGN:          KW_ALIGN            -> type(KW_ALIGN);
M_INTERP_KW_IDENT:          KW_IDENT            -> type(KW_IDENT);
M_INTERP_KW_TRAIT:          KW_TRAIT            -> type(KW_TRAIT);
M_INTERP_KW_BREAK:          KW_BREAK            -> type(KW_BREAK);
M_INTERP_KW_YIELD:          KW_YIELD            -> type(KW_YIELD);
M_INTERP_KW_CLASS:          KW_CLASS            -> type(KW_CLASS);
M_INTERP_KW_CONST:          KW_CONST            -> type(KW_CONST);
M_INTERP_KW_FALSE:          KW_FALSE            -> type(KW_FALSE);
M_INTERP_KW_WHILE:          KW_WHILE            -> type(KW_WHILE);
M_INTERP_KW_VALUE:          KW_VALUE            -> type(KW_VALUE);
M_INTERP_KW_WHERE:          KW_WHERE            -> type(KW_WHERE);
M_INTERP_KW_SUPER:          KW_SUPER            -> type(KW_SUPER);
M_INTERP_KW_THROW:          KW_THROW            -> type(KW_THROW);
M_INTERP_KW_CATCH:          KW_CATCH            -> type(KW_CATCH);
M_INTERP_KW_LATE:           KW_LATE             -> type(KW_LATE);
M_INTERP_KW_GOTO:           KW_GOTO             -> type(KW_GOTO);
M_INTERP_KW_TRUE:           KW_TRUE             -> type(KW_TRUE);
M_INTERP_KW_TYPE:           KW_TYPE             -> type(KW_TYPE);
M_INTERP_KW_EXPR:           KW_EXPR             -> type(KW_EXPR);
M_INTERP_KW_NULL:           KW_NULL             -> type(KW_NULL);
M_INTERP_KW_ENUM:           KW_ENUM             -> type(KW_ENUM);
M_INTERP_KW_WHEN:           KW_WHEN             -> type(KW_WHEN);
M_INTERP_KW_OPEN:           KW_OPEN             -> type(KW_OPEN);
M_INTERP_KW_THIS:           KW_THIS             -> type(KW_THIS);
M_INTERP_KW_SELF:           KW_SELF             -> type(KW_SELF);
M_INTERP_KW_ELSE:           KW_ELSE             -> type(KW_ELSE);
M_INTERP_KW_PRIV:           KW_PRIV             -> type(KW_PRIV);
M_INTERP_KW_PROT:           KW_PROT             -> type(KW_PROT);
M_INTERP_KW_INL:            KW_INL              -> type(KW_INL);
M_INTERP_KW_PUB:            KW_PUB              -> type(KW_PUB);
M_INTERP_KW_NEW:            KW_NEW              -> type(KW_NEW);
M_INTERP_KW_OUT:            KW_OUT              -> type(KW_OUT);
M_INTERP_KW_LET:            KW_LET              -> type(KW_LET);
M_INTERP_KW_MUT:            KW_MUT              -> type(KW_MUT);
M_INTERP_KW_GET:            KW_GET              -> type(KW_GET);
M_INTERP_KW_SET:            KW_SET              -> type(KW_SET);
M_INTERP_KW_TRY:            KW_TRY              -> type(KW_TRY);
M_INTERP_KW_FOR:            KW_FOR              -> type(KW_FOR);
M_INTERP_KW_DO:             KW_DO               -> type(KW_DO);
M_INTERP_KW_IF:             KW_IF               -> type(KW_IF);
M_INTERP_KW_FN:             KW_FN               -> type(KW_FN);
M_INTERP_KW_OP:             KW_OP               -> type(KW_OP);
M_INTERP_KW_AS_SAFE:        KW_AS_SAFE          -> type(KW_AS_SAFE);
M_INTERP_KW_AS:             KW_AS               -> type(KW_AS);
M_INTERP_KW_IS_NOT:         KW_IS_NOT           -> type(KW_IS_NOT);
M_INTERP_KW_IS:             KW_IS               -> type(KW_IS);
M_INTERP_KW_IN_NOT:         KW_IN_NOT           -> type(KW_IN_NOT);
M_INTERP_KW_IN:             KW_IN               -> type(KW_IN);
// ---------- Operators
M_INTERP_TRIPLE_EQ: 	    TRIPLE_EQ           -> type(TRIPLE_EQ);
M_INTERP_ARROW:				ARROW               -> type(ARROW);
M_INTERP_DOUBLE_ARROW:		DOUBLE_ARROW        -> type(DOUBLE_ARROW);
M_INTERP_DOUBLE_EQ: 	    DOUBLE_EQ           -> type(DOUBLE_EQ);
M_INTERP_ASSIGN: 			ASSIGN              -> type(ASSIGN);
M_INTERP_TRIPLE_DOT:		TRIPLE_DOT          -> type(TRIPLE_DOT);
M_INTERP_DOUBLE_DOT:		DOUBLE_DOT          -> type(DOUBLE_DOT);
M_INTERP_DOT:				DOT                 -> type(DOT);
M_INTERP_COMMA:             COMMA               -> type(COMMA);
M_INTERP_DOUBLE_COLON:	    DOUBLE_COLON        -> type(DOUBLE_COLON);
M_INTERP_COLON:				COLON               -> type(COLON);
M_INTERP_DOUBLE_SEMICOLON:  DOUBLE_SEMICOLON    -> type(DOUBLE_SEMICOLON);
M_INTERP_SEMICOLON:         SEMICOLON           -> type(SEMICOLON);
M_INTERP_SINGLE_QUOTE:      SINGLE_QUOTE        -> type(SINGLE_QUOTE);
M_INTERP_HASH:              HASH                -> type(HASH);
M_INTERP_UNDERSCORE:        UNDERSCORE          -> type(UNDERSCORE);
M_INTERP_OP_IFN_ASSIGN:     OP_IFN_ASSIGN       -> type(OP_IFN_ASSIGN);
M_INTERP_OP_IFN:            OP_IFN              -> type(OP_IFN);
M_INTERP_OP_NEQ:            OP_NEQ              -> type(OP_NEQ);
M_INTERP_OP_SAFE_CALL:      OP_SAFE_CALL        -> type(OP_SAFE_CALL);
M_INTERP_OP_SAFE_DEREF:     OP_SAFE_DEREF       -> type(OP_SAFE_DEREF);
M_INTERP_OP_NASRT:          OP_NASRT            -> type(OP_NASRT);
M_INTERP_OP_NOT:            OP_NOT              -> type(OP_NOT);
M_INTERP_QMK:               QMK                 -> type(QMK);
M_INTERP_OP_SPACESHIP:      OP_SPACESHIP        -> type(OP_SPACESHIP);
M_INTERP_OP_SWAP:           OP_SWAP             -> type(OP_SWAP);
M_INTERP_OP_L_SHIFT_ASSIGN: OP_L_SHIFT_ASSIGN   -> type(OP_L_SHIFT_ASSIGN);
M_INTERP_OP_L_SHIFT:        OP_L_SHIFT          -> type(OP_L_SHIFT);
M_INTERP_OP_LEQ:            OP_LEQ              -> type(OP_LEQ);
M_INTERP_OP_R_SHIFT_ASSIGN: OP_R_SHIFT_ASSIGN   -> type(OP_R_SHIFT_ASSIGN);
M_INTERP_OP_R_SHIFT:        OP_R_SHIFT          -> type(OP_R_SHIFT);
M_INTERP_OP_GEQ:            OP_GEQ              -> type(OP_GEQ);
M_INTERP_L_ANGLE:           L_ANGLE             -> type(L_ANGLE);
M_INTERP_R_ANGLE:           R_ANGLE             -> type(R_ANGLE);
M_INTERP_OP_POW_ASSIGN:     OP_POW_ASSIGN       -> type(OP_POW_ASSIGN);
M_INTERP_OP_POW:            OP_POW              -> type(OP_POW);
M_INTERP_OP_TIMES_ASSIGN:   OP_TIMES_ASSIGN     -> type(OP_TIMES_ASSIGN);
M_INTERP_OP_TIMES:          OP_TIMES            -> type(OP_TIMES);
M_INTERP_OP_DIV_ASSIGN:     OP_DIV_ASSIGN       -> type(OP_DIV_ASSIGN);
M_INTERP_OP_DIV:            OP_DIV              -> type(OP_DIV);
M_INTERP_OP_MOD_ASSIGN:     OP_MOD_ASSIGN       -> type(OP_MOD_ASSIGN);
M_INTERP_OP_MOD:            OP_MOD              -> type(OP_MOD);
M_INTERP_OP_INCREMENT:      OP_INCREMENT        -> type(OP_INCREMENT);
M_INTERP_OP_PLUS_ASSIGN:    OP_PLUS_ASSIGN      -> type(OP_PLUS_ASSIGN);
M_INTERP_OP_PLUS:           OP_PLUS             -> type(OP_PLUS);
M_INTERP_OP_DECREMENT:      OP_DECREMENT        -> type(OP_DECREMENT);
M_INTERP_OP_MINUS_ASSIGN:   OP_MINUS_ASSIGN     -> type(OP_MINUS_ASSIGN);
M_INTERP_OP_MINUS:          OP_MINUS            -> type(OP_MINUS);
M_INTERP_OP_CONJ_AND:       OP_CONJ_AND         -> type(OP_CONJ_AND);
M_INTERP_OP_AND_ASSIGN:     OP_AND_ASSIGN       -> type(OP_AND_ASSIGN);
M_INTERP_OP_AMP:            OP_AMP              -> type(OP_AMP);
M_INTERP_OP_DISJ_OR:        OP_DISJ_OR          -> type(OP_DISJ_OR);
M_INTERP_OP_OR_ASSIGN:      OP_OR_ASSIGN        -> type(OP_OR_ASSIGN);
M_INTERP_OP_OR:             OP_OR               -> type(OP_OR);
M_INTERP_OP_XOR:            OP_XOR              -> type(OP_XOR);
M_INTERP_OP_XOR_ASSIGN:     OP_XOR_ASSIGN       -> type(OP_XOR_ASSIGN);
M_INTERP_OP_INV_ASSIGN:     OP_INV_ASSIGN       -> type(OP_INV_ASSIGN);
M_INTERP_OP_INV:            OP_INV              -> type(OP_INV);
// ---------- Attribute usage sites
M_INTERP_AUS_FIELD:         AUS_FIELD           -> type(AUS_FIELD);
M_INTERP_AUS_FILE:          AUS_FILE            -> type(AUS_FILE);
M_INTERP_AT:                AT                  -> type(AT);
// ---------- Identifiers
M_INTERP_IDENTIFIER:        IDENTIFIER          -> type(IDENTIFIER);
M_INTERP_LINE_COMMENT:      LINE_COMMENT        -> channel(HIDDEN);
M_INTERP_BLOCK_COMMENT:     BLOCK_COMMENT       -> channel(HIDDEN);
M_INTERP_WS:                WS                  -> channel(HIDDEN);
M_INTERP_NL:                NL                  -> channel(HIDDEN);