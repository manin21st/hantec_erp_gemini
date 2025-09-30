$PBExportHeader$w_pdt_09050.srw
$PBExportComments$�� ���� ��ȹ �� ����[��]
forward
global type w_pdt_09050 from w_standard_print
end type
type shl_1 from statichyperlink within w_pdt_09050
end type
type shl_2 from statichyperlink within w_pdt_09050
end type
type st_1 from statictext within w_pdt_09050
end type
type rr_1 from roundrectangle within w_pdt_09050
end type
end forward

global type w_pdt_09050 from w_standard_print
string title = "�������(ǰ���ߺз�)"
string menuname = ""
boolean maxbox = true
shl_1 shl_1
shl_2 shl_2
st_1 st_1
rr_1 rr_1
end type
global w_pdt_09050 w_pdt_09050

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year, ls_pdtgu

ls_year = dw_ip.GetItemString(1, 'year')
ls_pdtgu = dw_ip.GetItemString(1, 'pdtgu')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[���س⵵]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year+'0101', ls_year+'1231', ls_pdtgu, gs_codename) <= 0 THEN
	Return -1
END IF

Return 1
end function

on w_pdt_09050.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.shl_2=create shl_2
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.shl_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_pdt_09050.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.st_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'year', gs_gubun)
dw_ip.SetItem(1, 'pdtgu', gs_code)
dw_ip.SetItem(1, 'titnm', gs_codename2)

//SetNull(gs_gubun)
//SetNull(gs_code)
//
wf_retrieve()
end event

type p_preview from w_standard_print`p_preview within w_pdt_09050
boolean visible = false
integer x = 2843
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_pdt_09050
end type

type p_print from w_standard_print`p_print within w_pdt_09050
boolean visible = false
integer x = 3017
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_09050
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_pdt_09050
end type



type dw_print from w_standard_print`dw_print within w_pdt_09050
integer x = 3255
string dataobject = "d_pdt_09020_1"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_09050
integer x = 14
integer y = 96
integer width = 2555
integer height = 152
string dataobject = "d_pdt_09050_2"
end type

type dw_list from w_standard_print`dw_list within w_pdt_09050
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 268
integer width = 4549
integer height = 1996
string dataobject = "d_pdt_09050_1"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

IF this.Rowcount() < 1 then return 0

ls_Object = Lower(This.GetObjectAtPointer())

//IF mid(ls_Object, 1, 5)  = 'jocod' THEN 
//   ll_Row = long(mid(ls_Object, 6, 5))
//	this.setrow(ll_row)
//	this.setitem(ll_row, 'opt', '1')
IF mid(ls_Object, 1, 5)  = 'titnm' THEN 
   ll_Row = long(mid(ls_Object, 6, 5))
	this.setrow(ll_row)
	this.setitem(ll_row, 'opt', '2')
ELSE
	this.setitem(this.getrow(), 'opt', '0')
END IF
end event

event dw_list::clicked;call super::clicked;String  ls_Object
Long	  ll_Row
Boolean	lb_isopen
Window	lw_window
	
IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 5)  = 'titnm' THEN 
   ll_Row = long(mid(ls_Object, 6, 3))
	if ll_Row < 1 or isnull(ll_Row) then return 
	
	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = This.GetItemString(row, 'ittyp')
	gs_codename = This.GetItemString(row, 'itcls')
	gs_codename2 = This.GetItemString(row, 'titnm')	
	
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_pdt_09060' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	if lb_isopen then Close(w_pdt_09060)		

	OpenSheet(w_pdt_09060, w_mdi_frame, 0, Layered!)

END IF



end event

type shl_1 from statichyperlink within w_pdt_09050
integer x = 69
integer y = 36
integer width = 251
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "��з���"
alignment alignment = center!
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_pdt_09045' then
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
	OpenSheet(w_pdt_09045, w_mdi_frame, 0, Layered!)	
end if
end event

type shl_2 from statichyperlink within w_pdt_09050
integer x = 462
integer y = 36
integer width = 251
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "�ߺз���"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pdt_09050
integer x = 325
integer y = 36
integer width = 114
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = ">>"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_09050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

