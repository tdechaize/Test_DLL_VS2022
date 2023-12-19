// **************************      File : SampleApp.cpp (example of load explicit of DLL)      ***********************

// #include "stdafx.h"
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "sampleDLL.h"

typedef VOID (CALLBACK* DLLPROC) (LPTSTR);

int APIENTRY WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{ 	

HINSTANCE hinstDLL;
DLLPROC HelloWorld;
BOOL fFreeDLL;

/* if used by C++ code, identify these functions as C items */

hinstDLL = LoadLibrary("SampleDLL.dll");
 
if (hinstDLL != NULL)
{
   HelloWorld = (DLLPROC)GetProcAddress(hinstDLL, "HelloWorld");
	
   if (HelloWorld != NULL) {
      (HelloWorld);
   }
   else
   {
    MessageBox(NULL, "Unable to find function HelloWorld.", "Error", MB_OK | MB_ICONERROR);	  
   }

   fFreeDLL = FreeLibrary(hinstDLL);
}
else 
{
    MessageBox(NULL, "Unable to load SampleDLL.dll.", "Error", MB_OK | MB_ICONERROR);
}

}

// **************************                End file : SampleApp.c                ***********************

