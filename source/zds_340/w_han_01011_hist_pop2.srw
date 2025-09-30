$PBExportHeader$w_han_01011_hist_pop2.srw
$PBExportComments$자재소진내역 조정2
forward
global type w_han_01011_hist_pop2 from w_inherite_popup
end type
type rr_2 from roundrectangle within w_han_01011_hist_pop2
end type
end forward

global type w_han_01011_hist_pop2 from w_inherite_popup
integer width = 3072
integer height = 1536
string title = "원자재 소진 수정/삭제"
boolean controlmenu = true
rr_2 rr_2
end type
global w_han_01011_hist_pop2 w_han_01011_hist_pop2

type variables
String is_sidate , is_shpjpno
end variables

on w_han_01011_hist_pop2.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_han_01011_hist_pop2.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;is_shpjpno = gs_code

dw_1.Retrieve(is_shpjpno)

end event

event key;call super::key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose

If keyDown(keyQ!) And keyDown(keyAlt!) Then
	p_exit.TriggerEvent(Clicked!)
End If

If keyDown(keyD!) And keyDown(keyAlt!) Then
	p_inq.TriggerEvent(Clicked!)
End If

If keyDown(keyS!) And keyDown(keyAlt!) Then
	p_choose.TriggerEvent(Clicked!)
End If
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_han_01011_hist_pop2
boolean visible = false
integer x = 923
integer y = 32
integer width = 942
integer height = 164
end type

type p_exit from w_inherite_popup`p_exit within w_han_01011_hist_pop2
integer x = 2478
integer y = 28
string picturename = "C:\erpman\image\조회_up.gif"
end type

event p_exit::clicked;call super::clicked;dw_1.Retrieve(is_shpjpno)

end event

event p_exit::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_han_01011_hist_pop2
integer x = 55
integer y = 28
boolean originalsize = false
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event p_inq::ue_lbuttondown;PictureName = 'C:\erpman\image\삭제_dn.gif'
end event

event p_inq::ue_lbuttonup;PictureName = 'C:\erpman\image\삭제_up.gif'
end event

event p_inq::clicked;call super::clicked;integer	i

If f_msg_delete() = -1 Then Return  //저장 Yes/No ?

For i = dw_1.RowCount() To 1 Step -1
	
	If dw_1.object.chk[i] = 'Y' then		 
		dw_1.DeleteRow(i)
	End If
	
Next

//If dw_1.Update() < 1 then
//	MessageBox("DB Update Error!",SQLCA.SQLErrText)
//	Rollback ;
//	Return
//else
//	Commit ;
//	gs_code = '1'
//	MessageBox("성공","저장성공 하였습니다.")
//End If 
//
end event

type p_choose from w_inherite_popup`p_choose within w_han_01011_hist_pop2
integer x = 2711
integer y = 28
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_choose::clicked;call super::clicked;If dw_1.AcceptText() < 1 then Return

dw_1.AcceptText()

If f_msg_update() = -1 Then Return  //저장 Yes/No ?

If dw_1.Update() < 1 then
	MessageBox("DB Update Error!",SQLCA.SQLErrText)
	Rollback ;
	Return
else
	Commit ;
	gs_code = 'OK'
//	MessageBox("성공","저장성공 하였습니다.")
End If 

Close(Parent)

end event

event p_choose::ue_lbuttondown;PictureName = 'C:\erpman\image\추가_dn.gif'
end event

event p_choose::ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\추가_up.gif'
end event

type dw_1 from w_inherite_popup`dw_1 within w_han_01011_hist_pop2
integer x = 46
integer y = 220
integer width = 2962
integer height = 1200
string dataobject = "d_han_01011_hist_002_pop2"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::itemchanged;call super::itemchanged;If row < 1 Then Return

Dec ld_inqty , ld_qty
String ls_null

SetNull(ls_null)

Choose Case dwo.name
		
	Case 'tuipqty'
		This.object.loss_gubun[row]= 'M'
		
End Choose
end event

event dw_1::itemerror;call super::itemerror;return 1
end event

event dw_1::clicked;call super::clicked;dw_1.SelectRow(0,False)
if row > 0 then dw_1.SelectRow(row,True)

end event

type sle_2 from w_inherite_popup`sle_2 within w_han_01011_hist_pop2
boolean visible = false
integer x = 544
integer y = 2472
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_han_01011_hist_pop2
boolean visible = false
integer x = 672
integer y = 2356
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_han_01011_hist_pop2
boolean visible = false
integer x = 1307
integer y = 2356
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_han_01011_hist_pop2
boolean visible = false
integer x = 992
integer y = 2356
boolean enabled = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_han_01011_hist_pop2
boolean visible = false
integer x = 361
integer y = 2472
boolean enabled = false
end type

type st_1 from w_inherite_popup`st_1 within w_han_01011_hist_pop2
boolean visible = false
integer x = 82
integer y = 2484
end type

type rr_2 from roundrectangle within w_han_01011_hist_pop2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 208
integer width = 2994
integer height = 1224
integer cornerheight = 40
integer cornerwidth = 55
end type

