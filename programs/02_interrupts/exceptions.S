	.set	noreorder	# Don't allow the assembler to reorder instructions.
	.set	noat

	.section .exceptions

	.org	0x180

general_exception_vector:

	.type	general_exception_vector, @function

	j	general_exception_handler
	nop
