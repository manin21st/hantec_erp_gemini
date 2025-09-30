$PBExportHeader$w_qa06_00040.srw
$PBExportComments$**품질지수 현황_한텍(17.08.24)
forward
global type w_qa06_00040 from w_standard_print
end type
type dw_1 from datawindow within w_qa06_00040
end type
type cb_1 from commandbutton within w_qa06_00040
end type
type rr_1 from roundrectangle within w_qa06_00040
end type
end forward

global type w_qa06_00040 from w_standard_print
integer width = 4654
string title = "품질 지수 현황"
dw_1 dw_1
cb_1 cb_1
rr_1 rr_1
end type
global w_qa06_00040 w_qa06_00040

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row
String ls_gub, ls_year, ls_itnbr, ls_cvcod

row = dw_ip.GetRow()
If row < 1 Then Return -1

ls_year = dw_ip.GetItemString(row, 'd_year')
If Trim(ls_year) = '' OR IsNull(ls_year) Then
	MessageBox('기준년도 확인', '기준년도는 필수 항목입니다.')
	dw_ip.SetColumn('d_year')
	dw_ip.SetFocus()
	Return -1
End If

ls_gub = dw_ip.GetItemString(row, 'gubun')

ls_itnbr = dw_ip.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

ls_cvcod = dw_ip.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'


dw_list.Object.gr_1.Title  = ls_year + '년 ' + ls_gub

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_year+'%',ls_itnbr,ls_cvcod)
dw_list.SetRedraw(True)

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_year+'%',ls_itnbr,ls_cvcod)
//dw_1.SetRedraw(True)



//-------------------------------------------------------------------------------------------------------------------------------
// 1. 실적(PPM), 달성률 계산
// 2. 품번, 거래처 지정되는 경우 목표 삭제
//-------------------------------------------------------------------------------------------------------------------------------
Long			i, j, lrow
Decimal		dVal

dw_1.SetRedraw(False)

IF ls_gub = '고객불만' THEN
	
	IF ls_itnbr = '%' AND ls_cvcod = '%' THEN	// 달성률 행추가
		dw_1.InsertRow(0)
		dw_1.SetItem(3, 'gubun', '달성률%')
		for j = 1 to 12
			dVal = dw_1.GetItemNumber(1, 'val_'+String(j,'00'))
			if dVal > 0 then
				dw_1.SetItem(3, 'val_'+String(j,'00'), dw_1.GetItemNumber(2, 'val_'+String(j,'00')) / dVal * 100)
			end if
		next
	ELSE
		dw_1.DeleteRow(1)							// 목표 행삭제
	END IF
	
ELSEIF ls_gub = '출하검사' OR ls_gub = '수입검사' OR ls_gub = '공정검사' THEN

	// 실적PPM 행추가
	dw_1.InsertRow(2)
	dw_1.SetItem(2, 'gubun', '실적PPM')
	for j = 1 to 12
		dVal = dw_1.GetItemNumber(3, 'val_'+String(j,'00'))
		if dVal > 0 then
			dw_1.SetItem(2, 'val_'+String(j,'00'), dw_1.GetItemNumber(4, 'val_'+String(j,'00')) / dVal * 1000000)
		end if
	next
	
	IF ls_itnbr = '%' AND ls_cvcod = '%' THEN
		// 달성률 행추가
		dw_1.InsertRow(3)
		dw_1.SetItem(3, 'gubun', '달성률%')
		for j = 1 to 12
			dVal = dw_1.GetItemNumber(1, 'val_'+String(j,'00'))
			if dVal > 0 then
				dw_1.SetItem(3, 'val_'+String(j,'00'), dw_1.GetItemNumber(2, 'val_'+String(j,'00')) / dVal * 100)
			end if
		next
	ELSE
		dw_1.DeleteRow(1)							// 목표 행삭제
	END IF


ELSEIF ls_gub = '협력사품질' THEN

	// 실적PPM 행추가
	dw_1.InsertRow(1)
	dw_1.SetItem(1, 'gubun', '실적PPM')
	for j = 1 to 12
		dVal = dw_1.GetItemNumber(2, 'val_'+String(j,'00'))
		if dVal > 0 then
			dw_1.SetItem(1, 'val_'+String(j,'00'), dw_1.GetItemNumber(3, 'val_'+String(j,'00')) / dVal * 1000000)
		end if
	next

END IF

dw_1.SetRedraw(True)
//-------------------------------------------------------------------------------------------------------------------------------


Return 1


end function

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'd_year', String(TODAY(), 'yyyy'))
end event

on w_qa06_00040.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_qa06_00040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_qa06_00040
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

event p_xls::clicked;//

If this.Enabled Then wf_excel_down(dw_1)
end event

type p_sort from w_standard_print`p_sort within w_qa06_00040
integer x = 5083
integer y = 196
end type

type p_preview from w_standard_print`p_preview within w_qa06_00040
boolean visible = false
integer x = 4736
integer y = 196
end type

type p_exit from w_standard_print`p_exit within w_qa06_00040
end type

type p_print from w_standard_print`p_print within w_qa06_00040
boolean visible = false
integer x = 4910
integer y = 196
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa06_00040
integer x = 4096
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







type st_10 from w_standard_print`st_10 within w_qa06_00040
end type



type dw_print from w_standard_print`dw_print within w_qa06_00040
integer x = 4777
integer y = 44
string dataobject = "d_qa06_00040_2"
end type

type dw_ip from w_standard_print`dw_ip within w_qa06_00040
integer x = 32
integer width = 3502
integer height = 188
string dataobject = "d_qa06_00040_1"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'gubun'		

		If data = '고객불만' Then
			dw_1.DataObject = 'd_qa06_00040_31'
			dw_list.DataObject = 'd_qa06_00040_21'
		ElseIf data = '출하검사' Then
			dw_1.DataObject = 'd_qa06_00040_32'
			dw_list.DataObject = 'd_qa06_00040_22'
		ElseIf data = '수입검사' Then
			dw_1.DataObject = 'd_qa06_00040_33'
			dw_list.DataObject = 'd_qa06_00040_23'
		ElseIf data = '공정검사' Then
			dw_1.DataObject = 'd_qa06_00040_34'
			dw_list.DataObject = 'd_qa06_00040_24'
		ElseIf data = '협력사품질' Then
			dw_1.DataObject = 'd_qa06_00040_35'
			dw_list.DataObject = 'd_qa06_00040_25'
		End If	
		dw_1.SetTransObject(SQLCA)
		dw_list.SetTransObject(SQLCA)
		
End Choose
			
			

			
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

// 품번
IF this.GetColumnName() = 'itnbr' THEN
	Open(w_itemas_popup)	
	If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
	This.SetItem(row, 'itnbr', gs_code)
END IF

// 귀책처
IF this.GetColumnName() = 'cvcod' THEN
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(1,'cvcod',gs_code)
	this.SetItem(1,'cvnas',gs_codename)
END IF
end event

type dw_list from w_standard_print`dw_list within w_qa06_00040
integer x = 55
integer y = 224
integer width = 4530
integer height = 1456
string dataobject = "d_qa06_00040_21"
end type

type dw_1 from datawindow within w_qa06_00040
integer x = 55
integer y = 1688
integer width = 4530
integer height = 540
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa06_00040_31"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cb_1 from commandbutton within w_qa06_00040
integer x = 3557
integer y = 32
integer width = 494
integer height = 140
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
string text = "품질 목표 등록"
end type

event clicked;dw_ip.AcceptText()

String ls_year

ls_year = dw_ip.GetItemString(1, 'd_year')
If Trim(ls_year) = '' OR IsNull(ls_year) Then
	MessageBox('기준년도 확인', '기준년도는 필수 항목입니다.')
	dw_ip.SetColumn('d_year')
	dw_ip.SetFocus()
	Return
End If

gs_gubun = ls_year
Open(w_qa06_00040_popup)

p_retrieve.TriggerEvent(Clicked!)
end event

type rr_1 from roundrectangle within w_qa06_00040
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 212
integer width = 4567
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

