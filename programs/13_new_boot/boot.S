// This boot code is derived from https://github.com/sergev/LiteBSD/blob/master/sys/mips/pic32/locore.s

// Place all code in the .reset section
#define _RESETCODE

#include <mips/regdef.h>
#include <mips/asm.h>
#include <mips/m32c0.h>


/*-----------------------------------
 * Reset/NMI exception handler.
 */
	.set push
        .set noreorder                  # Don't allow the assembler to reorder instructions.
        .set noat
	.set nomicromips
LEAF(__reset_vector)

        mtc0    zero, C0_COUNT          # Clear cp0 Count (Used to measure boot time.)

        //
        // Init CP0 Status, Count, Compare, Watch*, and Cause.
        //
init_cp0:
        # Initialize Status
	li	v1, 0x00400004		// (M_StatusERL | M_StatusBEV)
        mtc0    v1, C0_STATUS           # write Status

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

        # Prepare for eret to _start.

        la      ra, all_done        # If main returns then go to all_done:.
        move    a0, zero            # Indicate that there are no arguments available.

        la      v0, _start          # load the address of the CRT entry point _start.
        mtc0    v0, $30             # Write ErrorEPC with the address of main
        ehb                         # clear hazards (makes sure write to ErrorPC has completed)

        # Return from exception will now execute code at _start

        eret                        # Exit reset exception handler and start execution of _start.


/**************************************************************************************/
all_done:
        # If main returns it will return to this point.  Just spin here.
        b       all_done
        nop
END(__reset_vector)
