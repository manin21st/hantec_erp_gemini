$PBExportHeader$w_sm10_0030_ckd.srw
$PBExportComments$CKD VAN����(HKMC, MOBIS, GLOBIS, WIA)
forward
global type w_sm10_0030_ckd from w_inherite
end type
type cb_1 from commandbutton within w_sm10_0030_ckd
end type
type cb_2 from commandbutton within w_sm10_0030_ckd
end type
type cb_3 from commandbutton within w_sm10_0030_ckd
end type
type cb_4 from commandbutton within w_sm10_0030_ckd
end type
type cb_5 from commandbutton within w_sm10_0030_ckd
end type
type cb_6 from commandbutton within w_sm10_0030_ckd
end type
type dw_list from datawindow within w_sm10_0030_ckd
end type
type st_state from statictext within w_sm10_0030_ckd
end type
end forward

global type w_sm10_0030_ckd from w_inherite
integer width = 5829
integer height = 3044
string title = "CKD VAN����"
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
cb_6 cb_6
dw_list dw_list
st_state st_state
end type
global w_sm10_0030_ckd w_sm10_0030_ckd

type variables
String is_custid
Long il_err , il_succeed

end variables

forward prototypes
public function integer wf_van_d68 (string arg_file_name, string arg_sabu)
public function double wf_van_scan_chk2 (string arg_gubun, string arg_value, string arg_value_1)
public function long wf_error (string as_gubun, long al_line, string as_doccode, string as_factory, string as_itnbr, string as_errtext)
public function integer wf_file_copy (string arg_file)
end prototypes

public function integer wf_van_d68 (string arg_file_name, string arg_sabu);/* ����ȯ ����
	{:+0  	}:-0
	A:1  B:2  C:3  D:4  E:5  F:6  G:7  H:8  I:9
	J:-1 K:-2 L:-3 M:-4 N:-5 O:-6 P:-7 Q:-8 R:-9 
	
  [return �� ����]
   
   -1 : txt ȭ���� �������� �ʽ��ϴ�.
	-2 : ȭ�ϸ��� ���� ȭ�ϳ����� ���� ���� ����
   -3 : �̹� ������ �ڷ�
	-4 : ���� ����/���� ����
    1�̻� : ���������� ���� �Ϸ�  �Ǵ� ����Ÿ �Ǽ� */	

string ls_Input_Data ,ls_indate
integer li_FileNum,li_cnt,li_rowcnt
Long ll_data = 0 
string ls_DOCCODE,ls_CUSTCD,ls_FACTORY,ls_ITNBR,ls_ORDER_GB,ls_ORDERNO,ls_ORDER_DATE,ls_ORDER_TYPE
string ls_CRT_DATE,ls_CRT_TIME,ls_CRT_USER,ls_FORM_ORDERNO,ls_COUNTRY_CARKIND
string ls_TO_ORDERNO,ls_LOCNO_CKD,ls_YARDNO_CKD,ls_PACKCON_CKD,ls_MITNBR,ls_MCVCOD,ls_MDCVCOD
long  ll_ORDER_TIME,ll_ORDER_MIN,ll_seqno ,ll_check
double  ld_ORDER_QTY,ld_IPDAN,ld_PACKUNI
string ls_CITNBR ,ls_gubun
Long ll_cnt

//���� ����,�ð� 
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')

Long ll_p , ll_px
ll_p = LastPos(arg_file_name , '\')
ll_px = LastPos(Upper(arg_file_name) , '.TXT')
ls_gubun = Upper(Mid(arg_file_name , ll_p + 1 , ll_px - ( ll_p + 1 ) ))
li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,"["+arg_file_name+"]"+" VAN�ڷᰡ �����ϴ�.!!")
	return -1
end if

li_cnt = 0

st_state.Visible = True
st_state.Text = '����Ÿ�� �д� ���Դϴ�...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	Setnull(ls_citnbr)
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	li_cnt ++
	
	yield()
	st_state.Text = "���ϸ�: "+Right(arg_file_name,9) +"  ���μ� :" +String(li_cnt)
	
	ls_doccode = trim(mid(ls_Input_Data,1,12))	
	ls_indate = Trim(dw_input.Object.d_crt[1])
//	// ���� ��¥ üũ
//	if ls_indate <> Mid(ls_doccode,3,8) then
//		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "������ �������ڿ� ������ڰ� �����մϴ�.")
//		Continue ;
//	end if	
	if ls_indate <> Mid(ls_doccode,3,8) then
		ls_indate = Mid(ls_doccode,3,8)
	end if
	
	// ȭ�ϸ��� ���� �ʵ尪�� üũ
	if upper(left(right(arg_file_name,6),2)) <> upper(left(ls_doccode,2)) then
		rollback;
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,"ȭ�ϸ�� ȭ���� �ʵ尪�� Ʋ���ϴ�.")
		FileClose(li_FileNum)
		return -2
	end if

	ls_custcd = trim(mid(ls_Input_Data,13,4))
	ls_factory = trim(mid(ls_Input_Data,17,2))
	ls_itnbr = trim(mid(ls_Input_Data,19,15))
	ls_order_gb = trim(mid(ls_Input_Data,34,1))
	ls_orderno =  trim(mid(ls_Input_Data,35,11))
	ld_order_qty = wf_van_scan_chk2('1',mid(ls_Input_Data,46,6),mid(ls_Input_Data,52,1))
	ld_ipdan = wf_van_scan_chk2('2',mid(ls_Input_Data,53,8),mid(ls_Input_Data,61,2))
	ls_order_date = trim(mid(ls_Input_Data,63,8))
	ls_order_type = trim(mid(ls_Input_Data,71,1))
	ll_order_time = long(mid(ls_Input_Data,72,2))
	ll_order_min = long(mid(ls_Input_Data,74,2))
	ld_packuni = wf_van_scan_chk2('1',mid(ls_Input_Data,76,5),mid(ls_Input_Data,81,1))
	ls_form_orderno = trim(mid(ls_Input_Data,82,15))
	ls_country_carkind = trim(mid(ls_Input_Data,97,5))
	ls_to_orderno = trim(mid(ls_Input_Data,102,15))
	ls_locno_ckd = trim(mid(ls_Input_Data,117,10))
	ls_yardno_ckd = trim(mid(ls_Input_Data,127,4))
	ls_packcon_ckd = trim(mid(ls_Input_Data,131,3))	
	
	//��üǰ�� �о����(��ü�ŷ�ó�ڵ�)
//	select itnbr
//	into :ls_mitnbr
//	from itemas
//	where replace(itnbr,'-','') = :ls_itnbr ;
//	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then

	ls_mitnbr = sqlca.fun_get_buitnbr(ls_itnbr , '') ;	
	if trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then		
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'ǰ������Ÿ�� ǰ���� ��ϵ��� �ʾҽ��ϴ�.')		
		Continue ;
	End IF
	
	//���庰 �ŷ�ó �о����
   select fun_get_scvcod( :ls_factory , :ls_mitnbr ,:ls_packcon_ckd  ),
			 nvl(RFNA3,'')
	  Into :ls_mcvcod , :ls_mdcvcod
	  from reffpf 
	where sabu = :arg_sabu and
			rfcod = '2A' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'�������̺�(REFFPF) ��ǰ����-�ŷ�ó �ڵ尡 �����ϴ�.')
		il_err++
		Continue ;
	end if
	
	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)

	// D68 ���� �ߺ� ��ŵ
	If Right(ls_gubun,2) = 'D6' Then		
		ll_check = 0 
		
		Select Count(*) Into :ll_check
		  From van_hkcd68
		 Where sabu = :gs_sabu
		   and custcd = :ls_CUSTCD
			and itnbr = :ls_itnbr 
			and factory = :ls_factory
			and order_qty = :ld_ORDER_QTY
			and orderno = :ls_orderno ;			
		If ll_check > 0 Then Continue;			
	End if	
	
	// D68 ���� �԰� �����ڰ� E �� ������ȣ�� ������(15�� �̻����ϰ� �̳�ó���� ����)�� �����ؾ��Ѵ�.(���߹���)
	If Right(ls_gubun,2) = 'D8' and ls_ORDER_GB = 'E' Then		
		ll_check = 0 
		
		Select Count(*) Into :ll_check
		  From van_hkcd68
		 Where sabu = :gs_sabu
		   and custcd = :ls_CUSTCD
			and itnbr = :ls_itnbr 
			and factory = :ls_factory
			and orderno = :ls_orderno ;

		//D6�� citnbr�� ����äũ �ȵǴ°� ����. 2005.04.12. �̼�ö		
		If ll_check > 0 Then			
			Update van_hkcd68 Set citnbr = '2' 
			                Where sabu = :gs_sabu
									and custcd = :ls_CUSTCD
									and itnbr = :ls_itnbr 
									and factory = :ls_factory
									and orderno = :ls_orderno ;
			
			if sqlca.sqlcode <> 0 then		
				st_state.Visible = False
				wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" �Է¿����� �߻��߽��ϴ�." + '[����ġ:'+string(li_cnt)+']')
				rollback;
				FileClose(li_FileNum)
				return 0
			end if			
		End if

		//���ϵ�Ͻ� List �Ⱥ��̵��� ����. 2005.04.12. �̼�ö
		DELETE FROM SM04_DAILY_ITEM WHERE YYMMDD = :ls_crt_date AND BALJU_NO = :ls_orderno ;		
		ls_citnbr = '2'		
	End If
	//===================================================================================================	
	// ���� ��û //////////////////////////////////////////////////////
   ll_cnt = 0 
	select count(*) Into :ll_cnt
	  from van_hkcd68
	 where SABU=   :gs_SABU
		and DOCCODE = :ls_DOCCODE   
		and CUSTCD = :ls_CUSTCD  
		and FACTORY = :ls_FACTORY 
		and ITNBR = :ls_ITNBR 
		and ORDERNO = :ls_ORDERNO ;
		
	If ll_cnt > 0 Then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr," �̹� �Էµ� ����Ÿ�Դϴ�.(�������..)" + '[����ġ:'+string(li_cnt)+']')
		Continue ;
	end if	
/////////////////////////////////////////////////////////	
	ll_data++
	insert into van_hkcd68(SABU,DOCCODE,CUSTCD,FACTORY,ITNBR,ORDER_GB,ORDERNO,ORDER_QTY,IPDAN,ORDER_DATE,ORDER_TYPE,     
								ORDER_TIME,ORDER_MIN,PACKUNI,FORM_ORDERNO,COUNTRY_CARKIND,TO_ORDERNO,LOCNO_CKD,YARDNO_CKD,
								PACKCON_CKD,CRT_DATE,CRT_TIME,CRT_USER,MITNBR,MCVCOD,MDCVCOD,CITNBR,SEQNO,
								BALYN, ORDER_DATE_HANTEC)       
					values(:arg_SABU,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_ITNBR,:ls_ORDER_GB,:ls_ORDERNO,:ld_ORDER_QTY,:ld_IPDAN,:ls_ORDER_DATE,:ls_ORDER_TYPE,
						:ll_ORDER_TIME,:ll_ORDER_MIN,:ld_PACKUNI,:ls_FORM_ORDERNO,:ls_COUNTRY_CARKIND,:ls_TO_ORDERNO,:ls_LOCNO_CKD,:ls_YARDNO_CKD,
						:ls_PACKCON_CKD,:ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,:ls_MITNBR,:ls_MCVCOD,:ls_MDCVCOD,:ls_CITNBR,:ll_seqno,
						NULL, NULL);
						/*NULL, DECODE(:ls_factory, 'Y', :ls_order_date, NULL) ������ �������� ����� ����NULL);*/
	if sqlca.sqlcode <> 0 then
		
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" �Է¿����� �߻��߽��ϴ�." + '[����ġ:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		return 0
	end if
	il_succeed++ 
Loop

// van file close
FileClose(li_FileNum)

commit;

wf_file_copy(arg_file_name)

st_state.Visible = False
return li_cnt
end function

public function double wf_van_scan_chk2 (string arg_gubun, string arg_value, string arg_value_1);//������
long ll_asc_value
double ld_return_value
if arg_gubun = '1' then
	ll_asc_value = asc(arg_value_1)
	// 'A' ~ 'I'
	if ll_asc_value >= 64 and ll_asc_value <= 73 then
		ld_return_value = double(arg_value) * 10 + ll_asc_value - 64
	// 'J' ~ 'R'
	elseif ll_asc_value >= 74 and ll_asc_value <= 82 then
		ld_return_value = (double(arg_value) * 10 + ll_asc_value - 73) * -1
	// '{'
	elseif ll_asc_value = 123 then
		ld_return_value = double(arg_value) * 10
	// '}'
	elseif ll_asc_value = 125 then
		ld_return_value = double(arg_value) * -10
	else
		ld_return_value = double(arg_value) * 10 + double(arg_value_1)
	end if
//�Ǽ���
else 
	ll_asc_value = asc(right(arg_value_1,1))
	// 'A' ~ 'I'
	if ll_asc_value >= 64 and ll_asc_value <= 73 then
		ld_return_value = double(arg_value) + &
								(double(left(arg_value_1,1)) * 0.1) + &
								((ll_asc_value - 64) * 0.01)
	// 'J' ~ 'R'
	elseif ll_asc_value >= 74 and ll_asc_value <= 82 then
		ld_return_value = (double(arg_value) + &
								(double(left(arg_value_1,1)) * 0.1) + &
								((ll_asc_value - 73) * 0.01)) * -1
	// '{'
	elseif ll_asc_value = 123 then
		ld_return_value = (double(arg_value) + &
								(double(left(arg_value_1,1)) * 0.1)) * 1 &
	// '}'
	elseif ll_asc_value = 125 then
		ld_return_value = (double(arg_value) + &
								(double(left(arg_value_1,1)) * 0.1)) * -1  
	else
		ld_return_value = double(arg_value) + (double(arg_value) * 0.01)
	end if
	
end if
	
return ld_return_value
end function

public function long wf_error (string as_gubun, long al_line, string as_doccode, string as_factory, string as_itnbr, string as_errtext);If dw_list.Visible = False Then
	dw_list.Visible = True
End If

Long ll_r

ll_r = dw_list.InsertRow(0)

dw_list.Object.saupj[ll_r] = gs_saupj
dw_list.Object.err_date[ll_r] = Trim(dw_input.Object.d_crt[1])
dw_list.Object.err_time[ll_r] = f_totime()
dw_list.Object.doctxt[ll_r] = as_gubun
dw_list.Object.err_line[ll_r] = al_line
dw_list.Object.doccode[ll_r] = as_doccode
dw_list.Object.factory[ll_r] = as_factory
dw_list.Object.itnbr[ll_r] = as_itnbr
dw_list.Object.err_txt[ll_r] = as_errtext

dw_list.scrolltorow(ll_r)

Return ll_r
end function

public function integer wf_file_copy (string arg_file);Long ll_p , ll_px ,ll_s
String ls_dir , ls_file ,ls_nfile  , ls_totime

ll_p = LastPos(arg_file , '\')
ls_dir = Upper(Left(arg_file , ll_p ))

ls_dir = ls_dir+'\'+is_today

If DirectoryExists ( ls_dir ) = false Then
	If CreateDirectory ( ls_dir ) < 1 Then
		MessageBox('Ȯ��','���Ϲ�� ����1')
		Return -1
	end if
end if

select to_char(sysdate,'yyyymmddhh24miss') into :ls_totime from dual ;

ll_px = LastPos(Upper(arg_file) , '.TXT')
ls_file = Upper(Mid(arg_file , ll_p + 1 , ll_px - ( ll_p + 1 ) )) + '_'+ls_totime+'.TXT'

ls_nfile = ls_dir+"\"+ls_file

If FileCopy(arg_file,ls_nfile ,false) < 1 Then
	MessageBox('Ȯ��','���Ϲ�� ����2')
	Return -1
End if

return 1
end function

on w_sm10_0030_ckd.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_6=create cb_6
this.dw_list=create dw_list
this.st_state=create st_state
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cb_4
this.Control[iCurrent+5]=this.cb_5
this.Control[iCurrent+6]=this.cb_6
this.Control[iCurrent+7]=this.dw_list
this.Control[iCurrent+8]=this.st_state
end on

on w_sm10_0030_ckd.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.dw_list)
destroy(this.st_state)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_input.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_input.InsertRow(0)

dw_input.SetItem(1, 'd_st', String(RelativeDate(TODAY(), -30), 'yyyymmdd'))
dw_input.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event resize;r_detail.width = this.width - 60
r_detail.height = this.height - r_detail.y - 65
dw_insert.width = this.width - 70
dw_insert.height = this.height - dw_insert.y - 70

st_state.x = (this.width - st_state.width) / 2
st_state.y = (this.height - st_state.height) / 2
end event

event activate;gw_window = this

if gs_lang = "CH" then   //// �߹��� ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// ��ȸ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("��ʥ(&A)", false) //// �߰�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?�(&D)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?��(&S)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("���(&Z)", true) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("���(&C)", false) //// �ű�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&T)", true) //// ã��
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&F)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("Excel??(&E)", false) //// �����ٿ�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?��(&P)", false) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", false) //// �̸����� 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?�?(&G)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)  //// PDF��ȯ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", true) //// ����
else
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("��ȸ") + "(&Q)", true) //// ��ȸ
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�߰�") + "(&A)", false) //// �߰�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&D)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&S)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&Z)", true) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�ű�") + "(&C)", false) //// �ű�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("ã��") + "(&T)", true) //// ã��
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&F)",	 true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("������ȯ") + "(&E)", false) //// �����ٿ�
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("���") + "(&P)", false) //// ���
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("�̸�����") + "(&R)", false) //// �̸�����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&G)", true) //// ����
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("����") + "(&C)", true)
end if

//// ����Ű Ȱ��ȭ ó��
m_main2.m_window.m_inq.enabled = true //// ��ȸ
m_main2.m_window.m_add.enabled = false //// �߰�
m_main2.m_window.m_del.enabled = true  //// ����
m_main2.m_window.m_save.enabled = true //// ����
m_main2.m_window.m_cancel.enabled = true //// ���
m_main2.m_window.m_new.enabled = false //// �ű�
m_main2.m_window.m_find.enabled = true  //// ã��
m_main2.m_window.m_filter.enabled = true //// ����
m_main2.m_window.m_excel.enabled = false //// �����ٿ�
m_main2.m_window.m_print.enabled = false  //// ���
m_main2.m_window.m_preview.enabled = false //// �̸�����

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0030_ckd
end type

type sle_msg from w_inherite`sle_msg within w_sm10_0030_ckd
end type

type dw_datetime from w_inherite`dw_datetime within w_sm10_0030_ckd
end type

type st_1 from w_inherite`st_1 within w_sm10_0030_ckd
integer y = 3400
end type

type p_search from w_inherite`p_search within w_sm10_0030_ckd
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0030_ckd
end type

type p_delrow from w_inherite`p_delrow within w_sm10_0030_ckd
end type

type p_mod from w_inherite`p_mod within w_sm10_0030_ckd
integer y = 3200
end type

type p_del from w_inherite`p_del within w_sm10_0030_ckd
integer y = 3200
end type

type p_inq from w_inherite`p_inq within w_sm10_0030_ckd
integer y = 3200
end type

event p_inq::clicked;call super::clicked;dw_input.AcceptText()

Integer row
row = dw_input.GetRow()
If row < 1 Then Return

String  ls_st
ls_st = dw_input.GetItemString(row, 'd_st')

String  ls_ed
ls_ed = dw_input.GetItemString(row, 'd_ed')

String  ls_fac
ls_fac = dw_input.GetItemString(row, 'factory')

String  ls_sitn
ls_sitn = dw_input.GetItemString(row, 'stit')

String  ls_eitn
ls_eitn = dw_input.GetItemString(row, 'edit')

If Trim(ls_st) = '' OR IsNull(ls_st) Then ls_st = '19000101'
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then ls_ed = '21001231'
If Trim(ls_sitn) = '' OR IsNull(ls_sitn) Then ls_sitn = '.'
If Trim(ls_eitn) = '' OR IsNull(ls_eitn) Then ls_eitn = 'ZZZZZZZZZZZZZZ'

If Trim(ls_fac) = '' OR IsNull(ls_fac) Then ls_fac = '%'

If dw_input.GetItemString(row, 'ckdgbn') = 'M' Then
	ls_fac = 'M1'
ElseIf dw_input.GetItemString(row, 'ckdgbn') = 'W' Then
	ls_fac = 'WP'
End If

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_st, ls_ed, ls_fac, ls_sitn, ls_eitn)
dw_insert.SetRedraw(True)

end event

type p_print from w_inherite`p_print within w_sm10_0030_ckd
integer y = 3200
end type

type p_can from w_inherite`p_can within w_sm10_0030_ckd
integer y = 3200
end type

event p_can::clicked;call super::clicked;dw_insert.ReSet()
end event

type p_exit from w_inherite`p_exit within w_sm10_0030_ckd
integer y = 3200
end type

type p_ins from w_inherite`p_ins within w_sm10_0030_ckd
integer y = 3200
end type

type p_new from w_inherite`p_new within w_sm10_0030_ckd
integer y = 3200
end type

type dw_input from w_inherite`dw_input within w_sm10_0030_ckd
integer x = 32
integer y = 52
integer width = 3017
integer height = 224
integer taborder = 50
string title = "none"
string dataobject = "d_sm10_0030_ckd_ret"
end type

event itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'stit'
		If Trim(This.GetItemString(row, 'edit')) = '' OR IsNull(This.GetItemString(row, 'edit')) Then
			This.SetItem(row, 'edit', data)
		End If
		
	Case 'd_st'
		If Trim(This.GetItemString(row, 'd_ed')) = '' OR IsNull(This.GetItemString(row, 'd_ed')) Then
			This.SetItem(row, 'd_ed', data)
		End If
		
	Case 'ckdgbn'
		Choose Case data
			Case 'H' //������
				dw_insert.DataObject = 'd_sm10_0030_ckd_hkmc'
			Case 'M' //���
				dw_insert.DataObject = 'd_sm10_0030_ckd_mobis'
			Case 'G' //�۷κ�
				dw_insert.DataObject = 'd_sm10_0030_ckd_globis'
			Case 'W' //����
				dw_insert.DataObject = 'd_sm10_0030_ckd_wia'
			Case 'P' //�Ŀ���
				dw_insert.DataObject = 'd_sm10_0030_ckd_ptc'
		End Choose
		
		dw_insert.SetTransObject(SQLCA)

End Choose
end event

type cb_delrow from w_inherite`cb_delrow within w_sm10_0030_ckd
boolean visible = false
integer y = 3400
end type

type cb_addrow from w_inherite`cb_addrow within w_sm10_0030_ckd
boolean visible = false
integer y = 3400
end type

type dw_insert from w_inherite`dw_insert within w_sm10_0030_ckd
integer x = 37
integer y = 312
integer width = 3489
integer height = 1964
string dataobject = "d_sm10_0030_ckd_hkmc"
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0030_ckd
boolean visible = false
integer y = 3400
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0030_ckd
boolean visible = false
integer y = 3400
end type

type cb_del from w_inherite`cb_del within w_sm10_0030_ckd
boolean visible = false
integer y = 3400
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0030_ckd
boolean visible = false
integer y = 3400
end type

type cb_print from w_inherite`cb_print within w_sm10_0030_ckd
boolean visible = false
integer y = 3400
end type

type cb_can from w_inherite`cb_can within w_sm10_0030_ckd
boolean visible = false
integer y = 3400
end type

type cb_search from w_inherite`cb_search within w_sm10_0030_ckd
boolean visible = false
integer y = 3400
end type

type gb_10 from w_inherite`gb_10 within w_sm10_0030_ckd
end type

type gb_button1 from w_inherite`gb_button1 within w_sm10_0030_ckd
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0030_ckd
end type

type r_head from w_inherite`r_head within w_sm10_0030_ckd
boolean visible = false
integer y = 2460
end type

type r_detail from w_inherite`r_detail within w_sm10_0030_ckd
integer y = 308
end type

type cb_1 from commandbutton within w_sm10_0030_ckd
boolean visible = false
integer x = 4155
integer y = 312
integer width = 402
integer height = 116
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "HKMC"
end type

event clicked;Integer li_value
String  ls_path
String  ls_file
li_value = GetFileOpenName("HKMC CKD ��������", ls_path, ls_file, "XLS", "XLS Files (*.XLS),*.XLS, XLSX Files (*.XLSX), *.XLSX,")
Choose Case li_value
	Case 0
		Return
	Case -1
		MessageBox('Ȯ��', '���� ���ÿ� ���� �߽��ϴ�.')
		Return
	Case 1
		If FileExists(ls_path) = False Then
			MessageBox('Ȯ��', ls_path + ' ������ �������� �ʽ��ϴ�.')
			Return
		End If
End Choose

uo_xlobject uo_xl
uo_xl = Create uo_xlobject
uo_xl.uf_excel_connect(ls_path, False, 3)
uo_xl.uf_selectsheet(1)
uo_xl.uf_set_format(1, 1, '@' + space(30))

//Data ���� Row Setting
Integer li_xlrow
li_xlrow = 1

Integer li_ins
Integer li_cnt  ; li_cnt  = 0
Integer li_jpno ; li_jpno = 0
Integer i
Integer li_dup
String  ls_sabu
String  ls_doccode
String  ls_pdno
String  ls_sang_cd
String  ls_plant
String  ls_jajeug
String  ls_jajeno
String  ls_custcd
String  ls_palnt_im
String  ls_unmsr
String  ls_calc_qty
String  ls_plan_dqty
String  ls_podate
String  ls_napdate
String  ls_pojangg
String  ls_salegbn
String  ls_saledoc
String  ls_sditno
String  ls_pobatch
String  ls_saledof
String  ls_saledot
String  ls_nadil_cd
String  ls_model_cd
String  ls_case_typ
String  ls_case_no
String  ls_relation
String  ls_jugpo_qty
String  ls_sourgbn
String  ls_sagbn
String  ls_jikgbn
String  ls_ipgo_user
String  ls_bunhal_nap
String  ls_cur_stock
String  ls_prev_result
String  ls_pojan_qty
String  ls_balju_yn
String  ls_gumeno
String  ls_guitno
String  ls_gujb_date
String  ls_mtext
String  ls_jajegbn
String  ls_ctcod
String  ls_pojaline
String  ls_ipqty
String  ls_crt_date
String  ls_crt_time
String  ls_crt_user
String  ls_citnbr
String  ls_mitnbr
String  ls_mcvcod
String  ls_mdcvcod
String  ls_baljpno
String  ls_balseq

Do While(True)
	//Data�� ������쿣 Return...........
	If IsNull(uo_xl.uf_gettext(li_xlrow, 1)) Or Trim(uo_xl.uf_gettext(li_xlrow, 1)) = '' Then Exit //������ȣ
	
//	li_ins = dw_insert.InsertRow(0) 
	li_cnt++
	li_jpno++
	
	For i = 1 To 15
		uo_xl.uf_set_format(li_xlrow, i, '@' + space(30))
	Next
	
	ls_sabu        = gs_sabu
	ls_doccode     = Trim(uo_xl.uf_GetText(li_xlrow, 1) )  //�����ڵ�
	ls_pdno        = Trim(uo_xl.uf_GetText(li_xlrow, 2) )  //PD ��ȣ
	ls_sang_cd     = Trim(uo_xl.uf_GetText(li_xlrow, 3) )
	ls_plant       = Trim(uo_xl.uf_GetText(li_xlrow, 4) )  //��ġ��(����)
	ls_jajeug      = Trim(uo_xl.uf_GetText(li_xlrow, 5) )
	ls_jajeno      = Trim(uo_xl.uf_GetText(li_xlrow, 6) )  //ǰ��(������ x)
	ls_custcd      = Trim(uo_xl.uf_GetText(li_xlrow, 7) )  //��ü�ڵ�
	ls_palnt_im    = Trim(uo_xl.uf_GetText(li_xlrow, 8) )
	ls_unmsr       = Trim(uo_xl.uf_GetText(li_xlrow, 9) )  //����
	ls_calc_qty    = Trim(uo_xl.uf_GetText(li_xlrow, 11))  //�̳�����
	ls_plan_dqty   = Trim(uo_xl.uf_GetText(li_xlrow, 10))  //���ּ���
	ls_podate      = Trim(uo_xl.uf_GetText(li_xlrow, 12))
	ls_napdate     = Trim(uo_xl.uf_GetText(li_xlrow, 13))  //��������
	ls_pojangg     = Trim(uo_xl.uf_GetText(li_xlrow, 14))
	ls_salegbn     = Trim(uo_xl.uf_GetText(li_xlrow, 15))
	ls_saledoc     = Trim(uo_xl.uf_GetText(li_xlrow, 16))
	ls_sditno      = Trim(uo_xl.uf_GetText(li_xlrow, 17))
	ls_pobatch     = Trim(uo_xl.uf_GetText(li_xlrow, 18))
	ls_saledof     = Trim(uo_xl.uf_GetText(li_xlrow, 19))  //������ȣ
	ls_saledot     = Trim(uo_xl.uf_GetText(li_xlrow, 20))  //���ֹ�ȣ
	ls_nadil_cd    = Trim(uo_xl.uf_GetText(li_xlrow, 21))
	ls_model_cd    = Trim(uo_xl.uf_GetText(li_xlrow, 22))
	ls_case_typ    = Trim(uo_xl.uf_GetText(li_xlrow, 23))
	ls_case_no     = Trim(uo_xl.uf_GetText(li_xlrow, 24))
	ls_relation    = Trim(uo_xl.uf_GetText(li_xlrow, 25))
	ls_jugpo_qty   = Trim(uo_xl.uf_GetText(li_xlrow, 26))
	ls_sourgbn     = Trim(uo_xl.uf_GetText(li_xlrow, 27))
	ls_sagbn       = Trim(uo_xl.uf_GetText(li_xlrow, 28))
	ls_jikgbn      = Trim(uo_xl.uf_GetText(li_xlrow, 29))
	ls_ipgo_user   = Trim(uo_xl.uf_GetText(li_xlrow, 30))
	ls_bunhal_nap  = Trim(uo_xl.uf_GetText(li_xlrow, 31))
	ls_cur_stock   = Trim(uo_xl.uf_GetText(li_xlrow, 32))
	ls_prev_result = Trim(uo_xl.uf_GetText(li_xlrow, 33))
	ls_pojan_qty   = Trim(uo_xl.uf_GetText(li_xlrow, 34))
	ls_balju_yn    = Trim(uo_xl.uf_GetText(li_xlrow, 35))
	ls_gumeno      = Trim(uo_xl.uf_GetText(li_xlrow, 36))
	ls_guitno      = Trim(uo_xl.uf_GetText(li_xlrow, 37))
	ls_gujb_date   = Trim(uo_xl.uf_GetText(li_xlrow, 38))
	ls_mtext       = Trim(uo_xl.uf_GetText(li_xlrow, 39))
	ls_jajegbn     = Trim(uo_xl.uf_GetText(li_xlrow, 40))
	ls_ctcod       = Trim(uo_xl.uf_GetText(li_xlrow, 41))
	ls_pojaline    = Trim(uo_xl.uf_GetText(li_xlrow, 42))
	ls_ipqty       = Trim(uo_xl.uf_GetText(li_xlrow, 43))
	ls_crt_date    = String(TODAY(), 'yyyymmdd')
	ls_crt_time    = String(TODAY(), 'hhmm'    )
	ls_crt_user    = gs_userid
	ls_citnbr      = ''
	ls_baljpno     = ''
	ls_balseq      = ''
	
	//���庰 �ŷ�ó �о����
	SELECT NVL(DECODE(:ls_custcd, 'U904', SUBSTR(TRIM(RFNA2), 1, 6), SUBSTR(TRIM(RFNA2), -6, 6)), '') AS CVCOD, NVL(RFNA3, '') AS CVTYP
	  INTO :ls_mcvcod, :ls_mdcvcod
	  FROM REFFPF
	 WHERE SABU  = :gs_sabu
		AND RFCOD = '2A'
		AND RFGUB = :ls_plant ;
	If SQLCA.SQLCODE <> 0 OR Trim(ls_mcvcod) = '' OR Trim(ls_mdcvcod) = '' OR IsNull(ls_mcvcod) OR IsNull(ls_mdcvcod) Then
		wf_error('HKMC', li_xlrow, ls_doccode, ls_plant, ls_mitnbr, '�������̺�(REFFPF) ��ǰ����-�ŷ�ó �ڵ尡 �����ϴ�.')
		Continue ;
//		MessageBox('���庰 �ŷ�ó Ȯ��', '[' + ls_plant + '] ������ �ŷ�ó�ڵ� ������ �����ϴ�.')
////		uo_xl.Application.Quit
//		uo_xl.uf_excel_Disconnect()
//		Destroy uo_xl
//		Return -1
	End If
	
	//��üǰ�� �о����(��ü�ŷ�ó�ڵ�)
	SELECT ITNBR
	  INTO :ls_mitnbr
	  FROM ITEMAS
	 WHERE REPLACE(ITNBR, '-', '') = :ls_jajeno
	   AND USEYN = '0' ;
	If SQLCA.SQLCODE <> 0 OR Trim(ls_mitnbr) = '' OR IsNull(ls_mitnbr) Then	
		wf_error('HKMC', li_xlrow, ls_doccode, ls_plant, ls_mitnbr, 'ǰ������Ÿ�� ǰ���� ��ϵ��� �ʾҽ��ϴ�.')		
		Continue ;
//		MessageBox('�ڻ�ǰ�� Ȯ��', '[' + ls_jajeno + '] ǰ���� �ڻ� ǰ���� �ƴմϴ�.')
////		uo_xl.Application.Quit
//		uo_xl.uf_excel_Disconnect()
//		Destroy uo_xl
//		Return -1
	End If
	
	/* �ߺ�Ȯ�� */
	SELECT COUNT('X')
	  INTO :li_dup
	  FROM VAN_CKDD2
	 WHERE SABU = :ls_sabu AND DOCCODE = :ls_doccode AND PDNO = :ls_pdno AND CUSTCD = :ls_custcd ;
	If li_dup < 1 Then	
		INSERT INTO VAN_CKDD2 (
		SABU		,	DOCCODE		,	PDNO			,	SANG_CD		,	PLANT			,	JAJEUG		,
		JAJENO	,	CUSTCD		,	PALNT_IM		,	UNMSR			,	CALC_QTY		,	PLAN_DQTY	,
		PODATE	,	NAPDATE		,	POJANGG		,	SALEGBN		,	SALEDOC		,	SDITNO		,
		POBATCH	,	SALEDOF		,	SALEDOT		,	NADIL_CD		,	MODEL_CD		,	CASE_TYP		,
		CASE_NO	,	RELATION		,	JUGPO_QTY	,	SOURGBN		,	SAGBN			,	JIKGBN		,
		IPGO_USER,	BUNHAL_NAP	,	CUR_STOCK	,	PREV_RESULT	,	POJAN_QTY	,	BALJU_YN		,
		GUMENO	,	GUITNO		,	GUJB_DATE	,	MTEXT			,	JAJEGBN		,	CTCOD			,
		POJALINE	,	IPQTY			,	CRT_DATE		,	CRT_TIME		,	CRT_USER		,	CITNBR		,
		MITNBR	,	MCVCOD		,	MDCVCOD		)
		VALUES (
		:ls_sabu			,	:ls_doccode		,	:ls_pdno			,	:ls_sang_cd		,	:ls_plant		,	:ls_jajeug		,
		:ls_jajeno		,	:ls_custcd		,	:ls_palnt_im	,	:ls_unmsr		,	:ls_calc_qty	,	:ls_plan_dqty	,
		:ls_podate		,	:ls_napdate		,	:ls_pojangg		,	:ls_salegbn		,	:ls_saledoc		,	:ls_sditno		,
		:ls_pobatch		,	:ls_saledof		,	:ls_saledot		,	:ls_nadil_cd	,	:ls_model_cd	,	:ls_case_typ	,
		:ls_case_no		,	:ls_relation	,	:ls_jugpo_qty	,	:ls_sourgbn		,	:ls_sagbn		,	:ls_jikgbn		,
		:ls_ipgo_user	,	:ls_bunhal_nap	,	:ls_cur_stock	,	:ls_prev_result,	:ls_pojan_qty	,	:ls_balju_yn	,
		:ls_gumeno		,	:ls_guitno		,	:ls_gujb_date	,	:ls_mtext		,	:ls_jajegbn		,	:ls_ctcod		,
		:ls_pojaline	,	:ls_ipqty		,	:ls_crt_date	,	:ls_crt_time	,	:ls_crt_user	,	:ls_citnbr		,
		:ls_mitnbr		,	:ls_mcvcod		,	:ls_mdcvcod 	)	;
		If SQLCA.SQLCODE <> 0 Then
			ROLLBACK USING SQLCA;
	//		uo_xl.Application.Quit
			uo_xl.uf_excel_Disconnect()
			Destroy uo_xl
			MessageBox('Ȯ��', '�ڷ� �Է� �� ������ �߻� �߽��ϴ�.')
			Return
		End If
	Else
		wf_error('HKMC', li_xlrow, ls_doccode, ls_plant, ls_mitnbr, " �̹� �Էµ� ����Ÿ�Դϴ�.(�������..)" + '[����ġ:' + String(li_xlrow) + ']')
	End If
	
	li_xlrow++
Loop

COMMIT USING SQLCA;
MessageBox('Ȯ��', '���� �Ǿ����ϴ�.')

//uo_xl.Application.Quit
uo_xl.uf_excel_Disconnect()
Destroy uo_xl

	
end event

type cb_2 from commandbutton within w_sm10_0030_ckd
boolean visible = false
integer x = 4155
integer y = 448
integer width = 402
integer height = 116
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "MOBIS"
end type

event clicked;Integer li_value
String  ls_path
String  ls_file
li_value = GetFileOpenName("MOBIS CKD ��������", ls_path, ls_file, "XLS", "XLS Files (*.XLS),*.XLS, XLSX Files (*.XLSX), *.XLSX,")
Choose Case li_value
	Case 0
		Return
	Case -1
		MessageBox('Ȯ��', '���� ���ÿ� ���� �߽��ϴ�.')
		Return
	Case 1
		If FileExists(ls_path) = False Then
			MessageBox('Ȯ��', ls_path + ' ������ �������� �ʽ��ϴ�.')
			Return
		End If
End Choose

uo_xlobject uo_xl
uo_xl = Create uo_xlobject
uo_xl.uf_excel_connect(ls_path, False, 3)
uo_xl.uf_selectsheet(1)
uo_xl.uf_set_format(1, 1, '@' + space(30))

//Data ���� Row Setting
Integer li_xlrow
li_xlrow = 2

Integer li_ins
Integer li_cnt  ; li_cnt  = 0
Integer li_jpno ; li_jpno = 0
Integer i
Integer li_dup
Long    ll_err
String  ls_balno
String  ls_balseq
String  ls_baldate
String  ls_orderno
String  ls_ordersq
String  ls_orddate
String  ls_itnbr
String  ls_itdsc
String  ls_balqty
String  ls_naparea
String  ls_yodate
String  ls_napyn
String  ls_gadate
String  ls_multi_ds
String  ls_ndate
String  ls_customer
String  ls_carname
String  ls_balmemo
String  ls_status
String  ls_factory
String  ls_crt_date
String  ls_crt_time
String  ls_crt_user
String  ls_mitnbr
String  ls_mcvcod
String  ls_balyn
String  ls_baljpno
String  ls_balseq2
String  ls_err

Do While(True)
	//Data�� ������쿣 Return...........
	If IsNull(uo_xl.uf_gettext(li_xlrow, 1)) Or Trim(uo_xl.uf_gettext(li_xlrow, 1)) = '' Then Exit //������ȣ
	
//	li_ins = dw_insert.InsertRow(0) 
	li_cnt++
	li_jpno++
	
	For i = 1 To 15
		uo_xl.uf_set_format(li_xlrow, i, '@' + space(30))
	Next
	/* ��� �������� ��ġ ���� - BY SHINGOON 2015.10.02 **************************************/
	/*ls_balno    = Trim(uo_xl.uf_GetText(li_xlrow, 3) )
	ls_balseq   = Trim(uo_xl.uf_GetText(li_xlrow, 4) )
	ls_baldate  = Trim(uo_xl.uf_GetText(li_xlrow, 2) )
	ls_orderno  = Trim(uo_xl.uf_GetText(li_xlrow, 5) )
	ls_ordersq  = Trim(uo_xl.uf_GetText(li_xlrow, 6) )
	ls_orddate  = ''
	ls_itnbr    = Trim(uo_xl.uf_GetText(li_xlrow, 7) )
	ls_itdsc    = Trim(uo_xl.uf_GetText(li_xlrow, 8) )
	ls_balqty   = Trim(uo_xl.uf_GetText(li_xlrow, 9) )
	ls_naparea  = Trim(uo_xl.uf_GetText(li_xlrow, 10))
	ls_yodate   = Trim(uo_xl.uf_GetText(li_xlrow, 11))
	ls_napyn    = Trim(uo_xl.uf_GetText(li_xlrow, 12))
	ls_gadate   = Trim(uo_xl.uf_GetText(li_xlrow, 13))
	ls_multi_ds = Trim(uo_xl.uf_GetText(li_xlrow, 14))
	ls_ndate    = Trim(uo_xl.uf_GetText(li_xlrow, 15))
	ls_customer = Trim(uo_xl.uf_GetText(li_xlrow, 16))
	ls_carname  = Trim(uo_xl.uf_GetText(li_xlrow, 17))
	ls_balmemo  = Trim(uo_xl.uf_GetText(li_xlrow, 18))
	ls_status   = Trim(uo_xl.uf_GetText(li_xlrow, 19))
	ls_factory  = 'M1'
	ls_crt_date = String(TODAY(), 'yyyymmdd')
	ls_crt_time = String(TODAY(), 'hhmm'    )
	ls_crt_user = gs_userid
	ls_balyn    = ''
	ls_baljpno  = ''
	ls_balseq2  = ''*/
	 /* ��� �������� ��ġ ���� - 2023.12.04 by dykim */
	/*ls_baldate  = Trim(uo_xl.uf_GetText(li_xlrow, 2) )	
	ls_balno    = Trim(uo_xl.uf_GetText(li_xlrow, 3) )	
	ls_balseq   = Trim(uo_xl.uf_GetText(li_xlrow, 4) )		
	ls_orderno  = Trim(uo_xl.uf_GetText(li_xlrow, 5) )
	ls_ordersq  = Trim(uo_xl.uf_GetText(li_xlrow, 6) )
	ls_orddate  = ''
	ls_itnbr    = Trim(uo_xl.uf_GetText(li_xlrow, 7) )	
	ls_itdsc    = ''//Trim(uo_xl.uf_GetText(li_xlrow, 8) ) - ��ĺ��� �� ��������
	ls_balqty   = Trim(uo_xl.uf_GetText(li_xlrow, 13))
	ls_naparea  = Trim(uo_xl.uf_GetText(li_xlrow, 8) )
	ls_yodate   = Trim(uo_xl.uf_GetText(li_xlrow, 9) )
	ls_napyn    = ''//Trim(uo_xl.uf_GetText(li_xlrow, 12)) - ��ĺ��� �� ��������
	ls_gadate   = Trim(uo_xl.uf_GetText(li_xlrow, 10) )	
	ls_multi_ds = ''//Trim(uo_xl.uf_GetText(li_xlrow, 14)) - ��ĺ��� �� ��������
	ls_ndate    = ''//Trim(uo_xl.uf_GetText(li_xlrow, 15)) - ��ĺ��� �� ��������
	ls_customer = Trim(uo_xl.uf_GetText(li_xlrow, 23)) 
	ls_carname  = Trim(uo_xl.uf_GetText(li_xlrow, 20)) 
	ls_balmemo  = Trim(uo_xl.uf_GetText(li_xlrow, 23))
	ls_status   = ''//Trim(uo_xl.uf_GetText(li_xlrow, 19)) - ��ĺ��� �� ��������
	ls_factory  = 'M1'
	ls_crt_date = String(TODAY(), 'yyyymmdd')
	ls_crt_time = String(TODAY(), 'hhmm'    )
	ls_crt_user = gs_userid
	ls_balyn    = ''
	ls_baljpno  = ''
	ls_balseq2  = '' */
	
	uo_xl.uf_set_format(li_xlrow, 3, 'YYYY-MM-DD') /* �ش� ������ ��¥�������� �Ǿ��־� ���� ����  */
	uo_xl.uf_set_format(li_xlrow, 10, 'YYYY-MM-DD')
	uo_xl.uf_set_format(li_xlrow, 11, 'YYYY-MM-DD')
	
	ls_baldate  = Trim(uo_xl.uf_GetText(li_xlrow, 3) )	 /* ������ */
	ls_balno    = Trim(uo_xl.uf_GetText(li_xlrow, 4) )  /* ���ֹ�ȣ */
	ls_balseq   = Trim(uo_xl.uf_GetText(li_xlrow, 5) )	 /* �����׹� */
	ls_orderno  = Trim(uo_xl.uf_GetText(li_xlrow, 6) ) /* �ֹ���ȣ */
	ls_ordersq  = Trim(uo_xl.uf_GetText(li_xlrow, 7) )	 /* LINE */
	ls_orddate  = ''
	ls_itnbr    = Trim(uo_xl.uf_GetText(li_xlrow, 8) )	/* �����ȣ */
	ls_itdsc    = ''//Trim(uo_xl.uf_GetText(li_xlrow, 8) ) - ��ĺ��� �� ��������
	ls_balqty   = Trim(uo_xl.uf_GetText(li_xlrow, 14)) /* ���ּ��� */
	ls_naparea  = Trim(uo_xl.uf_GetText(li_xlrow, 9) ) /* ����ó */
	ls_yodate   = Trim(uo_xl.uf_GetText(li_xlrow, 10) ) /* �䱸���� */
	ls_napyn    = ''//Trim(uo_xl.uf_GetText(li_xlrow, 12)) - ��ĺ��� �� ��������
	ls_gadate   = Trim(uo_xl.uf_GetText(li_xlrow, 11) ) /* �����ȹ */	
	ls_multi_ds = ''//Trim(uo_xl.uf_GetText(li_xlrow, 14)) - ��ĺ��� �� ��������
	ls_ndate    = ''//Trim(uo_xl.uf_GetText(li_xlrow, 15)) - ��ĺ��� �� ��������
	ls_customer = Trim(uo_xl.uf_GetText(li_xlrow, 23)) /* ���� */
	ls_carname  = Trim(uo_xl.uf_GetText(li_xlrow, 21)) /* �������� */
	ls_balmemo  = Trim(uo_xl.uf_GetText(li_xlrow, 24)) /* ���ָ޸� */
	ls_status   = ''//Trim(uo_xl.uf_GetText(li_xlrow, 19)) - ��ĺ��� �� ��������
	ls_factory  = 'M1'
	ls_crt_date = String(TODAY(), 'yyyymmdd')
	ls_crt_time = String(TODAY(), 'hhmm'    )
	ls_crt_user = gs_userid
	ls_balyn    = ''
	ls_baljpno  = ''
	ls_balseq2  = ''
	
//	ls_balno    = Trim(uo_xl.uf_GetText(li_xlrow, 2) )
//	ls_balseq   = Trim(uo_xl.uf_GetText(li_xlrow, 3) )
//	ls_baldate  = Trim(uo_xl.uf_GetText(li_xlrow, 1) )
//	ls_orderno  = Trim(uo_xl.uf_GetText(li_xlrow, 4) )
//	ls_ordersq  = Trim(uo_xl.uf_GetText(li_xlrow, 5) )
//	ls_orddate  = ''
//	ls_itnbr    = Trim(uo_xl.uf_GetText(li_xlrow, 6) )	
//	ls_itdsc    = ''//Trim(uo_xl.uf_GetText(li_xlrow, 8) ) - ��ĺ��� �� ��������
//	ls_balqty   = Trim(uo_xl.uf_GetText(li_xlrow, 12))
//	ls_naparea  = Trim(uo_xl.uf_GetText(li_xlrow, 7) )	
//	ls_yodate   = Trim(uo_xl.uf_GetText(li_xlrow, 8) )
//	ls_napyn    = ''//Trim(uo_xl.uf_GetText(li_xlrow, 12)) - ��ĺ��� �� ��������
//	ls_gadate   = Trim(uo_xl.uf_GetText(li_xlrow, 9) )
//	ls_multi_ds = ''//Trim(uo_xl.uf_GetText(li_xlrow, 14)) - ��ĺ��� �� ��������
//	ls_ndate    = ''//Trim(uo_xl.uf_GetText(li_xlrow, 15)) - ��ĺ��� �� ��������
//	ls_customer = Trim(uo_xl.uf_GetText(li_xlrow, 20))
//	ls_carname  = Trim(uo_xl.uf_GetText(li_xlrow, 19))
//	ls_balmemo  = Trim(uo_xl.uf_GetText(li_xlrow, 21))
//	ls_status   = ''//Trim(uo_xl.uf_GetText(li_xlrow, 19)) - ��ĺ��� �� ��������
//	ls_factory  = 'M1'
//	ls_crt_date = String(TODAY(), 'yyyymmdd')
//	ls_crt_time = String(TODAY(), 'hhmm'    )
//	ls_crt_user = gs_userid
//	ls_balyn    = ''
//	ls_baljpno  = ''
//	ls_balseq2  = ''



	/****************************************************************************************/
	
	SELECT REPLACE(:ls_baldate, '-', ''), REPLACE(:ls_yodate, '-', ''), REPLACE(:ls_gadate, '-', '')
	  INTO :ls_baldate                  , :ls_yodate                  , :ls_gadate
	  FROM DUAL;
	
	//���庰 �ŷ�ó �о����
	SELECT NVL(DECODE('P655', 'U904', SUBSTR(TRIM(RFNA2), 1, 6), SUBSTR(TRIM(RFNA2), -6, 6)), '') AS CVCOD
	  INTO :ls_mcvcod
	  FROM REFFPF
	 WHERE SABU  = :gs_sabu
		AND RFCOD = '2A'
		AND RFGUB = 'M1' ;
	If SQLCA.SQLCODE <> 0 OR Trim(ls_mcvcod) = '' OR IsNull(ls_mcvcod) Then
		MessageBox('���庰 �ŷ�ó Ȯ��', '[M1] ������ �ŷ�ó�ڵ� ������ �����ϴ�.')
//		uo_xl.Application.Quit
		uo_xl.uf_excel_Disconnect()
		Destroy uo_xl
		Return -1
	End If
	
	//��üǰ�� �о����(��ü�ŷ�ó�ڵ�)
	SELECT ITNBR, ITDSC
	  INTO :ls_mitnbr, :ls_itdsc
	  FROM ITEMAS
	/* WHERE REPLACE(ITNBR, '-', '') = :ls_itnbr*/
	 WHERE ITNBR = :ls_itnbr
	   AND USEYN = '0' ;
	If SQLCA.SQLCODE <> 0 OR Trim(ls_mitnbr) = '' OR IsNull(ls_mitnbr) Then
		MessageBox('�ڻ�ǰ�� Ȯ��', '[' + ls_itnbr + '] ǰ���� �ڻ� ǰ���� �ƴմϴ�.')
//		uo_xl.Application.Quit
		uo_xl.uf_excel_Disconnect()
		Destroy uo_xl
		Return -1
	End If
	
	/* �ߺ�Ȯ�� */
	SELECT COUNT('X')
	  INTO :li_dup
	  FROM VAN_MOBIS_CKD_B
	 WHERE BALNO = :ls_balno AND BALSEQ = :ls_balseq ;
	If li_dup < 1 Then
		INSERT INTO VAN_MOBIS_CKD_B (
		BALNO  ,	BALSEQ ,	BALDATE,	ORDERNO,	ORDERSQ ,	ORDDATE ,	ITNBR   ,	ITDSC   ,
		BALQTY ,	NAPAREA,	YODATE ,	NAPYN  ,	GADATE  ,	MULTI_DS,	NDATE   ,	CUSTOMER,
		CARNAME,	BALMEMO,	STATUS ,	FACTORY,	CRT_DATE,	CRT_TIME,	CRT_USER,	MITNBR  ,
		MCVCOD ,	BALYN  ,	BALJPNO,	BALSEQ2  )
		VALUES (
		:ls_balno  ,	:ls_balseq ,	:ls_baldate,	:ls_orderno,	:ls_ordersq ,	:ls_orddate ,	:ls_itnbr   ,	:ls_itdsc   ,
		:ls_balqty ,	:ls_naparea,	:ls_yodate ,	:ls_napyn  ,	:ls_gadate  ,	:ls_multi_ds,	:ls_ndate   ,	:ls_customer,
		:ls_carname,	:ls_balmemo,	:ls_status ,	:ls_factory,	:ls_crt_date,	:ls_crt_time,	:ls_crt_user,	:ls_mitnbr  ,
		:ls_mcvcod ,	:ls_balyn  ,	:ls_baljpno,	:ls_balseq2)   ;
		If SQLCA.SQLCODE <> 0 Then
			ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
			ROLLBACK USING SQLCA;
	//		uo_xl.Application.Quit
			uo_xl.uf_excel_Disconnect()
			Destroy uo_xl
			MessageBox('���� [' + String(ll_err), '�ڷ� �Է� �� ������ �߻� �߽��ϴ�.~r~n' + ls_err)
			Return
		End If
	End If
	
	li_xlrow++
Loop

COMMIT USING SQLCA;
MessageBox('Ȯ��', '���� �Ǿ����ϴ�.')

//uo_xl.Application.Quit
uo_xl.uf_excel_Disconnect()
Destroy uo_xl
end event

type cb_3 from commandbutton within w_sm10_0030_ckd
boolean visible = false
integer x = 4155
integer y = 584
integer width = 402
integer height = 116
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string pointer = "Arrow!"
string text = "WIA"
end type

event clicked;Integer li_value
String  ls_path
String  ls_file
li_value = GetFileOpenName("���� CKD ��������", ls_path, ls_file, "XLS", "XLS Files (*.XLS),*.XLS, XLSX Files (*.XLSX), *.XLSX")
Choose Case li_value
	Case 0
		Return
	Case -1
		MessageBox('Ȯ��', '���� ���ÿ� ���� �߽��ϴ�.')
		Return
	Case 1
		If FileExists(ls_path) = False Then
			MessageBox('Ȯ��', ls_path + ' ������ �������� �ʽ��ϴ�.')
			Return
		End If
End Choose

dw_list.ReSet()

uo_xlobject uo_xl
uo_xl = Create uo_xlobject
uo_xl.uf_excel_connect(ls_path, False, 3)
uo_xl.uf_selectsheet(1)
uo_xl.uf_set_format(1, 1, '@' + space(30))

/* Data Format ��ȯ�� */
uo_xlobject uo_xltemp
uo_xltemp = Create uo_xlobject
uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', False, 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1, 1, '@' + space(30))

//Data ���� Row Setting
Integer li_xlrow
li_xlrow = 3

Integer li_ins
Integer li_cnt  ; li_cnt  = 0
Integer li_jpno ; li_jpno = 0
Integer i
Integer li_dup
Integer li_chk ; li_chk = 0
String  ls_balno
String  ls_balseq
String  ls_baldate
String  ls_orderno
String  ls_ordersq
String  ls_orddate
String  ls_itnbr
String  ls_itdsc
String  ls_balqty
String  ls_naparea
String  ls_yodate
String  ls_napyn
String  ls_gadate
String  ls_multi_ds
String  ls_ndate
String  ls_customer
String  ls_carname
String  ls_balmemo
String  ls_status
String  ls_factory
String  ls_crt_date
String  ls_crt_time
String  ls_crt_user
String  ls_mitnbr
String  ls_mcvcod
String  ls_balyn
String  ls_baljpno
String  ls_balseq2

Long    ll_err
String  ls_err

SetPointer(HourGlass!)

Do While(True)
	//Data�� ������쿣 Return...........
	If IsNull(uo_xl.uf_gettext(li_xlrow, 1)) Or Trim(uo_xl.uf_gettext(li_xlrow, 1)) = '' Then Exit //������ȣ
	
//	li_ins = dw_insert.InsertRow(0) 
	li_cnt++
	li_jpno++
	
	For i = 1 To 15
		uo_xl.uf_set_format(li_xlrow, i, '@' + space(30))
	Next
	
	ls_balno    = Trim(uo_xl.uf_GetText(li_xlrow, 2) ) /* PO ��ȣ */
	/* ���ֹ�ȣ�� ���ּ������� �и� ('4502604010(00010)') */
	/* ���� �и� */
	SELECT SUBSTR(:ls_balno, INSTR(:ls_balno, '(') + 1, INSTR(:ls_balno, ')') - (INSTR(:ls_balno, '(') + 1))
	  INTO :ls_balseq
	  FROM DUAL;
	/* ���ֹ�ȣ �и� */
	SELECT SUBSTR(:ls_balno, 1, INSTR(:ls_balno, '(') - 1)
	  INTO :ls_balno
	  FROM DUAL;
	  
	
	//ls_baldate  = Trim(uo_xl.uf_GetText(li_xlrow, 22)) ���ε� ���亯�� - by shingoon 2016.01.22
	//ls_baldate  = Trim(uo_xl.uf_GetText(li_xlrow, 26)) ���ε� ��ĺ��� - BY BHKIM '20.05.29
	//ls_baldate  = Trim(uo_xl.uf_GetText(li_xlrow, 27) ) ���ε� ��ĺ��� - 2023.12.04 by dykim
	uo_xl.uf_set_format(li_xlrow, 28, 'YYYY-MM-DD')
	ls_baldate  = Trim(uo_xl.uf_GetText(li_xlrow, 28) ) /* PO ���� ������ */
	//ls_orderno  = Trim(uo_xl.uf_GetText(li_xlrow, 31)) ���ε� ���亯�� - by shingoon 2016.01.22
	ls_orderno  = Trim(uo_xl.uf_GetText(li_xlrow, 7)) /* CKD ������ȣ */
	
	ls_ordersq  = ''
	ls_orddate  = ''
	ls_itnbr    = Trim(uo_xl.uf_GetText(li_xlrow, 3) ) /* ǰ�� */
	ls_itdsc    = Trim(uo_xl.uf_GetText(li_xlrow, 4) ) /* ǰ�� */
	
	//ls_balqty   = Trim(uo_xl.uf_GetText(li_xlrow, 9) ) ���ε� ���亯�� - by shingoon 2016.01.22
	//ls_balqty   = Trim(uo_xl.uf_GetText(li_xlrow, 13) ) ���ε� ��ĺ��� - BY BHKIM '20.05.29
	//ls_balqty   = Trim(uo_xl.uf_GetText(li_xlrow, 14) ) ���ε� ��ĺ��� - 2023.12.04 by dykim
	ls_balqty   = Trim(uo_xl.uf_GetText(li_xlrow, 15) ) /* ���ּ��� */
	
	//ls_naparea  = Trim(uo_xl.uf_GetText(li_xlrow, 7) ) ���ε� ���亯�� - by shingoon 2016.01.22
	//ls_naparea  = Trim(uo_xl.uf_GetText(li_xlrow, 10)) ���ε� ��ĺ��� - BY BHKIM '20.05.29
	ls_naparea  = Trim(uo_xl.uf_GetText(li_xlrow, 11) ) /* ������ġ */
	
	//ls_yodate   = Trim(uo_xl.uf_GetText(li_xlrow, 20)) ���ε� ���亯�� - by shingoon 2016.01.22
	//ls_yodate   = Trim(uo_xl.uf_GetText(li_xlrow, 24)) ���ε� ��ĺ��� - BY BHKIM '20.05.29
	//ls_yodate   = Trim(uo_xl.uf_GetText(li_xlrow, 25) ) ���ε� ��ĺ��� - 2023.12.04 by dykim
	uo_xl.uf_set_format(li_xlrow, 26, 'YYYY-MM-DD')
	ls_yodate   = Trim(uo_xl.uf_GetText(li_xlrow, 26) ) /* ��ǰ�� */
	
	ls_napyn    = ''
	
	//ls_gadate   = Trim(uo_xl.uf_GetText(li_xlrow, 20)) ���ε� ���亯�� - by shingoon 2016.01.22
	//ls_gadate   = Trim(uo_xl.uf_GetText(li_xlrow, 24)) ���ε� ��ĺ��� - BY BHKIM '20.05.29
	//ls_gadate   = Trim(uo_xl.uf_GetText(li_xlrow, 25) ) ���ε� ��ĺ��� - 2023.12.04 by dykim
	uo_xl.uf_set_format(li_xlrow, 26, 'YYYY-MM-DD')	
	ls_gadate   = Trim(uo_xl.uf_GetText(li_xlrow, 26) ) /* ��ǰ�� */

	ls_multi_ds = ''
	ls_ndate    = ''
	//ls_customer = Trim(uo_xl.uf_GetText(li_xlrow, 6) ) ���ε� ���亯�� - by shingoon 2016.01.22
	//ls_customer = Trim(uo_xl.uf_GetText(li_xlrow, 9) ) ���ε� ��ĺ��� - BY BHKIM '20.05.29
	ls_customer = Trim(uo_xl.uf_GetText(li_xlrow, 10) ) /* ����� */
	
	ls_carname  = ''
	ls_balmemo  = ''
	
	//ls_status   = Trim(uo_xl.uf_GetText(li_xlrow, 17)) ���ε� ���亯�� - by shingoon 2016.01.22
	//ls_status   = Trim(uo_xl.uf_GetText(li_xlrow, 21)) ���ε� ��ĺ��� - BY BHKIM '20.05.29
	//ls_status   = Trim(uo_xl.uf_GetText(li_xlrow, 22) ) ���ε� ��ĺ��� - 2023.12.04 by dykim
	ls_status   = Trim(uo_xl.uf_GetText(li_xlrow, 23) )	
	
	ls_factory  = 'WP'
	ls_crt_date = String(TODAY(), 'yyyymmdd')
	ls_crt_time = String(TODAY(), 'hhmm'    )
	ls_crt_user = gs_userid
	ls_balyn    = ''
	ls_baljpno  = ''
	ls_balseq2  = ''
	
	/* ������ ��¥ ������ ���ڿ��� ���� */
	uo_xltemp.uf_setvalue(1, 1, ls_baldate)	
	ls_baldate = String(Long(uo_xltemp.uf_gettext(1, 2)), '0000') + String(Long(uo_xltemp.uf_gettext(1, 3)), '00') + String(Long(uo_xltemp.uf_gettext(1, 4)), '00')
	If IsDate(LEFT(ls_baldate, 4) + '/' + MID(ls_baldate, 5, 2) + '/' + RIGHT(ls_baldate, 2)) = False Then
		wf_error('WP', li_xlrow, ls_orderno, ls_customer, ls_itnbr, " �������Ŀ� ���� �ʽ��ϴ�.(�������..) " + ls_baldate + ' [����ġ:' + String(li_xlrow) + ']')
	End If
	
	uo_xltemp.uf_setvalue(1, 1, ls_yodate )	
	ls_yodate = String(Long(uo_xltemp.uf_gettext(1, 2)), '0000') + String(Long(uo_xltemp.uf_gettext(1, 3)), '00') + String(Long(uo_xltemp.uf_gettext(1, 4)), '00')
	If IsDate(LEFT(ls_yodate, 4) + '/' + MID(ls_yodate, 5, 2) + '/' + RIGHT(ls_yodate, 2)) = False Then
		wf_error('WP', li_xlrow, ls_orderno, ls_customer, ls_itnbr, " �������Ŀ� ���� �ʽ��ϴ�.(�������..) " + ls_yodate + ' [����ġ:' + String(li_xlrow) + ']')
	End If
	
	uo_xltemp.uf_setvalue(1, 1, ls_gadate )	
	ls_gadate = String(Long(uo_xltemp.uf_gettext(1, 2)), '0000') + String(Long(uo_xltemp.uf_gettext(1, 3)), '00') + String(Long(uo_xltemp.uf_gettext(1, 4)), '00')
	If IsDate(LEFT(ls_gadate, 4) + '/' + MID(ls_gadate, 5, 2) + '/' + RIGHT(ls_gadate, 2)) = False Then
		wf_error('WP', li_xlrow, ls_orderno, ls_customer, ls_itnbr, " �������Ŀ� ���� �ʽ��ϴ�.(�������..) " + ls_gadate + ' [����ġ:' + String(li_xlrow) + ']')
	End If
	
	SELECT REPLACE(:ls_baldate, '-', ''), REPLACE(:ls_yodate, '-', ''), REPLACE(:ls_gadate, '-', '')
	  INTO :ls_baldate                  , :ls_yodate                  , :ls_gadate
	  FROM DUAL ;
	
	//���庰 �ŷ�ó �о����
	SELECT NVL(DECODE('P655', 'U904', SUBSTR(TRIM(RFNA2), 1, 6), SUBSTR(TRIM(RFNA2), -6, 6)), '') AS CVCOD
	  INTO :ls_mcvcod
	  FROM REFFPF
	 WHERE SABU  = :gs_sabu
		AND RFCOD = '2A'
		AND RFGUB = 'WP' ;
	If SQLCA.SQLCODE <> 0 OR Trim(ls_mcvcod) = '' OR IsNull(ls_mcvcod) Then
		MessageBox('���庰 �ŷ�ó Ȯ��', '[M1] ������ �ŷ�ó�ڵ� ������ �����ϴ�.')
//		uo_xl.Application.Quit
		uo_xl.uf_excel_Disconnect()
		uo_xltemp.uf_excel_Disconnect()
		Destroy uo_xl
		Destroy uo_xltemp
		SetPointer(Arrow!)
		Return -1
	End If
	
	/* ǰ���� ù ��° �ڸ��� ����(A,B,C)�� �پ� �����ٰ� MTP�� ���� ǰ���� �߰��� �߻��� - BY SHINGOON 2016.01.22 */
	//��üǰ�� �о����(��üǰ���ڵ�)
//	SELECT ITNBR
//	  INTO :ls_mitnbr
//	  FROM ITEMAS
//	 WHERE REPLACE(ITNBR, '-', '') = SUBSTR(:ls_itnbr, 2, LENGTH(:ls_itnbr))
//	   AND USEYN = '0' ;
	SELECT ITNBR INTO :ls_mitnbr FROM ITEMAS
	 WHERE :ls_itnbr LIKE '%'||NVL(REPLACE(ITNBR, '-', ''), '.')||'%'
	   AND ITNBR <> 'E' ; /* VAN���� ����� �Ǵ��� �˼� ���� E ǰ���� ��ϵǸ鼭 �ش� ���п� SELECT������ ��Ÿ���� Eǰ�� ����ó�� �� - BY SHINGOON 20180514 */
	/****************************************************************************************************************/
	If SQLCA.SQLCODE <> 0 OR Trim(ls_mitnbr) = '' OR IsNull(ls_mitnbr) Then
		MessageBox('�ڻ�ǰ�� Ȯ��', '[' + ls_itnbr + '] ǰ���� �ڻ� ǰ���� �ƴմϴ�.')
//		uo_xl.Application.Quit
		uo_xl.uf_excel_Disconnect()
		uo_xltemp.uf_excel_Disconnect()
		Destroy uo_xl
		Destroy uo_xltemp
		SetPointer(Arrow!)
		Return -1
	End If
	
	/* �ߺ�Ȯ�� */
	SELECT COUNT('X')
	  INTO :li_dup
	  FROM VAN_MOBIS_CKD_B
	 WHERE BALNO = :ls_balno AND BALSEQ = :ls_balseq ;
	If li_dup < 1 Then
		INSERT INTO VAN_MOBIS_CKD_B (
		BALNO  ,	BALSEQ ,	BALDATE,	ORDERNO,	ORDERSQ ,	ORDDATE ,	ITNBR   ,	ITDSC   ,
		BALQTY ,	NAPAREA,	YODATE ,	NAPYN  ,	GADATE  ,	MULTI_DS,	NDATE   ,	CUSTOMER,
		CARNAME,	BALMEMO,	STATUS ,	FACTORY,	CRT_DATE,	CRT_TIME,	CRT_USER,	MITNBR  ,
		MCVCOD ,	BALYN  ,	BALJPNO,	BALSEQ2  )
		VALUES (
		:ls_balno  ,	:ls_balseq ,	:ls_baldate,	:ls_orderno,	:ls_ordersq ,	:ls_orddate ,	:ls_mitnbr  ,	:ls_itdsc   ,
		:ls_balqty ,	:ls_naparea,	:ls_yodate ,	:ls_napyn  ,	:ls_gadate  ,	:ls_multi_ds,	:ls_ndate   ,	:ls_customer,
		:ls_carname,	:ls_balmemo,	:ls_status ,	:ls_factory,	:ls_crt_date,	:ls_crt_time,	:ls_crt_user,	:ls_mitnbr  ,
		:ls_mcvcod ,	:ls_balyn  ,	:ls_baljpno,	:ls_balseq2)   ;
		If SQLCA.SQLCODE <> 0 Then
			ll_err = SQLCA.SQLDBCODE ; ls_err = SQLCA.SQLERRTEXT
			ROLLBACK USING SQLCA;
	//		uo_xl.Application.Quit
			uo_xl.uf_excel_Disconnect()
			uo_xltemp.uf_excel_Disconnect()
			Destroy uo_xl
			Destroy uo_xltemp
			SetPointer(Arrow!)
			MessageBox('Insert Err - ' + String(ll_err), '(' + String(li_xlrow) + '��) �ڷ� �Է� �� ������ �߻� �߽��ϴ�.~r~n' + ls_err)
			Return
		End If
	Else
		li_chk++
	End If
	
	li_xlrow++
Loop

SetPointer(Arrow!)

COMMIT USING SQLCA;
MessageBox('Ȯ��', '���� �Ǿ����ϴ�.~r~r~n(��ü:' + String(li_cnt) + '�� / �ߺ�:' + String(li_chk) + '��)')

//uo_xl.Application.Quit
uo_xl.uf_excel_Disconnect()
uo_xltemp.uf_excel_Disconnect()
Destroy uo_xl
Destroy uo_xltemp
end event

type cb_4 from commandbutton within w_sm10_0030_ckd
boolean visible = false
integer x = 4155
integer y = 720
integer width = 402
integer height = 116
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "GLOBIS"
end type

event clicked;Long ll_cnt
string ls_filename , ls_gubun , ls_reg_gb
Long ll_r

If dw_input.AcceptText() < 1 Then Return
If dw_input.GetRow() < 1 Then Return

If Trim(dw_input.GetItemString(1, 'd_crt')) = '' OR IsNull(dw_input.GetItemString(1, 'd_crt')) Then
	MessageBox('Ȯ��', '�������� �Է� �Ͻʽÿ�.')
	Return
End If

pointer oldpointer
oldpointer = SetPointer(HourGlass!)

dw_list.reset()

If FileExists("C:\HKC\VAN\HKCD6.TXT") = False Then
	MessageBox('���� Ȯ��', '[C:\HKC\VAN\HKCD6.TXT] ������ �������� �ʽ��ϴ�.')
	Return
End If

If FileExists("C:\HKC\VAN\HKCD8.TXT") = False Then
	MessageBox('���� Ȯ��', '[C:\HKC\VAN\HKCD8.TXT] ������ �������� �ʽ��ϴ�.')
	Return
End If

// D6
il_succeed = 0
ll_cnt=0
ls_gubun = "HKCD6"
ls_filename = "C:\HKC\VAN\HKCD6.TXT"
ll_cnt = wf_van_d68(ls_filename,gs_sabu)
If ll_cnt > 0 Then
	ll_r = wf_error('D6',ll_cnt,'','','',Right('D6',2) + ' �ѰǼ� :'+String(ll_cnt) + '(���� : '+String(ll_cnt - il_succeed)+',���� :'+String(il_succeed) + ') ����Ÿ ó���� �Ͽ����ϴ�.')
	dw_list.object.err_seq[ll_r] = 1	
End if
// D8
il_succeed = 0
ll_cnt=0
ls_gubun = "HKCD8"
ls_filename = "C:\HKC\VAN\HKCD8.TXT"
ll_cnt = wf_van_d68(ls_filename,gs_sabu)
If ll_cnt > 0 Then
	ll_r = wf_error('D8',ll_cnt,'','','',Right('D8',2) + ' �ѰǼ� :'+String(ll_cnt) + '(���� : '+String(ll_cnt - il_succeed)+',���� :'+String(il_succeed) + ') ����Ÿ ó���� �Ͽ����ϴ�.')
	dw_list.object.err_seq[ll_r] = 1	
End if

SetPointer(oldpointer)

//If ll_cnt > 0 Then
//	p_print.Enabled =True
//	p_print.PictureName = '..\image\�μ�_up.gif'
//
//	p_preview.enabled = True
//	p_preview.PictureName = '..\image\�̸�����_up.gif'
//Else
//	p_print.Enabled =False
//	p_print.PictureName = '..\image\�μ�_d.gif'
//
//	p_preview.enabled = False
//	p_preview.PictureName = '..\image\�̸�����_d.gif'
//End If	
SetPointer(Arrow!)

end event

type cb_5 from commandbutton within w_sm10_0030_ckd
integer x = 3067
integer y = 56
integer width = 425
integer height = 132
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "File Upload"
end type

event clicked;dw_input.AcceptText()

Integer row
row = dw_input.GetRow()
If row < 1 Then Return

String  ls_gbn
ls_gbn = dw_input.GetItemString(row, 'ckdgbn')

dw_insert.ReSet()

Choose Case ls_gbn
	Case 'H' //������
		cb_1.TriggerEvent('Clicked')
	Case 'M' //���
		cb_2.TriggerEvent('Clicked')
	Case 'W' //����
		cb_3.TriggerEvent('Clicked')
	Case 'G' //�۷κ�
		cb_4.TriggerEvent('Clicked')
	Case 'P' //�Ŀ���
		cb_6.TriggerEvent('Clicked')
End Choose

end event

type cb_6 from commandbutton within w_sm10_0030_ckd
boolean visible = false
integer x = 4155
integer y = 856
integer width = 402
integer height = 116
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "POWERTEC"
end type

event clicked;Integer li_value
String  ls_path
String  ls_file
li_value = GetFileOpenName("�Ŀ��� CKD ��������", ls_path, ls_file, "XLS", "XLS Files (*.XLS),*.XLS, XLSX Files (*.XLSX), *.XLSX,")
Choose Case li_value
	Case 0
		Return
	Case -1
		MessageBox('Ȯ��', '���� ���ÿ� ���� �߽��ϴ�.')
		Return
	Case 1
		If FileExists(ls_path) = False Then
			MessageBox('Ȯ��', ls_path + ' ������ �������� �ʽ��ϴ�.')
			Return
		End If
End Choose

If FileExists('c:\erpman\bin\date_conv.xls') = False Then
	MessageBox('Ȯ��','c:\erpman\bin\date_conv.xls'+' ������ �������� �ʽ��ϴ�.')
	Return
End If

dw_list.ReSet()

uo_xlobject uo_xl
uo_xl = Create uo_xlobject
uo_xl.uf_excel_connect(ls_path, False, 3)
uo_xl.uf_selectsheet(1)
uo_xl.uf_set_format(1, 1, '@' + space(30))

/* Data Format ��ȯ�� */
uo_xlobject uo_xltemp
uo_xltemp = Create uo_xlobject
uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', False, 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1, 1, '@' + space(30))

//Data ���� Row Setting
Integer li_xlrow
li_xlrow = 2

Integer li_ins
Integer li_cnt  ; li_cnt  = 0
Integer li_jpno ; li_jpno = 0
Integer i
Integer li_dup
String  ls_order_no
String  ls_itnbr
String  ls_itdsc
String  ls_custcd
String  ls_custnm
String  ls_vndcd
String  ls_carcd
String  ls_orddat
String  ls_ordtim
String  ls_pum
String  ls_ordqty
String  ls_bigo

st_state.Text    = '����Ÿ�� �д� ���Դϴ�...'
st_state.Visible = True

Do While(True)
	//Data�� ������쿣 Return...........
	If IsNull(uo_xl.uf_gettext(li_xlrow, 1)) Or Trim(uo_xl.uf_gettext(li_xlrow, 1)) = '' Then Exit //����
	
//	li_ins = dw_insert.InsertRow(0)
	li_cnt++
	li_jpno++
	
	For i = 1 To 11
		uo_xl.uf_set_format(li_xlrow, i, '@' + space(30))
	Next
	
	ls_order_no = Trim(uo_xl.uf_GetText(li_xlrow, 3))  //������ȣ
	ls_itnbr    = Trim(uo_xl.uf_GetText(li_xlrow, 6))  //ǰ��
	ls_itdsc    = Trim(uo_xl.uf_GetText(li_xlrow, 7))  //ǰ��
	ls_custcd   = Trim(uo_xl.uf_GetText(li_xlrow, 9))  //��ü�ڵ�(P655)
	ls_custnm   = Trim(uo_xl.uf_GetText(li_xlrow, 8))  //��ü��
	ls_vndcd    = Trim(uo_xl.uf_GetText(li_xlrow, 1))  //����
	ls_carcd    = Trim(uo_xl.uf_GetText(li_xlrow, 2))  //����
	ls_orddat   = Trim(uo_xl.uf_GetText(li_xlrow, 4))  //Ȯ������(��������)
	ls_ordtim   = Trim(uo_xl.uf_GetText(li_xlrow, 5))  //Ȯ���Ͻ�(�����Ͻ�)
	ls_pum      = Trim(uo_xl.uf_GetText(li_xlrow, 10)) //ǰ��
	ls_ordqty   = Trim(uo_xl.uf_GetText(li_xlrow, 11)) //���ü���
	ls_bigo     = ''                                   //���
	
	st_state.Text = String(li_xlrow) + '�� [' + ls_order_no + ' / ' + ls_itnbr + ']'
	
	/* ��ü�ڵ尡 P655�� ��� �ڷ� ��� */
	If ls_custcd = 'P655' Then
		/* ������ ��¥ ������ ���ڿ��� ���� */
		uo_xltemp.uf_setvalue(1, 1, ls_orddat)
			
		ls_orddat = String(Long(uo_xltemp.uf_gettext(1, 2)), '0000') + String(Long(uo_xltemp.uf_gettext(1, 3)), '00') + String(Long(uo_xltemp.uf_gettext(1, 4)), '00')
		If IsDate(LEFT(ls_orddat, 4) + '/' + MID(ls_orddat, 5, 2) + '/' + RIGHT(ls_orddat, 2)) = False Then
			wf_error('PTC', li_xlrow, ls_order_no, ls_vndcd, ls_itnbr, " �������Ŀ� ���� �ʽ��ϴ�.(�������..) " + ls_orddat + ' [����ġ:' + String(li_xlrow) + ']')
		End If
		
		SELECT REPLACE(:ls_orddat, '-', ''), REPLACE(:ls_ordtim, ':', '')
		  INTO :ls_orddat                  , :ls_ordtim
		  FROM DUAL ;
		
		/* �ߺ�Ȯ�� */
		SELECT COUNT('X')
		  INTO :li_dup
		  FROM VAN_PTC_CKD
		 WHERE ORDER_NO = :ls_order_no AND ITNBR = :ls_itnbr ;
		If li_dup < 1 Then	
			INSERT INTO VAN_PTC_CKD (
			ORDER_NO, ITNBR, ITDSC, CUSTCD, CUSTNM, VNDCD, CARCD, ORDDAT, ORDTIM, PUM, ORDQTY, BIGO )
			VALUES (
			:ls_order_no, :ls_itnbr, :ls_itdsc, :ls_custcd, :ls_custnm, :ls_vndcd, :ls_carcd, :ls_orddat, :ls_ordtim, :ls_pum, :ls_ordqty, :ls_bigo ) ;
			If SQLCA.SQLCODE <> 0 Then
				ROLLBACK USING SQLCA;
		//		uo_xl.Application.Quit
				uo_xltemp.uf_excel_Disconnect()
				uo_xl.uf_excel_Disconnect()
				Destroy uo_xl
				Destroy uo_xltemp
				MessageBox('Ȯ��', '�ڷ� �Է� �� ������ �߻� �߽��ϴ�.')
				Return
			End If
		Else
			wf_error('PTC', li_xlrow, ls_order_no, ls_vndcd, ls_itnbr, " �̹� �Էµ� ����Ÿ�Դϴ�.(�������..)" + ' [����ġ:' + String(li_xlrow) + ']')
		End If
	End If
	
	li_xlrow++
Loop

st_state.Visible = False

COMMIT USING SQLCA;
MessageBox('Ȯ��', '���� �Ǿ����ϴ�.')

//uo_xl.Application.Quit
uo_xltemp.uf_excel_Disconnect()
uo_xl.uf_excel_Disconnect()
Destroy uo_xl
Destroy uo_xltemp

	
end event

type dw_list from datawindow within w_sm10_0030_ckd
boolean visible = false
integer x = 187
integer y = 676
integer width = 4256
integer height = 1564
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "VAN ��������"
string dataobject = "d_sm10_0030_a"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_state from statictext within w_sm10_0030_ckd
boolean visible = false
integer x = 1637
integer y = 472
integer width = 1440
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 255
long backcolor = 16777215
string text = "����Ÿ�� �д� ���Դϴ�..."
alignment alignment = center!
boolean focusrectangle = false
end type

