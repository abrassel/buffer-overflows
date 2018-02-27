	.file	"client.c"
	.text
	.type	get_response, @function
get_response:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$240, %rsp
	movl	%edi, -228(%rbp)
	movq	%rsi, -240(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-208(%rbp), %rsi
	movl	-228(%rbp), %eax
	movl	$0, %ecx
	movl	$1602, %edx
	movl	%eax, %edi
	call	recv
	leaq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movl	%eax, -212(%rbp)
	movq	-240(%rbp), %rax
	leaq	-208(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy
	movl	-212(%rbp), %eax
	cltq
	leaq	1(%rax), %rdx
	leaq	-208(%rbp), %rax
	addq	%rax, %rdx
	movq	-240(%rbp), %rax
	addq	$801, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L2
	call	__stack_chk_fail
.L2:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	get_response, .-get_response
	.section	.rodata
	.align 8
.LC0:
	.string	"Proper usage is ./client <port>"
.LC1:
	.string	"Could not obtain a socket"
.LC2:
	.string	"127.0.0.1"
	.align 8
.LC3:
	.string	"Could not bind to port.  Is it in use?"
.LC4:
	.string	"Please input your username: "
.LC5:
	.string	"%800s"
.LC6:
	.string	"\nPlease input your password: "
.LC7:
	.string	"r"
.LC8:
	.string	"ok"
.LC9:
	.string	"Access refused."
.LC10:
	.string	"%s: %s\n"
.LC11:
	.string	"\\quit"
.LC12:
	.string	"Ending connection."
	.text
	.globl	main
	.type	main, @function
main:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$4176, %rsp
	movl	%edi, -4164(%rbp)
	movq	%rsi, -4176(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movb	$0, -1648(%rbp)
	movb	$0, -832(%rbp)
	cmpl	$2, -4164(%rbp)
	je	.L4
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	movl	$1, %eax
	jmp	.L16
.L4:
	movl	$0, %edx
	movl	$1, %esi
	movl	$2, %edi
	call	socket
	movl	%eax, -4140(%rbp)
	cmpl	$0, -4140(%rbp)
	jne	.L6
	movl	$.LC1, %edi
	call	perror
	movl	$1, %eax
	jmp	.L16
.L6:
	movw	$2, -4112(%rbp)
	movq	-4176(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	htons
	movw	%ax, -4110(%rbp)
	leaq	-4112(%rbp), %rax
	addq	$4, %rax
	movq	%rax, %rdx
	movl	$.LC2, %esi
	movl	$2, %edi
	call	inet_pton
	leaq	-4112(%rbp), %rcx
	movl	-4140(%rbp), %eax
	movl	$16, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	connect
	cmpl	$-1, %eax
	jne	.L7
	movl	$.LC3, %edi
	call	perror
	movl	$1, %eax
	jmp	.L16
.L7:
	movl	$.LC4, %edi
	movl	$0, %eax
	call	printf
	leaq	-2448(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC5, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	movq	stdin(%rip), %rdx
	leaq	-2480(%rbp), %rax
	movl	$2, %esi
	movq	%rax, %rdi
	call	fgets
	movl	$.LC6, %edi
	movl	$0, %eax
	call	printf
	movq	stdin(%rip), %rdx
	leaq	-1632(%rbp), %rax
	movl	$801, %esi
	movq	%rax, %rdi
	call	fgets
	movl	$1, -4144(%rbp)
	jmp	.L8
.L9:
	addl	$1, -4144(%rbp)
.L8:
	movl	-4144(%rbp), %eax
	cltq
	movzbl	-1632(%rbp,%rax), %eax
	cmpb	$10, %al
	jne	.L9
	movl	-4144(%rbp), %eax
	cltq
	movb	$0, -1632(%rbp,%rax)
	leaq	-2448(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movb	%al, -4145(%rbp)
	movl	-4144(%rbp), %eax
	movb	%al, -4146(%rbp)
	movzbl	-1632(%rbp), %eax
	cmpb	$92, %al
	jne	.L10
	movzbl	-1631(%rbp), %eax
	cmpb	$117, %al
	jne	.L10
	leaq	-1632(%rbp), %rax
	addq	$3, %rax
	movl	$.LC7, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -4128(%rbp)
	movq	-4128(%rbp), %rdx
	leaq	-1632(%rbp), %rax
	movq	%rdx, %rcx
	movl	$801, %edx
	movl	$1, %esi
	movq	%rax, %rdi
	call	fread
	movb	%al, -4146(%rbp)
	subb	$1, -4146(%rbp)
.L10:
	movzbl	-4145(%rbp), %edx
	movzbl	-4146(%rbp), %eax
	addl	%edx, %eax
	addl	$2, %eax
	movl	%eax, -4136(%rbp)
	movl	-4136(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -4120(%rbp)
	leaq	-2448(%rbp), %rdx
	movq	-4120(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy
	movzbl	-4146(%rbp), %eax
	addl	$1, %eax
	movslq	%eax, %rdx
	movzbl	-4145(%rbp), %eax
	leaq	1(%rax), %rcx
	movq	-4120(%rbp), %rax
	addq	%rax, %rcx
	leaq	-1632(%rbp), %rax
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	memcpy
	movl	-4136(%rbp), %eax
	movslq	%eax, %rdx
	movq	-4120(%rbp), %rsi
	movl	-4140(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	send
	movb	$0, -2462(%rbp)
	leaq	-2464(%rbp), %rsi
	movl	-4140(%rbp), %eax
	movl	$0, %ecx
	movl	$2, %edx
	movl	%eax, %edi
	call	recv
	leaq	-2464(%rbp), %rax
	movl	$.LC8, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L11
	movl	$.LC9, %edi
	call	puts
	movl	$1, %eax
	jmp	.L16
.L11:
	call	fork
	movl	%eax, -4132(%rbp)
	cmpl	$0, -4132(%rbp)
	jne	.L12
.L13:
	leaq	-4096(%rbp), %rdx
	movl	-4140(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	get_response
	leaq	-4096(%rbp), %rax
	leaq	801(%rax), %rdx
	leaq	-4096(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC10, %edi
	movl	$0, %eax
	call	printf
	jmp	.L13
.L12:
	movq	stdin(%rip), %rdx
	leaq	-2481(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fgets
.L15:
	movq	stdin(%rip), %rdx
	leaq	-816(%rbp), %rax
	movl	$801, %esi
	movq	%rax, %rdi
	call	fgets
	leaq	-816(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	subq	$1, %rax
	movb	$0, -816(%rbp,%rax)
	leaq	-816(%rbp), %rax
	movl	$.LC11, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L14
	movl	$.LC12, %edi
	movl	$0, %eax
	call	printf
	movl	-4132(%rbp), %eax
	movl	$15, %esi
	movl	%eax, %edi
	call	kill
	movl	$1, %eax
	jmp	.L16
.L14:
	leaq	-816(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	leaq	1(%rax), %rdx
	leaq	-816(%rbp), %rsi
	movl	-4140(%rbp), %eax
	movl	$0, %ecx
	movl	%eax, %edi
	call	send
	jmp	.L15
.L16:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L17
	call	__stack_chk_fail
.L17:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.6) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
