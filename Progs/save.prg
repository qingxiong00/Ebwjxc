* LoadSQLTables.PRG
* Purpose....: Creates a duplicate of each DBF from your data directory in SQL Server
*              and copies the DBF's records to the SQL table.
*              The program puts brackets around named reserved words.
*              If you get an error indicating illegal use of a reserved word, add it here:
*!*	目的....: 将您数据库目录中的dbf复制到SQL Server表中
*!*	          然后将DBF的数据也复制到SQL表中。该程序将括号括起来，以命名为保留字。
*!*	          如果你有一个错误，表明非法使用一个保留的词，请在这里添加:

SET TALK OFF
CLEAR
CLOSE ALL
SET STRICTDATE TO 0
SET SAFETY OFF
SET EXCLUSIVE ON
SET CONFIRM ON

*!*	这是您设定的非法保留字。-------------------------------------------------------------------
ReservedWords = [,DESC,DATE,RESERVED,PRINT,ID,VIEW,BY,DEFAULT,CURRENT,KEY,ORDER,CHECK,FROM,TO,] 

*!*	连接SQL数据库-------------------------------------------------------------------------------
*!*ConnStr = [Driver={SQL Server};Server=(local);UID=sa;PWD=;Database=NorthWind;]
ConnStr = [Driver={SQL Server};Server=192.168.1.8;UID=sa;PWD=3b7d29akfq93lgs8;Database=EbERPdb;]
Handle = SQLSTRINGCONNECT( ConnStr )
IF Handle < 1
*!*	   MESSAGEBOX( "Unable to connect to SQL" + CHR(13) + ConnStr, 16 )
   MESSAGEBOX( "无法连接到数据库" + CHR(13) + ConnStr, 16 )
   RETURN
ENDIF

*!*	选择本地DBF文件夹---------------------------------------------------------------------------
DataPath = GETDIR("Where are your DBFs?") && getdir(）函数，选择文件
?datapath




RETURN


set step on
IF LASTKEY() = 27  && Escape was pressed
   RETURN
ENDIF
IF NOT EMPTY ( DataPath )
   SET PATH TO &DataPath
ENDIF

*!*	本地文件夹的dbf逐个打开，逐个保存到SQL-------------------------------------------------------
ADIR( laDBFS, ( DataPath + [*.dbf] ) )   && ADIR()函数：将文件信息存放在数组中
ASORT(laDBFS,1)                          && ASORT()函数：从第一个元素(1,1)开始对数组进行排序
FOR I = 1 TO ALEN(laDBFS,1)              && ALEN()函数：返回数组个数
    USE ( laDBFS(I,1))
*!*	    _VFP.Caption = "Loading " + ALIAS()
    LoadOneTable()                       && 执行LoadOneTable() 类过程，方法是保存一个dbf表到SQL里
ENDFOR

*!*	断开数据库-----------------------------------------------------------------------------------
SQLDISCONNECT(0)
*!*	_VFP.Caption = [Done]


*!*----------------------------------------------------------------------------------------------
*!*	LoadOneTable() 类过程，自定义的过程，方法是将DBF数据保存到SQL里。
*!*	---------------------------------------------------------------------------------------------
PROCEDURE LoadOneTable             && PROCEDURE是类过程，不返回值。function 是函数过程，有返回值。
LOCAL I
cRecCount = TRANSFORM(RECCOUNT())  && RECCOUNT()函数，返回当前表的记录数目。 TRANSFORM（）函数，返回的内容只获取数字。
cmd  = [DROP TABLE ] + ALIAS()     && 设置变量，cmd 等于 删除当前dbf表   cmd = drop table +当前dbf表名
SQLEXEC( Handle, Cmd )             && 发送SQL命令，删除当前dbf表名的SQL表

* Skip tables we don't want to load && 跳过我们不想加载的表
IF ALIAS() $ [COREMETA/DBCXREG/SDTMETA/SDTUSER/FOXUSER/]    && skip system tables  &&跳过系统文件名的dbf表
   ? [Skipping ] + ALIAS()
   RETURN
ENDIF

CreateTable()                     && 执行CreateTable() 类过程，方法是创建一个SQL表，字段与当前DBF一样
SCAN
*!*	    WAIT WINDOW [Loading record ] + TRANSFORM(RECNO()) + [/] + cRecCount NOWAIT
    WAIT WINDOW [加载记录] + TRANSFORM(RECNO()) + [/] + cRecCount NOWAIT     && 提示加载表进度
    Cmd  = [INSERT INTO ] + ALIAS() + [ VALUES ( ]  && 设置变量，cmd等于 添加当前数据 “cmd= INSERT INTO +当前dbf表名+ values (”
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
*!*	LoadOneTable() 类过程的结尾。
*!*	---------------------------------------------------------------------------------------------

*!*···············································
*!*	CreateTable 类过程，自定义的过程，方法创建SQL表，SQL表的字段就是当前DBF的字段
*!*···············································
PROCEDURE CreateTable             && PROCEDURE是类过程，不返回值。function 是函数过程，有返回值。
LOCAL J
Cmd = [CREATE TABLE ] + ALIAS() + [ ( ]   && 设置变量，cmd 等于 创建当前表名  cmd = CREATE TABLE +当前dbf表名 +(
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
*!*···············································
*!*	CreateTable 类过程的结尾。
*!*	··············································