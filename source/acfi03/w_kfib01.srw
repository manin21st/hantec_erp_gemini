$PBExportHeader$w_kfib01.srw
$PBExportComments$금융기관별 이자율 현황
forward
global type w_kfib01 from w_standard_print
end type
type st_2 from statictext within w_kfib01
end type
type rb_1 from radiobutton within w_kfib01
end type
type rb_2 from radiobutton within w_kfib01
end type
type rb_3 from radiobutton within w_kfib01
end type
type rb_4 from radiobutton within w_kfib01
end type
type rr_1 from roundrectangle within w_kfib01
end type
type rr_2 from roundrectangle within w_kfib01
end type
end forward

global type w_kfib01 from w_standard_print
integer x = 0
integer y = 0
string title = "금융기관별 이자율 현황"
st_2 st_2
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rr_1 rr_1
rr_2 rr_2
end type
global w_kfib01 w_kfib01

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sSaupj, sacc_ym,  s_saup, s_yy, s_mm

dw_ip.AcceptText()
dw_list.Reset()

sSaupj =Trim(dw_ip.GetItemString(1,"saupj"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

sacc_ym  = Trim(dw_ip.GetItemString(1,"acc_ym"))

if sacc_ym = "" or isnull(sacc_ym) then
	f_messagechk(22,"[기준일자]")
	dw_ip.SetColumn("acc_ym")
	dw_ip.SetFocus()
	return 1
end if 

s_saup = dw_ip.GetItemString(1, "saupj")
s_yy      = Left(sacc_ym, 4)
s_mm      = Mid(sacc_ym, 5,2)

setpointer(hourglass!)

IF dw_print.Retrieve(sabu_f, sabu_t, sacc_ym) <= 0   THEN
	messagebox("확인","조회한 자료가 없습니다.!!")
	dw_list.insertrow(0)
	//return -1 
END IF
dw_print.sharedata(dw_list)	
setpointer(arrow!)
dw_ip.SetFocus()

Return 1
end function

on w_kfib01.create
int iCurrent
call super::create
this.st_2=create st_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_kfib01.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
lstr_jpra.flag =True

dw_datetime.settransobject(sqlca)
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

dw_ip.SetItem(1,"acc_ym", f_today())

dw_ip.SetItem(1,"saupj", gs_saupj)
end event

type p_preview from w_standard_print`p_preview within w_kfib01
end type

type p_exit from w_standard_print`p_exit within w_kfib01
end type

type p_print from w_standard_print`p_print within w_kfib01
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfib01
end type







type st_10 from w_standard_print`st_10 within w_kfib01
end type



type dw_print from w_standard_print`dw_print within w_kfib01
string dataobject = "d_kfib01_3_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfib01
integer x = 50
integer y = 32
integer width = 1339
integer height = 216
string dataobject = "d_kfib01_0"
end type

type dw_list from w_standard_print`dw_list within w_kfib01
integer x = 69
integer y = 268
integer width = 4512
integer height = 2044
string title = "차입종류별 이자율순"
string dataobject = "d_kfib01_3"
boolean border = false
end type

type st_2 from statictext within w_kfib01
integer x = 1417
integer y = 44
integer width = 306
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
string text = "자료선택"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_kfib01
integer x = 1431
integer y = 100
integer width = 622
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "차입종류별 이자율순"
boolean checked = true
end type

event clicked;dw_list.DataObject = 'd_kfib01_3'
dw_list.Title      = '차입종류별 이자율순'
dw_list.settransobject(sqlca)
end event

type rb_2 from radiobutton within w_kfib01
integer x = 1431
integer y = 168
integer width = 622
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "금융기관별 이자율순"
end type

event clicked;dw_list.DataObject = 'd_kfib01_4'
dw_list.Title      = '금융기관별 이자율순'
dw_list.settransobject(sqlca)
end event

type rb_3 from radiobutton within w_kfib01
integer x = 2107
integer y = 100
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "이자율별"
end type

event clicked;dw_list.DataObject = 'd_kfib01_2'
dw_list.Title      = '이자율순'
dw_list.settransobject(sqlca)
end event

type rb_4 from radiobutton within w_kfib01
integer x = 2107
integer y = 168
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "만기일별"
end type

event clicked;dw_list.DataObject = 'd_kfib01_1'
dw_list.Title      = '만기일별'
dw_list.settransobject(sqlca)
end event

type rr_1 from roundrectangle within w_kfib01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1390
integer y = 32
integer width = 1147
integer height = 208
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfib01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 256
integer width = 4539
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

