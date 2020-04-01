# TOOLPATH=../z_tools/
MAKE = make -r
COPY     = cp
DEL      = rm -f
# GCC		= x86_64-elf-gcc
GCC = gcc
CFLAGS = -c -m32 -nostdlib -fno-stack-protector
# EDIMG = $(TOOLPATH)edimg

default:
	$(MAKE) run

ipl10.bin : ipl10.asm Makefile
	nasm ipl10.asm -o ipl10.bin -l ipl10.lst

asmhead.bin: asmhead.asm Makefile
	nasm asmhead.asm -o asmhead.bin -l asmhead.lst

nasmfunc.o : nasmfunc.asm
	nasm -f elf32 -o nasmfunc.o nasmfunc.asm

OBJS_BOOTPACK =bootpack.o nasmfunc.o dsctbl.o graphic.o font.o mystd.o int.o fifo.o mouse.o keyboard.o memory.o sheet.o timer.o mtask.o
bootpack.hrb : $(OBJS_BOOTPACK) hrb.ld Makefile
	# ld -m elf_i386 -e HariMain -o bootpack.hrb -T hrb.ld $(OBJS_BOOTPACK)
	ld -m elf_i386 -T hrb.ld $(OBJS_BOOTPACK) -o $@
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

%.o : %.c
	$(GCC) $(CFLAGS) $*.c -o $*.o

img : 
	$(MAKE) haribote.img

nasm:
	$(MAKE) ipl10.bin

sys :
	$(MAKE) haribote.sys

build:
	docker build -t nasmubu .
dimg:
	docker run -it --rm -v /Users/soju/workspace/osjisak/:/test nasmubu

run: 
	$(MAKE) dimg
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
