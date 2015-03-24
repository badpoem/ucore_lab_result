
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fd 10 00       	mov    $0x10fd80,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 bf 33 00 00       	call   1033eb <memset>

    cons_init();                // init the console
  10002c:	e8 46 15 00 00       	call   101577 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 80 35 10 00 	movl   $0x103580,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 9c 35 10 00 	movl   $0x10359c,(%esp)
  100046:	e8 d9 02 00 00       	call   100324 <cprintf>

    print_kerninfo();
  10004b:	e8 08 08 00 00       	call   100858 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8d 00 00 00       	call   1000e2 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 d7 29 00 00       	call   102a31 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 5b 16 00 00       	call   1016ba <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 ad 17 00 00       	call   101811 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 01 0d 00 00       	call   100d6a <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 ba 15 00 00       	call   101628 <intr_enable>
    asm volatile("int $8");
  10006e:	cd 08                	int    $0x8

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100070:	e8 6d 01 00 00       	call   1001e2 <lab1_switch_test>

    /* do nothing */
    while (1);
  100075:	eb fe                	jmp    100075 <kern_init+0x75>

00100077 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100077:	55                   	push   %ebp
  100078:	89 e5                	mov    %esp,%ebp
  10007a:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100084:	00 
  100085:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008c:	00 
  10008d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100094:	e8 03 0c 00 00       	call   100c9c <mon_backtrace>
}
  100099:	c9                   	leave  
  10009a:	c3                   	ret    

0010009b <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009b:	55                   	push   %ebp
  10009c:	89 e5                	mov    %esp,%ebp
  10009e:	53                   	push   %ebx
  10009f:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a8:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ae:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000ba:	89 04 24             	mov    %eax,(%esp)
  1000bd:	e8 b5 ff ff ff       	call   100077 <grade_backtrace2>
}
  1000c2:	83 c4 14             	add    $0x14,%esp
  1000c5:	5b                   	pop    %ebx
  1000c6:	5d                   	pop    %ebp
  1000c7:	c3                   	ret    

001000c8 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c8:	55                   	push   %ebp
  1000c9:	89 e5                	mov    %esp,%ebp
  1000cb:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d8:	89 04 24             	mov    %eax,(%esp)
  1000db:	e8 bb ff ff ff       	call   10009b <grade_backtrace1>
}
  1000e0:	c9                   	leave  
  1000e1:	c3                   	ret    

001000e2 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e2:	55                   	push   %ebp
  1000e3:	89 e5                	mov    %esp,%ebp
  1000e5:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e8:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000ed:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f4:	ff 
  1000f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100100:	e8 c3 ff ff ff       	call   1000c8 <grade_backtrace0>
}
  100105:	c9                   	leave  
  100106:	c3                   	ret    

00100107 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100107:	55                   	push   %ebp
  100108:	89 e5                	mov    %esp,%ebp
  10010a:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010d:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100110:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100113:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100116:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100119:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011d:	0f b7 c0             	movzwl %ax,%eax
  100120:	83 e0 03             	and    $0x3,%eax
  100123:	89 c2                	mov    %eax,%edx
  100125:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10012a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100132:	c7 04 24 a1 35 10 00 	movl   $0x1035a1,(%esp)
  100139:	e8 e6 01 00 00       	call   100324 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100142:	0f b7 d0             	movzwl %ax,%edx
  100145:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10014a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100152:	c7 04 24 af 35 10 00 	movl   $0x1035af,(%esp)
  100159:	e8 c6 01 00 00       	call   100324 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015e:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100162:	0f b7 d0             	movzwl %ax,%edx
  100165:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10016a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100172:	c7 04 24 bd 35 10 00 	movl   $0x1035bd,(%esp)
  100179:	e8 a6 01 00 00       	call   100324 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100182:	0f b7 d0             	movzwl %ax,%edx
  100185:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10018a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100192:	c7 04 24 cb 35 10 00 	movl   $0x1035cb,(%esp)
  100199:	e8 86 01 00 00       	call   100324 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a2:	0f b7 d0             	movzwl %ax,%edx
  1001a5:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b2:	c7 04 24 d9 35 10 00 	movl   $0x1035d9,(%esp)
  1001b9:	e8 66 01 00 00       	call   100324 <cprintf>
    round ++;
  1001be:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001c3:	83 c0 01             	add    $0x1,%eax
  1001c6:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001cb:	c9                   	leave  
  1001cc:	c3                   	ret    

001001cd <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cd:	55                   	push   %ebp
  1001ce:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001d0:	83 ec 08             	sub    $0x8,%esp
  1001d3:	cd 78                	int    $0x78
  1001d5:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001d7:	5d                   	pop    %ebp
  1001d8:	c3                   	ret    

001001d9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d9:	55                   	push   %ebp
  1001da:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001dc:	cd 79                	int    $0x79
  1001de:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001e0:	5d                   	pop    %ebp
  1001e1:	c3                   	ret    

001001e2 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001e2:	55                   	push   %ebp
  1001e3:	89 e5                	mov    %esp,%ebp
  1001e5:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e8:	e8 1a ff ff ff       	call   100107 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001ed:	c7 04 24 e8 35 10 00 	movl   $0x1035e8,(%esp)
  1001f4:	e8 2b 01 00 00       	call   100324 <cprintf>
    lab1_switch_to_user();
  1001f9:	e8 cf ff ff ff       	call   1001cd <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fe:	e8 04 ff ff ff       	call   100107 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100203:	c7 04 24 08 36 10 00 	movl   $0x103608,(%esp)
  10020a:	e8 15 01 00 00       	call   100324 <cprintf>
    lab1_switch_to_kernel();
  10020f:	e8 c5 ff ff ff       	call   1001d9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100214:	e8 ee fe ff ff       	call   100107 <lab1_print_cur_status>
}
  100219:	c9                   	leave  
  10021a:	c3                   	ret    

0010021b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10021b:	55                   	push   %ebp
  10021c:	89 e5                	mov    %esp,%ebp
  10021e:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100221:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100225:	74 13                	je     10023a <readline+0x1f>
        cprintf("%s", prompt);
  100227:	8b 45 08             	mov    0x8(%ebp),%eax
  10022a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10022e:	c7 04 24 27 36 10 00 	movl   $0x103627,(%esp)
  100235:	e8 ea 00 00 00       	call   100324 <cprintf>
    }
    int i = 0, c;
  10023a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100241:	e8 66 01 00 00       	call   1003ac <getchar>
  100246:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100249:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10024d:	79 07                	jns    100256 <readline+0x3b>
            return NULL;
  10024f:	b8 00 00 00 00       	mov    $0x0,%eax
  100254:	eb 79                	jmp    1002cf <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100256:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10025a:	7e 28                	jle    100284 <readline+0x69>
  10025c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100263:	7f 1f                	jg     100284 <readline+0x69>
            cputchar(c);
  100265:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100268:	89 04 24             	mov    %eax,(%esp)
  10026b:	e8 da 00 00 00       	call   10034a <cputchar>
            buf[i ++] = c;
  100270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100273:	8d 50 01             	lea    0x1(%eax),%edx
  100276:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100279:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10027c:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100282:	eb 46                	jmp    1002ca <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100284:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100288:	75 17                	jne    1002a1 <readline+0x86>
  10028a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10028e:	7e 11                	jle    1002a1 <readline+0x86>
            cputchar(c);
  100290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100293:	89 04 24             	mov    %eax,(%esp)
  100296:	e8 af 00 00 00       	call   10034a <cputchar>
            i --;
  10029b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10029f:	eb 29                	jmp    1002ca <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002a1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002a5:	74 06                	je     1002ad <readline+0x92>
  1002a7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002ab:	75 1d                	jne    1002ca <readline+0xaf>
            cputchar(c);
  1002ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b0:	89 04 24             	mov    %eax,(%esp)
  1002b3:	e8 92 00 00 00       	call   10034a <cputchar>
            buf[i] = '\0';
  1002b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002bb:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002c0:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002c3:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002c8:	eb 05                	jmp    1002cf <readline+0xb4>
        }
    }
  1002ca:	e9 72 ff ff ff       	jmp    100241 <readline+0x26>
}
  1002cf:	c9                   	leave  
  1002d0:	c3                   	ret    

001002d1 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002d1:	55                   	push   %ebp
  1002d2:	89 e5                	mov    %esp,%ebp
  1002d4:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002da:	89 04 24             	mov    %eax,(%esp)
  1002dd:	e8 c1 12 00 00       	call   1015a3 <cons_putc>
    (*cnt) ++;
  1002e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e5:	8b 00                	mov    (%eax),%eax
  1002e7:	8d 50 01             	lea    0x1(%eax),%edx
  1002ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ed:	89 10                	mov    %edx,(%eax)
}
  1002ef:	c9                   	leave  
  1002f0:	c3                   	ret    

001002f1 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002f1:	55                   	push   %ebp
  1002f2:	89 e5                	mov    %esp,%ebp
  1002f4:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  100301:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100305:	8b 45 08             	mov    0x8(%ebp),%eax
  100308:	89 44 24 08          	mov    %eax,0x8(%esp)
  10030c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10030f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100313:	c7 04 24 d1 02 10 00 	movl   $0x1002d1,(%esp)
  10031a:	e8 e5 28 00 00       	call   102c04 <vprintfmt>
    return cnt;
  10031f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100322:	c9                   	leave  
  100323:	c3                   	ret    

00100324 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100324:	55                   	push   %ebp
  100325:	89 e5                	mov    %esp,%ebp
  100327:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10032a:	8d 45 0c             	lea    0xc(%ebp),%eax
  10032d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100333:	89 44 24 04          	mov    %eax,0x4(%esp)
  100337:	8b 45 08             	mov    0x8(%ebp),%eax
  10033a:	89 04 24             	mov    %eax,(%esp)
  10033d:	e8 af ff ff ff       	call   1002f1 <vcprintf>
  100342:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100345:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100348:	c9                   	leave  
  100349:	c3                   	ret    

0010034a <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10034a:	55                   	push   %ebp
  10034b:	89 e5                	mov    %esp,%ebp
  10034d:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100350:	8b 45 08             	mov    0x8(%ebp),%eax
  100353:	89 04 24             	mov    %eax,(%esp)
  100356:	e8 48 12 00 00       	call   1015a3 <cons_putc>
}
  10035b:	c9                   	leave  
  10035c:	c3                   	ret    

0010035d <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10035d:	55                   	push   %ebp
  10035e:	89 e5                	mov    %esp,%ebp
  100360:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100363:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10036a:	eb 13                	jmp    10037f <cputs+0x22>
        cputch(c, &cnt);
  10036c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100370:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100373:	89 54 24 04          	mov    %edx,0x4(%esp)
  100377:	89 04 24             	mov    %eax,(%esp)
  10037a:	e8 52 ff ff ff       	call   1002d1 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10037f:	8b 45 08             	mov    0x8(%ebp),%eax
  100382:	8d 50 01             	lea    0x1(%eax),%edx
  100385:	89 55 08             	mov    %edx,0x8(%ebp)
  100388:	0f b6 00             	movzbl (%eax),%eax
  10038b:	88 45 f7             	mov    %al,-0x9(%ebp)
  10038e:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100392:	75 d8                	jne    10036c <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100394:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100397:	89 44 24 04          	mov    %eax,0x4(%esp)
  10039b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003a2:	e8 2a ff ff ff       	call   1002d1 <cputch>
    return cnt;
  1003a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003aa:	c9                   	leave  
  1003ab:	c3                   	ret    

001003ac <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003ac:	55                   	push   %ebp
  1003ad:	89 e5                	mov    %esp,%ebp
  1003af:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003b2:	e8 15 12 00 00       	call   1015cc <cons_getc>
  1003b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003be:	74 f2                	je     1003b2 <getchar+0x6>
        /* do nothing */;
    return c;
  1003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003c3:	c9                   	leave  
  1003c4:	c3                   	ret    

001003c5 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003c5:	55                   	push   %ebp
  1003c6:	89 e5                	mov    %esp,%ebp
  1003c8:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003ce:	8b 00                	mov    (%eax),%eax
  1003d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1003d6:	8b 00                	mov    (%eax),%eax
  1003d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003e2:	e9 d2 00 00 00       	jmp    1004b9 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003ed:	01 d0                	add    %edx,%eax
  1003ef:	89 c2                	mov    %eax,%edx
  1003f1:	c1 ea 1f             	shr    $0x1f,%edx
  1003f4:	01 d0                	add    %edx,%eax
  1003f6:	d1 f8                	sar    %eax
  1003f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003fe:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100401:	eb 04                	jmp    100407 <stab_binsearch+0x42>
            m --;
  100403:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10040a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10040d:	7c 1f                	jl     10042e <stab_binsearch+0x69>
  10040f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100412:	89 d0                	mov    %edx,%eax
  100414:	01 c0                	add    %eax,%eax
  100416:	01 d0                	add    %edx,%eax
  100418:	c1 e0 02             	shl    $0x2,%eax
  10041b:	89 c2                	mov    %eax,%edx
  10041d:	8b 45 08             	mov    0x8(%ebp),%eax
  100420:	01 d0                	add    %edx,%eax
  100422:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100426:	0f b6 c0             	movzbl %al,%eax
  100429:	3b 45 14             	cmp    0x14(%ebp),%eax
  10042c:	75 d5                	jne    100403 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100431:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100434:	7d 0b                	jge    100441 <stab_binsearch+0x7c>
            l = true_m + 1;
  100436:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100439:	83 c0 01             	add    $0x1,%eax
  10043c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10043f:	eb 78                	jmp    1004b9 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100441:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100448:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10044b:	89 d0                	mov    %edx,%eax
  10044d:	01 c0                	add    %eax,%eax
  10044f:	01 d0                	add    %edx,%eax
  100451:	c1 e0 02             	shl    $0x2,%eax
  100454:	89 c2                	mov    %eax,%edx
  100456:	8b 45 08             	mov    0x8(%ebp),%eax
  100459:	01 d0                	add    %edx,%eax
  10045b:	8b 40 08             	mov    0x8(%eax),%eax
  10045e:	3b 45 18             	cmp    0x18(%ebp),%eax
  100461:	73 13                	jae    100476 <stab_binsearch+0xb1>
            *region_left = m;
  100463:	8b 45 0c             	mov    0xc(%ebp),%eax
  100466:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100469:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10046b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10046e:	83 c0 01             	add    $0x1,%eax
  100471:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100474:	eb 43                	jmp    1004b9 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100476:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100479:	89 d0                	mov    %edx,%eax
  10047b:	01 c0                	add    %eax,%eax
  10047d:	01 d0                	add    %edx,%eax
  10047f:	c1 e0 02             	shl    $0x2,%eax
  100482:	89 c2                	mov    %eax,%edx
  100484:	8b 45 08             	mov    0x8(%ebp),%eax
  100487:	01 d0                	add    %edx,%eax
  100489:	8b 40 08             	mov    0x8(%eax),%eax
  10048c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10048f:	76 16                	jbe    1004a7 <stab_binsearch+0xe2>
            *region_right = m - 1;
  100491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100494:	8d 50 ff             	lea    -0x1(%eax),%edx
  100497:	8b 45 10             	mov    0x10(%ebp),%eax
  10049a:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10049f:	83 e8 01             	sub    $0x1,%eax
  1004a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a5:	eb 12                	jmp    1004b9 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ad:	89 10                	mov    %edx,(%eax)
            l = m;
  1004af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004b5:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004bf:	0f 8e 22 ff ff ff    	jle    1003e7 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004c9:	75 0f                	jne    1004da <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ce:	8b 00                	mov    (%eax),%eax
  1004d0:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d6:	89 10                	mov    %edx,(%eax)
  1004d8:	eb 3f                	jmp    100519 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004da:	8b 45 10             	mov    0x10(%ebp),%eax
  1004dd:	8b 00                	mov    (%eax),%eax
  1004df:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004e2:	eb 04                	jmp    1004e8 <stab_binsearch+0x123>
  1004e4:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004eb:	8b 00                	mov    (%eax),%eax
  1004ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004f0:	7d 1f                	jge    100511 <stab_binsearch+0x14c>
  1004f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004f5:	89 d0                	mov    %edx,%eax
  1004f7:	01 c0                	add    %eax,%eax
  1004f9:	01 d0                	add    %edx,%eax
  1004fb:	c1 e0 02             	shl    $0x2,%eax
  1004fe:	89 c2                	mov    %eax,%edx
  100500:	8b 45 08             	mov    0x8(%ebp),%eax
  100503:	01 d0                	add    %edx,%eax
  100505:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100509:	0f b6 c0             	movzbl %al,%eax
  10050c:	3b 45 14             	cmp    0x14(%ebp),%eax
  10050f:	75 d3                	jne    1004e4 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100511:	8b 45 0c             	mov    0xc(%ebp),%eax
  100514:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100517:	89 10                	mov    %edx,(%eax)
    }
}
  100519:	c9                   	leave  
  10051a:	c3                   	ret    

0010051b <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10051b:	55                   	push   %ebp
  10051c:	89 e5                	mov    %esp,%ebp
  10051e:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100521:	8b 45 0c             	mov    0xc(%ebp),%eax
  100524:	c7 00 2c 36 10 00    	movl   $0x10362c,(%eax)
    info->eip_line = 0;
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100534:	8b 45 0c             	mov    0xc(%ebp),%eax
  100537:	c7 40 08 2c 36 10 00 	movl   $0x10362c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10053e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100541:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100548:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054b:	8b 55 08             	mov    0x8(%ebp),%edx
  10054e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100551:	8b 45 0c             	mov    0xc(%ebp),%eax
  100554:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10055b:	c7 45 f4 8c 3e 10 00 	movl   $0x103e8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100562:	c7 45 f0 a4 b6 10 00 	movl   $0x10b6a4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100569:	c7 45 ec a5 b6 10 00 	movl   $0x10b6a5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100570:	c7 45 e8 b4 d6 10 00 	movl   $0x10d6b4,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100577:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10057a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10057d:	76 0d                	jbe    10058c <debuginfo_eip+0x71>
  10057f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100582:	83 e8 01             	sub    $0x1,%eax
  100585:	0f b6 00             	movzbl (%eax),%eax
  100588:	84 c0                	test   %al,%al
  10058a:	74 0a                	je     100596 <debuginfo_eip+0x7b>
        return -1;
  10058c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100591:	e9 c0 02 00 00       	jmp    100856 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100596:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10059d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005a3:	29 c2                	sub    %eax,%edx
  1005a5:	89 d0                	mov    %edx,%eax
  1005a7:	c1 f8 02             	sar    $0x2,%eax
  1005aa:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005b0:	83 e8 01             	sub    $0x1,%eax
  1005b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005bd:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005c4:	00 
  1005c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005d6:	89 04 24             	mov    %eax,(%esp)
  1005d9:	e8 e7 fd ff ff       	call   1003c5 <stab_binsearch>
    if (lfile == 0)
  1005de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e1:	85 c0                	test   %eax,%eax
  1005e3:	75 0a                	jne    1005ef <debuginfo_eip+0xd4>
        return -1;
  1005e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005ea:	e9 67 02 00 00       	jmp    100856 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1005fe:	89 44 24 10          	mov    %eax,0x10(%esp)
  100602:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100609:	00 
  10060a:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10060d:	89 44 24 08          	mov    %eax,0x8(%esp)
  100611:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100614:	89 44 24 04          	mov    %eax,0x4(%esp)
  100618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10061b:	89 04 24             	mov    %eax,(%esp)
  10061e:	e8 a2 fd ff ff       	call   1003c5 <stab_binsearch>

    if (lfun <= rfun) {
  100623:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100626:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100629:	39 c2                	cmp    %eax,%edx
  10062b:	7f 7c                	jg     1006a9 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10062d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100630:	89 c2                	mov    %eax,%edx
  100632:	89 d0                	mov    %edx,%eax
  100634:	01 c0                	add    %eax,%eax
  100636:	01 d0                	add    %edx,%eax
  100638:	c1 e0 02             	shl    $0x2,%eax
  10063b:	89 c2                	mov    %eax,%edx
  10063d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100640:	01 d0                	add    %edx,%eax
  100642:	8b 10                	mov    (%eax),%edx
  100644:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100647:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10064a:	29 c1                	sub    %eax,%ecx
  10064c:	89 c8                	mov    %ecx,%eax
  10064e:	39 c2                	cmp    %eax,%edx
  100650:	73 22                	jae    100674 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100652:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100655:	89 c2                	mov    %eax,%edx
  100657:	89 d0                	mov    %edx,%eax
  100659:	01 c0                	add    %eax,%eax
  10065b:	01 d0                	add    %edx,%eax
  10065d:	c1 e0 02             	shl    $0x2,%eax
  100660:	89 c2                	mov    %eax,%edx
  100662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100665:	01 d0                	add    %edx,%eax
  100667:	8b 10                	mov    (%eax),%edx
  100669:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066c:	01 c2                	add    %eax,%edx
  10066e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100671:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100674:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100677:	89 c2                	mov    %eax,%edx
  100679:	89 d0                	mov    %edx,%eax
  10067b:	01 c0                	add    %eax,%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	c1 e0 02             	shl    $0x2,%eax
  100682:	89 c2                	mov    %eax,%edx
  100684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100687:	01 d0                	add    %edx,%eax
  100689:	8b 50 08             	mov    0x8(%eax),%edx
  10068c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10068f:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100692:	8b 45 0c             	mov    0xc(%ebp),%eax
  100695:	8b 40 10             	mov    0x10(%eax),%eax
  100698:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10069b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006a7:	eb 15                	jmp    1006be <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ac:	8b 55 08             	mov    0x8(%ebp),%edx
  1006af:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c1:	8b 40 08             	mov    0x8(%eax),%eax
  1006c4:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006cb:	00 
  1006cc:	89 04 24             	mov    %eax,(%esp)
  1006cf:	e8 8b 2b 00 00       	call   10325f <strfind>
  1006d4:	89 c2                	mov    %eax,%edx
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	29 c2                	sub    %eax,%edx
  1006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e1:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1006e7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006eb:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006f2:	00 
  1006f3:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006fa:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100704:	89 04 24             	mov    %eax,(%esp)
  100707:	e8 b9 fc ff ff       	call   1003c5 <stab_binsearch>
    if (lline <= rline) {
  10070c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10070f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100712:	39 c2                	cmp    %eax,%edx
  100714:	7f 24                	jg     10073a <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100716:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100719:	89 c2                	mov    %eax,%edx
  10071b:	89 d0                	mov    %edx,%eax
  10071d:	01 c0                	add    %eax,%eax
  10071f:	01 d0                	add    %edx,%eax
  100721:	c1 e0 02             	shl    $0x2,%eax
  100724:	89 c2                	mov    %eax,%edx
  100726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100729:	01 d0                	add    %edx,%eax
  10072b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10072f:	0f b7 d0             	movzwl %ax,%edx
  100732:	8b 45 0c             	mov    0xc(%ebp),%eax
  100735:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100738:	eb 13                	jmp    10074d <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10073a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10073f:	e9 12 01 00 00       	jmp    100856 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100744:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100747:	83 e8 01             	sub    $0x1,%eax
  10074a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10074d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100753:	39 c2                	cmp    %eax,%edx
  100755:	7c 56                	jl     1007ad <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100757:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075a:	89 c2                	mov    %eax,%edx
  10075c:	89 d0                	mov    %edx,%eax
  10075e:	01 c0                	add    %eax,%eax
  100760:	01 d0                	add    %edx,%eax
  100762:	c1 e0 02             	shl    $0x2,%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076a:	01 d0                	add    %edx,%eax
  10076c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100770:	3c 84                	cmp    $0x84,%al
  100772:	74 39                	je     1007ad <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100774:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100777:	89 c2                	mov    %eax,%edx
  100779:	89 d0                	mov    %edx,%eax
  10077b:	01 c0                	add    %eax,%eax
  10077d:	01 d0                	add    %edx,%eax
  10077f:	c1 e0 02             	shl    $0x2,%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100787:	01 d0                	add    %edx,%eax
  100789:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10078d:	3c 64                	cmp    $0x64,%al
  10078f:	75 b3                	jne    100744 <debuginfo_eip+0x229>
  100791:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100794:	89 c2                	mov    %eax,%edx
  100796:	89 d0                	mov    %edx,%eax
  100798:	01 c0                	add    %eax,%eax
  10079a:	01 d0                	add    %edx,%eax
  10079c:	c1 e0 02             	shl    $0x2,%eax
  10079f:	89 c2                	mov    %eax,%edx
  1007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a4:	01 d0                	add    %edx,%eax
  1007a6:	8b 40 08             	mov    0x8(%eax),%eax
  1007a9:	85 c0                	test   %eax,%eax
  1007ab:	74 97                	je     100744 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007b3:	39 c2                	cmp    %eax,%edx
  1007b5:	7c 46                	jl     1007fd <debuginfo_eip+0x2e2>
  1007b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ba:	89 c2                	mov    %eax,%edx
  1007bc:	89 d0                	mov    %edx,%eax
  1007be:	01 c0                	add    %eax,%eax
  1007c0:	01 d0                	add    %edx,%eax
  1007c2:	c1 e0 02             	shl    $0x2,%eax
  1007c5:	89 c2                	mov    %eax,%edx
  1007c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ca:	01 d0                	add    %edx,%eax
  1007cc:	8b 10                	mov    (%eax),%edx
  1007ce:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007d4:	29 c1                	sub    %eax,%ecx
  1007d6:	89 c8                	mov    %ecx,%eax
  1007d8:	39 c2                	cmp    %eax,%edx
  1007da:	73 21                	jae    1007fd <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007df:	89 c2                	mov    %eax,%edx
  1007e1:	89 d0                	mov    %edx,%eax
  1007e3:	01 c0                	add    %eax,%eax
  1007e5:	01 d0                	add    %edx,%eax
  1007e7:	c1 e0 02             	shl    $0x2,%eax
  1007ea:	89 c2                	mov    %eax,%edx
  1007ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ef:	01 d0                	add    %edx,%eax
  1007f1:	8b 10                	mov    (%eax),%edx
  1007f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f6:	01 c2                	add    %eax,%edx
  1007f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007fb:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100800:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100803:	39 c2                	cmp    %eax,%edx
  100805:	7d 4a                	jge    100851 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  100807:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10080a:	83 c0 01             	add    $0x1,%eax
  10080d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100810:	eb 18                	jmp    10082a <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100812:	8b 45 0c             	mov    0xc(%ebp),%eax
  100815:	8b 40 14             	mov    0x14(%eax),%eax
  100818:	8d 50 01             	lea    0x1(%eax),%edx
  10081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081e:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100821:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100824:	83 c0 01             	add    $0x1,%eax
  100827:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10082a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082d:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100830:	39 c2                	cmp    %eax,%edx
  100832:	7d 1d                	jge    100851 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100834:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100837:	89 c2                	mov    %eax,%edx
  100839:	89 d0                	mov    %edx,%eax
  10083b:	01 c0                	add    %eax,%eax
  10083d:	01 d0                	add    %edx,%eax
  10083f:	c1 e0 02             	shl    $0x2,%eax
  100842:	89 c2                	mov    %eax,%edx
  100844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100847:	01 d0                	add    %edx,%eax
  100849:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084d:	3c a0                	cmp    $0xa0,%al
  10084f:	74 c1                	je     100812 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100851:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100856:	c9                   	leave  
  100857:	c3                   	ret    

00100858 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100858:	55                   	push   %ebp
  100859:	89 e5                	mov    %esp,%ebp
  10085b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10085e:	c7 04 24 36 36 10 00 	movl   $0x103636,(%esp)
  100865:	e8 ba fa ff ff       	call   100324 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10086a:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100871:	00 
  100872:	c7 04 24 4f 36 10 00 	movl   $0x10364f,(%esp)
  100879:	e8 a6 fa ff ff       	call   100324 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10087e:	c7 44 24 04 74 35 10 	movl   $0x103574,0x4(%esp)
  100885:	00 
  100886:	c7 04 24 67 36 10 00 	movl   $0x103667,(%esp)
  10088d:	e8 92 fa ff ff       	call   100324 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100892:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100899:	00 
  10089a:	c7 04 24 7f 36 10 00 	movl   $0x10367f,(%esp)
  1008a1:	e8 7e fa ff ff       	call   100324 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008a6:	c7 44 24 04 80 fd 10 	movl   $0x10fd80,0x4(%esp)
  1008ad:	00 
  1008ae:	c7 04 24 97 36 10 00 	movl   $0x103697,(%esp)
  1008b5:	e8 6a fa ff ff       	call   100324 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008ba:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  1008bf:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c5:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008ca:	29 c2                	sub    %eax,%edx
  1008cc:	89 d0                	mov    %edx,%eax
  1008ce:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008d4:	85 c0                	test   %eax,%eax
  1008d6:	0f 48 c2             	cmovs  %edx,%eax
  1008d9:	c1 f8 0a             	sar    $0xa,%eax
  1008dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008e0:	c7 04 24 b0 36 10 00 	movl   $0x1036b0,(%esp)
  1008e7:	e8 38 fa ff ff       	call   100324 <cprintf>
}
  1008ec:	c9                   	leave  
  1008ed:	c3                   	ret    

001008ee <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008ee:	55                   	push   %ebp
  1008ef:	89 e5                	mov    %esp,%ebp
  1008f1:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008f7:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100901:	89 04 24             	mov    %eax,(%esp)
  100904:	e8 12 fc ff ff       	call   10051b <debuginfo_eip>
  100909:	85 c0                	test   %eax,%eax
  10090b:	74 15                	je     100922 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10090d:	8b 45 08             	mov    0x8(%ebp),%eax
  100910:	89 44 24 04          	mov    %eax,0x4(%esp)
  100914:	c7 04 24 da 36 10 00 	movl   $0x1036da,(%esp)
  10091b:	e8 04 fa ff ff       	call   100324 <cprintf>
  100920:	eb 6d                	jmp    10098f <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100929:	eb 1c                	jmp    100947 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  10092b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100931:	01 d0                	add    %edx,%eax
  100933:	0f b6 00             	movzbl (%eax),%eax
  100936:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10093c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10093f:	01 ca                	add    %ecx,%edx
  100941:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100943:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100947:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10094a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10094d:	7f dc                	jg     10092b <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10094f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100958:	01 d0                	add    %edx,%eax
  10095a:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10095d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100960:	8b 55 08             	mov    0x8(%ebp),%edx
  100963:	89 d1                	mov    %edx,%ecx
  100965:	29 c1                	sub    %eax,%ecx
  100967:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10096a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10096d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100971:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100977:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10097b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10097f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100983:	c7 04 24 f6 36 10 00 	movl   $0x1036f6,(%esp)
  10098a:	e8 95 f9 ff ff       	call   100324 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10098f:	c9                   	leave  
  100990:	c3                   	ret    

00100991 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100991:	55                   	push   %ebp
  100992:	89 e5                	mov    %esp,%ebp
  100994:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100997:	8b 45 04             	mov    0x4(%ebp),%eax
  10099a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10099d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009a0:	c9                   	leave  
  1009a1:	c3                   	ret    

001009a2 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009a2:	55                   	push   %ebp
  1009a3:	89 e5                	mov    %esp,%ebp
  1009a5:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009a8:	89 e8                	mov    %ebp,%eax
  1009aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  1009b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009b3:	e8 d9 ff ff ff       	call   100991 <read_eip>
  1009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009c2:	e9 88 00 00 00       	jmp    100a4f <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d5:	c7 04 24 08 37 10 00 	movl   $0x103708,(%esp)
  1009dc:	e8 43 f9 ff ff       	call   100324 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  1009e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e4:	83 c0 08             	add    $0x8,%eax
  1009e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  1009ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009f1:	eb 25                	jmp    100a18 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
  1009f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a00:	01 d0                	add    %edx,%eax
  100a02:	8b 00                	mov    (%eax),%eax
  100a04:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a08:	c7 04 24 24 37 10 00 	movl   $0x103724,(%esp)
  100a0f:	e8 10 f9 ff ff       	call   100324 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
  100a14:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a18:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a1c:	7e d5                	jle    1009f3 <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  100a1e:	c7 04 24 2c 37 10 00 	movl   $0x10372c,(%esp)
  100a25:	e8 fa f8 ff ff       	call   100324 <cprintf>
        print_debuginfo(eip - 1);
  100a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a2d:	83 e8 01             	sub    $0x1,%eax
  100a30:	89 04 24             	mov    %eax,(%esp)
  100a33:	e8 b6 fe ff ff       	call   1008ee <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3b:	83 c0 04             	add    $0x4,%eax
  100a3e:	8b 00                	mov    (%eax),%eax
  100a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a46:	8b 00                	mov    (%eax),%eax
  100a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a4b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a53:	74 0a                	je     100a5f <print_stackframe+0xbd>
  100a55:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a59:	0f 8e 68 ff ff ff    	jle    1009c7 <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
  100a5f:	c9                   	leave  
  100a60:	c3                   	ret    

00100a61 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a61:	55                   	push   %ebp
  100a62:	89 e5                	mov    %esp,%ebp
  100a64:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a6e:	eb 0c                	jmp    100a7c <parse+0x1b>
            *buf ++ = '\0';
  100a70:	8b 45 08             	mov    0x8(%ebp),%eax
  100a73:	8d 50 01             	lea    0x1(%eax),%edx
  100a76:	89 55 08             	mov    %edx,0x8(%ebp)
  100a79:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7f:	0f b6 00             	movzbl (%eax),%eax
  100a82:	84 c0                	test   %al,%al
  100a84:	74 1d                	je     100aa3 <parse+0x42>
  100a86:	8b 45 08             	mov    0x8(%ebp),%eax
  100a89:	0f b6 00             	movzbl (%eax),%eax
  100a8c:	0f be c0             	movsbl %al,%eax
  100a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a93:	c7 04 24 b0 37 10 00 	movl   $0x1037b0,(%esp)
  100a9a:	e8 8d 27 00 00       	call   10322c <strchr>
  100a9f:	85 c0                	test   %eax,%eax
  100aa1:	75 cd                	jne    100a70 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa6:	0f b6 00             	movzbl (%eax),%eax
  100aa9:	84 c0                	test   %al,%al
  100aab:	75 02                	jne    100aaf <parse+0x4e>
            break;
  100aad:	eb 67                	jmp    100b16 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aaf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ab3:	75 14                	jne    100ac9 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ab5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100abc:	00 
  100abd:	c7 04 24 b5 37 10 00 	movl   $0x1037b5,(%esp)
  100ac4:	e8 5b f8 ff ff       	call   100324 <cprintf>
        }
        argv[argc ++] = buf;
  100ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100acc:	8d 50 01             	lea    0x1(%eax),%edx
  100acf:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ad2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  100adc:	01 c2                	add    %eax,%edx
  100ade:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae1:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae3:	eb 04                	jmp    100ae9 <parse+0x88>
            buf ++;
  100ae5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  100aec:	0f b6 00             	movzbl (%eax),%eax
  100aef:	84 c0                	test   %al,%al
  100af1:	74 1d                	je     100b10 <parse+0xaf>
  100af3:	8b 45 08             	mov    0x8(%ebp),%eax
  100af6:	0f b6 00             	movzbl (%eax),%eax
  100af9:	0f be c0             	movsbl %al,%eax
  100afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b00:	c7 04 24 b0 37 10 00 	movl   $0x1037b0,(%esp)
  100b07:	e8 20 27 00 00       	call   10322c <strchr>
  100b0c:	85 c0                	test   %eax,%eax
  100b0e:	74 d5                	je     100ae5 <parse+0x84>
            buf ++;
        }
    }
  100b10:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b11:	e9 66 ff ff ff       	jmp    100a7c <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b19:	c9                   	leave  
  100b1a:	c3                   	ret    

00100b1b <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b1b:	55                   	push   %ebp
  100b1c:	89 e5                	mov    %esp,%ebp
  100b1e:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b21:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b28:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2b:	89 04 24             	mov    %eax,(%esp)
  100b2e:	e8 2e ff ff ff       	call   100a61 <parse>
  100b33:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b3a:	75 0a                	jne    100b46 <runcmd+0x2b>
        return 0;
  100b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  100b41:	e9 85 00 00 00       	jmp    100bcb <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b4d:	eb 5c                	jmp    100bab <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b4f:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b55:	89 d0                	mov    %edx,%eax
  100b57:	01 c0                	add    %eax,%eax
  100b59:	01 d0                	add    %edx,%eax
  100b5b:	c1 e0 02             	shl    $0x2,%eax
  100b5e:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b63:	8b 00                	mov    (%eax),%eax
  100b65:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b69:	89 04 24             	mov    %eax,(%esp)
  100b6c:	e8 1c 26 00 00       	call   10318d <strcmp>
  100b71:	85 c0                	test   %eax,%eax
  100b73:	75 32                	jne    100ba7 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b78:	89 d0                	mov    %edx,%eax
  100b7a:	01 c0                	add    %eax,%eax
  100b7c:	01 d0                	add    %edx,%eax
  100b7e:	c1 e0 02             	shl    $0x2,%eax
  100b81:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b86:	8b 40 08             	mov    0x8(%eax),%eax
  100b89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b8c:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b92:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b96:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b99:	83 c2 04             	add    $0x4,%edx
  100b9c:	89 54 24 04          	mov    %edx,0x4(%esp)
  100ba0:	89 0c 24             	mov    %ecx,(%esp)
  100ba3:	ff d0                	call   *%eax
  100ba5:	eb 24                	jmp    100bcb <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ba7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bae:	83 f8 02             	cmp    $0x2,%eax
  100bb1:	76 9c                	jbe    100b4f <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bb3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bba:	c7 04 24 d3 37 10 00 	movl   $0x1037d3,(%esp)
  100bc1:	e8 5e f7 ff ff       	call   100324 <cprintf>
    return 0;
  100bc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bcb:	c9                   	leave  
  100bcc:	c3                   	ret    

00100bcd <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bcd:	55                   	push   %ebp
  100bce:	89 e5                	mov    %esp,%ebp
  100bd0:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bd3:	c7 04 24 ec 37 10 00 	movl   $0x1037ec,(%esp)
  100bda:	e8 45 f7 ff ff       	call   100324 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bdf:	c7 04 24 14 38 10 00 	movl   $0x103814,(%esp)
  100be6:	e8 39 f7 ff ff       	call   100324 <cprintf>

    if (tf != NULL) {
  100beb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bef:	74 0b                	je     100bfc <kmonitor+0x2f>
        print_trapframe(tf);
  100bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf4:	89 04 24             	mov    %eax,(%esp)
  100bf7:	e8 cd 0d 00 00       	call   1019c9 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bfc:	c7 04 24 39 38 10 00 	movl   $0x103839,(%esp)
  100c03:	e8 13 f6 ff ff       	call   10021b <readline>
  100c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c0f:	74 18                	je     100c29 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c11:	8b 45 08             	mov    0x8(%ebp),%eax
  100c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c1b:	89 04 24             	mov    %eax,(%esp)
  100c1e:	e8 f8 fe ff ff       	call   100b1b <runcmd>
  100c23:	85 c0                	test   %eax,%eax
  100c25:	79 02                	jns    100c29 <kmonitor+0x5c>
                break;
  100c27:	eb 02                	jmp    100c2b <kmonitor+0x5e>
            }
        }
    }
  100c29:	eb d1                	jmp    100bfc <kmonitor+0x2f>
}
  100c2b:	c9                   	leave  
  100c2c:	c3                   	ret    

00100c2d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c2d:	55                   	push   %ebp
  100c2e:	89 e5                	mov    %esp,%ebp
  100c30:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c3a:	eb 3f                	jmp    100c7b <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3f:	89 d0                	mov    %edx,%eax
  100c41:	01 c0                	add    %eax,%eax
  100c43:	01 d0                	add    %edx,%eax
  100c45:	c1 e0 02             	shl    $0x2,%eax
  100c48:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c4d:	8b 48 04             	mov    0x4(%eax),%ecx
  100c50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c53:	89 d0                	mov    %edx,%eax
  100c55:	01 c0                	add    %eax,%eax
  100c57:	01 d0                	add    %edx,%eax
  100c59:	c1 e0 02             	shl    $0x2,%eax
  100c5c:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c61:	8b 00                	mov    (%eax),%eax
  100c63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c67:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c6b:	c7 04 24 3d 38 10 00 	movl   $0x10383d,(%esp)
  100c72:	e8 ad f6 ff ff       	call   100324 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c7e:	83 f8 02             	cmp    $0x2,%eax
  100c81:	76 b9                	jbe    100c3c <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c88:	c9                   	leave  
  100c89:	c3                   	ret    

00100c8a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c8a:	55                   	push   %ebp
  100c8b:	89 e5                	mov    %esp,%ebp
  100c8d:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c90:	e8 c3 fb ff ff       	call   100858 <print_kerninfo>
    return 0;
  100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9a:	c9                   	leave  
  100c9b:	c3                   	ret    

00100c9c <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c9c:	55                   	push   %ebp
  100c9d:	89 e5                	mov    %esp,%ebp
  100c9f:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ca2:	e8 fb fc ff ff       	call   1009a2 <print_stackframe>
    return 0;
  100ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cac:	c9                   	leave  
  100cad:	c3                   	ret    

00100cae <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cae:	55                   	push   %ebp
  100caf:	89 e5                	mov    %esp,%ebp
  100cb1:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cb4:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cb9:	85 c0                	test   %eax,%eax
  100cbb:	74 02                	je     100cbf <__panic+0x11>
        goto panic_dead;
  100cbd:	eb 48                	jmp    100d07 <__panic+0x59>
    }
    is_panic = 1;
  100cbf:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cc6:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cc9:	8d 45 14             	lea    0x14(%ebp),%eax
  100ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cd2:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cdd:	c7 04 24 46 38 10 00 	movl   $0x103846,(%esp)
  100ce4:	e8 3b f6 ff ff       	call   100324 <cprintf>
    vcprintf(fmt, ap);
  100ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf0:	8b 45 10             	mov    0x10(%ebp),%eax
  100cf3:	89 04 24             	mov    %eax,(%esp)
  100cf6:	e8 f6 f5 ff ff       	call   1002f1 <vcprintf>
    cprintf("\n");
  100cfb:	c7 04 24 62 38 10 00 	movl   $0x103862,(%esp)
  100d02:	e8 1d f6 ff ff       	call   100324 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d07:	e8 22 09 00 00       	call   10162e <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d0c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d13:	e8 b5 fe ff ff       	call   100bcd <kmonitor>
    }
  100d18:	eb f2                	jmp    100d0c <__panic+0x5e>

00100d1a <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d1a:	55                   	push   %ebp
  100d1b:	89 e5                	mov    %esp,%ebp
  100d1d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d20:	8d 45 14             	lea    0x14(%ebp),%eax
  100d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d29:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  100d30:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d34:	c7 04 24 64 38 10 00 	movl   $0x103864,(%esp)
  100d3b:	e8 e4 f5 ff ff       	call   100324 <cprintf>
    vcprintf(fmt, ap);
  100d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d43:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d47:	8b 45 10             	mov    0x10(%ebp),%eax
  100d4a:	89 04 24             	mov    %eax,(%esp)
  100d4d:	e8 9f f5 ff ff       	call   1002f1 <vcprintf>
    cprintf("\n");
  100d52:	c7 04 24 62 38 10 00 	movl   $0x103862,(%esp)
  100d59:	e8 c6 f5 ff ff       	call   100324 <cprintf>
    va_end(ap);
}
  100d5e:	c9                   	leave  
  100d5f:	c3                   	ret    

00100d60 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d60:	55                   	push   %ebp
  100d61:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d63:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d68:	5d                   	pop    %ebp
  100d69:	c3                   	ret    

00100d6a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d6a:	55                   	push   %ebp
  100d6b:	89 e5                	mov    %esp,%ebp
  100d6d:	83 ec 28             	sub    $0x28,%esp
  100d70:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d76:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d7a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d7e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d82:	ee                   	out    %al,(%dx)
  100d83:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d89:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d8d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d91:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d95:	ee                   	out    %al,(%dx)
  100d96:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d9c:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100da0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100da4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100da8:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100da9:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100db0:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db3:	c7 04 24 82 38 10 00 	movl   $0x103882,(%esp)
  100dba:	e8 65 f5 ff ff       	call   100324 <cprintf>
    pic_enable(IRQ_TIMER);
  100dbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dc6:	e8 c1 08 00 00       	call   10168c <pic_enable>
}
  100dcb:	c9                   	leave  
  100dcc:	c3                   	ret    

00100dcd <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dcd:	55                   	push   %ebp
  100dce:	89 e5                	mov    %esp,%ebp
  100dd0:	83 ec 10             	sub    $0x10,%esp
  100dd3:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dd9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ddd:	89 c2                	mov    %eax,%edx
  100ddf:	ec                   	in     (%dx),%al
  100de0:	88 45 fd             	mov    %al,-0x3(%ebp)
  100de3:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100de9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ded:	89 c2                	mov    %eax,%edx
  100def:	ec                   	in     (%dx),%al
  100df0:	88 45 f9             	mov    %al,-0x7(%ebp)
  100df3:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100df9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dfd:	89 c2                	mov    %eax,%edx
  100dff:	ec                   	in     (%dx),%al
  100e00:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e03:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e09:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e0d:	89 c2                	mov    %eax,%edx
  100e0f:	ec                   	in     (%dx),%al
  100e10:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e13:	c9                   	leave  
  100e14:	c3                   	ret    

00100e15 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e15:	55                   	push   %ebp
  100e16:	89 e5                	mov    %esp,%ebp
  100e18:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e1b:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e25:	0f b7 00             	movzwl (%eax),%eax
  100e28:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e37:	0f b7 00             	movzwl (%eax),%eax
  100e3a:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e3e:	74 12                	je     100e52 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e40:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e47:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e4e:	b4 03 
  100e50:	eb 13                	jmp    100e65 <cga_init+0x50>
    } else {
        *cp = was;
  100e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e55:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e59:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e5c:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e63:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e65:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e6c:	0f b7 c0             	movzwl %ax,%eax
  100e6f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e73:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e77:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e7b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e7f:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e80:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e87:	83 c0 01             	add    $0x1,%eax
  100e8a:	0f b7 c0             	movzwl %ax,%eax
  100e8d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e91:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e95:	89 c2                	mov    %eax,%edx
  100e97:	ec                   	in     (%dx),%al
  100e98:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e9b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e9f:	0f b6 c0             	movzbl %al,%eax
  100ea2:	c1 e0 08             	shl    $0x8,%eax
  100ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ea8:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eaf:	0f b7 c0             	movzwl %ax,%eax
  100eb2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100eb6:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eba:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ebe:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ec2:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100ec3:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eca:	83 c0 01             	add    $0x1,%eax
  100ecd:	0f b7 c0             	movzwl %ax,%eax
  100ed0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ed4:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ed8:	89 c2                	mov    %eax,%edx
  100eda:	ec                   	in     (%dx),%al
  100edb:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ede:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ee2:	0f b6 c0             	movzbl %al,%eax
  100ee5:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eeb:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ef3:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ef9:	c9                   	leave  
  100efa:	c3                   	ret    

00100efb <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100efb:	55                   	push   %ebp
  100efc:	89 e5                	mov    %esp,%ebp
  100efe:	83 ec 48             	sub    $0x48,%esp
  100f01:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f07:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f0b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f0f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f13:	ee                   	out    %al,(%dx)
  100f14:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f1a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f1e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f22:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f26:	ee                   	out    %al,(%dx)
  100f27:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f2d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f31:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f35:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f39:	ee                   	out    %al,(%dx)
  100f3a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f40:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f44:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f48:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f4c:	ee                   	out    %al,(%dx)
  100f4d:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f53:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f57:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f5b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f5f:	ee                   	out    %al,(%dx)
  100f60:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f66:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f6a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f6e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f72:	ee                   	out    %al,(%dx)
  100f73:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f79:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f7d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f81:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f85:	ee                   	out    %al,(%dx)
  100f86:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f8c:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f90:	89 c2                	mov    %eax,%edx
  100f92:	ec                   	in     (%dx),%al
  100f93:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f96:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f9a:	3c ff                	cmp    $0xff,%al
  100f9c:	0f 95 c0             	setne  %al
  100f9f:	0f b6 c0             	movzbl %al,%eax
  100fa2:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fa7:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fad:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fb1:	89 c2                	mov    %eax,%edx
  100fb3:	ec                   	in     (%dx),%al
  100fb4:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fb7:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fbd:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fc1:	89 c2                	mov    %eax,%edx
  100fc3:	ec                   	in     (%dx),%al
  100fc4:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fc7:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fcc:	85 c0                	test   %eax,%eax
  100fce:	74 0c                	je     100fdc <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fd0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fd7:	e8 b0 06 00 00       	call   10168c <pic_enable>
    }
}
  100fdc:	c9                   	leave  
  100fdd:	c3                   	ret    

00100fde <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fde:	55                   	push   %ebp
  100fdf:	89 e5                	mov    %esp,%ebp
  100fe1:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100feb:	eb 09                	jmp    100ff6 <lpt_putc_sub+0x18>
        delay();
  100fed:	e8 db fd ff ff       	call   100dcd <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ff2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100ff6:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100ffc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101000:	89 c2                	mov    %eax,%edx
  101002:	ec                   	in     (%dx),%al
  101003:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101006:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10100a:	84 c0                	test   %al,%al
  10100c:	78 09                	js     101017 <lpt_putc_sub+0x39>
  10100e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101015:	7e d6                	jle    100fed <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101017:	8b 45 08             	mov    0x8(%ebp),%eax
  10101a:	0f b6 c0             	movzbl %al,%eax
  10101d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101023:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101026:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10102a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10102e:	ee                   	out    %al,(%dx)
  10102f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101035:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101039:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10103d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101041:	ee                   	out    %al,(%dx)
  101042:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101048:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10104c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101050:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101054:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101055:	c9                   	leave  
  101056:	c3                   	ret    

00101057 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101057:	55                   	push   %ebp
  101058:	89 e5                	mov    %esp,%ebp
  10105a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10105d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101061:	74 0d                	je     101070 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101063:	8b 45 08             	mov    0x8(%ebp),%eax
  101066:	89 04 24             	mov    %eax,(%esp)
  101069:	e8 70 ff ff ff       	call   100fde <lpt_putc_sub>
  10106e:	eb 24                	jmp    101094 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101070:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101077:	e8 62 ff ff ff       	call   100fde <lpt_putc_sub>
        lpt_putc_sub(' ');
  10107c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101083:	e8 56 ff ff ff       	call   100fde <lpt_putc_sub>
        lpt_putc_sub('\b');
  101088:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10108f:	e8 4a ff ff ff       	call   100fde <lpt_putc_sub>
    }
}
  101094:	c9                   	leave  
  101095:	c3                   	ret    

00101096 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101096:	55                   	push   %ebp
  101097:	89 e5                	mov    %esp,%ebp
  101099:	53                   	push   %ebx
  10109a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10109d:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a0:	b0 00                	mov    $0x0,%al
  1010a2:	85 c0                	test   %eax,%eax
  1010a4:	75 07                	jne    1010ad <cga_putc+0x17>
        c |= 0x0700;
  1010a6:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b0:	0f b6 c0             	movzbl %al,%eax
  1010b3:	83 f8 0a             	cmp    $0xa,%eax
  1010b6:	74 4c                	je     101104 <cga_putc+0x6e>
  1010b8:	83 f8 0d             	cmp    $0xd,%eax
  1010bb:	74 57                	je     101114 <cga_putc+0x7e>
  1010bd:	83 f8 08             	cmp    $0x8,%eax
  1010c0:	0f 85 88 00 00 00    	jne    10114e <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010c6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010cd:	66 85 c0             	test   %ax,%ax
  1010d0:	74 30                	je     101102 <cga_putc+0x6c>
            crt_pos --;
  1010d2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010d9:	83 e8 01             	sub    $0x1,%eax
  1010dc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010e2:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010e7:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010ee:	0f b7 d2             	movzwl %dx,%edx
  1010f1:	01 d2                	add    %edx,%edx
  1010f3:	01 c2                	add    %eax,%edx
  1010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f8:	b0 00                	mov    $0x0,%al
  1010fa:	83 c8 20             	or     $0x20,%eax
  1010fd:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101100:	eb 72                	jmp    101174 <cga_putc+0xde>
  101102:	eb 70                	jmp    101174 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101104:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10110b:	83 c0 50             	add    $0x50,%eax
  10110e:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101114:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  10111b:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101122:	0f b7 c1             	movzwl %cx,%eax
  101125:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10112b:	c1 e8 10             	shr    $0x10,%eax
  10112e:	89 c2                	mov    %eax,%edx
  101130:	66 c1 ea 06          	shr    $0x6,%dx
  101134:	89 d0                	mov    %edx,%eax
  101136:	c1 e0 02             	shl    $0x2,%eax
  101139:	01 d0                	add    %edx,%eax
  10113b:	c1 e0 04             	shl    $0x4,%eax
  10113e:	29 c1                	sub    %eax,%ecx
  101140:	89 ca                	mov    %ecx,%edx
  101142:	89 d8                	mov    %ebx,%eax
  101144:	29 d0                	sub    %edx,%eax
  101146:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10114c:	eb 26                	jmp    101174 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10114e:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101154:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10115b:	8d 50 01             	lea    0x1(%eax),%edx
  10115e:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101165:	0f b7 c0             	movzwl %ax,%eax
  101168:	01 c0                	add    %eax,%eax
  10116a:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10116d:	8b 45 08             	mov    0x8(%ebp),%eax
  101170:	66 89 02             	mov    %ax,(%edx)
        break;
  101173:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101174:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10117b:	66 3d cf 07          	cmp    $0x7cf,%ax
  10117f:	76 5b                	jbe    1011dc <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101181:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101186:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10118c:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101191:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101198:	00 
  101199:	89 54 24 04          	mov    %edx,0x4(%esp)
  10119d:	89 04 24             	mov    %eax,(%esp)
  1011a0:	e8 85 22 00 00       	call   10342a <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011a5:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011ac:	eb 15                	jmp    1011c3 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011ae:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011b6:	01 d2                	add    %edx,%edx
  1011b8:	01 d0                	add    %edx,%eax
  1011ba:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011c3:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011ca:	7e e2                	jle    1011ae <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011cc:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d3:	83 e8 50             	sub    $0x50,%eax
  1011d6:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011dc:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011e3:	0f b7 c0             	movzwl %ax,%eax
  1011e6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011ea:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011ee:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011f2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011f6:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011f7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011fe:	66 c1 e8 08          	shr    $0x8,%ax
  101202:	0f b6 c0             	movzbl %al,%eax
  101205:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10120c:	83 c2 01             	add    $0x1,%edx
  10120f:	0f b7 d2             	movzwl %dx,%edx
  101212:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101216:	88 45 ed             	mov    %al,-0x13(%ebp)
  101219:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10121d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101221:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101222:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101229:	0f b7 c0             	movzwl %ax,%eax
  10122c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101230:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101234:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101238:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10123c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10123d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101244:	0f b6 c0             	movzbl %al,%eax
  101247:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10124e:	83 c2 01             	add    $0x1,%edx
  101251:	0f b7 d2             	movzwl %dx,%edx
  101254:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101258:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10125b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10125f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101263:	ee                   	out    %al,(%dx)
}
  101264:	83 c4 34             	add    $0x34,%esp
  101267:	5b                   	pop    %ebx
  101268:	5d                   	pop    %ebp
  101269:	c3                   	ret    

0010126a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10126a:	55                   	push   %ebp
  10126b:	89 e5                	mov    %esp,%ebp
  10126d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101270:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101277:	eb 09                	jmp    101282 <serial_putc_sub+0x18>
        delay();
  101279:	e8 4f fb ff ff       	call   100dcd <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10127e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101282:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101288:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10128c:	89 c2                	mov    %eax,%edx
  10128e:	ec                   	in     (%dx),%al
  10128f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101292:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101296:	0f b6 c0             	movzbl %al,%eax
  101299:	83 e0 20             	and    $0x20,%eax
  10129c:	85 c0                	test   %eax,%eax
  10129e:	75 09                	jne    1012a9 <serial_putc_sub+0x3f>
  1012a0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012a7:	7e d0                	jle    101279 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ac:	0f b6 c0             	movzbl %al,%eax
  1012af:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012b5:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012bc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012c0:	ee                   	out    %al,(%dx)
}
  1012c1:	c9                   	leave  
  1012c2:	c3                   	ret    

001012c3 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012c3:	55                   	push   %ebp
  1012c4:	89 e5                	mov    %esp,%ebp
  1012c6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012c9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012cd:	74 0d                	je     1012dc <serial_putc+0x19>
        serial_putc_sub(c);
  1012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d2:	89 04 24             	mov    %eax,(%esp)
  1012d5:	e8 90 ff ff ff       	call   10126a <serial_putc_sub>
  1012da:	eb 24                	jmp    101300 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012dc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e3:	e8 82 ff ff ff       	call   10126a <serial_putc_sub>
        serial_putc_sub(' ');
  1012e8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012ef:	e8 76 ff ff ff       	call   10126a <serial_putc_sub>
        serial_putc_sub('\b');
  1012f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012fb:	e8 6a ff ff ff       	call   10126a <serial_putc_sub>
    }
}
  101300:	c9                   	leave  
  101301:	c3                   	ret    

00101302 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101302:	55                   	push   %ebp
  101303:	89 e5                	mov    %esp,%ebp
  101305:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101308:	eb 33                	jmp    10133d <cons_intr+0x3b>
        if (c != 0) {
  10130a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10130e:	74 2d                	je     10133d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101310:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101315:	8d 50 01             	lea    0x1(%eax),%edx
  101318:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10131e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101321:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101327:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10132c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101331:	75 0a                	jne    10133d <cons_intr+0x3b>
                cons.wpos = 0;
  101333:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10133a:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10133d:	8b 45 08             	mov    0x8(%ebp),%eax
  101340:	ff d0                	call   *%eax
  101342:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101345:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101349:	75 bf                	jne    10130a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10134b:	c9                   	leave  
  10134c:	c3                   	ret    

0010134d <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10134d:	55                   	push   %ebp
  10134e:	89 e5                	mov    %esp,%ebp
  101350:	83 ec 10             	sub    $0x10,%esp
  101353:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101359:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10135d:	89 c2                	mov    %eax,%edx
  10135f:	ec                   	in     (%dx),%al
  101360:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101363:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101367:	0f b6 c0             	movzbl %al,%eax
  10136a:	83 e0 01             	and    $0x1,%eax
  10136d:	85 c0                	test   %eax,%eax
  10136f:	75 07                	jne    101378 <serial_proc_data+0x2b>
        return -1;
  101371:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101376:	eb 2a                	jmp    1013a2 <serial_proc_data+0x55>
  101378:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10137e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101382:	89 c2                	mov    %eax,%edx
  101384:	ec                   	in     (%dx),%al
  101385:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101388:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10138c:	0f b6 c0             	movzbl %al,%eax
  10138f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101392:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101396:	75 07                	jne    10139f <serial_proc_data+0x52>
        c = '\b';
  101398:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10139f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013a2:	c9                   	leave  
  1013a3:	c3                   	ret    

001013a4 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013a4:	55                   	push   %ebp
  1013a5:	89 e5                	mov    %esp,%ebp
  1013a7:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013aa:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013af:	85 c0                	test   %eax,%eax
  1013b1:	74 0c                	je     1013bf <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013b3:	c7 04 24 4d 13 10 00 	movl   $0x10134d,(%esp)
  1013ba:	e8 43 ff ff ff       	call   101302 <cons_intr>
    }
}
  1013bf:	c9                   	leave  
  1013c0:	c3                   	ret    

001013c1 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013c1:	55                   	push   %ebp
  1013c2:	89 e5                	mov    %esp,%ebp
  1013c4:	83 ec 38             	sub    $0x38,%esp
  1013c7:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013d1:	89 c2                	mov    %eax,%edx
  1013d3:	ec                   	in     (%dx),%al
  1013d4:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013d7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013db:	0f b6 c0             	movzbl %al,%eax
  1013de:	83 e0 01             	and    $0x1,%eax
  1013e1:	85 c0                	test   %eax,%eax
  1013e3:	75 0a                	jne    1013ef <kbd_proc_data+0x2e>
        return -1;
  1013e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013ea:	e9 59 01 00 00       	jmp    101548 <kbd_proc_data+0x187>
  1013ef:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013f5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013f9:	89 c2                	mov    %eax,%edx
  1013fb:	ec                   	in     (%dx),%al
  1013fc:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013ff:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101403:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101406:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10140a:	75 17                	jne    101423 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10140c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101411:	83 c8 40             	or     $0x40,%eax
  101414:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101419:	b8 00 00 00 00       	mov    $0x0,%eax
  10141e:	e9 25 01 00 00       	jmp    101548 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101423:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101427:	84 c0                	test   %al,%al
  101429:	79 47                	jns    101472 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10142b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101430:	83 e0 40             	and    $0x40,%eax
  101433:	85 c0                	test   %eax,%eax
  101435:	75 09                	jne    101440 <kbd_proc_data+0x7f>
  101437:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143b:	83 e0 7f             	and    $0x7f,%eax
  10143e:	eb 04                	jmp    101444 <kbd_proc_data+0x83>
  101440:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101444:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101447:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144b:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101452:	83 c8 40             	or     $0x40,%eax
  101455:	0f b6 c0             	movzbl %al,%eax
  101458:	f7 d0                	not    %eax
  10145a:	89 c2                	mov    %eax,%edx
  10145c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101461:	21 d0                	and    %edx,%eax
  101463:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101468:	b8 00 00 00 00       	mov    $0x0,%eax
  10146d:	e9 d6 00 00 00       	jmp    101548 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101472:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101477:	83 e0 40             	and    $0x40,%eax
  10147a:	85 c0                	test   %eax,%eax
  10147c:	74 11                	je     10148f <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10147e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101482:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101487:	83 e0 bf             	and    $0xffffffbf,%eax
  10148a:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101493:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10149a:	0f b6 d0             	movzbl %al,%edx
  10149d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a2:	09 d0                	or     %edx,%eax
  1014a4:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014a9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ad:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014b4:	0f b6 d0             	movzbl %al,%edx
  1014b7:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014bc:	31 d0                	xor    %edx,%eax
  1014be:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014c3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c8:	83 e0 03             	and    $0x3,%eax
  1014cb:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014d2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d6:	01 d0                	add    %edx,%eax
  1014d8:	0f b6 00             	movzbl (%eax),%eax
  1014db:	0f b6 c0             	movzbl %al,%eax
  1014de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014e1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e6:	83 e0 08             	and    $0x8,%eax
  1014e9:	85 c0                	test   %eax,%eax
  1014eb:	74 22                	je     10150f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014ed:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014f1:	7e 0c                	jle    1014ff <kbd_proc_data+0x13e>
  1014f3:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014f7:	7f 06                	jg     1014ff <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014f9:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014fd:	eb 10                	jmp    10150f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014ff:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101503:	7e 0a                	jle    10150f <kbd_proc_data+0x14e>
  101505:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101509:	7f 04                	jg     10150f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10150b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10150f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101514:	f7 d0                	not    %eax
  101516:	83 e0 06             	and    $0x6,%eax
  101519:	85 c0                	test   %eax,%eax
  10151b:	75 28                	jne    101545 <kbd_proc_data+0x184>
  10151d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101524:	75 1f                	jne    101545 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101526:	c7 04 24 9d 38 10 00 	movl   $0x10389d,(%esp)
  10152d:	e8 f2 ed ff ff       	call   100324 <cprintf>
  101532:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101538:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10153c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101540:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101544:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101545:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101548:	c9                   	leave  
  101549:	c3                   	ret    

0010154a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10154a:	55                   	push   %ebp
  10154b:	89 e5                	mov    %esp,%ebp
  10154d:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101550:	c7 04 24 c1 13 10 00 	movl   $0x1013c1,(%esp)
  101557:	e8 a6 fd ff ff       	call   101302 <cons_intr>
}
  10155c:	c9                   	leave  
  10155d:	c3                   	ret    

0010155e <kbd_init>:

static void
kbd_init(void) {
  10155e:	55                   	push   %ebp
  10155f:	89 e5                	mov    %esp,%ebp
  101561:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101564:	e8 e1 ff ff ff       	call   10154a <kbd_intr>
    pic_enable(IRQ_KBD);
  101569:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101570:	e8 17 01 00 00       	call   10168c <pic_enable>
}
  101575:	c9                   	leave  
  101576:	c3                   	ret    

00101577 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101577:	55                   	push   %ebp
  101578:	89 e5                	mov    %esp,%ebp
  10157a:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10157d:	e8 93 f8 ff ff       	call   100e15 <cga_init>
    serial_init();
  101582:	e8 74 f9 ff ff       	call   100efb <serial_init>
    kbd_init();
  101587:	e8 d2 ff ff ff       	call   10155e <kbd_init>
    if (!serial_exists) {
  10158c:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101591:	85 c0                	test   %eax,%eax
  101593:	75 0c                	jne    1015a1 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101595:	c7 04 24 a9 38 10 00 	movl   $0x1038a9,(%esp)
  10159c:	e8 83 ed ff ff       	call   100324 <cprintf>
    }
}
  1015a1:	c9                   	leave  
  1015a2:	c3                   	ret    

001015a3 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015a3:	55                   	push   %ebp
  1015a4:	89 e5                	mov    %esp,%ebp
  1015a6:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ac:	89 04 24             	mov    %eax,(%esp)
  1015af:	e8 a3 fa ff ff       	call   101057 <lpt_putc>
    cga_putc(c);
  1015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b7:	89 04 24             	mov    %eax,(%esp)
  1015ba:	e8 d7 fa ff ff       	call   101096 <cga_putc>
    serial_putc(c);
  1015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c2:	89 04 24             	mov    %eax,(%esp)
  1015c5:	e8 f9 fc ff ff       	call   1012c3 <serial_putc>
}
  1015ca:	c9                   	leave  
  1015cb:	c3                   	ret    

001015cc <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015cc:	55                   	push   %ebp
  1015cd:	89 e5                	mov    %esp,%ebp
  1015cf:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015d2:	e8 cd fd ff ff       	call   1013a4 <serial_intr>
    kbd_intr();
  1015d7:	e8 6e ff ff ff       	call   10154a <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015dc:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015e2:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015e7:	39 c2                	cmp    %eax,%edx
  1015e9:	74 36                	je     101621 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015eb:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f0:	8d 50 01             	lea    0x1(%eax),%edx
  1015f3:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015f9:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101600:	0f b6 c0             	movzbl %al,%eax
  101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101606:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10160b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101610:	75 0a                	jne    10161c <cons_getc+0x50>
            cons.rpos = 0;
  101612:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101619:	00 00 00 
        }
        return c;
  10161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10161f:	eb 05                	jmp    101626 <cons_getc+0x5a>
    }
    return 0;
  101621:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101626:	c9                   	leave  
  101627:	c3                   	ret    

00101628 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101628:	55                   	push   %ebp
  101629:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10162b:	fb                   	sti    
    sti();
}
  10162c:	5d                   	pop    %ebp
  10162d:	c3                   	ret    

0010162e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10162e:	55                   	push   %ebp
  10162f:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101631:	fa                   	cli    
    cli();
}
  101632:	5d                   	pop    %ebp
  101633:	c3                   	ret    

00101634 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101634:	55                   	push   %ebp
  101635:	89 e5                	mov    %esp,%ebp
  101637:	83 ec 14             	sub    $0x14,%esp
  10163a:	8b 45 08             	mov    0x8(%ebp),%eax
  10163d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101641:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101645:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10164b:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101650:	85 c0                	test   %eax,%eax
  101652:	74 36                	je     10168a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101654:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101658:	0f b6 c0             	movzbl %al,%eax
  10165b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101661:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101664:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101668:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10166c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10166d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101671:	66 c1 e8 08          	shr    $0x8,%ax
  101675:	0f b6 c0             	movzbl %al,%eax
  101678:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10167e:	88 45 f9             	mov    %al,-0x7(%ebp)
  101681:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101685:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101689:	ee                   	out    %al,(%dx)
    }
}
  10168a:	c9                   	leave  
  10168b:	c3                   	ret    

0010168c <pic_enable>:

void
pic_enable(unsigned int irq) {
  10168c:	55                   	push   %ebp
  10168d:	89 e5                	mov    %esp,%ebp
  10168f:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101692:	8b 45 08             	mov    0x8(%ebp),%eax
  101695:	ba 01 00 00 00       	mov    $0x1,%edx
  10169a:	89 c1                	mov    %eax,%ecx
  10169c:	d3 e2                	shl    %cl,%edx
  10169e:	89 d0                	mov    %edx,%eax
  1016a0:	f7 d0                	not    %eax
  1016a2:	89 c2                	mov    %eax,%edx
  1016a4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016ab:	21 d0                	and    %edx,%eax
  1016ad:	0f b7 c0             	movzwl %ax,%eax
  1016b0:	89 04 24             	mov    %eax,(%esp)
  1016b3:	e8 7c ff ff ff       	call   101634 <pic_setmask>
}
  1016b8:	c9                   	leave  
  1016b9:	c3                   	ret    

001016ba <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016ba:	55                   	push   %ebp
  1016bb:	89 e5                	mov    %esp,%ebp
  1016bd:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016c0:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016c7:	00 00 00 
  1016ca:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016d0:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016d4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016d8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016dc:	ee                   	out    %al,(%dx)
  1016dd:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016e3:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016eb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016ef:	ee                   	out    %al,(%dx)
  1016f0:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016f6:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016fa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016fe:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101702:	ee                   	out    %al,(%dx)
  101703:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101709:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10170d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101711:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101715:	ee                   	out    %al,(%dx)
  101716:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10171c:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101720:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101724:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101728:	ee                   	out    %al,(%dx)
  101729:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10172f:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101733:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101737:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10173b:	ee                   	out    %al,(%dx)
  10173c:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101742:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101746:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10174a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10174e:	ee                   	out    %al,(%dx)
  10174f:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101755:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101759:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10175d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101761:	ee                   	out    %al,(%dx)
  101762:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101768:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10176c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101770:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101774:	ee                   	out    %al,(%dx)
  101775:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10177b:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10177f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101783:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101787:	ee                   	out    %al,(%dx)
  101788:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10178e:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101792:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101796:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10179a:	ee                   	out    %al,(%dx)
  10179b:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017a1:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017a5:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017a9:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017ad:	ee                   	out    %al,(%dx)
  1017ae:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017b4:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017b8:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017bc:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017c0:	ee                   	out    %al,(%dx)
  1017c1:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017c7:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017cb:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017cf:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017d3:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017d4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017db:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017df:	74 12                	je     1017f3 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017e1:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e8:	0f b7 c0             	movzwl %ax,%eax
  1017eb:	89 04 24             	mov    %eax,(%esp)
  1017ee:	e8 41 fe ff ff       	call   101634 <pic_setmask>
    }
}
  1017f3:	c9                   	leave  
  1017f4:	c3                   	ret    

001017f5 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  1017f5:	55                   	push   %ebp
  1017f6:	89 e5                	mov    %esp,%ebp
  1017f8:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017fb:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101802:	00 
  101803:	c7 04 24 e0 38 10 00 	movl   $0x1038e0,(%esp)
  10180a:	e8 15 eb ff ff       	call   100324 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10180f:	c9                   	leave  
  101810:	c3                   	ret    

00101811 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101811:	55                   	push   %ebp
  101812:	89 e5                	mov    %esp,%ebp
  101814:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101817:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10181e:	e9 c3 00 00 00       	jmp    1018e6 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101823:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101826:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10182d:	89 c2                	mov    %eax,%edx
  10182f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101832:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101839:	00 
  10183a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10183d:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101844:	00 08 00 
  101847:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184a:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101851:	00 
  101852:	83 e2 e0             	and    $0xffffffe0,%edx
  101855:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10185c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185f:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101866:	00 
  101867:	83 e2 1f             	and    $0x1f,%edx
  10186a:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101871:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101874:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10187b:	00 
  10187c:	83 e2 f0             	and    $0xfffffff0,%edx
  10187f:	83 ca 0e             	or     $0xe,%edx
  101882:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101889:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188c:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101893:	00 
  101894:	83 e2 ef             	and    $0xffffffef,%edx
  101897:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10189e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a1:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018a8:	00 
  1018a9:	83 e2 9f             	and    $0xffffff9f,%edx
  1018ac:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b6:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018bd:	00 
  1018be:	83 ca 80             	or     $0xffffff80,%edx
  1018c1:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cb:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018d2:	c1 e8 10             	shr    $0x10,%eax
  1018d5:	89 c2                	mov    %eax,%edx
  1018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018da:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018e1:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e9:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018ee:	0f 86 2f ff ff ff    	jbe    101823 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1018f4:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1018f9:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  1018ff:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101906:	08 00 
  101908:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10190f:	83 e0 e0             	and    $0xffffffe0,%eax
  101912:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101917:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10191e:	83 e0 1f             	and    $0x1f,%eax
  101921:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101926:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10192d:	83 e0 f0             	and    $0xfffffff0,%eax
  101930:	83 c8 0e             	or     $0xe,%eax
  101933:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101938:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10193f:	83 e0 ef             	and    $0xffffffef,%eax
  101942:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101947:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10194e:	83 c8 60             	or     $0x60,%eax
  101951:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101956:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10195d:	83 c8 80             	or     $0xffffff80,%eax
  101960:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101965:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10196a:	c1 e8 10             	shr    $0x10,%eax
  10196d:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101973:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  10197a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10197d:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  101980:	c9                   	leave  
  101981:	c3                   	ret    

00101982 <trapname>:

static const char *
trapname(int trapno) {
  101982:	55                   	push   %ebp
  101983:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101985:	8b 45 08             	mov    0x8(%ebp),%eax
  101988:	83 f8 13             	cmp    $0x13,%eax
  10198b:	77 0c                	ja     101999 <trapname+0x17>
        return excnames[trapno];
  10198d:	8b 45 08             	mov    0x8(%ebp),%eax
  101990:	8b 04 85 40 3c 10 00 	mov    0x103c40(,%eax,4),%eax
  101997:	eb 18                	jmp    1019b1 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101999:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10199d:	7e 0d                	jle    1019ac <trapname+0x2a>
  10199f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019a3:	7f 07                	jg     1019ac <trapname+0x2a>
        return "Hardware Interrupt";
  1019a5:	b8 ea 38 10 00       	mov    $0x1038ea,%eax
  1019aa:	eb 05                	jmp    1019b1 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019ac:	b8 fd 38 10 00       	mov    $0x1038fd,%eax
}
  1019b1:	5d                   	pop    %ebp
  1019b2:	c3                   	ret    

001019b3 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019b3:	55                   	push   %ebp
  1019b4:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019bd:	66 83 f8 08          	cmp    $0x8,%ax
  1019c1:	0f 94 c0             	sete   %al
  1019c4:	0f b6 c0             	movzbl %al,%eax
}
  1019c7:	5d                   	pop    %ebp
  1019c8:	c3                   	ret    

001019c9 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019c9:	55                   	push   %ebp
  1019ca:	89 e5                	mov    %esp,%ebp
  1019cc:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019d6:	c7 04 24 3e 39 10 00 	movl   $0x10393e,(%esp)
  1019dd:	e8 42 e9 ff ff       	call   100324 <cprintf>
    print_regs(&tf->tf_regs);
  1019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e5:	89 04 24             	mov    %eax,(%esp)
  1019e8:	e8 a1 01 00 00       	call   101b8e <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f0:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019f4:	0f b7 c0             	movzwl %ax,%eax
  1019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019fb:	c7 04 24 4f 39 10 00 	movl   $0x10394f,(%esp)
  101a02:	e8 1d e9 ff ff       	call   100324 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a07:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0a:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a0e:	0f b7 c0             	movzwl %ax,%eax
  101a11:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a15:	c7 04 24 62 39 10 00 	movl   $0x103962,(%esp)
  101a1c:	e8 03 e9 ff ff       	call   100324 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a21:	8b 45 08             	mov    0x8(%ebp),%eax
  101a24:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a28:	0f b7 c0             	movzwl %ax,%eax
  101a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a2f:	c7 04 24 75 39 10 00 	movl   $0x103975,(%esp)
  101a36:	e8 e9 e8 ff ff       	call   100324 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3e:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a42:	0f b7 c0             	movzwl %ax,%eax
  101a45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a49:	c7 04 24 88 39 10 00 	movl   $0x103988,(%esp)
  101a50:	e8 cf e8 ff ff       	call   100324 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a55:	8b 45 08             	mov    0x8(%ebp),%eax
  101a58:	8b 40 30             	mov    0x30(%eax),%eax
  101a5b:	89 04 24             	mov    %eax,(%esp)
  101a5e:	e8 1f ff ff ff       	call   101982 <trapname>
  101a63:	8b 55 08             	mov    0x8(%ebp),%edx
  101a66:	8b 52 30             	mov    0x30(%edx),%edx
  101a69:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a6d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a71:	c7 04 24 9b 39 10 00 	movl   $0x10399b,(%esp)
  101a78:	e8 a7 e8 ff ff       	call   100324 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a80:	8b 40 34             	mov    0x34(%eax),%eax
  101a83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a87:	c7 04 24 ad 39 10 00 	movl   $0x1039ad,(%esp)
  101a8e:	e8 91 e8 ff ff       	call   100324 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a93:	8b 45 08             	mov    0x8(%ebp),%eax
  101a96:	8b 40 38             	mov    0x38(%eax),%eax
  101a99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9d:	c7 04 24 bc 39 10 00 	movl   $0x1039bc,(%esp)
  101aa4:	e8 7b e8 ff ff       	call   100324 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aac:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ab0:	0f b7 c0             	movzwl %ax,%eax
  101ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab7:	c7 04 24 cb 39 10 00 	movl   $0x1039cb,(%esp)
  101abe:	e8 61 e8 ff ff       	call   100324 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac6:	8b 40 40             	mov    0x40(%eax),%eax
  101ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acd:	c7 04 24 de 39 10 00 	movl   $0x1039de,(%esp)
  101ad4:	e8 4b e8 ff ff       	call   100324 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ad9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ae0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ae7:	eb 3e                	jmp    101b27 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aec:	8b 50 40             	mov    0x40(%eax),%edx
  101aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101af2:	21 d0                	and    %edx,%eax
  101af4:	85 c0                	test   %eax,%eax
  101af6:	74 28                	je     101b20 <print_trapframe+0x157>
  101af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101afb:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b02:	85 c0                	test   %eax,%eax
  101b04:	74 1a                	je     101b20 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b09:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b10:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b14:	c7 04 24 ed 39 10 00 	movl   $0x1039ed,(%esp)
  101b1b:	e8 04 e8 ff ff       	call   100324 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b20:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b24:	d1 65 f0             	shll   -0x10(%ebp)
  101b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b2a:	83 f8 17             	cmp    $0x17,%eax
  101b2d:	76 ba                	jbe    101ae9 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b32:	8b 40 40             	mov    0x40(%eax),%eax
  101b35:	25 00 30 00 00       	and    $0x3000,%eax
  101b3a:	c1 e8 0c             	shr    $0xc,%eax
  101b3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b41:	c7 04 24 f1 39 10 00 	movl   $0x1039f1,(%esp)
  101b48:	e8 d7 e7 ff ff       	call   100324 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b50:	89 04 24             	mov    %eax,(%esp)
  101b53:	e8 5b fe ff ff       	call   1019b3 <trap_in_kernel>
  101b58:	85 c0                	test   %eax,%eax
  101b5a:	75 30                	jne    101b8c <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5f:	8b 40 44             	mov    0x44(%eax),%eax
  101b62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b66:	c7 04 24 fa 39 10 00 	movl   $0x1039fa,(%esp)
  101b6d:	e8 b2 e7 ff ff       	call   100324 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b72:	8b 45 08             	mov    0x8(%ebp),%eax
  101b75:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b79:	0f b7 c0             	movzwl %ax,%eax
  101b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b80:	c7 04 24 09 3a 10 00 	movl   $0x103a09,(%esp)
  101b87:	e8 98 e7 ff ff       	call   100324 <cprintf>
    }
}
  101b8c:	c9                   	leave  
  101b8d:	c3                   	ret    

00101b8e <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b8e:	55                   	push   %ebp
  101b8f:	89 e5                	mov    %esp,%ebp
  101b91:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b94:	8b 45 08             	mov    0x8(%ebp),%eax
  101b97:	8b 00                	mov    (%eax),%eax
  101b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9d:	c7 04 24 1c 3a 10 00 	movl   $0x103a1c,(%esp)
  101ba4:	e8 7b e7 ff ff       	call   100324 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bac:	8b 40 04             	mov    0x4(%eax),%eax
  101baf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb3:	c7 04 24 2b 3a 10 00 	movl   $0x103a2b,(%esp)
  101bba:	e8 65 e7 ff ff       	call   100324 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc2:	8b 40 08             	mov    0x8(%eax),%eax
  101bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc9:	c7 04 24 3a 3a 10 00 	movl   $0x103a3a,(%esp)
  101bd0:	e8 4f e7 ff ff       	call   100324 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd8:	8b 40 0c             	mov    0xc(%eax),%eax
  101bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdf:	c7 04 24 49 3a 10 00 	movl   $0x103a49,(%esp)
  101be6:	e8 39 e7 ff ff       	call   100324 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101beb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bee:	8b 40 10             	mov    0x10(%eax),%eax
  101bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf5:	c7 04 24 58 3a 10 00 	movl   $0x103a58,(%esp)
  101bfc:	e8 23 e7 ff ff       	call   100324 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c01:	8b 45 08             	mov    0x8(%ebp),%eax
  101c04:	8b 40 14             	mov    0x14(%eax),%eax
  101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0b:	c7 04 24 67 3a 10 00 	movl   $0x103a67,(%esp)
  101c12:	e8 0d e7 ff ff       	call   100324 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c17:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1a:	8b 40 18             	mov    0x18(%eax),%eax
  101c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c21:	c7 04 24 76 3a 10 00 	movl   $0x103a76,(%esp)
  101c28:	e8 f7 e6 ff ff       	call   100324 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c30:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c37:	c7 04 24 85 3a 10 00 	movl   $0x103a85,(%esp)
  101c3e:	e8 e1 e6 ff ff       	call   100324 <cprintf>
}
  101c43:	c9                   	leave  
  101c44:	c3                   	ret    

00101c45 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c45:	55                   	push   %ebp
  101c46:	89 e5                	mov    %esp,%ebp
  101c48:	57                   	push   %edi
  101c49:	56                   	push   %esi
  101c4a:	53                   	push   %ebx
  101c4b:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c51:	8b 40 30             	mov    0x30(%eax),%eax
  101c54:	83 f8 2f             	cmp    $0x2f,%eax
  101c57:	77 21                	ja     101c7a <trap_dispatch+0x35>
  101c59:	83 f8 2e             	cmp    $0x2e,%eax
  101c5c:	0f 83 ec 01 00 00    	jae    101e4e <trap_dispatch+0x209>
  101c62:	83 f8 21             	cmp    $0x21,%eax
  101c65:	0f 84 8a 00 00 00    	je     101cf5 <trap_dispatch+0xb0>
  101c6b:	83 f8 24             	cmp    $0x24,%eax
  101c6e:	74 5c                	je     101ccc <trap_dispatch+0x87>
  101c70:	83 f8 20             	cmp    $0x20,%eax
  101c73:	74 1c                	je     101c91 <trap_dispatch+0x4c>
  101c75:	e9 9c 01 00 00       	jmp    101e16 <trap_dispatch+0x1d1>
  101c7a:	83 f8 78             	cmp    $0x78,%eax
  101c7d:	0f 84 9b 00 00 00    	je     101d1e <trap_dispatch+0xd9>
  101c83:	83 f8 79             	cmp    $0x79,%eax
  101c86:	0f 84 11 01 00 00    	je     101d9d <trap_dispatch+0x158>
  101c8c:	e9 85 01 00 00       	jmp    101e16 <trap_dispatch+0x1d1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101c91:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c96:	83 c0 01             	add    $0x1,%eax
  101c99:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0) {
  101c9e:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101ca4:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101ca9:	89 c8                	mov    %ecx,%eax
  101cab:	f7 e2                	mul    %edx
  101cad:	89 d0                	mov    %edx,%eax
  101caf:	c1 e8 05             	shr    $0x5,%eax
  101cb2:	6b c0 64             	imul   $0x64,%eax,%eax
  101cb5:	29 c1                	sub    %eax,%ecx
  101cb7:	89 c8                	mov    %ecx,%eax
  101cb9:	85 c0                	test   %eax,%eax
  101cbb:	75 0a                	jne    101cc7 <trap_dispatch+0x82>
            print_ticks();
  101cbd:	e8 33 fb ff ff       	call   1017f5 <print_ticks>
        }
        break;
  101cc2:	e9 88 01 00 00       	jmp    101e4f <trap_dispatch+0x20a>
  101cc7:	e9 83 01 00 00       	jmp    101e4f <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ccc:	e8 fb f8 ff ff       	call   1015cc <cons_getc>
  101cd1:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cd4:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101cd8:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101cdc:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce4:	c7 04 24 94 3a 10 00 	movl   $0x103a94,(%esp)
  101ceb:	e8 34 e6 ff ff       	call   100324 <cprintf>
        break;
  101cf0:	e9 5a 01 00 00       	jmp    101e4f <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101cf5:	e8 d2 f8 ff ff       	call   1015cc <cons_getc>
  101cfa:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cfd:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d01:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d05:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0d:	c7 04 24 a6 3a 10 00 	movl   $0x103aa6,(%esp)
  101d14:	e8 0b e6 ff ff       	call   100324 <cprintf>
        break;
  101d19:	e9 31 01 00 00       	jmp    101e4f <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d21:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d25:	66 83 f8 1b          	cmp    $0x1b,%ax
  101d29:	74 6d                	je     101d98 <trap_dispatch+0x153>
            switchk2u = *tf;
  101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2e:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101d33:	89 c3                	mov    %eax,%ebx
  101d35:	b8 13 00 00 00       	mov    $0x13,%eax
  101d3a:	89 d7                	mov    %edx,%edi
  101d3c:	89 de                	mov    %ebx,%esi
  101d3e:	89 c1                	mov    %eax,%ecx
  101d40:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101d42:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101d49:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101d4b:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101d52:	23 00 
  101d54:	0f b7 05 68 f9 10 00 	movzwl 0x10f968,%eax
  101d5b:	66 a3 48 f9 10 00    	mov    %ax,0x10f948
  101d61:	0f b7 05 48 f9 10 00 	movzwl 0x10f948,%eax
  101d68:	66 a3 4c f9 10 00    	mov    %ax,0x10f94c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d71:	83 c0 44             	add    $0x44,%eax
  101d74:	a3 64 f9 10 00       	mov    %eax,0x10f964
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101d79:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101d7e:	80 cc 30             	or     $0x30,%ah
  101d81:	a3 60 f9 10 00       	mov    %eax,0x10f960
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101d86:	8b 45 08             	mov    0x8(%ebp),%eax
  101d89:	8d 50 fc             	lea    -0x4(%eax),%edx
  101d8c:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101d91:	89 02                	mov    %eax,(%edx)
        }
        break;
  101d93:	e9 b7 00 00 00       	jmp    101e4f <trap_dispatch+0x20a>
  101d98:	e9 b2 00 00 00       	jmp    101e4f <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101da0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101da4:	66 83 f8 08          	cmp    $0x8,%ax
  101da8:	74 6a                	je     101e14 <trap_dispatch+0x1cf>
            tf->tf_cs = KERNEL_CS;
  101daa:	8b 45 08             	mov    0x8(%ebp),%eax
  101dad:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101db3:	8b 45 08             	mov    0x8(%ebp),%eax
  101db6:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbf:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc6:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101dca:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcd:	8b 40 40             	mov    0x40(%eax),%eax
  101dd0:	80 e4 cf             	and    $0xcf,%ah
  101dd3:	89 c2                	mov    %eax,%edx
  101dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd8:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dde:	8b 40 44             	mov    0x44(%eax),%eax
  101de1:	83 e8 44             	sub    $0x44,%eax
  101de4:	a3 6c f9 10 00       	mov    %eax,0x10f96c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101de9:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101dee:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101df5:	00 
  101df6:	8b 55 08             	mov    0x8(%ebp),%edx
  101df9:	89 54 24 04          	mov    %edx,0x4(%esp)
  101dfd:	89 04 24             	mov    %eax,(%esp)
  101e00:	e8 25 16 00 00       	call   10342a <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e05:	8b 45 08             	mov    0x8(%ebp),%eax
  101e08:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e0b:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e10:	89 02                	mov    %eax,(%edx)
        }
        break;
  101e12:	eb 3b                	jmp    101e4f <trap_dispatch+0x20a>
  101e14:	eb 39                	jmp    101e4f <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e16:	8b 45 08             	mov    0x8(%ebp),%eax
  101e19:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e1d:	0f b7 c0             	movzwl %ax,%eax
  101e20:	83 e0 03             	and    $0x3,%eax
  101e23:	85 c0                	test   %eax,%eax
  101e25:	75 28                	jne    101e4f <trap_dispatch+0x20a>
            print_trapframe(tf);
  101e27:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2a:	89 04 24             	mov    %eax,(%esp)
  101e2d:	e8 97 fb ff ff       	call   1019c9 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e32:	c7 44 24 08 b5 3a 10 	movl   $0x103ab5,0x8(%esp)
  101e39:	00 
  101e3a:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  101e41:	00 
  101e42:	c7 04 24 d1 3a 10 00 	movl   $0x103ad1,(%esp)
  101e49:	e8 60 ee ff ff       	call   100cae <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e4e:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e4f:	83 c4 2c             	add    $0x2c,%esp
  101e52:	5b                   	pop    %ebx
  101e53:	5e                   	pop    %esi
  101e54:	5f                   	pop    %edi
  101e55:	5d                   	pop    %ebp
  101e56:	c3                   	ret    

00101e57 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e57:	55                   	push   %ebp
  101e58:	89 e5                	mov    %esp,%ebp
  101e5a:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e60:	89 04 24             	mov    %eax,(%esp)
  101e63:	e8 dd fd ff ff       	call   101c45 <trap_dispatch>
}
  101e68:	c9                   	leave  
  101e69:	c3                   	ret    

00101e6a <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e6a:	1e                   	push   %ds
    pushl %es
  101e6b:	06                   	push   %es
    pushl %fs
  101e6c:	0f a0                	push   %fs
    pushl %gs
  101e6e:	0f a8                	push   %gs
    pushal
  101e70:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e71:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e76:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e78:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e7a:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e7b:	e8 d7 ff ff ff       	call   101e57 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e80:	5c                   	pop    %esp

00101e81 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e81:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e82:	0f a9                	pop    %gs
    popl %fs
  101e84:	0f a1                	pop    %fs
    popl %es
  101e86:	07                   	pop    %es
    popl %ds
  101e87:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e88:	83 c4 08             	add    $0x8,%esp
    iret
  101e8b:	cf                   	iret   

00101e8c <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e8c:	6a 00                	push   $0x0
  pushl $0
  101e8e:	6a 00                	push   $0x0
  jmp __alltraps
  101e90:	e9 d5 ff ff ff       	jmp    101e6a <__alltraps>

00101e95 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e95:	6a 00                	push   $0x0
  pushl $1
  101e97:	6a 01                	push   $0x1
  jmp __alltraps
  101e99:	e9 cc ff ff ff       	jmp    101e6a <__alltraps>

00101e9e <vector2>:
.globl vector2
vector2:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $2
  101ea0:	6a 02                	push   $0x2
  jmp __alltraps
  101ea2:	e9 c3 ff ff ff       	jmp    101e6a <__alltraps>

00101ea7 <vector3>:
.globl vector3
vector3:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $3
  101ea9:	6a 03                	push   $0x3
  jmp __alltraps
  101eab:	e9 ba ff ff ff       	jmp    101e6a <__alltraps>

00101eb0 <vector4>:
.globl vector4
vector4:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $4
  101eb2:	6a 04                	push   $0x4
  jmp __alltraps
  101eb4:	e9 b1 ff ff ff       	jmp    101e6a <__alltraps>

00101eb9 <vector5>:
.globl vector5
vector5:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $5
  101ebb:	6a 05                	push   $0x5
  jmp __alltraps
  101ebd:	e9 a8 ff ff ff       	jmp    101e6a <__alltraps>

00101ec2 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $6
  101ec4:	6a 06                	push   $0x6
  jmp __alltraps
  101ec6:	e9 9f ff ff ff       	jmp    101e6a <__alltraps>

00101ecb <vector7>:
.globl vector7
vector7:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $7
  101ecd:	6a 07                	push   $0x7
  jmp __alltraps
  101ecf:	e9 96 ff ff ff       	jmp    101e6a <__alltraps>

00101ed4 <vector8>:
.globl vector8
vector8:
  pushl $8
  101ed4:	6a 08                	push   $0x8
  jmp __alltraps
  101ed6:	e9 8f ff ff ff       	jmp    101e6a <__alltraps>

00101edb <vector9>:
.globl vector9
vector9:
  pushl $9
  101edb:	6a 09                	push   $0x9
  jmp __alltraps
  101edd:	e9 88 ff ff ff       	jmp    101e6a <__alltraps>

00101ee2 <vector10>:
.globl vector10
vector10:
  pushl $10
  101ee2:	6a 0a                	push   $0xa
  jmp __alltraps
  101ee4:	e9 81 ff ff ff       	jmp    101e6a <__alltraps>

00101ee9 <vector11>:
.globl vector11
vector11:
  pushl $11
  101ee9:	6a 0b                	push   $0xb
  jmp __alltraps
  101eeb:	e9 7a ff ff ff       	jmp    101e6a <__alltraps>

00101ef0 <vector12>:
.globl vector12
vector12:
  pushl $12
  101ef0:	6a 0c                	push   $0xc
  jmp __alltraps
  101ef2:	e9 73 ff ff ff       	jmp    101e6a <__alltraps>

00101ef7 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ef7:	6a 0d                	push   $0xd
  jmp __alltraps
  101ef9:	e9 6c ff ff ff       	jmp    101e6a <__alltraps>

00101efe <vector14>:
.globl vector14
vector14:
  pushl $14
  101efe:	6a 0e                	push   $0xe
  jmp __alltraps
  101f00:	e9 65 ff ff ff       	jmp    101e6a <__alltraps>

00101f05 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f05:	6a 00                	push   $0x0
  pushl $15
  101f07:	6a 0f                	push   $0xf
  jmp __alltraps
  101f09:	e9 5c ff ff ff       	jmp    101e6a <__alltraps>

00101f0e <vector16>:
.globl vector16
vector16:
  pushl $0
  101f0e:	6a 00                	push   $0x0
  pushl $16
  101f10:	6a 10                	push   $0x10
  jmp __alltraps
  101f12:	e9 53 ff ff ff       	jmp    101e6a <__alltraps>

00101f17 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f17:	6a 11                	push   $0x11
  jmp __alltraps
  101f19:	e9 4c ff ff ff       	jmp    101e6a <__alltraps>

00101f1e <vector18>:
.globl vector18
vector18:
  pushl $0
  101f1e:	6a 00                	push   $0x0
  pushl $18
  101f20:	6a 12                	push   $0x12
  jmp __alltraps
  101f22:	e9 43 ff ff ff       	jmp    101e6a <__alltraps>

00101f27 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f27:	6a 00                	push   $0x0
  pushl $19
  101f29:	6a 13                	push   $0x13
  jmp __alltraps
  101f2b:	e9 3a ff ff ff       	jmp    101e6a <__alltraps>

00101f30 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f30:	6a 00                	push   $0x0
  pushl $20
  101f32:	6a 14                	push   $0x14
  jmp __alltraps
  101f34:	e9 31 ff ff ff       	jmp    101e6a <__alltraps>

00101f39 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f39:	6a 00                	push   $0x0
  pushl $21
  101f3b:	6a 15                	push   $0x15
  jmp __alltraps
  101f3d:	e9 28 ff ff ff       	jmp    101e6a <__alltraps>

00101f42 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $22
  101f44:	6a 16                	push   $0x16
  jmp __alltraps
  101f46:	e9 1f ff ff ff       	jmp    101e6a <__alltraps>

00101f4b <vector23>:
.globl vector23
vector23:
  pushl $0
  101f4b:	6a 00                	push   $0x0
  pushl $23
  101f4d:	6a 17                	push   $0x17
  jmp __alltraps
  101f4f:	e9 16 ff ff ff       	jmp    101e6a <__alltraps>

00101f54 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f54:	6a 00                	push   $0x0
  pushl $24
  101f56:	6a 18                	push   $0x18
  jmp __alltraps
  101f58:	e9 0d ff ff ff       	jmp    101e6a <__alltraps>

00101f5d <vector25>:
.globl vector25
vector25:
  pushl $0
  101f5d:	6a 00                	push   $0x0
  pushl $25
  101f5f:	6a 19                	push   $0x19
  jmp __alltraps
  101f61:	e9 04 ff ff ff       	jmp    101e6a <__alltraps>

00101f66 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f66:	6a 00                	push   $0x0
  pushl $26
  101f68:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f6a:	e9 fb fe ff ff       	jmp    101e6a <__alltraps>

00101f6f <vector27>:
.globl vector27
vector27:
  pushl $0
  101f6f:	6a 00                	push   $0x0
  pushl $27
  101f71:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f73:	e9 f2 fe ff ff       	jmp    101e6a <__alltraps>

00101f78 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f78:	6a 00                	push   $0x0
  pushl $28
  101f7a:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f7c:	e9 e9 fe ff ff       	jmp    101e6a <__alltraps>

00101f81 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f81:	6a 00                	push   $0x0
  pushl $29
  101f83:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f85:	e9 e0 fe ff ff       	jmp    101e6a <__alltraps>

00101f8a <vector30>:
.globl vector30
vector30:
  pushl $0
  101f8a:	6a 00                	push   $0x0
  pushl $30
  101f8c:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f8e:	e9 d7 fe ff ff       	jmp    101e6a <__alltraps>

00101f93 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f93:	6a 00                	push   $0x0
  pushl $31
  101f95:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f97:	e9 ce fe ff ff       	jmp    101e6a <__alltraps>

00101f9c <vector32>:
.globl vector32
vector32:
  pushl $0
  101f9c:	6a 00                	push   $0x0
  pushl $32
  101f9e:	6a 20                	push   $0x20
  jmp __alltraps
  101fa0:	e9 c5 fe ff ff       	jmp    101e6a <__alltraps>

00101fa5 <vector33>:
.globl vector33
vector33:
  pushl $0
  101fa5:	6a 00                	push   $0x0
  pushl $33
  101fa7:	6a 21                	push   $0x21
  jmp __alltraps
  101fa9:	e9 bc fe ff ff       	jmp    101e6a <__alltraps>

00101fae <vector34>:
.globl vector34
vector34:
  pushl $0
  101fae:	6a 00                	push   $0x0
  pushl $34
  101fb0:	6a 22                	push   $0x22
  jmp __alltraps
  101fb2:	e9 b3 fe ff ff       	jmp    101e6a <__alltraps>

00101fb7 <vector35>:
.globl vector35
vector35:
  pushl $0
  101fb7:	6a 00                	push   $0x0
  pushl $35
  101fb9:	6a 23                	push   $0x23
  jmp __alltraps
  101fbb:	e9 aa fe ff ff       	jmp    101e6a <__alltraps>

00101fc0 <vector36>:
.globl vector36
vector36:
  pushl $0
  101fc0:	6a 00                	push   $0x0
  pushl $36
  101fc2:	6a 24                	push   $0x24
  jmp __alltraps
  101fc4:	e9 a1 fe ff ff       	jmp    101e6a <__alltraps>

00101fc9 <vector37>:
.globl vector37
vector37:
  pushl $0
  101fc9:	6a 00                	push   $0x0
  pushl $37
  101fcb:	6a 25                	push   $0x25
  jmp __alltraps
  101fcd:	e9 98 fe ff ff       	jmp    101e6a <__alltraps>

00101fd2 <vector38>:
.globl vector38
vector38:
  pushl $0
  101fd2:	6a 00                	push   $0x0
  pushl $38
  101fd4:	6a 26                	push   $0x26
  jmp __alltraps
  101fd6:	e9 8f fe ff ff       	jmp    101e6a <__alltraps>

00101fdb <vector39>:
.globl vector39
vector39:
  pushl $0
  101fdb:	6a 00                	push   $0x0
  pushl $39
  101fdd:	6a 27                	push   $0x27
  jmp __alltraps
  101fdf:	e9 86 fe ff ff       	jmp    101e6a <__alltraps>

00101fe4 <vector40>:
.globl vector40
vector40:
  pushl $0
  101fe4:	6a 00                	push   $0x0
  pushl $40
  101fe6:	6a 28                	push   $0x28
  jmp __alltraps
  101fe8:	e9 7d fe ff ff       	jmp    101e6a <__alltraps>

00101fed <vector41>:
.globl vector41
vector41:
  pushl $0
  101fed:	6a 00                	push   $0x0
  pushl $41
  101fef:	6a 29                	push   $0x29
  jmp __alltraps
  101ff1:	e9 74 fe ff ff       	jmp    101e6a <__alltraps>

00101ff6 <vector42>:
.globl vector42
vector42:
  pushl $0
  101ff6:	6a 00                	push   $0x0
  pushl $42
  101ff8:	6a 2a                	push   $0x2a
  jmp __alltraps
  101ffa:	e9 6b fe ff ff       	jmp    101e6a <__alltraps>

00101fff <vector43>:
.globl vector43
vector43:
  pushl $0
  101fff:	6a 00                	push   $0x0
  pushl $43
  102001:	6a 2b                	push   $0x2b
  jmp __alltraps
  102003:	e9 62 fe ff ff       	jmp    101e6a <__alltraps>

00102008 <vector44>:
.globl vector44
vector44:
  pushl $0
  102008:	6a 00                	push   $0x0
  pushl $44
  10200a:	6a 2c                	push   $0x2c
  jmp __alltraps
  10200c:	e9 59 fe ff ff       	jmp    101e6a <__alltraps>

00102011 <vector45>:
.globl vector45
vector45:
  pushl $0
  102011:	6a 00                	push   $0x0
  pushl $45
  102013:	6a 2d                	push   $0x2d
  jmp __alltraps
  102015:	e9 50 fe ff ff       	jmp    101e6a <__alltraps>

0010201a <vector46>:
.globl vector46
vector46:
  pushl $0
  10201a:	6a 00                	push   $0x0
  pushl $46
  10201c:	6a 2e                	push   $0x2e
  jmp __alltraps
  10201e:	e9 47 fe ff ff       	jmp    101e6a <__alltraps>

00102023 <vector47>:
.globl vector47
vector47:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $47
  102025:	6a 2f                	push   $0x2f
  jmp __alltraps
  102027:	e9 3e fe ff ff       	jmp    101e6a <__alltraps>

0010202c <vector48>:
.globl vector48
vector48:
  pushl $0
  10202c:	6a 00                	push   $0x0
  pushl $48
  10202e:	6a 30                	push   $0x30
  jmp __alltraps
  102030:	e9 35 fe ff ff       	jmp    101e6a <__alltraps>

00102035 <vector49>:
.globl vector49
vector49:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $49
  102037:	6a 31                	push   $0x31
  jmp __alltraps
  102039:	e9 2c fe ff ff       	jmp    101e6a <__alltraps>

0010203e <vector50>:
.globl vector50
vector50:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $50
  102040:	6a 32                	push   $0x32
  jmp __alltraps
  102042:	e9 23 fe ff ff       	jmp    101e6a <__alltraps>

00102047 <vector51>:
.globl vector51
vector51:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $51
  102049:	6a 33                	push   $0x33
  jmp __alltraps
  10204b:	e9 1a fe ff ff       	jmp    101e6a <__alltraps>

00102050 <vector52>:
.globl vector52
vector52:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $52
  102052:	6a 34                	push   $0x34
  jmp __alltraps
  102054:	e9 11 fe ff ff       	jmp    101e6a <__alltraps>

00102059 <vector53>:
.globl vector53
vector53:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $53
  10205b:	6a 35                	push   $0x35
  jmp __alltraps
  10205d:	e9 08 fe ff ff       	jmp    101e6a <__alltraps>

00102062 <vector54>:
.globl vector54
vector54:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $54
  102064:	6a 36                	push   $0x36
  jmp __alltraps
  102066:	e9 ff fd ff ff       	jmp    101e6a <__alltraps>

0010206b <vector55>:
.globl vector55
vector55:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $55
  10206d:	6a 37                	push   $0x37
  jmp __alltraps
  10206f:	e9 f6 fd ff ff       	jmp    101e6a <__alltraps>

00102074 <vector56>:
.globl vector56
vector56:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $56
  102076:	6a 38                	push   $0x38
  jmp __alltraps
  102078:	e9 ed fd ff ff       	jmp    101e6a <__alltraps>

0010207d <vector57>:
.globl vector57
vector57:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $57
  10207f:	6a 39                	push   $0x39
  jmp __alltraps
  102081:	e9 e4 fd ff ff       	jmp    101e6a <__alltraps>

00102086 <vector58>:
.globl vector58
vector58:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $58
  102088:	6a 3a                	push   $0x3a
  jmp __alltraps
  10208a:	e9 db fd ff ff       	jmp    101e6a <__alltraps>

0010208f <vector59>:
.globl vector59
vector59:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $59
  102091:	6a 3b                	push   $0x3b
  jmp __alltraps
  102093:	e9 d2 fd ff ff       	jmp    101e6a <__alltraps>

00102098 <vector60>:
.globl vector60
vector60:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $60
  10209a:	6a 3c                	push   $0x3c
  jmp __alltraps
  10209c:	e9 c9 fd ff ff       	jmp    101e6a <__alltraps>

001020a1 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $61
  1020a3:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020a5:	e9 c0 fd ff ff       	jmp    101e6a <__alltraps>

001020aa <vector62>:
.globl vector62
vector62:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $62
  1020ac:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020ae:	e9 b7 fd ff ff       	jmp    101e6a <__alltraps>

001020b3 <vector63>:
.globl vector63
vector63:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $63
  1020b5:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020b7:	e9 ae fd ff ff       	jmp    101e6a <__alltraps>

001020bc <vector64>:
.globl vector64
vector64:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $64
  1020be:	6a 40                	push   $0x40
  jmp __alltraps
  1020c0:	e9 a5 fd ff ff       	jmp    101e6a <__alltraps>

001020c5 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $65
  1020c7:	6a 41                	push   $0x41
  jmp __alltraps
  1020c9:	e9 9c fd ff ff       	jmp    101e6a <__alltraps>

001020ce <vector66>:
.globl vector66
vector66:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $66
  1020d0:	6a 42                	push   $0x42
  jmp __alltraps
  1020d2:	e9 93 fd ff ff       	jmp    101e6a <__alltraps>

001020d7 <vector67>:
.globl vector67
vector67:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $67
  1020d9:	6a 43                	push   $0x43
  jmp __alltraps
  1020db:	e9 8a fd ff ff       	jmp    101e6a <__alltraps>

001020e0 <vector68>:
.globl vector68
vector68:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $68
  1020e2:	6a 44                	push   $0x44
  jmp __alltraps
  1020e4:	e9 81 fd ff ff       	jmp    101e6a <__alltraps>

001020e9 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $69
  1020eb:	6a 45                	push   $0x45
  jmp __alltraps
  1020ed:	e9 78 fd ff ff       	jmp    101e6a <__alltraps>

001020f2 <vector70>:
.globl vector70
vector70:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $70
  1020f4:	6a 46                	push   $0x46
  jmp __alltraps
  1020f6:	e9 6f fd ff ff       	jmp    101e6a <__alltraps>

001020fb <vector71>:
.globl vector71
vector71:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $71
  1020fd:	6a 47                	push   $0x47
  jmp __alltraps
  1020ff:	e9 66 fd ff ff       	jmp    101e6a <__alltraps>

00102104 <vector72>:
.globl vector72
vector72:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $72
  102106:	6a 48                	push   $0x48
  jmp __alltraps
  102108:	e9 5d fd ff ff       	jmp    101e6a <__alltraps>

0010210d <vector73>:
.globl vector73
vector73:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $73
  10210f:	6a 49                	push   $0x49
  jmp __alltraps
  102111:	e9 54 fd ff ff       	jmp    101e6a <__alltraps>

00102116 <vector74>:
.globl vector74
vector74:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $74
  102118:	6a 4a                	push   $0x4a
  jmp __alltraps
  10211a:	e9 4b fd ff ff       	jmp    101e6a <__alltraps>

0010211f <vector75>:
.globl vector75
vector75:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $75
  102121:	6a 4b                	push   $0x4b
  jmp __alltraps
  102123:	e9 42 fd ff ff       	jmp    101e6a <__alltraps>

00102128 <vector76>:
.globl vector76
vector76:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $76
  10212a:	6a 4c                	push   $0x4c
  jmp __alltraps
  10212c:	e9 39 fd ff ff       	jmp    101e6a <__alltraps>

00102131 <vector77>:
.globl vector77
vector77:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $77
  102133:	6a 4d                	push   $0x4d
  jmp __alltraps
  102135:	e9 30 fd ff ff       	jmp    101e6a <__alltraps>

0010213a <vector78>:
.globl vector78
vector78:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $78
  10213c:	6a 4e                	push   $0x4e
  jmp __alltraps
  10213e:	e9 27 fd ff ff       	jmp    101e6a <__alltraps>

00102143 <vector79>:
.globl vector79
vector79:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $79
  102145:	6a 4f                	push   $0x4f
  jmp __alltraps
  102147:	e9 1e fd ff ff       	jmp    101e6a <__alltraps>

0010214c <vector80>:
.globl vector80
vector80:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $80
  10214e:	6a 50                	push   $0x50
  jmp __alltraps
  102150:	e9 15 fd ff ff       	jmp    101e6a <__alltraps>

00102155 <vector81>:
.globl vector81
vector81:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $81
  102157:	6a 51                	push   $0x51
  jmp __alltraps
  102159:	e9 0c fd ff ff       	jmp    101e6a <__alltraps>

0010215e <vector82>:
.globl vector82
vector82:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $82
  102160:	6a 52                	push   $0x52
  jmp __alltraps
  102162:	e9 03 fd ff ff       	jmp    101e6a <__alltraps>

00102167 <vector83>:
.globl vector83
vector83:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $83
  102169:	6a 53                	push   $0x53
  jmp __alltraps
  10216b:	e9 fa fc ff ff       	jmp    101e6a <__alltraps>

00102170 <vector84>:
.globl vector84
vector84:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $84
  102172:	6a 54                	push   $0x54
  jmp __alltraps
  102174:	e9 f1 fc ff ff       	jmp    101e6a <__alltraps>

00102179 <vector85>:
.globl vector85
vector85:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $85
  10217b:	6a 55                	push   $0x55
  jmp __alltraps
  10217d:	e9 e8 fc ff ff       	jmp    101e6a <__alltraps>

00102182 <vector86>:
.globl vector86
vector86:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $86
  102184:	6a 56                	push   $0x56
  jmp __alltraps
  102186:	e9 df fc ff ff       	jmp    101e6a <__alltraps>

0010218b <vector87>:
.globl vector87
vector87:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $87
  10218d:	6a 57                	push   $0x57
  jmp __alltraps
  10218f:	e9 d6 fc ff ff       	jmp    101e6a <__alltraps>

00102194 <vector88>:
.globl vector88
vector88:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $88
  102196:	6a 58                	push   $0x58
  jmp __alltraps
  102198:	e9 cd fc ff ff       	jmp    101e6a <__alltraps>

0010219d <vector89>:
.globl vector89
vector89:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $89
  10219f:	6a 59                	push   $0x59
  jmp __alltraps
  1021a1:	e9 c4 fc ff ff       	jmp    101e6a <__alltraps>

001021a6 <vector90>:
.globl vector90
vector90:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $90
  1021a8:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021aa:	e9 bb fc ff ff       	jmp    101e6a <__alltraps>

001021af <vector91>:
.globl vector91
vector91:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $91
  1021b1:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021b3:	e9 b2 fc ff ff       	jmp    101e6a <__alltraps>

001021b8 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $92
  1021ba:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021bc:	e9 a9 fc ff ff       	jmp    101e6a <__alltraps>

001021c1 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $93
  1021c3:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021c5:	e9 a0 fc ff ff       	jmp    101e6a <__alltraps>

001021ca <vector94>:
.globl vector94
vector94:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $94
  1021cc:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021ce:	e9 97 fc ff ff       	jmp    101e6a <__alltraps>

001021d3 <vector95>:
.globl vector95
vector95:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $95
  1021d5:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021d7:	e9 8e fc ff ff       	jmp    101e6a <__alltraps>

001021dc <vector96>:
.globl vector96
vector96:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $96
  1021de:	6a 60                	push   $0x60
  jmp __alltraps
  1021e0:	e9 85 fc ff ff       	jmp    101e6a <__alltraps>

001021e5 <vector97>:
.globl vector97
vector97:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $97
  1021e7:	6a 61                	push   $0x61
  jmp __alltraps
  1021e9:	e9 7c fc ff ff       	jmp    101e6a <__alltraps>

001021ee <vector98>:
.globl vector98
vector98:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $98
  1021f0:	6a 62                	push   $0x62
  jmp __alltraps
  1021f2:	e9 73 fc ff ff       	jmp    101e6a <__alltraps>

001021f7 <vector99>:
.globl vector99
vector99:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $99
  1021f9:	6a 63                	push   $0x63
  jmp __alltraps
  1021fb:	e9 6a fc ff ff       	jmp    101e6a <__alltraps>

00102200 <vector100>:
.globl vector100
vector100:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $100
  102202:	6a 64                	push   $0x64
  jmp __alltraps
  102204:	e9 61 fc ff ff       	jmp    101e6a <__alltraps>

00102209 <vector101>:
.globl vector101
vector101:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $101
  10220b:	6a 65                	push   $0x65
  jmp __alltraps
  10220d:	e9 58 fc ff ff       	jmp    101e6a <__alltraps>

00102212 <vector102>:
.globl vector102
vector102:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $102
  102214:	6a 66                	push   $0x66
  jmp __alltraps
  102216:	e9 4f fc ff ff       	jmp    101e6a <__alltraps>

0010221b <vector103>:
.globl vector103
vector103:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $103
  10221d:	6a 67                	push   $0x67
  jmp __alltraps
  10221f:	e9 46 fc ff ff       	jmp    101e6a <__alltraps>

00102224 <vector104>:
.globl vector104
vector104:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $104
  102226:	6a 68                	push   $0x68
  jmp __alltraps
  102228:	e9 3d fc ff ff       	jmp    101e6a <__alltraps>

0010222d <vector105>:
.globl vector105
vector105:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $105
  10222f:	6a 69                	push   $0x69
  jmp __alltraps
  102231:	e9 34 fc ff ff       	jmp    101e6a <__alltraps>

00102236 <vector106>:
.globl vector106
vector106:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $106
  102238:	6a 6a                	push   $0x6a
  jmp __alltraps
  10223a:	e9 2b fc ff ff       	jmp    101e6a <__alltraps>

0010223f <vector107>:
.globl vector107
vector107:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $107
  102241:	6a 6b                	push   $0x6b
  jmp __alltraps
  102243:	e9 22 fc ff ff       	jmp    101e6a <__alltraps>

00102248 <vector108>:
.globl vector108
vector108:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $108
  10224a:	6a 6c                	push   $0x6c
  jmp __alltraps
  10224c:	e9 19 fc ff ff       	jmp    101e6a <__alltraps>

00102251 <vector109>:
.globl vector109
vector109:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $109
  102253:	6a 6d                	push   $0x6d
  jmp __alltraps
  102255:	e9 10 fc ff ff       	jmp    101e6a <__alltraps>

0010225a <vector110>:
.globl vector110
vector110:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $110
  10225c:	6a 6e                	push   $0x6e
  jmp __alltraps
  10225e:	e9 07 fc ff ff       	jmp    101e6a <__alltraps>

00102263 <vector111>:
.globl vector111
vector111:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $111
  102265:	6a 6f                	push   $0x6f
  jmp __alltraps
  102267:	e9 fe fb ff ff       	jmp    101e6a <__alltraps>

0010226c <vector112>:
.globl vector112
vector112:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $112
  10226e:	6a 70                	push   $0x70
  jmp __alltraps
  102270:	e9 f5 fb ff ff       	jmp    101e6a <__alltraps>

00102275 <vector113>:
.globl vector113
vector113:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $113
  102277:	6a 71                	push   $0x71
  jmp __alltraps
  102279:	e9 ec fb ff ff       	jmp    101e6a <__alltraps>

0010227e <vector114>:
.globl vector114
vector114:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $114
  102280:	6a 72                	push   $0x72
  jmp __alltraps
  102282:	e9 e3 fb ff ff       	jmp    101e6a <__alltraps>

00102287 <vector115>:
.globl vector115
vector115:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $115
  102289:	6a 73                	push   $0x73
  jmp __alltraps
  10228b:	e9 da fb ff ff       	jmp    101e6a <__alltraps>

00102290 <vector116>:
.globl vector116
vector116:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $116
  102292:	6a 74                	push   $0x74
  jmp __alltraps
  102294:	e9 d1 fb ff ff       	jmp    101e6a <__alltraps>

00102299 <vector117>:
.globl vector117
vector117:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $117
  10229b:	6a 75                	push   $0x75
  jmp __alltraps
  10229d:	e9 c8 fb ff ff       	jmp    101e6a <__alltraps>

001022a2 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $118
  1022a4:	6a 76                	push   $0x76
  jmp __alltraps
  1022a6:	e9 bf fb ff ff       	jmp    101e6a <__alltraps>

001022ab <vector119>:
.globl vector119
vector119:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $119
  1022ad:	6a 77                	push   $0x77
  jmp __alltraps
  1022af:	e9 b6 fb ff ff       	jmp    101e6a <__alltraps>

001022b4 <vector120>:
.globl vector120
vector120:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $120
  1022b6:	6a 78                	push   $0x78
  jmp __alltraps
  1022b8:	e9 ad fb ff ff       	jmp    101e6a <__alltraps>

001022bd <vector121>:
.globl vector121
vector121:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $121
  1022bf:	6a 79                	push   $0x79
  jmp __alltraps
  1022c1:	e9 a4 fb ff ff       	jmp    101e6a <__alltraps>

001022c6 <vector122>:
.globl vector122
vector122:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $122
  1022c8:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022ca:	e9 9b fb ff ff       	jmp    101e6a <__alltraps>

001022cf <vector123>:
.globl vector123
vector123:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $123
  1022d1:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022d3:	e9 92 fb ff ff       	jmp    101e6a <__alltraps>

001022d8 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $124
  1022da:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022dc:	e9 89 fb ff ff       	jmp    101e6a <__alltraps>

001022e1 <vector125>:
.globl vector125
vector125:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $125
  1022e3:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022e5:	e9 80 fb ff ff       	jmp    101e6a <__alltraps>

001022ea <vector126>:
.globl vector126
vector126:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $126
  1022ec:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022ee:	e9 77 fb ff ff       	jmp    101e6a <__alltraps>

001022f3 <vector127>:
.globl vector127
vector127:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $127
  1022f5:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022f7:	e9 6e fb ff ff       	jmp    101e6a <__alltraps>

001022fc <vector128>:
.globl vector128
vector128:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $128
  1022fe:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102303:	e9 62 fb ff ff       	jmp    101e6a <__alltraps>

00102308 <vector129>:
.globl vector129
vector129:
  pushl $0
  102308:	6a 00                	push   $0x0
  pushl $129
  10230a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10230f:	e9 56 fb ff ff       	jmp    101e6a <__alltraps>

00102314 <vector130>:
.globl vector130
vector130:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $130
  102316:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10231b:	e9 4a fb ff ff       	jmp    101e6a <__alltraps>

00102320 <vector131>:
.globl vector131
vector131:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $131
  102322:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102327:	e9 3e fb ff ff       	jmp    101e6a <__alltraps>

0010232c <vector132>:
.globl vector132
vector132:
  pushl $0
  10232c:	6a 00                	push   $0x0
  pushl $132
  10232e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102333:	e9 32 fb ff ff       	jmp    101e6a <__alltraps>

00102338 <vector133>:
.globl vector133
vector133:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $133
  10233a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10233f:	e9 26 fb ff ff       	jmp    101e6a <__alltraps>

00102344 <vector134>:
.globl vector134
vector134:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $134
  102346:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10234b:	e9 1a fb ff ff       	jmp    101e6a <__alltraps>

00102350 <vector135>:
.globl vector135
vector135:
  pushl $0
  102350:	6a 00                	push   $0x0
  pushl $135
  102352:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102357:	e9 0e fb ff ff       	jmp    101e6a <__alltraps>

0010235c <vector136>:
.globl vector136
vector136:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $136
  10235e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102363:	e9 02 fb ff ff       	jmp    101e6a <__alltraps>

00102368 <vector137>:
.globl vector137
vector137:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $137
  10236a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10236f:	e9 f6 fa ff ff       	jmp    101e6a <__alltraps>

00102374 <vector138>:
.globl vector138
vector138:
  pushl $0
  102374:	6a 00                	push   $0x0
  pushl $138
  102376:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10237b:	e9 ea fa ff ff       	jmp    101e6a <__alltraps>

00102380 <vector139>:
.globl vector139
vector139:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $139
  102382:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102387:	e9 de fa ff ff       	jmp    101e6a <__alltraps>

0010238c <vector140>:
.globl vector140
vector140:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $140
  10238e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102393:	e9 d2 fa ff ff       	jmp    101e6a <__alltraps>

00102398 <vector141>:
.globl vector141
vector141:
  pushl $0
  102398:	6a 00                	push   $0x0
  pushl $141
  10239a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10239f:	e9 c6 fa ff ff       	jmp    101e6a <__alltraps>

001023a4 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $142
  1023a6:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023ab:	e9 ba fa ff ff       	jmp    101e6a <__alltraps>

001023b0 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $143
  1023b2:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023b7:	e9 ae fa ff ff       	jmp    101e6a <__alltraps>

001023bc <vector144>:
.globl vector144
vector144:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $144
  1023be:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023c3:	e9 a2 fa ff ff       	jmp    101e6a <__alltraps>

001023c8 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $145
  1023ca:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023cf:	e9 96 fa ff ff       	jmp    101e6a <__alltraps>

001023d4 <vector146>:
.globl vector146
vector146:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $146
  1023d6:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023db:	e9 8a fa ff ff       	jmp    101e6a <__alltraps>

001023e0 <vector147>:
.globl vector147
vector147:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $147
  1023e2:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023e7:	e9 7e fa ff ff       	jmp    101e6a <__alltraps>

001023ec <vector148>:
.globl vector148
vector148:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $148
  1023ee:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023f3:	e9 72 fa ff ff       	jmp    101e6a <__alltraps>

001023f8 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $149
  1023fa:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023ff:	e9 66 fa ff ff       	jmp    101e6a <__alltraps>

00102404 <vector150>:
.globl vector150
vector150:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $150
  102406:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10240b:	e9 5a fa ff ff       	jmp    101e6a <__alltraps>

00102410 <vector151>:
.globl vector151
vector151:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $151
  102412:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102417:	e9 4e fa ff ff       	jmp    101e6a <__alltraps>

0010241c <vector152>:
.globl vector152
vector152:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $152
  10241e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102423:	e9 42 fa ff ff       	jmp    101e6a <__alltraps>

00102428 <vector153>:
.globl vector153
vector153:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $153
  10242a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10242f:	e9 36 fa ff ff       	jmp    101e6a <__alltraps>

00102434 <vector154>:
.globl vector154
vector154:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $154
  102436:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10243b:	e9 2a fa ff ff       	jmp    101e6a <__alltraps>

00102440 <vector155>:
.globl vector155
vector155:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $155
  102442:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102447:	e9 1e fa ff ff       	jmp    101e6a <__alltraps>

0010244c <vector156>:
.globl vector156
vector156:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $156
  10244e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102453:	e9 12 fa ff ff       	jmp    101e6a <__alltraps>

00102458 <vector157>:
.globl vector157
vector157:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $157
  10245a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10245f:	e9 06 fa ff ff       	jmp    101e6a <__alltraps>

00102464 <vector158>:
.globl vector158
vector158:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $158
  102466:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10246b:	e9 fa f9 ff ff       	jmp    101e6a <__alltraps>

00102470 <vector159>:
.globl vector159
vector159:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $159
  102472:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102477:	e9 ee f9 ff ff       	jmp    101e6a <__alltraps>

0010247c <vector160>:
.globl vector160
vector160:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $160
  10247e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102483:	e9 e2 f9 ff ff       	jmp    101e6a <__alltraps>

00102488 <vector161>:
.globl vector161
vector161:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $161
  10248a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10248f:	e9 d6 f9 ff ff       	jmp    101e6a <__alltraps>

00102494 <vector162>:
.globl vector162
vector162:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $162
  102496:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10249b:	e9 ca f9 ff ff       	jmp    101e6a <__alltraps>

001024a0 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $163
  1024a2:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024a7:	e9 be f9 ff ff       	jmp    101e6a <__alltraps>

001024ac <vector164>:
.globl vector164
vector164:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $164
  1024ae:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024b3:	e9 b2 f9 ff ff       	jmp    101e6a <__alltraps>

001024b8 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $165
  1024ba:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024bf:	e9 a6 f9 ff ff       	jmp    101e6a <__alltraps>

001024c4 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $166
  1024c6:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024cb:	e9 9a f9 ff ff       	jmp    101e6a <__alltraps>

001024d0 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $167
  1024d2:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024d7:	e9 8e f9 ff ff       	jmp    101e6a <__alltraps>

001024dc <vector168>:
.globl vector168
vector168:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $168
  1024de:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024e3:	e9 82 f9 ff ff       	jmp    101e6a <__alltraps>

001024e8 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $169
  1024ea:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024ef:	e9 76 f9 ff ff       	jmp    101e6a <__alltraps>

001024f4 <vector170>:
.globl vector170
vector170:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $170
  1024f6:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024fb:	e9 6a f9 ff ff       	jmp    101e6a <__alltraps>

00102500 <vector171>:
.globl vector171
vector171:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $171
  102502:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102507:	e9 5e f9 ff ff       	jmp    101e6a <__alltraps>

0010250c <vector172>:
.globl vector172
vector172:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $172
  10250e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102513:	e9 52 f9 ff ff       	jmp    101e6a <__alltraps>

00102518 <vector173>:
.globl vector173
vector173:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $173
  10251a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10251f:	e9 46 f9 ff ff       	jmp    101e6a <__alltraps>

00102524 <vector174>:
.globl vector174
vector174:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $174
  102526:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10252b:	e9 3a f9 ff ff       	jmp    101e6a <__alltraps>

00102530 <vector175>:
.globl vector175
vector175:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $175
  102532:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102537:	e9 2e f9 ff ff       	jmp    101e6a <__alltraps>

0010253c <vector176>:
.globl vector176
vector176:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $176
  10253e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102543:	e9 22 f9 ff ff       	jmp    101e6a <__alltraps>

00102548 <vector177>:
.globl vector177
vector177:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $177
  10254a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10254f:	e9 16 f9 ff ff       	jmp    101e6a <__alltraps>

00102554 <vector178>:
.globl vector178
vector178:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $178
  102556:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10255b:	e9 0a f9 ff ff       	jmp    101e6a <__alltraps>

00102560 <vector179>:
.globl vector179
vector179:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $179
  102562:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102567:	e9 fe f8 ff ff       	jmp    101e6a <__alltraps>

0010256c <vector180>:
.globl vector180
vector180:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $180
  10256e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102573:	e9 f2 f8 ff ff       	jmp    101e6a <__alltraps>

00102578 <vector181>:
.globl vector181
vector181:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $181
  10257a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10257f:	e9 e6 f8 ff ff       	jmp    101e6a <__alltraps>

00102584 <vector182>:
.globl vector182
vector182:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $182
  102586:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10258b:	e9 da f8 ff ff       	jmp    101e6a <__alltraps>

00102590 <vector183>:
.globl vector183
vector183:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $183
  102592:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102597:	e9 ce f8 ff ff       	jmp    101e6a <__alltraps>

0010259c <vector184>:
.globl vector184
vector184:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $184
  10259e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025a3:	e9 c2 f8 ff ff       	jmp    101e6a <__alltraps>

001025a8 <vector185>:
.globl vector185
vector185:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $185
  1025aa:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025af:	e9 b6 f8 ff ff       	jmp    101e6a <__alltraps>

001025b4 <vector186>:
.globl vector186
vector186:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $186
  1025b6:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025bb:	e9 aa f8 ff ff       	jmp    101e6a <__alltraps>

001025c0 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $187
  1025c2:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025c7:	e9 9e f8 ff ff       	jmp    101e6a <__alltraps>

001025cc <vector188>:
.globl vector188
vector188:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $188
  1025ce:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025d3:	e9 92 f8 ff ff       	jmp    101e6a <__alltraps>

001025d8 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $189
  1025da:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025df:	e9 86 f8 ff ff       	jmp    101e6a <__alltraps>

001025e4 <vector190>:
.globl vector190
vector190:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $190
  1025e6:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025eb:	e9 7a f8 ff ff       	jmp    101e6a <__alltraps>

001025f0 <vector191>:
.globl vector191
vector191:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $191
  1025f2:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025f7:	e9 6e f8 ff ff       	jmp    101e6a <__alltraps>

001025fc <vector192>:
.globl vector192
vector192:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $192
  1025fe:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102603:	e9 62 f8 ff ff       	jmp    101e6a <__alltraps>

00102608 <vector193>:
.globl vector193
vector193:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $193
  10260a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10260f:	e9 56 f8 ff ff       	jmp    101e6a <__alltraps>

00102614 <vector194>:
.globl vector194
vector194:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $194
  102616:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10261b:	e9 4a f8 ff ff       	jmp    101e6a <__alltraps>

00102620 <vector195>:
.globl vector195
vector195:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $195
  102622:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102627:	e9 3e f8 ff ff       	jmp    101e6a <__alltraps>

0010262c <vector196>:
.globl vector196
vector196:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $196
  10262e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102633:	e9 32 f8 ff ff       	jmp    101e6a <__alltraps>

00102638 <vector197>:
.globl vector197
vector197:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $197
  10263a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10263f:	e9 26 f8 ff ff       	jmp    101e6a <__alltraps>

00102644 <vector198>:
.globl vector198
vector198:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $198
  102646:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10264b:	e9 1a f8 ff ff       	jmp    101e6a <__alltraps>

00102650 <vector199>:
.globl vector199
vector199:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $199
  102652:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102657:	e9 0e f8 ff ff       	jmp    101e6a <__alltraps>

0010265c <vector200>:
.globl vector200
vector200:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $200
  10265e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102663:	e9 02 f8 ff ff       	jmp    101e6a <__alltraps>

00102668 <vector201>:
.globl vector201
vector201:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $201
  10266a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10266f:	e9 f6 f7 ff ff       	jmp    101e6a <__alltraps>

00102674 <vector202>:
.globl vector202
vector202:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $202
  102676:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10267b:	e9 ea f7 ff ff       	jmp    101e6a <__alltraps>

00102680 <vector203>:
.globl vector203
vector203:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $203
  102682:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102687:	e9 de f7 ff ff       	jmp    101e6a <__alltraps>

0010268c <vector204>:
.globl vector204
vector204:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $204
  10268e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102693:	e9 d2 f7 ff ff       	jmp    101e6a <__alltraps>

00102698 <vector205>:
.globl vector205
vector205:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $205
  10269a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10269f:	e9 c6 f7 ff ff       	jmp    101e6a <__alltraps>

001026a4 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $206
  1026a6:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026ab:	e9 ba f7 ff ff       	jmp    101e6a <__alltraps>

001026b0 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $207
  1026b2:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026b7:	e9 ae f7 ff ff       	jmp    101e6a <__alltraps>

001026bc <vector208>:
.globl vector208
vector208:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $208
  1026be:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026c3:	e9 a2 f7 ff ff       	jmp    101e6a <__alltraps>

001026c8 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $209
  1026ca:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026cf:	e9 96 f7 ff ff       	jmp    101e6a <__alltraps>

001026d4 <vector210>:
.globl vector210
vector210:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $210
  1026d6:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026db:	e9 8a f7 ff ff       	jmp    101e6a <__alltraps>

001026e0 <vector211>:
.globl vector211
vector211:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $211
  1026e2:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026e7:	e9 7e f7 ff ff       	jmp    101e6a <__alltraps>

001026ec <vector212>:
.globl vector212
vector212:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $212
  1026ee:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026f3:	e9 72 f7 ff ff       	jmp    101e6a <__alltraps>

001026f8 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026f8:	6a 00                	push   $0x0
  pushl $213
  1026fa:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026ff:	e9 66 f7 ff ff       	jmp    101e6a <__alltraps>

00102704 <vector214>:
.globl vector214
vector214:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $214
  102706:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10270b:	e9 5a f7 ff ff       	jmp    101e6a <__alltraps>

00102710 <vector215>:
.globl vector215
vector215:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $215
  102712:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102717:	e9 4e f7 ff ff       	jmp    101e6a <__alltraps>

0010271c <vector216>:
.globl vector216
vector216:
  pushl $0
  10271c:	6a 00                	push   $0x0
  pushl $216
  10271e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102723:	e9 42 f7 ff ff       	jmp    101e6a <__alltraps>

00102728 <vector217>:
.globl vector217
vector217:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $217
  10272a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10272f:	e9 36 f7 ff ff       	jmp    101e6a <__alltraps>

00102734 <vector218>:
.globl vector218
vector218:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $218
  102736:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10273b:	e9 2a f7 ff ff       	jmp    101e6a <__alltraps>

00102740 <vector219>:
.globl vector219
vector219:
  pushl $0
  102740:	6a 00                	push   $0x0
  pushl $219
  102742:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102747:	e9 1e f7 ff ff       	jmp    101e6a <__alltraps>

0010274c <vector220>:
.globl vector220
vector220:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $220
  10274e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102753:	e9 12 f7 ff ff       	jmp    101e6a <__alltraps>

00102758 <vector221>:
.globl vector221
vector221:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $221
  10275a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10275f:	e9 06 f7 ff ff       	jmp    101e6a <__alltraps>

00102764 <vector222>:
.globl vector222
vector222:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $222
  102766:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10276b:	e9 fa f6 ff ff       	jmp    101e6a <__alltraps>

00102770 <vector223>:
.globl vector223
vector223:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $223
  102772:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102777:	e9 ee f6 ff ff       	jmp    101e6a <__alltraps>

0010277c <vector224>:
.globl vector224
vector224:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $224
  10277e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102783:	e9 e2 f6 ff ff       	jmp    101e6a <__alltraps>

00102788 <vector225>:
.globl vector225
vector225:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $225
  10278a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10278f:	e9 d6 f6 ff ff       	jmp    101e6a <__alltraps>

00102794 <vector226>:
.globl vector226
vector226:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $226
  102796:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10279b:	e9 ca f6 ff ff       	jmp    101e6a <__alltraps>

001027a0 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $227
  1027a2:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027a7:	e9 be f6 ff ff       	jmp    101e6a <__alltraps>

001027ac <vector228>:
.globl vector228
vector228:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $228
  1027ae:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027b3:	e9 b2 f6 ff ff       	jmp    101e6a <__alltraps>

001027b8 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $229
  1027ba:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027bf:	e9 a6 f6 ff ff       	jmp    101e6a <__alltraps>

001027c4 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $230
  1027c6:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027cb:	e9 9a f6 ff ff       	jmp    101e6a <__alltraps>

001027d0 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $231
  1027d2:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027d7:	e9 8e f6 ff ff       	jmp    101e6a <__alltraps>

001027dc <vector232>:
.globl vector232
vector232:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $232
  1027de:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027e3:	e9 82 f6 ff ff       	jmp    101e6a <__alltraps>

001027e8 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $233
  1027ea:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027ef:	e9 76 f6 ff ff       	jmp    101e6a <__alltraps>

001027f4 <vector234>:
.globl vector234
vector234:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $234
  1027f6:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027fb:	e9 6a f6 ff ff       	jmp    101e6a <__alltraps>

00102800 <vector235>:
.globl vector235
vector235:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $235
  102802:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102807:	e9 5e f6 ff ff       	jmp    101e6a <__alltraps>

0010280c <vector236>:
.globl vector236
vector236:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $236
  10280e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102813:	e9 52 f6 ff ff       	jmp    101e6a <__alltraps>

00102818 <vector237>:
.globl vector237
vector237:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $237
  10281a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10281f:	e9 46 f6 ff ff       	jmp    101e6a <__alltraps>

00102824 <vector238>:
.globl vector238
vector238:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $238
  102826:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10282b:	e9 3a f6 ff ff       	jmp    101e6a <__alltraps>

00102830 <vector239>:
.globl vector239
vector239:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $239
  102832:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102837:	e9 2e f6 ff ff       	jmp    101e6a <__alltraps>

0010283c <vector240>:
.globl vector240
vector240:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $240
  10283e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102843:	e9 22 f6 ff ff       	jmp    101e6a <__alltraps>

00102848 <vector241>:
.globl vector241
vector241:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $241
  10284a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10284f:	e9 16 f6 ff ff       	jmp    101e6a <__alltraps>

00102854 <vector242>:
.globl vector242
vector242:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $242
  102856:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10285b:	e9 0a f6 ff ff       	jmp    101e6a <__alltraps>

00102860 <vector243>:
.globl vector243
vector243:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $243
  102862:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102867:	e9 fe f5 ff ff       	jmp    101e6a <__alltraps>

0010286c <vector244>:
.globl vector244
vector244:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $244
  10286e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102873:	e9 f2 f5 ff ff       	jmp    101e6a <__alltraps>

00102878 <vector245>:
.globl vector245
vector245:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $245
  10287a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10287f:	e9 e6 f5 ff ff       	jmp    101e6a <__alltraps>

00102884 <vector246>:
.globl vector246
vector246:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $246
  102886:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10288b:	e9 da f5 ff ff       	jmp    101e6a <__alltraps>

00102890 <vector247>:
.globl vector247
vector247:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $247
  102892:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102897:	e9 ce f5 ff ff       	jmp    101e6a <__alltraps>

0010289c <vector248>:
.globl vector248
vector248:
  pushl $0
  10289c:	6a 00                	push   $0x0
  pushl $248
  10289e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028a3:	e9 c2 f5 ff ff       	jmp    101e6a <__alltraps>

001028a8 <vector249>:
.globl vector249
vector249:
  pushl $0
  1028a8:	6a 00                	push   $0x0
  pushl $249
  1028aa:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028af:	e9 b6 f5 ff ff       	jmp    101e6a <__alltraps>

001028b4 <vector250>:
.globl vector250
vector250:
  pushl $0
  1028b4:	6a 00                	push   $0x0
  pushl $250
  1028b6:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028bb:	e9 aa f5 ff ff       	jmp    101e6a <__alltraps>

001028c0 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028c0:	6a 00                	push   $0x0
  pushl $251
  1028c2:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028c7:	e9 9e f5 ff ff       	jmp    101e6a <__alltraps>

001028cc <vector252>:
.globl vector252
vector252:
  pushl $0
  1028cc:	6a 00                	push   $0x0
  pushl $252
  1028ce:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028d3:	e9 92 f5 ff ff       	jmp    101e6a <__alltraps>

001028d8 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028d8:	6a 00                	push   $0x0
  pushl $253
  1028da:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028df:	e9 86 f5 ff ff       	jmp    101e6a <__alltraps>

001028e4 <vector254>:
.globl vector254
vector254:
  pushl $0
  1028e4:	6a 00                	push   $0x0
  pushl $254
  1028e6:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028eb:	e9 7a f5 ff ff       	jmp    101e6a <__alltraps>

001028f0 <vector255>:
.globl vector255
vector255:
  pushl $0
  1028f0:	6a 00                	push   $0x0
  pushl $255
  1028f2:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028f7:	e9 6e f5 ff ff       	jmp    101e6a <__alltraps>

001028fc <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1028fc:	55                   	push   %ebp
  1028fd:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  102902:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102905:	b8 23 00 00 00       	mov    $0x23,%eax
  10290a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10290c:	b8 23 00 00 00       	mov    $0x23,%eax
  102911:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102913:	b8 10 00 00 00       	mov    $0x10,%eax
  102918:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10291a:	b8 10 00 00 00       	mov    $0x10,%eax
  10291f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102921:	b8 10 00 00 00       	mov    $0x10,%eax
  102926:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102928:	ea 2f 29 10 00 08 00 	ljmp   $0x8,$0x10292f
}
  10292f:	5d                   	pop    %ebp
  102930:	c3                   	ret    

00102931 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102931:	55                   	push   %ebp
  102932:	89 e5                	mov    %esp,%ebp
  102934:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102937:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  10293c:	05 00 04 00 00       	add    $0x400,%eax
  102941:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102946:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  10294d:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10294f:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102956:	68 00 
  102958:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10295d:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102963:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102968:	c1 e8 10             	shr    $0x10,%eax
  10296b:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102970:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102977:	83 e0 f0             	and    $0xfffffff0,%eax
  10297a:	83 c8 09             	or     $0x9,%eax
  10297d:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102982:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102989:	83 c8 10             	or     $0x10,%eax
  10298c:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102991:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102998:	83 e0 9f             	and    $0xffffff9f,%eax
  10299b:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029a0:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029a7:	83 c8 80             	or     $0xffffff80,%eax
  1029aa:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029af:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029b6:	83 e0 f0             	and    $0xfffffff0,%eax
  1029b9:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029be:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029c5:	83 e0 ef             	and    $0xffffffef,%eax
  1029c8:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029cd:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029d4:	83 e0 df             	and    $0xffffffdf,%eax
  1029d7:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029dc:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029e3:	83 c8 40             	or     $0x40,%eax
  1029e6:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029eb:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029f2:	83 e0 7f             	and    $0x7f,%eax
  1029f5:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029fa:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029ff:	c1 e8 18             	shr    $0x18,%eax
  102a02:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a07:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a0e:	83 e0 ef             	and    $0xffffffef,%eax
  102a11:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a16:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102a1d:	e8 da fe ff ff       	call   1028fc <lgdt>
  102a22:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a28:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a2c:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a2f:	c9                   	leave  
  102a30:	c3                   	ret    

00102a31 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a31:	55                   	push   %ebp
  102a32:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a34:	e8 f8 fe ff ff       	call   102931 <gdt_init>
}
  102a39:	5d                   	pop    %ebp
  102a3a:	c3                   	ret    

00102a3b <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102a3b:	55                   	push   %ebp
  102a3c:	89 e5                	mov    %esp,%ebp
  102a3e:	83 ec 58             	sub    $0x58,%esp
  102a41:	8b 45 10             	mov    0x10(%ebp),%eax
  102a44:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a47:	8b 45 14             	mov    0x14(%ebp),%eax
  102a4a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102a4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a50:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a53:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102a56:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102a59:	8b 45 18             	mov    0x18(%ebp),%eax
  102a5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a62:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102a65:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102a68:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102a75:	74 1c                	je     102a93 <printnum+0x58>
  102a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a7a:	ba 00 00 00 00       	mov    $0x0,%edx
  102a7f:	f7 75 e4             	divl   -0x1c(%ebp)
  102a82:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a88:	ba 00 00 00 00       	mov    $0x0,%edx
  102a8d:	f7 75 e4             	divl   -0x1c(%ebp)
  102a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102a99:	f7 75 e4             	divl   -0x1c(%ebp)
  102a9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102a9f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102aa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102aa5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102aa8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102aab:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102aae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ab1:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102ab4:	8b 45 18             	mov    0x18(%ebp),%eax
  102ab7:	ba 00 00 00 00       	mov    $0x0,%edx
  102abc:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102abf:	77 56                	ja     102b17 <printnum+0xdc>
  102ac1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102ac4:	72 05                	jb     102acb <printnum+0x90>
  102ac6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102ac9:	77 4c                	ja     102b17 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102acb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102ace:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ad1:	8b 45 20             	mov    0x20(%ebp),%eax
  102ad4:	89 44 24 18          	mov    %eax,0x18(%esp)
  102ad8:	89 54 24 14          	mov    %edx,0x14(%esp)
  102adc:	8b 45 18             	mov    0x18(%ebp),%eax
  102adf:	89 44 24 10          	mov    %eax,0x10(%esp)
  102ae3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ae6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ae9:	89 44 24 08          	mov    %eax,0x8(%esp)
  102aed:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102af8:	8b 45 08             	mov    0x8(%ebp),%eax
  102afb:	89 04 24             	mov    %eax,(%esp)
  102afe:	e8 38 ff ff ff       	call   102a3b <printnum>
  102b03:	eb 1c                	jmp    102b21 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b0c:	8b 45 20             	mov    0x20(%ebp),%eax
  102b0f:	89 04 24             	mov    %eax,(%esp)
  102b12:	8b 45 08             	mov    0x8(%ebp),%eax
  102b15:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102b17:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102b1b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102b1f:	7f e4                	jg     102b05 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102b21:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b24:	05 10 3d 10 00       	add    $0x103d10,%eax
  102b29:	0f b6 00             	movzbl (%eax),%eax
  102b2c:	0f be c0             	movsbl %al,%eax
  102b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b32:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b36:	89 04 24             	mov    %eax,(%esp)
  102b39:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3c:	ff d0                	call   *%eax
}
  102b3e:	c9                   	leave  
  102b3f:	c3                   	ret    

00102b40 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102b40:	55                   	push   %ebp
  102b41:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102b43:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102b47:	7e 14                	jle    102b5d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102b49:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4c:	8b 00                	mov    (%eax),%eax
  102b4e:	8d 48 08             	lea    0x8(%eax),%ecx
  102b51:	8b 55 08             	mov    0x8(%ebp),%edx
  102b54:	89 0a                	mov    %ecx,(%edx)
  102b56:	8b 50 04             	mov    0x4(%eax),%edx
  102b59:	8b 00                	mov    (%eax),%eax
  102b5b:	eb 30                	jmp    102b8d <getuint+0x4d>
    }
    else if (lflag) {
  102b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b61:	74 16                	je     102b79 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102b63:	8b 45 08             	mov    0x8(%ebp),%eax
  102b66:	8b 00                	mov    (%eax),%eax
  102b68:	8d 48 04             	lea    0x4(%eax),%ecx
  102b6b:	8b 55 08             	mov    0x8(%ebp),%edx
  102b6e:	89 0a                	mov    %ecx,(%edx)
  102b70:	8b 00                	mov    (%eax),%eax
  102b72:	ba 00 00 00 00       	mov    $0x0,%edx
  102b77:	eb 14                	jmp    102b8d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102b79:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7c:	8b 00                	mov    (%eax),%eax
  102b7e:	8d 48 04             	lea    0x4(%eax),%ecx
  102b81:	8b 55 08             	mov    0x8(%ebp),%edx
  102b84:	89 0a                	mov    %ecx,(%edx)
  102b86:	8b 00                	mov    (%eax),%eax
  102b88:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102b8d:	5d                   	pop    %ebp
  102b8e:	c3                   	ret    

00102b8f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102b8f:	55                   	push   %ebp
  102b90:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102b92:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102b96:	7e 14                	jle    102bac <getint+0x1d>
        return va_arg(*ap, long long);
  102b98:	8b 45 08             	mov    0x8(%ebp),%eax
  102b9b:	8b 00                	mov    (%eax),%eax
  102b9d:	8d 48 08             	lea    0x8(%eax),%ecx
  102ba0:	8b 55 08             	mov    0x8(%ebp),%edx
  102ba3:	89 0a                	mov    %ecx,(%edx)
  102ba5:	8b 50 04             	mov    0x4(%eax),%edx
  102ba8:	8b 00                	mov    (%eax),%eax
  102baa:	eb 28                	jmp    102bd4 <getint+0x45>
    }
    else if (lflag) {
  102bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bb0:	74 12                	je     102bc4 <getint+0x35>
        return va_arg(*ap, long);
  102bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb5:	8b 00                	mov    (%eax),%eax
  102bb7:	8d 48 04             	lea    0x4(%eax),%ecx
  102bba:	8b 55 08             	mov    0x8(%ebp),%edx
  102bbd:	89 0a                	mov    %ecx,(%edx)
  102bbf:	8b 00                	mov    (%eax),%eax
  102bc1:	99                   	cltd   
  102bc2:	eb 10                	jmp    102bd4 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc7:	8b 00                	mov    (%eax),%eax
  102bc9:	8d 48 04             	lea    0x4(%eax),%ecx
  102bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  102bcf:	89 0a                	mov    %ecx,(%edx)
  102bd1:	8b 00                	mov    (%eax),%eax
  102bd3:	99                   	cltd   
    }
}
  102bd4:	5d                   	pop    %ebp
  102bd5:	c3                   	ret    

00102bd6 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102bd6:	55                   	push   %ebp
  102bd7:	89 e5                	mov    %esp,%ebp
  102bd9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  102bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102be5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102be9:	8b 45 10             	mov    0x10(%ebp),%eax
  102bec:	89 44 24 08          	mov    %eax,0x8(%esp)
  102bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfa:	89 04 24             	mov    %eax,(%esp)
  102bfd:	e8 02 00 00 00       	call   102c04 <vprintfmt>
    va_end(ap);
}
  102c02:	c9                   	leave  
  102c03:	c3                   	ret    

00102c04 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102c04:	55                   	push   %ebp
  102c05:	89 e5                	mov    %esp,%ebp
  102c07:	56                   	push   %esi
  102c08:	53                   	push   %ebx
  102c09:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c0c:	eb 18                	jmp    102c26 <vprintfmt+0x22>
            if (ch == '\0') {
  102c0e:	85 db                	test   %ebx,%ebx
  102c10:	75 05                	jne    102c17 <vprintfmt+0x13>
                return;
  102c12:	e9 d1 03 00 00       	jmp    102fe8 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c1e:	89 1c 24             	mov    %ebx,(%esp)
  102c21:	8b 45 08             	mov    0x8(%ebp),%eax
  102c24:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c26:	8b 45 10             	mov    0x10(%ebp),%eax
  102c29:	8d 50 01             	lea    0x1(%eax),%edx
  102c2c:	89 55 10             	mov    %edx,0x10(%ebp)
  102c2f:	0f b6 00             	movzbl (%eax),%eax
  102c32:	0f b6 d8             	movzbl %al,%ebx
  102c35:	83 fb 25             	cmp    $0x25,%ebx
  102c38:	75 d4                	jne    102c0e <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102c3a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102c3e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102c45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c48:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102c4b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102c52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c55:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102c58:	8b 45 10             	mov    0x10(%ebp),%eax
  102c5b:	8d 50 01             	lea    0x1(%eax),%edx
  102c5e:	89 55 10             	mov    %edx,0x10(%ebp)
  102c61:	0f b6 00             	movzbl (%eax),%eax
  102c64:	0f b6 d8             	movzbl %al,%ebx
  102c67:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102c6a:	83 f8 55             	cmp    $0x55,%eax
  102c6d:	0f 87 44 03 00 00    	ja     102fb7 <vprintfmt+0x3b3>
  102c73:	8b 04 85 34 3d 10 00 	mov    0x103d34(,%eax,4),%eax
  102c7a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102c7c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102c80:	eb d6                	jmp    102c58 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102c82:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102c86:	eb d0                	jmp    102c58 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102c88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102c8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102c92:	89 d0                	mov    %edx,%eax
  102c94:	c1 e0 02             	shl    $0x2,%eax
  102c97:	01 d0                	add    %edx,%eax
  102c99:	01 c0                	add    %eax,%eax
  102c9b:	01 d8                	add    %ebx,%eax
  102c9d:	83 e8 30             	sub    $0x30,%eax
  102ca0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  102ca6:	0f b6 00             	movzbl (%eax),%eax
  102ca9:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102cac:	83 fb 2f             	cmp    $0x2f,%ebx
  102caf:	7e 0b                	jle    102cbc <vprintfmt+0xb8>
  102cb1:	83 fb 39             	cmp    $0x39,%ebx
  102cb4:	7f 06                	jg     102cbc <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102cb6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102cba:	eb d3                	jmp    102c8f <vprintfmt+0x8b>
            goto process_precision;
  102cbc:	eb 33                	jmp    102cf1 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102cbe:	8b 45 14             	mov    0x14(%ebp),%eax
  102cc1:	8d 50 04             	lea    0x4(%eax),%edx
  102cc4:	89 55 14             	mov    %edx,0x14(%ebp)
  102cc7:	8b 00                	mov    (%eax),%eax
  102cc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102ccc:	eb 23                	jmp    102cf1 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102cce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cd2:	79 0c                	jns    102ce0 <vprintfmt+0xdc>
                width = 0;
  102cd4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102cdb:	e9 78 ff ff ff       	jmp    102c58 <vprintfmt+0x54>
  102ce0:	e9 73 ff ff ff       	jmp    102c58 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102ce5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102cec:	e9 67 ff ff ff       	jmp    102c58 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102cf1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cf5:	79 12                	jns    102d09 <vprintfmt+0x105>
                width = precision, precision = -1;
  102cf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cfa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102cfd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102d04:	e9 4f ff ff ff       	jmp    102c58 <vprintfmt+0x54>
  102d09:	e9 4a ff ff ff       	jmp    102c58 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102d0e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102d12:	e9 41 ff ff ff       	jmp    102c58 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102d17:	8b 45 14             	mov    0x14(%ebp),%eax
  102d1a:	8d 50 04             	lea    0x4(%eax),%edx
  102d1d:	89 55 14             	mov    %edx,0x14(%ebp)
  102d20:	8b 00                	mov    (%eax),%eax
  102d22:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d25:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d29:	89 04 24             	mov    %eax,(%esp)
  102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2f:	ff d0                	call   *%eax
            break;
  102d31:	e9 ac 02 00 00       	jmp    102fe2 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102d36:	8b 45 14             	mov    0x14(%ebp),%eax
  102d39:	8d 50 04             	lea    0x4(%eax),%edx
  102d3c:	89 55 14             	mov    %edx,0x14(%ebp)
  102d3f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102d41:	85 db                	test   %ebx,%ebx
  102d43:	79 02                	jns    102d47 <vprintfmt+0x143>
                err = -err;
  102d45:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102d47:	83 fb 06             	cmp    $0x6,%ebx
  102d4a:	7f 0b                	jg     102d57 <vprintfmt+0x153>
  102d4c:	8b 34 9d f4 3c 10 00 	mov    0x103cf4(,%ebx,4),%esi
  102d53:	85 f6                	test   %esi,%esi
  102d55:	75 23                	jne    102d7a <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102d57:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102d5b:	c7 44 24 08 21 3d 10 	movl   $0x103d21,0x8(%esp)
  102d62:	00 
  102d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6d:	89 04 24             	mov    %eax,(%esp)
  102d70:	e8 61 fe ff ff       	call   102bd6 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102d75:	e9 68 02 00 00       	jmp    102fe2 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102d7a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102d7e:	c7 44 24 08 2a 3d 10 	movl   $0x103d2a,0x8(%esp)
  102d85:	00 
  102d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d89:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d90:	89 04 24             	mov    %eax,(%esp)
  102d93:	e8 3e fe ff ff       	call   102bd6 <printfmt>
            }
            break;
  102d98:	e9 45 02 00 00       	jmp    102fe2 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102d9d:	8b 45 14             	mov    0x14(%ebp),%eax
  102da0:	8d 50 04             	lea    0x4(%eax),%edx
  102da3:	89 55 14             	mov    %edx,0x14(%ebp)
  102da6:	8b 30                	mov    (%eax),%esi
  102da8:	85 f6                	test   %esi,%esi
  102daa:	75 05                	jne    102db1 <vprintfmt+0x1ad>
                p = "(null)";
  102dac:	be 2d 3d 10 00       	mov    $0x103d2d,%esi
            }
            if (width > 0 && padc != '-') {
  102db1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102db5:	7e 3e                	jle    102df5 <vprintfmt+0x1f1>
  102db7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102dbb:	74 38                	je     102df5 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102dbd:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102dc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dc7:	89 34 24             	mov    %esi,(%esp)
  102dca:	e8 15 03 00 00       	call   1030e4 <strnlen>
  102dcf:	29 c3                	sub    %eax,%ebx
  102dd1:	89 d8                	mov    %ebx,%eax
  102dd3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102dd6:	eb 17                	jmp    102def <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102dd8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102ddc:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ddf:	89 54 24 04          	mov    %edx,0x4(%esp)
  102de3:	89 04 24             	mov    %eax,(%esp)
  102de6:	8b 45 08             	mov    0x8(%ebp),%eax
  102de9:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102deb:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102def:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102df3:	7f e3                	jg     102dd8 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102df5:	eb 38                	jmp    102e2f <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102df7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102dfb:	74 1f                	je     102e1c <vprintfmt+0x218>
  102dfd:	83 fb 1f             	cmp    $0x1f,%ebx
  102e00:	7e 05                	jle    102e07 <vprintfmt+0x203>
  102e02:	83 fb 7e             	cmp    $0x7e,%ebx
  102e05:	7e 15                	jle    102e1c <vprintfmt+0x218>
                    putch('?', putdat);
  102e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e0e:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102e15:	8b 45 08             	mov    0x8(%ebp),%eax
  102e18:	ff d0                	call   *%eax
  102e1a:	eb 0f                	jmp    102e2b <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e23:	89 1c 24             	mov    %ebx,(%esp)
  102e26:	8b 45 08             	mov    0x8(%ebp),%eax
  102e29:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e2b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e2f:	89 f0                	mov    %esi,%eax
  102e31:	8d 70 01             	lea    0x1(%eax),%esi
  102e34:	0f b6 00             	movzbl (%eax),%eax
  102e37:	0f be d8             	movsbl %al,%ebx
  102e3a:	85 db                	test   %ebx,%ebx
  102e3c:	74 10                	je     102e4e <vprintfmt+0x24a>
  102e3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e42:	78 b3                	js     102df7 <vprintfmt+0x1f3>
  102e44:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102e48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e4c:	79 a9                	jns    102df7 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102e4e:	eb 17                	jmp    102e67 <vprintfmt+0x263>
                putch(' ', putdat);
  102e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e53:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e57:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e61:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102e63:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e67:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e6b:	7f e3                	jg     102e50 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102e6d:	e9 70 01 00 00       	jmp    102fe2 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102e72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e75:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e79:	8d 45 14             	lea    0x14(%ebp),%eax
  102e7c:	89 04 24             	mov    %eax,(%esp)
  102e7f:	e8 0b fd ff ff       	call   102b8f <getint>
  102e84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e87:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e90:	85 d2                	test   %edx,%edx
  102e92:	79 26                	jns    102eba <vprintfmt+0x2b6>
                putch('-', putdat);
  102e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e97:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e9b:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea5:	ff d0                	call   *%eax
                num = -(long long)num;
  102ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ead:	f7 d8                	neg    %eax
  102eaf:	83 d2 00             	adc    $0x0,%edx
  102eb2:	f7 da                	neg    %edx
  102eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102eba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102ec1:	e9 a8 00 00 00       	jmp    102f6e <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ec9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ecd:	8d 45 14             	lea    0x14(%ebp),%eax
  102ed0:	89 04 24             	mov    %eax,(%esp)
  102ed3:	e8 68 fc ff ff       	call   102b40 <getuint>
  102ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102edb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102ede:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102ee5:	e9 84 00 00 00       	jmp    102f6e <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102eea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102eed:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ef1:	8d 45 14             	lea    0x14(%ebp),%eax
  102ef4:	89 04 24             	mov    %eax,(%esp)
  102ef7:	e8 44 fc ff ff       	call   102b40 <getuint>
  102efc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102f02:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102f09:	eb 63                	jmp    102f6e <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f12:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102f19:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1c:	ff d0                	call   *%eax
            putch('x', putdat);
  102f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f21:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f25:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2f:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102f31:	8b 45 14             	mov    0x14(%ebp),%eax
  102f34:	8d 50 04             	lea    0x4(%eax),%edx
  102f37:	89 55 14             	mov    %edx,0x14(%ebp)
  102f3a:	8b 00                	mov    (%eax),%eax
  102f3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102f46:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102f4d:	eb 1f                	jmp    102f6e <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102f4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f52:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f56:	8d 45 14             	lea    0x14(%ebp),%eax
  102f59:	89 04 24             	mov    %eax,(%esp)
  102f5c:	e8 df fb ff ff       	call   102b40 <getuint>
  102f61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f64:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102f67:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102f6e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f75:	89 54 24 18          	mov    %edx,0x18(%esp)
  102f79:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102f7c:	89 54 24 14          	mov    %edx,0x14(%esp)
  102f80:	89 44 24 10          	mov    %eax,0x10(%esp)
  102f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f8e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f95:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f99:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9c:	89 04 24             	mov    %eax,(%esp)
  102f9f:	e8 97 fa ff ff       	call   102a3b <printnum>
            break;
  102fa4:	eb 3c                	jmp    102fe2 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fad:	89 1c 24             	mov    %ebx,(%esp)
  102fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb3:	ff d0                	call   *%eax
            break;
  102fb5:	eb 2b                	jmp    102fe2 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fba:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fbe:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc8:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102fca:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102fce:	eb 04                	jmp    102fd4 <vprintfmt+0x3d0>
  102fd0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  102fd7:	83 e8 01             	sub    $0x1,%eax
  102fda:	0f b6 00             	movzbl (%eax),%eax
  102fdd:	3c 25                	cmp    $0x25,%al
  102fdf:	75 ef                	jne    102fd0 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102fe1:	90                   	nop
        }
    }
  102fe2:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102fe3:	e9 3e fc ff ff       	jmp    102c26 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102fe8:	83 c4 40             	add    $0x40,%esp
  102feb:	5b                   	pop    %ebx
  102fec:	5e                   	pop    %esi
  102fed:	5d                   	pop    %ebp
  102fee:	c3                   	ret    

00102fef <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102fef:	55                   	push   %ebp
  102ff0:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff5:	8b 40 08             	mov    0x8(%eax),%eax
  102ff8:	8d 50 01             	lea    0x1(%eax),%edx
  102ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ffe:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103001:	8b 45 0c             	mov    0xc(%ebp),%eax
  103004:	8b 10                	mov    (%eax),%edx
  103006:	8b 45 0c             	mov    0xc(%ebp),%eax
  103009:	8b 40 04             	mov    0x4(%eax),%eax
  10300c:	39 c2                	cmp    %eax,%edx
  10300e:	73 12                	jae    103022 <sprintputch+0x33>
        *b->buf ++ = ch;
  103010:	8b 45 0c             	mov    0xc(%ebp),%eax
  103013:	8b 00                	mov    (%eax),%eax
  103015:	8d 48 01             	lea    0x1(%eax),%ecx
  103018:	8b 55 0c             	mov    0xc(%ebp),%edx
  10301b:	89 0a                	mov    %ecx,(%edx)
  10301d:	8b 55 08             	mov    0x8(%ebp),%edx
  103020:	88 10                	mov    %dl,(%eax)
    }
}
  103022:	5d                   	pop    %ebp
  103023:	c3                   	ret    

00103024 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103024:	55                   	push   %ebp
  103025:	89 e5                	mov    %esp,%ebp
  103027:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10302a:	8d 45 14             	lea    0x14(%ebp),%eax
  10302d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103033:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103037:	8b 45 10             	mov    0x10(%ebp),%eax
  10303a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10303e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103041:	89 44 24 04          	mov    %eax,0x4(%esp)
  103045:	8b 45 08             	mov    0x8(%ebp),%eax
  103048:	89 04 24             	mov    %eax,(%esp)
  10304b:	e8 08 00 00 00       	call   103058 <vsnprintf>
  103050:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103053:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103056:	c9                   	leave  
  103057:	c3                   	ret    

00103058 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103058:	55                   	push   %ebp
  103059:	89 e5                	mov    %esp,%ebp
  10305b:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10305e:	8b 45 08             	mov    0x8(%ebp),%eax
  103061:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103064:	8b 45 0c             	mov    0xc(%ebp),%eax
  103067:	8d 50 ff             	lea    -0x1(%eax),%edx
  10306a:	8b 45 08             	mov    0x8(%ebp),%eax
  10306d:	01 d0                	add    %edx,%eax
  10306f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103072:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103079:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10307d:	74 0a                	je     103089 <vsnprintf+0x31>
  10307f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103085:	39 c2                	cmp    %eax,%edx
  103087:	76 07                	jbe    103090 <vsnprintf+0x38>
        return -E_INVAL;
  103089:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10308e:	eb 2a                	jmp    1030ba <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103090:	8b 45 14             	mov    0x14(%ebp),%eax
  103093:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103097:	8b 45 10             	mov    0x10(%ebp),%eax
  10309a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10309e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1030a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030a5:	c7 04 24 ef 2f 10 00 	movl   $0x102fef,(%esp)
  1030ac:	e8 53 fb ff ff       	call   102c04 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1030b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030b4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030ba:	c9                   	leave  
  1030bb:	c3                   	ret    

001030bc <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1030bc:	55                   	push   %ebp
  1030bd:	89 e5                	mov    %esp,%ebp
  1030bf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1030c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1030c9:	eb 04                	jmp    1030cf <strlen+0x13>
        cnt ++;
  1030cb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d2:	8d 50 01             	lea    0x1(%eax),%edx
  1030d5:	89 55 08             	mov    %edx,0x8(%ebp)
  1030d8:	0f b6 00             	movzbl (%eax),%eax
  1030db:	84 c0                	test   %al,%al
  1030dd:	75 ec                	jne    1030cb <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1030df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1030e2:	c9                   	leave  
  1030e3:	c3                   	ret    

001030e4 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1030e4:	55                   	push   %ebp
  1030e5:	89 e5                	mov    %esp,%ebp
  1030e7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1030ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1030f1:	eb 04                	jmp    1030f7 <strnlen+0x13>
        cnt ++;
  1030f3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  1030f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1030fd:	73 10                	jae    10310f <strnlen+0x2b>
  1030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103102:	8d 50 01             	lea    0x1(%eax),%edx
  103105:	89 55 08             	mov    %edx,0x8(%ebp)
  103108:	0f b6 00             	movzbl (%eax),%eax
  10310b:	84 c0                	test   %al,%al
  10310d:	75 e4                	jne    1030f3 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10310f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103112:	c9                   	leave  
  103113:	c3                   	ret    

00103114 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103114:	55                   	push   %ebp
  103115:	89 e5                	mov    %esp,%ebp
  103117:	57                   	push   %edi
  103118:	56                   	push   %esi
  103119:	83 ec 20             	sub    $0x20,%esp
  10311c:	8b 45 08             	mov    0x8(%ebp),%eax
  10311f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103122:	8b 45 0c             	mov    0xc(%ebp),%eax
  103125:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103128:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10312e:	89 d1                	mov    %edx,%ecx
  103130:	89 c2                	mov    %eax,%edx
  103132:	89 ce                	mov    %ecx,%esi
  103134:	89 d7                	mov    %edx,%edi
  103136:	ac                   	lods   %ds:(%esi),%al
  103137:	aa                   	stos   %al,%es:(%edi)
  103138:	84 c0                	test   %al,%al
  10313a:	75 fa                	jne    103136 <strcpy+0x22>
  10313c:	89 fa                	mov    %edi,%edx
  10313e:	89 f1                	mov    %esi,%ecx
  103140:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103143:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103146:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103149:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10314c:	83 c4 20             	add    $0x20,%esp
  10314f:	5e                   	pop    %esi
  103150:	5f                   	pop    %edi
  103151:	5d                   	pop    %ebp
  103152:	c3                   	ret    

00103153 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103153:	55                   	push   %ebp
  103154:	89 e5                	mov    %esp,%ebp
  103156:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103159:	8b 45 08             	mov    0x8(%ebp),%eax
  10315c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10315f:	eb 21                	jmp    103182 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  103161:	8b 45 0c             	mov    0xc(%ebp),%eax
  103164:	0f b6 10             	movzbl (%eax),%edx
  103167:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10316a:	88 10                	mov    %dl,(%eax)
  10316c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10316f:	0f b6 00             	movzbl (%eax),%eax
  103172:	84 c0                	test   %al,%al
  103174:	74 04                	je     10317a <strncpy+0x27>
            src ++;
  103176:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  10317a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10317e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  103182:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103186:	75 d9                	jne    103161 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103188:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10318b:	c9                   	leave  
  10318c:	c3                   	ret    

0010318d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10318d:	55                   	push   %ebp
  10318e:	89 e5                	mov    %esp,%ebp
  103190:	57                   	push   %edi
  103191:	56                   	push   %esi
  103192:	83 ec 20             	sub    $0x20,%esp
  103195:	8b 45 08             	mov    0x8(%ebp),%eax
  103198:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10319b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10319e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1031a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031a7:	89 d1                	mov    %edx,%ecx
  1031a9:	89 c2                	mov    %eax,%edx
  1031ab:	89 ce                	mov    %ecx,%esi
  1031ad:	89 d7                	mov    %edx,%edi
  1031af:	ac                   	lods   %ds:(%esi),%al
  1031b0:	ae                   	scas   %es:(%edi),%al
  1031b1:	75 08                	jne    1031bb <strcmp+0x2e>
  1031b3:	84 c0                	test   %al,%al
  1031b5:	75 f8                	jne    1031af <strcmp+0x22>
  1031b7:	31 c0                	xor    %eax,%eax
  1031b9:	eb 04                	jmp    1031bf <strcmp+0x32>
  1031bb:	19 c0                	sbb    %eax,%eax
  1031bd:	0c 01                	or     $0x1,%al
  1031bf:	89 fa                	mov    %edi,%edx
  1031c1:	89 f1                	mov    %esi,%ecx
  1031c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031c6:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1031c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1031cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1031cf:	83 c4 20             	add    $0x20,%esp
  1031d2:	5e                   	pop    %esi
  1031d3:	5f                   	pop    %edi
  1031d4:	5d                   	pop    %ebp
  1031d5:	c3                   	ret    

001031d6 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1031d6:	55                   	push   %ebp
  1031d7:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1031d9:	eb 0c                	jmp    1031e7 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1031db:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1031df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031e3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1031e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031eb:	74 1a                	je     103207 <strncmp+0x31>
  1031ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f0:	0f b6 00             	movzbl (%eax),%eax
  1031f3:	84 c0                	test   %al,%al
  1031f5:	74 10                	je     103207 <strncmp+0x31>
  1031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fa:	0f b6 10             	movzbl (%eax),%edx
  1031fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  103200:	0f b6 00             	movzbl (%eax),%eax
  103203:	38 c2                	cmp    %al,%dl
  103205:	74 d4                	je     1031db <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103207:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10320b:	74 18                	je     103225 <strncmp+0x4f>
  10320d:	8b 45 08             	mov    0x8(%ebp),%eax
  103210:	0f b6 00             	movzbl (%eax),%eax
  103213:	0f b6 d0             	movzbl %al,%edx
  103216:	8b 45 0c             	mov    0xc(%ebp),%eax
  103219:	0f b6 00             	movzbl (%eax),%eax
  10321c:	0f b6 c0             	movzbl %al,%eax
  10321f:	29 c2                	sub    %eax,%edx
  103221:	89 d0                	mov    %edx,%eax
  103223:	eb 05                	jmp    10322a <strncmp+0x54>
  103225:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10322a:	5d                   	pop    %ebp
  10322b:	c3                   	ret    

0010322c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10322c:	55                   	push   %ebp
  10322d:	89 e5                	mov    %esp,%ebp
  10322f:	83 ec 04             	sub    $0x4,%esp
  103232:	8b 45 0c             	mov    0xc(%ebp),%eax
  103235:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103238:	eb 14                	jmp    10324e <strchr+0x22>
        if (*s == c) {
  10323a:	8b 45 08             	mov    0x8(%ebp),%eax
  10323d:	0f b6 00             	movzbl (%eax),%eax
  103240:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103243:	75 05                	jne    10324a <strchr+0x1e>
            return (char *)s;
  103245:	8b 45 08             	mov    0x8(%ebp),%eax
  103248:	eb 13                	jmp    10325d <strchr+0x31>
        }
        s ++;
  10324a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  10324e:	8b 45 08             	mov    0x8(%ebp),%eax
  103251:	0f b6 00             	movzbl (%eax),%eax
  103254:	84 c0                	test   %al,%al
  103256:	75 e2                	jne    10323a <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103258:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10325d:	c9                   	leave  
  10325e:	c3                   	ret    

0010325f <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10325f:	55                   	push   %ebp
  103260:	89 e5                	mov    %esp,%ebp
  103262:	83 ec 04             	sub    $0x4,%esp
  103265:	8b 45 0c             	mov    0xc(%ebp),%eax
  103268:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10326b:	eb 11                	jmp    10327e <strfind+0x1f>
        if (*s == c) {
  10326d:	8b 45 08             	mov    0x8(%ebp),%eax
  103270:	0f b6 00             	movzbl (%eax),%eax
  103273:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103276:	75 02                	jne    10327a <strfind+0x1b>
            break;
  103278:	eb 0e                	jmp    103288 <strfind+0x29>
        }
        s ++;
  10327a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  10327e:	8b 45 08             	mov    0x8(%ebp),%eax
  103281:	0f b6 00             	movzbl (%eax),%eax
  103284:	84 c0                	test   %al,%al
  103286:	75 e5                	jne    10326d <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103288:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10328b:	c9                   	leave  
  10328c:	c3                   	ret    

0010328d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10328d:	55                   	push   %ebp
  10328e:	89 e5                	mov    %esp,%ebp
  103290:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  103293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10329a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032a1:	eb 04                	jmp    1032a7 <strtol+0x1a>
        s ++;
  1032a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1032aa:	0f b6 00             	movzbl (%eax),%eax
  1032ad:	3c 20                	cmp    $0x20,%al
  1032af:	74 f2                	je     1032a3 <strtol+0x16>
  1032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b4:	0f b6 00             	movzbl (%eax),%eax
  1032b7:	3c 09                	cmp    $0x9,%al
  1032b9:	74 e8                	je     1032a3 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1032be:	0f b6 00             	movzbl (%eax),%eax
  1032c1:	3c 2b                	cmp    $0x2b,%al
  1032c3:	75 06                	jne    1032cb <strtol+0x3e>
        s ++;
  1032c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032c9:	eb 15                	jmp    1032e0 <strtol+0x53>
    }
    else if (*s == '-') {
  1032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ce:	0f b6 00             	movzbl (%eax),%eax
  1032d1:	3c 2d                	cmp    $0x2d,%al
  1032d3:	75 0b                	jne    1032e0 <strtol+0x53>
        s ++, neg = 1;
  1032d5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1032e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032e4:	74 06                	je     1032ec <strtol+0x5f>
  1032e6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1032ea:	75 24                	jne    103310 <strtol+0x83>
  1032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ef:	0f b6 00             	movzbl (%eax),%eax
  1032f2:	3c 30                	cmp    $0x30,%al
  1032f4:	75 1a                	jne    103310 <strtol+0x83>
  1032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032f9:	83 c0 01             	add    $0x1,%eax
  1032fc:	0f b6 00             	movzbl (%eax),%eax
  1032ff:	3c 78                	cmp    $0x78,%al
  103301:	75 0d                	jne    103310 <strtol+0x83>
        s += 2, base = 16;
  103303:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103307:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10330e:	eb 2a                	jmp    10333a <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103310:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103314:	75 17                	jne    10332d <strtol+0xa0>
  103316:	8b 45 08             	mov    0x8(%ebp),%eax
  103319:	0f b6 00             	movzbl (%eax),%eax
  10331c:	3c 30                	cmp    $0x30,%al
  10331e:	75 0d                	jne    10332d <strtol+0xa0>
        s ++, base = 8;
  103320:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103324:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10332b:	eb 0d                	jmp    10333a <strtol+0xad>
    }
    else if (base == 0) {
  10332d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103331:	75 07                	jne    10333a <strtol+0xad>
        base = 10;
  103333:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10333a:	8b 45 08             	mov    0x8(%ebp),%eax
  10333d:	0f b6 00             	movzbl (%eax),%eax
  103340:	3c 2f                	cmp    $0x2f,%al
  103342:	7e 1b                	jle    10335f <strtol+0xd2>
  103344:	8b 45 08             	mov    0x8(%ebp),%eax
  103347:	0f b6 00             	movzbl (%eax),%eax
  10334a:	3c 39                	cmp    $0x39,%al
  10334c:	7f 11                	jg     10335f <strtol+0xd2>
            dig = *s - '0';
  10334e:	8b 45 08             	mov    0x8(%ebp),%eax
  103351:	0f b6 00             	movzbl (%eax),%eax
  103354:	0f be c0             	movsbl %al,%eax
  103357:	83 e8 30             	sub    $0x30,%eax
  10335a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10335d:	eb 48                	jmp    1033a7 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10335f:	8b 45 08             	mov    0x8(%ebp),%eax
  103362:	0f b6 00             	movzbl (%eax),%eax
  103365:	3c 60                	cmp    $0x60,%al
  103367:	7e 1b                	jle    103384 <strtol+0xf7>
  103369:	8b 45 08             	mov    0x8(%ebp),%eax
  10336c:	0f b6 00             	movzbl (%eax),%eax
  10336f:	3c 7a                	cmp    $0x7a,%al
  103371:	7f 11                	jg     103384 <strtol+0xf7>
            dig = *s - 'a' + 10;
  103373:	8b 45 08             	mov    0x8(%ebp),%eax
  103376:	0f b6 00             	movzbl (%eax),%eax
  103379:	0f be c0             	movsbl %al,%eax
  10337c:	83 e8 57             	sub    $0x57,%eax
  10337f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103382:	eb 23                	jmp    1033a7 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103384:	8b 45 08             	mov    0x8(%ebp),%eax
  103387:	0f b6 00             	movzbl (%eax),%eax
  10338a:	3c 40                	cmp    $0x40,%al
  10338c:	7e 3d                	jle    1033cb <strtol+0x13e>
  10338e:	8b 45 08             	mov    0x8(%ebp),%eax
  103391:	0f b6 00             	movzbl (%eax),%eax
  103394:	3c 5a                	cmp    $0x5a,%al
  103396:	7f 33                	jg     1033cb <strtol+0x13e>
            dig = *s - 'A' + 10;
  103398:	8b 45 08             	mov    0x8(%ebp),%eax
  10339b:	0f b6 00             	movzbl (%eax),%eax
  10339e:	0f be c0             	movsbl %al,%eax
  1033a1:	83 e8 37             	sub    $0x37,%eax
  1033a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033aa:	3b 45 10             	cmp    0x10(%ebp),%eax
  1033ad:	7c 02                	jl     1033b1 <strtol+0x124>
            break;
  1033af:	eb 1a                	jmp    1033cb <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1033b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1033b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033b8:	0f af 45 10          	imul   0x10(%ebp),%eax
  1033bc:	89 c2                	mov    %eax,%edx
  1033be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033c1:	01 d0                	add    %edx,%eax
  1033c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1033c6:	e9 6f ff ff ff       	jmp    10333a <strtol+0xad>

    if (endptr) {
  1033cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1033cf:	74 08                	je     1033d9 <strtol+0x14c>
        *endptr = (char *) s;
  1033d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033d4:	8b 55 08             	mov    0x8(%ebp),%edx
  1033d7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1033d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1033dd:	74 07                	je     1033e6 <strtol+0x159>
  1033df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033e2:	f7 d8                	neg    %eax
  1033e4:	eb 03                	jmp    1033e9 <strtol+0x15c>
  1033e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1033e9:	c9                   	leave  
  1033ea:	c3                   	ret    

001033eb <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1033eb:	55                   	push   %ebp
  1033ec:	89 e5                	mov    %esp,%ebp
  1033ee:	57                   	push   %edi
  1033ef:	83 ec 24             	sub    $0x24,%esp
  1033f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033f5:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1033f8:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1033fc:	8b 55 08             	mov    0x8(%ebp),%edx
  1033ff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103402:	88 45 f7             	mov    %al,-0x9(%ebp)
  103405:	8b 45 10             	mov    0x10(%ebp),%eax
  103408:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10340b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10340e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103412:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103415:	89 d7                	mov    %edx,%edi
  103417:	f3 aa                	rep stos %al,%es:(%edi)
  103419:	89 fa                	mov    %edi,%edx
  10341b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10341e:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103421:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103424:	83 c4 24             	add    $0x24,%esp
  103427:	5f                   	pop    %edi
  103428:	5d                   	pop    %ebp
  103429:	c3                   	ret    

0010342a <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10342a:	55                   	push   %ebp
  10342b:	89 e5                	mov    %esp,%ebp
  10342d:	57                   	push   %edi
  10342e:	56                   	push   %esi
  10342f:	53                   	push   %ebx
  103430:	83 ec 30             	sub    $0x30,%esp
  103433:	8b 45 08             	mov    0x8(%ebp),%eax
  103436:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103439:	8b 45 0c             	mov    0xc(%ebp),%eax
  10343c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10343f:	8b 45 10             	mov    0x10(%ebp),%eax
  103442:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103448:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10344b:	73 42                	jae    10348f <memmove+0x65>
  10344d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103450:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103456:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10345c:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10345f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103462:	c1 e8 02             	shr    $0x2,%eax
  103465:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103467:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10346a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10346d:	89 d7                	mov    %edx,%edi
  10346f:	89 c6                	mov    %eax,%esi
  103471:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103473:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103476:	83 e1 03             	and    $0x3,%ecx
  103479:	74 02                	je     10347d <memmove+0x53>
  10347b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10347d:	89 f0                	mov    %esi,%eax
  10347f:	89 fa                	mov    %edi,%edx
  103481:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103484:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103487:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  10348a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10348d:	eb 36                	jmp    1034c5 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10348f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103492:	8d 50 ff             	lea    -0x1(%eax),%edx
  103495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103498:	01 c2                	add    %eax,%edx
  10349a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10349d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1034a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034a3:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1034a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034a9:	89 c1                	mov    %eax,%ecx
  1034ab:	89 d8                	mov    %ebx,%eax
  1034ad:	89 d6                	mov    %edx,%esi
  1034af:	89 c7                	mov    %eax,%edi
  1034b1:	fd                   	std    
  1034b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034b4:	fc                   	cld    
  1034b5:	89 f8                	mov    %edi,%eax
  1034b7:	89 f2                	mov    %esi,%edx
  1034b9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1034bc:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1034bf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1034c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1034c5:	83 c4 30             	add    $0x30,%esp
  1034c8:	5b                   	pop    %ebx
  1034c9:	5e                   	pop    %esi
  1034ca:	5f                   	pop    %edi
  1034cb:	5d                   	pop    %ebp
  1034cc:	c3                   	ret    

001034cd <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1034cd:	55                   	push   %ebp
  1034ce:	89 e5                	mov    %esp,%ebp
  1034d0:	57                   	push   %edi
  1034d1:	56                   	push   %esi
  1034d2:	83 ec 20             	sub    $0x20,%esp
  1034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1034d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1034db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1034e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1034e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034ea:	c1 e8 02             	shr    $0x2,%eax
  1034ed:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1034ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034f5:	89 d7                	mov    %edx,%edi
  1034f7:	89 c6                	mov    %eax,%esi
  1034f9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1034fb:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1034fe:	83 e1 03             	and    $0x3,%ecx
  103501:	74 02                	je     103505 <memcpy+0x38>
  103503:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103505:	89 f0                	mov    %esi,%eax
  103507:	89 fa                	mov    %edi,%edx
  103509:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10350c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10350f:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103512:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103515:	83 c4 20             	add    $0x20,%esp
  103518:	5e                   	pop    %esi
  103519:	5f                   	pop    %edi
  10351a:	5d                   	pop    %ebp
  10351b:	c3                   	ret    

0010351c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10351c:	55                   	push   %ebp
  10351d:	89 e5                	mov    %esp,%ebp
  10351f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103522:	8b 45 08             	mov    0x8(%ebp),%eax
  103525:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103528:	8b 45 0c             	mov    0xc(%ebp),%eax
  10352b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10352e:	eb 30                	jmp    103560 <memcmp+0x44>
        if (*s1 != *s2) {
  103530:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103533:	0f b6 10             	movzbl (%eax),%edx
  103536:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103539:	0f b6 00             	movzbl (%eax),%eax
  10353c:	38 c2                	cmp    %al,%dl
  10353e:	74 18                	je     103558 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103543:	0f b6 00             	movzbl (%eax),%eax
  103546:	0f b6 d0             	movzbl %al,%edx
  103549:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10354c:	0f b6 00             	movzbl (%eax),%eax
  10354f:	0f b6 c0             	movzbl %al,%eax
  103552:	29 c2                	sub    %eax,%edx
  103554:	89 d0                	mov    %edx,%eax
  103556:	eb 1a                	jmp    103572 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103558:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10355c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  103560:	8b 45 10             	mov    0x10(%ebp),%eax
  103563:	8d 50 ff             	lea    -0x1(%eax),%edx
  103566:	89 55 10             	mov    %edx,0x10(%ebp)
  103569:	85 c0                	test   %eax,%eax
  10356b:	75 c3                	jne    103530 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10356d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103572:	c9                   	leave  
  103573:	c3                   	ret    
