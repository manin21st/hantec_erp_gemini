$PBExportHeader$w_pdt_09010.srw
$PBExportComments$생산효율 종합분석-권
forward
global type w_pdt_09010 from w_standard_print
end type
type shl_1 from statichyperlink within w_pdt_09010
end type
type rr_1 from roundrectangle within w_pdt_09010
end type
end forward

global type w_pdt_09010 from w_standard_print
string title = "생산 효율현황"
string menuname = ""
boolean maxbox = true
shl_1 shl_1
rr_1 rr_1
end type
global w_pdt_09010 w_pdt_09010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year

ls_year = dw_ip.GetItemString(1, 'year')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년도]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year+'0101', ls_year+'1231') <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

Return 1
end function

on w_pdt_09010.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdt_09010.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1,'year', Left(f_today(),4))
end event

type p_preview from w_standard_print`p_preview within w_pdt_09010
boolean visible = false
integer x = 3141
integer y = 44
end type

type p_exit from w_standard_print`p_exit within w_pdt_09010
end type

type p_print from w_standard_print`p_print within w_pdt_09010
boolean visible = false
integer x = 3314
integer y = 44
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_09010
integer x = 4270
end type







type st_10 from w_standard_print`st_10 within w_pdt_09010
end type



type dw_print from w_standard_print`dw_print within w_pdt_09010
string dataobject = "d_pdt_09010_1"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_09010
integer x = 18
integer y = 96
integer width = 690
integer height = 152
string dataobject = "d_pdt_09010_2"
end type

type dw_list from w_standard_print`dw_list within w_pdt_09010
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 268
integer width = 4558
integer height = 2052
string dataobject = "d_pdt_09010_1"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 5)  = 'pdtgu' THEN 
   ll_Row = long(mid(ls_Object, 6, 5))
	this.setrow(ll_row)
	this.setitem(ll_row, 'opt', '1')
ELSEIF mid(ls_Object, 1, 7)  = 'ntime_t' THEN 
   ll_Row = long(mid(ls_Object, 8, 5))
	this.setrow(ll_row)
	this.setitem(ll_row, 'opt', '2')
ELSEIF mid(ls_Object, 1, 7)  = 'ktime_t' THEN 
   ll_Row = long(mid(ls_Object, 8, 5))
	this.setrow(ll_row)
	this.setitem(ll_row, 'opt', '3')
ELSEIF mid(ls_Object, 1, 7)  = 'ttime_t' THEN 
   ll_Row = long(mid(ls_Object, 8, 5))
	this.setrow(ll_row)
	this.setitem(ll_row, 'opt', '4')
ELSEIF mid(ls_Object, 1, 7)  = 'jtime_t' THEN 
   ll_Row = long(mid(ls_Object, 8, 5))
	this.setrow(ll_row)
	this.setitem(ll_row, 'opt', '5')	
ELSE
	this.setitem(this.getrow(), 'opt', '0')
END IF


end event

event dw_list::clicked;call super::clicked;String  	ls_Object
Long	  	ll_Row
Boolean	lb_isopen
Window	lw_window
	
IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 5)  = 'pdtgu' THEN 
	
   ll_Row = long(mid(ls_Object, 6, 3))
	if ll_Row < 1 or isnull(ll_Row) then return 

	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = This.GetItemString(row, 'pdtgu')
	
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_pdt_09020' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	if lb_isopen then Close(w_pdt_09020)		

	OpenSheet(w_pdt_09020, w_mdi_frame, 0, Layered!)
ELSEIF mid(ls_Object, 1, 7)  = 'ntime_t' THEN 
	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = This.GetItemString(row, 'pdtgu')
	gs_codename = '비가동공수'
		
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_pdt_09012' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	if lb_isopen then Close(w_pdt_09012)		

	OpenSheetWithparm(w_pdt_09012, 'd_pdt_09012_4', w_mdi_frame, 0, Layered!)
ELSEIF mid(ls_Object, 1, 7)  = 'ktime_t' THEN 
	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = This.GetItemString(row, 'pdtgu')
	gs_codename = '보유공수'
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_pdt_09012' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	if lb_isopen then Close(w_pdt_09012)		

	OpenSheetWithparm(w_pdt_09012, 'd_pdt_09012_1', w_mdi_frame, 0, Layered!)
ELSEIF mid(ls_Object, 1, 7)  = 'ttime_t' THEN 
	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = This.GetItemString(row, 'pdtgu')
	gs_codename = '투입공수'
	
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_pdt_09012' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	if lb_isopen then Close(w_pdt_09012)		

	OpenSheetWithparm(w_pdt_09012, 'd_pdt_09012_3', w_mdi_frame, 0, Layered!)
ELSEIF mid(ls_Object, 1, 7)  = 'ntime_t' THEN 
	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = This.GetItemString(row, 'pdtgu')
	gs_codename = '비가동공수'
	
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_pdt_09012' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	if lb_isopen then Close(w_pdt_09012)		

	OpenSheetWithparm(w_pdt_09012, 'd_pdt_09012_4', w_mdi_frame, 0, Layered!)
ELSEIF mid(ls_Object, 1, 7)  = 'jtime_t' THEN 
	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = This.GetItemString(row, 'pdtgu')
	gs_codename = '실가동공수'
	
	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_pdt_09012' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	if lb_isopen then Close(w_pdt_09012)		

	OpenSheetWithparm(w_pdt_09012, 'd_pdt_09012_5', w_mdi_frame, 0, Layered!)	
END IF



end event

type shl_1 from statichyperlink within w_pdt_09010
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
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "생산팀별"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_09010
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

