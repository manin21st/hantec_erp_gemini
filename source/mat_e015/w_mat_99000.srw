$PBExportHeader$w_mat_99000.srw
$PBExportComments$단가 조정
forward
global type w_mat_99000 from w_inherite
end type
type st_2 from statictext within w_mat_99000
end type
type dw_1 from datawindow within w_mat_99000
end type
type st_3 from statictext within w_mat_99000
end type
type pb_1 from u_pb_cal within w_mat_99000
end type
type pb_2 from u_pb_cal within w_mat_99000
end type
type rr_1 from roundrectangle within w_mat_99000
end type
end forward

global type w_mat_99000 from w_inherite
string title = "단가 조정"
st_2 st_2
dw_1 dw_1
st_3 st_3
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_mat_99000 w_mat_99000

on w_mat_99000.create
int iCurrent
call super::create
this.st_2=create st_2
this.dw_1=create dw_1
this.st_3=create st_3
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.rr_1
end on

on w_mat_99000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.st_3)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)

dw_1.InsertRow(0)

dw_1.SetItem(1,'sdatef',Left(is_today,6)+'01')
dw_1.SetItem(1,'sdatet',is_today)
end event

type dw_insert from w_inherite`dw_insert within w_mat_99000
integer x = 37
integer y = 308
integer width = 4571
integer height = 2012
integer taborder = 30
string dataobject = "d_mat_99000_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::editchanged;dec{3}  dQty, dpeqty, dsuqty
dec{5}  dPrice 
long    lRow
string  sIodate

lRow = this.GetRow()

// 수정시
IF this.getcolumnname() = "ioprc"		THEN

	this.AcceptText()
	
	dSuQty = this.GetItemDecimal(lRow, "iosuqty")
	dPeQty = this.GetItemDecimal(lRow, "imhist_iopeqty")
	dPrice = this.GetItemDecimal(lRow, "ioprc") 
   sIodate = this.GetItemString(lRow, "io_date") //승인일자가 없으면 금액변경 안함

   if sIodate = '' or isnull(sIodate) then return 

   dqty = dsuqty + dpeqty
	
	if dqty = 0 then dqty = 1 

	this.SetItem(lRow, "ioamt", truncate(dPrice * dQty, 0))

END IF

end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow > 0 Then
	this.SelectRow(0,false)
	this.SelectRow(currentrow,true)
Else
	this.SelectRow(0,false)
End If
end event

type p_delrow from w_inherite`p_delrow within w_mat_99000
boolean visible = false
integer x = 3424
integer y = 2500
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_mat_99000
boolean visible = false
integer x = 3250
integer y = 2500
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_mat_99000
integer x = 3922
boolean originalsize = true
string picturename = "C:\erpman\image\단가조정_up.gif"
end type

event p_search::clicked;call super::clicked;
if dw_1.Accepttext() = -1 then return 
if dw_insert.Accepttext() = -1 then return 

dec {3} dQty, dPeqty
dec {5} dPrice
long	  lRow, lCount
string  sittyp, sitnbr, sInsdate, sIodate, sOpt1, sOpt2, sopt1_yymm, sOPt2_yymm  , scvcod, scvnas, stuncu

sOpt1  = dw_1.GetItemString(1, "opt1") //제품 단가구분
if sOpt1 = '3' then 
	sOpt1_yymm  = dw_1.GetItemString(1, "opt1_yymm") 
end if
sOpt2  = dw_1.GetItemString(1, "opt2") //반제품 단가구분
if sOpt2 = '3' then 
	sOpt2_yymm  = dw_1.GetItemString(1, "opt2_yymm") 
end if

SetPointer(HourGlass!)

/* 품번 */
sItnbr = Trim(dw_1.GetItemString(1,'itnbr'))
If sItnbr = '' Or IsNull(sItnbr) Then 
	f_message_chk(30,'[품번]')
	dw_1.SetFocus()
	dw_1.SetColumn('ITNBR')
	Return
End If

lCount = dw_insert.Rowcount()

FOR lRow = 1 TO lCount	

	dQty     = dw_insert.GetItemDecimal(lRow, "iosuqty")        //합격수량
	dPeQty   = dw_insert.GetItemDecimal(lRow, "imhist_iopeqty") //폐기수량
   sItnbr   = dw_insert.GetItemString(lRow, "itnbr")
	sCvcod   = dw_insert.GetItemString(lRow, "cvcod")
   sInsdate = dw_insert.GetItemString(lRow, "insdat")  //검사일자
   sIodate  = dw_insert.GetItemString(lRow, "io_date") //승인일자가 없으면 금액변경 안함

   dqty = dqty + dpeqty
	
	if dqty = 0 then dqty = 1 

	 select ittyp,   nvl(wonsrc,0)
		into :sittyp, :dPrice
		from itemas
	  where itnbr = :sitnbr;

	// 생산자료인 경우
	If dw_1.GetItemString(1, "gubun") = '2' Then
		if sittyp = '1' then 
			 if sOpt1 = '1' then //판매단가
				 dPrice = sqlca.fun_erp100000012_1(sinsdate, scvcod, sitnbr, '.')
			 elseif sOpt1 = '3' then //사전원가 단가
				 if sOpt1_yymm = '' or isnull(sOpt1_yymm) then 
					 dPrice = sqlca.fun_get_itemcc_amt(left(sinsdate, 6), sitnbr)
				 else	 
					 dPrice = sqlca.fun_get_itemcc_amt(sOpt1_yymm, sitnbr)
				 end if
			 end if 
		else
			 if sOpt2 = '1' then //판매단가
				 dPrice = sqlca.fun_erp100000012_1(sinsdate, scvcod, sitnbr, '.')
			 elseif sOpt2 = '3' then //사전원가 단가
				 if sOpt2_yymm = '' or isnull(sOpt2_yymm) then 
					 dPrice = sqlca.fun_get_itemcc_amt(left(sinsdate, 6), sitnbr)
				 else	 
					 dPrice = sqlca.fun_get_itemcc_amt(sOpt2_yymm, sitnbr)
				 end if
			 end if 
		end if
	Else
		// 매입자료인 경우
		stuncu = 'WON'
		f_buy_unprc(sItnbr, '.', '9999', scvcod, scvnas, dPrice, stuncu)
	End If
	
	dw_insert.SetItem(lRow, "ioprc", dPrice)
	
   if not (sIodate = '' or isnull(sIodate)) then
   	dw_insert.SetItem(lRow, "ioamt", truncate(dPrice * dQty, 0))
	end if	
	
NEXT

SetPointer(Arrow!)

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\단가조정_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\단가조정_up.gif"
end event

type p_ins from w_inherite`p_ins within w_mat_99000
boolean visible = false
integer x = 3077
integer y = 2500
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_mat_99000
end type

type p_can from w_inherite`p_can within w_mat_99000
end type

event p_can::clicked;call super::clicked;dw_insert.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()
dw_1.reset()
dw_1.InsertRow(0)

dw_1.SetItem(1,'sdatef',Left(is_today,6)+'01')
dw_1.SetItem(1,'sdatet',is_today)

dw_insert.setredraw(true)
dw_1.setredraw(true)

ib_any_typing= FALSE

end event

type p_print from w_inherite`p_print within w_mat_99000
boolean visible = false
integer x = 2898
integer y = 2500
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_mat_99000
integer x = 3749
end type

event p_inq::clicked;call super::clicked;If dw_1.AcceptText() <> 1 then Return

string sDatef, sDatet, sItnbr, sCvcod, sgub
int    nCnt

sDatef = Trim(dw_1.GetItemString(1,'sdatef'))
sDatet = Trim(dw_1.GetItemString(1,'sdatet'))
sCvcod = Trim(dw_1.GetItemString(1,'cvcod'))
sItnbr = Trim(dw_1.GetItemString(1,'itnbr'))
sGub   = Trim(dw_1.GetItemString(1,'gubun'))


If IsNull(sdatef) Or sdatef = '' Then
   f_message_chk(30,'[수불일자]')
	dw_1.SetColumn('sdatef')
	dw_1.SetFocus()
	Return 
End If

If IsNull(sdatet) Or sdatet = '' Then
   f_message_chk(30,'[수불일자]')
	dw_1.SetColumn('sdatet')
	dw_1.SetFocus()
	Return 
End If

/* 거래처 */
If sCVCOD = '' Or IsNull(sCVCOD) Then 
	f_message_chk(30,'[상대처]')
	dw_1.SetFocus()
	dw_1.SetColumn('CVCOD')
	Return
End If


If sItnbr = '' Or IsNull(sItnbr) Then sitnbr = '%'

if sgub = '1' then 
	dw_insert.DataObject = 'd_mat_99000_1'
else
	dw_insert.DataObject = 'd_mat_99000_2'
end if
dw_insert.SetTransObject(sqlca)

SetPointer(HourGlass!)

/* 구매입고 */
IF dw_insert.Retrieve(gs_sabu, sDatef, sDatet, sItnbr, sCvcod) <= 0		THEN
	f_message_chk(50,'')
	dw_1.SetFocus()
	RETURN
END IF

SetPointer(Arrow!)

ib_any_typing= FALSE

end event

type p_del from w_inherite`p_del within w_mat_99000
boolean visible = false
integer x = 3598
integer y = 2500
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_mat_99000
integer x = 4096
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 
if dw_insert.rowcount() <= 0 then return 	

SetPointer(HourGlass!)

IF Messagebox('저 장','저장 하시겠습니까?', Question!,YesNo!,1) = 2 THEN
   Return 
END IF

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

type cb_exit from w_inherite`cb_exit within w_mat_99000
end type

type cb_mod from w_inherite`cb_mod within w_mat_99000
end type

type cb_ins from w_inherite`cb_ins within w_mat_99000
integer x = 640
integer y = 2568
end type

type cb_del from w_inherite`cb_del within w_mat_99000
integer x = 1390
integer y = 2540
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_mat_99000
end type

type cb_print from w_inherite`cb_print within w_mat_99000
integer x = 1792
integer y = 2496
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_mat_99000
end type

type cb_can from w_inherite`cb_can within w_mat_99000
end type

type cb_search from w_inherite`cb_search within w_mat_99000
end type







type gb_button1 from w_inherite`gb_button1 within w_mat_99000
end type

type gb_button2 from w_inherite`gb_button2 within w_mat_99000
end type

type st_2 from statictext within w_mat_99000
integer x = 69
integer y = 224
integer width = 1134
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "* 수불마감된 자료 / 매입마감된 자료는"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_mat_99000
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 18
integer y = 8
integer width = 3557
integer height = 212
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_mat_99000"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event itemchanged;String  sDateFrom, sDateTo, snull, sItnbr, sItdsc, sIspec
int     ireturn 

SetNull(snull)

Choose Case GetColumnName() 
 Case"sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[수불일자]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[수불일자]')
		this.SetItem(1,"sdatet",snull)
		Return 1
	END IF
 Case "cvcod"
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('V0', 'Y', sitnbr, sitdsc, sispec)
	this.setitem(1, "cvcod", sitnbr)	
	this.setitem(1, "cvcodnm", sitdsc)	
	RETURN ireturn
 Case	"itnbr" 
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', sitnbr, sitdsc, sispec)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	
	p_inq.TriggerEvent(Clicked!)
	RETURN ireturn
 Case "itdsc"
	sItdsc = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', sitnbr, sitdsc, sispec) 
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	RETURN ireturn
 Case "ispec"
	sIspec = trim(this.GetText())
	ireturn = f_get_name2('규격', 'Y', sitnbr, sitdsc, sispec) 
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	RETURN ireturn
 Case "gubun"
	sIspec  = trim(this.GetText())
	dw_insert.reset()
	IF sIspec = '1' then 
		cb_search.enabled = false
	ELSE
		cb_search.enabled = true 
	END IF
END Choose


end event

event rbuttondown;SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
 Case "cvcod"
	Open(w_vndmst_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
   this.SetItem(1, "cvcod", gs_code)
   TriggerEvent(ItemChanged!)	 
 Case "itnbr"
	 gs_gubun = '1'
	 Open(w_itemas_popup)
	 IF gs_code = "" OR IsNull(gs_code) THEN RETURN
	
	 SetItem(1, "itnbr", gs_code)
	 TriggerEvent(ItemChanged!)	 
END Choose

end event

type st_3 from statictext within w_mat_99000
integer x = 1230
integer y = 224
integer width = 1093
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = " 단가 조정 할 수 없습니다."
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_mat_99000
integer x = 654
integer y = 64
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('sdatef')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'sdatef', gs_code)



end event

type pb_2 from u_pb_cal within w_mat_99000
integer x = 1083
integer y = 64
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('sdatet')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'sdatet', gs_code)



end event

type rr_1 from roundrectangle within w_mat_99000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 296
integer width = 4590
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

