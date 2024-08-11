#include <fcgiapp.h>

int main() {
    FCGX_Request Request;
    FCGX_Init();
    FCGX_InitRequest(&Request, 0, 0);

    while (FCGX_Accept_r(&Request) >= 0) {
        FCGX_FPrintF(Request.out, "Content-Type: text/html\n\n");
        FCGX_FPrintF(Request.out, "Hello World!\n");
        FCGX_Finish_r(&Request);
    }
}
