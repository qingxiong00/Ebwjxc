MODIFY WINDOW SCREEN FROM 0.00, 0.00 TO 48.00,168.50   &&�������� ��1024*768

LOCAL lcMainClassLib
LOCAL lcLastSetTalk,lcLastSetPath,lcLastSetClassLib,lcOnShutdown

*-- Save and configure environment.
lcLastSetTalk=SET("TALK")
SET TALK OFF
lcLastSetPath=SET("PATH")
**
PUSH MENU _msysmenu
lcLastSetClassLib=SET("CLASSLIB")
lcMainClassLib="libs\xgerp"
SET CLASSLIB TO (lcMainClassLib) ADDITIVE
lcOnShutdown="ShutDown()"
ON SHUTDOWN &lcOnShutdown
ON ERROR ErrorHandler(ERROR(),PROGRAM(),LINENO())
_shell="DO Cleanup IN progs\xgerp"

*-- Instantiate application object.
RELEASE goApp
PUBLIC goApp
goApp=CREATEOBJECT("cApplication")

*-- Configure application object.
*****
goApp.SetCaption(c��˾+"   ����Ա�� "+c����)
*****
goApp.cStartupMenu="menus\xgerp"
goApp.cStartupForm=""

*****************************************************************************
goApp.SetIcon("..\bmp\NET01.ICO")  &&��ʾͼ��

_SCREEN.MAXWIDTH= -1 &&-1  &&�����Ļ
_SCREEN.CLOSABLE = .T.  && ȡ�����ڹرձ���ť

* @ 0.00,0.00 SAY "..\BMP\main_bg.gif" BITMAP NOWAIT

* DO FORM ..\forms\������.scx
* @44,84 SAY c�汾�� ;
 	 FONT "Arial" ,14 ;
     STYLE "BIUT";
     COLOR RGB(192,192,192,,,,)

* DO ..\progs\pwinshow.prg

*****************************************************************************
*-- Show application.
goApp.Show
*-- Release application.
RELEASE goApp

*-- Restore default menu.
POP MENU _msysmenu

*-- Restore environment.
ON ERROR
ON SHUTDOWN
IF NOT lcLastSetClassLib==SET("classlib")
	RELEASE CLASSLIB (lcMainClassLib)
ENDIF
IF EMPTY(lcLastSetPath)
	SET PATH TO
ELSE
	SET PATH TO &lcLastSetPath
ENDIF
IF lcLastSetTalk=="ON"
	SET TALK ON
ELSE
	SET TALK OFF
ENDIF
RETURN

FUNCTION ErrorHandler(nError,cMethod,nLine)
LOCAL lcErrorMsg,lcCodeLineMsg

WAIT CLEAR
lcErrorMsg=MESSAGE()+CHR(13)+CHR(13)
lcErrorMsg=lcErrorMsg+"Method:    "+cMethod
lcCodeLineMsg=MESSAGE(1)
IF BETWEEN(nLine,1,10000) AND NOT lcCodeLineMsg="..."
	lcErrorMsg=lcErrorMsg+CHR(13)+"Line:         "+ALLTRIM(STR(nLine));
	           +CHR(13)+CHR(13)+c����֧��         && ����ʱ�����˾似��֧��
	IF NOT EMPTY(lcCodeLineMsg)
		lcErrorMsg=lcErrorMsg+CHR(13)+CHR(13)+lcCodeLineMsg
	ENDIF
ENDIF
IF MESSAGEBOX(lcErrorMsg,17,_screen.Caption)#1
	ON ERROR
	RETURN .F.
ENDIF
ENDFUNC

FUNCTION ShutDown

IF TYPE("goApp")=="O" AND NOT ISNULL(goApp)
	RETURN goApp.OnShutDown()
ENDIF
Cleanup()
QUIT
ENDFUNC

FUNCTION Cleanup

IF CNTBAR("_msysmenu")=7
	RETURN
ENDIF
ON ERROR
ON SHUTDOWN
SET CLASSLIB TO
SET PATH TO
CLEAR ALL
CLOSE ALL
POP MENU _msysmenu
RETURN