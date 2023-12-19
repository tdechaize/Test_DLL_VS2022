// **************************          Include file : SampleDLL.h             ****************
//
#ifndef INDLL_H
#define INDLL_H

/* if used by C++ code, identify these functions as C items */
#ifdef __cplusplus
extern "C" {
#endif

   #ifdef EXPORTING_DLL
      __declspec(dllexport) void HelloWorld(void) ;
   #else
      __declspec(dllimport) void HelloWorld(void) ;
   #endif
   
#ifdef __cplusplus
}
#endif 
 
#endif
// **************************           End file : SampleDLL.h               ****************
