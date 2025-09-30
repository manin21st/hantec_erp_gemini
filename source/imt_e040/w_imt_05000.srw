$PBExportHeader$w_imt_05000.srw
$PBExportComments$** 매입마감 회계전송
forward
global type w_imt_05000 from w_inherite
end type
type dw_list from u_key_enter within w_imt_05000
end type
type rb_1 from radiobutton within w_imt_05000
end type
type rb_2 from radiobutton within w_imt_05000
end type
type dw_1 from u_key_enter within w_imt_05000
end type
type pb_1 from u_pb_cal within w_imt_05000
end type
type pb_2 from u_pb_cal within w_imt_05000
end type
type pb_3 from u_pb_cal within w_imt_05000
end type
type rr_1 from roundrectangle within w_imt_05000
end type
type rr_2 from roundrectangle within w_imt_05000
end type
type rr_3 from roundrectangle within w_imt_05000
end type
type rr_4 from roundrectangle within w_imt_05000
end type
end forward

global type w_imt_05000 from w_inherite
integer height = 3772
string title = "매입마감 회계전송"
dw_list dw_list
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
end type
global w_imt_05000 w_imt_05000

type variables
String     is_magubn					// mro여부
end variables

forward prototypes
public function integer wf_wdept_set (string ar_sabu, string ar_yymm, integer ar_seq, string ar_cvcod)
public subroutine wf_kif01ot0_chk (string ar_no, string gub)
public function integer wf_required_chk ()
public function integer wf_accod_chk (string gub)
end prototypes

public function integer wf_wdept_set (string ar_sabu, string ar_yymm, integer ar_seq, string ar_cvcod);////////////////////////////////////////////////////////////////////////////////////////
// 원가 부문 셋팅하기(마감 이력으로 발주자료를 찾고 구매의뢰 자료를 다시 찾아서 조회되는
//                      첫번째 부서 ) 없으면 (소급) 수불에 의뢰부서로 
////////////////////////////////////////////////////////////////////////////////////////
string get_dept, get_deptnm, sdept_cd

SELECT "ESTIMA"."RDPTNO"
  INTO :get_dept
  FROM "IMHIST", "ESTIMA"  
 WHERE ( "IMHIST"."SABU"    = "ESTIMA"."SABU" ) and  
		 ( "IMHIST"."BALJPNO" = "ESTIMA"."BALJPNO" ) and  
		 ( "IMHIST"."BALSEQ"  = "ESTIMA"."BALSEQ" ) and  
		 ( "IMHIST"."SABU"    = :ar_sabu  ) AND  
		 ( "IMHIST"."MAYYMM"  = :ar_yymm  ) AND  
		 ( "IMHIST"."MAYYSQ"  = :ar_seq   ) AND  
		 ( "IMHIST"."CVCOD"   = :ar_cvcod ) AND
		  ROWNUM = 1 ;


IF isnull(get_dept) or get_dept = '' then 
	SELECT "IOREDEPT"
	  INTO :get_dept
	  FROM "IMHIST"
	 WHERE ( "IMHIST"."SABU"    = :ar_sabu  ) AND  
			 ( "IMHIST"."MAYYMM"  = :ar_yymm  ) AND  
			 ( "IMHIST"."MAYYSQ"  = :ar_seq   ) AND  
			 ( "IMHIST"."CVCOD"   = :ar_cvcod ) AND
			  ROWNUM = 1 ;
END IF	

SELECT COST_CD, COST_NM  
  INTO :sdept_cd, :get_deptnm
  FROM CIA02M  
 WHERE DEPT_CD = :get_dept AND USEGBN = '1' AND ROWNUM = 1 ;

dw_insert.object.sdept_cd[1] = sdept_cd
dw_insert.object.wdeptnm[1]  = get_deptnm

return 1 
end function

public subroutine wf_kif01ot0_chk (string ar_no, string gub);//사업자번호, 주민번호로 거래처 정보 가져오기

string scvnas, sownam, sno, suptae, sjongk, saddr1, saddr2, sdate
  
IF gub = '1' THEN //사업자번호  
   SELECT MAX(BUYDT)
	  INTO :sdate
	  FROM KIF01OT0 
	 WHERE ( SABU = :gs_sabu ) AND  
			 ( SANO = :ar_no )   ;
	
	if not (sdate = '' or isnull(sdate)) then 
	
		SELECT CVNAS,   OWNAM,   RESIDENT, UPTAE,   JONGK,   ADDR1,   ADDR2  
		  INTO :sCVNAS, :sOWNAM, :sNO,     :sUPTAE, :sJONGK, :sADDR1, :sADDR2  
		  FROM KIF01OT0 
		 WHERE ( SABU  = :gs_sabu ) AND  
		       ( BUYDT = :sdate ) AND 
			  	 ( SANO  = :ar_no )   ;

      dw_insert.setitem(1, 'cvnas', scvnas)
      dw_insert.setitem(1, 'ownam', sownam)
      dw_insert.setitem(1, 'uptae', suptae)
      dw_insert.setitem(1, 'jongk', sjongk)
      dw_insert.setitem(1, 'addr1', saddr1)
      dw_insert.setitem(1, 'addr1', scvnas)
      dw_insert.setitem(1, 'resident', sno)
	end if
ELSE

   SELECT MAX(BUYDT)
	  INTO :sdate
	  FROM KIF01OT0 
	 WHERE ( SABU = :gs_sabu ) AND  
			 ( RESIDENT = :ar_no )   ;
	
	if not (sdate = '' or isnull(sdate)) then 
	
		SELECT CVNAS,   OWNAM,   SANO,  UPTAE,   JONGK,   ADDR1,   ADDR2  
		  INTO :sCVNAS, :sOWNAM, :sNO,  :sUPTAE, :sJONGK, :sADDR1, :sADDR2  
		  FROM KIF01OT0 
		 WHERE ( SABU     = :gs_sabu ) AND  
		       ( BUYDT    = :sdate ) AND 
			  	 ( RESIDENT = :ar_no )   ;

      dw_insert.setitem(1, 'cvnas', scvnas)
      dw_insert.setitem(1, 'ownam', sownam)
      dw_insert.setitem(1, 'uptae', suptae)
      dw_insert.setitem(1, 'jongk', sjongk)
      dw_insert.setitem(1, 'addr1', saddr1)
      dw_insert.setitem(1, 'addr1', scvnas)
      dw_insert.setitem(1, 'sano', sno)
	end if
END IF

return

end subroutine

public function integer wf_required_chk ();string sdate, scode, sname, sacc1, sacc2, get_dc, get_sang
long   dseq 
//필수입력항목 체크
if dw_insert.AcceptText() = -1 then return -1

if Isnull(Trim(dw_insert.object.sabu[1])) or Trim(dw_insert.object.sabu[1]) =  "" then
	dw_insert.object.sabu[1] = gs_sabu
end if
if Isnull(Trim(dw_insert.object.buy_dept[1])) or Trim(dw_insert.object.buy_dept[1]) =  "" then
  	f_message_chk(1400,'[매입부서]')
	dw_insert.SetColumn('buy_dept')
   dw_insert.SetFocus()
   return -1
end if
if Isnull(Trim(dw_insert.object.sdept_cd[1])) or Trim(dw_insert.object.sdept_cd[1]) =  "" then
  	f_message_chk(1400,'[원가부서]')
	dw_insert.SetColumn('sdept_cd')
   dw_insert.SetFocus()
   return -1
end if
if Isnull(dw_insert.object.jasa_cd[1]) or dw_insert.object.jasa_cd[1] = '' then
  	f_message_chk(1400,'[자사거래처]')
	dw_insert.SetColumn('jasa_cd')
   dw_insert.SetFocus()
   return -1
end if
if Isnull(dw_insert.object.tax_no[1]) or dw_insert.object.tax_no[1] = '' then
  	f_message_chk(1400,'[부가세구분]')
	dw_insert.SetColumn('tax_no')
   dw_insert.SetFocus()
   return -1
end if

if Isnull(dw_insert.object.elegbn[1]) or dw_insert.object.elegbn[1] = '' then
  	f_message_chk(1400,'[세금계산서구분]')
	dw_insert.SetColumn('elegbn')
   dw_insert.SetFocus()
   return -1
end if

sdate = Trim(dw_insert.object.buydt[1])
if Isnull(sdate) or Trim(sdate) =  "" then
  	f_message_chk(1400,'[계산서발행일자]')
	dw_insert.SetColumn('buydt')
   dw_insert.SetFocus()
   return -1
end if

if (Isnull(dw_insert.object.sano[1]) or TRIM(dw_insert.object.sano[1]) = '') AND &
  	(Isnull(dw_insert.object.resident[1]) or TRIM(dw_insert.object.resident[1]) = '') then
  	f_message_chk(1401,'[사업자번호/주민등록번호]')
	dw_insert.SetColumn('sano')
   dw_insert.SetFocus()
   return -1
end if

if Isnull(dw_insert.object.cvnas[1]) or TRIM(dw_insert.object.cvnas[1]) = '' then
  	f_message_chk(1401,'[거래처명]')
	dw_insert.SetColumn('cvnas')
   dw_insert.SetFocus()
   return -1
end if

if Isnull(dw_insert.object.ownam[1]) or TRIM(dw_insert.object.ownam[1]) = '' then
  	f_message_chk(1401,'[대표자명]')
	dw_insert.SetColumn('ownam')
   dw_insert.SetFocus()
   return -1
end if

if Isnull(dw_insert.object.uptae[1]) or TRIM(dw_insert.object.uptae[1]) = '' then
  	f_message_chk(1401,'[업태]')
	dw_insert.SetColumn('uptae')
   dw_insert.SetFocus()
   return -1
end if

if Isnull(dw_insert.object.jongk[1]) or TRIM(dw_insert.object.jongk[1]) = '' then
  	f_message_chk(1401,'[업종]')
	dw_insert.SetColumn('jongk')
   dw_insert.SetFocus()
   return -1
end if

if Isnull(dw_insert.object.addr1[1]) or TRIM(dw_insert.object.addr1[1]) = '' then
  	f_message_chk(1401,'[주소1]')
	dw_insert.SetColumn('addr1')
   dw_insert.SetFocus()
   return -1
end if

scode = dw_insert.object.saccod[1]
if Isnull(scode) or TRIM(scode) = '' then
  	f_message_chk(1400,'[상대계정]')
	dw_insert.SetColumn('saccod')
   dw_insert.SetFocus()
   return -1
else
   sacc1 = left(scode, 5)
   sacc2 = mid(scode, 6, 2)
	
   SELECT DC_GU,   SANG_GU  
	  INTO :get_dc, :get_sang
	  FROM KFZ01OM0  
	 WHERE ACC1_CD = :sacc1 AND  ACC2_CD =  :sacc2  ;
   
	//가지급, 선급금 구분은 차대구분이 차변이고 상계구분이 'Y' 인 자료 
	//OPT가  X => 전부입력금지, N => 외상매입금만, Y => 반제전표만 
	IF SQLCA.SQLCODE <> 0 THEN 
		MessageBox('확 인', '계정과목을 확인하세요')
		dw_insert.SetColumn('saccod')
		dw_insert.SetFocus()
		return -1
	ELSE	
		IF get_dc = '1' and get_sang = 'Y' THEN 
			if Isnull(dw_insert.object.crossno[1]) or TRIM(dw_insert.object.crossno[1]) = '' then
				f_message_chk(1400,'[반제전표]')
				dw_insert.SetColumn('crossno')
				dw_insert.SetFocus()
				return -1
			end if
		END IF	
	END IF
end if

if Trim(dw_insert.object.vouc_gu[1]) = "3" then
	if Isnull(Trim(dw_insert.object.vouc_gu[1])) or Trim(dw_insert.object.vouc_gu[1]) =  "" then
		f_message_chk(1400,'[영세율증빙구분]')
		dw_insert.SetColumn('vouc_gu')
		dw_insert.SetFocus()
		return -1
	end if		
	if Isnull(Trim(dw_insert.object.lcno[1])) or Trim(dw_insert.object.lcno[1]) =  "" then
  	   f_message_chk(1400,'[L/C NO]')
	   dw_insert.SetColumn('lcno')
      dw_insert.SetFocus()
      return -1
   end if	
	if Isnull(dw_insert.object.for_amt[1]) or dw_insert.object.for_amt[1] < 0 then
  	   f_message_chk(1400,'[외화금액]')
	   dw_insert.SetColumn('for_amt')
      dw_insert.SetFocus()
      return -1
   end if	
	if Isnull(dw_insert.object.exc_rate[1]) or dw_insert.object.exc_rate[1] < 0 then
  	   f_message_chk(1400,'[적용환율]')
	   dw_insert.SetColumn('exc_rate')
      dw_insert.SetFocus()
      return -1
   end if	
end if

if Isnull(dw_insert.object.buyno[1]) or dw_insert.object.buyno[1] < 1 then
	
	dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'M1')
	if dSeq = -1 then 
		rollback;
		f_message_chk(51, '')
		return -1
	elseif dseq > 1000 then 
		rollback;
		f_message_chk(51, '[자릿수 초과]')
		return -1
	end if
	Commit;
	
	dw_insert.object.buyno[1] = dseq
end if

return 1
end function

public function integer wf_accod_chk (string gub);////////////////////////////////////////////////////////////////////////////////////////
// 
//   참조코드에 상대계정으로 반제전표, 예정결제일등등 셋팅하기
//
////////////////////////////////////////////////////////////////////////////////////////
string  s_cod, s_nam1, snull, sacc1, sacc2, get_dc, get_sang, sopt 	

if gub = '1' then   //초기화시키기
	dw_insert.Object.bt_crossno.Visible= False
//   dw_insert.Object.crossno.Background.Color= 79741120
	
	dw_insert.SetTabOrder("gyul_date", 160)
	dw_insert.SetTabOrder("gyul_method", 170)
	dw_insert.SetTabOrder("send_bank", 180)
	dw_insert.SetTabOrder("send_dep", 190)
	dw_insert.SetTabOrder("send_nm", 200)

//	dw_insert.Object.gyul_date.Background.Color= 16777215
//	dw_insert.Object.gyul_method.Background.Color= 16777215
//	dw_insert.Object.send_bank.Background.Color= 16777215
//	dw_insert.Object.send_dep.Background.Color= 16777215
//	dw_insert.Object.send_nm.Background.Color= 16777215
else  //조회시
	if dw_insert.accepttext() = -1 then return 1
	
	setnull(snull)
	
	s_cod = dw_insert.GetItemString(1, 'saccod')
	
   sacc1 = left(s_cod, 5)
   sacc2 = mid(s_cod, 6, 2)
	
   SELECT DC_GU,   SANG_GU  
	  INTO :get_dc, :get_sang
	  FROM KFZ01OM0  
	 WHERE ACC1_CD = :sacc1 AND  ACC2_CD =  :sacc2  ;
   
	//가지급, 선급금 구분은 차대구분이 차변이고 상계구분이 'Y' 인 자료 
	//OPT가  X => 전부입력금지, N => 외상매입금만, Y => 반제전표만 
	IF SQLCA.SQLCODE <> 0 THEN 
		sOpt = 'X'  
	ELSE	
		SELECT RFGUB     INTO :s_nam1     FROM REFFPF  
		 WHERE SABU = '1' AND RFCOD = '1C' AND RFGUB <> '00' AND RFNA2 = :s_cod ;
		 
		IF SQLCA.SQLCODE <> 0 THEN 
			sOpt = 'X'  
		ELSE
			IF get_dc = '1' and get_sang = 'Y' THEN 
				sOpt = 'Y'
			ELSE
				sOpt = 'N'
			END IF	
		END IF	
	END IF

	IF sOpt = 'N' THEN 
//		dw_insert.Object.crossno.Background.Color= 79741120
		dw_insert.Object.bt_crossno.Visible= False
		
		dw_insert.SetTabOrder("gyul_date", 160)
		dw_insert.SetTabOrder("gyul_method", 170)
		dw_insert.SetTabOrder("send_bank", 180)
		dw_insert.SetTabOrder("send_dep", 190)
		dw_insert.SetTabOrder("send_nm", 200)
	
//		dw_insert.Object.gyul_date.Background.Color= 16777215
//		dw_insert.Object.gyul_method.Background.Color= 16777215
//		dw_insert.Object.send_bank.Background.Color= 16777215
//		dw_insert.Object.send_dep.Background.Color= 16777215
//		dw_insert.Object.send_nm.Background.Color= 16777215
	ELSEIF sOpt = 'Y' THEN 	
//		dw_insert.Object.crossno.Background.Color= 12639424
		dw_insert.Object.bt_crossno.Visible= True
		
		dw_insert.SetTabOrder("gyul_date", 0)
		dw_insert.SetTabOrder("gyul_method", 0)
		dw_insert.SetTabOrder("send_bank", 0)
		dw_insert.SetTabOrder("send_dep", 0)
		dw_insert.SetTabOrder("send_nm", 0)
	
//		dw_insert.Object.gyul_date.Background.Color= 79741120
//		dw_insert.Object.gyul_method.Background.Color= 79741120
//		dw_insert.Object.send_bank.Background.Color= 79741120
//		dw_insert.Object.send_dep.Background.Color= 79741120
//		dw_insert.Object.send_nm.Background.Color= 79741120
	ELSE
		MessageBox("확 인","상대계정에 참조코드를 확인하세요!")
		
		dw_insert.Object.bt_crossno.Visible= False
//		dw_insert.Object.crossno.Background.Color= 79741120
		
		dw_insert.SetTabOrder("gyul_date", 0)
		dw_insert.SetTabOrder("gyul_method", 0)
		dw_insert.SetTabOrder("send_bank", 0)
		dw_insert.SetTabOrder("send_dep", 0)
		dw_insert.SetTabOrder("send_nm", 0)
	
//		dw_insert.Object.gyul_date.Background.Color= 79741120
//		dw_insert.Object.gyul_method.Background.Color= 79741120
//		dw_insert.Object.send_bank.Background.Color= 79741120
//		dw_insert.Object.send_dep.Background.Color= 79741120
//		dw_insert.Object.send_nm.Background.Color= 79741120
      return 1		
	END IF
		
end if

return 1
end function

on w_imt_05000.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.pb_3
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
this.Control[iCurrent+10]=this.rr_3
this.Control[iCurrent+11]=this.rr_4
end on

on w_imt_05000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_1.ReSet()
dw_list.ReSet()
dw_insert.ReSet()

dw_1.InsertRow(0)
dw_1.SetFocus()

// MRO 관리부서 여부
Int nCnt
select count(*) into :ncnt from vndmst a
 where a.cvgu = '5' and a.soguan = 'Z' and a.ipjogun = :gs_saupj 
   and a.deptcode = ( select b.deptcode from p1_master b where b.empno = :gs_empno);
If nCnt > 0 Then
	is_magubn = 'Z'	// Mro
else
	//is_magubn = '2'	// 구매
	is_magubn = '9'	//24.10.23_SBH_구매+외주
End If

// MRO 부서인 경우 설정
dw_1.SetItem(1, 'gub2', is_magubn)
If is_magubn = 'Z' Then
	dw_1.Object.gub2.protect = 1
Else
	dw_1.Object.gub2.protect = 0
End If

/* 부가 사업장 */
f_mod_saupj(dw_1,'saupj')

end event

type dw_insert from w_inherite`dw_insert within w_imt_05000
integer x = 1326
integer y = 204
integer width = 3182
integer height = 2076
integer taborder = 40
string dataobject = "d_imt_05000_03"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "buy_dept"	THEN		
	open(w_vndmst_4_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	this.SetItem(1, "buy_dept", gs_code)
	this.SetItem(1, "deptnm", gs_codename)
ELSEIF	this.getcolumnname() = "sdept_cd"	THEN		
	open(w_cia02m_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	this.SetItem(1, "sdept_cd", gs_code)
	this.SetItem(1, "wdeptnm", gs_codename)
ELSEIF	this.getcolumnname() = "lcno"	THEN		
	Open(w_lc_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	THIS.SetItem(1, "lcno",	gs_code)
END IF


end event

event dw_insert::itemchanged;String  s_cod, s_nam1, s_nam2, snull, sacc1, sacc2, get_dc, get_sang, sOpt
Integer i_rtn

setnull(snull)

if (this.GetColumnName() = "buy_dept") Then
   s_cod = Trim(this.GetText())
	i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2) 
	this.object.buy_dept[1] = s_cod
	this.object.deptnm[1] = s_nam1
	this.object.sdept_cd[1] = s_cod
	this.object.wdeptnm[1] = s_nam1
	return i_rtn
elseif (this.GetColumnName() = "sdept_cd") Then
   s_cod = Trim(this.GetText())
	
	if s_cod = '' or isnull(s_cod) then return 
	
   SELECT COST_NM  
     INTO :s_nam1  
     FROM CIA02M  
    WHERE COST_CD = :s_cod AND USEGBN = '1' ;

   IF SQLCA.SQLCODE = 0 THEN 
		this.object.wdeptnm[1] = s_nam1
	ELSE
      F_message_chk(33, "[원가부서]")
		this.object.sdept_cd[1] = snull
		RETURN 1
	END IF	
elseif this.GetColumnName() = "buydt" Then
	s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then
		return
	end if	
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[계산서발행일자]")
		this.object.buydt[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "gyul_date" Then
	s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then
		return
	end if	
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[예정결제일]")
		this.object.gyul_date[1] = ""
		return 1
	end if
ELSEIF	this.getcolumnname() = "sano"	THEN
	string	sGubun, SaupNo, DupCheck, DupName, scvcod
	SaupNo = trim(this.GETTEXT())				
	IF IsNull(saupno) OR saupno ="" THEN RETURN 
	scvcod = this.getitemstring(1, "cvcod")
	
   if scvcod = "" or isnull(scvcod) then 
		SELECT "VNDMST"."CVCOD",   "VNDMST"."CVNAS"  
		  INTO :DupCheck,   :DupName  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."SANO" = :SaupNo   ;
   else
		SELECT "VNDMST"."CVCOD",   "VNDMST"."CVNAS"  
		  INTO :DupCheck,   :DupName  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."SANO" = :SaupNo AND "VNDMST"."CVCOD" <> :scvcod  ;
   end if
	
	IF sqlca.sqlcode = 0 THEN
		IF messagebox("사업자등록번호 확인", "등록된 사업자등록번호입니다.~n~r" 	&
						+ "거래처번호 : " + DupCheck + "~n~r거래처   명 : " + DupName + "~n~n" + &
						  "계속하시겠습니까?",Question!,YesNo!, 2) = 2 then
			this.setitem(1, "sano", sNull)
			return 1
		END IF
	END IF
	
	IF f_vendcode_check(saupno) = False THEN
		MessageBox("확 인","사업자등록번호가 틀렸습니다. 사업자번호를 확인하세요!") 
		this.SetItem(1,"sano",snull)
		Return 1
	END IF
	//사업자 번호로 이전에 매입세금계산서에서 참조하여 셋팅
	wf_kif01ot0_chk(saupno, '1')
	
ELSEIF this.GetColumnName() = "resident" THEN
	s_cod = trim(this.GETTEXT())				
	
	IF s_cod = "" OR IsNull(s_cod) THEN RETURN
	
	IF f_vendcode_check(s_cod) = False THEN
		MessageBox("확 인","주민등록번호가 틀렸습니다. 주민등록번호를 확인하세요!")
		this.SetItem(1,"resident",snull)
		Return 1
	END IF
	//주민번호로 이전에 매입세금계산서에서 참조하여 셋팅
	wf_kif01ot0_chk(s_cod, '2')
ELSEIF this.GetColumnName() = "saccod" THEN
	s_cod = this.GETTEXT()

   this.SetItem(1, 'crossno', snull)
	this.SetItem(1, 'gyul_date', snull)
	this.SetItem(1, 'gyul_method', snull)
	this.SetItem(1, 'send_bank', snull)
	this.SetItem(1, 'send_dep', snull)
	this.SetItem(1, 'send_nm', snull)

   sacc1 = left(s_cod, 5)
   sacc2 = mid(s_cod, 6, 2)
	
   SELECT DC_GU,   SANG_GU  
	  INTO :get_dc, :get_sang
	  FROM KFZ01OM0  
	 WHERE ACC1_CD = :sacc1 AND  ACC2_CD =  :sacc2  ;
   
	//가지급, 선급금 구분은 차대구분이 차변이고 상계구분이 'Y' 인 자료 
	//OPT가  X => 전부입력금지, N => 외상매입금, 미지급금만, Y => 반제전표만 
	IF SQLCA.SQLCODE <> 0 THEN 
		sOpt = 'X'  
	ELSE	
		SELECT RFGUB     INTO :s_nam1     FROM REFFPF  
		 WHERE SABU = '1' AND RFCOD = '1C' AND RFGUB <> '00' AND RFNA2 = :s_cod ;

		IF SQLCA.SQLCODE <> 0 THEN 
			sOpt = 'X'  
	   ELSE		
			IF get_dc = '1' and get_sang = 'Y' THEN 
				sOpt = 'Y'
			ELSE
				sOpt = 'N'
			END IF
		END IF
	END IF

	IF sOpt = 'N' THEN 
//		this.Object.crossno.Background.Color= 79741120
		this.Object.bt_crossno.Visible= False
		
		this.SetTabOrder("gyul_date", 160)
		this.SetTabOrder("gyul_method", 170)
		this.SetTabOrder("send_bank", 180)
		this.SetTabOrder("send_dep", 190)
		this.SetTabOrder("send_nm", 200)
	
//		this.Object.gyul_date.Background.Color= 16777215
//		this.Object.gyul_method.Background.Color= 16777215
//		this.Object.send_bank.Background.Color= 16777215
//		this.Object.send_dep.Background.Color= 16777215
//		this.Object.send_nm.Background.Color= 16777215
		
		string svndcd, get_cvbanm, get_cvdpno, get_dpname
		svndcd = this.getitemstring(1, 'cvcod')
		
		SELECT "VNDMST"."CVBANK", "VNDMST"."CVDPNO", "VNDMST"."DPNAME"  
 		  INTO :get_cvbanm,       :get_cvdpno,     	:get_dpname  
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :svndcd   ;

		this.SetItem(1, 'send_bank', get_cvbanm)
		this.SetItem(1, 'send_dep', get_cvdpno)
		this.SetItem(1, 'send_nm', get_dpname)
		
	ELSEIF sOpt = 'Y' THEN 	
//		this.Object.crossno.Background.Color= 12639424
		this.Object.bt_crossno.Visible= True
		
		this.SetTabOrder("gyul_date", 0)
		this.SetTabOrder("gyul_method", 0)
		this.SetTabOrder("send_bank", 0)
		this.SetTabOrder("send_dep", 0)
		this.SetTabOrder("send_nm", 0)
	
//		this.Object.gyul_date.Background.Color= 79741120
//		this.Object.gyul_method.Background.Color= 79741120
//		this.Object.send_bank.Background.Color= 79741120
//		this.Object.send_dep.Background.Color= 79741120
//		this.Object.send_nm.Background.Color= 79741120
	ELSE
		MessageBox("확 인","상대계정에 참조코드를 확인하세요!")
		this.SetItem(1, 'saccod', snull)
		
		this.Object.bt_crossno.Visible= False
//		this.Object.crossno.Background.Color= 79741120
		
		this.SetTabOrder("gyul_date", 0)
		this.SetTabOrder("gyul_method", 0)
		this.SetTabOrder("send_bank", 0)
		this.SetTabOrder("send_dep", 0)
		this.SetTabOrder("send_nm", 0)
	
//		this.Object.gyul_date.Background.Color= 79741120
//		this.Object.gyul_method.Background.Color= 79741120
//		this.Object.send_bank.Background.Color= 79741120
//		this.Object.send_dep.Background.Color= 79741120
//		this.Object.send_nm.Background.Color= 79741120
      return 1		
	END IF
ELSEIF this.GetColumnName() = "lcno" THEN
	s_Cod  = trim(this.gettext())

	if s_cod = '' or isnull(s_cod) then return 

	SELECT "POLCHD"."POLCNO"  
     INTO :s_Nam1  
     FROM "POLCHD"  
    WHERE ( "POLCHD"."SABU" = :gs_sabu ) AND  
          ( "POLCHD"."POLCNO" = :s_cod )   ;

	IF sqlca.sqlcode <> 0 THEN
		MessageBox("확 인","L/C No을 확인하세요!")
		this.SetItem(1, 'lcno', snull)
		return 1
   END IF	
END IF


end event

event dw_insert::buttonclicking;string  get_gbn, sacc_cd1, sacc_cd2
decimal damt

//조회조건 - 전표종료일, 계정과목, 매입부서
//           (gs_gubun, gs_codename, gs_code)
// 먼저 계정과목으로 계정과목 마스타를 읽어서 인명거래처를 체크하여 부서를 조회할 것인지
// 거래처를 조회할 것인지를 선택한다.(KFZ01OM0 에 GBN1 거래처면 '1', 부서는 '3')
//
gs_codename = this.getitemstring(1, 'saccod')

if gs_codename = '' or isnull(gs_codename) then 
	messagebox("확 인", "상대계정을 먼저 선택하세요!")
	return 
end if	

sacc_cd1 = left(gs_codename, 5)
sacc_cd2 = mid(gs_codename, 6, 2)

SELECT "KFZ01OM0"."GBN1"  
  INTO :get_gbn  
  FROM "KFZ01OM0"  
 WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc_cd1 ) AND  
		 ( "KFZ01OM0"."ACC2_CD" = :sacc_cd2 )   ;

IF SQLCA.SQLCODE <> 0 THEN 
	MESSAGEBOX("확 인", "참조코드에 계정과목을 확인하세요!")
   Return 
END IF	

IF get_gbn = '1' THEN  			//거래처를 가져오고
	gs_code     = this.getitemstring(1, 'cvcod')
ELSEIF get_gbn = '3' THEN  	//부서를 가져오고
	gs_code     = this.getitemstring(1, 'buy_dept')
ELSE 
	messagebox("확 인", "계정과목에 상대 거래처를 확인하세요!")
	return 
END IF

gs_gubun    = this.getitemstring(1, 'maeddat')

//총금액(부가세 + 공급가액) <= 미반제금액 인 자료만 선택
damt        = this.getitemdecimal(1, 'tot_amt')

if gs_code = '' or isnull(gs_code) then 
	if get_gbn = '1' then 
		messagebox("확 인", "거래처를 먼저 입력하세요!")
	else
		messagebox("확 인", "매입부서를 먼저 선택하세요!")
	end if
	return 
end if	

openwithparm(w_kfz19ot0_popup, damt)

if gs_code = '' or isnull(gs_code) then return 

this.setitem(1, 'crossno', gs_code)


end event

type p_delrow from w_inherite`p_delrow within w_imt_05000
boolean visible = false
integer x = 3424
integer y = 2684
end type

type p_addrow from w_inherite`p_addrow within w_imt_05000
boolean visible = false
integer x = 3227
integer y = 2668
end type

type p_search from w_inherite`p_search within w_imt_05000
boolean visible = false
integer x = 2185
integer y = 2636
end type

type p_ins from w_inherite`p_ins within w_imt_05000
boolean visible = false
integer x = 2487
integer y = 2644
end type

type p_exit from w_inherite`p_exit within w_imt_05000
integer x = 4421
end type

type p_can from w_inherite`p_can within w_imt_05000
integer x = 4247
end type

event p_can::clicked;call super::clicked;dw_list.ReSet()

dw_1.SetReDraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.SetFocus()
dw_1.SetReDraw(True)

dw_Insert.SetReDraw(False)
dw_Insert.ReSet()
dw_insert.InsertRow(0)
dw_Insert.SetReDraw(True)

ib_any_typing = False //입력필드 변경여부 No

wf_accod_chk('1')  //초기화
dw_insert.SetTabOrder("buydt", 50)

end event

type p_print from w_inherite`p_print within w_imt_05000
boolean visible = false
integer x = 2843
integer y = 2508
end type

type p_inq from w_inherite`p_inq within w_imt_05000
integer x = 3726
end type

event p_inq::clicked;call super::clicked;String  yymm, ssaupj, strans, smagub
long    seq, tseq

if dw_1.AcceptText() = -1 then return 

yymm   = Trim(dw_1.object.yymm[1])
ssaupj = dw_1.object.saupj[1]
strans = dw_1.object.gub[1]
smagub = dw_1.object.gub2[1]
seq = dw_1.object.seq[1]

IF IsNull(yymm) or yymm = ''	THEN
	f_message_chk(30, "[마감년월]")
	dw_1.SetColumn("yymm")
	dw_1.SetFocus()
	return
END IF

IF IsNull(seq) or seq = 0 THEN 
	seq = 0 
	tseq = 999999
else
	tseq = seq
END IF

if rb_1.checked then 
	dw_list.SetSort('cvcod a')
	dw_list.Sort()
else
	dw_list.SetSort('cvnas2 a')
	dw_list.Sort()
end if

IF strans = 'Y' then 
	dw_list.setfilter("transyn = '전송'")
ELSEIF strans = 'N' then 
	dw_list.setfilter("transyn = '미전송'")
ELSE	
	dw_list.setfilter("")
END IF
dw_list.filter()

if dw_list.Retrieve(gs_sabu, yymm, seq, tseq, ssaupj, smagub) < 1 then
	f_message_chk(50, "[거래처 마감자료]")
	return
end if	

dw_Insert.SetReDraw(False)
dw_Insert.ReSet()
dw_insert.InsertRow(0)
dw_Insert.SetReDraw(True)

ib_any_typing = False //입력필드 변경여부 No


end event

type p_del from w_inherite`p_del within w_imt_05000
integer x = 4073
end type

event p_del::clicked;call super::clicked;Boolean fg
Long    crow, lreturnrow
string  scvcod

if f_msg_delete() = -1 then return

scvcod = dw_insert.getitemstring(1, 'cvcod')

dw_insert.SetRedraw(False)
dw_insert.DeleteRow(0)
IF dw_insert.Update() > 0	 THEN
   COMMIT;
   w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"
ELSE
   ROLLBACK;
	f_message_chk(31,"[삭제실패]")
   w_mdi_frame.sle_msg.Text = "삭제작업 실패!"
	dw_insert.SetRedraw(True)
   Return
end if

lReturnRow = dw_list.Find("cvcod = '"+scvcod+"' ", 1, dw_list.RowCount())

dw_list.setitem(lReturnRow, 'transyn', '미전송')

dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

ib_any_typing = False //입력필드 변경여부 No



end event

type p_mod from w_inherite`p_mod within w_imt_05000
integer x = 3899
end type

event p_mod::clicked;call super::clicked;string scvcod, sBuyDt
long   lreturnrow, lBuyNo, lcnt

if f_msg_update() = -1 then return

if wf_required_chk() = -1 then return //필수입력항목 체크 

IF dw_insert.Update() > 0 THEN		
	COMMIT;
	w_mdi_frame.sle_msg.Text = "저장 되었습니다!"
	
	/* 작성자 저장 */
	sBuyDt = dw_insert.GetItemString(1, 'buydt')
	lBuyNo = dw_insert.GetItemNumber(1, 'buyno')
	SELECT COUNT(*) INTO :lcnt FROM KIF01OT0_EMP WHERE SABU = :gs_sabu AND BUYDT = :sBuydt AND BUYNO = :lBuyno;
	If lCnt = 0 Then
		INSERT INTO KIF01OT0_EMP ( SABU, BUYDT, BUYNO, EMPNO)
		 VALUES ( :gs_sabu, :sBuydt, :lBuyno, :gs_empno);
		COMMIT;
	End If
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	w_mdi_frame.sle_msg.Text = "저장작업 실패!"
	return 
END IF

scvcod = dw_insert.getitemstring(1, 'cvcod')

lReturnRow = dw_list.Find("cvcod = '"+scvcod+"' ", 1, dw_list.RowCount())

dw_list.setitem(lReturnRow, 'transyn', '전송')

ib_any_typing = False //입력필드 변경여부 No


end event

type cb_exit from w_inherite`cb_exit within w_imt_05000
integer x = 3735
integer y = 2512
end type

type cb_mod from w_inherite`cb_mod within w_imt_05000
integer x = 2693
integer y = 2512
integer height = 312
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;string scvcod
long   lreturnrow

if f_msg_update() = -1 then return

if wf_required_chk() = -1 then return //필수입력항목 체크 

IF dw_insert.Update() > 0 THEN		
	COMMIT;
	sle_msg.Text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	sle_msg.Text = "저장작업 실패!"
	return 
END IF

scvcod = dw_insert.getitemstring(1, 'cvcod')

lReturnRow = dw_list.Find("cvcod = '"+scvcod+"' ", 1, dw_list.RowCount())

dw_list.setitem(lReturnRow, 'transyn', '전송')

ib_any_typing = False //입력필드 변경여부 No


end event

type cb_ins from w_inherite`cb_ins within w_imt_05000
integer x = 1298
integer y = 2524
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_imt_05000
integer x = 3040
integer y = 2512
integer taborder = 60
end type

type cb_inq from w_inherite`cb_inq within w_imt_05000
integer x = 2286
integer y = 2504
integer taborder = 20
end type

type cb_print from w_inherite`cb_print within w_imt_05000
integer x = 1879
integer y = 2508
end type

type st_1 from w_inherite`st_1 within w_imt_05000
end type

type cb_can from w_inherite`cb_can within w_imt_05000
integer x = 3387
integer y = 2512
end type

type cb_search from w_inherite`cb_search within w_imt_05000
integer x = 1307
integer y = 2516
integer width = 443
boolean enabled = false
string text = ""
end type





type gb_10 from w_inherite`gb_10 within w_imt_05000
integer x = 5
integer y = 2484
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_05000
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_05000
end type

type dw_list from u_key_enter within w_imt_05000
event ue_key pbm_dwnkey
integer x = 91
integer y = 876
integer width = 1175
integer height = 1404
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_imt_05000_02"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;String sabu, mayymm, cvcod, deptno, deptnm
integer mayyseq, i_no
Real    amt

w_mdi_frame.sle_msg.text =""

this.SelectRow(0,false)
If row <=0 Then Return
this.SelectRow(row,true)

/*
sabu = Trim(this.object.sabu[row])
mayymm = Trim(this.object.mayymm[row])
mayyseq = this.object.mayysq[row]
cvcod = Trim(this.object.cvcod[row])
*/
String ls_get[]
LongLong   ll_Get[]
ls_get[1]  = This.GetItemString(row, 'sabu'    )
ls_get[2]  = This.GetItemString(row, 'mayymm'  )
ll_get[1]  = This.GetItemNumber(row, 'mayysq'  )
ls_get[3]  = This.GetItemString(row, 'cvcod'   )
ls_get[4]  = This.GetItemString(row, 'cvnas2'  )
ls_get[5]  = This.GetItemString(row, 'mastdat' )
ls_get[6]  = This.GetItemString(row, 'maeddat' )
ll_get[2]  = This.GetItemNumber(row, 'maamt'   )
ll_get[3]  = This.GetItemNumber(row, 'mavat'   )
ll_get[4]  = This.GetItemNumber(row, 'ipamt'   )
ll_get[5]  = This.GetItemNumber(row, 'gongamt' )
ls_get[7]  = This.GetItemString(row, 'sano'    )
ls_get[8]  = This.GetItemString(row, 'cvnas'   )
ls_get[9]  = This.GetItemString(row, 'ownam'   )
ls_get[10] = This.GetItemString(row, 'resident')
ls_get[11] = This.GetItemString(row, 'uptae'   )
ls_get[12] = This.GetItemString(row, 'jongk'   )
ls_get[13] = This.GetItemString(row, 'addr1'   )
ls_get[14] = This.GetItemString(row, 'addr2'   )
ls_get[15] = This.GetItemString(row, 'cvgu'    )
ls_get[16] = This.GetItemString(row, 'saupj'   )
ls_get[17] = This.GetItemString(row, 'pocurr'  )
ls_get[18] = This.GetItemString(row, 'magubn'  )
ls_get[19] = This.GetItemString(row, 'polcno'  )
ll_get[6]  = This.GetItemNumber(row, 'pwaiamt' )
ll_get[7]  = This.GetItemNumber(row, 'prate'   )

dw_insert.SetRedraw(False)
//if dw_insert.Retrieve(sabu, mayymm, mayyseq, cvcod) <= 0 then
If dw_insert.Retrieve(ls_get[1], ls_get[2], long(ll_get[1]), ls_get[3]) < 1 Then
   MessageBox("신규 생성","신규로 생성합니다!")
	dw_insert.InsertRow(0)
		dw_insert.SetItem(1, 'sabu', ls_get[1])
	dw_insert.SetItem(1, 'mayymm', ls_get[2])
	dw_insert.SetItem(1, 'mayyseq', ll_get[1])
	dw_insert.SetItem(1, 'cvcod', ls_get[3])
	dw_insert.SetItem(1, 'cvnas2', ls_get[4])
	dw_insert.SetItem(1, 'mastdat', ls_get[5])
	dw_insert.SetItem(1, 'maeddat', ls_get[6])
	dw_insert.SetItem(1, 'gon_amt', ll_get[2])
	dw_insert.SetItem(1, 'vat_amt', ll_get[3])
	dw_insert.SetItem(1, 'ipamt', ll_get[4])
	dw_insert.SetItem(1, 'gongamt', ll_get[5])
	
	dw_insert.SetItem(1, 'sano', ls_get[7])
	dw_insert.SetItem(1, 'cvnas', ls_get[8])
	dw_insert.SetItem(1, 'ownam', ls_get[9])
	dw_insert.SetItem(1, 'resident', ls_get[10])
	dw_insert.SetItem(1, 'uptae', ls_get[11])
	dw_insert.SetItem(1, 'jongk', ls_get[12])
	dw_insert.SetItem(1, 'addr1', ls_get[13])
	dw_insert.SetItem(1, 'addr2', ls_get[14])
	dw_insert.SetItem(1, 'cvgu', ls_get[15])
	dw_insert.SetItem(1, 'saupj', ls_get[16])
	dw_insert.SetItem(1, 'y_curr', ls_get[17])

	if ls_get[18] = "1" or ls_get[18] = "9" or ls_get[18] = "Z" or ls_get[18] = "2" then //외주, 구매
		dw_insert.SetItem(1, 'tax_no', '11')
		dw_insert.SetItem(1, 'lcno', '')
      		dw_insert.SetItem(1, 'for_amt', 0)
		dw_insert.SetItem(1, 'exc_rate', 0)
   	else  //LOCAL
		dw_insert.SetItem(1, 'tax_no', '13')
		dw_insert.SetItem(1, 'for_amt', ll_get[6])
		dw_insert.SetItem(1, 'exc_rate', ll_get[7])
		dw_insert.SetItem(1, 'lcno', ls_get[19])
	end if
	
	dw_insert.SetItem(1, 'dhgu', ls_get[18])
	
	//매입부서 setting
	if ls_get[18] = "1" then  //시스템환경설정(Y,11,1)=>외주
	   i_no = 11
   elseIF ls_get[18] = "Z" Then //시스템환경설정(Y,10,1)=>MRO
		i_no = 10
   elseIF ls_get[18] = "2" OR  &
		    ls_get[18] = "9"  then //시스템환경설정(Y,12,1)=>구매
	   i_no = 12
   elseIF ls_get[18] = "3" then //시스템환경설정(Y,12,1)=>LOCAL
	   i_no = 12		
   end if
	
//	// 사업장별 마감부서 가져온다
//	select s.dataname, v.cvnas2 into :deptno, :deptnm
//	  from syscnfg s, vndmst v
//	 where s.sysgu = 'Y'
//		and s.serial = :i_no
//		and s.lineno = :gs_saupj
//		and s.dataname = v.cvcod (+);
//		
//	if sqlca.sqlcode <> 0 then
//		MessageBox("매입부서 확인", "시스템 환경설정에 매입부서를 확인하세요!")
//	end if	
//	dw_insert.SetItem(1, 'buy_dept', deptno)
//	dw_insert.SetItem(1, 'deptnm', deptnm)
	
	/* 마감부서는 로그인 사원 소속부서로 변경 - 2007.02.22 - 송병호 */
	dw_insert.SetItem(1, 'buy_dept', gs_dept)
	dw_insert.SetItem(1, 'deptnm', f_get_name5('01', gs_dept, '') )

	wf_accod_chk('1')  //초기화

	//원가부서 setting
   wf_wdept_set(sabu, mayymm, mayyseq, cvcod)	
	
	dw_insert.SetTabOrder("buydt", 50)
	
	//신규일 경우 : 삭제버튼 Disabled
	p_mod.Enabled = true
   p_mod.picturename = "C:\erpman\image\저장_up.gif"
   p_del.Enabled = False
   p_del.picturename = "C:\erpman\image\삭제_d.gif"
else
	wf_accod_chk('2') 
	
	dw_insert.SetTabOrder("buydt", 0)
	dw_insert.Object.buydt.Background.Color= 79741120
	
	if IsNull(Trim(dw_insert.object.bal_date[1])) or Trim(dw_insert.object.bal_date[1]) = "" then
      p_mod.Enabled = true
		p_mod.picturename = "C:\erpman\image\저장_up.gif"
		p_del.Enabled = true
		p_del.picturename = "C:\erpman\image\삭제_up.gif"
	else
//		dw_insert.Enabled = false
		p_mod.Enabled = false
		p_mod.picturename = "C:\erpman\image\저장_d.gif"
		p_del.Enabled = false
		p_del.picturename = "C:\erpman\image\삭제_d.gif"
		MessageBox("발행된 전표", "이미 발행된 전표입니다! (변경 불가능)")
	end if	
end if	 
dw_insert.SetRedraw(True)
dw_insert.SetColumn("jasa_cd")
dw_insert.SetFocus()

ib_any_typing = False //입력필드 변경여부 No

end event

type rb_1 from radiobutton within w_imt_05000
integer x = 151
integer y = 772
integer width = 507
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "거래처코드 순"
boolean checked = true
end type

event clicked;dw_list.SetSort('cvcod a')
dw_list.Sort()
end event

type rb_2 from radiobutton within w_imt_05000
integer x = 699
integer y = 772
integer width = 434
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "거래처 순"
end type

event clicked;dw_list.SetSort('cvnas2 a')
dw_list.Sort()
end event

type dw_1 from u_key_enter within w_imt_05000
integer x = 96
integer y = 216
integer width = 1166
integer height = 500
integer taborder = 10
string dataobject = "d_imt_05000_01"
boolean border = false
boolean livescroll = false
end type

event itemerror;call super::itemerror;return 1
end event

event itemchanged;String s_cod
Long   get_max

if this.GetColumnName() = "yymm" then
	s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then
		this.object.seq[1] = 0
		return
	end if
	
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[마감년월]")
		this.object.yymm[1] = ""
		this.object.seq[1] = 0
		return 1
	else
	  SELECT MAX("MAHIST"."MAYYSQ")  
		 INTO :get_max  
		 FROM "MAHIST"  
		WHERE ( "MAHIST"."SABU" = :gs_sabu ) AND  
				( "MAHIST"."MAYYMM" = :s_cod )   ;

		this.object.seq[1] = get_max
	end if
end if


end event

event getfocus;call super::getfocus;dw_list.SetReDraw(False)
dw_list.ReSet()
dw_list.SetReDraw(True)

dw_Insert.SetReDraw(False)
dw_Insert.ReSet()
dw_insert.InsertRow(0)
dw_Insert.SetReDraw(True)

p_mod.Enabled = False
p_mod.picturename = "C:\erpman\image\저장_d.gif"
p_del.Enabled = False
p_del.picturename = "C:\erpman\image\삭제_d.gif"

ib_any_typing = False //입력필드 변경여부 No

end event

event rbuttondown;gi_page = 0
gs_code = is_magubn

open(w_imt_05000_1)

if gs_code = '' or isnull(gs_code) then return 

setitem(1, "yymm", gs_code)
setitem(1, "seq", gi_page)
setitem(1, "saupj", gs_codename2)
setitem(1, "gub2", gs_gubun)

setnull(gs_code)
gi_page = 0

p_inq.TriggerEvent(Clicked!)
end event

type pb_1 from u_pb_cal within w_imt_05000
integer x = 2185
integer y = 576
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_insert.SetColumn('mastdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_insert.GetRow()
If ll_row < 1 Then Return
dw_insert.SetItem(ll_row, 'mastdat', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_05000
integer x = 2674
integer y = 576
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_insert.SetColumn('maeddat')
IF IsNull(gs_code) THEN Return
ll_row = dw_insert.GetRow()
If ll_row < 1 Then Return
dw_insert.SetItem(ll_row, 'maeddat', gs_code)



end event

type pb_3 from u_pb_cal within w_imt_05000
integer x = 2185
integer y = 868
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_insert.SetColumn('buydt')
IF IsNull(gs_code) THEN Return
ll_row = dw_insert.GetRow()
If ll_row < 1 Then Return
dw_insert.SetItem(ll_row, 'buydt', gs_code)



end event

type rr_1 from roundrectangle within w_imt_05000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 82
integer y = 872
integer width = 1193
integer height = 1424
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_imt_05000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 82
integer y = 740
integer width = 1189
integer height = 124
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_imt_05000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 82
integer y = 196
integer width = 1189
integer height = 540
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_imt_05000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1312
integer y = 192
integer width = 3209
integer height = 2104
integer cornerheight = 40
integer cornerwidth = 46
end type

