$PBExportHeader$w_han_01010.srw
$PBExportComments$생산실적 현황
forward
global type w_han_01010 from w_standard_print
end type
type pb_1 from u_pb_cal within w_han_01010
end type
type pb_2 from u_pb_cal within w_han_01010
end type
type cb_1 from commandbutton within w_han_01010
end type
type cbx_1 from checkbox within w_han_01010
end type
type rr_1 from roundrectangle within w_han_01010
end type
end forward

global type w_han_01010 from w_standard_print
integer width = 4768
integer height = 4312
string title = "생산실적 현황"
pb_1 pb_1
pb_2 pb_2
cb_1 cb_1
cbx_1 cbx_1
rr_1 rr_1
end type
global w_han_01010 w_han_01010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   ll_row

ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return -1

String ls_st
String ls_ed

ls_st = dw_ip.GetItemString(ll_row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못되었습니다.')
		dw_ip.SetColumn('d_st')
		dw_ip.SetFocus()
		Return -1
	End If
End If

ls_ed = dw_ip.GetItemString(ll_row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자 형식이 잘못되었습니다.')
		dw_ip.SetColumn('d_ed')
		dw_ip.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간확인', '시작일 보다 종료일이 빠릅니다.')
	dw_ip.SetColumn('d_st')
	dw_ip.SetFocus()
	Return -1
End If

String ls_stim

ls_stim = dw_ip.GetItemString(ll_row, 'stim')
If Trim(ls_stim) = '' OR IsNull(ls_stim) Then ls_stim = '0800'

String ls_etim

ls_etim = dw_ip.GetItemString(ll_row, 'etim')
If Trim(ls_etim) = '' OR IsNull(ls_etim) Then ls_etim = '0630'

String ls_itnbr

ls_itnbr = dw_ip.GetItemString(ll_row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

String ls_itcls

ls_itcls = dw_ip.GetItemString(ll_row, 'itcls')
If Trim(ls_itcls) = '' OR IsNull(ls_itcls) Then ls_itcls = '%'

String ls_itnct

ls_itnct = dw_ip.GetItemString(ll_row, 'itnct')
If Trim(ls_itnct) = '' OR IsNull(ls_itnct) Then
	ls_itnct = '%'
Else
	ls_itnct = '%' + ls_itnct + '%'
End If

String ls_jocod

ls_jocod = dw_ip.GetItemString(ll_row, 'jocod')
If Trim(ls_jocod) = '' OR IsNull(ls_jocod) Then
	ls_jocod = '%'
Else
	ls_jocod = ls_jocod + '%'
End If

String ls_wkctr

ls_wkctr = dw_ip.GetItemString(ll_row, 'wkctr')
If Trim(ls_wkctr) = '' OR IsNull(ls_wkctr) Then ls_wkctr = '%'

String ls_empnm

ls_empnm = dw_ip.GetItemString(ll_row, 'empnm')
If Trim(ls_empnm) = '' OR IsNull(ls_empnm) Then
	ls_empnm = '%'
Else
	ls_empnm = '%' + ls_empnm + '%'
End If

String ls_ittyp

ls_ittyp = dw_ip.GetItemString(ll_row, 'ittyp')
If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then ls_ittyp = '%'

String ls_lotsno

ls_lotsno = dw_ip.GetItemString(ll_row, 'lotsno')
If Trim(ls_lotsno) = '' OR IsNull(ls_lotsno) Then 
	ls_lotsno = '%'
Else
	ls_lotsno='%'+ls_lotsno+'%'
End If


String ls_mchcod

ls_mchcod = dw_ip.GetItemString(ll_row, 'mchcod')
If Trim(ls_mchcod) = '' OR IsNull(ls_mchcod) Then ls_mchcod = '%'

// 생산팀(울산, 장안) 구분 추가 '22.03.15 by jhkim     //한텍요청으로 원복 '22.04.14 by jhkim
//String ls_pdtgu

//ls_pdtgu = dw_ip.GetItemString(ll_row, 'pdtgu')
//If Trim(ls_pdtgu) = '' OR IsNull(ls_pdtgu) Then ls_pdtgu = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed, ls_itnbr, ls_itcls, ls_itnct, ls_jocod, ls_wkctr, ls_empnm, ls_ittyp, ls_stim, ls_etim, ls_lotsno, ls_mchcod)
dw_list.SetRedraw(True)

// 정미가동률 체크 유무에 따라 출력물 작업자 다르게 나오도록 변경 '20.11.03 BY BHKIM
if cbx_1.checked = true then
	dw_print.SetRedraw(False)
	dw_print.Retrieve(ls_st, ls_ed, ls_itnbr, ls_itcls, ls_itnct, ls_jocod, ls_wkctr, ls_empnm, ls_ittyp, ls_stim, ls_etim, ls_lotsno, ls_mchcod)
	dw_print.SetRedraw(True)
else
	dw_list.ShareData(dw_print)
end if

Return 1
end function

on w_han_01010.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.cb_1=create cb_1
this.cbx_1=create cbx_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_han_01010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.cb_1)
destroy(this.cbx_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

String ls_st
ls_st = f_get_syscnfg('Y', 89, 'ST')
If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '0800'

String ls_ed
ls_ed = f_get_syscnfg('Y', 89, 'ED')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '0630'

dw_ip.SetItem(1, 'stim', ls_st)
dw_ip.SetItem(1, 'etim', ls_ed)
end event

type p_xls from w_standard_print`p_xls within w_han_01010
boolean visible = true
integer x = 4247
integer y = 164
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_01010
boolean visible = true
integer x = 4421
integer y = 164
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_01010
integer x = 4247
end type

type p_exit from w_standard_print`p_exit within w_han_01010
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_han_01010
boolean visible = false
integer x = 3890
integer y = 20
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_01010
integer x = 4073
end type

event p_retrieve::clicked;//

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
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







type st_10 from w_standard_print`st_10 within w_han_01010
end type



type dw_print from w_standard_print`dw_print within w_han_01010
integer x = 3749
string dataobject = "d_han_01010_003"
end type

type dw_ip from w_standard_print`dw_ip within w_han_01010
integer x = 37
integer y = 0
integer width = 3840
integer height = 384
string dataobject = "d_han_01010_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

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
	
	String ls_mchcod, ls_mchnam

	Case 'mchcod'
			ls_mchnam = This.GetItemString(row, 'mchnam')
			If Trim(data) = '' OR IsNull(data) Then
				This.SetItem(row, 'mchnam', '')
//				Return
			else
				This.SetItem(row, 'mchnam', ls_mchnam)	
			End If		


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

event dw_ip::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'itnbr'
		Open(w_itemas_popup3)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'itnbr', gs_code)
		This.SetItem(row, 'itdsc', gs_codename)
		
	Case 'mchcod'
		Open(w_mchno_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'mchcod', gs_code)
		This.SetItem(row, 'mchnam', gs_codename)	
		
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

type dw_list from w_standard_print`dw_list within w_han_01010
integer y = 408
integer width = 4558
integer height = 1812
string dataobject = "d_han_01010_002"
boolean border = false
end type

type pb_1 from u_pb_cal within w_han_01010
integer x = 1403
integer y = 44
integer height = 76
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_st', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

If gs_code = dw_ip.GetItemString(1, 'd_ed') Then
	dw_ip.SetItem(1, 'etim', '2400')
Else
	dw_ip.SetItem(1, 'etim', f_get_syscnfg('Y', 89, 'ED'))
End If
end event

type pb_2 from u_pb_cal within w_han_01010
integer x = 2034
integer y = 40
integer height = 76
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_ed')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_ed', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

If gs_code = dw_ip.GetItemString(1, 'd_st') Then
	dw_ip.SetItem(1, 'etim', '2400')
Else
	dw_ip.SetItem(1, 'etim', f_get_syscnfg('Y', 89, 'ED'))
End If


end event

type cb_1 from commandbutton within w_han_01010
integer x = 3909
integer y = 180
integer width = 334
integer height = 116
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "I/F 현황"
end type

event clicked;Open(w_han_01010_if)
end event

type cbx_1 from checkbox within w_han_01010
integer x = 3328
integer y = 256
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554431
long backcolor = 33554431
string text = "정미가동률포함"
end type

event clicked;If This.Checked = True Then
 dw_list.DataObject = 'd_han_01010_002_jungmi'
 dw_print.DataObject = 'd_han_01010_003_jungmi'
Else
 dw_list.DataObject = 'd_han_01010_002'
 dw_print.DataObject = 'd_han_01010_003'
End If

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
 

end event

type rr_1 from roundrectangle within w_han_01010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 396
integer width = 4585
integer height = 1860
integer cornerheight = 40
integer cornerwidth = 55
end type

