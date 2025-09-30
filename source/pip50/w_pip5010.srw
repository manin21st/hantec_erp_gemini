$PBExportHeader$w_pip5010.srw
$PBExportComments$** ���� �Ű� �ڷ� ����
forward
global type w_pip5010 from w_inherite_standard
end type
type dw_saup from datawindow within w_pip5010
end type
type dw_3 from datawindow within w_pip5010
end type
type cbx_1 from checkbox within w_pip5010
end type
type dw_1 from datawindow within w_pip5010
end type
type dw_2 from datawindow within w_pip5010
end type
type st_6 from statictext within w_pip5010
end type
type rr_1 from roundrectangle within w_pip5010
end type
type rr_2 from roundrectangle within w_pip5010
end type
type p_1 from uo_picture within w_pip5010
end type
type dw_ip from u_key_enter within w_pip5010
end type
type rb_half from radiobutton within w_pip5010
end type
type rb_all from radiobutton within w_pip5010
end type
type dw_4 from datawindow within w_pip5010
end type
type dw_5 from datawindow within w_pip5010
end type
type gb_3 from groupbox within w_pip5010
end type
end forward

global type w_pip5010 from w_inherite_standard
string title = "���ٽŰ��ڷ����"
event ue_filename ( )
dw_saup dw_saup
dw_3 dw_3
cbx_1 cbx_1
dw_1 dw_1
dw_2 dw_2
st_6 st_6
rr_1 rr_1
rr_2 rr_2
p_1 p_1
dw_ip dw_ip
rb_half rb_half
rb_all rb_all
dw_4 dw_4
dw_5 dw_5
gb_3 gb_3
end type
global w_pip5010 w_pip5010

type variables
// �Է¹޴� ����Ÿ
string		is_termtag
string		is_filepath
string		idt_submitdate
string		idt_workyear,idt_workmm

int		   ii_fileID
string		is_businessno, is_businessname
string		is_president,  is_residentno
string		is_zipcode, is_address
string		is_phoneno
string		is_taxoffice

long		il_c_seq, il_d_seq
long		il_prevCnt
string   soffcode  /*�������ڵ�*/
string   is_hometaxid

end variables

forward prototypes
public function boolean wf_fileopen (integer ai_gbn)
public function boolean wf_write_c_record (long al_row)
public function boolean wf_write_a_record ()
public function boolean wf_write_b_record ()
public function boolean wf_write_d_record (long al_row)
public function boolean wf_write_e_record (long al_row)
public function boolean wf_medfile (long al_row)
public function boolean wf_donafile (long al_row)
end prototypes

event ue_filename();string saupno

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

select replace(:saupno,'-','') into :saupno from dual;

								 
dw_ip.Setitem(1,'spath','C:\EOSDATA\C'+left(saupno,7)+'.'+right(saupno,3))

end event

public function boolean wf_fileopen (integer ai_gbn);int	li_yesNo

choose case ai_gbn
	case 1
		if FileLength(is_filepath) <> -1 then
			li_yesNo = MessageBox("���� �����", "�̹� �ִ� ������ ������?", Question!, YesNo!, 2)
			if li_yesNo = 2 then return false
		end if
		
		ii_fileID = FileOpen(is_filePath, LineMode!, Write!, LockWrite!, Replace!)
		if ii_fileID = -1 then
			MessageBox("����,���� ����", "���Ϲ� ���������� �ùٸ��� Ȯ���Ͻʽÿ�.")
			return false
		end if
	case 2
		if FileLength(is_filepath) <> -1 then
			li_yesNo = MessageBox("���� �����", "�̹� �ִ� �Ƿ�������� ������?", Question!, YesNo!, 2)
			if li_yesNo = 2 then return false
		end if
		
		ii_fileID = FileOpen(is_filePath, LineMode!, Write!, LockWrite!, Replace!)
		if ii_fileID = -1 then
			MessageBox("�Ƿ������,���� ����", "���Ϲ� ���������� �ùٸ��� Ȯ���Ͻʽÿ�.")
			return false
		end if
	case 3
		if FileLength(is_filepath) <> -1 then
			li_yesNo = MessageBox("���� �����", "�̹� �ִ� ��α������� ������?", Question!, YesNo!, 2)
			if li_yesNo = 2 then return false
		end if
		
		ii_fileID = FileOpen(is_filePath, LineMode!, Write!, LockWrite!, Replace!)
		if ii_fileID = -1 then
			MessageBox("��α�����,���� ����", "���Ϲ� ���������� �ùٸ��� Ȯ���Ͻʽÿ�.")
			return false
		end if
end choose

return true

end function

public function boolean wf_write_c_record (long al_row);long		ll_cnt, ll_dependent20, ll_dependent60, ll_respect, ll_respect70,ll_political
long		ll_rubber, ll_childcount, ll_wedding, ll_johapsub, ll_urisajusub, ll_Tjotsub
long     ll_borncount
double	ld_paytotal, ld_bonustotal, ld_total, ld_foreignworkincome, ld_nightworkpay
double	ld_etctaxfree, ld_tottax, ld_finalmonthpay, ld_workincomegross
double	ld_workincomesub, ld_workincome, ld_basesub, ld_wifesub, ld_dependentsub
double	ld_respectsub, ld_rubbersub, ld_womanhouseholdersub, ld_childsub
double	ld_basicaddsub, ld_insurancesub, ld_medsub, ld_educationsub, ld_housesub
double	ld_pursesub, ld_tot40, ld_standardsub, ld_pensionsavingsub, ld_standardtaxamt
double   ld_engineeramt, ld_cdcardsub, ld_urisajusub, ld_cashbillsub
double	ld_calctaxsub, ld_workincometaxsub, ld_welthsavingtaxsub, ld_housechaip
double	ld_foreignpaidtaxsub, ld_tottaxsub, ld_incometaxlawsub, ld_relftaxlawsub
double	ld_totlawsub, ld_resultincometax, ld_resultspecialtax, ld_resultresidenttax
double	ld_totresulttax, ld_ssub, ld_chaincome, ld_pensub, ld_housesavesub,ld_fundsub
double	ld_previncometax, ld_prevspecialtax, ld_prevresidenttax, ld_totprevtax
double	ld_currincometax, ld_currspecialtax, ld_currresidenttax, ld_totcurrtax, ld_etcamt
double   ls_labsave, ld_pensioninsurance, ld_rubberinsurance, ld_longlabsub,ld_pensionsub2
double   ld_stockprofit, ld_penamt, ld_foreigntaxfree, ld_bontaxfree, ld_bornsub,ld_houselongsub
string	ls_recordtag, ls_datatag, ls_address,snation
string	ls_record, ls_empno, ls_empname, ls_residentno, ls_zipcode1, ls_inout
long kk

il_c_seq++
il_d_seq			= 0
ls_recordtag	= 'C'
ls_datatag 		= '20'
//�ڷ������ȣ
ls_record = ls_recordtag + ls_datatag + is_taxoffice
ls_record = ls_record + string(il_c_seq, '000000') 
//��õ¡���ǹ���
ls_record = ls_record + is_businessno

ls_empno = dw_1.GetItemString(al_row, "empno")

select count(*) into :ll_cnt
		from p3_acnt_prev_company
		where workyear		= :idt_workyear
		  and companycode = :gs_company
		  and empno			= :ls_empno
;
if sqlca.sqlcode = -1 then
	MessageBox("wf_write_c_record_1", sqlca.sqlerrtext)
	return false
end if
if isNull(ll_cnt) then ll_cnt = 0
il_prevCnt = ll_cnt
ls_record = ls_record + string(ll_cnt, '00')
string sretiredate, senterdate
select retiredate, enterdate into :sretiredate, :senterdate
from p1_master
where companycode = :gs_company and empno = :ls_empno;

ls_record = ls_record + '1'	// ������ ���� �ڵ�

select inout, nationcode into :ls_inout, :snation
from p1_master 
where empno = :ls_empno;

if IsNull(snation) or snation = '' then snation = 'KR'
//if snation = 'KR' then
	snation = space(2)
//end if

if IsNull(ls_inout) or ls_inout = '' then ls_inout = '1'

ls_record = ls_record + snation  //'���������ڵ��߰�'

ls_record = ls_record + '2'      //�ܱ��δ��ϼ������� '1', �ƴϸ� '2'



if left(senterdate,4) = idt_workyear then  /*�ߵ��Ի���*/
	ls_record = ls_record + senterdate
else
	ls_record = ls_record + idt_workyear + '0101'
end if	
																	  //�������̰ų�
if IsNull(sretiredate) or sretiredate = '' &   
	or left(sretiredate,4) > idt_workyear then        //����⵵ ������ ������
	ls_record = ls_record + idt_workyear + '1231'
else
	ls_record = ls_record + sretiredate
end if


kk = lena(ls_record)


ls_empname = dw_1.GetItemString(al_row, "empname")
if lena(ls_empname) > 30 then
	ls_empname = left(ls_empname, 30)
else
	ls_empname = ls_empname + Space(30 - lena(ls_empname))
end if

ls_record = ls_record + ls_empname
if ls_inout = '1' then
   ls_record = ls_record + '1'	// ����/�ܱ��� �����ڵ�
else
	ls_record = ls_record + '9'	// ����/�ܱ��� �����ڵ�
end if

ls_residentno = dw_1.GetItemString(al_row, "residentno")
if lena(ls_residentno) > 13 then
	ls_residentno = left(ls_residentno, 13)
else
	ls_residentno = ls_residentno + Space(13 - lena(ls_residentno))
end if
ls_record = ls_record + ls_residentno
kk = lena(ls_record)
//ls_zipcode1 = dw_1.GetItemString(al_row, "zipcode1")
//if isNull(ls_zipcode1) then ls_zipcode1 = Space(10)
//if lena(ls_zipcode1) > 10 then
//	ls_zipcode1 = left(ls_zipcode1, 10)
//else
//	ls_zipcode1 = ls_zipcode1 + Space(10 - Len(ls_zipcode1))
//end if
//ls_record = ls_record + ls_zipcode1
//
//ls_address = dw_1.GetItemString(al_row, "address")
//if isNull(ls_address) then ls_address = Space(70)
//if Len(ls_address) > 70 then
//	ls_address = left(ls_address, 70)
//else
//	ls_address = ls_address + Space(70 - Len(ls_address))
//end if
//ls_record = ls_record + ls_address

IF ls_inout = '1' THEN
	ls_record = ls_record + '0000000000000000' //�������� ����Ⱓ �ش���� ����
ELSEIF is_termtag = '1' THEN
	ls_record = ls_record + idt_workyear + '0101'
	if IsNull(sretiredate) or sretiredate = '' or long(sretiredate) > long(idt_workyear + '1231') then
   	ls_record = ls_record + idt_workyear + '1231'
	else
		ls_record = ls_record + sretiredate
	end if
ELSE
	ls_record = ls_record + idt_workyear + '0101'
	ls_record = ls_record + idt_workyear + '0630'
END IF


ld_paytotal = dw_1.GetItemNumber(al_row, "paytotal")              //�޿��Ѿ�
if isNull(ld_paytotal) then ld_paytotal = 0
ls_record = ls_record + string(ld_paytotal, '00000000000')
ld_total = ld_paytotal

ld_bonustotal = dw_1.GetItemNumber(al_row, "bonustotal")          //���Ѿ�
if isNull(ld_bonustotal) then ld_bonustotal = 0
ls_record = ls_record + string(ld_bonustotal, '00000000000')
ld_total = ld_total + ld_bonustotal

ld_incometaxlawsub = dw_1.GetItemNumber(al_row, 'injungbonusamt')   //������
if isNull(ld_incometaxlawsub) then ld_incometaxlawsub = 0
ls_record = ls_record + string(ld_incometaxlawsub, '00000000000')
ld_total = ld_total + ld_incometaxlawsub

ld_stockprofit = dw_1.GetItemNumber(al_row, 'stockprofit')   //�ֽĸż����ñ��������(2007)
if isNull(ld_stockprofit) then ld_stockprofit = 0
ls_record = ls_record + string(ld_stockprofit, '00000000000')

ld_total = ld_total + ld_stockprofit

ls_record = ls_record + string(ld_total, '00000000000')               //�ҵ��

ld_engineeramt = dw_1.GetItemNumber(al_row, "engineeramt")    //����Ȱ����(2008��)
if isNull(ld_engineeramt) then ld_engineeramt = 0
ls_record = ls_record + string(ld_engineeramt, '0000000000')
ld_tottax = ld_tottax + ld_engineeramt

ld_foreignworkincome = dw_1.GetItemNumber(al_row, "foreignworkincome") //���ܱٷμҵ�
if isNull(ld_foreignworkincome) then ld_foreignworkincome = 0
ls_record = ls_record + string(ld_foreignworkincome, '0000000000')
ld_tottax = ld_foreignworkincome

ld_nightworkpay = dw_1.GetItemNumber(al_row, "nightworkpay")    //�߰��ٷμ���
if isNull(ld_nightworkpay) then ld_nightworkpay = 0
ls_record = ls_record + string(ld_nightworkpay, '0000000000')
ld_tottax = ld_tottax + ld_nightworkpay

ld_bontaxfree = dw_1.GetItemNumber(al_row, "bornfaxfree")    //��꺸������(2008��)
if isNull(ld_bontaxfree) then ld_bontaxfree = 0
ls_record = ls_record + string(ld_bontaxfree, '0000000000')
ld_tottax = ld_tottax + ld_bontaxfree

ld_foreigntaxfree = dw_1.GetItemNumber(al_row, "foreigntaxfree")    //�ܱ��αٷ���(2008��)
if isNull(ld_foreigntaxfree) then ld_foreigntaxfree = 0
ls_record = ls_record + string(ld_foreigntaxfree, '0000000000')
ld_tottax = ld_tottax + ld_foreigntaxfree

ld_etctaxfree = dw_1.GetItemNumber(al_row, "etctaxfree")       //��Ÿ�����
if isNull(ld_etctaxfree) then ld_etctaxfree = 0

ls_record = ls_record + string(ld_etctaxfree, '0000000000')
ld_tottax = ld_tottax + ld_etctaxfree

ls_record = ls_record + string(ld_tottax, '0000000000')           //�������
kk = lena(ls_record)
//ld_finalmonthpay = dw_1.GetItemNumber(al_row, "finalmonthpay")
//if isNull(ld_finalmonthpay) then ld_finalmonthpay = 0
//ls_record = ls_record + string(ld_finalmonthpay, '0000000000')

ld_workincomegross = dw_1.GetItemNumber(al_row, "workincomegross")   //�ѱ޿�
if isNull(ld_workincomegross) then ld_workincomegross = 0
ls_record = ls_record + string(ld_workincomegross, '00000000000')

ld_workincomesub = dw_1.GetItemNumber(al_row, 'workincomesub')      //�ٷμҵ����
if isNull(ld_workincomesub) then ld_workincomesub = 0
ls_record = ls_record + string(ld_workincomesub, '0000000000')

ld_workincome = dw_1.GetItemNumber(al_row, 'workincome')            //�������ٷμҵ�ݾ�
if isNull(ld_workincome) then ld_workincome = 0
ls_record = ls_record + string(ld_workincome, '00000000000')

ld_basesub = dw_1.GetItemNumber(al_row, 'basesub')                 //���ΰ����ݾ�

if isNull(ld_basesub) then ld_basesub = 0
ls_record = ls_record + string(ld_basesub, '00000000')
ld_ssub = ld_ssub + ld_basesub

ld_wifesub = dw_1.GetItemNumber(al_row, 'wifesub')                //����ڰ����ݾ�
if isNull(ld_wifesub) then ld_wifesub = 0
ls_record = ls_record + string(ld_wifesub, '00000000')
ld_ssub = ld_ssub + ld_wifesub



ll_dependent60 = dw_1.GetItemNumber(al_row, 'dependent60')
if isNull(ll_dependent60) then ll_dependent60 = 0
ls_record = ls_record + string(ll_dependent60, '00')             //�ξ簡�������ο�

kk = lena(ls_record)
ld_dependentsub = dw_1.GetItemNumber(al_row, 'dependentsub')     //�ξ簡�������ݾ�
if isNull(ld_dependentsub) then ld_dependentsub = 0
ls_record = ls_record + string(ld_dependentsub, '00000000')
ld_ssub = ld_ssub + ld_dependentsub

ll_respect = dw_1.GetItemNumber(al_row, 'respect')
if isNull(ll_respect) then ll_respect = 0
ll_respect70 = dw_1.GetItemNumber(al_row, 'respect1')
if isNull(ll_respect70) then ll_respect70 = 0

ll_respect = ll_respect +ll_respect70 

ls_record = ls_record + string(ll_respect, '00')                //��ο������ο�

ld_respectsub = dw_1.GetItemNumber(al_row, 'respectsub')        //��ο������ݾ�
if isNull(ld_respectsub) then ld_respectsub = 0
ls_record = ls_record + string(ld_respectsub, '00000000')
ld_ssub = ld_ssub + ld_respectsub

ll_rubber = dw_1.GetItemNumber(al_row, 'rubber')               //����ڰ����ο�
if isNull(ll_rubber) then ll_rubber = 0
ls_record = ls_record + string(ll_rubber, '00')               

ld_rubbersub = dw_1.GetItemNumber(al_row, 'rubbersub')        //����ڰ����ݾ�
if isNull(ld_rubbersub) then ld_rubbersub = 0
ls_record = ls_record + string(ld_rubbersub, '00000000')
ld_ssub = ld_ssub + ld_rubbersub

ld_womanhouseholdersub = dw_1.GetItemNumber(al_row, 'womanhouseholdersub')  //�γ��ڰ����ݾ�
if isNull(ld_womanhouseholdersub) then ld_womanhouseholdersub = 0
ls_record = ls_record + string(ld_womanhouseholdersub, '00000000')
ld_ssub = ld_ssub + ld_womanhouseholdersub

ll_childcount = dw_1.GetItemNumber(al_row, 'childcount')         //�ڳ����������ο�

if isNull(ll_childcount) then ll_childcount = 0
ls_record = ls_record + string(ll_childcount, '00')

ld_childsub = dw_1.GetItemNumber(al_row, 'childsub')           //�ڳ����������ݾ�
if isNull(ld_childsub) then ld_childsub = 0
ls_record = ls_record + string(ld_childsub, '00000000')
ld_ssub = ld_ssub + ld_childsub


ll_borncount = long(dw_1.GetItemString(al_row, 'borncount'))        //����Ծ�����ο�(2008��)

if isNull(ll_borncount) then ll_borncount = 0
ls_record = ls_record + string(ll_borncount, '00')

ld_bornsub = dw_1.GetItemNumber(al_row, 'bornsub')           //����Ծ�����ݾ�(2008��)
if isNull(ld_bornsub) then ld_bornsub = 0
ls_record = ls_record + string(ld_bornsub, '00000000')
ld_ssub = ld_ssub + ld_bornsub

ls_record = ls_record + '0000000000'    //����(2008��)


ll_dependent20 = dw_1.GetItemNumber(al_row, 'dependent20')    //���ڳ��߰�����(2007)
if isNull(ll_dependent20) then ll_dependent20 = 0
if ll_dependent20 = 1 then ll_dependent20 = 0
ls_record = ls_record + string(ll_dependent20, '00')  

ld_basicaddsub = dw_1.GetItemNumber(al_row, 'basicaddsub')  //���ڳ��߰������ݾ�(2007)
if isNull(ld_basicaddsub) then ld_basicaddsub = 0
ls_record = ls_record + string(ld_basicaddsub, '00000000')
ld_ssub = ld_ssub + ld_basicaddsub


ld_penamt = dw_1.GetItemNumber(al_row, 'payemployee')   //���ο��ݺ�������(2007)
if isNull(ld_penamt) then ld_penamt = 0
ls_record = ls_record + string(ld_penamt, '0000000000')
ld_pensub = ld_pensub + ld_penamt


ld_pensub = dw_1.GetItemNumber(al_row, 'pensioninsurancesub')   //���ݺ�������
ld_penamt = dw_1.GetItemNumber(al_row, 'payemployee')   //���ο���(2007)
if isNull(ld_pensub) then ld_pensub = 0
ld_pensub = ld_pensub - ld_penamt

ls_record = ls_record + string(ld_pensub, '0000000000')  //��Ÿ���ݺ������(2008��)


ls_record = ls_record + '0000000000'                   //�������ݼҵ����(2007)

/*Ư������*/

ld_insurancesub = dw_1.GetItemNumber(al_row, 'insurancesub')   //��������(2008�� �ڸ�������)
if isNull(ld_insurancesub) then ld_insurancesub = 0
if ld_insurancesub < 0 then
	ls_record = ls_record + string(ld_insurancesub, '0000000000')
else
   ls_record = ls_record + string(ld_insurancesub, '0000000000')
end if
ld_medsub = dw_1.GetItemNumber(al_row, 'medsub')               //�Ƿ�����
if isNull(ld_medsub) then ld_medsub = 0
ls_record = ls_record + string(ld_medsub, '0000000000')

ld_educationsub = dw_1.GetItemNumber(al_row, 'educationsub')   //���������
if isNull(ld_educationsub) then ld_educationsub = 0
ls_record = ls_record + string(ld_educationsub, '00000000')
kk = lena(ls_record)

ld_housesub = dw_1.GetItemNumber(al_row, 'housesub')          //�����Ӵ������ӱݿ����ݻ�ȯ�����ݾ�(2008��)
if isNull(ld_housesub) then ld_housesub = 0
ls_record = ls_record + string(ld_housesub, '00000000')

ld_houselongsub = dw_1.GetItemNumber(al_row, 'houselongsub')   //��������������ӱ����ڻ�ȯ�����ݾ�(2008��)
if isNull(ld_houselongsub) then ld_houselongsub = 0
ls_record = ls_record + string(ld_houselongsub, '00000000')

ld_pursesub = dw_1.GetItemNumber(al_row, 'pursesub')         //��αݰ���
if isNull(ld_pursesub) then ld_pursesub = 0
ls_record = ls_record + string(ld_pursesub, '0000000000')

ll_wedding = dw_1.GetItemNumber(al_row, 'weddingetcsub')    //ȥ��,�̻�,��ʺ�
if isNull(ll_wedding) then ll_wedding = 0
ls_record = ls_record + string(ll_wedding, '0000000000')

ls_record = ls_record + '0000000000'                      //����

ld_tot40 = dw_1.GetItemNumber(al_row, 'tot38')           //��(Ư������)

if isNull(ld_tot40) or ld_tot40 < 0 then ld_tot40 = 0


ld_standardsub = dw_1.GetItemNumber(al_row, 'standardsub')   //ǥ�ذ���
if isNull(ld_standardsub) then ld_standardsub = 0

if ld_standardsub = 0 then                              //ǥ�ذ����ݾ� ������ Ư�������� ������ ǥ�ذ�����
   ls_record = ls_record + string(ld_tot40, '0000000000')
else
	ld_tot40 = 0
	ls_record = ls_record + string(ld_tot40, '0000000000')
end if

ls_record = ls_record + string(ld_standardsub, '00000000')
kk = lena(ls_record)


if ld_tot40 >= ld_standardsub then
	ld_chaincome = ld_workincome - ld_ssub - ld_tot40 - ld_penamt
else
	ld_chaincome = ld_workincome - ld_ssub - ld_standardsub - ld_penamt
end if

if ld_chaincome < 0 then ld_chaincome  = 0
ls_record = ls_record + string(ld_chaincome, '00000000000')    //�����ҵ�ݾ�
kk = lena(ls_record)


ld_pensionsavingsub = dw_1.GetItemNumber(al_row, 'pensionsavingsub')  //���ο�������(72����)
if isNull(ld_pensionsavingsub) then ld_pensionsavingsub = 0
ls_record = ls_record + string(ld_pensionsavingsub, '00000000')

ld_pensionsub2 = dw_1.GetItemNumber(al_row, 'pensionsavingsub2')  //��������(300����)
if isNull(ld_pensionsub2) then ld_pensionsub2 = 0
ls_record = ls_record + string(ld_pensionsub2, '00000000')


ls_record = ls_record + '0000000000'              //�ұ�������αݼҵ����(2008��) Į������


ld_housesavesub = dw_1.GetItemNumber(al_row, 'housesavesub')   //���ø�������ҵ������(2008��)
if isNull(ld_housesavesub) then ld_housesavesub = 0
ls_record = ls_record + string(ld_housesavesub, '0000000000')


ll_johapsub = dw_1.GetItemNumber(al_row, 'johapsub')   //�����������ڵ�
if isNull(ll_johapsub) then ll_johapsub = 0
ls_record = ls_record + string(ll_johapsub, '0000000000')

kk = lena(ls_record)
ld_cdcardsub = dw_1.GetItemNumber(al_row, 'cdcardsub')  //�ſ�ī���
if isNull(ld_cdcardsub) then ld_cdcardsub = 0
ls_record = ls_record + string(ld_cdcardsub, '00000000')

ld_urisajusub = dw_1.GetItemNumber(al_row, 'urisajusub')  //�츮���������⿬��
if isNull(ld_urisajusub) then ld_urisajusub = 0
if ld_urisajusub < 0 then
	ls_record = ls_record + '1'	//�����̸� '1'
else
	ls_record = ls_record + '0'	//����̸� '0'
end if
ls_record = ls_record + string(ld_urisajusub, '0000000000')

ld_fundsub = dw_1.GetItemNumber(al_row, 'fundsub')       //����ֽ����ҵ����(2008��)
if isNull(ld_fundsub) then ld_fundsub = 0
ls_record = ls_record + string(ld_fundsub, '0000000000')

ll_Tjotsub = 0
ll_Tjotsub = ld_pensionsavingsub + ld_pensionsub2 + ll_johapsub + ld_cdcardsub + ld_urisajusub + ld_housesavesub + ld_fundsub 
if isNull(ll_Tjotsub) then ll_Tjotsub = 0
if ll_Tjotsub < 0 then
	ls_record = ls_record + '1'	//�����̸� '1'
else
	ls_record = ls_record + '0'	//����̸� '0'
end if
ls_record = ls_record + string(ll_Tjotsub, '0000000000')          //��Ÿ�ҵ������


ld_standardtaxamt = dw_1.GetItemNumber(al_row, 'standardtaxamt') //���ռҵ����ǥ��
if isNull(ld_standardtaxamt) then ld_standardtaxamt = 0
ls_record = ls_record + string(ld_standardtaxamt, '00000000000')

ld_calctaxsub = dw_1.GetItemNumber(al_row, 'calctaxsub')       //���⼼��
if isNull(ld_calctaxsub) then ld_calctaxsub = 0
ls_record = ls_record + string(ld_calctaxsub, '0000000000')

//���װ���
//ld_incometaxlawsub = dw_1.GetItemNumber(al_row, 'incometaxlawsub')  //�ҵ漼��
//if isNull(ld_incometaxlawsub) then ld_incometaxlawsub = 0
//ls_record = ls_record + string(ld_incometaxlawsub, '0000000000')
ls_record = ls_record + '0000000000'
//ld_totlawsub = ld_incometaxlawsub

ld_relftaxlawsub = dw_1.GetItemNumber(al_row, 'relftaxlawsub')   //��Ư��
if isNull(ld_relftaxlawsub) then ld_relftaxlawsub = 0
ls_record = ls_record + string(ld_relftaxlawsub, '0000000000')
ld_totlawsub = ld_totlawsub + ld_relftaxlawsub

ls_record = ls_record + '0000000000'     //����                     

ls_record = ls_record + string(ld_totlawsub, '0000000000')   //���鼼��



//���װ���
ld_workincometaxsub = dw_1.GetItemNumber(al_row, 'workincometaxsub') //�ٷμҵ漼�װ���
if isNull(ld_workincometaxsub) then ld_workincometaxsub = 0
ls_record = ls_record + string(ld_workincometaxsub, '00000000')

ls_record = ls_record + '00000000'                          //�������հ���
kk = lena(ls_record)
//ld_welthsavingtaxsub = dw_1.GetItemNumber(al_row, 'welthsavingtaxsub')  
//if isNull(ld_welthsavingtaxsub) then ld_welthsavingtaxsub = 0
//ls_record = ls_record + string(ld_welthsavingtaxsub, '00000000')

ld_housechaip = dw_1.GetItemNumber(al_row, 'housechaip')     //�������Ա�
if isNull(ld_housechaip) then ld_housechaip = 0
ls_record = ls_record + string(ld_housechaip, '00000000')

ll_political = dw_1.GetItemNumber(al_row, 'politicaltaxsub') //�����ġ�ڱ�
if isNull(ll_political) then ll_political = 0
ls_record = ls_record + string(ll_political, '0000000000')

ld_foreignpaidtaxsub = dw_1.GetItemNumber(al_row, 'foreignpaidtaxsub')  //�ܱ�����
if isNull(ld_foreignpaidtaxsub) then ld_foreignpaidtaxsub = 0
ls_record = ls_record + string(ld_foreignpaidtaxsub, '00000000')

ls_record = ls_record + '00000000'                    //����

kk = lena(ls_record)

ld_tottaxsub = dw_1.GetItemNumber(al_row, 'tottaxsub')        //���װ�����
ls_record = ls_record + string(ld_tottaxsub, '00000000')
kk = lena(ls_record)


// ��������
ld_resultincometax = dw_1.GetItemNumber(al_row, 'resultincometax')  //�ҵ漼
if isNull(ld_resultincometax) then ld_resultincometax = 0
ls_record = ls_record + string(ld_resultincometax, '0000000000')

ld_resultresidenttax = dw_1.GetItemNumber(al_row, 'resultresidenttax') //�ֹμ�
if isNull(ld_resultresidenttax) then ld_resultresidenttax = 0
ls_record = ls_record + string(ld_resultresidenttax, '0000000000')

ld_resultspecialtax = dw_1.GetItemNumber(al_row, 'resultspecialtax')   //��Ư��
if isNull(ld_resultspecialtax) then ld_resultspecialtax = 0
ls_record = ls_record + string(ld_resultspecialtax, '0000000000')

kk = lena(ls_record)
ld_totresulttax = ld_resultincometax + ld_resultspecialtax + ld_resultresidenttax

ls_record = ls_record + string(ld_totresulttax, '0000000000')      //���װ�

//�ⳳ�μ��� [��(��)�ٹ���]
ld_previncometax = dw_1.GetItemNumber(al_row, 'previncometax')
if isNull(ld_previncometax) then ld_previncometax = 0
if ld_previncometax < 0 then
	ls_record = ls_record + string(ld_previncometax, '0000000000')
else
   ls_record = ls_record + string(ld_previncometax, '0000000000')
end if

ld_prevresidenttax = dw_1.GetItemNumber(al_row, 'prevresidenttax')
if isNull(ld_prevresidenttax) then ld_prevresidenttax = 0
if ld_prevresidenttax < 0 then
	ls_record = ls_record + string(ld_prevresidenttax, '000000000')
else
   ls_record = ls_record + string(ld_prevresidenttax, '0000000000')
end if

ld_prevspecialtax = dw_1.GetItemNumber(al_row, 'prevspecialtax')
if isNull(ld_prevspecialtax) then ld_prevspecialtax = 0
ls_record = ls_record + string(ld_prevspecialtax, '0000000000')

ld_totprevtax = ld_previncometax + ld_prevspecialtax + ld_prevresidenttax
if ld_totprevtax < 0 then
	ls_record = ls_record + string(ld_totprevtax, '000000000')
else
   ls_record = ls_record + string(ld_totprevtax, '0000000000')
end if

kk = lena(ls_record)


//�ⳳ�μ���[��(��)�ٹ���]
ld_currincometax = dw_1.GetItemNumber(al_row, 'currincometax')
if isNull(ld_currincometax) then ld_currincometax = 0
ls_record = ls_record + string(ld_currincometax, '0000000000')

ld_currresidenttax = dw_1.GetItemNumber(al_row, 'currresidenttax')
if isNull(ld_currresidenttax) then ld_currresidenttax = 0
ls_record = ls_record + string(ld_currresidenttax, '0000000000')

ld_currspecialtax = dw_1.GetItemNumber(al_row, 'currspecialtax')
if isNull(ld_currspecialtax) then ld_currspecialtax = 0
ls_record = ls_record + string(ld_currspecialtax, '0000000000')

ld_totcurrtax = ld_currincometax + ld_currspecialtax + ld_currresidenttax
ls_record = ls_record + string(ld_totcurrtax, '0000000000')


ls_record = ls_record + Space(7)   /*����(7) 2008��*/

kk = lena(ls_record)



//Messagebox('���� ������ ' + string(kk),ls_record)
int reclen
reclen = FileWrite(ii_fileid, ls_record)
if reclen <> 820 then
Messagebox('C���ڵ� ���� : ���ڵ���� = ' + string(reclen), ls_record)
	MessageBox("����Ÿ ����", "wf_write_c_record�� Ȯ���Ͻʽÿ�.")
	return false
end if

return true

end function

public function boolean wf_write_a_record ();string	ls_recordtag, ls_datatag, ls_submitdate, ls_submittag
string	ls_space6, s_saupno, s_saname, s_president
string	s_zip, s_addr, ls_b_cnt, ls_korean_kind,s_ddd
string	ls_updatecode, ls_emptySpace
string	ls_record,S_Resno, tot_cnt, ls_dept, ls_empname, ls_tel
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
				
//	  SELECT "SYSCNFG"."DATANAME"  //������ּ�
//		 INTO :S_ADDR
//		 FROM "SYSCNFG"  
//		WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
//				( "SYSCNFG"."SERIAL" = 1 )  AND
//				( "SYSCNFG"."LINENO" = '5' )  ;				
//				
//	  SELECT "SYSCNFG"."DATANAME"  //���������ȣ
//		 INTO :S_ZIP
//		 FROM "SYSCNFG"  
//		WHERE ( "SYSCNFG"."SYSGU" = 'C' ) AND  
//				( "SYSCNFG"."SERIAL" = 1 )  AND
//				( "SYSCNFG"."LINENO" = '8' )  ;		
//	s_zip = left(s_zip,3)+right(s_zip,3)
	
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
//sainfo.zip       = S_ZIP
//sainfo.addr      = S_ADDR

OpenWithParm(w_pip5010_popup, sainfo)

sainfo = Message.PowerObjectParm
S_SAUPNO    = sainfo.saupno   
S_Resno     = sainfo.jurno    
S_SANAME    = sainfo.jurname  
S_PRESIDENT = sainfo.president
//S_ZIP       = sainfo.zip      
//S_ADDR      = sainfo.addr     


ls_recordtag	= 'A'
ls_datatag		= '20'
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
ls_emptySpace	= Space(641)         /*���� 2008��*/

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

if FileWrite(ii_fileid, ls_record) <> 820 then
	MessageBox("����Ÿ ����", "wf_write_a_record�� Ȯ���Ͻʽÿ�.")
	return false
end if

return true


end function

public function boolean wf_write_b_record ();long		ll_submitCnt
double	ld_totsum, ld_tottax
string	ls_recordtag, ls_datatag, ls_seq
string	ls_record, sadd

ls_recordtag	= 'B'
ls_datatag		= '20'
ls_seq			= '000001'
//�ڷ������ȣ
ls_record = ls_recordtag + ls_datatag + is_taxoffice + ls_seq
//��õ¡���ǹ���
ls_record = ls_record + is_businessno + is_businessname + is_president
ls_record = ls_record + is_residentno //+ is_zipcode + is_address

//if cbx_1.Checked = true then
//	sadd = '2'
//else
//	sadd = '1'
//end if
//
//select count(*) into :ll_submitCnt
//		from p3_acnt_taxcal_data
//		where workyear		= :idt_workyear		  
//		  and companycode = :gs_company
//		  and (workmm		= :idt_workmm	and tag = '1') or
//		      (tag = :sadd );
				
ll_submitCnt = dw_1.rowcount()				
		  
if sqlca.sqlcode = -1 then
	MessageBox("wf_write_b_record_1", sqlca.sqlerrtext)
	return false
end if

ls_record = ls_record + string(ll_submitCnt, '0000000')

ll_submitCnt = dw_2.rowcount()  //���ٹ��� �ڷ��
		  
if sqlca.sqlcode = -1 then
	MessageBox("wf_write_b_record_2", sqlca.sqlerrtext)
	return false
end if

ls_record = ls_record + string(ll_submitCnt, '0000000')


ld_totsum = dw_1.GetitemNumber(1,'sum_workincomegross')

if sqlca.sqlcode = -1 then
	MessageBox("wf_write_b_record_3", sqlca.sqlerrtext)
	return false
end if

ls_record = ls_record + string(ld_totsum, '00000000000000')  //�ҵ�ݾ��Ѱ�

ld_totsum = dw_1.GetitemNumber(1,'sum_incometax')

if sqlca.sqlcode = -1 then
	MessageBox("wf_write_b_record_4", sqlca.sqlerrtext)
	return false
end if
ls_record = ls_record + string(ld_totsum, '0000000000000')   //�ҵ漼���������Ѱ�
ld_tottax = ld_totsum
ls_record = ls_record + '0000000000000'                     //���μ�

ld_totsum = dw_1.GetitemNumber(1,'sum_residenttax')				
			
if sqlca.sqlcode = -1 then
	MessageBox("wf_write_b_record_6", sqlca.sqlerrtext)
	return false
end if
ls_record = ls_record + string(ld_totsum, '0000000000000')  //�ֹμ����������Ѱ�
ld_tottax = ld_tottax + ld_totsum

ld_totsum = dw_1.GetitemNumber(1,'sum_special')		        //��Ư�����������Ѱ�

if sqlca.sqlcode = -1 then
	MessageBox("wf_write_b_record_5", sqlca.sqlerrtext)
	return false
end if
ls_record = ls_record + string(ld_totsum, '0000000000000')
ld_tottax = ld_tottax + ld_totsum



ls_record = ls_record + string(ld_tottax, '0000000000000')   //�������� �Ѱ�
ls_record = ls_record + Space(622)   /*�������� 2008��*/

if FileWrite(ii_fileid, ls_record) <> 820 then
	MessageBox("����Ÿ ����", "wf_write_b_record�� Ȯ���Ͻʽÿ�.")
	return false
end if

return true

end function

public function boolean wf_write_d_record (long al_row);string	ls_empno, ls_residentno, ls_companyname, ls_companyno
string	ls_record, ls_record_before, ls_record_after
double	ld_paytotal, ld_bonustotal, ld_injung, ld_total, ld_stock
long		ll_row, ll_rowcnt, ll_saverow, reclen

ls_empno = dw_1.GetItemString(al_row, 'empno')
ll_rowcnt = dw_2.RowCount()

ll_row = dw_2.Find("empno = '" + ls_empno + "'", 1, ll_rowcnt)
ll_saverow = ll_row

if ll_row < 1 then return false
//�ڷ������ȣ
ls_record_before = 'D' + '20' + is_taxoffice
ls_record_before = ls_record_before + string(il_c_seq, '000000')
//��õ¡���ǹ���
ls_record_before = ls_record_before + is_businessno + Space(50)
//�ҵ����ֹι�ȣ
ls_residentno = dw_1.GetItemString(al_row, "residentno")
if lena(ls_residentno) > 13 then
	ls_residentno = left(ls_residentno, 13)
else
	ls_residentno = ls_residentno + Space(13 - lena(ls_residentno))
end if
ls_record_before = ls_record_before + ls_residentno

il_d_seq++

do until ll_row < 1
	
	ls_companyname = dw_2.GetItemString(ll_row, 'companyname')
	if lena(ls_companyname) > 40 then
		ls_companyname = left(ls_companyname, 40)
	else
		ls_companyname = ls_companyname + Space(40 - lena(ls_companyname))
	end if
	ls_record = ls_record_before + ls_companyname
	
	ls_companyno = dw_2.GetItemString(ll_row, 'companyno')
	if lena(ls_companyno) > 10 then
		ls_companyno = left(ls_companyno, 10)
	else
		ls_companyno = ls_companyno + Space(10 - lena(ls_companyno))
	end if
	ls_record = ls_record + ls_companyno
	
	ld_paytotal = dw_2.GetItemNumber(ll_row, 'paytotal')       //�޿��Ѿ�
	if isNull(ld_paytotal) then ld_paytotal = 0
	ls_record = ls_record + string(ld_paytotal, '00000000000')
	
	ld_bonustotal = dw_2.GetItemNumber(ll_row, 'bonustotal')   //���Ѿ�
	if isNull(ld_bonustotal) then ld_bonustotal = 0
	ls_record = ls_record + string(ld_bonustotal, '00000000000')
	
	ld_injung = dw_2.GetItemNumber(ll_row, 'injungbonusamt')     //������
	if isNull(ld_injung) then ld_injung = 0
	ls_record = ls_record + string(ld_injung, '00000000000')		
	
	ld_stock = dw_2.GetItemNumber(ll_row, 'stockprofit')     //�ֽĸż����ñ��������(2007��)
	if isNull(ld_stock) then ld_stock = 0
	ls_record = ls_record + string(ld_stock, '00000000000')	
	
	
	ld_total = ld_paytotal + ld_bonustotal + ld_injung + ld_stock       //��
	ls_record = ls_record + string(ld_total, '00000000000')

	ls_record = ls_record + string(il_d_seq, '00')    //��(��)�ٹ�ó�Ϸù�ȣ
	
	ls_record_after = Space(628)    /*����(628) 2008��*/
	
	ls_record = ls_record + ls_record_after

	reclen = FileWrite(ii_fileid, ls_record)
	if reclen <> 820 then
	Messagebox('D���ڵ� ���� : ���ڵ���� = ' + string(reclen), ls_record)
		MessageBox("����Ÿ ����", "wf_write_d_record�� Ȯ���Ͻʽÿ�.")
		return false
	end if
	
	ll_row = dw_2.Find("empno = '" + ls_empno + "'", ll_row + 1, ll_rowcnt)
	if ll_row = ll_saverow then exit
	ll_saverow = ll_row
	il_d_seq++

loop

return true

end function

public function boolean wf_write_e_record (long al_row);string	ls_empno, ls_residentno, ls_empname
string	ls_record, ls_record_before, ls_record_after
string	ls_relation, ls_fname, ls_fresidentno, ls_inout
long		icnt, rcnt, i, j, reclen
double   ld_insuranceamt1,         ld_medicalamt1,         ld_educationamt1,         ld_creditcardamt1,         ld_purseamt1
double   ld_insuranceamt2,         ld_medicalamt2,         ld_educationamt2,         ld_creditcardamt2,         ld_purseamt2
double   ld_cashsubamt     
string   ls_etcamt, ls_self
long     kk

ls_empno = dw_1.GetItemString(al_row, 'empno')
ls_empname = dw_1.GetItemString(al_row, 'empname')
icnt = dw_5.Retrieve( idt_workyear, ls_empno)

IF icnt <= 0 THEN return true

rcnt = Ceiling(icnt / 5)
//Messagebox(ls_empno + ',' + ls_empname,'rcnt : '+string(icnt)+' / 5 = '+string(rcnt))

for j = 1 to rcnt
	//�ڷ������ȣ
	ls_record_before = 'E' + '20' + is_taxoffice
	ls_record_before = ls_record_before + string(il_c_seq, '000000')
	//��õ¡���ǹ���
	ls_record_before = ls_record_before + is_businessno 
	//�ҵ����ֹι�ȣ
	ls_residentno = dw_1.GetItemString(al_row, "residentno")
	if lena(ls_residentno) > 13 then
		ls_residentno = left(ls_residentno, 13)
	else
		ls_residentno = ls_residentno + Space(13 - lena(ls_residentno))
	end if
	ls_record_before = ls_record_before + ls_residentno
	
	
	ls_record = ls_record_before

	for i = (j - 1) * 5 + 1 to j * 5 			//�� ���ڵ忡 5���� �ξ簡�� ���
		if icnt < i then
			ls_record = ls_record + space(42) + '00000000000000000000000000000000000000000000000000'  //100�ڸ�
			ls_record = ls_record + '00000000000000000000000000000000000000000000000000'
			//space(141)
		else
			ls_self = ' '
			ls_fname = ' '
			ls_fresidentno = ' '
			ls_relation = dw_5.GetItemString(i, 'relation_code')					//����
			
			ls_record = ls_record + ls_relation
			
			ls_inout  = dw_5.GetItemString(i, 'inout')	
			if IsNull(ls_inout) or ls_inout = "" then ls_inout = '1'
			ls_record = ls_record + ls_inout  												//��.�ܱ��� �����ڵ�
			
			ls_fname = dw_5.GetItemString(i, 'family_name')							//����
						
			if lena(ls_fname) > 20 then
				ls_fname = left(ls_fname, 20)
			else
				ls_fname = ls_fname + Space(20 - lena(ls_fname))
			end if
			if isnull(ls_fname) then ls_fname = space(20)
			ls_record = ls_record + ls_fname
			
			ls_fresidentno = dw_5.GetItemString(i, 'residentno')					//�ֹε�Ϲ�ȣ
			
			if lena(ls_fresidentno) > 13 then
				ls_fresidentno = left(ls_fresidentno, 13)
			else
				ls_fresidentno = ls_fresidentno + Space(13 - lena(ls_fresidentno))
			end if
			if isnull(ls_fresidentno) then ls_fresidentno = space(13)
			ls_record = ls_record + ls_fresidentno	
		
			
			
			if dw_5.GetItemString(i, 'dependent') = '1' then							//�⺻����
				ls_record = ls_record + '1'
			else
				ls_record = ls_record + space(1)
			end if
			
			if dw_5.GetItemString(i, 'rubber') = '1' then								//�����
				ls_record = ls_record + '1'
			else
				ls_record = ls_record + space(1)
			end if
		
			if dw_5.GetItemString(i, 'childcount') = '1' then						//�ڳ������
				ls_record = ls_record + '1'
			else
				ls_record = ls_record + space(1)
			end if
			
			if dw_5.GetItemString(i, 'womanhouse') = '1' then						//�γ��ڰ���(2007��)
				ls_record = ls_record + '1'
			else
				ls_record = ls_record + space(1)
			end if
			                                                                  //��ο��(2007��)
			if dw_5.GetItemString(i, 'respect65') = '1' or dw_5.GetItemString(i, 'respect70') = '1' then	
				ls_record = ls_record + '1'
			else
				ls_record = ls_record + space(1)
			end if
			
			if dw_5.GetItemString(i, 'manychild') = '1' then						//�ٳ��߰�����(2007��)
				ls_record = ls_record + '1'
			else
				ls_record = ls_record + space(1)
			end if
			
			if dw_5.GetItemString(i, 'born') = '1' then					      	//����Ծ��ڰ���(2008��)
				ls_record = ls_record + '1'
			else
				ls_record = ls_record + space(1)
			end if
			
			
			ld_insuranceamt1 = dw_5.GetItemNumber(i, 'insuranceamt1')
			if IsNull(ld_insuranceamt1) then ld_insuranceamt1 = 0
			ld_medicalamt1 = dw_5.GetItemNumber(i, 'medicalamt1')
			if IsNull(ld_medicalamt1) then ld_medicalamt1 = 0
			ld_educationamt1 = dw_5.GetItemNumber(i, 'educationamt1')
			if IsNull(ld_educationamt1) then ld_educationamt1 = 0
			ld_creditcardamt1 = dw_5.GetItemNumber(i, 'creditcardamt1')
			if IsNull(ld_creditcardamt1) then ld_creditcardamt1 = 0
			ld_purseamt1 = dw_5.GetItemNumber(i, 'purseamt1')
			if IsNull(ld_purseamt1) then ld_purseamt1 = 0
			ld_insuranceamt2 = dw_5.GetItemNumber(i, 'insuranceamt2')
			if IsNull(ld_insuranceamt2) then ld_insuranceamt2 = 0
			ld_medicalamt2 = dw_5.GetItemNumber(i, 'medicalamt2')
			if IsNull(ld_medicalamt2) then ld_medicalamt2 = 0
			ld_educationamt2 = dw_5.GetItemNumber(i, 'educationamt2')
			if IsNull(ld_educationamt2) then ld_educationamt2 = 0
			ld_creditcardamt2 = dw_5.GetItemNumber(i, 'creditcardamt2')
			if IsNull(ld_creditcardamt2) then ld_creditcardamt2 = 0
			ld_purseamt2 = dw_5.GetItemNumber(i, 'purseamt2')
			if IsNull(ld_purseamt2) then ld_purseamt2 = 0
			ld_cashsubamt = dw_5.GetItemNumber(i, 'cashsubamt')
			if IsNull(ld_cashsubamt) then ld_cashsubamt = 0
			
			
			//�ݾ׺κ� = �����1(10), �Ƿ��1(10), ������1(10), �ſ�ī��1(10),���ݿ�����1(10)
			ls_etcamt = string(ld_insuranceamt1, '0000000000') + string(ld_medicalamt1, '0000000000') 
			ls_etcamt = ls_etcamt + string(ld_educationamt1, '0000000000')  + string(ld_creditcardamt1, '0000000000') 
			ls_etcamt = ls_etcamt + string(ld_cashsubamt, '0000000000') 
			
					 //	�����2(10), �Ƿ��2(10), ������2(10), �ſ�ī��2(10), ��α�1(10),
			ls_etcamt = ls_etcamt + string(ld_insuranceamt2, '0000000000')  + string(ld_medicalamt2, '0000000000') 
			ls_etcamt = ls_etcamt + string(ld_educationamt2, '0000000000')  + string(ld_creditcardamt2, '0000000000') 
			ls_etcamt = ls_etcamt + string(ld_purseamt2, '0000000000')  
			
			ls_record = ls_record + ls_etcamt
			
			kk = lena(ls_record)
		end if
	next

	ls_record = ls_record + string(j, '00')
	ls_record_after = Space(73)  /*2008��*/
		
	ls_record = ls_record + ls_record_after
	
	reclen = FileWrite(ii_fileid, ls_record)
	if reclen <> 820 then
		Messagebox('E���ڵ� ���� : ���ڵ���� = ' + string(reclen), ls_record)
		MessageBox("����Ÿ ����", "wf_write_e_record�� Ȯ���Ͻʽÿ�.")
		return false
	end if
next

return true
end function

public function boolean wf_medfile (long al_row);string	ls_empno, ls_residentno, ls_empname, ls_medresident, ls_relation, ls_jkgbn
string	ls_record, ls_record_before, ls_saupno, ls_saupname, ls_medgbn, ls_inoutgbn
double	ld_medamt, ld_creditamt
long		ll_cnt, ll_rowcnt, reclen, ll_creditcnt

il_c_seq++
ls_empno = dw_3.GetItemString(al_row, 'empno')
ll_rowcnt = dw_3.RowCount()

//�ڷ������ȣ
ls_record_before = 'A' + '26' + is_taxoffice

ls_record_before = ls_record_before + string(il_c_seq, '000000')
ls_record_before = ls_record_before + idt_submitdate   //��������

//������(�븮��)
ls_record_before = ls_record_before + is_businessno    //����ڹ�ȣ

ls_record_before = ls_record_before + is_hometaxid     //Ȩ�ý�ID
ls_record_before = ls_record_before + '9000'           //���α׷� ���� ��Ÿ '9000'

//��õ¡���ǹ���
ls_record_before = ls_record_before + is_businessno    //����ڹ�ȣ
ls_record_before = ls_record_before + is_businessname  //��ü��


//�ҵ���(���������û��)
ls_residentno = dw_3.GetItemString(al_row, "residentno")  //�ֹι�ȣ
if Lena(ls_residentno) > 13 then
	ls_residentno = left(ls_residentno, 13)
else
	ls_residentno = ls_residentno + Space(13 - lena(ls_residentno))
end if
ls_record_before = ls_record_before + ls_residentno

ls_record_before = ls_record_before + '1' 				//��.�ܱ��� ����

ls_empname = dw_3.GetItemString(al_row, 'empname')     //����
if lena(ls_empname) > 30 then
	ls_empname = left(ls_empname, 30)
else
	ls_empname = ls_empname + Space(30 - lena(ls_empname))
end if
ls_record_before = ls_record_before + ls_empname
ls_record = ls_record + ls_record_before

//�Ƿ�� ���޳���
ls_saupno = dw_3.GetItemString(al_row, 'vendor_no')     //����ó����ڹ�ȣ
if IsNull(ls_saupno) or ls_saupno = '' then ls_saupno = space(10)
ls_saupno = ls_saupno + Space(10 - lena(ls_saupno))
ls_record = ls_record + ls_saupno

ls_saupname = dw_3.GetItemString(al_row, 'vendor_name')     //����ó��ȣ
ls_saupname = ls_saupname + Space(40 - lena(ls_saupname))	
ls_record = ls_record + ls_saupname


ls_medgbn = dw_3.GetItemString(al_row, 'medgbn')      //�Ƿ������ڵ�(2008��)
ls_record = ls_record + ls_medgbn

//select count(*) into :ll_cnt
//from p3_acnt_medical
//where workyear = :idt_workyear and empno = :ls_empno;
//
//if IsNull(ll_cnt) then ll_cnt = 0
//
//ls_record = ls_record + string(ll_cnt,'00000')        //�Ǽ� 2008�����

//ll_creditcnt = dw_3.GetItemNumber(al_row, 'credit_cnt')    //�ſ�ī�����ްǼ� 2008�����
//if isNull(ll_creditcnt) then ll_creditcnt = 0
//ls_record = ls_record + string(ll_creditcnt, '00000')
//
//ld_creditamt = dw_3.GetItemNumber(al_row, 'credit_amt')    //�ſ�ī�����ޱݾ� 2008�����
//if isNull(ld_creditamt) then ld_creditamt = 0
//ls_record = ls_record + string(ld_creditamt, '00000000000')
//

ll_cnt = dw_3.GetItemNumber(al_row, 'medical_cnt')    //�Ǽ�
if isNull(ll_cnt) then ll_cnt = 0
ls_record = ls_record + string(ll_cnt, '00000')

ld_medamt = dw_3.GetItemNumber(al_row, 'medical_amt')    //�ݾ�
if isNull(ld_medamt) then ld_medamt = 0
ls_record = ls_record + string(ld_medamt, '00000000000')


//ls_relation = dw_3.GetItemString(al_row, 'relation_code') //���� 2008�����
//IF ISNULL(ls_relation) THEN ls_relation = SPACE(1)
//ls_record = ls_record + ls_relation

ls_medresident = dw_3.GetItemString(al_row, 'medical_residentno') //������ֹι�ȣ
ls_medresident = ls_medresident + Space(13 - lena(ls_medresident))
ls_record = ls_record + ls_medresident

ls_inoutgbn =  dw_3.GetItemString(al_row, 'inoutgbn')  

ls_record = ls_record + ls_inoutgbn			    	//��.�ܱ��� ����

ls_jkgbn = dw_3.GetItemString(al_row, 'res_rub_div')    //���ε� �ش� ����
IF ISNULL(ls_jkgbn) THEN ls_jkgbn = SPACE(1)
ls_record = ls_record + ls_jkgbn

ls_record = ls_record + SPACE(20)

reclen = FileWrite(ii_fileid, ls_record)
if reclen <> 250 then
Messagebox('�Ƿ�� ���� : ���ڵ���� = ' + string(reclen), ls_record)
	MessageBox("����Ÿ ����", "�Ƿ�� ���ϻ����� Ȯ���Ͻʽÿ�.")
	return false
end if

return true

end function

public function boolean wf_donafile (long al_row);string	ls_empno, ls_residentno, ls_empname, ls_gubncode
string	ls_record, ls_record_before, ls_saupno, ls_saupname, ls_docno
double	ld_donamt, ld_iwoljamt, ld_donationsub, ld_iwolamt
long		ll_cnt, ll_rowcnt, reclen, kk
string   ls_inout, ls_relation_code, ls_inoutgbn, ls_residentno2, ls_gfromdate, ls_gtodate, ls_empname2

il_c_seq++
ls_empno = dw_4.GetItemString(al_row, 'empno')
ll_rowcnt = dw_4.RowCount()

//�ڷ������ȣ
ls_record_before = 'A' + '27' + is_taxoffice


ls_record_before = ls_record_before + string(il_c_seq, '0000000')  /*�Ϸù�ȣ 7�ڸ� 2007��*/
//messagebox('','il_c_seq,' + string(il_c_seq)+' :'+ls_record_before)
ls_record_before = ls_record_before + idt_submitdate   //��������

//������(�븮��)
ls_record_before = ls_record_before + is_businessno    //����ڹ�ȣ

ls_record_before = ls_record_before + is_hometaxid     //Ȩ�ý�ID
ls_record_before = ls_record_before + '9000'           //���α׷� ���� ��Ÿ '9000'

//��õ¡���ǹ���
ls_record_before = ls_record_before + is_businessno    //����ڹ�ȣ
ls_record_before = ls_record_before + is_businessname  //��ü��


//�ҵ���(���������û��)
ls_residentno = dw_4.GetItemString(al_row, "residentno")  //�ֹι�ȣ
if lena(ls_residentno) > 13 then
	ls_residentno = left(ls_residentno, 13)
else
	ls_residentno = ls_residentno + Space(13 - lena(ls_residentno))
end if
ls_record_before = ls_record_before + ls_residentno

select inout into :ls_inout
from p1_master
where empno = :ls_empno;
if sqlca.sqlcode <> 0 then
	ls_inout = '1'
end if;	
if IsNull(ls_inout) or ls_inout = "" then ls_inout = '1'

ls_record_before = ls_record_before + ls_inout 				//��.�ܱ��� ����

ls_empname = dw_4.GetItemString(al_row, 'empname')     //����
if lena(ls_empname) > 30 then
	ls_empname = left(ls_empname, 30)
else
	ls_empname = ls_empname + Space(30 - lena(ls_empname))
end if
ls_record_before = ls_record_before + ls_empname
ls_record = ls_record + ls_record_before

//��α� ���޳���
ls_saupno = dw_4.GetItemString(al_row, 'vendor_no')     //���ó����ڹ�ȣ
if IsNull(ls_saupno) or ls_saupno = '' then ls_saupno = '0000000000'
ls_saupno = ls_saupno + Space(13 - lena(ls_saupno))
ls_record = ls_record + ls_saupno

ls_saupname = dw_4.GetItemString(al_row, 'vendor_name')     //���ó��ȣ
if IsNull(ls_saupname) or ls_saupname = '' then ls_saupname = Space(30)
ls_saupname = ls_saupname + Space(30 - lena(ls_saupname))	
ls_record = ls_record + ls_saupname

ls_gubncode = dw_4.GetItemString(al_row, 'gubn_code') //�ڵ�
IF ISNULL(ls_gubncode) THEN ls_gubncode = SPACE(2)
ls_record = ls_record + ls_gubncode

ll_cnt = dw_4.GetItemNumber(al_row, 'cnt')    //�Ǽ�
if isNull(ll_cnt) then ll_cnt = 0
ls_record = ls_record + string(ll_cnt, '00000')

ld_donamt = dw_4.GetItemNumber(al_row, 'amt')    //���ޱݾ�
if isNull(ld_donamt) then ld_donamt = 0
ls_record = ls_record + string(ld_donamt, '0000000000000')

kk = lena(ls_record)
//ls_docno = dw_4.GetItemString(al_row, 'docno')     /*������ �Ϸù�ȣ 2007��*/ 2008�� ����
//if IsNull(ls_docno) or ls_docno = "" then 
//	ls_docno = space(20)
//end if	
//if Len(ls_docno) > 20 then
//	ls_docno = left(ls_docno, 20)
//else
//	ls_docno = ls_docno + Space(20 - Len(ls_docno))
//end if
//ls_record = ls_record + ls_docno
//


ls_relation_code = dw_4.GetItemString(al_row, 'relation_code')    //����(2008��)
ls_record = ls_record + ls_relation_code
kk = lena(ls_record)
ls_inoutgbn = dw_4.GetItemString(al_row, 'inoutgbn')              //���ܱ��α���
ls_record = ls_record + ls_inoutgbn
kk = lena(ls_record)
ls_empname2 = trim(dw_4.GetItemString(al_row, 'doname'))                //����
if ls_relation_code = '1' then ls_empname2 = trim(ls_empname)
ls_empname2 = ls_empname2 + Space(20 - lena(ls_empname2))	
ls_record = ls_record + ls_empname2
kk = lena(ls_empname2)
kk = lena(ls_record)
ls_residentno2 = dw_4.GetItemString(al_row, 'residentno2')        //�ֹι�ȣ
if ls_relation_code = '1' then
	ls_residentno2 = ls_residentno
else	
   ls_residentno2 = ls_residentno2 + Space(13 - lena(ls_residentno2))	
end if	
ls_record = ls_record + ls_residentno2
kk = lena(ls_record)
ls_gfromdate = dw_4.GetItemString(al_row, 'gfromdate')           //����������
if IsNull(ls_gfromdate) or ls_gfromdate = '' then ls_gfromdate = Space(8)
ls_gfromdate = ls_gfromdate + Space(8 - lena(ls_gfromdate))	
ls_record = ls_record + ls_gfromdate

ls_gtodate = dw_4.GetItemString(al_row, 'gtodate')               //����������
if IsNull(ls_gtodate) or ls_gtodate = '' then ls_gtodate = Space(8)
ls_gtodate = ls_gtodate + Space(8 - lena(ls_gtodate))	
ls_record = ls_record + ls_gtodate

kk = lena(ls_record)
ld_iwoljamt = dw_4.GetItemNumber(al_row, 'iwoljamt')             //�̿����ܾ�
if isNull(ld_iwoljamt) then ld_iwoljamt = 0
ls_record = ls_record + string(ld_iwoljamt, '0000000000000')

ld_donationsub = dw_4.GetItemNumber(al_row, 'donationsub')       //�ش�����Ⱓ�����ݾ�
if isNull(ld_donationsub) then ld_donationsub = 0
ls_record = ls_record + string(ld_donationsub, '0000000000000')

ld_iwolamt = dw_4.GetItemNumber(al_row, 'iwolamt')               //�̿���
if isNull(ld_iwolamt) then ld_iwolamt = 0
ls_record = ls_record + string(ld_iwolamt, '0000000000000')
kk = lena(ls_record)

ls_record = ls_record + space(118) /*���� 2008��*/

reclen = FileWrite(ii_fileid, ls_record)
if reclen <> 420 then
Messagebox('��α� ���� : ���ڵ���� = ' + string(reclen), ls_record)
	MessageBox("����Ÿ ����", "��α� ���ϻ����� Ȯ���Ͻʽÿ�.")
	return false
end if

return true

end function

event open;call super::open;
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_3.SetTransObject(sqlca)
dw_4.SetTransObject(sqlca)
dw_5.SetTransObject(sqlca)
dw_ip.SetTransObject(sqlca)

dw_datetime.SetTransObject(sqlca)
dw_datetime.insertrow(0)
dw_ip.insertrow(0)

dw_saup.SetTransObject(sqlca)
dw_saup.insertrow(0)

f_set_saupcd(dw_saup,'saupcd','1')

is_saupcd = gs_saupcd

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

dw_ip.Setitem(1,'workym', left(f_today(),6))
dw_ip.Setitem(1,'jdate', f_today())
dw_ip.Setitem(1,'semuseo', semucode)

string saupno

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
								 
dw_ip.Setitem(1,'spath','C:\EOSDATA\C'+left(saupno,7)+'.'+right(saupno,3))


string ls_deptname, ls_empname

select a.empname, b.deptname
into  :ls_empname, :ls_deptname
from p1_master a, p0_dept b
where a.deptcode = b.deptcode and
      a.empno = :gs_empno;
		
dw_ip.Setitem(1,'deptname', ls_deptname)
dw_ip.Setitem(1,'empname', ls_empname)
		
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
//								 
								 
end event

on w_pip5010.create
int iCurrent
call super::create
this.dw_saup=create dw_saup
this.dw_3=create dw_3
this.cbx_1=create cbx_1
this.dw_1=create dw_1
this.dw_2=create dw_2
this.st_6=create st_6
this.rr_1=create rr_1
this.rr_2=create rr_2
this.p_1=create p_1
this.dw_ip=create dw_ip
this.rb_half=create rb_half
this.rb_all=create rb_all
this.dw_4=create dw_4
this.dw_5=create dw_5
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_saup
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.dw_ip
this.Control[iCurrent+11]=this.rb_half
this.Control[iCurrent+12]=this.rb_all
this.Control[iCurrent+13]=this.dw_4
this.Control[iCurrent+14]=this.dw_5
this.Control[iCurrent+15]=this.gb_3
end on

on w_pip5010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_saup)
destroy(this.dw_3)
destroy(this.cbx_1)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.st_6)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.p_1)
destroy(this.dw_ip)
destroy(this.rb_half)
destroy(this.rb_all)
destroy(this.dw_4)
destroy(this.dw_5)
destroy(this.gb_3)
end on

type p_mod from w_inherite_standard`p_mod within w_pip5010
boolean visible = false
integer x = 2153
integer y = 2380
end type

type p_del from w_inherite_standard`p_del within w_pip5010
boolean visible = false
integer x = 2327
integer y = 2380
end type

type p_inq from w_inherite_standard`p_inq within w_pip5010
boolean visible = false
integer x = 1458
integer y = 2380
end type

type p_print from w_inherite_standard`p_print within w_pip5010
boolean visible = false
integer x = 1285
integer y = 2380
end type

type p_can from w_inherite_standard`p_can within w_pip5010
boolean visible = false
integer x = 2501
integer y = 2380
end type

type p_exit from w_inherite_standard`p_exit within w_pip5010
integer x = 4389
end type

type p_ins from w_inherite_standard`p_ins within w_pip5010
boolean visible = false
integer x = 1632
integer y = 2380
end type

type p_search from w_inherite_standard`p_search within w_pip5010
boolean visible = false
integer x = 1106
integer y = 2380
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip5010
boolean visible = false
integer x = 1806
integer y = 2380
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip5010
boolean visible = false
integer x = 1979
integer y = 2380
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip5010
boolean visible = false
integer x = 846
integer y = 2380
end type

type st_window from w_inherite_standard`st_window within w_pip5010
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip5010
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pip5010
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip5010
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip5010
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip5010
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pip5010
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip5010
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip5010
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip5010
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip5010
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip5010
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip5010
boolean visible = false
end type

type dw_saup from datawindow within w_pip5010
integer x = 2039
integer y = 140
integer width = 690
integer height = 84
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_saup_jung"
boolean border = false
boolean livescroll = true
end type

event itemchanged;this.AcceptText()

IF this.GetColumnName() ="saupcd" THEN 
   is_saupcd = this.GetText()
	IF trim(is_saupcd) = '' OR ISNULL(is_saupcd) THEN is_saupcd = '%'
	parent.event ue_filename()
END IF
end event

type dw_3 from datawindow within w_pip5010
boolean visible = false
integer x = 914
integer y = 2088
integer width = 590
integer height = 160
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "�Ƿ��"
string dataobject = "d_pip5010_4"
boolean livescroll = true
end type

type cbx_1 from checkbox within w_pip5010
integer x = 1751
integer y = 1608
integer width = 576
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 32106727
string text = "�ߵ�����������"
end type

type dw_1 from datawindow within w_pip5010
boolean visible = false
integer x = 914
integer y = 1920
integer width = 585
integer height = 160
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "���ڵ� C"
string dataobject = "d_pip5010_1"
boolean livescroll = true
end type

type dw_2 from datawindow within w_pip5010
boolean visible = false
integer x = 1522
integer y = 1920
integer width = 590
integer height = 160
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "���ڵ� D"
string dataobject = "d_pip5010_2"
boolean livescroll = true
end type

type st_6 from statictext within w_pip5010
integer x = 1495
integer y = 368
integer width = 672
integer height = 64
boolean bringtotop = true
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

type rr_1 from roundrectangle within w_pip5010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1413
integer y = 404
integer width = 1934
integer height = 1368
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip5010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 1989
integer y = 112
integer width = 768
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_1 from uo_picture within w_pip5010
integer x = 4215
integer y = 24
integer width = 178
string pointer = ""
string picturename = "C:\erpman\image\�ڷ����_up.gif"
borderstyle borderstyle = stylelowered!
end type

event clicked;long	ll_cnt, ll_rowcnt, ll_row
string  sadd, ls_path, ls_tag

dw_ip.Accepttext()

// �ͼӳ⵵ ����, ������ ���ذ�
if rb_half.checked = true then
	is_termtag = '2'
else
	is_termtag = '1'
end if

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
ls_path = dw_ip.GetitemString(1,'spath')
is_filepath = ls_path


if cbx_1.Checked = true then
	sadd = '2'
	ls_tag = '%'
else
	sadd = '1'
	ls_tag = '1'
end if

// �������� �۾��⵵
idt_workyear = left(trim(dw_ip.GetitemString(1,'workym')),4)
idt_workmm = right(trim(dw_ip.GetitemString(1,'workym')),2)

dw_1.Retrieve( idt_workyear, gs_company, is_saupcd, idt_workmm, sadd)
dw_2.Retrieve( idt_workyear,gs_company, is_saupcd,ls_tag)
dw_3.Retrieve( idt_workyear, is_saupcd)
dw_4.Retrieve( idt_workyear, is_saupcd)

select count(*) into :ll_cnt
	from	p3_acnt_taxcal_data
	where	workyear		= :idt_workyear
	  and workmm		= :idt_workmm	
	  and companycode	= :gs_company
	  and tag			= '1';
	  
if sqlca.sqlcode <> 0 then
	MessageBox("ue_process(w_make_acntdata)", sqlca.sqlerrtext)
	return
elseif ll_cnt < 1 then
	MessageBox("����Ÿ ����", "�������� �۾��� ���� �����Ͻʽÿ�.")
	return
end if

SetPointer(HourGlass!)

// ȭ�� Open
if not wf_fileOpen(1) then
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


il_c_seq = 0
ll_rowcnt = dw_1.RowCount()

SetPointer(HourGlass!)

for ll_row = 1 to ll_rowcnt
   w_mdi_frame.sle_msg.text = string(ll_row )+'�� �۾���......!!'
	il_prevCnt = 0
	// C_record Write
	if not wf_write_C_record(ll_row) then
		SetPointer(Arrow!)
		FileClose(ii_fileID)
		return
	end if

	// D_record Write
	wf_write_D_record(ll_row)

	// E_record Write
	wf_write_E_record(ll_row)
next

FileClose(ii_fileID)

String ls_spath,ls_apath

ll_rowcnt = dw_3.RowCount()
if ll_rowcnt > 0 then
	ls_spath = left(is_filepath,len(ls_path) - 12)
	ls_apath = right(is_filepath,11)
	ls_apath = ls_spath+'CA'+ls_apath
	is_filepath = ls_apath
	// ȭ�� Open
	if wf_fileOpen(2) then
		il_c_seq = 0
		for ll_row = 1 to ll_rowcnt
			w_mdi_frame.sle_msg.text = string(ll_row )+'�� �Ƿ�� ���� �۾���......!!'
			il_prevCnt = 0
			// �Ƿ�� ���ϻ���
			if not wf_medfile(ll_row) then
				SetPointer(Arrow!)
				FileClose(ii_fileID)
				return
			end if	
		next
		FileClose(ii_fileID)
	end if
end if

ll_rowcnt = dw_4.RowCount()
if ll_rowcnt > 0 then
	ls_spath = left(is_filepath,len(ls_path) - 12)
	ls_apath = right(is_filepath,11)
	ls_apath = ls_spath+'H'+ls_apath
	is_filepath = ls_apath
	// ȭ�� Open
	if wf_fileOpen(3) then
		il_c_seq = 0
		for ll_row = 1 to ll_rowcnt
			w_mdi_frame.sle_msg.text = string(ll_row )+'�� ��α� ���� �۾���......!!'
			il_prevCnt = 0
			// ��α� ���ϻ���
			if not wf_donafile(ll_row) then
				SetPointer(Arrow!)
				FileClose(ii_fileID)
				return
			end if	
		next
		FileClose(ii_fileID)
	end if
end if

w_mdi_frame.sle_msg.text = "�۾��� �Ϸ�Ǿ����ϴ�!!"
Messagebox('Ȯ��','���� �۾� �Ϸ�!!')

SetPointer(Arrow!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\�ڷ����_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\�ڷ����_up.gif"
end event

type dw_ip from u_key_enter within w_pip5010
integer x = 1417
integer y = 476
integer width = 1897
integer height = 1092
integer taborder = 11
string title = "none"
string dataobject = "d_pip5010_3"
boolean border = false
end type

event itemfocuschanged;call super::itemfocuschanged;if dwo.name = 'deptname' or dwo.name = 'empname' then
	f_toggle_kor(handle(parent))
else
	f_toggle_eng(handle(parent))
end if
end event

type rb_half from radiobutton within w_pip5010
boolean visible = false
integer x = 2583
integer y = 3328
integer width = 658
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 12632256
boolean enabled = false
string text = "��ݱ� ���޺�"
end type

type rb_all from radiobutton within w_pip5010
boolean visible = false
integer x = 3525
integer y = 3328
integer width = 585
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 12632256
boolean enabled = false
string text = "���� ���޺�"
boolean checked = true
end type

type dw_4 from datawindow within w_pip5010
boolean visible = false
integer x = 1522
integer y = 2088
integer width = 590
integer height = 160
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "��α�"
string dataobject = "d_pip5010_5"
boolean livescroll = true
end type

type dw_5 from datawindow within w_pip5010
boolean visible = false
integer x = 2130
integer y = 1920
integer width = 590
integer height = 160
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "���ڵ� E"
string dataobject = "d_pip5010_6"
boolean livescroll = true
end type

type gb_3 from groupbox within w_pip5010
boolean visible = false
integer x = 2359
integer y = 3168
integer width = 2048
integer height = 360
integer taborder = 80
integer textsize = -12
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 12632256
boolean enabled = false
string text = "������Ⱓ"
end type

