$PBExportHeader$w_st38_00010.srw
$PBExportComments$단가 등록
forward
global type w_st38_00010 from w_inherite
end type
type rr_1 from roundrectangle within w_st38_00010
end type
type dw_cond from u_key_enter within w_st38_00010
end type
type rb_1 from radiobutton within w_st38_00010
end type
type rb_2 from radiobutton within w_st38_00010
end type
type cbx_1 from checkbox within w_st38_00010
end type
type rr_3 from roundrectangle within w_st38_00010
end type
end forward

global type w_st38_00010 from w_inherite
integer width = 4635
integer height = 2644
string title = "단가 등록(소모품)"
rr_1 rr_1
dw_cond dw_cond
rb_1 rb_1
rb_2 rb_2
cbx_1 cbx_1
rr_3 rr_3
end type
global w_st38_00010 w_st38_00010

type variables
string	isgubun
end variables

forward prototypes
public function integer wf_required_chk ()
public subroutine wf_initial ()
end prototypes

public function integer wf_required_chk ();If dw_cond.AcceptText() < 1 Then Return -1
If dw_insert.AcceptText() < 1 Then Return -1

Long		i, l, lcnt
String 	ls_cvcod , ls_itnbr, ls_date1, ls_date2, ls_date1_t
Decimal	ld_price

For i = 1 To dw_insert.RowCount()
	ld_price = dw_insert.Object.unprc[i]	
	If isnull(ld_price) or ld_price <= 0 Then continue
	
	ls_date1 = Trim(dw_insert.Object.sdate[i])
	If f_datechk(ls_date1) < 1  Then
		f_message_chk(35,'[적용개시]')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('sdate')
		dw_insert.setfocus()
		Return -1
	End If
	
	FOR l = 1 TO dw_insert.rowcount()
		ls_date1_t = Trim(dw_insert.Object.sdate[l])
		if ls_date1 = ls_date1_t and i <> l then
			messagebox('확인','적용개시일은 중복이 허용되지 않습니다')
			dw_insert.ScrollToRow(l)
			dw_insert.SetColumn('sdate')
			dw_insert.setfocus()
			return -1
		end if
	NEXT
		
	ls_date2 = Trim(dw_insert.Object.edate[i])
	If ls_date2 <> '99999999' Then
		If f_datechk(ls_date2) < 1 Then
			f_message_chk(35,'[적용해지]')
			dw_insert.ScrollToRow(i)
			dw_insert.SetColumn('edate')
			dw_insert.setfocus()
			Return -1
		End If
	End If
	
	if ls_date1 > ls_date2 then
		messagebox('확인','적용개시일이 적용해지일보다 큽니다')
		dw_insert.ScrollToRow(i)
		dw_insert.SetColumn('sdate')
		dw_insert.setfocus()
		return -1
	end if
Next

return 1
end function

public subroutine wf_initial ();string	snull

setnull(snull)
//dw_cond.reset()
dw_insert.reset()

dw_cond.Enabled = True

isgubun = 'N'

//dw_cond.insertrow(0)
dw_cond.setitem(1,'itnbr',snull)
dw_cond.setitem(1,'itdsc',snull)
dw_cond.setcolumn('cvcod')
dw_cond.setfocus()

ib_any_typing = false

end subroutine

on w_st38_00010.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_cond=create dw_cond
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_1=create cbx_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_cond
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.rr_3
end on

on w_st38_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_cond)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_1)
destroy(this.rr_3)
end on

event open;call super::open;dw_insert.settransobject(sqlca)

dw_cond.insertrow(0)
wf_initial()
end event

type dw_insert from w_inherite`dw_insert within w_st38_00010
integer x = 64
integer y = 256
integer width = 4494
integer height = 2048
integer taborder = 0
string dataobject = "d_st38_00010_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;call super::itemchanged;Long		lrow
String 	ls_col ,ls_cod ,ls_itdsc

ls_col = Lower(This.GetColumnName())
 

Choose Case ls_col
	
	Case "itnbr" 
		ls_cod = Trim(This.GetText())  
		If ls_cod = '' Or isNull(ls_cod)  Then
			f_message_chk(33 , '[품번]')
			SetColumn(ls_col)
			Return 1
		End If
		
		Select itdsc
		  Into :ls_itdsc 
		  From itemas
		 Where itnbr = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[품번]")
			This.Object.itdsc[GetRow()] = ""
			Return 1
		End If
		
		This.Object.itdsc[GetRow()] = ls_itdsc	
	
	Case "cvcod"
		ls_cod = Trim(This.GetText())  
		If ls_cod = '' Or isNull(ls_cod)  Then
			This.Object.cvcas[GetRow()] = ""	
			Return
		End If
		
		Select cvnas
		  Into :ls_itdsc 
		  From vndmst
		 Where cvcod = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[거래처]")
			This.Object.cvcas[GetRow()] = ""	
			Return 1
		End If
		
		This.Object.cvnas[GetRow()] = ls_itdsc	
		
	Case 'efrdt'
		ls_cod = Trim(This.GetText())  
		If ls_cod = '' Or isNull(ls_cod) Or f_datechk(ls_cod) < 1   Then
			f_message_chk(35 , '[시작일자]')
			SetColumn(ls_col)
			Return 1
		End If
	Case 'eftdt'
		ls_cod = Trim(This.GetText())  
		If ls_cod = '' Or isNull(ls_cod) Or f_datechk(ls_cod) < 1   Then
			f_message_chk(35 , '[해지일자]')
			SetColumn(ls_col)
			Return 1
		End If

	Case "sltcd"
//		MESSAGEBOX('A','A')
		ls_cod = This.GetText()
		if ls_cod = 'Y' then
			FOR lrow = 1 TO this.rowcount()
				if lrow = GetRow() then continue
				This.Object.sltcd[lrow] = "N"
			NEXT
		end if

End Choose
end event

event dw_insert::rbuttondown;call super::rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

If this.GetColumnName() = 'itnbr' then
	
	Open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(row,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
	
elseif this.GetColumnName() = 'cvcod' then
	gs_gubun = '1'
	Open(w_vndmst_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(row,"cvcod",gs_code)
	this.TriggerEvent(ItemChanged!)
	
END IF
end event

event dw_insert::clicked;call super::clicked;//If Row <= 0 then
//	SelectRow(0,False)
//ELSE
//	SelectRow(0, FALSE)
//	SelectRow(Row,TRUE)
//END IF
end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::buttonclicked;call super::buttonclicked;//If row < 1 Then Return
//
//SetNull(gs_gubun)
//SetNull(gs_code)
//SetNull(gs_codename)
//
//Choose Case dwo.name
//	Case 'b_view'
//		gs_gubun    = Trim(Object.gubun[row])
//		gs_code     = Trim(Object.cvcod[row])
//		gs_codename = Trim(Object.itnbr[row])
//		
//		If isNull(gs_code) = False And isNull(gs_codename) = False Then
//			Open(w_kcda10_popup)
//		End If
//End Choose
end event

event dw_insert::doubleclicked;call super::doubleclicked;//If row < 1 Then Return
//
//SetNull(gs_gubun)
//SetNull(gs_code)
//SetNull(gs_codename)
//
//gs_gubun    = isgubun
//gs_code     = Trim(Object.cvcod[row])
//gs_codename = Trim(Object.itnbr[row])
//
//If not isNull(gs_code) And not isNull(gs_codename) Then
//	Open(w_kcda10_popup)
//End If
end event

event dw_insert::updatestart;call super::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF this.getitemstring(k,'ischange') = 'Y' THEN
 	   This.SetItem(k,'upd_user',gs_userid)
		This.SetItem(k,'upd_date',f_today())
		This.SetItem(k,'upd_time',f_totime())
   END IF	  
NEXT

end event

type p_delrow from w_inherite`p_delrow within w_st38_00010
boolean visible = false
integer x = 3904
integer y = 2448
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_st38_00010
boolean visible = false
integer x = 3730
integer y = 2448
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_st38_00010
boolean visible = false
integer x = 3410
integer y = 2752
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_st38_00010
integer x = 3680
integer y = 16
end type

event p_ins::clicked;Long		ll_row , ll_r
String 	ls_cvcod , ls_itnbr

if isgubun = 'N' then return
If dw_cond.AcceptText() < 1 Then Return

ll_row = dw_insert.getrow()
if ll_row > 0 then
	ll_r = dw_insert.InsertRow(ll_row)
else
	ll_r = dw_insert.InsertRow(0)
end if

ls_itnbr = dw_cond.getitemstring(1,'itnbr')
ls_cvcod = dw_cond.getitemstring(1,'cvcod')

dw_insert.setitem(ll_r,'itnbr',ls_itnbr)
dw_insert.setitem(ll_r,'cvcod',ls_cvcod)
dw_insert.ScrollToRow(ll_r)
dw_insert.SetColumn('sdate')
dw_insert.setfocus()
end event

type p_exit from w_inherite`p_exit within w_st38_00010
integer x = 4375
integer y = 16
integer taborder = 60
end type

event p_exit::clicked;//
Close(Parent)
end event

type p_can from w_inherite`p_can within w_st38_00010
integer x = 4201
integer y = 16
integer taborder = 50
end type

event p_can::clicked;call super::clicked;if cbx_1.checked then
	dw_cond.reset()
	dw_insert.reset()
	
	dw_cond.Enabled = True
	isgubun = 'N'
	
	dw_cond.insertrow(0)
	dw_cond.setfocus()
	ib_any_typing = false
else
	wf_initial()
end if
end event

type p_print from w_inherite`p_print within w_st38_00010
boolean visible = false
integer x = 3584
integer y = 2752
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_st38_00010
integer x = 3506
integer y = 16
end type

event p_inq::clicked;call super::clicked;If dw_cond.AcceptText() < 1 Then Return

String ls_cvcod , ls_itnbr ,ls_curr
Long   ll_rcnt, ll_cnt, ll_last

ls_itnbr = Trim(dw_cond.Object.itnbr[1])
if isnull(ls_itnbr) or ls_itnbr = '' then
	dw_cond.setcolumn('itnbr')
	dw_cond.setfocus()
	return
end if

select count(*) into :ll_rcnt from itemas 
 where itnbr = :ls_itnbr ;
if ll_rcnt = 0 then
	messagebox('확인','등록되지 않은 품번입니다')
	dw_cond.setcolumn('itnbr')
	dw_cond.setfocus()
	return
end if

ls_cvcod = Trim(dw_cond.Object.cvcod[1])
if isnull(ls_cvcod) or ls_cvcod = '' then
	dw_cond.setcolumn('cvcod')
	dw_cond.setfocus()
	return
end if

select count(*) into :ll_rcnt from vndmst 
 where cvcod = :ls_cvcod ;
if ll_rcnt = 0 then
	messagebox('확인','등록되지 않은 거래처코드입니다')
	dw_cond.setcolumn('cvcod')
	dw_cond.setfocus()
	return
end if

ll_rcnt = dw_insert.Retrieve(ls_cvcod,ls_itnbr)
If ll_rcnt < 1 Then
	messagebox('확인','신규로 등록합니다')
	ll_cnt = 1
	ll_last= 6
Else
	ll_last= ll_rcnt
	ll_cnt = 6 - ll_rcnt
End If

isgubun = 'Y'

//FOR ll_rcnt = 1 TO ll_cnt
	p_ins.triggerevent(clicked!)
//NEXT

dw_insert.setrow(1)
dw_insert.setfocus()

dw_cond.Enabled = False
end event

type p_del from w_inherite`p_del within w_st38_00010
integer x = 4027
integer y = 16
integer taborder = 40
end type

event p_del::clicked;call super::clicked;if isgubun = 'N' then return

Long   	ll_r

dw_insert.AcceptText()

ll_r = dw_insert.GetRow()
If ll_r < 1 Then Return

If f_msg_delete() < 1 Then Return

dw_insert.DeleteRow(ll_r)
end event

type p_mod from w_inherite`p_mod within w_st38_00010
integer x = 3854
integer y = 16
integer taborder = 30
end type

event p_mod::clicked;if isgubun = 'N' then return
If dw_insert.AcceptText() < 1 then Return

If wf_required_chk() < 1 Then Return
//If f_msg_update() < 1 Then Return

long		lrow
decimal	ld_price

dw_insert.setredraw(false)
For lrow = dw_insert.RowCount() To 1 Step -1
	dw_insert.Object.upd_user[lrow] = gs_userid
	
	ld_price = dw_insert.Object.unprc[lrow]	
	If ld_price > 0 Then continue
	dw_insert.deleterow(lrow)
Next

If dw_insert.Update() < 1 Then
	dw_insert.setredraw(true)
	Rollback ;
	f_message_chk(32,'')
	Return
End If

dw_insert.setredraw(true)
COMMIT ;

p_inq.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_st38_00010
end type

type cb_mod from w_inherite`cb_mod within w_st38_00010
end type

type cb_ins from w_inherite`cb_ins within w_st38_00010
end type

type cb_del from w_inherite`cb_del within w_st38_00010
end type

type cb_inq from w_inherite`cb_inq within w_st38_00010
end type

type cb_print from w_inherite`cb_print within w_st38_00010
end type

type st_1 from w_inherite`st_1 within w_st38_00010
end type

type cb_can from w_inherite`cb_can within w_st38_00010
end type

type cb_search from w_inherite`cb_search within w_st38_00010
end type







type gb_button1 from w_inherite`gb_button1 within w_st38_00010
end type

type gb_button2 from w_inherite`gb_button2 within w_st38_00010
end type

type rr_1 from roundrectangle within w_st38_00010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 248
integer width = 4530
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 46
end type

type dw_cond from u_key_enter within w_st38_00010
integer x = 46
integer y = 16
integer width = 3049
integer height = 212
integer taborder = 11
string dataobject = "d_st38_00010_0"
boolean border = false
end type

event rbuttondown;call super::rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then return
	this.SetItem(1, "cvcod", gs_Code)
	this.TriggerEvent(ItemChanged!)
	
ElseIf this.GetColumnName() = 'itnbr' then
	gs_gubun = '5'
	Open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF
end event

event itemchanged;call super::itemchanged;String ls_col ,ls_cod , ls_cvnas ,ls_itdsc

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())   

Choose Case ls_col
	Case "cvcod"
		If ls_cod = '' Or isNull(ls_cod)  Then
			f_message_chk(33 , '[거래처]')
			SetColumn(ls_col)
			Return 1
		End If
		Select cvnas 
		  Into :ls_cvnas 
		  From vndmst
		  Where cvcod = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[거래처]")
			This.Object.cvcod[1] = ""
			Return 1
		End If
		
		This.Object.cvname[1] = ls_cvnas
		
	Case "itnbr" 
		If ls_cod = '' Or isNull(ls_cod)  Then
			f_message_chk(33 , '[품번]')
			SetColumn(ls_col)
			Return 1
		End If
		Select itdsc
		  Into :ls_itdsc 
		  From itemas
		  Where itnbr = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[품번]")
			This.Object.itdsc[1] = ""
			Return 1
		End If
		
		This.Object.itdsc[1] = ls_itdsc	
End Choose

p_inq.PostEvent(Clicked!)
end event

event itemerror;call super::itemerror;return 1
end event

type rb_1 from radiobutton within w_st38_00010
boolean visible = false
integer x = 4677
integer y = 184
integer width = 242
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "매 입"
boolean checked = true
end type

event clicked;isgubun = '1'	// 매입

wf_Initial()
end event

type rb_2 from radiobutton within w_st38_00010
boolean visible = false
integer x = 4677
integer y = 256
integer width = 247
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "매 출"
end type

event clicked;isgubun = '2'	// 매출

wf_Initial()
end event

type cbx_1 from checkbox within w_st38_00010
integer x = 3104
integer y = 172
integer width = 855
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "취소시 조건에 거래처도 지움"
boolean checked = true
end type

type rr_3 from roundrectangle within w_st38_00010
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4631
integer y = 148
integer width = 329
integer height = 200
integer cornerheight = 40
integer cornerwidth = 55
end type

