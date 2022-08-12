
loader_block.o:     file format elf32-i386


Disassembly of section .text:

00010000 <LdrEntry16>:
   10000:	eb 02                	jmp    10004 <LdrEntry16.JmpOutLdrSignature>
   10002:	55                   	push   %ebp
   10003:	aa                   	stos   %al,%es:(%edi)

00010004 <LdrEntry16.JmpOutLdrSignature>:
   10004:	fc                   	cld    
   10005:	6a 00                	push   $0x0
   10007:	6a 00                	push   $0x0
   10009:	85 ff                	test   %edi,%edi
   1000b:	0f 84 c3 00 66 31    	je     316700d4 <_end+0x31650028>
   10011:	d2 8e c2 66 8b 46    	rorb   %cl,0x468b66c2(%esi)
   10017:	0a 66 2b             	or     0x2b(%esi),%ah
   1001a:	46                   	inc    %esi
   1001b:	1e                   	push   %ds
   1001c:	66 0f b6 4e 09       	movzbw 0x9(%esi),%cx
   10021:	66 f7 f1             	div    %cx
   10024:	66 3d f5 ff          	cmp    $0xfff5,%ax
   10028:	00 00                	add    %al,(%eax)
   1002a:	0f 83 a4 00 66 3d    	jae    3d6700d4 <_end+0x3d650028>
   10030:	f5                   	cmc    
   10031:	0f 00 00             	sldt   (%eax)
   10034:	0f 93 46 fa          	setae  -0x6(%esi)
   10038:	66 8b 4e 12          	mov    0x12(%esi),%cx
   1003c:	8b 46 0e             	mov    0xe(%esi),%eax
   1003f:	8b 56 10             	mov    0x10(%esi),%edx
   10042:	bb                   	.byte 0xbb
   10043:	00 08                	add    %cl,(%eax)

00010045 <_ReadFatSector>:
   10045:	e8 8e 00 0f 82       	call   821000d8 <_end+0x820e002c>
   1004a:	86 00                	xchg   %al,(%eax)
   1004c:	26 80 3f 00          	cmpb   $0x0,%es:(%edi)
   10050:	74 0b                	je     1005d <_ReadFatSector.Done>
   10052:	03 5e 07             	add    0x7(%esi),%ebx
   10055:	40                   	inc    %eax
   10056:	83 d2 00             	adc    $0x0,%edx
   10059:	66 49                	dec    %cx
   1005b:	75 e8                	jne    10045 <_ReadFatSector>

0001005d <_ReadFatSector.Done>:
   1005d:	8b 46 07             	mov    0x7(%esi),%eax
   10060:	0f b6 4e 09          	movzbl 0x9(%esi),%ecx
   10064:	f7 e1                	mul    %ecx
   10066:	c1 e8 04             	shr    $0x4,%eax
   10069:	05 00 10 8e c0       	add    $0xc08e1000,%eax
   1006e:	8b 5e 07             	mov    0x7(%esi),%ebx
   10071:	c1 eb 04             	shr    $0x4,%ebx

00010074 <_ReadLoaderSector>:
   10074:	89 f8                	mov    %edi,%eax
   10076:	51                   	push   %ecx
   10077:	b9 03 00 03 4e       	mov    $0x4e030003,%ecx
   1007c:	fa                   	cli    
   1007d:	f7 e1                	mul    %ecx
   1007f:	b1 02                	mov    $0x2,%cl
   10081:	f7 f1                	div    %ecx
   10083:	59                   	pop    %ecx
   10084:	89 c6                	mov    %eax,%esi
   10086:	b8 f8 ff 89 fa       	mov    $0xfa89fff8,%eax
   1008b:	8b bc 00 08 80 7e fa 	mov    -0x5817ff8(%eax,%eax,1),%edi
   10092:	01 74 11 80          	add    %esi,-0x80(%ecx,%edx,1)
   10096:	e4 0f                	in     $0xf,%al
   10098:	80 e2 01             	and    $0x1,%dl
   1009b:	74 05                	je     100a2 <_ReadLoaderSector.Even>
   1009d:	c1 ef 04             	shr    $0x4,%edi
   100a0:	eb 04                	jmp    100a6 <_ReadLoaderSector.Out>

000100a2 <_ReadLoaderSector.Even>:
   100a2:	81                   	.byte 0x81
   100a3:	e7 ff                	out    %eax,$0xff
   100a5:	0f                   	.byte 0xf

000100a6 <_ReadLoaderSector.Out>:
   100a6:	39 c7                	cmp    %eax,%edi
   100a8:	0f 83 a4 00 89 f8    	jae    f88a0152 <_end+0xf88800a6>
   100ae:	48                   	dec    %eax
   100af:	48                   	dec    %eax
   100b0:	0f b6 4e 09          	movzbl 0x9(%esi),%ecx
   100b4:	f7 e1                	mul    %ecx
   100b6:	03 46 1e             	add    0x1e(%esi),%eax
   100b9:	13 56 20             	adc    0x20(%esi),%edx

000100bc <_ReadOneCluster>:
   100bc:	53                   	push   %ebx
   100bd:	31 db                	xor    %ebx,%ebx
   100bf:	e8 14 00 5b 72       	call   725c00d8 <_end+0x725a002c>
   100c4:	0d 06 01 5e f6       	or     $0xf65e0106,%eax
   100c9:	07                   	pop    %es
   100ca:	40                   	inc    %eax
   100cb:	83 d2 00             	adc    $0x0,%edx
   100ce:	e2 ec                	loop   100bc <_ReadOneCluster>
   100d0:	eb a2                	jmp    10074 <_ReadLoaderSector>

000100d2 <_LoadFailed>:
   100d2:	83 c4 02             	add    $0x2,%esp
   100d5:	cb                   	lret   

000100d6 <ReadSector>:
   100d6:	60                   	pusha  
   100d7:	66 6a 00             	pushw  $0x0
   100da:	52                   	push   %edx
   100db:	50                   	push   %eax
   100dc:	06                   	push   %es
   100dd:	53                   	push   %ebx
   100de:	6a 01                	push   $0x1
   100e0:	6a 10                	push   $0x10
   100e2:	80 7e f8 01          	cmpb   $0x1,-0x8(%esi)
   100e6:	74 2b                	je     10113 <ReadSector.CHS.1>

000100e8 <ReadSector.LBA>:
   100e8:	89 e6                	mov    %esp,%esi
   100ea:	60                   	pusha  
   100eb:	b4 41                	mov    $0x41,%ah
   100ed:	bb aa 55 8a 56       	mov    $0x568a55aa,%ebx
   100f2:	06                   	push   %es
   100f3:	cd 13                	int    $0x13
   100f5:	72 17                	jb     1010e <ReadSector.CHS>
   100f7:	81 fb 55 aa 75 11    	cmp    $0x1175aa55,%ebx
   100fd:	f6 c1 01             	test   $0x1,%cl
   10100:	74 0c                	je     1010e <ReadSector.CHS>
   10102:	b4 42                	mov    $0x42,%ah
   10104:	8a 56 06             	mov    0x6(%esi),%dl
   10107:	cd 13                	int    $0x13
   10109:	72 03                	jb     1010e <ReadSector.CHS>
   1010b:	61                   	popa   
   1010c:	eb 22                	jmp    10130 <ReadSector.Exit>

0001010e <ReadSector.CHS>:
   1010e:	c6 46 f8 01          	movb   $0x1,-0x8(%esi)
   10112:	61                   	popa   

00010113 <ReadSector.CHS.1>:
   10113:	f7 76 00             	divl   0x0(%esi)
   10116:	88 d1                	mov    %dl,%cl
   10118:	fe c1                	inc    %cl
   1011a:	30 d2                	xor    %dl,%dl
   1011c:	f7 76 02             	divl   0x2(%esi)
   1011f:	88 d6                	mov    %dl,%dh
   10121:	88 c5                	mov    %al,%ch
   10123:	c0 e4 06             	shl    $0x6,%ah
   10126:	08 e1                	or     %ah,%cl
   10128:	b8 01 02 8a 56       	mov    $0x568a0201,%eax
   1012d:	06                   	push   %es
   1012e:	cd 13                	int    $0x13

00010130 <ReadSector.Exit>:
   10130:	61                   	popa   
   10131:	61                   	popa   
   10132:	c3                   	ret    

00010133 <DispStr>:
   10133:	60                   	pusha  
   10134:	b4 0e                	mov    $0xe,%ah
   10136:	bb                   	.byte 0xbb
   10137:	07                   	pop    %es
	...

00010139 <DispStr.Loop>:
   10139:	ac                   	lods   %ds:(%esi),%al
   1013a:	84 c0                	test   %al,%al
   1013c:	74 04                	je     10142 <DispStr.Exit>
   1013e:	cd 10                	int    $0x10
   10140:	eb f7                	jmp    10139 <DispStr.Loop>

00010142 <DispStr.Exit>:
   10142:	b0 0d                	mov    $0xd,%al
   10144:	cd 10                	int    $0x10
   10146:	b0 0a                	mov    $0xa,%al
   10148:	cd 10                	int    $0x10
   1014a:	30 e4                	xor    %ah,%ah
   1014c:	cd 16                	int    $0x16
   1014e:	61                   	popa   
   1014f:	c3                   	ret    

00010150 <_LoadDone>:
   10150:	e8 9d 12 0f 82       	call   821013f2 <_end+0x820e1346>
   10155:	7b ff                	jnp    10156 <_LoadDone+0x6>

00010157 <_CopyLoaderParameter>:
   10157:	b8 00 10 8e c0       	mov    $0xc08e1000,%eax
   1015c:	89 ee                	mov    %ebp,%esi
   1015e:	bf 7c 04 b9 13       	mov    $0x13b9047c,%edi
   10163:	00 f3                	add    %dh,%bl
   10165:	a5                   	movsl  %ds:(%esi),%es:(%edi)

00010166 <_GetMemMap>:
   10166:	b8 00 10 8e c0       	mov    $0xc08e1000,%eax
   1016b:	bf e0 04 66 31       	mov    $0x316604e0,%edi
   10170:	db 66 ba             	(bad)  -0x46(%esi)
   10173:	50                   	push   %eax
   10174:	41                   	inc    %ecx
   10175:	4d                   	dec    %ebp
   10176:	53                   	push   %ebx
   10177:	66 b9 14 00          	mov    $0x14,%cx
	...

0001017d <_GetMemMap.E820>:
   1017d:	66 b8 20 e8          	mov    $0xe820,%ax
   10181:	00 00                	add    %al,(%eax)
   10183:	cd 15                	int    $0x15
   10185:	72 19                	jb     101a0 <_GetMemMap.E801>
   10187:	66 3d 50 41          	cmp    $0x4150,%ax
   1018b:	4d                   	dec    %ebp
   1018c:	53                   	push   %ebx
   1018d:	75 11                	jne    101a0 <_GetMemMap.E801>
   1018f:	66 83 f9 14          	cmp    $0x14,%cx
   10193:	75 0b                	jne    101a0 <_GetMemMap.E801>
   10195:	83 c7 14             	add    $0x14,%edi
   10198:	66 85 db             	test   %bx,%bx
   1019b:	75 e0                	jne    1017d <_GetMemMap.E820>
   1019d:	e9                   	.byte 0xe9
   1019e:	b8                   	.byte 0xb8
	...

000101a0 <_GetMemMap.E801>:
   101a0:	b8 01 e8 cd 15       	mov    $0x15cde801,%eax
   101a5:	72 77                	jb     1021e <_GetMemMap.88>
   101a7:	bf e0 04 85 c0       	mov    $0xc08504e0,%edi
   101ac:	74 06                	je     101b4 <_GetMemMap.1>
   101ae:	66 0f b7 c0          	movzww %ax,%ax
   101b2:	eb 04                	jmp    101b8 <_GetMemMap.2>

000101b4 <_GetMemMap.1>:
   101b4:	66 0f b7 c1          	movzww %cx,%ax

000101b8 <_GetMemMap.2>:
   101b8:	85 db                	test   %ebx,%ebx
   101ba:	74 06                	je     101c2 <_GetMemMap.3>
   101bc:	66 0f b7 db          	movzww %bx,%bx
   101c0:	eb 04                	jmp    101c6 <_GetMemMap.4>

000101c2 <_GetMemMap.3>:
   101c2:	66 0f b7 da          	movzww %dx,%bx

000101c6 <_GetMemMap.4>:
   101c6:	66 b9 00 04          	mov    $0x400,%cx
   101ca:	00 00                	add    %al,(%eax)
   101cc:	66 f7 e1             	mul    %cx
   101cf:	66 89 c1             	mov    %ax,%cx
   101d2:	66 b8 00 00          	mov    $0x0,%ax
   101d6:	10 00                	adc    %al,(%eax)
   101d8:	66 ab                	stos   %ax,%es:(%edi)
   101da:	66 31 c0             	xor    %ax,%ax
   101dd:	66 ab                	stos   %ax,%es:(%edi)
   101df:	66 89 c8             	mov    %cx,%ax
   101e2:	66 ab                	stos   %ax,%es:(%edi)
   101e4:	66 89 d0             	mov    %dx,%ax
   101e7:	66 ab                	stos   %ax,%es:(%edi)
   101e9:	66 b8 01 00          	mov    $0x1,%ax
   101ed:	00 00                	add    %al,(%eax)
   101ef:	66 ab                	stos   %ax,%es:(%edi)
   101f1:	66 b8 00 00          	mov    $0x0,%ax
   101f5:	01 00                	add    %eax,(%eax)
   101f7:	66 f7 e3             	mul    %bx
   101fa:	66 89 c1             	mov    %ax,%cx
   101fd:	66 b8 00 00          	mov    $0x0,%ax
   10201:	00 01                	add    %al,(%ecx)
   10203:	66 ab                	stos   %ax,%es:(%edi)
   10205:	66 31 c0             	xor    %ax,%ax
   10208:	66 ab                	stos   %ax,%es:(%edi)
   1020a:	66 89 c8             	mov    %cx,%ax
   1020d:	66 ab                	stos   %ax,%es:(%edi)
   1020f:	66 89 d0             	mov    %dx,%ax
   10212:	66 ab                	stos   %ax,%es:(%edi)
   10214:	66 b8 01 00          	mov    $0x1,%ax
   10218:	00 00                	add    %al,(%eax)
   1021a:	66 ab                	stos   %ax,%es:(%edi)
   1021c:	eb 3a                	jmp    10258 <_GetMemMap.Exit>

0001021e <_GetMemMap.88>:
   1021e:	b4 88                	mov    $0x88,%ah
   10220:	cd 15                	int    $0x15
   10222:	0f 82 ac fe bf e0    	jb     e0c100d4 <_end+0xe0bf0028>
   10228:	04 66                	add    $0x66,%al
   1022a:	0f b7 c0             	movzwl %ax,%eax
   1022d:	66 b9 00 04          	mov    $0x400,%cx
   10231:	00 00                	add    %al,(%eax)
   10233:	66 f7 e1             	mul    %cx
   10236:	66 89 c1             	mov    %ax,%cx
   10239:	66 b8 00 00          	mov    $0x0,%ax
   1023d:	10 00                	adc    %al,(%eax)
   1023f:	66 ab                	stos   %ax,%es:(%edi)
   10241:	66 31 c0             	xor    %ax,%ax
   10244:	66 ab                	stos   %ax,%es:(%edi)
   10246:	66 89 c8             	mov    %cx,%ax
   10249:	66 ab                	stos   %ax,%es:(%edi)
   1024b:	66 89 d0             	mov    %dx,%ax
   1024e:	66 ab                	stos   %ax,%es:(%edi)
   10250:	66 b8 01 00          	mov    $0x1,%ax
   10254:	00 00                	add    %al,(%eax)
   10256:	66 ab                	stos   %ax,%es:(%edi)

00010258 <_GetMemMap.Exit>:
   10258:	b8 00 10 8e d8       	mov    $0xd88e1000,%eax
   1025d:	c1 e8 04             	shr    $0x4,%eax
   10260:	8e c0                	mov    %eax,%es
   10262:	b8 00 4f 31 ff       	mov    $0xff314f00,%eax
   10267:	26 66 c7 05 56 42 45 	movw   $0x10cd,%es:0x32454256
   1026e:	32 cd 10 
   10271:	83 f8 4f             	cmp    $0x4f,%eax
   10274:	0f 85 d0 00 26 66    	jne    6627034a <_end+0x6625029e>
   1027a:	81 3d 56 45 53 41 0f 	cmpl   $0xc4850f,0x41534556
   10281:	85 c4 00 
   10284:	26 8b 45 04          	mov    %es:0x4(%ebp),%eax
   10288:	3d 00 02 0f 82       	cmp    $0x820f0200,%eax
   1028d:	b9 00 a3 a5 04       	mov    $0x4a5a300,%ecx
   10292:	26 8b 45 12          	mov    %es:0x12(%ebp),%eax
   10296:	a3 b5 04 26 8b       	mov    %eax,0x8b2604b5
   1029b:	45                   	inc    %ebp
   1029c:	14 a3                	adc    $0xa3,%al
   1029e:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
   1029f:	04 26                	add    $0x26,%al
   102a1:	66 ff 75 06          	pushw  0x6(%ebp)
   102a5:	5e                   	pop    %esi
   102a6:	1f                   	pop    %ds
   102a7:	e8 89 fe 26 66       	call   66280135 <_end+0x66260089>
   102ac:	ff 75 0e             	push   0xe(%ebp)
   102af:	5e                   	pop    %esi
   102b0:	1f                   	pop    %ds
   102b1:	68 00 10 07 bf       	push   $0xbf071000
   102b6:	e0 09                	loopne 102c1 <_SetupConsoleMode.GUI+0x2>

000102b8 <_SetupConsoleMode.CopyVideoMode>:
   102b8:	ad                   	lods   %ds:(%esi),%eax
   102b9:	ab                   	stos   %eax,%es:(%edi)
   102ba:	83 f8 ff             	cmp    $0xffffffff,%eax
   102bd:	75 f9                	jne    102b8 <_SetupConsoleMode.CopyVideoMode>

000102bf <_SetupConsoleMode.GUI>:
   102bf:	b8 00 10 8e d8       	mov    $0xd88e1000,%eax
   102c4:	c1 e8 04             	shr    $0x4,%eax
   102c7:	8e c0                	mov    %eax,%es
   102c9:	be                   	.byte 0xbe
   102ca:	e0 09                	loopne 102d5 <_SetupConsoleMode.LookupTargetMode+0x9>

000102cc <_SetupConsoleMode.LookupTargetMode>:
   102cc:	ad                   	lods   %ds:(%esi),%eax
   102cd:	83 f8 ff             	cmp    $0xffffffff,%eax
   102d0:	74 76                	je     10348 <_SetupConsoleMode.Legacy>
   102d2:	89 c1                	mov    %eax,%ecx
   102d4:	89 c3                	mov    %eax,%ebx
   102d6:	31 ff                	xor    %edi,%edi
   102d8:	b8 01 4f cd 10       	mov    $0x10cd4f01,%eax
   102dd:	83 f8 4f             	cmp    $0x4f,%eax
   102e0:	75 ea                	jne    102cc <_SetupConsoleMode.LookupTargetMode>
   102e2:	26 8a 05 24 9b 3c 9b 	mov    %es:0x9b3c9b24,%al
   102e9:	75 e1                	jne    102cc <_SetupConsoleMode.LookupTargetMode>
   102eb:	26 8a 45 1b          	mov    %es:0x1b(%ebp),%al
   102ef:	3c 06                	cmp    $0x6,%al
   102f1:	75 d9                	jne    102cc <_SetupConsoleMode.LookupTargetMode>
   102f3:	26 8a 45 1f          	mov    %es:0x1f(%ebp),%al
   102f7:	3c 08                	cmp    $0x8,%al
   102f9:	75 d1                	jne    102cc <_SetupConsoleMode.LookupTargetMode>
   102fb:	26 8a 45 21          	mov    %es:0x21(%ebp),%al
   102ff:	3c 08                	cmp    $0x8,%al
   10301:	75 c9                	jne    102cc <_SetupConsoleMode.LookupTargetMode>
   10303:	26 8a 45 23          	mov    %es:0x23(%ebp),%al
   10307:	3c 08                	cmp    $0x8,%al
   10309:	75 c1                	jne    102cc <_SetupConsoleMode.LookupTargetMode>
   1030b:	26 8a 45 19          	mov    %es:0x19(%ebp),%al
   1030f:	3c 18                	cmp    $0x18,%al
   10311:	72 b9                	jb     102cc <_SetupConsoleMode.LookupTargetMode>
   10313:	a2 b7 04 26 8b       	mov    %al,0x8b2604b7
   10318:	45                   	inc    %ebp
   10319:	12 3d 20 03 72 ad    	adc    0xad720320,%bh
   1031f:	a3 a9 04 26 8b       	mov    %eax,0x8b2604a9
   10324:	45                   	inc    %ebp
   10325:	10 a3 b8 04 26 8b    	adc    %ah,-0x74d9fb48(%ebx)
   1032b:	45                   	inc    %ebp
   1032c:	14 a3                	adc    $0xa3,%al
   1032e:	ab                   	stos   %eax,%es:(%edi)
   1032f:	04 26                	add    $0x26,%al
   10331:	66 8b 45 28          	mov    0x28(%ebp),%ax
   10335:	66 a3 ad 04 80 cf    	mov    %ax,0xcf8004ad
   1033b:	40                   	inc    %eax
   1033c:	b8 02 4f cd 10       	mov    $0x10cd4f02,%eax
   10341:	83 f8 4f             	cmp    $0x4f,%eax
   10344:	75 86                	jne    102cc <_SetupConsoleMode.LookupTargetMode>
   10346:	eb 30                	jmp    10378 <_SetupConsoleMode.Exit>

00010348 <_SetupConsoleMode.Legacy>:
   10348:	b8 03 00 cd 10       	mov    $0x10cd0003,%eax
   1034d:	c6 06 a4             	movb   $0xa4,(%esi)
   10350:	04 00                	add    $0x0,%al
   10352:	c7 06 a9 04 50 00    	movl   $0x5004a9,(%esi)
   10358:	c7 06 ab 04 19 00    	movl   $0x1904ab,(%esi)
   1035e:	66 c7 06 ad 04       	movw   $0x4ad,(%esi)
   10363:	00 80 0b 00 c7 06    	add    %al,0x6c7000b(%eax)
   10369:	b5 04                	mov    $0x4,%ch
   1036b:	a0 0f c6 06 b7       	mov    0xb706c60f,%al
   10370:	04 10                	add    $0x10,%al
   10372:	c7 06 b8 04 a0 00    	movl   $0xa004b8,(%esi)

00010378 <_SetupConsoleMode.Exit>:
   10378:	b8 01 b1 cd 1a       	mov    $0x1acdb101,%eax
   1037d:	72 1d                	jb     1039c <_SetupAPM>
   1037f:	84 e4                	test   %ah,%ah
   10381:	75 19                	jne    1039c <_SetupAPM>
   10383:	66 81 fa 50 43       	cmp    $0x4350,%dx
   10388:	49                   	dec    %ecx
   10389:	20 75 10             	and    %dh,0x10(%ebp)
   1038c:	89 1e                	mov    %ebx,(%esi)
   1038e:	bc 04 a2 be 04       	mov    $0x4bea204,%esp
   10393:	88 0e                	mov    %cl,(%esi)
   10395:	bf 04 c6 06 c0       	mov    $0xc006c604,%edi
   1039a:	04 01                	add    $0x1,%al

0001039c <_SetupAPM>:
   1039c:	b8 00 53 31 db       	mov    $0xdb315300,%eax
   103a1:	cd 15                	int    $0x15
   103a3:	72 62                	jb     10407 <_SetupAPM.Exit>
   103a5:	81 fb 4d 50 75 5c    	cmp    $0x5c75504d,%ebx
   103ab:	f6 c1 02             	test   $0x2,%cl
   103ae:	74 57                	je     10407 <_SetupAPM.Exit>
   103b0:	a3 c4 04 88 0e       	mov    %eax,0xe8804c4
   103b5:	c6 04 b8 04          	movb   $0x4,(%eax,%edi,4)
   103b9:	53                   	push   %ebx
   103ba:	31 db                	xor    %ebx,%ebx
   103bc:	cd 15                	int    $0x15
   103be:	b8 03 53 31 db       	mov    $0xdb315303,%eax
   103c3:	cd 15                	int    $0x15
   103c5:	72 40                	jb     10407 <_SetupAPM.Exit>
   103c7:	66 0f b7 c0          	movzww %ax,%ax
   103cb:	66 c1 e0 04          	shl    $0x4,%ax
   103cf:	66 a3 c7 04 89 36    	mov    %ax,0x368904c7
   103d5:	cb                   	lret   
   103d6:	04 66                	add    $0x66,%al
   103d8:	0f b7 c9             	movzwl %cx,%ecx
   103db:	66 c1 e1 04          	shl    $0x4,%cx
   103df:	66 89 0e             	mov    %cx,(%esi)
   103e2:	cd 04                	int    $0x4
   103e4:	66 c1 ee 10          	shr    $0x10,%si
   103e8:	89 36                	mov    %esi,(%esi)
   103ea:	d1 04 66             	roll   (%esi,%eiz,2)
   103ed:	0f b7 d2             	movzwl %dx,%edx
   103f0:	66 c1 e2 04          	shl    $0x4,%dx
   103f4:	66 89 16             	mov    %dx,(%esi)
   103f7:	d3 04 89             	roll   %cl,(%ecx,%ecx,4)
   103fa:	3e d7                	xlat   %ds:(%ebx)
   103fc:	04 66                	add    $0x66,%al
   103fe:	89 1e                	mov    %ebx,(%esi)
   10400:	d9 04 c6             	flds   (%esi,%eax,8)
   10403:	06                   	push   %es
   10404:	dd 04 01             	fldl   (%ecx,%eax,1)

00010407 <_SetupAPM.Exit>:
   10407:	fa                   	cli    
   10408:	b0 80                	mov    $0x80,%al
   1040a:	e6 70                	out    %al,$0x70
   1040c:	30 c0                	xor    %al,%al
   1040e:	e6 f0                	out    %al,$0xf0
   10410:	e6 f1                	out    %al,$0xf1
   10412:	f6 d0                	not    %al
   10414:	e6 a1                	out    %al,$0xa1
   10416:	b0 fb                	mov    $0xfb,%al
   10418:	e6 21                	out    %al,$0x21
   1041a:	0f 01 16             	lgdtl  (%esi)
   1041d:	e0 0b                	loopne 1042a <_SetupAPM.Exit+0x23>
   1041f:	0f 01 1e             	lidtl  (%esi)
   10422:	e8 13 0f 01 e0       	call   e002133a <_end+0xe000128e>
   10427:	0c 01                	or     $0x1,%al
   10429:	0f 01 f0             	lmsw   %ax
   1042c:	66 ea 34 04 01 00    	ljmpw  $0x1,$0x434
   10432:	08 00                	or     %al,(%eax)

00010434 <LdrEntry32>:
   10434:	66 b8 10 00          	mov    $0x10,%ax
   10438:	8e d8                	mov    %eax,%ds
   1043a:	8e c0                	mov    %eax,%es
   1043c:	8e d0                	mov    %eax,%ss
   1043e:	66 31 c0             	xor    %ax,%ax
   10441:	8e e0                	mov    %eax,%fs
   10443:	8e e8                	mov    %eax,%gs
   10445:	bd 00 20 00 00       	mov    $0x2000,%ebp
   1044a:	89 ec                	mov    %ebp,%esp
   1044c:	66 0f 01 e0          	smsw   %ax
   10450:	0c 22                	or     $0x22,%al
   10452:	24 f3                	and    $0xf3,%al
   10454:	0f 01 f0             	lmsw   %ax
   10457:	9b db e3             	finit  
   1045a:	68 68 04 01 00       	push   $0x10468
   1045f:	e8 c7 63 00 00       	call   1682b <LdrMain>
   10464:	eb fe                	jmp    10464 <LdrEntry32+0x30>
   10466:	90                   	nop
   10467:	90                   	nop

00010468 <LdrParameter>:
   10468:	7c 04                	jl     1046e <LdrParameter+0x6>
   1046a:	01 00                	add    %eax,(%eax)
   1046c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
   1046d:	04 01                	add    $0x1,%al
   1046f:	00 bc 04 01 00 c4 04 	add    %bh,0x4c40001(%esp,%eax,1)
   10476:	01 00                	add    %eax,(%eax)
   10478:	e0 04                	loopne 1047e <LdrParameter+0x16>
   1047a:	01 00                	add    %eax,(%eax)
	...
   104a0:	00 00                	add    %al,(%eax)
   104a2:	90                   	nop
   104a3:	90                   	nop
   104a4:	01 00                	add    %eax,(%eax)
	...
   104ae:	00 00                	add    %al,(%eax)
   104b0:	00 e0                	add    %ah,%al
   104b2:	09 01                	or     %eax,(%ecx)
   104b4:	00 00                	add    %al,(%eax)
   104b6:	00 00                	add    %al,(%eax)
   104b8:	00 00                	add    %al,(%eax)
   104ba:	90                   	nop
   104bb:	90                   	nop
   104bc:	00 00                	add    %al,(%eax)
   104be:	00 00                	add    %al,(%eax)
   104c0:	00 90 90 90 00 00    	add    %dl,0x9090(%eax)
	...
   104de:	90                   	nop
   104df:	90                   	nop
	...
   109e0:	ff                   	(bad)  
   109e1:	ff 00                	incl   (%eax)
	...

00010ae0 <gdt_begin>:
	...

00010ae8 <kcode>:
   10ae8:	ff                   	(bad)  
   10ae9:	ff 00                	incl   (%eax)
   10aeb:	00 00                	add    %al,(%eax)
   10aed:	9a                   	.byte 0x9a
   10aee:	cf                   	iret   
	...

00010af0 <kdata>:
   10af0:	ff                   	(bad)  
   10af1:	ff 00                	incl   (%eax)
   10af3:	00 00                	add    %al,(%eax)
   10af5:	92                   	xchg   %eax,%edx
   10af6:	cf                   	iret   
	...

00010af8 <gdt_dummpy>:
	...

00010be0 <gdt_end>:
   10be0:	ff 00                	incl   (%eax)
   10be2:	e0 0a                	loopne 10bee <idt_begin+0x6>
   10be4:	01 00                	add    %eax,(%eax)
   10be6:	90                   	nop
   10be7:	90                   	nop

00010be8 <idt_begin>:
	...

000113e8 <idt_end>:
   113e8:	ff 07                	incl   (%edi)
   113ea:	e8 0b 01 00 66       	call   660114fa <_end+0x65ff144e>
   113ef:	90                   	nop

000113f0 <A20_Gate>:
   113f0:	e8 72 00 73 20       	call   20741467 <_end+0x207213bb>
   113f5:	e8 1e 00 e8 6a       	call   6ae91418 <_end+0x6ae7136c>
   113fa:	00 73 18             	add    %dh,0x18(%ebx)
   113fd:	e8 1c 00 e8 62       	call   62e9141e <_end+0x62e71372>
   11402:	00 73 10             	add    %dh,0x10(%ebx)
   11405:	e8 4d 00 e8 5a       	call   5ae91457 <_end+0x5ae713ab>
   1140a:	00 73 08             	add    %dh,0x8(%ebx)
   1140d:	e8 52 00 e8 52       	call   52e91464 <_end+0x52e713b8>
   11412:	00 73 00             	add    %dh,0x0(%ebx)

00011415 <A20_Gate.Exit>:
   11415:	c3                   	ret    

00011416 <A20_Gate_Bios>:
   11416:	b8 01 24 cd 15       	mov    $0x15cd2401,%eax
   1141b:	c3                   	ret    

0001141c <A20_Gate_8042>:
   1141c:	b0 ad                	mov    $0xad,%al
   1141e:	e6 64                	out    %al,$0x64
   11420:	b0 a7                	mov    $0xa7,%al
   11422:	e6 64                	out    %al,$0x64

00011424 <A20_Gate_8042.empty_outbuf>:
   11424:	e4 64                	in     $0x64,%al
   11426:	a8 01                	test   $0x1,%al
   11428:	74 04                	je     1142e <A20_Gate_8042.empty>
   1142a:	e4 60                	in     $0x60,%al
   1142c:	eb f6                	jmp    11424 <A20_Gate_8042.empty_outbuf>

0001142e <A20_Gate_8042.empty>:
   1142e:	e8 74 00 b0 d0       	call   d0b114a7 <_end+0xd0af13fb>
   11433:	e6 64                	out    %al,$0x64
   11435:	e8 66 00 e4 60       	call   60e514a0 <_end+0x60e313f4>
   1143a:	50                   	push   %eax
   1143b:	e8 67 00 b0 d1       	call   d1b114a7 <_end+0xd1af13fb>
   11440:	e6 64                	out    %al,$0x64
   11442:	e8 60 00 58 0c       	call   c5914a7 <_end+0xc5713fb>
   11447:	02 e6                	add    %dh,%ah
   11449:	60                   	pusha  
   1144a:	e8 58 00 b0 ae       	call   aeb114a7 <_end+0xaeaf13fb>
   1144f:	e6 64                	out    %al,$0x64
   11451:	e8                   	.byte 0xe8
   11452:	51                   	push   %ecx
   11453:	00 c3                	add    %al,%bl

00011455 <A20_Gate_FastGate>:
   11455:	e4 92                	in     $0x92,%al
   11457:	a8 02                	test   $0x2,%al
   11459:	75 06                	jne    11461 <A20_Gate_FastGate.Exit>
   1145b:	0c 02                	or     $0x2,%al
   1145d:	24 fe                	and    $0xfe,%al
   1145f:	e6 92                	out    %al,$0x92

00011461 <A20_Gate_FastGate.Exit>:
   11461:	c3                   	ret    

00011462 <A20_Gate_PortEE>:
   11462:	e4 ee                	in     $0xee,%al
   11464:	c3                   	ret    

00011465 <CheckA20>:
   11465:	56                   	push   %esi
   11466:	57                   	push   %edi
   11467:	50                   	push   %eax
   11468:	1e                   	push   %ds
   11469:	06                   	push   %es
   1146a:	31 c0                	xor    %eax,%eax
   1146c:	8e d8                	mov    %eax,%ds
   1146e:	f7 d0                	not    %eax
   11470:	8e c0                	mov    %eax,%es
   11472:	be 00 05 bf 10       	mov    $0x10bf0500,%esi
   11477:	05 3e 8a 04 50       	add    $0x50048a3e,%eax
   1147c:	26 8a 05 50 3e c6 04 	mov    %es:0x4c63e50,%al
   11483:	00 26                	add    %ah,(%esi)
   11485:	c6 05 ff 3e 80 3c ff 	movb   $0xff,0x3c803eff
   1148c:	58                   	pop    %eax
   1148d:	26 88 05 58 3e 88 04 	mov    %al,%es:0x4883e58
   11494:	f9                   	stc    
   11495:	74 01                	je     11498 <CheckA20.Exit>
   11497:	f8                   	clc    

00011498 <CheckA20.Exit>:
   11498:	07                   	pop    %es
   11499:	1f                   	pop    %ds
   1149a:	58                   	pop    %eax
   1149b:	5f                   	pop    %edi
   1149c:	5e                   	pop    %esi
   1149d:	c3                   	ret    

0001149e <Wait_8042_Read>:
   1149e:	e4 64                	in     $0x64,%al
   114a0:	a8 01                	test   $0x1,%al
   114a2:	75 fa                	jne    1149e <Wait_8042_Read>
   114a4:	c3                   	ret    

000114a5 <Wait_8042_Write>:
   114a5:	e4 64                	in     $0x64,%al
   114a7:	a8 02                	test   $0x2,%al
   114a9:	75 fa                	jne    114a5 <Wait_8042_Write>
   114ab:	c3                   	ret    
   114ac:	66 90                	xchg   %ax,%ax
   114ae:	66 90                	xchg   %ax,%ax

000114b0 <kTrap0>:
   114b0:	6a 00                	push   $0x0
   114b2:	6a 00                	push   $0x0
   114b4:	ff 74 24 10          	push   0x10(%esp)
   114b8:	ff 74 24 10          	push   0x10(%esp)
   114bc:	ff 74 24 10          	push   0x10(%esp)
   114c0:	60                   	pusha  
   114c1:	0f 20 e0             	mov    %cr4,%eax
   114c4:	50                   	push   %eax
   114c5:	0f 20 d8             	mov    %cr3,%eax
   114c8:	50                   	push   %eax
   114c9:	0f 20 d0             	mov    %cr2,%eax
   114cc:	50                   	push   %eax
   114cd:	0f 20 c0             	mov    %cr0,%eax
   114d0:	50                   	push   %eax
   114d1:	e8 03 30 00 00       	call   144d9 <common_trap_handler>
   114d6:	83 c4 10             	add    $0x10,%esp
   114d9:	61                   	popa   
   114da:	83 c4 0c             	add    $0xc,%esp
   114dd:	83 c4 08             	add    $0x8,%esp
   114e0:	cf                   	iret   
   114e1:	90                   	nop
   114e2:	90                   	nop
   114e3:	90                   	nop

000114e4 <kTrap1>:
   114e4:	6a 00                	push   $0x0
   114e6:	6a 01                	push   $0x1
   114e8:	ff 74 24 10          	push   0x10(%esp)
   114ec:	ff 74 24 10          	push   0x10(%esp)
   114f0:	ff 74 24 10          	push   0x10(%esp)
   114f4:	60                   	pusha  
   114f5:	0f 20 e0             	mov    %cr4,%eax
   114f8:	50                   	push   %eax
   114f9:	0f 20 d8             	mov    %cr3,%eax
   114fc:	50                   	push   %eax
   114fd:	0f 20 d0             	mov    %cr2,%eax
   11500:	50                   	push   %eax
   11501:	0f 20 c0             	mov    %cr0,%eax
   11504:	50                   	push   %eax
   11505:	e8 cf 2f 00 00       	call   144d9 <common_trap_handler>
   1150a:	83 c4 10             	add    $0x10,%esp
   1150d:	61                   	popa   
   1150e:	83 c4 0c             	add    $0xc,%esp
   11511:	83 c4 08             	add    $0x8,%esp
   11514:	cf                   	iret   
   11515:	90                   	nop
   11516:	90                   	nop
   11517:	90                   	nop

00011518 <kTrap2>:
   11518:	6a 00                	push   $0x0
   1151a:	6a 02                	push   $0x2
   1151c:	ff 74 24 10          	push   0x10(%esp)
   11520:	ff 74 24 10          	push   0x10(%esp)
   11524:	ff 74 24 10          	push   0x10(%esp)
   11528:	60                   	pusha  
   11529:	0f 20 e0             	mov    %cr4,%eax
   1152c:	50                   	push   %eax
   1152d:	0f 20 d8             	mov    %cr3,%eax
   11530:	50                   	push   %eax
   11531:	0f 20 d0             	mov    %cr2,%eax
   11534:	50                   	push   %eax
   11535:	0f 20 c0             	mov    %cr0,%eax
   11538:	50                   	push   %eax
   11539:	e8 9b 2f 00 00       	call   144d9 <common_trap_handler>
   1153e:	83 c4 10             	add    $0x10,%esp
   11541:	61                   	popa   
   11542:	83 c4 0c             	add    $0xc,%esp
   11545:	83 c4 08             	add    $0x8,%esp
   11548:	cf                   	iret   
   11549:	90                   	nop
   1154a:	90                   	nop
   1154b:	90                   	nop

0001154c <kTrap3>:
   1154c:	6a 00                	push   $0x0
   1154e:	6a 03                	push   $0x3
   11550:	ff 74 24 10          	push   0x10(%esp)
   11554:	ff 74 24 10          	push   0x10(%esp)
   11558:	ff 74 24 10          	push   0x10(%esp)
   1155c:	60                   	pusha  
   1155d:	0f 20 e0             	mov    %cr4,%eax
   11560:	50                   	push   %eax
   11561:	0f 20 d8             	mov    %cr3,%eax
   11564:	50                   	push   %eax
   11565:	0f 20 d0             	mov    %cr2,%eax
   11568:	50                   	push   %eax
   11569:	0f 20 c0             	mov    %cr0,%eax
   1156c:	50                   	push   %eax
   1156d:	e8 67 2f 00 00       	call   144d9 <common_trap_handler>
   11572:	83 c4 10             	add    $0x10,%esp
   11575:	61                   	popa   
   11576:	83 c4 0c             	add    $0xc,%esp
   11579:	83 c4 08             	add    $0x8,%esp
   1157c:	cf                   	iret   
   1157d:	90                   	nop
   1157e:	90                   	nop
   1157f:	90                   	nop

00011580 <kTrap4>:
   11580:	6a 00                	push   $0x0
   11582:	6a 04                	push   $0x4
   11584:	ff 74 24 10          	push   0x10(%esp)
   11588:	ff 74 24 10          	push   0x10(%esp)
   1158c:	ff 74 24 10          	push   0x10(%esp)
   11590:	60                   	pusha  
   11591:	0f 20 e0             	mov    %cr4,%eax
   11594:	50                   	push   %eax
   11595:	0f 20 d8             	mov    %cr3,%eax
   11598:	50                   	push   %eax
   11599:	0f 20 d0             	mov    %cr2,%eax
   1159c:	50                   	push   %eax
   1159d:	0f 20 c0             	mov    %cr0,%eax
   115a0:	50                   	push   %eax
   115a1:	e8 33 2f 00 00       	call   144d9 <common_trap_handler>
   115a6:	83 c4 10             	add    $0x10,%esp
   115a9:	61                   	popa   
   115aa:	83 c4 0c             	add    $0xc,%esp
   115ad:	83 c4 08             	add    $0x8,%esp
   115b0:	cf                   	iret   
   115b1:	90                   	nop
   115b2:	90                   	nop
   115b3:	90                   	nop

000115b4 <kTrap5>:
   115b4:	6a 00                	push   $0x0
   115b6:	6a 05                	push   $0x5
   115b8:	ff 74 24 10          	push   0x10(%esp)
   115bc:	ff 74 24 10          	push   0x10(%esp)
   115c0:	ff 74 24 10          	push   0x10(%esp)
   115c4:	60                   	pusha  
   115c5:	0f 20 e0             	mov    %cr4,%eax
   115c8:	50                   	push   %eax
   115c9:	0f 20 d8             	mov    %cr3,%eax
   115cc:	50                   	push   %eax
   115cd:	0f 20 d0             	mov    %cr2,%eax
   115d0:	50                   	push   %eax
   115d1:	0f 20 c0             	mov    %cr0,%eax
   115d4:	50                   	push   %eax
   115d5:	e8 ff 2e 00 00       	call   144d9 <common_trap_handler>
   115da:	83 c4 10             	add    $0x10,%esp
   115dd:	61                   	popa   
   115de:	83 c4 0c             	add    $0xc,%esp
   115e1:	83 c4 08             	add    $0x8,%esp
   115e4:	cf                   	iret   
   115e5:	90                   	nop
   115e6:	90                   	nop
   115e7:	90                   	nop

000115e8 <kTrap6>:
   115e8:	6a 00                	push   $0x0
   115ea:	6a 06                	push   $0x6
   115ec:	ff 74 24 10          	push   0x10(%esp)
   115f0:	ff 74 24 10          	push   0x10(%esp)
   115f4:	ff 74 24 10          	push   0x10(%esp)
   115f8:	60                   	pusha  
   115f9:	0f 20 e0             	mov    %cr4,%eax
   115fc:	50                   	push   %eax
   115fd:	0f 20 d8             	mov    %cr3,%eax
   11600:	50                   	push   %eax
   11601:	0f 20 d0             	mov    %cr2,%eax
   11604:	50                   	push   %eax
   11605:	0f 20 c0             	mov    %cr0,%eax
   11608:	50                   	push   %eax
   11609:	e8 cb 2e 00 00       	call   144d9 <common_trap_handler>
   1160e:	83 c4 10             	add    $0x10,%esp
   11611:	61                   	popa   
   11612:	83 c4 0c             	add    $0xc,%esp
   11615:	83 c4 08             	add    $0x8,%esp
   11618:	cf                   	iret   
   11619:	90                   	nop
   1161a:	90                   	nop
   1161b:	90                   	nop

0001161c <kTrap7>:
   1161c:	6a 00                	push   $0x0
   1161e:	6a 07                	push   $0x7
   11620:	ff 74 24 10          	push   0x10(%esp)
   11624:	ff 74 24 10          	push   0x10(%esp)
   11628:	ff 74 24 10          	push   0x10(%esp)
   1162c:	60                   	pusha  
   1162d:	0f 20 e0             	mov    %cr4,%eax
   11630:	50                   	push   %eax
   11631:	0f 20 d8             	mov    %cr3,%eax
   11634:	50                   	push   %eax
   11635:	0f 20 d0             	mov    %cr2,%eax
   11638:	50                   	push   %eax
   11639:	0f 20 c0             	mov    %cr0,%eax
   1163c:	50                   	push   %eax
   1163d:	e8 97 2e 00 00       	call   144d9 <common_trap_handler>
   11642:	83 c4 10             	add    $0x10,%esp
   11645:	61                   	popa   
   11646:	83 c4 0c             	add    $0xc,%esp
   11649:	83 c4 08             	add    $0x8,%esp
   1164c:	cf                   	iret   
   1164d:	90                   	nop
   1164e:	90                   	nop
   1164f:	90                   	nop

00011650 <kTrap8>:
   11650:	6a 08                	push   $0x8
   11652:	ff 74 24 10          	push   0x10(%esp)
   11656:	ff 74 24 10          	push   0x10(%esp)
   1165a:	ff 74 24 10          	push   0x10(%esp)
   1165e:	60                   	pusha  
   1165f:	0f 20 e0             	mov    %cr4,%eax
   11662:	50                   	push   %eax
   11663:	0f 20 d8             	mov    %cr3,%eax
   11666:	50                   	push   %eax
   11667:	0f 20 d0             	mov    %cr2,%eax
   1166a:	50                   	push   %eax
   1166b:	0f 20 c0             	mov    %cr0,%eax
   1166e:	50                   	push   %eax
   1166f:	e8 65 2e 00 00       	call   144d9 <common_trap_handler>
   11674:	83 c4 10             	add    $0x10,%esp
   11677:	61                   	popa   
   11678:	83 c4 0c             	add    $0xc,%esp
   1167b:	83 c4 08             	add    $0x8,%esp
   1167e:	cf                   	iret   
   1167f:	90                   	nop

00011680 <kTrap9>:
   11680:	6a 00                	push   $0x0
   11682:	6a 09                	push   $0x9
   11684:	ff 74 24 10          	push   0x10(%esp)
   11688:	ff 74 24 10          	push   0x10(%esp)
   1168c:	ff 74 24 10          	push   0x10(%esp)
   11690:	60                   	pusha  
   11691:	0f 20 e0             	mov    %cr4,%eax
   11694:	50                   	push   %eax
   11695:	0f 20 d8             	mov    %cr3,%eax
   11698:	50                   	push   %eax
   11699:	0f 20 d0             	mov    %cr2,%eax
   1169c:	50                   	push   %eax
   1169d:	0f 20 c0             	mov    %cr0,%eax
   116a0:	50                   	push   %eax
   116a1:	e8 33 2e 00 00       	call   144d9 <common_trap_handler>
   116a6:	83 c4 10             	add    $0x10,%esp
   116a9:	61                   	popa   
   116aa:	83 c4 0c             	add    $0xc,%esp
   116ad:	83 c4 08             	add    $0x8,%esp
   116b0:	cf                   	iret   
   116b1:	90                   	nop
   116b2:	90                   	nop
   116b3:	90                   	nop

000116b4 <kTrap10>:
   116b4:	6a 0a                	push   $0xa
   116b6:	ff 74 24 10          	push   0x10(%esp)
   116ba:	ff 74 24 10          	push   0x10(%esp)
   116be:	ff 74 24 10          	push   0x10(%esp)
   116c2:	60                   	pusha  
   116c3:	0f 20 e0             	mov    %cr4,%eax
   116c6:	50                   	push   %eax
   116c7:	0f 20 d8             	mov    %cr3,%eax
   116ca:	50                   	push   %eax
   116cb:	0f 20 d0             	mov    %cr2,%eax
   116ce:	50                   	push   %eax
   116cf:	0f 20 c0             	mov    %cr0,%eax
   116d2:	50                   	push   %eax
   116d3:	e8 01 2e 00 00       	call   144d9 <common_trap_handler>
   116d8:	83 c4 10             	add    $0x10,%esp
   116db:	61                   	popa   
   116dc:	83 c4 0c             	add    $0xc,%esp
   116df:	83 c4 08             	add    $0x8,%esp
   116e2:	cf                   	iret   
   116e3:	90                   	nop

000116e4 <kTrap11>:
   116e4:	6a 0b                	push   $0xb
   116e6:	ff 74 24 10          	push   0x10(%esp)
   116ea:	ff 74 24 10          	push   0x10(%esp)
   116ee:	ff 74 24 10          	push   0x10(%esp)
   116f2:	60                   	pusha  
   116f3:	0f 20 e0             	mov    %cr4,%eax
   116f6:	50                   	push   %eax
   116f7:	0f 20 d8             	mov    %cr3,%eax
   116fa:	50                   	push   %eax
   116fb:	0f 20 d0             	mov    %cr2,%eax
   116fe:	50                   	push   %eax
   116ff:	0f 20 c0             	mov    %cr0,%eax
   11702:	50                   	push   %eax
   11703:	e8 d1 2d 00 00       	call   144d9 <common_trap_handler>
   11708:	83 c4 10             	add    $0x10,%esp
   1170b:	61                   	popa   
   1170c:	83 c4 0c             	add    $0xc,%esp
   1170f:	83 c4 08             	add    $0x8,%esp
   11712:	cf                   	iret   
   11713:	90                   	nop

00011714 <kTrap12>:
   11714:	6a 0c                	push   $0xc
   11716:	ff 74 24 10          	push   0x10(%esp)
   1171a:	ff 74 24 10          	push   0x10(%esp)
   1171e:	ff 74 24 10          	push   0x10(%esp)
   11722:	60                   	pusha  
   11723:	0f 20 e0             	mov    %cr4,%eax
   11726:	50                   	push   %eax
   11727:	0f 20 d8             	mov    %cr3,%eax
   1172a:	50                   	push   %eax
   1172b:	0f 20 d0             	mov    %cr2,%eax
   1172e:	50                   	push   %eax
   1172f:	0f 20 c0             	mov    %cr0,%eax
   11732:	50                   	push   %eax
   11733:	e8 a1 2d 00 00       	call   144d9 <common_trap_handler>
   11738:	83 c4 10             	add    $0x10,%esp
   1173b:	61                   	popa   
   1173c:	83 c4 0c             	add    $0xc,%esp
   1173f:	83 c4 08             	add    $0x8,%esp
   11742:	cf                   	iret   
   11743:	90                   	nop

00011744 <kTrap13>:
   11744:	6a 0d                	push   $0xd
   11746:	ff 74 24 10          	push   0x10(%esp)
   1174a:	ff 74 24 10          	push   0x10(%esp)
   1174e:	ff 74 24 10          	push   0x10(%esp)
   11752:	60                   	pusha  
   11753:	0f 20 e0             	mov    %cr4,%eax
   11756:	50                   	push   %eax
   11757:	0f 20 d8             	mov    %cr3,%eax
   1175a:	50                   	push   %eax
   1175b:	0f 20 d0             	mov    %cr2,%eax
   1175e:	50                   	push   %eax
   1175f:	0f 20 c0             	mov    %cr0,%eax
   11762:	50                   	push   %eax
   11763:	e8 71 2d 00 00       	call   144d9 <common_trap_handler>
   11768:	83 c4 10             	add    $0x10,%esp
   1176b:	61                   	popa   
   1176c:	83 c4 0c             	add    $0xc,%esp
   1176f:	83 c4 08             	add    $0x8,%esp
   11772:	cf                   	iret   
   11773:	90                   	nop

00011774 <kTrap14>:
   11774:	6a 0e                	push   $0xe
   11776:	ff 74 24 10          	push   0x10(%esp)
   1177a:	ff 74 24 10          	push   0x10(%esp)
   1177e:	ff 74 24 10          	push   0x10(%esp)
   11782:	60                   	pusha  
   11783:	0f 20 e0             	mov    %cr4,%eax
   11786:	50                   	push   %eax
   11787:	0f 20 d8             	mov    %cr3,%eax
   1178a:	50                   	push   %eax
   1178b:	0f 20 d0             	mov    %cr2,%eax
   1178e:	50                   	push   %eax
   1178f:	0f 20 c0             	mov    %cr0,%eax
   11792:	50                   	push   %eax
   11793:	e8 41 2d 00 00       	call   144d9 <common_trap_handler>
   11798:	83 c4 10             	add    $0x10,%esp
   1179b:	61                   	popa   
   1179c:	83 c4 0c             	add    $0xc,%esp
   1179f:	83 c4 08             	add    $0x8,%esp
   117a2:	cf                   	iret   
   117a3:	90                   	nop

000117a4 <kTrap16>:
   117a4:	6a 00                	push   $0x0
   117a6:	6a 10                	push   $0x10
   117a8:	ff 74 24 10          	push   0x10(%esp)
   117ac:	ff 74 24 10          	push   0x10(%esp)
   117b0:	ff 74 24 10          	push   0x10(%esp)
   117b4:	60                   	pusha  
   117b5:	0f 20 e0             	mov    %cr4,%eax
   117b8:	50                   	push   %eax
   117b9:	0f 20 d8             	mov    %cr3,%eax
   117bc:	50                   	push   %eax
   117bd:	0f 20 d0             	mov    %cr2,%eax
   117c0:	50                   	push   %eax
   117c1:	0f 20 c0             	mov    %cr0,%eax
   117c4:	50                   	push   %eax
   117c5:	e8 0f 2d 00 00       	call   144d9 <common_trap_handler>
   117ca:	83 c4 10             	add    $0x10,%esp
   117cd:	61                   	popa   
   117ce:	83 c4 0c             	add    $0xc,%esp
   117d1:	83 c4 08             	add    $0x8,%esp
   117d4:	cf                   	iret   
   117d5:	90                   	nop
   117d6:	90                   	nop
   117d7:	90                   	nop

000117d8 <kTrap17>:
   117d8:	6a 11                	push   $0x11
   117da:	ff 74 24 10          	push   0x10(%esp)
   117de:	ff 74 24 10          	push   0x10(%esp)
   117e2:	ff 74 24 10          	push   0x10(%esp)
   117e6:	60                   	pusha  
   117e7:	0f 20 e0             	mov    %cr4,%eax
   117ea:	50                   	push   %eax
   117eb:	0f 20 d8             	mov    %cr3,%eax
   117ee:	50                   	push   %eax
   117ef:	0f 20 d0             	mov    %cr2,%eax
   117f2:	50                   	push   %eax
   117f3:	0f 20 c0             	mov    %cr0,%eax
   117f6:	50                   	push   %eax
   117f7:	e8 dd 2c 00 00       	call   144d9 <common_trap_handler>
   117fc:	83 c4 10             	add    $0x10,%esp
   117ff:	61                   	popa   
   11800:	83 c4 0c             	add    $0xc,%esp
   11803:	83 c4 08             	add    $0x8,%esp
   11806:	cf                   	iret   
   11807:	90                   	nop

00011808 <kTrap18>:
   11808:	6a 00                	push   $0x0
   1180a:	6a 12                	push   $0x12
   1180c:	ff 74 24 10          	push   0x10(%esp)
   11810:	ff 74 24 10          	push   0x10(%esp)
   11814:	ff 74 24 10          	push   0x10(%esp)
   11818:	60                   	pusha  
   11819:	0f 20 e0             	mov    %cr4,%eax
   1181c:	50                   	push   %eax
   1181d:	0f 20 d8             	mov    %cr3,%eax
   11820:	50                   	push   %eax
   11821:	0f 20 d0             	mov    %cr2,%eax
   11824:	50                   	push   %eax
   11825:	0f 20 c0             	mov    %cr0,%eax
   11828:	50                   	push   %eax
   11829:	e8 ab 2c 00 00       	call   144d9 <common_trap_handler>
   1182e:	83 c4 10             	add    $0x10,%esp
   11831:	61                   	popa   
   11832:	83 c4 0c             	add    $0xc,%esp
   11835:	83 c4 08             	add    $0x8,%esp
   11838:	cf                   	iret   
   11839:	90                   	nop
   1183a:	90                   	nop
   1183b:	90                   	nop

0001183c <kTrap19>:
   1183c:	6a 00                	push   $0x0
   1183e:	6a 13                	push   $0x13
   11840:	ff 74 24 10          	push   0x10(%esp)
   11844:	ff 74 24 10          	push   0x10(%esp)
   11848:	ff 74 24 10          	push   0x10(%esp)
   1184c:	60                   	pusha  
   1184d:	0f 20 e0             	mov    %cr4,%eax
   11850:	50                   	push   %eax
   11851:	0f 20 d8             	mov    %cr3,%eax
   11854:	50                   	push   %eax
   11855:	0f 20 d0             	mov    %cr2,%eax
   11858:	50                   	push   %eax
   11859:	0f 20 c0             	mov    %cr0,%eax
   1185c:	50                   	push   %eax
   1185d:	e8 77 2c 00 00       	call   144d9 <common_trap_handler>
   11862:	83 c4 10             	add    $0x10,%esp
   11865:	61                   	popa   
   11866:	83 c4 0c             	add    $0xc,%esp
   11869:	83 c4 08             	add    $0x8,%esp
   1186c:	cf                   	iret   
   1186d:	90                   	nop
   1186e:	90                   	nop
   1186f:	90                   	nop

00011870 <kTrap20>:
   11870:	6a 00                	push   $0x0
   11872:	6a 14                	push   $0x14
   11874:	ff 74 24 10          	push   0x10(%esp)
   11878:	ff 74 24 10          	push   0x10(%esp)
   1187c:	ff 74 24 10          	push   0x10(%esp)
   11880:	60                   	pusha  
   11881:	0f 20 e0             	mov    %cr4,%eax
   11884:	50                   	push   %eax
   11885:	0f 20 d8             	mov    %cr3,%eax
   11888:	50                   	push   %eax
   11889:	0f 20 d0             	mov    %cr2,%eax
   1188c:	50                   	push   %eax
   1188d:	0f 20 c0             	mov    %cr0,%eax
   11890:	50                   	push   %eax
   11891:	e8 43 2c 00 00       	call   144d9 <common_trap_handler>
   11896:	83 c4 10             	add    $0x10,%esp
   11899:	61                   	popa   
   1189a:	83 c4 0c             	add    $0xc,%esp
   1189d:	83 c4 08             	add    $0x8,%esp
   118a0:	cf                   	iret   
   118a1:	90                   	nop
   118a2:	90                   	nop
   118a3:	90                   	nop

000118a4 <kTrap32>:
   118a4:	6a 00                	push   $0x0
   118a6:	6a 20                	push   $0x20
   118a8:	ff 74 24 10          	push   0x10(%esp)
   118ac:	ff 74 24 10          	push   0x10(%esp)
   118b0:	ff 74 24 10          	push   0x10(%esp)
   118b4:	60                   	pusha  
   118b5:	0f 20 e0             	mov    %cr4,%eax
   118b8:	50                   	push   %eax
   118b9:	0f 20 d8             	mov    %cr3,%eax
   118bc:	50                   	push   %eax
   118bd:	0f 20 d0             	mov    %cr2,%eax
   118c0:	50                   	push   %eax
   118c1:	0f 20 c0             	mov    %cr0,%eax
   118c4:	50                   	push   %eax
   118c5:	e8 0f 2c 00 00       	call   144d9 <common_trap_handler>
   118ca:	83 c4 10             	add    $0x10,%esp
   118cd:	61                   	popa   
   118ce:	83 c4 0c             	add    $0xc,%esp
   118d1:	83 c4 08             	add    $0x8,%esp
   118d4:	cf                   	iret   
   118d5:	90                   	nop
   118d6:	90                   	nop
   118d7:	90                   	nop

000118d8 <kTrap33>:
   118d8:	6a 00                	push   $0x0
   118da:	6a 21                	push   $0x21
   118dc:	ff 74 24 10          	push   0x10(%esp)
   118e0:	ff 74 24 10          	push   0x10(%esp)
   118e4:	ff 74 24 10          	push   0x10(%esp)
   118e8:	60                   	pusha  
   118e9:	0f 20 e0             	mov    %cr4,%eax
   118ec:	50                   	push   %eax
   118ed:	0f 20 d8             	mov    %cr3,%eax
   118f0:	50                   	push   %eax
   118f1:	0f 20 d0             	mov    %cr2,%eax
   118f4:	50                   	push   %eax
   118f5:	0f 20 c0             	mov    %cr0,%eax
   118f8:	50                   	push   %eax
   118f9:	e8 db 2b 00 00       	call   144d9 <common_trap_handler>
   118fe:	83 c4 10             	add    $0x10,%esp
   11901:	61                   	popa   
   11902:	83 c4 0c             	add    $0xc,%esp
   11905:	83 c4 08             	add    $0x8,%esp
   11908:	cf                   	iret   
   11909:	90                   	nop
   1190a:	90                   	nop
   1190b:	90                   	nop

0001190c <kTrap35>:
   1190c:	6a 00                	push   $0x0
   1190e:	6a 23                	push   $0x23
   11910:	ff 74 24 10          	push   0x10(%esp)
   11914:	ff 74 24 10          	push   0x10(%esp)
   11918:	ff 74 24 10          	push   0x10(%esp)
   1191c:	60                   	pusha  
   1191d:	0f 20 e0             	mov    %cr4,%eax
   11920:	50                   	push   %eax
   11921:	0f 20 d8             	mov    %cr3,%eax
   11924:	50                   	push   %eax
   11925:	0f 20 d0             	mov    %cr2,%eax
   11928:	50                   	push   %eax
   11929:	0f 20 c0             	mov    %cr0,%eax
   1192c:	50                   	push   %eax
   1192d:	e8 a7 2b 00 00       	call   144d9 <common_trap_handler>
   11932:	83 c4 10             	add    $0x10,%esp
   11935:	61                   	popa   
   11936:	83 c4 0c             	add    $0xc,%esp
   11939:	83 c4 08             	add    $0x8,%esp
   1193c:	cf                   	iret   
   1193d:	90                   	nop
   1193e:	90                   	nop
   1193f:	90                   	nop

00011940 <kTrap36>:
   11940:	6a 00                	push   $0x0
   11942:	6a 24                	push   $0x24
   11944:	ff 74 24 10          	push   0x10(%esp)
   11948:	ff 74 24 10          	push   0x10(%esp)
   1194c:	ff 74 24 10          	push   0x10(%esp)
   11950:	60                   	pusha  
   11951:	0f 20 e0             	mov    %cr4,%eax
   11954:	50                   	push   %eax
   11955:	0f 20 d8             	mov    %cr3,%eax
   11958:	50                   	push   %eax
   11959:	0f 20 d0             	mov    %cr2,%eax
   1195c:	50                   	push   %eax
   1195d:	0f 20 c0             	mov    %cr0,%eax
   11960:	50                   	push   %eax
   11961:	e8 73 2b 00 00       	call   144d9 <common_trap_handler>
   11966:	83 c4 10             	add    $0x10,%esp
   11969:	61                   	popa   
   1196a:	83 c4 0c             	add    $0xc,%esp
   1196d:	83 c4 08             	add    $0x8,%esp
   11970:	cf                   	iret   
   11971:	90                   	nop
   11972:	90                   	nop
   11973:	90                   	nop

00011974 <kTrap37>:
   11974:	6a 00                	push   $0x0
   11976:	6a 25                	push   $0x25
   11978:	ff 74 24 10          	push   0x10(%esp)
   1197c:	ff 74 24 10          	push   0x10(%esp)
   11980:	ff 74 24 10          	push   0x10(%esp)
   11984:	60                   	pusha  
   11985:	0f 20 e0             	mov    %cr4,%eax
   11988:	50                   	push   %eax
   11989:	0f 20 d8             	mov    %cr3,%eax
   1198c:	50                   	push   %eax
   1198d:	0f 20 d0             	mov    %cr2,%eax
   11990:	50                   	push   %eax
   11991:	0f 20 c0             	mov    %cr0,%eax
   11994:	50                   	push   %eax
   11995:	e8 3f 2b 00 00       	call   144d9 <common_trap_handler>
   1199a:	83 c4 10             	add    $0x10,%esp
   1199d:	61                   	popa   
   1199e:	83 c4 0c             	add    $0xc,%esp
   119a1:	83 c4 08             	add    $0x8,%esp
   119a4:	cf                   	iret   
   119a5:	90                   	nop
   119a6:	90                   	nop
   119a7:	90                   	nop

000119a8 <kTrap38>:
   119a8:	6a 00                	push   $0x0
   119aa:	6a 26                	push   $0x26
   119ac:	ff 74 24 10          	push   0x10(%esp)
   119b0:	ff 74 24 10          	push   0x10(%esp)
   119b4:	ff 74 24 10          	push   0x10(%esp)
   119b8:	60                   	pusha  
   119b9:	0f 20 e0             	mov    %cr4,%eax
   119bc:	50                   	push   %eax
   119bd:	0f 20 d8             	mov    %cr3,%eax
   119c0:	50                   	push   %eax
   119c1:	0f 20 d0             	mov    %cr2,%eax
   119c4:	50                   	push   %eax
   119c5:	0f 20 c0             	mov    %cr0,%eax
   119c8:	50                   	push   %eax
   119c9:	e8 0b 2b 00 00       	call   144d9 <common_trap_handler>
   119ce:	83 c4 10             	add    $0x10,%esp
   119d1:	61                   	popa   
   119d2:	83 c4 0c             	add    $0xc,%esp
   119d5:	83 c4 08             	add    $0x8,%esp
   119d8:	cf                   	iret   
   119d9:	90                   	nop
   119da:	90                   	nop
   119db:	90                   	nop

000119dc <kTrap39>:
   119dc:	6a 00                	push   $0x0
   119de:	6a 27                	push   $0x27
   119e0:	ff 74 24 10          	push   0x10(%esp)
   119e4:	ff 74 24 10          	push   0x10(%esp)
   119e8:	ff 74 24 10          	push   0x10(%esp)
   119ec:	60                   	pusha  
   119ed:	0f 20 e0             	mov    %cr4,%eax
   119f0:	50                   	push   %eax
   119f1:	0f 20 d8             	mov    %cr3,%eax
   119f4:	50                   	push   %eax
   119f5:	0f 20 d0             	mov    %cr2,%eax
   119f8:	50                   	push   %eax
   119f9:	0f 20 c0             	mov    %cr0,%eax
   119fc:	50                   	push   %eax
   119fd:	e8 d7 2a 00 00       	call   144d9 <common_trap_handler>
   11a02:	83 c4 10             	add    $0x10,%esp
   11a05:	61                   	popa   
   11a06:	83 c4 0c             	add    $0xc,%esp
   11a09:	83 c4 08             	add    $0x8,%esp
   11a0c:	cf                   	iret   
   11a0d:	90                   	nop
   11a0e:	90                   	nop
   11a0f:	90                   	nop

00011a10 <kTrap40>:
   11a10:	6a 00                	push   $0x0
   11a12:	6a 28                	push   $0x28
   11a14:	ff 74 24 10          	push   0x10(%esp)
   11a18:	ff 74 24 10          	push   0x10(%esp)
   11a1c:	ff 74 24 10          	push   0x10(%esp)
   11a20:	60                   	pusha  
   11a21:	0f 20 e0             	mov    %cr4,%eax
   11a24:	50                   	push   %eax
   11a25:	0f 20 d8             	mov    %cr3,%eax
   11a28:	50                   	push   %eax
   11a29:	0f 20 d0             	mov    %cr2,%eax
   11a2c:	50                   	push   %eax
   11a2d:	0f 20 c0             	mov    %cr0,%eax
   11a30:	50                   	push   %eax
   11a31:	e8 a3 2a 00 00       	call   144d9 <common_trap_handler>
   11a36:	83 c4 10             	add    $0x10,%esp
   11a39:	61                   	popa   
   11a3a:	83 c4 0c             	add    $0xc,%esp
   11a3d:	83 c4 08             	add    $0x8,%esp
   11a40:	cf                   	iret   
   11a41:	90                   	nop
   11a42:	90                   	nop
   11a43:	90                   	nop

00011a44 <kTrap41>:
   11a44:	6a 00                	push   $0x0
   11a46:	6a 29                	push   $0x29
   11a48:	ff 74 24 10          	push   0x10(%esp)
   11a4c:	ff 74 24 10          	push   0x10(%esp)
   11a50:	ff 74 24 10          	push   0x10(%esp)
   11a54:	60                   	pusha  
   11a55:	0f 20 e0             	mov    %cr4,%eax
   11a58:	50                   	push   %eax
   11a59:	0f 20 d8             	mov    %cr3,%eax
   11a5c:	50                   	push   %eax
   11a5d:	0f 20 d0             	mov    %cr2,%eax
   11a60:	50                   	push   %eax
   11a61:	0f 20 c0             	mov    %cr0,%eax
   11a64:	50                   	push   %eax
   11a65:	e8 6f 2a 00 00       	call   144d9 <common_trap_handler>
   11a6a:	83 c4 10             	add    $0x10,%esp
   11a6d:	61                   	popa   
   11a6e:	83 c4 0c             	add    $0xc,%esp
   11a71:	83 c4 08             	add    $0x8,%esp
   11a74:	cf                   	iret   
   11a75:	90                   	nop
   11a76:	90                   	nop
   11a77:	90                   	nop

00011a78 <kTrap42>:
   11a78:	6a 00                	push   $0x0
   11a7a:	6a 2a                	push   $0x2a
   11a7c:	ff 74 24 10          	push   0x10(%esp)
   11a80:	ff 74 24 10          	push   0x10(%esp)
   11a84:	ff 74 24 10          	push   0x10(%esp)
   11a88:	60                   	pusha  
   11a89:	0f 20 e0             	mov    %cr4,%eax
   11a8c:	50                   	push   %eax
   11a8d:	0f 20 d8             	mov    %cr3,%eax
   11a90:	50                   	push   %eax
   11a91:	0f 20 d0             	mov    %cr2,%eax
   11a94:	50                   	push   %eax
   11a95:	0f 20 c0             	mov    %cr0,%eax
   11a98:	50                   	push   %eax
   11a99:	e8 3b 2a 00 00       	call   144d9 <common_trap_handler>
   11a9e:	83 c4 10             	add    $0x10,%esp
   11aa1:	61                   	popa   
   11aa2:	83 c4 0c             	add    $0xc,%esp
   11aa5:	83 c4 08             	add    $0x8,%esp
   11aa8:	cf                   	iret   
   11aa9:	90                   	nop
   11aaa:	90                   	nop
   11aab:	90                   	nop

00011aac <kTrap43>:
   11aac:	6a 00                	push   $0x0
   11aae:	6a 2b                	push   $0x2b
   11ab0:	ff 74 24 10          	push   0x10(%esp)
   11ab4:	ff 74 24 10          	push   0x10(%esp)
   11ab8:	ff 74 24 10          	push   0x10(%esp)
   11abc:	60                   	pusha  
   11abd:	0f 20 e0             	mov    %cr4,%eax
   11ac0:	50                   	push   %eax
   11ac1:	0f 20 d8             	mov    %cr3,%eax
   11ac4:	50                   	push   %eax
   11ac5:	0f 20 d0             	mov    %cr2,%eax
   11ac8:	50                   	push   %eax
   11ac9:	0f 20 c0             	mov    %cr0,%eax
   11acc:	50                   	push   %eax
   11acd:	e8 07 2a 00 00       	call   144d9 <common_trap_handler>
   11ad2:	83 c4 10             	add    $0x10,%esp
   11ad5:	61                   	popa   
   11ad6:	83 c4 0c             	add    $0xc,%esp
   11ad9:	83 c4 08             	add    $0x8,%esp
   11adc:	cf                   	iret   
   11add:	90                   	nop
   11ade:	90                   	nop
   11adf:	90                   	nop

00011ae0 <kTrap44>:
   11ae0:	6a 00                	push   $0x0
   11ae2:	6a 2c                	push   $0x2c
   11ae4:	ff 74 24 10          	push   0x10(%esp)
   11ae8:	ff 74 24 10          	push   0x10(%esp)
   11aec:	ff 74 24 10          	push   0x10(%esp)
   11af0:	60                   	pusha  
   11af1:	0f 20 e0             	mov    %cr4,%eax
   11af4:	50                   	push   %eax
   11af5:	0f 20 d8             	mov    %cr3,%eax
   11af8:	50                   	push   %eax
   11af9:	0f 20 d0             	mov    %cr2,%eax
   11afc:	50                   	push   %eax
   11afd:	0f 20 c0             	mov    %cr0,%eax
   11b00:	50                   	push   %eax
   11b01:	e8 d3 29 00 00       	call   144d9 <common_trap_handler>
   11b06:	83 c4 10             	add    $0x10,%esp
   11b09:	61                   	popa   
   11b0a:	83 c4 0c             	add    $0xc,%esp
   11b0d:	83 c4 08             	add    $0x8,%esp
   11b10:	cf                   	iret   
   11b11:	90                   	nop
   11b12:	90                   	nop
   11b13:	90                   	nop

00011b14 <kTrap45>:
   11b14:	6a 00                	push   $0x0
   11b16:	6a 2d                	push   $0x2d
   11b18:	ff 74 24 10          	push   0x10(%esp)
   11b1c:	ff 74 24 10          	push   0x10(%esp)
   11b20:	ff 74 24 10          	push   0x10(%esp)
   11b24:	60                   	pusha  
   11b25:	0f 20 e0             	mov    %cr4,%eax
   11b28:	50                   	push   %eax
   11b29:	0f 20 d8             	mov    %cr3,%eax
   11b2c:	50                   	push   %eax
   11b2d:	0f 20 d0             	mov    %cr2,%eax
   11b30:	50                   	push   %eax
   11b31:	0f 20 c0             	mov    %cr0,%eax
   11b34:	50                   	push   %eax
   11b35:	e8 9f 29 00 00       	call   144d9 <common_trap_handler>
   11b3a:	83 c4 10             	add    $0x10,%esp
   11b3d:	61                   	popa   
   11b3e:	83 c4 0c             	add    $0xc,%esp
   11b41:	83 c4 08             	add    $0x8,%esp
   11b44:	cf                   	iret   
   11b45:	90                   	nop
   11b46:	90                   	nop
   11b47:	90                   	nop

00011b48 <kTrap46>:
   11b48:	6a 00                	push   $0x0
   11b4a:	6a 2e                	push   $0x2e
   11b4c:	ff 74 24 10          	push   0x10(%esp)
   11b50:	ff 74 24 10          	push   0x10(%esp)
   11b54:	ff 74 24 10          	push   0x10(%esp)
   11b58:	60                   	pusha  
   11b59:	0f 20 e0             	mov    %cr4,%eax
   11b5c:	50                   	push   %eax
   11b5d:	0f 20 d8             	mov    %cr3,%eax
   11b60:	50                   	push   %eax
   11b61:	0f 20 d0             	mov    %cr2,%eax
   11b64:	50                   	push   %eax
   11b65:	0f 20 c0             	mov    %cr0,%eax
   11b68:	50                   	push   %eax
   11b69:	e8 6b 29 00 00       	call   144d9 <common_trap_handler>
   11b6e:	83 c4 10             	add    $0x10,%esp
   11b71:	61                   	popa   
   11b72:	83 c4 0c             	add    $0xc,%esp
   11b75:	83 c4 08             	add    $0x8,%esp
   11b78:	cf                   	iret   
   11b79:	90                   	nop
   11b7a:	90                   	nop
   11b7b:	90                   	nop

00011b7c <kTrap47>:
   11b7c:	6a 00                	push   $0x0
   11b7e:	6a 2f                	push   $0x2f
   11b80:	ff 74 24 10          	push   0x10(%esp)
   11b84:	ff 74 24 10          	push   0x10(%esp)
   11b88:	ff 74 24 10          	push   0x10(%esp)
   11b8c:	60                   	pusha  
   11b8d:	0f 20 e0             	mov    %cr4,%eax
   11b90:	50                   	push   %eax
   11b91:	0f 20 d8             	mov    %cr3,%eax
   11b94:	50                   	push   %eax
   11b95:	0f 20 d0             	mov    %cr2,%eax
   11b98:	50                   	push   %eax
   11b99:	0f 20 c0             	mov    %cr0,%eax
   11b9c:	50                   	push   %eax
   11b9d:	e8 37 29 00 00       	call   144d9 <common_trap_handler>
   11ba2:	83 c4 10             	add    $0x10,%esp
   11ba5:	61                   	popa   
   11ba6:	83 c4 0c             	add    $0xc,%esp
   11ba9:	83 c4 08             	add    $0x8,%esp
   11bac:	cf                   	iret   
   11bad:	90                   	nop
   11bae:	90                   	nop
   11baf:	90                   	nop

00011bb0 <kTrapReserved>:
   11bb0:	6a 00                	push   $0x0
   11bb2:	6a 0f                	push   $0xf
   11bb4:	ff 74 24 10          	push   0x10(%esp)
   11bb8:	ff 74 24 10          	push   0x10(%esp)
   11bbc:	ff 74 24 10          	push   0x10(%esp)
   11bc0:	60                   	pusha  
   11bc1:	0f 20 e0             	mov    %cr4,%eax
   11bc4:	50                   	push   %eax
   11bc5:	0f 20 d8             	mov    %cr3,%eax
   11bc8:	50                   	push   %eax
   11bc9:	0f 20 d0             	mov    %cr2,%eax
   11bcc:	50                   	push   %eax
   11bcd:	0f 20 c0             	mov    %cr0,%eax
   11bd0:	50                   	push   %eax
   11bd1:	e8 03 29 00 00       	call   144d9 <common_trap_handler>
   11bd6:	83 c4 10             	add    $0x10,%esp
   11bd9:	61                   	popa   
   11bda:	83 c4 0c             	add    $0xc,%esp
   11bdd:	83 c4 08             	add    $0x8,%esp
   11be0:	cf                   	iret   

00011be1 <ps2_write>:
        ps2_write(PS2_CMD_ENABLE_1, true, true);
    }
}

bool ps2_write(u8 data, bool cmd, bool wait_infinite)
{
   11be1:	55                   	push   %ebp
   11be2:	89 e5                	mov    %esp,%ebp
   11be4:	57                   	push   %edi
   11be5:	56                   	push   %esi
   11be6:	53                   	push   %ebx
   11be7:	83 ec 1c             	sub    $0x1c,%esp
   11bea:	8b 7d 08             	mov    0x8(%ebp),%edi
   11bed:	8a 5d 10             	mov    0x10(%ebp),%bl
    u16 port = cmd ? PS2_PORT_CMD : PS2_PORT_DATA;
   11bf0:	ba 64 00 00 00       	mov    $0x64,%edx
   11bf5:	80 7d 0c 00          	cmpb   $0x0,0xc(%ebp)
   11bf9:	75 05                	jne    11c00 <ps2_write+0x1f>
   11bfb:	ba 60 00 00 00       	mov    $0x60,%edx
    while (port_read_byte(PS2_PORT_STATUS) & PS2_STATUS_IN_FULL && times--)
   11c00:	be 33 00 00 00       	mov    $0x33,%esi
}

inline static u8 port_read_byte(u16 port)
{
    u8 data;
    __asm__ volatile("inb %1, %0"
   11c05:	e4 64                	in     $0x64,%al
   11c07:	a8 02                	test   $0x2,%al
   11c09:	74 18                	je     11c23 <ps2_write+0x42>
   11c0b:	4e                   	dec    %esi
   11c0c:	74 15                	je     11c23 <ps2_write+0x42>
   11c0e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        delay_ms(10);
   11c11:	83 ec 0c             	sub    $0xc,%esp
   11c14:	6a 0a                	push   $0xa
   11c16:	e8 7a 32 00 00       	call   14e95 <delay_ms>
   11c1b:	83 c4 10             	add    $0x10,%esp
   11c1e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
   11c21:	eb e2                	jmp    11c05 <ps2_write+0x24>
   11c23:	e4 64                	in     $0x64,%al
    bool ret;
    do
    {
        ret = wait_for_write();
    } while (!ret && wait_infinite);
   11c25:	a8 02                	test   $0x2,%al
   11c27:	74 06                	je     11c2f <ps2_write+0x4e>
   11c29:	84 db                	test   %bl,%bl
   11c2b:	75 d3                	jne    11c00 <ps2_write+0x1f>
   11c2d:	eb 05                	jmp    11c34 <ps2_write+0x53>
    __asm__ volatile("outb %0, %1"
   11c2f:	89 f8                	mov    %edi,%eax
   11c31:	ee                   	out    %al,(%dx)
        ret = wait_for_write();
   11c32:	b3 01                	mov    $0x1,%bl
    if (ret)
    {
        port_write_byte(port, data);
    }
    return ret;
}
   11c34:	88 d8                	mov    %bl,%al
   11c36:	8d 65 f4             	lea    -0xc(%ebp),%esp
   11c39:	5b                   	pop    %ebx
   11c3a:	5e                   	pop    %esi
   11c3b:	5f                   	pop    %edi
   11c3c:	5d                   	pop    %ebp
   11c3d:	c3                   	ret    

00011c3e <ps2_read>:

bool ps2_read(u8 *data, bool wait_infinite)
{
   11c3e:	55                   	push   %ebp
   11c3f:	89 e5                	mov    %esp,%ebp
   11c41:	57                   	push   %edi
   11c42:	56                   	push   %esi
   11c43:	53                   	push   %ebx
   11c44:	83 ec 0c             	sub    $0xc,%esp
   11c47:	8b 7d 08             	mov    0x8(%ebp),%edi
   11c4a:	8a 5d 0c             	mov    0xc(%ebp),%bl
    while ((port_read_byte(PS2_PORT_STATUS) & PS2_SATTUS_OUT_FULL) == 0 && times--)
   11c4d:	be 33 00 00 00       	mov    $0x33,%esi
    __asm__ volatile("inb %1, %0"
   11c52:	e4 64                	in     $0x64,%al
   11c54:	a8 01                	test   $0x1,%al
   11c56:	75 12                	jne    11c6a <ps2_read+0x2c>
   11c58:	4e                   	dec    %esi
   11c59:	74 0f                	je     11c6a <ps2_read+0x2c>
        delay_ms(10);
   11c5b:	83 ec 0c             	sub    $0xc,%esp
   11c5e:	6a 0a                	push   $0xa
   11c60:	e8 30 32 00 00       	call   14e95 <delay_ms>
   11c65:	83 c4 10             	add    $0x10,%esp
   11c68:	eb e8                	jmp    11c52 <ps2_read+0x14>
   11c6a:	e4 64                	in     $0x64,%al
    bool ret;
    do
    {
        ret = wait_for_read();
    } while (!ret && wait_infinite);
   11c6c:	24 01                	and    $0x1,%al
   11c6e:	88 c2                	mov    %al,%dl
   11c70:	75 06                	jne    11c78 <ps2_read+0x3a>
   11c72:	84 db                	test   %bl,%bl
   11c74:	75 d7                	jne    11c4d <ps2_read+0xf>
   11c76:	eb 08                	jmp    11c80 <ps2_read+0x42>
   11c78:	e4 60                	in     $0x60,%al

    if (ret)
    {
        u8 tmp = port_read_byte(PS2_PORT_DATA);
        if (data)
   11c7a:	85 ff                	test   %edi,%edi
   11c7c:	74 02                	je     11c80 <ps2_read+0x42>
            *data = tmp;
   11c7e:	88 07                	mov    %al,(%edi)
    }
    return ret;
}
   11c80:	88 d0                	mov    %dl,%al
   11c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
   11c85:	5b                   	pop    %ebx
   11c86:	5e                   	pop    %esi
   11c87:	5f                   	pop    %edi
   11c88:	5d                   	pop    %ebp
   11c89:	c3                   	ret    

00011c8a <ps2_setup>:
{
   11c8a:	55                   	push   %ebp
   11c8b:	89 e5                	mov    %esp,%ebp
   11c8d:	56                   	push   %esi
   11c8e:	53                   	push   %ebx
   11c8f:	83 ec 14             	sub    $0x14,%esp
    ps2_write(PS2_CMD_DISABLE_1, true, true);
   11c92:	6a 01                	push   $0x1
   11c94:	6a 01                	push   $0x1
   11c96:	68 ad 00 00 00       	push   $0xad
   11c9b:	e8 41 ff ff ff       	call   11be1 <ps2_write>
    ps2_write(PS2_CMD_DISABLE_2, true, true);
   11ca0:	83 c4 0c             	add    $0xc,%esp
   11ca3:	6a 01                	push   $0x1
   11ca5:	6a 01                	push   $0x1
   11ca7:	68 a7 00 00 00       	push   $0xa7
   11cac:	e8 30 ff ff ff       	call   11be1 <ps2_write>
    while (ps2_read(NULL, false))
   11cb1:	83 c4 10             	add    $0x10,%esp
   11cb4:	51                   	push   %ecx
   11cb5:	51                   	push   %ecx
   11cb6:	6a 00                	push   $0x0
   11cb8:	6a 00                	push   $0x0
   11cba:	e8 7f ff ff ff       	call   11c3e <ps2_read>
   11cbf:	83 c4 10             	add    $0x10,%esp
   11cc2:	84 c0                	test   %al,%al
   11cc4:	75 ee                	jne    11cb4 <ps2_setup+0x2a>
    ps2_write(PS2_CMD_READ_CONF, true, true);
   11cc6:	53                   	push   %ebx
   11cc7:	6a 01                	push   $0x1
   11cc9:	6a 01                	push   $0x1
   11ccb:	6a 20                	push   $0x20
   11ccd:	e8 0f ff ff ff       	call   11be1 <ps2_write>
    ps2_read(&conf, true);
   11cd2:	5e                   	pop    %esi
   11cd3:	58                   	pop    %eax
   11cd4:	6a 01                	push   $0x1
   11cd6:	8d 5d f6             	lea    -0xa(%ebp),%ebx
   11cd9:	53                   	push   %ebx
   11cda:	e8 5f ff ff ff       	call   11c3e <ps2_read>
    conf &= ~(PS2_CONF_INTR1 | PS2_CONF_INTR2 | PS2_CONF_TRANSLATION);
   11cdf:	80 65 f6 bc          	andb   $0xbc,-0xa(%ebp)
    ps2_write(PS2_CMD_WRITE_CONF, true, true);
   11ce3:	83 c4 0c             	add    $0xc,%esp
   11ce6:	6a 01                	push   $0x1
   11ce8:	6a 01                	push   $0x1
   11cea:	6a 60                	push   $0x60
   11cec:	e8 f0 fe ff ff       	call   11be1 <ps2_write>
    ps2_write(conf, false, true);
   11cf1:	83 c4 0c             	add    $0xc,%esp
   11cf4:	6a 01                	push   $0x1
   11cf6:	6a 00                	push   $0x0
   11cf8:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
   11cfc:	50                   	push   %eax
   11cfd:	e8 df fe ff ff       	call   11be1 <ps2_write>
    ps2_write(PS2_CMD_TEST_PS2, true, true);
   11d02:	83 c4 0c             	add    $0xc,%esp
   11d05:	6a 01                	push   $0x1
   11d07:	6a 01                	push   $0x1
   11d09:	68 aa 00 00 00       	push   $0xaa
   11d0e:	e8 ce fe ff ff       	call   11be1 <ps2_write>
    ps2_read(&result, true);
   11d13:	58                   	pop    %eax
   11d14:	5a                   	pop    %edx
   11d15:	6a 01                	push   $0x1
   11d17:	8d 75 f7             	lea    -0x9(%ebp),%esi
   11d1a:	56                   	push   %esi
   11d1b:	e8 1e ff ff ff       	call   11c3e <ps2_read>
    if (result != 0x55)
   11d20:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
   11d24:	83 c4 10             	add    $0x10,%esp
   11d27:	3c 55                	cmp    $0x55,%al
   11d29:	74 0a                	je     11d35 <ps2_setup+0xab>
        printf("PS/2 Controller Self Test Failed: 0x%x\n", result);
   11d2b:	51                   	push   %ecx
   11d2c:	51                   	push   %ecx
   11d2d:	50                   	push   %eax
   11d2e:	68 60 80 01 00       	push   $0x18060
   11d33:	eb 3f                	jmp    11d74 <ps2_setup+0xea>
    ps2_write(PS2_CMD_TEST_1, true, true);
   11d35:	50                   	push   %eax
   11d36:	6a 01                	push   $0x1
   11d38:	6a 01                	push   $0x1
   11d3a:	68 ab 00 00 00       	push   $0xab
   11d3f:	e8 9d fe ff ff       	call   11be1 <ps2_write>
    ps2_read(&result, true);
   11d44:	58                   	pop    %eax
   11d45:	5a                   	pop    %edx
   11d46:	6a 01                	push   $0x1
   11d48:	56                   	push   %esi
   11d49:	e8 f0 fe ff ff       	call   11c3e <ps2_read>
    if (result)
   11d4e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
   11d52:	83 c4 10             	add    $0x10,%esp
   11d55:	84 c0                	test   %al,%al
   11d57:	74 0a                	je     11d63 <ps2_setup+0xd9>
        printf("First PS/2 Port Test Failed: 0x%x\n", result);
   11d59:	53                   	push   %ebx
   11d5a:	53                   	push   %ebx
   11d5b:	50                   	push   %eax
   11d5c:	68 88 80 01 00       	push   $0x18088
   11d61:	eb 11                	jmp    11d74 <ps2_setup+0xea>
    if (!kbd_setup())
   11d63:	e8 d0 2d 00 00       	call   14b38 <kbd_setup>
   11d68:	84 c0                	test   %al,%al
   11d6a:	75 0f                	jne    11d7b <ps2_setup+0xf1>
        printf("Keyboard Initial Failed!\n");
   11d6c:	83 ec 0c             	sub    $0xc,%esp
   11d6f:	68 ab 80 01 00       	push   $0x180ab
   11d74:	e8 81 11 00 00       	call   12efa <printf>
   11d79:	eb 52                	jmp    11dcd <ps2_setup+0x143>
        ps2_write(PS2_CMD_READ_CONF, true, true);
   11d7b:	50                   	push   %eax
   11d7c:	6a 01                	push   $0x1
   11d7e:	6a 01                	push   $0x1
   11d80:	6a 20                	push   $0x20
   11d82:	e8 5a fe ff ff       	call   11be1 <ps2_write>
        ps2_read(&conf, true);
   11d87:	5a                   	pop    %edx
   11d88:	59                   	pop    %ecx
   11d89:	6a 01                	push   $0x1
   11d8b:	53                   	push   %ebx
   11d8c:	e8 ad fe ff ff       	call   11c3e <ps2_read>
        conf &= ~(PS2_CONF_TRANSLATION | PS2_CONF_INTR2);
   11d91:	8a 45 f6             	mov    -0xa(%ebp),%al
   11d94:	83 e0 bd             	and    $0xffffffbd,%eax
        conf |= PS2_CONF_INTR1;
   11d97:	83 c8 01             	or     $0x1,%eax
   11d9a:	88 45 f6             	mov    %al,-0xa(%ebp)
        ps2_write(PS2_CMD_WRITE_CONF, true, true);
   11d9d:	83 c4 0c             	add    $0xc,%esp
   11da0:	6a 01                	push   $0x1
   11da2:	6a 01                	push   $0x1
   11da4:	6a 60                	push   $0x60
   11da6:	e8 36 fe ff ff       	call   11be1 <ps2_write>
        ps2_write(conf, false, true);
   11dab:	83 c4 0c             	add    $0xc,%esp
   11dae:	6a 01                	push   $0x1
   11db0:	6a 00                	push   $0x0
   11db2:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
   11db6:	50                   	push   %eax
   11db7:	e8 25 fe ff ff       	call   11be1 <ps2_write>
        ps2_write(PS2_CMD_ENABLE_1, true, true);
   11dbc:	83 c4 0c             	add    $0xc,%esp
   11dbf:	6a 01                	push   $0x1
   11dc1:	6a 01                	push   $0x1
   11dc3:	68 ae 00 00 00       	push   $0xae
   11dc8:	e8 14 fe ff ff       	call   11be1 <ps2_write>
   11dcd:	83 c4 10             	add    $0x10,%esp
}
   11dd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
   11dd3:	5b                   	pop    %ebx
   11dd4:	5e                   	pop    %esi
   11dd5:	5d                   	pop    %ebp
   11dd6:	c3                   	ret    

00011dd7 <apm_setup>:
static u16 _version;

extern u32 apm_entry_call(u32 seg, u32 entrypoint, u32 func, u32 devid, u32 pstate);

void apm_setup(const struct apm_configuration *info)
{
   11dd7:	55                   	push   %ebp
   11dd8:	89 e5                	mov    %esp,%ebp
   11dda:	56                   	push   %esi
   11ddb:	53                   	push   %ebx
   11ddc:	83 ec 10             	sub    $0x10,%esp
   11ddf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(info->ok) {
   11de2:	80 7b 19 00          	cmpb   $0x0,0x19(%ebx)
   11de6:	74 6f                	je     11e57 <apm_setup+0x80>
        struct gdt_entry entry;
        // gdt_get_entry(APM_CS16, &entry);
        entry.base = info->cs16_base;
   11de8:	8b 43 09             	mov    0x9(%ebx),%eax
   11deb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        entry.limit = info->cs16_size;
   11dee:	0f b7 43 0d          	movzwl 0xd(%ebx),%eax
   11df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
        entry.attr = SEG_CODE_XR | SEG_PRESENT | SEG_DPL_KERNEL;
   11df5:	c7 45 f4 9a 00 00 00 	movl   $0x9a,-0xc(%ebp)
        gdt_set_entry(APM_CS16, &entry);
   11dfc:	50                   	push   %eax
   11dfd:	50                   	push   %eax
   11dfe:	8d 75 ec             	lea    -0x14(%ebp),%esi
   11e01:	56                   	push   %esi
   11e02:	6a 04                	push   $0x4
   11e04:	e8 fb 1b 00 00       	call   13a04 <gdt_set_entry>

        entry.base = info->cs32_base;
   11e09:	8b 43 03             	mov    0x3(%ebx),%eax
   11e0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        entry.limit = info->cs32_size;
   11e0f:	0f b7 43 07          	movzwl 0x7(%ebx),%eax
   11e13:	89 45 f0             	mov    %eax,-0x10(%ebp)
        entry.attr = SEG_CODE_XR | SEG_PRESENT | SEG_DPL_KERNEL | SEG_32BITS;
   11e16:	c7 45 f4 9a 04 00 00 	movl   $0x49a,-0xc(%ebp)
        gdt_set_entry(APM_CS32, &entry);
   11e1d:	5a                   	pop    %edx
   11e1e:	59                   	pop    %ecx
   11e1f:	56                   	push   %esi
   11e20:	6a 03                	push   $0x3
   11e22:	e8 dd 1b 00 00       	call   13a04 <gdt_set_entry>

        entry.base = info->ds_base;
   11e27:	8b 43 0f             	mov    0xf(%ebx),%eax
   11e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        entry.limit = info->ds_size;
   11e2d:	0f b7 43 13          	movzwl 0x13(%ebx),%eax
   11e31:	89 45 f0             	mov    %eax,-0x10(%ebp)
        entry.attr = SEG_DATA_RW | SEG_PRESENT | SEG_DPL_KERNEL | SEG_32BITS;
   11e34:	c7 45 f4 92 04 00 00 	movl   $0x492,-0xc(%ebp)
        gdt_set_entry(APM_DS, &entry);
   11e3b:	58                   	pop    %eax
   11e3c:	5a                   	pop    %edx
   11e3d:	56                   	push   %esi
   11e3e:	6a 05                	push   $0x5
   11e40:	e8 bf 1b 00 00       	call   13a04 <gdt_set_entry>

        _entrypoint = info->entry_point;
   11e45:	8b 43 15             	mov    0x15(%ebx),%eax
   11e48:	a3 60 aa 01 00       	mov    %eax,0x1aa60
        _version = info->version;
        _present = true;
   11e4d:	c6 05 64 aa 01 00 01 	movb   $0x1,0x1aa64
   11e54:	83 c4 10             	add    $0x10,%esp
    }
}
   11e57:	8d 65 f8             	lea    -0x8(%ebp),%esp
   11e5a:	5b                   	pop    %ebx
   11e5b:	5e                   	pop    %esi
   11e5c:	5d                   	pop    %ebp
   11e5d:	c3                   	ret    

00011e5e <apm_shutdown>:

bool apm_shutdown(void)
{
   11e5e:	55                   	push   %ebp
   11e5f:	89 e5                	mov    %esp,%ebp
   11e61:	53                   	push   %ebx
   11e62:	50                   	push   %eax
    if(_present) {
   11e63:	8a 1d 64 aa 01 00    	mov    0x1aa64,%bl
   11e69:	84 db                	test   %bl,%bl
   11e6b:	74 19                	je     11e86 <apm_shutdown+0x28>
        u32 err = apm_entry_call(APM_CS32 << 3, _entrypoint, 0x7, 0x1, 0x3);
   11e6d:	83 ec 0c             	sub    $0xc,%esp
   11e70:	6a 03                	push   $0x3
   11e72:	6a 01                	push   $0x1
   11e74:	6a 07                	push   $0x7
   11e76:	ff 35 60 aa 01 00    	push   0x1aa60
   11e7c:	6a 18                	push   $0x18
   11e7e:	e8 0d 00 00 00       	call   11e90 <apm_entry_call>
        // printf("%s - apm_entry_call failed - 0x%x\n", __func__, err);
        // err = apm_entry_call(APM_CS32 << 3, _entrypoint, 0x7, 0x1, 0x1);
        // printf("%s - apm_entry_call failed - 0x%x\n", __func__, err);
        // err = apm_entry_call(APM_CS32 << 3, _entrypoint, 0x5, 0, 0);
        // printf("%s - apm_entry_call failed - 0x%x\n", __func__, err);
        return true;
   11e83:	83 c4 20             	add    $0x20,%esp
    }
    return false;
}
   11e86:	88 d8                	mov    %bl,%al
   11e88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   11e8b:	c9                   	leave  
   11e8c:	c3                   	ret    
   11e8d:	66 90                	xchg   %ax,%ax
   11e8f:	90                   	nop

00011e90 <apm_entry_call>:
   11e90:	55                   	push   %ebp
   11e91:	89 e5                	mov    %esp,%ebp
   11e93:	53                   	push   %ebx
   11e94:	51                   	push   %ecx
   11e95:	b4 53                	mov    $0x53,%ah
   11e97:	8a 45 10             	mov    0x10(%ebp),%al
   11e9a:	66 8b 5d 14          	mov    0x14(%ebp),%bx
   11e9e:	66 8b 4d 18          	mov    0x18(%ebp),%cx
   11ea2:	66 ff 75 08          	pushw  0x8(%ebp)
   11ea6:	ff 75 0c             	push   0xc(%ebp)
   11ea9:	ff 1c 24             	lcall  *(%esp)
   11eac:	83 c4 06             	add    $0x6,%esp
   11eaf:	72 02                	jb     11eb3 <apm_entry_call.Exit>
   11eb1:	30 e4                	xor    %ah,%ah

00011eb3 <apm_entry_call.Exit>:
   11eb3:	0f b6 c4             	movzbl %ah,%eax
   11eb6:	59                   	pop    %ecx
   11eb7:	5b                   	pop    %ebx
   11eb8:	5d                   	pop    %ebp
   11eb9:	c3                   	ret    

00011eba <get_set_count>:
#include "bitmap.h"
#include "string.h"

static u32 get_set_count(u8 *byte, u32 size)
{
   11eba:	55                   	push   %ebp
   11ebb:	89 e5                	mov    %esp,%ebp
   11ebd:	56                   	push   %esi
   11ebe:	53                   	push   %ebx
    u32 count = 0;
    for (u32 i = 0; i < size; ++i)
   11ebf:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
    u32 count = 0;
   11ec2:	31 c9                	xor    %ecx,%ecx
    {
        u8 data = byte[i];
   11ec4:	8a 10                	mov    (%eax),%dl
        while (data)
   11ec6:	84 d2                	test   %dl,%dl
   11ec8:	74 08                	je     11ed2 <get_set_count+0x18>
        {
            ++count;
   11eca:	41                   	inc    %ecx
            data &= data - 1;
   11ecb:	8d 72 ff             	lea    -0x1(%edx),%esi
   11ece:	21 f2                	and    %esi,%edx
   11ed0:	eb f4                	jmp    11ec6 <get_set_count+0xc>
    for (u32 i = 0; i < size; ++i)
   11ed2:	40                   	inc    %eax
   11ed3:	39 d8                	cmp    %ebx,%eax
   11ed5:	75 ed                	jne    11ec4 <get_set_count+0xa>
        }
    }
    return count;
}
   11ed7:	89 c8                	mov    %ecx,%eax
   11ed9:	5b                   	pop    %ebx
   11eda:	5e                   	pop    %esi
   11edb:	5d                   	pop    %ebp
   11edc:	c3                   	ret    

00011edd <bitmap_init>:

void bitmap_init(struct bitmap *map, void *buf, u32 buf_size)
{
   11edd:	55                   	push   %ebp
   11ede:	89 e5                	mov    %esp,%ebp
   11ee0:	8b 45 08             	mov    0x8(%ebp),%eax
   11ee3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    map->data = buf;
   11ee6:	89 08                	mov    %ecx,(%eax)
    map->size = buf_size * 8;
   11ee8:	8b 55 10             	mov    0x10(%ebp),%edx
   11eeb:	c1 e2 03             	shl    $0x3,%edx
   11eee:	89 50 04             	mov    %edx,0x4(%eax)
    map->first_clear = 0;
   11ef1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    map->clear_count = map->size;
   11ef8:	89 50 0c             	mov    %edx,0xc(%eax)
    memset(buf, 0, buf_size);
   11efb:	c7 45 0c 00 00 00 00 	movl   $0x0,0xc(%ebp)
   11f02:	89 4d 08             	mov    %ecx,0x8(%ebp)
}
   11f05:	5d                   	pop    %ebp
    memset(buf, 0, buf_size);
   11f06:	e9 4d 45 00 00       	jmp    16458 <memset>

00011f0b <bitmap_set>:

void bitmap_set(struct bitmap *map, u32 idx, u32 count)
{
   11f0b:	55                   	push   %ebp
   11f0c:	89 e5                	mov    %esp,%ebp
   11f0e:	57                   	push   %edi
   11f0f:	56                   	push   %esi
   11f10:	53                   	push   %ebx
   11f11:	83 ec 2c             	sub    $0x2c,%esp
   11f14:	8b 7d 08             	mov    0x8(%ebp),%edi
   11f17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
   11f1a:	8b 45 10             	mov    0x10(%ebp),%eax
    if (idx >= map->size)
   11f1d:	8b 4f 04             	mov    0x4(%edi),%ecx
   11f20:	39 d9                	cmp    %ebx,%ecx
   11f22:	0f 86 6c 01 00 00    	jbe    12094 <bitmap_set+0x189>
        return;
    if (idx < map->first_clear)
   11f28:	8b 57 08             	mov    0x8(%edi),%edx
   11f2b:	39 da                	cmp    %ebx,%edx
   11f2d:	76 12                	jbe    11f41 <bitmap_set+0x36>
    {
        if (count <= map->first_clear - idx)
   11f2f:	89 d6                	mov    %edx,%esi
   11f31:	29 de                	sub    %ebx,%esi
   11f33:	39 c6                	cmp    %eax,%esi
   11f35:	0f 83 59 01 00 00    	jae    12094 <bitmap_set+0x189>
            return;
        count -= map->first_clear - idx;
   11f3b:	01 d8                	add    %ebx,%eax
   11f3d:	29 d0                	sub    %edx,%eax
   11f3f:	89 d3                	mov    %edx,%ebx
        idx = map->first_clear;
    }
    if (count > map->size)
   11f41:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
   11f44:	39 c1                	cmp    %eax,%ecx
   11f46:	76 03                	jbe    11f4b <bitmap_set+0x40>
   11f48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        count = map->size;
    if (idx + count > map->size)
   11f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
   11f4e:	01 d8                	add    %ebx,%eax
   11f50:	39 c1                	cmp    %eax,%ecx
   11f52:	73 05                	jae    11f59 <bitmap_set+0x4e>
        count = map->size - idx;
   11f54:	29 d9                	sub    %ebx,%ecx
   11f56:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    if (!count)
   11f59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
   11f5d:	0f 84 31 01 00 00    	je     12094 <bitmap_set+0x189>
        return;

    if (idx == map->first_clear)
   11f63:	39 da                	cmp    %ebx,%edx
   11f65:	75 08                	jne    11f6f <bitmap_set+0x64>
    {
        map->first_clear += count;
   11f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
   11f6a:	01 d8                	add    %ebx,%eax
   11f6c:	89 47 08             	mov    %eax,0x8(%edi)
    }

    u32 offset = idx >> 3;
   11f6f:	89 de                	mov    %ebx,%esi
   11f71:	c1 ee 03             	shr    $0x3,%esi
    idx &= 7;

    if (idx)
   11f74:	83 e3 07             	and    $0x7,%ebx
   11f77:	0f 84 81 00 00 00    	je     11ffe <bitmap_set+0xf3>
    {
        u8 shift = 0;
        if (count < 8 - idx)
   11f7d:	b8 08 00 00 00       	mov    $0x8,%eax
   11f82:	29 d8                	sub    %ebx,%eax
   11f84:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
   11f87:	76 10                	jbe    11f99 <bitmap_set+0x8e>
        {
            shift = 8 - idx - count;
   11f89:	b1 08                	mov    $0x8,%cl
   11f8b:	29 d9                	sub    %ebx,%ecx
   11f8d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
            count = 0;
   11f90:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
   11f97:	eb 0c                	jmp    11fa5 <bitmap_set+0x9a>
        }
        else
            count -= 8 - idx;
   11f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
   11f9c:	8d 44 18 f8          	lea    -0x8(%eax,%ebx,1),%eax
   11fa0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        u8 shift = 0;
   11fa3:	31 c9                	xor    %ecx,%ecx
   11fa5:	88 4d d7             	mov    %cl,-0x29(%ebp)
        if (map->data[offset] != 0xff)
   11fa8:	8b 07                	mov    (%edi),%eax
   11faa:	01 f0                	add    %esi,%eax
   11fac:	89 45 e0             	mov    %eax,-0x20(%ebp)
   11faf:	8a 00                	mov    (%eax),%al
   11fb1:	88 45 dc             	mov    %al,-0x24(%ebp)
   11fb4:	fe c0                	inc    %al
   11fb6:	74 46                	je     11ffe <bitmap_set+0xf3>
        {
            u8 old = get_set_count(&map->data[offset], 1);
   11fb8:	ba 01 00 00 00       	mov    $0x1,%edx
   11fbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
   11fc0:	e8 f5 fe ff ff       	call   11eba <get_set_count>
   11fc5:	89 45 d8             	mov    %eax,-0x28(%ebp)
            map->data[offset] |= 0xff >> shift & 0xff << idx;
   11fc8:	ba ff 00 00 00       	mov    $0xff,%edx
   11fcd:	89 d0                	mov    %edx,%eax
   11fcf:	8a 4d d7             	mov    -0x29(%ebp),%cl
   11fd2:	d3 f8                	sar    %cl,%eax
   11fd4:	88 d9                	mov    %bl,%cl
   11fd6:	d3 e2                	shl    %cl,%edx
   11fd8:	21 d0                	and    %edx,%eax
   11fda:	0b 45 dc             	or     -0x24(%ebp),%eax
   11fdd:	8b 55 e0             	mov    -0x20(%ebp),%edx
   11fe0:	88 02                	mov    %al,(%edx)
            map->clear_count -= get_set_count(&map->data[offset++], 1) - old;
   11fe2:	8d 5e 01             	lea    0x1(%esi),%ebx
   11fe5:	8b 07                	mov    (%edi),%eax
   11fe7:	01 f0                	add    %esi,%eax
   11fe9:	ba 01 00 00 00       	mov    $0x1,%edx
   11fee:	e8 c7 fe ff ff       	call   11eba <get_set_count>
   11ff3:	0f b6 75 d8          	movzbl -0x28(%ebp),%esi
   11ff7:	29 c6                	sub    %eax,%esi
   11ff9:	01 77 0c             	add    %esi,0xc(%edi)
   11ffc:	89 de                	mov    %ebx,%esi
        }
    }

    if (count & 0xfffffff8)
   11ffe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
   12001:	83 e0 f8             	and    $0xfffffff8,%eax
   12004:	89 45 e0             	mov    %eax,-0x20(%ebp)
   12007:	74 41                	je     1204a <bitmap_set+0x13f>
    { // count >= 8
        u32 size = count >> 3;
   12009:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
   1200c:	c1 eb 03             	shr    $0x3,%ebx
        u32 need_set = (size << 3) - get_set_count(&map->data[offset], size);
   1200f:	8b 0f                	mov    (%edi),%ecx
   12011:	01 f1                	add    %esi,%ecx
   12013:	89 da                	mov    %ebx,%edx
   12015:	89 c8                	mov    %ecx,%eax
   12017:	89 4d dc             	mov    %ecx,-0x24(%ebp)
   1201a:	e8 9b fe ff ff       	call   11eba <get_set_count>
   1201f:	89 c2                	mov    %eax,%edx
        if (need_set)
   12021:	39 45 e0             	cmp    %eax,-0x20(%ebp)
   12024:	74 1e                	je     12044 <bitmap_set+0x139>
        {
            map->clear_count -= need_set;
   12026:	8b 47 0c             	mov    0xc(%edi),%eax
   12029:	2b 45 e0             	sub    -0x20(%ebp),%eax
   1202c:	01 d0                	add    %edx,%eax
   1202e:	89 47 0c             	mov    %eax,0xc(%edi)
            memset(&map->data[offset], 0xff, size);
   12031:	50                   	push   %eax
   12032:	53                   	push   %ebx
   12033:	68 ff 00 00 00       	push   $0xff
   12038:	8b 4d dc             	mov    -0x24(%ebp),%ecx
   1203b:	51                   	push   %ecx
   1203c:	e8 17 44 00 00       	call   16458 <memset>
   12041:	83 c4 10             	add    $0x10,%esp
        }
        offset += size;
   12044:	01 de                	add    %ebx,%esi
        count &= 7;
   12046:	83 65 e4 07          	andl   $0x7,-0x1c(%ebp)
    }

    if (count)
   1204a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
   1204e:	74 44                	je     12094 <bitmap_set+0x189>
    {
        if (map->data[offset] != 0xff)
   12050:	8b 1f                	mov    (%edi),%ebx
   12052:	01 f3                	add    %esi,%ebx
   12054:	8a 03                	mov    (%ebx),%al
   12056:	88 45 e0             	mov    %al,-0x20(%ebp)
   12059:	fe c0                	inc    %al
   1205b:	74 37                	je     12094 <bitmap_set+0x189>
        {
            u8 old = get_set_count(&map->data[offset], 1);
   1205d:	ba 01 00 00 00       	mov    $0x1,%edx
   12062:	89 d8                	mov    %ebx,%eax
   12064:	e8 51 fe ff ff       	call   11eba <get_set_count>
   12069:	89 45 dc             	mov    %eax,-0x24(%ebp)
            map->data[offset] |= ~(0xff << count);
   1206c:	b8 ff 00 00 00       	mov    $0xff,%eax
   12071:	8a 4d e4             	mov    -0x1c(%ebp),%cl
   12074:	d3 e0                	shl    %cl,%eax
   12076:	f7 d0                	not    %eax
   12078:	0b 45 e0             	or     -0x20(%ebp),%eax
   1207b:	88 03                	mov    %al,(%ebx)
            map->clear_count -= get_set_count(&map->data[offset], 1) - old;
   1207d:	8b 07                	mov    (%edi),%eax
   1207f:	01 f0                	add    %esi,%eax
   12081:	ba 01 00 00 00       	mov    $0x1,%edx
   12086:	e8 2f fe ff ff       	call   11eba <get_set_count>
   1208b:	0f b6 5d dc          	movzbl -0x24(%ebp),%ebx
   1208f:	29 c3                	sub    %eax,%ebx
   12091:	01 5f 0c             	add    %ebx,0xc(%edi)
        }
    }
}
   12094:	8d 65 f4             	lea    -0xc(%ebp),%esp
   12097:	5b                   	pop    %ebx
   12098:	5e                   	pop    %esi
   12099:	5f                   	pop    %edi
   1209a:	5d                   	pop    %ebp
   1209b:	c3                   	ret    

0001209c <bitmap_clear>:

void bitmap_clear(struct bitmap *map, u32 idx, u32 count)
{
   1209c:	55                   	push   %ebp
   1209d:	89 e5                	mov    %esp,%ebp
   1209f:	57                   	push   %edi
   120a0:	56                   	push   %esi
   120a1:	53                   	push   %ebx
   120a2:	83 ec 2c             	sub    $0x2c,%esp
   120a5:	8b 75 08             	mov    0x8(%ebp),%esi
   120a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
   120ab:	8b 55 10             	mov    0x10(%ebp),%edx
    if (idx >= map->size)
   120ae:	8b 46 04             	mov    0x4(%esi),%eax
   120b1:	39 d8                	cmp    %ebx,%eax
   120b3:	0f 86 4a 01 00 00    	jbe    12203 <bitmap_clear+0x167>
        return;
    if (idx == map->first_clear)
   120b9:	8b 4e 08             	mov    0x8(%esi),%ecx
   120bc:	39 d9                	cmp    %ebx,%ecx
   120be:	75 04                	jne    120c4 <bitmap_clear+0x28>
    {
        idx = map->first_clear + 1;
   120c0:	8d 59 01             	lea    0x1(%ecx),%ebx
        --count;
   120c3:	4a                   	dec    %edx
    }
    if (count > map->size)
   120c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
   120c7:	39 d0                	cmp    %edx,%eax
   120c9:	76 03                	jbe    120ce <bitmap_clear+0x32>
   120cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        count = map->size;
    if (idx + count > map->size)
   120ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
   120d1:	8d 14 3b             	lea    (%ebx,%edi,1),%edx
   120d4:	39 d0                	cmp    %edx,%eax
   120d6:	73 05                	jae    120dd <bitmap_clear+0x41>
        count = map->size - idx;
   120d8:	29 d8                	sub    %ebx,%eax
   120da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (!count)
   120dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
   120e1:	0f 84 1c 01 00 00    	je     12203 <bitmap_clear+0x167>
        return;

    if (idx < map->first_clear)
   120e7:	39 d9                	cmp    %ebx,%ecx
   120e9:	76 03                	jbe    120ee <bitmap_clear+0x52>
        map->first_clear = idx;
   120eb:	89 5e 08             	mov    %ebx,0x8(%esi)

    u32 offset = idx >> 3;
   120ee:	89 df                	mov    %ebx,%edi
   120f0:	c1 ef 03             	shr    $0x3,%edi
    idx &= 7;

    if (idx)
   120f3:	83 e3 07             	and    $0x7,%ebx
   120f6:	0f 84 83 00 00 00    	je     1217f <bitmap_clear+0xe3>
    {
        u8 shift = 0;
        if (count < 8 - idx)
   120fc:	b8 08 00 00 00       	mov    $0x8,%eax
   12101:	29 d8                	sub    %ebx,%eax
   12103:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
   12106:	76 10                	jbe    12118 <bitmap_clear+0x7c>
        {
            shift = 8 - idx - count;
   12108:	b1 08                	mov    $0x8,%cl
   1210a:	29 d9                	sub    %ebx,%ecx
   1210c:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
            count = 0;
   1210f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
   12116:	eb 0c                	jmp    12124 <bitmap_clear+0x88>
        }
        else
            count -= 8 - idx;
   12118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
   1211b:	8d 44 18 f8          	lea    -0x8(%eax,%ebx,1),%eax
   1211f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        u8 shift = 0;
   12122:	31 c9                	xor    %ecx,%ecx
        if (map->data[offset] != 0)
   12124:	8b 06                	mov    (%esi),%eax
   12126:	01 f8                	add    %edi,%eax
   12128:	89 45 e0             	mov    %eax,-0x20(%ebp)
   1212b:	8a 00                	mov    (%eax),%al
   1212d:	88 45 dc             	mov    %al,-0x24(%ebp)
   12130:	84 c0                	test   %al,%al
   12132:	74 4b                	je     1217f <bitmap_clear+0xe3>
   12134:	88 4d d7             	mov    %cl,-0x29(%ebp)
        {
            u8 old = get_set_count(&map->data[offset], 1);
   12137:	ba 01 00 00 00       	mov    $0x1,%edx
   1213c:	8b 45 e0             	mov    -0x20(%ebp),%eax
   1213f:	e8 76 fd ff ff       	call   11eba <get_set_count>
   12144:	89 45 d8             	mov    %eax,-0x28(%ebp)
            map->data[offset] &= ~(0xff >> shift & 0xff << idx);
   12147:	b8 ff 00 00 00       	mov    $0xff,%eax
   1214c:	89 c2                	mov    %eax,%edx
   1214e:	8a 4d d7             	mov    -0x29(%ebp),%cl
   12151:	d3 fa                	sar    %cl,%edx
   12153:	88 d9                	mov    %bl,%cl
   12155:	d3 e0                	shl    %cl,%eax
   12157:	21 c2                	and    %eax,%edx
   12159:	f7 d2                	not    %edx
   1215b:	23 55 dc             	and    -0x24(%ebp),%edx
   1215e:	8b 45 e0             	mov    -0x20(%ebp),%eax
   12161:	88 10                	mov    %dl,(%eax)
            map->clear_count += old - get_set_count(&map->data[offset++], 1);
   12163:	8d 5f 01             	lea    0x1(%edi),%ebx
   12166:	8b 06                	mov    (%esi),%eax
   12168:	01 f8                	add    %edi,%eax
   1216a:	ba 01 00 00 00       	mov    $0x1,%edx
   1216f:	e8 46 fd ff ff       	call   11eba <get_set_count>
   12174:	0f b6 7d d8          	movzbl -0x28(%ebp),%edi
   12178:	29 c7                	sub    %eax,%edi
   1217a:	01 7e 0c             	add    %edi,0xc(%esi)
   1217d:	89 df                	mov    %ebx,%edi
        }
    }

    if (count & 0xfffffff8)
   1217f:	f7 45 e4 f8 ff ff ff 	testl  $0xfffffff8,-0x1c(%ebp)
   12186:	74 33                	je     121bb <bitmap_clear+0x11f>
    { // count >= 8
        u32 size = count >> 3;
   12188:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
   1218b:	c1 eb 03             	shr    $0x3,%ebx
        u32 need_clear = get_set_count(&map->data[offset], size);
   1218e:	8b 0e                	mov    (%esi),%ecx
   12190:	01 f9                	add    %edi,%ecx
   12192:	89 da                	mov    %ebx,%edx
   12194:	89 c8                	mov    %ecx,%eax
   12196:	89 4d e0             	mov    %ecx,-0x20(%ebp)
   12199:	e8 1c fd ff ff       	call   11eba <get_set_count>
        if (need_clear)
   1219e:	85 c0                	test   %eax,%eax
   121a0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
   121a3:	74 10                	je     121b5 <bitmap_clear+0x119>
        {
            map->clear_count += need_clear;
   121a5:	01 46 0c             	add    %eax,0xc(%esi)
            memset(&map->data[offset], 0, size);
   121a8:	50                   	push   %eax
   121a9:	53                   	push   %ebx
   121aa:	6a 00                	push   $0x0
   121ac:	51                   	push   %ecx
   121ad:	e8 a6 42 00 00       	call   16458 <memset>
   121b2:	83 c4 10             	add    $0x10,%esp
        }
        offset += size;
   121b5:	01 df                	add    %ebx,%edi
        count &= 7;
   121b7:	83 65 e4 07          	andl   $0x7,-0x1c(%ebp)
    }

    if (count)
   121bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
   121bf:	74 42                	je     12203 <bitmap_clear+0x167>
    {
        if (map->data[offset] != 0)
   121c1:	8b 1e                	mov    (%esi),%ebx
   121c3:	01 fb                	add    %edi,%ebx
   121c5:	8a 03                	mov    (%ebx),%al
   121c7:	88 45 e0             	mov    %al,-0x20(%ebp)
   121ca:	84 c0                	test   %al,%al
   121cc:	74 35                	je     12203 <bitmap_clear+0x167>
        {
            u8 old = get_set_count(&map->data[offset], 1);
   121ce:	ba 01 00 00 00       	mov    $0x1,%edx
   121d3:	89 d8                	mov    %ebx,%eax
   121d5:	e8 e0 fc ff ff       	call   11eba <get_set_count>
   121da:	89 45 dc             	mov    %eax,-0x24(%ebp)
            map->data[offset] &= 0xff << count;
   121dd:	b8 ff 00 00 00       	mov    $0xff,%eax
   121e2:	8a 4d e4             	mov    -0x1c(%ebp),%cl
   121e5:	d3 e0                	shl    %cl,%eax
   121e7:	23 45 e0             	and    -0x20(%ebp),%eax
   121ea:	88 03                	mov    %al,(%ebx)
            map->clear_count += old - get_set_count(&map->data[offset++], 1);
   121ec:	8b 06                	mov    (%esi),%eax
   121ee:	01 f8                	add    %edi,%eax
   121f0:	ba 01 00 00 00       	mov    $0x1,%edx
   121f5:	e8 c0 fc ff ff       	call   11eba <get_set_count>
   121fa:	0f b6 5d dc          	movzbl -0x24(%ebp),%ebx
   121fe:	29 c3                	sub    %eax,%ebx
   12200:	01 5e 0c             	add    %ebx,0xc(%esi)
        }
    }
}
   12203:	8d 65 f4             	lea    -0xc(%ebp),%esp
   12206:	5b                   	pop    %ebx
   12207:	5e                   	pop    %esi
   12208:	5f                   	pop    %edi
   12209:	5d                   	pop    %ebp
   1220a:	c3                   	ret    

0001220b <bitmap_test>:

bool bitmap_test(const struct bitmap *map, u32 idx)
{
   1220b:	55                   	push   %ebp
   1220c:	89 e5                	mov    %esp,%ebp
   1220e:	53                   	push   %ebx
   1220f:	8b 55 08             	mov    0x8(%ebp),%edx
   12212:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    if (idx < map->first_clear || idx >= map->size)
   12215:	8b 5a 08             	mov    0x8(%edx),%ebx
        return true;
   12218:	b0 01                	mov    $0x1,%al
    if (idx < map->first_clear || idx >= map->size)
   1221a:	39 cb                	cmp    %ecx,%ebx
   1221c:	77 25                	ja     12243 <bitmap_test+0x38>
   1221e:	39 4a 04             	cmp    %ecx,0x4(%edx)
   12221:	76 20                	jbe    12243 <bitmap_test+0x38>
    else if (idx == map->first_clear)
        return false;
   12223:	31 c0                	xor    %eax,%eax
    else if (idx == map->first_clear)
   12225:	39 cb                	cmp    %ecx,%ebx
   12227:	74 1a                	je     12243 <bitmap_test+0x38>
    u32 offset = idx >> 3;
   12229:	89 c8                	mov    %ecx,%eax
   1222b:	c1 e8 03             	shr    $0x3,%eax
    idx &= 7;
    return map->data[offset] & (1 << idx);
   1222e:	8b 12                	mov    (%edx),%edx
   12230:	0f b6 14 02          	movzbl (%edx,%eax,1),%edx
    idx &= 7;
   12234:	83 e1 07             	and    $0x7,%ecx
    return map->data[offset] & (1 << idx);
   12237:	b8 01 00 00 00       	mov    $0x1,%eax
   1223c:	d3 e0                	shl    %cl,%eax
   1223e:	85 c2                	test   %eax,%edx
   12240:	0f 95 c0             	setne  %al
}
   12243:	5b                   	pop    %ebx
   12244:	5d                   	pop    %ebp
   12245:	c3                   	ret    

00012246 <bitmap_size>:

u32 bitmap_size(const struct bitmap *map)
{
   12246:	55                   	push   %ebp
   12247:	89 e5                	mov    %esp,%ebp
    return map->size;
   12249:	8b 45 08             	mov    0x8(%ebp),%eax
   1224c:	8b 40 04             	mov    0x4(%eax),%eax
}
   1224f:	5d                   	pop    %ebp
   12250:	c3                   	ret    

00012251 <bitmap_clear_count>:

u32 bitmap_clear_count(const struct bitmap *map)
{
   12251:	55                   	push   %ebp
   12252:	89 e5                	mov    %esp,%ebp
    return map->clear_count;
   12254:	8b 45 08             	mov    0x8(%ebp),%eax
   12257:	8b 40 0c             	mov    0xc(%eax),%eax
}
   1225a:	5d                   	pop    %ebp
   1225b:	c3                   	ret    

0001225c <bitmap_find_clear>:

u32 bitmap_find_clear(const struct bitmap *map, u32 idx)
{
   1225c:	55                   	push   %ebp
   1225d:	89 e5                	mov    %esp,%ebp
   1225f:	57                   	push   %edi
   12260:	56                   	push   %esi
   12261:	53                   	push   %ebx
   12262:	8b 7d 08             	mov    0x8(%ebp),%edi
   12265:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (idx >= map->size || map->clear_count == 0)
   12268:	8b 57 04             	mov    0x4(%edi),%edx
        return -1;
   1226b:	83 c8 ff             	or     $0xffffffff,%eax
    if (idx >= map->size || map->clear_count == 0)
   1226e:	39 da                	cmp    %ebx,%edx
   12270:	76 3d                	jbe    122af <bitmap_find_clear+0x53>
   12272:	83 7f 0c 00          	cmpl   $0x0,0xc(%edi)
   12276:	74 37                	je     122af <bitmap_find_clear+0x53>
    if (idx <= map->first_clear)
   12278:	8b 47 08             	mov    0x8(%edi),%eax
   1227b:	39 d8                	cmp    %ebx,%eax
   1227d:	73 30                	jae    122af <bitmap_find_clear+0x53>
        return map->first_clear;

    u32 offset = idx >> 3;
   1227f:	89 de                	mov    %ebx,%esi
   12281:	c1 ee 03             	shr    $0x3,%esi
    u32 i = idx & 7;
   12284:	89 d9                	mov    %ebx,%ecx
   12286:	83 e1 07             	and    $0x7,%ecx

    // while(idx < map->size && map->data[offset] == 0xff) {
    //     ++offset;
    //     idx += 8;
    // }
    for (; idx < map->size && (map->data[offset] & (1 << i)); ++idx)
   12289:	8b 3f                	mov    (%edi),%edi
   1228b:	89 d8                	mov    %ebx,%eax
   1228d:	0f b6 1c 37          	movzbl (%edi,%esi,1),%ebx
   12291:	d3 fb                	sar    %cl,%ebx
   12293:	80 e3 01             	and    $0x1,%bl
   12296:	74 10                	je     122a8 <bitmap_find_clear+0x4c>
    {
        if (++i == 8)
   12298:	41                   	inc    %ecx
   12299:	83 f9 08             	cmp    $0x8,%ecx
   1229c:	75 03                	jne    122a1 <bitmap_find_clear+0x45>
        {
            ++offset;
   1229e:	46                   	inc    %esi
            i = 0;
   1229f:	31 c9                	xor    %ecx,%ecx
    for (; idx < map->size && (map->data[offset] & (1 << i)); ++idx)
   122a1:	40                   	inc    %eax
   122a2:	39 c2                	cmp    %eax,%edx
   122a4:	75 e7                	jne    1228d <bitmap_find_clear+0x31>
   122a6:	eb 04                	jmp    122ac <bitmap_find_clear+0x50>
        }
    }

    if (idx == map->size)
   122a8:	39 c2                	cmp    %eax,%edx
   122aa:	75 03                	jne    122af <bitmap_find_clear+0x53>
        return -1;
   122ac:	83 c8 ff             	or     $0xffffffff,%eax
        return -1;
    return idx;
}
   122af:	5b                   	pop    %ebx
   122b0:	5e                   	pop    %esi
   122b1:	5f                   	pop    %edi
   122b2:	5d                   	pop    %ebp
   122b3:	c3                   	ret    

000122b4 <bitmap_find_set>:

u32 bitmap_find_set(const struct bitmap *map, u32 idx)
{
   122b4:	55                   	push   %ebp
   122b5:	89 e5                	mov    %esp,%ebp
   122b7:	57                   	push   %edi
   122b8:	56                   	push   %esi
   122b9:	53                   	push   %ebx
   122ba:	8b 55 08             	mov    0x8(%ebp),%edx
   122bd:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (idx < map->first_clear)
   122c0:	39 42 08             	cmp    %eax,0x8(%edx)
   122c3:	77 2f                	ja     122f4 <bitmap_find_set+0x40>
        return idx;
    else if (idx >= map->size)
   122c5:	8b 72 04             	mov    0x4(%edx),%esi
   122c8:	39 c6                	cmp    %eax,%esi
   122ca:	76 25                	jbe    122f1 <bitmap_find_set+0x3d>
        return -1;

    u32 offset = idx >> 3;
   122cc:	89 c3                	mov    %eax,%ebx
   122ce:	c1 eb 03             	shr    $0x3,%ebx
    u32 i = idx & 7;
   122d1:	89 c1                	mov    %eax,%ecx
   122d3:	83 e1 07             	and    $0x7,%ecx

    for (; idx < map->size && (map->data[offset] & (1 << i)) == 0; ++idx)
   122d6:	8b 3a                	mov    (%edx),%edi
   122d8:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
   122dc:	d3 fa                	sar    %cl,%edx
   122de:	80 e2 01             	and    $0x1,%dl
   122e1:	75 11                	jne    122f4 <bitmap_find_set+0x40>
    {
        if (++i == 8)
   122e3:	41                   	inc    %ecx
   122e4:	83 f9 08             	cmp    $0x8,%ecx
   122e7:	75 03                	jne    122ec <bitmap_find_set+0x38>
        {
            ++offset;
   122e9:	43                   	inc    %ebx
            i = 0;
   122ea:	31 c9                	xor    %ecx,%ecx
    for (; idx < map->size && (map->data[offset] & (1 << i)) == 0; ++idx)
   122ec:	40                   	inc    %eax
   122ed:	39 c6                	cmp    %eax,%esi
   122ef:	75 e7                	jne    122d8 <bitmap_find_set+0x24>
        return -1;
   122f1:	83 c8 ff             	or     $0xffffffff,%eax
    }

    if (idx == map->size)
        return -1;
    return idx;
}
   122f4:	5b                   	pop    %ebx
   122f5:	5e                   	pop    %esi
   122f6:	5f                   	pop    %edi
   122f7:	5d                   	pop    %ebp
   122f8:	c3                   	ret    

000122f9 <cmos_read_byte>:
    print_char('\n');
}
#endif

u8 cmos_read_byte(u8 reg)
{
   122f9:	55                   	push   %ebp
   122fa:	89 e5                	mov    %esp,%ebp
   122fc:	8b 45 08             	mov    0x8(%ebp),%eax
// void write_cr4(u32 cr4);

inline static u32 read_eflags(void)
{
	u32 eflags;
	__asm__ __volatile__("pushfl\n\t"
   122ff:	9c                   	pushf  
   12300:	5a                   	pop    %edx
						 : "memory");
}

inline static void disable(void)
{
	__asm__ __volatile__("cli\n" ::
   12301:	fa                   	cli    
    __asm__ volatile("outb %0, %1"
   12302:	e6 70                	out    %al,$0x70
    __asm__ volatile("inb %1, %0"
   12304:	e4 71                	in     $0x71,%al
	__asm__ __volatile__("pushfl\n\t"
   12306:	9c                   	pushf  
   12307:	59                   	pop    %ecx
    u32 save_eflags = read_eflags();
    disable();
    port_write_byte(CMOS_PORT_REG, reg);
    u8 data = port_read_byte(CMOS_PORT_DATA);
    write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
   12308:	81 e2 00 02 00 00    	and    $0x200,%edx
   1230e:	09 ca                	or     %ecx,%edx
	__asm__ __volatile__("pushl %0\n\t"
   12310:	52                   	push   %edx
   12311:	9d                   	popf   
    return data;
}
   12312:	5d                   	pop    %ebp
   12313:	c3                   	ret    

00012314 <cmos_write_byte>:

void cmos_write_byte(u8 reg, u8 val)
{
   12314:	55                   	push   %ebp
   12315:	89 e5                	mov    %esp,%ebp
   12317:	8b 45 08             	mov    0x8(%ebp),%eax
   1231a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	__asm__ __volatile__("pushfl\n\t"
   1231d:	9c                   	pushf  
   1231e:	5a                   	pop    %edx
	__asm__ __volatile__("cli\n" ::
   1231f:	fa                   	cli    
    __asm__ volatile("outb %0, %1"
   12320:	e6 70                	out    %al,$0x70
   12322:	88 c8                	mov    %cl,%al
   12324:	e6 71                	out    %al,$0x71
	__asm__ __volatile__("pushfl\n\t"
   12326:	9c                   	pushf  
   12327:	58                   	pop    %eax
    u32 save_eflags = read_eflags();
    disable();
    port_write_byte(CMOS_PORT_REG, reg);
    port_write_byte(CMOS_PORT_DATA, val);
    write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
   12328:	81 e2 00 02 00 00    	and    $0x200,%edx
   1232e:	09 c2                	or     %eax,%edx
	__asm__ __volatile__("pushl %0\n\t"
   12330:	52                   	push   %edx
   12331:	9d                   	popf   
}
   12332:	5d                   	pop    %ebp
   12333:	c3                   	ret    

00012334 <cmos_mask>:

void cmos_mask(u8 reg, u8 on, u8 off)
{
   12334:	55                   	push   %ebp
   12335:	89 e5                	mov    %esp,%ebp
   12337:	57                   	push   %edi
   12338:	56                   	push   %esi
   12339:	53                   	push   %ebx
   1233a:	83 ec 18             	sub    $0x18,%esp
   1233d:	8b 75 0c             	mov    0xc(%ebp),%esi
   12340:	8b 5d 10             	mov    0x10(%ebp),%ebx
    u8 new_val = (cmos_read_byte(reg) & ~off) | on;
   12343:	0f b6 7d 08          	movzbl 0x8(%ebp),%edi
   12347:	57                   	push   %edi
   12348:	e8 ac ff ff ff       	call   122f9 <cmos_read_byte>
    cmos_write_byte(reg, new_val);
   1234d:	83 c4 10             	add    $0x10,%esp
    u8 new_val = (cmos_read_byte(reg) & ~off) | on;
   12350:	f7 d3                	not    %ebx
   12352:	21 c3                	and    %eax,%ebx
   12354:	09 f3                	or     %esi,%ebx
    cmos_write_byte(reg, new_val);
   12356:	0f b6 db             	movzbl %bl,%ebx
   12359:	89 5d 0c             	mov    %ebx,0xc(%ebp)
   1235c:	89 7d 08             	mov    %edi,0x8(%ebp)
}
   1235f:	8d 65 f4             	lea    -0xc(%ebp),%esp
   12362:	5b                   	pop    %ebx
   12363:	5e                   	pop    %esi
   12364:	5f                   	pop    %edi
   12365:	5d                   	pop    %ebp
    cmos_write_byte(reg, new_val);
   12366:	eb ac                	jmp    12314 <cmos_write_byte>

00012368 <cmos_setup>:
{
   12368:	55                   	push   %ebp
   12369:	89 e5                	mov    %esp,%ebp
   1236b:	83 ec 0c             	sub    $0xc,%esp
    cmos_mask(CMOS_REG_STATUS_A, 0x26, 0x7f);
   1236e:	6a 7f                	push   $0x7f
   12370:	6a 26                	push   $0x26
   12372:	6a 0a                	push   $0xa
   12374:	e8 bb ff ff ff       	call   12334 <cmos_mask>
    cmos_mask(CMOS_REG_STATUS_B, 0x2, 0xff); // 24-hour BCD
   12379:	83 c4 0c             	add    $0xc,%esp
   1237c:	68 ff 00 00 00       	push   $0xff
   12381:	6a 02                	push   $0x2
   12383:	6a 0b                	push   $0xb
   12385:	e8 aa ff ff ff       	call   12334 <cmos_mask>
    u8 status_b = cmos_read_byte(CMOS_REG_STATUS_B);
   1238a:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
   12391:	e8 63 ff ff ff       	call   122f9 <cmos_read_byte>
    _rtc_bcd_mode = (status_b & 0x4) == 0;
   12396:	88 c2                	mov    %al,%dl
   12398:	c0 ea 02             	shr    $0x2,%dl
   1239b:	83 f2 01             	xor    $0x1,%edx
   1239e:	83 e2 01             	and    $0x1,%edx
   123a1:	88 15 66 aa 01 00    	mov    %dl,0x1aa66
    _rtc_12hour_format = (status_b & 0x2) == 0;
   123a7:	d0 e8                	shr    %al
   123a9:	83 f0 01             	xor    $0x1,%eax
   123ac:	83 e0 01             	and    $0x1,%eax
   123af:	a2 65 aa 01 00       	mov    %al,0x1aa65
    cmos_read_byte(CMOS_REG_STATUS_C);
   123b4:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
   123bb:	e8 39 ff ff ff       	call   122f9 <cmos_read_byte>
    cmos_read_byte(CMOS_REG_STATUS_D);
   123c0:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
   123c7:	e8 2d ff ff ff       	call   122f9 <cmos_read_byte>
}
   123cc:	83 c4 10             	add    $0x10,%esp
   123cf:	c9                   	leave  
   123d0:	c3                   	ret    

000123d1 <cmos_rtc_time>:
    return 1;
}
#endif

bool cmos_rtc_time(struct rtc_time *tm)
{
   123d1:	55                   	push   %ebp
   123d2:	89 e5                	mov    %esp,%ebp
   123d4:	57                   	push   %edi
   123d5:	56                   	push   %esi
   123d6:	53                   	push   %ebx
   123d7:	83 ec 0c             	sub    $0xc,%esp
   123da:	8b 5d 08             	mov    0x8(%ebp),%ebx
    for (u8 times = 100; cmos_read_byte(CMOS_REG_STATUS_A) & CMOS_REG_STATUS_A_UIP && times; --times)
   123dd:	bf 64 00 00 00       	mov    $0x64,%edi
   123e2:	83 ec 0c             	sub    $0xc,%esp
   123e5:	6a 0a                	push   $0xa
   123e7:	e8 0d ff ff ff       	call   122f9 <cmos_read_byte>
   123ec:	83 c4 10             	add    $0x10,%esp
   123ef:	89 fa                	mov    %edi,%edx
   123f1:	84 d2                	test   %dl,%dl
   123f3:	0f 95 c2             	setne  %dl
   123f6:	c0 e8 07             	shr    $0x7,%al
   123f9:	20 c2                	and    %al,%dl
   123fb:	89 d6                	mov    %edx,%esi
   123fd:	74 10                	je     1240f <cmos_rtc_time+0x3e>
        delay_ms(10);
   123ff:	83 ec 0c             	sub    $0xc,%esp
   12402:	6a 0a                	push   $0xa
   12404:	e8 8c 2a 00 00       	call   14e95 <delay_ms>
    for (u8 times = 100; cmos_read_byte(CMOS_REG_STATUS_A) & CMOS_REG_STATUS_A_UIP && times; --times)
   12409:	4f                   	dec    %edi
   1240a:	83 c4 10             	add    $0x10,%esp
   1240d:	eb d3                	jmp    123e2 <cmos_rtc_time+0x11>
    return (cmos_read_byte(CMOS_REG_STATUS_A) & CMOS_REG_STATUS_A_UIP) == 0;
   1240f:	83 ec 0c             	sub    $0xc,%esp
   12412:	6a 0a                	push   $0xa
   12414:	e8 e0 fe ff ff       	call   122f9 <cmos_read_byte>
    u8 century;
    // cmos_mask(CMOS_REG_STATUS_B, 0x80, 0);

    if (!cmos_rtc_wait())
   12419:	83 c4 10             	add    $0x10,%esp
   1241c:	84 c0                	test   %al,%al
   1241e:	0f 88 28 01 00 00    	js     1254c <cmos_rtc_time+0x17b>
        return false;

    tm->seconds = cmos_read_byte(CMOS_RTC_SECONDS);
   12424:	83 ec 0c             	sub    $0xc,%esp
   12427:	6a 00                	push   $0x0
   12429:	e8 cb fe ff ff       	call   122f9 <cmos_read_byte>
   1242e:	88 43 06             	mov    %al,0x6(%ebx)
    tm->minutes = cmos_read_byte(CMOS_RTC_MINUTES);
   12431:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
   12438:	e8 bc fe ff ff       	call   122f9 <cmos_read_byte>
   1243d:	88 43 05             	mov    %al,0x5(%ebx)
    tm->hours = cmos_read_byte(CMOS_RTC_HOURS);
   12440:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
   12447:	e8 ad fe ff ff       	call   122f9 <cmos_read_byte>
   1244c:	88 43 04             	mov    %al,0x4(%ebx)
    tm->day = cmos_read_byte(CMOS_RTC_DAY);
   1244f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
   12456:	e8 9e fe ff ff       	call   122f9 <cmos_read_byte>
   1245b:	88 43 03             	mov    %al,0x3(%ebx)
    tm->month = cmos_read_byte(CMOS_RTC_MONTH);
   1245e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
   12465:	e8 8f fe ff ff       	call   122f9 <cmos_read_byte>
   1246a:	88 43 02             	mov    %al,0x2(%ebx)
    tm->year = cmos_read_byte(CMOS_RTC_YEAR);
   1246d:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
   12474:	e8 80 fe ff ff       	call   122f9 <cmos_read_byte>
   12479:	0f b6 c0             	movzbl %al,%eax
   1247c:	66 89 03             	mov    %ax,(%ebx)
    century = cmos_read_byte(CMOS_RTC_CENTURY);
   1247f:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
   12486:	e8 6e fe ff ff       	call   122f9 <cmos_read_byte>
   1248b:	89 c7                	mov    %eax,%edi

    if (_rtc_12hour_format)
   1248d:	83 c4 10             	add    $0x10,%esp
   12490:	80 3d 65 aa 01 00 00 	cmpb   $0x0,0x1aa65
   12497:	74 10                	je     124a9 <cmos_rtc_time+0xd8>
    {
        print_str("\n[CMOS] unexpecting 12-hour format!\n");
   12499:	83 ec 0c             	sub    $0xc,%esp
   1249c:	68 c5 80 01 00       	push   $0x180c5
   124a1:	e8 0d 0a 00 00       	call   12eb3 <print_str>
   124a6:	83 c4 10             	add    $0x10,%esp
        // pm = tm->hours & 0x80;
        // tm->hours &= 0x7f;
    }

    if (_rtc_bcd_mode)
   124a9:	0f b6 35 66 aa 01 00 	movzbl 0x1aa66,%esi
   124b0:	89 f0                	mov    %esi,%eax
   124b2:	84 c0                	test   %al,%al
   124b4:	0f 84 8d 00 00 00    	je     12547 <cmos_rtc_time+0x176>
    {
        tm->seconds = BCD2BIN(tm->seconds);
   124ba:	8a 4b 06             	mov    0x6(%ebx),%cl
   124bd:	88 c8                	mov    %cl,%al
   124bf:	c0 e8 04             	shr    $0x4,%al
   124c2:	b2 0a                	mov    $0xa,%dl
   124c4:	f6 e2                	mul    %dl
   124c6:	83 e1 0f             	and    $0xf,%ecx
   124c9:	01 c1                	add    %eax,%ecx
   124cb:	88 4b 06             	mov    %cl,0x6(%ebx)
        tm->minutes = BCD2BIN(tm->minutes);
   124ce:	8a 4b 05             	mov    0x5(%ebx),%cl
   124d1:	88 c8                	mov    %cl,%al
   124d3:	c0 e8 04             	shr    $0x4,%al
   124d6:	f6 e2                	mul    %dl
   124d8:	83 e1 0f             	and    $0xf,%ecx
   124db:	01 c1                	add    %eax,%ecx
   124dd:	88 4b 05             	mov    %cl,0x5(%ebx)
        tm->hours = BCD2BIN(tm->hours);
   124e0:	8a 4b 04             	mov    0x4(%ebx),%cl
   124e3:	88 c8                	mov    %cl,%al
   124e5:	c0 e8 04             	shr    $0x4,%al
   124e8:	f6 e2                	mul    %dl
   124ea:	83 e1 0f             	and    $0xf,%ecx
   124ed:	01 c1                	add    %eax,%ecx
   124ef:	88 4b 04             	mov    %cl,0x4(%ebx)
        tm->day = BCD2BIN(tm->day);
   124f2:	8a 4b 03             	mov    0x3(%ebx),%cl
   124f5:	88 c8                	mov    %cl,%al
   124f7:	c0 e8 04             	shr    $0x4,%al
   124fa:	f6 e2                	mul    %dl
   124fc:	83 e1 0f             	and    $0xf,%ecx
   124ff:	01 c1                	add    %eax,%ecx
   12501:	88 4b 03             	mov    %cl,0x3(%ebx)
        tm->month = BCD2BIN(tm->month);
   12504:	8a 4b 02             	mov    0x2(%ebx),%cl
   12507:	88 c8                	mov    %cl,%al
   12509:	c0 e8 04             	shr    $0x4,%al
   1250c:	f6 e2                	mul    %dl
   1250e:	83 e1 0f             	and    $0xf,%ecx
   12511:	01 c8                	add    %ecx,%eax
   12513:	88 43 02             	mov    %al,0x2(%ebx)
        tm->year = BCD2BIN(century) * 100 + BCD2BIN(tm->year);
   12516:	66 8b 13             	mov    (%ebx),%dx
   12519:	89 f8                	mov    %edi,%eax
   1251b:	c0 e8 04             	shr    $0x4,%al
   1251e:	0f b6 c0             	movzbl %al,%eax
   12521:	6b c8 0a             	imul   $0xa,%eax,%ecx
   12524:	83 e7 0f             	and    $0xf,%edi
   12527:	01 cf                	add    %ecx,%edi
   12529:	66 6b ff 64          	imul   $0x64,%di,%di
   1252d:	89 d0                	mov    %edx,%eax
   1252f:	66 c1 e8 04          	shr    $0x4,%ax
   12533:	83 e0 0f             	and    $0xf,%eax
   12536:	66 6b c8 0a          	imul   $0xa,%ax,%cx
   1253a:	83 e2 0f             	and    $0xf,%edx
   1253d:	8d 04 11             	lea    (%ecx,%edx,1),%eax
   12540:	01 c7                	add    %eax,%edi
   12542:	66 89 3b             	mov    %di,(%ebx)
   12545:	eb 05                	jmp    1254c <cmos_rtc_time+0x17b>
    }

    return true;
   12547:	be 01 00 00 00       	mov    $0x1,%esi
        // tm->hours %= 24;
        // }
    }
    return ret;
#endif
}
   1254c:	89 f0                	mov    %esi,%eax
   1254e:	8d 65 f4             	lea    -0xc(%ebp),%esp
   12551:	5b                   	pop    %ebx
   12552:	5e                   	pop    %esi
   12553:	5f                   	pop    %edi
   12554:	5d                   	pop    %ebp
   12555:	c3                   	ret    

00012556 <read_eflags>:
	__asm__ __volatile__("pushfl\n\t"
   12556:	9c                   	pushf  
   12557:	58                   	pop    %eax
}
   12558:	c3                   	ret    

00012559 <update>:
// static void clear_rows(u32 start, u32 end);
// static void print_int(u32 n, u32 base, u32 width);

static void update(void)
{
	if (_GUI_mode)
   12559:	80 3d b4 b2 01 00 00 	cmpb   $0x0,0x1b2b4
   12560:	0f 84 c4 00 00 00    	je     1262a <update+0xd1>
{
   12566:	55                   	push   %ebp
   12567:	89 e5                	mov    %esp,%ebp
   12569:	57                   	push   %edi
   1256a:	56                   	push   %esi
   1256b:	53                   	push   %ebx
   1256c:	83 ec 1c             	sub    $0x1c,%esp
	{
		u32 save_eflags = read_eflags();
   1256f:	e8 e2 ff ff ff       	call   12556 <read_eflags>
   12574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	__asm__ __volatile__("cli\n" ::
   12577:	fa                   	cli    
		disable();

		void *ptr = map_mem(_show_mem_base, _show_mem_size);
   12578:	52                   	push   %edx
   12579:	52                   	push   %edx
   1257a:	ff 35 b0 b2 01 00    	push   0x1b2b0
   12580:	ff 35 d0 b5 01 00    	push   0x1b5d0
   12586:	e8 b7 2e 00 00       	call   15442 <map_mem>
   1258b:	89 c6                	mov    %eax,%esi
		u32 offset = 0;
		for (u16 row = 0; row < _max_rows; ++row)
   1258d:	83 c4 10             	add    $0x10,%esp
   12590:	31 ff                	xor    %edi,%edi
		u32 offset = 0;
   12592:	31 db                	xor    %ebx,%ebx
		for (u16 row = 0; row < _max_rows; ++row)
   12594:	66 3b 3d c6 b5 01 00 	cmp    0x1b5c6,%di
   1259b:	73 67                	jae    12604 <update+0xab>
		{
			if (!_line_modified[row])
   1259d:	0f b7 d7             	movzwl %di,%edx
   125a0:	80 ba c0 b2 01 00 00 	cmpb   $0x0,0x1b2c0(%edx)
   125a7:	75 0e                	jne    125b7 <update+0x5e>
			{
				offset += _show_Bpl * 16;
   125a9:	0f b7 05 c0 b5 01 00 	movzwl 0x1b5c0,%eax
   125b0:	c1 e0 04             	shl    $0x4,%eax
   125b3:	01 c3                	add    %eax,%ebx
				continue;
   125b5:	eb 4a                	jmp    12601 <update+0xa8>
			}

			_line_modified[row] = false;
   125b7:	c6 82 c0 b2 01 00 00 	movb   $0x0,0x1b2c0(%edx)
   125be:	c6 45 e3 10          	movb   $0x10,-0x1d(%ebp)
			for (u8 y = 0; y < 16; ++y) // each font are 16 pixel height
			{
				u32 size = (u32)8 * _line_count[row] * _show_Bpp;
				memcpy(ptr + offset, _show_buffer + offset, size);
   125c2:	50                   	push   %eax
				u32 size = (u32)8 * _line_count[row] * _show_Bpp;
   125c3:	0f b7 84 12 c0 b3 01 	movzwl 0x1b3c0(%edx,%edx,1),%eax
   125ca:	00 
   125cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
   125ce:	0f b7 0d c2 b5 01 00 	movzwl 0x1b5c2,%ecx
   125d5:	0f af c1             	imul   %ecx,%eax
   125d8:	c1 e0 03             	shl    $0x3,%eax
				memcpy(ptr + offset, _show_buffer + offset, size);
   125db:	50                   	push   %eax
   125dc:	a1 a0 b2 01 00       	mov    0x1b2a0,%eax
   125e1:	01 d8                	add    %ebx,%eax
   125e3:	50                   	push   %eax
   125e4:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
   125e7:	50                   	push   %eax
   125e8:	e8 56 3e 00 00       	call   16443 <memcpy>
				offset += _show_Bpl;
   125ed:	0f b7 05 c0 b5 01 00 	movzwl 0x1b5c0,%eax
   125f4:	01 c3                	add    %eax,%ebx
			for (u8 y = 0; y < 16; ++y) // each font are 16 pixel height
   125f6:	83 c4 10             	add    $0x10,%esp
   125f9:	fe 4d e3             	decb   -0x1d(%ebp)
   125fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
   125ff:	75 c1                	jne    125c2 <update+0x69>
		for (u16 row = 0; row < _max_rows; ++row)
   12601:	47                   	inc    %edi
   12602:	eb 90                	jmp    12594 <update+0x3b>
			}
		}

		unmap_mem(ptr);
   12604:	83 ec 0c             	sub    $0xc,%esp
   12607:	56                   	push   %esi
   12608:	e8 95 30 00 00       	call   156a2 <unmap_mem>
		write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
   1260d:	e8 44 ff ff ff       	call   12556 <read_eflags>
   12612:	8b 55 e4             	mov    -0x1c(%ebp),%edx
   12615:	81 e2 00 02 00 00    	and    $0x200,%edx
   1261b:	09 d0                	or     %edx,%eax
	__asm__ __volatile__("pushl %0\n\t"
   1261d:	50                   	push   %eax
   1261e:	9d                   	popf   
}
   1261f:	83 c4 10             	add    $0x10,%esp
	}
}
   12622:	8d 65 f4             	lea    -0xc(%ebp),%esp
   12625:	5b                   	pop    %ebx
   12626:	5e                   	pop    %esi
   12627:	5f                   	pop    %edi
   12628:	5d                   	pop    %ebp
   12629:	c3                   	ret    
   1262a:	c3                   	ret    

0001262b <clear_line>:
		write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
	}
}

static void clear_line(u16 row, u16 begin)
{
   1262b:	55                   	push   %ebp
   1262c:	89 e5                	mov    %esp,%ebp
   1262e:	57                   	push   %edi
   1262f:	56                   	push   %esi
   12630:	53                   	push   %ebx
   12631:	83 ec 2c             	sub    $0x2c,%esp
   12634:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	if (_line_count[row] <= begin)
   12637:	0f b7 d8             	movzwl %ax,%ebx
   1263a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
   1263d:	66 39 84 1b c0 b3 01 	cmp    %ax,0x1b3c0(%ebx,%ebx,1)
   12644:	00 
   12645:	0f 86 12 01 00 00    	jbe    1275d <clear_line+0x132>
		return;

	u32 save_eflags = read_eflags();
   1264b:	e8 06 ff ff ff       	call   12556 <read_eflags>
   12650:	89 45 dc             	mov    %eax,-0x24(%ebp)
	__asm__ __volatile__("cli\n" ::
   12653:	fa                   	cli    
	disable();

	if (_GUI_mode)
	{
		void *ptr = map_mem(_show_mem_base + (u32)row * _show_Bpl * 16, _show_Bpl * 16);
		u32 offset = (u32)begin * _show_Bpp * 8;
   12654:	0f b7 7d e4          	movzwl -0x1c(%ebp),%edi
	if (_GUI_mode)
   12658:	80 3d b4 b2 01 00 00 	cmpb   $0x0,0x1b2b4
   1265f:	0f 84 95 00 00 00    	je     126fa <clear_line+0xcf>
		void *ptr = map_mem(_show_mem_base + (u32)row * _show_Bpl * 16, _show_Bpl * 16);
   12665:	52                   	push   %edx
   12666:	52                   	push   %edx
   12667:	0f b7 05 c0 b5 01 00 	movzwl 0x1b5c0,%eax
   1266e:	89 c2                	mov    %eax,%edx
   12670:	c1 e2 04             	shl    $0x4,%edx
   12673:	52                   	push   %edx
   12674:	0f af c3             	imul   %ebx,%eax
   12677:	c1 e0 04             	shl    $0x4,%eax
   1267a:	03 05 d0 b5 01 00    	add    0x1b5d0,%eax
   12680:	50                   	push   %eax
   12681:	e8 bc 2d 00 00       	call   15442 <map_mem>
		u32 offset = (u32)begin * _show_Bpp * 8;
   12686:	0f b7 35 c2 b5 01 00 	movzwl 0x1b5c2,%esi
   1268d:	0f af f7             	imul   %edi,%esi
   12690:	c1 e6 03             	shl    $0x3,%esi
		// ptr += (u32)row * _show_Bpl * 16 + (u32)begin * _show_Bpp * 8;
		for (u8 y = 0; y < 16; ++y) // each font are 16 pixel height
		{
			u8 *tmp = ptr + offset;
			for (u32 x = (u32)begin * 8; x < _line_count[row] * 8; ++x) // each row are _max_colums font or _max_colums*8 pixel
   12693:	c1 e7 03             	shl    $0x3,%edi
   12696:	89 7d d8             	mov    %edi,-0x28(%ebp)
   12699:	83 c4 10             	add    $0x10,%esp
   1269c:	c6 45 e3 10          	movb   $0x10,-0x1d(%ebp)
			u8 *tmp = ptr + offset;
   126a0:	8d 0c 30             	lea    (%eax,%esi,1),%ecx
			for (u32 x = (u32)begin * 8; x < _line_count[row] * 8; ++x) // each row are _max_colums font or _max_colums*8 pixel
   126a3:	8b 7d d8             	mov    -0x28(%ebp),%edi
   126a6:	0f b7 94 1b c0 b3 01 	movzwl 0x1b3c0(%ebx,%ebx,1),%edx
   126ad:	00 
   126ae:	c1 e2 03             	shl    $0x3,%edx
   126b1:	39 fa                	cmp    %edi,%edx
   126b3:	76 29                	jbe    126de <clear_line+0xb3>
   126b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
			{
				// for (u8 i = 0; i < 8; ++i) // each font are 8 pixel width
				// {
				// memcpy(ptr, &_show_bg, _show_Bpp);
				memcpy(tmp, &_show_bg, 3);
   126b8:	50                   	push   %eax
   126b9:	6a 03                	push   $0x3
   126bb:	68 a8 b2 01 00       	push   $0x1b2a8
   126c0:	51                   	push   %ecx
   126c1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
   126c4:	e8 7a 3d 00 00       	call   16443 <memcpy>
				tmp += _show_Bpp;
   126c9:	0f b7 15 c2 b5 01 00 	movzwl 0x1b5c2,%edx
   126d0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
   126d3:	01 d1                	add    %edx,%ecx
			for (u32 x = (u32)begin * 8; x < _line_count[row] * 8; ++x) // each row are _max_colums font or _max_colums*8 pixel
   126d5:	47                   	inc    %edi
   126d6:	83 c4 10             	add    $0x10,%esp
   126d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
   126dc:	eb c8                	jmp    126a6 <clear_line+0x7b>
				// for (u8 i = 0; i < _show_Bpp; ++i)
				// *ptr++ = (&_show_bg)[i];
				// }
			}
			offset += _show_Bpl;
   126de:	0f b7 15 c0 b5 01 00 	movzwl 0x1b5c0,%edx
   126e5:	01 d6                	add    %edx,%esi
		for (u8 y = 0; y < 16; ++y) // each font are 16 pixel height
   126e7:	fe 4d e3             	decb   -0x1d(%ebp)
   126ea:	75 b4                	jne    126a0 <clear_line+0x75>
			// ptr += _show_Bpl;
		}
		unmap_mem(ptr);
   126ec:	83 ec 0c             	sub    $0xc,%esp
   126ef:	50                   	push   %eax
   126f0:	e8 ad 2f 00 00       	call   156a2 <unmap_mem>
   126f5:	83 c4 10             	add    $0x10,%esp
   126f8:	eb 3f                	jmp    12739 <clear_line+0x10e>
	}
	else
	{
		u8 *ptr = _show_buffer + (u32)row * _show_Bpl + (u32)begin * _show_Bpp;
   126fa:	0f b7 0d c2 b5 01 00 	movzwl 0x1b5c2,%ecx
   12701:	0f b7 05 c0 b5 01 00 	movzwl 0x1b5c0,%eax
   12708:	0f af c3             	imul   %ebx,%eax
   1270b:	89 ca                	mov    %ecx,%edx
   1270d:	0f af d7             	imul   %edi,%edx
   12710:	01 d0                	add    %edx,%eax
   12712:	03 05 a0 b2 01 00    	add    0x1b2a0,%eax
		// ptr += (u32)row * _show_Bpl + (u32)begin * _show_Bpp;
		for (u32 i = begin; i < _line_count[row]; ++i)
		{
			*(u16 *)ptr = ((u16)_show_color << 8) | ' ';
   12718:	0f b6 15 b5 b2 01 00 	movzbl 0x1b2b5,%edx
   1271f:	c1 e2 08             	shl    $0x8,%edx
   12722:	83 ca 20             	or     $0x20,%edx
		for (u32 i = begin; i < _line_count[row]; ++i)
   12725:	0f b7 b4 1b c0 b3 01 	movzwl 0x1b3c0(%ebx,%ebx,1),%esi
   1272c:	00 
   1272d:	39 fe                	cmp    %edi,%esi
   1272f:	76 08                	jbe    12739 <clear_line+0x10e>
			*(u16 *)ptr = ((u16)_show_color << 8) | ' ';
   12731:	66 89 10             	mov    %dx,(%eax)
			ptr += _show_Bpp;
   12734:	01 c8                	add    %ecx,%eax
		for (u32 i = begin; i < _line_count[row]; ++i)
   12736:	47                   	inc    %edi
   12737:	eb ec                	jmp    12725 <clear_line+0xfa>
		}
	}

	write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
   12739:	e8 18 fe ff ff       	call   12556 <read_eflags>
   1273e:	8b 55 dc             	mov    -0x24(%ebp),%edx
   12741:	81 e2 00 02 00 00    	and    $0x200,%edx
   12747:	09 d0                	or     %edx,%eax
	__asm__ __volatile__("pushl %0\n\t"
   12749:	50                   	push   %eax
   1274a:	9d                   	popf   
	_line_count[row] = count;
   1274b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
   1274e:	66 89 84 1b c0 b3 01 	mov    %ax,0x1b3c0(%ebx,%ebx,1)
   12755:	00 
	_line_modified[row] = true;
   12756:	c6 83 c0 b2 01 00 01 	movb   $0x1,0x1b2c0(%ebx)

	set_line_count(row, begin);
}
   1275d:	8d 65 f4             	lea    -0xc(%ebp),%esp
   12760:	5b                   	pop    %ebx
   12761:	5e                   	pop    %esi
   12762:	5f                   	pop    %edi
   12763:	5d                   	pop    %ebp
   12764:	c3                   	ret    

00012765 <clear_rows>:

static void clear_rows(u16 start, u32 count)
{
   12765:	55                   	push   %ebp
   12766:	89 e5                	mov    %esp,%ebp
   12768:	57                   	push   %edi
   12769:	56                   	push   %esi
   1276a:	53                   	push   %ebx
   1276b:	83 ec 0c             	sub    $0xc,%esp
   1276e:	89 d6                	mov    %edx,%esi
   12770:	89 c7                	mov    %eax,%edi
	for (u32 i = 0; i < count; ++i)
   12772:	31 db                	xor    %ebx,%ebx
   12774:	39 f3                	cmp    %esi,%ebx
   12776:	74 10                	je     12788 <clear_rows+0x23>
		clear_line(start + i, 0);
   12778:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
   1277b:	0f b7 c0             	movzwl %ax,%eax
   1277e:	31 d2                	xor    %edx,%edx
   12780:	e8 a6 fe ff ff       	call   1262b <clear_line>
	for (u32 i = 0; i < count; ++i)
   12785:	43                   	inc    %ebx
   12786:	eb ec                	jmp    12774 <clear_rows+0xf>
}
   12788:	83 c4 0c             	add    $0xc,%esp
   1278b:	5b                   	pop    %ebx
   1278c:	5e                   	pop    %esi
   1278d:	5f                   	pop    %edi
   1278e:	5d                   	pop    %ebp
   1278f:	c3                   	ret    

00012790 <console_set_color>:
	printf("\nline_count=0x%x\nmax_colums=%d\nmax_rows=%d\nbpp=%d\nBpp=%d\nBpl=%d\n",
		   _line_count, _max_colums, _max_rows, _show_bpp, _show_Bpp, _show_Bpl);
}

void console_set_color(u32 bg, u32 fg)
{
   12790:	55                   	push   %ebp
   12791:	89 e5                	mov    %esp,%ebp
   12793:	56                   	push   %esi
   12794:	53                   	push   %ebx
	if (_GUI_mode)
	{
		_show_bg = bg & 0xFFFFFF;
   12795:	8b 4d 08             	mov    0x8(%ebp),%ecx
   12798:	81 e1 ff ff ff 00    	and    $0xffffff,%ecx
		_show_fg = fg & 0xFFFFFF;
   1279e:	8b 55 0c             	mov    0xc(%ebp),%edx
   127a1:	81 e2 ff ff ff 00    	and    $0xffffff,%edx
	if (_GUI_mode)
   127a7:	80 3d b4 b2 01 00 00 	cmpb   $0x0,0x1b2b4
   127ae:	74 0e                	je     127be <console_set_color+0x2e>
		_show_bg = bg & 0xFFFFFF;
   127b0:	89 0d a8 b2 01 00    	mov    %ecx,0x1b2a8
		_show_fg = fg & 0xFFFFFF;
   127b6:	89 15 a4 b2 01 00    	mov    %edx,0x1b2a4
   127bc:	eb 71                	jmp    1282f <console_set_color+0x9f>
	** KRGB-IRGB
	** K-闪烁，I-亮、浅
	*/
		bg &= 0xFFFFFF;
		fg &= 0xFFFFFF;
		bg = (bg >> 21 & 0x4) | (bg >> 13 & 0x2) | (bg >> 7 & 0x1);
   127be:	89 c8                	mov    %ecx,%eax
   127c0:	c1 e8 15             	shr    $0x15,%eax
   127c3:	83 e0 04             	and    $0x4,%eax
   127c6:	89 cb                	mov    %ecx,%ebx
   127c8:	c1 eb 0d             	shr    $0xd,%ebx
   127cb:	83 e3 02             	and    $0x2,%ebx
   127ce:	09 d8                	or     %ebx,%eax
   127d0:	c1 e9 07             	shr    $0x7,%ecx
   127d3:	83 e1 01             	and    $0x1,%ecx
   127d6:	09 c8                	or     %ecx,%eax
		fg = (fg >> 16 == 0xff || (fg >> 8 & 0xff) == 0xff || (fg & 0xff) == 0xff) << 3 | (fg >> 21 & 0x4) | (fg >> 13 & 0x2) | (fg >> 7 & 0x1);
   127d8:	89 d3                	mov    %edx,%ebx
   127da:	c1 eb 10             	shr    $0x10,%ebx
   127dd:	b9 01 00 00 00       	mov    $0x1,%ecx
   127e2:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
   127e8:	74 1b                	je     12805 <console_set_color+0x75>
   127ea:	0f b6 de             	movzbl %dh,%ebx
   127ed:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
   127f3:	74 10                	je     12805 <console_set_color+0x75>
   127f5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
   127f9:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
   127ff:	0f 94 c1             	sete   %cl
   12802:	0f b6 c9             	movzbl %cl,%ecx
   12805:	89 d3                	mov    %edx,%ebx
   12807:	c1 eb 15             	shr    $0x15,%ebx
   1280a:	83 e3 04             	and    $0x4,%ebx
   1280d:	89 d6                	mov    %edx,%esi
   1280f:	c1 ee 0d             	shr    $0xd,%esi
   12812:	83 e6 02             	and    $0x2,%esi
   12815:	09 f3                	or     %esi,%ebx
   12817:	c1 ea 07             	shr    $0x7,%edx
   1281a:	83 e2 01             	and    $0x1,%edx
   1281d:	09 da                	or     %ebx,%edx
   1281f:	c1 e1 03             	shl    $0x3,%ecx
   12822:	09 ca                	or     %ecx,%edx

		_show_color = MAKE_COLOR(bg, fg);
   12824:	c1 e0 04             	shl    $0x4,%eax
   12827:	09 c2                	or     %eax,%edx
   12829:	88 15 b5 b2 01 00    	mov    %dl,0x1b2b5
		// _show_color = MAKE_COLOR(bg & 0xF, fg & 0xF);
	}
}
   1282f:	5b                   	pop    %ebx
   12830:	5e                   	pop    %esi
   12831:	5d                   	pop    %ebp
   12832:	c3                   	ret    

00012833 <console_setup>:
{
   12833:	55                   	push   %ebp
   12834:	89 e5                	mov    %esp,%ebp
   12836:	57                   	push   %edi
   12837:	56                   	push   %esi
   12838:	53                   	push   %ebx
   12839:	83 ec 1c             	sub    $0x1c,%esp
   1283c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	_show_mem_base = console_info->show_mem_base;
   1283f:	8b 51 09             	mov    0x9(%ecx),%edx
   12842:	89 15 d0 b5 01 00    	mov    %edx,0x1b5d0
	_show_bpp = console_info->bpp;
   12848:	0f b6 41 13          	movzbl 0x13(%ecx),%eax
   1284c:	66 a3 c4 b5 01 00    	mov    %ax,0x1b5c4
	_show_Bpp = _show_bpp / 8;
   12852:	66 c1 e8 03          	shr    $0x3,%ax
   12856:	66 a3 c2 b5 01 00    	mov    %ax,0x1b5c2
	_show_Bpl = console_info->Bpl;
   1285c:	66 8b 71 14          	mov    0x14(%ecx),%si
   12860:	66 89 35 c0 b5 01 00 	mov    %si,0x1b5c0
	_cur_env = CONSOLE_ENV_NORMAL;
   12867:	c7 05 d8 b5 01 00 00 	movl   $0x0,0x1b5d8
   1286e:	00 00 00 
		_max_x = console_info->width;
   12871:	66 8b 59 05          	mov    0x5(%ecx),%bx
		_max_y = console_info->height;
   12875:	0f b7 41 07          	movzwl 0x7(%ecx),%eax
	if (console_info->GUI)
   12879:	80 39 00             	cmpb   $0x0,(%ecx)
   1287c:	0f 84 c8 00 00 00    	je     1294a <console_setup+0x117>
		_max_x = console_info->width;
   12882:	66 89 1d ae b2 01 00 	mov    %bx,0x1b2ae
		_max_y = console_info->height;
   12889:	66 a3 ac b2 01 00    	mov    %ax,0x1b2ac
		_max_colums = _max_x / 8;
   1288f:	66 c1 eb 03          	shr    $0x3,%bx
   12893:	66 89 1d c8 b5 01 00 	mov    %bx,0x1b5c8
		_max_rows = _max_y / 16;
   1289a:	89 c2                	mov    %eax,%edx
   1289c:	66 c1 ea 04          	shr    $0x4,%dx
   128a0:	66 89 15 c6 b5 01 00 	mov    %dx,0x1b5c6
		_show_mem_size = _show_Bpl * _max_y;
   128a7:	0f b7 ce             	movzwl %si,%ecx
   128aa:	0f af c1             	imul   %ecx,%eax
   128ad:	a3 b0 b2 01 00       	mov    %eax,0x1b2b0
		_show_buffer = alloc_page(_max_rows * 16 * _show_Bpl, normal_phy_mem);
   128b2:	53                   	push   %ebx
   128b3:	53                   	push   %ebx
   128b4:	6a 01                	push   $0x1
   128b6:	0f b7 d2             	movzwl %dx,%edx
   128b9:	0f af d1             	imul   %ecx,%edx
   128bc:	c1 e2 04             	shl    $0x4,%edx
   128bf:	52                   	push   %edx
   128c0:	e8 31 2d 00 00       	call   155f6 <alloc_page>
   128c5:	a3 a0 b2 01 00       	mov    %eax,0x1b2a0
		_GUI_mode = true;
   128ca:	c6 05 b4 b2 01 00 01 	movb   $0x1,0x1b2b4
		if (_max_rows * 16 != _max_y)
   128d1:	0f b7 05 c6 b5 01 00 	movzwl 0x1b5c6,%eax
   128d8:	c1 e0 04             	shl    $0x4,%eax
   128db:	89 c2                	mov    %eax,%edx
   128dd:	0f b7 1d ac b2 01 00 	movzwl 0x1b2ac,%ebx
   128e4:	83 c4 10             	add    $0x10,%esp
   128e7:	39 d8                	cmp    %ebx,%eax
   128e9:	74 72                	je     1295d <console_setup+0x12a>
			u32 y = _max_rows * 16, index = 0, count = (_max_y - y) * _max_x;
   128eb:	29 c3                	sub    %eax,%ebx
   128ed:	0f b7 05 ae b2 01 00 	movzwl 0x1b2ae,%eax
   128f4:	0f af d8             	imul   %eax,%ebx
			u8 *ptr = map_mem(_show_mem_base + y * _show_Bpl, count * _show_Bpp);
   128f7:	51                   	push   %ecx
   128f8:	51                   	push   %ecx
   128f9:	0f b7 05 c2 b5 01 00 	movzwl 0x1b5c2,%eax
   12900:	0f af c3             	imul   %ebx,%eax
   12903:	50                   	push   %eax
   12904:	0f b7 05 c0 b5 01 00 	movzwl 0x1b5c0,%eax
   1290b:	0f af c2             	imul   %edx,%eax
   1290e:	03 05 d0 b5 01 00    	add    0x1b5d0,%eax
   12914:	50                   	push   %eax
   12915:	e8 28 2b 00 00       	call   15442 <map_mem>
   1291a:	89 c2                	mov    %eax,%edx
				index += _show_Bpp;
   1291c:	0f b7 35 c2 b5 01 00 	movzwl 0x1b5c2,%esi
			for (u32 i = 0; i < count; ++i)
   12923:	83 c4 10             	add    $0x10,%esp
   12926:	31 c9                	xor    %ecx,%ecx
   12928:	39 d9                	cmp    %ebx,%ecx
   1292a:	74 10                	je     1293c <console_setup+0x109>
				ptr[index] = 0x00;
   1292c:	c6 00 00             	movb   $0x0,(%eax)
				ptr[index + 1] = 0xff;
   1292f:	c6 40 01 ff          	movb   $0xff,0x1(%eax)
				ptr[index + 2] = 0x00;
   12933:	c6 40 02 00          	movb   $0x0,0x2(%eax)
			for (u32 i = 0; i < count; ++i)
   12937:	41                   	inc    %ecx
   12938:	01 f0                	add    %esi,%eax
   1293a:	eb ec                	jmp    12928 <console_setup+0xf5>
			unmap_mem(ptr);
   1293c:	83 ec 0c             	sub    $0xc,%esp
   1293f:	52                   	push   %edx
   12940:	e8 5d 2d 00 00       	call   156a2 <unmap_mem>
   12945:	83 c4 10             	add    $0x10,%esp
   12948:	eb 13                	jmp    1295d <console_setup+0x12a>
		_show_buffer = (u8 *)_show_mem_base;
   1294a:	89 15 a0 b2 01 00    	mov    %edx,0x1b2a0
		_max_colums = console_info->width;
   12950:	66 89 1d c8 b5 01 00 	mov    %bx,0x1b5c8
		_max_rows = console_info->height;
   12957:	66 a3 c6 b5 01 00    	mov    %ax,0x1b5c6
	console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
   1295d:	50                   	push   %eax
   1295e:	50                   	push   %eax
   1295f:	68 d3 d3 d3 00       	push   $0xd3d3d3
   12964:	6a 00                	push   $0x0
   12966:	e8 25 fe ff ff       	call   12790 <console_set_color>
	if (_cursor_visible == visible)
   1296b:	83 c4 10             	add    $0x10,%esp
   1296e:	80 3d d4 b5 01 00 00 	cmpb   $0x0,0x1b5d4
   12975:	75 4f                	jne    129c6 <console_setup+0x193>
	_cursor_visible = visible;
   12977:	c6 05 d4 b5 01 00 01 	movb   $0x1,0x1b5d4
	if (_GUI_mode)
   1297e:	80 3d b4 b2 01 00 00 	cmpb   $0x0,0x1b2b4
   12985:	75 3f                	jne    129c6 <console_setup+0x193>
		u32 save_eflags = read_eflags();
   12987:	e8 ca fb ff ff       	call   12556 <read_eflags>
   1298c:	89 c1                	mov    %eax,%ecx
	__asm__ __volatile__("cli\n" ::
   1298e:	fa                   	cli    
   1298f:	be 0a 00 00 00       	mov    $0xa,%esi
   12994:	bf d4 03 00 00       	mov    $0x3d4,%edi
   12999:	89 f0                	mov    %esi,%eax
   1299b:	89 fa                	mov    %edi,%edx
   1299d:	ee                   	out    %al,(%dx)
    __asm__ volatile("inb %1, %0"
   1299e:	bb d5 03 00 00       	mov    $0x3d5,%ebx
   129a3:	89 da                	mov    %ebx,%edx
   129a5:	ec                   	in     (%dx),%al
   129a6:	88 45 e7             	mov    %al,-0x19(%ebp)
    __asm__ volatile("outb %0, %1"
   129a9:	89 f0                	mov    %esi,%eax
   129ab:	89 fa                	mov    %edi,%edx
   129ad:	ee                   	out    %al,(%dx)
			data &= ~CRTC_CURSOR_START_CD;
   129ae:	8a 45 e7             	mov    -0x19(%ebp),%al
   129b1:	83 e0 ef             	and    $0xffffffef,%eax
   129b4:	89 da                	mov    %ebx,%edx
   129b6:	ee                   	out    %al,(%dx)
		write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
   129b7:	e8 9a fb ff ff       	call   12556 <read_eflags>
   129bc:	81 e1 00 02 00 00    	and    $0x200,%ecx
   129c2:	09 c8                	or     %ecx,%eax
	__asm__ __volatile__("pushl %0\n\t"
   129c4:	50                   	push   %eax
   129c5:	9d                   	popf   
}
   129c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
   129c9:	5b                   	pop    %ebx
   129ca:	5e                   	pop    %esi
   129cb:	5f                   	pop    %edi
   129cc:	5d                   	pop    %ebp
   129cd:	c3                   	ret    

000129ce <console_set_env>:

enum console_env console_set_env(enum console_env env)
{
   129ce:	55                   	push   %ebp
   129cf:	89 e5                	mov    %esp,%ebp
   129d1:	8b 55 08             	mov    0x8(%ebp),%edx
	if(_cur_env == env) return env;
   129d4:	a1 d8 b5 01 00       	mov    0x1b5d8,%eax
   129d9:	39 d0                	cmp    %edx,%eax
   129db:	74 06                	je     129e3 <console_set_env+0x15>

	enum console_env old = _cur_env;
	_cur_env = env;
   129dd:	89 15 d8 b5 01 00    	mov    %edx,0x1b5d8
	return old;
}
   129e3:	5d                   	pop    %ebp
   129e4:	c3                   	ret    

000129e5 <console_clear_screen>:

void console_clear_screen(void)
{
   129e5:	55                   	push   %ebp
   129e6:	89 e5                	mov    %esp,%ebp
   129e8:	83 ec 08             	sub    $0x8,%esp
	clear_rows(0, _max_rows);
   129eb:	0f b7 15 c6 b5 01 00 	movzwl 0x1b5c6,%edx
   129f2:	31 c0                	xor    %eax,%eax
   129f4:	e8 6c fd ff ff       	call   12765 <clear_rows>
	_show_x = _show_y = 0;
   129f9:	66 c7 05 ca b5 01 00 	movw   $0x0,0x1b5ca
   12a00:	00 00 
   12a02:	66 c7 05 cc b5 01 00 	movw   $0x0,0x1b5cc
   12a09:	00 00 
}
   12a0b:	c9                   	leave  
   12a0c:	c3                   	ret    

00012a0d <console_get_print_size>:

void console_get_print_size(u32 *colums, u32 *rows)
{
   12a0d:	55                   	push   %ebp
   12a0e:	89 e5                	mov    %esp,%ebp
	*colums = _max_colums;
   12a10:	0f b7 15 c8 b5 01 00 	movzwl 0x1b5c8,%edx
   12a17:	8b 45 08             	mov    0x8(%ebp),%eax
   12a1a:	89 10                	mov    %edx,(%eax)
	*rows = _max_rows;
   12a1c:	0f b7 15 c6 b5 01 00 	movzwl 0x1b5c6,%edx
   12a23:	8b 45 0c             	mov    0xc(%ebp),%eax
   12a26:	89 10                	mov    %edx,(%eax)
}
   12a28:	5d                   	pop    %ebp
   12a29:	c3                   	ret    

00012a2a <console_get_size>:

void console_get_size(u32 *width, u32 *height)
{
   12a2a:	55                   	push   %ebp
   12a2b:	89 e5                	mov    %esp,%ebp
   12a2d:	8b 55 08             	mov    0x8(%ebp),%edx
   12a30:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (_GUI_mode)
   12a33:	80 3d b4 b2 01 00 00 	cmpb   $0x0,0x1b2b4
   12a3a:	74 12                	je     12a4e <console_get_size+0x24>
	{
		*width = _max_x;
   12a3c:	0f b7 0d ae b2 01 00 	movzwl 0x1b2ae,%ecx
   12a43:	89 0a                	mov    %ecx,(%edx)
		*height = _max_y;
   12a45:	0f b7 15 ac b2 01 00 	movzwl 0x1b2ac,%edx
   12a4c:	eb 10                	jmp    12a5e <console_get_size+0x34>
	*colums = _max_colums;
   12a4e:	0f b7 0d c8 b5 01 00 	movzwl 0x1b5c8,%ecx
   12a55:	89 0a                	mov    %ecx,(%edx)
	*rows = _max_rows;
   12a57:	0f b7 15 c6 b5 01 00 	movzwl 0x1b5c6,%edx
   12a5e:	89 10                	mov    %edx,(%eax)
	}
	else
	{
		console_get_print_size(width, height);
	}
}
   12a60:	5d                   	pop    %ebp
   12a61:	c3                   	ret    

00012a62 <print_char>:

void print_char(char c)
{
   12a62:	55                   	push   %ebp
   12a63:	89 e5                	mov    %esp,%ebp
   12a65:	57                   	push   %edi
   12a66:	56                   	push   %esi
   12a67:	53                   	push   %ebx
   12a68:	83 ec 2c             	sub    $0x2c,%esp
   12a6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
   12a6e:	88 d8                	mov    %bl,%al
	bool do_self = !_have_parent;
	if (do_self)
   12a70:	8a 0d b6 b2 01 00    	mov    0x1b2b6,%cl
   12a76:	80 f1 01             	xor    $0x1,%cl
   12a79:	88 4d e3             	mov    %cl,-0x1d(%ebp)
   12a7c:	74 07                	je     12a85 <print_char+0x23>
		_have_parent = true;
   12a7e:	c6 05 b6 b2 01 00 01 	movb   $0x1,0x1b2b6
	if (c == '\r' || c == '\n')
	{
		_show_x = 0;
		if (c == '\n')
		{
			++_show_y;
   12a85:	0f b7 35 ca b5 01 00 	movzwl 0x1b5ca,%esi
	if (c == '\r' || c == '\n')
   12a8c:	80 fb 0a             	cmp    $0xa,%bl
   12a8f:	74 05                	je     12a96 <print_char+0x34>
   12a91:	80 fb 0d             	cmp    $0xd,%bl
   12a94:	75 1f                	jne    12ab5 <print_char+0x53>
		_show_x = 0;
   12a96:	66 c7 05 cc b5 01 00 	movw   $0x0,0x1b5cc
   12a9d:	00 00 
		if (c == '\n')
   12a9f:	80 fb 0a             	cmp    $0xa,%bl
   12aa2:	0f 85 3f 01 00 00    	jne    12be7 <print_char+0x185>
			++_show_y;
   12aa8:	46                   	inc    %esi
   12aa9:	66 89 35 ca b5 01 00 	mov    %si,0x1b5ca
   12ab0:	e9 32 01 00 00       	jmp    12be7 <print_char+0x185>
		}
	}
	else if (c == '\b' && _show_x)
   12ab5:	0f b7 0d cc b5 01 00 	movzwl 0x1b5cc,%ecx
   12abc:	80 fb 08             	cmp    $0x8,%bl
   12abf:	75 12                	jne    12ad3 <print_char+0x71>
   12ac1:	66 85 c9             	test   %cx,%cx
   12ac4:	74 3d                	je     12b03 <print_char+0xa1>
	{
		--_show_x;
   12ac6:	49                   	dec    %ecx
   12ac7:	66 89 0d cc b5 01 00 	mov    %cx,0x1b5cc
   12ace:	e9 14 01 00 00       	jmp    12be7 <print_char+0x185>
		// --_line_count[_show_y];
	}
	else
	{
		if (c == '\t')
   12ad3:	80 fb 09             	cmp    $0x9,%bl
   12ad6:	75 23                	jne    12afb <print_char+0x99>
		{
			_show_x += MIN(_max_colums - _show_x, 4);
   12ad8:	0f b7 05 c8 b5 01 00 	movzwl 0x1b5c8,%eax
   12adf:	0f b7 d1             	movzwl %cx,%edx
   12ae2:	29 d0                	sub    %edx,%eax
   12ae4:	83 f8 04             	cmp    $0x4,%eax
   12ae7:	7e 05                	jle    12aee <print_char+0x8c>
   12ae9:	b8 04 00 00 00       	mov    $0x4,%eax
   12aee:	01 c8                	add    %ecx,%eax
   12af0:	66 a3 cc b5 01 00    	mov    %ax,0x1b5cc
   12af6:	e9 b4 00 00 00       	jmp    12baf <print_char+0x14d>
		}
		else
		{
			if (c < 32 || c > 126)
   12afb:	83 eb 20             	sub    $0x20,%ebx
   12afe:	80 fb 5e             	cmp    $0x5e,%bl
   12b01:	76 02                	jbe    12b05 <print_char+0xa3>
			{
				c = ' ';
   12b03:	b0 20                	mov    $0x20,%al
		u8 *ptr = _show_buffer + y * _show_Bpl * 16 + x * _show_Bpp * 8;
   12b05:	0f b7 15 c0 b5 01 00 	movzwl 0x1b5c0,%edx
   12b0c:	0f af d6             	imul   %esi,%edx
   12b0f:	0f b7 1d c2 b5 01 00 	movzwl 0x1b5c2,%ebx
   12b16:	0f af cb             	imul   %ebx,%ecx
   12b19:	8b 1d a0 b2 01 00    	mov    0x1b2a0,%ebx
	if (_GUI_mode)
   12b1f:	80 3d b4 b2 01 00 00 	cmpb   $0x0,0x1b2b4
   12b26:	74 72                	je     12b9a <print_char+0x138>
		const u8 *font_ptr = &fontdata_8x16[(c - 32) * 16];
   12b28:	83 e8 20             	sub    $0x20,%eax
   12b2b:	0f be c0             	movsbl %al,%eax
   12b2e:	c1 e0 04             	shl    $0x4,%eax
   12b31:	05 c0 83 01 00       	add    $0x183c0,%eax
   12b36:	89 45 dc             	mov    %eax,-0x24(%ebp)
		u8 *ptr = _show_buffer + y * _show_Bpl * 16 + x * _show_Bpp * 8;
   12b39:	01 d2                	add    %edx,%edx
   12b3b:	01 d1                	add    %edx,%ecx
   12b3d:	8d 3c cb             	lea    (%ebx,%ecx,8),%edi
   12b40:	31 f6                	xor    %esi,%esi
				c = ' ';
   12b42:	89 fb                	mov    %edi,%ebx
   12b44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
				if ((font_ptr[i] << j) & 0x80)
   12b4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
   12b4e:	0f b6 14 30          	movzbl (%eax,%esi,1),%edx
   12b52:	8a 4d e4             	mov    -0x1c(%ebp),%cl
   12b55:	d3 e2                	shl    %cl,%edx
   12b57:	80 e2 80             	and    $0x80,%dl
   12b5a:	74 0a                	je     12b66 <print_char+0x104>
					memcpy(tmp, &_show_fg, 3);
   12b5c:	50                   	push   %eax
   12b5d:	6a 03                	push   $0x3
   12b5f:	68 a4 b2 01 00       	push   $0x1b2a4
   12b64:	eb 08                	jmp    12b6e <print_char+0x10c>
					memcpy(tmp, &_show_bg, 3);
   12b66:	51                   	push   %ecx
   12b67:	6a 03                	push   $0x3
   12b69:	68 a8 b2 01 00       	push   $0x1b2a8
   12b6e:	53                   	push   %ebx
   12b6f:	e8 cf 38 00 00       	call   16443 <memcpy>
   12b74:	83 c4 10             	add    $0x10,%esp
				tmp += _show_Bpp;
   12b77:	0f b7 15 c2 b5 01 00 	movzwl 0x1b5c2,%edx
   12b7e:	01 d3                	add    %edx,%ebx
			for (u8 j = 0; j < 8; ++j)
   12b80:	ff 45 e4             	incl   -0x1c(%ebp)
   12b83:	83 7d e4 08          	cmpl   $0x8,-0x1c(%ebp)
   12b87:	75 c2                	jne    12b4b <print_char+0xe9>
			ptr += _show_Bpl;
   12b89:	0f b7 05 c0 b5 01 00 	movzwl 0x1b5c0,%eax
   12b90:	01 c7                	add    %eax,%edi
		for (u8 i = 0; i < 16; ++i)
   12b92:	46                   	inc    %esi
   12b93:	83 fe 10             	cmp    $0x10,%esi
   12b96:	75 aa                	jne    12b42 <print_char+0xe0>
   12b98:	eb 0e                	jmp    12ba8 <print_char+0x146>
		u32 offset = y * _show_Bpl + x * _show_Bpp;
   12b9a:	01 ca                	add    %ecx,%edx
		_show_buffer[offset++] = c;
   12b9c:	88 04 13             	mov    %al,(%ebx,%edx,1)
		_show_buffer[offset] = _show_color;
   12b9f:	a0 b5 b2 01 00       	mov    0x1b2b5,%al
   12ba4:	88 44 13 01          	mov    %al,0x1(%ebx,%edx,1)
			}

			draw_font(_show_x, _show_y, c);
			++_show_x;
   12ba8:	66 ff 05 cc b5 01 00 	incw   0x1b5cc
		}

		set_line_count(_show_y, _show_x);
   12baf:	66 8b 15 cc b5 01 00 	mov    0x1b5cc,%dx
   12bb6:	0f b7 0d ca b5 01 00 	movzwl 0x1b5ca,%ecx
   12bbd:	89 c8                	mov    %ecx,%eax
	_line_count[row] = count;
   12bbf:	66 89 94 09 c0 b3 01 	mov    %dx,0x1b3c0(%ecx,%ecx,1)
   12bc6:	00 
	_line_modified[row] = true;
   12bc7:	c6 81 c0 b2 01 00 01 	movb   $0x1,0x1b2c0(%ecx)
		if (_show_x == _max_colums)
   12bce:	66 3b 15 c8 b5 01 00 	cmp    0x1b5c8,%dx
   12bd5:	75 10                	jne    12be7 <print_char+0x185>
		{
			_show_x = 0;
   12bd7:	66 c7 05 cc b5 01 00 	movw   $0x0,0x1b5cc
   12bde:	00 00 
			++_show_y;
   12be0:	40                   	inc    %eax
   12be1:	66 a3 ca b5 01 00    	mov    %ax,0x1b5ca
		}
	}

	if (_show_y == _max_rows)
   12be7:	0f b7 05 ca b5 01 00 	movzwl 0x1b5ca,%eax
   12bee:	0f b7 15 c6 b5 01 00 	movzwl 0x1b5c6,%edx
   12bf5:	66 39 d0             	cmp    %dx,%ax
   12bf8:	0f 85 90 01 00 00    	jne    12d8e <print_char+0x32c>
	if (do_self)
   12bfe:	8a 1d b6 b2 01 00    	mov    0x1b2b6,%bl
   12c04:	80 f3 01             	xor    $0x1,%bl
   12c07:	88 5d dc             	mov    %bl,-0x24(%ebp)
   12c0a:	74 07                	je     12c13 <print_char+0x1b1>
		_have_parent = true;
   12c0c:	c6 05 b6 b2 01 00 01 	movb   $0x1,0x1b2b6
	if (_show_y < rows)
   12c13:	66 85 c0             	test   %ax,%ax
   12c16:	75 10                	jne    12c28 <print_char+0x1c6>
		_show_y = 0;
   12c18:	66 c7 05 ca b5 01 00 	movw   $0x0,0x1b5ca
   12c1f:	00 00 
		clear_rows(0, _max_rows);
   12c21:	31 c0                	xor    %eax,%eax
   12c23:	e9 35 01 00 00       	jmp    12d5d <print_char+0x2fb>
		_show_y -= rows;
   12c28:	8d 48 ff             	lea    -0x1(%eax),%ecx
   12c2b:	66 89 0d ca b5 01 00 	mov    %cx,0x1b5ca
		u8 *ptr_src = _show_buffer, *ptr_dst = _show_buffer;
   12c32:	8b 1d a0 b2 01 00    	mov    0x1b2a0,%ebx
		u16 src_start = rows, dst_start = 0, count = MIN(_show_y + 1, _max_rows - 1);
   12c38:	8d 7a ff             	lea    -0x1(%edx),%edi
   12c3b:	39 c7                	cmp    %eax,%edi
   12c3d:	7e 02                	jle    12c41 <print_char+0x1df>
   12c3f:	89 c7                	mov    %eax,%edi
		if (_GUI_mode)
   12c41:	80 3d b4 b2 01 00 00 	cmpb   $0x0,0x1b2b4
   12c48:	0f b7 35 c0 b5 01 00 	movzwl 0x1b5c0,%esi
   12c4f:	0f 84 91 00 00 00    	je     12ce6 <print_char+0x284>
			ptr_src += src_start * _show_Bpl * 16;
   12c55:	c1 e6 04             	shl    $0x4,%esi
   12c58:	8d 04 33             	lea    (%ebx,%esi,1),%eax
   12c5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			for (u32 i = 0; i < count; ++i)
   12c5e:	31 f6                	xor    %esi,%esi
   12c60:	0f b7 c7             	movzwl %di,%eax
   12c63:	89 45 d8             	mov    %eax,-0x28(%ebp)
   12c66:	8d 46 01             	lea    0x1(%esi),%eax
   12c69:	3b 75 d8             	cmp    -0x28(%ebp),%esi
   12c6c:	0f 83 82 00 00 00    	jae    12cf4 <print_char+0x292>
				u32 size = (u32)_show_Bpp * 8 * _line_count[src_start];
   12c72:	0f b7 c0             	movzwl %ax,%eax
   12c75:	0f b7 3d c2 b5 01 00 	movzwl 0x1b5c2,%edi
   12c7c:	0f b7 94 00 c0 b3 01 	movzwl 0x1b3c0(%eax,%eax,1),%edx
   12c83:	00 
   12c84:	0f af fa             	imul   %edx,%edi
   12c87:	c1 e7 03             	shl    $0x3,%edi
   12c8a:	b2 10                	mov    $0x10,%dl
   12c8c:	88 55 e2             	mov    %dl,-0x1e(%ebp)
   12c8f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					memcpy(ptr_dst, ptr_src, size);
   12c92:	52                   	push   %edx
   12c93:	57                   	push   %edi
   12c94:	ff 75 e4             	push   -0x1c(%ebp)
   12c97:	53                   	push   %ebx
   12c98:	e8 a6 37 00 00       	call   16443 <memcpy>
					ptr_dst += _show_Bpl;
   12c9d:	0f b7 0d c0 b5 01 00 	movzwl 0x1b5c0,%ecx
   12ca4:	01 cb                	add    %ecx,%ebx
					ptr_src += _show_Bpl;
   12ca6:	01 4d e4             	add    %ecx,-0x1c(%ebp)
				for (u8 y = 0; y < 16; ++y) // each font are 16 pixel height
   12ca9:	83 c4 10             	add    $0x10,%esp
   12cac:	8a 55 e2             	mov    -0x1e(%ebp),%dl
   12caf:	fe ca                	dec    %dl
   12cb1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   12cb4:	75 d6                	jne    12c8c <print_char+0x22a>
				if (_line_count[dst_start] > _line_count[src_start])
   12cb6:	66 8b 94 00 c0 b3 01 	mov    0x1b3c0(%eax,%eax,1),%dx
   12cbd:	00 
   12cbe:	66 39 94 36 c0 b3 01 	cmp    %dx,0x1b3c0(%esi,%esi,1)
   12cc5:	00 
   12cc6:	76 0c                	jbe    12cd4 <print_char+0x272>
					clear_line(dst_start, _line_count[src_start]);
   12cc8:	0f b7 d2             	movzwl %dx,%edx
   12ccb:	89 f0                	mov    %esi,%eax
   12ccd:	e8 59 f9 ff ff       	call   1262b <clear_line>
   12cd2:	eb 0f                	jmp    12ce3 <print_char+0x281>
	_line_count[row] = count;
   12cd4:	66 89 94 36 c0 b3 01 	mov    %dx,0x1b3c0(%esi,%esi,1)
   12cdb:	00 
	_line_modified[row] = true;
   12cdc:	c6 86 c0 b2 01 00 01 	movb   $0x1,0x1b2c0(%esi)
			for (u32 i = 0; i < count; ++i)
   12ce3:	46                   	inc    %esi
   12ce4:	eb 80                	jmp    12c66 <print_char+0x204>
		u16 src_start = rows, dst_start = 0, count = MIN(_show_y + 1, _max_rows - 1);
   12ce6:	66 89 7d e4          	mov    %di,-0x1c(%ebp)
			ptr_src += src_start * _show_Bpl;
   12cea:	01 de                	add    %ebx,%esi
			for (u16 i = 0; i < count; ++i)
   12cec:	31 ff                	xor    %edi,%edi
   12cee:	66 39 7d e4          	cmp    %di,-0x1c(%ebp)
   12cf2:	77 1a                	ja     12d0e <print_char+0x2ac>
		if (_show_x == 0)
   12cf4:	0f b7 15 cc b5 01 00 	movzwl 0x1b5cc,%edx
   12cfb:	66 85 d2             	test   %dx,%dx
   12cfe:	75 64                	jne    12d64 <print_char+0x302>
			clear_rows(_show_y, rows);
   12d00:	0f b7 05 ca b5 01 00 	movzwl 0x1b5ca,%eax
   12d07:	ba 01 00 00 00       	mov    $0x1,%edx
   12d0c:	eb 4f                	jmp    12d5d <print_char+0x2fb>
				memcpy(ptr_dst, ptr_src, _show_Bpp * _line_count[src_start]);
   12d0e:	50                   	push   %eax
   12d0f:	0f b7 15 c2 b5 01 00 	movzwl 0x1b5c2,%edx
   12d16:	0f b7 8c 3f c2 b3 01 	movzwl 0x1b3c2(%edi,%edi,1),%ecx
   12d1d:	00 
   12d1e:	0f af d1             	imul   %ecx,%edx
   12d21:	52                   	push   %edx
   12d22:	56                   	push   %esi
   12d23:	53                   	push   %ebx
   12d24:	e8 1a 37 00 00       	call   16443 <memcpy>
				ptr_dst += _show_Bpl;
   12d29:	0f b7 15 c0 b5 01 00 	movzwl 0x1b5c0,%edx
   12d30:	01 d3                	add    %edx,%ebx
				ptr_src += _show_Bpl;
   12d32:	01 d6                	add    %edx,%esi
				if (_line_count[dst_start] > _line_count[src_start])
   12d34:	0f b7 94 3f c2 b3 01 	movzwl 0x1b3c2(%edi,%edi,1),%edx
   12d3b:	00 
   12d3c:	83 c4 10             	add    $0x10,%esp
   12d3f:	66 39 94 3f c0 b3 01 	cmp    %dx,0x1b3c0(%edi,%edi,1)
   12d46:	00 
   12d47:	76 09                	jbe    12d52 <print_char+0x2f0>
					clear_line(dst_start, _line_count[src_start]);
   12d49:	89 f8                	mov    %edi,%eax
   12d4b:	e8 db f8 ff ff       	call   1262b <clear_line>
   12d50:	eb 08                	jmp    12d5a <print_char+0x2f8>
					_line_count[dst_start] = _line_count[src_start];
   12d52:	66 89 94 3f c0 b3 01 	mov    %dx,0x1b3c0(%edi,%edi,1)
   12d59:	00 
			for (u16 i = 0; i < count; ++i)
   12d5a:	47                   	inc    %edi
   12d5b:	eb 91                	jmp    12cee <print_char+0x28c>
			clear_rows(_show_y, rows);
   12d5d:	e8 03 fa ff ff       	call   12765 <clear_rows>
   12d62:	eb 18                	jmp    12d7c <print_char+0x31a>
			if (_show_x != _max_colums - 1)
   12d64:	0f b7 05 c8 b5 01 00 	movzwl 0x1b5c8,%eax
   12d6b:	48                   	dec    %eax
   12d6c:	39 c2                	cmp    %eax,%edx
   12d6e:	74 0c                	je     12d7c <print_char+0x31a>
				clear_line(_show_y, _show_x);
   12d70:	0f b7 05 ca b5 01 00 	movzwl 0x1b5ca,%eax
   12d77:	e8 af f8 ff ff       	call   1262b <clear_line>
	if (do_self)
   12d7c:	80 7d dc 00          	cmpb   $0x0,-0x24(%ebp)
   12d80:	74 0c                	je     12d8e <print_char+0x32c>
		update();
   12d82:	e8 d2 f7 ff ff       	call   12559 <update>
		_have_parent = false;
   12d87:	c6 05 b6 b2 01 00 00 	movb   $0x0,0x1b2b6
	if (_GUI_mode)
   12d8e:	80 3d b4 b2 01 00 00 	cmpb   $0x0,0x1b2b4
   12d95:	75 4f                	jne    12de6 <print_char+0x384>
		u16 cur_pos = y * _max_colums + x;
   12d97:	66 8b 1d ca b5 01 00 	mov    0x1b5ca,%bx
   12d9e:	66 0f af 1d c8 b5 01 	imul   0x1b5c8,%bx
   12da5:	00 
   12da6:	66 03 1d cc b5 01 00 	add    0x1b5cc,%bx
		u32 save_eflags = read_eflags();
   12dad:	e8 a4 f7 ff ff       	call   12556 <read_eflags>
   12db2:	89 c1                	mov    %eax,%ecx
	__asm__ __volatile__("cli\n" ::
   12db4:	fa                   	cli    
   12db5:	bf d4 03 00 00       	mov    $0x3d4,%edi
   12dba:	b0 0e                	mov    $0xe,%al
   12dbc:	89 fa                	mov    %edi,%edx
   12dbe:	ee                   	out    %al,(%dx)
		port_write_byte(CRTC_COLOR_PORT_DATA, cur_pos >> 8);
   12dbf:	89 d8                	mov    %ebx,%eax
   12dc1:	66 c1 e8 08          	shr    $0x8,%ax
   12dc5:	be d5 03 00 00       	mov    $0x3d5,%esi
   12dca:	89 f2                	mov    %esi,%edx
   12dcc:	ee                   	out    %al,(%dx)
   12dcd:	b0 0f                	mov    $0xf,%al
   12dcf:	89 fa                	mov    %edi,%edx
   12dd1:	ee                   	out    %al,(%dx)
   12dd2:	88 d8                	mov    %bl,%al
   12dd4:	89 f2                	mov    %esi,%edx
   12dd6:	ee                   	out    %al,(%dx)
		write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
   12dd7:	e8 7a f7 ff ff       	call   12556 <read_eflags>
   12ddc:	81 e1 00 02 00 00    	and    $0x200,%ecx
   12de2:	09 c1                	or     %eax,%ecx
	__asm__ __volatile__("pushl %0\n\t"
   12de4:	51                   	push   %ecx
   12de5:	9d                   	popf   
		scroll_up(1);
	}

	set_cursor_pos(_show_x, _show_y);

	if (do_self)
   12de6:	80 7d e3 00          	cmpb   $0x0,-0x1d(%ebp)
   12dea:	74 0c                	je     12df8 <print_char+0x396>
	{
		update();
   12dec:	e8 68 f7 ff ff       	call   12559 <update>
		_have_parent = false;
   12df1:	c6 05 b6 b2 01 00 00 	movb   $0x0,0x1b2b6
	}
}
   12df8:	8d 65 f4             	lea    -0xc(%ebp),%esp
   12dfb:	5b                   	pop    %ebx
   12dfc:	5e                   	pop    %esi
   12dfd:	5f                   	pop    %edi
   12dfe:	5d                   	pop    %ebp
   12dff:	c3                   	ret    

00012e00 <print_int>:
{
   12e00:	55                   	push   %ebp
   12e01:	89 e5                	mov    %esp,%ebp
   12e03:	57                   	push   %edi
   12e04:	56                   	push   %esi
   12e05:	53                   	push   %ebx
   12e06:	83 ec 4c             	sub    $0x4c,%esp
   12e09:	89 45 b4             	mov    %eax,-0x4c(%ebp)
   12e0c:	89 55 b0             	mov    %edx,-0x50(%ebp)
   12e0f:	89 cb                	mov    %ecx,%ebx
	char translate_table[] = {"0123456789abcdef"};
   12e11:	8d 7d d7             	lea    -0x29(%ebp),%edi
   12e14:	be ea 80 01 00       	mov    $0x180ea,%esi
   12e19:	b9 11 00 00 00       	mov    $0x11,%ecx
   12e1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	if (do_self)
   12e20:	a0 b6 b2 01 00       	mov    0x1b2b6,%al
   12e25:	34 01                	xor    $0x1,%al
   12e27:	88 45 af             	mov    %al,-0x51(%ebp)
   12e2a:	74 07                	je     12e33 <print_int+0x33>
		_have_parent = true;
   12e2c:	c6 05 b6 b2 01 00 01 	movb   $0x1,0x1b2b6
{
   12e33:	31 c9                	xor    %ecx,%ecx
		index_seq[index_count++] = n % base;
   12e35:	8b 45 b4             	mov    -0x4c(%ebp),%eax
   12e38:	31 d2                	xor    %edx,%edx
   12e3a:	f7 75 b0             	divl   -0x50(%ebp)
   12e3d:	89 45 a8             	mov    %eax,-0x58(%ebp)
   12e40:	89 ce                	mov    %ecx,%esi
   12e42:	8d 4e 01             	lea    0x1(%esi),%ecx
   12e45:	89 f0                	mov    %esi,%eax
   12e47:	0f b6 f8             	movzbl %al,%edi
   12e4a:	88 54 3d c7          	mov    %dl,-0x39(%ebp,%edi,1)
		n /= base;
   12e4e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
   12e51:	8b 45 a8             	mov    -0x58(%ebp),%eax
   12e54:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	} while (n != 0);
   12e57:	3b 55 b0             	cmp    -0x50(%ebp),%edx
   12e5a:	73 d9                	jae    12e35 <print_int+0x35>
	if (width > index_count)
   12e5c:	0f b6 c9             	movzbl %cl,%ecx
   12e5f:	39 d9                	cmp    %ebx,%ecx
   12e61:	73 12                	jae    12e75 <print_int+0x75>
		width -= index_count;
   12e63:	29 cb                	sub    %ecx,%ebx
			print_char('0');
   12e65:	83 ec 0c             	sub    $0xc,%esp
   12e68:	6a 30                	push   $0x30
   12e6a:	e8 f3 fb ff ff       	call   12a62 <print_char>
		while (width--)
   12e6f:	83 c4 10             	add    $0x10,%esp
   12e72:	4b                   	dec    %ebx
   12e73:	75 f0                	jne    12e65 <print_int+0x65>
	while (index_count--)
   12e75:	89 f0                	mov    %esi,%eax
   12e77:	fe c0                	inc    %al
   12e79:	74 1e                	je     12e99 <print_int+0x99>
		print_char(translate_table[index_seq[index_count]]);
   12e7b:	83 ec 0c             	sub    $0xc,%esp
   12e7e:	89 f0                	mov    %esi,%eax
   12e80:	0f b6 c0             	movzbl %al,%eax
   12e83:	0f b6 44 05 c7       	movzbl -0x39(%ebp,%eax,1),%eax
   12e88:	0f be 44 05 d7       	movsbl -0x29(%ebp,%eax,1),%eax
   12e8d:	50                   	push   %eax
   12e8e:	e8 cf fb ff ff       	call   12a62 <print_char>
   12e93:	4e                   	dec    %esi
   12e94:	83 c4 10             	add    $0x10,%esp
   12e97:	eb dc                	jmp    12e75 <print_int+0x75>
	if (do_self)
   12e99:	80 7d af 00          	cmpb   $0x0,-0x51(%ebp)
   12e9d:	74 0c                	je     12eab <print_int+0xab>
		update();
   12e9f:	e8 b5 f6 ff ff       	call   12559 <update>
		_have_parent = false;
   12ea4:	c6 05 b6 b2 01 00 00 	movb   $0x0,0x1b2b6
}
   12eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
   12eae:	5b                   	pop    %ebx
   12eaf:	5e                   	pop    %esi
   12eb0:	5f                   	pop    %edi
   12eb1:	5d                   	pop    %ebp
   12eb2:	c3                   	ret    

00012eb3 <print_str>:

void print_str(const char *s)
{
   12eb3:	55                   	push   %ebp
   12eb4:	89 e5                	mov    %esp,%ebp
   12eb6:	56                   	push   %esi
   12eb7:	53                   	push   %ebx
   12eb8:	8b 75 08             	mov    0x8(%ebp),%esi
	bool do_self = !_have_parent;
	if (do_self)
   12ebb:	8a 1d b6 b2 01 00    	mov    0x1b2b6,%bl
   12ec1:	80 f3 01             	xor    $0x1,%bl
   12ec4:	74 07                	je     12ecd <print_str+0x1a>
		_have_parent = true;
   12ec6:	c6 05 b6 b2 01 00 01 	movb   $0x1,0x1b2b6

	while (*s != '\0')
   12ecd:	0f be 06             	movsbl (%esi),%eax
   12ed0:	84 c0                	test   %al,%al
   12ed2:	74 0f                	je     12ee3 <print_str+0x30>
	{
		print_char(*(s++));
   12ed4:	46                   	inc    %esi
   12ed5:	83 ec 0c             	sub    $0xc,%esp
   12ed8:	50                   	push   %eax
   12ed9:	e8 84 fb ff ff       	call   12a62 <print_char>
   12ede:	83 c4 10             	add    $0x10,%esp
   12ee1:	eb ea                	jmp    12ecd <print_str+0x1a>
	}

	if (do_self)
   12ee3:	84 db                	test   %bl,%bl
   12ee5:	74 0c                	je     12ef3 <print_str+0x40>
	{
		update();
   12ee7:	e8 6d f6 ff ff       	call   12559 <update>
		_have_parent = false;
   12eec:	c6 05 b6 b2 01 00 00 	movb   $0x0,0x1b2b6
	}
}
   12ef3:	8d 65 f8             	lea    -0x8(%ebp),%esp
   12ef6:	5b                   	pop    %ebx
   12ef7:	5e                   	pop    %esi
   12ef8:	5d                   	pop    %ebp
   12ef9:	c3                   	ret    

00012efa <printf>:

void printf(const char *fmt, ...)
{
   12efa:	55                   	push   %ebp
   12efb:	89 e5                	mov    %esp,%ebp
   12efd:	53                   	push   %ebx
   12efe:	51                   	push   %ecx
	va_list args;
	bool do_self = !_have_parent;
	if (do_self)
   12eff:	8a 1d b6 b2 01 00    	mov    0x1b2b6,%bl
   12f05:	80 f3 01             	xor    $0x1,%bl
   12f08:	74 07                	je     12f11 <printf+0x17>
		_have_parent = true;
   12f0a:	c6 05 b6 b2 01 00 01 	movb   $0x1,0x1b2b6

	va_start(args, fmt);
   12f11:	8d 45 0c             	lea    0xc(%ebp),%eax
	vsprintf(_print_buf[_cur_env], fmt, args);
   12f14:	52                   	push   %edx
   12f15:	50                   	push   %eax
   12f16:	ff 75 08             	push   0x8(%ebp)
   12f19:	a1 d8 b5 01 00       	mov    0x1b5d8,%eax
   12f1e:	c1 e0 0a             	shl    $0xa,%eax
   12f21:	05 a0 aa 01 00       	add    $0x1aaa0,%eax
   12f26:	50                   	push   %eax
   12f27:	e8 27 36 00 00       	call   16553 <vsprintf>
	va_end(args);

	print_str(_print_buf[_cur_env]);
   12f2c:	a1 d8 b5 01 00       	mov    0x1b5d8,%eax
   12f31:	c1 e0 0a             	shl    $0xa,%eax
   12f34:	05 a0 aa 01 00       	add    $0x1aaa0,%eax
   12f39:	89 04 24             	mov    %eax,(%esp)
   12f3c:	e8 72 ff ff ff       	call   12eb3 <print_str>

	if (do_self)
   12f41:	83 c4 10             	add    $0x10,%esp
   12f44:	84 db                	test   %bl,%bl
   12f46:	74 0c                	je     12f54 <printf+0x5a>
	{
		update();
   12f48:	e8 0c f6 ff ff       	call   12559 <update>
		_have_parent = false;
   12f4d:	c6 05 b6 b2 01 00 00 	movb   $0x0,0x1b2b6
	}
}
   12f54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   12f57:	c9                   	leave  
   12f58:	c3                   	ret    

00012f59 <console_dumpinfo>:
{
   12f59:	55                   	push   %ebp
   12f5a:	89 e5                	mov    %esp,%ebp
   12f5c:	83 ec 0c             	sub    $0xc,%esp
	printf("\nline_count=0x%x\nmax_colums=%d\nmax_rows=%d\nbpp=%d\nBpp=%d\nBpl=%d\n",
   12f5f:	0f b7 05 c0 b5 01 00 	movzwl 0x1b5c0,%eax
   12f66:	50                   	push   %eax
   12f67:	0f b7 05 c2 b5 01 00 	movzwl 0x1b5c2,%eax
   12f6e:	50                   	push   %eax
   12f6f:	0f b7 05 c4 b5 01 00 	movzwl 0x1b5c4,%eax
   12f76:	50                   	push   %eax
   12f77:	0f b7 05 c6 b5 01 00 	movzwl 0x1b5c6,%eax
   12f7e:	50                   	push   %eax
   12f7f:	0f b7 05 c8 b5 01 00 	movzwl 0x1b5c8,%eax
   12f86:	50                   	push   %eax
   12f87:	68 c0 b3 01 00       	push   $0x1b3c0
   12f8c:	68 fb 80 01 00       	push   $0x180fb
   12f91:	e8 64 ff ff ff       	call   12efa <printf>
}
   12f96:	83 c4 20             	add    $0x20,%esp
   12f99:	c9                   	leave  
   12f9a:	c3                   	ret    

00012f9b <print_dec>:

void print_dec(u32 n, u32 width)
{
   12f9b:	55                   	push   %ebp
   12f9c:	89 e5                	mov    %esp,%ebp
   12f9e:	53                   	push   %ebx
   12f9f:	52                   	push   %edx
	bool do_self = !_have_parent;
	if (do_self)
   12fa0:	8a 1d b6 b2 01 00    	mov    0x1b2b6,%bl
   12fa6:	80 f3 01             	xor    $0x1,%bl
   12fa9:	74 07                	je     12fb2 <print_dec+0x17>
		_have_parent = true;
   12fab:	c6 05 b6 b2 01 00 01 	movb   $0x1,0x1b2b6

	print_int(n, 10, width);
   12fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
   12fb5:	ba 0a 00 00 00       	mov    $0xa,%edx
   12fba:	8b 45 08             	mov    0x8(%ebp),%eax
   12fbd:	e8 3e fe ff ff       	call   12e00 <print_int>

	if (do_self)
   12fc2:	84 db                	test   %bl,%bl
   12fc4:	74 0c                	je     12fd2 <print_dec+0x37>
	{
		update();
   12fc6:	e8 8e f5 ff ff       	call   12559 <update>
		_have_parent = false;
   12fcb:	c6 05 b6 b2 01 00 00 	movb   $0x0,0x1b2b6
	}
}
   12fd2:	58                   	pop    %eax
   12fd3:	5b                   	pop    %ebx
   12fd4:	5d                   	pop    %ebp
   12fd5:	c3                   	ret    

00012fd6 <print_hex>:

void print_hex(u32 n, u32 width)
{
   12fd6:	55                   	push   %ebp
   12fd7:	89 e5                	mov    %esp,%ebp
   12fd9:	53                   	push   %ebx
   12fda:	52                   	push   %edx
	bool do_self = !_have_parent;
	if (do_self)
   12fdb:	8a 1d b6 b2 01 00    	mov    0x1b2b6,%bl
   12fe1:	80 f3 01             	xor    $0x1,%bl
   12fe4:	74 07                	je     12fed <print_hex+0x17>
		_have_parent = true;
   12fe6:	c6 05 b6 b2 01 00 01 	movb   $0x1,0x1b2b6

	print_int(n, 16, width);
   12fed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
   12ff0:	ba 10 00 00 00       	mov    $0x10,%edx
   12ff5:	8b 45 08             	mov    0x8(%ebp),%eax
   12ff8:	e8 03 fe ff ff       	call   12e00 <print_int>

	if (do_self)
   12ffd:	84 db                	test   %bl,%bl
   12fff:	74 0c                	je     1300d <print_hex+0x37>
	{
		update();
   13001:	e8 53 f5 ff ff       	call   12559 <update>
		_have_parent = false;
   13006:	c6 05 b6 b2 01 00 00 	movb   $0x0,0x1b2b6
	}
}
   1300d:	58                   	pop    %eax
   1300e:	5b                   	pop    %ebx
   1300f:	5d                   	pop    %ebp
   13010:	c3                   	ret    

00013011 <print_oct>:

void print_oct(u32 n, u32 width)
{
   13011:	55                   	push   %ebp
   13012:	89 e5                	mov    %esp,%ebp
   13014:	53                   	push   %ebx
   13015:	52                   	push   %edx
	bool do_self = !_have_parent;
	if (do_self)
   13016:	8a 1d b6 b2 01 00    	mov    0x1b2b6,%bl
   1301c:	80 f3 01             	xor    $0x1,%bl
   1301f:	74 07                	je     13028 <print_oct+0x17>
		_have_parent = true;
   13021:	c6 05 b6 b2 01 00 01 	movb   $0x1,0x1b2b6

	print_int(n, 8, width);
   13028:	8b 4d 0c             	mov    0xc(%ebp),%ecx
   1302b:	ba 08 00 00 00       	mov    $0x8,%edx
   13030:	8b 45 08             	mov    0x8(%ebp),%eax
   13033:	e8 c8 fd ff ff       	call   12e00 <print_int>

	if (do_self)
   13038:	84 db                	test   %bl,%bl
   1303a:	74 0c                	je     13048 <print_oct+0x37>
	{
		update();
   1303c:	e8 18 f5 ff ff       	call   12559 <update>
		_have_parent = false;
   13041:	c6 05 b6 b2 01 00 00 	movb   $0x0,0x1b2b6
	}
}
   13048:	58                   	pop    %eax
   13049:	5b                   	pop    %ebx
   1304a:	5d                   	pop    %ebp
   1304b:	c3                   	ret    

0001304c <getkey>:

static u8 kbd_flags; // shift-ctrl-alt-caps-gui

u8 getkey(bool *released)
{
   1304c:	55                   	push   %ebp
   1304d:	89 e5                	mov    %esp,%ebp
   1304f:	53                   	push   %ebx
   13050:	83 ec 20             	sub    $0x20,%esp
   13053:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct kbd_key_packet key;
	bool ret = kbd_get_key(&key);
   13056:	8d 45 f6             	lea    -0xa(%ebp),%eax
   13059:	50                   	push   %eax
   1305a:	e8 c4 1d 00 00       	call   14e23 <kbd_get_key>
   1305f:	88 c2                	mov    %al,%dl
	if (ret)
   13061:	83 c4 10             	add    $0x10,%esp
   13064:	31 c0                	xor    %eax,%eax
   13066:	84 d2                	test   %dl,%dl
   13068:	74 0c                	je     13076 <getkey+0x2a>
	{
		if (released)
   1306a:	85 db                	test   %ebx,%ebx
   1306c:	74 05                	je     13073 <getkey+0x27>
			*released = key.released;
   1306e:	8a 45 f7             	mov    -0x9(%ebp),%al
   13071:	88 03                	mov    %al,(%ebx)
		return key.key;
   13073:	8a 45 f6             	mov    -0xa(%ebp),%al
	}
	return 0;
}
   13076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   13079:	c9                   	leave  
   1307a:	c3                   	ret    

0001307b <getchar>:

char getchar(void)
{
   1307b:	55                   	push   %ebp
   1307c:	89 e5                	mov    %esp,%ebp
   1307e:	53                   	push   %ebx
   1307f:	83 ec 24             	sub    $0x24,%esp
		"~_+{}?|:\"><)!@#$%^&*(\0\0\0\0\0\0\0ABCDEFGHIJKLMNOPQRSTUVWXYZ"};
	struct kbd_key_packet key;
	char c;
	while (true)
	{
		if (!kbd_get_key(&key))
   13082:	83 ec 0c             	sub    $0xc,%esp
   13085:	8d 45 f6             	lea    -0xa(%ebp),%eax
   13088:	50                   	push   %eax
   13089:	e8 95 1d 00 00       	call   14e23 <kbd_get_key>
   1308e:	83 c4 10             	add    $0x10,%esp
   13091:	84 c0                	test   %al,%al
   13093:	74 ed                	je     13082 <getchar+0x7>
			continue;
		if (key.key == KEY_LSHIFT || key.key == KEY_RSHIFT)
   13095:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
		{
			if (key.released)
   13099:	8a 55 f7             	mov    -0x9(%ebp),%dl
		if (key.key == KEY_LSHIFT || key.key == KEY_RSHIFT)
   1309c:	3c 07                	cmp    $0x7,%al
   1309e:	74 04                	je     130a4 <getchar+0x29>
   130a0:	3c 04                	cmp    $0x4,%al
   130a2:	75 13                	jne    130b7 <getchar+0x3c>
				kbd_flags &= ~(1 << 4);
   130a4:	a0 80 aa 01 00       	mov    0x1aa80,%al
			if (key.released)
   130a9:	84 d2                	test   %dl,%dl
   130ab:	74 05                	je     130b2 <getchar+0x37>
				kbd_flags &= ~(1 << 4);
   130ad:	83 e0 ef             	and    $0xffffffef,%eax
   130b0:	eb 1e                	jmp    130d0 <getchar+0x55>
			else
				kbd_flags |= 1 << 4;
   130b2:	83 c8 10             	or     $0x10,%eax
   130b5:	eb 19                	jmp    130d0 <getchar+0x55>
		// 	if (key.released)
		// 		kbd_flags &= ~(1 << 0);
		// 	else
		// 		kbd_flags |= 1 << 0;
		// }
		else if (!key.released)
   130b7:	84 d2                	test   %dl,%dl
   130b9:	75 c7                	jne    13082 <getchar+0x7>
		{
			if (key.key == KEY_CAPS)
   130bb:	3c 15                	cmp    $0x15,%al
   130bd:	75 18                	jne    130d7 <getchar+0x5c>
			{
				if (kbd_flags & 0x2)
   130bf:	a0 80 aa 01 00       	mov    0x1aa80,%al
   130c4:	a8 02                	test   $0x2,%al
   130c6:	74 05                	je     130cd <getchar+0x52>
					kbd_flags &= ~(1 << 1);
   130c8:	83 e0 fd             	and    $0xfffffffd,%eax
   130cb:	eb 03                	jmp    130d0 <getchar+0x55>
				else
					kbd_flags |= 1 << 1;
   130cd:	83 c8 02             	or     $0x2,%eax
   130d0:	a2 80 aa 01 00       	mov    %al,0x1aa80
   130d5:	eb ab                	jmp    13082 <getchar+0x7>
			}
			else if (key.key == KEY_ENTER)
   130d7:	3c 0e                	cmp    $0xe,%al
   130d9:	74 48                	je     13123 <getchar+0xa8>
			{
				c = '\n';
				break;
			}
			else if (key.key == KEY_TAB)
   130db:	3c 09                	cmp    $0x9,%al
   130dd:	74 48                	je     13127 <getchar+0xac>
			{
				c = '\t';
				break;
			}
			else if (key.key == KEY_BACK)
   130df:	3c 08                	cmp    $0x8,%al
   130e1:	74 48                	je     1312b <getchar+0xb0>
			{
				c = '\b';
				break;
			}
			else if (key.key == KEY_SPACE)
   130e3:	3c 24                	cmp    $0x24,%al
   130e5:	74 48                	je     1312f <getchar+0xb4>
			{
				c = ' ';
				break;
			}
			else if ((key.key >= KEY_BTICK && key.key <= '9') || (key.key >= 'A' && key.key <= 'Z'))
   130e7:	8d 50 db             	lea    -0x25(%eax),%edx
   130ea:	80 fa 14             	cmp    $0x14,%dl
   130ed:	76 08                	jbe    130f7 <getchar+0x7c>
   130ef:	8d 50 bf             	lea    -0x41(%eax),%edx
   130f2:	80 fa 19             	cmp    $0x19,%dl
   130f5:	77 8b                	ja     13082 <getchar+0x7>
			{
				u8 idx = 0;
				if (kbd_flags & 0x2 && key.key >= 'A')
   130f7:	8a 0d 80 aa 01 00    	mov    0x1aa80,%cl
   130fd:	88 ca                	mov    %cl,%dl
   130ff:	d0 ea                	shr    %dl
   13101:	3c 40                	cmp    $0x40,%al
   13103:	0f 97 c3             	seta   %bl
   13106:	21 da                	and    %ebx,%edx
				{
					idx = 1;
				}
				if (kbd_flags & 0x10)
   13108:	80 e1 10             	and    $0x10,%cl
   1310b:	74 06                	je     13113 <getchar+0x98>
				{
					if (idx == 1)
   1310d:	b1 01                	mov    $0x1,%cl
   1310f:	29 d1                	sub    %edx,%ecx
   13111:	88 ca                	mov    %cl,%dl
						idx = 0;
					else
						idx = 1;
				}
				c = key_char_mapping[idx][key.key - KEY_BTICK];
   13113:	0f b6 d2             	movzbl %dl,%edx
   13116:	8b 14 95 ac 81 01 00 	mov    0x181ac(,%edx,4),%edx
   1311d:	8a 44 02 db          	mov    -0x25(%edx,%eax,1),%al
				break;
   13121:	eb 0e                	jmp    13131 <getchar+0xb6>
				c = '\n';
   13123:	b0 0a                	mov    $0xa,%al
   13125:	eb 0a                	jmp    13131 <getchar+0xb6>
				c = '\t';
   13127:	b0 09                	mov    $0x9,%al
   13129:	eb 06                	jmp    13131 <getchar+0xb6>
				c = '\b';
   1312b:	b0 08                	mov    $0x8,%al
   1312d:	eb 02                	jmp    13131 <getchar+0xb6>
				c = ' ';
   1312f:	b0 20                	mov    $0x20,%al
			}
		}
	}

	print_char(c);
   13131:	83 ec 0c             	sub    $0xc,%esp
   13134:	0f be d0             	movsbl %al,%edx
   13137:	88 45 e7             	mov    %al,-0x19(%ebp)
   1313a:	52                   	push   %edx
   1313b:	e8 22 f9 ff ff       	call   12a62 <print_char>
	return c;
}
   13140:	8a 45 e7             	mov    -0x19(%ebp),%al
   13143:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   13146:	c9                   	leave  
   13147:	c3                   	ret    

00013148 <dma_setup>:
   13148:	b0 0f                	mov    $0xf,%al
   1314a:	e6 0f                	out    %al,$0xf
   1314c:	b0 0e                	mov    $0xe,%al
   1314e:	e6 de                	out    %al,$0xde

	// port_write_byte(DMA_PORT_MODE_1, 0xc0);
	// port_write_byte(DMA_PORT_MASK_RESET_1, 0);
	// port_write_byte(DMA_PORT_MODE_2, 0xc0);
	// port_write_byte(DMA_PORT_MASK_RESET_2, 0);
}
   13150:	c3                   	ret    

00013151 <dma_prepare>:

bool dma_prepare(u8 channel, u32 paddr, u32 len, bool write)
{
   13151:	55                   	push   %ebp
   13152:	89 e5                	mov    %esp,%ebp
   13154:	57                   	push   %edi
   13155:	56                   	push   %esi
   13156:	53                   	push   %ebx
   13157:	83 ec 14             	sub    $0x14,%esp
   1315a:	8b 4d 08             	mov    0x8(%ebp),%ecx
   1315d:	8b 55 0c             	mov    0xc(%ebp),%edx
   13160:	8b 7d 10             	mov    0x10(%ebp),%edi
   13163:	8b 45 14             	mov    0x14(%ebp),%eax
   13166:	89 45 e0             	mov    %eax,-0x20(%ebp)
	u16 port_ff_clear, port_mode, port_addr, port_count, port_page = 0;
	u16 count;
	u16 buf_offset;
	u8 page;

	if (channel == 0 || channel == 4 || channel > 7 || paddr + len > 16 * 1024 * 1024 || (paddr >> 16) != ((paddr + len) >> 16) || len > 64 * 1024)
   13169:	8d 41 ff             	lea    -0x1(%ecx),%eax
   1316c:	88 45 e4             	mov    %al,-0x1c(%ebp)
   1316f:	80 f9 04             	cmp    $0x4,%cl
   13172:	0f 94 c3             	sete   %bl
   13175:	3c 06                	cmp    $0x6,%al
   13177:	0f 97 c0             	seta   %al
   1317a:	08 d8                	or     %bl,%al
   1317c:	0f 85 06 01 00 00    	jne    13288 <dma_prepare+0x137>
   13182:	8d 1c 3a             	lea    (%edx,%edi,1),%ebx
   13185:	81 fb 00 00 00 01    	cmp    $0x1000000,%ebx
   1318b:	0f 87 f9 00 00 00    	ja     1328a <dma_prepare+0x139>
   13191:	89 d6                	mov    %edx,%esi
   13193:	c1 ee 10             	shr    $0x10,%esi
   13196:	89 75 ec             	mov    %esi,-0x14(%ebp)
   13199:	c1 eb 10             	shr    $0x10,%ebx
   1319c:	39 f3                	cmp    %esi,%ebx
   1319e:	0f 85 e6 00 00 00    	jne    1328a <dma_prepare+0x139>
   131a4:	81 ff 00 00 01 00    	cmp    $0x10000,%edi
   131aa:	0f 87 da 00 00 00    	ja     1328a <dma_prepare+0x139>
	{
		return false;
	}

	page = paddr >> 16;
	buf_offset = paddr;
   131b0:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
	if (channel < 4)
   131b4:	80 f9 03             	cmp    $0x3,%cl
   131b7:	77 1d                	ja     131d6 <dma_prepare+0x85>
	{
		port_ff_clear = DMA_PORT_FF_CLEAR_MASTER;
		port_mode = DMA_PORT_MODE_MASTER;
		port_addr = DMA_PORT_ADDR_0 + (channel << 1);
   131b9:	0f b6 c1             	movzbl %cl,%eax
   131bc:	d1 e0                	shl    %eax
   131be:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
		port_count = port_addr + 1;
   131c2:	40                   	inc    %eax
   131c3:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

		count = len;
   131c7:	89 f8                	mov    %edi,%eax
		port_mode = DMA_PORT_MODE_MASTER;
   131c9:	66 c7 45 e8 0b 00    	movw   $0xb,-0x18(%ebp)
		port_ff_clear = DMA_PORT_FF_CLEAR_MASTER;
   131cf:	bf 0c 00 00 00       	mov    $0xc,%edi
   131d4:	eb 3a                	jmp    13210 <dma_prepare+0xbf>
	}
	else
	{
		port_ff_clear = DMA_PORT_FF_CLEAR_SLAVE;
		port_mode = DMA_PORT_MODE_SLAVE;
		port_addr = DMA_PORT_ADDR_4 + ((channel & 0x3) << 2);
   131d6:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
   131dd:	83 e0 0c             	and    $0xc,%eax
   131e0:	8d 98 c0 00 00 00    	lea    0xc0(%eax),%ebx
   131e6:	66 89 5d f2          	mov    %bx,-0xe(%ebp)
		port_count = port_addr + 2;
   131ea:	66 05 c2 00          	add    $0xc2,%ax
   131ee:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
		
		u16 tmp = page & 0x1;
		tmp <<= 15;
		buf_offset >>= 1;
   131f2:	66 d1 ea             	shr    %dx
		tmp <<= 15;
   131f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
   131f8:	c1 e0 0f             	shl    $0xf,%eax
		buf_offset &= 0x7fff;
		buf_offset |= tmp;
   131fb:	09 d0                	or     %edx,%eax
   131fd:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
		count = len >> 1;
   13201:	89 f8                	mov    %edi,%eax
   13203:	d1 e8                	shr    %eax
		port_mode = DMA_PORT_MODE_SLAVE;
   13205:	66 c7 45 e8 d6 00    	movw   $0xd6,-0x18(%ebp)
		port_ff_clear = DMA_PORT_FF_CLEAR_SLAVE;
   1320b:	bf d8 00 00 00       	mov    $0xd8,%edi
	}
	count -= 1;
   13210:	48                   	dec    %eax
   13211:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)

	switch (channel)
   13215:	0f b6 75 e4          	movzbl -0x1c(%ebp),%esi
   13219:	0f b6 86 b4 81 01 00 	movzbl 0x181b4(%esi),%eax
   13220:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
		break;
	}

	// port_page = port_page_list[channel];

	u8 transfer_mode = write ? 0x58 : 0x54; // Single, AI, Auto-Init
   13224:	80 7d e0 01          	cmpb   $0x1,-0x20(%ebp)
   13228:	19 db                	sbb    %ebx,%ebx
   1322a:	83 e3 fc             	and    $0xfffffffc,%ebx
   1322d:	83 c3 58             	add    $0x58,%ebx
	u16 port_smask = channel < 4 ? DMA_PORT_SMASK_MASTER : DMA_PORT_SMASK_SLAVE;
   13230:	be 0a 00 00 00       	mov    $0xa,%esi
   13235:	80 f9 03             	cmp    $0x3,%cl
   13238:	76 05                	jbe    1323f <dma_prepare+0xee>
   1323a:	be d4 00 00 00       	mov    $0xd4,%esi
	port_write_byte(port_smask, (off << 2) | (channel & 0x3));
   1323f:	83 e1 03             	and    $0x3,%ecx
   13242:	88 c8                	mov    %cl,%al
   13244:	83 c8 04             	or     $0x4,%eax
   13247:	89 f2                	mov    %esi,%edx
   13249:	ee                   	out    %al,(%dx)
   1324a:	31 c0                	xor    %eax,%eax
   1324c:	89 fa                	mov    %edi,%edx
   1324e:	ee                   	out    %al,(%dx)

	mask_channel(channel, true);
	port_write_byte(port_ff_clear, 0);
	port_write_byte(port_mode, transfer_mode | (channel & 0x3));
   1324f:	88 d8                	mov    %bl,%al
   13251:	09 c8                	or     %ecx,%eax
   13253:	8b 55 e8             	mov    -0x18(%ebp),%edx
   13256:	ee                   	out    %al,(%dx)
   13257:	8a 45 e6             	mov    -0x1a(%ebp),%al
   1325a:	8b 55 f0             	mov    -0x10(%ebp),%edx
   1325d:	ee                   	out    %al,(%dx)

	port_write_byte(port_count, count);
	port_write_byte(port_count, count >> 8);
   1325e:	66 8b 45 e6          	mov    -0x1a(%ebp),%ax
   13262:	66 c1 e8 08          	shr    $0x8,%ax
   13266:	ee                   	out    %al,(%dx)
   13267:	8a 45 ec             	mov    -0x14(%ebp),%al
   1326a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
   1326d:	ee                   	out    %al,(%dx)
   1326e:	8a 45 ea             	mov    -0x16(%ebp),%al
   13271:	66 8b 55 f2          	mov    -0xe(%ebp),%dx
   13275:	ee                   	out    %al,(%dx)

	port_write_byte(port_page, page);
	port_write_byte(port_addr, buf_offset);
	port_write_byte(port_addr, buf_offset >> 8);	
   13276:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
   1327a:	66 c1 e8 08          	shr    $0x8,%ax
   1327e:	ee                   	out    %al,(%dx)
   1327f:	88 c8                	mov    %cl,%al
   13281:	89 f2                	mov    %esi,%edx
   13283:	ee                   	out    %al,(%dx)
	
	mask_channel(channel, false);

	return true;
   13284:	b0 01                	mov    $0x1,%al
}
   13286:	eb 02                	jmp    1328a <dma_prepare+0x139>
		return false;
   13288:	31 c0                	xor    %eax,%eax
}
   1328a:	83 c4 14             	add    $0x14,%esp
   1328d:	5b                   	pop    %ebx
   1328e:	5e                   	pop    %esi
   1328f:	5f                   	pop    %edi
   13290:	5d                   	pop    %ebp
   13291:	c3                   	ret    

00013292 <dma_release>:
	
// 	mask_channel(channel, false);
// }

void dma_release(u8 channel)
{
   13292:	55                   	push   %ebp
   13293:	89 e5                	mov    %esp,%ebp
   13295:	8b 45 08             	mov    0x8(%ebp),%eax
	u16 port_smask = channel < 4 ? DMA_PORT_SMASK_MASTER : DMA_PORT_SMASK_SLAVE;
   13298:	ba d4 00 00 00       	mov    $0xd4,%edx
   1329d:	3c 03                	cmp    $0x3,%al
   1329f:	77 05                	ja     132a6 <dma_release+0x14>
   132a1:	ba 0a 00 00 00       	mov    $0xa,%edx
	port_write_byte(port_smask, (off << 2) | (channel & 0x3));
   132a6:	83 e0 03             	and    $0x3,%eax
   132a9:	83 c8 04             	or     $0x4,%eax
   132ac:	ee                   	out    %al,(%dx)
	mask_channel(channel, true);
}
   132ad:	5d                   	pop    %ebp
   132ae:	c3                   	ret    

000132af <irq_handler>:
    port_read_word(_iobase.base + ES1370_REG_CODEC);
    delay_ms(1);
}

static void irq_handler(void)
{
   132af:	55                   	push   %ebp
   132b0:	89 e5                	mov    %esp,%ebp
   132b2:	53                   	push   %ebx
   132b3:	83 ec 10             	sub    $0x10,%esp
    enum console_env old_env = console_set_env(CONSOLE_ENV_INTR);
   132b6:	6a 01                	push   $0x1
   132b8:	e8 11 f7 ff ff       	call   129ce <console_set_env>
   132bd:	89 c3                	mov    %eax,%ebx
    u32 status = port_read_dword(_iobase.base + ES1370_REG_STATUS);
   132bf:	a1 f0 b5 01 00       	mov    0x1b5f0,%eax
   132c4:	8d 50 04             	lea    0x4(%eax),%edx
}

inline static u32 port_read_dword(u16 port)
{
    u32 data;
    __asm__ volatile("inl %1, %0"
   132c7:	ed                   	in     (%dx),%eax
    printf("[ES1370] Irq Handler Invoked - 0x%x\n", status);
   132c8:	5a                   	pop    %edx
   132c9:	59                   	pop    %ecx
   132ca:	50                   	push   %eax
   132cb:	68 bb 81 01 00       	push   $0x181bb
   132d0:	e8 25 fc ff ff       	call   12efa <printf>
    console_set_env(old_env);
   132d5:	89 1c 24             	mov    %ebx,(%esp)
   132d8:	e8 f1 f6 ff ff       	call   129ce <console_set_env>
}
   132dd:	83 c4 10             	add    $0x10,%esp
   132e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   132e3:	c9                   	leave  
   132e4:	c3                   	ret    

000132e5 <es1370_setup>:

void es1370_setup(void)
{
   132e5:	55                   	push   %ebp
   132e6:	89 e5                	mov    %esp,%ebp
   132e8:	57                   	push   %edi
   132e9:	56                   	push   %esi
   132ea:	53                   	push   %ebx
   132eb:	83 ec 24             	sub    $0x24,%esp
    bool found = pci_dev_find(&_dev_info, true);
   132ee:	6a 01                	push   $0x1
   132f0:	68 3c aa 01 00       	push   $0x1aa3c
   132f5:	e8 e5 25 00 00       	call   158df <pci_dev_find>
    if (!found)
   132fa:	83 c4 10             	add    $0x10,%esp
   132fd:	84 c0                	test   %al,%al
   132ff:	0f 84 2c 02 00 00    	je     13531 <es1370_setup+0x24c>
    {
        return;
    }

    printf("ES1370 PCI Controller\n"
   13305:	56                   	push   %esi
   13306:	56                   	push   %esi
   13307:	0f b6 05 4e aa 01 00 	movzbl 0x1aa4e,%eax
   1330e:	50                   	push   %eax
   1330f:	0f b6 05 51 aa 01 00 	movzbl 0x1aa51,%eax
   13316:	50                   	push   %eax
   13317:	0f b6 05 50 aa 01 00 	movzbl 0x1aa50,%eax
   1331e:	50                   	push   %eax
   1331f:	0f b6 05 4f aa 01 00 	movzbl 0x1aa4f,%eax
   13326:	50                   	push   %eax
   13327:	0f b7 05 4c aa 01 00 	movzwl 0x1aa4c,%eax
   1332e:	50                   	push   %eax
   1332f:	0f b7 05 4a aa 01 00 	movzwl 0x1aa4a,%eax
   13336:	50                   	push   %eax
   13337:	ff 35 44 aa 01 00    	push   0x1aa44
   1333d:	ff 35 40 aa 01 00    	push   0x1aa40
   13343:	ff 35 3c aa 01 00    	push   0x1aa3c
   13349:	68 e0 81 01 00       	push   $0x181e0
   1334e:	e8 a7 fb ff ff       	call   12efa <printf>
           _dev_info.bus, _dev_info.dev, _dev_info.func,
           _dev_info.ven_id, _dev_info.dev_id,
           _dev_info.class, _dev_info.subclass, _dev_info.progif, _dev_info.rev);

    u32 subsys_ven, status_cmd;
    subsys_ven = pci_conf_read_dword(_dev_info.bus, _dev_info.dev, _dev_info.func, 11);
   13353:	83 c4 30             	add    $0x30,%esp
   13356:	6a 0b                	push   $0xb
   13358:	ff 35 44 aa 01 00    	push   0x1aa44
   1335e:	ff 35 40 aa 01 00    	push   0x1aa40
   13364:	ff 35 3c aa 01 00    	push   0x1aa3c
   1336a:	e8 74 23 00 00       	call   156e3 <pci_conf_read_dword>
    printf("subsys: 0x%x, ven: 0x%x\n", subsys_ven >> 16, subsys_ven & 0xffff);
   1336f:	83 c4 0c             	add    $0xc,%esp
   13372:	0f b7 d0             	movzwl %ax,%edx
   13375:	52                   	push   %edx
   13376:	c1 e8 10             	shr    $0x10,%eax
   13379:	50                   	push   %eax
   1337a:	68 3c 82 01 00       	push   $0x1823c
   1337f:	e8 76 fb ff ff       	call   12efa <printf>
    status_cmd = pci_conf_read_dword(_dev_info.bus, _dev_info.dev, _dev_info.func, 1);
   13384:	6a 01                	push   $0x1
   13386:	ff 35 44 aa 01 00    	push   0x1aa44
   1338c:	ff 35 40 aa 01 00    	push   0x1aa40
   13392:	ff 35 3c aa 01 00    	push   0x1aa3c
   13398:	e8 46 23 00 00       	call   156e3 <pci_conf_read_dword>
    printf("status: 0x%x, command: 0x%x\n", status_cmd >> 16, status_cmd & 0xffff);
   1339d:	83 c4 1c             	add    $0x1c,%esp
   133a0:	0f b7 d0             	movzwl %ax,%edx
   133a3:	52                   	push   %edx
   133a4:	c1 e8 10             	shr    $0x10,%eax
   133a7:	50                   	push   %eax
   133a8:	68 55 82 01 00       	push   $0x18255
   133ad:	e8 48 fb ff ff       	call   12efa <printf>
    
    u16 intr_pin_line = pci_conf_read_word(_dev_info.bus, _dev_info.dev, _dev_info.func, 30);
   133b2:	6a 1e                	push   $0x1e
   133b4:	ff 35 44 aa 01 00    	push   0x1aa44
   133ba:	ff 35 40 aa 01 00    	push   0x1aa40
   133c0:	ff 35 3c aa 01 00    	push   0x1aa3c
   133c6:	e8 b4 23 00 00       	call   1577f <pci_conf_read_word>
   133cb:	89 c3                	mov    %eax,%ebx
    printf("IntrPin: %d, Line: %d\n", intr_pin_line >> 8, intr_pin_line & 0xff);
   133cd:	83 c4 1c             	add    $0x1c,%esp
   133d0:	0f b6 c0             	movzbl %al,%eax
   133d3:	50                   	push   %eax
   133d4:	0f b6 c7             	movzbl %bh,%eax
   133d7:	50                   	push   %eax
   133d8:	68 72 82 01 00       	push   $0x18272
   133dd:	e8 18 fb ff ff       	call   12efa <printf>

    _irq = intr_pin_line & 0xff;
   133e2:	88 1d dc b5 01 00    	mov    %bl,0x1b5dc

    pci_decode_bar(&_dev_info, 0, &_iobase);
   133e8:	83 c4 0c             	add    $0xc,%esp
   133eb:	68 ec b5 01 00       	push   $0x1b5ec
   133f0:	6a 00                	push   $0x0
   133f2:	68 3c aa 01 00       	push   $0x1aa3c
   133f7:	e8 27 26 00 00       	call   15a23 <pci_decode_bar>
    if (_iobase.type != PCI_BAR_TYPE_PIO)
   133fc:	0f b6 05 ec b5 01 00 	movzbl 0x1b5ec,%eax
   13403:	83 c4 10             	add    $0x10,%esp
   13406:	3c 01                	cmp    $0x1,%al
   13408:	74 12                	je     1341c <es1370_setup+0x137>
    {
        printf("[ES1370] ERROR: BAR0.type=%d!\n", _iobase.type);
   1340a:	53                   	push   %ebx
   1340b:	53                   	push   %ebx
   1340c:	50                   	push   %eax
   1340d:	68 89 82 01 00       	push   $0x18289
   13412:	e8 e3 fa ff ff       	call   12efa <printf>
        return;
   13417:	e9 12 01 00 00       	jmp    1352e <es1370_setup+0x249>
    }
    printf("BAR0: base=0x%x, size=0x%x, type=PIO\n", _iobase.base, _iobase.size);
   1341c:	50                   	push   %eax
   1341d:	ff 35 f4 b5 01 00    	push   0x1b5f4
   13423:	ff 35 f0 b5 01 00    	push   0x1b5f0
   13429:	68 a8 82 01 00       	push   $0x182a8
   1342e:	e8 c7 fa ff ff       	call   12efa <printf>

    u32 reg_ctrl = port_read_dword(_iobase.base + ES1370_REG_CONTROL);
   13433:	8b 0d f0 b5 01 00    	mov    0x1b5f0,%ecx
   13439:	89 ca                	mov    %ecx,%edx
   1343b:	ed                   	in     (%dx),%eax
   1343c:	89 c6                	mov    %eax,%esi
    u32 reg_status = port_read_dword(_iobase.base + ES1370_REG_STATUS);
   1343e:	8d 51 04             	lea    0x4(%ecx),%edx
   13441:	ed                   	in     (%dx),%eax
   13442:	89 c7                	mov    %eax,%edi
    u8 reg_mem_page = port_read_byte(_iobase.base + ES1370_REG_MEM_PAGE) & 0xf;
   13444:	8d 51 0c             	lea    0xc(%ecx),%edx
    __asm__ volatile("inb %1, %0"
   13447:	ec                   	in     (%dx),%al
   13448:	88 45 e4             	mov    %al,-0x1c(%ebp)
    u16 reg_codec = port_read_word(_iobase.base + ES1370_REG_CODEC);
   1344b:	8d 51 10             	lea    0x10(%ecx),%edx
    __asm__ volatile("inw %1, %0"
   1344e:	66 ed                	in     (%dx),%ax
   13450:	0f b7 d8             	movzwl %ax,%ebx
    u32 reg_serial = port_read_dword(_iobase.base + ES1370_REG_SERIAL);
   13453:	8d 51 20             	lea    0x20(%ecx),%edx
    __asm__ volatile("inl %1, %0"
   13456:	ed                   	in     (%dx),%eax

    printf("reg_ctrl=0x%x\nreg_status=0x%x\nreg_mem_page=0x%x\nreg_codec=0x%x\nreg_serial=0x%x\n",
   13457:	5a                   	pop    %edx
   13458:	59                   	pop    %ecx
   13459:	50                   	push   %eax
   1345a:	53                   	push   %ebx
   1345b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
   1345e:	83 e0 0f             	and    $0xf,%eax
   13461:	50                   	push   %eax
   13462:	57                   	push   %edi
   13463:	56                   	push   %esi
   13464:	68 ce 82 01 00       	push   $0x182ce
   13469:	e8 8c fa ff ff       	call   12efa <printf>
           reg_ctrl, reg_status, reg_mem_page, reg_codec, reg_serial);

    pic_irq_set_entry(_irq, irq_handler);
   1346e:	83 c4 18             	add    $0x18,%esp
   13471:	68 af 32 01 00       	push   $0x132af
   13476:	0f b6 05 dc b5 01 00 	movzbl 0x1b5dc,%eax
   1347d:	50                   	push   %eax
   1347e:	e8 59 28 00 00       	call   15cdc <pic_irq_set_entry>

    u16 status = pci_conf_read_word(_dev_info.bus, _dev_info.dev, _dev_info.func, 2);
   13483:	6a 02                	push   $0x2
   13485:	ff 35 44 aa 01 00    	push   0x1aa44
   1348b:	ff 35 40 aa 01 00    	push   0x1aa40
   13491:	ff 35 3c aa 01 00    	push   0x1aa3c
   13497:	e8 e3 22 00 00       	call   1577f <pci_conf_read_word>
    pci_conf_write_word(_dev_info.bus, _dev_info.dev, _dev_info.func, 2, status | 0x5);
   1349c:	83 c4 14             	add    $0x14,%esp
   1349f:	83 c8 05             	or     $0x5,%eax
   134a2:	0f b7 c0             	movzwl %ax,%eax
   134a5:	50                   	push   %eax
   134a6:	6a 02                	push   $0x2
   134a8:	ff 35 44 aa 01 00    	push   0x1aa44
   134ae:	ff 35 40 aa 01 00    	push   0x1aa40
   134b4:	ff 35 3c aa 01 00    	push   0x1aa3c
   134ba:	e8 bd 23 00 00       	call   1587c <pci_conf_write_word>
    port_write_word(_iobase.base + ES1370_REG_CODEC, 0x10 << 8 | 0x2);
   134bf:	a1 f0 b5 01 00       	mov    0x1b5f0,%eax
   134c4:	8d 50 10             	lea    0x10(%eax),%edx
    __asm__ volatile("outw %0, %1"
   134c7:	b8 02 10 00 00       	mov    $0x1002,%eax
   134cc:	66 ef                	out    %ax,(%dx)
    __asm__ volatile("inw %1, %0"
   134ce:	66 ed                	in     (%dx),%ax
    delay_ms(1);
   134d0:	83 c4 14             	add    $0x14,%esp
   134d3:	6a 01                	push   $0x1
   134d5:	e8 bb 19 00 00       	call   14e95 <delay_ms>
    port_write_word(_iobase.base + ES1370_REG_CODEC, 0x10 << 8 | 0x3);
   134da:	a1 f0 b5 01 00       	mov    0x1b5f0,%eax
   134df:	8d 50 10             	lea    0x10(%eax),%edx
    __asm__ volatile("outw %0, %1"
   134e2:	b8 03 10 00 00       	mov    $0x1003,%eax
   134e7:	66 ef                	out    %ax,(%dx)
    __asm__ volatile("inw %1, %0"
   134e9:	66 ed                	in     (%dx),%ax
    delay_ms(1);
   134eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
   134f2:	e8 9e 19 00 00       	call   14e95 <delay_ms>

    reset_mixer();

    _ctrl = (1 << 31) | (((1411200 / 8000 - 2) & 0x1fff) << 16) | (0x3 << 12) | (1 << 1);
   134f7:	c7 05 e4 b5 01 00 02 	movl   $0x80ae3002,0x1b5e4
   134fe:	30 ae 80 
    _sctrl = 0;
   13501:	c7 05 e0 b5 01 00 00 	movl   $0x0,0x1b5e0
   13508:	00 00 00 
    port_write_dword(_iobase.base + ES1370_REG_CONTROL, _ctrl);
   1350b:	8b 0d f0 b5 01 00    	mov    0x1b5f0,%ecx
    __asm__ volatile("outl %0, %1"
   13511:	b8 02 30 ae 80       	mov    $0x80ae3002,%eax
   13516:	89 ca                	mov    %ecx,%edx
   13518:	ef                   	out    %eax,(%dx)
    port_write_dword(_iobase.base + ES1370_REG_SERIAL, _sctrl);
   13519:	8d 51 20             	lea    0x20(%ecx),%edx
   1351c:	31 c0                	xor    %eax,%eax
   1351e:	ef                   	out    %eax,(%dx)
    port_write_byte(_iobase.base + ES1370_REG_UART_CTRL, 0);
   1351f:	8d 51 09             	lea    0x9(%ecx),%edx
    __asm__ volatile("outb %0, %1"
   13522:	ee                   	out    %al,(%dx)
    port_write_byte(_iobase.base + ES1370_REG_UART_RES, 0);
   13523:	8d 51 0a             	lea    0xa(%ecx),%edx
   13526:	ee                   	out    %al,(%dx)
    // port_write_dword(_iobase.base + ES1370_REG_STATUS)
    // port_write_dword(_iobase.base + ES1370_REG_MEM_PAGE, 0xd);

    _present = true;
   13527:	c6 05 e8 b5 01 00 01 	movb   $0x1,0x1b5e8
   1352e:	83 c4 10             	add    $0x10,%esp
}
   13531:	8d 65 f4             	lea    -0xc(%ebp),%esp
   13534:	5b                   	pop    %ebx
   13535:	5e                   	pop    %esi
   13536:	5f                   	pop    %edi
   13537:	5d                   	pop    %ebp
   13538:	c3                   	ret    

00013539 <es1370_play>:

bool es1370_play(void *laddr, u32 len, u16 freq, u8 width, u8 channels)
{
   13539:	55                   	push   %ebp
   1353a:	89 e5                	mov    %esp,%ebp
   1353c:	57                   	push   %edi
   1353d:	56                   	push   %esi
   1353e:	53                   	push   %ebx
   1353f:	83 ec 1c             	sub    $0x1c,%esp
   13542:	8b 5d 0c             	mov    0xc(%ebp),%ebx
   13545:	8b 45 10             	mov    0x10(%ebp),%eax
   13548:	89 45 e0             	mov    %eax,-0x20(%ebp)
   1354b:	8b 45 14             	mov    0x14(%ebp),%eax
   1354e:	8b 55 18             	mov    0x18(%ebp),%edx
    u32 mode = 0, count;

    if (!_present)
   13551:	8a 0d e8 b5 01 00    	mov    0x1b5e8,%cl
   13557:	88 4d e7             	mov    %cl,-0x19(%ebp)
   1355a:	84 c9                	test   %cl,%cl
   1355c:	0f 84 da 00 00 00    	je     1363c <es1370_play+0x103>
    {
        return false;
    }

    if (width == 16)
   13562:	3c 10                	cmp    $0x10,%al
   13564:	74 18                	je     1357e <es1370_play+0x45>
    u32 mode = 0, count;
   13566:	31 c9                	xor    %ecx,%ecx
    }

    switch (mode)
    {
    case 0: // MONO 8-bits
        count = len;
   13568:	89 df                	mov    %ebx,%edi
    if (channels > 1)
   1356a:	80 fa 01             	cmp    $0x1,%dl
   1356d:	76 1d                	jbe    1358c <es1370_play+0x53>
        mode |= 0x1;
   1356f:	83 c9 01             	or     $0x1,%ecx
    switch (mode)
   13572:	83 f9 03             	cmp    $0x3,%ecx
   13575:	75 11                	jne    13588 <es1370_play+0x4f>
    case 1: // STEREO 8-bits
    case 2: // MONO 16-bits
        count = len >> 1;
        break;
    case 3: // STEREO 16-bits
        count = len >> 2;
   13577:	89 df                	mov    %ebx,%edi
   13579:	c1 ef 02             	shr    $0x2,%edi
   1357c:	eb 0e                	jmp    1358c <es1370_play+0x53>
        mode |= 0x2;
   1357e:	b9 02 00 00 00       	mov    $0x2,%ecx
    if (channels > 1)
   13583:	80 fa 01             	cmp    $0x1,%dl
   13586:	77 e7                	ja     1356f <es1370_play+0x36>
        count = len >> 1;
   13588:	89 df                	mov    %ebx,%edi
   1358a:	d1 ef                	shr    %edi
        break;
    }

    _ctrl &= ~(1 << 5);
    port_write_dword(_iobase.base + ES1370_REG_CONTROL, _ctrl);
   1358c:	8b 35 f0 b5 01 00    	mov    0x1b5f0,%esi
    _ctrl &= ~(1 << 5);
   13592:	a1 e4 b5 01 00       	mov    0x1b5e4,%eax
   13597:	83 e0 df             	and    $0xffffffdf,%eax
    __asm__ volatile("outl %0, %1"
   1359a:	89 f2                	mov    %esi,%edx
   1359c:	ef                   	out    %eax,(%dx)
    port_write_dword(_iobase.base + ES1370_REG_MEM_PAGE, 0xc);
   1359d:	8d 56 0c             	lea    0xc(%esi),%edx
   135a0:	b8 0c 00 00 00       	mov    $0xc,%eax
   135a5:	ef                   	out    %eax,(%dx)
    port_write_dword(_iobase.base + ES1370_REG_DAC2_FRAME, (u32)laddr);
   135a6:	8d 56 38             	lea    0x38(%esi),%edx
   135a9:	8b 45 08             	mov    0x8(%ebp),%eax
   135ac:	ef                   	out    %eax,(%dx)
    port_write_dword(_iobase.base + ES1370_REG_DAC2_SIZE, (len >> 2) - 1);
   135ad:	c1 eb 02             	shr    $0x2,%ebx
   135b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
   135b3:	8d 56 3c             	lea    0x3c(%esi),%edx
   135b6:	ef                   	out    %eax,(%dx)
    _sctrl &= ~((0x7 << 19) | (0x7 << 16) | (1 << 14) | (1 << 12) | (1 << 6) || (0x3 << 2));
   135b7:	8b 15 e0 b5 01 00    	mov    0x1b5e0,%edx
   135bd:	83 e2 fe             	and    $0xfffffffe,%edx
    _sctrl |= ((mode & 2 ? 2 : 1) << 19) | (0 << 16) | (1 << 9) | ((mode & 0x3) << 2);
   135c0:	89 c8                	mov    %ecx,%eax
   135c2:	83 e0 02             	and    $0x2,%eax
   135c5:	83 f8 01             	cmp    $0x1,%eax
   135c8:	19 c0                	sbb    %eax,%eax
   135ca:	25 00 00 f8 ff       	and    $0xfff80000,%eax
   135cf:	05 00 02 10 00       	add    $0x100200,%eax
   135d4:	c1 e1 02             	shl    $0x2,%ecx
   135d7:	09 d1                	or     %edx,%ecx
   135d9:	09 c8                	or     %ecx,%eax
   135db:	a3 e0 b5 01 00       	mov    %eax,0x1b5e0
    port_write_dword(_iobase.base + ES1370_REG_SERIAL, _sctrl);
   135e0:	8d 56 20             	lea    0x20(%esi),%edx
   135e3:	ef                   	out    %eax,(%dx)
    port_write_dword(_iobase.base + ES1370_REG_DAC2_COUNT, count);
   135e4:	8d 56 28             	lea    0x28(%esi),%edx
   135e7:	89 f8                	mov    %edi,%eax
   135e9:	ef                   	out    %eax,(%dx)

    _ctrl &= ~(0x1fff << 16);
    _ctrl |= (((1411200 / freq - 2) & 0x1fff) << 16);
   135ea:	0f b7 4d e0          	movzwl -0x20(%ebp),%ecx
   135ee:	b8 80 88 15 00       	mov    $0x158880,%eax
   135f3:	99                   	cltd   
   135f4:	f7 f9                	idiv   %ecx
   135f6:	83 e8 02             	sub    $0x2,%eax
   135f9:	c1 e0 10             	shl    $0x10,%eax
   135fc:	25 00 00 ff 1f       	and    $0x1fff0000,%eax
    _ctrl &= ~(0x1fff << 16);
   13601:	8b 15 e4 b5 01 00    	mov    0x1b5e4,%edx
   13607:	81 e2 df ff 00 e0    	and    $0xe000ffdf,%edx
    _ctrl |= (((1411200 / freq - 2) & 0x1fff) << 16);
   1360d:	09 d0                	or     %edx,%eax
   1360f:	a3 e4 b5 01 00       	mov    %eax,0x1b5e4
    // default:
    //     printf("\n[ES1370] unsupported freq: %d\n", freq);
    //     return false;
    // }

    pic_irq_enable(_irq);
   13614:	83 ec 0c             	sub    $0xc,%esp
   13617:	0f b6 05 dc b5 01 00 	movzbl 0x1b5dc,%eax
   1361e:	50                   	push   %eax
   1361f:	e8 69 26 00 00       	call   15c8d <pic_irq_enable>

    port_write_dword(_iobase.base + ES1370_REG_CONTROL, _ctrl);
   13624:	a1 e4 b5 01 00       	mov    0x1b5e4,%eax
   13629:	8b 15 f0 b5 01 00    	mov    0x1b5f0,%edx
   1362f:	ef                   	out    %eax,(%dx)

    _ctrl |= (1 << 5);
   13630:	83 c8 20             	or     $0x20,%eax
   13633:	a3 e4 b5 01 00       	mov    %eax,0x1b5e4
   13638:	ef                   	out    %eax,(%dx)
    port_write_dword(_iobase.base + ES1370_REG_CONTROL, _ctrl);

    return true;
   13639:	83 c4 10             	add    $0x10,%esp
}
   1363c:	8a 45 e7             	mov    -0x19(%ebp),%al
   1363f:	8d 65 f4             	lea    -0xc(%ebp),%esp
   13642:	5b                   	pop    %ebx
   13643:	5e                   	pop    %esi
   13644:	5f                   	pop    %edi
   13645:	5d                   	pop    %ebp
   13646:	c3                   	ret    

00013647 <_irq_handler>:
}

static void _irq_handler(void)
{
    // print_str("fdc irq handler triggered!\n");
    ++_irq_trigger;
   13647:	a0 04 b6 01 00       	mov    0x1b604,%al
   1364c:	40                   	inc    %eax
   1364d:	a2 04 b6 01 00       	mov    %al,0x1b604
}
   13652:	c3                   	ret    

00013653 <wait_fdc_ready>:

static bool wait_fdc_ready(void)
{
   13653:	55                   	push   %ebp
   13654:	89 e5                	mov    %esp,%ebp
   13656:	53                   	push   %ebx
   13657:	50                   	push   %eax
    s8 times = 100;
   13658:	b3 64                	mov    $0x64,%bl
    u8 msr;
    do
    {
        delay_ms(10);
   1365a:	83 ec 0c             	sub    $0xc,%esp
   1365d:	6a 0a                	push   $0xa
   1365f:	e8 31 18 00 00       	call   14e95 <delay_ms>
    __asm__ volatile("inb %1, %0"
   13664:	ba f4 03 00 00       	mov    $0x3f4,%edx
   13669:	ec                   	in     (%dx),%al
        msr = port_read_byte(FDC_PORT_MSR);
    } while (times-- && (msr & FDC_MSR_BUSY) && !(msr & FDC_MSR_READY));
   1366a:	4b                   	dec    %ebx
   1366b:	83 c4 10             	add    $0x10,%esp
   1366e:	80 fb ff             	cmp    $0xff,%bl
   13671:	74 08                	je     1367b <wait_fdc_ready+0x28>
   13673:	a8 10                	test   $0x10,%al
   13675:	74 04                	je     1367b <wait_fdc_ready+0x28>
   13677:	84 c0                	test   %al,%al
   13679:	79 df                	jns    1365a <wait_fdc_ready+0x7>

    return times >= 0;
   1367b:	88 d8                	mov    %bl,%al
   1367d:	f7 d0                	not    %eax
   1367f:	c0 e8 07             	shr    $0x7,%al
}
   13682:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   13685:	c9                   	leave  
   13686:	c3                   	ret    

00013687 <wait_irq_ready>:

static bool wait_irq_ready(void)
{
   13687:	55                   	push   %ebp
   13688:	89 e5                	mov    %esp,%ebp
   1368a:	53                   	push   %ebx
   1368b:	50                   	push   %eax
   1368c:	b3 65                	mov    $0x65,%bl
    s8 times = 100;

    do
    {
        delay_ms(10);
   1368e:	83 ec 0c             	sub    $0xc,%esp
   13691:	6a 0a                	push   $0xa
   13693:	e8 fd 17 00 00       	call   14e95 <delay_ms>
    } while (times-- && !_irq_trigger);
   13698:	83 c4 10             	add    $0x10,%esp
   1369b:	fe cb                	dec    %bl
   1369d:	74 09                	je     136a8 <wait_irq_ready+0x21>
   1369f:	a0 04 b6 01 00       	mov    0x1b604,%al
   136a4:	84 c0                	test   %al,%al
   136a6:	74 e6                	je     1368e <wait_irq_ready+0x7>

    if (_irq_trigger)
   136a8:	8a 15 04 b6 01 00    	mov    0x1b604,%dl
    {
        --_irq_trigger;
        return true;
    }

    return false;
   136ae:	31 c0                	xor    %eax,%eax
    if (_irq_trigger)
   136b0:	84 d2                	test   %dl,%dl
   136b2:	74 0d                	je     136c1 <wait_irq_ready+0x3a>
        --_irq_trigger;
   136b4:	a0 04 b6 01 00       	mov    0x1b604,%al
   136b9:	48                   	dec    %eax
   136ba:	a2 04 b6 01 00       	mov    %al,0x1b604
   136bf:	b0 01                	mov    $0x1,%al
}
   136c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   136c4:	c9                   	leave  
   136c5:	c3                   	ret    

000136c6 <floppy_dumpinfo>:

void floppy_dumpinfo(void)
{
   136c6:	55                   	push   %ebp
   136c7:	89 e5                	mov    %esp,%ebp
   136c9:	83 ec 08             	sub    $0x8,%esp
    if (!_drive_count)
   136cc:	0f b6 05 08 b6 01 00 	movzbl 0x1b608,%eax
   136d3:	84 c0                	test   %al,%al
   136d5:	75 2a                	jne    13701 <floppy_dumpinfo+0x3b>
    {
        console_set_color(COLOR_NORMAL_BG, COLOR_YELLOW);
   136d7:	50                   	push   %eax
   136d8:	50                   	push   %eax
   136d9:	68 00 fe fe 00       	push   $0xfefe00
   136de:	6a 00                	push   $0x0
   136e0:	e8 ab f0 ff ff       	call   12790 <console_set_color>
        print_str("no floppy drive installed!\n");
   136e5:	c7 04 24 28 83 01 00 	movl   $0x18328,(%esp)
   136ec:	e8 c2 f7 ff ff       	call   12eb3 <print_str>
        console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
   136f1:	58                   	pop    %eax
   136f2:	5a                   	pop    %edx
   136f3:	68 d3 d3 d3 00       	push   $0xd3d3d3
   136f8:	6a 00                	push   $0x0
   136fa:	e8 91 f0 ff ff       	call   12790 <console_set_color>
        return;
   136ff:	eb 58                	jmp    13759 <floppy_dumpinfo+0x93>
    }

    printf("fd_count: %d\n", _drive_count);
   13701:	51                   	push   %ecx
   13702:	51                   	push   %ecx
   13703:	50                   	push   %eax
   13704:	68 44 83 01 00       	push   $0x18344
   13709:	e8 ec f7 ff ff       	call   12efa <printf>

    u8 type[2];
    type[1] = cmos_read_byte(CMOS_REG_FLOPPY_DRIVE_TYPES);
   1370e:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
   13715:	e8 df eb ff ff       	call   122f9 <cmos_read_byte>
            0010 - 1.2M
            0011 - 720k
            0100 - 1.44M
            0101 - 2.88M
        */
    type[0] = type[1] >> 4;
   1371a:	88 c2                	mov    %al,%dl
   1371c:	c0 ea 04             	shr    $0x4,%dl
    type[1] &= 0xf;
   1371f:	83 e0 0f             	and    $0xf,%eax

    static const char *fd_type[] = {"none", "360k", "1.2M", "720k", "1.44M", "2.88M"};

    printf("fd0_type: %s\nfd1_type: %s\n",
   13722:	83 c4 10             	add    $0x10,%esp
   13725:	b9 1e 83 01 00       	mov    $0x1831e,%ecx
   1372a:	3c 05                	cmp    $0x5,%al
   1372c:	77 0a                	ja     13738 <floppy_dumpinfo+0x72>
           type[0] > 5 ? fd_type[0] : fd_type[type[0]],
           type[1] > 5 ? fd_type[1] : fd_type[type[1]]);
   1372e:	0f b6 c0             	movzbl %al,%eax
    printf("fd0_type: %s\nfd1_type: %s\n",
   13731:	8b 0c 85 8c 83 01 00 	mov    0x1838c(,%eax,4),%ecx
   13738:	b8 23 83 01 00       	mov    $0x18323,%eax
   1373d:	80 fa 05             	cmp    $0x5,%dl
   13740:	77 0a                	ja     1374c <floppy_dumpinfo+0x86>
           type[0] > 5 ? fd_type[0] : fd_type[type[0]],
   13742:	0f b6 d2             	movzbl %dl,%edx
    printf("fd0_type: %s\nfd1_type: %s\n",
   13745:	8b 04 95 8c 83 01 00 	mov    0x1838c(,%edx,4),%eax
   1374c:	52                   	push   %edx
   1374d:	51                   	push   %ecx
   1374e:	50                   	push   %eax
   1374f:	68 52 83 01 00       	push   $0x18352
   13754:	e8 a1 f7 ff ff       	call   12efa <printf>
   13759:	83 c4 10             	add    $0x10,%esp
}
   1375c:	c9                   	leave  
   1375d:	c3                   	ret    

0001375e <floppy_setup>:

void floppy_setup(void)
{
   1375e:	55                   	push   %ebp
   1375f:	89 e5                	mov    %esp,%ebp
   13761:	83 ec 14             	sub    $0x14,%esp
    u8 equ = cmos_read_byte(CMOS_REG_EQUIPMENT_INFO);
   13764:	6a 14                	push   $0x14
   13766:	e8 8e eb ff ff       	call   122f9 <cmos_read_byte>
    CMOS_REG_EQUIPMENT_INFO
    Bits 6 & 7 – No. Of Floppy Drives
            00=1, 01=2, 10=3, 11=4
    Bit 0 – Floppy Drive(s) Available
    */
    _drive_count = (equ >> 6) + (equ & 1);
   1376b:	88 c2                	mov    %al,%dl
   1376d:	c0 ea 06             	shr    $0x6,%dl
   13770:	83 e0 01             	and    $0x1,%eax
   13773:	01 d0                	add    %edx,%eax
   13775:	a2 08 b6 01 00       	mov    %al,0x1b608

    if (!_drive_count)
   1377a:	83 c4 10             	add    $0x10,%esp
   1377d:	84 c0                	test   %al,%al
   1377f:	74 0f                	je     13790 <floppy_setup+0x32>
    _fdc_dor = dor;
   13781:	c6 05 05 b6 01 00 00 	movb   $0x0,0x1b605
    __asm__ volatile("outb %0, %1"
   13788:	31 c0                	xor    %eax,%eax
   1378a:	ba f2 03 00 00       	mov    $0x3f2,%edx
   1378f:	ee                   	out    %al,(%dx)
    }

    // for(u8 drive = 0; drive < _drive_count; ++drive)
    // write_dor(drive);
    write_dor(0);
}
   13790:	c9                   	leave  
   13791:	c3                   	ret    

00013792 <floppy_prepare>:

bool floppy_prepare(u8 fd_n, bool transfer)
{
   13792:	55                   	push   %ebp
   13793:	89 e5                	mov    %esp,%ebp
   13795:	56                   	push   %esi
   13796:	53                   	push   %ebx
   13797:	83 ec 10             	sub    $0x10,%esp
   1379a:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (fd_n >= _drive_count)
   1379d:	38 1d 08 b6 01 00    	cmp    %bl,0x1b608
   137a3:	0f 86 94 00 00 00    	jbe    1383d <floppy_prepare+0xab>
        return false;

    _drive_type[1] = cmos_read_byte(CMOS_REG_FLOPPY_DRIVE_TYPES);
   137a9:	83 ec 0c             	sub    $0xc,%esp
   137ac:	6a 10                	push   $0x10
   137ae:	e8 46 eb ff ff       	call   122f9 <cmos_read_byte>
            0010 - 1.2M
            0011 - 720k
            0100 - 1.44M
            0101 - 2.88M
        */
    _drive_type[0] = _drive_type[1] >> 4;
   137b3:	88 c2                	mov    %al,%dl
   137b5:	c0 ea 04             	shr    $0x4,%dl
   137b8:	88 15 06 b6 01 00    	mov    %dl,0x1b606
    _drive_type[1] &= 0xf;
   137be:	83 e0 0f             	and    $0xf,%eax
   137c1:	a2 07 b6 01 00       	mov    %al,0x1b607

    if (!_drive_type[fd_n])
   137c6:	0f b6 f3             	movzbl %bl,%esi
   137c9:	83 c4 10             	add    $0x10,%esp
   137cc:	80 be 06 b6 01 00 00 	cmpb   $0x0,0x1b606(%esi)
   137d3:	74 68                	je     1383d <floppy_prepare+0xab>
    {
        return false;
    }

    _irq_trigger = 0;
   137d5:	c6 05 04 b6 01 00 00 	movb   $0x0,0x1b604
    pic_irq_set_entry(FDC_IRQ, _irq_handler);
   137dc:	50                   	push   %eax
   137dd:	50                   	push   %eax
   137de:	68 47 36 01 00       	push   $0x13647
   137e3:	6a 06                	push   $0x6
   137e5:	e8 f2 24 00 00       	call   15cdc <pic_irq_set_entry>
    pic_irq_enable(FDC_IRQ);
   137ea:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
   137f1:	e8 97 24 00 00       	call   15c8d <pic_irq_enable>
    write_dor((FDC_DOR_MOTOR_A << fd_n) | FDC_DOR_DMA_IRQ | fd_n);
   137f6:	b8 10 00 00 00       	mov    $0x10,%eax
   137fb:	89 f1                	mov    %esi,%ecx
   137fd:	d3 e0                	shl    %cl,%eax
   137ff:	09 d8                	or     %ebx,%eax
   13801:	83 c8 08             	or     $0x8,%eax
    _fdc_dor = dor;
   13804:	a2 05 b6 01 00       	mov    %al,0x1b605
   13809:	ba f2 03 00 00       	mov    $0x3f2,%edx
   1380e:	ee                   	out    %al,(%dx)
   1380f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    // mask_dor((FDC_DOR_MOTOR_A << fd_n) | FDC_DOR_DMA_IRQ | fd_n, FDC_DOR_RESET);
    delay_ms(100);
   13812:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
   13819:	e8 77 16 00 00       	call   14e95 <delay_ms>
    write_dor((read_dor() & ~off) | on);
   1381e:	a0 05 b6 01 00       	mov    0x1b605,%al
   13823:	83 c8 04             	or     $0x4,%eax
    _fdc_dor = dor;
   13826:	a2 05 b6 01 00       	mov    %al,0x1b605
   1382b:	8b 55 f4             	mov    -0xc(%ebp),%edx
   1382e:	ee                   	out    %al,(%dx)
    mask_dor(FDC_DOR_RESET, 0);
    return wait_irq_ready();
   1382f:	83 c4 10             	add    $0x10,%esp
}
   13832:	8d 65 f8             	lea    -0x8(%ebp),%esp
   13835:	5b                   	pop    %ebx
   13836:	5e                   	pop    %esi
   13837:	5d                   	pop    %ebp
    return wait_irq_ready();
   13838:	e9 4a fe ff ff       	jmp    13687 <wait_irq_ready>
}
   1383d:	31 c0                	xor    %eax,%eax
   1383f:	8d 65 f8             	lea    -0x8(%ebp),%esp
   13842:	5b                   	pop    %ebx
   13843:	5e                   	pop    %esi
   13844:	5d                   	pop    %ebp
   13845:	c3                   	ret    

00013846 <floppy_release>:

bool floppy_release(u8 fd_n)
{
   13846:	55                   	push   %ebp
   13847:	89 e5                	mov    %esp,%ebp
   13849:	53                   	push   %ebx
   1384a:	83 ec 14             	sub    $0x14,%esp
   1384d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (fd_n >= _drive_count)
   13850:	31 c0                	xor    %eax,%eax
   13852:	38 1d 08 b6 01 00    	cmp    %bl,0x1b608
   13858:	76 6d                	jbe    138c7 <floppy_release+0x81>
    write_dor((read_dor() & ~off) | on);
   1385a:	a0 05 b6 01 00       	mov    0x1b605,%al
   1385f:	83 e0 fb             	and    $0xfffffffb,%eax
    _fdc_dor = dor;
   13862:	a2 05 b6 01 00       	mov    %al,0x1b605
   13867:	ba f2 03 00 00       	mov    $0x3f2,%edx
   1386c:	ee                   	out    %al,(%dx)
   1386d:	89 55 f4             	mov    %edx,-0xc(%ebp)
    {
        return false;
    }

    mask_dor(0, FDC_DOR_RESET);
    delay_ms(100);
   13870:	83 ec 0c             	sub    $0xc,%esp
   13873:	6a 64                	push   $0x64
   13875:	e8 1b 16 00 00       	call   14e95 <delay_ms>
    if (wait_fdc_ready())
   1387a:	e8 d4 fd ff ff       	call   13653 <wait_fdc_ready>
   1387f:	83 c4 10             	add    $0x10,%esp
   13882:	84 c0                	test   %al,%al
   13884:	8b 55 f4             	mov    -0xc(%ebp),%edx
   13887:	74 2f                	je     138b8 <floppy_release+0x72>
    {
        mask_dor(FDC_DOR_RESET, (FDC_DOR_MOTOR_A << fd_n) | FDC_DOR_DMA_IRQ);
   13889:	b8 10 00 00 00       	mov    $0x10,%eax
   1388e:	88 d9                	mov    %bl,%cl
   13890:	d3 e0                	shl    %cl,%eax
   13892:	83 c8 08             	or     $0x8,%eax
    write_dor((read_dor() & ~off) | on);
   13895:	f7 d0                	not    %eax
   13897:	22 05 05 b6 01 00    	and    0x1b605,%al
   1389d:	83 c8 04             	or     $0x4,%eax
    _fdc_dor = dor;
   138a0:	a2 05 b6 01 00       	mov    %al,0x1b605
   138a5:	ee                   	out    %al,(%dx)
        delay_ms(50);
   138a6:	83 ec 0c             	sub    $0xc,%esp
   138a9:	6a 32                	push   $0x32
   138ab:	e8 e5 15 00 00       	call   14e95 <delay_ms>
        wait_irq_ready();
   138b0:	e8 d2 fd ff ff       	call   13687 <wait_irq_ready>
   138b5:	83 c4 10             	add    $0x10,%esp
    }
    pic_irq_remove_entry(FDC_IRQ);
   138b8:	83 ec 0c             	sub    $0xc,%esp
   138bb:	6a 06                	push   $0x6
   138bd:	e8 48 24 00 00       	call   15d0a <pic_irq_remove_entry>
    return true;
   138c2:	83 c4 10             	add    $0x10,%esp
   138c5:	b0 01                	mov    $0x1,%al
}
   138c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   138ca:	c9                   	leave  
   138cb:	c3                   	ret    

000138cc <floppy_cmd_readid>:

void floppy_cmd_readid(void)
{
   138cc:	55                   	push   %ebp
   138cd:	89 e5                	mov    %esp,%ebp
   138cf:	56                   	push   %esi
   138d0:	53                   	push   %ebx
    u8 send_len = 2, recv_len = 7;

    for (; send_len; --send_len)
    {
        if (!wait_fdc_ready())
   138d1:	e8 7d fd ff ff       	call   13653 <wait_fdc_ready>
   138d6:	84 c0                	test   %al,%al
   138d8:	74 7b                	je     13955 <floppy_cmd_readid+0x89>
    __asm__ volatile("inb %1, %0"
   138da:	be f4 03 00 00       	mov    $0x3f4,%esi
   138df:	89 f2                	mov    %esi,%edx
   138e1:	ec                   	in     (%dx),%al
            break;

        if (port_read_byte(FDC_PORT_MSR) & FDC_MSR_IOD)
   138e2:	a8 40                	test   $0x40,%al
   138e4:	75 6f                	jne    13955 <floppy_cmd_readid+0x89>
    __asm__ volatile("outb %0, %1"
   138e6:	bb f5 03 00 00       	mov    $0x3f5,%ebx
   138eb:	b0 4a                	mov    $0x4a,%al
   138ed:	89 da                	mov    %ebx,%edx
   138ef:	ee                   	out    %al,(%dx)
        if (!wait_fdc_ready())
   138f0:	e8 5e fd ff ff       	call   13653 <wait_fdc_ready>
   138f5:	84 c0                	test   %al,%al
   138f7:	74 5c                	je     13955 <floppy_cmd_readid+0x89>
    __asm__ volatile("inb %1, %0"
   138f9:	89 f2                	mov    %esi,%edx
   138fb:	ec                   	in     (%dx),%al
        if (port_read_byte(FDC_PORT_MSR) & FDC_MSR_IOD)
   138fc:	24 40                	and    $0x40,%al
   138fe:	75 55                	jne    13955 <floppy_cmd_readid+0x89>
    __asm__ volatile("outb %0, %1"
   13900:	89 da                	mov    %ebx,%edx
   13902:	ee                   	out    %al,(%dx)
            port_write_byte(FDC_PORT_DATA, 0);
    }

    if (!send_len)
    { // in BOCHS irq not triggered
        wait_irq_ready();
   13903:	e8 7f fd ff ff       	call   13687 <wait_irq_ready>
        print_str("result: ");
   13908:	83 ec 0c             	sub    $0xc,%esp
   1390b:	68 6d 83 01 00       	push   $0x1836d
   13910:	e8 9e f5 ff ff       	call   12eb3 <print_str>
   13915:	83 c4 10             	add    $0x10,%esp
   13918:	b3 07                	mov    $0x7,%bl
        for (; recv_len; --recv_len)
        {
            if (!wait_fdc_ready())
   1391a:	e8 34 fd ff ff       	call   13653 <wait_fdc_ready>
   1391f:	84 c0                	test   %al,%al
   13921:	74 32                	je     13955 <floppy_cmd_readid+0x89>
    __asm__ volatile("inb %1, %0"
   13923:	ba f4 03 00 00       	mov    $0x3f4,%edx
   13928:	ec                   	in     (%dx),%al
                break;

            if (!(port_read_byte(FDC_PORT_MSR) & FDC_MSR_IOD))
   13929:	a8 40                	test   $0x40,%al
   1392b:	74 28                	je     13955 <floppy_cmd_readid+0x89>
   1392d:	ba f5 03 00 00       	mov    $0x3f5,%edx
   13932:	ec                   	in     (%dx),%al
                break;

            print_hex(port_read_byte(FDC_PORT_DATA), 2);
   13933:	52                   	push   %edx
   13934:	52                   	push   %edx
   13935:	6a 02                	push   $0x2
   13937:	0f b6 c0             	movzbl %al,%eax
   1393a:	50                   	push   %eax
   1393b:	e8 96 f6 ff ff       	call   12fd6 <print_hex>
            print_char(' ');
   13940:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
   13947:	e8 16 f1 ff ff       	call   12a62 <print_char>
        for (; recv_len; --recv_len)
   1394c:	83 c4 10             	add    $0x10,%esp
   1394f:	fe cb                	dec    %bl
   13951:	75 c7                	jne    1391a <floppy_cmd_readid+0x4e>
   13953:	eb 10                	jmp    13965 <floppy_cmd_readid+0x99>
        }
    }

    if (send_len || recv_len)
    {
        print_str("failed!");
   13955:	83 ec 0c             	sub    $0xc,%esp
   13958:	68 40 93 01 00       	push   $0x19340
   1395d:	e8 51 f5 ff ff       	call   12eb3 <print_str>
   13962:	83 c4 10             	add    $0x10,%esp
    }
    print_char('\n');
   13965:	83 ec 0c             	sub    $0xc,%esp
   13968:	6a 0a                	push   $0xa
   1396a:	e8 f3 f0 ff ff       	call   12a62 <print_char>
}
   1396f:	83 c4 10             	add    $0x10,%esp
   13972:	8d 65 f8             	lea    -0x8(%ebp),%esp
   13975:	5b                   	pop    %ebx
   13976:	5e                   	pop    %esi
   13977:	5d                   	pop    %ebp
   13978:	c3                   	ret    

00013979 <floppy_cmd_version>:

void floppy_cmd_version(void)
{
   13979:	55                   	push   %ebp
   1397a:	89 e5                	mov    %esp,%ebp
   1397c:	56                   	push   %esi
   1397d:	53                   	push   %ebx
    u8 send_len = 1, recv_len = 1;

    for (; send_len; --send_len)
    {
        if (!wait_fdc_ready())
   1397e:	e8 d0 fc ff ff       	call   13653 <wait_fdc_ready>
   13983:	84 c0                	test   %al,%al
   13985:	74 59                	je     139e0 <floppy_cmd_version+0x67>
   13987:	be f4 03 00 00       	mov    $0x3f4,%esi
   1398c:	89 f2                	mov    %esi,%edx
   1398e:	ec                   	in     (%dx),%al
            break;

        if (port_read_byte(FDC_PORT_MSR) & FDC_MSR_IOD)
   1398f:	a8 40                	test   $0x40,%al
   13991:	75 4d                	jne    139e0 <floppy_cmd_version+0x67>
    __asm__ volatile("outb %0, %1"
   13993:	bb f5 03 00 00       	mov    $0x3f5,%ebx
   13998:	b0 10                	mov    $0x10,%al
   1399a:	89 da                	mov    %ebx,%edx
   1399c:	ee                   	out    %al,(%dx)
            port_write_byte(FDC_PORT_DATA, FDC_CMD_VERSION);
    }

    if (!send_len)
    { // in BOCHS irq not triggered
        wait_irq_ready();
   1399d:	e8 e5 fc ff ff       	call   13687 <wait_irq_ready>
        print_str("result: ");
   139a2:	83 ec 0c             	sub    $0xc,%esp
   139a5:	68 6d 83 01 00       	push   $0x1836d
   139aa:	e8 04 f5 ff ff       	call   12eb3 <print_str>
        for (; recv_len; --recv_len)
        {
            if (!wait_fdc_ready())
   139af:	e8 9f fc ff ff       	call   13653 <wait_fdc_ready>
   139b4:	83 c4 10             	add    $0x10,%esp
   139b7:	84 c0                	test   %al,%al
   139b9:	74 25                	je     139e0 <floppy_cmd_version+0x67>
    __asm__ volatile("inb %1, %0"
   139bb:	89 f2                	mov    %esi,%edx
   139bd:	ec                   	in     (%dx),%al
                break;

            if (!(port_read_byte(FDC_PORT_MSR) & FDC_MSR_IOD))
   139be:	a8 40                	test   $0x40,%al
   139c0:	74 1e                	je     139e0 <floppy_cmd_version+0x67>
   139c2:	89 da                	mov    %ebx,%edx
   139c4:	ec                   	in     (%dx),%al
                break;

            print_hex(port_read_byte(FDC_PORT_DATA), 2);
   139c5:	52                   	push   %edx
   139c6:	52                   	push   %edx
   139c7:	6a 02                	push   $0x2
   139c9:	0f b6 c0             	movzbl %al,%eax
   139cc:	50                   	push   %eax
   139cd:	e8 04 f6 ff ff       	call   12fd6 <print_hex>
            print_char(' ');
   139d2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
   139d9:	e8 84 f0 ff ff       	call   12a62 <print_char>
        }
    }

    if (send_len || recv_len)
   139de:	eb 0d                	jmp    139ed <floppy_cmd_version+0x74>
    {
        print_str("failed!");
   139e0:	83 ec 0c             	sub    $0xc,%esp
   139e3:	68 40 93 01 00       	push   $0x19340
   139e8:	e8 c6 f4 ff ff       	call   12eb3 <print_str>
   139ed:	83 c4 10             	add    $0x10,%esp
    }
    print_char('\n');
   139f0:	83 ec 0c             	sub    $0xc,%esp
   139f3:	6a 0a                	push   $0xa
   139f5:	e8 68 f0 ff ff       	call   12a62 <print_char>
}
   139fa:	83 c4 10             	add    $0x10,%esp
   139fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
   13a00:	5b                   	pop    %ebx
   13a01:	5e                   	pop    %esi
   13a02:	5d                   	pop    %ebp
   13a03:	c3                   	ret    

00013a04 <gdt_set_entry>:
#include "gdt.h"

void gdt_set_entry(u32 seg, const struct gdt_entry *entry)
{
   13a04:	55                   	push   %ebp
   13a05:	89 e5                	mov    %esp,%ebp
   13a07:	53                   	push   %ebx
   13a08:	83 ec 10             	sub    $0x10,%esp
   13a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
					 : "memory");
}

inline static void sgdt(struct gdt_ptr48 *ptr)
{
	__asm__ __volatile__("sgdt (%0)\n"
   13a0e:	8d 45 f6             	lea    -0xa(%ebp),%eax
   13a11:	0f 01 00             	sgdtl  (%eax)
    struct gdt_ptr48 gdt_ptr;
    sgdt(&gdt_ptr);

    u16 *entry_ptr = (u16*)(gdt_ptr.base + (seg << 3));
   13a14:	8b 4d 08             	mov    0x8(%ebp),%ecx
   13a17:	8b 45 f8             	mov    -0x8(%ebp),%eax
   13a1a:	8d 0c c8             	lea    (%eax,%ecx,8),%ecx
    entry_ptr[0] = entry->limit;
   13a1d:	8b 42 04             	mov    0x4(%edx),%eax
   13a20:	66 89 01             	mov    %ax,(%ecx)
	entry_ptr[1] = entry->base;
   13a23:	8b 02                	mov    (%edx),%eax
   13a25:	66 89 41 02          	mov    %ax,0x2(%ecx)
	entry_ptr[2] = ((entry->attr & 0xff) << 8) | ((entry->base >> 16) & 0xff);
   13a29:	0f b6 42 02          	movzbl 0x2(%edx),%eax
   13a2d:	8b 5a 08             	mov    0x8(%edx),%ebx
   13a30:	c1 e3 08             	shl    $0x8,%ebx
   13a33:	09 d8                	or     %ebx,%eax
   13a35:	66 89 41 04          	mov    %ax,0x4(%ecx)
	entry_ptr[3] = ((entry->base >> 16) & 0xff00) | ((entry->attr >> 4) & 0xf0) | (entry->limit >> 16);
   13a39:	8b 02                	mov    (%edx),%eax
   13a3b:	c1 e8 10             	shr    $0x10,%eax
   13a3e:	30 c0                	xor    %al,%al
   13a40:	8b 5a 08             	mov    0x8(%edx),%ebx
   13a43:	c1 eb 04             	shr    $0x4,%ebx
   13a46:	66 81 e3 f0 00       	and    $0xf0,%bx
   13a4b:	09 d8                	or     %ebx,%eax
   13a4d:	66 0b 42 06          	or     0x6(%edx),%ax
   13a51:	66 89 41 06          	mov    %ax,0x6(%ecx)
}
   13a55:	83 c4 10             	add    $0x10,%esp
   13a58:	5b                   	pop    %ebx
   13a59:	5d                   	pop    %ebp
   13a5a:	c3                   	ret    

00013a5b <gdt_get_entry>:

void gdt_get_entry(u32 seg, struct gdt_entry *entry)
{
   13a5b:	55                   	push   %ebp
   13a5c:	89 e5                	mov    %esp,%ebp
   13a5e:	56                   	push   %esi
   13a5f:	53                   	push   %ebx
   13a60:	83 ec 10             	sub    $0x10,%esp
   13a63:	8b 55 0c             	mov    0xc(%ebp),%edx
   13a66:	8d 45 f2             	lea    -0xe(%ebp),%eax
   13a69:	0f 01 00             	sgdtl  (%eax)
    struct gdt_ptr48 gdt_ptr;
    sgdt(&gdt_ptr);

    u32 *entry_ptr = (u32*)(gdt_ptr.base + (seg << 3));
   13a6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
   13a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
   13a72:	8d 1c c8             	lea    (%eax,%ecx,8),%ebx
    entry->base = (entry_ptr[0] >> 16) | (entry_ptr[1] & 0xff000000) | ((entry_ptr[1] << 16) & 0xff0000);
   13a75:	8b 4b 04             	mov    0x4(%ebx),%ecx
   13a78:	8b 03                	mov    (%ebx),%eax
   13a7a:	c1 e8 10             	shr    $0x10,%eax
   13a7d:	89 ce                	mov    %ecx,%esi
   13a7f:	81 e6 00 00 00 ff    	and    $0xff000000,%esi
   13a85:	09 f0                	or     %esi,%eax
   13a87:	c1 e1 10             	shl    $0x10,%ecx
   13a8a:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
   13a90:	09 c8                	or     %ecx,%eax
   13a92:	89 02                	mov    %eax,(%edx)
    entry->limit = (entry_ptr[0] & 0xffff) | (entry_ptr[1] & 0xf0000);
   13a94:	0f b7 03             	movzwl (%ebx),%eax
   13a97:	8b 4b 04             	mov    0x4(%ebx),%ecx
   13a9a:	81 e1 00 00 0f 00    	and    $0xf0000,%ecx
   13aa0:	09 c8                	or     %ecx,%eax
   13aa2:	89 42 04             	mov    %eax,0x4(%edx)
    entry->attr = ((entry_ptr[1] >> 8) & 0xff) | ((entry_ptr[1] >> 16) & 0xf00);
   13aa5:	8b 43 04             	mov    0x4(%ebx),%eax
   13aa8:	0f b6 cc             	movzbl %ah,%ecx
   13aab:	c1 e8 10             	shr    $0x10,%eax
   13aae:	25 00 0f 00 00       	and    $0xf00,%eax
   13ab3:	09 c8                	or     %ecx,%eax
   13ab5:	89 42 08             	mov    %eax,0x8(%edx)
}
   13ab8:	83 c4 10             	add    $0x10,%esp
   13abb:	5b                   	pop    %ebx
   13abc:	5e                   	pop    %esi
   13abd:	5d                   	pop    %ebp
   13abe:	c3                   	ret    

00013abf <_irq_handler0>:

static void _irq_handler0(void)
{
    // ++_irq0_invoked;
    // printf("_irq0_invoked=%d\n", _irq0_invoked);
}
   13abf:	c3                   	ret    

00013ac0 <ide_write>:
    // ++_irq1_invoked;
    // printf("_irq0_invoked=%d\n", _irq0_invoked);
}

static void ide_write(u8 channel, u8 reg, u8 data)
{
   13ac0:	55                   	push   %ebp
   13ac1:	89 e5                	mov    %esp,%ebp
   13ac3:	57                   	push   %edi
   13ac4:	56                   	push   %esi
   13ac5:	53                   	push   %ebx
   13ac6:	83 ec 1c             	sub    $0x1c,%esp
   13ac9:	89 d3                	mov    %edx,%ebx
   13acb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    if (ATA_REG_COMMAND < reg && reg < ATA_REG_CONTROL)
    {
        ide_write(channel, ATA_REG_CONTROL, ATA_CONTROL_HOB | _ide_info.channel[channel].irq_disable << ATA_CONTROL_NIEN_SHIFT);
   13ace:	0f b6 f0             	movzbl %al,%esi
    if (ATA_REG_COMMAND < reg && reg < ATA_REG_CONTROL)
   13ad1:	8d 42 f8             	lea    -0x8(%edx),%eax
   13ad4:	3c 03                	cmp    $0x3,%al
   13ad6:	77 53                	ja     13b2b <ide_write+0x6b>
        ide_write(channel, ATA_REG_CONTROL, ATA_CONTROL_HOB | _ide_info.channel[channel].irq_disable << ATA_CONTROL_NIEN_SHIFT);
   13ad8:	69 c6 3c 04 00 00    	imul   $0x43c,%esi,%eax
   13ade:	8d b8 20 b6 01 00    	lea    0x1b620(%eax),%edi
   13ae4:	0f b6 88 74 ba 01 00 	movzbl 0x1ba74(%eax),%ecx
   13aeb:	01 c9                	add    %ecx,%ecx
   13aed:	83 c9 80             	or     $0xffffff80,%ecx
   13af0:	0f b6 c9             	movzbl %cl,%ecx
   13af3:	ba 0c 00 00 00       	mov    $0xc,%edx
   13af8:	89 f0                	mov    %esi,%eax
   13afa:	e8 c1 ff ff ff       	call   13ac0 <ide_write>
        port_write_byte(_ide_info.channel[channel].cmd_base + reg - ATA_REG_SECTOR_COUNT1 + ATA_REG_SECTOR_COUNT0, data);
   13aff:	8b 87 48 04 00 00    	mov    0x448(%edi),%eax
   13b05:	0f b6 d3             	movzbl %bl,%edx
   13b08:	8d 54 02 fa          	lea    -0x6(%edx,%eax,1),%edx
    __asm__ volatile("outb %0, %1"
   13b0c:	8a 45 e4             	mov    -0x1c(%ebp),%al
   13b0f:	ee                   	out    %al,(%dx)
        ide_write(channel, ATA_REG_CONTROL, _ide_info.channel[channel].irq_disable << ATA_CONTROL_NIEN_SHIFT);
   13b10:	8a 8f 54 04 00 00    	mov    0x454(%edi),%cl
   13b16:	d1 e1                	shl    %ecx
   13b18:	0f b6 c9             	movzbl %cl,%ecx
   13b1b:	ba 0c 00 00 00       	mov    $0xc,%edx
   13b20:	89 f0                	mov    %esi,%eax
    }
    else
    {
        printf("%s(): unexpecting reg: 0x%x\n", __func__, reg);
    }
}
   13b22:	83 c4 1c             	add    $0x1c,%esp
   13b25:	5b                   	pop    %ebx
   13b26:	5e                   	pop    %esi
   13b27:	5f                   	pop    %edi
   13b28:	5d                   	pop    %ebp
        ide_write(channel, ATA_REG_CONTROL, _ide_info.channel[channel].irq_disable << ATA_CONTROL_NIEN_SHIFT);
   13b29:	eb 95                	jmp    13ac0 <ide_write>
        port_write_byte(_ide_info.channel[channel].cmd_base + reg, data);
   13b2b:	69 f6 3c 04 00 00    	imul   $0x43c,%esi,%esi
    else if (reg <= ATA_REG_COMMAND)
   13b31:	80 fa 07             	cmp    $0x7,%dl
   13b34:	77 0b                	ja     13b41 <ide_write+0x81>
        port_write_byte(_ide_info.channel[channel].cmd_base + reg, data);
   13b36:	0f b6 d2             	movzbl %dl,%edx
   13b39:	03 96 68 ba 01 00    	add    0x1ba68(%esi),%edx
   13b3f:	eb 1a                	jmp    13b5b <ide_write+0x9b>
    else if (reg <= ATA_REG_CONTROL)
   13b41:	80 fa 0c             	cmp    $0xc,%dl
   13b44:	75 08                	jne    13b4e <ide_write+0x8e>
        port_write_byte(_ide_info.channel[channel].ctrl_base + reg - ATA_REG_CONTROL, data);
   13b46:	8b 96 6c ba 01 00    	mov    0x1ba6c(%esi),%edx
   13b4c:	eb 0d                	jmp    13b5b <ide_write+0x9b>
        port_write_byte(_ide_info.channel[channel].busmaster_base + reg - IDE_REG_BM_COMMAND, data);
   13b4e:	8b 86 70 ba 01 00    	mov    0x1ba70(%esi),%eax
   13b54:	0f b6 d2             	movzbl %dl,%edx
   13b57:	8d 54 02 f3          	lea    -0xd(%edx,%eax,1),%edx
   13b5b:	8a 45 e4             	mov    -0x1c(%ebp),%al
   13b5e:	ee                   	out    %al,(%dx)
}
   13b5f:	83 c4 1c             	add    $0x1c,%esp
   13b62:	5b                   	pop    %ebx
   13b63:	5e                   	pop    %esi
   13b64:	5f                   	pop    %edi
   13b65:	5d                   	pop    %ebp
   13b66:	c3                   	ret    

00013b67 <ide_read>:
        data = port_read_byte(_ide_info.channel[channel].cmd_base + reg - ATA_REG_SECTOR_COUNT1 + ATA_REG_SECTOR_COUNT0);
        ide_write(channel, ATA_REG_CONTROL, _ide_info.channel[channel].irq_disable << ATA_CONTROL_NIEN_SHIFT);
    }
    else if (reg <= ATA_REG_STATUS)
    {
        data = port_read_byte(_ide_info.channel[channel].cmd_base + reg);
   13b67:	0f b6 c0             	movzbl %al,%eax
   13b6a:	69 c0 3c 04 00 00    	imul   $0x43c,%eax,%eax
   13b70:	0f b6 d2             	movzbl %dl,%edx
   13b73:	03 90 68 ba 01 00    	add    0x1ba68(%eax),%edx
    __asm__ volatile("inb %1, %0"
   13b79:	ec                   	in     (%dx),%al
        printf("%s(): unexpecting reg: 0x%x\n", __func__, reg);
        data = 0;
    }

    return data;
}
   13b7a:	c3                   	ret    

00013b7b <ide_wait>:

static s8 ide_wait(u8 channel, bool check_err, u8 *err)
{
   13b7b:	55                   	push   %ebp
   13b7c:	89 e5                	mov    %esp,%ebp
   13b7e:	57                   	push   %edi
   13b7f:	56                   	push   %esi
   13b80:	53                   	push   %ebx
   13b81:	83 ec 0c             	sub    $0xc,%esp
   13b84:	89 d3                	mov    %edx,%ebx
   13b86:	be 31 75 00 00       	mov    $0x7531,%esi
    int times = 30000;
    s8 ret = 0;

    while (true)
    {
        status = ide_read(channel, ATA_REG_STATUS);
   13b8b:	0f b6 f8             	movzbl %al,%edi
   13b8e:	ba 07 00 00 00       	mov    $0x7,%edx
   13b93:	89 f8                	mov    %edi,%eax
   13b95:	e8 cd ff ff ff       	call   13b67 <ide_read>
        if (status & ATA_STATUS_BSY)
   13b9a:	84 c0                	test   %al,%al
   13b9c:	79 07                	jns    13ba5 <ide_wait+0x2a>
        {
            if (times-- == 0)
   13b9e:	4e                   	dec    %esi
   13b9f:	75 ed                	jne    13b8e <ide_wait+0x13>
            {
                ret = -2;
   13ba1:	b2 fe                	mov    $0xfe,%dl
   13ba3:	eb 02                	jmp    13ba7 <ide_wait+0x2c>
    s8 ret = 0;
   13ba5:	31 d2                	xor    %edx,%edx
        //     ret = -1;
        //     break;
        // }
    }

    if (check_err)
   13ba7:	84 db                	test   %bl,%bl
   13ba9:	74 0e                	je     13bb9 <ide_wait+0x3e>
    {
        if ((status & (ATA_STATUS_DF | ATA_STATUS_ERR)) || !(status & ATA_STATUS_DRQ))
   13bab:	88 c3                	mov    %al,%bl
   13bad:	83 e3 29             	and    $0x29,%ebx
   13bb0:	80 fb 08             	cmp    $0x8,%bl
   13bb3:	74 04                	je     13bb9 <ide_wait+0x3e>
        {
            ret = -1;
            *err = status;
   13bb5:	88 01                	mov    %al,(%ecx)
            ret = -1;
   13bb7:	b2 ff                	mov    $0xff,%dl
        }
    }
    return ret;
}
   13bb9:	88 d0                	mov    %dl,%al
   13bbb:	83 c4 0c             	add    $0xc,%esp
   13bbe:	5b                   	pop    %ebx
   13bbf:	5e                   	pop    %esi
   13bc0:	5f                   	pop    %edi
   13bc1:	5d                   	pop    %ebp
   13bc2:	c3                   	ret    

00013bc3 <_irq_handler1>:
   13bc3:	c3                   	ret    

00013bc4 <ide_setup>:
    }
}
#endif

void ide_setup(void)
{
   13bc4:	55                   	push   %ebp
   13bc5:	89 e5                	mov    %esp,%ebp
   13bc7:	57                   	push   %edi
   13bc8:	56                   	push   %esi
   13bc9:	53                   	push   %ebx
   13bca:	83 ec 44             	sub    $0x44,%esp
    struct pci_dev_info *dev_info = &_ide_info.controller;
    dev_info->class = 0x1;    // Mass storage controller
   13bcd:	66 c7 05 37 b6 01 00 	movw   $0x101,0x1b637
   13bd4:	01 01 
    dev_info->subclass = 0x1; // IDE controller

    _ide_info.present = pci_dev_find(dev_info, false);
   13bd6:	6a 00                	push   $0x0
   13bd8:	68 24 b6 01 00       	push   $0x1b624
   13bdd:	e8 fd 1c 00 00       	call   158df <pci_dev_find>
   13be2:	a2 20 b6 01 00       	mov    %al,0x1b620
    if (!_ide_info.present)
   13be7:	83 c4 10             	add    $0x10,%esp
   13bea:	84 c0                	test   %al,%al
   13bec:	75 2d                	jne    13c1b <ide_setup+0x57>
    {
        console_set_color(COLOR_NORMAL_BG, COLOR_YELLOW);
   13bee:	50                   	push   %eax
   13bef:	50                   	push   %eax
   13bf0:	68 00 fe fe 00       	push   $0xfefe00
   13bf5:	6a 00                	push   $0x0
   13bf7:	e8 94 eb ff ff       	call   12790 <console_set_color>
        print_str("PCI IDE controller not present!\n");
   13bfc:	c7 04 24 b9 89 01 00 	movl   $0x189b9,(%esp)
   13c03:	e8 ab f2 ff ff       	call   12eb3 <print_str>
        console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
   13c08:	58                   	pop    %eax
   13c09:	5a                   	pop    %edx
   13c0a:	68 d3 d3 d3 00       	push   $0xd3d3d3
   13c0f:	6a 00                	push   $0x0
   13c11:	e8 7a eb ff ff       	call   12790 <console_set_color>
        return;
   13c16:	e9 ab 06 00 00       	jmp    142c6 <ide_setup+0x702>
    }

    printf("PCI IDE controller\n"
   13c1b:	50                   	push   %eax
   13c1c:	50                   	push   %eax
   13c1d:	0f b6 05 36 b6 01 00 	movzbl 0x1b636,%eax
   13c24:	50                   	push   %eax
   13c25:	0f b6 05 39 b6 01 00 	movzbl 0x1b639,%eax
   13c2c:	50                   	push   %eax
   13c2d:	0f b6 05 38 b6 01 00 	movzbl 0x1b638,%eax
   13c34:	50                   	push   %eax
   13c35:	0f b6 05 37 b6 01 00 	movzbl 0x1b637,%eax
   13c3c:	50                   	push   %eax
   13c3d:	0f b7 05 34 b6 01 00 	movzwl 0x1b634,%eax
   13c44:	50                   	push   %eax
   13c45:	0f b7 05 32 b6 01 00 	movzwl 0x1b632,%eax
   13c4c:	50                   	push   %eax
   13c4d:	ff 35 2c b6 01 00    	push   0x1b62c
   13c53:	ff 35 28 b6 01 00    	push   0x1b628
   13c59:	ff 35 24 b6 01 00    	push   0x1b624
   13c5f:	68 da 89 01 00       	push   $0x189da
   13c64:	e8 91 f2 ff ff       	call   12efa <printf>
           dev_info->bus, dev_info->dev, dev_info->func,
           dev_info->ven_id, dev_info->dev_id,
           dev_info->class, dev_info->subclass, dev_info->progif, dev_info->rev);
    
    u32 subsys_ven, status_cmd;
    subsys_ven = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, 11);
   13c69:	83 c4 30             	add    $0x30,%esp
   13c6c:	6a 0b                	push   $0xb
   13c6e:	ff 35 2c b6 01 00    	push   0x1b62c
   13c74:	ff 35 28 b6 01 00    	push   0x1b628
   13c7a:	ff 35 24 b6 01 00    	push   0x1b624
   13c80:	e8 5e 1a 00 00       	call   156e3 <pci_conf_read_dword>
    printf("subsys: 0x%x, ven: 0x%x\n", subsys_ven >> 16, subsys_ven & 0xffff);
   13c85:	83 c4 0c             	add    $0xc,%esp
   13c88:	0f b7 d0             	movzwl %ax,%edx
   13c8b:	52                   	push   %edx
   13c8c:	c1 e8 10             	shr    $0x10,%eax
   13c8f:	50                   	push   %eax
   13c90:	68 3c 82 01 00       	push   $0x1823c
   13c95:	e8 60 f2 ff ff       	call   12efa <printf>
    status_cmd = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, 1);
   13c9a:	6a 01                	push   $0x1
   13c9c:	ff 35 2c b6 01 00    	push   0x1b62c
   13ca2:	ff 35 28 b6 01 00    	push   0x1b628
   13ca8:	ff 35 24 b6 01 00    	push   0x1b624
   13cae:	e8 30 1a 00 00       	call   156e3 <pci_conf_read_dword>
   13cb3:	89 c6                	mov    %eax,%esi
    printf("status: 0x%x, command: 0x%x\n", status_cmd >> 16, status_cmd & 0xffff);
   13cb5:	83 c4 1c             	add    $0x1c,%esp
   13cb8:	0f b7 c0             	movzwl %ax,%eax
   13cbb:	50                   	push   %eax
   13cbc:	89 f0                	mov    %esi,%eax
   13cbe:	c1 e8 10             	shr    $0x10,%eax
   13cc1:	50                   	push   %eax
   13cc2:	68 55 82 01 00       	push   $0x18255
   13cc7:	e8 2e f2 ff ff       	call   12efa <printf>

    u16 intr_pin_line = pci_conf_read_word(dev_info->bus, dev_info->dev, dev_info->func, 30);
   13ccc:	6a 1e                	push   $0x1e
   13cce:	ff 35 2c b6 01 00    	push   0x1b62c
   13cd4:	ff 35 28 b6 01 00    	push   0x1b628
   13cda:	ff 35 24 b6 01 00    	push   0x1b624
   13ce0:	e8 9a 1a 00 00       	call   1577f <pci_conf_read_word>
    printf("IntrPin: %d, Line: %d\n", intr_pin_line >> 8, intr_pin_line & 0xff);
   13ce5:	83 c4 1c             	add    $0x1c,%esp
   13ce8:	0f b6 d0             	movzbl %al,%edx
   13ceb:	52                   	push   %edx
   13cec:	0f b6 c4             	movzbl %ah,%eax
   13cef:	50                   	push   %eax
   13cf0:	68 72 82 01 00       	push   $0x18272
   13cf5:	e8 00 f2 ff ff       	call   12efa <printf>
    // if((intr_pin_line & 0xff) == 0xfe)
    // {

    // }

    if (dev_info->progif & 0x1)
   13cfa:	83 c4 10             	add    $0x10,%esp
   13cfd:	f6 05 39 b6 01 00 01 	testb  $0x1,0x1b639
   13d04:	74 11                	je     13d17 <ide_setup+0x153>
    {
        _ide_info.channel[0].cur_mode = 2;
   13d06:	c6 05 64 ba 01 00 02 	movb   $0x2,0x1ba64
        print_str("primary channel in PCI native mode!\n");
   13d0d:	83 ec 0c             	sub    $0xc,%esp
   13d10:	68 33 8a 01 00       	push   $0x18a33
   13d15:	eb 0f                	jmp    13d26 <ide_setup+0x162>
    }
    else
    {
        _ide_info.channel[0].cur_mode = 1;
   13d17:	c6 05 64 ba 01 00 01 	movb   $0x1,0x1ba64
        print_str("primary channel in compatibility mode!\n");
   13d1e:	83 ec 0c             	sub    $0xc,%esp
   13d21:	68 58 8a 01 00       	push   $0x18a58
   13d26:	e8 88 f1 ff ff       	call   12eb3 <print_str>
   13d2b:	83 c4 10             	add    $0x10,%esp
    }
    if (dev_info->progif & 0x2)
   13d2e:	f6 05 39 b6 01 00 02 	testb  $0x2,0x1b639
   13d35:	74 17                	je     13d4e <ide_setup+0x18a>
    {
        _ide_info.channel[0].can_change_mode = true;
   13d37:	c6 05 65 ba 01 00 01 	movb   $0x1,0x1ba65
        print_str("primary channel can change mode!\n");
   13d3e:	83 ec 0c             	sub    $0xc,%esp
   13d41:	68 80 8a 01 00       	push   $0x18a80
   13d46:	e8 68 f1 ff ff       	call   12eb3 <print_str>
   13d4b:	83 c4 10             	add    $0x10,%esp
    }
    if (dev_info->progif & 0x4)
   13d4e:	f6 05 39 b6 01 00 04 	testb  $0x4,0x1b639
   13d55:	74 11                	je     13d68 <ide_setup+0x1a4>
    {
        _ide_info.channel[1].cur_mode = 2;
   13d57:	c6 05 a0 be 01 00 02 	movb   $0x2,0x1bea0
        print_str("secondary channel in PCI native mode!\n");
   13d5e:	83 ec 0c             	sub    $0xc,%esp
   13d61:	68 a2 8a 01 00       	push   $0x18aa2
   13d66:	eb 0f                	jmp    13d77 <ide_setup+0x1b3>
    }
    else
    {
        _ide_info.channel[1].cur_mode = 1;
   13d68:	c6 05 a0 be 01 00 01 	movb   $0x1,0x1bea0
        print_str("secondary channel in compatibility mode!\n");
   13d6f:	83 ec 0c             	sub    $0xc,%esp
   13d72:	68 c9 8a 01 00       	push   $0x18ac9
   13d77:	e8 37 f1 ff ff       	call   12eb3 <print_str>
   13d7c:	83 c4 10             	add    $0x10,%esp
    }
    if (dev_info->progif & 0x8)
   13d7f:	f6 05 39 b6 01 00 08 	testb  $0x8,0x1b639
   13d86:	74 17                	je     13d9f <ide_setup+0x1db>
    {
        _ide_info.channel[1].can_change_mode = true;
   13d88:	c6 05 a1 be 01 00 01 	movb   $0x1,0x1bea1
        print_str("secondary channel can change mode!\n");
   13d8f:	83 ec 0c             	sub    $0xc,%esp
   13d92:	68 f3 8a 01 00       	push   $0x18af3
   13d97:	e8 17 f1 ff ff       	call   12eb3 <print_str>
   13d9c:	83 c4 10             	add    $0x10,%esp
    }

    if (dev_info->progif & 0x80)
   13d9f:	80 3d 39 b6 01 00 00 	cmpb   $0x0,0x1b639
   13da6:	79 62                	jns    13e0a <ide_setup+0x246>
    {
        struct pci_bar_info bar_info;
        pci_decode_bar(dev_info, 4, &bar_info);
   13da8:	50                   	push   %eax
   13da9:	8d 45 d0             	lea    -0x30(%ebp),%eax
   13dac:	50                   	push   %eax
   13dad:	6a 04                	push   $0x4
   13daf:	68 24 b6 01 00       	push   $0x1b624
   13db4:	e8 6a 1c 00 00       	call   15a23 <pci_decode_bar>
        if (bar_info.type == PCI_BAR_TYPE_NONE)
   13db9:	8a 4d d0             	mov    -0x30(%ebp),%cl
   13dbc:	83 c4 10             	add    $0x10,%esp
   13dbf:	84 c9                	test   %cl,%cl
   13dc1:	75 0f                	jne    13dd2 <ide_setup+0x20e>
        {
            print_str("progif set the BusMaster bit but BAR4 not present!\n");
   13dc3:	83 ec 0c             	sub    $0xc,%esp
   13dc6:	68 17 8b 01 00       	push   $0x18b17
   13dcb:	e8 e3 f0 ff ff       	call   12eb3 <print_str>
   13dd0:	eb 35                	jmp    13e07 <ide_setup+0x243>
        }
        else
        {
            _ide_info.support_dma = true;
   13dd2:	c6 05 b4 be 01 00 01 	movb   $0x1,0x1beb4
            _ide_info.channel[0].busmaster_base = bar_info.base;
   13dd9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   13ddc:	a3 70 ba 01 00       	mov    %eax,0x1ba70
            _ide_info.channel[1].busmaster_base = bar_info.base + 8;
   13de1:	8d 50 08             	lea    0x8(%eax),%edx
   13de4:	89 15 ac be 01 00    	mov    %edx,0x1beac
            printf("BusMaster BAR: base=0x%x, size=0x%x, type=%s\n",
   13dea:	ba b0 89 01 00       	mov    $0x189b0,%edx
   13def:	fe c9                	dec    %cl
   13df1:	74 05                	je     13df8 <ide_setup+0x234>
   13df3:	ba b4 89 01 00       	mov    $0x189b4,%edx
   13df8:	52                   	push   %edx
   13df9:	ff 75 d8             	push   -0x28(%ebp)
   13dfc:	50                   	push   %eax
   13dfd:	68 4b 8b 01 00       	push   $0x18b4b
   13e02:	e8 f3 f0 ff ff       	call   12efa <printf>
   13e07:	83 c4 10             	add    $0x10,%esp
   13e0a:	31 db                	xor    %ebx,%ebx
    }

    for (u32 bar = 0; bar <= 5; ++bar)
    {
        struct pci_bar_info bar_info;
        if (bar == 4)
   13e0c:	83 fb 04             	cmp    $0x4,%ebx
   13e0f:	74 40                	je     13e51 <ide_setup+0x28d>
            continue;
        pci_decode_bar(dev_info, bar, &bar_info);
   13e11:	50                   	push   %eax
   13e12:	8d 45 d0             	lea    -0x30(%ebp),%eax
   13e15:	50                   	push   %eax
   13e16:	53                   	push   %ebx
   13e17:	68 24 b6 01 00       	push   $0x1b624
   13e1c:	e8 02 1c 00 00       	call   15a23 <pci_decode_bar>
        if (bar_info.type == PCI_BAR_TYPE_NONE)
   13e21:	8a 55 d0             	mov    -0x30(%ebp),%dl
   13e24:	83 c4 10             	add    $0x10,%esp
   13e27:	84 d2                	test   %dl,%dl
   13e29:	74 26                	je     13e51 <ide_setup+0x28d>
            continue;

        printf("BAR%d: base=0x%x, size=0x%x, type=%s\n",
   13e2b:	b8 b0 89 01 00       	mov    $0x189b0,%eax
   13e30:	fe ca                	dec    %dl
   13e32:	74 05                	je     13e39 <ide_setup+0x275>
   13e34:	b8 b4 89 01 00       	mov    $0x189b4,%eax
   13e39:	83 ec 0c             	sub    $0xc,%esp
   13e3c:	50                   	push   %eax
   13e3d:	ff 75 d8             	push   -0x28(%ebp)
   13e40:	ff 75 d4             	push   -0x2c(%ebp)
   13e43:	53                   	push   %ebx
   13e44:	68 79 8b 01 00       	push   $0x18b79
   13e49:	e8 ac f0 ff ff       	call   12efa <printf>
   13e4e:	83 c4 20             	add    $0x20,%esp
    for (u32 bar = 0; bar <= 5; ++bar)
   13e51:	43                   	inc    %ebx
   13e52:	83 fb 06             	cmp    $0x6,%ebx
   13e55:	75 b5                	jne    13e0c <ide_setup+0x248>
               bar, bar_info.base, bar_info.size, bar_info.type == PCI_BAR_TYPE_PIO ? "PIO" : "MMIO");
    }

    if ((status_cmd >> 16) & 0x10)
   13e57:	0f ba e6 14          	bt     $0x14,%esi
   13e5b:	72 2d                	jb     13e8a <ide_setup+0x2c6>
            printf("id=0x%x, next=0x%x\n", cap & 0xff, cap_ptr);
        }
    }

    bool need_change = false;
    u8 progif = pci_conf_read_byte(dev_info->bus, dev_info->dev, dev_info->func, 0x9);
   13e5d:	6a 09                	push   $0x9
   13e5f:	ff 35 2c b6 01 00    	push   0x1b62c
   13e65:	ff 35 28 b6 01 00    	push   0x1b628
   13e6b:	ff 35 24 b6 01 00    	push   0x1b624
   13e71:	e8 df 18 00 00       	call   15755 <pci_conf_read_byte>
    if (_ide_info.channel[0].cur_mode == 2 && _ide_info.channel[0].can_change_mode)
   13e76:	83 c4 10             	add    $0x10,%esp
    bool need_change = false;
   13e79:	31 d2                	xor    %edx,%edx
    if (_ide_info.channel[0].cur_mode == 2 && _ide_info.channel[0].can_change_mode)
   13e7b:	80 3d 64 ba 01 00 02 	cmpb   $0x2,0x1ba64
   13e82:	0f 85 81 00 00 00    	jne    13f09 <ide_setup+0x345>
   13e88:	eb 6b                	jmp    13ef5 <ide_setup+0x331>
        u8 cap_ptr = pci_conf_read_byte(dev_info->bus, dev_info->dev, dev_info->func, 0x34);
   13e8a:	6a 34                	push   $0x34
   13e8c:	ff 35 2c b6 01 00    	push   0x1b62c
   13e92:	ff 35 28 b6 01 00    	push   0x1b628
   13e98:	ff 35 24 b6 01 00    	push   0x1b624
   13e9e:	e8 b2 18 00 00       	call   15755 <pci_conf_read_byte>
   13ea3:	88 c3                	mov    %al,%bl
        printf("Capabilities List Ptr=0x%x\n", cap_ptr);
   13ea5:	5e                   	pop    %esi
   13ea6:	5f                   	pop    %edi
   13ea7:	0f b6 c0             	movzbl %al,%eax
   13eaa:	50                   	push   %eax
   13eab:	68 9f 8b 01 00       	push   $0x18b9f
            printf("id=0x%x, next=0x%x\n", cap & 0xff, cap_ptr);
   13eb0:	e8 45 f0 ff ff       	call   12efa <printf>
   13eb5:	83 c4 10             	add    $0x10,%esp
            u16 cap = pci_conf_read_word(dev_info->bus, dev_info->dev, dev_info->func, cap_ptr >> 1);
   13eb8:	8b 0d 2c b6 01 00    	mov    0x1b62c,%ecx
   13ebe:	8b 15 28 b6 01 00    	mov    0x1b628,%edx
   13ec4:	a1 24 b6 01 00       	mov    0x1b624,%eax
        while (cap_ptr)
   13ec9:	84 db                	test   %bl,%bl
   13ecb:	74 90                	je     13e5d <ide_setup+0x299>
            u16 cap = pci_conf_read_word(dev_info->bus, dev_info->dev, dev_info->func, cap_ptr >> 1);
   13ecd:	d0 eb                	shr    %bl
   13ecf:	0f b6 db             	movzbl %bl,%ebx
   13ed2:	53                   	push   %ebx
   13ed3:	51                   	push   %ecx
   13ed4:	52                   	push   %edx
   13ed5:	50                   	push   %eax
   13ed6:	e8 a4 18 00 00       	call   1577f <pci_conf_read_word>
            cap_ptr = cap >> 8;
   13edb:	89 c2                	mov    %eax,%edx
   13edd:	66 c1 ea 08          	shr    $0x8,%dx
   13ee1:	88 d3                	mov    %dl,%bl
            printf("id=0x%x, next=0x%x\n", cap & 0xff, cap_ptr);
   13ee3:	83 c4 0c             	add    $0xc,%esp
   13ee6:	0f b7 d2             	movzwl %dx,%edx
   13ee9:	52                   	push   %edx
   13eea:	0f b6 c0             	movzbl %al,%eax
   13eed:	50                   	push   %eax
   13eee:	68 bb 8b 01 00       	push   $0x18bbb
   13ef3:	eb bb                	jmp    13eb0 <ide_setup+0x2ec>
    if (_ide_info.channel[0].cur_mode == 2 && _ide_info.channel[0].can_change_mode)
   13ef5:	8a 15 65 ba 01 00    	mov    0x1ba65,%dl
   13efb:	84 d2                	test   %dl,%dl
   13efd:	74 0a                	je     13f09 <ide_setup+0x345>
    {
        progif &= 0xfe;
   13eff:	83 e0 fe             	and    $0xfffffffe,%eax
        _ide_info.channel[0].cur_mode = 1;
   13f02:	c6 05 64 ba 01 00 01 	movb   $0x1,0x1ba64
        need_change = true;
    }
    if (_ide_info.channel[1].cur_mode == 2 && _ide_info.channel[1].can_change_mode)
   13f09:	80 3d a0 be 01 00 02 	cmpb   $0x2,0x1bea0
   13f10:	75 15                	jne    13f27 <ide_setup+0x363>
   13f12:	80 3d a1 be 01 00 00 	cmpb   $0x0,0x1bea1
   13f19:	74 0c                	je     13f27 <ide_setup+0x363>
    {
        progif &= 0xfb;
   13f1b:	83 e0 fb             	and    $0xfffffffb,%eax
        _ide_info.channel[1].cur_mode = 1;
   13f1e:	c6 05 a0 be 01 00 01 	movb   $0x1,0x1bea0
        need_change = true;
    }
    if (need_change)
   13f25:	eb 04                	jmp    13f2b <ide_setup+0x367>
   13f27:	84 d2                	test   %dl,%dl
   13f29:	74 23                	je     13f4e <ide_setup+0x38a>
    {
        pci_conf_write_byte(dev_info->bus, dev_info->dev, dev_info->func, 0x9, progif);
   13f2b:	83 ec 0c             	sub    $0xc,%esp
   13f2e:	0f b6 c0             	movzbl %al,%eax
   13f31:	50                   	push   %eax
   13f32:	6a 09                	push   $0x9
   13f34:	ff 35 2c b6 01 00    	push   0x1b62c
   13f3a:	ff 35 28 b6 01 00    	push   0x1b628
   13f40:	ff 35 24 b6 01 00    	push   0x1b624
   13f46:	e8 ce 18 00 00       	call   15819 <pci_conf_write_byte>
   13f4b:	83 c4 20             	add    $0x20,%esp
    }

    if (_ide_info.channel[0].cur_mode == 2)
   13f4e:	80 3d 64 ba 01 00 02 	cmpb   $0x2,0x1ba64
   13f55:	75 12                	jne    13f69 <ide_setup+0x3a5>
    {
        print_str("primary channel at native mode but we not support it!\n");
   13f57:	83 ec 0c             	sub    $0xc,%esp
   13f5a:	68 cf 8b 01 00       	push   $0x18bcf
   13f5f:	e8 4f ef ff ff       	call   12eb3 <print_str>
   13f64:	83 c4 10             	add    $0x10,%esp
   13f67:	eb 14                	jmp    13f7d <ide_setup+0x3b9>
    }
    else
    {
        _ide_info.channel[0].cmd_base = IDE_IOBASE0;
   13f69:	c7 05 68 ba 01 00 f0 	movl   $0x1f0,0x1ba68
   13f70:	01 00 00 
        _ide_info.channel[0].ctrl_base = IDE_CTRLBASE0;
   13f73:	c7 05 6c ba 01 00 f6 	movl   $0x3f6,0x1ba6c
   13f7a:	03 00 00 
    }

    if (_ide_info.channel[1].cur_mode == 2)
   13f7d:	80 3d a0 be 01 00 02 	cmpb   $0x2,0x1bea0
   13f84:	75 12                	jne    13f98 <ide_setup+0x3d4>
    {
        print_str("secondary channel at native mode but we not support it!\n");
   13f86:	83 ec 0c             	sub    $0xc,%esp
   13f89:	68 06 8c 01 00       	push   $0x18c06
   13f8e:	e8 20 ef ff ff       	call   12eb3 <print_str>
   13f93:	83 c4 10             	add    $0x10,%esp
   13f96:	eb 14                	jmp    13fac <ide_setup+0x3e8>
    }
    else
    {
        _ide_info.channel[1].cmd_base = IDE_IOBASE1;
   13f98:	c7 05 a4 be 01 00 70 	movl   $0x170,0x1bea4
   13f9f:	01 00 00 
        _ide_info.channel[0].ctrl_base = IDE_CTRLBASE1;
   13fa2:	c7 05 6c ba 01 00 76 	movl   $0x376,0x1ba6c
   13fa9:	03 00 00 
    ide_write(0, ATA_REG_CONTROL, ATA_CONTROL_NIEN);
   13fac:	b9 02 00 00 00       	mov    $0x2,%ecx
   13fb1:	ba 0c 00 00 00       	mov    $0xc,%edx
   13fb6:	31 c0                	xor    %eax,%eax
   13fb8:	e8 03 fb ff ff       	call   13ac0 <ide_write>
    ide_write(1, ATA_REG_CONTROL, ATA_CONTROL_NIEN);
   13fbd:	b9 02 00 00 00       	mov    $0x2,%ecx
   13fc2:	ba 0c 00 00 00       	mov    $0xc,%edx
   13fc7:	b8 01 00 00 00       	mov    $0x1,%eax
   13fcc:	e8 ef fa ff ff       	call   13ac0 <ide_write>
    _ide_info.channel[0].irq_disable = true;
   13fd1:	c6 05 74 ba 01 00 01 	movb   $0x1,0x1ba74
    _ide_info.channel[1].irq_disable = true;
   13fd8:	c6 05 b0 be 01 00 01 	movb   $0x1,0x1beb0
    for (u8 c = 0; c < 2; ++c)
   13fdf:	c7 45 b8 20 b6 01 00 	movl   $0x1b620,-0x48(%ebp)
    _ide_info.channel[1].irq_disable = true;
   13fe6:	31 db                	xor    %ebx,%ebx
        for (u8 d = 0; d < 2; ++d)
   13fe8:	69 c3 3c 04 00 00    	imul   $0x43c,%ebx,%eax
   13fee:	89 45 c0             	mov    %eax,-0x40(%ebp)
            _ide_info.channel[c].device[d].present = false;
   13ff1:	8b 45 b8             	mov    -0x48(%ebp),%eax
   13ff4:	89 45 bc             	mov    %eax,-0x44(%ebp)
   13ff7:	89 c6                	mov    %eax,%esi
   13ff9:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
   14000:	c6 46 1c 00          	movb   $0x0,0x1c(%esi)
            ide_write(c, ATA_REG_DEVICE, 0xA0 | (d << ATA_DEVICE_DEV_SHIFT));
   14004:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
   14007:	c1 e1 04             	shl    $0x4,%ecx
   1400a:	80 c9 a0             	or     $0xa0,%cl
   1400d:	ba 06 00 00 00       	mov    $0x6,%edx
   14012:	89 d8                	mov    %ebx,%eax
   14014:	e8 a7 fa ff ff       	call   13ac0 <ide_write>
            delay_ms(1);
   14019:	83 ec 0c             	sub    $0xc,%esp
   1401c:	6a 01                	push   $0x1
   1401e:	e8 72 0e 00 00       	call   14e95 <delay_ms>
            ide_write(c, ATA_REG_COMMAND, ATA_CMD_IDENTIFY);
   14023:	b9 ec 00 00 00       	mov    $0xec,%ecx
   14028:	ba 07 00 00 00       	mov    $0x7,%edx
   1402d:	89 d8                	mov    %ebx,%eax
   1402f:	e8 8c fa ff ff       	call   13ac0 <ide_write>
            delay_ms(1);
   14034:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
   1403b:	e8 55 0e 00 00       	call   14e95 <delay_ms>
            if ((err = ide_read(c, ATA_REG_STATUS)) == 0 || err == 0xff)
   14040:	ba 07 00 00 00       	mov    $0x7,%edx
   14045:	89 d8                	mov    %ebx,%eax
   14047:	e8 1b fb ff ff       	call   13b67 <ide_read>
   1404c:	88 45 d0             	mov    %al,-0x30(%ebp)
   1404f:	48                   	dec    %eax
   14050:	83 c4 10             	add    $0x10,%esp
   14053:	3c fd                	cmp    $0xfd,%al
   14055:	77 13                	ja     1406a <ide_setup+0x4a6>
            s8 status = ide_wait(c, true, &err);
   14057:	8d 4d d0             	lea    -0x30(%ebp),%ecx
   1405a:	ba 01 00 00 00       	mov    $0x1,%edx
   1405f:	89 d8                	mov    %ebx,%eax
   14061:	e8 15 fb ff ff       	call   13b7b <ide_wait>
            if (status == -2)
   14066:	3c fe                	cmp    $0xfe,%al
   14068:	75 14                	jne    1407e <ide_setup+0x4ba>
                printf("IDE %d:%d timeout\n", c, d);
   1406a:	51                   	push   %ecx
   1406b:	ff 75 c4             	push   -0x3c(%ebp)
   1406e:	53                   	push   %ebx
   1406f:	68 3f 8c 01 00       	push   $0x18c3f
   14074:	e8 81 ee ff ff       	call   12efa <printf>
                continue;
   14079:	e9 aa 01 00 00       	jmp    14228 <ide_setup+0x664>
            else if (status == -1)
   1407e:	fe c0                	inc    %al
   14080:	75 50                	jne    140d2 <ide_setup+0x50e>
                u8 sig1 = ide_read(c, ATA_REG_LBA1), sig2 = ide_read(c, ATA_REG_LBA2);
   14082:	ba 04 00 00 00       	mov    $0x4,%edx
   14087:	89 d8                	mov    %ebx,%eax
   14089:	e8 d9 fa ff ff       	call   13b67 <ide_read>
   1408e:	88 c1                	mov    %al,%cl
   14090:	ba 05 00 00 00       	mov    $0x5,%edx
   14095:	89 d8                	mov    %ebx,%eax
   14097:	e8 cb fa ff ff       	call   13b67 <ide_read>
                if (sig1 != 0x14 || sig2 != 0xEB)
   1409c:	80 f9 14             	cmp    $0x14,%cl
   1409f:	0f 85 86 01 00 00    	jne    1422b <ide_setup+0x667>
   140a5:	3c eb                	cmp    $0xeb,%al
   140a7:	0f 85 7e 01 00 00    	jne    1422b <ide_setup+0x667>
                ide_write(c, ATA_REG_COMMAND, ATA_CMD_IDENTIFY_PACKET);
   140ad:	b9 a1 00 00 00       	mov    $0xa1,%ecx
   140b2:	ba 07 00 00 00       	mov    $0x7,%edx
   140b7:	89 d8                	mov    %ebx,%eax
   140b9:	e8 02 fa ff ff       	call   13ac0 <ide_write>
                delay_ms(1);
   140be:	83 ec 0c             	sub    $0xc,%esp
   140c1:	6a 01                	push   $0x1
   140c3:	e8 cd 0d 00 00       	call   14e95 <delay_ms>
   140c8:	83 c4 10             	add    $0x10,%esp
                type = 2;
   140cb:	b8 02 00 00 00       	mov    $0x2,%eax
   140d0:	eb 05                	jmp    140d7 <ide_setup+0x513>
            u8 type = 1;
   140d2:	b8 01 00 00 00       	mov    $0x1,%eax
            port_read_dword_count(_ide_info.channel[c].cmd_base + ATA_REG_DATA, _ide_info.channel[c].device[d].identify_data, 128);
   140d7:	8b 7d b8             	mov    -0x48(%ebp),%edi
   140da:	8b 97 48 04 00 00    	mov    0x448(%edi),%edx
                     : "memory");
}

inline static void port_read_dword_count(u16 port, volatile void *buffer, u32 count)
{
    __asm__ volatile("cld\n\trep insl"
   140e0:	8b 7d bc             	mov    -0x44(%ebp),%edi
   140e3:	83 c7 30             	add    $0x30,%edi
   140e6:	b9 80 00 00 00       	mov    $0x80,%ecx
   140eb:	fc                   	cld    
   140ec:	f3 6d                	rep insl (%dx),%es:(%edi)
            _ide_info.channel[c].device[d].present = true;
   140ee:	c6 46 1c 01          	movb   $0x1,0x1c(%esi)
            _ide_info.channel[c].device[d].device_type = type;
   140f2:	88 46 1d             	mov    %al,0x1d(%esi)
            printf("\nIDE %d:%d %d, %x, %d, ", c, d, type,
   140f5:	52                   	push   %edx
   140f6:	52                   	push   %edx
   140f7:	0f b6 96 8e 00 00 00 	movzbl 0x8e(%esi),%edx
   140fe:	52                   	push   %edx
   140ff:	0f b7 56 30          	movzwl 0x30(%esi),%edx
   14103:	52                   	push   %edx
   14104:	50                   	push   %eax
   14105:	ff 75 c4             	push   -0x3c(%ebp)
   14108:	53                   	push   %ebx
   14109:	68 52 8c 01 00       	push   $0x18c52
   1410e:	e8 e7 ed ff ff       	call   12efa <printf>
            if (_ide_info.channel[c].device[d].identify_data[83] & (1 << 10)) // 48-bit Address feature set supported
   14113:	83 c4 20             	add    $0x20,%esp
   14116:	f6 86 d7 00 00 00 04 	testb  $0x4,0xd7(%esi)
   1411d:	74 19                	je     14138 <ide_setup+0x574>
                printf("LBA48 - 0x%x_%x",
   1411f:	57                   	push   %edi
   14120:	8b 45 bc             	mov    -0x44(%ebp),%eax
   14123:	ff b0 f8 00 00 00    	push   0xf8(%eax)
   14129:	0f b7 86 fc 00 00 00 	movzwl 0xfc(%esi),%eax
   14130:	50                   	push   %eax
   14131:	68 6a 8c 01 00       	push   $0x18c6a
   14136:	eb 33                	jmp    1416b <ide_setup+0x5a7>
                if (_ide_info.channel[c].device[d].identify_data[49] & (1 << 9)) // 28-bit Address feature set supported
   14138:	f6 86 93 00 00 00 02 	testb  $0x2,0x93(%esi)
   1413f:	74 0a                	je     1414b <ide_setup+0x587>
                    print_str("LBA28 - ");
   14141:	83 ec 0c             	sub    $0xc,%esp
   14144:	68 7a 8c 01 00       	push   $0x18c7a
   14149:	eb 08                	jmp    14153 <ide_setup+0x58f>
                    print_str("CHS - ");
   1414b:	83 ec 0c             	sub    $0xc,%esp
   1414e:	68 83 8c 01 00       	push   $0x18c83
   14153:	e8 5b ed ff ff       	call   12eb3 <print_str>
   14158:	83 c4 10             	add    $0x10,%esp
                printf("0x%x",
   1415b:	51                   	push   %ecx
   1415c:	51                   	push   %ecx
   1415d:	8b 45 bc             	mov    -0x44(%ebp),%eax
   14160:	ff b0 a8 00 00 00    	push   0xa8(%eax)
   14166:	68 75 92 01 00       	push   $0x19275
   1416b:	e8 8a ed ff ff       	call   12efa <printf>
   14170:	83 c4 10             	add    $0x10,%esp
            print_str("\nSerial number: ");
   14173:	83 ec 0c             	sub    $0xc,%esp
   14176:	68 8a 8c 01 00       	push   $0x18c8a
   1417b:	e8 33 ed ff ff       	call   12eb3 <print_str>
   14180:	83 c4 10             	add    $0x10,%esp
   14183:	31 ff                	xor    %edi,%edi
                printf("%c%c", _ide_info.channel[c].device[d].identify_data[i] >> 8, _ide_info.channel[c].device[d].identify_data[i] & 0xff);
   14185:	8b 45 c0             	mov    -0x40(%ebp),%eax
   14188:	66 8b 84 78 64 b6 01 	mov    0x1b664(%eax,%edi,2),%ax
   1418f:	00 
   14190:	52                   	push   %edx
   14191:	0f b6 d0             	movzbl %al,%edx
   14194:	52                   	push   %edx
   14195:	0f b6 c4             	movzbl %ah,%eax
   14198:	50                   	push   %eax
   14199:	68 9b 8c 01 00       	push   $0x18c9b
   1419e:	e8 57 ed ff ff       	call   12efa <printf>
            for (u8 i = 10; i <= 19; ++i)
   141a3:	47                   	inc    %edi
   141a4:	83 c4 10             	add    $0x10,%esp
   141a7:	83 ff 0a             	cmp    $0xa,%edi
   141aa:	75 d9                	jne    14185 <ide_setup+0x5c1>
            print_str("\nFirmware revision: ");
   141ac:	83 ec 0c             	sub    $0xc,%esp
   141af:	68 a0 8c 01 00       	push   $0x18ca0
   141b4:	e8 fa ec ff ff       	call   12eb3 <print_str>
   141b9:	83 c4 10             	add    $0x10,%esp
   141bc:	31 ff                	xor    %edi,%edi
                printf("%c%c", _ide_info.channel[c].device[d].identify_data[i] >> 8, _ide_info.channel[c].device[d].identify_data[i] & 0xff);
   141be:	8b 45 c0             	mov    -0x40(%ebp),%eax
   141c1:	66 8b 84 78 7e b6 01 	mov    0x1b67e(%eax,%edi,2),%ax
   141c8:	00 
   141c9:	51                   	push   %ecx
   141ca:	0f b6 d0             	movzbl %al,%edx
   141cd:	52                   	push   %edx
   141ce:	0f b6 c4             	movzbl %ah,%eax
   141d1:	50                   	push   %eax
   141d2:	68 9b 8c 01 00       	push   $0x18c9b
   141d7:	e8 1e ed ff ff       	call   12efa <printf>
            for (u8 i = 23; i <= 26; ++i)
   141dc:	47                   	inc    %edi
   141dd:	83 c4 10             	add    $0x10,%esp
   141e0:	83 ff 04             	cmp    $0x4,%edi
   141e3:	75 d9                	jne    141be <ide_setup+0x5fa>
            print_str("\nModel number: ");
   141e5:	83 ec 0c             	sub    $0xc,%esp
   141e8:	68 b5 8c 01 00       	push   $0x18cb5
   141ed:	e8 c1 ec ff ff       	call   12eb3 <print_str>
   141f2:	83 c4 10             	add    $0x10,%esp
   141f5:	31 ff                	xor    %edi,%edi
                printf("%c%c", _ide_info.channel[c].device[d].identify_data[i] >> 8, _ide_info.channel[c].device[d].identify_data[i] & 0xff);
   141f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
   141fa:	66 8b 84 78 86 b6 01 	mov    0x1b686(%eax,%edi,2),%ax
   14201:	00 
   14202:	52                   	push   %edx
   14203:	0f b6 d0             	movzbl %al,%edx
   14206:	52                   	push   %edx
   14207:	0f b6 c4             	movzbl %ah,%eax
   1420a:	50                   	push   %eax
   1420b:	68 9b 8c 01 00       	push   $0x18c9b
   14210:	e8 e5 ec ff ff       	call   12efa <printf>
            for (u8 i = 27; i <= 46; ++i)
   14215:	47                   	inc    %edi
   14216:	83 c4 10             	add    $0x10,%esp
   14219:	83 ff 14             	cmp    $0x14,%edi
   1421c:	75 d9                	jne    141f7 <ide_setup+0x633>
            print_char('\n');
   1421e:	83 ec 0c             	sub    $0xc,%esp
   14221:	6a 0a                	push   $0xa
   14223:	e8 3a e8 ff ff       	call   12a62 <print_char>
   14228:	83 c4 10             	add    $0x10,%esp
        for (u8 d = 0; d < 2; ++d)
   1422b:	81 c6 14 02 00 00    	add    $0x214,%esi
   14231:	81 45 c0 14 02 00 00 	addl   $0x214,-0x40(%ebp)
   14238:	81 45 bc 14 02 00 00 	addl   $0x214,-0x44(%ebp)
   1423f:	83 7d c4 01          	cmpl   $0x1,-0x3c(%ebp)
   14243:	74 0c                	je     14251 <ide_setup+0x68d>
   14245:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
   1424c:	e9 af fd ff ff       	jmp    14000 <ide_setup+0x43c>
    for (u8 c = 0; c < 2; ++c)
   14251:	81 45 b8 3c 04 00 00 	addl   $0x43c,-0x48(%ebp)
   14258:	4b                   	dec    %ebx
   14259:	74 0a                	je     14265 <ide_setup+0x6a1>
   1425b:	bb 01 00 00 00       	mov    $0x1,%ebx
   14260:	e9 83 fd ff ff       	jmp    13fe8 <ide_setup+0x424>
    ide_write(0, ATA_REG_CONTROL, 0);
   14265:	31 c9                	xor    %ecx,%ecx
   14267:	ba 0c 00 00 00       	mov    $0xc,%edx
   1426c:	31 c0                	xor    %eax,%eax
   1426e:	e8 4d f8 ff ff       	call   13ac0 <ide_write>
    ide_write(1, ATA_REG_CONTROL, 0);
   14273:	31 c9                	xor    %ecx,%ecx
   14275:	ba 0c 00 00 00       	mov    $0xc,%edx
   1427a:	b8 01 00 00 00       	mov    $0x1,%eax
   1427f:	e8 3c f8 ff ff       	call   13ac0 <ide_write>
    _ide_info.channel[0].irq_disable = false;
   14284:	c6 05 74 ba 01 00 00 	movb   $0x0,0x1ba74
    _ide_info.channel[1].irq_disable = false;
   1428b:	c6 05 b0 be 01 00 00 	movb   $0x0,0x1beb0
    }

    init_ide();

    pic_irq_set_entry(IDE_IRQ0, _irq_handler0);
   14292:	50                   	push   %eax
   14293:	50                   	push   %eax
   14294:	68 bf 3a 01 00       	push   $0x13abf
   14299:	6a 0e                	push   $0xe
   1429b:	e8 3c 1a 00 00       	call   15cdc <pic_irq_set_entry>
    pic_irq_set_entry(IDE_IRQ1, _irq_handler1);
   142a0:	5a                   	pop    %edx
   142a1:	59                   	pop    %ecx
   142a2:	68 c3 3b 01 00       	push   $0x13bc3
   142a7:	6a 0f                	push   $0xf
   142a9:	e8 2e 1a 00 00       	call   15cdc <pic_irq_set_entry>
    pic_irq_enable(IDE_IRQ0);
   142ae:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
   142b5:	e8 d3 19 00 00       	call   15c8d <pic_irq_enable>
    pic_irq_enable(IDE_IRQ1);
   142ba:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
   142c1:	e8 c7 19 00 00       	call   15c8d <pic_irq_enable>
   142c6:	83 c4 10             	add    $0x10,%esp
}
   142c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
   142cc:	5b                   	pop    %ebx
   142cd:	5e                   	pop    %esi
   142ce:	5f                   	pop    %edi
   142cf:	5d                   	pop    %ebp
   142d0:	c3                   	ret    

000142d1 <ide_read_write_sectors>:

int ide_read_write_sectors(u8 channel, u8 device, u32 lba, bool write, u8 count, void *buffer)
{
   142d1:	55                   	push   %ebp
   142d2:	89 e5                	mov    %esp,%ebp
   142d4:	57                   	push   %edi
   142d5:	56                   	push   %esi
   142d6:	53                   	push   %ebx
   142d7:	83 ec 3c             	sub    $0x3c,%esp
   142da:	8b 55 08             	mov    0x8(%ebp),%edx
   142dd:	8b 45 0c             	mov    0xc(%ebp),%eax
   142e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
   142e3:	8b 7d 14             	mov    0x14(%ebp),%edi
   142e6:	89 7d cc             	mov    %edi,-0x34(%ebp)
   142e9:	8b 7d 18             	mov    0x18(%ebp),%edi
   142ec:	8a 4d cc             	mov    -0x34(%ebp),%cl
   142ef:	88 4d c3             	mov    %cl,-0x3d(%ebp)
    if (!_ide_info.present || !_ide_info.channel[channel].device[device].present || _ide_info.channel[channel].device[device].device_type != 1)
        return -1;
   142f2:	83 ce ff             	or     $0xffffffff,%esi
    if (!_ide_info.present || !_ide_info.channel[channel].device[device].present || _ide_info.channel[channel].device[device].device_type != 1)
   142f5:	80 3d 20 b6 01 00 00 	cmpb   $0x0,0x1b620
   142fc:	0f 84 a6 01 00 00    	je     144a8 <ide_read_write_sectors+0x1d7>
   14302:	0f b6 f2             	movzbl %dl,%esi
   14305:	89 75 d4             	mov    %esi,-0x2c(%ebp)
   14308:	0f b6 c0             	movzbl %al,%eax
   1430b:	89 45 d0             	mov    %eax,-0x30(%ebp)
   1430e:	69 c0 14 02 00 00    	imul   $0x214,%eax,%eax
   14314:	69 f6 3c 04 00 00    	imul   $0x43c,%esi,%esi
   1431a:	89 75 c8             	mov    %esi,-0x38(%ebp)
   1431d:	8d 84 30 20 b6 01 00 	lea    0x1b620(%eax,%esi,1),%eax
        return -1;
   14324:	83 ce ff             	or     $0xffffffff,%esi
    if (!_ide_info.present || !_ide_info.channel[channel].device[device].present || _ide_info.channel[channel].device[device].device_type != 1)
   14327:	80 78 1c 00          	cmpb   $0x0,0x1c(%eax)
   1432b:	0f 84 77 01 00 00    	je     144a8 <ide_read_write_sectors+0x1d7>
   14331:	80 78 1d 01          	cmpb   $0x1,0x1d(%eax)
   14335:	0f 85 6d 01 00 00    	jne    144a8 <ide_read_write_sectors+0x1d7>

    u8 *lba28 = (u8 *)&lba;

    // ide_write(channel, ATA_REG_CONTROL, _ide_info.channel[channel].irq_disable << ATA_CONTROL_NIEN_SHIFT);

    ide_write(channel, ATA_REG_DEVICE, 0xA0 | ATA_DEVICE_LBA | device << ATA_DEVICE_DEV_SHIFT | (lba28[3] & 0xf)); // LBA
   1433b:	8b 45 d0             	mov    -0x30(%ebp),%eax
   1433e:	c1 e0 04             	shl    $0x4,%eax
   14341:	89 d9                	mov    %ebx,%ecx
   14343:	c1 e9 18             	shr    $0x18,%ecx
   14346:	83 e1 0f             	and    $0xf,%ecx
   14349:	09 c1                	or     %eax,%ecx
   1434b:	83 c9 e0             	or     $0xffffffe0,%ecx
   1434e:	0f b6 c9             	movzbl %cl,%ecx
   14351:	ba 06 00 00 00       	mov    $0x6,%edx
   14356:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   14359:	e8 62 f7 ff ff       	call   13ac0 <ide_write>
    delay_ms(1);
   1435e:	83 ec 0c             	sub    $0xc,%esp
   14361:	6a 01                	push   $0x1
   14363:	e8 2d 0b 00 00       	call   14e95 <delay_ms>

    if (ide_wait(channel, false, NULL) == -2)
   14368:	31 c9                	xor    %ecx,%ecx
   1436a:	31 d2                	xor    %edx,%edx
   1436c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   1436f:	e8 07 f8 ff ff       	call   13b7b <ide_wait>
   14374:	83 c4 10             	add    $0x10,%esp
   14377:	3c fe                	cmp    $0xfe,%al
   14379:	75 1e                	jne    14399 <ide_read_write_sectors+0xc8>
    {
        printf("IDE %d:%d timeout!\n", channel, device);
   1437b:	52                   	push   %edx
   1437c:	ff 75 d0             	push   -0x30(%ebp)
   1437f:	ff 75 d4             	push   -0x2c(%ebp)
   14382:	68 c5 8c 01 00       	push   $0x18cc5
   14387:	e8 6e eb ff ff       	call   12efa <printf>
        return -2;
   1438c:	83 c4 10             	add    $0x10,%esp
   1438f:	be fe ff ff ff       	mov    $0xfffffffe,%esi
   14394:	e9 0f 01 00 00       	jmp    144a8 <ide_read_write_sectors+0x1d7>
    }

    ide_write(channel, ATA_REG_SECTOR_COUNT0, count);
   14399:	89 f8                	mov    %edi,%eax
   1439b:	0f b6 f8             	movzbl %al,%edi
   1439e:	89 f9                	mov    %edi,%ecx
   143a0:	ba 02 00 00 00       	mov    $0x2,%edx
   143a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   143a8:	e8 13 f7 ff ff       	call   13ac0 <ide_write>
    ide_write(channel, ATA_REG_LBA0, lba28[0]);
   143ad:	0f b6 cb             	movzbl %bl,%ecx
   143b0:	ba 03 00 00 00       	mov    $0x3,%edx
   143b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   143b8:	e8 03 f7 ff ff       	call   13ac0 <ide_write>
    ide_write(channel, ATA_REG_LBA1, lba28[1]);
   143bd:	0f b6 cf             	movzbl %bh,%ecx
   143c0:	ba 04 00 00 00       	mov    $0x4,%edx
   143c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   143c8:	e8 f3 f6 ff ff       	call   13ac0 <ide_write>
    ide_write(channel, ATA_REG_LBA2, lba28[2]);
   143cd:	c1 eb 10             	shr    $0x10,%ebx
   143d0:	0f b6 cb             	movzbl %bl,%ecx
   143d3:	ba 05 00 00 00       	mov    $0x5,%edx
   143d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   143db:	e8 e0 f6 ff ff       	call   13ac0 <ide_write>

    ide_write(channel, ATA_REG_COMMAND, write ? ATA_CMD_WRITE_SECTORS : ATA_CMD_READ_SECTORS);
   143e0:	80 7d cc 01          	cmpb   $0x1,-0x34(%ebp)
   143e4:	19 c9                	sbb    %ecx,%ecx
   143e6:	83 e1 f0             	and    $0xfffffff0,%ecx
   143e9:	83 c1 30             	add    $0x30,%ecx
   143ec:	ba 07 00 00 00       	mov    $0x7,%edx
   143f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   143f4:	e8 c7 f6 ff ff       	call   13ac0 <ide_write>

    for (u8 i = 0; i < count; ++i)
   143f9:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
   143fc:	c1 e7 09             	shl    $0x9,%edi
   143ff:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
   14402:	89 45 c4             	mov    %eax,-0x3c(%ebp)
   14405:	39 5d c4             	cmp    %ebx,-0x3c(%ebp)
   14408:	74 78                	je     14482 <ide_read_write_sectors+0x1b1>
    {
        // delay_ms(1);

        u8 err;
        s8 status = ide_wait(channel, true, &err);
   1440a:	8d 4d e7             	lea    -0x19(%ebp),%ecx
   1440d:	ba 01 00 00 00       	mov    $0x1,%edx
   14412:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   14415:	e8 61 f7 ff ff       	call   13b7b <ide_wait>
        if (status)
   1441a:	84 c0                	test   %al,%al
   1441c:	74 37                	je     14455 <ide_read_write_sectors+0x184>
        {
            if (status == -2)
   1441e:	3c fe                	cmp    $0xfe,%al
   14420:	75 1b                	jne    1443d <ide_read_write_sectors+0x16c>
            {
                printf("IDE %d:%d timeout!\n", channel, device);
   14422:	50                   	push   %eax
   14423:	ff 75 d0             	push   -0x30(%ebp)
   14426:	ff 75 d4             	push   -0x2c(%ebp)
   14429:	68 c5 8c 01 00       	push   $0x18cc5
   1442e:	e8 c7 ea ff ff       	call   12efa <printf>
                return -3;
   14433:	83 c4 10             	add    $0x10,%esp
   14436:	be fd ff ff ff       	mov    $0xfffffffd,%esi
   1443b:	eb 6b                	jmp    144a8 <ide_read_write_sectors+0x1d7>
            }
            if (err & ATA_STATUS_ERR)
   1443d:	8a 45 e7             	mov    -0x19(%ebp),%al
                return -4;
   14440:	be fc ff ff ff       	mov    $0xfffffffc,%esi
            if (err & ATA_STATUS_ERR)
   14445:	a8 01                	test   $0x1,%al
   14447:	75 5f                	jne    144a8 <ide_read_write_sectors+0x1d7>
            if (err & ATA_STATUS_DF)
   14449:	83 e0 20             	and    $0x20,%eax
                return -5;
            return -6;
   1444c:	3c 01                	cmp    $0x1,%al
   1444e:	19 f6                	sbb    %esi,%esi
   14450:	83 ee 05             	sub    $0x5,%esi
   14453:	eb 53                	jmp    144a8 <ide_read_write_sectors+0x1d7>
        }

        if (write)
            port_write_dword_count(_ide_info.channel[channel].cmd_base + ATA_REG_DATA, (u8 *)buffer + i * 512, 128);
   14455:	8b 45 c8             	mov    -0x38(%ebp),%eax
   14458:	8b 90 68 ba 01 00    	mov    0x1ba68(%eax),%edx
        if (write)
   1445e:	80 7d c3 00          	cmpb   $0x0,-0x3d(%ebp)
   14462:	74 0c                	je     14470 <ide_read_write_sectors+0x19f>
                     : "memory");
}

inline static void port_write_dword_count(u16 port, const volatile void *buffer, u32 count)
{
    __asm__ volatile("cld\n\trep outsl"
   14464:	89 de                	mov    %ebx,%esi
   14466:	b9 80 00 00 00       	mov    $0x80,%ecx
   1446b:	fc                   	cld    
   1446c:	f3 6f                	rep outsl %ds:(%esi),(%dx)
                     : "+S"(buffer)
                     : "dN"(port), "c"(count)
                     : "memory");
}
   1446e:	eb 0a                	jmp    1447a <ide_read_write_sectors+0x1a9>
    __asm__ volatile("cld\n\trep insl"
   14470:	89 df                	mov    %ebx,%edi
   14472:	b9 80 00 00 00       	mov    $0x80,%ecx
   14477:	fc                   	cld    
   14478:	f3 6d                	rep insl (%dx),%es:(%edi)
    for (u8 i = 0; i < count; ++i)
   1447a:	81 c3 00 02 00 00    	add    $0x200,%ebx
   14480:	eb 83                	jmp    14405 <ide_read_write_sectors+0x134>
    {
        ide_write(channel, ATA_REG_COMMAND, ATA_CMD_FLUSH_CACHE);
        ide_wait(channel, false, NULL);
    }

    return 0;
   14482:	31 f6                	xor    %esi,%esi
    if (write)
   14484:	80 7d cc 00          	cmpb   $0x0,-0x34(%ebp)
   14488:	74 1e                	je     144a8 <ide_read_write_sectors+0x1d7>
        ide_write(channel, ATA_REG_COMMAND, ATA_CMD_FLUSH_CACHE);
   1448a:	b9 e7 00 00 00       	mov    $0xe7,%ecx
   1448f:	ba 07 00 00 00       	mov    $0x7,%edx
   14494:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   14497:	e8 24 f6 ff ff       	call   13ac0 <ide_write>
        ide_wait(channel, false, NULL);
   1449c:	31 c9                	xor    %ecx,%ecx
   1449e:	31 d2                	xor    %edx,%edx
   144a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   144a3:	e8 d3 f6 ff ff       	call   13b7b <ide_wait>
}
   144a8:	89 f0                	mov    %esi,%eax
   144aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
   144ad:	5b                   	pop    %ebx
   144ae:	5e                   	pop    %esi
   144af:	5f                   	pop    %edi
   144b0:	5d                   	pop    %ebp
   144b1:	c3                   	ret    

000144b2 <set_idt_entry>:
		"#VE: Virtualization Exception (EPT violations)"};

#define RESERVED_INDEX 15

static void set_idt_entry(u8 index, u32 entry, u16 type)
{
   144b2:	55                   	push   %ebp
   144b3:	89 e5                	mov    %esp,%ebp
   144b5:	53                   	push   %ebx
	// u32 save_eflags = read_eflags();
	// disable();
	u16 *idt_entry = (u16 *)(gk_idt_ptr.base + index * 8);
   144b6:	0f b6 c0             	movzbl %al,%eax
   144b9:	8b 1d ba be 01 00    	mov    0x1beba,%ebx
   144bf:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
	idt_entry[0] = entry;
   144c2:	66 89 10             	mov    %dx,(%eax)
	idt_entry[1] = KERNEL_CS << 3;
   144c5:	66 c7 40 02 08 00    	movw   $0x8,0x2(%eax)
	idt_entry[2] = type;
   144cb:	66 89 48 04          	mov    %cx,0x4(%eax)
	idt_entry[3] = entry >> 16;
   144cf:	c1 ea 10             	shr    $0x10,%edx
   144d2:	66 89 50 06          	mov    %dx,0x6(%eax)
	// write_eflags(save_eflags);
}
   144d6:	5b                   	pop    %ebx
   144d7:	5d                   	pop    %ebp
   144d8:	c3                   	ret    

000144d9 <common_trap_handler>:
	print_hex(frame->eflags, 8);
	print_char('\n');
}

void common_trap_handler(struct trap_frame frame, u32 index, u32 error_code)
{
   144d9:	55                   	push   %ebp
   144da:	89 e5                	mov    %esp,%ebp
   144dc:	57                   	push   %edi
   144dd:	56                   	push   %esi
   144de:	53                   	push   %ebx
   144df:	83 ec 18             	sub    $0x18,%esp
   144e2:	8b 5d 44             	mov    0x44(%ebp),%ebx
   144e5:	8b 7d 48             	mov    0x48(%ebp),%edi
	enum console_env old = console_set_env(CONSOLE_ENV_INTR);
   144e8:	6a 01                	push   $0x1
   144ea:	e8 df e4 ff ff       	call   129ce <console_set_env>
   144ef:	89 c6                	mov    %eax,%esi

	if (PIC_VECTOR_MASTER <= index && index <= PIC_VECTOR_SLAVE + 8)
   144f1:	8d 43 e0             	lea    -0x20(%ebx),%eax
   144f4:	83 c4 10             	add    $0x10,%esp
   144f7:	83 f8 10             	cmp    $0x10,%eax
   144fa:	77 14                	ja     14510 <common_trap_handler+0x37>
	{
		pic_irq_common_handler(index - PIC_VECTOR_MASTER);
   144fc:	83 ec 0c             	sub    $0xc,%esp
   144ff:	83 eb 20             	sub    $0x20,%ebx
   14502:	0f b6 db             	movzbl %bl,%ebx
   14505:	53                   	push   %ebx
   14506:	e8 bf 16 00 00       	call   15bca <pic_irq_common_handler>
   1450b:	e9 b8 01 00 00       	jmp    146c8 <common_trap_handler+0x1ef>
	}
	else
	{
		// print_str("\nenter common_trap_handler\n");
		if (index == PAGEFAULT_INDEX)
   14510:	83 fb 0e             	cmp    $0xe,%ebx
   14513:	75 0f                	jne    14524 <common_trap_handler+0x4b>
		{
			pagefault_exception_handler(&frame, error_code);
   14515:	50                   	push   %eax
   14516:	50                   	push   %eax
   14517:	57                   	push   %edi
   14518:	8d 45 08             	lea    0x8(%ebp),%eax
   1451b:	50                   	push   %eax
   1451c:	e8 86 0e 00 00       	call   153a7 <pagefault_exception_handler>
   14521:	83 c4 10             	add    $0x10,%esp
		}
		// console_clear_screen();
		console_set_color(COLOR_NORMAL_BG, COLOR_LIGHT_RED);
   14524:	50                   	push   %eax
   14525:	50                   	push   %eax
   14526:	68 00 00 ff 00       	push   $0xff0000
   1452b:	6a 00                	push   $0x0
   1452d:	e8 5e e2 ff ff       	call   12790 <console_set_color>
		print_str("vector: 0x");
   14532:	c7 04 24 d9 8c 01 00 	movl   $0x18cd9,(%esp)
   14539:	e8 75 e9 ff ff       	call   12eb3 <print_str>
		print_hex(index, 2);
   1453e:	5a                   	pop    %edx
   1453f:	59                   	pop    %ecx
   14540:	6a 02                	push   $0x2
   14542:	53                   	push   %ebx
   14543:	e8 8e ea ff ff       	call   12fd6 <print_hex>
		print_str("\nerror_code: 0x");
   14548:	c7 04 24 e4 8c 01 00 	movl   $0x18ce4,(%esp)
   1454f:	e8 5f e9 ff ff       	call   12eb3 <print_str>
		print_hex(error_code, 0);
   14554:	58                   	pop    %eax
   14555:	5a                   	pop    %edx
   14556:	6a 00                	push   $0x0
   14558:	57                   	push   %edi
   14559:	e8 78 ea ff ff       	call   12fd6 <print_hex>
		print_char('\n');
   1455e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
   14565:	e8 f8 e4 ff ff       	call   12a62 <print_char>
		print_str(exception_description[index]);
   1456a:	59                   	pop    %ecx
   1456b:	ff 34 9d 20 92 01 00 	push   0x19220(,%ebx,4)
   14572:	e8 3c e9 ff ff       	call   12eb3 <print_str>
		print_char('\n');
   14577:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
   1457e:	e8 df e4 ff ff       	call   12a62 <print_char>
	print_str("EAX: 0x");
   14583:	c7 04 24 f4 8c 01 00 	movl   $0x18cf4,(%esp)
   1458a:	e8 24 e9 ff ff       	call   12eb3 <print_str>
	print_hex(frame->eax, 8);
   1458f:	5b                   	pop    %ebx
   14590:	5f                   	pop    %edi
   14591:	6a 08                	push   $0x8
   14593:	ff 75 34             	push   0x34(%ebp)
   14596:	e8 3b ea ff ff       	call   12fd6 <print_hex>
	print_str(" ECX: 0x");
   1459b:	c7 04 24 fc 8c 01 00 	movl   $0x18cfc,(%esp)
   145a2:	e8 0c e9 ff ff       	call   12eb3 <print_str>
	print_hex(frame->ecx, 8);
   145a7:	58                   	pop    %eax
   145a8:	5a                   	pop    %edx
   145a9:	6a 08                	push   $0x8
   145ab:	ff 75 30             	push   0x30(%ebp)
   145ae:	e8 23 ea ff ff       	call   12fd6 <print_hex>
	print_str("\nEDX: 0x");
   145b3:	c7 04 24 05 8d 01 00 	movl   $0x18d05,(%esp)
   145ba:	e8 f4 e8 ff ff       	call   12eb3 <print_str>
	print_hex(frame->edx, 8);
   145bf:	59                   	pop    %ecx
   145c0:	5b                   	pop    %ebx
   145c1:	6a 08                	push   $0x8
   145c3:	ff 75 2c             	push   0x2c(%ebp)
   145c6:	e8 0b ea ff ff       	call   12fd6 <print_hex>
	print_str(" EBX: 0x");
   145cb:	c7 04 24 0e 8d 01 00 	movl   $0x18d0e,(%esp)
   145d2:	e8 dc e8 ff ff       	call   12eb3 <print_str>
	print_hex(frame->ebx, 8);
   145d7:	5f                   	pop    %edi
   145d8:	58                   	pop    %eax
   145d9:	6a 08                	push   $0x8
   145db:	ff 75 28             	push   0x28(%ebp)
   145de:	e8 f3 e9 ff ff       	call   12fd6 <print_hex>
	print_str("\nESI: 0x");
   145e3:	c7 04 24 17 8d 01 00 	movl   $0x18d17,(%esp)
   145ea:	e8 c4 e8 ff ff       	call   12eb3 <print_str>
	print_hex(frame->esi, 8);
   145ef:	58                   	pop    %eax
   145f0:	5a                   	pop    %edx
   145f1:	6a 08                	push   $0x8
   145f3:	ff 75 1c             	push   0x1c(%ebp)
   145f6:	e8 db e9 ff ff       	call   12fd6 <print_hex>
	print_str(" EDI: 0x");
   145fb:	c7 04 24 20 8d 01 00 	movl   $0x18d20,(%esp)
   14602:	e8 ac e8 ff ff       	call   12eb3 <print_str>
	print_hex(frame->edi, 8);
   14607:	59                   	pop    %ecx
   14608:	5b                   	pop    %ebx
   14609:	6a 08                	push   $0x8
   1460b:	ff 75 18             	push   0x18(%ebp)
   1460e:	e8 c3 e9 ff ff       	call   12fd6 <print_hex>
	print_str("\nCR0: 0x");
   14613:	c7 04 24 29 8d 01 00 	movl   $0x18d29,(%esp)
   1461a:	e8 94 e8 ff ff       	call   12eb3 <print_str>
	print_hex(frame->cr0, 8);
   1461f:	5f                   	pop    %edi
   14620:	58                   	pop    %eax
   14621:	6a 08                	push   $0x8
   14623:	ff 75 08             	push   0x8(%ebp)
   14626:	e8 ab e9 ff ff       	call   12fd6 <print_hex>
	print_str(" CR2: 0x");
   1462b:	c7 04 24 32 8d 01 00 	movl   $0x18d32,(%esp)
   14632:	e8 7c e8 ff ff       	call   12eb3 <print_str>
	print_hex(frame->cr2, 8);
   14637:	58                   	pop    %eax
   14638:	5a                   	pop    %edx
   14639:	6a 08                	push   $0x8
   1463b:	ff 75 0c             	push   0xc(%ebp)
   1463e:	e8 93 e9 ff ff       	call   12fd6 <print_hex>
	print_str("\nCR3: 0x");
   14643:	c7 04 24 3b 8d 01 00 	movl   $0x18d3b,(%esp)
   1464a:	e8 64 e8 ff ff       	call   12eb3 <print_str>
	print_hex(frame->cr3, 8);
   1464f:	59                   	pop    %ecx
   14650:	5b                   	pop    %ebx
   14651:	6a 08                	push   $0x8
   14653:	ff 75 10             	push   0x10(%ebp)
   14656:	e8 7b e9 ff ff       	call   12fd6 <print_hex>
	print_str(" CR4: 0x");
   1465b:	c7 04 24 44 8d 01 00 	movl   $0x18d44,(%esp)
   14662:	e8 4c e8 ff ff       	call   12eb3 <print_str>
	print_hex(frame->cr4, 8);
   14667:	5f                   	pop    %edi
   14668:	58                   	pop    %eax
   14669:	6a 08                	push   $0x8
   1466b:	ff 75 14             	push   0x14(%ebp)
   1466e:	e8 63 e9 ff ff       	call   12fd6 <print_hex>
	print_str("\nCS: 0x");
   14673:	c7 04 24 4d 8d 01 00 	movl   $0x18d4d,(%esp)
   1467a:	e8 34 e8 ff ff       	call   12eb3 <print_str>
	print_hex(frame->cs, 8);
   1467f:	58                   	pop    %eax
   14680:	5a                   	pop    %edx
   14681:	6a 08                	push   $0x8
   14683:	ff 75 3c             	push   0x3c(%ebp)
   14686:	e8 4b e9 ff ff       	call   12fd6 <print_hex>
	print_str(" EIP: 0x");
   1468b:	c7 04 24 55 8d 01 00 	movl   $0x18d55,(%esp)
   14692:	e8 1c e8 ff ff       	call   12eb3 <print_str>
	print_hex(frame->eip, 8);
   14697:	59                   	pop    %ecx
   14698:	5b                   	pop    %ebx
   14699:	6a 08                	push   $0x8
   1469b:	ff 75 38             	push   0x38(%ebp)
   1469e:	e8 33 e9 ff ff       	call   12fd6 <print_hex>
	print_str("\nEFLAGS: 0x");
   146a3:	c7 04 24 5e 8d 01 00 	movl   $0x18d5e,(%esp)
   146aa:	e8 04 e8 ff ff       	call   12eb3 <print_str>
	print_hex(frame->eflags, 8);
   146af:	5f                   	pop    %edi
   146b0:	58                   	pop    %eax
   146b1:	6a 08                	push   $0x8
   146b3:	ff 75 40             	push   0x40(%ebp)
   146b6:	e8 1b e9 ff ff       	call   12fd6 <print_hex>
	print_char('\n');
   146bb:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
   146c2:	e8 9b e3 ff ff       	call   12a62 <print_char>
							 : "memory");
}

inline static void halt(void)
{
	__asm__ __volatile__("hlt\n" ::
   146c7:	f4                   	hlt    
							 : "memory");
}
   146c8:	83 c4 10             	add    $0x10,%esp
		halt();
		// for (;;)
		// 	;
	}

	console_set_env(old);
   146cb:	83 ec 0c             	sub    $0xc,%esp
   146ce:	56                   	push   %esi
   146cf:	e8 fa e2 ff ff       	call   129ce <console_set_env>
}
   146d4:	83 c4 10             	add    $0x10,%esp
   146d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
   146da:	5b                   	pop    %ebx
   146db:	5e                   	pop    %esi
   146dc:	5f                   	pop    %edi
   146dd:	5d                   	pop    %ebp
   146de:	c3                   	ret    

000146df <idt_setup>:

void idt_setup(void)
{
   146df:	55                   	push   %ebp
   146e0:	89 e5                	mov    %esp,%ebp
   146e2:	53                   	push   %ebx
   146e3:	52                   	push   %edx
					 : "memory");
}

inline static void sidt(struct idt_ptr48 *ptr)
{
	__asm__ volatile("sidt (%0)\n\t"
   146e4:	b8 b8 be 01 00       	mov    $0x1beb8,%eax
   146e9:	0f 01 08             	sidtl  (%eax)
	sidt(&gk_idt_ptr);

	u32 type = GATE_PRESENT | GATE_TYPE_INTERRUPT;

	set_idt_entry(0, (u32)kTrap0, type | GATE_DPL_USER);
   146ec:	b9 00 ee 00 00       	mov    $0xee00,%ecx
   146f1:	ba b0 14 01 00       	mov    $0x114b0,%edx
   146f6:	31 c0                	xor    %eax,%eax
   146f8:	e8 b5 fd ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(1, (u32)kTrap1, type | GATE_DPL_USER);
   146fd:	ba e4 14 01 00       	mov    $0x114e4,%edx
   14702:	b8 01 00 00 00       	mov    $0x1,%eax
   14707:	e8 a6 fd ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(2, (u32)kTrap2, type);
   1470c:	b9 00 8e 00 00       	mov    $0x8e00,%ecx
   14711:	ba 18 15 01 00       	mov    $0x11518,%edx
   14716:	b8 02 00 00 00       	mov    $0x2,%eax
   1471b:	e8 92 fd ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(3, (u32)kTrap3, type | GATE_DPL_USER);
   14720:	b9 00 ee 00 00       	mov    $0xee00,%ecx
   14725:	ba 4c 15 01 00       	mov    $0x1154c,%edx
   1472a:	b8 03 00 00 00       	mov    $0x3,%eax
   1472f:	e8 7e fd ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(4, (u32)kTrap4, type | GATE_DPL_USER);
   14734:	ba 80 15 01 00       	mov    $0x11580,%edx
   14739:	b8 04 00 00 00       	mov    $0x4,%eax
   1473e:	e8 6f fd ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(5, (u32)kTrap5, type);
   14743:	b9 00 8e 00 00       	mov    $0x8e00,%ecx
   14748:	ba b4 15 01 00       	mov    $0x115b4,%edx
   1474d:	b8 05 00 00 00       	mov    $0x5,%eax
   14752:	e8 5b fd ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(6, (u32)kTrap6, type);
   14757:	ba e8 15 01 00       	mov    $0x115e8,%edx
   1475c:	b8 06 00 00 00       	mov    $0x6,%eax
   14761:	e8 4c fd ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(7, (u32)kTrap7, type);
   14766:	ba 1c 16 01 00       	mov    $0x1161c,%edx
   1476b:	b8 07 00 00 00       	mov    $0x7,%eax
   14770:	e8 3d fd ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(8, (u32)kTrap8, type);
   14775:	ba 50 16 01 00       	mov    $0x11650,%edx
   1477a:	b8 08 00 00 00       	mov    $0x8,%eax
   1477f:	e8 2e fd ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(9, (u32)kTrap9, type);
   14784:	ba 80 16 01 00       	mov    $0x11680,%edx
   14789:	b8 09 00 00 00       	mov    $0x9,%eax
   1478e:	e8 1f fd ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(10, (u32)kTrap10, type);
   14793:	ba b4 16 01 00       	mov    $0x116b4,%edx
   14798:	b8 0a 00 00 00       	mov    $0xa,%eax
   1479d:	e8 10 fd ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(11, (u32)kTrap11, type);
   147a2:	ba e4 16 01 00       	mov    $0x116e4,%edx
   147a7:	b8 0b 00 00 00       	mov    $0xb,%eax
   147ac:	e8 01 fd ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(12, (u32)kTrap12, type);
   147b1:	ba 14 17 01 00       	mov    $0x11714,%edx
   147b6:	b8 0c 00 00 00       	mov    $0xc,%eax
   147bb:	e8 f2 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(13, (u32)kTrap13, type);
   147c0:	ba 44 17 01 00       	mov    $0x11744,%edx
   147c5:	b8 0d 00 00 00       	mov    $0xd,%eax
   147ca:	e8 e3 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(14, (u32)kTrap14, type);
   147cf:	ba 74 17 01 00       	mov    $0x11774,%edx
   147d4:	b8 0e 00 00 00       	mov    $0xe,%eax
   147d9:	e8 d4 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(15, (u32)kTrapReserved, type);
   147de:	ba b0 1b 01 00       	mov    $0x11bb0,%edx
   147e3:	b8 0f 00 00 00       	mov    $0xf,%eax
   147e8:	e8 c5 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(16, (u32)kTrap16, type);
   147ed:	ba a4 17 01 00       	mov    $0x117a4,%edx
   147f2:	b8 10 00 00 00       	mov    $0x10,%eax
   147f7:	e8 b6 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(17, (u32)kTrap17, type);
   147fc:	ba d8 17 01 00       	mov    $0x117d8,%edx
   14801:	b8 11 00 00 00       	mov    $0x11,%eax
   14806:	e8 a7 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(18, (u32)kTrap18, type);
   1480b:	ba 08 18 01 00       	mov    $0x11808,%edx
   14810:	b8 12 00 00 00       	mov    $0x12,%eax
   14815:	e8 98 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(19, (u32)kTrap19, type);
   1481a:	ba 3c 18 01 00       	mov    $0x1183c,%edx
   1481f:	b8 13 00 00 00       	mov    $0x13,%eax
   14824:	e8 89 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(20, (u32)kTrap20, type);
   14829:	ba 70 18 01 00       	mov    $0x11870,%edx
   1482e:	b8 14 00 00 00       	mov    $0x14,%eax
   14833:	e8 7a fc ff ff       	call   144b2 <set_idt_entry>
   14838:	bb 15 00 00 00       	mov    $0x15,%ebx

	for (u8 i = 21; i <= 31; ++i)
	{
		set_idt_entry(i, (u32)kTrapReserved, type);
   1483d:	b9 00 8e 00 00       	mov    $0x8e00,%ecx
   14842:	ba b0 1b 01 00       	mov    $0x11bb0,%edx
   14847:	89 d8                	mov    %ebx,%eax
   14849:	e8 64 fc ff ff       	call   144b2 <set_idt_entry>
	for (u8 i = 21; i <= 31; ++i)
   1484e:	43                   	inc    %ebx
   1484f:	83 fb 20             	cmp    $0x20,%ebx
   14852:	75 e9                	jne    1483d <idt_setup+0x15e>
	}

	// IRQ entry
	set_idt_entry(32, (u32)kTrap32, type);
   14854:	ba a4 18 01 00       	mov    $0x118a4,%edx
   14859:	b8 20 00 00 00       	mov    $0x20,%eax
   1485e:	e8 4f fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(33, (u32)kTrap33, type);
   14863:	ba d8 18 01 00       	mov    $0x118d8,%edx
   14868:	b8 21 00 00 00       	mov    $0x21,%eax
   1486d:	e8 40 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(34, (u32)kTrapReserved, type);
   14872:	ba b0 1b 01 00       	mov    $0x11bb0,%edx
   14877:	b8 22 00 00 00       	mov    $0x22,%eax
   1487c:	e8 31 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(35, (u32)kTrap35, type);
   14881:	ba 0c 19 01 00       	mov    $0x1190c,%edx
   14886:	b8 23 00 00 00       	mov    $0x23,%eax
   1488b:	e8 22 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(36, (u32)kTrap36, type);
   14890:	ba 40 19 01 00       	mov    $0x11940,%edx
   14895:	b8 24 00 00 00       	mov    $0x24,%eax
   1489a:	e8 13 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(37, (u32)kTrap37, type);
   1489f:	ba 74 19 01 00       	mov    $0x11974,%edx
   148a4:	b8 25 00 00 00       	mov    $0x25,%eax
   148a9:	e8 04 fc ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(38, (u32)kTrap38, type);
   148ae:	ba a8 19 01 00       	mov    $0x119a8,%edx
   148b3:	b8 26 00 00 00       	mov    $0x26,%eax
   148b8:	e8 f5 fb ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(39, (u32)kTrap39, type);
   148bd:	ba dc 19 01 00       	mov    $0x119dc,%edx
   148c2:	b8 27 00 00 00       	mov    $0x27,%eax
   148c7:	e8 e6 fb ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(40, (u32)kTrap40, type);
   148cc:	ba 10 1a 01 00       	mov    $0x11a10,%edx
   148d1:	b8 28 00 00 00       	mov    $0x28,%eax
   148d6:	e8 d7 fb ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(41, (u32)kTrap41, type);
   148db:	ba 44 1a 01 00       	mov    $0x11a44,%edx
   148e0:	b8 29 00 00 00       	mov    $0x29,%eax
   148e5:	e8 c8 fb ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(42, (u32)kTrap42, type);
   148ea:	ba 78 1a 01 00       	mov    $0x11a78,%edx
   148ef:	b8 2a 00 00 00       	mov    $0x2a,%eax
   148f4:	e8 b9 fb ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(43, (u32)kTrap43, type);
   148f9:	ba ac 1a 01 00       	mov    $0x11aac,%edx
   148fe:	b8 2b 00 00 00       	mov    $0x2b,%eax
   14903:	e8 aa fb ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(44, (u32)kTrap44, type);
   14908:	ba e0 1a 01 00       	mov    $0x11ae0,%edx
   1490d:	b8 2c 00 00 00       	mov    $0x2c,%eax
   14912:	e8 9b fb ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(45, (u32)kTrap45, type);
   14917:	ba 14 1b 01 00       	mov    $0x11b14,%edx
   1491c:	b8 2d 00 00 00       	mov    $0x2d,%eax
   14921:	e8 8c fb ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(46, (u32)kTrap46, type);
   14926:	ba 48 1b 01 00       	mov    $0x11b48,%edx
   1492b:	b8 2e 00 00 00       	mov    $0x2e,%eax
   14930:	e8 7d fb ff ff       	call   144b2 <set_idt_entry>
	set_idt_entry(47, (u32)kTrap47, type);
   14935:	ba 7c 1b 01 00       	mov    $0x11b7c,%edx
   1493a:	b8 2f 00 00 00       	mov    $0x2f,%eax
   1493f:	e8 6e fb ff ff       	call   144b2 <set_idt_entry>
   14944:	bb ff 00 00 00       	mov    $0xff,%ebx

	for (u8 i = 255; i >= 48; --i)
	{
		set_idt_entry(i, (u32)kTrapReserved, type);
   14949:	b9 00 8e 00 00       	mov    $0x8e00,%ecx
   1494e:	ba b0 1b 01 00       	mov    $0x11bb0,%edx
   14953:	89 d8                	mov    %ebx,%eax
   14955:	e8 58 fb ff ff       	call   144b2 <set_idt_entry>
	for (u8 i = 255; i >= 48; --i)
   1495a:	4b                   	dec    %ebx
   1495b:	83 fb 2f             	cmp    $0x2f,%ebx
   1495e:	75 e9                	jne    14949 <idt_setup+0x26a>
	}
}
   14960:	58                   	pop    %eax
   14961:	5b                   	pop    %ebx
   14962:	5d                   	pop    %ebp
   14963:	c3                   	ret    

00014964 <_irq_handler>:
        }
    }
}

static void _irq_handler(void)
{
   14964:	55                   	push   %ebp
   14965:	89 e5                	mov    %esp,%ebp
   14967:	57                   	push   %edi
   14968:	56                   	push   %esi
   14969:	53                   	push   %ebx
   1496a:	83 ec 3c             	sub    $0x3c,%esp
    bool released = false, alternate = false, expecting_pause = false, expecting_prtscr = false, success = false, failed = false;
   1496d:	c6 45 c6 00          	movb   $0x0,-0x3a(%ebp)
   14971:	31 c9                	xor    %ecx,%ecx
   14973:	31 f6                	xor    %esi,%esi
    u32 scode_seq_idx = 0;
   14975:	31 db                	xor    %ebx,%ebx
    bool released = false, alternate = false, expecting_pause = false, expecting_prtscr = false, success = false, failed = false;
   14977:	c6 45 c5 00          	movb   $0x0,-0x3b(%ebp)
    u8 scode[32], latest_scode = 0, len = 0, key = 0;
   1497b:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
   1497f:	88 4d c3             	mov    %cl,-0x3d(%ebp)
        if (!kbd_read(&scode[len], false))
   14982:	0f b6 7d c4          	movzbl -0x3c(%ebp),%edi
    return ps2_read(data, wait_infinite);
   14986:	51                   	push   %ecx
   14987:	51                   	push   %ecx
   14988:	6a 00                	push   $0x0
        if (!kbd_read(&scode[len], false))
   1498a:	8d 44 3d c8          	lea    -0x38(%ebp,%edi,1),%eax
    return ps2_read(data, wait_infinite);
   1498e:	50                   	push   %eax
   1498f:	e8 aa d2 ff ff       	call   11c3e <ps2_read>
   14994:	88 45 c7             	mov    %al,-0x39(%ebp)
        if (!kbd_read(&scode[len], false))
   14997:	83 c4 10             	add    $0x10,%esp
   1499a:	84 c0                	test   %al,%al
   1499c:	0f 84 d2 00 00 00    	je     14a74 <_irq_handler+0x110>
        latest_scode = scode[len++];
   149a2:	fe 45 c4             	incb   -0x3c(%ebp)
   149a5:	0f b6 44 3d c8       	movzbl -0x38(%ebp,%edi,1),%eax
        if (expecting_pause)
   149aa:	80 7d c5 00          	cmpb   $0x0,-0x3b(%ebp)
   149ae:	8a 4d c3             	mov    -0x3d(%ebp),%cl
   149b1:	74 1b                	je     149ce <_irq_handler+0x6a>
            if (latest_scode == scode_seq[2][scode_seq_idx])
   149b3:	3a 83 98 94 01 00    	cmp    0x19498(%ebx),%al
   149b9:	0f 85 b5 00 00 00    	jne    14a74 <_irq_handler+0x110>
                if (++scode_seq_idx == 8)
   149bf:	43                   	inc    %ebx
   149c0:	83 fb 08             	cmp    $0x8,%ebx
   149c3:	0f 85 a3 00 00 00    	jne    14a6c <_irq_handler+0x108>
   149c9:	e9 d8 00 00 00       	jmp    14aa6 <_irq_handler+0x142>
        else if (expecting_prtscr)
   149ce:	89 f2                	mov    %esi,%edx
   149d0:	84 d2                	test   %dl,%dl
   149d2:	74 34                	je     14a08 <_irq_handler+0xa4>
            if (latest_scode == scode_seq[released][released + scode_seq_idx])
   149d4:	0f b6 d1             	movzbl %cl,%edx
   149d7:	8d bc d3 88 94 01 00 	lea    0x19488(%ebx,%edx,8),%edi
   149de:	3a 04 17             	cmp    (%edi,%edx,1),%al
   149e1:	0f 85 8d 00 00 00    	jne    14a74 <_irq_handler+0x110>
                ++scode_seq_idx;
   149e7:	43                   	inc    %ebx
                if ((scode_seq_idx == 4 && !released) || (scode_seq_idx == 6 && released))
   149e8:	83 fb 04             	cmp    $0x4,%ebx
   149eb:	75 0c                	jne    149f9 <_irq_handler+0x95>
   149ed:	84 c9                	test   %cl,%cl
   149ef:	0f 84 08 01 00 00    	je     14afd <_irq_handler+0x199>
   149f5:	89 ce                	mov    %ecx,%esi
   149f7:	eb 73                	jmp    14a6c <_irq_handler+0x108>
   149f9:	83 fb 06             	cmp    $0x6,%ebx
   149fc:	75 6e                	jne    14a6c <_irq_handler+0x108>
   149fe:	84 c9                	test   %cl,%cl
   14a00:	0f 85 f7 00 00 00    	jne    14afd <_irq_handler+0x199>
   14a06:	eb 64                	jmp    14a6c <_irq_handler+0x108>
            switch (latest_scode)
   14a08:	3c e1                	cmp    $0xe1,%al
   14a0a:	75 10                	jne    14a1c <_irq_handler+0xb8>
   14a0c:	bb 01 00 00 00       	mov    $0x1,%ebx
    u8 scode[32], latest_scode = 0, len = 0, key = 0;
   14a11:	8a 45 c7             	mov    -0x39(%ebp),%al
   14a14:	88 45 c5             	mov    %al,-0x3b(%ebp)
   14a17:	e9 63 ff ff ff       	jmp    1497f <_irq_handler+0x1b>
            switch (latest_scode)
   14a1c:	3c f0                	cmp    $0xf0,%al
   14a1e:	74 41                	je     14a61 <_irq_handler+0xfd>
   14a20:	3c e0                	cmp    $0xe0,%al
   14a22:	74 42                	je     14a66 <_irq_handler+0x102>
                if (alternate && (latest_scode == 0x12 || latest_scode == 0x7C))
   14a24:	80 7d c6 00          	cmpb   $0x0,-0x3a(%ebp)
   14a28:	75 06                	jne    14a30 <_irq_handler+0xcc>
                else if (latest_scode > 0x83)
   14a2a:	3c 83                	cmp    $0x83,%al
   14a2c:	77 46                	ja     14a74 <_irq_handler+0x110>
   14a2e:	eb 1a                	jmp    14a4a <_irq_handler+0xe6>
                if (alternate && (latest_scode == 0x12 || latest_scode == 0x7C))
   14a30:	3c 7c                	cmp    $0x7c,%al
   14a32:	0f 94 c2             	sete   %dl
   14a35:	3c 12                	cmp    $0x12,%al
   14a37:	0f 94 c3             	sete   %bl
   14a3a:	08 da                	or     %bl,%dl
   14a3c:	74 ec                	je     14a2a <_irq_handler+0xc6>
                    expecting_prtscr = true;
   14a3e:	89 d6                	mov    %edx,%esi
   14a40:	88 55 c6             	mov    %dl,-0x3a(%ebp)
                    scode_seq_idx = 2;
   14a43:	bb 02 00 00 00       	mov    $0x2,%ebx
   14a48:	eb 22                	jmp    14a6c <_irq_handler+0x108>
                    key = key_mapping[alternate][latest_scode];
   14a4a:	0f b6 55 c6          	movzbl -0x3a(%ebp),%edx
   14a4e:	69 d2 84 00 00 00    	imul   $0x84,%edx,%edx
   14a54:	8a 84 10 80 93 01 00 	mov    0x19380(%eax,%edx,1),%al
                    if (key == 0)
   14a5b:	84 c0                	test   %al,%al
   14a5d:	74 15                	je     14a74 <_irq_handler+0x110>
   14a5f:	eb 47                	jmp    14aa8 <_irq_handler+0x144>
            switch (latest_scode)
   14a61:	8a 4d c7             	mov    -0x39(%ebp),%cl
   14a64:	eb 06                	jmp    14a6c <_irq_handler+0x108>
                alternate = true;
   14a66:	8a 45 c7             	mov    -0x39(%ebp),%al
   14a69:	88 45 c6             	mov    %al,-0x3a(%ebp)
{
   14a6c:	8a 45 c5             	mov    -0x3b(%ebp),%al
   14a6f:	88 45 c7             	mov    %al,-0x39(%ebp)
   14a72:	eb 9d                	jmp    14a11 <_irq_handler+0xad>
        printf("\nunexpecting scode seq(%d):", len);
   14a74:	0f b6 5d c4          	movzbl -0x3c(%ebp),%ebx
   14a78:	50                   	push   %eax
   14a79:	50                   	push   %eax
   14a7a:	53                   	push   %ebx
   14a7b:	68 7a 92 01 00       	push   $0x1927a
   14a80:	e8 75 e4 ff ff       	call   12efa <printf>
        for (int i = 0; i < len; ++i)
   14a85:	83 c4 10             	add    $0x10,%esp
   14a88:	31 f6                	xor    %esi,%esi
   14a8a:	39 f3                	cmp    %esi,%ebx
   14a8c:	7e 5a                	jle    14ae8 <_irq_handler+0x184>
            printf(" 0x%x", scode[i]);
   14a8e:	52                   	push   %edx
   14a8f:	52                   	push   %edx
   14a90:	0f b6 44 35 c8       	movzbl -0x38(%ebp,%esi,1),%eax
   14a95:	50                   	push   %eax
   14a96:	68 74 92 01 00       	push   $0x19274
   14a9b:	e8 5a e4 ff ff       	call   12efa <printf>
        for (int i = 0; i < len; ++i)
   14aa0:	46                   	inc    %esi
   14aa1:	83 c4 10             	add    $0x10,%esp
   14aa4:	eb e4                	jmp    14a8a <_irq_handler+0x126>
                    key = KEY_PAUSE;
   14aa6:	b0 0b                	mov    $0xb,%al
    _kbd_buf[_kbd_buf_idx].key = key;
   14aa8:	0f b6 1d c2 be 01 00 	movzbl 0x1bec2,%ebx
   14aaf:	88 84 1b e0 be 01 00 	mov    %al,0x1bee0(%ebx,%ebx,1)
    _kbd_buf[_kbd_buf_idx].released = released;
   14ab6:	88 8c 1b e1 be 01 00 	mov    %cl,0x1bee1(%ebx,%ebx,1)
    if (++_kbd_buf_idx == 128)
   14abd:	8d 43 01             	lea    0x1(%ebx),%eax
   14ac0:	80 fb 7f             	cmp    $0x7f,%bl
   14ac3:	75 54                	jne    14b19 <_irq_handler+0x1b5>
        _kbd_buf_idx = 0;
   14ac5:	c6 05 c2 be 01 00 00 	movb   $0x0,0x1bec2
    if (_kbd_buf_idx == _kbd_buf_oldest)
   14acc:	a0 c0 be 01 00       	mov    0x1bec0,%al
   14ad1:	38 05 c2 be 01 00    	cmp    %al,0x1bec2
   14ad7:	74 28                	je     14b01 <_irq_handler+0x19d>
    if (_kbd_buf_size != 128)
   14ad9:	a0 c1 be 01 00       	mov    0x1bec1,%al
   14ade:	3c 80                	cmp    $0x80,%al
   14ae0:	74 06                	je     14ae8 <_irq_handler+0x184>
        ++_kbd_buf_size;
   14ae2:	40                   	inc    %eax
   14ae3:	a2 c1 be 01 00       	mov    %al,0x1bec1
    __asm__ volatile("inb %1, %0"
   14ae8:	e4 61                	in     $0x61,%al
   14aea:	88 c2                	mov    %al,%dl
    kbd_decode_scode();

    // for PC-XT PPI used to reset kbd intr req signals
    u8 ack = port_read_byte(PS2_PORT_ACK);
    port_write_byte(PS2_PORT_ACK, ack | 0x80);
   14aec:	83 c8 80             	or     $0xffffff80,%eax
    __asm__ volatile("outb %0, %1"
   14aef:	e6 61                	out    %al,$0x61
   14af1:	88 d0                	mov    %dl,%al
   14af3:	e6 61                	out    %al,$0x61
    port_write_byte(PS2_PORT_ACK, ack);
}
   14af5:	8d 65 f4             	lea    -0xc(%ebp),%esp
   14af8:	5b                   	pop    %ebx
   14af9:	5e                   	pop    %esi
   14afa:	5f                   	pop    %edi
   14afb:	5d                   	pop    %ebp
   14afc:	c3                   	ret    
                    key = KEY_PRTSCR;
   14afd:	b0 0a                	mov    $0xa,%al
   14aff:	eb a7                	jmp    14aa8 <_irq_handler+0x144>
        if (++_kbd_buf_oldest == 128)
   14b01:	8d 50 01             	lea    0x1(%eax),%edx
   14b04:	3c 7f                	cmp    $0x7f,%al
   14b06:	74 08                	je     14b10 <_irq_handler+0x1ac>
   14b08:	88 15 c0 be 01 00    	mov    %dl,0x1bec0
   14b0e:	eb c9                	jmp    14ad9 <_irq_handler+0x175>
            _kbd_buf_oldest = 0;
   14b10:	c6 05 c0 be 01 00 00 	movb   $0x0,0x1bec0
   14b17:	eb c0                	jmp    14ad9 <_irq_handler+0x175>
    if (++_kbd_buf_idx == 128)
   14b19:	a2 c2 be 01 00       	mov    %al,0x1bec2
   14b1e:	eb ac                	jmp    14acc <_irq_handler+0x168>

00014b20 <kbd_write.constprop.0.isra.0>:
static bool kbd_write(u8 data, bool wait_infinite)
   14b20:	55                   	push   %ebp
   14b21:	89 e5                	mov    %esp,%ebp
   14b23:	83 ec 0c             	sub    $0xc,%esp
    return ps2_write(data, false, wait_infinite);
   14b26:	6a 01                	push   $0x1
   14b28:	6a 00                	push   $0x0
   14b2a:	0f b6 c0             	movzbl %al,%eax
   14b2d:	50                   	push   %eax
   14b2e:	e8 ae d0 ff ff       	call   11be1 <ps2_write>
   14b33:	83 c4 10             	add    $0x10,%esp
}
   14b36:	c9                   	leave  
   14b37:	c3                   	ret    

00014b38 <kbd_setup>:

bool kbd_setup(void)
{
   14b38:	55                   	push   %ebp
   14b39:	89 e5                	mov    %esp,%ebp
   14b3b:	57                   	push   %edi
   14b3c:	56                   	push   %esi
   14b3d:	53                   	push   %ebx
   14b3e:	83 ec 1c             	sub    $0x1c,%esp
    u8 result[3], i = 0;

    kbd_write(KBD_CMD_DISABLE, true);
   14b41:	b8 f5 00 00 00       	mov    $0xf5,%eax
   14b46:	e8 d5 ff ff ff       	call   14b20 <kbd_write.constprop.0.isra.0>
    return ps2_read(data, wait_infinite);
   14b4b:	50                   	push   %eax
   14b4c:	50                   	push   %eax
   14b4d:	6a 00                	push   $0x0
   14b4f:	8d 5d e5             	lea    -0x1b(%ebp),%ebx
   14b52:	53                   	push   %ebx
   14b53:	e8 e6 d0 ff ff       	call   11c3e <ps2_read>
    while (kbd_read(result, false))
   14b58:	83 c4 10             	add    $0x10,%esp
   14b5b:	84 c0                	test   %al,%al
   14b5d:	75 ec                	jne    14b4b <kbd_setup+0x13>
        ;

    if (result[0] != 0xfa)
   14b5f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
   14b63:	3c fa                	cmp    $0xfa,%al
   14b65:	75 67                	jne    14bce <kbd_setup+0x96>
    {
        printf("No Keyboard Connected! (KBD_CMD_DISABLE): %x\n", result[0]);
        goto Exit;
    }

    kbd_write(KBD_CMD_RESET, true);
   14b67:	b8 ff 00 00 00       	mov    $0xff,%eax
   14b6c:	e8 af ff ff ff       	call   14b20 <kbd_write.constprop.0.isra.0>
    while (kbd_read(&result[i], false) && i < 2)
   14b71:	31 f6                	xor    %esi,%esi
    return ps2_read(data, wait_infinite);
   14b73:	57                   	push   %edi
   14b74:	57                   	push   %edi
   14b75:	6a 00                	push   $0x0
   14b77:	8d 04 33             	lea    (%ebx,%esi,1),%eax
   14b7a:	50                   	push   %eax
   14b7b:	e8 be d0 ff ff       	call   11c3e <ps2_read>
    while (kbd_read(&result[i], false) && i < 2)
   14b80:	83 c4 10             	add    $0x10,%esp
   14b83:	89 f1                	mov    %esi,%ecx
   14b85:	80 f9 02             	cmp    $0x2,%cl
   14b88:	0f 95 c2             	setne  %dl
   14b8b:	46                   	inc    %esi
   14b8c:	84 c2                	test   %al,%dl
   14b8e:	75 e3                	jne    14b73 <kbd_setup+0x3b>
    {
        ++i;
    }
    if (result[0] != 0xfa || result[1] != 0xaa)
   14b90:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
   14b94:	0f b6 55 e6          	movzbl -0x1a(%ebp),%edx
   14b98:	3c fa                	cmp    $0xfa,%al
   14b9a:	75 05                	jne    14ba1 <kbd_setup+0x69>
   14b9c:	80 fa aa             	cmp    $0xaa,%dl
   14b9f:	74 0a                	je     14bab <kbd_setup+0x73>
    {
        printf("Reset Keyboard Failed: %x %x\n", result[0], result[1]);
   14ba1:	53                   	push   %ebx
   14ba2:	52                   	push   %edx
   14ba3:	50                   	push   %eax
   14ba4:	68 c4 92 01 00       	push   $0x192c4
   14ba9:	eb 2b                	jmp    14bd6 <kbd_setup+0x9e>
        goto Exit;
    }

    kbd_write(KBD_CMD_DISABLE, true);
   14bab:	b8 f5 00 00 00       	mov    $0xf5,%eax
   14bb0:	e8 6b ff ff ff       	call   14b20 <kbd_write.constprop.0.isra.0>
    return ps2_read(data, wait_infinite);
   14bb5:	51                   	push   %ecx
   14bb6:	51                   	push   %ecx
   14bb7:	6a 00                	push   $0x0
   14bb9:	53                   	push   %ebx
   14bba:	e8 7f d0 ff ff       	call   11c3e <ps2_read>
    while (kbd_read(result, false))
   14bbf:	83 c4 10             	add    $0x10,%esp
   14bc2:	84 c0                	test   %al,%al
   14bc4:	75 ef                	jne    14bb5 <kbd_setup+0x7d>
        ;

    if (result[0] != 0xfa)
   14bc6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
   14bca:	3c fa                	cmp    $0xfa,%al
   14bcc:	74 12                	je     14be0 <kbd_setup+0xa8>
    {
        printf("No Keyboard Connected! (KBD_CMD_DISABLE): %x\n", result[0]);
   14bce:	52                   	push   %edx
   14bcf:	52                   	push   %edx
   14bd0:	50                   	push   %eax
   14bd1:	68 96 92 01 00       	push   $0x19296
   14bd6:	e8 1f e3 ff ff       	call   12efa <printf>
        goto Exit;
   14bdb:	e9 33 02 00 00       	jmp    14e13 <kbd_setup+0x2db>
    }

    kbd_write(KBD_CMD_INDENTIFY, true);
   14be0:	b8 f2 00 00 00       	mov    $0xf2,%eax
   14be5:	e8 36 ff ff ff       	call   14b20 <kbd_write.constprop.0.isra.0>
    i = 0;
   14bea:	31 f6                	xor    %esi,%esi
    return ps2_read(data, wait_infinite);
   14bec:	50                   	push   %eax
   14bed:	50                   	push   %eax
   14bee:	6a 00                	push   $0x0
    while (kbd_read(&result[i], false))
   14bf0:	89 f0                	mov    %esi,%eax
   14bf2:	0f b6 c0             	movzbl %al,%eax
   14bf5:	01 d8                	add    %ebx,%eax
    return ps2_read(data, wait_infinite);
   14bf7:	50                   	push   %eax
   14bf8:	e8 41 d0 ff ff       	call   11c3e <ps2_read>
    while (kbd_read(&result[i], false))
   14bfd:	83 c4 10             	add    $0x10,%esp
   14c00:	84 c0                	test   %al,%al
   14c02:	74 03                	je     14c07 <kbd_setup+0xcf>
    {
        ++i;
   14c04:	46                   	inc    %esi
   14c05:	eb e5                	jmp    14bec <kbd_setup+0xb4>
    }
    if ((i == 1 || i == 3) && result[0] == 0xfa)
   14c07:	89 f0                	mov    %esi,%eax
   14c09:	83 e0 fd             	and    $0xfffffffd,%eax
   14c0c:	fe c8                	dec    %al
   14c0e:	75 5c                	jne    14c6c <kbd_setup+0x134>
   14c10:	80 7d e5 fa          	cmpb   $0xfa,-0x1b(%ebp)
   14c14:	75 56                	jne    14c6c <kbd_setup+0x134>
    {
        print_str("PS/2 keyboard type:");
   14c16:	83 ec 0c             	sub    $0xc,%esp
   14c19:	68 e2 92 01 00       	push   $0x192e2
   14c1e:	e8 90 e2 ff ff       	call   12eb3 <print_str>
        for (u8 j = 0; j < i; ++j)
   14c23:	83 c4 10             	add    $0x10,%esp
   14c26:	31 ff                	xor    %edi,%edi
   14c28:	89 f0                	mov    %esi,%eax
   14c2a:	89 f9                	mov    %edi,%ecx
   14c2c:	38 c8                	cmp    %cl,%al
   14c2e:	76 17                	jbe    14c47 <kbd_setup+0x10f>
        {
            printf(" %x", result[j]);
   14c30:	50                   	push   %eax
   14c31:	50                   	push   %eax
   14c32:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
   14c36:	50                   	push   %eax
   14c37:	68 f6 92 01 00       	push   $0x192f6
   14c3c:	e8 b9 e2 ff ff       	call   12efa <printf>
        for (u8 j = 0; j < i; ++j)
   14c41:	47                   	inc    %edi
   14c42:	83 c4 10             	add    $0x10,%esp
   14c45:	eb e1                	jmp    14c28 <kbd_setup+0xf0>
        }
        print_char('\n');
   14c47:	83 ec 0c             	sub    $0xc,%esp
   14c4a:	6a 0a                	push   $0xa
   14c4c:	e8 11 de ff ff       	call   12a62 <print_char>
        }
        print_char('\n');
        goto Exit;
    }

    kbd_write(KBD_CMD_SCANCODE, true);
   14c51:	b8 f0 00 00 00       	mov    $0xf0,%eax
   14c56:	e8 c5 fe ff ff       	call   14b20 <kbd_write.constprop.0.isra.0>
    kbd_write(2, true); // Set scan code set 2
   14c5b:	b8 02 00 00 00       	mov    $0x2,%eax
   14c60:	e8 bb fe ff ff       	call   14b20 <kbd_write.constprop.0.isra.0>
    i = 0;
    while (kbd_read(&result[i], false))
   14c65:	83 c4 10             	add    $0x10,%esp
    i = 0;
   14c68:	31 f6                	xor    %esi,%esi
    while (kbd_read(&result[i], false))
   14c6a:	eb 53                	jmp    14cbf <kbd_setup+0x187>
        print_str("No Keyboard Connected! (KBD_CMD_INDENTIFY)");
   14c6c:	83 ec 0c             	sub    $0xc,%esp
   14c6f:	68 fa 92 01 00       	push   $0x192fa
   14c74:	e8 3a e2 ff ff       	call   12eb3 <print_str>
        if (i)
   14c79:	83 c4 10             	add    $0x10,%esp
   14c7c:	89 f0                	mov    %esi,%eax
   14c7e:	84 c0                	test   %al,%al
   14c80:	75 0f                	jne    14c91 <kbd_setup+0x159>
        print_char('\n');
   14c82:	83 ec 0c             	sub    $0xc,%esp
   14c85:	6a 0a                	push   $0xa
   14c87:	e8 d6 dd ff ff       	call   12a62 <print_char>
        goto Exit;
   14c8c:	e9 82 01 00 00       	jmp    14e13 <kbd_setup+0x2db>
            print_char(':');
   14c91:	83 ec 0c             	sub    $0xc,%esp
   14c94:	6a 3a                	push   $0x3a
   14c96:	e8 c7 dd ff ff       	call   12a62 <print_char>
   14c9b:	83 c4 10             	add    $0x10,%esp
   14c9e:	31 ff                	xor    %edi,%edi
                printf("%x ", result[j]);
   14ca0:	50                   	push   %eax
   14ca1:	50                   	push   %eax
   14ca2:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
   14ca6:	50                   	push   %eax
   14ca7:	68 25 93 01 00       	push   $0x19325
   14cac:	e8 49 e2 ff ff       	call   12efa <printf>
            for (u8 j = 0; j < i; ++j)
   14cb1:	47                   	inc    %edi
   14cb2:	83 c4 10             	add    $0x10,%esp
   14cb5:	89 f0                	mov    %esi,%eax
   14cb7:	89 f9                	mov    %edi,%ecx
   14cb9:	38 c8                	cmp    %cl,%al
   14cbb:	77 e3                	ja     14ca0 <kbd_setup+0x168>
   14cbd:	eb c3                	jmp    14c82 <kbd_setup+0x14a>
    return ps2_read(data, wait_infinite);
   14cbf:	50                   	push   %eax
   14cc0:	50                   	push   %eax
   14cc1:	6a 00                	push   $0x0
    while (kbd_read(&result[i], false))
   14cc3:	89 f0                	mov    %esi,%eax
   14cc5:	0f b6 c0             	movzbl %al,%eax
   14cc8:	01 d8                	add    %ebx,%eax
    return ps2_read(data, wait_infinite);
   14cca:	50                   	push   %eax
   14ccb:	e8 6e cf ff ff       	call   11c3e <ps2_read>
    while (kbd_read(&result[i], false))
   14cd0:	83 c4 10             	add    $0x10,%esp
   14cd3:	84 c0                	test   %al,%al
   14cd5:	74 03                	je     14cda <kbd_setup+0x1a2>
    {
        ++i;
   14cd7:	46                   	inc    %esi
   14cd8:	eb e5                	jmp    14cbf <kbd_setup+0x187>
    }
    if (i != 2 || result[0] != 0xfa || result[1] != 0xfa)
   14cda:	89 f0                	mov    %esi,%eax
   14cdc:	3c 02                	cmp    $0x2,%al
   14cde:	75 0c                	jne    14cec <kbd_setup+0x1b4>
   14ce0:	80 7d e5 fa          	cmpb   $0xfa,-0x1b(%ebp)
   14ce4:	75 06                	jne    14cec <kbd_setup+0x1b4>
   14ce6:	80 7d e6 fa          	cmpb   $0xfa,-0x1a(%ebp)
   14cea:	74 47                	je     14d33 <kbd_setup+0x1fb>
    {
        print_str("Set Keyboard Typematic failed!");
   14cec:	83 ec 0c             	sub    $0xc,%esp
   14cef:	68 29 93 01 00       	push   $0x19329
   14cf4:	e8 ba e1 ff ff       	call   12eb3 <print_str>
        if (i)
   14cf9:	83 c4 10             	add    $0x10,%esp
   14cfc:	89 f0                	mov    %esi,%eax
   14cfe:	84 c0                	test   %al,%al
   14d00:	74 80                	je     14c82 <kbd_setup+0x14a>
        {
            print_char(':');
   14d02:	83 ec 0c             	sub    $0xc,%esp
   14d05:	6a 3a                	push   $0x3a
   14d07:	e8 56 dd ff ff       	call   12a62 <print_char>
   14d0c:	83 c4 10             	add    $0x10,%esp
   14d0f:	31 ff                	xor    %edi,%edi
            for (u8 j = 0; j < i; ++j)
            {
                printf("%x ", result[j]);
   14d11:	50                   	push   %eax
   14d12:	50                   	push   %eax
   14d13:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
   14d17:	50                   	push   %eax
   14d18:	68 25 93 01 00       	push   $0x19325
   14d1d:	e8 d8 e1 ff ff       	call   12efa <printf>
            for (u8 j = 0; j < i; ++j)
   14d22:	47                   	inc    %edi
   14d23:	83 c4 10             	add    $0x10,%esp
   14d26:	89 f0                	mov    %esi,%eax
   14d28:	89 f9                	mov    %edi,%ecx
   14d2a:	38 c8                	cmp    %cl,%al
   14d2c:	77 e3                	ja     14d11 <kbd_setup+0x1d9>
   14d2e:	e9 4f ff ff ff       	jmp    14c82 <kbd_setup+0x14a>
        }
        print_char('\n');
        goto Exit;
    }

    kbd_write(KBD_CMD_TYPEMATIC, true);
   14d33:	b8 f3 00 00 00       	mov    $0xf3,%eax
   14d38:	e8 e3 fd ff ff       	call   14b20 <kbd_write.constprop.0.isra.0>
    kbd_write(0, true); // Repeat rate: 30Hz, Delay before keys repeat: 250ms
   14d3d:	31 c0                	xor    %eax,%eax
   14d3f:	e8 dc fd ff ff       	call   14b20 <kbd_write.constprop.0.isra.0>
    i = 0;
   14d44:	31 f6                	xor    %esi,%esi
    return ps2_read(data, wait_infinite);
   14d46:	57                   	push   %edi
   14d47:	57                   	push   %edi
   14d48:	6a 00                	push   $0x0
    while (kbd_read(&result[i], false))
   14d4a:	89 f0                	mov    %esi,%eax
   14d4c:	0f b6 c0             	movzbl %al,%eax
   14d4f:	01 d8                	add    %ebx,%eax
    return ps2_read(data, wait_infinite);
   14d51:	50                   	push   %eax
   14d52:	e8 e7 ce ff ff       	call   11c3e <ps2_read>
    while (kbd_read(&result[i], false))
   14d57:	83 c4 10             	add    $0x10,%esp
   14d5a:	84 c0                	test   %al,%al
   14d5c:	74 03                	je     14d61 <kbd_setup+0x229>
    {
        ++i;
   14d5e:	46                   	inc    %esi
   14d5f:	eb e5                	jmp    14d46 <kbd_setup+0x20e>
    }
    if (i != 2 || result[0] != 0xfa || result[1] != 0xfa)
   14d61:	89 f0                	mov    %esi,%eax
   14d63:	3c 02                	cmp    $0x2,%al
   14d65:	75 0c                	jne    14d73 <kbd_setup+0x23b>
   14d67:	80 7d e5 fa          	cmpb   $0xfa,-0x1b(%ebp)
   14d6b:	75 06                	jne    14d73 <kbd_setup+0x23b>
   14d6d:	80 7d e6 fa          	cmpb   $0xfa,-0x1a(%ebp)
   14d71:	74 4b                	je     14dbe <kbd_setup+0x286>
    {
        print_str("Set Keyboard Typematic failed!");
   14d73:	83 ec 0c             	sub    $0xc,%esp
   14d76:	68 29 93 01 00       	push   $0x19329
   14d7b:	e8 33 e1 ff ff       	call   12eb3 <print_str>
        if (i)
   14d80:	83 c4 10             	add    $0x10,%esp
   14d83:	89 f0                	mov    %esi,%eax
   14d85:	84 c0                	test   %al,%al
   14d87:	0f 84 f5 fe ff ff    	je     14c82 <kbd_setup+0x14a>
        {
            print_char(':');
   14d8d:	83 ec 0c             	sub    $0xc,%esp
   14d90:	6a 3a                	push   $0x3a
   14d92:	e8 cb dc ff ff       	call   12a62 <print_char>
   14d97:	83 c4 10             	add    $0x10,%esp
   14d9a:	31 ff                	xor    %edi,%edi
            for (u8 j = 0; j < i; ++j)
            {
                printf("%x ", result[j]);
   14d9c:	51                   	push   %ecx
   14d9d:	51                   	push   %ecx
   14d9e:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
   14da2:	50                   	push   %eax
   14da3:	68 25 93 01 00       	push   $0x19325
   14da8:	e8 4d e1 ff ff       	call   12efa <printf>
            for (u8 j = 0; j < i; ++j)
   14dad:	47                   	inc    %edi
   14dae:	83 c4 10             	add    $0x10,%esp
   14db1:	89 f0                	mov    %esi,%eax
   14db3:	89 fa                	mov    %edi,%edx
   14db5:	38 d0                	cmp    %dl,%al
   14db7:	77 e3                	ja     14d9c <kbd_setup+0x264>
   14db9:	e9 c4 fe ff ff       	jmp    14c82 <kbd_setup+0x14a>
        }
        print_char('\n');
        goto Exit;
    }

    kbd_write(KBD_CMD_ENABLE, true);
   14dbe:	b8 f4 00 00 00       	mov    $0xf4,%eax
   14dc3:	e8 58 fd ff ff       	call   14b20 <kbd_write.constprop.0.isra.0>
    return ps2_read(data, wait_infinite);
   14dc8:	52                   	push   %edx
   14dc9:	52                   	push   %edx
   14dca:	6a 00                	push   $0x0
   14dcc:	53                   	push   %ebx
   14dcd:	e8 6c ce ff ff       	call   11c3e <ps2_read>
    if (!kbd_read(result, false) || (result[0] != 0xfa && result[0] != 0xfe))
   14dd2:	83 c4 10             	add    $0x10,%esp
   14dd5:	84 c0                	test   %al,%al
   14dd7:	74 0a                	je     14de3 <kbd_setup+0x2ab>
   14dd9:	8a 45 e5             	mov    -0x1b(%ebp),%al
   14ddc:	83 e0 fb             	and    $0xfffffffb,%eax
   14ddf:	3c fa                	cmp    $0xfa,%al
   14de1:	74 0f                	je     14df2 <kbd_setup+0x2ba>
    {
        print_str("Enable Keyboard function failed!\n");
   14de3:	83 ec 0c             	sub    $0xc,%esp
   14de6:	68 48 93 01 00       	push   $0x19348
   14deb:	e8 c3 e0 ff ff       	call   12eb3 <print_str>
        goto Exit;
   14df0:	eb 21                	jmp    14e13 <kbd_setup+0x2db>
    }

    pic_irq_set_entry(PS2_IRQ1, _irq_handler);
   14df2:	50                   	push   %eax
   14df3:	50                   	push   %eax
   14df4:	68 64 49 01 00       	push   $0x14964
   14df9:	6a 01                	push   $0x1
   14dfb:	e8 dc 0e 00 00       	call   15cdc <pic_irq_set_entry>
    pic_irq_enable(PS2_IRQ1);
   14e00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
   14e07:	e8 81 0e 00 00       	call   15c8d <pic_irq_enable>

    _kbd_avaliable = true;
   14e0c:	c6 05 e0 bf 01 00 01 	movb   $0x1,0x1bfe0
   14e13:	83 c4 10             	add    $0x10,%esp
Exit:
    return _kbd_avaliable;
}
   14e16:	a0 e0 bf 01 00       	mov    0x1bfe0,%al
   14e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
   14e1e:	5b                   	pop    %ebx
   14e1f:	5e                   	pop    %esi
   14e20:	5f                   	pop    %edi
   14e21:	5d                   	pop    %ebp
   14e22:	c3                   	ret    

00014e23 <kbd_get_key>:

bool kbd_get_key(struct kbd_key_packet *key)
{
   14e23:	55                   	push   %ebp
   14e24:	89 e5                	mov    %esp,%ebp
   14e26:	56                   	push   %esi
   14e27:	53                   	push   %ebx
    if (!_kbd_avaliable)
   14e28:	8a 1d e0 bf 01 00    	mov    0x1bfe0,%bl
   14e2e:	84 db                	test   %bl,%bl
   14e30:	74 5a                	je     14e8c <kbd_get_key+0x69>
        return false;
    // u32 save_eflags = read_eflags();
    // disable();
    pic_irq_disable(PS2_IRQ1);
   14e32:	83 ec 0c             	sub    $0xc,%esp
   14e35:	6a 01                	push   $0x1
   14e37:	e8 7f 0e 00 00       	call   15cbb <pic_irq_disable>
    if (_kbd_buf_size == 0)
   14e3c:	a0 c1 be 01 00       	mov    0x1bec1,%al
   14e41:	83 c4 10             	add    $0x10,%esp
   14e44:	84 c0                	test   %al,%al
   14e46:	74 35                	je     14e7d <kbd_get_key+0x5a>
    key->key = _kbd_buf[_kbd_buf_oldest].key;
   14e48:	0f b6 0d c0 be 01 00 	movzbl 0x1bec0,%ecx
   14e4f:	89 ca                	mov    %ecx,%edx
   14e51:	66 8b b4 09 e0 be 01 	mov    0x1bee0(%ecx,%ecx,1),%si
   14e58:	00 
   14e59:	8b 4d 08             	mov    0x8(%ebp),%ecx
   14e5c:	66 89 31             	mov    %si,(%ecx)
    --_kbd_buf_size;
   14e5f:	48                   	dec    %eax
   14e60:	a2 c1 be 01 00       	mov    %al,0x1bec1
    if (++_kbd_buf_oldest == 128)
   14e65:	8d 42 01             	lea    0x1(%edx),%eax
   14e68:	80 fa 7f             	cmp    $0x7f,%dl
   14e6b:	74 07                	je     14e74 <kbd_get_key+0x51>
   14e6d:	a2 c0 be 01 00       	mov    %al,0x1bec0
   14e72:	eb 0b                	jmp    14e7f <kbd_get_key+0x5c>
        _kbd_buf_oldest = 0;
   14e74:	c6 05 c0 be 01 00 00 	movb   $0x0,0x1bec0
   14e7b:	eb 02                	jmp    14e7f <kbd_get_key+0x5c>
        return false;
   14e7d:	31 db                	xor    %ebx,%ebx
    bool ret = pop_key(key);
    // write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
    pic_irq_enable(PS2_IRQ1);
   14e7f:	83 ec 0c             	sub    $0xc,%esp
   14e82:	6a 01                	push   $0x1
   14e84:	e8 04 0e 00 00       	call   15c8d <pic_irq_enable>
    return ret;
   14e89:	83 c4 10             	add    $0x10,%esp
}
   14e8c:	88 d8                	mov    %bl,%al
   14e8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
   14e91:	5b                   	pop    %ebx
   14e92:	5e                   	pop    %esi
   14e93:	5d                   	pop    %ebp
   14e94:	c3                   	ret    

00014e95 <delay_ms>:
#include "cpu.h"
#include "io.h"
#include "pit.h"

void delay_ms(u32 ms)
{
   14e95:	55                   	push   %ebp
   14e96:	89 e5                	mov    %esp,%ebp
   14e98:	56                   	push   %esi
   14e99:	53                   	push   %ebx
	__asm__ __volatile__("pushfl\n\t"
   14e9a:	9c                   	pushf  
   14e9b:	5b                   	pop    %ebx
	__asm__ __volatile__("sti\n" ::
   14e9c:	fb                   	sti    
		} while(i);
	}
	*/
	u32 save_eflags = read_eflags();
	enable();
	for (u32 end = pit_get_ticks() + ms; pit_get_ticks() < end;)
   14e9d:	e8 d2 0e 00 00       	call   15d74 <pit_get_ticks>
   14ea2:	03 45 08             	add    0x8(%ebp),%eax
   14ea5:	89 c6                	mov    %eax,%esi
   14ea7:	e8 c8 0e 00 00       	call   15d74 <pit_get_ticks>
   14eac:	39 f0                	cmp    %esi,%eax
   14eae:	72 f7                	jb     14ea7 <delay_ms+0x12>
	__asm__ __volatile__("pushfl\n\t"
   14eb0:	9c                   	pushf  
   14eb1:	58                   	pop    %eax
		;
	write_eflags(read_eflags() & (save_eflags & EFLAGS_IF));
   14eb2:	21 c3                	and    %eax,%ebx
   14eb4:	81 e3 00 02 00 00    	and    $0x200,%ebx
	__asm__ __volatile__("pushl %0\n\t"
   14eba:	53                   	push   %ebx
   14ebb:	9d                   	popf   
}
   14ebc:	5b                   	pop    %ebx
   14ebd:	5e                   	pop    %esi
   14ebe:	5d                   	pop    %ebp
   14ebf:	c3                   	ret    

00014ec0 <checksum_add>:

u8 checksum_add(const void *p, u32 len)
{
   14ec0:	55                   	push   %ebp
   14ec1:	89 e5                	mov    %esp,%ebp
   14ec3:	8b 4d 08             	mov    0x8(%ebp),%ecx
   14ec6:	8b 55 0c             	mov    0xc(%ebp),%edx
	u8 sum = 0;
   14ec9:	31 c0                	xor    %eax,%eax
	while (len--)
   14ecb:	83 ea 01             	sub    $0x1,%edx
   14ece:	72 05                	jb     14ed5 <checksum_add+0x15>
	{
		sum += ((const u8 *)p)[len];
   14ed0:	02 04 11             	add    (%ecx,%edx,1),%al
   14ed3:	eb f6                	jmp    14ecb <checksum_add+0xb>
	}
	return sum;
}
   14ed5:	5d                   	pop    %ebp
   14ed6:	c3                   	ret    

00014ed7 <init_list>:
#include "list.h"

void init_list(struct list_entry *head)
{
   14ed7:	55                   	push   %ebp
   14ed8:	89 e5                	mov    %esp,%ebp
   14eda:	8b 45 08             	mov    0x8(%ebp),%eax
    head->prev = head;
   14edd:	89 00                	mov    %eax,(%eax)
    head->next = head;
   14edf:	89 40 04             	mov    %eax,0x4(%eax)
}
   14ee2:	5d                   	pop    %ebp
   14ee3:	c3                   	ret    

00014ee4 <list_empty>:

bool list_empty(const struct list_entry *head)
{
   14ee4:	55                   	push   %ebp
   14ee5:	89 e5                	mov    %esp,%ebp
   14ee7:	8b 45 08             	mov    0x8(%ebp),%eax
    return head->next == head;
   14eea:	39 40 04             	cmp    %eax,0x4(%eax)
   14eed:	0f 94 c0             	sete   %al
}
   14ef0:	5d                   	pop    %ebp
   14ef1:	c3                   	ret    

00014ef2 <insert_head>:

void insert_head(struct list_entry *head, struct list_entry *entry)
{
   14ef2:	55                   	push   %ebp
   14ef3:	89 e5                	mov    %esp,%ebp
   14ef5:	8b 45 08             	mov    0x8(%ebp),%eax
   14ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
    entry->next = head->next;
   14efb:	8b 48 04             	mov    0x4(%eax),%ecx
   14efe:	89 4a 04             	mov    %ecx,0x4(%edx)
    entry->prev = head;
   14f01:	89 02                	mov    %eax,(%edx)
    head->next = entry;
   14f03:	89 50 04             	mov    %edx,0x4(%eax)
}
   14f06:	5d                   	pop    %ebp
   14f07:	c3                   	ret    

00014f08 <insert_tail>:

void insert_tail(struct list_entry *head, struct list_entry *entry)
{
   14f08:	55                   	push   %ebp
   14f09:	89 e5                	mov    %esp,%ebp
   14f0b:	8b 45 08             	mov    0x8(%ebp),%eax
   14f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
    entry->prev = head->prev;
   14f11:	8b 08                	mov    (%eax),%ecx
   14f13:	89 0a                	mov    %ecx,(%edx)
    entry->next = head;
   14f15:	89 42 04             	mov    %eax,0x4(%edx)
    head->prev = entry;
   14f18:	89 10                	mov    %edx,(%eax)
}
   14f1a:	5d                   	pop    %ebp
   14f1b:	c3                   	ret    

00014f1c <remove_head>:

struct list_entry *remove_head(struct list_entry *head)
{
   14f1c:	55                   	push   %ebp
   14f1d:	89 e5                	mov    %esp,%ebp
   14f1f:	8b 55 08             	mov    0x8(%ebp),%edx
    // if(list_empty(head)) return head;

    struct list_entry *entry = head->next;
   14f22:	8b 42 04             	mov    0x4(%edx),%eax
    head->next = entry->next;
   14f25:	8b 48 04             	mov    0x4(%eax),%ecx
   14f28:	89 4a 04             	mov    %ecx,0x4(%edx)
    head->next->prev = head;
   14f2b:	89 11                	mov    %edx,(%ecx)
    return entry;
}
   14f2d:	5d                   	pop    %ebp
   14f2e:	c3                   	ret    

00014f2f <remove_tail>:

struct list_entry *remove_tail(struct list_entry *head)
{
   14f2f:	55                   	push   %ebp
   14f30:	89 e5                	mov    %esp,%ebp
   14f32:	8b 55 08             	mov    0x8(%ebp),%edx
    struct list_entry *entry = head->prev;
   14f35:	8b 02                	mov    (%edx),%eax
    head->prev = entry->prev;
   14f37:	8b 08                	mov    (%eax),%ecx
   14f39:	89 0a                	mov    %ecx,(%edx)
    head->prev->next = head;
   14f3b:	89 51 04             	mov    %edx,0x4(%ecx)
    return entry;
}
   14f3e:	5d                   	pop    %ebp
   14f3f:	c3                   	ret    

00014f40 <remove_entry>:

void remove_entry(struct list_entry *entry)
{
   14f40:	55                   	push   %ebp
   14f41:	89 e5                	mov    %esp,%ebp
    remove_head(entry->prev);
   14f43:	8b 45 08             	mov    0x8(%ebp),%eax
   14f46:	8b 00                	mov    (%eax),%eax
   14f48:	89 45 08             	mov    %eax,0x8(%ebp)

    // struct list_entry *tmp_head = entry->prev;
    // tmp->prev = entry->prev;
    // entry->prev->next = tmp;
}
   14f4b:	5d                   	pop    %ebp
    remove_head(entry->prev);
   14f4c:	eb ce                	jmp    14f1c <remove_head>

00014f4e <mem_dumpinfo>:
// static u8 _bitmap_buf[131040];
static u8 _bitmap_buf[8192]; // 4-Mbyte to 260-Mbyte - 256 * 1024 * 1024 / 4096 / 8 = 8192
static struct bitmap _mem_bitmap;

void mem_dumpinfo(void)
{
   14f4e:	55                   	push   %ebp
   14f4f:	89 e5                	mov    %esp,%ebp
   14f51:	53                   	push   %ebx
   14f52:	83 ec 10             	sub    $0x10,%esp
    printf("\nbitmap_buf=0x%x, mem_bitmap=0x%x\n"
   14f55:	68 00 c0 01 00       	push   $0x1c000
   14f5a:	e8 f2 d2 ff ff       	call   12251 <bitmap_clear_count>
   14f5f:	89 c3                	mov    %eax,%ebx
   14f61:	c7 04 24 00 c0 01 00 	movl   $0x1c000,(%esp)
   14f68:	e8 d9 d2 ff ff       	call   12246 <bitmap_size>
   14f6d:	5a                   	pop    %edx
   14f6e:	59                   	pop    %ecx
   14f6f:	53                   	push   %ebx
   14f70:	50                   	push   %eax
   14f71:	ff 35 00 c0 01 00    	push   0x1c000
   14f77:	68 00 c0 01 00       	push   $0x1c000
   14f7c:	68 20 c0 01 00       	push   $0x1c020
   14f81:	68 a0 94 01 00       	push   $0x194a0
   14f86:	e8 6f df ff ff       	call   12efa <printf>
           "mem_bitmap.data=0x%x, size=%d, clear_count=%d\n",
           _bitmap_buf, &_mem_bitmap,
           _mem_bitmap.data, bitmap_size(&_mem_bitmap), bitmap_clear_count(&_mem_bitmap));
}
   14f8b:	83 c4 20             	add    $0x20,%esp
   14f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   14f91:	c9                   	leave  
   14f92:	c3                   	ret    

00014f93 <mem_setup>:

void mem_setup(const struct e820_entry *ards_buf)
{
   14f93:	55                   	push   %ebp
   14f94:	89 e5                	mov    %esp,%ebp
   14f96:	57                   	push   %edi
   14f97:	56                   	push   %esi
   14f98:	53                   	push   %ebx
   14f99:	83 ec 10             	sub    $0x10,%esp
   14f9c:	8b 7d 08             	mov    0x8(%ebp),%edi
    u32 last_end = MEM_PHY_MIN;

    bitmap_init(&_mem_bitmap, _bitmap_buf, sizeof(_bitmap_buf));
   14f9f:	68 00 20 00 00       	push   $0x2000
   14fa4:	68 20 c0 01 00       	push   $0x1c020
   14fa9:	68 00 c0 01 00       	push   $0x1c000
   14fae:	e8 2a cf ff ff       	call   11edd <bitmap_init>

    for (const struct e820_entry *ptr = ards_buf; ptr->Type; ++ptr)
   14fb3:	83 c4 10             	add    $0x10,%esp
    u32 last_end = MEM_PHY_MIN;
   14fb6:	b8 00 00 50 00       	mov    $0x500000,%eax
    for (const struct e820_entry *ptr = ards_buf; ptr->Type; ++ptr)
   14fbb:	8b 57 10             	mov    0x10(%edi),%edx
   14fbe:	85 d2                	test   %edx,%edx
   14fc0:	0f 84 b9 00 00 00    	je     1507f <mem_setup+0xec>
    {
        if (ptr->Type == 1)
   14fc6:	4a                   	dec    %edx
   14fc7:	0f 85 aa 00 00 00    	jne    15077 <mem_setup+0xe4>
        {
            u32 base, len;
            if (ptr->BaseAddrHi)
   14fcd:	83 7f 04 00          	cmpl   $0x0,0x4(%edi)
   14fd1:	75 5e                	jne    15031 <mem_setup+0x9e>
            {
                base = MEM_PHY_MAX;
                len = 0;
            }
            else if (ptr->LengthHi)
   14fd3:	8b 77 0c             	mov    0xc(%edi),%esi
   14fd6:	85 f6                	test   %esi,%esi
   14fd8:	75 5b                	jne    15035 <mem_setup+0xa2>
                base = MEM_PHY_MIN;
                len = MEM_PHY_MAX - MEM_PHY_MIN;
            }
            else
            {
                base = (ptr->BaseAddrLow + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1); // 向上取整
   14fda:	8b 0f                	mov    (%edi),%ecx
   14fdc:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
   14fe2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
                len = ptr->LengthLow & ~(PAGE_SIZE - 1);                      // 向下取整
   14fe8:	8b 57 08             	mov    0x8(%edi),%edx
   14feb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx

                if (base <= MEM_PHY_MIN)
   14ff1:	81 fb 00 00 50 00    	cmp    $0x500000,%ebx
   14ff7:	77 21                	ja     1501a <mem_setup+0x87>
                {
                    if (len > MEM_PHY_MIN - base)
   14ff9:	b9 00 00 50 00       	mov    $0x500000,%ecx
   14ffe:	29 d9                	sub    %ebx,%ecx
   15000:	39 d1                	cmp    %edx,%ecx
   15002:	73 73                	jae    15077 <mem_setup+0xe4>
                    {
                        len -= MEM_PHY_MIN - base;
   15004:	8d b4 13 00 00 b0 ff 	lea    -0x500000(%ebx,%edx,1),%esi
   1500b:	81 fe 00 00 50 10    	cmp    $0x10500000,%esi
   15011:	76 27                	jbe    1503a <mem_setup+0xa7>
   15013:	be 00 00 50 10       	mov    $0x10500000,%esi
   15018:	eb 20                	jmp    1503a <mem_setup+0xa7>
                            len = MEM_PHY_MAX;
                    }
                    else
                        continue;
                }
                else if (base >= MEM_PHY_MAX)
   1501a:	81 fb ff ff 4f 10    	cmp    $0x104fffff,%ebx
   15020:	77 1f                	ja     15041 <mem_setup+0xae>
                {
                    base = MEM_PHY_MAX;
                    len = 0;
                }
                else if (len > MEM_PHY_MAX - base)
   15022:	be 00 00 50 10       	mov    $0x10500000,%esi
   15027:	29 de                	sub    %ebx,%esi
   15029:	39 d6                	cmp    %edx,%esi
   1502b:	76 19                	jbe    15046 <mem_setup+0xb3>
   1502d:	89 d6                	mov    %edx,%esi
   1502f:	eb 15                	jmp    15046 <mem_setup+0xb3>
                len = 0;
   15031:	31 f6                	xor    %esi,%esi
   15033:	eb 0c                	jmp    15041 <mem_setup+0xae>
                len = MEM_PHY_MAX - MEM_PHY_MIN;
   15035:	be 00 00 00 10       	mov    $0x10000000,%esi
                base = MEM_PHY_MIN;
   1503a:	bb 00 00 50 00       	mov    $0x500000,%ebx
   1503f:	eb 05                	jmp    15046 <mem_setup+0xb3>
                base = MEM_PHY_MAX;
   15041:	bb 00 00 50 10       	mov    $0x10500000,%ebx
                {
                    len = MEM_PHY_MAX - base;
                }
            }

            if (last_end == base)
   15046:	39 d8                	cmp    %ebx,%eax
   15048:	75 04                	jne    1504e <mem_setup+0xbb>
            {
                last_end += len;
   1504a:	01 f0                	add    %esi,%eax
   1504c:	eb 22                	jmp    15070 <mem_setup+0xdd>
            }
            else
            {
                // last_end 至 base 需要屏蔽
                u32 idx = last_end / PAGE_SIZE - 256, count = (base - last_end) / PAGE_SIZE;
                bitmap_set(&_mem_bitmap, idx, count);
   1504e:	51                   	push   %ecx
                u32 idx = last_end / PAGE_SIZE - 256, count = (base - last_end) / PAGE_SIZE;
   1504f:	89 da                	mov    %ebx,%edx
   15051:	29 c2                	sub    %eax,%edx
   15053:	c1 ea 0c             	shr    $0xc,%edx
                bitmap_set(&_mem_bitmap, idx, count);
   15056:	52                   	push   %edx
                u32 idx = last_end / PAGE_SIZE - 256, count = (base - last_end) / PAGE_SIZE;
   15057:	c1 e8 0c             	shr    $0xc,%eax
   1505a:	2d 00 01 00 00       	sub    $0x100,%eax
                bitmap_set(&_mem_bitmap, idx, count);
   1505f:	50                   	push   %eax
   15060:	68 00 c0 01 00       	push   $0x1c000
   15065:	e8 a1 ce ff ff       	call   11f0b <bitmap_set>
                last_end = base + len;
   1506a:	8d 04 33             	lea    (%ebx,%esi,1),%eax
   1506d:	83 c4 10             	add    $0x10,%esp
            }

            if (last_end == MEM_PHY_MAX)
   15070:	3d 00 00 50 10       	cmp    $0x10500000,%eax
   15075:	74 31                	je     150a8 <mem_setup+0x115>
    for (const struct e820_entry *ptr = ards_buf; ptr->Type; ++ptr)
   15077:	83 c7 14             	add    $0x14,%edi
   1507a:	e9 3c ff ff ff       	jmp    14fbb <mem_setup+0x28>
                break;
        }
    }

    if (last_end != MEM_PHY_MAX)
   1507f:	3d 00 00 50 10       	cmp    $0x10500000,%eax
   15084:	74 22                	je     150a8 <mem_setup+0x115>
    {
        u32 idx = last_end / PAGE_SIZE - 256, count = (MEM_PHY_MAX - last_end) / PAGE_SIZE;
        bitmap_set(&_mem_bitmap, idx, count);
   15086:	52                   	push   %edx
        u32 idx = last_end / PAGE_SIZE - 256, count = (MEM_PHY_MAX - last_end) / PAGE_SIZE;
   15087:	ba 00 00 50 10       	mov    $0x10500000,%edx
   1508c:	29 c2                	sub    %eax,%edx
   1508e:	c1 ea 0c             	shr    $0xc,%edx
        bitmap_set(&_mem_bitmap, idx, count);
   15091:	52                   	push   %edx
        u32 idx = last_end / PAGE_SIZE - 256, count = (MEM_PHY_MAX - last_end) / PAGE_SIZE;
   15092:	c1 e8 0c             	shr    $0xc,%eax
   15095:	2d 00 01 00 00       	sub    $0x100,%eax
        bitmap_set(&_mem_bitmap, idx, count);
   1509a:	50                   	push   %eax
   1509b:	68 00 c0 01 00       	push   $0x1c000
   150a0:	e8 66 ce ff ff       	call   11f0b <bitmap_set>
   150a5:	83 c4 10             	add    $0x10,%esp
    }
}
   150a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
   150ab:	5b                   	pop    %ebx
   150ac:	5e                   	pop    %esi
   150ad:	5f                   	pop    %edi
   150ae:	5d                   	pop    %ebp
   150af:	c3                   	ret    

000150b0 <alloc_phy_mem>:
//     }
//     return false;
// }

u32 alloc_phy_mem(u32 count, u32 *allocated, enum phy_mem_type type)
{
   150b0:	55                   	push   %ebp
   150b1:	89 e5                	mov    %esp,%ebp
   150b3:	57                   	push   %edi
   150b4:	56                   	push   %esi
   150b5:	53                   	push   %ebx
   150b6:	83 ec 18             	sub    $0x18,%esp
   150b9:	8b 75 08             	mov    0x8(%ebp),%esi
   150bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
    // u32 base = type == dma_phy_mem?MEM_PHY_DMA_MIN:MEM_PHY_NORMAL_MIN;
    u32 clear_idx = type == dma_phy_mem ? 0 : 1024, set_idx;
   150bf:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
   150c3:	19 db                	sbb    %ebx,%ebx
   150c5:	f7 d3                	not    %ebx
   150c7:	81 e3 00 04 00 00    	and    $0x400,%ebx

    do
    {
        if (bitmap_clear_count(&_mem_bitmap) < count)
   150cd:	68 00 c0 01 00       	push   $0x1c000
   150d2:	e8 7a d1 ff ff       	call   12251 <bitmap_clear_count>
   150d7:	83 c4 10             	add    $0x10,%esp
   150da:	39 f0                	cmp    %esi,%eax
   150dc:	72 70                	jb     1514e <alloc_phy_mem+0x9e>
            break;
        clear_idx = bitmap_find_clear(&_mem_bitmap, clear_idx);
   150de:	51                   	push   %ecx
   150df:	51                   	push   %ecx
   150e0:	53                   	push   %ebx
   150e1:	68 00 c0 01 00       	push   $0x1c000
   150e6:	e8 71 d1 ff ff       	call   1225c <bitmap_find_clear>
   150eb:	89 c3                	mov    %eax,%ebx
        if (clear_idx == (u32)-1)
   150ed:	83 c4 10             	add    $0x10,%esp
   150f0:	83 f8 ff             	cmp    $0xffffffff,%eax
   150f3:	74 59                	je     1514e <alloc_phy_mem+0x9e>
            break;
        set_idx = bitmap_find_set(&_mem_bitmap, clear_idx + 1);
   150f5:	52                   	push   %edx
   150f6:	52                   	push   %edx
   150f7:	8d 40 01             	lea    0x1(%eax),%eax
   150fa:	50                   	push   %eax
   150fb:	68 00 c0 01 00       	push   $0x1c000
   15100:	e8 af d1 ff ff       	call   122b4 <bitmap_find_set>
        if (set_idx == (u32)-1)
   15105:	83 c4 10             	add    $0x10,%esp
   15108:	83 f8 ff             	cmp    $0xffffffff,%eax
   1510b:	75 10                	jne    1511d <alloc_phy_mem+0x6d>
            set_idx = bitmap_size(&_mem_bitmap);
   1510d:	83 ec 0c             	sub    $0xc,%esp
   15110:	68 00 c0 01 00       	push   $0x1c000
   15115:	e8 2c d1 ff ff       	call   12246 <bitmap_size>
   1511a:	83 c4 10             	add    $0x10,%esp
        *allocated = MIN(set_idx - clear_idx, count);
   1511d:	29 d8                	sub    %ebx,%eax
   1511f:	89 c2                	mov    %eax,%edx
   15121:	39 f0                	cmp    %esi,%eax
   15123:	76 02                	jbe    15127 <alloc_phy_mem+0x77>
   15125:	89 f2                	mov    %esi,%edx
   15127:	89 17                	mov    %edx,(%edi)
        if (type == dma_phy_mem && *allocated != count)
   15129:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
   1512d:	75 04                	jne    15133 <alloc_phy_mem+0x83>
   1512f:	39 f0                	cmp    %esi,%eax
   15131:	72 1b                	jb     1514e <alloc_phy_mem+0x9e>
            break;
        bitmap_set(&_mem_bitmap, clear_idx, *allocated);
   15133:	50                   	push   %eax
   15134:	52                   	push   %edx
   15135:	53                   	push   %ebx
   15136:	68 00 c0 01 00       	push   $0x1c000
   1513b:	e8 cb cd ff ff       	call   11f0b <bitmap_set>
        return MEM_PHY_MIN + PAGE_SIZE * clear_idx;
   15140:	8d 83 00 05 00 00    	lea    0x500(%ebx),%eax
   15146:	c1 e0 0c             	shl    $0xc,%eax
   15149:	83 c4 10             	add    $0x10,%esp
   1514c:	eb 08                	jmp    15156 <alloc_phy_mem+0xa6>
    } while (false);

    *allocated = 0;
   1514e:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    return 0;
   15154:	31 c0                	xor    %eax,%eax
}
   15156:	8d 65 f4             	lea    -0xc(%ebp),%esp
   15159:	5b                   	pop    %ebx
   1515a:	5e                   	pop    %esi
   1515b:	5f                   	pop    %edi
   1515c:	5d                   	pop    %ebp
   1515d:	c3                   	ret    

0001515e <free_phy_mem>:

void free_phy_mem(u32 paddr, u32 count)
{
   1515e:	55                   	push   %ebp
   1515f:	89 e5                	mov    %esp,%ebp
   15161:	53                   	push   %ebx
   15162:	51                   	push   %ecx
   15163:	8b 4d 08             	mov    0x8(%ebp),%ecx
   15166:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (paddr < MEM_PHY_MIN || paddr >= MEM_PHY_MAX)
   15169:	8d 81 00 00 b0 ff    	lea    -0x500000(%ecx),%eax
   1516f:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
   15174:	77 32                	ja     151a8 <free_phy_mem+0x4a>
        return;
    if (paddr + PAGE_SIZE * count > MEM_PHY_MAX)
   15176:	89 da                	mov    %ebx,%edx
   15178:	c1 e2 0c             	shl    $0xc,%edx
   1517b:	01 ca                	add    %ecx,%edx
   1517d:	81 fa 00 00 50 10    	cmp    $0x10500000,%edx
   15183:	77 23                	ja     151a8 <free_phy_mem+0x4a>
        return;
    if (paddr < MEM_PHY_NORMAL_MIN && paddr + PAGE_SIZE * count > MEM_PHY_NORMAL_MIN)
   15185:	81 fa 00 00 90 00    	cmp    $0x900000,%edx
   1518b:	76 08                	jbe    15195 <free_phy_mem+0x37>
   1518d:	81 f9 ff ff 8f 00    	cmp    $0x8fffff,%ecx
   15193:	76 13                	jbe    151a8 <free_phy_mem+0x4a>
        return;
    u32 idx = (paddr - MEM_PHY_MIN) / PAGE_SIZE;
    bitmap_clear(&_mem_bitmap, idx, count);
   15195:	52                   	push   %edx
   15196:	53                   	push   %ebx
    u32 idx = (paddr - MEM_PHY_MIN) / PAGE_SIZE;
   15197:	c1 e8 0c             	shr    $0xc,%eax
    bitmap_clear(&_mem_bitmap, idx, count);
   1519a:	50                   	push   %eax
   1519b:	68 00 c0 01 00       	push   $0x1c000
   151a0:	e8 f7 ce ff ff       	call   1209c <bitmap_clear>
   151a5:	83 c4 10             	add    $0x10,%esp
}
   151a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   151ab:	c9                   	leave  
   151ac:	c3                   	ret    

000151ad <free_pte>:
    return -1;
#endif
}

static u32 free_pte(u32 pte_idx)
{
   151ad:	55                   	push   %ebp
   151ae:	89 e5                	mov    %esp,%ebp
   151b0:	53                   	push   %ebx
   151b1:	53                   	push   %ebx
   151b2:	89 c2                	mov    %eax,%edx
    
    if (_MappedSize[pte_idx - 256] == 0)
        return;
#endif

    u32 i = 0, n = _MappedPTE_Used;
   151b4:	8b 0d 20 e0 01 00    	mov    0x1e020,%ecx
   151ba:	89 cb                	mov    %ecx,%ebx
   151bc:	31 c0                	xor    %eax,%eax
    while (n && i < 1024)
   151be:	85 db                	test   %ebx,%ebx
   151c0:	74 1e                	je     151e0 <free_pte+0x33>
   151c2:	3d 00 04 00 00       	cmp    $0x400,%eax
   151c7:	74 34                	je     151fd <free_pte+0x50>
    {
        if (_MappedPTE[i].count)
   151c9:	83 3c c5 44 e0 01 00 	cmpl   $0x0,0x1e044(,%eax,8)
   151d0:	00 
   151d1:	74 0a                	je     151dd <free_pte+0x30>
        {
            --n;
   151d3:	4b                   	dec    %ebx
            if (_MappedPTE[i].start == pte_idx)
   151d4:	39 14 c5 40 e0 01 00 	cmp    %edx,0x1e040(,%eax,8)
   151db:	74 20                	je     151fd <free_pte+0x50>
            {
                break;
            }
        }
        ++i;
   151dd:	40                   	inc    %eax
   151de:	eb de                	jmp    151be <free_pte+0x11>
    }
    if (n == 0 && _MappedPTE[i].count == 0)
   151e0:	8b 1c c5 44 e0 01 00 	mov    0x1e044(,%eax,8),%ebx
   151e7:	85 db                	test   %ebx,%ebx
   151e9:	75 12                	jne    151fd <free_pte+0x50>
    {
        printf("can't find the pte_idx(%d) mapped!(%d)\n", pte_idx, i);
   151eb:	51                   	push   %ecx
   151ec:	50                   	push   %eax
   151ed:	52                   	push   %edx
   151ee:	68 f1 94 01 00       	push   $0x194f1
   151f3:	e8 02 dd ff ff       	call   12efa <printf>
        return 0;
   151f8:	83 c4 10             	add    $0x10,%esp
   151fb:	eb 3f                	jmp    1523c <free_pte+0x8f>
    }

    u32 ret = _MappedPTE[i].count;
   151fd:	8b 1c c5 44 e0 01 00 	mov    0x1e044(,%eax,8),%ebx
    _MappedPTE[i].start = 0;
   15204:	c7 04 c5 40 e0 01 00 	movl   $0x0,0x1e040(,%eax,8)
   1520b:	00 00 00 00 
    _MappedPTE[i].count = 0;
   1520f:	c7 04 c5 44 e0 01 00 	movl   $0x0,0x1e044(,%eax,8)
   15216:	00 00 00 00 
    if (i < _MappedPTE_FirstFreeIdx)
   1521a:	39 05 24 e0 01 00    	cmp    %eax,0x1e024
   15220:	76 05                	jbe    15227 <free_pte+0x7a>
        _MappedPTE_FirstFreeIdx = i;
   15222:	a3 24 e0 01 00       	mov    %eax,0x1e024

    if (pte_idx < _FirstFreePTE)
   15227:	39 15 54 aa 01 00    	cmp    %edx,0x1aa54
   1522d:	76 06                	jbe    15235 <free_pte+0x88>
        _FirstFreePTE = pte_idx;
   1522f:	89 15 54 aa 01 00    	mov    %edx,0x1aa54

    --_MappedPTE_Used;
   15235:	49                   	dec    %ecx
   15236:	89 0d 20 e0 01 00    	mov    %ecx,0x1e020
    invlpg(pte_idx << 12, _MappedSize[pte_idx - 256]);
    _MappedSize[pte_idx - 256] = 0;
    if (_FirstFreePTE > pte_idx)
        _FirstFreePTE = pte_idx;
#endif
}
   1523c:	89 d8                	mov    %ebx,%eax
   1523e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   15241:	c9                   	leave  
   15242:	c3                   	ret    

00015243 <alloc_pte>:
{
   15243:	55                   	push   %ebp
   15244:	89 e5                	mov    %esp,%ebp
   15246:	57                   	push   %edi
   15247:	56                   	push   %esi
   15248:	53                   	push   %ebx
   15249:	83 ec 1c             	sub    $0x1c,%esp
   1524c:	89 c2                	mov    %eax,%edx
    if (_MappedPTE_Used == 1024)
   1524e:	8b 1d 20 e0 01 00    	mov    0x1e020,%ebx
    for (u32 pte_idx = _FirstFreePTE; pte_idx < 1024 * 1024 - count;)
   15254:	a1 54 aa 01 00       	mov    0x1aa54,%eax
   15259:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (_MappedPTE_Used == 1024)
   1525c:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
   15262:	74 0c                	je     15270 <alloc_pte+0x2d>
    for (u32 pte_idx = _FirstFreePTE; pte_idx < 1024 * 1024 - count;)
   15264:	b9 00 00 10 00       	mov    $0x100000,%ecx
   15269:	29 d1                	sub    %edx,%ecx
   1526b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
   1526e:	eb 24                	jmp    15294 <alloc_pte+0x51>
        print_str("_MappedPTE_Used == 1024!!!\n");
   15270:	83 ec 0c             	sub    $0xc,%esp
   15273:	68 19 95 01 00       	push   $0x19519
   15278:	e8 36 dc ff ff       	call   12eb3 <print_str>
        return -1;
   1527d:	83 c4 10             	add    $0x10,%esp
   15280:	eb 6d                	jmp    152ef <alloc_pte+0xac>
        pte_idx += i;
   15282:	01 c8                	add    %ecx,%eax
        while (pte_idx < 1024 * 1024 - count && (_PTE[++pte_idx] & PAGING_PRESENT) == PAGING_PRESENT)
   15284:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
   15287:	76 66                	jbe    152ef <alloc_pte+0xac>
   15289:	40                   	inc    %eax
   1528a:	f6 04 85 00 00 10 00 	testb  $0x1,0x100000(,%eax,4)
   15291:	01 
   15292:	75 f0                	jne    15284 <alloc_pte+0x41>
    for (u32 pte_idx = _FirstFreePTE; pte_idx < 1024 * 1024 - count;)
   15294:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
   15297:	76 56                	jbe    152ef <alloc_pte+0xac>
   15299:	8d 34 85 00 00 10 00 	lea    0x100000(,%eax,4),%esi
        u32 i = 0;
   152a0:	31 c9                	xor    %ecx,%ecx
        while (i < count && (_PTE[pte_idx + i] & PAGING_PRESENT) != PAGING_PRESENT)
   152a2:	39 d1                	cmp    %edx,%ecx
   152a4:	74 0d                	je     152b3 <alloc_pte+0x70>
   152a6:	8b 3e                	mov    (%esi),%edi
   152a8:	83 c6 04             	add    $0x4,%esi
   152ab:	83 e7 01             	and    $0x1,%edi
   152ae:	75 d2                	jne    15282 <alloc_pte+0x3f>
            ++i;
   152b0:	41                   	inc    %ecx
   152b1:	eb ef                	jmp    152a2 <alloc_pte+0x5f>
            if (_FirstFreePTE == pte_idx)
   152b3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
   152b6:	75 09                	jne    152c1 <alloc_pte+0x7e>
                _FirstFreePTE += count;
   152b8:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
   152bb:	89 0d 54 aa 01 00    	mov    %ecx,0x1aa54
            _MappedPTE[_MappedPTE_FirstFreeIdx].start = pte_idx;
   152c1:	8b 0d 24 e0 01 00    	mov    0x1e024,%ecx
   152c7:	89 04 cd 40 e0 01 00 	mov    %eax,0x1e040(,%ecx,8)
            _MappedPTE[_MappedPTE_FirstFreeIdx].count = count;
   152ce:	89 14 cd 44 e0 01 00 	mov    %edx,0x1e044(,%ecx,8)
            while (_MappedPTE[++_MappedPTE_FirstFreeIdx].count)
   152d5:	41                   	inc    %ecx
   152d6:	83 3c cd 44 e0 01 00 	cmpl   $0x0,0x1e044(,%ecx,8)
   152dd:	00 
   152de:	75 f5                	jne    152d5 <alloc_pte+0x92>
   152e0:	89 0d 24 e0 01 00    	mov    %ecx,0x1e024
            ++_MappedPTE_Used;
   152e6:	43                   	inc    %ebx
   152e7:	89 1d 20 e0 01 00    	mov    %ebx,0x1e020
            return pte_idx;
   152ed:	eb 03                	jmp    152f2 <alloc_pte+0xaf>
    return -1;
   152ef:	83 c8 ff             	or     $0xffffffff,%eax
}
   152f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
   152f5:	5b                   	pop    %ebx
   152f6:	5e                   	pop    %esi
   152f7:	5f                   	pop    %edi
   152f8:	5d                   	pop    %ebp
   152f9:	c3                   	ret    

000152fa <paging_setup>:

void paging_setup(void)
{
   152fa:	55                   	push   %ebp
   152fb:	89 e5                	mov    %esp,%ebp
   152fd:	83 ec 08             	sub    $0x8,%esp
   15300:	ba 00 40 00 00       	mov    $0x4000,%edx
    // _FirstFreePTE = 256;

    // u32 paddr = alloc_phy_mem(1);
    // _PDE[0][0] = (u32 *)paddr;

    u32 paddr = PAGING_PTE_PADDR;
   15305:	b8 00 00 10 00       	mov    $0x100000,%eax
    u32 *ptr_PDE = (u32 *)PAGING_PDE_PADDR;
    for (u32 i = 0; i < 1024; ++i)
    {
        ptr_PDE[i] = paddr | PAGING_CACHE_DISABLE | PAGING_READ_WRITE | PAGING_PRESENT;
   1530a:	89 c1                	mov    %eax,%ecx
   1530c:	83 c9 13             	or     $0x13,%ecx
   1530f:	89 0a                	mov    %ecx,(%edx)
        paddr += PAGE_SIZE;
   15311:	05 00 10 00 00       	add    $0x1000,%eax
    for (u32 i = 0; i < 1024; ++i)
   15316:	83 c2 04             	add    $0x4,%edx
   15319:	3d 00 00 50 00       	cmp    $0x500000,%eax
   1531e:	75 ea                	jne    1530a <paging_setup+0x10>
    // _PDE[0] = paddr | PAGING_CACHE_DISABLE | PAGING_READ_WRITE | PAGING_PRESENT;
    // memset(_PDE + 1, 0, (1024 - 1) * 4);

    u32 *ptr_PTE = (u32 *)PAGING_PTE_PADDR;
    paddr = 0;
    for (u32 i = 0; i < _FirstFreePTE; ++i)
   15320:	8b 15 54 aa 01 00    	mov    0x1aa54,%edx
   15326:	31 c0                	xor    %eax,%eax
   15328:	89 c1                	mov    %eax,%ecx
   1532a:	c1 e1 0c             	shl    $0xc,%ecx
   1532d:	39 c2                	cmp    %eax,%edx
   1532f:	74 0d                	je     1533e <paging_setup+0x44>
    { // Map 0-0x400000 to 0-0x400000 (first 1-Mbyte region)
        ptr_PTE[i] = paddr | PAGING_READ_WRITE | PAGING_PRESENT;
   15331:	83 c9 03             	or     $0x3,%ecx
   15334:	89 0c 85 00 00 10 00 	mov    %ecx,0x100000(,%eax,4)
    for (u32 i = 0; i < _FirstFreePTE; ++i)
   1533b:	40                   	inc    %eax
   1533c:	eb ea                	jmp    15328 <paging_setup+0x2e>
        paddr += PAGE_SIZE;
    }
    memset(ptr_PTE + _FirstFreePTE, 0, (1024 * 1024 - _FirstFreePTE) * 4);
   1533e:	50                   	push   %eax
   1533f:	b8 00 00 10 00       	mov    $0x100000,%eax
   15344:	29 d0                	sub    %edx,%eax
   15346:	c1 e0 02             	shl    $0x2,%eax
   15349:	50                   	push   %eax
   1534a:	6a 00                	push   $0x0
   1534c:	8d 04 95 00 00 10 00 	lea    0x100000(,%edx,4),%eax
   15353:	50                   	push   %eax
   15354:	e8 ff 10 00 00       	call   16458 <memset>
	__asm__ __volatile__("movl %0, %%cr3\n"
   15359:	b8 10 40 00 00       	mov    $0x4010,%eax
   1535e:	0f 22 d8             	mov    %eax,%cr3
	__asm__ __volatile__("movl %%cr0, %0\n"
   15361:	0f 20 c0             	mov    %cr0,%eax
    //     // disable();
    //     halt();
    // }

    write_cr3(cr3);
    write_cr0(read_cr0() | CR0_PG | CR0_WP); // Paging here!!!
   15364:	0d 00 00 01 80       	or     $0x80010000,%eax
	__asm__ __volatile__("movl %0, %%cr0\n"
   15369:	0f 22 c0             	mov    %eax,%cr0
}
   1536c:	83 c4 10             	add    $0x10,%esp
   1536f:	c9                   	leave  
   15370:	c3                   	ret    

00015371 <paging_dumpinfo>:

void paging_dumpinfo(void)
{
   15371:	55                   	push   %ebp
   15372:	89 e5                	mov    %esp,%ebp
   15374:	83 ec 0c             	sub    $0xc,%esp
    printf("\nPDE=0x%x, PTE=0x%x, FirstFreePTE=%d\n"
   15377:	ff 35 20 e0 01 00    	push   0x1e020
   1537d:	ff 35 24 e0 01 00    	push   0x1e024
   15383:	68 40 e0 01 00       	push   $0x1e040
   15388:	ff 35 54 aa 01 00    	push   0x1aa54
   1538e:	68 00 00 10 00       	push   $0x100000
   15393:	68 00 40 00 00       	push   $0x4000
   15398:	68 35 95 01 00       	push   $0x19535
   1539d:	e8 58 db ff ff       	call   12efa <printf>
           "MappedPTE=0x%x, FirstFreeIdx=%d, Used=%d\n",
           PAGING_PDE_PADDR, PAGING_PTE_PADDR, _FirstFreePTE,
           _MappedPTE, _MappedPTE_FirstFreeIdx, _MappedPTE_Used);
}
   153a2:	83 c4 20             	add    $0x20,%esp
   153a5:	c9                   	leave  
   153a6:	c3                   	ret    

000153a7 <pagefault_exception_handler>:

void pagefault_exception_handler(const struct trap_frame *frame, u32 error_code)
{
   153a7:	55                   	push   %ebp
   153a8:	89 e5                	mov    %esp,%ebp
   153aa:	53                   	push   %ebx
   153ab:	83 ec 0c             	sub    $0xc,%esp
   153ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    // console_clear_screen();
    console_set_color(COLOR_NORMAL_BG, COLOR_LIGHT_RED);
   153b1:	68 00 00 ff 00       	push   $0xff0000
   153b6:	6a 00                	push   $0x0
   153b8:	e8 d3 d3 ff ff       	call   12790 <console_set_color>
    printf("page fault exception\nerror_code: 0x%x\nreason info\nat: 0x%x\n", error_code, frame->cr2);
   153bd:	83 c4 0c             	add    $0xc,%esp
   153c0:	8b 45 08             	mov    0x8(%ebp),%eax
   153c3:	ff 70 04             	push   0x4(%eax)
   153c6:	53                   	push   %ebx
   153c7:	68 84 95 01 00       	push   $0x19584
   153cc:	e8 29 db ff ff       	call   12efa <printf>
           reason_WR[(error_code >> 1) & 1],
           reason_US[(error_code >> 2) & 1],
           reason_RSVD[(error_code >> 3) & 1],
           reason_ID[(error_code >> 4) & 1],
           reason_PK[(error_code >> 5) & 1],
           reason_SGX[(error_code >> 15) & 1]);
   153d1:	89 d8                	mov    %ebx,%eax
   153d3:	c1 e8 0f             	shr    $0xf,%eax
   153d6:	83 e0 01             	and    $0x1,%eax
    printf("%s%s%s%s%s%s%s",
   153d9:	ff 34 85 ec 98 01 00 	push   0x198ec(,%eax,4)
           reason_PK[(error_code >> 5) & 1],
   153e0:	89 d8                	mov    %ebx,%eax
   153e2:	c1 e8 05             	shr    $0x5,%eax
   153e5:	83 e0 01             	and    $0x1,%eax
    printf("%s%s%s%s%s%s%s",
   153e8:	ff 34 85 f4 98 01 00 	push   0x198f4(,%eax,4)
           reason_ID[(error_code >> 4) & 1],
   153ef:	89 d8                	mov    %ebx,%eax
   153f1:	c1 e8 04             	shr    $0x4,%eax
   153f4:	83 e0 01             	and    $0x1,%eax
    printf("%s%s%s%s%s%s%s",
   153f7:	ff 34 85 fc 98 01 00 	push   0x198fc(,%eax,4)
           reason_RSVD[(error_code >> 3) & 1],
   153fe:	89 d8                	mov    %ebx,%eax
   15400:	c1 e8 03             	shr    $0x3,%eax
   15403:	83 e0 01             	and    $0x1,%eax
    printf("%s%s%s%s%s%s%s",
   15406:	ff 34 85 04 99 01 00 	push   0x19904(,%eax,4)
           reason_US[(error_code >> 2) & 1],
   1540d:	89 d8                	mov    %ebx,%eax
   1540f:	83 e0 04             	and    $0x4,%eax
    printf("%s%s%s%s%s%s%s",
   15412:	ff b0 0c 99 01 00    	push   0x1990c(%eax)
           reason_WR[(error_code >> 1) & 1],
   15418:	89 d8                	mov    %ebx,%eax
   1541a:	d1 e8                	shr    %eax
   1541c:	83 e0 01             	and    $0x1,%eax
    printf("%s%s%s%s%s%s%s",
   1541f:	ff 34 85 14 99 01 00 	push   0x19914(,%eax,4)
           reason_P[(error_code >> 0) & 1],
   15426:	83 e3 01             	and    $0x1,%ebx
    printf("%s%s%s%s%s%s%s",
   15429:	ff 34 9d 1c 99 01 00 	push   0x1991c(,%ebx,4)
   15430:	68 c0 95 01 00       	push   $0x195c0
   15435:	e8 c0 da ff ff       	call   12efa <printf>
}
   1543a:	83 c4 30             	add    $0x30,%esp
   1543d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   15440:	c9                   	leave  
   15441:	c3                   	ret    

00015442 <map_mem>:
        free_page = 1;
    }
}

void *map_mem(u32 paddr, u32 size)
{
   15442:	55                   	push   %ebp
   15443:	89 e5                	mov    %esp,%ebp
   15445:	57                   	push   %edi
   15446:	56                   	push   %esi
   15447:	53                   	push   %ebx
   15448:	83 ec 0c             	sub    $0xc,%esp
   1544b:	8b 7d 08             	mov    0x8(%ebp),%edi
   1544e:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (size == 0)
   15451:	85 c0                	test   %eax,%eax
   15453:	75 04                	jne    15459 <map_mem+0x17>
        return 0;
   15455:	31 c0                	xor    %eax,%eax
   15457:	eb 54                	jmp    154ad <map_mem+0x6b>
    u32 offset = paddr & (PAGE_SIZE - 1);
   15459:	89 fe                	mov    %edi,%esi
   1545b:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
    paddr = paddr & ~(PAGE_SIZE - 1);                          // 向下取整
   15461:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    size = (size + offset + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1); // 向上取整
   15467:	8d 9c 06 ff 0f 00 00 	lea    0xfff(%esi,%eax,1),%ebx
   1546e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if (paddr + size <= paddr)
   15474:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
   15477:	39 f8                	cmp    %edi,%eax
   15479:	76 da                	jbe    15455 <map_mem+0x13>
    return paddr | offset;
}

u32 get_page_count(u32 size)
{
    return (size + PAGE_SIZE - 1) / PAGE_SIZE;
   1547b:	c1 eb 0c             	shr    $0xc,%ebx
    u32 pte_idx = alloc_pte(count);
   1547e:	89 d8                	mov    %ebx,%eax
   15480:	e8 be fd ff ff       	call   15243 <alloc_pte>
    if (pte_idx == (u32)-1)
   15485:	83 f8 ff             	cmp    $0xffffffff,%eax
   15488:	74 cb                	je     15455 <map_mem+0x13>
   1548a:	8d 14 85 00 00 10 00 	lea    0x100000(,%eax,4),%edx
    while (count--)
   15491:	83 eb 01             	sub    $0x1,%ebx
   15494:	72 12                	jb     154a8 <map_mem+0x66>
        _PTE[pte_idx++] = paddr | PAGING_READ_WRITE | PAGING_PRESENT;
   15496:	89 f9                	mov    %edi,%ecx
   15498:	83 c9 03             	or     $0x3,%ecx
   1549b:	89 0a                	mov    %ecx,(%edx)
        paddr += PAGE_SIZE;
   1549d:	81 c7 00 10 00 00    	add    $0x1000,%edi
   154a3:	83 c2 04             	add    $0x4,%edx
   154a6:	eb e9                	jmp    15491 <map_mem+0x4f>
    return (void *)((pte_idx << 12) | offset);
   154a8:	c1 e0 0c             	shl    $0xc,%eax
   154ab:	09 f0                	or     %esi,%eax
}
   154ad:	83 c4 0c             	add    $0xc,%esp
   154b0:	5b                   	pop    %ebx
   154b1:	5e                   	pop    %esi
   154b2:	5f                   	pop    %edi
   154b3:	5d                   	pop    %ebp
   154b4:	c3                   	ret    

000154b5 <get_paddr>:
{
   154b5:	55                   	push   %ebp
   154b6:	89 e5                	mov    %esp,%ebp
   154b8:	8b 55 08             	mov    0x8(%ebp),%edx
        return 0;
   154bb:	31 c0                	xor    %eax,%eax
    if ((u32)laddr < PAGING_LADDR_MINIMUM)
   154bd:	81 fa ff ff 4f 00    	cmp    $0x4fffff,%edx
   154c3:	76 22                	jbe    154e7 <get_paddr+0x32>
    u32 pte_idx = (u32)laddr >> 12;
   154c5:	89 d0                	mov    %edx,%eax
   154c7:	c1 e8 0c             	shr    $0xc,%eax
    if ((_PTE[pte_idx] & PAGING_PRESENT) != PAGING_PRESENT)
   154ca:	8b 0c 85 00 00 10 00 	mov    0x100000(,%eax,4),%ecx
   154d1:	89 c8                	mov    %ecx,%eax
   154d3:	83 e0 01             	and    $0x1,%eax
   154d6:	74 0f                	je     154e7 <get_paddr+0x32>
    u32 offset = (u32)laddr & (PAGE_SIZE - 1);
   154d8:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
    u32 paddr = _PTE[pte_idx] & ~(PAGE_SIZE - 1);
   154de:	89 c8                	mov    %ecx,%eax
   154e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return paddr | offset;
   154e5:	09 d0                	or     %edx,%eax
}
   154e7:	5d                   	pop    %ebp
   154e8:	c3                   	ret    

000154e9 <get_page_count>:
{
   154e9:	55                   	push   %ebp
   154ea:	89 e5                	mov    %esp,%ebp
    return (size + PAGE_SIZE - 1) / PAGE_SIZE;
   154ec:	8b 45 08             	mov    0x8(%ebp),%eax
   154ef:	05 ff 0f 00 00       	add    $0xfff,%eax
   154f4:	c1 e8 0c             	shr    $0xc,%eax
}
   154f7:	5d                   	pop    %ebp
   154f8:	c3                   	ret    

000154f9 <invlpg>:

void invlpg(u32 laddr, u32 count)
{
   154f9:	55                   	push   %ebp
   154fa:	89 e5                	mov    %esp,%ebp
   154fc:	8b 55 08             	mov    0x8(%ebp),%edx
   154ff:	8b 45 0c             	mov    0xc(%ebp),%eax
    while (count--)
   15502:	85 c0                	test   %eax,%eax
   15504:	74 0c                	je     15512 <invlpg+0x19>
    {
        __asm__ __volatile__("invlpg (%0)"
   15506:	0f 01 3a             	invlpg (%edx)
                             :
                             : "r"(laddr)
                             :);
        laddr += PAGE_SIZE;
   15509:	81 c2 00 10 00 00    	add    $0x1000,%edx
   1550f:	48                   	dec    %eax
   15510:	eb f0                	jmp    15502 <invlpg+0x9>
    }
}
   15512:	5d                   	pop    %ebp
   15513:	c3                   	ret    

00015514 <unmap_page>:
{
   15514:	55                   	push   %ebp
   15515:	89 e5                	mov    %esp,%ebp
   15517:	56                   	push   %esi
   15518:	53                   	push   %ebx
   15519:	89 c3                	mov    %eax,%ebx
   1551b:	89 d6                	mov    %edx,%esi
    memset(&_PTE[pte_idx], 0, count * 4);
   1551d:	50                   	push   %eax
   1551e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
   15525:	50                   	push   %eax
   15526:	6a 00                	push   $0x0
   15528:	8d 04 9d 00 00 10 00 	lea    0x100000(,%ebx,4),%eax
   1552f:	50                   	push   %eax
   15530:	e8 23 0f 00 00       	call   16458 <memset>
    invlpg(pte_idx << 12, count);
   15535:	5a                   	pop    %edx
   15536:	59                   	pop    %ecx
   15537:	56                   	push   %esi
   15538:	c1 e3 0c             	shl    $0xc,%ebx
   1553b:	53                   	push   %ebx
   1553c:	e8 b8 ff ff ff       	call   154f9 <invlpg>
}
   15541:	83 c4 10             	add    $0x10,%esp
   15544:	8d 65 f8             	lea    -0x8(%ebp),%esp
   15547:	5b                   	pop    %ebx
   15548:	5e                   	pop    %esi
   15549:	5d                   	pop    %ebp
   1554a:	c3                   	ret    

0001554b <free_page>:
{
   1554b:	55                   	push   %ebp
   1554c:	89 e5                	mov    %esp,%ebp
   1554e:	57                   	push   %edi
   1554f:	56                   	push   %esi
   15550:	53                   	push   %ebx
   15551:	83 ec 1c             	sub    $0x1c,%esp
    u32 pte_idx = (u32)laddr >> 12;
   15554:	8b 45 08             	mov    0x8(%ebp),%eax
   15557:	c1 e8 0c             	shr    $0xc,%eax
   1555a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    u32 count = free_pte(pte_idx);
   1555d:	e8 4b fc ff ff       	call   151ad <free_pte>
   15562:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!count)
   15565:	85 c0                	test   %eax,%eax
   15567:	0f 84 81 00 00 00    	je     155ee <free_page+0xa3>
    u32 pre_paddr, cur_paddr = get_paddr(laddr);
   1556d:	83 ec 0c             	sub    $0xc,%esp
   15570:	ff 75 08             	push   0x8(%ebp)
   15573:	e8 3d ff ff ff       	call   154b5 <get_paddr>
   15578:	83 c4 10             	add    $0x10,%esp
   1557b:	89 c3                	mov    %eax,%ebx
    if (!cur_paddr)
   1557d:	85 c0                	test   %eax,%eax
   1557f:	74 6d                	je     155ee <free_page+0xa3>
   15581:	89 c7                	mov    %eax,%edi
    u32 free_page = 1;
   15583:	be 01 00 00 00       	mov    $0x1,%esi
        if (free_page < count)
   15588:	89 d9                	mov    %ebx,%ecx
   1558a:	39 75 e0             	cmp    %esi,-0x20(%ebp)
   1558d:	76 2e                	jbe    155bd <free_page+0x72>
            laddr = (u8 *)laddr + PAGE_SIZE;
   1558f:	81 45 08 00 10 00 00 	addl   $0x1000,0x8(%ebp)
            cur_paddr = get_paddr(laddr);
   15596:	83 ec 0c             	sub    $0xc,%esp
   15599:	ff 75 08             	push   0x8(%ebp)
   1559c:	e8 14 ff ff ff       	call   154b5 <get_paddr>
   155a1:	83 c4 10             	add    $0x10,%esp
   155a4:	89 c1                	mov    %eax,%ecx
            if (cur_paddr && cur_paddr == tmp_paddr + PAGE_SIZE)
   155a6:	85 c0                	test   %eax,%eax
   155a8:	74 13                	je     155bd <free_page+0x72>
   155aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
   155b0:	39 c3                	cmp    %eax,%ebx
   155b2:	75 09                	jne    155bd <free_page+0x72>
                ++free_page;
   155b4:	46                   	inc    %esi
                continue;
   155b5:	89 c3                	mov    %eax,%ebx
   155b7:	89 f9                	mov    %edi,%ecx
   155b9:	89 cf                	mov    %ecx,%edi
   155bb:	eb cb                	jmp    15588 <free_page+0x3d>
   155bd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
        unmap_page(pte_idx, free_page);
   155c0:	89 f2                	mov    %esi,%edx
   155c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
   155c5:	e8 4a ff ff ff       	call   15514 <unmap_page>
        free_phy_mem(pre_paddr, free_page);
   155ca:	50                   	push   %eax
   155cb:	50                   	push   %eax
   155cc:	56                   	push   %esi
   155cd:	57                   	push   %edi
   155ce:	e8 8b fb ff ff       	call   1515e <free_phy_mem>
        if (!cur_paddr)
   155d3:	83 c4 10             	add    $0x10,%esp
   155d6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
   155d9:	85 c9                	test   %ecx,%ecx
   155db:	74 11                	je     155ee <free_page+0xa3>
        if (!count)
   155dd:	29 75 e0             	sub    %esi,-0x20(%ebp)
   155e0:	74 0c                	je     155ee <free_page+0xa3>
        pte_idx += free_page;
   155e2:	01 75 e4             	add    %esi,-0x1c(%ebp)
   155e5:	89 cb                	mov    %ecx,%ebx
        free_page = 1;
   155e7:	be 01 00 00 00       	mov    $0x1,%esi
   155ec:	eb cb                	jmp    155b9 <free_page+0x6e>
}
   155ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
   155f1:	5b                   	pop    %ebx
   155f2:	5e                   	pop    %esi
   155f3:	5f                   	pop    %edi
   155f4:	5d                   	pop    %ebp
   155f5:	c3                   	ret    

000155f6 <alloc_page>:
{
   155f6:	55                   	push   %ebp
   155f7:	89 e5                	mov    %esp,%ebp
   155f9:	57                   	push   %edi
   155fa:	56                   	push   %esi
   155fb:	53                   	push   %ebx
   155fc:	83 ec 2c             	sub    $0x2c,%esp
    return (size + PAGE_SIZE - 1) / PAGE_SIZE;
   155ff:	8b 45 08             	mov    0x8(%ebp),%eax
   15602:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
        return 0;
   15608:	31 c0                	xor    %eax,%eax
    if (count == 0)
   1560a:	c1 eb 0c             	shr    $0xc,%ebx
   1560d:	0f 84 87 00 00 00    	je     1569a <alloc_page+0xa4>
    u32 pte_idx = alloc_pte(count);
   15613:	89 d8                	mov    %ebx,%eax
   15615:	e8 29 fc ff ff       	call   15243 <alloc_pte>
   1561a:	89 c7                	mov    %eax,%edi
    if (pte_idx == (u32)-1)
   1561c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
   1561f:	83 f8 ff             	cmp    $0xffffffff,%eax
   15622:	75 0a                	jne    1562e <alloc_page+0x38>
        print_str("alloc_kernel_pte failed!\n");
   15624:	83 ec 0c             	sub    $0xc,%esp
   15627:	68 cf 95 01 00       	push   $0x195cf
   1562c:	eb 2a                	jmp    15658 <alloc_page+0x62>
        paddr = alloc_phy_mem(count, &allocated, type);
   1562e:	50                   	push   %eax
   1562f:	ff 75 0c             	push   0xc(%ebp)
   15632:	8d 45 e4             	lea    -0x1c(%ebp),%eax
   15635:	50                   	push   %eax
   15636:	53                   	push   %ebx
   15637:	e8 74 fa ff ff       	call   150b0 <alloc_phy_mem>
        if (paddr == 0)
   1563c:	83 c4 10             	add    $0x10,%esp
   1563f:	85 c0                	test   %eax,%eax
   15641:	75 21                	jne    15664 <alloc_page+0x6e>
            free_page((void *)(pte_idx << 12));
   15643:	83 ec 0c             	sub    $0xc,%esp
   15646:	89 f8                	mov    %edi,%eax
   15648:	c1 e0 0c             	shl    $0xc,%eax
   1564b:	50                   	push   %eax
   1564c:	e8 fa fe ff ff       	call   1554b <free_page>
            print_str("alloc_phy_mem failed!\n");
   15651:	c7 04 24 e9 95 01 00 	movl   $0x195e9,(%esp)
   15658:	e8 56 d8 ff ff       	call   12eb3 <print_str>
            return 0;
   1565d:	83 c4 10             	add    $0x10,%esp
   15660:	31 c0                	xor    %eax,%eax
   15662:	eb 36                	jmp    1569a <alloc_page+0xa4>
        map_page(idx, paddr, allocated);
   15664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    while (count--)
   15667:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
   1566a:	8d 0c 8d 00 00 10 00 	lea    0x100000(,%ecx,4),%ecx
   15671:	89 55 d0             	mov    %edx,-0x30(%ebp)
   15674:	ff 4d d0             	decl   -0x30(%ebp)
   15677:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
   1567b:	74 11                	je     1568e <alloc_page+0x98>
        _PTE[pte_idx++] = paddr | PAGING_READ_WRITE | PAGING_PRESENT;
   1567d:	89 c6                	mov    %eax,%esi
   1567f:	83 ce 03             	or     $0x3,%esi
   15682:	89 31                	mov    %esi,(%ecx)
        paddr += PAGE_SIZE;
   15684:	05 00 10 00 00       	add    $0x1000,%eax
   15689:	83 c1 04             	add    $0x4,%ecx
   1568c:	eb e6                	jmp    15674 <alloc_page+0x7e>
        idx += allocated;
   1568e:	01 55 d4             	add    %edx,-0x2c(%ebp)
    } while (count);
   15691:	29 d3                	sub    %edx,%ebx
   15693:	75 99                	jne    1562e <alloc_page+0x38>
    return (void *)(pte_idx << 12);
   15695:	89 f8                	mov    %edi,%eax
   15697:	c1 e0 0c             	shl    $0xc,%eax
}
   1569a:	8d 65 f4             	lea    -0xc(%ebp),%esp
   1569d:	5b                   	pop    %ebx
   1569e:	5e                   	pop    %esi
   1569f:	5f                   	pop    %edi
   156a0:	5d                   	pop    %ebp
   156a1:	c3                   	ret    

000156a2 <unmap_mem>:
{
   156a2:	55                   	push   %ebp
   156a3:	89 e5                	mov    %esp,%ebp
   156a5:	53                   	push   %ebx
   156a6:	53                   	push   %ebx
   156a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if ((u32)laddr < PAGING_LADDR_MINIMUM)
   156aa:	81 fb ff ff 4f 00    	cmp    $0x4fffff,%ebx
   156b0:	76 16                	jbe    156c8 <unmap_mem+0x26>
    u32 pte_idx = (u32)laddr >> 12;
   156b2:	c1 eb 0c             	shr    $0xc,%ebx
    u32 count = free_pte(pte_idx);
   156b5:	89 d8                	mov    %ebx,%eax
   156b7:	e8 f1 fa ff ff       	call   151ad <free_pte>
   156bc:	89 c2                	mov    %eax,%edx
    unmap_page(pte_idx, count);
   156be:	89 d8                	mov    %ebx,%eax
}
   156c0:	59                   	pop    %ecx
   156c1:	5b                   	pop    %ebx
   156c2:	5d                   	pop    %ebp
    unmap_page(pte_idx, count);
   156c3:	e9 4c fe ff ff       	jmp    15514 <unmap_page>
}
   156c8:	58                   	pop    %eax
   156c9:	5b                   	pop    %ebx
   156ca:	5d                   	pop    %ebp
   156cb:	c3                   	ret    

000156cc <pci_setup>:
#include "cpu.h"

static struct pci_configuration *_pci_conf;

void pci_setup(struct pci_configuration *info)
{
   156cc:	55                   	push   %ebp
   156cd:	89 e5                	mov    %esp,%ebp
   156cf:	8b 45 08             	mov    0x8(%ebp),%eax
    _pci_conf = info;
   156d2:	a3 40 00 02 00       	mov    %eax,0x20040

    if (!_pci_conf->present)
   156d7:	80 78 04 00          	cmpb   $0x0,0x4(%eax)
   156db:	75 04                	jne    156e1 <pci_setup+0x15>
        _pci_conf->last_bus = 255;
   156dd:	c6 40 03 ff          	movb   $0xff,0x3(%eax)
}
   156e1:	5d                   	pop    %ebp
   156e2:	c3                   	ret    

000156e3 <pci_conf_read_dword>:
    data = ((u16 *)&tmp)[idx & 0x1];
    return data;
}

u32 pci_conf_read_dword(u32 bus, u32 dev, u32 func, u32 idx)
{
   156e3:	55                   	push   %ebp
   156e4:	89 e5                	mov    %esp,%ebp
   156e6:	53                   	push   %ebx
   156e7:	8b 45 08             	mov    0x8(%ebp),%eax
   156ea:	8b 55 0c             	mov    0xc(%ebp),%edx
    if (bus > _pci_conf->last_bus || dev > 31 || func > 7 || idx > 63)
   156ed:	83 7d 14 3f          	cmpl   $0x3f,0x14(%ebp)
   156f1:	0f 97 c3             	seta   %bl
   156f4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
   156f8:	0f 97 c1             	seta   %cl
   156fb:	09 cb                	or     %ecx,%ebx
   156fd:	83 fa 1f             	cmp    $0x1f,%edx
   15700:	0f 97 c1             	seta   %cl
   15703:	08 cb                	or     %cl,%bl
   15705:	75 48                	jne    1574f <pci_conf_read_dword+0x6c>
   15707:	8b 0d 40 00 02 00    	mov    0x20040,%ecx
   1570d:	0f b6 49 03          	movzbl 0x3(%ecx),%ecx
   15711:	39 c1                	cmp    %eax,%ecx
   15713:	72 3a                	jb     1574f <pci_conf_read_dword+0x6c>
	__asm__ __volatile__("pushfl\n\t"
   15715:	9c                   	pushf  
   15716:	59                   	pop    %ecx
	__asm__ __volatile__("cli\n" ::
   15717:	fa                   	cli    
        return -1;

    u32 addr = 0x80000000 | bus << 16 | dev << 11 | func << 8 | idx << 2;
   15718:	c1 e0 10             	shl    $0x10,%eax
   1571b:	8b 5d 14             	mov    0x14(%ebp),%ebx
   1571e:	c1 e3 02             	shl    $0x2,%ebx
   15721:	09 d8                	or     %ebx,%eax
   15723:	8b 5d 10             	mov    0x10(%ebp),%ebx
   15726:	c1 e3 08             	shl    $0x8,%ebx
   15729:	09 d8                	or     %ebx,%eax
   1572b:	c1 e2 0b             	shl    $0xb,%edx
   1572e:	09 d0                	or     %edx,%eax
   15730:	0d 00 00 00 80       	or     $0x80000000,%eax
    __asm__ volatile("outl %0, %1"
   15735:	ba f8 0c 00 00       	mov    $0xcf8,%edx
   1573a:	ef                   	out    %eax,(%dx)
    __asm__ volatile("inl %1, %0"
   1573b:	ba fc 0c 00 00       	mov    $0xcfc,%edx
   15740:	ed                   	in     (%dx),%eax
	__asm__ __volatile__("pushfl\n\t"
   15741:	9c                   	pushf  
   15742:	5a                   	pop    %edx
    u32 save_eflags = read_eflags();
    disable();
    port_write_dword(PCI_PORT_CONF_ADDR, addr);
    u32 data = port_read_dword(PCI_PORT_CONF_DATA);
    write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
   15743:	81 e1 00 02 00 00    	and    $0x200,%ecx
   15749:	09 d1                	or     %edx,%ecx
	__asm__ __volatile__("pushl %0\n\t"
   1574b:	51                   	push   %ecx
   1574c:	9d                   	popf   
    return data;
   1574d:	eb 03                	jmp    15752 <pci_conf_read_dword+0x6f>
        return -1;
   1574f:	83 c8 ff             	or     $0xffffffff,%eax
}
   15752:	5b                   	pop    %ebx
   15753:	5d                   	pop    %ebp
   15754:	c3                   	ret    

00015755 <pci_conf_read_byte>:
{
   15755:	55                   	push   %ebp
   15756:	89 e5                	mov    %esp,%ebp
   15758:	83 ec 18             	sub    $0x18,%esp
    u32 tmp = pci_conf_read_dword(bus, dev, func, idx >> 2);
   1575b:	8b 45 14             	mov    0x14(%ebp),%eax
   1575e:	c1 e8 02             	shr    $0x2,%eax
   15761:	50                   	push   %eax
   15762:	ff 75 10             	push   0x10(%ebp)
   15765:	ff 75 0c             	push   0xc(%ebp)
   15768:	ff 75 08             	push   0x8(%ebp)
   1576b:	e8 73 ff ff ff       	call   156e3 <pci_conf_read_dword>
   15770:	89 45 f4             	mov    %eax,-0xc(%ebp)
    data = ((u8 *)&tmp)[idx & 0x3];
   15773:	8b 45 14             	mov    0x14(%ebp),%eax
   15776:	83 e0 03             	and    $0x3,%eax
   15779:	8a 44 05 f4          	mov    -0xc(%ebp,%eax,1),%al
}
   1577d:	c9                   	leave  
   1577e:	c3                   	ret    

0001577f <pci_conf_read_word>:
{
   1577f:	55                   	push   %ebp
   15780:	89 e5                	mov    %esp,%ebp
   15782:	83 ec 18             	sub    $0x18,%esp
    u32 tmp = pci_conf_read_dword(bus, dev, func, idx >> 1);
   15785:	8b 45 14             	mov    0x14(%ebp),%eax
   15788:	d1 e8                	shr    %eax
   1578a:	50                   	push   %eax
   1578b:	ff 75 10             	push   0x10(%ebp)
   1578e:	ff 75 0c             	push   0xc(%ebp)
   15791:	ff 75 08             	push   0x8(%ebp)
   15794:	e8 4a ff ff ff       	call   156e3 <pci_conf_read_dword>
   15799:	89 45 f4             	mov    %eax,-0xc(%ebp)
    data = ((u16 *)&tmp)[idx & 0x1];
   1579c:	8b 45 14             	mov    0x14(%ebp),%eax
   1579f:	83 e0 01             	and    $0x1,%eax
   157a2:	66 8b 44 45 f4       	mov    -0xc(%ebp,%eax,2),%ax
}
   157a7:	c9                   	leave  
   157a8:	c3                   	ret    

000157a9 <pci_conf_write_dword>:
    ptr[idx & 0x1] = val;
    pci_conf_write_dword(bus, dev, func, idx >> 1, data);
}

void pci_conf_write_dword(u32 bus, u32 dev, u32 func, u32 idx, u32 val)
{
   157a9:	55                   	push   %ebp
   157aa:	89 e5                	mov    %esp,%ebp
   157ac:	53                   	push   %ebx
   157ad:	8b 45 08             	mov    0x8(%ebp),%eax
   157b0:	8b 55 0c             	mov    0xc(%ebp),%edx
    if (bus > _pci_conf->last_bus || dev > 31 || func > 7 || idx > 63)
   157b3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
   157b7:	0f 97 c3             	seta   %bl
   157ba:	83 7d 14 3f          	cmpl   $0x3f,0x14(%ebp)
   157be:	0f 97 c1             	seta   %cl
   157c1:	09 cb                	or     %ecx,%ebx
   157c3:	83 fa 1f             	cmp    $0x1f,%edx
   157c6:	0f 97 c1             	seta   %cl
   157c9:	08 cb                	or     %cl,%bl
   157cb:	75 49                	jne    15816 <pci_conf_write_dword+0x6d>
   157cd:	8b 0d 40 00 02 00    	mov    0x20040,%ecx
   157d3:	0f b6 49 03          	movzbl 0x3(%ecx),%ecx
   157d7:	39 c1                	cmp    %eax,%ecx
   157d9:	72 3b                	jb     15816 <pci_conf_write_dword+0x6d>
	__asm__ __volatile__("pushfl\n\t"
   157db:	9c                   	pushf  
   157dc:	59                   	pop    %ecx
	__asm__ __volatile__("cli\n" ::
   157dd:	fa                   	cli    
        return;

    u32 addr = 0x80000000 | bus << 16 | dev << 11 | func << 8 | idx << 2;
   157de:	c1 e0 10             	shl    $0x10,%eax
   157e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
   157e4:	c1 e3 02             	shl    $0x2,%ebx
   157e7:	09 d8                	or     %ebx,%eax
   157e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
   157ec:	c1 e3 08             	shl    $0x8,%ebx
   157ef:	09 d8                	or     %ebx,%eax
   157f1:	c1 e2 0b             	shl    $0xb,%edx
   157f4:	09 d0                	or     %edx,%eax
   157f6:	0d 00 00 00 80       	or     $0x80000000,%eax
    __asm__ volatile("outl %0, %1"
   157fb:	ba f8 0c 00 00       	mov    $0xcf8,%edx
   15800:	ef                   	out    %eax,(%dx)
   15801:	8b 45 18             	mov    0x18(%ebp),%eax
   15804:	ba fc 0c 00 00       	mov    $0xcfc,%edx
   15809:	ef                   	out    %eax,(%dx)
	__asm__ __volatile__("pushfl\n\t"
   1580a:	9c                   	pushf  
   1580b:	58                   	pop    %eax
    u32 save_eflags = read_eflags();
    disable();
    port_write_dword(PCI_PORT_CONF_ADDR, addr);
    port_write_dword(PCI_PORT_CONF_DATA, val);
    write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
   1580c:	81 e1 00 02 00 00    	and    $0x200,%ecx
   15812:	09 c1                	or     %eax,%ecx
	__asm__ __volatile__("pushl %0\n\t"
   15814:	51                   	push   %ecx
   15815:	9d                   	popf   
}
   15816:	5b                   	pop    %ebx
   15817:	5d                   	pop    %ebp
   15818:	c3                   	ret    

00015819 <pci_conf_write_byte>:
{
   15819:	55                   	push   %ebp
   1581a:	89 e5                	mov    %esp,%ebp
   1581c:	57                   	push   %edi
   1581d:	56                   	push   %esi
   1581e:	53                   	push   %ebx
   1581f:	83 ec 2c             	sub    $0x2c,%esp
   15822:	8b 75 08             	mov    0x8(%ebp),%esi
   15825:	8b 7d 0c             	mov    0xc(%ebp),%edi
   15828:	8b 55 10             	mov    0x10(%ebp),%edx
   1582b:	8b 5d 14             	mov    0x14(%ebp),%ebx
   1582e:	8b 45 18             	mov    0x18(%ebp),%eax
   15831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    u32 data = pci_conf_read_dword(bus, dev, func, idx >> 2);
   15834:	89 d9                	mov    %ebx,%ecx
   15836:	c1 e9 02             	shr    $0x2,%ecx
   15839:	51                   	push   %ecx
   1583a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
   1583d:	52                   	push   %edx
   1583e:	89 55 d0             	mov    %edx,-0x30(%ebp)
   15841:	57                   	push   %edi
   15842:	56                   	push   %esi
   15843:	e8 9b fe ff ff       	call   156e3 <pci_conf_read_dword>
   15848:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    ptr[idx & 0x3] = val;
   1584b:	83 e3 03             	and    $0x3,%ebx
   1584e:	8a 45 d4             	mov    -0x2c(%ebp),%al
   15851:	88 44 1d e4          	mov    %al,-0x1c(%ebp,%ebx,1)
    pci_conf_write_dword(bus, dev, func, idx >> 2, data);
   15855:	83 c4 10             	add    $0x10,%esp
   15858:	8b 45 e4             	mov    -0x1c(%ebp),%eax
   1585b:	89 45 18             	mov    %eax,0x18(%ebp)
   1585e:	8b 4d cc             	mov    -0x34(%ebp),%ecx
   15861:	89 4d 14             	mov    %ecx,0x14(%ebp)
   15864:	8b 55 d0             	mov    -0x30(%ebp),%edx
   15867:	89 55 10             	mov    %edx,0x10(%ebp)
   1586a:	89 7d 0c             	mov    %edi,0xc(%ebp)
   1586d:	89 75 08             	mov    %esi,0x8(%ebp)
}
   15870:	8d 65 f4             	lea    -0xc(%ebp),%esp
   15873:	5b                   	pop    %ebx
   15874:	5e                   	pop    %esi
   15875:	5f                   	pop    %edi
   15876:	5d                   	pop    %ebp
    pci_conf_write_dword(bus, dev, func, idx >> 2, data);
   15877:	e9 2d ff ff ff       	jmp    157a9 <pci_conf_write_dword>

0001587c <pci_conf_write_word>:
{
   1587c:	55                   	push   %ebp
   1587d:	89 e5                	mov    %esp,%ebp
   1587f:	57                   	push   %edi
   15880:	56                   	push   %esi
   15881:	53                   	push   %ebx
   15882:	83 ec 2c             	sub    $0x2c,%esp
   15885:	8b 75 08             	mov    0x8(%ebp),%esi
   15888:	8b 7d 0c             	mov    0xc(%ebp),%edi
   1588b:	8b 55 10             	mov    0x10(%ebp),%edx
   1588e:	8b 5d 14             	mov    0x14(%ebp),%ebx
   15891:	8b 45 18             	mov    0x18(%ebp),%eax
   15894:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    u32 data = pci_conf_read_dword(bus, dev, func, idx >> 1);
   15897:	89 d9                	mov    %ebx,%ecx
   15899:	d1 e9                	shr    %ecx
   1589b:	51                   	push   %ecx
   1589c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
   1589f:	52                   	push   %edx
   158a0:	89 55 d0             	mov    %edx,-0x30(%ebp)
   158a3:	57                   	push   %edi
   158a4:	56                   	push   %esi
   158a5:	e8 39 fe ff ff       	call   156e3 <pci_conf_read_dword>
   158aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    ptr[idx & 0x1] = val;
   158ad:	83 e3 01             	and    $0x1,%ebx
   158b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   158b3:	66 89 44 5d e4       	mov    %ax,-0x1c(%ebp,%ebx,2)
    pci_conf_write_dword(bus, dev, func, idx >> 1, data);
   158b8:	83 c4 10             	add    $0x10,%esp
   158bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
   158be:	89 45 18             	mov    %eax,0x18(%ebp)
   158c1:	8b 4d cc             	mov    -0x34(%ebp),%ecx
   158c4:	89 4d 14             	mov    %ecx,0x14(%ebp)
   158c7:	8b 55 d0             	mov    -0x30(%ebp),%edx
   158ca:	89 55 10             	mov    %edx,0x10(%ebp)
   158cd:	89 7d 0c             	mov    %edi,0xc(%ebp)
   158d0:	89 75 08             	mov    %esi,0x8(%ebp)
}
   158d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
   158d6:	5b                   	pop    %ebx
   158d7:	5e                   	pop    %esi
   158d8:	5f                   	pop    %edi
   158d9:	5d                   	pop    %ebp
    pci_conf_write_dword(bus, dev, func, idx >> 1, data);
   158da:	e9 ca fe ff ff       	jmp    157a9 <pci_conf_write_dword>

000158df <pci_dev_find>:

bool pci_dev_find(struct pci_dev_info *info, bool by_id)
{
   158df:	55                   	push   %ebp
   158e0:	89 e5                	mov    %esp,%ebp
   158e2:	57                   	push   %edi
   158e3:	56                   	push   %esi
   158e4:	53                   	push   %ebx
   158e5:	83 ec 2c             	sub    $0x2c,%esp
   158e8:	8b 75 08             	mov    0x8(%ebp),%esi
   158eb:	8b 45 0c             	mov    0xc(%ebp),%eax
   158ee:	88 45 e0             	mov    %al,-0x20(%ebp)
    u32 target = by_id ? info->dev_id << 16 | info->ven_id : info->class << 8 | info->subclass;
   158f1:	84 c0                	test   %al,%al
   158f3:	74 05                	je     158fa <pci_dev_find+0x1b>
   158f5:	8b 46 0e             	mov    0xe(%esi),%eax
   158f8:	eb 09                	jmp    15903 <pci_dev_find+0x24>
   158fa:	66 8b 46 13          	mov    0x13(%esi),%ax
   158fe:	86 e0                	xchg   %ah,%al
   15900:	0f b7 c0             	movzwl %ax,%eax
   15903:	89 45 d8             	mov    %eax,-0x28(%ebp)
    u16 bus, dev, func;
    bool mf, found = false;

    for (bus = 0; bus <= _pci_conf->last_bus; ++bus)
   15906:	66 c7 45 de 00 00    	movw   $0x0,-0x22(%ebp)
    {
        for (dev = 0; dev <= 31; ++dev)
   1590c:	66 c7 45 e2 00 00    	movw   $0x0,-0x1e(%ebp)
{
   15912:	31 db                	xor    %ebx,%ebx
        {
            mf = false;
   15914:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
            for (func = 0; func <= 7; ++func)
            {
                u32 dev_ven = pci_conf_read_dword(bus, dev, func, 0x0);
   15918:	0f b7 7d e2          	movzwl -0x1e(%ebp),%edi
   1591c:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
   15920:	89 45 e4             	mov    %eax,-0x1c(%ebp)
   15923:	6a 00                	push   $0x0
   15925:	53                   	push   %ebx
   15926:	57                   	push   %edi
   15927:	ff 75 e4             	push   -0x1c(%ebp)
   1592a:	e8 b4 fd ff ff       	call   156e3 <pci_conf_read_dword>
   1592f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                if ((dev_ven & 0xffff) == 0xffff)
   15932:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
   15936:	83 c4 10             	add    $0x10,%esp
   15939:	3d ff ff 00 00       	cmp    $0xffff,%eax
   1593e:	74 6d                	je     159ad <pci_dev_find+0xce>
                    continue;
                u8 htype = pci_conf_read_byte(bus, dev, func, 0xe);
   15940:	6a 0e                	push   $0xe
   15942:	53                   	push   %ebx
   15943:	57                   	push   %edi
   15944:	ff 75 e4             	push   -0x1c(%ebp)
   15947:	e8 09 fe ff ff       	call   15755 <pci_conf_read_byte>
   1594c:	88 45 dd             	mov    %al,-0x23(%ebp)
                if ((htype & 0x7f) > 2)
   1594f:	83 e0 7f             	and    $0x7f,%eax
   15952:	88 45 dc             	mov    %al,-0x24(%ebp)
   15955:	83 c4 10             	add    $0x10,%esp
   15958:	3c 02                	cmp    $0x2,%al
   1595a:	77 51                	ja     159ad <pci_dev_find+0xce>
                    continue;
                if (!mf)
   1595c:	80 7d e1 00          	cmpb   $0x0,-0x1f(%ebp)
   15960:	75 09                	jne    1596b <pci_dev_find+0x8c>
                    mf = (htype & 0x80) == 0x80;
   15962:	8a 45 dd             	mov    -0x23(%ebp),%al
   15965:	c0 e8 07             	shr    $0x7,%al
   15968:	88 45 e1             	mov    %al,-0x1f(%ebp)

                u32 class_rev;
                if (by_id)
   1596b:	80 7d e0 00          	cmpb   $0x0,-0x20(%ebp)
   1596f:	74 21                	je     15992 <pci_dev_find+0xb3>
                {
                    if (dev_ven == target)
   15971:	8b 55 d4             	mov    -0x2c(%ebp),%edx
   15974:	39 55 d8             	cmp    %edx,-0x28(%ebp)
   15977:	74 08                	je     15981 <pci_dev_find+0xa2>
                    info->progif = (class_rev >> 8) & 0xff;
                    info->rev = class_rev & 0xff;
                    return true;
                }

                if (!mf)
   15979:	80 7d e1 00          	cmpb   $0x0,-0x1f(%ebp)
   1597d:	75 2e                	jne    159ad <pci_dev_find+0xce>
   1597f:	eb 36                	jmp    159b7 <pci_dev_find+0xd8>
                        class_rev = pci_conf_read_dword(bus, dev, func, 0x2);
   15981:	6a 02                	push   $0x2
   15983:	53                   	push   %ebx
   15984:	57                   	push   %edi
   15985:	ff 75 e4             	push   -0x1c(%ebp)
   15988:	e8 56 fd ff ff       	call   156e3 <pci_conf_read_dword>
   1598d:	83 c4 10             	add    $0x10,%esp
   15990:	eb 36                	jmp    159c8 <pci_dev_find+0xe9>
                    class_rev = pci_conf_read_dword(bus, dev, func, 0x2);
   15992:	6a 02                	push   $0x2
   15994:	53                   	push   %ebx
   15995:	57                   	push   %edi
   15996:	ff 75 e4             	push   -0x1c(%ebp)
   15999:	e8 45 fd ff ff       	call   156e3 <pci_conf_read_dword>
                    if ((class_rev >> 16) == target)
   1599e:	89 c1                	mov    %eax,%ecx
   159a0:	c1 e9 10             	shr    $0x10,%ecx
   159a3:	83 c4 10             	add    $0x10,%esp
   159a6:	3b 4d d8             	cmp    -0x28(%ebp),%ecx
   159a9:	75 ce                	jne    15979 <pci_dev_find+0x9a>
   159ab:	eb 1b                	jmp    159c8 <pci_dev_find+0xe9>
            for (func = 0; func <= 7; ++func)
   159ad:	43                   	inc    %ebx
   159ae:	83 fb 08             	cmp    $0x8,%ebx
   159b1:	0f 85 6c ff ff ff    	jne    15923 <pci_dev_find+0x44>
        for (dev = 0; dev <= 31; ++dev)
   159b7:	66 ff 45 e2          	incw   -0x1e(%ebp)
   159bb:	66 83 7d e2 20       	cmpw   $0x20,-0x1e(%ebp)
   159c0:	0f 85 4c ff ff ff    	jne    15912 <pci_dev_find+0x33>
   159c6:	eb 3a                	jmp    15a02 <pci_dev_find+0x123>
                    info->bus = bus;
   159c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
   159cb:	89 16                	mov    %edx,(%esi)
                    info->dev = dev;
   159cd:	89 7e 04             	mov    %edi,0x4(%esi)
                    info->func = func;
   159d0:	89 5e 08             	mov    %ebx,0x8(%esi)
                    info->mf = (htype & 0x80) == 0x80;
   159d3:	8a 4d dd             	mov    -0x23(%ebp),%cl
   159d6:	c0 e9 07             	shr    $0x7,%cl
   159d9:	88 4e 0d             	mov    %cl,0xd(%esi)
                    info->type = htype & 0x7f;
   159dc:	8a 55 dc             	mov    -0x24(%ebp),%dl
   159df:	88 56 0c             	mov    %dl,0xc(%esi)
                    info->ven_id = dev_ven & 0xffff;
   159e2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
   159e5:	89 7e 0e             	mov    %edi,0xe(%esi)
                    info->class = class_rev >> 24;
   159e8:	89 c1                	mov    %eax,%ecx
   159ea:	c1 e9 18             	shr    $0x18,%ecx
   159ed:	88 4e 13             	mov    %cl,0x13(%esi)
                    info->subclass = (class_rev >> 16) & 0xff;
   159f0:	89 c1                	mov    %eax,%ecx
   159f2:	c1 e9 10             	shr    $0x10,%ecx
   159f5:	88 4e 14             	mov    %cl,0x14(%esi)
                    info->progif = (class_rev >> 8) & 0xff;
   159f8:	88 66 15             	mov    %ah,0x15(%esi)
                    info->rev = class_rev & 0xff;
   159fb:	88 46 12             	mov    %al,0x12(%esi)
                    return true;
   159fe:	b0 01                	mov    $0x1,%al
   15a00:	eb 19                	jmp    15a1b <pci_dev_find+0x13c>
    for (bus = 0; bus <= _pci_conf->last_bus; ++bus)
   15a02:	66 ff 45 de          	incw   -0x22(%ebp)
   15a06:	a1 40 00 02 00       	mov    0x20040,%eax
   15a0b:	0f b6 40 03          	movzbl 0x3(%eax),%eax
   15a0f:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
   15a13:	0f 83 f3 fe ff ff    	jae    1590c <pci_dev_find+0x2d>
                    break;
            }
        }
    }

    return false;
   15a19:	31 c0                	xor    %eax,%eax
}
   15a1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
   15a1e:	5b                   	pop    %ebx
   15a1f:	5e                   	pop    %esi
   15a20:	5f                   	pop    %edi
   15a21:	5d                   	pop    %ebp
   15a22:	c3                   	ret    

00015a23 <pci_decode_bar>:

void pci_decode_bar(const struct pci_dev_info *dev_info, u32 bar, struct pci_bar_info *bar_info)
{
   15a23:	55                   	push   %ebp
   15a24:	89 e5                	mov    %esp,%ebp
   15a26:	57                   	push   %edi
   15a27:	56                   	push   %esi
   15a28:	53                   	push   %ebx
   15a29:	83 ec 1c             	sub    $0x1c,%esp
   15a2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
   15a2f:	8b 75 10             	mov    0x10(%ebp),%esi
    bar_info->type = PCI_BAR_TYPE_NONE;
   15a32:	c6 06 00             	movb   $0x0,(%esi)

    if (bar > 5)
   15a35:	83 7d 0c 05          	cmpl   $0x5,0xc(%ebp)
   15a39:	0f 87 5c 01 00 00    	ja     15b9b <pci_decode_bar+0x178>
        return;

    u32 idx = 4 + bar;
   15a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
   15a42:	8d 78 04             	lea    0x4(%eax),%edi

    u32 base = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, idx);
   15a45:	57                   	push   %edi
   15a46:	ff 73 08             	push   0x8(%ebx)
   15a49:	ff 73 04             	push   0x4(%ebx)
   15a4c:	ff 33                	push   (%ebx)
   15a4e:	e8 90 fc ff ff       	call   156e3 <pci_conf_read_dword>
   15a53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if ((base & 0x2) == 0x2)
   15a56:	83 c4 10             	add    $0x10,%esp
   15a59:	a8 02                	test   $0x2,%al
   15a5b:	0f 85 3a 01 00 00    	jne    15b9b <pci_decode_bar+0x178>
        return;

    if ((base & 0x1) == 0x1)
    {
        pci_conf_write_dword(dev_info->bus, dev_info->dev, dev_info->func, idx, 0xffffffff);
   15a61:	8b 4b 08             	mov    0x8(%ebx),%ecx
   15a64:	8b 53 04             	mov    0x4(%ebx),%edx
   15a67:	8b 03                	mov    (%ebx),%eax
    if ((base & 0x1) == 0x1)
   15a69:	f6 45 e4 01          	testb  $0x1,-0x1c(%ebp)
   15a6d:	74 7d                	je     15aec <pci_decode_bar+0xc9>
        pci_conf_write_dword(dev_info->bus, dev_info->dev, dev_info->func, idx, 0xffffffff);
   15a6f:	83 ec 0c             	sub    $0xc,%esp
   15a72:	6a ff                	push   $0xffffffff
   15a74:	57                   	push   %edi
   15a75:	51                   	push   %ecx
   15a76:	52                   	push   %edx
   15a77:	50                   	push   %eax
   15a78:	e8 2c fd ff ff       	call   157a9 <pci_conf_write_dword>
        u32 size = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, idx);
   15a7d:	83 c4 20             	add    $0x20,%esp
   15a80:	57                   	push   %edi
   15a81:	ff 73 08             	push   0x8(%ebx)
   15a84:	ff 73 04             	push   0x4(%ebx)
   15a87:	ff 33                	push   (%ebx)
   15a89:	e8 55 fc ff ff       	call   156e3 <pci_conf_read_dword>
        size = ~(size & 0xfffffffc) + 1;
   15a8e:	83 e0 fc             	and    $0xfffffffc,%eax
   15a91:	89 c2                	mov    %eax,%edx
   15a93:	f7 da                	neg    %edx
        if (size > 256)
   15a95:	83 c4 10             	add    $0x10,%esp
   15a98:	81 fa 00 01 00 00    	cmp    $0x100,%edx
   15a9e:	89 55 e0             	mov    %edx,-0x20(%ebp)
   15aa1:	0f 87 f4 00 00 00    	ja     15b9b <pci_decode_bar+0x178>
            return;
        pci_conf_write_dword(dev_info->bus, dev_info->dev, dev_info->func, idx, base);
   15aa7:	83 ec 0c             	sub    $0xc,%esp
   15aaa:	ff 75 e4             	push   -0x1c(%ebp)
   15aad:	57                   	push   %edi
   15aae:	ff 73 08             	push   0x8(%ebx)
   15ab1:	ff 73 04             	push   0x4(%ebx)
   15ab4:	ff 33                	push   (%ebx)
   15ab6:	e8 ee fc ff ff       	call   157a9 <pci_conf_write_dword>
        if (pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, idx) != base)
   15abb:	83 c4 20             	add    $0x20,%esp
   15abe:	57                   	push   %edi
   15abf:	ff 73 08             	push   0x8(%ebx)
   15ac2:	ff 73 04             	push   0x4(%ebx)
   15ac5:	ff 33                	push   (%ebx)
   15ac7:	e8 17 fc ff ff       	call   156e3 <pci_conf_read_dword>
   15acc:	83 c4 10             	add    $0x10,%esp
   15acf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
   15ad2:	0f 85 c3 00 00 00    	jne    15b9b <pci_decode_bar+0x178>
            return;
        bar_info->base = base & 0xfffffffc;
   15ad8:	83 e0 fc             	and    $0xfffffffc,%eax
   15adb:	89 46 04             	mov    %eax,0x4(%esi)
        bar_info->size = size;
   15ade:	8b 55 e0             	mov    -0x20(%ebp),%edx
   15ae1:	89 56 08             	mov    %edx,0x8(%esi)
        bar_info->type = PCI_BAR_TYPE_PIO;
   15ae4:	c6 06 01             	movb   $0x1,(%esi)
   15ae7:	e9 af 00 00 00       	jmp    15b9b <pci_decode_bar+0x178>
    }
    else
    {
        // only support Type 0 Configuration
        pci_conf_write_dword(dev_info->bus, dev_info->dev, dev_info->func, idx, 0xffffffff);
   15aec:	83 ec 0c             	sub    $0xc,%esp
   15aef:	6a ff                	push   $0xffffffff
   15af1:	57                   	push   %edi
   15af2:	51                   	push   %ecx
   15af3:	52                   	push   %edx
   15af4:	50                   	push   %eax
   15af5:	e8 af fc ff ff       	call   157a9 <pci_conf_write_dword>
        u32 size_low = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, idx);
   15afa:	83 c4 20             	add    $0x20,%esp
   15afd:	57                   	push   %edi
   15afe:	ff 73 08             	push   0x8(%ebx)
   15b01:	ff 73 04             	push   0x4(%ebx)
   15b04:	ff 33                	push   (%ebx)
   15b06:	e8 d8 fb ff ff       	call   156e3 <pci_conf_read_dword>
        if(size_low == 0) return;
   15b0b:	83 c4 10             	add    $0x10,%esp
   15b0e:	85 c0                	test   %eax,%eax
   15b10:	0f 84 85 00 00 00    	je     15b9b <pci_decode_bar+0x178>
        if((size_low & 0x4) == 0x4) {
   15b16:	89 c7                	mov    %eax,%edi
   15b18:	83 e7 f0             	and    $0xfffffff0,%edi
   15b1b:	a8 04                	test   $0x4,%al
   15b1d:	74 59                	je     15b78 <pci_decode_bar+0x155>
            pci_conf_write_dword(dev_info->bus, dev_info->dev, dev_info->func, idx + 1, 0xffffffff);
   15b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
   15b22:	83 c0 05             	add    $0x5,%eax
   15b25:	83 ec 0c             	sub    $0xc,%esp
   15b28:	6a ff                	push   $0xffffffff
   15b2a:	50                   	push   %eax
   15b2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
   15b2e:	ff 73 08             	push   0x8(%ebx)
   15b31:	ff 73 04             	push   0x4(%ebx)
   15b34:	ff 33                	push   (%ebx)
   15b36:	e8 6e fc ff ff       	call   157a9 <pci_conf_write_dword>
            u32 size_hi = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, idx + 1);
   15b3b:	83 c4 20             	add    $0x20,%esp
   15b3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
   15b41:	50                   	push   %eax
   15b42:	ff 73 08             	push   0x8(%ebx)
   15b45:	ff 73 04             	push   0x4(%ebx)
   15b48:	ff 33                	push   (%ebx)
   15b4a:	e8 94 fb ff ff       	call   156e3 <pci_conf_read_dword>
   15b4f:	89 c1                	mov    %eax,%ecx
            // if(size_hi == 0) return;
            u64 size = (u64)size_hi << 32 | (size_low & 0xfffffff0);
   15b51:	89 f8                	mov    %edi,%eax
   15b53:	89 ca                	mov    %ecx,%edx
            size = ~size + 1;
   15b55:	f7 d8                	neg    %eax
   15b57:	83 d2 00             	adc    $0x0,%edx
   15b5a:	f7 da                	neg    %edx
            if(size == 0) return;
   15b5c:	83 c4 10             	add    $0x10,%esp
   15b5f:	89 d1                	mov    %edx,%ecx
   15b61:	09 c1                	or     %eax,%ecx
   15b63:	74 36                	je     15b9b <pci_decode_bar+0x178>
            bar_info->size = 0;
   15b65:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
            bar_info->size64 = size;
   15b6c:	89 46 10             	mov    %eax,0x10(%esi)
   15b6f:	89 56 14             	mov    %edx,0x14(%esi)
            bar_info->mmio_64bits = true;
   15b72:	c6 46 0c 01          	movb   $0x1,0xc(%esi)
   15b76:	eb 19                	jmp    15b91 <pci_decode_bar+0x16e>
        } else {
            size_low = ~(size_low & 0xfffffff0) + 1;
            if(size_low == 0) return;
   15b78:	f7 df                	neg    %edi
   15b7a:	74 1f                	je     15b9b <pci_decode_bar+0x178>
            bar_info->size64 = 0;
   15b7c:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
   15b83:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
            bar_info->mmio_64bits = false;
   15b8a:	c6 46 0c 00          	movb   $0x0,0xc(%esi)
            bar_info->size = size_low;
   15b8e:	89 7e 08             	mov    %edi,0x8(%esi)
        }

        bar_info->base = 0;
   15b91:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
        // bar_info->size = 0;
        bar_info->type = PCI_BAR_TYPE_MMIO;
   15b98:	c6 06 02             	movb   $0x2,(%esi)
        // bar_info->base = base & 0xfffffff0;
        // bar_info->size = ~(size & 0xfffffff0) + 1;
    }
}
   15b9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
   15b9e:	5b                   	pop    %ebx
   15b9f:	5e                   	pop    %esi
   15ba0:	5f                   	pop    %edi
   15ba1:	5d                   	pop    %ebp
   15ba2:	c3                   	ret    

00015ba3 <pic_irq_mask>:
#include "io.h"

static pic_irq_entry _irq_entry[15];

static void pic_irq_mask(u16 on, u16 off)
{
   15ba3:	55                   	push   %ebp
   15ba4:	89 e5                	mov    %esp,%ebp
   15ba6:	53                   	push   %ebx
   15ba7:	89 c1                	mov    %eax,%ecx
    __asm__ volatile("inb %1, %0"
   15ba9:	e4 21                	in     $0x21,%al
    u8 master_on = on, master_off = off, slave_on = on >> 8, slave_off = off >> 8;
    port_write_byte(PIC_PORT_DATA_MASTER, (port_read_byte(PIC_PORT_DATA_MASTER) | master_off) & ~master_on);
   15bab:	09 d0                	or     %edx,%eax
   15bad:	88 cb                	mov    %cl,%bl
   15baf:	f7 d3                	not    %ebx
   15bb1:	21 d8                	and    %ebx,%eax
    __asm__ volatile("outb %0, %1"
   15bb3:	e6 21                	out    %al,$0x21
    __asm__ volatile("inb %1, %0"
   15bb5:	e4 a1                	in     $0xa1,%al
    u8 master_on = on, master_off = off, slave_on = on >> 8, slave_off = off >> 8;
   15bb7:	66 c1 ea 08          	shr    $0x8,%dx
    port_write_byte(PIC_PORT_DATA_SLAVE, (port_read_byte(PIC_PORT_DATA_SLAVE) | slave_off) & ~slave_on);
   15bbb:	09 d0                	or     %edx,%eax
    u8 master_on = on, master_off = off, slave_on = on >> 8, slave_off = off >> 8;
   15bbd:	66 c1 e9 08          	shr    $0x8,%cx
    port_write_byte(PIC_PORT_DATA_SLAVE, (port_read_byte(PIC_PORT_DATA_SLAVE) | slave_off) & ~slave_on);
   15bc1:	f7 d1                	not    %ecx
   15bc3:	21 c8                	and    %ecx,%eax
    __asm__ volatile("outb %0, %1"
   15bc5:	e6 a1                	out    %al,$0xa1
}
   15bc7:	5b                   	pop    %ebx
   15bc8:	5d                   	pop    %ebp
   15bc9:	c3                   	ret    

00015bca <pic_irq_common_handler>:
    irr_map |= port_read_byte(PIC_PORT_CMD_MASTER);
    return irr_map;
}

void pic_irq_common_handler(u8 irq)
{
   15bca:	55                   	push   %ebp
   15bcb:	89 e5                	mov    %esp,%ebp
   15bcd:	57                   	push   %edi
   15bce:	56                   	push   %esi
   15bcf:	53                   	push   %ebx
   15bd0:	83 ec 0c             	sub    $0xc,%esp
   15bd3:	8b 5d 08             	mov    0x8(%ebp),%ebx
    // print_str("\nenter pic_irq_common_handler\n");

    if (_irq_entry[irq])
   15bd6:	0f b6 f3             	movzbl %bl,%esi
   15bd9:	8b 04 b5 60 00 02 00 	mov    0x20060(,%esi,4),%eax
   15be0:	85 c0                	test   %eax,%eax
   15be2:	74 04                	je     15be8 <pic_irq_common_handler+0x1e>
        _irq_entry[irq]();
   15be4:	ff d0                	call   *%eax
   15be6:	eb 65                	jmp    15c4d <pic_irq_common_handler+0x83>
    else
    {
        // pic_irr_read();
        console_set_color(COLOR_NORMAL_BG, COLOR_LIGHT_RED);
   15be8:	51                   	push   %ecx
   15be9:	51                   	push   %ecx
   15bea:	68 00 00 ff 00       	push   $0xff0000
   15bef:	6a 00                	push   $0x0
   15bf1:	e8 9a cb ff ff       	call   12790 <console_set_color>
   15bf6:	b1 0b                	mov    $0xb,%cl
   15bf8:	88 c8                	mov    %cl,%al
   15bfa:	e6 a0                	out    %al,$0xa0
    __asm__ volatile("inb %1, %0"
   15bfc:	e4 a0                	in     $0xa0,%al
   15bfe:	0f b6 d0             	movzbl %al,%edx
    if (!isr)
   15c01:	83 c4 10             	add    $0x10,%esp
   15c04:	84 d2                	test   %dl,%dl
   15c06:	75 09                	jne    15c11 <pic_irq_common_handler+0x47>
    __asm__ volatile("outb %0, %1"
   15c08:	88 c8                	mov    %cl,%al
   15c0a:	e6 20                	out    %al,$0x20
    __asm__ volatile("inb %1, %0"
   15c0c:	e4 20                	in     $0x20,%al
   15c0e:	0f b6 d0             	movzbl %al,%edx
    __asm__ volatile("outb %0, %1"
   15c11:	bf 0a 00 00 00       	mov    $0xa,%edi
   15c16:	89 f8                	mov    %edi,%eax
   15c18:	e6 a0                	out    %al,$0xa0
    __asm__ volatile("inb %1, %0"
   15c1a:	e4 a0                	in     $0xa0,%al
    irr_map = (u16)port_read_byte(PIC_PORT_CMD_SLAVE) << 8;
   15c1c:	89 c1                	mov    %eax,%ecx
   15c1e:	c1 e1 08             	shl    $0x8,%ecx
    __asm__ volatile("outb %0, %1"
   15c21:	89 f8                	mov    %edi,%eax
   15c23:	e6 20                	out    %al,$0x20
    __asm__ volatile("inb %1, %0"
   15c25:	e4 20                	in     $0x20,%al
        printf("\nIRQ%d not registered!\nirr=0x%x, isr=0x%x\n", irq, pic_irr_read(), pic_isr_read());
   15c27:	52                   	push   %edx
    irr_map |= port_read_byte(PIC_PORT_CMD_MASTER);
   15c28:	0f b6 c0             	movzbl %al,%eax
   15c2b:	09 c8                	or     %ecx,%eax
        printf("\nIRQ%d not registered!\nirr=0x%x, isr=0x%x\n", irq, pic_irr_read(), pic_isr_read());
   15c2d:	0f b7 c0             	movzwl %ax,%eax
   15c30:	50                   	push   %eax
   15c31:	56                   	push   %esi
   15c32:	68 24 99 01 00       	push   $0x19924
   15c37:	e8 be d2 ff ff       	call   12efa <printf>
        // print_str("\nIRQ");
        // print_hex(irq, 4);
        // print_hex(pic_isr_read(), 4);
        // print_str(" entry not registered\n");
        console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
   15c3c:	58                   	pop    %eax
   15c3d:	5a                   	pop    %edx
   15c3e:	68 d3 d3 d3 00       	push   $0xd3d3d3
   15c43:	6a 00                	push   $0x0
   15c45:	e8 46 cb ff ff       	call   12790 <console_set_color>
   15c4a:	83 c4 10             	add    $0x10,%esp
    if (irq >= 8)
   15c4d:	80 fb 07             	cmp    $0x7,%bl
   15c50:	76 04                	jbe    15c56 <pic_irq_common_handler+0x8c>
    __asm__ volatile("outb %0, %1"
   15c52:	b0 20                	mov    $0x20,%al
   15c54:	e6 a0                	out    %al,$0xa0
   15c56:	b0 20                	mov    $0x20,%al
   15c58:	e6 20                	out    %al,$0x20
    }

    pic_eoi(irq);
}
   15c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
   15c5d:	5b                   	pop    %ebx
   15c5e:	5e                   	pop    %esi
   15c5f:	5f                   	pop    %edi
   15c60:	5d                   	pop    %ebp
   15c61:	c3                   	ret    

00015c62 <pic_setup>:
   15c62:	b0 11                	mov    $0x11,%al
   15c64:	e6 20                	out    %al,$0x20
   15c66:	e6 a0                	out    %al,$0xa0
   15c68:	b0 20                	mov    $0x20,%al
   15c6a:	e6 21                	out    %al,$0x21
   15c6c:	b0 28                	mov    $0x28,%al
   15c6e:	e6 a1                	out    %al,$0xa1
   15c70:	b0 04                	mov    $0x4,%al
   15c72:	e6 21                	out    %al,$0x21
   15c74:	b0 02                	mov    $0x2,%al
   15c76:	e6 a1                	out    %al,$0xa1
   15c78:	b0 01                	mov    $0x1,%al
   15c7a:	e6 21                	out    %al,$0x21
   15c7c:	e6 a1                	out    %al,$0xa1
    // ICW4
    port_write_byte(PIC_PORT_DATA_MASTER, PIC_ICW4_8086); // 80x86 normal no-buffered seq
    port_write_byte(PIC_PORT_DATA_SLAVE, PIC_ICW4_8086);

    // OCW1
    pic_irq_mask(1 << PIC_IRQ_SLAVE_ATTACH, 0xffff);
   15c7e:	ba ff ff 00 00       	mov    $0xffff,%edx
   15c83:	b8 04 00 00 00       	mov    $0x4,%eax
   15c88:	e9 16 ff ff ff       	jmp    15ba3 <pic_irq_mask>

00015c8d <pic_irq_enable>:
        // write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
    }
}

void pic_irq_enable(u8 irq)
{
   15c8d:	55                   	push   %ebp
   15c8e:	89 e5                	mov    %esp,%ebp
   15c90:	8b 4d 08             	mov    0x8(%ebp),%ecx
    if (irq <= 15 && irq != PIC_IRQ_SLAVE_ATTACH)
   15c93:	80 f9 0f             	cmp    $0xf,%cl
   15c96:	77 21                	ja     15cb9 <pic_irq_enable+0x2c>
   15c98:	80 f9 02             	cmp    $0x2,%cl
   15c9b:	74 1c                	je     15cb9 <pic_irq_enable+0x2c>
    {
        // u32 save_eflags = read_eflags();
        // disable();
        if (_irq_entry[irq] != NULL)
   15c9d:	0f b6 c9             	movzbl %cl,%ecx
   15ca0:	83 3c 8d 60 00 02 00 	cmpl   $0x0,0x20060(,%ecx,4)
   15ca7:	00 
   15ca8:	74 0f                	je     15cb9 <pic_irq_enable+0x2c>
            pic_irq_mask(1 << irq, 0);
   15caa:	b8 01 00 00 00       	mov    $0x1,%eax
   15caf:	d3 e0                	shl    %cl,%eax
   15cb1:	31 d2                	xor    %edx,%edx
        // _irq_entry[irq] = entry;
        // write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
    }
}
   15cb3:	5d                   	pop    %ebp
            pic_irq_mask(1 << irq, 0);
   15cb4:	e9 ea fe ff ff       	jmp    15ba3 <pic_irq_mask>
}
   15cb9:	5d                   	pop    %ebp
   15cba:	c3                   	ret    

00015cbb <pic_irq_disable>:

void pic_irq_disable(u8 irq)
{
   15cbb:	55                   	push   %ebp
   15cbc:	89 e5                	mov    %esp,%ebp
   15cbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
    if (irq <= 15 && irq != PIC_IRQ_SLAVE_ATTACH)
   15cc1:	80 f9 0f             	cmp    $0xf,%cl
   15cc4:	77 14                	ja     15cda <pic_irq_disable+0x1f>
   15cc6:	80 f9 02             	cmp    $0x2,%cl
   15cc9:	74 0f                	je     15cda <pic_irq_disable+0x1f>
    {
        // u32 save_eflags = read_eflags();
        // disable();
        pic_irq_mask(0, 1 << irq);
   15ccb:	ba 01 00 00 00       	mov    $0x1,%edx
   15cd0:	d3 e2                	shl    %cl,%edx
   15cd2:	31 c0                	xor    %eax,%eax
        // _irq_entry[irq] = NULL;
        // write_eflags(read_eflags() | (save_eflags & EFLAGS_IF));
    }
}
   15cd4:	5d                   	pop    %ebp
        pic_irq_mask(0, 1 << irq);
   15cd5:	e9 c9 fe ff ff       	jmp    15ba3 <pic_irq_mask>
}
   15cda:	5d                   	pop    %ebp
   15cdb:	c3                   	ret    

00015cdc <pic_irq_set_entry>:
{
   15cdc:	55                   	push   %ebp
   15cdd:	89 e5                	mov    %esp,%ebp
   15cdf:	53                   	push   %ebx
   15ce0:	50                   	push   %eax
   15ce1:	8b 45 08             	mov    0x8(%ebp),%eax
    if (irq <= 15 && irq != PIC_IRQ_SLAVE_ATTACH)
   15ce4:	3c 0f                	cmp    $0xf,%al
   15ce6:	77 1d                	ja     15d05 <pic_irq_set_entry+0x29>
   15ce8:	3c 02                	cmp    $0x2,%al
   15cea:	74 19                	je     15d05 <pic_irq_set_entry+0x29>
        pic_irq_disable(irq);
   15cec:	0f b6 d8             	movzbl %al,%ebx
   15cef:	83 ec 0c             	sub    $0xc,%esp
   15cf2:	53                   	push   %ebx
   15cf3:	e8 c3 ff ff ff       	call   15cbb <pic_irq_disable>
        _irq_entry[irq] = entry;
   15cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
   15cfb:	89 04 9d 60 00 02 00 	mov    %eax,0x20060(,%ebx,4)
   15d02:	83 c4 10             	add    $0x10,%esp
}
   15d05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   15d08:	c9                   	leave  
   15d09:	c3                   	ret    

00015d0a <pic_irq_remove_entry>:
{
   15d0a:	55                   	push   %ebp
   15d0b:	89 e5                	mov    %esp,%ebp
   15d0d:	53                   	push   %ebx
   15d0e:	50                   	push   %eax
   15d0f:	8b 45 08             	mov    0x8(%ebp),%eax
    if (irq <= 15 && irq != PIC_IRQ_SLAVE_ATTACH)
   15d12:	3c 0f                	cmp    $0xf,%al
   15d14:	77 1e                	ja     15d34 <pic_irq_remove_entry+0x2a>
   15d16:	3c 02                	cmp    $0x2,%al
   15d18:	74 1a                	je     15d34 <pic_irq_remove_entry+0x2a>
        pic_irq_disable(irq);
   15d1a:	0f b6 d8             	movzbl %al,%ebx
   15d1d:	83 ec 0c             	sub    $0xc,%esp
   15d20:	53                   	push   %ebx
   15d21:	e8 95 ff ff ff       	call   15cbb <pic_irq_disable>
        _irq_entry[irq] = NULL;
   15d26:	c7 04 9d 60 00 02 00 	movl   $0x0,0x20060(,%ebx,4)
   15d2d:	00 00 00 00 
   15d31:	83 c4 10             	add    $0x10,%esp
}
   15d34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   15d37:	c9                   	leave  
   15d38:	c3                   	ret    

00015d39 <pit_irq_handler>:

static u32 volatile _ticks; // , _fractions;

static void pit_irq_handler(void)
{
    ++_ticks;
   15d39:	a1 9c 00 02 00       	mov    0x2009c,%eax
   15d3e:	40                   	inc    %eax
   15d3f:	a3 9c 00 02 00       	mov    %eax,0x2009c
    // if(_fractions >= 1193182) {
    //     ++_ticks;
    //     _fractions -= 1193182;
    // }
    // print_char('0');
}
   15d44:	c3                   	ret    

00015d45 <pit_setup>:

void pit_setup(void)
{
   15d45:	55                   	push   %ebp
   15d46:	89 e5                	mov    %esp,%ebp
   15d48:	83 ec 10             	sub    $0x10,%esp
   15d4b:	b0 34                	mov    $0x34,%al
   15d4d:	e6 43                	out    %al,$0x43
   15d4f:	b0 b0                	mov    $0xb0,%al
   15d51:	e6 40                	out    %al,$0x40
   15d53:	b0 04                	mov    $0x4,%al
   15d55:	e6 40                	out    %al,$0x40
    // port_write_byte(PIT_PORT_DATA_CHANNEL0, 0); // LSB
    // port_write_byte(PIT_PORT_DATA_CHANNEL0, 0); // MSB
    port_write_byte(PIT_PORT_DATA_CHANNEL0, 0xB0); // LSB
    port_write_byte(PIT_PORT_DATA_CHANNEL0, 0x04); // MSB

    pic_irq_set_entry(PIT_IRQ, pit_irq_handler);
   15d57:	68 39 5d 01 00       	push   $0x15d39
   15d5c:	6a 00                	push   $0x0
   15d5e:	e8 79 ff ff ff       	call   15cdc <pic_irq_set_entry>
    pic_irq_enable(PIT_IRQ);
   15d63:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
   15d6a:	e8 1e ff ff ff       	call   15c8d <pic_irq_enable>
    // port_write_byte(PIT_PORT_DATA_CHANNEL2, 0xA9);
    // port_write_byte(PIT_PORT_DATA_CHANNEL2, 0x04);
    port_write_byte(PIT_PORT_DATA_CHANNEL2, 0);
    port_write_byte(PIT_PORT_DATA_CHANNEL2, 0);
    */
}
   15d6f:	83 c4 10             	add    $0x10,%esp
   15d72:	c9                   	leave  
   15d73:	c3                   	ret    

00015d74 <pit_get_ticks>:
}
*/

u32 pit_get_ticks(void)
{
    return _ticks;
   15d74:	a1 9c 00 02 00       	mov    0x2009c,%eax
}
   15d79:	c3                   	ret    

00015d7a <read_dsp>:
static bool _present;
static u16 _io_base;
static u8 _irq, _dma_8, _dma_16;

inline static u8 read_dsp(u8 reg)
{
   15d7a:	55                   	push   %ebp
   15d7b:	89 e5                	mov    %esp,%ebp
   15d7d:	53                   	push   %ebx
   15d7e:	89 c1                	mov    %eax,%ecx
    {
        while ((port_read_byte(_io_base + SB16_PORT_DSP_R_STATUS) & 0x80) == 0)
            ;
    }

    return port_read_byte(_io_base + reg);
   15d80:	66 8b 1d a8 00 02 00 	mov    0x200a8,%bx
    if (reg == SB16_PORT_DSP_READ)
   15d87:	3c 0a                	cmp    $0xa,%al
   15d89:	75 08                	jne    15d93 <read_dsp+0x19>
        while ((port_read_byte(_io_base + SB16_PORT_DSP_R_STATUS) & 0x80) == 0)
   15d8b:	8d 53 0e             	lea    0xe(%ebx),%edx
    __asm__ volatile("inb %1, %0"
   15d8e:	ec                   	in     (%dx),%al
   15d8f:	84 c0                	test   %al,%al
   15d91:	79 fb                	jns    15d8e <read_dsp+0x14>
    return port_read_byte(_io_base + reg);
   15d93:	0f b6 d1             	movzbl %cl,%edx
   15d96:	01 da                	add    %ebx,%edx
   15d98:	ec                   	in     (%dx),%al
}
   15d99:	5b                   	pop    %ebx
   15d9a:	5d                   	pop    %ebp
   15d9b:	c3                   	ret    

00015d9c <write_dsp>:

static void write_dsp(u8 reg, u8 data)
{
   15d9c:	55                   	push   %ebp
   15d9d:	89 e5                	mov    %esp,%ebp
   15d9f:	56                   	push   %esi
   15da0:	53                   	push   %ebx
   15da1:	89 c1                	mov    %eax,%ecx
   15da3:	89 d3                	mov    %edx,%ebx
    {
        while (port_read_byte(_io_base + SB16_PORT_DSP_W_STATUS) & 0x80)
            ;
    }

    port_write_byte(_io_base + reg, data);
   15da5:	66 8b 35 a8 00 02 00 	mov    0x200a8,%si
    if (reg == SB16_PORT_DSP_WRITE)
   15dac:	3c 0c                	cmp    $0xc,%al
   15dae:	75 08                	jne    15db8 <write_dsp+0x1c>
        while (port_read_byte(_io_base + SB16_PORT_DSP_W_STATUS) & 0x80)
   15db0:	8d 56 0c             	lea    0xc(%esi),%edx
   15db3:	ec                   	in     (%dx),%al
   15db4:	84 c0                	test   %al,%al
   15db6:	78 fb                	js     15db3 <write_dsp+0x17>
    port_write_byte(_io_base + reg, data);
   15db8:	0f b6 d1             	movzbl %cl,%edx
   15dbb:	01 f2                	add    %esi,%edx
    __asm__ volatile("outb %0, %1"
   15dbd:	88 d8                	mov    %bl,%al
   15dbf:	ee                   	out    %al,(%dx)
}
   15dc0:	5b                   	pop    %ebx
   15dc1:	5e                   	pop    %esi
   15dc2:	5d                   	pop    %ebp
   15dc3:	c3                   	ret    

00015dc4 <write_dsp_cmd>:

static void write_dsp_cmd(u8 data)
{
    write_dsp(SB16_PORT_DSP_WRITE, data);
   15dc4:	0f b6 d0             	movzbl %al,%edx
   15dc7:	b8 0c 00 00 00       	mov    $0xc,%eax
   15dcc:	eb ce                	jmp    15d9c <write_dsp>

00015dce <write_mixer>:
    // delay_ms(1);
    return read_dsp(SB16_PORT_MIXER_DATA);
}

inline static void write_mixer(u8 reg, u8 data)
{
   15dce:	55                   	push   %ebp
   15dcf:	89 e5                	mov    %esp,%ebp
   15dd1:	53                   	push   %ebx
   15dd2:	51                   	push   %ecx
   15dd3:	89 d3                	mov    %edx,%ebx
    write_dsp(SB16_PORT_MIXER_REG, reg);
   15dd5:	0f b6 d0             	movzbl %al,%edx
   15dd8:	b8 04 00 00 00       	mov    $0x4,%eax
   15ddd:	e8 ba ff ff ff       	call   15d9c <write_dsp>
    // delay_ms(1);
    write_dsp(SB16_PORT_MIXER_DATA, data);
   15de2:	0f b6 d3             	movzbl %bl,%edx
   15de5:	b8 05 00 00 00       	mov    $0x5,%eax
}
   15dea:	5b                   	pop    %ebx
   15deb:	5b                   	pop    %ebx
   15dec:	5d                   	pop    %ebp
    write_dsp(SB16_PORT_MIXER_DATA, data);
   15ded:	eb ad                	jmp    15d9c <write_dsp>

00015def <_irq_handler>:
static volatile bool _end_of_data;
static volatile bool _last_block_played;

// static volatile bool _second_last_block_played;
static void _irq_handler(void)
{
   15def:	55                   	push   %ebp
   15df0:	89 e5                	mov    %esp,%ebp
   15df2:	83 ec 08             	sub    $0x8,%esp
    write_dsp(SB16_PORT_MIXER_REG, reg);
   15df5:	ba 82 00 00 00       	mov    $0x82,%edx
   15dfa:	b8 04 00 00 00       	mov    $0x4,%eax
   15dff:	e8 98 ff ff ff       	call   15d9c <write_dsp>
    return read_dsp(SB16_PORT_MIXER_DATA);
   15e04:	b8 05 00 00 00       	mov    $0x5,%eax
   15e09:	e8 6c ff ff ff       	call   15d7a <read_dsp>
    u8 intr_status = read_mixer(0x82); // Interrupt Status

    // printf("SB16._irq_handler intr_status=0x%x\n", intr_status);

    if (_is_16bits)
   15e0e:	80 3d a4 00 02 00 00 	cmpb   $0x0,0x200a4
   15e15:	74 0b                	je     15e22 <_irq_handler+0x33>
    {
        if (intr_status & 2)
   15e17:	a8 02                	test   $0x2,%al
   15e19:	74 11                	je     15e2c <_irq_handler+0x3d>
            read_dsp(SB16_PORT_DSP_EOI1);
   15e1b:	b8 0f 00 00 00       	mov    $0xf,%eax
   15e20:	eb 05                	jmp    15e27 <_irq_handler+0x38>
    }
    else
        read_dsp(SB16_PORT_DSP_EOI0);
   15e22:	b8 0e 00 00 00       	mov    $0xe,%eax
   15e27:	e8 4e ff ff ff       	call   15d7a <read_dsp>
    // {
    //     // read_dsp(SB16_PORT_DSP_EOI2);
    //     printf("\nunexpecting sb16 intr_status: 0x%x\n", intr_status);
    // }

    _first_block_playing = !_first_block_playing;
   15e2c:	a0 a3 00 02 00       	mov    0x200a3,%al
   15e31:	83 f0 01             	xor    $0x1,%eax
   15e34:	a2 a3 00 02 00       	mov    %al,0x200a3
    // {
    //     print_char('?');
    //     _last_block_played = true;
    // }

    if (_end_of_data)
   15e39:	a0 a1 00 02 00       	mov    0x200a1,%al
   15e3e:	84 c0                	test   %al,%al
   15e40:	74 07                	je     15e49 <_irq_handler+0x5a>
    {
        // print_char('#');
        // _second_last_block_played = true;
        _last_block_played = true;
   15e42:	c6 05 a0 00 02 00 01 	movb   $0x1,0x200a0
    }
}
   15e49:	c9                   	leave  
   15e4a:	c3                   	ret    

00015e4b <reset_dsp>:
{
   15e4b:	55                   	push   %ebp
   15e4c:	89 e5                	mov    %esp,%ebp
   15e4e:	53                   	push   %ebx
   15e4f:	50                   	push   %eax
    write_dsp(SB16_PORT_DSP_RESET, 1);
   15e50:	ba 01 00 00 00       	mov    $0x1,%edx
   15e55:	b8 06 00 00 00       	mov    $0x6,%eax
   15e5a:	e8 3d ff ff ff       	call   15d9c <write_dsp>
    delay_ms(3);
   15e5f:	83 ec 0c             	sub    $0xc,%esp
   15e62:	6a 03                	push   $0x3
   15e64:	e8 2c f0 ff ff       	call   14e95 <delay_ms>
    write_dsp(SB16_PORT_DSP_RESET, 0);
   15e69:	31 d2                	xor    %edx,%edx
   15e6b:	b8 06 00 00 00       	mov    $0x6,%eax
   15e70:	e8 27 ff ff ff       	call   15d9c <write_dsp>
   15e75:	83 c4 10             	add    $0x10,%esp
   15e78:	bb ff ff 00 00       	mov    $0xffff,%ebx
        if (read_dsp(SB16_PORT_DSP_R_STATUS) & 0x80)
   15e7d:	b8 0e 00 00 00       	mov    $0xe,%eax
   15e82:	e8 f3 fe ff ff       	call   15d7a <read_dsp>
   15e87:	84 c0                	test   %al,%al
   15e89:	78 07                	js     15e92 <reset_dsp+0x47>
    for (int i = 0; i < 65535; ++i)
   15e8b:	4b                   	dec    %ebx
   15e8c:	75 ef                	jne    15e7d <reset_dsp+0x32>
    return false;
   15e8e:	31 c0                	xor    %eax,%eax
   15e90:	eb 10                	jmp    15ea2 <reset_dsp+0x57>
            if (read_dsp(SB16_PORT_DSP_READ) == 0xaa)
   15e92:	b8 0a 00 00 00       	mov    $0xa,%eax
   15e97:	e8 de fe ff ff       	call   15d7a <read_dsp>
   15e9c:	3c aa                	cmp    $0xaa,%al
   15e9e:	75 eb                	jne    15e8b <reset_dsp+0x40>
                return true;
   15ea0:	b0 01                	mov    $0x1,%al
}
   15ea2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
   15ea5:	c9                   	leave  
   15ea6:	c3                   	ret    

00015ea7 <sb16_setup>:

void sb16_setup(void)
{
   15ea7:	55                   	push   %ebp
   15ea8:	89 e5                	mov    %esp,%ebp
   15eaa:	57                   	push   %edi
   15eab:	56                   	push   %esi
   15eac:	53                   	push   %ebx
   15ead:	83 ec 2c             	sub    $0x2c,%esp
    for (_io_base = 0x220; _io_base <= 0x280; _io_base += 0x20)
   15eb0:	66 c7 05 a8 00 02 00 	movw   $0x220,0x200a8
   15eb7:	20 02 
        if (reset_dsp())
   15eb9:	e8 8d ff ff ff       	call   15e4b <reset_dsp>
   15ebe:	89 c6                	mov    %eax,%esi
   15ec0:	84 c0                	test   %al,%al
   15ec2:	75 45                	jne    15f09 <sb16_setup+0x62>
    for (_io_base = 0x220; _io_base <= 0x280; _io_base += 0x20)
   15ec4:	66 a1 a8 00 02 00    	mov    0x200a8,%ax
   15eca:	83 c0 20             	add    $0x20,%eax
   15ecd:	66 a3 a8 00 02 00    	mov    %ax,0x200a8
   15ed3:	66 3d 80 02          	cmp    $0x280,%ax
   15ed7:	76 e0                	jbe    15eb9 <sb16_setup+0x12>
    if (!detect_sb16())
    {
        console_set_color(COLOR_NORMAL_BG, COLOR_YELLOW);
   15ed9:	50                   	push   %eax
   15eda:	50                   	push   %eax
   15edb:	68 00 fe fe 00       	push   $0xfefe00
   15ee0:	6a 00                	push   $0x0
   15ee2:	e8 a9 c8 ff ff       	call   12790 <console_set_color>
        printf("SB not detected!\n");
   15ee7:	c7 04 24 c5 99 01 00 	movl   $0x199c5,(%esp)
   15eee:	e8 07 d0 ff ff       	call   12efa <printf>
        console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
   15ef3:	5a                   	pop    %edx
   15ef4:	59                   	pop    %ecx
   15ef5:	68 d3 d3 d3 00       	push   $0xd3d3d3
   15efa:	6a 00                	push   $0x0
   15efc:	e8 8f c8 ff ff       	call   12790 <console_set_color>
        return;
   15f01:	83 c4 10             	add    $0x10,%esp
   15f04:	e9 d9 01 00 00       	jmp    160e2 <sb16_setup+0x23b>
    }

    write_dsp_cmd(0xE1); // Get DSP version
   15f09:	b8 e1 00 00 00       	mov    $0xe1,%eax
   15f0e:	e8 b1 fe ff ff       	call   15dc4 <write_dsp_cmd>
    u16 version = read_dsp(SB16_PORT_DSP_READ) << 8;
   15f13:	b8 0a 00 00 00       	mov    $0xa,%eax
   15f18:	e8 5d fe ff ff       	call   15d7a <read_dsp>
   15f1d:	89 c3                	mov    %eax,%ebx
   15f1f:	c1 e3 08             	shl    $0x8,%ebx
    version |= read_dsp(SB16_PORT_DSP_READ);
   15f22:	b8 0a 00 00 00       	mov    $0xa,%eax
   15f27:	e8 4e fe ff ff       	call   15d7a <read_dsp>
            dma_map |= 0x20;
        }
        if (need_setup_dma)
            write_mixer(SB16_MIXER_DMA_SETUP, dma_map);

        printf("SB16 version: %d.%d\niobase: 0x%x\nirq: %d\ndma8: %d\ndma16: %d\n", version >> 8, version & 0xff, _io_base, _irq, _dma_8, _dma_16);
   15f2c:	0f b6 c0             	movzbl %al,%eax
   15f2f:	89 45 cc             	mov    %eax,-0x34(%ebp)
   15f32:	0f b6 c7             	movzbl %bh,%eax
   15f35:	89 45 c8             	mov    %eax,-0x38(%ebp)
    if (version >> 8 >= 4)
   15f38:	66 81 fb 00 03       	cmp    $0x300,%bx
   15f3d:	0f 86 89 01 00 00    	jbe    160cc <sb16_setup+0x225>
    write_mixer(0x00, 0x00);
   15f43:	31 d2                	xor    %edx,%edx
   15f45:	31 c0                	xor    %eax,%eax
   15f47:	e8 82 fe ff ff       	call   15dce <write_mixer>
    delay_ms(10);
   15f4c:	83 ec 0c             	sub    $0xc,%esp
   15f4f:	6a 0a                	push   $0xa
   15f51:	e8 3f ef ff ff       	call   14e95 <delay_ms>
    write_mixer(0x43, 0x1);
   15f56:	ba 01 00 00 00       	mov    $0x1,%edx
   15f5b:	b8 43 00 00 00       	mov    $0x43,%eax
   15f60:	e8 69 fe ff ff       	call   15dce <write_mixer>
    write_dsp(SB16_PORT_MIXER_REG, reg);
   15f65:	ba 80 00 00 00       	mov    $0x80,%edx
   15f6a:	b8 04 00 00 00       	mov    $0x4,%eax
   15f6f:	e8 28 fe ff ff       	call   15d9c <write_dsp>
    return read_dsp(SB16_PORT_MIXER_DATA);
   15f74:	b8 05 00 00 00       	mov    $0x5,%eax
   15f79:	e8 fc fd ff ff       	call   15d7a <read_dsp>
        u8 irq_map = read_mixer(SB16_MIXER_INTR_SETUP) & 0xf; // Interrupt Setup
   15f7e:	83 e0 0f             	and    $0xf,%eax
   15f81:	88 45 d5             	mov    %al,-0x2b(%ebp)
    write_dsp(SB16_PORT_MIXER_REG, reg);
   15f84:	ba 81 00 00 00       	mov    $0x81,%edx
   15f89:	b8 04 00 00 00       	mov    $0x4,%eax
   15f8e:	e8 09 fe ff ff       	call   15d9c <write_dsp>
    return read_dsp(SB16_PORT_MIXER_DATA);
   15f93:	b8 05 00 00 00       	mov    $0x5,%eax
   15f98:	e8 dd fd ff ff       	call   15d7a <read_dsp>
   15f9d:	88 c3                	mov    %al,%bl
        u8 dma_map = read_mixer(SB16_MIXER_DMA_SETUP) & 0xeb; // DMA Setup
   15f9f:	83 e0 eb             	and    $0xffffffeb,%eax
   15fa2:	88 45 d7             	mov    %al,-0x29(%ebp)
        printf("irq_map=0x%x, dma_map=0x%x\n", irq_map, dma_map);
   15fa5:	89 d8                	mov    %ebx,%eax
   15fa7:	25 eb 00 00 00       	and    $0xeb,%eax
   15fac:	89 45 d0             	mov    %eax,-0x30(%ebp)
   15faf:	0f b6 7d d5          	movzbl -0x2b(%ebp),%edi
   15fb3:	83 c4 0c             	add    $0xc,%esp
   15fb6:	50                   	push   %eax
   15fb7:	57                   	push   %edi
   15fb8:	68 4f 99 01 00       	push   $0x1994f
   15fbd:	e8 38 cf ff ff       	call   12efa <printf>
        if (irq_map)
   15fc2:	83 c4 10             	add    $0x10,%esp
            u8 bit = 0;
   15fc5:	c6 45 d6 00          	movb   $0x0,-0x2a(%ebp)
        if (irq_map)
   15fc9:	80 7d d5 00          	cmpb   $0x0,-0x2b(%ebp)
   15fcd:	74 26                	je     15ff5 <sb16_setup+0x14e>
            while (irq_map >> (bit + 1))
   15fcf:	0f b6 55 d6          	movzbl -0x2a(%ebp),%edx
   15fd3:	8d 4a 01             	lea    0x1(%edx),%ecx
   15fd6:	89 f8                	mov    %edi,%eax
   15fd8:	d3 f8                	sar    %cl,%eax
   15fda:	85 c0                	test   %eax,%eax
   15fdc:	74 05                	je     15fe3 <sb16_setup+0x13c>
                ++bit;
   15fde:	fe 45 d6             	incb   -0x2a(%ebp)
   15fe1:	eb ec                	jmp    15fcf <sb16_setup+0x128>
            u8 irqs[] = {2, 5, 7, 10};
   15fe3:	c7 45 e4 02 05 07 0a 	movl   $0xa070502,-0x1c(%ebp)
            _irq = irqs[bit];
   15fea:	8a 44 15 e4          	mov    -0x1c(%ebp,%edx,1),%al
   15fee:	a2 a7 00 02 00       	mov    %al,0x200a7
   15ff3:	eb 16                	jmp    1600b <sb16_setup+0x164>
            _irq = 5;
   15ff5:	c6 05 a7 00 02 00 05 	movb   $0x5,0x200a7
            write_mixer(SB16_MIXER_INTR_SETUP, 0x2);
   15ffc:	ba 02 00 00 00       	mov    $0x2,%edx
   16001:	b8 80 00 00 00       	mov    $0x80,%eax
   16006:	e8 c3 fd ff ff       	call   15dce <write_mixer>
        if (dma_map & 0xb)
   1600b:	80 e3 0b             	and    $0xb,%bl
   1600e:	74 27                	je     16037 <sb16_setup+0x190>
   16010:	8a 0d a6 00 02 00    	mov    0x200a6,%cl
   16016:	31 c0                	xor    %eax,%eax
            while (!(dma_map & (1 << _dma_8)))
   16018:	8b 5d d0             	mov    -0x30(%ebp),%ebx
   1601b:	d3 fb                	sar    %cl,%ebx
   1601d:	88 ca                	mov    %cl,%dl
   1601f:	41                   	inc    %ecx
   16020:	80 e3 01             	and    $0x1,%bl
   16023:	75 04                	jne    16029 <sb16_setup+0x182>
   16025:	89 f0                	mov    %esi,%eax
   16027:	eb ef                	jmp    16018 <sb16_setup+0x171>
   16029:	84 c0                	test   %al,%al
   1602b:	74 06                	je     16033 <sb16_setup+0x18c>
   1602d:	88 15 a6 00 02 00    	mov    %dl,0x200a6
        bool need_setup_dma = false;
   16033:	31 c0                	xor    %eax,%eax
   16035:	eb 0d                	jmp    16044 <sb16_setup+0x19d>
            _dma_8 = 1;
   16037:	c6 05 a6 00 02 00 01 	movb   $0x1,0x200a6
            dma_map |= 0x2;
   1603e:	80 4d d7 02          	orb    $0x2,-0x29(%ebp)
            need_setup_dma = true;
   16042:	89 f0                	mov    %esi,%eax
        _dma_16 = 5;
   16044:	c6 05 a5 00 02 00 05 	movb   $0x5,0x200a5
        if (dma_map & 0xe0)
   1604b:	f6 45 d7 e0          	testb  $0xe0,-0x29(%ebp)
   1604f:	74 1c                	je     1606d <sb16_setup+0x1c6>
   16051:	0f b6 7d d7          	movzbl -0x29(%ebp),%edi
   16055:	b1 05                	mov    $0x5,%cl
   16057:	31 d2                	xor    %edx,%edx
            while (!(dma_map & (1 << _dma_16)))
   16059:	89 fb                	mov    %edi,%ebx
   1605b:	d3 fb                	sar    %cl,%ebx
   1605d:	89 5d d0             	mov    %ebx,-0x30(%ebp)
   16060:	88 cb                	mov    %cl,%bl
   16062:	41                   	inc    %ecx
   16063:	f6 45 d0 01          	testb  $0x1,-0x30(%ebp)
   16067:	75 0a                	jne    16073 <sb16_setup+0x1cc>
   16069:	89 f2                	mov    %esi,%edx
   1606b:	eb ec                	jmp    16059 <sb16_setup+0x1b2>
            dma_map |= 0x20;
   1606d:	80 4d d7 20          	orb    $0x20,-0x29(%ebp)
        if (need_setup_dma)
   16071:	eb 0e                	jmp    16081 <sb16_setup+0x1da>
   16073:	84 d2                	test   %dl,%dl
   16075:	74 06                	je     1607d <sb16_setup+0x1d6>
   16077:	88 1d a5 00 02 00    	mov    %bl,0x200a5
   1607d:	84 c0                	test   %al,%al
   1607f:	74 0e                	je     1608f <sb16_setup+0x1e8>
            write_mixer(SB16_MIXER_DMA_SETUP, dma_map);
   16081:	0f b6 55 d7          	movzbl -0x29(%ebp),%edx
   16085:	b8 81 00 00 00       	mov    $0x81,%eax
   1608a:	e8 3f fd ff ff       	call   15dce <write_mixer>
        printf("SB16 version: %d.%d\niobase: 0x%x\nirq: %d\ndma8: %d\ndma16: %d\n", version >> 8, version & 0xff, _io_base, _irq, _dma_8, _dma_16);
   1608f:	56                   	push   %esi
   16090:	0f b6 05 a5 00 02 00 	movzbl 0x200a5,%eax
   16097:	50                   	push   %eax
   16098:	0f b6 05 a6 00 02 00 	movzbl 0x200a6,%eax
   1609f:	50                   	push   %eax
   160a0:	0f b6 05 a7 00 02 00 	movzbl 0x200a7,%eax
   160a7:	50                   	push   %eax
   160a8:	0f b7 05 a8 00 02 00 	movzwl 0x200a8,%eax
   160af:	50                   	push   %eax
   160b0:	ff 75 cc             	push   -0x34(%ebp)
   160b3:	ff 75 c8             	push   -0x38(%ebp)
   160b6:	68 6b 99 01 00       	push   $0x1996b
   160bb:	e8 3a ce ff ff       	call   12efa <printf>

        _present = true;
   160c0:	c6 05 aa 00 02 00 01 	movb   $0x1,0x200aa
   160c7:	83 c4 20             	add    $0x20,%esp
   160ca:	eb 16                	jmp    160e2 <sb16_setup+0x23b>
    }
    else
    {
        printf("SB not SB16! version: %d.%d\n", version >> 8, version & 0xff);
   160cc:	53                   	push   %ebx
   160cd:	ff 75 cc             	push   -0x34(%ebp)
   160d0:	ff 75 c8             	push   -0x38(%ebp)
   160d3:	68 a8 99 01 00       	push   $0x199a8
   160d8:	e8 1d ce ff ff       	call   12efa <printf>
   160dd:	e9 1f fe ff ff       	jmp    15f01 <sb16_setup+0x5a>
    }
}
   160e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
   160e5:	5b                   	pop    %ebx
   160e6:	5e                   	pop    %esi
   160e7:	5f                   	pop    %edi
   160e8:	5d                   	pop    %ebp
   160e9:	c3                   	ret    

000160ea <sb16_play>:
 * freq: 5000 to 45000 Hz
 * PCM_s16le stereo/mono
 * PCM_u8 stereo/mono
 **/
bool sb16_play(void *laddr, u32 len, u16 freq, bool is_16bits, bool is_stereo)
{
   160ea:	55                   	push   %ebp
   160eb:	89 e5                	mov    %esp,%ebp
   160ed:	57                   	push   %edi
   160ee:	56                   	push   %esi
   160ef:	53                   	push   %ebx
   160f0:	83 ec 2c             	sub    $0x2c,%esp
   160f3:	8b 75 0c             	mov    0xc(%ebp),%esi
   160f6:	8b 45 10             	mov    0x10(%ebp),%eax
   160f9:	89 45 dc             	mov    %eax,-0x24(%ebp)
   160fc:	8b 45 14             	mov    0x14(%ebp),%eax
   160ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
   16102:	8b 45 18             	mov    0x18(%ebp),%eax
   16105:	89 45 d4             	mov    %eax,-0x2c(%ebp)
   16108:	8a 45 e4             	mov    -0x1c(%ebp),%al
   1610b:	88 45 e2             	mov    %al,-0x1e(%ebp)
    if (!_present || freq < 5000 || 45000 < freq || !len)
   1610e:	a0 aa 00 02 00       	mov    0x200aa,%al
   16113:	83 f0 01             	xor    $0x1,%eax
   16116:	85 f6                	test   %esi,%esi
   16118:	0f 94 c2             	sete   %dl
   1611b:	08 d0                	or     %dl,%al
   1611d:	0f 85 11 03 00 00    	jne    16434 <sb16_play+0x34a>
   16123:	8b 45 dc             	mov    -0x24(%ebp),%eax
   16126:	66 2d 88 13          	sub    $0x1388,%ax
   1612a:	66 3d 40 9c          	cmp    $0x9c40,%ax
   1612e:	0f 87 00 03 00 00    	ja     16434 <sb16_play+0x34a>
    {
        return false;
    }

    u8 *dma_buffer = alloc_page(DMA_BUFFER_LEN, dma_phy_mem);
   16134:	50                   	push   %eax
   16135:	50                   	push   %eax
   16136:	6a 00                	push   $0x0
   16138:	68 00 40 00 00       	push   $0x4000
   1613d:	e8 b4 f4 ff ff       	call   155f6 <alloc_page>
   16142:	89 c7                	mov    %eax,%edi
    u32 dma_buf_paddr = get_paddr(dma_buffer);
   16144:	89 04 24             	mov    %eax,(%esp)
   16147:	e8 69 f3 ff ff       	call   154b5 <get_paddr>
   1614c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    u8 dma_channel = is_16bits ? _dma_16 : _dma_8;
   1614f:	83 c4 10             	add    $0x10,%esp
   16152:	0f b6 1d a6 00 02 00 	movzbl 0x200a6,%ebx
   16159:	80 7d e4 00          	cmpb   $0x0,-0x1c(%ebp)
   1615d:	74 07                	je     16166 <sb16_play+0x7c>
   1615f:	0f b6 1d a5 00 02 00 	movzbl 0x200a5,%ebx
    u8 *cur_data_addr = laddr;
    u32 data_remain = len;
    u32 cur_play_count;

    _is_16bits = is_16bits;
   16166:	8a 45 e4             	mov    -0x1c(%ebp),%al
   16169:	a2 a4 00 02 00       	mov    %al,0x200a4
    _first_block_playing = true;
   1616e:	c6 05 a3 00 02 00 01 	movb   $0x1,0x200a3
    _first_block_need_fill = true;
   16175:	c6 05 a2 00 02 00 01 	movb   $0x1,0x200a2
    _end_of_data = false;
   1617c:	c6 05 a1 00 02 00 00 	movb   $0x0,0x200a1
    _last_block_played = false;
   16183:	c6 05 a0 00 02 00 00 	movb   $0x0,0x200a0
    // _second_last_block_played = false;

    if (!reset_dsp())
   1618a:	e8 bc fc ff ff       	call   15e4b <reset_dsp>
   1618f:	88 45 e3             	mov    %al,-0x1d(%ebp)
   16192:	84 c0                	test   %al,%al
   16194:	75 12                	jne    161a8 <sb16_play+0xbe>
    {
        printf("reset dsp failed!\n");
   16196:	83 ec 0c             	sub    $0xc,%esp
   16199:	68 d7 99 01 00       	push   $0x199d7
   1619e:	e8 57 cd ff ff       	call   12efa <printf>
        free_page(dma_buffer);
   161a3:	e9 76 01 00 00       	jmp    1631e <sb16_play+0x234>
        return false;
    }

    write_mixer(0x0a, 0x00); // MIC Volume
   161a8:	31 d2                	xor    %edx,%edx
   161aa:	b8 0a 00 00 00       	mov    $0xa,%eax
   161af:	e8 1a fc ff ff       	call   15dce <write_mixer>
    write_mixer(0x04, 0xff); // VOC Volume
   161b4:	ba ff 00 00 00       	mov    $0xff,%edx
   161b9:	b8 04 00 00 00       	mov    $0x4,%eax
   161be:	e8 0b fc ff ff       	call   15dce <write_mixer>

    pic_irq_set_entry(_irq, _irq_handler);
   161c3:	50                   	push   %eax
   161c4:	50                   	push   %eax
   161c5:	68 ef 5d 01 00       	push   $0x15def
   161ca:	0f b6 05 a7 00 02 00 	movzbl 0x200a7,%eax
   161d1:	50                   	push   %eax
   161d2:	e8 05 fb ff ff       	call   15cdc <pic_irq_set_entry>
    pic_irq_enable(_irq);
   161d7:	0f b6 05 a7 00 02 00 	movzbl 0x200a7,%eax
   161de:	89 04 24             	mov    %eax,(%esp)
   161e1:	e8 a7 fa ff ff       	call   15c8d <pic_irq_enable>

    dma_prepare(dma_channel, dma_buf_paddr, DMA_BUFFER_LEN, true);
   161e6:	6a 01                	push   $0x1
   161e8:	68 00 40 00 00       	push   $0x4000
   161ed:	ff 75 d8             	push   -0x28(%ebp)
   161f0:	53                   	push   %ebx
   161f1:	e8 5b cf ff ff       	call   13151 <dma_prepare>

    // write_mixer(0x22, 0xFF);    // Master volume L.R
    // write_mixer(0x30, 30 << 3); // Master volume L
    // write_mixer(0x31, 30 << 3); // Master volume R
    write_dsp_cmd(0xD1); // turn on DAC speaker
   161f6:	83 c4 20             	add    $0x20,%esp
   161f9:	b8 d1 00 00 00       	mov    $0xd1,%eax
   161fe:	e8 c1 fb ff ff       	call   15dc4 <write_dsp_cmd>
    delay_ms(112);
   16203:	83 ec 0c             	sub    $0xc,%esp
   16206:	6a 70                	push   $0x70
   16208:	e8 88 ec ff ff       	call   14e95 <delay_ms>

    if (data_remain < DMA_BUFFER_LEN / 2)
   1620d:	83 c4 10             	add    $0x10,%esp
   16210:	81 fe ff 1f 00 00    	cmp    $0x1fff,%esi
   16216:	77 19                	ja     16231 <sb16_play+0x147>
    {
        memcpy(dma_buffer, cur_data_addr, data_remain);
   16218:	50                   	push   %eax
   16219:	56                   	push   %esi
   1621a:	ff 75 08             	push   0x8(%ebp)
   1621d:	57                   	push   %edi
   1621e:	e8 20 02 00 00       	call   16443 <memcpy>
        cur_play_count = data_remain;
        _end_of_data = true;
   16223:	c6 05 a1 00 02 00 01 	movb   $0x1,0x200a1
        // memset(_dma_buffer + _data_remain, 0, DMA_BUFFER_LEN - _data_remain);
        data_remain = 0;
   1622a:	83 c4 10             	add    $0x10,%esp
   1622d:	31 db                	xor    %ebx,%ebx
   1622f:	eb 24                	jmp    16255 <sb16_play+0x16b>
    }
    else
    {
        memcpy(dma_buffer, cur_data_addr, DMA_BUFFER_LEN / 2);
   16231:	53                   	push   %ebx
   16232:	68 00 20 00 00       	push   $0x2000
   16237:	ff 75 08             	push   0x8(%ebp)
   1623a:	57                   	push   %edi
   1623b:	e8 03 02 00 00       	call   16443 <memcpy>
        cur_play_count = DMA_BUFFER_LEN / 2;
        cur_data_addr += DMA_BUFFER_LEN / 2;
   16240:	81 45 08 00 20 00 00 	addl   $0x2000,0x8(%ebp)
        data_remain -= DMA_BUFFER_LEN / 2;
   16247:	8d 9e 00 e0 ff ff    	lea    -0x2000(%esi),%ebx
   1624d:	83 c4 10             	add    $0x10,%esp
        cur_play_count = DMA_BUFFER_LEN / 2;
   16250:	be 00 20 00 00       	mov    $0x2000,%esi
    }
    _first_block_need_fill = false;
   16255:	c6 05 a2 00 02 00 00 	movb   $0x0,0x200a2

    if (cur_play_count <= 1 && is_16bits)
   1625c:	83 fe 01             	cmp    $0x1,%esi
   1625f:	75 0b                	jne    1626c <sb16_play+0x182>
   16261:	80 7d e4 00          	cmpb   $0x0,-0x1c(%ebp)
   16265:	74 05                	je     1626c <sb16_play+0x182>
        cur_play_count = 2;
   16267:	be 02 00 00 00       	mov    $0x2,%esi
    else if (cur_play_count == 0 && !is_16bits)
        cur_play_count = 1;

    write_dsp_cmd(0x41); // set output rate
   1626c:	b8 41 00 00 00       	mov    $0x41,%eax
   16271:	e8 4e fb ff ff       	call   15dc4 <write_dsp_cmd>
    write_dsp_cmd(freq >> 8);
   16276:	8b 45 dc             	mov    -0x24(%ebp),%eax
   16279:	0f b6 c4             	movzbl %ah,%eax
   1627c:	89 45 d8             	mov    %eax,-0x28(%ebp)
   1627f:	e8 40 fb ff ff       	call   15dc4 <write_dsp_cmd>
    write_dsp_cmd(freq);
   16284:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
   16288:	89 45 dc             	mov    %eax,-0x24(%ebp)
   1628b:	e8 34 fb ff ff       	call   15dc4 <write_dsp_cmd>

    // 00148429143 (5) DMA is 8b, 44100Hz, mono, output, mode 2, unsigned, normal speed, 44100 bps, 8707 usec/DMA

    u8 mode = is_stereo << 5 | is_16bits << 4;
   16290:	8a 45 d4             	mov    -0x2c(%ebp),%al
   16293:	c1 e0 05             	shl    $0x5,%eax
   16296:	8a 55 e4             	mov    -0x1c(%ebp),%dl
   16299:	c1 e2 04             	shl    $0x4,%edx
   1629c:	09 c2                	or     %eax,%edx
   1629e:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    write_dsp_cmd(is_16bits ? 0xB6 : 0xC6); // transfer mode - D/A, AutoInit, FIFO
   162a1:	80 7d e4 01          	cmpb   $0x1,-0x1c(%ebp)
   162a5:	19 c0                	sbb    %eax,%eax
   162a7:	83 e0 10             	and    $0x10,%eax
   162aa:	05 b6 00 00 00       	add    $0xb6,%eax
   162af:	e8 10 fb ff ff       	call   15dc4 <write_dsp_cmd>
    write_dsp_cmd(mode);                    // type of sound data
   162b4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
   162b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
   162bb:	e8 04 fb ff ff       	call   15dc4 <write_dsp_cmd>

    u16 count = cur_play_count;
   162c0:	89 f2                	mov    %esi,%edx
    if (is_16bits)
   162c2:	80 7d e4 00          	cmpb   $0x0,-0x1c(%ebp)
   162c6:	74 03                	je     162cb <sb16_play+0x1e1>
        count >>= 1;
   162c8:	66 d1 ea             	shr    %dx
    count -= 1;
   162cb:	4a                   	dec    %edx

    write_dsp_cmd(count);
   162cc:	0f b6 c2             	movzbl %dl,%eax
   162cf:	89 55 d0             	mov    %edx,-0x30(%ebp)
   162d2:	e8 ed fa ff ff       	call   15dc4 <write_dsp_cmd>
    write_dsp_cmd(count >> 8);
   162d7:	8b 55 d0             	mov    -0x30(%ebp),%edx
   162da:	0f b6 c6             	movzbl %dh,%eax
   162dd:	e8 e2 fa ff ff       	call   15dc4 <write_dsp_cmd>

    if (cur_play_count < DMA_BUFFER_LEN / 2)
   162e2:	81 fe 00 20 00 00    	cmp    $0x2000,%esi
   162e8:	74 44                	je     1632e <sb16_play+0x244>
    {
        while (_first_block_playing)
   162ea:	a0 a3 00 02 00       	mov    0x200a3,%al
   162ef:	84 c0                	test   %al,%al
   162f1:	75 f7                	jne    162ea <sb16_play+0x200>

        while (!_last_block_played)
            ;
    }

    write_dsp_cmd(is_16bits ? 0xD9 : 0xDA); // stop auto-init DMA sound
   162f3:	80 7d e4 01          	cmpb   $0x1,-0x1c(%ebp)
   162f7:	b8 da 00 00 00       	mov    $0xda,%eax
   162fc:	83 d0 ff             	adc    $0xffffffff,%eax
   162ff:	e8 c0 fa ff ff       	call   15dc4 <write_dsp_cmd>
    write_dsp_cmd(0xD3);                    // turn off DAC speaker
   16304:	b8 d3 00 00 00       	mov    $0xd3,%eax
   16309:	e8 b6 fa ff ff       	call   15dc4 <write_dsp_cmd>

    // dma_release(_is_16bits ? _dma_16 : _dma_8);
    pic_irq_disable(_irq);
   1630e:	83 ec 0c             	sub    $0xc,%esp
   16311:	0f b6 05 a7 00 02 00 	movzbl 0x200a7,%eax
   16318:	50                   	push   %eax
   16319:	e8 9d f9 ff ff       	call   15cbb <pic_irq_disable>
    free_page(dma_buffer);
   1631e:	89 3c 24             	mov    %edi,(%esp)
   16321:	e8 25 f2 ff ff       	call   1554b <free_page>

    return true;
   16326:	83 c4 10             	add    $0x10,%esp
   16329:	e9 0a 01 00 00       	jmp    16438 <sb16_play+0x34e>
   1632e:	80 7d e4 01          	cmpb   $0x1,-0x1c(%ebp)
   16332:	19 f6                	sbb    %esi,%esi
   16334:	83 e6 10             	and    $0x10,%esi
   16337:	81 c6 b2 00 00 00    	add    $0xb2,%esi
            while (_first_block_playing == _first_block_need_fill)
   1633d:	8a 15 a3 00 02 00    	mov    0x200a3,%dl
   16343:	a0 a2 00 02 00       	mov    0x200a2,%al
   16348:	38 c2                	cmp    %al,%dl
   1634a:	74 f1                	je     1633d <sb16_play+0x253>
            u32 offset = _first_block_need_fill ? 0 : DMA_BUFFER_LEN / 2;
   1634c:	a0 a2 00 02 00       	mov    0x200a2,%al
   16351:	3c 01                	cmp    $0x1,%al
   16353:	19 c0                	sbb    %eax,%eax
   16355:	25 00 20 00 00       	and    $0x2000,%eax
                memcpy(dma_buffer + offset, cur_data_addr, data_remain);
   1635a:	01 f8                	add    %edi,%eax
            if (data_remain < DMA_BUFFER_LEN / 2)
   1635c:	81 fb ff 1f 00 00    	cmp    $0x1fff,%ebx
   16362:	77 1b                	ja     1637f <sb16_play+0x295>
                memcpy(dma_buffer + offset, cur_data_addr, data_remain);
   16364:	51                   	push   %ecx
   16365:	53                   	push   %ebx
   16366:	ff 75 08             	push   0x8(%ebp)
   16369:	50                   	push   %eax
   1636a:	e8 d4 00 00 00       	call   16443 <memcpy>
                _end_of_data = true;
   1636f:	c6 05 a1 00 02 00 01 	movb   $0x1,0x200a1
                data_remain = 0;
   16376:	83 c4 10             	add    $0x10,%esp
   16379:	89 da                	mov    %ebx,%edx
   1637b:	31 db                	xor    %ebx,%ebx
   1637d:	eb 24                	jmp    163a3 <sb16_play+0x2b9>
                memcpy(dma_buffer + offset, cur_data_addr, DMA_BUFFER_LEN / 2);
   1637f:	52                   	push   %edx
   16380:	68 00 20 00 00       	push   $0x2000
   16385:	ff 75 08             	push   0x8(%ebp)
   16388:	50                   	push   %eax
   16389:	e8 b5 00 00 00       	call   16443 <memcpy>
                cur_data_addr += DMA_BUFFER_LEN / 2;
   1638e:	81 45 08 00 20 00 00 	addl   $0x2000,0x8(%ebp)
                data_remain -= DMA_BUFFER_LEN / 2;
   16395:	81 eb 00 20 00 00    	sub    $0x2000,%ebx
   1639b:	83 c4 10             	add    $0x10,%esp
                cur_play_count = DMA_BUFFER_LEN / 2;
   1639e:	ba 00 20 00 00       	mov    $0x2000,%edx
            _first_block_need_fill = !_first_block_need_fill;
   163a3:	a0 a2 00 02 00       	mov    0x200a2,%al
   163a8:	83 f0 01             	xor    $0x1,%eax
   163ab:	a2 a2 00 02 00       	mov    %al,0x200a2
            if (cur_play_count < DMA_BUFFER_LEN / 2)
   163b0:	81 fa 00 20 00 00    	cmp    $0x2000,%edx
   163b6:	74 61                	je     16419 <sb16_play+0x32f>
                if (cur_play_count <= 1 && is_16bits)
   163b8:	83 fa 01             	cmp    $0x1,%edx
   163bb:	77 09                	ja     163c6 <sb16_play+0x2dc>
   163bd:	80 7d e2 01          	cmpb   $0x1,-0x1e(%ebp)
   163c1:	19 d2                	sbb    %edx,%edx
   163c3:	83 c2 02             	add    $0x2,%edx
   163c6:	89 55 d0             	mov    %edx,-0x30(%ebp)
                write_dsp_cmd(0x41); // set output rate
   163c9:	b8 41 00 00 00       	mov    $0x41,%eax
   163ce:	e8 f1 f9 ff ff       	call   15dc4 <write_dsp_cmd>
                write_dsp_cmd(freq >> 8);
   163d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
   163d6:	e8 e9 f9 ff ff       	call   15dc4 <write_dsp_cmd>
                write_dsp_cmd(freq);
   163db:	8b 45 dc             	mov    -0x24(%ebp),%eax
   163de:	e8 e1 f9 ff ff       	call   15dc4 <write_dsp_cmd>
                write_dsp_cmd(is_16bits ? 0xB2 : 0xC2); // transfer mode - D/A, Single-cycle, FIFO
   163e3:	89 f0                	mov    %esi,%eax
   163e5:	e8 da f9 ff ff       	call   15dc4 <write_dsp_cmd>
                write_dsp_cmd(mode);                    // type of sound data
   163ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
   163ed:	e8 d2 f9 ff ff       	call   15dc4 <write_dsp_cmd>
                u16 count = cur_play_count;
   163f2:	8b 55 d0             	mov    -0x30(%ebp),%edx
   163f5:	89 d0                	mov    %edx,%eax
                if (is_16bits)
   163f7:	80 7d e2 00          	cmpb   $0x0,-0x1e(%ebp)
   163fb:	74 03                	je     16400 <sb16_play+0x316>
                    count >>= 1;
   163fd:	66 d1 e8             	shr    %ax
                count -= 1;
   16400:	8d 50 ff             	lea    -0x1(%eax),%edx
                write_dsp_cmd(count);
   16403:	0f b6 c2             	movzbl %dl,%eax
   16406:	89 55 d0             	mov    %edx,-0x30(%ebp)
   16409:	e8 b6 f9 ff ff       	call   15dc4 <write_dsp_cmd>
                write_dsp_cmd(count >> 8);
   1640e:	8b 55 d0             	mov    -0x30(%ebp),%edx
   16411:	0f b6 c6             	movzbl %dh,%eax
   16414:	e8 ab f9 ff ff       	call   15dc4 <write_dsp_cmd>
        } while (!_end_of_data);
   16419:	a0 a1 00 02 00       	mov    0x200a1,%al
   1641e:	84 c0                	test   %al,%al
   16420:	0f 84 17 ff ff ff    	je     1633d <sb16_play+0x253>
        while (!_last_block_played)
   16426:	a0 a0 00 02 00       	mov    0x200a0,%al
   1642b:	84 c0                	test   %al,%al
   1642d:	74 f7                	je     16426 <sb16_play+0x33c>
   1642f:	e9 bf fe ff ff       	jmp    162f3 <sb16_play+0x209>
        return false;
   16434:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
}
   16438:	8a 45 e3             	mov    -0x1d(%ebp),%al
   1643b:	8d 65 f4             	lea    -0xc(%ebp),%esp
   1643e:	5b                   	pop    %ebx
   1643f:	5e                   	pop    %esi
   16440:	5f                   	pop    %edi
   16441:	5d                   	pop    %ebp
   16442:	c3                   	ret    

00016443 <memcpy>:
#include "string.h"

void memcpy(volatile void *dst, const volatile void *src, u32 size)
{
   16443:	55                   	push   %ebp
   16444:	89 e5                	mov    %esp,%ebp
   16446:	57                   	push   %edi
   16447:	56                   	push   %esi
#if 1
    __asm__ volatile("cld\n\t"
   16448:	8b 7d 08             	mov    0x8(%ebp),%edi
   1644b:	8b 4d 10             	mov    0x10(%ebp),%ecx
   1644e:	8b 75 0c             	mov    0xc(%ebp),%esi
   16451:	fc                   	cld    
   16452:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                     "rep movsb\n"
                     : "+D"(dst)
                     : "S"(src), "r"(size / 4), "r"(size % 4)
                     : "memory");
#endif
}
   16454:	5e                   	pop    %esi
   16455:	5f                   	pop    %edi
   16456:	5d                   	pop    %ebp
   16457:	c3                   	ret    

00016458 <memset>:

void memset(volatile void *dst, u8 value, u32 size)
{
   16458:	55                   	push   %ebp
   16459:	89 e5                	mov    %esp,%ebp
   1645b:	57                   	push   %edi
    __asm__ volatile("cld\n\t"
   1645c:	8b 7d 08             	mov    0x8(%ebp),%edi
   1645f:	8b 45 0c             	mov    0xc(%ebp),%eax
   16462:	8b 4d 10             	mov    0x10(%ebp),%ecx
   16465:	fc                   	cld    
   16466:	f3 aa                	rep stos %al,%es:(%edi)
                     "rep stosb\n"
                     : "+D"(dst)
                     : "a"(value), "c"(size)
                     : "memory");
}
   16468:	5f                   	pop    %edi
   16469:	5d                   	pop    %ebp
   1646a:	c3                   	ret    

0001646b <memcmp>:

int memcmp(const volatile void *src1, const volatile void *src2, u32 size)
{
   1646b:	55                   	push   %ebp
   1646c:	89 e5                	mov    %esp,%ebp
   1646e:	57                   	push   %edi
   1646f:	56                   	push   %esi
   16470:	8b 7d 08             	mov    0x8(%ebp),%edi
   16473:	8b 75 0c             	mov    0xc(%ebp),%esi
   16476:	8b 45 10             	mov    0x10(%ebp),%eax
    u32 remain = size;
    __asm__ volatile("cld\n\t"
   16479:	89 c1                	mov    %eax,%ecx
   1647b:	fc                   	cld    
   1647c:	f3 a6                	repz cmpsb %es:(%edi),%ds:(%esi)
                     "repe cmpsb\n"
                     : "+c"(remain)
                     : "D"(src1), "S"(src2)
                     : "memory");
    return remain ? ((char *)src1)[size - remain] - ((char *)src2)[size - remain] : 0;
   1647e:	31 d2                	xor    %edx,%edx
   16480:	85 c9                	test   %ecx,%ecx
   16482:	74 0c                	je     16490 <memcmp+0x25>
   16484:	29 c8                	sub    %ecx,%eax
   16486:	0f be 14 07          	movsbl (%edi,%eax,1),%edx
   1648a:	0f be 04 06          	movsbl (%esi,%eax,1),%eax
   1648e:	29 c2                	sub    %eax,%edx
}
   16490:	89 d0                	mov    %edx,%eax
   16492:	5e                   	pop    %esi
   16493:	5f                   	pop    %edi
   16494:	5d                   	pop    %ebp
   16495:	c3                   	ret    

00016496 <itoa>:

void itoa(s32 value, char *volatile dst, int base)
{
   16496:	55                   	push   %ebp
   16497:	89 e5                	mov    %esp,%ebp
   16499:	57                   	push   %edi
   1649a:	56                   	push   %esi
   1649b:	53                   	push   %ebx
   1649c:	83 ec 40             	sub    $0x40,%esp
   1649f:	8b 45 08             	mov    0x8(%ebp),%eax
    u32 num;
    char translate_table[] = {"0123456789abcdef"};
   164a2:	8d 7d c3             	lea    -0x3d(%ebp),%edi
   164a5:	be ea 80 01 00       	mov    $0x180ea,%esi
   164aa:	b9 11 00 00 00       	mov    $0x11,%ecx
   164af:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
    u8 index_seq[32], index_count = 0;

    if (value < 0 && base == 10)
   164b1:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
   164b5:	75 16                	jne    164cd <itoa+0x37>
   164b7:	85 c0                	test   %eax,%eax
   164b9:	79 12                	jns    164cd <itoa+0x37>
    {
        num = -value;
   164bb:	f7 d8                	neg    %eax
   164bd:	89 c6                	mov    %eax,%esi
        *dst++ = '-';
   164bf:	8b 45 0c             	mov    0xc(%ebp),%eax
   164c2:	8d 50 01             	lea    0x1(%eax),%edx
   164c5:	89 55 0c             	mov    %edx,0xc(%ebp)
   164c8:	c6 00 2d             	movb   $0x2d,(%eax)
   164cb:	eb 02                	jmp    164cf <itoa+0x39>
    }
    else
        num = value;
   164cd:	89 c6                	mov    %eax,%esi
{
   164cf:	31 c9                	xor    %ecx,%ecx

    do
    {
        index_seq[index_count++] = num % base;
   164d1:	89 f0                	mov    %esi,%eax
   164d3:	31 d2                	xor    %edx,%edx
   164d5:	f7 75 10             	divl   0x10(%ebp)
   164d8:	0f b6 f9             	movzbl %cl,%edi
   164db:	41                   	inc    %ecx
   164dc:	88 54 3d d4          	mov    %dl,-0x2c(%ebp,%edi,1)
        num /= base;
   164e0:	89 f2                	mov    %esi,%edx
   164e2:	89 c6                	mov    %eax,%esi
    } while (num);
   164e4:	39 55 10             	cmp    %edx,0x10(%ebp)
   164e7:	76 e8                	jbe    164d1 <itoa+0x3b>

    while (index_count--)
   164e9:	49                   	dec    %ecx
   164ea:	80 f9 ff             	cmp    $0xff,%cl
   164ed:	74 19                	je     16508 <itoa+0x72>
    {
        *dst++ = translate_table[index_seq[index_count]];
   164ef:	0f b6 c1             	movzbl %cl,%eax
   164f2:	0f b6 54 05 d4       	movzbl -0x2c(%ebp,%eax,1),%edx
   164f7:	8b 45 0c             	mov    0xc(%ebp),%eax
   164fa:	8d 58 01             	lea    0x1(%eax),%ebx
   164fd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
   16500:	8a 54 15 c3          	mov    -0x3d(%ebp,%edx,1),%dl
   16504:	88 10                	mov    %dl,(%eax)
   16506:	eb e1                	jmp    164e9 <itoa+0x53>
    }
    *dst = 0;
   16508:	8b 45 0c             	mov    0xc(%ebp),%eax
   1650b:	c6 00 00             	movb   $0x0,(%eax)
}
   1650e:	83 c4 40             	add    $0x40,%esp
   16511:	5b                   	pop    %ebx
   16512:	5e                   	pop    %esi
   16513:	5f                   	pop    %edi
   16514:	5d                   	pop    %ebp
   16515:	c3                   	ret    

00016516 <strcpy>:

void strcpy(char *volatile dst, const char *volatile src)
{
   16516:	55                   	push   %ebp
   16517:	89 e5                	mov    %esp,%ebp
    while (*src)
   16519:	8b 45 0c             	mov    0xc(%ebp),%eax
   1651c:	80 38 00             	cmpb   $0x0,(%eax)
   1651f:	74 18                	je     16539 <strcpy+0x23>
        *dst++ = *src++;
   16521:	8b 55 0c             	mov    0xc(%ebp),%edx
   16524:	8d 42 01             	lea    0x1(%edx),%eax
   16527:	89 45 0c             	mov    %eax,0xc(%ebp)
   1652a:	8b 45 08             	mov    0x8(%ebp),%eax
   1652d:	8d 48 01             	lea    0x1(%eax),%ecx
   16530:	89 4d 08             	mov    %ecx,0x8(%ebp)
   16533:	8a 12                	mov    (%edx),%dl
   16535:	88 10                	mov    %dl,(%eax)
   16537:	eb e0                	jmp    16519 <strcpy+0x3>
}
   16539:	5d                   	pop    %ebp
   1653a:	c3                   	ret    

0001653b <strlen>:

u32 strlen(const char *volatile s)
{
   1653b:	55                   	push   %ebp
   1653c:	89 e5                	mov    %esp,%ebp
    u32 len = 0;
   1653e:	31 c0                	xor    %eax,%eax
    while (*s++)
   16540:	8b 55 08             	mov    0x8(%ebp),%edx
   16543:	8d 4a 01             	lea    0x1(%edx),%ecx
   16546:	89 4d 08             	mov    %ecx,0x8(%ebp)
   16549:	80 3a 00             	cmpb   $0x0,(%edx)
   1654c:	74 03                	je     16551 <strlen+0x16>
        ++len;
   1654e:	40                   	inc    %eax
   1654f:	eb ef                	jmp    16540 <strlen+0x5>
    return len;
}
   16551:	5d                   	pop    %ebp
   16552:	c3                   	ret    

00016553 <vsprintf>:

void vsprintf(char *buf, const char *fmt, va_list args)
{
   16553:	55                   	push   %ebp
   16554:	89 e5                	mov    %esp,%ebp
   16556:	57                   	push   %edi
   16557:	56                   	push   %esi
   16558:	53                   	push   %ebx
   16559:	83 ec 4c             	sub    $0x4c,%esp
   1655c:	8b 5d 08             	mov    0x8(%ebp),%ebx
   1655f:	8b 45 10             	mov    0x10(%ebp),%eax
    char str_tmp[32 + 1];
    u32 s_len;

    while (*fmt != '\0')
   16562:	8b 55 0c             	mov    0xc(%ebp),%edx
   16565:	8a 12                	mov    (%edx),%dl
   16567:	84 d2                	test   %dl,%dl
   16569:	0f 84 b0 00 00 00    	je     1661f <vsprintf+0xcc>
    {
        if (*fmt == '%')
   1656f:	80 fa 25             	cmp    $0x25,%dl
   16572:	0f 85 9c 00 00 00    	jne    16614 <vsprintf+0xc1>
        {
            ++fmt;
            switch (*fmt)
   16578:	8b 7d 0c             	mov    0xc(%ebp),%edi
   1657b:	8a 57 01             	mov    0x1(%edi),%dl
   1657e:	80 fa 6f             	cmp    $0x6f,%dl
   16581:	74 44                	je     165c7 <vsprintf+0x74>
   16583:	7f 15                	jg     1659a <vsprintf+0x47>
   16585:	80 fa 63             	cmp    $0x63,%dl
   16588:	74 25                	je     165af <vsprintf+0x5c>
   1658a:	80 fa 64             	cmp    $0x64,%dl
   1658d:	75 65                	jne    165f4 <vsprintf+0xa1>
                s_len = strlen(str_tmp);
                memcpy(buf, str_tmp, s_len);
                buf += s_len;
                break;
            case 'd':
                itoa(va_arg(args, s32), str_tmp, 10);
   1658f:	8d 78 04             	lea    0x4(%eax),%edi
   16592:	89 7d b4             	mov    %edi,-0x4c(%ebp)
   16595:	51                   	push   %ecx
   16596:	6a 0a                	push   $0xa
   16598:	eb 36                	jmp    165d0 <vsprintf+0x7d>
            switch (*fmt)
   1659a:	80 fa 73             	cmp    $0x73,%dl
   1659d:	74 1a                	je     165b9 <vsprintf+0x66>
   1659f:	80 fa 78             	cmp    $0x78,%dl
   165a2:	75 50                	jne    165f4 <vsprintf+0xa1>
                s_len = strlen(str_tmp);
                memcpy(buf, str_tmp, s_len);
                buf += s_len;
                break;
            case 'x':
                itoa(va_arg(args, s32), str_tmp, 16);
   165a4:	8d 48 04             	lea    0x4(%eax),%ecx
   165a7:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
   165aa:	52                   	push   %edx
   165ab:	6a 10                	push   $0x10
   165ad:	eb 21                	jmp    165d0 <vsprintf+0x7d>
                *buf++ = (char)va_arg(args, int);
   165af:	8b 10                	mov    (%eax),%edx
   165b1:	88 13                	mov    %dl,(%ebx)
   165b3:	83 c0 04             	add    $0x4,%eax
   165b6:	43                   	inc    %ebx
                break;
   165b7:	eb 52                	jmp    1660b <vsprintf+0xb8>
                char *s_ptr = va_arg(args, char *);
   165b9:	8d 78 04             	lea    0x4(%eax),%edi
   165bc:	89 7d b4             	mov    %edi,-0x4c(%ebp)
   165bf:	8b 30                	mov    (%eax),%esi
                s_len = strlen(s_ptr);
   165c1:	83 ec 0c             	sub    $0xc,%esp
   165c4:	56                   	push   %esi
   165c5:	eb 17                	jmp    165de <vsprintf+0x8b>
                itoa(va_arg(args, s32), str_tmp, 8);
   165c7:	8d 48 04             	lea    0x4(%eax),%ecx
   165ca:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
   165cd:	56                   	push   %esi
   165ce:	6a 08                	push   $0x8
                itoa(va_arg(args, s32), str_tmp, 16);
   165d0:	8d 75 c7             	lea    -0x39(%ebp),%esi
   165d3:	56                   	push   %esi
   165d4:	ff 30                	push   (%eax)
   165d6:	e8 bb fe ff ff       	call   16496 <itoa>
                s_len = strlen(str_tmp);
   165db:	89 34 24             	mov    %esi,(%esp)
   165de:	e8 58 ff ff ff       	call   1653b <strlen>
   165e3:	89 c1                	mov    %eax,%ecx
    __asm__ volatile("cld\n\t"
   165e5:	89 df                	mov    %ebx,%edi
   165e7:	fc                   	cld    
   165e8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                memcpy(buf, str_tmp, s_len);
                buf += s_len;
   165ea:	01 c3                	add    %eax,%ebx
                break;
   165ec:	83 c4 10             	add    $0x10,%esp
                itoa(va_arg(args, s32), str_tmp, 16);
   165ef:	8b 45 b4             	mov    -0x4c(%ebp),%eax
                break;
   165f2:	eb 17                	jmp    1660b <vsprintf+0xb8>
            default:
                *buf++ = '%';
   165f4:	c6 03 25             	movb   $0x25,(%ebx)
                if (*fmt != '%')
   165f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
   165fa:	8a 57 01             	mov    0x1(%edi),%dl
   165fd:	80 fa 25             	cmp    $0x25,%dl
   16600:	75 03                	jne    16605 <vsprintf+0xb2>
                *buf++ = '%';
   16602:	43                   	inc    %ebx
   16603:	eb 06                	jmp    1660b <vsprintf+0xb8>
                    *buf++ = *fmt;
   16605:	88 53 01             	mov    %dl,0x1(%ebx)
   16608:	83 c3 02             	add    $0x2,%ebx
                break;
            }
            ++fmt;
   1660b:	83 45 0c 02          	addl   $0x2,0xc(%ebp)
            continue;
   1660f:	e9 4e ff ff ff       	jmp    16562 <vsprintf+0xf>
        }

        *buf++ = *fmt++;
   16614:	ff 45 0c             	incl   0xc(%ebp)
   16617:	88 13                	mov    %dl,(%ebx)
   16619:	43                   	inc    %ebx
   1661a:	e9 43 ff ff ff       	jmp    16562 <vsprintf+0xf>
    }
    *buf = 0;
   1661f:	c6 03 00             	movb   $0x0,(%ebx)
}
   16622:	8d 65 f4             	lea    -0xc(%ebp),%esp
   16625:	5b                   	pop    %ebx
   16626:	5e                   	pop    %esi
   16627:	5f                   	pop    %edi
   16628:	5d                   	pop    %ebp
   16629:	c3                   	ret    

0001662a <sprintf>:

void sprintf(char *buf, const char *fmt, ...)
{
   1662a:	55                   	push   %ebp
   1662b:	89 e5                	mov    %esp,%ebp
   1662d:	83 ec 0c             	sub    $0xc,%esp
    va_list arg;

    va_start(arg, fmt);
   16630:	8d 45 10             	lea    0x10(%ebp),%eax
    vsprintf(buf, fmt, arg);
   16633:	50                   	push   %eax
   16634:	ff 75 0c             	push   0xc(%ebp)
   16637:	ff 75 08             	push   0x8(%ebp)
   1663a:	e8 14 ff ff ff       	call   16553 <vsprintf>
    va_end(arg);
}
   1663f:	83 c4 10             	add    $0x10,%esp
   16642:	c9                   	leave  
   16643:	c3                   	ret    

00016644 <MpfpSearch>:

	unmap_mem(xsdt_ptr);
}

static mpfp_s *MpfpSearch(u32 addr, u32 len)
{
   16644:	55                   	push   %ebp
   16645:	89 e5                	mov    %esp,%ebp
   16647:	56                   	push   %esi
   16648:	53                   	push   %ebx
	mpfp_s *p;
	for (u8 *s = (u8 *)addr, *e = (u8 *)(addr + len); s < e; s += 16, p = NULL)
   16649:	89 c3                	mov    %eax,%ebx
   1664b:	8d 34 10             	lea    (%eax,%edx,1),%esi
   1664e:	39 f3                	cmp    %esi,%ebx
   16650:	73 58                	jae    166aa <MpfpSearch+0x66>
	{
		p = (mpfp_s *)s;
		if (memcmp(p->Signature, "_MP_", 4))
   16652:	51                   	push   %ecx
   16653:	6a 04                	push   $0x4
   16655:	68 68 9b 01 00       	push   $0x19b68
   1665a:	53                   	push   %ebx
   1665b:	e8 0b fe ff ff       	call   1646b <memcmp>
   16660:	83 c4 10             	add    $0x10,%esp
   16663:	85 c0                	test   %eax,%eax
   16665:	75 3e                	jne    166a5 <MpfpSearch+0x61>
			continue;
		if ((u32)e - (u32)s < sizeof(mpfp_s))
   16667:	89 f0                	mov    %esi,%eax
   16669:	29 d8                	sub    %ebx,%eax
   1666b:	83 f8 0f             	cmp    $0xf,%eax
   1666e:	76 35                	jbe    166a5 <MpfpSearch+0x61>
			continue;
		if (p->Length != 1)
   16670:	80 7b 08 01          	cmpb   $0x1,0x8(%ebx)
   16674:	75 2f                	jne    166a5 <MpfpSearch+0x61>
			continue;
		if (p->Revision != 1 && p->Revision != 4)
   16676:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
   1667a:	3c 01                	cmp    $0x1,%al
   1667c:	74 16                	je     16694 <MpfpSearch+0x50>
   1667e:	3c 04                	cmp    $0x4,%al
   16680:	74 12                	je     16694 <MpfpSearch+0x50>
		{
			printf("invalid Revision=%d\n", p->Revision);
   16682:	52                   	push   %edx
   16683:	52                   	push   %edx
   16684:	50                   	push   %eax
   16685:	68 6d 9b 01 00       	push   $0x19b6d
   1668a:	e8 6b c8 ff ff       	call   12efa <printf>
			continue;
   1668f:	83 c4 10             	add    $0x10,%esp
   16692:	eb 11                	jmp    166a5 <MpfpSearch+0x61>
		}
		if (checksum_add(p, p->Length * 16))
   16694:	50                   	push   %eax
   16695:	50                   	push   %eax
   16696:	6a 10                	push   $0x10
   16698:	53                   	push   %ebx
   16699:	e8 22 e8 ff ff       	call   14ec0 <checksum_add>
   1669e:	83 c4 10             	add    $0x10,%esp
   166a1:	84 c0                	test   %al,%al
   166a3:	74 07                	je     166ac <MpfpSearch+0x68>
	for (u8 *s = (u8 *)addr, *e = (u8 *)(addr + len); s < e; s += 16, p = NULL)
   166a5:	83 c3 10             	add    $0x10,%ebx
   166a8:	eb a4                	jmp    1664e <MpfpSearch+0xa>
   166aa:	31 db                	xor    %ebx,%ebx
			continue;
		break;
	}

	return p;
}
   166ac:	89 d8                	mov    %ebx,%eax
   166ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
   166b1:	5b                   	pop    %ebx
   166b2:	5e                   	pop    %esi
   166b3:	5d                   	pop    %ebp
   166b4:	c3                   	ret    

000166b5 <XsdpSearch>:
{
   166b5:	55                   	push   %ebp
   166b6:	89 e5                	mov    %esp,%ebp
   166b8:	57                   	push   %edi
   166b9:	56                   	push   %esi
   166ba:	53                   	push   %ebx
   166bb:	83 ec 0c             	sub    $0xc,%esp
	for (u8 *s = (u8 *)addr, *e = (u8 *)(addr + len); s < e; s += 16, p = NULL)
   166be:	89 c3                	mov    %eax,%ebx
   166c0:	8d 34 10             	lea    (%eax,%edx,1),%esi
   166c3:	39 f3                	cmp    %esi,%ebx
   166c5:	73 6e                	jae    16735 <XsdpSearch+0x80>
		if (memcmp(p->Rsdp.Signature, "RSD PTR ", 8))
   166c7:	57                   	push   %edi
   166c8:	6a 08                	push   $0x8
   166ca:	68 82 9b 01 00       	push   $0x19b82
   166cf:	53                   	push   %ebx
   166d0:	e8 96 fd ff ff       	call   1646b <memcmp>
   166d5:	83 c4 10             	add    $0x10,%esp
   166d8:	85 c0                	test   %eax,%eax
   166da:	75 54                	jne    16730 <XsdpSearch+0x7b>
		if ((u32)e - (u32)s < sizeof(rsdp_t))
   166dc:	89 f7                	mov    %esi,%edi
   166de:	29 df                	sub    %ebx,%edi
   166e0:	83 ff 13             	cmp    $0x13,%edi
   166e3:	76 4b                	jbe    16730 <XsdpSearch+0x7b>
		if (checksum_add(p, sizeof(rsdp_t)))
   166e5:	51                   	push   %ecx
   166e6:	51                   	push   %ecx
   166e7:	6a 14                	push   $0x14
   166e9:	53                   	push   %ebx
   166ea:	e8 d1 e7 ff ff       	call   14ec0 <checksum_add>
   166ef:	83 c4 10             	add    $0x10,%esp
   166f2:	84 c0                	test   %al,%al
   166f4:	75 3a                	jne    16730 <XsdpSearch+0x7b>
		if (p->Rsdp.Revsion != 0 && p->Rsdp.Revsion != 2)
   166f6:	0f b6 43 0f          	movzbl 0xf(%ebx),%eax
   166fa:	84 c0                	test   %al,%al
   166fc:	74 39                	je     16737 <XsdpSearch+0x82>
   166fe:	3c 02                	cmp    $0x2,%al
   16700:	74 12                	je     16714 <XsdpSearch+0x5f>
			printf("unknown revision: %d\n", p->Rsdp.Revsion);
   16702:	52                   	push   %edx
   16703:	52                   	push   %edx
   16704:	50                   	push   %eax
   16705:	68 8b 9b 01 00       	push   $0x19b8b
   1670a:	e8 eb c7 ff ff       	call   12efa <printf>
			continue;
   1670f:	83 c4 10             	add    $0x10,%esp
   16712:	eb 1c                	jmp    16730 <XsdpSearch+0x7b>
			if ((u32)e - (u32)s < sizeof(xsdp_t))
   16714:	83 ff 23             	cmp    $0x23,%edi
   16717:	76 17                	jbe    16730 <XsdpSearch+0x7b>
			if (p->Length != sizeof(xsdp_t))
   16719:	83 7b 14 24          	cmpl   $0x24,0x14(%ebx)
   1671d:	75 11                	jne    16730 <XsdpSearch+0x7b>
			if (checksum_add(p, sizeof(xsdp_t)))
   1671f:	50                   	push   %eax
   16720:	50                   	push   %eax
   16721:	6a 24                	push   $0x24
   16723:	53                   	push   %ebx
   16724:	e8 97 e7 ff ff       	call   14ec0 <checksum_add>
   16729:	83 c4 10             	add    $0x10,%esp
   1672c:	84 c0                	test   %al,%al
   1672e:	74 07                	je     16737 <XsdpSearch+0x82>
	for (u8 *s = (u8 *)addr, *e = (u8 *)(addr + len); s < e; s += 16, p = NULL)
   16730:	83 c3 10             	add    $0x10,%ebx
   16733:	eb 8e                	jmp    166c3 <XsdpSearch+0xe>
   16735:	31 db                	xor    %ebx,%ebx
}
   16737:	89 d8                	mov    %ebx,%eax
   16739:	8d 65 f4             	lea    -0xc(%ebp),%esp
   1673c:	5b                   	pop    %ebx
   1673d:	5e                   	pop    %esi
   1673e:	5f                   	pop    %edi
   1673f:	5d                   	pop    %ebp
   16740:	c3                   	ret    

00016741 <PrintSdth>:
{
   16741:	55                   	push   %ebp
   16742:	89 e5                	mov    %esp,%ebp
   16744:	56                   	push   %esi
   16745:	53                   	push   %ebx
   16746:	83 ec 1c             	sub    $0x1c,%esp
   16749:	89 c3                	mov    %eax,%ebx
	printf("Address        =0x%x\n", get_paddr(Header));
   1674b:	50                   	push   %eax
   1674c:	e8 64 ed ff ff       	call   154b5 <get_paddr>
   16751:	5a                   	pop    %edx
   16752:	59                   	pop    %ecx
   16753:	50                   	push   %eax
   16754:	68 a1 9b 01 00       	push   $0x19ba1
   16759:	e8 9c c7 ff ff       	call   12efa <printf>
	memcpy(buf, Header->Signature, 4);
   1675e:	83 c4 0c             	add    $0xc,%esp
   16761:	6a 04                	push   $0x4
   16763:	53                   	push   %ebx
   16764:	8d 75 ef             	lea    -0x11(%ebp),%esi
   16767:	56                   	push   %esi
   16768:	e8 d6 fc ff ff       	call   16443 <memcpy>
	buf[4] = 0;
   1676d:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	printf("Signature      =%s\n", buf);
   16771:	58                   	pop    %eax
   16772:	5a                   	pop    %edx
   16773:	56                   	push   %esi
   16774:	68 b7 9b 01 00       	push   $0x19bb7
   16779:	e8 7c c7 ff ff       	call   12efa <printf>
	printf("Length         =%d\n", Header->Length);
   1677e:	59                   	pop    %ecx
   1677f:	58                   	pop    %eax
   16780:	ff 73 04             	push   0x4(%ebx)
   16783:	68 cb 9b 01 00       	push   $0x19bcb
   16788:	e8 6d c7 ff ff       	call   12efa <printf>
	printf("Revision       =%d\n", Header->Revision);
   1678d:	58                   	pop    %eax
   1678e:	5a                   	pop    %edx
   1678f:	0f b6 43 08          	movzbl 0x8(%ebx),%eax
   16793:	50                   	push   %eax
   16794:	68 df 9b 01 00       	push   $0x19bdf
   16799:	e8 5c c7 ff ff       	call   12efa <printf>
	memcpy(buf, Header->OemId, 6);
   1679e:	83 c4 0c             	add    $0xc,%esp
   167a1:	6a 06                	push   $0x6
   167a3:	8d 43 0a             	lea    0xa(%ebx),%eax
   167a6:	50                   	push   %eax
   167a7:	56                   	push   %esi
   167a8:	e8 96 fc ff ff       	call   16443 <memcpy>
	buf[6] = 0;
   167ad:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
	printf("OemId          =%s\n", buf);
   167b1:	59                   	pop    %ecx
   167b2:	58                   	pop    %eax
   167b3:	56                   	push   %esi
   167b4:	68 f3 9b 01 00       	push   $0x19bf3
   167b9:	e8 3c c7 ff ff       	call   12efa <printf>
	memcpy(buf, Header->OemTableId, 8);
   167be:	83 c4 0c             	add    $0xc,%esp
   167c1:	6a 08                	push   $0x8
   167c3:	8d 43 10             	lea    0x10(%ebx),%eax
   167c6:	50                   	push   %eax
   167c7:	56                   	push   %esi
   167c8:	e8 76 fc ff ff       	call   16443 <memcpy>
	buf[8] = 0;
   167cd:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	printf("OemTableId     =%s\n", buf);
   167d1:	58                   	pop    %eax
   167d2:	5a                   	pop    %edx
   167d3:	56                   	push   %esi
   167d4:	68 07 9c 01 00       	push   $0x19c07
   167d9:	e8 1c c7 ff ff       	call   12efa <printf>
	printf("OemRevision    =%d\n", Header->OemRevision);
   167de:	59                   	pop    %ecx
   167df:	58                   	pop    %eax
   167e0:	ff 73 18             	push   0x18(%ebx)
   167e3:	68 1b 9c 01 00       	push   $0x19c1b
   167e8:	e8 0d c7 ff ff       	call   12efa <printf>
	memcpy(buf, Header->CreatorId, 4);
   167ed:	83 c4 0c             	add    $0xc,%esp
   167f0:	6a 04                	push   $0x4
   167f2:	8d 43 1c             	lea    0x1c(%ebx),%eax
   167f5:	50                   	push   %eax
   167f6:	56                   	push   %esi
   167f7:	e8 47 fc ff ff       	call   16443 <memcpy>
	buf[4] = 0;
   167fc:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
	printf("CreatorId      =%s\n", buf);
   16800:	58                   	pop    %eax
   16801:	5a                   	pop    %edx
   16802:	56                   	push   %esi
   16803:	68 2f 9c 01 00       	push   $0x19c2f
   16808:	e8 ed c6 ff ff       	call   12efa <printf>
	printf("CreatorRevision=%d\n", Header->CreatorRevision);
   1680d:	59                   	pop    %ecx
   1680e:	5e                   	pop    %esi
   1680f:	ff 73 20             	push   0x20(%ebx)
   16812:	68 43 9c 01 00       	push   $0x19c43
   16817:	e8 de c6 ff ff       	call   12efa <printf>
	getchar();
   1681c:	e8 5a c8 ff ff       	call   1307b <getchar>
}
   16821:	83 c4 10             	add    $0x10,%esp
   16824:	8d 65 f8             	lea    -0x8(%ebp),%esp
   16827:	5b                   	pop    %ebx
   16828:	5e                   	pop    %esi
   16829:	5d                   	pop    %ebp
   1682a:	c3                   	ret    

0001682b <LdrMain>:
	print_char('\n');
}
#endif

extern void LdrMain(const struct loader_parameter *param)
{
   1682b:	55                   	push   %ebp
   1682c:	89 e5                	mov    %esp,%ebp
   1682e:	57                   	push   %edi
   1682f:	56                   	push   %esi
   16830:	53                   	push   %ebx
   16831:	81 ec dc 00 00 00    	sub    $0xdc,%esp
	paging_setup();
   16837:	e8 be ea ff ff       	call   152fa <paging_setup>
	idt_setup();
   1683c:	e8 9e de ff ff       	call   146df <idt_setup>
	mem_setup(param->ards_buf);
   16841:	83 ec 0c             	sub    $0xc,%esp
   16844:	8b 45 08             	mov    0x8(%ebp),%eax
   16847:	ff 70 10             	push   0x10(%eax)
   1684a:	e8 44 e7 ff ff       	call   14f93 <mem_setup>
	console_setup(param->console_info);
   1684f:	5f                   	pop    %edi
   16850:	8b 45 08             	mov    0x8(%ebp),%eax
   16853:	ff 70 04             	push   0x4(%eax)
   16856:	e8 d8 bf ff ff       	call   12833 <console_setup>
	pic_setup();
   1685b:	e8 02 f4 ff ff       	call   15c62 <pic_setup>
	pit_setup();
   16860:	e8 e0 f4 ff ff       	call   15d45 <pit_setup>
	cmos_setup();
   16865:	e8 fe ba ff ff       	call   12368 <cmos_setup>
	dma_setup();
   1686a:	e8 d9 c8 ff ff       	call   13148 <dma_setup>
	apm_setup(param->apm_info);
   1686f:	58                   	pop    %eax
   16870:	8b 45 08             	mov    0x8(%ebp),%eax
   16873:	ff 70 0c             	push   0xc(%eax)
   16876:	e8 5c b5 ff ff       	call   11dd7 <apm_setup>
	pci_setup(param->pci_info);
   1687b:	58                   	pop    %eax
   1687c:	8b 45 08             	mov    0x8(%ebp),%eax
   1687f:	ff 70 08             	push   0x8(%eax)
   16882:	e8 45 ee ff ff       	call   156cc <pci_setup>
	__asm__ __volatile__("sti\n" ::
   16887:	fb                   	sti    
	ps2_setup();
   16888:	e8 fd b3 ff ff       	call   11c8a <ps2_setup>
	floppy_setup();
   1688d:	e8 cc ce ff ff       	call   1375e <floppy_setup>
	ide_setup();
   16892:	e8 2d d3 ff ff       	call   13bc4 <ide_setup>
	getchar();
   16897:	e8 df c7 ff ff       	call   1307b <getchar>
	sb16_setup();
   1689c:	e8 06 f6 ff ff       	call   15ea7 <sb16_setup>
	getchar();
   168a1:	e8 d5 c7 ff ff       	call   1307b <getchar>
	es1370_setup();
   168a6:	e8 3a ca ff ff       	call   132e5 <es1370_setup>
	getchar();
   168ab:	e8 cb c7 ff ff       	call   1307b <getchar>
	init(param);

#if 1
	mem_dumpinfo();
   168b0:	e8 99 e6 ff ff       	call   14f4e <mem_dumpinfo>
	getchar();
   168b5:	e8 c1 c7 ff ff       	call   1307b <getchar>
	paging_dumpinfo();
   168ba:	e8 b2 ea ff ff       	call   15371 <paging_dumpinfo>
	getchar();
   168bf:	e8 b7 c7 ff ff       	call   1307b <getchar>
	console_dumpinfo();
   168c4:	e8 90 c6 ff ff       	call   12f59 <console_dumpinfo>
	getchar();
   168c9:	e8 ad c7 ff ff       	call   1307b <getchar>
	floppy_dumpinfo();
   168ce:	e8 f3 cd ff ff       	call   136c6 <floppy_dumpinfo>
	getchar();
   168d3:	e8 a3 c7 ff ff       	call   1307b <getchar>

	u32 colums, rows;
	console_get_print_size(&colums, &rows);
   168d8:	58                   	pop    %eax
   168d9:	5a                   	pop    %edx
   168da:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
   168e0:	50                   	push   %eax
   168e1:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
   168e7:	50                   	push   %eax
   168e8:	e8 20 c1 ff ff       	call   12a0d <console_get_print_size>

	for (u32 i = 0; i < colums - 1; ++i)
   168ed:	83 c4 10             	add    $0x10,%esp
   168f0:	31 db                	xor    %ebx,%ebx
   168f2:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
   168f8:	48                   	dec    %eax
   168f9:	39 d8                	cmp    %ebx,%eax
   168fb:	76 10                	jbe    1690d <LdrMain+0xe2>
		print_char('*');
   168fd:	83 ec 0c             	sub    $0xc,%esp
   16900:	6a 2a                	push   $0x2a
   16902:	e8 5b c1 ff ff       	call   12a62 <print_char>
	for (u32 i = 0; i < colums - 1; ++i)
   16907:	43                   	inc    %ebx
   16908:	83 c4 10             	add    $0x10,%esp
   1690b:	eb e5                	jmp    168f2 <LdrMain+0xc7>
	print_char('#');
   1690d:	83 ec 0c             	sub    $0xc,%esp
   16910:	6a 23                	push   $0x23
   16912:	e8 4b c1 ff ff       	call   12a62 <print_char>
	for (u8 i = 0; i < colums - 1; ++i)
   16917:	83 c4 10             	add    $0x10,%esp
   1691a:	31 db                	xor    %ebx,%ebx
   1691c:	0f b6 d3             	movzbl %bl,%edx
   1691f:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
   16925:	48                   	dec    %eax
   16926:	39 c2                	cmp    %eax,%edx
   16928:	73 10                	jae    1693a <LdrMain+0x10f>
		print_char('#');
   1692a:	83 ec 0c             	sub    $0xc,%esp
   1692d:	6a 23                	push   $0x23
   1692f:	e8 2e c1 ff ff       	call   12a62 <print_char>
	for (u8 i = 0; i < colums - 1; ++i)
   16934:	43                   	inc    %ebx
   16935:	83 c4 10             	add    $0x10,%esp
   16938:	eb e2                	jmp    1691c <LdrMain+0xf1>
	print_char('*');
   1693a:	83 ec 0c             	sub    $0xc,%esp
   1693d:	6a 2a                	push   $0x2a
   1693f:	e8 1e c1 ff ff       	call   12a62 <print_char>
	getchar();
   16944:	e8 32 c7 ff ff       	call   1307b <getchar>

	struct rtc_time time;
	if (cmos_rtc_time(&time))
   16949:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
   1694f:	89 04 24             	mov    %eax,(%esp)
   16952:	e8 7a ba ff ff       	call   123d1 <cmos_rtc_time>
   16957:	83 c4 10             	add    $0x10,%esp
   1695a:	84 c0                	test   %al,%al
   1695c:	74 43                	je     169a1 <LdrMain+0x176>
	{
		// print_str("\nshell>time\n");
		printf("current RTC time: %d/%d/%d %d:%d:%d\n", time.year, time.month, time.day, time.hours, time.minutes, time.seconds);
   1695e:	56                   	push   %esi
   1695f:	0f b6 85 52 ff ff ff 	movzbl -0xae(%ebp),%eax
   16966:	50                   	push   %eax
   16967:	0f b6 85 51 ff ff ff 	movzbl -0xaf(%ebp),%eax
   1696e:	50                   	push   %eax
   1696f:	0f b6 85 50 ff ff ff 	movzbl -0xb0(%ebp),%eax
   16976:	50                   	push   %eax
   16977:	0f b6 85 4f ff ff ff 	movzbl -0xb1(%ebp),%eax
   1697e:	50                   	push   %eax
   1697f:	0f b6 85 4e ff ff ff 	movzbl -0xb2(%ebp),%eax
   16986:	50                   	push   %eax
   16987:	0f b7 85 4c ff ff ff 	movzwl -0xb4(%ebp),%eax
   1698e:	50                   	push   %eax
   1698f:	68 7f 9c 01 00       	push   $0x19c7f
   16994:	e8 61 c5 ff ff       	call   12efa <printf>
		getchar();
   16999:	83 c4 20             	add    $0x20,%esp
   1699c:	e8 da c6 ff ff       	call   1307b <getchar>
	__asm__ __volatile__("cpuid\n"
   169a1:	31 c0                	xor    %eax,%eax
   169a3:	0f a2                	cpuid  
   169a5:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
   169ab:	89 9d 77 ff ff ff    	mov    %ebx,-0x89(%ebp)
   169b1:	89 8d 7f ff ff ff    	mov    %ecx,-0x81(%ebp)
   169b7:	89 95 7b ff ff ff    	mov    %edx,-0x85(%ebp)
	}

	u32 eax, cpuid_basic_max;
	char cpu_brand[49];
	cpuid(0, &cpuid_basic_max, (u32 *)cpu_brand, (u32 *)(cpu_brand + 8), (u32 *)(cpu_brand + 4));
	cpu_brand[12] = 0;
   169bd:	c6 45 83 00          	movb   $0x0,-0x7d(%ebp)
	printf("cpuid_basic_max: 0x%x\n", cpuid_basic_max);
   169c1:	53                   	push   %ebx
   169c2:	53                   	push   %ebx
   169c3:	50                   	push   %eax
   169c4:	68 a4 9c 01 00       	push   $0x19ca4
   169c9:	e8 2c c5 ff ff       	call   12efa <printf>
   169ce:	b8 00 00 00 80       	mov    $0x80000000,%eax
   169d3:	0f a2                	cpuid  
   169d5:	89 c7                	mov    %eax,%edi
   169d7:	89 55 84             	mov    %edx,-0x7c(%ebp)
	cpuid(0x80000000, &eax, (u32 *)(cpu_brand + 13), (u32 *)(cpu_brand + 13), (u32 *)(cpu_brand + 13));
	printf("cpuid_ext_max: 0x%x\ncpu_vendor: %s\n", eax, cpu_brand);
   169da:	83 c4 0c             	add    $0xc,%esp
   169dd:	8d b5 77 ff ff ff    	lea    -0x89(%ebp),%esi
   169e3:	56                   	push   %esi
   169e4:	50                   	push   %eax
   169e5:	68 bb 9c 01 00       	push   $0x19cbb
   169ea:	e8 0b c5 ff ff       	call   12efa <printf>
	if (eax >= 0x80000004)
   169ef:	83 c4 10             	add    $0x10,%esp
   169f2:	81 ff 03 00 00 80    	cmp    $0x80000003,%edi
   169f8:	76 3a                	jbe    16a34 <LdrMain+0x209>
	{
		char *ptr = cpu_brand;
		for (u32 index = 0x80000002; index <= 0x80000004; ++index)
   169fa:	bf 02 00 00 80       	mov    $0x80000002,%edi
   169ff:	89 f8                	mov    %edi,%eax
   16a01:	0f a2                	cpuid  
   16a03:	89 06                	mov    %eax,(%esi)
   16a05:	89 5e 04             	mov    %ebx,0x4(%esi)
   16a08:	89 4e 08             	mov    %ecx,0x8(%esi)
   16a0b:	89 56 0c             	mov    %edx,0xc(%esi)
		{
			cpuid(index, (u32 *)ptr, (u32 *)(ptr + 4), (u32 *)(ptr + 8), (u32 *)(ptr + 12));
			ptr += 16;
   16a0e:	83 c6 10             	add    $0x10,%esi
		for (u32 index = 0x80000002; index <= 0x80000004; ++index)
   16a11:	47                   	inc    %edi
   16a12:	81 ff 05 00 00 80    	cmp    $0x80000005,%edi
   16a18:	75 e5                	jne    169ff <LdrMain+0x1d4>
		}
		*ptr = 0;
   16a1a:	c6 45 a7 00          	movb   $0x0,-0x59(%ebp)
		printf("cpu_brand: %s\n", cpu_brand);
   16a1e:	51                   	push   %ecx
   16a1f:	51                   	push   %ecx
   16a20:	8d 85 77 ff ff ff    	lea    -0x89(%ebp),%eax
   16a26:	50                   	push   %eax
   16a27:	68 df 9c 01 00       	push   $0x19cdf
   16a2c:	e8 c9 c4 ff ff       	call   12efa <printf>
   16a31:	83 c4 10             	add    $0x10,%esp
	}
	if (cpuid_basic_max >= 0x1)
   16a34:	83 bd 34 ff ff ff 00 	cmpl   $0x0,-0xcc(%ebp)
   16a3b:	0f 84 f9 00 00 00    	je     16b3a <LdrMain+0x30f>
   16a41:	b8 01 00 00 00       	mov    $0x1,%eax
   16a46:	0f a2                	cpuid  
   16a48:	89 d6                	mov    %edx,%esi
   16a4a:	89 cf                	mov    %ecx,%edi
	{
		u32 eax, ebx, ecx, edx;
		cpuid(0x1, &eax, &ebx, &ecx, &edx);
		printf("version=0x%x: family=%x, model=%x, stepping=%x, type=%x\n",
   16a4c:	52                   	push   %edx
   16a4d:	52                   	push   %edx
			   eax,
			   (eax >> 8) & 0xf, (eax >> 4) & 0xf, eax & 0xf,
			   (eax >> 12) & 0x3);
   16a4e:	89 c2                	mov    %eax,%edx
   16a50:	c1 ea 0c             	shr    $0xc,%edx
		printf("version=0x%x: family=%x, model=%x, stepping=%x, type=%x\n",
   16a53:	83 e2 03             	and    $0x3,%edx
   16a56:	52                   	push   %edx
   16a57:	89 c2                	mov    %eax,%edx
   16a59:	83 e2 0f             	and    $0xf,%edx
   16a5c:	52                   	push   %edx
			   (eax >> 8) & 0xf, (eax >> 4) & 0xf, eax & 0xf,
   16a5d:	89 c2                	mov    %eax,%edx
   16a5f:	c1 ea 04             	shr    $0x4,%edx
		printf("version=0x%x: family=%x, model=%x, stepping=%x, type=%x\n",
   16a62:	83 e2 0f             	and    $0xf,%edx
   16a65:	52                   	push   %edx
			   (eax >> 8) & 0xf, (eax >> 4) & 0xf, eax & 0xf,
   16a66:	89 c2                	mov    %eax,%edx
   16a68:	c1 ea 08             	shr    $0x8,%edx
		printf("version=0x%x: family=%x, model=%x, stepping=%x, type=%x\n",
   16a6b:	83 e2 0f             	and    $0xf,%edx
   16a6e:	52                   	push   %edx
   16a6f:	50                   	push   %eax
   16a70:	68 ee 9c 01 00       	push   $0x19cee
   16a75:	e8 80 c4 ff ff       	call   12efa <printf>
		printf("CPUID[01H].EBX=0x%x, ECX=0x%x, EDX=0x%x\n", ebx, ecx, edx);
   16a7a:	83 c4 20             	add    $0x20,%esp
   16a7d:	56                   	push   %esi
   16a7e:	57                   	push   %edi
   16a7f:	53                   	push   %ebx
   16a80:	68 27 9d 01 00       	push   $0x19d27
   16a85:	e8 70 c4 ff ff       	call   12efa <printf>
		if (ecx & (1 << 21))
   16a8a:	83 c4 10             	add    $0x10,%esp
   16a8d:	0f ba e7 15          	bt     $0x15,%edi
   16a91:	73 10                	jae    16aa3 <LdrMain+0x278>
			print_str("x2APIC ");
   16a93:	83 ec 0c             	sub    $0xc,%esp
   16a96:	68 50 9d 01 00       	push   $0x19d50
   16a9b:	e8 13 c4 ff ff       	call   12eb3 <print_str>
   16aa0:	83 c4 10             	add    $0x10,%esp
		if (ecx & (1 << 24))
   16aa3:	0f ba e7 18          	bt     $0x18,%edi
   16aa7:	73 10                	jae    16ab9 <LdrMain+0x28e>
			print_str("TSC-Deadline ");
   16aa9:	83 ec 0c             	sub    $0xc,%esp
   16aac:	68 58 9d 01 00       	push   $0x19d58
   16ab1:	e8 fd c3 ff ff       	call   12eb3 <print_str>
   16ab6:	83 c4 10             	add    $0x10,%esp
		if (ecx & (1 << 30))
   16ab9:	0f ba e7 1e          	bt     $0x1e,%edi
   16abd:	73 10                	jae    16acf <LdrMain+0x2a4>
			print_str("RDRAND ");
   16abf:	83 ec 0c             	sub    $0xc,%esp
   16ac2:	68 66 9d 01 00       	push   $0x19d66
   16ac7:	e8 e7 c3 ff ff       	call   12eb3 <print_str>
   16acc:	83 c4 10             	add    $0x10,%esp
		if (edx & (1 << 0))
   16acf:	f7 c6 01 00 00 00    	test   $0x1,%esi
   16ad5:	74 10                	je     16ae7 <LdrMain+0x2bc>
			print_str("FPU ");
   16ad7:	83 ec 0c             	sub    $0xc,%esp
   16ada:	68 6e 9d 01 00       	push   $0x19d6e
   16adf:	e8 cf c3 ff ff       	call   12eb3 <print_str>
   16ae4:	83 c4 10             	add    $0x10,%esp
		if (edx & (1 << 4))
   16ae7:	f7 c6 10 00 00 00    	test   $0x10,%esi
   16aed:	74 10                	je     16aff <LdrMain+0x2d4>
			print_str("TSC ");
   16aef:	83 ec 0c             	sub    $0xc,%esp
   16af2:	68 73 9d 01 00       	push   $0x19d73
   16af7:	e8 b7 c3 ff ff       	call   12eb3 <print_str>
   16afc:	83 c4 10             	add    $0x10,%esp
		if (edx & (1 << 5))
   16aff:	f7 c6 20 00 00 00    	test   $0x20,%esi
   16b05:	74 10                	je     16b17 <LdrMain+0x2ec>
			print_str("MSR ");
   16b07:	83 ec 0c             	sub    $0xc,%esp
   16b0a:	68 78 9d 01 00       	push   $0x19d78
   16b0f:	e8 9f c3 ff ff       	call   12eb3 <print_str>
   16b14:	83 c4 10             	add    $0x10,%esp
		if (edx & (1 << 9))
   16b17:	0f ba e6 09          	bt     $0x9,%esi
   16b1b:	73 10                	jae    16b2d <LdrMain+0x302>
			print_str("APIC ");
   16b1d:	83 ec 0c             	sub    $0xc,%esp
   16b20:	68 52 9d 01 00       	push   $0x19d52
   16b25:	e8 89 c3 ff ff       	call   12eb3 <print_str>
   16b2a:	83 c4 10             	add    $0x10,%esp
		print_char('\n');
   16b2d:	83 ec 0c             	sub    $0xc,%esp
   16b30:	6a 0a                	push   $0xa
   16b32:	e8 2b bf ff ff       	call   12a62 <print_char>
   16b37:	83 c4 10             	add    $0x10,%esp
	}
	getchar();
   16b3a:	e8 3c c5 ff ff       	call   1307b <getchar>
	printf("%x - %x\n", laddr[2], get_paddr(laddr[2]));
	// getchar();
	// delay_ms(3000);
#endif

	const struct boot_configuration *boot_info = param->boot_info;
   16b3f:	8b 45 08             	mov    0x8(%ebp),%eax
   16b42:	8b 18                	mov    (%eax),%ebx
	console_set_color(COLOR_NORMAL_BG, COLOR_LIGHT_RED);
   16b44:	57                   	push   %edi
   16b45:	57                   	push   %edi
   16b46:	68 00 00 ff 00       	push   $0xff0000
   16b4b:	6a 00                	push   $0x0
   16b4d:	e8 3e bc ff ff       	call   12790 <console_set_color>
	print_str("boot drive: ");
   16b52:	c7 04 24 7d 9d 01 00 	movl   $0x19d7d,(%esp)
   16b59:	e8 55 c3 ff ff       	call   12eb3 <print_str>
	console_set_color(COLOR_NORMAL_BG, COLOR_LIGHT_GREEN);
   16b5e:	58                   	pop    %eax
   16b5f:	5a                   	pop    %edx
   16b60:	68 00 ff 00 00       	push   $0xff00
   16b65:	6a 00                	push   $0x0
   16b67:	e8 24 bc ff ff       	call   12790 <console_set_color>
	printf("0x%x\n", boot_info->DriveNumber);
   16b6c:	59                   	pop    %ecx
   16b6d:	5e                   	pop    %esi
   16b6e:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
   16b72:	50                   	push   %eax
   16b73:	68 f5 a5 01 00       	push   $0x1a5f5
   16b78:	e8 7d c3 ff ff       	call   12efa <printf>
	console_set_color(COLOR_NORMAL_BG, COLOR_NORMAL_FG);
   16b7d:	5f                   	pop    %edi
   16b7e:	58                   	pop    %eax
   16b7f:	68 d3 d3 d3 00       	push   $0xd3d3d3
   16b84:	6a 00                	push   $0x0
   16b86:	e8 05 bc ff ff       	call   12790 <console_set_color>
	printf("CyliderCount: %d\n", boot_info->CyliderCount);
   16b8b:	58                   	pop    %eax
   16b8c:	5a                   	pop    %edx
   16b8d:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
   16b91:	50                   	push   %eax
   16b92:	68 8a 9d 01 00       	push   $0x19d8a
   16b97:	e8 5e c3 ff ff       	call   12efa <printf>
	printf("NumberHeads: %d\n", boot_info->NumberHeads);
   16b9c:	59                   	pop    %ecx
   16b9d:	5e                   	pop    %esi
   16b9e:	0f b7 43 02          	movzwl 0x2(%ebx),%eax
   16ba2:	50                   	push   %eax
   16ba3:	68 9c 9d 01 00       	push   $0x19d9c
   16ba8:	e8 4d c3 ff ff       	call   12efa <printf>
	printf("SectorsPerTrack: %d\n", boot_info->SectorsPerTrack);
   16bad:	5f                   	pop    %edi
   16bae:	58                   	pop    %eax
   16baf:	0f b7 03             	movzwl (%ebx),%eax
   16bb2:	50                   	push   %eax
   16bb3:	68 ad 9d 01 00       	push   $0x19dad
   16bb8:	e8 3d c3 ff ff       	call   12efa <printf>
	printf("BytesPerSector: %d\n", boot_info->BytesPerSector);
   16bbd:	58                   	pop    %eax
   16bbe:	5a                   	pop    %edx
   16bbf:	0f b7 43 07          	movzwl 0x7(%ebx),%eax
   16bc3:	50                   	push   %eax
   16bc4:	68 c2 9d 01 00       	push   $0x19dc2
   16bc9:	e8 2c c3 ff ff       	call   12efa <printf>
	printf("SectorsPerCluster: %d\n", boot_info->SectorsPerCluster);
   16bce:	59                   	pop    %ecx
   16bcf:	5e                   	pop    %esi
   16bd0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
   16bd4:	50                   	push   %eax
   16bd5:	68 d6 9d 01 00       	push   $0x19dd6
   16bda:	e8 1b c3 ff ff       	call   12efa <printf>
	printf("TotalSectors: %d\n", boot_info->TotalSectors);
   16bdf:	5f                   	pop    %edi
   16be0:	58                   	pop    %eax
   16be1:	ff 73 0a             	push   0xa(%ebx)
   16be4:	68 ed 9d 01 00       	push   $0x19ded
   16be9:	e8 0c c3 ff ff       	call   12efa <printf>
	printf("FatStartSector: %d\n", boot_info->FatStartSector);
   16bee:	58                   	pop    %eax
   16bef:	5a                   	pop    %edx
   16bf0:	ff 73 0e             	push   0xe(%ebx)
   16bf3:	68 ff 9d 01 00       	push   $0x19dff
   16bf8:	e8 fd c2 ff ff       	call   12efa <printf>
	printf("FatSectors: %d\n", boot_info->FatSectors);
   16bfd:	59                   	pop    %ecx
   16bfe:	5e                   	pop    %esi
   16bff:	ff 73 12             	push   0x12(%ebx)
   16c02:	68 13 9e 01 00       	push   $0x19e13
   16c07:	e8 ee c2 ff ff       	call   12efa <printf>
	printf("RootDirStartSector: %d\n", boot_info->RootDirStartSector);
   16c0c:	5f                   	pop    %edi
   16c0d:	58                   	pop    %eax
   16c0e:	ff 73 16             	push   0x16(%ebx)
   16c11:	68 23 9e 01 00       	push   $0x19e23
   16c16:	e8 df c2 ff ff       	call   12efa <printf>
	printf("RootDirSectors: %d\n", boot_info->RootDirSectors);
   16c1b:	58                   	pop    %eax
   16c1c:	5a                   	pop    %edx
   16c1d:	ff 73 1a             	push   0x1a(%ebx)
   16c20:	68 3b 9e 01 00       	push   $0x19e3b
   16c25:	e8 d0 c2 ff ff       	call   12efa <printf>
	printf("DataStartSector: %d\n", boot_info->DataStartSector);
   16c2a:	59                   	pop    %ecx
   16c2b:	5e                   	pop    %esi
   16c2c:	ff 73 1e             	push   0x1e(%ebx)
   16c2f:	68 4f 9e 01 00       	push   $0x19e4f
   16c34:	e8 c1 c2 ff ff       	call   12efa <printf>
	printf("LoaderSize: %d\n", boot_info->LoaderSize);
   16c39:	5f                   	pop    %edi
   16c3a:	58                   	pop    %eax
   16c3b:	ff 73 22             	push   0x22(%ebx)
   16c3e:	68 64 9e 01 00       	push   $0x19e64
   16c43:	e8 b2 c2 ff ff       	call   12efa <printf>
	getchar();
   16c48:	e8 2e c4 ff ff       	call   1307b <getchar>
	// delay_ms(3000);

	const struct console_configuration *console_info = param->console_info;
   16c4d:	8b 45 08             	mov    0x8(%ebp),%eax
   16c50:	8b 58 04             	mov    0x4(%eax),%ebx
	printf("GUI: %s\n", console_info->GUI ? "YES" : "NO");
   16c53:	83 c4 10             	add    $0x10,%esp
   16c56:	b8 57 9c 01 00       	mov    $0x19c57,%eax
   16c5b:	80 3b 00             	cmpb   $0x0,(%ebx)
   16c5e:	75 05                	jne    16c65 <LdrMain+0x43a>
   16c60:	b8 5b 9c 01 00       	mov    $0x19c5b,%eax
   16c65:	52                   	push   %edx
   16c66:	52                   	push   %edx
   16c67:	50                   	push   %eax
   16c68:	68 74 9e 01 00       	push   $0x19e74
   16c6d:	e8 88 c2 ff ff       	call   12efa <printf>
	printf("vbe_version: %d.%d\n", BCD2BIN(console_info->version >> 8), BCD2BIN(console_info->version));
   16c72:	66 8b 43 01          	mov    0x1(%ebx),%ax
   16c76:	83 c4 0c             	add    $0xc,%esp
   16c79:	89 c2                	mov    %eax,%edx
   16c7b:	66 c1 ea 04          	shr    $0x4,%dx
   16c7f:	83 e2 0f             	and    $0xf,%edx
   16c82:	6b d2 0a             	imul   $0xa,%edx,%edx
   16c85:	89 c1                	mov    %eax,%ecx
   16c87:	83 e1 0f             	and    $0xf,%ecx
   16c8a:	01 ca                	add    %ecx,%edx
   16c8c:	52                   	push   %edx
   16c8d:	89 c2                	mov    %eax,%edx
   16c8f:	66 c1 ea 0c          	shr    $0xc,%dx
   16c93:	0f b7 d2             	movzwl %dx,%edx
   16c96:	6b d2 0a             	imul   $0xa,%edx,%edx
   16c99:	66 c1 e8 08          	shr    $0x8,%ax
   16c9d:	83 e0 0f             	and    $0xf,%eax
   16ca0:	01 d0                	add    %edx,%eax
   16ca2:	50                   	push   %eax
   16ca3:	68 7d 9e 01 00       	push   $0x19e7d
   16ca8:	e8 4d c2 ff ff       	call   12efa <printf>
	printf("oem_version: %d.%d\n", BCD2BIN(console_info->oem_version >> 8), BCD2BIN(console_info->oem_version));
   16cad:	66 8b 43 03          	mov    0x3(%ebx),%ax
   16cb1:	83 c4 0c             	add    $0xc,%esp
   16cb4:	89 c2                	mov    %eax,%edx
   16cb6:	66 c1 ea 04          	shr    $0x4,%dx
   16cba:	83 e2 0f             	and    $0xf,%edx
   16cbd:	6b d2 0a             	imul   $0xa,%edx,%edx
   16cc0:	89 c1                	mov    %eax,%ecx
   16cc2:	83 e1 0f             	and    $0xf,%ecx
   16cc5:	01 ca                	add    %ecx,%edx
   16cc7:	52                   	push   %edx
   16cc8:	89 c2                	mov    %eax,%edx
   16cca:	66 c1 ea 0c          	shr    $0xc,%dx
   16cce:	0f b7 d2             	movzwl %dx,%edx
   16cd1:	6b d2 0a             	imul   $0xa,%edx,%edx
   16cd4:	66 c1 e8 08          	shr    $0x8,%ax
   16cd8:	83 e0 0f             	and    $0xf,%eax
   16cdb:	01 d0                	add    %edx,%eax
   16cdd:	50                   	push   %eax
   16cde:	68 91 9e 01 00       	push   $0x19e91
   16ce3:	e8 12 c2 ff ff       	call   12efa <printf>
	printf("width: %d\n", console_info->width);
   16ce8:	59                   	pop    %ecx
   16ce9:	5e                   	pop    %esi
   16cea:	0f b7 43 05          	movzwl 0x5(%ebx),%eax
   16cee:	50                   	push   %eax
   16cef:	68 a5 9e 01 00       	push   $0x19ea5
   16cf4:	e8 01 c2 ff ff       	call   12efa <printf>
	printf("height: %d\n", console_info->height);
   16cf9:	5f                   	pop    %edi
   16cfa:	58                   	pop    %eax
   16cfb:	0f b7 43 07          	movzwl 0x7(%ebx),%eax
   16cff:	50                   	push   %eax
   16d00:	68 b0 9e 01 00       	push   $0x19eb0
   16d05:	e8 f0 c1 ff ff       	call   12efa <printf>
	printf("show_mem_base: 0x%x\n", console_info->show_mem_base);
   16d0a:	58                   	pop    %eax
   16d0b:	5a                   	pop    %edx
   16d0c:	ff 73 09             	push   0x9(%ebx)
   16d0f:	68 bc 9e 01 00       	push   $0x19ebc
   16d14:	e8 e1 c1 ff ff       	call   12efa <printf>
	printf("video_mode_list: 0x%x\n", console_info->video_mode_list);
   16d19:	59                   	pop    %ecx
   16d1a:	5e                   	pop    %esi
   16d1b:	ff 73 0d             	push   0xd(%ebx)
   16d1e:	68 d1 9e 01 00       	push   $0x19ed1
   16d23:	e8 d2 c1 ff ff       	call   12efa <printf>
	printf("total_memory_size: 0x%x\n", console_info->GUI ? console_info->total_memory_size * 64 * 1024 : console_info->total_memory_size);
   16d28:	83 c4 10             	add    $0x10,%esp
   16d2b:	80 3b 00             	cmpb   $0x0,(%ebx)
   16d2e:	0f b7 43 11          	movzwl 0x11(%ebx),%eax
   16d32:	74 03                	je     16d37 <LdrMain+0x50c>
   16d34:	c1 e0 10             	shl    $0x10,%eax
   16d37:	56                   	push   %esi
   16d38:	56                   	push   %esi
   16d39:	50                   	push   %eax
   16d3a:	68 e8 9e 01 00       	push   $0x19ee8
   16d3f:	e8 b6 c1 ff ff       	call   12efa <printf>
	printf("bpp: %d\n", console_info->bpp);
   16d44:	5f                   	pop    %edi
   16d45:	58                   	pop    %eax
   16d46:	0f b6 43 13          	movzbl 0x13(%ebx),%eax
   16d4a:	50                   	push   %eax
   16d4b:	68 01 9f 01 00       	push   $0x19f01
   16d50:	e8 a5 c1 ff ff       	call   12efa <printf>
	printf("Bpl: %d\n", console_info->Bpl);
   16d55:	58                   	pop    %eax
   16d56:	5a                   	pop    %edx
   16d57:	0f b7 43 14          	movzwl 0x14(%ebx),%eax
   16d5b:	50                   	push   %eax
   16d5c:	68 0a 9f 01 00       	push   $0x19f0a
   16d61:	e8 94 c1 ff ff       	call   12efa <printf>
	printf("colums: %d\n", colums);
   16d66:	59                   	pop    %ecx
   16d67:	5e                   	pop    %esi
   16d68:	ff b5 3c ff ff ff    	push   -0xc4(%ebp)
   16d6e:	68 13 9f 01 00       	push   $0x19f13
   16d73:	e8 82 c1 ff ff       	call   12efa <printf>
	printf("rows: %d\n", rows);
   16d78:	5f                   	pop    %edi
   16d79:	58                   	pop    %eax
   16d7a:	ff b5 40 ff ff ff    	push   -0xc0(%ebp)
   16d80:	68 1f 9f 01 00       	push   $0x19f1f
   16d85:	e8 70 c1 ff ff       	call   12efa <printf>
	for (const u16 *mode = (u16 *)console_info->video_mode_list; *mode != 0xFFFF; ++mode)
   16d8a:	8b 5b 0d             	mov    0xd(%ebx),%ebx
   16d8d:	83 c4 10             	add    $0x10,%esp
   16d90:	0f b7 03             	movzwl (%ebx),%eax
   16d93:	66 83 f8 ff          	cmp    $0xffff,%ax
   16d97:	74 12                	je     16dab <LdrMain+0x580>
	{
		printf("%x ", *mode);
   16d99:	51                   	push   %ecx
   16d9a:	51                   	push   %ecx
   16d9b:	50                   	push   %eax
   16d9c:	68 25 93 01 00       	push   $0x19325
   16da1:	e8 54 c1 ff ff       	call   12efa <printf>
	for (const u16 *mode = (u16 *)console_info->video_mode_list; *mode != 0xFFFF; ++mode)
   16da6:	83 c3 02             	add    $0x2,%ebx
   16da9:	eb e2                	jmp    16d8d <LdrMain+0x562>
	}
	print_char('\n');
   16dab:	83 ec 0c             	sub    $0xc,%esp
   16dae:	6a 0a                	push   $0xa
   16db0:	e8 ad bc ff ff       	call   12a62 <print_char>
	getchar();
   16db5:	e8 c1 c2 ff ff       	call   1307b <getchar>
	// delay_ms(3000);

	// print_str("\n\n");
	const struct pci_configuration *pci_info = param->pci_info;
   16dba:	8b 45 08             	mov    0x8(%ebp),%eax
   16dbd:	8b 58 08             	mov    0x8(%eax),%ebx
	print_str("PCI_BIOS version: ");
   16dc0:	c7 04 24 29 9f 01 00 	movl   $0x19f29,(%esp)
   16dc7:	e8 e7 c0 ff ff       	call   12eb3 <print_str>
	if (pci_info->present)
   16dcc:	83 c4 10             	add    $0x10,%esp
   16dcf:	80 7b 04 00          	cmpb   $0x0,0x4(%ebx)
   16dd3:	0f 84 b2 00 00 00    	je     16e8b <LdrMain+0x660>
	{
		printf("%d.%d\n", BCD2BIN(pci_info->version >> 8), BCD2BIN(pci_info->version));
   16dd9:	66 8b 03             	mov    (%ebx),%ax
   16ddc:	52                   	push   %edx
   16ddd:	89 c2                	mov    %eax,%edx
   16ddf:	66 c1 ea 04          	shr    $0x4,%dx
   16de3:	83 e2 0f             	and    $0xf,%edx
   16de6:	6b d2 0a             	imul   $0xa,%edx,%edx
   16de9:	89 c1                	mov    %eax,%ecx
   16deb:	83 e1 0f             	and    $0xf,%ecx
   16dee:	01 ca                	add    %ecx,%edx
   16df0:	52                   	push   %edx
   16df1:	89 c2                	mov    %eax,%edx
   16df3:	66 c1 ea 0c          	shr    $0xc,%dx
   16df7:	0f b7 d2             	movzwl %dx,%edx
   16dfa:	6b d2 0a             	imul   $0xa,%edx,%edx
   16dfd:	66 c1 e8 08          	shr    $0x8,%ax
   16e01:	83 e0 0f             	and    $0xf,%eax
   16e04:	01 d0                	add    %edx,%eax
   16e06:	50                   	push   %eax
   16e07:	68 be 99 01 00       	push   $0x199be
   16e0c:	e8 e9 c0 ff ff       	call   12efa <printf>
		print_str("hw_mechanism:");
   16e11:	c7 04 24 3c 9f 01 00 	movl   $0x19f3c,(%esp)
   16e18:	e8 96 c0 ff ff       	call   12eb3 <print_str>
		if (pci_info->hw_mechanism & 0x1)
   16e1d:	83 c4 10             	add    $0x10,%esp
   16e20:	f6 43 02 01          	testb  $0x1,0x2(%ebx)
   16e24:	74 10                	je     16e36 <LdrMain+0x60b>
			print_str(" mech1");
   16e26:	83 ec 0c             	sub    $0xc,%esp
   16e29:	68 4a 9f 01 00       	push   $0x19f4a
   16e2e:	e8 80 c0 ff ff       	call   12eb3 <print_str>
   16e33:	83 c4 10             	add    $0x10,%esp
		if (pci_info->hw_mechanism & 0x2)
   16e36:	f6 43 02 02          	testb  $0x2,0x2(%ebx)
   16e3a:	74 10                	je     16e4c <LdrMain+0x621>
			print_str(" mech2");
   16e3c:	83 ec 0c             	sub    $0xc,%esp
   16e3f:	68 51 9f 01 00       	push   $0x19f51
   16e44:	e8 6a c0 ff ff       	call   12eb3 <print_str>
   16e49:	83 c4 10             	add    $0x10,%esp
		if (pci_info->hw_mechanism & 0x10)
   16e4c:	f6 43 02 10          	testb  $0x10,0x2(%ebx)
   16e50:	74 10                	je     16e62 <LdrMain+0x637>
			print_str(" cycle1");
   16e52:	83 ec 0c             	sub    $0xc,%esp
   16e55:	68 58 9f 01 00       	push   $0x19f58
   16e5a:	e8 54 c0 ff ff       	call   12eb3 <print_str>
   16e5f:	83 c4 10             	add    $0x10,%esp
		if (pci_info->hw_mechanism & 0x20)
   16e62:	f6 43 02 20          	testb  $0x20,0x2(%ebx)
   16e66:	74 10                	je     16e78 <LdrMain+0x64d>
			print_str(" cycle2");
   16e68:	83 ec 0c             	sub    $0xc,%esp
   16e6b:	68 60 9f 01 00       	push   $0x19f60
   16e70:	e8 3e c0 ff ff       	call   12eb3 <print_str>
   16e75:	83 c4 10             	add    $0x10,%esp
		printf("\nlast_bus: 0x%x\n", pci_info->last_bus);
   16e78:	57                   	push   %edi
   16e79:	57                   	push   %edi
   16e7a:	0f b6 43 03          	movzbl 0x3(%ebx),%eax
   16e7e:	50                   	push   %eax
   16e7f:	68 68 9f 01 00       	push   $0x19f68
   16e84:	e8 71 c0 ff ff       	call   12efa <printf>
   16e89:	eb 0d                	jmp    16e98 <LdrMain+0x66d>
	}
	else
	{
		print_str("None\n");
   16e8b:	83 ec 0c             	sub    $0xc,%esp
   16e8e:	68 79 9f 01 00       	push   $0x19f79
   16e93:	e8 1b c0 ff ff       	call   12eb3 <print_str>
   16e98:	83 c4 10             	add    $0x10,%esp
	}
	getchar();
   16e9b:	e8 db c1 ff ff       	call   1307b <getchar>
	// delay_ms(3000);

	// print_char('\n');
	const struct apm_configuration *apm_info = param->apm_info;
   16ea0:	8b 45 08             	mov    0x8(%ebp),%eax
   16ea3:	8b 58 0c             	mov    0xc(%eax),%ebx
	print_str("APM_BIOS version: ");
   16ea6:	83 ec 0c             	sub    $0xc,%esp
   16ea9:	68 7f 9f 01 00       	push   $0x19f7f
   16eae:	e8 00 c0 ff ff       	call   12eb3 <print_str>
	if (apm_info->ok)
   16eb3:	83 c4 10             	add    $0x10,%esp
   16eb6:	80 7b 19 00          	cmpb   $0x0,0x19(%ebx)
   16eba:	0f 84 ba 00 00 00    	je     16f7a <LdrMain+0x74f>
	{
		printf("%d.%d\n", BCD2BIN(apm_info->version >> 8), BCD2BIN(apm_info->version));
   16ec0:	66 8b 03             	mov    (%ebx),%ax
   16ec3:	57                   	push   %edi
   16ec4:	89 c2                	mov    %eax,%edx
   16ec6:	66 c1 ea 04          	shr    $0x4,%dx
   16eca:	83 e2 0f             	and    $0xf,%edx
   16ecd:	6b d2 0a             	imul   $0xa,%edx,%edx
   16ed0:	89 c1                	mov    %eax,%ecx
   16ed2:	83 e1 0f             	and    $0xf,%ecx
   16ed5:	01 ca                	add    %ecx,%edx
   16ed7:	52                   	push   %edx
   16ed8:	89 c2                	mov    %eax,%edx
   16eda:	66 c1 ea 0c          	shr    $0xc,%dx
   16ede:	0f b7 d2             	movzwl %dx,%edx
   16ee1:	6b d2 0a             	imul   $0xa,%edx,%edx
   16ee4:	66 c1 e8 08          	shr    $0x8,%ax
   16ee8:	83 e0 0f             	and    $0xf,%eax
   16eeb:	01 d0                	add    %edx,%eax
   16eed:	50                   	push   %eax
   16eee:	68 be 99 01 00       	push   $0x199be
   16ef3:	e8 02 c0 ff ff       	call   12efa <printf>
		printf("original_flags: 0x%x\n", apm_info->original_flags);
   16ef8:	58                   	pop    %eax
   16ef9:	5a                   	pop    %edx
   16efa:	0f b6 43 02          	movzbl 0x2(%ebx),%eax
   16efe:	50                   	push   %eax
   16eff:	68 92 9f 01 00       	push   $0x19f92
   16f04:	e8 f1 bf ff ff       	call   12efa <printf>
		printf("cs32_base: 0x%x\n", apm_info->cs32_base);
   16f09:	59                   	pop    %ecx
   16f0a:	5e                   	pop    %esi
   16f0b:	ff 73 03             	push   0x3(%ebx)
   16f0e:	68 a8 9f 01 00       	push   $0x19fa8
   16f13:	e8 e2 bf ff ff       	call   12efa <printf>
		printf("cs32_size: 0x%x\n", apm_info->cs32_size);
   16f18:	5f                   	pop    %edi
   16f19:	58                   	pop    %eax
   16f1a:	0f b7 43 07          	movzwl 0x7(%ebx),%eax
   16f1e:	50                   	push   %eax
   16f1f:	68 b9 9f 01 00       	push   $0x19fb9
   16f24:	e8 d1 bf ff ff       	call   12efa <printf>
		printf("cs16_base: 0x%x\n", apm_info->cs16_base);
   16f29:	58                   	pop    %eax
   16f2a:	5a                   	pop    %edx
   16f2b:	ff 73 09             	push   0x9(%ebx)
   16f2e:	68 ca 9f 01 00       	push   $0x19fca
   16f33:	e8 c2 bf ff ff       	call   12efa <printf>
		printf("cs16_size: 0x%x\n", apm_info->cs16_size);
   16f38:	59                   	pop    %ecx
   16f39:	5e                   	pop    %esi
   16f3a:	0f b7 43 0d          	movzwl 0xd(%ebx),%eax
   16f3e:	50                   	push   %eax
   16f3f:	68 db 9f 01 00       	push   $0x19fdb
   16f44:	e8 b1 bf ff ff       	call   12efa <printf>
		printf("ds_base: 0x%x\n", apm_info->ds_base);
   16f49:	5f                   	pop    %edi
   16f4a:	58                   	pop    %eax
   16f4b:	ff 73 0f             	push   0xf(%ebx)
   16f4e:	68 ec 9f 01 00       	push   $0x19fec
   16f53:	e8 a2 bf ff ff       	call   12efa <printf>
		printf("ds_size: 0x%x\n", apm_info->ds_size);
   16f58:	58                   	pop    %eax
   16f59:	5a                   	pop    %edx
   16f5a:	0f b7 43 13          	movzwl 0x13(%ebx),%eax
   16f5e:	50                   	push   %eax
   16f5f:	68 fb 9f 01 00       	push   $0x19ffb
   16f64:	e8 91 bf ff ff       	call   12efa <printf>
		printf("entry_point: 0x%x\n", apm_info->entry_point);
   16f69:	59                   	pop    %ecx
   16f6a:	5e                   	pop    %esi
   16f6b:	ff 73 15             	push   0x15(%ebx)
   16f6e:	68 0a a0 01 00       	push   $0x1a00a
   16f73:	e8 82 bf ff ff       	call   12efa <printf>
   16f78:	eb 0d                	jmp    16f87 <LdrMain+0x75c>
	}
	else
	{
		print_str("None\n");
   16f7a:	83 ec 0c             	sub    $0xc,%esp
   16f7d:	68 79 9f 01 00       	push   $0x19f79
   16f82:	e8 2c bf ff ff       	call   12eb3 <print_str>
   16f87:	83 c4 10             	add    $0x10,%esp
	}
	getchar();
   16f8a:	e8 ec c0 ff ff       	call   1307b <getchar>
#endif

#if 1
	// print_char('\n');
	const struct e820_entry *ards_buf = param->ards_buf;
	const char *e820_type_str[] = {"Unknown", "RAM", "Reserved", "ACPI_Reclaimable", "ACPI_NVS", "Unusable", "Disabled", "Persistent"};
   16f8f:	8d bd 54 ff ff ff    	lea    -0xac(%ebp),%edi
   16f95:	be a0 a9 01 00       	mov    $0x1a9a0,%esi
   16f9a:	b9 08 00 00 00       	mov    $0x8,%ecx
   16f9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	for (unsigned i = 0; ards_buf[i].Type != 0; ++i)
   16fa1:	8b 45 08             	mov    0x8(%ebp),%eax
   16fa4:	8b 58 10             	mov    0x10(%eax),%ebx
   16fa7:	8b 43 10             	mov    0x10(%ebx),%eax
   16faa:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
   16fb0:	85 c0                	test   %eax,%eax
   16fb2:	0f 84 a6 00 00 00    	je     1705e <LdrMain+0x833>
	{
		print_str("0x");
   16fb8:	83 ec 0c             	sub    $0xc,%esp
   16fbb:	68 2f 8d 01 00       	push   $0x18d2f
   16fc0:	e8 ee be ff ff       	call   12eb3 <print_str>
		if (ards_buf[i].BaseAddrHi)
   16fc5:	8b 43 04             	mov    0x4(%ebx),%eax
   16fc8:	83 c4 10             	add    $0x10,%esp
   16fcb:	85 c0                	test   %eax,%eax
   16fcd:	74 0d                	je     16fdc <LdrMain+0x7b1>
			print_hex(ards_buf[i].BaseAddrHi, 8);
   16fcf:	56                   	push   %esi
   16fd0:	56                   	push   %esi
   16fd1:	6a 08                	push   $0x8
   16fd3:	50                   	push   %eax
   16fd4:	e8 fd bf ff ff       	call   12fd6 <print_hex>
   16fd9:	83 c4 10             	add    $0x10,%esp
		print_hex(ards_buf[i].BaseAddrLow, 8);
   16fdc:	51                   	push   %ecx
   16fdd:	51                   	push   %ecx
   16fde:	6a 08                	push   $0x8
   16fe0:	ff 33                	push   (%ebx)
   16fe2:	e8 ef bf ff ff       	call   12fd6 <print_hex>
		print_str(" 0x");
   16fe7:	c7 04 24 2e 8d 01 00 	movl   $0x18d2e,(%esp)
   16fee:	e8 c0 be ff ff       	call   12eb3 <print_str>
		if (ards_buf[i].LengthHi)
   16ff3:	8b 43 0c             	mov    0xc(%ebx),%eax
   16ff6:	83 c4 10             	add    $0x10,%esp
   16ff9:	85 c0                	test   %eax,%eax
   16ffb:	74 0d                	je     1700a <LdrMain+0x7df>
			print_hex(ards_buf[i].LengthHi, 8);
   16ffd:	52                   	push   %edx
   16ffe:	52                   	push   %edx
   16fff:	6a 08                	push   $0x8
   17001:	50                   	push   %eax
   17002:	e8 cf bf ff ff       	call   12fd6 <print_hex>
   17007:	83 c4 10             	add    $0x10,%esp
		print_hex(ards_buf[i].LengthLow, 8);
   1700a:	50                   	push   %eax
   1700b:	50                   	push   %eax
   1700c:	6a 08                	push   $0x8
   1700e:	ff 73 08             	push   0x8(%ebx)
   17011:	e8 c0 bf ff ff       	call   12fd6 <print_hex>
		print_char(' ');
   17016:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
   1701d:	e8 40 ba ff ff       	call   12a62 <print_char>
		if (ards_buf[i].Type > 7)
   17022:	8b 43 10             	mov    0x10(%ebx),%eax
   17025:	83 c4 10             	add    $0x10,%esp
   17028:	83 f8 07             	cmp    $0x7,%eax
   1702b:	76 0a                	jbe    17037 <LdrMain+0x80c>
			print_str("Undefined");
   1702d:	83 ec 0c             	sub    $0xc,%esp
   17030:	68 1d a0 01 00       	push   $0x1a01d
   17035:	eb 0a                	jmp    17041 <LdrMain+0x816>
		else
			print_str(e820_type_str[ards_buf[i].Type]);
   17037:	83 ec 0c             	sub    $0xc,%esp
   1703a:	ff b4 85 54 ff ff ff 	push   -0xac(%ebp,%eax,4)
   17041:	e8 6d be ff ff       	call   12eb3 <print_str>
   17046:	83 c4 10             	add    $0x10,%esp
		print_char('\n');
   17049:	83 ec 0c             	sub    $0xc,%esp
   1704c:	6a 0a                	push   $0xa
   1704e:	e8 0f ba ff ff       	call   12a62 <print_char>
	for (unsigned i = 0; ards_buf[i].Type != 0; ++i)
   17053:	83 c3 14             	add    $0x14,%ebx
   17056:	83 c4 10             	add    $0x10,%esp
   17059:	e9 49 ff ff ff       	jmp    16fa7 <LdrMain+0x77c>
	}
	getchar();
   1705e:	e8 18 c0 ff ff       	call   1307b <getchar>
#if 1
	// print_str("\nshell>lspci\n");
	struct pci_dev_info dev_info;
	bool mf;
	u32 i = 0;
	for (dev_info.bus = 0; dev_info.bus <= 255; ++dev_info.bus)
   17063:	31 db                	xor    %ebx,%ebx
	u32 i = 0;
   17065:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%ebp)
   1706c:	00 00 00 
	u8 *p = map_mem(SmbiosEpsPtr->StructureAddress, SmbiosEpsPtr->StructureLength), *s = p, *e = s + SmbiosEpsPtr->StructureLength;
   1706f:	31 ff                	xor    %edi,%edi
	printf("GUI: %s\n", console_info->GUI ? "YES" : "NO");
   17071:	31 f6                	xor    %esi,%esi
   17073:	c6 85 30 ff ff ff 00 	movb   $0x0,-0xd0(%ebp)
		for (dev_info.dev = 0; dev_info.dev <= 31; ++dev_info.dev)
		{
			mf = false;
			for (dev_info.func = 0; dev_info.func <= 7; ++dev_info.func)
			{
				u32 dev_ven = pci_conf_read_dword(dev_info.bus, dev_info.dev, dev_info.func, 0x0);
   1707a:	6a 00                	push   $0x0
   1707c:	56                   	push   %esi
   1707d:	57                   	push   %edi
   1707e:	53                   	push   %ebx
   1707f:	e8 5f e6 ff ff       	call   156e3 <pci_conf_read_dword>
   17084:	89 c2                	mov    %eax,%edx
				if ((dev_ven & 0xffff) == 0xffff)
   17086:	0f b7 c0             	movzwl %ax,%eax
   17089:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%ebp)
   1708f:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
   17095:	83 c4 10             	add    $0x10,%esp
   17098:	3d ff ff 00 00       	cmp    $0xffff,%eax
   1709d:	0f 84 35 01 00 00    	je     171d8 <LdrMain+0x9ad>
					continue;
				u8 htype = pci_conf_read_byte(dev_info.bus, dev_info.dev, dev_info.func, 0xe);
   170a3:	6a 0e                	push   $0xe
   170a5:	56                   	push   %esi
   170a6:	57                   	push   %edi
   170a7:	53                   	push   %ebx
   170a8:	e8 a8 e6 ff ff       	call   15755 <pci_conf_read_byte>
				if ((htype & 0x7f) > 2)
   170ad:	88 c1                	mov    %al,%cl
   170af:	83 e1 7f             	and    $0x7f,%ecx
   170b2:	88 8d 34 ff ff ff    	mov    %cl,-0xcc(%ebp)
   170b8:	83 c4 10             	add    $0x10,%esp
   170bb:	80 f9 02             	cmp    $0x2,%cl
   170be:	0f 87 14 01 00 00    	ja     171d8 <LdrMain+0x9ad>
					continue;
				if (!mf)
   170c4:	80 bd 30 ff ff ff 00 	cmpb   $0x0,-0xd0(%ebp)
   170cb:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
   170d1:	75 09                	jne    170dc <LdrMain+0x8b1>
					mf = (htype & 0x80) == 0x80;
   170d3:	c0 e8 07             	shr    $0x7,%al
   170d6:	88 85 30 ff ff ff    	mov    %al,-0xd0(%ebp)

				dev_info.mf = (htype & 0x80) == 0x80;
				dev_info.type = htype & 0x7f;
				dev_info.dev_id = dev_ven >> 16;
   170dc:	c1 ea 10             	shr    $0x10,%edx
   170df:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%ebp)
				dev_info.ven_id = dev_ven & 0xffff;

				if (++i == rows)
   170e5:	ff 85 2c ff ff ff    	incl   -0xd4(%ebp)
   170eb:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
   170f1:	39 85 40 ff ff ff    	cmp    %eax,-0xc0(%ebp)
   170f7:	75 0f                	jne    17108 <LdrMain+0x8dd>
				{
					i = 0;
					getchar();
   170f9:	e8 7d bf ff ff       	call   1307b <getchar>
					i = 0;
   170fe:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%ebp)
   17105:	00 00 00 
	printf("%x:%x.%x type_%x&ven_%x&dev_%x",
   17108:	50                   	push   %eax
   17109:	ff b5 20 ff ff ff    	push   -0xe0(%ebp)
   1710f:	ff b5 24 ff ff ff    	push   -0xdc(%ebp)
   17115:	0f b6 85 34 ff ff ff 	movzbl -0xcc(%ebp),%eax
   1711c:	50                   	push   %eax
   1711d:	56                   	push   %esi
   1711e:	57                   	push   %edi
   1711f:	53                   	push   %ebx
   17120:	68 27 a0 01 00       	push   $0x1a027
   17125:	e8 d0 bd ff ff       	call   12efa <printf>
	u32 class_rev = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, 2);
   1712a:	83 c4 20             	add    $0x20,%esp
   1712d:	6a 02                	push   $0x2
   1712f:	56                   	push   %esi
   17130:	57                   	push   %edi
   17131:	53                   	push   %ebx
   17132:	e8 ac e5 ff ff       	call   156e3 <pci_conf_read_dword>
	printf("&rev_%x&class_%x_%x_%x", class_rev & 0xff, class >> 16, (class >> 8) & 0xff, class & 0xff);
   17137:	0f b6 d4             	movzbl %ah,%edx
   1713a:	89 14 24             	mov    %edx,(%esp)
   1713d:	89 c2                	mov    %eax,%edx
   1713f:	c1 ea 10             	shr    $0x10,%edx
   17142:	0f b6 d2             	movzbl %dl,%edx
   17145:	52                   	push   %edx
   17146:	89 c2                	mov    %eax,%edx
   17148:	c1 ea 18             	shr    $0x18,%edx
   1714b:	52                   	push   %edx
   1714c:	0f b6 c0             	movzbl %al,%eax
   1714f:	50                   	push   %eax
   17150:	68 46 a0 01 00       	push   $0x1a046
   17155:	e8 a0 bd ff ff       	call   12efa <printf>
	if (dev_info->type != PCI_DEV_TYPE_PCI2PCI_BRIDGE) // PCI-to-PCI Bridge
   1715a:	83 c4 20             	add    $0x20,%esp
   1715d:	80 bd 34 ff ff ff 01 	cmpb   $0x1,-0xcc(%ebp)
   17164:	74 5c                	je     171c2 <LdrMain+0x997>
		print_str("&subsys_");
   17166:	83 ec 0c             	sub    $0xc,%esp
   17169:	68 5d a0 01 00       	push   $0x1a05d
   1716e:	e8 40 bd ff ff       	call   12eb3 <print_str>
		if (dev_info->type == PCI_DEV_TYPE_DEVICE) // General Device
   17173:	83 c4 10             	add    $0x10,%esp
   17176:	80 bd 34 ff ff ff 00 	cmpb   $0x0,-0xcc(%ebp)
   1717d:	75 23                	jne    171a2 <LdrMain+0x977>
			u32 subsys_ven = pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, 11);
   1717f:	6a 0b                	push   $0xb
   17181:	56                   	push   %esi
   17182:	57                   	push   %edi
   17183:	53                   	push   %ebx
   17184:	e8 5a e5 ff ff       	call   156e3 <pci_conf_read_dword>
			printf("%x_%x", subsys_ven & 0xffff, subsys_ven >> 16);
   17189:	83 c4 0c             	add    $0xc,%esp
   1718c:	89 c2                	mov    %eax,%edx
   1718e:	c1 ea 10             	shr    $0x10,%edx
   17191:	52                   	push   %edx
   17192:	0f b7 c0             	movzwl %ax,%eax
   17195:	50                   	push   %eax
   17196:	68 57 a0 01 00       	push   $0x1a057
   1719b:	e8 5a bd ff ff       	call   12efa <printf>
   171a0:	eb 1d                	jmp    171bf <LdrMain+0x994>
		else if (dev_info->type == PCI_DEV_TYPE_CARDBUS_BRIDGE) // PCI-to-CardBus bridge
   171a2:	80 bd 34 ff ff ff 02 	cmpb   $0x2,-0xcc(%ebp)
   171a9:	75 17                	jne    171c2 <LdrMain+0x997>
			print_hex(pci_conf_read_dword(dev_info->bus, dev_info->dev, dev_info->func, 0x10), 4);
   171ab:	6a 10                	push   $0x10
   171ad:	56                   	push   %esi
   171ae:	57                   	push   %edi
   171af:	53                   	push   %ebx
   171b0:	e8 2e e5 ff ff       	call   156e3 <pci_conf_read_dword>
   171b5:	5a                   	pop    %edx
   171b6:	59                   	pop    %ecx
   171b7:	6a 04                	push   $0x4
   171b9:	50                   	push   %eax
   171ba:	e8 17 be ff ff       	call   12fd6 <print_hex>
   171bf:	83 c4 10             	add    $0x10,%esp
	print_char('\n');
   171c2:	83 ec 0c             	sub    $0xc,%esp
   171c5:	6a 0a                	push   $0xa
   171c7:	e8 96 b8 ff ff       	call   12a62 <print_char>
				}
				print_pci_conf_info(&dev_info);

				if (!mf)
   171cc:	83 c4 10             	add    $0x10,%esp
   171cf:	80 bd 30 ff ff ff 00 	cmpb   $0x0,-0xd0(%ebp)
   171d6:	74 0a                	je     171e2 <LdrMain+0x9b7>
			for (dev_info.func = 0; dev_info.func <= 7; ++dev_info.func)
   171d8:	46                   	inc    %esi
   171d9:	83 fe 08             	cmp    $0x8,%esi
   171dc:	0f 85 98 fe ff ff    	jne    1707a <LdrMain+0x84f>
		for (dev_info.dev = 0; dev_info.dev <= 31; ++dev_info.dev)
   171e2:	47                   	inc    %edi
   171e3:	83 ff 20             	cmp    $0x20,%edi
   171e6:	0f 85 85 fe ff ff    	jne    17071 <LdrMain+0x846>
	for (dev_info.bus = 0; dev_info.bus <= 255; ++dev_info.bus)
   171ec:	43                   	inc    %ebx
   171ed:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
   171f3:	0f 85 76 fe ff ff    	jne    1706f <LdrMain+0x844>
					break;
			}
		}
	}
	getchar();
   171f9:	e8 7d be ff ff       	call   1307b <getchar>
	{
		apm_shutdown();
	}
#endif

	u32 EbdaAddr = (u32)(*(volatile const u16 *)0x40E) << 4;
   171fe:	0f b7 05 0e 04 00 00 	movzwl 0x40e,%eax
   17205:	c1 e0 04             	shl    $0x4,%eax
   17208:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
	u32 BaseMemSize = (u32)(*(volatile const u16 *)0x413) * 1024;
   1720e:	0f b7 1d 13 04 00 00 	movzwl 0x413,%ebx
   17215:	c1 e3 0a             	shl    $0xa,%ebx
	printf("EBDA Addr  =0x%x\n", EbdaAddr);
   17218:	56                   	push   %esi
   17219:	56                   	push   %esi
   1721a:	50                   	push   %eax
   1721b:	68 66 a0 01 00       	push   $0x1a066
   17220:	e8 d5 bc ff ff       	call   12efa <printf>
	printf("BaseMemSize=0x%x\n\n", BaseMemSize);
   17225:	5f                   	pop    %edi
   17226:	58                   	pop    %eax
   17227:	53                   	push   %ebx
   17228:	68 78 a0 01 00       	push   $0x1a078
   1722d:	e8 c8 bc ff ff       	call   12efa <printf>

	mpfp_s *mpfp_ptr = MpfpSearch(EbdaAddr, 1024);
   17232:	ba 00 04 00 00       	mov    $0x400,%edx
   17237:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   1723d:	e8 02 f4 ff ff       	call   16644 <MpfpSearch>
   17242:	89 c6                	mov    %eax,%esi
	if (!mpfp_ptr)
   17244:	83 c4 10             	add    $0x10,%esp
   17247:	85 c0                	test   %eax,%eax
   17249:	75 35                	jne    17280 <LdrMain+0xa55>
		mpfp_ptr = MpfpSearch(BaseMemSize - 1024, 1024);
   1724b:	8d 83 00 fc ff ff    	lea    -0x400(%ebx),%eax
   17251:	ba 00 04 00 00       	mov    $0x400,%edx
   17256:	e8 e9 f3 ff ff       	call   16644 <MpfpSearch>
   1725b:	89 c6                	mov    %eax,%esi
	if (!mpfp_ptr)
   1725d:	85 c0                	test   %eax,%eax
   1725f:	75 1f                	jne    17280 <LdrMain+0xa55>
		mpfp_ptr = MpfpSearch(0xE0000, 0x20000);
   17261:	ba 00 00 02 00       	mov    $0x20000,%edx
   17266:	b8 00 00 0e 00       	mov    $0xe0000,%eax
   1726b:	e8 d4 f3 ff ff       	call   16644 <MpfpSearch>
   17270:	89 c6                	mov    %eax,%esi
	if (!mpfp_ptr)
   17272:	85 c0                	test   %eax,%eax
   17274:	75 0a                	jne    17280 <LdrMain+0xa55>
	{
		printf("MPFP not found!\n");
   17276:	83 ec 0c             	sub    $0xc,%esp
   17279:	68 8b a0 01 00       	push   $0x1a08b
   1727e:	eb 77                	jmp    172f7 <LdrMain+0xacc>
		getchar();
	}
	else
	{
		printf("MPFP Addresss=0x%x\n", mpfp_ptr);
   17280:	53                   	push   %ebx
   17281:	53                   	push   %ebx
   17282:	56                   	push   %esi
   17283:	68 9c a0 01 00       	push   $0x1a09c
   17288:	e8 6d bc ff ff       	call   12efa <printf>
		printf("MPCFG Address=0x%x\n", mpfp_ptr->MpCfgAddress);
   1728d:	5f                   	pop    %edi
   1728e:	58                   	pop    %eax
   1728f:	ff 76 04             	push   0x4(%esi)
   17292:	68 b0 a0 01 00       	push   $0x1a0b0
   17297:	e8 5e bc ff ff       	call   12efa <printf>
		printf("Revision     =%d\n", mpfp_ptr->Revision);
   1729c:	58                   	pop    %eax
   1729d:	5a                   	pop    %edx
   1729e:	0f b6 46 09          	movzbl 0x9(%esi),%eax
   172a2:	50                   	push   %eax
   172a3:	68 ee a8 01 00       	push   $0x1a8ee
   172a8:	e8 4d bc ff ff       	call   12efa <printf>
		printf("MPCFG Type   =%d\n", mpfp_ptr->MpCfgType);
   172ad:	59                   	pop    %ecx
   172ae:	5b                   	pop    %ebx
   172af:	0f b6 46 0b          	movzbl 0xb(%esi),%eax
   172b3:	50                   	push   %eax
   172b4:	68 c4 a0 01 00       	push   $0x1a0c4
   172b9:	e8 3c bc ff ff       	call   12efa <printf>
		printf("Feature      =0x%x, %s\n", mpfp_ptr->Feature,
			   mpfp_ptr->Feature & 0x80 ? "IMCR(PIC Mode)" : "Virtual Wire Mode");
   172be:	0f b6 46 0c          	movzbl 0xc(%esi),%eax
		printf("Feature      =0x%x, %s\n", mpfp_ptr->Feature,
   172c2:	83 c4 10             	add    $0x10,%esp
   172c5:	ba 5e 9c 01 00       	mov    $0x19c5e,%edx
   172ca:	84 c0                	test   %al,%al
   172cc:	78 05                	js     172d3 <LdrMain+0xaa8>
   172ce:	ba 6d 9c 01 00       	mov    $0x19c6d,%edx
   172d3:	51                   	push   %ecx
   172d4:	52                   	push   %edx
   172d5:	50                   	push   %eax
   172d6:	68 d6 a0 01 00       	push   $0x1a0d6
   172db:	e8 1a bc ff ff       	call   12efa <printf>
		if (!mpfp_ptr->MpCfgAddress || mpfp_ptr->MpCfgType)
   172e0:	83 c4 10             	add    $0x10,%esp
   172e3:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
   172e7:	74 06                	je     172ef <LdrMain+0xac4>
   172e9:	80 7e 0b 00          	cmpb   $0x0,0xb(%esi)
   172ed:	74 17                	je     17306 <LdrMain+0xadb>
		{
			printf("MPCFG not present!\n");
   172ef:	83 ec 0c             	sub    $0xc,%esp
   172f2:	68 ee a0 01 00       	push   $0x1a0ee
   172f7:	e8 fe bb ff ff       	call   12efa <printf>
			getchar();
   172fc:	e8 7a bd ff ff       	call   1307b <getchar>
   17301:	e9 5b 05 00 00       	jmp    17861 <LdrMain+0x1036>
		}
		else
		{
			getchar();
   17306:	e8 70 bd ff ff       	call   1307b <getchar>
	mpct_header_s *mpct_header = map_mem(mpfp_ptr->MpCfgAddress, sizeof(mpct_header_s));
   1730b:	57                   	push   %edi
   1730c:	57                   	push   %edi
   1730d:	6a 2c                	push   $0x2c
   1730f:	ff 76 04             	push   0x4(%esi)
   17312:	e8 2b e1 ff ff       	call   15442 <map_mem>
   17317:	89 c3                	mov    %eax,%ebx
		if (memcmp(mpct_header->Signature, "PCMP", 4))
   17319:	83 c4 0c             	add    $0xc,%esp
   1731c:	6a 04                	push   $0x4
   1731e:	68 02 a1 01 00       	push   $0x1a102
   17323:	50                   	push   %eax
   17324:	e8 42 f1 ff ff       	call   1646b <memcmp>
   17329:	83 c4 10             	add    $0x10,%esp
   1732c:	85 c0                	test   %eax,%eax
   1732e:	74 0d                	je     1733d <LdrMain+0xb12>
			printf("invalid MPCT_Header signature!\n");
   17330:	83 ec 0c             	sub    $0xc,%esp
   17333:	68 07 a1 01 00       	push   $0x1a107
   17338:	e9 6e 04 00 00       	jmp    177ab <LdrMain+0xf80>
		if (sizeof(mpct_header_s) > mpct_header->Length)
   1733d:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
   17341:	66 83 f8 2b          	cmp    $0x2b,%ax
   17345:	77 0d                	ja     17354 <LdrMain+0xb29>
			printf("incorrect MPCT_Header length=%d\n", mpct_header->Length);
   17347:	56                   	push   %esi
   17348:	56                   	push   %esi
   17349:	50                   	push   %eax
   1734a:	68 27 a1 01 00       	push   $0x1a127
   1734f:	e9 57 04 00 00       	jmp    177ab <LdrMain+0xf80>
		if (checksum_add(mpct_header, mpct_header->Length))
   17354:	51                   	push   %ecx
   17355:	51                   	push   %ecx
   17356:	50                   	push   %eax
   17357:	53                   	push   %ebx
   17358:	e8 63 db ff ff       	call   14ec0 <checksum_add>
   1735d:	83 c4 10             	add    $0x10,%esp
   17360:	84 c0                	test   %al,%al
   17362:	74 0d                	je     17371 <LdrMain+0xb46>
			printf("invalid MPCT_Header checksum!\n");
   17364:	83 ec 0c             	sub    $0xc,%esp
   17367:	68 48 a1 01 00       	push   $0x1a148
   1736c:	e9 3a 04 00 00       	jmp    177ab <LdrMain+0xf80>
		if (mpct_header->ExtTableSize)
   17371:	0f b7 43 28          	movzwl 0x28(%ebx),%eax
   17375:	66 85 c0             	test   %ax,%ax
   17378:	74 20                	je     1739a <LdrMain+0xb6f>
			void *full_map = map_mem(mpfp_ptr->MpCfgAddress, mpct_header->Length + mpct_header->ExtTableSize);
   1737a:	52                   	push   %edx
   1737b:	52                   	push   %edx
   1737c:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
   17380:	01 d0                	add    %edx,%eax
   17382:	50                   	push   %eax
   17383:	ff 76 04             	push   0x4(%esi)
   17386:	e8 b7 e0 ff ff       	call   15442 <map_mem>
   1738b:	89 c6                	mov    %eax,%esi
			unmap_mem(mpct_header);
   1738d:	89 1c 24             	mov    %ebx,(%esp)
   17390:	e8 0d e3 ff ff       	call   156a2 <unmap_mem>
   17395:	83 c4 10             	add    $0x10,%esp
			mpct_header = full_map;
   17398:	89 f3                	mov    %esi,%ebx
		printf("Revision     =%d\n", mpct_header->Revision);
   1739a:	50                   	push   %eax
   1739b:	50                   	push   %eax
   1739c:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
   173a0:	50                   	push   %eax
   173a1:	68 ee a8 01 00       	push   $0x1a8ee
   173a6:	e8 4f bb ff ff       	call   12efa <printf>
		memcpy(buf, mpct_header->OemId, 8);
   173ab:	83 c4 0c             	add    $0xc,%esp
   173ae:	6a 08                	push   $0x8
   173b0:	8d 43 08             	lea    0x8(%ebx),%eax
   173b3:	50                   	push   %eax
   173b4:	8d 75 a8             	lea    -0x58(%ebp),%esi
   173b7:	56                   	push   %esi
   173b8:	e8 86 f0 ff ff       	call   16443 <memcpy>
		buf[8] = 0;
   173bd:	c6 45 b0 00          	movb   $0x0,-0x50(%ebp)
		printf("OemId        =%s\n", buf);
   173c1:	58                   	pop    %eax
   173c2:	5a                   	pop    %edx
   173c3:	56                   	push   %esi
   173c4:	68 67 a1 01 00       	push   $0x1a167
   173c9:	e8 2c bb ff ff       	call   12efa <printf>
		memcpy(buf, mpct_header->ProductId, 12);
   173ce:	83 c4 0c             	add    $0xc,%esp
   173d1:	6a 0c                	push   $0xc
   173d3:	8d 43 10             	lea    0x10(%ebx),%eax
   173d6:	50                   	push   %eax
   173d7:	56                   	push   %esi
   173d8:	e8 66 f0 ff ff       	call   16443 <memcpy>
		buf[12] = 0;
   173dd:	c6 45 b4 00          	movb   $0x0,-0x4c(%ebp)
		printf("ProductId    =%s\n", buf);
   173e1:	59                   	pop    %ecx
   173e2:	5f                   	pop    %edi
   173e3:	56                   	push   %esi
   173e4:	68 79 a1 01 00       	push   $0x1a179
   173e9:	e8 0c bb ff ff       	call   12efa <printf>
		printf("OemTableAddr =0x%x\n", mpct_header->OemTableAddress);
   173ee:	58                   	pop    %eax
   173ef:	5a                   	pop    %edx
   173f0:	ff 73 1c             	push   0x1c(%ebx)
   173f3:	68 8b a1 01 00       	push   $0x1a18b
   173f8:	e8 fd ba ff ff       	call   12efa <printf>
		printf("OemTableSize =%d\n", mpct_header->OemTableSize);
   173fd:	59                   	pop    %ecx
   173fe:	5e                   	pop    %esi
   173ff:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
   17403:	50                   	push   %eax
   17404:	68 9f a1 01 00       	push   $0x1a19f
   17409:	e8 ec ba ff ff       	call   12efa <printf>
		printf("EntryCount   =%d\n", mpct_header->EntryCount);
   1740e:	5f                   	pop    %edi
   1740f:	58                   	pop    %eax
   17410:	0f b7 43 22          	movzwl 0x22(%ebx),%eax
   17414:	50                   	push   %eax
   17415:	68 b1 a1 01 00       	push   $0x1a1b1
   1741a:	e8 db ba ff ff       	call   12efa <printf>
		printf("LAPIC Address=0x%x\n", mpct_header->LapicAddress);
   1741f:	58                   	pop    %eax
   17420:	5a                   	pop    %edx
   17421:	ff 73 24             	push   0x24(%ebx)
   17424:	68 c3 a1 01 00       	push   $0x1a1c3
   17429:	e8 cc ba ff ff       	call   12efa <printf>
		printf("ExtTableSize =%d\n", mpct_header->ExtTableSize);
   1742e:	59                   	pop    %ecx
   1742f:	5e                   	pop    %esi
   17430:	0f b7 43 28          	movzwl 0x28(%ebx),%eax
   17434:	50                   	push   %eax
   17435:	68 d7 a1 01 00       	push   $0x1a1d7
   1743a:	e8 bb ba ff ff       	call   12efa <printf>
		printf("ExtChecksum  =0x%x\n", mpct_header->ExtTableChecksum);
   1743f:	5f                   	pop    %edi
   17440:	58                   	pop    %eax
   17441:	0f b6 43 2a          	movzbl 0x2a(%ebx),%eax
   17445:	50                   	push   %eax
   17446:	68 e9 a1 01 00       	push   $0x1a1e9
   1744b:	e8 aa ba ff ff       	call   12efa <printf>
		if (mpct_header->ExtTableSize)
   17450:	0f b7 43 28          	movzwl 0x28(%ebx),%eax
   17454:	83 c4 10             	add    $0x10,%esp
   17457:	66 85 c0             	test   %ax,%ax
   1745a:	74 40                	je     1749c <LdrMain+0xc71>
			u8 sum = checksum_add((u8 *)mpct_header + mpct_header->Length, mpct_header->ExtTableSize);
   1745c:	51                   	push   %ecx
   1745d:	51                   	push   %ecx
   1745e:	50                   	push   %eax
   1745f:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
   17463:	01 d8                	add    %ebx,%eax
   17465:	50                   	push   %eax
   17466:	e8 55 da ff ff       	call   14ec0 <checksum_add>
			printf("ext_checksum =0x%x\n", sum);
   1746b:	5e                   	pop    %esi
   1746c:	5f                   	pop    %edi
   1746d:	0f b6 d0             	movzbl %al,%edx
   17470:	88 85 30 ff ff ff    	mov    %al,-0xd0(%ebp)
   17476:	52                   	push   %edx
   17477:	68 fd a1 01 00       	push   $0x1a1fd
   1747c:	e8 79 ba ff ff       	call   12efa <printf>
			if ((sum + mpct_header->ExtTableChecksum) & 0xff)
   17481:	83 c4 10             	add    $0x10,%esp
   17484:	8a 85 30 ff ff ff    	mov    -0xd0(%ebp),%al
   1748a:	02 43 2a             	add    0x2a(%ebx),%al
   1748d:	74 0d                	je     1749c <LdrMain+0xc71>
				printf("invalid MPCT_Header_ExtTable checksum!\n");
   1748f:	83 ec 0c             	sub    $0xc,%esp
   17492:	68 11 a2 01 00       	push   $0x1a211
   17497:	e9 0f 03 00 00       	jmp    177ab <LdrMain+0xf80>
		getchar();
   1749c:	e8 da bb ff ff       	call   1307b <getchar>
		for (u8 *s = (u8 *)(mpct_header + 1), *e = (u8 *)mpct_header + mpct_header->Length; s < e;)
   174a1:	8d 73 2c             	lea    0x2c(%ebx),%esi
   174a4:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
   174a8:	01 d8                	add    %ebx,%eax
   174aa:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
   174b0:	39 b5 30 ff ff ff    	cmp    %esi,-0xd0(%ebp)
   174b6:	0f 86 49 02 00 00    	jbe    17705 <LdrMain+0xeda>
			if (entry->Type == MPC_TYPE_LAPIC)
   174bc:	0f b6 06             	movzbl (%esi),%eax
   174bf:	84 c0                	test   %al,%al
   174c1:	74 0e                	je     174d1 <LdrMain+0xca6>
			else if (entry->Type <= MPC_TYPE_LIA)
   174c3:	3c 04                	cmp    $0x4,%al
   174c5:	76 11                	jbe    174d8 <LdrMain+0xcad>
				printf("invalid entry Type=%d\n", entry->Type);
   174c7:	52                   	push   %edx
   174c8:	52                   	push   %edx
   174c9:	50                   	push   %eax
   174ca:	68 39 a2 01 00       	push   $0x1a239
   174cf:	eb 24                	jmp    174f5 <LdrMain+0xcca>
				EntrySize = sizeof(mpct_lapic_s);
   174d1:	bf 14 00 00 00       	mov    $0x14,%edi
   174d6:	eb 05                	jmp    174dd <LdrMain+0xcb2>
				EntrySize = 8;
   174d8:	bf 08 00 00 00       	mov    $0x8,%edi
			if ((u32)e - (u32)s < EntrySize)
   174dd:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
   174e3:	29 f2                	sub    %esi,%edx
   174e5:	39 fa                	cmp    %edi,%edx
   174e7:	73 19                	jae    17502 <LdrMain+0xcd7>
				printf("incorrect MPCT_Header length=%d\n", mpct_header->Length);
   174e9:	50                   	push   %eax
   174ea:	50                   	push   %eax
   174eb:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
   174ef:	50                   	push   %eax
   174f0:	68 27 a1 01 00       	push   $0x1a127
   174f5:	e8 00 ba ff ff       	call   12efa <printf>
				break;
   174fa:	83 c4 10             	add    $0x10,%esp
   174fd:	e9 03 02 00 00       	jmp    17705 <LdrMain+0xeda>
			switch (entry->Type)
   17502:	3c 04                	cmp    $0x4,%al
   17504:	0f 87 ef 01 00 00    	ja     176f9 <LdrMain+0xece>
   1750a:	ff 24 85 00 aa 01 00 	jmp    *0x1aa00(,%eax,4)
				printf("LAPIC Id     =%d\n", lapic_ptr->LapicId);
   17511:	51                   	push   %ecx
   17512:	51                   	push   %ecx
   17513:	0f b6 46 01          	movzbl 0x1(%esi),%eax
   17517:	50                   	push   %eax
   17518:	68 50 a2 01 00       	push   $0x1a250
   1751d:	e8 d8 b9 ff ff       	call   12efa <printf>
				printf("LAPIC Ver    =%d\n", lapic_ptr->LapicVer);
   17522:	58                   	pop    %eax
   17523:	5a                   	pop    %edx
   17524:	0f b6 46 02          	movzbl 0x2(%esi),%eax
   17528:	50                   	push   %eax
   17529:	68 62 a2 01 00       	push   $0x1a262
   1752e:	e8 c7 b9 ff ff       	call   12efa <printf>
				printf("Flags        =0x%x,", lapic_ptr->Flags);
   17533:	59                   	pop    %ecx
   17534:	58                   	pop    %eax
   17535:	0f b6 46 03          	movzbl 0x3(%esi),%eax
   17539:	50                   	push   %eax
   1753a:	68 74 a2 01 00       	push   $0x1a274
   1753f:	e8 b6 b9 ff ff       	call   12efa <printf>
				if (!(lapic_ptr->Flags & 0x1))
   17544:	83 c4 10             	add    $0x10,%esp
   17547:	f6 46 03 01          	testb  $0x1,0x3(%esi)
   1754b:	75 10                	jne    1755d <LdrMain+0xd32>
					print_str(" Unusable");
   1754d:	83 ec 0c             	sub    $0xc,%esp
   17550:	68 01 a3 01 00       	push   $0x1a301
   17555:	e8 59 b9 ff ff       	call   12eb3 <print_str>
   1755a:	83 c4 10             	add    $0x10,%esp
				if (lapic_ptr->Flags & 0x2)
   1755d:	f6 46 03 02          	testb  $0x2,0x3(%esi)
   17561:	74 0a                	je     1756d <LdrMain+0xd42>
					print_str(" BP");
   17563:	83 ec 0c             	sub    $0xc,%esp
   17566:	68 88 a2 01 00       	push   $0x1a288
   1756b:	eb 08                	jmp    17575 <LdrMain+0xd4a>
					print_str(" AP");
   1756d:	83 ec 0c             	sub    $0xc,%esp
   17570:	68 8c a2 01 00       	push   $0x1a28c
   17575:	e8 39 b9 ff ff       	call   12eb3 <print_str>
   1757a:	83 c4 10             	add    $0x10,%esp
				printf("\nCPU Signature=0x%x\n", lapic_ptr->CpuSignature);
   1757d:	51                   	push   %ecx
   1757e:	51                   	push   %ecx
   1757f:	ff 76 04             	push   0x4(%esi)
   17582:	68 90 a2 01 00       	push   $0x1a290
   17587:	e8 6e b9 ff ff       	call   12efa <printf>
				printf("CPU Features =0x%x\n", lapic_ptr->CpuFeatures);
   1758c:	58                   	pop    %eax
   1758d:	5a                   	pop    %edx
   1758e:	ff 76 08             	push   0x8(%esi)
   17591:	68 a5 a2 01 00       	push   $0x1a2a5
   17596:	e9 56 01 00 00       	jmp    176f1 <LdrMain+0xec6>
				printf("BUS Id  =%d\n", bus_ptr->BusId);
   1759b:	50                   	push   %eax
   1759c:	50                   	push   %eax
   1759d:	0f b6 46 01          	movzbl 0x1(%esi),%eax
   175a1:	50                   	push   %eax
   175a2:	68 d2 a3 01 00       	push   $0x1a3d2
   175a7:	e8 4e b9 ff ff       	call   12efa <printf>
				memcpy(buf, bus_ptr->BusType, 6);
   175ac:	83 c4 0c             	add    $0xc,%esp
   175af:	6a 06                	push   $0x6
   175b1:	8d 46 02             	lea    0x2(%esi),%eax
   175b4:	50                   	push   %eax
   175b5:	8d 45 a8             	lea    -0x58(%ebp),%eax
   175b8:	50                   	push   %eax
   175b9:	e8 85 ee ff ff       	call   16443 <memcpy>
				buf[6] = 0;
   175be:	c6 45 ae 00          	movb   $0x0,-0x52(%ebp)
				printf("BUS type=%d\n", buf);
   175c2:	58                   	pop    %eax
   175c3:	5a                   	pop    %edx
   175c4:	8d 45 a8             	lea    -0x58(%ebp),%eax
   175c7:	50                   	push   %eax
   175c8:	68 b9 a2 01 00       	push   $0x1a2b9
   175cd:	e9 1f 01 00 00       	jmp    176f1 <LdrMain+0xec6>
				printf("IOAPIC Id     =%d\n", ioapic_ptr->IoapicId);
   175d2:	50                   	push   %eax
   175d3:	50                   	push   %eax
   175d4:	0f b6 46 01          	movzbl 0x1(%esi),%eax
   175d8:	50                   	push   %eax
   175d9:	68 c6 a2 01 00       	push   $0x1a2c6
   175de:	e8 17 b9 ff ff       	call   12efa <printf>
				printf("IOAPIC Ver    =%d\n", ioapic_ptr->IoapicVer);
   175e3:	58                   	pop    %eax
   175e4:	5a                   	pop    %edx
   175e5:	0f b6 46 02          	movzbl 0x2(%esi),%eax
   175e9:	50                   	push   %eax
   175ea:	68 d9 a2 01 00       	push   $0x1a2d9
   175ef:	e8 06 b9 ff ff       	call   12efa <printf>
				printf("Flags         =0x%x", ioapic_ptr->Flags);
   175f4:	59                   	pop    %ecx
   175f5:	58                   	pop    %eax
   175f6:	0f b6 46 03          	movzbl 0x3(%esi),%eax
   175fa:	50                   	push   %eax
   175fb:	68 ec a2 01 00       	push   $0x1a2ec
   17600:	e8 f5 b8 ff ff       	call   12efa <printf>
				if (!(ioapic_ptr->Flags & 0x1))
   17605:	83 c4 10             	add    $0x10,%esp
   17608:	f6 46 03 01          	testb  $0x1,0x3(%esi)
   1760c:	75 10                	jne    1761e <LdrMain+0xdf3>
					print_str(", Unusable");
   1760e:	83 ec 0c             	sub    $0xc,%esp
   17611:	68 00 a3 01 00       	push   $0x1a300
   17616:	e8 98 b8 ff ff       	call   12eb3 <print_str>
   1761b:	83 c4 10             	add    $0x10,%esp
				printf("\nIOAPIC Address=0x%x\n", ioapic_ptr->IoapicAddress);
   1761e:	51                   	push   %ecx
   1761f:	51                   	push   %ecx
   17620:	ff 76 04             	push   0x4(%esi)
   17623:	68 0b a3 01 00       	push   $0x1a30b
   17628:	e9 c4 00 00 00       	jmp    176f1 <LdrMain+0xec6>
				printf("Interrupt Type  =%d\n", ioia_ptr->IntrType);
   1762d:	51                   	push   %ecx
   1762e:	51                   	push   %ecx
   1762f:	0f b6 46 01          	movzbl 0x1(%esi),%eax
   17633:	50                   	push   %eax
   17634:	68 21 a3 01 00       	push   $0x1a321
   17639:	e8 bc b8 ff ff       	call   12efa <printf>
				printf("Flags           =0x%x\n", ioia_ptr->Flags);
   1763e:	58                   	pop    %eax
   1763f:	5a                   	pop    %edx
   17640:	0f b7 46 02          	movzwl 0x2(%esi),%eax
   17644:	50                   	push   %eax
   17645:	68 36 a3 01 00       	push   $0x1a336
   1764a:	e8 ab b8 ff ff       	call   12efa <printf>
				printf("Source BUS Id   =%d\n", ioia_ptr->BusId);
   1764f:	59                   	pop    %ecx
   17650:	58                   	pop    %eax
   17651:	0f b6 46 04          	movzbl 0x4(%esi),%eax
   17655:	50                   	push   %eax
   17656:	68 4d a3 01 00       	push   $0x1a34d
   1765b:	e8 9a b8 ff ff       	call   12efa <printf>
				printf("Source BUS Irq  =%d\n", ioia_ptr->BusIrq);
   17660:	58                   	pop    %eax
   17661:	5a                   	pop    %edx
   17662:	0f b6 46 05          	movzbl 0x5(%esi),%eax
   17666:	50                   	push   %eax
   17667:	68 62 a3 01 00       	push   $0x1a362
   1766c:	e8 89 b8 ff ff       	call   12efa <printf>
				printf("Dst IOAPIC Id   =%d\n", ioia_ptr->IoapicId);
   17671:	59                   	pop    %ecx
   17672:	58                   	pop    %eax
   17673:	0f b6 46 06          	movzbl 0x6(%esi),%eax
   17677:	50                   	push   %eax
   17678:	68 77 a3 01 00       	push   $0x1a377
   1767d:	e8 78 b8 ff ff       	call   12efa <printf>
				printf("Dst IOAPIC INTIN=%d\n", ioia_ptr->IoapicIntIn);
   17682:	58                   	pop    %eax
   17683:	5a                   	pop    %edx
   17684:	0f b6 46 07          	movzbl 0x7(%esi),%eax
   17688:	50                   	push   %eax
   17689:	68 8c a3 01 00       	push   $0x1a38c
   1768e:	eb 61                	jmp    176f1 <LdrMain+0xec6>
				printf("Interrupt Type =%d\n", lia_ptr->IntrType);
   17690:	50                   	push   %eax
   17691:	50                   	push   %eax
   17692:	0f b6 46 01          	movzbl 0x1(%esi),%eax
   17696:	50                   	push   %eax
   17697:	68 a1 a3 01 00       	push   $0x1a3a1
   1769c:	e8 59 b8 ff ff       	call   12efa <printf>
				printf("Flags          =0x%x\n", lia_ptr->Flags);
   176a1:	58                   	pop    %eax
   176a2:	5a                   	pop    %edx
   176a3:	0f b7 46 02          	movzwl 0x2(%esi),%eax
   176a7:	50                   	push   %eax
   176a8:	68 b5 a3 01 00       	push   $0x1a3b5
   176ad:	e8 48 b8 ff ff       	call   12efa <printf>
				printf("Source BUS Id  =%d\n", lia_ptr->BusId);
   176b2:	59                   	pop    %ecx
   176b3:	58                   	pop    %eax
   176b4:	0f b6 46 04          	movzbl 0x4(%esi),%eax
   176b8:	50                   	push   %eax
   176b9:	68 cb a3 01 00       	push   $0x1a3cb
   176be:	e8 37 b8 ff ff       	call   12efa <printf>
				printf("Source BUS Irq =%d\n", lia_ptr->BusIrq);
   176c3:	58                   	pop    %eax
   176c4:	5a                   	pop    %edx
   176c5:	0f b6 46 05          	movzbl 0x5(%esi),%eax
   176c9:	50                   	push   %eax
   176ca:	68 df a3 01 00       	push   $0x1a3df
   176cf:	e8 26 b8 ff ff       	call   12efa <printf>
				printf("Dst LAPIC Id   =%d\n", lia_ptr->LapicId);
   176d4:	59                   	pop    %ecx
   176d5:	58                   	pop    %eax
   176d6:	0f b6 46 06          	movzbl 0x6(%esi),%eax
   176da:	50                   	push   %eax
   176db:	68 f3 a3 01 00       	push   $0x1a3f3
   176e0:	e8 15 b8 ff ff       	call   12efa <printf>
				printf("Dst LAPIC INTIN=%d\n", lia_ptr->LapicIntIn);
   176e5:	58                   	pop    %eax
   176e6:	5a                   	pop    %edx
   176e7:	0f b6 46 07          	movzbl 0x7(%esi),%eax
   176eb:	50                   	push   %eax
   176ec:	68 07 a4 01 00       	push   $0x1a407
   176f1:	e8 04 b8 ff ff       	call   12efa <printf>
			break;
   176f6:	83 c4 10             	add    $0x10,%esp
			s += EntrySize;
   176f9:	01 fe                	add    %edi,%esi
			getchar();
   176fb:	e8 7b b9 ff ff       	call   1307b <getchar>
   17700:	e9 ab fd ff ff       	jmp    174b0 <LdrMain+0xc85>
		if (mpct_header->ExtTableSize)
   17705:	0f b7 43 28          	movzwl 0x28(%ebx),%eax
   17709:	66 85 c0             	test   %ax,%ax
   1770c:	0f 84 46 01 00 00    	je     17858 <LdrMain+0x102d>
			for (u8 *s = (u8 *)mpct_header + mpct_header->Length, *e = s + mpct_header->ExtTableSize; s < e;)
   17712:	0f b7 73 04          	movzwl 0x4(%ebx),%esi
   17716:	01 de                	add    %ebx,%esi
   17718:	01 f0                	add    %esi,%eax
   1771a:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
   17720:	eb 66                	jmp    17788 <LdrMain+0xf5d>
				switch (entry->Type)
   17722:	3c 81                	cmp    $0x81,%al
   17724:	0f 84 ca 00 00 00    	je     177f4 <LdrMain+0xfc9>
   1772a:	3c 82                	cmp    $0x82,%al
   1772c:	0f 84 f5 00 00 00    	je     17827 <LdrMain+0xffc>
   17732:	3c 80                	cmp    $0x80,%al
   17734:	75 4b                	jne    17781 <LdrMain+0xf56>
					printf("BUS Id       =%d\n", sasm_ptr->BusId);
   17736:	50                   	push   %eax
   17737:	50                   	push   %eax
   17738:	0f b6 46 02          	movzbl 0x2(%esi),%eax
   1773c:	50                   	push   %eax
   1773d:	68 6d a4 01 00       	push   $0x1a46d
   17742:	e8 b3 b7 ff ff       	call   12efa <printf>
					printf("AddressType  =%d\n", sasm_ptr->AddressType);
   17747:	58                   	pop    %eax
   17748:	5a                   	pop    %edx
   17749:	0f b6 46 03          	movzbl 0x3(%esi),%eax
   1774d:	50                   	push   %eax
   1774e:	68 7f a4 01 00       	push   $0x1a47f
   17753:	e8 a2 b7 ff ff       	call   12efa <printf>
					printf("Address      =0x%x_%x\n", sasm_ptr->Address[1], sasm_ptr->Address[0]);
   17758:	83 c4 0c             	add    $0xc,%esp
   1775b:	ff 76 04             	push   0x4(%esi)
   1775e:	ff 76 08             	push   0x8(%esi)
   17761:	68 91 a4 01 00       	push   $0x1a491
   17766:	e8 8f b7 ff ff       	call   12efa <printf>
					printf("AddressLength=0x%x_%x\n", sasm_ptr->AddressLength[1], sasm_ptr->AddressLength[0]);
   1776b:	83 c4 0c             	add    $0xc,%esp
   1776e:	ff 76 0c             	push   0xc(%esi)
   17771:	ff 76 10             	push   0x10(%esi)
   17774:	68 a8 a4 01 00       	push   $0x1a4a8
					printf("PreRangeList=%d\n", cbasm_ptr->PreRangeList);
   17779:	e8 7c b7 ff ff       	call   12efa <printf>
				break;
   1777e:	83 c4 10             	add    $0x10,%esp
				s += EntrySize;
   17781:	01 fe                	add    %edi,%esi
				getchar();
   17783:	e8 f3 b8 ff ff       	call   1307b <getchar>
			for (u8 *s = (u8 *)mpct_header + mpct_header->Length, *e = s + mpct_header->ExtTableSize; s < e;)
   17788:	39 b5 30 ff ff ff    	cmp    %esi,-0xd0(%ebp)
   1778e:	0f 86 c4 00 00 00    	jbe    17858 <LdrMain+0x102d>
				if (entry->Type == MPCT_TYPE_EXT_SASM)
   17794:	0f b6 06             	movzbl (%esi),%eax
   17797:	3c 80                	cmp    $0x80,%al
   17799:	74 1d                	je     177b8 <LdrMain+0xf8d>
				else if (entry->Type == MPCT_TYPE_EXT_BHD || entry->Type == MPCT_TYPE_EXT_CBASM)
   1779b:	8d 50 7f             	lea    0x7f(%eax),%edx
   1779e:	80 fa 01             	cmp    $0x1,%dl
   177a1:	76 1c                	jbe    177bf <LdrMain+0xf94>
					printf("invalid entry Type=%d\n", entry->Type);
   177a3:	57                   	push   %edi
   177a4:	57                   	push   %edi
   177a5:	50                   	push   %eax
   177a6:	68 39 a2 01 00       	push   $0x1a239
					printf("incorrect MPCT_Ext_Header length=%d\n", mpct_header->ExtTableSize);
   177ab:	e8 4a b7 ff ff       	call   12efa <printf>
					break;
   177b0:	83 c4 10             	add    $0x10,%esp
   177b3:	e9 a0 00 00 00       	jmp    17858 <LdrMain+0x102d>
					EntrySize = sizeof(mpct_ext_sasm_s);
   177b8:	bf 14 00 00 00       	mov    $0x14,%edi
   177bd:	eb 05                	jmp    177c4 <LdrMain+0xf99>
					EntrySize = 8;
   177bf:	bf 08 00 00 00       	mov    $0x8,%edi
				if (entry->Length != EntrySize)
   177c4:	0f b6 56 01          	movzbl 0x1(%esi),%edx
   177c8:	39 fa                	cmp    %edi,%edx
   177ca:	74 0a                	je     177d6 <LdrMain+0xfab>
					printf("incorrect MPCT_Ext_Entry(Type=%d) length=%d\n", entry->Type, entry->Length);
   177cc:	56                   	push   %esi
   177cd:	52                   	push   %edx
   177ce:	50                   	push   %eax
   177cf:	68 1b a4 01 00       	push   $0x1a41b
   177d4:	eb d5                	jmp    177ab <LdrMain+0xf80>
				if ((u32)e - (u32)s < EntrySize)
   177d6:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
   177dc:	29 f2                	sub    %esi,%edx
   177de:	39 d7                	cmp    %edx,%edi
   177e0:	0f 86 3c ff ff ff    	jbe    17722 <LdrMain+0xef7>
					printf("incorrect MPCT_Ext_Header length=%d\n", mpct_header->ExtTableSize);
   177e6:	51                   	push   %ecx
   177e7:	51                   	push   %ecx
   177e8:	0f b7 43 28          	movzwl 0x28(%ebx),%eax
   177ec:	50                   	push   %eax
   177ed:	68 48 a4 01 00       	push   $0x1a448
   177f2:	eb b7                	jmp    177ab <LdrMain+0xf80>
					printf("BUS Id    =%d\n", bhd_ptr->BusId);
   177f4:	50                   	push   %eax
   177f5:	50                   	push   %eax
   177f6:	0f b6 46 02          	movzbl 0x2(%esi),%eax
   177fa:	50                   	push   %eax
   177fb:	68 bf a4 01 00       	push   $0x1a4bf
   17800:	e8 f5 b6 ff ff       	call   12efa <printf>
					printf("BUS Info  =%d\n", bhd_ptr->BusInfo);
   17805:	58                   	pop    %eax
   17806:	5a                   	pop    %edx
   17807:	0f b6 46 03          	movzbl 0x3(%esi),%eax
   1780b:	50                   	push   %eax
   1780c:	68 ce a4 01 00       	push   $0x1a4ce
   17811:	e8 e4 b6 ff ff       	call   12efa <printf>
					printf("Parent BUS=%d\n", bhd_ptr->ParentBus);
   17816:	59                   	pop    %ecx
   17817:	58                   	pop    %eax
   17818:	0f b6 46 04          	movzbl 0x4(%esi),%eax
   1781c:	50                   	push   %eax
   1781d:	68 dd a4 01 00       	push   $0x1a4dd
   17822:	e9 52 ff ff ff       	jmp    17779 <LdrMain+0xf4e>
					printf("BUS Id      =%d\n", cbasm_ptr->BusId);
   17827:	50                   	push   %eax
   17828:	50                   	push   %eax
   17829:	0f b6 46 02          	movzbl 0x2(%esi),%eax
   1782d:	50                   	push   %eax
   1782e:	68 ec a4 01 00       	push   $0x1a4ec
   17833:	e8 c2 b6 ff ff       	call   12efa <printf>
					printf("Modifier    =%d\n", cbasm_ptr->Modifier);
   17838:	58                   	pop    %eax
   17839:	5a                   	pop    %edx
   1783a:	0f b6 46 03          	movzbl 0x3(%esi),%eax
   1783e:	50                   	push   %eax
   1783f:	68 fd a4 01 00       	push   $0x1a4fd
   17844:	e8 b1 b6 ff ff       	call   12efa <printf>
					printf("PreRangeList=%d\n", cbasm_ptr->PreRangeList);
   17849:	59                   	pop    %ecx
   1784a:	58                   	pop    %eax
   1784b:	ff 76 04             	push   0x4(%esi)
   1784e:	68 0e a5 01 00       	push   $0x1a50e
   17853:	e9 21 ff ff ff       	jmp    17779 <LdrMain+0xf4e>
	unmap_mem(mpct_header);
   17858:	83 ec 0c             	sub    $0xc,%esp
   1785b:	53                   	push   %ebx
   1785c:	e8 41 de ff ff       	call   156a2 <unmap_mem>
}
   17861:	83 c4 10             	add    $0x10,%esp
			WalkMpct(mpfp_ptr);
		}
	}

	xsdp_t *xsdp_ptr = XsdpSearch(EbdaAddr, 1024);
   17864:	ba 00 04 00 00       	mov    $0x400,%edx
   17869:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   1786f:	e8 41 ee ff ff       	call   166b5 <XsdpSearch>
   17874:	89 c3                	mov    %eax,%ebx
	if (!xsdp_ptr)
   17876:	85 c0                	test   %eax,%eax
   17878:	75 2c                	jne    178a6 <LdrMain+0x107b>
		xsdp_ptr = XsdpSearch(0xE0000, 0x20000);
   1787a:	ba 00 00 02 00       	mov    $0x20000,%edx
   1787f:	b8 00 00 0e 00       	mov    $0xe0000,%eax
   17884:	e8 2c ee ff ff       	call   166b5 <XsdpSearch>
   17889:	89 c3                	mov    %eax,%ebx
	if (!xsdp_ptr)
   1788b:	85 c0                	test   %eax,%eax
   1788d:	75 17                	jne    178a6 <LdrMain+0x107b>
	{
		printf("RSDP(XSDP) not found!\n");
   1788f:	83 ec 0c             	sub    $0xc,%esp
   17892:	68 1f a5 01 00       	push   $0x1a51f
   17897:	e8 5e b6 ff ff       	call   12efa <printf>
		getchar();
   1789c:	e8 da b7 ff ff       	call   1307b <getchar>
   178a1:	e9 d2 05 00 00       	jmp    17e78 <LdrMain+0x164d>
	}
	else
	{
		char buf[7];
		memcpy(buf, xsdp_ptr->Rsdp.OemId, 6);
   178a6:	57                   	push   %edi
   178a7:	6a 06                	push   $0x6
   178a9:	8d 43 09             	lea    0x9(%ebx),%eax
   178ac:	50                   	push   %eax
   178ad:	8d b5 45 ff ff ff    	lea    -0xbb(%ebp),%esi
   178b3:	56                   	push   %esi
   178b4:	e8 8a eb ff ff       	call   16443 <memcpy>
		buf[6] = 0;
   178b9:	c6 85 4b ff ff ff 00 	movb   $0x0,-0xb5(%ebp)
		printf("RSDP    =0x%x\n", xsdp_ptr);
   178c0:	58                   	pop    %eax
   178c1:	5a                   	pop    %edx
   178c2:	53                   	push   %ebx
   178c3:	68 36 a5 01 00       	push   $0x1a536
   178c8:	e8 2d b6 ff ff       	call   12efa <printf>
		printf("OemId   =%s\n", buf);
   178cd:	59                   	pop    %ecx
   178ce:	5f                   	pop    %edi
   178cf:	56                   	push   %esi
   178d0:	68 45 a5 01 00       	push   $0x1a545
   178d5:	e8 20 b6 ff ff       	call   12efa <printf>
		printf("Revision=%d\n", xsdp_ptr->Rsdp.Revsion);
   178da:	58                   	pop    %eax
   178db:	5a                   	pop    %edx
   178dc:	0f b6 43 0f          	movzbl 0xf(%ebx),%eax
   178e0:	50                   	push   %eax
   178e1:	68 75 9b 01 00       	push   $0x19b75
   178e6:	e8 0f b6 ff ff       	call   12efa <printf>
		printf("RSDT    =0x%x\n", xsdp_ptr->Rsdp.RsdtAddress);
   178eb:	59                   	pop    %ecx
   178ec:	5e                   	pop    %esi
   178ed:	ff 73 10             	push   0x10(%ebx)
   178f0:	68 52 a5 01 00       	push   $0x1a552
   178f5:	e8 00 b6 ff ff       	call   12efa <printf>
		if (xsdp_ptr->Rsdp.Revsion == 2)
   178fa:	83 c4 10             	add    $0x10,%esp
   178fd:	80 7b 0f 02          	cmpb   $0x2,0xf(%ebx)
   17901:	75 25                	jne    17928 <LdrMain+0x10fd>
		{
			printf("Length  =%d\n", xsdp_ptr->Length);
   17903:	56                   	push   %esi
   17904:	56                   	push   %esi
   17905:	ff 73 14             	push   0x14(%ebx)
   17908:	68 1f a9 01 00       	push   $0x1a91f
   1790d:	e8 e8 b5 ff ff       	call   12efa <printf>
			printf("XSDT    =0x%x_%x\n", xsdp_ptr->XsdtAddress[1], xsdp_ptr->XsdtAddress[0]);
   17912:	83 c4 0c             	add    $0xc,%esp
   17915:	ff 73 18             	push   0x18(%ebx)
   17918:	ff 73 1c             	push   0x1c(%ebx)
   1791b:	68 61 a5 01 00       	push   $0x1a561
   17920:	e8 d5 b5 ff ff       	call   12efa <printf>
   17925:	83 c4 10             	add    $0x10,%esp
		}
		getchar();
   17928:	e8 4e b7 ff ff       	call   1307b <getchar>
	u32 SdtAddress = xsdp_ptr->Rsdp.RsdtAddress;
   1792d:	8b 73 10             	mov    0x10(%ebx),%esi
	bool use_xsdt = false;
   17930:	c6 85 24 ff ff ff 00 	movb   $0x0,-0xdc(%ebp)
	if (xsdp_ptr->Rsdp.Revsion == 2 && xsdp_ptr->XsdtAddress)
   17937:	80 7b 0f 02          	cmpb   $0x2,0xf(%ebx)
   1793b:	75 0a                	jne    17947 <LdrMain+0x111c>
		SdtAddress = xsdp_ptr->XsdtAddress[0];
   1793d:	8b 73 18             	mov    0x18(%ebx),%esi
		use_xsdt = true;
   17940:	c6 85 24 ff ff ff 01 	movb   $0x1,-0xdc(%ebp)
	header = map_mem(SdtAddress, sizeof(sdth_t));
   17947:	50                   	push   %eax
   17948:	50                   	push   %eax
   17949:	6a 24                	push   $0x24
   1794b:	56                   	push   %esi
   1794c:	e8 f1 da ff ff       	call   15442 <map_mem>
   17951:	89 c3                	mov    %eax,%ebx
	rsdt_ptr = (rsdt_t *)(xsdt_ptr = map_mem(SdtAddress, header->Length));
   17953:	58                   	pop    %eax
   17954:	5a                   	pop    %edx
   17955:	ff 73 04             	push   0x4(%ebx)
   17958:	56                   	push   %esi
   17959:	e8 e4 da ff ff       	call   15442 <map_mem>
   1795e:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
	unmap_mem(header);
   17964:	89 1c 24             	mov    %ebx,(%esp)
   17967:	e8 36 dd ff ff       	call   156a2 <unmap_mem>
		if (checksum_add(xsdt_ptr, xsdt_ptr->Header.Length))
   1796c:	59                   	pop    %ecx
   1796d:	5b                   	pop    %ebx
   1796e:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
   17974:	ff 70 04             	push   0x4(%eax)
   17977:	50                   	push   %eax
   17978:	e8 43 d5 ff ff       	call   14ec0 <checksum_add>
   1797d:	83 c4 10             	add    $0x10,%esp
   17980:	84 c0                	test   %al,%al
   17982:	74 15                	je     17999 <LdrMain+0x116e>
			printf("invalid SDT checksum!\n");
   17984:	83 ec 0c             	sub    $0xc,%esp
   17987:	68 73 a5 01 00       	push   $0x1a573
   1798c:	e8 69 b5 ff ff       	call   12efa <printf>
			break;
   17991:	83 c4 10             	add    $0x10,%esp
   17994:	e9 d1 04 00 00       	jmp    17e6a <LdrMain+0x163f>
		PrintSdth(&rsdt_ptr->Header);
   17999:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
   1799f:	e8 9d ed ff ff       	call   16741 <PrintSdth>
			XsdtEntryN = (xsdt_ptr->Header.Length - sizeof(sdth_t)) / 8;
   179a4:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
   179aa:	8b 40 04             	mov    0x4(%eax),%eax
		if (use_xsdt)
   179ad:	80 bd 24 ff ff ff 00 	cmpb   $0x0,-0xdc(%ebp)
			XsdtEntryN = (xsdt_ptr->Header.Length - sizeof(sdth_t)) / 8;
   179b4:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
		if (use_xsdt)
   179ba:	74 08                	je     179c4 <LdrMain+0x1199>
			XsdtEntryN = (xsdt_ptr->Header.Length - sizeof(sdth_t)) / 8;
   179bc:	83 e8 24             	sub    $0x24,%eax
   179bf:	c1 e8 03             	shr    $0x3,%eax
   179c2:	eb 06                	jmp    179ca <LdrMain+0x119f>
			XsdtEntryN = (rsdt_ptr->Header.Length - sizeof(sdth_t)) / 4;
   179c4:	83 e8 24             	sub    $0x24,%eax
   179c7:	c1 e8 02             	shr    $0x2,%eax
   179ca:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		for (u32 i = 0; i < XsdtEntryN; ++i)
   179d0:	8b bd 20 ff ff ff    	mov    -0xe0(%ebp),%edi
   179d6:	39 bd 28 ff ff ff    	cmp    %edi,-0xd8(%ebp)
   179dc:	0f 84 88 04 00 00    	je     17e6a <LdrMain+0x163f>
				EntryAddress = (u32)xsdt_ptr->Entry[i];
   179e2:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
			if (use_xsdt)
   179e8:	80 bd 24 ff ff ff 00 	cmpb   $0x0,-0xdc(%ebp)
   179ef:	74 0c                	je     179fd <LdrMain+0x11d2>
				EntryAddress = (u32)xsdt_ptr->Entry[i];
   179f1:	8b 8d 28 ff ff ff    	mov    -0xd8(%ebp),%ecx
   179f7:	8b 5c c8 24          	mov    0x24(%eax,%ecx,8),%ebx
   179fb:	eb 0a                	jmp    17a07 <LdrMain+0x11dc>
				EntryAddress = rsdt_ptr->Entry[i];
   179fd:	8b bd 28 ff ff ff    	mov    -0xd8(%ebp),%edi
   17a03:	8b 5c b8 24          	mov    0x24(%eax,%edi,4),%ebx
			header = map_mem(EntryAddress, sizeof(sdth_t));
   17a07:	57                   	push   %edi
   17a08:	57                   	push   %edi
   17a09:	6a 24                	push   $0x24
   17a0b:	53                   	push   %ebx
   17a0c:	e8 31 da ff ff       	call   15442 <map_mem>
   17a11:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
			void *full_map = map_mem(EntryAddress, header->Length);
   17a17:	5a                   	pop    %edx
   17a18:	59                   	pop    %ecx
   17a19:	ff 70 04             	push   0x4(%eax)
   17a1c:	53                   	push   %ebx
   17a1d:	e8 20 da ff ff       	call   15442 <map_mem>
   17a22:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
				if (checksum_add(full_map, header->Length))
   17a28:	5e                   	pop    %esi
   17a29:	5f                   	pop    %edi
   17a2a:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
   17a30:	ff 70 04             	push   0x4(%eax)
   17a33:	ff b5 34 ff ff ff    	push   -0xcc(%ebp)
   17a39:	e8 82 d4 ff ff       	call   14ec0 <checksum_add>
   17a3e:	83 c4 10             	add    $0x10,%esp
   17a41:	84 c0                	test   %al,%al
   17a43:	74 17                	je     17a5c <LdrMain+0x1231>
					printf("invalid checksum! (at Entry[%d]=0x%x)\n", i, EntryAddress);
   17a45:	56                   	push   %esi
   17a46:	53                   	push   %ebx
   17a47:	ff b5 28 ff ff ff    	push   -0xd8(%ebp)
   17a4d:	68 8a a5 01 00       	push   $0x1a58a
   17a52:	e8 a3 b4 ff ff       	call   12efa <printf>
					break;
   17a57:	e9 58 03 00 00       	jmp    17db4 <LdrMain+0x1589>
				PrintSdth(header);
   17a5c:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
   17a62:	e8 da ec ff ff       	call   16741 <PrintSdth>
				if (!memcmp(header->Signature, "APIC", 4))
   17a67:	51                   	push   %ecx
   17a68:	6a 04                	push   $0x4
   17a6a:	68 3d 9a 01 00       	push   $0x19a3d
   17a6f:	ff b5 2c ff ff ff    	push   -0xd4(%ebp)
   17a75:	e8 f1 e9 ff ff       	call   1646b <memcmp>
   17a7a:	83 c4 10             	add    $0x10,%esp
   17a7d:	85 c0                	test   %eax,%eax
   17a7f:	0f 85 02 02 00 00    	jne    17c87 <LdrMain+0x145c>
					printf("LapicAddress=0x%x\n", madt_ptr->LapicAddress);
   17a85:	50                   	push   %eax
   17a86:	50                   	push   %eax
   17a87:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17a8d:	ff 70 24             	push   0x24(%eax)
   17a90:	68 b1 a5 01 00       	push   $0x1a5b1
   17a95:	e8 60 b4 ff ff       	call   12efa <printf>
					printf("Flags       =0x%x", madt_ptr->Flags);
   17a9a:	58                   	pop    %eax
   17a9b:	5a                   	pop    %edx
   17a9c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17aa2:	ff 70 28             	push   0x28(%eax)
   17aa5:	68 c4 a5 01 00       	push   $0x1a5c4
   17aaa:	e8 4b b4 ff ff       	call   12efa <printf>
					if (madt_ptr->Flags & PCAT_COMPAT)
   17aaf:	83 c4 10             	add    $0x10,%esp
   17ab2:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17ab8:	f6 40 28 01          	testb  $0x1,0x28(%eax)
   17abc:	74 10                	je     17ace <LdrMain+0x12a3>
						printf(", PCAT_COMPAT");
   17abe:	83 ec 0c             	sub    $0xc,%esp
   17ac1:	68 d6 a5 01 00       	push   $0x1a5d6
   17ac6:	e8 2f b4 ff ff       	call   12efa <printf>
   17acb:	83 c4 10             	add    $0x10,%esp
					print_char('\n');
   17ace:	83 ec 0c             	sub    $0xc,%esp
   17ad1:	6a 0a                	push   $0xa
   17ad3:	e8 8a af ff ff       	call   12a62 <print_char>
					for (u8 *s = (u8 *)(madt_ptr + 1), *e = (u8 *)madt_ptr + madt_ptr->Header.Length; s < e;)
   17ad8:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17ade:	8d 58 2c             	lea    0x2c(%eax),%ebx
   17ae1:	03 40 04             	add    0x4(%eax),%eax
   17ae4:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
   17aea:	83 c4 10             	add    $0x10,%esp
   17aed:	39 9d 1c ff ff ff    	cmp    %ebx,-0xe4(%ebp)
   17af3:	0f 86 49 03 00 00    	jbe    17e42 <LdrMain+0x1617>
						const char *type_name[] = {
   17af9:	8d 7d a8             	lea    -0x58(%ebp),%edi
   17afc:	be c0 a9 01 00       	mov    $0x1a9c0,%esi
   17b01:	b9 10 00 00 00       	mov    $0x10,%ecx
   17b06:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
						if (adth_ptr->Type > MAT_GICITS)
   17b08:	0f b6 03             	movzbl (%ebx),%eax
   17b0b:	3c 0f                	cmp    $0xf,%al
   17b0d:	76 26                	jbe    17b35 <LdrMain+0x130a>
							printf("Type  =Reserved, 0x%x\n", adth_ptr->Type);
   17b0f:	51                   	push   %ecx
   17b10:	51                   	push   %ecx
   17b11:	50                   	push   %eax
   17b12:	68 e4 a5 01 00       	push   $0x1a5e4
   17b17:	e8 de b3 ff ff       	call   12efa <printf>
							printf("Length=%d\n", adth_ptr->Length);
   17b1c:	5e                   	pop    %esi
   17b1d:	5f                   	pop    %edi
   17b1e:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
   17b22:	50                   	push   %eax
   17b23:	68 fb a5 01 00       	push   $0x1a5fb
   17b28:	e8 cd b3 ff ff       	call   12efa <printf>
   17b2d:	83 c4 10             	add    $0x10,%esp
   17b30:	e9 47 01 00 00       	jmp    17c7c <LdrMain+0x1451>
							printf("Type  =%s, 0x%x\n", type_name[adth_ptr->Type], adth_ptr->Type);
   17b35:	57                   	push   %edi
   17b36:	50                   	push   %eax
   17b37:	ff 74 85 a8          	push   -0x58(%ebp,%eax,4)
   17b3b:	68 06 a6 01 00       	push   $0x1a606
   17b40:	e8 b5 b3 ff ff       	call   12efa <printf>
							printf("Length=%d\n", adth_ptr->Length);
   17b45:	58                   	pop    %eax
   17b46:	5a                   	pop    %edx
   17b47:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
   17b4b:	50                   	push   %eax
   17b4c:	68 fb a5 01 00       	push   $0x1a5fb
   17b51:	e8 a4 b3 ff ff       	call   12efa <printf>
							switch (adth_ptr->Type)
   17b56:	83 c4 10             	add    $0x10,%esp
   17b59:	80 3b 09             	cmpb   $0x9,(%ebx)
   17b5c:	0f 87 15 01 00 00    	ja     17c77 <LdrMain+0x144c>
   17b62:	0f b6 03             	movzbl (%ebx),%eax
   17b65:	ff 24 85 14 aa 01 00 	jmp    *0x1aa14(,%eax,4)
								printf("Processor UID=%d\n", tmp[0]);
   17b6c:	57                   	push   %edi
   17b6d:	57                   	push   %edi
   17b6e:	0f b6 43 02          	movzbl 0x2(%ebx),%eax
   17b72:	50                   	push   %eax
   17b73:	68 17 a6 01 00       	push   $0x1a617
   17b78:	e8 7d b3 ff ff       	call   12efa <printf>
								printf("LAPIC ID     =%d\n", tmp[1]);
   17b7d:	58                   	pop    %eax
   17b7e:	5a                   	pop    %edx
   17b7f:	0f b6 43 03          	movzbl 0x3(%ebx),%eax
   17b83:	50                   	push   %eax
   17b84:	68 29 a6 01 00       	push   $0x1a629
   17b89:	e8 6c b3 ff ff       	call   12efa <printf>
								printf("Flags        =0x%x\n", *(u32 *)(tmp + 2));
   17b8e:	59                   	pop    %ecx
   17b8f:	5e                   	pop    %esi
   17b90:	ff 73 04             	push   0x4(%ebx)
   17b93:	68 3b a6 01 00       	push   $0x1a63b
   17b98:	e9 d2 00 00 00       	jmp    17c6f <LdrMain+0x1444>
								printf("IOAPIC ID     =%d\n", tmp[0]);
   17b9d:	50                   	push   %eax
   17b9e:	50                   	push   %eax
   17b9f:	0f b6 43 02          	movzbl 0x2(%ebx),%eax
   17ba3:	50                   	push   %eax
   17ba4:	68 4f a6 01 00       	push   $0x1a64f
   17ba9:	e8 4c b3 ff ff       	call   12efa <printf>
								printf("IOAPIC Address=0x%x\n", *(u32 *)(tmp + 2));
   17bae:	58                   	pop    %eax
   17baf:	5a                   	pop    %edx
   17bb0:	ff 73 04             	push   0x4(%ebx)
   17bb3:	68 0c a3 01 00       	push   $0x1a30c
   17bb8:	e8 3d b3 ff ff       	call   12efa <printf>
								printf("GSI Base      =%d\n", *((u32 *)(tmp + 2) + 1));
   17bbd:	59                   	pop    %ecx
   17bbe:	5e                   	pop    %esi
   17bbf:	ff 73 08             	push   0x8(%ebx)
   17bc2:	68 62 a6 01 00       	push   $0x1a662
   17bc7:	e9 a3 00 00 00       	jmp    17c6f <LdrMain+0x1444>
								printf("Bus   =%d\n", tmp[0]);
   17bcc:	57                   	push   %edi
   17bcd:	57                   	push   %edi
   17bce:	0f b6 43 02          	movzbl 0x2(%ebx),%eax
   17bd2:	50                   	push   %eax
   17bd3:	68 63 a8 01 00       	push   $0x1a863
   17bd8:	e8 1d b3 ff ff       	call   12efa <printf>
								printf("Source=%d\n", tmp[1]);
   17bdd:	58                   	pop    %eax
   17bde:	5a                   	pop    %edx
   17bdf:	0f b6 43 03          	movzbl 0x3(%ebx),%eax
   17be3:	50                   	push   %eax
   17be4:	68 75 a6 01 00       	push   $0x1a675
   17be9:	e8 0c b3 ff ff       	call   12efa <printf>
								printf("GSI   =%d\n", *(u32 *)(tmp + 2));
   17bee:	59                   	pop    %ecx
   17bef:	5e                   	pop    %esi
   17bf0:	ff 73 04             	push   0x4(%ebx)
   17bf3:	68 80 a6 01 00       	push   $0x1a680
   17bf8:	e8 fd b2 ff ff       	call   12efa <printf>
								printf("Flags =0x%x\n", *(u16 *)((u32 *)(tmp + 2) + 1));
   17bfd:	5f                   	pop    %edi
   17bfe:	58                   	pop    %eax
   17bff:	0f b7 43 08          	movzwl 0x8(%ebx),%eax
   17c03:	50                   	push   %eax
   17c04:	68 8b a6 01 00       	push   $0x1a68b
   17c09:	eb 64                	jmp    17c6f <LdrMain+0x1444>
								printf("Processor UID=%d\n", tmp[0]);
   17c0b:	50                   	push   %eax
   17c0c:	50                   	push   %eax
   17c0d:	0f b6 43 02          	movzbl 0x2(%ebx),%eax
   17c11:	50                   	push   %eax
   17c12:	68 17 a6 01 00       	push   $0x1a617
   17c17:	e8 de b2 ff ff       	call   12efa <printf>
								printf("Flags        =0x%x\n", *(u16 *)(tmp + 1));
   17c1c:	58                   	pop    %eax
   17c1d:	5a                   	pop    %edx
   17c1e:	0f b7 43 03          	movzwl 0x3(%ebx),%eax
   17c22:	50                   	push   %eax
   17c23:	68 3b a6 01 00       	push   $0x1a63b
   17c28:	e8 cd b2 ff ff       	call   12efa <printf>
								printf("LAPIC LINTn  =%d\n", tmp[3]);
   17c2d:	59                   	pop    %ecx
   17c2e:	5e                   	pop    %esi
   17c2f:	0f b6 43 05          	movzbl 0x5(%ebx),%eax
   17c33:	50                   	push   %eax
   17c34:	68 98 a6 01 00       	push   $0x1a698
   17c39:	eb 34                	jmp    17c6f <LdrMain+0x1444>
								printf("LAPIC Address=0x%x\n", *(u32 *)(tmp + 2));
   17c3b:	57                   	push   %edi
   17c3c:	57                   	push   %edi
   17c3d:	ff 73 04             	push   0x4(%ebx)
   17c40:	68 c3 a1 01 00       	push   $0x1a1c3
   17c45:	eb 28                	jmp    17c6f <LdrMain+0x1444>
								printf("x2LAPIC ID   =%d\n", *(u32 *)(tmp + 2));
   17c47:	50                   	push   %eax
   17c48:	50                   	push   %eax
   17c49:	ff 73 04             	push   0x4(%ebx)
   17c4c:	68 aa a6 01 00       	push   $0x1a6aa
   17c51:	e8 a4 b2 ff ff       	call   12efa <printf>
								printf("Flags        =0x%x\n", *((u32 *)(tmp + 2) + 1));
   17c56:	58                   	pop    %eax
   17c57:	5a                   	pop    %edx
   17c58:	ff 73 08             	push   0x8(%ebx)
   17c5b:	68 3b a6 01 00       	push   $0x1a63b
   17c60:	e8 95 b2 ff ff       	call   12efa <printf>
								printf("Processor UID=%d\n", *((u32 *)(tmp + 2) + 2));
   17c65:	59                   	pop    %ecx
   17c66:	5e                   	pop    %esi
   17c67:	ff 73 0c             	push   0xc(%ebx)
   17c6a:	68 17 a6 01 00       	push   $0x1a617
   17c6f:	e8 86 b2 ff ff       	call   12efa <printf>
								break;
   17c74:	83 c4 10             	add    $0x10,%esp
							getchar();
   17c77:	e8 ff b3 ff ff       	call   1307b <getchar>
						s += adth_ptr->Length;
   17c7c:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
   17c80:	01 c3                	add    %eax,%ebx
   17c82:	e9 66 fe ff ff       	jmp    17aed <LdrMain+0x12c2>
				else if (!memcmp(header->Signature, "HPET", 4))
   17c87:	50                   	push   %eax
   17c88:	6a 04                	push   $0x4
   17c8a:	68 bc a6 01 00       	push   $0x1a6bc
   17c8f:	ff b5 2c ff ff ff    	push   -0xd4(%ebp)
   17c95:	e8 d1 e7 ff ff       	call   1646b <memcmp>
   17c9a:	83 c4 10             	add    $0x10,%esp
   17c9d:	85 c0                	test   %eax,%eax
   17c9f:	0f 85 17 01 00 00    	jne    17dbc <LdrMain+0x1591>
					printf("EventTimerBlockId.VendorId        =0x%x\n", hpet_ptr->EventTimerBlockId.VendorId);
   17ca5:	53                   	push   %ebx
   17ca6:	53                   	push   %ebx
   17ca7:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17cad:	0f b7 40 26          	movzwl 0x26(%eax),%eax
   17cb1:	50                   	push   %eax
   17cb2:	68 c1 a6 01 00       	push   $0x1a6c1
   17cb7:	e8 3e b2 ff ff       	call   12efa <printf>
					printf("EventTimerBlockId.Legacy          =%d\n", hpet_ptr->EventTimerBlockId.LegacyReplacementIrqRouting);
   17cbc:	5e                   	pop    %esi
   17cbd:	5f                   	pop    %edi
   17cbe:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17cc4:	8a 40 25             	mov    0x25(%eax),%al
   17cc7:	88 85 1c ff ff ff    	mov    %al,-0xe4(%ebp)
   17ccd:	c0 e8 07             	shr    $0x7,%al
   17cd0:	0f b6 c0             	movzbl %al,%eax
   17cd3:	50                   	push   %eax
   17cd4:	68 ea a6 01 00       	push   $0x1a6ea
   17cd9:	e8 1c b2 ff ff       	call   12efa <printf>
					printf("EventTimerBlockId.CounterSize     =%d\n", hpet_ptr->EventTimerBlockId.CounterSize);
   17cde:	58                   	pop    %eax
   17cdf:	5a                   	pop    %edx
   17ce0:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17ce6:	8a 40 25             	mov    0x25(%eax),%al
   17ce9:	88 85 1c ff ff ff    	mov    %al,-0xe4(%ebp)
   17cef:	c0 e8 05             	shr    $0x5,%al
   17cf2:	83 e0 01             	and    $0x1,%eax
   17cf5:	50                   	push   %eax
   17cf6:	68 11 a7 01 00       	push   $0x1a711
   17cfb:	e8 fa b1 ff ff       	call   12efa <printf>
					printf("EventTimerBlockId.NumOfComparators=%d\n", hpet_ptr->EventTimerBlockId.NumberOfComparators);
   17d00:	59                   	pop    %ecx
   17d01:	5b                   	pop    %ebx
   17d02:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17d08:	8a 40 25             	mov    0x25(%eax),%al
   17d0b:	83 e0 1f             	and    $0x1f,%eax
   17d0e:	50                   	push   %eax
   17d0f:	68 38 a7 01 00       	push   $0x1a738
   17d14:	e8 e1 b1 ff ff       	call   12efa <printf>
					printf("EventTimerBlockId.RevId           =%d\n", hpet_ptr->EventTimerBlockId.RevId);
   17d19:	5e                   	pop    %esi
   17d1a:	5f                   	pop    %edi
   17d1b:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17d21:	0f b6 40 24          	movzbl 0x24(%eax),%eax
   17d25:	50                   	push   %eax
   17d26:	68 5f a7 01 00       	push   $0x1a75f
   17d2b:	e8 ca b1 ff ff       	call   12efa <printf>
					printf("BaseAddress                       =0x%x_%x, %d, %d:%d\n",
   17d30:	58                   	pop    %eax
   17d31:	5a                   	pop    %edx
   17d32:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17d38:	0f b6 40 2a          	movzbl 0x2a(%eax),%eax
   17d3c:	50                   	push   %eax
   17d3d:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17d43:	0f b6 40 29          	movzbl 0x29(%eax),%eax
   17d47:	50                   	push   %eax
   17d48:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17d4e:	0f b6 40 28          	movzbl 0x28(%eax),%eax
   17d52:	50                   	push   %eax
   17d53:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17d59:	ff 70 2c             	push   0x2c(%eax)
   17d5c:	ff 70 30             	push   0x30(%eax)
   17d5f:	68 86 a7 01 00       	push   $0x1a786
   17d64:	e8 91 b1 ff ff       	call   12efa <printf>
					printf("HPET Number                       =%d\n", hpet_ptr->HpetNumber);
   17d69:	83 c4 18             	add    $0x18,%esp
   17d6c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17d72:	0f b6 40 34          	movzbl 0x34(%eax),%eax
   17d76:	50                   	push   %eax
   17d77:	68 bd a7 01 00       	push   $0x1a7bd
   17d7c:	e8 79 b1 ff ff       	call   12efa <printf>
					printf("Min Periodic tick                 =%d\n", hpet_ptr->MinClockTickPeriodic);
   17d81:	59                   	pop    %ecx
   17d82:	5b                   	pop    %ebx
   17d83:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17d89:	0f b7 40 36          	movzwl 0x36(%eax),%eax
   17d8d:	50                   	push   %eax
   17d8e:	68 e4 a7 01 00       	push   $0x1a7e4
   17d93:	e8 62 b1 ff ff       	call   12efa <printf>
					printf("Protection And Attribute          =0x%x\n", hpet_ptr->PageProtectionOemAttribute);
   17d98:	5e                   	pop    %esi
   17d99:	5f                   	pop    %edi
   17d9a:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
   17da0:	0f b6 40 38          	movzbl 0x38(%eax),%eax
   17da4:	50                   	push   %eax
   17da5:	68 0b a8 01 00       	push   $0x1a80b
   17daa:	e8 4b b1 ff ff       	call   12efa <printf>
					getchar();
   17daf:	e8 c7 b2 ff ff       	call   1307b <getchar>
   17db4:	83 c4 10             	add    $0x10,%esp
   17db7:	e9 86 00 00 00       	jmp    17e42 <LdrMain+0x1617>
				else if (!memcmp(header->Signature, "MCFG", 4))
   17dbc:	51                   	push   %ecx
   17dbd:	6a 04                	push   $0x4
   17dbf:	68 34 a8 01 00       	push   $0x1a834
   17dc4:	ff b5 2c ff ff ff    	push   -0xd4(%ebp)
   17dca:	e8 9c e6 ff ff       	call   1646b <memcmp>
   17dcf:	83 c4 10             	add    $0x10,%esp
   17dd2:	85 c0                	test   %eax,%eax
   17dd4:	75 6c                	jne    17e42 <LdrMain+0x1617>
					for (u32 i = 0; i < mcfg_entry_n; ++i)
   17dd6:	8b 9d 34 ff ff ff    	mov    -0xcc(%ebp),%ebx
					u32 mcfg_entry_n = (mcfg_ptr->Header.Length - sizeof(mcfg_t)) / sizeof(mcfg_entry_t);
   17ddc:	8b 43 04             	mov    0x4(%ebx),%eax
   17ddf:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
   17de5:	8d 70 d4             	lea    -0x2c(%eax),%esi
   17de8:	83 e6 f0             	and    $0xfffffff0,%esi
   17deb:	01 de                	add    %ebx,%esi
					for (u32 i = 0; i < mcfg_entry_n; ++i)
   17ded:	39 f3                	cmp    %esi,%ebx
   17def:	74 51                	je     17e42 <LdrMain+0x1617>
						printf("BaseAddress=0x%x_%x\n",
   17df1:	50                   	push   %eax
   17df2:	ff 73 2c             	push   0x2c(%ebx)
   17df5:	ff 73 30             	push   0x30(%ebx)
   17df8:	68 39 a8 01 00       	push   $0x1a839
   17dfd:	e8 f8 b0 ff ff       	call   12efa <printf>
						printf("PciSegGroup=%d\n", mcfg_ptr->Entry[i].PciSegGroupNumber);
   17e02:	58                   	pop    %eax
   17e03:	5a                   	pop    %edx
   17e04:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
   17e08:	50                   	push   %eax
   17e09:	68 4e a8 01 00       	push   $0x1a84e
   17e0e:	e8 e7 b0 ff ff       	call   12efa <printf>
						printf("StartBus   =%d\n", mcfg_ptr->Entry[i].StartBusNumber);
   17e13:	59                   	pop    %ecx
   17e14:	5f                   	pop    %edi
   17e15:	0f b6 43 36          	movzbl 0x36(%ebx),%eax
   17e19:	50                   	push   %eax
   17e1a:	68 5e a8 01 00       	push   $0x1a85e
   17e1f:	e8 d6 b0 ff ff       	call   12efa <printf>
						printf("EndBus     =%d\n", mcfg_ptr->Entry[i].EndBusNumber);
   17e24:	58                   	pop    %eax
   17e25:	5a                   	pop    %edx
   17e26:	0f b6 43 37          	movzbl 0x37(%ebx),%eax
   17e2a:	50                   	push   %eax
   17e2b:	68 6e a8 01 00       	push   $0x1a86e
   17e30:	e8 c5 b0 ff ff       	call   12efa <printf>
						getchar();
   17e35:	e8 41 b2 ff ff       	call   1307b <getchar>
					for (u32 i = 0; i < mcfg_entry_n; ++i)
   17e3a:	83 c3 10             	add    $0x10,%ebx
   17e3d:	83 c4 10             	add    $0x10,%esp
   17e40:	eb ab                	jmp    17ded <LdrMain+0x15c2>
			unmap_mem(header);
   17e42:	83 ec 0c             	sub    $0xc,%esp
   17e45:	ff b5 2c ff ff ff    	push   -0xd4(%ebp)
   17e4b:	e8 52 d8 ff ff       	call   156a2 <unmap_mem>
			unmap_mem(full_map);
   17e50:	5f                   	pop    %edi
   17e51:	ff b5 34 ff ff ff    	push   -0xcc(%ebp)
   17e57:	e8 46 d8 ff ff       	call   156a2 <unmap_mem>
		for (u32 i = 0; i < XsdtEntryN; ++i)
   17e5c:	ff 85 28 ff ff ff    	incl   -0xd8(%ebp)
   17e62:	83 c4 10             	add    $0x10,%esp
   17e65:	e9 66 fb ff ff       	jmp    179d0 <LdrMain+0x11a5>
	unmap_mem(xsdt_ptr);
   17e6a:	83 ec 0c             	sub    $0xc,%esp
   17e6d:	ff b5 30 ff ff ff    	push   -0xd0(%ebp)
   17e73:	e8 2a d8 ff ff       	call   156a2 <unmap_mem>
   17e78:	83 c4 10             	add    $0x10,%esp
	bool use_xsdt = false;
   17e7b:	bb 00 00 0f 00       	mov    $0xf0000,%ebx
		if (memcmp(p->Signature1, "_SM_", 4))
   17e80:	56                   	push   %esi
   17e81:	6a 04                	push   $0x4
   17e83:	68 7e a8 01 00       	push   $0x1a87e
   17e88:	53                   	push   %ebx
   17e89:	e8 dd e5 ff ff       	call   1646b <memcmp>
   17e8e:	83 c4 10             	add    $0x10,%esp
   17e91:	85 c0                	test   %eax,%eax
   17e93:	8d 73 10             	lea    0x10(%ebx),%esi
   17e96:	75 65                	jne    17efd <LdrMain+0x16d2>
		if (memcmp(p->Signature2, "_DMI_", 5))
   17e98:	51                   	push   %ecx
   17e99:	6a 05                	push   $0x5
   17e9b:	68 83 a8 01 00       	push   $0x1a883
   17ea0:	56                   	push   %esi
   17ea1:	e8 c5 e5 ff ff       	call   1646b <memcmp>
   17ea6:	83 c4 10             	add    $0x10,%esp
   17ea9:	85 c0                	test   %eax,%eax
   17eab:	75 50                	jne    17efd <LdrMain+0x16d2>
		if (p->MajorVersion < 2 || (p->MajorVersion == 2 && p->MinorVersion <= 1))
   17ead:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
   17eb1:	3c 01                	cmp    $0x1,%al
   17eb3:	76 0a                	jbe    17ebf <LdrMain+0x1694>
   17eb5:	3c 02                	cmp    $0x2,%al
   17eb7:	75 1c                	jne    17ed5 <LdrMain+0x16aa>
   17eb9:	80 7b 07 01          	cmpb   $0x1,0x7(%ebx)
   17ebd:	77 16                	ja     17ed5 <LdrMain+0x16aa>
			printf("Unsupported SMBIOS Version %d.%d!\n", p->MajorVersion, p->MinorVersion);
   17ebf:	52                   	push   %edx
   17ec0:	0f b6 53 07          	movzbl 0x7(%ebx),%edx
   17ec4:	52                   	push   %edx
   17ec5:	50                   	push   %eax
   17ec6:	68 89 a8 01 00       	push   $0x1a889
   17ecb:	e8 2a b0 ff ff       	call   12efa <printf>
			continue;
   17ed0:	83 c4 10             	add    $0x10,%esp
   17ed3:	eb 28                	jmp    17efd <LdrMain+0x16d2>
		if (p->Length != sizeof(smbios_eps_t))
   17ed5:	80 7b 05 1f          	cmpb   $0x1f,0x5(%ebx)
   17ed9:	75 22                	jne    17efd <LdrMain+0x16d2>
		if (checksum_add(p, sizeof(smbios_eps_t)))
   17edb:	50                   	push   %eax
   17edc:	50                   	push   %eax
   17edd:	6a 1f                	push   $0x1f
   17edf:	53                   	push   %ebx
   17ee0:	e8 db cf ff ff       	call   14ec0 <checksum_add>
   17ee5:	83 c4 10             	add    $0x10,%esp
   17ee8:	84 c0                	test   %al,%al
   17eea:	75 11                	jne    17efd <LdrMain+0x16d2>
		if (checksum_add(s + 0x10, 0xf))
   17eec:	50                   	push   %eax
   17eed:	50                   	push   %eax
   17eee:	6a 0f                	push   $0xf
   17ef0:	56                   	push   %esi
   17ef1:	e8 ca cf ff ff       	call   14ec0 <checksum_add>
   17ef6:	83 c4 10             	add    $0x10,%esp
   17ef9:	84 c0                	test   %al,%al
   17efb:	74 20                	je     17f1d <LdrMain+0x16f2>
	for (u8 *s = (u8 *)0xF0000, *e = (u8 *)(0xF0000 + 0x10000); s < e; s += 16, p = NULL)
   17efd:	89 f3                	mov    %esi,%ebx
		if ((u32)e - (u32)s < sizeof(smbios_eps_t))
   17eff:	81 fe f0 ff 0f 00    	cmp    $0xffff0,%esi
   17f05:	0f 85 75 ff ff ff    	jne    17e80 <LdrMain+0x1655>
	}

	smbios_eps_t *SmbiosEpsPtr = SmbiosSearch();
	if (!SmbiosEpsPtr)
	{
		printf("Suitable SMBIOS not found!\n");
   17f0b:	83 ec 0c             	sub    $0xc,%esp
   17f0e:	68 70 a9 01 00       	push   $0x1a970
   17f13:	e8 e2 af ff ff       	call   12efa <printf>
   17f18:	e9 1c 01 00 00       	jmp    18039 <LdrMain+0x180e>
	}
	else
	{
		printf("SMBIOS EPS       =0x%x\n", SmbiosEpsPtr);
   17f1d:	50                   	push   %eax
   17f1e:	50                   	push   %eax
   17f1f:	53                   	push   %ebx
   17f20:	68 b9 a8 01 00       	push   $0x1a8b9
   17f25:	e8 d0 af ff ff       	call   12efa <printf>
		printf("Version          =%d.%d\n", SmbiosEpsPtr->MajorVersion, SmbiosEpsPtr->MinorVersion);
   17f2a:	83 c4 0c             	add    $0xc,%esp
   17f2d:	0f b6 43 07          	movzbl 0x7(%ebx),%eax
   17f31:	50                   	push   %eax
   17f32:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
   17f36:	50                   	push   %eax
   17f37:	68 d1 a8 01 00       	push   $0x1a8d1
   17f3c:	e8 b9 af ff ff       	call   12efa <printf>
		printf("EPS Revision     =%d\n", SmbiosEpsPtr->EpsRevision);
   17f41:	5a                   	pop    %edx
   17f42:	59                   	pop    %ecx
   17f43:	0f b6 43 0a          	movzbl 0xa(%ebx),%eax
   17f47:	50                   	push   %eax
   17f48:	68 ea a8 01 00       	push   $0x1a8ea
   17f4d:	e8 a8 af ff ff       	call   12efa <printf>
		printf("MaxStructureSize =%d\n", SmbiosEpsPtr->MaxStructureSize);
   17f52:	5e                   	pop    %esi
   17f53:	5f                   	pop    %edi
   17f54:	0f b7 43 08          	movzwl 0x8(%ebx),%eax
   17f58:	50                   	push   %eax
   17f59:	68 00 a9 01 00       	push   $0x1a900
   17f5e:	e8 97 af ff ff       	call   12efa <printf>
		printf("StructureLength  =%d\n", SmbiosEpsPtr->StructureLength);
   17f63:	58                   	pop    %eax
   17f64:	5a                   	pop    %edx
   17f65:	0f b7 43 16          	movzwl 0x16(%ebx),%eax
   17f69:	50                   	push   %eax
   17f6a:	68 16 a9 01 00       	push   $0x1a916
   17f6f:	e8 86 af ff ff       	call   12efa <printf>
		printf("NumberOfStructure=%d\n", SmbiosEpsPtr->NumberOfStructure);
   17f74:	59                   	pop    %ecx
   17f75:	5e                   	pop    %esi
   17f76:	0f b7 43 1c          	movzwl 0x1c(%ebx),%eax
   17f7a:	50                   	push   %eax
   17f7b:	68 2c a9 01 00       	push   $0x1a92c
   17f80:	e8 75 af ff ff       	call   12efa <printf>
		printf("StructureAddress =0x%x\n", SmbiosEpsPtr->StructureAddress);
   17f85:	5f                   	pop    %edi
   17f86:	58                   	pop    %eax
   17f87:	ff 73 18             	push   0x18(%ebx)
   17f8a:	68 42 a9 01 00       	push   $0x1a942
   17f8f:	e8 66 af ff ff       	call   12efa <printf>
		printf("SmbiosBcdRevison =%x\n", SmbiosEpsPtr->SmbiosBcdRevison);
   17f94:	58                   	pop    %eax
   17f95:	5a                   	pop    %edx
   17f96:	0f b6 43 1e          	movzbl 0x1e(%ebx),%eax
   17f9a:	50                   	push   %eax
   17f9b:	68 5a a9 01 00       	push   $0x1a95a
   17fa0:	e8 55 af ff ff       	call   12efa <printf>
		getchar();
   17fa5:	e8 d1 b0 ff ff       	call   1307b <getchar>
	u8 *p = map_mem(SmbiosEpsPtr->StructureAddress, SmbiosEpsPtr->StructureLength), *s = p, *e = s + SmbiosEpsPtr->StructureLength;
   17faa:	59                   	pop    %ecx
   17fab:	5e                   	pop    %esi
   17fac:	0f b7 43 16          	movzwl 0x16(%ebx),%eax
   17fb0:	50                   	push   %eax
   17fb1:	ff 73 18             	push   0x18(%ebx)
   17fb4:	e8 89 d4 ff ff       	call   15442 <map_mem>
   17fb9:	89 c6                	mov    %eax,%esi
   17fbb:	0f b7 7b 16          	movzwl 0x16(%ebx),%edi
   17fbf:	01 c7                	add    %eax,%edi
	while (s < e)
   17fc1:	83 c4 10             	add    $0x10,%esp
	u8 *p = map_mem(SmbiosEpsPtr->StructureAddress, SmbiosEpsPtr->StructureLength), *s = p, *e = s + SmbiosEpsPtr->StructureLength;
   17fc4:	89 c3                	mov    %eax,%ebx
	while (s < e)
   17fc6:	39 df                	cmp    %ebx,%edi
   17fc8:	76 09                	jbe    17fd3 <LdrMain+0x17a8>
		if ((u32)e - (u32)s < sizeof(smbios_sth_t))
   17fca:	89 f8                	mov    %edi,%eax
   17fcc:	29 d8                	sub    %ebx,%eax
   17fce:	83 f8 03             	cmp    $0x3,%eax
   17fd1:	77 0b                	ja     17fde <LdrMain+0x17b3>
	unmap_mem(p);
   17fd3:	83 ec 0c             	sub    $0xc,%esp
   17fd6:	56                   	push   %esi
   17fd7:	e8 c6 d6 ff ff       	call   156a2 <unmap_mem>
   17fdc:	eb 5b                	jmp    18039 <LdrMain+0x180e>
		if ((u32)e - (u32)s < header->Length)
   17fde:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
   17fe2:	39 d0                	cmp    %edx,%eax
   17fe4:	72 ed                	jb     17fd3 <LdrMain+0x17a8>
		printf("Type  =%d\n", header->Type);
   17fe6:	50                   	push   %eax
   17fe7:	50                   	push   %eax
   17fe8:	0f b6 03             	movzbl (%ebx),%eax
   17feb:	50                   	push   %eax
   17fec:	68 2b a3 01 00       	push   $0x1a32b
   17ff1:	e8 04 af ff ff       	call   12efa <printf>
		printf("Length=%d\n", header->Length);
   17ff6:	58                   	pop    %eax
   17ff7:	5a                   	pop    %edx
   17ff8:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
   17ffc:	50                   	push   %eax
   17ffd:	68 fb a5 01 00       	push   $0x1a5fb
   18002:	e8 f3 ae ff ff       	call   12efa <printf>
		printf("Handle=0x%x\n", header->Handle);
   18007:	59                   	pop    %ecx
   18008:	58                   	pop    %eax
   18009:	0f b7 43 02          	movzwl 0x2(%ebx),%eax
   1800d:	50                   	push   %eax
   1800e:	68 ac a8 01 00       	push   $0x1a8ac
   18013:	e8 e2 ae ff ff       	call   12efa <printf>
		if(header->Type == 127)	// EndOfTable
   18018:	83 c4 10             	add    $0x10,%esp
   1801b:	80 3b 7f             	cmpb   $0x7f,(%ebx)
   1801e:	74 b3                	je     17fd3 <LdrMain+0x17a8>
		s += header->Length;
   18020:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
   18024:	01 c3                	add    %eax,%ebx
		while(*(u16*)s) ++s;
   18026:	66 83 3b 00          	cmpw   $0x0,(%ebx)
   1802a:	74 03                	je     1802f <LdrMain+0x1804>
   1802c:	43                   	inc    %ebx
   1802d:	eb f7                	jmp    18026 <LdrMain+0x17fb>
		s += 2;
   1802f:	83 c3 02             	add    $0x2,%ebx
		getchar();
   18032:	e8 44 b0 ff ff       	call   1307b <getchar>
   18037:	eb 8d                	jmp    17fc6 <LdrMain+0x179b>
   18039:	83 c4 10             	add    $0x10,%esp

		WalkSmbios(SmbiosEpsPtr);
	}

	for (;;)
		getchar();
   1803c:	e8 3a b0 ff ff       	call   1307b <getchar>
	for (;;)
   18041:	eb f9                	jmp    1803c <LdrMain+0x1811>
