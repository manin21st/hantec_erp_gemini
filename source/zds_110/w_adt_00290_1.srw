$PBExportHeader$w_adt_00290_1.srw
$PBExportComments$작업지시 등록(ADT)
forward
global type w_adt_00290_1 from window
end type
type dw_list from u_key_enter within w_adt_00290_1
end type
type dw_wkctr from datawindow within w_adt_00290_1
end type
type lv_list from listview within w_adt_00290_1
end type
type rr_1 from roundrectangle within w_adt_00290_1
end type
type rr_2 from roundrectangle within w_adt_00290_1
end type
end forward

global type w_adt_00290_1 from window
integer width = 4489
integer height = 1080
windowtype windowtype = child!
long backcolor = 32106727
string icon = "AppIcon!"
boolean center = true
dw_list dw_list
dw_wkctr dw_wkctr
lv_list lv_list
rr_1 rr_1
rr_2 rr_2
end type
global w_adt_00290_1 w_adt_00290_1

type variables
String is_sysno

// m환산기준
Dec idMeter
end variables

forward prototypes
public function integer wf_setmenu (string arg_msterno)
end prototypes

public function integer wf_setmenu (string arg_msterno);ListviewItem		lvi_Current
Long					ix
Int j, li_count
Dec dwidth
String sTitle

// 생성된 내역 삭제
lv_list.DeleteItems()
dw_list.Reset()

dw_wkctr.Retrieve(gs_sabu, arg_msterno, idMeter)

li_count = dw_wkctr.RowCount()
If li_count <= 0 Then Return 1

dwidth = (lv_list.Width )/li_count
//1자간 폭을 대략 90으로 Setting 
j = Truncate(dwidth/80,0)

For ix = 1 To dw_wkctr.RowCount()
	lvi_Current.Data  = Trim(dw_wkctr.GetItemString(ix, 'wkctr'))
//	lvi_Current.Label = Trim(dw_wkctr.GetItemString(ix, 'wcdsc'))

	sTitle = Trim(dw_wkctr.GetItemString(ix, 'wcdsc'))
	if j < Len(sTitle) then 
		lvi_Current.Label = Left(sTitle,(j+2)) + '..'
	else 
		lvi_Current.Label = sTitle
	end if
	lvi_Current.itemx = (ix - 1) * 500
	
	lvi_Current.itemy = 0
	lvi_Current.PictureIndex = 1
	lv_list.additem(lvi_Current)
Next
lv_list.Scrolling = False

is_sysno = arg_msterno

return 1
end function

on w_adt_00290_1.create
this.dw_list=create dw_list
this.dw_wkctr=create dw_wkctr
this.lv_list=create lv_list
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.dw_list,&
this.dw_wkctr,&
this.lv_list,&
this.rr_1,&
this.rr_2}
end on

on w_adt_00290_1.destroy
destroy(this.dw_list)
destroy(this.dw_wkctr)
destroy(this.lv_list)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;
dw_wkctr.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

//m환산기준
SELECT TO_NUMBER(DATANAME) INTO :idMeter FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 2 AND LINENO = :gs_saupj;
If IsNull(idMeter) Then idMeter = 500000
end event

type dw_list from u_key_enter within w_adt_00290_1
integer x = 18
integer y = 8
integer width = 4434
integer height = 724
integer taborder = 30
string dataobject = "d_adt_00290_1_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type dw_wkctr from datawindow within w_adt_00290_1
boolean visible = false
integer y = 172
integer width = 686
integer height = 176
integer taborder = 20
string title = "none"
string dataobject = "d_adt_00290_4"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type lv_list from listview within w_adt_00290_1
integer x = 27
integer y = 756
integer width = 4434
integer height = 180
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean border = false
boolean buttonheader = false
boolean showheader = false
boolean trackselect = true
boolean oneclickactivate = true
boolean underlinehot = true
string largepicturename[] = {"Custom092!"}
long largepicturemaskcolor = 536870912
string smallpicturename[] = {""}
long smallpicturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

event clicked;ListViewItem		llvi_Current
String            sWkctr

If index <= 0 Then Return

If GetItem(index, llvi_Current) = -1 Then Return

sWkctr = llvi_Current.Data
	
dw_list.Retrieve(gs_sabu, is_sysno, swkctr,gs_saupj, idMeter)

Return 1
end event

type rr_1 from roundrectangle within w_adt_00290_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 4
integer width = 4462
integer height = 736
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_adt_00290_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 748
integer width = 4462
integer height = 196
integer cornerheight = 40
integer cornerwidth = 55
end type

