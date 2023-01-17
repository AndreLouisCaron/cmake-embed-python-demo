// -*- coding: utf-8 -*-


#include <Python.h>


int main(int argc, char * argv[])
{
    wchar_t * program = Py_DecodeLocale(argv[0], NULL);
    if (program == NULL) {
        fprintf(stderr, "Fatal error: cannot decode argv[0]\n");
        return EXIT_FAILURE;
    }
    Py_SetProgramName(program);
    Py_Initialize();
    PyRun_SimpleString("print(\"Hello, world!\")\n");
    if (Py_FinalizeEx() < 0) {
        return 120;
    }
    return EXIT_SUCCESS;
}
