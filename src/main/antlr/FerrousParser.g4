parser grammar FerrousParser;

/*
 * Reference implementation of a parser for the Ferrous
 * programming language.
 *
 * Version: 1.0
 * Author(s):
 *	- Alexander 'KitsuneAlex' Hinze
 */

options {
    tokenVocab = FerrousLexer;
}

eval:
    file
    | script_file
    ;

// -------------------------------------------------------------------------------- Files

/*
 * This is used when evaluating the entire source file as one big expression,
 * thus being able to return a result value from the root-scope of the source file.
 */
script_file:                    // ---------- Root-rule for parsing .fes files.
    package_decl?               // Optional package declaration
    (decl                       // Allow zero or more declarations..
    | fn_body_decl)*            // ..or function-body declarations.
    EOF                         // End of file.
    ;

/*
 * This is used when parsing a normal .fe source file for compilation.
 * It only allows regular declarations in it's root-scope.
 */
file:                           // ---------- Root-rule for parsing .fe files.
    package_decl?               // Optional package declaration.
    decl*                       // Zero or more declarations.
    EOF                         // End of file.
    ;

// -------------------------------------------------------------------------------- Declarations

decl:                           // ---------- Declaration
    import_decl                 // Imports.
    | udt_decl                  // User defined types (class, struct etc.).
    | fn_decl                   // Functions.
    | field_decl                // Fields.
    | type_decl                 // Type definitions.
    | pc_decl                   // Pre-compiler directives.
    | label_decl                // Labels.
    ;

type_decl:                      // ---------- Type definition declaration.
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    KW_TYPE                     // 'type'
    ident                       // The name of the type definition.
    ASSIGN                      // '='
    type                        // The type being aliased.
    semi?                       // Optional ';' or \n(\r).
    ;

label_decl:                     // ---------- Label declarations.
    ident                       // The name of the label.
    COLON                       // ':'
    semi?                       // Optional ';' or \n(\r).
    ;

import_decl:                    // ---------- Import declaration.
    KW_IMPORT                   // 'import'
    package_ident               // The name(-group) of the package.
    semi?                       // Optional ';' or \n(\r).
    ;

package_decl:                   // ---------- Package declaration.
    KW_PACKAGE                  // 'package'
    package_ident               // The name(-group) of the package.
    semi?                       // Optional ';' or \n(\r).
    ;

package_ident:                  // ---------- Package identifier (name-group).
    ident                       // At least one identifier..
    (DOT ident)*                // ..and zero or more following groups separated by a '.'.
    ;

// -------------------------------------------------------------------------------- User Defined Types

udt_decl:                       // ---------- User defined type declaration.
    attrib_decl                 // Attributes.
    | iface_decl                // Interfaces.
    | struct_decl               // Structures.
    | class_decl                // Classes.
    | e_class_decl              // Enum classes.
    | trait_decl                // Traits.
    | enum_decl                 // Enums.
    ;

// -------------------------------------------------------------------------------- Attributes

attrib_decl:                    // ---------- Attribute declaration.
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    KW_CONST?                   // Optional 'const' for compile-time-only attributes.
    KW_ATTRIB                   // 'attrib'
    ident                       // The name of the attribute.
    L_CRL_PAREN                 // '{'
    attrib_body_decl*           // Zero or more attribute body declarations.
    R_CRL_PAREN                 // '}'
    ;

attrib_body_decl:               // ---------- Attribute body declaration.
    field_decl                  // Fields.
    | pc_decl                   // Pre-compiler directives.
    ;

// -------------------------------------------------------------------------------- Interfaces

iface_decl:                     // ---------- Interface declaration.
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    KW_INTERFACE                // 'interface'
    ident                       // The name of the interface.
    generic_params_decl?        // Optional generic parameters.
    generic_constraints_decl?   // Optional generic constraints.
    L_CRL_PAREN                 // '{'
    iface_body_decl*            // Zero or more interface body declarations.
    R_CRL_PAREN                 // '}'
    ;

iface_body_decl:                // ---------- Interface body declaration.
    iface_proto_decl            // Interface function prototypes.
    | pc_decl                   // Pre-compiler directives.
    ;

iface_proto_decl:               // ---------- Interface function prototype declaration.
    fn_proto_decl               // Function prototype.
    semi?                       // Optional ';' or \n(\r).
    ;

// -------------------------------------------------------------------------------- Structures

struct_decl:                    // ---------- Structure declaration.
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    KW_STRUCT                   // 'struct'
    ident                       // The name of the structure.
    generic_params_decl?        // Optional generic parameters.
    generic_constraints_decl?   // Optional generic constraints.
    L_CRL_PAREN                 // '{'
    struct_body_decl*           // Zero or more structure body declarations.
    R_CRL_PAREN                 // '}'
    ;

struct_body_decl:               // ---------- Structure body declaration.
    field_decl                  // Fields.
    | fn_decl                   // Functions.
    | pc_decl                   // Pre-compiler directives.
    ;

// -------------------------------------------------------------------------------- Enum classes

e_class_decl:                   // ---------- Enum class declaration.
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    KW_STATIC?                  // Optional 'static', since this counts as a class.
    KW_ENUM                     // 'enum'
    KW_CLASS                    // 'class'
    ident                       // The name of the enum class.
    L_CRL_PAREN                 // '{'
    enum_body                   // Zero or more enum constants.
    (SEMICOLON                  // Optional ';' to indicate the start of the normal class body..
    e_class_body_decl*)?        // ..as well as zero or more enum class body declarations.
    R_CRL_PAREN                 // '}'
    ;

e_class_body_decl:              // ---------- Enum class body declaration.
    field_decl                  // Fields.
    | fn_decl                   // Functions.
    ;

// -------------------------------------------------------------------------------- Classes

class_decl:                     // ---------- Class declaration.
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    (KW_ABSTRACT                // Optional 'abstract'..
    |KW_STATIC)?                // ..or 'static' modifier.
    KW_CLASS                    // 'class'
    ident                       // The name of the class.
    generic_params_decl?        // Optional generic parameters.
    generic_constraints_decl?   // Optional generic constraints.
    L_CRL_PAREN                 // '{'
    class_body_decl*            // Zero or more class body declarations.
    R_CRL_PAREN                 // '}'
    ;

class_body_decl:                // ---------- Class body declaration.
    decl                        // Declarations.
    ;

// -------------------------------------------------------------------------------- Traits

trait_decl:                     // ---------- Trait declaration.
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    KW_TRAIT                    // 'trait'
    ident                       // The name of the trait.
    generic_params_decl?        // Optional generic parameters.
    generic_constraints_decl?   // Optional generic constrants.
    L_CRL_PAREN                 // '{'
    trait_body_decl*            // Zero or more trait body declarations.
    R_CRL_PAREN                 // '}'
    ;

trait_body_decl:                // ---------- Trait body declaration.
    fn_decl                     // Functions.
    | pc_decl                   // Pre-compiler directive.
    ;

// -------------------------------------------------------------------------------- Enums

enum_decl:                      // ---------- Enum declaration.
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    KW_ENUM                     // 'enum'
    ident                       // The name of the enum.
    L_CRL_PAREN                 // '{'
    enum_body                   // Enum body declaration.
    R_CRL_PAREN                 // '}'
    ;

enum_body:                      // ---------- Enum body.
    (enum_field_decl            // Zero or more enum field declarations..
    COMMA?)*                    // ..separated by commas.
    ;

enum_field_decl:                // ---------- Enum field declaration.
    ident                       // The name of the constant.
    | pc_decl                   // Pre-compiler directive.
    ;

// -------------------------------------------------------------------------------- Pre-compiler

pc_decl:                        // ---------- Pre-compiler declaration.
    pc_define_decl              // Defines.
    | pc_undef_decl             // Undefines.
    | pc_macro_decl             // Macros.
    | pc_assert_decl            // Assertions.
    | pc_if_expr                // Ifs.
    | pc_for_decl               // For-loops.
    | pc_while_decl             // While-loops.
    | pc_conj_decl              // Conjunctive token addition.
    | pc_disj_decl              // Disjunctive token addition.
    | pc_literal                // Pre-compiler specific literals.
    | pc_macro_call             // Macro calls.
    ;

pc_conj_decl:                   // ---------- Conjunctive token addition.
    pc_lhs_conj_decl            // LHS conjunction.
    | pc_rhs_conj_decl          // RHS conjunction.
    ;

pc_lhs_conj_decl:               // ---------- LHS token conjunction.
    PC_KW_CONJ                  // '!conj'
    L_PAREN                     // '('
    expr                        // Some expression.
    COMMA                       // ','
    pc_junction_op              // Some type of junction-capable operator.
    R_PAREN                     // ')'
    ;

pc_rhs_conj_decl:               // ---------- RHS token conjunction.
    PC_KW_CONJ                  // '!conj'
    L_PAREN                     // '('
    pc_junction_op              // Some type of junction-capable operator.
    COMMA                       // ','
    expr                        // Some expression.
    R_PAREN                     // ')'
    ;

pc_disj_decl:                   // ---------- Disjunctive token addition.
    pc_lhs_disj_decl            // LHS disjunction.
    | pc_rhs_disj_decl          // RHS disjunction.
    ;

pc_lhs_disj_decl:               // ---------- LHS disjunction.
    PC_KW_DISJ                  // '!disj'
    L_PAREN                     // '('
    expr                        // Some expression.
    COMMA                       // ','
    pc_junction_op              // Some type of junction-capable operator.
    R_PAREN                     // ')'
    ;

pc_rhs_disj_decl:               // ---------- RHS disjunction.
    PC_KW_DISJ                  // '!disj'
    L_PAREN                     // '('
    pc_junction_op              // Some type of junction-capable operator.
    COMMA                       // ','
    expr                        // Some expression.
    R_PAREN                     // ')'
    ;

pc_junction_op:                 // ---------- Pre-compiler junction capable operator(s)
    unary_op                    // Unary operators.
    | binary_op                 // Binary operators.
    | COMMA                     // ','
    | (QMK?                     // Optional '?'..
    DOT)                        // ..lead by a required '.'.
    ;

pc_literal:                     // ---------- Pre-compiler literals
    pc_nameof_literal           // Name literals.
    ;

pc_nameof_literal:              // ---------- Pre-compiler type-name-derivative
    PC_KW_NAMEOF                // '!nameof'
    L_PAREN                     // '('
    type                        // Some type.
    R_PAREN                     // ')'
    ;

pc_define_decl:                 // ---------- Pre-compiler defines
    PC_KW_DEFINE                // '!define'
    pc_ident                    // The name of the definition.
    (ASSIGN                     // Optional '='..
    expr)?                      // ..followed by any type of expression.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

pc_undef_decl:                  // ---------- Pre-compiler undefines
    PC_KW_UNDEF                 // '!undef'
    pc_ident                    // The name of the definition to be undefined.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

pc_assert_decl:                 // ---------- Pre-compiler assertions
    pc_simple_assert_decl       // Simple assertions.
    | pc_custom_assert_decl     // Custom assertions (custom message).
    ;

pc_simple_assert_decl:          // ---------- Simple pre-compiler assertion
    PC_KW_ASSERT                // '!assert'
    (expr                       // Any type of expression..
    | expl_pattern_expr)        // ..or explicit pattern matching expression.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

pc_custom_assert_decl:          // ---------- Custom pre-compiler assertions
    PC_KW_ASSERT                // '!assert'
    L_PAREN                     // '('
    ((expr                      // Some type of expression..
    | expl_pattern_expr)        // ..or an explicit pattern matching expression..
    COMMA)?                     // ..followed by ','.
    string_literal              // Any type of string literal.
    R_PAREN                     // ')'
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

pc_if_expr:                     // ---------- Pre-compiler if expression
    pc_if_bodied_expr           // Bodied ifs.
    | pc_if_inline_expr         // Inline ifs.
    ;

pc_if_bodied_expr:              // ---------- Bodied pre-compiler if
    PC_KW_IF                    // '!if'
    if_conditional_expr_type    // Some type of conditional expression.
    L_CRL_PAREN                 // '{'
    fn_body_decl*               // Zero or more function-body declarations.
    R_CRL_PAREN                 // '}'
    pc_else_if_branch*          // Zero or more else-if branches.
    pc_else_branch?             // Zero or one else branch.
    ;

pc_if_inline_expr:              // ---------- Inline pre-compiler if
    PC_KW_IF                    // '!if'
    L_PAREN                     // '('
    if_conditional_expr_type    // Some type of conditional expression.
    R_PAREN                     // ')'
    fn_body_decl                // Zero or more function-body declarations.
    semi?                       // Optional ';' or \n(\r) at the end.
    pc_else_if_branch*          // Zero or more else-if branches.
    pc_else_branch?             // Zero or one else branch.
    ;

pc_else_if_branch:              // ---------- Pre-compiler else-if
    pc_else_if_bodied_branch    // Bodied else-ifs.
    | pc_else_if_inline_branch  // Inline else-ifs.
    ;

pc_else_if_bodied_branch:       // ---------- Bodied pre-compiler else-if
    PC_KW_ELSE                  // '!else'
    PC_KW_IF                    // '!if'
    if_conditional_expr_type    // Some type of conditional expression.
    L_CRL_PAREN                 // '{'
    fn_body_decl*               // Zero or more function-body declarations.
    R_CRL_PAREN                 // '}'
    ;

pc_else_if_inline_branch:       // ---------- Inline pre-compiler else-if
    PC_KW_ELSE                  // '!else'
    PC_KW_IF                    // '!if'
    L_PAREN                     // '('
    if_conditional_expr_type    // Some type of conditional expression.
    R_PAREN                     // ')'
    fn_body_decl                // Exactly one function-body declaration.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

pc_else_branch:                 // ---------- Pre-compiler else
    pc_else_bodied_branch       // Bodied elses.
    | pc_else_inline_branch     // Inline elses.
    ;

pc_else_bodied_branch:          // ---------- Bodied pre-compiler else
    PC_KW_ELSE                  // '!else'
    L_CRL_PAREN                 // '{'
    fn_body_decl*               // Zero or more function body declarations.
    R_CRL_PAREN                 // '}'
    ;

pc_else_inline_branch:          // ---------- Inline pre-compiler else
    PC_KW_ELSE                  // '!else'
    fn_body_decl                // Exactly one function-body declaration.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

pc_while_decl:                  // ---------- Pre-compiler while
    pc_while_bodied_decl        // Bodied while.
    | pc_while_inline_decl      // Inline while.
    | pc_do_while_decl          // do-while.
    ;

pc_while_bodied_decl:           // ---------- Bodied pre-compiler while
    PC_KW_WHILE                 // '!while'
    expr                        // Some type of expression.
    L_CRL_PAREN                 // '{'
    (decl                       // Some type of declaration..
    | fn_body_decl              // ..function-body declaration..
    | pc_cf_statement)*         // ..or pre-compiler control flow statement.
    R_CRL_PAREN                 // '}'
    ;

pc_while_inline_decl:           // ---------- Inline pre-compiler while
    PC_KW_WHILE                 // '!while'
    L_PAREN                     // '('
    expr                        // Some type of expression.
    R_PAREN                     // ')'
    fn_body_decl                // Exactly one function-body declaration.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

pc_do_while_decl:               // ---------- Pre-compiler do-while
    pc_do_decl                  // do-declaration.
    PC_KW_WHILE                 // '!while'
    L_PAREN                     // '('
    expr                        // Some type of expression.
    R_PAREN                     // ')'
    ;

pc_do_decl:                     // ---------- Pre-compiler do
    pc_do_bodied_decl           // Bodied do.
    | pc_do_inline_decl         // Inline do.
    ;

pc_do_bodied_decl:              // ---------- Bodied pre-compiler do
    PC_KW_DO                    // '!do'
    L_CRL_PAREN                 // '{'
    fn_body_decl*               // Zero or more function-body declarations.
    R_CRL_PAREN                 // '}'
    ;

pc_do_inline_decl:              // ---------- Inline pre-compiler do
    PC_KW_DO                    // '!do'
    fn_body_decl                // Exactly one function-body declaration.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

pc_for_decl:                    // ---------- Pre-compiler for
    pc_bodied_for_decl          // Bodied for.
    | pc_inline_for_decl        // Inline for.
    ;

pc_bodied_for_decl:             // ---------- Bodied pre-compiler for
    PC_KW_FOR                   // '!for'
    for_head                    // Some type of for-head.
    L_CRL_PAREN                 // '{'
    (decl                       // Zero or more declarations..
    | fn_body_decl              // ..function-body declarations..
    | pc_cf_statement)*         // ..or pre-compiler control flow statements.
    R_CRL_PAREN                 // '}'
    ;

pc_inline_for_decl:             // ---------- Inline pre-compiler for
    PC_KW_FOR                   // '!for'
    L_PAREN                     // '('
    for_head                    // Some type of for-head.
    R_PAREN                     // ')'
    (decl                       // Exactly one declarations..
    | fn_body_decl)             // ..or function-body declaration.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

pc_macro_call:                  // ---------- Pre-compiler macro call
    ident                       // The name of the macro.
    OP_NOT                      // '!'
    L_PAREN                     // '('
    (fn_call_param              // Zero or more function-call parameters..
    COMMA?)*                    // ..separated by commas.
    R_PAREN                     // ')'
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

pc_macro_decl:                  // ---------- Pre-compiler macro
    pc_simple_macro_decl        // Simple macros.
    | pc_matching_macro_decl    // Matching macros.
    ;

pc_matching_macro_decl:         // ---------- Matching macro
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    PC_KW_MACRO                 // '!macro'
    ident                       // The name of the macro.
    L_CRL_PAREN                 // '{'
    pc_macro_branch*            // Zero or more macro branches.
    pc_default_macro_branch?    // Zero or one default macro branch.
    R_CRL_PAREN                 // '}'
    ;

pc_macro_branch:                // ---------- Macro branch
    L_PAREN                     // '('
    ((pc_macro_params_decl      // Zero or more macro param declarations..
    | pc_macro_match_group)     // ..or macro matching groups..
    COMMA?)*                    // ..separated by ','.
    R_PAREN                     // '}'
    ARROW                       // '->'
    pc_macro_scope              // Some type of macro-match scope.
    ;

pc_default_macro_branch:        // ---------- Default macro branch
    L_PAREN                     // '('
    R_PAREN                     // ')'
    ARROW                       // '->'
    pc_macro_scope              // Some type of macro-match-scope.
    ;

pc_macro_scope:                 // ---------- Macro scope
    pc_bodied_macro_scope       // Bodied pre-compiler macro scope.
    | pc_inline_macro_scope     // Inline pre-compiler macro scope.
    ;

pc_bodied_macro_scope:          // ---------- Bodied macro scope
    L_CRL_PAREN                 // '('
    pc_macro_body_decl*         // Zero or more pre-compiler macro body-declarations.
    R_CRL_PAREN                 // ')'
    ;

pc_inline_macro_scope:          // ---------- Inline macro scope
    pc_macro_body_decl          // Exactly one pre-compiler macro body-declaration.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

pc_macro_match_group:           // ---------- Macro match group
    DOLLAR                      // '$'
    L_PAREN                     // '('
    (pc_macro_params_decl       // At least one macro parameter list..
    | pc_macro_match_group)+    // ..or another nested match group.
    R_PAREN                     // ')'
    pc_macro_match_op?          // Some type of matching operator (+, * or ?).
    ;

pc_macro_match_op:              // ---------- Token match operator
    (QMK                        // '?'
    | OP_TIMES                  // '*'
    | OP_PLUS)                  // '+'
    | (HASH                     // '#'
    L_CRL_PAREN                 // '{'
    (int_literal                // Some type of integral literal..
    | range_expr)               // ..or a range expression.
    R_CRL_PAREN)                // '}'
    ;

pc_simple_macro_decl:           // ---------- Simple pre-compiler macro declaration
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    PC_KW_MACRO                 // '!macro'
    ident                       // The name of the macro.
    L_PAREN                     // '('
    pc_macro_params_decl?       // Optional macro parameter list.
    R_PAREN                     // ')'
    L_CRL_PAREN                 // '{'
    pc_macro_body_decl*         // Zero or more pre-compiler macro body-declarations.
    R_CRL_PAREN                 // '}'
    ;

pc_macro_params_decl:
    (pc_macro_param_decl        // One or more macro parameter declarations..
    COMMA?)+                    // ..separated by a comma.
    ;

pc_macro_body_decl:             // ---------- Macro body delclaration
    decl                        // Some type of declaration..
    | fn_body_decl              // ..or some type of function body-declaration.
    ;

pc_macro_param_decl:            // ---------- Macro parameter declaration
    simple_pc_ident             // The name of the macro.
    COLON                       // ':'
    pc_macro_param_type         // Some macro parameter type.
    (ASSIGN                     // Optional '='..
    expr)?                      // ..and some type of expression at the end.
    ;

pc_macro_param_type:            // ---------- Macro parameter type
    type                        // A regular type..
    | pc_macro_token_type       // ..or a pre-compiler token-type.
    ;

pc_macro_token_type:            // ---------- Macro token type
    KW_TYPE                     // 'type'
    | KW_EXPR                   // 'expr'
    | KW_IDENT                  // 'ident'
    | KW_LITERAL                // 'literal'
    ;

pc_cf_statement:                // ---------- Pre-compiler control flow statements
    pc_cf_continue              // Continue.
    | pc_cf_break               // Break.
    ;

pc_cf_continue:                 // ---------- Pre-compiler continue
    PC_KW_CONTINUE              // '!continue'
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

pc_cf_break:                    // ---------- Pre-compiler break
    PC_KW_BREAK                 // '!break'
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

// -------------------------------------------------------------------------------- Functions

fn_decl:                        // ---------- Function declarations
    fn_bodied_decl              // Bodied functions.
    | fn_inline_decl            // Inline functions.
    ;

fn_bodied_decl:                 // ---------- Bodied function declarations.
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    fn_proto_decl               // Function prototype.
    L_CRL_PAREN                 // '{'
    fn_body_decl*               // Zero or more function body-declarations.
    R_CRL_PAREN                 // '}'
    ;

fn_inline_decl:                 // ---------- Inline function declarations
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    fn_proto_decl               // Function prototype.
    ARROW                       // '->'
    fn_body_decl                // Exactly one function body-declaration.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

fn_proto_decl:                  // ---------- Function prototypes
    fn_named_proto_decl         // Named prototype.
    | fn_op_proto_decl          // Operator prototype.
    ;

fn_named_proto_decl:            // ---------- Named function prototypes
    fn_mod*                     // Zero or more function modifiers.
    KW_FN                       // 'fn'
    ident                       // The name of the function.
    generic_params_decl?        // Optional generic parameters.
    params_decl                 // Parameter list.
    fn_return_type?             // Optional return type.
    generic_constraints_decl?   // Optional generic constraints.
    ;

fn_op_proto_decl:               // ---------- Operator function prototypes
    fn_mod*                     // Zero or more function modifiers.
    KW_OP                       // 'op'
    KW_FN                       // 'fn'
    (unary_op                   // Either a unary..
    | binary_op                 // ..a binary operator..
    | (L_SQR_PAREN              // ..or '['..
    R_SQR_PAREN))               // ..and ']'.
    generic_params_decl?        // Optional generic parameters.
    params_decl                 // Parameter list.
    fn_return_type?             // Optional return type.
    generic_constraints_decl?   // Optional generic constraints.
    ;

fn_return_type:                 // ---------- Function return type
    COLON                       // ':'
    type                        // Some type.
    ;

fn_body_decl:                   // ---------- Function body declarations
    fn_decl                     // Function declarations.
    | return_statement          // Function return statement.
    | for_decl                  // For-loops.
    | while_decl                // While-loops.
    | goto_statement            // Goto statemenent.
    | (var_decl                 // Variable declarations.
    semi?)
    | named_scope_decl          // Named scope declarations.
    | pc_decl                   // Pre-compiler declarations.
    | (expr                     // Any type of expression..
    semi?)                      // ..followed by ';' or \n(\r) at the end.
    | label_decl                // Label declarations.
    ;

named_scope_decl:               // ---------- Named scope declarations
    label_decl                  // Labels.
    L_CRL_PAREN                 // '{'
    fn_body_decl*               // Zero or more function body-declarations.
    R_CRL_PAREN                 // '}'
    ;

goto_statement:                 // ---------- Goto statements
    KW_GOTO                     // 'goto'
    ident                       // The name of the label being jumped to.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

return_statement:               // ---------- Return statements
    KW_RETURN                   // 'return'
    expr?                       // Some type of expression.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

fn_mod:                         // ---------- Function modifiers
    KW_STATIC                   // 'static'
    | KW_CONST                  // 'const'
    | KW_INL                    // 'inl'
    ;

scoped_fn_call:
    ident                       // The name of the function to call.
    generic_usage?              // Optional generic usage parameters.
    (L_PAREN                    // '('
    (fn_call_param              // Zero or more function call parameters..
    COMMA?)*                    // ..separated by commas.
    R_PAREN)?                   // ')'
    lambda_expr
    ;

fn_call:                        // ---------- Function calls
    ident                       // The name of the function to call.
    generic_usage?              // Optional generic usage parameters.
    L_PAREN                     // '('
    (fn_call_param              // Zero or more function call parameters..
    COMMA?)*                    // ..separated by commas.
    R_PAREN                     // ')'
    ;

fn_call_param:                  // ---------- Function call parameter
    literal                     // Some type of literal.
    | expr                      // Some type of expression.
    | var_ref                   // Some type of variable reference.
    ;

params_decl:                    // ---------- Function call parameter list
    L_PAREN                     // '('
    (param_decl                 // Zero or more parameter declarations..
    COMMA?)*                    // ..separated by commas.
    R_PAREN                     // ')'
    ;

param_decl:                     // ---------- Parameter declarations
    param_mod?                  // Optional parameter modifier.
    ident                       // The name of the parameter.
    COLON                       // ':'
    type                        // Some type.
    TRIPLE_DOT?                 // Optional '...' for indicating a parameter pack.
    param_default_value?        // Optional default value.
    ;

param_default_value:            // ---------- Parameter default value
    ASSIGN                      // '='
    expr                        // Some expression.
    ;

param_mod:                      // ---------- Parameter modifiers
    KW_MUT                      // 'mut'
    | KW_CONST                  // 'const'
    | KW_IN                     // 'in'
    | KW_OUT                    // 'out'
    ;

// -------------------------------------------------------------------------------- Variables

var_decl:                       // ---------- Variables
    impl_var_decl               // Implicit variable declaration.
    | expl_var_decl             // Explicit varaible declaration.
    ;

expl_var_decl:                  // ---------- Explicit variable declarations
    KW_LET                      // 'let'
    var_mod?                    // Visibility modifier (pub, prot, priv etc.).
    ident                       // The name of the variable.
    COLON                       // ':'
    type                        // Some type.
    (ASSIGN                     // Optional '='..
    expr)?                      // ..and any type of expression.
    ;

impl_var_decl:                  // ---------- Implicit variable declarations
    KW_LET                      // 'let'
    var_mod?                    // Optional veriable modifier.
    ident                       // The name of the variable.
    ASSIGN                      // '='
    expr                        // Some type of expression.
    ;

var_mod:                        // ---------- Variable modifiers
    KW_STATIC                   // 'static'
    | KW_CONST                  // 'const'
    | KW_MUT                    // 'mut'
    ;

var_ref:                        // ---------- Simple variable references
    (OP_TIMES                   // Optional '*' to indicate de-reference..
    | OP_AMP                    // ..a '&' to indicate taking the address of something..
    | OP_CONJ_AND)?             // ..a '&&' to indicate passing a value-type by reference.
    (KW_THIS                    // 'this'..
    | fn_call                   // ..function calls..
    | mem_expr                  // ..memory expressions..
    | grouped_expr              // ..grouped expressions..
    | ident)                    // ..or identifiers.
    indexed_ref?                // Optional indexed accessor.
    OP_NASRT?                   // Optional '!!'.
    (var_ref_op                 // Optional reference operator..
    var_ref                     // ..some type of another variable reference (recursive)..
    indexed_ref?                // ..an optional indexed accessor..
    OP_NASRT?)*                 // ..and an optional '!!' at the end.
    ;

indexed_ref:                    // ---------- Indexed variable references
    L_SQR_PAREN                 // '['
    expr                        // Some type of expression.
    (COMMA                      // Optional ','..
    expr)*                      // ..and an optional amount of expressions.
    R_SQR_PAREN                 // ']'
    ;

var_ref_op:                     // ---------- Variable reference operators
    OP_SAFE_CALL                // '?.'
    | OP_SAFE_DEREF             // '?->'
    | DOT                       // '.'
    | ARROW                     // '->'
    ;

// -------------------------------------------------------------------------------- Fields

field_decl:                     // ---------- Field declarations
    init_field_decl             // Init field declaration.
    | late_field_decl           // Late field declaration.
    ;

init_field_decl:                // ---------- Initialized field declarations
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    field_mod*                  // Zero or more fields modifiers.
    ident                       // The name of the field.
    COLON                       // ':'
    type                        // The type of the field.
    ASSIGN                      // '='
    expr                        // Some type of expression.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

late_field_decl:                // ---------- Late field declarations
    visibility_mod?             // Visibility modifier (pub, prot, priv etc.).
    field_mod*                  // Zero or more field modifiers.
    KW_LATE                     // 'late'
    ident                       // The name of the field.
    COLON                       // ':'
    type                        // Some type.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

field_mod:                      // ---------- Field modifiers
    KW_STATIC                   // 'static'
    | KW_CONST                  // 'const'
    | KW_MUT                    // 'mut'
    ;

// -------------------------------------------------------------------------------- While Loops

while_decl:                     // ---------- While declarations
    while_bodied_decl           // Bodied while declarations.
    | while_inline_decl         // Inline while declarations.
    | do_while_decl             // Do-while declarations.
    ;

while_bodied_decl:              // ---------- Bodied while declarations
    KW_WHILE                    // 'while'
    expr                        // Some type of expression.
    L_CRL_PAREN                 // '{'
    fn_body_decl*               // Zero or more function body-declarations.
    R_CRL_PAREN                 // '}'
    ;

while_inline_decl:              // ---------- Inline while declarations
    KW_WHILE                    // 'while'
    L_PAREN                     // '('
    expr                        // Some type of expression.
    R_PAREN                     // ')'
    fn_body_decl                // Exactly one function body-declaration.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

do_while_decl:                  // ---------- Do-while declarations
    do_decl                     // Some type do-declaration.
    KW_WHILE                    // 'while'
    L_PAREN                     // '('
    expr                        // Some type of expression.
    R_PAREN                     // ')'
    ;

do_decl:                        // ---------- Do declarations
    do_bodied_decl              // Bodied dos.
    | do_inline_decl            // Inline dos.
    ;

do_bodied_decl:                 // ---------- Bodied do declarations
    KW_DO                       // 'do'
    L_CRL_PAREN                 // '{'
    fn_body_decl*               // Zero or more function body-declarations.
    R_CRL_PAREN                 // '}'
    ;

do_inline_decl:                 // ---------- Inline do declarations
    KW_DO                       // 'do'
    fn_body_decl                // Exactly one function body-declaration.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

// -------------------------------------------------------------------------------- For loops

for_decl:                       // ---------- For declarations
    bodied_for_decl             // Bodied fors
    | inline_for_decl           // Inline fors
    ;

bodied_for_decl:                // ---------- Bodied for declarations
    KW_FOR                      // 'for'
    for_head                    // Some type of for-head.
    L_CRL_PAREN                 // '{'
    fn_body_decl*               // Zero or more function body-declarations.
    R_CRL_PAREN                 // '}'
    ;

inline_for_decl:                // ---------- Inline for declarations
    KW_FOR                      // 'for'
    L_PAREN                     // '('
    for_head                    // Some type of for-head.
    R_PAREN                     // ')'
    fn_body_decl                // Exactly one function body-declaration.
    semi?                       // Optional ';' or \n(\r) at the end.
    ;

for_head:                       // ---------- For-heads
    ranged_for_head             // Ranged for-heads.
    | simple_for_head           // Simple for-heads.
    ;

ranged_for_head:                // ---------- Ranged for-heads
    ident                       // The name of the iteration variable.
    KW_IN                       // 'in'
    (range_expr                 // Some type of range-expression..
    | var_ref)                  // ..or some type of variable.
    ;

simple_for_head:                // ---------- Simple for-heads
    ident                       // The name of the iteration variable.
    (COLON                      // Optional ':'..
    type)?                      // ..and type.
    ASSIGN                      // '='
    expr                        // Some type of expression.
    SEMICOLON                   // ';'
    expr                        // Some type of expression.
    SEMICOLON                   // ';'
    expr                        // Some type of expression.
    ;

// -------------------------------------------------------------------------------- Generics

generic_constraints_decl:       // ---------- Generic constraints
    KW_WHERE                    // 'where'
    ((ident                     // One or more names of a generic parameter..
    COLON                       // ..a ':' as a separator..
    generic_constraint)         // ..and a generic constraint..
    COMMA?)+                    // ..separated by a comma ','.
    ;

generic_constraint_list:        // ---------- Generic constrains
    (generic_constraint         // Some type of generic constraint..
    COMMA?)+                    // ..separated by a comma ','.
    ;

generic_constraint:             // ---------- Generic constraint
    type                        // Some type..
    | generic_constraint_group  // ..or a generic constraint group.
    ;

generic_constraint_group:       // ---------- Generic constraint group
    L_PAREN                     // '('
    ((generic_constraint_group  // A nested generic constraint group (recursive)..
    | type)                     // ..or some type..
    (OP_AMP                     // ..separated by '&'..
    | OP_OR)?)+                 // ..or '|'.
    R_PAREN                     // ')'
    ;

generic_params_decl:            // ---------- Generic parameter list
    L_ANGLE                     // '<'
    (generic_param_decl         // One or more generic parameters..
    COMMA?)+                    // ..separated by a comma ','.
    R_ANGLE                     // '>'
    ;

generic_param_decl:             // ---------- Generic parameters
    simple_generic_param_decl   // Simple generic parameters..
    | const_generic_param_decl  // ..or constant generic parameters.
    ;

simple_generic_param_decl:      // ---------- Simple generic parameters
    ident                       // The name of the porameter.
    (COLON                      // Optional ':'..
    generic_constraint_list)?   // ..and a generic constraint list.
    ;

const_generic_param_decl:       // ---------- Constant generic parameters
    KW_CONST                    // 'const'
    ident                       // The name of the parameter.
    COLON                       // ':'
    type                        // The type of the parameter.
    (ASSIGN                     // Optional '='..
    expr)?                      // ..and some type of expression at the end.
    ;

generic_usage:                  // ---------- Generic usages
    L_ANGLE                     // '<'
    ((type                      // One or more types..
    | expr)                     // ..or expressions..
    COMMA?)+                    // ..separated by a comma ','.
    R_ANGLE                     // '>'
    ;

// -------------------------------------------------------------------------------- Expressions

array_expr:
    L_SQR_PAREN
    ((expr
    | pc_decl)
    COMMA?)*
    R_SQR_PAREN
    ;

obj_init_expr:
    seq_obj_init_expr
    | named_obj_init_expr
    ;

named_obj_init_expr:
    type
    L_CRL_PAREN
    (ident
    ASSIGN
    expr
    COMMA?)*
    R_CRL_PAREN
    ;

seq_obj_init_expr:
    type
    L_CRL_PAREN
    ((expr
    | pc_decl)
    COMMA?)*
    R_CRL_PAREN
    ;

range_expr:
    incl_range_expr
    | excl_range_expr
    ;

incl_range_expr:
    expr_type
    DOUBLE_DOT
    expr_type
    ;

excl_range_expr:
    expr_type
    DOUBLE_DOT
    ASSIGN
    expr_type
    ;

expr:
    cast_expr
    | if_null_expr
    | grouped_expr
    | raw_expr
    ;

grouped_expr:
    L_PAREN
    expr
    R_PAREN
    ;

raw_expr:
    mem_expr
    | if_expr
    | when_expr
    | constructor_call_expr
    | destructor_call_expr
    | expl_type_pattern_expr
    | array_expr
    | unary_expr
    | range_expr
    | assign_expr
    | lambda_expr
    | tuple_expr
    | binary_expr
    | simple_expr
    ;

tuple_expr:
    L_PAREN
    expr
    COMMA
    (expr
    COMMA?)+
    R_PAREN
    ;

lambda_expr:
    L_CRL_PAREN
    (((ident
    (COLON
    type))
    COMMA?)*
    ARROW)?
    fn_body_decl*
    R_CRL_PAREN
    ;

cast_expr:
    unsafe_cast_expr
    | safe_cast_expr
    ;

unsafe_cast_expr:
    raw_expr
    KW_AS
    type
    ;

safe_cast_expr:
    raw_expr
    KW_AS_SAFE
    type
    ;

mem_expr:
    mem_stackalloc_expr
    | mem_new_expr
    | mem_delete_expr
    ;

mem_new_expr:
    mem_simple_new_expr
    | mem_array_new_expr
    ;

mem_simple_new_expr:
    KW_NEW
    constructor_call_expr
    semi?
    ;

mem_array_new_expr:
    KW_NEW
    type
    array_alloc_bounds
    semi?
    ;

mem_delete_expr:
    mem_simple_delete_expr
    | mem_array_delete_expr
    ;

mem_simple_delete_expr:
    KW_DELETE
    expr
    semi?
    ;

mem_array_delete_expr:
    KW_DELETE
    L_SQR_PAREN
    R_SQR_PAREN
    expr
    semi?
    ;

mem_stackalloc_expr:
    KW_STACKALLOC
    ((type
    array_alloc_bounds)
    | obj_init_expr)
    semi?
    ;

array_alloc_bounds:
    L_SQR_PAREN
    expr
    (COMMA
    expr)*
    R_SQR_PAREN
    ;

constructor_call_expr:
    var_ref
    var_ref_op
    type
    L_PAREN
    (expr
    COMMA?)*
    R_PAREN
    ;

destructor_call_expr:
    var_ref
    var_ref_op
    OP_INV
    L_PAREN
    R_PAREN
    ;

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
    ident
    impl_type_pattern_expr // Allow inline declaration
    ;

impl_type_pattern_expr:
    KW_IS
    generic_constraint ident?
    ;

expl_contains_pattern_expr:
    ident
    impl_contains_pattern_expr
    ;

impl_contains_pattern_expr:
    KW_IN
    (ident
    | range_expr)
    ;

when_expr:
    KW_WHEN
    when_head?
    L_CRL_PAREN
    when_branch*
    default_when_branch?
    R_CRL_PAREN
    ;

when_head:
    expr
    | var_decl
    ;

when_branch:
    when_conditional_expr
    ARROW
    when_scope_expr
    ;

default_when_branch:
    KW_ELSE
    ARROW
    when_scope_expr
    ;

when_scope_expr:
    when_bodied_scope_expr
    | when_inline_scope_expr
    ;

when_bodied_scope_expr:
    L_CRL_PAREN
    fn_body_decl
    R_CRL_PAREN
    ;

when_inline_scope_expr:
    fn_body_decl
    semi? // This just delegates for now..
    ;

when_conditional_expr:
    expr
    | pattern_expr
    ;

// If expressions
if_expr:
    if_bodied_expr
    | if_inline_expr
    ;

if_bodied_expr:
    KW_IF
    if_conditional_expr_type
    L_CRL_PAREN
    fn_body_decl*
    R_CRL_PAREN
    else_if_branch*
    else_branch?
    ;

if_inline_expr:
    KW_IF L_PAREN
    if_conditional_expr_type
    R_PAREN
    fn_body_decl semi?
    else_if_branch*
    else_branch?
    ;

// Else if
else_if_branch:
    else_if_bodied_branch
    | else_if_inline_branch
    ;

else_if_bodied_branch:
    KW_ELSE KW_IF
    if_conditional_expr_type
    L_CRL_PAREN
    fn_body_decl*
    R_CRL_PAREN
    ;

else_if_inline_branch:
    KW_ELSE
    KW_IF
    L_PAREN
    if_conditional_expr_type
    R_PAREN
    fn_body_decl semi?
    ;

// Else
else_branch:
    else_bodied_branch
    | else_inline_branch
    ;

else_bodied_branch:
    KW_ELSE
    L_CRL_PAREN
    fn_body_decl*
    R_CRL_PAREN
    ;

else_inline_branch:
    KW_ELSE
    fn_body_decl
    semi?
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
    binary_lhs_expr
    binary_op
    expr
    ;

binary_lhs_expr:
    simple_expr
    | unary_expr
    | grouped_expr
    ;

if_null_expr:
    if_null_lhs_expr
    OP_IFN
    (expr
    | return_statement)
    ;

if_null_lhs_expr:
    simple_expr
    | unary_expr
    | grouped_expr
    | cast_expr
    ;

assign_expr:
    assign_lhs_expr
    ASSIGN
    expr
    ;

assign_lhs_expr:
    var_ref
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
    | TRIPLE_EQ
    | DOUBLE_EQ
    | OP_NEQ
    | OP_SPACESHIP
    | OP_SWAP
    | OP_PLUS_ASSIGN
    | OP_PLUS
    | OP_MINUS_ASSIGN
    | OP_MINUS
    | OP_IFN_ASSIGN
    | OP_IFN
    | OP_CONJ_AND
    | OP_DISJ_OR
    ;

// Increment and decrement
incr_expr:
    pre_incr_expr
    | post_incr_expr
    ;

pre_incr_expr:
    OP_INCREMENT
    var_ref
    ;

post_incr_expr:
    var_ref
    OP_INCREMENT
    ;

decr_expr:
    pre_decr_expr
    | post_decr_expr
    ;

pre_decr_expr:
    OP_DECREMENT
    var_ref
    ;

post_decr_expr:
    var_ref
    OP_DECREMENT
    ;

// Misc
simple_expr:
    pc_macro_call
    | incr_expr
    | decr_expr
    | (var_ref?
    scoped_fn_call)
    | (var_ref?
    fn_call)
    | var_ref
    | obj_init_expr
    | literal
    ;

expr_type:
    literal
    | ident
    ;

// -------------------- Literals

literal:
    KW_NULL
    | string_literal
    | primitive_literal
    | type_literal
    | size_literal
    | alignment_literal
    | name_literal
    | default_literal
    ;

name_literal:
    KW_NAMEOF
    L_PAREN
    type
    R_PAREN
    ;

default_literal:
    KW_DEFAULT
    (L_PAREN
    type
    R_PAREN)?
    ;

type_literal:
    KW_TYPEOF
    L_PAREN
    type
    R_PAREN
    ;

size_literal:
    KW_SIZEOF
    L_PAREN
    type
    R_PAREN
    ;

alignment_literal:
    KW_ALIGNOF
    L_PAREN
    type
    R_PAREN
    ;

string_literal:
    simple_string_literal
    | raw_string_literal
    ;

raw_string_literal:
    (RAW_STRING
    (M_RAW_STRING_TEXT
    | M_RAW_STRING_ESCAPED_END)*
    M_RAW_STRING_END)
    | EMPTY_RAW_STRING
    ;

simple_string_literal:
    (DOUBLE_QUOTE
    M_STRING_TEXT
    DOUBLE_QUOTE)
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
    functional_type
    | tuple_type
    | pointer_type
    | nonnull_type
    | nullable_type
    | ref_type
    ;

ref_type:
    (functional_type
    | tuple_type
    | pointer_type
    | nonnull_type
    | nullable_type)
    OP_AMP
    ;

functional_type:
    L_PAREN
    ((ident
    COLON)?
    type
    COMMA?)*
    R_PAREN
    ARROW
    type
    ;

tuple_type:
    L_PAREN
    type
    COMMA
    (type
    COMMA?)+
    R_PAREN
    ;

pointer_type:
    nonnull_type
    OP_TIMES
    ;

nonnull_type:
    array_type
    | simple_type
    ;

nullable_type:
    (array_type
    | simple_type)
    QMK?
    ;

array_type:
    L_SQR_PAREN
    type
    R_SQR_PAREN
    ;

simple_type:
    primitive_type
    | native_size_type
    | KW_TYPE_STR
    | KW_SELF
    | (ident
    generic_usage?)
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
    (pc_ident
    | IDENTIFIER)+
    ;

pc_ident:
    simple_pc_ident
    | complex_pc_ident
    ;

simple_pc_ident:
    DOLLAR
    IDENTIFIER
    ;

complex_pc_ident:
    DOLLAR
    L_CRL_PAREN
    (pc_ident
    | expr)
    R_CRL_PAREN
    ;

semi:
    (SEMICOLON
    | NL)
    NL*
    | EOF
    ;