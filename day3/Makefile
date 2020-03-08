# TOOLPATH=../z_tools/
MAKE = make -r
COPY     = cp
DEL      = rm -f
# GCC		= x86_64-elf-gcc

# EDIMG = $(TOOLPATH)edimg

default:
	$(MAKE) img

ipl10.bin : ipl10.asm Makefile
	nasm ipl10.asm -o ipl10.bin -l ipl10.lst

asmhead.bin: asmhead.asm Makefile
	nasm asmhead.asm -o asmhead.bin -l asmhead.lst

nasmfunc.o:nasmfunc.asm
	nasm -f elf32 -o nasmfunc.o nasmfunc.asm

bootpack.o : bootpack.c
	gcc -c -m32 -fno-pic -fno-stack-protector -o bootpack.o bootpack.c

font.o : font.c
	gcc -c -m32 -o font.o font.c

mysprintf.o :mysprintf.c
	gcc -c -m32 -fno-stack-protector -o mysprintf.o mysprintf.c

bootpack.hrb : nasmfunc.o bootpack.o font.o mysprintf.o Makefile
	ld -m elf_i386 -e HariMain -o bootpack.hrb -T hrb.ld bootpack.o font.o nasmfunc.o mysprintf.o
	# gcc -m32 -fno-stack-protector -march=i486 -nostdlib -nostdinc -T hrb.ld bootpack.c font.o nasmfunc.o mysprintf.o -o bootpack.hrb

haribote.sys: asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img : ipl10.bin haribote.sys Makefile
	mformat -f 1440 -C -B ipl10.bin -i haribote.img ::
	mcopy -i haribote.img haribote.sys ::
	# echo haribote.sys > haribote.name
	# dd if=ipl10.bin     of=haribote.img count=2880 bs=512 conv=notrunc
	# dd if=haribote.name of=haribote.img count=1 bs=512 seek=19 conv=notrunc
	# dd if=haribote.sys  of=haribote.img count=1 bs=512 seek=33 conv=notrunc
		# $(EDIMG)  imgin:../../z_tools/fdimg0at.tek \
	# 	wbinimg src:ipl10.bin len:512 from:0 to:0 \
	# 	copy from:haribote.sys to:@: \
	# 	imgout:haribote.img
	# sh ./mkimg.sh ipl10.bin haribote.img

img : 
	$(MAKE) haribote.img

nasm:
	$(MAKE) ipl10.bin

sys :
	$(MAKE) haribote.sys

run: haribote.img
	qemu-system-i386 -fda haribote.img

# when you use virtualbox
vdi : haribote.img
	-$(DEL) ./haribote.vdi
	VBoxManage convertfromraw --format VDI ./haribote.img ./haribote.vdi

clean :
	rm -f *.bin
	rm -f *.o
	rm -f *.sys
	rm -f *.img

src_only :
	$(MAKE) clean
	-$(DEL) haribote.img
