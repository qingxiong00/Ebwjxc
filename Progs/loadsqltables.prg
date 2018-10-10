* LoadSQLTables.PRG
* Purpose....: Creates a duplicate of each DBF from your data directory in SQL Server
*              and copies the DBF's records to the SQL table.
*              The program puts brackets around named reserved words.
*              If you get an error indicating illegal use of a reserved word, add it here:
*!*	Ŀ��....: �������ݿ�Ŀ¼�е�dbf���Ƶ�SQL Server����
*!*	          Ȼ��DBF������Ҳ���Ƶ�SQL���С��ó���������������������Ϊ�����֡�
*!*	          �������һ�����󣬱����Ƿ�ʹ��һ�������Ĵʣ������������:

SET TALK OFF
CLEAR
CLOSE ALL
SET STRICTDATE TO 0
SET SAFETY OFF
SET EXCLUSIVE ON
SET CONFIRM ON

*!*	�������趨�ķǷ������֡�-------------------------------------------------------------------
ReservedWords = [,DESC,DATE,RESERVED,PRINT,ID,VIEW,BY,DEFAULT,CURRENT,KEY,ORDER,CHECK,FROM,TO,] 

*!*	����SQL���ݿ�-------------------------------------------------------------------------------
*!*ConnStr = [Driver={SQL Server};Server=(local);UID=sa;PWD=;Database=NorthWind;]
ConnStr = [Driver={SQL Server};Server=123.207.38.110;UID=sa;PWD=Eb123456;Database=Ebjxcdb;]
Handle = SQLSTRINGCONNECT( ConnStr )
IF Handle < 1
*!*	   MESSAGEBOX( "Unable to connect to SQL" + CHR(13) + ConnStr, 16 )
   MESSAGEBOX( "�޷����ӵ����ݿ�" + CHR(13) + ConnStr, 16 )
   RETURN
ENDIF

*!*	ѡ�񱾵�DBF�ļ���---------------------------------------------------------------------------
DataPath = GETDIR("Where are your DBFs?") && getdir(��������ѡ���ļ�
set step on
IF LASTKEY() = 27  && Escape was pressed
   RETURN
ENDIF
IF NOT EMPTY ( DataPath )
   SET PATH TO &DataPath
ENDIF

*!*	�����ļ��е�dbf����򿪣�������浽SQL-------------------------------------------------------
ADIR( laDBFS, ( DataPath + [*.dbf] ) )   && ADIR()���������ļ���Ϣ�����������
ASORT(laDBFS,1)                          && ASORT()�������ӵ�һ��Ԫ��(1,1)��ʼ�������������
FOR I = 1 TO ALEN(laDBFS,1)              && ALEN()�����������������
    USE ( laDBFS(I,1))
*!*	    _VFP.Caption = "Loading " + ALIAS()
    LoadOneTable()                       && ִ��LoadOneTable() ����̣������Ǳ���һ��dbf��SQL��
ENDFOR

*!*	�Ͽ����ݿ�-----------------------------------------------------------------------------------
SQLDISCONNECT(0)
*!*	_VFP.Caption = [Done]


*!*----------------------------------------------------------------------------------------------
*!*	LoadOneTable() ����̣��Զ���Ĺ��̣������ǽ�DBF���ݱ��浽SQL�
*!*	---------------------------------------------------------------------------------------------
PROCEDURE LoadOneTable             && PROCEDURE������̣�������ֵ��function �Ǻ������̣��з���ֵ��
LOCAL I
cRecCount = TRANSFORM(RECCOUNT())  && RECCOUNT()���������ص�ǰ��ļ�¼��Ŀ�� TRANSFORM�������������ص�����ֻ��ȡ���֡�
cmd  = [DROP TABLE ] + ALIAS()     && ���ñ�����cmd ���� ɾ����ǰdbf��   cmd = drop table +��ǰdbf����
SQLEXEC( Handle, Cmd )             && ����SQL���ɾ����ǰdbf������SQL��

* Skip tables we don't want to load && �������ǲ�����صı�
IF ALIAS() $ [COREMETA/DBCXREG/SDTMETA/SDTUSER/FOXUSER/]    && skip system tables  &&����ϵͳ�ļ�����dbf��
   ? [Skipping ] + ALIAS()
   RETURN
ENDIF

CreateTable()                     && ִ��CreateTable() ����̣������Ǵ���һ��SQL���ֶ��뵱ǰDBFһ��
SCAN
*!*	    WAIT WINDOW [Loading record ] + TRANSFORM(RECNO()) + [/] + cRecCount NOWAIT
    WAIT WINDOW [���ؼ�¼] + TRANSFORM(RECNO()) + [/] + cRecCount NOWAIT     && ��ʾ���ر����
    Cmd  = [INSERT INTO ] + ALIAS() + [ VALUES ( ]  && ���ñ�����cmd���� ��ӵ�ǰ���� ��cmd= INSERT INTO +��ǰdbf����+ values (��
    FOR I = 1 TO FCOUNT()
        fld  = FIELD(I)
        IF TYPE(Fld) = [G]
           LOOP
        ENDIF
        dta  = &Fld
        typ  = VARTYPE(dta)
        cdta = ALLTRIM(TRANSFORM(dta))
        cdta = CHRTRAN ( cdta, CHR(39),CHR(146) )
        DO CASE
           CASE Typ $ [CM]
                Cmd = Cmd + ['] + cDta + ['] + [, ]
           CASE Typ $ [IN]
                Cmd = Cmd +       cDta       + [, ]
           CASE Typ = [D]
                IF cDta = [/  /]
                   cDta = []
                ENDIF
                Cmd = Cmd + ['] + cDta + ['] + [, ]
           CASE Typ = [T]
                IF cDta = [/  /]
                   cDta = []
                ENDIF
                Cmd = Cmd + ['] + cDta + ['] + [, ]
           CASE Typ = [L]
                Cmd = Cmd + IIF('F'$cdta,[0],[1]) + [, ]
        ENDCASE
    ENDFOR
    Cmd = LEFT(Cmd,LEN(cmd)-2) + [ )]
    lr = SQLEXEC( Handle, Cmd )
    IF lr < 0
       ? [Error: ] + Cmd
       SUSPEND
    ENDIF
ENDSCAN
WAIT CLEAR




*!*----------------------------------------------------------------------------------------------
*!*	LoadOneTable() ����̵Ľ�β��
*!*	---------------------------------------------------------------------------------------------

*!*����������������������������������������������������������������������������������������������
*!*	CreateTable ����̣��Զ���Ĺ��̣���������SQL��SQL����ֶξ��ǵ�ǰDBF���ֶ�
*!*����������������������������������������������������������������������������������������������
PROCEDURE CreateTable             && PROCEDURE������̣�������ֵ��function �Ǻ������̣��з���ֵ��
LOCAL J
Cmd = [CREATE TABLE ] + ALIAS() + [ ( ]   && ���ñ�����cmd ���� ������ǰ����  cmd = CREATE TABLE +��ǰdbf���� +(
AFIELDS(laFlds)
FOR J = 1 TO ALEN(laFlds,1)
    IF laFlds(J,2) = [G]
       LOOP
    ENDIF
    FldName = laFlds(J,1)
    IF [,] + FldName + [,] $ ReservedWords
       FldName = "[" + FldName + "]"
    ENDIF
    Cmd = Cmd + FldName + [ ] 
    DO CASE
       CASE laFlds(J,2) = [C]
            Cmd = Cmd + [Char(] + TRANSFORM(laFlds(J,3)) + [)  NOT NULL DEFAULT '', ]
       CASE laFlds(J,2) = [I]
            Cmd = Cmd + [Integer  NOT NULL DEFAULT 0, ]
       CASE laFlds(J,2) = [M]
            Cmd = Cmd + [Text     NOT NULL DEFAULT '', ]
       CASE laFlds(J,2) = [N]
            N = TRANSFORM(laFlds(J,3))
            D = TRANSFORM(laFlds(J,4))
            Cmd = Cmd + [Numeric(] + N + [,] + D + [)  NOT NULL DEFAULT 0, ]
       CASE laFlds(J,2) $ [TD]
            Cmd = Cmd + [SmallDateTime  NOT NULL DEFAULT '', ]
       CASE laFlds(J,2) = [L]
            Cmd = Cmd + [Bit  NOT NULL DEFAULT 0, ]
    ENDCASE
ENDFOR
Cmd = LEFT(Cmd,LEN(cmd)-2) + [ )]
lr = SQLEXEC( Handle, Cmd )
IF lr < 0
   _ClipText = Cmd
   ? [Couldn't create table ] + ALIAS()
   MESSAGEBOX( Cmd )
   SUSPEND
ENDIF
? [Created ] + ALIAS()
ENDPROC
*!*����������������������������������������������������������������������������������������������
*!*	CreateTable ����̵Ľ�β��
*!*	��������������������������������������������������������������������������������������������