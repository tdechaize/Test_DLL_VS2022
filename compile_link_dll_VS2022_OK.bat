@echo off
REM
REM   	Script de génération de la DLL dll_core.dll et des programmee de test : "testdll_implicit.exe" (chargement implicite de la DLL),
REM 	"testdll_explicit.exe" (chargement explicite de la DLL), et enfin du script de test écrit en python.
REM		Ce fichier de commande est paramètrable avec deux paraamètres : 
REM			a) le premier paramètre permet de choisir la compilation et le linkage des programmes en une seule passe
REM 			soit la compilation et le linkage en deux passes successives : compilation séparée puis linkage,
REM 		b) le deuxième paramètre définit soit une compilation et un linkage en mode 32 bits, soit en mode 64 bits
REM 	 		pour les compilateurs qui le supportent.
REM     Le premier paramètre peut prendre les valeurs suivantes :
REM 		ONE (or unknown value, because only second value of this parameter is tested during execution) ou TWO.
REM     Et le deuxième paramètre peut prendre les valeurs suivantes :
REM 		32, 64 ou  ALL si vous souhaitez lancer les deux générations, 32 bits et 64 bits.
REM
REM 	Author : 						Thierry DECHAIZE
REM		Date creation/modification : 	01/12/2023
REM 	Reason of modifications : 	n° 1 - Blah Blah Blah ....
REM 	 							n° 2 - Blah Blah Blah ....	
REM 	Version number :				1.1.1	          	(version majeure . version mineure . patch level)

echo. Lancement du batch de generation d'une DLL et deux tests de celle-ci avec Visual C/C++ 32 bits ou 64 bits + Kit Windows
REM     Affichage du nom du système d'exploitation Windows :              			Microsoft Windows 11 Famille (par exemple)
REM 	Affichage de la version du système Windows :              					10.0.22621 (par exemple)
REM 	Affichage de l'architecture du processeur supportant le système Windows :   64-bit (par exemple)    
echo.  *********  Quelques caracteristiques du systeme hebergeant l'environnement de developpement.   ***********
WMIC OS GET Name
WMIC OS GET Version
WMIC OS GET OSArchitecture

REM 	Save of initial PATH on PATHINIT variable
set PATHINIT=%PATH%
echo.  **********      Pour cette generation le premier parametre vaut "%1" et le deuxieme "%2".     ************* 
IF "%2" == "32" ( 
   call :complink32 %1
) ELSE (
   IF "%2" == "64" (
      call :complink64 %1	  
   ) ELSE (
      call :complink32 %1
	  call :complink64 %1
	)  
)

goto FIN

:complink32
echo.  ******************                        Compilation de la DLL en mode 32 bits                        *******************
set "PAR1=%~1"
REM Mandatory, add to PATH the binary directory of compiler VisualC/C++ 32 bits + Kits Windows. You can adapt this directory at your personal software environment.
SET PATH=C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\bin\%KIT_WIN_NUM%\x86;C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\bin\Hostx86\x86;;C:\GetGnuWin32\bin;%PATH%
SET LIB="C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\lib\%KIT_WIN_NUM%\um\x86";"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\lib\x86";"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\lib\%KIT_WIN_NUM%\ucrt\x86";"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\lib\x86\store"
if "%PAR1%" == "TWO" (
REM Options used with Visual C/C++ compiler 32 bits :
REM 	/Wall								-> set all warning during compilation
REM		/c 									-> compile and assemble only, not call of linker
REM 	/Dxxxxxx							-> define variable xxxxxx used by preprocessor of compiler Visual C/C++
REM 	/Fodll_core.obj 					-> output of object file indicated just after this option 
echo.  ***************       Compilation de la DLL avec Visual C/C++ 32 bits + Kits Windows.             *****************
cl /nologo /Wall /c /DBUILD_DLL /D_WIN32 /DNDEBUG src\dll_core.c /Fodll_core.obj /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\shared" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\ucrt" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\um" /I"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
REM Options used with linker Visual C/C++ 32 bits :
REM		/LD									-> generate a shared library => on Window, generate a DLL (Dynamic Linked Library)
REM		/MT                     			-> Use static run-time  
echo.  ***************          Edition de liens de la DLL avec Visual C/C++ 32 bits + Kits Windows.     *******************
cl /nologo /LD /MT /Fedll_core.dll dll_core.obj 
echo.  ***************              Listage des fonctions exportees de la DLL                                   *******************
REM  	dump result with command "dumpbin" to see exported symbols of dll
dumpbin /exports  dll_core.dll
echo.  *************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *******************
cl /nologo /Wall /c /D_WIN32 /DNDEBUG /Fotestdll_implicit.obj src\testdll_implicit.c /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\shared" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\ucrt" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\um" /I"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
REM 	Options used by linker of cl /nologoANG/LLVM compiler
REM 		/Fexxxxx 						-> Define output file generated by Visual C/C++ compiler, here exe file
cl /nologo /Fetestdll_implicit.exe testdll_implicit.obj dll_core.lib
REM 	Run test program of DLL with implicit load
testdll_implicit.exe
echo.  ************      Generation et lancement du deuxieme programme de test de la DLL en mode explicite.      *****************
cl /nologo /c /Wall /DNDEBUG /D_WIN32 /Fotestdll_explicit.obj src\testdll_explicit.c /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\shared" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\ucrt" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\um" /I"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
cl /nologo /Fetestdll_explicit.exe testdll_explicit.obj
REM 	Run test program of DLL with explicit load
testdll_explicit.exe						
 ) ELSE (
REM     Options used by Visual C/C++ compiler 32 bits + Kit Windows
REM 		/Wall 						-> Set options to generate all warnings
REM 		/Dxxxxx	 					-> Define variable xxxxxx used by precompiler, here define to build dll with good prefix of functions exported (or imported)
REM 		/LD							-> Set option to generate shared library .ie. on windows systems DLL
REM			/MT                     	-> Use static run-time
REM 		/Fexxxxx 					-> Define output file generated by Visual C/C++ compiler, here dll file
cl /nologo /Wall /DBUILD_DLL /D_WIN32 /DNDEBUG /LD /MT src\dll_core.c /Fedll_core.dll  /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\shared" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\ucrt" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\um" /I"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
echo.  ************     			Dump des symboles exportes de la DLL dll_core.dll      				       *************
REM  	dump result with command "dumpbin" to see exported symbols of dll
dumpbin /exports  dll_core.dll
echo.  ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
cl /nologo /Wall /DNDEBUG /D_WIN32 /Fetestdll_implicit.exe src\testdll_implicit.c dll_core.lib /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\shared" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\ucrt" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\um" /I"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
REM 	Run test program of DLL with implicit load
testdll_implicit.exe
echo.  ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     *************
cl /nologo /Wall /DNDEBUG /D_WIN32 /Fetestdll_explicit.exe src\testdll_explicit.c /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\shared" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\ucrt" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\um" /I"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
REM 	Run test program of DLL with explicit load
testdll_explicit.exe
)
echo.  ****************               Lancement du script python 32 bits de test de la DLL.               ********************
%PYTHON32% version.py
REM 	Run test python script of DLL with explicit load
%PYTHON32% testdll_cdecl.py dll_core.dll
REM 	Return in initial PATH
set PATH=%PATHINIT%
set "LIB="
exit /B 

:complink64
echo.  ******************             Compilation de la DLL en mode 64 bits               *******************
set "PAR1=%~1"
REM      Mandatory, add to PATH the binary directory of compiler Visual C/C++ 64 bits + kits Windows. You can adapt this directory at your personal software environment.
SET PATH=C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\bin\%KIT_WIN_NUM%\x64;C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\bin\Hostx64\x64;;C:\GetGnuWin32\bin;%PATH%
SET LIB="C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\lib\%KIT_WIN_NUM%\um\x64";"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\lib\x64";"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\lib\%KIT_WIN_NUM%\ucrt\x64";"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\lib\x64\store"
if "%PAR1%" == "TWO" (
REM Options used with  Visual C/C++ compiler 64 bits 
REM 	/Wall								-> set all warning during compilation
REM		/c 									-> compile and assemble only, not call of linker
REM 	/Dxxxxxx							-> define variable xxxxxx used by preprocessor of compiler Visual C/C++
REM 	/Fodll_core.obj 					-> output of object file indicated just after this option 
echo.  ***************       Compilation de la DLL avec Visual C/C++ 64 bits + Kits Windows.             *****************
cl /nologo /Wall /c /DBUILD_DLL /D_WIN32 /DNDEBUG src\dll_core.c /Fodll_core64.obj /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\shared" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\ucrt" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\um" /I"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
REM Options used with linker cl /nologoANG/LLVM 64 bits (very similar with syntax of Visual C/C++ compiler) :
REM		/LD									-> generate a shared library => on Window, generate a DLL (Dynamic Linked Library)
REM		/MT                     			-> Use static run-time  
echo.  ***************          Edition de liens de la DLL avec Visual C/C++ 64 bits + Kits Windows.     *******************
cl /nologo /LD /MT /Fedll_core64.dll dll_core64.obj 
echo.  ***************              Listage des fonctions exportees de la DLL                                   *******************
REM  	dump result with command "dumpbin" to see exported symbols of dll
dumpbin /exports  dll_core64.dll
echo.  *************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *******************
cl /nologo /Wall /c /D_WIN32 /DNDEBUG /Fotestdll_implicit64.obj src\testdll_implicit.c /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\shared" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\ucrt" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\um" /I"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
REM 	Options used by linker of VisualC/C++ compiler
REM 		/Fexxxxx 						-> Define output file generated by Visual C/C++ compiler, here exe file
cl /nologo /Fetestdll_implicit64.exe testdll_implicit64.obj dll_core64.lib
REM 	Run test program of DLL with implicit load
testdll_implicit64.exe
echo.  ************      Generation et lancement du deuxieme programme de test de la DLL en mode explicite.      *****************
cl /nologo /c /Wall /DNDEBUG /D_WIN32 /Fotestdll_explicit64.obj src\testdll_explicit.c /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\shared" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\ucrt" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\um" /I"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
cl /nologo /Fetestdll_explicit64.exe testdll_explicit64.obj
REM 	Run test program of DLL with explicit load
testdll_explicit64.exe					
 ) ELSE (
REM     Options used by  Visual C/C++ compiler 64 bits + Kit Windows
REM 		/Wall 						-> Set options to generate all warnings
REM 		/Dxxxxx	 					-> Define variable xxxxxx used by precompiler, here define to build dll with good prefix of functions exported (or imported)
REM 		/LD							-> Set option to generate shared library .ie. on windows systems DLL
REM			/MT                     	-> Use static run-time
REM 		/Fexxxxx 					-> Define output file generated by  Visual C/C++ compiler, here dll file
cl /nologo /Wall /DBUILD_DLL /D_WIN32 /DNDEBUG /LD /MT src\dll_core.c /Fedll_core64.dll  /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\shared" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\ucrt" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\um" /I"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
echo.  ************     			Dump des symboles exportes de la DLL dll_core64.dll      				   *************
REM  	dump result with command "dumpbin" to see exported symbols of dll
dumpbin /exports  dll_core64.dll
echo.  ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
cl /nologo /Wall /DNDEBUG /D_WIN32 /Fetestdll_implicit64.exe src\testdll_implicit.c dll_core64.lib /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\shared" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\ucrt" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\um" /I"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
REM 	Run test program of DLL with implicit load
testdll_implicit64.exe
echo.  ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     *************
cl /nologo /Wall /DNDEBUG /D_WIN32 /Fetestdll_explicit64.exe src\testdll_explicit.c /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\shared" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\ucrt" /I"C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\include\%KIT_WIN_NUM%\um" /I"C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
REM 	Run test program of DLL with explicit load
testdll_explicit64.exe
)					
echo.  ****************               Lancement du script python 64 bits de test de la DLL.               *******************
%PYTHON64% version.py
REM 	Run test python script of DLL with explicit load
%PYTHON64% testdll_cdecl.py dll_core64.dll
REM 	Return in initial PATH
set PATH=%PATHINIT%
set "LIB="
exit /B 

:FIN
echo.        Fin de la generation de la DLL et des tests avec Visual C/C++ 32 bits ou 64 bits + Kits Windows.
