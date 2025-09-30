$PBExportHeader$wp_pip3140.srw
$PBExportComments$** 급여/상여 명세서(이메일전송)
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
string title = "명세서이메일전송"
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
함 수 명:	wf_save
설    명:	화일명을 입력 받아 화일로 저장한다.
파라미터:	datawindow pdw_File
=====================================================*/
string 	lsv_FileName, lsv_ExeName, lsv_userExe,ls_empno,ls_empname
int		liv_Ret

pdw_File.AcceptText()

ls_empno   = dw_read.GetITemString(i,"p3_editdata_empno")
ls_empname = dw_read.GetITemString(i,"p1_master_empname")
lsv_FileName = ls_empno + '(' + ls_empname + ')'

lsv_ExeName = '.HTM'

long llv_pos
//파일의 확장자를 검사한다.		
llv_pos = pos(lsv_FileName , ".")

if llv_pos = 0 then
	lsv_FileName = lsv_FileName + lsv_ExeName					
end if
				
//if FileExists(lsv_FileName) then
//	liv_Ret = MessageBox("저장", lsv_FileName + "파일이 존재합니다." + "~r~n" + &
//										"저장하시겠습니까 ?",  Question!, YesNo!)
//	if liv_Ret = 2 then return
//end if

long 	llv_Ret

llv_Ret = pdw_File.SaveAs('c:\erpman\pay\'+lsv_FileName, HTMLTable!, TRUE)			 	 
//
//IF llv_Ret = 1 THEN
//	MessageBox('도움말', lsv_FileName + " 저장되었습니다.")
//END IF
end subroutine

public subroutine wf_save_per (datawindow pdw_file, long i);/*1F===================================================
함 수 명:	wf_save
설    명:	화일명을 입력 받아 화일로 저장한다.
파라미터:	datawindow pdw_File
=====================================================*/
string 	lsv_FileName, lsv_ExeName, lsv_userExe,ls_empno,ls_empname
int		liv_Ret

pdw_File.AcceptText()

ls_empno   = dw_read2.GetITemString(i,"p3_editdata_empno")
ls_empname = dw_read2.GetITemString(i,"p1_master_empname")
lsv_FileName = ls_empno + '(' + ls_empname + ')'

lsv_ExeName = '.HTM'

long llv_pos
//파일의 확장자를 검사한다.		
llv_pos = pos(lsv_FileName , ".")

if llv_pos = 0 then
	lsv_FileName = lsv_FileName + lsv_ExeName					
end if
				
//if FileExists(lsv_FileName) then
//	liv_Ret = MessageBox("저장", lsv_FileName + "파일이 존재합니다." + "~r~n" + &
//										"저장하시겠습니까 ?",  Question!, YesNo!)
//	if liv_Ret = 2 then return
//end if

long 	llv_Ret

llv_Ret = pdw_File.SaveAs('c:\erpman\pay\'+lsv_FileName, HTMLTable!, TRUE)			 	 
//
//IF llv_Ret = 1 THEN
//	MessageBox('도움말', lsv_FileName + " 저장되었습니다.")
//END IF
end subroutine

public function integer wf_retrieve ();String sYm,sSaup,ls_gubun,ls_Empno,sDeptcode
integer iRtnValue
dw_ip.AcceptText()

sYm      = dw_ip.GetITemString(1,"l_ym")
sSaup    = dw_ip.GetITemString(1,"l_saup")
ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
ls_Empno = dw_ip.GetITemString(1,"l_empno")
sDeptcode  = dw_ip.GetITemString(1,"l_dept")  /*부서*/
			  
		 
IF sYm = "      " OR IsNull(sYm) THEN
	MessageBox("확 인","년월을 입력하세요!!")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sYm + '01') = -1 THEN
   MessageBox("확인","년월을 확인하세요")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 
//IF sSaup = '' OR ISNULL(sSaup) THEN
//	MessageBox("확 인","사업장을 입력하세요!!")
//	dw_ip.SetColumn("l_saup")
//	dw_ip.SetFocus()
//	Return -1
//END IF	
IF ls_gubun = '' OR ISNULL(ls_gubun) THEN
	MessageBox("확 인","구분을 입력하세요!!")
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
/*************지급부분********************/
/*****************************************/

INSERT INTO "P3_TMP_PAY"	 
	         ("EMPNO",    "GUBUN",   "ALLOWCODE",   
             "ALLOWAMT", "PRINTSEQ")
				 
				 
SELECT p3_editdatachild.empno as empno,  /*수당*/
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
	
		 SELECT p3_editdatachild.empno as empno,   /*공제부분*/
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
//	MessageBox("확 인","급여명세서 조회오류!!")
//	SetPointer(Arrow!)
//	Return -1
//END IF
WF_SETTEXT()
WF_SETTEXT2()

IF dw_list.Retrieve(sSaup,sYm,sDeptcode,ls_gubun,ls_Empno) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
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
			MessageBox("확 인","사업장번호를 확인하세요!!")  
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
   	MessageBox("확 인","부서번호를 확인하세요!!") 
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
				 MessageBox("확 인","사원번호를 확인하세요!!") 
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
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "메일 발송 대상설정"
end type

type dw_1 from datawindow within wp_pip3140
boolean visible = false
integer x = 69
integer y = 3308
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(지급)"
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
string title = "TEXT 찍기용 데이타윈도우(공제)"
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
string facename = "굴림체"
string text = "메일전송 Sample Source"
end type

event clicked;//String is_FileName,ls_ym ,ls_filename
//mailSession mSes
//mailReturnCode mRet
//mailMessage mMsg
//mailRecipient mRecip
//mailFileDescription mattach
//Boolean ib_attach = False
//
//mSes = create mailSession              // MailSession 오브젝트 생성 .
//mRet = mSes.mailLogon(mailNewSession!) // 메일 Session 로그 -온 .
//
//IF mRet <> mailReturnSuccess! THEN
//   MessageBox("메일 Session", '로그 -온 실패 ')
//   Return
//END IF
//
////***** 메일 보내기 버튼(cb_sendmail)의 Clicked 이벤트 *****
////mMsg.Recipient[1].name = sle_to.Text // 메일 받는사람의 주소
//
//ls_ym      = dw_ip.GetITemString(1,"l_ym")
//mMsg.Subject = left(ls_ym,4) + '년 ' + mid(ls_ym,5,2) + '월 급여명세서 입니다.'
//mMsg.NoteText = '한달 동안 고생 많으셨습니다.'
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
//  /******** 파일 첨부시 사용 한다 .************/
//IF ib_attach = True THEN
//   mattach.Filetype = mailattach! // 파일 첨부 하기위한 작업 .
////   mattach.PathName = sle_attach.Text // 첨부할 파일이 있는 Full Path.
//	mattach.PathName = ls_filename
////   mattach.FileName = is_FileName // 첨부할 파일의 이름 .
//	mattach.FileName = ls_filename
////	mAttach.Position = filelength('c:\erpman\test.htm')
//   mattach.Position = len(mMsg.notetext) - 1 //첨부된 파일의 위치 지정
//   mMsg.attachmentFile[1] = mattach
//END IF
//
////MSes.mailResolveRecipient(mMsg.Recipient[1].name) // E-mail Address 를 얻는다 .
//mRet = mSes.mailSend(mMsg) // 메일 보내기 .
//IF mRet <> mailReturnSuccess! THEN
//   MessageBox('메일보내기 ', '메일보내기 ==> 실패 ')
//   RETURN 
//ELSE
//   MessageBox('메일보내기 ', '메일보내기 ==> 성공 ')
//end If
//
//
////********************************
//// 여러명을 같은 파일 보낼때... 
////********************************
////  mMsg.Subject = sle_subject.Text      // 메일 제목 지정 .
////  mMsg.NoteText = mle_body.Text        // 메일 내용 지정 .
////  for i = 1 to dw_list.rowcount()
////      if isnull(dw_list.object.email[i]) = false then
////         cc++
////         ls_address = dw_list.object.email[i]
////         mMsg.Recipient[cc].name = ls_address // 메일 받는사람의 주소
////     end if
////  next
////    
////           /******** 파일 첨부시 사용 한다 .************/
////IF ib_attach = True THEN
////   mattach.Filetype = mailattach!             // 파일첨부 하기위한 작업 .
////   mattach.PathName = sle_attach.Text         // 첨부할 파일이 있는 Full Path.
////   mattach.FileName = is_FileName             // 첨부할 파일의 이름 .
////   mattach.Position = len(mMsg.notetext) - 1  //첨부된 파일의 위치 지정
////   mMsg.attachmentFile[1] = mattach
////END IF
////
////
//////위의 for문에 의해서 등록된 mail주소로 일괄 전송됨니다.
////mRet = mSes.mailSend(mMsg) // 메일 보내기 
////  
////IF mRet <> mailReturnSuccess! THEN
////   MessageBox('email','메일전송에 실패하였습니다....')
////   RETURN 
////ELSE
////   MessageBox('email','메일을 전송하였습니다....')
////end If
////***************************** 혹시나 해서 남겨 둠..
//
//
//mSes.mailLogoff() // 메일 Session 끊기 .
//DESTROY mSes
//
//
////**** 첨부파일 찾기 버튼(cb_browse)의 Clicked 이벤트 *****
////String ls_FilePathName
////ib_attach = True
////GetFileOpenName("Select File", ls_FilePathName, s_filename, "DOC", "All Files (*.*),*.*")
////sle_attach.Text = ls_FilePathName // sle_attatch 는 윈도우위에 있는 싱글라 인에디터로 첨부할 파일을 경로를 보여준다 .
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
string facename = "굴림체"
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
string facename = "굴림체"
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
string facename = "굴림체"
string text = "전사원 급여 전송"
end type

event clicked;String  sYm,sSaup,ls_gubun,ls_empno,ls_deptcode , ls_mailad,ls_empname
string  NextStep
integer iRtnValue
long    i
decimal ld_pct_ind
//========================== Mail관련...
String ls_ym ,lsv_filename,lsv_ExeName,ls_FileName
mailSession mSes
mailReturnCode mRet
mailMessage mMsg
mailRecipient mRecip
mailFileDescription mattach
Boolean ib_attach = False
datawindow ldw_save
//==========================
mSes = create mailSession              // MailSession 오브젝트 생성 .
mRet = mSes.mailLogon(mailNewSession!) // 메일 Session 로그 -온 .

dw_ip.AcceptText()
dw_read.SetTransObject(SQLCA)

IF mRet <> mailReturnSuccess! THEN
   MessageBox("메일 Session", '로그 -온 실패 ')
   Return
END IF

sYm      = dw_ip.GetITemString(1,"l_ym")
sSaup    = dw_ip.GetITemString(1,"l_saup")
ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
		  
		 
IF sYm = "      " OR IsNull(sYm) THEN
	MessageBox("확 인","년월을 입력하세요!!")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sYm + '01') = -1 THEN
   MessageBox("확인","년월을 확인하세요")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 

IF ls_gubun = '' OR ISNULL(ls_gubun) THEN
	MessageBox("확 인","구분을 입력하세요!!")
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
/*************지급부분********************/
/*****************************************/

INSERT INTO "P3_TMP_PAY"	 
	         ("EMPNO",    "GUBUN",   "ALLOWCODE",   
             "ALLOWAMT", "PRINTSEQ")
				 
				 
SELECT p3_editdatachild.empno as empno,  /*수당*/
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
	
		 SELECT p3_editdatachild.empno as empno,   /*공제부분*/
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
	MessageBox("확 인","급여를 생성하지 않았습니다!!")
	Return -1
END IF
	
for i = 1 to dw_read.rowcount() 		
	ls_empno    = dw_read.GetITemString(i,"p3_editdata_empno")
	ls_empname  = dw_read.GetITemString(i,"p1_master_empname")
	ls_deptcode = dw_read.GetITemString(i,"p3_editdata_deptcode")
	ls_mailad   = dw_read.GetITemString(i,"p1_etc_email")
	
	if ls_mailad = '' or isnull(ls_mailad) then
		messagebox(ls_empno,ls_empname + '의 메일주소가 등록되지 않았습니다! 확인요망')
	else
		
		WF_SETTEXT()
		WF_SETTEXT2()
		dw_save.SetTransObject(SQLCA)
		dw_save.Retrieve(sSaup,sYm,ls_deptcode,ls_gubun,ls_Empno)
		
		// C:\erpman\pay 폴더 밑에 급여 사번(성명).html 저장...
		ldw_save = dw_save
		wf_save(ldw_save,i)
	
		//***** 메일 보내기 *****
		mMsg.Recipient[1].name = ls_mailad 	  // 메일 받는사람의 주소	
		ls_ym      = dw_ip.GetITemString(1,"l_ym")
		mMsg.Subject = left(ls_ym,4) + '년 ' + mid(ls_ym,5,2) + '월 급여명세서 입니다.'
		mMsg.NoteText = '한달 동안 고생 많으셨습니다.'
	   //***** 파일 첨부 *****			
		ls_empno   = dw_read.GetITemString(i,"p3_editdata_empno")
		ls_empname = dw_read.GetITemString(i,"p1_master_empname")
		lsv_FileName = ls_empno + '(' + ls_empname + ')'				
		lsv_ExeName = '.HTM'
		
		long llv_pos
		//파일의 확장자를 검사한다.		
		llv_pos = pos(lsv_FileName , ".")
		
		if llv_pos = 0 then
			ls_FileName = 'c:\erpman\pay\' + lsv_FileName + lsv_ExeName					
		end if
		
		mattach.Filetype = mailattach! // 파일 첨부 하기위한 작업 .
		mattach.PathName = ls_filename
		mattach.FileName = ls_filename
	   mattach.Position = len(mMsg.notetext) - 1 //첨부된 파일의 위치 지정
	   mMsg.attachmentFile[1] = mattach		

		mRet = mSes.mailSend(mMsg) // 메일 보내기 .

		IF mRet <> mailReturnSuccess! THEN
			MessageBox('메일보내기 ', lsv_FileName + ' 메일보내기 ==> 실패 ')
		end If

	end if	
	
	ld_pct_ind = ( i / dw_read.rowcount()) * 100
	st_rcvpct.width = ld_pct_ind / 100.0 * st_100.width
	st_rcvpct.visible = true	  		
next				

mSes.mailLogoff() // 메일 Session 끊기 .
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
string facename = "굴림체"
string text = "조건 설정 대상 전송"
end type

event clicked;String  sYm,sSaup,ls_gubun,ls_empno,ls_deptcode , ls_mailad,ls_empname,&
        lsv_Empno,sDeptcode
integer iRtnValue
long    i
decimal ld_pct_ind
//========================== Mail관련...
String ls_ym ,lsv_filename,lsv_ExeName,ls_FileName
mailSession mSes
mailReturnCode mRet
mailMessage mMsg
mailRecipient mRecip
mailFileDescription mattach
Boolean ib_attach = False
datawindow ldw_save
//==========================
mSes = create mailSession              // MailSession 오브젝트 생성 .
mRet = mSes.mailLogon(mailNewSession!) // 메일 Session 로그 -온 .

dw_ip.AcceptText()
dw_read2.SetTransObject(SQLCA)

IF mRet <> mailReturnSuccess! THEN
   MessageBox("메일 Session", '로그 -온 실패 ')
   Return
END IF

sYm      = dw_ip.GetITemString(1,"l_ym")
sSaup    = dw_ip.GetITemString(1,"l_saup")
ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
lsv_Empno = dw_ip.GetITemString(1,"l_empno")
sDeptcode  = dw_ip.GetITemString(1,"l_dept")  /*부서*/		  
		 
IF sYm = "      " OR IsNull(sYm) THEN
	MessageBox("확 인","년월을 입력하세요!!")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
ELSE
  IF f_datechk(sYm + '01') = -1 THEN
   MessageBox("확인","년월을 확인하세요")
	dw_ip.SetColumn("l_ym")
	dw_ip.SetFocus()
	Return -1
  END IF	
END IF 

IF ls_gubun = '' OR ISNULL(ls_gubun) THEN
	MessageBox("확 인","구분을 입력하세요!!")
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
	messagebox("조건설정대상을 선택하셨습니다.","부서 또는 사원번호를 선택하신 후 작업바랍니다.")
	return
end if

SetPointer(HourGlass!)

DELETE FROM "P3_TMP_PAY"
COMMIT ;


/*****************************************/
/*************지급부분********************/
/*****************************************/

INSERT INTO "P3_TMP_PAY"	 
	         ("EMPNO",    "GUBUN",   "ALLOWCODE",   
             "ALLOWAMT", "PRINTSEQ")
				 
				 
SELECT p3_editdatachild.empno as empno,  /*수당*/
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
	
		 SELECT p3_editdatachild.empno as empno,   /*공제부분*/
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
	MessageBox("확 인","급여를 생성하지 않았습니다!!")
	Return -1
END IF
	
for i = 1 to dw_read2.rowcount() 		
	ls_empno    = dw_read2.GetITemString(i,"p3_editdata_empno")
	ls_empname  = dw_read2.GetITemString(i,"p1_master_empname")
	ls_deptcode = dw_read2.GetITemString(i,"p3_editdata_deptcode")
	ls_mailad   = dw_read2.GetITemString(i,"p1_etc_email")
	
	if ls_mailad = '' or isnull(ls_mailad) then
		messagebox(ls_empno,ls_empname + '의 메일주소가 등록되지 않았습니다! 확인요망')
	else
		
		WF_SETTEXT()
		WF_SETTEXT2()
		dw_save.SetTransObject(SQLCA)
		dw_save.Retrieve(sSaup,sYm,ls_deptcode,ls_gubun,ls_Empno)
		
		// C:\erpman\pay 폴더 밑에 급여 사번(성명).html 저장...
		ldw_save = dw_save
		wf_save_per(ldw_save,i)
	
		//***** 메일 보내기 *****
		mMsg.Recipient[1].name = ls_mailad 	  // 메일 받는사람의 주소	
		mMsg.Recipient[1].address = ls_mailad
		ls_ym      = dw_ip.GetITemString(1,"l_ym")
		mMsg.Subject = left(ls_ym,4) + '년 ' + mid(ls_ym,5,2) + '월 급여명세서 입니다.'
//		mMsg.NoteText = '한달 동안 고생 많으셨습니다.'
	   //***** 파일 첨부 *****			
		ls_empno   = dw_read2.GetITemString(i,"p3_editdata_empno")
		ls_empname = dw_read2.GetITemString(i,"p1_master_empname")
		lsv_FileName = ls_empno + '(' + ls_empname + ')'				
		lsv_ExeName = '.HTM'
		
		long llv_pos
		//파일의 확장자를 검사한다.		
		llv_pos = pos(lsv_FileName , ".")
		
		if llv_pos = 0 then
			ls_FileName = 'c:\erpman\pay\' + lsv_FileName + lsv_ExeName					
		end if
		
		mattach.Filetype = mailattach! // 파일 첨부 하기위한 작업 .
		mattach.PathName = ls_filename
		mattach.FileName = ls_filename
	   mattach.Position = len(mMsg.notetext) - 1 //첨부된 파일의 위치 지정
	   mMsg.attachmentFile[1] = mattach		

		mRet = mSes.mailSend(mMsg) // 메일 보내기 .

		IF mRet <> mailReturnSuccess! THEN
			MessageBox('메일보내기 ', lsv_FileName + ' 메일보내기 ==> 실패 ')
		end If

	end if	
	
	ld_pct_ind = ( i / dw_read2.rowcount()) * 100
	st_rcvpct.width = ld_pct_ind / 100.0 * st_100.width
	st_rcvpct.visible = true	  		
next				

mSes.mailLogoff() // 메일 Session 끊기 .
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
string facename = "굴림체"
long backcolor = 32106727
string text = "전체"
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
string facename = "굴림체"
long backcolor = 32106727
string text = "조건설정대상"
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
string picturename = "C:\Erpman\image\메일전송_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\메일전송_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\메일전송_up.gif"
end event

event clicked;call super::clicked;st_100.Visible = true
st_rcvpct.Visible = true

IF rb_all.Checked = True THEN
	cb_all.TriggerEvent(Clicked!)
ELSE
	cb_per.TriggerEvent(Clicked!)
END IF
end event

