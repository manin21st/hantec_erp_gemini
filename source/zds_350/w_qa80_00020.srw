$PBExportHeader$w_qa80_00020.srw
$PBExportComments$ǰ�� �̷� ��Ȳ
forward
global type w_qa80_00020 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qa80_00020
end type
type pb_2 from u_pb_cal within w_qa80_00020
end type
type rr_1 from roundrectangle within w_qa80_00020
end type
end forward

global type w_qa80_00020 from w_standard_print
string title = "ǰ�� �̷� ��Ȳ"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qa80_00020 w_qa80_00020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_st
String ls_ed

ls_st = dw_ip.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('�������� Ȯ��', '���������� �߸� �Ǿ����ϴ�.')
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
		MessageBox('�������� Ȯ��', '���������� �߸� �Ǿ����ϴ�.')
		dw_ip.SetColumn('d_ed')
		dw_ip.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('�ⰣȮ��', '������ ���� �������� �����ϴ�.')
	dw_ip.SetColumn('d_ed')
	dw_ip.SetFocus()
	Return -1
End If

String ls_itst
String ls_ited

ls_itst = dw_ip.GetItemString(row, 'it_st')
If Trim(ls_itst) = '' OR IsNull(ls_itst) Then ls_itst = '.'

ls_ited = dw_ip.GetItemString(row, 'it_ed')
If Trim(ls_ited) = '' OR IsNull(ls_ited) Then ls_ited = 'ZZZZZZZZZZZZZZZZZZZZ'

String ls_gbn

ls_gbn = dw_ip.GetItemString(row, 'gubun')
If Trim(ls_gbn) = '' OR IsNull(ls_gbn) Then ls_gbn = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed, ls_itst, ls_ited, ls_gbn)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1
	
end function

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
end event

on w_qa80_00020.create
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

on w_qa80_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_qa80_00020
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\������ȯ_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_qa80_00020
integer x = 4256
integer y = 180
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_qa80_00020
end type

type p_exit from w_standard_print`p_exit within w_qa80_00020
end type

type p_print from w_standard_print`p_print within w_qa80_00020
boolean visible = false
integer x = 4434
integer y = 176
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa80_00020
end type

event p_retrieve::clicked;//

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//������� �����̰ų� ������ ��� �����//
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
	p_xls.PictureName = 'C:\erpman\image\������ȯ_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\�̸�����_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\������ȯ_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\�̸�����_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 fontä ���� - ��
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
		lstr_object.li_obj = i						//Window Object ����
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event







type st_10 from w_standard_print`st_10 within w_qa80_00020
end type



type dw_print from w_standard_print`dw_print within w_qa80_00020
string dataobject = "d_qa80_00020_003"
end type

type dw_ip from w_standard_print`dw_ip within w_qa80_00020
integer x = 37
integer width = 3141
integer height = 256
string dataobject = "d_qa80_00020_001"
end type

event dw_ip::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'it_st'
		Open(w_itemas_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'it_st'  , gs_code)
		This.SetItem(row, 'itnm_st', gs_codename)
		This.SetItem(row, 'it_ed'  , gs_code)
		This.SetItem(row, 'itnm_ed', gs_codename)
		
	Case 'it_ed'
		Open(w_itemas_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'it_ed'  , gs_code)
		This.SetItem(row, 'itnm_ed', gs_codename)
		
End Choose
end event

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return 
		
String ls_itdsc

Choose Case dwo.name
	Case 'it_st'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'itnm_st', data)
			This.SetItem(row, 'it_ed'  , data)
			This.SetItem(row, 'itnm_ed', data)
			Return
		End If
		
		This.SetItem(row, 'itnm_st', f_get_name5('13', data, ''))
		This.SetItem(row, 'it_ed'  , data)
		This.SetItem(row, 'itnm_ed', f_get_name5('13', data, ''))
		
	Case 'it_ed'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'itnm_ed', '')
			Return
		End If
		
		This.SetItem(row, 'itnm_ed', f_get_name5('13', data, ''))
		
End Choose
end event

type dw_list from w_standard_print`dw_list within w_qa80_00020
integer x = 50
integer y = 292
integer width = 4544
integer height = 1920
string dataobject = "d_qa80_00020_002"
boolean border = false
end type

type pb_1 from u_pb_cal within w_qa80_00020
integer x = 677
integer y = 44
integer height = 76
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('d_st')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'd_st', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

end event

type pb_2 from u_pb_cal within w_qa80_00020
integer x = 1184
integer y = 44
integer height = 76
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('d_ed')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'd_ed', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

end event

type rr_1 from roundrectangle within w_qa80_00020
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 280
integer width = 4571
integer height = 1944
integer cornerheight = 40
integer cornerwidth = 55
end type

