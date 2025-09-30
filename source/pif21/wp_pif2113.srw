$PBExportHeader$wp_pif2113.srw
$PBExportComments$** 증명서발급대장
forward
global type wp_pif2113 from w_standard_print
end type
type rr_2 from roundrectangle within wp_pif2113
end type
end forward

global type wp_pif2113 from w_standard_print
integer height = 2488
string title = "증명서발급대장"
rr_2 rr_2
end type
global wp_pif2113 wp_pif2113

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String empno1,empno2, sSaupcd
String sDate1,sDate2

dw_ip.AcceptText()
sDate1 = dw_ip.GetItemString(1,"dayfrom")
sDate2 = dw_ip.GetItemString(1,"dayto")
sSaupcd = dw_ip.GetItemString(1,"saupcd")

IF sDate1 = '00000000' AND  sDate2 <> '00000000' THEN
	MessageBox("확인","발급일자를 입력하세요!")
	Return -1
END IF

IF sDate1 <> '00000000' AND sDate2 <> '00000000' THEN
	IF sDate1 > sDate2 THEN
		MessageBox("확인","발급일자 범위를 확인하세요!")
		Return -1
	END IF	
END IF		

IF sDate1 = '00000000' THEN sDate1 = '  '
IF sDate2 = '00000000' THEN sDate2 = '99999999'

empno1 = Trim(dw_ip.GetItemString(1,"empno1"))
empno2 = Trim(dw_ip.GetItemString(1,"empno2"))

IF empno1 = '' and empno2 <> '' THEN
	MessageBox("확인","사번을 입력하세요!")
	Return -1
END IF	

IF empno1 <> '' and empno2 <> '' THEN
  IF empno1 > empno2 THEN
	  MessageBox("확인","사번범위를 확인하세요!")
	  Return -1
  END IF			 
END IF

IF empno1 = '' or isnull(empno1) THEN empno1 = '000000' 
IF empno2 = '' or isnull(empno2) THEN empno2 = 'Z999999'

IF sSaupcd = '' or isnull(sSaupcd) THEN sSaupcd = '%'

IF dw_print.Retrieve(gs_company,sDate1,sDate2,empno1,empno2, sSaupcd) < 1 THEN
	MessageBox("확인","조회된 자료가 없습니다")
   Return -1
END IF
dw_print.sharedata(dw_list)
Return 1
end function

on wp_pif2113.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on wp_pif2113.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;w_mdi_frame.sle_msg.text = ''
w_mdi_frame.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"
dw_ip.SetItem(1,'dayto',String(f_today()))
dw_ip.SetItem(1,'dayfrom',String(Left(String(f_today()),6) + "01"))
end event

type p_xls from w_standard_print`p_xls within wp_pif2113
end type

type p_sort from w_standard_print`p_sort within wp_pif2113
end type

type p_preview from w_standard_print`p_preview within wp_pif2113
integer x = 4082
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within wp_pif2113
integer x = 4430
string pointer = ""
end type

type p_print from w_standard_print`p_print within wp_pif2113
integer x = 4256
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pif2113
integer x = 3909
string pointer = ""
end type

type st_window from w_standard_print`st_window within wp_pif2113
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within wp_pif2113
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pif2113
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within wp_pif2113
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within wp_pif2113
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within wp_pif2113
string dataobject = "dr_pif2113_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pif2113
integer x = 119
integer width = 1906
string dataobject = "dr_pif2113_1"
end type

event dw_ip::itemchanged;String sEmpCode, sEmpName, SetNull, sColName1, sColName2,ls_name

AcceptText()
sColName1 = GetColumnName()

IF sColName1 = "empno1" or sColName1 = "empno2" THEN
	
	IF sColName1 = "empno1" THEN sColName2 = "empname1"
	IF sColName1 = "empno2" THEN sColName2 = "empname2"
	
	sEmpCode = GetItemString(1,sColName1)

	IF sEmpCode = "" OR ISNULL(sEmpCode) THEN
		SetItem(1,sColName2,"")
		Return 1
	ELSE
		SELECT "P1_MASTER"."EMPNAME"  
		  INTO :sEmpName  
		  FROM "P1_MASTER"  
		 WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpCode ) ; 
   	IF SQLCA.SQLCODE <> 0  THEN
			 MessageBox("확인" ,"사원코드를 확인하세요!") 
		    SetItem(1,sColName1,"")
			 SetItem(1,sColName2,"")
			 Return 1
		END IF
		    SetItem(1,sColName2,sEmpName) 
	END IF

END IF

IF sColName1 = "empname1" or sColName1 = "empname2" THEN
	
	IF sColName1 = "empname1" THEN sColName2 = "empno1"
	IF sColName1 = "empname2" THEN sColName2 = "empno2"
	
	sEmpName = GetItemString(1,sColName1)

//	IF sEmpName = "" OR ISNULL(sEmpName) THEN
//		SetItem(1,sColName2,"")
//		Return 1
//	ELSE
//			SELECT "P1_MASTER"."EMPNO"  
//			  INTO :sEmpCode
//			  FROM "P1_MASTER"  
//			 WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
//						( "P1_MASTER"."EMPNAME" = :sEmpName ) ;  
//   	IF SQLCA.SQLCODE <> 0  THEN
//			 MessageBox("확인" ,"사원명을 확인하세요!") 
//		    SetItem(1,sColName1,"")
//			 SetItem(1,sColName2,"")
//			 Return 1
//		END IF
//		    SetItem(1,sColName2,sEmpCode) 
//	END IF
   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', '%')	 
	 if IsNull(ls_name) then 
		 Setitem(1,sColName1,ls_name)
		 Setitem(1,sColName2,ls_name)
		 return 2
    end if
	 Setitem(1,sColName2,ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', '%')
	 Setitem(1,sColName1,ls_name)
	 return 1
	

END IF
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;String sColName1, sColName2

SetNull(Gs_code)
SetNull(Gs_codename)

AcceptText()
sColName1 = GetColumnName()

IF sColName1 = "empno1" or sColName1 = "empno2" THEN
	
	IF sColName1 = "empno1" THEN sColName2 = "empname1"
	IF sColName1 = "empno2" THEN sColName2 = "empname2"	

	Gs_Code = this.GetItemString(this.GetRow(),sColName1)
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	SetItem(this.GetRow(),sColName1,Gs_code)
	SetItem(this.GetRow(),sColName2,Gs_codeName)
	Return 1
END IF

IF sColName1 = "empname1" or sColName1 = "empname2" THEN

	IF sColName1 = "empname1" THEN sColName2 = "empno1"
	IF sColName1 = "empname2" THEN sColName2 = "empno2"

	Gs_Codename = GetItemString(this.GetRow(),sColName1)
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN

	SetItem(this.GetRow(),sColName1,Gs_codeName)	
	SetItem(this.GetRow(),sColName2,Gs_code)
	Return 1
END IF
end event

type dw_list from w_standard_print`dw_list within wp_pif2113
integer x = 142
integer y = 296
integer width = 4402
integer height = 1996
integer taborder = 10
string dataobject = "dr_pif2113"
boolean border = false
end type

type rr_2 from roundrectangle within wp_pif2113
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 123
integer y = 292
integer width = 4439
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 55
end type

