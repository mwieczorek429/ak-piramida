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
cls:
	mov ax,0b800h   	; Adres poczatkowy obszaru pamieci obrazu
	mov es,ax       	; Ustawienie segmentu ES na 0b800h
	mov di,0        	; Zerujemy rejestr DI - offset segmentu ES
	mov ax,25			; Liczba wierszy w konsoli
	mov cx,80			; Liczba kolumn w konsoli
	mul cx				; Mnozenie wiersze * kolumny i zapisanie wartosci w AX 
	mov cx,ax   		; Ustawienie liczby iteracji na liczbe znakow mieszczacych sie w konsoli
	mov al,' '      	; Zapisanie znaku spacji w kodzie ASCII w mlodszej czesci rejestru AX
	mov ah,7     		; Zapisanie bajtu rejestru AX jak atrybut, kolor 
    rep stosw			; Przysylanie wartosci AX do miejsca ES:DI wykonana az CX = 0
	

;**************************Miejsce na kod do wyswietlania piramidki
	mov di,80			; Ustawienie pozycji pierwszego wystapienia znaku na ekranie konsoli
	mov al,'A'			; Ustawienie pierwszego znaku 
	mov ah,2			; Ustawienie atrybutu znaku		
	mov dx,160			; Rejestr zawiera wartosc o ile bedziemy przemieszczac sie w pamiec obrazu
	mov bh,1			; Rejestr przechowuje wartosc znakow, ktore zostana wypisane
	mov cx,0			; Ustawienie 16 bitow na zero
	mov cl,1			; Rejestr zawiera wartosc znakow, ktore zostana wypisane
	
petla:
	add bh,2			; Zwiekszamy liczbe znakow w nastepnym poziomie piramidy

	rep stosw			; Przysylanie wartosci AX do miejsca ES:DI wykonana az CX = 0
	
	inc al				; inkrementacja znaku ASCII
	inc ah				; inkrementacja atrybutu, koloru
	
	add di,dx			; Przejscie na kolejny poziom piramidy 
	sub di,4			; Poprawka, przesuniecie o 2 pozycje w lewo, 4 bajty 
	sub dx,4			; Zmniejszenie ilosc komorek w pameci graficznej w nastepnej iteracji
	mov cl,bh			; ustawienie liczika ile ma znakow napisac w nastepnej iteracji 
	cmp ah,21			; Sprawdzenie czy osiagnelismy wymagana wielkosc piramidy 
	jle petla			; jesli ah mniejsze lub rowne 21 powtorz 
	
;end petla	

;********************************************	

	; Wait for any key
	mov ah,0
	int 16h
	
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
