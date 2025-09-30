$PBExportHeader$w_pm05_00080_han_bak.srw
$PBExportComments$주간 생산계획 대비 실적현황- BAK
forward
global type w_pm05_00080_han_bak from w_standard_print
end type
type pb_1 from u_pb_cal within w_pm05_00080_han_bak
end type
type pb_2 from u_pb_cal within w_pm05_00080_han_bak
end type
type cbx_1 from checkbox within w_pm05_00080_han_bak
end type
type rr_1 from roundrectangle within w_pm05_00080_han_bak
end type
end forward

global type w_pm05_00080_han_bak from w_standard_print
string title = "주간 계획 대비 실적 달성률"
pb_1 pb_1
pb_2 pb_2
cbx_1 cbx_1
rr_1 rr_1
end type
global w_pm05_00080_han_bak w_pm05_00080_han_bak

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

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed, ls_itnbr, ls_itcls, ls_itnct, ls_jocod, ls_wkctr, ls_empnm, ls_ittyp)
dw_list.SetRedraw(True)

dw_list.ShareData(dw_print)

Return 1
end function

on w_pm05_00080_han_bak.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.cbx_1=create cbx_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_pm05_00080_han_bak.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.cbx_1)
destroy(this.rr_1)
end on

event open;call super::open;String sDate, stoday

stoday = f_today()

select min(week_sdate) INTO :sDate from pdtweek where week_sdate <= :stoday and week_ldate >= :stoday;

dw_ip.SetItem(1, 'd_st', sDate)
dw_ip.SetItem(1, 'd_ed', f_afterday(sDate,6))
end event

type p_xls from w_standard_print`p_xls within w_pm05_00080_han_bak
boolean visible = true
integer x = 4247
integer y = 24
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_pm05_00080_han_bak
boolean visible = true
integer x = 3662
integer y = 24
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_pm05_00080_han_bak
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_pm05_00080_han_bak
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_pm05_00080_han_bak
boolean visible = false
integer x = 4073
integer y = 164
end type

type p_retrieve from w_standard_print`p_retrieve within w_pm05_00080_han_bak
integer x = 3899
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







type st_10 from w_standard_print`st_10 within w_pm05_00080_han_bak
end type



type dw_print from w_standard_print`dw_print within w_pm05_00080_han_bak
integer x = 3424
integer y = 32
string dataobject = "d_pm05_00080_han1_p_bak"
end type

type dw_ip from w_standard_print`dw_ip within w_pm05_00080_han_bak
integer x = 27
integer width = 2816
integer height = 272
string dataobject = "d_pm05_00080_han0_bak"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'd_st'
		If f_datechk(data) = -1 Then
			This.SetItem(row, 'd_ed', '')
			Return 1
		End If
		
		This.SetItem(row, 'd_ed', f_afterday(data, 6))

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

type dw_list from w_standard_print`dw_list within w_pm05_00080_han_bak
integer y = 312
integer width = 4558
integer height = 1928
string dataobject = "d_pm05_00080_han1_bak"
boolean border = false
end type

type pb_1 from u_pb_cal within w_pm05_00080_han_bak
integer x = 731
integer y = 60
integer height = 76
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
If f_datechk(gs_code) = -1 Then Return

dw_ip.SetItem(1, 'd_st', gs_code)
dw_ip.SetItem(1, 'd_ed', f_afterday(gs_code, 6))


end event

type pb_2 from u_pb_cal within w_pm05_00080_han_bak
boolean visible = false
integer x = 2944
integer y = 32
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

end event

type cbx_1 from checkbox within w_pm05_00080_han_bak
integer x = 2235
integer y = 64
integer width = 411
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "미 달성 계획"
end type

event clicked;If This.Checked = True Then
	dw_list.DataObject = 'd_pm05_00080_han1_1_bak'
	dw_print.DataObject = 'd_pm05_00080_han1_1_p_bak'
Else
	dw_list.DataObject = 'd_pm05_00080_han1_bak'
	dw_print.DataObject = 'd_pm05_00080_han1_p_bak'
End If

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rr_1 from roundrectangle within w_pm05_00080_han_bak
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 300
integer width = 4585
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 55
end type

