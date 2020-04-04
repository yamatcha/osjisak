void api_putstr0(char *s);
void api_end(void);

void HariMain(void)
{
    api_putstr0("helloworld\n");
    api_end();
}