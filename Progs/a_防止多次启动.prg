*----------------------------------
*	��ֹ���򱻶�ο���
*----------------------------------
Public handle
Declare Integer CreateFileMapping In kernel32.Dll Integer hFile, ;
	INTEGER lpFileMappingAttributes,Integer flProtect, ;
	INTEGER dwMaximumSizeHigh, Integer dwMaximumSizeLow, ;
	STRING lpName
Declare Integer GetLastError In kernel32.Dll
Declare Integer CloseHandle In kernel32.Dll Integer hObject

szname="Xgerp-sos"   
handle = CreateFileMapping(0xFFFFFFFF,0,4,0,128,szname)

If handle = 0
	Wait Window "CreateFileMapping ʧ�� - LastError: " + Ltrim(Str(GetLastError()))
	Return
Endif

If handle=0
	Messagebox("�ڴ�ӳ���ļ�����ʧ�ܣ�",16,"����")
	Return .F.
Else
	If GetLastError()=183
		=Messagebox("�ó�������Ѿ����У�",16,"��ʾ")
		Close All
		Clear Dlls
		Clear Events
		Quit
	Endif
ENDIF