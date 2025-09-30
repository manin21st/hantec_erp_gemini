$PBExportHeader$w_qa80_00090.srw
$PBExportComments$매출/매입클래임등록
forward
global type w_qa80_00090 from w_inherite
end type
type dw_jogun from datawindow within w_qa80_00090
end type
type dw_ip from datawindow within w_qa80_00090
end type
type cb_1 from commandbutton within w_qa80_00090
end type
type rr_1 from roundrectangle within w_qa80_00090
end type
end forward

global type w_qa80_00090 from w_inherite
integer width = 4672
string title = "매출/매입 클레임"
dw_jogun dw_jogun
dw_ip dw_ip
cb_1 cb_1
rr_1 rr_1
end type
global w_qa80_00090 w_qa80_00090

on w_qa80_00090.create
int iCurrent
call super::create
this.dw_jogun=create dw_jogun
this.dw_ip=create dw_ip
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_jogun
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_qa80_00090.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_jogun)
destroy(this.dw_ip)
destroy(this.cb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_jogun.SetItem(1, 'sdate', String(TODAY(), 'yyyymm'))
dw_jogun.SetItem(1, 'fdate', String(TODAY(), 'yyyymm'))

f_mod_saupj(dw_jogun, 'saupj')

end event

event open;call super::open;This.PostEvent('ue_open')
end event

type dw_insert from w_inherite`dw_insert within w_qa80_00090
integer x = 50
integer y = 236
integer width = 4535
integer height = 940
string dataobject = "d_qa80_00090_002"
boolean border = false
end type

event dw_insert::retrieveend;call super::retrieveend;If rowcount < 1 Then Return

String ls_jpno

ls_jpno = This.GetItemString(1, 'qajpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('매입 클레임 번호 확인', '매입 클레임 번호 이상입니다.')
	Return
End If

If dw_ip.Retrieve(ls_jpno) < 1 Then 
	dw_ip.InsertRow(0)
End If


end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(currentrow, True)

String ls_jpno

ls_jpno = This.GetItemString(currentrow, 'qajpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('매입 클레임 번호 확인', '매입 클레임 번호 이상입니다.')
	Return
End If

dw_ip.Retrieve(ls_jpno)
end event

event dw_insert::clicked;call super::clicked;If row < 1 Then Return

This.SelectRow(0, False)
This.SelectRow(row, True)

String ls_jpno

ls_jpno = This.GetItemString(row, 'qajpno')
If Trim(ls_jpno) = '' OR IsNull(ls_jpno) Then
	MessageBox('매입 클레임 번호 확인', '매입 클레임 번호 이상입니다.')
	Return
End If

dw_ip.Retrieve(ls_jpno)
end event

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)
end event

type p_delrow from w_inherite`p_delrow within w_qa80_00090
boolean visible = false
integer x = 5312
integer y = 176
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_qa80_00090
boolean visible = false
integer x = 5138
integer y = 176
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_qa80_00090
boolean visible = false
integer x = 4791
integer y = 176
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_qa80_00090
integer x = 3707
end type

event p_ins::clicked;call super::clicked;dw_ip.ReSet()
dw_ip.InsertRow(0)
end event

type p_exit from w_inherite`p_exit within w_qa80_00090
integer x = 4402
end type

type p_can from w_inherite`p_can within w_qa80_00090
integer x = 4229
end type

event p_can::clicked;call super::clicked;dw_insert.ReSet()

dw_ip.ReSet()

dw_ip.InsertRow(0)
end event

type p_print from w_inherite`p_print within w_qa80_00090
boolean visible = false
integer x = 4965
integer y = 176
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_qa80_00090
integer x = 3534
end type

event p_inq::clicked;call super::clicked;dw_jogun.AcceptText()

Long   row

row = dw_jogun.GetRow()
If row < 1 Then Return

String ls_saupj

ls_saupj = dw_jogun.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '%'

String ls_sdate, ls_gubun

ls_sdate = dw_jogun.GetItemString(row, 'sdate')
If Trim(ls_sdate) = '' OR IsNull(ls_sdate) Then	ls_sdate = '190001'

String ls_fdate

ls_fdate = dw_jogun.GetItemString(row, 'fdate')
If Trim(ls_fdate) = '' OR IsNull(ls_fdate) Then ls_fdate = '299912'

ls_gubun = dw_jogun.GetItemString(row, 'gubun')

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_saupj, ls_sdate, ls_gubun, ls_fdate)
dw_insert.SetRedraw(True)

end event

type p_del from w_inherite`p_del within w_qa80_00090
integer x = 4055
end type

event p_del::clicked;call super::clicked;Long   row

row = dw_ip.GetRow()
If row < 1 Then Return

If f_msg_delete() <> 1 Then Return

dw_ip.DeleteRow(row)

If dw_ip.UPDATE() = 1 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제실패', '자료 삭제 중 오류가 발생했습니다.')
	Return
End If

p_inq.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_qa80_00090
integer x = 3881
end type

event p_mod::clicked;call super::clicked;dw_ip.AcceptText()

If f_msg_update() <> 1 Then Return

//필수
String ls_yymm, ls_create

ls_create = dw_ip.GetItemString(1, 'crt_flag')

//ls_yymm = dw_ip.GetItemString(1, 'yyyymm')
//If Trim(ls_yymm) = '' OR IsNull(ls_yymm) Then
//	MessageBox('발생년월 확인', '발생년월은 필수 항목 입니다.')
//	dw_ip.SetColumn('yyyymm')
//	dw_ip.SetFocus()
//	Return
//End If


if ls_create = 'Y' then
	//매입클레임전표번호 생성
	String ls_day
	ls_day = String(TODAY(), 'yyyymmdd')
	
	Long   ll_seq
	ll_seq = SQLCA.FUN_JUNPYO(gs_sabu, ls_day, 'E1')
	
	If ll_seq < 1 OR ll_seq > 9999 Then
		ROLLBACK USING SQLCA;
		f_message_chk(51, '')
		Return
	End If
	
	COMMIT USING SQLCA;
	
	String ls_jpno
	ls_jpno = ls_day + String(ll_seq, '0000') + '001'
	
	dw_ip.SetItem(1, 'sabu'  , gs_sabu)
	dw_ip.SetItem(1, 'qajpno', ls_jpno)
	dw_ip.SetItem(1, 'saupj', dw_jogun.GetItemString(1, 'saupj'))
end if

dw_ip.SetItem(1, 'yyyymm', left(dw_ip.GetItemString(1, 'whdate'),6))

If dw_ip.UPDATE() = 1 Then
	COMMIT USING SQLCA;
//	MessageBox('전표번호 확인', '전표번호 : ' + ls_day + '-' + String(ll_seq, '0000')+ '~r~r생성되었습니다.')
Else
	ROLLBACK USING SQLCA;
	MessageBox('저장오류', '자료 저장 중 오류가 발생 했습니다.')
	Return
End If

p_inq.triggerevent(clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_qa80_00090
end type

type cb_mod from w_inherite`cb_mod within w_qa80_00090
end type

type cb_ins from w_inherite`cb_ins within w_qa80_00090
end type

type cb_del from w_inherite`cb_del within w_qa80_00090
end type

type cb_inq from w_inherite`cb_inq within w_qa80_00090
end type

type cb_print from w_inherite`cb_print within w_qa80_00090
end type

type st_1 from w_inherite`st_1 within w_qa80_00090
end type

type cb_can from w_inherite`cb_can within w_qa80_00090
end type

type cb_search from w_inherite`cb_search within w_qa80_00090
end type







type gb_button1 from w_inherite`gb_button1 within w_qa80_00090
end type

type gb_button2 from w_inherite`gb_button2 within w_qa80_00090
end type

type dw_jogun from datawindow within w_qa80_00090
integer x = 37
integer y = 20
integer width = 2505
integer height = 184
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa80_00090_001"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)

end event

type dw_ip from datawindow within w_qa80_00090
event ue_enter pbm_dwnprocessenter
integer x = 37
integer y = 1216
integer width = 4562
integer height = 1056
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa80_00090_003"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(This), 256, 9, 0)
Return 1
end event

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)

end event

event itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'tbyn'
		If data = 'Y' Then
			This.SetItem(row, 'tbdate', String(TODAY(), 'yyyymmdd'))
			This.SetItem(row, 'wempno', gs_empno)
			This.SetItem(row, 'empname', f_get_name5('02', gs_empno, ''))
		Else
			This.SetItem(row, 'tbdate', '')
			This.SetItem(row, 'wempno', '')
			This.SetItem(row, 'empname', '')
		End If
		
	Case 'itnbr'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'itdsc', data)
		Else
			This.SetItem(row, 'itdsc', f_get_name5('13', data, ''))
		End If
		
	Case 'cvcod'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvnas', data)
		Else
			This.SetItem(row, 'cvnas', f_get_name5('11', data, ''))
		End If
		
	Case 'tempno'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'tcvnas', data)
		Else
			This.SetItem(row, 'tcvnas', f_get_name5('11', data, ''))
		End If

	Case 'wempno'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'empname', data)
		Else
			This.SetItem(row, 'empname', f_get_name5('02', data, ''))
		End If
End Choose
end event

event rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'itnbr'
		Open(w_itemas_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'itnbr', gs_code)
		This.SetItem(row, 'itdsc', gs_codename)
		
	Case 'cvcod'
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'cvcod', gs_code)
		This.SetItem(row, 'cvnas', gs_codename)
		
	Case 'tempno'
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'tempno', gs_code)
		This.SetItem(row, 'tcvnas', gs_codename)

	Case 'wempno'
		Open(w_sawon_popup)
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
		This.SetItem(row, 'wempno' , gs_code    )
		This.SetItem(row, 'empname', gs_codename)
End Choose
		
end event

type cb_1 from commandbutton within w_qa80_00090
integer x = 2665
integer y = 36
integer width = 805
integer height = 124
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "매출(VAN)클레임 가져오기"
end type

event clicked;Long 		i, ll_cnt, ll_seq, ll_no
str_code lst_code
string	scl_jpno, ls_day, ls_jpno, ls_saupj

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

open(w_qa03_00020_popup)
if gs_code = 'OK' then
	lst_code = Message.PowerObjectParm
	IF isValid(lst_code) = False Then Return 
	If UpperBound(lst_code.code) < 1 Then Return 
	
	//전표번호 채번
	ls_day = String(TODAY(), 'yyyymmdd')
	ll_seq = SQLCA.FUN_JUNPYO(gs_sabu, ls_day, 'E1')
	If ll_seq < 1 OR ll_seq > 9999 Then
		ROLLBACK USING SQLCA;
		f_message_chk(51, '')
		Return
	End If
	COMMIT USING SQLCA;

	ls_saupj = dw_jogun.GetItemString(1, 'saupj')
	
	SETPOINTER(HOURGLASS!)
	For i = 1 To UpperBound(lst_code.code)
		scl_jpno = lst_code.code[i]
		
		select count(*) into :ll_cnt from qa_clhist
		 where sabu = :gs_sabu and acjpno = :scl_jpno ;
		if ll_cnt > 0 then continue
		
		ll_no++
		ls_jpno = ls_day + String(ll_seq, '0000') + String(ll_no, '000')
	

	  	insert into qa_clhist
		(	sabu,				qajpno,				itnbr,				cvcod,				
			acjpno,			totamt,
			yyyymm,			clmgbn,										whdate,				saupj	)
		select
			:gs_sabu,		:ls_jpno,			itnbr,				decode(vnd_gb,'H','201021','K','201005',null),
			cl_jpno,			nvl(it_amt,0) + nvl(trans_amt,0) + nvl(wai_amt,0),
			ro_yymm,			decode(end_yn,'1','O','A'),			ro_yymm||'01',		:ls_saupj
		  from clamst_boogook
		 where sabu = :ls_saupj and cl_jpno = :scl_jpno ;
		
		if sqlca.sqlcode <> 0 then
			ROLLBACK;
			MessageBox("확인", "클레임자료 생성 실패!!!", stopsign!)
			return	
		end if		
	Next
	
	COMMIT;
end if

p_inq.triggerevent(clicked!)
end event

type rr_1 from roundrectangle within w_qa80_00090
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 224
integer width = 4562
integer height = 964
integer cornerheight = 40
integer cornerwidth = 55
end type

