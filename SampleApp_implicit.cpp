// *********************      File : SampleApp_implcit.cpp (test DLL with implicit load)    ********************

// #include "stdafx.h"
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "sampleDLL.h"

int APIENTRY WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{ 	
   HelloWorld();
   return 0;
}
// *********************               End file : SampleApp_implicit.cpp                   ********************

