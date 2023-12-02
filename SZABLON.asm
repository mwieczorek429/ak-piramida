_code segment
	assume  cs:_code

start:	mov	ax, _data
	mov	ds, ax
	assume	ds:_data
	mov	ax, _stack
	mov	ss, ax
	assume	ss:_stack
	mov	sp, top_stack
        
	; your code goes here
	;clear screen
	mov ax,0600h
	mov bh,7
	mov cx,0
	mov dx,184fh
	int 10h
	
;**************************Miejsce na kod do wyswietlania piramidki
	mov bh,0
	mov al,'A' ;jaki znak
	mov cx,1 ;ile razy pojawi sie znak
	
	mov bl,2 ;atrybut wyswietlanego znaku
	
	mov dh,1;Wiersz
	mov dl,40;Kolumna
	
	mov di,20;zmienna petli
petla:	
	mov ah,02h;ustawienie pozycji kursora na DH wiersz i DL kolumne
	int 10h
	mov ah,09h;Zapisz znak z AL, CX razy
	int 10h
	
	inc dh;Kolejny wiersz
	dec dl;zmniejsz kolumne
	add cx,2;Nastepnym znak wykona sie cx+=2
	inc al;Aby piramida tworzyla A BB CCC...
	inc bl;kolejny kolor
		
	dec di
	jnz petla
;end petla	

;********************************************	
	mov	ah, 4ch
	mov	al, 0
	int	21h
_code ends

_data segment
	; your data goes here
_data ends

_stack segment stack
	top_stack	equ 100h
_stack ends

end start
