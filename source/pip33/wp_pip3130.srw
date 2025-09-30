$PBExportHeader$wp_pip3130.srw
$PBExportComments$** 급여/상여 명세서
forward
global type wp_pip3130 from w_standard_print
end type
type dw_1 from datawindow within wp_pip3130
end type
type dw_2 from datawindow within wp_pip3130
end type
type rr_1 from roundrectangle within wp_pip3130
end type
end forward

global type wp_pip3130 from w_standard_print
integer x = 0
integer y = 0
string title = "급여/상여 명세서"
dw_1 dw_1
dw_2 dw_2
rr_1 rr_1
end type
global wp_pip3130 wp_pip3130

type variables

end variables

forward prototypes
public function integer wf_settext2 ()
public function integer wf_psettext ()
public function integer wf_psettext2 ()
public function integer wf_settext ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_settext2 ();String sName
 Long K,ToTalRow
 
 dw_2.Reset()
 dw_2.Retrieve()
 ToTalRow = dw_2.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_2.GetItemString(K,"p3_allowance_allowname")
   dw_list.modify("text200.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text201.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text202.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text203.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text204.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text205.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text206.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text207.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text208.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text209.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text210.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text211.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text212.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text213.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text214.text = '"+sName+"'")
 
 
 
Return 1
end function

public function integer wf_psettext (); String sName
 Long K,ToTalRow
 
 dw_1.Reset()
 dw_1.Retrieve()
 ToTalRow = dw_1.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_1.GetItemString(K,"p3_allowance_allowname")
   dw_print.modify("text100.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text101.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text102.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text103.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text104.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text105.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text106.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text107.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text108.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text109.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text110.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text111.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text112.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text113.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text114.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text115.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text116.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text117.text = '"+sName+"'")
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text118.text = '"+sName+"'")
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text119.text = '"+sName+"'")
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text120.text = '"+sName+"'")
 
 
 
Return 1
end function

public function integer wf_psettext2 ();String sName
 Long K,ToTalRow
 
 dw_2.Reset()
 dw_2.Retrieve()
 ToTalRow = dw_2.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_2.GetItemString(K,"p3_allowance_allowname")
   dw_print.modify("text200.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text201.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text202.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text203.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text204.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text205.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text206.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text207.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text208.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text209.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text210.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text211.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text212.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text213.text = '"+sName+"'")
  K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_2.GetItemString(K,"p3_allowance_allowname")
 dw_print.modify("text214.text = '"+sName+"'")
 
 
 
Return 1
end function

public function integer wf_settext (); String sName
 Long K,ToTalRow
 
 dw_1.Reset()
 dw_1.Retrieve()
 ToTalRow = dw_1.RowCount()
 
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
   sName = dw_1.GetItemString(K,"p3_allowance_allowname")
   dw_list.modify("text100.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text101.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text102.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text103.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text104.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text105.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text106.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text107.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text108.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text109.text = '"+sName+"'")
 K = K + 1
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text110.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text111.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text112.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text113.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text114.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text115.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text116.text = '"+sName+"'")
  K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text117.text = '"+sName+"'")
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text118.text = '"+sName+"'")
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text119.text = '"+sName+"'")
 K = K + 1 
 IF K > ToTalRow THEN RETURN -1
 sName = dw_1.GetItemString(K,"p3_allowance_allowname")
 dw_list.modify("text120.text = '"+sName+"'")
 
 
 
Return 1
end function

public function integer wf_retrieve ();String sYm,sSaup,ls_gubun,ls_Empno,sDeptcode,sJikjong,sKunmu
integer iRtnValue
dw_ip.AcceptText()

sYm      = dw_ip.GetITemString(1,"l_ym")
sSaup    = dw_ip.GetITemString(1,"l_saup")
ls_gubun = dw_ip.GetITemString(1,"l_gubn")     /*급여,상여구분*/
ls_Empno = dw_ip.GetITemString(1,"l_empno")
sDeptcode  = dw_ip.GetITemString(1,"l_dept")  /*부서*/
sJikjong = trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu = trim(dw_ip.GetItemString(1,"kunmu"))

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
		 p3_editdatachild.allowcode,
		 p3_editdatachild.allowamt as amt,
		 P3_ALLOWANCE.PRINTSEQ
  FROM p3_editdatachild,p3_allowance
 WHERE p3_editdatachild.allowcode = p3_allowance.allowcode AND
		 p3_editdatachild.gubun     = p3_allowance.PAYSUBTAG AND
		 p3_editdatachild.companycode =:gs_company AND 
		 p3_editdatachild.workym    = :sYm AND
		 p3_editdatachild.pbtag     = :ls_gubun and 
		 p3_editdatachild.empno  like :ls_Empno and
		 p3_allowance.paysubtag     = '1'

UNION ALL 

 SELECT p3_editdatachild.empno as empno,   /*공제부분*/
		 '2' AS GUBUN,
		 p3_editdatachild.allowcode,
		 p3_editdatachild.allowamt as amt,
		 p3_allowance.PRINTSEQ
  FROM p3_editdatachild,p3_allowance
 WHERE p3_editdatachild.allowcode = p3_allowance.allowcode AND
		 p3_editdatachild.gubun     = p3_allowance.PAYSUBTAG AND
		 p3_editdatachild.companycode =:gs_company AND 
		 p3_editdatachild.workym    = :sYm AND
		 p3_editdatachild.pbtag     = :ls_gubun and 
		 p3_editdatachild.empno  like :ls_Empno and 
		 p3_allowance.paysubtag     = '2'  ;
		 
IF SQLCA.SQLCODE = 0 THEN
	COMMIT ;
ELSE
	ROLLBACK ;
END IF

IF dw_list.Retrieve(sSaup,sYm,sDeptcode,ls_gubun,ls_Empno,sJikjong,sKunmu) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	dw_list.insertrow(0)
END IF

dw_list.Setredraw(true)
SetPointer(Arrow!)
Return 1
end function

on wp_pip3130.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.rr_1
end on

on wp_pip3130.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_print.ShareDataOff()

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

dw_ip.SetITem(1,"l_ym",String(gs_today,'@@@@@@'))
dw_ip.SetITem(1,"l_gubn",'P')

f_set_saupcd(dw_ip, 'l_saup', '1')
is_saupcd = gs_saupcd

dw_list.object.datawindow.print.preview = "yes"	
dw_list.insertrow(0)
end event

type p_xls from w_standard_print`p_xls within wp_pip3130
end type

type p_sort from w_standard_print`p_sort within wp_pip3130
end type

type p_preview from w_standard_print`p_preview within wp_pip3130
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

//WF_PSETTEXT()
//WF_PSETTEXT2()

//dw_print.Retrieve(sSaup,sYm,sDeptcode,ls_gubun,ls_Empno)
dw_list.accepttext()

OpenWithParm(w_print_preview, dw_list)
end event

type p_exit from w_standard_print`p_exit within wp_pip3130
integer x = 4375
end type

type p_print from w_standard_print`p_print within wp_pip3130
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

//WF_PSETTEXT()
//WF_PSETTEXT2()

//dw_list.Retrieve(sSaup,sYm,sDeptcode,ls_gubun,ls_Empno)
dw_list.accepttext()

IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)
end event

type p_retrieve from w_standard_print`p_retrieve within wp_pip3130
integer x = 3854
end type

type st_window from w_standard_print`st_window within wp_pip3130
boolean visible = false
integer x = 2336
integer y = 2584
end type

type sle_msg from w_standard_print`sle_msg within wp_pip3130
boolean visible = false
integer x = 361
integer y = 2584
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip3130
boolean visible = false
integer x = 2830
integer y = 2584
end type

type st_10 from w_standard_print`st_10 within wp_pip3130
boolean visible = false
integer x = 0
integer y = 2584
end type



type dw_print from w_standard_print`dw_print within wp_pip3130
integer x = 3689
string dataobject = "dp_pip3130_21_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip3130
integer x = 297
integer y = 40
integer width = 3241
integer height = 272
string dataobject = "dp_pip3130_10"
end type

event dw_ip::itemchanged;String sDeptno,sName,snull,sEmpNo,sEmpName, ls_Name

SetNull(snull)

This.AcceptText()

IF dw_ip.GetColumnName() = "l_saup" THEN
	is_saupcd = this.GetText()
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
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

IF GetColumnName() = "l_empname" then
  sEmpName = GetItemString(1,"l_empname")

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'l_empname',ls_name)
		 Setitem(1,'l_empno',ls_name)
		 return 2
    end if
	 Setitem(1,"l_empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"l_empname",ls_name)
	 return 2
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

type dw_list from w_standard_print`dw_list within wp_pip3130
integer x = 306
integer y = 344
integer width = 3717
integer height = 1948
string dataobject = "dp_pip3130_21_p"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::rowfocuschanged;//override
end event

event dw_list::clicked;//override
end event

type dw_1 from datawindow within wp_pip3130
boolean visible = false
integer x = 553
integer y = 2360
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(지급)"
string dataobject = "dp_pip3130_30"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within wp_pip3130
boolean visible = false
integer x = 1504
integer y = 2360
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(공제)"
string dataobject = "dp_pip3130_40"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within wp_pip3130
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 16777215
integer x = 297
integer y = 332
integer width = 3735
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

