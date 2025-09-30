$PBExportHeader$w_pdt_06044.srw
$PBExportComments$������� ���
forward
global type w_pdt_06044 from w_inherite
end type
type gb_3 from groupbox within w_pdt_06044
end type
type dw_1 from datawindow within w_pdt_06044
end type
type rb_1 from radiobutton within w_pdt_06044
end type
type rb_2 from radiobutton within w_pdt_06044
end type
type rb_3 from radiobutton within w_pdt_06044
end type
type cb_1 from commandbutton within w_pdt_06044
end type
type p_1 from uo_picture within w_pdt_06044
end type
type dw_list from u_d_select_sort within w_pdt_06044
end type
type cbx_1 from checkbox within w_pdt_06044
end type
type pb_1 from u_pb_cal within w_pdt_06044
end type
type pb_2 from u_pb_cal within w_pdt_06044
end type
type pb_3 from u_pb_cal within w_pdt_06044
end type
type pb_4 from u_pb_cal within w_pdt_06044
end type
type pb_5 from u_pb_cal within w_pdt_06044
end type
type p_2 from picture within w_pdt_06044
end type
type dw_2 from datawindow within w_pdt_06044
end type
type rr_1 from roundrectangle within w_pdt_06044
end type
end forward

global type w_pdt_06044 from w_inherite
integer width = 4677
integer height = 2512
string title = "������û���� �� ������(����)"
gb_3 gb_3
dw_1 dw_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cb_1 cb_1
p_1 p_1
dw_list dw_list
cbx_1 cbx_1
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
pb_5 pb_5
p_2 p_2
dw_2 dw_2
rr_1 rr_1
end type
global w_pdt_06044 w_pdt_06044

type variables
String sMtype
end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_required_chk ()
public function integer wf_init ()
public function integer wf_daychk (string as_str[])
public function integer wf_item (string as_jpno)
end prototypes

public function integer wf_retrieve ();string ls_rslcod , ls_sidat , ls_mchno , ls_eddat
int   li_seq

if dw_1.Accepttext() = -1 then return -1 

ls_sidat = dw_1.Getitemstring( 1, "sidat" )
ls_eddat = dw_1.GetItemString( 1, 'eddat' )
ls_mchno = dw_1.Getitemstring( 1, "mchno" )
li_seq   = dw_1.Getitemnumber( 1, "seq"  )

if Isnull(ls_sidat) or ls_sidat = "" then
	f_message_chk (1400 , "[�����Ƿ���]" ) 
	dw_1.setcolumn("sidat")
	dw_1.setfocus()
	return -1
ElseIf IsNull(ls_eddat) Or ls_eddat = '' Then
	f_message_chk(1400, '[�����Ƿ���]')
	dw_1.SetColumn('eddat')
	dw_1.SetFocus()
	Return -1
elseif IsNull(ls_mchno) or ls_mchno = "" then
	ls_mchno = '%'
//	f_message_chk (1400 , "[������ȣ]" ) 
//	dw_1.setcolumn("mchno")
//	dw_1.setfocus()
//	return -1
//elseif IsNull(li_seq) or li_seq = 0 then
//	f_message_chk (1400, "[�Ƿڹ�ȣ]" ) 
//	dw_1.setcolumn("seq")
//	dw_1.setfocus()
//	return -1
end if 

//if dw_insert.retrieve(gs_sabu, ls_sidat, ls_mchno, li_seq) <= 0 then  
If dw_list.Retrieve(ls_sidat, ls_eddat, ls_mchno) < 1 Then
	f_message_chk(50, "")
//   wf_init()
	return -1 
end if

//// ��ȸ��  dw_1 �� protect �ɾ��� 
//dw_1.Modify('sidat.protect = 1')
////dw_1.Modify('sidat.background.color = 79741120')
//dw_1.Modify('mchno.protect = 1')
////dw_1.Modify('mchno.background.color = 79741120')
//dw_1.Modify('seq.protect = 1' )
////dw_1.Modify('seq.background.color = 79741120')

return 1

end function

public function integer wf_required_chk ();string scode, sFdate, sTdate, sFtime, sTtime

if Isnull(Trim(dw_insert.object.mchrsl_sidat[1])) or Trim(dw_insert.object.mchrsl_sidat[1]) = "" then
  	f_message_chk(1400,'[�ǽ� ����]')
//	dw_insert.SetColumn('mchrsl_sidat')
//	dw_insert.SetFocus()
	return -1
end if	

if Isnull(Trim(dw_insert.object.mchrsl_mchno[1])) or Trim(dw_insert.object.mchrsl_mchno[1]) = "" then
  	f_message_chk(1400,'[���� ��ȣ]')
//	dw_insert.SetColumn('mchno')
//	dw_insert.SetFocus()
	return -1
end if	

if Isnull(Trim(dw_insert.object.mchrsl_chkman[1])) or &
   Trim(dw_insert.object.mchrsl_chkman[1]) = "" then
  	f_message_chk(1400,'[���������]')
	dw_insert.SetColumn('mchrsl_chkman')
	dw_insert.SetFocus()
	return -1
end if	

if Isnull(Trim(dw_insert.object.mchrsl_measure[1])) or &
   Trim(dw_insert.object.mchrsl_measure[1]) = "" then
  	f_message_chk(1400,'[��ġ����]')
	dw_insert.SetColumn('mchrsl_measure')
	dw_insert.SetFocus()
	return -1
end if	

scode = dw_insert.object.mchrsl_iegbn[1]
if IsNull(scode) or scode = "" then
	f_message_chk(1400, "[�系/�� ����]")
	dw_insert.SetColumn("mchrsl_iegbn")
	dw_insert.SetFocus()
   Return -1
elseif scode = '2' then  //����� ��� 
	scode = trim(dw_insert.object.mchrsl_cvcod[1])
	if IsNull(scode) or scode = "" then
		f_message_chk(1400, "[�ŷ�ó]")
		dw_insert.SetColumn("mchrsl_cvcod")
		dw_insert.SetFocus()
		Return -1
	end if
end if

sFdate = dw_insert.object.mchrsl_susidat[1]
if Isnull(sFdate) or Trim(sFdate) = "" then
  	f_message_chk(1400,'[������������]')
	dw_insert.SetColumn('mchrsl_susidat')
	dw_insert.SetFocus()
	return -1
end if	

sFtime = dw_insert.object.mchrsl_susitim[1]
if Isnull(sFtime) or Trim(sFtime) = "" then
  	f_message_chk(1400,'[�������۽ð�]')
	dw_insert.SetColumn('mchrsl_susitim')
	dw_insert.SetFocus()
	return -1
end if	

sTdate = dw_insert.object.mchrsl_sueddat[1]
if Isnull(sTdate) or Trim(sTdate) = "" then
  	f_message_chk(1400,'[�����Ϸ�����]')
	dw_insert.SetColumn('mchrsl_sueddat')
	dw_insert.SetFocus()
	return -1
end if	

sTtime = dw_insert.object.mchrsl_suedtim[1]
if Isnull(sTtime) or Trim(sTtime) = "" then
  	f_message_chk(1400,'[�����Ϸ�ð�]')
	dw_insert.SetColumn('mchrsl_suedtim')
	dw_insert.SetFocus()
	return -1
end if	

if sfdate > stdate then 
  	f_message_chk(200,'[������������]')
	dw_insert.SetColumn('mchrsl_susidat')
	dw_insert.SetFocus()
	return -1
elseif sfdate + sFtime > stdate + sTtime then 
  	f_message_chk(200,'[�������۽ð�]')
	dw_insert.SetColumn('mchrsl_susitim')
	dw_insert.SetFocus()
	return -1
end if

if rb_3.checked then 
	if Isnull(dw_insert.object.mchrsl_jutim[1]) or &
	   dw_insert.object.mchrsl_jutim[1] <= 0 then
		f_message_chk(1400,'[����ð�]')
		dw_insert.SetColumn('mchrsl_jutim')
		dw_insert.SetFocus()
		return -1
	end if	
end if	

if IsNull(dw_insert.object.mchrsl_gocod[1]) or dw_insert.object.mchrsl_gocod[1] = "" then //���� ���� �ڵ� 
	f_message_chk(1400, "[��������]")
	dw_insert.setcolumn("mchrsl_gocod")
	dw_insert.setfocus()
	return -1 
end if

return 1 


end function

public function integer wf_init ();int nCnt

select count(*) into :nCnt from reffpf
where rfcod = '4F'
and rfna2 = :gs_empno
and rfgub <> '00';

If cbx_1.Checked = False Then
	dw_insert.SetTabOrder('mchrsl_chkman' , 0)
	dw_insert.SetTabOrder('mchrsl_measure', 0)
	dw_insert.SetTabOrder('mchrsl_iegbn'  , 0)
	dw_insert.SetTabOrder('mchrsl_cvcod'  , 0)
	dw_insert.SetTabOrder('mchrsl_susidat', 0)
	dw_insert.SetTabOrder('mchrsl_susitim', 0)
	dw_insert.SetTabOrder('mchrsl_sueddat', 0)
	dw_insert.SetTabOrder('mchrsl_suedtim', 0)
	dw_insert.SetTabOrder('mchrsl_teeddat', 0)
	dw_insert.SetTabOrder('mchrsl_teedtim', 0)
	dw_insert.SetTabOrder('mchrsl_jutim'  , 0)
	dw_insert.SetTabOrder('mchrsl_gocod'  , 0)
	dw_insert.SetTabOrder('mchrsl_suamt'  , 0)
	dw_insert.SetTabOrder('mchrsl_gowon'  , 0)
	dw_insert.SetTabOrder('mchrsl_gorsl'  , 0)
	dw_insert.SetTabOrder('mchrsl_godae'  , 0)
	
	dw_insert.Modify('mchrsl_chkman.BackGround.color  = 33027312')
	dw_insert.Modify('mchrsl_measure.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_iegbn.BackGround.color   = 33027312')
	dw_insert.Modify('mchrsl_cvcod.BackGround.color   = 33027312')
	dw_insert.Modify('mchrsl_susidat.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_susitim.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_sueddat.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_suedtim.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_teeddat.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_teedtim.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_jutim.BackGround.color   = 33027312')
	dw_insert.Modify('mchrsl_gocod.BackGround.color   = 33027312')
	dw_insert.Modify('mchrsl_suamt.BackGround.color   = 33027312')
	dw_insert.Modify('mchrsl_gowon.BackGround.color   = 33027312')
	dw_insert.Modify('mchrsl_gorsl.BackGround.color   = 33027312')
	dw_insert.Modify('mchrsl_godae.BackGround.color   = 33027312')
	
	dw_insert.Modify('p1_master_bname.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_sutim.BackGround.color    = 33027312')
	dw_insert.Modify('mchrsl_damnm.BackGround.color    = 33027312')	
	dw_insert.Modify('vndmst_cvnas.BackGround.color    = 33027312')
Elseif cbx_1.Checked = TRUE and nCnt > 0 Then

	dw_insert.SetTabOrder('mchrsl_chkman' , 30 )
	dw_insert.SetTabOrder('mchrsl_measure', 40 )
	dw_insert.SetTabOrder('mchrsl_iegbn'  , 50 )
	dw_insert.SetTabOrder('mchrsl_cvcod'  , 60 )
	dw_insert.SetTabOrder('mchrsl_susidat', 70 )
	dw_insert.SetTabOrder('mchrsl_susitim', 80 )
	dw_insert.SetTabOrder('mchrsl_sueddat', 90 )
	dw_insert.SetTabOrder('mchrsl_suedtim', 100)
	dw_insert.SetTabOrder('mchrsl_teeddat', 110)
	dw_insert.SetTabOrder('mchrsl_teedtim', 120)
	dw_insert.SetTabOrder('mchrsl_jutim'  , 130)
	dw_insert.SetTabOrder('mchrsl_gocod'  , 140)
	dw_insert.SetTabOrder('mchrsl_suamt'  , 150)
	dw_insert.SetTabOrder('mchrsl_gowon'  , 160)
	dw_insert.SetTabOrder('mchrsl_gorsl'  , 170)
	dw_insert.SetTabOrder('mchrsl_godae'  , 180)
	
	dw_insert.Modify('mchrsl_chkman.BackGround.color  = 16777215')
//	dw_insert.Modify('mchrsl_measure.BackGround.color = 16777215')
//	dw_insert.Modify('mchrsl_iegbn.BackGround.color   = 16777215')
	dw_insert.Modify('mchrsl_cvcod.BackGround.color   = 16777215')
	dw_insert.Modify('mchrsl_susidat.BackGround.color = 16777215')
	dw_insert.Modify('mchrsl_susitim.BackGround.color = 16777215')
	dw_insert.Modify('mchrsl_sueddat.BackGround.color = 16777215')
	dw_insert.Modify('mchrsl_suedtim.BackGround.color = 16777215')
	dw_insert.Modify('mchrsl_teeddat.BackGround.color = 16777215')
	dw_insert.Modify('mchrsl_teedtim.BackGround.color = 16777215')
	dw_insert.Modify('mchrsl_jutim.BackGround.color   = 16777215')
	dw_insert.Modify('mchrsl_gocod.BackGround.color   = 16777215')
	dw_insert.Modify('mchrsl_suamt.BackGround.color   = 16777215')
	dw_insert.Modify('mchrsl_gowon.BackGround.color   = 16777215')
	dw_insert.Modify('mchrsl_gorsl.BackGround.color   = 16777215')
	dw_insert.Modify('mchrsl_godae.BackGround.color   = 16777215')
	
	dw_insert.Modify('p1_master_bname.BackGround.color = 16777215')
	dw_insert.Modify('mchrsl_sutim.BackGround.color    = 16777215')
	dw_insert.Modify('mchrsl_damnm.BackGround.color    = 16777215')
	dw_insert.Modify('vndmst_cvnas.BackGround.color    = 16777215')

Elseif cbx_1.Checked = TRUE and nCnt <= 0 Then

	dw_insert.SetTabOrder('mchrsl_chkman' , 0 )
	dw_insert.SetTabOrder('mchrsl_measure', 0 )
	dw_insert.SetTabOrder('mchrsl_iegbn'  , 0 )
	dw_insert.SetTabOrder('mchrsl_cvcod'  , 0 )
	dw_insert.SetTabOrder('mchrsl_susidat', 0 )
	dw_insert.SetTabOrder('mchrsl_susitim', 0 )
	dw_insert.SetTabOrder('mchrsl_sueddat', 0 )
	dw_insert.SetTabOrder('mchrsl_suedtim', 0)
	dw_insert.SetTabOrder('mchrsl_teeddat', 0)
	dw_insert.SetTabOrder('mchrsl_teedtim', 0)
	dw_insert.SetTabOrder('mchrsl_jutim'  , 0)
	dw_insert.SetTabOrder('mchrsl_gocod'  , 30)
	dw_insert.SetTabOrder('mchrsl_suamt'  , 0)
	dw_insert.SetTabOrder('mchrsl_gowon'  , 40)
	dw_insert.SetTabOrder('mchrsl_gorsl'  , 50)
	dw_insert.SetTabOrder('mchrsl_godae'  , 60)
	
	dw_insert.Modify('mchrsl_chkman.BackGround.color  = 33027312')
//	dw_insert.Modify('mchrsl_measure.BackGround.color = 16777215')
//	dw_insert.Modify('mchrsl_iegbn.BackGround.color   = 16777215')
	dw_insert.Modify('mchrsl_cvcod.BackGround.color   = 33027312')
	dw_insert.Modify('mchrsl_susidat.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_susitim.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_sueddat.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_suedtim.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_teeddat.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_teedtim.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_jutim.BackGround.color   = 33027312')
	dw_insert.Modify('mchrsl_gocod.BackGround.color   = 16777215')
	dw_insert.Modify('mchrsl_suamt.BackGround.color   = 33027312')
	dw_insert.Modify('mchrsl_gowon.BackGround.color   = 16777215')
	dw_insert.Modify('mchrsl_gorsl.BackGround.color   = 16777215')
	dw_insert.Modify('mchrsl_godae.BackGround.color   = 16777215')
	
	dw_insert.Modify('p1_master_bname.BackGround.color = 33027312')
	dw_insert.Modify('mchrsl_sutim.BackGround.color    = 33027312')
	dw_insert.Modify('mchrsl_damnm.BackGround.color    = 33027312')
	dw_insert.Modify('vndmst_cvnas.BackGround.color    = 33027312')
End If

ib_any_typing = false
return 1
	
end function

public function integer wf_daychk (string as_str[]);/*-------------------------------------------------------------------------------------------------------------------
[1]  = ������
[2]  = �����ϷΌ����
[3]  = ����������
[4]  = �������۽ð�
[5]  = �����Ϸ���
[6]  = �����Ϸ�ð�
[7]  = ����������
[8]  = �������۽ð�
-------------------------------------------------------------------------------------------------------------------*/
String ls_jid
String ls_tim

Long   row

row = dw_insert.GetRow()
If row < 1 Then Return -1

ls_jid = dw_insert.GetItemString(row, 'mchrsl_jidat')
If Trim(ls_jid) = '' OR IsNull(ls_jid) Then
	ls_jid = 'PASS'
//	MessageBox('�������� Ȯ��', '�������ڰ� �������� �ʾҽ��ϴ�.')
//	Return -1
End If

ls_tim = dw_insert.GetItemString(row, 'mchrsl_sttim')
If Trim(ls_tim) = '' OR IsNull(ls_tim) Then
	ls_tim = 'PASS'
//	MessageBox('�����ð� Ȯ��', '�����ð��� �������� �ʾҽ��ϴ�.')
//	Return -1
End If

If as_str[99] = 'A' Then
	//�����ϰ� ������ Ȯ��
	//�����Ϻ��� �������� ���� ���
	If ls_jid <> 'PASS' Then
		If ls_jid > as_str[1] Then
			MessageBox('����Ȯ��', '�������� �����Ϻ��� �����ϴ�.')
			dw_insert.SetColumn('mchrsl_redat')
			dw_insert.SetFocus()
			Return -1
		End If
	End If
	
	//�����ϰ� �����ϷΌ���� Ȯ��
	//�����Ϻ��� �����ϷΌ������ �������
	If as_str[1] > as_str[2] Then
		MessageBox('����Ȯ��', '�����ϷΌ������ �����Ϻ��� �����ϴ�.')
		dw_insert.SetColumn('mchrsl_comdat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	//�����ϰ� ���������� Ȯ��
	//�����Ϻ��� ������������ �������
	If as_str[1] > as_str[3] Then
		MessageBox('����Ȯ��', '������������ �����Ϻ��� �����ϴ�.')
		dw_insert.SetColumn('mchrsl_susidat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	//�����ϰ� ������������ ���� ��� �ð� Ȯ��
	//�����ϰ� ������������ ���� �����ð����� �������۽ð��� ���� ���
	If ls_jid <> 'PASS' Then
		If ls_jid = as_str[3] Then
			If ls_tim <> 'PASS' Then
				If ls_tim > as_str[4] Then
					MessageBox('�ð�Ȯ��', '�������۽ð��� �����ð����� �����ϴ�.')
					dw_insert.SetColumn('mchrsl_susitim')
					dw_insert.SetFocus()
					Return -1
				End If
			End If
		End If
	End If
	
	//���������ϰ� ���������� Ȯ��
	//���������Ϻ��� ������������ �������
	If as_str[3] > as_str[5] Then
		MessageBox('����Ȯ��', '������������ ���������Ϻ��� �����ϴ�.')
		dw_insert.SetColumn('mchrsl_sueddat')
		dw_insert.SetFocus()
		Return -1
	End If
	
	//���������ϰ� ������������ ������ �ð� Ȯ��
	//�������۽ð����� ��������ð��� �������
	If as_str[3] = as_str[5] Then
		If as_str[4] > as_str[6] Then
			MessageBox('�ð�Ȯ��', '��������ð��� �������۽ð����� �����ϴ�.')
			dw_insert.SetColumn('mchrsl_suedtim')
			dw_insert.SetFocus()
			Return -1
		End If
	End If
	
//	//���������ϰ� ���������� Ȯ��
//	//���������Ϻ��� ������������ �������
//	If as_str[5] > as_str[7] Then
//		MessageBox('����Ȯ��', '������������ ���������Ϻ��� �����ϴ�.')
//		dw_insert.SetColumn('mchrsl_teeddat')
//		dw_insert.SetFocus()
//		Return -1
//	End If
//	
//	//���������ϰ� ������������ ������ �ð� Ȯ��
//	//��������ð����� �������۽ð��� �������
//	If as_str[5] = as_str[7] Then
//		If as_str[6] > as_str[8] Then
//			MessageBox('�ð�Ȯ��', '�������۽ð��� ��������ð����� �����ϴ�.')
//			dw_insert.SetColumn('mchrsl_teedtim')
//			dw_insert.SetFocus()
//			Return -1 
//		End If
//	End If
	
Else
	//�����ϰ� ������ Ȯ��
	//�����Ϻ��� �������� ���� ���
	If ls_jid <> 'PASS' Then
		If ls_jid > as_str[1] Then
			MessageBox('����Ȯ��', '�������� �����Ϻ��� �����ϴ�.')
			dw_insert.SetColumn('mchrsl_redat')
			dw_insert.SetFocus()
			Return -1
		End If
	End If
	
	//�����ϰ� �����ϷΌ���� Ȯ��
	//�����Ϻ��� �����ϷΌ������ �������
	If as_str[1] > as_str[2] Then
		MessageBox('����Ȯ��', '�����ϷΌ������ �����Ϻ��� �����ϴ�.')
		dw_insert.SetColumn('mchrsl_comdat')
		dw_insert.SetFocus()
		Return -1
	End If	
End If

Return 1











































end function

public function integer wf_item (string as_jpno);Long   ll_cnt

SELECT COUNT('X')
  INTO :ll_cnt
  FROM IMHIST
 WHERE SABU   =    :gs_sabu
   AND IOJPNO LIKE :as_jpno ;
If ll_cnt < 1 OR IsNull(ll_cnt) Then Return -1

DECLARE item_cur CURSOR FOR
	SELECT A.ITNBR,
			 B.ITDSC,
			 B.ISPEC,
			 A.IOQTY
	  FROM IMHIST A,
			 ITEMAS B
	 WHERE A.ITNBR  =    B.ITNBR
		AND A.SABU   =    :gs_sabu
		AND A.IOJPNO LIKE :as_jpno ;
		
OPEN item_cur ;
	
String ls_itn
String ls_dsc
String ls_spe
String ls_text

Long   ll_qty
Long   i

ls_text = ''
For i = 1 To ll_cnt
	FETCH item_cur INTO :ls_itn, :ls_dsc, :ls_spe, :ll_qty ;
	
	If IsNull(ls_itn) Then ls_itn = ''
	If IsNull(ls_dsc) Then ls_dsc = ''
	If IsNull(ls_spe) Then ls_spe = '��'
	If IsNull(ll_qty) Then ll_qty = 0
	
	ls_text = ls_text + 'ǰ��:' + ls_itn + ' ' + 'ǰ��:' + ls_dsc + ' ' + '�԰�:' + ls_spe + ' ' + '����:' + String(ll_qty) + '~r'
	
Next

dw_2.Modify("t_item.Text = '" + ls_text + "'")

Return 1
end function

on w_pdt_06044.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.dw_1=create dw_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cb_1=create cb_1
this.p_1=create p_1
this.dw_list=create dw_list
this.cbx_1=create cbx_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.pb_5=create pb_5
this.p_2=create p_2
this.dw_2=create dw_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.p_1
this.Control[iCurrent+8]=this.dw_list
this.Control[iCurrent+9]=this.cbx_1
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.pb_2
this.Control[iCurrent+12]=this.pb_3
this.Control[iCurrent+13]=this.pb_4
this.Control[iCurrent+14]=this.pb_5
this.Control[iCurrent+15]=this.p_2
this.Control[iCurrent+16]=this.dw_2
this.Control[iCurrent+17]=this.rr_1
end on

on w_pdt_06044.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.dw_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cb_1)
destroy(this.p_1)
destroy(this.dw_list)
destroy(this.cbx_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.pb_5)
destroy(this.p_2)
destroy(this.dw_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
dw_list.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_insert.InsertRow(0)
dw_1.InsertRow(0)

String ls_stdat
String ls_eddat
ls_stdat = String(TODAY(), 'yyyymm') + '01'
ls_eddat = String(TODAY(), 'yyyymmdd')

dw_1.SetItem(1, 'sidat', ls_stdat)
dw_1.SetItem(1, 'eddat', ls_eddat)

dw_insert.SetItem(1, 'mchrsl_useitem', 'Y')

wf_init()

if gs_dept = '42000' then
	sMtype = '000002'
else
	sMtype = '000001'
end if




end event

type dw_insert from w_inherite`dw_insert within w_pdt_06044
event ue_mousemove pbm_dwnmousemove
integer x = 1687
integer y = 176
integer width = 2935
integer height = 2144
integer taborder = 40
string dataobject = "d_pdt_06044_01"
boolean border = false
end type

event dw_insert::ue_mousemove;If row < 1 Then Return

This.Modify('userqty.color = 33554432')
This.Modify('userqty.font.weight = 400')
This.Modify('userqty.border = 0')

Choose Case dwo.name
	Case 'userqty'
		This.Modify('userqty.color = 128')
      This.Modify('userqty.font.weight = 700')
		This.Modify('userqty.border = 6')
End Choose
end event

event dw_insert::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "mchrsl_chkman" then
	open(w_sawon_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "mchrsl_chkman", gs_code)
	this.SetItem(1, "p1_master_bname", gs_codename)
elseif this.getcolumnname() = "mchrsl_cvcod" then  // �����ŷ�ó �ڵ�
	gs_gubun = '1'
	open(w_vndmst_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "mchrsl_cvcod", gs_code)
	this.SetItem(1, "vndmst_cvnas", gs_codename)
end if

end event

event dw_insert::itemchanged;String  s_cod, s_nam1, s_nam2, sNull
Integer ireturn
long    ll_ret

setnull(sNull)

if this.getcolumnname() = "mchrsl_susidat" then // ��ȿ�� üũ 
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[�������� ����]")
		this.object.mchrsl_susidat[1] = ""
		return 1
	end if
   this.setitem(1, "mchrsl_sueddat", s_cod ) 
elseif this.getcolumnname() = "mchrsl_sueddat" then
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[�����Ϸ� ����]")
		this.object.mchrsl_sueddat[1] = ""
		return 1
	end if
elseif  this.getcolumnname() = "mchrsl_susitim" then 
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then return 
	if f_timechk(s_cod) = -1 then
		f_message_chk(176, "[�������� �ð�]")
		this.object.mchrsl_susitim[1] = ""
		return 1
	end if
elseif  this.getcolumnname() = "mchrsl_suedtim"  then   
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then return 
	if f_timechk(s_cod) = -1 then
		f_message_chk(176, "[�����Ϸ� �ð�]")
		this.object.mchrsl_suedtim[1] = ""
		return 1
	end if
ELSEIF this.GetColumnName() = 'mchrsl_chkman' THEN
   s_cod = this.gettext()
	ireturn = f_get_name2('���', 'Y', s_cod, s_nam1, s_nam2)
	this.setitem(1, "mchrsl_chkman", s_cod)
	this.setitem(1, "p1_master_bname", s_nam1)
	return ireturn 			
ELSEIF this.GetColumnName() = 'mchrsl_cvcod' then
   s_cod = this.gettext()
   ireturn = f_get_name2('V1', 'Y', s_cod, s_nam1, s_nam2)
   this.setitem(1, "mchrsl_cvcod", s_cod)
   this.setitem(1, "vndmst_cvnas", s_nam1)
   return ireturn
ELSEIF this.GetColumnName() = 'mchrsl_iegbn' then
   s_cod = this.gettext()
	if s_cod = '1' then //�系�� ��� 
		this.setitem(1, "mchrsl_cvcod", sNull)
		this.setitem(1, "vndmst_cvnas", sNull)
		this.setitem(1, "mchrsl_damnm", sNull)
	end if
End if

end event

event dw_insert::itemerror;call super::itemerror;return 1


end event

event dw_insert::ue_pressenter;call super::ue_pressenter;//if this.getcolumnname() = "mchrsl_gowon" or this.getcolumnname() = "mchrsl_gorsl" or &
//   this.getcolumnname() = "mchrsl_godae" then
//   return 1
//else
//   Send(Handle(this),256,9,0)
//   Return 1
//end if
end event

event dw_insert::losefocus;call super::losefocus;this.accepttext()
end event

event dw_insert::clicked;call super::clicked;If row < 1 Then Return

SetNull(gs_code)

gstr_array lstr_str

Choose Case dwo.name
	Case 'userqty'
		If dw_list.GetItemString(dw_list.GetRow(), 'status') <> '3' Then
			If cbx_1.Checked <> True Then
				Return
			End If
		End If
		
		lstr_str.as_str[1] = This.GetItemString(row, 'mchrsl_sabu' )
		lstr_str.as_str[2] = This.GetItemString(row, 'mchrsl_sidat')
		lstr_str.as_str[3] = This.GetItemString(row, 'mchrsl_gubun')
		lstr_str.as_str[4] = This.GetItemString(row, 'mchrsl_mchno')
		lstr_str.as_str[5] = String(This.GetItemNumber(row, 'mchrsl_seq'))
		
		OpenWithParm(w_pdt_06044_popup_001, lstr_str)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

		This.SetItem(row, 'userqty', '�� ' + gs_code + '��')
End Choose
			
end event

event dw_insert::buttonclicked;call super::buttonclicked;If row <= 0 then return

If dwo.name = 'b_1' Then
	gs_gubun		= trim(dw_insert.getitemstring(1,'mchrsl_sidat'))
	gs_code			= dw_insert.getitemstring(1,'mchrsl_gubun')
	gs_codename	= trim(dw_insert.getitemstring(1,'mchrsl_mchno'))
	gi_page			= dw_insert.getitemnumber(1,'mchrsl_seq')

	open(w_pdt_06044_image)	
End If

end event

type p_delrow from w_inherite`p_delrow within w_pdt_06044
integer x = 3054
integer y = 5000
integer taborder = 80
end type

type p_addrow from w_inherite`p_addrow within w_pdt_06044
integer x = 2880
integer y = 5000
integer taborder = 60
end type

type p_search from w_inherite`p_search within w_pdt_06044
integer x = 1970
integer y = 5000
integer taborder = 170
end type

type p_ins from w_inherite`p_ins within w_pdt_06044
integer x = 2706
integer y = 5000
integer taborder = 50
end type

type p_exit from w_inherite`p_exit within w_pdt_06044
integer x = 4402
integer y = 20
integer taborder = 160
end type

type p_can from w_inherite`p_can within w_pdt_06044
integer x = 4229
integer y = 20
integer taborder = 140
end type

event p_can::clicked;call super::clicked;//wf_init()

String ls_st
String ls_ed
ls_st = String(RelativeDate(TODAY(), -30), 'yyyymmdd')
ls_ed = String(TODAY(), 'yyyymmdd')

dw_1.ReSet()
dw_list.ReSet()
dw_insert.ReSet()

dw_1.InsertRow(0)
dw_insert.InsertRow(0)

cbx_1.Checked = False

dw_1.SetItem(1, 'sidat', ls_st)
dw_1.SetItem(1, 'eddat', ls_ed)

dw_insert.SetItem(1, 'mchrsl_useitem', 'Y')
end event

type p_print from w_inherite`p_print within w_pdt_06044
integer x = 2359
integer y = 5000
integer taborder = 190
end type

type p_inq from w_inherite`p_inq within w_pdt_06044
integer x = 3707
integer y = 20
end type

event p_inq::clicked;call super::clicked;//wf_retrieve() 

//if rb_1.checked then 
//   p_mod.enabled = true
//	p_mod.picturename = "c:\erpman\image\����_up.gif"
//elseif rb_2.checked then 	
//   p_mod.enabled = true
//   p_del.enabled = true
//   p_1.enabled = true
//	p_mod.picturename = "c:\erpman\image\����_up.gif"
//	p_del.picturename = "c:\erpman\image\����_up.gif"
//	p_1.picturename   = "c:\erpman\image\���������_up.gif"	
//end if

dw_1.AcceptText()

Long row 
row = dw_1.GetRow()
If row < 1 Then Return

String ls_si
String ls_ed
String ls_mch
String ls_status

ls_si     = dw_1.GetItemString(row, 'sidat' )
ls_ed     = dw_1.GetItemString(row, 'eddat' )
ls_mch    = dw_1.GetItemString(row, 'mchno' )
ls_status = dw_1.GetItemString(row, 'status')

If Trim(ls_si) = '' Or IsNull(ls_si) Then
	f_message_chk(1400, '[�����Ƿ���]')
	dw_1.SetColumn('sidat')
	dw_1.SetFocus()
	Return
End If

If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	f_message_chk(1400, '[�����Ƿ���]')
	dw_1.SetColumn('eddat')
	dw_1.SetFocus()
	Return
End If

If Trim(ls_mch) = '' Or IsNull(ls_mch) Then ls_mch = '%'

If Trim(ls_status) = '' Or IsNull(ls_status) Then ls_status = '%'

If dw_list.Retrieve(gs_sabu, ls_si, ls_ed, ls_mch) < 1 Then
	p_2.Enabled = False
	p_2.PictureName = 'C:\erpman\image\�μ�_d.gif'
	f_message_chk(50, '')
	Return
End If

p_2.Enabled = True
p_2.PictureName = 'C:\erpman\image\�μ�_up.gif'

cbx_1.Enabled = True
dw_list.ScrollToRow(row)
dw_list.SelectRow(0, False)
dw_list.SetRow(row)
dw_list.SelectRow(row, True)
end event

type p_del from w_inherite`p_del within w_pdt_06044
integer x = 4055
integer y = 20
integer taborder = 120
end type

event p_del::clicked;call super::clicked;/**********************************************************************************************************/
/******																															  ******/
/******               ���� �� ���� ���� �۾��ϱ� ���� (DATA ������ �̷�� ���� ����)                 ******/
/******												2005.10.25    															  ******/
/**********************************************************************************************************/
If f_msg_delete() = -1 Then Return

Long row
row = dw_list.GetRow()
If row < 1 Then Return

String ls_stat
ls_stat = dw_list.GetItemString(row, 'status')

String ls_sabu
String ls_sidat
String ls_gubun
String ls_mchno
Long   ll_seq

ls_sabu  = dw_list.GetItemString(row, 'mchrsl_sabu' )
ls_sidat = dw_list.GetItemString(row, 'mchrsl_sidat')
ls_gubun = dw_list.GetItemString(row, 'mchrsl_gubun')
ls_mchno = dw_list.GetItemString(row, 'mchrsl_mchno')
ll_seq   = dw_list.GetItemNumber(row, 'mchrsl_seq'  )

Choose Case ls_stat
	Case '1'  //�Ƿڻ��¿��� ����
		MessageBox('Ȯ��', '�Ƿڻ��´� �����Ͻ� �� �����ϴ�!')
		Return
		
	Case '2'  //�������¿��� ����
		//���� : mchrsl_redat   mchrsl_comdat
		UPDATE MCHRSL
		   SET REDAT  = NULL,
			    COMDAT = NULL
	    WHERE SABU   = :ls_sabu
		   AND SIDAT  = :ls_sidat
			AND GUBUN  = :ls_gubun
			AND MCHNO  = :ls_mchno
			AND SEQ    = :ll_seq   ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			f_message_chk(32, "[�������]")
			sle_msg.Text = "�����۾� ����!"
			Return
		End If
		
	Case '3'  //�Ϸ���¿��� ����
		//�Ϸ� : �ش� �Ӽ� Null ������ ó��
		UPDATE MCHRSL
		   SET CHKMAN  = NULL, MEASURE = NULL, IEGBN   = NULL, CVCOD   = NULL,
			    SUSIDAT = NULL, SUSITIM = NULL, SUEDDAT = NULL, SUEDTIM = NULL,
				 DAMNM   = NULL, JUTIM   = NULL, SUTIM   = NULL, GOCOD   = NULL,
				 SUAMT   = NULL, GOWON   = NULL, GORSL   = NULL, GODAE   = NULL,
				 TEEDDAT = NULL, TEEDTIM = NULL
	    WHERE SABU   = :ls_sabu
		   AND SIDAT  = :ls_sidat
			AND GUBUN  = :ls_gubun
			AND MCHNO  = :ls_mchno
			AND SEQ    = :ll_seq   ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			f_message_chk(32, "[�������]")
			sle_msg.Text = "�����۾� ����!"
			Return
		End If				 
		
		//������� ����
		DELETE FROM "MCHCHK_MTR"  
            WHERE ( "MCHCHK_MTR"."SABU"  = :ls_sabu   ) AND  
	               ( "MCHCHK_MTR"."SIDAT" = :ls_sidat  ) AND  
		            ( "MCHCHK_MTR"."MCHNO" = :ls_mchno  ) AND  
		            ( "MCHCHK_MTR"."SEQNO" = :ll_seq    ) AND  
		            ( "MCHCHK_MTR"."GUBUN" = '4'        ) ;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
			f_message_chk(160, '[������� ��������]')
			sle_msg.Text = '������� ���� ����!'
			Return
		End If
		
End Choose

COMMIT USING SQLCA;

p_inq.PostEvent(Clicked!)

//string snull, sIns_gub, sSidat, sMchno
//int    iseq
//
//setnull(snull)
//
//if dw_1.Accepttext() = -1 then return
//if dw_insert.Accepttext() = -1 then return
//
////if rb_2.checked = false then return 
//
//sSidat = trim(dw_insert.object.mchrsl_sidat[1])
//smchno = trim(dw_insert.object.mchrsl_mchno[1])
//iseq   = dw_insert.object.mchrsl_seq[1]
//
//if IsNull(ssidat) or ssidat = "" then
//	f_message_chk(30, "[�Ƿ�����]")
//	dw_insert.SetColumn("sidat")
//	dw_insert.SetFocus()
//   return
//end if
//if IsNull(smchno) or smchno = "" then
//	f_message_chk(30, "[������ȣ]")
//	dw_insert.SetColumn("mchno")
//	dw_insert.SetFocus()
//   return
//end if
//if IsNull(iseq) or iseq = 0 then
//	f_message_chk(30, "[�Ƿڹ�ȣ]")
//	dw_insert.SetColumn("seq")
//	dw_insert.SetFocus()
//   return
//end if
//
//IF f_msg_delete() = -1 THEN	RETURN
//
//sIns_gub = dw_insert.getitemstring(1,"mchrsl_ins_gub")
//
//DELETE FROM "MCHCHK_MTR"  
// WHERE ( "MCHCHK_MTR"."SABU"  = :gs_sabu ) AND  
//		 ( "MCHCHK_MTR"."SIDAT" = :sSidat ) AND  
//		 ( "MCHCHK_MTR"."MCHNO" = :sMchno ) AND  
//		 ( "MCHCHK_MTR"."SEQNO" = :iseq ) AND  
//		 ( "MCHCHK_MTR"."GUBUN" = '4' )   ;
//		 
//IF SQLCA.SQLCODE = 0	THEN	
//
//	if sIns_gub = '1' then // ������� 	
//		dw_insert.object.mchrsl_rslcod[1] = 'W'	
//		dw_insert.object.mchrsl_measure[1] = snull
//		dw_insert.object.mchrsl_chkman[1] = snull
//		dw_insert.object.mchrsl_cvcod[1] = snull
//		dw_insert.object.mchrsl_damnm[1] = snull
//		dw_insert.object.mchrsl_iegbn[1] = '1'
//		dw_insert.object.mchrsl_susidat[1] = snull
//		dw_insert.object.mchrsl_susitim[1] = snull
//		dw_insert.object.mchrsl_sueddat[1] = snull
//		dw_insert.object.mchrsl_suedtim[1] = snull
//		dw_insert.object.mchrsl_jutim[1] = 0
//		dw_insert.object.mchrsl_sutim[1] = 0
//		dw_insert.object.mchrsl_watim[1] = 0
//		dw_insert.object.mchrsl_suamt[1] = 0
//		dw_insert.object.mchrsl_gowon[1] = snull
//		dw_insert.object.mchrsl_gorsl[1] = snull
//		dw_insert.object.mchrsl_godae[1] = snull
//		dw_insert.object.mchrsl_tesidat[1] = snull
//		dw_insert.object.mchrsl_tesitim[1] = snull
//		dw_insert.object.mchrsl_teeddat[1] = snull
//		dw_insert.object.mchrsl_teedtim[1] = snull
//		dw_insert.object.mchrsl_redat[1] = snull
//		dw_insert.object.mchrsl_comdat[1] = snull
//		
//		IF dw_insert.Update() > 0 THEN		
//			COMMIT;
//		ELSE
//			ROLLBACK;
//			f_message_chk(32, "[�������]")
//			sle_msg.Text = "�����۾� ����!"
//		END IF
////		wf_init()
//	elseif sIns_gub = '2' then // ������� 	
//		dw_insert.setredraw(false)
//		dw_insert.deleterow(0)  
//		IF dw_insert.Update() > 0 THEN		
//			COMMIT;
//		ELSE
//			ROLLBACK;
//			f_message_chk(32, "[�������]")
//		END IF
////		wf_init()
//		dw_insert.setredraw(true)
//	end if
//ELSE
//	Rollback;
//	Messagebox('��������', '������� ������ �����Ͽ����ϴ�.')
//	Return 
//END IF
//
end event

type p_mod from w_inherite`p_mod within w_pdt_06044
integer x = 3881
integer y = 20
integer taborder = 100
end type

event p_mod::clicked;call super::clicked;String ls_sidat, ls_mchno, ls_susidat, ls_susitim, ls_sueddat, ls_suedtim
int    ll_seq
long   lTerm, lFix

if dw_insert.AcceptText() = -1 then return
	
//���忩�� �޼���
if f_msg_update() = -1 then return

//---------------------------------------------------------------------------------------------------

String ls_array[]

String ls_re
String ls_ed
String ls_testdat
String ls_testtim
String ls_jidat
String ls_sttim

ls_re = dw_insert.GetItemString(1, 'mchrsl_redat' )  //��û������
ls_ed = dw_insert.GetItemString(1, 'mchrsl_comdat')  //�ϷΌ����
	
ls_array[1]  = ls_re
ls_array[2]  = ls_ed

String ls_chk
String ls_sabu
String ls_jpno

Long   ll_cnt

ls_chk = dw_insert.GetItemString(1, 'mchrsl_useitem')
If ls_chk = 'Y' Then
	ls_sabu = dw_insert.GetItemString(1, 'mchrsl_sabu'  )
	ls_jpno = dw_insert.GetItemString(1, 'mchrsl_iojpno')
	
	SELECT COUNT(SABU)
	  INTO :ll_cnt
     FROM IMHIST
    WHERE SABU   = :ls_sabu
      AND IOJPNO = :ls_jpno
      AND IOGBN  = 'O81'   ;
	If ll_cnt < 1 OR IsNull(ll_cnt) Then
		MessageBox('������� ���', '������� ���ΰ� ���õǾ����ϴ�.~r~n����� ���縦 ����Ͻʽÿ�.')
		Return
	End If
End If

//������ ���õǸ� ��ü ����
//������ ���õ��� ������ ���� �׸� ����
If cbx_1.Checked = True Then

	if wf_required_chk() = -1 then return //�ʼ��Է��׸� üũ
	
	ls_susidat = dw_insert.getitemstring( 1, "mchrsl_susidat")  // ������������ 
	ls_susitim = dw_insert.getitemstring( 1, "mchrsl_susitim")  // �������۽ð�
	ls_sueddat = dw_insert.getitemstring( 1, "mchrsl_sueddat")  // �����Ϸ����� 
	ls_suedtim = dw_insert.getitemstring( 1, "mchrsl_suedtim")  // �����Ϸ�ð� 
	ls_testdat = dw_insert.GetItemString( 1, 'mchrsl_teeddat')  // ������������
	ls_testtim = dw_insert.GetItemString( 1, 'mchrsl_teedtim')  // �������۽ð�
	ls_jidat   = dw_insert.GetItemString( 1, 'mchrsl_jidat'  )  // ��������
	ls_sttim   = dw_insert.GetItemString( 1, 'mchrsl_sttim'  )  // �����ð�
	
	ls_array[3]  = ls_susidat
	ls_array[4]  = ls_susitim
	ls_array[5]  = ls_sueddat
	ls_array[6]  = ls_suedtim
	ls_array[7]  = ls_testdat
	ls_array[8]  = ls_testtim
	ls_array[9]  = ls_jidat
	ls_array[10] = ls_sttim
	ls_array[99] = 'A'
	
	lTerm = f_daytimeterm(ls_susidat, ls_sueddat, ls_susitim, ls_suedtim )
	lFix  = f_daytimeterm(ls_jidat  , ls_sueddat, ls_sttim  , ls_suedtim )
	if lTerm < 0 then
		MessageBox("Ȯ��", "�ð��� �ùٸ��� ��ϵ����ʾҽ��ϴ�!" )
		dw_insert.setcolumn("mchrsl_susidat")
		dw_insert.setfocus()
		return
	else
		dw_insert.setitem(1, 'mchrsl_sutim', lTerm)
	end if
	
	If lFix < 0 Then
		MessageBox('Ȯ��', '�ð��� �ùٸ��� ��ϵ��� �ʾҽ��ϴ�.')
		Return
	Else
		dw_insert.SetItem(1, 'mchrsl_jutim', lFix)
	End If
	
	//--------------------------------------------------------------------------------------------------------------
	//��û�����ϰ� �ϷΌ������ �Է����� ������ Default �� �Է� (��û������ = ������������, �ϷΌ���� = �����Ϸ�����)
	If Trim(ls_re) = '' OR IsNull(ls_re) Then dw_insert.SetItem(1, 'mchrsl_redat' , ls_susidat)  //��û������
	If Trim(ls_ed) = '' Or IsNull(ls_ed) Then dw_insert.SetItem(1, 'mchrsl_comdat', ls_sueddat)  //�ϷΌ����
	//--------------------------------------------------------------------------------------------------------------
	
	dw_insert.object.mchrsl_rslcod[1] = '3'
	
	If wf_daychk(ls_array[]) < 1 Then Return
	
Else
	ls_array[99] = 'N'
	
	If Trim(ls_re) = '' Or IsNull(ls_re) Then
		MessageBox('Ȯ��', '��û�������� �Է��Ͻʽÿ�!')
		dw_insert.SetColumn('mchrsl_redat')
		dw_insert.SetFocus()
		Return
	End If
	
	If Trim(ls_ed) = '' Or IsNull(ls_ed) Then
		MessageBox('Ȯ��', '�ϷΌ������ �Է��Ͻʽÿ�!')
		dw_insert.SetColumn('mchrsl_comdat')
		dw_insert.SetFocus()
		Return
	End If
	
	If wf_daychk(ls_array[]) < 1 Then Return
	
End If	
	
IF dw_insert.Update() > 0 THEN		
	COMMIT;
	sle_msg.Text = "���� �Ǿ����ϴ�!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[�������]")
	sle_msg.Text = "�����۾� ����!"
	return 
END IF

ib_any_typing = False //�Է��ʵ� ���濩�� No

//������ Check Box
cbx_1.Checked = False

p_inq.PostEvent(Clicked!)

end event

type cb_exit from w_inherite`cb_exit within w_pdt_06044
integer x = 2994
integer y = 5000
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06044
integer x = 1952
integer y = 5000
integer taborder = 110
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06044
integer x = 1641
integer y = 2816
integer width = 361
string text = "�߰�(&I)"
end type

type cb_del from w_inherite`cb_del within w_pdt_06044
integer x = 2299
integer y = 5000
integer taborder = 130
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_06044
integer x = 2194
integer y = 5000
integer taborder = 70
end type

type cb_print from w_inherite`cb_print within w_pdt_06044
integer x = 2034
integer y = 2828
end type

type st_1 from w_inherite`st_1 within w_pdt_06044
end type

type cb_can from w_inherite`cb_can within w_pdt_06044
integer x = 2647
integer y = 5000
integer taborder = 150
end type

type cb_search from w_inherite`cb_search within w_pdt_06044
integer x = 2971
integer y = 2828
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_06044
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06044
end type

type gb_3 from groupbox within w_pdt_06044
boolean visible = false
integer x = 2094
integer y = 2980
integer width = 1536
integer height = 148
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
end type

type dw_1 from datawindow within w_pdt_06044
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 23
integer y = 24
integer width = 3031
integer height = 148
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdt_06044_02"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string s_cod, ls_mchnam, ls_sidat, ls_mchno, snull
int    inull, li_seq

sle_msg.text = ""

setnull(snull)
setnull(inull)
 
if this.getcolumnname() = "sidat"  then  // �����Ƿ� ���� 
	s_cod = Trim(this.gettext()) 
   
	if s_cod = '' or isnull(s_cod) then return 
	if f_datechk(s_cod) = -1 then 
		f_message_chk(35, "[�����Ƿ���]" )
		this.object.sidat[1] = "" 
		return 1
	end if
elseif  this.getcolumnname() = "mchno" then // �����ȣ 
	s_cod = Trim(this.gettext())
		
	if IsNull(s_cod) or s_cod = ""  then
		this.object.mchnam[1] = ""
//		this.object.seq[1] = inull
		return 
	end if
		
	select a.mchnam 
	  into :ls_mchnam
	  from mchmst a, mchgrp b
	 where a.sabu = :gs_sabu 
	 and a.mchno = :s_cod
	 and a.grpcod = b.grpcod
	 and b.m_type = :sMtype;
		
	if sqlca.sqlcode <> 0 then
		messageBox("Ȯ��", "��ϵ� �����ȣ�� �ƴմϴ�. " )
		this.setitem(1, "mchno",  snull)
		this.setitem(1, "mchnam", snull)
//		this.setitem(1, "seq",    inull)
		return 1
	end if
	
	this.setitem(1, "mchnam", ls_mchnam) 	
elseif  this.getcolumnname() = "seq" then   // ���� 
	li_seq   = integer(this.gettext())
	if li_seq <= 0 or isnull(li_seq) then return 
	 
	ls_sidat = trim(this.getitemstring(1, "sidat"))
	ls_mchno = trim(this.getitemstring(1, "mchno"))
	 
	if ls_sidat = '' or isnull(ls_sidat) then 
 	   messagebox('Ȯ ��', '�����Ƿ����ڸ� ���� �Է��ϼ���!')
		this.setitem(1, 'seq', inull)
		this.SetColumn('sidat')
		return 1
	end if
	if ls_mchno = '' or isnull(ls_mchno) then 
 	   messagebox('Ȯ ��', '������ȣ�� ���� �Է��ϼ���!')
		this.setitem(1, 'seq', inull)
		this.SetColumn('mchno')
		return 1
	end if
	 
	if rb_1.checked then  // ������(�Ƿ�) 
		select rslcod
		  into :s_cod
		  from mchrsl
		 where sabu   = :gs_sabu
		   and sidat  = :ls_sidat 
			and gubun  = '4'   
			and mchno  = :ls_mchno 
			and seq    = :li_seq ;
			
		if sqlca.sqlcode <> 0 then 
			MessageBox("Ȯ��", "��ϵ� �Ƿڹ�ȣ�� �ƴմϴ�. �ڷḦ Ȯ���ϼ���!")
			this.setitem(1, "seq", inull ) 
			return 1
		else
			if s_cod <> 'W' then 
				MessageBox("Ȯ��", "���� ó���� �Ƿڹ�ȣ�Դϴ�. ����������� �ڷḦ �����ϼ���")
				this.setitem(1, "seq", inull ) 
				return 1
			end if
		end if
		p_inq.triggerevent(clicked!)
	elseif rb_2.checked then // ������� 
		select rslcod
		  into :s_cod
		  from mchrsl
		 where sabu   = :gs_sabu
		   and sidat  = :ls_sidat 
			and gubun  = '4'   
			and mchno  = :ls_mchno 
			and seq    = :li_seq ;
			
		if sqlca.sqlcode <> 0 then 
			MessageBox("Ȯ��", "��ϵ� �Ƿڹ�ȣ�� �ƴմϴ�. �ڷḦ Ȯ���ϼ���!")
			this.setitem(1, "seq", inull ) 
			return 1
		else
			if s_cod = 'W' then 
				MessageBox("Ȯ��", "���� �Ƿڵ� �Ƿڹ�ȣ�Դϴ�. �����Ͽ��� �ڷḦ �����ϼ���")
				this.setitem(1, "seq", inull ) 
				return 1
			end if
		end if
		p_inq.triggerevent(clicked!)
	end if
end if 	


end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if	this.getcolumnname() = "mchno"   then
	gs_code = sMtype
	open(w_mchno_popup)
	if gs_code= '' or isnull(gs_code) then return
	this.SetItem(1, "mchno", gs_code)
	this.SetItem(1, "mchnam", gs_codename)
//elseif  this.getcolumnname() = 'seq' then
//	if rb_1.checked then //  ������  , �Ƿ� 
//		gs_code  = this.getitemstring( 1, "mchno" )
//		gs_gubun  = 'W'
//		
//		open ( w_pdt_06043_pop_up)
//		if IsNull(gs_code) or gs_code= "" then return
//		
//		this.setitem(1, 'mchno', gs_code)
//		this.setitem(1, 'mchnam', gs_codename)
//		this.setitem(1, "sidat" , gs_gubun )
//		this.setitem(1, "seq", gi_page ) 
//		p_inq.triggerevent(clicked!)
//	elseif  rb_2.checked then  //  ������� 
//		gs_code  = this.getitemstring( 1, "mchno" )
//		gs_gubun  = '3'
//	
//		open(w_pdt_06043_pop_up)
//		If IsNull(gs_code)  or gs_code="" Then Return
//		
//		this.setitem(1, 'mchno', gs_code)
//		this.setitem(1, 'mchnam', gs_codename)
//		this.setitem(1, "sidat" , gs_gubun )
//		this.setitem(1, "seq", gi_page )
//		p_inq.triggerevent(clicked!)
//	end if
end if
end event

event itemerror;return 1

end event

type rb_1 from radiobutton within w_pdt_06044
boolean visible = false
integer x = 2158
integer y = 3032
integer width = 553
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "������(�Ƿ�)"
boolean checked = true
end type

event clicked;wf_init()
sle_msg.text = " �Ƿڰǿ� ���� ������� ��ϸ��"
end event

type rb_2 from radiobutton within w_pdt_06044
boolean visible = false
integer x = 3250
integer y = 3032
integer width = 329
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "�������"
end type

event clicked;wf_init()
sle_msg.text = "���� ��� ���� ���"


end event

type rb_3 from radiobutton within w_pdt_06044
boolean visible = false
integer x = 2702
integer y = 3032
integer width = 521
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "������(����)"
end type

event clicked;wf_init()
sle_msg.text = "�Ƿڰ� ���� ���� ��� ��� ���"

end event

type cb_1 from commandbutton within w_pdt_06044
integer x = 2542
integer y = 5000
integer width = 411
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "���������"
end type

type p_1 from uo_picture within w_pdt_06044
integer x = 3355
integer y = 20
integer width = 306
integer taborder = 180
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\���������_up.gif"
end type

event clicked;call super::clicked;If dw_list.RowCount() < 1 Then Return

//If dw_list.GetItemString(dw_list.GetRow(), 'status') <> '3' Then
//	MessageBox('Ȯ��', '�Ϸ�� �ڷḸ ��� �����մϴ�.')
//	Return
//End If

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_codename2)

if dw_insert.accepttext() = -1 then return

gs_gubun 	= trim(dw_insert.getitemstring(1,'mchrsl_sidat'))			// �ǽ�����
gs_code  	= dw_insert.getitemstring(1,'mchrsl_mchno')
gs_codename = trim(dw_insert.getitemstring(1,'mchrsl_susidat'))	// ������������
//gs_codename2= dw_insert.getitemstring(1,'mchrsl_gubun')
gs_codename2= '4'
gi_page		= dw_insert.getitemnumber(1,'mchrsl_seq')

if f_datechk(gs_codename) = -1 then
   MessageBox("�ڷ� Ȯ��", "�����������ڸ� Ȯ���ϼ���!")
	return
end if

if IsNull(gs_code) or gs_code = '' then
   MessageBox("�ڷ� Ȯ��", "�����ڵ带 Ȯ���ϼ���!")
	return
end if

Openwithparm(w_pdt_06100_popup03,'������� ')
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = "C:\erpman\image\���������_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = "C:\erpman\image\���������_dn.gif"
end event

type dw_list from u_d_select_sort within w_pdt_06044
integer x = 41
integer y = 192
integer width = 1618
integer height = 2108
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdt_06044_03_kum"
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;If CurrentRow < 1 Then Return

This.SelectRow(0, FALSE)
This.SetRow(currentrow)	
This.SelectRow(currentrow, TRUE)

String ls_data[]
Long   ll_seq
ls_data[1] = This.GetItemString(currentrow, 'mchrsl_sabu' )  //�����
ls_data[2] = This.GetItemString(currentrow, 'mchrsl_sidat')  //�����Ƿ���
ls_data[3] = This.GetItemString(currentrow, 'mchrsl_gubun')  //�Ƿڱ���
ls_data[4] = This.GetItemString(currentrow, 'mchrsl_mchno')  //�����ȣ
ll_seq     = This.GetItemNumber(currentrow, 'mchrsl_seq'  )  //�Ƿڹ�ȣ

dw_insert.Retrieve(ls_data[1], ls_data[2], ls_data[3], ls_data[4], ll_seq)


end event

event retrieveend;call super::retrieveend;If rowcount < 1 Then Return

Long row
row = This.GetRow()

String ls_data[]
Long   ll_seq
ls_data[1] = This.GetItemString(row, 'mchrsl_sabu' )  //�����
ls_data[2] = This.GetItemString(row, 'mchrsl_sidat')  //�����Ƿ���
ls_data[3] = This.GetItemString(row, 'mchrsl_gubun')  //�Ƿڱ���
ls_data[4] = This.GetItemString(row, 'mchrsl_mchno')  //�����ȣ
ll_seq     = This.GetItemNumber(row, 'mchrsl_seq'  )  //�Ƿڹ�ȣ

If dw_insert.Retrieve(ls_data[1], ls_data[2], ls_data[3], ls_data[4], ll_seq) < 1 Then
	Return -1
Else
	This.SelectRow(0, FALSE)
	This.SetRow(1)	
	This.SelectRow(1, TRUE)
End If
end event

event clicked;//
If row < 1 Then Return

String ls_data[]
Long   ll_seq
ls_data[1] = This.GetItemString(row, 'mchrsl_sabu' )  //�����
ls_data[2] = This.GetItemString(row, 'mchrsl_sidat')  //�����Ƿ���
ls_data[3] = This.GetItemString(row, 'mchrsl_gubun')  //�Ƿڱ���
ls_data[4] = This.GetItemString(row, 'mchrsl_mchno')  //�����ȣ
ll_seq     = This.GetItemNumber(row, 'mchrsl_seq'  )  //�Ƿڹ�ȣ

dw_insert.Retrieve(ls_data[1], ls_data[2], ls_data[3], ls_data[4], ll_seq)


end event

type cbx_1 from checkbox within w_pdt_06044
integer x = 4064
integer y = 1008
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 33027312
boolean enabled = false
string text = "������"
end type

event clicked;wf_init()
end event

type pb_1 from u_pb_cal within w_pdt_06044
integer x = 2510
integer y = 992
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.Setcolumn('mchrsl_redat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'mchrsl_redat', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_06044
integer x = 3685
integer y = 988
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.Setcolumn('mchrsl_comdat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'mchrsl_comdat', gs_code)
end event

type pb_3 from u_pb_cal within w_pdt_06044
integer x = 2510
integer y = 1352
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;int nCnt

select count(*) into :nCnt from reffpf
where rfcod = '4F'
and rfna2 = :gs_empno
and rfgub <> '00';

If cbx_1.Checked = TRUE and nCnt <= 0 Then Return

If cbx_1.Checked = False Then Return

dw_insert.Setcolumn('mchrsl_susidat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'mchrsl_susidat', gs_code)
end event

type pb_4 from u_pb_cal within w_pdt_06044
integer x = 2510
integer y = 1436
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;int nCnt

select count(*) into :nCnt from reffpf
where rfcod = '4F'
and rfna2 = :gs_empno
and rfgub <> '00';

If cbx_1.Checked = TRUE and nCnt <= 0 Then Return

If cbx_1.Checked = False Then Return

dw_insert.Setcolumn('mchrsl_sueddat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'mchrsl_sueddat', gs_code)
end event

type pb_5 from u_pb_cal within w_pdt_06044
integer x = 2510
integer y = 1520
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;int nCnt

select count(*) into :nCnt from reffpf
where rfcod = '4F'
and rfna2 = :gs_empno
and rfgub <> '00';

If cbx_1.Checked = TRUE and nCnt <= 0 Then Return
If cbx_1.Checked = False Then Return

dw_insert.Setcolumn('mchrsl_teeddat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_insert.SetItem(1, 'mchrsl_teeddat', gs_code)
end event

type p_2 from picture within w_pdt_06044
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3077
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
boolean enabled = false
string picturename = "C:\erpman\image\�μ�_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;This.PictureName = 'C:\erpman\image\�μ�_dn.gif'
end event

event ue_lbuttonup;This.PictureName = 'C:\erpman\image\�μ�_up.gif'
end event

event clicked;dw_insert.AcceptText()

Long   row

row = dw_insert.GetRow()
If row < 1 Then Return

String ls_dat
String ls_gub
String ls_mch

Long   ll_seq

ls_dat = dw_insert.GetItemString(row, 'mchrsl_sidat')
If Trim(ls_dat) = '' OR IsNull(ls_dat) Then Return

ls_gub = dw_insert.GetItemString(row, 'mchrsl_gubun')
If Trim(ls_gub) = '' OR IsNull(ls_gub) Then Return

ls_mch = dw_insert.GetItemString(row, 'mchrsl_mchno')
If Trim(ls_mch) = '' OR IsNull(ls_mch) Then Return

ll_seq = dw_insert.GetItemNumber(row, 'mchrsl_seq')
If ll_seq < 1 OR IsNull(ll_seq) Then Return

dw_2.SetRedraw(False)
dw_2.Retrieve(gs_sabu, ls_dat, ls_gub, ls_mch, ll_seq)
dw_2.SetRedraw(True)

If dw_2.RowCount() < 1 Then 
	MessageBox('Ȯ��', '�μ��� ������ �����ϴ�.')
	Return
End If

String ls_jpno

ls_jpno = dw_insert.GetItemString(row, 'mchrsl_iojpno')

wf_item(ls_jpno + '%')

OpenWithParm(w_print_preview, dw_2)
end event

type dw_2 from datawindow within w_pdt_06044
integer x = 686
integer y = 2360
integer width = 274
integer height = 216
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_06043_03_con"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type rr_1 from roundrectangle within w_pdt_06044
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 27
integer y = 180
integer width = 1650
integer height = 2136
integer cornerheight = 40
integer cornerwidth = 55
end type

