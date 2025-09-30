$PBExportHeader$w_pdt_02350.srw
$PBExportComments$작업지시 REVISION 처리
forward
global type w_pdt_02350 from w_inherite
end type
type gb_2 from groupbox within w_pdt_02350
end type
type rr_1 from roundrectangle within w_pdt_02350
end type
type rr_2 from roundrectangle within w_pdt_02350
end type
type dw_1 from datawindow within w_pdt_02350
end type
type st_2 from statictext within w_pdt_02350
end type
type dw_rela from datawindow within w_pdt_02350
end type
end forward

global type w_pdt_02350 from w_inherite
integer height = 2488
string title = "작업지시 REVISION"
gb_2 gb_2
rr_1 rr_1
rr_2 rr_2
dw_1 dw_1
st_2 st_2
dw_rela dw_rela
end type
global w_pdt_02350 w_pdt_02350

forward prototypes
public function integer wf_save_rtn (long arl_row)
end prototypes

public function integer wf_save_rtn (long arl_row);String ls_sabu, ls_pordno, ls_itnbr, ls_date, ls_sordno, ls_opdsc, ls_today, ls_totime
Dec ldc_pdqty, ldc_order_qty, ldc_sqty, ldc_qty
Int li_seq

ls_sabu   = Trim(dw_insert.Object.momast_sabu[arl_row])
ls_pordno = Trim(dw_insert.Object.momast_pordno[arl_row])
ls_itnbr  = Trim(dw_insert.Object.momast_itnbr[arl_row])
ls_date   = Trim(dw_insert.Object.inp_date[arl_row])
ls_sordno = Trim(dw_insert.Object.sorder_order_no[arl_row])
ls_opdsc  = Trim(dw_insert.Object.opdsc[arl_row])

ldc_qty 		  = truncate(dw_insert.Object.change_qty[arl_row],2)
ldc_pdqty 	  = dw_insert.Object.momast_pdqty[arl_row]
ldc_order_qty = dw_insert.Object.sorder_order_qty[arl_row]
ldc_sqty      = dw_insert.Object.momord_sqty[arl_row]

// 작업지시
Update momast set pdqty = :ldc_qty
 where sabu = :ls_sabu and
       pordno = :ls_pordno and
		 itnbr  = :ls_itnbr; 
If sqlca.sqlcode <> 0 Then
	messagebox("작업지시조정", "작업지시조정을 실패하였읍니다" + '~n' + &
									   sqlca.sqlerrtext, stopsign!)
	Rollback;
	Return -1
End If

// 할당
Update holdstock set hold_qty = ROUND(HOLD_QTY * (:ldc_qty / :ldc_pdqty), 2)
 where sabu   = :ls_sabu and
       pordno = :ls_pordno and
		 hosts = 'N';
If sqlca.sqlcode <> 0 Then
	Rollback;
	Return -1
End If

Select nvl(max(inp_seq),0) + 1 into :li_seq
  From momast_rev
 Where sabu     = :ls_sabu and
       pordno   = :ls_pordno and
		 inp_date = :ls_date ;

If sqlca.sqlcode <> 0 Then
	li_seq = 1
End IF

ls_today  = f_today()
ls_totime = f_totime()

Insert into momast_rev (sabu,           pordno,     inp_date,   inp_seq,    sordno,     itnbr,     pdqty, 
                        order_qty,      sqty,       change_qty, opsno_name,
							   crt_date,       crt_time,   crt_user,   upd_date,   upd_time,   upd_user)
                values (:ls_sabu,       :ls_pordno, :ls_date,   :li_seq,    :ls_sordno, :ls_itnbr, :ldc_pdqty,
					 			:ldc_order_qty, :ldc_sqty,  :ldc_qty,   :ls_opdsc,
								:ls_today,      :ls_totime, :gs_userid, :ls_today,  :ls_totime, :gs_userid) ;
If sqlca.sqlcode <> 0 Then
	Rollback;
	Return -1
End If

Return 1
end function

on w_pdt_02350.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_1=create dw_1
this.st_2=create st_2
this.dw_rela=create dw_rela
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.dw_rela
end on

on w_pdt_02350.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.dw_rela)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_rela.settransobject(sqlca)

dw_1.insertrow(0)
dw_1.setfocus()
end event

type dw_insert from w_inherite`dw_insert within w_pdt_02350
integer x = 27
integer y = 192
integer width = 4558
integer height = 1148
integer taborder = 30
string dataobject = "d_pdt_02350_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event dw_insert::doubleclicked;call super::doubleclicked;Long ll_row
String ls_pordno, ls_sabu

ll_row = GetRow()

if ll_row > 0 then
	ls_sabu   = getitemstring(ll_row, "momast_sabu")		
	ls_pordno = getitemstring(ll_row, "momast_pordno")	
	
	If dw_rela.retrieve(ls_sabu, ls_pordno) > 0 Then
		dw_rela.SetRow(1)
		dw_rela.SetFocus()
	End IF	
End if
end event

event dw_insert::itemerror;call super::itemerror;RETURN 1
end event

event dw_insert::itemchanged;call super::itemchanged;long ll_row
string spordno, ls_rt, ls_pt, ls_mt, ls_choice, ls_date
decimal ldc_sqty, ldc_change_qty, ldc_op_max

AcceptText()
ll_row = GetRow()

Choose Case GetColumnName()
	Case 'change_qty'
		ldc_sqty       = Object.momord_sqty[ll_row]
		ldc_op_max 		= Object.op_max[ll_row]
		ldc_change_qty = Object.change_qty[ll_row]
			
		If ldc_change_qty > ldc_sqty Then
			Messagebox('확인', '조정수량이 연결수량보다 많습니다.')
			Object.change_qty[ll_row] = 0
			Return 1
		End If	
			
		If ldc_change_qty < ldc_op_max Then
			Messagebox('확인', '조정수량이 공정실적 수량보다 작습니다.')
			Object.change_qty[ll_row] = 0
			Return 1
		End If	
	Case 'inp_date'
		ls_date = Trim(Object.inp_date[ll_row])
		If isnull(ls_date) Or ls_date = '' Then Return 1
		
		If f_datechk(ls_date) = -1 then
			f_message_chk(35,'[변경일자]') 		
			Object.inp_date[ll_row] = ''
			Return 1
		End If

End Choose



end event

type p_delrow from w_inherite`p_delrow within w_pdt_02350
boolean visible = false
integer x = 2999
integer y = 28
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02350
boolean visible = false
integer x = 2821
end type

type p_search from w_inherite`p_search within w_pdt_02350
boolean visible = false
integer x = 2459
end type

type p_ins from w_inherite`p_ins within w_pdt_02350
boolean visible = false
integer x = 3200
integer y = 28
end type

type p_exit from w_inherite`p_exit within w_pdt_02350
end type

type p_can from w_inherite`p_can within w_pdt_02350
end type

event p_can::clicked;call super::clicked;rollback;

dw_insert.reset()
dw_rela.reset()

dw_1.setfocus()
end event

type p_print from w_inherite`p_print within w_pdt_02350
boolean visible = false
integer x = 2647
end type

type p_inq from w_inherite`p_inq within w_pdt_02350
integer x = 3749
end type

event p_inq::clicked;call super::clicked;String ls_pordno, ls_ittyp

if dw_1.accepttext() = -1 then return

ls_pordno = TRim(dw_1.Object.rsd_pordno[1])
ls_ittyp  = dw_1.Object.rsd_ittyp[1]

if isnull(ls_pordno) or trim(ls_pordno) = '' then
	Messagebox("확인","작업지시번호가 없습니다.")
	Return 
end if

If dw_insert.Retrieve(gs_sabu, ls_pordno + '%', ls_ittyp) > 0 then
	p_mod.enabled = true
	p_mod.pictureName = "C:\erpman\image\저장_up.gif"
Else
		f_message_chk(50,'[작업지시 REVISION]')
End if
end event

type p_del from w_inherite`p_del within w_pdt_02350
end type

type p_mod from w_inherite`p_mod within w_pdt_02350
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;sle_msg.text = '자료를 저장중입니다'

Long ll_row, ll_cnt = 0
String sNull, ls_date
dec ldc_qty

Setnull(sNull)

If f_msg_update() = -1 then return

dw_insert.AcceptText()
If dw_insert.RowCount() < 1 then Return

For ll_row = 1 To dw_insert.rowcount()
	If dw_insert.Object.opt[ll_row] = 'Y' then
		ls_date = Trim(dw_insert.Object.inp_date[ll_row])
		ldc_qty = dw_insert.Object.change_qty[ll_row]
		IF isnull(ls_date) Or ls_date = '' Then 
			Messagebox("확인",String(ll_row) + ' 번째 자료에 변경일자가 없습니다.')
			Return
		End If	
		If ldc_qty <= 0 Then 
			Messagebox("확인",String(ll_row) + ' 번째 자료에 수량을 확인하세요.')
			Return
		End If	
		
		ll_cnt ++
	End if
Next

If ll_cnt = 0 Then
	Messagebox("확인","선택된 자료가 없습니다")
	Return
End IF	

For ll_row = 1 to dw_insert.rowcount()
	If dw_insert.Object.opt[ll_row] = 'Y' then
		ls_date = Trim(dw_insert.Object.inp_date[ll_row])
		ldc_qty = dw_insert.Object.change_qty[ll_row]
		IF isnull(ls_date) Or ls_date = '' Then Continue;
		If ldc_qty = 0 Then Continue;			
		
		If Wf_save_rtn(ll_row) = -1 Then 
			sle_msg.text = '자료 저장을 실패하였습니다.'			
			Return 
		End IF 
	End if
Next

sle_msg.text = '자료를 저장하였습니다.'
Commit;

p_can.TriggerEvent(Clicked!)
//If dw_insert.update() = 1 and dw_rela.update() = 1 then
//	Commit;
//	cb_can.triggerevent(clicked!)
//Else
//	rollback;
//	f_rollback()
//End if
end event

type cb_exit from w_inherite`cb_exit within w_pdt_02350
boolean visible = false
integer x = 2487
integer y = 2560
integer taborder = 130
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02350
boolean visible = false
integer x = 1746
integer y = 2560
integer taborder = 70
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02350
boolean visible = false
integer x = 210
integer y = 2552
integer taborder = 60
end type

type cb_del from w_inherite`cb_del within w_pdt_02350
boolean visible = false
integer x = 571
integer y = 2556
integer taborder = 80
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02350
boolean visible = false
integer x = 1376
integer y = 2560
integer taborder = 20
end type

type cb_print from w_inherite`cb_print within w_pdt_02350
boolean visible = false
integer x = 978
integer y = 2544
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_pdt_02350
end type

type cb_can from w_inherite`cb_can within w_pdt_02350
boolean visible = false
integer x = 2117
integer y = 2556
integer taborder = 100
end type

type cb_search from w_inherite`cb_search within w_pdt_02350
boolean visible = false
integer x = 1184
integer y = 236
integer taborder = 110
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_02350
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02350
end type

type gb_2 from groupbox within w_pdt_02350
boolean visible = false
integer x = 1321
integer y = 2508
integer width = 1550
integer height = 184
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type rr_1 from roundrectangle within w_pdt_02350
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 188
integer width = 4590
integer height = 1172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_02350
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 1432
integer width = 4590
integer height = 884
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_pdt_02350
event ue_key pbm_dwnkey
event ue_processenter pbm_dwnprocessenter
integer x = 23
integer y = 48
integer width = 2391
integer height = 116
integer taborder = 10
string dataobject = "d_pdt_02350_head"
boolean border = false
boolean livescroll = true
end type

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String ls_pordno

AcceptText()

If GetColumnName() = 'rsd_pordno' then
	ls_pordno = Object.rsd_pordno[1]
	If isnull(ls_pordno) Or Trim(ls_pordno) = '' Then Return 1
	
	If len(ls_pordno) < 7 Then
		Messagebox("확인","작업지시번호는 7자리 이상 입력되어야 됩니다.")
		Return 1
	End If	
End If	

end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "rsd_pordno"	THEN		
	open(w_jisi_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "rsd_pordno", gs_code)
end if
end event

type st_2 from statictext within w_pdt_02350
integer x = 41
integer y = 1376
integer width = 306
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "공정현황"
boolean focusrectangle = false
end type

type dw_rela from datawindow within w_pdt_02350
integer x = 27
integer y = 1436
integer width = 4558
integer height = 868
integer taborder = 50
string title = "공정현황"
string dataobject = "d_pdt_02350_2"
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;SelectRow(0,False)
SelectRow(currentrow,True)
ScrollToRow(currentrow)
end event

