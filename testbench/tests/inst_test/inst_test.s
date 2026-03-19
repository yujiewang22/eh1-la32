#include "defines.h"

#define STDOUT 0xd0580000

// wyj
// --------------------------------------------------
// r3为outcome结果
// r30、r31为testbench的输出交互
// --------------------------------------------------

// #define TEST_LU12I_W       // PASS
// #define TEST_PCADDU12I     // PASS
// #define TEST_B             // PASS
// #define TEST_BL            // PASS
// #define TEST_JIRL          // PASS
// #define TEST_CONDBR        // PASS
// #define TEST_MEM           // PASS
// #define TEST_ARITH_IMM     // PASS
// #define TEST_ARITH_REG     // PASS
// #define TEST_MUL           // PASS
// #define TEST_DIV           // PASS
// #define TEST_CSRWR         // PASS
// #define TEST_CSRRD         // PASS
// #define TEST_CSRXCHG       // PASS
// #define TEST_RDCNTVL_W     // PASS
// #define TEST_RDCNTVH_W     // PASS

.section .text
.global _start

_start:

// --------------------------------------------------
// 测试指令
// --------------------------------------------------
	
    li.w      $r1, 1                    # r1 = 1
    li.w      $r2, 2                    # r2 = 2

    li.w      $r3, 0                    # r3 = 0

#if defined(TEST_LU12I_W)
    lu12i.w   $r3, 1                    # Outcome: r3 = 0x00001000

#elif defined(TEST_PCADDU12I)
    pcaddu12i $r3, 0                    # Outcome: r3 = 0x0000c000

#elif defined(TEST_B)
    li.w      $r3, 3                    # Outcome: r3 = 3
    b         finish
    li.w      $r3, 0

#elif defined(TEST_BL)
    li.w      $r3, 3                    # Outcome: r3 = 3
    bl        finish                    # Linker : r1 = 0x00000014
    li.w      $r3, 0

#elif defined(TEST_JIRL)
    li.w      $r3, 3                    # Outcome: r3 = 3
    la        $r4, finish
    jirl      $r2, $r4, 0               # Linker : r2 = 0x0000001c
    li.w      $r3, 0

#elif defined(TEST_CONDBR)
    li.w      $r3, 3                    # Outcome: r3 = 3
    bne       $r1, $r2, finish
    li.w      $r3, 0

#elif defined(TEST_MEM)
    li.w      $r4, 3
    li.w      $r5, 0x00123456
    st.w      $r4, $r5, 0               # MEM[0x00123456] = r3
    ld.w      $r3, $r5, 0               # Outcome: r3 = 3

#elif defined(TEST_ARITH_REG)
    add.w     $r3, $r1, $r2             # Outcome: r3 = 3

#elif defined(TEST_ARITH_IMM)
    addi.w    $r3, $r1, 2               # Outcome: r3 = 3

#elif defined(TEST_MUL)
    mul.w     $r3, $r2, $r1             # Outcome: r3 = 2

#elif defined(TEST_DIV)
    div.w     $r3, $r2, $r1             # Outcome: r3 = 2

#elif defined(TEST_CSRWR)
    li.w      $r3, 3
    csrwr     $r3, 0x340                # Outcome: r3 = 0
    csrrd     $r3, 0x340                # Outcome: r3 = 3

#elif defined(TEST_CSRRD)
    csrrd     $r3, 0xf12                # Outcome: r3 = 0xb

#elif defined(TEST_CSRXCHG)
    li.w      $r1, 0x00001111
    li.w      $r2, 0x11111111
    li.w      $r3, 0x10101010
    csrwr     $r1, 0x340                #          r1 = 0
    csrxchg   $r2, $r3, 0x340           #          r2 = 0x00001111
    csrrd     $r3, 0x340                # Outcome: r3 = 0x10101111

#elif defined(TEST_RDCNTVL_W)
    rdcntvl.w $r3                       # Outcome: r3 = low 32 bits of time counter
    rdcntvl.w $r4                       # Outcome: r4 = low 32 bits of time counter
    rdcntvl.w $r5                       # Outcome: r5 = low 32 bits of time counter
    rdcntvl.w $r6                       # Outcome: r6 = low 32 bits of time counter

#elif defined(TEST_RDCNTVH_W)
    rdcntvh.w $r3                       # Outcome: r3 = high 32 bits of time counter
    rdcntvh.w $r4                       # Outcome: r4 = high 32 bits of time counter
    rdcntvh.w $r5                       # Outcome: r5 = high 32 bits of time counter
    rdcntvh.w $r6                       # Outcome: r6 = high 32 bits of time counter
#endif

finish:

// --------------------------------------------------
// 通过 STDOUT 输出结果
// --------------------------------------------------

    li.w      $r30, STDOUT
    st.b      $r3, $r30, 0

// --------------------------------------------------
// 写 0xff 通知 TB 结束
// --------------------------------------------------

    li.w      $r31, 0xff
    st.b      $r31, $r30, 0
 
