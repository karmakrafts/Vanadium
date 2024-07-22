parser grammar FerrousParser;

/**
 * @author Alexander Hinze
 * @since 24/09/2022
 */

options {
    tokenVocab = FerrousLexer;
}

file:
    moduleFile
    | sourceFile
    ;

moduleFile:
    NL*
    moduleDeclaration
    (useModuleStatement | NL)*?
    EOF
    ;

sourceFile:
    (declaration | NL)*?
    EOF
    ;

moduleDeclaration:
    KW_MOD
    identifier
    ;

useModuleStatement:
    KW_USE
    KW_MOD
    anyIdentifier
    ;

declaration:
    useModuleStatement
    | useStatement
    | userDefinedType
    | typeAlias
    | function
    | constructor
    | destructor
    | (protoFunction end?)
    | (property end?)
    | (field end?)
    ;

typeAlias:
    KW_TYPE
    identifier
    genericParameterList?
    OP_ASSIGN
    (expression | type)
    ;

useStatement:
    KW_USE
    anyIdentifier
    (DOUBLE_COLON
    L_BRACE
    useTypeList?
    R_BRACE)?
    ;

useTypeList:
    useType
    (COMMA useType)*?
    ;

useType:
    anyIdentifier
    (KW_AS
    anyIdentifier)?
    ;

userDefinedType:
    enumClass
    | enum
    | struct
    | class
    | interface
    | attribute
    | trait
    ;

enumClassBody:
    L_BRACE
    enumConstantList
    (SEMICOLON
    (declaration | NL)*?)?
    R_BRACE
    ;

enumClass:
    (attributeUsage NL*)*?
    accessModifier?
    KW_UNSAFE?
    KW_ENUM
    KW_CLASS
    identifier
    (COLON typeList)?
    enumClassBody
    ;

enumBody:
    L_BRACE
    enumConstantList
    R_BRACE
    ;

enum:
    (attributeUsage NL*)*?
    accessModifier?
    KW_ENUM
    identifier
    enumBody
    ;

enumConstantList:
    (enumConstant
    | (enumConstant COMMA)
    | NL)*?
    ;

enumConstant:
    identifier
    (OP_ASSIGN
    expression)?
    ;

structBody:
    L_BRACE
    (declaration | NL)*?
    R_BRACE
    ;

struct:
    (attributeUsage NL*)*?
    accessModifier?
    KW_UNSAFE?
    KW_STRUCT
    identifier
    genericParameterList? // Optional because of chevrons
    (COLON
    typeList)?
    structBody
    ;

classBody:
    L_BRACE
    (declaration | NL)*?
    R_BRACE
    ;

class:
    (attributeUsage NL*)*?
    (accessModifier NL*)?
    (KW_UNSAFE NL*)?
    (KW_CLASS NL*)?
    (L_PAREN
    (KW_ATOMIC NL*)?
    uintType
    R_PAREN NL*)?
    identifier
    genericParameterList? // Optional because of chevrons
    (COLON
    typeList)?
    classBody
    ;

interfaceBody:
    L_BRACE
    (declaration
    | protoFunction
    | NL)*?
    R_BRACE
    ;

interface:
    (attributeUsage NL*)*?
    accessModifier?
    KW_UNSAFE?
    KW_INTERFACE
    identifier
    genericParameterList? // Optional because of chevrons
    (COLON typeList)?
    interfaceBody
    ;

attributeBody:
    L_BRACE
    (declaration
    | NL)*?
    R_BRACE
    ;

attribute:
    (attributeUsage NL*)*?
    accessModifier?
    KW_UNSAFE?
    KW_ATTRIB
    identifier
    genericParameterList? // Optional because of chevrons
    (COLON typeList)?
    attributeBody
    ;

trait:
    (attributeUsage NL*)*?
    accessModifier?
    KW_UNSAFE?
    KW_TRAIT
    identifier
    genericParameterList? // Optional because of chevrons
    (COLON typeList)?
    structBody
    ;

attributeUsage:
    AT
    anyIdentifier
    (NL*
    L_PAREN
    NL*
    (namedExpressionList | expressionList)
    NL*
    R_PAREN)?
    ;

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
    identifier
    NL*?
    R_PAREN
    NL*?
    (inlineFunctionBody | functionBody)
    ;

property:
    (attributeUsage NL*)*?
    accessModifier?
    KW_UNSAFE?
    NL*?
    (KW_INL NL*)?
    identifier
    NL*?
    COLON
    NL*?
    type
    NL*?
    (inlinePropertyBody | propertyBody)
    ;

inlinePropertyBody:
    ARROW
    expression
    ;

propertyBody:
    L_BRACE
    NL*?
    propertyGetter
    (NL* propertySetter)?
    NL*?
    R_BRACE
    ;

field:
    (attributeUsage NL*)*?
    (accessModifier NL*)?
    (fieldModifier NL*)*?
    identifier
    NL*?
    COLON
    NL*?
    type
    (NL* OP_ASSIGN NL* (expression | QMK))?
    ;

fieldModifier:
    KW_STATIC
    | KW_CONST
    | KW_MUT
    | KW_EXPECT
    | KW_ACTUAL
    | KW_TLS
    ;

constructor:
    accessModifier?
    KW_UNSAFE?
    identifier
    L_PAREN
    parameterList
    R_PAREN
    (COLON (thisCall | superCall))?
    (functionBody | inlineFunctionBody)?
    ;

thisCall:
    KW_THIS
    L_PAREN
    expressionList
    R_PAREN
    ;

superCall:
    KW_SUPER
    L_PAREN
    expressionList
    R_PAREN
    ;

destructor:
    KW_UNSAFE?
    OP_INV
    identifier
    L_PAREN
    parameterList
    R_PAREN
    (functionBody | inlineFunctionBody)?
    ;

gotoStatement:
    KW_GOTO
    COLON
    identifier
    ;

gotoAddressStatement:
    KW_GOTO
    ASTERISK
    expression
    ;

continueStatement:
    (KW_CONTINUE
    COLON
    identifier)
    | KW_CONTINUE
    ;

yieldStatement:
    KW_YIELD
    (COLON
    identifier)?
    expression
    ;

breakStatement:
    (KW_BREAK
    COLON
    identifier)
    | KW_BREAK
    ;

statement:
    (letStatement
    | panicStatement
    | destructureStatement
    | returnStatement
    | gotoAddressStatement
    | gotoStatement
    | continueStatement
    | yieldStatement
    | breakStatement
    | KW_UNREACHABLE
    | labelBlock
    | label
    | expression)
    end?
    ;

label:
    identifier
    COLON
    ;

labelBlock:
    identifier
    COLON
    L_BRACE
    (statement | declaration | NL)*?
    R_BRACE
    ;

destructureStatement:
    KW_LET
    KW_MUT?
    AMP?
    L_BRACKET
    inferredParamList
    R_BRACKET
    OP_ASSIGN
    expression
    ;

inferredParamList:
    identifier
    (COMMA identifier)*
    ;

panicStatement:
    KW_CONST?
    KW_PANIC
    L_PAREN
    stringLiteral
    R_PAREN
    ;

returnStatement:
    (KW_RETURN
    expression)
    | KW_RETURN
    ;

whenExpression:
    KW_WHEN
    L_PAREN
    expression
    R_PAREN
    L_BRACE
    (whenBranch | NL)*?
    defaultWhenBranch?
    NL*?
    R_BRACE
    ;

whenBranch:
    expressionList
    ARROW
    ((expression end)
    | whenBranchBody)
    ;

defaultWhenBranch:
    KW_DEFAULT
    ARROW
    ((expression end)
    | whenBranchBody)
    ;

whenBranchBody:
    L_BRACE
    (statement | declaration | NL)*?
    R_BRACE
    ;

loop:
    KW_LOOP
    ((expression end)
    | labelBlock
    | ((NL*
    KW_DEFAULT
    expression)?
    L_BRACE
    (statement | declaration | NL)*?
    R_BRACE))
    ;

whileLoop:
    whileDoLoop
    | simpleWhileLoop
    | doWhileLoop
    ;

simpleWhileLoop:
    whileHead
    ((expression end)
    | whileBody)
    ;

whileBody:
    labelBlock
    | ((NL*
    KW_DEFAULT
    expression)?
    L_BRACE
    (statement | declaration | NL)*?
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
    expression
    NL*?
    R_PAREN)
    ;

doStatement:
    KW_DO
    NL*?
    ((expression end)
    | doBody)
    ;

doBody:
    (L_BRACE
    (declaration | NL)*?
    R_BRACE)
    ;

forLoop:
    KW_FOR
    NL*?
    (indexedLoopHead
    | rangedLoopHead)
    ((expression end)
    | labelBlock
    | ((NL*
    KW_DEFAULT
    expression)?
    L_BRACE
    (declaration | NL)*?
    R_BRACE))
    ;

rangedLoopHead:
    L_PAREN
    NL*?
    identifier
    NL*?
    KW_IN
    NL*?
    expression
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
    expression?
    NL*?
    SEMICOLON
    NL*?
    expression?
    NL*?
    R_PAREN
    ;

ifExpression:
    (KW_CONST NL*)?
    KW_IF
    NL*
    L_PAREN
    expression
    R_PAREN
    NL*
    ifBody
    elseIfExpression+?
    elseExpression?
    ;

elseIfExpression:
    KW_ELSE
    NL*
    KW_IF
    NL*
    L_PAREN
    NL*
    expression
    NL*
    R_PAREN
    NL*
    ifBody
    ;

elseExpression:
    KW_ELSE
    NL*
    ifBody
    ;

ifBody:
    (L_BRACE
    (statement | NL)*?
    R_BRACE)
    | statement
    ;

functionBody:
    L_BRACE
    (statement | declaration | NL)*?
    R_BRACE
    ;

function:
    protoFunction
    (functionBody | inlineFunctionBody)
    ;

letStatement:
    KW_LET
    NL*?
    (KW_STATIC NL*)?
    (KW_MUT NL*)?
    identifier
    NL*?
    (COLON type)?
    (OP_ASSIGN (expression | QMK))?
    ;

inlineFunctionBody:
    ARROW
    expression
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
    | identifier
    ;

protoFunction:
    (attributeUsage NL*)*?
    (accessModifier
    NL*)?
    (functionModifier
    NL*)*?
    (callingConvention
    NL*)?
    KW_FUN
    NL*?
    functionIdent
    NL*?
    (genericParameterList
    NL*)?
    (L_PAREN
    NL*
    parameterList
    NL*
    R_PAREN)?
    (COLON NL*? type)?
    ;

parameterList:
    (parameter
    (COMMA parameter)*?)?
    |
    ((parameter (COMMA parameter)*?)
    (COMMA TRIPLE_DOT))
    ;

parameter:
    (parameterModifier NL*)?
    identifier NL*
    COLON NL*
    type NL*
    (OP_ASSIGN NL* expression)?
    ;

parameterModifier:
    KW_CONST
    | KW_MUT
    | KW_INIT // Allows passing uninitialized memory, implies initialization
    ;

namedExpression:
    identifier
    OP_ASSIGN
    expression
    ;

namedExpressionList:
    (namedExpression
    | (namedExpression COMMA))+
    ;

expressionList:
    (expression
    | (expression COMMA))+
    ;

scopeLabel:
    identifier
    AT
    ;

anonymousScope:
    (attributeUsage NL*)*?
    (KW_UNSAFE NL*)?
    (scopeLabel NL*)?
    L_BRACE
    (declaration | NL)*?
    R_BRACE
    ;

unsafeExpression:
    KW_UNSAFE
    expression
    ;

parameterReference:
    KW_FUN
    DOT
    identifier
    ;

typeExpression:
    KW_TYPE
    L_PAREN
    type
    R_PAREN
    ;

identifierExpression:
    KW_IDENT
    L_PAREN
    anyIdentifier
    R_PAREN
    ;

literalExpression:
    KW_LITERAL
    L_PAREN
    literal
    R_PAREN
    ;

expressionExpression:
    KW_EXPR
    L_PAREN
    expression
    R_PAREN
    ;

tokenExpression:
    TOKEN_BEGIN
    TOKEN_MODE_TOKEN
    R_PAREN
    ;

primary:
    ifExpression
    | whenExpression
    | lambdaExpression
    | initExpression
    | stackAllocExpression
    | sizedSliceExpression
    | sliceInitExpression
    | exhaustiveIfExpression
    | exhaustiveWhenExpression
    | forLoop
    | whileLoop
    | loop
    | anonymousScope
    | alignofExpression
    | sizeofExpression
    | typeExpression
    | literalExpression
    | expressionExpression
    | tokenExpression
    | identifierExpression
    | unsafeExpression
    | parameterReference
    | literal
    | anyIdentifier
    ;

expression: // C++ operator precedence used as a reference
    primary
    | L_PAREN expression R_PAREN
    | expression (KW_AS | KW_AS_QMK) (UNDERSCORE | type)
    | expression (KW_IS | KW_IS_NOT) type
    | expression (KW_IN | KW_IN_NOT) expression
    | expression (DOUBLE_DOT | OP_INCL_RANGE) expression
    | expression (OP_INCREMENT | OP_DECREMENT | OP_INV_ASSIGN)
    | expression genericList? L_PAREN (namedExpressionList | expressionList)? R_PAREN
    | expression L_BRACKET expressionList R_BRACKET
    | expression (DOT | ARROW | OP_SAFE_PTR_REF) identifier
    | <assoc=right> (
        OP_INCREMENT | OP_DECREMENT | OP_PLUS | OP_MINUS
        | OP_INV | OP_NOT | ASTERISK | OP_SAFE_DEREF | OP_LABEL_ADDR | AMP
    ) expression
    | expression (OP_MEMBER_DEREF | OP_MEMBER_PTR_DEREF) identifier
    | expression (ASTERISK | OP_DIV | OP_MOD | OP_SAT_TIMES | OP_SAT_DIV | OP_SAT_MOD) (expression | TRIPLE_DOT)
    | expression (OP_PLUS | OP_MINUS | OP_SAT_PLUS | OP_SAT_MINUS) (expression | TRIPLE_DOT)
    | expression (OP_LSH | OP_RSH) (expression | TRIPLE_DOT)
    | expression OP_COMPARE (expression | TRIPLE_DOT)
    | expression (OP_LEQUAL | OP_GEQUAL | L_CHEVRON | R_CHEVRON) expression
    | expression (OP_EQ | OP_NEQ) expression
    | expression AMP (expression | TRIPLE_DOT)
    | expression OP_XOR (expression | TRIPLE_DOT)
    | expression PIPE (expression | TRIPLE_DOT)
    | expression OP_SHORTC_AND (expression | TRIPLE_DOT)
    | expression OP_SHORTC_OR (expression | TRIPLE_DOT)
    | expression OP_ELVIS expression
    | <assoc=right> expression QMK expression COLON expression
    | <assoc=right> expression (
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
    ) expression
    | expression TRIPLE_DOT
    ;

lambdaExpression:
    callingConvention?
    L_PAREN
    parameterList
    R_PAREN
    (ARROW
    type)?
    L_BRACE
    (declaration | NL)*?
    R_BRACE
    ;

alignofExpression:
    KW_ALIGNOF
    NL*?
    L_PAREN
    NL*?
    anyIdentifier
    NL*?
    R_PAREN
    ;

sizeofExpression:
    KW_SIZEOF
    NL*?
    (TRIPLE_DOT NL*)?
    L_PAREN
    NL*?
    anyIdentifier
    NL*?
    R_PAREN
    ;

exhaustiveIfExpression:
    KW_IF
    L_PAREN
    expression
    R_PAREN
    ((declaration end)
    | ifBody)
    elseIfExpression+?
    elseExpression
    ;

exhaustiveWhenExpression:
    KW_WHEN
    expression
    L_BRACE
    (whenBranch | NL)*?
    defaultWhenBranch
    NL*?
    R_BRACE
    ;

sizedSliceExpression:
    L_BRACKET
    (type | sizedSliceExpression)
    COMMA
    intLiteral
    R_BRACKET
    ;

sliceInitExpression:
    L_BRACKET
    expressionList
    R_BRACKET
    ;

stackAllocExpression:
    KW_STACKALLOC
    L_BRACKET
    (type | sizedSliceExpression)?
    COMMA
    expression
    R_BRACKET
    ;

initExpression:
    type?
    L_BRACE
    (namedExpressionList | expressionList)?
    R_BRACE
    ;

genericParameterList:
    L_CHEVRON
    genericParameter
    (COMMA genericParameter)*?
    R_CHEVRON
    ;

genericParameter:
    identifier
    TRIPLE_DOT?
    (COLON genericExpression)?
    (OP_ASSIGN (expression | type))?
    ;

primaryGenericExpression:
    KW_CONST?
    (typeMod*? type)
    | KW_FUN
    ;

genericExpression:
    primaryGenericExpression
    | genericGroupedExpression
    | OP_NOT genericExpression
    | genericExpression genericOp genericExpression
    ;

genericGroupedExpression:
    L_PAREN
    genericExpression
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
    expression*?
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
    expression*?
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
    expression*?
    R_BRACE))+
    CML_STRING_END)
    | EMPTY_CML_STRING
    ;

accessModifier:
    (KW_PUB
    L_PAREN
    (KW_MOD
    | (COLON)
    | typeList)
    R_PAREN)
    | KW_PUB
    ;

callingConvention:
    KW_CALLCONV
    L_PAREN
    identifier
    R_PAREN
    ;

functionModifier:
    (KW_CONST QMK?)
    | KW_INL
    | KW_VIRTUAL
    | KW_OVERRIDE
    | KW_OP
    | KW_STATIC
    | KW_EXTERN
    | KW_UNSAFE
    | KW_EXPECT
    | KW_ACTUAL
    ;

typeMod:
    KW_ATOMIC
    | KW_MUT
    | KW_TLS
    | KW_VOLATILE
    | KW_EXPECT
    | KW_ACTUAL
    ;

typeList:
    type
    (COMMA type)*?
    ;

imaginaryType:
    KW_TYPE
    | KW_EXPR
    | KW_IDENT
    | KW_LITERAL
    | KW_TOKEN
    | KW_STRING
    ;

primaryType:
    attributeUsage*? // Allow applying attributes to type usages
    typeMod*?
    (functionType
    | tupleType
    | sliceType
    | builtinType
    | imaginaryType
    | qualifiedIdentifier
    | IDENT)
    ;

type:
    type L_CHEVRON typeList R_CHEVRON
    | type typeMod*? (ASTERISK | AMP)
    | primaryType
    ;

tupleType:
    L_PAREN
    typeList
    R_PAREN
    ;

functionType:
    callingConvention?
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

qualifiedIdentifier:
    identifier
    (DOUBLE_COLON identifier)+
    ;

softKeyword:
    KW_GET
    | KW_SET
    | KW_MOD
    | imaginaryType // All imaginary types are also soft keywords
    ;

identifier:
    softKeyword
    | IDENT
    ;

anyIdentifier:
    qualifiedIdentifier
    | identifier
    ;

end:
    SEMICOLON
    | NL
    ;
