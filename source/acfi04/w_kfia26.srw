$PBExportHeader$w_kfia26.srw
$PBExportComments$월자금 수지 조회 출력
forward
global type w_kfia26 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia26
end type
type st_1 from statictext within w_kfia26
end type
type em_tmonth from editmask within w_kfia26
end type
type rb_1 from radiobutton within w_kfia26
end type
type rb_2 from radiobutton within w_kfia26
end type
type rb_3 from radiobutton within w_kfia26
end type
type st_5 from statictext within w_kfia26
end type
type st_2 from statictext within w_kfia26
end type
type rr_2 from roundrectangle within w_kfia26
end type
type ln_1 from line within w_kfia26
end type
end forward

global type w_kfia26 from w_standard_print
integer x = 0
integer y = 0
string title = "월 자금 수지 조회 출력"
rr_1 rr_1
st_1 st_1
em_tmonth em_tmonth
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_5 st_5
st_2 st_2
rr_2 rr_2
ln_1 ln_1
end type
global w_kfia26 w_kfia26

type variables
String sYearMonth[12]
end variables

forward prototypes
public function integer wf_calculation_month (string sym)
public function integer f_month_set ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_calculation_month (string sym);
Integer i,iIwolCnt =0
Long    lYearMonth

lYearMonth = Long(sym)

sYearMonth[1] = sYm
For i = 2 TO 12
	IF Integer(Mid(sYm,5,2)) + (i - 1) > 12 THEN
		iIWolCnt = iIWolCnt + 1
		sYearMonth[i] = String(Long(Left(sYm,4)) + 1,'0000') + String(iIWolCnt,'00')
	ELSE
		sYearMonth[i] = Left(sYm,4) + String(Integer(Mid(sYm,5,2)) + (i - 1),'00')
	END IF
NEXT

Return 1
end function

public function integer f_month_set ();string ls_yy, ls_mm, ls_set, ls_tmonth
long ll_ym

ls_tmonth = trim(em_tmonth.text)

ls_yy = left(ls_tmonth, 4)
ls_mm = '01'
ls_set = ls_yy + ls_mm
ll_ym = long(ls_set) + 1

dw_list.setitem(1, "mm01", ls_set)   // 시작년월
dw_list.setitem(1, "mm02", string(ll_ym))
dw_list.setitem(1, "mm03", string(ll_ym + 1))
dw_list.setitem(1, "mm04", string(ll_ym + 2))
dw_list.setitem(1, "mm05", string(ll_ym + 3))
dw_list.setitem(1, "mm06", string(ll_ym + 4))
dw_list.setitem(1, "mm07", string(ll_ym + 5))
dw_list.setitem(1, "mm08", string(ll_ym + 6))
dw_list.setitem(1, "mm09", string(ll_ym + 7))
dw_list.setitem(1, "mm10", string(ll_ym + 8))
dw_list.setitem(1, "mm11", string(ll_ym + 9))
dw_list.setitem(1, "mm12", string(ll_ym + 10))

return 0
end function

public function integer wf_retrieve ();
string ls_tmonth

setpointer(hourglass!)

ls_tmonth = Left(trim(em_tmonth.text),4) + Right(trim(em_tmonth.text),2)

if isnull(ls_tmonth) or ls_tmonth = '' then
	messagebox("확인", "기준년월을 확인하십시오.!", information!)
	em_tmonth.setfocus()
	return -1
else
	IF Wf_Calculation_Month(ls_tmonth) = -1 THEN
		F_Messagechk(20,'[달력]')
		em_tmonth.SetFocus()
		Return -1
	End if
end if

dw_print.setTransObject(sqlca)
if dw_print.retrieve(sYearMonth[1], &
						  sYearMonth[2],&
						  sYearMonth[3],&
						  sYearMonth[4],&
						  sYearMonth[5],&
						  sYearMonth[6],&
						  sYearMonth[7],&
						  sYearMonth[8],&
						  sYearMonth[9],&
						  sYearMonth[10],&
						  sYearMonth[11],&
						  sYearMonth[12]) < 1 then
	f_messagechk(14,'')
	em_tmonth.setfocus()
	//return -1
	dw_list.insertrow(0)
end if
dw_print.sharedata(dw_list)
Return 1
end function

on w_kfia26.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.st_1=create st_1
this.em_tmonth=create em_tmonth
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_5=create st_5
this.st_2=create st_2
this.rr_2=create rr_2
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_tmonth
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.rr_2
this.Control[iCurrent+10]=this.ln_1
end on

on w_kfia26.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.st_1)
destroy(this.em_tmonth)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_5)
destroy(this.st_2)
destroy(this.rr_2)
destroy(this.ln_1)
end on

event open;call super::open;dw_list.settransobject(sqlca)

em_tmonth.text = string(left(f_today(), 6), '@@@@.@@')

em_tmonth.SetFocus()

rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)


end event

type p_preview from w_standard_print`p_preview within w_kfia26
end type

type p_exit from w_standard_print`p_exit within w_kfia26
end type

type p_print from w_standard_print`p_print within w_kfia26
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia26
end type

type st_window from w_standard_print`st_window within w_kfia26
integer y = 5000
integer width = 466
end type

type sle_msg from w_standard_print`sle_msg within w_kfia26
integer x = 389
integer y = 5000
end type

type dw_datetime from w_standard_print`dw_datetime within w_kfia26
integer x = 2834
integer y = 5000
end type

type st_10 from w_standard_print`st_10 within w_kfia26
integer x = 27
integer y = 5000
end type

type gb_10 from w_standard_print`gb_10 within w_kfia26
integer y = 5000
end type

type dw_print from w_standard_print`dw_print within w_kfia26
string dataobject = "d_kfia26_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia26
boolean visible = false
integer x = 2336
integer y = 2716
integer height = 180
integer taborder = 50
boolean enabled = false
end type

type dw_list from w_standard_print`dw_list within w_kfia26
integer x = 50
integer y = 316
integer width = 4549
integer height = 2008
string dataobject = "d_kfia26_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia26
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 32
integer width = 1321
integer height = 232
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_1 from statictext within w_kfia26
integer x = 78
integer y = 80
integer width = 256
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "기준년월"
boolean focusrectangle = false
end type

type em_tmonth from editmask within w_kfia26
integer x = 357
integer y = 76
integer width = 379
integer height = 56
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
boolean autoskip = true
end type

type rb_1 from radiobutton within w_kfia26
integer x = 347
integer y = 172
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "계 획"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if rb_1.checked = true then
	dw_list.dataobject = "d_kfia26_1"   // 계획
	dw_list.settransobject(sqlca)
	dw_list.Reset()
end if
end event

type rb_2 from radiobutton within w_kfia26
integer x = 677
integer y = 172
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "실 적"
borderstyle borderstyle = stylelowered!
end type

event clicked;if rb_2.checked = true then
	dw_list.dataobject = "d_kfia26_2"   // 실적
	dw_list.settransobject(sqlca)
	dw_list.Reset()
end if
end event

type rb_3 from radiobutton within w_kfia26
integer x = 1006
integer y = 172
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "비 교"
borderstyle borderstyle = stylelowered!
end type

event clicked;if rb_3.checked = true then
	dw_list.dataobject = "d_kfia26_3"   // 비교
	dw_list.settransobject(sqlca)
	dw_list.Reset()
end if
end event

type st_5 from statictext within w_kfia26
integer x = 78
integer y = 176
integer width = 224
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "작업선택"
boolean focusrectangle = false
end type

type st_2 from statictext within w_kfia26
integer x = 27
integer y = 80
integer width = 59
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_kfia26
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 292
integer width = 4603
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfia26
integer linethickness = 1
integer beginx = 375
integer beginy = 132
integer endx = 736
integer endy = 132
end type

