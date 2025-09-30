$PBExportHeader$w_pdm_01270.srw
$PBExportComments$ǰ�񸶽�Ÿ���
forward
global type w_pdm_01270 from w_inherite
end type
type rr_1 from roundrectangle within w_pdm_01270
end type
type gb_3 from groupbox within w_pdm_01270
end type
type gb_2 from groupbox within w_pdm_01270
end type
type dw_1 from datawindow within w_pdm_01270
end type
type cbx_auto from checkbox within w_pdm_01270
end type
type cb_desc from commandbutton within w_pdm_01270
end type
type cb_dept from commandbutton within w_pdm_01270
end type
type dw_dept from datawindow within w_pdm_01270
end type
type rr_2 from roundrectangle within w_pdm_01270
end type
type dw_list from u_d_popup_sort within w_pdm_01270
end type
type p_desc from picture within w_pdm_01270
end type
type p_print1 from picture within w_pdm_01270
end type
type p_dept from picture within w_pdm_01270
end type
type p_sea from picture within w_pdm_01270
end type
type p_copy from picture within w_pdm_01270
end type
type p_6 from picture within w_pdm_01270
end type
type pb_1 from u_pb_cal within w_pdm_01270
end type
type pb_2 from u_pb_cal within w_pdm_01270
end type
type pb_3 from u_pb_cal within w_pdm_01270
end type
type pb_4 from u_pb_cal within w_pdm_01270
end type
end forward

global type w_pdm_01270 from w_inherite
integer width = 4667
integer height = 2484
string title = "ǰ�񸶽�Ÿ���"
rr_1 rr_1
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
cbx_auto cbx_auto
cb_desc cb_desc
cb_dept cb_dept
dw_dept dw_dept
rr_2 rr_2
dw_list dw_list
p_desc p_desc
p_print1 p_print1
p_dept p_dept
p_sea p_sea
p_copy p_copy
p_6 p_6
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
end type
global w_pdm_01270 w_pdm_01270

type variables
String ls_gub = 'Y' //Y:���,N:����
str_itnct lstr_sitnct
string  is_version, is_Auto

end variables

forward prototypes
public subroutine wf_init ()
public function string wf_copy ()
public function character wf_version_up (character old_version)
public function integer wf_itnbr ()
public function integer wf_add_seqno_yakum ()
public function integer wf_rename ()
public function integer wf_itnbr_check (string sitnbr)
public function integer wf_required_chk ()
public function integer wf_add_seqno ()
public function integer wf_name_chk ()
public subroutine wf_retrieve (string arg_dcomp, string s_pumgu, string s_date, string s_use)
end prototypes

public subroutine wf_init ();dw_insert.SetRedraw(false)

dw_insert.Reset()
dw_insert.insertRow(0)

dw_insert.SetRedraw(true)

dw_insert.SetTaborder('itnbr',1)

dw_dept.Reset()
dw_insert.setfocus()
ls_gub = 'Y'    //'Y'�̸� ��ϸ��

end subroutine

public function string wf_copy ();//////////////////////////////////////////////////////////////////////
// 	1. ǰ�񱸺� + MODEL/ǰ��з� + SEQ NO + VERSION -> ǰ���ڵ� copy 
//////////////////////////////////////////////////////////////////////
String 	sItnbr,	sIttyp, sGubcode, sSeq, sVersion
long     lSeq

dw_insert.accepttext()
//ǰ�񱸺�
sIttyp = dw_insert.getitemstring(1, 'ittyp')
sGubcode = dw_insert.getitemstring(1, 'itcls')

sGubcode = left(sGubcode, 4)	
	
SELECT "ITNCT"."SEQ"  
  INTO :lSeq  
  FROM "ITNCT"  
 WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
		 ( "ITNCT"."ITCLS" = :sGubcode ) AND  
		 ( "ITNCT"."LMSGU" = 'M' ) FOR UPDATE  ;

if sqlca.sqlcode = 0 then
   lSeq = lseq + 1
else
	lseq = 1
end if

dw_insert.SetItem(1, "seqno" , lSeq )

sSeq = string(lSeq, "0000")   //SEQ NO

sVersion = dw_insert.getitemstring(1, 'itnbr_version')

sItnbr = sIttyp + sGubCode + sSeq + sVersion

RETURN sItnbr

end function

public function character wf_version_up (character old_version);//********************************************************************//
//  function name : wf_version_up
//       argument : String old_version(���� ����)
//         return : String (��ȯ�� ����� ����)
//                  0(48) - 9(57), A(65) - Z(90) 
//*******************************************************************//
integer i_new, i_old
char  new_version

i_old = ASC(old_version) 

IF i_old = 57 THEN
	i_new = 65
ELSEIF i_old = 90 THEN
   MessageBox("Ȯ ��", "���������� �����Ͽ����ϴ�. ���������� 'Z'�� ���� �� �����ϴ�.!!")
   RETURN ''
ELSE	
   i_new = i_old + 1
END IF	

new_version = CHAR(i_new)

RETURN new_version
end function

public function integer wf_itnbr ();String 	sItnbr,	get_name

sItnbr = dw_insert.GetItemString(1, "itnbr")	
IF IsNull(sItnbr) or sItnbr = ''	THEN
	f_message_chk(1400,'[ǰ��]')
	dw_insert.setcolumn('itnbr')
	dw_insert.setfocus()
	RETURN -1
ELSE
	SELECT "ITEMAS"."ITNBR"  
	  INTO :get_name  
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ITNBR" = :sitnbr   ;

	if sqlca.sqlcode = 0 then 
		f_message_chk(37,'[ǰ��]')
		dw_insert.setcolumn('itnbr')
		dw_insert.setfocus()
		RETURN -1
	end if		   
END IF

Return 1
end function

public function integer wf_add_seqno_yakum ();string sIttyp, sGubcode, smid
long   lSeq

sIttyp = dw_insert.getitemstring(1, 'ittyp')

sGubcode = dw_insert.getitemstring(1, 'itcls')
smid = Left(sGubcode, 2) 

lSeq = dw_insert.getitemnumber(1, 'seqno') 

UPDATE "ITNCT"  
   SET "SEQ" = :lSeq  
 WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
		 ( "ITNCT"."ITCLS" = :smid ) AND  
		 ( "ITNCT"."LMSGU" = 'L' )   ;

if sqlca.sqlcode = 0 then 
   return 1
else
	return -1
end if	

end function

public function integer wf_rename ();//////////////////////////////////////////////////////////////////////
// 	1. ǰ�񱸺� + MODEL/ǰ��з� + SEQ NO + VERSION -> ǰ���ڵ� ä�� 
//////////////////////////////////////////////////////////////////////
String 	sItnbr,	sIttyp, sGubcode, sSeq, sVersion,	&
			sAuto, get_name
long     lSeq

//ǰ�񱸺�
sIttyp = dw_insert.getitemstring(1, 'ittyp')
sGubcode = dw_insert.getitemstring(1, 'itcls')

// �ߺз��ڵ�
sGubcode = left(sGubcode, 4)	

// �ߺз��ڵ� �ڵ�ä�� CHECK
SELECT "AUTO"
  INTO :sAuto
  FROM "ITNCT"  
 WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
		 ( "ITNCT"."ITCLS" = :sGubcode ) AND  
		 ( "ITNCT"."LMSGU" = 'M' )   ;

if sqlca.sqlcode <> 0 then
	f_message_chk(51,'[ǰ��з�]')
	return -1
end if
//////////////////////////////////////////////////////////////////////////

IF sAuto = 'Y'		THEN

	SELECT "ITNCT"."SEQ"  
	  INTO :lSeq  
	  FROM "ITNCT"  
	 WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
			 ( "ITNCT"."ITCLS" = :sGubcode ) AND  
			 ( "ITNCT"."LMSGU" = 'M' ) FOR UPDATE ;

	if sqlca.sqlcode = 0 then
		lSeq = lseq + 1
	else
		f_message_chk(51,'[ǰ��]')
		return -1
	end if

	dw_insert.SetItem(1, "seqno" , lSeq )
	sSeq = string(lSeq, "0000")   //SEQ NO
	sVersion = dw_insert.getitemstring(1, 'itnbr_version')
	sItnbr = sIttyp + sGubCode + sSeq      //���� ����+ sVersion
	dw_insert.SetItem(1, "itnbr" , sItnbr )
	dw_insert.SetItem(1, "itemas_auto" , 'Y' )
ELSE
	MessageBox("Ȯ��", "�ߺз��ڵ��� �ڵ�ä�������� Ȯ���Ͻʽÿ�.~r" +  &
							 "�ߺз��ڵ� �ڵ�ä�������� N0 �� �����Ǿ� �ֽ��ϴ�.")
	RETURN -1
END IF

Return 1
end function

public function integer wf_itnbr_check (string sitnbr);Long icnt = 0

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '���� ���� ���� CHECK ��.....'

select count(*) into :icnt
  from vnddan
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[�ŷ�ó��ǰ�ܰ�]')
	return -1
end if

select count(*) into :icnt
  from danmst
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[�ܰ�����Ÿ]')
	return -1
end if

select count(*) into :icnt
  from poblkt
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[����_ǰ������]')
	return -1
end if

select count(*) into :icnt
  from estima
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[���ֿ���_�����Ƿ�]')
	return -1
end if

select count(*) into :icnt
  from sorder
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[����]')
	return -1
end if

select count(*) into :icnt
  from exppid
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[����PI Detail]')
	return -1
end if

select count(*) into :icnt
  from imhist
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[������̷�]')
	return -1
end if

//��� BOM üũ  
  SELECT COUNT("ESTRUC"."USSEQ")  
    INTO :icnt  
    FROM "ESTRUC"  
   WHERE "ESTRUC"."PINBR" = :sitnbr OR "ESTRUC"."CINBR" = :sitnbr ;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[���BOM]')
	return -1
end if
	
//���� BOM üũ  
  SELECT COUNT("PSTRUC"."USSEQ")  
    INTO :icnt  
    FROM "PSTRUC"  
   WHERE "PSTRUC"."PINBR" = :sitnbr OR "PSTRUC"."CINBR" = :sitnbr ;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[����BOM]')
	return -1
end if

//���� BOM üũ  
  SELECT COUNT("WSTRUC"."USSEQ")  
    INTO :icnt  
    FROM "WSTRUC"  
   WHERE "WSTRUC"."PINBR" = :sitnbr OR "WSTRUC"."CINBR" = :sitnbr ;	

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[����BOM]')
	return -1
end if

//���ִܰ� BOM üũ  
  SELECT SUM(1)  
    INTO :icnt  
    FROM "WSUNPR"  
   WHERE "WSUNPR"."ITNBR" = :sitnbr;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[���ִܰ�BOM]')
	return -1
end if

//�Ҵ� üũ
select count(*) into :icnt
  from holdstock
 where itnbr = :sitnbr;
		 
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[�Ҵ�]')
	return -1
end if

//�� ���
select count(*) into :icnt
  from stockmonth
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[�������]')
	return -1
end if

w_mdi_frame.sle_msg.text = ''
return 1
end function

public function integer wf_required_chk ();string snull, sasc, s_ittyp, s_itcls, get_nm
int iasc

setnull(snull)

dw_insert.AcceptText()

if isnull(dw_insert.GetItemString(1,'ittyp')) or &
	trim(dw_insert.GetItemString(1,'ittyp')) = "" then
	f_message_chk(1400,'[ǰ�񱸺�]')
	dw_insert.SetColumn('ittyp')
	dw_insert.SetFocus()
	return -1
end if	

// ǰ���� �Ǵ� �������°� nULL�� ��쿡�� ǰ�񱸺��� �̿��Ͽ� �⺻���� Setting
if dw_insert.getitemstring(1, 'ittyp') = '1' or & 
	dw_insert.getitemstring(1, 'ittyp') = '2' Then
Else
	dw_insert.setitem(1, "itemas_itgu", dw_insert.GetItemString(1, 'temp_itgu'))
End if
	
if Isnull(dw_insert.getitemstring(1, 'itemas_itgu')) or &
   Trim(dw_insert.getitemstring(1, 'itemas_itgu')) = '' then
	if dw_insert.getitemstring(1, 'ittyp') = '1' or & 
		dw_insert.getitemstring(1, 'ittyp') = '2' Then
		dw_insert.setitem(1, "itemas_itgu", '5')
	Else
		dw_insert.setitem(1, "itemas_itgu", '2')
	End if
End if
	

if isnull(dw_insert.GetItemString(1,'itcls')) or &
	dw_insert.GetItemString(1,'itcls') = "" then
	f_message_chk(1400,'[ǰ��з�]')
	dw_insert.SetColumn('itcls')
	dw_insert.SetFocus()
	return -1
else
	s_ittyp = dw_insert.getitemstring(1, 'ittyp')
   s_itcls = dw_insert.getitemstring(1, 'itcls')
	
  SELECT "ITNCT"."TITNM"  
    INTO :get_nm  
    FROM "ITNCT"  
   WHERE ( "ITNCT"."ITTYP" = :s_ittyp ) AND  
         ( "ITNCT"."ITCLS" = :s_itcls ) AND  
         ( "ITNCT"."LMSGU" <> 'L' )   ;

	IF SQLCA.SQLCODE <> 0 THEN
   	f_message_chk(33,'[ǰ��з�]')
		dw_insert.SetColumn('itcls')
		dw_insert.SetFocus()
   	return -1
   END IF
end if			

if isnull(dw_insert.GetItemString(1,'itdsc')) or &
	dw_insert.GetItemString(1,'itdsc') = "" then
	f_message_chk(1400,'[ǰ��]')
	dw_insert.SetColumn('itdsc')
	dw_insert.SetFocus()
	return -1
end if	

sAsc =  trim(dw_insert.GetItemString(1,'ispec')) 
 
iAsc = asc(sAsc)
if sAsc = "" or iAsc = 13 then   // ||(ctrl + enter ��) = 13(ascii code ��)   
 	dw_insert.SetItem(1, 'ispec', snull)
end if	

//if isnull(dw_insert.GetItemString(1,'itnbr_version')) or &
//	dw_insert.GetItemString(1,'itnbr_version') = "" then
//	f_message_chk(1400,'[VERSION]')
//	dw_insert.SetColumn('itnbr_version')
//	dw_insert.SetFocus()
//	return -1
//end if	

if isnull(dw_insert.GetItemString(1,'lotgub')) or &
	dw_insert.GetItemString(1,'lotgub') = "" then
	f_message_chk(1400,'[LOT NO ������ȣ]')
	dw_insert.SetColumn('lotgub')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'gbwan')) or &
	dw_insert.GetItemString(1,'gbwan') = "" then
	f_message_chk(1400,'[���߿Ϸᱸ��]')
	dw_insert.SetColumn('gbwan')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'gbgub')) or &
	dw_insert.GetItemString(1,'gbgub') = "" then
	f_message_chk(1400,'[���߱���]')
	dw_insert.SetColumn('gbgub')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'useyn')) or &
	dw_insert.GetItemString(1,'useyn') = "" then
	f_message_chk(1400,'[��뱸��]')
	dw_insert.SetColumn('useyn')
	dw_insert.SetFocus()
	return -1
end if	

return 1
end function

public function integer wf_add_seqno ();string sIttyp, sGubcode, smid
long   lSeq

sIttyp = dw_insert.getitemstring(1, 'ittyp')

sGubcode = dw_insert.getitemstring(1, 'itcls')
smid = Left(sGubcode, 4) 

lSeq = dw_insert.getitemnumber(1, 'seqno') 

UPDATE "ITNCT"  
   SET "SEQ" = :lSeq  
 WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
		 ( "ITNCT"."ITCLS" = :smid ) AND  
		 ( "ITNCT"."LMSGU" = 'M' )   ;

if sqlca.sqlcode = 0 then 
   return 1
else
	return -1
end if	
end function

public function integer wf_name_chk ();string s_itnbr, s_itdsc, s_ispec, s_jijil, s_ittyp, sispec_code
long   get_count

if dw_insert.AcceptText() = -1 then return -1

/////////////////////////////////////////////////////////////////////////////
s_ittyp = trim(dw_insert.Getitemstring(1, 'ittyp'))
s_itnbr = trim(dw_insert.Getitemstring(1, 'itnbr'))
s_itdsc = trim(dw_insert.Getitemstring(1, 'itdsc'))
s_ispec = trim(dw_insert.Getitemstring(1, 'ispec'))
s_jijil = trim(dw_insert.Getitemstring(1, 'jijil'))
sispec_code = trim(dw_insert.Getitemstring(1, 'ispec_code')) 

// null �� üũ
if s_ispec = '' or isnull(s_ispec) then s_ispec = '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' 
if s_jijil = '' or isnull(s_jijil) then s_jijil = '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@' 
if sispec_code = '' or isnull(sispec_code) then sispec_code = '@@@@@@@@@@@@@@@@@@@@' 

IF ls_gub = 'Y' THEN 
	SELECT COUNT(ITNBR)    INTO :get_count  
	  FROM ITEMAS  
	 WHERE ITDSC = :s_itdsc 
	   AND NVL(ISPEC, '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') = :s_ispec
		AND NVL(JIJIL, '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') = :s_jijil 
		AND NVL(ISPEC_CODE, '@@@@@@@@@@@@@@@@@@@@') = :sispec_code ;
	IF get_count > 0 THEN 
		f_message_chk(49, '')
		RETURN -1
	END IF
ELSE
	SELECT COUNT(ITNBR)    INTO :get_count  
	  FROM ITEMAS  
	 WHERE ITNBR <> :s_itnbr
	   AND ITDSC = :s_itdsc 
	   AND NVL(ISPEC, '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') = :s_ispec
		AND NVL(JIJIL, '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') = :s_jijil 
		AND NVL(ISPEC_CODE, '@@@@@@@@@@@@@@@@@@@@') = :sispec_code ;
	IF get_count > 0 THEN 
		f_message_chk(49, '')
	END IF
END IF

RETURN 1
end function

public subroutine wf_retrieve (string arg_dcomp, string s_pumgu, string s_date, string s_use);
if s_date = '' or isnull(s_date)  then 
	dw_list.SetFilter("")    //�Ϸᱸ�� = ALL
	dw_list.Filter( )
else
	dw_list.SetFilter(" crt_date  >= '"+s_date+"' ")
	dw_list.Filter( )
end if

if dw_list.Retrieve(arg_dcomp, s_pumgu, s_use) <= 0 then
	dw_insert.setredraw(false)
	dw_insert.reset()
	dw_insert.insertrow(0)
	dw_insert.SETItem(1, "gbdate", f_today())
	dw_insert.SetTabOrder('itnbr',1)	
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	dw_insert.setredraw(true)
else
	dw_insert.setredraw(false)
	dw_insert.reset()
	dw_insert.insertrow(0)
	dw_insert.SetTabOrder('itnbr',1)	
	dw_list.SetFocus()
	dw_insert.setredraw(true)
end if	
	
ls_gub = 'Y'    //'Y'�̸� ��ϸ��
ib_any_typing = FALSE
p_copy.enabled = false
p_copy.PictureName = 'C:\erpman\image\����_d.gif'
p_del.enabled = false
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_sea.enabled = false
p_sea.PictureName = 'C:\erpman\image\��������_d.gif'
p_print1.enabled = false
p_print1.PictureName = 'C:\erpman\image\�������_d.gif'
p_desc.enabled = false
p_desc.PictureName = 'C:\erpman\image\�������_d.gif'
p_dept.enabled = false
p_dept.PictureName = 'C:\erpman\image\����ǰ��_d.gif'

end subroutine

on w_pdm_01270.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
this.cbx_auto=create cbx_auto
this.cb_desc=create cb_desc
this.cb_dept=create cb_dept
this.dw_dept=create dw_dept
this.rr_2=create rr_2
this.dw_list=create dw_list
this.p_desc=create p_desc
this.p_print1=create p_print1
this.p_dept=create p_dept
this.p_sea=create p_sea
this.p_copy=create p_copy
this.p_6=create p_6
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.gb_3
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.cbx_auto
this.Control[iCurrent+6]=this.cb_desc
this.Control[iCurrent+7]=this.cb_dept
this.Control[iCurrent+8]=this.dw_dept
this.Control[iCurrent+9]=this.rr_2
this.Control[iCurrent+10]=this.dw_list
this.Control[iCurrent+11]=this.p_desc
this.Control[iCurrent+12]=this.p_print1
this.Control[iCurrent+13]=this.p_dept
this.Control[iCurrent+14]=this.p_sea
this.Control[iCurrent+15]=this.p_copy
this.Control[iCurrent+16]=this.p_6
this.Control[iCurrent+17]=this.pb_1
this.Control[iCurrent+18]=this.pb_2
this.Control[iCurrent+19]=this.pb_3
this.Control[iCurrent+20]=this.pb_4
end on

on w_pdm_01270.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.cbx_auto)
destroy(this.cb_desc)
destroy(this.cb_dept)
destroy(this.dw_dept)
destroy(this.rr_2)
destroy(this.dw_list)
destroy(this.p_desc)
destroy(this.p_print1)
destroy(this.p_dept)
destroy(this.p_sea)
destroy(this.p_copy)
destroy(this.p_6)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_dept.SetTransObject(sqlca)

dw_insert.InsertRow(0)
dw_1.InsertRow(0)
dw_insert.SETItem(1, "gbdate", f_today())

dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

  SELECT "SYSCNFG"."DATANAME"  
    INTO :is_Auto
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'S' ) AND  
         ( "SYSCNFG"."SERIAL" = 6 ) AND  
         ( "SYSCNFG"."LINENO" = '10' )   ;

IF SQLCA.SQLCODE <> 0	THEN	is_Auto = 'Y'	

IF is_Auto = 'N'	THEN	cbx_auto.visible = false

  SELECT "SYSCNFG"."DATANAME"  
    INTO :is_Version  
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
         ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '3' )   ;

IF SQLCA.SQLCODE <> 0	THEN	is_Version = 'Y'	

IF is_Version = 'N'		THEN	p_sea.visible = false

f_mod_saupj(dw_1, 'dcomp')


end event

event key;// Page Up & Page Down & Home & End Key ��� ����
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_pdm_01270
integer x = 2350
integer y = 276
integer width = 2149
integer height = 2020
integer taborder = 40
string dataobject = "d_pdm_01270"
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemchanged;string s_itnbr, get_nm, s_name, s_date, snull, s_itt, s_itdsc, get_nm2, s_stdnbr, ls_gritu, ls_mdljijil, ls_data1, ls_data2
long   get_count, ireturn 

setnull(snull)

if this.accepttext() = -1 then return 

IF this.GetColumnName() ="itnbr" THEN
	s_itnbr = this.GetText()
	
	IF s_itnbr = "" OR IsNull(s_itnbr) THEN RETURN
	
	SELECT "ITEMAS"."ITNBR"
	  INTO :get_nm   		
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ITNBR" = :s_itnbr  ;
	IF SQLCA.SQLCODE = 0 THEN
		p_inq.TriggerEvent(Clicked!)
		RETURN 1
	END IF

ELSEIF this.GetColumnName() = 'ittyp' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'titnm1', snull)
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_itt)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[ǰ�񱸺�]')
		this.SetItem(1,'ittyp', snull)
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'titnm1', snull)
		return 1
	else	
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'titnm1', snull)
   end if
	
	if s_itt <= '4' then
		SetItem(1, 'lotgub', 'N')
	else
		SetItem(1, 'lotgub', 'N')
	end if
ELSEIF this.GetColumnName() = 'itcls' THEN
	s_name = this.gettext()
   s_itt  = this.getitemstring(1, 'ittyp')
   IF s_name = "" OR IsNull(s_name) THEN 	
		This.setitem(1, 'titnm1', snull)
		RETURN 
	END IF
	
  SELECT "ITNCT"."TITNM"  
    INTO :get_nm  
    FROM "ITNCT"  
   WHERE ( "ITNCT"."ITTYP" = :s_itt ) AND  
         ( "ITNCT"."ITCLS" = :s_name ) AND  
         ( "ITNCT"."LMSGU" <> 'L' )   ;

	IF SQLCA.SQLCODE <> 0 THEN
		this.TriggerEvent(rbuttondown!)
		if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
			This.setitem(1, 'itcls', snull)
			This.setitem(1, 'titnm1', snull)
			RETURN 1
      else
			this.SetItem(1, "ittyp", lstr_sitnct.s_ittyp)
			this.SetItem(1, "itcls", lstr_sitnct.s_sumgub)
			this.SetItem(1, "titnm1",lstr_sitnct.s_titnm)
			if ls_gub = 'Y' then This.setitem(1, 'itdsc', lstr_sitnct.s_titnm)
         Return 1			
      end if
   ELSE
		This.setitem(1, 'titnm1', get_nm)
		
		if ls_gub = 'Y' then This.setitem(1, 'itdsc',  get_nm)
   END IF
//���� �ڵ� ����
elseif this.GetColumnName() = 'gritu' then
   
	ls_gritu = this.GetText()
	
	IF ls_gritu = "" OR IsNull(ls_gritu) THEN RETURN
	
	Select RFGUB, RFNA1
	INTO :ls_data1, :ls_data2
   FROM REFFPF 
   WHERE RFCOD = '01'
	AND	RFGUB <> '00'
	AND   RFGUB = :ls_gritu;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("Ȯ��","�����ڵ尡 �������� �ʽ��ϴ�.",Exclamation!)
		this.SetItem(1,'gritu', '')
		this.SetItem(1,'vhtype', '')
		Return 1
	End If
	
	this.SetItem(1,"gritu",ls_data1)
	this.SetItem(1,"vhtype",ls_data2)
	
//�� �ڵ� ����
elseif this.GetColumnName() = 'mdl_jijil' then
   
	ls_mdljijil = this.GetText()
	
	IF ls_mdljijil = "" OR IsNull(ls_mdljijil) THEN RETURN
	
	Select RFGUB, RFNA1
	INTO :ls_data1, :ls_data2
   FROM REFFPF 
   WHERE RFCOD = '1F'
	AND	RFGUB <> '00'
	AND   RFGUB = :ls_mdljijil;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("Ȯ��","���ڵ尡 �������� �ʽ��ϴ�.",Exclamation!)
		this.SetItem(1,'mdl_jijil', '')
		this.SetItem(1,'model', '')
		Return 1
	End If
	
	this.SetItem(1,"mdl_jijil",ls_data1)
	this.SetItem(1,"model",ls_data2)

ELSEIF this.GetColumnName() = 'empno2' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN RETURN
	
	s_name = f_get_reffer('46', s_itt)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[���ߴ����]')
		this.SetItem(1,'empno2', snull)
		return 1
   end if	
ELSEIF this.GetColumnName() = 'gbwan' THEN
	s_date = Trim(this.Gettext())
	IF s_date = 'Y' THEN
		this.SetItem(1,"gbdate", f_today())
		this.Setcolumn("gbdate")
		this.SetFocus()
   ELSE
		this.SetItem(1,"gbdate", sNull)
	END IF
ELSEIF this.GetColumnName() = 'useyn' THEN
	s_date = Trim(this.Gettext())
	IF s_date <> '0' and ls_gub = 'N' THEN
      s_itnbr = this.GetItemString(1, "itnbr")
  	   SELECT COUNT(*)  
		  INTO :get_count
		  FROM "ITEMAS"  
		 WHERE "ITEMAS"."STDNBR" = :s_itnbr   ;
 
      if get_count > 0 then 
			messagebox("Ȯ ��", "�����ǥ ǰ������ ��ϵ� �ڷ�� �������/���� ��ų �� �����ϴ�.")
			return 2
		end if	
	END IF
ELSEIF this.GetColumnName() = 'gbdate' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[���߿Ϸ�����]')
		this.SetItem(1,"gbdate",snull)
		this.Setcolumn("gbdate")
		this.SetFocus()
		Return 1
	END IF
ELSEIF this.GetColumnName() ="itemas_stdnbr" THEN
	s_stdnbr = this.GetText()
	
	IF s_stdnbr = "" OR IsNull(s_stdnbr) THEN
		this.SetItem(1,"itemas_itdsc",snull)
		this.SetItem(1,"itemas_ispec",snull)
		RETURN
	END IF
	
	ireturn = f_get_name2('��üǰ��', 'Y', s_stdnbr, get_nm, get_nm2)
	IF ireturn = 0 THEN
      s_itnbr = this.GetItemString(1, "itnbr")
		
		If s_itnbr = s_stdnbr then
    		f_message_chk(44,'[�����ǥ ǰ��]')
			this.SetItem(1,"itemas_stdnbr",snull)
			this.SetItem(1,"itemas_itdsc",snull)
			this.SetItem(1,"itemas_ispec",snull)
			return 1
      Else		   
		   SELECT COUNT("PSTRUC"."PINBR")  
			  INTO :get_count  
			  FROM "PSTRUC"  
			 WHERE "PSTRUC"."PINBR" = :s_stdnbr   ;
         
			if get_count > 0 then
   			this.SetItem(1,"itemas_itdsc",get_nm)
				this.SetItem(1,"itemas_ispec",get_nm2)
				RETURN 1
			else
				f_message_chk(55,'[�����ǥ ǰ��]')
				this.SetItem(1,"itemas_stdnbr",snull)
				this.SetItem(1,"itemas_itdsc",snull)
				this.SetItem(1,"itemas_ispec",snull)
				return 1
         end if
      End if
   ELSE
		this.SetItem(1,"itemas_stdnbr",snull)
		this.SetItem(1,"itemas_itdsc",snull)
		this.SetItem(1,"itemas_ispec",snull)
		return 1
   END IF
END IF	

end event

event itemerror;return 1
end event

event dw_insert::rbuttondown;string snull, sname

setnull(snull)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

if this.GetColumnName() = 'itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup3)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"itnbr",gs_code)
	p_inq.TriggerEvent(Clicked!)
	RETURN 1

elseif this.GetColumnName() = 'itcls' then
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"titnm1", lstr_sitnct.s_titnm)
	if ls_gub = 'Y' then 	this.SetItem(1, "itdsc", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
	this.SetFocus()
	RETURN 1
elseif this.GetColumnName() = 'itemas_stdnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup3)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"itemas_stdnbr",gs_code)
	this.TriggerEvent(itemchanged!)
	RETURN 1
//���� �ڵ� ����
elseif this.GetColumnName() = 'gritu' then
   gs_code = this.GetText()

	open(w_vehtype_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1,"gritu",gs_code)
	this.SetItem(1,"vhtype",gs_codename)
	
	RETURN 1
//�� �ڵ� ����
elseif this.GetColumnName() = 'mdl_jijil' then
   gs_code = this.GetText()

	open(w_model_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1,"mdl_jijil",gs_code)
	this.SetItem(1,"model",gs_codename)
	
	RETURN 1

end if	

end event

event dw_insert::itemfocuschanged;//Long wnd
//
//wnd =Handle(this)
//
//IF dwo.name ="itgu" or dwo.name = "vndmst_cvnas2" then
//	f_toggle_kor(wnd)
//ELSE
//	f_toggle_eng(wnd)
//END IF
end event

event dw_insert::ue_key;string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
		IF This.GetColumnName() = "itnbr" Then
			open(w_itemas_popup4)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(1,"itnbr",gs_code)
			p_inq.TriggerEvent(Clicked!)
			RETURN 1
		ELSEIF This.GetColumnName() = "itcls" OR This.GetColumnName() = "ittyp" Then
			gs_code = this.getitemstring(1, 'ittyp')
			
			open(w_ittyp_popup2)
			
			lstr_sitnct = Message.PowerObjectParm	
			
			if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
				return
			end if
		
			this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
			this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
			this.SetItem(1,"titnm1",lstr_sitnct.s_titnm)
			if ls_gub = 'Y' then  this.SetItem(1, "itdsc", lstr_sitnct.s_titnm)
			this.SetColumn('itcls')
			this.SetFocus()
		ELSEIF This.GetColumnName() = "itemas_stdnbr" Then
			open(w_itemas_popup4)
			if isnull(gs_code) or gs_code = "" then return
			
			this.SetItem(1,"itemas_stdnbr",gs_code)
      	this.TriggerEvent(itemchanged!)
			RETURN 1
      End If
END IF

end event

event dw_insert::updatestart;/* Update() function ȣ��� user ���� */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF  New! = this.GetItemStatus(k, 0, Primary!) OR NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type p_delrow from w_inherite`p_delrow within w_pdm_01270
boolean visible = false
integer x = 965
integer y = 3128
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01270
boolean visible = false
integer x = 791
integer y = 3128
end type

type p_search from w_inherite`p_search within w_pdm_01270
boolean visible = false
integer x = 256
integer y = 3136
end type

type p_ins from w_inherite`p_ins within w_pdm_01270
boolean visible = false
integer x = 617
integer y = 3132
end type

type p_exit from w_inherite`p_exit within w_pdm_01270
end type

type p_can from w_inherite`p_can within w_pdm_01270
end type

event p_can::clicked;call super::clicked;wf_init()

ib_any_typing = FALSE
p_copy.enabled = false
p_copy.PictureName = 'C:\erpman\image\����_d.gif'
p_del.enabled = false
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_sea.enabled = false
p_sea.PictureName = 'C:\erpman\image\��������_d.gif'
p_print1.enabled = false
p_print1.PictureName = 'C:\erpman\image\�������_d.gif'
p_desc.enabled = false
p_desc.PictureName = 'C:\erpman\image\�������_d.gif'
p_dept.enabled = false
p_dept.PictureName = 'C:\erpman\image\����ǰ��_d.gif'

dw_1.TriggerEvent(itemchanged!)

dw_insert.SETItem(1, "gbdate", f_today())
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

end event

type p_print from w_inherite`p_print within w_pdm_01270
boolean visible = false
integer x = 434
integer y = 3140
end type

type p_inq from w_inherite`p_inq within w_pdm_01270
integer x = 3749
end type

event p_inq::clicked;string s_code

if dw_insert.AcceptText() = -1 then return 

if dw_insert.RowCount() <= 0 then
	dw_insert.SetFocus()
	return 
end if	

s_code = dw_insert.GetItemString(1,"itnbr")

if isnull(s_code) or s_code = "" then
	f_message_chk(30,'[ǰ��]')
	dw_insert.SetFocus()
	return
end if	

if dw_insert.Retrieve(s_code) <= 0 then
	f_message_chk(50,'[ǰ�񸶽�Ÿ]')
   wf_init()
   return
  
else
   dw_dept.Retrieve(s_code)
	dw_insert.SetTaborder('itnbr',0)	
   dw_insert.setcolumn('ittyp')
   dw_insert.setfocus()
   ib_any_typing = FALSE
	p_copy.enabled = true
	p_copy.PictureName = 'C:\erpman\image\����_up.gif'
	p_del.enabled = true
	p_del.PictureName = 'C:\erpman\image\����_up.gif'
   p_sea.enabled = true
	p_sea.PictureName = 'C:\erpman\image\��������_up.gif'
	p_print1.enabled = true
	p_print1.PictureName = 'C:\erpman\image\�������_up.gif'
	p_desc.enabled = true
	p_desc.PictureName = 'C:\erpman\image\�������_up.gif'
	p_dept.enabled = true
	p_dept.PictureName = 'C:\erpman\image\����ǰ��_up.gif'
	ls_gub = 'N'    
end if	

end event

type p_del from w_inherite`p_del within w_pdm_01270
end type

event p_del::clicked;call super::clicked;string s_itnbr
long   get_count, lrow

if dw_insert.AcceptText() = -1 then return 

s_itnbr = dw_insert.GetItemString(1,'itnbr')

if s_itnbr = '' or isnull(s_itnbr) then return 

//�����ϱ����� �������� üũ�ؾ� 
IF wf_itnbr_check(s_itnbr) = -1 THEN RETURN

SELECT COUNT("ITMDA"."DTNBR")  
  INTO :get_count  
  FROM "ITMDA"  
 WHERE "ITMDA"."DTNBR" = :s_itnbr   ;

IF get_count < 1 Then 
   IF f_msg_delete() = -1 THEN Return
ELSE
   IF MessageBox("�� ��","�� ǰ���� �����Ͻø� �ٸ� ǰ���� ��üǰ������ ��ϵ� "+ "~n" +&
								 "�ڷᵵ �����˴ϴ�." +"~n~n" +&
                      	 "���� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
END IF

////////////////////////////////////////////////////////////////////////////
dw_insert.SetRedraw(FALSE)

dw_insert.DeleteROw(0)
if dw_insert.Update() = 1 then
else
	rollback ;
	f_rollback()
	return
end if

w_mdi_frame.sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	

COMMIT ;

dw_insert.SetRedraw(TRUE)

lrow = dw_list.Find("itnbr = '" + s_itnbr + "'", 1, dw_list.RowCount())

if lrow > 0 then
   dw_list.DeleteROw(lrow)
end if

ib_any_typing = FALSE

wf_init()

ib_any_typing = FALSE
p_copy.enabled = false
p_copy.PictureName = 'C:\erpman\image\����_d.gif'
p_del.enabled = false
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_sea.enabled = false
p_sea.PictureName = 'C:\erpman\image\��������_d.gif'
p_print1.enabled = false
p_print1.PictureName = 'C:\erpman\image\�������_d.gif'
p_desc.enabled = false
p_desc.PictureName = 'C:\erpman\image\�������_d.gif'
p_dept.enabled = false
p_dept.PictureName = 'C:\erpman\image\����ǰ��_d.gif'

end event

type p_mod from w_inherite`p_mod within w_pdm_01270
end type

event p_mod::clicked;call super::clicked;string s_itnbr, s_ittyp
long lreturnrow

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if wf_required_chk() = -1 then return
/////////////////////////////////////////////////////////////////////////////

//// ǰ��/�԰ݸ� üũ
//IF wf_name_chk() = -1	THEN
//	dw_insert.setcolumn('itdsc')
//	dw_insert.setfocus()
//	RETURN 
//END IF

IF ls_gub = 'Y'  THEN           //��� mod�϶�
	IF is_auto = 'Y' THEN        //�ý��� file���� �ڵ�ä���϶�
		IF	cbx_auto.checked THEN  
	
			// ǰ��з� ��������
			if wf_add_seqno_yakum() < 0 then 
				rollback ;
				return 
			end if				
			
			// ���� version
			// ǰ���ȣ �ڵ�ä��
			IF  wf_rename() = -1	THEN	RETURN 
		
			// ǰ��з� ��������
			if wf_add_seqno() < 0 then 
				rollback ;
				return 
			end if	
		ELSE	
			IF  wf_itnbr() = -1	THEN	RETURN 
		END IF
	ELSE	
		IF  wf_itnbr() = -1	THEN	RETURN 
	END IF
END IF

IF f_msg_update() = -1 then
	rollback ;
	return
END IF

s_itnbr = dw_insert.getitemstring(1, 'itnbr')
s_ittyp = dw_insert.getitemstring(1, 'ittyp')

if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"			
	ib_any_typing = false
	commit ;
else
	rollback ;
	return 
end if	

p_inq.triggerevent(clicked!)	

end event

type cb_exit from w_inherite`cb_exit within w_pdm_01270
integer x = 3278
integer y = 2892
integer width = 288
integer taborder = 150
integer textsize = -9
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01270
integer x = 2373
integer y = 2892
integer width = 288
integer taborder = 60
integer textsize = -9
end type

event cb_mod::clicked;call super::clicked;//string s_itnbr, s_ittyp
//long lreturnrow
//
//if dw_insert.AcceptText() = -1 then return 
//if dw_1.AcceptText() = -1 then return 
//
//if wf_required_chk() = -1 then return
///////////////////////////////////////////////////////////////////////////////
//
//// ǰ��/�԰ݸ� üũ
//IF wf_name_chk() = -1	THEN
//	dw_insert.setcolumn('itdsc')
//	dw_insert.setfocus()
//	RETURN 
//END IF
//
//IF ls_gub = 'Y'  THEN           //��� mod�϶�
//	IF is_auto = 'Y' THEN        //�ý��� file���� �ڵ�ä���϶�
//		IF	cbx_auto.checked THEN  
//	
//			// ǰ��з� ��������
//			if wf_add_seqno_yakum() < 0 then 
//				rollback ;
//				return 
//			end if				
//			
//			// ���� version
//			// ǰ���ȣ �ڵ�ä��
//			IF  wf_rename() = -1	THEN	RETURN 
//		
//			// ǰ��з� ��������
//			if wf_add_seqno() < 0 then 
//				rollback ;
//				return 
//			end if	
//		ELSE	
//			IF  wf_itnbr() = -1	THEN	RETURN 
//		END IF
//	ELSE	
//		IF  wf_itnbr() = -1	THEN	RETURN 
//	END IF
//END IF
//
//IF f_msg_update() = -1 then
//	rollback ;
//	return
//END IF
//
//s_itnbr = dw_insert.getitemstring(1, 'itnbr')
//s_ittyp = dw_insert.getitemstring(1, 'ittyp')
//
//if dw_insert.update() = 1 then
//	sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"			
//	ib_any_typing = false
//	commit ;
//else
//	rollback ;
//	return 
//end if	
//
//cb_inq.triggerevent(clicked!)	
////dw_1.setitem(1, 'ittyp', s_ittyp)
////
////String  s_use, s_date
////
////s_date = trim(dw_1.getitemstring(1, 'sildate'))
////s_use  = dw_1.getitemstring(1, 'useyn')
////
////if s_date = '' or isnull(s_date)  then 
////	dw_list.SetFilter("")    //�Ϸᱸ�� = ALL
////	dw_list.Filter( )
////else
////	dw_list.SetFilter(" crt_date  >= '"+s_date+"' ")
////	dw_list.Filter( )
////end if
////
////dw_list.Retrieve(s_ittyp, s_use) 
////
////lReturnRow = dw_list.Find("itnbr = '"+s_itnbr+"' ", 1, dw_list.RowCount())
////
////IF lReturnRow <> 0 THEN 
////	dw_list.selectrow(lReturnRow, true)
////	dw_list.scrolltorow(lReturnRow)
////END IF
////
////dw_insert.retrieve(s_itnbr) 
////dw_insert.SetTaborder('itnbr',0)	
////
////ls_gub = 'N'
////cb_ins.enabled = true
////cb_del.enabled = true
////cb_search.enabled = true
////cb_print.enabled = true
////cb_desc.enabled = true
////cb_dept.enabled = true
//
//
end event

type cb_ins from w_inherite`cb_ins within w_pdm_01270
integer x = 402
integer y = 2892
integer width = 288
integer taborder = 100
integer textsize = -9
boolean enabled = false
string text = "����(&B)"
end type

event clicked;//string snull
//
//if dw_insert.AcceptText() = -1 then return 
//
//if wf_required_chk() = -1 then return
//
//IF MessageBox("Ȯ ��", "���� ǰ���� ���� �Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	RETURN
//setnull(snull)
//
//dw_insert.setitemstatus(1, 0, primary!, new!)
//
//dw_insert.SetTaborder('itnbr',1)
//
//dw_insert.setfocus()
//ls_gub = 'Y'    //'Y'�̸� ��ϸ��
//
////dw_insert.SETItem(1, "itnbr", snull)
//dw_insert.SETItem(1, "gbdate", F_today())
//dw_insert.SETItem(1, "upd_user", snull)
//dw_insert.SetColumn('itnbr')
//dw_insert.SetFocus()
//
//dw_list.SelectRow(0, FALSE)
//cb_ins.enabled = false
//cb_del.enabled = false
//cb_search.enabled = false
//cb_print.enabled = false
//cb_desc.enabled = false
//cb_dept.enabled = false
end event

type cb_del from w_inherite`cb_del within w_pdm_01270
integer x = 2674
integer y = 2892
integer width = 288
integer taborder = 70
integer textsize = -9
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;//string s_itnbr
//long   get_count, lrow
//
//if dw_insert.AcceptText() = -1 then return 
//
//s_itnbr = dw_insert.GetItemString(1,'itnbr')
//
//if s_itnbr = '' or isnull(s_itnbr) then return 
//
////�����ϱ����� �������� üũ�ؾ� 
//IF wf_itnbr_check(s_itnbr) = -1 THEN RETURN
//
//SELECT COUNT("ITMDA"."DTNBR")  
//  INTO :get_count  
//  FROM "ITMDA"  
// WHERE "ITMDA"."DTNBR" = :s_itnbr   ;
//
//IF get_count < 1 Then 
//   IF f_msg_delete() = -1 THEN Return
//ELSE
//   IF MessageBox("�� ��","�� ǰ���� �����Ͻø� �ٸ� ǰ���� ��üǰ������ ��ϵ� "+ "~n" +&
//								 "�ڷᵵ �����˴ϴ�." +"~n~n" +&
//                      	 "���� �Ͻðڽ��ϱ�?",Question!, YesNo!, 2) = 2 THEN RETURN
//END IF
//
//////////////////////////////////////////////////////////////////////////////
//dw_insert.SetRedraw(FALSE)
//
//dw_insert.DeleteROw(0)
//if dw_insert.Update() = 1 then
//else
//	rollback ;
//	f_rollback()
//	return
//end if
//
//sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"	
//
//COMMIT ;
//
//dw_insert.SetRedraw(TRUE)
//
//lrow = dw_list.Find("itnbr = '" + s_itnbr + "'", 1, dw_list.RowCount())
//
//if lrow > 0 then
//   dw_list.DeleteROw(lrow)
//end if
//
//ib_any_typing = FALSE
//
//wf_init()
//
//ib_any_typing = FALSE
//cb_ins.enabled = false
//cb_del.enabled = false
//cb_search.enabled = false
//cb_print.enabled = false
//cb_desc.enabled = false
//cb_dept.enabled = false
//
end event

type cb_inq from w_inherite`cb_inq within w_pdm_01270
integer x = 101
integer y = 2888
integer width = 288
integer taborder = 80
integer textsize = -9
end type

event cb_inq::clicked;call super::clicked;//string s_code
//
//if dw_insert.AcceptText() = -1 then return 
//
//if dw_insert.RowCount() <= 0 then
//	dw_insert.SetFocus()
//	return 
//end if	
//
//s_code = dw_insert.GetItemString(1,"itnbr")
//
//if isnull(s_code) or s_code = "" then
//	f_message_chk(30,'[ǰ��]')
//	dw_insert.SetFocus()
//	return
//end if	
//
//if dw_insert.Retrieve(s_code) <= 0 then
//	f_message_chk(50,'[ǰ�񸶽�Ÿ]')
//   wf_init()
//   return
//  
//else
//   dw_dept.Retrieve(s_code)
//	dw_insert.SetTaborder('itnbr',0)	
//   dw_insert.setcolumn('ittyp')
//   dw_insert.setfocus()
//   ib_any_typing = FALSE
//	cb_ins.enabled = true
//	cb_del.enabled = true
//   cb_search.enabled = true
//	cb_print.enabled = true
//	cb_desc.enabled = true
//	cb_dept.enabled = true
//	ls_gub = 'N'    
//end if	
//
end event

type cb_print from w_inherite`cb_print within w_pdm_01270
integer x = 1499
integer y = 2892
integer width = 384
integer taborder = 120
integer textsize = -9
boolean enabled = false
string text = "�������(&Q)"
end type

event clicked;//string sItnbr
//if dw_insert.accepttext() = -1 then return 
//
//sItnbr = dw_insert.getitemstring(1, 'itnbr')
//
//OpenWithParm(w_pdm_01280, sItnbr)
//
//
end event

type st_1 from w_inherite`st_1 within w_pdm_01270
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_pdm_01270
integer x = 2976
integer y = 2892
integer width = 288
integer taborder = 140
integer textsize = -9
end type

event cb_can::clicked;call super::clicked;
//wf_init()
//
//ib_any_typing = FALSE
//cb_ins.enabled = false
//cb_del.enabled = false
//cb_search.enabled = false
//cb_print.enabled = false
//cb_desc.enabled = false
//cb_dept.enabled = false
//
//dw_1.TriggerEvent(itemchanged!)
//
//dw_insert.SETItem(1, "gbdate", f_today())
//dw_insert.SetColumn('itnbr')
//dw_insert.SetFocus()
//


end event

type cb_search from w_inherite`cb_search within w_pdm_01270
integer x = 704
integer y = 2892
integer width = 384
integer taborder = 110
integer textsize = -9
boolean enabled = false
string text = "��������(&V)"
end type

event clicked;//string s_itnbr, s_itdsc, s_ispec, s_jijil, s_jejos, s_ittyp, s_itcls,  &
//       s_empno, s_lotgub, s_gbwan, s_gbdate, s_gbgub, s_useyn, s_version, s_itn, get_itnbr, &
//		 s_message, s_auto
//char   c_version
//long   lreturnrow, l_seqno
//
//if dw_insert.AcceptText() = -1 then return 
//
//if wf_required_chk() = -1 then return
//
//s_itnbr  = dw_insert.getitemstring( 1, 'itnbr')
//
////////////////////////////////////////////////////////////////////////////////
//dec	dLength
//dLength = Len(s_itnbr) - 1
//
//s_itn   =  left(s_itnbr, dLength)
//
////////////////////////////////////////////////////////////////////////////////
//
//SELECT MAX(ITNBR)  
//  INTO :get_itnbr  
//  FROM ITEMAS  
// WHERE SUBSTR(ITNBR, 1, :dLength) = :s_itn   ;
//
//if isnull(get_itnbr) then
//	f_message_chk(41, "")
//	return 
//end if
//
//c_version = right(get_itnbr, 1)
//	
//s_message = '������ ������  ' + c_version + ' �Դϴ�.' 
//
//IF MessageBox("Ȯ ��",  + s_message + "~n~n" + &
//              "���� ǰ���� �������� �Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	RETURN
//
//c_version = wf_version_up(c_version)
//
//if c_version = '' then return 
//
//s_version = string(c_version)
//
//s_itnbr = s_itn + s_version
//
//l_Seqno  = dw_insert.getitemnumber( 1, 'seqno') 
//s_itdsc  = dw_insert.getitemstring( 1, 'itdsc')
//s_ispec  = dw_insert.getitemstring( 1, 'ispec')
//s_jijil  = dw_insert.getitemstring( 1, 'jijil')
//s_jejos  = dw_insert.getitemstring( 1, 'jejos')
//s_ittyp  = dw_insert.getitemstring( 1, 'ittyp')
//s_itcls  = dw_insert.getitemstring( 1, 'itcls')
//s_empno  = dw_insert.getitemstring( 1, 'empno2')
//s_lotgub = dw_insert.getitemstring( 1, 'lotgub')
//s_gbwan  = dw_insert.getitemstring( 1, 'gbwan')
//s_gbdate = dw_insert.getitemstring( 1, 'gbdate')
//s_gbgub  = dw_insert.getitemstring( 1, 'gbgub')
//s_useyn  = dw_insert.getitemstring( 1, 'useyn')
//s_auto  = dw_insert.getitemstring( 1, 'itemas_auto')
//
//INSERT INTO "ITEMAS"  
//		( "SABU",    "ITNBR",   "ITDSC",   "ISPEC",    "JIJIL",  "JEJOS",   "ITTYP",    "GRITU",   
//		  "ITCLS",   "SEQNO",   "ITNBR_VERSION",   	 "ENGNO",   "EMPNO2",   "LOTGUB",   
//		  "GBWAN",   "GBDATE",  "GBGUB",    "USEYN",  "STDNBR",  "EMPNO",   
//		  "PUMSR",   "CNVFAT",  "UNMSR",    "WAGHT",  "FILSK",   "ACCOD",    "ITGU",   
//		  "CHGBN",   "QCEMP",   "LOCFR",    "LOCTO",  "HSNO",    "ABCGB",    "SILSU",   
//		  "SILDATE", "WONPRC",  "FORPRC",   "FORPUN", "WONSRC",  "FORSRC",   "FORSUN",   
//		  "GNHNO",   "MLICD",    "LDTIM",   
//		  "LDTIM2",  "MINSAF",  "MIDSAF",   "MAXSAF", "SHRAT",   "MINQT",    "MULQT", "MAXQT",
//		  "AUTO",    "CRT_USER")  
//VALUES ( '1',      :s_itnbr, :s_itdsc,  :s_ispec,  :s_jijil,  :s_jejos,  :s_ittyp,   null,   
//		   :s_itcls, :l_seqno,  :s_version,           null,  :s_empno,   :s_lotgub,   
//		   :s_gbwan, :s_gbdate, :s_gbgub,  :s_useyn,  null,      null,   
//			null,     1,         null,      null,      'Y',       null, 		'1',   
//			'Y',      null,      null,      null,      null,      null,       null,   
//			null,     null,      null,      'WON',     null,      null,      'WON',     
//			null,      '1',      null,   
//			null,     null,      null,      null,      null,      null,       null, null,
//			:s_auto,  :gs_userid )  ;
//			
//
//
//if sqlca.sqlcode <> 0 then 
//	rollback ;
//	F_ROLLBACK()
//else	
//	sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"			
//	commit ;
//end if
//
//
////
//dw_1.TriggerEvent(itemchanged!)   
//
//lReturnRow = dw_list.Find("itnbr = '"+s_itnbr+"' ", 1, dw_list.RowCount())
//dw_list.selectrow(lReturnRow, true)
//dw_list.scrolltorow(lReturnRow)
//dw_insert.retrieve(s_itnbr) 
//dw_dept.Retrieve(s_itnbr)
//dw_insert.SetTaborder('itnbr',0)	
//dw_insert.setcolumn('ittyp')
//dw_insert.setfocus()
//
//ls_gub = 'N'
//cb_ins.enabled = true
//cb_del.enabled = true
//cb_search.enabled = true
//cb_print.enabled = true
//cb_desc.enabled = true
//cb_dept.enabled = true
//
////string	sCheckBox
////sCheckBox = dw_insert.GetItemString(1, "itemas_auto")
////
////IF sCheckBox = 'Y'	THEN
////	cb_ins.enabled = TRUE
////ELSE
////	cb_ins.enabled = FALSE
////END IF
//
end event



type sle_msg from w_inherite`sle_msg within w_pdm_01270
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_pdm_01270
integer y = 2980
integer height = 140
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01270
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01270
end type

type rr_1 from roundrectangle within w_pdm_01270
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2336
integer y = 268
integer width = 2171
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

type gb_3 from groupbox within w_pdm_01270
boolean visible = false
integer x = 2327
integer y = 2848
integer width = 1285
integer height = 188
integer textsize = -3
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 12632256
end type

type gb_2 from groupbox within w_pdm_01270
boolean visible = false
integer x = 55
integer y = 2848
integer width = 2258
integer height = 188
integer textsize = -3
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 12632256
end type

type dw_1 from datawindow within w_pdm_01270
event ue_enter pbm_dwnprocessenter
integer x = 101
integer y = 268
integer width = 2199
integer height = 464
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01272"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string s_pumgu, s_name, snull, s_date, s_use, ls_Dcomp

setnull(snull)

if 	this.accepttext() = -1 then return 

//---------------------------------------------------------------------
ls_Dcomp   	= this.GetItemString(1,'dcomp')  
s_pumgu   	= this.GetItemString(1,'ittyp')  
s_Date   	= this.GetItemString(1,'sildate')  
s_use   		= this.GetItemString(1,'useyn')  

Choose Case this.GetColumnName()
	Case	"dcomp" 
		ls_Dcomp   = this.Gettext()   // ����� ���� Ȯ��.
	     wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
	Case	"ittyp" 
		s_pumgu = this.Gettext()
		IF s_pumgu = "" OR IsNull(s_pumgu) THEN 
			RETURN
		END IF
		
		s_name = f_get_reffer('05', s_pumgu)
		if isnull(s_name) or s_name="" then
			f_message_chk(33,'[ǰ�񱸺�]')
			this.SetItem(1,'ittyp', snull)
			return 1
		end if

	     wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
	Case	"sildate" 
		s_date     = trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN 
		   	wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
			Return 
		END IF
	
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[��������]')
			this.SetItem(1,"sildate",snull)
	   		wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
			Return 1
		END IF

		if isnull(s_pumgu) or s_pumgu="" then
			f_message_chk(40,'[ǰ�񱸺�]')
			this.SetColumn('ittyp')
			this.SetFocus()
			return 1
		end if
   
   		wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
	Case	"useyn" 
		if isnull(s_pumgu) or s_pumgu="" then
			f_message_chk(40,'[ǰ�񱸺�]')
			this.SetColumn('ittyp')
			this.SetFocus()
			return 1
		end if
      	s_use = Trim(this.Gettext())
   		wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
End Choose

//---------------------------------------------------------------------

end event

event itemerror;return 1
end event

event losefocus;if this.accepttext() = -1 then return 
end event

type cbx_auto from checkbox within w_pdm_01270
integer x = 4069
integer y = 304
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "�ڵ�ä��"
boolean checked = true
end type

type cb_desc from commandbutton within w_pdm_01270
boolean visible = false
integer x = 1897
integer y = 2892
integer width = 384
integer height = 108
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "����ü"
boolean enabled = false
string text = "�������(&T)"
end type

event clicked;//string sItnbr
//if dw_insert.accepttext() = -1 then return 
//
//sItnbr = dw_insert.getitemstring(1, 'itnbr')
//
//OpenWithParm(w_pdm_01285, sItnbr)
//
//
end event

type cb_dept from commandbutton within w_pdm_01270
boolean visible = false
integer x = 1102
integer y = 2892
integer width = 384
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
string text = "����ǰ��"
end type

event clicked;//string sItnbr
//if dw_insert.accepttext() = -1 then return 
//
//sItnbr = dw_insert.getitemstring(1, 'itnbr')
//
//OpenWithParm(w_pdm_01287, sItnbr)
//
//dw_dept.retrieve(sitnbr)
end event

type dw_dept from datawindow within w_pdm_01270
boolean visible = false
integer x = 128
integer y = 1884
integer width = 1751
integer height = 304
integer taborder = 50
string dataobject = "d_pdm_01273"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_2 from roundrectangle within w_pdm_01270
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 114
integer y = 748
integer width = 2171
integer height = 1556
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from u_d_popup_sort within w_pdm_01270
event ue_key pbm_dwnkey
integer x = 119
integer y = 756
integer width = 2153
integer height = 1540
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdm_01271"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;SetPointer(HourGlass!)

this.SetRedraw(FALSE)

If Row <= 0 then
//	this.SelectRow(0,False)
	b_flag =True
ELSE

	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
	
	b_flag = False

   if dw_insert.Retrieve(dw_list.GetItemString(Row,"itnbr")) <= 0 then
		dw_dept.reset()
   	ls_gub = 'Y'    //'Y'�̸� ��ϸ��
		ib_any_typing = FALSE
		p_copy.enabled = false
		p_copy.PictureName = 'C:\erpman\image\����_d.gif'
		p_del.enabled = false
		p_del.PictureName = 'C:\erpman\image\����_d.gif'
		p_sea.enabled = false
		p_sea.PictureName = 'C:\erpman\image\��������_d.gif'
		p_print1.enabled = false
		p_print1.PictureName = 'C:\erpman\image\�������_d.gif'
		p_desc.enabled = false
		p_desc.PictureName = 'C:\erpman\image\�������_d.gif'
		p_dept.enabled = false
		p_dept.PictureName = 'C:\erpman\image\����ǰ��_d.gif'
	else
		dw_dept.Retrieve(dw_list.GetItemString(Row,"itnbr"))
		dw_insert.SetTaborder('itnbr',0)
		ib_any_typing = FALSE
		p_copy.enabled = true
		p_copy.PictureName = 'C:\erpman\image\����_up.gif'
		p_del.enabled = true
		p_del.PictureName = 'C:\erpman\image\����_up.gif'
		p_sea.enabled = true
		p_sea.PictureName = 'C:\erpman\image\��������_up.gif'
		p_print1.enabled = true
		p_print1.PictureName = 'C:\erpman\image\�������_up.gif'
		p_desc.enabled = true
		p_desc.PictureName = 'C:\erpman\image\�������_up.gif'
		p_dept.enabled = true
		p_dept.PictureName = 'C:\erpman\image\����ǰ��_up.gif'
		ls_gub = 'N'    //'N'�̸� �������
	end if	
END IF

CALL SUPER ::CLICKED 

long    k
boolean result

If Row <= 0 then
	FOR k=1 TO this.rowcount()
		result = this.IsSelected(k)
		IF result THEN
			dw_list.scrolltorow(k)
			dw_list.setrow(k)
			EXIT
		END IF
	NEXT
END IF

this.SetRedraw(true)

end event

event rowfocuschanged;STRING s_code 

if currentrow < 1 then return 
if this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

s_code = dw_list.GetItemString(currentrow,"itnbr")

dw_insert.Retrieve(s_code)
ls_gub = 'N'    //'N'�̸� �������

dw_dept.Retrieve(s_code)
this.setredraw(true)



end event

type p_desc from picture within w_pdm_01270
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 3575
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\�������_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_desc.PictureName = 'C:\erpman\image\�������_dn.gif'
end event

event ue_lbuttonup;p_desc.PictureName = 'C:\erpman\image\�������_up.gif'
end event

event p_desc::clicked;call super::clicked;string sItnbr
if dw_insert.accepttext() = -1 then return 

sItnbr = dw_insert.getitemstring(1, 'itnbr')

OpenWithParm(w_pdm_01285, sItnbr)


end event

type p_print1 from picture within w_pdm_01270
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 3401
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\�������_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_print1.PictureName = 'C:\erpman\image\�������_dn.gif'
end event

event ue_lbuttonup;p_print1.PictureName = 'C:\erpman\image\�������_up.gif'
end event

event clicked;string sItnbr
if dw_insert.accepttext() = -1 then return 

sItnbr = dw_insert.getitemstring(1, 'itnbr')

OpenWithParm(w_pdm_01280, sItnbr)


end event

type p_dept from picture within w_pdm_01270
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 2395
integer y = 44
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
boolean enabled = false
string picturename = "C:\erpman\image\����ǰ��_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_dept.PictureName = 'C:\erpman\image\����ǰ��_dn.gif'
end event

event ue_lbuttonup;p_dept.PictureName = 'C:\erpman\image\����ǰ��_up.gif'
end event

event p_dept::clicked;call super::clicked;string sItnbr
if dw_insert.accepttext() = -1 then return 

sItnbr = dw_insert.getitemstring(1, 'itnbr')

OpenWithParm(w_pdm_01287, sItnbr)

dw_dept.retrieve(sitnbr)
end event

type p_sea from picture within w_pdm_01270
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 3227
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\��������_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_sea.PictureName = 'C:\erpman\image\��������_dn.gif'
end event

event ue_lbuttonup;p_sea.PictureName = 'C:\erpman\image\��������_up.gif'
end event

event clicked;string s_itnbr, s_itdsc, s_ispec, s_jijil, s_jejos, s_ittyp, s_itcls,  &
       s_empno, s_lotgub, s_gbwan, s_gbdate, s_gbgub, s_useyn, s_version, s_itn, get_itnbr, &
		 s_message, s_auto
char   c_version
long   lreturnrow, l_seqno

if dw_insert.AcceptText() = -1 then return 

if wf_required_chk() = -1 then return

s_itnbr  = dw_insert.getitemstring( 1, 'itnbr')

//////////////////////////////////////////////////////////////////////////////
dec	dLength
dLength = Len(s_itnbr) - 1

s_itn   =  left(s_itnbr, dLength)

//////////////////////////////////////////////////////////////////////////////

SELECT MAX(ITNBR)  
  INTO :get_itnbr  
  FROM ITEMAS  
 WHERE SUBSTR(ITNBR, 1, :dLength) = :s_itn   ;

if isnull(get_itnbr) then
	f_message_chk(41, "")
	return 
end if

c_version = right(get_itnbr, 1)
	
s_message = '������ ������  ' + c_version + ' �Դϴ�.' 

IF MessageBox("Ȯ ��",  + s_message + "~n~n" + &
              "���� ǰ���� �������� �Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	RETURN

c_version = wf_version_up(c_version)

if c_version = '' then return 

s_version = string(c_version)

s_itnbr = s_itn + s_version

l_Seqno  = dw_insert.getitemnumber( 1, 'seqno') 
s_itdsc  = dw_insert.getitemstring( 1, 'itdsc')
s_ispec  = dw_insert.getitemstring( 1, 'ispec')
s_jijil  = dw_insert.getitemstring( 1, 'jijil')
s_jejos  = dw_insert.getitemstring( 1, 'jejos')
s_ittyp  = dw_insert.getitemstring( 1, 'ittyp')
s_itcls  = dw_insert.getitemstring( 1, 'itcls')
s_empno  = dw_insert.getitemstring( 1, 'empno2')
s_lotgub = dw_insert.getitemstring( 1, 'lotgub')
s_gbwan  = dw_insert.getitemstring( 1, 'gbwan')
s_gbdate = dw_insert.getitemstring( 1, 'gbdate')
s_gbgub  = dw_insert.getitemstring( 1, 'gbgub')
s_useyn  = dw_insert.getitemstring( 1, 'useyn')
s_auto  = dw_insert.getitemstring( 1, 'itemas_auto')

INSERT INTO "ITEMAS"  
		( "SABU",    "ITNBR",   "ITDSC",   "ISPEC",    "JIJIL",  "JEJOS",   "ITTYP",    "GRITU",   
		  "ITCLS",   "SEQNO",   "ITNBR_VERSION",   	 "ENGNO",   "EMPNO2",   "LOTGUB",   
		  "GBWAN",   "GBDATE",  "GBGUB",    "USEYN",  "STDNBR",  "EMPNO",   
		  "PUMSR",   "CNVFAT",  "UNMSR",    "WAGHT",  "FILSK",   "ACCOD",    "ITGU",   
		  "CHGBN",   "QCEMP",   "LOCFR",    "LOCTO",  "HSNO",    "ABCGB",    "SILSU",   
		  "SILDATE", "WONPRC",  "FORPRC",   "FORPUN", "WONSRC",  "FORSRC",   "FORSUN",   
		  "GNHNO",   "MLICD",    "LDTIM",   
		  "LDTIM2",  "MINSAF",  "MIDSAF",   "MAXSAF", "SHRAT",   "MINQT",    "MULQT", "MAXQT",
		  "AUTO",    "CRT_USER")  
VALUES ( '1',      :s_itnbr, :s_itdsc,  :s_ispec,  :s_jijil,  :s_jejos,  :s_ittyp,   null,   
		   :s_itcls, :l_seqno,  :s_version,           null,  :s_empno,   :s_lotgub,   
		   :s_gbwan, :s_gbdate, :s_gbgub,  :s_useyn,  null,      null,   
			null,     1,         null,      null,      'Y',       null, 		'1',   
			'Y',      null,      null,      null,      null,      null,       null,   
			null,     null,      null,      'WON',     null,      null,      'WON',     
			null,      '1',      null,   
			null,     null,      null,      null,      null,      null,       null, null,
			:s_auto,  :gs_userid )  ;
			


if sqlca.sqlcode <> 0 then 
	rollback ;
	F_ROLLBACK()
else	
	w_mdi_frame.sle_msg.text =	"�ڷḦ �����Ͽ����ϴ�!!"			
	commit ;
end if


//
dw_1.TriggerEvent(itemchanged!)   

lReturnRow = dw_list.Find("itnbr = '"+s_itnbr+"' ", 1, dw_list.RowCount())
dw_list.selectrow(lReturnRow, true)
dw_list.scrolltorow(lReturnRow)
dw_insert.retrieve(s_itnbr) 
dw_dept.Retrieve(s_itnbr)
dw_insert.SetTaborder('itnbr',0)	
dw_insert.setcolumn('ittyp')
dw_insert.setfocus()

ls_gub = 'N'
p_copy.enabled = true
p_copy.PictureName = 'C:\erpman\image\����_up.gif'
p_del.enabled = true
p_del.PictureName = 'C:\erpman\image\����_up.gif'
p_sea.enabled = true
p_sea.PictureName = 'C:\erpman\image\��������_up.gif'
p_print1.enabled = true
p_print1.PictureName = 'C:\erpman\image\�������_up.gif'
p_desc.enabled = true
p_desc.PictureName = 'C:\erpman\image\�������_up.gif'
p_dept.enabled = true
p_dept.PictureName = 'C:\erpman\image\����ǰ��_up.gif'

//string	sCheckBox
//sCheckBox = dw_insert.GetItemString(1, "itemas_auto")
//
//IF sCheckBox = 'Y'	THEN
//	cb_ins.enabled = TRUE
//ELSE
//	cb_ins.enabled = FALSE
//END IF

end event

type p_copy from picture within w_pdm_01270
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 3054
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\����_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_copy.PictureName = 'C:\erpman\image\����_dn.gif'
end event

event ue_lbuttonup;p_copy.PictureName = 'C:\erpman\image\����_up.gif'
end event

event clicked;call super::clicked;string snull

if dw_insert.AcceptText() = -1 then return 

if wf_required_chk() = -1 then return

IF MessageBox("Ȯ ��", "���� ǰ���� ���� �Ͻðڽ��ϱ�?", question!, yesno!) = 2	THEN	RETURN
setnull(snull)

dw_insert.setitemstatus(1, 0, primary!, new!)

dw_insert.SetTaborder('itnbr',1)

dw_insert.setfocus()
ls_gub = 'Y'    //'Y'�̸� ��ϸ��

//dw_insert.SETItem(1, "itnbr", snull)
dw_insert.SETItem(1, "gbdate", F_today())
dw_insert.SETItem(1, "upd_user", snull)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

dw_list.SelectRow(0, FALSE)
p_copy.enabled = false
p_copy.PictureName = 'C:\erpman\image\����_d.gif'
p_del.enabled = false
p_del.PictureName = 'C:\erpman\image\����_d.gif'
p_sea.enabled = false
p_sea.PictureName = 'C:\erpman\image\��������_d.gif'
p_print1.enabled = false
p_print1.PictureName = 'C:\erpman\image\�������_d.gif'
p_desc.enabled = false
p_desc.PictureName = 'C:\erpman\image\�������_d.gif'
p_dept.enabled = false
p_dept.PictureName = 'C:\erpman\image\����ǰ��_d.gif'
end event

type p_6 from picture within w_pdm_01270
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 2085
integer y = 468
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\�˻�_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\�˻�_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\�˻�_up.gif'
end event

event clicked;call super::clicked;long lReturnRow
string sitdsc, sgub
Long   lrow

if dw_1.accepttext() = -1 then return 

if dw_list.rowcount() < 1 then return 

sitdsc = trim(dw_1.getitemstring(1, 'itdsc'))

if sitdsc = '' or isnull(sitdsc) then 
	dw_list.selectrow(0, false)
	dw_list.selectrow(1, true)
	dw_list.scrolltorow(1)
	dw_insert.retrieve(dw_list.getitemstring(1, 'itnbr')) 
	dw_dept.retrieve(dw_list.getitemstring(1, 'itnbr')) 
	dw_insert.SetTaborder('itnbr',0)	
else
	sitdsc = sitdsc + '%'
	
	sgub = dw_1.getitemstring(1, 'gub')
	
	lrow = dw_list.GetSelectedRow(0)
	
	if sgub = '1' then 
		lReturnRow = dw_list.Find("itnbr like '"+sitdsc+"' ", lrow+1, dw_list.RowCount())
	elseif sgub = '2' then 
		lReturnRow = dw_list.Find("itdsc like '"+sitdsc+"' ", lrow+1, dw_list.RowCount())
	elseif sgub = '3' then 
		lReturnRow = dw_list.Find("ispec like '"+sitdsc+"' ", lrow+1, dw_list.RowCount())
	else
		lReturnRow = dw_list.Find("jijil like '"+sitdsc+"' ", lrow+1, dw_list.RowCount())
	end if

	if isnull(lreturnrow) or lreturnrow < 1 then return 
	
	dw_list.selectrow(0, false)
	dw_list.selectrow(lReturnRow, true)
	dw_list.scrolltorow(lReturnRow)
	dw_insert.retrieve(dw_list.getitemstring(lReturnrow, 'itnbr')) 
	dw_dept.retrieve(dw_list.getitemstring(1, 'itnbr')) 
	dw_insert.SetTaborder('itnbr',0)	
end if

end event

type pb_1 from u_pb_cal within w_pdm_01270
integer x = 3319
integer y = 1596
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('gbdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'gbdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdm_01270
boolean visible = false
integer x = 3461
integer y = 2072
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('isir_rdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'isir_rdate', gs_code)
end event

type pb_3 from u_pb_cal within w_pdm_01270
boolean visible = false
integer x = 3461
integer y = 2164
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('apply_rdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'apply_rdate', gs_code)
end event

type pb_4 from u_pb_cal within w_pdm_01270
boolean visible = false
integer x = 4165
integer y = 2068
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('apply_cdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'apply_cdate', gs_code)
end event

