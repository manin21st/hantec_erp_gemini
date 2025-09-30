$PBExportHeader$w_pif2310.srw
$PBExportComments$** 기간별 상벌현황
forward
global type w_pif2310 from w_standard_print
end type
type rr_2 from roundrectangle within w_pif2310
end type
end forward

global type w_pif2310 from w_standard_print
integer x = 0
integer y = 0
string title = "기간별 상벌 현황"
rr_2 rr_2
end type
global w_pif2310 w_pif2310

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_date1, ls_date2, sgubn
String ls_jikjong, sKunmu, sSaup, ArgBuf

setpointer(hourglass!)

dw_ip.AcceptText()

ls_date1 	= trim(dw_ip.GetItemString(1,"retdayfrom"))
ls_date2 	= trim(dw_ip.GetItemString(1,"retdayto"))
ls_jikjong 	= trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu		= trim(dw_ip.GetItemString(1,"kunmu"))
sSaup 		= trim(dw_ip.GetItemString(1,"saup"))
sgubn       = trim(dw_ip.GetItemString(1,"gubn"))

IF ls_date1 = "00000000"  THEN
	messagebox("퇴사일자(FROM)", "퇴사 일자를 입력하세요.!", information!)
	dw_ip.SetColumn("retdayfrom")
	dw_ip.SetFocus()
	return -1
END IF
IF ls_date2 = "00000000"  THEN
	messagebox("퇴사일자(TO)", "퇴사 일자를 입력하세요.!", information!)
	dw_ip.SetColumn("retdayto")
	dw_ip.SetFocus()
	return -1
END IF


if ls_date1 > ls_date2 then
	messagebox("범위 확인", "퇴사일자 입력범위가 부정확합니다.!", information!)
	dw_ip.SetColumn("retdayfrom")
	dw_ip.SetFocus()
	return -1
end if

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

if dw_print.retrieve(gs_company,  sSaup, ls_date1, ls_date2, ls_jikjong, sKunmu,  sgubn) < 1 then
	messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_ip.SetColumn("retdayfrom")
	dw_ip.SetFocus()
	return -1
end if

setpointer(arrow!)

return 1
end function

on w_pif2310.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_pif2310.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.settransobject(sqlca)

dw_ip.SetItem(1,"retdayto",String(f_today()))
dw_ip.SetItem(1,"retdayfrom",String(Left(String(f_today()),6) + "01"))

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd


end event

type p_preview from w_standard_print`p_preview within w_pif2310
integer x = 4069
string pointer = ""
end type

event p_preview::clicked;//string ls_date1, ls_date2
//String ls_gubun, sKunmu
//
//setpointer(hourglass!)
//
//ls_date1 = trim(dw_ip.GetItemString(1,"retdayfrom"))
//ls_date2 = trim(dw_ip.GetItemString(1,"retdayto"))
//ls_gubun = dw_ip.GetItemString(1,"jikjong")
//sKunmu	= dw_ip.GetItemString(1,"kunmu")
//
//if sKunmu = '' or isnull(sKunmu) then sKunmu = "%"
//if ls_gubun = '' or isnull(ls_gubun) then ls_gubun = "%"
//
//dw_print.retrieve(ls_date1, ls_date2, ls_gubun, sKunmu)
//
//IF rb_1.Checked = TRUE THEN
//	dw_list.setsort("1A")
//ELSEIF rb_2.Checked = TRUE THEN
//	dw_list.setsort("2A")
//ELSEIF rb_3.Checked = TRUE THEN
//	dw_list.setsort("3A")
//END IF
//
//dw_list.sort()

OpenWithParm(w_print_preview, dw_print)
end event

type p_exit from w_standard_print`p_exit within w_pif2310
integer x = 4416
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_pif2310
integer x = 4242
string pointer = ""
end type

event p_print::clicked;//string ls_date1, ls_date2
//String ls_gubun
//
//setpointer(hourglass!)
//
//ls_date1 = trim(dw_ip.GetItemString(1,"retdayfrom"))
//ls_date2 = trim(dw_ip.GetItemString(1,"retdayto"))
//ls_gubun = dw_ip.GetItemString(1,"jikjong")
//
//if ls_gubun = '' or isnull(ls_gubun) then ls_gubun = "%"		
//
//dw_print.Reset()
//dw_print.retrieve(ls_date1, ls_date2,ls_gubun) 

IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within w_pif2310
integer x = 3895
string pointer = ""
end type

type st_window from w_standard_print`st_window within w_pif2310
integer y = 4000
end type

type sle_msg from w_standard_print`sle_msg within w_pif2310
integer y = 4000
end type

type dw_datetime from w_standard_print`dw_datetime within w_pif2310
integer y = 4000
end type

type st_10 from w_standard_print`st_10 within w_pif2310
integer y = 4000
end type

type gb_10 from w_standard_print`gb_10 within w_pif2310
integer y = 4000
end type

type dw_print from w_standard_print`dw_print within w_pif2310
integer x = 3721
integer y = 68
string dataobject = "d_pif2310_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pif2310
integer x = 14
integer y = 8
integer width = 2747
integer height = 272
string dataobject = "d_pif2310_1"
end type

event dw_ip::itemchanged;call super::itemchanged;this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_pif2310
integer x = 23
integer y = 288
integer width = 4539
integer height = 1952
integer taborder = 20
string dataobject = "d_pif2310_2"
boolean border = false
end type

type rr_2 from roundrectangle within w_pif2310
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 284
integer width = 4567
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

