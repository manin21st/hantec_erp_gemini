$PBExportHeader$w_kifa05.srw
$PBExportComments$자동전표 관리 : 수금(반제를 영업에서 처리)
forward
global type w_kifa05 from w_inherite
end type
type rr_1 from roundrectangle within w_kifa05
end type
type gb_1 from groupbox within w_kifa05
end type
type rb_1 from radiobutton within w_kifa05
end type
type rb_2 from radiobutton within w_kifa05
end type
type dw_junpoy from datawindow within w_kifa05
end type
type dw_sungin from datawindow within w_kifa05
end type
type dw_group_detail_cause from datawindow within w_kifa05
end type
type dw_print from datawindow within w_kifa05
end type
type dw_rbill from datawindow within w_kifa05
end type
type dw_sang from datawindow within w_kifa05
end type
type dw_group_detail_type from datawindow within w_kifa05
end type
type dw_ip from u_key_enter within w_kifa05
end type
type cbx_all from checkbox within w_kifa05
end type
type dw_rtv from datawindow within w_kifa05
end type
type dw_delete from datawindow within w_kifa05
end type
end forward

global type w_kifa05 from w_inherite
integer height = 2436
string title = "수금전표 처리"
rr_1 rr_1
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_group_detail_cause dw_group_detail_cause
dw_print dw_print
dw_rbill dw_rbill
dw_sang dw_sang
dw_group_detail_type dw_group_detail_type
dw_ip dw_ip
cbx_all cbx_all
dw_rtv dw_rtv
dw_delete dw_delete
end type
global w_kifa05 w_kifa05

type variables
Long  lDbErrCode
String sUpmuGbn = 'F',LsAutoSungGbn
end variables

forward prototypes
public function integer wf_delete_kfz12ot0 ()
public function integer wf_insert_kfz12otd (string sstatus, integer irow, string ssaupj, string sbaldate, long lbjunno, long llinno)
public function integer wf_insert_sang (integer icurrow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, double damount, string stype, string ssangcust, string sflag)
public function integer wf_update_fulljunno ()
public function integer wf_insert_kfz12ot0 (string ssaupj)
end prototypes

public function integer wf_delete_kfz12ot0 ();Integer iRowCount,k,i
String  sSaupj,sBalDate,sUpmuGu,sBill,sChuYmd,sStatus,snull
Long    lJunNo,lNull

SetNull(snull)
SetNull(lNull)

dw_junpoy.Reset()

SetPointer(HourGlass!)

For k = 1 TO dw_delete.RowCount()
	IF dw_delete.GetItemString(k,"chk") = '1' THEN
		sSaupj   = dw_delete.GetItemString(k,"saupj")
		sBalDate = dw_delete.GetItemString(k,"bal_date")
		sUpmuGu  = dw_delete.GetItemString(k,"upmu_gu")
		lJunNo   = dw_delete.GetItemNumber(k,"bjun_no")
		
		iRowCount = dw_junpoy.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo)
		IF iRowCount <=0 THEN Return 1
		
		FOR i = iRowCount TO 1 STEP -1							/*전표 삭제*/
			dw_junpoy.DeleteRow(i)		
		NEXT

		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(12,'[미승인전표]')
			SetPointer(Arrow!)
			Return -1
		END IF
			
		DELETE FROM "KFZ12OT1"  										/*전표품의내역 삭제*/
			WHERE ( "KFZ12OT1"."SAUPJ"    = :sSaupj  ) AND  
					( "KFZ12OT1"."BAL_DATE" = :sBalDate ) AND  
					( "KFZ12OT1"."UPMU_GU"  = :sUpmuGu ) AND  
					( "KFZ12OT1"."JUN_NO"   = :lJunNo ) ;
		
		/*수금자료 전표 발행 취소*/
		UPDATE "KIF04OT0"  
     		SET "BAL_DATE" = null,   
 				 "UPMU_GU" = null,   
				 "BJUN_NO" = null
		WHERE ( "KIF04OT0"."SAUPJ"    = :sSaupj  ) AND ( "KIF04OT0"."BAL_DATE" = :sBalDate ) AND  
				( "KIF04OT0"."UPMU_GU"  = :sUpmuGu ) AND ( "KIF04OT0"."BJUN_NO"  = :lJunNo )   ;
		IF SQLCA.SQLCODE <> 0 THEN
			F_MessageChk(12,'[수금자료]')
			SetPointer(Arrow!)
			Return -1
		END IF
	END IF
NEXT
COMMIT;

//String sJipFrom,sJipTo,sJipFlag
//
//SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)    INTO :sJipFlag  				/*집계 여부*/
//	FROM "SYSCNFG"  
//   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 8 ) AND  
//         ( "SYSCNFG"."LINENO" = '1' )   ;
//IF SQLCA.SQLCODE <> 0 THEN 
//	sJipFlag = 'N'
//ELSE
//	IF IsNull(sJipFlag) OR sJipFlag = "" THEN sJipFlag = 'N'
//END IF
//
//IF sJipFlag = 'Y' THEN
//	sJipFrom = dw_delete.GetItemString(1,"min_ym")
//	sJipTo   = dw_delete.GetItemString(1,"max_ym")
//	
//	//stored procedure로 계정별,거래처별 상위 집계 처리(시작년월,종료년월)
//	sle_msg.text ="계정별,거래처별 월집계 갱신처리 중입니다..."
//	F_ACC_SUM(sJipFrom,sJipTo)
//	
//	//전사로 집계('00'월)
//	F_ACC_SUM(Left(sJipFrom,4)+"00",Left(sJipTo,4)+"00")
//	
//	//stored procedure로 사업부문별 상위 집계 처리(시작년월,종료년월)
//	sle_msg.text ="사업부문별 월집계 갱신처리 중입니다..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'G')
//	
//	//stored procedure로 사업부문별 거래처별 집계 처리(시작년월,종료년월)
//	sle_msg.text ="사업부문별 거래처별 월집계 갱신처리 중입니다..."
//	F_SAUP_RESTORE(sJipFrom,sJipTo,'C')
//END IF
//
SetPointer(Arrow!)
Return 1

end function

public function integer wf_insert_kfz12otd (string sstatus, integer irow, string ssaupj, string sbaldate, long lbjunno, long llinno);String   sFullJunNo,sBillNo,&
			sSaup_no,sbnk_cd,sbbal_dat,sbman_dat,sbill_nm,sbill_ris,sbill_gu,sbill_jigu,schu_ymd,schu_bnk,sbill_ntinc,&
			sbill_change_date,stemp_bil_yn,slimit_aplgbn
Integer  iBilCnt
Double   dBillAmt

sFullJunNo = '00000'+ String(Integer(sSaupj),'00')+sBalDate+sUpmuGbn+String(lBJunNo,'0000')+String(lLinNo,'000')

IF sStatus = '9' THEN										/*부도어음 회수*/
	sBillNo = dw_group_detail_cause.GetItemString(iRow,"budo_bill_no")

	select saup_no,			bnk_cd,		bbal_dat,		bman_dat,		bill_amt,		bill_nm,
			 bill_ris,			bill_gu,		bill_jigu,		chu_ymd,			chu_bnk,			bill_ntinc,
			 bill_change_date,				temp_bill_yn,						limit_aplgbn
	   into :sSaup_no,		:sbnk_cd,	:sbbal_dat,		:sbman_dat,		:dBillAmt,		:sbill_nm,
			  :sbill_ris,		:sbill_gu,	:sbill_jigu,	:schu_ymd,		:schu_bnk,		:sbill_ntinc,
			  :sbill_change_date,			:stemp_bil_yn,						:slimit_aplgbn
		from kfm02ot0
		where bill_no = :sBillNo ;

	iBilCnt = dw_rbill.InsertRow(0)
	dw_rbill.SetItem(iBilCnt,"bill_no",  	 sBillNo)
	dw_rbill.SetItem(iBilCnt,"saup_no",  	 sSaup_No) 
	dw_rbill.SetItem(iBilCnt,"bbal_dat", 	 sbbal_dat)
	dw_rbill.SetItem(iBilCnt,"bman_dat", 	 sbMan_Dat)
	dw_rbill.SetItem(iBilCnt,"bnk_cd",   	 sBnk_cd)
	dw_rbill.SetItem(iBilCnt,"bill_gu",  	 sBill_Gu)
	dw_rbill.SetItem(iBilCnt,"bill_jigu",	 sBill_JiGu)
	dw_rbill.SetItem(iBilCnt,"bill_nm",  	 sBill_nm)
	dw_rbill.SetItem(iBilCnt,"bill_ris", 	 sBill_Ris)
	dw_rbill.SetItem(iBilCnt,"status",  	 '9')	
	dw_rbill.SetItem(iBilCnt,"temp_bill_yn",sTemp_Bil_Yn)
	dw_rbill.SetItem(iBilCnt,"limit_aplgbn",sLimit_AplGbn)
	dw_rbill.SetItem(iBilCnt,"bill_amt", 	 dBillAmt)
	dw_rbill.SetItem(iBilCnt,"budo_amt", 	 dw_group_detail_cause.GetItemNumber(iRow,"ipgum_amt"))
	dw_rbill.SetItem(iBilCnt,"remark1", 	 '부도어음 회수')
	dw_rbill.SetItem(iBilCnt,"owner_saupj", '10')
	dw_rbill.SetItem(iBilCnt,"full_junno",  sFullJunNo)				

	dw_rbill.SetItem(iBilCnt,"saupj",   sSaupj)
	dw_rbill.SetItem(iBilCnt,"bal_date",sBalDate)
	dw_rbill.SetItem(iBilCnt,"upmu_gu", sUpmuGbn)
	dw_rbill.SetItem(iBilCnt,"bjun_no", lBJunNo)
	dw_rbill.SetItem(iBilCnt,"lin_no",  lLinNo)
ELSE	
	iBilCnt = dw_rbill.InsertRow(0)
	dw_rbill.SetItem(iBilCnt,"bill_no",  	 dw_group_detail_type.GetItemString(iRow,"bill_no"))
	dw_rbill.SetItem(iBilCnt,"saup_no",  	 dw_group_detail_type.GetItemString(iRow,"cvcod")) 
	dw_rbill.SetItem(iBilCnt,"bbal_dat", 	 dw_group_detail_type.GetItemString(iRow,"bbal_date"))
	dw_rbill.SetItem(iBilCnt,"bman_dat", 	 dw_group_detail_type.GetItemString(iRow,"bman_date"))
	dw_rbill.SetItem(iBilCnt,"bnk_cd",   	 dw_group_detail_type.GetItemString(iRow,"bill_bank"))
	dw_rbill.SetItem(iBilCnt,"bill_gu",  	 dw_group_detail_type.GetItemString(iRow,"bill_gu"))
	dw_rbill.SetItem(iBilCnt,"bill_jigu",	 dw_group_detail_type.GetItemString(iRow,"bill_jigu"))
	dw_rbill.SetItem(iBilCnt,"bill_nm",  	 dw_group_detail_type.GetItemString(iRow,"bill_nm"))
	dw_rbill.SetItem(iBilCnt,"status",  	 '1')
	dw_rbill.SetItem(iBilCnt,"temp_bill_yn",dw_group_detail_type.GetItemString(iRow,"temp_bill_yn"))
	dw_rbill.SetItem(iBilCnt,"bill_amt", 	 dw_group_detail_type.GetItemNumber(iRow,"ipgum_amt"))
	
	dw_rbill.SetItem(iBilCnt,"remark1", 	 '어음으로 수금')
	dw_rbill.SetItem(iBilCnt,"owner_saupj", sSaupj)
	dw_rbill.SetItem(iBilCnt,"full_junno",  sFullJunNo)				

	dw_rbill.SetItem(iBilCnt,"saupj",   sSaupj)
	dw_rbill.SetItem(iBilCnt,"bal_date",sBalDate)
	dw_rbill.SetItem(iBilCnt,"upmu_gu", sUpmuGbn)
	dw_rbill.SetItem(iBilCnt,"bjun_no", lBJunNo)
	dw_rbill.SetItem(iBilCnt,"lin_no",  lLinNo)
	
	if dw_group_detail_type.GetItemString(iRow,"cmsyn") = 'Y' then
		Long    lChuJunNo
		
		lChuJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,'Z',sBalDate)						/*전표번호 채번*/
		
		sFullJunNo = '00000'+ String(Integer(sSaupj),'00')+sBalDate+'Z'+String(lChuJunNo,'0000')+String(1,'000')
		
		iBilCnt = dw_rbill.InsertRow(0)
		dw_rbill.SetItem(iBilCnt,"bill_no",  	 dw_group_detail_type.GetItemString(iRow,"bill_no"))
		dw_rbill.SetItem(iBilCnt,"saup_no",  	 dw_group_detail_type.GetItemString(iRow,"cvcod")) 
		dw_rbill.SetItem(iBilCnt,"bbal_dat", 	 dw_group_detail_type.GetItemString(iRow,"bbal_date"))
		dw_rbill.SetItem(iBilCnt,"bman_dat", 	 dw_group_detail_type.GetItemString(iRow,"bman_date"))
		dw_rbill.SetItem(iBilCnt,"bnk_cd",   	 dw_group_detail_type.GetItemString(iRow,"bill_bank"))
		dw_rbill.SetItem(iBilCnt,"bill_gu",  	 dw_group_detail_type.GetItemString(iRow,"bill_gu"))
		dw_rbill.SetItem(iBilCnt,"bill_jigu",	 dw_group_detail_type.GetItemString(iRow,"bill_jigu"))
		dw_rbill.SetItem(iBilCnt,"bill_nm",  	 dw_group_detail_type.GetItemString(iRow,"bill_nm"))
		dw_rbill.SetItem(iBilCnt,"status",  	 '3')
		dw_rbill.SetItem(iBilCnt,"temp_bill_yn",dw_group_detail_type.GetItemString(iRow,"temp_bill_yn"))
		dw_rbill.SetItem(iBilCnt,"bill_amt", 	 dw_group_detail_type.GetItemNumber(iRow,"ipgum_amt"))
		
		dw_rbill.SetItem(iBilCnt,"remark1", 	 '추심-CMS')
		dw_rbill.SetItem(iBilCnt,"owner_saupj", sSaupj)
		dw_rbill.SetItem(iBilCnt,"full_junno",  sFullJunNo)				
	
		dw_rbill.SetItem(iBilCnt,"chu_ymd",     sBalDate)
		dw_rbill.SetItem(iBilCnt,"chu_bnk",     dw_group_detail_type.GetItemString(iRow,"cms_bank"))	
		dw_rbill.SetItem(iBilCnt,"alc_gu",      'Y')
		dw_rbill.SetItem(iBilCnt,"acc_date",    sBalDate)
		dw_rbill.SetItem(iBilCnt,"jun_no",      lChuJunNo)
					
		dw_rbill.SetItem(iBilCnt,"saupj",       sSaupj)
		dw_rbill.SetItem(iBilCnt,"bal_date",    sBalDate)
		dw_rbill.SetItem(iBilCnt,"upmu_gu",     'Z')
		dw_rbill.SetItem(iBilCnt,"bjun_no",     lChuJunNo)
		dw_rbill.SetItem(iBilCnt,"lin_no",      1)	
	end if
END IF

Return 1
end function

public function integer wf_insert_sang (integer icurrow, string ssaupj, string sbaldate, string supmugu, long ljunno, integer llinno, double damount, string stype, string ssangcust, string sflag);/*반제 처리 = 반제전표번호를 읽어서 처리*/
String  sCrossNo, sSugumNo,sSaupjS,sAccDateS,sUpmuGuS,sBalDateS
Long    lJunNoS,lLinNoS,lBJunNos
Integer iInsertrow,iSugumSeq
Double  dCrossAmt,dTotalCrossAmt

sSugumNo = dw_rtv.GetItemString(icurrow,"sugum_no")

DECLARE Cursor_Sugum CURSOR FOR  
	SELECT "CROSSNO",			SUM(NVL("DAMOUNT",0))
		FROM "KIF04OT1"  
		WHERE ( "SABU" = '1' ) AND  ( "SUGUM_NO" = :sSugumNo ) AND
				( DECODE(:sFlag,'TYPE',"IPGUM_TYPE","IPGUM_CAUSE") = :sType) AND
				( "SANGCOD" = :sSangCust )
		GROUP BY "CROSSNO" ;
Open Cursor_Sugum;
Do While True
	Fetch Cursor_Sugum INTO :sCrossNo,		:dCrossAmt;
	IF SQLCA.SQLCODE <> 0 THEN EXIT
	
	sSaupjS   = Left(sCrossNo,2)
	sAccDateS = Mid(sCrossNo,3,8)
	sUpmuGuS  = Mid(sCrossNo,11,1)
	lJunNoS   = Long(Mid(sCrossNo,12,4))
	lLinNoS   = Integer(Mid(sCrossNo,16,3)) 
	sBalDateS = Mid(sCrossNo,19,8)
	lBJunNoS  = Long(Mid(sCrossNo,27,4)) 
	
	iInsertRow = dw_sang.InsertRow(0)
		
	dw_sang.SetItem(iInsertRow,"saupj",    sSaupjS)
	dw_sang.SetItem(iInsertRow,"acc_date", sAccDateS)
	dw_sang.SetItem(iInsertRow,"upmu_gu",  sUpmuGuS)
	dw_sang.SetItem(iInsertRow,"jun_no",   lJunNoS)
	dw_sang.SetItem(iInsertRow,"lin_no",   lLinNoS)
	dw_sang.SetItem(iInsertRow,"jbal_date",sBalDateS)
	dw_sang.SetItem(iInsertRow,"bjun_no",  lBJunNoS)
		
	dw_sang.SetItem(iInsertRow,"saupj_s",  sSaupj)
	dw_sang.SetItem(iInsertRow,"bal_date", sBaldate)
	dw_sang.SetItem(iInsertRow,"upmu_gu_s",sUpmugu)
	dw_sang.SetItem(iInsertRow,"bjun_no_s",lJunno)
	dw_sang.SetItem(iInsertRow,"lin_no_s", lLinNo)
	dw_sang.SetItem(iInsertRow,"amt_s",    dCrossAmt)
	
LOOP
Close Cursor_Sugum;

Return 1
end function

public function integer wf_update_fulljunno ();String sBillNo,sSaupj, sBalDate, sFullJunNo,sJunPoyNo,sUpmu = 'Z',sChuYmd,sChuBnk,sStatus = '3'
Long   lBJunNo,lLinNo,lSeqNo

Declare Cur_Chusim Cursor For
	select bill_no,			saupj,  		bal_date, 		bjun_no,		lin_no,		substr(full_junno,6,20),
			 chu_ymd,			chu_bnk
		from kfz12otd
		where upmu_gu = :sUpmu and substr(full_junno,1,5) = '00000';

Open Cur_Chusim;

Do While True
	Fetch Cur_Chusim INTO :sBillNo,		:sSaupj,		:sBalDate,		:lBJunNo,		:lLinNo,		:sJunPoyNo,
								 :sChuYmd,		:sChuBnk;
	IF sqlca.sqlcode <> 0 then Exit
	
	select max(nvl(to_number(substr(full_junno,1,5)),0))		into :lSeqNo
		from kfz12otd
		where bill_no = :sBillNo;
	IF SQLCA.SQLCODE <> 0 THEN
		LSeqNo = 0
	ELSE
		IF IsNull(LSeqNo) THEN LSeqNo = 0
	END IF
	LSeqNo = LSeqNo + 1
		
	sFullJunNo = String(lSeqNo,'00000') + sJunPoyNo
	
	update kfz12otd
		set full_junno = :sFullJunNo
		where saupj  = :sSaupj and bal_date = :sBalDate and upmu_gu = :sUpmu and
				bjun_no = :lBJunNo and lin_no = :lLinNo and bill_no = :sBillNo ;
				
	update kfm02ot0
		set status = :sStatus,   chu_ymd = :sChuYmd,		 chu_bnk = :sChuBnk
		where bill_no = :sBillNo;
Loop
Close Cur_Chusim;

Return 1
end function

public function integer wf_insert_kfz12ot0 (string ssaupj);/************************************************************************************/
/* 수금자료를 자동으로 전표 처리한다.																*/
/* 1. 차변 : 입금형태에 따라서 참조코드('38')의 참조명(S)의 계정과목으로 발생.		*/
/*           입금형태가 '예금'이고 지급수수료가 0이 아니면 지급수수료 발생.			*/
/*           (환경파일 : A- 1-34)																	*/
/* 2. 대변 : 입금사유에 따라서 참조코드('39')의 참조명(S)의 계정과목으로 발생.		*/
/************************************************************************************/
String   sAcc1_Cha,sAcc2_Cha,sAcc1_Dae,sAcc2_Dae,sDcGbn,sSuGumNo,sInsDesc,sInsType,sInsId,&
			sDepot,sBalDate,sDeptCode,sSdeptCode,sEmpNo,sFeeAcc1,sFeeAcc2,sAbNo,sAbName,&
			sChaDae,sYesanGbn,sSangGbn,sCusGbn,sRemark1,sSawonFlag,sFullJunNo
Integer  k,iCnt,i,lLinNo,iCurRow,iDetailDaeCount,iDetailChaCount,iBilCnt
Long     lJunNo
Double   dAmount,dSendFeeAmt

w_mdi_frame.sle_msg.text =""

w_mdi_frame.sle_msg.text ="수금 자동전표 처리 중 ..."

SetPointer(HourGlass!)

SELECT "SYSCNFG"."DATANAME"  					/*작성자 적용 (1:userid, 2:입금담당자)*/
	INTO :sSawonFlag  
   FROM "SYSCNFG"  
   WHERE ("SYSCNFG"."SYSGU" = 'A') AND ("SYSCNFG"."SERIAL" = 8) AND ("SYSCNFG"."LINENO" = '2');

FOR k = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(k,"chk") = '1' THEN	
		
		dw_junpoy.Reset()
		dw_sang.Reset()
		dw_rbill.Reset()
		dw_sungin.Reset()

//		sSaupj   = dw_rtv.GetItemString(k,"subu")
		sBalDate = dw_rtv.GetItemString(k,"ipgum_date") 			/*수금일자*/
		sInsId   = dw_rtv.GetItemString(k,"ipgum_emp_id") 			/*입금담당자*/
		
		sSuGumNo = dw_rtv.GetItemString(k,"sugum_no")	 			/*수금번호*/
				
		IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
			F_MessageChk(29,'[발행일자]')
			continue
		END IF
		
		/*전표번호 채번*/
		lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)
		lLinNo = 1
		
		IF sSawonFlag = '1' then									/*user-id*/
			sEmpNo     = gs_empno;			sDeptCode  = gs_dept;
			SELECT "COST_CD"  INTO :sSdeptCode  FROM "CIA02M"	WHERE "DEPT_CD" = :Gs_Dept;
		ELSE
			/*입금담당자 및 발의부서,원가부문*/
			SELECT "REFFPF"."RFGUB",   "P1_MASTER"."DEPTCODE",     "CIA02M"."COST_CD"  
				INTO :sEmpNo,   			:sDeptCode,   				:sSdeptCode  
				FROM "REFFPF",   "CIA02M",   "P1_MASTER"  
				WHERE ( "REFFPF"."RFGUB" = "P1_MASTER"."EMPNO" ) and  
						( "P1_MASTER"."DEPTCODE" = "CIA02M"."DEPT_CD"(+) ) and  
						(( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = '47' ) AND  
						( "REFFPF"."RFGUB" = :sInsId )) ;
			if sqlca.sqlcode = 100 then
				sEmpNo     = gs_empno
				sDeptCode  = gs_dept
				SELECT "COST_CD"  INTO :sSdeptCode  FROM "CIA02M"	WHERE "DEPT_CD" = :Gs_Dept;
			end if
		END IF
		
		iDetailChaCount = dw_group_detail_type.Retrieve(sSaupj,sSuGumNo)
		IF iDetailChaCount <=0 THEN Continue
		
		FOR i = 1 TO iDetailChaCount
			sDcGbn = '1'												/*차변*/
		
			sInsType    = dw_group_detail_type.GetItemString(i,"ipgum_type") 		/*입금형태*/
			
			dAmount     = dw_group_detail_type.GetItemNumber(i,"ipgum_amt")		/*수금금액*/
			dSendFeeAmt = dw_group_detail_type.GetItemNumber(i,"sendfee_amt")		/*지급수수료*/
			
			IF IsNull(dAmount) THEN dAmount = 0
			IF IsNull(dSendFeeAmt) THEN dSendFeeAmt = 0

			IF sInsType = '9' THEN Continue						/*동일어음 처리 안함*/
			/*차변계정:입금형태의 참조명(s)의 값*/
			SELECT SUBSTR("REFFPF"."RFNA2",1,5),  SUBSTR("REFFPF"."RFNA2",6,2),  
					 "KFZ01OM0"."SANG_GU",			  "KFZ01OM0"."CUS_GU",				"KFZ01OM0"."DC_GU" 
				INTO :sAcc1_Cha,						  :sAcc2_Cha,
					  :sSangGbn,						  :sCusGbn,								:sChaDae
				FROM "REFFPF", "KFZ01OM0"  
				WHERE ( SUBSTR("REFFPF"."RFNA2",1,5) = "KFZ01OM0"."ACC1_CD" ) and  
         			( SUBSTR("REFFPF"."RFNA2",6,2) = "KFZ01OM0"."ACC2_CD" ) and  
						( "REFFPF"."RFCOD" = '38' ) AND  ( "REFFPF"."RFGUB" = :sInsType )   ;
						
			iCurRow = dw_junpoy.InsertRow(0)
				
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
				
			dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
			
			dw_junpoy.SetItem(iCurRow,"sawon",   sEmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount - dSendFeeAmt)
			dw_junpoy.SetItem(iCurRow,"descr",   f_get_refferance('38',sInsType) + ' 수금')
			
			dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdeptCode)
				
			IF sInsType = '2' THEN										/*예적금*/
				sDepot = dw_group_detail_type.GetItemString(i,"save_code")
				
				SELECT "KFM04OT0"."ACC1_CD",   "KFM04OT0"."ACC2_CD",	
						 "KFM04OT0"."AB_NO", 	 "KFM04OT0"."AB_NAME"
					INTO :sAcc1_Cha,   			 :sAcc2_Cha,				
						  :sAbNo,					 :sAbName
					FROM "KFM04OT0"  
					WHERE "KFM04OT0"."AB_DPNO" = :sDepot   ;
	
				dw_junpoy.SetItem(iCurRow,"saup_no", sDepot) 
				dw_junpoy.SetItem(iCurRow,"in_nm",   sAbName+'['+sAbNo+']')  
				
				dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
				dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
			ELSEIF sInsType = '1' THEN							/*어음*/
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_group_detail_type.GetItemString(i,"cvcod")) 
				dw_junpoy.SetItem(iCurRow,"in_nm",   dw_group_detail_type.GetItemString(i,"cvname")) 
				dw_junpoy.SetItem(iCurRow,"rbill_gu",'Y')
				dw_junpoy.SetItem(iCurRow,"kwan_no", dw_group_detail_type.GetItemString(i,"bill_no")) 
				dw_junpoy.SetItem(iCurRow,"k_eymd",  dw_group_detail_type.GetItemString(i,"bman_date")) 
				
				sFullJunNo = '00000'+ String(Integer(sSaupj),'00')+sBalDate+sUpmuGbn+&
					       											String(lJunNo,'0000')+String(lLinNo,'000')
				IF Wf_Insert_Kfz12otd('1',i,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
					dw_junpoy.SetItem(iCurRow,"rbill_gu",'N') 	
					Return -1
				ELSE
					dw_junpoy.SetItem(iCurRow,"rbill_gu",'Y') 
				END IF
	
				dw_junpoy.SetItem(iCurRow,"descr",  F_Get_Refferance('BJ',dw_group_detail_type.GetItemString(i,"bill_gu"))+' '+&
																dw_group_detail_type.GetItemString(i,"bill_bank"))
			/*외상매입금상계,가수금,미지급금(일반),미지급금(장려금)*/
			ELSEIF sInsType = '4' OR sInsType = '5' or sInsType = '6' or sInsType = '7' THEN	
				dw_junpoy.SetItem(iCurRow,"saup_no", dw_group_detail_type.GetItemString(i,"cvcod")) 
				dw_junpoy.SetItem(iCurRow,"in_nm",   dw_group_detail_type.GetItemString(i,"cvname")) 
				
				IF sSangGbn = 'Y' and sDcGbn <> sChaDae THEN
					IF Wf_Insert_Sang(k,sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo,dAmount,sInsType,&
														dw_group_detail_type.GetItemString(i,"cvcod"),'TYPE') = 1 THEN	
						dw_junpoy.SetItem(iCurRow,"cross_gu",'Y') 
					ELSE
						Return -1
					END IF				
				ELSE
					dw_junpoy.SetItem(iCurRow,"cross_gu",'N') 
				END IF
			ELSE
				IF sCusGbn = 'Y' THEN
					dw_junpoy.SetItem(iCurRow,"saup_no", dw_group_detail_type.GetItemString(i,"cvcod")) 
					dw_junpoy.SetItem(iCurRow,"in_nm",   dw_group_detail_type.GetItemString(i,"cvname")) 					
				END IF
			END IF
			
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Cha)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Cha)
			
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			lLinNo = lLinNo + 1
			
			/*지급수수료 <> 0 and 입금형태가 '예금' 이면 지급수수료 발생 - 차변*/
			IF dSendFeeAmt <> 0 AND sInsType = '2' THEN
				SELECT SUBSTR("SYSCNFG"."DATANAME",1,5), SUBSTR("SYSCNFG"."DATANAME",6,2)	
					INTO :sFeeAcc1,							  :sFeeAcc2
					FROM "SYSCNFG"  
					WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
							( "SYSCNFG"."LINENO" = '34' )   ;
							
				SELECT "DC_GU", "YESAN_GU", "REMARK1"   INTO :sChaDae, :sYesanGbn, :sRemark1
			   	FROM "KFZ01OM0"  
			   	WHERE "ACC1_CD" = :sFeeAcc1 AND "ACC2_CD" = :sFeeAcc2;
				
				sDcGbn = '1'
				
				iCurRow = dw_junpoy.InsertRow(0)
				
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
					
				dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", sFeeAcc1)
				dw_junpoy.SetItem(iCurRow,"acc2_cd", sFeeAcc2)
				dw_junpoy.SetItem(iCurRow,"sawon",   sEmpNo)
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				
				dw_junpoy.SetItem(iCurRow,"amt",     dSendFeeAmt)
				dw_junpoy.SetItem(iCurRow,"descr",   '송금수수료')

				IF sRemark1 = 'Y' and sDcGbn = sChaDae THEN
					dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdeptCode)
				END IF
				
				IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcGbn = sChaDae THEN
					dw_junpoy.SetItem(iCurRow,"cdept_cd",sDeptCode)
				END IF
			
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				lLinNo = lLinNo + 1
			END IF
		NEXT
		
		iDetailDaeCount = dw_group_detail_cause.Retrieve(sSaupj,sSuGumNo)
		IF iDetailDaeCount <=0 THEN Continue
		
		FOR i = 1 TO iDetailDaeCount
			sDcGbn = '2'												/*대변*/
			
			sInsDesc = dw_group_detail_cause.GetItemString(i,"ipgum_cause") 			/*입금사유*/
			dAmount  = dw_group_detail_cause.GetItemNumber(i,"ipgum_amt")				/*수금금액*/
			IF IsNull(dAmount) THEN dAmount = 0
		
			/*대변계정:입금사유의 참조명(s)의 값*/
			SELECT SUBSTR("REFFPF"."RFNA2",1,5),  SUBSTR("REFFPF"."RFNA2",6,2),  "KFZ01OM0"."SANG_GU",	"KFZ01OM0"."DC_GU"  
				INTO :sAcc1_Dae,						  :sAcc2_Dae,							:sSangGbn,					:sChaDae  
				FROM "REFFPF", "KFZ01OM0"  
				WHERE ( SUBSTR("REFFPF"."RFNA2",1,5) = "KFZ01OM0"."ACC1_CD" ) and  
         			( SUBSTR("REFFPF"."RFNA2",6,2) = "KFZ01OM0"."ACC2_CD" ) and  
						( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = '39' ) AND  
						( "REFFPF"."RFGUB" = :sInsDesc )   ;
		
			iCurRow = dw_junpoy.InsertRow(0)
		
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  lLinNo)
		
			dw_junpoy.SetItem(iCurRow,"dept_cd", sDeptCode)	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", sAcc1_Dae)
			dw_junpoy.SetItem(iCurRow,"acc2_cd", sAcc2_Dae)
			dw_junpoy.SetItem(iCurRow,"sawon",   sEmpNo)
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		
			dw_junpoy.SetItem(iCurRow,"descr",   dw_group_detail_cause.GetItemString(i,"recv_bigo"))
			
			dw_junpoy.SetItem(iCurRow,"sdept_cd",sSdeptCode)
			dw_junpoy.SetItem(iCurRow,"saup_no", dw_group_detail_cause.GetItemString(i,"cvcod")) 
			dw_junpoy.SetItem(iCurRow,"in_nm",   dw_group_detail_cause.GetItemString(i,"cvname")) 
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			
			IF sInsDesc = '1' THEN									/*외상매출금*/
				dw_junpoy.SetItem(iCurRow,"amt",   dw_group_detail_cause.GetItemNumber(i,"ipgum_amt"))
			ELSEIF sInsDesc = '2' THEN								/*부도어음*/
				dw_junpoy.SetItem(iCurRow,"amt",    dw_group_detail_cause.GetItemNumber(i,"ipgum_amt"))			
				dw_junpoy.SetItem(iCurRow,"kwan_no",dw_group_detail_cause.GetItemString(i,"budo_bill_no"))
				
				dw_junpoy.SetItem(iCurRow,"exp_gu",'9')
				
				IF Wf_Insert_Kfz12otd('9',i,sSaupj,sBalDate,lJunNo,lLinNo) = -1 THEN
					dw_junpoy.SetItem(iCurRow,"rbill_gu",'N') 	
					Return -1
				ELSE
					dw_junpoy.SetItem(iCurRow,"rbill_gu",'Y') 
				END IF

			ELSE
				dw_junpoy.SetItem(iCurRow,"amt",   dw_group_detail_cause.GetItemNumber(i,"ipgum_amt"))			
				
			END IF
			IF sSangGbn = 'Y' AND sDcGbn <> sChaDae THEN
				IF Wf_Insert_Sang(k,sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo,dAmount,sInsDesc,&
													dw_group_detail_cause.GetItemString(i,"cvcod"),'CAUSE') = 1 THEN	
					dw_junpoy.SetItem(iCurRow,"cross_gu",'Y') 
				ELSE
					Return -1
				END IF
			ELSE
				dw_junpoy.SetItem(iCurRow,"cross_gu",'N') 
			END IF
				
			lLinNo = lLinNo + 1
		NEXT

		IF dw_rbill.Update() <> 1 THEN
			F_MessageChk(13,'[받을어음]')
			SetPointer(Arrow!)
			Return -1
		END IF
		
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(13,'[미승인전표]')
			SetPointer(Arrow!)
			Return -1
		ELSE				
			IF dw_sang.Update() <> 1 THEN
				F_MessageChk(13,'[반제]')
				SetPointer(Arrow!)
				Return -1
			END IF

			/*수금 저장*/
			UPDATE "KIF04OT0"  
			  SET "SAUPJ" = :sSaupj,   
					"BAL_DATE" = :sBalDate,   
					"UPMU_GU" = :sUpmuGbn,   
					"BJUN_NO" = :lJunNo
			WHERE ( "KIF04OT0"."SUGUM_NO" = :sSugumNo )   ;
			IF SQLCA.SQLCODE <> 0 THEN
				F_MessageChk(13,'[수금자료]')
				SetPointer(Arrow!)
				Return -1
			END IF
			
			/*자동 승인 처리*/
			IF LsAutoSungGbn = 'Y' THEN
				w_mdi_frame.sle_msg.text = '승인 처리 중...'
				IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
					SetPointer(Arrow!)
					Return -1
				END IF	
			END IF
		END IF
	END IF
NEXT
			
/*CMS건 전표의 어음의 처리 순서 갱신:2001.10.08 추가*/
if Wf_Update_FullJunNo() = -1 then 
	Return -1
else
	COMMIT;

	w_mdi_frame.sle_msg.text ="수금 전표 처리 완료!!"
end if

Return 1
end function

on w_kifa05.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_group_detail_cause=create dw_group_detail_cause
this.dw_print=create dw_print
this.dw_rbill=create dw_rbill
this.dw_sang=create dw_sang
this.dw_group_detail_type=create dw_group_detail_type
this.dw_ip=create dw_ip
this.cbx_all=create cbx_all
this.dw_rtv=create dw_rtv
this.dw_delete=create dw_delete
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.dw_junpoy
this.Control[iCurrent+6]=this.dw_sungin
this.Control[iCurrent+7]=this.dw_group_detail_cause
this.Control[iCurrent+8]=this.dw_print
this.Control[iCurrent+9]=this.dw_rbill
this.Control[iCurrent+10]=this.dw_sang
this.Control[iCurrent+11]=this.dw_group_detail_type
this.Control[iCurrent+12]=this.dw_ip
this.Control[iCurrent+13]=this.cbx_all
this.Control[iCurrent+14]=this.dw_rtv
this.Control[iCurrent+15]=this.dw_delete
end on

on w_kifa05.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_group_detail_cause)
destroy(this.dw_print)
destroy(this.dw_rbill)
destroy(this.dw_sang)
destroy(this.dw_group_detail_type)
destroy(this.dw_ip)
destroy(this.cbx_all)
destroy(this.dw_rtv)
destroy(this.dw_delete)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"sabu",gs_saupj)

dw_ip.SetItem(dw_ip.Getrow(),"saledtf",Left(f_today(),6)+"01")
dw_ip.SetItem(dw_ip.Getrow(),"saledtt",f_today())

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

dw_delete.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_group_detail_cause.SetTransObject(SQLCA)
dw_group_detail_type.SetTransObject(SQLCA)

dw_rbill.SetTransObject(SQLCA)
dw_sang.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

p_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '05' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()


end event

type dw_insert from w_inherite`dw_insert within w_kifa05
boolean visible = false
integer x = 41
integer y = 3084
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kifa05
boolean visible = false
integer y = 3120
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kifa05
boolean visible = false
integer y = 3120
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kifa05
integer x = 3922
integer y = 16
integer taborder = 70
boolean originalsize = true
string picturename = "C:\erpman\image\상세조회_up.gif"
end type

event p_search::clicked;call super::clicked;Integer iSelectRow

SetNull(Gs_Code)

IF rb_1.Checked = True THEN
	iSelectRow = dw_rtv.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return

	Gs_Code = dw_rtv.GetItemString(iSelectRow,"sugum_no")	 			/*수금번호*/
	
	Open(w_kifa05a)
ELSE
	iSelectRow = dw_delete.GetSelectedRow(0)

	IF iSelectRow <=0 THEN Return

	Gs_Code = dw_delete.GetItemString(iSelectRow,"sugum_no")	 			/*수금번호*/
	
	Open(w_kifa05a)
END IF
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\상세조회_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\상세조회_up.gif"
end event

type p_ins from w_inherite`p_ins within w_kifa05
boolean visible = false
integer y = 3120
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kifa05
integer y = 16
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_kifa05
boolean visible = false
integer y = 3120
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kifa05
boolean visible = false
integer y = 3120
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sUpmuGu,sBalDate,sSuGumNo,sPrtGbn = '0',sJunGbn = '1'
Long    lBJunNo,lJunNo
Integer i,iDetailCount,iRtnVal

IF MessageBox("확 인", "출력하시겠습니까 ?", Question!, OkCancel!, 2) = 2 THEN RETURN

F_Setting_Dw_Junpoy(LsAutoSungGbn,sJunGbn,dw_print)

Integer iCount
	
iCount = dw_ip.GetItemNumber(1,"empcnt")

if iCount = 1 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl3.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	
elseif iCount = 2 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible = 0")
	dw_print.Modify("t_gl3.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
elseif iCount = 3 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible = 0")
	dw_print.Modify("t_gl3.visible = 0")
	dw_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
elseif iCount = 4 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible = 0")
	dw_print.Modify("t_gl3.visible = 0")
	dw_print.Modify("t_gl4.visible = 0")
	dw_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
elseif iCount = 5 then
	dw_print.Modify("t_gl1.visible = 0")
	dw_print.Modify("t_gl2.visible = 0")
	dw_print.Modify("t_gl3.visible = 0")
	dw_print.Modify("t_gl4.visible = 0")
	dw_print.Modify("t_gl5.visible = 0")
end if

FOR i = 1 TO dw_rtv.RowCount()
	IF dw_rtv.GetItemString(i,"chk") = '1' THEN
		sSaupj   = dw_rtv.GetItemString(i,"subu")
		sSuGumNo = dw_rtv.GetItemString(i,"sugum_no")	 			/*수금번호*/
		
		iDetailCount = dw_group_detail_Cause.Retrieve(sSaupj,sSuGumNo)
		IF iDetailCount <=0 THEN Continue
		
		sSaupj   = dw_group_detail_Cause.GetItemString(1,"saupj")
		sBalDate = dw_group_detail_Cause.GetItemString(1,"bal_date") 
		sUpmuGu  = dw_group_detail_Cause.GetItemString(1,"upmu_gu") 
		lBJunNo  = dw_group_detail_Cause.GetItemNumber(1,"bjun_no") 
		
		select distinct jun_no into :lJunNo	from kfz10ot0 
			where saupj = :sSaupj and bal_date = :sBalDate and upmu_gu = :sUpmuGu and bjun_no = :lBJunNo;
		if sqlca.sqlcode = 0 then
			iRtnVal = F_Call_JunpoyPrint(dw_print,'Y',sJunGbn,sSaupj,sBalDate,sUpmuGu,lJunNo,sPrtGbn,'P')
		else
			iRtnVal = F_Call_JunpoyPrint(dw_print,'N',sJunGbn,sSaupj,sBalDate,sUpmuGu,lBJunNo,sPrtGbn,'P')
		end if
		IF iRtnVal = -1 THEN
			F_MessageChk(14,'')
			Return -1
		ELSEIF iRtnVal = -2 THEN
			Return 1
		ELSE	
			sPrtGbn = '1'
		END IF
	END IF
NEXT

end event

type p_inq from w_inherite`p_inq within w_kifa05
integer x = 4096
integer y = 16
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sSaupj,sSaleDtf,sSaleDtT

IF dw_ip.AcceptText() = -1 THEN RETURN

sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"sabu")
sSaleDtf = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"saledtf"))
sSaleDtt = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"saledtt"))

IF ssaupj ="" OR IsNull(ssaupj) THEN
	F_MessageChk(1,'[사업장]')	
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return 
END IF

IF sSaleDtf = "" OR IsNull(sSaledtF) THEN
	F_MessageChk(1,'[수금일자]')	
	dw_ip.SetColumn("saledtf")
	dw_ip.SetFocus()
	Return 
END IF
IF sSaleDtt = "" OR IsNull(sSaledtt) THEN
	F_MessageChk(1,'[수금일자]')	
	dw_ip.SetColumn("saledtt")
	dw_ip.SetFocus()
	Return 
END IF

dw_rtv.SetRedraw(False)
IF rb_1.Checked =True THEN
	IF dw_rtv.Retrieve(sSaupj,sSaledtf,sSaledtt) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
ELSEIF rb_2.Checked =True THEN
	IF dw_delete.Retrieve(sSaupj,sSaledtf,sSaledtt) <= 0 THEN
		F_MessageChk(14,'')
		dw_ip.SetFocus()
	END IF
END IF
dw_rtv.SetRedraw(True)

p_mod.Enabled =True
p_search.Enabled =True

cbx_all.Checked = False
end event

type p_del from w_inherite`p_del within w_kifa05
boolean visible = false
integer y = 3120
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kifa05
integer x = 4270
integer y = 16
string pointer = "C:\erpman\cur\create.cur"
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_mod::clicked;call super::clicked;String sSaupj

IF dw_ip.AcceptText() = -1 THEN RETURN

sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"sabu")

IF rb_1.Checked =True THEN
	IF dw_rtv.RowCount() <=0 THEN Return
	
	IF Wf_Insert_Kfz12ot0(sSaupj) = -1 THEN
		Rollback;
		Return
	END IF
	Commit;
	
	p_print.TriggerEvent(Clicked!)
	
ELSE
	IF dw_delete.RowCount() <=0 THEN Return
	
	IF Wf_Delete_Kfz12ot0() = -1 THEN
		Rollback;
		Return
	ELSE
		Commit;
	END IF
END IF

p_inq.TriggerEvent(Clicked!)
end event

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type cb_exit from w_inherite`cb_exit within w_kifa05
integer x = 4302
integer y = 2752
end type

type cb_mod from w_inherite`cb_mod within w_kifa05
integer x = 3941
integer y = 2752
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kifa05
integer x = 2350
integer y = 2748
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kifa05
integer x = 2693
integer y = 2748
end type

type cb_inq from w_inherite`cb_inq within w_kifa05
integer x = 3579
integer y = 2752
end type

type cb_print from w_inherite`cb_print within w_kifa05
integer x = 2706
integer y = 2748
end type

type st_1 from w_inherite`st_1 within w_kifa05
end type

type cb_can from w_inherite`cb_can within w_kifa05
integer x = 2345
integer y = 2628
end type

type cb_search from w_inherite`cb_search within w_kifa05
integer x = 3113
integer y = 2756
integer width = 439
string text = "수금상세(&V)"
end type



type sle_msg from w_inherite`sle_msg within w_kifa05
integer height = 88
end type



type gb_button1 from w_inherite`gb_button1 within w_kifa05
integer x = 2304
integer y = 2580
integer height = 308
end type

type gb_button2 from w_inherite`gb_button2 within w_kifa05
integer x = 3067
integer y = 2696
integer width = 1609
end type

type rr_1 from roundrectangle within w_kifa05
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 180
integer width = 4558
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

type gb_1 from groupbox within w_kifa05
integer x = 2656
integer width = 887
integer height = 168
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "작업선택"
end type

type rb_1 from radiobutton within w_kifa05
integer x = 2688
integer y = 60
integer width = 416
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표발행처리"
boolean checked = true
end type

event clicked;IF rb_1.Checked =True THEN
	dw_rtv.Title ="수금 자동전표 발행"
	
	dw_rtv.Visible =True
	dw_delete.Visible =False
END IF
dw_rtv.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()





end event

type rb_2 from radiobutton within w_kifa05
integer x = 3109
integer y = 60
integer width = 421
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전표삭제처리"
end type

event clicked;IF rb_2.Checked =True THEN
	dw_delete.Title ="수금 자동전표 삭제"
	
	dw_rtv.Visible =False
	dw_delete.Visible =True
END IF
dw_delete.Reset()

dw_ip.SetColumn("saledtf")
dw_ip.SetFocus()


end event

type dw_junpoy from datawindow within w_kifa05
boolean visible = false
integer x = 50
integer y = 2608
integer width = 1070
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "전표 저장"
string dataobject = "d_kifa106"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

event dberror;MessageBox('error',sqlerrtext+sTRING(sqldbcode)+' '+String(row))
end event

type dw_sungin from datawindow within w_kifa05
boolean visible = false
integer x = 50
integer y = 2716
integer width = 1070
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "승인전표 라인별 저장"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

event dberror;MessageBox('error',sqlerrtext+sTRING(sqldbcode)+String(row))
end event

type dw_group_detail_cause from datawindow within w_kifa05
boolean visible = false
integer x = 1166
integer y = 2524
integer width = 1106
integer height = 108
boolean bringtotop = true
boolean titlebar = true
string title = "수금 자료 리스트(입금사유)"
string dataobject = "d_kifa055"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kifa05
boolean visible = false
integer x = 50
integer y = 2824
integer width = 1070
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "전표 인쇄"
string dataobject = "dw_kglb01_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_rbill from datawindow within w_kifa05
boolean visible = false
integer x = 1166
integer y = 2832
integer width = 1106
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "받을어음 저장"
string dataobject = "d_kifa054"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sang from datawindow within w_kifa05
boolean visible = false
integer x = 1166
integer y = 2736
integer width = 1106
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "반제처리내역 저장"
string dataobject = "d_kifa108"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_group_detail_type from datawindow within w_kifa05
boolean visible = false
integer x = 1166
integer y = 2632
integer width = 1106
integer height = 104
boolean bringtotop = true
boolean titlebar = true
string title = "수금 자료 리스트(입금형태)"
string dataobject = "d_kifa057"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ip from u_key_enter within w_kifa05
event ue_key pbm_dwnkey
integer x = 46
integer y = 20
integer width = 2592
integer height = 160
integer taborder = 10
string dataobject = "d_kifa051"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sBnkNo,sChoose,sdeptCode,sCust,sCustName,sDeptName
Integer i

SetNull(snull)

IF this.GetColumnName() ="sabu" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[사업장]")
		dw_ip.SetItem(1,"sabu",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() ="saledtf" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"수금일자")
		dw_ip.SetItem(1,"saledtf",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="saledtt" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"수금일자")
		dw_ip.SetItem(1,"saledtt",snull)
		Return 1
	END IF
END IF
end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="bnk_no" THEN
	
	OpenWithParm(W_Kfz04om0_POPUP,'5')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"bnk_no",lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"name",  lstr_custom.name)
	
END IF

end event

event getfocus;this.AcceptText()
end event

type cbx_all from checkbox within w_kifa05
integer x = 3566
integer y = 104
integer width = 338
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;Integer i

w_mdi_frame.sle_msg.text = '자료 선택 중...'
if cbx_all.Checked = True then
	IF rb_1.Checked =True THEN
		FOR i =1 TO dw_rtv.Rowcount()
			dw_rtv.SetItem(i,"chk",'1')
		NEXT
	ELSEIF rb_2.Checked =True THEN
		FOR i =1 TO dw_delete.Rowcount()
			dw_delete.SetItem(i,"chk",'1')
		NEXT
	END IF
else
	IF rb_1.Checked =True THEN
		FOR i =1 TO dw_rtv.Rowcount()
			dw_rtv.SetItem(i,"chk",'0')
		NEXT
	ELSEIF rb_2.Checked =True THEN
		FOR i =1 TO dw_delete.Rowcount()
			dw_delete.SetItem(i,"chk",'0')
		NEXT
	END IF	
end if
w_mdi_frame.sle_msg.text = ''
end event

type dw_rtv from datawindow within w_kifa05
integer x = 69
integer y = 188
integer width = 4526
integer height = 2044
integer taborder = 30
string dataobject = "d_kifa052"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;String  sGbn,sAcc1_Dae,sAcc2_Dae,sAcc1_Cha,sAcc2_Cha,sInsDesc,sInsType,snull
Integer iCount,iSelectCount

SetNull(snull)

IF this.GetcolumnName() = "chk" THEN
	sGbn = this.GetText()
	IF sGbn = "" OR IsNull(sGbn) THEN Return
	
	iSelectCount = this.GetItemNumber(1,"yescnt")
	IF IsNull(iSelectCount) THEN iSelectCount = 0
	
	IF sGbn = '1' AND iSelectCount >= 1 THEN
		this.SetItem(this.GetRow(),"chk",'0')
		Return 1
	END IF
	
//	sInsDesc = this.GetItemString(this.GetRow(),"ipgum_cause") 			/*입금사유*/
//	sInsType = this.GetItemString(this.GetRow(),"ipgum_type") 			/*입금형태*/
//	
//	IF sInsType = '4' THEN									/*차변계정-외상매입금*/
//		SELECT SUBSTR("REFFPF"."RFNA2",1,5),  SUBSTR("REFFPF"."RFNA2",6,2)
//    		INTO :sAcc1_Cha,						  :sAcc2_Cha  
//    		FROM "REFFPF"  
//   		WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = '38' ) AND  
//         		( "REFFPF"."RFGUB" = :sInsType )   ;
//		iCount = Wf_Insert_Sang(sAcc1_Cha,	sAcc2_Cha,	this.GetItemString(this.GetRow(),"cvcod"),&
//										0,		snull,		snull,	sUpmuGbn,	0,	0, True)			
//	END IF
//	
//	IF sInsDesc = '1' THEN									/*대변계정 - 외상매출금*/
//		SELECT SUBSTR("REFFPF"."RFNA2",1,5),  SUBSTR("REFFPF"."RFNA2",6,2)
//				INTO :sAcc1_Dae,						  :sAcc2_Dae  
//				FROM "REFFPF"  
//				WHERE ( "REFFPF"."SABU" = '1' ) AND ( "REFFPF"."RFCOD" = '39' ) AND  
//						( "REFFPF"."RFGUB" = :sInsDesc )   ;
//		iCount = Wf_Insert_Sang(sAcc1_Dae,	sAcc2_Dae,	this.GetItemString(this.GetRow(),"cvcod"),&
//										0,		snull,		snull,	sUpmuGbn,	0,	0, True)			
//	
//	END IF
//	
//	IF iCount = -1 THEN
//		F_MessageChk(16,'[외화외상매출 반제 자료 없슴]')
//		this.SetItem(this.GetRow(),"chk",'0')
//		Return 1	
//	END IF							
END IF
end event

event itemerror;Return 1
end event

event clicked;IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)	

end event

type dw_delete from datawindow within w_kifa05
integer x = 69
integer y = 188
integer width = 4526
integer height = 2044
integer taborder = 40
string dataobject = "d_kifa053"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF Row <=0 THEN Return

SelectRow(0,False)
SelectRow(Row,True)	

end event

