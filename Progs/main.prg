* Program-ID..:  MAIN.PRG
* Purpose.....:  MAIN program for application

_Screen.Visible=.F.

DO ..\Progs\ϵͳ����.prg

DO FORM ..\Forms\login.scx

ON SHUTDOWN Quit  && ����ر�ϵͳʱ��XP��������Ӧ�ó������˳���Ϣ,��ʱ��on shutdown�ͻ�ִ��
READ EVENTS       && ��ʼ�¼�����ʹ��������ͣ����
