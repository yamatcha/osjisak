ipl.bin : ipl.nas Makefile
	nasm ipl.nas -o ipl.bin -l ipl.lst
testos.img : ipl.bin Makefile
	sh ./mkimg.sh ipl.bin testos.img
#	../z_tools/edimg   imgin:../z_tools/fdimg0at.tek   wbinimg src:ipl.bin len:512 from:0 to:0   imgout:testos.img
	sh ./mkimg.sh ipl.bin testos.img
img : 
	make -r testos.img
nasm:
	make -r ipl.bin
vdi : testos.img
#	rm ./testos.vdi -f
	VBoxManage convertfromraw --format VDI ./testos.img ./testos.vdi

