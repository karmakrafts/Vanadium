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

// ---------------------------------------- Files

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

// ---------------------------------------- Declarations

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

// ---------------------------------------- User Defined Types

udt_decl:                       // ---------- User defined type declaration.
    attrib_decl                 // Attributes.
    | iface_decl                // Interfaces.
    | struct_decl               // Structures.
    | class_decl                // Classes.
    | e_class_decl              // Enum classes.
    | trait_decl                // Traits.
    | enum_decl                 // Enums.
    ;

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

// ---------------------------------------- Pre-compiler

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

pc_macro_match_op:              // ---------- Match match operator
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
    pc_macro_params_decl        // Zero or more macro parameter declarations.
    R_PAREN                     // ')'
    L_CRL_PAREN                 // '{'
    pc_macro_body_decl*         // Zero or more pre-compiler macro body-declarations.
    R_CRL_PAREN                 // '}'
    ;

pc_macro_body_decl:             // ---------- Macro body delclaration
    decl                        // Some type of declaration..
    | fn_body_decl              // ..or some type of function body-declaration.
    ;

pc_macro_params_decl:           // ---------- Macro parameter list
    (pc_macro_param_decl        // One or more macro parameter declarations..
    COMMA?)+                    // ..separated by a comma.
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
    | binary_op)                // ..or a binary operator.
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
    | fn_call                   // Function calls.
    | fn_return                 // Function return statement.
    | for_decl                  // For-loops.
    | while_decl                // While-loops.
    | goto_statement            // Goto statemenent.
    | variable_decl             // Variable declarations.
    | named_scope_decl          // Named scope declarations.
    | (expr                     // Any type of expression..
    semi?)                      // ..optional ';' or \n(\r) at the end.
    | pc_decl                   // Pre-compiler declarations.
    | label_decl                // Label declarations.
    ;

named_scope_decl:    
    label_decl
    L_CRL_PAREN
    fn_body_decl*
    R_CRL_PAREN
    ;

goto_statement:
    KW_GOTO
    ident
    ;

fn_return:
    KW_RETURN
    expr?
    ;

fn_mod:
    KW_STATIC
    | KW_CONST
    | KW_INL
    ;

fn_call:
    variable_ref*
    ident
    generic_usage?
    L_PAREN
    (fn_call_param
    COMMA?)*
    R_PAREN
    ;

fn_call_param:
    literal
    | expr
    | ident
    ;

// Parameters
params_decl:
    L_PAREN
    (param_decl
    (COMMA?))*
    R_PAREN
    ;

param_decl:
    param_mod?
    ident
    COLON
    type
    param_default_value?
    ;

param_default_value:
    ASSIGN
    expr
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

// References
variable_ref:
    asserted_ref
    | indexed_ref
    | (ident (variable_ref_op variable_ref)*) // LHS recursive parsing
    ;

variable_ref_op:
    (QMK? DOT)
    | ARROW // De-referencing pointers
    ;

indexed_ref:
    ident indexed_ref_group
    ;

indexed_ref_group:
    L_SQR_PAREN
    expr (COMMA indexed_ref_group)? R_SQR_PAREN
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
// While
while_decl:
    while_bodied_decl
    | while_inline_decl
    | do_while_decl
    ;

while_bodied_decl:
    KW_WHILE expr L_CRL_PAREN
        fn_body_decl*
    R_CRL_PAREN
    ;

while_inline_decl:
    KW_WHILE L_PAREN expr R_PAREN fn_body_decl semi?
    ;

do_while_decl:
    do_decl KW_WHILE L_PAREN expr R_PAREN
    ;

do_decl:
    do_bodied_decl
    | do_inline_decl
    ;

do_bodied_decl:
    KW_DO L_CRL_PAREN
        fn_body_decl*
    R_CRL_PAREN
    ;

do_inline_decl:
    KW_DO fn_body_decl semi?
    ;

// For
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

generic_usage:
    L_ANGLE (type COMMA?)+ R_ANGLE
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
    | cast_expr
    | if_null_expr
    ;

grouped_expr:
    L_PAREN expr R_PAREN
    ;

raw_expr:
    simple_expr
    | unary_expr
    | binary_expr
    | mem_expr
    | when_expr
    | if_expr
    | range_expr
    | array_expr
    | constructor_call_expr
    | destructor_call_expr
    | expl_type_pattern_expr
    ;

// Casting
cast_expr:
    unsafe_cast_expr
    | safe_cast_expr
    ;

unsafe_cast_expr:
    raw_expr KW_AS type
    ;

safe_cast_expr:
    raw_expr KW_AS_SAFE type
    ;

// Memory management expressions (new, delete, alloc, free, stackalloc)
mem_expr:
    mem_stackalloc_expr
    | mem_new_expr
    | mem_delete_expr
    ;

// new
mem_new_expr:
    mem_simple_new_expr
    | mem_array_new_expr
    ;

mem_simple_new_expr:
    KW_NEW constructor_call_expr semi?
    ;

mem_array_new_expr:
    KW_NEW type array_alloc_bounds semi?
    ;

// delete
mem_delete_expr:
    mem_simple_delete_expr
    | mem_array_delete_expr
    ;

mem_simple_delete_expr:
    KW_DELETE expr semi?
    ;

mem_array_delete_expr:
    KW_DELETE L_SQR_PAREN R_SQR_PAREN expr semi?
    ;

// stackalloc
mem_stackalloc_expr:
    mem_simple_stackalloc_expr
    | mem_array_stackalloc_expr
    ;

mem_simple_stackalloc_expr:
    KW_STACKALLOC constructor_call_expr semi?
    ;

mem_array_stackalloc_expr:
    KW_STACKALLOC type array_alloc_bounds semi?
    ;

array_alloc_bounds:
    L_SQR_PAREN expr (COMMA array_alloc_bounds)? R_SQR_PAREN
    ;

// Constructors & destructors
constructor_call_expr:
    type L_PAREN (expr COMMA?)* R_PAREN
    ;

destructor_call_expr:
    variable_ref variable_ref_op OP_INV L_PAREN R_PAREN
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
    KW_IN (ident | range_expr)
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
    | fn_return)
    ;

if_null_lhs_expr:
    simple_expr
    | unary_expr
    | grouped_expr
    | cast_expr
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
    variable_ref
    ;

post_incr_expr:
    variable_ref
    OP_INCREMENT
    ;

decr_expr:
    pre_decr_expr
    | post_decr_expr
    ;

pre_decr_expr:
    OP_DECREMENT
    variable_ref
    ;

post_decr_expr:
    variable_ref
    OP_DECREMENT
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
    pointer_type
    | nonnull_type
    | nullable_type
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
    | ident
    generic_usage?
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