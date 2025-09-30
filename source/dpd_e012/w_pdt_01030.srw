$PBExportHeader$w_pdt_01030.srw
$PBExportComments$����ҿ䷮����(MRP)
forward
global type w_pdt_01030 from w_inherite
end type
type dw_process from u_key_enter within w_pdt_01030
end type
type st_runmsg from statictext within w_pdt_01030
end type
type pb_1 from u_pb_cal within w_pdt_01030
end type
type pb_2 from u_pb_cal within w_pdt_01030
end type
end forward

global type w_pdt_01030 from w_inherite
string title = "���� �ҿ䷮ ����(MRP)"
dw_process dw_process
st_runmsg st_runmsg
pb_1 pb_1
pb_2 pb_2
end type
global w_pdt_01030 w_pdt_01030

type variables
string  srunmsg 
integer il, icnt

end variables

forward prototypes
public subroutine wf_message (string smessage)
public subroutine wf_clear ()
end prototypes

public subroutine wf_message (string smessage);//w_pdt_01030_1.st_1.text = smessage

w_mdi_frame.sle_msg.Text = smessage

end subroutine

public subroutine wf_clear ();//dw_insert.object.step1[1] = 'N'
//dw_insert.object.step1[2] = 'N'
//dw_insert.object.step1[3] = 'N'
//dw_insert.object.step1[4] = 'N'
//dw_insert.object.step1[5] = 'N'
//dw_insert.object.step1[6] = 'N'

//dw_insert.object.step1[1] = 'N'
//dw_insert.object.step2[1] = 'N'
//dw_insert.object.step3[1] = 'N'
//dw_insert.object.step4[1] = 'N'
//dw_insert.object.step5[1] = 'N'
//dw_insert.object.step6[1] = 'N'

//dw_insert.object.stime11[1] = ''
//dw_insert.object.stime21[1] = ''
//dw_insert.object.stime31[1] = ''
//dw_insert.object.stime41[1] = ''
//dw_insert.object.stime51[1] = ''
//dw_insert.object.stime61[1] = ''
//
//dw_insert.object.stime12[1] = ''
//dw_insert.object.stime22[1] = ''
//dw_insert.object.stime32[1] = ''
//dw_insert.object.stime42[1] = ''
//dw_insert.object.stime52[1] = ''
//dw_insert.object.stime62[1] = ''
//
//sle_msg.text = ''
//
end subroutine

on w_pdt_01030.create
int iCurrent
call super::create
this.dw_process=create dw_process
this.st_runmsg=create st_runmsg
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_process
this.Control[iCurrent+2]=this.st_runmsg
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
end on

on w_pdt_01030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_process)
destroy(this.st_runmsg)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;dw_process.settransobject(sqlca)
dw_process.reset()
dw_process.insertrow(0)
dw_insert.insertrow(0)

String sym
Long   lmaxseq

select substr(yeayymm, 1, 4), Max(yeacha)
  into :sym,						:lmaxseq
  from yeapln
 Where sabu = :gs_sabu
	and substr(yeayymm, 1, 4) = 
			  (select substr(max(yeayymm), 1, 4)
				  from yeapln
				 where sabu = :gs_sabu and yeagu = 'A')
	and yeagu = 'A'
 group by substr(yeayymm, 1, 4);

dw_process.setitem(1, "giyymm", sym)
dw_process.setitem(1, "gseq", 	 lmaxseq)
dw_process.setitem(1, "mrprun", f_today())

dw_process.object.sidat[1] = sym + '01'
dw_process.object.eddat[1] = sym + '12'
dw_process.object.sidat.format = '@@@@.@@'
dw_process.object.eddat.format = '@@@@.@@'

if lMaxseq > 0 then
	p_search.enabled = true
	p_search.PictureName = 'C:\erpman\image\����_up.gif'
end if

/* �ΰ� ����� */
f_mod_saupj(dw_process, 'saupj')

end event

type dw_insert from w_inherite`dw_insert within w_pdt_01030
integer x = 2441
integer y = 252
integer width = 1829
integer height = 1676
integer taborder = 0
string dataobject = "d_pdt_01030_1"
boolean border = false
end type

type p_delrow from w_inherite`p_delrow within w_pdt_01030
boolean visible = false
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdt_01030
boolean visible = false
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdt_01030
integer x = 4265
string pointer = "C:\erpman\cur\create2.cur"
boolean enabled = false
string picturename = "C:\erpman\image\����_d.gif"
end type

event p_search::clicked;call super::clicked;/* MRP Server procedure �� ����
   step���� error check�� �����Ͽ� error�� �߻��� ��� �ش��������
	�ߴ� */
String sgijun, sgyymm, serror, smsgtxt, scalgu, sTxt, sstdat, seddat, scheck, sLoop, ssaupj
String temp_calgu
integer dseq, dCnt, dMaxno, dAddNo

if dw_process.accepttext() = -1 then return 	

sgijun = String(dw_process.object.gijun[1])
sgyymm = trim(dw_process.object.giyymm[1])
dseq   = dw_process.object.gseq[1]
scalgu = dw_process.object.gcalgu[1]
sstdat = trim(dw_process.object.sidat[1])
seddat = trim(dw_process.object.eddat[1])
ssaupj  = trim(dw_process.object.saupj[1])

if sgijun = '2' then
	if isnull(scalgu) or trim(scalgu) = '' then
		f_message_chk(30, '[�������]')
		dw_process.Setcolumn('gcalgu')
		dw_process.SetFocus()
		return
	end if
end if

temp_calgu = scalgu
if temp_calgu = '3' then
	scalgu = '1'
end if

if sgijun = '1' then 
	if isnull(sgyymm) or sgyymm = "" then
		f_message_chk(30,'[��ȹ�⵵]')
		dw_process.Setcolumn('giyymm')
		dw_process.SetFocus()
		return
	end if
	smsgtxt = sgyymm + '�� ' + string(dseq) + '�� ���� �ҿ䷮ ����(MRP)ó���� �Ͻðڽ��ϱ�?'
else
	if isnull(sgyymm) or sgyymm = "" then
		f_message_chk(30,'[��ȹ���]')
		dw_process.Setcolumn('giyymm')
		dw_process.SetFocus()
		return
	end if
	smsgtxt = left(sgyymm ,4)+ '�� ' + right(sgyymm,2) + '�� ' &
	          + string(dseq) + '�� ���� �ҿ䷮ ����(MRP)ó���� �Ͻðڽ��ϱ�?'
end if	

if messagebox("Ȯ ��", smsgtxt, Question!, YesNo!, 2) = 2 then return   
sLoop = 'N'

setpointer(hourglass!)

NEXTSTEP:

wf_clear()

serror = 'X'
icnt = 0
dw_insert.object.step1[1]   = '1'
dw_insert.object.stime11[1] = f_totime()

// Mrp History Create
/* MRP�����̷��� �ִ� ��������� ���Ѵ� */
SELECT MAX(ACTNO)	
  INTO :dmaxno
  FROM MRPSYS
 WHERE SABU = :gs_sabu;

if isnull(dmaxno) then dmaxno = 0;

dMaxno = dmaxno + 1

IF sCalgu = '1' THEN
	sTXT	= 'FACTOR����';
ELSEIF sCalgu = '2' THEN
	sTXT  = 'FACTOR�������';
ELSE
	sTXT  = 'FACTOR����+�������';
END IF;


/* MRP�̷��� �ۼ��Ѵ� */
INSERT INTO MRPSYS (SABU, ACTNO, MRPRUN, MRPGIYYMM, MRPDATA, MRPCUDAT, MRPSIDAT,
						  MRPEDDAT, MRPTXT, MRPSEQ, MRPCALGU, MRPPDTSND, MRPMATSND, MRPDELETE, SAUPJ)
		VALUES(:gs_sabu, :dMAXNO, TO_CHAR(SYSDATE, 'YYYYMMDD'), :sGyymm, :sgijun,
				 TO_CHAR(SYSDATE, 'YYYYMMDD'), :sstdat, :seddat, :stxt, :dseq, 'N','N','N','N', :ssaupj);
If sqlca.sqlcode <> 0 then
	ROLLBACK;
	sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Mrp History Create]' + '~n' + sqlca.sqlerrtext)
	dw_process.setfocus()
	return
END If

COMMIT;

/* Factor����п� ����  Factor������� ���� ��ȣ�� �����Ѵ�. */
if sLoop = 'Y' then
	Update mrpsys
		set mrpaddno = :dMaxno
	 Where sabu = :gs_sabu and actno = :dAddno;
	 
	If sqlca.sqlcode <> 0 then
		ROLLBACK;
		sle_msg.text = ""
		f_message_chk(41,'[MRP�߰� �̷� �ۼ�]' + '~n' + sqlca.sqlerrtext)
		dw_process.setfocus()
		return
	END If	 
End if;

COMMIT;

if sLoop = 'N' then
	openwithparm(w_pdt_01030_2, dmaxno)
else
	// Factor����� ����� ����â�� Copy
	insert into mrpsys_depot
		Select sabu, :dMaxno, Depot_no
		  From mrpsys_depot
		 Where Sabu = :gs_sabu And Actno = :dAddno;
	If sqlca.sqlcode <> 0 then
		ROLLBACK;
		sle_msg.text = ""
		f_message_chk(41,'[���� â�� ����]' + '~n' + sqlca.sqlerrtext)
		dw_process.setfocus()
		return
	END If	 		 
	// Factor����� ����� �������� Copy
	insert into mrpsys_dtl
		Select sabu, :dMaxno, Dptgu
		  From mrpsys_dtl
		 Where Sabu = :gs_sabu And Actno = :dAddno;		
	If sqlca.sqlcode <> 0 then
		ROLLBACK;
		sle_msg.text = ""
		f_message_chk(41,'[���� ������ ����]' + '~n' + sqlca.sqlerrtext)
		dw_process.setfocus()
		return
	END If
	
	sCheck = 'Y'
end if

sCheck = message.stringparm
if sCheck = 'N' then 
	return
end if
w_mdi_frame.sle_msg.text = "���� �ҿ䷮ ����(MRP)ó����. .............."

String ssilgu
ssilgu = f_get_syscnfg('S', 8, '40')

// mrp initial
srunmsg = "���� �ҿ䷮ ����(MRP)ó����. .............." + "MRP Initial Create"
dw_insert.object.step1[1]   = '1'
wf_message(srunmsg)
sqlca.erp200000050_1(gs_sabu, dmaxno, sgijun, sgyymm, dseq, ssaupj, ssilgu, serror); 
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Mrp Initial]' + '~n' + sqlca.sqlerrtext)
	dw_process.setfocus()
	return
END IF
//dw_insert.object.step1[1]   = 'Y'
dw_insert.object.step1[1]   = '2'
dw_insert.object.stime12[1] = f_totime()

// open order merge
icnt = 0
srunmsg = "���� �ҿ䷮ ����(MRP)ó����. ..............Open Order Merge"
dw_insert.object.step2[1]   = '1'
wf_message(srunmsg)
IF SCALGU = '1' THEN /* FACTOR�� �����ϴ� ��쿡�� ���� */
	dw_insert.object.stime21[1] = f_totime()
	sqlca.erp200000050_2(gs_sabu, dmaxno, sgijun, serror);
	If isnull(serror) or serror = 'X' or serror = 'Y' then
		w_mdi_frame.sle_msg.text = ""
		f_message_chk(41,'[MRP RUN-Open Order Merge]'+ '~n' + sqlca.sqlerrtext)
		dw_process.setfocus()
		return
	END IF
	//dw_insert.object.step2[1]   = 'Y'
	dw_insert.object.step2[1]   = '2'
	dw_insert.object.stime22[1] = f_totime()
END IF

// product schedule
icnt = 0
srunmsg = "���� �ҿ䷮ ����(MRP)ó����. ..............Open Product Schedule"
dw_insert.object.step3[1]   = '1'
wf_message(srunmsg)
dw_insert.object.stime31[1] = f_totime()
sqlca.erp200000050_3(gs_sabu, dmaxno, sgijun, sgyymm, dseq, ssaupj, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN- Product Schedule]'+ '~n' + sqlca.sqlerrtext)
	dw_process.setfocus()
	return
END IF
//dw_insert.object.step3[1]   = 'Y'
dw_insert.object.step3[1]   = '2'
dw_insert.object.stime32[1] = f_totime()

// manufacturing resource create
icnt = 0
srunmsg = "���� �ҿ䷮ ����(MRP)ó����. ..............Manufacturing Resource Create"
dw_insert.object.step4[1]   = '1'
wf_message(srunmsg)
dw_insert.object.stime41[1] = f_totime()

sqlca.erp200000050_4(gs_sabu, dmaxno, sgijun, sgyymm, scalgu, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Manufacturing Resource Create]'+ '~n' + sqlca.sqlerrtext)
	dw_process.setfocus()
	return
END IF
//dw_insert.object.step4[1]   = 'Y'
dw_insert.object.step4[1]   = '2'
dw_insert.object.stime42[1] = f_totime()

// mrp detail record create
icnt = 0
srunmsg = "���� �ҿ䷮ ����(MRP)ó����. ..............MRP Detail Record Create"
dw_insert.object.step5[1]   = '1'
wf_message(srunmsg)
dw_insert.object.stime51[1] = f_totime()
sqlca.erp000000050_5(gs_sabu, dmaxno, sgijun, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Mrp Detail Record Create]'+ '~n' + sqlca.sqlerrtext)
	dw_process.setfocus()
	return
END IF
dw_insert.object.step5[1]   = 'Y'
dw_insert.object.step5[1]   = '2'
dw_insert.object.stime52[1] = f_totime()

// plan detail record create
icnt = 0
srunmsg = "���� �ҿ䷮ ����(MRP)ó����. ..............Plan Detail Record Create"
dw_insert.object.step6[1]   = '1'
wf_message(srunmsg)
dw_insert.object.stime61[1] = f_totime()
sqlca.erp000000050_6(gs_sabu, dmaxno, sgijun, serror);
If isnull(serror) or serror = 'X' or serror = 'Y' then
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[MRP RUN-Plan Detail Record Create]'+ '~n' + sqlca.sqlerrtext)
	dw_process.setfocus()
	return
END IF
//dw_insert.object.step6[1]   = 'Y'
dw_insert.object.step6[1]   = '2'
dw_insert.object.stime62[1] = f_totime()

/* MRP����� ���������� ����Ǿ��ٴ� ǥ�ø� �Ѵ� */
Update mrpsys
   set mrpcalgu = 'Y'
 Where sabu = :gs_sabu and actno = :dmaxno;

If sqlca.sqlcode <> 0 then
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(41,'[����̷� �ۼ��� �����߻�]'+ '~n' + sqlca.sqlerrtext)
	dw_process.setfocus()
	return
END If 

Update reffpf
   set rfna2 = to_char(:dmaxno)
 where sabu = '1' and rfcod = '1A' and rfgub = '1';

COMMIT;

// ��ȹ������ ������ȹ�̸鼭 Factor������ ��쿡�� Factor�� �������� �ʰ� 
// �ٽ��ѹ� ����Ѵ�.
IF sGijun = '2' And temp_calgu = '3' then
	sCalgu = '2'
	temp_calgu = '2'
	dAddno = dMaxno
	sLoop  = 'Y'
	goto nextstep
end if

messagebox("���� �ҿ䷮ ���", "�����ȣ -> " + string(dmaxno) + " �� ��������Ǿ����ϴ�")

w_mdi_frame.sle_msg.text = ""
dw_process.setfocus()

end event

event p_search::ue_lbuttondown;call super::ue_lbuttondown;this.PictureName =  'C:\erpman\image\����_dn.gif'
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;this.PictureName =  'C:\erpman\image\����_up.gif'
end event

type p_ins from w_inherite`p_ins within w_pdt_01030
boolean visible = false
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdt_01030
end type

type p_can from w_inherite`p_can within w_pdt_01030
boolean visible = false
boolean enabled = false
end type

type p_print from w_inherite`p_print within w_pdt_01030
boolean visible = false
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdt_01030
boolean visible = false
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_pdt_01030
boolean visible = false
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_pdt_01030
boolean visible = false
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_pdt_01030
integer x = 4206
integer y = 1976
integer taborder = 30
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_pdt_01030
integer x = 549
integer y = 2508
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_01030
integer x = 187
integer y = 2508
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdt_01030
integer x = 910
integer y = 2508
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_01030
integer x = 1271
integer y = 2508
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pdt_01030
integer x = 1632
integer y = 2508
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_01030
end type

type cb_can from w_inherite`cb_can within w_pdt_01030
integer x = 1993
integer y = 2508
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pdt_01030
integer x = 2354
integer y = 2508
boolean enabled = false
end type





type gb_10 from w_inherite`gb_10 within w_pdt_01030
integer x = 18
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_01030
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_01030
end type

type dw_process from u_key_enter within w_pdt_01030
integer x = 571
integer y = 252
integer width = 1714
integer height = 1672
integer taborder = 10
string dataobject = "d_pdt_01030"
boolean border = false
end type

event itemchanged;long   lmaxseq
int    i_gijun
string snull, sYm, sDate, sMaxdate, scheck, sprvdat, scolumn

sColumn = dwo.name
if sColumn = 'sidat' or scolumn = 'eddat' then
	sprvdat = this.getitemstring(1, scolumn)
end if

this.accepttext()
Setnull(snull)

sDate = f_today()

Choose case dwo.name
		 case 'gijun'
				lmaxseq = 0
				sle_msg.text = '�ڷ� �˻���'
				
				if integer(data) = 1 then
					/* �Ⱓ �����ȹ�� ���� �ִ� ��� �� ���� */
					select substr(yeayymm, 1, 4), Max(yeacha)
					  into :sym,						:lmaxseq
					  from yeapln
					 Where sabu = :gs_sabu
						and substr(yeayymm, 1, 4) = 
								  (select substr(max(yeayymm), 1, 4)
									  from yeapln
									 where sabu = :gs_sabu and yeagu = 'A')
						and yeagu = 'A'
					 group by substr(yeayymm, 1, 4);
				else
					/* ���� �����ȹ�� ���� �ִ� ���� */
					select monyymm, Max(moseq)
					  into :sym, :lMaxseq
					  from monpln_dtl
					 Where sabu = :gs_sabu
						and monyymm = 
								  (select max(monyymm)
									  from monpln_dtl
									 where sabu = :gs_sabu)
					 group by monyymm;
				end if			
				
				sle_msg.text = ''				
				
				/* ������ = 1 �� ��� �Ⱓ�����ȹ�� �ִ������� �����ϰ�
					������ = 2 �� ��� ���������ȹ�� �ִ������� �����Ѵ� */
								
				if isnull(sym) 	 or trim(sym) = '' or &
					isnull(lmaxseq) or lmaxseq = 0 then
					f_message_chk(72,'[��ȹ�⵵ �Ǵ� ��]')
					RETURN  1
				End if				
			
				/* ���ؿ� ���� �⵵ �Ǵ� ����� �Է��� �� �ְ� editmask�� �����Ѵ� */
				if integer(data) = 1 then
					this.object.giyymm.editmask.mask = '####'
					this.object.gcalgu[1] = '2'
				else
					this.object.giyymm.editmask.mask = '####.##'
					this.object.gcalgu[1] = '1'
				end if
				dw_process.object.giyymm[1] = snull
				dw_process.object.gseq[1] = 0
				dw_process.object.sidat[1] = snull
				dw_process.object.eddat[1] = snull
				wf_clear()
			
				this.object.giyymm[1] = sym
				this.object.gseq[1] 	= lmaxseq
				/* ������ȹ�� �������� �������ڷ� �����ϰ�
					5���� ���� ���ڸ� �������ڷ� �����Ѵ� */
				if integer(data) = 2 then
					if sym+'01' > sDate then
						this.object.sidat[1] = sym + '01'
					else
						this.object.sidat[1] = sDate
					end if				
					this.object.eddat[1] = f_last_date(f_aftermonth(left(sym, 6), 4))
					this.object.sidat.format = '@@@@.@@.@@'
					this.object.eddat.format = '@@@@.@@.@@'
					pb_1.visible = True
					pb_2.visible = True
				Else
					this.object.sidat[1] = sym + '01'
					this.object.eddat[1] = sym + '12'
					this.object.sidat.format = '@@@@.@@'
					this.object.eddat.format = '@@@@.@@'
					pb_1.visible = False
					pb_2.visible = False
				End if

				p_search.enabled = True
				p_search.PictureName = 'C:\erpman\image\����_up.gif'
		 case 'giyymm'
			   i_gijun = this.getitemnumber(1, 'gijun')
				
				sle_msg.text = '�ڷ� �˻���'
				if i_gijun = 1 then 
					/* �Ⱓ �����ȹ�� ���� �ִ� ��� �� ���� */
					select substr(yeayymm, 1, 4), Max(yeacha)
					  into :sym,						:lmaxseq
					  from yeapln
					 Where sabu = :gs_sabu
						and substr(yeayymm, 1, 4) = :data
						and yeagu = 'A'
					 group by substr(yeayymm, 1, 4);
				else
				  	IF f_datechk(data + '01') = -1	then

						f_message_chk(35, '[��ȹ���]')
						this.setitem(1, "giyymm", sNull)
						return 1
					END IF
					/* ���� �����ȹ�� ���� �ִ� ���� */
					select monyymm, Max(moseq)
					  into :sym, :lMaxseq
					  from monpln_dtl
					 Where sabu = :gs_sabu
						and monyymm = :data
					 group by monyymm;
				end if			
				
				sle_msg.text = ''				
				/* ������ = 1 �� ��� �Ⱓ�����ȹ�� �ִ������� �����ϰ�
					������ = 2 �� ��� ���������ȹ�� �ִ������� �����Ѵ� */
				if isnull(sym) 	 or trim(sym) = '' or &
					isnull(lmaxseq) or lmaxseq = 0 then
					f_message_chk(72,'[��ȹ�⵵ �Ǵ� ��]')
					this.setitem(1, "giyymm", sNull)
					RETURN  1
				End if				
			
				this.object.gseq[1] 	= lmaxseq
				/* ������ȹ�� �������� �������ڷ� �����ϰ�
					5���� ���� ���ڸ� �������ڷ� �����Ѵ� */
				if i_gijun = 2 then
					if sym+'01' > sDate then
						this.object.sidat[1] = sym + '01'
					else
						this.object.sidat[1] = sDate
					end if				
					this.object.eddat[1] = f_last_date(f_aftermonth(left(sym, 6), 4))
					this.object.sidat.format = '@@@@.@@.@@'
					this.object.eddat.format = '@@@@.@@.@@'
				Else
					this.object.sidat[1] = sym + '01'
					this.object.eddat[1] = sym + '12'
					this.object.sidat.format = '@@@@.@@'
					this.object.eddat.format = '@@@@.@@'
				End if

				p_search.enabled = True
				p_search.PictureName = 'C:\erpman\image\����_up.gif'
		 case 'sidat'	// ��������
				if f_datechk(data) = -1 then
					f_message_chk(35, '[��ȹ������]')
					this.setitem(1, "sidat", sPrvdat)
					return 1
				end if
//			
//				if data < sDate then
//					f_message_chk(312, '[��ȹ������]')
//					this.setitem(1, "sidat", sDate)
//					return 1
//				end if
				
				sMaxdate = f_last_date(f_aftermonth(left(sym, 6), 4))
				
				if data > sDate then
					f_message_chk(313, '[��ȹ������]')
					this.setitem(1, "sidat", sDate)
					return 1
				end if
				
				scheck = this.getitemstring(1, "eddat")
				
				if data > scheck then
					f_message_chk(34, '[��ȹ������]')
					this.setitem(1, "sidat", sDate)
					return 1
				end if				
		 case 'eddat'	// ��������
				if f_datechk(data) = -1 then
					f_message_chk(35, '[��ȹ������]')
					this.setitem(1, "eddat", sPrvdat)
					return 1
				end if			
			
/*				sMaxdate = f_last_date(f_aftermonth(left(sDate, 6), 5))							
			
				if data < sDate then
					f_message_chk(312, '[��ȹ������]')
					this.setitem(1, "eddat", sMaxDate)
					return 1
				end if
							
				if data > sDate then
					f_message_chk(313, '[��ȹ������]')
					this.setitem(1, "eddat", sMaxDate)
					return 1
				end if */
				
				scheck = this.getitemstring(1, "sidat")
				
				if data < scheck then
					f_message_chk(34, '[��ȹ������]')
					this.setitem(1, "eddat", sMaxDate)
					return 1
				end if						
End choose
end event

event itemerror;return 1
end event

type st_runmsg from statictext within w_pdt_01030
boolean visible = false
integer x = 41
integer y = 2104
integer width = 1705
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean italic = true
long backcolor = 12632256
boolean enabled = false
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_pdt_01030
boolean visible = false
integer x = 1518
integer y = 1588
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_process.Setcolumn('sidat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_process.SetItem(1, 'sidat', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_01030
boolean visible = false
integer x = 1518
integer y = 1776
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_process.Setcolumn('eddat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_process.SetItem(1, 'eddat', gs_code)
end event

