parser grammar FerrousParser;

/*
 * Version: 1.0
 * Author(s):
 *	- Alexander 'KitsuneAlex' Hinze
 */

options {
    tokenVocab = FerrousLexer;
}

// -------------------- Files
file:
    package_decl?
    decl*
    EOF
    ;

decl:
    import_decl
    | udt_decl
    | fn_decl
    | field_decl
    ;

import_decl:
    KW_IMPORT package_ident semi?
    ;

package_decl:
    KW_PACKAGE package_ident semi?
    ;

package_ident:
    IDENTIFIER (WS* DOT WS* IDENTIFIER)*
    ;

// -------------------- User defined types
udt_decl:
    attrib_decl
    | iface_decl
    | struct_decl
    | class_decl
    | enum_class_decl
    | trait_decl
    | enum_decl
    ;

// Attributes
attrib_decl:
    visibility_mod? KW_CONST KW_ATTRIB IDENTIFIER L_CRL_PAREN
        attrib_body_decl*
    R_CRL_PAREN
    ;

attrib_body_decl:
    field_decl
    ;

// Interfaces
iface_decl:
    visibility_mod? KW_INTERFACE IDENTIFIER generic_params_decl? generic_constraints_decl? L_CRL_PAREN
        iface_body_decl*
    R_CRL_PAREN
    ;

iface_body_decl:
    iface_proto_decl
    ;

iface_proto_decl:
    fn_proto_decl semi?
    ;

// Structures
struct_decl:
    visibility_mod? KW_STRUCT IDENTIFIER generic_params_decl? generic_constraints_decl? L_CRL_PAREN
        struct_body_decl*
    R_CRL_PAREN
    ;

struct_body_decl:
    field_decl
    | fn_decl
    ;

// Enum classes
enum_class_decl:
    visibility_mod? KW_STATIC? KW_ENUM KW_CLASS IDENTIFIER L_CRL_PAREN
        enum_body_decl SEMICOLON
        enum_class_body_decl*
    R_CRL_PAREN
    ;

enum_class_body_decl:
    field_decl
    | fn_decl
    ;

// Classes
class_decl:
    visibility_mod? (KW_ABSTRACT|KW_STATIC)? KW_CLASS IDENTIFIER generic_params_decl? generic_constraints_decl? L_CRL_PAREN
        class_body_decl*
    R_CRL_PAREN
    ;

class_body_decl:
    decl // This just delegates for now..
    ;

// Traits
trait_decl:
    visibility_mod? KW_TRAIT IDENTIFIER generic_params_decl? generic_constraints_decl? L_CRL_PAREN
        trait_body_decl*
    R_CRL_PAREN
    ;

trait_body_decl:
    fn_decl // TODO: finish this..
    ;

// Enums
enum_decl:
    visibility_mod? KW_ENUM IDENTIFIER L_CRL_PAREN
        enum_body_decl
    R_CRL_PAREN
    ;

enum_body_decl:
    (enum_field_decl COMMA?)*
    ;

enum_field_decl:
    IDENTIFIER
    ;

// -------------------- Functions
fn_decl:
    fn_bodied_decl
    | fn_inline_decl
    ;

fn_bodied_decl:
    visibility_mod? fn_proto_decl L_CRL_PAREN
        fn_body_decl*
    R_CRL_PAREN
    ;

fn_inline_decl:
    visibility_mod? fn_proto_decl ARROW expr
    ;

fn_proto_decl:
    fn_mod* KW_FN IDENTIFIER generic_params_decl? params_decl fn_return_type? generic_constraints_decl?
    ;

fn_return_type:
    COLON type
    ;

fn_body_decl:
    fn_decl // Allow nested functions
    | fn_call
    | fn_return
    | variable_decl
    | (expr semi?)
    ;

fn_return:
    KW_RETURN expr?
    ;

fn_mod:
    KW_STATIC
    | KW_CONST
    | KW_INL
    ;

fn_call:
    IDENTIFIER L_PAREN (fn_call_param COMMA?)* R_PAREN
    ;

fn_call_param:
    literal
    | expr
    | IDENTIFIER
    ;

// Parameters
params_decl:
    L_PAREN (param_decl(COMMA?))* R_PAREN
    ;

param_decl:
    param_mod? IDENTIFIER COLON type param_default_value?
    ;

param_default_value:
    ASSIGN expr
    ;

param_mod:
    KW_MUT
    | KW_CONST
    ;

// -------------------- Variables
variable_decl:
    implicit_variable_decl
    | explicit_variable_decl
    ;

explicit_variable_decl:
    KW_LET variable_mod? IDENTIFIER COLON type (COLON type)? semi?
    ;

implicit_variable_decl:
    KW_LET variable_mod? IDENTIFIER ASSIGN expr semi?
    ;

variable_mod:
    KW_STATIC
    | KW_CONST
    | KW_MUT
    ;

// -------------------- Fields
field_decl:
    init_field_decl
    | late_field_decl
    ;

init_field_decl:
    visibility_mod? field_mod* IDENTIFIER COLON type ASSIGN expr semi?
    ;

late_field_decl:
    visibility_mod? field_mod* KW_LATE IDENTIFIER COLON type semi?
    ;

field_mod:
    KW_STATIC
    | KW_CONST
    | KW_MUT
    ;

// -------------------- Generics
// Constraints
generic_constraints_decl:
    KW_WHERE ((IDENTIFIER COLON generic_constraint_list) COMMA?)+
    ;

generic_constraint_list:
    (generic_constraint COMMA?)+
    ;

generic_constraint:
    type
    | generic_constraint_group
    ;

generic_constraint_group:
    L_PAREN ((generic_constraint_group | type)(OP_AMP | OP_OR)?)+ R_PAREN
    ;

// Parameters

generic_params_decl:
    L_ANGLE (generic_param_decl COMMA?)+ R_ANGLE
    ;

generic_param_decl:
    simple_generic_param_decl
    | const_generic_param_decl
    ;

simple_generic_param_decl:
    IDENTIFIER (COLON generic_constraint_list)?
    ;

const_generic_param_decl:
    KW_CONST IDENTIFIER COLON type (ASSIGN expr)?
    ;

// -------------------- Expressions
// General expressions
expr:
    raw_expr
    | grouped_expr
    ;

grouped_expr:
    L_PAREN raw_expr R_PAREN
    ;

raw_expr:
    simple_expr
    | unary_expr
    | binary_expr
    ;

// When expressions
when_expr:
    KW_WHEN // TODO: ...
    ;

// If expressions
if_expr:
    KW_IF // TODO: ...
    ;

// Unary
unary_expr:
    unary_op expr
    ;

unary_op:
    OP_PLUS
    | OP_MINUS
    | OP_INV
    | OP_INV_ASSIGN
    ;

// Binary
binary_expr:
    (simple_expr | unary_expr | grouped_expr) binary_op expr
    ;

binary_op:
    OP_PLUS
    | OP_PLUS_ASSIGN
    | OP_MINUS
    | OP_MINUS_ASSIGN
    | OP_TIMES
    | OP_TIMES_ASSIGN
    | OP_DIV
    | OP_DIV_ASSIGN
    | OP_MOD
    | OP_MOD_ASSIGN
    | OP_POW
    | OP_POW_ASSIGN
    | OP_AMP
    | OP_AND_ASSIGN
    | OP_OR
    | OP_OR_ASSIGN
    ;

simple_expr:
    literal
    | IDENTIFIER
    | fn_call
    ;

// -------------------- Literals
literal:
    primitive_literal
    | string_literal
    | KW_NULL
    ;

string_literal:
    simple_string_literal
    | raw_string_literal
    ;

raw_string_literal:
    (RAW_STRING M_RAW_STRING_TEXT DOUBLE_QUOTE)
    | EMPTY_RAW_STRING
    ;

simple_string_literal:
    (DOUBLE_QUOTE M_STRING_TEXT DOUBLE_QUOTE)
    | EMPTY_STRING
    ;

primitive_literal:
    bool_literal
    | int_literal
    | real_literal
    ;

real_literal:
    LITERAL_F32
    | LITERAL_F64
    ;

bool_literal:
    KW_TRUE
    | KW_FALSE
    ;

int_literal:
    s_int_literal
    | u_int_literal
    ;

u_int_literal:
    LITERAL_U8
    | LITERAL_U16
    | LITERAL_U32
    | LITERAL_U64
    ;

s_int_literal:
    LITERAL_I8
    | LITERAL_I16
    | LITERAL_I32
    | LITERAL_I64
    ;

// -------------------- Types
type:
    array_type
    | simple_type
    ;

array_type:
    L_SQR_PAREN (array_type | simple_type) R_SQR_PAREN
    ;

simple_type:
    primitive_type
    | native_size_type
    | IDENTIFIER
    ;

s_int_type:
    KW_TYPE_I8
    | KW_TYPE_I16
    | KW_TYPE_I32
    | KW_TYPE_I64
    ;

u_int_type:
    KW_TYPE_U8
    | KW_TYPE_U16
    | KW_TYPE_U32
    | KW_TYPE_U64
    ;

real_type:
    KW_TYPE_F32
    | KW_TYPE_F64
    ;

primitive_type:
    s_int_type
    | u_int_type
    | real_type
    | KW_TYPE_BOOL
    | KW_TYPE_CHAR
    | KW_TYPE_VOID
    ;

native_size_type:
    KW_TYPE_ISIZE
    | KW_TYPE_USIZE
    ;

// -------------------- Misc rules
visibility_mod:
    KW_PUB
    | KW_PRIV
    | KW_PROT
    | KW_INTERN
    | KW_GLOBAL
    ;

semi:
    (SEMICOLON | NL) NL*
    | EOF
    ;