PARAMETERS nError,cMessage,cMessage1,cProgram,nLineno  &&���ղ���
SET TEXTMERGE DELIMITERS TO  &&ָ���ı��ϲ��ָ���Ϊ"<<"��">>"
SET TEXTMERGE ON  &&���ı��ϲ��ָ���������ֶΡ������������Ƚ��м���
SET TEXTMERGE TO ErrorLog.txt ADDITIVE NOSHOW  &&����Ϊ׷�ӵ��ļ�β
\---------------------------------------------------------------------
\<<DATE( )>> <<TIME( )>> �����¼
\�������: <<_Screen.Caption>>
\���򿪷��汾: <<VERSION(1)>>
DO CASE 
    CASE _Screen.WindowState = 0
        \����״̬: ��ͨ
    CASE _Screen.WindowState = 1
        \����״̬: ��С��
    CASE _Screen.WindowState = 2
        \����״̬: ���
ENDCASE 
\���ڿ���: <<IIF(_Screen.Visible= .T.  , "�ɼ�" , "���ɼ�")>>
\���ڼ�����: <<_Screen.FormCount>>
\���������Ϣ: <<SYS(0)>>
\
\ִ�г���: <<JUSTFNAME(SYS(16,1))>>
\ִ�г�������Ŀ¼: <<JUSTPATH(SYS(16,1))>>
\ִ�г�������Ŀ¼���̿ռ�: <<DISKSPACE(JUSTDRIVE(SYS(16,1)))>>
\
\Ĭ��Ŀ¼: <<SYS(5)>><<SYS(2003)>>
\Ĭ��Ŀ¼���̿ռ�: <<DISKSPACE(SYS(5))>>
\�ļ���Ѱ·��: <<SET("PATH")>>
\
\ϵͳ��ʱĿ¼: <<SYS(2023)>>
\�����ڴ�ش�С: <<SYS(1001)>>
\
\����ʹ�õĹ�����: <<Alias()>>
\��ֶ�: <<VARREAD()>>
\
IF TYPE("_Screen.ActiveForm.Name")="C"
    \���: <<_Screen.ActiveForm.Name>>
    \������: <<_Screen.ActiveForm.Caption>>
    \������: <<_Screen.ActiveForm.BaseClass>>
    \������: <<_Screen.ActiveForm.Class>>
    \��������: <<_Screen.ActiveForm.ClassLibrary>>
    \��λ��: <<SYS(1271, _Screen.ActiveForm)>>
ELSE 
    \�޻��   
ENDIF 
IF TYPE("_Screen.ActiveForm.ActiveControl")="O"
    \�����: <<_Screen.ActiveForm.ActiveControl.Name>>
    IF TYPE("_Screen.ActiveForm.ActiveControl.Caption") = "C"
        \���Ʊ���: <<_Screen.ActiveForm.ActiveControl.Caption>>
    ENDIF 
    \�ؼ�����: <<_Screen.ActiveForm.ActiveControl.BaseClass>>
    \�ؼ�����: <<_Screen.ActiveForm.ActiveControl.Class>>
    \�ؼ�������: <<_Screen.ActiveForm.ActiveControl.ClassLibrary>>
    \�ؼ�λ��: <<SYS(1271, _Screen.ActiveForm.ActiveControl)>>
ELSE 
    \�޻����   
ENDIF 
\
\�������: <<nError>>
\������Ϣ: <<cMessage>>
\���������λ��: <<cProgram>>
\�����к�: <<nLineno>>
\��������Ĵ���: <<cMessage1>>
\
\����ڴ�ʹ����� -> MemoryLog.txt
\������������� -> StatusLog.txt
SET SAFETY OFF 
DISPLAY MEMORY NOCONSOLE TO FILE MemoryLog.txt
DISPLAY STATUS NOCONSOLE TO FILE StatusLog.txt
\
\---------------------------------------------------------------------
SET TEXTMERGE TO 
nValue= MESSAGEBOX("������������ϸ��Ϣ���£�"+CHR(13)+CHR(13)+;
    "�������: " + LTRIM( STR(nError) ) + CHR(13) + ;
    "�����к�: " + LTRIM( STR(nLineno) ) + CHR(13) + ;
    "������Ϣ: " + cMessage + CHR(13) + ;
    "�������: " + cMessage1 + CHR(13) + ;
    "����λ��: " + cProgram + CHR(13) + CHR(13) + ;
    "�ô����Ѿ���¼���ļ�:Errorlog.txt,Memorylog.txt,Statuslog.txt��";
    ,2+48,"��Ϣ")
DO CASE 
    CASE nValue=3  &&ѡ����ֹʱ����
        QUIT 
    CASE nValue=4  &&ѡ������ʱ����
        RETRY 
    CASE nValue=5  &&ѡ�����ʱ����
        RETURN 
ENDCASE 
