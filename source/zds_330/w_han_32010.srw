$PBExportHeader$w_han_32010.srw
$PBExportComments$자재 계획 대 실적
forward
global type w_han_32010 from w_standard_print
end type
type pb_1 from u_pb_cal within w_han_32010
end type
type rr_1 from roundrectangle within w_han_32010
end type
end forward

global type w_han_32010 from w_standard_print
string title = "자재계획 대비 실적현황"
pb_1 pb_1
rr_1 rr_1
end type
global w_han_32010 w_han_32010

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_day (string as_st)
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_st

ls_st = dw_ip.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	MessageBox('기준일 확인', '기준일은 필수 입력 항목입니다.')
	dw_ip.SetColumn('d_st')
	dw_ip.SetFocus()
	Return -1
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_st')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_ittyp

ls_ittyp = dw_ip.GetItemString(row, 'ittyp')
If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then ls_ittyp = '%'

String ls_itnbr

ls_itnbr = dw_ip.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

String ls_cvcod

ls_cvcod = dw_ip.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'

String ls_gubun

ls_gubun = dw_ip.GetItemString(row, 'gbn')
If Trim(ls_gubun) = '' OR IsNull(ls_gubun) Then ls_gubun = '%'

String  ls_saupj
ls_saupj = dw_ip.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ittyp, ls_itnbr, ls_cvcod, ls_gubun, ls_saupj)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

wf_day(ls_st)

Return 1
end function

public subroutine wf_day (string as_st);Date ld_st

ld_st = Date(LEFT(as_st, 4) + '/' + MID(as_st, 5, 2) + '/' + RIGHT(as_st, 2))

dw_list.Object.d01.Text = String(ld_st, 'mm/dd')
dw_list.Object.d02.Text = String(RelativeDate(ld_st, 1), 'mm/dd')
dw_list.Object.d03.Text = String(RelativeDate(ld_st, 2), 'mm/dd')
dw_list.Object.d04.Text = String(RelativeDate(ld_st, 3), 'mm/dd')
dw_list.Object.d05.Text = String(RelativeDate(ld_st, 4), 'mm/dd')
dw_list.Object.d06.Text = String(RelativeDate(ld_st, 5), 'mm/dd')
dw_list.Object.d07.Text = String(RelativeDate(ld_st, 6), 'mm/dd')
end subroutine

on w_han_32010.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_han_32010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;String ls_max

SELECT MAX(YYMMDD)
  INTO :ls_max
  FROM PU03_WEEKPLAN ;

dw_ip.SetItem(1, 'd_st', ls_max)
end event

type p_xls from w_standard_print`p_xls within w_han_32010
boolean visible = true
integer x = 4242
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_32010
integer x = 4059
integer y = 180
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_32010
boolean visible = false
integer x = 4233
integer y = 180
end type

type p_exit from w_standard_print`p_exit within w_han_32010
integer x = 4416
end type

type p_print from w_standard_print`p_print within w_han_32010
boolean visible = false
integer x = 4407
integer y = 180
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_32010
integer x = 4069
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

//	p_preview.enabled = False
//	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
//	p_preview.enabled = true
//	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
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







type st_10 from w_standard_print`st_10 within w_han_32010
end type



type dw_print from w_standard_print`dw_print within w_han_32010
integer x = 3931
integer y = 32
string dataobject = "d_han_32010_002-1"
end type

type dw_ip from w_standard_print`dw_ip within w_han_32010
integer x = 37
integer width = 3831
integer height = 244
string dataobject = "d_han_32010_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Long   ll_data

Choose Case dwo.name
	Case 'cvcod'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvnas', '')
			Return
		End If
		
		This.SetItem(row, 'cvnas', f_get_name5('11', data, ''))
		
	Case 'itnbr'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		SELECT COUNT('X')
		  INTO :ll_data
		  FROM ITEMAS
		 WHERE ITNBR = :data ;
		If ll_data < 1 OR IsNull(ll_data) Then
			MessageBox('품번 확인', '해당 품번은 등록되지 않은 품번입니다.')
			Return
		End If
		
	Case 'd_st'
		If DayNumber(Date(LEFT(data, 4) + '.' + MID(data, 5, 2) + '.' + RIGHT(data, 2))) <> 2 Then
			MessageBox('확 인','주간 계획은 월요일부터 확인 가능합니다.!!')
			dw_ip.SetItem(row, 'd_st', '')
			Return
		End If
End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'cvcod'		
		gs_gubun = '1'
		
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'cvcod', gs_code    )
		This.SetItem(row, 'cvnas', gs_codename)		
End Choose
end event

type dw_list from w_standard_print`dw_list within w_han_32010
integer x = 46
integer y = 296
integer width = 4530
integer height = 1932
string dataobject = "d_han_32010_002-1"
boolean border = false
end type

type pb_1 from u_pb_cal within w_han_32010
integer x = 617
integer y = 44
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

If DayNumber(Date(LEFT(gs_code,4) + '-' + MID(gs_code, 5, 2) + '-' + RIGHT(gs_code, 2))) <> 2 Then
	MessageBox('확 인','주간 계획은 월요일부터 확인 가능합니다.!!')
	dw_ip.SetItem(1, 'd_st', '')
	Return
End If
end event

type rr_1 from roundrectangle within w_han_32010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 288
integer width = 4553
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

