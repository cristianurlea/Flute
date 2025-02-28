// Copyright (c) 2016-2020 Bluespec, Inc. All Rights Reserved.
// DO NOT EDIT! This file is automatically generated from a script

// Size, type and function declarations for cache structures

package Cache_Decls_RV64_8KB_2way;

// ================================================================
// Basic sizes, from which everything else is derived

// Bits_per_PA      =  64    (= 0x40)    (bits per physical addr)
// KB_per_Cache     =   8    (= 0x08)    (cache size)
// Bits_per_CWord   = 128    (= 0x80)    (bits per cache words)
// CWords_per_CLine =   4    (= 0x04)    (cache line size in cache words)
// Ways_per_CSet    =   2    (= 0x02)    (associativity)

// ================================================================
// Type decls

// Basic ----------------

typedef        64   Bits_per_PA;    // (basic)
typedef       128   Bits_per_CWord;    // (basic)
typedef        16   Bytes_per_CWord;    // Bits_per_CWord / 8
typedef         4   Bits_per_Byte_in_CWord;    // log2 (Bytes_per_CWord)

// Cache Lines ----------------

typedef         4   CWords_per_CLine;    // (basic)
typedef         2   Bits_per_CWord_in_CLine;    // log2 (CWords_per_CLine)

typedef        64   Bytes_per_CLine;    // Bits_per_CLine / 8
typedef         6   Bits_per_Byte_in_CLine;    // log2 (Bytes_per_CLine)

typedef       512   Bits_per_CLine;    // CWords_per_CLine * Bits_per_CWord

// Cache Sets ----------------

typedef         2   Ways_per_CSet;    // (basic; associativity)
typedef         1   Bits_per_Way_in_CSet;    // log2 (Ways_per_CSet)

typedef       128   Bytes_per_CSet;    // Ways_per_CSet * Bytes_per_CLine

// Cache ----------------

typedef         8   KB_per_Cache;    // (basic)
typedef      8192   Bytes_per_Cache;    // KB_per_Cache * 1024
typedef       512   CWords_per_Cache;    // Bytes_per_Cache / Bytes_per_CWord
typedef       128   CLines_per_Cache;    // Bytes_per_Cache / Bytes_per_CLine

typedef        64   CSets_per_Cache;    // Bytes_per_Cache / Bytes_per_CSet
typedef         6   Bits_per_CSet_in_Cache;    // log2 (CSets_per_Cache)

typedef       256   CSet_CWords_per_Cache;    // CSets_per_Cache * CWords_per_CLine
typedef         8   Bits_per_CSet_CWord_in_Cache;    // Bits_per_CSet_in_Cache + Bits_per_CWord_in_CLine
typedef        52   Bits_per_CTag;    // Bits_per_PA - (Bits_per_CSet_in_Cache + Bits_per_Byte_in_CLine)

// ================================================================
// Integer decls

// Basic ----------------

Integer                   bits_per_pa =       64;    // (basic)
Integer                bits_per_cword =      128;    // (basic)
Integer               bytes_per_cword =       16;    // Bits_per_CWord / 8
Integer        bits_per_byte_in_cword =        4;    // log2 (Bytes_per_CWord)

// Cache Lines ----------------

Integer              cwords_per_cline =        4;    // (basic)
Integer       bits_per_cword_in_cline =        2;    // log2 (CWords_per_CLine)

Integer               bytes_per_cline =       64;    // Bits_per_CLine / 8
Integer        bits_per_byte_in_cline =        6;    // log2 (Bytes_per_CLine)

Integer                bits_per_cline =      512;    // CWords_per_CLine * Bits_per_CWord

// Cache Sets ----------------

Integer                 ways_per_cset =        2;    // (basic; associativity)
Integer          bits_per_way_in_cset =        1;    // log2 (Ways_per_CSet)

Integer                bytes_per_cset =      128;    // Ways_per_CSet * Bytes_per_CLine

// Cache ----------------

Integer                  kb_per_cache =        8;    // (basic)
Integer               bytes_per_cache =     8192;    // KB_per_Cache * 1024
Integer              cwords_per_cache =      512;    // Bytes_per_Cache / Bytes_per_CWord
Integer              clines_per_cache =      128;    // Bytes_per_Cache / Bytes_per_CLine

Integer               csets_per_cache =       64;    // Bytes_per_Cache / Bytes_per_CSet
Integer        bits_per_cset_in_cache =        6;    // log2 (CSets_per_Cache)

Integer         cset_cwords_per_cache =      256;    // CSets_per_Cache * CWords_per_CLine
Integer  bits_per_cset_cword_in_cache =        8;    // Bits_per_CSet_in_Cache + Bits_per_CWord_in_CLine
Integer                 bits_per_ctag =       52;    // Bits_per_PA - (Bits_per_CSet_in_Cache + Bits_per_Byte_in_CLine)

// Addrs ----------------

Integer        addr_lo_cword_in_cline =        4;    // log2 (Bytes_per_CWord)
Integer        addr_hi_cword_in_cline =        5;    // addr_lo_cword_in_cline + Bits_per_CWord_in_CLine - 1

Integer         addr_lo_cset_in_cache =        6;    // addr_hi_cword_in_cline + 1
Integer         addr_hi_cset_in_cache =       11;    // addr_lo_cset_in_cache + Bits_per_CSet_in_Cache - 1

Integer   addr_lo_cset_cword_in_cache =        4;    // log2 (Bytes_per_CWord)
Integer   addr_hi_cset_cword_in_cache =       11;    // addr_lo_cword_set_in_cache + Bits_per_CWord_Set_in_Cache - 1

Integer                  addr_lo_ctag =       12;    // addr_hi_cset_in_cache + 1

// ================================================================
// Addresses and address-fields

// Local synonyms (for use in this package)
typedef Bit #(Bits_per_CWord)               CWord;
typedef Bit #(Bits_per_CLine)               CLine;
typedef Bit #(Bits_per_CTag)                CTag;
typedef Bit #(Bits_per_Byte_in_CLine)       Byte_in_CLine;
typedef Bit #(Bits_per_CWord_in_CLine)      CWord_in_CLine;
typedef Bit #(Bits_per_Way_in_CSet)         Way_in_CSet;
typedef Bit #(Bits_per_CSet_in_Cache)       CSet_in_Cache;
typedef Bit #(Bits_per_CSet_CWord_in_Cache) CSet_CWord_in_Cache;

// ================================================================
// Address-decode functions

function  Bit #(4)  fn_Addr_to_Byte_in_CWord (Bit #(n)  addr);
   return  addr [3:0];
endfunction

function  CWord_in_CLine  fn_Addr_to_CWord_in_CLine (Bit #(n)  addr);
   return  addr [addr_hi_cword_in_cline : addr_lo_cword_in_cline ];
endfunction

function  CSet_in_Cache  fn_Addr_to_CSet_in_Cache (Bit #(n)  addr);
   return  addr [addr_hi_cset_in_cache : addr_lo_cset_in_cache ];
endfunction

function  CSet_CWord_in_Cache  fn_Addr_to_CSet_CWord_in_Cache (Bit #(n)  addr);
   return  addr [addr_hi_cset_cword_in_cache : addr_lo_cset_cword_in_cache ];
endfunction

function  CTag  fn_PA_to_CTag (Bit #(n)  pa);
   return  pa [(valueOf (n) - 1) : addr_lo_ctag ];
endfunction

// Align to start of CLine
function  Bit #(n)  fn_align_Addr_to_CLine (Bit #(n)  addr);
   Bit #(n) mask = (1 << addr_lo_cset_in_cache) - 1;
   return  addr & (~ mask);
endfunction

// ================================================================

endpackage: Cache_Decls_RV64_8KB_2way
