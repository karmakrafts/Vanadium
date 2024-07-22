lexer grammar FerrousLexer;

/**
 * Official reference lexer grammar for the Ferrous
 * programming language.
 *
 * @author Alexander Hinze
 * @since 24/09/2022
 */

// Whitespace
LINE_COMMENT: '//' ~[\r\n]* -> channel(HIDDEN);
BLOCK_COMMENT: '/*' (BLOCK_COMMENT | .)*? '*/' -> channel(HIDDEN);
WS: [\u0020\u0009\u000C] -> channel(HIDDEN);
NL: ('\n' | ('\r' '\n'?));

// Parenthese, brackets, braces & chevrons
L_BRACE: '{' -> pushMode(DEFAULT_MODE);
R_BRACE: '}' -> popMode, type(R_BRACE);
L_BRACKET: '[' -> pushMode(DEFAULT_MODE);
R_BRACKET: ']' -> popMode, type(R_BRACKET);
L_PAREN: '(' -> pushMode(DEFAULT_MODE);
R_PAREN: ')' -> popMode, type(R_PAREN);
L_CHEVRON: '<';
R_CHEVRON: '>';

// Strings
CML_STRING_END: '"/';
ML_STRING_END: '"#';
EMPTY_STRING: '""';
DOUBLE_QUOTE: '"' -> pushMode(STRING_MODE);
EMPTY_CML_STRING: '/""/';
EMPTY_ML_STRING: '#""#';
CML_STRING_BEGIN: '/"' -> pushMode(CML_STRING_MODE);
ML_STRING_BEGIN: '#"' -> pushMode(ML_STRING_MODE);

// Token expressions
TOKEN_BEGIN: KW_TOKEN WS*? L_PAREN -> pushMode(TOKEN_MODE);

// Keywords
KW_UNREACHABLE: 'unreachable';
KW_STACKALLOC: 'stackalloc';
KW_INTERFACE: 'interface';
KW_OVERRIDE: 'override';
KW_CALLCONV: 'callconv';
KW_CONTINUE: 'continue';
KW_VOLATILE: 'volatile';
KW_ALIGNOF: 'alignof';
KW_VIRTUAL: 'virtual';
KW_LITERAL: 'literal';
KW_DEFAULT: 'default';
KW_UNSAFE: 'unsafe';
KW_STATIC: 'static';
KW_SIZEOF: 'sizeof';
KW_VAARGS: 'vaargs';
KW_RETURN: 'return';
KW_EXTERN: 'extern';
KW_STRUCT: 'struct';
KW_ATTRIB: 'attrib';
KW_DELETE: 'delete';
KW_ATOMIC: 'atomic';
KW_EXPECT: 'expect'; // Reserved for multiplatform support
KW_ACTUAL: 'actual'; // Reserved for multiplatform support
KW_PANIC: 'panic';
KW_TOKEN: 'token';
KW_WHILE: 'while';
KW_CONST: 'const';
KW_CLASS: 'class';
KW_TRAIT: 'trait';
KW_IDENT: 'ident';
KW_SUPER: 'super';
KW_YIELD: 'yield';
KW_BREAK: 'break';
KW_INIT: 'init';
KW_WHEN: 'when';
KW_ELSE: 'else';
KW_LOOP: 'loop';
KW_TYPE: 'type';
KW_EXPR: 'expr';
KW_ENUM: 'enum';
KW_GOTO: 'goto';
KW_NULL: 'null';
KW_THIS: 'this';
KW_FOR: 'for';
KW_PUB: 'pub';
KW_USE: 'use';
KW_MOD: 'mod';
KW_INL: 'inl';
KW_TLS: 'tls';
KW_LET: 'let';
KW_MUT: 'mut';
KW_FUN: 'fun';
KW_GET: 'get';
KW_SET: 'set';
KW_AS_QMK: 'as?';
KW_IS_NOT: '!is';
KW_IN_NOT: '!in';
KW_AS: 'as';
KW_IS: 'is';
KW_IN: 'in';
KW_OP: 'op';
KW_IF: 'if';
KW_DO: 'do';

KW_TRUE: 'true';
KW_FALSE: 'false';

KW_STRING: 'string';
KW_VOID: 'void';
KW_BOOL: 'bool';
KW_CHAR: 'char';
KW_ISIZE: 'isize';
KW_USIZE: 'usize';
KW_F16: 'f16';
KW_F32: 'f32';
KW_F64: 'f64';
KW_F128: 'f128';

KW_ITYPE: 'i' [0-9]+;
KW_UTYPE: 'u' [0-9]+;

// Operators
OP_INCL_RANGE: '..=';
OP_LSH_ASSIGN: '<<=';
OP_RSH_ASSIGN: '>>=';
OP_AND_ASSIGN: '&=';
OP_OR_ASSIGN: '|=';
OP_XOR_ASSIGN: '^=';

OP_COMPARE: '<=>';
OP_LSH: '<<';
OP_RSH: '>>';
OP_SWAP: '<->';
OP_EQ: '==';
OP_NEQ: '!=';

OP_SAFE_PTR_REF: '?->';
OP_ELVIS: '?:';
OP_SAFE_DEREF: '*?';
OP_MEMBER_DEREF: '.*';
OP_MEMBER_PTR_DEREF: '->*';
OP_LABEL_ADDR: '&:';

OP_LEQUAL: '<=';
OP_GEQUAL: '>=';

OP_SHORTC_AND: '&&';
OP_SHORTC_OR: '||';

OP_INCREMENT: '++';
OP_DECREMENT: '--';

OP_SAT_PLUS_ASSIGN: '+|=';
OP_SAT_MINUS_ASSIGN: '-|=';
OP_SAT_TIMES_ASSIGN: '*|=';
OP_SAT_DIV_ASSIGN: '/|=';
OP_SAT_MOD_ASSIGN: '%|=';

OP_PLUS_ASSIGN: '+=';
OP_MINUS_ASSIGN: '-=';
OP_TIMES_ASSIGN: '*=';
OP_DIV_ASSIGN: '/=';
OP_MOD_ASSIGN: '%=';
OP_INV_ASSIGN: '~~';
OP_ASSIGN: '=';

OP_SAT_PLUS: '+|';
OP_SAT_MINUS: '-|';
OP_SAT_TIMES: '*|';
OP_SAT_DIV: '/|';
OP_SAT_MOD: '%|';

OP_PLUS: '+';
OP_MINUS: '-';
OP_DIV: '/';
OP_MOD: '%';

OP_INV: '~';
OP_XOR: '^';
OP_NOT: '!';

// Multi-purpose tokens
// We don't explicitly call these operators, since they can also be used for multiple things
DOUBLE_ARROW: '=>';
ARROW: '->';
AMP: '&';
TRIPLE_DOT: '...';
DOUBLE_DOT: '..';
DOT: '.';
COMMA: ',';
DOUBLE_COLON: '::';
COLON: ':';
SEMICOLON: ';';
ASTERISK: '*';
PIPE: '|';
QMK: '?';
UNDERSCORE: '_';
AT: '@';

// Literals
fragment F_BIN_DIGIT: [01'];
fragment F_DEC_DIGIT: [0-9'];
fragment F_HEX_DIGIT: [0-9a-fA-F'];
fragment F_OCT_DIGIT: [0-7'];

fragment F_LITERAL_DEC_INT: F_DEC_DIGIT+;
fragment F_LITERAL_BIN_INT: '0' [bB] F_BIN_DIGIT+;
fragment F_LITERAL_HEX_INT: '0' [xX] F_HEX_DIGIT+;
fragment F_LITERAL_OCT_INT: '0' [oO] F_OCT_DIGIT+;
fragment F_LITERAL_INT: F_LITERAL_DEC_INT | F_LITERAL_BIN_INT | F_LITERAL_HEX_INT | F_LITERAL_OCT_INT;

LITERAL_INT: F_LITERAL_INT KW_ITYPE?;
LITERAL_ISIZE: F_LITERAL_INT KW_ISIZE;
LITERAL_UINT: F_LITERAL_INT KW_UTYPE;
LITERAL_USIZE: F_LITERAL_INT KW_USIZE;

fragment F_LITERAL_FLOAT: F_DEC_DIGIT+ ('.' F_DEC_DIGIT+)?;

LITERAL_F16: F_LITERAL_FLOAT KW_F16;
LITERAL_F32: F_LITERAL_FLOAT KW_F32?;
LITERAL_F64: F_LITERAL_FLOAT KW_F64;
LITERAL_F128: F_LITERAL_FLOAT KW_F128;

fragment F_ESCAPED_CHAR: '\\' [nrbt0];
LITERAL_CHAR: '\'' (F_ESCAPED_CHAR | .) '\'';

IDENT: [a-zA-Z_]+[a-zA-Z0-9_]*;

SINGLE_QUOTE: '\'';
DOLLAR: '$';
HASH: '#';

// Error handling
ERROR: .;

mode STRING_MODE;

STRING_MODE_ESCAPED_STRING_END: '\\' DOUBLE_QUOTE;
STRING_MODE_STRING_END: DOUBLE_QUOTE -> popMode, type(DOUBLE_QUOTE);
STRING_MODE_ESCAPED_CHAR: F_ESCAPED_CHAR;
STRING_MODE_LERP_BEGIN: '${' -> pushMode(DEFAULT_MODE);
STRING_MODE_TEXT: ~('\\' | '"' | '$')+ | '$';

mode ML_STRING_MODE;

ML_STRING_MODE_ESCAPED_ML_STRING_END: '\\' ML_STRING_END;
ML_STRING_MODE_ML_STRING_END: ML_STRING_END -> popMode, type(ML_STRING_END);
ML_STRING_MODE_ESCAPED_CHAR: F_ESCAPED_CHAR;
ML_STRING_MODE_LERP_BEGIN: '${' -> pushMode(DEFAULT_MODE);
ML_STRING_MODE_TEXT: ~('\\' | '"' | '$')+ | '$';

mode CML_STRING_MODE;

CML_STRING_MODE_ESCAPED_CML_STRING_END: '\\' CML_STRING_END;
CML_STRING_MODE_CML_STRING_END: CML_STRING_END -> popMode, type(CML_STRING_END);
CML_STRING_MODE_ESCAPED_CHAR: F_ESCAPED_CHAR;
CML_STRING_MODE_LERP_BEGIN: '${' -> pushMode(DEFAULT_MODE);
CML_STRING_MODE_TEXT: ~('\\' | '"' | '$')+ | '$';

mode TOKEN_MODE;

TOKEN_MODE_END: R_PAREN -> popMode, type(R_PAREN);
TOKEN_MODE_TOKEN: ~(')')+;
