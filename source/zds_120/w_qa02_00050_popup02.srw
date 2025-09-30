$PBExportHeader$w_qa02_00050_popup02.srw
$PBExportComments$** 수정불합격 처리
forward
global type w_qa02_00050_popup02 from w_inherite_popup
end type
type dw_2 from datawindow within w_qa02_00050_popup02
end type
type p_save from picture within w_qa02_00050_popup02
end type
type rr_1 from roundrectangle within w_qa02_00050_popup02
end type
end forward

global type w_qa02_00050_popup02 from w_inherite_popup
integer width = 4165
integer height = 1064
string title = "공정불량상세내역"
dw_2 dw_2
p_save p_save
rr_1 rr_1
end type
global w_qa02_00050_popup02 w_qa02_00050_popup02

on w_qa02_00050_popup02.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.p_save=create p_save
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.p_save
this.Control[iCurrent+3]=this.rr_1
end on

on w_qa02_00050_popup02.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.p_save)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.Reset()
dw_jogun.InsertRow(0)
dw_jogun.Object.shpjpno[1] = gs_code

dw_2.SetTransObject(SQLCA)

dw_2.Retrieve(gs_code)



end event

type dw_jogun from w_inherite_popup`dw_jogun within w_qa02_00050_popup02
integer x = 23
integer y = 20
integer width = 1573
integer height = 160
string dataobject = "d_qa02_00050_popup02_1"
end type

type p_exit from w_inherite_popup`p_exit within w_qa02_00050_popup02
integer x = 3927
integer y = 32
end type

event p_exit::clicked;call super::clicked;close(parent)
end event

type p_inq from w_inherite_popup`p_inq within w_qa02_00050_popup02
boolean visible = false
integer x = 2661
end type

type p_choose from w_inherite_popup`p_choose within w_qa02_00050_popup02
boolean visible = false
integer x = 2834
end type

type dw_1 from w_inherite_popup`dw_1 within w_qa02_00050_popup02
boolean visible = false
integer x = 46
integer y = 212
integer width = 3131
integer height = 1052
end type

type sle_2 from w_inherite_popup`sle_2 within w_qa02_00050_popup02
end type

type cb_1 from w_inherite_popup`cb_1 within w_qa02_00050_popup02
end type

type cb_return from w_inherite_popup`cb_return within w_qa02_00050_popup02
end type

type cb_inq from w_inherite_popup`cb_inq within w_qa02_00050_popup02
end type

type sle_1 from w_inherite_popup`sle_1 within w_qa02_00050_popup02
end type

type st_1 from w_inherite_popup`st_1 within w_qa02_00050_popup02
end type

type dw_2 from datawindow within w_qa02_00050_popup02
integer x = 46
integer y = 212
integer width = 4050
integer height = 724
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa02_00050_popup02_2"
boolean border = false
boolean livescroll = true
end type

type p_save from picture within w_qa02_00050_popup02
integer x = 3753
integer y = 32
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event clicked;If dw_2.RowCount() < 1 Then Return
If dw_2.AcceptText() < 1 Then Return

If f_msg_update() < 1 Then Return

If dw_2.Update() < 1 Then
	Rollback ;
	f_message_chk(32,'')
	Return
Else
	Commit;
End if
end event

type rr_1 from roundrectangle within w_qa02_00050_popup02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 200
integer width = 4091
integer height = 744
integer cornerheight = 40
integer cornerwidth = 55
end type

