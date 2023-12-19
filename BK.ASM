_code segment
   assume  cs:_code
start:   mov   ax, _data
   mov   ds, ax
   assume   ds:_data
   mov   ax, _stack
   mov   ss, ax
   assume   ss:_stack
   mov   sp, top_stack
  
  
;**************************Miejsce na kod     
CLSCREEN:   				;clear screen
   mov ax,0b800h 			;Adres pamieci obrazu 
   mov es,ax 				;Zapisanie adresu w segmencie dodatkowym, aby stosowac operacje na blokach
   
   xor di,di 				;Wyzerowanie rejestru indeksowego docelowego
   mov al,' ' 				;Zapisane znaku spacji do wyswietlenia
   mov ah,00000000b 			;Bajt atrybutu wyswietlanego znaku. 7bit-mruganie(lub jasnosc w zaleznosci od ustawien) 6,5,4-kolor tla(RGB) 3,2,1,0-kolor znaku (jasnosc RGB)
   
   mov cx,1920d 			;Licznik informujacy ile razy ma sie wykonac nastepna instrukcja , 1920 = 80 * 24, aby wyczyscic 24 wierszy ekranu
   REP STOSW 				;Kopiuje AX do es:[di] CX razy, aby wyczyscic ekran
   					
   
SVALUES:
  mov di,80d 				;Ustawienie pozycji na srodek pierwszego wiersza
  mov al,'A' 				;Ustawienie jaki znak ma sie wyswietlic
  mov ah,00000001b 			;Ustawienie niebieskiego koloru
  mov cx,1d 				;Licznik ile razy instrukcja rep sie wykona
  mov dx,1d 				;Cx po wykonaniu rep sie resetuje wiec potrzebny pomocniczy licznik, aby wiedziec ile znakow na danym wierszu wyswietlic
  mov bx,1d 				;Iterator petli 
  cld 					;Aby di inkrementowalo sie
 
PIRAMID:
  mov cx,dx 				;Ustawienie ilosci znakow do wyswietlenia
  rep STOSW 				;Kopiuje AX do es:[di] CX razy, co powoduje wyswietlenie znaku zapisanego w al
  add di,158d 				;Przejscie do kolejnego wiersza.  
  sub di,dx 				;Cofniecie kursora o wypisana ilosc znakow
  sub di,dx				;Poprawka, aby poprawnie wyswietlac znaki
  add dx,2 				;Kolejny wiersz zawiera o 2 znaki wiecej aby powstala piramida
  inc al 				;Ustawienie kolejnego znaku do wyswietlenia
  inc ah 				;Zmiana koloru znaku
  xor ah,10000000b			;Negacja pierwszego bitu atrybutu, aby kazdy kolejny znak mrugal lub nie
  inc bx 				;Inkrementacja iteratora petli
  cmp bx,24d 				;Porownanie czy petla sie wykonala 24 razy
  jnz PIRAMID				;Jesli nie jestesmy na ostatnim wierszu powtorz petle
  
SCURSOR:				;Ustawienie pozycji kursora na 24 wiersz. Pozycja kolumny kursora jest zapisana pod adresem 0040h:0050h, a wiersz pod 0040h:0051h
  mov ax,40h 				;Rejestr pomocniczy do ustawienia segmentu dodatkowego
  mov es,ax 				;Ustawienie segmentu na adres 0040h
  mov BYTE PTR es:[51h],17h 		;Zapisanie pod adresem 40h:51h pozycji kursora na 24 wiersz 

;********************************************   
WAITKEY:
   mov ah,0				;Funkcja czeka na nacisniecie klawisza
   int 16h 				;Przerwanie obslugujace klawiature

   mov   ah, 4ch			;Funkcja konczy proces, zamyka otwarte pliki i zwalnia przydzielona pamiec 
   mov   al, 0				;Kod powrotu 
   int   21h				;DOSowskie przerwanie
  
   
  
_code ends

_data segment
   ; your data goes here
_data ends

_stack segment stack
   top_stack   equ 100h
_stack ends

end start

