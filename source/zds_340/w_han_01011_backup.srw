$PBExportHeader$w_han_01011_backup.srw
$PBExportComments$자재소진내역 조정
forward
global type w_han_01011_backup from w_inherite
end type
type rr_2 from roundrectangle within w_han_01011_backup
end type
type dw_1 from u_key_enter within w_han_01011_backup
end type
type dw_3 from datawindow within w_han_01011_backup
end type
type st_info2 from statictext within w_han_01011_backup
end type
type rr_1 from roundrectangle within w_han_01011_backup
end type
type st_info1 from statictext within w_han_01011_backup
end type
type dw_list from datawindow within w_han_01011_backup
end type
type pb_1 from u_pb_cal within w_han_01011_backup
end type
type pb_2 from u_pb_cal within w_han_01011_backup
end type
type st_2 from statictext within w_han_01011_backup
end type
type st_3 from statictext within w_han_01011_backup
end type
type rr_3 from roundrectangle within w_han_01011_backup
end type
type rr_4 from roundrectangle within w_han_01011_backup
end type
end forward

global type w_han_01011_backup from w_inherite
integer width = 4635
integer height = 2460
string title = "자재 소진내역 조정"
rr_2 rr_2
dw_1 dw_1
dw_3 dw_3
st_info2 st_info2
rr_1 rr_1
st_info1 st_info1
dw_list dw_list
pb_1 pb_1
pb_2 pb_2
st_2 st_2
st_3 st_3
rr_3 rr_3
rr_4 rr_4
end type
global w_han_01011_backup w_han_01011_backup

on w_han_01011_backup.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.dw_1=create dw_1
this.dw_3=create dw_3
this.st_info2=create st_info2
this.rr_1=create rr_1
this.st_info1=create st_info1
this.dw_list=create dw_list
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_2=create st_2
this.st_3=create st_3
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.st_info2
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.st_info1
this.Control[iCurrent+7]=this.dw_list
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.rr_3
this.Control[iCurrent+13]=this.rr_4
end on

on w_han_01011_backup.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.st_info2)
destroy(this.rr_1)
destroy(this.st_info1)
destroy(this.dw_list)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)
dw_3.SetTransObject(sqlca)


dw_1.InsertRow(0)

dw_1.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_1.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

String ls_st
ls_st = f_get_syscnfg('Y', 89, 'ST')
If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '0800'

String ls_ed
ls_ed = f_get_syscnfg('Y', 89, 'ED')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '0630'

dw_1.SetItem(1, 'stim', ls_st)
dw_1.SetItem(1, 'etim', ls_ed)
end event

type dw_insert from w_inherite`dw_insert within w_han_01011_backup
integer x = 50
integer y = 1780
integer width = 4512
integer height = 476
integer taborder = 150
string dataobject = "d_han_01011_004"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;this.selectrow(0,false)
end event

event dw_insert::clicked;call super::clicked;this.selectrow(0,false)
//post wf_history(this,row)
end event

event dw_insert::doubleclicked;call super::doubleclicked;//if row <= 0 then return
//
//long		lrow
//string	sitnbr, scvcod
//
//sitnbr = this.getitemstring(row,'pu01_yearplan_itnbr')
//scvcod = this.getitemstring(row,'pu01_yearplan_cvcod')
//
//lrow = dw_insert2.find("pu01_yearplan_itnbr='"+sitnbr+"' and "+&
//							 "pu01_yearplan_cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
//if lrow > 0 then
//	dw_7.setitem(1,'gubun','2')
//	dw_7.triggerevent(itemchanged!)
//
//	lrow = dw_insert2.find("pu01_yearplan_itnbr='"+sitnbr+"' and "+&
//							 "pu01_yearplan_cvcod='"+scvcod+"'",1,dw_insert2.rowcount())
//							 
//	this.selectrow(0,false)	
//	dw_insert2.setrow(lrow)
//	dw_insert2.selectrow(0,false)
//	dw_insert2.selectrow(lrow,true)
//	dw_insert2.scrolltorow(lrow)	
//end if
end event

type p_delrow from w_inherite`p_delrow within w_han_01011_backup
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

type p_addrow from w_inherite`p_addrow within w_han_01011_backup
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

type p_search from w_inherite`p_search within w_han_01011_backup
boolean visible = false
integer x = 3584
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

type p_ins from w_inherite`p_ins within w_han_01011_backup
boolean visible = false
integer x = 3168
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

type p_exit from w_inherite`p_exit within w_han_01011_backup
integer x = 4421
integer y = 88
integer taborder = 110
end type

type p_can from w_inherite`p_can within w_han_01011_backup
integer x = 4247
integer y = 88
integer taborder = 90
end type

type p_print from w_inherite`p_print within w_han_01011_backup
boolean visible = false
integer x = 5047
integer y = 536
integer taborder = 140
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_han_01011_backup
integer x = 3899
integer y = 88
end type

event p_inq::clicked;call super::clicked;string sabu_f, sabu_t,sabu_nm

if dw_1.AcceptText() = -1 then return  

w_mdi_frame.sle_msg.text =""

SetPointer(HourGlass!)


Long ll_row , ll_row2

ll_row = dw_1.GetRow()
If ll_row < 1 Then Return -1

String ls_st
String ls_ed

ls_st = dw_1.GetItemString(ll_row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못되었습니다.')
		dw_1.SetColumn('d_st')
		dw_1.SetFocus()
		Return -1
	End If
End If

ls_ed = dw_1.GetItemString(ll_row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못되었습니다.')
		dw_1.SetColumn('d_ed')
		dw_1.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간확인', '시작일 보다 종료일이 빠릅니다.')
	dw_1.SetColumn('d_st')
	dw_1.SetFocus()
	Return -1
End If

String ls_stim

ls_stim = dw_1.GetItemString(ll_row, 'stim')
If Trim(ls_stim) = '' OR IsNull(ls_stim) Then ls_stim = '0800'

String ls_etim

ls_etim = dw_1.GetItemString(ll_row, 'etim')
If Trim(ls_etim) = '' OR IsNull(ls_etim) Then ls_etim = '0630'

String ls_itnbr

ls_itnbr = dw_1.GetItemString(ll_row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

String ls_itcls

ls_itcls = dw_1.GetItemString(ll_row, 'itcls')
If Trim(ls_itcls) = '' OR IsNull(ls_itcls) Then ls_itcls = '%'

String ls_itnct

ls_itnct = dw_1.GetItemString(ll_row, 'itnct')
If Trim(ls_itnct) = '' OR IsNull(ls_itnct) Then
	ls_itnct = '%'
Else
	ls_itnct = '%' + ls_itnct + '%'
End If

String ls_jocod

ls_jocod = dw_1.GetItemString(ll_row, 'jocod')
If Trim(ls_jocod) = '' OR IsNull(ls_jocod) Then
	ls_jocod = '%'
Else
	ls_jocod = ls_jocod + '%'
End If

String ls_wkctr

ls_wkctr = dw_1.GetItemString(ll_row, 'wkctr')
If Trim(ls_wkctr) = '' OR IsNull(ls_wkctr) Then ls_wkctr = '%'

String ls_empnm

ls_empnm = dw_1.GetItemString(ll_row, 'empnm')
If Trim(ls_empnm) = '' OR IsNull(ls_empnm) Then
	ls_empnm = '%'
Else
	ls_empnm = '%' + ls_empnm + '%'
End If

String ls_ittyp , ls_shpjpno ,ls_lotsno 


ls_ittyp = dw_1.GetItemString(ll_row, 'ittyp')
If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then ls_ittyp = '%'

dw_list.SetRedraw(False)
ll_row = dw_list.Retrieve(ls_st, ls_ed, ls_itnbr, ls_itcls, ls_itnct, ls_jocod, ls_wkctr, ls_empnm, ls_ittyp, ls_stim, ls_etim)
dw_list.SetRedraw(True)

if ll_row > 0 then
	
	ls_shpjpno = dw_list.getitemstring(1, "shpact_shpjpno")
	ll_row2 = dw_3.retrieve(ls_shpjpno)
	
	If ll_row2 > 0 then
			ls_lotsno = dw_3.object.lotsno[1]
			ls_itnbr = dw_3.object.itnbr[1]
			
			dw_insert.retrieve(ls_lotsno , ls_itnbr)
		
	end if
end if


dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

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

type p_del from w_inherite`p_del within w_han_01011_backup
boolean visible = false
integer x = 4864
integer y = 536
integer taborder = 80
end type

type p_mod from w_inherite`p_mod within w_han_01011_backup
integer x = 4073
integer y = 88
integer taborder = 70
end type

type cb_exit from w_inherite`cb_exit within w_han_01011_backup
integer x = 3022
integer y = 2936
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_han_01011_backup
integer x = 709
integer y = 2936
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_han_01011_backup
integer x = 347
integer y = 2936
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_han_01011_backup
integer x = 1070
integer y = 2936
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_han_01011_backup
integer x = 1431
integer y = 2936
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_han_01011_backup
integer x = 1792
integer y = 2936
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_han_01011_backup
integer x = 59
integer y = 3148
end type

type cb_can from w_inherite`cb_can within w_han_01011_backup
integer x = 2117
integer y = 2896
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_han_01011_backup
integer x = 2514
integer y = 2936
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_han_01011_backup
integer x = 2903
integer y = 3148
boolean enabled = false
end type

type sle_msg from w_inherite`sle_msg within w_han_01011_backup
integer x = 411
integer y = 3148
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_han_01011_backup
integer x = 41
integer y = 3096
boolean enabled = false
end type

type gb_button1 from w_inherite`gb_button1 within w_han_01011_backup
integer x = 1211
integer y = 3368
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_han_01011_backup
integer x = 1755
integer y = 3392
boolean enabled = false
end type

type rr_2 from roundrectangle within w_han_01011_backup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 1772
integer width = 4544
integer height = 492
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from u_key_enter within w_han_01011_backup
integer x = 41
integer y = 36
integer width = 3831
integer height = 248
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_han_01011_001"
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
		
	Case 'd_st'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		If data = This.GetItemString(row, 'd_ed') Then
			This.SetItem(row, 'etim', '2400')
		Else
			This.SetItem(row, 'etim', f_get_syscnfg('Y', 89, 'ED'))
		End If
		
	Case 'd_ed'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		If data = This.GetItemString(row, 'd_st') Then
			This.SetItem(row, 'etim', '2400')
		Else
			This.SetItem(row, 'etim', f_get_syscnfg('Y', 89, 'ED'))
		End If
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

type dw_3 from datawindow within w_han_01011_backup
integer x = 50
integer y = 1204
integer width = 4512
integer height = 468
integer taborder = 160
boolean bringtotop = true
string title = "none"
string dataobject = "d_han_01011_003"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;string ls_lotsno , ls_itnbr
Long	 ll_row

w_mdi_frame.sle_msg.text =""	

if row > 0 then
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)	

	ls_lotsno = This.object.lotsno[row]
	ls_itnbr = this.object.itnbr[row]
	dw_insert.retrieve(ls_lotsno, ls_itnbr)
end if
end event

type st_info2 from statictext within w_han_01011_backup
boolean visible = false
integer x = 2075
integer y = 1032
integer width = 1047
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33551600
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_han_01011_backup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 304
integer width = 4544
integer height = 800
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_info1 from statictext within w_han_01011_backup
boolean visible = false
integer x = 1536
integer y = 1032
integer width = 530
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33551600
string text = "자재 소요량 계산 :"
boolean focusrectangle = false
end type

type dw_list from datawindow within w_han_01011_backup
integer x = 50
integer y = 312
integer width = 4512
integer height = 776
integer taborder = 110
boolean bringtotop = true
string title = "none"
string dataobject = "d_han_01011_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;string sIojpno, sShpjpno , ls_lotsno , ls_itnbr
Long	 ll_row

w_mdi_frame.sle_msg.text =""	

if row > 0 then
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)	

	sShpjpno = getitemstring(row, "shpact_shpjpno")
	ll_row = dw_3.retrieve(sShpjpno)
	
	if ll_row > 0 then
		
		ls_lotsno = dw_3.object.lotsno[1]
		ls_itnbr = dw_3.object.itnbr[1]
		dw_insert.retrieve(ls_lotsno, ls_itnbr)
	end if

end if
end event

type pb_1 from u_pb_cal within w_han_01011_backup
integer x = 1440
integer y = 84
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

type pb_2 from u_pb_cal within w_han_01011_backup
integer x = 2130
integer y = 84
integer height = 76
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('d_ed')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'd_ed', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

If gs_code = dw_1.GetItemString(1, 'd_st') Then
	dw_1.SetItem(1, 'etim', '2400')
Else
	dw_1.SetItem(1, 'etim', f_get_syscnfg('Y', 89, 'ED'))
End If


end event

type st_2 from statictext within w_han_01011_backup
integer x = 46
integer y = 1132
integer width = 526
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "[원자재 소진내역]"
boolean focusrectangle = false
end type

type st_3 from statictext within w_han_01011_backup
integer x = 41
integer y = 1712
integer width = 526
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "[원자재 투입내역]"
boolean focusrectangle = false
end type

type rr_3 from roundrectangle within w_han_01011_backup
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3227
integer y = 76
integer width = 297
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_han_01011_backup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 1192
integer width = 4544
integer height = 492
integer cornerheight = 40
integer cornerwidth = 55
end type

