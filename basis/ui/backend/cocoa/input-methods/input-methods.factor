! Copyright (C) 2019 KUSUMOTO Norio
! See http://factorcode.org/license.txt for BSD license.
USING: kernel accessors combinators locals ui.gadgets ui.gadgets.editors ;
IN: ui.backend.cocoa.input-methods

GENERIC: support-input-methods? ( gadget -- ? )
M: gadget support-input-methods? drop f ;
