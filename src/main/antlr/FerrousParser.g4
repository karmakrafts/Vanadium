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
script_file:
    package_decl?
    fn_body_decl*
    EOF
    ;

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
    | pc_decl
    | label_decl
    ;

label_decl:
    ident COLON semi?
    ;

import_decl:
    KW_IMPORT package_ident semi?
    ;

package_decl:
    KW_PACKAGE package_ident semi?
    ;

package_ident:
    ident (WS* DOT WS* ident)*
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
    visibility_mod? KW_CONST KW_ATTRIB ident L_CRL_PAREN
        attrib_body_decl*
    R_CRL_PAREN
    ;

attrib_body_decl:
    field_decl
    | pc_decl
    ;

// Interfaces
iface_decl:
    visibility_mod? KW_INTERFACE ident generic_params_decl? generic_constraints_decl? L_CRL_PAREN
        iface_body_decl*
    R_CRL_PAREN
    ;

iface_body_decl:
    iface_proto_decl
    | pc_decl
    ;

iface_proto_decl:
    fn_proto_decl semi?
    ;

// Structures
struct_decl:
    visibility_mod? KW_STRUCT ident generic_params_decl? generic_constraints_decl? L_CRL_PAREN
        struct_body_decl*
    R_CRL_PAREN
    ;

struct_body_decl:
    field_decl
    | fn_decl
    | pc_decl
    ;

// Enum classes
enum_class_decl:
    visibility_mod? KW_STATIC? KW_ENUM KW_CLASS ident L_CRL_PAREN
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
    visibility_mod? (KW_ABSTRACT|KW_STATIC)? KW_CLASS ident generic_params_decl? generic_constraints_decl? L_CRL_PAREN
        class_body_decl*
    R_CRL_PAREN
    ;

class_body_decl:
    decl // This just delegates for now..
    ;

// Traits
trait_decl:
    visibility_mod? KW_TRAIT ident generic_params_decl? generic_constraints_decl? L_CRL_PAREN
        trait_body_decl*
    R_CRL_PAREN
    ;

trait_body_decl:
    fn_decl
    | pc_decl
    ;

// Enums
enum_decl:
    visibility_mod? KW_ENUM ident L_CRL_PAREN
        enum_body_decl
    R_CRL_PAREN
    ;

enum_body_decl:
    (enum_field_decl COMMA?)*
    ;

enum_field_decl:
    ident
    | pc_decl
    ;

// -------------------- Pre-compiler
pc_decl:
    pc_define_decl
    | pc_undef_decl
    | pc_macro_decl
    | pc_assert_decl
    | pc_for_decl
    | pc_conj_decl
    | pc_disj_decl
    | pc_macro_call
    ;

// Control flow


// Conjunctive token addition
pc_conj_decl:
    pc_lhs_conj_decl
    | pc_rhs_conj_decl
    ;

pc_lhs_conj_decl:
    PC_KW_CONJ L_PAREN expr COMMA pc_junction_del R_PAREN
    ;

pc_rhs_conj_decl:
    PC_KW_CONJ L_PAREN pc_junction_del COMMA expr R_PAREN
    ;

// Disjunctive token addition
pc_disj_decl:
    pc_lhs_disj_decl
    | pc_rhs_disj_decl
    ;

pc_lhs_disj_decl:
    PC_KW_DISJ L_PAREN expr COMMA pc_junction_del R_PAREN
    ;

pc_rhs_disj_decl:
    PC_KW_DISJ L_PAREN pc_junction_del COMMA expr R_PAREN
    ;

pc_junction_del:
    unary_op
    | binary_op
    | COMMA
    | DOT
    | (QMK DOT)
    ;

// Defines
pc_define_decl:
    PC_KW_DEFINE pre_compiler_ident (ASSIGN expr)? semi?
    ;

pc_undef_decl:
    PC_KW_UNDEF pre_compiler_ident semi?
    ;

// Assertion
pc_assert_decl:
    pc_simple_assert_decl
    | pc_custom_assert_decl
    ;

pc_simple_assert_decl:
    PC_KW_ASSERT (expr | expl_pattern_expr) semi?
    ;

pc_custom_assert_decl:
    PC_KW_ASSERT L_PAREN ((expr | expl_pattern_expr) COMMA)? string_literal R_PAREN semi?
    ;

// For loops
pc_for_decl:
    pc_bodied_for_decl
    | pc_inline_for_decl
    ;

pc_bodied_for_decl:
    PC_KW_FOR for_head L_CRL_PAREN
        decl*
    R_CRL_PAREN
    ;

pc_inline_for_decl:
    PC_KW_FOR L_PAREN for_head R_PAREN (decl | expr) semi?
    ;

// Macros
pc_macro_call:
    ident OP_NOT L_PAREN (fn_call_param COMMA?)* R_PAREN
    ;

pc_macro_decl:
    pc_simple_macro_decl
    | pc_matching_macro_decl
    ;

pc_matching_macro_decl:
    visibility_mod? PC_KW_MACRO ident L_CRL_PAREN
        pc_macro_match_branch*
        pc_default_macro_match_branch?
    R_CRL_PAREN
    ;

pc_macro_match_branch:
    L_PAREN ((pc_macro_params_decl | pc_macro_match_group) COMMA?)* R_PAREN ARROW pc_macro_match_scope
    ;

pc_default_macro_match_branch:
    L_PAREN R_PAREN ARROW pc_macro_match_scope
    ;

pc_macro_match_scope:
    pc_bodied_macro_match_scope
    | pc_inline_macro_match_scope
    ;

pc_bodied_macro_match_scope:
    L_CRL_PAREN pc_macro_body_decl* R_CRL_PAREN
    ;

pc_inline_macro_match_scope:
    pc_macro_body_decl semi?
    ;

pc_macro_match_group:
    DOLLAR L_PAREN (pc_macro_params_decl | pc_macro_match_group) R_PAREN pc_macro_match_op?
    ;

pc_macro_match_op:
    (QMK | OP_TIMES | OP_PLUS) | (HASH L_CRL_PAREN (int_literal | range_expr) R_CRL_PAREN)
    ;

pc_simple_macro_decl:
    visibility_mod? PC_KW_MACRO ident L_PAREN pc_macro_params_decl R_PAREN L_CRL_PAREN
        pc_macro_body_decl*
    R_CRL_PAREN
    ;

pc_macro_body_decl:
    decl
    | fn_body_decl
    ;

pc_macro_params_decl:
    (pc_macro_param_decl COMMA?)+
    ;

pc_macro_param_decl:
    impl_pc_ident COLON pc_macro_param_type (ASSIGN expr)?
    ;

pc_macro_param_type:
    type
    | pc_macro_token_type
    ;

pc_macro_token_type:
    KW_TYPE
    | KW_EXPR
    | KW_IDENT
    | KW_LITERAL
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
    visibility_mod? fn_proto_decl ARROW fn_body_decl semi?
    ;

fn_proto_decl:
    fn_named_proto_decl
    | fn_op_proto_decl
    ;

fn_named_proto_decl:
    fn_mod* KW_FN ident generic_params_decl? params_decl fn_return_type? generic_constraints_decl?
    ;

fn_op_proto_decl:
    fn_mod* KW_OP KW_FN (unary_op | binary_op) generic_params_decl? params_decl fn_return_type? generic_constraints_decl?
    ;

fn_return_type:
    COLON type
    ;

fn_body_decl:
    fn_decl // Allow nested functions
    | fn_call
    | fn_return
    | for_decl
    | goto_statement
    | variable_decl
    | named_scope_decl
    | (expr semi?)
    | pc_decl
    | label_decl
    ;

named_scope_decl:
    label_decl L_CRL_PAREN fn_body_decl* R_CRL_PAREN
    ;

goto_statement:
    KW_GOTO ident
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
    variable_ref* ident L_PAREN (fn_call_param COMMA?)* R_PAREN
    ;

fn_call_param:
    literal
    | expr
    | ident
    ;

// Parameters
params_decl:
    L_PAREN (param_decl(COMMA?))* R_PAREN
    ;

param_decl:
    param_mod? ident COLON type param_default_value?
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
    KW_LET variable_mod? ident COLON type (ASSIGN expr)? semi?
    ;

implicit_variable_decl:
    KW_LET variable_mod? ident ASSIGN expr semi?
    ;

variable_mod:
    KW_STATIC
    | KW_CONST
    | KW_MUT
    ;

// References (null-safety assertion)
variable_ref:
    asserted_ref
    | indexed_ref
    | (ident (DOT QMK? ident)*)
    ;

indexed_ref:
    ident indexed_ref_group
    ;

indexed_ref_group:
    L_SQR_PAREN expr (COMMA indexed_ref_group)? R_SQR_PAREN
    ;

asserted_ref:
    ident OP_NASRT
    ;

// -------------------- Fields
field_decl:
    init_field_decl
    | late_field_decl
    ;

init_field_decl:
    visibility_mod? field_mod* ident COLON type ASSIGN expr semi?
    ;

late_field_decl:
    visibility_mod? field_mod* KW_LATE ident COLON type semi?
    ;

field_mod:
    KW_STATIC
    | KW_CONST
    | KW_MUT
    ;

// -------------------- Loops
for_decl:
    bodied_for_decl
    | inline_for_decl
    ;

bodied_for_decl:
    KW_FOR for_head L_CRL_PAREN
        decl*
    R_CRL_PAREN
    ;

inline_for_decl:
    KW_FOR L_PAREN for_head R_PAREN (decl | expr) semi?
    ;

for_head:
    ranged_for_head
    | simple_for_head
    ;

ranged_for_head:
    ident KW_IN (range_expr | ident)
    ;

simple_for_head:
    ident (COLON type)? ASSIGN expr SEMICOLON
    expr SEMICOLON
    expr
    ;

// -------------------- Generics
// Constraints
generic_constraints_decl:
    KW_WHERE ((ident COLON generic_constraint_list) COMMA?)+
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
    ident (COLON generic_constraint_list)?
    ;

const_generic_param_decl:
    KW_CONST ident COLON type (ASSIGN expr)?
    ;

// -------------------- Expressions
// Arrays
array_expr:
    L_SQR_PAREN ((expr | pc_decl) COMMA?)* R_SQR_PAREN
    ;

// Object initializer
obj_init_expr:
    type L_CRL_PAREN ((expr | pc_decl) COMMA?)* R_CRL_PAREN
    ;

// Ranges
range_expr:
    incl_range_expr
    | excl_range_expr
    ;

incl_range_expr:
    expr_type DOUBLE_DOT expr_type
    ;

excl_range_expr:
    expr_type DOUBLE_DOT ASSIGN expr_type
    ;

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
    | when_expr
    | if_expr
    | range_expr
    | array_expr
    ;

// Pattern matching - these are not included with the default set of raw expressions!
pattern_expr:
    expl_pattern_expr
    | impl_pattern_expr
    ;

impl_pattern_expr:
    impl_type_pattern_expr
    | impl_contains_pattern_expr
    ;

expl_pattern_expr:
    expl_type_pattern_expr
    | expl_contains_pattern_expr
    ;

expl_type_pattern_expr:
    ident impl_type_pattern_expr // Allow inline declaration
    ;

impl_type_pattern_expr:
    KW_IS generic_constraint ident?
    ;

expl_contains_pattern_expr:
    ident impl_contains_pattern_expr
    ;

impl_contains_pattern_expr:
    KW_IN ident
    ;

// When expressions
when_expr:
    KW_WHEN when_head? L_CRL_PAREN
        when_branch*
        default_when_branch?
    R_CRL_PAREN
    ;

when_head:
    expr
    | variable_decl
    ;

when_branch:
    when_conditional_expr ARROW when_scope_expr
    ;

default_when_branch:
    KW_ELSE ARROW when_scope_expr
    ;

when_scope_expr:
    when_bodied_scope_expr
    | when_inline_scope_expr
    ;

when_bodied_scope_expr:
    L_CRL_PAREN fn_body_decl R_CRL_PAREN
    ;

when_inline_scope_expr:
    fn_body_decl semi? // This just delegates for now..
    ;

when_conditional_expr:
    expr | pattern_expr
    ;

// If expressions
if_expr:
    if_bodied_expr
    | if_inline_expr
    ;

if_bodied_expr:
    KW_IF if_conditional_expr_type L_CRL_PAREN
        fn_body_decl*
    R_CRL_PAREN
    else_if_branch*
    else_branch?
    ;

if_inline_expr:
    KW_IF L_PAREN if_conditional_expr_type R_PAREN fn_body_decl semi?
    else_if_branch*
    else_branch?
    ;

// Else if
else_if_branch:
    else_if_bodied_branch
    | else_if_inline_branch
    ;

else_if_bodied_branch:
    KW_ELSE KW_IF if_conditional_expr_type L_CRL_PAREN
        fn_body_decl*
    R_CRL_PAREN
    ;

else_if_inline_branch:
    KW_ELSE KW_IF L_PAREN if_conditional_expr_type R_PAREN fn_body_decl semi?
    ;

// Else
else_branch:
    else_bodied_branch
    | else_inline_branch
    ;

else_bodied_branch:
    KW_ELSE L_CRL_PAREN
        fn_body_decl*
    R_CRL_PAREN
    ;

else_inline_branch:
    KW_ELSE fn_body_decl semi?
    ;

if_conditional_expr_type:
    expl_pattern_expr
    | expr
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
    OP_TIMES
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
    | OP_XOR
    | OP_XOR_ASSIGN
    | OP_LEQ
    | OP_L_SHIFT
    | OP_L_SHIFT_ASSIGN
    | L_ANGLE
    | OP_GEQ
    | OP_R_SHIFT
    | OP_R_SHIFT_ASSIGN
    | R_ANGLE
    | OP_NEQ
    | DOUBLE_EQ
    | TRIPLE_EQ
    | OP_SPACESHIP
    | OP_PLUS
    | OP_PLUS_ASSIGN
    | OP_MINUS
    | OP_MINUS_ASSIGN
    | OP_IFN
    | OP_IFN_ASSIGN
    | OP_CONJ_AND
    | OP_DISJ_OR
    ;

// Increment and decrement
incr_expr:
    pre_incr_expr
    | post_incr_expr
    ;

pre_incr_expr:
    OP_INCREMENT variable_ref
    ;

post_incr_expr:
    variable_ref OP_INCREMENT
    ;

decr_expr:
    pre_decr_expr
    | post_decr_expr
    ;

pre_decr_expr:
    OP_DECREMENT variable_ref
    ;

post_decr_expr:
    variable_ref OP_DECREMENT
    ;

// Misc
simple_expr:
    pc_macro_call
    | obj_init_expr
    | variable_ref
    | fn_call
    | incr_expr
    | decr_expr
    | literal
    ;

expr_type:
    literal
    | ident
    ;

// -------------------- Literals
literal:
    primitive_literal
    | string_literal
    | KW_NULL
    | type_literal
    | size_literal
    | alignment_literal
    | default_literal
    ;

default_literal:
    KW_DEFAULT (L_PAREN type R_PAREN)?
    ;

type_literal:
    KW_TYPEOF L_PAREN type R_PAREN
    ;

size_literal:
    KW_SIZEOF L_PAREN type R_PAREN
    ;

alignment_literal:
    KW_ALIGNOF L_PAREN type R_PAREN
    ;

string_literal:
    simple_string_literal
    | raw_string_literal
    ;

raw_string_literal:
    (RAW_STRING (M_RAW_STRING_TEXT | M_RAW_STRING_DONT_LOOK)* M_RAW_STRING_END)
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
    nonnull_type
    | nullable_type
    ;

nonnull_type:
    array_type
    | simple_type
    ;

nullable_type:
    (array_type | simple_type) QMK?
    ;

array_type:
    L_SQR_PAREN type R_SQR_PAREN
    ;

simple_type:
    primitive_type
    | native_size_type
    | KW_TYPE_STR
    | KW_SELF
    | ident
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

ident:
    (pre_compiler_ident | IDENTIFIER)+
    ;

pre_compiler_ident:
    impl_pc_ident
    | expl_pc_ident
    ;

impl_pc_ident:
    DOLLAR IDENTIFIER
    ;

expl_pc_ident:
    DOLLAR L_CRL_PAREN (impl_pc_ident | expr) R_CRL_PAREN
    ;

semi:
    (SEMICOLON | NL) NL*
    | EOF
    ;