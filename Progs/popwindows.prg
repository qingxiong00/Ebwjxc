
*!* VFP�з�MSN�����½���Ϣ��ʾ����

*!* ���÷�����
*!* PopWindows(cFrmCap,cFrmIco,nLayer,nWaitTime,cLblCap,cMess)
*!* cFrmCap: C�ͣ����ڵı���
*!* cFrmIco: C�ͣ�����ͼ�꣬���������ʹ��SET PATH����������·�����˴�����д���·��
*!* nLayer:  N�ͣ�����͸���ȣ���Сֵ0����ȫ͸���������ֵ250����ȫ��͸����
*!* nWaitTime: N�ͣ��ȴ�ʱ�䡣�Ժ���Ϊ��λ��1��=1000����
*!* cLblCap: C�ͣ���ʾ��Ϣ�ı���
*!* cMess:  C�ͣ�Ҫ��ʾ����Ϣ

*!* ����ʾ����
*popWindows('Wwwwjxc��ʾ','..\bmp\net01.ico',250,8000,' ','�������')
popWindows('Wwwwjxc��ʾ','..\bmp\net01.ico',250,8000,c����,c��ʾ)

*!* ˵����
*!* 1����ֻ��һ��˼·�������ͨ����˼·�����Լ�����Ϣ���ڣ��������ͼƬ����
*!* 2����Ϊ���õĶ��������������͸���ȣ����Բ���Ӱ����Ļ�������
*!* 3������ϣ�������Զ���ʧ��������"�ȴ�ʱ��"Ϊ0��
*!* 4����Ȼ�������ڵ�EDITBOX��ý���ʱ��Ҳ�����Զ���ʧ�ģ�����������ʧ��
*!* 5������ΪEXEΪ200K��ռ���ڴ�300K���£�����DELPHI�����50K��ռ���ڴ�30K��Ϊ����˲�ࣿ��

FUNCTION popWindows

LPARAMETERS pcCaption,pcIco,pnLayer,pnWaitTim,pcMesCap,pcMes,plMaxButt,plMinButt

PUBLIC oFrmPopWindow
oFrmPopWindow=NEWOBJECT("FrmPopWindow")
lcStuBar=SET("Status Bar")  &&����xs160�ṩ��������Ľ���취
SET STATUS BAR ON
oFrmPopWindow.Show
SET STATUS BAR &lcStuBar.
RETURN
DEFINE CLASS FrmPopWindow AS form
  DataSession = 2 
AlwaysOnTop=.T.            &&������ΪEXE��APPʹ�ã������Բ������ã�TIMER�����趨��Ч������ã���WINDOWS���������濪ʼ������
AllowOutput = .F.
ShowInTaskbar=.F.          && ллxywf����
  Height = 132
  Width = 277 
  BackColor = RGB(255,255,255)
  BorderStyle = 2
  Caption = pcCaption
  Icon = pcIco
  MaxButton = plMaxButt
  MinButton = plMinButt
  ShowWindow = 2
  Visible = .F.
  Name = "FrmPopWindow"
  Layerdd= pnLayer
  MesCap = pcMesCap
  Mes = pcMes
  
  
  PROCEDURE Load
   this.Left = SYSMETRIC(21) - this.Width - SYSMETRIC(3) * 2
   this.Top = SYSMETRIC(22)
   this.AddProperty('FormHeight',this.Height)
   this.AddProperty('FormWidth',this.Width)
   this.AddProperty('FormActive',.T.)
  ENDPROC
  
  PROCEDURE Click
   this.formactive = .T.
  ENDPROC
  
  PROCEDURE Init
   THIS.MY_setwindow(this.layerdd)
   this.lblCaption.caption = this.MesCap
   this.Edit1.value = this.Mes
  ENDPROC
  PROCEDURE My_SetWindow
   LPARAMETERS pnLayer
   DECLARE INTEGER SetLayeredWindowAttributes IN win32api  INTEGER HWND, INTEGER crKey, INTEGER bAlpha, INTEGER dwFlags
   DECLARE INTEGER SetWindowLong IN user32.DLL INTEGER hWnd, INTEGER nIndex, INTEGER dwNewLong
   DECLARE INTEGER GetWindowLong IN user32.DLL  INTEGER hWnd, INTEGER nIndex
   #DEFINE LWA_COLORKEY    1
   #DEFINE LWA_ALPHA        2
   #DEFINE GWL_EXSTYLE        -20
   #DEFINE WS_EX_LAYERED    0x00080000
   lnFlags = GetWindowLong(thisform.hwnd, GWL_EXSTYLE)
   lnFlags = BITOR(lnFlags, WS_EX_LAYERED)            
   SetWindowLong(thisform.HWnd , GWL_EXSTYLE, lnFlags) 
   i=0
   DO WHILE i<=254
    j=i
    SetLayeredWindowAttributes(thisform.hwnd,RGB(255,255,255) , j, LWA_ALPHA)
    i = i +20
   ENDDO
   SetLayeredWindowAttributes(thisform.hwnd,thisform.BackColor ,pnLayer, LWA_ALPHA)
   *!* *-- ��������������
   *!* #DEFINE WS_EX_TOOLWINDOW    0x0000008
   *!* lnFlags = GetWindowLong(thisform.hwnd, WS_EX_TOOLWINDOW)    &&Gets the existing flags from the window
   *!* lnFlags = BITOR(lnFlags, WS_EX_TOOLWINDOW)            &&Appends the Layered flag to the existing ones
   *!* SetWindowLong(thisform.HWnd , GWL_EXSTYLE, lnFlags)
  ENDPROC
  PROCEDURE DblClick
   thisform.Release
  ENDPROC
  PROCEDURE Unload
   thisform.Release
  ENDPROC  
  
  ADD OBJECT lblCaption AS label WITH ;
   AutoSize = .T.,;
   BackStyle = 0,;
   Caption = '',;
   Height = 16,;
   Left = 6,;
   Top = 5,;
   Name = "lblCaption"
  
  ADD OBJECT Edit1 AS EditBox WITH ;
   Anchor = 15,;
   Height = 108,;
   Left = 0,;
   Name = 'Edit1',;
   Top = 24, ;
   Width = 277
  
  PROCEDURE Edit1.MouseDown
   LPARAMETERS nButton, nShift, nXCoord, nYCoord
   thisform.FormActive = .F.
  ENDPROC
  
  PROCEDURE Edit1.LostFocus
   thisform.FormActive = .T.
  ENDPROC
  ADD OBJECT tmrShow AS Timer WITH ;
   Name = 'tmrShow',;
   Interval = 10
   
  ADD OBJECT tmrWait AS Timer WITH ;
   Name = 'tmrWait',;
   Interval = pnWaitTim,;
   Enabled = .F.
  
  ADD OBJECT tmrHide AS Timer WITH ;
   Name = 'tmrHide',;
   Interval = 10,;
   Enabled = .F.
  

  PROCEDURE tmrShow.Timer
   IF SYSMETRIC(22)-thisform.Top = thisform.Height +SYSMETRIC(4) * 2
    this.Enabled = .F.
    thisform.tmrWait.Enabled = .T.
    thisform.AlwaysOnTop = .T.
   ELSE
    thisform.Top = thisform.Top - 1
   ENDIF
  ENDPROC
  
  PROCEDURE tmrWait.Timer
   IF thisform.tmrHide.Enabled = .F.
    thisform.tmrHide.Enabled = .T.
   ENDIF
  ENDPROC
  
  PROCEDURE tmrHide.Timer
   IF thisform.FormActive
    IF thisform.Height<>thisform.Formheight OR thisform.Width<>thisform.Formwidth
     thisform.Height = thisform.FormHeight
     thisform.Width = thisform.FormWidth
    ENDIF
    IF thisform.Top=SYSMETRIC(22)
     this.Enabled = .F.
     thisform.Release
    ELSE
     thisform.AlwaysOnTop = .F.
     thisform.Top = thisform.Top + 2
    ENDIF
   ENDIF
  ENDPROC
ENDDEFINE
*ENDFUNC
