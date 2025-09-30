$PBExportHeader$w_cic00000.srw
$PBExportComments$원가계산실행 명령 등록
forward
global type w_cic00000 from w_inherite
end type
type dw_c from datawindow within w_cic00000
end type
type st_2 from statictext within w_cic00000
end type
type rr_2 from roundrectangle within w_cic00000
end type
type rr_1 from roundrectangle within w_cic00000
end type
end forward

global type w_cic00000 from w_inherite
integer width = 4695
integer height = 2580
string title = "원가계산실행 명령 등록"
boolean maxbox = true
boolean resizable = true
dw_c dw_c
st_2 st_2
rr_2 rr_2
rr_1 rr_1
end type
global w_cic00000 w_cic00000

on w_cic00000.create
int iCurrent
call super::create
this.dw_c=create dw_c
this.st_2=create st_2
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_c
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_cic00000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_c)
destroy(this.st_2)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;ib_any_typing = false

dw_c.InsertRow(0)

dw_insert.SetTransObject(sqlca)
p_inq.Post Event Clicked()

end event

event resize;call super::resize;rr_2.Width 			= NewWidth - 70
dw_insert.Width	= NewWidth - 120

rr_2.Height 		= NewHeight - 240
dw_insert.Height	= NewHeight - 270

end event

type dw_insert from w_inherite`dw_insert within w_cic00000
integer x = 46
integer y = 208
integer width = 4517
integer height = 2032
integer taborder = 70
string dataobject = "d_cic00000_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)

end event

event dw_insert::retrieveend;call super::retrieveend;if rowcount > 0 then This.Event RowFocusChanged(1)

end event

event dw_insert::doubleclicked;call super::doubleclicked;// Datawindow 정렬하기.
//f_sort(This)

If row < 1 Then return 


This.AcceptText()


String	ls_colname, ls_string
ls_colname = dwo.name

If ls_colname = "opdesc" Then 


	ls_string = This.object.opdesc[row]
	openwithparm(w_edit_window, ls_string)
	If Message.StringParm <> "" Then
		This.object.opdesc[row] = Message.StringParm
	End If


ElseIf ls_colname = "query" Then 


	ls_string = This.object.query[row]
	openwithparm(w_edit_window, ls_string)
	If Message.StringParm <> "" Then
		This.object.query[row] = Message.StringParm
	End If

	
ElseIf ls_colname = "cbdesc" Then 


	ls_string = This.object.cbdesc[row]
	openwithparm(w_edit_window, ls_string)
	If Message.StringParm <> "" Then
		This.object.cbdesc[row] = Message.StringParm
	End If

	
End If

end event

type p_delrow from w_inherite`p_delrow within w_cic00000
boolean visible = false
integer x = 4069
integer y = 2596
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_cic00000
boolean visible = false
integer x = 3895
integer y = 2596
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_cic00000
boolean visible = false
integer x = 3680
integer y = 2836
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_cic00000
integer x = 3872
integer y = 16
integer taborder = 30
end type

event p_ins::clicked;call super::clicked;dw_insert.Object.opkind.Initial	= dw_c.object.opkind[1]
dw_insert.Object.cbgbn.Initial	= dw_c.object.cbgbn[1]

If dw_insert.RowCount() < 1 Then
	dw_insert.Insertrow(1)
Else
	dw_insert.Insertrow(dw_insert.GetRow())
End If

end event

type p_exit from w_inherite`p_exit within w_cic00000
integer x = 4393
integer y = 16
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_cic00000
boolean visible = false
integer x = 4375
integer y = 2836
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_cic00000
boolean visible = false
integer x = 3854
integer y = 2836
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cic00000
integer x = 3698
integer y = 16
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string	ls_opkind, ls_cbgbn

dw_c.AcceptText()

ls_opkind = dw_c.object.opkind[1]
ls_cbgbn = dw_c.object.cbgbn[1]


dw_insert.retrieve(ls_opkind, ls_cbgbn )

end event

type p_del from w_inherite`p_del within w_cic00000
integer x = 4046
integer y = 16
integer taborder = 40
end type

event p_del::clicked;call super::clicked;dw_insert.Deleterow(0)

if dw_insert.RowCount() <> 0 Then
	dw_insert.SelectRow(0, FALSE)
	dw_insert.SelectRow(dw_insert.getrow(), TRUE)
end if

end event

type p_mod from w_inherite`p_mod within w_cic00000
integer x = 4219
integer y = 16
end type

event p_mod::clicked;call super::clicked;IF dw_insert.Accepttext() = -1 THEN RETURN

if dw_insert.ModifiedCount() + dw_insert.DeletedCount() = 0 then Return

// 저장메세지 function
IF f_msg_update() = -1 THEN RETURN

IF dw_insert.Update() > 0 THEN			
	COMMIT;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK;
	ib_any_typing = True
END IF

end event

type cb_exit from w_inherite`cb_exit within w_cic00000
end type

type cb_mod from w_inherite`cb_mod within w_cic00000
end type

type cb_ins from w_inherite`cb_ins within w_cic00000
end type

type cb_del from w_inherite`cb_del within w_cic00000
end type

type cb_inq from w_inherite`cb_inq within w_cic00000
end type

type cb_print from w_inherite`cb_print within w_cic00000
end type

type st_1 from w_inherite`st_1 within w_cic00000
end type

type cb_can from w_inherite`cb_can within w_cic00000
end type

type cb_search from w_inherite`cb_search within w_cic00000
end type







type gb_button1 from w_inherite`gb_button1 within w_cic00000
end type

type gb_button2 from w_inherite`gb_button2 within w_cic00000
end type

type dw_c from datawindow within w_cic00000
integer x = 55
integer y = 48
integer width = 1399
integer height = 112
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_cic00000_00"
boolean border = false
boolean livescroll = true
end type

event itemchanged;p_inq.TriggerEvent(Clicked!)

end event

type st_2 from statictext within w_cic00000
integer x = 1463
integer y = 72
integer width = 1632
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "( 두번 클릭하여 편집화면에서 편집할 수 있습니다. )"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_cic00000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 196
integer width = 4539
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_cic00000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 32
integer width = 3072
integer height = 140
integer cornerheight = 40
integer cornerwidth = 55
end type

