#include "bootpack.h"

void HariMain(void)
{
    int mx, my;
    // char *p;
    char *vram;
    char *s[40];
    char *mcursor[256];

    struct BOOTINFO *binfo = (struct BOOTINFO *)ADR_BOOTINFO;
    init_gdtidt();
    init_pic();
    io_sti(); /* IDT/PICの初期化が終わったのでCPUの割り込み禁止を解除 */

    init_palette();
    init_screen(binfo->vram, binfo->scrnx, binfo->scrny);
    init_mouse_cursor8(mcursor, COL8_008484);
    putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);

    mx = (binfo->scrnx - 16) / 2;
    my = (binfo->scrny - 28 - 16) / 2;
    sprintf(s, "(%d,%d)", mx, my);
    putfonts8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, s);
    io_out8(PIC0_IMR, 0xf9); /* PIC1とキーボードを許可(11111001) */
    io_out8(PIC1_IMR, 0xef); /* マウスを許可(11101111) */
    {
        io_hlt();
    }
}
