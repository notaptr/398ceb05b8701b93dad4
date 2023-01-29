				bits 64

global 			alphabet_position
extern 			malloc

				section .data

buf:    		dq 0
cap_L:  		db "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
reg_L:  		db "abcdefghijklmnopqrstuvwxyz",0


; <----- char *alphabet_position(const char *text) ----->

				section .text

; IN
;  al - char to loc
; edi - alphabet
; OUT
;  al - sym poz, CF if error

check:
				cld
				push rcx
				push rax
				xor rcx,rcx
				mov cl,0x1a
@dd:
				scasb
				je @getit
				loopne @dd
				stc
				pop rax
				pop rcx
				ret
@getit:
				clc
				pop rax
				mov al,0x1b
				sub al,cl
				pop rcx
				ret
    
alphabet_position:

				push rcx
				push rsi
				push rdi

				cld
				xor rax,rax
				mov rcx,rax
				push rdi
@1:
				scasb
				jz @2
				inc rcx
				jmp @1
@2:
				rol rcx, 2
				mov rdi,rcx
				call malloc
				mov rsi,rax
				mov [buf],rax
				mov [eax],byte 0
				pop rdi

				xor rax,rax
@next:    
				mov al,[rdi]
				or al,al
				jz @end
				inc rdi

				push rdi
				mov rdi,cap_L
				call check
				pop rdi
				jnc @3

				push rdi
				mov rdi,reg_L
				call check
				pop rdi
				jc @next
@3:
			    mov rcx,0
@4:
				cmp al,10
				jb @5
				sub al,10
				inc rcx
				jmp @4
@5:
				or cl,cl
				je @6
				add cl,'0'
				mov [rsi],cl
				inc rsi
@6:
				add al,'0'
				mov [rsi],al
				inc rsi
				mov [rsi],byte ' '
				inc rsi
				jmp @next
    
@end:
				dec rsi
				mov [rsi], al
				mov rax,[buf]

				pop rdi
				pop rsi
				pop rcx
				ret


;-------------------- long long count_ones(int left, int right) ---------------------------


				section .data
				align 64 

bitcnt:     	times 256   db  0
commn:      	dq 0
total:      	dq 0
               
global 			count_ones

				section .text
				align 64

; input: edi = left, esi = right
; output: rax
count_ones:

				;Make lookup table
  
				push rcx
				push rbx
				push rdx
				  
				mov rcx, 256
				xor rax, rax
				mov [total], rax
				mov [commn], rax
				mov rbx, bitcnt
				push rbx
  
@store:  
				push rax
				rcr al, 1
				adc ah, 0

				rcr al, 1
				adc ah, 0

				rcr al, 1
				adc ah, 0

				rcr al, 1
				adc ah, 0

				rcr al, 1
				adc ah, 0

				rcr al, 1
				adc ah, 0

				rcr al, 1
				adc ah, 0

				rcr al, 1
				adc ah, 0

				mov [rbx], ah
				pop rax
				inc rax
				inc rbx
				loop @store

; Main procedure

				pop rbx         ;XLATB table

				mov rcx, rdi    ;left value
				mov rdx, rdi    ;left value
				xor rdi, rdi
				inc rsi

				xor rax,rax

;--- initial count

@upbytes:

				mov rcx, rdx
				push rcx

				xor rdi, rdi

				sar rcx, 8      ;byte 2
				mov al, cl        
				xlatb           ;count bits
				add rdi, rax    ;accumulating

				sar rcx, 8      ;byte 3  
				mov al, cl        
				xlatb               
				add rdi, rax    ;accumulating

				sar rcx, 8      ;byte 4
				mov al, cl        
				xlatb             
				add rdi, rax    ;accumulating

				pop rcx    		;restore

				or cl, cl
				jz @skip

@nxt0:

				mov rdx, [total]

@nxt:  

				;--- byte 1

				mov al, cl            ;get LSB byte

				xlatb                 ;count bits
				add rax, rdi          ;add local
				add rdx, rax

				inc rcx
				cmp rcx, rsi
				jge @fin               ;all counted

				or cl, cl
				jnz @nxt        ;count first byte

				mov [total], rdx
				mov rdx, rcx
				jmp @upbytes

@skip:

				mov rdx, rcx    ;save left value

				add rcx, 0x100
				cmp rcx, rsi
				mov rcx, rdx
				jnc @nxt0

				add rdx, 0x100
				mov rcx, rdi
				sal rdi, 8
				add rdi, 0x400
				add qword [total], rdi

				jmp @upbytes

@fin:
				mov rax, rdx
				pop rdx
				pop rbx
				pop rcx
				ret

;---------------------- cheat code for count ones ------------------


global			count_ones_cheat

				section .text

; input: edi = left, esi = right
; output: rax

count_ones_cheat:
			  push rbx

			  xor rax, rax
			  mov rbx, rax
			  inc esi
@mainloop:
			  popcnt ebx, edi
			  add rax,rbx
			  inc edi
			  cmp edi, esi
			  jne @mainloop

			  pop rbx
			  ret

