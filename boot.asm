;; A bootloader for x86 PCs



    bits 16

    mov ax, 0x7C0 ; Pick some high segment in free memory
    mov ds, ax ; Set stack segment (data)
    mov ax, 0x7E0 ; Since the bootloader extends from 0x7C00 for 512 byts to 0x7E00
    mov ss, ax ; Move stack segment (code)
    mov sp, 0x2000 ; We must set the initial stack pointer to a number of bytes past the stack segment equal to the desired size of the stack
    