$PBExportHeader$w_pm05_00080_han.srw
$PBExportComments$주간 생산계획 대비 실적현황
forward
global type w_pm05_00080_han from w_standard_print
end type
type pb_1 from u_pb_cal within w_pm05_00080_han
end type
type pb_2 from u_pb_cal within w_pm05_00080_han
end type
type dw_1 from datawindow within w_pm05_00080_han
end type
type cbx_1 from checkbox within w_pm05_00080_han
end type
type rr_1 from roundrectangle within w_pm05_00080_han
end type
end forward

global type w_pm05_00080_han from w_standard_print
integer width = 4677
integer height = 2752
string title = "주간 계획 대비 실적 달성률"
pb_1 pb_1
pb_2 pb_2
dw_1 dw_1
cbx_1 cbx_1
rr_1 rr_1
end type
global w_pm05_00080_han w_pm05_00080_han

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

ls_stim = dw_ip.GetItemString(ll_row, 'stime')
If Trim(ls_stim) = '' OR IsNull(ls_stim) Then ls_stim = '0800'

String ls_etim

ls_etim = dw_ip.GetItemString(ll_row, 'etime')
If Trim(ls_etim) = '' OR IsNull(ls_etim) Then ls_etim = '0630'


String ls_itnbr

ls_itnbr = dw_ip.GetItemString(ll_row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

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

String ls_mchno

ls_mchno = dw_ip.GetItemString(ll_row, 'mchno')
If Trim(ls_mchno) = '' OR IsNull(ls_mchno) Then
	ls_mchno = '%'
Else
	ls_mchno = '%' + ls_mchno + '%'
End If



dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st,ls_ed, ls_itnbr, ls_jocod, ls_wkctr,ls_mchno,ls_stim,ls_etim)
dw_list.SetRedraw(True)

dw_list.ShareData(dw_print)

Return 1
end function

on w_pm05_00080_han.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_1=create dw_1
this.cbx_1=create cbx_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_pm05_00080_han.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_1)
destroy(this.cbx_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)

String sDate, stoday

stoday = f_today()

select min(week_sdate) INTO :sDate from pdtweek where week_sdate <= :stoday and week_ldate >= :stoday;

dw_ip.SetItem(1, 'd_st', sDate)
dw_ip.SetItem(1, 'd_ed', f_afterday(sDate,7))
end event

type p_xls from w_standard_print`p_xls within w_pm05_00080_han
boolean visible = true
integer x = 4247
integer y = 24
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_pm05_00080_han
boolean visible = true
integer x = 3698
integer y = 24
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_pm05_00080_han
integer x = 4073
end type

type p_exit from w_standard_print`p_exit within w_pm05_00080_han
integer x = 4421
end type

type p_print from w_standard_print`p_print within w_pm05_00080_han
boolean visible = false
integer x = 4073
integer y = 164
end type

type p_retrieve from w_standard_print`p_retrieve within w_pm05_00080_han
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







type st_10 from w_standard_print`st_10 within w_pm05_00080_han
end type



type dw_print from w_standard_print`dw_print within w_pm05_00080_han
integer x = 3424
integer y = 32
string dataobject = "d_pm05_00080_han1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pm05_00080_han
integer x = 0
integer y = 0
integer width = 3584
integer height = 288
string dataobject = "d_pm05_00080_han0"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'd_st'
		If f_datechk(data) = -1 Then
			This.SetItem(row, 'd_ed', '')
			Return 1
		End If
		
		This.SetItem(row, 'd_ed', f_afterday(data, 7))

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
		
	Case 'mchno'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'mchnm', '')
			Return 
		End If
		
		String ls_mchnam
		
		SELECT MCHNAM
		  INTO :ls_mchnam
		  FROM MCHMST
		 WHERE MCHNO = :data ;
		If SQLCA.SQLCODE <> 0 Then
			This.SetItem(row, 'mchnm', '')
			Return 2
		End If
		
		This.SetItem(row, 'mchnm', ls_mchnam)
		
	Case 'gbn'
		String ls_pstgbn
		ls_pstgbn = this.gettext()
		if ls_pstgbn = '1' then
			dw_list.DataObject = 'd_pm05_00080_han1'
			dw_print.DataObject = 'd_pm05_00080_han1_p'	
		Else
			dw_list.DataObject = 'd_pm05_00080_han1_1'
			dw_print.DataObject = 'd_pm05_00080_han1_1_p'
		End If
		
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)
		
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

	Case 'mchno'
		gs_gubun = 'ALL'
		
		Open(w_mchno_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'mchno' , gs_code    )
		This.SetItem(row, 'mchnm', gs_codename)
		Return

End Choose
end event

type dw_list from w_standard_print`dw_list within w_pm05_00080_han
integer y = 312
integer width = 4558
integer height = 1928
string dataobject = "d_pm05_00080_han1"
boolean border = false
end type

event dw_list::doubleclicked;If row < 1 Then Return

Choose Case dwo.name
	Case 'ntime'
		String ls_itnbr, ls_wkctr, ls_st, ls_et
		
		ls_itnbr = This.GetItemString(row, 'itnbr')
   	ls_wkctr = This.GetItemString(row, 'wkctr')
		ls_st = dw_ip.GetItemString(1, 'd_st')
		ls_et = dw_ip.GetItemString(1, 'd_ed')
		
		dw_1.SetRedraw(False)
		dw_1.Retrieve(gs_sabu, ls_itnbr,ls_wkctr,ls_st,ls_et)
		dw_1.SetRedraw(True)
		
		If dw_1.RowCount() < 1 Then
			MessageBox('비 가동 내역', '해당 실적은 비 가동 내역이 없습니다.')
			Return
		End If
		
		dw_1.Visible = True
End Choose
end event

type pb_1 from u_pb_cal within w_pm05_00080_han
integer x = 695
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

type pb_2 from u_pb_cal within w_pm05_00080_han
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

type dw_1 from datawindow within w_pm05_00080_han
boolean visible = false
integer x = 1024
integer y = 800
integer width = 2853
integer height = 800
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "비가동상세내역"
string dataobject = "d_pm05_00080_han1_ntime"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type cbx_1 from checkbox within w_pm05_00080_han
boolean visible = false
integer x = 2816
integer y = 160
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "생산BOM"
end type

event clicked;If This.Checked = True Then
	dw_list.DataObject = 'd_pm05_00080_han1_1'
	dw_print.DataObject = 'd_pm05_00080_han1_1_p'
Else
	dw_list.DataObject = 'd_pm05_00080_han1'
	dw_print.DataObject = 'd_pm05_00080_han1_p'
End If

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA) 
end event

type rr_1 from roundrectangle within w_pm05_00080_han
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

