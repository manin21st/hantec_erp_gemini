$PBExportHeader$w_pdm_01270_5.srw
$PBExportComments$품목마스타등록-저장품(소모품)
forward
global type w_pdm_01270_5 from w_inherite
end type
type gb_3 from groupbox within w_pdm_01270_5
end type
type gb_2 from groupbox within w_pdm_01270_5
end type
type dw_1 from datawindow within w_pdm_01270_5
end type
type cbx_auto from checkbox within w_pdm_01270_5
end type
type cb_desc from commandbutton within w_pdm_01270_5
end type
type cb_dept from commandbutton within w_pdm_01270_5
end type
type dw_dept from datawindow within w_pdm_01270_5
end type
type dw_list from u_d_popup_sort within w_pdm_01270_5
end type
type p_desc from picture within w_pdm_01270_5
end type
type p_print1 from picture within w_pdm_01270_5
end type
type p_dept from picture within w_pdm_01270_5
end type
type p_sea from picture within w_pdm_01270_5
end type
type p_copy from picture within w_pdm_01270_5
end type
type p_6 from picture within w_pdm_01270_5
end type
type pb_1 from u_pb_cal within w_pdm_01270_5
end type
type pb_2 from u_pb_cal within w_pdm_01270_5
end type
type pb_3 from u_pb_cal within w_pdm_01270_5
end type
type pb_4 from u_pb_cal within w_pdm_01270_5
end type
type r_list from rectangle within w_pdm_01270_5
end type
end forward

global type w_pdm_01270_5 from w_inherite
integer width = 4667
integer height = 2484
string title = "저장품마스타 등록"
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
cbx_auto cbx_auto
cb_desc cb_desc
cb_dept cb_dept
dw_dept dw_dept
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
r_list r_list
end type
global w_pdm_01270_5 w_pdm_01270_5

type variables
String ls_gub = 'Y' //Y:등록,N:수정
str_itnct lstr_sitnct
string  is_version, is_Auto

string is_ittyp = '5' // 셋팅할 품목구분

string is_delete = 'Y'
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
dw_insert.SetItem(1, 'ittyp',is_ittyp)
//dw_insert.Object.ittyp.protect = '1'

dw_insert.SetRedraw(true)

dw_insert.SetTaborder('itnbr',1)

dw_dept.Reset()
dw_insert.setfocus()
ls_gub = 'Y'    //'Y'이면 등록모드

end subroutine

public function string wf_copy ();//////////////////////////////////////////////////////////////////////
// 	1. 품목구분 + MODEL/품목분류 + SEQ NO + VERSION -> 품목코드 copy 
//////////////////////////////////////////////////////////////////////
String 	sItnbr,	sIttyp, sGubcode, sSeq, sVersion
long     lSeq

dw_insert.accepttext()
//품목구분
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
//       argument : String old_version(이전 버전)
//         return : String (변환한 새료운 버전)
//                  0(48) - 9(57), A(65) - Z(90) 
//*******************************************************************//
integer i_new, i_old
char  new_version

i_old = ASC(old_version) 

IF i_old = 57 THEN
	i_new = 65
ELSEIF i_old = 90 THEN
   MessageBox("확 인", "버전증가를 실패하였습니다. 최종버전이 'Z'를 넘을 수 없습니다.!!")
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
	f_message_chk(1400,'[품번]')
	dw_insert.setcolumn('itnbr')
	dw_insert.setfocus()
	RETURN -1
ELSE
	SELECT "ITEMAS"."ITNBR"  
	  INTO :get_name  
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ITNBR" = :sitnbr   ;

	if sqlca.sqlcode = 0 then 
		f_message_chk(37,'[품번]')
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
// 	1. 품목구분 + MODEL/품목분류 + SEQ NO + VERSION -> 품목코드 채번 
//////////////////////////////////////////////////////////////////////
String 	sItnbr,	sIttyp, sGubcode, sSeq, sVersion,	&
			sAuto, get_name
long     lSeq

//품목구분
sIttyp = dw_insert.getitemstring(1, 'ittyp')
sGubcode = dw_insert.getitemstring(1, 'itcls')

// 중분류코드
sGubcode = left(sGubcode, 4)	

// 중분류코드 자동채번 CHECK
SELECT "AUTO"
  INTO :sAuto
  FROM "ITNCT"  
 WHERE ( "ITNCT"."ITTYP" = :sIttyp ) AND  
		 ( "ITNCT"."ITCLS" = :sGubcode ) AND  
		 ( "ITNCT"."LMSGU" = 'M' )   ;

if sqlca.sqlcode <> 0 then
	f_message_chk(51,'[품목분류]')
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
		f_message_chk(51,'[품번]')
		return -1
	end if

	dw_insert.SetItem(1, "seqno" , lSeq )
	sSeq = string(lSeq, "000")   //SEQ NO
	sVersion = dw_insert.getitemstring(1, 'itnbr_version')
	sItnbr = sIttyp + sGubCode + sSeq      //버전 제외+ sVersion
	dw_insert.SetItem(1, "itnbr" , sItnbr )
	dw_insert.SetItem(1, "itemas_auto" , 'Y' )
ELSE
	MessageBox("확인", "중분류코드의 자동채번유무를 확인하십시요.~r" +  &
							 "중분류코드 자동채번구분이 N0 로 설정되어 있습니다.")
	RETURN -1
END IF

Return 1
end function

public function integer wf_itnbr_check (string sitnbr);Long icnt = 0

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = '삭제 가능 여부 CHECK 중.....'

select count(*) into :icnt
  from vnddan
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[거래처제품단가]')
	return -1
end if

select count(*) into :icnt
  from danmst
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[단가마스타]')
	return -1
end if

select count(*) into :icnt
  from poblkt
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[발주_품목정보]')
	return -1
end if

select count(*) into :icnt
  from estima
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[발주예정_구매의뢰]')
	return -1
end if

select count(*) into :icnt
  from sorder
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[수주]')
	return -1
end if

select count(*) into :icnt
  from exppid
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[수출PI Detail]')
	return -1
end if

select count(*) into :icnt
  from imhist
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[입출고이력]')
	return -1
end if

//기술 BOM 체크  
  SELECT COUNT("ESTRUC"."USSEQ")  
    INTO :icnt  
    FROM "ESTRUC"  
   WHERE "ESTRUC"."PINBR" = :sitnbr OR "ESTRUC"."CINBR" = :sitnbr ;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[기술BOM]')
	return -1
end if
	
//생산 BOM 체크  
  SELECT COUNT("PSTRUC"."USSEQ")  
    INTO :icnt  
    FROM "PSTRUC"  
   WHERE "PSTRUC"."PINBR" = :sitnbr OR "PSTRUC"."CINBR" = :sitnbr ;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[생산BOM]')
	return -1
end if

//외주 BOM 체크  
  SELECT COUNT("WSTRUC"."USSEQ")  
    INTO :icnt  
    FROM "WSTRUC"  
   WHERE "WSTRUC"."PINBR" = :sitnbr OR "WSTRUC"."CINBR" = :sitnbr ;	

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[외주BOM]')
	return -1
end if

//외주단가 BOM 체크  
  SELECT SUM(1)  
    INTO :icnt  
    FROM "WSUNPR"  
   WHERE "WSUNPR"."ITNBR" = :sitnbr;

if icnt > 0 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[외주단가BOM]')
	return -1
end if

//할당 체크
select count(*) into :icnt
  from holdstock
 where itnbr = :sitnbr;
		 
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[할당]')
	return -1
end if

//월 재고
select count(*) into :icnt
  from stockmonth
 where itnbr = :sitnbr;
if sqlca.sqlcode <> 0 or icnt >= 1 then
	w_mdi_frame.sle_msg.text = ''
	f_message_chk(38,'[기초재고]')
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
	f_message_chk(1400,'[품목구분]')
	dw_insert.SetColumn('ittyp')
	dw_insert.SetFocus()
	return -1
end if	

// 품목구입 또는 제작형태가 nULL인 경우에는 품목구분을 이용하영 기본으로 Setting
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
	f_message_chk(1400,'[품목분류]')
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
   	f_message_chk(33,'[품목분류]')
		dw_insert.SetColumn('itcls')
		dw_insert.SetFocus()
   	return -1
   END IF
end if			

if isnull(dw_insert.GetItemString(1,'itdsc')) or &
	dw_insert.GetItemString(1,'itdsc') = "" then
	f_message_chk(1400,'[품명]')
	dw_insert.SetColumn('itdsc')
	dw_insert.SetFocus()
	return -1
end if	

sAsc =  trim(dw_insert.GetItemString(1,'ispec')) 
 
iAsc = asc(sAsc)
if sAsc = "" or iAsc = 13 then   // ||(ctrl + enter 값) = 13(ascii code 값)   
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
	f_message_chk(1400,'[LOT NO 관리번호]')
	dw_insert.SetColumn('lotgub')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'gbwan')) or &
	dw_insert.GetItemString(1,'gbwan') = "" then
	f_message_chk(1400,'[개발완료구분]')
	dw_insert.SetColumn('gbwan')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'gbgub')) or &
	dw_insert.GetItemString(1,'gbgub') = "" then
	f_message_chk(1400,'[개발구분]')
	dw_insert.SetColumn('gbgub')
	dw_insert.SetFocus()
	return -1
end if	

if isnull(dw_insert.GetItemString(1,'useyn')) or &
	dw_insert.GetItemString(1,'useyn') = "" then
	f_message_chk(1400,'[사용구분]')
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

// null 값 체크
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
	dw_list.SetFilter("")    //완료구분 = ALL
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
	
ls_gub = 'Y'    //'Y'이면 등록모드
ib_any_typing = FALSE
p_copy.enabled = false
p_copy.PictureName = 'C:\erpman\image\복사_d.gif'
//p_del.enabled = false
//p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
is_delete = 'N'
p_sea.enabled = false
p_sea.PictureName = 'C:\erpman\image\버전증가_d.gif'
p_print1.enabled = false
p_print1.PictureName = 'C:\erpman\image\도면관리_d.gif'
p_desc.enabled = false
p_desc.PictureName = 'C:\erpman\image\기술내역_d.gif'
p_dept.enabled = false
p_dept.PictureName = 'C:\erpman\image\신제품평가_d.gif'

end subroutine

on w_pdm_01270_5.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
this.cbx_auto=create cbx_auto
this.cb_desc=create cb_desc
this.cb_dept=create cb_dept
this.dw_dept=create dw_dept
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
this.r_list=create r_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.cbx_auto
this.Control[iCurrent+5]=this.cb_desc
this.Control[iCurrent+6]=this.cb_dept
this.Control[iCurrent+7]=this.dw_dept
this.Control[iCurrent+8]=this.dw_list
this.Control[iCurrent+9]=this.p_desc
this.Control[iCurrent+10]=this.p_print1
this.Control[iCurrent+11]=this.p_dept
this.Control[iCurrent+12]=this.p_sea
this.Control[iCurrent+13]=this.p_copy
this.Control[iCurrent+14]=this.p_6
this.Control[iCurrent+15]=this.pb_1
this.Control[iCurrent+16]=this.pb_2
this.Control[iCurrent+17]=this.pb_3
this.Control[iCurrent+18]=this.pb_4
this.Control[iCurrent+19]=this.r_list
end on

on w_pdm_01270_5.destroy
call super::destroy
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.cbx_auto)
destroy(this.cb_desc)
destroy(this.cb_dept)
destroy(this.dw_dept)
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
destroy(this.r_list)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_dept.SetTransObject(sqlca)

dw_insert.InsertRow(0)
dw_1.InsertRow(0)

// 지정된 품목구분 설정
dw_1.SetItem(1, 'ittyp',is_ittyp)
//dw_1.Object.ittyp.protect = '1'
dw_insert.SetItem(1, 'ittyp',is_ittyp)
dw_insert.SetItem(1, 'temp_itgu', '2')
//dw_insert.Object.ittyp.protect = '1'

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

// 저장품은 자동채번
is_Auto = 'Y'	

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

dw_list.Retrieve(gs_saupj, is_ittyp, '%')
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
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

event resize;r_list.height = this.height - r_list.y - 65
dw_list.height = this.height - dw_list.y - 70

r_detail.width = this.width - 60 - 2313
r_detail.height = this.height - r_detail.y - 65
dw_insert.width = this.width - 70 - 2313
dw_insert.height = this.height - dw_insert.y - 70
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", false) //// 추가
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true) //// 삭제
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true) //// 저장
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true) //// 취소
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", false) //// 찾기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 false) //// 필터
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", false) //// 엑셀다운
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", false) //// 출력
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", false) //// 미리보기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", false) //// 도움말
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", false)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", false)

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = false //// 추가
m_main2.m_window.m_del.enabled = true  //// 삭제
m_main2.m_window.m_save.enabled = true //// 저장
m_main2.m_window.m_cancel.enabled = true //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = false  //// 찾기
m_main2.m_window.m_filter.enabled = false //// 필터
m_main2.m_window.m_excel.enabled = false //// 엑셀다운
m_main2.m_window.m_print.enabled = false  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01270_5
integer x = 4000
integer y = 3028
end type

type sle_msg from w_inherite`sle_msg within w_pdm_01270_5
integer x = 4192
integer y = 2844
long backcolor = 12632256
end type

type dw_datetime from w_inherite`dw_datetime within w_pdm_01270_5
integer x = 4192
integer y = 2844
end type

type st_1 from w_inherite`st_1 within w_pdm_01270_5
integer y = 2600
end type

type p_search from w_inherite`p_search within w_pdm_01270_5
integer x = 4187
integer y = 2848
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01270_5
integer x = 4187
integer y = 2848
end type

type p_delrow from w_inherite`p_delrow within w_pdm_01270_5
integer x = 4187
integer y = 2848
end type

type p_mod from w_inherite`p_mod within w_pdm_01270_5
integer x = 4613
integer y = 3244
end type

event p_mod::clicked;call super::clicked;string s_itnbr, s_ittyp
long lreturnrow

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if wf_required_chk() = -1 then return
/////////////////////////////////////////////////////////////////////////////

// 품명/규격명 체크
IF wf_name_chk() = -1	THEN
	dw_insert.setcolumn('itdsc')
	dw_insert.setfocus()
	RETURN 
END IF

IF ls_gub = 'Y'  THEN           //등록 mod일때
	IF is_auto = 'Y' THEN        //시스템 file에서 자동채번일때
		IF	cbx_auto.checked THEN  
	
			// 품목분류 순번증가
			if wf_add_seqno_yakum() < 0 then 
				rollback ;
				return 
			end if				
			
			// 원래 version
			// 품목번호 자동채번
			IF  wf_rename() = -1	THEN	RETURN 
		
			// 품목분류 순번증가
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
	w_mdi_frame.sle_msg.text =	"자료를 저장하였습니다!!"			
	ib_any_typing = false
	commit ;
else
	rollback ;
	return 
end if	

p_inq.triggerevent(clicked!)	

end event

type p_del from w_inherite`p_del within w_pdm_01270_5
integer x = 4965
integer y = 3244
end type

event p_del::clicked;call super::clicked;string s_itnbr
long   get_count, lrow

if dw_insert.AcceptText() = -1 then return

if is_delete = 'N' then return

s_itnbr = dw_insert.GetItemString(1,'itnbr')

if s_itnbr = '' or isnull(s_itnbr) then return 

//삭제하기전에 삭제여부 체크해야 
IF wf_itnbr_check(s_itnbr) = -1 THEN RETURN

SELECT COUNT("ITMDA"."DTNBR")  
  INTO :get_count  
  FROM "ITMDA"  
 WHERE "ITMDA"."DTNBR" = :s_itnbr   ;

IF get_count < 1 Then 
   IF f_msg_delete() = -1 THEN Return
ELSE
   IF MessageBox("삭 제","이 품번을 삭제하시면 다른 품번에 대체품번으로 등록된 "+ "~n" +&
								 "자료도 삭제됩니다." +"~n~n" +&
                      	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
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

w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	

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
p_copy.PictureName = 'C:\erpman\image\복사_d.gif'
//p_del.enabled = false
//p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
is_delete = 'N'
p_sea.enabled = false
p_sea.PictureName = 'C:\erpman\image\버전증가_d.gif'
p_print1.enabled = false
p_print1.PictureName = 'C:\erpman\image\도면관리_d.gif'
p_desc.enabled = false
p_desc.PictureName = 'C:\erpman\image\기술내역_d.gif'
p_dept.enabled = false
p_dept.PictureName = 'C:\erpman\image\신제품평가_d.gif'

end event

type p_inq from w_inherite`p_inq within w_pdm_01270_5
integer x = 3909
integer y = 3244
end type

event p_inq::clicked;string s_code

if dw_insert.AcceptText() = -1 then return 

if dw_insert.RowCount() <= 0 then
	dw_insert.SetFocus()
	return 
end if	

s_code = dw_insert.GetItemString(1,"itnbr")

if isnull(s_code) or s_code = "" then
	f_message_chk(30,'[품번]')
	dw_insert.SetFocus()
	return
end if	

if dw_insert.Retrieve(s_code) <= 0 then
	f_message_chk(50,'[품목마스타]')
   wf_init()
   return
  
else
   dw_dept.Retrieve(s_code)
	dw_insert.SetTaborder('itnbr',0)	
   dw_insert.setcolumn('ittyp')
   dw_insert.setfocus()
   ib_any_typing = FALSE
	p_copy.enabled = true
	p_copy.PictureName = 'C:\erpman\image\복사_up.gif'
	//p_del.enabled = true
	//p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
	is_delete = 'Y'
   p_sea.enabled = true
	p_sea.PictureName = 'C:\erpman\image\버전증가_up.gif'
	p_print1.enabled = true
	p_print1.PictureName = 'C:\erpman\image\도면관리_up.gif'
	p_desc.enabled = true
	p_desc.PictureName = 'C:\erpman\image\기술내역_up.gif'
	p_dept.enabled = true
	p_dept.PictureName = 'C:\erpman\image\신제품평가_up.gif'
	ls_gub = 'N'    
end if	

end event

type p_print from w_inherite`p_print within w_pdm_01270_5
integer x = 3557
integer y = 3244
end type

type p_can from w_inherite`p_can within w_pdm_01270_5
integer x = 5317
integer y = 3244
end type

event p_can::clicked;call super::clicked;wf_init()

ib_any_typing = FALSE
p_copy.enabled = false
p_copy.PictureName = 'C:\erpman\image\복사_d.gif'
//p_del.enabled = false
//p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
is_delete = 'N'
p_sea.enabled = false
p_sea.PictureName = 'C:\erpman\image\버전증가_d.gif'
p_print1.enabled = false
p_print1.PictureName = 'C:\erpman\image\도면관리_d.gif'
p_desc.enabled = false
p_desc.PictureName = 'C:\erpman\image\기술내역_d.gif'
p_dept.enabled = false
p_dept.PictureName = 'C:\erpman\image\신제품평가_d.gif'

dw_1.TriggerEvent(itemchanged!)

dw_insert.SETItem(1, "gbdate", f_today())
dw_insert.SetItem(1, 'ittyp',is_ittyp)
dw_insert.SetItem(1, 'temp_itgu','2')
//dw_insert.Object.ittyp.protect = '1'

dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

end event

type p_exit from w_inherite`p_exit within w_pdm_01270_5
integer x = 5669
integer y = 3244
end type

type p_ins from w_inherite`p_ins within w_pdm_01270_5
integer x = 4261
integer y = 3244
end type

type p_new from w_inherite`p_new within w_pdm_01270_5
integer x = 3205
integer y = 3244
end type

type dw_input from w_inherite`dw_input within w_pdm_01270_5
boolean visible = false
integer x = 347
integer y = 2600
integer width = 101
integer height = 100
end type

type cb_delrow from w_inherite`cb_delrow within w_pdm_01270_5
boolean visible = false
integer y = 2600
end type

type cb_addrow from w_inherite`cb_addrow within w_pdm_01270_5
boolean visible = false
integer y = 2600
end type

type dw_insert from w_inherite`dw_insert within w_pdm_01270_5
integer x = 2350
integer y = 276
integer width = 2149
integer height = 2020
integer taborder = 40
string dataobject = "d_pdm_01270_5_2"
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
	 WHERE "ITEMAS"."ITNBR" = :s_itnbr
	   AND "ITEMAS"."ITTYP" = :is_ittyp;
	IF SQLCA.SQLCODE = 0 THEN
		p_inq.TriggerEvent(Clicked!)
		RETURN 1
	Else
		If MessageBox('미 등록 품번', '등록되지 않은 품번입니다.~r~n신규로 등록 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then
			SetItem(1, 'itnbr', sNull)
			Return 2
		End If
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
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'titnm1', snull)
		return 1
	else	
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'titnm1', snull)
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
//차종 코드 선택
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
		MessageBox("확인","차종코드가 존재하지 않습니다.",Exclamation!)
		this.SetItem(1,'gritu', '')
		this.SetItem(1,'vhtype', '')
		Return 1
	End If
	
	this.SetItem(1,"gritu",ls_data1)
	this.SetItem(1,"vhtype",ls_data2)
	
//모델 코드 선택
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
		MessageBox("확인","모델코드가 존재하지 않습니다.",Exclamation!)
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
		f_message_chk(33,'[개발담당자]')
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
			messagebox("확 인", "생산대표 품번으로 등록된 자료는 사용정지/단종 시킬 수 없습니다.")
			return 2
		end if	
	END IF
ELSEIF this.GetColumnName() = 'gbdate' THEN
	s_date = Trim(this.Gettext())
	IF s_date ="" OR IsNull(s_date) THEN RETURN
	
	IF f_datechk(s_date) = -1 THEN
		f_message_chk(35,'[개발완료일자]')
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
	
	ireturn = f_get_name2('전체품번', 'Y', s_stdnbr, get_nm, get_nm2)
	IF ireturn = 0 THEN
      s_itnbr = this.GetItemString(1, "itnbr")
		
		If s_itnbr = s_stdnbr then
    		f_message_chk(44,'[생산대표 품번]')
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
				f_message_chk(55,'[생산대표 품번]')
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
   gs_gubun = is_ittyp
	open(w_itemas_popup3)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"itnbr",gs_code)
	PostEvent(ItemChanged!)
//	p_inq.TriggerEvent(Clicked!)
	RETURN 1

elseif this.GetColumnName() = 'itcls' then
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	

	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	If lstr_sitnct.s_ittyp <> is_ittyp Then Return 2

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
//차종 코드 선택
elseif this.GetColumnName() = 'gritu' then
   gs_code = this.GetText()

	open(w_vehtype_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(1,"gritu",gs_code)
	this.SetItem(1,"vhtype",gs_codename)
	
	RETURN 1
//모델 코드 선택
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

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event dw_insert::clicked;//
end event

event dw_insert::rowfocuschanged;//
end event

type cb_mod from w_inherite`cb_mod within w_pdm_01270_5
boolean visible = false
integer y = 2600
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
//// 품명/규격명 체크
//IF wf_name_chk() = -1	THEN
//	dw_insert.setcolumn('itdsc')
//	dw_insert.setfocus()
//	RETURN 
//END IF
//
//IF ls_gub = 'Y'  THEN           //등록 mod일때
//	IF is_auto = 'Y' THEN        //시스템 file에서 자동채번일때
//		IF	cbx_auto.checked THEN  
//	
//			// 품목분류 순번증가
//			if wf_add_seqno_yakum() < 0 then 
//				rollback ;
//				return 
//			end if				
//			
//			// 원래 version
//			// 품목번호 자동채번
//			IF  wf_rename() = -1	THEN	RETURN 
//		
//			// 품목분류 순번증가
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
//	sle_msg.text =	"자료를 저장하였습니다!!"			
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
////	dw_list.SetFilter("")    //완료구분 = ALL
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

type cb_ins from w_inherite`cb_ins within w_pdm_01270_5
boolean visible = false
integer y = 2600
end type

event clicked;//string snull
//
//if dw_insert.AcceptText() = -1 then return 
//
//if wf_required_chk() = -1 then return
//
//IF MessageBox("확 인", "현재 품목을 복사 하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
//setnull(snull)
//
//dw_insert.setitemstatus(1, 0, primary!, new!)
//
//dw_insert.SetTaborder('itnbr',1)
//
//dw_insert.setfocus()
//ls_gub = 'Y'    //'Y'이면 등록모드
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

type cb_del from w_inherite`cb_del within w_pdm_01270_5
boolean visible = false
integer y = 2600
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
////삭제하기전에 삭제여부 체크해야 
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
//   IF MessageBox("삭 제","이 품번을 삭제하시면 다른 품번에 대체품번으로 등록된 "+ "~n" +&
//								 "자료도 삭제됩니다." +"~n~n" +&
//                      	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
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
//sle_msg.text =	"자료를 삭제하였습니다!!"	
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

type cb_inq from w_inherite`cb_inq within w_pdm_01270_5
boolean visible = false
integer y = 2600
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
//	f_message_chk(30,'[품번]')
//	dw_insert.SetFocus()
//	return
//end if	
//
//if dw_insert.Retrieve(s_code) <= 0 then
//	f_message_chk(50,'[품목마스타]')
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

type cb_print from w_inherite`cb_print within w_pdm_01270_5
boolean visible = false
integer y = 2600
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

type cb_can from w_inherite`cb_can within w_pdm_01270_5
boolean visible = false
integer y = 2600
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

type cb_search from w_inherite`cb_search within w_pdm_01270_5
boolean visible = false
integer y = 2600
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
//s_message = '마지막 버전은  ' + c_version + ' 입니다.' 
//
//IF MessageBox("확 인",  + s_message + "~n~n" + &
//              "현재 품목을 버전증가 하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
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
//	sle_msg.text =	"자료를 저장하였습니다!!"			
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

type gb_10 from w_inherite`gb_10 within w_pdm_01270_5
integer y = 2980
integer height = 140
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01270_5
integer x = 3899
integer y = 2844
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01270_5
integer x = 3899
integer y = 2844
end type

type r_head from w_inherite`r_head within w_pdm_01270_5
integer y = 272
integer width = 2272
integer height = 376
end type

type r_detail from w_inherite`r_detail within w_pdm_01270_5
integer x = 2345
integer y = 272
integer width = 2158
integer height = 2028
end type

type gb_3 from groupbox within w_pdm_01270_5
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
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12632256
end type

type gb_2 from groupbox within w_pdm_01270_5
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
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12632256
end type

type dw_1 from datawindow within w_pdm_01270_5
event ue_enter pbm_dwnprocessenter
integer x = 37
integer y = 276
integer width = 2263
integer height = 368
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01270_5_1"
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
		ls_Dcomp   = this.Gettext()   // 사업장 구분 확인.
	     wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
	Case	"ittyp" 
		s_pumgu = this.Gettext()
		IF s_pumgu = "" OR IsNull(s_pumgu) THEN 
			RETURN
		END IF
		
		s_name = f_get_reffer('05', s_pumgu)
		if isnull(s_name) or s_name="" then
			f_message_chk(33,'[품목구분]')
			this.SetItem(1,'ittyp', snull)
			return 1
		end if
        is_ittyp = s_pumgu
	     wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
	Case	"sildate" 
		s_date     = trim(this.Gettext())
		IF s_date ="" OR IsNull(s_date) THEN 
		   	wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
			Return 
		END IF
	
		IF f_datechk(s_date) = -1 THEN
			f_message_chk(35,'[생성일자]')
			this.SetItem(1,"sildate",snull)
	   		wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
			Return 1
		END IF

		if isnull(s_pumgu) or s_pumgu="" then
			f_message_chk(40,'[품목구분]')
			this.SetColumn('ittyp')
			this.SetFocus()
			return 1
		end if
   
   		wf_retrieve(ls_Dcomp, s_pumgu, s_date, s_use)
	Case	"useyn" 
		if isnull(s_pumgu) or s_pumgu="" then
			f_message_chk(40,'[품목구분]')
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

type cbx_auto from checkbox within w_pdm_01270_5
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
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 12639424
string text = "자동채번"
boolean checked = true
end type

type cb_desc from commandbutton within w_pdm_01270_5
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
string facename = "굴림체"
boolean enabled = false
string text = "기술내역(&T)"
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

type cb_dept from commandbutton within w_pdm_01270_5
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
string facename = "굴림체"
boolean enabled = false
string text = "신제품평가"
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

type dw_dept from datawindow within w_pdm_01270_5
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

type dw_list from u_d_popup_sort within w_pdm_01270_5
event ue_key pbm_dwnkey
integer x = 37
integer y = 756
integer width = 2263
integer height = 1540
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdm_01271"
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
   	ls_gub = 'Y'    //'Y'이면 등록모드
		ib_any_typing = FALSE
		p_copy.enabled = false
		p_copy.PictureName = 'C:\erpman\image\복사_d.gif'
		//p_del.enabled = false
		//p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
		is_delete = 'N'
		p_sea.enabled = false
		p_sea.PictureName = 'C:\erpman\image\버전증가_d.gif'
		p_print1.enabled = false
		p_print1.PictureName = 'C:\erpman\image\도면관리_d.gif'
		p_desc.enabled = false
		p_desc.PictureName = 'C:\erpman\image\기술내역_d.gif'
		p_dept.enabled = false
		p_dept.PictureName = 'C:\erpman\image\신제품평가_d.gif'
	else
		dw_dept.Retrieve(dw_list.GetItemString(Row,"itnbr"))
		dw_insert.SetTaborder('itnbr',0)
		ib_any_typing = FALSE
		p_copy.enabled = true
		p_copy.PictureName = 'C:\erpman\image\복사_up.gif'
		//p_del.enabled = true
		//p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
		is_delete = 'Y'
		p_sea.enabled = true
		p_sea.PictureName = 'C:\erpman\image\버전증가_up.gif'
		p_print1.enabled = true
		p_print1.PictureName = 'C:\erpman\image\도면관리_up.gif'
		p_desc.enabled = true
		p_desc.PictureName = 'C:\erpman\image\기술내역_up.gif'
		p_dept.enabled = true
		p_dept.PictureName = 'C:\erpman\image\신제품평가_up.gif'
		ls_gub = 'N'    //'N'이면 수정모드
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
ls_gub = 'N'    //'N'이면 수정모드

dw_dept.Retrieve(s_code)
this.setredraw(true)



end event

type p_desc from picture within w_pdm_01270_5
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 2917
integer y = 48
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\기술내역_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_desc.PictureName = 'C:\erpman\image\기술내역_dn.gif'
end event

event ue_lbuttonup;p_desc.PictureName = 'C:\erpman\image\기술내역_up.gif'
end event

event p_desc::clicked;call super::clicked;string sItnbr
if dw_insert.accepttext() = -1 then return 

sItnbr = dw_insert.getitemstring(1, 'itnbr')

OpenWithParm(w_pdm_01285, sItnbr)


end event

type p_print1 from picture within w_pdm_01270_5
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 2743
integer y = 48
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\도면관리_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_print1.PictureName = 'C:\erpman\image\도면관리_dn.gif'
end event

event ue_lbuttonup;p_print1.PictureName = 'C:\erpman\image\도면관리_up.gif'
end event

event clicked;string sItnbr
if dw_insert.accepttext() = -1 then return 

sItnbr = dw_insert.getitemstring(1, 'itnbr')

OpenWithParm(w_pdm_01280, sItnbr)


end event

type p_dept from picture within w_pdm_01270_5
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 1737
integer y = 48
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
boolean enabled = false
string picturename = "C:\erpman\image\신제품평가_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_dept.PictureName = 'C:\erpman\image\신제품평가_dn.gif'
end event

event ue_lbuttonup;p_dept.PictureName = 'C:\erpman\image\신제품평가_up.gif'
end event

event p_dept::clicked;call super::clicked;string sItnbr
if dw_insert.accepttext() = -1 then return 

sItnbr = dw_insert.getitemstring(1, 'itnbr')

OpenWithParm(w_pdm_01287, sItnbr)

dw_dept.retrieve(sitnbr)
end event

type p_sea from picture within w_pdm_01270_5
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 2569
integer y = 48
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\버전증가_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_sea.PictureName = 'C:\erpman\image\버전증가_dn.gif'
end event

event ue_lbuttonup;p_sea.PictureName = 'C:\erpman\image\버전증가_up.gif'
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
	
s_message = '마지막 버전은  ' + c_version + ' 입니다.' 

IF MessageBox("확 인",  + s_message + "~n~n" + &
              "현재 품목을 버전증가 하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

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
	w_mdi_frame.sle_msg.text =	"자료를 저장하였습니다!!"			
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
p_copy.PictureName = 'C:\erpman\image\복사_up.gif'
//p_del.enabled = true
//p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
is_delete = 'Y'
p_sea.enabled = true
p_sea.PictureName = 'C:\erpman\image\버전증가_up.gif'
p_print1.enabled = true
p_print1.PictureName = 'C:\erpman\image\도면관리_up.gif'
p_desc.enabled = true
p_desc.PictureName = 'C:\erpman\image\기술내역_up.gif'
p_dept.enabled = true
p_dept.PictureName = 'C:\erpman\image\신제품평가_up.gif'

//string	sCheckBox
//sCheckBox = dw_insert.GetItemString(1, "itemas_auto")
//
//IF sCheckBox = 'Y'	THEN
//	cb_ins.enabled = TRUE
//ELSE
//	cb_ins.enabled = FALSE
//END IF

end event

type p_copy from picture within w_pdm_01270_5
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 2395
integer y = 48
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\복사_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;p_copy.PictureName = 'C:\erpman\image\복사_dn.gif'
end event

event ue_lbuttonup;p_copy.PictureName = 'C:\erpman\image\복사_up.gif'
end event

event clicked;call super::clicked;string snull

if dw_insert.AcceptText() = -1 then return 

if wf_required_chk() = -1 then return

IF MessageBox("확 인", "현재 품목을 복사 하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
setnull(snull)

dw_insert.setitemstatus(1, 0, primary!, new!)

dw_insert.SetTaborder('itnbr',1)

dw_insert.setfocus()
ls_gub = 'Y'    //'Y'이면 등록모드

//dw_insert.SETItem(1, "itnbr", snull)
dw_insert.SETItem(1, "gbdate", F_today())
dw_insert.SETItem(1, "upd_user", snull)
dw_insert.SetColumn('itnbr')
dw_insert.SetFocus()

dw_list.SelectRow(0, FALSE)
p_copy.enabled = false
p_copy.PictureName = 'C:\erpman\image\복사_d.gif'
//p_del.enabled = false
//p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
is_delete = 'N'
p_sea.enabled = false
p_sea.PictureName = 'C:\erpman\image\버전증가_d.gif'
p_print1.enabled = false
p_print1.PictureName = 'C:\erpman\image\도면관리_d.gif'
p_desc.enabled = false
p_desc.PictureName = 'C:\erpman\image\기술내역_d.gif'
p_dept.enabled = false
p_dept.PictureName = 'C:\erpman\image\신제품평가_d.gif'
end event

type p_6 from picture within w_pdm_01270_5
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 2085
integer y = 468
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\검색_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\검색_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\검색_up.gif'
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

type pb_1 from u_pb_cal within w_pdm_01270_5
integer x = 3319
integer y = 1596
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('gbdate')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'gbdate', gs_code)
end event

type pb_2 from u_pb_cal within w_pdm_01270_5
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

type pb_3 from u_pb_cal within w_pdm_01270_5
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

type pb_4 from u_pb_cal within w_pdm_01270_5
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

type r_list from rectangle within w_pdm_01270_5
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 33028087
integer x = 32
integer y = 752
integer width = 2272
integer height = 1548
end type

