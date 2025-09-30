$PBExportHeader$wp_pif2112.srw
$PBExportComments$** 퇴사자 현황(사용)
forward
global type wp_pif2112 from w_standard_print
end type
type rr_1 from roundrectangle within wp_pif2112
end type
type rb_1 from radiobutton within wp_pif2112
end type
type rb_2 from radiobutton within wp_pif2112
end type
type rb_3 from radiobutton within wp_pif2112
end type
type st_4 from statictext within wp_pif2112
end type
type rr_2 from roundrectangle within wp_pif2112
end type
end forward

global type wp_pif2112 from w_standard_print
integer x = 0
integer y = 0
string title = "퇴사자 현황"
rr_1 rr_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_4 st_4
rr_2 rr_2
end type
global wp_pif2112 wp_pif2112

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_date1, ls_date2
String ls_jikjong, sKunmu, sSaup, ArgBuf

setpointer(hourglass!)

dw_ip.AcceptText()

ls_date1 	= trim(dw_ip.GetItemString(1,"retdayfrom"))
ls_date2 	= trim(dw_ip.GetItemString(1,"retdayto"))
ls_jikjong 	= trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu		= trim(dw_ip.GetItemString(1,"kunmu"))
sSaup 		= trim(dw_ip.GetItemString(1,"saup"))

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

if dw_print.retrieve(ls_date1, ls_date2, ls_jikjong, sKunmu, sSaup) < 1 then
	messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
	dw_ip.SetColumn("retdayfrom")
	dw_ip.SetFocus()
	return -1
end if

IF rb_1.Checked = TRUE THEN
	dw_print.setsort("1A")
ELSEIF rb_2.Checked = TRUE THEN
	dw_print.setsort("2A")
ELSEIF rb_3.Checked = TRUE THEN
	dw_print.setsort("3A")
END IF

dw_print.sort()
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
//
setpointer(arrow!)

return 1
end function

on wp_pif2112.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_4=create st_4
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rr_2
end on

on wp_pif2112.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_4)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.settransobject(sqlca)

dw_ip.SetItem(1,"retdayto",String(f_today()))
dw_ip.SetItem(1,"retdayfrom",String(Left(String(f_today()),6) + "01"))

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd

rb_1.Checked = True
end event

type p_preview from w_standard_print`p_preview within wp_pif2112
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

type p_exit from w_standard_print`p_exit within wp_pif2112
integer x = 4416
string pointer = ""
end type

type p_print from w_standard_print`p_print within wp_pif2112
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

type p_retrieve from w_standard_print`p_retrieve within wp_pif2112
integer x = 3895
string pointer = ""
end type

type st_window from w_standard_print`st_window within wp_pif2112
integer y = 4000
end type

type sle_msg from w_standard_print`sle_msg within wp_pif2112
integer y = 4000
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pif2112
integer y = 4000
end type

type st_10 from w_standard_print`st_10 within wp_pif2112
integer y = 4000
end type

type gb_10 from w_standard_print`gb_10 within wp_pif2112
integer y = 4000
end type

type dw_print from w_standard_print`dw_print within wp_pif2112
integer x = 3721
integer y = 68
string dataobject = "dp_pif2112_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pif2112
integer x = 123
integer y = 60
integer width = 1851
integer height = 176
string dataobject = "dp_pif2112_1"
end type

event dw_ip::itemchanged;call super::itemchanged;this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within wp_pif2112
integer x = 23
integer y = 296
integer width = 4567
integer height = 1980
integer taborder = 20
string dataobject = "dp_pif2112"
boolean border = false
end type

type rr_1 from roundrectangle within wp_pif2112
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 28
integer width = 2665
integer height = 252
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within wp_pif2112
integer x = 2213
integer y = 64
integer width = 379
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "사 번 순"
boolean checked = true
end type

event clicked;if rb_1.checked = true then
	rb_2.checked = false
	rb_3.checked = false
end if

p_retrieve.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within wp_pif2112
integer x = 2213
integer y = 124
integer width = 379
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "성 명 순"
end type

event clicked;if rb_2.checked = true then
	rb_1.checked = false
	rb_3.checked = false
end if

p_retrieve.TriggerEvent(Clicked!)
end event

type rb_3 from radiobutton within wp_pif2112
integer x = 2213
integer y = 192
integer width = 379
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "퇴사일자순"
end type

event clicked;if rb_3.checked = true then
	rb_1.checked = false
	rb_2.checked = false
end if

p_retrieve.TriggerEvent(Clicked!)
end event

type st_4 from statictext within wp_pif2112
integer x = 2048
integer y = 68
integer width = 151
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "정 렬"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within wp_pif2112
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 292
integer width = 4594
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

