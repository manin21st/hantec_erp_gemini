$PBExportHeader$w_han_02010.srw
$PBExportComments$생산불량 현황
forward
global type w_han_02010 from w_standard_print
end type
type pb_1 from u_pb_cal within w_han_02010
end type
type pb_2 from u_pb_cal within w_han_02010
end type
type rr_1 from roundrectangle within w_han_02010
end type
end forward

global type w_han_02010 from w_standard_print
string title = "생산불량 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_han_02010 w_han_02010

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

String ls_roslt

ls_roslt = dw_ip.GetItemString(ll_row, 'roslt')
If Trim(ls_roslt) = '' OR IsNull(ls_roslt) Then ls_roslt = '%'

String ls_desc

ls_desc = dw_ip.GetItemString(ll_row, 'desc')
If Trim(ls_desc) = '' OR IsNull(ls_desc) Then 
	ls_desc = '%'
Else
	ls_desc = '%' + ls_desc + '%'
End If

String ls_sts

ls_sts = dw_ip.GetItemString(ll_row, 'sts')

// 생산팀(울산, 장안) 구분 추가 '22.03.15 by jhkim    *한텍 요청으로 원복   '22.04.14 by jhkim
//String ls_pdtgu

//ls_pdtgu = dw_ip.GetItemString(ll_row, 'pdtgu')
//If Trim(ls_pdtgu) = '' OR IsNull(ls_pdtgu) Then ls_pdtgu = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed, ls_itnbr, ls_itcls, ls_itnct, ls_jocod, ls_wkctr, ls_empnm, ls_ittyp, ls_roslt, ls_desc, ls_stim, ls_etim, ls_sts)
dw_list.SetRedraw(True)

dw_list.ShareData(dw_print)

Return 1
end function

on w_han_02010.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_han_02010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
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

type p_xls from w_standard_print`p_xls within w_han_02010
boolean visible = true
integer x = 4224
integer y = 168
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_02010
boolean visible = true
integer x = 4398
integer y = 168
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_02010
integer x = 4224
end type

type p_exit from w_standard_print`p_exit within w_han_02010
integer x = 4398
end type

type p_print from w_standard_print`p_print within w_han_02010
boolean visible = false
integer x = 4032
integer y = 196
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_02010
integer x = 4050
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







type st_10 from w_standard_print`st_10 within w_han_02010
end type



type dw_print from w_standard_print`dw_print within w_han_02010
integer x = 4411
integer y = 312
string dataobject = "d_han_02010_003"
end type

type dw_ip from w_standard_print`dw_ip within w_han_02010
integer x = 32
integer width = 4018
integer height = 348
string dataobject = "d_han_02010_001"
end type

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

type dw_list from w_standard_print`dw_list within w_han_02010
integer y = 392
integer width = 4558
integer height = 1828
string dataobject = "d_han_02010_002"
boolean border = false
end type

type pb_1 from u_pb_cal within w_han_02010
integer x = 1440
integer y = 60
integer height = 76
integer taborder = 110
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

type pb_2 from u_pb_cal within w_han_02010
integer x = 2071
integer y = 64
integer height = 76
integer taborder = 120
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

type rr_1 from roundrectangle within w_han_02010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 380
integer width = 4585
integer height = 1852
integer cornerheight = 40
integer cornerwidth = 55
end type

