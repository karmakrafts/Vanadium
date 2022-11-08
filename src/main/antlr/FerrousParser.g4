parser grammar FerrousParser;

/**
 * @author Alexander Hinze
 * @since 24/09/2022
 */

options {
    tokenVocab = FerrousLexer;
}

// Files
file:
    moduleFile
    | sourceFile
    ;

moduleFile:
    NL*
    moduleDecl
    (moduleUsageDecl
    | NL)*
    EOF
    ;

moduleDecl:
    KW_MOD
    (qualifiedIdent
    | ident)
    ;

moduleUsageDecl:
    KW_USE
    KW_MOD
    (qualifiedIdent
    | ident)
    ;

sourceFile:
    (expr
    | NL)+
    EOF
    ;

// Expressions
expr:
    literal
    | ref // Refs should have low precedence, like idents
    ;

// References
ref:
    specialRef
    | simpleRef
    ;

simpleRef:
    (qualifiedIdent
    | ident)
    (binaryRefOp
    ident)*
    ;

specialRef:
    unaryRefOp
    ref
    ;

binaryRefOp:
    OP_SAFE_PTR_REF
    | ARROW
    | DOT
    ;

unaryRefOp:
    OP_SAFE_DEREF
    | ASTERISK
    | AMP
    ;

// Literals
literal:
    boolLiteral
    | intLiteral
    | uintLiteral
    | floatLiteral
    | stringLiteral
    | LITERAL_CHAR
    | KW_NULL
    ;

boolLiteral:
    KW_TRUE
    | KW_FALSE;

intLiteral:
    LITERAL_I8
    | LITERAL_I16
    | LITERAL_I32
    | LITERAL_I64
    ;

uintLiteral:
    LITERAL_U8
    | LITERAL_U16
    | LITERAL_U32
    | LITERAL_U64
    ;

floatLiteral:
    LITERAL_F32
    | LITERAL_F64
    ;

stringLiteral:
    multilineStringLiteral
    | simpleStringLiteral
    ;

simpleStringLiteral:
    (DOUBLE_QUOTE
        (STRING_MODE_TEXT
        | STRING_MODE_ESCAPED_STRING_END
        | STRING_MODE_ESCAPED_CHAR
        | STRING_MODE_LERP_BEGIN
        | R_BRACE)+
    DOUBLE_QUOTE)
    | EMPTY_STRING
    ;

multilineStringLiteral:
    (ML_STRING_BEGIN
        (ML_STRING_MODE_TEXT
        | ML_STRING_MODE_ESCAPED_ML_STRING_END
        | ML_STRING_MODE_ESCAPED_CHAR
        | ML_STRING_MODE_LERP_BEGIN
        | R_BRACE)+
    ML_STRING_END)
    | EMPTY_ML_STRING
    ;

// Identifiers
qualifiedIdent:
    ident
    (DOUBLE_COLON
    ident)+
    ;

ident:
    ((TOKEN_LERP_BEGIN
        (MACRO_IDENT
        | specialToken)
    R_BRACE)
    | IDENT)+
    ;

specialToken:
    DOLLAR
    | COMMA
    | DOUBLE_COLON
    | COLON
    | TRIPLE_DOT
    | DOUBLE_DOT
    | DOT
    ;