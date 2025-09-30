$PBExportHeader$w_pdt_02100.srw
$PBExportComments$** 할당 조회(작업지시별)
forward
global type w_pdt_02100 from w_inherite
end type
type dw_1 from datawindow within w_pdt_02100
end type
type rr_1 from roundrectangle within w_pdt_02100
end type
end forward

global type w_pdt_02100 from w_inherite
string title = "할당 조회(작업지시별)"
dw_1 dw_1
rr_1 rr_1
end type
global w_pdt_02100 w_pdt_02100

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

if isnull(dw_insert.GetItemString(i,'itnbr')) or &
	trim(dw_insert.GetItemString(i,'itnbr')) = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'opseq')) or &
	dw_insert.GetItemString(i,'opseq') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 사용공정]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('opseq')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'out_store')) or &
	dw_insert.GetItemString(i,'out_store') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행 출고창고]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('out_store')
	dw_insert.SetFocus()
	return -1		
end if	

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

d_unqty =  d_qty + d_addqty - d_isqty

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

on w_pdt_02100.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdt_02100.destroy
call super::destroy
destroy(this.dw_1)
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

type dw_insert from w_inherite`dw_insert within w_pdt_02100
integer x = 41
integer y = 464
integer width = 4539
integer height = 1844
integer taborder = 0
string dataobject = "d_pdt_02100_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemchanged;string  snull, sitnbr, sitdsc, sispec, s_date, s_depot, spitnbr, s_opseq, get_dept
integer ireturn 
long    lrow
decimal {3} d_qty, d_jego, d_usejego

if dw_1.accepttext() = -1 then return 
if this.accepttext() = -1 then return 

SetNull(snull)
lrow = this.getrow()

IF this.GetColumnName() = "itnbr"	THEN
   sItnbr = trim(this.GetText())
	if sitnbr = "" or isnull(sitnbr) then 
		this.setitem(lrow, "itdsc", snull)	
		this.setitem(lrow, "ispec", snull)
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
      return 
	end if	
	ireturn = f_get_name2('품번', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
   IF ireturn = 0 THEN 
		s_depot = this.getitemstring(lrow, 'out_store')
      if trim(s_depot) = '' or isnull(s_depot) then 
			this.setitem(lrow, "jego", 0)
			this.setitem(lrow, "usejego", 0)
		else	
			d_jego    = SQLCA.ERP000000110(s_depot, sitnbr, '.', '1') 
			d_usejego = SQLCA.ERP000000110(s_depot, sitnbr, '.', '2') 
			this.setitem(lrow, "jego",    d_jego)
			this.setitem(lrow, "usejego", d_usejego)
      end if
   ELSE
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
	END IF	
	RETURN ireturn
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sItdsc = trim(this.GetText())
	if sitdsc = "" or isnull(sitdsc) then 
		this.setitem(lrow, "itnbr", snull)	
		this.setitem(lrow, "ispec", snull)
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
      return 
	end if	
	ireturn = f_get_name2('품명', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
   IF ireturn = 0 THEN 
		s_depot = this.getitemstring(lrow, 'out_store')
      if trim(s_depot) = '' or isnull(s_depot) then 
			this.setitem(lrow, "jego", 0)
			this.setitem(lrow, "usejego", 0)
		else	
			d_jego    = SQLCA.ERP000000110(s_depot, sitnbr, '.', '1') 
			d_usejego = SQLCA.ERP000000110(s_depot, sitnbr, '.', '2') 
			this.setitem(lrow, "jego",    d_jego)
			this.setitem(lrow, "usejego", d_usejego)
      end if
	ELSE
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
	END IF	
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sIspec = trim(this.GetText())
	if sispec = "" or isnull(sispec) then 
		this.setitem(lrow, "isnbr", snull)
		this.setitem(lrow, "itdsc", snull)	
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
      return 
	end if	
	ireturn = f_get_name2('규격', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
   IF ireturn = 0 THEN 
		s_depot = this.getitemstring(lrow, 'out_store')
      if trim(s_depot) = '' or isnull(s_depot) then 
			this.setitem(lrow, "jego", 0)
			this.setitem(lrow, "usejego", 0)
		else	
			d_jego    = SQLCA.ERP000000110(s_depot, sitnbr, '.', '1') 
			d_usejego = SQLCA.ERP000000110(s_depot, sitnbr, '.', '2') 
			this.setitem(lrow, "jego",    d_jego)
			this.setitem(lrow, "usejego", d_usejego)
      end if
	ELSE
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
	END IF	
	RETURN ireturn
ELSEIF this.GetColumnName() ="opseq" THEN  //사용공정
   s_opseq = this.Gettext()
	
	if s_opseq = '' or isnull(s_opseq) then 
		this.setitem(lrow, 'opdsc', snull)
		return 
	end if	
	spitnbr = dw_1.getitemstring(1, 'momast_itnbr')
	sitdsc = f_get_routng(spitnbr, s_opseq)
	if isnull(sitdsc) then 
		this.setitem(lrow, 'opseq', snull)
		this.setitem(lrow, 'opdsc', snull)
		return 1
   else
		this.setitem(lrow, 'opdsc', sitdsc)
   end if	
ELSEIF this.GetColumnName() = "out_store" THEN  //출고창고
   s_depot = trim(this.GetText())
	if s_depot = "" or isnull(s_depot) then 
		this.setitem(lrow, "req_dept", snull)
		this.setitem(lrow, "jego", 0)
		this.setitem(lrow, "usejego", 0)
      return 
	end if	
	ireturn = f_get_name2('창고', 'Y', s_depot, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "out_store", s_depot)	
   IF ireturn = 0 THEN 
		sitnbr = this.getitemstring(lrow, 'itnbr')
      if trim(sitnbr) = '' or isnull(sitnbr) then 
			this.setitem(lrow, "jego",    0)
			this.setitem(lrow, "usejego", 0)
		else	
			d_jego    = SQLCA.ERP000000110(s_depot, sitnbr, '.', '1') 
			d_usejego = SQLCA.ERP000000110(s_depot, sitnbr, '.', '2') 
			this.setitem(lrow, "jego",    d_jego)
			this.setitem(lrow, "usejego", d_usejego)
      end if
      SELECT "VNDMST"."DEPTCODE"  
		  INTO :get_dept  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :s_depot   ;
		
		this.setitem(lrow, "req_dept", get_dept)
	ELSE
		this.setitem(lrow, "req_dept", snull)
		this.setitem(lrow, "jego",    0)
		this.setitem(lrow, "usejego", 0)
	END IF	
	RETURN ireturn
ELSEIF this.GetColumnName() ="hold_qty" THEN  //소요수량
   d_qty = long(this.Gettext())
	
	if d_qty = 0 or isnull(d_qty) then return 
   if wf_check(lrow, 1) = -1 then return 1
ELSEIF this.GetColumnName() ="addqty" THEN  //추가소요량
   d_qty = long(this.Gettext())
	
	if d_qty = 0 or isnull(d_qty) then return 
   if wf_check(lrow, 2) = -1 then return 1
ELSEIF this.GetColumnName() ="rqdat" THEN  //출고요구일
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[출고요구일]')
		this.SetItem(lrow,"rqdat",snull)
		this.Setcolumn("rqdat")
		this.SetFocus()
		Return 1
	ELSE
		IF s_date < f_today() then 
			f_message_chk(64,'[출고요구일]')
			this.SetItem(lrow,"rqdat",snull)
			this.Setcolumn("rqdat")
			this.SetFocus()
			Return 1
		END IF
	END IF
END IF	


end event

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(this.getrow(),"itnbr",gs_code)
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event dw_insert::rbuttondown;Integer iCurRow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

iCurRow = this.GetRow()
IF this.GetcolumnName() ="itnbr" THEN
	Open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
	Return 1
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	
	open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.SetColumn("itnbr")
	this.SetFocus()
	
	this.TriggerEvent(ItemChanged!)
	Return 1
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	
	open(w_itemas_popup)
	IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(iCurRow,"itnbr",gs_code)
	this.SetColumn("itnbr")
	this.SetFocus()
	
	this.TriggerEvent(ItemChanged!)
	Return 1
ELSEIF this.GetColumnName() = "opseq"	THEN
	IF dw_1.GetItemString(1,"momast_itnbr") = "" OR &
		IsNull(dw_1.GetItemString(1,"momast_itnbr")) THEN
		MessageBox("확 인","작업지시번호에 품번이 등록되지않았습니다!!")
		Return
	ELSE
		OpenWithParm(w_routng_popup, dw_1.GetItemString(1,"momast_itnbr"))
		IF IsNull(Gs_Code) or gs_code = '' THEN RETURN
		this.SetItem(icurrow,"opseq",Gs_Code)
		this.triggerevent(itemchanged!)
	End If	
END IF
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02100
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02100
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_02100
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_02100
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_02100
integer x = 4421
integer y = 20
end type

type p_can from w_inherite`p_can within w_pdt_02100
integer x = 4247
integer y = 20
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdt_02100
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_02100
integer x = 4073
integer y = 20
end type

event p_inq::clicked;call super::clicked;string s_pordno

if dw_1.AcceptText() = -1 then return 

s_pordno = trim(dw_1.GetItemString(1,'pordno'))

if isnull(s_pordno) or s_pordno = "" then
	f_message_chk(30,'[작업지시번호]')
	dw_1.Setcolumn('pordno')
	dw_1.SetFocus()
	return
end if	

dw_1.Retrieve(gs_sabu, s_pordno) 
if dw_insert.Retrieve(gs_sabu, s_pordno) <= 0 then 
	f_message_chk(50,'')
	dw_1.Setcolumn('pordno')
	dw_1.SetFocus()
end if	
	
ib_any_typing = FALSE




end event

type p_del from w_inherite`p_del within w_pdt_02100
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_pdt_02100
integer y = 5000
end type

type cb_exit from w_inherite`cb_exit within w_pdt_02100
integer x = 4315
integer y = 5000
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02100
boolean visible = false
integer x = 1664
integer y = 2404
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

type cb_ins from w_inherite`cb_ins within w_pdt_02100
boolean visible = false
integer x = 421
integer y = 2480
integer taborder = 30
boolean enabled = false
string text = "추가(&A)"
end type

event cb_ins::clicked;call super::clicked;string s_pordno, s_today, shold_no, left_hold, shold_gu, sgub
int i, il_currow, il_RowCount, i_hold 
long lhold_no

if dw_1.AcceptText() = -1 then return 

s_pordno = trim(dw_1.GetItemString(1,'pordno'))

if isnull(s_pordno) or s_pordno = "" then
	f_message_chk(30,'[작업지시번호]')
	dw_1.Setcolumn('pordno')
	dw_1.SetFocus()
	return
end if	

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

il_currow = dw_insert.RowCount() 

if il_currow <= 0 then
	s_today = f_today()
	lHold_no = sqlca.fun_junpyo(gs_sabu, s_today, 'B0')
   shold_no = s_today + string(lHold_no, '0000') + '001'

	SELECT "IOMATRIX"."IOGBN", "IOMATRIX"."NAOUGU"   
     INTO :shold_gu, :sgub  
     FROM "IOMATRIX"  
    WHERE ( "IOMATRIX"."SABU" = :gs_sabu ) AND ( "IOMATRIX"."AUTPDT" = 'Y' )   ;

	if sqlca.sqlcode <> 0 then 
		f_message_chk(41, '')
		return 
	end if	
else
	left_hold = left(dw_insert.getitemstring(il_currow, 'hold_no'), 12)
	i_hold    = integer(mid(dw_insert.getitemstring(il_currow, 'hold_no'), 13, 3)) + 1
	shold_no  = left_hold + string(i_hold, '000') 
	
	shold_gu = dw_insert.getitemstring(il_currow, 'hold_gu')
	sgub     = dw_insert.getitemstring(il_currow, 'naougu')
end if	

il_currow = il_currow + 1
dw_insert.InsertRow(il_currow)

dw_insert.setitem(il_currow, 'sabu', gs_sabu )
dw_insert.setitem(il_currow, 'pordno', s_pordno )
dw_insert.setitem(il_currow, 'hold_no', shold_no )
dw_insert.setitem(il_currow, 'hold_gu', shold_gu )
dw_insert.setitem(il_currow, 'hold_date', f_today() )
dw_insert.setitem(il_currow, 'naougu', sgub )

dw_insert.ScrollToRow(il_currow)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

ib_any_typing =True

end event

type cb_del from w_inherite`cb_del within w_pdt_02100
boolean visible = false
integer x = 2016
integer y = 2404
integer taborder = 50
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;long i, irow, irow2

if dw_1.AcceptText() = -1 then return 
if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	f_Message_chk(31,'[삭제 행]')
	return 
end if	

irow = dw_insert.getrow() - 1
irow2 = dw_insert.getrow() + 1
if irow > 0 then   
	FOR i = 1 TO irow
		IF wf_required_chk(i) = -1 THEN RETURN
	NEXT
end if	

FOR i = irow2 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

if f_msg_delete() = -1 then return

dw_insert.DeleteRow(0)

if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	

p_inq.TriggerEvent(Clicked!)

end event

type cb_inq from w_inherite`cb_inq within w_pdt_02100
integer x = 3703
integer y = 5000
integer taborder = 20
end type

type cb_print from w_inherite`cb_print within w_pdt_02100
boolean visible = false
integer x = 1961
integer y = 2492
end type

type st_1 from w_inherite`st_1 within w_pdt_02100
end type

type cb_can from w_inherite`cb_can within w_pdt_02100
integer x = 3963
integer y = 5000
end type

type cb_search from w_inherite`cb_search within w_pdt_02100
boolean visible = false
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





type gb_10 from w_inherite`gb_10 within w_pdt_02100
integer y = 5000
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02100
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02100
end type

type dw_1 from datawindow within w_pdt_02100
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 23
integer y = 16
integer width = 3438
integer height = 432
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_02100_a"
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

IF this.GetColumnName() = "pordno"	THEN
	
	gs_gubun = '30' 
	open(w_jisi_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "pordno", 	 gs_Code)
   p_inq.TriggerEvent(Clicked!)
   return 1
END IF	
end event

event itemerror;RETURN 1
end event

event itemchanged;string snull, sporno
long   get_count

IF this.GetColumnName() = "pordno"	THEN
	sporno = trim(this.gettext())
	
	if sporno = "" or isnull(sporno) then
		wf_reset()
		return 
	end if	

   SELECT COUNT(*)
    INTO :get_count  
    FROM MOMAST A, ITEMAS B  
   WHERE ( A.ITNBR = B.ITNBR ) AND 
	      ( A.SABU = :gs_sabu ) AND ( A.PORDNO = :sporno )   ;

   if get_count > 0 then 
      p_inq.TriggerEvent(Clicked!)
		return 1
	else
   	f_message_chk(33,'[작업지시번호]')
   	wf_reset()
		return 1
	end if
END IF	
end event

type rr_1 from roundrectangle within w_pdt_02100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 456
integer width = 4581
integer height = 1868
integer cornerheight = 40
integer cornerwidth = 55
end type

