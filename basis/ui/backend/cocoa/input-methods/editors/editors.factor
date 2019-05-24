! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences accessors combinators sorting math
ui.gadgets.editors ui.backend.cocoa.input-methods ;
IN: ui.backend.cocoa.input-methods.editors

M: editor support-input-methods? drop t ;

: remove-preedit-text ( editor -- )
    { [ preedit-start>> ] [ set-caret ]
      [ preedit-end>> ] [ set-mark ]
      [ remove-selection ]
    } cleave ;

: remove-preedit-info ( editor -- )
    f >>preedit-start
    f >>preedit-end
    f >>preedit-selected-start
    f >>preedit-selected-end
    drop ;

: editor-selected-range ( editor -- location length )
    [ editor-mark second ] [ editor-caret second ] bi sort-pair over - ;

