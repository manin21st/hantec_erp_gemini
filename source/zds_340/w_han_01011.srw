$PBExportHeader$w_han_01011.srw
$PBExportComments$자재소진내역 조정
forward
global type w_han_01011 from w_inherite
end type
type rr_2 from roundrectangle within w_han_01011
end type
type dw_1 from u_key_enter within w_han_01011
end type
type pb_1 from u_pb_cal within w_han_01011
end type
type cb_1 from commandbutton within w_han_01011
end type
type cb_2 from commandbutton within w_han_01011
end type
end forward

global type w_han_01011 from w_inherite
integer width = 4654
integer height = 2480
string title = "자재 소진내역 조정"
rr_2 rr_2
dw_1 dw_1
pb_1 pb_1
cb_1 cb_1
cb_2 cb_2
end type
global w_han_01011 w_han_01011

on w_han_01011.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.dw_1=create dw_1
this.pb_1=create pb_1
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_2
end on

on w_han_01011.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)

dw_insert.SetTransObject(sqlca)


dw_1.InsertRow(0)

dw_1.SetItem(1, 'd_st', String(TODAY(), 'yyyymmdd'))

f_mod_saupj(dw_1, 'saupj')

//dw_1.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

//String ls_st
//ls_st = f_get_syscnfg('Y', 89, 'ST')
//If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '0800'
//
//String ls_ed
//ls_ed = f_get_syscnfg('Y', 89, 'ED')
//If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '0630'
//
//dw_1.SetItem(1, 'stim', ls_st)
//dw_1.SetItem(1, 'etim', ls_ed)
end event

type dw_insert from w_inherite`dw_insert within w_han_01011
integer x = 55
integer y = 216
integer width = 4517
integer height = 2068
integer taborder = 150
string dataobject = "d_han_01011_hist_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::clicked;call super::clicked;if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(row,True)
end event

type p_delrow from w_inherite`p_delrow within w_han_01011
boolean visible = false
integer x = 5413
integer y = 536
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;Long nRow

If f_msg_delete() <> 1 Then	REturn

nRow = dw_insert.GetRow()
If nRow > 0 then
	dw_insert.DeleteRow(nRow)
	
	If dw_insert.Update() <> 1 Then
		RollBack;
		f_message_chk(31,'')
		Return
	End If
	Commit;
End If
end event

type p_addrow from w_inherite`p_addrow within w_han_01011
boolean visible = false
integer x = 5230
integer y = 536
integer taborder = 50
end type

event p_addrow::clicked;String sYymm, sCust
Long	 nRow, dMax

If dw_1.AcceptText() <> 1 Then Return

sYymm = Trim(dw_1.GetItemString(1, 'yymm'))
scust = Trim(dw_1.GetItemString(1, 'cust'))
If sCust < '4' Then Return

If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'yymm', sYymm)

end event

type p_search from w_inherite`p_search within w_han_01011
boolean visible = false
integer x = 3456
integer y = 88
integer taborder = 130
boolean originalsize = true
string picturename = "C:\erpman\image\MRP_up.gif"
end type

event type long p_search::ue_lbuttondown(unsignedlong flags, integer xpos, integer ypos);call super::ue_lbuttondown;PictureName = "C:\erpman\image\MRP_dn.gif"
return 0
end event

event type long p_search::ue_lbuttonup(unsignedlong flags, integer xpos, integer ypos);call super::ue_lbuttonup;PictureName = "C:\erpman\image\MRP_up.gif"
return 0
end event

event type long p_search::ue_mousemove(unsignedlong flags, integer xpos, integer ypos);call super::ue_mousemove;//iF flags = 0 Then wf_onmouse(p_search)
return 0
end event

type p_ins from w_inherite`p_ins within w_han_01011
boolean visible = false
integer x = 3250
integer y = 92
integer taborder = 30
string picturename = "C:\erpman\image\메일전송_up.gif"
end type

event type long p_ins::ue_lbuttondown(unsignedlong flags, integer xpos, integer ypos);//PictureName = "C:\erpman\image\조정2_dn.gif"
return 0
end event

event type long p_ins::ue_lbuttonup(unsignedlong flags, integer xpos, integer ypos);//PictureName = "C:\erpman\image\조정2_up.gif"
return 0
end event

event type long p_ins::ue_mousemove(unsignedlong flags, integer xpos, integer ypos);//iF flags = 0 Then wf_onmouse(p_ins)
return 0
end event

event p_ins::clicked;call super::clicked;String 	ls_window_id , ls_window_nm, syyyy

dw_1.accepttext()

syyyy = trim(dw_1.getitemstring(1,'yyyy'))
if Isnull(syyyy) or syyyy = '' then
	f_message_chk(1400,'[계획년도]')
	return
end if

ls_window_id = 'w_pu01_00010'
ls_window_nm = '년 구매계획'

If ls_window_id = '' or isNull(ls_window_id) Then
	messagebox('','프로그램명이 없습니다.')
	return
End If

gs_code = '년 구매계획'
gs_codename = syyyy + '년 구매계획을 수립했습니다.'
OpenWithParm(w_mail_insert , ls_window_id + Space(100) + ls_window_nm)
end event

type p_exit from w_inherite`p_exit within w_han_01011
integer x = 4398
integer y = 40
integer taborder = 110
end type

type p_can from w_inherite`p_can within w_han_01011
integer x = 4224
integer y = 40
integer taborder = 90
end type

type p_print from w_inherite`p_print within w_han_01011
boolean visible = false
integer x = 5047
integer y = 536
integer taborder = 140
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_han_01011
integer x = 3877
integer y = 40
end type

event p_inq::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return  

String ls_st , ls_ed
String ls_jocod , ls_wkctr , ls_itnbr
Long ll_row

ls_st = dw_1.GetItemString(1, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	MessageBox('일자확인', '일자를 확인하세요')
	dw_1.SetColumn('d_st')
	dw_1.SetFocus()
	Return -1
End If

String  ls_saupj
ls_saupj = dw_1.GetItemString(1, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '%'

//ls_ed = dw_1.GetItemString(1, 'd_ed')
//If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
//	ls_ed = '29991231'
//End If

//If ls_st > ls_ed Then
//	MessageBox('기간확인', '시작일 보다 종료일이 빠릅니다.')
//	dw_1.SetColumn('d_st')
//	dw_1.SetFocus()
//	Return -1
//End If

//ls_jocod = dw_1.GetItemString(1, 'jocod')
//If IsNull(ls_jocod) Then ls_jocod = '%'
//
//ls_wkctr = dw_1.GetItemString(1, 'wkctr')
//If IsNull(ls_wkctr) Then ls_wkctr = '%'
//
//ls_itnbr = dw_1.GetItemString(1, 'itnbr')
//If IsNull(ls_itnbr) Then ls_itnbr = '%'

pointer oldpointer 

oldpointer = SetPointer(HourGlass!)

dw_insert.SetRedraw(False)
ll_row = dw_insert.Retrieve(ls_st, ls_st, ls_saupj)
dw_insert.SetRedraw(True)


dw_insert.scrolltorow(1)
dw_insert.SetFocus()

SetPointer(oldpointer)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event

type p_del from w_inherite`p_del within w_han_01011
boolean visible = false
integer x = 4864
integer y = 536
integer taborder = 80
end type

type p_mod from w_inherite`p_mod within w_han_01011
integer x = 4050
integer y = 40
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;Long		ll_rcnt , i , ll_cnt , ll_row , ll_count
String	ls_shpjpno

ll_rcnt = dw_insert.RowCount()
If ll_rcnt <= 0 then Return

If dw_insert.Find("mod='Y'", 1, ll_rcnt) <= 0 Then Return

If f_msg_update() = -1 Then Return  //저장 Yes/No ?

For i=1 To ll_rcnt	
	If dw_insert.object.mod[i] = 'Y' then		 
		ls_shpjpno = dw_insert.object.shpact_shpjpno[i]
		
		// 인터페이스 자료를 업데이트
		UPDATE SHPACT 
		   SET UPD_DATE = :is_today, UPD_TIME = :is_totime, UPD_USER = :gs_userid
		 WHERE SABU = '1' AND SHPJPNO = :ls_shpjpno;
		
		If SQLCA.SQLCODE <> 0 then
			MessageBox("DB Update Error!",SQLCA.SQLErrText)
			Rollback ;
			Return
		End If
	End If
Next

Commit ;
MessageBox("성공","저장성공 하였습니다.")




end event

type cb_exit from w_inherite`cb_exit within w_han_01011
integer x = 3022
integer y = 2936
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_han_01011
integer x = 709
integer y = 2936
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_han_01011
integer x = 347
integer y = 2936
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_han_01011
integer x = 1070
integer y = 2936
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_han_01011
integer x = 1431
integer y = 2936
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_han_01011
integer x = 1792
integer y = 2936
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_han_01011
integer x = 59
integer y = 3148
end type

type cb_can from w_inherite`cb_can within w_han_01011
integer x = 2117
integer y = 2896
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_han_01011
integer x = 2514
integer y = 2936
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_han_01011
integer x = 2903
integer y = 3148
boolean enabled = false
end type

type sle_msg from w_inherite`sle_msg within w_han_01011
integer x = 411
integer y = 3148
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_han_01011
integer x = 41
integer y = 3096
boolean enabled = false
end type

type gb_button1 from w_inherite`gb_button1 within w_han_01011
integer x = 1211
integer y = 3368
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_han_01011
integer x = 1755
integer y = 3392
boolean enabled = false
end type

type rr_2 from roundrectangle within w_han_01011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 204
integer width = 4544
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from u_key_enter within w_han_01011
integer x = 32
integer y = 32
integer width = 1943
integer height = 164
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_han_01011_hist_001"
boolean border = false
end type

event itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'itnbr'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'itdsc', '')
			Return
		End If
		
		This.SetItem(row, 'itdsc', f_get_name5('13', data, ''))
		
	Case 'itcls'
		String ls_ittyp
		ls_ittyp = This.GetItemString(row, 'ittyp')
		If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then
			MessageBox('품목구분 확인', '품목구분을 선택하신 후 분류를 지정 하십시오.')
			This.SetItem(row, 'itcls', '')
			Return 2
		End If
		
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'itnct', '')
			Return
		End If
		
		This.SetItem(row, 'itnct', f_get_name5('12', data, ls_ittyp))
		
	Case 'wkctr'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'wcdsc', '')
			Return
		End If
		
		This.SetItem(row, 'wcdsc', f_get_name5('05', data, ''))
		
//	Case 'd_st'
//		If Trim(data) = '' OR IsNull(data) Then Return
//		
//		If data = This.GetItemString(row, 'd_ed') Then
//			This.SetItem(row, 'etim', '2400')
//		Else
//			This.SetItem(row, 'etim', f_get_syscnfg('Y', 89, 'ED'))
//		End If
//		
//	Case 'd_ed'
//		If Trim(data) = '' OR IsNull(data) Then Return
//		
//		If data = This.GetItemString(row, 'd_st') Then
//			This.SetItem(row, 'etim', '2400')
//		Else
//			This.SetItem(row, 'etim', f_get_syscnfg('Y', 89, 'ED'))
//		End If
End Choose
end event

event rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'itnbr'
		Open(w_itemas_popup3)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'itnbr', gs_code)
		This.SetItem(row, 'itdsc', gs_codename)
		
	Case 'itcls'
		String ls_ittyp 
		ls_ittyp = This.GetItemString(row, 'ittyp')
		OpenWithParm(w_ittyp_popup, ls_ittyp)
		
		str_itnct lstr_sitnct
		
		lstr_sitnct = Message.PowerObjectParm
		
		If Trim(lstr_sitnct.s_ittyp) = '' OR IsNull(lstr_sitnct.s_ittyp) Then Return
		
		This.SetItem(row, 'ittyp', lstr_sitnct.s_ittyp )
		This.SetItem(row, 'itcls', lstr_sitnct.s_sumgub)
		This.SetItem(row, 'itnct', lstr_sitnct.s_titnm )
		
	Case 'wkctr'
		Open(w_workplace_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'wkctr', gs_code)
		This.SetItem(row, 'wcdsc', gs_codename)

End Choose
end event

type pb_1 from u_pb_cal within w_han_01011
integer x = 741
integer y = 72
integer height = 76
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'd_st', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

If gs_code = dw_1.GetItemString(1, 'd_ed') Then
	dw_1.SetItem(1, 'etim', '2400')
Else
	dw_1.SetItem(1, 'etim', f_get_syscnfg('Y', 89, 'ED'))
End If
end event

type cb_1 from commandbutton within w_han_01011
integer x = 2021
integer y = 60
integer width = 613
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "소진내역 추가"
end type

event clicked;Long 		ll_row
String	ls_pinbr, ls_cinbr

ll_row = dw_insert.GetSelectedRow(0)
If ll_row <= 0 then Return

ls_pinbr = dw_insert.object.shpact_itnbr[ll_row]
ls_cinbr = dw_insert.object.c_so_itnbr[ll_row]

if isnull(ls_cinbr) or ls_cinbr = '' then
	select cinbr
	  into :ls_cinbr
	  from pstruc
    where pinbr = :ls_pinbr and cinbr like 'C%' and rownum = 1;
end if

str_code lstr_code

lstr_code.code[1] = ''
lstr_code.code[2] = ls_cinbr
lstr_code.code[3] = dw_insert.object.lotsno[ll_row]
lstr_code.code[4] = dw_insert.object.shpact_sidat[ll_row]
lstr_code.code[5] = dw_insert.object.shpact_shpjpno[ll_row]

OpenWithParm(w_han_01011_hist_pop, lstr_code)
if gs_code = 'OK' then
	dw_insert.object.mod[ll_row] = 'Y'
end if

end event

type cb_2 from commandbutton within w_han_01011
integer x = 2720
integer y = 60
integer width = 613
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "소진내역 수정"
end type

event clicked;Long ll_row

ll_row = dw_insert.GetSelectedRow(0)
If ll_row <= 0 then Return

gs_code = dw_insert.object.shpact_shpjpno[ll_row]
Open(w_han_01011_hist_pop2)
if gs_code = 'OK' then
	dw_insert.object.mod[ll_row] = 'Y'
end if

end event

