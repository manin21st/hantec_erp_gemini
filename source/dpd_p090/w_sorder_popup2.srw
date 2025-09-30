$PBExportHeader$w_sorder_popup2.srw
$PBExportComments$수주 관리 : 수주 내역 조회 선택
forward
global type w_sorder_popup2 from w_inherite_popup
end type
type cbx_1 from checkbox within w_sorder_popup2
end type
type rr_1 from roundrectangle within w_sorder_popup2
end type
type rr_2 from roundrectangle within w_sorder_popup2
end type
end forward

global type w_sorder_popup2 from w_inherite_popup
integer x = 160
integer y = 124
integer width = 3415
integer height = 2332
cbx_1 cbx_1
rr_1 rr_1
rr_2 rr_2
end type
global w_sorder_popup2 w_sorder_popup2

type variables
String sOrderGbn
end variables

on w_sorder_popup2.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_sorder_popup2.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;String sDatef, sDateT

dw_jogun.SetTransObject(SQLCA)
dw_jogun.InsertRow(0)

select to_char(sysdate,'yyyymmdd')
  into :sDateT
  from dual;

sDatef = string(today(), 'yyyymm01')


dw_jogun.SetItem(1,'fr_date',sDatef)
dw_jogun.SetItem(1,'to_date',sDatet)

dw_1.SetTransObject(SQLCA)

p_inq.TriggerEvent(Clicked!)
	
dw_jogun.SetFocus()
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sorder_popup2
integer y = 36
integer width = 1083
integer height = 108
string dataobject = "d_sorder_popup1_dpd"
end type

event dw_jogun::itemchanged;call super::itemchanged;String sarea, steam, sCvcod, scvnas, sSaupj, sName1
String sNull, sItnbr, sItdsc, sIspec, sIspecCode, sJijil
Int    iReturn
long   lcount

Choose Case GetColumnName() 
	Case "fr_date"
		IF f_datechk(trim(gettext())) = -1	then
			SetItem(1, "fr_date", sNull)
			return 1
		END IF
	Case "to_date"
		IF f_datechk(trim(gettext())) = -1	then
			SetItem(1, "to_date", sNull)
			return 1
		END IF	
END Choose
end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName() 
	/* 거래처 */
	Case "vndcod", "vndnm"
		gs_gubun = '1'
		If GetColumnName() = "vndnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"vndcod",gs_code)
		SetColumn("vndcod")
		TriggerEvent(ItemChanged!)		
	Case "itnbr"
		gs_code = GetText()
		open(w_itemas_popup)
		if isnull(gs_code) or gs_code = "" then 
			return
		end if
		SetItem(1, "itnbr", gs_code)
		SetItem(1, "itdsc", gs_codename)
		SetItem(1, "ispec", gs_gubun)
END Choose
end event

type p_exit from w_inherite_popup`p_exit within w_sorder_popup2
integer x = 3195
integer y = 12
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sorder_popup2
integer x = 2848
integer y = 12
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet

If dw_jogun.AcceptText() <> 1 Then Return -1

sdatef = dw_jogun.GetItemString(1,"fr_date")
sdatet = dw_jogun.GetItemString(1,"to_date")

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='00000000'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[수주일자]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SetRedraw(False)
IF 	dw_1.Retrieve(gs_sabu, gs_saupj, sdatef, sdatet) <= 0 THEN
	f_message_chk(50,'')
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SetRedraw(True)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_sorder_popup2
integer x = 3022
integer y = 12
end type

event p_choose::clicked;call super::clicked;long nRtn, i
string ls_chk

if dw_1.rowcount() < 1 then return 
if dw_1.AcceptText() = -1 then return 

setNull(gs_code)
setNull(gs_codename)
setNull(gs_gubun)

  /* 선택되지 않은 것은 삭제 */
dw_1.SetRedraw(False)
dw_1.SetFilter("chk = 'Y'")
dw_1.filter()
dw_1.SetRedraw(True)


If dw_1.RowCount() > 0 then
	nRtn = dw_1.SaveAs("dummy",Clipboard!,false)
	If nRtn = 1 Then
		gs_code     = Trim(dw_1.GetItemString(1, "itnbr"))
		gs_codename = string(dw_1.GetItemDecimal(1, "order_qty"))
		gs_gubun    = '1'
	Else
		f_message_chk(164,'')
	End If
End If


Close(parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_sorder_popup2
integer y = 204
integer width = 3346
integer height = 2012
integer taborder = 20
string dataobject = "d_sorder_popup2_dpd"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::itemerror;call super::itemerror;return 1
end event

type sle_2 from w_inherite_popup`sle_2 within w_sorder_popup2
boolean visible = false
integer x = 969
integer y = 2364
integer width = 1001
textcase textcase = anycase!
end type

type cb_1 from w_inherite_popup`cb_1 within w_sorder_popup2
integer x = 827
integer y = 2516
end type

type cb_return from w_inherite_popup`cb_return within w_sorder_popup2
integer x = 1477
integer y = 2516
end type

type cb_inq from w_inherite_popup`cb_inq within w_sorder_popup2
integer x = 1152
integer y = 2516
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_sorder_popup2
boolean visible = false
integer x = 539
integer y = 2348
integer width = 425
textcase textcase = anycase!
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_sorder_popup2
boolean visible = false
integer x = 270
integer y = 2368
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type cbx_1 from checkbox within w_sorder_popup2
integer x = 1175
integer y = 84
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;int i

if dw_1.rowcount() < 1 then return

if checked then
	for i = 1 to dw_1.rowcount()
		dw_1.setitem(i, 'chk' , 'Y')
	next
else
	for i = 1 to dw_1.rowcount()
		dw_1.setitem(i, 'chk' , 'N')
	next	
	
end if
end event

type rr_1 from roundrectangle within w_sorder_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 9
integer y = 28
integer width = 1134
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sorder_popup2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 196
integer width = 3369
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

