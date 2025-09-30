$PBExportHeader$w_sm05_00070.srw
$PBExportComments$차종구성 현황
forward
global type w_sm05_00070 from w_standard_print
end type
type rb_item from radiobutton within w_sm05_00070
end type
type rb_car from radiobutton within w_sm05_00070
end type
type gb_1 from groupbox within w_sm05_00070
end type
type rr_2 from roundrectangle within w_sm05_00070
end type
end forward

global type w_sm05_00070 from w_standard_print
string title = "차종구성 현황"
rb_item rb_item
rb_car rb_car
gb_1 gb_1
rr_2 rr_2
end type
global w_sm05_00070 w_sm05_00070

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sCargbn1, sCargbn2

If dw_ip.AcceptText() <> 1 Then Return -1

sCargbn1 = Trim(dw_ip.GetItemString(1, 'cargbn1'))
sCargbn2 = Trim(dw_ip.GetItemString(1, 'cargbn2'))


IF dw_print.Retrieve(sCargbn1, sCargbn2) < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

return 1
end function

on w_sm05_00070.create
int iCurrent
call super::create
this.rb_item=create rb_item
this.rb_car=create rb_car
this.gb_1=create gb_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_item
this.Control[iCurrent+2]=this.rb_car
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_sm05_00070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_item)
destroy(this.rb_car)
destroy(this.gb_1)
destroy(this.rr_2)
end on

type p_preview from w_standard_print`p_preview within w_sm05_00070
end type

type p_exit from w_standard_print`p_exit within w_sm05_00070
end type

type p_print from w_standard_print`p_print within w_sm05_00070
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm05_00070
end type







type st_10 from w_standard_print`st_10 within w_sm05_00070
end type



type dw_print from w_standard_print`dw_print within w_sm05_00070
string dataobject = "d_sm05_00070_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm05_00070
boolean visible = false
integer y = 176
integer width = 3671
integer height = 144
string dataobject = "d_sm05_00070_1"
end type

event dw_ip::itemchanged;Long ix, nrow
String sCarcode, sCargbn1, sCargbn2, sCarnm, sTemp, sNull

SetNull(sNull)

Choose Case GetColumnName()
	Case 'cargbn1'
		sCargbn1 = GetText()
		
		// 차종이 아닌경우 '기타'로 설정
		If ( sCargbn1 <> 'E' And sCargbn1 <> 'C' ) Then
			SetItem(1, 'cargbn2','9')
		Else
			SetItem(1, 'cargbn2','E')
		End If
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sm05_00070
integer x = 46
integer width = 4558
string dataobject = "d_sm05_00070_2"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	selectrow(0,false)
	selectrow(currentrow,true)
else
	selectrow(0,false)
end if
end event

type rb_item from radiobutton within w_sm05_00070
integer x = 713
integer y = 80
integer width = 512
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "품목별 차종현황"
end type

event clicked;dw_print.DataObject = 'd_sm05_00070_3_p'
dw_list.DataObject = 'd_sm05_00070_3'
dw_print.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
end event

type rb_car from radiobutton within w_sm05_00070
integer x = 105
integer y = 80
integer width = 494
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "차종별 품목현황"
boolean checked = true
end type

event clicked;dw_print.DataObject = 'd_sm05_00070_2_p'
dw_list.DataObject = 'd_sm05_00070_2'
dw_print.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
end event

type gb_1 from groupbox within w_sm05_00070
integer x = 69
integer y = 8
integer width = 1248
integer height = 156
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "작업구분"
end type

type rr_2 from roundrectangle within w_sm05_00070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 41
integer y = 336
integer width = 4581
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

