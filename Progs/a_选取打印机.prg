*a_���ô�ӡ��
*---------------------------------------------------------------------------------------------------------
* ��δ�������VFPĬ����WINDOWS��ӡ��һ�£�VFPĬ�ϴ�ӡ������WINDOW Ĭ�ϴ�ӡ���ǲ�ͬ�ĸ������Ҫʹ����һ�£����ܴ�ӡ��
WshNetwork=Createobject("WScript.Network")
Public YD_Printer,SD_Printer
*-------------------------------------------------------------------------
YD_Printer=Set("Printer",2)  &&��ȡ��ǰϵͳ��Ĭ�ϴ�ӡ������
Wait Window "��ʾ:��ǰϵͳ��Ĭ�ϴ�ӡ��Ϊ��" +YD_Printer At 10,100 Nowait Noclear
*-------------------------------------------------------------------------
SD_Printer = Getprinter() && ѡ��WINDOWS�еĴ�ӡ��

If Empty(SD_Printer)
	Wait Window '��ʾ����û��δѡȡ��ӡ�������д�ӡ��' At 10,40 Nowait Noclear
	RETURN
ENDIF 

If ! Empty(SD_Printer)
	WshNetwork.SetDefaultPrinter(SD_Printer)
	YD_Printer=Set("Printer",2)  &&���»�ȡ��ǰϵͳ��Ĭ�ϴ�ӡ������
Set Printer To Default  && ���� VFP �� WINDOWS Ĭ�ϴ�ӡ��һ��
printk1 = SYS(1037) && ����ҳ��
IF printk1 ='0'
Wait Window '��ʾ����ȡ����ӡ��' At 10,40 Nowait Noclear
RETURN 
ENDIF
WAIT CLEAR
ENDIF 
*--------------------------------------------------------------------------------------
