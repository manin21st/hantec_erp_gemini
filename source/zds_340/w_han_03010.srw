$PBExportHeader$w_han_03010.srw
$PBExportComments$���갡�� ��Ȳ
forward
global type w_han_03010 from w_standard_print
end type
type pb_1 from u_pb_cal within w_han_03010
end type
type pb_2 from u_pb_cal within w_han_03010
end type
type rr_1 from roundrectangle within w_han_03010
end type
end forward

global type w_han_03010 from w_standard_print
string title = "���갡�� ��Ȳ"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_han_03010 w_han_03010

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
		MessageBox('�������� Ȯ��', '���� ������ �߸��Ǿ����ϴ�.')
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
		MessageBox('�������� Ȯ��', '���� ������ �߸��Ǿ����ϴ�.')
		dw_ip.SetColumn('d_ed')
		dw_ip.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('�ⰣȮ��', '������ ���� �������� �����ϴ�.')
	dw_ip.SetColumn('d_st')
	dw_ip.SetFocus()
	Return -1
End If

String ls_jocod

ls_jocod = dw_ip.GetItemString(ll_row, 'jocod')
If Trim(ls_jocod) = '' OR IsNull(ls_jocod) Then
	ls_jocod = '%'
Else
	ls_jocod = ls_jocod + '%'
End If

String ls_mchno

ls_mchno = dw_ip.GetItemString(ll_row, 'mchno')
If Trim(ls_mchno) = '' OR IsNull(ls_mchno) Then
	ls_mchno = '%'
End If

String ls_stim

ls_stim = dw_ip.GetItemString(ll_row, 'stim')
If Trim(ls_stim) = '' OR IsNull(ls_stim) Then ls_stim = '0820'

String ls_etim

ls_etim = dw_ip.GetItemString(ll_row, 'etim')
If Trim(ls_etim) = '' OR IsNull(ls_etim) Then ls_etim = '0700'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed, ls_jocod, ls_mchno, ls_stim, ls_etim)
dw_print.Retrieve(ls_st, ls_ed, ls_jocod, ls_mchno, ls_stim, ls_etim)
dw_list.SetRedraw(True)

//dw_list.ShareData(dw_print)

Return 1
end function

on w_han_03010.create
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

on w_han_03010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))

String ls_st
ls_st = f_get_syscnfg('Y', 89, 'ST')
If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '0800'

String ls_ed
ls_ed = f_get_syscnfg('Y', 89, 'ED')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '0630'

dw_ip.SetItem(1, 'stim', ls_st)
dw_ip.SetItem(1, 'etim', ls_ed)
end event

type p_xls from w_standard_print`p_xls within w_han_03010
boolean visible = true
integer x = 4078
integer y = 24
string picturename = "C:\erpman\image\������ȯ_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_03010
boolean visible = true
integer x = 4251
integer y = 24
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_03010
integer x = 3904
end type

type p_exit from w_standard_print`p_exit within w_han_03010
integer x = 4425
end type

type p_print from w_standard_print`p_print within w_han_03010
boolean visible = false
integer x = 3511
integer y = 40
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_03010
integer x = 3730
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







type st_10 from w_standard_print`st_10 within w_han_03010
end type



type dw_print from w_standard_print`dw_print within w_han_03010
integer x = 3342
integer y = 52
string dataobject = "d_han_03010_004"
end type

type dw_ip from w_standard_print`dw_ip within w_han_03010
integer x = 32
integer width = 2537
integer height = 260
string dataobject = "d_han_03010_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
		
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

	Case 'd_st'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		If data = This.GetItemString(row, 'd_ed') Then
			This.SetItem(row, 'etim', '2400')
		Else
			This.SetItem(row, 'etim', f_get_syscnfg('Y', 89, 'ED'))
		End If
		
	Case 'd_ed'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		If data = This.GetItemString(row, 'd_st') Then
			This.SetItem(row, 'etim', '2400')
		Else
			This.SetItem(row, 'etim', f_get_syscnfg('Y', 89, 'ED'))
		End If
	
End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case dwo.name
		
	Case 'mchno'
		gs_gubun = 'ALL'
		
		Open(w_mchno_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'mchno' , gs_code    )
		This.SetItem(row, 'mchnm', gs_codename)
		Return
	
End Choose
end event

type dw_list from w_standard_print`dw_list within w_han_03010
integer x = 41
integer y = 300
integer width = 4558
integer height = 1928
string dataobject = "d_han_03010_002"
boolean border = false
end type

type pb_1 from u_pb_cal within w_han_03010
integer x = 667
integer y = 68
integer height = 76
integer taborder = 110
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('d_st')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'd_st', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

If gs_code = dw_ip.GetItemString(1, 'd_ed') Then
	dw_ip.SetItem(1, 'etim', '2400')
Else
	dw_ip.SetItem(1, 'etim', f_get_syscnfg('Y', 89, 'ED'))
End If

end event

type pb_2 from u_pb_cal within w_han_03010
integer x = 1312
integer y = 68
integer height = 76
integer taborder = 120
boolean bringtotop = true
end type

event clicked;call super::clicked;//�ش� �÷� ����
dw_ip.SetColumn('d_ed')

//GS�ڵ尡 Null �̸� ����
IF IsNull(gs_code) THEN Return 

//Gs Code�� ������ ��¥ �� ����
dw_ip.SetItem(1, 'd_ed', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

If gs_code = dw_ip.GetItemString(1, 'd_st') Then
	dw_ip.SetItem(1, 'etim', '2400')
Else
	dw_ip.SetItem(1, 'etim', f_get_syscnfg('Y', 89, 'ED'))
End If


end event

type rr_1 from roundrectangle within w_han_03010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 27
integer y = 288
integer width = 4585
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 55
end type

