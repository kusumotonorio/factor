! Copyright (C) 2007, 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: words words.symbol sequences vocabs kernel
compiler.units ;
IN: bootstrap.syntax

[
    "syntax" create-vocab drop

    {
        "\""
        "("
        ":"
        ";"
        "<PRIVATE"
        "B{"
        "BV{"
        "C:"
        "char:"
        "DEFER:"
        "ERROR:"
        "FORGET:"
        "GENERIC#:"
        "GENERIC:"
        "HOOK:"
        "H{"
        "HS{"
        "IN:"
        "INSTANCE:"
        "M:"
        "MAIN:"
        "MATH:"
        "MIXIN:"
        "nan:"
        "P\""
        "postpone:"
        "PREDICATE:"
        "PRIMITIVE:"
        "PRIVATE>"
        "SBUF\""
        "SINGLETON:"
        "SINGLETONS:"
        "BUILTIN:"
        "SYMBOL:"
        "SYMBOLS:"
        "CONSTANT:"
        "TUPLE:"
        "final"
        "SLOT:"
        "T{"
        "TH{"
        "UNION:"
        "INTERSECTION:"
        "USE:"
        "UNUSE:"
        "USING:"
        "QUALIFIED:"
        "QUALIFIED-WITH:"
        "FROM:"
        "EXCLUDE:"
        "RENAME:"
        "ALIAS:"
        "SYNTAX:"
        "V{"
        "W{"
        "["
        "\\"
        "M\\\\"
        "]"
        "delimiter"
        "deprecated"
        "f"
        "flushable"
        "foldable"
        "inline"
        "recursive"
        "t"
        "{"
        "}"
        "CS{"
        "<<"
        ">>"
        "call-next-method"
        "not{"
        "maybe{"
        "union{"
        "intersection{"
        "initial:"
        "read-only"
        "call("
        "execute("
        "IH{"
        "::"
        "M::"
        "MACRO:"
        "MACRO::"
        "TYPED:"
        "TYPED::"
        "MEMO:"
        "MEMO::"
        "MEMO["
        "IDENTITY-MEMO:"
        "IDENTITY-MEMO::"
        "PROTOCOL:"
        "CONSULT:"
        "BROADCAST:"
        "SLOT-PROTOCOL:"
        "HINTS:"
        "':"
        "'["
        "@"
        "_"
        "[["
        "[=["
        "[==["
        "[===["
        "[====["
        "[=====["
        "[======["

        "![["
        "![=["
        "![==["
        "![===["
        "![====["
        "![=====["
        "![======["

        "I[["
        "I[=["
        "I[==["
        "I[===["
        "I[====["
        "I[=====["
        "I[======["

        ":>"
        "|["
        "let["
        "'let["
        "FUNCTOR:"
        "VARIABLES-FUNCTOR:"
        "INITIALIZED-SYMBOL:"
        "STARTUP-HOOK:"
        "SHUTDOWN-HOOK:"
    } [ "syntax" create-word drop ] each

    "t" "syntax" lookup-word define-symbol
] with-compilation-unit
