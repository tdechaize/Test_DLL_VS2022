// **************************      File : SampleApp_explicit.cpp (example of load explicit of DLL)      ***********************

// #include "stdafx.h"
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <iostream>
#include <fstream>
#include <cstring>
#include "sampleDLL.h"

using namespace std;

typedef VOID (*DLLPROC)(void);

int APIENTRY WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{ 	

HINSTANCE hinstDLL;
DLLPROC _HelloWorld;
BOOL fFreeDLL;
std::ofstream out("log.txt");

#if defined(__x86_64__) || defined(_M_X64) || defined(__amd64__)
	hinstDLL = LoadLibrary("SampleDLL64.dll");
#else
    hinstDLL = LoadLibrary("SampleDLL.dll");
#endif

out << "Beginning of program SampleApp.exe." << endl;

if (hinstDLL != NULL || hinstDLL == INVALID_HANDLE_VALUE)
{
   _HelloWorld = (DLLPROC)GetProcAddress(hinstDLL, "HelloWorld");
   out << "After search of function HelloWorld in DLL." << endl;
   if (_HelloWorld != NULL) {
       out << "Before call of function HelloWorld." << endl;
      _HelloWorld();
   }
   else
   {
    MessageBox(NULL, "Unable to find function HelloWorld.", "Error", MB_OK | MB_ICONERROR);	  
   }
   out << "Before call of FreeLibrary." << endl;
   fFreeDLL = FreeLibrary(hinstDLL);
}
else 
{
#if defined(__x86_64__) || defined(_M_X64) || defined(__amd64__)
    MessageBox(NULL, "Unable to load SampleDLL64.dll.", "Error", MB_OK | MB_ICONERROR);
#else
	MessageBox(NULL, "Unable to load SampleDLL.dll.", "Error", MB_OK | MB_ICONERROR);
#endif
}
out.close();
}

// **************************                End file : SampleApp_explicit.cpp                ***********************

