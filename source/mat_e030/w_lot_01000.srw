$PBExportHeader$w_lot_01000.srw
$PBExportComments$** LOT 입고 자료 등록(기초자료)
forward
global type w_lot_01000 from w_inherite
end type
type dw_1 from datawindow within w_lot_01000
end type
type rr_1 from roundrectangle within w_lot_01000
end type
end forward

global type w_lot_01000 from w_inherite
string title = "LOT 입고 자료 등록(기초자료)"
dw_1 dw_1
rr_1 rr_1
end type
global w_lot_01000 w_lot_01000

type variables

end variables

forward prototypes
public function integer wf_required_chk (integer i)
public subroutine wf_reset ()
public function integer wf_dup_chk ()
end prototypes

public function integer wf_required_chk (integer i);if dw_insert.AcceptText() = -1 then return -1

if isnull(dw_insert.GetItemString(i,'ipdat')) or &
	dw_insert.GetItemString(i,'itnbr') = '' then
	f_message_chk(1400,'[ '+string(i)+' 행  입고일자]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('ipdat')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'itnbr')) or &
	dw_insert.GetItemString(i,'itnbr') = '' then
	f_message_chk(1400,'[ '+string(i)+' 행  품번]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemString(i,'pspec')) or &
	dw_insert.GetItemString(i,'pspec') = '' then
	dw_insert.SetItem(i, 'pspec', '.')
end if	

if isnull(dw_insert.GetItemString(i,'igbn')) or &
	dw_insert.GetItemString(i,'igbn') = '' then
	f_message_chk(1400,'[ '+string(i)+' 행  수불구분]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('igbn')
	dw_insert.SetFocus()
	return -1		
end if	

if isnull(dw_insert.GetItemNumber(i,'ipqty')) or &
   dw_insert.GetItemNumber(i,'ipqty') = 0 then
	f_message_chk(1400,'[ '+string(i)+' 행  수량]')
	dw_insert.ScrollToRow(i)
	dw_insert.SetColumn('ipqty')
	dw_insert.SetFocus()
	return -1		
end if	

return 1
end function

public subroutine wf_reset ();string snull

setnull(snull)

dw_insert.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()
dw_1.reset()

dw_1.insertrow(0)
dw_1.setitem(1, 'yymm', left(is_today, 6))
dw_1.setfocus()

dw_1.setredraw(true)
dw_insert.setredraw(true)


end subroutine

public function integer wf_dup_chk ();long    k, lreturnrow
string  sfind

FOR k = dw_insert.rowcount() TO 1 step - 1
   sfind = dw_insert.getitemstring(k, 'sdup')

	lReturnRow = dw_insert.Find("sdup = '"+sfind+"' ", 1, dw_insert.RowCount())
	
	IF (k <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[품번/사양]')
		dw_insert.Setrow(k)
		dw_insert.Setcolumn('pspec')
		dw_insert.setfocus()
		RETURN  -1
	END IF
NEXT

return 1
end function

on w_lot_01000.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_lot_01000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.setitem(1, 'yymm', left(is_today, 6))
dw_1.SetFocus()

//입고창고 
f_child_saupj(dw_1, 'sdepot', gs_saupj)

//dw_insert.object.ispec_t.text = f_change_name('2')
//dw_insert.object.itemas_jijil_t.text = f_change_name('3')


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

type dw_insert from w_inherite`dw_insert within w_lot_01000
integer x = 32
integer y = 192
integer width = 4567
integer height = 2112
integer taborder = 40
string dataobject = "d_lot_01000_2"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rbuttondown;Long iCurRow

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
END IF
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;string   snull, sitnbr, sitdsc, sispec, sDate , ls_jijil , ls_ispec_code
integer  ireturn
long     lrow, lreturnrow
dec{3}   dQty
dec{5}   dPrice

if dw_1.accepttext() = -1 then return 

setnull(snull)

lrow   = this.getrow()

IF this.GetColumnName() = 'ipdat' THEN
	sDate = trim(this.gettext())
	if sdate = '' or isnull(sdate) then return 
	IF f_datechk(sDate) = -1	then
		f_message_chk(35,'[입고일자]')
		this.setitem(1, "ipdat", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec , ls_jijil , ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	this.setitem(lrow, "itemas_ispec_code", ls_ispec_code)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, ls_jijil , ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	this.setitem(lrow, "itemas_ispec_code", ls_ispec_code)
	RETURN ireturn
ELSEIF this.GetColumnName() = "ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, ls_jijil , ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	this.setitem(lrow, "itemas_ispec_code", ls_ispec_code)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_jijil"	THEN
	ls_jijil = trim(this.GetText())
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, ls_jijil , ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	this.setitem(lrow, "itemas_ispec_code", ls_ispec_code)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec_code"	THEN
	ls_ispec_code = trim(this.GetText())
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, ls_jijil , ls_ispec_code)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "itemas_jijil", ls_jijil)
	this.setitem(lrow, "itemas_ispec_code", ls_ispec_code)
	RETURN ireturn
ELSEIF this.getcolumnname() = "ipqty" 	THEN
 	dqty   = dec(this.GetText())
	dPrice = this.getitemdecimal(lRow, "ioprc")

   this.SetItem(lRow, "ioamt", truncate(dQty * dPrice, 2))	
	
ELSEIF this.getcolumnname() = "ioprc"		THEN

 	dPrice = dec(this.GetText())
	dqty   = this.getitemdecimal(lRow, "ipqty")

   this.SetItem(lRow, "ioamt", truncate(dQty * dPrice, 2))	
	
END IF
end event

type p_delrow from w_inherite`p_delrow within w_lot_01000
integer x = 3922
integer y = 20
end type

event p_delrow::clicked;call super::clicked;long i, irow, irow2

IF dw_insert.AcceptText() = -1 THEN RETURN 

if dw_insert.rowcount() <= 0 then
	f_Message_chk(31,'[삭제 행]')
	return 
end if	

SetPointer(HourGlass!)
sle_msg.text = "자료 유효성 여부 확인 中....."

irow = dw_insert.getrow() - 1
irow2 = dw_insert.getrow() + 1
if irow > 0 then   
	FOR i = 1 TO irow
		IF wf_required_chk(i) = -1 THEN
			sle_msg.text = ""
			RETURN
		END IF	
	NEXT
end if	

FOR i = irow2 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN
		sle_msg.text = ""
		RETURN
	END IF	
NEXT
sle_msg.text = ""

if f_msg_delete() = -1 then return

dw_insert.DeleteRow(0)

if dw_insert.Update() = 1 then
	sle_msg.text =	"자료를 삭제하였습니다!!"	
	ib_any_typing = false
	commit ;
else
	rollback ;
   sle_msg.text = ""
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	


end event

type p_addrow from w_inherite`p_addrow within w_lot_01000
integer x = 3749
integer y = 20
end type

event p_addrow::clicked;call super::clicked;string s_yymm, s_depot
long   i, il_currow, il_rowcount

if dw_1.AcceptText() = -1 then return 

s_yymm  = trim(dw_1.GetItemString(1,'yymm'))
s_depot = dw_1.GetItemString(1,'sdepot')

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.Setcolumn('yymm')
	dw_1.SetFocus()
	return
end if	

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.Setcolumn('sdepot')
	dw_1.SetFocus()
	return
end if	

SetPointer(HourGlass!)
sle_msg.text = "자료 유효성 여부 확인 中....."

FOR i = 1 TO dw_insert.RowCount()
	IF wf_required_chk(i) = -1 THEN 
      sle_msg.text = ""
		RETURN
	END IF	
NEXT

IF dw_insert.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = dw_insert.GetRow()
	il_RowCount = dw_insert.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_RowCount
	END IF
END IF

il_currow = il_currow + 1
dw_insert.InsertRow(il_currow)

dw_insert.setitem(il_currow, 'sabu', gs_sabu )
dw_insert.setitem(il_currow, 'lotyymm', s_yymm )
dw_insert.setitem(il_currow, 'depot_no', s_depot )
dw_insert.setitem(il_currow, 'opt', 'Y' )

dw_insert.ScrollToRow(il_currow)
dw_insert.SetColumn('ipdat')
dw_insert.SetFocus()

ib_any_typing =True
sle_msg.text = ""

end event

type p_search from w_inherite`p_search within w_lot_01000
boolean visible = false
integer x = 1257
integer y = 2396
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_lot_01000
boolean visible = false
integer x = 1614
integer y = 2408
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_lot_01000
integer y = 20
end type

type p_can from w_inherite`p_can within w_lot_01000
integer y = 20
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_lot_01000
boolean visible = false
integer x = 1431
integer y = 2396
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_lot_01000
integer x = 3575
integer y = 20
end type

event p_inq::clicked;call super::clicked;string s_yymm, s_depot

if dw_1.AcceptText() = -1 then return 

s_yymm = trim(dw_1.GetItemString(1,'yymm'))
s_depot = trim(dw_1.GetItemString(1,'sdepot'))

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.SetColumn('yymm')
	dw_1.SetFocus()
	return
end if	

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.SetColumn('sdepot')
	dw_1.SetFocus()
	return
end if	

SetPointer(HourGlass!)

if dw_insert.Retrieve(gs_sabu, s_yymm, s_depot) <= 0 then 
	dw_1.Setfocus()
	return
else
   dw_insert.SetColumn('ipdat')
	dw_insert.SetFocus()
end if	

ib_any_typing = FALSE


end event

type p_del from w_inherite`p_del within w_lot_01000
boolean visible = false
integer x = 1797
integer y = 2420
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_lot_01000
integer x = 4096
integer y = 20
end type

event p_mod::clicked;call super::clicked;long   i, lSeq, lCount, k
string sDate, sJpno

if dw_insert.AcceptText() = -1 then return 

lCount = dw_insert.rowcount()

if lCount <= 0 then return 	

SetPointer(HourGlass!)
sle_msg.text = "자료 유효성 여부 확인 中....."

sDate = trim(dw_1.GetItemString(1,'yymm'))
if isnull(sdate) or sdate = "" then
	f_message_chk(30,'[기준년월]')
	dw_1.SetColumn('yymm')
	dw_1.SetFocus()
	return
end if	

FOR i = 1 TO lCount
	IF wf_required_chk(i) = -1 THEN
      sle_msg.text = ""
		RETURN
	END IF	
NEXT

sle_msg.text = ""
IF Messagebox('저 장','저장 하시겠습니까?', Question!,YesNo!,1) = 2 THEN
   Return 
END IF


lSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate + '01', 'C0')
IF lSeq < 0		THEN	
	rollback;
	messagebox('확 인', '전표채번에 실패하였습니다.')
	RETURN -1
end if
COMMIT;

k = 0 

FOR i = 1 TO lCount
	if dw_insert.GetItemString(i,'opt') = 'Y' then
		
		k++
		
		if k > 998 then 
			lSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate + '01', 'C0')
			IF lSeq < 0		THEN	
				rollback;
				messagebox('확 인', '전표채번에 실패하였습니다.')
				RETURN -1
			end if
			COMMIT;
			k = 1
		end if	
		
		sJpno = sDate + '01' + string(lSeq, "0000")
		
		dw_insert.SetItem(i, 'ipno', sJpno + string(k, "000"))
	end if	
NEXT

sle_msg.text = "자료 저장 中....."
if dw_insert.update() = 1 then
	sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	sle_msg.text = ""
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	

end event

type cb_exit from w_inherite`cb_exit within w_lot_01000
end type

type cb_mod from w_inherite`cb_mod within w_lot_01000
end type

type cb_ins from w_inherite`cb_ins within w_lot_01000
end type

type cb_del from w_inherite`cb_del within w_lot_01000
end type

type cb_inq from w_inherite`cb_inq within w_lot_01000
end type

type cb_print from w_inherite`cb_print within w_lot_01000
integer x = 1984
integer y = 2544
end type

type st_1 from w_inherite`st_1 within w_lot_01000
end type

type cb_can from w_inherite`cb_can within w_lot_01000
end type

type cb_search from w_inherite`cb_search within w_lot_01000
integer x = 2619
integer y = 2532
end type





type gb_10 from w_inherite`gb_10 within w_lot_01000
integer x = 50
integer y = 2716
integer width = 402
integer height = 112
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
end type

type gb_button1 from w_inherite`gb_button1 within w_lot_01000
end type

type gb_button2 from w_inherite`gb_button2 within w_lot_01000
end type

type dw_1 from datawindow within w_lot_01000
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 14
integer y = 24
integer width = 2181
integer height = 132
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_lot_01000_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;//setnull(gs_code)
//
//IF keydown(keyF1!) THEN
//	TriggerEvent(RbuttonDown!)
//ELSEIF keydown(keyF2!) THEN
//		IF This.GetColumnName() = "fr_itnbr" Then
//			open(w_itemas_popup2)
//			if isnull(gs_code) or gs_code = "" then return
//			
//			this.SetItem(1,"fr_itnbr",gs_code)
//			RETURN 1
//		ELSEIF This.GetColumnName() = "to_itnbr" Then
//			open(w_itemas_popup2)
//			if isnull(gs_code) or gs_code = "" then return
//			
//			this.SetItem(1,"to_itnbr",gs_code)
//			RETURN 1
//      End If
//END IF
//
end event

event itemerror;return 1
end event

event rbuttondown;//setnull(gs_code)
//setnull(gs_codename)
//
//if this.GetColumnName() = 'fr_itnbr' then
//   gs_code = this.GetText()
//	open(w_itemas_popup)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	
//	this.SetItem(1,"fr_itnbr",gs_code)
//elseif this.GetColumnName() = 'to_itnbr' then
//   gs_code = this.GetText()
//	open(w_itemas_popup)
//	
//	if isnull(gs_code) or gs_code = "" then return
//	
//	this.SetItem(1,"to_itnbr",gs_code)
//end if	
//
end event

event itemchanged;string  snull, s_depot, s_depnm, s_depnm2, sdate
integer ireturn 

setnull(snull)

if this.accepttext() = -1 then return 

IF this.GetColumnName() ="yymm" THEN
	sdate = trim(this.GetText())
	s_depot = this.getitemstring(1, 'sdepot')
	
	if sdate = "" or isnull(sdate) then
      dw_insert.reset()
		return 
   end if
	
  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "yymm", sNull)
      dw_insert.reset()
		return 1
   END IF

	dw_insert.Retrieve(gs_sabu, sdate, s_depot) 
	
ELSEIF this.GetColumnName() ="sdepot" THEN
	s_depot = trim(this.GetText())
	sdate   = this.getitemstring(1, 'yymm')
	ireturn = f_get_name2('창고', 'N', s_depot, s_depnm, s_depnm2)
	dw_insert.Retrieve(gs_sabu, sdate, s_depot) 
	return ireturn
	
End if

ib_any_typing = FALSE

end event

event losefocus;if this.accepttext() = -1 then return 

end event

type rr_1 from roundrectangle within w_lot_01000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 180
integer width = 4594
integer height = 2136
integer cornerheight = 40
integer cornerwidth = 55
end type

