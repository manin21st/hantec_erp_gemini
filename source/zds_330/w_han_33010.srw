$PBExportHeader$w_han_33010.srw
$PBExportComments$������/�� ��Ȳ
forward
global type w_han_33010 from w_standard_print
end type
type rr_1 from roundrectangle within w_han_33010
end type
end forward

global type w_han_33010 from w_standard_print
string title = "���� ��/�� ��Ȳ"
rr_1 rr_1
end type
global w_han_33010 w_han_33010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_yymm

ls_yymm = dw_ip.GetItemString(row, 'yymm')
If Trim(ls_yymm) = '' OR IsNull(ls_yymm) Then
	MessageBox('���ؿ� Ȯ��', '���ؿ��� �Է��Ͻʽÿ�.')
	dw_ip.SetColumn('yymm')
	dw_ip.SetFocus()
	Return -1
End If

String ls_cvcod

ls_cvcod = dw_ip.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then
	MessageBox('�ŷ�ó Ȯ��', '�ŷ�ó�� Ȯ�� �Ͻʽÿ�.')
	dw_ip.SetColumn('cvcod')
	dw_ip.SetFocus()
	Return -1
End If

String ls_itnbr

ls_itnbr = dw_ip.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_yymm, ls_cvcod, ls_itnbr)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1
end function

on w_han_33010.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_han_33010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'yymm', String(TODAY(), 'yyyymm'))
end event

type p_xls from w_standard_print`p_xls within w_han_33010
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\������ȯ_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_33010
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_33010
boolean visible = false
integer x = 3410
integer y = 44
end type

type p_exit from w_standard_print`p_exit within w_han_33010
end type

type p_print from w_standard_print`p_print within w_han_33010
boolean visible = false
integer x = 3054
integer y = 40
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_33010
integer x = 4096
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

//	p_preview.enabled = False
//	p_preview.PictureName = 'C:\erpman\image\�̸�����_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\������ȯ_up.gif'
//	p_preview.enabled = true
//	p_preview.PictureName = 'C:\erpman\image\�̸�����_up.gif'
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







type st_10 from w_standard_print`st_10 within w_han_33010
end type



type dw_print from w_standard_print`dw_print within w_han_33010
string dataobject = "d_han_33010_002"
end type

type dw_ip from w_standard_print`dw_ip within w_han_33010
integer x = 37
integer y = 28
integer width = 2606
integer height = 164
string dataobject = "d_han_33010_001"
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
			MessageBox('ǰ�� Ȯ��', '�ش� ǰ���� ��ϵ��� ���� ǰ���Դϴ�.')
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

type dw_list from w_standard_print`dw_list within w_han_33010
integer x = 46
integer y = 224
integer width = 4521
integer height = 2020
string dataobject = "d_han_33010_002"
boolean border = false
end type

type rr_1 from roundrectangle within w_han_33010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 216
integer width = 4539
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

