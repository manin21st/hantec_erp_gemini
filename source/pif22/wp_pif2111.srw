$PBExportHeader$wp_pif2111.srw
$PBExportComments$** 근무년수 현황(사용)
forward
global type wp_pif2111 from w_standard_print
end type
type rr_1 from roundrectangle within wp_pif2111
end type
end forward

global type wp_pif2111 from w_standard_print
integer x = 0
integer y = 0
string title = "근무 년수 현황"
rr_1 rr_1
end type
global wp_pif2111 wp_pif2111

type variables
long ll_year, ll_month, ll_day
end variables

forward prototypes
public function long wf_compute_date (string ls_date1, string ls_date2)
public function integer wf_retrieve ()
end prototypes

public function long wf_compute_date (string ls_date1, string ls_date2);integer li_year, li_month, li_day, li_year1, li_month1, li_day1
long ll_days = 1
string ldt_temp

ll_year = 0
ll_month = 0
ll_day = 0

li_year = year(date(ls_date1))
li_month = month(Date(ls_date1))
li_day = day(Date(ls_date1))
li_year1 = year(Date(ls_date2))
li_month1 = month(Date(ls_date2))
li_day1 = day(Date(ls_date2))

// yy 년 mm개월 dd일로 산출하는 방법
ll_day = li_day1 - li_day + 1 
if ll_day < 0 then
	ldt_temp = f_lastday_month(string(date(string(li_year1) + "/" + string(li_month1) + "/01")))
	ll_day = integer(string(ldt_temp,"dd")) + li_day1 - li_day
	li_month1 = li_month1 - 1
end if

ll_month = ll_month + (li_month1 - li_month)
if ll_month < 0 then
	ll_month = (li_month1 + 12) - li_month
	li_year1 = li_year1 - 1
end if
ll_year = li_year1 - li_year

return ll_days
end function

public function integer wf_retrieve ();string ls_code1, ls_code2, ls_gubun, ls_date, ls_jikjong, sKunmu, sSaup
Long ll_cnt
String GetMinEmpno, GetMaxEmpno, ArgBuf


ls_code1   = dw_ip.GetItemString(1,"empno1")
ls_code2   = dw_ip.GetItemString(1,"empno2")
ls_date    = dw_ip.GetItemString(1,"workday")
ls_gubun   = dw_ip.GetItemString(1,"gubun") 
ls_jikjong = dw_ip.GetItemString(1,"jikjong")
sKunmu	  = dw_ip.GetItemString(1,"kunmu")
sSaup 	  = trim(dw_ip.GetItemString(1,"saup"))

if isnull(ls_code1) or ls_code1 = '' then 
  SELECT MIN(P1_MASTER.EMPNO)
	 INTO:GetMinEmpno
	 FROM P1_MASTER  ;
	
	ls_code1 = GetMinEmpno
end if

if isnull(ls_code2) or ls_code2 = '' then 
   SELECT MAX(P1_MASTER.EMPNO)
	  INTO:GetMaxEmpno
	 FROM P1_MASTER  ;

  ls_code2 = GetMaxEmpno
end if


if ls_code1 > ls_code2 then
	messagebox("사원번호", "사원번호 입력 범위가 부정확합니다.!", information!)
	dw_ip.SetColumn("empno1")
	dw_ip.SetFocus()
	return -1
end if

//if isnull(ls_gubun) or ls_gubun = '' then
//	messagebox("선택구분", "선택 구분을 입력하세요.!", information!)
//	dw_ip.SetColumn("gubun")
//	dw_ip.setfocus()
//	return -1
//end if

if ls_gubun = '' or isnull(ls_gubun) then ls_gubun = "%"

IF ls_jikjong = '' or isnull(ls_jikjong) THEN
	ls_jikjong = '%'
	dw_print.modify("t_jikjong.text = '"+'전체'+"'")
ELSE
	SELECT "CODENM"
     INTO :ArgBuf
     FROM "P0_REF"
    WHERE ( "CODEGBN" = 'JJ') AND
          ( "CODE" <> '00' ) AND
			 ( "CODE" = :ls_jikjong);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_jikjong.text = '" + ArgBuf + "'")
END IF

IF sSaup = '' OR IsNull(sSaup) THEN
	sSaup = '%'
	dw_print.modify("t_saup.text = '"+'전체'+"'")
ELSE
	SELECT "SAUPNAME"
     INTO :ArgBuf
     FROM "P0_SAUPCD"
    WHERE ( "SAUPCODE" = :sSaup);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_saup.text = '" + ArgBuf + "'")
END IF

IF sKunmu = '' OR IsNull(sKunmu) THEN
	sKunmu = '%'
	dw_print.modify("t_kunmu.text = '"+'전체'+"'")
ELSE
	SELECT "KUNMUNAME"
     INTO :ArgBuf
     FROM "P0_KUNMU"
    WHERE ( "KUNMUGUBN" = :sKunmu);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_kunmu.text = '" + ArgBuf + "'")
END IF

if isnull(ls_date) or ls_date = '' or ls_date  = '00000000'  then
	messagebox("확인", "기준 일자가 부정확합니다.!", information!)
	dw_ip.SetColumn("workday")
	dw_ip.setfocus()	
	return -1
end if

if dw_print.retrieve(ls_code1, ls_code2,ls_gubun,ls_date,ls_jikjong, sKunmu, sSaup) < 1 then
	Messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_ip.SetColumn("empno")
	dw_ip.SetFocus()
	return -1
end if

dw_print.sharedata(dw_list)
//cb_print.enabled = true
//
///* Last page 구하는 routine */
//long Li_row = 1, Ll_prev_row
//
//dw_list.setredraw(false)
//dw_list.object.datawindow.print.preview="yes"
//
//gi_page = 1
//
//do while true
//	ll_prev_row = Li_row
//	Li_row = dw_list.ScrollNextPage()
//	If Li_row = ll_prev_row or Li_row <= 0 then
//		exit
//	Else
//		gi_page++
//	End if
//loop
//
//dw_list.scrolltorow(1)
//dw_list.setredraw(true)

setpointer(arrow!)

return 1
end function

on wp_pif2111.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on wp_pif2111.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_list.settransobject(sqlca)

dw_ip.SetItem(1,"workday",String(F_today()))  

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd


end event

type p_preview from w_standard_print`p_preview within wp_pif2111
integer x = 4073
integer y = 4
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within wp_pif2111
integer x = 4421
integer y = 4
string pointer = ""
end type

type p_print from w_standard_print`p_print within wp_pif2111
integer x = 4247
integer y = 4
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pif2111
integer x = 3899
integer y = 4
string pointer = ""
end type

type st_window from w_standard_print`st_window within wp_pif2111
integer y = 4000
end type

type sle_msg from w_standard_print`sle_msg within wp_pif2111
integer y = 4000
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pif2111
integer y = 4000
end type

type st_10 from w_standard_print`st_10 within wp_pif2111
integer y = 4000
end type

type gb_10 from w_standard_print`gb_10 within wp_pif2111
integer y = 4000
end type

type dw_print from w_standard_print`dw_print within wp_pif2111
integer x = 3941
integer y = 192
string dataobject = "dp_pif2111_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pif2111
integer x = 731
integer width = 3122
integer height = 256
string dataobject = "dw_pif2111ret"
end type

event dw_ip::itemchanged;call super::itemchanged;String sEmpCode, sEmpName, SetNull, sColName1, sColName2,ls_name

AcceptText()
sColName1 = GetColumnName()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

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
   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,sColName1,ls_name)
		 return 2
    end if
	 Setitem(1,sColName2,ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,sColName1,ls_name)
	 return 2
	

END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
SetNull(Gs_gubun)

Gs_gubun = is_saupcd
IF GetColumnName() = "empno1"  THEN
	
  gs_code = GetItemString(1,"empno1")

  open(w_employee_saup_popup)

  if isnull(gs_code) or gs_code = '' then return

	SetITem(1,"empno1",gs_code)
	SetITem(1,"empname1",gs_codename)
ELSEIF GetColumnName() = "empno2"  THEN

  gs_code = GetItemString(1,"empno2")

  open(w_employee_saup_popup)

  if isnull(gs_code) or gs_code = '' then return

	SetITem(1,"empno2",gs_code)
	SetITem(1,"empname2",gs_codename)
		
END IF
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within wp_pif2111
integer x = 750
integer y = 284
integer width = 3086
integer height = 2036
integer taborder = 20
string dataobject = "dp_pif2111"
boolean border = false
end type

type rr_1 from roundrectangle within wp_pif2111
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 736
integer y = 280
integer width = 3118
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

