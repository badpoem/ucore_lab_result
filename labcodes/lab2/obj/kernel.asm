
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 85 5d 00 00       	call   c0105ddb <memset>

    cons_init();                // init the console
c0100056:	e8 7a 15 00 00       	call   c01015d5 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 80 5f 10 c0 	movl   $0xc0105f80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 9c 5f 10 c0 	movl   $0xc0105f9c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 55 42 00 00       	call   c01042d9 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 b5 16 00 00       	call   c010173e <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 2d 18 00 00       	call   c01018bb <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 f8 0c 00 00       	call   c0100d8b <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 14 16 00 00       	call   c01016ac <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 01 0c 00 00       	call   c0100cbd <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 a1 5f 10 c0 	movl   $0xc0105fa1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 af 5f 10 c0 	movl   $0xc0105faf,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 bd 5f 10 c0 	movl   $0xc0105fbd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 cb 5f 10 c0 	movl   $0xc0105fcb,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 d9 5f 10 c0 	movl   $0xc0105fd9,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 e8 5f 10 c0 	movl   $0xc0105fe8,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 27 60 10 c0 	movl   $0xc0106027,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 07 13 00 00       	call   c0101601 <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 bd 52 00 00       	call   c01055f4 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 8e 12 00 00       	call   c0101601 <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 6e 12 00 00       	call   c010163d <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 2c 60 10 c0    	movl   $0xc010602c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 2c 60 10 c0 	movl   $0xc010602c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 a0 72 10 c0 	movl   $0xc01072a0,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 f0 1e 11 c0 	movl   $0xc0111ef0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec f1 1e 11 c0 	movl   $0xc0111ef1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 1e 49 11 c0 	movl   $0xc011491e,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 63 55 00 00       	call   c0105c4f <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 36 60 10 c0 	movl   $0xc0106036,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 4f 60 10 c0 	movl   $0xc010604f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 64 5f 10 	movl   $0xc0105f64,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 67 60 10 c0 	movl   $0xc0106067,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 7f 60 10 c0 	movl   $0xc010607f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 97 60 10 c0 	movl   $0xc0106097,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 b0 60 10 c0 	movl   $0xc01060b0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 da 60 10 c0 	movl   $0xc01060da,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 f6 60 10 c0 	movl   $0xc01060f6,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i, j;
    for(i = 0 ; i < STACKFRAME_DEPTH ; i ++)
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 97 00 00 00       	jmp    c0100a76 <print_stackframe+0xbc>
    {
        cprintf("ebp is 0x%08x, eip is 0x%08x, ", ebp, eip);
c01009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ed:	c7 04 24 08 61 10 c0 	movl   $0xc0106108,(%esp)
c01009f4:	e8 43 f9 ff ff       	call   c010033c <cprintf>
        uint32_t* argu = (uint32_t*)ebp + 2;
c01009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fc:	83 c0 08             	add    $0x8,%eax
c01009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for(j = 0 ; j < 4 ; j ++)
c0100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a09:	eb 2c                	jmp    c0100a37 <print_stackframe+0x7d>
        {
            cprintf("argu[%d] is 0%08x, ", j, argu[j]);
c0100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a18:	01 d0                	add    %edx,%eax
c0100a1a:	8b 00                	mov    (%eax),%eax
c0100a1c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a27:	c7 04 24 27 61 10 c0 	movl   $0xc0106127,(%esp)
c0100a2e:	e8 09 f9 ff ff       	call   c010033c <cprintf>
    int i, j;
    for(i = 0 ; i < STACKFRAME_DEPTH ; i ++)
    {
        cprintf("ebp is 0x%08x, eip is 0x%08x, ", ebp, eip);
        uint32_t* argu = (uint32_t*)ebp + 2;
        for(j = 0 ; j < 4 ; j ++)
c0100a33:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a37:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a3b:	7e ce                	jle    c0100a0b <print_stackframe+0x51>
        {
            cprintf("argu[%d] is 0%08x, ", j, argu[j]);
        }
        cprintf("\n");
c0100a3d:	c7 04 24 3b 61 10 c0 	movl   $0xc010613b,(%esp)
c0100a44:	e8 f3 f8 ff ff       	call   c010033c <cprintf>
        print_debuginfo(eip - 1);
c0100a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a4c:	83 e8 01             	sub    $0x1,%eax
c0100a4f:	89 04 24             	mov    %eax,(%esp)
c0100a52:	e8 af fe ff ff       	call   c0100906 <print_debuginfo>
        eip = ((uint32_t*)ebp)[1];
c0100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5a:	83 c0 04             	add    $0x4,%eax
c0100a5d:	8b 00                	mov    (%eax),%eax
c0100a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t*)ebp)[0];
c0100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a65:	8b 00                	mov    (%eax),%eax
c0100a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(ebp == 0)
c0100a6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a6e:	75 02                	jne    c0100a72 <print_stackframe+0xb8>
            break;
c0100a70:	eb 0e                	jmp    c0100a80 <print_stackframe+0xc6>
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
    uint32_t eip = read_eip();
    int i, j;
    for(i = 0 ; i < STACKFRAME_DEPTH ; i ++)
c0100a72:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a76:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a7a:	0f 8e 5f ff ff ff    	jle    c01009df <print_stackframe+0x25>
        eip = ((uint32_t*)ebp)[1];
        ebp = ((uint32_t*)ebp)[0];
        if(ebp == 0)
            break;
    }
}
c0100a80:	c9                   	leave  
c0100a81:	c3                   	ret    

c0100a82 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a82:	55                   	push   %ebp
c0100a83:	89 e5                	mov    %esp,%ebp
c0100a85:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8f:	eb 0c                	jmp    c0100a9d <parse+0x1b>
            *buf ++ = '\0';
c0100a91:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a94:	8d 50 01             	lea    0x1(%eax),%edx
c0100a97:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a9a:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa0:	0f b6 00             	movzbl (%eax),%eax
c0100aa3:	84 c0                	test   %al,%al
c0100aa5:	74 1d                	je     c0100ac4 <parse+0x42>
c0100aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aaa:	0f b6 00             	movzbl (%eax),%eax
c0100aad:	0f be c0             	movsbl %al,%eax
c0100ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab4:	c7 04 24 c0 61 10 c0 	movl   $0xc01061c0,(%esp)
c0100abb:	e8 5c 51 00 00       	call   c0105c1c <strchr>
c0100ac0:	85 c0                	test   %eax,%eax
c0100ac2:	75 cd                	jne    c0100a91 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac7:	0f b6 00             	movzbl (%eax),%eax
c0100aca:	84 c0                	test   %al,%al
c0100acc:	75 02                	jne    c0100ad0 <parse+0x4e>
            break;
c0100ace:	eb 67                	jmp    c0100b37 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad0:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad4:	75 14                	jne    c0100aea <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad6:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100add:	00 
c0100ade:	c7 04 24 c5 61 10 c0 	movl   $0xc01061c5,(%esp)
c0100ae5:	e8 52 f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aed:	8d 50 01             	lea    0x1(%eax),%edx
c0100af0:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100afa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afd:	01 c2                	add    %eax,%edx
c0100aff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b02:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b04:	eb 04                	jmp    c0100b0a <parse+0x88>
            buf ++;
c0100b06:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0d:	0f b6 00             	movzbl (%eax),%eax
c0100b10:	84 c0                	test   %al,%al
c0100b12:	74 1d                	je     c0100b31 <parse+0xaf>
c0100b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b17:	0f b6 00             	movzbl (%eax),%eax
c0100b1a:	0f be c0             	movsbl %al,%eax
c0100b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b21:	c7 04 24 c0 61 10 c0 	movl   $0xc01061c0,(%esp)
c0100b28:	e8 ef 50 00 00       	call   c0105c1c <strchr>
c0100b2d:	85 c0                	test   %eax,%eax
c0100b2f:	74 d5                	je     c0100b06 <parse+0x84>
            buf ++;
        }
    }
c0100b31:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b32:	e9 66 ff ff ff       	jmp    c0100a9d <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b3a:	c9                   	leave  
c0100b3b:	c3                   	ret    

c0100b3c <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3c:	55                   	push   %ebp
c0100b3d:	89 e5                	mov    %esp,%ebp
c0100b3f:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b42:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4c:	89 04 24             	mov    %eax,(%esp)
c0100b4f:	e8 2e ff ff ff       	call   c0100a82 <parse>
c0100b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b5b:	75 0a                	jne    c0100b67 <runcmd+0x2b>
        return 0;
c0100b5d:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b62:	e9 85 00 00 00       	jmp    c0100bec <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b6e:	eb 5c                	jmp    c0100bcc <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b70:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b76:	89 d0                	mov    %edx,%eax
c0100b78:	01 c0                	add    %eax,%eax
c0100b7a:	01 d0                	add    %edx,%eax
c0100b7c:	c1 e0 02             	shl    $0x2,%eax
c0100b7f:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b84:	8b 00                	mov    (%eax),%eax
c0100b86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b8a:	89 04 24             	mov    %eax,(%esp)
c0100b8d:	e8 eb 4f 00 00       	call   c0105b7d <strcmp>
c0100b92:	85 c0                	test   %eax,%eax
c0100b94:	75 32                	jne    c0100bc8 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b99:	89 d0                	mov    %edx,%eax
c0100b9b:	01 c0                	add    %eax,%eax
c0100b9d:	01 d0                	add    %edx,%eax
c0100b9f:	c1 e0 02             	shl    $0x2,%eax
c0100ba2:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ba7:	8b 40 08             	mov    0x8(%eax),%eax
c0100baa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bad:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb7:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bba:	83 c2 04             	add    $0x4,%edx
c0100bbd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc1:	89 0c 24             	mov    %ecx,(%esp)
c0100bc4:	ff d0                	call   *%eax
c0100bc6:	eb 24                	jmp    c0100bec <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcf:	83 f8 02             	cmp    $0x2,%eax
c0100bd2:	76 9c                	jbe    c0100b70 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bdb:	c7 04 24 e3 61 10 c0 	movl   $0xc01061e3,(%esp)
c0100be2:	e8 55 f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bec:	c9                   	leave  
c0100bed:	c3                   	ret    

c0100bee <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bee:	55                   	push   %ebp
c0100bef:	89 e5                	mov    %esp,%ebp
c0100bf1:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf4:	c7 04 24 fc 61 10 c0 	movl   $0xc01061fc,(%esp)
c0100bfb:	e8 3c f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c00:	c7 04 24 24 62 10 c0 	movl   $0xc0106224,(%esp)
c0100c07:	e8 30 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c10:	74 0b                	je     c0100c1d <kmonitor+0x2f>
        print_trapframe(tf);
c0100c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c15:	89 04 24             	mov    %eax,(%esp)
c0100c18:	e8 d6 0d 00 00       	call   c01019f3 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c1d:	c7 04 24 49 62 10 c0 	movl   $0xc0106249,(%esp)
c0100c24:	e8 0a f6 ff ff       	call   c0100233 <readline>
c0100c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c30:	74 18                	je     c0100c4a <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c3c:	89 04 24             	mov    %eax,(%esp)
c0100c3f:	e8 f8 fe ff ff       	call   c0100b3c <runcmd>
c0100c44:	85 c0                	test   %eax,%eax
c0100c46:	79 02                	jns    c0100c4a <kmonitor+0x5c>
                break;
c0100c48:	eb 02                	jmp    c0100c4c <kmonitor+0x5e>
            }
        }
    }
c0100c4a:	eb d1                	jmp    c0100c1d <kmonitor+0x2f>
}
c0100c4c:	c9                   	leave  
c0100c4d:	c3                   	ret    

c0100c4e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c4e:	55                   	push   %ebp
c0100c4f:	89 e5                	mov    %esp,%ebp
c0100c51:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c5b:	eb 3f                	jmp    c0100c9c <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c60:	89 d0                	mov    %edx,%eax
c0100c62:	01 c0                	add    %eax,%eax
c0100c64:	01 d0                	add    %edx,%eax
c0100c66:	c1 e0 02             	shl    $0x2,%eax
c0100c69:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c6e:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c74:	89 d0                	mov    %edx,%eax
c0100c76:	01 c0                	add    %eax,%eax
c0100c78:	01 d0                	add    %edx,%eax
c0100c7a:	c1 e0 02             	shl    $0x2,%eax
c0100c7d:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c82:	8b 00                	mov    (%eax),%eax
c0100c84:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8c:	c7 04 24 4d 62 10 c0 	movl   $0xc010624d,(%esp)
c0100c93:	e8 a4 f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c98:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c9f:	83 f8 02             	cmp    $0x2,%eax
c0100ca2:	76 b9                	jbe    c0100c5d <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca9:	c9                   	leave  
c0100caa:	c3                   	ret    

c0100cab <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cab:	55                   	push   %ebp
c0100cac:	89 e5                	mov    %esp,%ebp
c0100cae:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb1:	e8 ba fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbb:	c9                   	leave  
c0100cbc:	c3                   	ret    

c0100cbd <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cbd:	55                   	push   %ebp
c0100cbe:	89 e5                	mov    %esp,%ebp
c0100cc0:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc3:	e8 f2 fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccd:	c9                   	leave  
c0100cce:	c3                   	ret    

c0100ccf <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ccf:	55                   	push   %ebp
c0100cd0:	89 e5                	mov    %esp,%ebp
c0100cd2:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd5:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cda:	85 c0                	test   %eax,%eax
c0100cdc:	74 02                	je     c0100ce0 <__panic+0x11>
        goto panic_dead;
c0100cde:	eb 48                	jmp    c0100d28 <__panic+0x59>
    }
    is_panic = 1;
c0100ce0:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100ce7:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cea:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfe:	c7 04 24 56 62 10 c0 	movl   $0xc0106256,(%esp)
c0100d05:	e8 32 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d11:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d14:	89 04 24             	mov    %eax,(%esp)
c0100d17:	e8 ed f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d1c:	c7 04 24 72 62 10 c0 	movl   $0xc0106272,(%esp)
c0100d23:	e8 14 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d28:	e8 85 09 00 00       	call   c01016b2 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d34:	e8 b5 fe ff ff       	call   c0100bee <kmonitor>
    }
c0100d39:	eb f2                	jmp    c0100d2d <__panic+0x5e>

c0100d3b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d3b:	55                   	push   %ebp
c0100d3c:	89 e5                	mov    %esp,%ebp
c0100d3e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d41:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d4a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d55:	c7 04 24 74 62 10 c0 	movl   $0xc0106274,(%esp)
c0100d5c:	e8 db f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d68:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d6b:	89 04 24             	mov    %eax,(%esp)
c0100d6e:	e8 96 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d73:	c7 04 24 72 62 10 c0 	movl   $0xc0106272,(%esp)
c0100d7a:	e8 bd f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d7f:	c9                   	leave  
c0100d80:	c3                   	ret    

c0100d81 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d81:	55                   	push   %ebp
c0100d82:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d84:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d89:	5d                   	pop    %ebp
c0100d8a:	c3                   	ret    

c0100d8b <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d8b:	55                   	push   %ebp
c0100d8c:	89 e5                	mov    %esp,%ebp
c0100d8e:	83 ec 28             	sub    $0x28,%esp
c0100d91:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d97:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d9b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d9f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da3:	ee                   	out    %al,(%dx)
c0100da4:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100daa:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dae:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db6:	ee                   	out    %al,(%dx)
c0100db7:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dbd:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dc1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc9:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dca:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dd1:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd4:	c7 04 24 92 62 10 c0 	movl   $0xc0106292,(%esp)
c0100ddb:	e8 5c f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100de0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de7:	e8 24 09 00 00       	call   c0101710 <pic_enable>
}
c0100dec:	c9                   	leave  
c0100ded:	c3                   	ret    

c0100dee <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dee:	55                   	push   %ebp
c0100def:	89 e5                	mov    %esp,%ebp
c0100df1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df4:	9c                   	pushf  
c0100df5:	58                   	pop    %eax
c0100df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dfc:	25 00 02 00 00       	and    $0x200,%eax
c0100e01:	85 c0                	test   %eax,%eax
c0100e03:	74 0c                	je     c0100e11 <__intr_save+0x23>
        intr_disable();
c0100e05:	e8 a8 08 00 00       	call   c01016b2 <intr_disable>
        return 1;
c0100e0a:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e0f:	eb 05                	jmp    c0100e16 <__intr_save+0x28>
    }
    return 0;
c0100e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e16:	c9                   	leave  
c0100e17:	c3                   	ret    

c0100e18 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e18:	55                   	push   %ebp
c0100e19:	89 e5                	mov    %esp,%ebp
c0100e1b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e22:	74 05                	je     c0100e29 <__intr_restore+0x11>
        intr_enable();
c0100e24:	e8 83 08 00 00       	call   c01016ac <intr_enable>
    }
}
c0100e29:	c9                   	leave  
c0100e2a:	c3                   	ret    

c0100e2b <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e2b:	55                   	push   %ebp
c0100e2c:	89 e5                	mov    %esp,%ebp
c0100e2e:	83 ec 10             	sub    $0x10,%esp
c0100e31:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e37:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e3b:	89 c2                	mov    %eax,%edx
c0100e3d:	ec                   	in     (%dx),%al
c0100e3e:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e41:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e47:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e4b:	89 c2                	mov    %eax,%edx
c0100e4d:	ec                   	in     (%dx),%al
c0100e4e:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e51:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e57:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e5b:	89 c2                	mov    %eax,%edx
c0100e5d:	ec                   	in     (%dx),%al
c0100e5e:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e61:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e67:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e6b:	89 c2                	mov    %eax,%edx
c0100e6d:	ec                   	in     (%dx),%al
c0100e6e:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e71:	c9                   	leave  
c0100e72:	c3                   	ret    

c0100e73 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e73:	55                   	push   %ebp
c0100e74:	89 e5                	mov    %esp,%ebp
c0100e76:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e79:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e83:	0f b7 00             	movzwl (%eax),%eax
c0100e86:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e95:	0f b7 00             	movzwl (%eax),%eax
c0100e98:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e9c:	74 12                	je     c0100eb0 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e9e:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ea5:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100eac:	b4 03 
c0100eae:	eb 13                	jmp    c0100ec3 <cga_init+0x50>
    } else {
        *cp = was;
c0100eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eb7:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eba:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ec1:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec3:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100eca:	0f b7 c0             	movzwl %ax,%eax
c0100ecd:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ed1:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100edd:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ede:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ee5:	83 c0 01             	add    $0x1,%eax
c0100ee8:	0f b7 c0             	movzwl %ax,%eax
c0100eeb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eef:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef3:	89 c2                	mov    %eax,%edx
c0100ef5:	ec                   	in     (%dx),%al
c0100ef6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100efd:	0f b6 c0             	movzbl %al,%eax
c0100f00:	c1 e0 08             	shl    $0x8,%eax
c0100f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f06:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f0d:	0f b7 c0             	movzwl %ax,%eax
c0100f10:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f14:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f18:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f1c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f20:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f21:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f28:	83 c0 01             	add    $0x1,%eax
c0100f2b:	0f b7 c0             	movzwl %ax,%eax
c0100f2e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f32:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f36:	89 c2                	mov    %eax,%edx
c0100f38:	ec                   	in     (%dx),%al
c0100f39:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f3c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f40:	0f b6 c0             	movzbl %al,%eax
c0100f43:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f49:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f51:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f57:	c9                   	leave  
c0100f58:	c3                   	ret    

c0100f59 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f59:	55                   	push   %ebp
c0100f5a:	89 e5                	mov    %esp,%ebp
c0100f5c:	83 ec 48             	sub    $0x48,%esp
c0100f5f:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f65:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f69:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f6d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f71:	ee                   	out    %al,(%dx)
c0100f72:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f78:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f7c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f80:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f84:	ee                   	out    %al,(%dx)
c0100f85:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f8b:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f8f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f93:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f97:	ee                   	out    %al,(%dx)
c0100f98:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f9e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fa2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100faa:	ee                   	out    %al,(%dx)
c0100fab:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fb1:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fb5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fbd:	ee                   	out    %al,(%dx)
c0100fbe:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fc4:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fc8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fcc:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd0:	ee                   	out    %al,(%dx)
c0100fd1:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd7:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fdb:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fdf:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe3:	ee                   	out    %al,(%dx)
c0100fe4:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fea:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fee:	89 c2                	mov    %eax,%edx
c0100ff0:	ec                   	in     (%dx),%al
c0100ff1:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ff4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ff8:	3c ff                	cmp    $0xff,%al
c0100ffa:	0f 95 c0             	setne  %al
c0100ffd:	0f b6 c0             	movzbl %al,%eax
c0101000:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0101005:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010100b:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010100f:	89 c2                	mov    %eax,%edx
c0101011:	ec                   	in     (%dx),%al
c0101012:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101015:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010101b:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010101f:	89 c2                	mov    %eax,%edx
c0101021:	ec                   	in     (%dx),%al
c0101022:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101025:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010102a:	85 c0                	test   %eax,%eax
c010102c:	74 0c                	je     c010103a <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010102e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101035:	e8 d6 06 00 00       	call   c0101710 <pic_enable>
    }
}
c010103a:	c9                   	leave  
c010103b:	c3                   	ret    

c010103c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010103c:	55                   	push   %ebp
c010103d:	89 e5                	mov    %esp,%ebp
c010103f:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101042:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101049:	eb 09                	jmp    c0101054 <lpt_putc_sub+0x18>
        delay();
c010104b:	e8 db fd ff ff       	call   c0100e2b <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101050:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101054:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010105a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010105e:	89 c2                	mov    %eax,%edx
c0101060:	ec                   	in     (%dx),%al
c0101061:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101064:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101068:	84 c0                	test   %al,%al
c010106a:	78 09                	js     c0101075 <lpt_putc_sub+0x39>
c010106c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101073:	7e d6                	jle    c010104b <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101075:	8b 45 08             	mov    0x8(%ebp),%eax
c0101078:	0f b6 c0             	movzbl %al,%eax
c010107b:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101081:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101084:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101088:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010108c:	ee                   	out    %al,(%dx)
c010108d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101093:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101097:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010109b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010109f:	ee                   	out    %al,(%dx)
c01010a0:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010a6:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010aa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010ae:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010b2:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b3:	c9                   	leave  
c01010b4:	c3                   	ret    

c01010b5 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b5:	55                   	push   %ebp
c01010b6:	89 e5                	mov    %esp,%ebp
c01010b8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010bb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010bf:	74 0d                	je     c01010ce <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c4:	89 04 24             	mov    %eax,(%esp)
c01010c7:	e8 70 ff ff ff       	call   c010103c <lpt_putc_sub>
c01010cc:	eb 24                	jmp    c01010f2 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010ce:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d5:	e8 62 ff ff ff       	call   c010103c <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010da:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010e1:	e8 56 ff ff ff       	call   c010103c <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010ed:	e8 4a ff ff ff       	call   c010103c <lpt_putc_sub>
    }
}
c01010f2:	c9                   	leave  
c01010f3:	c3                   	ret    

c01010f4 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f4:	55                   	push   %ebp
c01010f5:	89 e5                	mov    %esp,%ebp
c01010f7:	53                   	push   %ebx
c01010f8:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fe:	b0 00                	mov    $0x0,%al
c0101100:	85 c0                	test   %eax,%eax
c0101102:	75 07                	jne    c010110b <cga_putc+0x17>
        c |= 0x0700;
c0101104:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010110b:	8b 45 08             	mov    0x8(%ebp),%eax
c010110e:	0f b6 c0             	movzbl %al,%eax
c0101111:	83 f8 0a             	cmp    $0xa,%eax
c0101114:	74 4c                	je     c0101162 <cga_putc+0x6e>
c0101116:	83 f8 0d             	cmp    $0xd,%eax
c0101119:	74 57                	je     c0101172 <cga_putc+0x7e>
c010111b:	83 f8 08             	cmp    $0x8,%eax
c010111e:	0f 85 88 00 00 00    	jne    c01011ac <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101124:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010112b:	66 85 c0             	test   %ax,%ax
c010112e:	74 30                	je     c0101160 <cga_putc+0x6c>
            crt_pos --;
c0101130:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101137:	83 e8 01             	sub    $0x1,%eax
c010113a:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101140:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101145:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c010114c:	0f b7 d2             	movzwl %dx,%edx
c010114f:	01 d2                	add    %edx,%edx
c0101151:	01 c2                	add    %eax,%edx
c0101153:	8b 45 08             	mov    0x8(%ebp),%eax
c0101156:	b0 00                	mov    $0x0,%al
c0101158:	83 c8 20             	or     $0x20,%eax
c010115b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010115e:	eb 72                	jmp    c01011d2 <cga_putc+0xde>
c0101160:	eb 70                	jmp    c01011d2 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101162:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101169:	83 c0 50             	add    $0x50,%eax
c010116c:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101172:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101179:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101180:	0f b7 c1             	movzwl %cx,%eax
c0101183:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101189:	c1 e8 10             	shr    $0x10,%eax
c010118c:	89 c2                	mov    %eax,%edx
c010118e:	66 c1 ea 06          	shr    $0x6,%dx
c0101192:	89 d0                	mov    %edx,%eax
c0101194:	c1 e0 02             	shl    $0x2,%eax
c0101197:	01 d0                	add    %edx,%eax
c0101199:	c1 e0 04             	shl    $0x4,%eax
c010119c:	29 c1                	sub    %eax,%ecx
c010119e:	89 ca                	mov    %ecx,%edx
c01011a0:	89 d8                	mov    %ebx,%eax
c01011a2:	29 d0                	sub    %edx,%eax
c01011a4:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011aa:	eb 26                	jmp    c01011d2 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011ac:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011b2:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b9:	8d 50 01             	lea    0x1(%eax),%edx
c01011bc:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011c3:	0f b7 c0             	movzwl %ax,%eax
c01011c6:	01 c0                	add    %eax,%eax
c01011c8:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ce:	66 89 02             	mov    %ax,(%edx)
        break;
c01011d1:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d2:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011d9:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011dd:	76 5b                	jbe    c010123a <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011df:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011ea:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011ef:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f6:	00 
c01011f7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011fb:	89 04 24             	mov    %eax,(%esp)
c01011fe:	e8 17 4c 00 00       	call   c0105e1a <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101203:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010120a:	eb 15                	jmp    c0101221 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010120c:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101211:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101214:	01 d2                	add    %edx,%edx
c0101216:	01 d0                	add    %edx,%eax
c0101218:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010121d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101221:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101228:	7e e2                	jle    c010120c <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010122a:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101231:	83 e8 50             	sub    $0x50,%eax
c0101234:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010123a:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101241:	0f b7 c0             	movzwl %ax,%eax
c0101244:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101248:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010124c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101250:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101254:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101255:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010125c:	66 c1 e8 08          	shr    $0x8,%ax
c0101260:	0f b6 c0             	movzbl %al,%eax
c0101263:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010126a:	83 c2 01             	add    $0x1,%edx
c010126d:	0f b7 d2             	movzwl %dx,%edx
c0101270:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101274:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101277:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010127b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010127f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101280:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101287:	0f b7 c0             	movzwl %ax,%eax
c010128a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010128e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101292:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101296:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010129a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010129b:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01012a2:	0f b6 c0             	movzbl %al,%eax
c01012a5:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012ac:	83 c2 01             	add    $0x1,%edx
c01012af:	0f b7 d2             	movzwl %dx,%edx
c01012b2:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012b6:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012bd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c1:	ee                   	out    %al,(%dx)
}
c01012c2:	83 c4 34             	add    $0x34,%esp
c01012c5:	5b                   	pop    %ebx
c01012c6:	5d                   	pop    %ebp
c01012c7:	c3                   	ret    

c01012c8 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c8:	55                   	push   %ebp
c01012c9:	89 e5                	mov    %esp,%ebp
c01012cb:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d5:	eb 09                	jmp    c01012e0 <serial_putc_sub+0x18>
        delay();
c01012d7:	e8 4f fb ff ff       	call   c0100e2b <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e0:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012ea:	89 c2                	mov    %eax,%edx
c01012ec:	ec                   	in     (%dx),%al
c01012ed:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f4:	0f b6 c0             	movzbl %al,%eax
c01012f7:	83 e0 20             	and    $0x20,%eax
c01012fa:	85 c0                	test   %eax,%eax
c01012fc:	75 09                	jne    c0101307 <serial_putc_sub+0x3f>
c01012fe:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101305:	7e d0                	jle    c01012d7 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101307:	8b 45 08             	mov    0x8(%ebp),%eax
c010130a:	0f b6 c0             	movzbl %al,%eax
c010130d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101313:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101316:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010131a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010131e:	ee                   	out    %al,(%dx)
}
c010131f:	c9                   	leave  
c0101320:	c3                   	ret    

c0101321 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101321:	55                   	push   %ebp
c0101322:	89 e5                	mov    %esp,%ebp
c0101324:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101327:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010132b:	74 0d                	je     c010133a <serial_putc+0x19>
        serial_putc_sub(c);
c010132d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101330:	89 04 24             	mov    %eax,(%esp)
c0101333:	e8 90 ff ff ff       	call   c01012c8 <serial_putc_sub>
c0101338:	eb 24                	jmp    c010135e <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010133a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101341:	e8 82 ff ff ff       	call   c01012c8 <serial_putc_sub>
        serial_putc_sub(' ');
c0101346:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010134d:	e8 76 ff ff ff       	call   c01012c8 <serial_putc_sub>
        serial_putc_sub('\b');
c0101352:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101359:	e8 6a ff ff ff       	call   c01012c8 <serial_putc_sub>
    }
}
c010135e:	c9                   	leave  
c010135f:	c3                   	ret    

c0101360 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101360:	55                   	push   %ebp
c0101361:	89 e5                	mov    %esp,%ebp
c0101363:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101366:	eb 33                	jmp    c010139b <cons_intr+0x3b>
        if (c != 0) {
c0101368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010136c:	74 2d                	je     c010139b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010136e:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101373:	8d 50 01             	lea    0x1(%eax),%edx
c0101376:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c010137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010137f:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101385:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010138a:	3d 00 02 00 00       	cmp    $0x200,%eax
c010138f:	75 0a                	jne    c010139b <cons_intr+0x3b>
                cons.wpos = 0;
c0101391:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101398:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c010139b:	8b 45 08             	mov    0x8(%ebp),%eax
c010139e:	ff d0                	call   *%eax
c01013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a7:	75 bf                	jne    c0101368 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a9:	c9                   	leave  
c01013aa:	c3                   	ret    

c01013ab <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013ab:	55                   	push   %ebp
c01013ac:	89 e5                	mov    %esp,%ebp
c01013ae:	83 ec 10             	sub    $0x10,%esp
c01013b1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013bb:	89 c2                	mov    %eax,%edx
c01013bd:	ec                   	in     (%dx),%al
c01013be:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013c1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c5:	0f b6 c0             	movzbl %al,%eax
c01013c8:	83 e0 01             	and    $0x1,%eax
c01013cb:	85 c0                	test   %eax,%eax
c01013cd:	75 07                	jne    c01013d6 <serial_proc_data+0x2b>
        return -1;
c01013cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d4:	eb 2a                	jmp    c0101400 <serial_proc_data+0x55>
c01013d6:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013dc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e0:	89 c2                	mov    %eax,%edx
c01013e2:	ec                   	in     (%dx),%al
c01013e3:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013ea:	0f b6 c0             	movzbl %al,%eax
c01013ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f0:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f4:	75 07                	jne    c01013fd <serial_proc_data+0x52>
        c = '\b';
c01013f6:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101400:	c9                   	leave  
c0101401:	c3                   	ret    

c0101402 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101402:	55                   	push   %ebp
c0101403:	89 e5                	mov    %esp,%ebp
c0101405:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101408:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010140d:	85 c0                	test   %eax,%eax
c010140f:	74 0c                	je     c010141d <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101411:	c7 04 24 ab 13 10 c0 	movl   $0xc01013ab,(%esp)
c0101418:	e8 43 ff ff ff       	call   c0101360 <cons_intr>
    }
}
c010141d:	c9                   	leave  
c010141e:	c3                   	ret    

c010141f <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010141f:	55                   	push   %ebp
c0101420:	89 e5                	mov    %esp,%ebp
c0101422:	83 ec 38             	sub    $0x38,%esp
c0101425:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010142b:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010142f:	89 c2                	mov    %eax,%edx
c0101431:	ec                   	in     (%dx),%al
c0101432:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101435:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101439:	0f b6 c0             	movzbl %al,%eax
c010143c:	83 e0 01             	and    $0x1,%eax
c010143f:	85 c0                	test   %eax,%eax
c0101441:	75 0a                	jne    c010144d <kbd_proc_data+0x2e>
        return -1;
c0101443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101448:	e9 59 01 00 00       	jmp    c01015a6 <kbd_proc_data+0x187>
c010144d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101453:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101457:	89 c2                	mov    %eax,%edx
c0101459:	ec                   	in     (%dx),%al
c010145a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010145d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101461:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101464:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101468:	75 17                	jne    c0101481 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010146a:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010146f:	83 c8 40             	or     $0x40,%eax
c0101472:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101477:	b8 00 00 00 00       	mov    $0x0,%eax
c010147c:	e9 25 01 00 00       	jmp    c01015a6 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101485:	84 c0                	test   %al,%al
c0101487:	79 47                	jns    c01014d0 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101489:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010148e:	83 e0 40             	and    $0x40,%eax
c0101491:	85 c0                	test   %eax,%eax
c0101493:	75 09                	jne    c010149e <kbd_proc_data+0x7f>
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	83 e0 7f             	and    $0x7f,%eax
c010149c:	eb 04                	jmp    c01014a2 <kbd_proc_data+0x83>
c010149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a2:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a9:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014b0:	83 c8 40             	or     $0x40,%eax
c01014b3:	0f b6 c0             	movzbl %al,%eax
c01014b6:	f7 d0                	not    %eax
c01014b8:	89 c2                	mov    %eax,%edx
c01014ba:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014bf:	21 d0                	and    %edx,%eax
c01014c1:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014c6:	b8 00 00 00 00       	mov    $0x0,%eax
c01014cb:	e9 d6 00 00 00       	jmp    c01015a6 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d0:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d5:	83 e0 40             	and    $0x40,%eax
c01014d8:	85 c0                	test   %eax,%eax
c01014da:	74 11                	je     c01014ed <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014dc:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e0:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e5:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e8:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f1:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014f8:	0f b6 d0             	movzbl %al,%edx
c01014fb:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101500:	09 d0                	or     %edx,%eax
c0101502:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010150b:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101512:	0f b6 d0             	movzbl %al,%edx
c0101515:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010151a:	31 d0                	xor    %edx,%eax
c010151c:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101521:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101526:	83 e0 03             	and    $0x3,%eax
c0101529:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101530:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101534:	01 d0                	add    %edx,%eax
c0101536:	0f b6 00             	movzbl (%eax),%eax
c0101539:	0f b6 c0             	movzbl %al,%eax
c010153c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010153f:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101544:	83 e0 08             	and    $0x8,%eax
c0101547:	85 c0                	test   %eax,%eax
c0101549:	74 22                	je     c010156d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010154b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010154f:	7e 0c                	jle    c010155d <kbd_proc_data+0x13e>
c0101551:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101555:	7f 06                	jg     c010155d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101557:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010155b:	eb 10                	jmp    c010156d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010155d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101561:	7e 0a                	jle    c010156d <kbd_proc_data+0x14e>
c0101563:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101567:	7f 04                	jg     c010156d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101569:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010156d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101572:	f7 d0                	not    %eax
c0101574:	83 e0 06             	and    $0x6,%eax
c0101577:	85 c0                	test   %eax,%eax
c0101579:	75 28                	jne    c01015a3 <kbd_proc_data+0x184>
c010157b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101582:	75 1f                	jne    c01015a3 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101584:	c7 04 24 ad 62 10 c0 	movl   $0xc01062ad,(%esp)
c010158b:	e8 ac ed ff ff       	call   c010033c <cprintf>
c0101590:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101596:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010159a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010159e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a2:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a6:	c9                   	leave  
c01015a7:	c3                   	ret    

c01015a8 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015a8:	55                   	push   %ebp
c01015a9:	89 e5                	mov    %esp,%ebp
c01015ab:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015ae:	c7 04 24 1f 14 10 c0 	movl   $0xc010141f,(%esp)
c01015b5:	e8 a6 fd ff ff       	call   c0101360 <cons_intr>
}
c01015ba:	c9                   	leave  
c01015bb:	c3                   	ret    

c01015bc <kbd_init>:

static void
kbd_init(void) {
c01015bc:	55                   	push   %ebp
c01015bd:	89 e5                	mov    %esp,%ebp
c01015bf:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015c2:	e8 e1 ff ff ff       	call   c01015a8 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015ce:	e8 3d 01 00 00       	call   c0101710 <pic_enable>
}
c01015d3:	c9                   	leave  
c01015d4:	c3                   	ret    

c01015d5 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d5:	55                   	push   %ebp
c01015d6:	89 e5                	mov    %esp,%ebp
c01015d8:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015db:	e8 93 f8 ff ff       	call   c0100e73 <cga_init>
    serial_init();
c01015e0:	e8 74 f9 ff ff       	call   c0100f59 <serial_init>
    kbd_init();
c01015e5:	e8 d2 ff ff ff       	call   c01015bc <kbd_init>
    if (!serial_exists) {
c01015ea:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015ef:	85 c0                	test   %eax,%eax
c01015f1:	75 0c                	jne    c01015ff <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f3:	c7 04 24 b9 62 10 c0 	movl   $0xc01062b9,(%esp)
c01015fa:	e8 3d ed ff ff       	call   c010033c <cprintf>
    }
}
c01015ff:	c9                   	leave  
c0101600:	c3                   	ret    

c0101601 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101601:	55                   	push   %ebp
c0101602:	89 e5                	mov    %esp,%ebp
c0101604:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101607:	e8 e2 f7 ff ff       	call   c0100dee <__intr_save>
c010160c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010160f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101612:	89 04 24             	mov    %eax,(%esp)
c0101615:	e8 9b fa ff ff       	call   c01010b5 <lpt_putc>
        cga_putc(c);
c010161a:	8b 45 08             	mov    0x8(%ebp),%eax
c010161d:	89 04 24             	mov    %eax,(%esp)
c0101620:	e8 cf fa ff ff       	call   c01010f4 <cga_putc>
        serial_putc(c);
c0101625:	8b 45 08             	mov    0x8(%ebp),%eax
c0101628:	89 04 24             	mov    %eax,(%esp)
c010162b:	e8 f1 fc ff ff       	call   c0101321 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101633:	89 04 24             	mov    %eax,(%esp)
c0101636:	e8 dd f7 ff ff       	call   c0100e18 <__intr_restore>
}
c010163b:	c9                   	leave  
c010163c:	c3                   	ret    

c010163d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010163d:	55                   	push   %ebp
c010163e:	89 e5                	mov    %esp,%ebp
c0101640:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101643:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010164a:	e8 9f f7 ff ff       	call   c0100dee <__intr_save>
c010164f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101652:	e8 ab fd ff ff       	call   c0101402 <serial_intr>
        kbd_intr();
c0101657:	e8 4c ff ff ff       	call   c01015a8 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010165c:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101662:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101667:	39 c2                	cmp    %eax,%edx
c0101669:	74 31                	je     c010169c <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010166b:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101670:	8d 50 01             	lea    0x1(%eax),%edx
c0101673:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101679:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101680:	0f b6 c0             	movzbl %al,%eax
c0101683:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101686:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010168b:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101690:	75 0a                	jne    c010169c <cons_getc+0x5f>
                cons.rpos = 0;
c0101692:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101699:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010169f:	89 04 24             	mov    %eax,(%esp)
c01016a2:	e8 71 f7 ff ff       	call   c0100e18 <__intr_restore>
    return c;
c01016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016aa:	c9                   	leave  
c01016ab:	c3                   	ret    

c01016ac <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016ac:	55                   	push   %ebp
c01016ad:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016af:	fb                   	sti    
    sti();
}
c01016b0:	5d                   	pop    %ebp
c01016b1:	c3                   	ret    

c01016b2 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016b2:	55                   	push   %ebp
c01016b3:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016b5:	fa                   	cli    
    cli();
}
c01016b6:	5d                   	pop    %ebp
c01016b7:	c3                   	ret    

c01016b8 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016b8:	55                   	push   %ebp
c01016b9:	89 e5                	mov    %esp,%ebp
c01016bb:	83 ec 14             	sub    $0x14,%esp
c01016be:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016c5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c9:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016cf:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016d4:	85 c0                	test   %eax,%eax
c01016d6:	74 36                	je     c010170e <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016d8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016dc:	0f b6 c0             	movzbl %al,%eax
c01016df:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016e5:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016e8:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016ec:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016f0:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016f1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f5:	66 c1 e8 08          	shr    $0x8,%ax
c01016f9:	0f b6 c0             	movzbl %al,%eax
c01016fc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101702:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101705:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101709:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010170d:	ee                   	out    %al,(%dx)
    }
}
c010170e:	c9                   	leave  
c010170f:	c3                   	ret    

c0101710 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101710:	55                   	push   %ebp
c0101711:	89 e5                	mov    %esp,%ebp
c0101713:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101716:	8b 45 08             	mov    0x8(%ebp),%eax
c0101719:	ba 01 00 00 00       	mov    $0x1,%edx
c010171e:	89 c1                	mov    %eax,%ecx
c0101720:	d3 e2                	shl    %cl,%edx
c0101722:	89 d0                	mov    %edx,%eax
c0101724:	f7 d0                	not    %eax
c0101726:	89 c2                	mov    %eax,%edx
c0101728:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010172f:	21 d0                	and    %edx,%eax
c0101731:	0f b7 c0             	movzwl %ax,%eax
c0101734:	89 04 24             	mov    %eax,(%esp)
c0101737:	e8 7c ff ff ff       	call   c01016b8 <pic_setmask>
}
c010173c:	c9                   	leave  
c010173d:	c3                   	ret    

c010173e <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010173e:	55                   	push   %ebp
c010173f:	89 e5                	mov    %esp,%ebp
c0101741:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101744:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c010174b:	00 00 00 
c010174e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101754:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101758:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010175c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101760:	ee                   	out    %al,(%dx)
c0101761:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101767:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c010176b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101773:	ee                   	out    %al,(%dx)
c0101774:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010177a:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010177e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101782:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101786:	ee                   	out    %al,(%dx)
c0101787:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010178d:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101791:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101795:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101799:	ee                   	out    %al,(%dx)
c010179a:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017a0:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017a4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017a8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017ac:	ee                   	out    %al,(%dx)
c01017ad:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017b3:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017bb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017bf:	ee                   	out    %al,(%dx)
c01017c0:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c6:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017ca:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017ce:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017d2:	ee                   	out    %al,(%dx)
c01017d3:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d9:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017dd:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017e1:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e5:	ee                   	out    %al,(%dx)
c01017e6:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017ec:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017f0:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f4:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017f8:	ee                   	out    %al,(%dx)
c01017f9:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017ff:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101803:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101807:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010180b:	ee                   	out    %al,(%dx)
c010180c:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101812:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101816:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010181a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010181e:	ee                   	out    %al,(%dx)
c010181f:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101825:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101829:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010182d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101831:	ee                   	out    %al,(%dx)
c0101832:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101838:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010183c:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101840:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101844:	ee                   	out    %al,(%dx)
c0101845:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010184b:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010184f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101853:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101857:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101858:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010185f:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101863:	74 12                	je     c0101877 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101865:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010186c:	0f b7 c0             	movzwl %ax,%eax
c010186f:	89 04 24             	mov    %eax,(%esp)
c0101872:	e8 41 fe ff ff       	call   c01016b8 <pic_setmask>
    }
}
c0101877:	c9                   	leave  
c0101878:	c3                   	ret    

c0101879 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101879:	55                   	push   %ebp
c010187a:	89 e5                	mov    %esp,%ebp
c010187c:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010187f:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101886:	00 
c0101887:	c7 04 24 e0 62 10 c0 	movl   $0xc01062e0,(%esp)
c010188e:	e8 a9 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101893:	c7 04 24 ea 62 10 c0 	movl   $0xc01062ea,(%esp)
c010189a:	e8 9d ea ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c010189f:	c7 44 24 08 f8 62 10 	movl   $0xc01062f8,0x8(%esp)
c01018a6:	c0 
c01018a7:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018ae:	00 
c01018af:	c7 04 24 0e 63 10 c0 	movl   $0xc010630e,(%esp)
c01018b6:	e8 14 f4 ff ff       	call   c0100ccf <__panic>

c01018bb <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018bb:	55                   	push   %ebp
c01018bc:	89 e5                	mov    %esp,%ebp
c01018be:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for(i = 0 ; i < 256 ; i ++)
c01018c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018c8:	e9 c3 00 00 00       	jmp    c0101990 <idt_init+0xd5>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d0:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018d7:	89 c2                	mov    %eax,%edx
c01018d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018dc:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018e3:	c0 
c01018e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e7:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018ee:	c0 08 00 
c01018f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f4:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018fb:	c0 
c01018fc:	83 e2 e0             	and    $0xffffffe0,%edx
c01018ff:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101906:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101909:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101910:	c0 
c0101911:	83 e2 1f             	and    $0x1f,%edx
c0101914:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c010191b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191e:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101925:	c0 
c0101926:	83 e2 f0             	and    $0xfffffff0,%edx
c0101929:	83 ca 0e             	or     $0xe,%edx
c010192c:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101933:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101936:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010193d:	c0 
c010193e:	83 e2 ef             	and    $0xffffffef,%edx
c0101941:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101948:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194b:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101952:	c0 
c0101953:	83 e2 9f             	and    $0xffffff9f,%edx
c0101956:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010195d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101960:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101967:	c0 
c0101968:	83 ca 80             	or     $0xffffff80,%edx
c010196b:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101972:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101975:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010197c:	c1 e8 10             	shr    $0x10,%eax
c010197f:	89 c2                	mov    %eax,%edx
c0101981:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101984:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c010198b:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for(i = 0 ; i < 256 ; i ++)
c010198c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101990:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101997:	0f 8e 30 ff ff ff    	jle    c01018cd <idt_init+0x12>
c010199d:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019a7:	0f 01 18             	lidtl  (%eax)
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
c01019aa:	c9                   	leave  
c01019ab:	c3                   	ret    

c01019ac <trapname>:

static const char *
trapname(int trapno) {
c01019ac:	55                   	push   %ebp
c01019ad:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019af:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b2:	83 f8 13             	cmp    $0x13,%eax
c01019b5:	77 0c                	ja     c01019c3 <trapname+0x17>
        return excnames[trapno];
c01019b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ba:	8b 04 85 60 66 10 c0 	mov    -0x3fef99a0(,%eax,4),%eax
c01019c1:	eb 18                	jmp    c01019db <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019c3:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019c7:	7e 0d                	jle    c01019d6 <trapname+0x2a>
c01019c9:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019cd:	7f 07                	jg     c01019d6 <trapname+0x2a>
        return "Hardware Interrupt";
c01019cf:	b8 1f 63 10 c0       	mov    $0xc010631f,%eax
c01019d4:	eb 05                	jmp    c01019db <trapname+0x2f>
    }
    return "(unknown trap)";
c01019d6:	b8 32 63 10 c0       	mov    $0xc0106332,%eax
}
c01019db:	5d                   	pop    %ebp
c01019dc:	c3                   	ret    

c01019dd <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019dd:	55                   	push   %ebp
c01019de:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01019e3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019e7:	66 83 f8 08          	cmp    $0x8,%ax
c01019eb:	0f 94 c0             	sete   %al
c01019ee:	0f b6 c0             	movzbl %al,%eax
}
c01019f1:	5d                   	pop    %ebp
c01019f2:	c3                   	ret    

c01019f3 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01019f3:	55                   	push   %ebp
c01019f4:	89 e5                	mov    %esp,%ebp
c01019f6:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01019f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01019fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a00:	c7 04 24 73 63 10 c0 	movl   $0xc0106373,(%esp)
c0101a07:	e8 30 e9 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a0f:	89 04 24             	mov    %eax,(%esp)
c0101a12:	e8 a1 01 00 00       	call   c0101bb8 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a1a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a1e:	0f b7 c0             	movzwl %ax,%eax
c0101a21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a25:	c7 04 24 84 63 10 c0 	movl   $0xc0106384,(%esp)
c0101a2c:	e8 0b e9 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a31:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a34:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a38:	0f b7 c0             	movzwl %ax,%eax
c0101a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a3f:	c7 04 24 97 63 10 c0 	movl   $0xc0106397,(%esp)
c0101a46:	e8 f1 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4e:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a52:	0f b7 c0             	movzwl %ax,%eax
c0101a55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a59:	c7 04 24 aa 63 10 c0 	movl   $0xc01063aa,(%esp)
c0101a60:	e8 d7 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a65:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a68:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a6c:	0f b7 c0             	movzwl %ax,%eax
c0101a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a73:	c7 04 24 bd 63 10 c0 	movl   $0xc01063bd,(%esp)
c0101a7a:	e8 bd e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a82:	8b 40 30             	mov    0x30(%eax),%eax
c0101a85:	89 04 24             	mov    %eax,(%esp)
c0101a88:	e8 1f ff ff ff       	call   c01019ac <trapname>
c0101a8d:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a90:	8b 52 30             	mov    0x30(%edx),%edx
c0101a93:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101a97:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a9b:	c7 04 24 d0 63 10 c0 	movl   $0xc01063d0,(%esp)
c0101aa2:	e8 95 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aaa:	8b 40 34             	mov    0x34(%eax),%eax
c0101aad:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab1:	c7 04 24 e2 63 10 c0 	movl   $0xc01063e2,(%esp)
c0101ab8:	e8 7f e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101abd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac0:	8b 40 38             	mov    0x38(%eax),%eax
c0101ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac7:	c7 04 24 f1 63 10 c0 	movl   $0xc01063f1,(%esp)
c0101ace:	e8 69 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ada:	0f b7 c0             	movzwl %ax,%eax
c0101add:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae1:	c7 04 24 00 64 10 c0 	movl   $0xc0106400,(%esp)
c0101ae8:	e8 4f e8 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101aed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af0:	8b 40 40             	mov    0x40(%eax),%eax
c0101af3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af7:	c7 04 24 13 64 10 c0 	movl   $0xc0106413,(%esp)
c0101afe:	e8 39 e8 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b0a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b11:	eb 3e                	jmp    c0101b51 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b13:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b16:	8b 50 40             	mov    0x40(%eax),%edx
c0101b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b1c:	21 d0                	and    %edx,%eax
c0101b1e:	85 c0                	test   %eax,%eax
c0101b20:	74 28                	je     c0101b4a <print_trapframe+0x157>
c0101b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b25:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b2c:	85 c0                	test   %eax,%eax
c0101b2e:	74 1a                	je     c0101b4a <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b33:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b3e:	c7 04 24 22 64 10 c0 	movl   $0xc0106422,(%esp)
c0101b45:	e8 f2 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b4e:	d1 65 f0             	shll   -0x10(%ebp)
c0101b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b54:	83 f8 17             	cmp    $0x17,%eax
c0101b57:	76 ba                	jbe    c0101b13 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5c:	8b 40 40             	mov    0x40(%eax),%eax
c0101b5f:	25 00 30 00 00       	and    $0x3000,%eax
c0101b64:	c1 e8 0c             	shr    $0xc,%eax
c0101b67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b6b:	c7 04 24 26 64 10 c0 	movl   $0xc0106426,(%esp)
c0101b72:	e8 c5 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b7a:	89 04 24             	mov    %eax,(%esp)
c0101b7d:	e8 5b fe ff ff       	call   c01019dd <trap_in_kernel>
c0101b82:	85 c0                	test   %eax,%eax
c0101b84:	75 30                	jne    c0101bb6 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b89:	8b 40 44             	mov    0x44(%eax),%eax
c0101b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b90:	c7 04 24 2f 64 10 c0 	movl   $0xc010642f,(%esp)
c0101b97:	e8 a0 e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101b9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9f:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101ba3:	0f b7 c0             	movzwl %ax,%eax
c0101ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101baa:	c7 04 24 3e 64 10 c0 	movl   $0xc010643e,(%esp)
c0101bb1:	e8 86 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101bb6:	c9                   	leave  
c0101bb7:	c3                   	ret    

c0101bb8 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101bb8:	55                   	push   %ebp
c0101bb9:	89 e5                	mov    %esp,%ebp
c0101bbb:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc1:	8b 00                	mov    (%eax),%eax
c0101bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc7:	c7 04 24 51 64 10 c0 	movl   $0xc0106451,(%esp)
c0101bce:	e8 69 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101bd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd6:	8b 40 04             	mov    0x4(%eax),%eax
c0101bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdd:	c7 04 24 60 64 10 c0 	movl   $0xc0106460,(%esp)
c0101be4:	e8 53 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101be9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bec:	8b 40 08             	mov    0x8(%eax),%eax
c0101bef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf3:	c7 04 24 6f 64 10 c0 	movl   $0xc010646f,(%esp)
c0101bfa:	e8 3d e7 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101bff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c02:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c05:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c09:	c7 04 24 7e 64 10 c0 	movl   $0xc010647e,(%esp)
c0101c10:	e8 27 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c18:	8b 40 10             	mov    0x10(%eax),%eax
c0101c1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c1f:	c7 04 24 8d 64 10 c0 	movl   $0xc010648d,(%esp)
c0101c26:	e8 11 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2e:	8b 40 14             	mov    0x14(%eax),%eax
c0101c31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c35:	c7 04 24 9c 64 10 c0 	movl   $0xc010649c,(%esp)
c0101c3c:	e8 fb e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c44:	8b 40 18             	mov    0x18(%eax),%eax
c0101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c4b:	c7 04 24 ab 64 10 c0 	movl   $0xc01064ab,(%esp)
c0101c52:	e8 e5 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c57:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5a:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c61:	c7 04 24 ba 64 10 c0 	movl   $0xc01064ba,(%esp)
c0101c68:	e8 cf e6 ff ff       	call   c010033c <cprintf>
}
c0101c6d:	c9                   	leave  
c0101c6e:	c3                   	ret    

c0101c6f <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c6f:	55                   	push   %ebp
c0101c70:	89 e5                	mov    %esp,%ebp
c0101c72:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c78:	8b 40 30             	mov    0x30(%eax),%eax
c0101c7b:	83 f8 2f             	cmp    $0x2f,%eax
c0101c7e:	77 1d                	ja     c0101c9d <trap_dispatch+0x2e>
c0101c80:	83 f8 2e             	cmp    $0x2e,%eax
c0101c83:	0f 83 f2 00 00 00    	jae    c0101d7b <trap_dispatch+0x10c>
c0101c89:	83 f8 21             	cmp    $0x21,%eax
c0101c8c:	74 73                	je     c0101d01 <trap_dispatch+0x92>
c0101c8e:	83 f8 24             	cmp    $0x24,%eax
c0101c91:	74 48                	je     c0101cdb <trap_dispatch+0x6c>
c0101c93:	83 f8 20             	cmp    $0x20,%eax
c0101c96:	74 13                	je     c0101cab <trap_dispatch+0x3c>
c0101c98:	e9 a6 00 00 00       	jmp    c0101d43 <trap_dispatch+0xd4>
c0101c9d:	83 e8 78             	sub    $0x78,%eax
c0101ca0:	83 f8 01             	cmp    $0x1,%eax
c0101ca3:	0f 87 9a 00 00 00    	ja     c0101d43 <trap_dispatch+0xd4>
c0101ca9:	eb 7c                	jmp    c0101d27 <trap_dispatch+0xb8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101cab:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101cb0:	83 c0 01             	add    $0x1,%eax
c0101cb3:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if(TICK_NUM == ticks)
c0101cb8:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101cbd:	83 f8 64             	cmp    $0x64,%eax
c0101cc0:	75 14                	jne    c0101cd6 <trap_dispatch+0x67>
        {
            print_ticks();
c0101cc2:	e8 b2 fb ff ff       	call   c0101879 <print_ticks>
            ticks = 0;
c0101cc7:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0101cce:	00 00 00 
        }
        break;
c0101cd1:	e9 a6 00 00 00       	jmp    c0101d7c <trap_dispatch+0x10d>
c0101cd6:	e9 a1 00 00 00       	jmp    c0101d7c <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101cdb:	e8 5d f9 ff ff       	call   c010163d <cons_getc>
c0101ce0:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ce3:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101ce7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101ceb:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf3:	c7 04 24 c9 64 10 c0 	movl   $0xc01064c9,(%esp)
c0101cfa:	e8 3d e6 ff ff       	call   c010033c <cprintf>
        break;
c0101cff:	eb 7b                	jmp    c0101d7c <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d01:	e8 37 f9 ff ff       	call   c010163d <cons_getc>
c0101d06:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d09:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d0d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d11:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d19:	c7 04 24 db 64 10 c0 	movl   $0xc01064db,(%esp)
c0101d20:	e8 17 e6 ff ff       	call   c010033c <cprintf>
        break;
c0101d25:	eb 55                	jmp    c0101d7c <trap_dispatch+0x10d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d27:	c7 44 24 08 ea 64 10 	movl   $0xc01064ea,0x8(%esp)
c0101d2e:	c0 
c0101d2f:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0101d36:	00 
c0101d37:	c7 04 24 0e 63 10 c0 	movl   $0xc010630e,(%esp)
c0101d3e:	e8 8c ef ff ff       	call   c0100ccf <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d46:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d4a:	0f b7 c0             	movzwl %ax,%eax
c0101d4d:	83 e0 03             	and    $0x3,%eax
c0101d50:	85 c0                	test   %eax,%eax
c0101d52:	75 28                	jne    c0101d7c <trap_dispatch+0x10d>
            print_trapframe(tf);
c0101d54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d57:	89 04 24             	mov    %eax,(%esp)
c0101d5a:	e8 94 fc ff ff       	call   c01019f3 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101d5f:	c7 44 24 08 fa 64 10 	movl   $0xc01064fa,0x8(%esp)
c0101d66:	c0 
c0101d67:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0101d6e:	00 
c0101d6f:	c7 04 24 0e 63 10 c0 	movl   $0xc010630e,(%esp)
c0101d76:	e8 54 ef ff ff       	call   c0100ccf <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101d7b:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101d7c:	c9                   	leave  
c0101d7d:	c3                   	ret    

c0101d7e <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101d7e:	55                   	push   %ebp
c0101d7f:	89 e5                	mov    %esp,%ebp
c0101d81:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101d84:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d87:	89 04 24             	mov    %eax,(%esp)
c0101d8a:	e8 e0 fe ff ff       	call   c0101c6f <trap_dispatch>
}
c0101d8f:	c9                   	leave  
c0101d90:	c3                   	ret    

c0101d91 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101d91:	1e                   	push   %ds
    pushl %es
c0101d92:	06                   	push   %es
    pushl %fs
c0101d93:	0f a0                	push   %fs
    pushl %gs
c0101d95:	0f a8                	push   %gs
    pushal
c0101d97:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101d98:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101d9d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101d9f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101da1:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101da2:	e8 d7 ff ff ff       	call   c0101d7e <trap>

    # pop the pushed stack pointer
    popl %esp
c0101da7:	5c                   	pop    %esp

c0101da8 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101da8:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101da9:	0f a9                	pop    %gs
    popl %fs
c0101dab:	0f a1                	pop    %fs
    popl %es
c0101dad:	07                   	pop    %es
    popl %ds
c0101dae:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101daf:	83 c4 08             	add    $0x8,%esp
    iret
c0101db2:	cf                   	iret   

c0101db3 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101db3:	6a 00                	push   $0x0
  pushl $0
c0101db5:	6a 00                	push   $0x0
  jmp __alltraps
c0101db7:	e9 d5 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101dbc <vector1>:
.globl vector1
vector1:
  pushl $0
c0101dbc:	6a 00                	push   $0x0
  pushl $1
c0101dbe:	6a 01                	push   $0x1
  jmp __alltraps
c0101dc0:	e9 cc ff ff ff       	jmp    c0101d91 <__alltraps>

c0101dc5 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101dc5:	6a 00                	push   $0x0
  pushl $2
c0101dc7:	6a 02                	push   $0x2
  jmp __alltraps
c0101dc9:	e9 c3 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101dce <vector3>:
.globl vector3
vector3:
  pushl $0
c0101dce:	6a 00                	push   $0x0
  pushl $3
c0101dd0:	6a 03                	push   $0x3
  jmp __alltraps
c0101dd2:	e9 ba ff ff ff       	jmp    c0101d91 <__alltraps>

c0101dd7 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101dd7:	6a 00                	push   $0x0
  pushl $4
c0101dd9:	6a 04                	push   $0x4
  jmp __alltraps
c0101ddb:	e9 b1 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101de0 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101de0:	6a 00                	push   $0x0
  pushl $5
c0101de2:	6a 05                	push   $0x5
  jmp __alltraps
c0101de4:	e9 a8 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101de9 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101de9:	6a 00                	push   $0x0
  pushl $6
c0101deb:	6a 06                	push   $0x6
  jmp __alltraps
c0101ded:	e9 9f ff ff ff       	jmp    c0101d91 <__alltraps>

c0101df2 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101df2:	6a 00                	push   $0x0
  pushl $7
c0101df4:	6a 07                	push   $0x7
  jmp __alltraps
c0101df6:	e9 96 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101dfb <vector8>:
.globl vector8
vector8:
  pushl $8
c0101dfb:	6a 08                	push   $0x8
  jmp __alltraps
c0101dfd:	e9 8f ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e02 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e02:	6a 09                	push   $0x9
  jmp __alltraps
c0101e04:	e9 88 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e09 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e09:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e0b:	e9 81 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e10 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e10:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e12:	e9 7a ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e17 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e17:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e19:	e9 73 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e1e <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e1e:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e20:	e9 6c ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e25 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e25:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e27:	e9 65 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e2c <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e2c:	6a 00                	push   $0x0
  pushl $15
c0101e2e:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e30:	e9 5c ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e35 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e35:	6a 00                	push   $0x0
  pushl $16
c0101e37:	6a 10                	push   $0x10
  jmp __alltraps
c0101e39:	e9 53 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e3e <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e3e:	6a 11                	push   $0x11
  jmp __alltraps
c0101e40:	e9 4c ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e45 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e45:	6a 00                	push   $0x0
  pushl $18
c0101e47:	6a 12                	push   $0x12
  jmp __alltraps
c0101e49:	e9 43 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e4e <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e4e:	6a 00                	push   $0x0
  pushl $19
c0101e50:	6a 13                	push   $0x13
  jmp __alltraps
c0101e52:	e9 3a ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e57 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e57:	6a 00                	push   $0x0
  pushl $20
c0101e59:	6a 14                	push   $0x14
  jmp __alltraps
c0101e5b:	e9 31 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e60 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e60:	6a 00                	push   $0x0
  pushl $21
c0101e62:	6a 15                	push   $0x15
  jmp __alltraps
c0101e64:	e9 28 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e69 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e69:	6a 00                	push   $0x0
  pushl $22
c0101e6b:	6a 16                	push   $0x16
  jmp __alltraps
c0101e6d:	e9 1f ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e72 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e72:	6a 00                	push   $0x0
  pushl $23
c0101e74:	6a 17                	push   $0x17
  jmp __alltraps
c0101e76:	e9 16 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e7b <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e7b:	6a 00                	push   $0x0
  pushl $24
c0101e7d:	6a 18                	push   $0x18
  jmp __alltraps
c0101e7f:	e9 0d ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e84 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e84:	6a 00                	push   $0x0
  pushl $25
c0101e86:	6a 19                	push   $0x19
  jmp __alltraps
c0101e88:	e9 04 ff ff ff       	jmp    c0101d91 <__alltraps>

c0101e8d <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e8d:	6a 00                	push   $0x0
  pushl $26
c0101e8f:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101e91:	e9 fb fe ff ff       	jmp    c0101d91 <__alltraps>

c0101e96 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101e96:	6a 00                	push   $0x0
  pushl $27
c0101e98:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101e9a:	e9 f2 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101e9f <vector28>:
.globl vector28
vector28:
  pushl $0
c0101e9f:	6a 00                	push   $0x0
  pushl $28
c0101ea1:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101ea3:	e9 e9 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101ea8 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101ea8:	6a 00                	push   $0x0
  pushl $29
c0101eaa:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101eac:	e9 e0 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101eb1 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101eb1:	6a 00                	push   $0x0
  pushl $30
c0101eb3:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101eb5:	e9 d7 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101eba <vector31>:
.globl vector31
vector31:
  pushl $0
c0101eba:	6a 00                	push   $0x0
  pushl $31
c0101ebc:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ebe:	e9 ce fe ff ff       	jmp    c0101d91 <__alltraps>

c0101ec3 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ec3:	6a 00                	push   $0x0
  pushl $32
c0101ec5:	6a 20                	push   $0x20
  jmp __alltraps
c0101ec7:	e9 c5 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101ecc <vector33>:
.globl vector33
vector33:
  pushl $0
c0101ecc:	6a 00                	push   $0x0
  pushl $33
c0101ece:	6a 21                	push   $0x21
  jmp __alltraps
c0101ed0:	e9 bc fe ff ff       	jmp    c0101d91 <__alltraps>

c0101ed5 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101ed5:	6a 00                	push   $0x0
  pushl $34
c0101ed7:	6a 22                	push   $0x22
  jmp __alltraps
c0101ed9:	e9 b3 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101ede <vector35>:
.globl vector35
vector35:
  pushl $0
c0101ede:	6a 00                	push   $0x0
  pushl $35
c0101ee0:	6a 23                	push   $0x23
  jmp __alltraps
c0101ee2:	e9 aa fe ff ff       	jmp    c0101d91 <__alltraps>

c0101ee7 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ee7:	6a 00                	push   $0x0
  pushl $36
c0101ee9:	6a 24                	push   $0x24
  jmp __alltraps
c0101eeb:	e9 a1 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101ef0 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101ef0:	6a 00                	push   $0x0
  pushl $37
c0101ef2:	6a 25                	push   $0x25
  jmp __alltraps
c0101ef4:	e9 98 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101ef9 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101ef9:	6a 00                	push   $0x0
  pushl $38
c0101efb:	6a 26                	push   $0x26
  jmp __alltraps
c0101efd:	e9 8f fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f02 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f02:	6a 00                	push   $0x0
  pushl $39
c0101f04:	6a 27                	push   $0x27
  jmp __alltraps
c0101f06:	e9 86 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f0b <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f0b:	6a 00                	push   $0x0
  pushl $40
c0101f0d:	6a 28                	push   $0x28
  jmp __alltraps
c0101f0f:	e9 7d fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f14 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f14:	6a 00                	push   $0x0
  pushl $41
c0101f16:	6a 29                	push   $0x29
  jmp __alltraps
c0101f18:	e9 74 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f1d <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f1d:	6a 00                	push   $0x0
  pushl $42
c0101f1f:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f21:	e9 6b fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f26 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f26:	6a 00                	push   $0x0
  pushl $43
c0101f28:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f2a:	e9 62 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f2f <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f2f:	6a 00                	push   $0x0
  pushl $44
c0101f31:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f33:	e9 59 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f38 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f38:	6a 00                	push   $0x0
  pushl $45
c0101f3a:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f3c:	e9 50 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f41 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f41:	6a 00                	push   $0x0
  pushl $46
c0101f43:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f45:	e9 47 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f4a <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f4a:	6a 00                	push   $0x0
  pushl $47
c0101f4c:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f4e:	e9 3e fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f53 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f53:	6a 00                	push   $0x0
  pushl $48
c0101f55:	6a 30                	push   $0x30
  jmp __alltraps
c0101f57:	e9 35 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f5c <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f5c:	6a 00                	push   $0x0
  pushl $49
c0101f5e:	6a 31                	push   $0x31
  jmp __alltraps
c0101f60:	e9 2c fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f65 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f65:	6a 00                	push   $0x0
  pushl $50
c0101f67:	6a 32                	push   $0x32
  jmp __alltraps
c0101f69:	e9 23 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f6e <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f6e:	6a 00                	push   $0x0
  pushl $51
c0101f70:	6a 33                	push   $0x33
  jmp __alltraps
c0101f72:	e9 1a fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f77 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f77:	6a 00                	push   $0x0
  pushl $52
c0101f79:	6a 34                	push   $0x34
  jmp __alltraps
c0101f7b:	e9 11 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f80 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f80:	6a 00                	push   $0x0
  pushl $53
c0101f82:	6a 35                	push   $0x35
  jmp __alltraps
c0101f84:	e9 08 fe ff ff       	jmp    c0101d91 <__alltraps>

c0101f89 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f89:	6a 00                	push   $0x0
  pushl $54
c0101f8b:	6a 36                	push   $0x36
  jmp __alltraps
c0101f8d:	e9 ff fd ff ff       	jmp    c0101d91 <__alltraps>

c0101f92 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101f92:	6a 00                	push   $0x0
  pushl $55
c0101f94:	6a 37                	push   $0x37
  jmp __alltraps
c0101f96:	e9 f6 fd ff ff       	jmp    c0101d91 <__alltraps>

c0101f9b <vector56>:
.globl vector56
vector56:
  pushl $0
c0101f9b:	6a 00                	push   $0x0
  pushl $56
c0101f9d:	6a 38                	push   $0x38
  jmp __alltraps
c0101f9f:	e9 ed fd ff ff       	jmp    c0101d91 <__alltraps>

c0101fa4 <vector57>:
.globl vector57
vector57:
  pushl $0
c0101fa4:	6a 00                	push   $0x0
  pushl $57
c0101fa6:	6a 39                	push   $0x39
  jmp __alltraps
c0101fa8:	e9 e4 fd ff ff       	jmp    c0101d91 <__alltraps>

c0101fad <vector58>:
.globl vector58
vector58:
  pushl $0
c0101fad:	6a 00                	push   $0x0
  pushl $58
c0101faf:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101fb1:	e9 db fd ff ff       	jmp    c0101d91 <__alltraps>

c0101fb6 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101fb6:	6a 00                	push   $0x0
  pushl $59
c0101fb8:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fba:	e9 d2 fd ff ff       	jmp    c0101d91 <__alltraps>

c0101fbf <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fbf:	6a 00                	push   $0x0
  pushl $60
c0101fc1:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fc3:	e9 c9 fd ff ff       	jmp    c0101d91 <__alltraps>

c0101fc8 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fc8:	6a 00                	push   $0x0
  pushl $61
c0101fca:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fcc:	e9 c0 fd ff ff       	jmp    c0101d91 <__alltraps>

c0101fd1 <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fd1:	6a 00                	push   $0x0
  pushl $62
c0101fd3:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fd5:	e9 b7 fd ff ff       	jmp    c0101d91 <__alltraps>

c0101fda <vector63>:
.globl vector63
vector63:
  pushl $0
c0101fda:	6a 00                	push   $0x0
  pushl $63
c0101fdc:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fde:	e9 ae fd ff ff       	jmp    c0101d91 <__alltraps>

c0101fe3 <vector64>:
.globl vector64
vector64:
  pushl $0
c0101fe3:	6a 00                	push   $0x0
  pushl $64
c0101fe5:	6a 40                	push   $0x40
  jmp __alltraps
c0101fe7:	e9 a5 fd ff ff       	jmp    c0101d91 <__alltraps>

c0101fec <vector65>:
.globl vector65
vector65:
  pushl $0
c0101fec:	6a 00                	push   $0x0
  pushl $65
c0101fee:	6a 41                	push   $0x41
  jmp __alltraps
c0101ff0:	e9 9c fd ff ff       	jmp    c0101d91 <__alltraps>

c0101ff5 <vector66>:
.globl vector66
vector66:
  pushl $0
c0101ff5:	6a 00                	push   $0x0
  pushl $66
c0101ff7:	6a 42                	push   $0x42
  jmp __alltraps
c0101ff9:	e9 93 fd ff ff       	jmp    c0101d91 <__alltraps>

c0101ffe <vector67>:
.globl vector67
vector67:
  pushl $0
c0101ffe:	6a 00                	push   $0x0
  pushl $67
c0102000:	6a 43                	push   $0x43
  jmp __alltraps
c0102002:	e9 8a fd ff ff       	jmp    c0101d91 <__alltraps>

c0102007 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102007:	6a 00                	push   $0x0
  pushl $68
c0102009:	6a 44                	push   $0x44
  jmp __alltraps
c010200b:	e9 81 fd ff ff       	jmp    c0101d91 <__alltraps>

c0102010 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102010:	6a 00                	push   $0x0
  pushl $69
c0102012:	6a 45                	push   $0x45
  jmp __alltraps
c0102014:	e9 78 fd ff ff       	jmp    c0101d91 <__alltraps>

c0102019 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102019:	6a 00                	push   $0x0
  pushl $70
c010201b:	6a 46                	push   $0x46
  jmp __alltraps
c010201d:	e9 6f fd ff ff       	jmp    c0101d91 <__alltraps>

c0102022 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102022:	6a 00                	push   $0x0
  pushl $71
c0102024:	6a 47                	push   $0x47
  jmp __alltraps
c0102026:	e9 66 fd ff ff       	jmp    c0101d91 <__alltraps>

c010202b <vector72>:
.globl vector72
vector72:
  pushl $0
c010202b:	6a 00                	push   $0x0
  pushl $72
c010202d:	6a 48                	push   $0x48
  jmp __alltraps
c010202f:	e9 5d fd ff ff       	jmp    c0101d91 <__alltraps>

c0102034 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102034:	6a 00                	push   $0x0
  pushl $73
c0102036:	6a 49                	push   $0x49
  jmp __alltraps
c0102038:	e9 54 fd ff ff       	jmp    c0101d91 <__alltraps>

c010203d <vector74>:
.globl vector74
vector74:
  pushl $0
c010203d:	6a 00                	push   $0x0
  pushl $74
c010203f:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102041:	e9 4b fd ff ff       	jmp    c0101d91 <__alltraps>

c0102046 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102046:	6a 00                	push   $0x0
  pushl $75
c0102048:	6a 4b                	push   $0x4b
  jmp __alltraps
c010204a:	e9 42 fd ff ff       	jmp    c0101d91 <__alltraps>

c010204f <vector76>:
.globl vector76
vector76:
  pushl $0
c010204f:	6a 00                	push   $0x0
  pushl $76
c0102051:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102053:	e9 39 fd ff ff       	jmp    c0101d91 <__alltraps>

c0102058 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102058:	6a 00                	push   $0x0
  pushl $77
c010205a:	6a 4d                	push   $0x4d
  jmp __alltraps
c010205c:	e9 30 fd ff ff       	jmp    c0101d91 <__alltraps>

c0102061 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102061:	6a 00                	push   $0x0
  pushl $78
c0102063:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102065:	e9 27 fd ff ff       	jmp    c0101d91 <__alltraps>

c010206a <vector79>:
.globl vector79
vector79:
  pushl $0
c010206a:	6a 00                	push   $0x0
  pushl $79
c010206c:	6a 4f                	push   $0x4f
  jmp __alltraps
c010206e:	e9 1e fd ff ff       	jmp    c0101d91 <__alltraps>

c0102073 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102073:	6a 00                	push   $0x0
  pushl $80
c0102075:	6a 50                	push   $0x50
  jmp __alltraps
c0102077:	e9 15 fd ff ff       	jmp    c0101d91 <__alltraps>

c010207c <vector81>:
.globl vector81
vector81:
  pushl $0
c010207c:	6a 00                	push   $0x0
  pushl $81
c010207e:	6a 51                	push   $0x51
  jmp __alltraps
c0102080:	e9 0c fd ff ff       	jmp    c0101d91 <__alltraps>

c0102085 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102085:	6a 00                	push   $0x0
  pushl $82
c0102087:	6a 52                	push   $0x52
  jmp __alltraps
c0102089:	e9 03 fd ff ff       	jmp    c0101d91 <__alltraps>

c010208e <vector83>:
.globl vector83
vector83:
  pushl $0
c010208e:	6a 00                	push   $0x0
  pushl $83
c0102090:	6a 53                	push   $0x53
  jmp __alltraps
c0102092:	e9 fa fc ff ff       	jmp    c0101d91 <__alltraps>

c0102097 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102097:	6a 00                	push   $0x0
  pushl $84
c0102099:	6a 54                	push   $0x54
  jmp __alltraps
c010209b:	e9 f1 fc ff ff       	jmp    c0101d91 <__alltraps>

c01020a0 <vector85>:
.globl vector85
vector85:
  pushl $0
c01020a0:	6a 00                	push   $0x0
  pushl $85
c01020a2:	6a 55                	push   $0x55
  jmp __alltraps
c01020a4:	e9 e8 fc ff ff       	jmp    c0101d91 <__alltraps>

c01020a9 <vector86>:
.globl vector86
vector86:
  pushl $0
c01020a9:	6a 00                	push   $0x0
  pushl $86
c01020ab:	6a 56                	push   $0x56
  jmp __alltraps
c01020ad:	e9 df fc ff ff       	jmp    c0101d91 <__alltraps>

c01020b2 <vector87>:
.globl vector87
vector87:
  pushl $0
c01020b2:	6a 00                	push   $0x0
  pushl $87
c01020b4:	6a 57                	push   $0x57
  jmp __alltraps
c01020b6:	e9 d6 fc ff ff       	jmp    c0101d91 <__alltraps>

c01020bb <vector88>:
.globl vector88
vector88:
  pushl $0
c01020bb:	6a 00                	push   $0x0
  pushl $88
c01020bd:	6a 58                	push   $0x58
  jmp __alltraps
c01020bf:	e9 cd fc ff ff       	jmp    c0101d91 <__alltraps>

c01020c4 <vector89>:
.globl vector89
vector89:
  pushl $0
c01020c4:	6a 00                	push   $0x0
  pushl $89
c01020c6:	6a 59                	push   $0x59
  jmp __alltraps
c01020c8:	e9 c4 fc ff ff       	jmp    c0101d91 <__alltraps>

c01020cd <vector90>:
.globl vector90
vector90:
  pushl $0
c01020cd:	6a 00                	push   $0x0
  pushl $90
c01020cf:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020d1:	e9 bb fc ff ff       	jmp    c0101d91 <__alltraps>

c01020d6 <vector91>:
.globl vector91
vector91:
  pushl $0
c01020d6:	6a 00                	push   $0x0
  pushl $91
c01020d8:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020da:	e9 b2 fc ff ff       	jmp    c0101d91 <__alltraps>

c01020df <vector92>:
.globl vector92
vector92:
  pushl $0
c01020df:	6a 00                	push   $0x0
  pushl $92
c01020e1:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020e3:	e9 a9 fc ff ff       	jmp    c0101d91 <__alltraps>

c01020e8 <vector93>:
.globl vector93
vector93:
  pushl $0
c01020e8:	6a 00                	push   $0x0
  pushl $93
c01020ea:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020ec:	e9 a0 fc ff ff       	jmp    c0101d91 <__alltraps>

c01020f1 <vector94>:
.globl vector94
vector94:
  pushl $0
c01020f1:	6a 00                	push   $0x0
  pushl $94
c01020f3:	6a 5e                	push   $0x5e
  jmp __alltraps
c01020f5:	e9 97 fc ff ff       	jmp    c0101d91 <__alltraps>

c01020fa <vector95>:
.globl vector95
vector95:
  pushl $0
c01020fa:	6a 00                	push   $0x0
  pushl $95
c01020fc:	6a 5f                	push   $0x5f
  jmp __alltraps
c01020fe:	e9 8e fc ff ff       	jmp    c0101d91 <__alltraps>

c0102103 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102103:	6a 00                	push   $0x0
  pushl $96
c0102105:	6a 60                	push   $0x60
  jmp __alltraps
c0102107:	e9 85 fc ff ff       	jmp    c0101d91 <__alltraps>

c010210c <vector97>:
.globl vector97
vector97:
  pushl $0
c010210c:	6a 00                	push   $0x0
  pushl $97
c010210e:	6a 61                	push   $0x61
  jmp __alltraps
c0102110:	e9 7c fc ff ff       	jmp    c0101d91 <__alltraps>

c0102115 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102115:	6a 00                	push   $0x0
  pushl $98
c0102117:	6a 62                	push   $0x62
  jmp __alltraps
c0102119:	e9 73 fc ff ff       	jmp    c0101d91 <__alltraps>

c010211e <vector99>:
.globl vector99
vector99:
  pushl $0
c010211e:	6a 00                	push   $0x0
  pushl $99
c0102120:	6a 63                	push   $0x63
  jmp __alltraps
c0102122:	e9 6a fc ff ff       	jmp    c0101d91 <__alltraps>

c0102127 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102127:	6a 00                	push   $0x0
  pushl $100
c0102129:	6a 64                	push   $0x64
  jmp __alltraps
c010212b:	e9 61 fc ff ff       	jmp    c0101d91 <__alltraps>

c0102130 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102130:	6a 00                	push   $0x0
  pushl $101
c0102132:	6a 65                	push   $0x65
  jmp __alltraps
c0102134:	e9 58 fc ff ff       	jmp    c0101d91 <__alltraps>

c0102139 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102139:	6a 00                	push   $0x0
  pushl $102
c010213b:	6a 66                	push   $0x66
  jmp __alltraps
c010213d:	e9 4f fc ff ff       	jmp    c0101d91 <__alltraps>

c0102142 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102142:	6a 00                	push   $0x0
  pushl $103
c0102144:	6a 67                	push   $0x67
  jmp __alltraps
c0102146:	e9 46 fc ff ff       	jmp    c0101d91 <__alltraps>

c010214b <vector104>:
.globl vector104
vector104:
  pushl $0
c010214b:	6a 00                	push   $0x0
  pushl $104
c010214d:	6a 68                	push   $0x68
  jmp __alltraps
c010214f:	e9 3d fc ff ff       	jmp    c0101d91 <__alltraps>

c0102154 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102154:	6a 00                	push   $0x0
  pushl $105
c0102156:	6a 69                	push   $0x69
  jmp __alltraps
c0102158:	e9 34 fc ff ff       	jmp    c0101d91 <__alltraps>

c010215d <vector106>:
.globl vector106
vector106:
  pushl $0
c010215d:	6a 00                	push   $0x0
  pushl $106
c010215f:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102161:	e9 2b fc ff ff       	jmp    c0101d91 <__alltraps>

c0102166 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102166:	6a 00                	push   $0x0
  pushl $107
c0102168:	6a 6b                	push   $0x6b
  jmp __alltraps
c010216a:	e9 22 fc ff ff       	jmp    c0101d91 <__alltraps>

c010216f <vector108>:
.globl vector108
vector108:
  pushl $0
c010216f:	6a 00                	push   $0x0
  pushl $108
c0102171:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102173:	e9 19 fc ff ff       	jmp    c0101d91 <__alltraps>

c0102178 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102178:	6a 00                	push   $0x0
  pushl $109
c010217a:	6a 6d                	push   $0x6d
  jmp __alltraps
c010217c:	e9 10 fc ff ff       	jmp    c0101d91 <__alltraps>

c0102181 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102181:	6a 00                	push   $0x0
  pushl $110
c0102183:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102185:	e9 07 fc ff ff       	jmp    c0101d91 <__alltraps>

c010218a <vector111>:
.globl vector111
vector111:
  pushl $0
c010218a:	6a 00                	push   $0x0
  pushl $111
c010218c:	6a 6f                	push   $0x6f
  jmp __alltraps
c010218e:	e9 fe fb ff ff       	jmp    c0101d91 <__alltraps>

c0102193 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102193:	6a 00                	push   $0x0
  pushl $112
c0102195:	6a 70                	push   $0x70
  jmp __alltraps
c0102197:	e9 f5 fb ff ff       	jmp    c0101d91 <__alltraps>

c010219c <vector113>:
.globl vector113
vector113:
  pushl $0
c010219c:	6a 00                	push   $0x0
  pushl $113
c010219e:	6a 71                	push   $0x71
  jmp __alltraps
c01021a0:	e9 ec fb ff ff       	jmp    c0101d91 <__alltraps>

c01021a5 <vector114>:
.globl vector114
vector114:
  pushl $0
c01021a5:	6a 00                	push   $0x0
  pushl $114
c01021a7:	6a 72                	push   $0x72
  jmp __alltraps
c01021a9:	e9 e3 fb ff ff       	jmp    c0101d91 <__alltraps>

c01021ae <vector115>:
.globl vector115
vector115:
  pushl $0
c01021ae:	6a 00                	push   $0x0
  pushl $115
c01021b0:	6a 73                	push   $0x73
  jmp __alltraps
c01021b2:	e9 da fb ff ff       	jmp    c0101d91 <__alltraps>

c01021b7 <vector116>:
.globl vector116
vector116:
  pushl $0
c01021b7:	6a 00                	push   $0x0
  pushl $116
c01021b9:	6a 74                	push   $0x74
  jmp __alltraps
c01021bb:	e9 d1 fb ff ff       	jmp    c0101d91 <__alltraps>

c01021c0 <vector117>:
.globl vector117
vector117:
  pushl $0
c01021c0:	6a 00                	push   $0x0
  pushl $117
c01021c2:	6a 75                	push   $0x75
  jmp __alltraps
c01021c4:	e9 c8 fb ff ff       	jmp    c0101d91 <__alltraps>

c01021c9 <vector118>:
.globl vector118
vector118:
  pushl $0
c01021c9:	6a 00                	push   $0x0
  pushl $118
c01021cb:	6a 76                	push   $0x76
  jmp __alltraps
c01021cd:	e9 bf fb ff ff       	jmp    c0101d91 <__alltraps>

c01021d2 <vector119>:
.globl vector119
vector119:
  pushl $0
c01021d2:	6a 00                	push   $0x0
  pushl $119
c01021d4:	6a 77                	push   $0x77
  jmp __alltraps
c01021d6:	e9 b6 fb ff ff       	jmp    c0101d91 <__alltraps>

c01021db <vector120>:
.globl vector120
vector120:
  pushl $0
c01021db:	6a 00                	push   $0x0
  pushl $120
c01021dd:	6a 78                	push   $0x78
  jmp __alltraps
c01021df:	e9 ad fb ff ff       	jmp    c0101d91 <__alltraps>

c01021e4 <vector121>:
.globl vector121
vector121:
  pushl $0
c01021e4:	6a 00                	push   $0x0
  pushl $121
c01021e6:	6a 79                	push   $0x79
  jmp __alltraps
c01021e8:	e9 a4 fb ff ff       	jmp    c0101d91 <__alltraps>

c01021ed <vector122>:
.globl vector122
vector122:
  pushl $0
c01021ed:	6a 00                	push   $0x0
  pushl $122
c01021ef:	6a 7a                	push   $0x7a
  jmp __alltraps
c01021f1:	e9 9b fb ff ff       	jmp    c0101d91 <__alltraps>

c01021f6 <vector123>:
.globl vector123
vector123:
  pushl $0
c01021f6:	6a 00                	push   $0x0
  pushl $123
c01021f8:	6a 7b                	push   $0x7b
  jmp __alltraps
c01021fa:	e9 92 fb ff ff       	jmp    c0101d91 <__alltraps>

c01021ff <vector124>:
.globl vector124
vector124:
  pushl $0
c01021ff:	6a 00                	push   $0x0
  pushl $124
c0102201:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102203:	e9 89 fb ff ff       	jmp    c0101d91 <__alltraps>

c0102208 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102208:	6a 00                	push   $0x0
  pushl $125
c010220a:	6a 7d                	push   $0x7d
  jmp __alltraps
c010220c:	e9 80 fb ff ff       	jmp    c0101d91 <__alltraps>

c0102211 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102211:	6a 00                	push   $0x0
  pushl $126
c0102213:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102215:	e9 77 fb ff ff       	jmp    c0101d91 <__alltraps>

c010221a <vector127>:
.globl vector127
vector127:
  pushl $0
c010221a:	6a 00                	push   $0x0
  pushl $127
c010221c:	6a 7f                	push   $0x7f
  jmp __alltraps
c010221e:	e9 6e fb ff ff       	jmp    c0101d91 <__alltraps>

c0102223 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102223:	6a 00                	push   $0x0
  pushl $128
c0102225:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010222a:	e9 62 fb ff ff       	jmp    c0101d91 <__alltraps>

c010222f <vector129>:
.globl vector129
vector129:
  pushl $0
c010222f:	6a 00                	push   $0x0
  pushl $129
c0102231:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102236:	e9 56 fb ff ff       	jmp    c0101d91 <__alltraps>

c010223b <vector130>:
.globl vector130
vector130:
  pushl $0
c010223b:	6a 00                	push   $0x0
  pushl $130
c010223d:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102242:	e9 4a fb ff ff       	jmp    c0101d91 <__alltraps>

c0102247 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102247:	6a 00                	push   $0x0
  pushl $131
c0102249:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010224e:	e9 3e fb ff ff       	jmp    c0101d91 <__alltraps>

c0102253 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102253:	6a 00                	push   $0x0
  pushl $132
c0102255:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010225a:	e9 32 fb ff ff       	jmp    c0101d91 <__alltraps>

c010225f <vector133>:
.globl vector133
vector133:
  pushl $0
c010225f:	6a 00                	push   $0x0
  pushl $133
c0102261:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102266:	e9 26 fb ff ff       	jmp    c0101d91 <__alltraps>

c010226b <vector134>:
.globl vector134
vector134:
  pushl $0
c010226b:	6a 00                	push   $0x0
  pushl $134
c010226d:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102272:	e9 1a fb ff ff       	jmp    c0101d91 <__alltraps>

c0102277 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102277:	6a 00                	push   $0x0
  pushl $135
c0102279:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010227e:	e9 0e fb ff ff       	jmp    c0101d91 <__alltraps>

c0102283 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $136
c0102285:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010228a:	e9 02 fb ff ff       	jmp    c0101d91 <__alltraps>

c010228f <vector137>:
.globl vector137
vector137:
  pushl $0
c010228f:	6a 00                	push   $0x0
  pushl $137
c0102291:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102296:	e9 f6 fa ff ff       	jmp    c0101d91 <__alltraps>

c010229b <vector138>:
.globl vector138
vector138:
  pushl $0
c010229b:	6a 00                	push   $0x0
  pushl $138
c010229d:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022a2:	e9 ea fa ff ff       	jmp    c0101d91 <__alltraps>

c01022a7 <vector139>:
.globl vector139
vector139:
  pushl $0
c01022a7:	6a 00                	push   $0x0
  pushl $139
c01022a9:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022ae:	e9 de fa ff ff       	jmp    c0101d91 <__alltraps>

c01022b3 <vector140>:
.globl vector140
vector140:
  pushl $0
c01022b3:	6a 00                	push   $0x0
  pushl $140
c01022b5:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022ba:	e9 d2 fa ff ff       	jmp    c0101d91 <__alltraps>

c01022bf <vector141>:
.globl vector141
vector141:
  pushl $0
c01022bf:	6a 00                	push   $0x0
  pushl $141
c01022c1:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022c6:	e9 c6 fa ff ff       	jmp    c0101d91 <__alltraps>

c01022cb <vector142>:
.globl vector142
vector142:
  pushl $0
c01022cb:	6a 00                	push   $0x0
  pushl $142
c01022cd:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022d2:	e9 ba fa ff ff       	jmp    c0101d91 <__alltraps>

c01022d7 <vector143>:
.globl vector143
vector143:
  pushl $0
c01022d7:	6a 00                	push   $0x0
  pushl $143
c01022d9:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022de:	e9 ae fa ff ff       	jmp    c0101d91 <__alltraps>

c01022e3 <vector144>:
.globl vector144
vector144:
  pushl $0
c01022e3:	6a 00                	push   $0x0
  pushl $144
c01022e5:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022ea:	e9 a2 fa ff ff       	jmp    c0101d91 <__alltraps>

c01022ef <vector145>:
.globl vector145
vector145:
  pushl $0
c01022ef:	6a 00                	push   $0x0
  pushl $145
c01022f1:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01022f6:	e9 96 fa ff ff       	jmp    c0101d91 <__alltraps>

c01022fb <vector146>:
.globl vector146
vector146:
  pushl $0
c01022fb:	6a 00                	push   $0x0
  pushl $146
c01022fd:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102302:	e9 8a fa ff ff       	jmp    c0101d91 <__alltraps>

c0102307 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102307:	6a 00                	push   $0x0
  pushl $147
c0102309:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010230e:	e9 7e fa ff ff       	jmp    c0101d91 <__alltraps>

c0102313 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102313:	6a 00                	push   $0x0
  pushl $148
c0102315:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010231a:	e9 72 fa ff ff       	jmp    c0101d91 <__alltraps>

c010231f <vector149>:
.globl vector149
vector149:
  pushl $0
c010231f:	6a 00                	push   $0x0
  pushl $149
c0102321:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102326:	e9 66 fa ff ff       	jmp    c0101d91 <__alltraps>

c010232b <vector150>:
.globl vector150
vector150:
  pushl $0
c010232b:	6a 00                	push   $0x0
  pushl $150
c010232d:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102332:	e9 5a fa ff ff       	jmp    c0101d91 <__alltraps>

c0102337 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102337:	6a 00                	push   $0x0
  pushl $151
c0102339:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010233e:	e9 4e fa ff ff       	jmp    c0101d91 <__alltraps>

c0102343 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102343:	6a 00                	push   $0x0
  pushl $152
c0102345:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010234a:	e9 42 fa ff ff       	jmp    c0101d91 <__alltraps>

c010234f <vector153>:
.globl vector153
vector153:
  pushl $0
c010234f:	6a 00                	push   $0x0
  pushl $153
c0102351:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102356:	e9 36 fa ff ff       	jmp    c0101d91 <__alltraps>

c010235b <vector154>:
.globl vector154
vector154:
  pushl $0
c010235b:	6a 00                	push   $0x0
  pushl $154
c010235d:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102362:	e9 2a fa ff ff       	jmp    c0101d91 <__alltraps>

c0102367 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102367:	6a 00                	push   $0x0
  pushl $155
c0102369:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010236e:	e9 1e fa ff ff       	jmp    c0101d91 <__alltraps>

c0102373 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102373:	6a 00                	push   $0x0
  pushl $156
c0102375:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010237a:	e9 12 fa ff ff       	jmp    c0101d91 <__alltraps>

c010237f <vector157>:
.globl vector157
vector157:
  pushl $0
c010237f:	6a 00                	push   $0x0
  pushl $157
c0102381:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102386:	e9 06 fa ff ff       	jmp    c0101d91 <__alltraps>

c010238b <vector158>:
.globl vector158
vector158:
  pushl $0
c010238b:	6a 00                	push   $0x0
  pushl $158
c010238d:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102392:	e9 fa f9 ff ff       	jmp    c0101d91 <__alltraps>

c0102397 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102397:	6a 00                	push   $0x0
  pushl $159
c0102399:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010239e:	e9 ee f9 ff ff       	jmp    c0101d91 <__alltraps>

c01023a3 <vector160>:
.globl vector160
vector160:
  pushl $0
c01023a3:	6a 00                	push   $0x0
  pushl $160
c01023a5:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023aa:	e9 e2 f9 ff ff       	jmp    c0101d91 <__alltraps>

c01023af <vector161>:
.globl vector161
vector161:
  pushl $0
c01023af:	6a 00                	push   $0x0
  pushl $161
c01023b1:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023b6:	e9 d6 f9 ff ff       	jmp    c0101d91 <__alltraps>

c01023bb <vector162>:
.globl vector162
vector162:
  pushl $0
c01023bb:	6a 00                	push   $0x0
  pushl $162
c01023bd:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023c2:	e9 ca f9 ff ff       	jmp    c0101d91 <__alltraps>

c01023c7 <vector163>:
.globl vector163
vector163:
  pushl $0
c01023c7:	6a 00                	push   $0x0
  pushl $163
c01023c9:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023ce:	e9 be f9 ff ff       	jmp    c0101d91 <__alltraps>

c01023d3 <vector164>:
.globl vector164
vector164:
  pushl $0
c01023d3:	6a 00                	push   $0x0
  pushl $164
c01023d5:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023da:	e9 b2 f9 ff ff       	jmp    c0101d91 <__alltraps>

c01023df <vector165>:
.globl vector165
vector165:
  pushl $0
c01023df:	6a 00                	push   $0x0
  pushl $165
c01023e1:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023e6:	e9 a6 f9 ff ff       	jmp    c0101d91 <__alltraps>

c01023eb <vector166>:
.globl vector166
vector166:
  pushl $0
c01023eb:	6a 00                	push   $0x0
  pushl $166
c01023ed:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01023f2:	e9 9a f9 ff ff       	jmp    c0101d91 <__alltraps>

c01023f7 <vector167>:
.globl vector167
vector167:
  pushl $0
c01023f7:	6a 00                	push   $0x0
  pushl $167
c01023f9:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01023fe:	e9 8e f9 ff ff       	jmp    c0101d91 <__alltraps>

c0102403 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102403:	6a 00                	push   $0x0
  pushl $168
c0102405:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010240a:	e9 82 f9 ff ff       	jmp    c0101d91 <__alltraps>

c010240f <vector169>:
.globl vector169
vector169:
  pushl $0
c010240f:	6a 00                	push   $0x0
  pushl $169
c0102411:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102416:	e9 76 f9 ff ff       	jmp    c0101d91 <__alltraps>

c010241b <vector170>:
.globl vector170
vector170:
  pushl $0
c010241b:	6a 00                	push   $0x0
  pushl $170
c010241d:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102422:	e9 6a f9 ff ff       	jmp    c0101d91 <__alltraps>

c0102427 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102427:	6a 00                	push   $0x0
  pushl $171
c0102429:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010242e:	e9 5e f9 ff ff       	jmp    c0101d91 <__alltraps>

c0102433 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102433:	6a 00                	push   $0x0
  pushl $172
c0102435:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010243a:	e9 52 f9 ff ff       	jmp    c0101d91 <__alltraps>

c010243f <vector173>:
.globl vector173
vector173:
  pushl $0
c010243f:	6a 00                	push   $0x0
  pushl $173
c0102441:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102446:	e9 46 f9 ff ff       	jmp    c0101d91 <__alltraps>

c010244b <vector174>:
.globl vector174
vector174:
  pushl $0
c010244b:	6a 00                	push   $0x0
  pushl $174
c010244d:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102452:	e9 3a f9 ff ff       	jmp    c0101d91 <__alltraps>

c0102457 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102457:	6a 00                	push   $0x0
  pushl $175
c0102459:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010245e:	e9 2e f9 ff ff       	jmp    c0101d91 <__alltraps>

c0102463 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102463:	6a 00                	push   $0x0
  pushl $176
c0102465:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010246a:	e9 22 f9 ff ff       	jmp    c0101d91 <__alltraps>

c010246f <vector177>:
.globl vector177
vector177:
  pushl $0
c010246f:	6a 00                	push   $0x0
  pushl $177
c0102471:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102476:	e9 16 f9 ff ff       	jmp    c0101d91 <__alltraps>

c010247b <vector178>:
.globl vector178
vector178:
  pushl $0
c010247b:	6a 00                	push   $0x0
  pushl $178
c010247d:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102482:	e9 0a f9 ff ff       	jmp    c0101d91 <__alltraps>

c0102487 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102487:	6a 00                	push   $0x0
  pushl $179
c0102489:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010248e:	e9 fe f8 ff ff       	jmp    c0101d91 <__alltraps>

c0102493 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102493:	6a 00                	push   $0x0
  pushl $180
c0102495:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010249a:	e9 f2 f8 ff ff       	jmp    c0101d91 <__alltraps>

c010249f <vector181>:
.globl vector181
vector181:
  pushl $0
c010249f:	6a 00                	push   $0x0
  pushl $181
c01024a1:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024a6:	e9 e6 f8 ff ff       	jmp    c0101d91 <__alltraps>

c01024ab <vector182>:
.globl vector182
vector182:
  pushl $0
c01024ab:	6a 00                	push   $0x0
  pushl $182
c01024ad:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01024b2:	e9 da f8 ff ff       	jmp    c0101d91 <__alltraps>

c01024b7 <vector183>:
.globl vector183
vector183:
  pushl $0
c01024b7:	6a 00                	push   $0x0
  pushl $183
c01024b9:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024be:	e9 ce f8 ff ff       	jmp    c0101d91 <__alltraps>

c01024c3 <vector184>:
.globl vector184
vector184:
  pushl $0
c01024c3:	6a 00                	push   $0x0
  pushl $184
c01024c5:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024ca:	e9 c2 f8 ff ff       	jmp    c0101d91 <__alltraps>

c01024cf <vector185>:
.globl vector185
vector185:
  pushl $0
c01024cf:	6a 00                	push   $0x0
  pushl $185
c01024d1:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024d6:	e9 b6 f8 ff ff       	jmp    c0101d91 <__alltraps>

c01024db <vector186>:
.globl vector186
vector186:
  pushl $0
c01024db:	6a 00                	push   $0x0
  pushl $186
c01024dd:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024e2:	e9 aa f8 ff ff       	jmp    c0101d91 <__alltraps>

c01024e7 <vector187>:
.globl vector187
vector187:
  pushl $0
c01024e7:	6a 00                	push   $0x0
  pushl $187
c01024e9:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024ee:	e9 9e f8 ff ff       	jmp    c0101d91 <__alltraps>

c01024f3 <vector188>:
.globl vector188
vector188:
  pushl $0
c01024f3:	6a 00                	push   $0x0
  pushl $188
c01024f5:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01024fa:	e9 92 f8 ff ff       	jmp    c0101d91 <__alltraps>

c01024ff <vector189>:
.globl vector189
vector189:
  pushl $0
c01024ff:	6a 00                	push   $0x0
  pushl $189
c0102501:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102506:	e9 86 f8 ff ff       	jmp    c0101d91 <__alltraps>

c010250b <vector190>:
.globl vector190
vector190:
  pushl $0
c010250b:	6a 00                	push   $0x0
  pushl $190
c010250d:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102512:	e9 7a f8 ff ff       	jmp    c0101d91 <__alltraps>

c0102517 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102517:	6a 00                	push   $0x0
  pushl $191
c0102519:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010251e:	e9 6e f8 ff ff       	jmp    c0101d91 <__alltraps>

c0102523 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102523:	6a 00                	push   $0x0
  pushl $192
c0102525:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010252a:	e9 62 f8 ff ff       	jmp    c0101d91 <__alltraps>

c010252f <vector193>:
.globl vector193
vector193:
  pushl $0
c010252f:	6a 00                	push   $0x0
  pushl $193
c0102531:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102536:	e9 56 f8 ff ff       	jmp    c0101d91 <__alltraps>

c010253b <vector194>:
.globl vector194
vector194:
  pushl $0
c010253b:	6a 00                	push   $0x0
  pushl $194
c010253d:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102542:	e9 4a f8 ff ff       	jmp    c0101d91 <__alltraps>

c0102547 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102547:	6a 00                	push   $0x0
  pushl $195
c0102549:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010254e:	e9 3e f8 ff ff       	jmp    c0101d91 <__alltraps>

c0102553 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102553:	6a 00                	push   $0x0
  pushl $196
c0102555:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010255a:	e9 32 f8 ff ff       	jmp    c0101d91 <__alltraps>

c010255f <vector197>:
.globl vector197
vector197:
  pushl $0
c010255f:	6a 00                	push   $0x0
  pushl $197
c0102561:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102566:	e9 26 f8 ff ff       	jmp    c0101d91 <__alltraps>

c010256b <vector198>:
.globl vector198
vector198:
  pushl $0
c010256b:	6a 00                	push   $0x0
  pushl $198
c010256d:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102572:	e9 1a f8 ff ff       	jmp    c0101d91 <__alltraps>

c0102577 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102577:	6a 00                	push   $0x0
  pushl $199
c0102579:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010257e:	e9 0e f8 ff ff       	jmp    c0101d91 <__alltraps>

c0102583 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102583:	6a 00                	push   $0x0
  pushl $200
c0102585:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010258a:	e9 02 f8 ff ff       	jmp    c0101d91 <__alltraps>

c010258f <vector201>:
.globl vector201
vector201:
  pushl $0
c010258f:	6a 00                	push   $0x0
  pushl $201
c0102591:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102596:	e9 f6 f7 ff ff       	jmp    c0101d91 <__alltraps>

c010259b <vector202>:
.globl vector202
vector202:
  pushl $0
c010259b:	6a 00                	push   $0x0
  pushl $202
c010259d:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025a2:	e9 ea f7 ff ff       	jmp    c0101d91 <__alltraps>

c01025a7 <vector203>:
.globl vector203
vector203:
  pushl $0
c01025a7:	6a 00                	push   $0x0
  pushl $203
c01025a9:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025ae:	e9 de f7 ff ff       	jmp    c0101d91 <__alltraps>

c01025b3 <vector204>:
.globl vector204
vector204:
  pushl $0
c01025b3:	6a 00                	push   $0x0
  pushl $204
c01025b5:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025ba:	e9 d2 f7 ff ff       	jmp    c0101d91 <__alltraps>

c01025bf <vector205>:
.globl vector205
vector205:
  pushl $0
c01025bf:	6a 00                	push   $0x0
  pushl $205
c01025c1:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025c6:	e9 c6 f7 ff ff       	jmp    c0101d91 <__alltraps>

c01025cb <vector206>:
.globl vector206
vector206:
  pushl $0
c01025cb:	6a 00                	push   $0x0
  pushl $206
c01025cd:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025d2:	e9 ba f7 ff ff       	jmp    c0101d91 <__alltraps>

c01025d7 <vector207>:
.globl vector207
vector207:
  pushl $0
c01025d7:	6a 00                	push   $0x0
  pushl $207
c01025d9:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025de:	e9 ae f7 ff ff       	jmp    c0101d91 <__alltraps>

c01025e3 <vector208>:
.globl vector208
vector208:
  pushl $0
c01025e3:	6a 00                	push   $0x0
  pushl $208
c01025e5:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025ea:	e9 a2 f7 ff ff       	jmp    c0101d91 <__alltraps>

c01025ef <vector209>:
.globl vector209
vector209:
  pushl $0
c01025ef:	6a 00                	push   $0x0
  pushl $209
c01025f1:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01025f6:	e9 96 f7 ff ff       	jmp    c0101d91 <__alltraps>

c01025fb <vector210>:
.globl vector210
vector210:
  pushl $0
c01025fb:	6a 00                	push   $0x0
  pushl $210
c01025fd:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102602:	e9 8a f7 ff ff       	jmp    c0101d91 <__alltraps>

c0102607 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102607:	6a 00                	push   $0x0
  pushl $211
c0102609:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010260e:	e9 7e f7 ff ff       	jmp    c0101d91 <__alltraps>

c0102613 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102613:	6a 00                	push   $0x0
  pushl $212
c0102615:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010261a:	e9 72 f7 ff ff       	jmp    c0101d91 <__alltraps>

c010261f <vector213>:
.globl vector213
vector213:
  pushl $0
c010261f:	6a 00                	push   $0x0
  pushl $213
c0102621:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102626:	e9 66 f7 ff ff       	jmp    c0101d91 <__alltraps>

c010262b <vector214>:
.globl vector214
vector214:
  pushl $0
c010262b:	6a 00                	push   $0x0
  pushl $214
c010262d:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102632:	e9 5a f7 ff ff       	jmp    c0101d91 <__alltraps>

c0102637 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102637:	6a 00                	push   $0x0
  pushl $215
c0102639:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010263e:	e9 4e f7 ff ff       	jmp    c0101d91 <__alltraps>

c0102643 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102643:	6a 00                	push   $0x0
  pushl $216
c0102645:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010264a:	e9 42 f7 ff ff       	jmp    c0101d91 <__alltraps>

c010264f <vector217>:
.globl vector217
vector217:
  pushl $0
c010264f:	6a 00                	push   $0x0
  pushl $217
c0102651:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102656:	e9 36 f7 ff ff       	jmp    c0101d91 <__alltraps>

c010265b <vector218>:
.globl vector218
vector218:
  pushl $0
c010265b:	6a 00                	push   $0x0
  pushl $218
c010265d:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102662:	e9 2a f7 ff ff       	jmp    c0101d91 <__alltraps>

c0102667 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102667:	6a 00                	push   $0x0
  pushl $219
c0102669:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010266e:	e9 1e f7 ff ff       	jmp    c0101d91 <__alltraps>

c0102673 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102673:	6a 00                	push   $0x0
  pushl $220
c0102675:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010267a:	e9 12 f7 ff ff       	jmp    c0101d91 <__alltraps>

c010267f <vector221>:
.globl vector221
vector221:
  pushl $0
c010267f:	6a 00                	push   $0x0
  pushl $221
c0102681:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102686:	e9 06 f7 ff ff       	jmp    c0101d91 <__alltraps>

c010268b <vector222>:
.globl vector222
vector222:
  pushl $0
c010268b:	6a 00                	push   $0x0
  pushl $222
c010268d:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102692:	e9 fa f6 ff ff       	jmp    c0101d91 <__alltraps>

c0102697 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102697:	6a 00                	push   $0x0
  pushl $223
c0102699:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010269e:	e9 ee f6 ff ff       	jmp    c0101d91 <__alltraps>

c01026a3 <vector224>:
.globl vector224
vector224:
  pushl $0
c01026a3:	6a 00                	push   $0x0
  pushl $224
c01026a5:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026aa:	e9 e2 f6 ff ff       	jmp    c0101d91 <__alltraps>

c01026af <vector225>:
.globl vector225
vector225:
  pushl $0
c01026af:	6a 00                	push   $0x0
  pushl $225
c01026b1:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026b6:	e9 d6 f6 ff ff       	jmp    c0101d91 <__alltraps>

c01026bb <vector226>:
.globl vector226
vector226:
  pushl $0
c01026bb:	6a 00                	push   $0x0
  pushl $226
c01026bd:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026c2:	e9 ca f6 ff ff       	jmp    c0101d91 <__alltraps>

c01026c7 <vector227>:
.globl vector227
vector227:
  pushl $0
c01026c7:	6a 00                	push   $0x0
  pushl $227
c01026c9:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026ce:	e9 be f6 ff ff       	jmp    c0101d91 <__alltraps>

c01026d3 <vector228>:
.globl vector228
vector228:
  pushl $0
c01026d3:	6a 00                	push   $0x0
  pushl $228
c01026d5:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026da:	e9 b2 f6 ff ff       	jmp    c0101d91 <__alltraps>

c01026df <vector229>:
.globl vector229
vector229:
  pushl $0
c01026df:	6a 00                	push   $0x0
  pushl $229
c01026e1:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026e6:	e9 a6 f6 ff ff       	jmp    c0101d91 <__alltraps>

c01026eb <vector230>:
.globl vector230
vector230:
  pushl $0
c01026eb:	6a 00                	push   $0x0
  pushl $230
c01026ed:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01026f2:	e9 9a f6 ff ff       	jmp    c0101d91 <__alltraps>

c01026f7 <vector231>:
.globl vector231
vector231:
  pushl $0
c01026f7:	6a 00                	push   $0x0
  pushl $231
c01026f9:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01026fe:	e9 8e f6 ff ff       	jmp    c0101d91 <__alltraps>

c0102703 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102703:	6a 00                	push   $0x0
  pushl $232
c0102705:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010270a:	e9 82 f6 ff ff       	jmp    c0101d91 <__alltraps>

c010270f <vector233>:
.globl vector233
vector233:
  pushl $0
c010270f:	6a 00                	push   $0x0
  pushl $233
c0102711:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102716:	e9 76 f6 ff ff       	jmp    c0101d91 <__alltraps>

c010271b <vector234>:
.globl vector234
vector234:
  pushl $0
c010271b:	6a 00                	push   $0x0
  pushl $234
c010271d:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102722:	e9 6a f6 ff ff       	jmp    c0101d91 <__alltraps>

c0102727 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102727:	6a 00                	push   $0x0
  pushl $235
c0102729:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010272e:	e9 5e f6 ff ff       	jmp    c0101d91 <__alltraps>

c0102733 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102733:	6a 00                	push   $0x0
  pushl $236
c0102735:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010273a:	e9 52 f6 ff ff       	jmp    c0101d91 <__alltraps>

c010273f <vector237>:
.globl vector237
vector237:
  pushl $0
c010273f:	6a 00                	push   $0x0
  pushl $237
c0102741:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102746:	e9 46 f6 ff ff       	jmp    c0101d91 <__alltraps>

c010274b <vector238>:
.globl vector238
vector238:
  pushl $0
c010274b:	6a 00                	push   $0x0
  pushl $238
c010274d:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102752:	e9 3a f6 ff ff       	jmp    c0101d91 <__alltraps>

c0102757 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102757:	6a 00                	push   $0x0
  pushl $239
c0102759:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010275e:	e9 2e f6 ff ff       	jmp    c0101d91 <__alltraps>

c0102763 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102763:	6a 00                	push   $0x0
  pushl $240
c0102765:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010276a:	e9 22 f6 ff ff       	jmp    c0101d91 <__alltraps>

c010276f <vector241>:
.globl vector241
vector241:
  pushl $0
c010276f:	6a 00                	push   $0x0
  pushl $241
c0102771:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102776:	e9 16 f6 ff ff       	jmp    c0101d91 <__alltraps>

c010277b <vector242>:
.globl vector242
vector242:
  pushl $0
c010277b:	6a 00                	push   $0x0
  pushl $242
c010277d:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102782:	e9 0a f6 ff ff       	jmp    c0101d91 <__alltraps>

c0102787 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102787:	6a 00                	push   $0x0
  pushl $243
c0102789:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010278e:	e9 fe f5 ff ff       	jmp    c0101d91 <__alltraps>

c0102793 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102793:	6a 00                	push   $0x0
  pushl $244
c0102795:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010279a:	e9 f2 f5 ff ff       	jmp    c0101d91 <__alltraps>

c010279f <vector245>:
.globl vector245
vector245:
  pushl $0
c010279f:	6a 00                	push   $0x0
  pushl $245
c01027a1:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027a6:	e9 e6 f5 ff ff       	jmp    c0101d91 <__alltraps>

c01027ab <vector246>:
.globl vector246
vector246:
  pushl $0
c01027ab:	6a 00                	push   $0x0
  pushl $246
c01027ad:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01027b2:	e9 da f5 ff ff       	jmp    c0101d91 <__alltraps>

c01027b7 <vector247>:
.globl vector247
vector247:
  pushl $0
c01027b7:	6a 00                	push   $0x0
  pushl $247
c01027b9:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027be:	e9 ce f5 ff ff       	jmp    c0101d91 <__alltraps>

c01027c3 <vector248>:
.globl vector248
vector248:
  pushl $0
c01027c3:	6a 00                	push   $0x0
  pushl $248
c01027c5:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027ca:	e9 c2 f5 ff ff       	jmp    c0101d91 <__alltraps>

c01027cf <vector249>:
.globl vector249
vector249:
  pushl $0
c01027cf:	6a 00                	push   $0x0
  pushl $249
c01027d1:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027d6:	e9 b6 f5 ff ff       	jmp    c0101d91 <__alltraps>

c01027db <vector250>:
.globl vector250
vector250:
  pushl $0
c01027db:	6a 00                	push   $0x0
  pushl $250
c01027dd:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027e2:	e9 aa f5 ff ff       	jmp    c0101d91 <__alltraps>

c01027e7 <vector251>:
.globl vector251
vector251:
  pushl $0
c01027e7:	6a 00                	push   $0x0
  pushl $251
c01027e9:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027ee:	e9 9e f5 ff ff       	jmp    c0101d91 <__alltraps>

c01027f3 <vector252>:
.globl vector252
vector252:
  pushl $0
c01027f3:	6a 00                	push   $0x0
  pushl $252
c01027f5:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01027fa:	e9 92 f5 ff ff       	jmp    c0101d91 <__alltraps>

c01027ff <vector253>:
.globl vector253
vector253:
  pushl $0
c01027ff:	6a 00                	push   $0x0
  pushl $253
c0102801:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102806:	e9 86 f5 ff ff       	jmp    c0101d91 <__alltraps>

c010280b <vector254>:
.globl vector254
vector254:
  pushl $0
c010280b:	6a 00                	push   $0x0
  pushl $254
c010280d:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102812:	e9 7a f5 ff ff       	jmp    c0101d91 <__alltraps>

c0102817 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102817:	6a 00                	push   $0x0
  pushl $255
c0102819:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010281e:	e9 6e f5 ff ff       	jmp    c0101d91 <__alltraps>

c0102823 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102823:	55                   	push   %ebp
c0102824:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102826:	8b 55 08             	mov    0x8(%ebp),%edx
c0102829:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010282e:	29 c2                	sub    %eax,%edx
c0102830:	89 d0                	mov    %edx,%eax
c0102832:	c1 f8 02             	sar    $0x2,%eax
c0102835:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010283b:	5d                   	pop    %ebp
c010283c:	c3                   	ret    

c010283d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010283d:	55                   	push   %ebp
c010283e:	89 e5                	mov    %esp,%ebp
c0102840:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102843:	8b 45 08             	mov    0x8(%ebp),%eax
c0102846:	89 04 24             	mov    %eax,(%esp)
c0102849:	e8 d5 ff ff ff       	call   c0102823 <page2ppn>
c010284e:	c1 e0 0c             	shl    $0xc,%eax
}
c0102851:	c9                   	leave  
c0102852:	c3                   	ret    

c0102853 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102853:	55                   	push   %ebp
c0102854:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102856:	8b 45 08             	mov    0x8(%ebp),%eax
c0102859:	8b 00                	mov    (%eax),%eax
}
c010285b:	5d                   	pop    %ebp
c010285c:	c3                   	ret    

c010285d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010285d:	55                   	push   %ebp
c010285e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102860:	8b 45 08             	mov    0x8(%ebp),%eax
c0102863:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102866:	89 10                	mov    %edx,(%eax)
}
c0102868:	5d                   	pop    %ebp
c0102869:	c3                   	ret    

c010286a <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010286a:	55                   	push   %ebp
c010286b:	89 e5                	mov    %esp,%ebp
c010286d:	83 ec 10             	sub    $0x10,%esp
c0102870:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102877:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010287a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010287d:	89 50 04             	mov    %edx,0x4(%eax)
c0102880:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102883:	8b 50 04             	mov    0x4(%eax),%edx
c0102886:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102889:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010288b:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102892:	00 00 00 
}
c0102895:	c9                   	leave  
c0102896:	c3                   	ret    

c0102897 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102897:	55                   	push   %ebp
c0102898:	89 e5                	mov    %esp,%ebp
c010289a:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c010289d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01028a1:	75 24                	jne    c01028c7 <default_init_memmap+0x30>
c01028a3:	c7 44 24 0c b0 66 10 	movl   $0xc01066b0,0xc(%esp)
c01028aa:	c0 
c01028ab:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01028b2:	c0 
c01028b3:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01028ba:	00 
c01028bb:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01028c2:	e8 08 e4 ff ff       	call   c0100ccf <__panic>
    struct Page *p = base;
c01028c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01028ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01028cd:	e9 a5 00 00 00       	jmp    c0102977 <default_init_memmap+0xe0>
        assert(PageReserved(p));
c01028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028d5:	83 c0 04             	add    $0x4,%eax
c01028d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01028df:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01028e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01028e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01028e8:	0f a3 10             	bt     %edx,(%eax)
c01028eb:	19 c0                	sbb    %eax,%eax
c01028ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01028f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01028f4:	0f 95 c0             	setne  %al
c01028f7:	0f b6 c0             	movzbl %al,%eax
c01028fa:	85 c0                	test   %eax,%eax
c01028fc:	75 24                	jne    c0102922 <default_init_memmap+0x8b>
c01028fe:	c7 44 24 0c e1 66 10 	movl   $0xc01066e1,0xc(%esp)
c0102905:	c0 
c0102906:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010290d:	c0 
c010290e:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0102915:	00 
c0102916:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010291d:	e8 ad e3 ff ff       	call   c0100ccf <__panic>
        p->flags = 0;
c0102922:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102925:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c010292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010292f:	83 c0 04             	add    $0x4,%eax
c0102932:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102939:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010293c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010293f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102942:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c0102945:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102948:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	if(p == base)
c010294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102952:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102955:	75 09                	jne    c0102960 <default_init_memmap+0xc9>
		p->property = n;
c0102957:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010295a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010295d:	89 50 08             	mov    %edx,0x8(%eax)
	set_page_ref(p, 0);
c0102960:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102967:	00 
c0102968:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010296b:	89 04 24             	mov    %eax,(%esp)
c010296e:	e8 ea fe ff ff       	call   c010285d <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102973:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102977:	8b 55 0c             	mov    0xc(%ebp),%edx
c010297a:	89 d0                	mov    %edx,%eax
c010297c:	c1 e0 02             	shl    $0x2,%eax
c010297f:	01 d0                	add    %edx,%eax
c0102981:	c1 e0 02             	shl    $0x2,%eax
c0102984:	89 c2                	mov    %eax,%edx
c0102986:	8b 45 08             	mov    0x8(%ebp),%eax
c0102989:	01 d0                	add    %edx,%eax
c010298b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010298e:	0f 85 3e ff ff ff    	jne    c01028d2 <default_init_memmap+0x3b>
        p->property = 0;
	if(p == base)
		p->property = n;
	set_page_ref(p, 0);
    }
    nr_free += n;
c0102994:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c010299a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010299d:	01 d0                	add    %edx,%eax
c010299f:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    list_add_before(&free_list, &(base->page_link));
c01029a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a7:	83 c0 0c             	add    $0xc,%eax
c01029aa:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c01029b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01029b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029b7:	8b 00                	mov    (%eax),%eax
c01029b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01029bc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01029bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01029c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01029c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01029ce:	89 10                	mov    %edx,(%eax)
c01029d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029d3:	8b 10                	mov    (%eax),%edx
c01029d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01029d8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01029db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029de:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01029e1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01029e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029e7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01029ea:	89 10                	mov    %edx,(%eax)
}
c01029ec:	c9                   	leave  
c01029ed:	c3                   	ret    

c01029ee <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01029ee:	55                   	push   %ebp
c01029ef:	89 e5                	mov    %esp,%ebp
c01029f1:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01029f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01029f8:	75 24                	jne    c0102a1e <default_alloc_pages+0x30>
c01029fa:	c7 44 24 0c b0 66 10 	movl   $0xc01066b0,0xc(%esp)
c0102a01:	c0 
c0102a02:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102a09:	c0 
c0102a0a:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0102a11:	00 
c0102a12:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102a19:	e8 b1 e2 ff ff       	call   c0100ccf <__panic>
    if (n > nr_free) {
c0102a1e:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102a23:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a26:	73 0a                	jae    c0102a32 <default_alloc_pages+0x44>
        return NULL;
c0102a28:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a2d:	e9 43 01 00 00       	jmp    c0102b75 <default_alloc_pages+0x187>
    }
    struct Page *page = NULL;
c0102a32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102a39:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102a40:	eb 1c                	jmp    c0102a5e <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a45:	83 e8 0c             	sub    $0xc,%eax
c0102a48:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0102a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102a4e:	8b 40 08             	mov    0x8(%eax),%eax
c0102a51:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a54:	72 08                	jb     c0102a5e <default_alloc_pages+0x70>
            page = p;
c0102a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102a5c:	eb 18                	jmp    c0102a76 <default_alloc_pages+0x88>
c0102a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a61:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102a64:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a67:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a6d:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102a74:	75 cc                	jne    c0102a42 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102a7a:	0f 84 f2 00 00 00    	je     c0102b72 <default_alloc_pages+0x184>
	int i;
        list_del(&(page->page_link));
c0102a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a83:	83 c0 0c             	add    $0xc,%eax
c0102a86:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102a89:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a8c:	8b 40 04             	mov    0x4(%eax),%eax
c0102a8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a92:	8b 12                	mov    (%edx),%edx
c0102a94:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102a97:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102a9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a9d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102aa0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102aa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102aa6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102aa9:	89 10                	mov    %edx,(%eax)
	for(i = 0 ; i < n ; i++)
c0102aab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102ab2:	eb 2e                	jmp    c0102ae2 <default_alloc_pages+0xf4>
	{
		ClearPageProperty(page + i);
c0102ab4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102ab7:	89 d0                	mov    %edx,%eax
c0102ab9:	c1 e0 02             	shl    $0x2,%eax
c0102abc:	01 d0                	add    %edx,%eax
c0102abe:	c1 e0 02             	shl    $0x2,%eax
c0102ac1:	89 c2                	mov    %eax,%edx
c0102ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ac6:	01 d0                	add    %edx,%eax
c0102ac8:	83 c0 04             	add    $0x4,%eax
c0102acb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102ad2:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ad5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102ad8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102adb:	0f b3 10             	btr    %edx,(%eax)
        }
    }
    if (page != NULL) {
	int i;
        list_del(&(page->page_link));
	for(i = 0 ; i < n ; i++)
c0102ade:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0102ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ae5:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ae8:	72 ca                	jb     c0102ab4 <default_alloc_pages+0xc6>
	{
		ClearPageProperty(page + i);
	}
        if (page->property > n) {
c0102aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aed:	8b 40 08             	mov    0x8(%eax),%eax
c0102af0:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102af3:	76 70                	jbe    c0102b65 <default_alloc_pages+0x177>
            struct Page *p = page + n;
c0102af5:	8b 55 08             	mov    0x8(%ebp),%edx
c0102af8:	89 d0                	mov    %edx,%eax
c0102afa:	c1 e0 02             	shl    $0x2,%eax
c0102afd:	01 d0                	add    %edx,%eax
c0102aff:	c1 e0 02             	shl    $0x2,%eax
c0102b02:	89 c2                	mov    %eax,%edx
c0102b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b07:	01 d0                	add    %edx,%eax
c0102b09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n;
c0102b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b0f:	8b 40 08             	mov    0x8(%eax),%eax
c0102b12:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b15:	89 c2                	mov    %eax,%edx
c0102b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b1a:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_before(&free_list, &(p->page_link));
c0102b1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b20:	83 c0 0c             	add    $0xc,%eax
c0102b23:	c7 45 c8 50 89 11 c0 	movl   $0xc0118950,-0x38(%ebp)
c0102b2a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102b2d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b30:	8b 00                	mov    (%eax),%eax
c0102b32:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b35:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102b38:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102b3b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b41:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b44:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b47:	89 10                	mov    %edx,(%eax)
c0102b49:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b4c:	8b 10                	mov    (%eax),%edx
c0102b4e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b51:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b54:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b57:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b5a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b5d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b60:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b63:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c0102b65:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102b6a:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b6d:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    }
    return page;
c0102b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102b75:	c9                   	leave  
c0102b76:	c3                   	ret    

c0102b77 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102b77:	55                   	push   %ebp
c0102b78:	89 e5                	mov    %esp,%ebp
c0102b7a:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0102b80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102b84:	75 24                	jne    c0102baa <default_free_pages+0x33>
c0102b86:	c7 44 24 0c b0 66 10 	movl   $0xc01066b0,0xc(%esp)
c0102b8d:	c0 
c0102b8e:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102b95:	c0 
c0102b96:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
c0102b9d:	00 
c0102b9e:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102ba5:	e8 25 e1 ff ff       	call   c0100ccf <__panic>
    struct Page *p = base;
c0102baa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102bb0:	e9 9d 00 00 00       	jmp    c0102c52 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bb8:	83 c0 04             	add    $0x4,%eax
c0102bbb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102bc2:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102bc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bc8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102bcb:	0f a3 10             	bt     %edx,(%eax)
c0102bce:	19 c0                	sbb    %eax,%eax
c0102bd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102bd3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102bd7:	0f 95 c0             	setne  %al
c0102bda:	0f b6 c0             	movzbl %al,%eax
c0102bdd:	85 c0                	test   %eax,%eax
c0102bdf:	75 2c                	jne    c0102c0d <default_free_pages+0x96>
c0102be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102be4:	83 c0 04             	add    $0x4,%eax
c0102be7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102bee:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102bf1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bf4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102bf7:	0f a3 10             	bt     %edx,(%eax)
c0102bfa:	19 c0                	sbb    %eax,%eax
c0102bfc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102bff:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102c03:	0f 95 c0             	setne  %al
c0102c06:	0f b6 c0             	movzbl %al,%eax
c0102c09:	85 c0                	test   %eax,%eax
c0102c0b:	74 24                	je     c0102c31 <default_free_pages+0xba>
c0102c0d:	c7 44 24 0c f4 66 10 	movl   $0xc01066f4,0xc(%esp)
c0102c14:	c0 
c0102c15:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102c1c:	c0 
c0102c1d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
c0102c24:	00 
c0102c25:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102c2c:	e8 9e e0 ff ff       	call   c0100ccf <__panic>
        p->flags = 0;
c0102c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102c3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c42:	00 
c0102c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c46:	89 04 24             	mov    %eax,(%esp)
c0102c49:	e8 0f fc ff ff       	call   c010285d <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102c4e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c52:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c55:	89 d0                	mov    %edx,%eax
c0102c57:	c1 e0 02             	shl    $0x2,%eax
c0102c5a:	01 d0                	add    %edx,%eax
c0102c5c:	c1 e0 02             	shl    $0x2,%eax
c0102c5f:	89 c2                	mov    %eax,%edx
c0102c61:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c64:	01 d0                	add    %edx,%eax
c0102c66:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102c69:	0f 85 46 ff ff ff    	jne    c0102bb5 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c72:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c75:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c7b:	83 c0 04             	add    $0x4,%eax
c0102c7e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102c85:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c88:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c8b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c8e:	0f ab 10             	bts    %edx,(%eax)
c0102c91:	c7 45 cc 50 89 11 c0 	movl   $0xc0118950,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102c98:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c9b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102ca1:	e9 08 01 00 00       	jmp    c0102dae <default_free_pages+0x237>
        p = le2page(le, page_link);
c0102ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ca9:	83 e8 0c             	sub    $0xc,%eax
c0102cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cb2:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102cb5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102cb8:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102cbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cc1:	8b 50 08             	mov    0x8(%eax),%edx
c0102cc4:	89 d0                	mov    %edx,%eax
c0102cc6:	c1 e0 02             	shl    $0x2,%eax
c0102cc9:	01 d0                	add    %edx,%eax
c0102ccb:	c1 e0 02             	shl    $0x2,%eax
c0102cce:	89 c2                	mov    %eax,%edx
c0102cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd3:	01 d0                	add    %edx,%eax
c0102cd5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cd8:	75 5a                	jne    c0102d34 <default_free_pages+0x1bd>
            base->property += p->property;
c0102cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cdd:	8b 50 08             	mov    0x8(%eax),%edx
c0102ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ce3:	8b 40 08             	mov    0x8(%eax),%eax
c0102ce6:	01 c2                	add    %eax,%edx
c0102ce8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ceb:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cf1:	83 c0 04             	add    $0x4,%eax
c0102cf4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102cfb:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cfe:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d01:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d04:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d0a:	83 c0 0c             	add    $0xc,%eax
c0102d0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102d10:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d13:	8b 40 04             	mov    0x4(%eax),%eax
c0102d16:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d19:	8b 12                	mov    (%edx),%edx
c0102d1b:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102d1e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d21:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d24:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d27:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d2a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d2d:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d30:	89 10                	mov    %edx,(%eax)
c0102d32:	eb 7a                	jmp    c0102dae <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0102d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d37:	8b 50 08             	mov    0x8(%eax),%edx
c0102d3a:	89 d0                	mov    %edx,%eax
c0102d3c:	c1 e0 02             	shl    $0x2,%eax
c0102d3f:	01 d0                	add    %edx,%eax
c0102d41:	c1 e0 02             	shl    $0x2,%eax
c0102d44:	89 c2                	mov    %eax,%edx
c0102d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d49:	01 d0                	add    %edx,%eax
c0102d4b:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d4e:	75 5e                	jne    c0102dae <default_free_pages+0x237>
            p->property += base->property;
c0102d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d53:	8b 50 08             	mov    0x8(%eax),%edx
c0102d56:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d59:	8b 40 08             	mov    0x8(%eax),%eax
c0102d5c:	01 c2                	add    %eax,%edx
c0102d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d61:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102d64:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d67:	83 c0 04             	add    $0x4,%eax
c0102d6a:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102d71:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102d74:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102d77:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102d7a:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d80:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d86:	83 c0 0c             	add    $0xc,%eax
c0102d89:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102d8c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102d8f:	8b 40 04             	mov    0x4(%eax),%eax
c0102d92:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102d95:	8b 12                	mov    (%edx),%edx
c0102d97:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102d9a:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d9d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102da0:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102da3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102da6:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102da9:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102dac:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102dae:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102db5:	0f 85 eb fe ff ff    	jne    c0102ca6 <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0102dbb:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102dc4:	01 d0                	add    %edx,%eax
c0102dc6:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    list_add_before(&free_list, &(base->page_link));
c0102dcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dce:	83 c0 0c             	add    $0xc,%eax
c0102dd1:	c7 45 9c 50 89 11 c0 	movl   $0xc0118950,-0x64(%ebp)
c0102dd8:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102ddb:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102dde:	8b 00                	mov    (%eax),%eax
c0102de0:	8b 55 98             	mov    -0x68(%ebp),%edx
c0102de3:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0102de6:	89 45 90             	mov    %eax,-0x70(%ebp)
c0102de9:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102dec:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102def:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102df2:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102df5:	89 10                	mov    %edx,(%eax)
c0102df7:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102dfa:	8b 10                	mov    (%eax),%edx
c0102dfc:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102dff:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102e02:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e05:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102e08:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102e0b:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e0e:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e11:	89 10                	mov    %edx,(%eax)
}
c0102e13:	c9                   	leave  
c0102e14:	c3                   	ret    

c0102e15 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e15:	55                   	push   %ebp
c0102e16:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e18:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102e1d:	5d                   	pop    %ebp
c0102e1e:	c3                   	ret    

c0102e1f <basic_check>:

static void
basic_check(void) {
c0102e1f:	55                   	push   %ebp
c0102e20:	89 e5                	mov    %esp,%ebp
c0102e22:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e35:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e3f:	e8 85 0e 00 00       	call   c0103cc9 <alloc_pages>
c0102e44:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e47:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e4b:	75 24                	jne    c0102e71 <basic_check+0x52>
c0102e4d:	c7 44 24 0c 19 67 10 	movl   $0xc0106719,0xc(%esp)
c0102e54:	c0 
c0102e55:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102e5c:	c0 
c0102e5d:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0102e64:	00 
c0102e65:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102e6c:	e8 5e de ff ff       	call   c0100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102e71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e78:	e8 4c 0e 00 00       	call   c0103cc9 <alloc_pages>
c0102e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102e84:	75 24                	jne    c0102eaa <basic_check+0x8b>
c0102e86:	c7 44 24 0c 35 67 10 	movl   $0xc0106735,0xc(%esp)
c0102e8d:	c0 
c0102e8e:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102e95:	c0 
c0102e96:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0102e9d:	00 
c0102e9e:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102ea5:	e8 25 de ff ff       	call   c0100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102eaa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102eb1:	e8 13 0e 00 00       	call   c0103cc9 <alloc_pages>
c0102eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102eb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102ebd:	75 24                	jne    c0102ee3 <basic_check+0xc4>
c0102ebf:	c7 44 24 0c 51 67 10 	movl   $0xc0106751,0xc(%esp)
c0102ec6:	c0 
c0102ec7:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102ece:	c0 
c0102ecf:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0102ed6:	00 
c0102ed7:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102ede:	e8 ec dd ff ff       	call   c0100ccf <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102ee3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ee6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102ee9:	74 10                	je     c0102efb <basic_check+0xdc>
c0102eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102eee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ef1:	74 08                	je     c0102efb <basic_check+0xdc>
c0102ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ef6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ef9:	75 24                	jne    c0102f1f <basic_check+0x100>
c0102efb:	c7 44 24 0c 70 67 10 	movl   $0xc0106770,0xc(%esp)
c0102f02:	c0 
c0102f03:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102f0a:	c0 
c0102f0b:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c0102f12:	00 
c0102f13:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102f1a:	e8 b0 dd ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f22:	89 04 24             	mov    %eax,(%esp)
c0102f25:	e8 29 f9 ff ff       	call   c0102853 <page_ref>
c0102f2a:	85 c0                	test   %eax,%eax
c0102f2c:	75 1e                	jne    c0102f4c <basic_check+0x12d>
c0102f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f31:	89 04 24             	mov    %eax,(%esp)
c0102f34:	e8 1a f9 ff ff       	call   c0102853 <page_ref>
c0102f39:	85 c0                	test   %eax,%eax
c0102f3b:	75 0f                	jne    c0102f4c <basic_check+0x12d>
c0102f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f40:	89 04 24             	mov    %eax,(%esp)
c0102f43:	e8 0b f9 ff ff       	call   c0102853 <page_ref>
c0102f48:	85 c0                	test   %eax,%eax
c0102f4a:	74 24                	je     c0102f70 <basic_check+0x151>
c0102f4c:	c7 44 24 0c 94 67 10 	movl   $0xc0106794,0xc(%esp)
c0102f53:	c0 
c0102f54:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102f5b:	c0 
c0102f5c:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
c0102f63:	00 
c0102f64:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102f6b:	e8 5f dd ff ff       	call   c0100ccf <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f73:	89 04 24             	mov    %eax,(%esp)
c0102f76:	e8 c2 f8 ff ff       	call   c010283d <page2pa>
c0102f7b:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f81:	c1 e2 0c             	shl    $0xc,%edx
c0102f84:	39 d0                	cmp    %edx,%eax
c0102f86:	72 24                	jb     c0102fac <basic_check+0x18d>
c0102f88:	c7 44 24 0c d0 67 10 	movl   $0xc01067d0,0xc(%esp)
c0102f8f:	c0 
c0102f90:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102f97:	c0 
c0102f98:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0102f9f:	00 
c0102fa0:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102fa7:	e8 23 dd ff ff       	call   c0100ccf <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102faf:	89 04 24             	mov    %eax,(%esp)
c0102fb2:	e8 86 f8 ff ff       	call   c010283d <page2pa>
c0102fb7:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fbd:	c1 e2 0c             	shl    $0xc,%edx
c0102fc0:	39 d0                	cmp    %edx,%eax
c0102fc2:	72 24                	jb     c0102fe8 <basic_check+0x1c9>
c0102fc4:	c7 44 24 0c ed 67 10 	movl   $0xc01067ed,0xc(%esp)
c0102fcb:	c0 
c0102fcc:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0102fd3:	c0 
c0102fd4:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c0102fdb:	00 
c0102fdc:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0102fe3:	e8 e7 dc ff ff       	call   c0100ccf <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102feb:	89 04 24             	mov    %eax,(%esp)
c0102fee:	e8 4a f8 ff ff       	call   c010283d <page2pa>
c0102ff3:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102ff9:	c1 e2 0c             	shl    $0xc,%edx
c0102ffc:	39 d0                	cmp    %edx,%eax
c0102ffe:	72 24                	jb     c0103024 <basic_check+0x205>
c0103000:	c7 44 24 0c 0a 68 10 	movl   $0xc010680a,0xc(%esp)
c0103007:	c0 
c0103008:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010300f:	c0 
c0103010:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c0103017:	00 
c0103018:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010301f:	e8 ab dc ff ff       	call   c0100ccf <__panic>

    list_entry_t free_list_store = free_list;
c0103024:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103029:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c010302f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103032:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103035:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010303c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010303f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103042:	89 50 04             	mov    %edx,0x4(%eax)
c0103045:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103048:	8b 50 04             	mov    0x4(%eax),%edx
c010304b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010304e:	89 10                	mov    %edx,(%eax)
c0103050:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103057:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010305a:	8b 40 04             	mov    0x4(%eax),%eax
c010305d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103060:	0f 94 c0             	sete   %al
c0103063:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103066:	85 c0                	test   %eax,%eax
c0103068:	75 24                	jne    c010308e <basic_check+0x26f>
c010306a:	c7 44 24 0c 27 68 10 	movl   $0xc0106827,0xc(%esp)
c0103071:	c0 
c0103072:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103079:	c0 
c010307a:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c0103081:	00 
c0103082:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103089:	e8 41 dc ff ff       	call   c0100ccf <__panic>

    unsigned int nr_free_store = nr_free;
c010308e:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103093:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103096:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c010309d:	00 00 00 

    assert(alloc_page() == NULL);
c01030a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030a7:	e8 1d 0c 00 00       	call   c0103cc9 <alloc_pages>
c01030ac:	85 c0                	test   %eax,%eax
c01030ae:	74 24                	je     c01030d4 <basic_check+0x2b5>
c01030b0:	c7 44 24 0c 3e 68 10 	movl   $0xc010683e,0xc(%esp)
c01030b7:	c0 
c01030b8:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01030bf:	c0 
c01030c0:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c01030c7:	00 
c01030c8:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01030cf:	e8 fb db ff ff       	call   c0100ccf <__panic>

    free_page(p0);
c01030d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030db:	00 
c01030dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030df:	89 04 24             	mov    %eax,(%esp)
c01030e2:	e8 1a 0c 00 00       	call   c0103d01 <free_pages>
    free_page(p1);
c01030e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030ee:	00 
c01030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030f2:	89 04 24             	mov    %eax,(%esp)
c01030f5:	e8 07 0c 00 00       	call   c0103d01 <free_pages>
    free_page(p2);
c01030fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103101:	00 
c0103102:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103105:	89 04 24             	mov    %eax,(%esp)
c0103108:	e8 f4 0b 00 00       	call   c0103d01 <free_pages>
    assert(nr_free == 3);
c010310d:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103112:	83 f8 03             	cmp    $0x3,%eax
c0103115:	74 24                	je     c010313b <basic_check+0x31c>
c0103117:	c7 44 24 0c 53 68 10 	movl   $0xc0106853,0xc(%esp)
c010311e:	c0 
c010311f:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103126:	c0 
c0103127:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c010312e:	00 
c010312f:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103136:	e8 94 db ff ff       	call   c0100ccf <__panic>

    assert((p0 = alloc_page()) != NULL);
c010313b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103142:	e8 82 0b 00 00       	call   c0103cc9 <alloc_pages>
c0103147:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010314a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010314e:	75 24                	jne    c0103174 <basic_check+0x355>
c0103150:	c7 44 24 0c 19 67 10 	movl   $0xc0106719,0xc(%esp)
c0103157:	c0 
c0103158:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010315f:	c0 
c0103160:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0103167:	00 
c0103168:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010316f:	e8 5b db ff ff       	call   c0100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103174:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010317b:	e8 49 0b 00 00       	call   c0103cc9 <alloc_pages>
c0103180:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103183:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103187:	75 24                	jne    c01031ad <basic_check+0x38e>
c0103189:	c7 44 24 0c 35 67 10 	movl   $0xc0106735,0xc(%esp)
c0103190:	c0 
c0103191:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103198:	c0 
c0103199:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c01031a0:	00 
c01031a1:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01031a8:	e8 22 db ff ff       	call   c0100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
c01031ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031b4:	e8 10 0b 00 00       	call   c0103cc9 <alloc_pages>
c01031b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031c0:	75 24                	jne    c01031e6 <basic_check+0x3c7>
c01031c2:	c7 44 24 0c 51 67 10 	movl   $0xc0106751,0xc(%esp)
c01031c9:	c0 
c01031ca:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01031d1:	c0 
c01031d2:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c01031d9:	00 
c01031da:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01031e1:	e8 e9 da ff ff       	call   c0100ccf <__panic>

    assert(alloc_page() == NULL);
c01031e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031ed:	e8 d7 0a 00 00       	call   c0103cc9 <alloc_pages>
c01031f2:	85 c0                	test   %eax,%eax
c01031f4:	74 24                	je     c010321a <basic_check+0x3fb>
c01031f6:	c7 44 24 0c 3e 68 10 	movl   $0xc010683e,0xc(%esp)
c01031fd:	c0 
c01031fe:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103205:	c0 
c0103206:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c010320d:	00 
c010320e:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103215:	e8 b5 da ff ff       	call   c0100ccf <__panic>

    free_page(p0);
c010321a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103221:	00 
c0103222:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103225:	89 04 24             	mov    %eax,(%esp)
c0103228:	e8 d4 0a 00 00       	call   c0103d01 <free_pages>
c010322d:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c0103234:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103237:	8b 40 04             	mov    0x4(%eax),%eax
c010323a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010323d:	0f 94 c0             	sete   %al
c0103240:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103243:	85 c0                	test   %eax,%eax
c0103245:	74 24                	je     c010326b <basic_check+0x44c>
c0103247:	c7 44 24 0c 60 68 10 	movl   $0xc0106860,0xc(%esp)
c010324e:	c0 
c010324f:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103256:	c0 
c0103257:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c010325e:	00 
c010325f:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103266:	e8 64 da ff ff       	call   c0100ccf <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010326b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103272:	e8 52 0a 00 00       	call   c0103cc9 <alloc_pages>
c0103277:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010327a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010327d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103280:	74 24                	je     c01032a6 <basic_check+0x487>
c0103282:	c7 44 24 0c 78 68 10 	movl   $0xc0106878,0xc(%esp)
c0103289:	c0 
c010328a:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103291:	c0 
c0103292:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103299:	00 
c010329a:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01032a1:	e8 29 da ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c01032a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032ad:	e8 17 0a 00 00       	call   c0103cc9 <alloc_pages>
c01032b2:	85 c0                	test   %eax,%eax
c01032b4:	74 24                	je     c01032da <basic_check+0x4bb>
c01032b6:	c7 44 24 0c 3e 68 10 	movl   $0xc010683e,0xc(%esp)
c01032bd:	c0 
c01032be:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01032c5:	c0 
c01032c6:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c01032cd:	00 
c01032ce:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01032d5:	e8 f5 d9 ff ff       	call   c0100ccf <__panic>

    assert(nr_free == 0);
c01032da:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01032df:	85 c0                	test   %eax,%eax
c01032e1:	74 24                	je     c0103307 <basic_check+0x4e8>
c01032e3:	c7 44 24 0c 91 68 10 	movl   $0xc0106891,0xc(%esp)
c01032ea:	c0 
c01032eb:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01032f2:	c0 
c01032f3:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c01032fa:	00 
c01032fb:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103302:	e8 c8 d9 ff ff       	call   c0100ccf <__panic>
    free_list = free_list_store;
c0103307:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010330a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010330d:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103312:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c0103318:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010331b:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c0103320:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103327:	00 
c0103328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010332b:	89 04 24             	mov    %eax,(%esp)
c010332e:	e8 ce 09 00 00       	call   c0103d01 <free_pages>
    free_page(p1);
c0103333:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010333a:	00 
c010333b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010333e:	89 04 24             	mov    %eax,(%esp)
c0103341:	e8 bb 09 00 00       	call   c0103d01 <free_pages>
    free_page(p2);
c0103346:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010334d:	00 
c010334e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103351:	89 04 24             	mov    %eax,(%esp)
c0103354:	e8 a8 09 00 00       	call   c0103d01 <free_pages>
}
c0103359:	c9                   	leave  
c010335a:	c3                   	ret    

c010335b <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010335b:	55                   	push   %ebp
c010335c:	89 e5                	mov    %esp,%ebp
c010335e:	53                   	push   %ebx
c010335f:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103365:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010336c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103373:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010337a:	eb 6b                	jmp    c01033e7 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c010337c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010337f:	83 e8 0c             	sub    $0xc,%eax
c0103382:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103385:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103388:	83 c0 04             	add    $0x4,%eax
c010338b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103392:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103395:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103398:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010339b:	0f a3 10             	bt     %edx,(%eax)
c010339e:	19 c0                	sbb    %eax,%eax
c01033a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01033a3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01033a7:	0f 95 c0             	setne  %al
c01033aa:	0f b6 c0             	movzbl %al,%eax
c01033ad:	85 c0                	test   %eax,%eax
c01033af:	75 24                	jne    c01033d5 <default_check+0x7a>
c01033b1:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c01033b8:	c0 
c01033b9:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01033c0:	c0 
c01033c1:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c01033c8:	00 
c01033c9:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01033d0:	e8 fa d8 ff ff       	call   c0100ccf <__panic>
        count ++, total += p->property;
c01033d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033dc:	8b 50 08             	mov    0x8(%eax),%edx
c01033df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033e2:	01 d0                	add    %edx,%eax
c01033e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033ea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033f0:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01033f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033f6:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01033fd:	0f 85 79 ff ff ff    	jne    c010337c <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103403:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103406:	e8 28 09 00 00       	call   c0103d33 <nr_free_pages>
c010340b:	39 c3                	cmp    %eax,%ebx
c010340d:	74 24                	je     c0103433 <default_check+0xd8>
c010340f:	c7 44 24 0c ae 68 10 	movl   $0xc01068ae,0xc(%esp)
c0103416:	c0 
c0103417:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010341e:	c0 
c010341f:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103426:	00 
c0103427:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010342e:	e8 9c d8 ff ff       	call   c0100ccf <__panic>

    basic_check();
c0103433:	e8 e7 f9 ff ff       	call   c0102e1f <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103438:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010343f:	e8 85 08 00 00       	call   c0103cc9 <alloc_pages>
c0103444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103447:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010344b:	75 24                	jne    c0103471 <default_check+0x116>
c010344d:	c7 44 24 0c c7 68 10 	movl   $0xc01068c7,0xc(%esp)
c0103454:	c0 
c0103455:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010345c:	c0 
c010345d:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103464:	00 
c0103465:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010346c:	e8 5e d8 ff ff       	call   c0100ccf <__panic>
    assert(!PageProperty(p0));
c0103471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103474:	83 c0 04             	add    $0x4,%eax
c0103477:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010347e:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103481:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103484:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103487:	0f a3 10             	bt     %edx,(%eax)
c010348a:	19 c0                	sbb    %eax,%eax
c010348c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010348f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103493:	0f 95 c0             	setne  %al
c0103496:	0f b6 c0             	movzbl %al,%eax
c0103499:	85 c0                	test   %eax,%eax
c010349b:	74 24                	je     c01034c1 <default_check+0x166>
c010349d:	c7 44 24 0c d2 68 10 	movl   $0xc01068d2,0xc(%esp)
c01034a4:	c0 
c01034a5:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01034ac:	c0 
c01034ad:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c01034b4:	00 
c01034b5:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01034bc:	e8 0e d8 ff ff       	call   c0100ccf <__panic>

    list_entry_t free_list_store = free_list;
c01034c1:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01034c6:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c01034cc:	89 45 80             	mov    %eax,-0x80(%ebp)
c01034cf:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01034d2:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01034d9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034dc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01034df:	89 50 04             	mov    %edx,0x4(%eax)
c01034e2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034e5:	8b 50 04             	mov    0x4(%eax),%edx
c01034e8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034eb:	89 10                	mov    %edx,(%eax)
c01034ed:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01034f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01034f7:	8b 40 04             	mov    0x4(%eax),%eax
c01034fa:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01034fd:	0f 94 c0             	sete   %al
c0103500:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103503:	85 c0                	test   %eax,%eax
c0103505:	75 24                	jne    c010352b <default_check+0x1d0>
c0103507:	c7 44 24 0c 27 68 10 	movl   $0xc0106827,0xc(%esp)
c010350e:	c0 
c010350f:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103516:	c0 
c0103517:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c010351e:	00 
c010351f:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103526:	e8 a4 d7 ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c010352b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103532:	e8 92 07 00 00       	call   c0103cc9 <alloc_pages>
c0103537:	85 c0                	test   %eax,%eax
c0103539:	74 24                	je     c010355f <default_check+0x204>
c010353b:	c7 44 24 0c 3e 68 10 	movl   $0xc010683e,0xc(%esp)
c0103542:	c0 
c0103543:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010354a:	c0 
c010354b:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103552:	00 
c0103553:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010355a:	e8 70 d7 ff ff       	call   c0100ccf <__panic>

    unsigned int nr_free_store = nr_free;
c010355f:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103564:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103567:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c010356e:	00 00 00 

    free_pages(p0 + 2, 3);
c0103571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103574:	83 c0 28             	add    $0x28,%eax
c0103577:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010357e:	00 
c010357f:	89 04 24             	mov    %eax,(%esp)
c0103582:	e8 7a 07 00 00       	call   c0103d01 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103587:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010358e:	e8 36 07 00 00       	call   c0103cc9 <alloc_pages>
c0103593:	85 c0                	test   %eax,%eax
c0103595:	74 24                	je     c01035bb <default_check+0x260>
c0103597:	c7 44 24 0c e4 68 10 	movl   $0xc01068e4,0xc(%esp)
c010359e:	c0 
c010359f:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01035a6:	c0 
c01035a7:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c01035ae:	00 
c01035af:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01035b6:	e8 14 d7 ff ff       	call   c0100ccf <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01035bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035be:	83 c0 28             	add    $0x28,%eax
c01035c1:	83 c0 04             	add    $0x4,%eax
c01035c4:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01035cb:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035ce:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01035d1:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01035d4:	0f a3 10             	bt     %edx,(%eax)
c01035d7:	19 c0                	sbb    %eax,%eax
c01035d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01035dc:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01035e0:	0f 95 c0             	setne  %al
c01035e3:	0f b6 c0             	movzbl %al,%eax
c01035e6:	85 c0                	test   %eax,%eax
c01035e8:	74 0e                	je     c01035f8 <default_check+0x29d>
c01035ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035ed:	83 c0 28             	add    $0x28,%eax
c01035f0:	8b 40 08             	mov    0x8(%eax),%eax
c01035f3:	83 f8 03             	cmp    $0x3,%eax
c01035f6:	74 24                	je     c010361c <default_check+0x2c1>
c01035f8:	c7 44 24 0c fc 68 10 	movl   $0xc01068fc,0xc(%esp)
c01035ff:	c0 
c0103600:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103607:	c0 
c0103608:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010360f:	00 
c0103610:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103617:	e8 b3 d6 ff ff       	call   c0100ccf <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010361c:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103623:	e8 a1 06 00 00       	call   c0103cc9 <alloc_pages>
c0103628:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010362b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010362f:	75 24                	jne    c0103655 <default_check+0x2fa>
c0103631:	c7 44 24 0c 28 69 10 	movl   $0xc0106928,0xc(%esp)
c0103638:	c0 
c0103639:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103640:	c0 
c0103641:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103648:	00 
c0103649:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103650:	e8 7a d6 ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c0103655:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010365c:	e8 68 06 00 00       	call   c0103cc9 <alloc_pages>
c0103661:	85 c0                	test   %eax,%eax
c0103663:	74 24                	je     c0103689 <default_check+0x32e>
c0103665:	c7 44 24 0c 3e 68 10 	movl   $0xc010683e,0xc(%esp)
c010366c:	c0 
c010366d:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103674:	c0 
c0103675:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c010367c:	00 
c010367d:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103684:	e8 46 d6 ff ff       	call   c0100ccf <__panic>
    assert(p0 + 2 == p1);
c0103689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010368c:	83 c0 28             	add    $0x28,%eax
c010368f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103692:	74 24                	je     c01036b8 <default_check+0x35d>
c0103694:	c7 44 24 0c 46 69 10 	movl   $0xc0106946,0xc(%esp)
c010369b:	c0 
c010369c:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01036a3:	c0 
c01036a4:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01036ab:	00 
c01036ac:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01036b3:	e8 17 d6 ff ff       	call   c0100ccf <__panic>

    p2 = p0 + 1;
c01036b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036bb:	83 c0 14             	add    $0x14,%eax
c01036be:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01036c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036c8:	00 
c01036c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036cc:	89 04 24             	mov    %eax,(%esp)
c01036cf:	e8 2d 06 00 00       	call   c0103d01 <free_pages>
    free_pages(p1, 3);
c01036d4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01036db:	00 
c01036dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036df:	89 04 24             	mov    %eax,(%esp)
c01036e2:	e8 1a 06 00 00       	call   c0103d01 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01036e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036ea:	83 c0 04             	add    $0x4,%eax
c01036ed:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01036f4:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036f7:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01036fa:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01036fd:	0f a3 10             	bt     %edx,(%eax)
c0103700:	19 c0                	sbb    %eax,%eax
c0103702:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103705:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103709:	0f 95 c0             	setne  %al
c010370c:	0f b6 c0             	movzbl %al,%eax
c010370f:	85 c0                	test   %eax,%eax
c0103711:	74 0b                	je     c010371e <default_check+0x3c3>
c0103713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103716:	8b 40 08             	mov    0x8(%eax),%eax
c0103719:	83 f8 01             	cmp    $0x1,%eax
c010371c:	74 24                	je     c0103742 <default_check+0x3e7>
c010371e:	c7 44 24 0c 54 69 10 	movl   $0xc0106954,0xc(%esp)
c0103725:	c0 
c0103726:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010372d:	c0 
c010372e:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103735:	00 
c0103736:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010373d:	e8 8d d5 ff ff       	call   c0100ccf <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103742:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103745:	83 c0 04             	add    $0x4,%eax
c0103748:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010374f:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103752:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103755:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103758:	0f a3 10             	bt     %edx,(%eax)
c010375b:	19 c0                	sbb    %eax,%eax
c010375d:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103760:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103764:	0f 95 c0             	setne  %al
c0103767:	0f b6 c0             	movzbl %al,%eax
c010376a:	85 c0                	test   %eax,%eax
c010376c:	74 0b                	je     c0103779 <default_check+0x41e>
c010376e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103771:	8b 40 08             	mov    0x8(%eax),%eax
c0103774:	83 f8 03             	cmp    $0x3,%eax
c0103777:	74 24                	je     c010379d <default_check+0x442>
c0103779:	c7 44 24 0c 7c 69 10 	movl   $0xc010697c,0xc(%esp)
c0103780:	c0 
c0103781:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103788:	c0 
c0103789:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103790:	00 
c0103791:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103798:	e8 32 d5 ff ff       	call   c0100ccf <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010379d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037a4:	e8 20 05 00 00       	call   c0103cc9 <alloc_pages>
c01037a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037af:	83 e8 14             	sub    $0x14,%eax
c01037b2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037b5:	74 24                	je     c01037db <default_check+0x480>
c01037b7:	c7 44 24 0c a2 69 10 	movl   $0xc01069a2,0xc(%esp)
c01037be:	c0 
c01037bf:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01037c6:	c0 
c01037c7:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c01037ce:	00 
c01037cf:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01037d6:	e8 f4 d4 ff ff       	call   c0100ccf <__panic>
    free_page(p0);
c01037db:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037e2:	00 
c01037e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037e6:	89 04 24             	mov    %eax,(%esp)
c01037e9:	e8 13 05 00 00       	call   c0103d01 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01037ee:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01037f5:	e8 cf 04 00 00       	call   c0103cc9 <alloc_pages>
c01037fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103800:	83 c0 14             	add    $0x14,%eax
c0103803:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103806:	74 24                	je     c010382c <default_check+0x4d1>
c0103808:	c7 44 24 0c c0 69 10 	movl   $0xc01069c0,0xc(%esp)
c010380f:	c0 
c0103810:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103817:	c0 
c0103818:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c010381f:	00 
c0103820:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103827:	e8 a3 d4 ff ff       	call   c0100ccf <__panic>

    free_pages(p0, 2);
c010382c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103833:	00 
c0103834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103837:	89 04 24             	mov    %eax,(%esp)
c010383a:	e8 c2 04 00 00       	call   c0103d01 <free_pages>
    free_page(p2);
c010383f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103846:	00 
c0103847:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010384a:	89 04 24             	mov    %eax,(%esp)
c010384d:	e8 af 04 00 00       	call   c0103d01 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103852:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103859:	e8 6b 04 00 00       	call   c0103cc9 <alloc_pages>
c010385e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103865:	75 24                	jne    c010388b <default_check+0x530>
c0103867:	c7 44 24 0c e0 69 10 	movl   $0xc01069e0,0xc(%esp)
c010386e:	c0 
c010386f:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103876:	c0 
c0103877:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c010387e:	00 
c010387f:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0103886:	e8 44 d4 ff ff       	call   c0100ccf <__panic>
    assert(alloc_page() == NULL);
c010388b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103892:	e8 32 04 00 00       	call   c0103cc9 <alloc_pages>
c0103897:	85 c0                	test   %eax,%eax
c0103899:	74 24                	je     c01038bf <default_check+0x564>
c010389b:	c7 44 24 0c 3e 68 10 	movl   $0xc010683e,0xc(%esp)
c01038a2:	c0 
c01038a3:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01038aa:	c0 
c01038ab:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01038b2:	00 
c01038b3:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01038ba:	e8 10 d4 ff ff       	call   c0100ccf <__panic>

    assert(nr_free == 0);
c01038bf:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01038c4:	85 c0                	test   %eax,%eax
c01038c6:	74 24                	je     c01038ec <default_check+0x591>
c01038c8:	c7 44 24 0c 91 68 10 	movl   $0xc0106891,0xc(%esp)
c01038cf:	c0 
c01038d0:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c01038d7:	c0 
c01038d8:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c01038df:	00 
c01038e0:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01038e7:	e8 e3 d3 ff ff       	call   c0100ccf <__panic>
    nr_free = nr_free_store;
c01038ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038ef:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c01038f4:	8b 45 80             	mov    -0x80(%ebp),%eax
c01038f7:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01038fa:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c01038ff:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c0103905:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010390c:	00 
c010390d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103910:	89 04 24             	mov    %eax,(%esp)
c0103913:	e8 e9 03 00 00       	call   c0103d01 <free_pages>

    le = &free_list;
c0103918:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010391f:	eb 1d                	jmp    c010393e <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103921:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103924:	83 e8 0c             	sub    $0xc,%eax
c0103927:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c010392a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010392e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103931:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103934:	8b 40 08             	mov    0x8(%eax),%eax
c0103937:	29 c2                	sub    %eax,%edx
c0103939:	89 d0                	mov    %edx,%eax
c010393b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010393e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103941:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103944:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103947:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010394a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010394d:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103954:	75 cb                	jne    c0103921 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103956:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010395a:	74 24                	je     c0103980 <default_check+0x625>
c010395c:	c7 44 24 0c fe 69 10 	movl   $0xc01069fe,0xc(%esp)
c0103963:	c0 
c0103964:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c010396b:	c0 
c010396c:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0103973:	00 
c0103974:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c010397b:	e8 4f d3 ff ff       	call   c0100ccf <__panic>
    assert(total == 0);
c0103980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103984:	74 24                	je     c01039aa <default_check+0x64f>
c0103986:	c7 44 24 0c 09 6a 10 	movl   $0xc0106a09,0xc(%esp)
c010398d:	c0 
c010398e:	c7 44 24 08 b6 66 10 	movl   $0xc01066b6,0x8(%esp)
c0103995:	c0 
c0103996:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c010399d:	00 
c010399e:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c01039a5:	e8 25 d3 ff ff       	call   c0100ccf <__panic>
}
c01039aa:	81 c4 94 00 00 00    	add    $0x94,%esp
c01039b0:	5b                   	pop    %ebx
c01039b1:	5d                   	pop    %ebp
c01039b2:	c3                   	ret    

c01039b3 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01039b3:	55                   	push   %ebp
c01039b4:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01039b6:	8b 55 08             	mov    0x8(%ebp),%edx
c01039b9:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01039be:	29 c2                	sub    %eax,%edx
c01039c0:	89 d0                	mov    %edx,%eax
c01039c2:	c1 f8 02             	sar    $0x2,%eax
c01039c5:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01039cb:	5d                   	pop    %ebp
c01039cc:	c3                   	ret    

c01039cd <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01039cd:	55                   	push   %ebp
c01039ce:	89 e5                	mov    %esp,%ebp
c01039d0:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01039d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01039d6:	89 04 24             	mov    %eax,(%esp)
c01039d9:	e8 d5 ff ff ff       	call   c01039b3 <page2ppn>
c01039de:	c1 e0 0c             	shl    $0xc,%eax
}
c01039e1:	c9                   	leave  
c01039e2:	c3                   	ret    

c01039e3 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01039e3:	55                   	push   %ebp
c01039e4:	89 e5                	mov    %esp,%ebp
c01039e6:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01039e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01039ec:	c1 e8 0c             	shr    $0xc,%eax
c01039ef:	89 c2                	mov    %eax,%edx
c01039f1:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01039f6:	39 c2                	cmp    %eax,%edx
c01039f8:	72 1c                	jb     c0103a16 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01039fa:	c7 44 24 08 44 6a 10 	movl   $0xc0106a44,0x8(%esp)
c0103a01:	c0 
c0103a02:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103a09:	00 
c0103a0a:	c7 04 24 63 6a 10 c0 	movl   $0xc0106a63,(%esp)
c0103a11:	e8 b9 d2 ff ff       	call   c0100ccf <__panic>
    }
    return &pages[PPN(pa)];
c0103a16:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103a1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a1f:	c1 e8 0c             	shr    $0xc,%eax
c0103a22:	89 c2                	mov    %eax,%edx
c0103a24:	89 d0                	mov    %edx,%eax
c0103a26:	c1 e0 02             	shl    $0x2,%eax
c0103a29:	01 d0                	add    %edx,%eax
c0103a2b:	c1 e0 02             	shl    $0x2,%eax
c0103a2e:	01 c8                	add    %ecx,%eax
}
c0103a30:	c9                   	leave  
c0103a31:	c3                   	ret    

c0103a32 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a32:	55                   	push   %ebp
c0103a33:	89 e5                	mov    %esp,%ebp
c0103a35:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a38:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a3b:	89 04 24             	mov    %eax,(%esp)
c0103a3e:	e8 8a ff ff ff       	call   c01039cd <page2pa>
c0103a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a49:	c1 e8 0c             	shr    $0xc,%eax
c0103a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a4f:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a54:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103a57:	72 23                	jb     c0103a7c <page2kva+0x4a>
c0103a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a5c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103a60:	c7 44 24 08 74 6a 10 	movl   $0xc0106a74,0x8(%esp)
c0103a67:	c0 
c0103a68:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103a6f:	00 
c0103a70:	c7 04 24 63 6a 10 c0 	movl   $0xc0106a63,(%esp)
c0103a77:	e8 53 d2 ff ff       	call   c0100ccf <__panic>
c0103a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a7f:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103a84:	c9                   	leave  
c0103a85:	c3                   	ret    

c0103a86 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103a86:	55                   	push   %ebp
c0103a87:	89 e5                	mov    %esp,%ebp
c0103a89:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103a8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a8f:	83 e0 01             	and    $0x1,%eax
c0103a92:	85 c0                	test   %eax,%eax
c0103a94:	75 1c                	jne    c0103ab2 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103a96:	c7 44 24 08 98 6a 10 	movl   $0xc0106a98,0x8(%esp)
c0103a9d:	c0 
c0103a9e:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103aa5:	00 
c0103aa6:	c7 04 24 63 6a 10 c0 	movl   $0xc0106a63,(%esp)
c0103aad:	e8 1d d2 ff ff       	call   c0100ccf <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ab5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103aba:	89 04 24             	mov    %eax,(%esp)
c0103abd:	e8 21 ff ff ff       	call   c01039e3 <pa2page>
}
c0103ac2:	c9                   	leave  
c0103ac3:	c3                   	ret    

c0103ac4 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103ac4:	55                   	push   %ebp
c0103ac5:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aca:	8b 00                	mov    (%eax),%eax
}
c0103acc:	5d                   	pop    %ebp
c0103acd:	c3                   	ret    

c0103ace <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103ace:	55                   	push   %ebp
c0103acf:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103ad1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ad7:	89 10                	mov    %edx,(%eax)
}
c0103ad9:	5d                   	pop    %ebp
c0103ada:	c3                   	ret    

c0103adb <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103adb:	55                   	push   %ebp
c0103adc:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103ade:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae1:	8b 00                	mov    (%eax),%eax
c0103ae3:	8d 50 01             	lea    0x1(%eax),%edx
c0103ae6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae9:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103aeb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aee:	8b 00                	mov    (%eax),%eax
}
c0103af0:	5d                   	pop    %ebp
c0103af1:	c3                   	ret    

c0103af2 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103af2:	55                   	push   %ebp
c0103af3:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103af5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af8:	8b 00                	mov    (%eax),%eax
c0103afa:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b00:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b05:	8b 00                	mov    (%eax),%eax
}
c0103b07:	5d                   	pop    %ebp
c0103b08:	c3                   	ret    

c0103b09 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103b09:	55                   	push   %ebp
c0103b0a:	89 e5                	mov    %esp,%ebp
c0103b0c:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b0f:	9c                   	pushf  
c0103b10:	58                   	pop    %eax
c0103b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b17:	25 00 02 00 00       	and    $0x200,%eax
c0103b1c:	85 c0                	test   %eax,%eax
c0103b1e:	74 0c                	je     c0103b2c <__intr_save+0x23>
        intr_disable();
c0103b20:	e8 8d db ff ff       	call   c01016b2 <intr_disable>
        return 1;
c0103b25:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b2a:	eb 05                	jmp    c0103b31 <__intr_save+0x28>
    }
    return 0;
c0103b2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b31:	c9                   	leave  
c0103b32:	c3                   	ret    

c0103b33 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b33:	55                   	push   %ebp
c0103b34:	89 e5                	mov    %esp,%ebp
c0103b36:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b3d:	74 05                	je     c0103b44 <__intr_restore+0x11>
        intr_enable();
c0103b3f:	e8 68 db ff ff       	call   c01016ac <intr_enable>
    }
}
c0103b44:	c9                   	leave  
c0103b45:	c3                   	ret    

c0103b46 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103b46:	55                   	push   %ebp
c0103b47:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b4c:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103b4f:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b54:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103b56:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b5b:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103b5d:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b62:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103b64:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b69:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103b6b:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b70:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103b72:	ea 79 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103b79
}
c0103b79:	5d                   	pop    %ebp
c0103b7a:	c3                   	ret    

c0103b7b <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103b7b:	55                   	push   %ebp
c0103b7c:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103b7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b81:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103b86:	5d                   	pop    %ebp
c0103b87:	c3                   	ret    

c0103b88 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103b88:	55                   	push   %ebp
c0103b89:	89 e5                	mov    %esp,%ebp
c0103b8b:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103b8e:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103b93:	89 04 24             	mov    %eax,(%esp)
c0103b96:	e8 e0 ff ff ff       	call   c0103b7b <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103b9b:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103ba2:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103ba4:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103bab:	68 00 
c0103bad:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103bb2:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103bb8:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103bbd:	c1 e8 10             	shr    $0x10,%eax
c0103bc0:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103bc5:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bcc:	83 e0 f0             	and    $0xfffffff0,%eax
c0103bcf:	83 c8 09             	or     $0x9,%eax
c0103bd2:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bd7:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bde:	83 e0 ef             	and    $0xffffffef,%eax
c0103be1:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103be6:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bed:	83 e0 9f             	and    $0xffffff9f,%eax
c0103bf0:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bf5:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bfc:	83 c8 80             	or     $0xffffff80,%eax
c0103bff:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c04:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c0b:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c0e:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c13:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c1a:	83 e0 ef             	and    $0xffffffef,%eax
c0103c1d:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c22:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c29:	83 e0 df             	and    $0xffffffdf,%eax
c0103c2c:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c31:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c38:	83 c8 40             	or     $0x40,%eax
c0103c3b:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c40:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c47:	83 e0 7f             	and    $0x7f,%eax
c0103c4a:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c4f:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c54:	c1 e8 18             	shr    $0x18,%eax
c0103c57:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103c5c:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103c63:	e8 de fe ff ff       	call   c0103b46 <lgdt>
c0103c68:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103c6e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103c72:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103c75:	c9                   	leave  
c0103c76:	c3                   	ret    

c0103c77 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103c77:	55                   	push   %ebp
c0103c78:	89 e5                	mov    %esp,%ebp
c0103c7a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103c7d:	c7 05 5c 89 11 c0 28 	movl   $0xc0106a28,0xc011895c
c0103c84:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103c87:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c8c:	8b 00                	mov    (%eax),%eax
c0103c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c92:	c7 04 24 c4 6a 10 c0 	movl   $0xc0106ac4,(%esp)
c0103c99:	e8 9e c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103c9e:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103ca3:	8b 40 04             	mov    0x4(%eax),%eax
c0103ca6:	ff d0                	call   *%eax
}
c0103ca8:	c9                   	leave  
c0103ca9:	c3                   	ret    

c0103caa <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103caa:	55                   	push   %ebp
c0103cab:	89 e5                	mov    %esp,%ebp
c0103cad:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103cb0:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cb5:	8b 40 08             	mov    0x8(%eax),%eax
c0103cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103cbb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cbf:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cc2:	89 14 24             	mov    %edx,(%esp)
c0103cc5:	ff d0                	call   *%eax
}
c0103cc7:	c9                   	leave  
c0103cc8:	c3                   	ret    

c0103cc9 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103cc9:	55                   	push   %ebp
c0103cca:	89 e5                	mov    %esp,%ebp
c0103ccc:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103ccf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103cd6:	e8 2e fe ff ff       	call   c0103b09 <__intr_save>
c0103cdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103cde:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103ce3:	8b 40 0c             	mov    0xc(%eax),%eax
c0103ce6:	8b 55 08             	mov    0x8(%ebp),%edx
c0103ce9:	89 14 24             	mov    %edx,(%esp)
c0103cec:	ff d0                	call   *%eax
c0103cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cf4:	89 04 24             	mov    %eax,(%esp)
c0103cf7:	e8 37 fe ff ff       	call   c0103b33 <__intr_restore>
    return page;
c0103cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103cff:	c9                   	leave  
c0103d00:	c3                   	ret    

c0103d01 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103d01:	55                   	push   %ebp
c0103d02:	89 e5                	mov    %esp,%ebp
c0103d04:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d07:	e8 fd fd ff ff       	call   c0103b09 <__intr_save>
c0103d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d0f:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d14:	8b 40 10             	mov    0x10(%eax),%eax
c0103d17:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d1a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d1e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d21:	89 14 24             	mov    %edx,(%esp)
c0103d24:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d29:	89 04 24             	mov    %eax,(%esp)
c0103d2c:	e8 02 fe ff ff       	call   c0103b33 <__intr_restore>
}
c0103d31:	c9                   	leave  
c0103d32:	c3                   	ret    

c0103d33 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d33:	55                   	push   %ebp
c0103d34:	89 e5                	mov    %esp,%ebp
c0103d36:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d39:	e8 cb fd ff ff       	call   c0103b09 <__intr_save>
c0103d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103d41:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d46:	8b 40 14             	mov    0x14(%eax),%eax
c0103d49:	ff d0                	call   *%eax
c0103d4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d51:	89 04 24             	mov    %eax,(%esp)
c0103d54:	e8 da fd ff ff       	call   c0103b33 <__intr_restore>
    return ret;
c0103d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103d5c:	c9                   	leave  
c0103d5d:	c3                   	ret    

c0103d5e <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103d5e:	55                   	push   %ebp
c0103d5f:	89 e5                	mov    %esp,%ebp
c0103d61:	57                   	push   %edi
c0103d62:	56                   	push   %esi
c0103d63:	53                   	push   %ebx
c0103d64:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103d6a:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103d71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103d78:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103d7f:	c7 04 24 db 6a 10 c0 	movl   $0xc0106adb,(%esp)
c0103d86:	e8 b1 c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103d8b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103d92:	e9 15 01 00 00       	jmp    c0103eac <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103d97:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d9d:	89 d0                	mov    %edx,%eax
c0103d9f:	c1 e0 02             	shl    $0x2,%eax
c0103da2:	01 d0                	add    %edx,%eax
c0103da4:	c1 e0 02             	shl    $0x2,%eax
c0103da7:	01 c8                	add    %ecx,%eax
c0103da9:	8b 50 08             	mov    0x8(%eax),%edx
c0103dac:	8b 40 04             	mov    0x4(%eax),%eax
c0103daf:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103db2:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103db5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103db8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dbb:	89 d0                	mov    %edx,%eax
c0103dbd:	c1 e0 02             	shl    $0x2,%eax
c0103dc0:	01 d0                	add    %edx,%eax
c0103dc2:	c1 e0 02             	shl    $0x2,%eax
c0103dc5:	01 c8                	add    %ecx,%eax
c0103dc7:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103dca:	8b 58 10             	mov    0x10(%eax),%ebx
c0103dcd:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103dd0:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103dd3:	01 c8                	add    %ecx,%eax
c0103dd5:	11 da                	adc    %ebx,%edx
c0103dd7:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103dda:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103ddd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103de0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103de3:	89 d0                	mov    %edx,%eax
c0103de5:	c1 e0 02             	shl    $0x2,%eax
c0103de8:	01 d0                	add    %edx,%eax
c0103dea:	c1 e0 02             	shl    $0x2,%eax
c0103ded:	01 c8                	add    %ecx,%eax
c0103def:	83 c0 14             	add    $0x14,%eax
c0103df2:	8b 00                	mov    (%eax),%eax
c0103df4:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103dfa:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103dfd:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e00:	83 c0 ff             	add    $0xffffffff,%eax
c0103e03:	83 d2 ff             	adc    $0xffffffff,%edx
c0103e06:	89 c6                	mov    %eax,%esi
c0103e08:	89 d7                	mov    %edx,%edi
c0103e0a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e10:	89 d0                	mov    %edx,%eax
c0103e12:	c1 e0 02             	shl    $0x2,%eax
c0103e15:	01 d0                	add    %edx,%eax
c0103e17:	c1 e0 02             	shl    $0x2,%eax
c0103e1a:	01 c8                	add    %ecx,%eax
c0103e1c:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e1f:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e22:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e28:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e2c:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e30:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e34:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e37:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e3e:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103e42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e46:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103e4a:	c7 04 24 e8 6a 10 c0 	movl   $0xc0106ae8,(%esp)
c0103e51:	e8 e6 c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103e56:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e59:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e5c:	89 d0                	mov    %edx,%eax
c0103e5e:	c1 e0 02             	shl    $0x2,%eax
c0103e61:	01 d0                	add    %edx,%eax
c0103e63:	c1 e0 02             	shl    $0x2,%eax
c0103e66:	01 c8                	add    %ecx,%eax
c0103e68:	83 c0 14             	add    $0x14,%eax
c0103e6b:	8b 00                	mov    (%eax),%eax
c0103e6d:	83 f8 01             	cmp    $0x1,%eax
c0103e70:	75 36                	jne    c0103ea8 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103e72:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e78:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e7b:	77 2b                	ja     c0103ea8 <page_init+0x14a>
c0103e7d:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e80:	72 05                	jb     c0103e87 <page_init+0x129>
c0103e82:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103e85:	73 21                	jae    c0103ea8 <page_init+0x14a>
c0103e87:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e8b:	77 1b                	ja     c0103ea8 <page_init+0x14a>
c0103e8d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e91:	72 09                	jb     c0103e9c <page_init+0x13e>
c0103e93:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103e9a:	77 0c                	ja     c0103ea8 <page_init+0x14a>
                maxpa = end;
c0103e9c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e9f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ea2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103ea5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103ea8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103eac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103eaf:	8b 00                	mov    (%eax),%eax
c0103eb1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103eb4:	0f 8f dd fe ff ff    	jg     c0103d97 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103eba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ebe:	72 1d                	jb     c0103edd <page_init+0x17f>
c0103ec0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ec4:	77 09                	ja     c0103ecf <page_init+0x171>
c0103ec6:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103ecd:	76 0e                	jbe    c0103edd <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103ecf:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103ed6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ee0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ee3:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103ee7:	c1 ea 0c             	shr    $0xc,%edx
c0103eea:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103eef:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103ef6:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103efb:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103efe:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f01:	01 d0                	add    %edx,%eax
c0103f03:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103f06:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f09:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f0e:	f7 75 ac             	divl   -0x54(%ebp)
c0103f11:	89 d0                	mov    %edx,%eax
c0103f13:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f16:	29 c2                	sub    %eax,%edx
c0103f18:	89 d0                	mov    %edx,%eax
c0103f1a:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103f1f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f26:	eb 2f                	jmp    c0103f57 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f28:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103f2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f31:	89 d0                	mov    %edx,%eax
c0103f33:	c1 e0 02             	shl    $0x2,%eax
c0103f36:	01 d0                	add    %edx,%eax
c0103f38:	c1 e0 02             	shl    $0x2,%eax
c0103f3b:	01 c8                	add    %ecx,%eax
c0103f3d:	83 c0 04             	add    $0x4,%eax
c0103f40:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103f47:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103f4a:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103f4d:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103f50:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103f53:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f57:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f5a:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103f5f:	39 c2                	cmp    %eax,%edx
c0103f61:	72 c5                	jb     c0103f28 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103f63:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103f69:	89 d0                	mov    %edx,%eax
c0103f6b:	c1 e0 02             	shl    $0x2,%eax
c0103f6e:	01 d0                	add    %edx,%eax
c0103f70:	c1 e0 02             	shl    $0x2,%eax
c0103f73:	89 c2                	mov    %eax,%edx
c0103f75:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103f7a:	01 d0                	add    %edx,%eax
c0103f7c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103f7f:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103f86:	77 23                	ja     c0103fab <page_init+0x24d>
c0103f88:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f8f:	c7 44 24 08 18 6b 10 	movl   $0xc0106b18,0x8(%esp)
c0103f96:	c0 
c0103f97:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103f9e:	00 
c0103f9f:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0103fa6:	e8 24 cd ff ff       	call   c0100ccf <__panic>
c0103fab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fae:	05 00 00 00 40       	add    $0x40000000,%eax
c0103fb3:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103fb6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fbd:	e9 74 01 00 00       	jmp    c0104136 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103fc2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fc8:	89 d0                	mov    %edx,%eax
c0103fca:	c1 e0 02             	shl    $0x2,%eax
c0103fcd:	01 d0                	add    %edx,%eax
c0103fcf:	c1 e0 02             	shl    $0x2,%eax
c0103fd2:	01 c8                	add    %ecx,%eax
c0103fd4:	8b 50 08             	mov    0x8(%eax),%edx
c0103fd7:	8b 40 04             	mov    0x4(%eax),%eax
c0103fda:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103fdd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103fe0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fe3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fe6:	89 d0                	mov    %edx,%eax
c0103fe8:	c1 e0 02             	shl    $0x2,%eax
c0103feb:	01 d0                	add    %edx,%eax
c0103fed:	c1 e0 02             	shl    $0x2,%eax
c0103ff0:	01 c8                	add    %ecx,%eax
c0103ff2:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103ff5:	8b 58 10             	mov    0x10(%eax),%ebx
c0103ff8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103ffb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103ffe:	01 c8                	add    %ecx,%eax
c0104000:	11 da                	adc    %ebx,%edx
c0104002:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104005:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104008:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010400b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010400e:	89 d0                	mov    %edx,%eax
c0104010:	c1 e0 02             	shl    $0x2,%eax
c0104013:	01 d0                	add    %edx,%eax
c0104015:	c1 e0 02             	shl    $0x2,%eax
c0104018:	01 c8                	add    %ecx,%eax
c010401a:	83 c0 14             	add    $0x14,%eax
c010401d:	8b 00                	mov    (%eax),%eax
c010401f:	83 f8 01             	cmp    $0x1,%eax
c0104022:	0f 85 0a 01 00 00    	jne    c0104132 <page_init+0x3d4>
            if (begin < freemem) {
c0104028:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010402b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104030:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104033:	72 17                	jb     c010404c <page_init+0x2ee>
c0104035:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104038:	77 05                	ja     c010403f <page_init+0x2e1>
c010403a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010403d:	76 0d                	jbe    c010404c <page_init+0x2ee>
                begin = freemem;
c010403f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104042:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104045:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010404c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104050:	72 1d                	jb     c010406f <page_init+0x311>
c0104052:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104056:	77 09                	ja     c0104061 <page_init+0x303>
c0104058:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010405f:	76 0e                	jbe    c010406f <page_init+0x311>
                end = KMEMSIZE;
c0104061:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104068:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010406f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104072:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104075:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104078:	0f 87 b4 00 00 00    	ja     c0104132 <page_init+0x3d4>
c010407e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104081:	72 09                	jb     c010408c <page_init+0x32e>
c0104083:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104086:	0f 83 a6 00 00 00    	jae    c0104132 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c010408c:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104093:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104096:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104099:	01 d0                	add    %edx,%eax
c010409b:	83 e8 01             	sub    $0x1,%eax
c010409e:	89 45 98             	mov    %eax,-0x68(%ebp)
c01040a1:	8b 45 98             	mov    -0x68(%ebp),%eax
c01040a4:	ba 00 00 00 00       	mov    $0x0,%edx
c01040a9:	f7 75 9c             	divl   -0x64(%ebp)
c01040ac:	89 d0                	mov    %edx,%eax
c01040ae:	8b 55 98             	mov    -0x68(%ebp),%edx
c01040b1:	29 c2                	sub    %eax,%edx
c01040b3:	89 d0                	mov    %edx,%eax
c01040b5:	ba 00 00 00 00       	mov    $0x0,%edx
c01040ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040bd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01040c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040c3:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01040c6:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01040c9:	ba 00 00 00 00       	mov    $0x0,%edx
c01040ce:	89 c7                	mov    %eax,%edi
c01040d0:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01040d6:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01040d9:	89 d0                	mov    %edx,%eax
c01040db:	83 e0 00             	and    $0x0,%eax
c01040de:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01040e1:	8b 45 80             	mov    -0x80(%ebp),%eax
c01040e4:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01040e7:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01040ea:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01040ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040f3:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040f6:	77 3a                	ja     c0104132 <page_init+0x3d4>
c01040f8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040fb:	72 05                	jb     c0104102 <page_init+0x3a4>
c01040fd:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104100:	73 30                	jae    c0104132 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104102:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104105:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104108:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010410b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010410e:	29 c8                	sub    %ecx,%eax
c0104110:	19 da                	sbb    %ebx,%edx
c0104112:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104116:	c1 ea 0c             	shr    $0xc,%edx
c0104119:	89 c3                	mov    %eax,%ebx
c010411b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010411e:	89 04 24             	mov    %eax,(%esp)
c0104121:	e8 bd f8 ff ff       	call   c01039e3 <pa2page>
c0104126:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010412a:	89 04 24             	mov    %eax,(%esp)
c010412d:	e8 78 fb ff ff       	call   c0103caa <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104132:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104136:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104139:	8b 00                	mov    (%eax),%eax
c010413b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010413e:	0f 8f 7e fe ff ff    	jg     c0103fc2 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104144:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010414a:	5b                   	pop    %ebx
c010414b:	5e                   	pop    %esi
c010414c:	5f                   	pop    %edi
c010414d:	5d                   	pop    %ebp
c010414e:	c3                   	ret    

c010414f <enable_paging>:

static void
enable_paging(void) {
c010414f:	55                   	push   %ebp
c0104150:	89 e5                	mov    %esp,%ebp
c0104152:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104155:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c010415a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010415d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104160:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104163:	0f 20 c0             	mov    %cr0,%eax
c0104166:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104169:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c010416c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010416f:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104176:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c010417a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010417d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104180:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104183:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104186:	c9                   	leave  
c0104187:	c3                   	ret    

c0104188 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104188:	55                   	push   %ebp
c0104189:	89 e5                	mov    %esp,%ebp
c010418b:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010418e:	8b 45 14             	mov    0x14(%ebp),%eax
c0104191:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104194:	31 d0                	xor    %edx,%eax
c0104196:	25 ff 0f 00 00       	and    $0xfff,%eax
c010419b:	85 c0                	test   %eax,%eax
c010419d:	74 24                	je     c01041c3 <boot_map_segment+0x3b>
c010419f:	c7 44 24 0c 4a 6b 10 	movl   $0xc0106b4a,0xc(%esp)
c01041a6:	c0 
c01041a7:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c01041ae:	c0 
c01041af:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01041b6:	00 
c01041b7:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c01041be:	e8 0c cb ff ff       	call   c0100ccf <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01041c3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01041ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041cd:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041d2:	89 c2                	mov    %eax,%edx
c01041d4:	8b 45 10             	mov    0x10(%ebp),%eax
c01041d7:	01 c2                	add    %eax,%edx
c01041d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041dc:	01 d0                	add    %edx,%eax
c01041de:	83 e8 01             	sub    $0x1,%eax
c01041e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01041e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041e7:	ba 00 00 00 00       	mov    $0x0,%edx
c01041ec:	f7 75 f0             	divl   -0x10(%ebp)
c01041ef:	89 d0                	mov    %edx,%eax
c01041f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01041f4:	29 c2                	sub    %eax,%edx
c01041f6:	89 d0                	mov    %edx,%eax
c01041f8:	c1 e8 0c             	shr    $0xc,%eax
c01041fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01041fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104201:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104204:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010420c:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010420f:	8b 45 14             	mov    0x14(%ebp),%eax
c0104212:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104215:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104218:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010421d:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104220:	eb 6b                	jmp    c010428d <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104222:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104229:	00 
c010422a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010422d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104231:	8b 45 08             	mov    0x8(%ebp),%eax
c0104234:	89 04 24             	mov    %eax,(%esp)
c0104237:	e8 cc 01 00 00       	call   c0104408 <get_pte>
c010423c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010423f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104243:	75 24                	jne    c0104269 <boot_map_segment+0xe1>
c0104245:	c7 44 24 0c 76 6b 10 	movl   $0xc0106b76,0xc(%esp)
c010424c:	c0 
c010424d:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104254:	c0 
c0104255:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c010425c:	00 
c010425d:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104264:	e8 66 ca ff ff       	call   c0100ccf <__panic>
        *ptep = pa | PTE_P | perm;
c0104269:	8b 45 18             	mov    0x18(%ebp),%eax
c010426c:	8b 55 14             	mov    0x14(%ebp),%edx
c010426f:	09 d0                	or     %edx,%eax
c0104271:	83 c8 01             	or     $0x1,%eax
c0104274:	89 c2                	mov    %eax,%edx
c0104276:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104279:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010427b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010427f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104286:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010428d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104291:	75 8f                	jne    c0104222 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104293:	c9                   	leave  
c0104294:	c3                   	ret    

c0104295 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104295:	55                   	push   %ebp
c0104296:	89 e5                	mov    %esp,%ebp
c0104298:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010429b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042a2:	e8 22 fa ff ff       	call   c0103cc9 <alloc_pages>
c01042a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01042aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042ae:	75 1c                	jne    c01042cc <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01042b0:	c7 44 24 08 83 6b 10 	movl   $0xc0106b83,0x8(%esp)
c01042b7:	c0 
c01042b8:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01042bf:	00 
c01042c0:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c01042c7:	e8 03 ca ff ff       	call   c0100ccf <__panic>
    }
    return page2kva(p);
c01042cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042cf:	89 04 24             	mov    %eax,(%esp)
c01042d2:	e8 5b f7 ff ff       	call   c0103a32 <page2kva>
}
c01042d7:	c9                   	leave  
c01042d8:	c3                   	ret    

c01042d9 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01042d9:	55                   	push   %ebp
c01042da:	89 e5                	mov    %esp,%ebp
c01042dc:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01042df:	e8 93 f9 ff ff       	call   c0103c77 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01042e4:	e8 75 fa ff ff       	call   c0103d5e <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01042e9:	e8 84 04 00 00       	call   c0104772 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01042ee:	e8 a2 ff ff ff       	call   c0104295 <boot_alloc_page>
c01042f3:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c01042f8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042fd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104304:	00 
c0104305:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010430c:	00 
c010430d:	89 04 24             	mov    %eax,(%esp)
c0104310:	e8 c6 1a 00 00       	call   c0105ddb <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104315:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010431a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010431d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104324:	77 23                	ja     c0104349 <pmm_init+0x70>
c0104326:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104329:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010432d:	c7 44 24 08 18 6b 10 	movl   $0xc0106b18,0x8(%esp)
c0104334:	c0 
c0104335:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c010433c:	00 
c010433d:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104344:	e8 86 c9 ff ff       	call   c0100ccf <__panic>
c0104349:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434c:	05 00 00 00 40       	add    $0x40000000,%eax
c0104351:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c0104356:	e8 35 04 00 00       	call   c0104790 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010435b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104360:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104366:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010436b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010436e:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104375:	77 23                	ja     c010439a <pmm_init+0xc1>
c0104377:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010437a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010437e:	c7 44 24 08 18 6b 10 	movl   $0xc0106b18,0x8(%esp)
c0104385:	c0 
c0104386:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c010438d:	00 
c010438e:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104395:	e8 35 c9 ff ff       	call   c0100ccf <__panic>
c010439a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010439d:	05 00 00 00 40       	add    $0x40000000,%eax
c01043a2:	83 c8 03             	or     $0x3,%eax
c01043a5:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01043a7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043ac:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01043b3:	00 
c01043b4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01043bb:	00 
c01043bc:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01043c3:	38 
c01043c4:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01043cb:	c0 
c01043cc:	89 04 24             	mov    %eax,(%esp)
c01043cf:	e8 b4 fd ff ff       	call   c0104188 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01043d4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043d9:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c01043df:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01043e5:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01043e7:	e8 63 fd ff ff       	call   c010414f <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01043ec:	e8 97 f7 ff ff       	call   c0103b88 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01043f1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01043fc:	e8 2a 0a 00 00       	call   c0104e2b <check_boot_pgdir>

    print_pgdir();
c0104401:	e8 b7 0e 00 00       	call   c01052bd <print_pgdir>

}
c0104406:	c9                   	leave  
c0104407:	c3                   	ret    

c0104408 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104408:	55                   	push   %ebp
c0104409:	89 e5                	mov    %esp,%ebp
c010440b:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = pgdir + PDX(la); // (1)
c010440e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104411:	c1 e8 16             	shr    $0x16,%eax
c0104414:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010441b:	8b 45 08             	mov    0x8(%ebp),%eax
c010441e:	01 d0                	add    %edx,%eax
c0104420:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*pdep & PTE_P)) // (2)
c0104423:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104426:	8b 00                	mov    (%eax),%eax
c0104428:	83 e0 01             	and    $0x1,%eax
c010442b:	85 c0                	test   %eax,%eax
c010442d:	0f 85 b9 00 00 00    	jne    c01044ec <get_pte+0xe4>
    {
        if(!create) // (3)
c0104433:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104437:	75 0a                	jne    c0104443 <get_pte+0x3b>
            return NULL;
c0104439:	b8 00 00 00 00       	mov    $0x0,%eax
c010443e:	e9 0e 01 00 00       	jmp    c0104551 <get_pte+0x149>
        struct Page *page = alloc_page();
c0104443:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010444a:	e8 7a f8 ff ff       	call   c0103cc9 <alloc_pages>
c010444f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(page == NULL)
c0104452:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104456:	75 0a                	jne    c0104462 <get_pte+0x5a>
            return NULL;
c0104458:	b8 00 00 00 00       	mov    $0x0,%eax
c010445d:	e9 ef 00 00 00       	jmp    c0104551 <get_pte+0x149>
        set_page_ref(page, 1); // (4)
c0104462:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104469:	00 
c010446a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010446d:	89 04 24             	mov    %eax,(%esp)
c0104470:	e8 59 f6 ff ff       	call   c0103ace <set_page_ref>
        uintptr_t pa = page2pa(page); // (5)
c0104475:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104478:	89 04 24             	mov    %eax,(%esp)
c010447b:	e8 4d f5 ff ff       	call   c01039cd <page2pa>
c0104480:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE); // (6)
c0104483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104486:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104489:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010448c:	c1 e8 0c             	shr    $0xc,%eax
c010448f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104492:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104497:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010449a:	72 23                	jb     c01044bf <get_pte+0xb7>
c010449c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010449f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044a3:	c7 44 24 08 74 6a 10 	movl   $0xc0106a74,0x8(%esp)
c01044aa:	c0 
c01044ab:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
c01044b2:	00 
c01044b3:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c01044ba:	e8 10 c8 ff ff       	call   c0100ccf <__panic>
c01044bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044c2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01044c7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01044ce:	00 
c01044cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01044d6:	00 
c01044d7:	89 04 24             	mov    %eax,(%esp)
c01044da:	e8 fc 18 00 00       	call   c0105ddb <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c01044df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044e2:	83 c8 07             	or     $0x7,%eax
c01044e5:	89 c2                	mov    %eax,%edx
c01044e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ea:	89 10                	mov    %edx,(%eax)
    }
    pte_t *ptep = (pte_t *)KADDR(PDE_ADDR(*pdep));
c01044ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ef:	8b 00                	mov    (%eax),%eax
c01044f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01044f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01044f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044fc:	c1 e8 0c             	shr    $0xc,%eax
c01044ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104502:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104507:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010450a:	72 23                	jb     c010452f <get_pte+0x127>
c010450c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010450f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104513:	c7 44 24 08 74 6a 10 	movl   $0xc0106a74,0x8(%esp)
c010451a:	c0 
c010451b:	c7 44 24 04 8c 01 00 	movl   $0x18c,0x4(%esp)
c0104522:	00 
c0104523:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c010452a:	e8 a0 c7 ff ff       	call   c0100ccf <__panic>
c010452f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104532:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104537:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return ptep + PTX(la); // (8)
c010453a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010453d:	c1 e8 0c             	shr    $0xc,%eax
c0104540:	25 ff 03 00 00       	and    $0x3ff,%eax
c0104545:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010454c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010454f:	01 d0                	add    %edx,%eax
}
c0104551:	c9                   	leave  
c0104552:	c3                   	ret    

c0104553 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104553:	55                   	push   %ebp
c0104554:	89 e5                	mov    %esp,%ebp
c0104556:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104559:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104560:	00 
c0104561:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104564:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104568:	8b 45 08             	mov    0x8(%ebp),%eax
c010456b:	89 04 24             	mov    %eax,(%esp)
c010456e:	e8 95 fe ff ff       	call   c0104408 <get_pte>
c0104573:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104576:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010457a:	74 08                	je     c0104584 <get_page+0x31>
        *ptep_store = ptep;
c010457c:	8b 45 10             	mov    0x10(%ebp),%eax
c010457f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104582:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104584:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104588:	74 1b                	je     c01045a5 <get_page+0x52>
c010458a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010458d:	8b 00                	mov    (%eax),%eax
c010458f:	83 e0 01             	and    $0x1,%eax
c0104592:	85 c0                	test   %eax,%eax
c0104594:	74 0f                	je     c01045a5 <get_page+0x52>
        return pa2page(*ptep);
c0104596:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104599:	8b 00                	mov    (%eax),%eax
c010459b:	89 04 24             	mov    %eax,(%esp)
c010459e:	e8 40 f4 ff ff       	call   c01039e3 <pa2page>
c01045a3:	eb 05                	jmp    c01045aa <get_page+0x57>
    }
    return NULL;
c01045a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045aa:	c9                   	leave  
c01045ab:	c3                   	ret    

c01045ac <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01045ac:	55                   	push   %ebp
c01045ad:	89 e5                	mov    %esp,%ebp
c01045af:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P) // (1)
c01045b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01045b5:	8b 00                	mov    (%eax),%eax
c01045b7:	83 e0 01             	and    $0x1,%eax
c01045ba:	85 c0                	test   %eax,%eax
c01045bc:	74 58                	je     c0104616 <page_remove_pte+0x6a>
    {
        struct Page *page = pte2page(*ptep); // (2)
c01045be:	8b 45 10             	mov    0x10(%ebp),%eax
c01045c1:	8b 00                	mov    (%eax),%eax
c01045c3:	89 04 24             	mov    %eax,(%esp)
c01045c6:	e8 bb f4 ff ff       	call   c0103a86 <pte2page>
c01045cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page); // (3)
c01045ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045d1:	89 04 24             	mov    %eax,(%esp)
c01045d4:	e8 19 f5 ff ff       	call   c0103af2 <page_ref_dec>
        if(page_ref(page) == 0) // (4)
c01045d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045dc:	89 04 24             	mov    %eax,(%esp)
c01045df:	e8 e0 f4 ff ff       	call   c0103ac4 <page_ref>
c01045e4:	85 c0                	test   %eax,%eax
c01045e6:	75 13                	jne    c01045fb <page_remove_pte+0x4f>
            free_page(page);
c01045e8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01045ef:	00 
c01045f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f3:	89 04 24             	mov    %eax,(%esp)
c01045f6:	e8 06 f7 ff ff       	call   c0103d01 <free_pages>
        *ptep = 0; // (5)
c01045fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01045fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la); // (6)
c0104604:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104607:	89 44 24 04          	mov    %eax,0x4(%esp)
c010460b:	8b 45 08             	mov    0x8(%ebp),%eax
c010460e:	89 04 24             	mov    %eax,(%esp)
c0104611:	e8 ff 00 00 00       	call   c0104715 <tlb_invalidate>
    }
}
c0104616:	c9                   	leave  
c0104617:	c3                   	ret    

c0104618 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104618:	55                   	push   %ebp
c0104619:	89 e5                	mov    %esp,%ebp
c010461b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010461e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104625:	00 
c0104626:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104629:	89 44 24 04          	mov    %eax,0x4(%esp)
c010462d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104630:	89 04 24             	mov    %eax,(%esp)
c0104633:	e8 d0 fd ff ff       	call   c0104408 <get_pte>
c0104638:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010463b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010463f:	74 19                	je     c010465a <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104641:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104644:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104648:	8b 45 0c             	mov    0xc(%ebp),%eax
c010464b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010464f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104652:	89 04 24             	mov    %eax,(%esp)
c0104655:	e8 52 ff ff ff       	call   c01045ac <page_remove_pte>
    }
}
c010465a:	c9                   	leave  
c010465b:	c3                   	ret    

c010465c <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010465c:	55                   	push   %ebp
c010465d:	89 e5                	mov    %esp,%ebp
c010465f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104662:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104669:	00 
c010466a:	8b 45 10             	mov    0x10(%ebp),%eax
c010466d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104671:	8b 45 08             	mov    0x8(%ebp),%eax
c0104674:	89 04 24             	mov    %eax,(%esp)
c0104677:	e8 8c fd ff ff       	call   c0104408 <get_pte>
c010467c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010467f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104683:	75 0a                	jne    c010468f <page_insert+0x33>
        return -E_NO_MEM;
c0104685:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010468a:	e9 84 00 00 00       	jmp    c0104713 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010468f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104692:	89 04 24             	mov    %eax,(%esp)
c0104695:	e8 41 f4 ff ff       	call   c0103adb <page_ref_inc>
    if (*ptep & PTE_P) {
c010469a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010469d:	8b 00                	mov    (%eax),%eax
c010469f:	83 e0 01             	and    $0x1,%eax
c01046a2:	85 c0                	test   %eax,%eax
c01046a4:	74 3e                	je     c01046e4 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01046a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a9:	8b 00                	mov    (%eax),%eax
c01046ab:	89 04 24             	mov    %eax,(%esp)
c01046ae:	e8 d3 f3 ff ff       	call   c0103a86 <pte2page>
c01046b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01046b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01046bc:	75 0d                	jne    c01046cb <page_insert+0x6f>
            page_ref_dec(page);
c01046be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046c1:	89 04 24             	mov    %eax,(%esp)
c01046c4:	e8 29 f4 ff ff       	call   c0103af2 <page_ref_dec>
c01046c9:	eb 19                	jmp    c01046e4 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01046cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ce:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046d2:	8b 45 10             	mov    0x10(%ebp),%eax
c01046d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01046dc:	89 04 24             	mov    %eax,(%esp)
c01046df:	e8 c8 fe ff ff       	call   c01045ac <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01046e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046e7:	89 04 24             	mov    %eax,(%esp)
c01046ea:	e8 de f2 ff ff       	call   c01039cd <page2pa>
c01046ef:	0b 45 14             	or     0x14(%ebp),%eax
c01046f2:	83 c8 01             	or     $0x1,%eax
c01046f5:	89 c2                	mov    %eax,%edx
c01046f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046fa:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01046fc:	8b 45 10             	mov    0x10(%ebp),%eax
c01046ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104703:	8b 45 08             	mov    0x8(%ebp),%eax
c0104706:	89 04 24             	mov    %eax,(%esp)
c0104709:	e8 07 00 00 00       	call   c0104715 <tlb_invalidate>
    return 0;
c010470e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104713:	c9                   	leave  
c0104714:	c3                   	ret    

c0104715 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104715:	55                   	push   %ebp
c0104716:	89 e5                	mov    %esp,%ebp
c0104718:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010471b:	0f 20 d8             	mov    %cr3,%eax
c010471e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104721:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104724:	89 c2                	mov    %eax,%edx
c0104726:	8b 45 08             	mov    0x8(%ebp),%eax
c0104729:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010472c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104733:	77 23                	ja     c0104758 <tlb_invalidate+0x43>
c0104735:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104738:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010473c:	c7 44 24 08 18 6b 10 	movl   $0xc0106b18,0x8(%esp)
c0104743:	c0 
c0104744:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c010474b:	00 
c010474c:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104753:	e8 77 c5 ff ff       	call   c0100ccf <__panic>
c0104758:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010475b:	05 00 00 00 40       	add    $0x40000000,%eax
c0104760:	39 c2                	cmp    %eax,%edx
c0104762:	75 0c                	jne    c0104770 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104764:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104767:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010476a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010476d:	0f 01 38             	invlpg (%eax)
    }
}
c0104770:	c9                   	leave  
c0104771:	c3                   	ret    

c0104772 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104772:	55                   	push   %ebp
c0104773:	89 e5                	mov    %esp,%ebp
c0104775:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104778:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c010477d:	8b 40 18             	mov    0x18(%eax),%eax
c0104780:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104782:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104789:	e8 ae bb ff ff       	call   c010033c <cprintf>
}
c010478e:	c9                   	leave  
c010478f:	c3                   	ret    

c0104790 <check_pgdir>:

static void
check_pgdir(void) {
c0104790:	55                   	push   %ebp
c0104791:	89 e5                	mov    %esp,%ebp
c0104793:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104796:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010479b:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01047a0:	76 24                	jbe    c01047c6 <check_pgdir+0x36>
c01047a2:	c7 44 24 0c bb 6b 10 	movl   $0xc0106bbb,0xc(%esp)
c01047a9:	c0 
c01047aa:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c01047b1:	c0 
c01047b2:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c01047b9:	00 
c01047ba:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c01047c1:	e8 09 c5 ff ff       	call   c0100ccf <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01047c6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047cb:	85 c0                	test   %eax,%eax
c01047cd:	74 0e                	je     c01047dd <check_pgdir+0x4d>
c01047cf:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047d4:	25 ff 0f 00 00       	and    $0xfff,%eax
c01047d9:	85 c0                	test   %eax,%eax
c01047db:	74 24                	je     c0104801 <check_pgdir+0x71>
c01047dd:	c7 44 24 0c d8 6b 10 	movl   $0xc0106bd8,0xc(%esp)
c01047e4:	c0 
c01047e5:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c01047ec:	c0 
c01047ed:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c01047f4:	00 
c01047f5:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c01047fc:	e8 ce c4 ff ff       	call   c0100ccf <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104801:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104806:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010480d:	00 
c010480e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104815:	00 
c0104816:	89 04 24             	mov    %eax,(%esp)
c0104819:	e8 35 fd ff ff       	call   c0104553 <get_page>
c010481e:	85 c0                	test   %eax,%eax
c0104820:	74 24                	je     c0104846 <check_pgdir+0xb6>
c0104822:	c7 44 24 0c 10 6c 10 	movl   $0xc0106c10,0xc(%esp)
c0104829:	c0 
c010482a:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104831:	c0 
c0104832:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104839:	00 
c010483a:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104841:	e8 89 c4 ff ff       	call   c0100ccf <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104846:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010484d:	e8 77 f4 ff ff       	call   c0103cc9 <alloc_pages>
c0104852:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104855:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010485a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104861:	00 
c0104862:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104869:	00 
c010486a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010486d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104871:	89 04 24             	mov    %eax,(%esp)
c0104874:	e8 e3 fd ff ff       	call   c010465c <page_insert>
c0104879:	85 c0                	test   %eax,%eax
c010487b:	74 24                	je     c01048a1 <check_pgdir+0x111>
c010487d:	c7 44 24 0c 38 6c 10 	movl   $0xc0106c38,0xc(%esp)
c0104884:	c0 
c0104885:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c010488c:	c0 
c010488d:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104894:	00 
c0104895:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c010489c:	e8 2e c4 ff ff       	call   c0100ccf <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01048a1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048ad:	00 
c01048ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048b5:	00 
c01048b6:	89 04 24             	mov    %eax,(%esp)
c01048b9:	e8 4a fb ff ff       	call   c0104408 <get_pte>
c01048be:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048c5:	75 24                	jne    c01048eb <check_pgdir+0x15b>
c01048c7:	c7 44 24 0c 64 6c 10 	movl   $0xc0106c64,0xc(%esp)
c01048ce:	c0 
c01048cf:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c01048d6:	c0 
c01048d7:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c01048de:	00 
c01048df:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c01048e6:	e8 e4 c3 ff ff       	call   c0100ccf <__panic>
    assert(pa2page(*ptep) == p1);
c01048eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048ee:	8b 00                	mov    (%eax),%eax
c01048f0:	89 04 24             	mov    %eax,(%esp)
c01048f3:	e8 eb f0 ff ff       	call   c01039e3 <pa2page>
c01048f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01048fb:	74 24                	je     c0104921 <check_pgdir+0x191>
c01048fd:	c7 44 24 0c 91 6c 10 	movl   $0xc0106c91,0xc(%esp)
c0104904:	c0 
c0104905:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c010490c:	c0 
c010490d:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104914:	00 
c0104915:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c010491c:	e8 ae c3 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p1) == 1);
c0104921:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104924:	89 04 24             	mov    %eax,(%esp)
c0104927:	e8 98 f1 ff ff       	call   c0103ac4 <page_ref>
c010492c:	83 f8 01             	cmp    $0x1,%eax
c010492f:	74 24                	je     c0104955 <check_pgdir+0x1c5>
c0104931:	c7 44 24 0c a6 6c 10 	movl   $0xc0106ca6,0xc(%esp)
c0104938:	c0 
c0104939:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104940:	c0 
c0104941:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104948:	00 
c0104949:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104950:	e8 7a c3 ff ff       	call   c0100ccf <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104955:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010495a:	8b 00                	mov    (%eax),%eax
c010495c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104961:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104964:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104967:	c1 e8 0c             	shr    $0xc,%eax
c010496a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010496d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104972:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104975:	72 23                	jb     c010499a <check_pgdir+0x20a>
c0104977:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010497a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010497e:	c7 44 24 08 74 6a 10 	movl   $0xc0106a74,0x8(%esp)
c0104985:	c0 
c0104986:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c010498d:	00 
c010498e:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104995:	e8 35 c3 ff ff       	call   c0100ccf <__panic>
c010499a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010499d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01049a2:	83 c0 04             	add    $0x4,%eax
c01049a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01049a8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049ad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049b4:	00 
c01049b5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049bc:	00 
c01049bd:	89 04 24             	mov    %eax,(%esp)
c01049c0:	e8 43 fa ff ff       	call   c0104408 <get_pte>
c01049c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049c8:	74 24                	je     c01049ee <check_pgdir+0x25e>
c01049ca:	c7 44 24 0c b8 6c 10 	movl   $0xc0106cb8,0xc(%esp)
c01049d1:	c0 
c01049d2:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c01049d9:	c0 
c01049da:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c01049e1:	00 
c01049e2:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c01049e9:	e8 e1 c2 ff ff       	call   c0100ccf <__panic>

    p2 = alloc_page();
c01049ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01049f5:	e8 cf f2 ff ff       	call   c0103cc9 <alloc_pages>
c01049fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01049fd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a02:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a09:	00 
c0104a0a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a11:	00 
c0104a12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a15:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a19:	89 04 24             	mov    %eax,(%esp)
c0104a1c:	e8 3b fc ff ff       	call   c010465c <page_insert>
c0104a21:	85 c0                	test   %eax,%eax
c0104a23:	74 24                	je     c0104a49 <check_pgdir+0x2b9>
c0104a25:	c7 44 24 0c e0 6c 10 	movl   $0xc0106ce0,0xc(%esp)
c0104a2c:	c0 
c0104a2d:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104a34:	c0 
c0104a35:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104a3c:	00 
c0104a3d:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104a44:	e8 86 c2 ff ff       	call   c0100ccf <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a49:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a4e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a55:	00 
c0104a56:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a5d:	00 
c0104a5e:	89 04 24             	mov    %eax,(%esp)
c0104a61:	e8 a2 f9 ff ff       	call   c0104408 <get_pte>
c0104a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a6d:	75 24                	jne    c0104a93 <check_pgdir+0x303>
c0104a6f:	c7 44 24 0c 18 6d 10 	movl   $0xc0106d18,0xc(%esp)
c0104a76:	c0 
c0104a77:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104a7e:	c0 
c0104a7f:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104a86:	00 
c0104a87:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104a8e:	e8 3c c2 ff ff       	call   c0100ccf <__panic>
    assert(*ptep & PTE_U);
c0104a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a96:	8b 00                	mov    (%eax),%eax
c0104a98:	83 e0 04             	and    $0x4,%eax
c0104a9b:	85 c0                	test   %eax,%eax
c0104a9d:	75 24                	jne    c0104ac3 <check_pgdir+0x333>
c0104a9f:	c7 44 24 0c 48 6d 10 	movl   $0xc0106d48,0xc(%esp)
c0104aa6:	c0 
c0104aa7:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104aae:	c0 
c0104aaf:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104ab6:	00 
c0104ab7:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104abe:	e8 0c c2 ff ff       	call   c0100ccf <__panic>
    assert(*ptep & PTE_W);
c0104ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ac6:	8b 00                	mov    (%eax),%eax
c0104ac8:	83 e0 02             	and    $0x2,%eax
c0104acb:	85 c0                	test   %eax,%eax
c0104acd:	75 24                	jne    c0104af3 <check_pgdir+0x363>
c0104acf:	c7 44 24 0c 56 6d 10 	movl   $0xc0106d56,0xc(%esp)
c0104ad6:	c0 
c0104ad7:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104ade:	c0 
c0104adf:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104ae6:	00 
c0104ae7:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104aee:	e8 dc c1 ff ff       	call   c0100ccf <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104af3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104af8:	8b 00                	mov    (%eax),%eax
c0104afa:	83 e0 04             	and    $0x4,%eax
c0104afd:	85 c0                	test   %eax,%eax
c0104aff:	75 24                	jne    c0104b25 <check_pgdir+0x395>
c0104b01:	c7 44 24 0c 64 6d 10 	movl   $0xc0106d64,0xc(%esp)
c0104b08:	c0 
c0104b09:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104b10:	c0 
c0104b11:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104b18:	00 
c0104b19:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104b20:	e8 aa c1 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p2) == 1);
c0104b25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b28:	89 04 24             	mov    %eax,(%esp)
c0104b2b:	e8 94 ef ff ff       	call   c0103ac4 <page_ref>
c0104b30:	83 f8 01             	cmp    $0x1,%eax
c0104b33:	74 24                	je     c0104b59 <check_pgdir+0x3c9>
c0104b35:	c7 44 24 0c 7a 6d 10 	movl   $0xc0106d7a,0xc(%esp)
c0104b3c:	c0 
c0104b3d:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104b44:	c0 
c0104b45:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104b4c:	00 
c0104b4d:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104b54:	e8 76 c1 ff ff       	call   c0100ccf <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104b59:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b5e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104b65:	00 
c0104b66:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104b6d:	00 
c0104b6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b71:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b75:	89 04 24             	mov    %eax,(%esp)
c0104b78:	e8 df fa ff ff       	call   c010465c <page_insert>
c0104b7d:	85 c0                	test   %eax,%eax
c0104b7f:	74 24                	je     c0104ba5 <check_pgdir+0x415>
c0104b81:	c7 44 24 0c 8c 6d 10 	movl   $0xc0106d8c,0xc(%esp)
c0104b88:	c0 
c0104b89:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104b90:	c0 
c0104b91:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104b98:	00 
c0104b99:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104ba0:	e8 2a c1 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p1) == 2);
c0104ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ba8:	89 04 24             	mov    %eax,(%esp)
c0104bab:	e8 14 ef ff ff       	call   c0103ac4 <page_ref>
c0104bb0:	83 f8 02             	cmp    $0x2,%eax
c0104bb3:	74 24                	je     c0104bd9 <check_pgdir+0x449>
c0104bb5:	c7 44 24 0c b8 6d 10 	movl   $0xc0106db8,0xc(%esp)
c0104bbc:	c0 
c0104bbd:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104bc4:	c0 
c0104bc5:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104bcc:	00 
c0104bcd:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104bd4:	e8 f6 c0 ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p2) == 0);
c0104bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bdc:	89 04 24             	mov    %eax,(%esp)
c0104bdf:	e8 e0 ee ff ff       	call   c0103ac4 <page_ref>
c0104be4:	85 c0                	test   %eax,%eax
c0104be6:	74 24                	je     c0104c0c <check_pgdir+0x47c>
c0104be8:	c7 44 24 0c ca 6d 10 	movl   $0xc0106dca,0xc(%esp)
c0104bef:	c0 
c0104bf0:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104bf7:	c0 
c0104bf8:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104bff:	00 
c0104c00:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104c07:	e8 c3 c0 ff ff       	call   c0100ccf <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c0c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c11:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c18:	00 
c0104c19:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c20:	00 
c0104c21:	89 04 24             	mov    %eax,(%esp)
c0104c24:	e8 df f7 ff ff       	call   c0104408 <get_pte>
c0104c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c30:	75 24                	jne    c0104c56 <check_pgdir+0x4c6>
c0104c32:	c7 44 24 0c 18 6d 10 	movl   $0xc0106d18,0xc(%esp)
c0104c39:	c0 
c0104c3a:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104c41:	c0 
c0104c42:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104c49:	00 
c0104c4a:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104c51:	e8 79 c0 ff ff       	call   c0100ccf <__panic>
    assert(pa2page(*ptep) == p1);
c0104c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c59:	8b 00                	mov    (%eax),%eax
c0104c5b:	89 04 24             	mov    %eax,(%esp)
c0104c5e:	e8 80 ed ff ff       	call   c01039e3 <pa2page>
c0104c63:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104c66:	74 24                	je     c0104c8c <check_pgdir+0x4fc>
c0104c68:	c7 44 24 0c 91 6c 10 	movl   $0xc0106c91,0xc(%esp)
c0104c6f:	c0 
c0104c70:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104c77:	c0 
c0104c78:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104c7f:	00 
c0104c80:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104c87:	e8 43 c0 ff ff       	call   c0100ccf <__panic>
    assert((*ptep & PTE_U) == 0);
c0104c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c8f:	8b 00                	mov    (%eax),%eax
c0104c91:	83 e0 04             	and    $0x4,%eax
c0104c94:	85 c0                	test   %eax,%eax
c0104c96:	74 24                	je     c0104cbc <check_pgdir+0x52c>
c0104c98:	c7 44 24 0c dc 6d 10 	movl   $0xc0106ddc,0xc(%esp)
c0104c9f:	c0 
c0104ca0:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104ca7:	c0 
c0104ca8:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104caf:	00 
c0104cb0:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104cb7:	e8 13 c0 ff ff       	call   c0100ccf <__panic>

    page_remove(boot_pgdir, 0x0);
c0104cbc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cc1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104cc8:	00 
c0104cc9:	89 04 24             	mov    %eax,(%esp)
c0104ccc:	e8 47 f9 ff ff       	call   c0104618 <page_remove>
    assert(page_ref(p1) == 1);
c0104cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cd4:	89 04 24             	mov    %eax,(%esp)
c0104cd7:	e8 e8 ed ff ff       	call   c0103ac4 <page_ref>
c0104cdc:	83 f8 01             	cmp    $0x1,%eax
c0104cdf:	74 24                	je     c0104d05 <check_pgdir+0x575>
c0104ce1:	c7 44 24 0c a6 6c 10 	movl   $0xc0106ca6,0xc(%esp)
c0104ce8:	c0 
c0104ce9:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104cf0:	c0 
c0104cf1:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104cf8:	00 
c0104cf9:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104d00:	e8 ca bf ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p2) == 0);
c0104d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d08:	89 04 24             	mov    %eax,(%esp)
c0104d0b:	e8 b4 ed ff ff       	call   c0103ac4 <page_ref>
c0104d10:	85 c0                	test   %eax,%eax
c0104d12:	74 24                	je     c0104d38 <check_pgdir+0x5a8>
c0104d14:	c7 44 24 0c ca 6d 10 	movl   $0xc0106dca,0xc(%esp)
c0104d1b:	c0 
c0104d1c:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104d23:	c0 
c0104d24:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104d2b:	00 
c0104d2c:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104d33:	e8 97 bf ff ff       	call   c0100ccf <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d38:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d3d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d44:	00 
c0104d45:	89 04 24             	mov    %eax,(%esp)
c0104d48:	e8 cb f8 ff ff       	call   c0104618 <page_remove>
    assert(page_ref(p1) == 0);
c0104d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d50:	89 04 24             	mov    %eax,(%esp)
c0104d53:	e8 6c ed ff ff       	call   c0103ac4 <page_ref>
c0104d58:	85 c0                	test   %eax,%eax
c0104d5a:	74 24                	je     c0104d80 <check_pgdir+0x5f0>
c0104d5c:	c7 44 24 0c f1 6d 10 	movl   $0xc0106df1,0xc(%esp)
c0104d63:	c0 
c0104d64:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104d6b:	c0 
c0104d6c:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0104d73:	00 
c0104d74:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104d7b:	e8 4f bf ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p2) == 0);
c0104d80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d83:	89 04 24             	mov    %eax,(%esp)
c0104d86:	e8 39 ed ff ff       	call   c0103ac4 <page_ref>
c0104d8b:	85 c0                	test   %eax,%eax
c0104d8d:	74 24                	je     c0104db3 <check_pgdir+0x623>
c0104d8f:	c7 44 24 0c ca 6d 10 	movl   $0xc0106dca,0xc(%esp)
c0104d96:	c0 
c0104d97:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104d9e:	c0 
c0104d9f:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104da6:	00 
c0104da7:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104dae:	e8 1c bf ff ff       	call   c0100ccf <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104db3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104db8:	8b 00                	mov    (%eax),%eax
c0104dba:	89 04 24             	mov    %eax,(%esp)
c0104dbd:	e8 21 ec ff ff       	call   c01039e3 <pa2page>
c0104dc2:	89 04 24             	mov    %eax,(%esp)
c0104dc5:	e8 fa ec ff ff       	call   c0103ac4 <page_ref>
c0104dca:	83 f8 01             	cmp    $0x1,%eax
c0104dcd:	74 24                	je     c0104df3 <check_pgdir+0x663>
c0104dcf:	c7 44 24 0c 04 6e 10 	movl   $0xc0106e04,0xc(%esp)
c0104dd6:	c0 
c0104dd7:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104dde:	c0 
c0104ddf:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104de6:	00 
c0104de7:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104dee:	e8 dc be ff ff       	call   c0100ccf <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104df3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104df8:	8b 00                	mov    (%eax),%eax
c0104dfa:	89 04 24             	mov    %eax,(%esp)
c0104dfd:	e8 e1 eb ff ff       	call   c01039e3 <pa2page>
c0104e02:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e09:	00 
c0104e0a:	89 04 24             	mov    %eax,(%esp)
c0104e0d:	e8 ef ee ff ff       	call   c0103d01 <free_pages>
    boot_pgdir[0] = 0;
c0104e12:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104e1d:	c7 04 24 2a 6e 10 c0 	movl   $0xc0106e2a,(%esp)
c0104e24:	e8 13 b5 ff ff       	call   c010033c <cprintf>
}
c0104e29:	c9                   	leave  
c0104e2a:	c3                   	ret    

c0104e2b <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e2b:	55                   	push   %ebp
c0104e2c:	89 e5                	mov    %esp,%ebp
c0104e2e:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e38:	e9 ca 00 00 00       	jmp    c0104f07 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e40:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e46:	c1 e8 0c             	shr    $0xc,%eax
c0104e49:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e4c:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104e51:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104e54:	72 23                	jb     c0104e79 <check_boot_pgdir+0x4e>
c0104e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e59:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e5d:	c7 44 24 08 74 6a 10 	movl   $0xc0106a74,0x8(%esp)
c0104e64:	c0 
c0104e65:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104e6c:	00 
c0104e6d:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104e74:	e8 56 be ff ff       	call   c0100ccf <__panic>
c0104e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e7c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e81:	89 c2                	mov    %eax,%edx
c0104e83:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e88:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e8f:	00 
c0104e90:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e94:	89 04 24             	mov    %eax,(%esp)
c0104e97:	e8 6c f5 ff ff       	call   c0104408 <get_pte>
c0104e9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e9f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104ea3:	75 24                	jne    c0104ec9 <check_boot_pgdir+0x9e>
c0104ea5:	c7 44 24 0c 44 6e 10 	movl   $0xc0106e44,0xc(%esp)
c0104eac:	c0 
c0104ead:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104eb4:	c0 
c0104eb5:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104ebc:	00 
c0104ebd:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104ec4:	e8 06 be ff ff       	call   c0100ccf <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104ec9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ecc:	8b 00                	mov    (%eax),%eax
c0104ece:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ed3:	89 c2                	mov    %eax,%edx
c0104ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed8:	39 c2                	cmp    %eax,%edx
c0104eda:	74 24                	je     c0104f00 <check_boot_pgdir+0xd5>
c0104edc:	c7 44 24 0c 81 6e 10 	movl   $0xc0106e81,0xc(%esp)
c0104ee3:	c0 
c0104ee4:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104eeb:	c0 
c0104eec:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0104ef3:	00 
c0104ef4:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104efb:	e8 cf bd ff ff       	call   c0100ccf <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104f00:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f0a:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104f0f:	39 c2                	cmp    %eax,%edx
c0104f11:	0f 82 26 ff ff ff    	jb     c0104e3d <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104f17:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f1c:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f21:	8b 00                	mov    (%eax),%eax
c0104f23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f28:	89 c2                	mov    %eax,%edx
c0104f2a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f32:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104f39:	77 23                	ja     c0104f5e <check_boot_pgdir+0x133>
c0104f3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f42:	c7 44 24 08 18 6b 10 	movl   $0xc0106b18,0x8(%esp)
c0104f49:	c0 
c0104f4a:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0104f51:	00 
c0104f52:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104f59:	e8 71 bd ff ff       	call   c0100ccf <__panic>
c0104f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f61:	05 00 00 00 40       	add    $0x40000000,%eax
c0104f66:	39 c2                	cmp    %eax,%edx
c0104f68:	74 24                	je     c0104f8e <check_boot_pgdir+0x163>
c0104f6a:	c7 44 24 0c 98 6e 10 	movl   $0xc0106e98,0xc(%esp)
c0104f71:	c0 
c0104f72:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104f79:	c0 
c0104f7a:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0104f81:	00 
c0104f82:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104f89:	e8 41 bd ff ff       	call   c0100ccf <__panic>

    assert(boot_pgdir[0] == 0);
c0104f8e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f93:	8b 00                	mov    (%eax),%eax
c0104f95:	85 c0                	test   %eax,%eax
c0104f97:	74 24                	je     c0104fbd <check_boot_pgdir+0x192>
c0104f99:	c7 44 24 0c cc 6e 10 	movl   $0xc0106ecc,0xc(%esp)
c0104fa0:	c0 
c0104fa1:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0104fa8:	c0 
c0104fa9:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0104fb0:	00 
c0104fb1:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0104fb8:	e8 12 bd ff ff       	call   c0100ccf <__panic>

    struct Page *p;
    p = alloc_page();
c0104fbd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104fc4:	e8 00 ed ff ff       	call   c0103cc9 <alloc_pages>
c0104fc9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104fcc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fd1:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104fd8:	00 
c0104fd9:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104fe0:	00 
c0104fe1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104fe4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104fe8:	89 04 24             	mov    %eax,(%esp)
c0104feb:	e8 6c f6 ff ff       	call   c010465c <page_insert>
c0104ff0:	85 c0                	test   %eax,%eax
c0104ff2:	74 24                	je     c0105018 <check_boot_pgdir+0x1ed>
c0104ff4:	c7 44 24 0c e0 6e 10 	movl   $0xc0106ee0,0xc(%esp)
c0104ffb:	c0 
c0104ffc:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0105003:	c0 
c0105004:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c010500b:	00 
c010500c:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0105013:	e8 b7 bc ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p) == 1);
c0105018:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010501b:	89 04 24             	mov    %eax,(%esp)
c010501e:	e8 a1 ea ff ff       	call   c0103ac4 <page_ref>
c0105023:	83 f8 01             	cmp    $0x1,%eax
c0105026:	74 24                	je     c010504c <check_boot_pgdir+0x221>
c0105028:	c7 44 24 0c 0e 6f 10 	movl   $0xc0106f0e,0xc(%esp)
c010502f:	c0 
c0105030:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0105037:	c0 
c0105038:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c010503f:	00 
c0105040:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0105047:	e8 83 bc ff ff       	call   c0100ccf <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010504c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105051:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105058:	00 
c0105059:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105060:	00 
c0105061:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105064:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105068:	89 04 24             	mov    %eax,(%esp)
c010506b:	e8 ec f5 ff ff       	call   c010465c <page_insert>
c0105070:	85 c0                	test   %eax,%eax
c0105072:	74 24                	je     c0105098 <check_boot_pgdir+0x26d>
c0105074:	c7 44 24 0c 20 6f 10 	movl   $0xc0106f20,0xc(%esp)
c010507b:	c0 
c010507c:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0105083:	c0 
c0105084:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c010508b:	00 
c010508c:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0105093:	e8 37 bc ff ff       	call   c0100ccf <__panic>
    assert(page_ref(p) == 2);
c0105098:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010509b:	89 04 24             	mov    %eax,(%esp)
c010509e:	e8 21 ea ff ff       	call   c0103ac4 <page_ref>
c01050a3:	83 f8 02             	cmp    $0x2,%eax
c01050a6:	74 24                	je     c01050cc <check_boot_pgdir+0x2a1>
c01050a8:	c7 44 24 0c 57 6f 10 	movl   $0xc0106f57,0xc(%esp)
c01050af:	c0 
c01050b0:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c01050b7:	c0 
c01050b8:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c01050bf:	00 
c01050c0:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c01050c7:	e8 03 bc ff ff       	call   c0100ccf <__panic>

    const char *str = "ucore: Hello world!!";
c01050cc:	c7 45 dc 68 6f 10 c0 	movl   $0xc0106f68,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01050d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050da:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050e1:	e8 1e 0a 00 00       	call   c0105b04 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01050e6:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01050ed:	00 
c01050ee:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050f5:	e8 83 0a 00 00       	call   c0105b7d <strcmp>
c01050fa:	85 c0                	test   %eax,%eax
c01050fc:	74 24                	je     c0105122 <check_boot_pgdir+0x2f7>
c01050fe:	c7 44 24 0c 80 6f 10 	movl   $0xc0106f80,0xc(%esp)
c0105105:	c0 
c0105106:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c010510d:	c0 
c010510e:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105115:	00 
c0105116:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c010511d:	e8 ad bb ff ff       	call   c0100ccf <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105122:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105125:	89 04 24             	mov    %eax,(%esp)
c0105128:	e8 05 e9 ff ff       	call   c0103a32 <page2kva>
c010512d:	05 00 01 00 00       	add    $0x100,%eax
c0105132:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105135:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010513c:	e8 6b 09 00 00       	call   c0105aac <strlen>
c0105141:	85 c0                	test   %eax,%eax
c0105143:	74 24                	je     c0105169 <check_boot_pgdir+0x33e>
c0105145:	c7 44 24 0c b8 6f 10 	movl   $0xc0106fb8,0xc(%esp)
c010514c:	c0 
c010514d:	c7 44 24 08 61 6b 10 	movl   $0xc0106b61,0x8(%esp)
c0105154:	c0 
c0105155:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c010515c:	00 
c010515d:	c7 04 24 3c 6b 10 c0 	movl   $0xc0106b3c,(%esp)
c0105164:	e8 66 bb ff ff       	call   c0100ccf <__panic>

    free_page(p);
c0105169:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105170:	00 
c0105171:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105174:	89 04 24             	mov    %eax,(%esp)
c0105177:	e8 85 eb ff ff       	call   c0103d01 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c010517c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105181:	8b 00                	mov    (%eax),%eax
c0105183:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105188:	89 04 24             	mov    %eax,(%esp)
c010518b:	e8 53 e8 ff ff       	call   c01039e3 <pa2page>
c0105190:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105197:	00 
c0105198:	89 04 24             	mov    %eax,(%esp)
c010519b:	e8 61 eb ff ff       	call   c0103d01 <free_pages>
    boot_pgdir[0] = 0;
c01051a0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01051a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01051ab:	c7 04 24 dc 6f 10 c0 	movl   $0xc0106fdc,(%esp)
c01051b2:	e8 85 b1 ff ff       	call   c010033c <cprintf>
}
c01051b7:	c9                   	leave  
c01051b8:	c3                   	ret    

c01051b9 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01051b9:	55                   	push   %ebp
c01051ba:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01051bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01051bf:	83 e0 04             	and    $0x4,%eax
c01051c2:	85 c0                	test   %eax,%eax
c01051c4:	74 07                	je     c01051cd <perm2str+0x14>
c01051c6:	b8 75 00 00 00       	mov    $0x75,%eax
c01051cb:	eb 05                	jmp    c01051d2 <perm2str+0x19>
c01051cd:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051d2:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c01051d7:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01051de:	8b 45 08             	mov    0x8(%ebp),%eax
c01051e1:	83 e0 02             	and    $0x2,%eax
c01051e4:	85 c0                	test   %eax,%eax
c01051e6:	74 07                	je     c01051ef <perm2str+0x36>
c01051e8:	b8 77 00 00 00       	mov    $0x77,%eax
c01051ed:	eb 05                	jmp    c01051f4 <perm2str+0x3b>
c01051ef:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051f4:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c01051f9:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0105200:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0105205:	5d                   	pop    %ebp
c0105206:	c3                   	ret    

c0105207 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105207:	55                   	push   %ebp
c0105208:	89 e5                	mov    %esp,%ebp
c010520a:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010520d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105210:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105213:	72 0a                	jb     c010521f <get_pgtable_items+0x18>
        return 0;
c0105215:	b8 00 00 00 00       	mov    $0x0,%eax
c010521a:	e9 9c 00 00 00       	jmp    c01052bb <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010521f:	eb 04                	jmp    c0105225 <get_pgtable_items+0x1e>
        start ++;
c0105221:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105225:	8b 45 10             	mov    0x10(%ebp),%eax
c0105228:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010522b:	73 18                	jae    c0105245 <get_pgtable_items+0x3e>
c010522d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105230:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105237:	8b 45 14             	mov    0x14(%ebp),%eax
c010523a:	01 d0                	add    %edx,%eax
c010523c:	8b 00                	mov    (%eax),%eax
c010523e:	83 e0 01             	and    $0x1,%eax
c0105241:	85 c0                	test   %eax,%eax
c0105243:	74 dc                	je     c0105221 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105245:	8b 45 10             	mov    0x10(%ebp),%eax
c0105248:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010524b:	73 69                	jae    c01052b6 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c010524d:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105251:	74 08                	je     c010525b <get_pgtable_items+0x54>
            *left_store = start;
c0105253:	8b 45 18             	mov    0x18(%ebp),%eax
c0105256:	8b 55 10             	mov    0x10(%ebp),%edx
c0105259:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010525b:	8b 45 10             	mov    0x10(%ebp),%eax
c010525e:	8d 50 01             	lea    0x1(%eax),%edx
c0105261:	89 55 10             	mov    %edx,0x10(%ebp)
c0105264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010526b:	8b 45 14             	mov    0x14(%ebp),%eax
c010526e:	01 d0                	add    %edx,%eax
c0105270:	8b 00                	mov    (%eax),%eax
c0105272:	83 e0 07             	and    $0x7,%eax
c0105275:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105278:	eb 04                	jmp    c010527e <get_pgtable_items+0x77>
            start ++;
c010527a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010527e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105281:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105284:	73 1d                	jae    c01052a3 <get_pgtable_items+0x9c>
c0105286:	8b 45 10             	mov    0x10(%ebp),%eax
c0105289:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105290:	8b 45 14             	mov    0x14(%ebp),%eax
c0105293:	01 d0                	add    %edx,%eax
c0105295:	8b 00                	mov    (%eax),%eax
c0105297:	83 e0 07             	and    $0x7,%eax
c010529a:	89 c2                	mov    %eax,%edx
c010529c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010529f:	39 c2                	cmp    %eax,%edx
c01052a1:	74 d7                	je     c010527a <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01052a3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01052a7:	74 08                	je     c01052b1 <get_pgtable_items+0xaa>
            *right_store = start;
c01052a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01052ac:	8b 55 10             	mov    0x10(%ebp),%edx
c01052af:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01052b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052b4:	eb 05                	jmp    c01052bb <get_pgtable_items+0xb4>
    }
    return 0;
c01052b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052bb:	c9                   	leave  
c01052bc:	c3                   	ret    

c01052bd <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01052bd:	55                   	push   %ebp
c01052be:	89 e5                	mov    %esp,%ebp
c01052c0:	57                   	push   %edi
c01052c1:	56                   	push   %esi
c01052c2:	53                   	push   %ebx
c01052c3:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01052c6:	c7 04 24 fc 6f 10 c0 	movl   $0xc0106ffc,(%esp)
c01052cd:	e8 6a b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c01052d2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01052d9:	e9 fa 00 00 00       	jmp    c01053d8 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01052de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052e1:	89 04 24             	mov    %eax,(%esp)
c01052e4:	e8 d0 fe ff ff       	call   c01051b9 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01052e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01052ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052ef:	29 d1                	sub    %edx,%ecx
c01052f1:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01052f3:	89 d6                	mov    %edx,%esi
c01052f5:	c1 e6 16             	shl    $0x16,%esi
c01052f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052fb:	89 d3                	mov    %edx,%ebx
c01052fd:	c1 e3 16             	shl    $0x16,%ebx
c0105300:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105303:	89 d1                	mov    %edx,%ecx
c0105305:	c1 e1 16             	shl    $0x16,%ecx
c0105308:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010530b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010530e:	29 d7                	sub    %edx,%edi
c0105310:	89 fa                	mov    %edi,%edx
c0105312:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105316:	89 74 24 10          	mov    %esi,0x10(%esp)
c010531a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010531e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105322:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105326:	c7 04 24 2d 70 10 c0 	movl   $0xc010702d,(%esp)
c010532d:	e8 0a b0 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105332:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105335:	c1 e0 0a             	shl    $0xa,%eax
c0105338:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010533b:	eb 54                	jmp    c0105391 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010533d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105340:	89 04 24             	mov    %eax,(%esp)
c0105343:	e8 71 fe ff ff       	call   c01051b9 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105348:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010534b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010534e:	29 d1                	sub    %edx,%ecx
c0105350:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105352:	89 d6                	mov    %edx,%esi
c0105354:	c1 e6 0c             	shl    $0xc,%esi
c0105357:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010535a:	89 d3                	mov    %edx,%ebx
c010535c:	c1 e3 0c             	shl    $0xc,%ebx
c010535f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105362:	c1 e2 0c             	shl    $0xc,%edx
c0105365:	89 d1                	mov    %edx,%ecx
c0105367:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010536a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010536d:	29 d7                	sub    %edx,%edi
c010536f:	89 fa                	mov    %edi,%edx
c0105371:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105375:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105379:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010537d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105381:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105385:	c7 04 24 4c 70 10 c0 	movl   $0xc010704c,(%esp)
c010538c:	e8 ab af ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105391:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105396:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105399:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010539c:	89 ce                	mov    %ecx,%esi
c010539e:	c1 e6 0a             	shl    $0xa,%esi
c01053a1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01053a4:	89 cb                	mov    %ecx,%ebx
c01053a6:	c1 e3 0a             	shl    $0xa,%ebx
c01053a9:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01053ac:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053b0:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01053b3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01053b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053bb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053bf:	89 74 24 04          	mov    %esi,0x4(%esp)
c01053c3:	89 1c 24             	mov    %ebx,(%esp)
c01053c6:	e8 3c fe ff ff       	call   c0105207 <get_pgtable_items>
c01053cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053d2:	0f 85 65 ff ff ff    	jne    c010533d <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01053d8:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01053dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053e0:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01053e3:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053e7:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01053ea:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01053ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053f2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053f6:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01053fd:	00 
c01053fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105405:	e8 fd fd ff ff       	call   c0105207 <get_pgtable_items>
c010540a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010540d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105411:	0f 85 c7 fe ff ff    	jne    c01052de <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105417:	c7 04 24 70 70 10 c0 	movl   $0xc0107070,(%esp)
c010541e:	e8 19 af ff ff       	call   c010033c <cprintf>
}
c0105423:	83 c4 4c             	add    $0x4c,%esp
c0105426:	5b                   	pop    %ebx
c0105427:	5e                   	pop    %esi
c0105428:	5f                   	pop    %edi
c0105429:	5d                   	pop    %ebp
c010542a:	c3                   	ret    

c010542b <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010542b:	55                   	push   %ebp
c010542c:	89 e5                	mov    %esp,%ebp
c010542e:	83 ec 58             	sub    $0x58,%esp
c0105431:	8b 45 10             	mov    0x10(%ebp),%eax
c0105434:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105437:	8b 45 14             	mov    0x14(%ebp),%eax
c010543a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010543d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105440:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105443:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105446:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105449:	8b 45 18             	mov    0x18(%ebp),%eax
c010544c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010544f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105452:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105455:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105458:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010545b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010545e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105461:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105465:	74 1c                	je     c0105483 <printnum+0x58>
c0105467:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010546a:	ba 00 00 00 00       	mov    $0x0,%edx
c010546f:	f7 75 e4             	divl   -0x1c(%ebp)
c0105472:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105475:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105478:	ba 00 00 00 00       	mov    $0x0,%edx
c010547d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105480:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105483:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105486:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105489:	f7 75 e4             	divl   -0x1c(%ebp)
c010548c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010548f:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105492:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105495:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105498:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010549b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010549e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054a1:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01054a4:	8b 45 18             	mov    0x18(%ebp),%eax
c01054a7:	ba 00 00 00 00       	mov    $0x0,%edx
c01054ac:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054af:	77 56                	ja     c0105507 <printnum+0xdc>
c01054b1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054b4:	72 05                	jb     c01054bb <printnum+0x90>
c01054b6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01054b9:	77 4c                	ja     c0105507 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01054bb:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054be:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054c1:	8b 45 20             	mov    0x20(%ebp),%eax
c01054c4:	89 44 24 18          	mov    %eax,0x18(%esp)
c01054c8:	89 54 24 14          	mov    %edx,0x14(%esp)
c01054cc:	8b 45 18             	mov    0x18(%ebp),%eax
c01054cf:	89 44 24 10          	mov    %eax,0x10(%esp)
c01054d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054d9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01054e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01054eb:	89 04 24             	mov    %eax,(%esp)
c01054ee:	e8 38 ff ff ff       	call   c010542b <printnum>
c01054f3:	eb 1c                	jmp    c0105511 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01054f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054fc:	8b 45 20             	mov    0x20(%ebp),%eax
c01054ff:	89 04 24             	mov    %eax,(%esp)
c0105502:	8b 45 08             	mov    0x8(%ebp),%eax
c0105505:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105507:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010550b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010550f:	7f e4                	jg     c01054f5 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105511:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105514:	05 24 71 10 c0       	add    $0xc0107124,%eax
c0105519:	0f b6 00             	movzbl (%eax),%eax
c010551c:	0f be c0             	movsbl %al,%eax
c010551f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105522:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105526:	89 04 24             	mov    %eax,(%esp)
c0105529:	8b 45 08             	mov    0x8(%ebp),%eax
c010552c:	ff d0                	call   *%eax
}
c010552e:	c9                   	leave  
c010552f:	c3                   	ret    

c0105530 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105530:	55                   	push   %ebp
c0105531:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105533:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105537:	7e 14                	jle    c010554d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105539:	8b 45 08             	mov    0x8(%ebp),%eax
c010553c:	8b 00                	mov    (%eax),%eax
c010553e:	8d 48 08             	lea    0x8(%eax),%ecx
c0105541:	8b 55 08             	mov    0x8(%ebp),%edx
c0105544:	89 0a                	mov    %ecx,(%edx)
c0105546:	8b 50 04             	mov    0x4(%eax),%edx
c0105549:	8b 00                	mov    (%eax),%eax
c010554b:	eb 30                	jmp    c010557d <getuint+0x4d>
    }
    else if (lflag) {
c010554d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105551:	74 16                	je     c0105569 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105553:	8b 45 08             	mov    0x8(%ebp),%eax
c0105556:	8b 00                	mov    (%eax),%eax
c0105558:	8d 48 04             	lea    0x4(%eax),%ecx
c010555b:	8b 55 08             	mov    0x8(%ebp),%edx
c010555e:	89 0a                	mov    %ecx,(%edx)
c0105560:	8b 00                	mov    (%eax),%eax
c0105562:	ba 00 00 00 00       	mov    $0x0,%edx
c0105567:	eb 14                	jmp    c010557d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105569:	8b 45 08             	mov    0x8(%ebp),%eax
c010556c:	8b 00                	mov    (%eax),%eax
c010556e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105571:	8b 55 08             	mov    0x8(%ebp),%edx
c0105574:	89 0a                	mov    %ecx,(%edx)
c0105576:	8b 00                	mov    (%eax),%eax
c0105578:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010557d:	5d                   	pop    %ebp
c010557e:	c3                   	ret    

c010557f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010557f:	55                   	push   %ebp
c0105580:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105582:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105586:	7e 14                	jle    c010559c <getint+0x1d>
        return va_arg(*ap, long long);
c0105588:	8b 45 08             	mov    0x8(%ebp),%eax
c010558b:	8b 00                	mov    (%eax),%eax
c010558d:	8d 48 08             	lea    0x8(%eax),%ecx
c0105590:	8b 55 08             	mov    0x8(%ebp),%edx
c0105593:	89 0a                	mov    %ecx,(%edx)
c0105595:	8b 50 04             	mov    0x4(%eax),%edx
c0105598:	8b 00                	mov    (%eax),%eax
c010559a:	eb 28                	jmp    c01055c4 <getint+0x45>
    }
    else if (lflag) {
c010559c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055a0:	74 12                	je     c01055b4 <getint+0x35>
        return va_arg(*ap, long);
c01055a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a5:	8b 00                	mov    (%eax),%eax
c01055a7:	8d 48 04             	lea    0x4(%eax),%ecx
c01055aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01055ad:	89 0a                	mov    %ecx,(%edx)
c01055af:	8b 00                	mov    (%eax),%eax
c01055b1:	99                   	cltd   
c01055b2:	eb 10                	jmp    c01055c4 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01055b7:	8b 00                	mov    (%eax),%eax
c01055b9:	8d 48 04             	lea    0x4(%eax),%ecx
c01055bc:	8b 55 08             	mov    0x8(%ebp),%edx
c01055bf:	89 0a                	mov    %ecx,(%edx)
c01055c1:	8b 00                	mov    (%eax),%eax
c01055c3:	99                   	cltd   
    }
}
c01055c4:	5d                   	pop    %ebp
c01055c5:	c3                   	ret    

c01055c6 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01055c6:	55                   	push   %ebp
c01055c7:	89 e5                	mov    %esp,%ebp
c01055c9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01055cc:	8d 45 14             	lea    0x14(%ebp),%eax
c01055cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01055d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01055dc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ea:	89 04 24             	mov    %eax,(%esp)
c01055ed:	e8 02 00 00 00       	call   c01055f4 <vprintfmt>
    va_end(ap);
}
c01055f2:	c9                   	leave  
c01055f3:	c3                   	ret    

c01055f4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01055f4:	55                   	push   %ebp
c01055f5:	89 e5                	mov    %esp,%ebp
c01055f7:	56                   	push   %esi
c01055f8:	53                   	push   %ebx
c01055f9:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01055fc:	eb 18                	jmp    c0105616 <vprintfmt+0x22>
            if (ch == '\0') {
c01055fe:	85 db                	test   %ebx,%ebx
c0105600:	75 05                	jne    c0105607 <vprintfmt+0x13>
                return;
c0105602:	e9 d1 03 00 00       	jmp    c01059d8 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105607:	8b 45 0c             	mov    0xc(%ebp),%eax
c010560a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010560e:	89 1c 24             	mov    %ebx,(%esp)
c0105611:	8b 45 08             	mov    0x8(%ebp),%eax
c0105614:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105616:	8b 45 10             	mov    0x10(%ebp),%eax
c0105619:	8d 50 01             	lea    0x1(%eax),%edx
c010561c:	89 55 10             	mov    %edx,0x10(%ebp)
c010561f:	0f b6 00             	movzbl (%eax),%eax
c0105622:	0f b6 d8             	movzbl %al,%ebx
c0105625:	83 fb 25             	cmp    $0x25,%ebx
c0105628:	75 d4                	jne    c01055fe <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010562a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010562e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105638:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010563b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105642:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105645:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105648:	8b 45 10             	mov    0x10(%ebp),%eax
c010564b:	8d 50 01             	lea    0x1(%eax),%edx
c010564e:	89 55 10             	mov    %edx,0x10(%ebp)
c0105651:	0f b6 00             	movzbl (%eax),%eax
c0105654:	0f b6 d8             	movzbl %al,%ebx
c0105657:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010565a:	83 f8 55             	cmp    $0x55,%eax
c010565d:	0f 87 44 03 00 00    	ja     c01059a7 <vprintfmt+0x3b3>
c0105663:	8b 04 85 48 71 10 c0 	mov    -0x3fef8eb8(,%eax,4),%eax
c010566a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010566c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105670:	eb d6                	jmp    c0105648 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105672:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105676:	eb d0                	jmp    c0105648 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105678:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010567f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105682:	89 d0                	mov    %edx,%eax
c0105684:	c1 e0 02             	shl    $0x2,%eax
c0105687:	01 d0                	add    %edx,%eax
c0105689:	01 c0                	add    %eax,%eax
c010568b:	01 d8                	add    %ebx,%eax
c010568d:	83 e8 30             	sub    $0x30,%eax
c0105690:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105693:	8b 45 10             	mov    0x10(%ebp),%eax
c0105696:	0f b6 00             	movzbl (%eax),%eax
c0105699:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010569c:	83 fb 2f             	cmp    $0x2f,%ebx
c010569f:	7e 0b                	jle    c01056ac <vprintfmt+0xb8>
c01056a1:	83 fb 39             	cmp    $0x39,%ebx
c01056a4:	7f 06                	jg     c01056ac <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056a6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01056aa:	eb d3                	jmp    c010567f <vprintfmt+0x8b>
            goto process_precision;
c01056ac:	eb 33                	jmp    c01056e1 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01056ae:	8b 45 14             	mov    0x14(%ebp),%eax
c01056b1:	8d 50 04             	lea    0x4(%eax),%edx
c01056b4:	89 55 14             	mov    %edx,0x14(%ebp)
c01056b7:	8b 00                	mov    (%eax),%eax
c01056b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056bc:	eb 23                	jmp    c01056e1 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01056be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056c2:	79 0c                	jns    c01056d0 <vprintfmt+0xdc>
                width = 0;
c01056c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056cb:	e9 78 ff ff ff       	jmp    c0105648 <vprintfmt+0x54>
c01056d0:	e9 73 ff ff ff       	jmp    c0105648 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01056d5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01056dc:	e9 67 ff ff ff       	jmp    c0105648 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01056e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056e5:	79 12                	jns    c01056f9 <vprintfmt+0x105>
                width = precision, precision = -1;
c01056e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056ed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01056f4:	e9 4f ff ff ff       	jmp    c0105648 <vprintfmt+0x54>
c01056f9:	e9 4a ff ff ff       	jmp    c0105648 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01056fe:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105702:	e9 41 ff ff ff       	jmp    c0105648 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105707:	8b 45 14             	mov    0x14(%ebp),%eax
c010570a:	8d 50 04             	lea    0x4(%eax),%edx
c010570d:	89 55 14             	mov    %edx,0x14(%ebp)
c0105710:	8b 00                	mov    (%eax),%eax
c0105712:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105715:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105719:	89 04 24             	mov    %eax,(%esp)
c010571c:	8b 45 08             	mov    0x8(%ebp),%eax
c010571f:	ff d0                	call   *%eax
            break;
c0105721:	e9 ac 02 00 00       	jmp    c01059d2 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105726:	8b 45 14             	mov    0x14(%ebp),%eax
c0105729:	8d 50 04             	lea    0x4(%eax),%edx
c010572c:	89 55 14             	mov    %edx,0x14(%ebp)
c010572f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105731:	85 db                	test   %ebx,%ebx
c0105733:	79 02                	jns    c0105737 <vprintfmt+0x143>
                err = -err;
c0105735:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105737:	83 fb 06             	cmp    $0x6,%ebx
c010573a:	7f 0b                	jg     c0105747 <vprintfmt+0x153>
c010573c:	8b 34 9d 08 71 10 c0 	mov    -0x3fef8ef8(,%ebx,4),%esi
c0105743:	85 f6                	test   %esi,%esi
c0105745:	75 23                	jne    c010576a <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105747:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010574b:	c7 44 24 08 35 71 10 	movl   $0xc0107135,0x8(%esp)
c0105752:	c0 
c0105753:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105756:	89 44 24 04          	mov    %eax,0x4(%esp)
c010575a:	8b 45 08             	mov    0x8(%ebp),%eax
c010575d:	89 04 24             	mov    %eax,(%esp)
c0105760:	e8 61 fe ff ff       	call   c01055c6 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105765:	e9 68 02 00 00       	jmp    c01059d2 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010576a:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010576e:	c7 44 24 08 3e 71 10 	movl   $0xc010713e,0x8(%esp)
c0105775:	c0 
c0105776:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105779:	89 44 24 04          	mov    %eax,0x4(%esp)
c010577d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105780:	89 04 24             	mov    %eax,(%esp)
c0105783:	e8 3e fe ff ff       	call   c01055c6 <printfmt>
            }
            break;
c0105788:	e9 45 02 00 00       	jmp    c01059d2 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010578d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105790:	8d 50 04             	lea    0x4(%eax),%edx
c0105793:	89 55 14             	mov    %edx,0x14(%ebp)
c0105796:	8b 30                	mov    (%eax),%esi
c0105798:	85 f6                	test   %esi,%esi
c010579a:	75 05                	jne    c01057a1 <vprintfmt+0x1ad>
                p = "(null)";
c010579c:	be 41 71 10 c0       	mov    $0xc0107141,%esi
            }
            if (width > 0 && padc != '-') {
c01057a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057a5:	7e 3e                	jle    c01057e5 <vprintfmt+0x1f1>
c01057a7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01057ab:	74 38                	je     c01057e5 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057ad:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01057b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057b7:	89 34 24             	mov    %esi,(%esp)
c01057ba:	e8 15 03 00 00       	call   c0105ad4 <strnlen>
c01057bf:	29 c3                	sub    %eax,%ebx
c01057c1:	89 d8                	mov    %ebx,%eax
c01057c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057c6:	eb 17                	jmp    c01057df <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01057c8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057cc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057cf:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057d3:	89 04 24             	mov    %eax,(%esp)
c01057d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d9:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057db:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057e3:	7f e3                	jg     c01057c8 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057e5:	eb 38                	jmp    c010581f <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01057e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01057eb:	74 1f                	je     c010580c <vprintfmt+0x218>
c01057ed:	83 fb 1f             	cmp    $0x1f,%ebx
c01057f0:	7e 05                	jle    c01057f7 <vprintfmt+0x203>
c01057f2:	83 fb 7e             	cmp    $0x7e,%ebx
c01057f5:	7e 15                	jle    c010580c <vprintfmt+0x218>
                    putch('?', putdat);
c01057f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057fe:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105805:	8b 45 08             	mov    0x8(%ebp),%eax
c0105808:	ff d0                	call   *%eax
c010580a:	eb 0f                	jmp    c010581b <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010580c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010580f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105813:	89 1c 24             	mov    %ebx,(%esp)
c0105816:	8b 45 08             	mov    0x8(%ebp),%eax
c0105819:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010581b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010581f:	89 f0                	mov    %esi,%eax
c0105821:	8d 70 01             	lea    0x1(%eax),%esi
c0105824:	0f b6 00             	movzbl (%eax),%eax
c0105827:	0f be d8             	movsbl %al,%ebx
c010582a:	85 db                	test   %ebx,%ebx
c010582c:	74 10                	je     c010583e <vprintfmt+0x24a>
c010582e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105832:	78 b3                	js     c01057e7 <vprintfmt+0x1f3>
c0105834:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105838:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010583c:	79 a9                	jns    c01057e7 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010583e:	eb 17                	jmp    c0105857 <vprintfmt+0x263>
                putch(' ', putdat);
c0105840:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105843:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105847:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010584e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105851:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105853:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105857:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010585b:	7f e3                	jg     c0105840 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010585d:	e9 70 01 00 00       	jmp    c01059d2 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105862:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105865:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105869:	8d 45 14             	lea    0x14(%ebp),%eax
c010586c:	89 04 24             	mov    %eax,(%esp)
c010586f:	e8 0b fd ff ff       	call   c010557f <getint>
c0105874:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105877:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010587a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010587d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105880:	85 d2                	test   %edx,%edx
c0105882:	79 26                	jns    c01058aa <vprintfmt+0x2b6>
                putch('-', putdat);
c0105884:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105887:	89 44 24 04          	mov    %eax,0x4(%esp)
c010588b:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105892:	8b 45 08             	mov    0x8(%ebp),%eax
c0105895:	ff d0                	call   *%eax
                num = -(long long)num;
c0105897:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010589a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010589d:	f7 d8                	neg    %eax
c010589f:	83 d2 00             	adc    $0x0,%edx
c01058a2:	f7 da                	neg    %edx
c01058a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01058aa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058b1:	e9 a8 00 00 00       	jmp    c010595e <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058b9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058bd:	8d 45 14             	lea    0x14(%ebp),%eax
c01058c0:	89 04 24             	mov    %eax,(%esp)
c01058c3:	e8 68 fc ff ff       	call   c0105530 <getuint>
c01058c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058ce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058d5:	e9 84 00 00 00       	jmp    c010595e <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058da:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058e1:	8d 45 14             	lea    0x14(%ebp),%eax
c01058e4:	89 04 24             	mov    %eax,(%esp)
c01058e7:	e8 44 fc ff ff       	call   c0105530 <getuint>
c01058ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01058f2:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01058f9:	eb 63                	jmp    c010595e <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01058fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105902:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105909:	8b 45 08             	mov    0x8(%ebp),%eax
c010590c:	ff d0                	call   *%eax
            putch('x', putdat);
c010590e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105911:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105915:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010591c:	8b 45 08             	mov    0x8(%ebp),%eax
c010591f:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105921:	8b 45 14             	mov    0x14(%ebp),%eax
c0105924:	8d 50 04             	lea    0x4(%eax),%edx
c0105927:	89 55 14             	mov    %edx,0x14(%ebp)
c010592a:	8b 00                	mov    (%eax),%eax
c010592c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010592f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105936:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010593d:	eb 1f                	jmp    c010595e <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010593f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105942:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105946:	8d 45 14             	lea    0x14(%ebp),%eax
c0105949:	89 04 24             	mov    %eax,(%esp)
c010594c:	e8 df fb ff ff       	call   c0105530 <getuint>
c0105951:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105954:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105957:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010595e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105962:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105965:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105969:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010596c:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105970:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105974:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105977:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010597a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010597e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105982:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105985:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105989:	8b 45 08             	mov    0x8(%ebp),%eax
c010598c:	89 04 24             	mov    %eax,(%esp)
c010598f:	e8 97 fa ff ff       	call   c010542b <printnum>
            break;
c0105994:	eb 3c                	jmp    c01059d2 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105996:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105999:	89 44 24 04          	mov    %eax,0x4(%esp)
c010599d:	89 1c 24             	mov    %ebx,(%esp)
c01059a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a3:	ff d0                	call   *%eax
            break;
c01059a5:	eb 2b                	jmp    c01059d2 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01059a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01059b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b8:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01059ba:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059be:	eb 04                	jmp    c01059c4 <vprintfmt+0x3d0>
c01059c0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01059c7:	83 e8 01             	sub    $0x1,%eax
c01059ca:	0f b6 00             	movzbl (%eax),%eax
c01059cd:	3c 25                	cmp    $0x25,%al
c01059cf:	75 ef                	jne    c01059c0 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01059d1:	90                   	nop
        }
    }
c01059d2:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01059d3:	e9 3e fc ff ff       	jmp    c0105616 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01059d8:	83 c4 40             	add    $0x40,%esp
c01059db:	5b                   	pop    %ebx
c01059dc:	5e                   	pop    %esi
c01059dd:	5d                   	pop    %ebp
c01059de:	c3                   	ret    

c01059df <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01059df:	55                   	push   %ebp
c01059e0:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01059e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e5:	8b 40 08             	mov    0x8(%eax),%eax
c01059e8:	8d 50 01             	lea    0x1(%eax),%edx
c01059eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ee:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01059f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f4:	8b 10                	mov    (%eax),%edx
c01059f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f9:	8b 40 04             	mov    0x4(%eax),%eax
c01059fc:	39 c2                	cmp    %eax,%edx
c01059fe:	73 12                	jae    c0105a12 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105a00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a03:	8b 00                	mov    (%eax),%eax
c0105a05:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a08:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a0b:	89 0a                	mov    %ecx,(%edx)
c0105a0d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a10:	88 10                	mov    %dl,(%eax)
    }
}
c0105a12:	5d                   	pop    %ebp
c0105a13:	c3                   	ret    

c0105a14 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a14:	55                   	push   %ebp
c0105a15:	89 e5                	mov    %esp,%ebp
c0105a17:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a1a:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a23:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a27:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a2a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a38:	89 04 24             	mov    %eax,(%esp)
c0105a3b:	e8 08 00 00 00       	call   c0105a48 <vsnprintf>
c0105a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a46:	c9                   	leave  
c0105a47:	c3                   	ret    

c0105a48 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a48:	55                   	push   %ebp
c0105a49:	89 e5                	mov    %esp,%ebp
c0105a4b:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a51:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a54:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a57:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a5d:	01 d0                	add    %edx,%eax
c0105a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a6d:	74 0a                	je     c0105a79 <vsnprintf+0x31>
c0105a6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a75:	39 c2                	cmp    %eax,%edx
c0105a77:	76 07                	jbe    c0105a80 <vsnprintf+0x38>
        return -E_INVAL;
c0105a79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a7e:	eb 2a                	jmp    c0105aaa <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105a80:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a83:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a87:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a8a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105a91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a95:	c7 04 24 df 59 10 c0 	movl   $0xc01059df,(%esp)
c0105a9c:	e8 53 fb ff ff       	call   c01055f4 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105aa4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105aaa:	c9                   	leave  
c0105aab:	c3                   	ret    

c0105aac <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105aac:	55                   	push   %ebp
c0105aad:	89 e5                	mov    %esp,%ebp
c0105aaf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ab2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105ab9:	eb 04                	jmp    c0105abf <strlen+0x13>
        cnt ++;
c0105abb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac2:	8d 50 01             	lea    0x1(%eax),%edx
c0105ac5:	89 55 08             	mov    %edx,0x8(%ebp)
c0105ac8:	0f b6 00             	movzbl (%eax),%eax
c0105acb:	84 c0                	test   %al,%al
c0105acd:	75 ec                	jne    c0105abb <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105acf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105ad2:	c9                   	leave  
c0105ad3:	c3                   	ret    

c0105ad4 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105ad4:	55                   	push   %ebp
c0105ad5:	89 e5                	mov    %esp,%ebp
c0105ad7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ada:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105ae1:	eb 04                	jmp    c0105ae7 <strnlen+0x13>
        cnt ++;
c0105ae3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105ae7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105aea:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105aed:	73 10                	jae    c0105aff <strnlen+0x2b>
c0105aef:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af2:	8d 50 01             	lea    0x1(%eax),%edx
c0105af5:	89 55 08             	mov    %edx,0x8(%ebp)
c0105af8:	0f b6 00             	movzbl (%eax),%eax
c0105afb:	84 c0                	test   %al,%al
c0105afd:	75 e4                	jne    c0105ae3 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105aff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b02:	c9                   	leave  
c0105b03:	c3                   	ret    

c0105b04 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105b04:	55                   	push   %ebp
c0105b05:	89 e5                	mov    %esp,%ebp
c0105b07:	57                   	push   %edi
c0105b08:	56                   	push   %esi
c0105b09:	83 ec 20             	sub    $0x20,%esp
c0105b0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b12:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105b18:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b1e:	89 d1                	mov    %edx,%ecx
c0105b20:	89 c2                	mov    %eax,%edx
c0105b22:	89 ce                	mov    %ecx,%esi
c0105b24:	89 d7                	mov    %edx,%edi
c0105b26:	ac                   	lods   %ds:(%esi),%al
c0105b27:	aa                   	stos   %al,%es:(%edi)
c0105b28:	84 c0                	test   %al,%al
c0105b2a:	75 fa                	jne    c0105b26 <strcpy+0x22>
c0105b2c:	89 fa                	mov    %edi,%edx
c0105b2e:	89 f1                	mov    %esi,%ecx
c0105b30:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b33:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105b3c:	83 c4 20             	add    $0x20,%esp
c0105b3f:	5e                   	pop    %esi
c0105b40:	5f                   	pop    %edi
c0105b41:	5d                   	pop    %ebp
c0105b42:	c3                   	ret    

c0105b43 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105b43:	55                   	push   %ebp
c0105b44:	89 e5                	mov    %esp,%ebp
c0105b46:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105b4f:	eb 21                	jmp    c0105b72 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105b51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b54:	0f b6 10             	movzbl (%eax),%edx
c0105b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b5a:	88 10                	mov    %dl,(%eax)
c0105b5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b5f:	0f b6 00             	movzbl (%eax),%eax
c0105b62:	84 c0                	test   %al,%al
c0105b64:	74 04                	je     c0105b6a <strncpy+0x27>
            src ++;
c0105b66:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105b6a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105b6e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105b72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b76:	75 d9                	jne    c0105b51 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105b78:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b7b:	c9                   	leave  
c0105b7c:	c3                   	ret    

c0105b7d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105b7d:	55                   	push   %ebp
c0105b7e:	89 e5                	mov    %esp,%ebp
c0105b80:	57                   	push   %edi
c0105b81:	56                   	push   %esi
c0105b82:	83 ec 20             	sub    $0x20,%esp
c0105b85:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b88:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b97:	89 d1                	mov    %edx,%ecx
c0105b99:	89 c2                	mov    %eax,%edx
c0105b9b:	89 ce                	mov    %ecx,%esi
c0105b9d:	89 d7                	mov    %edx,%edi
c0105b9f:	ac                   	lods   %ds:(%esi),%al
c0105ba0:	ae                   	scas   %es:(%edi),%al
c0105ba1:	75 08                	jne    c0105bab <strcmp+0x2e>
c0105ba3:	84 c0                	test   %al,%al
c0105ba5:	75 f8                	jne    c0105b9f <strcmp+0x22>
c0105ba7:	31 c0                	xor    %eax,%eax
c0105ba9:	eb 04                	jmp    c0105baf <strcmp+0x32>
c0105bab:	19 c0                	sbb    %eax,%eax
c0105bad:	0c 01                	or     $0x1,%al
c0105baf:	89 fa                	mov    %edi,%edx
c0105bb1:	89 f1                	mov    %esi,%ecx
c0105bb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bb6:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105bb9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105bbf:	83 c4 20             	add    $0x20,%esp
c0105bc2:	5e                   	pop    %esi
c0105bc3:	5f                   	pop    %edi
c0105bc4:	5d                   	pop    %ebp
c0105bc5:	c3                   	ret    

c0105bc6 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105bc6:	55                   	push   %ebp
c0105bc7:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bc9:	eb 0c                	jmp    c0105bd7 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105bcb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105bcf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bd3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bdb:	74 1a                	je     c0105bf7 <strncmp+0x31>
c0105bdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be0:	0f b6 00             	movzbl (%eax),%eax
c0105be3:	84 c0                	test   %al,%al
c0105be5:	74 10                	je     c0105bf7 <strncmp+0x31>
c0105be7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bea:	0f b6 10             	movzbl (%eax),%edx
c0105bed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bf0:	0f b6 00             	movzbl (%eax),%eax
c0105bf3:	38 c2                	cmp    %al,%dl
c0105bf5:	74 d4                	je     c0105bcb <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105bf7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bfb:	74 18                	je     c0105c15 <strncmp+0x4f>
c0105bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c00:	0f b6 00             	movzbl (%eax),%eax
c0105c03:	0f b6 d0             	movzbl %al,%edx
c0105c06:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c09:	0f b6 00             	movzbl (%eax),%eax
c0105c0c:	0f b6 c0             	movzbl %al,%eax
c0105c0f:	29 c2                	sub    %eax,%edx
c0105c11:	89 d0                	mov    %edx,%eax
c0105c13:	eb 05                	jmp    c0105c1a <strncmp+0x54>
c0105c15:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c1a:	5d                   	pop    %ebp
c0105c1b:	c3                   	ret    

c0105c1c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105c1c:	55                   	push   %ebp
c0105c1d:	89 e5                	mov    %esp,%ebp
c0105c1f:	83 ec 04             	sub    $0x4,%esp
c0105c22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c25:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c28:	eb 14                	jmp    c0105c3e <strchr+0x22>
        if (*s == c) {
c0105c2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c2d:	0f b6 00             	movzbl (%eax),%eax
c0105c30:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c33:	75 05                	jne    c0105c3a <strchr+0x1e>
            return (char *)s;
c0105c35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c38:	eb 13                	jmp    c0105c4d <strchr+0x31>
        }
        s ++;
c0105c3a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105c3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c41:	0f b6 00             	movzbl (%eax),%eax
c0105c44:	84 c0                	test   %al,%al
c0105c46:	75 e2                	jne    c0105c2a <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c4d:	c9                   	leave  
c0105c4e:	c3                   	ret    

c0105c4f <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105c4f:	55                   	push   %ebp
c0105c50:	89 e5                	mov    %esp,%ebp
c0105c52:	83 ec 04             	sub    $0x4,%esp
c0105c55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c58:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c5b:	eb 11                	jmp    c0105c6e <strfind+0x1f>
        if (*s == c) {
c0105c5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c60:	0f b6 00             	movzbl (%eax),%eax
c0105c63:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c66:	75 02                	jne    c0105c6a <strfind+0x1b>
            break;
c0105c68:	eb 0e                	jmp    c0105c78 <strfind+0x29>
        }
        s ++;
c0105c6a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105c6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c71:	0f b6 00             	movzbl (%eax),%eax
c0105c74:	84 c0                	test   %al,%al
c0105c76:	75 e5                	jne    c0105c5d <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105c78:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c7b:	c9                   	leave  
c0105c7c:	c3                   	ret    

c0105c7d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105c7d:	55                   	push   %ebp
c0105c7e:	89 e5                	mov    %esp,%ebp
c0105c80:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105c83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105c8a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c91:	eb 04                	jmp    c0105c97 <strtol+0x1a>
        s ++;
c0105c93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c9a:	0f b6 00             	movzbl (%eax),%eax
c0105c9d:	3c 20                	cmp    $0x20,%al
c0105c9f:	74 f2                	je     c0105c93 <strtol+0x16>
c0105ca1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca4:	0f b6 00             	movzbl (%eax),%eax
c0105ca7:	3c 09                	cmp    $0x9,%al
c0105ca9:	74 e8                	je     c0105c93 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105cab:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cae:	0f b6 00             	movzbl (%eax),%eax
c0105cb1:	3c 2b                	cmp    $0x2b,%al
c0105cb3:	75 06                	jne    c0105cbb <strtol+0x3e>
        s ++;
c0105cb5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cb9:	eb 15                	jmp    c0105cd0 <strtol+0x53>
    }
    else if (*s == '-') {
c0105cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cbe:	0f b6 00             	movzbl (%eax),%eax
c0105cc1:	3c 2d                	cmp    $0x2d,%al
c0105cc3:	75 0b                	jne    c0105cd0 <strtol+0x53>
        s ++, neg = 1;
c0105cc5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cc9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105cd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cd4:	74 06                	je     c0105cdc <strtol+0x5f>
c0105cd6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105cda:	75 24                	jne    c0105d00 <strtol+0x83>
c0105cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cdf:	0f b6 00             	movzbl (%eax),%eax
c0105ce2:	3c 30                	cmp    $0x30,%al
c0105ce4:	75 1a                	jne    c0105d00 <strtol+0x83>
c0105ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce9:	83 c0 01             	add    $0x1,%eax
c0105cec:	0f b6 00             	movzbl (%eax),%eax
c0105cef:	3c 78                	cmp    $0x78,%al
c0105cf1:	75 0d                	jne    c0105d00 <strtol+0x83>
        s += 2, base = 16;
c0105cf3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105cf7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105cfe:	eb 2a                	jmp    c0105d2a <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d04:	75 17                	jne    c0105d1d <strtol+0xa0>
c0105d06:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d09:	0f b6 00             	movzbl (%eax),%eax
c0105d0c:	3c 30                	cmp    $0x30,%al
c0105d0e:	75 0d                	jne    c0105d1d <strtol+0xa0>
        s ++, base = 8;
c0105d10:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d14:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d1b:	eb 0d                	jmp    c0105d2a <strtol+0xad>
    }
    else if (base == 0) {
c0105d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d21:	75 07                	jne    c0105d2a <strtol+0xad>
        base = 10;
c0105d23:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d2d:	0f b6 00             	movzbl (%eax),%eax
c0105d30:	3c 2f                	cmp    $0x2f,%al
c0105d32:	7e 1b                	jle    c0105d4f <strtol+0xd2>
c0105d34:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d37:	0f b6 00             	movzbl (%eax),%eax
c0105d3a:	3c 39                	cmp    $0x39,%al
c0105d3c:	7f 11                	jg     c0105d4f <strtol+0xd2>
            dig = *s - '0';
c0105d3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d41:	0f b6 00             	movzbl (%eax),%eax
c0105d44:	0f be c0             	movsbl %al,%eax
c0105d47:	83 e8 30             	sub    $0x30,%eax
c0105d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d4d:	eb 48                	jmp    c0105d97 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105d4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d52:	0f b6 00             	movzbl (%eax),%eax
c0105d55:	3c 60                	cmp    $0x60,%al
c0105d57:	7e 1b                	jle    c0105d74 <strtol+0xf7>
c0105d59:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5c:	0f b6 00             	movzbl (%eax),%eax
c0105d5f:	3c 7a                	cmp    $0x7a,%al
c0105d61:	7f 11                	jg     c0105d74 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105d63:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d66:	0f b6 00             	movzbl (%eax),%eax
c0105d69:	0f be c0             	movsbl %al,%eax
c0105d6c:	83 e8 57             	sub    $0x57,%eax
c0105d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d72:	eb 23                	jmp    c0105d97 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105d74:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d77:	0f b6 00             	movzbl (%eax),%eax
c0105d7a:	3c 40                	cmp    $0x40,%al
c0105d7c:	7e 3d                	jle    c0105dbb <strtol+0x13e>
c0105d7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d81:	0f b6 00             	movzbl (%eax),%eax
c0105d84:	3c 5a                	cmp    $0x5a,%al
c0105d86:	7f 33                	jg     c0105dbb <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105d88:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8b:	0f b6 00             	movzbl (%eax),%eax
c0105d8e:	0f be c0             	movsbl %al,%eax
c0105d91:	83 e8 37             	sub    $0x37,%eax
c0105d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d9a:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105d9d:	7c 02                	jl     c0105da1 <strtol+0x124>
            break;
c0105d9f:	eb 1a                	jmp    c0105dbb <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105da1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105da5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105da8:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105dac:	89 c2                	mov    %eax,%edx
c0105dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105db1:	01 d0                	add    %edx,%eax
c0105db3:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105db6:	e9 6f ff ff ff       	jmp    c0105d2a <strtol+0xad>

    if (endptr) {
c0105dbb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105dbf:	74 08                	je     c0105dc9 <strtol+0x14c>
        *endptr = (char *) s;
c0105dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dc4:	8b 55 08             	mov    0x8(%ebp),%edx
c0105dc7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105dc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105dcd:	74 07                	je     c0105dd6 <strtol+0x159>
c0105dcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dd2:	f7 d8                	neg    %eax
c0105dd4:	eb 03                	jmp    c0105dd9 <strtol+0x15c>
c0105dd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105dd9:	c9                   	leave  
c0105dda:	c3                   	ret    

c0105ddb <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105ddb:	55                   	push   %ebp
c0105ddc:	89 e5                	mov    %esp,%ebp
c0105dde:	57                   	push   %edi
c0105ddf:	83 ec 24             	sub    $0x24,%esp
c0105de2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105de5:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105de8:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105dec:	8b 55 08             	mov    0x8(%ebp),%edx
c0105def:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105df2:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105df5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105dfb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105dfe:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105e02:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105e05:	89 d7                	mov    %edx,%edi
c0105e07:	f3 aa                	rep stos %al,%es:(%edi)
c0105e09:	89 fa                	mov    %edi,%edx
c0105e0b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e0e:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105e11:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e14:	83 c4 24             	add    $0x24,%esp
c0105e17:	5f                   	pop    %edi
c0105e18:	5d                   	pop    %ebp
c0105e19:	c3                   	ret    

c0105e1a <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105e1a:	55                   	push   %ebp
c0105e1b:	89 e5                	mov    %esp,%ebp
c0105e1d:	57                   	push   %edi
c0105e1e:	56                   	push   %esi
c0105e1f:	53                   	push   %ebx
c0105e20:	83 ec 30             	sub    $0x30,%esp
c0105e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e2f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e32:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e38:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105e3b:	73 42                	jae    c0105e7f <memmove+0x65>
c0105e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e43:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e46:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e52:	c1 e8 02             	shr    $0x2,%eax
c0105e55:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e5d:	89 d7                	mov    %edx,%edi
c0105e5f:	89 c6                	mov    %eax,%esi
c0105e61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e63:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e66:	83 e1 03             	and    $0x3,%ecx
c0105e69:	74 02                	je     c0105e6d <memmove+0x53>
c0105e6b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e6d:	89 f0                	mov    %esi,%eax
c0105e6f:	89 fa                	mov    %edi,%edx
c0105e71:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105e74:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105e77:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e7d:	eb 36                	jmp    c0105eb5 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105e7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e82:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e85:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e88:	01 c2                	add    %eax,%edx
c0105e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e8d:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e93:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105e96:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e99:	89 c1                	mov    %eax,%ecx
c0105e9b:	89 d8                	mov    %ebx,%eax
c0105e9d:	89 d6                	mov    %edx,%esi
c0105e9f:	89 c7                	mov    %eax,%edi
c0105ea1:	fd                   	std    
c0105ea2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ea4:	fc                   	cld    
c0105ea5:	89 f8                	mov    %edi,%eax
c0105ea7:	89 f2                	mov    %esi,%edx
c0105ea9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105eac:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105eaf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105eb5:	83 c4 30             	add    $0x30,%esp
c0105eb8:	5b                   	pop    %ebx
c0105eb9:	5e                   	pop    %esi
c0105eba:	5f                   	pop    %edi
c0105ebb:	5d                   	pop    %ebp
c0105ebc:	c3                   	ret    

c0105ebd <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105ebd:	55                   	push   %ebp
c0105ebe:	89 e5                	mov    %esp,%ebp
c0105ec0:	57                   	push   %edi
c0105ec1:	56                   	push   %esi
c0105ec2:	83 ec 20             	sub    $0x20,%esp
c0105ec5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ece:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ed1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ed4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105eda:	c1 e8 02             	shr    $0x2,%eax
c0105edd:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ee5:	89 d7                	mov    %edx,%edi
c0105ee7:	89 c6                	mov    %eax,%esi
c0105ee9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105eeb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105eee:	83 e1 03             	and    $0x3,%ecx
c0105ef1:	74 02                	je     c0105ef5 <memcpy+0x38>
c0105ef3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ef5:	89 f0                	mov    %esi,%eax
c0105ef7:	89 fa                	mov    %edi,%edx
c0105ef9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105efc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105eff:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105f05:	83 c4 20             	add    $0x20,%esp
c0105f08:	5e                   	pop    %esi
c0105f09:	5f                   	pop    %edi
c0105f0a:	5d                   	pop    %ebp
c0105f0b:	c3                   	ret    

c0105f0c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105f0c:	55                   	push   %ebp
c0105f0d:	89 e5                	mov    %esp,%ebp
c0105f0f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f18:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105f1e:	eb 30                	jmp    c0105f50 <memcmp+0x44>
        if (*s1 != *s2) {
c0105f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f23:	0f b6 10             	movzbl (%eax),%edx
c0105f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f29:	0f b6 00             	movzbl (%eax),%eax
c0105f2c:	38 c2                	cmp    %al,%dl
c0105f2e:	74 18                	je     c0105f48 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f30:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f33:	0f b6 00             	movzbl (%eax),%eax
c0105f36:	0f b6 d0             	movzbl %al,%edx
c0105f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f3c:	0f b6 00             	movzbl (%eax),%eax
c0105f3f:	0f b6 c0             	movzbl %al,%eax
c0105f42:	29 c2                	sub    %eax,%edx
c0105f44:	89 d0                	mov    %edx,%eax
c0105f46:	eb 1a                	jmp    c0105f62 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105f48:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105f4c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105f50:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f53:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f56:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f59:	85 c0                	test   %eax,%eax
c0105f5b:	75 c3                	jne    c0105f20 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105f5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f62:	c9                   	leave  
c0105f63:	c3                   	ret    
