$PBExportHeader$w_han_10010.srw
$PBExportComments$원자재 입/출고 현황 (절단코일)
forward
global type w_han_10010 from w_standard_print
end type
type pb_1 from u_pb_cal within w_han_10010
end type
type pb_2 from u_pb_cal within w_han_10010
end type
type pb_3 from u_pb_cal within w_han_10010
end type
type pb_4 from u_pb_cal within w_han_10010
end type
type rr_1 from roundrectangle within w_han_10010
end type
end forward

global type w_han_10010 from w_standard_print
string title = "원자재 입/출고 현황 (절단코일)"
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
rr_1 rr_1
end type
global w_han_10010 w_han_10010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.accepttext( )

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_inst

ls_inst = dw_ip.GetItemString(row, 'in_sdat')
If Trim(ls_inst) = '' OR IsNull(ls_inst) Then ls_inst = '19000101'

String ls_ined

ls_ined = dw_ip.GetItemString(row, 'in_edat')
If Trim(ls_ined) = '' OR IsNull(ls_ined) Then ls_ined = '29991231'

String ls_otst

ls_otst = dw_ip.GetItemString(row, 'ot_sdat')
If Trim(ls_otst) = '' OR IsNull(ls_otst) Then ls_otst = '19000101'

String ls_oted

ls_oted = dw_ip.GetItemString(row, 'ot_edat')
If Trim(ls_oted) = '' OR IsNull(ls_oted) Then ls_oted = '29991231'

String ls_cvcod

ls_cvcod = dw_ip.GetItemString(row, 'ot_cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'

String ls_sts

ls_sts = dw_ip.GetItemString(row, 'status')
If Trim(ls_sts) = '' OR IsNull(ls_sts) Then ls_sts = '%'

String ls_itnbr

ls_itnbr = dw_ip.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

String ls_lotsno

ls_lotsno = dw_ip.GetItemString(row, 'lotsno')
If Trim(ls_lotsno) = '' OR IsNull(ls_lotsno) Then ls_lotsno = '%'

String ls_saupj

ls_saupj = dw_ip.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_inst, ls_ined, ls_otst, ls_oted, ls_cvcod, ls_sts, ls_itnbr, ls_lotsno, ls_saupj)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then
	MessageBox('조회확인', '조회된 내용이 없습니다.')
	Return -1
End If

dw_list.ShareData(dw_print)

Return 1

end function

on w_han_10010.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_3
this.Control[iCurrent+4]=this.pb_4
this.Control[iCurrent+5]=this.rr_1
end on

on w_han_10010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'in_sdat', String(TODAY(), 'yyyymm') + '01')
dw_ip.SetItem(1, 'in_edat', String(TODAY(), 'yyyymmdd'))
end event

type p_xls from w_standard_print`p_xls within w_han_10010
boolean visible = true
integer x = 4050
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_10010
boolean visible = true
integer x = 4224
integer y = 24
boolean enabled = false
boolean originalsize = false
string picturename = "C:\erpman\image\정렬_d.gif"
end type

type p_preview from w_standard_print`p_preview within w_han_10010
integer x = 3877
end type

type p_exit from w_standard_print`p_exit within w_han_10010
integer x = 4398
end type

type p_print from w_standard_print`p_print within w_han_10010
boolean visible = false
integer x = 4261
integer y = 184
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_10010
integer x = 3703
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
	p_xls.Enabled = False
	p_sort.Enabled = False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'
	p_sort.PictureName = 'C:\erpman\image\정렬_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled = true
	p_sort.Enabled = true
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
	p_sort.PictureName = 'C:\erpman\image\정렬_up.gif'
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







type st_10 from w_standard_print`st_10 within w_han_10010
end type



type dw_print from w_standard_print`dw_print within w_han_10010
integer x = 4443
integer y = 188
string dataobject = "d_han_10010_003"
end type

type dw_ip from w_standard_print`dw_ip within w_han_10010
integer x = 37
integer y = 32
integer width = 3657
integer height = 240
string dataobject = "d_han_10010_001"
end type

event dw_ip::rbuttondown;call super::rbuttondown;If row < 1 Then Return

Choose Case dwo.name
	Case 'ot_cvcod'
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'ot_cvcod', gs_code    )
		This.SetItem(row, 'ot_cvnas', gs_codename)
		
End Choose
end event

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'ot_cvcod'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'ot_cvnas', data)
			Return
		End If
		
		String ls_nam
		
		SELECT CVNAS
		  INTO :ls_nam
		  FROM VNDMST
		 WHERE CVCOD = :data ;
		If Trim(ls_nam) = '' OR IsNull(ls_nam) Then
			MessageBox('거래처 확인', '등록된 거래처가 아닙니다.')
			This.SetColumn('ot_cvcod')
			This.SetFocus()
			Return
		End If
		
		This.SetItem(row, 'ot_cvnas', ls_nam)
		
	Case 'itnbr'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'itdsc', data)
			Return
		End If
		
		String ls_itdsc
		
		SELECT ITDSC
		  INTO :ls_itdsc
		  FROM ITEMAS
		 WHERE ITNBR = :data ;
		If Trim(ls_itdsc) = '' OR IsNull(ls_itdsc) Then
			MessageBox('품번확인', '등록된 품번이 아닙니다.')
			This.SetColumn('itnbr')
			This.SetFocus()
			Return
		End If
		
		This.SetItem(row, 'itdsc', ls_itdsc)
		
End Choose
end event

type dw_list from w_standard_print`dw_list within w_han_10010
integer x = 50
integer y = 300
integer width = 4530
integer height = 1932
string dataobject = "d_han_10010_002"
boolean border = false
end type

type pb_1 from u_pb_cal within w_han_10010
integer x = 553
integer y = 64
integer height = 76
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('in_sdat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'in_sdat', gs_code)

end event

type pb_2 from u_pb_cal within w_han_10010
integer x = 997
integer y = 64
integer height = 76
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('in_edat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'in_edat', gs_code)

end event

type pb_3 from u_pb_cal within w_han_10010
integer x = 553
integer y = 168
integer height = 76
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('ot_sdat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'ot_sdat', gs_code)

end event

type pb_4 from u_pb_cal within w_han_10010
integer x = 997
integer y = 168
integer height = 76
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('ot_edat')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'ot_edat', gs_code)

end event

type rr_1 from roundrectangle within w_han_10010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 288
integer width = 4558
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

