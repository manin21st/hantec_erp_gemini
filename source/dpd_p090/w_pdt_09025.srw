$PBExportHeader$w_pdt_09025.srw
$PBExportComments$생산효율 종합분석-권
forward
global type w_pdt_09025 from w_standard_print
end type
type shl_1 from statichyperlink within w_pdt_09025
end type
type shl_2 from statichyperlink within w_pdt_09025
end type
type st_1 from statictext within w_pdt_09025
end type
type shl_3 from statichyperlink within w_pdt_09025
end type
type st_2 from statictext within w_pdt_09025
end type
type rr_1 from roundrectangle within w_pdt_09025
end type
end forward

global type w_pdt_09025 from w_standard_print
string title = "작업장별 현황"
string menuname = ""
boolean maxbox = true
shl_1 shl_1
shl_2 shl_2
st_1 st_1
shl_3 shl_3
st_2 st_2
rr_1 rr_1
end type
global w_pdt_09025 w_pdt_09025

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();IF dw_ip.AcceptText() = -1 THEN Return -1

String	ls_year, ls_pdtgu

ls_year = dw_ip.GetItemString(1, 'year')
ls_pdtgu = dw_ip.GetItemString(1, 'jocod')

IF ls_year = '' OR IsNull(ls_year) THEN
	f_message_chk(30, '[기준년도]')
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_list.Retrieve(ls_year+'0101', ls_year+'1231', ls_pdtgu) <= 0 THEN
	f_message_chk(50, '[]')
	Return -1
END IF

Return 1
end function

on w_pdt_09025.create
int iCurrent
call super::create
this.shl_1=create shl_1
this.shl_2=create shl_2
this.st_1=create st_1
this.shl_3=create shl_3
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.shl_1
this.Control[iCurrent+2]=this.shl_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.shl_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.rr_1
end on

on w_pdt_09025.destroy
call super::destroy
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.st_1)
destroy(this.shl_3)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_ip.SetItem(1, 'year', gs_gubun)
dw_ip.SetItem(1, 'pdtgu', gs_code)
dw_ip.SetItem(1, 'jocod', gs_codename)
dw_ip.SetItem(1, 'jonam', gs_codename2)

SetNull(gs_gubun)
SetNull(gs_code)

p_retrieve.PostEvent(clicked!)
end event

type p_preview from w_standard_print`p_preview within w_pdt_09025
boolean visible = false
integer x = 2843
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_pdt_09025
end type

type p_print from w_standard_print`p_print within w_pdt_09025
boolean visible = false
integer x = 3017
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_09025
integer x = 4265
end type







type st_10 from w_standard_print`st_10 within w_pdt_09025
end type



type dw_print from w_standard_print`dw_print within w_pdt_09025
integer x = 3255
string dataobject = "d_pdt_09020_1"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_09025
integer x = 14
integer y = 96
integer width = 3378
integer height = 152
string dataobject = "d_pdt_09025_2"
end type

type dw_list from w_standard_print`dw_list within w_pdt_09025
event ue_mousemove pbm_mousemove
integer x = 46
integer y = 268
integer width = 4549
integer height = 2040
string dataobject = "d_pdt_09025_1"
boolean border = false
end type

event dw_list::ue_mousemove;String ls_Object
Long	 ll_Row

IF this.Rowcount() < 1 then return 

ls_Object = Lower(This.GetObjectAtPointer())

IF mid(ls_Object, 1, 7)  = 'ntime_t' THEN 
   ll_Row = long(mid(ls_Object, 9))
	this.setrow(ll_row)
	this.setitem(ll_row, 'opt', '1')
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

IF mid(ls_Object, 1, 7)  = 'ntime_t' THEN 
	
   ll_Row = long(mid(ls_Object, 9))
	if ll_Row < 1 or isnull(ll_Row) then return 

	gs_gubun = dw_ip.GetItemString(1, 'year')
	gs_code = This.GetItemString(row, 'wkctr')
	gs_codename = This.GetItemString(row, 'wcdsc')
	gs_codename2 = dw_ip.GetItemString(1, 'pdtgu') + dw_ip.GetItemString(1, 'jonam')

	lb_isopen = FALSE
	lw_window = parent.GetFirstSheet()
	DO WHILE IsValid(lw_window)
		if ClassName(lw_window) = 'w_pdt_09030' then
			lb_isopen = TRUE
			Exit
		else		
			lw_window = parent.GetNextSheet(lw_window)
		end if
	LOOP
	if lb_isopen then Close(w_pdt_09030)		

	OpenSheet(w_pdt_09030, w_mdi_frame, 0, Layered!)
END IF
end event

type shl_1 from statichyperlink within w_pdt_09025
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
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
string text = "생산팀별"
alignment alignment = center!
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

type shl_2 from statichyperlink within w_pdt_09025
integer x = 443
integer y = 36
integer width = 261
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
string text = "작업조별"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;Boolean				lb_isopen
Window				lw_window

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
if lb_isopen then
	lw_window.windowstate = Normal!
	lw_window.SetFocus()
else	
	OpenSheet(w_pdt_09020, w_mdi_frame, 0, Layered!)	
end if
end event

type st_1 from statictext within w_pdt_09025
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

type shl_3 from statichyperlink within w_pdt_09025
integer x = 827
integer y = 36
integer width = 265
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
string text = "작업장별"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdt_09025
integer x = 718
integer y = 32
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

type rr_1 from roundrectangle within w_pdt_09025
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

