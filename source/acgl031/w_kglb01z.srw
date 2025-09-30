$PBExportHeader$w_kglb01z.srw
$PBExportComments$전표구분 선택
forward
global type w_kglb01z from window
end type
type p_1 from uo_picture within w_kglb01z
end type
type p_2 from uo_picture within w_kglb01z
end type
type rb_3 from radiobutton within w_kglb01z
end type
type rb_1 from radiobutton within w_kglb01z
end type
type rb_2 from radiobutton within w_kglb01z
end type
type dw_gubun from datawindow within w_kglb01z
end type
type gb_2 from groupbox within w_kglb01z
end type
end forward

global type w_kglb01z from window
integer x = 741
integer y = 624
integer width = 1929
integer height = 1160
boolean titlebar = true
string title = "작업 선택"
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
p_2 p_2
rb_3 rb_3
rb_1 rb_1
rb_2 rb_2
dw_gubun dw_gubun
gb_2 gb_2
end type
global w_kglb01z w_kglb01z

on w_kglb01z.create
this.p_1=create p_1
this.p_2=create p_2
this.rb_3=create rb_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_gubun=create dw_gubun
this.gb_2=create gb_2
this.Control[]={this.p_1,&
this.p_2,&
this.rb_3,&
this.rb_1,&
this.rb_2,&
this.dw_gubun,&
this.gb_2}
end on

on w_kglb01z.destroy
destroy(this.p_1)
destroy(this.p_2)
destroy(this.rb_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_gubun)
destroy(this.gb_2)
end on

event open;String sDeptCode

f_window_center_Response(THIS)

dw_gubun.SetTransObject(SQLCA)

dw_gubun.Reset()
dw_gubun.InsertRow(0)

dw_gubun.SetItem(1,"upmu_gu",'A')

IF Message.StringParm = '9' THEN
	P_1.Enabled = False
ELSE
	P_1.Enabled = True
END IF

//IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
//	dw_gubun.Modify("upmu_gu.protect = 1")
//ELSE
//	dw_gubun.Modify("upmu_gu.protect = 0")
//END IF

dw_gubun.SetFocus()
end event

type p_1 from uo_picture within w_kglb01z
integer x = 1714
integer y = 8
integer width = 178
integer taborder = 30
string pointer = "c:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;CLOSEWithReturn(w_kglb01z,'0')
end event

type p_2 from uo_picture within w_kglb01z
integer x = 1536
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "c:\erpman\cur\confirm.cur"
string picturename = "C:\erpman\image\확인_up.gif"
end type

event clicked;call super::clicked;String supmugu,sJunGbn

dw_gubun.AcceptText()

supmugu = dw_gubun.GetItemString(1,"upmu_gu")

IF IsNull(supmugu) OR supmugu ="" THEN
	Messagebox("확 인","작업할 전표구분을 선택하지 않았습니다.!!")
	Return
END IF

IF rb_1.Checked = True THEN
	sJunGbn = '1'							/*입금전표*/
ELSEIF rb_2.Checked = True THEN
	sJunGbn = '2'							/*출금전표*/
ELSEif rb_3.Checked = True THEN
	sJunGbn = '3'							/*대체전표*/
END IF
CLOSEWithReturn(w_kglb01z,supmugu+sJunGbn)
end event

type rb_3 from radiobutton within w_kglb01z
integer x = 1275
integer y = 928
integer width = 439
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
string text = "대체전표"
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_kglb01z
integer x = 96
integer y = 928
integer width = 439
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
string text = "입금 전표"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;//cb_2.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within w_kglb01z
integer x = 686
integer y = 928
integer width = 439
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
string text = "출금 전표"
borderstyle borderstyle = stylelowered!
end type

event clicked;//cb_2.TriggerEvent(Clicked!)
end event

type dw_gubun from datawindow within w_kglb01z
event ue_keyenter pbm_dwnprocessenter
integer x = 14
integer y = 148
integer width = 1879
integer height = 712
integer taborder = 10
string dataobject = "dw_kglb01z"
boolean border = false
boolean livescroll = true
end type

event ue_keyenter;p_2.TriggerEvent(Clicked!)
end event

event doubleclicked;
//cb_2.TriggerEvent(Clicked!)
end event

event itemchanged;
IF dwo.name = 'upmu_gu' THEN
	if data = 'A' then
		rb_1.Enabled = True
		rb_1.Checked = True
		
		rb_2.Enabled = True
		rb_3.Enabled = True	
	else
		rb_1.Enabled = False
				
		rb_2.Enabled = False
		rb_3.Enabled = False
		rb_3.Checked = True
	end if
END IF
end event

type gb_2 from groupbox within w_kglb01z
integer x = 27
integer y = 868
integer width = 1847
integer height = 164
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "전표 종류"
borderstyle borderstyle = styleraised!
end type

