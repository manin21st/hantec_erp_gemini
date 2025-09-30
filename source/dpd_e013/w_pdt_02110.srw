$PBExportHeader$w_pdt_02110.srw
$PBExportComments$** 할당 조회(생산팀별)
forward
global type w_pdt_02110 from w_inherite
end type
type dw_1 from datawindow within w_pdt_02110
end type
type st_2 from statictext within w_pdt_02110
end type
type rr_1 from roundrectangle within w_pdt_02110
end type
end forward

global type w_pdt_02110 from w_inherite
string title = "할당 조회(생산팀별)"
dw_1 dw_1
st_2 st_2
rr_1 rr_1
end type
global w_pdt_02110 w_pdt_02110

type variables

end variables

forward prototypes
public subroutine wf_reset ()
public function integer wf_required_chk (integer i)
public function integer wf_check (long ll_row, integer gub)
end prototypes

public subroutine wf_reset ();dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)
dw_1.SetFocus()

dw_1.setredraw(true)
dw_insert.setredraw(true)

end subroutine

public function integer wf_required_chk (integer i);decimal {3} d_qty, d_addqty, d_unqty, d_isqty

if dw_insert.AcceptText() = -1 then return -1

d_qty     =  dw_insert.GetItemDecimal(i,'hold_qty')
d_addqty  =  dw_insert.GetItemDecimal(i,'addqty')
d_isqty  =  dw_insert.GetItemDecimal(i,'isqty')
d_unqty  =  dw_insert.GetItemDecimal(i,'unqty')
if isnull(d_isqty) then d_isqty = 0
if isnull(d_unqty) then d_unqty = 0

if (isnull(d_qty) or d_qty = 0) and (isnull(d_addqty) or d_addqty = 0 ) then return 1

if d_qty + d_addqty  < d_isqty then 
	f_message_chk(65,'[소요수량]')
	dw_insert.Setcolumn("hold_qty")
	dw_insert.SetFocus()
	return -1
end if

d_unqty = d_qty + d_addqty - d_isqty

dw_insert.setitem(i, 'unqty', d_unqty)

Return 1
end function

public function integer wf_check (long ll_row, integer gub);decimal {3} d_qty, d_addqty, d_isqty

dw_insert.accepttext()

d_qty = dw_insert.GetItemDecimal(ll_row, 'hold_qty')
d_addqty = dw_insert.GetItemDecimal(ll_row, 'addqty')
d_isqty = dw_insert.GetItemDecimal(ll_row, 'isqty')

if isnull(d_qty) or d_qty = 0 then return 1
if isnull(d_addqty) or d_addqty = 0 then return 1

if isnull(d_isqty) then d_isqty = 0 

if d_qty + d_addqty  < d_isqty then 
	if gub = 1 then 
   	f_message_chk(65,'[소요수량]')
	   dw_insert.SetItem(ll_row,"hold_qty",0)
		dw_insert.Setcolumn("hold_qty")
		dw_insert.SetFocus()
		return -1
	else  
   	f_message_chk(65,'[추가소요량]')
      dw_insert.SetItem(ll_row,"addqty",0)
		dw_insert.Setcolumn("addqty")
		dw_insert.SetFocus()
		return -1
   end if
end if

return 1
end function

on w_pdt_02110.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.st_2=create st_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_pdt_02110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()



end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_pdt_02110
integer x = 55
integer y = 268
integer width = 4521
integer height = 1912
integer taborder = 20
string dataobject = "d_pdt_02110_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemchanged;String snull, s_date
long ll_row
decimal {3} d_qty

SetNull(snull)
ll_row = this.getrow()
IF this.GetColumnName() ="hold_qty" THEN  //소요수량
   d_qty = long(this.Gettext())
	
	if d_qty = 0 or isnull(d_qty) then return 
   if wf_check(ll_row, 1) = -1 then return 1
ELSEIF this.GetColumnName() ="addqty" THEN  //추가소요량
   d_qty = long(this.Gettext())
	
	if d_qty = 0 or isnull(d_qty) then return 
   if wf_check(ll_row, 2) = -1 then return 1
ELSEIF this.GetColumnName() ="rqdat" THEN  //출고요구일
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[출고요구일]')
		this.SetItem(ll_row,"rqdat",snull)
		this.Setcolumn("rqdat")
		this.SetFocus()
		Return 1
	ELSE
		IF s_date < f_today() then 
			f_message_chk(64,'[출고요구일]')
			this.SetItem(ll_row,"rqdat",snull)
			this.Setcolumn("rqdat")
			this.SetFocus()
			Return 1
		END IF
	END IF
END IF	
end event

event dw_insert::itemerror;RETURN 1
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02110
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02110
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_02110
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_02110
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_02110
end type

type p_can from w_inherite`p_can within w_pdt_02110
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdt_02110
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_02110
integer x = 4096
end type

event p_inq::clicked;call super::clicked;string s_team, s_frwrk, s_towrk, s_itnbr

if dw_1.AcceptText() = -1 then return 

s_team = trim(dw_1.GetItemString(1,'steam'))

if isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	

s_frwrk  = dw_1.GetItemString(1,"fr_wkctr")
s_towrk  = dw_1.GetItemString(1,"to_wkctr")
s_itnbr  = dw_1.GetItemString(1,"itnbr")

IF s_frwrk = "" OR IsNull(s_frwrk) THEN 
	s_frwrk = '.'
END IF
IF s_towrk = "" OR IsNull(s_towrk) THEN 
	s_towrk = 'zzzzzz'
END IF
IF s_itnbr = "" OR IsNull(s_itnbr) THEN 
	s_itnbr = ''
END IF

if s_frwrk > s_towrk then 
	f_message_chk(34,'[작업장]')
	dw_1.Setcolumn('fr_wkctr')
	dw_1.SetFocus()
	return 
end if	
if dw_insert.Retrieve(gs_sabu, s_team, s_frwrk, s_towrk, s_itnbr+'%') <= 0 then 
	f_message_chk(50,'')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
end if	
	
ib_any_typing = FALSE




end event

type p_del from w_inherite`p_del within w_pdt_02110
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_pdt_02110
integer y = 5000
end type

type cb_exit from w_inherite`cb_exit within w_pdt_02110
integer x = 4178
integer y = 3000
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02110
integer x = 1664
integer y = 2488
integer taborder = 40
boolean enabled = false
end type

event cb_mod::clicked;call super::clicked;Int i

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_update() = -1 then return

if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	

end event

type cb_ins from w_inherite`cb_ins within w_pdt_02110
integer x = 562
integer y = 2384
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_02110
integer x = 2523
integer y = 2420
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02110
integer x = 3977
integer y = 3000
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_pdt_02110
integer x = 1961
integer y = 2492
end type

type st_1 from w_inherite`st_1 within w_pdt_02110
end type

type cb_can from w_inherite`cb_can within w_pdt_02110
integer x = 3826
integer y = 3000
integer taborder = 50
end type

type cb_search from w_inherite`cb_search within w_pdt_02110
integer x = 1326
integer y = 2520
integer width = 434
string text = ""
end type

event cb_search::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 

gs_code = trim(dw_1.GetItemString(1,'baljpno'))

if isnull(gs_code) or gs_code = "" then
	f_message_chk(30,'[발주번호]')
	dw_1.Setcolumn('baljpno')
	dw_1.SetFocus()
	return
end if	

open(w_imt_02041)
end event





type gb_10 from w_inherite`gb_10 within w_pdt_02110
integer y = 5000
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02110
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02110
end type

type dw_1 from datawindow within w_pdt_02110
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 32
integer y = 60
integer width = 3717
integer height = 148
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_02110_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;///////////////////////////////////////////////////////////////////////////
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

IF this.GetColumnName() = "fr_wkctr"	THEN
	
   gs_code = this.GetText()
	open(w_workplace_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "fr_wkctr", 	 gs_Code)
ELSEIF this.GetColumnName() = "to_wkctr"	THEN
	
   gs_code = this.GetText()
	open(w_workplace_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "to_wkctr", 	 gs_Code)
ELSEIF this.GetColumnName() = 'itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
	
END IF	
end event

event itemchanged;String sitnbr, sitdsc, sispec
int    ireturn

IF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	RETURN ireturn
END IF
end event

type st_2 from statictext within w_pdt_02110
integer x = 1710
integer y = 2236
integer width = 1193
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "현재 작업 진행 중인 지시내역만 조회 됩니다."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_02110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 256
integer width = 4562
integer height = 1936
integer cornerheight = 40
integer cornerwidth = 55
end type

