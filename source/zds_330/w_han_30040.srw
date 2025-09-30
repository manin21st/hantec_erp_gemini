$PBExportHeader$w_han_30040.srw
$PBExportComments$��ȹ �� ����
forward
global type w_han_30040 from w_standard_print
end type
type pb_1 from u_pb_cal within w_han_30040
end type
type rr_1 from roundrectangle within w_han_30040
end type
end forward

global type w_han_30040 from w_standard_print
string title = "�ְ� �����ȹ ��� ���� ��Ȳ"
pb_1 pb_1
rr_1 rr_1
end type
global w_han_30040 w_han_30040

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_st

ls_st = dw_ip.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	MessageBox('������ Ȯ��', '�������� �ʼ� �Է� �׸��Դϴ�.')
	Return -1
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('�������� Ȯ��', '���������� �߸� �Ǿ����ϴ�.')
		dw_ip.SetColumn('d_st')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_jocod

ls_jocod = dw_ip.GetItemString(row, 'jocod')
If Trim(ls_jocod) = '' OR IsNull(ls_jocod) Then ls_jocod = '%'

String ls_itnbr

ls_itnbr = dw_ip.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_jocod, ls_itnbr)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

Return 1
end function

on w_han_30040.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_han_30040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;String ls_st

SELECT MAX(YYMMDD)
  INTO :ls_st
  FROM PM02_WEEKPLAN_SUM ;
  
dw_ip.SetItem(1, 'd_st', ls_st)
end event

type p_xls from w_standard_print`p_xls within w_han_30040
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\������ȯ_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_30040
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_30040
boolean visible = false
integer x = 2871
integer y = 28
end type

type p_exit from w_standard_print`p_exit within w_han_30040
end type

type p_print from w_standard_print`p_print within w_han_30040
boolean visible = false
integer x = 3045
integer y = 28
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_30040
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







type st_10 from w_standard_print`st_10 within w_han_30040
end type



type dw_print from w_standard_print`dw_print within w_han_30040
string dataobject = "d_han_30040_002"
end type

type dw_ip from w_standard_print`dw_ip within w_han_30040
integer x = 37
integer width = 2185
integer height = 164
string dataobject = "d_han_30040_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'd_st'
		If DayNumber(Date(LEFT(data, 4) + '.' + MID(data, 5, 2) + '.' + RIGHT(data, 2))) <> 2 Then
			MessageBox('Ȯ ��','�ְ� ��ȹ�� �����Ϻ��� Ȯ�� �����մϴ�.!!')
			dw_ip.SetItem(row, 'd_st', '')
			Return
		End If
End Choose
end event

type dw_list from w_standard_print`dw_list within w_han_30040
integer x = 50
integer y = 200
integer width = 4535
integer height = 2028
string dataobject = "d_han_30040_002"
boolean border = false
end type

type pb_1 from u_pb_cal within w_han_30040
integer x = 585
integer y = 48
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('d_st')
If IsNull(gs_code) Then Return
dw_ip.SetItem(1, 'd_st', gs_code)

If DayNumber(Date( Left(gs_code,4)+'-'+Mid(gs_code,5,2) +'-'+Right(gs_code,2) )) <> 2 Then
	MessageBox('Ȯ ��','�ְ� ��ȹ�� �����Ϻ��� Ȯ�� �����մϴ�.!!')
	dw_ip.SetItem(1, 'd_st', '')
	Return
End If
end event

type rr_1 from roundrectangle within w_han_30040
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 188
integer width = 4562
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

