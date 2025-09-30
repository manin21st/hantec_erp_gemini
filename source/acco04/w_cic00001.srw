$PBExportHeader$w_cic00001.srw
$PBExportComments$원가계산실행_LOG조회
forward
global type w_cic00001 from w_inherite
end type
type dw_c from datawindow within w_cic00001
end type
type shl_1 from statichyperlink within w_cic00001
end type
type rr_2 from roundrectangle within w_cic00001
end type
type rr_1 from roundrectangle within w_cic00001
end type
end forward

global type w_cic00001 from w_inherite
integer width = 4667
integer height = 2596
string title = "원가계산실행_LOG조회"
dw_c dw_c
shl_1 shl_1
rr_2 rr_2
rr_1 rr_1
end type
global w_cic00001 w_cic00001

on w_cic00001.create
int iCurrent
call super::create
this.dw_c=create dw_c
this.shl_1=create shl_1
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_c
this.Control[iCurrent+2]=this.shl_1
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_cic00001.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_c)
destroy(this.shl_1)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;ib_any_typing = false

dw_c.InsertRow(0)
dw_c.object.workym[1] = string(Today(), "YYYYMMDD")

p_inq.Post Event Clicked()

end event

type dw_insert from w_inherite`dw_insert within w_cic00001
integer x = 46
integer y = 204
integer width = 4544
integer height = 2060
integer taborder = 20
string dataobject = "d_cic00001_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)

end event

event dw_insert::retrieveend;call super::retrieveend;if rowcount > 0 then This.Event RowFocusChanged(1)

end event

event dw_insert::constructor;call super::constructor;This.SetTransObject(sqlca)

end event

event dw_insert::doubleclicked;call super::doubleclicked;// Datawindow 정렬하기.
//f_sort(This)

If row < 1 Then return 


This.AcceptText()


String	ls_colname, ls_string
ls_colname = dwo.name

If ls_colname = "trace_value" Then 


	ls_string = This.object.trace_value[row]
	openwithparm(w_edit_window, ls_string)


End If

end event

type p_delrow from w_inherite`p_delrow within w_cic00001
boolean visible = false
integer x = 4197
integer y = 2840
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_cic00001
boolean visible = false
integer x = 4027
integer y = 2836
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_cic00001
boolean visible = false
integer x = 3680
integer y = 2836
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_cic00001
boolean visible = false
integer x = 3904
integer y = 2676
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_cic00001
integer x = 4430
integer y = 16
integer taborder = 40
end type

type p_can from w_inherite`p_can within w_cic00001
boolean visible = false
integer x = 4375
integer y = 2836
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_cic00001
boolean visible = false
integer x = 3854
integer y = 2836
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cic00001
integer x = 4251
integer y = 16
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;string	ls_date_val, ls_workym, ls_data_gbn

dw_c.AcceptText()

ls_workym	= dw_c.object.workym[1]


if IsNull(ls_workym) then
	MessageBox("작업일자 입력확인", "작업일자 조회조건을 설정하십시오.")
	Return
end if

ls_date_val = left(ls_workym, 4) + "." + mid(ls_workym, 5, 2) + "." + right(ls_workym, 2)
if Not IsDate(ls_date_val) then
	MessageBox("작업일자 입력확인", "작업일자 조회조건을 확인하십시오.")
	Return
end if


dw_insert.ReSet()
dw_insert.retrieve(ls_workym)

end event

type p_del from w_inherite`p_del within w_cic00001
boolean visible = false
integer x = 4078
integer y = 2676
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_cic00001
boolean visible = false
integer x = 4251
integer y = 2676
integer taborder = 0
end type

type cb_exit from w_inherite`cb_exit within w_cic00001
end type

type cb_mod from w_inherite`cb_mod within w_cic00001
end type

type cb_ins from w_inherite`cb_ins within w_cic00001
end type

type cb_del from w_inherite`cb_del within w_cic00001
end type

type cb_inq from w_inherite`cb_inq within w_cic00001
end type

type cb_print from w_inherite`cb_print within w_cic00001
end type

type st_1 from w_inherite`st_1 within w_cic00001
end type

type cb_can from w_inherite`cb_can within w_cic00001
end type

type cb_search from w_inherite`cb_search within w_cic00001
end type







type gb_button1 from w_inherite`gb_button1 within w_cic00001
end type

type gb_button2 from w_inherite`gb_button2 within w_cic00001
end type

type dw_c from datawindow within w_cic00001
event ue_dwnkey pbm_dwnkey
integer x = 73
integer y = 48
integer width = 745
integer height = 104
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_cic00001_00"
boolean border = false
boolean livescroll = true
end type

event ue_dwnkey;if KeyDown(KeyEnter!) then
	p_inq.TriggerEvent(Clicked!)
end if

end event

event itemchanged;String	ls_date_val

Choose Case GetColumnName()
	Case "workym"

		if IsNull(data) then
			MessageBox("작업일자 입력확인", "작업일자 조회조건을 설정하십시오.")
			Return 1
		end if

		ls_date_val = left(data, 4) + "." + mid(data, 5, 2) + "." + right(data, 2)
		if Not IsDate(ls_date_val) then
			MessageBox("작업일자 입력확인", "작업일자 조회조건을 확인하십시오.")
			Return 1
		end if

	Case Else

End Choose

end event

event itemerror;Return 1

end event

event constructor;This.SetTransObject(sqlca)

end event

type shl_1 from statichyperlink within w_cic00001
integer x = 3593
integer y = 64
integer width = 631
integer height = 64
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 32106727
string text = "Trace Log 삭제"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;
Execute immediate 'TRUNCATE TABLE CIC_PROCESS_LOG' ;


MessageBox("확인", "Trace Log 삭제 작업이 정상처리 되었습니다.")


p_inq.Post Event Clicked()

end event

type rr_2 from roundrectangle within w_cic00001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 192
integer width = 4567
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_cic00001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 32
integer width = 786
integer height = 136
integer cornerheight = 40
integer cornerwidth = 55
end type

