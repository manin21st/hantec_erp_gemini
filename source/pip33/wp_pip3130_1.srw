$PBExportHeader$wp_pip3130_1.srw
$PBExportComments$** 급여/상여 명세서(settext)
forward
global type wp_pip3130_1 from w_standard_print
end type
type dw_1 from datawindow within wp_pip3130_1
end type
type dw_2 from datawindow within wp_pip3130_1
end type
type dw_read from dw_list within wp_pip3130_1
end type
type cb_all from commandbutton within wp_pip3130_1
end type
type p_send from uo_picture within wp_pip3130_1
end type
type dw_save from dw_list within wp_pip3130_1
end type
type rr_1 from roundrectangle within wp_pip3130_1
end type
end forward

global type wp_pip3130_1 from w_standard_print
integer x = 0
integer y = 0
integer width = 4603
integer height = 2256
string title = "급여/상여 명세서"
dw_1 dw_1
dw_2 dw_2
dw_read dw_read
cb_all cb_all
p_send p_send
dw_save dw_save
rr_1 rr_1
end type
global wp_pip3130_1 wp_pip3130_1

type variables

end variables

forward prototypes
public function integer wf_settext2 ()
public function integer wf_psettext ()
public function integer wf_psettext2 ()
public function integer wf_settext ()
public function integer wf_retrieve ()
public subroutine wf_save (datawindow pdw_file, long i)
public function integer wf_esettext ()
public function integer wf_esettext2 ()
public subroutine wf_save_per (datawindow pdw_file, long i)
end prototypes

public function integer wf_settext2 (); String sName
 Long K,ToTalRow
 
 dw_2.Reset()
 dw_2.Retrieve()
 ToTalRow = dw_2.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_2.GetItemString(K,"allowname")
   dw_list.modify("text200.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text201.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text202.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text203.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text204.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text205.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text206.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text207.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text208.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text209.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text210.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text211.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text212.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text213.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_list.modify("text214.text = '"+sName+"'")
 
// dw_list.SetTransObject(SQLCA)
 
Return 1
end function

public function integer wf_psettext (); String sName
 Long K,ToTalRow
 
 dw_1.Reset()
 dw_1.Retrieve()
 ToTalRow = dw_1.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_1.GetItemString(K,"allowname")
   dw_print.modify("text100.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text101.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text102.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text103.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text104.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text105.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text106.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text107.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text108.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text109.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text110.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text111.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text112.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text113.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text114.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text115.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text116.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text117.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text118.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text119.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_print.modify("text120.text = '"+sName+"'")
 
 
 //dw_print.SetTransObject(SQLCA)
 
Return 1
end function

public function integer wf_psettext2 (); String sName
 Long K,ToTalRow
 
 dw_2.Reset()
 dw_2.Retrieve()
 ToTalRow = dw_2.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_2.GetItemString(K,"allowname")
   dw_print.modify("text200.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text201.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text202.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text203.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text204.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text205.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text206.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text207.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text208.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text209.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text210.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text211.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text212.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text213.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_print.modify("text214.text = '"+sName+"'")
 
// dw_print.SetTransObject(SQLCA)
 
Return 1
end function

public function integer wf_settext (); String sName
 Long K,ToTalRow
 
 dw_1.Reset()
 dw_1.Retrieve()
 ToTalRow = dw_1.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_1.GetItemString(K,"allowname")
   dw_list.modify("text100.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text101.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text102.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text103.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text104.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text105.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text106.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text107.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text108.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text109.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text110.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text111.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text112.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text113.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text114.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text115.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text116.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text117.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text118.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text119.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_list.modify("text120.text = '"+sName+"'")
 
// dw_list.SetTransObject(SQLCA)
 
Return 1
end function

public function integer wf_retrieve ();String sYm,sSaup,ls_gubun,ls_Empno,sDeptcode,sJikjong,sKunmu, ls_bigo
integer iRtnValue
dw_ip.AcceptText()

sYm      = dw_ip.GetITemString(1,"l_ym")
sSaup    = dw_ip.GetITemString(1,"l_saup")
ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
ls_Empno = dw_ip.GetITemString(1,"l_empno")
sDeptcode  = dw_ip.GetITemString(1,"l_dept")  /*부서*/
sJikjong = trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu = trim(dw_ip.GetItemString(1,"kunmu"))
ls_bigo = dw_ip.GetItemString(1,"bigo")


IF sJikjong = '' OR IsNull(sJikjong) THEN sJikjong = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
		 
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

SetPointer(HourGlass!)
dw_list.Setredraw(false)

DELETE FROM "P3_TMP_PAY"
COMMIT ;
		
INSERT INTO "P3_TMP_PAY"
				("EMPNO",    "GUBUN",   "ALLOWCODE",
				 "ALLOWAMT", "PRINTSEQ")		
 
	 SELECT p3_editdatachild.empno as empno,  /*수당*/
				 '1' AS GUBUN,
				 p3_tallowance.tallowcode,
				 sum( decode(p1_master.paygubn,'3', decode(p3_editdatachild.allowcode,'13',p3_editdatachild.allowamt,'12', p3_editdatachild.allowamt, '07', p3_editdatachild.allowamt, 0), p3_editdatachild.allowamt)) as amt,
				 p3_tallowance.printseq
		  FROM p3_editdatachild,P3_ALLOWANCE, p3_tallowance, p1_master
		 WHERE p3_editdatachild.empno = p1_master.empno and
		       p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
             p3_allowance.tallowcode = p3_tallowance.tallowcode and
             p3_allowance.paysubtag = p3_tallowance.gubun and
				 p3_editdatachild.companycode = :gs_company AND 
				 p3_editdatachild.workym     = :sYm AND
				 p3_editdatachild.pbtag     = :ls_gubun and 
		 		 p3_editdatachild.empno  like :ls_Empno and 
				 P3_ALLOWANCE.paysubtag     = '1' 
	  group by 	p3_editdatachild.empno,
				 p3_tallowance.tallowcode,	
				 p3_tallowance.printseq
		
		UNION ALL 
	
		 SELECT p3_editdatachild.empno as empno,  /*공제부문*/
				 '2' AS GUBUN,
				 p3_tallowance.tallowcode,
				 sum(p3_editdatachild.allowamt) as amt,
				 p3_tallowance.printseq
		  FROM p3_editdatachild,P3_ALLOWANCE, p3_tallowance, p1_master
		 WHERE p3_editdatachild.empno = p1_master.empno and
		       p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
				 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
             p3_allowance.tallowcode = p3_tallowance.tallowcode and
             p3_allowance.paysubtag = p3_tallowance.gubun and
				 p3_editdatachild.companycode = :gs_company AND 
				 p3_editdatachild.workym     = :sYm AND
				 p3_editdatachild.pbtag     = :ls_gubun and  
				 p3_editdatachild.empno  like :ls_Empno and 
				 P3_ALLOWANCE.paysubtag     = '2' 
 group by 	p3_editdatachild.empno,
				 p3_tallowance.tallowcode,	
				 p3_tallowance.printseq		 ;		
		 
IF SQLCA.SQLCODE = 0 THEN
	COMMIT ;
ELSE
	ROLLBACK ;
END IF

//WF_SETTEXT()
//WF_SETTEXT2()
//WF_PSETTEXT()
//WF_PSETTEXT2()

IF dw_PRINT.Retrieve(sSaup,sYm,sDeptcode,ls_gubun,ls_Empno,sJikjong,sKunmu,  ls_bigo) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	dw_list.insertrow(0)
END IF
	
dw_list.object.datawindow.print.preview = "yes"
dw_list.Setredraw(true)
SetPointer(Arrow!)
dw_print.Modify("t_bigo1.text = '" + ls_bigo + "' ")
dw_list.Modify("t_bigo1.text = '" + ls_bigo + "' ")
dw_print.Modify("t_bigo2.text = '" + ls_bigo + "' ")
dw_list.Modify("t_bigo2.text = '" + ls_bigo + "' ")

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

public function integer wf_esettext (); String sName
 Long K,ToTalRow
 
 dw_1.Reset()
 dw_1.Retrieve()
 ToTalRow = dw_1.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_1.GetItemString(K,"allowname")
   dw_save.modify("text100.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text101.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text102.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text103.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text104.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text105.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text106.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text107.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text108.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text109.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text110.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text111.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text112.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text113.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text114.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text115.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text116.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text117.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text118.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text119.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"allowname")
 dw_save.modify("text120.text = '"+sName+"'")
 
// dw_save.SetTransObject(SQLCA)
 
Return 1
end function

public function integer wf_esettext2 (); String sName
 Long K,ToTalRow
 
 dw_2.Reset()
 dw_2.Retrieve()
 ToTalRow = dw_2.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_2.GetItemString(K,"allowname")
   dw_save.modify("text200.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text201.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text202.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text203.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text204.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text205.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text206.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text207.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text208.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text209.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text210.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text211.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text212.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text213.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"allowname")
 dw_save.modify("text214.text = '"+sName+"'")
 
// dw_save.SetTransObject(SQLCA)
 
Return 1
end function

public subroutine wf_save_per (datawindow pdw_file, long i);/*1F===================================================
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
//lsv_FileName = 'payment'

lsv_ExeName = '.html'
//lsv_ExeName = '.psr'

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
//llv_Ret = pdw_File.SaveAs('c:\erpman\pay\'+lsv_FileName, PSReport!, TRUE)			 	 
//
//IF llv_Ret = 1 THEN
//	MessageBox('도움말', lsv_FileName + " 저장되었습니다.")
//END IF
end subroutine

on wp_pip3130_1.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_read=create dw_read
this.cb_all=create cb_all
this.p_send=create p_send
this.dw_save=create dw_save
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_read
this.Control[iCurrent+4]=this.cb_all
this.Control[iCurrent+5]=this.p_send
this.Control[iCurrent+6]=this.dw_save
this.Control[iCurrent+7]=this.rr_1
end on

on wp_pip3130_1.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_read)
destroy(this.cb_all)
destroy(this.p_send)
destroy(this.dw_save)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

dw_ip.SetITem(1,"l_ym",f_aftermonth(left(f_today(),6),-1))
dw_ip.SetITem(1,"l_gubn",'P')
dw_list.insertrow(0)

f_set_saupcd(dw_ip, 'l_saup', '1')
is_saupcd = gs_saupcd

dw_ip.SetItem(1, "bigo", "개인임금을 타직원과 공유시 징계조치됩니다.")



end event

type p_xls from w_standard_print`p_xls within wp_pip3130_1
end type

type p_sort from w_standard_print`p_sort within wp_pip3130_1
end type

type p_preview from w_standard_print`p_preview within wp_pip3130_1
integer x = 4027
end type

event p_preview::clicked;//String sYm,sSaup,ls_gubun,ls_Empno,sDeptcode
//integer iRtnValue
//dw_ip.AcceptText()
//
//sYm      = dw_ip.GetITemString(1,"l_ym")
//sSaup    = dw_ip.GetITemString(1,"l_saup")
//ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
//ls_Empno = dw_ip.GetITemString(1,"l_empno")
//sDeptcode  = dw_ip.GetITemString(1,"l_dept")  /*부서*/
//			  
//
//IF sSaup = '' OR ISNULL(sSaup) THEN
//	sSaup = '%'	
//END IF	
//
//IF ls_Empno = '' OR ISNULL(ls_Empno) THEN
//	ls_Empno = '%'
//END IF	
//
//IF sDeptcode = '' OR ISNULL(sDeptcode) THEN
//	sDeptcode = '%'
//END IF

WF_PSETTEXT()
WF_PSETTEXT2()

//dw_print.Retrieve(sSaup,sYm,sDeptcode,ls_gubun,ls_Empno)
OpenWithParm(w_print_preview, dw_print)
end event

type p_exit from w_standard_print`p_exit within wp_pip3130_1
integer x = 4375
end type

type p_print from w_standard_print`p_print within wp_pip3130_1
integer x = 4201
end type

event p_print::clicked;//String sYm,sSaup,ls_gubun,ls_Empno,sDeptcode
//integer iRtnValue
//dw_ip.AcceptText()
//
//sYm      = dw_ip.GetITemString(1,"l_ym")
//sSaup    = dw_ip.GetITemString(1,"l_saup")
//ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
//ls_Empno = dw_ip.GetITemString(1,"l_empno")
//sDeptcode  = dw_ip.GetITemString(1,"l_dept")  /*부서*/
//			  
//
//IF sSaup = '' OR ISNULL(sSaup) THEN
//	sSaup = '%'	
//END IF	
//
//IF ls_Empno = '' OR ISNULL(ls_Empno) THEN
//	ls_Empno = '%'
//END IF	
//
//IF sDeptcode = '' OR ISNULL(sDeptcode) THEN
//	sDeptcode = '%'
//END IF	

WF_PSETTEXT()
WF_PSETTEXT2()

//dw_print.Retrieve(sSaup,sYm,sDeptcode,ls_gubun,ls_Empno)
IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within wp_pip3130_1
integer x = 3854
end type

type st_window from w_standard_print`st_window within wp_pip3130_1
integer x = 2336
integer y = 2584
end type

type sle_msg from w_standard_print`sle_msg within wp_pip3130_1
integer x = 361
integer y = 2584
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip3130_1
integer x = 2830
integer y = 2584
end type

type st_10 from w_standard_print`st_10 within wp_pip3130_1
integer x = 0
integer y = 2584
end type



type dw_print from w_standard_print`dw_print within wp_pip3130_1
integer x = 3415
integer y = 208
string dataobject = "dp_pip3130_1_20_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip3130_1
integer x = 96
integer y = 40
integer width = 3241
integer height = 408
string dataobject = "dp_pip3130_1_10"
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
SetNull(Gs_Gubun)

Gs_Gubun = is_saupcd
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

type dw_list from w_standard_print`dw_list within wp_pip3130_1
integer x = 119
integer y = 472
integer width = 4274
integer height = 1608
string dataobject = "dp_pip3130_1_20_p1"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::rowfocuschanged;//override
end event

event dw_list::clicked;//override
end event

type dw_1 from datawindow within wp_pip3130_1
boolean visible = false
integer x = 151
integer y = 2208
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(지급)"
string dataobject = "dp_pip3110_30"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within wp_pip3130_1
boolean visible = false
integer x = 1504
integer y = 2544
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(공제)"
string dataobject = "dp_pip3110_40"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_read from dw_list within wp_pip3130_1
boolean visible = false
integer x = 1051
integer y = 2104
integer width = 1920
integer height = 588
boolean bringtotop = true
string dataobject = "dp_pip3140_read"
boolean hsplitscroll = true
end type

type cb_all from commandbutton within wp_pip3130_1
boolean visible = false
integer x = 2971
integer y = 2416
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
string text = "전사원 급여 전송"
end type

event clicked;string ls_progubun, ls_pbtag

dw_ip.accepttext()  

IF Messagebox ("작업 확인", "메일을 발송하시겠습니까?",Question!,YesNo!) = 2 THEN Return
 

 
select dataname 
into :ls_progubun
from p0_syscnfg
where serial = 80 and lineno = '3';

		String  sYm,sSaup,ls_gubun,ls_empno,ls_deptcode , ls_mailad,ls_empname
		string  NextStep, ls_jikjong, ls_kunmu, ls_dept, ls_reademp, ls_bigo
		string lsv_Empno,sDeptcode,read_empno
		integer iRtnValue
		long    i
		decimal ld_pct_ind
		//========================== Mail관련...
		String ls_ym ,lsv_filename,lsv_ExeName,ls_FileName, ls_FileName2
		mailSession mSes
		mailReturnCode mRet
		mailMessage mMsg
		mailRecipient mRecip
		mailFileDescription mattach
		mailFileDescription mattach2
		Boolean ib_attach = False
		datawindow ldw_save 
		//==========================
		OLEObject	smtp
		Integer		iRet
		String  smailaddress, smailid
		String  scomname
		long llv_pos
		
		
		ls_bigo = dw_ip.GetItemString(1, "bigo")
		
		update p0_syscnfg
		set dataname = :ls_bigo
		where serial = '80' and lineno = '4' ;
		commit;
				
if ls_progubun = '1' then		/*기존대로 접속*/
		

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
		ls_jikjong = dw_ip.GetItemString(1,"jikjong")
		ls_kunmu = dw_ip.GetItemString(1,"kunmu")
		ls_dept = dw_ip.GetItemString(1,"l_dept")
		ls_reademp = dw_ip.GetItemString(1,"l_empno")
		ls_bigo = dw_ip.GetItemString(1, "bigo")
		
		
		if ls_jikjong = '' or isnull(ls_jikjong) then ls_jikjong = '%'
		if ls_kunmu = '' or isnull(ls_kunmu) then ls_kunmu = '%'
		if ls_dept = '' or isnull(ls_dept) then ls_dept = '%'
		if ls_reademp = '' or isnull(ls_reademp) then ls_reademp = '%'
				  
				 
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
						 decode(p1_master.paygubn,'3', decode(p3_editdatachild.allowcode,'13', p3_editdatachild.allowamt, '12', p3_editdatachild.allowamt, '07', p3_editdatachild.allowamt,  '17', p3_editdatachild.allowamt, 0), p3_editdatachild.allowamt) as amt,
						/* p3_editdatachild.allowamt as amt,*/
						 P3_ALLOWANCE.PRINTSEQ
				  FROM p3_editdatachild,P3_ALLOWANCE, p1_etc, p1_master 
				 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
						 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
						 p3_editdatachild.companycode =:gs_company AND 
						 p3_editdatachild.workym     =:sYm AND
						 p3_editdatachild.pbtag     =:ls_gubun and  
						 P3_ALLOWANCE.paysubtag     = '1' and
						 p3_editdatachild.empno = p1_etc.empno(+) and
						 p3_editdatachild.empno = p1_master.empno and
						 p1_etc.mailgubn = 'Y'
				
				UNION ALL 
			
				 SELECT p3_editdatachild.empno as empno,   /*공제부분*/
						 '2' AS GUBUN,
						 p3_editdatachild.allowcode,
						 p3_editdatachild.allowamt as amt,
						 P3_ALLOWANCE.PRINTSEQ
				  FROM p3_editdatachild,P3_ALLOWANCE, p1_etc
				 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
						 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
						 p3_editdatachild.companycode =:gs_company AND 
						 p3_editdatachild.workym     =:sYm AND
						 p3_editdatachild.pbtag     =:ls_gubun and  
						 P3_ALLOWANCE.paysubtag     = '2' and
						 p3_editdatachild.empno = p1_etc.empno(+) and
						 p1_etc.mailgubn = 'Y';
		IF SQLCA.SQLCODE = 0 THEN
			COMMIT ;
		ELSE
			ROLLBACK ;	
		END IF	
		
		IF dw_read.Retrieve(sSaup,sYm,ls_gubun, ls_jikjong, ls_kunmu, ls_dept, ls_reademp) <=0 THEN
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
				
				WF_ESETTEXT()
				WF_ESETTEXT2()
				dw_save.SetTransObject(SQLCA)
				dw_save.Retrieve(sSaup,sYm,ls_deptcode,ls_gubun,ls_Empno, ls_bigo)
				
				// C:\erpman\pay 폴더 밑에 급여 사번(성명).html 저장...
				ldw_save = dw_save
				wf_save(ldw_save,i)
			
				//***** 메일 보내기 *****
				mMsg.Recipient[1].name = ls_mailad 	  // 메일 받는사람의 주소	
				
				
				ls_ym      = dw_ip.GetITemString(1,"l_ym")
				
				
				ls_pbtag = dw_ip.GetItemString(1, "l_gubn")
				if ls_pbtag = 'P' then
					mMsg.Subject = left(ls_ym,4) + '년 ' + mid(ls_ym,5,2) + '월 급여명세서 입니다.'
				else
					mMsg.Subject = left(ls_ym,4) + '년 ' + mid(ls_ym,5,2) + '월 상여명세서 입니다.'
				end if

				
				
				mMsg.NoteText = '한달 동안 고생 많으셨습니다.'
				//***** 파일 첨부 *****			
				ls_empno   = dw_read.GetITemString(i,"p3_editdata_empno")
				ls_empname = dw_read.GetITemString(i,"p1_master_empname")
				lsv_FileName = ls_empno + '(' + ls_empname + ')'				
				lsv_ExeName = '.HTM'
				

				//파일의 확장자를 검사한다.		
				llv_pos = pos(lsv_FileName , ".")
				
				if llv_pos = 0 then
					ls_FileName = 'c:\erpman\pay\' + lsv_FileName + lsv_ExeName					
				end if	
				
				mattach.Filetype = mailattach! // 파일 첨부 하기위한 작업 .
				mattach.PathName = ls_filename
				mattach.FileName = ls_filename
				mattach.Position = lena(mMsg.notetext) - 1 //첨부된 파일의 위치 지정
				mMsg.attachmentFile[1] = mattach		
		
				mRet = mSes.mailSend(mMsg) // 메일 보내기 .
		
				IF mRet <> mailReturnSuccess! THEN
					MessageBox('메일보내기 ', lsv_FileName + ' 메일보내기 ==> 실패 ')
				end If
		
			end if	
			
			ld_pct_ind = ( i / dw_read.rowcount()) * 100
		//	st_rcvpct.width = ld_pct_ind / 100.0 * st_100.width
		//	st_rcvpct.visible = true	  		
		next				
		
		mSes.mailLogoff() // 메일 Session 끊기 .
		DESTROY mSes
		
		SetPointer(Arrow!)
		
		
elseif ls_progubun = '2' then		/*신규방식으로 접속*/
	

		
		
		
		dw_ip.AcceptText()
		dw_read.SetTransObject(SQLCA)
		
		sYm      = dw_ip.GetITemString(1,"l_ym")
		sSaup    = dw_ip.GetITemString(1,"l_saup")
		ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
		ls_jikjong = dw_ip.GetItemString(1,"jikjong")
		ls_kunmu = dw_ip.GetItemString(1,"kunmu")
		ls_dept = dw_ip.GetItemString(1,"l_dept")
		ls_reademp = dw_ip.GetItemString(1,"l_empno")
		ls_bigo = dw_ip.GetItemString(1, "bigo")
		
		
		if ls_jikjong = '' or isnull(ls_jikjong) then ls_jikjong = '%'
		if ls_kunmu = '' or isnull(ls_kunmu) then ls_kunmu = '%'
		if ls_dept = '' or isnull(ls_dept) then ls_dept = '%'
		if ls_reademp = '' or isnull(ls_reademp) then ls_reademp = '%'
				  
				 
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
				  FROM p3_editdatachild,P3_ALLOWANCE, p3_personal
				 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
						 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
						 p3_editdatachild.companycode =:gs_company AND 
						 p3_editdatachild.workym     =:sYm AND
						 p3_editdatachild.pbtag     =:ls_gubun and  
						 P3_ALLOWANCE.paysubtag     = '1' and
						 p3_editdatachild.empno = p3_personal.empno and
						 p3_personal.mailgubn = 'Y'
				
				UNION ALL 
			
				 SELECT p3_editdatachild.empno as empno,   /*공제부분*/
						 '2' AS GUBUN,
						 p3_editdatachild.allowcode,
						 p3_editdatachild.allowamt as amt,
						 P3_ALLOWANCE.PRINTSEQ
				  FROM p3_editdatachild,P3_ALLOWANCE, p3_personal
				 WHERE p3_editdatachild.allowcode = P3_ALLOWANCE.allowcode AND
						 p3_editdatachild.gubun     = P3_ALLOWANCE.PAYSUBTAG AND
						 p3_editdatachild.companycode =:gs_company AND 
						 p3_editdatachild.workym     =:sYm AND
						 p3_editdatachild.pbtag     =:ls_gubun and  
						 P3_ALLOWANCE.paysubtag     = '2' and
						 p3_editdatachild.empno = p3_personal.empno and
						 p3_personal.mailgubn = 'Y' ;
		IF SQLCA.SQLCODE = 0 THEN
			COMMIT ;
		ELSE
			ROLLBACK ;	
		END IF	
		
		
		IF dw_read.Retrieve(sSaup,sYm,ls_gubun, ls_jikjong, ls_kunmu, ls_dept, ls_reademp) <=0 THEN
			MessageBox("확 인","급여를 생성하지 않았습니다!!")
			Return -1
		END IF
		
		If Not DirectoryExists ( 'c:\erpman\pay\' ) Then			/*급여파일(HTM) 저장 폴더가 없으면 새로 생성*/
			CreateDirectory ( 'c:\erpman\pay\' )
		End If
		
		select max(decode(lineno,'1', dataname)), max(decode(lineno,'2', dataname))
		into :smailaddress, :smailid
		from p0_syscnfg  
		where serial = 80; 

		
		if IsNull(is_saupcd) or is_saupcd = '%' then is_saupcd = '10'
		
		select  jurname into :scomname
		from p0_saupcd
		where saupcode = :is_saupcd;
		
		
		ls_ym      = dw_ip.GetITemString(1,"l_ym")


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
				WF_ESETTEXT()
				WF_ESETTEXT2()
				dw_save.SetTransObject(SQLCA)
				dw_save.Retrieve(sSaup,sYm,ls_deptcode,ls_gubun,ls_Empno, ls_bigo)
				
				// C:\erpman\pay 폴더 밑에 급여 사번(성명).html 저장...
				ldw_save = dw_save
				wf_save_per(ldw_save,i)
				
				
				smtp = CREATE OLEObject
				iRet = smtp.ConnectToNewObject ( "SoftArtisans.SMTPMail" )
				
				IF iRet <> 0 THEN
					MessageBox ( "ConnectToNewObject Error", iRet )
					return
				ENd IF
			
				//***** 메일 보내기 *****
				smtp.RemoteHost 		=  smailaddress	  // SMTP MAIL SERVER ADDRESS (or  IP)
				smtp.CustomCharSet 	= "ks_c_5601-1987"  // 한글은 ks_c_5601-1987 이다 ...  특별히 지정을 하지 않으면 US-ASCII or ISO-8859-1
				smtp.ContentType 	   = "text/html"		  // mailer.ContentType = "text/html"
				smtp.FromName 		   = scomname		     // 보내는 사람의 이름을 적는곳.
				smtp.FromAddress 	   = smailid           // 보내는 사람의 메일 Address를 적는곳.
				smtp.ReplyTo 			= smailid           // 답장을 받을 곳의 메일을 적는곳. 
				
				smtp.AddRecipient ( ls_empname, ls_mailad )    // OBJECT.AddRecipient ([in] Name as String, E-mail as String)  
				
				//smtp.Subject = left(ls_ym,4) + '년 ' + mid(ls_ym,5,2) + '월 급여명세서 입니다.'      // 제목		 
				smtp.Subject = '급여명세서 메일전송 테스트 중입니다..BDS'
				smtp.Live = TRUE
				smtp.HtmlText = "한달 동안 수고하셨습니다!!"                            // 본문
			
			
				//***** 파일 첨부 *****			
				ls_empno   = dw_read.GetITemString(i,"p3_editdata_empno")
				ls_empname = dw_read.GetITemString(i,"p1_master_empname")
				lsv_FileName = ls_empno + '(' + ls_empname + ')'	
				//lsv_FileName = 'payment'	
				lsv_ExeName = '.html'
				

				//파일의 확장자를 검사한다.		
				llv_pos = pos(lsv_FileName , ".") 
				
				if llv_pos = 0 then
					ls_FileName = 'c:\erpman\pay\' + lsv_FileName + lsv_ExeName					
				end if
				
				smtp.AddAttachment(ls_FileName)	
				IF smtp.SendMail = TRUE THEN
				//	smtp.ClearBCCs								   // 숨은 참조 Clear
		//			MessageBox ( "Mail", "OK" )
				ELSE
					MessageBox ( "Mail", "FAIL" )
				END IF
				
				
			end if	
			ls_FileName = ""
			
			ld_pct_ind = ( i / dw_read.rowcount()) * 100
		//	st_rcvpct.width = ld_pct_ind / 100.0 * st_100.width
		//	st_rcvpct.visible = true	  		
		next		
		
		
		SetPointer(Arrow!)	
		
		messagebox("확인","메일이 전송되었습니다.")
end if		
	

end event

type p_send from uo_picture within wp_pip3130_1
integer x = 3561
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\Erpman\image\메일전송_up.gif"
end type

event clicked;call super::clicked;cb_all.TriggerEvent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\메일전송_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\메일전송_up.gif"
end event

type dw_save from dw_list within wp_pip3130_1
boolean visible = false
integer x = 3630
integer y = 2428
integer width = 151
integer height = 132
integer taborder = 20
boolean bringtotop = true
string dataobject = "dp_pip3140_mail2"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

type rr_1 from roundrectangle within wp_pip3130_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 110
integer y = 456
integer width = 4306
integer height = 1636
integer cornerheight = 40
integer cornerwidth = 55
end type

