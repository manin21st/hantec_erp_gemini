$PBExportHeader$w_qct_05010.srw
$PBExportComments$계획생성
forward
global type w_qct_05010 from w_inherite
end type
type gb_1 from groupbox within w_qct_05010
end type
type gb_2 from groupbox within w_qct_05010
end type
type st_2 from statictext within w_qct_05010
end type
type st_3 from statictext within w_qct_05010
end type
type st_4 from statictext within w_qct_05010
end type
end forward

global type w_qct_05010 from w_inherite
string title = "계획생성"
gb_1 gb_1
gb_2 gb_2
st_2 st_2
st_3 st_3
st_4 st_4
end type
global w_qct_05010 w_qct_05010

on w_qct_05010.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.gb_2=create gb_2
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
end on

on w_qct_05010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
end on

event open;call super::open;int nRow
string syear

dw_insert.SetTransObject(sqlca)

nRow = dw_insert.InsertRow(0)

syear = String(f_afterday(f_today(), 15),"@@@@@@")
dw_insert.SetItem(nRow,'syear1',syear)
dw_insert.SetItem(nRow,'syear2',syear)
end event

type dw_insert from w_inherite`dw_insert within w_qct_05010
integer x = 1765
integer y = 632
integer width = 1125
integer height = 524
string dataobject = "d_qct_05010"
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;String s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "syear1" then 
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35,"[시작년월]")
		this.object.syear1[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "syear2" then 
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35,"[끝년월]")
		this.object.syear2[1] = ""
		return 1
	end if	
end if

return
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_qct_05010
boolean visible = false
end type

type p_addrow from w_inherite`p_addrow within w_qct_05010
boolean visible = false
end type

type p_search from w_inherite`p_search within w_qct_05010
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_qct_05010
boolean visible = false
end type

type p_exit from w_inherite`p_exit within w_qct_05010
integer x = 2354
integer y = 1680
end type

event p_exit::clicked;call super::clicked;//close(parent)

end event

type p_can from w_inherite`p_can within w_qct_05010
boolean visible = false
end type

type p_print from w_inherite`p_print within w_qct_05010
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_qct_05010
boolean visible = false
end type

type p_del from w_inherite`p_del within w_qct_05010
boolean visible = false
end type

type p_mod from w_inherite`p_mod within w_qct_05010
integer x = 2135
integer y = 1680
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_mod::clicked;call super::clicked;int nRow
string syear1,syear2
double i_rtn

if dw_insert.AcceptText() = -1 then
	dw_insert.SetFocus()
	return
end if
syear1 = Trim(dw_insert.GetItemString(1,'syear1'))
syear2 = Trim(dw_insert.GetItemString(1,'syear2'))
If syear1 = '' Or IsNull(syear1) Then
	f_message_chk(40,'시작년월')
   dw_insert.SetFocus()
	dw_insert.SetColumn('syear1')			
	Return 
End If
If syear2 = '' Or IsNull(syear2) Then
	f_message_chk(40,'끝년월')
   dw_insert.SetFocus()
	dw_insert.SetColumn('syear2')			
	Return 
End If

if Messagebox("주 의","기존 계획 중에서 실시하지 않은 자료을 삭제후 재생성 합니다!~n~n" + &
                      "진행 하시겠습니까?",Question!,YesNo!,1) <> 1 then 
	sle_msg.text = "생성작업이 취소되었습니다!"						 
	return
else
	sle_msg.text = ""
end if

setpointer(hourglass!)
i_rtn = 0
// Stored Procedure call 
SQLCA.ERP000000290(gs_sabu, syear1, syear2, i_rtn)

messagebox("생성 완료","총 [ " + String(i_rtn) + " ] 건의 자료가 생성되었습니다!")

end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_qct_05010
boolean visible = false
integer x = 110
integer y = 1072
integer taborder = 30
end type

type cb_mod from w_inherite`cb_mod within w_qct_05010
boolean visible = false
integer x = 187
integer y = 852
integer width = 361
string text = "생성(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_qct_05010
boolean visible = false
integer taborder = 40
end type

type cb_del from w_inherite`cb_del within w_qct_05010
boolean visible = false
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_qct_05010
boolean visible = false
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_qct_05010
boolean visible = false
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_qct_05010
end type

type cb_can from w_inherite`cb_can within w_qct_05010
boolean visible = false
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_qct_05010
boolean visible = false
integer taborder = 90
end type







type gb_button1 from w_inherite`gb_button1 within w_qct_05010
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_05010
end type

type gb_1 from groupbox within w_qct_05010
integer x = 2057
integer y = 1624
integer width = 539
integer height = 232
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type gb_2 from groupbox within w_qct_05010
integer x = 571
integer y = 24
integer width = 3515
integer height = 2036
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 32106727
end type

type st_2 from statictext within w_qct_05010
integer x = 1883
integer y = 376
integer width = 891
integer height = 112
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "교정 계획 생성"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_qct_05010
integer x = 1536
integer y = 1244
integer width = 1189
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "(주의) 기존의 계획된 자료 중에서"
boolean focusrectangle = false
end type

type st_4 from statictext within w_qct_05010
integer x = 1751
integer y = 1320
integer width = 1883
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "미실시 자료를 삭제 한 후에 생성 작업을 진행 합니다!"
boolean focusrectangle = false
end type

