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
	
    buf db 8			;���建��������
        db ? 			;Ԥ��ʵ�������ַ������ļ�����Ԫ
        db 8 dup(?)		;��DS����buffer�Ķλ�ַ
        
    year dw 0			;���������ֵ
    month dw 0			;�����·���ֵ
    day dw 0			;����������ֵ
    
    isl dw 0			;��־�Ƿ�Ϊ����
    
    YC dw 0				;��ݴ���
    MC dw 0				;�·ݴ���
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
    lea dx,inyear		;��ʾ�������
    mov ah,9
    int 21h
    lea dx,buf
    mov ah,10
    int 21h
    call calyear		;������ַ���ת��������
    call isleap
;---------------------------------------------------------
M:
    lea dx,inmonth		;��ʾ�����·�
    mov ah,9
    int 21h
    lea dx,buf
    mov ah,10
    int 21h
    call calmonth		;���·�ת��������
;---------------------------------------------------------
D:
    lea dx,inday		;��ʾ������
    mov ah,9
    int 21h
    lea dx,buf
    mov ah,10
    int 21h
    call calday			;���·�ת��������
;---------------------------------------------------------
	cmp isl,1			;����Ƿ�������
	je forl
	lea dx,notleap
	jmp s
forl:
	lea dx,leap
s:
	mov ah,9
	int 21h
;---------------------------------------------------------
    call calweekday		;�������ڼ������
    
    MOV AH,4CH
    INT 21H
;---------------------------------------------------------
isleap proc near;�ж��Ƿ�Ϊ����
	push bx
	push cx
	push dx
	
	mov ax,[year]		;����ݸ�ֵ��AX
	mov cx,ax
	mov dx,0
	mov bx,100			;��100��������Ϊ0�����жϳ�400�������жϳ�100
	div bx
	cmp dx,0
	jnz l1
	mov ax,cx
	mov dx,0
	mov bx,400			;��400��������Ϊ0����Ϊ����
	div bx
	cmp dx,0
	jz l2
	jmp last			;������
l1:
	mov ax,cx
	mov dx,0
	mov bx,4			;��4��������Ϊ0����Ϊ����
	div bx
	cmp dx,0
	jz l2
	jmp last			;������
l2:
	mov isl,1			;���꣬���ñ�־λΪ1
last:
	
	pop bx
	pop cx
	pop dx
	ret
isleap endp
;---------------------------------------------------------
calweekday proc near
	cmp month,5			;�����·ݴ���				
	je l0				;5 1 2 5 0 3 5 1 4 6 2 4			
	cmp month,8			;�������·ݴ���
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
foryear:				;��ݴ���=(���β��/4+���β��)%7
	mov ax,[year]
	mov dx,0
	mov bx,100
	div bx
	mov ax,dx			;�õ����β��
	mov cx,ax			;�ݴ����β��
	mov bx,4
	mov dx,0			
	div bx				;�õ����β��/4
	add ax,cx			;���β��/4+���β��
	mov bx,7
	mov dx,0
	div bx				;%7
	mov YC,dx
;---------------------------------------------------------
	mov ax,[YC]			;weekday=(Y+M+day)%7
	add ax,[MC]			;�� һ �� �� �� �� ��
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
calyear proc near							;������ַ���ת��������
	mov dx,0
	mov bx,10
	mov si,2
	mov year,0
	mov ax,0
	lop:
		mov al,buf[si]
		cmp al,0dh							;��Ϊ���з���˵�������ַ���β��
		je final
		sub al,30h
		
		cmp al,0							;�ж��Ƿ���ȷ����
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
											;���·��ַ���ת��������
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
		
		cmp al,0							;�ж��Ƿ���ȷ����
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
											;�������ַ���ת��������
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
		
		cmp al,0							;�ж��Ƿ���ȷ����
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
			
		final:								;�ж������Ƿ���ϳ���
			cmp month,2						;2������29�죬������28��
			je c2
			cmp month,4						;4,6,9,11���ж��Ƿ����30
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
					
			c2:								;����2��
				cmp isl,1
				je c3
				cmp day,28					;�������ж��Ƿ����28
				ja erro
				jmp last
				c3:							;�����ж��Ƿ����29
					cmp day,29
					ja erro
					jmp last
			c5:								;�ж��Ƿ����31
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


















