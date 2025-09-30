$PBExportHeader$w_mat_05050.srw
$PBExportComments$자재 입출고 현황[품목중분류]
forward
global type w_mat_05050 from w_standard_print
end type
type shl_1 from statichyperlink within w_mat_05050
end type
type shl_2 from statichyperlink within w_mat_05050
end type
type st_1 from statictext within w_mat_05050
end type
type st_2 from statictext within w_mat_05050
end type
type rr_1 from roundrectangle within w_mat_05050
end type
end forward

global type w_mat_05050 from w_standard_print
string title = "자재 입출고 현황[품목중분류]"
string menuname = ""
shl_1 shl_1
shl_2 shl_2
st_1 st_1
st_2 st_2
rr_1 rr_1
end type
global w_mat_05050 w_mat_05050

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_yymm, ls_itcls

ls_yymm  = dw_ip.GetItemString(1, 'yymm')
ls_itcls = dw_ip.GetItemString(1, 'itcls')

IF ls_yymm = '' OR IsNull(ls_yymm) THEN
	f_message_chk(30, '[기준년월]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_yymm,ls_itcls) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

Return 1
end function

on w_mat_05050.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.shl_2=create shl_2
this.st_1=create st_1
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.shl_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.rr_1
end on

on w_mat_05050.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.insertRow(0)

dw_ip.SetItem(1, 'yymm', gs_gubun)
dw_ip.SetItem(1,'itcls', gs_code)
//DataWindowChild state_child
//integer rtncode
//
//rtncode = dw_ip.GetChild('itcls', state_child)
//
//IF rtncode = -1 THEN MessageBox( &
//		"Error", "Not a DataWindowChild")
//CONNECT USING SQLCA;
//state_child.SetTransObject(SQLCA)
//state_child.Retrieve()
////state_child.setItem(1,'itcls',gs_code)
//
SetNull(gs_gubun)
SetNull(gs_code)

wf_retrieve()
end event

type p_preview from w_standard_print`p_preview within w_mat_05050
boolean visible = false
integer x = 2843
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_mat_05050
end type

type p_print from w_standard_print`p_print within w_mat_05050
boolean visible = false
integer x = 3017
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_mat_05050
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_mat_05050
end type



type dw_print from w_standard_print`dw_print within w_mat_05050
integer x = 3255
string dataobject = "d_mat_05050_1"
end type

type dw_ip from w_standard_print`dw_ip within w_mat_05050
integer y = 96
integer width = 1810
integer height = 152
string dataobject = "d_mat_05050"
end type

type dw_list from w_standard_print`dw_list within w_mat_05050
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 268
integer width = 4549
integer height = 2040
string dataobject = "d_mat_05050_1"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 5)  = 'titnm' THEN 
   ll_Row = long(mid(ls_Object, 6, 5))
	this.setrow(ll_row)
	this.setitem(ll_row, 'opt', '1')
ELSE
	this.setitem(this.getrow(), 'opt', '0')
END IF


end event

event dw_list::clicked;call super::clicked;String  ls_Object
Long	  ll_Row

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 5)  = 'titnm' THEN 
   ll_Row = long(mid(ls_Object, 6, 5))
	if ll_Row < 1 or isnull(ll_Row) then return 

	gs_gubun = dw_ip.GetItemString(1, 'yymm')
	gs_code  = dw_ip.GetItemString(1, 'itcls')
  	gs_codename = This.GetItemString(ll_row, 'itcls')

	OpenSheet(w_mat_05060, w_mdi_frame, 0, Layered!)

END IF

end event

type shl_1 from statichyperlink within w_mat_05050
integer x = 69
integer y = 36
integer width = 192
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "년월별"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_mat_05040' then
		lb_isopen = TRUE
		Exit
	else		
		lw_window = parent.GetNextSheet(lw_window)
	end if
LOOP
if lb_isopen then
	lw_window.windowstate = Normal!
	lw_window.SetFocus()
else	
	OpenSheet(w_mat_05040, w_mdi_frame, 0, Layered!)	
end if

close(Parent)
end event

type shl_2 from statichyperlink within w_mat_05050
integer x = 421
integer y = 36
integer width = 370
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "품목중분류별"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_mat_05050
integer x = 283
integer y = 36
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_mat_05050
integer x = 4251
integer y = 200
integer width = 334
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 31778020
string text = "(단위:천원)"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_mat_05050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

