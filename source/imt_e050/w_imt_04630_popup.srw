$PBExportHeader$w_imt_04630_popup.srw
$PBExportComments$소모공구 마스타 조회 선택
forward
global type w_imt_04630_popup from w_inherite_popup
end type
type rr_1 from roundrectangle within w_imt_04630_popup
end type
type dw_2 from datawindow within w_imt_04630_popup
end type
type st_2 from statictext within w_imt_04630_popup
end type
type st_3 from statictext within w_imt_04630_popup
end type
type rr_2 from roundrectangle within w_imt_04630_popup
end type
type sle_3 from singlelineedit within w_imt_04630_popup
end type
type rb_1 from radiobutton within w_imt_04630_popup
end type
type rb_2 from radiobutton within w_imt_04630_popup
end type
type st_4 from statictext within w_imt_04630_popup
end type
end forward

global type w_imt_04630_popup from w_inherite_popup
integer x = 110
integer y = 172
integer width = 3077
integer height = 1916
string title = "금형/치공구 마스터 선택 POPUP"
rr_1 rr_1
dw_2 dw_2
st_2 st_2
st_3 st_3
rr_2 rr_2
sle_3 sle_3
rb_1 rb_1
rb_2 rb_2
st_4 st_4
end type
global w_imt_04630_popup w_imt_04630_popup

on w_imt_04630_popup.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_2=create dw_2
this.st_2=create st_2
this.st_3=create st_3
this.rr_2=create rr_2
this.sle_3=create sle_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.sle_3
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.st_4
end on

on w_imt_04630_popup.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_2)
destroy(this.sle_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_4)
end on

event open;call super::open;string sGubun

if gs_gubun = 'M' then 
	sGubun = 'M'
	dw_2.Modify('gubun.protect = 1')
elseif gs_gubun = 'J' then 
	sGubun = 'J'
	dw_2.Modify('gubun.protect = 1')
else
	sGubun = '%'
end if

dw_2.insertrow(0)
dw_2.setitem(1, 'gubun', sGubun)

If gs_code = '1' Then
	dw_2.SetItem(1, 'gubun', 'M')
	dw_2.Enabled = False
ElseIf gs_code = '2' Then
	dw_2.SetItem(1, 'gubun', 'J')
	dw_2.Enabled = False
End If

//dw_1.Retrieve(gs_sabu,'%','%','%', sGubun)
//	
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()
//

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_imt_04630_popup
integer x = 114
integer y = 1972
end type

type p_exit from w_inherite_popup`p_exit within w_imt_04630_popup
integer x = 2862
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_imt_04630_popup
integer x = 2514
end type

event p_inq::clicked;call super::clicked;string sKumNo, sKumNm, sSts, sGubun, sSpec

IF dw_2.accepttext() = -1 then return 

sKumNo = Trim(sle_1.text)
sKumNm = Trim(sle_2.text)
sSpec  = Trim(sle_3.text)

If IsNull(sKumNo) Or sKumNo = '' Then
	sKumNo = '%'
Else
	sKumNo = sKumNo + '%'
End If
If IsNull(sKumNm) Or sKumNm = '' Then
	sKumNm = '%'
Else
	sKumNm = '%' + sKumNm + '%'
End If
If IsNull(sSpec) Or sSpec = '' Then
	sSpec = '%'
Else
	sSpec = '%' + sSpec + '%'
End If

sSts   = dw_2.getitemstring(1, 'sts')
sGubun = dw_2.getitemstring(1, 'gubun')

If rb_1.Checked = True Then
	dw_1.SetFilter("BOCVCOD = '100000'")
Else
	dw_1.SetFilter("BOCVCOD <> '100000'")
End If
dw_1.Filter()

dw_1.Retrieve(gs_sabu, sKumNo, sKumNm, sSts, sGubun, sSpec)
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_imt_04630_popup
integer x = 2688
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "kumno")
gs_codename = dw_1.GetItemString(ll_Row, "kumname")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_imt_04630_popup
integer x = 46
integer y = 248
integer width = 2976
integer height = 1512
integer taborder = 40
string dataobject = "d_imt_04630_popup"
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "kumno")
gs_codename= dw_1.GetItemString(row,"kumname")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_imt_04630_popup
integer x = 891
integer y = 136
integer width = 649
integer height = 64
integer taborder = 30
boolean border = true
integer limit = 40
end type

event sle_2::getfocus;f_toggle_kor(Handle(this))

end event

type cb_1 from w_inherite_popup`cb_1 within w_imt_04630_popup
boolean visible = false
integer x = 2542
integer y = 1992
integer taborder = 50
end type

event cb_1::clicked;call super::clicked;//Long ll_row
//
//ll_Row = dw_1.GetSelectedRow(0)
//
//IF ll_Row <= 0 THEN
//   f_message_chk(36,'')
//   return
//END IF
//
//gs_code= dw_1.GetItemString(ll_Row, "kumno")
//gs_codename = dw_1.GetItemString(ll_Row, "kumname")
//
//Close(Parent)
//
end event

type cb_return from w_inherite_popup`cb_return within w_imt_04630_popup
boolean visible = false
integer x = 3163
integer y = 1992
integer taborder = 70
end type

event cb_return::clicked;call super::clicked;//SetNull(gs_code)
//Close(Parent)
end event

type cb_inq from w_inherite_popup`cb_inq within w_imt_04630_popup
boolean visible = false
integer x = 2853
integer y = 1992
integer taborder = 60
end type

event cb_inq::clicked;call super::clicked;//string sKumNo, sKumNm, sSts, sGubun, sSpec
//
//IF dw_2.accepttext() = -1 then return 
//
//sKumNo = Trim(sle_1.text)
//sKumNm = Trim(sle_2.text)
//sSpec  = Trim(sle_3.text)
//
//If IsNull(sKumNo) Or sKumNo = '' Then
//	sKumNo = '%'
//Else
//	sKumNo = sKumNo + '%'
//End If
//If IsNull(sKumNm) Or sKumNm = '' Then
//	sKumNm = '%'
//Else
//	sKumNm = '%' + sKumNm + '%'
//End If
//If IsNull(sSpec) Or sSpec = '' Then
//	sSpec = '%'
//Else
//	sSpec = '%' + sSpec + '%'
//End If
//
//sSts   = dw_2.getitemstring(1, 'sts')
//sGubun = dw_2.getitemstring(1, 'gubun')
//
//dw_1.Retrieve(gs_sabu, sKumNo, sKumNm, sSts, sGubun, sSpec)
//	
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
//dw_1.ScrollToRow(1)
//dw_1.SetFocus()
//
end event

type sle_1 from w_inherite_popup`sle_1 within w_imt_04630_popup
event pressenterkey pbm_dwnprocessenter
integer x = 375
integer y = 136
integer width = 297
integer height = 64
integer taborder = 20
boolean border = true
integer limit = 7
end type

event sle_1::modified;cb_inq.triggerevent(clicked!)
end event

type st_1 from w_inherite_popup`st_1 within w_imt_04630_popup
integer x = 78
integer y = 144
integer width = 288
integer height = 64
integer weight = 400
long backcolor = 33027312
string text = "관리번호:"
alignment alignment = right!
end type

type rr_1 from roundrectangle within w_imt_04630_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 36
integer width = 2469
integer height = 192
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from datawindow within w_imt_04630_popup
integer x = 64
integer y = 40
integer width = 1577
integer height = 84
integer taborder = 10
string dataobject = "d_imt_04630_popup1"
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_imt_04630_popup
integer x = 704
integer y = 144
integer width = 178
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "품번:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_imt_04630_popup
integer x = 1577
integer y = 144
integer width = 206
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "규격:"
alignment alignment = right!
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_imt_04630_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 236
integer width = 3003
integer height = 1536
integer cornerheight = 40
integer cornerwidth = 55
end type

type sle_3 from singlelineedit within w_imt_04630_popup
integer x = 1797
integer y = 136
integer width = 649
integer height = 64
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean autohscroll = false
end type

type rb_1 from radiobutton within w_imt_04630_popup
integer x = 1961
integer y = 56
integer width = 224
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
string text = "사내"
boolean checked = true
end type

type rb_2 from radiobutton within w_imt_04630_popup
integer x = 2217
integer y = 56
integer width = 224
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
string text = "사외"
end type

type st_4 from statictext within w_imt_04630_popup
integer x = 1705
integer y = 56
integer width = 187
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "보관처"
boolean focusrectangle = false
end type

