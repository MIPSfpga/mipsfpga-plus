// This boot code is derived from https://github.com/sergev/LiteBSD/blob/master/sys/mips/pic32/locore.s

#include <mips/regdef.h>
#include <mips/asm.h>
#include <mips/m32c0.h>

        .set    noreorder               # Don't allow the assembler to reorder instructions.
        .set    noat

/*-----------------------------------
 * Reset/NMI exception handler.
 */
        .globl  start
        .type   start, @function
        .section .reset
start:
        mtc0    zero, C0_COUNT          # Clear cp0 Count (Used to measure boot time.)

        //
        // Set all GPRs of all register sets to predefined state.
        //

init_gpr:
        li      $1, 0xdeadbeef          # 0xdeadbeef stands out, kseg2 mapped, odd.

        # Determine how many shadow sets are implemented (in addition to the base register set.)
        # the first time thru the loop it will initialize using $1 set above.
        # At the bottom og the loop, 1 is  subtract from $30
        # and loop back to next_shadow_set to start the next loop and the next lowest set number.
        mfc0    $29, C0_SRSCTL          # read SRSCtl
        ext     $30, $29, 26, 4         # extract HSS

next_shadow_set:                        # set PSS to shadow set to be initialized
        ins     $29, $30, 6, 4          # insert PSS
        mtc0    $29, C0_SRSCTL          # write SRSCtl

        wrpgpr  $1, $1
        wrpgpr  $2, $1
        wrpgpr  $3, $1
        wrpgpr  $4, $1
        wrpgpr  $5, $1
        wrpgpr  $6, $1
        wrpgpr  $7, $1
        wrpgpr  $8, $1
        wrpgpr  $9, $1
        wrpgpr  $10, $1
        wrpgpr  $11, $1
        wrpgpr  $12, $1
        wrpgpr  $13, $1
        wrpgpr  $14, $1
        wrpgpr  $15, $1
        wrpgpr  $16, $1
        wrpgpr  $17, $1
        wrpgpr  $18, $1
        wrpgpr  $19, $1
        wrpgpr  $20, $1
        wrpgpr  $21, $1
        wrpgpr  $22, $1
        wrpgpr  $23, $1
        wrpgpr  $24, $1
        wrpgpr  $25, $1
        wrpgpr  $26, $1
        wrpgpr  $27, $1
        wrpgpr  $28, $1
        beqz    $30, init_cp0
        wrpgpr  $29, $1

        wrpgpr  $30, $1
        wrpgpr  $31, $1
        b       next_shadow_set
        add     $30, -1                 # Decrement to the next lower number

        //
        // Init CP0 Status, Count, Compare, Watch*, and Cause.
        //
init_cp0:
        # Initialize Status
	li	v1, 0x00400004		// (M_StatusERL | M_StatusBEV)
        mtc0    v1, C0_STATUS           # write Status

        # Initialize Watch registers if implemented.
        mfc0    v0, C0_CONFIG1          # read Config1
        ext     v1, v0, 3, 1            # extract bit 3 WR (Watch registers implemented)
        beq     v1, zero, done_wr
        li      v1, 0x7                 # (M_WatchHiI | M_WatchHiR | M_WatchHiW)

        # Clear Watch Status bits and disable watch exceptions
        mtc0    v1, C0_WATCHHI          # write WatchHi0
        mfc0    v0, C0_WATCHHI          # read WatchHi0
        bgez    v0, done_wr             # Check for bit 31 (sign bit) for more Watch registers
        mtc0    zero, C0_WATCHLO        # clear WatchLo0

        mtc0    v1, C0_WATCHHI, 1       # write WatchHi1
        mfc0    v0, C0_WATCHHI, 1       # read WatchHi1
        bgez    v0, done_wr             # Check for bit 31 (sign bit) for more Watch registers
        mtc0    zero, C0_WATCHLO,1      # clear WatchLo1

        mtc0    v1, C0_WATCHHI, 2       # write WatchHi2
        mfc0    v0, C0_WATCHHI, 2       # read WatchHi2
        bgez    v0, done_wr             # Check for bit 31 (sign bit) for more Watch registers
        mtc0    zero, C0_WATCHLO, 2     # clear WatchLo2

        mtc0    v1, C0_WATCHHI, 3       # write WatchHi3
        mfc0    v0, C0_WATCHHI, 3       # read WatchHi3
        bgez    v0, done_wr             # Check for bit 31 (sign bit) for more Watch registers
        mtc0    zero, C0_WATCHLO, 3     # clear WatchLo3

        mtc0    v1, C0_WATCHHI, 4       # write WatchHi4
        mfc0    v0, C0_WATCHHI, 4       # read WatchHi4
        bgez    v0, done_wr             # Check for bit 31 (sign bit) for more Watch registers
        mtc0    zero, C0_WATCHLO, 4     # clear WatchLo4

        mtc0    v1, C0_WATCHHI, 5       # write WatchHi5
        mfc0    v0, C0_WATCHHI, 5       # read WatchHi5
        bgez    v0, done_wr             # Check for bit 31 (sign bit) for more Watch registers
        mtc0    zero, C0_WATCHLO, 5     # clear WatchLo5

        mtc0    v1, C0_WATCHHI, 6       # write WatchHi6
        mfc0    v0, C0_WATCHHI, 6       # read WatchHi6
        bgez    v0, done_wr             # Check for bit 31 (sign bit) for more Watch registers
        mtc0    zero, C0_WATCHLO, 6     # clear WatchLo6

        mtc0    v1, C0_WATCHHI, 7       # write WatchHi7
        mtc0    zero, C0_WATCHLO, 7     # clear WatchLo7

done_wr:
        # Clear WP bit to avoid watch exception upon user code entry, IV, and software interrupts.
        mtc0    zero, C0_CAUSE          # clear Cause: init AFTER init of WatchHi/Lo registers.

        # Clear timer interrupt. (Count was cleared at the reset vector to allow timing boot.)
        mtc0    zero, C0_COMPARE        # clear Compare

/*-----------------------------------
 * Initialization.
 */
        //
        // Clear TLB: generate unique EntryHi contents per entry pair.
        //
init_tlb:
        # Determine if we have a TLB
        mfc0    v1, C0_CONFIG           # read Config
        ext     v1, v1, 7, 3            # extract MT field
        li      a3, 0x1                 # load a 1 to check against
        bne     v1, a3, init_icache

        # Config1MMUSize == Number of TLB entries - 1
        mfc0    v0, C0_CONFIG1          # Config1
        ext     v1, v0, 25, 6           # extract MMU Size
        mtc0    zero, C0_ENTRYLO0       # clear EntryLo0
        mtc0    zero, C0_ENTRYLO1       # clear EntryLo1
        mtc0    zero, C0_PAGEMASK       # clear PageMask
        mtc0    zero, C0_WIRED          # clear Wired
        li      a0, 0x80000000

next_tlb_entry:
        mtc0    v1, C0_INDEX            # write Index
        mtc0    a0, C0_ENTRYHI          # write EntryHi
        ehb
        tlbwi
        add     a0, 2 << 13             # Add 8K to the address to avoid TLB conflict with previous entry

        bne     v1, zero, next_tlb_entry
        add     v1, -1

        //
        // Clear L1 instruction cache.
        //
init_icache:
        # Determine how big the I-cache is
        mfc0    v0, C0_CONFIG1          # read Config1
        ext     v1, v0, 19, 3           # extract I-cache line size
        beq     v1, zero, done_icache   # Skip ahead if no I-cache
        nop

        li      a2, 2
        sllv    v1, a2, v1              # Now have true I-cache line size in bytes

        ext     a0, v0, 22, 3           # extract IS
        li      a2, 64
        sllv    a0, a2, a0              # I-cache sets per way

        ext     a1, v0, 16, 3           # extract I-cache Assoc - 1
        add     a1, 1
        mul     a0, a0, a1              # Total number of sets
        lui     a2, 0x8000              # Get a KSeg0 address for cacheops

        mtc0    zero, C0_ITAGLO         # Clear ITagLo register
        move    a3, a0

next_icache_tag:
        # Index Store Tag Cache Op
        # Will invalidate the tag entry, clear the lock bit, and clear the LRF bit
        cache   0x8, 0 (a2)             # ICIndexStTag
        add     a3, -1                  # Decrement set counter
        bne     a3, zero, next_icache_tag
        add     a2, v1                  # Get next line address
done_icache:

        //
        // Enable cacheability of kseg0 segment.
        // Until this point the code is executed from segment bfc00000,
        // (i.e. kseg1), so I-cache is not used.
        // Here we jump to kseg0 and run with I-cache enabled.
        //
enable_k0_cache:
        # Set CCA for kseg0 to cacheable.
        # NOTE! This code must be executed in KSEG1 (not KSEG0 uncached)
        mfc0    v0, C0_CONFIG           # read Config
        li      v1, 3                   # CCA for single-core processors
        ins     v0, v1, 0, 3            # insert K0
        mtc0    v0, C0_CONFIG           # write Config

        la      a2, init_dcache
        jr      a2                      # switch back to KSEG0
        ehb

        //
        // Initialize the L1 data cache
        //
init_dcache:
        mfc0    v0, C0_CONFIG1          # read Config1
        ext     v1, v0, 10, 3           # extract D-cache line size
        beq     v1, zero, done_dcache   # Skip ahead if no D-cache
        nop

        li      a2, 2
        sllv    v1, a2, v1              # Now have true D-cache line size in bytes

        ext     a0, v0, 13, 3           # extract DS
        li      a2, 64
        sllv    a0, a2, a0              # D-cache sets per way

        ext     a1, v0, 7, 3            # extract D-cache Assoc - 1
        add     a1, 1
        mul     a0, a0, a1              # Get total number of sets
        lui     a2, 0x8000              # Get a KSeg0 address for cacheops

        mtc0    zero, C0_ITAGLO         # Clear ITagLo/DTagLo registers
        mtc0    zero, C0_DTAGLO
        move    a3, a0

next_dcache_tag:
        # Index Store Tag Cache Op
        # Will invalidate the tag entry, clear the lock bit, and clear the LRF bit
        cache   0x9, 0 (a2)             # DCIndexStTag
        add     a3, -1                  # Decrement set counter
        bne     a3, zero, next_dcache_tag
        add     a2, v1                  # Get next line address
done_dcache:

        # Prepare for eret to main.

        la      ra, all_done        # If main returns then go to all_done:.
        move    a0, zero            # Indicate that there are no arguments available.

        la      v0, main            # load the address of the CRT entry point _start.
        mtc0    v0, $30             # Write ErrorEPC with the address of main
        ehb                         # clear hazards (makes sure write to ErrorPC has completed)

        # Set stack and global data

        la	sp, __stack
        la      gp, _gp

        # Return from exception will now execute code in main

        eret                        # Exit reset exception handler and start execution of _start.


/**************************************************************************************/
all_done:
        # If main returns it will return to this point.  Just spin here.
        b       all_done
        nop
