USING: kernel alien alien.libraries ;
in: opengl.gl.macosx

: gl-function-context ( -- context ) 0 ; inline
: gl-function-address ( name -- address ) f dlsym ; inline
: gl-function-calling-convention ( -- str ) cdecl ; inline