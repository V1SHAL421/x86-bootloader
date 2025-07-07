;; A bootloader for x86 PCs



    bits 16

    mov ax, 0x7C0 ; Pick some high segment in free memory
    mov ds, ax ; Set stack segment (data)
    mov ax, 0x7E0 ; Since the bootloader extends from 0x7C00 for 512 byts to 0x7E00
    mov ss, ax ; Move stack segment (code)
    mov sp, 0x2000 ; We must set the initial stack pointer to a number of bytes past the stack segment equal to the desired size of the stack

;; Now we can use the standard calling convention in order to safely pass control over to different functions.
;; We can use push in order to push caller-saved registers onto the stack, pass parameters to the callee again with push,
;; and then use call to save the current program counter to the stack, and perform an unconditional
;; jump to the given label.

;;; register ah = function code
;;; register al = number of lines to scroll (0 = clear)
;;; register bh = colour attribute
;;; register cx = top-left corner (ch=row, cl=col)
;;; register dx = bottom-right corner (dh=row, dl=col)

    clearscreen: ; Goal is to clear the screen
        push bp ; Save the current base pointer (for the stack frame)
        mov bp, sp ; Set up a new stack frame (standard convention)
        pusha ; Push all general purpose registers to save their values

        mov ah, 0x07 ; tells BIOS to scroll down window (video interrupt function 0x07)
        mov al, 0x00 ; clear entire window
        mov bh, 0x07 ; white on black (Set the colour attribute for the cleared area to white)
        mov cx, 0x00 ; specifies top left of screen as (0,0) - cx is position of start of window
        mov dh, 0x18 ; 18h = 24 rows of chars (lower-right corner row = 0x18 = 24)
        mov dl, 0x4f ; 4fh = 79 cols of chars (bottom-right corner column of window to clear)
        int 0x10 ; calls video interrupt (int 0x10 controls the video output in real mode)