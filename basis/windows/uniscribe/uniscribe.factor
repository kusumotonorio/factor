! Copyright (C) 2009 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors alien.c-types alien.data arrays assocs cache
classes.struct combinators destructors fonts init io.encodings.string
io.encodings.utf16n kernel literals locals math namespaces sequences
windows.errors windows.fonts windows.gdi32 windows.offscreen
windows.ole32 windows.types windows.usp10 colors images math.vectors
math.order ;
IN: windows.uniscribe

TUPLE: script-string < disposable font string metrics ssa size image ;

: line-offset>x ( n script-string -- x )
    2dup string>> length = [
        ssa>> ! ssa
        swap 1 - ! icp
        TRUE ! fTrailing
    ] [
        ssa>>
        swap ! icp
        FALSE ! fTrailing
    ] if
    { int } [ ScriptStringCPtoX check-ole32-error ] with-out-parameters ;

: x>line-offset ( x script-string -- n trailing )
    ssa>> ! ssa
    swap ! iX
    { int int } [ ScriptStringXtoCP check-ole32-error ] with-out-parameters ;

<PRIVATE

SYMBOL: chroma-key-background

CONSTANT: ssa-dwFlags flags{ SSA_GLYPHS SSA_FALLBACK SSA_TAB }

: make-ssa ( dc script-string -- ssa )
    dup selection? [ string>> ] when
    [ utf16n encode ] ! pString
    [ length ] bi ! cString
    dup 1.5 * 16 + >integer ! cGlyphs -- MSDN says this is "recommended size"
    -1 ! iCharset -- Unicode
    ssa-dwFlags
    0 ! iReqWidth
    f ! psControl
    f ! psState
    f ! piDx
    f ! pTabdef
    f ! pbInClass
    f void* <ref> ! pssa
    [ ScriptStringAnalyse ] keep
    [ check-ole32-error ] [ |ScriptStringFree void* deref ] bi* ;

:: set-dc-colors ( dc font -- )
    font background>> dup >rgba alpha>> 1 number= [
        dc swap color>RGB SetBkColor drop
    ] [
        drop
        font foreground>> [ red>> ] [ green>> ] [ blue>> ] tri :> ( r g b ) 
        r g b max max 0.65 > [
            { r g b } 0.2 v*n
        ] [
            { 1.0 1.0 1.0 } clone { r g b } v- 0.2 v*n { 1.0 1.0 1.0 } clone swap v-
        ] if 
        dup [ 255 * >integer ] map chroma-key-background set
        first3 1.0 <rgba> dc swap color>RGB SetBkColor drop
    ] if
    dc font foreground>> color>RGB SetTextColor drop ;

: selection-start/end ( script-string -- iMinSel iMaxSel )
    string>> dup selection? [ [ start>> ] [ end>> ] bi ] [ drop 0 0 ] if ;

: draw-script-string ( ssa size script-string -- )
    [
        0 ! iX
        0 ! iY
        ETO_OPAQUE ! uOptions
    ]
    [ [ { 0 0 } ] dip <RECT> ]
    [ selection-start/end ] tri*
    ! iMinSel
    ! iMaxSel
    FALSE ! fDisabled
    ScriptStringOut check-ole32-error ;

:: render-image ( dc ssa script-string -- image )
    script-string size>> :> size
    size dc
    [ ssa size script-string draw-script-string ] make-bitmap-image ;

: set-dc-font ( dc font -- )
    cache-font SelectObject win32-error=0/f ;

: ssa-size ( ssa -- dim )
    ScriptString_pSize
    dup win32-error=0/f
    [ cx>> ] [ cy>> ] bi 2array ;

: dc-metrics ( dc -- metrics )
    TEXTMETRICW <struct>
    [ GetTextMetrics drop ] keep
    TEXTMETRIC>metrics ;

! DC limit is default soft-limited to 10,000 per process.
: <script-string> ( font string -- script-string )
    [ script-string new-disposable ] 2dip
        [ >>font ] [ >>string ] bi*
    [
        {
            [ over font>> set-dc-font ]
            [ dc-metrics >>metrics ]
            [ over string>> make-ssa [ >>ssa ] [ ssa-size >>size ] bi ]
        } cleave
    ] with-memory-dc ;

:: remove-background ( chroma-key-image foreground-color -- processed-image )
    chroma-key-background get :> bk-color
    foreground-color [ red>> ] [ green>> ] [ blue>> ] tri
    [ 255 * >integer ] tri@ 3array :> text-color
    chroma-key-image [
        first3 :> ( b g r )
        bk-color { r g b } = [
            { 0 0 0 0 } clone
        ] [
            text-color { r g b } = [
                { b g r 255 }
            ] [
                { r g b } bk-color v- norm-sq
                text-color bk-color v- norm-sq
                / 155 * 100 + >integer 255 min :> a 
                { b g r a }
            ] if
        ] if
        -rot chroma-key-image set-pixel-at
    ] each-pixel
    chroma-key-image BGRA >>component-order ;

PRIVATE>

M: script-string dispose*
    ssa>> void* <ref> ScriptStringFree check-ole32-error ;

SYMBOL: cached-script-strings

: cached-script-string ( font string -- script-string )
    cached-script-strings get-global [ <script-string> ] 2cache ;

: script-string>image ( script-string -- image )
    dup image>> [
        [
            {
                [ over font>> [ set-dc-font ] [ set-dc-colors ] 2bi ]
                [
                    dup pick string>> make-ssa
                    dup void* <ref> &ScriptStringFree drop
                    pick render-image
                    over font>> background>> alpha>> 1 number= [
                        over font>> foreground>> remove-background
                    ] unless
                    >>image
                ]
            } cleave
        ] with-memory-dc
    ] unless image>> ;

[ <cache-assoc> &dispose cached-script-strings set-global ]
"windows.uniscribe" add-startup-hook
