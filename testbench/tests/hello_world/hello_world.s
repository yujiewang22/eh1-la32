// SPDX-License-Identifier: Apache-2.0
// Copyright 2019 Western Digital Corporation or its affiliates.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

// Assembly code for Hello World
// Not using only ALU ops for creating the string


#include "defines.h"

#define STDOUT 0xd0580000


// Code to execute
.section .text
.global _start
_start:

    // Clear minstret
    // wyj
    /*
    csrw minstret, zero
    csrw minstreth, zero
    */
    csrwr $r0, 0xb02
    csrwr $r0, 0xb82

    // Set up MTVEC - not expecting to use it though
    // wyj
    /*
    li x1, RV_ICCM_SADR
    csrw mtvec, x1
    */
    li.w $r1, RV_ICCM_SADR
    csrwr $r1, 0x305


    // Enable Caches in MRAC
    // wyj
    /*
    li x1, 0x5f555555
    csrw 0x7c0, x1
    */
    li.w $r1, 0x5f555555
    csrwr $r1, 0x7c0

    // Load string from hw_data
    // and write to stdout address

    // wyj
    /*
    li x3, STDOUT
    la x4, hw_data
    */
    li.w $r3, STDOUT
    la $r4, hw_data

loop:
   // wyj
   /*
   lb x5, 0(x4)
   sb x5, 0(x3)
   addi x4, x4, 1
   bnez x5, loop
   */
   ld.b $r5, $r4, 0
   st.b $r5, $r3, 0
   addi.w $r4, $r4, 1
   bne $r5, $r0, loop

// Write 0xff to STDOUT for TB to terminate test.
_finish:
    // wyj
    /*
    li x3, STDOUT
    addi x5, x0, 0xff
    sb x5, 0(x3)
    beq x0, x0, _finish
    */
    li.w $r3, STDOUT
    addi.w $r5, $r0, 0xff
    st.b $r5, $r3, 0
    beq $r0, $r0, _finish
.rept 100
    nop
.endr

.global hw_data
.data
hw_data:
.ascii "-------------------------\n"
.ascii "Hello World from VeeR EH1\n"
.ascii "-------------------------\n"
.byte 0
