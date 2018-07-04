DATAS SEGMENT
	inyear db 'input year:$'
	inmonth db 0dh,0ah,'input month:$'
	inday db 0dh,0ah,'input day:$'
	err db 0dh,0ah,'wrong date!',0dh,0ah,'$'
	
	leap db 0dh,0ah,'this is a leap year!$'
	notleap db 0dh,0ah,'this is not a leap year!$'
	
	Sun db 0dh,0ah,'It is sunday!$'
	Mon db 0dh,0ah,'It is Monday!$'
	Tues db 0dh,0ah,'It is Tuesday!$'
	Wednes db 0dh,0ah,'It is Wednesday!$'
	Thurs db 0dh,0ah,'It is Thursday!$'
	Fri db 0dh,0ah,'It is Friday!$'
	Satur db 0dh,0ah,'It is Saturday!$'
	
    buf db 8			;定义缓冲区长度
        db ? 			;预留实际输入字符个数的技术单元
        db 8 dup(?)		;设DS已是buffer的段基址
        
    year dw 0			;保存年份数值
    month dw 0			;保存月份数值
    day dw 0			;保存日期数值
    
    isl dw 0			;标志是否为闰年
    
    YC dw 0				;年份代码
    MC dw 0				;月份代码
DATAS ENDS

STACKS SEGMENT
    db 200 dup(0)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
;---------------------------------------------------------
Y:
    lea dx,inyear		;提示输入年份
    mov ah,9
    int 21h
    lea dx,buf
    mov ah,10
    int 21h
    call calyear		;将年份字符串转换成数字
    call isleap
;---------------------------------------------------------
M:
    lea dx,inmonth		;提示输入月份
    mov ah,9
    int 21h
    lea dx,buf
    mov ah,10
    int 21h
    call calmonth		;将月份转换成数字
;---------------------------------------------------------
D:
    lea dx,inday		;提示输入日
    mov ah,9
    int 21h
    lea dx,buf
    mov ah,10
    int 21h
    call calday			;将月份转换成数字
;---------------------------------------------------------
	cmp isl,1			;输出是否是闰年
	je forl
	lea dx,notleap
	jmp s
forl:
	lea dx,leap
s:
	mov ah,9
	int 21h
;---------------------------------------------------------
    call calweekday		;计算星期几并输出
    
    MOV AH,4CH
    INT 21H
;---------------------------------------------------------
isleap proc near;判断是否为闰年
	push bx
	push cx
	push dx
	
	mov ax,[year]		;将年份赋值到AX
	mov cx,ax
	mov dx,0
	mov bx,100			;除100，若余数为0，再判断除400，否则判断除100
	div bx
	cmp dx,0
	jnz l1
	mov ax,cx
	mov dx,0
	mov bx,400			;除400，若余数为0，则为闰年
	div bx
	cmp dx,0
	jz l2
	jmp last			;非闰年
l1:
	mov ax,cx
	mov dx,0
	mov bx,4			;除4，若余数为0，则为闰年
	div bx
	cmp dx,0
	jz l2
	jmp last			;非闰年
l2:
	mov isl,1			;闰年，设置标志位为1
last:
	
	pop bx
	pop cx
	pop dx
	ret
isleap endp
;---------------------------------------------------------
calweekday proc near
	cmp month,5			;闰年月份代码				
	je l0				;5 1 2 5 0 3 5 1 4 6 2 4			
	cmp month,8			;非闰年月份代码
	je l1				;6 2 2 5 0 3 5 1 4 6 2 4
	cmp month,2
	je l22
	cmp month,3
	je l2
	cmp month,11
	je l2
	cmp month,6
	je l3
	cmp month,9
	je l4
	cmp month,12
	je l4
	cmp month,4
	je l5
	cmp month,7
	je l5
	cmp month,1
	je l66
	cmp month,10
	je l6
l0:
	mov MC,0
	jmp foryear
l1:
	mov MC,1
	jmp foryear
l22:
	cmp isl,1
	jne l2
	mov MC,1
	jmp foryear
l2:
	mov MC,2
	jmp foryear
l3:
	mov MC,3
	jmp foryear
l4:
	mov MC,4
	jmp foryear
l5:
	mov MC,5
	jmp foryear
l66:
	cmp isl,1
	jne l6
	mov MC,5
	jmp foryear
l6:
	mov MC,6
;---------------------------------------------------------
foryear:				;年份代码=(年份尾数/4+年份尾数)%7
	mov ax,[year]
	mov dx,0
	mov bx,100
	div bx
	mov ax,dx			;得到年份尾数
	mov cx,ax			;暂存年份尾数
	mov bx,4
	mov dx,0			
	div bx				;得到年份尾数/4
	add ax,cx			;年份尾数/4+年份尾数
	mov bx,7
	mov dx,0
	div bx				;%7
	mov YC,dx
;---------------------------------------------------------
	mov ax,[YC]			;weekday=(Y+M+day)%7
	add ax,[MC]			;日 一 二 三 四 五 六
	add ax,[day]
	mov dx,0
	mov bx,7
	div bx
	cmp dx,0
	je c7
	cmp dx,1
	je c1
	cmp dx,2
	je c2
	cmp dx,3
	je c3
	cmp dx,4
	je c4
	cmp dx,5
	je c5
	cmp dx,6
	je c6
c7:
	lea dx,Sun
	jmp show
c1:
	lea dx,Mon
	jmp show
c2:
	lea dx,Tues
	jmp show
c3:
	lea dx,Wednes
	jmp show
c4:
	lea dx,Thurs
	jmp show
c5:
	lea dx,Fri
	jmp show
c6:
	lea dx,Satur
show:
	mov ah,9
	int 21h
	
	ret
calweekday endp
;---------------------------------------------------------  
calyear proc near							;将年份字符串转化成数字
	mov dx,0
	mov bx,10
	mov si,2
	mov year,0
	mov ax,0
	lop:
		mov al,buf[si]
		cmp al,0dh							;若为换行符则说明到了字符串尾部
		je final
		sub al,30h
		
		cmp al,0							;判断是否正确输入
		jb erro
		cmp al,9
		ja erro
		
		cmp year,0
		je deal
		push ax
		mov ax,year
		mul bx
		mov year,ax
		pop ax
		deal:
			add year,ax
			mov ax,0
			inc si
			jmp lop
		final:
    ret
erro:
	call error
	jmp Y
    ret
	
calyear endp
;---------------------------------------------------------
calmonth proc near
											;将月份字符串转化成数字
	mov dx,0
	mov bx,10
	mov si,2
	mov month,0
	mov ax,0
	lop:
		mov al,buf[si]
		cmp al,0dh
		je final
		sub al,30h
		
		cmp al,0							;判断是否正确输入
		jb erro	
		cmp al,9
		ja erro
		
		cmp month,0
		je deal
		push ax
		mov ax,month
		mul bx
		mov month,ax
		pop ax
		deal:
			add month,ax
			mov ax,0
			inc si
			jmp lop
		final:
			cmp month,12
			ja erro
    ret
erro:
	call error
	jmp M
    ret
	
calmonth endp
;---------------------------------------------------------
calday proc near
											;将日期字符串转化成数字
	mov dx,0
	mov bx,10
	mov si,2
	mov day,0
	mov ax,0
	lop:
		mov al,buf[si]
		cmp al,0dh
		je final
		sub al,30h
		
		cmp al,0							;判断是否正确输入
		jb erro
		cmp al,9
		ja erro
		
		cmp day,0
		je deal
		push ax
		mov ax,day
		mul bx
		mov day,ax
		pop ax
		deal:
			add day,ax
			mov ax,0
			inc si
			jmp lop
			
		final:								;判断天数是否符合常理
			cmp month,2						;2月闰年29天，非闰年28天
			je c2
			cmp month,4						;4,6,9,11月判断是否大于30
			je c4
			cmp month,6
			je c4
			cmp month,9
			je c4
			cmp month,11
			je c4
			jmp c5
			c4:
				cmp day,30
				ja erro
				jmp last
					
			c2:								;对于2月
				cmp isl,1
				je c3
				cmp day,28					;非闰年判断是否大于28
				ja erro
				jmp last
				c3:							;闰年判断是否大于29
					cmp day,29
					ja erro
					jmp last
			c5:								;判断是否大于31
				cmp day,31
				ja erro
last:
    ret
erro:
	call error
	jmp D
    ret
	
calday endp
;---------------------------------------------------------
error proc near
	lea dx,err
	mov ah,9
	int 21h
	
	ret
error endp
;---------------------------------------------------------
CODES ENDS
    END START


















