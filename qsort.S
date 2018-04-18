	.section	.rodata

	.align	2
.STR_COUNT:
	.string "create %d num:\n"

	.align	2
.STR_CONTEXT:
	.string "array[%d] = %d\n"

	.align	2
.ERR_ARG:
	.string	"argument error\n"

	.align	2
.ERR_MEM:
	.string	"Overflow\n"

	.text
	.align	2
	.global	array_init
array_init:
	push {r4,r5,r6, lr}

	@ init arguments
	mov r4, r0
	mov r5, r1

	mov r0, #0
	bl time
	bl srand

	mov r6, #0
1:
	cmp r6,r5
	bge 1f

	bl rand
	and r0,r0, #0x3f

	str r0 ,[r4, r6, lsl #2]

	add r6, #1
	b 1b
1:
	pop {r4-r6, lr}
	mov pc, lr

	.align	2
	.global	array_print
array_print:
	push {r4,r5,r6, lr}

	@ init arguments
	mov r4, r0
	mov r5, r1

	mov r6, #0
1:
	cmp r6,r5
	bge 1f

	ldr r0, =.STR_CONTEXT
	mov r1, r6
	ldr r2, [r4, r6, lsl #2]
	bl printf

	add r6, #1
	b 1b
1:
	pop {r4-r6, lr}
	mov pc, lr

	.align	2
	.global	array_sort
array_sort:
	push {r4,r5,r6,r7,r8,r9,r10,r11,lr}

	@ init arguments
	mov r4, r0
	mov r5, r1

@init out-loop
	mov r6, #0
1:
	cmp r6, r5
	bge 1f

@init in-loop
	mov r7, #0
	sub r12, r5, r6
	sub r12, #1
2:
	cmp r7, r12
	bge 2f

	ldr r9, [r4, r7, lsl #2]
	add r3, r7, #1
	ldr r10, [r4, r3, lsl #2]

	cmp r9, r10
	bge 3f

	mov r8, r9
	mov r11, r10
	str r8, [r4, r3, lsl #2]
	str r11, [r4, r7, lsl #2]
3:
	add r7, #1
	b 2b
2:
	add r6, #1
	b 1b
1:
	pop {r4-r11, lr}
	mov pc, lr

	.align	2
	.global	main
main:
	push {r4,r5,lr}

	cmp r0,#2
	blt earg_handler

	ldr r0, [r1, #4]

	bl atoi
	mov r4, r0

@Debug Start
	mov r1, r0
	ldr r0, =.STR_COUNT
	bl printf
@Debug End

	mov r1, #4
	mul r0, r4, r1

	bl malloc
	mov r5,r0

	cmp r5, #0
	beq	emem_handler

	mov r0,r5
	mov r1,r4
	bl array_init

	mov r0,r5
	mov r1,r4
	bl array_print

	mov r0,r5
	mov r1,r4
	bl array_sort

	mov r0,r5
	mov r1,r4
	bl array_print

normal_exit:
	mov r0, #0

	pop {r4,r5,lr}

	mov pc, lr

earg_handler:
	ldr r0, =.ERR_ARG
	bl printf
	mov r0, #1
	bl exit

emem_handler:
	ldr r0, =.ERR_MEM
	bl printf
	mov r0, #1
	bl exit
