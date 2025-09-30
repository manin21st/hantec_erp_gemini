$PBExportHeader$w_pdt_09012.srw
$PBExportComments$생산효율 종합분석-권
forward
global type w_pdt_09012 from w_standard_print
end type
type shl_1 from statichyperlink within w_pdt_09012
end type
type st_1 from statictext within w_pdt_09012
end type
type shl_2 from statichyperlink within w_pdt_09012
end type
type rr_1 from roundrectangle within w_pdt_09012
end type
end forward

global type w_pdt_09012 from w_standard_print
string title = "작업조별 현황"
string menuname = ""
boolean maxbox = true
shl_1 shl_1
st_1 st_1
shl_2 shl_2
rr_1 rr_1
end type
global w_pdt_09012 w_pdt_09012

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year, ls_pdtgu

ls_year = dw_ip.GetItemString(1, 'year')
ls_pdtgu = dw_ip.GetItemString(1, 'pdtgu')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년도]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year+'0101', ls_year+'1231', ls_pdtgu) <= 0 THEN
	Return -1
END IF

Return 1
end function

on w_pdt_09012.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.st_1=create st_1
this.shl_2=create shl_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.shl_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_pdt_09012.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.st_1)
destroy(this.shl_2)
destroy(this.rr_1)
end on

event open;call super::open;String	ls_dw

ls_dw = Message.StringParm

dw_list.DataObject = ls_dw
dw_list.SetTransObject(Sqlca)
dw_ip.SetItem(1, 'year', gs_gubun)
dw_ip.SetItem(1, 'pdtgu', gs_code)
dw_ip.SetItem(1, 'timenm', gs_codename)

SetNull(gs_gubun)
SetNull(gs_code)

p_retrieve.PostEvent(clicked!)
end event

type p_preview from w_standard_print`p_preview within w_pdt_09012
boolean visible = false
integer x = 3141
integer y = 44
end type

type p_exit from w_standard_print`p_exit within w_pdt_09012
end type

type p_print from w_standard_print`p_print within w_pdt_09012
boolean visible = false
integer x = 3314
integer y = 44
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_09012
integer x = 4270
end type







type st_10 from w_standard_print`st_10 within w_pdt_09012
end type



type dw_print from w_standard_print`dw_print within w_pdt_09012
string dataobject = "d_pdt_09010_1"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_09012
integer x = 18
integer y = 96
integer width = 2203
integer height = 152
string dataobject = "d_pdt_09012_2"
end type

type dw_list from w_standard_print`dw_list within w_pdt_09012
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 268
integer width = 4558
integer height = 2052
string dataobject = "d_pdt_09012_4"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 5)  = 'jonam' THEN 
   ll_Row = long(mid(ls_Object, 7))
	this.setrow(ll_row)
	this.setitem(ll_row, 'opt', '1')
ELSE
	this.setitem(this.getrow(), 'opt', '0')
END IF


end event

event dw_list::clicked;call super::clicked;String  	ls_Object, ls_dw, ls_gubun
Long	  	ll_Row
Boolean	lb_isopen
Window	lw_window
	
IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 5)  = 'jonam' THEN 
	
   ll_Row = long(mid(ls_Object, 7))
	if ll_Row < 1 or isnull(ll_Row) then return 

	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = This.GetItemString(row, 'jocod')
	gs_codename = This.GetItemString(row, 'jonam')
	gs_codename2 = dw_ip.GetItemString(1, 'pdtgu') + dw_ip.GetItemString(1, 'timenm')
	
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_pdt_09014' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	if lb_isopen then Close(w_pdt_09014)		
	
	ls_gubun = dw_ip.GetItemString(1, 'timenm')
	
	Choose Case ls_gubun
		Case 	'보유공수'
			ls_dw = 'd_pdt_09014_1'
		Case	'투입공수'
			ls_dw = 'd_pdt_09014_3'
		Case	'비가동공수'
			ls_dw = 'd_pdt_09014_4'
		Case	'실가동공수'
			ls_dw = 'd_pdt_09014_5'
	End Choose
	
	OpenSheetWithParm(w_pdt_09014, ls_dw, w_mdi_frame, 0, Layered!)
	
END IF
end event

type shl_1 from statichyperlink within w_pdt_09012
integer x = 41
integer y = 36
integer width = 251
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
string text = "생산팀별"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;Boolean				lb_isopen
Window				lw_window

lb_isopen = FALSE
lw_window = parent.GetFirstSheet()
DO WHILE IsValid(lw_window)
	if ClassName(lw_window) = 'w_pdt_09010' then
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
	OpenSheet(w_pdt_09010, w_mdi_frame, 0, Layered!)	
end if
end event

type st_1 from statictext within w_pdt_09012
integer x = 334
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

type shl_2 from statichyperlink within w_pdt_09012
integer x = 443
integer y = 36
integer width = 311
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
string text = "작업조별"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_09012
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 260
integer width = 4576
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

