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
    module
    (modUseStatement | NL)*?
    EOF?
    ;

module:
    KW_MOD
    (qualifiedIdent | ident)
    ;

modUseStatement:
    KW_USE
    KW_MOD
    (qualifiedIdent | ident)
    ;

sourceFile:
    (decl | NL)*?
    EOF?
    ;

decl:
    modUseStatement
    | useStatement
    | udt
    | typeAlias
    | function
    | constructor
    | destructor
    | (protoFunction end)
    | (property end)
    | (field end)
    | (statement end)
    ;

typeAlias:
    KW_TYPE
    ident
    genericParamList?
    OP_ASSIGN
    type
    ;

useStatement:
    KW_USE
    (qualifiedIdent | ident)
    (DOUBLE_COLON useList)?
    ;

useList:
    L_BRACE
    NL*?
    useTypeList
    NL*?
    R_BRACE
    ;

useTypeList:
    (useType
    | (useType COMMA NL*?))+?
    ;

useType:
    type
    (KW_AS
    ident)?
    ;

// User defined types
udt:
    enumClass
    | enum
    | struct
    | interface
    | attrib
    | trait
    ;

enumClassBody:
    L_BRACE
    enumConstantList
    (SEMICOLON
    (decl | NL)*?)?
    R_BRACE
    ;

enumClass:
    attributeList
    accessMod?
    KW_UNSAFE?
    KW_ENUM
    KW_CLASS
    ident
    (COLON typeList)?
    enumClassBody
    ;

enumBody:
    L_BRACE
    enumConstantList
    R_BRACE
    ;

enum:
    attributeList
    accessMod?
    KW_ENUM
    ident
    enumBody
    ;

enumConstantList:
    (enumConstant
    | (enumConstant COMMA)
    | NL)*?
    ;

enumConstant:
    ident
    (OP_ASSIGN
    expr)?
    ;

structBody:
    L_BRACE
    (decl | NL)*?
    R_BRACE
    ;

struct:
    attributeList
    accessMod?
    KW_UNSAFE?
    KW_STRUCT
    ident
    genericParamList? // Optional because of chevrons
    (COLON
    typeList)?
    structBody
    ;

interfaceBody:
    L_BRACE
    (decl
    | protoFunction
    | NL)*?
    R_BRACE
    ;

interface:
    attributeList
    accessMod?
    KW_UNSAFE?
    KW_INTERFACE
    ident
    genericParamList? // Optional because of chevrons
    (COLON typeList)?
    interfaceBody
    ;

attribBody:
    L_BRACE
    (decl
    | NL)*?
    R_BRACE
    ;

attrib:
    attributeList
    accessMod?
    KW_UNSAFE?
    KW_ATTRIB
    ident
    genericParamList? // Optional because of chevrons
    (COLON typeList)?
    attribBody
    ;

trait:
    attributeList
    accessMod?
    KW_UNSAFE?
    KW_TRAIT
    ident
    genericParamList? // Optional because of chevrons
    (COLON typeList)?
    structBody
    ;

// Attributes
attributeList:
    (attribUsage end?)*?
    ;

attribUsage:
    AT
    (qualifiedIdent | ident)
    (NL*
    L_PAREN
    NL*
    (namedExprList | exprList)
    NL*
    R_PAREN)?
    ;

// Properties
propertyGetter:
    KW_UNSAFE?
    KW_GET
    NL*?
    (inlineFunctionBody | functionBody)
    ;

propertySetter:
    KW_UNSAFE?
    KW_SET
    NL*?
    L_PAREN
    NL*?
    ident
    NL*?
    R_PAREN
    NL*?
    (inlineFunctionBody | functionBody)
    ;

property:
    attributeList
    accessMod?
    KW_UNSAFE?
    NL*?
    (KW_INL NL*)?
    ident
    NL*?
    COLON
    NL*?
    type
    NL*?
    (inlinePropertyBody | propertyBody)
    ;

inlinePropertyBody:
    ARROW
    expr
    ;

propertyBody:
    L_BRACE
    NL*?
    propertyGetter
    (NL* propertySetter)?
    NL*?
    R_BRACE
    ;

// Fields
field:
    attributeList
    (accessMod
    NL*)?
    (KW_STATIC
    NL*)?
    (KW_MUT
    NL*)?
    ident
    NL*?
    COLON
    NL*?
    type
    (NL* OP_ASSIGN NL* (expr | QMK))?
    ;

// Constructors
constructor:
    accessMod?
    KW_UNSAFE?
    ident
    L_PAREN
    functionParamList
    R_PAREN
    (COLON (thisCall | superCall))?
    (functionBody | inlineFunctionBody)?
    ;

thisCall:
    KW_THIS
    L_PAREN
    exprList
    R_PAREN
    ;

superCall:
    KW_SUPER
    L_PAREN
    exprList
    R_PAREN
    ;

// Destructors
destructor:
    KW_UNSAFE?
    OP_INV
    ident
    L_PAREN
    functionParamList
    R_PAREN
    (functionBody | inlineFunctionBody)?
    ;

gotoStatement:
    KW_GOTO
    COLON
    IDENT
    ;

continueStatement:
    (KW_CONTINUE
    COLON
    IDENT)
    | KW_CONTINUE
    ;

yieldStatement:
    KW_YIELD
    (COLON
    IDENT)?
    expr
    ;

breakStatement:
    (KW_BREAK
    COLON
    IDENT)
    | KW_BREAK
    ;

// Statements
statement:
    letStatement
    | panicStatement
    | destructureStatement
    | returnStatement
    | gotoStatement
    | continueStatement
    | yieldStatement
    | breakStatement
    | KW_UNREACHABLE
    | labelBlock
    | label
    | expr
    ;

label:
    IDENT
    COLON
    ;

labelBlock:
    IDENT
    COLON
    L_BRACE
    (decl | NL)*?
    R_BRACE
    ;

// Destrucuring statements
destructureStatement:
    KW_LET
    KW_MUT?
    AMP?
    L_BRACKET
    inferredParamList
    R_BRACKET
    OP_ASSIGN
    expr
    ;

inferredParamList:
    (ident
    (COMMA ident)*)?
    ;

// Panic statements
panicStatement:
    KW_CONST?
    KW_PANIC
    L_PAREN
    stringLiteral
    R_PAREN
    ;

// Return statements
returnStatement:
    (KW_RETURN
    expr)
    | KW_RETURN
    ;

// When expressions
whenExpr:
    KW_WHEN
    expr
    L_BRACE
    (whenBranch | NL)*?
    defaultWhenBranch?
    NL*?
    R_BRACE
    ;

whenBranch:
    exprList
    ARROW
    ((expr end)
    | whenBranchBody)
    ;

defaultWhenBranch:
    UNDERSCORE
    ARROW
    ((expr end)
    | whenBranchBody)
    ;

whenBranchBody:
    L_BRACE
    (decl | NL)*?
    R_BRACE
    ;

// Loops
loop:
    KW_LOOP
    ((expr end)
    | labelBlock
    | ((NL*
    KW_DEFAULT
    expr)?
    L_BRACE
    (decl | NL)*?
    R_BRACE))
    ;

// While loops
whileLoop:
    whileDoLoop
    | simpleWhileLoop
    | doWhileLoop
    ;

simpleWhileLoop:
    whileHead
    ((expr end)
    | whileBody)
    ;

whileBody:
    labelBlock
    | ((NL*
    KW_DEFAULT
    expr)?
    L_BRACE
    (decl | NL)*?
    R_BRACE)
    ;

doWhileLoop:
    doStatement
    end?
    whileHead
    ;

whileDoLoop:
    whileHead
    end?
    doStatement
    ;

whileHead:
    KW_WHILE
    NL*?
    (L_PAREN
    NL*?
    expr
    NL*?
    R_PAREN)
    ;

doStatement:
    KW_DO
    NL*?
    ((expr end)
    | doBody)
    ;

doBody:
    (L_BRACE
    (decl | NL)*?
    R_BRACE)
    ;

// For loops
forLoop:
    KW_FOR
    NL*?
    (indexedLoopHead
    | rangedLoopHead)
    ((expr end)
    | labelBlock
    | ((NL*
    KW_DEFAULT
    expr)?
    L_BRACE
    (decl | NL)*?
    R_BRACE))
    ;

rangedLoopHead:
    L_PAREN
    NL*?
    ident
    NL*?
    KW_IN
    NL*?
    expr
    NL*?
    R_PAREN
    ;

indexedLoopHead:
    L_PAREN
    NL*?
    letStatement?
    NL*?
    SEMICOLON
    NL*?
    expr?
    NL*?
    SEMICOLON
    NL*?
    expr?
    NL*?
    R_PAREN
    ;

// If expressions
ifExpr:
    (KW_CONST
    NL*)?
    KW_IF
    NL*
    L_PAREN
    NL*
    expr
    NL*
    R_PAREN
    ifBody
    elseIfExpr*?
    elseExpr?
    ;

elseIfExpr:
    KW_ELSE
    NL*
    KW_IF
    NL*
    L_PAREN
    NL*
    expr
    NL*
    R_PAREN
    NL*
    ((statement end)
    | ifBody)
    ;

elseExpr:
    KW_ELSE
    NL*
    ((statement end)
    | ifBody)
    ;

ifBody:
    (L_BRACE
    (statement | NL)*?
    R_BRACE)
    | statement
    ;

// Functions
functionBody:
    L_BRACE
    (statement | NL)*?
    R_BRACE
    ;

function:
    protoFunction
    (functionBody | inlineFunctionBody)
    ;

letStatement:
    KW_LET
    NL*?
    (KW_MUT NL*)?
    ident
    NL*?
    (COLON type)?
    (OP_ASSIGN (expr | QMK))?
    ;

inlineFunctionBody:
    ARROW
    expr
    end
    ;

operator:
    OP_PLUS
    | OP_MINUS
    | ASTERISK
    | OP_DIV
    | OP_MOD
    | OP_SAT_PLUS
    | OP_SAT_MINUS
    | OP_SAT_TIMES
    | OP_SAT_DIV
    | OP_SAT_MOD
    | OP_SHORTC_AND
    | OP_SHORTC_OR
    | AMP
    | PIPE
    | OP_XOR
    | OP_LSH
    | OP_RSH
    | OP_INV
    | OP_ASSIGN
    | OP_PLUS_ASSIGN
    | OP_MINUS_ASSIGN
    | OP_TIMES_ASSIGN
    | OP_DIV_ASSIGN
    | OP_MOD_ASSIGN
    | OP_SAT_PLUS_ASSIGN
    | OP_SAT_MINUS_ASSIGN
    | OP_SAT_TIMES_ASSIGN
    | OP_SAT_DIV_ASSIGN
    | OP_SAT_MOD_ASSIGN
    | OP_AND_ASSIGN
    | OP_OR_ASSIGN
    | OP_XOR_ASSIGN
    | OP_LSH_ASSIGN
    | OP_RSH_ASSIGN
    | (UNDERSCORE OP_INCREMENT)
    | (OP_INCREMENT UNDERSCORE)
    | OP_INCREMENT
    | (UNDERSCORE OP_DECREMENT)
    | (OP_DECREMENT UNDERSCORE)
    | OP_DECREMENT
    | (UNDERSCORE OP_INV_ASSIGN)
    | (OP_INV_ASSIGN UNDERSCORE)
    | OP_INV_ASSIGN
    ;

functionIdent:
    operator
    | ident
    ;

protoFunction:
    attributeList
    (accessMod
    NL*)?
    (functionMod
    NL*)*?
    (callConvMod
    NL*)?
    KW_FUN
    NL*?
    functionIdent
    NL*?
    (genericParamList
    NL*)?
    (L_PAREN
    NL*
    functionParamList
    NL*
    R_PAREN)?
    (COLON NL*? type)?
    ;

functionParamList:
    (functionParam
    (COMMA functionParam)*?)?
    |
    ((functionParam (COMMA functionParam)*?)
    (COMMA TRIPLE_DOT))
    ;

functionParam:
    ident
    COLON
    type
    (OP_ASSIGN expr)?
    ;

// Expressions
namedExpr:
    ident
    OP_ASSIGN
    expr
    ;

namedExprList:
    (namedExpr
    | (namedExpr COMMA))+
    ;

exprList:
    (expr
    | (expr COMMA))+
    ;

unsafeBlock:
    KW_UNSAFE
    L_BRACE
    (decl | NL)*?
    R_BRACE
    ;

unsafeExpr:
    KW_UNSAFE
    expr
    ;

primary:
    unsafeBlock
    | unsafeExpr
    | ifExpr
    | whenExpr
    | lambdaExpr
    | heapInitExpr
    | stackInitExpr
    | stackAllocExpr
    | sizedSliceExpr
    | sliceInitExpr
    | exhaustiveIfExpr
    | exhaustiveWhenExpr
    | forLoop
    | whileLoop
    | loop
    | alignofExpr
    | sizeofExpr
    | literal
    | qualifiedIdent
    | ident
    ;

expr: // C++ operator precedence used as a reference
    primary
    | L_PAREN expr R_PAREN
    | expr (KW_AS | KW_AS_QMK) type
    | expr (KW_IS | KW_IS_NOT) type
    | expr (KW_IN | KW_IN_NOT) expr
    | expr (DOUBLE_DOT | OP_INCL_RANGE) expr
    | expr (OP_INCREMENT | OP_DECREMENT | OP_INV_ASSIGN)
    | expr genericList? L_PAREN (namedExprList | exprList)? R_PAREN
    | expr L_BRACKET exprList R_BRACKET
    | expr (DOT | ARROW | OP_SAFE_PTR_REF) ident
    | <assoc=right> (
        OP_INCREMENT | OP_DECREMENT | OP_PLUS | OP_MINUS
        | OP_INV | OP_NOT | ASTERISK | OP_SAFE_DEREF | AMP
    ) expr
    | expr (OP_MEMBER_DEREF | OP_MEMBER_PTR_DEREF) (expr | TRIPLE_DOT)
    | expr (ASTERISK | OP_DIV | OP_MOD | OP_SAT_TIMES | OP_SAT_DIV | OP_SAT_MOD) (expr | TRIPLE_DOT)
    | expr (OP_PLUS | OP_MINUS | OP_SAT_PLUS | OP_SAT_MINUS) (expr | TRIPLE_DOT)
    | expr (OP_LSH | OP_RSH) (expr | TRIPLE_DOT)
    | expr OP_COMPARE (expr | TRIPLE_DOT)
    | expr (OP_LEQUAL | OP_GEQUAL | L_CHEVRON | R_CHEVRON) expr
    | expr (OP_EQ | OP_NEQ) expr
    | expr AMP (expr | TRIPLE_DOT)
    | expr OP_XOR (expr | TRIPLE_DOT)
    | expr PIPE (expr | TRIPLE_DOT)
    | expr OP_SHORTC_AND (expr | TRIPLE_DOT)
    | expr OP_SHORTC_OR (expr | TRIPLE_DOT)
    | expr OP_ELVIS expr
    | <assoc=right> expr QMK expr COLON expr
    | <assoc=right> expr (
        OP_ASSIGN
        | OP_SAT_PLUS_ASSIGN
        | OP_SAT_MINUS_ASSIGN
        | OP_SAT_TIMES_ASSIGN
        | OP_SAT_DIV_ASSIGN
        | OP_SAT_MOD_ASSIGN
        | OP_PLUS_ASSIGN
        | OP_MINUS_ASSIGN
        | OP_TIMES_ASSIGN
        | OP_DIV_ASSIGN
        | OP_AND_ASSIGN
        | OP_OR_ASSIGN
        | OP_XOR_ASSIGN
        | OP_RSH_ASSIGN
        | OP_LSH_ASSIGN
        | OP_MOD_ASSIGN
        | OP_SWAP
    ) expr
    | expr TRIPLE_DOT
    ;

lambdaExpr:
    callConvMod?
    L_PAREN
    functionParamList
    R_PAREN
    (ARROW
    type)?
    L_BRACE
    (decl | NL)*?
    R_BRACE
    ;

alignofExpr:
    KW_ALIGNOF
    NL*?
    L_PAREN
    NL*?
    ident
    NL*?
    R_PAREN
    ;

sizeofExpr:
    KW_SIZEOF
    NL*?
    (TRIPLE_DOT NL*)?
    L_PAREN
    NL*?
    ident
    NL*?
    R_PAREN
    ;

// Control flow expressions
exhaustiveIfExpr:
    KW_IF
    expr
    ((decl end)
    | ifBody)
    elseIfExpr*?
    elseExpr
    ;

exhaustiveWhenExpr:
    KW_WHEN
    expr
    L_BRACE
    (whenBranch | NL)*?
    defaultWhenBranch
    NL*?
    R_BRACE
    ;

// Array expressions
sizedSliceExpr:
    L_BRACKET
    (type | sizedSliceExpr)
    COMMA
    intLiteral
    R_BRACKET
    ;

sliceInitExpr:
    L_BRACKET
    exprList
    R_BRACKET
    ;

// stackalloc expressions
stackAllocExpr:
    KW_STACKALLOC
    L_BRACKET
    (type | sizedSliceExpr)?
    COMMA
    expr
    R_BRACKET
    ;

// Initialization expressions
heapInitExpr:
    KW_NEW
    (sizedSliceExpr
    | (type?
    L_PAREN
    (namedExprList | exprList)?
    R_PAREN))
    ;

stackInitExpr:
    type?
    L_BRACE
    (namedExprList | exprList)?
    R_BRACE
    ;

// Generics
genericParamList:
    L_CHEVRON
    genericParam
    (COMMA genericParam)*?
    R_CHEVRON
    ;

genericParam:
    IDENT
    TRIPLE_DOT?
    (COLON genericExpr)?
    (OP_ASSIGN type)?
    ;

genericExpr:
    genericGroupedExpr
    | OP_NOT genericExpr
    | genericExpr genericOp genericExpr
    | type
    ;

genericGroupedExpr:
    L_PAREN
    genericExpr
    R_PAREN
    ;

genericOp:
    AMP
    | PIPE
    ;

genericList:
    L_CHEVRON
    (type
    | (type COMMA))+
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
    | KW_THIS
    ;

boolLiteral:
    KW_TRUE
    | KW_FALSE;

intLiteral:
    sintLiteral
    | uintLiteral
    ;

sintLiteral:
    LITERAL_INT
    | LITERAL_ISIZE
    ;

uintLiteral:
    LITERAL_UINT
    | LITERAL_USIZE
    ;

floatLiteral:
    LITERAL_F16
    | LITERAL_F32
    | LITERAL_F64
    | LITERAL_F128
    ;

stringLiteral:
    cmlStringLiteral
    | mlStringLiteral
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

mlStringLiteral:
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

cmlStringLiteral:
    (CML_STRING_BEGIN
    (CML_STRING_MODE_TEXT
    | CML_STRING_MODE_ESCAPED_CML_STRING_END
    | CML_STRING_MODE_ESCAPED_CHAR
    | (CML_STRING_MODE_LERP_BEGIN
    expr*?
    R_BRACE))+
    CML_STRING_END)
    | EMPTY_CML_STRING
    ;

// Modifiers
accessMod:
    (KW_PUB
    L_PAREN
    (KW_MOD
    | (COLON)
    | typeList)
    R_PAREN)
    | KW_PUB
    ;

callConvMod:
    KW_CALLCONV
    L_PAREN
    IDENT
    R_PAREN
    ;

functionMod:
    KW_CONST
    | KW_INL
    | KW_VIRTUAL
    | KW_OVERRIDE
    | KW_OP
    | KW_STATIC
    | KW_EXTERN
    | KW_UNSAFE
    ;

typeMod:
    KW_ATOMIC
    | KW_MUT
    | KW_TLS
    | KW_VOLATILE
    ;

// Types
typeList:
    (type
    | (type COMMA))+?
    ;

modifiedType:
    (typeMod NL*)+
    type
    ;

type:
    modifiedType
    | functionType
    | tupleType
    | sliceType
    | type (ASTERISK | AMP)
    | builtinType
    | qualifiedIdent
    | ident
    ;

tupleType:
    L_PAREN
    typeList
    R_PAREN
    ;

functionType:
    callConvMod?
    (L_PAREN
    typeList?
    (COMMA
    TRIPLE_DOT)?
    R_PAREN)
    ARROW
    type
    ;

sliceType:
    L_BRACKET
    type
    R_BRACKET
    ;

builtinType:
    intType
    | floatType
    | miscType
    ;

miscType:
    KW_VOID
    | KW_BOOL
    | KW_CHAR
    | KW_STRING
    ;

intType:
    sintType
    | uintType
    ;

sintType:
    KW_ITYPE
    | KW_ISIZE
    ;

uintType:
    KW_UTYPE
    | KW_USIZE
    ;

floatType:
    KW_F16
    | KW_F32
    | KW_F64
    | KW_F128
    ;

// Identifiers
qualifiedIdent:
    ident
    (DOUBLE_COLON ident)+
    ;

lerpIdent:
    (TOKEN_LERP_BEGIN
    (MACRO_IDENT
    | specialToken)
    R_BRACE)+
    ;

ident:
    lerpIdent
    | UNDERSCORE
    | IDENT
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
    | EOF
    ;