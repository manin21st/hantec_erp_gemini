$PBExportHeader$wp_pip3140.srw
$PBExportComments$** �޿�/�� ����(�̸�������)
forward
global type wp_pip3140 from w_standard_print
end type
type gb_2 from groupbox within wp_pip3140
end type
type dw_1 from datawindow within wp_pip3140
end type
type dw_2 from datawindow within wp_pip3140
end type
type cb_3 from commandbutton within wp_pip3140
end type
type dw_save from dw_list within wp_pip3140
end type
type st_100 from statictext within wp_pip3140
end type
type st_rcvpct from statictext within wp_pip3140
end type
type dw_read from dw_list within wp_pip3140
end type
type cb_all from commandbutton within wp_pip3140
end type
type cb_per from commandbutton within wp_pip3140
end type
type rr_1 from roundrectangle within wp_pip3140
end type
type rb_all from radiobutton within wp_pip3140
end type
type rb_per from radiobutton within wp_pip3140
end type
type dw_read2 from dw_list within wp_pip3140
end type
type p_send from uo_picture within wp_pip3140
end type
end forward

global type wp_pip3140 from w_standard_print
integer x = 0
integer y = 0
integer height = 2024
string title = "�����̸�������"
boolean maxbox = true
gb_2 gb_2
dw_1 dw_1
dw_2 dw_2
cb_3 cb_3
dw_save dw_save
st_100 st_100
st_rcvpct st_rcvpct
dw_read dw_read
cb_all cb_all
cb_per cb_per
rr_1 rr_1
rb_all rb_all
rb_per rb_per
dw_read2 dw_read2
p_send p_send
end type
global wp_pip3140 wp_pip3140

type variables

end variables

forward prototypes
public function integer wf_settext ()
public function integer wf_settext2 ()
public subroutine wf_save (datawindow pdw_file, long i)
public subroutine wf_save_per (datawindow pdw_file, long i)
public function integer wf_retrieve ()
end prototypes

public function integer wf_settext (); String sName
 Long K,ToTalRow
 
 dw_1.Reset()
 dw_1.Retrieve()
 ToTalRow = dw_1.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_1.GetItemString(K,"p3_allowance_allowname")
   dw_list.modify("text100.text = '"+sName+"'")
   dw_save.modify("text100.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text101.text = '"+sName+"'")
 dw_save.modify("text101.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text102.text = '"+sName+"'")
 dw_save.modify("text102.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text103.text = '"+sName+"'")
 dw_save.modify("text103.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text104.text = '"+sName+"'")
 dw_save.modify("text104.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text105.text = '"+sName+"'")
 dw_save.modify("text105.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text106.text = '"+sName+"'")
 dw_save.modify("text106.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text107.text = '"+sName+"'")
 dw_save.modify("text107.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text108.text = '"+sName+"'")
 dw_save.modify("text108.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text109.text = '"+sName+"'")
 dw_save.modify("text109.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text110.text = '"+sName+"'")
 dw_save.modify("text110.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text111.text = '"+sName+"'")
 dw_save.modify("text111.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text112.text = '"+sName+"'")
 dw_save.modify("text112.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text113.text = '"+sName+"'")
 dw_save.modify("text113.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text114.text = '"+sName+"'")
 dw_save.modify("text114.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text115.text = '"+sName+"'")
 dw_save.modify("text115.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text116.text = '"+sName+"'")
 dw_save.modify("text116.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text117.text = '"+sName+"'")
 dw_save.modify("text117.text = '"+sName+"'")
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text118.text = '"+sName+"'")
 dw_save.modify("text118.text = '"+sName+"'")
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text119.text = '"+sName+"'")
 dw_save.modify("text119.text = '"+sName+"'")
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text120.text = '"+sName+"'")
 dw_save.modify("text120.text = '"+sName+"'")
 
Return 1
end function

public function integer wf_settext2 ();String sName
 Long K,ToTalRow
 
 dw_2.Reset()
 dw_2.Retrieve()
 ToTalRow = dw_2.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_2.GetItemString(K,"p3_allowance_allowname")
   dw_list.modify("text200.text = '"+sName+"'")
	dw_save.modify("text200.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text201.text = '"+sName+"'")
 dw_save.modify("text201.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text202.text = '"+sName+"'")
 dw_save.modify("text202.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text203.text = '"+sName+"'")
 dw_save.modify("text203.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text204.text = '"+sName+"'")
 dw_save.modify("text204.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text205.text = '"+sName+"'")
 dw_save.modify("text205.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text206.text = '"+sName+"'")
 dw_save.modify("text206.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text207.text = '"+sName+"'")
 dw_save.modify("text207.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text208.text = '"+sName+"'")
 dw_save.modify("text208.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text209.text = '"+sName+"'")
 dw_save.modify("text209.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text210.text = '"+sName+"'")
 dw_save.modify("text210.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text211.text = '"+sName+"'")
 dw_save.modify("text211.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text212.text = '"+sName+"'")
 dw_save.modify("text212.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text213.text = '"+sName+"'")
 dw_save.modify("text213.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text214.text = '"+sName+"'")
 dw_save.modify("text214.text = '"+sName+"'")
 
 
 
Return 1
end function

public subroutine wf_save (datawindow pdw_file, long i);/*1F===================================================
�� �� ��:	wf_save
��    ��:	ȭ�ϸ��� �Է� �޾� ȭ�Ϸ� �����Ѵ�.
�Ķ����:	datawindow pdw_File
=====================================================*/
string 	lsv_FileName, lsv_ExeName, lsv_userExe,ls_empno,ls_empname
int		liv_Ret

pdw_File.AcceptText()

ls_empno   = dw_read.GetITemString(i,"p3_editdata_empno")
ls_empname = dw_read.GetITemString(i,"p1_master_empname")
lsv_FileName = ls_empno + '(' + ls_empname + ')'

lsv_ExeName = '.HTM'

long llv_pos
//������ Ȯ���ڸ� �˻��Ѵ�.		
llv_pos = pos(lsv_FileName , ".")

if llv_pos = 0 then
	lsv_FileName = lsv_FileName + lsv_ExeName					
end if
				
//if FileExists(lsv_FileName) then
//	liv_Ret = MessageBox("����", lsv_FileName + "������ �����մϴ�." + "~r~n" + &
//										"�����Ͻðڽ��ϱ� ?",  Question!, YesNo!)
//	if liv_Ret = 2 then return
//end if

long 	llv_Ret

llv_Ret = pdw_File.SaveAs('c:\erpman\pay\'+lsv_FileName, HTMLTable!, TRUE)			 	 
//
//IF llv_Ret = 1 THEN
//	MessageBox('����', lsv_FileName + " ����Ǿ����ϴ�.")
//END IF
end subroutine

public subroutine wf_save_per (datawindow pdw_file, long i);/*1F===================================================
�� �� ��:	wf_save
��    ��:	ȭ�ϸ��� �Է� �޾� ȭ�Ϸ� �����Ѵ�.
�Ķ����:	datawindow pdw_File
=====================================================*/
string 	lsv_FileName, lsv_ExeName, lsv_userExe,ls_empno,ls_empname
int		liv_Ret

pdw_File.AcceptText()

ls_empno   = dw_read2.GetITemString(i,"p3_editdata_empno")
ls_empname = dw_read2.GetITemString(i,"p1_master_empname")
lsv_FileName = ls_empno + '(' + ls_empname + ')'

lsv_ExeName = '.HTM'

long llv_pos
//������ Ȯ���ڸ� �˻��Ѵ�.		
llv_pos = pos(lsv_FileName , ".")

if llv_pos = 0 then
	lsv_FileName = lsv_FileName + lsv_ExeName					
end if
				
//if FileExists(lsv_FileName) then
//	liv_Ret = MessageBox("����", lsv_FileName + "������ �����մϴ�." + "~r~n" + &
//										"�����Ͻðڽ��ϱ� ?",  Question!, YesNo!)
//	if liv_Ret = 2 then return
//end if

long 	llv_Ret

llv_Ret = pdw_File.SaveAs('c:\erpman\pay\'+lsv_FileName, HTMLTable!, TRUE)			 	 
//
//IF llv_Ret = 1 THEN
//	MessageBox('����', lsv_FileName + " ����Ǿ����ϴ�.")
//END IF
end subroutine

public function integer wf_retrieve ();String sYm,sSaup,ls_gubun,ls_Empno,sDeptcode
integer iRtnValue
dw_ip.AcceptText()

sYm      = dw_ip.GetITemString(1,"l_ym")
sSaup    = dw_ip.GetITemString(1,"l_saup")
ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*�޿�,�󿩱���*/
ls_Empno = dw_ip.GetITemString(1,"l_empno")
sDeptcode  = dw_ip.GetITemString(1,"l_dept")  /*�μ�*/
			  
		 
IF sYm = "      " OR IsNull(sYm) THEN
	MessageBox("Ȯ ��","����� �Է��ϼ���!!")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sYm + '01') = -1 THEN
   MessageBox("Ȯ��","����� Ȯ���ϼ���")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 
//IF sSaup = '' OR ISNULL(sSaup) THEN
//	MessageBox("Ȯ ��","������� �Է��ϼ���!!")
//	dw_ip.SetColumn("l_saup")
//	dw_ip.SetFocus()
//	Return -1
//END IF	
IF ls_gubun = '' OR ISNULL(ls_gubun) THEN
	MessageBox("Ȯ ��","������ �Է��ϼ���!!")
	dw_ip.SetColumn("l_gubn")
	dw_ip.SetFocus()
	Return -1
END IF	

IF sSaup = '' OR ISNULL(sSaup) THEN
	sSaup = '%'	
END IF	

IF ls_Empno = '' OR ISNULL(ls_Empno) THEN
	ls_Empno = '%'
END IF	

IF sDeptcode = '' OR ISNULL(sDeptcode) THEN
	sDeptcode = '%'
END IF	


		
DELETE FROM "P3_TMP_PAY"
COMMIT ;


/*****************************************/
/*************���޺κ�********************/
/*****************************************/

INSERT INTO "P3_TMP_PAY"	 
	         ("EMPNO",    "GUBUN",   "ALLOWCODE",   
             "ALLOWAMT", "PRINTSEQ")
				 
				 
SELECT p3_editdatachild.empno as empno,  /*����*/
				 '1' AS GUBUN,
				 p3_editdatachild.allowcode,
				 p3_editdatachild.allowamt as amt,
				 P3_ALLOWANCE.PRINTSEQ
		  FROM p3_editdatachild,P3_ALLOWANCE
		 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
				 p3_editdatachild.companycode =:gs_company AND 
				 p3_editdatachild.workym     =:sYm AND
				 p3_editdatachild.pbtag     =:ls_gubun and  
				 P3_ALLOWANCE.paysubtag     = '1'
		
		UNION ALL 
	
		 SELECT p3_editdatachild.empno as empno,   /*�����κ�*/
				 '2' AS GUBUN,
				 p3_editdatachild.allowcode,
				 p3_editdatachild.allowamt as amt,
				 P3_ALLOWANCE.PRINTSEQ
		  FROM p3_editdatachild,P3_ALLOWANCE
		 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
				 p3_editdatachild.companycode =:gs_company AND 
				 p3_editdatachild.workym     =:sYm AND
				 p3_editdatachild.pbtag     =:ls_gubun and  
				 P3_ALLOWANCE.paysubtag     = '2'  ;
IF SQLCA.SQLCODE = 0 THEN
	COMMIT ;
ELSE
   ROLLBACK ;	
END IF	
SetPointer(HourGlass!)
//iRtnValue = sqlca.FUN_PAYLIST(sYm,sSaup,ls_gubun,ls_Empno,sDeptcode,gs_company);

//IF iRtnValue <> 1 then
//	MessageBox("Ȯ ��","�޿����� ��ȸ����!!")
//	SetPointer(Arrow!)
//	Return -1
//END IF
WF_SETTEXT()
WF_SETTEXT2()

IF dw_list.Retrieve(sSaup,sYm,sDeptcode,ls_gubun,ls_Empno) <=0 THEN
	MessageBox("Ȯ ��","��ȸ�� �ڷᰡ �����ϴ�!!")
	Return -1
else	
	dw_save.SetTransObject(SQLCA)
	dw_save.Retrieve(sSaup,sYm,sDeptcode,ls_gubun,ls_Empno)
	
END IF


	
SetPointer(Arrow!)
Return 1
end function

on wp_pip3140.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cb_3=create cb_3
this.dw_save=create dw_save
this.st_100=create st_100
this.st_rcvpct=create st_rcvpct
this.dw_read=create dw_read
this.cb_all=create cb_all
this.cb_per=create cb_per
this.rr_1=create rr_1
this.rb_all=create rb_all
this.rb_per=create rb_per
this.dw_read2=create dw_read2
this.p_send=create p_send
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.dw_save
this.Control[iCurrent+6]=this.st_100
this.Control[iCurrent+7]=this.st_rcvpct
this.Control[iCurrent+8]=this.dw_read
this.Control[iCurrent+9]=this.cb_all
this.Control[iCurrent+10]=this.cb_per
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.rb_all
this.Control[iCurrent+13]=this.rb_per
this.Control[iCurrent+14]=this.dw_read2
this.Control[iCurrent+15]=this.p_send
end on

on wp_pip3140.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cb_3)
destroy(this.dw_save)
destroy(this.st_100)
destroy(this.st_rcvpct)
destroy(this.dw_read)
destroy(this.cb_all)
destroy(this.cb_per)
destroy(this.rr_1)
destroy(this.rb_all)
destroy(this.rb_per)
destroy(this.dw_read2)
destroy(this.p_send)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

dw_ip.SetITem(1,"l_ym",String(gs_today,'@@@@@@'))
dw_ip.SetITem(1,"l_gubn",'P')

f_set_saupcd(dw_ip, 'l_saup', '1')
is_saupcd = gs_saupcd

dw_list.insertrow(0)

st_100.Visible = false
st_rcvpct.Visible = false
end event

type p_preview from w_standard_print`p_preview within wp_pip3140
end type

type p_exit from w_standard_print`p_exit within wp_pip3140
end type

type p_print from w_standard_print`p_print within wp_pip3140
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip3140
end type

type st_window from w_standard_print`st_window within wp_pip3140
boolean visible = false
integer x = 2418
integer y = 3448
end type

type sle_msg from w_standard_print`sle_msg within wp_pip3140
boolean visible = false
integer x = 443
integer y = 3448
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip3140
boolean visible = false
integer x = 2912
integer y = 3448
end type

type st_10 from w_standard_print`st_10 within wp_pip3140
boolean visible = false
integer x = 82
integer y = 3448
end type

type gb_10 from w_standard_print`gb_10 within wp_pip3140
boolean visible = false
integer x = 69
integer y = 3412
end type

type dw_print from w_standard_print`dw_print within wp_pip3140
integer x = 3739
integer y = 2312
string dataobject = "dp_pip3140_20_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip3140
integer x = 46
integer y = 56
integer width = 2633
integer height = 336
string dataobject = "dp_pip3140_10"
end type

event dw_ip::itemchanged;String sDeptno,sName,snull,sEmpNo,sEmpName

SetNull(snull)

This.AcceptText()

IF dw_ip.GetColumnName() = "l_saup" THEN
	is_saupcd = this.GetText()
	sDeptno = dw_ip.GetText()
	IF sDeptno = '' OR ISNULL(sDeptno) THEN RETURN
	  SELECT "P0_DEPT"."DEPTNAME"  
       INTO :sName  
       FROM "P0_DEPT"  
		WHERE "P0_DEPT"."SAUPCD" =:sDeptno ;
		IF sName = '' OR ISNULL(sName) THEN
			MessageBox("Ȯ ��","������ȣ�� Ȯ���ϼ���!!")  
			dw_ip.SetITem(1,"l_saup",snull)
			Return 1
		END IF
END IF	


IF dw_ip.GetColumnName() ="l_dept" THEN 
   sDeptno = dw_ip.GetText()
	IF sDeptno = '' OR ISNULL(sDeptno) THEN
		dw_ip.SetITem(1,"l_dept",snull)
		dw_ip.SetITem(1,"l_deptname",snull)
		Return 
	END IF	
	
	  SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :sDeptno ); 
	
	IF sName = '' OR ISNULL(sName) THEN
   	MessageBox("Ȯ ��","�μ���ȣ�� Ȯ���ϼ���!!") 
		dw_ip.SetITem(1,"l_dept",snull)
	   dw_ip.SetITem(1,"l_deptname",snull) 
		dw_ip.SetColumn("l_dept")
      Return 1
	END IF	
	   dw_ip.SetITem(1,"l_deptname",sName) 
END IF
IF dw_ip.GetColumnName() = "l_empno" then
   sEmpNo = dw_ip.GetItemString(1,"l_empno")

	IF sEmpNo = '' or isnull(sEmpNo) THEN
	   dw_ip.SetITem(1,"l_empno",snull)
		dw_ip.SetITem(1,"l_empname",snull)
	ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("Ȯ ��","�����ȣ�� Ȯ���ϼ���!!") 
				 dw_ip.SetITem(1,"l_empno",snull)
				 dw_ip.SetITem(1,"l_empname",snull)
				 RETURN 1 
			 END IF
				dw_ip.SetITem(1,"l_empname",sEmpName  )
				
	 END IF
END IF



end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd
IF dw_ip.GetColumnName() = "l_dept" THEN
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_ip.SetITem(1,"l_dept",gs_code)
	dw_ip.SetITem(1,"l_deptname",gs_codename)
END IF	

IF dw_ip.GetColumnName() = "l_empno" THEN
   Open(w_employee_saup_popup)

   if isnull(gs_code) or gs_code = '' then return
   dw_ip.SetITem(1,"l_empno",gs_code)
	dw_ip.SetITem(1,"l_empname",gs_codename)
  
END IF	
end event

type dw_list from w_standard_print`dw_list within wp_pip3140
integer x = 91
integer y = 600
integer width = 4407
integer height = 1168
string dataobject = "dp_pip3140_20"
boolean border = false
end type

event dw_list::rowfocuschanged;//override
end event

event dw_list::clicked;//override
end event

type gb_2 from groupbox within wp_pip3140
integer x = 2798
integer y = 184
integer width = 777
integer height = 204
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "���� �߼� �����"
end type

type dw_1 from datawindow within wp_pip3140
boolean visible = false
integer x = 69
integer y = 3308
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT ���� ����Ÿ������(����)"
string dataobject = "dp_pip3140_30"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within wp_pip3140
boolean visible = false
integer x = 1019
integer y = 3308
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT ���� ����Ÿ������(����)"
string dataobject = "dp_pip3140_40"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within wp_pip3140
boolean visible = false
integer x = 3730
integer y = 3412
integer width = 750
integer height = 132
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�������� Sample Source"
end type

event clicked;//String is_FileName,ls_ym ,ls_filename
//mailSession mSes
//mailReturnCode mRet
//mailMessage mMsg
//mailRecipient mRecip
//mailFileDescription mattach
//Boolean ib_attach = False
//
//mSes = create mailSession              // MailSession ������Ʈ ���� .
//mRet = mSes.mailLogon(mailNewSession!) // ���� Session �α� -�� .
//
//IF mRet <> mailReturnSuccess! THEN
//   MessageBox("���� Session", '�α� -�� ���� ')
//   Return
//END IF
//
////***** ���� ������ ��ư(cb_sendmail)�� Clicked �̺�Ʈ *****
////mMsg.Recipient[1].name = sle_to.Text // ���� �޴»���� �ּ�
//
//ls_ym      = dw_ip.GetITemString(1,"l_ym")
//mMsg.Subject = left(ls_ym,4) + '�� ' + mid(ls_ym,5,2) + '�� �޿����� �Դϴ�.'
//mMsg.NoteText = '�Ѵ� ���� ��� �����̽��ϴ�.'
//
//mMsg.Recipient[1].name = 'wyyang@bdsic.com'
//
//
//datawindow ldw_save
//ldw_save = dw_save
//wf_save(ldw_save)
//ls_filename = "c:\test.htm"
////if FileExists(lsv_FileName) then
////     ib_attach = true
////else
////	ib_attach = false
////end if;
//ib_attach = true
//
//  /******** ���� ÷�ν� ��� �Ѵ� .************/
//IF ib_attach = True THEN
//   mattach.Filetype = mailattach! // ���� ÷�� �ϱ����� �۾� .
////   mattach.PathName = sle_attach.Text // ÷���� ������ �ִ� Full Path.
//	mattach.PathName = ls_filename
////   mattach.FileName = is_FileName // ÷���� ������ �̸� .
//	mattach.FileName = ls_filename
////	mAttach.Position = filelength('c:\erpman\test.htm')
//   mattach.Position = len(mMsg.notetext) - 1 //÷�ε� ������ ��ġ ����
//   mMsg.attachmentFile[1] = mattach
//END IF
//
////MSes.mailResolveRecipient(mMsg.Recipient[1].name) // E-mail Address �� ��´� .
//mRet = mSes.mailSend(mMsg) // ���� ������ .
//IF mRet <> mailReturnSuccess! THEN
//   MessageBox('���Ϻ����� ', '���Ϻ����� ==> ���� ')
//   RETURN 
//ELSE
//   MessageBox('���Ϻ����� ', '���Ϻ����� ==> ���� ')
//end If
//
//
////********************************
//// �������� ���� ���� ������... 
////********************************
////  mMsg.Subject = sle_subject.Text      // ���� ���� ���� .
////  mMsg.NoteText = mle_body.Text        // ���� ���� ���� .
////  for i = 1 to dw_list.rowcount()
////      if isnull(dw_list.object.email[i]) = false then
////         cc++
////         ls_address = dw_list.object.email[i]
////         mMsg.Recipient[cc].name = ls_address // ���� �޴»���� �ּ�
////     end if
////  next
////    
////           /******** ���� ÷�ν� ��� �Ѵ� .************/
////IF ib_attach = True THEN
////   mattach.Filetype = mailattach!             // ����÷�� �ϱ����� �۾� .
////   mattach.PathName = sle_attach.Text         // ÷���� ������ �ִ� Full Path.
////   mattach.FileName = is_FileName             // ÷���� ������ �̸� .
////   mattach.Position = len(mMsg.notetext) - 1  //÷�ε� ������ ��ġ ����
////   mMsg.attachmentFile[1] = mattach
////END IF
////
////
//////���� for���� ���ؼ� ��ϵ� mail�ּҷ� �ϰ� ���۵ʴϴ�.
////mRet = mSes.mailSend(mMsg) // ���� ������ 
////  
////IF mRet <> mailReturnSuccess! THEN
////   MessageBox('email','�������ۿ� �����Ͽ����ϴ�....')
////   RETURN 
////ELSE
////   MessageBox('email','������ �����Ͽ����ϴ�....')
////end If
////***************************** Ȥ�ó� �ؼ� ���� ��..
//
//
//mSes.mailLogoff() // ���� Session ���� .
//DESTROY mSes
//
//
////**** ÷������ ã�� ��ư(cb_browse)�� Clicked �̺�Ʈ *****
////String ls_FilePathName
////ib_attach = True
////GetFileOpenName("Select File", ls_FilePathName, s_filename, "DOC", "All Files (*.*),*.*")
////sle_attach.Text = ls_FilePathName // sle_attatch �� ���������� �ִ� �̱۶� �ο����ͷ� ÷���� ������ ��θ� �����ش� .
//
end event

type dw_save from dw_list within wp_pip3140
boolean visible = false
integer x = 3959
integer y = 2772
integer width = 151
integer height = 132
integer taborder = 10
boolean bringtotop = true
string dataobject = "dp_pip3140_mail"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type st_100 from statictext within wp_pip3140
boolean visible = false
integer x = 2030
integer y = 1920
integer width = 2519
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 16777215
boolean border = true
boolean focusrectangle = false
end type

type st_rcvpct from statictext within wp_pip3140
boolean visible = false
integer x = 2030
integer y = 1924
integer width = 41
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 8388608
boolean focusrectangle = false
end type

type dw_read from dw_list within wp_pip3140
boolean visible = false
integer x = 1998
integer y = 2456
integer width = 1920
integer height = 588
integer taborder = 20
boolean bringtotop = true
string dataobject = "dp_pip3140_read"
end type

type cb_all from commandbutton within wp_pip3140
boolean visible = false
integer x = 3950
integer y = 2600
integer width = 635
integer height = 164
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����� �޿� ����"
end type

event clicked;String  sYm,sSaup,ls_gubun,ls_empno,ls_deptcode , ls_mailad,ls_empname
string  NextStep
integer iRtnValue
long    i
decimal ld_pct_ind
//========================== Mail����...
String ls_ym ,lsv_filename,lsv_ExeName,ls_FileName
mailSession mSes
mailReturnCode mRet
mailMessage mMsg
mailRecipient mRecip
mailFileDescription mattach
Boolean ib_attach = False
datawindow ldw_save
//==========================
mSes = create mailSession              // MailSession ������Ʈ ���� .
mRet = mSes.mailLogon(mailNewSession!) // ���� Session �α� -�� .

dw_ip.AcceptText()
dw_read.SetTransObject(SQLCA)

IF mRet <> mailReturnSuccess! THEN
   MessageBox("���� Session", '�α� -�� ���� ')
   Return
END IF

sYm      = dw_ip.GetITemString(1,"l_ym")
sSaup    = dw_ip.GetITemString(1,"l_saup")
ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*�޿�,�󿩱���*/
		  
		 
IF sYm = "      " OR IsNull(sYm) THEN
	MessageBox("Ȯ ��","����� �Է��ϼ���!!")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sYm + '01') = -1 THEN
   MessageBox("Ȯ��","����� Ȯ���ϼ���")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 

IF ls_gubun = '' OR ISNULL(ls_gubun) THEN
	MessageBox("Ȯ ��","������ �Է��ϼ���!!")
	dw_ip.SetColumn("l_gubn")
	dw_ip.SetFocus()
	Return -1
END IF	

IF sSaup = '' OR ISNULL(sSaup) THEN
	sSaup = '%'	
END IF	

SetPointer(HourGlass!)

DELETE FROM "P3_TMP_PAY"
COMMIT ;


/*****************************************/
/*************���޺κ�********************/
/*****************************************/

INSERT INTO "P3_TMP_PAY"	 
	         ("EMPNO",    "GUBUN",   "ALLOWCODE",   
             "ALLOWAMT", "PRINTSEQ")
				 
				 
SELECT p3_editdatachild.empno as empno,  /*����*/
				 '1' AS GUBUN,
				 p3_editdatachild.allowcode,
				 p3_editdatachild.allowamt as amt,
				 P3_ALLOWANCE.PRINTSEQ
		  FROM p3_editdatachild,P3_ALLOWANCE
		 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
				 p3_editdatachild.companycode =:gs_company AND 
				 p3_editdatachild.workym     =:sYm AND
				 p3_editdatachild.pbtag     =:ls_gubun and  
				 P3_ALLOWANCE.paysubtag     = '1'
		
		UNION ALL 
	
		 SELECT p3_editdatachild.empno as empno,   /*�����κ�*/
				 '2' AS GUBUN,
				 p3_editdatachild.allowcode,
				 p3_editdatachild.allowamt as amt,
				 P3_ALLOWANCE.PRINTSEQ
		  FROM p3_editdatachild,P3_ALLOWANCE
		 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
				 p3_editdatachild.companycode =:gs_company AND 
				 p3_editdatachild.workym     =:sYm AND
				 p3_editdatachild.pbtag     =:ls_gubun and  
				 P3_ALLOWANCE.paysubtag     = '2'  ;
IF SQLCA.SQLCODE = 0 THEN
	COMMIT ;
ELSE
   ROLLBACK ;	
END IF	

IF dw_read.Retrieve(sSaup,sYm,ls_gubun) <=0 THEN
	MessageBox("Ȯ ��","�޿��� �������� �ʾҽ��ϴ�!!")
	Return -1
END IF
	
for i = 1 to dw_read.rowcount() 		
	ls_empno    = dw_read.GetITemString(i,"p3_editdata_empno")
	ls_empname  = dw_read.GetITemString(i,"p1_master_empname")
	ls_deptcode = dw_read.GetITemString(i,"p3_editdata_deptcode")
	ls_mailad   = dw_read.GetITemString(i,"p1_etc_email")
	
	if ls_mailad = '' or isnull(ls_mailad) then
		messagebox(ls_empno,ls_empname + '�� �����ּҰ� ��ϵ��� �ʾҽ��ϴ�! Ȯ�ο��')
	else
		
		WF_SETTEXT()
		WF_SETTEXT2()
		dw_save.SetTransObject(SQLCA)
		dw_save.Retrieve(sSaup,sYm,ls_deptcode,ls_gubun,ls_Empno)
		
		// C:\erpman\pay ���� �ؿ� �޿� ���(����).html ����...
		ldw_save = dw_save
		wf_save(ldw_save,i)
	
		//***** ���� ������ *****
		mMsg.Recipient[1].name = ls_mailad 	  // ���� �޴»���� �ּ�	
		ls_ym      = dw_ip.GetITemString(1,"l_ym")
		mMsg.Subject = left(ls_ym,4) + '�� ' + mid(ls_ym,5,2) + '�� �޿����� �Դϴ�.'
		mMsg.NoteText = '�Ѵ� ���� ��� �����̽��ϴ�.'
	   //***** ���� ÷�� *****			
		ls_empno   = dw_read.GetITemString(i,"p3_editdata_empno")
		ls_empname = dw_read.GetITemString(i,"p1_master_empname")
		lsv_FileName = ls_empno + '(' + ls_empname + ')'				
		lsv_ExeName = '.HTM'
		
		long llv_pos
		//������ Ȯ���ڸ� �˻��Ѵ�.		
		llv_pos = pos(lsv_FileName , ".")
		
		if llv_pos = 0 then
			ls_FileName = 'c:\erpman\pay\' + lsv_FileName + lsv_ExeName					
		end if
		
		mattach.Filetype = mailattach! // ���� ÷�� �ϱ����� �۾� .
		mattach.PathName = ls_filename
		mattach.FileName = ls_filename
	   mattach.Position = len(mMsg.notetext) - 1 //÷�ε� ������ ��ġ ����
	   mMsg.attachmentFile[1] = mattach		

		mRet = mSes.mailSend(mMsg) // ���� ������ .

		IF mRet <> mailReturnSuccess! THEN
			MessageBox('���Ϻ����� ', lsv_FileName + ' ���Ϻ����� ==> ���� ')
		end If

	end if	
	
	ld_pct_ind = ( i / dw_read.rowcount()) * 100
	st_rcvpct.width = ld_pct_ind / 100.0 * st_100.width
	st_rcvpct.visible = true	  		
next				

mSes.mailLogoff() // ���� Session ���� .
DESTROY mSes

SetPointer(Arrow!)

end event

type cb_per from commandbutton within wp_pip3140
boolean visible = false
integer x = 3950
integer y = 2424
integer width = 635
integer height = 164
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "���� ���� ��� ����"
end type

event clicked;String  sYm,sSaup,ls_gubun,ls_empno,ls_deptcode , ls_mailad,ls_empname,&
        lsv_Empno,sDeptcode
integer iRtnValue
long    i
decimal ld_pct_ind
//========================== Mail����...
String ls_ym ,lsv_filename,lsv_ExeName,ls_FileName
mailSession mSes
mailReturnCode mRet
mailMessage mMsg
mailRecipient mRecip
mailFileDescription mattach
Boolean ib_attach = False
datawindow ldw_save
//==========================
mSes = create mailSession              // MailSession ������Ʈ ���� .
mRet = mSes.mailLogon(mailNewSession!) // ���� Session �α� -�� .

dw_ip.AcceptText()
dw_read2.SetTransObject(SQLCA)

IF mRet <> mailReturnSuccess! THEN
   MessageBox("���� Session", '�α� -�� ���� ')
   Return
END IF

sYm      = dw_ip.GetITemString(1,"l_ym")
sSaup    = dw_ip.GetITemString(1,"l_saup")
ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*�޿�,�󿩱���*/
lsv_Empno = dw_ip.GetITemString(1,"l_empno")
sDeptcode  = dw_ip.GetITemString(1,"l_dept")  /*�μ�*/		  
		 
IF sYm = "      " OR IsNull(sYm) THEN
	MessageBox("Ȯ ��","����� �Է��ϼ���!!")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sYm + '01') = -1 THEN
   MessageBox("Ȯ��","����� Ȯ���ϼ���")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 

IF ls_gubun = '' OR ISNULL(ls_gubun) THEN
	MessageBox("Ȯ ��","������ �Է��ϼ���!!")
	dw_ip.SetColumn("l_gubn")
	dw_ip.SetFocus()
	Return -1
END IF	

IF sSaup = '' OR ISNULL(sSaup) THEN
	sSaup = '%'	
END IF	

IF lsv_Empno = '' OR ISNULL(lsv_Empno) THEN
	lsv_Empno = '%'
END IF	

IF sDeptcode = '' OR ISNULL(sDeptcode) THEN
	sDeptcode = '%'
END IF		

if sDeptcode = '%' and lsv_empno = '%' then 
	messagebox("���Ǽ�������� �����ϼ̽��ϴ�.","�μ� �Ǵ� �����ȣ�� �����Ͻ� �� �۾��ٶ��ϴ�.")
	return
end if

SetPointer(HourGlass!)

DELETE FROM "P3_TMP_PAY"
COMMIT ;


/*****************************************/
/*************���޺κ�********************/
/*****************************************/

INSERT INTO "P3_TMP_PAY"	 
	         ("EMPNO",    "GUBUN",   "ALLOWCODE",   
             "ALLOWAMT", "PRINTSEQ")
				 
				 
SELECT p3_editdatachild.empno as empno,  /*����*/
				 '1' AS GUBUN,
				 p3_editdatachild.allowcode,
				 p3_editdatachild.allowamt as amt,
				 P3_ALLOWANCE.PRINTSEQ
		  FROM p3_editdatachild,P3_ALLOWANCE
		 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
				 p3_editdatachild.companycode =:gs_company AND 
				 p3_editdatachild.workym     =:sYm AND
				 p3_editdatachild.pbtag     =:ls_gubun and  
				 P3_ALLOWANCE.paysubtag     = '1'
		
		UNION ALL 
	
		 SELECT p3_editdatachild.empno as empno,   /*�����κ�*/
				 '2' AS GUBUN,
				 p3_editdatachild.allowcode,
				 p3_editdatachild.allowamt as amt,
				 P3_ALLOWANCE.PRINTSEQ
		  FROM p3_editdatachild,P3_ALLOWANCE
		 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
				 p3_editdatachild.companycode =:gs_company AND 
				 p3_editdatachild.workym     =:sYm AND
				 p3_editdatachild.pbtag     =:ls_gubun and  
				 P3_ALLOWANCE.paysubtag     = '2'  ;
IF SQLCA.SQLCODE = 0 THEN
	COMMIT ;
ELSE
   ROLLBACK ;	
END IF	

IF dw_read2.Retrieve(sSaup,sYm,sDeptcode,ls_gubun,lsv_empno) <=0 THEN
	MessageBox("Ȯ ��","�޿��� �������� �ʾҽ��ϴ�!!")
	Return -1
END IF
	
for i = 1 to dw_read2.rowcount() 		
	ls_empno    = dw_read2.GetITemString(i,"p3_editdata_empno")
	ls_empname  = dw_read2.GetITemString(i,"p1_master_empname")
	ls_deptcode = dw_read2.GetITemString(i,"p3_editdata_deptcode")
	ls_mailad   = dw_read2.GetITemString(i,"p1_etc_email")
	
	if ls_mailad = '' or isnull(ls_mailad) then
		messagebox(ls_empno,ls_empname + '�� �����ּҰ� ��ϵ��� �ʾҽ��ϴ�! Ȯ�ο��')
	else
		
		WF_SETTEXT()
		WF_SETTEXT2()
		dw_save.SetTransObject(SQLCA)
		dw_save.Retrieve(sSaup,sYm,ls_deptcode,ls_gubun,ls_Empno)
		
		// C:\erpman\pay ���� �ؿ� �޿� ���(����).html ����...
		ldw_save = dw_save
		wf_save_per(ldw_save,i)
	
		//***** ���� ������ *****
		mMsg.Recipient[1].name = ls_mailad 	  // ���� �޴»���� �ּ�	
		mMsg.Recipient[1].address = ls_mailad
		ls_ym      = dw_ip.GetITemString(1,"l_ym")
		mMsg.Subject = left(ls_ym,4) + '�� ' + mid(ls_ym,5,2) + '�� �޿����� �Դϴ�.'
//		mMsg.NoteText = '�Ѵ� ���� ��� �����̽��ϴ�.'
	   //***** ���� ÷�� *****			
		ls_empno   = dw_read2.GetITemString(i,"p3_editdata_empno")
		ls_empname = dw_read2.GetITemString(i,"p1_master_empname")
		lsv_FileName = ls_empno + '(' + ls_empname + ')'				
		lsv_ExeName = '.HTM'
		
		long llv_pos
		//������ Ȯ���ڸ� �˻��Ѵ�.		
		llv_pos = pos(lsv_FileName , ".")
		
		if llv_pos = 0 then
			ls_FileName = 'c:\erpman\pay\' + lsv_FileName + lsv_ExeName					
		end if
		
		mattach.Filetype = mailattach! // ���� ÷�� �ϱ����� �۾� .
		mattach.PathName = ls_filename
		mattach.FileName = ls_filename
	   mattach.Position = len(mMsg.notetext) - 1 //÷�ε� ������ ��ġ ����
	   mMsg.attachmentFile[1] = mattach		

		mRet = mSes.mailSend(mMsg) // ���� ������ .

		IF mRet <> mailReturnSuccess! THEN
			MessageBox('���Ϻ����� ', lsv_FileName + ' ���Ϻ����� ==> ���� ')
		end If

	end if	
	
	ld_pct_ind = ( i / dw_read2.rowcount()) * 100
	st_rcvpct.width = ld_pct_ind / 100.0 * st_100.width
	st_rcvpct.visible = true	  		
next				

mSes.mailLogoff() // ���� Session ���� .
DESTROY mSes

SetPointer(Arrow!)

end event

type rr_1 from roundrectangle within wp_pip3140
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 540
integer width = 4503
integer height = 1288
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_all from radiobutton within wp_pip3140
integer x = 2866
integer y = 276
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
string text = "��ü"
end type

event clicked;//
////String ldt_workdate
////
////ldt_workdate = Left(em_date.text,4) + Right(em_date.text,2)+ '31'
////
//mm = integer(mid(em_date.text,6,2))
//
//startdate = Left(em_date.text,4)+Right(em_date.text,2) + "01"
//enddate = Left(em_date.text,4)+Right(em_date.text,2)  + STRING(idd_dd[mm])
//
//st_info.Visible = True
//
//dw_1.retrieve(gs_company,startdate,enddate)
//dw_2.Reset()
//dw_err.Reset()
//
//rb_per.checked = false
end event

type rb_per from radiobutton within wp_pip3140
integer x = 3131
integer y = 272
integer width = 411
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 32106727
string text = "���Ǽ������"
boolean checked = true
end type

event clicked;//
//rb_all.checked = false
//
//
end event

type dw_read2 from dw_list within wp_pip3140
boolean visible = false
integer x = 50
integer y = 2460
integer width = 1925
integer height = 588
boolean bringtotop = true
string dataobject = "dp_pip3140_read2"
end type

type p_send from uo_picture within wp_pip3140
integer x = 3598
integer y = 244
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\Erpman\image\��������_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\��������_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\��������_up.gif"
end event

event clicked;call super::clicked;st_100.Visible = true
st_rcvpct.Visible = true

IF rb_all.Checked = True THEN
	cb_all.TriggerEvent(Clicked!)
ELSE
	cb_per.TriggerEvent(Clicked!)
END IF
end event

