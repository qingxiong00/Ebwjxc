*--------------------------------------------------------------------------------------
* log_mmk.PRG
*--------------------------------------------------------------------------------------
DO �������ݿ�.prg

*-��ѯ��˾����
ln1=SQLExec(lnHandle,'select * from sys_gssetup ')
  If ln1<=0   && ��ѯ���ݲ��ɹ����Ͽ�������������
    SQLDISCONNECT(0) && �Ͽ�������������
    RELEASE lnHandle && ɾ�����Ӿ������
    MESSAGEBOX ("��ѯ���ݿ�ʧ�ܣ�","��ʾ")
    QUIT && ��Ϊ������������Ҫ�˳�ϵͳ -----
    RETURN 
  ENDIF

cԭ�ĵ� = ALLTRIM(ԭ�ĵ�)
c��˾���� = ALLTRIM(��˾����)
c��������  = ALLTRIM(��������)
c��˾��ַ = ALLTRIM(��˾��ַ)
c������ַ = ALLTRIM(������ַ)
c��˾�绰 = ALLTRIM(��˾�绰)
c��˾���� = ALLTRIM(��˾����)
c�ļ�˾�ֻ� = ALLTRIM(�ļ�˾�ֻ�)
c���ʵ���ַ = ALLTRIM(���ʵ���ַ)
USE

SQLDISCONNECT(0) && �Ͽ�������������
RELEASE lnHandle && ɾ�����Ӿ������
Close Databases All
Close Tables All