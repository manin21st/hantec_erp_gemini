$PBExportHeader$w_sm99_00010.srw
$PBExportComments$업체별 집계현황
forward
global type w_sm99_00010 from w_standard_print
end type
type rr_1 from roundrectangle within w_sm99_00010
end type
end forward

global type w_sm99_00010 from w_standard_print
string title = "업체별 매출 집계현황"
rr_1 rr_1
end type
global w_sm99_00010 w_sm99_00010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_saupj

ls_saupj = dw_ip.GetItemString(row, 'saupj')
If Trim(ls_saupj) = '' OR IsNull(ls_saupj) Then ls_saupj = gs_saupj

String ls_st
String ls_ed

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
	ls_ed = '29001231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_ed')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_dept

ls_dept = dw_ip.GetItemSTring(row, 'dept')
If Trim(ls_dept) = '' OR IsNull(ls_dept) Then ls_dept = '%'

String ls_emp

ls_emp = dw_ip.GetItemString(row, 'empno')
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then ls_emp = '%'

String ls_cvcod

ls_cvcod = dw_ip.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_saupj, ls_st, ls_ed, ls_emp, ls_dept, ls_cvcod)
dw_list.SetRedraw(True)

Return 1
end function

event ue_open;call super::ue_open;f_mod_saupj(dw_ip, 'saupj')
dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
end event

on w_sm99_00010.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sm99_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_sm99_00010
boolean visible = true
integer x = 4251
integer y = 24
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_sm99_00010
integer x = 3465
integer y = 116
end type

type p_preview from w_standard_print`p_preview within w_sm99_00010
boolean visible = false
integer x = 3639
integer y = 124
end type

type p_exit from w_standard_print`p_exit within w_sm99_00010
integer x = 4425
end type

type p_print from w_standard_print`p_print within w_sm99_00010
boolean visible = false
integer x = 3813
integer y = 124
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm99_00010
integer x = 4078
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







type st_10 from w_standard_print`st_10 within w_sm99_00010
end type



type dw_print from w_standard_print`dw_print within w_sm99_00010
string dataobject = "d_sm99_00010_002"
end type

type dw_ip from w_standard_print`dw_ip within w_sm99_00010
integer x = 37
integer width = 3712
integer height = 256
string dataobject = "d_sm99_00010_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'gub'
		If data = '1' Then
			//출하
			dw_list.DataObject = 'd_sm99_00010_002'
			dw_print.DataObject = 'd_sm99_00010_002'
		ElseIf data = '2' Then
			//매출(출하)
			dw_list.DataObject = 'd_sm99_00010_003'
			dw_print.DataObject = 'd_sm99_00010_003'
		ElseIf data = '4' Then
			//매출(검수)
			dw_list.DataObject = 'd_sm99_00010_005'
			dw_print.DataObject = 'd_sm99_00010_005'
		ElseIf data = '3' Then
			//매출(출하+기타+사급)
			dw_list.DataObject = 'd_sm99_00010_004'
			dw_print.DataObject = 'd_sm99_00010_004'
		End If
		
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sm99_00010
integer x = 55
integer y = 300
integer width = 4535
integer height = 1924
string dataobject = "d_sm99_00010_002"
boolean border = false
end type

type rr_1 from roundrectangle within w_sm99_00010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 284
integer width = 4567
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

