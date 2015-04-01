
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 85 5d 00 00       	call   105ddb <memset>

    cons_init();                // init the console
  100056:	e8 7a 15 00 00       	call   1015d5 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 80 5f 10 00 	movl   $0x105f80,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 9c 5f 10 00 	movl   $0x105f9c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 55 42 00 00       	call   1042d9 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b5 16 00 00       	call   10173e <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 2d 18 00 00       	call   1018bb <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 f8 0c 00 00       	call   100d8b <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 14 16 00 00       	call   1016ac <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 01 0c 00 00       	call   100cbd <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 a1 5f 10 00 	movl   $0x105fa1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 af 5f 10 00 	movl   $0x105faf,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 bd 5f 10 00 	movl   $0x105fbd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 cb 5f 10 00 	movl   $0x105fcb,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 d9 5f 10 00 	movl   $0x105fd9,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 e8 5f 10 00 	movl   $0x105fe8,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 08 60 10 00 	movl   $0x106008,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 27 60 10 00 	movl   $0x106027,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 07 13 00 00       	call   101601 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 bd 52 00 00       	call   1055f4 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 8e 12 00 00       	call   101601 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 6e 12 00 00       	call   10163d <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 2c 60 10 00    	movl   $0x10602c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 2c 60 10 00 	movl   $0x10602c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 a0 72 10 00 	movl   $0x1072a0,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 f0 1e 11 00 	movl   $0x111ef0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec f1 1e 11 00 	movl   $0x111ef1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 1e 49 11 00 	movl   $0x11491e,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 63 55 00 00       	call   105c4f <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 36 60 10 00 	movl   $0x106036,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 4f 60 10 00 	movl   $0x10604f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 64 5f 10 	movl   $0x105f64,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 67 60 10 00 	movl   $0x106067,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 7f 60 10 00 	movl   $0x10607f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 97 60 10 00 	movl   $0x106097,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 b0 60 10 00 	movl   $0x1060b0,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 da 60 10 00 	movl   $0x1060da,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 f6 60 10 00 	movl   $0x1060f6,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i, j;
    for(i = 0 ; i < STACKFRAME_DEPTH ; i ++)
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	e9 97 00 00 00       	jmp    100a76 <print_stackframe+0xbc>
    {
        cprintf("ebp is 0x%08x, eip is 0x%08x, ", ebp, eip);
  1009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ed:	c7 04 24 08 61 10 00 	movl   $0x106108,(%esp)
  1009f4:	e8 43 f9 ff ff       	call   10033c <cprintf>
        uint32_t* argu = (uint32_t*)ebp + 2;
  1009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fc:	83 c0 08             	add    $0x8,%eax
  1009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for(j = 0 ; j < 4 ; j ++)
  100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a09:	eb 2c                	jmp    100a37 <print_stackframe+0x7d>
        {
            cprintf("argu[%d] is 0%08x, ", j, argu[j]);
  100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a18:	01 d0                	add    %edx,%eax
  100a1a:	8b 00                	mov    (%eax),%eax
  100a1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a27:	c7 04 24 27 61 10 00 	movl   $0x106127,(%esp)
  100a2e:	e8 09 f9 ff ff       	call   10033c <cprintf>
    int i, j;
    for(i = 0 ; i < STACKFRAME_DEPTH ; i ++)
    {
        cprintf("ebp is 0x%08x, eip is 0x%08x, ", ebp, eip);
        uint32_t* argu = (uint32_t*)ebp + 2;
        for(j = 0 ; j < 4 ; j ++)
  100a33:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a37:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a3b:	7e ce                	jle    100a0b <print_stackframe+0x51>
        {
            cprintf("argu[%d] is 0%08x, ", j, argu[j]);
        }
        cprintf("\n");
  100a3d:	c7 04 24 3b 61 10 00 	movl   $0x10613b,(%esp)
  100a44:	e8 f3 f8 ff ff       	call   10033c <cprintf>
        print_debuginfo(eip - 1);
  100a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a4c:	83 e8 01             	sub    $0x1,%eax
  100a4f:	89 04 24             	mov    %eax,(%esp)
  100a52:	e8 af fe ff ff       	call   100906 <print_debuginfo>
        eip = ((uint32_t*)ebp)[1];
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	83 c0 04             	add    $0x4,%eax
  100a5d:	8b 00                	mov    (%eax),%eax
  100a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t*)ebp)[0];
  100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a65:	8b 00                	mov    (%eax),%eax
  100a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(ebp == 0)
  100a6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a6e:	75 02                	jne    100a72 <print_stackframe+0xb8>
            break;
  100a70:	eb 0e                	jmp    100a80 <print_stackframe+0xc6>
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
    uint32_t eip = read_eip();
    int i, j;
    for(i = 0 ; i < STACKFRAME_DEPTH ; i ++)
  100a72:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a76:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a7a:	0f 8e 5f ff ff ff    	jle    1009df <print_stackframe+0x25>
        eip = ((uint32_t*)ebp)[1];
        ebp = ((uint32_t*)ebp)[0];
        if(ebp == 0)
            break;
    }
}
  100a80:	c9                   	leave  
  100a81:	c3                   	ret    

00100a82 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a82:	55                   	push   %ebp
  100a83:	89 e5                	mov    %esp,%ebp
  100a85:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8f:	eb 0c                	jmp    100a9d <parse+0x1b>
            *buf ++ = '\0';
  100a91:	8b 45 08             	mov    0x8(%ebp),%eax
  100a94:	8d 50 01             	lea    0x1(%eax),%edx
  100a97:	89 55 08             	mov    %edx,0x8(%ebp)
  100a9a:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa0:	0f b6 00             	movzbl (%eax),%eax
  100aa3:	84 c0                	test   %al,%al
  100aa5:	74 1d                	je     100ac4 <parse+0x42>
  100aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  100aaa:	0f b6 00             	movzbl (%eax),%eax
  100aad:	0f be c0             	movsbl %al,%eax
  100ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab4:	c7 04 24 c0 61 10 00 	movl   $0x1061c0,(%esp)
  100abb:	e8 5c 51 00 00       	call   105c1c <strchr>
  100ac0:	85 c0                	test   %eax,%eax
  100ac2:	75 cd                	jne    100a91 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac7:	0f b6 00             	movzbl (%eax),%eax
  100aca:	84 c0                	test   %al,%al
  100acc:	75 02                	jne    100ad0 <parse+0x4e>
            break;
  100ace:	eb 67                	jmp    100b37 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ad0:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad4:	75 14                	jne    100aea <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad6:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100add:	00 
  100ade:	c7 04 24 c5 61 10 00 	movl   $0x1061c5,(%esp)
  100ae5:	e8 52 f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aed:	8d 50 01             	lea    0x1(%eax),%edx
  100af0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  100afd:	01 c2                	add    %eax,%edx
  100aff:	8b 45 08             	mov    0x8(%ebp),%eax
  100b02:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b04:	eb 04                	jmp    100b0a <parse+0x88>
            buf ++;
  100b06:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0d:	0f b6 00             	movzbl (%eax),%eax
  100b10:	84 c0                	test   %al,%al
  100b12:	74 1d                	je     100b31 <parse+0xaf>
  100b14:	8b 45 08             	mov    0x8(%ebp),%eax
  100b17:	0f b6 00             	movzbl (%eax),%eax
  100b1a:	0f be c0             	movsbl %al,%eax
  100b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b21:	c7 04 24 c0 61 10 00 	movl   $0x1061c0,(%esp)
  100b28:	e8 ef 50 00 00       	call   105c1c <strchr>
  100b2d:	85 c0                	test   %eax,%eax
  100b2f:	74 d5                	je     100b06 <parse+0x84>
            buf ++;
        }
    }
  100b31:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b32:	e9 66 ff ff ff       	jmp    100a9d <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b3a:	c9                   	leave  
  100b3b:	c3                   	ret    

00100b3c <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3c:	55                   	push   %ebp
  100b3d:	89 e5                	mov    %esp,%ebp
  100b3f:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b42:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b45:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b49:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4c:	89 04 24             	mov    %eax,(%esp)
  100b4f:	e8 2e ff ff ff       	call   100a82 <parse>
  100b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b5b:	75 0a                	jne    100b67 <runcmd+0x2b>
        return 0;
  100b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  100b62:	e9 85 00 00 00       	jmp    100bec <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b6e:	eb 5c                	jmp    100bcc <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b70:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b76:	89 d0                	mov    %edx,%eax
  100b78:	01 c0                	add    %eax,%eax
  100b7a:	01 d0                	add    %edx,%eax
  100b7c:	c1 e0 02             	shl    $0x2,%eax
  100b7f:	05 20 70 11 00       	add    $0x117020,%eax
  100b84:	8b 00                	mov    (%eax),%eax
  100b86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b8a:	89 04 24             	mov    %eax,(%esp)
  100b8d:	e8 eb 4f 00 00       	call   105b7d <strcmp>
  100b92:	85 c0                	test   %eax,%eax
  100b94:	75 32                	jne    100bc8 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b99:	89 d0                	mov    %edx,%eax
  100b9b:	01 c0                	add    %eax,%eax
  100b9d:	01 d0                	add    %edx,%eax
  100b9f:	c1 e0 02             	shl    $0x2,%eax
  100ba2:	05 20 70 11 00       	add    $0x117020,%eax
  100ba7:	8b 40 08             	mov    0x8(%eax),%eax
  100baa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bad:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb3:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb7:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bba:	83 c2 04             	add    $0x4,%edx
  100bbd:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bc1:	89 0c 24             	mov    %ecx,(%esp)
  100bc4:	ff d0                	call   *%eax
  100bc6:	eb 24                	jmp    100bec <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bcf:	83 f8 02             	cmp    $0x2,%eax
  100bd2:	76 9c                	jbe    100b70 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdb:	c7 04 24 e3 61 10 00 	movl   $0x1061e3,(%esp)
  100be2:	e8 55 f7 ff ff       	call   10033c <cprintf>
    return 0;
  100be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bec:	c9                   	leave  
  100bed:	c3                   	ret    

00100bee <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bee:	55                   	push   %ebp
  100bef:	89 e5                	mov    %esp,%ebp
  100bf1:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf4:	c7 04 24 fc 61 10 00 	movl   $0x1061fc,(%esp)
  100bfb:	e8 3c f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c00:	c7 04 24 24 62 10 00 	movl   $0x106224,(%esp)
  100c07:	e8 30 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c10:	74 0b                	je     100c1d <kmonitor+0x2f>
        print_trapframe(tf);
  100c12:	8b 45 08             	mov    0x8(%ebp),%eax
  100c15:	89 04 24             	mov    %eax,(%esp)
  100c18:	e8 d6 0d 00 00       	call   1019f3 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c1d:	c7 04 24 49 62 10 00 	movl   $0x106249,(%esp)
  100c24:	e8 0a f6 ff ff       	call   100233 <readline>
  100c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c30:	74 18                	je     100c4a <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c32:	8b 45 08             	mov    0x8(%ebp),%eax
  100c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3c:	89 04 24             	mov    %eax,(%esp)
  100c3f:	e8 f8 fe ff ff       	call   100b3c <runcmd>
  100c44:	85 c0                	test   %eax,%eax
  100c46:	79 02                	jns    100c4a <kmonitor+0x5c>
                break;
  100c48:	eb 02                	jmp    100c4c <kmonitor+0x5e>
            }
        }
    }
  100c4a:	eb d1                	jmp    100c1d <kmonitor+0x2f>
}
  100c4c:	c9                   	leave  
  100c4d:	c3                   	ret    

00100c4e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c4e:	55                   	push   %ebp
  100c4f:	89 e5                	mov    %esp,%ebp
  100c51:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c5b:	eb 3f                	jmp    100c9c <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c60:	89 d0                	mov    %edx,%eax
  100c62:	01 c0                	add    %eax,%eax
  100c64:	01 d0                	add    %edx,%eax
  100c66:	c1 e0 02             	shl    $0x2,%eax
  100c69:	05 20 70 11 00       	add    $0x117020,%eax
  100c6e:	8b 48 04             	mov    0x4(%eax),%ecx
  100c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c74:	89 d0                	mov    %edx,%eax
  100c76:	01 c0                	add    %eax,%eax
  100c78:	01 d0                	add    %edx,%eax
  100c7a:	c1 e0 02             	shl    $0x2,%eax
  100c7d:	05 20 70 11 00       	add    $0x117020,%eax
  100c82:	8b 00                	mov    (%eax),%eax
  100c84:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8c:	c7 04 24 4d 62 10 00 	movl   $0x10624d,(%esp)
  100c93:	e8 a4 f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c98:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9f:	83 f8 02             	cmp    $0x2,%eax
  100ca2:	76 b9                	jbe    100c5d <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca9:	c9                   	leave  
  100caa:	c3                   	ret    

00100cab <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cab:	55                   	push   %ebp
  100cac:	89 e5                	mov    %esp,%ebp
  100cae:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cb1:	e8 ba fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbb:	c9                   	leave  
  100cbc:	c3                   	ret    

00100cbd <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cbd:	55                   	push   %ebp
  100cbe:	89 e5                	mov    %esp,%ebp
  100cc0:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc3:	e8 f2 fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccd:	c9                   	leave  
  100cce:	c3                   	ret    

00100ccf <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ccf:	55                   	push   %ebp
  100cd0:	89 e5                	mov    %esp,%ebp
  100cd2:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd5:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cda:	85 c0                	test   %eax,%eax
  100cdc:	74 02                	je     100ce0 <__panic+0x11>
        goto panic_dead;
  100cde:	eb 48                	jmp    100d28 <__panic+0x59>
    }
    is_panic = 1;
  100ce0:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100ce7:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cea:	8d 45 14             	lea    0x14(%ebp),%eax
  100ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf3:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  100cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfe:	c7 04 24 56 62 10 00 	movl   $0x106256,(%esp)
  100d05:	e8 32 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d11:	8b 45 10             	mov    0x10(%ebp),%eax
  100d14:	89 04 24             	mov    %eax,(%esp)
  100d17:	e8 ed f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d1c:	c7 04 24 72 62 10 00 	movl   $0x106272,(%esp)
  100d23:	e8 14 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d28:	e8 85 09 00 00       	call   1016b2 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d34:	e8 b5 fe ff ff       	call   100bee <kmonitor>
    }
  100d39:	eb f2                	jmp    100d2d <__panic+0x5e>

00100d3b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d3b:	55                   	push   %ebp
  100d3c:	89 e5                	mov    %esp,%ebp
  100d3e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d41:	8d 45 14             	lea    0x14(%ebp),%eax
  100d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  100d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d55:	c7 04 24 74 62 10 00 	movl   $0x106274,(%esp)
  100d5c:	e8 db f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d68:	8b 45 10             	mov    0x10(%ebp),%eax
  100d6b:	89 04 24             	mov    %eax,(%esp)
  100d6e:	e8 96 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d73:	c7 04 24 72 62 10 00 	movl   $0x106272,(%esp)
  100d7a:	e8 bd f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d7f:	c9                   	leave  
  100d80:	c3                   	ret    

00100d81 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d81:	55                   	push   %ebp
  100d82:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d84:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d89:	5d                   	pop    %ebp
  100d8a:	c3                   	ret    

00100d8b <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d8b:	55                   	push   %ebp
  100d8c:	89 e5                	mov    %esp,%ebp
  100d8e:	83 ec 28             	sub    $0x28,%esp
  100d91:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d97:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d9b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d9f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100da3:	ee                   	out    %al,(%dx)
  100da4:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100daa:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dae:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100db2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db6:	ee                   	out    %al,(%dx)
  100db7:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dbd:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dc1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc9:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dca:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dd1:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd4:	c7 04 24 92 62 10 00 	movl   $0x106292,(%esp)
  100ddb:	e8 5c f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100de0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de7:	e8 24 09 00 00       	call   101710 <pic_enable>
}
  100dec:	c9                   	leave  
  100ded:	c3                   	ret    

00100dee <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dee:	55                   	push   %ebp
  100def:	89 e5                	mov    %esp,%ebp
  100df1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100df4:	9c                   	pushf  
  100df5:	58                   	pop    %eax
  100df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dfc:	25 00 02 00 00       	and    $0x200,%eax
  100e01:	85 c0                	test   %eax,%eax
  100e03:	74 0c                	je     100e11 <__intr_save+0x23>
        intr_disable();
  100e05:	e8 a8 08 00 00       	call   1016b2 <intr_disable>
        return 1;
  100e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  100e0f:	eb 05                	jmp    100e16 <__intr_save+0x28>
    }
    return 0;
  100e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e16:	c9                   	leave  
  100e17:	c3                   	ret    

00100e18 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e18:	55                   	push   %ebp
  100e19:	89 e5                	mov    %esp,%ebp
  100e1b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e22:	74 05                	je     100e29 <__intr_restore+0x11>
        intr_enable();
  100e24:	e8 83 08 00 00       	call   1016ac <intr_enable>
    }
}
  100e29:	c9                   	leave  
  100e2a:	c3                   	ret    

00100e2b <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e2b:	55                   	push   %ebp
  100e2c:	89 e5                	mov    %esp,%ebp
  100e2e:	83 ec 10             	sub    $0x10,%esp
  100e31:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e37:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e3b:	89 c2                	mov    %eax,%edx
  100e3d:	ec                   	in     (%dx),%al
  100e3e:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e41:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e47:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e4b:	89 c2                	mov    %eax,%edx
  100e4d:	ec                   	in     (%dx),%al
  100e4e:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e51:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e57:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e5b:	89 c2                	mov    %eax,%edx
  100e5d:	ec                   	in     (%dx),%al
  100e5e:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e61:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e67:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e6b:	89 c2                	mov    %eax,%edx
  100e6d:	ec                   	in     (%dx),%al
  100e6e:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e71:	c9                   	leave  
  100e72:	c3                   	ret    

00100e73 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e73:	55                   	push   %ebp
  100e74:	89 e5                	mov    %esp,%ebp
  100e76:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e79:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e83:	0f b7 00             	movzwl (%eax),%eax
  100e86:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e95:	0f b7 00             	movzwl (%eax),%eax
  100e98:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e9c:	74 12                	je     100eb0 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e9e:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ea5:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100eac:	b4 03 
  100eae:	eb 13                	jmp    100ec3 <cga_init+0x50>
    } else {
        *cp = was;
  100eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb7:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eba:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ec1:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ec3:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100eca:	0f b7 c0             	movzwl %ax,%eax
  100ecd:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ed1:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100edd:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ede:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ee5:	83 c0 01             	add    $0x1,%eax
  100ee8:	0f b7 c0             	movzwl %ax,%eax
  100eeb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eef:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ef3:	89 c2                	mov    %eax,%edx
  100ef5:	ec                   	in     (%dx),%al
  100ef6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100efd:	0f b6 c0             	movzbl %al,%eax
  100f00:	c1 e0 08             	shl    $0x8,%eax
  100f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f06:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f0d:	0f b7 c0             	movzwl %ax,%eax
  100f10:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f14:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f18:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f1c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f20:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f21:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f28:	83 c0 01             	add    $0x1,%eax
  100f2b:	0f b7 c0             	movzwl %ax,%eax
  100f2e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f32:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f36:	89 c2                	mov    %eax,%edx
  100f38:	ec                   	in     (%dx),%al
  100f39:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f3c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f40:	0f b6 c0             	movzbl %al,%eax
  100f43:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f49:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f51:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f57:	c9                   	leave  
  100f58:	c3                   	ret    

00100f59 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f59:	55                   	push   %ebp
  100f5a:	89 e5                	mov    %esp,%ebp
  100f5c:	83 ec 48             	sub    $0x48,%esp
  100f5f:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f65:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f69:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f6d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f71:	ee                   	out    %al,(%dx)
  100f72:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f78:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f7c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f80:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f84:	ee                   	out    %al,(%dx)
  100f85:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f8b:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f8f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f93:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f97:	ee                   	out    %al,(%dx)
  100f98:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f9e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fa2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100faa:	ee                   	out    %al,(%dx)
  100fab:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fb1:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fb5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fbd:	ee                   	out    %al,(%dx)
  100fbe:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fc4:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fc8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fcc:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fd0:	ee                   	out    %al,(%dx)
  100fd1:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd7:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fdb:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fdf:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fe3:	ee                   	out    %al,(%dx)
  100fe4:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fea:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fee:	89 c2                	mov    %eax,%edx
  100ff0:	ec                   	in     (%dx),%al
  100ff1:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ff4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ff8:	3c ff                	cmp    $0xff,%al
  100ffa:	0f 95 c0             	setne  %al
  100ffd:	0f b6 c0             	movzbl %al,%eax
  101000:	a3 88 7e 11 00       	mov    %eax,0x117e88
  101005:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10100b:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  10100f:	89 c2                	mov    %eax,%edx
  101011:	ec                   	in     (%dx),%al
  101012:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101015:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  10101b:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  10101f:	89 c2                	mov    %eax,%edx
  101021:	ec                   	in     (%dx),%al
  101022:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101025:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10102a:	85 c0                	test   %eax,%eax
  10102c:	74 0c                	je     10103a <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10102e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101035:	e8 d6 06 00 00       	call   101710 <pic_enable>
    }
}
  10103a:	c9                   	leave  
  10103b:	c3                   	ret    

0010103c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10103c:	55                   	push   %ebp
  10103d:	89 e5                	mov    %esp,%ebp
  10103f:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101042:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101049:	eb 09                	jmp    101054 <lpt_putc_sub+0x18>
        delay();
  10104b:	e8 db fd ff ff       	call   100e2b <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101050:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101054:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10105a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10105e:	89 c2                	mov    %eax,%edx
  101060:	ec                   	in     (%dx),%al
  101061:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101064:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101068:	84 c0                	test   %al,%al
  10106a:	78 09                	js     101075 <lpt_putc_sub+0x39>
  10106c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101073:	7e d6                	jle    10104b <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101075:	8b 45 08             	mov    0x8(%ebp),%eax
  101078:	0f b6 c0             	movzbl %al,%eax
  10107b:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101081:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101084:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101088:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10108c:	ee                   	out    %al,(%dx)
  10108d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101093:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101097:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10109b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10109f:	ee                   	out    %al,(%dx)
  1010a0:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010a6:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010aa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010ae:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b2:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010b3:	c9                   	leave  
  1010b4:	c3                   	ret    

001010b5 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010b5:	55                   	push   %ebp
  1010b6:	89 e5                	mov    %esp,%ebp
  1010b8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010bb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010bf:	74 0d                	je     1010ce <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c4:	89 04 24             	mov    %eax,(%esp)
  1010c7:	e8 70 ff ff ff       	call   10103c <lpt_putc_sub>
  1010cc:	eb 24                	jmp    1010f2 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010ce:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d5:	e8 62 ff ff ff       	call   10103c <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010da:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010e1:	e8 56 ff ff ff       	call   10103c <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ed:	e8 4a ff ff ff       	call   10103c <lpt_putc_sub>
    }
}
  1010f2:	c9                   	leave  
  1010f3:	c3                   	ret    

001010f4 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010f4:	55                   	push   %ebp
  1010f5:	89 e5                	mov    %esp,%ebp
  1010f7:	53                   	push   %ebx
  1010f8:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fe:	b0 00                	mov    $0x0,%al
  101100:	85 c0                	test   %eax,%eax
  101102:	75 07                	jne    10110b <cga_putc+0x17>
        c |= 0x0700;
  101104:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10110b:	8b 45 08             	mov    0x8(%ebp),%eax
  10110e:	0f b6 c0             	movzbl %al,%eax
  101111:	83 f8 0a             	cmp    $0xa,%eax
  101114:	74 4c                	je     101162 <cga_putc+0x6e>
  101116:	83 f8 0d             	cmp    $0xd,%eax
  101119:	74 57                	je     101172 <cga_putc+0x7e>
  10111b:	83 f8 08             	cmp    $0x8,%eax
  10111e:	0f 85 88 00 00 00    	jne    1011ac <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101124:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10112b:	66 85 c0             	test   %ax,%ax
  10112e:	74 30                	je     101160 <cga_putc+0x6c>
            crt_pos --;
  101130:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101137:	83 e8 01             	sub    $0x1,%eax
  10113a:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101140:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101145:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  10114c:	0f b7 d2             	movzwl %dx,%edx
  10114f:	01 d2                	add    %edx,%edx
  101151:	01 c2                	add    %eax,%edx
  101153:	8b 45 08             	mov    0x8(%ebp),%eax
  101156:	b0 00                	mov    $0x0,%al
  101158:	83 c8 20             	or     $0x20,%eax
  10115b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10115e:	eb 72                	jmp    1011d2 <cga_putc+0xde>
  101160:	eb 70                	jmp    1011d2 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101162:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101169:	83 c0 50             	add    $0x50,%eax
  10116c:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101172:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101179:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101180:	0f b7 c1             	movzwl %cx,%eax
  101183:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101189:	c1 e8 10             	shr    $0x10,%eax
  10118c:	89 c2                	mov    %eax,%edx
  10118e:	66 c1 ea 06          	shr    $0x6,%dx
  101192:	89 d0                	mov    %edx,%eax
  101194:	c1 e0 02             	shl    $0x2,%eax
  101197:	01 d0                	add    %edx,%eax
  101199:	c1 e0 04             	shl    $0x4,%eax
  10119c:	29 c1                	sub    %eax,%ecx
  10119e:	89 ca                	mov    %ecx,%edx
  1011a0:	89 d8                	mov    %ebx,%eax
  1011a2:	29 d0                	sub    %edx,%eax
  1011a4:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011aa:	eb 26                	jmp    1011d2 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011ac:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011b2:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b9:	8d 50 01             	lea    0x1(%eax),%edx
  1011bc:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011c3:	0f b7 c0             	movzwl %ax,%eax
  1011c6:	01 c0                	add    %eax,%eax
  1011c8:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1011ce:	66 89 02             	mov    %ax,(%edx)
        break;
  1011d1:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011d2:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d9:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011dd:	76 5b                	jbe    10123a <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011df:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011ea:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011ef:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f6:	00 
  1011f7:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011fb:	89 04 24             	mov    %eax,(%esp)
  1011fe:	e8 17 4c 00 00       	call   105e1a <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101203:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10120a:	eb 15                	jmp    101221 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10120c:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101211:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101214:	01 d2                	add    %edx,%edx
  101216:	01 d0                	add    %edx,%eax
  101218:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101221:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101228:	7e e2                	jle    10120c <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10122a:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101231:	83 e8 50             	sub    $0x50,%eax
  101234:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10123a:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101241:	0f b7 c0             	movzwl %ax,%eax
  101244:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101248:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10124c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101250:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101254:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101255:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10125c:	66 c1 e8 08          	shr    $0x8,%ax
  101260:	0f b6 c0             	movzbl %al,%eax
  101263:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10126a:	83 c2 01             	add    $0x1,%edx
  10126d:	0f b7 d2             	movzwl %dx,%edx
  101270:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101274:	88 45 ed             	mov    %al,-0x13(%ebp)
  101277:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10127b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10127f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101280:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101287:	0f b7 c0             	movzwl %ax,%eax
  10128a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10128e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101292:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101296:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10129a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10129b:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1012a2:	0f b6 c0             	movzbl %al,%eax
  1012a5:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012ac:	83 c2 01             	add    $0x1,%edx
  1012af:	0f b7 d2             	movzwl %dx,%edx
  1012b2:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012b6:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012bd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012c1:	ee                   	out    %al,(%dx)
}
  1012c2:	83 c4 34             	add    $0x34,%esp
  1012c5:	5b                   	pop    %ebx
  1012c6:	5d                   	pop    %ebp
  1012c7:	c3                   	ret    

001012c8 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c8:	55                   	push   %ebp
  1012c9:	89 e5                	mov    %esp,%ebp
  1012cb:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d5:	eb 09                	jmp    1012e0 <serial_putc_sub+0x18>
        delay();
  1012d7:	e8 4f fb ff ff       	call   100e2b <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012e0:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012ea:	89 c2                	mov    %eax,%edx
  1012ec:	ec                   	in     (%dx),%al
  1012ed:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012f0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f4:	0f b6 c0             	movzbl %al,%eax
  1012f7:	83 e0 20             	and    $0x20,%eax
  1012fa:	85 c0                	test   %eax,%eax
  1012fc:	75 09                	jne    101307 <serial_putc_sub+0x3f>
  1012fe:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101305:	7e d0                	jle    1012d7 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101307:	8b 45 08             	mov    0x8(%ebp),%eax
  10130a:	0f b6 c0             	movzbl %al,%eax
  10130d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101313:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101316:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10131a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10131e:	ee                   	out    %al,(%dx)
}
  10131f:	c9                   	leave  
  101320:	c3                   	ret    

00101321 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101321:	55                   	push   %ebp
  101322:	89 e5                	mov    %esp,%ebp
  101324:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101327:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10132b:	74 0d                	je     10133a <serial_putc+0x19>
        serial_putc_sub(c);
  10132d:	8b 45 08             	mov    0x8(%ebp),%eax
  101330:	89 04 24             	mov    %eax,(%esp)
  101333:	e8 90 ff ff ff       	call   1012c8 <serial_putc_sub>
  101338:	eb 24                	jmp    10135e <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10133a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101341:	e8 82 ff ff ff       	call   1012c8 <serial_putc_sub>
        serial_putc_sub(' ');
  101346:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10134d:	e8 76 ff ff ff       	call   1012c8 <serial_putc_sub>
        serial_putc_sub('\b');
  101352:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101359:	e8 6a ff ff ff       	call   1012c8 <serial_putc_sub>
    }
}
  10135e:	c9                   	leave  
  10135f:	c3                   	ret    

00101360 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101360:	55                   	push   %ebp
  101361:	89 e5                	mov    %esp,%ebp
  101363:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101366:	eb 33                	jmp    10139b <cons_intr+0x3b>
        if (c != 0) {
  101368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10136c:	74 2d                	je     10139b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10136e:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101373:	8d 50 01             	lea    0x1(%eax),%edx
  101376:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  10137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10137f:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101385:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10138a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138f:	75 0a                	jne    10139b <cons_intr+0x3b>
                cons.wpos = 0;
  101391:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101398:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10139b:	8b 45 08             	mov    0x8(%ebp),%eax
  10139e:	ff d0                	call   *%eax
  1013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a7:	75 bf                	jne    101368 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a9:	c9                   	leave  
  1013aa:	c3                   	ret    

001013ab <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013ab:	55                   	push   %ebp
  1013ac:	89 e5                	mov    %esp,%ebp
  1013ae:	83 ec 10             	sub    $0x10,%esp
  1013b1:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013bb:	89 c2                	mov    %eax,%edx
  1013bd:	ec                   	in     (%dx),%al
  1013be:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013c1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c5:	0f b6 c0             	movzbl %al,%eax
  1013c8:	83 e0 01             	and    $0x1,%eax
  1013cb:	85 c0                	test   %eax,%eax
  1013cd:	75 07                	jne    1013d6 <serial_proc_data+0x2b>
        return -1;
  1013cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d4:	eb 2a                	jmp    101400 <serial_proc_data+0x55>
  1013d6:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013dc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013e0:	89 c2                	mov    %eax,%edx
  1013e2:	ec                   	in     (%dx),%al
  1013e3:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013ea:	0f b6 c0             	movzbl %al,%eax
  1013ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013f0:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f4:	75 07                	jne    1013fd <serial_proc_data+0x52>
        c = '\b';
  1013f6:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101400:	c9                   	leave  
  101401:	c3                   	ret    

00101402 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101402:	55                   	push   %ebp
  101403:	89 e5                	mov    %esp,%ebp
  101405:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101408:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10140d:	85 c0                	test   %eax,%eax
  10140f:	74 0c                	je     10141d <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101411:	c7 04 24 ab 13 10 00 	movl   $0x1013ab,(%esp)
  101418:	e8 43 ff ff ff       	call   101360 <cons_intr>
    }
}
  10141d:	c9                   	leave  
  10141e:	c3                   	ret    

0010141f <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10141f:	55                   	push   %ebp
  101420:	89 e5                	mov    %esp,%ebp
  101422:	83 ec 38             	sub    $0x38,%esp
  101425:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10142b:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10142f:	89 c2                	mov    %eax,%edx
  101431:	ec                   	in     (%dx),%al
  101432:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101435:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101439:	0f b6 c0             	movzbl %al,%eax
  10143c:	83 e0 01             	and    $0x1,%eax
  10143f:	85 c0                	test   %eax,%eax
  101441:	75 0a                	jne    10144d <kbd_proc_data+0x2e>
        return -1;
  101443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101448:	e9 59 01 00 00       	jmp    1015a6 <kbd_proc_data+0x187>
  10144d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101453:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101457:	89 c2                	mov    %eax,%edx
  101459:	ec                   	in     (%dx),%al
  10145a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10145d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101461:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101464:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101468:	75 17                	jne    101481 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10146a:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10146f:	83 c8 40             	or     $0x40,%eax
  101472:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101477:	b8 00 00 00 00       	mov    $0x0,%eax
  10147c:	e9 25 01 00 00       	jmp    1015a6 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101485:	84 c0                	test   %al,%al
  101487:	79 47                	jns    1014d0 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101489:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10148e:	83 e0 40             	and    $0x40,%eax
  101491:	85 c0                	test   %eax,%eax
  101493:	75 09                	jne    10149e <kbd_proc_data+0x7f>
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	83 e0 7f             	and    $0x7f,%eax
  10149c:	eb 04                	jmp    1014a2 <kbd_proc_data+0x83>
  10149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a2:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a9:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014b0:	83 c8 40             	or     $0x40,%eax
  1014b3:	0f b6 c0             	movzbl %al,%eax
  1014b6:	f7 d0                	not    %eax
  1014b8:	89 c2                	mov    %eax,%edx
  1014ba:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014bf:	21 d0                	and    %edx,%eax
  1014c1:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014c6:	b8 00 00 00 00       	mov    $0x0,%eax
  1014cb:	e9 d6 00 00 00       	jmp    1015a6 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014d0:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d5:	83 e0 40             	and    $0x40,%eax
  1014d8:	85 c0                	test   %eax,%eax
  1014da:	74 11                	je     1014ed <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014dc:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014e0:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e5:	83 e0 bf             	and    $0xffffffbf,%eax
  1014e8:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f1:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014f8:	0f b6 d0             	movzbl %al,%edx
  1014fb:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101500:	09 d0                	or     %edx,%eax
  101502:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150b:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101512:	0f b6 d0             	movzbl %al,%edx
  101515:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10151a:	31 d0                	xor    %edx,%eax
  10151c:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101521:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101526:	83 e0 03             	and    $0x3,%eax
  101529:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101530:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101534:	01 d0                	add    %edx,%eax
  101536:	0f b6 00             	movzbl (%eax),%eax
  101539:	0f b6 c0             	movzbl %al,%eax
  10153c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10153f:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101544:	83 e0 08             	and    $0x8,%eax
  101547:	85 c0                	test   %eax,%eax
  101549:	74 22                	je     10156d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10154b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10154f:	7e 0c                	jle    10155d <kbd_proc_data+0x13e>
  101551:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101555:	7f 06                	jg     10155d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101557:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10155b:	eb 10                	jmp    10156d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10155d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101561:	7e 0a                	jle    10156d <kbd_proc_data+0x14e>
  101563:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101567:	7f 04                	jg     10156d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101569:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10156d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101572:	f7 d0                	not    %eax
  101574:	83 e0 06             	and    $0x6,%eax
  101577:	85 c0                	test   %eax,%eax
  101579:	75 28                	jne    1015a3 <kbd_proc_data+0x184>
  10157b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101582:	75 1f                	jne    1015a3 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101584:	c7 04 24 ad 62 10 00 	movl   $0x1062ad,(%esp)
  10158b:	e8 ac ed ff ff       	call   10033c <cprintf>
  101590:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101596:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10159a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10159e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015a2:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a6:	c9                   	leave  
  1015a7:	c3                   	ret    

001015a8 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015a8:	55                   	push   %ebp
  1015a9:	89 e5                	mov    %esp,%ebp
  1015ab:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015ae:	c7 04 24 1f 14 10 00 	movl   $0x10141f,(%esp)
  1015b5:	e8 a6 fd ff ff       	call   101360 <cons_intr>
}
  1015ba:	c9                   	leave  
  1015bb:	c3                   	ret    

001015bc <kbd_init>:

static void
kbd_init(void) {
  1015bc:	55                   	push   %ebp
  1015bd:	89 e5                	mov    %esp,%ebp
  1015bf:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015c2:	e8 e1 ff ff ff       	call   1015a8 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015ce:	e8 3d 01 00 00       	call   101710 <pic_enable>
}
  1015d3:	c9                   	leave  
  1015d4:	c3                   	ret    

001015d5 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d5:	55                   	push   %ebp
  1015d6:	89 e5                	mov    %esp,%ebp
  1015d8:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015db:	e8 93 f8 ff ff       	call   100e73 <cga_init>
    serial_init();
  1015e0:	e8 74 f9 ff ff       	call   100f59 <serial_init>
    kbd_init();
  1015e5:	e8 d2 ff ff ff       	call   1015bc <kbd_init>
    if (!serial_exists) {
  1015ea:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015ef:	85 c0                	test   %eax,%eax
  1015f1:	75 0c                	jne    1015ff <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015f3:	c7 04 24 b9 62 10 00 	movl   $0x1062b9,(%esp)
  1015fa:	e8 3d ed ff ff       	call   10033c <cprintf>
    }
}
  1015ff:	c9                   	leave  
  101600:	c3                   	ret    

00101601 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101601:	55                   	push   %ebp
  101602:	89 e5                	mov    %esp,%ebp
  101604:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101607:	e8 e2 f7 ff ff       	call   100dee <__intr_save>
  10160c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10160f:	8b 45 08             	mov    0x8(%ebp),%eax
  101612:	89 04 24             	mov    %eax,(%esp)
  101615:	e8 9b fa ff ff       	call   1010b5 <lpt_putc>
        cga_putc(c);
  10161a:	8b 45 08             	mov    0x8(%ebp),%eax
  10161d:	89 04 24             	mov    %eax,(%esp)
  101620:	e8 cf fa ff ff       	call   1010f4 <cga_putc>
        serial_putc(c);
  101625:	8b 45 08             	mov    0x8(%ebp),%eax
  101628:	89 04 24             	mov    %eax,(%esp)
  10162b:	e8 f1 fc ff ff       	call   101321 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101633:	89 04 24             	mov    %eax,(%esp)
  101636:	e8 dd f7 ff ff       	call   100e18 <__intr_restore>
}
  10163b:	c9                   	leave  
  10163c:	c3                   	ret    

0010163d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163d:	55                   	push   %ebp
  10163e:	89 e5                	mov    %esp,%ebp
  101640:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101643:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10164a:	e8 9f f7 ff ff       	call   100dee <__intr_save>
  10164f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101652:	e8 ab fd ff ff       	call   101402 <serial_intr>
        kbd_intr();
  101657:	e8 4c ff ff ff       	call   1015a8 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10165c:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101662:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101667:	39 c2                	cmp    %eax,%edx
  101669:	74 31                	je     10169c <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10166b:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101670:	8d 50 01             	lea    0x1(%eax),%edx
  101673:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101679:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101680:	0f b6 c0             	movzbl %al,%eax
  101683:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101686:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10168b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101690:	75 0a                	jne    10169c <cons_getc+0x5f>
                cons.rpos = 0;
  101692:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101699:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10169f:	89 04 24             	mov    %eax,(%esp)
  1016a2:	e8 71 f7 ff ff       	call   100e18 <__intr_restore>
    return c;
  1016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016aa:	c9                   	leave  
  1016ab:	c3                   	ret    

001016ac <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016ac:	55                   	push   %ebp
  1016ad:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016af:	fb                   	sti    
    sti();
}
  1016b0:	5d                   	pop    %ebp
  1016b1:	c3                   	ret    

001016b2 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016b2:	55                   	push   %ebp
  1016b3:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016b5:	fa                   	cli    
    cli();
}
  1016b6:	5d                   	pop    %ebp
  1016b7:	c3                   	ret    

001016b8 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016b8:	55                   	push   %ebp
  1016b9:	89 e5                	mov    %esp,%ebp
  1016bb:	83 ec 14             	sub    $0x14,%esp
  1016be:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c9:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016cf:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016d4:	85 c0                	test   %eax,%eax
  1016d6:	74 36                	je     10170e <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016d8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016dc:	0f b6 c0             	movzbl %al,%eax
  1016df:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e5:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016e8:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ec:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016f0:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016f1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f5:	66 c1 e8 08          	shr    $0x8,%ax
  1016f9:	0f b6 c0             	movzbl %al,%eax
  1016fc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101702:	88 45 f9             	mov    %al,-0x7(%ebp)
  101705:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101709:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170d:	ee                   	out    %al,(%dx)
    }
}
  10170e:	c9                   	leave  
  10170f:	c3                   	ret    

00101710 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101710:	55                   	push   %ebp
  101711:	89 e5                	mov    %esp,%ebp
  101713:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101716:	8b 45 08             	mov    0x8(%ebp),%eax
  101719:	ba 01 00 00 00       	mov    $0x1,%edx
  10171e:	89 c1                	mov    %eax,%ecx
  101720:	d3 e2                	shl    %cl,%edx
  101722:	89 d0                	mov    %edx,%eax
  101724:	f7 d0                	not    %eax
  101726:	89 c2                	mov    %eax,%edx
  101728:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10172f:	21 d0                	and    %edx,%eax
  101731:	0f b7 c0             	movzwl %ax,%eax
  101734:	89 04 24             	mov    %eax,(%esp)
  101737:	e8 7c ff ff ff       	call   1016b8 <pic_setmask>
}
  10173c:	c9                   	leave  
  10173d:	c3                   	ret    

0010173e <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10173e:	55                   	push   %ebp
  10173f:	89 e5                	mov    %esp,%ebp
  101741:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101744:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  10174b:	00 00 00 
  10174e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101754:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101758:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10175c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101760:	ee                   	out    %al,(%dx)
  101761:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101767:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  10176b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101773:	ee                   	out    %al,(%dx)
  101774:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10177a:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10177e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101782:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101786:	ee                   	out    %al,(%dx)
  101787:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10178d:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101791:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101795:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101799:	ee                   	out    %al,(%dx)
  10179a:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017a0:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ac:	ee                   	out    %al,(%dx)
  1017ad:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017b3:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017bb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017bf:	ee                   	out    %al,(%dx)
  1017c0:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c6:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017ca:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017ce:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017d2:	ee                   	out    %al,(%dx)
  1017d3:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d9:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017dd:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017e1:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e5:	ee                   	out    %al,(%dx)
  1017e6:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017ec:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017f0:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f4:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017f8:	ee                   	out    %al,(%dx)
  1017f9:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017ff:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101803:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101807:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10180b:	ee                   	out    %al,(%dx)
  10180c:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101812:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101816:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10181a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10181e:	ee                   	out    %al,(%dx)
  10181f:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101825:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101829:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10182d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101831:	ee                   	out    %al,(%dx)
  101832:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101838:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10183c:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101840:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101844:	ee                   	out    %al,(%dx)
  101845:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10184b:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10184f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101853:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101857:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101858:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10185f:	66 83 f8 ff          	cmp    $0xffff,%ax
  101863:	74 12                	je     101877 <pic_init+0x139>
        pic_setmask(irq_mask);
  101865:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10186c:	0f b7 c0             	movzwl %ax,%eax
  10186f:	89 04 24             	mov    %eax,(%esp)
  101872:	e8 41 fe ff ff       	call   1016b8 <pic_setmask>
    }
}
  101877:	c9                   	leave  
  101878:	c3                   	ret    

00101879 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101879:	55                   	push   %ebp
  10187a:	89 e5                	mov    %esp,%ebp
  10187c:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10187f:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101886:	00 
  101887:	c7 04 24 e0 62 10 00 	movl   $0x1062e0,(%esp)
  10188e:	e8 a9 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101893:	c7 04 24 ea 62 10 00 	movl   $0x1062ea,(%esp)
  10189a:	e8 9d ea ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  10189f:	c7 44 24 08 f8 62 10 	movl   $0x1062f8,0x8(%esp)
  1018a6:	00 
  1018a7:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018ae:	00 
  1018af:	c7 04 24 0e 63 10 00 	movl   $0x10630e,(%esp)
  1018b6:	e8 14 f4 ff ff       	call   100ccf <__panic>

001018bb <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018bb:	55                   	push   %ebp
  1018bc:	89 e5                	mov    %esp,%ebp
  1018be:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for(i = 0 ; i < 256 ; i ++)
  1018c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018c8:	e9 c3 00 00 00       	jmp    101990 <idt_init+0xd5>
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d0:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018d7:	89 c2                	mov    %eax,%edx
  1018d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018dc:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018e3:	00 
  1018e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e7:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018ee:	00 08 00 
  1018f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f4:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018fb:	00 
  1018fc:	83 e2 e0             	and    $0xffffffe0,%edx
  1018ff:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101906:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101909:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101910:	00 
  101911:	83 e2 1f             	and    $0x1f,%edx
  101914:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  10191b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191e:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101925:	00 
  101926:	83 e2 f0             	and    $0xfffffff0,%edx
  101929:	83 ca 0e             	or     $0xe,%edx
  10192c:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101933:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101936:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10193d:	00 
  10193e:	83 e2 ef             	and    $0xffffffef,%edx
  101941:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101948:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194b:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101952:	00 
  101953:	83 e2 9f             	and    $0xffffff9f,%edx
  101956:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10195d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101960:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101967:	00 
  101968:	83 ca 80             	or     $0xffffff80,%edx
  10196b:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101972:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101975:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10197c:	c1 e8 10             	shr    $0x10,%eax
  10197f:	89 c2                	mov    %eax,%edx
  101981:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101984:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  10198b:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for(i = 0 ; i < 256 ; i ++)
  10198c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101990:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101997:	0f 8e 30 ff ff ff    	jle    1018cd <idt_init+0x12>
  10199d:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019a7:	0f 01 18             	lidtl  (%eax)
    {
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
  1019aa:	c9                   	leave  
  1019ab:	c3                   	ret    

001019ac <trapname>:

static const char *
trapname(int trapno) {
  1019ac:	55                   	push   %ebp
  1019ad:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019af:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b2:	83 f8 13             	cmp    $0x13,%eax
  1019b5:	77 0c                	ja     1019c3 <trapname+0x17>
        return excnames[trapno];
  1019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ba:	8b 04 85 60 66 10 00 	mov    0x106660(,%eax,4),%eax
  1019c1:	eb 18                	jmp    1019db <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019c3:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019c7:	7e 0d                	jle    1019d6 <trapname+0x2a>
  1019c9:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019cd:	7f 07                	jg     1019d6 <trapname+0x2a>
        return "Hardware Interrupt";
  1019cf:	b8 1f 63 10 00       	mov    $0x10631f,%eax
  1019d4:	eb 05                	jmp    1019db <trapname+0x2f>
    }
    return "(unknown trap)";
  1019d6:	b8 32 63 10 00       	mov    $0x106332,%eax
}
  1019db:	5d                   	pop    %ebp
  1019dc:	c3                   	ret    

001019dd <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019dd:	55                   	push   %ebp
  1019de:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019e7:	66 83 f8 08          	cmp    $0x8,%ax
  1019eb:	0f 94 c0             	sete   %al
  1019ee:	0f b6 c0             	movzbl %al,%eax
}
  1019f1:	5d                   	pop    %ebp
  1019f2:	c3                   	ret    

001019f3 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019f3:	55                   	push   %ebp
  1019f4:	89 e5                	mov    %esp,%ebp
  1019f6:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a00:	c7 04 24 73 63 10 00 	movl   $0x106373,(%esp)
  101a07:	e8 30 e9 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0f:	89 04 24             	mov    %eax,(%esp)
  101a12:	e8 a1 01 00 00       	call   101bb8 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a17:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a1e:	0f b7 c0             	movzwl %ax,%eax
  101a21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a25:	c7 04 24 84 63 10 00 	movl   $0x106384,(%esp)
  101a2c:	e8 0b e9 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a31:	8b 45 08             	mov    0x8(%ebp),%eax
  101a34:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a38:	0f b7 c0             	movzwl %ax,%eax
  101a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3f:	c7 04 24 97 63 10 00 	movl   $0x106397,(%esp)
  101a46:	e8 f1 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4e:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a52:	0f b7 c0             	movzwl %ax,%eax
  101a55:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a59:	c7 04 24 aa 63 10 00 	movl   $0x1063aa,(%esp)
  101a60:	e8 d7 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a65:	8b 45 08             	mov    0x8(%ebp),%eax
  101a68:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a6c:	0f b7 c0             	movzwl %ax,%eax
  101a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a73:	c7 04 24 bd 63 10 00 	movl   $0x1063bd,(%esp)
  101a7a:	e8 bd e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a82:	8b 40 30             	mov    0x30(%eax),%eax
  101a85:	89 04 24             	mov    %eax,(%esp)
  101a88:	e8 1f ff ff ff       	call   1019ac <trapname>
  101a8d:	8b 55 08             	mov    0x8(%ebp),%edx
  101a90:	8b 52 30             	mov    0x30(%edx),%edx
  101a93:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a97:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a9b:	c7 04 24 d0 63 10 00 	movl   $0x1063d0,(%esp)
  101aa2:	e8 95 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aaa:	8b 40 34             	mov    0x34(%eax),%eax
  101aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab1:	c7 04 24 e2 63 10 00 	movl   $0x1063e2,(%esp)
  101ab8:	e8 7f e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101abd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac0:	8b 40 38             	mov    0x38(%eax),%eax
  101ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac7:	c7 04 24 f1 63 10 00 	movl   $0x1063f1,(%esp)
  101ace:	e8 69 e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ada:	0f b7 c0             	movzwl %ax,%eax
  101add:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae1:	c7 04 24 00 64 10 00 	movl   $0x106400,(%esp)
  101ae8:	e8 4f e8 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101aed:	8b 45 08             	mov    0x8(%ebp),%eax
  101af0:	8b 40 40             	mov    0x40(%eax),%eax
  101af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af7:	c7 04 24 13 64 10 00 	movl   $0x106413,(%esp)
  101afe:	e8 39 e8 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b0a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b11:	eb 3e                	jmp    101b51 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b13:	8b 45 08             	mov    0x8(%ebp),%eax
  101b16:	8b 50 40             	mov    0x40(%eax),%edx
  101b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b1c:	21 d0                	and    %edx,%eax
  101b1e:	85 c0                	test   %eax,%eax
  101b20:	74 28                	je     101b4a <print_trapframe+0x157>
  101b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b25:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b2c:	85 c0                	test   %eax,%eax
  101b2e:	74 1a                	je     101b4a <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b33:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3e:	c7 04 24 22 64 10 00 	movl   $0x106422,(%esp)
  101b45:	e8 f2 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b4e:	d1 65 f0             	shll   -0x10(%ebp)
  101b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b54:	83 f8 17             	cmp    $0x17,%eax
  101b57:	76 ba                	jbe    101b13 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b59:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5c:	8b 40 40             	mov    0x40(%eax),%eax
  101b5f:	25 00 30 00 00       	and    $0x3000,%eax
  101b64:	c1 e8 0c             	shr    $0xc,%eax
  101b67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6b:	c7 04 24 26 64 10 00 	movl   $0x106426,(%esp)
  101b72:	e8 c5 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101b77:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7a:	89 04 24             	mov    %eax,(%esp)
  101b7d:	e8 5b fe ff ff       	call   1019dd <trap_in_kernel>
  101b82:	85 c0                	test   %eax,%eax
  101b84:	75 30                	jne    101bb6 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b86:	8b 45 08             	mov    0x8(%ebp),%eax
  101b89:	8b 40 44             	mov    0x44(%eax),%eax
  101b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b90:	c7 04 24 2f 64 10 00 	movl   $0x10642f,(%esp)
  101b97:	e8 a0 e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9f:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ba3:	0f b7 c0             	movzwl %ax,%eax
  101ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101baa:	c7 04 24 3e 64 10 00 	movl   $0x10643e,(%esp)
  101bb1:	e8 86 e7 ff ff       	call   10033c <cprintf>
    }
}
  101bb6:	c9                   	leave  
  101bb7:	c3                   	ret    

00101bb8 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bb8:	55                   	push   %ebp
  101bb9:	89 e5                	mov    %esp,%ebp
  101bbb:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc1:	8b 00                	mov    (%eax),%eax
  101bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc7:	c7 04 24 51 64 10 00 	movl   $0x106451,(%esp)
  101bce:	e8 69 e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd6:	8b 40 04             	mov    0x4(%eax),%eax
  101bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdd:	c7 04 24 60 64 10 00 	movl   $0x106460,(%esp)
  101be4:	e8 53 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101be9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bec:	8b 40 08             	mov    0x8(%eax),%eax
  101bef:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf3:	c7 04 24 6f 64 10 00 	movl   $0x10646f,(%esp)
  101bfa:	e8 3d e7 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bff:	8b 45 08             	mov    0x8(%ebp),%eax
  101c02:	8b 40 0c             	mov    0xc(%eax),%eax
  101c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c09:	c7 04 24 7e 64 10 00 	movl   $0x10647e,(%esp)
  101c10:	e8 27 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c15:	8b 45 08             	mov    0x8(%ebp),%eax
  101c18:	8b 40 10             	mov    0x10(%eax),%eax
  101c1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1f:	c7 04 24 8d 64 10 00 	movl   $0x10648d,(%esp)
  101c26:	e8 11 e7 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2e:	8b 40 14             	mov    0x14(%eax),%eax
  101c31:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c35:	c7 04 24 9c 64 10 00 	movl   $0x10649c,(%esp)
  101c3c:	e8 fb e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c41:	8b 45 08             	mov    0x8(%ebp),%eax
  101c44:	8b 40 18             	mov    0x18(%eax),%eax
  101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4b:	c7 04 24 ab 64 10 00 	movl   $0x1064ab,(%esp)
  101c52:	e8 e5 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c57:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5a:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c61:	c7 04 24 ba 64 10 00 	movl   $0x1064ba,(%esp)
  101c68:	e8 cf e6 ff ff       	call   10033c <cprintf>
}
  101c6d:	c9                   	leave  
  101c6e:	c3                   	ret    

00101c6f <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c6f:	55                   	push   %ebp
  101c70:	89 e5                	mov    %esp,%ebp
  101c72:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c75:	8b 45 08             	mov    0x8(%ebp),%eax
  101c78:	8b 40 30             	mov    0x30(%eax),%eax
  101c7b:	83 f8 2f             	cmp    $0x2f,%eax
  101c7e:	77 1d                	ja     101c9d <trap_dispatch+0x2e>
  101c80:	83 f8 2e             	cmp    $0x2e,%eax
  101c83:	0f 83 f2 00 00 00    	jae    101d7b <trap_dispatch+0x10c>
  101c89:	83 f8 21             	cmp    $0x21,%eax
  101c8c:	74 73                	je     101d01 <trap_dispatch+0x92>
  101c8e:	83 f8 24             	cmp    $0x24,%eax
  101c91:	74 48                	je     101cdb <trap_dispatch+0x6c>
  101c93:	83 f8 20             	cmp    $0x20,%eax
  101c96:	74 13                	je     101cab <trap_dispatch+0x3c>
  101c98:	e9 a6 00 00 00       	jmp    101d43 <trap_dispatch+0xd4>
  101c9d:	83 e8 78             	sub    $0x78,%eax
  101ca0:	83 f8 01             	cmp    $0x1,%eax
  101ca3:	0f 87 9a 00 00 00    	ja     101d43 <trap_dispatch+0xd4>
  101ca9:	eb 7c                	jmp    101d27 <trap_dispatch+0xb8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101cab:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101cb0:	83 c0 01             	add    $0x1,%eax
  101cb3:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if(TICK_NUM == ticks)
  101cb8:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101cbd:	83 f8 64             	cmp    $0x64,%eax
  101cc0:	75 14                	jne    101cd6 <trap_dispatch+0x67>
        {
            print_ticks();
  101cc2:	e8 b2 fb ff ff       	call   101879 <print_ticks>
            ticks = 0;
  101cc7:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  101cce:	00 00 00 
        }
        break;
  101cd1:	e9 a6 00 00 00       	jmp    101d7c <trap_dispatch+0x10d>
  101cd6:	e9 a1 00 00 00       	jmp    101d7c <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cdb:	e8 5d f9 ff ff       	call   10163d <cons_getc>
  101ce0:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ce3:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ce7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ceb:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf3:	c7 04 24 c9 64 10 00 	movl   $0x1064c9,(%esp)
  101cfa:	e8 3d e6 ff ff       	call   10033c <cprintf>
        break;
  101cff:	eb 7b                	jmp    101d7c <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d01:	e8 37 f9 ff ff       	call   10163d <cons_getc>
  101d06:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d09:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d0d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d11:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d19:	c7 04 24 db 64 10 00 	movl   $0x1064db,(%esp)
  101d20:	e8 17 e6 ff ff       	call   10033c <cprintf>
        break;
  101d25:	eb 55                	jmp    101d7c <trap_dispatch+0x10d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d27:	c7 44 24 08 ea 64 10 	movl   $0x1064ea,0x8(%esp)
  101d2e:	00 
  101d2f:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  101d36:	00 
  101d37:	c7 04 24 0e 63 10 00 	movl   $0x10630e,(%esp)
  101d3e:	e8 8c ef ff ff       	call   100ccf <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d43:	8b 45 08             	mov    0x8(%ebp),%eax
  101d46:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d4a:	0f b7 c0             	movzwl %ax,%eax
  101d4d:	83 e0 03             	and    $0x3,%eax
  101d50:	85 c0                	test   %eax,%eax
  101d52:	75 28                	jne    101d7c <trap_dispatch+0x10d>
            print_trapframe(tf);
  101d54:	8b 45 08             	mov    0x8(%ebp),%eax
  101d57:	89 04 24             	mov    %eax,(%esp)
  101d5a:	e8 94 fc ff ff       	call   1019f3 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d5f:	c7 44 24 08 fa 64 10 	movl   $0x1064fa,0x8(%esp)
  101d66:	00 
  101d67:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  101d6e:	00 
  101d6f:	c7 04 24 0e 63 10 00 	movl   $0x10630e,(%esp)
  101d76:	e8 54 ef ff ff       	call   100ccf <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d7b:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d7c:	c9                   	leave  
  101d7d:	c3                   	ret    

00101d7e <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d7e:	55                   	push   %ebp
  101d7f:	89 e5                	mov    %esp,%ebp
  101d81:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d84:	8b 45 08             	mov    0x8(%ebp),%eax
  101d87:	89 04 24             	mov    %eax,(%esp)
  101d8a:	e8 e0 fe ff ff       	call   101c6f <trap_dispatch>
}
  101d8f:	c9                   	leave  
  101d90:	c3                   	ret    

00101d91 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d91:	1e                   	push   %ds
    pushl %es
  101d92:	06                   	push   %es
    pushl %fs
  101d93:	0f a0                	push   %fs
    pushl %gs
  101d95:	0f a8                	push   %gs
    pushal
  101d97:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101d98:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101d9d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101d9f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101da1:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101da2:	e8 d7 ff ff ff       	call   101d7e <trap>

    # pop the pushed stack pointer
    popl %esp
  101da7:	5c                   	pop    %esp

00101da8 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101da8:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101da9:	0f a9                	pop    %gs
    popl %fs
  101dab:	0f a1                	pop    %fs
    popl %es
  101dad:	07                   	pop    %es
    popl %ds
  101dae:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101daf:	83 c4 08             	add    $0x8,%esp
    iret
  101db2:	cf                   	iret   

00101db3 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101db3:	6a 00                	push   $0x0
  pushl $0
  101db5:	6a 00                	push   $0x0
  jmp __alltraps
  101db7:	e9 d5 ff ff ff       	jmp    101d91 <__alltraps>

00101dbc <vector1>:
.globl vector1
vector1:
  pushl $0
  101dbc:	6a 00                	push   $0x0
  pushl $1
  101dbe:	6a 01                	push   $0x1
  jmp __alltraps
  101dc0:	e9 cc ff ff ff       	jmp    101d91 <__alltraps>

00101dc5 <vector2>:
.globl vector2
vector2:
  pushl $0
  101dc5:	6a 00                	push   $0x0
  pushl $2
  101dc7:	6a 02                	push   $0x2
  jmp __alltraps
  101dc9:	e9 c3 ff ff ff       	jmp    101d91 <__alltraps>

00101dce <vector3>:
.globl vector3
vector3:
  pushl $0
  101dce:	6a 00                	push   $0x0
  pushl $3
  101dd0:	6a 03                	push   $0x3
  jmp __alltraps
  101dd2:	e9 ba ff ff ff       	jmp    101d91 <__alltraps>

00101dd7 <vector4>:
.globl vector4
vector4:
  pushl $0
  101dd7:	6a 00                	push   $0x0
  pushl $4
  101dd9:	6a 04                	push   $0x4
  jmp __alltraps
  101ddb:	e9 b1 ff ff ff       	jmp    101d91 <__alltraps>

00101de0 <vector5>:
.globl vector5
vector5:
  pushl $0
  101de0:	6a 00                	push   $0x0
  pushl $5
  101de2:	6a 05                	push   $0x5
  jmp __alltraps
  101de4:	e9 a8 ff ff ff       	jmp    101d91 <__alltraps>

00101de9 <vector6>:
.globl vector6
vector6:
  pushl $0
  101de9:	6a 00                	push   $0x0
  pushl $6
  101deb:	6a 06                	push   $0x6
  jmp __alltraps
  101ded:	e9 9f ff ff ff       	jmp    101d91 <__alltraps>

00101df2 <vector7>:
.globl vector7
vector7:
  pushl $0
  101df2:	6a 00                	push   $0x0
  pushl $7
  101df4:	6a 07                	push   $0x7
  jmp __alltraps
  101df6:	e9 96 ff ff ff       	jmp    101d91 <__alltraps>

00101dfb <vector8>:
.globl vector8
vector8:
  pushl $8
  101dfb:	6a 08                	push   $0x8
  jmp __alltraps
  101dfd:	e9 8f ff ff ff       	jmp    101d91 <__alltraps>

00101e02 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e02:	6a 09                	push   $0x9
  jmp __alltraps
  101e04:	e9 88 ff ff ff       	jmp    101d91 <__alltraps>

00101e09 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e09:	6a 0a                	push   $0xa
  jmp __alltraps
  101e0b:	e9 81 ff ff ff       	jmp    101d91 <__alltraps>

00101e10 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e10:	6a 0b                	push   $0xb
  jmp __alltraps
  101e12:	e9 7a ff ff ff       	jmp    101d91 <__alltraps>

00101e17 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e17:	6a 0c                	push   $0xc
  jmp __alltraps
  101e19:	e9 73 ff ff ff       	jmp    101d91 <__alltraps>

00101e1e <vector13>:
.globl vector13
vector13:
  pushl $13
  101e1e:	6a 0d                	push   $0xd
  jmp __alltraps
  101e20:	e9 6c ff ff ff       	jmp    101d91 <__alltraps>

00101e25 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e25:	6a 0e                	push   $0xe
  jmp __alltraps
  101e27:	e9 65 ff ff ff       	jmp    101d91 <__alltraps>

00101e2c <vector15>:
.globl vector15
vector15:
  pushl $0
  101e2c:	6a 00                	push   $0x0
  pushl $15
  101e2e:	6a 0f                	push   $0xf
  jmp __alltraps
  101e30:	e9 5c ff ff ff       	jmp    101d91 <__alltraps>

00101e35 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e35:	6a 00                	push   $0x0
  pushl $16
  101e37:	6a 10                	push   $0x10
  jmp __alltraps
  101e39:	e9 53 ff ff ff       	jmp    101d91 <__alltraps>

00101e3e <vector17>:
.globl vector17
vector17:
  pushl $17
  101e3e:	6a 11                	push   $0x11
  jmp __alltraps
  101e40:	e9 4c ff ff ff       	jmp    101d91 <__alltraps>

00101e45 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e45:	6a 00                	push   $0x0
  pushl $18
  101e47:	6a 12                	push   $0x12
  jmp __alltraps
  101e49:	e9 43 ff ff ff       	jmp    101d91 <__alltraps>

00101e4e <vector19>:
.globl vector19
vector19:
  pushl $0
  101e4e:	6a 00                	push   $0x0
  pushl $19
  101e50:	6a 13                	push   $0x13
  jmp __alltraps
  101e52:	e9 3a ff ff ff       	jmp    101d91 <__alltraps>

00101e57 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e57:	6a 00                	push   $0x0
  pushl $20
  101e59:	6a 14                	push   $0x14
  jmp __alltraps
  101e5b:	e9 31 ff ff ff       	jmp    101d91 <__alltraps>

00101e60 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e60:	6a 00                	push   $0x0
  pushl $21
  101e62:	6a 15                	push   $0x15
  jmp __alltraps
  101e64:	e9 28 ff ff ff       	jmp    101d91 <__alltraps>

00101e69 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e69:	6a 00                	push   $0x0
  pushl $22
  101e6b:	6a 16                	push   $0x16
  jmp __alltraps
  101e6d:	e9 1f ff ff ff       	jmp    101d91 <__alltraps>

00101e72 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e72:	6a 00                	push   $0x0
  pushl $23
  101e74:	6a 17                	push   $0x17
  jmp __alltraps
  101e76:	e9 16 ff ff ff       	jmp    101d91 <__alltraps>

00101e7b <vector24>:
.globl vector24
vector24:
  pushl $0
  101e7b:	6a 00                	push   $0x0
  pushl $24
  101e7d:	6a 18                	push   $0x18
  jmp __alltraps
  101e7f:	e9 0d ff ff ff       	jmp    101d91 <__alltraps>

00101e84 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e84:	6a 00                	push   $0x0
  pushl $25
  101e86:	6a 19                	push   $0x19
  jmp __alltraps
  101e88:	e9 04 ff ff ff       	jmp    101d91 <__alltraps>

00101e8d <vector26>:
.globl vector26
vector26:
  pushl $0
  101e8d:	6a 00                	push   $0x0
  pushl $26
  101e8f:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e91:	e9 fb fe ff ff       	jmp    101d91 <__alltraps>

00101e96 <vector27>:
.globl vector27
vector27:
  pushl $0
  101e96:	6a 00                	push   $0x0
  pushl $27
  101e98:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e9a:	e9 f2 fe ff ff       	jmp    101d91 <__alltraps>

00101e9f <vector28>:
.globl vector28
vector28:
  pushl $0
  101e9f:	6a 00                	push   $0x0
  pushl $28
  101ea1:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ea3:	e9 e9 fe ff ff       	jmp    101d91 <__alltraps>

00101ea8 <vector29>:
.globl vector29
vector29:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $29
  101eaa:	6a 1d                	push   $0x1d
  jmp __alltraps
  101eac:	e9 e0 fe ff ff       	jmp    101d91 <__alltraps>

00101eb1 <vector30>:
.globl vector30
vector30:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $30
  101eb3:	6a 1e                	push   $0x1e
  jmp __alltraps
  101eb5:	e9 d7 fe ff ff       	jmp    101d91 <__alltraps>

00101eba <vector31>:
.globl vector31
vector31:
  pushl $0
  101eba:	6a 00                	push   $0x0
  pushl $31
  101ebc:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ebe:	e9 ce fe ff ff       	jmp    101d91 <__alltraps>

00101ec3 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ec3:	6a 00                	push   $0x0
  pushl $32
  101ec5:	6a 20                	push   $0x20
  jmp __alltraps
  101ec7:	e9 c5 fe ff ff       	jmp    101d91 <__alltraps>

00101ecc <vector33>:
.globl vector33
vector33:
  pushl $0
  101ecc:	6a 00                	push   $0x0
  pushl $33
  101ece:	6a 21                	push   $0x21
  jmp __alltraps
  101ed0:	e9 bc fe ff ff       	jmp    101d91 <__alltraps>

00101ed5 <vector34>:
.globl vector34
vector34:
  pushl $0
  101ed5:	6a 00                	push   $0x0
  pushl $34
  101ed7:	6a 22                	push   $0x22
  jmp __alltraps
  101ed9:	e9 b3 fe ff ff       	jmp    101d91 <__alltraps>

00101ede <vector35>:
.globl vector35
vector35:
  pushl $0
  101ede:	6a 00                	push   $0x0
  pushl $35
  101ee0:	6a 23                	push   $0x23
  jmp __alltraps
  101ee2:	e9 aa fe ff ff       	jmp    101d91 <__alltraps>

00101ee7 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $36
  101ee9:	6a 24                	push   $0x24
  jmp __alltraps
  101eeb:	e9 a1 fe ff ff       	jmp    101d91 <__alltraps>

00101ef0 <vector37>:
.globl vector37
vector37:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $37
  101ef2:	6a 25                	push   $0x25
  jmp __alltraps
  101ef4:	e9 98 fe ff ff       	jmp    101d91 <__alltraps>

00101ef9 <vector38>:
.globl vector38
vector38:
  pushl $0
  101ef9:	6a 00                	push   $0x0
  pushl $38
  101efb:	6a 26                	push   $0x26
  jmp __alltraps
  101efd:	e9 8f fe ff ff       	jmp    101d91 <__alltraps>

00101f02 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f02:	6a 00                	push   $0x0
  pushl $39
  101f04:	6a 27                	push   $0x27
  jmp __alltraps
  101f06:	e9 86 fe ff ff       	jmp    101d91 <__alltraps>

00101f0b <vector40>:
.globl vector40
vector40:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $40
  101f0d:	6a 28                	push   $0x28
  jmp __alltraps
  101f0f:	e9 7d fe ff ff       	jmp    101d91 <__alltraps>

00101f14 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $41
  101f16:	6a 29                	push   $0x29
  jmp __alltraps
  101f18:	e9 74 fe ff ff       	jmp    101d91 <__alltraps>

00101f1d <vector42>:
.globl vector42
vector42:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $42
  101f1f:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f21:	e9 6b fe ff ff       	jmp    101d91 <__alltraps>

00101f26 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f26:	6a 00                	push   $0x0
  pushl $43
  101f28:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f2a:	e9 62 fe ff ff       	jmp    101d91 <__alltraps>

00101f2f <vector44>:
.globl vector44
vector44:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $44
  101f31:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f33:	e9 59 fe ff ff       	jmp    101d91 <__alltraps>

00101f38 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $45
  101f3a:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f3c:	e9 50 fe ff ff       	jmp    101d91 <__alltraps>

00101f41 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $46
  101f43:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f45:	e9 47 fe ff ff       	jmp    101d91 <__alltraps>

00101f4a <vector47>:
.globl vector47
vector47:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $47
  101f4c:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f4e:	e9 3e fe ff ff       	jmp    101d91 <__alltraps>

00101f53 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $48
  101f55:	6a 30                	push   $0x30
  jmp __alltraps
  101f57:	e9 35 fe ff ff       	jmp    101d91 <__alltraps>

00101f5c <vector49>:
.globl vector49
vector49:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $49
  101f5e:	6a 31                	push   $0x31
  jmp __alltraps
  101f60:	e9 2c fe ff ff       	jmp    101d91 <__alltraps>

00101f65 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $50
  101f67:	6a 32                	push   $0x32
  jmp __alltraps
  101f69:	e9 23 fe ff ff       	jmp    101d91 <__alltraps>

00101f6e <vector51>:
.globl vector51
vector51:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $51
  101f70:	6a 33                	push   $0x33
  jmp __alltraps
  101f72:	e9 1a fe ff ff       	jmp    101d91 <__alltraps>

00101f77 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $52
  101f79:	6a 34                	push   $0x34
  jmp __alltraps
  101f7b:	e9 11 fe ff ff       	jmp    101d91 <__alltraps>

00101f80 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $53
  101f82:	6a 35                	push   $0x35
  jmp __alltraps
  101f84:	e9 08 fe ff ff       	jmp    101d91 <__alltraps>

00101f89 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $54
  101f8b:	6a 36                	push   $0x36
  jmp __alltraps
  101f8d:	e9 ff fd ff ff       	jmp    101d91 <__alltraps>

00101f92 <vector55>:
.globl vector55
vector55:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $55
  101f94:	6a 37                	push   $0x37
  jmp __alltraps
  101f96:	e9 f6 fd ff ff       	jmp    101d91 <__alltraps>

00101f9b <vector56>:
.globl vector56
vector56:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $56
  101f9d:	6a 38                	push   $0x38
  jmp __alltraps
  101f9f:	e9 ed fd ff ff       	jmp    101d91 <__alltraps>

00101fa4 <vector57>:
.globl vector57
vector57:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $57
  101fa6:	6a 39                	push   $0x39
  jmp __alltraps
  101fa8:	e9 e4 fd ff ff       	jmp    101d91 <__alltraps>

00101fad <vector58>:
.globl vector58
vector58:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $58
  101faf:	6a 3a                	push   $0x3a
  jmp __alltraps
  101fb1:	e9 db fd ff ff       	jmp    101d91 <__alltraps>

00101fb6 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $59
  101fb8:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fba:	e9 d2 fd ff ff       	jmp    101d91 <__alltraps>

00101fbf <vector60>:
.globl vector60
vector60:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $60
  101fc1:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fc3:	e9 c9 fd ff ff       	jmp    101d91 <__alltraps>

00101fc8 <vector61>:
.globl vector61
vector61:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $61
  101fca:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fcc:	e9 c0 fd ff ff       	jmp    101d91 <__alltraps>

00101fd1 <vector62>:
.globl vector62
vector62:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $62
  101fd3:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fd5:	e9 b7 fd ff ff       	jmp    101d91 <__alltraps>

00101fda <vector63>:
.globl vector63
vector63:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $63
  101fdc:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fde:	e9 ae fd ff ff       	jmp    101d91 <__alltraps>

00101fe3 <vector64>:
.globl vector64
vector64:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $64
  101fe5:	6a 40                	push   $0x40
  jmp __alltraps
  101fe7:	e9 a5 fd ff ff       	jmp    101d91 <__alltraps>

00101fec <vector65>:
.globl vector65
vector65:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $65
  101fee:	6a 41                	push   $0x41
  jmp __alltraps
  101ff0:	e9 9c fd ff ff       	jmp    101d91 <__alltraps>

00101ff5 <vector66>:
.globl vector66
vector66:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $66
  101ff7:	6a 42                	push   $0x42
  jmp __alltraps
  101ff9:	e9 93 fd ff ff       	jmp    101d91 <__alltraps>

00101ffe <vector67>:
.globl vector67
vector67:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $67
  102000:	6a 43                	push   $0x43
  jmp __alltraps
  102002:	e9 8a fd ff ff       	jmp    101d91 <__alltraps>

00102007 <vector68>:
.globl vector68
vector68:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $68
  102009:	6a 44                	push   $0x44
  jmp __alltraps
  10200b:	e9 81 fd ff ff       	jmp    101d91 <__alltraps>

00102010 <vector69>:
.globl vector69
vector69:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $69
  102012:	6a 45                	push   $0x45
  jmp __alltraps
  102014:	e9 78 fd ff ff       	jmp    101d91 <__alltraps>

00102019 <vector70>:
.globl vector70
vector70:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $70
  10201b:	6a 46                	push   $0x46
  jmp __alltraps
  10201d:	e9 6f fd ff ff       	jmp    101d91 <__alltraps>

00102022 <vector71>:
.globl vector71
vector71:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $71
  102024:	6a 47                	push   $0x47
  jmp __alltraps
  102026:	e9 66 fd ff ff       	jmp    101d91 <__alltraps>

0010202b <vector72>:
.globl vector72
vector72:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $72
  10202d:	6a 48                	push   $0x48
  jmp __alltraps
  10202f:	e9 5d fd ff ff       	jmp    101d91 <__alltraps>

00102034 <vector73>:
.globl vector73
vector73:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $73
  102036:	6a 49                	push   $0x49
  jmp __alltraps
  102038:	e9 54 fd ff ff       	jmp    101d91 <__alltraps>

0010203d <vector74>:
.globl vector74
vector74:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $74
  10203f:	6a 4a                	push   $0x4a
  jmp __alltraps
  102041:	e9 4b fd ff ff       	jmp    101d91 <__alltraps>

00102046 <vector75>:
.globl vector75
vector75:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $75
  102048:	6a 4b                	push   $0x4b
  jmp __alltraps
  10204a:	e9 42 fd ff ff       	jmp    101d91 <__alltraps>

0010204f <vector76>:
.globl vector76
vector76:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $76
  102051:	6a 4c                	push   $0x4c
  jmp __alltraps
  102053:	e9 39 fd ff ff       	jmp    101d91 <__alltraps>

00102058 <vector77>:
.globl vector77
vector77:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $77
  10205a:	6a 4d                	push   $0x4d
  jmp __alltraps
  10205c:	e9 30 fd ff ff       	jmp    101d91 <__alltraps>

00102061 <vector78>:
.globl vector78
vector78:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $78
  102063:	6a 4e                	push   $0x4e
  jmp __alltraps
  102065:	e9 27 fd ff ff       	jmp    101d91 <__alltraps>

0010206a <vector79>:
.globl vector79
vector79:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $79
  10206c:	6a 4f                	push   $0x4f
  jmp __alltraps
  10206e:	e9 1e fd ff ff       	jmp    101d91 <__alltraps>

00102073 <vector80>:
.globl vector80
vector80:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $80
  102075:	6a 50                	push   $0x50
  jmp __alltraps
  102077:	e9 15 fd ff ff       	jmp    101d91 <__alltraps>

0010207c <vector81>:
.globl vector81
vector81:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $81
  10207e:	6a 51                	push   $0x51
  jmp __alltraps
  102080:	e9 0c fd ff ff       	jmp    101d91 <__alltraps>

00102085 <vector82>:
.globl vector82
vector82:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $82
  102087:	6a 52                	push   $0x52
  jmp __alltraps
  102089:	e9 03 fd ff ff       	jmp    101d91 <__alltraps>

0010208e <vector83>:
.globl vector83
vector83:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $83
  102090:	6a 53                	push   $0x53
  jmp __alltraps
  102092:	e9 fa fc ff ff       	jmp    101d91 <__alltraps>

00102097 <vector84>:
.globl vector84
vector84:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $84
  102099:	6a 54                	push   $0x54
  jmp __alltraps
  10209b:	e9 f1 fc ff ff       	jmp    101d91 <__alltraps>

001020a0 <vector85>:
.globl vector85
vector85:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $85
  1020a2:	6a 55                	push   $0x55
  jmp __alltraps
  1020a4:	e9 e8 fc ff ff       	jmp    101d91 <__alltraps>

001020a9 <vector86>:
.globl vector86
vector86:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $86
  1020ab:	6a 56                	push   $0x56
  jmp __alltraps
  1020ad:	e9 df fc ff ff       	jmp    101d91 <__alltraps>

001020b2 <vector87>:
.globl vector87
vector87:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $87
  1020b4:	6a 57                	push   $0x57
  jmp __alltraps
  1020b6:	e9 d6 fc ff ff       	jmp    101d91 <__alltraps>

001020bb <vector88>:
.globl vector88
vector88:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $88
  1020bd:	6a 58                	push   $0x58
  jmp __alltraps
  1020bf:	e9 cd fc ff ff       	jmp    101d91 <__alltraps>

001020c4 <vector89>:
.globl vector89
vector89:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $89
  1020c6:	6a 59                	push   $0x59
  jmp __alltraps
  1020c8:	e9 c4 fc ff ff       	jmp    101d91 <__alltraps>

001020cd <vector90>:
.globl vector90
vector90:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $90
  1020cf:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020d1:	e9 bb fc ff ff       	jmp    101d91 <__alltraps>

001020d6 <vector91>:
.globl vector91
vector91:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $91
  1020d8:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020da:	e9 b2 fc ff ff       	jmp    101d91 <__alltraps>

001020df <vector92>:
.globl vector92
vector92:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $92
  1020e1:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020e3:	e9 a9 fc ff ff       	jmp    101d91 <__alltraps>

001020e8 <vector93>:
.globl vector93
vector93:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $93
  1020ea:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020ec:	e9 a0 fc ff ff       	jmp    101d91 <__alltraps>

001020f1 <vector94>:
.globl vector94
vector94:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $94
  1020f3:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020f5:	e9 97 fc ff ff       	jmp    101d91 <__alltraps>

001020fa <vector95>:
.globl vector95
vector95:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $95
  1020fc:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020fe:	e9 8e fc ff ff       	jmp    101d91 <__alltraps>

00102103 <vector96>:
.globl vector96
vector96:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $96
  102105:	6a 60                	push   $0x60
  jmp __alltraps
  102107:	e9 85 fc ff ff       	jmp    101d91 <__alltraps>

0010210c <vector97>:
.globl vector97
vector97:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $97
  10210e:	6a 61                	push   $0x61
  jmp __alltraps
  102110:	e9 7c fc ff ff       	jmp    101d91 <__alltraps>

00102115 <vector98>:
.globl vector98
vector98:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $98
  102117:	6a 62                	push   $0x62
  jmp __alltraps
  102119:	e9 73 fc ff ff       	jmp    101d91 <__alltraps>

0010211e <vector99>:
.globl vector99
vector99:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $99
  102120:	6a 63                	push   $0x63
  jmp __alltraps
  102122:	e9 6a fc ff ff       	jmp    101d91 <__alltraps>

00102127 <vector100>:
.globl vector100
vector100:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $100
  102129:	6a 64                	push   $0x64
  jmp __alltraps
  10212b:	e9 61 fc ff ff       	jmp    101d91 <__alltraps>

00102130 <vector101>:
.globl vector101
vector101:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $101
  102132:	6a 65                	push   $0x65
  jmp __alltraps
  102134:	e9 58 fc ff ff       	jmp    101d91 <__alltraps>

00102139 <vector102>:
.globl vector102
vector102:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $102
  10213b:	6a 66                	push   $0x66
  jmp __alltraps
  10213d:	e9 4f fc ff ff       	jmp    101d91 <__alltraps>

00102142 <vector103>:
.globl vector103
vector103:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $103
  102144:	6a 67                	push   $0x67
  jmp __alltraps
  102146:	e9 46 fc ff ff       	jmp    101d91 <__alltraps>

0010214b <vector104>:
.globl vector104
vector104:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $104
  10214d:	6a 68                	push   $0x68
  jmp __alltraps
  10214f:	e9 3d fc ff ff       	jmp    101d91 <__alltraps>

00102154 <vector105>:
.globl vector105
vector105:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $105
  102156:	6a 69                	push   $0x69
  jmp __alltraps
  102158:	e9 34 fc ff ff       	jmp    101d91 <__alltraps>

0010215d <vector106>:
.globl vector106
vector106:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $106
  10215f:	6a 6a                	push   $0x6a
  jmp __alltraps
  102161:	e9 2b fc ff ff       	jmp    101d91 <__alltraps>

00102166 <vector107>:
.globl vector107
vector107:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $107
  102168:	6a 6b                	push   $0x6b
  jmp __alltraps
  10216a:	e9 22 fc ff ff       	jmp    101d91 <__alltraps>

0010216f <vector108>:
.globl vector108
vector108:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $108
  102171:	6a 6c                	push   $0x6c
  jmp __alltraps
  102173:	e9 19 fc ff ff       	jmp    101d91 <__alltraps>

00102178 <vector109>:
.globl vector109
vector109:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $109
  10217a:	6a 6d                	push   $0x6d
  jmp __alltraps
  10217c:	e9 10 fc ff ff       	jmp    101d91 <__alltraps>

00102181 <vector110>:
.globl vector110
vector110:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $110
  102183:	6a 6e                	push   $0x6e
  jmp __alltraps
  102185:	e9 07 fc ff ff       	jmp    101d91 <__alltraps>

0010218a <vector111>:
.globl vector111
vector111:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $111
  10218c:	6a 6f                	push   $0x6f
  jmp __alltraps
  10218e:	e9 fe fb ff ff       	jmp    101d91 <__alltraps>

00102193 <vector112>:
.globl vector112
vector112:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $112
  102195:	6a 70                	push   $0x70
  jmp __alltraps
  102197:	e9 f5 fb ff ff       	jmp    101d91 <__alltraps>

0010219c <vector113>:
.globl vector113
vector113:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $113
  10219e:	6a 71                	push   $0x71
  jmp __alltraps
  1021a0:	e9 ec fb ff ff       	jmp    101d91 <__alltraps>

001021a5 <vector114>:
.globl vector114
vector114:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $114
  1021a7:	6a 72                	push   $0x72
  jmp __alltraps
  1021a9:	e9 e3 fb ff ff       	jmp    101d91 <__alltraps>

001021ae <vector115>:
.globl vector115
vector115:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $115
  1021b0:	6a 73                	push   $0x73
  jmp __alltraps
  1021b2:	e9 da fb ff ff       	jmp    101d91 <__alltraps>

001021b7 <vector116>:
.globl vector116
vector116:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $116
  1021b9:	6a 74                	push   $0x74
  jmp __alltraps
  1021bb:	e9 d1 fb ff ff       	jmp    101d91 <__alltraps>

001021c0 <vector117>:
.globl vector117
vector117:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $117
  1021c2:	6a 75                	push   $0x75
  jmp __alltraps
  1021c4:	e9 c8 fb ff ff       	jmp    101d91 <__alltraps>

001021c9 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $118
  1021cb:	6a 76                	push   $0x76
  jmp __alltraps
  1021cd:	e9 bf fb ff ff       	jmp    101d91 <__alltraps>

001021d2 <vector119>:
.globl vector119
vector119:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $119
  1021d4:	6a 77                	push   $0x77
  jmp __alltraps
  1021d6:	e9 b6 fb ff ff       	jmp    101d91 <__alltraps>

001021db <vector120>:
.globl vector120
vector120:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $120
  1021dd:	6a 78                	push   $0x78
  jmp __alltraps
  1021df:	e9 ad fb ff ff       	jmp    101d91 <__alltraps>

001021e4 <vector121>:
.globl vector121
vector121:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $121
  1021e6:	6a 79                	push   $0x79
  jmp __alltraps
  1021e8:	e9 a4 fb ff ff       	jmp    101d91 <__alltraps>

001021ed <vector122>:
.globl vector122
vector122:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $122
  1021ef:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021f1:	e9 9b fb ff ff       	jmp    101d91 <__alltraps>

001021f6 <vector123>:
.globl vector123
vector123:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $123
  1021f8:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021fa:	e9 92 fb ff ff       	jmp    101d91 <__alltraps>

001021ff <vector124>:
.globl vector124
vector124:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $124
  102201:	6a 7c                	push   $0x7c
  jmp __alltraps
  102203:	e9 89 fb ff ff       	jmp    101d91 <__alltraps>

00102208 <vector125>:
.globl vector125
vector125:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $125
  10220a:	6a 7d                	push   $0x7d
  jmp __alltraps
  10220c:	e9 80 fb ff ff       	jmp    101d91 <__alltraps>

00102211 <vector126>:
.globl vector126
vector126:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $126
  102213:	6a 7e                	push   $0x7e
  jmp __alltraps
  102215:	e9 77 fb ff ff       	jmp    101d91 <__alltraps>

0010221a <vector127>:
.globl vector127
vector127:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $127
  10221c:	6a 7f                	push   $0x7f
  jmp __alltraps
  10221e:	e9 6e fb ff ff       	jmp    101d91 <__alltraps>

00102223 <vector128>:
.globl vector128
vector128:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $128
  102225:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10222a:	e9 62 fb ff ff       	jmp    101d91 <__alltraps>

0010222f <vector129>:
.globl vector129
vector129:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $129
  102231:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102236:	e9 56 fb ff ff       	jmp    101d91 <__alltraps>

0010223b <vector130>:
.globl vector130
vector130:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $130
  10223d:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102242:	e9 4a fb ff ff       	jmp    101d91 <__alltraps>

00102247 <vector131>:
.globl vector131
vector131:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $131
  102249:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10224e:	e9 3e fb ff ff       	jmp    101d91 <__alltraps>

00102253 <vector132>:
.globl vector132
vector132:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $132
  102255:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10225a:	e9 32 fb ff ff       	jmp    101d91 <__alltraps>

0010225f <vector133>:
.globl vector133
vector133:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $133
  102261:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102266:	e9 26 fb ff ff       	jmp    101d91 <__alltraps>

0010226b <vector134>:
.globl vector134
vector134:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $134
  10226d:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102272:	e9 1a fb ff ff       	jmp    101d91 <__alltraps>

00102277 <vector135>:
.globl vector135
vector135:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $135
  102279:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10227e:	e9 0e fb ff ff       	jmp    101d91 <__alltraps>

00102283 <vector136>:
.globl vector136
vector136:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $136
  102285:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10228a:	e9 02 fb ff ff       	jmp    101d91 <__alltraps>

0010228f <vector137>:
.globl vector137
vector137:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $137
  102291:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102296:	e9 f6 fa ff ff       	jmp    101d91 <__alltraps>

0010229b <vector138>:
.globl vector138
vector138:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $138
  10229d:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022a2:	e9 ea fa ff ff       	jmp    101d91 <__alltraps>

001022a7 <vector139>:
.globl vector139
vector139:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $139
  1022a9:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022ae:	e9 de fa ff ff       	jmp    101d91 <__alltraps>

001022b3 <vector140>:
.globl vector140
vector140:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $140
  1022b5:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022ba:	e9 d2 fa ff ff       	jmp    101d91 <__alltraps>

001022bf <vector141>:
.globl vector141
vector141:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $141
  1022c1:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022c6:	e9 c6 fa ff ff       	jmp    101d91 <__alltraps>

001022cb <vector142>:
.globl vector142
vector142:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $142
  1022cd:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022d2:	e9 ba fa ff ff       	jmp    101d91 <__alltraps>

001022d7 <vector143>:
.globl vector143
vector143:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $143
  1022d9:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022de:	e9 ae fa ff ff       	jmp    101d91 <__alltraps>

001022e3 <vector144>:
.globl vector144
vector144:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $144
  1022e5:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022ea:	e9 a2 fa ff ff       	jmp    101d91 <__alltraps>

001022ef <vector145>:
.globl vector145
vector145:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $145
  1022f1:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022f6:	e9 96 fa ff ff       	jmp    101d91 <__alltraps>

001022fb <vector146>:
.globl vector146
vector146:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $146
  1022fd:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102302:	e9 8a fa ff ff       	jmp    101d91 <__alltraps>

00102307 <vector147>:
.globl vector147
vector147:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $147
  102309:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10230e:	e9 7e fa ff ff       	jmp    101d91 <__alltraps>

00102313 <vector148>:
.globl vector148
vector148:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $148
  102315:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10231a:	e9 72 fa ff ff       	jmp    101d91 <__alltraps>

0010231f <vector149>:
.globl vector149
vector149:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $149
  102321:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102326:	e9 66 fa ff ff       	jmp    101d91 <__alltraps>

0010232b <vector150>:
.globl vector150
vector150:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $150
  10232d:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102332:	e9 5a fa ff ff       	jmp    101d91 <__alltraps>

00102337 <vector151>:
.globl vector151
vector151:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $151
  102339:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10233e:	e9 4e fa ff ff       	jmp    101d91 <__alltraps>

00102343 <vector152>:
.globl vector152
vector152:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $152
  102345:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10234a:	e9 42 fa ff ff       	jmp    101d91 <__alltraps>

0010234f <vector153>:
.globl vector153
vector153:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $153
  102351:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102356:	e9 36 fa ff ff       	jmp    101d91 <__alltraps>

0010235b <vector154>:
.globl vector154
vector154:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $154
  10235d:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102362:	e9 2a fa ff ff       	jmp    101d91 <__alltraps>

00102367 <vector155>:
.globl vector155
vector155:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $155
  102369:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10236e:	e9 1e fa ff ff       	jmp    101d91 <__alltraps>

00102373 <vector156>:
.globl vector156
vector156:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $156
  102375:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10237a:	e9 12 fa ff ff       	jmp    101d91 <__alltraps>

0010237f <vector157>:
.globl vector157
vector157:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $157
  102381:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102386:	e9 06 fa ff ff       	jmp    101d91 <__alltraps>

0010238b <vector158>:
.globl vector158
vector158:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $158
  10238d:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102392:	e9 fa f9 ff ff       	jmp    101d91 <__alltraps>

00102397 <vector159>:
.globl vector159
vector159:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $159
  102399:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10239e:	e9 ee f9 ff ff       	jmp    101d91 <__alltraps>

001023a3 <vector160>:
.globl vector160
vector160:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $160
  1023a5:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023aa:	e9 e2 f9 ff ff       	jmp    101d91 <__alltraps>

001023af <vector161>:
.globl vector161
vector161:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $161
  1023b1:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023b6:	e9 d6 f9 ff ff       	jmp    101d91 <__alltraps>

001023bb <vector162>:
.globl vector162
vector162:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $162
  1023bd:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023c2:	e9 ca f9 ff ff       	jmp    101d91 <__alltraps>

001023c7 <vector163>:
.globl vector163
vector163:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $163
  1023c9:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023ce:	e9 be f9 ff ff       	jmp    101d91 <__alltraps>

001023d3 <vector164>:
.globl vector164
vector164:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $164
  1023d5:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023da:	e9 b2 f9 ff ff       	jmp    101d91 <__alltraps>

001023df <vector165>:
.globl vector165
vector165:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $165
  1023e1:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023e6:	e9 a6 f9 ff ff       	jmp    101d91 <__alltraps>

001023eb <vector166>:
.globl vector166
vector166:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $166
  1023ed:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023f2:	e9 9a f9 ff ff       	jmp    101d91 <__alltraps>

001023f7 <vector167>:
.globl vector167
vector167:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $167
  1023f9:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023fe:	e9 8e f9 ff ff       	jmp    101d91 <__alltraps>

00102403 <vector168>:
.globl vector168
vector168:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $168
  102405:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10240a:	e9 82 f9 ff ff       	jmp    101d91 <__alltraps>

0010240f <vector169>:
.globl vector169
vector169:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $169
  102411:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102416:	e9 76 f9 ff ff       	jmp    101d91 <__alltraps>

0010241b <vector170>:
.globl vector170
vector170:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $170
  10241d:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102422:	e9 6a f9 ff ff       	jmp    101d91 <__alltraps>

00102427 <vector171>:
.globl vector171
vector171:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $171
  102429:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10242e:	e9 5e f9 ff ff       	jmp    101d91 <__alltraps>

00102433 <vector172>:
.globl vector172
vector172:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $172
  102435:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10243a:	e9 52 f9 ff ff       	jmp    101d91 <__alltraps>

0010243f <vector173>:
.globl vector173
vector173:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $173
  102441:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102446:	e9 46 f9 ff ff       	jmp    101d91 <__alltraps>

0010244b <vector174>:
.globl vector174
vector174:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $174
  10244d:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102452:	e9 3a f9 ff ff       	jmp    101d91 <__alltraps>

00102457 <vector175>:
.globl vector175
vector175:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $175
  102459:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10245e:	e9 2e f9 ff ff       	jmp    101d91 <__alltraps>

00102463 <vector176>:
.globl vector176
vector176:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $176
  102465:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10246a:	e9 22 f9 ff ff       	jmp    101d91 <__alltraps>

0010246f <vector177>:
.globl vector177
vector177:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $177
  102471:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102476:	e9 16 f9 ff ff       	jmp    101d91 <__alltraps>

0010247b <vector178>:
.globl vector178
vector178:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $178
  10247d:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102482:	e9 0a f9 ff ff       	jmp    101d91 <__alltraps>

00102487 <vector179>:
.globl vector179
vector179:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $179
  102489:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10248e:	e9 fe f8 ff ff       	jmp    101d91 <__alltraps>

00102493 <vector180>:
.globl vector180
vector180:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $180
  102495:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10249a:	e9 f2 f8 ff ff       	jmp    101d91 <__alltraps>

0010249f <vector181>:
.globl vector181
vector181:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $181
  1024a1:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024a6:	e9 e6 f8 ff ff       	jmp    101d91 <__alltraps>

001024ab <vector182>:
.globl vector182
vector182:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $182
  1024ad:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024b2:	e9 da f8 ff ff       	jmp    101d91 <__alltraps>

001024b7 <vector183>:
.globl vector183
vector183:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $183
  1024b9:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024be:	e9 ce f8 ff ff       	jmp    101d91 <__alltraps>

001024c3 <vector184>:
.globl vector184
vector184:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $184
  1024c5:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024ca:	e9 c2 f8 ff ff       	jmp    101d91 <__alltraps>

001024cf <vector185>:
.globl vector185
vector185:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $185
  1024d1:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024d6:	e9 b6 f8 ff ff       	jmp    101d91 <__alltraps>

001024db <vector186>:
.globl vector186
vector186:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $186
  1024dd:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024e2:	e9 aa f8 ff ff       	jmp    101d91 <__alltraps>

001024e7 <vector187>:
.globl vector187
vector187:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $187
  1024e9:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024ee:	e9 9e f8 ff ff       	jmp    101d91 <__alltraps>

001024f3 <vector188>:
.globl vector188
vector188:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $188
  1024f5:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024fa:	e9 92 f8 ff ff       	jmp    101d91 <__alltraps>

001024ff <vector189>:
.globl vector189
vector189:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $189
  102501:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102506:	e9 86 f8 ff ff       	jmp    101d91 <__alltraps>

0010250b <vector190>:
.globl vector190
vector190:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $190
  10250d:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102512:	e9 7a f8 ff ff       	jmp    101d91 <__alltraps>

00102517 <vector191>:
.globl vector191
vector191:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $191
  102519:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10251e:	e9 6e f8 ff ff       	jmp    101d91 <__alltraps>

00102523 <vector192>:
.globl vector192
vector192:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $192
  102525:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10252a:	e9 62 f8 ff ff       	jmp    101d91 <__alltraps>

0010252f <vector193>:
.globl vector193
vector193:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $193
  102531:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102536:	e9 56 f8 ff ff       	jmp    101d91 <__alltraps>

0010253b <vector194>:
.globl vector194
vector194:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $194
  10253d:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102542:	e9 4a f8 ff ff       	jmp    101d91 <__alltraps>

00102547 <vector195>:
.globl vector195
vector195:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $195
  102549:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10254e:	e9 3e f8 ff ff       	jmp    101d91 <__alltraps>

00102553 <vector196>:
.globl vector196
vector196:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $196
  102555:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10255a:	e9 32 f8 ff ff       	jmp    101d91 <__alltraps>

0010255f <vector197>:
.globl vector197
vector197:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $197
  102561:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102566:	e9 26 f8 ff ff       	jmp    101d91 <__alltraps>

0010256b <vector198>:
.globl vector198
vector198:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $198
  10256d:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102572:	e9 1a f8 ff ff       	jmp    101d91 <__alltraps>

00102577 <vector199>:
.globl vector199
vector199:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $199
  102579:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10257e:	e9 0e f8 ff ff       	jmp    101d91 <__alltraps>

00102583 <vector200>:
.globl vector200
vector200:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $200
  102585:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10258a:	e9 02 f8 ff ff       	jmp    101d91 <__alltraps>

0010258f <vector201>:
.globl vector201
vector201:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $201
  102591:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102596:	e9 f6 f7 ff ff       	jmp    101d91 <__alltraps>

0010259b <vector202>:
.globl vector202
vector202:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $202
  10259d:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025a2:	e9 ea f7 ff ff       	jmp    101d91 <__alltraps>

001025a7 <vector203>:
.globl vector203
vector203:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $203
  1025a9:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025ae:	e9 de f7 ff ff       	jmp    101d91 <__alltraps>

001025b3 <vector204>:
.globl vector204
vector204:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $204
  1025b5:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025ba:	e9 d2 f7 ff ff       	jmp    101d91 <__alltraps>

001025bf <vector205>:
.globl vector205
vector205:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $205
  1025c1:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025c6:	e9 c6 f7 ff ff       	jmp    101d91 <__alltraps>

001025cb <vector206>:
.globl vector206
vector206:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $206
  1025cd:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025d2:	e9 ba f7 ff ff       	jmp    101d91 <__alltraps>

001025d7 <vector207>:
.globl vector207
vector207:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $207
  1025d9:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025de:	e9 ae f7 ff ff       	jmp    101d91 <__alltraps>

001025e3 <vector208>:
.globl vector208
vector208:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $208
  1025e5:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025ea:	e9 a2 f7 ff ff       	jmp    101d91 <__alltraps>

001025ef <vector209>:
.globl vector209
vector209:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $209
  1025f1:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025f6:	e9 96 f7 ff ff       	jmp    101d91 <__alltraps>

001025fb <vector210>:
.globl vector210
vector210:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $210
  1025fd:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102602:	e9 8a f7 ff ff       	jmp    101d91 <__alltraps>

00102607 <vector211>:
.globl vector211
vector211:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $211
  102609:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10260e:	e9 7e f7 ff ff       	jmp    101d91 <__alltraps>

00102613 <vector212>:
.globl vector212
vector212:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $212
  102615:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10261a:	e9 72 f7 ff ff       	jmp    101d91 <__alltraps>

0010261f <vector213>:
.globl vector213
vector213:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $213
  102621:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102626:	e9 66 f7 ff ff       	jmp    101d91 <__alltraps>

0010262b <vector214>:
.globl vector214
vector214:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $214
  10262d:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102632:	e9 5a f7 ff ff       	jmp    101d91 <__alltraps>

00102637 <vector215>:
.globl vector215
vector215:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $215
  102639:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10263e:	e9 4e f7 ff ff       	jmp    101d91 <__alltraps>

00102643 <vector216>:
.globl vector216
vector216:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $216
  102645:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10264a:	e9 42 f7 ff ff       	jmp    101d91 <__alltraps>

0010264f <vector217>:
.globl vector217
vector217:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $217
  102651:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102656:	e9 36 f7 ff ff       	jmp    101d91 <__alltraps>

0010265b <vector218>:
.globl vector218
vector218:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $218
  10265d:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102662:	e9 2a f7 ff ff       	jmp    101d91 <__alltraps>

00102667 <vector219>:
.globl vector219
vector219:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $219
  102669:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10266e:	e9 1e f7 ff ff       	jmp    101d91 <__alltraps>

00102673 <vector220>:
.globl vector220
vector220:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $220
  102675:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10267a:	e9 12 f7 ff ff       	jmp    101d91 <__alltraps>

0010267f <vector221>:
.globl vector221
vector221:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $221
  102681:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102686:	e9 06 f7 ff ff       	jmp    101d91 <__alltraps>

0010268b <vector222>:
.globl vector222
vector222:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $222
  10268d:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102692:	e9 fa f6 ff ff       	jmp    101d91 <__alltraps>

00102697 <vector223>:
.globl vector223
vector223:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $223
  102699:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10269e:	e9 ee f6 ff ff       	jmp    101d91 <__alltraps>

001026a3 <vector224>:
.globl vector224
vector224:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $224
  1026a5:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026aa:	e9 e2 f6 ff ff       	jmp    101d91 <__alltraps>

001026af <vector225>:
.globl vector225
vector225:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $225
  1026b1:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026b6:	e9 d6 f6 ff ff       	jmp    101d91 <__alltraps>

001026bb <vector226>:
.globl vector226
vector226:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $226
  1026bd:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026c2:	e9 ca f6 ff ff       	jmp    101d91 <__alltraps>

001026c7 <vector227>:
.globl vector227
vector227:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $227
  1026c9:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026ce:	e9 be f6 ff ff       	jmp    101d91 <__alltraps>

001026d3 <vector228>:
.globl vector228
vector228:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $228
  1026d5:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026da:	e9 b2 f6 ff ff       	jmp    101d91 <__alltraps>

001026df <vector229>:
.globl vector229
vector229:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $229
  1026e1:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026e6:	e9 a6 f6 ff ff       	jmp    101d91 <__alltraps>

001026eb <vector230>:
.globl vector230
vector230:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $230
  1026ed:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026f2:	e9 9a f6 ff ff       	jmp    101d91 <__alltraps>

001026f7 <vector231>:
.globl vector231
vector231:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $231
  1026f9:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026fe:	e9 8e f6 ff ff       	jmp    101d91 <__alltraps>

00102703 <vector232>:
.globl vector232
vector232:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $232
  102705:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10270a:	e9 82 f6 ff ff       	jmp    101d91 <__alltraps>

0010270f <vector233>:
.globl vector233
vector233:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $233
  102711:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102716:	e9 76 f6 ff ff       	jmp    101d91 <__alltraps>

0010271b <vector234>:
.globl vector234
vector234:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $234
  10271d:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102722:	e9 6a f6 ff ff       	jmp    101d91 <__alltraps>

00102727 <vector235>:
.globl vector235
vector235:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $235
  102729:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10272e:	e9 5e f6 ff ff       	jmp    101d91 <__alltraps>

00102733 <vector236>:
.globl vector236
vector236:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $236
  102735:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10273a:	e9 52 f6 ff ff       	jmp    101d91 <__alltraps>

0010273f <vector237>:
.globl vector237
vector237:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $237
  102741:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102746:	e9 46 f6 ff ff       	jmp    101d91 <__alltraps>

0010274b <vector238>:
.globl vector238
vector238:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $238
  10274d:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102752:	e9 3a f6 ff ff       	jmp    101d91 <__alltraps>

00102757 <vector239>:
.globl vector239
vector239:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $239
  102759:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10275e:	e9 2e f6 ff ff       	jmp    101d91 <__alltraps>

00102763 <vector240>:
.globl vector240
vector240:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $240
  102765:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10276a:	e9 22 f6 ff ff       	jmp    101d91 <__alltraps>

0010276f <vector241>:
.globl vector241
vector241:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $241
  102771:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102776:	e9 16 f6 ff ff       	jmp    101d91 <__alltraps>

0010277b <vector242>:
.globl vector242
vector242:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $242
  10277d:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102782:	e9 0a f6 ff ff       	jmp    101d91 <__alltraps>

00102787 <vector243>:
.globl vector243
vector243:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $243
  102789:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10278e:	e9 fe f5 ff ff       	jmp    101d91 <__alltraps>

00102793 <vector244>:
.globl vector244
vector244:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $244
  102795:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10279a:	e9 f2 f5 ff ff       	jmp    101d91 <__alltraps>

0010279f <vector245>:
.globl vector245
vector245:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $245
  1027a1:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027a6:	e9 e6 f5 ff ff       	jmp    101d91 <__alltraps>

001027ab <vector246>:
.globl vector246
vector246:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $246
  1027ad:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027b2:	e9 da f5 ff ff       	jmp    101d91 <__alltraps>

001027b7 <vector247>:
.globl vector247
vector247:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $247
  1027b9:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027be:	e9 ce f5 ff ff       	jmp    101d91 <__alltraps>

001027c3 <vector248>:
.globl vector248
vector248:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $248
  1027c5:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027ca:	e9 c2 f5 ff ff       	jmp    101d91 <__alltraps>

001027cf <vector249>:
.globl vector249
vector249:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $249
  1027d1:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027d6:	e9 b6 f5 ff ff       	jmp    101d91 <__alltraps>

001027db <vector250>:
.globl vector250
vector250:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $250
  1027dd:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027e2:	e9 aa f5 ff ff       	jmp    101d91 <__alltraps>

001027e7 <vector251>:
.globl vector251
vector251:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $251
  1027e9:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027ee:	e9 9e f5 ff ff       	jmp    101d91 <__alltraps>

001027f3 <vector252>:
.globl vector252
vector252:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $252
  1027f5:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027fa:	e9 92 f5 ff ff       	jmp    101d91 <__alltraps>

001027ff <vector253>:
.globl vector253
vector253:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $253
  102801:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102806:	e9 86 f5 ff ff       	jmp    101d91 <__alltraps>

0010280b <vector254>:
.globl vector254
vector254:
  pushl $0
  10280b:	6a 00                	push   $0x0
  pushl $254
  10280d:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102812:	e9 7a f5 ff ff       	jmp    101d91 <__alltraps>

00102817 <vector255>:
.globl vector255
vector255:
  pushl $0
  102817:	6a 00                	push   $0x0
  pushl $255
  102819:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10281e:	e9 6e f5 ff ff       	jmp    101d91 <__alltraps>

00102823 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102823:	55                   	push   %ebp
  102824:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102826:	8b 55 08             	mov    0x8(%ebp),%edx
  102829:	a1 64 89 11 00       	mov    0x118964,%eax
  10282e:	29 c2                	sub    %eax,%edx
  102830:	89 d0                	mov    %edx,%eax
  102832:	c1 f8 02             	sar    $0x2,%eax
  102835:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10283b:	5d                   	pop    %ebp
  10283c:	c3                   	ret    

0010283d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10283d:	55                   	push   %ebp
  10283e:	89 e5                	mov    %esp,%ebp
  102840:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102843:	8b 45 08             	mov    0x8(%ebp),%eax
  102846:	89 04 24             	mov    %eax,(%esp)
  102849:	e8 d5 ff ff ff       	call   102823 <page2ppn>
  10284e:	c1 e0 0c             	shl    $0xc,%eax
}
  102851:	c9                   	leave  
  102852:	c3                   	ret    

00102853 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102853:	55                   	push   %ebp
  102854:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102856:	8b 45 08             	mov    0x8(%ebp),%eax
  102859:	8b 00                	mov    (%eax),%eax
}
  10285b:	5d                   	pop    %ebp
  10285c:	c3                   	ret    

0010285d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  10285d:	55                   	push   %ebp
  10285e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102860:	8b 45 08             	mov    0x8(%ebp),%eax
  102863:	8b 55 0c             	mov    0xc(%ebp),%edx
  102866:	89 10                	mov    %edx,(%eax)
}
  102868:	5d                   	pop    %ebp
  102869:	c3                   	ret    

0010286a <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  10286a:	55                   	push   %ebp
  10286b:	89 e5                	mov    %esp,%ebp
  10286d:	83 ec 10             	sub    $0x10,%esp
  102870:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102877:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10287a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10287d:	89 50 04             	mov    %edx,0x4(%eax)
  102880:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102883:	8b 50 04             	mov    0x4(%eax),%edx
  102886:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102889:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  10288b:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  102892:	00 00 00 
}
  102895:	c9                   	leave  
  102896:	c3                   	ret    

00102897 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102897:	55                   	push   %ebp
  102898:	89 e5                	mov    %esp,%ebp
  10289a:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  10289d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1028a1:	75 24                	jne    1028c7 <default_init_memmap+0x30>
  1028a3:	c7 44 24 0c b0 66 10 	movl   $0x1066b0,0xc(%esp)
  1028aa:	00 
  1028ab:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1028b2:	00 
  1028b3:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  1028ba:	00 
  1028bb:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1028c2:	e8 08 e4 ff ff       	call   100ccf <__panic>
    struct Page *p = base;
  1028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1028cd:	e9 a5 00 00 00       	jmp    102977 <default_init_memmap+0xe0>
        assert(PageReserved(p));
  1028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028d5:	83 c0 04             	add    $0x4,%eax
  1028d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1028df:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1028e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1028e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1028e8:	0f a3 10             	bt     %edx,(%eax)
  1028eb:	19 c0                	sbb    %eax,%eax
  1028ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1028f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1028f4:	0f 95 c0             	setne  %al
  1028f7:	0f b6 c0             	movzbl %al,%eax
  1028fa:	85 c0                	test   %eax,%eax
  1028fc:	75 24                	jne    102922 <default_init_memmap+0x8b>
  1028fe:	c7 44 24 0c e1 66 10 	movl   $0x1066e1,0xc(%esp)
  102905:	00 
  102906:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10290d:	00 
  10290e:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  102915:	00 
  102916:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  10291d:	e8 ad e3 ff ff       	call   100ccf <__panic>
        p->flags = 0;
  102922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102925:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
  10292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10292f:	83 c0 04             	add    $0x4,%eax
  102932:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102939:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10293c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10293f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102942:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
  102945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102948:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	if(p == base)
  10294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102952:	3b 45 08             	cmp    0x8(%ebp),%eax
  102955:	75 09                	jne    102960 <default_init_memmap+0xc9>
		p->property = n;
  102957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10295a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10295d:	89 50 08             	mov    %edx,0x8(%eax)
	set_page_ref(p, 0);
  102960:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102967:	00 
  102968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10296b:	89 04 24             	mov    %eax,(%esp)
  10296e:	e8 ea fe ff ff       	call   10285d <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102973:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102977:	8b 55 0c             	mov    0xc(%ebp),%edx
  10297a:	89 d0                	mov    %edx,%eax
  10297c:	c1 e0 02             	shl    $0x2,%eax
  10297f:	01 d0                	add    %edx,%eax
  102981:	c1 e0 02             	shl    $0x2,%eax
  102984:	89 c2                	mov    %eax,%edx
  102986:	8b 45 08             	mov    0x8(%ebp),%eax
  102989:	01 d0                	add    %edx,%eax
  10298b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10298e:	0f 85 3e ff ff ff    	jne    1028d2 <default_init_memmap+0x3b>
        p->property = 0;
	if(p == base)
		p->property = n;
	set_page_ref(p, 0);
    }
    nr_free += n;
  102994:	8b 15 58 89 11 00    	mov    0x118958,%edx
  10299a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10299d:	01 d0                	add    %edx,%eax
  10299f:	a3 58 89 11 00       	mov    %eax,0x118958
    list_add_before(&free_list, &(base->page_link));
  1029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a7:	83 c0 0c             	add    $0xc,%eax
  1029aa:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  1029b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  1029b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029b7:	8b 00                	mov    (%eax),%eax
  1029b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1029bc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1029bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1029c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1029c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1029cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1029ce:	89 10                	mov    %edx,(%eax)
  1029d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1029d3:	8b 10                	mov    (%eax),%edx
  1029d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1029d8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1029db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1029de:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1029e1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1029e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1029e7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1029ea:	89 10                	mov    %edx,(%eax)
}
  1029ec:	c9                   	leave  
  1029ed:	c3                   	ret    

001029ee <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1029ee:	55                   	push   %ebp
  1029ef:	89 e5                	mov    %esp,%ebp
  1029f1:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  1029f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1029f8:	75 24                	jne    102a1e <default_alloc_pages+0x30>
  1029fa:	c7 44 24 0c b0 66 10 	movl   $0x1066b0,0xc(%esp)
  102a01:	00 
  102a02:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102a09:	00 
  102a0a:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  102a11:	00 
  102a12:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102a19:	e8 b1 e2 ff ff       	call   100ccf <__panic>
    if (n > nr_free) {
  102a1e:	a1 58 89 11 00       	mov    0x118958,%eax
  102a23:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a26:	73 0a                	jae    102a32 <default_alloc_pages+0x44>
        return NULL;
  102a28:	b8 00 00 00 00       	mov    $0x0,%eax
  102a2d:	e9 43 01 00 00       	jmp    102b75 <default_alloc_pages+0x187>
    }
    struct Page *page = NULL;
  102a32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102a39:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102a40:	eb 1c                	jmp    102a5e <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a45:	83 e8 0c             	sub    $0xc,%eax
  102a48:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
  102a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a4e:	8b 40 08             	mov    0x8(%eax),%eax
  102a51:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a54:	72 08                	jb     102a5e <default_alloc_pages+0x70>
            page = p;
  102a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102a5c:	eb 18                	jmp    102a76 <default_alloc_pages+0x88>
  102a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a61:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102a64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a67:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a6d:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102a74:	75 cc                	jne    102a42 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102a7a:	0f 84 f2 00 00 00    	je     102b72 <default_alloc_pages+0x184>
	int i;
        list_del(&(page->page_link));
  102a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a83:	83 c0 0c             	add    $0xc,%eax
  102a86:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102a89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a8c:	8b 40 04             	mov    0x4(%eax),%eax
  102a8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102a92:	8b 12                	mov    (%edx),%edx
  102a94:	89 55 d8             	mov    %edx,-0x28(%ebp)
  102a97:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102a9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a9d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102aa0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102aa3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102aa6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102aa9:	89 10                	mov    %edx,(%eax)
	for(i = 0 ; i < n ; i++)
  102aab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102ab2:	eb 2e                	jmp    102ae2 <default_alloc_pages+0xf4>
	{
		ClearPageProperty(page + i);
  102ab4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ab7:	89 d0                	mov    %edx,%eax
  102ab9:	c1 e0 02             	shl    $0x2,%eax
  102abc:	01 d0                	add    %edx,%eax
  102abe:	c1 e0 02             	shl    $0x2,%eax
  102ac1:	89 c2                	mov    %eax,%edx
  102ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ac6:	01 d0                	add    %edx,%eax
  102ac8:	83 c0 04             	add    $0x4,%eax
  102acb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102ad2:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102ad5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102ad8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102adb:	0f b3 10             	btr    %edx,(%eax)
        }
    }
    if (page != NULL) {
	int i;
        list_del(&(page->page_link));
	for(i = 0 ; i < n ; i++)
  102ade:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  102ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ae5:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ae8:	72 ca                	jb     102ab4 <default_alloc_pages+0xc6>
	{
		ClearPageProperty(page + i);
	}
        if (page->property > n) {
  102aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aed:	8b 40 08             	mov    0x8(%eax),%eax
  102af0:	3b 45 08             	cmp    0x8(%ebp),%eax
  102af3:	76 70                	jbe    102b65 <default_alloc_pages+0x177>
            struct Page *p = page + n;
  102af5:	8b 55 08             	mov    0x8(%ebp),%edx
  102af8:	89 d0                	mov    %edx,%eax
  102afa:	c1 e0 02             	shl    $0x2,%eax
  102afd:	01 d0                	add    %edx,%eax
  102aff:	c1 e0 02             	shl    $0x2,%eax
  102b02:	89 c2                	mov    %eax,%edx
  102b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b07:	01 d0                	add    %edx,%eax
  102b09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n;
  102b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b0f:	8b 40 08             	mov    0x8(%eax),%eax
  102b12:	2b 45 08             	sub    0x8(%ebp),%eax
  102b15:	89 c2                	mov    %eax,%edx
  102b17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b1a:	89 50 08             	mov    %edx,0x8(%eax)
            list_add_before(&free_list, &(p->page_link));
  102b1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b20:	83 c0 0c             	add    $0xc,%eax
  102b23:	c7 45 c8 50 89 11 00 	movl   $0x118950,-0x38(%ebp)
  102b2a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102b2d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b30:	8b 00                	mov    (%eax),%eax
  102b32:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b35:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102b38:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102b3b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b41:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102b44:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102b47:	89 10                	mov    %edx,(%eax)
  102b49:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102b4c:	8b 10                	mov    (%eax),%edx
  102b4e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b51:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b54:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b57:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102b5a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b5d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b60:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102b63:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
  102b65:	a1 58 89 11 00       	mov    0x118958,%eax
  102b6a:	2b 45 08             	sub    0x8(%ebp),%eax
  102b6d:	a3 58 89 11 00       	mov    %eax,0x118958
    }
    return page;
  102b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102b75:	c9                   	leave  
  102b76:	c3                   	ret    

00102b77 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102b77:	55                   	push   %ebp
  102b78:	89 e5                	mov    %esp,%ebp
  102b7a:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
  102b80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b84:	75 24                	jne    102baa <default_free_pages+0x33>
  102b86:	c7 44 24 0c b0 66 10 	movl   $0x1066b0,0xc(%esp)
  102b8d:	00 
  102b8e:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102b95:	00 
  102b96:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
  102b9d:	00 
  102b9e:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102ba5:	e8 25 e1 ff ff       	call   100ccf <__panic>
    struct Page *p = base;
  102baa:	8b 45 08             	mov    0x8(%ebp),%eax
  102bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102bb0:	e9 9d 00 00 00       	jmp    102c52 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bb8:	83 c0 04             	add    $0x4,%eax
  102bbb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102bc2:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102bc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bc8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102bcb:	0f a3 10             	bt     %edx,(%eax)
  102bce:	19 c0                	sbb    %eax,%eax
  102bd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102bd3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102bd7:	0f 95 c0             	setne  %al
  102bda:	0f b6 c0             	movzbl %al,%eax
  102bdd:	85 c0                	test   %eax,%eax
  102bdf:	75 2c                	jne    102c0d <default_free_pages+0x96>
  102be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102be4:	83 c0 04             	add    $0x4,%eax
  102be7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102bee:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102bf1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bf4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102bf7:	0f a3 10             	bt     %edx,(%eax)
  102bfa:	19 c0                	sbb    %eax,%eax
  102bfc:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102bff:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102c03:	0f 95 c0             	setne  %al
  102c06:	0f b6 c0             	movzbl %al,%eax
  102c09:	85 c0                	test   %eax,%eax
  102c0b:	74 24                	je     102c31 <default_free_pages+0xba>
  102c0d:	c7 44 24 0c f4 66 10 	movl   $0x1066f4,0xc(%esp)
  102c14:	00 
  102c15:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102c1c:	00 
  102c1d:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  102c24:	00 
  102c25:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102c2c:	e8 9e e0 ff ff       	call   100ccf <__panic>
        p->flags = 0;
  102c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102c3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c42:	00 
  102c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c46:	89 04 24             	mov    %eax,(%esp)
  102c49:	e8 0f fc ff ff       	call   10285d <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102c4e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c55:	89 d0                	mov    %edx,%eax
  102c57:	c1 e0 02             	shl    $0x2,%eax
  102c5a:	01 d0                	add    %edx,%eax
  102c5c:	c1 e0 02             	shl    $0x2,%eax
  102c5f:	89 c2                	mov    %eax,%edx
  102c61:	8b 45 08             	mov    0x8(%ebp),%eax
  102c64:	01 d0                	add    %edx,%eax
  102c66:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102c69:	0f 85 46 ff ff ff    	jne    102bb5 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c75:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102c78:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7b:	83 c0 04             	add    $0x4,%eax
  102c7e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102c85:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c88:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c8b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c8e:	0f ab 10             	bts    %edx,(%eax)
  102c91:	c7 45 cc 50 89 11 00 	movl   $0x118950,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102c98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c9b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102ca1:	e9 08 01 00 00       	jmp    102dae <default_free_pages+0x237>
        p = le2page(le, page_link);
  102ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ca9:	83 e8 0c             	sub    $0xc,%eax
  102cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cb2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102cb5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102cb8:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc1:	8b 50 08             	mov    0x8(%eax),%edx
  102cc4:	89 d0                	mov    %edx,%eax
  102cc6:	c1 e0 02             	shl    $0x2,%eax
  102cc9:	01 d0                	add    %edx,%eax
  102ccb:	c1 e0 02             	shl    $0x2,%eax
  102cce:	89 c2                	mov    %eax,%edx
  102cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd3:	01 d0                	add    %edx,%eax
  102cd5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102cd8:	75 5a                	jne    102d34 <default_free_pages+0x1bd>
            base->property += p->property;
  102cda:	8b 45 08             	mov    0x8(%ebp),%eax
  102cdd:	8b 50 08             	mov    0x8(%eax),%edx
  102ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ce3:	8b 40 08             	mov    0x8(%eax),%eax
  102ce6:	01 c2                	add    %eax,%edx
  102ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ceb:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cf1:	83 c0 04             	add    $0x4,%eax
  102cf4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102cfb:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cfe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d01:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d04:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  102d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d0a:	83 c0 0c             	add    $0xc,%eax
  102d0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102d10:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d13:	8b 40 04             	mov    0x4(%eax),%eax
  102d16:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102d19:	8b 12                	mov    (%edx),%edx
  102d1b:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102d1e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102d21:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d24:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d27:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102d2a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d2d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102d30:	89 10                	mov    %edx,(%eax)
  102d32:	eb 7a                	jmp    102dae <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  102d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d37:	8b 50 08             	mov    0x8(%eax),%edx
  102d3a:	89 d0                	mov    %edx,%eax
  102d3c:	c1 e0 02             	shl    $0x2,%eax
  102d3f:	01 d0                	add    %edx,%eax
  102d41:	c1 e0 02             	shl    $0x2,%eax
  102d44:	89 c2                	mov    %eax,%edx
  102d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d49:	01 d0                	add    %edx,%eax
  102d4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d4e:	75 5e                	jne    102dae <default_free_pages+0x237>
            p->property += base->property;
  102d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d53:	8b 50 08             	mov    0x8(%eax),%edx
  102d56:	8b 45 08             	mov    0x8(%ebp),%eax
  102d59:	8b 40 08             	mov    0x8(%eax),%eax
  102d5c:	01 c2                	add    %eax,%edx
  102d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d61:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102d64:	8b 45 08             	mov    0x8(%ebp),%eax
  102d67:	83 c0 04             	add    $0x4,%eax
  102d6a:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102d71:	89 45 ac             	mov    %eax,-0x54(%ebp)
  102d74:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102d77:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102d7a:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  102d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d80:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d86:	83 c0 0c             	add    $0xc,%eax
  102d89:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102d8c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102d8f:	8b 40 04             	mov    0x4(%eax),%eax
  102d92:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102d95:	8b 12                	mov    (%edx),%edx
  102d97:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102d9a:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102d9d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102da0:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102da3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102da6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102da9:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102dac:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  102dae:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102db5:	0f 85 eb fe ff ff    	jne    102ca6 <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
  102dbb:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dc4:	01 d0                	add    %edx,%eax
  102dc6:	a3 58 89 11 00       	mov    %eax,0x118958
    list_add_before(&free_list, &(base->page_link));
  102dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dce:	83 c0 0c             	add    $0xc,%eax
  102dd1:	c7 45 9c 50 89 11 00 	movl   $0x118950,-0x64(%ebp)
  102dd8:	89 45 98             	mov    %eax,-0x68(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102ddb:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102dde:	8b 00                	mov    (%eax),%eax
  102de0:	8b 55 98             	mov    -0x68(%ebp),%edx
  102de3:	89 55 94             	mov    %edx,-0x6c(%ebp)
  102de6:	89 45 90             	mov    %eax,-0x70(%ebp)
  102de9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102dec:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102def:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102df2:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102df5:	89 10                	mov    %edx,(%eax)
  102df7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102dfa:	8b 10                	mov    (%eax),%edx
  102dfc:	8b 45 90             	mov    -0x70(%ebp),%eax
  102dff:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102e02:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102e05:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102e08:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102e0b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102e0e:	8b 55 90             	mov    -0x70(%ebp),%edx
  102e11:	89 10                	mov    %edx,(%eax)
}
  102e13:	c9                   	leave  
  102e14:	c3                   	ret    

00102e15 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e15:	55                   	push   %ebp
  102e16:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e18:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102e1d:	5d                   	pop    %ebp
  102e1e:	c3                   	ret    

00102e1f <basic_check>:

static void
basic_check(void) {
  102e1f:	55                   	push   %ebp
  102e20:	89 e5                	mov    %esp,%ebp
  102e22:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e35:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e3f:	e8 85 0e 00 00       	call   103cc9 <alloc_pages>
  102e44:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e47:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e4b:	75 24                	jne    102e71 <basic_check+0x52>
  102e4d:	c7 44 24 0c 19 67 10 	movl   $0x106719,0xc(%esp)
  102e54:	00 
  102e55:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102e5c:	00 
  102e5d:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  102e64:	00 
  102e65:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102e6c:	e8 5e de ff ff       	call   100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
  102e71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e78:	e8 4c 0e 00 00       	call   103cc9 <alloc_pages>
  102e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e84:	75 24                	jne    102eaa <basic_check+0x8b>
  102e86:	c7 44 24 0c 35 67 10 	movl   $0x106735,0xc(%esp)
  102e8d:	00 
  102e8e:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102e95:	00 
  102e96:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  102e9d:	00 
  102e9e:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102ea5:	e8 25 de ff ff       	call   100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
  102eaa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102eb1:	e8 13 0e 00 00       	call   103cc9 <alloc_pages>
  102eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102ebd:	75 24                	jne    102ee3 <basic_check+0xc4>
  102ebf:	c7 44 24 0c 51 67 10 	movl   $0x106751,0xc(%esp)
  102ec6:	00 
  102ec7:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102ece:	00 
  102ecf:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  102ed6:	00 
  102ed7:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102ede:	e8 ec dd ff ff       	call   100ccf <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102ee3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ee6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102ee9:	74 10                	je     102efb <basic_check+0xdc>
  102eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102eee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ef1:	74 08                	je     102efb <basic_check+0xdc>
  102ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ef6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ef9:	75 24                	jne    102f1f <basic_check+0x100>
  102efb:	c7 44 24 0c 70 67 10 	movl   $0x106770,0xc(%esp)
  102f02:	00 
  102f03:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102f0a:	00 
  102f0b:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  102f12:	00 
  102f13:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102f1a:	e8 b0 dd ff ff       	call   100ccf <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f22:	89 04 24             	mov    %eax,(%esp)
  102f25:	e8 29 f9 ff ff       	call   102853 <page_ref>
  102f2a:	85 c0                	test   %eax,%eax
  102f2c:	75 1e                	jne    102f4c <basic_check+0x12d>
  102f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f31:	89 04 24             	mov    %eax,(%esp)
  102f34:	e8 1a f9 ff ff       	call   102853 <page_ref>
  102f39:	85 c0                	test   %eax,%eax
  102f3b:	75 0f                	jne    102f4c <basic_check+0x12d>
  102f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f40:	89 04 24             	mov    %eax,(%esp)
  102f43:	e8 0b f9 ff ff       	call   102853 <page_ref>
  102f48:	85 c0                	test   %eax,%eax
  102f4a:	74 24                	je     102f70 <basic_check+0x151>
  102f4c:	c7 44 24 0c 94 67 10 	movl   $0x106794,0xc(%esp)
  102f53:	00 
  102f54:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102f5b:	00 
  102f5c:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  102f63:	00 
  102f64:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102f6b:	e8 5f dd ff ff       	call   100ccf <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f73:	89 04 24             	mov    %eax,(%esp)
  102f76:	e8 c2 f8 ff ff       	call   10283d <page2pa>
  102f7b:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f81:	c1 e2 0c             	shl    $0xc,%edx
  102f84:	39 d0                	cmp    %edx,%eax
  102f86:	72 24                	jb     102fac <basic_check+0x18d>
  102f88:	c7 44 24 0c d0 67 10 	movl   $0x1067d0,0xc(%esp)
  102f8f:	00 
  102f90:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102f97:	00 
  102f98:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  102f9f:	00 
  102fa0:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102fa7:	e8 23 dd ff ff       	call   100ccf <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102faf:	89 04 24             	mov    %eax,(%esp)
  102fb2:	e8 86 f8 ff ff       	call   10283d <page2pa>
  102fb7:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fbd:	c1 e2 0c             	shl    $0xc,%edx
  102fc0:	39 d0                	cmp    %edx,%eax
  102fc2:	72 24                	jb     102fe8 <basic_check+0x1c9>
  102fc4:	c7 44 24 0c ed 67 10 	movl   $0x1067ed,0xc(%esp)
  102fcb:	00 
  102fcc:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  102fd3:	00 
  102fd4:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
  102fdb:	00 
  102fdc:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  102fe3:	e8 e7 dc ff ff       	call   100ccf <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102feb:	89 04 24             	mov    %eax,(%esp)
  102fee:	e8 4a f8 ff ff       	call   10283d <page2pa>
  102ff3:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102ff9:	c1 e2 0c             	shl    $0xc,%edx
  102ffc:	39 d0                	cmp    %edx,%eax
  102ffe:	72 24                	jb     103024 <basic_check+0x205>
  103000:	c7 44 24 0c 0a 68 10 	movl   $0x10680a,0xc(%esp)
  103007:	00 
  103008:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10300f:	00 
  103010:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
  103017:	00 
  103018:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  10301f:	e8 ab dc ff ff       	call   100ccf <__panic>

    list_entry_t free_list_store = free_list;
  103024:	a1 50 89 11 00       	mov    0x118950,%eax
  103029:	8b 15 54 89 11 00    	mov    0x118954,%edx
  10302f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103032:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103035:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10303c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10303f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103042:	89 50 04             	mov    %edx,0x4(%eax)
  103045:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103048:	8b 50 04             	mov    0x4(%eax),%edx
  10304b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10304e:	89 10                	mov    %edx,(%eax)
  103050:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103057:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10305a:	8b 40 04             	mov    0x4(%eax),%eax
  10305d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103060:	0f 94 c0             	sete   %al
  103063:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103066:	85 c0                	test   %eax,%eax
  103068:	75 24                	jne    10308e <basic_check+0x26f>
  10306a:	c7 44 24 0c 27 68 10 	movl   $0x106827,0xc(%esp)
  103071:	00 
  103072:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103079:	00 
  10307a:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
  103081:	00 
  103082:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103089:	e8 41 dc ff ff       	call   100ccf <__panic>

    unsigned int nr_free_store = nr_free;
  10308e:	a1 58 89 11 00       	mov    0x118958,%eax
  103093:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103096:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  10309d:	00 00 00 

    assert(alloc_page() == NULL);
  1030a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030a7:	e8 1d 0c 00 00       	call   103cc9 <alloc_pages>
  1030ac:	85 c0                	test   %eax,%eax
  1030ae:	74 24                	je     1030d4 <basic_check+0x2b5>
  1030b0:	c7 44 24 0c 3e 68 10 	movl   $0x10683e,0xc(%esp)
  1030b7:	00 
  1030b8:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1030bf:	00 
  1030c0:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  1030c7:	00 
  1030c8:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1030cf:	e8 fb db ff ff       	call   100ccf <__panic>

    free_page(p0);
  1030d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030db:	00 
  1030dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030df:	89 04 24             	mov    %eax,(%esp)
  1030e2:	e8 1a 0c 00 00       	call   103d01 <free_pages>
    free_page(p1);
  1030e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030ee:	00 
  1030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030f2:	89 04 24             	mov    %eax,(%esp)
  1030f5:	e8 07 0c 00 00       	call   103d01 <free_pages>
    free_page(p2);
  1030fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103101:	00 
  103102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103105:	89 04 24             	mov    %eax,(%esp)
  103108:	e8 f4 0b 00 00       	call   103d01 <free_pages>
    assert(nr_free == 3);
  10310d:	a1 58 89 11 00       	mov    0x118958,%eax
  103112:	83 f8 03             	cmp    $0x3,%eax
  103115:	74 24                	je     10313b <basic_check+0x31c>
  103117:	c7 44 24 0c 53 68 10 	movl   $0x106853,0xc(%esp)
  10311e:	00 
  10311f:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103126:	00 
  103127:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  10312e:	00 
  10312f:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103136:	e8 94 db ff ff       	call   100ccf <__panic>

    assert((p0 = alloc_page()) != NULL);
  10313b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103142:	e8 82 0b 00 00       	call   103cc9 <alloc_pages>
  103147:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10314a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10314e:	75 24                	jne    103174 <basic_check+0x355>
  103150:	c7 44 24 0c 19 67 10 	movl   $0x106719,0xc(%esp)
  103157:	00 
  103158:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10315f:	00 
  103160:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  103167:	00 
  103168:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  10316f:	e8 5b db ff ff       	call   100ccf <__panic>
    assert((p1 = alloc_page()) != NULL);
  103174:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10317b:	e8 49 0b 00 00       	call   103cc9 <alloc_pages>
  103180:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103183:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103187:	75 24                	jne    1031ad <basic_check+0x38e>
  103189:	c7 44 24 0c 35 67 10 	movl   $0x106735,0xc(%esp)
  103190:	00 
  103191:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103198:	00 
  103199:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  1031a0:	00 
  1031a1:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1031a8:	e8 22 db ff ff       	call   100ccf <__panic>
    assert((p2 = alloc_page()) != NULL);
  1031ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031b4:	e8 10 0b 00 00       	call   103cc9 <alloc_pages>
  1031b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031c0:	75 24                	jne    1031e6 <basic_check+0x3c7>
  1031c2:	c7 44 24 0c 51 67 10 	movl   $0x106751,0xc(%esp)
  1031c9:	00 
  1031ca:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1031d1:	00 
  1031d2:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  1031d9:	00 
  1031da:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1031e1:	e8 e9 da ff ff       	call   100ccf <__panic>

    assert(alloc_page() == NULL);
  1031e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031ed:	e8 d7 0a 00 00       	call   103cc9 <alloc_pages>
  1031f2:	85 c0                	test   %eax,%eax
  1031f4:	74 24                	je     10321a <basic_check+0x3fb>
  1031f6:	c7 44 24 0c 3e 68 10 	movl   $0x10683e,0xc(%esp)
  1031fd:	00 
  1031fe:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103205:	00 
  103206:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  10320d:	00 
  10320e:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103215:	e8 b5 da ff ff       	call   100ccf <__panic>

    free_page(p0);
  10321a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103221:	00 
  103222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103225:	89 04 24             	mov    %eax,(%esp)
  103228:	e8 d4 0a 00 00       	call   103d01 <free_pages>
  10322d:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  103234:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103237:	8b 40 04             	mov    0x4(%eax),%eax
  10323a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10323d:	0f 94 c0             	sete   %al
  103240:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103243:	85 c0                	test   %eax,%eax
  103245:	74 24                	je     10326b <basic_check+0x44c>
  103247:	c7 44 24 0c 60 68 10 	movl   $0x106860,0xc(%esp)
  10324e:	00 
  10324f:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103256:	00 
  103257:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  10325e:	00 
  10325f:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103266:	e8 64 da ff ff       	call   100ccf <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10326b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103272:	e8 52 0a 00 00       	call   103cc9 <alloc_pages>
  103277:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10327a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10327d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103280:	74 24                	je     1032a6 <basic_check+0x487>
  103282:	c7 44 24 0c 78 68 10 	movl   $0x106878,0xc(%esp)
  103289:	00 
  10328a:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103291:	00 
  103292:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  103299:	00 
  10329a:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1032a1:	e8 29 da ff ff       	call   100ccf <__panic>
    assert(alloc_page() == NULL);
  1032a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032ad:	e8 17 0a 00 00       	call   103cc9 <alloc_pages>
  1032b2:	85 c0                	test   %eax,%eax
  1032b4:	74 24                	je     1032da <basic_check+0x4bb>
  1032b6:	c7 44 24 0c 3e 68 10 	movl   $0x10683e,0xc(%esp)
  1032bd:	00 
  1032be:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1032c5:	00 
  1032c6:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
  1032cd:	00 
  1032ce:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1032d5:	e8 f5 d9 ff ff       	call   100ccf <__panic>

    assert(nr_free == 0);
  1032da:	a1 58 89 11 00       	mov    0x118958,%eax
  1032df:	85 c0                	test   %eax,%eax
  1032e1:	74 24                	je     103307 <basic_check+0x4e8>
  1032e3:	c7 44 24 0c 91 68 10 	movl   $0x106891,0xc(%esp)
  1032ea:	00 
  1032eb:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1032f2:	00 
  1032f3:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  1032fa:	00 
  1032fb:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103302:	e8 c8 d9 ff ff       	call   100ccf <__panic>
    free_list = free_list_store;
  103307:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10330a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10330d:	a3 50 89 11 00       	mov    %eax,0x118950
  103312:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  103318:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10331b:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  103320:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103327:	00 
  103328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10332b:	89 04 24             	mov    %eax,(%esp)
  10332e:	e8 ce 09 00 00       	call   103d01 <free_pages>
    free_page(p1);
  103333:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10333a:	00 
  10333b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10333e:	89 04 24             	mov    %eax,(%esp)
  103341:	e8 bb 09 00 00       	call   103d01 <free_pages>
    free_page(p2);
  103346:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10334d:	00 
  10334e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103351:	89 04 24             	mov    %eax,(%esp)
  103354:	e8 a8 09 00 00       	call   103d01 <free_pages>
}
  103359:	c9                   	leave  
  10335a:	c3                   	ret    

0010335b <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10335b:	55                   	push   %ebp
  10335c:	89 e5                	mov    %esp,%ebp
  10335e:	53                   	push   %ebx
  10335f:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103365:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10336c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103373:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10337a:	eb 6b                	jmp    1033e7 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  10337c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10337f:	83 e8 0c             	sub    $0xc,%eax
  103382:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103385:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103388:	83 c0 04             	add    $0x4,%eax
  10338b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103392:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103395:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103398:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10339b:	0f a3 10             	bt     %edx,(%eax)
  10339e:	19 c0                	sbb    %eax,%eax
  1033a0:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1033a3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1033a7:	0f 95 c0             	setne  %al
  1033aa:	0f b6 c0             	movzbl %al,%eax
  1033ad:	85 c0                	test   %eax,%eax
  1033af:	75 24                	jne    1033d5 <default_check+0x7a>
  1033b1:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  1033b8:	00 
  1033b9:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1033c0:	00 
  1033c1:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  1033c8:	00 
  1033c9:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1033d0:	e8 fa d8 ff ff       	call   100ccf <__panic>
        count ++, total += p->property;
  1033d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033dc:	8b 50 08             	mov    0x8(%eax),%edx
  1033df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033e2:	01 d0                	add    %edx,%eax
  1033e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1033ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1033f0:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1033f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033f6:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1033fd:	0f 85 79 ff ff ff    	jne    10337c <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  103403:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103406:	e8 28 09 00 00       	call   103d33 <nr_free_pages>
  10340b:	39 c3                	cmp    %eax,%ebx
  10340d:	74 24                	je     103433 <default_check+0xd8>
  10340f:	c7 44 24 0c ae 68 10 	movl   $0x1068ae,0xc(%esp)
  103416:	00 
  103417:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10341e:	00 
  10341f:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  103426:	00 
  103427:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  10342e:	e8 9c d8 ff ff       	call   100ccf <__panic>

    basic_check();
  103433:	e8 e7 f9 ff ff       	call   102e1f <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103438:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10343f:	e8 85 08 00 00       	call   103cc9 <alloc_pages>
  103444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103447:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10344b:	75 24                	jne    103471 <default_check+0x116>
  10344d:	c7 44 24 0c c7 68 10 	movl   $0x1068c7,0xc(%esp)
  103454:	00 
  103455:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10345c:	00 
  10345d:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  103464:	00 
  103465:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  10346c:	e8 5e d8 ff ff       	call   100ccf <__panic>
    assert(!PageProperty(p0));
  103471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103474:	83 c0 04             	add    $0x4,%eax
  103477:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10347e:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103481:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103484:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103487:	0f a3 10             	bt     %edx,(%eax)
  10348a:	19 c0                	sbb    %eax,%eax
  10348c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10348f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103493:	0f 95 c0             	setne  %al
  103496:	0f b6 c0             	movzbl %al,%eax
  103499:	85 c0                	test   %eax,%eax
  10349b:	74 24                	je     1034c1 <default_check+0x166>
  10349d:	c7 44 24 0c d2 68 10 	movl   $0x1068d2,0xc(%esp)
  1034a4:	00 
  1034a5:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1034ac:	00 
  1034ad:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  1034b4:	00 
  1034b5:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1034bc:	e8 0e d8 ff ff       	call   100ccf <__panic>

    list_entry_t free_list_store = free_list;
  1034c1:	a1 50 89 11 00       	mov    0x118950,%eax
  1034c6:	8b 15 54 89 11 00    	mov    0x118954,%edx
  1034cc:	89 45 80             	mov    %eax,-0x80(%ebp)
  1034cf:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1034d2:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1034d9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034dc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1034df:	89 50 04             	mov    %edx,0x4(%eax)
  1034e2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034e5:	8b 50 04             	mov    0x4(%eax),%edx
  1034e8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034eb:	89 10                	mov    %edx,(%eax)
  1034ed:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1034f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1034f7:	8b 40 04             	mov    0x4(%eax),%eax
  1034fa:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1034fd:	0f 94 c0             	sete   %al
  103500:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103503:	85 c0                	test   %eax,%eax
  103505:	75 24                	jne    10352b <default_check+0x1d0>
  103507:	c7 44 24 0c 27 68 10 	movl   $0x106827,0xc(%esp)
  10350e:	00 
  10350f:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103516:	00 
  103517:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  10351e:	00 
  10351f:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103526:	e8 a4 d7 ff ff       	call   100ccf <__panic>
    assert(alloc_page() == NULL);
  10352b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103532:	e8 92 07 00 00       	call   103cc9 <alloc_pages>
  103537:	85 c0                	test   %eax,%eax
  103539:	74 24                	je     10355f <default_check+0x204>
  10353b:	c7 44 24 0c 3e 68 10 	movl   $0x10683e,0xc(%esp)
  103542:	00 
  103543:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10354a:	00 
  10354b:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  103552:	00 
  103553:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  10355a:	e8 70 d7 ff ff       	call   100ccf <__panic>

    unsigned int nr_free_store = nr_free;
  10355f:	a1 58 89 11 00       	mov    0x118958,%eax
  103564:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  103567:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  10356e:	00 00 00 

    free_pages(p0 + 2, 3);
  103571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103574:	83 c0 28             	add    $0x28,%eax
  103577:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10357e:	00 
  10357f:	89 04 24             	mov    %eax,(%esp)
  103582:	e8 7a 07 00 00       	call   103d01 <free_pages>
    assert(alloc_pages(4) == NULL);
  103587:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10358e:	e8 36 07 00 00       	call   103cc9 <alloc_pages>
  103593:	85 c0                	test   %eax,%eax
  103595:	74 24                	je     1035bb <default_check+0x260>
  103597:	c7 44 24 0c e4 68 10 	movl   $0x1068e4,0xc(%esp)
  10359e:	00 
  10359f:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1035a6:	00 
  1035a7:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  1035ae:	00 
  1035af:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1035b6:	e8 14 d7 ff ff       	call   100ccf <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1035bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035be:	83 c0 28             	add    $0x28,%eax
  1035c1:	83 c0 04             	add    $0x4,%eax
  1035c4:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1035cb:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035ce:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1035d1:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1035d4:	0f a3 10             	bt     %edx,(%eax)
  1035d7:	19 c0                	sbb    %eax,%eax
  1035d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1035dc:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1035e0:	0f 95 c0             	setne  %al
  1035e3:	0f b6 c0             	movzbl %al,%eax
  1035e6:	85 c0                	test   %eax,%eax
  1035e8:	74 0e                	je     1035f8 <default_check+0x29d>
  1035ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035ed:	83 c0 28             	add    $0x28,%eax
  1035f0:	8b 40 08             	mov    0x8(%eax),%eax
  1035f3:	83 f8 03             	cmp    $0x3,%eax
  1035f6:	74 24                	je     10361c <default_check+0x2c1>
  1035f8:	c7 44 24 0c fc 68 10 	movl   $0x1068fc,0xc(%esp)
  1035ff:	00 
  103600:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103607:	00 
  103608:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  10360f:	00 
  103610:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103617:	e8 b3 d6 ff ff       	call   100ccf <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10361c:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103623:	e8 a1 06 00 00       	call   103cc9 <alloc_pages>
  103628:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10362b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10362f:	75 24                	jne    103655 <default_check+0x2fa>
  103631:	c7 44 24 0c 28 69 10 	movl   $0x106928,0xc(%esp)
  103638:	00 
  103639:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103640:	00 
  103641:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  103648:	00 
  103649:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103650:	e8 7a d6 ff ff       	call   100ccf <__panic>
    assert(alloc_page() == NULL);
  103655:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10365c:	e8 68 06 00 00       	call   103cc9 <alloc_pages>
  103661:	85 c0                	test   %eax,%eax
  103663:	74 24                	je     103689 <default_check+0x32e>
  103665:	c7 44 24 0c 3e 68 10 	movl   $0x10683e,0xc(%esp)
  10366c:	00 
  10366d:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103674:	00 
  103675:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  10367c:	00 
  10367d:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103684:	e8 46 d6 ff ff       	call   100ccf <__panic>
    assert(p0 + 2 == p1);
  103689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10368c:	83 c0 28             	add    $0x28,%eax
  10368f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103692:	74 24                	je     1036b8 <default_check+0x35d>
  103694:	c7 44 24 0c 46 69 10 	movl   $0x106946,0xc(%esp)
  10369b:	00 
  10369c:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1036a3:	00 
  1036a4:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  1036ab:	00 
  1036ac:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1036b3:	e8 17 d6 ff ff       	call   100ccf <__panic>

    p2 = p0 + 1;
  1036b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036bb:	83 c0 14             	add    $0x14,%eax
  1036be:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1036c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036c8:	00 
  1036c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036cc:	89 04 24             	mov    %eax,(%esp)
  1036cf:	e8 2d 06 00 00       	call   103d01 <free_pages>
    free_pages(p1, 3);
  1036d4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1036db:	00 
  1036dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036df:	89 04 24             	mov    %eax,(%esp)
  1036e2:	e8 1a 06 00 00       	call   103d01 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1036e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036ea:	83 c0 04             	add    $0x4,%eax
  1036ed:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1036f4:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036f7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1036fa:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1036fd:	0f a3 10             	bt     %edx,(%eax)
  103700:	19 c0                	sbb    %eax,%eax
  103702:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103705:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103709:	0f 95 c0             	setne  %al
  10370c:	0f b6 c0             	movzbl %al,%eax
  10370f:	85 c0                	test   %eax,%eax
  103711:	74 0b                	je     10371e <default_check+0x3c3>
  103713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103716:	8b 40 08             	mov    0x8(%eax),%eax
  103719:	83 f8 01             	cmp    $0x1,%eax
  10371c:	74 24                	je     103742 <default_check+0x3e7>
  10371e:	c7 44 24 0c 54 69 10 	movl   $0x106954,0xc(%esp)
  103725:	00 
  103726:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10372d:	00 
  10372e:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  103735:	00 
  103736:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  10373d:	e8 8d d5 ff ff       	call   100ccf <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103742:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103745:	83 c0 04             	add    $0x4,%eax
  103748:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10374f:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103752:	8b 45 90             	mov    -0x70(%ebp),%eax
  103755:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103758:	0f a3 10             	bt     %edx,(%eax)
  10375b:	19 c0                	sbb    %eax,%eax
  10375d:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103760:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103764:	0f 95 c0             	setne  %al
  103767:	0f b6 c0             	movzbl %al,%eax
  10376a:	85 c0                	test   %eax,%eax
  10376c:	74 0b                	je     103779 <default_check+0x41e>
  10376e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103771:	8b 40 08             	mov    0x8(%eax),%eax
  103774:	83 f8 03             	cmp    $0x3,%eax
  103777:	74 24                	je     10379d <default_check+0x442>
  103779:	c7 44 24 0c 7c 69 10 	movl   $0x10697c,0xc(%esp)
  103780:	00 
  103781:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103788:	00 
  103789:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  103790:	00 
  103791:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103798:	e8 32 d5 ff ff       	call   100ccf <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  10379d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037a4:	e8 20 05 00 00       	call   103cc9 <alloc_pages>
  1037a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037af:	83 e8 14             	sub    $0x14,%eax
  1037b2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037b5:	74 24                	je     1037db <default_check+0x480>
  1037b7:	c7 44 24 0c a2 69 10 	movl   $0x1069a2,0xc(%esp)
  1037be:	00 
  1037bf:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1037c6:	00 
  1037c7:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  1037ce:	00 
  1037cf:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1037d6:	e8 f4 d4 ff ff       	call   100ccf <__panic>
    free_page(p0);
  1037db:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037e2:	00 
  1037e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037e6:	89 04 24             	mov    %eax,(%esp)
  1037e9:	e8 13 05 00 00       	call   103d01 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1037ee:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1037f5:	e8 cf 04 00 00       	call   103cc9 <alloc_pages>
  1037fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103800:	83 c0 14             	add    $0x14,%eax
  103803:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103806:	74 24                	je     10382c <default_check+0x4d1>
  103808:	c7 44 24 0c c0 69 10 	movl   $0x1069c0,0xc(%esp)
  10380f:	00 
  103810:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103817:	00 
  103818:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  10381f:	00 
  103820:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103827:	e8 a3 d4 ff ff       	call   100ccf <__panic>

    free_pages(p0, 2);
  10382c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103833:	00 
  103834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103837:	89 04 24             	mov    %eax,(%esp)
  10383a:	e8 c2 04 00 00       	call   103d01 <free_pages>
    free_page(p2);
  10383f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103846:	00 
  103847:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10384a:	89 04 24             	mov    %eax,(%esp)
  10384d:	e8 af 04 00 00       	call   103d01 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103852:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103859:	e8 6b 04 00 00       	call   103cc9 <alloc_pages>
  10385e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103865:	75 24                	jne    10388b <default_check+0x530>
  103867:	c7 44 24 0c e0 69 10 	movl   $0x1069e0,0xc(%esp)
  10386e:	00 
  10386f:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103876:	00 
  103877:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  10387e:	00 
  10387f:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  103886:	e8 44 d4 ff ff       	call   100ccf <__panic>
    assert(alloc_page() == NULL);
  10388b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103892:	e8 32 04 00 00       	call   103cc9 <alloc_pages>
  103897:	85 c0                	test   %eax,%eax
  103899:	74 24                	je     1038bf <default_check+0x564>
  10389b:	c7 44 24 0c 3e 68 10 	movl   $0x10683e,0xc(%esp)
  1038a2:	00 
  1038a3:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1038aa:	00 
  1038ab:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  1038b2:	00 
  1038b3:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1038ba:	e8 10 d4 ff ff       	call   100ccf <__panic>

    assert(nr_free == 0);
  1038bf:	a1 58 89 11 00       	mov    0x118958,%eax
  1038c4:	85 c0                	test   %eax,%eax
  1038c6:	74 24                	je     1038ec <default_check+0x591>
  1038c8:	c7 44 24 0c 91 68 10 	movl   $0x106891,0xc(%esp)
  1038cf:	00 
  1038d0:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  1038d7:	00 
  1038d8:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  1038df:	00 
  1038e0:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1038e7:	e8 e3 d3 ff ff       	call   100ccf <__panic>
    nr_free = nr_free_store;
  1038ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038ef:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  1038f4:	8b 45 80             	mov    -0x80(%ebp),%eax
  1038f7:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1038fa:	a3 50 89 11 00       	mov    %eax,0x118950
  1038ff:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  103905:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  10390c:	00 
  10390d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103910:	89 04 24             	mov    %eax,(%esp)
  103913:	e8 e9 03 00 00       	call   103d01 <free_pages>

    le = &free_list;
  103918:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10391f:	eb 1d                	jmp    10393e <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103924:	83 e8 0c             	sub    $0xc,%eax
  103927:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  10392a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10392e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103931:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103934:	8b 40 08             	mov    0x8(%eax),%eax
  103937:	29 c2                	sub    %eax,%edx
  103939:	89 d0                	mov    %edx,%eax
  10393b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10393e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103941:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103944:	8b 45 88             	mov    -0x78(%ebp),%eax
  103947:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10394a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10394d:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103954:	75 cb                	jne    103921 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103956:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10395a:	74 24                	je     103980 <default_check+0x625>
  10395c:	c7 44 24 0c fe 69 10 	movl   $0x1069fe,0xc(%esp)
  103963:	00 
  103964:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  10396b:	00 
  10396c:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  103973:	00 
  103974:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  10397b:	e8 4f d3 ff ff       	call   100ccf <__panic>
    assert(total == 0);
  103980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103984:	74 24                	je     1039aa <default_check+0x64f>
  103986:	c7 44 24 0c 09 6a 10 	movl   $0x106a09,0xc(%esp)
  10398d:	00 
  10398e:	c7 44 24 08 b6 66 10 	movl   $0x1066b6,0x8(%esp)
  103995:	00 
  103996:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  10399d:	00 
  10399e:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  1039a5:	e8 25 d3 ff ff       	call   100ccf <__panic>
}
  1039aa:	81 c4 94 00 00 00    	add    $0x94,%esp
  1039b0:	5b                   	pop    %ebx
  1039b1:	5d                   	pop    %ebp
  1039b2:	c3                   	ret    

001039b3 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1039b3:	55                   	push   %ebp
  1039b4:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1039b6:	8b 55 08             	mov    0x8(%ebp),%edx
  1039b9:	a1 64 89 11 00       	mov    0x118964,%eax
  1039be:	29 c2                	sub    %eax,%edx
  1039c0:	89 d0                	mov    %edx,%eax
  1039c2:	c1 f8 02             	sar    $0x2,%eax
  1039c5:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1039cb:	5d                   	pop    %ebp
  1039cc:	c3                   	ret    

001039cd <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1039cd:	55                   	push   %ebp
  1039ce:	89 e5                	mov    %esp,%ebp
  1039d0:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1039d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1039d6:	89 04 24             	mov    %eax,(%esp)
  1039d9:	e8 d5 ff ff ff       	call   1039b3 <page2ppn>
  1039de:	c1 e0 0c             	shl    $0xc,%eax
}
  1039e1:	c9                   	leave  
  1039e2:	c3                   	ret    

001039e3 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1039e3:	55                   	push   %ebp
  1039e4:	89 e5                	mov    %esp,%ebp
  1039e6:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  1039e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1039ec:	c1 e8 0c             	shr    $0xc,%eax
  1039ef:	89 c2                	mov    %eax,%edx
  1039f1:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1039f6:	39 c2                	cmp    %eax,%edx
  1039f8:	72 1c                	jb     103a16 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  1039fa:	c7 44 24 08 44 6a 10 	movl   $0x106a44,0x8(%esp)
  103a01:	00 
  103a02:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103a09:	00 
  103a0a:	c7 04 24 63 6a 10 00 	movl   $0x106a63,(%esp)
  103a11:	e8 b9 d2 ff ff       	call   100ccf <__panic>
    }
    return &pages[PPN(pa)];
  103a16:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  103a1f:	c1 e8 0c             	shr    $0xc,%eax
  103a22:	89 c2                	mov    %eax,%edx
  103a24:	89 d0                	mov    %edx,%eax
  103a26:	c1 e0 02             	shl    $0x2,%eax
  103a29:	01 d0                	add    %edx,%eax
  103a2b:	c1 e0 02             	shl    $0x2,%eax
  103a2e:	01 c8                	add    %ecx,%eax
}
  103a30:	c9                   	leave  
  103a31:	c3                   	ret    

00103a32 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a32:	55                   	push   %ebp
  103a33:	89 e5                	mov    %esp,%ebp
  103a35:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a38:	8b 45 08             	mov    0x8(%ebp),%eax
  103a3b:	89 04 24             	mov    %eax,(%esp)
  103a3e:	e8 8a ff ff ff       	call   1039cd <page2pa>
  103a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a49:	c1 e8 0c             	shr    $0xc,%eax
  103a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a4f:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a54:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a57:	72 23                	jb     103a7c <page2kva+0x4a>
  103a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a5c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103a60:	c7 44 24 08 74 6a 10 	movl   $0x106a74,0x8(%esp)
  103a67:	00 
  103a68:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103a6f:	00 
  103a70:	c7 04 24 63 6a 10 00 	movl   $0x106a63,(%esp)
  103a77:	e8 53 d2 ff ff       	call   100ccf <__panic>
  103a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a7f:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103a84:	c9                   	leave  
  103a85:	c3                   	ret    

00103a86 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103a86:	55                   	push   %ebp
  103a87:	89 e5                	mov    %esp,%ebp
  103a89:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  103a8f:	83 e0 01             	and    $0x1,%eax
  103a92:	85 c0                	test   %eax,%eax
  103a94:	75 1c                	jne    103ab2 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103a96:	c7 44 24 08 98 6a 10 	movl   $0x106a98,0x8(%esp)
  103a9d:	00 
  103a9e:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103aa5:	00 
  103aa6:	c7 04 24 63 6a 10 00 	movl   $0x106a63,(%esp)
  103aad:	e8 1d d2 ff ff       	call   100ccf <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  103ab5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103aba:	89 04 24             	mov    %eax,(%esp)
  103abd:	e8 21 ff ff ff       	call   1039e3 <pa2page>
}
  103ac2:	c9                   	leave  
  103ac3:	c3                   	ret    

00103ac4 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103ac4:	55                   	push   %ebp
  103ac5:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  103aca:	8b 00                	mov    (%eax),%eax
}
  103acc:	5d                   	pop    %ebp
  103acd:	c3                   	ret    

00103ace <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103ace:	55                   	push   %ebp
  103acf:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  103ad7:	89 10                	mov    %edx,(%eax)
}
  103ad9:	5d                   	pop    %ebp
  103ada:	c3                   	ret    

00103adb <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103adb:	55                   	push   %ebp
  103adc:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103ade:	8b 45 08             	mov    0x8(%ebp),%eax
  103ae1:	8b 00                	mov    (%eax),%eax
  103ae3:	8d 50 01             	lea    0x1(%eax),%edx
  103ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  103ae9:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  103aee:	8b 00                	mov    (%eax),%eax
}
  103af0:	5d                   	pop    %ebp
  103af1:	c3                   	ret    

00103af2 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103af2:	55                   	push   %ebp
  103af3:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103af5:	8b 45 08             	mov    0x8(%ebp),%eax
  103af8:	8b 00                	mov    (%eax),%eax
  103afa:	8d 50 ff             	lea    -0x1(%eax),%edx
  103afd:	8b 45 08             	mov    0x8(%ebp),%eax
  103b00:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b02:	8b 45 08             	mov    0x8(%ebp),%eax
  103b05:	8b 00                	mov    (%eax),%eax
}
  103b07:	5d                   	pop    %ebp
  103b08:	c3                   	ret    

00103b09 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103b09:	55                   	push   %ebp
  103b0a:	89 e5                	mov    %esp,%ebp
  103b0c:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b0f:	9c                   	pushf  
  103b10:	58                   	pop    %eax
  103b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b17:	25 00 02 00 00       	and    $0x200,%eax
  103b1c:	85 c0                	test   %eax,%eax
  103b1e:	74 0c                	je     103b2c <__intr_save+0x23>
        intr_disable();
  103b20:	e8 8d db ff ff       	call   1016b2 <intr_disable>
        return 1;
  103b25:	b8 01 00 00 00       	mov    $0x1,%eax
  103b2a:	eb 05                	jmp    103b31 <__intr_save+0x28>
    }
    return 0;
  103b2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b31:	c9                   	leave  
  103b32:	c3                   	ret    

00103b33 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b33:	55                   	push   %ebp
  103b34:	89 e5                	mov    %esp,%ebp
  103b36:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b3d:	74 05                	je     103b44 <__intr_restore+0x11>
        intr_enable();
  103b3f:	e8 68 db ff ff       	call   1016ac <intr_enable>
    }
}
  103b44:	c9                   	leave  
  103b45:	c3                   	ret    

00103b46 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103b46:	55                   	push   %ebp
  103b47:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103b49:	8b 45 08             	mov    0x8(%ebp),%eax
  103b4c:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103b4f:	b8 23 00 00 00       	mov    $0x23,%eax
  103b54:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103b56:	b8 23 00 00 00       	mov    $0x23,%eax
  103b5b:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103b5d:	b8 10 00 00 00       	mov    $0x10,%eax
  103b62:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103b64:	b8 10 00 00 00       	mov    $0x10,%eax
  103b69:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103b6b:	b8 10 00 00 00       	mov    $0x10,%eax
  103b70:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103b72:	ea 79 3b 10 00 08 00 	ljmp   $0x8,$0x103b79
}
  103b79:	5d                   	pop    %ebp
  103b7a:	c3                   	ret    

00103b7b <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103b7b:	55                   	push   %ebp
  103b7c:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  103b81:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103b86:	5d                   	pop    %ebp
  103b87:	c3                   	ret    

00103b88 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103b88:	55                   	push   %ebp
  103b89:	89 e5                	mov    %esp,%ebp
  103b8b:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103b8e:	b8 00 70 11 00       	mov    $0x117000,%eax
  103b93:	89 04 24             	mov    %eax,(%esp)
  103b96:	e8 e0 ff ff ff       	call   103b7b <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103b9b:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103ba2:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103ba4:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103bab:	68 00 
  103bad:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103bb2:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103bb8:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103bbd:	c1 e8 10             	shr    $0x10,%eax
  103bc0:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103bc5:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bcc:	83 e0 f0             	and    $0xfffffff0,%eax
  103bcf:	83 c8 09             	or     $0x9,%eax
  103bd2:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bd7:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bde:	83 e0 ef             	and    $0xffffffef,%eax
  103be1:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103be6:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bed:	83 e0 9f             	and    $0xffffff9f,%eax
  103bf0:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bf5:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bfc:	83 c8 80             	or     $0xffffff80,%eax
  103bff:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c04:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c0b:	83 e0 f0             	and    $0xfffffff0,%eax
  103c0e:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c13:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c1a:	83 e0 ef             	and    $0xffffffef,%eax
  103c1d:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c22:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c29:	83 e0 df             	and    $0xffffffdf,%eax
  103c2c:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c31:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c38:	83 c8 40             	or     $0x40,%eax
  103c3b:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c40:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c47:	83 e0 7f             	and    $0x7f,%eax
  103c4a:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c4f:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c54:	c1 e8 18             	shr    $0x18,%eax
  103c57:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103c5c:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103c63:	e8 de fe ff ff       	call   103b46 <lgdt>
  103c68:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103c6e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103c72:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103c75:	c9                   	leave  
  103c76:	c3                   	ret    

00103c77 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103c77:	55                   	push   %ebp
  103c78:	89 e5                	mov    %esp,%ebp
  103c7a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103c7d:	c7 05 5c 89 11 00 28 	movl   $0x106a28,0x11895c
  103c84:	6a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103c87:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c8c:	8b 00                	mov    (%eax),%eax
  103c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103c92:	c7 04 24 c4 6a 10 00 	movl   $0x106ac4,(%esp)
  103c99:	e8 9e c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103c9e:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103ca3:	8b 40 04             	mov    0x4(%eax),%eax
  103ca6:	ff d0                	call   *%eax
}
  103ca8:	c9                   	leave  
  103ca9:	c3                   	ret    

00103caa <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103caa:	55                   	push   %ebp
  103cab:	89 e5                	mov    %esp,%ebp
  103cad:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103cb0:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cb5:	8b 40 08             	mov    0x8(%eax),%eax
  103cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  103cbb:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cbf:	8b 55 08             	mov    0x8(%ebp),%edx
  103cc2:	89 14 24             	mov    %edx,(%esp)
  103cc5:	ff d0                	call   *%eax
}
  103cc7:	c9                   	leave  
  103cc8:	c3                   	ret    

00103cc9 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103cc9:	55                   	push   %ebp
  103cca:	89 e5                	mov    %esp,%ebp
  103ccc:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103ccf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103cd6:	e8 2e fe ff ff       	call   103b09 <__intr_save>
  103cdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103cde:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103ce3:	8b 40 0c             	mov    0xc(%eax),%eax
  103ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  103ce9:	89 14 24             	mov    %edx,(%esp)
  103cec:	ff d0                	call   *%eax
  103cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103cf4:	89 04 24             	mov    %eax,(%esp)
  103cf7:	e8 37 fe ff ff       	call   103b33 <__intr_restore>
    return page;
  103cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103cff:	c9                   	leave  
  103d00:	c3                   	ret    

00103d01 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103d01:	55                   	push   %ebp
  103d02:	89 e5                	mov    %esp,%ebp
  103d04:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103d07:	e8 fd fd ff ff       	call   103b09 <__intr_save>
  103d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d0f:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d14:	8b 40 10             	mov    0x10(%eax),%eax
  103d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d1a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  103d21:	89 14 24             	mov    %edx,(%esp)
  103d24:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d29:	89 04 24             	mov    %eax,(%esp)
  103d2c:	e8 02 fe ff ff       	call   103b33 <__intr_restore>
}
  103d31:	c9                   	leave  
  103d32:	c3                   	ret    

00103d33 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d33:	55                   	push   %ebp
  103d34:	89 e5                	mov    %esp,%ebp
  103d36:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d39:	e8 cb fd ff ff       	call   103b09 <__intr_save>
  103d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103d41:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d46:	8b 40 14             	mov    0x14(%eax),%eax
  103d49:	ff d0                	call   *%eax
  103d4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d51:	89 04 24             	mov    %eax,(%esp)
  103d54:	e8 da fd ff ff       	call   103b33 <__intr_restore>
    return ret;
  103d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103d5c:	c9                   	leave  
  103d5d:	c3                   	ret    

00103d5e <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103d5e:	55                   	push   %ebp
  103d5f:	89 e5                	mov    %esp,%ebp
  103d61:	57                   	push   %edi
  103d62:	56                   	push   %esi
  103d63:	53                   	push   %ebx
  103d64:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103d6a:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103d71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103d78:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103d7f:	c7 04 24 db 6a 10 00 	movl   $0x106adb,(%esp)
  103d86:	e8 b1 c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103d8b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103d92:	e9 15 01 00 00       	jmp    103eac <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103d97:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d9d:	89 d0                	mov    %edx,%eax
  103d9f:	c1 e0 02             	shl    $0x2,%eax
  103da2:	01 d0                	add    %edx,%eax
  103da4:	c1 e0 02             	shl    $0x2,%eax
  103da7:	01 c8                	add    %ecx,%eax
  103da9:	8b 50 08             	mov    0x8(%eax),%edx
  103dac:	8b 40 04             	mov    0x4(%eax),%eax
  103daf:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103db2:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103db5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103db8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dbb:	89 d0                	mov    %edx,%eax
  103dbd:	c1 e0 02             	shl    $0x2,%eax
  103dc0:	01 d0                	add    %edx,%eax
  103dc2:	c1 e0 02             	shl    $0x2,%eax
  103dc5:	01 c8                	add    %ecx,%eax
  103dc7:	8b 48 0c             	mov    0xc(%eax),%ecx
  103dca:	8b 58 10             	mov    0x10(%eax),%ebx
  103dcd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103dd0:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103dd3:	01 c8                	add    %ecx,%eax
  103dd5:	11 da                	adc    %ebx,%edx
  103dd7:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103dda:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103ddd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103de0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103de3:	89 d0                	mov    %edx,%eax
  103de5:	c1 e0 02             	shl    $0x2,%eax
  103de8:	01 d0                	add    %edx,%eax
  103dea:	c1 e0 02             	shl    $0x2,%eax
  103ded:	01 c8                	add    %ecx,%eax
  103def:	83 c0 14             	add    $0x14,%eax
  103df2:	8b 00                	mov    (%eax),%eax
  103df4:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103dfa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103dfd:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e00:	83 c0 ff             	add    $0xffffffff,%eax
  103e03:	83 d2 ff             	adc    $0xffffffff,%edx
  103e06:	89 c6                	mov    %eax,%esi
  103e08:	89 d7                	mov    %edx,%edi
  103e0a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e10:	89 d0                	mov    %edx,%eax
  103e12:	c1 e0 02             	shl    $0x2,%eax
  103e15:	01 d0                	add    %edx,%eax
  103e17:	c1 e0 02             	shl    $0x2,%eax
  103e1a:	01 c8                	add    %ecx,%eax
  103e1c:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e1f:	8b 58 10             	mov    0x10(%eax),%ebx
  103e22:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e28:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e2c:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e30:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e34:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e37:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e3e:	89 54 24 10          	mov    %edx,0x10(%esp)
  103e42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e46:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e4a:	c7 04 24 e8 6a 10 00 	movl   $0x106ae8,(%esp)
  103e51:	e8 e6 c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103e56:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e59:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e5c:	89 d0                	mov    %edx,%eax
  103e5e:	c1 e0 02             	shl    $0x2,%eax
  103e61:	01 d0                	add    %edx,%eax
  103e63:	c1 e0 02             	shl    $0x2,%eax
  103e66:	01 c8                	add    %ecx,%eax
  103e68:	83 c0 14             	add    $0x14,%eax
  103e6b:	8b 00                	mov    (%eax),%eax
  103e6d:	83 f8 01             	cmp    $0x1,%eax
  103e70:	75 36                	jne    103ea8 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103e72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e78:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e7b:	77 2b                	ja     103ea8 <page_init+0x14a>
  103e7d:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e80:	72 05                	jb     103e87 <page_init+0x129>
  103e82:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103e85:	73 21                	jae    103ea8 <page_init+0x14a>
  103e87:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e8b:	77 1b                	ja     103ea8 <page_init+0x14a>
  103e8d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e91:	72 09                	jb     103e9c <page_init+0x13e>
  103e93:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103e9a:	77 0c                	ja     103ea8 <page_init+0x14a>
                maxpa = end;
  103e9c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e9f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103ea2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103ea5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103ea8:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103eac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103eaf:	8b 00                	mov    (%eax),%eax
  103eb1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103eb4:	0f 8f dd fe ff ff    	jg     103d97 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103eba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103ebe:	72 1d                	jb     103edd <page_init+0x17f>
  103ec0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103ec4:	77 09                	ja     103ecf <page_init+0x171>
  103ec6:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103ecd:	76 0e                	jbe    103edd <page_init+0x17f>
        maxpa = KMEMSIZE;
  103ecf:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103ed6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ee0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ee3:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103ee7:	c1 ea 0c             	shr    $0xc,%edx
  103eea:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103eef:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103ef6:	b8 68 89 11 00       	mov    $0x118968,%eax
  103efb:	8d 50 ff             	lea    -0x1(%eax),%edx
  103efe:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103f01:	01 d0                	add    %edx,%eax
  103f03:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103f06:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103f09:	ba 00 00 00 00       	mov    $0x0,%edx
  103f0e:	f7 75 ac             	divl   -0x54(%ebp)
  103f11:	89 d0                	mov    %edx,%eax
  103f13:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f16:	29 c2                	sub    %eax,%edx
  103f18:	89 d0                	mov    %edx,%eax
  103f1a:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103f1f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f26:	eb 2f                	jmp    103f57 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f28:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103f2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f31:	89 d0                	mov    %edx,%eax
  103f33:	c1 e0 02             	shl    $0x2,%eax
  103f36:	01 d0                	add    %edx,%eax
  103f38:	c1 e0 02             	shl    $0x2,%eax
  103f3b:	01 c8                	add    %ecx,%eax
  103f3d:	83 c0 04             	add    $0x4,%eax
  103f40:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103f47:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f4a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103f4d:	8b 55 90             	mov    -0x70(%ebp),%edx
  103f50:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103f53:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f57:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f5a:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103f5f:	39 c2                	cmp    %eax,%edx
  103f61:	72 c5                	jb     103f28 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103f63:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103f69:	89 d0                	mov    %edx,%eax
  103f6b:	c1 e0 02             	shl    $0x2,%eax
  103f6e:	01 d0                	add    %edx,%eax
  103f70:	c1 e0 02             	shl    $0x2,%eax
  103f73:	89 c2                	mov    %eax,%edx
  103f75:	a1 64 89 11 00       	mov    0x118964,%eax
  103f7a:	01 d0                	add    %edx,%eax
  103f7c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103f7f:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103f86:	77 23                	ja     103fab <page_init+0x24d>
  103f88:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f8f:	c7 44 24 08 18 6b 10 	movl   $0x106b18,0x8(%esp)
  103f96:	00 
  103f97:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103f9e:	00 
  103f9f:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  103fa6:	e8 24 cd ff ff       	call   100ccf <__panic>
  103fab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fae:	05 00 00 00 40       	add    $0x40000000,%eax
  103fb3:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103fb6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fbd:	e9 74 01 00 00       	jmp    104136 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103fc2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fc8:	89 d0                	mov    %edx,%eax
  103fca:	c1 e0 02             	shl    $0x2,%eax
  103fcd:	01 d0                	add    %edx,%eax
  103fcf:	c1 e0 02             	shl    $0x2,%eax
  103fd2:	01 c8                	add    %ecx,%eax
  103fd4:	8b 50 08             	mov    0x8(%eax),%edx
  103fd7:	8b 40 04             	mov    0x4(%eax),%eax
  103fda:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103fdd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103fe0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fe3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fe6:	89 d0                	mov    %edx,%eax
  103fe8:	c1 e0 02             	shl    $0x2,%eax
  103feb:	01 d0                	add    %edx,%eax
  103fed:	c1 e0 02             	shl    $0x2,%eax
  103ff0:	01 c8                	add    %ecx,%eax
  103ff2:	8b 48 0c             	mov    0xc(%eax),%ecx
  103ff5:	8b 58 10             	mov    0x10(%eax),%ebx
  103ff8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103ffb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103ffe:	01 c8                	add    %ecx,%eax
  104000:	11 da                	adc    %ebx,%edx
  104002:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104005:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104008:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10400b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10400e:	89 d0                	mov    %edx,%eax
  104010:	c1 e0 02             	shl    $0x2,%eax
  104013:	01 d0                	add    %edx,%eax
  104015:	c1 e0 02             	shl    $0x2,%eax
  104018:	01 c8                	add    %ecx,%eax
  10401a:	83 c0 14             	add    $0x14,%eax
  10401d:	8b 00                	mov    (%eax),%eax
  10401f:	83 f8 01             	cmp    $0x1,%eax
  104022:	0f 85 0a 01 00 00    	jne    104132 <page_init+0x3d4>
            if (begin < freemem) {
  104028:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10402b:	ba 00 00 00 00       	mov    $0x0,%edx
  104030:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104033:	72 17                	jb     10404c <page_init+0x2ee>
  104035:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104038:	77 05                	ja     10403f <page_init+0x2e1>
  10403a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10403d:	76 0d                	jbe    10404c <page_init+0x2ee>
                begin = freemem;
  10403f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104042:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104045:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10404c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104050:	72 1d                	jb     10406f <page_init+0x311>
  104052:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104056:	77 09                	ja     104061 <page_init+0x303>
  104058:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10405f:	76 0e                	jbe    10406f <page_init+0x311>
                end = KMEMSIZE;
  104061:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104068:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10406f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104072:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104075:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104078:	0f 87 b4 00 00 00    	ja     104132 <page_init+0x3d4>
  10407e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104081:	72 09                	jb     10408c <page_init+0x32e>
  104083:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104086:	0f 83 a6 00 00 00    	jae    104132 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  10408c:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104093:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104096:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104099:	01 d0                	add    %edx,%eax
  10409b:	83 e8 01             	sub    $0x1,%eax
  10409e:	89 45 98             	mov    %eax,-0x68(%ebp)
  1040a1:	8b 45 98             	mov    -0x68(%ebp),%eax
  1040a4:	ba 00 00 00 00       	mov    $0x0,%edx
  1040a9:	f7 75 9c             	divl   -0x64(%ebp)
  1040ac:	89 d0                	mov    %edx,%eax
  1040ae:	8b 55 98             	mov    -0x68(%ebp),%edx
  1040b1:	29 c2                	sub    %eax,%edx
  1040b3:	89 d0                	mov    %edx,%eax
  1040b5:	ba 00 00 00 00       	mov    $0x0,%edx
  1040ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040bd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1040c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040c3:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1040c6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1040c9:	ba 00 00 00 00       	mov    $0x0,%edx
  1040ce:	89 c7                	mov    %eax,%edi
  1040d0:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1040d6:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1040d9:	89 d0                	mov    %edx,%eax
  1040db:	83 e0 00             	and    $0x0,%eax
  1040de:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1040e1:	8b 45 80             	mov    -0x80(%ebp),%eax
  1040e4:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1040e7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1040ea:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1040ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040f3:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040f6:	77 3a                	ja     104132 <page_init+0x3d4>
  1040f8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040fb:	72 05                	jb     104102 <page_init+0x3a4>
  1040fd:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104100:	73 30                	jae    104132 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104102:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104105:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  104108:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10410b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10410e:	29 c8                	sub    %ecx,%eax
  104110:	19 da                	sbb    %ebx,%edx
  104112:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104116:	c1 ea 0c             	shr    $0xc,%edx
  104119:	89 c3                	mov    %eax,%ebx
  10411b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10411e:	89 04 24             	mov    %eax,(%esp)
  104121:	e8 bd f8 ff ff       	call   1039e3 <pa2page>
  104126:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10412a:	89 04 24             	mov    %eax,(%esp)
  10412d:	e8 78 fb ff ff       	call   103caa <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  104132:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104136:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104139:	8b 00                	mov    (%eax),%eax
  10413b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10413e:	0f 8f 7e fe ff ff    	jg     103fc2 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104144:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  10414a:	5b                   	pop    %ebx
  10414b:	5e                   	pop    %esi
  10414c:	5f                   	pop    %edi
  10414d:	5d                   	pop    %ebp
  10414e:	c3                   	ret    

0010414f <enable_paging>:

static void
enable_paging(void) {
  10414f:	55                   	push   %ebp
  104150:	89 e5                	mov    %esp,%ebp
  104152:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  104155:	a1 60 89 11 00       	mov    0x118960,%eax
  10415a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  10415d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104160:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  104163:	0f 20 c0             	mov    %cr0,%eax
  104166:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  104169:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  10416c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10416f:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  104176:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  10417a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10417d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  104180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104183:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  104186:	c9                   	leave  
  104187:	c3                   	ret    

00104188 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104188:	55                   	push   %ebp
  104189:	89 e5                	mov    %esp,%ebp
  10418b:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10418e:	8b 45 14             	mov    0x14(%ebp),%eax
  104191:	8b 55 0c             	mov    0xc(%ebp),%edx
  104194:	31 d0                	xor    %edx,%eax
  104196:	25 ff 0f 00 00       	and    $0xfff,%eax
  10419b:	85 c0                	test   %eax,%eax
  10419d:	74 24                	je     1041c3 <boot_map_segment+0x3b>
  10419f:	c7 44 24 0c 4a 6b 10 	movl   $0x106b4a,0xc(%esp)
  1041a6:	00 
  1041a7:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  1041ae:	00 
  1041af:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1041b6:	00 
  1041b7:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  1041be:	e8 0c cb ff ff       	call   100ccf <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1041c3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1041ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041cd:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041d2:	89 c2                	mov    %eax,%edx
  1041d4:	8b 45 10             	mov    0x10(%ebp),%eax
  1041d7:	01 c2                	add    %eax,%edx
  1041d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041dc:	01 d0                	add    %edx,%eax
  1041de:	83 e8 01             	sub    $0x1,%eax
  1041e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1041e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041e7:	ba 00 00 00 00       	mov    $0x0,%edx
  1041ec:	f7 75 f0             	divl   -0x10(%ebp)
  1041ef:	89 d0                	mov    %edx,%eax
  1041f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1041f4:	29 c2                	sub    %eax,%edx
  1041f6:	89 d0                	mov    %edx,%eax
  1041f8:	c1 e8 0c             	shr    $0xc,%eax
  1041fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1041fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  104201:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10420c:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10420f:	8b 45 14             	mov    0x14(%ebp),%eax
  104212:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104215:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104218:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10421d:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104220:	eb 6b                	jmp    10428d <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104222:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104229:	00 
  10422a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10422d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104231:	8b 45 08             	mov    0x8(%ebp),%eax
  104234:	89 04 24             	mov    %eax,(%esp)
  104237:	e8 cc 01 00 00       	call   104408 <get_pte>
  10423c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10423f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104243:	75 24                	jne    104269 <boot_map_segment+0xe1>
  104245:	c7 44 24 0c 76 6b 10 	movl   $0x106b76,0xc(%esp)
  10424c:	00 
  10424d:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104254:	00 
  104255:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  10425c:	00 
  10425d:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104264:	e8 66 ca ff ff       	call   100ccf <__panic>
        *ptep = pa | PTE_P | perm;
  104269:	8b 45 18             	mov    0x18(%ebp),%eax
  10426c:	8b 55 14             	mov    0x14(%ebp),%edx
  10426f:	09 d0                	or     %edx,%eax
  104271:	83 c8 01             	or     $0x1,%eax
  104274:	89 c2                	mov    %eax,%edx
  104276:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104279:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10427b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10427f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104286:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10428d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104291:	75 8f                	jne    104222 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104293:	c9                   	leave  
  104294:	c3                   	ret    

00104295 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104295:	55                   	push   %ebp
  104296:	89 e5                	mov    %esp,%ebp
  104298:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10429b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1042a2:	e8 22 fa ff ff       	call   103cc9 <alloc_pages>
  1042a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1042aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042ae:	75 1c                	jne    1042cc <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1042b0:	c7 44 24 08 83 6b 10 	movl   $0x106b83,0x8(%esp)
  1042b7:	00 
  1042b8:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1042bf:	00 
  1042c0:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  1042c7:	e8 03 ca ff ff       	call   100ccf <__panic>
    }
    return page2kva(p);
  1042cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042cf:	89 04 24             	mov    %eax,(%esp)
  1042d2:	e8 5b f7 ff ff       	call   103a32 <page2kva>
}
  1042d7:	c9                   	leave  
  1042d8:	c3                   	ret    

001042d9 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1042d9:	55                   	push   %ebp
  1042da:	89 e5                	mov    %esp,%ebp
  1042dc:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1042df:	e8 93 f9 ff ff       	call   103c77 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1042e4:	e8 75 fa ff ff       	call   103d5e <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1042e9:	e8 84 04 00 00       	call   104772 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1042ee:	e8 a2 ff ff ff       	call   104295 <boot_alloc_page>
  1042f3:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  1042f8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042fd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104304:	00 
  104305:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10430c:	00 
  10430d:	89 04 24             	mov    %eax,(%esp)
  104310:	e8 c6 1a 00 00       	call   105ddb <memset>
    boot_cr3 = PADDR(boot_pgdir);
  104315:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10431a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10431d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104324:	77 23                	ja     104349 <pmm_init+0x70>
  104326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104329:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10432d:	c7 44 24 08 18 6b 10 	movl   $0x106b18,0x8(%esp)
  104334:	00 
  104335:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  10433c:	00 
  10433d:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104344:	e8 86 c9 ff ff       	call   100ccf <__panic>
  104349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10434c:	05 00 00 00 40       	add    $0x40000000,%eax
  104351:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  104356:	e8 35 04 00 00       	call   104790 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10435b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104360:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104366:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10436b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10436e:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104375:	77 23                	ja     10439a <pmm_init+0xc1>
  104377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10437a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10437e:	c7 44 24 08 18 6b 10 	movl   $0x106b18,0x8(%esp)
  104385:	00 
  104386:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  10438d:	00 
  10438e:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104395:	e8 35 c9 ff ff       	call   100ccf <__panic>
  10439a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10439d:	05 00 00 00 40       	add    $0x40000000,%eax
  1043a2:	83 c8 03             	or     $0x3,%eax
  1043a5:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1043a7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043ac:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1043b3:	00 
  1043b4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1043bb:	00 
  1043bc:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1043c3:	38 
  1043c4:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1043cb:	c0 
  1043cc:	89 04 24             	mov    %eax,(%esp)
  1043cf:	e8 b4 fd ff ff       	call   104188 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1043d4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043d9:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  1043df:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1043e5:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1043e7:	e8 63 fd ff ff       	call   10414f <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1043ec:	e8 97 f7 ff ff       	call   103b88 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1043f1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1043fc:	e8 2a 0a 00 00       	call   104e2b <check_boot_pgdir>

    print_pgdir();
  104401:	e8 b7 0e 00 00       	call   1052bd <print_pgdir>

}
  104406:	c9                   	leave  
  104407:	c3                   	ret    

00104408 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  104408:	55                   	push   %ebp
  104409:	89 e5                	mov    %esp,%ebp
  10440b:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = pgdir + PDX(la); // (1)
  10440e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104411:	c1 e8 16             	shr    $0x16,%eax
  104414:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10441b:	8b 45 08             	mov    0x8(%ebp),%eax
  10441e:	01 d0                	add    %edx,%eax
  104420:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*pdep & PTE_P)) // (2)
  104423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104426:	8b 00                	mov    (%eax),%eax
  104428:	83 e0 01             	and    $0x1,%eax
  10442b:	85 c0                	test   %eax,%eax
  10442d:	0f 85 b9 00 00 00    	jne    1044ec <get_pte+0xe4>
    {
        if(!create) // (3)
  104433:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104437:	75 0a                	jne    104443 <get_pte+0x3b>
            return NULL;
  104439:	b8 00 00 00 00       	mov    $0x0,%eax
  10443e:	e9 0e 01 00 00       	jmp    104551 <get_pte+0x149>
        struct Page *page = alloc_page();
  104443:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10444a:	e8 7a f8 ff ff       	call   103cc9 <alloc_pages>
  10444f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(page == NULL)
  104452:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104456:	75 0a                	jne    104462 <get_pte+0x5a>
            return NULL;
  104458:	b8 00 00 00 00       	mov    $0x0,%eax
  10445d:	e9 ef 00 00 00       	jmp    104551 <get_pte+0x149>
        set_page_ref(page, 1); // (4)
  104462:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104469:	00 
  10446a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10446d:	89 04 24             	mov    %eax,(%esp)
  104470:	e8 59 f6 ff ff       	call   103ace <set_page_ref>
        uintptr_t pa = page2pa(page); // (5)
  104475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104478:	89 04 24             	mov    %eax,(%esp)
  10447b:	e8 4d f5 ff ff       	call   1039cd <page2pa>
  104480:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE); // (6)
  104483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104486:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104489:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10448c:	c1 e8 0c             	shr    $0xc,%eax
  10448f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104492:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104497:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10449a:	72 23                	jb     1044bf <get_pte+0xb7>
  10449c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10449f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1044a3:	c7 44 24 08 74 6a 10 	movl   $0x106a74,0x8(%esp)
  1044aa:	00 
  1044ab:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
  1044b2:	00 
  1044b3:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  1044ba:	e8 10 c8 ff ff       	call   100ccf <__panic>
  1044bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044c2:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1044c7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1044ce:	00 
  1044cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044d6:	00 
  1044d7:	89 04 24             	mov    %eax,(%esp)
  1044da:	e8 fc 18 00 00       	call   105ddb <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  1044df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044e2:	83 c8 07             	or     $0x7,%eax
  1044e5:	89 c2                	mov    %eax,%edx
  1044e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044ea:	89 10                	mov    %edx,(%eax)
    }
    pte_t *ptep = (pte_t *)KADDR(PDE_ADDR(*pdep));
  1044ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044ef:	8b 00                	mov    (%eax),%eax
  1044f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1044f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1044f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044fc:	c1 e8 0c             	shr    $0xc,%eax
  1044ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104502:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104507:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10450a:	72 23                	jb     10452f <get_pte+0x127>
  10450c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10450f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104513:	c7 44 24 08 74 6a 10 	movl   $0x106a74,0x8(%esp)
  10451a:	00 
  10451b:	c7 44 24 04 8c 01 00 	movl   $0x18c,0x4(%esp)
  104522:	00 
  104523:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  10452a:	e8 a0 c7 ff ff       	call   100ccf <__panic>
  10452f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104532:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104537:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return ptep + PTX(la); // (8)
  10453a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10453d:	c1 e8 0c             	shr    $0xc,%eax
  104540:	25 ff 03 00 00       	and    $0x3ff,%eax
  104545:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10454c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10454f:	01 d0                	add    %edx,%eax
}
  104551:	c9                   	leave  
  104552:	c3                   	ret    

00104553 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104553:	55                   	push   %ebp
  104554:	89 e5                	mov    %esp,%ebp
  104556:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104559:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104560:	00 
  104561:	8b 45 0c             	mov    0xc(%ebp),%eax
  104564:	89 44 24 04          	mov    %eax,0x4(%esp)
  104568:	8b 45 08             	mov    0x8(%ebp),%eax
  10456b:	89 04 24             	mov    %eax,(%esp)
  10456e:	e8 95 fe ff ff       	call   104408 <get_pte>
  104573:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104576:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10457a:	74 08                	je     104584 <get_page+0x31>
        *ptep_store = ptep;
  10457c:	8b 45 10             	mov    0x10(%ebp),%eax
  10457f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104582:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104584:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104588:	74 1b                	je     1045a5 <get_page+0x52>
  10458a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10458d:	8b 00                	mov    (%eax),%eax
  10458f:	83 e0 01             	and    $0x1,%eax
  104592:	85 c0                	test   %eax,%eax
  104594:	74 0f                	je     1045a5 <get_page+0x52>
        return pa2page(*ptep);
  104596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104599:	8b 00                	mov    (%eax),%eax
  10459b:	89 04 24             	mov    %eax,(%esp)
  10459e:	e8 40 f4 ff ff       	call   1039e3 <pa2page>
  1045a3:	eb 05                	jmp    1045aa <get_page+0x57>
    }
    return NULL;
  1045a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1045aa:	c9                   	leave  
  1045ab:	c3                   	ret    

001045ac <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1045ac:	55                   	push   %ebp
  1045ad:	89 e5                	mov    %esp,%ebp
  1045af:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P) // (1)
  1045b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1045b5:	8b 00                	mov    (%eax),%eax
  1045b7:	83 e0 01             	and    $0x1,%eax
  1045ba:	85 c0                	test   %eax,%eax
  1045bc:	74 58                	je     104616 <page_remove_pte+0x6a>
    {
        struct Page *page = pte2page(*ptep); // (2)
  1045be:	8b 45 10             	mov    0x10(%ebp),%eax
  1045c1:	8b 00                	mov    (%eax),%eax
  1045c3:	89 04 24             	mov    %eax,(%esp)
  1045c6:	e8 bb f4 ff ff       	call   103a86 <pte2page>
  1045cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page); // (3)
  1045ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045d1:	89 04 24             	mov    %eax,(%esp)
  1045d4:	e8 19 f5 ff ff       	call   103af2 <page_ref_dec>
        if(page_ref(page) == 0) // (4)
  1045d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045dc:	89 04 24             	mov    %eax,(%esp)
  1045df:	e8 e0 f4 ff ff       	call   103ac4 <page_ref>
  1045e4:	85 c0                	test   %eax,%eax
  1045e6:	75 13                	jne    1045fb <page_remove_pte+0x4f>
            free_page(page);
  1045e8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1045ef:	00 
  1045f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045f3:	89 04 24             	mov    %eax,(%esp)
  1045f6:	e8 06 f7 ff ff       	call   103d01 <free_pages>
        *ptep = 0; // (5)
  1045fb:	8b 45 10             	mov    0x10(%ebp),%eax
  1045fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la); // (6)
  104604:	8b 45 0c             	mov    0xc(%ebp),%eax
  104607:	89 44 24 04          	mov    %eax,0x4(%esp)
  10460b:	8b 45 08             	mov    0x8(%ebp),%eax
  10460e:	89 04 24             	mov    %eax,(%esp)
  104611:	e8 ff 00 00 00       	call   104715 <tlb_invalidate>
    }
}
  104616:	c9                   	leave  
  104617:	c3                   	ret    

00104618 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104618:	55                   	push   %ebp
  104619:	89 e5                	mov    %esp,%ebp
  10461b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10461e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104625:	00 
  104626:	8b 45 0c             	mov    0xc(%ebp),%eax
  104629:	89 44 24 04          	mov    %eax,0x4(%esp)
  10462d:	8b 45 08             	mov    0x8(%ebp),%eax
  104630:	89 04 24             	mov    %eax,(%esp)
  104633:	e8 d0 fd ff ff       	call   104408 <get_pte>
  104638:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  10463b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10463f:	74 19                	je     10465a <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104644:	89 44 24 08          	mov    %eax,0x8(%esp)
  104648:	8b 45 0c             	mov    0xc(%ebp),%eax
  10464b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10464f:	8b 45 08             	mov    0x8(%ebp),%eax
  104652:	89 04 24             	mov    %eax,(%esp)
  104655:	e8 52 ff ff ff       	call   1045ac <page_remove_pte>
    }
}
  10465a:	c9                   	leave  
  10465b:	c3                   	ret    

0010465c <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10465c:	55                   	push   %ebp
  10465d:	89 e5                	mov    %esp,%ebp
  10465f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104662:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104669:	00 
  10466a:	8b 45 10             	mov    0x10(%ebp),%eax
  10466d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104671:	8b 45 08             	mov    0x8(%ebp),%eax
  104674:	89 04 24             	mov    %eax,(%esp)
  104677:	e8 8c fd ff ff       	call   104408 <get_pte>
  10467c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10467f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104683:	75 0a                	jne    10468f <page_insert+0x33>
        return -E_NO_MEM;
  104685:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10468a:	e9 84 00 00 00       	jmp    104713 <page_insert+0xb7>
    }
    page_ref_inc(page);
  10468f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104692:	89 04 24             	mov    %eax,(%esp)
  104695:	e8 41 f4 ff ff       	call   103adb <page_ref_inc>
    if (*ptep & PTE_P) {
  10469a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10469d:	8b 00                	mov    (%eax),%eax
  10469f:	83 e0 01             	and    $0x1,%eax
  1046a2:	85 c0                	test   %eax,%eax
  1046a4:	74 3e                	je     1046e4 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1046a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a9:	8b 00                	mov    (%eax),%eax
  1046ab:	89 04 24             	mov    %eax,(%esp)
  1046ae:	e8 d3 f3 ff ff       	call   103a86 <pte2page>
  1046b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1046b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1046bc:	75 0d                	jne    1046cb <page_insert+0x6f>
            page_ref_dec(page);
  1046be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046c1:	89 04 24             	mov    %eax,(%esp)
  1046c4:	e8 29 f4 ff ff       	call   103af2 <page_ref_dec>
  1046c9:	eb 19                	jmp    1046e4 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1046cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046d2:	8b 45 10             	mov    0x10(%ebp),%eax
  1046d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1046dc:	89 04 24             	mov    %eax,(%esp)
  1046df:	e8 c8 fe ff ff       	call   1045ac <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1046e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046e7:	89 04 24             	mov    %eax,(%esp)
  1046ea:	e8 de f2 ff ff       	call   1039cd <page2pa>
  1046ef:	0b 45 14             	or     0x14(%ebp),%eax
  1046f2:	83 c8 01             	or     $0x1,%eax
  1046f5:	89 c2                	mov    %eax,%edx
  1046f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046fa:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1046fc:	8b 45 10             	mov    0x10(%ebp),%eax
  1046ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  104703:	8b 45 08             	mov    0x8(%ebp),%eax
  104706:	89 04 24             	mov    %eax,(%esp)
  104709:	e8 07 00 00 00       	call   104715 <tlb_invalidate>
    return 0;
  10470e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104713:	c9                   	leave  
  104714:	c3                   	ret    

00104715 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104715:	55                   	push   %ebp
  104716:	89 e5                	mov    %esp,%ebp
  104718:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10471b:	0f 20 d8             	mov    %cr3,%eax
  10471e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104721:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104724:	89 c2                	mov    %eax,%edx
  104726:	8b 45 08             	mov    0x8(%ebp),%eax
  104729:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10472c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104733:	77 23                	ja     104758 <tlb_invalidate+0x43>
  104735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104738:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10473c:	c7 44 24 08 18 6b 10 	movl   $0x106b18,0x8(%esp)
  104743:	00 
  104744:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  10474b:	00 
  10474c:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104753:	e8 77 c5 ff ff       	call   100ccf <__panic>
  104758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10475b:	05 00 00 00 40       	add    $0x40000000,%eax
  104760:	39 c2                	cmp    %eax,%edx
  104762:	75 0c                	jne    104770 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104764:	8b 45 0c             	mov    0xc(%ebp),%eax
  104767:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10476a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10476d:	0f 01 38             	invlpg (%eax)
    }
}
  104770:	c9                   	leave  
  104771:	c3                   	ret    

00104772 <check_alloc_page>:

static void
check_alloc_page(void) {
  104772:	55                   	push   %ebp
  104773:	89 e5                	mov    %esp,%ebp
  104775:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104778:	a1 5c 89 11 00       	mov    0x11895c,%eax
  10477d:	8b 40 18             	mov    0x18(%eax),%eax
  104780:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104782:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104789:	e8 ae bb ff ff       	call   10033c <cprintf>
}
  10478e:	c9                   	leave  
  10478f:	c3                   	ret    

00104790 <check_pgdir>:

static void
check_pgdir(void) {
  104790:	55                   	push   %ebp
  104791:	89 e5                	mov    %esp,%ebp
  104793:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104796:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10479b:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1047a0:	76 24                	jbe    1047c6 <check_pgdir+0x36>
  1047a2:	c7 44 24 0c bb 6b 10 	movl   $0x106bbb,0xc(%esp)
  1047a9:	00 
  1047aa:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  1047b1:	00 
  1047b2:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  1047b9:	00 
  1047ba:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  1047c1:	e8 09 c5 ff ff       	call   100ccf <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1047c6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047cb:	85 c0                	test   %eax,%eax
  1047cd:	74 0e                	je     1047dd <check_pgdir+0x4d>
  1047cf:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047d4:	25 ff 0f 00 00       	and    $0xfff,%eax
  1047d9:	85 c0                	test   %eax,%eax
  1047db:	74 24                	je     104801 <check_pgdir+0x71>
  1047dd:	c7 44 24 0c d8 6b 10 	movl   $0x106bd8,0xc(%esp)
  1047e4:	00 
  1047e5:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  1047ec:	00 
  1047ed:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  1047f4:	00 
  1047f5:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  1047fc:	e8 ce c4 ff ff       	call   100ccf <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104801:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104806:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10480d:	00 
  10480e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104815:	00 
  104816:	89 04 24             	mov    %eax,(%esp)
  104819:	e8 35 fd ff ff       	call   104553 <get_page>
  10481e:	85 c0                	test   %eax,%eax
  104820:	74 24                	je     104846 <check_pgdir+0xb6>
  104822:	c7 44 24 0c 10 6c 10 	movl   $0x106c10,0xc(%esp)
  104829:	00 
  10482a:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104831:	00 
  104832:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104839:	00 
  10483a:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104841:	e8 89 c4 ff ff       	call   100ccf <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104846:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10484d:	e8 77 f4 ff ff       	call   103cc9 <alloc_pages>
  104852:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104855:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10485a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104861:	00 
  104862:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104869:	00 
  10486a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10486d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104871:	89 04 24             	mov    %eax,(%esp)
  104874:	e8 e3 fd ff ff       	call   10465c <page_insert>
  104879:	85 c0                	test   %eax,%eax
  10487b:	74 24                	je     1048a1 <check_pgdir+0x111>
  10487d:	c7 44 24 0c 38 6c 10 	movl   $0x106c38,0xc(%esp)
  104884:	00 
  104885:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  10488c:	00 
  10488d:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104894:	00 
  104895:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  10489c:	e8 2e c4 ff ff       	call   100ccf <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1048a1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048ad:	00 
  1048ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048b5:	00 
  1048b6:	89 04 24             	mov    %eax,(%esp)
  1048b9:	e8 4a fb ff ff       	call   104408 <get_pte>
  1048be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048c5:	75 24                	jne    1048eb <check_pgdir+0x15b>
  1048c7:	c7 44 24 0c 64 6c 10 	movl   $0x106c64,0xc(%esp)
  1048ce:	00 
  1048cf:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  1048d6:	00 
  1048d7:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  1048de:	00 
  1048df:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  1048e6:	e8 e4 c3 ff ff       	call   100ccf <__panic>
    assert(pa2page(*ptep) == p1);
  1048eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048ee:	8b 00                	mov    (%eax),%eax
  1048f0:	89 04 24             	mov    %eax,(%esp)
  1048f3:	e8 eb f0 ff ff       	call   1039e3 <pa2page>
  1048f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1048fb:	74 24                	je     104921 <check_pgdir+0x191>
  1048fd:	c7 44 24 0c 91 6c 10 	movl   $0x106c91,0xc(%esp)
  104904:	00 
  104905:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  10490c:	00 
  10490d:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104914:	00 
  104915:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  10491c:	e8 ae c3 ff ff       	call   100ccf <__panic>
    assert(page_ref(p1) == 1);
  104921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104924:	89 04 24             	mov    %eax,(%esp)
  104927:	e8 98 f1 ff ff       	call   103ac4 <page_ref>
  10492c:	83 f8 01             	cmp    $0x1,%eax
  10492f:	74 24                	je     104955 <check_pgdir+0x1c5>
  104931:	c7 44 24 0c a6 6c 10 	movl   $0x106ca6,0xc(%esp)
  104938:	00 
  104939:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104940:	00 
  104941:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104948:	00 
  104949:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104950:	e8 7a c3 ff ff       	call   100ccf <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104955:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10495a:	8b 00                	mov    (%eax),%eax
  10495c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104961:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104964:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104967:	c1 e8 0c             	shr    $0xc,%eax
  10496a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10496d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104972:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104975:	72 23                	jb     10499a <check_pgdir+0x20a>
  104977:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10497a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10497e:	c7 44 24 08 74 6a 10 	movl   $0x106a74,0x8(%esp)
  104985:	00 
  104986:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  10498d:	00 
  10498e:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104995:	e8 35 c3 ff ff       	call   100ccf <__panic>
  10499a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10499d:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1049a2:	83 c0 04             	add    $0x4,%eax
  1049a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1049a8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049ad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049b4:	00 
  1049b5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1049bc:	00 
  1049bd:	89 04 24             	mov    %eax,(%esp)
  1049c0:	e8 43 fa ff ff       	call   104408 <get_pte>
  1049c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1049c8:	74 24                	je     1049ee <check_pgdir+0x25e>
  1049ca:	c7 44 24 0c b8 6c 10 	movl   $0x106cb8,0xc(%esp)
  1049d1:	00 
  1049d2:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  1049d9:	00 
  1049da:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  1049e1:	00 
  1049e2:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  1049e9:	e8 e1 c2 ff ff       	call   100ccf <__panic>

    p2 = alloc_page();
  1049ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1049f5:	e8 cf f2 ff ff       	call   103cc9 <alloc_pages>
  1049fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1049fd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a02:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104a09:	00 
  104a0a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a11:	00 
  104a12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a15:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a19:	89 04 24             	mov    %eax,(%esp)
  104a1c:	e8 3b fc ff ff       	call   10465c <page_insert>
  104a21:	85 c0                	test   %eax,%eax
  104a23:	74 24                	je     104a49 <check_pgdir+0x2b9>
  104a25:	c7 44 24 0c e0 6c 10 	movl   $0x106ce0,0xc(%esp)
  104a2c:	00 
  104a2d:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104a34:	00 
  104a35:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104a3c:	00 
  104a3d:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104a44:	e8 86 c2 ff ff       	call   100ccf <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a49:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a4e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a55:	00 
  104a56:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a5d:	00 
  104a5e:	89 04 24             	mov    %eax,(%esp)
  104a61:	e8 a2 f9 ff ff       	call   104408 <get_pte>
  104a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a6d:	75 24                	jne    104a93 <check_pgdir+0x303>
  104a6f:	c7 44 24 0c 18 6d 10 	movl   $0x106d18,0xc(%esp)
  104a76:	00 
  104a77:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104a7e:	00 
  104a7f:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104a86:	00 
  104a87:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104a8e:	e8 3c c2 ff ff       	call   100ccf <__panic>
    assert(*ptep & PTE_U);
  104a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a96:	8b 00                	mov    (%eax),%eax
  104a98:	83 e0 04             	and    $0x4,%eax
  104a9b:	85 c0                	test   %eax,%eax
  104a9d:	75 24                	jne    104ac3 <check_pgdir+0x333>
  104a9f:	c7 44 24 0c 48 6d 10 	movl   $0x106d48,0xc(%esp)
  104aa6:	00 
  104aa7:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104aae:	00 
  104aaf:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104ab6:	00 
  104ab7:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104abe:	e8 0c c2 ff ff       	call   100ccf <__panic>
    assert(*ptep & PTE_W);
  104ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ac6:	8b 00                	mov    (%eax),%eax
  104ac8:	83 e0 02             	and    $0x2,%eax
  104acb:	85 c0                	test   %eax,%eax
  104acd:	75 24                	jne    104af3 <check_pgdir+0x363>
  104acf:	c7 44 24 0c 56 6d 10 	movl   $0x106d56,0xc(%esp)
  104ad6:	00 
  104ad7:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104ade:	00 
  104adf:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104ae6:	00 
  104ae7:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104aee:	e8 dc c1 ff ff       	call   100ccf <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104af3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104af8:	8b 00                	mov    (%eax),%eax
  104afa:	83 e0 04             	and    $0x4,%eax
  104afd:	85 c0                	test   %eax,%eax
  104aff:	75 24                	jne    104b25 <check_pgdir+0x395>
  104b01:	c7 44 24 0c 64 6d 10 	movl   $0x106d64,0xc(%esp)
  104b08:	00 
  104b09:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104b10:	00 
  104b11:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104b18:	00 
  104b19:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104b20:	e8 aa c1 ff ff       	call   100ccf <__panic>
    assert(page_ref(p2) == 1);
  104b25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b28:	89 04 24             	mov    %eax,(%esp)
  104b2b:	e8 94 ef ff ff       	call   103ac4 <page_ref>
  104b30:	83 f8 01             	cmp    $0x1,%eax
  104b33:	74 24                	je     104b59 <check_pgdir+0x3c9>
  104b35:	c7 44 24 0c 7a 6d 10 	movl   $0x106d7a,0xc(%esp)
  104b3c:	00 
  104b3d:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104b44:	00 
  104b45:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104b4c:	00 
  104b4d:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104b54:	e8 76 c1 ff ff       	call   100ccf <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104b59:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b5e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104b65:	00 
  104b66:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104b6d:	00 
  104b6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b71:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b75:	89 04 24             	mov    %eax,(%esp)
  104b78:	e8 df fa ff ff       	call   10465c <page_insert>
  104b7d:	85 c0                	test   %eax,%eax
  104b7f:	74 24                	je     104ba5 <check_pgdir+0x415>
  104b81:	c7 44 24 0c 8c 6d 10 	movl   $0x106d8c,0xc(%esp)
  104b88:	00 
  104b89:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104b90:	00 
  104b91:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104b98:	00 
  104b99:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104ba0:	e8 2a c1 ff ff       	call   100ccf <__panic>
    assert(page_ref(p1) == 2);
  104ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ba8:	89 04 24             	mov    %eax,(%esp)
  104bab:	e8 14 ef ff ff       	call   103ac4 <page_ref>
  104bb0:	83 f8 02             	cmp    $0x2,%eax
  104bb3:	74 24                	je     104bd9 <check_pgdir+0x449>
  104bb5:	c7 44 24 0c b8 6d 10 	movl   $0x106db8,0xc(%esp)
  104bbc:	00 
  104bbd:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104bc4:	00 
  104bc5:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104bcc:	00 
  104bcd:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104bd4:	e8 f6 c0 ff ff       	call   100ccf <__panic>
    assert(page_ref(p2) == 0);
  104bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bdc:	89 04 24             	mov    %eax,(%esp)
  104bdf:	e8 e0 ee ff ff       	call   103ac4 <page_ref>
  104be4:	85 c0                	test   %eax,%eax
  104be6:	74 24                	je     104c0c <check_pgdir+0x47c>
  104be8:	c7 44 24 0c ca 6d 10 	movl   $0x106dca,0xc(%esp)
  104bef:	00 
  104bf0:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104bf7:	00 
  104bf8:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104bff:	00 
  104c00:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104c07:	e8 c3 c0 ff ff       	call   100ccf <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c0c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c11:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c18:	00 
  104c19:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c20:	00 
  104c21:	89 04 24             	mov    %eax,(%esp)
  104c24:	e8 df f7 ff ff       	call   104408 <get_pte>
  104c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c30:	75 24                	jne    104c56 <check_pgdir+0x4c6>
  104c32:	c7 44 24 0c 18 6d 10 	movl   $0x106d18,0xc(%esp)
  104c39:	00 
  104c3a:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104c41:	00 
  104c42:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104c49:	00 
  104c4a:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104c51:	e8 79 c0 ff ff       	call   100ccf <__panic>
    assert(pa2page(*ptep) == p1);
  104c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c59:	8b 00                	mov    (%eax),%eax
  104c5b:	89 04 24             	mov    %eax,(%esp)
  104c5e:	e8 80 ed ff ff       	call   1039e3 <pa2page>
  104c63:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104c66:	74 24                	je     104c8c <check_pgdir+0x4fc>
  104c68:	c7 44 24 0c 91 6c 10 	movl   $0x106c91,0xc(%esp)
  104c6f:	00 
  104c70:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104c77:	00 
  104c78:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104c7f:	00 
  104c80:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104c87:	e8 43 c0 ff ff       	call   100ccf <__panic>
    assert((*ptep & PTE_U) == 0);
  104c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c8f:	8b 00                	mov    (%eax),%eax
  104c91:	83 e0 04             	and    $0x4,%eax
  104c94:	85 c0                	test   %eax,%eax
  104c96:	74 24                	je     104cbc <check_pgdir+0x52c>
  104c98:	c7 44 24 0c dc 6d 10 	movl   $0x106ddc,0xc(%esp)
  104c9f:	00 
  104ca0:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104ca7:	00 
  104ca8:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104caf:	00 
  104cb0:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104cb7:	e8 13 c0 ff ff       	call   100ccf <__panic>

    page_remove(boot_pgdir, 0x0);
  104cbc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cc1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104cc8:	00 
  104cc9:	89 04 24             	mov    %eax,(%esp)
  104ccc:	e8 47 f9 ff ff       	call   104618 <page_remove>
    assert(page_ref(p1) == 1);
  104cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cd4:	89 04 24             	mov    %eax,(%esp)
  104cd7:	e8 e8 ed ff ff       	call   103ac4 <page_ref>
  104cdc:	83 f8 01             	cmp    $0x1,%eax
  104cdf:	74 24                	je     104d05 <check_pgdir+0x575>
  104ce1:	c7 44 24 0c a6 6c 10 	movl   $0x106ca6,0xc(%esp)
  104ce8:	00 
  104ce9:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104cf0:	00 
  104cf1:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104cf8:	00 
  104cf9:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104d00:	e8 ca bf ff ff       	call   100ccf <__panic>
    assert(page_ref(p2) == 0);
  104d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d08:	89 04 24             	mov    %eax,(%esp)
  104d0b:	e8 b4 ed ff ff       	call   103ac4 <page_ref>
  104d10:	85 c0                	test   %eax,%eax
  104d12:	74 24                	je     104d38 <check_pgdir+0x5a8>
  104d14:	c7 44 24 0c ca 6d 10 	movl   $0x106dca,0xc(%esp)
  104d1b:	00 
  104d1c:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104d23:	00 
  104d24:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104d2b:	00 
  104d2c:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104d33:	e8 97 bf ff ff       	call   100ccf <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104d38:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d3d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d44:	00 
  104d45:	89 04 24             	mov    %eax,(%esp)
  104d48:	e8 cb f8 ff ff       	call   104618 <page_remove>
    assert(page_ref(p1) == 0);
  104d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d50:	89 04 24             	mov    %eax,(%esp)
  104d53:	e8 6c ed ff ff       	call   103ac4 <page_ref>
  104d58:	85 c0                	test   %eax,%eax
  104d5a:	74 24                	je     104d80 <check_pgdir+0x5f0>
  104d5c:	c7 44 24 0c f1 6d 10 	movl   $0x106df1,0xc(%esp)
  104d63:	00 
  104d64:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104d6b:	00 
  104d6c:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  104d73:	00 
  104d74:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104d7b:	e8 4f bf ff ff       	call   100ccf <__panic>
    assert(page_ref(p2) == 0);
  104d80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d83:	89 04 24             	mov    %eax,(%esp)
  104d86:	e8 39 ed ff ff       	call   103ac4 <page_ref>
  104d8b:	85 c0                	test   %eax,%eax
  104d8d:	74 24                	je     104db3 <check_pgdir+0x623>
  104d8f:	c7 44 24 0c ca 6d 10 	movl   $0x106dca,0xc(%esp)
  104d96:	00 
  104d97:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104d9e:	00 
  104d9f:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104da6:	00 
  104da7:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104dae:	e8 1c bf ff ff       	call   100ccf <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104db3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104db8:	8b 00                	mov    (%eax),%eax
  104dba:	89 04 24             	mov    %eax,(%esp)
  104dbd:	e8 21 ec ff ff       	call   1039e3 <pa2page>
  104dc2:	89 04 24             	mov    %eax,(%esp)
  104dc5:	e8 fa ec ff ff       	call   103ac4 <page_ref>
  104dca:	83 f8 01             	cmp    $0x1,%eax
  104dcd:	74 24                	je     104df3 <check_pgdir+0x663>
  104dcf:	c7 44 24 0c 04 6e 10 	movl   $0x106e04,0xc(%esp)
  104dd6:	00 
  104dd7:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104dde:	00 
  104ddf:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104de6:	00 
  104de7:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104dee:	e8 dc be ff ff       	call   100ccf <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104df3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104df8:	8b 00                	mov    (%eax),%eax
  104dfa:	89 04 24             	mov    %eax,(%esp)
  104dfd:	e8 e1 eb ff ff       	call   1039e3 <pa2page>
  104e02:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e09:	00 
  104e0a:	89 04 24             	mov    %eax,(%esp)
  104e0d:	e8 ef ee ff ff       	call   103d01 <free_pages>
    boot_pgdir[0] = 0;
  104e12:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104e1d:	c7 04 24 2a 6e 10 00 	movl   $0x106e2a,(%esp)
  104e24:	e8 13 b5 ff ff       	call   10033c <cprintf>
}
  104e29:	c9                   	leave  
  104e2a:	c3                   	ret    

00104e2b <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104e2b:	55                   	push   %ebp
  104e2c:	89 e5                	mov    %esp,%ebp
  104e2e:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e38:	e9 ca 00 00 00       	jmp    104f07 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e46:	c1 e8 0c             	shr    $0xc,%eax
  104e49:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e4c:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104e51:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104e54:	72 23                	jb     104e79 <check_boot_pgdir+0x4e>
  104e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e59:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e5d:	c7 44 24 08 74 6a 10 	movl   $0x106a74,0x8(%esp)
  104e64:	00 
  104e65:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104e6c:	00 
  104e6d:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104e74:	e8 56 be ff ff       	call   100ccf <__panic>
  104e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e7c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104e81:	89 c2                	mov    %eax,%edx
  104e83:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e88:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104e8f:	00 
  104e90:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e94:	89 04 24             	mov    %eax,(%esp)
  104e97:	e8 6c f5 ff ff       	call   104408 <get_pte>
  104e9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104e9f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104ea3:	75 24                	jne    104ec9 <check_boot_pgdir+0x9e>
  104ea5:	c7 44 24 0c 44 6e 10 	movl   $0x106e44,0xc(%esp)
  104eac:	00 
  104ead:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104eb4:	00 
  104eb5:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104ebc:	00 
  104ebd:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104ec4:	e8 06 be ff ff       	call   100ccf <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104ec9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ecc:	8b 00                	mov    (%eax),%eax
  104ece:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104ed3:	89 c2                	mov    %eax,%edx
  104ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ed8:	39 c2                	cmp    %eax,%edx
  104eda:	74 24                	je     104f00 <check_boot_pgdir+0xd5>
  104edc:	c7 44 24 0c 81 6e 10 	movl   $0x106e81,0xc(%esp)
  104ee3:	00 
  104ee4:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104eeb:	00 
  104eec:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  104ef3:	00 
  104ef4:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104efb:	e8 cf bd ff ff       	call   100ccf <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104f00:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f0a:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104f0f:	39 c2                	cmp    %eax,%edx
  104f11:	0f 82 26 ff ff ff    	jb     104e3d <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104f17:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f1c:	05 ac 0f 00 00       	add    $0xfac,%eax
  104f21:	8b 00                	mov    (%eax),%eax
  104f23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f28:	89 c2                	mov    %eax,%edx
  104f2a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f32:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104f39:	77 23                	ja     104f5e <check_boot_pgdir+0x133>
  104f3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f42:	c7 44 24 08 18 6b 10 	movl   $0x106b18,0x8(%esp)
  104f49:	00 
  104f4a:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  104f51:	00 
  104f52:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104f59:	e8 71 bd ff ff       	call   100ccf <__panic>
  104f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f61:	05 00 00 00 40       	add    $0x40000000,%eax
  104f66:	39 c2                	cmp    %eax,%edx
  104f68:	74 24                	je     104f8e <check_boot_pgdir+0x163>
  104f6a:	c7 44 24 0c 98 6e 10 	movl   $0x106e98,0xc(%esp)
  104f71:	00 
  104f72:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104f79:	00 
  104f7a:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  104f81:	00 
  104f82:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104f89:	e8 41 bd ff ff       	call   100ccf <__panic>

    assert(boot_pgdir[0] == 0);
  104f8e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f93:	8b 00                	mov    (%eax),%eax
  104f95:	85 c0                	test   %eax,%eax
  104f97:	74 24                	je     104fbd <check_boot_pgdir+0x192>
  104f99:	c7 44 24 0c cc 6e 10 	movl   $0x106ecc,0xc(%esp)
  104fa0:	00 
  104fa1:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  104fa8:	00 
  104fa9:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  104fb0:	00 
  104fb1:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  104fb8:	e8 12 bd ff ff       	call   100ccf <__panic>

    struct Page *p;
    p = alloc_page();
  104fbd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fc4:	e8 00 ed ff ff       	call   103cc9 <alloc_pages>
  104fc9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104fcc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fd1:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104fd8:	00 
  104fd9:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104fe0:	00 
  104fe1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104fe4:	89 54 24 04          	mov    %edx,0x4(%esp)
  104fe8:	89 04 24             	mov    %eax,(%esp)
  104feb:	e8 6c f6 ff ff       	call   10465c <page_insert>
  104ff0:	85 c0                	test   %eax,%eax
  104ff2:	74 24                	je     105018 <check_boot_pgdir+0x1ed>
  104ff4:	c7 44 24 0c e0 6e 10 	movl   $0x106ee0,0xc(%esp)
  104ffb:	00 
  104ffc:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  105003:	00 
  105004:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  10500b:	00 
  10500c:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  105013:	e8 b7 bc ff ff       	call   100ccf <__panic>
    assert(page_ref(p) == 1);
  105018:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10501b:	89 04 24             	mov    %eax,(%esp)
  10501e:	e8 a1 ea ff ff       	call   103ac4 <page_ref>
  105023:	83 f8 01             	cmp    $0x1,%eax
  105026:	74 24                	je     10504c <check_boot_pgdir+0x221>
  105028:	c7 44 24 0c 0e 6f 10 	movl   $0x106f0e,0xc(%esp)
  10502f:	00 
  105030:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  105037:	00 
  105038:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  10503f:	00 
  105040:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  105047:	e8 83 bc ff ff       	call   100ccf <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10504c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105051:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105058:	00 
  105059:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105060:	00 
  105061:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105064:	89 54 24 04          	mov    %edx,0x4(%esp)
  105068:	89 04 24             	mov    %eax,(%esp)
  10506b:	e8 ec f5 ff ff       	call   10465c <page_insert>
  105070:	85 c0                	test   %eax,%eax
  105072:	74 24                	je     105098 <check_boot_pgdir+0x26d>
  105074:	c7 44 24 0c 20 6f 10 	movl   $0x106f20,0xc(%esp)
  10507b:	00 
  10507c:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  105083:	00 
  105084:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  10508b:	00 
  10508c:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  105093:	e8 37 bc ff ff       	call   100ccf <__panic>
    assert(page_ref(p) == 2);
  105098:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10509b:	89 04 24             	mov    %eax,(%esp)
  10509e:	e8 21 ea ff ff       	call   103ac4 <page_ref>
  1050a3:	83 f8 02             	cmp    $0x2,%eax
  1050a6:	74 24                	je     1050cc <check_boot_pgdir+0x2a1>
  1050a8:	c7 44 24 0c 57 6f 10 	movl   $0x106f57,0xc(%esp)
  1050af:	00 
  1050b0:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  1050b7:	00 
  1050b8:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  1050bf:	00 
  1050c0:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  1050c7:	e8 03 bc ff ff       	call   100ccf <__panic>

    const char *str = "ucore: Hello world!!";
  1050cc:	c7 45 dc 68 6f 10 00 	movl   $0x106f68,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1050d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050da:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1050e1:	e8 1e 0a 00 00       	call   105b04 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1050e6:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1050ed:	00 
  1050ee:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1050f5:	e8 83 0a 00 00       	call   105b7d <strcmp>
  1050fa:	85 c0                	test   %eax,%eax
  1050fc:	74 24                	je     105122 <check_boot_pgdir+0x2f7>
  1050fe:	c7 44 24 0c 80 6f 10 	movl   $0x106f80,0xc(%esp)
  105105:	00 
  105106:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  10510d:	00 
  10510e:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
  105115:	00 
  105116:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  10511d:	e8 ad bb ff ff       	call   100ccf <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105122:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105125:	89 04 24             	mov    %eax,(%esp)
  105128:	e8 05 e9 ff ff       	call   103a32 <page2kva>
  10512d:	05 00 01 00 00       	add    $0x100,%eax
  105132:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105135:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10513c:	e8 6b 09 00 00       	call   105aac <strlen>
  105141:	85 c0                	test   %eax,%eax
  105143:	74 24                	je     105169 <check_boot_pgdir+0x33e>
  105145:	c7 44 24 0c b8 6f 10 	movl   $0x106fb8,0xc(%esp)
  10514c:	00 
  10514d:	c7 44 24 08 61 6b 10 	movl   $0x106b61,0x8(%esp)
  105154:	00 
  105155:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
  10515c:	00 
  10515d:	c7 04 24 3c 6b 10 00 	movl   $0x106b3c,(%esp)
  105164:	e8 66 bb ff ff       	call   100ccf <__panic>

    free_page(p);
  105169:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105170:	00 
  105171:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105174:	89 04 24             	mov    %eax,(%esp)
  105177:	e8 85 eb ff ff       	call   103d01 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  10517c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105181:	8b 00                	mov    (%eax),%eax
  105183:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105188:	89 04 24             	mov    %eax,(%esp)
  10518b:	e8 53 e8 ff ff       	call   1039e3 <pa2page>
  105190:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105197:	00 
  105198:	89 04 24             	mov    %eax,(%esp)
  10519b:	e8 61 eb ff ff       	call   103d01 <free_pages>
    boot_pgdir[0] = 0;
  1051a0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1051a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1051ab:	c7 04 24 dc 6f 10 00 	movl   $0x106fdc,(%esp)
  1051b2:	e8 85 b1 ff ff       	call   10033c <cprintf>
}
  1051b7:	c9                   	leave  
  1051b8:	c3                   	ret    

001051b9 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1051b9:	55                   	push   %ebp
  1051ba:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1051bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1051bf:	83 e0 04             	and    $0x4,%eax
  1051c2:	85 c0                	test   %eax,%eax
  1051c4:	74 07                	je     1051cd <perm2str+0x14>
  1051c6:	b8 75 00 00 00       	mov    $0x75,%eax
  1051cb:	eb 05                	jmp    1051d2 <perm2str+0x19>
  1051cd:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1051d2:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  1051d7:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1051de:	8b 45 08             	mov    0x8(%ebp),%eax
  1051e1:	83 e0 02             	and    $0x2,%eax
  1051e4:	85 c0                	test   %eax,%eax
  1051e6:	74 07                	je     1051ef <perm2str+0x36>
  1051e8:	b8 77 00 00 00       	mov    $0x77,%eax
  1051ed:	eb 05                	jmp    1051f4 <perm2str+0x3b>
  1051ef:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1051f4:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  1051f9:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  105200:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  105205:	5d                   	pop    %ebp
  105206:	c3                   	ret    

00105207 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105207:	55                   	push   %ebp
  105208:	89 e5                	mov    %esp,%ebp
  10520a:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10520d:	8b 45 10             	mov    0x10(%ebp),%eax
  105210:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105213:	72 0a                	jb     10521f <get_pgtable_items+0x18>
        return 0;
  105215:	b8 00 00 00 00       	mov    $0x0,%eax
  10521a:	e9 9c 00 00 00       	jmp    1052bb <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  10521f:	eb 04                	jmp    105225 <get_pgtable_items+0x1e>
        start ++;
  105221:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105225:	8b 45 10             	mov    0x10(%ebp),%eax
  105228:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10522b:	73 18                	jae    105245 <get_pgtable_items+0x3e>
  10522d:	8b 45 10             	mov    0x10(%ebp),%eax
  105230:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105237:	8b 45 14             	mov    0x14(%ebp),%eax
  10523a:	01 d0                	add    %edx,%eax
  10523c:	8b 00                	mov    (%eax),%eax
  10523e:	83 e0 01             	and    $0x1,%eax
  105241:	85 c0                	test   %eax,%eax
  105243:	74 dc                	je     105221 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105245:	8b 45 10             	mov    0x10(%ebp),%eax
  105248:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10524b:	73 69                	jae    1052b6 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  10524d:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105251:	74 08                	je     10525b <get_pgtable_items+0x54>
            *left_store = start;
  105253:	8b 45 18             	mov    0x18(%ebp),%eax
  105256:	8b 55 10             	mov    0x10(%ebp),%edx
  105259:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10525b:	8b 45 10             	mov    0x10(%ebp),%eax
  10525e:	8d 50 01             	lea    0x1(%eax),%edx
  105261:	89 55 10             	mov    %edx,0x10(%ebp)
  105264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10526b:	8b 45 14             	mov    0x14(%ebp),%eax
  10526e:	01 d0                	add    %edx,%eax
  105270:	8b 00                	mov    (%eax),%eax
  105272:	83 e0 07             	and    $0x7,%eax
  105275:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105278:	eb 04                	jmp    10527e <get_pgtable_items+0x77>
            start ++;
  10527a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  10527e:	8b 45 10             	mov    0x10(%ebp),%eax
  105281:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105284:	73 1d                	jae    1052a3 <get_pgtable_items+0x9c>
  105286:	8b 45 10             	mov    0x10(%ebp),%eax
  105289:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105290:	8b 45 14             	mov    0x14(%ebp),%eax
  105293:	01 d0                	add    %edx,%eax
  105295:	8b 00                	mov    (%eax),%eax
  105297:	83 e0 07             	and    $0x7,%eax
  10529a:	89 c2                	mov    %eax,%edx
  10529c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10529f:	39 c2                	cmp    %eax,%edx
  1052a1:	74 d7                	je     10527a <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1052a3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1052a7:	74 08                	je     1052b1 <get_pgtable_items+0xaa>
            *right_store = start;
  1052a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1052ac:	8b 55 10             	mov    0x10(%ebp),%edx
  1052af:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1052b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052b4:	eb 05                	jmp    1052bb <get_pgtable_items+0xb4>
    }
    return 0;
  1052b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1052bb:	c9                   	leave  
  1052bc:	c3                   	ret    

001052bd <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1052bd:	55                   	push   %ebp
  1052be:	89 e5                	mov    %esp,%ebp
  1052c0:	57                   	push   %edi
  1052c1:	56                   	push   %esi
  1052c2:	53                   	push   %ebx
  1052c3:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1052c6:	c7 04 24 fc 6f 10 00 	movl   $0x106ffc,(%esp)
  1052cd:	e8 6a b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  1052d2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1052d9:	e9 fa 00 00 00       	jmp    1053d8 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1052de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052e1:	89 04 24             	mov    %eax,(%esp)
  1052e4:	e8 d0 fe ff ff       	call   1051b9 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1052e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1052ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052ef:	29 d1                	sub    %edx,%ecx
  1052f1:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1052f3:	89 d6                	mov    %edx,%esi
  1052f5:	c1 e6 16             	shl    $0x16,%esi
  1052f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1052fb:	89 d3                	mov    %edx,%ebx
  1052fd:	c1 e3 16             	shl    $0x16,%ebx
  105300:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105303:	89 d1                	mov    %edx,%ecx
  105305:	c1 e1 16             	shl    $0x16,%ecx
  105308:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10530b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10530e:	29 d7                	sub    %edx,%edi
  105310:	89 fa                	mov    %edi,%edx
  105312:	89 44 24 14          	mov    %eax,0x14(%esp)
  105316:	89 74 24 10          	mov    %esi,0x10(%esp)
  10531a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10531e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105322:	89 54 24 04          	mov    %edx,0x4(%esp)
  105326:	c7 04 24 2d 70 10 00 	movl   $0x10702d,(%esp)
  10532d:	e8 0a b0 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  105332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105335:	c1 e0 0a             	shl    $0xa,%eax
  105338:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10533b:	eb 54                	jmp    105391 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10533d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105340:	89 04 24             	mov    %eax,(%esp)
  105343:	e8 71 fe ff ff       	call   1051b9 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105348:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10534b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10534e:	29 d1                	sub    %edx,%ecx
  105350:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105352:	89 d6                	mov    %edx,%esi
  105354:	c1 e6 0c             	shl    $0xc,%esi
  105357:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10535a:	89 d3                	mov    %edx,%ebx
  10535c:	c1 e3 0c             	shl    $0xc,%ebx
  10535f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105362:	c1 e2 0c             	shl    $0xc,%edx
  105365:	89 d1                	mov    %edx,%ecx
  105367:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10536a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10536d:	29 d7                	sub    %edx,%edi
  10536f:	89 fa                	mov    %edi,%edx
  105371:	89 44 24 14          	mov    %eax,0x14(%esp)
  105375:	89 74 24 10          	mov    %esi,0x10(%esp)
  105379:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10537d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105381:	89 54 24 04          	mov    %edx,0x4(%esp)
  105385:	c7 04 24 4c 70 10 00 	movl   $0x10704c,(%esp)
  10538c:	e8 ab af ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105391:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  105396:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105399:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10539c:	89 ce                	mov    %ecx,%esi
  10539e:	c1 e6 0a             	shl    $0xa,%esi
  1053a1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1053a4:	89 cb                	mov    %ecx,%ebx
  1053a6:	c1 e3 0a             	shl    $0xa,%ebx
  1053a9:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1053ac:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1053b0:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1053b3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1053b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  1053c3:	89 1c 24             	mov    %ebx,(%esp)
  1053c6:	e8 3c fe ff ff       	call   105207 <get_pgtable_items>
  1053cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1053d2:	0f 85 65 ff ff ff    	jne    10533d <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1053d8:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1053dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053e0:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1053e3:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1053e7:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1053ea:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1053ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053f6:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1053fd:	00 
  1053fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105405:	e8 fd fd ff ff       	call   105207 <get_pgtable_items>
  10540a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10540d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105411:	0f 85 c7 fe ff ff    	jne    1052de <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105417:	c7 04 24 70 70 10 00 	movl   $0x107070,(%esp)
  10541e:	e8 19 af ff ff       	call   10033c <cprintf>
}
  105423:	83 c4 4c             	add    $0x4c,%esp
  105426:	5b                   	pop    %ebx
  105427:	5e                   	pop    %esi
  105428:	5f                   	pop    %edi
  105429:	5d                   	pop    %ebp
  10542a:	c3                   	ret    

0010542b <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10542b:	55                   	push   %ebp
  10542c:	89 e5                	mov    %esp,%ebp
  10542e:	83 ec 58             	sub    $0x58,%esp
  105431:	8b 45 10             	mov    0x10(%ebp),%eax
  105434:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105437:	8b 45 14             	mov    0x14(%ebp),%eax
  10543a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10543d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105440:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105443:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105446:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105449:	8b 45 18             	mov    0x18(%ebp),%eax
  10544c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10544f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105452:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105455:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105458:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10545b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10545e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105461:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105465:	74 1c                	je     105483 <printnum+0x58>
  105467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10546a:	ba 00 00 00 00       	mov    $0x0,%edx
  10546f:	f7 75 e4             	divl   -0x1c(%ebp)
  105472:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105478:	ba 00 00 00 00       	mov    $0x0,%edx
  10547d:	f7 75 e4             	divl   -0x1c(%ebp)
  105480:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105483:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105486:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105489:	f7 75 e4             	divl   -0x1c(%ebp)
  10548c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10548f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105495:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105498:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10549b:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10549e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054a1:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1054a4:	8b 45 18             	mov    0x18(%ebp),%eax
  1054a7:	ba 00 00 00 00       	mov    $0x0,%edx
  1054ac:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054af:	77 56                	ja     105507 <printnum+0xdc>
  1054b1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054b4:	72 05                	jb     1054bb <printnum+0x90>
  1054b6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1054b9:	77 4c                	ja     105507 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1054bb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1054c1:	8b 45 20             	mov    0x20(%ebp),%eax
  1054c4:	89 44 24 18          	mov    %eax,0x18(%esp)
  1054c8:	89 54 24 14          	mov    %edx,0x14(%esp)
  1054cc:	8b 45 18             	mov    0x18(%ebp),%eax
  1054cf:	89 44 24 10          	mov    %eax,0x10(%esp)
  1054d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1054d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1054e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1054eb:	89 04 24             	mov    %eax,(%esp)
  1054ee:	e8 38 ff ff ff       	call   10542b <printnum>
  1054f3:	eb 1c                	jmp    105511 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1054f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054fc:	8b 45 20             	mov    0x20(%ebp),%eax
  1054ff:	89 04 24             	mov    %eax,(%esp)
  105502:	8b 45 08             	mov    0x8(%ebp),%eax
  105505:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105507:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10550b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10550f:	7f e4                	jg     1054f5 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105511:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105514:	05 24 71 10 00       	add    $0x107124,%eax
  105519:	0f b6 00             	movzbl (%eax),%eax
  10551c:	0f be c0             	movsbl %al,%eax
  10551f:	8b 55 0c             	mov    0xc(%ebp),%edx
  105522:	89 54 24 04          	mov    %edx,0x4(%esp)
  105526:	89 04 24             	mov    %eax,(%esp)
  105529:	8b 45 08             	mov    0x8(%ebp),%eax
  10552c:	ff d0                	call   *%eax
}
  10552e:	c9                   	leave  
  10552f:	c3                   	ret    

00105530 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105530:	55                   	push   %ebp
  105531:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105533:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105537:	7e 14                	jle    10554d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105539:	8b 45 08             	mov    0x8(%ebp),%eax
  10553c:	8b 00                	mov    (%eax),%eax
  10553e:	8d 48 08             	lea    0x8(%eax),%ecx
  105541:	8b 55 08             	mov    0x8(%ebp),%edx
  105544:	89 0a                	mov    %ecx,(%edx)
  105546:	8b 50 04             	mov    0x4(%eax),%edx
  105549:	8b 00                	mov    (%eax),%eax
  10554b:	eb 30                	jmp    10557d <getuint+0x4d>
    }
    else if (lflag) {
  10554d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105551:	74 16                	je     105569 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105553:	8b 45 08             	mov    0x8(%ebp),%eax
  105556:	8b 00                	mov    (%eax),%eax
  105558:	8d 48 04             	lea    0x4(%eax),%ecx
  10555b:	8b 55 08             	mov    0x8(%ebp),%edx
  10555e:	89 0a                	mov    %ecx,(%edx)
  105560:	8b 00                	mov    (%eax),%eax
  105562:	ba 00 00 00 00       	mov    $0x0,%edx
  105567:	eb 14                	jmp    10557d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105569:	8b 45 08             	mov    0x8(%ebp),%eax
  10556c:	8b 00                	mov    (%eax),%eax
  10556e:	8d 48 04             	lea    0x4(%eax),%ecx
  105571:	8b 55 08             	mov    0x8(%ebp),%edx
  105574:	89 0a                	mov    %ecx,(%edx)
  105576:	8b 00                	mov    (%eax),%eax
  105578:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10557d:	5d                   	pop    %ebp
  10557e:	c3                   	ret    

0010557f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10557f:	55                   	push   %ebp
  105580:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105582:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105586:	7e 14                	jle    10559c <getint+0x1d>
        return va_arg(*ap, long long);
  105588:	8b 45 08             	mov    0x8(%ebp),%eax
  10558b:	8b 00                	mov    (%eax),%eax
  10558d:	8d 48 08             	lea    0x8(%eax),%ecx
  105590:	8b 55 08             	mov    0x8(%ebp),%edx
  105593:	89 0a                	mov    %ecx,(%edx)
  105595:	8b 50 04             	mov    0x4(%eax),%edx
  105598:	8b 00                	mov    (%eax),%eax
  10559a:	eb 28                	jmp    1055c4 <getint+0x45>
    }
    else if (lflag) {
  10559c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055a0:	74 12                	je     1055b4 <getint+0x35>
        return va_arg(*ap, long);
  1055a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a5:	8b 00                	mov    (%eax),%eax
  1055a7:	8d 48 04             	lea    0x4(%eax),%ecx
  1055aa:	8b 55 08             	mov    0x8(%ebp),%edx
  1055ad:	89 0a                	mov    %ecx,(%edx)
  1055af:	8b 00                	mov    (%eax),%eax
  1055b1:	99                   	cltd   
  1055b2:	eb 10                	jmp    1055c4 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1055b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1055b7:	8b 00                	mov    (%eax),%eax
  1055b9:	8d 48 04             	lea    0x4(%eax),%ecx
  1055bc:	8b 55 08             	mov    0x8(%ebp),%edx
  1055bf:	89 0a                	mov    %ecx,(%edx)
  1055c1:	8b 00                	mov    (%eax),%eax
  1055c3:	99                   	cltd   
    }
}
  1055c4:	5d                   	pop    %ebp
  1055c5:	c3                   	ret    

001055c6 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1055c6:	55                   	push   %ebp
  1055c7:	89 e5                	mov    %esp,%ebp
  1055c9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1055cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1055cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1055d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1055d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1055dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ea:	89 04 24             	mov    %eax,(%esp)
  1055ed:	e8 02 00 00 00       	call   1055f4 <vprintfmt>
    va_end(ap);
}
  1055f2:	c9                   	leave  
  1055f3:	c3                   	ret    

001055f4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1055f4:	55                   	push   %ebp
  1055f5:	89 e5                	mov    %esp,%ebp
  1055f7:	56                   	push   %esi
  1055f8:	53                   	push   %ebx
  1055f9:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1055fc:	eb 18                	jmp    105616 <vprintfmt+0x22>
            if (ch == '\0') {
  1055fe:	85 db                	test   %ebx,%ebx
  105600:	75 05                	jne    105607 <vprintfmt+0x13>
                return;
  105602:	e9 d1 03 00 00       	jmp    1059d8 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105607:	8b 45 0c             	mov    0xc(%ebp),%eax
  10560a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10560e:	89 1c 24             	mov    %ebx,(%esp)
  105611:	8b 45 08             	mov    0x8(%ebp),%eax
  105614:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105616:	8b 45 10             	mov    0x10(%ebp),%eax
  105619:	8d 50 01             	lea    0x1(%eax),%edx
  10561c:	89 55 10             	mov    %edx,0x10(%ebp)
  10561f:	0f b6 00             	movzbl (%eax),%eax
  105622:	0f b6 d8             	movzbl %al,%ebx
  105625:	83 fb 25             	cmp    $0x25,%ebx
  105628:	75 d4                	jne    1055fe <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  10562a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10562e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105638:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10563b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105642:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105645:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105648:	8b 45 10             	mov    0x10(%ebp),%eax
  10564b:	8d 50 01             	lea    0x1(%eax),%edx
  10564e:	89 55 10             	mov    %edx,0x10(%ebp)
  105651:	0f b6 00             	movzbl (%eax),%eax
  105654:	0f b6 d8             	movzbl %al,%ebx
  105657:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10565a:	83 f8 55             	cmp    $0x55,%eax
  10565d:	0f 87 44 03 00 00    	ja     1059a7 <vprintfmt+0x3b3>
  105663:	8b 04 85 48 71 10 00 	mov    0x107148(,%eax,4),%eax
  10566a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10566c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105670:	eb d6                	jmp    105648 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105672:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105676:	eb d0                	jmp    105648 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105678:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10567f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105682:	89 d0                	mov    %edx,%eax
  105684:	c1 e0 02             	shl    $0x2,%eax
  105687:	01 d0                	add    %edx,%eax
  105689:	01 c0                	add    %eax,%eax
  10568b:	01 d8                	add    %ebx,%eax
  10568d:	83 e8 30             	sub    $0x30,%eax
  105690:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105693:	8b 45 10             	mov    0x10(%ebp),%eax
  105696:	0f b6 00             	movzbl (%eax),%eax
  105699:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10569c:	83 fb 2f             	cmp    $0x2f,%ebx
  10569f:	7e 0b                	jle    1056ac <vprintfmt+0xb8>
  1056a1:	83 fb 39             	cmp    $0x39,%ebx
  1056a4:	7f 06                	jg     1056ac <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056a6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1056aa:	eb d3                	jmp    10567f <vprintfmt+0x8b>
            goto process_precision;
  1056ac:	eb 33                	jmp    1056e1 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1056ae:	8b 45 14             	mov    0x14(%ebp),%eax
  1056b1:	8d 50 04             	lea    0x4(%eax),%edx
  1056b4:	89 55 14             	mov    %edx,0x14(%ebp)
  1056b7:	8b 00                	mov    (%eax),%eax
  1056b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1056bc:	eb 23                	jmp    1056e1 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1056be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056c2:	79 0c                	jns    1056d0 <vprintfmt+0xdc>
                width = 0;
  1056c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1056cb:	e9 78 ff ff ff       	jmp    105648 <vprintfmt+0x54>
  1056d0:	e9 73 ff ff ff       	jmp    105648 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1056d5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1056dc:	e9 67 ff ff ff       	jmp    105648 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1056e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056e5:	79 12                	jns    1056f9 <vprintfmt+0x105>
                width = precision, precision = -1;
  1056e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1056ed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1056f4:	e9 4f ff ff ff       	jmp    105648 <vprintfmt+0x54>
  1056f9:	e9 4a ff ff ff       	jmp    105648 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1056fe:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105702:	e9 41 ff ff ff       	jmp    105648 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105707:	8b 45 14             	mov    0x14(%ebp),%eax
  10570a:	8d 50 04             	lea    0x4(%eax),%edx
  10570d:	89 55 14             	mov    %edx,0x14(%ebp)
  105710:	8b 00                	mov    (%eax),%eax
  105712:	8b 55 0c             	mov    0xc(%ebp),%edx
  105715:	89 54 24 04          	mov    %edx,0x4(%esp)
  105719:	89 04 24             	mov    %eax,(%esp)
  10571c:	8b 45 08             	mov    0x8(%ebp),%eax
  10571f:	ff d0                	call   *%eax
            break;
  105721:	e9 ac 02 00 00       	jmp    1059d2 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105726:	8b 45 14             	mov    0x14(%ebp),%eax
  105729:	8d 50 04             	lea    0x4(%eax),%edx
  10572c:	89 55 14             	mov    %edx,0x14(%ebp)
  10572f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105731:	85 db                	test   %ebx,%ebx
  105733:	79 02                	jns    105737 <vprintfmt+0x143>
                err = -err;
  105735:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105737:	83 fb 06             	cmp    $0x6,%ebx
  10573a:	7f 0b                	jg     105747 <vprintfmt+0x153>
  10573c:	8b 34 9d 08 71 10 00 	mov    0x107108(,%ebx,4),%esi
  105743:	85 f6                	test   %esi,%esi
  105745:	75 23                	jne    10576a <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105747:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10574b:	c7 44 24 08 35 71 10 	movl   $0x107135,0x8(%esp)
  105752:	00 
  105753:	8b 45 0c             	mov    0xc(%ebp),%eax
  105756:	89 44 24 04          	mov    %eax,0x4(%esp)
  10575a:	8b 45 08             	mov    0x8(%ebp),%eax
  10575d:	89 04 24             	mov    %eax,(%esp)
  105760:	e8 61 fe ff ff       	call   1055c6 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105765:	e9 68 02 00 00       	jmp    1059d2 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10576a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10576e:	c7 44 24 08 3e 71 10 	movl   $0x10713e,0x8(%esp)
  105775:	00 
  105776:	8b 45 0c             	mov    0xc(%ebp),%eax
  105779:	89 44 24 04          	mov    %eax,0x4(%esp)
  10577d:	8b 45 08             	mov    0x8(%ebp),%eax
  105780:	89 04 24             	mov    %eax,(%esp)
  105783:	e8 3e fe ff ff       	call   1055c6 <printfmt>
            }
            break;
  105788:	e9 45 02 00 00       	jmp    1059d2 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10578d:	8b 45 14             	mov    0x14(%ebp),%eax
  105790:	8d 50 04             	lea    0x4(%eax),%edx
  105793:	89 55 14             	mov    %edx,0x14(%ebp)
  105796:	8b 30                	mov    (%eax),%esi
  105798:	85 f6                	test   %esi,%esi
  10579a:	75 05                	jne    1057a1 <vprintfmt+0x1ad>
                p = "(null)";
  10579c:	be 41 71 10 00       	mov    $0x107141,%esi
            }
            if (width > 0 && padc != '-') {
  1057a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057a5:	7e 3e                	jle    1057e5 <vprintfmt+0x1f1>
  1057a7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1057ab:	74 38                	je     1057e5 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057ad:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1057b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057b7:	89 34 24             	mov    %esi,(%esp)
  1057ba:	e8 15 03 00 00       	call   105ad4 <strnlen>
  1057bf:	29 c3                	sub    %eax,%ebx
  1057c1:	89 d8                	mov    %ebx,%eax
  1057c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057c6:	eb 17                	jmp    1057df <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1057c8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1057cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057cf:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057d3:	89 04 24             	mov    %eax,(%esp)
  1057d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d9:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057db:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057e3:	7f e3                	jg     1057c8 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1057e5:	eb 38                	jmp    10581f <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1057e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1057eb:	74 1f                	je     10580c <vprintfmt+0x218>
  1057ed:	83 fb 1f             	cmp    $0x1f,%ebx
  1057f0:	7e 05                	jle    1057f7 <vprintfmt+0x203>
  1057f2:	83 fb 7e             	cmp    $0x7e,%ebx
  1057f5:	7e 15                	jle    10580c <vprintfmt+0x218>
                    putch('?', putdat);
  1057f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057fe:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105805:	8b 45 08             	mov    0x8(%ebp),%eax
  105808:	ff d0                	call   *%eax
  10580a:	eb 0f                	jmp    10581b <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  10580c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10580f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105813:	89 1c 24             	mov    %ebx,(%esp)
  105816:	8b 45 08             	mov    0x8(%ebp),%eax
  105819:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10581b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10581f:	89 f0                	mov    %esi,%eax
  105821:	8d 70 01             	lea    0x1(%eax),%esi
  105824:	0f b6 00             	movzbl (%eax),%eax
  105827:	0f be d8             	movsbl %al,%ebx
  10582a:	85 db                	test   %ebx,%ebx
  10582c:	74 10                	je     10583e <vprintfmt+0x24a>
  10582e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105832:	78 b3                	js     1057e7 <vprintfmt+0x1f3>
  105834:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105838:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10583c:	79 a9                	jns    1057e7 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10583e:	eb 17                	jmp    105857 <vprintfmt+0x263>
                putch(' ', putdat);
  105840:	8b 45 0c             	mov    0xc(%ebp),%eax
  105843:	89 44 24 04          	mov    %eax,0x4(%esp)
  105847:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10584e:	8b 45 08             	mov    0x8(%ebp),%eax
  105851:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105853:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105857:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10585b:	7f e3                	jg     105840 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  10585d:	e9 70 01 00 00       	jmp    1059d2 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105862:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105865:	89 44 24 04          	mov    %eax,0x4(%esp)
  105869:	8d 45 14             	lea    0x14(%ebp),%eax
  10586c:	89 04 24             	mov    %eax,(%esp)
  10586f:	e8 0b fd ff ff       	call   10557f <getint>
  105874:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105877:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10587a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10587d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105880:	85 d2                	test   %edx,%edx
  105882:	79 26                	jns    1058aa <vprintfmt+0x2b6>
                putch('-', putdat);
  105884:	8b 45 0c             	mov    0xc(%ebp),%eax
  105887:	89 44 24 04          	mov    %eax,0x4(%esp)
  10588b:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105892:	8b 45 08             	mov    0x8(%ebp),%eax
  105895:	ff d0                	call   *%eax
                num = -(long long)num;
  105897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10589a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10589d:	f7 d8                	neg    %eax
  10589f:	83 d2 00             	adc    $0x0,%edx
  1058a2:	f7 da                	neg    %edx
  1058a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1058aa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058b1:	e9 a8 00 00 00       	jmp    10595e <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1058b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058bd:	8d 45 14             	lea    0x14(%ebp),%eax
  1058c0:	89 04 24             	mov    %eax,(%esp)
  1058c3:	e8 68 fc ff ff       	call   105530 <getuint>
  1058c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1058ce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058d5:	e9 84 00 00 00       	jmp    10595e <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1058da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058e1:	8d 45 14             	lea    0x14(%ebp),%eax
  1058e4:	89 04 24             	mov    %eax,(%esp)
  1058e7:	e8 44 fc ff ff       	call   105530 <getuint>
  1058ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1058f2:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1058f9:	eb 63                	jmp    10595e <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1058fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  105902:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105909:	8b 45 08             	mov    0x8(%ebp),%eax
  10590c:	ff d0                	call   *%eax
            putch('x', putdat);
  10590e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105911:	89 44 24 04          	mov    %eax,0x4(%esp)
  105915:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10591c:	8b 45 08             	mov    0x8(%ebp),%eax
  10591f:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105921:	8b 45 14             	mov    0x14(%ebp),%eax
  105924:	8d 50 04             	lea    0x4(%eax),%edx
  105927:	89 55 14             	mov    %edx,0x14(%ebp)
  10592a:	8b 00                	mov    (%eax),%eax
  10592c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10592f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105936:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10593d:	eb 1f                	jmp    10595e <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10593f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105942:	89 44 24 04          	mov    %eax,0x4(%esp)
  105946:	8d 45 14             	lea    0x14(%ebp),%eax
  105949:	89 04 24             	mov    %eax,(%esp)
  10594c:	e8 df fb ff ff       	call   105530 <getuint>
  105951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105954:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105957:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10595e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105965:	89 54 24 18          	mov    %edx,0x18(%esp)
  105969:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10596c:	89 54 24 14          	mov    %edx,0x14(%esp)
  105970:	89 44 24 10          	mov    %eax,0x10(%esp)
  105974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10597a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10597e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105982:	8b 45 0c             	mov    0xc(%ebp),%eax
  105985:	89 44 24 04          	mov    %eax,0x4(%esp)
  105989:	8b 45 08             	mov    0x8(%ebp),%eax
  10598c:	89 04 24             	mov    %eax,(%esp)
  10598f:	e8 97 fa ff ff       	call   10542b <printnum>
            break;
  105994:	eb 3c                	jmp    1059d2 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105996:	8b 45 0c             	mov    0xc(%ebp),%eax
  105999:	89 44 24 04          	mov    %eax,0x4(%esp)
  10599d:	89 1c 24             	mov    %ebx,(%esp)
  1059a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a3:	ff d0                	call   *%eax
            break;
  1059a5:	eb 2b                	jmp    1059d2 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1059a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1059b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b8:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1059ba:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059be:	eb 04                	jmp    1059c4 <vprintfmt+0x3d0>
  1059c0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1059c7:	83 e8 01             	sub    $0x1,%eax
  1059ca:	0f b6 00             	movzbl (%eax),%eax
  1059cd:	3c 25                	cmp    $0x25,%al
  1059cf:	75 ef                	jne    1059c0 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1059d1:	90                   	nop
        }
    }
  1059d2:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1059d3:	e9 3e fc ff ff       	jmp    105616 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1059d8:	83 c4 40             	add    $0x40,%esp
  1059db:	5b                   	pop    %ebx
  1059dc:	5e                   	pop    %esi
  1059dd:	5d                   	pop    %ebp
  1059de:	c3                   	ret    

001059df <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1059df:	55                   	push   %ebp
  1059e0:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1059e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059e5:	8b 40 08             	mov    0x8(%eax),%eax
  1059e8:	8d 50 01             	lea    0x1(%eax),%edx
  1059eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ee:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1059f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f4:	8b 10                	mov    (%eax),%edx
  1059f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f9:	8b 40 04             	mov    0x4(%eax),%eax
  1059fc:	39 c2                	cmp    %eax,%edx
  1059fe:	73 12                	jae    105a12 <sprintputch+0x33>
        *b->buf ++ = ch;
  105a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a03:	8b 00                	mov    (%eax),%eax
  105a05:	8d 48 01             	lea    0x1(%eax),%ecx
  105a08:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a0b:	89 0a                	mov    %ecx,(%edx)
  105a0d:	8b 55 08             	mov    0x8(%ebp),%edx
  105a10:	88 10                	mov    %dl,(%eax)
    }
}
  105a12:	5d                   	pop    %ebp
  105a13:	c3                   	ret    

00105a14 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105a14:	55                   	push   %ebp
  105a15:	89 e5                	mov    %esp,%ebp
  105a17:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105a1a:	8d 45 14             	lea    0x14(%ebp),%eax
  105a1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a27:	8b 45 10             	mov    0x10(%ebp),%eax
  105a2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a31:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a35:	8b 45 08             	mov    0x8(%ebp),%eax
  105a38:	89 04 24             	mov    %eax,(%esp)
  105a3b:	e8 08 00 00 00       	call   105a48 <vsnprintf>
  105a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a46:	c9                   	leave  
  105a47:	c3                   	ret    

00105a48 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105a48:	55                   	push   %ebp
  105a49:	89 e5                	mov    %esp,%ebp
  105a4b:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105a51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a57:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a5d:	01 d0                	add    %edx,%eax
  105a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105a69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a6d:	74 0a                	je     105a79 <vsnprintf+0x31>
  105a6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a75:	39 c2                	cmp    %eax,%edx
  105a77:	76 07                	jbe    105a80 <vsnprintf+0x38>
        return -E_INVAL;
  105a79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105a7e:	eb 2a                	jmp    105aaa <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105a80:	8b 45 14             	mov    0x14(%ebp),%eax
  105a83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a87:	8b 45 10             	mov    0x10(%ebp),%eax
  105a8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105a91:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a95:	c7 04 24 df 59 10 00 	movl   $0x1059df,(%esp)
  105a9c:	e8 53 fb ff ff       	call   1055f4 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105aa4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105aaa:	c9                   	leave  
  105aab:	c3                   	ret    

00105aac <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105aac:	55                   	push   %ebp
  105aad:	89 e5                	mov    %esp,%ebp
  105aaf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ab2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105ab9:	eb 04                	jmp    105abf <strlen+0x13>
        cnt ++;
  105abb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105abf:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac2:	8d 50 01             	lea    0x1(%eax),%edx
  105ac5:	89 55 08             	mov    %edx,0x8(%ebp)
  105ac8:	0f b6 00             	movzbl (%eax),%eax
  105acb:	84 c0                	test   %al,%al
  105acd:	75 ec                	jne    105abb <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105acf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105ad2:	c9                   	leave  
  105ad3:	c3                   	ret    

00105ad4 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105ad4:	55                   	push   %ebp
  105ad5:	89 e5                	mov    %esp,%ebp
  105ad7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ada:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105ae1:	eb 04                	jmp    105ae7 <strnlen+0x13>
        cnt ++;
  105ae3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105ae7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105aea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105aed:	73 10                	jae    105aff <strnlen+0x2b>
  105aef:	8b 45 08             	mov    0x8(%ebp),%eax
  105af2:	8d 50 01             	lea    0x1(%eax),%edx
  105af5:	89 55 08             	mov    %edx,0x8(%ebp)
  105af8:	0f b6 00             	movzbl (%eax),%eax
  105afb:	84 c0                	test   %al,%al
  105afd:	75 e4                	jne    105ae3 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105aff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b02:	c9                   	leave  
  105b03:	c3                   	ret    

00105b04 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105b04:	55                   	push   %ebp
  105b05:	89 e5                	mov    %esp,%ebp
  105b07:	57                   	push   %edi
  105b08:	56                   	push   %esi
  105b09:	83 ec 20             	sub    $0x20,%esp
  105b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b15:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105b18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b1e:	89 d1                	mov    %edx,%ecx
  105b20:	89 c2                	mov    %eax,%edx
  105b22:	89 ce                	mov    %ecx,%esi
  105b24:	89 d7                	mov    %edx,%edi
  105b26:	ac                   	lods   %ds:(%esi),%al
  105b27:	aa                   	stos   %al,%es:(%edi)
  105b28:	84 c0                	test   %al,%al
  105b2a:	75 fa                	jne    105b26 <strcpy+0x22>
  105b2c:	89 fa                	mov    %edi,%edx
  105b2e:	89 f1                	mov    %esi,%ecx
  105b30:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b33:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105b3c:	83 c4 20             	add    $0x20,%esp
  105b3f:	5e                   	pop    %esi
  105b40:	5f                   	pop    %edi
  105b41:	5d                   	pop    %ebp
  105b42:	c3                   	ret    

00105b43 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105b43:	55                   	push   %ebp
  105b44:	89 e5                	mov    %esp,%ebp
  105b46:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105b49:	8b 45 08             	mov    0x8(%ebp),%eax
  105b4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105b4f:	eb 21                	jmp    105b72 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b54:	0f b6 10             	movzbl (%eax),%edx
  105b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b5a:	88 10                	mov    %dl,(%eax)
  105b5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b5f:	0f b6 00             	movzbl (%eax),%eax
  105b62:	84 c0                	test   %al,%al
  105b64:	74 04                	je     105b6a <strncpy+0x27>
            src ++;
  105b66:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105b6a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105b6e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105b72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b76:	75 d9                	jne    105b51 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105b78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b7b:	c9                   	leave  
  105b7c:	c3                   	ret    

00105b7d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105b7d:	55                   	push   %ebp
  105b7e:	89 e5                	mov    %esp,%ebp
  105b80:	57                   	push   %edi
  105b81:	56                   	push   %esi
  105b82:	83 ec 20             	sub    $0x20,%esp
  105b85:	8b 45 08             	mov    0x8(%ebp),%eax
  105b88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105b91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b97:	89 d1                	mov    %edx,%ecx
  105b99:	89 c2                	mov    %eax,%edx
  105b9b:	89 ce                	mov    %ecx,%esi
  105b9d:	89 d7                	mov    %edx,%edi
  105b9f:	ac                   	lods   %ds:(%esi),%al
  105ba0:	ae                   	scas   %es:(%edi),%al
  105ba1:	75 08                	jne    105bab <strcmp+0x2e>
  105ba3:	84 c0                	test   %al,%al
  105ba5:	75 f8                	jne    105b9f <strcmp+0x22>
  105ba7:	31 c0                	xor    %eax,%eax
  105ba9:	eb 04                	jmp    105baf <strcmp+0x32>
  105bab:	19 c0                	sbb    %eax,%eax
  105bad:	0c 01                	or     $0x1,%al
  105baf:	89 fa                	mov    %edi,%edx
  105bb1:	89 f1                	mov    %esi,%ecx
  105bb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105bb6:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105bb9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105bbf:	83 c4 20             	add    $0x20,%esp
  105bc2:	5e                   	pop    %esi
  105bc3:	5f                   	pop    %edi
  105bc4:	5d                   	pop    %ebp
  105bc5:	c3                   	ret    

00105bc6 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105bc6:	55                   	push   %ebp
  105bc7:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bc9:	eb 0c                	jmp    105bd7 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105bcb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105bcf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bd3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bdb:	74 1a                	je     105bf7 <strncmp+0x31>
  105bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  105be0:	0f b6 00             	movzbl (%eax),%eax
  105be3:	84 c0                	test   %al,%al
  105be5:	74 10                	je     105bf7 <strncmp+0x31>
  105be7:	8b 45 08             	mov    0x8(%ebp),%eax
  105bea:	0f b6 10             	movzbl (%eax),%edx
  105bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bf0:	0f b6 00             	movzbl (%eax),%eax
  105bf3:	38 c2                	cmp    %al,%dl
  105bf5:	74 d4                	je     105bcb <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105bf7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bfb:	74 18                	je     105c15 <strncmp+0x4f>
  105bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  105c00:	0f b6 00             	movzbl (%eax),%eax
  105c03:	0f b6 d0             	movzbl %al,%edx
  105c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c09:	0f b6 00             	movzbl (%eax),%eax
  105c0c:	0f b6 c0             	movzbl %al,%eax
  105c0f:	29 c2                	sub    %eax,%edx
  105c11:	89 d0                	mov    %edx,%eax
  105c13:	eb 05                	jmp    105c1a <strncmp+0x54>
  105c15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c1a:	5d                   	pop    %ebp
  105c1b:	c3                   	ret    

00105c1c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105c1c:	55                   	push   %ebp
  105c1d:	89 e5                	mov    %esp,%ebp
  105c1f:	83 ec 04             	sub    $0x4,%esp
  105c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c25:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c28:	eb 14                	jmp    105c3e <strchr+0x22>
        if (*s == c) {
  105c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  105c2d:	0f b6 00             	movzbl (%eax),%eax
  105c30:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c33:	75 05                	jne    105c3a <strchr+0x1e>
            return (char *)s;
  105c35:	8b 45 08             	mov    0x8(%ebp),%eax
  105c38:	eb 13                	jmp    105c4d <strchr+0x31>
        }
        s ++;
  105c3a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  105c41:	0f b6 00             	movzbl (%eax),%eax
  105c44:	84 c0                	test   %al,%al
  105c46:	75 e2                	jne    105c2a <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c4d:	c9                   	leave  
  105c4e:	c3                   	ret    

00105c4f <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105c4f:	55                   	push   %ebp
  105c50:	89 e5                	mov    %esp,%ebp
  105c52:	83 ec 04             	sub    $0x4,%esp
  105c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c58:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c5b:	eb 11                	jmp    105c6e <strfind+0x1f>
        if (*s == c) {
  105c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c60:	0f b6 00             	movzbl (%eax),%eax
  105c63:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c66:	75 02                	jne    105c6a <strfind+0x1b>
            break;
  105c68:	eb 0e                	jmp    105c78 <strfind+0x29>
        }
        s ++;
  105c6a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  105c71:	0f b6 00             	movzbl (%eax),%eax
  105c74:	84 c0                	test   %al,%al
  105c76:	75 e5                	jne    105c5d <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105c78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c7b:	c9                   	leave  
  105c7c:	c3                   	ret    

00105c7d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105c7d:	55                   	push   %ebp
  105c7e:	89 e5                	mov    %esp,%ebp
  105c80:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105c83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105c8a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c91:	eb 04                	jmp    105c97 <strtol+0x1a>
        s ++;
  105c93:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c97:	8b 45 08             	mov    0x8(%ebp),%eax
  105c9a:	0f b6 00             	movzbl (%eax),%eax
  105c9d:	3c 20                	cmp    $0x20,%al
  105c9f:	74 f2                	je     105c93 <strtol+0x16>
  105ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca4:	0f b6 00             	movzbl (%eax),%eax
  105ca7:	3c 09                	cmp    $0x9,%al
  105ca9:	74 e8                	je     105c93 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105cab:	8b 45 08             	mov    0x8(%ebp),%eax
  105cae:	0f b6 00             	movzbl (%eax),%eax
  105cb1:	3c 2b                	cmp    $0x2b,%al
  105cb3:	75 06                	jne    105cbb <strtol+0x3e>
        s ++;
  105cb5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cb9:	eb 15                	jmp    105cd0 <strtol+0x53>
    }
    else if (*s == '-') {
  105cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  105cbe:	0f b6 00             	movzbl (%eax),%eax
  105cc1:	3c 2d                	cmp    $0x2d,%al
  105cc3:	75 0b                	jne    105cd0 <strtol+0x53>
        s ++, neg = 1;
  105cc5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cc9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105cd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cd4:	74 06                	je     105cdc <strtol+0x5f>
  105cd6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105cda:	75 24                	jne    105d00 <strtol+0x83>
  105cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  105cdf:	0f b6 00             	movzbl (%eax),%eax
  105ce2:	3c 30                	cmp    $0x30,%al
  105ce4:	75 1a                	jne    105d00 <strtol+0x83>
  105ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce9:	83 c0 01             	add    $0x1,%eax
  105cec:	0f b6 00             	movzbl (%eax),%eax
  105cef:	3c 78                	cmp    $0x78,%al
  105cf1:	75 0d                	jne    105d00 <strtol+0x83>
        s += 2, base = 16;
  105cf3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105cf7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105cfe:	eb 2a                	jmp    105d2a <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d04:	75 17                	jne    105d1d <strtol+0xa0>
  105d06:	8b 45 08             	mov    0x8(%ebp),%eax
  105d09:	0f b6 00             	movzbl (%eax),%eax
  105d0c:	3c 30                	cmp    $0x30,%al
  105d0e:	75 0d                	jne    105d1d <strtol+0xa0>
        s ++, base = 8;
  105d10:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d14:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105d1b:	eb 0d                	jmp    105d2a <strtol+0xad>
    }
    else if (base == 0) {
  105d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d21:	75 07                	jne    105d2a <strtol+0xad>
        base = 10;
  105d23:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d2d:	0f b6 00             	movzbl (%eax),%eax
  105d30:	3c 2f                	cmp    $0x2f,%al
  105d32:	7e 1b                	jle    105d4f <strtol+0xd2>
  105d34:	8b 45 08             	mov    0x8(%ebp),%eax
  105d37:	0f b6 00             	movzbl (%eax),%eax
  105d3a:	3c 39                	cmp    $0x39,%al
  105d3c:	7f 11                	jg     105d4f <strtol+0xd2>
            dig = *s - '0';
  105d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d41:	0f b6 00             	movzbl (%eax),%eax
  105d44:	0f be c0             	movsbl %al,%eax
  105d47:	83 e8 30             	sub    $0x30,%eax
  105d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d4d:	eb 48                	jmp    105d97 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d52:	0f b6 00             	movzbl (%eax),%eax
  105d55:	3c 60                	cmp    $0x60,%al
  105d57:	7e 1b                	jle    105d74 <strtol+0xf7>
  105d59:	8b 45 08             	mov    0x8(%ebp),%eax
  105d5c:	0f b6 00             	movzbl (%eax),%eax
  105d5f:	3c 7a                	cmp    $0x7a,%al
  105d61:	7f 11                	jg     105d74 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105d63:	8b 45 08             	mov    0x8(%ebp),%eax
  105d66:	0f b6 00             	movzbl (%eax),%eax
  105d69:	0f be c0             	movsbl %al,%eax
  105d6c:	83 e8 57             	sub    $0x57,%eax
  105d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d72:	eb 23                	jmp    105d97 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105d74:	8b 45 08             	mov    0x8(%ebp),%eax
  105d77:	0f b6 00             	movzbl (%eax),%eax
  105d7a:	3c 40                	cmp    $0x40,%al
  105d7c:	7e 3d                	jle    105dbb <strtol+0x13e>
  105d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d81:	0f b6 00             	movzbl (%eax),%eax
  105d84:	3c 5a                	cmp    $0x5a,%al
  105d86:	7f 33                	jg     105dbb <strtol+0x13e>
            dig = *s - 'A' + 10;
  105d88:	8b 45 08             	mov    0x8(%ebp),%eax
  105d8b:	0f b6 00             	movzbl (%eax),%eax
  105d8e:	0f be c0             	movsbl %al,%eax
  105d91:	83 e8 37             	sub    $0x37,%eax
  105d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d9a:	3b 45 10             	cmp    0x10(%ebp),%eax
  105d9d:	7c 02                	jl     105da1 <strtol+0x124>
            break;
  105d9f:	eb 1a                	jmp    105dbb <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105da1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105da5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105da8:	0f af 45 10          	imul   0x10(%ebp),%eax
  105dac:	89 c2                	mov    %eax,%edx
  105dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105db1:	01 d0                	add    %edx,%eax
  105db3:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105db6:	e9 6f ff ff ff       	jmp    105d2a <strtol+0xad>

    if (endptr) {
  105dbb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105dbf:	74 08                	je     105dc9 <strtol+0x14c>
        *endptr = (char *) s;
  105dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  105dc7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105dc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105dcd:	74 07                	je     105dd6 <strtol+0x159>
  105dcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dd2:	f7 d8                	neg    %eax
  105dd4:	eb 03                	jmp    105dd9 <strtol+0x15c>
  105dd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105dd9:	c9                   	leave  
  105dda:	c3                   	ret    

00105ddb <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105ddb:	55                   	push   %ebp
  105ddc:	89 e5                	mov    %esp,%ebp
  105dde:	57                   	push   %edi
  105ddf:	83 ec 24             	sub    $0x24,%esp
  105de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105de5:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105de8:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105dec:	8b 55 08             	mov    0x8(%ebp),%edx
  105def:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105df2:	88 45 f7             	mov    %al,-0x9(%ebp)
  105df5:	8b 45 10             	mov    0x10(%ebp),%eax
  105df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105dfb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105dfe:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105e02:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105e05:	89 d7                	mov    %edx,%edi
  105e07:	f3 aa                	rep stos %al,%es:(%edi)
  105e09:	89 fa                	mov    %edi,%edx
  105e0b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e0e:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105e11:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105e14:	83 c4 24             	add    $0x24,%esp
  105e17:	5f                   	pop    %edi
  105e18:	5d                   	pop    %ebp
  105e19:	c3                   	ret    

00105e1a <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105e1a:	55                   	push   %ebp
  105e1b:	89 e5                	mov    %esp,%ebp
  105e1d:	57                   	push   %edi
  105e1e:	56                   	push   %esi
  105e1f:	53                   	push   %ebx
  105e20:	83 ec 30             	sub    $0x30,%esp
  105e23:	8b 45 08             	mov    0x8(%ebp),%eax
  105e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  105e32:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e38:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105e3b:	73 42                	jae    105e7f <memmove+0x65>
  105e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e46:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e52:	c1 e8 02             	shr    $0x2,%eax
  105e55:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105e57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e5d:	89 d7                	mov    %edx,%edi
  105e5f:	89 c6                	mov    %eax,%esi
  105e61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e63:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105e66:	83 e1 03             	and    $0x3,%ecx
  105e69:	74 02                	je     105e6d <memmove+0x53>
  105e6b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e6d:	89 f0                	mov    %esi,%eax
  105e6f:	89 fa                	mov    %edi,%edx
  105e71:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105e74:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105e77:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105e7d:	eb 36                	jmp    105eb5 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105e7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e82:	8d 50 ff             	lea    -0x1(%eax),%edx
  105e85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e88:	01 c2                	add    %eax,%edx
  105e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e8d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e93:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105e96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e99:	89 c1                	mov    %eax,%ecx
  105e9b:	89 d8                	mov    %ebx,%eax
  105e9d:	89 d6                	mov    %edx,%esi
  105e9f:	89 c7                	mov    %eax,%edi
  105ea1:	fd                   	std    
  105ea2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ea4:	fc                   	cld    
  105ea5:	89 f8                	mov    %edi,%eax
  105ea7:	89 f2                	mov    %esi,%edx
  105ea9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105eac:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105eaf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105eb5:	83 c4 30             	add    $0x30,%esp
  105eb8:	5b                   	pop    %ebx
  105eb9:	5e                   	pop    %esi
  105eba:	5f                   	pop    %edi
  105ebb:	5d                   	pop    %ebp
  105ebc:	c3                   	ret    

00105ebd <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105ebd:	55                   	push   %ebp
  105ebe:	89 e5                	mov    %esp,%ebp
  105ec0:	57                   	push   %edi
  105ec1:	56                   	push   %esi
  105ec2:	83 ec 20             	sub    $0x20,%esp
  105ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ece:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  105ed4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105eda:	c1 e8 02             	shr    $0x2,%eax
  105edd:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ee5:	89 d7                	mov    %edx,%edi
  105ee7:	89 c6                	mov    %eax,%esi
  105ee9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105eeb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105eee:	83 e1 03             	and    $0x3,%ecx
  105ef1:	74 02                	je     105ef5 <memcpy+0x38>
  105ef3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ef5:	89 f0                	mov    %esi,%eax
  105ef7:	89 fa                	mov    %edi,%edx
  105ef9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105efc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105eff:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105f05:	83 c4 20             	add    $0x20,%esp
  105f08:	5e                   	pop    %esi
  105f09:	5f                   	pop    %edi
  105f0a:	5d                   	pop    %ebp
  105f0b:	c3                   	ret    

00105f0c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105f0c:	55                   	push   %ebp
  105f0d:	89 e5                	mov    %esp,%ebp
  105f0f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105f12:	8b 45 08             	mov    0x8(%ebp),%eax
  105f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105f1e:	eb 30                	jmp    105f50 <memcmp+0x44>
        if (*s1 != *s2) {
  105f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f23:	0f b6 10             	movzbl (%eax),%edx
  105f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f29:	0f b6 00             	movzbl (%eax),%eax
  105f2c:	38 c2                	cmp    %al,%dl
  105f2e:	74 18                	je     105f48 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f33:	0f b6 00             	movzbl (%eax),%eax
  105f36:	0f b6 d0             	movzbl %al,%edx
  105f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f3c:	0f b6 00             	movzbl (%eax),%eax
  105f3f:	0f b6 c0             	movzbl %al,%eax
  105f42:	29 c2                	sub    %eax,%edx
  105f44:	89 d0                	mov    %edx,%eax
  105f46:	eb 1a                	jmp    105f62 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105f48:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105f4c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105f50:	8b 45 10             	mov    0x10(%ebp),%eax
  105f53:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f56:	89 55 10             	mov    %edx,0x10(%ebp)
  105f59:	85 c0                	test   %eax,%eax
  105f5b:	75 c3                	jne    105f20 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105f5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f62:	c9                   	leave  
  105f63:	c3                   	ret    
