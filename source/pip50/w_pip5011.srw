$PBExportHeader$w_pip5011.srw
$PBExportComments$** ���� �Ű� �ڷ� ����
forward
global type w_pip5011 from window
end type
type dw_saup from datawindow within w_pip5011
end type
type dw_ip from datawindow within w_pip5011
end type
type st_6 from statictext within w_pip5011
end type
type rr_1 from roundrectangle within w_pip5011
end type
type p_1 from uo_picture within w_pip5011
end type
type p_exit from uo_picture within w_pip5011
end type
type dw_2 from datawindow within w_pip5011
end type
type dw_1 from datawindow within w_pip5011
end type
type cb_exit from commandbutton within w_pip5011
end type
type sle_msg from singlelineedit within w_pip5011
end type
type dw_datetime from datawindow within w_pip5011
end type
type st_10 from statictext within w_pip5011
end type
type pb_1 from picturebutton within w_pip5011
end type
type gb_3 from groupbox within w_pip5011
end type
type gb_10 from groupbox within w_pip5011
end type
type rr_2 from roundrectangle within w_pip5011
end type
end forward

global type w_pip5011 from window
integer x = 5
integer y = 4
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "���� �Ű� �ڷ� ����"
string menuname = "m_shortcut"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
event ue_filename ( )
dw_saup dw_saup
dw_ip dw_ip
st_6 st_6
rr_1 rr_1
p_1 p_1
p_exit p_exit
dw_2 dw_2
dw_1 dw_1
cb_exit cb_exit
sle_msg sle_msg
dw_datetime dw_datetime
st_10 st_10
pb_1 pb_1
gb_3 gb_3
gb_10 gb_10
rr_2 rr_2
end type
global w_pip5011 w_pip5011

type variables
// �Է¹޴� ����Ÿ
string		is_termtag
string		is_filepath
string		idt_submitdate
string		idt_workyear
string		idt_workyear2

int		ii_fileID
string		is_businessno, is_businessname
string		is_president,  is_residentno
string		is_zipcode, is_address
string		is_phoneno
string		is_taxoffice

long		il_c_seq, il_d_seq
long		il_prevCnt

string   soffcode  /*�������ڵ�*/
string   is_hometaxid

string      is_saupcd //�����
end variables

forward prototypes
public function boolean wf_write_d_record (long al_row)
public function boolean wf_fileopen ()
public function boolean wf_write_a_record ()
public function boolean wf_write_b_record ()
public function boolean wf_write_c_record (long al_row)
end prototypes

event ue_filename;string saupno, ls_temp

SELECT SAUPNO
 INTO :saupno			//����ڹ�ȣ
 FROM P0_SAUPCD
WHERE COMPANYCODE = :gs_company AND
		SAUPCODE = DECODE(:is_saupcd,'%','10',:is_saupcd);

IF SQLCA.SQLCODE <> 0 OR IsNull(saupno) THEN
	// ���� ����
	  SELECT "SYSCNFG"."DATANAME"  //����ڹ�ȣ
		 INTO :saupno  
		 FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
				( "SYSCNFG"."SERIAL" = 1 )  AND
				( "SYSCNFG"."LINENO" = '2' )  ;
	IF SQLCA.SQLCODE <> 0 OR IsNull(saupno) THEN
		 select a.sano
		  into :saupno
		  from vndmst a, reffpf b
		 where a.cvcod = b.rfna2 and
				 b.rfcod = 'AD' and
				 b.rfgub <> 99  and
				 b.rfgub = DECODE(:is_saupcd,'%','10',:is_saupcd) ;
	END IF
END IF

integer i
for i = 1 to 3
   ls_temp += f_get_token(saupno,'-')
next								 

dw_ip.Setitem(1,'spath','C:\EOSDATA\E'+left(ls_temp,7)+'.'+right(ls_temp,3))
end event

public function boolean wf_write_d_record (long al_row);
string	ls_empno, ls_residentno, ls_companyname, ls_companyno
string	ls_record, ls_record_before, ls_record_after
double	ld_retirementpay, ld_honorretirepay, ld_groupretireinsurance, ld_totalretireamt
long		ll_row, ll_rowcnt, ll_saverow

ls_empno = dw_1.GetItemString(al_row, 'empno')
ll_rowcnt = dw_2.RowCount()

ll_row = dw_2.Find("empno = '" + ls_empno + "'", 1, ll_rowcnt)
if ll_row < 1 then return false

ls_record_before = 'D' + '22' + is_taxoffice
ls_record_before = ls_record_before + string(il_c_seq, '000000')
ls_record_before = ls_record_before + is_businessno + Space(50)

ls_residentno = dw_1.GetItemString(al_row, "residentno")
if Len(ls_residentno) > 13 then
	ls_residentno = left(ls_residentno, 13)
else
	ls_residentno = ls_residentno + Space(13 - Len(ls_residentno))
end if
ls_record_before = ls_record_before + ls_residentno

ls_record_after = Space(233)

il_d_seq++
do until ll_row < 1
	
//	ls_companyname = dw_2.GetItemString(ll_row, 'companyname')
//	if Len(ls_companyname) > 40 then
//		ls_companyname = left(ls_companyname, 40)
//	else
//		ls_companyname = ls_companyname + Space(40 - Len(ls_companyname))
//	end if
//	ls_record = ls_record_before + ls_companyname
//	
//	ls_companyno = dw_2.GetItemString(ll_row, 'companyno')
//	if Len(ls_companyno) > 10 then
//		ls_companyno = left(ls_companyno, 10)
//	else
//		ls_companyno = ls_companyno + Space(10 - Len(ls_companyno))
//	end if
//	ls_record = ls_record + ls_companyno
	
	ls_record = ls_record_before + Space(40) + Space(10)
	
	ld_retirementpay = dw_2.GetItemNumber(ll_row, "retirementpay") // �����޿�
	if isNull(ld_retirementpay) then ld_retirementpay = 0
	ls_record = ls_record + string(ld_retirementpay, '0000000000')
	
	ld_honorretirepay = dw_2.GetItemNumber(ll_row, "honorretirepay")  //����������
	if isNull(ld_honorretirepay) then ld_honorretirepay = 0
	ls_record = ls_record + string(ld_honorretirepay, '0000000000')
	
//	ld_groupretireinsurance = dw_2.GetItemNumber(ll_row, "groupretireinsurance")
//	if isNull(ld_groupretireinsurance) then ld_groupretireinsurance = 0
//	ls_record = ls_record + string(ld_groupretireinsurance, '0000000000')

//���������Ͻñ�(10)
	
	ld_totalretireamt = dw_2.GetItemNumber(ll_row, "totalretireamt")  //��
	if isNull(ld_totalretireamt) then ld_totalretireamt = 0
	ls_record = ls_record + string(ld_totalretireamt, '0000000000')
	
	//������ҵ�(10)
	ls_record = ls_record + '0000000000'
	//�Ѽ��ɾ�(10)
	ls_record = ls_record + '0000000000'
	//�������հ��(10)
	ls_record = ls_record + '0000000000'
	//�ҵ��ں��Ծ�(10)
	ls_record = ls_record + '0000000000'	
	//�������ݼҵ������(10)
	ls_record = ls_record + '0000000000'
	//���������Ͻñ�(10)
	ls_record = ls_record + '0000000000'
	
	ls_record = ls_record + string(il_d_seq, '00')  //�����ٹ�ó �Ϸù�ȣ
	
	ls_record = ls_record + ls_record_after
	if FileWrite(ii_fileid, ls_record) <> 470 then
		MessageBox("����Ÿ ����", "wf_write_d_record�� Ȯ���Ͻʽÿ�.")
		return false
	end if

	if ll_row < ll_rowcnt then
		ll_row = dw_2.Find("empno = '" + ls_empno + "'", ll_row + 1, ll_rowcnt)
	else
		ll_row = 0
	end if

	if ll_row = ll_saverow then exit
	ll_saverow = ll_row
	il_d_seq++

loop

return true

end function

public function boolean wf_fileopen ();
int	li_yesNo

if FileLength(is_filepath) <> -1 then
	li_yesNo = MessageBox("ȭ�� �����", "�̹� �ִ� ȭ���� ������?", Question!, YesNo!, 2)
	if li_yesNo = 2 then return false
end if

ii_fileID = FileOpen(is_filePath, LineMode!, Write!, LockWrite!, Replace!)
if ii_fileID = -1 then
	MessageBox("ȭ��,���� ����", "ȭ�Ϲ� ���������� �ùٸ��� Ȯ���Ͻʽÿ�.")
	return false
end if

return true

end function

public function boolean wf_write_a_record ();string	ls_recordtag, ls_datatag, ls_submitdate, ls_submittag
string	ls_space6, s_saupno, s_saname, s_president
string	s_zip, s_addr, ls_b_cnt, ls_korean_kind,s_ddd
string	ls_updatecode, ls_emptySpace
string	ls_record, S_Resno, ls_dept, ls_empname, ls_tel
St_saupinfo	sainfo

dw_ip.Accepttext()

  SELECT SAUPNO, JURNO, JURNAME, CHAIRMAN
    INTO :S_SAUPNO,			//����ڹ�ȣ
	      :S_Resno,			//���ι�ȣ
	 		:S_SANAME,			//���θ�
			:S_PRESIDENT		//��ǥ�ڸ�
    FROM P0_SAUPCD
   WHERE COMPANYCODE = :gs_company AND
			SAUPCODE = DECODE(:is_saupcd,'%','10',:is_saupcd);
			
IF SQLCA.SQLCODE <> 0 THEN
	// ���� ����
	  SELECT "SYSCNFG"."DATANAME"  //����ڹ�ȣ
		 INTO :S_SAUPNO  
		 FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
				( "SYSCNFG"."SERIAL" = 1 )  AND
				( "SYSCNFG"."LINENO" = '2' )  ;
				
	//S_SAUPNO = left(s_saupno,3)+mid(s_saupno,5,2)+right(s_saupno,5)
				
	  SELECT "SYSCNFG"."DATANAME"  //������
		 INTO :S_SANAME
		 FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
				( "SYSCNFG"."SERIAL" = 1 )  AND
				( "SYSCNFG"."LINENO" = '3' )  ;	
				
	  SELECT "SYSCNFG"."DATANAME"  //��ǥ�ڸ�
		 INTO :S_PRESIDENT
		 FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
				( "SYSCNFG"."SERIAL" = 1 )  AND
				( "SYSCNFG"."LINENO" = '4' )  ;	
	
	 SELECT "SYSCNFG"."DATANAME"  //���ι�ȣ
		 INTO :S_Resno
		 FROM "SYSCNFG"  
		WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
				( "SYSCNFG"."SERIAL" = 1 )  AND
				( "SYSCNFG"."LINENO" = '1' )  ;
	IF ISNULL(S_SAUPNO) OR ISNULL(S_SANAME) OR ISNULL(S_PRESIDENT) OR ISNULL(S_Resno) THEN
		 select a.cvnas, a.sano, a.ownam, a.posno, a.addr1, a.telddd||a.telno1||a.telno2
		  into :S_SANAME,:S_SAUPNO,:S_PRESIDENT,:S_ZIP,	:S_ADDR,:S_DDD	 
		  from vndmst a, reffpf b
		 where a.cvcod = b.rfna2 and
				 b.rfcod = 'AD' and
				 b.rfgub <> 99  and
				 b.rfgub = DECODE(:is_saupcd,'%','10',:is_saupcd);

		if sqlca.sqlcode = -1 then
			MessageBox("wf_write_a_record(��������)", sqlca.sqlerrtext)
			return false
		end if
	END IF
END IF
			
sainfo.saupno    = S_SAUPNO
sainfo.jurno     = S_Resno
sainfo.jurname   = S_SANAME
sainfo.president = S_PRESIDENT

OpenWithParm(w_pip5010_popup, sainfo)

sainfo = Message.PowerObjectParm
S_SAUPNO    = sainfo.saupno   
S_Resno     = sainfo.jurno    
S_SANAME    = sainfo.jurname  
S_PRESIDENT = sainfo.president

IF s_saupno = 'cancel' THEN return false

ls_recordtag	= 'A'
ls_datatag		= '22'
is_taxoffice	= soffcode  //�������ڵ� 
is_hometaxid   = is_hometaxid + Space(20 - Len(is_hometaxid))  //Ȩ�ý� id
ls_submitdate	= idt_submitdate
ls_submittag	= '2'			// 1:�����븮��, 2:����, 3:����
ls_space6		= Space(6)  //�����븮�� ������ȣ
is_phoneno		= s_ddd + Space(15 - Len(s_ddd)) //��ȭ��ȣ
is_residentno  = S_Resno				//���ι�ȣ
ls_b_cnt			= '00001'						
ls_korean_kind = '101'							
ls_updatecode	= Space(1)
ls_emptySpace	= Space(291)

ls_dept        = trim(dw_ip.GetitemString(1,'deptname'))
ls_dept        = ls_dept + Space(30 - Len(ls_dept))
ls_empname     = trim(dw_ip.GetitemString(1,'empname'))
ls_empname     = ls_empname + Space(30 - Len(ls_empname))
ls_tel         = trim(dw_ip.GetitemString(1,'telno'))
ls_tel         = ls_tel + Space(15 - Len(ls_tel))


if isNull(s_saupno) then 
	is_businessno = Space(10)  //����ڹ�ȣ
else	
	if Len(s_saupno) > 10 then
		is_businessno = left(s_saupno, 10)
	else
		is_businessno = s_saupno + Space(10 - Len(s_saupno))
	end if
end if

if isNull(s_Resno) then 
	is_residentno = Space(13)  //���ι�ȣ
else	
	if Len(s_Resno) > 13 then
		is_residentno = left(s_Resno, 13)
	else
		is_residentno = s_Resno + Space(13 - Len(s_Resno))
	end if
end if

if isNull(s_saname) then 
	is_businessname = Space(40)//���θ�
else
	if Len(s_saname) > 40 then
		is_businessname = left(s_saname, 40)
	else
		is_businessname = s_saname + Space(40 - Len(s_saname))
	end if
end if

if isNull(s_president) then
	is_president = Space(30)//��ǥ�ڸ�
else	
	if Len(s_president) > 30 then
		is_president = left(s_president, 30)
	else
		is_president = s_president + Space(30 - Len(s_president))
	end if
end if

if isNull(s_zip) then
	is_zipcode = Space(10)//�����ȣ
else	
	if Len(s_zip) > 10 then
		is_zipcode = left(s_zip, 10)
	else
		is_zipcode = s_zip + Space(10 - Len(s_zip))
	end if
end if
if isNull(s_addr) then
	is_address = Space(70)//������
else	
	if Len(s_addr) > 70 then
		is_address = left(s_addr, 70)
	else
		is_address = s_addr + Space(70 - Len(s_addr))
	end if
end if	
//�ڷ������ȣ
ls_record = ls_recordtag + ls_datatag + is_taxoffice + ls_submitdate
//������(�븮��)
ls_record = ls_record + ls_submittag + ls_space6
ls_record = ls_record + is_hometaxid  //Ȩ�ý� id
ls_record = ls_record + '9000'       //��Ÿ���α׷�
ls_record = ls_record + is_businessno + is_businessname //����ڹ�ȣ,���θ� //+ is_residentno
ls_record = ls_record + ls_dept + ls_empname + ls_tel //�μ�,����,��ȭ
//ls_record = ls_record + is_president + + is_phoneno //is_zipcode + is_address

//���⳻��
ls_record = ls_record + ls_b_cnt
ls_record = ls_record + ls_korean_kind
//������Ⱓ�ڵ�
ls_record = ls_record + is_termtag
//����
ls_record = ls_record + ls_emptySpace

int li_len
li_len = FileWrite(ii_fileid, ls_record)
if li_len <> 470 then
	MessageBox("����Ÿ ����", "���ڵ� ���� : "+string(li_len)+"~rwf_write_a_record�� Ȯ���Ͻʽÿ�.")
	return false
end if

return true

end function

public function boolean wf_write_b_record ();
long		ll_submitCnt
double	ld_totsum, ld_tottax
string	ls_recordtag, ls_datatag, ls_seq
string	ls_record

ls_recordtag	= 'B'
ls_datatag		= '22'
ls_seq			= '000001'

ls_record = ls_recordtag + ls_datatag + is_taxoffice + ls_seq
ls_record = ls_record + is_businessno + is_businessname + is_president
ls_record = ls_record + is_residentno

select count(*) into :ll_submitCnt
	from	p3_retirementpay a, p1_master b, p0_dept c
	where	a.companycode	= b.companycode
	  and b.companycode	= c.companycode
	  and b.deptcode		= c.deptcode
	  and a.empno			= b.empno
	  and a.companycode	= :gs_company
	  and c.saupcd       like :is_saupcd
	  and a.todate	>= :idt_workyear
	  and a.todate	<= :idt_workyear2
;
if sqlca.sqlcode = -1 then
	MessageBox("wf_write_b_record_1", sqlca.sqlerrtext)
	return false
end if
ls_record = ls_record + string(ll_submitCnt, '0000000')

select count(*) into :ll_submitCnt
	from	p3_previousretirementpay a, p1_master b
	where	a.companycode	= b.companycode
	  and a.empno			= b.empno
	  and a.companycode  = :gs_company
	  and a.retiredate	>= :idt_workyear
	  and a.retiredate	<= :idt_workyear2 
;
if sqlca.sqlcode = -1 then
	MessageBox("wf_write_b_record_2", sqlca.sqlerrtext)
	return false
end if
ls_record = ls_record + string(ll_submitCnt, '0000000')

select sum(a.retiretotalamt) into :ld_totsum
	from	p3_retirementpay a, p1_master b, p0_dept c
	where	a.companycode	= b.companycode
	  and b.companycode	= c.companycode
	  and b.deptcode		= c.deptcode
	  and a.empno			= b.empno
	  and a.companycode	= :gs_company
	  and c.saupcd       like :is_saupcd
	  and a.todate	>= :idt_workyear
	  and a.todate	<= :idt_workyear2
;
if sqlca.sqlcode = -1 then
	MessageBox("wf_write_b_record_3", sqlca.sqlerrtext)
	return false
end if
ls_record = ls_record + string(ld_totsum, '00000000000000') //�ҵ�ݾ� �Ѱ�

select sum(a.resultincometax) into :ld_totsum
	from	p3_retirementpay a, p1_master b, p0_dept c
	where	a.companycode	= b.companycode
	  and b.companycode	= c.companycode
	  and b.deptcode		= c.deptcode
	  and a.empno			= b.empno
	  and a.companycode	= :gs_company
	  and c.saupcd       like :is_saupcd
	  and a.todate	>= :idt_workyear
	  and a.todate	<= :idt_workyear2
;
if sqlca.sqlcode = -1 then
	MessageBox("wf_write_b_record_4", sqlca.sqlerrtext)
	return false
end if
ls_record = ls_record + string(ld_totsum, '0000000000000') //�ҵ漼 �������� �Ѱ�
ld_tottax = ld_totsum
ls_record = ls_record + '0000000000000'	                 //���μ� �������� �Ѱ�

select sum(a.resultresidenttax) into :ld_totsum
	from	p3_retirementpay a, p1_master b, p0_dept c
	where	a.companycode	= b.companycode
	  and b.companycode	= c.companycode
	  and b.deptcode		= c.deptcode
	  and a.empno			= b.empno
	  and a.companycode	= :gs_company
	  and c.saupcd       like :is_saupcd
	  and a.todate	>= :idt_workyear
	  and a.todate	<= :idt_workyear2
;
if sqlca.sqlcode = -1 then
	MessageBox("wf_write_b_record_5", sqlca.sqlerrtext)
	return false
end if
ls_record = ls_record + string(ld_totsum, '0000000000000')  //�ֹμ� �������� �Ѱ�
ld_tottax = ld_tottax + ld_totsum
ls_record = ls_record + '0000000000000'                  	//��Ư�� �������� �Ѱ�

ls_record = ls_record + string(ld_tottax, '0000000000000')  //�������� �Ѱ�
ls_record = ls_record + Space(272)

int li_len
li_len = FileWrite(ii_fileid, ls_record)
if li_len <> 470 then
	MessageBox("����Ÿ ����", "���ڵ� ���� : "+string(li_len)+"~rwf_write_b_record�� Ȯ���Ͻʽÿ�.")
	return false
end if

return true

end function

public function boolean wf_write_c_record (long al_row);
long		ll_cnt, ll_serviceyears, ll_servicemonths, ll_servicedays, ll_findrow, ll_dupmonth, ll_seackper
long		ll_tot_serviceyears, ll_tot_servicemonths, ll_tot_dupmonth, ll_workyear
string	ls_recordtag, ls_datatag, ls_address, ls_fromdate, ls_todate, ls_inout
string	ls_record, ls_empno, ls_empname, ls_residentno, ls_zipcode1
STRING	ldt_enterdate, ldt_retiredate, ldt_prev_enterdate, ldt_prev_retiredate
double	ld_retirementpay, ld_honorretirepay, ld_groupretireinsurance
double	ld_retiretotalamt, ld_resultincometax, ls_resultresidenttax
double	ld_prev_resultincometax, ld_prev_resultresidenttax, ld_tot_prevtax
double	ld_tot_resultincometax, ld_tot_resultresidenttax
double	ld_retireincomeearnamt, ld_incomesub, ld_taxablestandardamt
double	ld_outputtax, ld_outputtax_year, ld_incomespecialsub, ld_incometaxsub
double	ld_tot_resulttax, ld_resultresidenttax, ld_hando

il_c_seq++
il_d_seq			= 0
ls_recordtag	= 'C'
ls_datatag 		= '22'

ls_record = ls_recordtag + ls_datatag + is_taxoffice
ls_record = ls_record + string(il_c_seq, '000000') + is_businessno

ls_empno = dw_1.GetItemString(al_row, "empno")
select count(a.empno) into :ll_cnt
	from	p3_previousretirementpay a, p1_master b, p0_dept c
 where b.companycode	= c.companycode
   and a.empno			= b.empno
   and b.deptcode     = c.deptcode
   and c.saupcd       like :is_saupcd
   and a.companycode = :gs_company
   and a.empno			= :ls_empno ;

if sqlca.sqlcode = -1 then
	MessageBox("wf_write_c_record_1", sqlca.sqlerrtext)
	return false
end if
if isNull(ll_cnt) then ll_cnt = 0
il_prevCnt = ll_cnt
ls_record = ls_record + string(ll_cnt, '00')

ls_record = ls_record + '1'	// ������ ���� �ڵ�

ls_record = ls_record + space(2)	// �������� �ڵ�

ls_fromdate = dw_1.GetItemString(al_row, "fromdate")
ls_todate   = dw_1.GetItemString(al_row, "todate")

if ls_fromdate < idt_workyear then ls_fromdate = idt_workyear

ls_record = ls_record + ls_fromdate
ls_record = ls_record + ls_todate
//ls_record = ls_record + idt_workyear
//ls_record = ls_record + idt_workyear2

ls_empname = dw_1.GetItemString(al_row, "empname")
if Len(ls_empname) > 30 then
	ls_empname = left(ls_empname, 30)
else
	ls_empname = ls_empname + Space(30 - Len(ls_empname))
end if
ls_record = ls_record + ls_empname
ls_inout = dw_1.GetItemString(al_row, "inout")
if ls_inout = '2' then 
	ls_inout = '9'
else
	ls_inout = '1'
end if
ls_record = ls_record + ls_inout	// ����/�ܱ��� �����ڵ�

ls_residentno = dw_1.GetItemString(al_row, "residentno")
if Len(ls_residentno) > 13 then
	ls_residentno = left(ls_residentno, 13)
else
	ls_residentno = ls_residentno + Space(13 - Len(ls_residentno))
end if
ls_record = ls_record + ls_residentno

ld_retirementpay = dw_1.GetItemNumber(al_row, "retirementpay1")  //�����޿�
if isNull(ld_retirementpay) then ld_retirementpay = 0
ls_record = ls_record + string(ld_retirementpay, '0000000000')

ld_honorretirepay = dw_1.GetItemNumber(al_row, "honorretirepay") //����������
if isNull(ld_honorretirepay) then ld_honorretirepay = 0
ls_record = ls_record + string(ld_honorretirepay, '0000000000')

//ld_groupretireinsurance = dw_1.GetItemNumber(al_row, "groupretireinsurance") //���������
//if isNull(ld_groupretireinsurance) then ld_groupretireinsurance = 0
//ls_record = ls_record + string(ld_groupretireinsurance, '0000000000')

//���������Ͻñ�(10)
ls_record = ls_record + '0000000000'

ld_retiretotalamt = dw_1.GetItemNumber(al_row, "retiretotalamt")   //��
if isNull(ld_retiretotalamt) then ld_retiretotalamt = 0
ls_record = ls_record + string(ld_retiretotalamt, '0000000000')

//������ҵ�(10)
ls_record = ls_record + '0000000000'

//[�������ݸ�]
//�Ѽ��ɾ�(10)
ls_record = ls_record + '0000000000'
//�������հ��(10)
ls_record = ls_record + '0000000000'
//�ҵ��ں��Ծ�(10)
ls_record = ls_record + '0000000000'
//�������ݼҵ������(10)
ls_record = ls_record + '0000000000'
//���������Ͻñ�(10)
ls_record = ls_record + '0000000000'

//[����ȯ���]
//���������Ͻñ����޿����(10)
ls_record = ls_record + '0000000000'
//���Ͻñ�(10)
ls_record = ls_record + '0000000000'
//���ɰ��������޿���(10)
ls_record = ls_record + '0000000000'
//ȯ�������ҵ����(10)
ls_record = ls_record + '0000000000'
//ȯ�������ҵ���� ����ǥ��(10)
ls_record = ls_record + '0000000000'
//ȯ�꿬��հ���ǥ��(10)
ls_record = ls_record + '0000000000'
//ȯ�꿬��ջ��⼼��(10)
ls_record = ls_record + '0000000000'

//[�ټӿ���]
ldt_enterdate = dw_1.GetItemSTRING(al_row, "fromdate") //�Ի���
ldt_retiredate = dw_1.GetItemSTRING(al_row, "todate")  //�����
ls_record = ls_record + ldt_enterdate
ls_record = ls_record +ldt_retiredate

ll_serviceyears  = dw_1.GetItemNumber(al_row, "serviceyears")
ll_servicemonths = dw_1.GetItemNumber(al_row, "servicemonths")
ll_servicedays   = dw_1.GetItemNumber(al_row, "servicedays")
if isNull(ll_serviceyears) then ll_serviceyears = 0
if isNull(ll_servicemonths) then ll_servicemonths = 0
if isNull(ll_servicedays) then ll_servicedays = 0

//if ll_servicemonths = 0 and ll_servicedays > 0 then ll_servicemonths += 1

ll_servicemonths = ll_serviceyears * 12 + ll_servicemonths
ls_record = ls_record + string(ll_servicemonths, '0000')   //�ټӿ���

//���ܿ���(4)
ls_record = ls_record + '0000'                             //���ܿ��� 

ll_findrow = dw_2.find("empno = " + "'" + ls_empno + "'", 1, dw_2.RowCount())

if ll_findrow > 0 then

	ldt_prev_enterdate = dw_2.GetItemSTRING(ll_findrow, "enterdate")  //���ٹ��� �Ի���
	if isNull(ldt_prev_enterdate) then
		ls_record = ls_record + '00000000'
	else
		ls_record = ls_record + ldt_prev_enterdate
	end if
	
	ldt_prev_retiredate = dw_2.GetItemSTRING(ll_findrow, "retiredate")  //���ٹ��� �����
	if isNull(ldt_prev_retiredate) then
		ls_record = ls_record + '00000000'
	else
		ls_record = ls_record + ldt_prev_retiredate
	end if

	ll_tot_serviceyears = 0
	ll_tot_servicemonths = 0
	ll_tot_dupmonth = 0
	ld_tot_resultincometax = 0
	ld_tot_resultresidenttax = 0
	do while ll_findrow > 0
		ll_serviceyears = dw_2.GetItemNumber(ll_findrow, "serviceyears")
		ll_servicemonths = dw_2.GetItemNumber(ll_findrow, "servicemonths")
		if isNull(ll_serviceyears) then ll_serviceyears = 0
		if isNull(ll_servicemonths) then ll_servicemonths = 0
		
		ll_tot_serviceyears = ll_tot_serviceyears + ll_serviceyears
		ll_tot_servicemonths = ll_tot_servicemonths + ll_servicemonths
		
		ll_dupmonth = dw_2.GetItemNumber(ll_findrow, "dupmonth")
		if isNull(ll_dupmonth) then ll_dupmonth = 0
		ll_tot_dupmonth = ll_tot_dupmonth + ll_dupmonth
		
		ld_prev_resultincometax = dw_2.GetItemNumber(ll_findrow, "resultincometax")
		if isNull(ld_prev_resultincometax) then ld_prev_resultincometax = 0
		ld_tot_resultincometax = ld_tot_resultincometax + ld_prev_resultincometax
		
		ld_prev_resultresidenttax = dw_2.GetItemNumber(ll_findrow, "resultresidenttax")
		if isNull(ld_prev_resultresidenttax) then ld_prev_resultresidenttax = 0
		ld_tot_resultresidenttax = ld_tot_resultresidenttax + ld_prev_resultresidenttax
		
		if ll_findrow < dw_2.RowCount() then
			ll_findrow = dw_2.Find("empno = " + "'" + ls_empno + "'", ll_findrow + 1, dw_2.RowCount())
		else
			ll_findrow = 0
		end if
	loop
	
	ll_tot_servicemonths = ll_tot_serviceyears * 12 + ll_tot_servicemonths
	ls_record = ls_record + string(ll_tot_servicemonths, '0000')  //���ٹ��� �ټӿ���
	//���ܿ���(4)
	ls_record = ls_record + '0000'                                //���ٹ��� ���ܿ���
	ls_record = ls_record + string(ll_tot_dupmonth, '0000')       //���ٹ��� �ߺ�����
	
else
	ls_record = ls_record + '00000000' + '00000000'     //���ٹ��� �Ի���, �����
	ls_record = ls_record + '0000'                      //���ٹ��� �ټӿ���
	//���ܿ���(4)
	ls_record = ls_record + '0000'                      //���ٹ��� ���ܿ���
	//�ߺ�����(4)
	ls_record = ls_record + '0000'                      //���ٹ��� �ߺ�����
	ld_tot_resultincometax = 0
	ld_tot_resultresidenttax = 0
end if

ll_workyear = dw_1.GetItemNumber(al_row, "workyear")
if isNull(ll_workyear) then ll_workyear = 0

ls_record = ls_record + string(ll_workyear, '00')									 //�ټӳ��


ld_retireincomeearnamt = dw_1.GetItemNumber(al_row, "retireincomeearnamt")  //�����޿���
if isNull(ld_retireincomeearnamt) then ld_retireincomeearnamt = 0
ls_record = ls_record + string(ld_retireincomeearnamt, '0000000000')


ld_incomespecialsub = dw_1.GetItemNumber(al_row, "incomespecialsub")       //�����ҵ�Ư��������
if isNull(ld_incomespecialsub) then ld_incomespecialsub = 0

ld_incomesub = dw_1.GetItemNumber(al_row, "incomesub")                     //�����ҵ������
if isNull(ld_incomesub) then ld_incomesub = 0
ld_incomesub = ld_incomespecialsub + ld_incomesub
if ld_incomesub > ld_retireincomeearnamt then ld_incomesub = ld_retireincomeearnamt
ls_record = ls_record + string(ld_incomesub, '0000000000')

ld_taxablestandardamt = dw_1.GetItemNumber(al_row, "taxablestandardamt")   //�����ҵ����ǥ��
if isNull(ld_taxablestandardamt) then ld_taxablestandardamt = 0
ls_record = ls_record + string(ld_taxablestandardamt, '0000000000')

ld_taxablestandardamt = truncate((ld_taxablestandardamt / ll_workyear), 0) //����հ���ǥ��
ls_record = ls_record + string(ld_taxablestandardamt, '0000000000')

ld_outputtax = dw_1.GetItemNumber(al_row, "outputtax")                    
if isNull(ld_outputtax) then ld_outputtax = 0
ld_outputtax_year = truncate((ld_outputtax / ll_workyear), 0)              //����ջ��⼼��
ls_record = ls_record + string(ld_outputtax_year, '0000000000')
ls_record = ls_record + string(ld_outputtax, '0000000000')                 //���⼼��

ls_record = ls_record + '0000000000'                           //����(�ܱ�����)����(2008��)

//ll_seackper = dw_1.GetItemNumber(al_row, "seackper") /*�����ҵ漼�װ�����*/
//if isNull(ll_seackper) then ll_seackper = 0
//ld_incometaxsub = truncate(ld_outputtax * ll_seackper /100, 0)
//ld_hando = 120000 * ll_workyear /*2004���� �����ѵ�*/
//
//if ld_incometaxsub > ld_hando then ld_incometaxsub = ld_hando
//ls_record = ls_record + string(ld_incometaxsub, '00000000')               //�����ҵ漼�װ���

ld_resultincometax = dw_1.GetItemNumber(al_row, "resultincometax")        //�ҵ漼
if isNull(ld_resultincometax) then ld_resultincometax = 0
ls_record = ls_record + string(ld_resultincometax, '0000000000')
ld_tot_resulttax = ld_resultincometax

ld_resultresidenttax = dw_1.GetItemNumber(al_row, "resultresidenttax")    //�ֹμ�
if isNull(ld_resultresidenttax) then ld_resultresidenttax = 0
ls_record = ls_record + string(ld_resultresidenttax, '0000000000')
ld_tot_resulttax = ld_tot_resulttax + ld_resultresidenttax

ls_record = ls_record + '0000000000'                                      //�����Ư����
ls_record = ls_record + string(ld_tot_resulttax, '0000000000')            //���װ�
ls_record = ls_record + string(ld_tot_resultincometax, '0000000000')      //���ٹ����ҵ漼 
ls_record = ls_record + string(ld_tot_resultresidenttax, '0000000000')    //���ٹ����ֹμ�
ls_record = ls_record + '0000000000'                                      //���ٹ�����Ư��

ld_tot_prevtax = ld_tot_resultincometax + ld_tot_resultresidenttax        //���ٹ������װ�
ls_record = ls_record + string(ld_tot_prevtax, '0000000000')

ls_record = ls_record + Space(9)

int li_len
li_len = FileWrite(ii_fileid, ls_record)
if li_len <> 470 then
	MessageBox("����Ÿ ����", "���ڵ� ���� : "+string(li_len)+"~rwf_write_c_record�� Ȯ���Ͻʽÿ�.")
	return false
end if

return true

end function

event open;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_ip.SetTransObject(sqlca)

dw_datetime.SetTransObject(sqlca)
dw_datetime.insertrow(0)
dw_ip.insertrow(0)

dw_saup.SetTransObject(sqlca)
dw_saup.insertrow(0)

f_set_saupcd(dw_saup,'saupcd','1')

is_saupcd = dw_saup.GetItemString(dw_saup.GetRow(), 'saupcd')
if is_saupcd = '' or isnull(is_saupcd) then is_saupcd = '%'

String semucode

  SELECT "P0_SYSCNFG"."DATANAME"  //�������ڵ�(ȯ�溯��)
    INTO :semucode  
    FROM "P0_SYSCNFG"  
   WHERE ( "P0_SYSCNFG"."SYSGU" = 'P' ) AND  
         ( "P0_SYSCNFG"."SERIAL" = 70 ) AND  
         ( "P0_SYSCNFG"."LINENO" = '1' )   ;

IF sqlca.sqlcode <> 0 THEN
  SELECT "SYSCNFG"."DATANAME"  //�������ڵ�(ȯ�溯��)
    INTO :semucode  
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'P' ) AND  
         ( "SYSCNFG"."SERIAL" = 70 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
END IF

IF Isnull(semucode) OR semucode = '' THEN semucode = ''

dw_ip.Setitem(1,'workdate', STRING(LONG(LEFT(f_today(),4)) - 1) +'0101')
dw_ip.Setitem(1,'workdate2', STRING(LONG(LEFT(f_today(),4)) - 1) +'1231')

dw_ip.Setitem(1,'jdate', f_today())
dw_ip.Setitem(1,'semuseo', semucode)


string ls_deptname, ls_empname

select a.empname, b.deptname
into  :ls_empname, :ls_deptname
from p1_master a, p0_dept b
where a.deptcode = b.deptcode and
      a.empno = :gs_empno;
		
dw_ip.Setitem(1,'deptname', ls_deptname)
dw_ip.Setitem(1,'empname', ls_empname)

event ue_filename()
		
//if sqlca.sqlcode <> 0 then
//	
//	 SELECT "SYSCNFG"."DATANAME"  //����ڹ�ȣ
//    INTO :SAUPNO  
//    FROM "SYSCNFG"  
//   WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
//         ( "SYSCNFG"."SERIAL" = 1 )  AND
//			( "SYSCNFG"."LINENO" = '2' )  ;
//			
//end if
//								 
//								 
//sle_filepath.text = 'C:\C'+left(saupno,3)+mid(saupno,5,2)+mid(saupno,8,2)+'.'+right(saupno,3)
end event

on w_pip5011.create
if this.MenuName = "m_shortcut" then this.MenuID = create m_shortcut
this.dw_saup=create dw_saup
this.dw_ip=create dw_ip
this.st_6=create st_6
this.rr_1=create rr_1
this.p_1=create p_1
this.p_exit=create p_exit
this.dw_2=create dw_2
this.dw_1=create dw_1
this.cb_exit=create cb_exit
this.sle_msg=create sle_msg
this.dw_datetime=create dw_datetime
this.st_10=create st_10
this.pb_1=create pb_1
this.gb_3=create gb_3
this.gb_10=create gb_10
this.rr_2=create rr_2
this.Control[]={this.dw_saup,&
this.dw_ip,&
this.st_6,&
this.rr_1,&
this.p_1,&
this.p_exit,&
this.dw_2,&
this.dw_1,&
this.cb_exit,&
this.sle_msg,&
this.dw_datetime,&
this.st_10,&
this.pb_1,&
this.gb_3,&
this.gb_10,&
this.rr_2}
end on

on w_pip5011.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_saup)
destroy(this.dw_ip)
destroy(this.st_6)
destroy(this.rr_1)
destroy(this.p_1)
destroy(this.p_exit)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.cb_exit)
destroy(this.sle_msg)
destroy(this.dw_datetime)
destroy(this.st_10)
destroy(this.pb_1)
destroy(this.gb_3)
destroy(this.gb_10)
destroy(this.rr_2)
end on

event key;Choose Case key
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type dw_saup from datawindow within w_pip5011
integer x = 1998
integer y = 168
integer width = 681
integer height = 88
integer taborder = 90
string title = "none"
string dataobject = "d_saup_jung"
boolean border = false
boolean livescroll = true
end type

event itemchanged;call super::itemchanged;this.AcceptText()

IF this.GetColumnName() ="saupcd" THEN 
   is_saupcd = this.GetText()
	IF trim(is_saupcd) = '' OR ISNULL(is_saupcd) THEN is_saupcd = '%'
	parent.event ue_filename()
END IF
end event

type dw_ip from datawindow within w_pip5011
event ue_pressenter pbm_dwnprocessenter
integer x = 1390
integer y = 564
integer width = 2025
integer height = 1056
integer taborder = 90
string title = "none"
string dataobject = "d_pip5011_3"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemfocuschanged;if dwo.name = 'deptname' or dwo.name = 'empname' then
	f_toggle_kor(handle(parent))
else
	f_toggle_eng(handle(parent))
end if
end event

type st_6 from statictext within w_pip5011
integer x = 1335
integer y = 440
integer width = 672
integer height = 64
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 8388608
long backcolor = 32106727
string text = "����Ÿ ���� ����"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pip5011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1248
integer y = 472
integer width = 2181
integer height = 1252
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_1 from uo_picture within w_pip5011
integer x = 4219
integer y = 24
integer width = 178
string pointer = ""
string picturename = "C:\erpman\image\�ڷ����_up.gif"
end type

event clicked;call super::clicked;long	ll_cnt, ll_rowcnt, ll_row

dw_ip.AcceptText()

// �ͼӳ⵵ ����, ������ ���ذ�
//if rb_half.checked = true then
	is_termtag = '1'
//else
//	is_termtag = '2'
//end if

// ��������
if f_datechk(dw_ip.GetitemString(1,'jdate')) = -1 then
	MessageBox("Ȯ ��", "�Էµ� �������ڰ� �ùٸ��� �ʽ��ϴ�.")
	dw_ip.SetColumn('jdate')
	dw_ip.SetFocus()
	return
end if
idt_submitdate = dw_ip.GetitemString(1,'jdate')

// �������ڵ�
soffcode = trim(dw_ip.GetitemString(1,'semuseo'))
if soffcode= '' or isnull(soffcode)  then
	MessageBox("Ȯ ��", "�������ڵ尡  �Էµ��� �ʾҽ��ϴ�.")
	dw_ip.SetColumn('semuseo')
	dw_ip.SetFocus()
	return
end if

//Ȩ�ý�id
is_hometaxid = trim(dw_ip.GetitemString(1,'hometaxid'))
if is_hometaxid= '' or isnull(is_hometaxid)  then
	MessageBox("Ȯ ��", "Ȩ�ý� ID�� �Էµ��� �ʾҽ��ϴ�.")
	dw_ip.SetColumn('hometaxid')
	dw_ip.SetFocus()
	return
end if

//�������ȭ��ȣ
is_phoneno = trim(dw_ip.GetitemString(1,'telno'))
if is_phoneno= '' or isnull(is_phoneno)  then
	MessageBox("Ȯ ��", "����� ��ȭ��ȣ�� �Էµ��� �ʾҽ��ϴ�.")
	dw_ip.SetColumn('telno')
	dw_ip.SetFocus()
	return
end if

// ����ȭ�� �̸�
if Len(trim(dw_ip.GetitemString(1,'spath'))) < 1 then
	MessageBox("Ȯ ��", "����ȭ�� �̸��� �Էµ��� �ʾҽ��ϴ�.")
	dw_ip.SetColumn('spath')
	dw_ip.SetFocus()
	return
end if
is_filepath = dw_ip.GetitemString(1,'spath')

// �ͼ�������
idt_workyear = dw_ip.GetitemString(1,'workdate')
idt_workyear2 = dw_ip.GetitemString(1,'workdate2')

if f_DateChk(idt_workyear) = -1 or f_DateChk(idt_workyear2) = -1 &
		or idt_workyear > idt_workyear2 then
	MessageBox("�Է� ����", "�Էµ� �ͼ�����Ⱓ�� �ùٸ��� �ʽ��ϴ�.")
	return
end if


select count(*) into :ll_cnt
	from	p3_retirementpay a, p1_master b, p0_dept c
	where	a.companycode	= b.companycode
	  and b.companycode	= c.companycode
	  and a.empno			= b.empno
	  and b.deptcode     = c.deptcode
	  and c.saupcd       like :is_saupcd
	  and a.companycode	= :gs_company
	  and a.todate			>= :idt_workyear
	  and a.todate			<= :idt_workyear2
;
if sqlca.sqlcode <> 0 then
	MessageBox("ue_process(w_make_acntdata)", sqlca.sqlerrtext)
	return
elseif ll_cnt < 1 then
	MessageBox("����Ÿ ����", "�������� �۾��� ���� �����Ͻʽÿ�.")
	return
end if

SetPointer(HourGlass!)

// ȭ�� Open
if not wf_fileOpen() then
	SetPointer(Arrow!)
	return
end if

// A_record Write
if not wf_write_A_record() then
	SetPointer(Arrow!)
	FileClose(ii_fileID)
	return
end if

// B_record Write
if not wf_write_B_record() then
	SetPointer(Arrow!)
	FileClose(ii_fileID)
	return
end if

SetPointer(HourGlass!)
dw_1.Retrieve(gs_company, idt_workyear, idt_workyear2, is_saupcd)
dw_2.Retrieve(gs_company, idt_workyear, idt_workyear2, is_saupcd)

il_c_seq = 0
ll_rowcnt = dw_1.RowCount()
for ll_row = 1 to ll_rowcnt
   w_mdi_frame.sle_msg.text = string(ll_row )+'�� �۾���......!!'
	il_prevCnt = 0
	// C_record Write
	if not wf_write_C_record(ll_row) then
		SetPointer(Arrow!)
		FileClose(ii_fileID)
		return
	end if

	if il_prevCnt < 1 then continue
	// D_record Write
	if not wf_write_D_record(ll_row) then
		SetPointer(Arrow!)
		FileClose(ii_fileID)
		return
	end if
next

FileClose(ii_fileID)
w_mdi_frame.sle_msg.text = "���������� �۾��� ����Ǿ����ϴ�.!!       [�۾� �ο� : " + string(ll_rowcnt) + "��]"
SetPointer(Arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ڷ����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ڷ����_up.gif"
end event

type p_exit from uo_picture within w_pip5011
integer x = 4398
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\�ݱ�_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ݱ�_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ݱ�_up.gif"
end event

type dw_2 from datawindow within w_pip5011
boolean visible = false
integer x = 1952
integer y = 1916
integer width = 649
integer height = 92
boolean titlebar = true
string title = "���ڵ�D"
string dataobject = "d_pip5011_2"
boolean livescroll = true
end type

type dw_1 from datawindow within w_pip5011
boolean visible = false
integer x = 1947
integer y = 1820
integer width = 654
integer height = 92
boolean titlebar = true
string title = "���ڵ�C"
string dataobject = "d_pip5011_1"
boolean livescroll = true
end type

type cb_exit from commandbutton within w_pip5011
event clicked pbm_bnclicked
boolean visible = false
integer x = 2912
integer y = 2960
integer width = 498
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "����(&X)"
end type

event clicked;//SLE_MSG.TEXT = ""
//Close(PARENT)
end event

type sle_msg from singlelineedit within w_pip5011
boolean visible = false
integer x = 375
integer y = 3156
integer width = 2482
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 12632256
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type dw_datetime from datawindow within w_pip5011
boolean visible = false
integer x = 2857
integer y = 3156
integer width = 750
integer height = 92
string dataobject = "d_datetime"
boolean border = false
boolean livescroll = true
end type

type st_10 from statictext within w_pip5011
boolean visible = false
integer x = 46
integer y = 3156
integer width = 325
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 128
long backcolor = 12632256
boolean enabled = false
string text = "�޼���"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_pip5011
event clicked pbm_bnclicked
boolean visible = false
integer x = 2395
integer y = 2960
integer width = 498
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
string text = "�ڷ����(&E)"
vtextalign vtextalign = vcenter!
end type

event clicked;//long	ll_cnt, ll_rowcnt, ll_row
//
//// �ͼӳ⵵ ����, ������ ���ذ�
////if rb_half.checked = true then
////	is_termtag = '1'
////else
//	is_termtag = '2'
////end if
//
//// ��������
//if not IsDate(em_date.text) then
//	MessageBox("�Է� ����", "�Էµ� �������ڰ� �ùٸ��� �ʽ��ϴ�.")
//	return
//end if
//idt_submitdate = string(date(em_date.text),"yyyymmdd")
//
//// �ͼ�������
//if not IsDate(em_workyear.text) or not IsDate(em_workyear2.text) &
//		or date(em_workyear.text) > date(em_workyear2.text) then
//	MessageBox("�Է� ����", "�Էµ� �ͼ�����Ⱓ�� �ùٸ��� �ʽ��ϴ�.")
//	return
//end if
//idt_workyear = string(date(em_workyear.text),"yyyymmdd")
//idt_workyear2 = string(date(em_workyear2.text),"yyyymmdd")
//
//// ������ �̸�
//is_taxoffice = trim(sle_offcode.text)
//
//// ����ȭ�� �̸�
//if Len(sle_filepath.text) < 1 then
//	MessageBox("�Է� ����", "����ȭ�� �̸��� �Էµ��� �ʾҽ��ϴ�.")
//	return
//end if
//
//is_filepath = sle_filepath.text
//
//select count(*) into :ll_cnt
//	from	p3_retirementpay a, p1_master b
//	where	a.companycode	= b.companycode
//	  and a.empno			= b.empno
//	  and a.companycode	= :gs_company
//	  and b.retiredate	>= :idt_workyear
//	  and b.retiredate	<= :idt_workyear2
//;
//if sqlca.sqlcode <> 0 then
//	MessageBox("ue_process(w_make_acntdata)", sqlca.sqlerrtext)
//	return
//elseif ll_cnt < 1 then
//	MessageBox("����Ÿ ����", "�������� �۾��� ���� �����Ͻʽÿ�.")
//	return
//end if
//
//SetPointer(HourGlass!)
//
//// ȭ�� Open
//if not wf_fileOpen() then
//	SetPointer(Arrow!)
//	return
//end if
//
//// A_record Write
//if not wf_write_A_record() then
//	SetPointer(Arrow!)
//	FileClose(ii_fileID)
//	return
//end if
//
//// B_record Write
//if not wf_write_B_record() then
//	SetPointer(Arrow!)
//	FileClose(ii_fileID)
//	return
//end if
//
//dw_1.Retrieve(gs_company, idt_workyear, idt_workyear2)
//dw_2.Retrieve(gs_company, idt_workyear, idt_workyear2)
//
//il_c_seq = 0
//ll_rowcnt = dw_1.RowCount()
//for ll_row = 1 to ll_rowcnt
//
//	il_prevCnt = 0
//	// C_record Write
//	if not wf_write_C_record(ll_row) then
//		SetPointer(Arrow!)
//		FileClose(ii_fileID)
//		return
//	end if
//
//	if il_prevCnt < 1 then continue
//	// D_record Write
//	if not wf_write_D_record(ll_row) then
//		SetPointer(Arrow!)
//		FileClose(ii_fileID)
//		return
//	end if
//next
//
//FileClose(ii_fileID)
//sle_msg.text = "���������� �۾��� ����Ǿ����ϴ�.!!"
//
//SetPointer(Arrow!)
//
end event

type gb_3 from groupbox within w_pip5011
boolean visible = false
integer x = 2331
integer y = 2900
integer width = 1143
integer height = 200
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 12632256
end type

type gb_10 from groupbox within w_pip5011
boolean visible = false
integer x = 27
integer y = 3100
integer width = 3589
integer height = 152
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
end type

type rr_2 from roundrectangle within w_pip5011
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1943
integer y = 140
integer width = 791
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

