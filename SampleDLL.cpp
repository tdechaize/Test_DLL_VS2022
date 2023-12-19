// ***********************            File : SampleDLL.cpp             *****************

// #include "stdafx.h"
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#define EXPORTING_DLL
#include "sampleDLL.h"

/* if used by C++ code, identify these functions as C items */
#ifdef __cplusplus
extern "C" {
#endif

BOOL APIENTRY DllMain( HANDLE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved )
{
   return TRUE;
}

#ifdef __cplusplus
}
#endif

extern void HelloWorld(void)
{
   MessageBox( NULL, TEXT("Hello World"), 
   TEXT("In a DLL"), MB_OK);
}
// ***********************          End file : SampleDLL.cpp           *****************
