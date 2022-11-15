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
    NL*?
    moduleDecl
    (modUseDecl
    | NL)*?
    EOF
    ;

moduleDecl:
    KW_MOD
    (qualifiedIdent
    | ident)
    ;

modUseDecl:
    KW_USE
    KW_MOD
    (qualifiedIdent
    | ident)
    ;

sourceFile:
    (decl
    | NL)*?
    EOF
    ;

decl:
    modUseDecl
    | statement
    | useDecl
    | expr
    | udtDecl
    | functionDecl
    | fieldDecl
    | variableDecl
    ;

useDecl:
    KW_USE
    (qualifiedIdent
    | ident)
    (DOUBLE_COLON
    useList)?
    ;

useList:
    L_BRACE
    typeList
    R_BRACE
    ;

// User defined types
udtDecl:
    enumClassDecl
    | classDecl
    | enumDecl
    | structDecl
    | interfaceDecl
    | attribDecl
    | traitDecl
    ;

enumClassDecl:
    accessMod?
    KW_ENUM
    KW_CLASS
    ident
    genericParamList? // Optional because of chevrons
    (COLON
    typeList)?
    L_BRACE
    enumConstantList
    SEMICOLON
    (decl
    | NL)*?
    R_BRACE
    ;

classDecl:
    accessMod?
    KW_CLASS
    ident
    genericParamList? // Optional because of chevrons
    (COLON
    typeList)?
    (classBody
    | inlineClassBody)
    ;

classBody:
    L_BRACE
    (decl
    | NL)*?
    R_BRACE
    ;

inlineClassBody:
    L_PAREN
    functionParamList
    R_PAREN
    end
    ;

enumDecl:
    accessMod?
    KW_ENUM
    ident
    L_BRACE
    enumConstantList
    R_BRACE
    ;

enumConstantList:
    (enumConstant
    | (enumConstant
    COMMA)
    | NL)*?
    ;

enumConstant:
    (ident
    | (ident
    COMMA))
    ;

structDecl:
    accessMod?
    KW_STRUCT
    ident
    genericParamList? // Optional because of chevrons
    (COLON
    typeList)?
    (classBody
    | inlineClassBody)
    ;

interfaceDecl:
    accessMod?
    KW_INTERFACE
    ident
    genericParamList? // Optional because of chevrons
    (COLON
    typeList)?
    L_BRACE
    (decl
    | protoFunctionDecl
    | NL)*?
    R_BRACE
    ;

attribDecl:
    accessMod?
    KW_ATTRIB
    ident
    genericParamList? // Optional because of chevrons
    (COLON
    typeList)?
    inlineClassBody
    ;

traitDecl:
    accessMod?
    KW_TRAIT
    ident
    genericParamList? // Optional because of chevrons
    (COLON
    typeList)?
    (classBody
    | inlineClassBody)
    ;

// Fields
fieldDecl:
    accessMod?
    storageMod*?
    ident
    COLON
    type
    (OP_ASSIGN
    expr)?
    end
    ;

// Statements
statement:
    returnStatement
    | ifStatement
    | whenStatement
    ;

// Return statements
returnStatement:
    KW_RETURN
    expr
    ;

// When statements
whenStatement:
    KW_WHEN
    expr
    L_BRACE
    (whenBranch
    | NL)*?
    defaultWhenBranch?
    NL*?
    R_BRACE
    ;

whenBranch:
    exprList
    ARROW
    ((expr
    end)
    | whenBranchBody)
    ;

defaultWhenBranch:
    UNDERSCORE
    ARROW
    ((expr
    end)
    | whenBranchBody)
    ;

whenBranchBody:
    L_BRACE
    (decl
    | NL)*?
    R_BRACE
    ;

// If statements
ifStatement:
    KW_IF
    expr
    ((decl
    end)
    | ifBody)
    elseIfStatement*?
    elseStatement?
    ;

elseIfStatement:
    KW_ELSE
    KW_IF
    L_PAREN
    expr
    R_PAREN
    ((decl
    end)
    | ifBody)
    ;

elseStatement:
    KW_ELSE
    ((decl
    end)
    | ifBody)
    ;

ifBody:
    L_BRACE
    (decl
    | NL)*?
    R_BRACE
    ;

// Functions
functionDecl:
    protoFunctionDecl
    (functionBody
    | inlineFunctionBody)
    ;

functionBody:
    L_BRACE
    (decl
    | NL)*?
    R_BRACE
    ;

variableDecl:
    KW_LET
    storageMod*?
    ident
    (COLON
    type)?
    (OP_ASSIGN
    expr)?
    end
    ;

inlineFunctionBody:
    ARROW
    expr
    end
    ;

protoFunctionDecl:
    accessMod?
    functionMod*?
    KW_FN
    (binaryOp
    | unaryOp
    | OP_ASSIGN
    | ident)
    genericParamList? // Optional because of chevrons
    L_PAREN
    functionParamList
    R_PAREN
    (COLON
    type)?
    (KW_THROWS
    typeList)?
    ;

functionParamList:
    (functionParam
    | (functionParam
    COMMA))*?
    ;

functionParam:
    ident
    COLON
    type
    (OP_ASSIGN
    expr)?
    ;

// Expressions
exprList:
    (expr
    | (expr
    COMMA))*?
    ;

expr:
    simpleExpr
    | binaryExpr
    | tryExpr
    | heapInitExpr
    | stackInitExpr
    | stackAllocExpr
    | arrayExpr
    | arrayInitExpr
    | exhaustiveIfExpr
    | exhaustiveWhenExpr
    ;

groupedExpr:
    L_PAREN
    expr
    R_PAREN
    ;

// Control flow expressions
exhaustiveIfExpr:
    KW_IF
    expr
    ((decl
    end)
    | ifBody)
    elseIfStatement*?
    elseStatement
    ;

exhaustiveWhenExpr:
    KW_WHEN
    expr
    L_BRACE
    (whenBranch
    | NL)*?
    defaultWhenBranch
    NL*?
    R_BRACE
    ;

// Array expressions
arrayExpr:
    L_BRACKET
    (type
    | arrayExpr)
    COMMA
    intLiteral
    R_BRACKET
    ;

arrayInitExpr:
    L_BRACKET
    exprList
    R_BRACKET
    ;

// stackalloc expressions
stackAllocExpr:
    KW_STACKALLOC
    L_BRACKET
    (type
    | arrayExpr)
    COMMA
    intLiteral
    R_BRACKET
    ;

// Initialization expressions
heapInitExpr:
    KW_NEW
    type?
    L_PAREN
    exprList
    R_PAREN
    ;

stackInitExpr:
    type?
    L_BRACE
    exprList
    R_BRACE
    ;

// Try expressions
tryExpr:
    KW_TRY
    expr
    ;

// Call expressions
callExpr:
    (ref
    binaryRefOp)?
    ident
    genericList?
    L_PAREN
    exprList
    R_PAREN
    ;

// Binary expressions
simpleExpr:
    groupedExpr
    | callExpr
    | unaryExpr
    | literal
    | ref // Refs should have low precedence, like idents
    ;

binaryExpr:
    simpleExpr
    binaryOp
    expr
    ;

binaryOp:
    OP_SWAP

    | OP_COMPARE
    | OP_EQUAL
    | OP_LEQUAL
    | OP_GEQUAL
    | L_CHEVRON
    | R_CHEVRON

    | OP_PLUS
    | OP_MINUS
    | ASTERISK
    | OP_DIV
    | OP_MOD

    | OP_SAT_PLUS
    | OP_SAT_MINUS
    | OP_SAT_TIMES
    | OP_SAT_DIV
    | OP_SAT_MOD

    | OP_PLUS_ASSIGN
    | OP_MINUS_ASSIGN
    | OP_TIMES_ASSIGN
    | OP_MOD_ASSIGN

    | OP_SAT_PLUS_ASSIGN
    | OP_SAT_MINUS_ASSIGN
    | OP_SAT_TIMES_ASSIGN
    | OP_SAT_DIV_ASSIGN
    | OP_SAT_MOD_ASSIGN

    | OP_INV_ASSIGN
    ;

// Unary expressions
unaryExpr:
    unaryOp
    expr
    ;

unaryOp:
    OP_PLUS
    | OP_MINUS
    | OP_INV
    ;

// References
ref:
    specialRef
    | simpleRef
    | methodRef
    ;

simpleRef:
    (qualifiedIdent
    | ident)
    (binaryRefOp
    ident)*?
    ;

binaryRefOp:
    OP_SAFE_PTR_REF
    | ARROW
    | DOT
    ;

specialRef:
    unaryRefOp
    ref
    ;

unaryRefOp:
    OP_SAFE_DEREF
    | ASTERISK
    | AMP
    ;

methodRef:
    (qualifiedIdent
    | ident)?
    DOUBLE_COLON
    ident
    ;

// Generics
genericParamList:
    L_CHEVRON
    (genericParam
    | (genericParam
    COMMA))+
    R_CHEVRON
    ;

genericParam:
    ident
    (COLON
    genericExpr)?
    (OP_ASSIGN
    type)?
    ;

genericExpr:
    genericBinaryExpr
    | genericBinaryExprLhs
    ;

genericGroupedExpr:
    L_PAREN
    genericExpr
    R_PAREN
    ;

genericBinaryExpr:
    genericBinaryExprLhs
    genericOp
    genericExpr
    ;

genericBinaryExprLhs:
    genericGroupedExpr
    | type
    ;

genericOp:
    AMP
    | PIPE
    ;

genericList:
    L_CHEVRON
    (type
    | (type
    COMMA))+
    R_CHEVRON
    ;

// Literals
literal:
    boolLiteral
    | intLiteral
    | floatLiteral
    | stringLiteral
    | LITERAL_CHAR
    | KW_NULL
    ;

boolLiteral:
    KW_TRUE
    | KW_FALSE;

intLiteral:
    sintLiteral
    | uintLiteral
    ;

sintLiteral:
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
        | (STRING_MODE_LERP_BEGIN
        expr*?
        R_BRACE))+
    DOUBLE_QUOTE)
    | EMPTY_STRING
    ;

multilineStringLiteral:
    (ML_STRING_BEGIN
        (ML_STRING_MODE_TEXT
        | ML_STRING_MODE_ESCAPED_ML_STRING_END
        | ML_STRING_MODE_ESCAPED_CHAR
        | (ML_STRING_MODE_LERP_BEGIN
        expr*?
        R_BRACE))+
    ML_STRING_END)
    | EMPTY_ML_STRING
    ;

// Modifiers
accessMod:
    (KW_PUB
    L_PAREN
    (KW_MOD
    | (COLON
    KW_THIS)
    | type)
    R_PAREN)
    | KW_PUB
    ;

functionMod:
    KW_STATIC
    | KW_CONST
    | KW_INL
    | KW_OVERRIDE
    | KW_VIRTUAL
    | KW_OP
    ;

storageMod:
    KW_STATIC
    | KW_CONST
    | KW_TLS
    ;

typeMod:
    KW_ATOMIC
    ;

// Types
typeList:
    (type
    | (type
    COMMA))+?
    ;

type:
    arrayType
    | genericType
    | simpleType
    ;

simpleType:
    refType
    | pointerType
    | builtinType
    | nullableType
    | ident
    ;

nullableType:
    QMK
    type
    ;

refType:
    AMP
    type
    ;

pointerType:
    typeMod*?
    ASTERISK
    type
    ;

genericType:
    simpleType
    genericList
    ;

arrayType:
    L_BRACKET
    type
    R_BRACKET
    ;

builtinType:
    typeMod*?
    (intType
    | floatType
    | KW_VOID
    | KW_BOOL
    | KW_CHAR
    | KW_STRING)
    ;

intType:
    sintType
    | uintType
    ;

sintType:
    KW_I8
    | KW_I16
    | KW_I32
    | KW_I64
    ;

uintType:
    KW_U8
    | KW_U16
    | KW_U32
    | KW_U64
    ;

floatType:
    KW_F32
    | KW_F64
    ;

// Identifiers
qualifiedIdent:
    ident
    (DOUBLE_COLON
    ident)+
    (DOUBLE_COLON
    ASTERISK)?
    ;

ident:
    (((TOKEN_LERP_BEGIN
        (MACRO_IDENT
        | specialToken)
    R_BRACE)
    | IDENT)+)
    | UNDERSCORE
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

end:
    SEMICOLON
    | NL
    ;