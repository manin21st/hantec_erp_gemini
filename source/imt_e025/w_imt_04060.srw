$PBExportHeader$w_imt_04060.srw
$PBExportComments$구매결제등록
forward
global type w_imt_04060 from window
end type
type pb_3 from u_pb_cal within w_imt_04060
end type
type pb_2 from u_pb_cal within w_imt_04060
end type
type pb_1 from u_pb_cal within w_imt_04060
end type
type p_2 from uo_picture within w_imt_04060
end type
type p_delrow from uo_picture within w_imt_04060
end type
type p_exit from uo_picture within w_imt_04060
end type
type p_cancel from uo_picture within w_imt_04060
end type
type p_delete from uo_picture within w_imt_04060
end type
type p_save from uo_picture within w_imt_04060
end type
type p_retrieve from uo_picture within w_imt_04060
end type
type dw_detail from datawindow within w_imt_04060
end type
type dw_list from datawindow within w_imt_04060
end type
type rr_1 from roundrectangle within w_imt_04060
end type
end forward

global type w_imt_04060 from window
integer width = 4658
integer height = 2412
boolean titlebar = true
string title = "구매결제 등록"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
pb_3 pb_3
pb_2 pb_2
pb_1 pb_1
p_2 p_2
p_delrow p_delrow
p_exit p_exit
p_cancel p_cancel
p_delete p_delete
p_save p_save
p_retrieve p_retrieve
dw_detail dw_detail
dw_list dw_list
rr_1 rr_1
end type
global w_imt_04060 w_imt_04060

type variables
boolean  ib_any_typing = False
char ic_status

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부
String     isimpno               // 수입비용번호

string     is_saupj              //기본 부가 사업장 - 없으면 b/l l/c에 부가사업장을 사용
end variables

forward prototypes
public subroutine wf_rate (string srdat, string sname, string scode, string gubun)
public function integer wf_delete ()
public function integer wf_create ()
public subroutine wf_query ()
public function integer wf_checkrequiredfield ()
public subroutine wf_new ()
end prototypes

public subroutine wf_rate (string srdat, string sname, string scode, string gubun);// srdat = 환율기준일자(결제일자)
// sname = 통화단위

decimal {4} drate, dusdrat
	
if isnull(srdat) or trim(srdat) = '' then
	srdat = f_today()
end if

drate = 1
dusdrat = 1

// 일일환율 및 대미환산율 검색

dusdrat = sqlca.erp000000090(srdat, sname, 1, '3', '', 'N');	// 대미환산율

if scode = 'Y' then
	drate = sqlca.erp000000090(srdat, sname, 1, '2', '3', 'N');	// local이면 매매기준환율		
else
	drate = sqlca.erp000000090(srdat, sname, 1, '2', '2', 'N');	// direct이면 전신환매도율		
end if	

dw_detail.setitem(1, "gusdrat", dusdrat)
dw_detail.setitem(1, "grate", drate)
end subroutine

public function integer wf_delete ();string  sblno, slcno, ssetno, sbank, scurr, sgyeyn
dec{4}  dkumusd, dkumwon, dwaiamt, dwonamt
long    lrow

sbank   = dw_detail.getitemstring(1, "poopbk")
scurr   = dw_detail.getitemstring(1, "pocurr")
dwaiamt = dw_detail.getitemdecimal(1, "gyeamt")
dwonamt = dw_detail.getitemdecimal(1, "gyewon")
dkumusd = dw_detail.getitemdecimal(1, "kumusd")
dkumwon = dw_detail.getitemdecimal(1, "kumwon")
slcno   = dw_detail.getitemstring(1, "polcno")	
sgyeyn  = dw_detail.getitemstring(1, "gyeyn")	

For Lrow = 1 to dw_list.rowcount() 
	
	slcno    = dw_list.getitemstring(lrow, "polcno")	
	sblno    = dw_list.getitemstring(lrow, "poblno")
	
	// 구매결제내역을 재검색
	Select max(setno) into :ssetno from polcsetdt
	 where sabu = :gs_sabu and poblno = :sblno;
	 
	if sqlca.sqlcode <> 0 then 
		Rollback ;
		Messagebox("결제번호", "결제번호 검색중 오류발생", stopsign!)
		return -1
	end if	 			 
	
	// B/L-HEAD에 결제번호 UPDATE
	update polcblhd
		set taxno = :ssetno
	 where sabu = :gs_sabu and poblno = :sblno;	
	 
	if sqlca.sqlcode <> 0 then
		Rollback ;
		Messagebox("B/L", "결제번호 작성중 오류발생", stopsign!)
		return -1
	end if	 	
	
Next

// 결제금액을 L/C-HEAD에 UPDATE(단 원화L/C인 경우에는 원화를 결제금에 update)
IF scurr <> 'WON' then
	update polchd
		set bilamt = bilamt - :dwaiamt
	 where sabu = :gs_sabu and polcno = :slcno;	
Else
	update polchd
		set bilamt = bilamt - :dwonamt
	 where sabu = :gs_sabu and polcno = :slcno;		
End if
 
if sqlca.sqlcode <> 0 then
	Rollback ;
	Messagebox("구매L/C", "구매L/C 결제금 작성중 오류발생", stopsign!)
	return -1
end if

// 금융사용금액을 수입한도에 update
if sGyeyn = 'N' then  //자기자금결제
	return 1 
elseif sGyeyn = 'Y' then //무역금융결제
	Update pobank
		set blusdamt = nvl(blusdamt, 0) - :dkumusd,
			 blwonamt = nvl(blwonamt, 0) - :dkumwon
	 where sabu = :gs_sabu and bankcd = :sbank;
else
	Update pobank
		set usansamt = nvl(usansamt, 0) - :dkumusd,
			 usanswon = nvl(usanswon, 0) - :dkumwon
	 where sabu = :gs_sabu and bankcd = :sbank;
end if

if sqlca.sqlcode <> 0 then
	Rollback ;
	Messagebox("금융사용", "금융사용 내역 작성중 오류발생", stopsign!)
	return -1
end if 

Return 1

end function

public function integer wf_create ();string  sblno, slcno, ssetno, sjpno, srcadat, scode, scurr, sbank, sSaupj, sGyeyn, schcode
dec{4}  damt, dwaiamt, dwonamt, drate, dkumusd, dkumwon, ndivide, dchamt
long    lrow, lseq, lRowCount
String	ls_inter
dec{4} 	dilrate, dilamt, dilsu

// 결제금 비용코드 검색
SELECT dataname
  INTO :scode
  FROM SYSCNFG
 WHERE SYSGU = 'Y' and SERIAL = '32' and LINENO = '2';
 
if isnull(scode) or trim(scode) = '' then
	scode = '220'
end if

// 참조코드 검색
select rfgub into :scode from reffpf where rfcod = '55' and rfgub = :scode;

if sqlca.sqlcode <> 0  then
	Messagebox("결제금", "결제금 비용코드가 환경설정에 없읍니다", stopsign!)
	return -1
end if

// 타발추심료 비용코드 검색
SELECT dataname
  INTO :schcode
  FROM SYSCNFG
 WHERE SYSGU = 'Y' and SERIAL = '32' and LINENO = '4';
 
if isnull(schcode) or trim(schcode) = '' then
	scode = '118'
end if

// 참조코드 검색
select rfgub into :schcode from reffpf where rfcod = '55' and rfgub = :schcode;

if sqlca.sqlcode <> 0  then
	Messagebox("타발추심료", "타발추심료 비용코드가 환경설정에 없읍니다", stopsign!)
	return -1
end if

// 이자 비용코드 검색
SELECT dataname
  INTO :ls_inter
  FROM SYSCNFG
 WHERE SYSGU = 'Y' and SERIAL = '32' and LINENO = '6';
 
if isnull(ls_inter) or trim(ls_inter) = '' then
	scode = '120'
end if

// 참조코드 검색
select rfgub into :ls_inter from reffpf where rfcod = '55' and rfgub = :ls_inter;

if 	sqlca.sqlcode <> 0  then
	Messagebox("이자비용", "이자비용 비용코드가 환경설정에 없읍니다", stopsign!)
	return -1
end if


ssetno  	= dw_detail.getitemstring(1, "setno")
srcadat 	= dw_detail.getitemstring(1, "rcadat")
scurr   	= dw_detail.getitemstring(1, "pocurr")
sbank   	= dw_detail.getitemstring(1, "poopbk")

sGyeyn  	= dw_detail.getitemstring(1, "gyeyn") //결제구분

drate   	= dw_detail.getitemdecimal(1, "grate")
dwaiamt 	= dw_detail.getitemdecimal(1, "gyeamt")
dwonamt 	= dw_detail.getitemdecimal(1, "gyewon")
dkumusd 	= dw_detail.getitemdecimal(1, "kumusd")
dkumwon = dw_detail.getitemdecimal(1, "kumwon")
dchamt 	= dw_detail.getitemdecimal(1, "biamt1")
slcno   	= dw_detail.getitemstring(1, "polcno")	 

//////////// 환율계산시 필요한 참조코드 값 가져오기 ///////////////////
ndivide = 1
SELECT NVL(TO_NUMBER(RFNA2), 1)
  INTO :nDIVIDE
  FROM REFFPF  
 WHERE SABU  = '1' AND  RFCOD = '10' AND  RFGUB = :scurr  ;
if nDIVIDE = 0 or sqlca.sqlcode <> 0 then nDIVIDE = 1 

drate = truncate(drate / nDIVIDE, 2)

///////////  L/C DETAIL 에서 사업장 가져오기 ///////////////////////
SetNull(sSaupj)
SELECT SAUPJ  
  INTO :sSaupj
  FROM POLCDT  
 WHERE SABU   = :gs_sabu
	AND POLCNO = :sLcno
	AND ROWNUM = 1 ;
	
if sqlca.sqlcode <> 0 then 
	Rollback ;
	Messagebox("확 인", "부가사업장 가져오기 실패", stopsign!) 
	return -1 
end if 
If IsNull( sSaupj ) or Trim( sSaupj ) = '' then
	sSaupj = is_saupj
end if

sjpno = isimpno + '001'

// 수입비용 명세서 작성 - 물대
INSERT INTO "IMPEXP"  
		( "SABU",              "EXPJPNO",             "OCCDAT",              "OCCCOD",   
		  "FORAMT",            "FORCUR",              "FPRRAT",              "WONAMT",   
		  "VATAMT",            "SETTLE",              "POLCNO",              "POBLNO",   
		  "BIGU",              "AC_CONFIRM",          "SETDAT",              "CVCOD",   
		  "MULGU",             "LCMAGU",              "LCMADAT",             "MABLNO",   
		  "PRCGUB",            "SAUPJ"  )  
VALUES( :gs_sabu,   		 :sjpno,						 :srcadat,					:scode,
		  :dwaiamt,   			 :scurr,						 :drate,						:dwonamt,
		  0,						 'N',							 :slcno,						null,
		  '1',			 		 null,						 null,						:sbank,
		  'N',					 'N',							 null,						null,
		  'N',                :sSaupj   ) ;

if sqlca.sqlcode <> 0 then
	Rollback ;
	Messagebox("수입비용명세", "수입비용명세 작성중 오류발생", stopsign!)
	return -1
end if

sjpno = isimpno + '002'

// 수입비용 명세서 작성 - 타발추심료
if dchamt > 0 then
	INSERT INTO "IMPEXP"  
			( "SABU",              "EXPJPNO",             "OCCDAT",              "OCCCOD",   
			  "FORAMT",            "FORCUR",              "FPRRAT",              "WONAMT",   
			  "VATAMT",            "SETTLE",              "POLCNO",              "POBLNO",   
			  "BIGU",              "AC_CONFIRM",          "SETDAT",              "CVCOD",   
			  "MULGU",             "LCMAGU",              "LCMADAT",             "MABLNO",   
			  "PRCGUB",            "SAUPJ"  )  
	VALUES( :gs_sabu,   		 :sjpno,						 :srcadat,					:schcode,
			  0,   			    'WON',						 0,						:dchamt,
			  0,						 'X',							 :slcno,						null,
			  '1',			 		 null,						 null,						:sbank,
			  'N',					 'N',							 null,						null,
			  'N',                :sSaupj   ) ;
End if

if sqlca.sqlcode <> 0 then
	Rollback ;
	Messagebox("수입비용명세", "수입비용명세 작성중 오류발생", stopsign!)
	return -1
end if


//--------
dilrate 	= dw_detail.getitemdecimal(1, "ilrate")
dilamt	 	= dw_detail.getitemdecimal(1, "ilamt")
dilsu	 	= dw_detail.getitemdecimal(1, "ilsu")
if	dilrate > 0 	then
	sjpno = isimpno + '003'
	
	// 수입비용 명세서 작성 - 이자비용
	if dilamt > 0 then
		INSERT INTO "IMPEXP"  
				( "SABU",              "EXPJPNO",             "OCCDAT",              "OCCCOD",   
				  "FORAMT",            "FORCUR",              "FPRRAT",              "WONAMT",   
				  "VATAMT",            "SETTLE",              "POLCNO",              "POBLNO",   
				  "BIGU",              "AC_CONFIRM",          "SETDAT",              "CVCOD",   
				  "MULGU",             "LCMAGU",              "LCMADAT",             "MABLNO",   
				  "PRCGUB",            "SAUPJ"  )  
		VALUES( :gs_sabu,   		 :sjpno,						 :srcadat,				:ls_inter,
				  0,   			    		'WON',						 0,						:dilamt,
				  0,						 'X',							 :slcno,				null,
				  '2',			 		 null,						 	null,					:sbank,
				  'N',					 'N',							 null,					null,
				  'N',                		:sSaupj   ) ;
	End if
	
	if 	sqlca.sqlcode <> 0 then
		Rollback ;
		Messagebox("이자비용", "이자비용명세 작성중 오류발생", stopsign!)
		return -1
	end if
End If
///////////////////////////////////////////////////////////////////////////////////////////
lRowCount = dw_list.rowcount() 

For Lrow = 1 to lRowCount 
	
	 sblno = dw_list.getitemstring(Lrow, "poblno")
	 lseq  = dw_list.getitemNumber(Lrow, "pobseq")
	 damt  = dw_list.getitemdecimal(Lrow, "pomulamt")
	 
	 if damt <= 0 then continue 
 
	// B/L-HEAD에 결제번호 UPDATE
	update polcblhd
		set taxno = :ssetno
	 where sabu  = :gs_sabu and poblno = :sblno;	
	 
	if sqlca.sqlcode <> 0 then
		Rollback ;
		Messagebox("수입B/L HEAD", "B/L HEAD 수정중 오류발생", stopsign!)
		return -1
	end if
	
	 insert into polcsetdt
		(sabu,		setno,	poblno,	polcno,	pobseq,  pomulamt,  gubun )
	  values
		(:gs_sabu,	:ssetno,	:sblno,	:slcno,	:lseq,   :damt,	  '1');
		  
	if sqlca.sqlcode <> 0 then
		Rollback ;
		Messagebox("구매결제-DETAIL", "구매결제 상세내역 작성중 오류발생", stopsign!)
		return -1
	end if
	
Next
	
// 결제금액을 L/C-HEAD에 UPDATE(단 원화L/C인 경우에는 원화를 결제금에 update)
IF scurr <> 'WON' then
	update polchd
		set bilamt = bilamt + :dwaiamt
	 where sabu = :gs_sabu and polcno = :slcno;	
Else
	update polchd
		set bilamt = bilamt + :dwonamt
	 where sabu = :gs_sabu and polcno = :slcno;		
End if
 
if sqlca.sqlcode <> 0 then
	Rollback ;
	Messagebox("구매L/C", "구매L/C 결제금 작성중 오류발생", stopsign!)
	return -1
end if

// 금융사용금액을 수입한도에 update
if sGyeyn = 'N' then  //자기자금결제
	return 1 
elseif sGyeyn = 'Y' then //무역금융결제
	Update pobank
		set blusdamt = nvl(blusdamt, 0) + :dkumusd,
			 blwonamt = nvl(blwonamt, 0) + :dkumwon
	 where sabu = :gs_sabu and bankcd = :sbank;
else  //usance 결제
	Update pobank
		set usansamt = nvl(usansamt, 0) + :dkumusd,
			 usanswon = nvl(usanswon, 0) + :dkumwon
	 where sabu = :gs_sabu and bankcd = :sbank;
end if 

if sqlca.sqlcode <> 0 then
	Rollback ;
	Messagebox("금융사용", "금융사용 내역 작성중 오류발생", stopsign!)
	return -1
end if 

return 1

end function

public subroutine wf_query ();
w_mdi_frame.sle_msg.text = "조회"
ic_Status = '2'

dw_list.SetFocus()
	

// button
p_delete.enabled = true
//cb_insert.enabled = false

end subroutine

public function integer wf_checkrequiredfield ();string	sCode, ls_pocurr
dec{2}   damt, dTotal, dLcamt, dBilamt, damt1, damt2, damt3, damt4, damt5, ld_amt
dec{4}   drate
long		lcount, lrow, lno , lRstan

if dw_list.accepttext() = -1 then return -1
if dw_detail.accepttext() = -1 then return -1

sCode = trim(dw_detail.getitemstring(1, "polcno"))
if isnull(sCode) or trim(sCode) = '' then
	f_message_chk(30,'[L/C-NO]')		
	dw_detail.SetColumn("polcno")
	dw_detail.SetFocus()
	RETURN -1	
end if

sCode = trim(dw_detail.getitemstring(1, "rcadat"))
if isnull(sCode) or trim(sCode) = '' then
	f_message_chk(30,'[결제일자]')		
	dw_detail.SetColumn("rcadat")
	dw_detail.SetFocus()
	RETURN -1	
end if

sCode = trim(dw_detail.getitemstring(1, "gipdat"))
if isnull(sCode) or trim(sCode) = '' then
	f_message_chk(30,'[기표일자]')		
	dw_detail.SetColumn("gipdat")
	dw_detail.SetFocus()
	RETURN -1	
end if

if dw_detail.getitemString(1, "pocurr") <> 'WON' THEN 
	damt = dw_detail.getitemdecimal(1, "gyeamt")
	if isnull(damt) or dAmt = 0 then
		f_message_chk(30,'[결제금액(외화)]')		
		dw_detail.SetColumn("gyeamt")
		dw_detail.SetFocus()
		RETURN -1	
	end if
	
	if dw_list.rowcount() > 0 then 
		dTotal = dw_list.getitemdecimal(1, "tot_amt")
		if damt < dTotal then 
			Messagebox("결제금액", "결제금액이 DETAIL에 미결제 금액 합계 보다 작습니다", stopsign!)
			dw_detail.SetColumn("gyeamt")
			dw_detail.SetFocus()
			return -1
		end if
	end if
ELSE
	damt = dw_detail.getitemdecimal(1, "gyewon")
	if dw_list.rowcount() > 0 then 
		dTotal = dw_list.getitemdecimal(1, "tot_amt")
		if damt < dTotal then 
			Messagebox("결제금액", "결제금액이 DETAIL에 미결제 금액 합계 보다 작습니다", stopsign!)
			dw_detail.SetColumn("gyewon")
			dw_detail.SetFocus()
			return -1
		end if
	end if

end if

dLcamt  = dw_detail.getitemdecimal(1, "polamt")
dBilamt = dw_detail.getitemdecimal(1, "bilamt")
if damt > dLcamt - dBilamt then
	Messagebox("결제금액", "결제금액이 미결제액(L/C금액 - 결제금액)보다 큽니다", stopsign!)
	return -1
end if

drate = dw_detail.getitemdecimal(1, "grate")
if isnull(drate) or drate = 0 then
	f_message_chk(30,'[적용환율]')		
	dw_detail.SetColumn("grate")
	dw_detail.SetFocus()
	RETURN -1	
end if

//if 	dw_detail.getitemString(1, "pocurr") = 'WON' THEN 
//	//--- 환율등록 처리를 위하여 환율조회하여 결제금액(USD)에 입력처리.
//	ls_pocurr 	= dw_detail.getitemString(1, "pocurr")
//	sCode 	= trim(dw_detail.getitemstring(1, "rcadat"))
//	lRstan 	= 0
//	Select  	Rstan into :lRstan	from RATEMT 
//	   where   rdate = :sCode  And  rcurr = :ls_pocurr;
//	If	lRstan	= 0		then
//		sCode 	= left(scode,6)
//		SELECT exchrate  into :lRstan
//		  FROM exchrate_forecast 
//		 WHERE base_yymm like :scode
//			AND  ratunit = :ls_pocurr; 		
//	End If
//	If	lRstan	= 0		then
//		lRstan = 1
//	End If
//	damt 	= dw_detail.getitemdecimal(1, "gyewon")
//	damt  	= damt / lRstan
//	dw_detail.SetItem(1,"gyeusd", damt)
//End if

damt = dw_detail.getitemdecimal(1, "gyeusd")
//if isnull(damt) or dAmt = 0 then
//	f_message_chk(30,'[결제금액(USD)]')		
//	dw_detail.SetColumn("gyeusd")
//	dw_detail.SetFocus()
//	RETURN -1	
//end if

damt = dw_detail.getitemdecimal(1, "gyewon")
if isnull(damt) or dAmt = 0 then
	f_message_chk(30,'[결제금액(WON)]')		
	dw_detail.SetColumn("gyewon")
	dw_detail.SetFocus()
	RETURN -1	
end if

// 금융사용인 경우에만 적용함
if dw_detail.getitemstring(1, "gyeyn") <> 'N' then
	damt = dw_detail.getitemdecimal(1, "kumusd")
//	if ( isnull(damt) or dAmt = 0 ) and damt = 0 then
//		f_message_chk(30,'[사용금액(USD)]')		
//		dw_detail.SetColumn("kumusd")
//		dw_detail.SetFocus()
//		RETURN -1	
//	end if
	
	damt = dw_detail.getitemdecimal(1, "kumprc")
//	if isnull(damt) or dAmt = 0 then
//		f_message_chk(30,'[단가]')		
//		dw_detail.SetColumn("kumusd")
//		dw_detail.SetFocus()
//		RETURN -1	
//	end if	
	
	damt = dw_detail.getitemdecimal(1, "kumwon")
	if isnull(damt) or dAmt = 0 then
		f_message_chk(30,'[사용금액(WON)]')		
		dw_detail.SetColumn("kumwon")
		dw_detail.SetFocus()
		RETURN -1	
	end if		
	
end if

// 예금출금인 경우에는 계좌번호 필수
scode = dw_detail.getitemstring(1, "gyecod")
damt  = dw_detail.getitemdecimal(1, "chamt")
If damt > 0 then
	If IsNull( scode ) or Trim( sCode ) = '' then
		MessageBox("계좌번호", "예금출금인 경우 계좌번호는 필수입니다", stopsign!)
		dw_detail.SetColumn("gyecod")
		dw_detail.SetFocus()
		RETURN -1					
	end if
End if

If Not IsNull( scode ) then
	If damt = 0 then
		MessageBox("예금출금", "계좌번호가 있으면 예금출금이 필수입니다", stopsign!)
		dw_detail.SetColumn("chamt")
		dw_detail.SetFocus()
		RETURN -1					
	end if
End if

// 자동전표를 발행하기 위하여 차대변금액을 Check
damt  = dw_detail.getitemdecimal(1, "gyewon")  // 결제금액
damt1 = dw_detail.getitemdecimal(1, "biamt1")  // 타발추심액
damt2 = dw_detail.getitemdecimal(1, "ilamt")   // 이자금액

damt3 = dw_detail.getitemdecimal(1, "kumwon")  // 차입금액
damt4 = dw_detail.getitemdecimal(1, "chamt")   // 인출금액(예금)
damt5 = dw_detail.getitemdecimal(1, "csamt")   // 인출금액(현금)

If damt + damt1 + damt2 <> damt3 + damt4 + damt5 then
	Messagebox("결제금액", "결제금액의 차대금액이 일치하지 않읍니다", stopsign!)
	dw_detail.SetFocus()	
	return -1
end if

sCode = dw_detail.getitemstring(1, "rcadat")
// 전표번호 채번
lcount = sqlca.fun_junpyo(gs_sabu, left(sCode, 6), "R0")
if lcount < 1 then
	rollback;
	Messagebox("구매결제번호", "번호채번시 오류발생", stopsign!)
	return -1
end if

dw_detail.setitem(1, "sabu", 		gs_sabu)
dw_detail.setitem(1, "setno", 	sCode + string(lcount, '0000'))

// 전표번호 채번
lno = sqlca.fun_junpyo(gs_sabu, sCode, "P0")
if lno < 1 then
	rollback;
	Messagebox("수입비용번호", "번호채번시 오류발생", stopsign!)
	return -1
end if

isimpno = sCode + string(lno, '0000')
dw_detail.setitem(1, "sujpno", 	isimpno + '001')

commit;

return 1

end function

public subroutine wf_new ();
ic_status = '1'
w_mdi_frame.sle_msg.text = "등록"

///////////////////////////////////////////////
dw_detail.setredraw(false)

dw_detail.reset()
dw_detail.insertrow(0)
dw_detail.setitem(1, "sabu", gs_sabu)
dw_detail.setitem(1, "rcadat", is_today)
dw_detail.setitem(1, "gipdat", is_today)
dw_detail.setredraw(true)
///////////////////////////////////////////////

dw_list.dataobject = "d_imt_04060_1"
dw_list.settransobject(sqlca)

dw_detail.enabled = true
dw_list.enabled = true

dw_detail.SetFocus()

p_save.enabled = true
p_delete.enabled = false
p_delete.picturename = 'C:\erpman\image\삭제_d.gif'

p_delrow.enabled = true
p_delrow.picturename = 'C:\erpman\image\행삭제_up.gif'

ib_any_typing = false


end subroutine

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF

///////////////////////////////////////////////////////////////////////////////////
//기본 부가사업장 코드 시스템에서 가져오기
SELECT DATANAME  
  INTO :is_saupj
  FROM SYSCNFG  
 WHERE SYSGU = 'Y' AND SERIAL = 32 AND LINENO = '3' ;

IF isnull(is_saupj) or trim(is_saupj) = '' then is_saupj = '' 

dw_detail.settransobject(sqlca)
dw_list.settransobject(sqlca)

p_cancel.TriggerEvent("clicked")
end event

on w_imt_04060.create
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_2=create p_2
this.p_delrow=create p_delrow
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_delete=create p_delete
this.p_save=create p_save
this.p_retrieve=create p_retrieve
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.pb_3,&
this.pb_2,&
this.pb_1,&
this.p_2,&
this.p_delrow,&
this.p_exit,&
this.p_cancel,&
this.p_delete,&
this.p_save,&
this.p_retrieve,&
this.dw_detail,&
this.dw_list,&
this.rr_1}
end on

on w_imt_04060.destroy
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_2)
destroy(this.p_delrow)
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_delete)
destroy(this.p_save)
destroy(this.p_retrieve)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event closequery;string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

w_mdi_frame.st_window.Text = ''

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

type pb_3 from u_pb_cal within w_imt_04060
integer x = 983
integer y = 300
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('rcadat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'rcadat', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_04060
integer x = 3269
integer y = 712
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('mandat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'mandat', gs_code)



end event

type pb_1 from u_pb_cal within w_imt_04060
integer x = 2066
integer y = 300
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_detail.SetColumn('gipdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_detail.GetRow()
If ll_row < 1 Then Return
dw_detail.SetItem(ll_row, 'gipdat', gs_code)



end event

type p_2 from uo_picture within w_imt_04060
integer x = 3511
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "c:\ERPMAN\cur\point.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\선급금조회_up.gif"
end type

event clicked;call super::clicked;if dw_detail.Accepttext() = -1	then 	return

gs_gubun = 'w_imt_04060'
gs_code  = dw_detail.getitemstring(1, "polcno")

openSheet(w_imt_04080,w_mdi_frame,2,Layered!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\선급금조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\선급금조회_up.gif"
end event

type p_delrow from uo_picture within w_imt_04060
integer x = 3337
integer y = 24
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event clicked;call super::clicked;Long Lrow

Lrow = dw_list.getrow()

if Lrow > 0 then
	If Messagebox("행삭제", dw_list.getitemstring(Lrow, "poblno") + '~n' + &
									"를 삭제하시겠읍니까?", question!, yesno!) = 1 then
		dw_list.deleterow(dw_list.getrow())
	end if
end if
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_exit from uo_picture within w_imt_04060
integer x = 4402
integer y = 24
integer width = 178
integer taborder = 90
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : 종료" , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		RETURN 									

	END IF

END IF

close(parent)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_cancel from uo_picture within w_imt_04060
integer x = 4229
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : 취소" , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		RETURN 									

	END IF

END IF

wf_New()

dw_list.Reset()
end event

type p_delete from uo_picture within w_imt_04060
integer x = 4055
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "c:\ERPMAN\cur\delete.cur"
boolean enabled = false
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;String ssetno, sSujpno

IF f_msg_delete() = -1 THEN	RETURN

ssetno  = dw_detail.getitemstring(1, "setno")
sSujpno = dw_detail.getitemstring(1, "sujpno")  //수입비용 전표번호
	
/////////////////////////////////////////////////////////////////
	
// HEAD삭제
DELETE FROM POLCSETHD
 WHERE SABU = :gs_sabu AND SETNO = :ssetno   ;
IF SQLCA.SQLCODE <> 0 THEN
	rollback;
	MESSAGEBOX("구매결제-HEAD", "구매결제-HEAD삭제시 오류가 발생", stopsign!)
	return
END IF

// DETAIL삭제
DELETE FROM POLCSETDT
 WHERE SABU = :gs_sabu AND SETNO = :ssetno   ;
IF SQLCA.SQLCODE <> 0 THEN
	rollback;
	MESSAGEBOX("구매결제-DETAIL", "구매결제-DETAIL삭제시 오류가 발생", stopsign!)
	return
END IF

// 수입비용내역을 삭제
Delete from impexp
 where sabu = :gs_sabu and expjpno Like substr(:sSujpno, 1, 12)||'%';	
 
if sqlca.sqlcode <> 0 then
	Messagebox("수입비용", "수입비용 삭제시 오류발생", stopsign!)
	return -1
end if	 		

if wf_delete() = -1 then
	rollback;
	f_Rollback()
	return
END IF		

COMMIT;

Messagebox("삭제완료", "자료가 삭제되었읍니다", information!)	

wf_New()

dw_list.Reset()	
	
dw_detail.setredraw(true)

end event

type p_save from uo_picture within w_imt_04060
integer x = 3881
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "c:\ERPMAN\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_detail.AcceptText() = -1	THEN	RETURN
IF dw_list.AcceptText() = -1		THEN	RETURN

string	ssetno
/////////////////////////////////////////////////////////////////////////
IF f_msg_update() = -1 		THEN	RETURN

IF	wf_CheckRequiredField() = -1	THEN	RETURN

IF dw_detail.Update() = 1	then
	if wf_create() = -1 then
		ROLLBACK;
		f_Rollback()
		return
	END IF		
	COMMIT;
	ssetno = dw_detail.getitemstring(1, "setno")
	Messagebox("저장완료", "결제번호 -> " + ssetno + " 로 자료가 저장되었읍니다", information!)
ELSE
	ROLLBACK;
	f_Rollback()
END IF

ib_any_typing = False

p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)

end event

type p_retrieve from uo_picture within w_imt_04060
integer x = 3707
integer y = 24
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event clicked;call super::clicked;
if dw_detail.Accepttext() = -1	then 	return

string  	ssetno,		&
			sDate,		&
			sNull, slcno
int      get_count 
			
SetNull(sNull)

ssetno	= dw_detail.getitemstring(1, "setno")

IF isnull(ssetno) or ssetno = "" 	THEN
	f_message_chk(30,'[구매결제번호]')
	dw_detail.SetColumn("setno")
	dw_detail.SetFocus()
	RETURN
END IF

//////////////////////////////////////////////////////////////////////////
dw_detail.SetRedraw(False)

IF dw_detail.Retrieve(gs_Sabu, ssetno) < 1	THEN
	f_message_chk(50, '[구매결제번호]')
	dw_detail.setcolumn("setno")
	dw_detail.setfocus()

	ib_any_typing = False
	p_cancel.TriggerEvent("clicked")
	RETURN
END IF

dw_detail.SetRedraw(True)

dw_list.dataobject = "d_imt_04060_2"
dw_list.settransobject(sqlca)

dw_list.Retrieve(gs_Sabu, ssetno)

wf_Query()

p_save.enabled = false

//////////////////////////////////////////////////////////////////////////////////////
// 상환중이거나, B/L이 마감되거나, 구매결제내역이 회계로 전송된 경우에는 처리못 함  //
//////////////////////////////////////////////////////////////////////////////////////
if dw_detail.getitemdecimal(1, "gisawon") > 0 then
	w_mdi_frame.sle_msg.text = "상환내역이 발생하였읍니다"
	p_delete.enabled = false
	return
end if

get_count = 0

Select Count(*)
  Into :get_count
  From polcsetdt a, polcbl b
 where a.sabu 		= :gs_sabu and a.setno  = :ssetno
   and a.sabu     = b.sabu    and a.poblno = b.poblno
	and a.magyeo	= 'Y';
	
if get_count > 0 then
	w_mdi_frame.sle_msg.text = "B/L(인수증)내역이 마감되었읍니다."
	p_delete.enabled = false	
	return
end if	

get_count = 0
Select Count(*)
  Into :get_count
  From polcsetdt a, impexp b
 where a.sabu 		= :gs_sabu and a.setno   = :ssetno
   and a.sabu     = b.sabu    and a.impjpno = b.impjpno and b.settle = 'Y';
	
if get_count > 0 then
	w_mdi_frame.sle_msg.text = "구매결제내역이 정산신청되었읍니다."
	
	p_delete.enabled = false	
	return
end if		

dw_detail.enabled = false
p_delete.enabled = true
p_delete.picturename = 'C:\erpman\image\삭제_up.gif'

p_delrow.enabled = false
p_delrow.picturename = 'C:\erpman\image\행삭제_d.gif'

ib_any_typing = False

end event

type dw_detail from datawindow within w_imt_04060
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 176
integer width = 4535
integer height = 764
integer taborder = 10
string dataobject = "d_imt_04060"
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;string	sDate, 			&
			sCode, sName,	&
			sNull, sBigub, slcno, scvcod, scvnas, scurr, slocal, sbank, ssaveno, sabname, sbankcd
int      icount			
dec{5}   dbilamt, damt, drate, ndivide, dusdrat, damt1, damt2

SetNull(sNull)
// 끝전
If this.getcolumnname() = 'gyewon' then
	damt  = dec(gettext())
	damt1 = getitemdecimal(1, "kumwon")
	setitem(1, "latwon", damt - damt1)
ElseIf this.getcolumnname() = 'kumwon' then
	damt1  = dec(gettext())
	damt   = getitemdecimal(1, "gyewon")
	setitem(1, "latwon", damt - damt1)
	
	damt    = getitemdecimal(1, "kumusd")
	If damt  > 0 then
		setitem(1, "kumprc", damt1 / damt)	
	End if
ElseIf this.getcolumnname() = 'kumusd' then
	damt1   = dec(gettext())
	damt    = getitemdecimal(1, "kumwon")
	If damt1 > 0 then
		setitem(1, "kumprc", damt / damt1)	
	End if
End if

If this.getcolumnname() = 'ilamt' then
	damt    = dec(gettext())
	damt1   = getitemdecimal(1, "latwon")
	damt2   = getitemdecimal(1, "biamt1")	
	setitem(1, "chamt", damt + damt1 + damt2)
ElseIf this.getcolumnname() = 'latwon' then
	damt    = dec(gettext())
	damt1   = getitemdecimal(1, "ilamt")
	damt2   = getitemdecimal(1, "biamt1")	
	setitem(1, "chamt", damt + damt1 + damt2)	
ElseIf this.getcolumnname() = 'biamt1' then
	damt    = dec(gettext())
	damt1   = getitemdecimal(1, "ilamt")
	damt2   = getitemdecimal(1, "latwon")	
	setitem(1, "chamt", damt + damt1 + damt2)		
End if

// L/C-NO
IF this.GetColumnName() = 'polcno' THEN

	slcno  = TRIM(this.gettext())
	
	Select a.poopbk, b.cvnas, a.bilamt, a.pocurr, a.polamt, a.localyn 
	  into :scvcod, :scvnas, :dbilamt, :scurr, :drate, :slocal
	  from polchd a, vndmst b
	 where a.sabu = :gs_sabu and a.polcno = :slcno
	 	and a.poopbk = b.cvcod (+);
	 
	if sqlca.sqlcode <> 0 then
      f_message_chk(33, '[L/C-NO]')
		dw_detail.setitem(1, "polcno", sNull)
		dw_detail.setitem(1, "poopbk", snull)
		dw_detail.setitem(1, "cvnas2", snull)
		dw_detail.setitem(1, "pocurr", snull)
		dw_detail.setitem(1, "polamt", 0)
		dw_detail.setitem(1, "bilamt", 0)		
		dw_list.reset()
		return 1
	END IF
	
	IF dw_list.retrieve(gs_sabu, slcno) < 0	then
      f_message_chk(50, '[L/C-NO]')
		this.setitem(1, "polcno", sNull)
		dw_detail.setitem(1, "polcno", sNull)
		dw_detail.setitem(1, "pooobk", snull)
		dw_detail.setitem(1, "cvnas2", snull)
		dw_detail.setitem(1, "pocurr", snull)
		dw_detail.setitem(1, "polamt", 0)
		dw_detail.setitem(1, "bilamt", 0)		
		return 1
	END IF
	
	dw_detail.setitem(1, "poopbk", scvcod)
	dw_detail.setitem(1, "cvnas2", scvnas)
	dw_detail.setitem(1, "pocurr", scurr)	
	dw_detail.setitem(1, "polamt", drate)	
	dw_detail.setitem(1, "bilamt", dbilamt)
	dw_detail.setitem(1, "localyn", slocal)
	
	wf_rate(dw_detail.getitemstring(1, "rcadat"), scurr, slocal, 'Y')
ELSEIF this.GetColumnName() = 'rcadat' THEN
	sCode = TRIM(this.gettext())
	
	IF scode ='' or isnull(scode) then return 
	
	if f_datechk(sCode) = -1 then
		f_message_chk(35,'[결제일자]')		
		dw_detail.setitem(1, "rcadat", snull)
		RETURN 1
	end if
	
	scurr  = dw_detail.getitemstring(1, "pocurr")
	slocal = dw_detail.getitemstring(1, "localyn")
	wf_rate(scode, scurr, slocal, 'Y')	
	
ELSEIF this.GetColumnName() = 'gipdat' THEN
	sCode = TRIM(this.gettext())

	IF scode ='' or isnull(scode) then return 

	if f_datechk(sCode) = -1 then
		f_message_chk(35,'[기표일자]')		
		dw_detail.setitem(1, "gipdat", snull)	
		RETURN 1	
	end if
ELSEIF this.GetColumnName() = 'gyeamt' THEN
	damt = dec(gettext())
	if isnull(damt) or dAmt = 0 then
		f_message_chk(30,'[결제금액(외화)]')		
		RETURN 1	
	elseif   damt > dw_detail.getitemdecimal(1, "polamt") - dw_detail.getitemdecimal(1, "bilamt") then
		Messagebox("결제금액", "결제금액(외화)이 미결제액(L/C금액 - 결제금액)보다 큽니다", stopsign!)
		dw_detail.setitem(1, "gyeamt", 0)
		RETURN 1	
	end if
	
	scurr = dw_detail.getitemstring(1, "pocurr")
	
	ndivide = 1
	
  SELECT NVL(TO_NUMBER(RFNA2), 1)
	 INTO :nDIVIDE
	 FROM REFFPF  
	WHERE SABU  = '1' AND  RFCOD = '10' AND  RFGUB = :scurr  ;
	
	drate		= getitemdecimal(1, "grate")
	dusdrat	= getitemdecimal(1, "gusdrat")	
	setitem(1, "gyewon", truncate((damt * drate) / ndivide, 0))	
	setitem(1, "gyeusd", truncate((damt * dusdrat) / ndivide,0))
	
ELSEIF this.GetColumnName() = 'gyewon' THEN
	scurr = dw_detail.getitemstring(1, "pocurr")
	
	IF scurr <> 'WON' THEN RETURN 
	
	damt = dec(gettext())
	
	if isnull(damt) or dAmt = 0 then
		f_message_chk(30,'[결제금액(WON)]')		
		RETURN 1	
	elseif   damt > dw_detail.getitemdecimal(1, "polamt") - dw_detail.getitemdecimal(1, "bilamt") then
		Messagebox("결제금액", "결제금액(WON)이 미결제액(L/C금액 - 결제금액)보다 큽니다", stopsign!)
		dw_detail.setitem(1, "gyewon", 0)
		RETURN 1	
	end if
	
// 결제금액(적용환율)
elseif this.getcolumnname() = "grate" then
	damt 	= dec(gettext())
	drate	= getitemdecimal(1, "gyeamt")

	scurr = dw_detail.getitemstring(1, "pocurr")
	ndivide = 1
	
  SELECT NVL(TO_NUMBER(RFNA2), 1)
	 INTO :nDIVIDE
	 FROM REFFPF  
	WHERE SABU  = '1' AND  RFCOD = '10' AND  RFGUB = :scurr  ;
	
	setitem(1, "gyewon", truncate((damt * drate) / ndivide, 0))
// 결제금액(USD)
elseif this.getcolumnname() = "gyeusd" then
	damt 		= dec(gettext())
	drate		= getitemdecimal(1, "gyeamt")
	if drate = 0 then 
		setitem(1, "gusdrat", 1)
	else
		setitem(1, "gusdrat", truncate(damt / drate, 5))
	end if
// 금융사용 여부에 따라서 무역금융 사용금액, 금융단가... 등을 자동으로 setting한다.
elseif this.getcolumnname() = "gyeyn" then
	scode = gettext()
	
	if scode = 'N' then 
		setitem(1, "kumusd", 0)
		setitem(1, "kumprc", 0)		
		setitem(1, "kumwon", 0)
		setitem(1, "latwon", 0)
		setitem(1, "ilrate", 0)		
		setitem(1, "ilamt",  0)
		setitem(1, "ilsu",   0)
		setitem(1, "mandat", getitemstring(1, "rcadat"))
		return
	end if
	
	sbank = this.getitemstring(1, "poopbk")
	
	if scode = 'O' then //usance 결제 
		Select nvl(urate, 0), nvl(uilrate, 0), nvl(uililsu, 0)
		  into :drate, :damt, :dbilamt
		  From pobank
		 where sabu = :gs_sabu and bankcd = :sbank;
	else
		Select nvl(crate, 0), nvl(ilrate, 0), nvl(ililsu, 0)
		  into :drate, :damt, :dbilamt
		  From pobank
		 where sabu = :gs_sabu and bankcd = :sbank;
	end if

   if isnull(drate)   then drate = 0 
   if isnull(damt)    then damt = 0 
   if isnull(dbilamt) then dbilamt = 0 
	
	this.setitem(1, "kumprc", drate)
	this.setitem(1, "ilrate", damt)
	this.setitem(1, "ilsu",   dbilamt)	

	this.setitem(1, "kumwon", truncate(getitemdecimal(1, "gyewon") / 100000, 0) * 100000)
	
	if drate = 0 then 
		setitem(1, "kumusd", 0)
	else
		setitem(1, "kumusd", truncate(getitemdecimal(1, "kumwon") / drate, 0))
	end if
	
	setitem(1, "latwon", getitemdecimal(1, "gyewon") - getitemdecimal(1, "kumwon"))
	setitem(1, "ilamt",  truncate((((getitemdecimal(1, "kumwon") * (damt / 100)) / 365) * dbilamt), 0))
	setitem(1, "mandat", f_afterday(getitemstring(1, "gipdat"), dbilamt))
elseif this.getcolumnname() = "gyecod" then
	
		sbank = GetText()
		//************************************************
		Select bnk_cd, ab_no, ab_name Into :sBankcd, :sSaveNo, :sAbName
		From   kfm04ot0
		Where  ab_dpno = :sbank;
		//************************************************
		if sqlca.Sqlcode <> 0 then
 			f_Message_Chk(33, '[예적금코드]')
			SetItem(1, "gyecod", sNull)
			SetItem(1, "ab_name", sNull)
			return 1
		else
			SetItem(1, "ab_name", sAbName)
			SetItem(1, "gyecod", sSaveNo)
		end if
	
end if


end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;gs_gubun = ''
gs_code  = ''
gs_codename = ''


// LC번호
IF this.GetColumnName() = 'polcno'	THEN
	Gs_gubun = 'LOCAL'
	  
	Open(w_lc_popup)
		
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "polcno", gs_code)
	this.TriggerEvent(Itemchanged!)
	
// 구매결제번호
ELSEIF this.GetColumnName() = 'setno'	THEN
	  
	Open(w_polcsethd_popup)
		
	if isNull(gs_code) or trim(gs_code) = ''	then	return
	SetItem(1, "setno", gs_code)
	this.TriggerEvent(Itemchanged!)
	
ELSEIF this.GetColumnName() = 'gyecod'	THEN	
	gs_code = GetText()
	Open(w_kfm04ot0_popup)
	
	if gs_code = "" or isnull(gs_code) then return
	
	SetItem(1, "ab_name", gs_codename)
	SetItem(1, "gyecod", gs_code)	
END IF
end event

event editchanged;ib_any_typing =True
end event

type dw_list from datawindow within w_imt_04060
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 78
integer y = 976
integer width = 4466
integer height = 1292
integer taborder = 30
string dataobject = "d_imt_04060_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;choose case key
	case KeyF1! 
   	TriggerEvent(RbuttonDown!)
end choose
	
end event

event itemerror;RETURN 1
	
	
end event

event losefocus;this.AcceptText()
end event

event editchanged;ib_any_typing =True


end event

event itemchanged;dec {2} dOldAmt, dAmt, dblamt, dmulamt

// 미결제금액 + 기결제금액 > 인수금액 -> ERROR
IF this.getcolumnname() = "pomulamt" 	THEN
	dOldAmt   = this.GetITemDecimal(Row, "pomulamt")

 	dAmt  	 = dec(this.GetText())
	dblamt    = this.GetITemDecimal(Row, "blamt")
	dmulamt   = this.GetITemDecimal(Row, "mulamt")
	
	IF damt + dmulamt > dblamt		THEN
		MessageBox("확 인", "미결제금액 + 기결제금액 은  인수금액보다 클 수 없습니다.")
		this.SetItem(Row, "pomulamt", dOldAmt)
		RETURN 1
	END IF
	
END IF

end event

type rr_1 from roundrectangle within w_imt_04060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 960
integer width = 4494
integer height = 1320
integer cornerheight = 40
integer cornerwidth = 55
end type

