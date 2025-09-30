$PBExportHeader$w_qa02_00070_p.srw
$PBExportComments$사내 검사 현황
forward
global type w_qa02_00070_p from w_standard_print
end type
type pb_1 from u_pb_cal within w_qa02_00070_p
end type
type pb_2 from u_pb_cal within w_qa02_00070_p
end type
type rr_1 from roundrectangle within w_qa02_00070_p
end type
type rr_2 from roundrectangle within w_qa02_00070_p
end type
end forward

global type w_qa02_00070_p from w_standard_print
integer width = 4677
integer height = 2752
string title = "사내 검사 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_qa02_00070_p w_qa02_00070_p

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_saupj, ls_st, ls_ed, ls_itnbr

ls_st = dw_ip.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_st')
		dw_ip.SetFocus()
		Return -1
	End If
End If

ls_ed = dw_ip.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
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

ls_itnbr = dw_ip.GetItemString(1, 'itnbr')

If IsNull(ls_itnbr) Or ls_itnbr = '' Then
	ls_itnbr = '%'
End If

dw_list.SetRedraw(False)
//dw_list.Retrieve(ls_st, ls_ed, ls_jocod, ls_gubun, ls_gbn, ls_stim, ls_etim)
dw_list.Retrieve(gs_sabu, ls_st, ls_ed, ls_itnbr)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1
end function

on w_qa02_00070_p.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_qa02_00070_p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;dw_ip.settransobject(SQLCA)
dw_list.settransobject(SQLCA)
dw_print.settransobject(SQLCA)

//dw_ip.InsertRow(0)

dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
end event

type p_xls from w_standard_print`p_xls within w_qa02_00070_p
boolean visible = true
integer x = 4215
integer y = 28
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_qa02_00070_p
integer x = 4206
integer y = 180
end type

type p_preview from w_standard_print`p_preview within w_qa02_00070_p
integer x = 4041
integer y = 28
end type

type p_exit from w_standard_print`p_exit within w_qa02_00070_p
integer x = 4389
integer y = 28
end type

type p_print from w_standard_print`p_print within w_qa02_00070_p
boolean visible = false
integer x = 4389
integer y = 184
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa02_00070_p
integer x = 3867
integer y = 28
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







type st_10 from w_standard_print`st_10 within w_qa02_00070_p
end type



type dw_print from w_standard_print`dw_print within w_qa02_00070_p
integer x = 4069
integer y = 176
string dataobject = "d_qa02_00070_p_ap"
end type

type dw_ip from w_standard_print`dw_ip within w_qa02_00070_p
integer x = 64
integer y = 48
integer width = 3717
integer height = 176
string dataobject = "d_qa02_00070_p_1"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return
string snull, sdata , sname, scode
Long	 Lrow

Setnull(snull)

//this.accepttext()
Lrow = this.getrow()

Choose Case dwo.name
	Case 'itnbr'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'itdsc', '')
			Return
		End If
	
		This.SetItem(row, 'itdsc', f_get_name5('13', data, ''))

End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)


// 공급업체
IF this.GetColumnName() = 'cvcod' THEN
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(1,'cvcod',gs_code)
	this.TriggerEvent(itemchanged!)

END IF

IF this.GetColumnName() = 'itnbr' THEN

	Open(w_itemas_popup)
	
	If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
	This.SetItem(row, 'itnbr', gs_code)
	This.SetItem(row, 'itdsc', f_get_name5('13', gs_code, ''))

END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qa02_00070_p
integer x = 50
integer y = 300
integer width = 4535
integer height = 1944
string dataobject = "d_qa02_00070_p_a"
boolean border = false
end type

type pb_1 from u_pb_cal within w_qa02_00070_p
integer x = 672
integer y = 84
integer height = 76
integer taborder = 140
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_st', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

end event

type pb_2 from u_pb_cal within w_qa02_00070_p
integer x = 1157
integer y = 84
integer height = 76
integer taborder = 150
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_ed')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_ed', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

end event

type rr_1 from roundrectangle within w_qa02_00070_p
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 288
integer width = 4562
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qa02_00070_p
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 40
integer width = 3767
integer height = 188
integer cornerheight = 40
integer cornerwidth = 55
end type

