$PBExportHeader$w_sm04_00005_1.srw
$PBExportComments$�����Ƿڵ��(����)
forward
global type w_sm04_00005_1 from w_inherite_popup
end type
type rr_2 from roundrectangle within w_sm04_00005_1
end type
end forward

global type w_sm04_00005_1 from w_inherite_popup
integer width = 1952
integer height = 1132
string title = "�����Ƿ�(�ǸŰ�ȹ ����)"
boolean controlmenu = true
rr_2 rr_2
end type
global w_sm04_00005_1 w_sm04_00005_1

forward prototypes
public function integer wf_update_reffpf ()
end prototypes

public function integer wf_update_reffpf ();long		lrow
string	srfgub, srfna3
for lrow=1 to dw_jogun.rowcount()
	if dw_jogun.getitemstring(lrow,'chk')='N' then continue
	if dw_jogun.getitemnumber(lrow,'rfna4')=99 then continue
	srfgub=dw_jogun.getitemstring(lrow,'rfgub')
	srfna3=trim(dw_jogun.getitemstring(lrow,'rfna3'))
	update reffpf set rfna3= :srfna3 where rfcod='5B' and rfgub= :srfgub ;
next

return 1     

end function

on w_sm04_00005_1.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_sm04_00005_1.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;
dw_jogun.SetTransObject(sqlca)

dw_1.InsertRow(0)
dw_1.SetItem(1, 'yymmdd', gs_code)
dw_1.SetItem(1, 'saupj', gs_codename)

dw_jogun.Retrieve()
Long i
For i = 1 To dw_jogun.RowCount()
	dw_jogun.Object.rfna3[i] = gs_code
Next


/* User�� ����� Setting Start */
//String sSaupj
//
//If f_check_saupj(sSaupj) = 1 Then
//	dw_1.Modify("saupj.protect=1")
//End If
//dw_1.SetItem(1, 'saupj', sSaupj)
///* ---------------------- End  */
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sm04_00005_1
integer x = 46
integer y = 212
integer width = 1829
integer height = 804
string dataobject = "d_sm04_00005_1_2"
boolean vscrollbar = true
end type

type p_exit from w_inherite_popup`p_exit within w_sm04_00005_1
integer x = 1733
integer y = 32
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)

Close(Parent)
end event

event p_exit::ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\�ݱ�_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\�ݱ�_up.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_sm04_00005_1
boolean visible = false
integer x = 27
integer y = 1148
end type

type p_choose from w_inherite_popup`p_choose within w_sm04_00005_1
integer x = 1559
integer y = 32
string picturename = "C:\erpman\image\����_up.gif"
end type

event p_choose::clicked;call super::clicked;String ls_saupj , ls_ymd ,ls_today , ls_sdate, ls_edate , ls_gubun
Long i ,ll_cnt

If dw_1.AcceptText() < 1 Then Return
If dw_jogun.AcceptText() < 1 Then Return

ls_ymd = trim(dw_1.getitemstring(1, 'yymmdd'))

If IsNull(ls_ymd) Or ls_ymd = '' Then
	f_message_chk(1400,'[��ȹ����]')
	Return
End If

/* ����� üũ */
ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(ls_saupj) Or ls_saupj = '' Then
	f_message_chk(1400, '[�����]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

IF MessageBox("Ȯ��", '���� ������ �ڷ� [������ó��]�� ���� ��� �����˴ϴ�. ~r~n~r~n����Ͻðڽ��ϱ�?', Exclamation!, OKCancel!, 2) = 2 THEN
	Return
END IF

ls_today = f_today()

SetPointer(HourGlass!)


For i = 1 To dw_jogun.RowCount()
	
	If dw_jogun.GetItemString(i, 'chk') <> 'Y' Then Continue
	
	ls_gubun = trim(dw_jogun.getitemstring(i, 'rfgub'))
	// ����ó�� ���� Ȯ��
//		ll_cnt = 0 
//		Select Count(*) Into :ll_cnt
//		  From SM04_DAILY_ITEM A , imhist B
//		 Where A.IOJPNO = B.IOJPNO
//		   AND A.SAUPJ = :ls_saupj
//		   AND A.YYMMDD = :ls_ymd
//			AND A.GUBUN = :ls_gubun
//			;
//			
//		If ll_cnt > 0 Then
//			dw_jogun.Object.bigo[i] = "���ϵ� ǰ���� �����Ͽ� ����� ����."
//			Continue ;
//		End iF
	//===========================================================
//	MESSAGEbOX('',ls_gubun)

//	ll_cnt = sqlca.sm04_create_data_DDS(ls_saupj , ls_ymd , ls_gubun )
	
	If sqlca.sqlcode <> 0 Then
		MessageBox('Ȯ��',sqlca.sqlerrText)
		Return
	End if
	
	If ll_cnt > 0 Then
		dw_jogun.Object.bigo[i] = String(ll_cnt) + " ���� �����Ǿ����ϴ�."
		wf_update_reffpf()
	ElseiF ll_cnt = -3 Then
		dw_jogun.Object.bigo[i] = "���ϵ� ǰ���� �����Ͽ� ����� ����."
	Else
		dw_jogun.Object.bigo[i] = "����(��������) �ڷᰡ �����ϴ�."
		
	End If
	
Next

COMMIT;
end event

event p_choose::ue_lbuttondown;PictureName = 'C:\erpman\image\����_dn.gif'
end event

event p_choose::ue_lbuttonup;PictureName = 'C:\erpman\image\����_up.gif'
end event

type dw_1 from w_inherite_popup`dw_1 within w_sm04_00005_1
integer x = 23
integer y = 24
integer width = 1545
integer height = 172
string dataobject = "d_sm04_00005_1_1"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::rowfocuschanged;//
end event

event dw_1::clicked;//
end event

type sle_2 from w_inherite_popup`sle_2 within w_sm04_00005_1
end type

type cb_1 from w_inherite_popup`cb_1 within w_sm04_00005_1
end type

type cb_return from w_inherite_popup`cb_return within w_sm04_00005_1
end type

type cb_inq from w_inherite_popup`cb_inq within w_sm04_00005_1
end type

type sle_1 from w_inherite_popup`sle_1 within w_sm04_00005_1
end type

type st_1 from w_inherite_popup`st_1 within w_sm04_00005_1
end type

type rr_2 from roundrectangle within w_sm04_00005_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 208
integer width = 1870
integer height = 820
integer cornerheight = 40
integer cornerwidth = 55
end type

