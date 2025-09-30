$PBExportHeader$w_zip_popup_pre.srw
$PBExportComments$** 오픈시 우편번호 조회 후 선택
forward
global type w_zip_popup_pre from w_inherite_popup
end type
type st_2 from statictext within w_zip_popup_pre
end type
type sle_find from singlelineedit within w_zip_popup_pre
end type
type rr_1 from roundrectangle within w_zip_popup_pre
end type
end forward

global type w_zip_popup_pre from w_inherite_popup
integer x = 1938
integer y = 84
integer width = 2071
integer height = 1676
string title = "우편번호 조회 선택"
boolean controlmenu = true
st_2 st_2
sle_find sle_find
rr_1 rr_1
end type
global w_zip_popup_pre w_zip_popup_pre

event key;call super::key;choose case key
	case keyenter!
		sle_find.TriggerEvent(Modified!)
end choose
end event

event open;call super::open;
dw_1.Retrieve('%')

sle_find.SetFocus()

end event

on w_zip_popup_pre.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_find=create sle_find
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_find
this.Control[iCurrent+3]=this.rr_1
end on

on w_zip_popup_pre.destroy
call super::destroy
destroy(this.st_2)
destroy(this.sle_find)
destroy(this.rr_1)
end on

type dw_jogun from w_inherite_popup`dw_jogun within w_zip_popup_pre
boolean visible = false
integer x = 192
integer y = 2772
integer taborder = 0
end type

type p_exit from w_inherite_popup`p_exit within w_zip_popup_pre
integer x = 1861
integer y = 4
integer taborder = 30
end type

event p_exit::clicked;call super::clicked;
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_zip_popup_pre
boolean visible = false
integer x = 1641
integer y = 2616
integer height = 140
integer taborder = 0
boolean originalsize = false
end type

type p_choose from w_inherite_popup`p_choose within w_zip_popup_pre
integer x = 1687
integer y = 4
integer taborder = 20
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "zip")
gs_codename = dw_1.GetItemString(ll_Row, "addr")

Close(Parent)




end event

type dw_1 from w_inherite_popup`dw_1 within w_zip_popup_pre
integer x = 23
integer y = 160
integer width = 1989
integer height = 1404
string dataobject = "d_zip_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE
   dw_1.setfocus()
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code = dw_1.GetItemString(Row, "zip")
gs_codename = dw_1.GetItemString(Row, "addr")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_zip_popup_pre
boolean visible = false
integer y = 2668
end type

type cb_1 from w_inherite_popup`cb_1 within w_zip_popup_pre
boolean visible = false
integer y = 2416
end type

type cb_return from w_inherite_popup`cb_return within w_zip_popup_pre
boolean visible = false
integer y = 2416
end type

type cb_inq from w_inherite_popup`cb_inq within w_zip_popup_pre
boolean visible = false
integer y = 2416
end type

type sle_1 from w_inherite_popup`sle_1 within w_zip_popup_pre
boolean visible = false
integer y = 2668
end type

type st_1 from w_inherite_popup`st_1 within w_zip_popup_pre
boolean visible = false
integer y = 2680
end type

type st_2 from statictext within w_zip_popup_pre
integer x = 32
integer y = 48
integer width = 169
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "주소"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_find from singlelineedit within w_zip_popup_pre
integer x = 201
integer y = 36
integer width = 1285
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean autohscroll = false
integer limit = 30
borderstyle borderstyle = stylelowered!
end type

event getfocus;
f_toggle_kor(Handle(this))
end event

event modified;string saddr

saddr = Trim(sle_find.Text)

IF IsNull(saddr) THEN
	saddr =""
END IF

IF dw_1.Retrieve('%' + saddr + '%') <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	sle_find.SetFocus()
	Return
END IF
end event

type rr_1 from roundrectangle within w_zip_popup_pre
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 152
integer width = 2007
integer height = 1420
integer cornerheight = 40
integer cornerwidth = 46
end type

