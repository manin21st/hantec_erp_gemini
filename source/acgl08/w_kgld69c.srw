$PBExportHeader$w_kgld69c.srw
$PBExportComments$합계잔액시산표 상세 조회-전표 조회
forward
global type w_kgld69c from w_inherite
end type
type cb_2 from commandbutton within w_kgld69c
end type
type cb_yesan from commandbutton within w_kgld69c
end type
type dw_rtv from datawindow within w_kgld69c
end type
type dw_kwan from datawindow within w_kgld69c
end type
type dw_ins2 from u_key_enter within w_kgld69c
end type
type dw_ins from u_key_enter within w_kgld69c
end type
type dw_print from datawindow within w_kgld69c
end type
type dw_sang from datawindow within w_kgld69c
end type
type dw_sungin from datawindow within w_kgld69c
end type
type dw_descr from datawindow within w_kgld69c
end type
type p_yesan from uo_picture within w_kgld69c
end type
type cb_ins2 from commandbutton within w_kgld69c
end type
type p_ok from uo_picture within w_kgld69c
end type
type rr_5 from roundrectangle within w_kgld69c
end type
end forward

global type w_kgld69c from w_inherite
string title = "전표 조회"
boolean minbox = false
windowtype windowtype = response!
boolean toolbarvisible = false
event ue_change_upmu pbm_custom01
cb_2 cb_2
cb_yesan cb_yesan
dw_rtv dw_rtv
dw_kwan dw_kwan
dw_ins2 dw_ins2
dw_ins dw_ins
dw_print dw_print
dw_sang dw_sang
dw_sungin dw_sungin
dw_descr dw_descr
p_yesan p_yesan
cb_ins2 cb_ins2
p_ok p_ok
rr_5 rr_5
end type
global w_kgld69c w_kgld69c

type variables
//금액체크구분,채번구분,승인구분//
Boolean  Ib_Amt_Chk,&
               Ib_ClickedFlag,&
               Ib_AlcFlag = False
//전표구분
//적요자동여부(환경)
//관리항목자동여부(환경)
//예산배분자동여부(환경)
//원가부문자동여부(환경)
//수정시 이전자료 상계처리여부,거래처
//전표송부 사용 여부
String      Is_UpmuGbn,                   &
				Is_JunGbn,							&
               Is_SysCnfg_DescFlag,    &
               Is_SysCnfg_InFlag,         &
               Is_SysCnfg_YesanFlag,  &
               Is_SysCnfg_WonGaFlag,&
               ls_SangGbn,ls_SangCust,&
               Is_AcRcvFlag

Long       lDbErrCode =0                      /*db error시 저장 체크*/
String      LsBudoAcc1,LsBudoAcc2

String      sAutoChk ='N'

s_Junpoy	Str_Junpoy
end variables

forward prototypes
public subroutine wf_clear_structure (string smod)
public function integer wf_requiredchk (string dw_curobj, integer il_currow)
public subroutine wf_sang_delete ()
public function integer wf_chk_chaip ()
public function integer wf_warndataloss (string as_titletext)
public function string wf_check_autosungin (string sdept)
public subroutine wf_change_data_clear (string scolid, integer icurrow)
public function integer wf_check_child (integer icurrow)
public function integer wf_check_cust (string scust, string schadae, ref string scustname)
public function integer wf_check_kwanno (string skwanno, string scolid)
public function integer wf_check_sdept (string sacc1, string sacc2, string sdeptcode)
public function integer wf_chk_standarddate (string sbaldate)
public function integer wf_control_ds_junpoy (string sflag, integer il_currentrow, integer ifrcnt, integer itocnt)
public subroutine wf_get_syscnfg ()
public function integer wf_insert_cash (string sjungbn, string saddmod)
public function integer wf_junpoy (string ssaupj, string sbaldate)
public subroutine wf_move_ins ()
public function integer wf_open_finance ()
public function integer wf_open_vat ()
public function integer wf_open_window (string sdcgbn)
public subroutine wf_button_sts ()
public function integer wf_get_account (string sacc1, string sacc2, string sdcgbn)
public subroutine wf_position_col (integer iposition, string scolid, string scolname, string sreqgbn, string schkcust)
public subroutine wf_append_init (integer llinno, integer irowcount)
public subroutine wf_insert_init ()
public subroutine wf_invisible_kwanlst (string scolid, string sstatus, integer itaborder, string sreqstatus)
public subroutine wf_setting_reflst (string sacc1, string sacc2, string schadae)
end prototypes

event ue_change_upmu;String sMsgParm

IF MessageBox("확 인","진행하던 작업을 취소합니다.계속하시겠습니까?",Question!,YesNo!) = 2 THEN Return

rollback;

OpenWithParm(w_kglb01z,'9')

IF Message.StringParm = '0' THEN
	Return
ELSE
	sMsgParm = Message.StringParm
	
	Is_UpmuGbn = Left(sMsgParm,1)							/*처리할 전표 구분*/
	
	IF Right(sMsgParm,1) = '1' THEN						/*금액 체크*/
		Ib_Amt_Chk = True		
	ELSE
		Ib_Amt_Chk = False	
	END IF
	
	Wf_Insert_Init()											/*화면 초기화*/
END IF

end event

public subroutine wf_clear_structure (string smod);
IF smod = 'ACCOUNT' THEN										/*계정과목*/
	SetNull(lstr_account.acc1_cd);			SetNull(lstr_account.acc2_cd);
	SetNull(lstr_account.acc1_nm);			SetNull(lstr_account.acc2_nm);
	SetNull(lstr_account.dcr_gu);				SetNull(lstr_account.cus_gu);
	SetNull(lstr_account.gbn1);				SetNull(lstr_account.bal_gu);
	SetNull(lstr_account.yesan_gu);			SetNull(lstr_account.sang_gu);
	SetNull(lstr_account.jubdae_gu);			SetNull(lstr_account.vat_gu);
	SetNull(lstr_account.paybil_gu);			SetNull(lstr_account.rcvbil_gu);
	SetNull(lstr_account.ch_gu);				SetNull(lstr_account.yu_gu);
	SetNull(lstr_account.fsang_gu);			SetNull(lstr_account.ija_gu);
	SetNull(lstr_account.admin_gu);			SetNull(lstr_account.use_windowc);
	SetNull(lstr_account.use_windowd);
ELSEIF sMod = 'CUST' THEN										/*거래처*/
	SetNull(lstr_custom.code);					SetNull(lstr_custom.name);
	SetNull(lstr_custom.gubun);				SetNull(lstr_custom.sano);
	SetNull(lstr_custom.bnk);					SetNull(lstr_custom.status);
	SetNull(lstr_custom.acc1);					SetNull(lstr_custom.acc2);
END IF
end subroutine

public function integer wf_requiredchk (string dw_curobj, integer il_currow);String  sSaupj,    sBalDate,  sUpmuGu,   sDeptCode,sChaDae,sAcc1,sAcc2,sDescr, sEmpNo,sCustCode,&
		  sCdeptCode,sInCode,   sKwanColId,sGetData, sSDeptCode,sGyulDate,sGbn5, sRefGbn,sDcGbn,  &
		  sTaxGbn
Long    lJunNo,lLinNo,k
Double  dAmount,dGetData,dQty,dSysAmount
Integer iFunValue

IF dw_curobj = 'dw_kglb01' THEN
	sSaupj    = dw_ins.GetItemString(il_currow,"saupj")
	sBalDate  = Trim(dw_ins.GetItemString(il_currow,"bal_date"))
	sDeptCode = dw_ins.GetItemString(il_currow,"dept_cd")
	sUpmuGu   = dw_ins.GetItemString(il_currow,"upmu_gu")
	
	lJunNo    = dw_ins.GetItemNumber(il_currow,"bjun_no")
	lLinNo    = dw_ins.GetItemNumber(il_currow,"lin_no")
	
	sEmpNo    = dw_ins.GetItemString(il_currow,"sawon")
	sChaDae   = dw_ins.GetItemString(il_currow,"dcr_gu")
	sAcc1     = dw_ins.GetItemString(il_currow,"acc1_cd")
	sAcc2     = dw_ins.GetItemString(il_currow,"acc2_cd")
	sDescr    = dw_ins.GetItemString(il_currow,"descr")
	
	IF sSaupj = "" OR IsNull(sSaupj) THEN
		F_MessageChk(1,'[사업장]')
		dw_ins.SetColumn("saupj")
		dw_ins.SetFocus()
		Return -1
	END IF
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		F_MessageChk(1,'[작성부서]')
		dw_ins.SetColumn("dept_cd")
		dw_ins.SetFocus()
		Return -1
	END IF

	IF sBalDate = "" OR IsNull(sBalDate) THEN
		F_MessageChk(1,'[작성일자]')
		dw_ins.SetColumn("bal_date")
		dw_ins.SetFocus()
		Return -1
	ELSE
		IF Wf_Chk_StandardDate(sBalDate) = -1 THEN							/*회계기준일 체크*/
			F_MessageChk(29,'[작성일자]')
			dw_ins.SetColumn("bal_date")
			dw_ins.SetFocus()
			Return -1
		END IF
	END IF
	IF lJunNo = 0 OR IsNull(lJunNo) THEN
		F_MessageChk(3,'')
		dw_ins.SetFocus()
		Return -1
	END IF
	IF lLinNo = 0 OR IsNull(lLinNo) THEN
		F_MessageChk(1,'[라인번호]')
		dw_ins.SetColumn("lin_no")
		dw_ins.SetFocus()
		Return -1
	END IF
	IF sEmpNo = "" OR IsNull(sEmpno) THEN
		F_MessageChk(1,'[작성자]')
		dw_ins.SetColumn("sawon")
		dw_ins.SetFocus()
		Return -1
	END IF
	IF sChaDae = "" OR IsNull(sChaDae) THEN
		F_MessageChk(1,'[차대구분]')
		dw_ins.SetColumn("dcr_gu")
		dw_ins.SetFocus()
		Return -1
	END IF
	IF sAcc1 = "" OR IsNull(sAcc1) THEN
		F_MessageChk(1,'[계정과목]')
		dw_ins.SetColumn("acc1_cd")
		dw_ins.SetFocus()
		Return -1
	END IF
	IF sAcc2 = "" OR IsNull(sAcc2) THEN
		F_MessageChk(1,'[계정과목]')
		dw_ins.SetColumn("acc2_cd")
		dw_ins.SetFocus()
		Return -1
	END IF
	IF sDescr = "" OR IsNull(sDescr) THEN
		F_MessageChk(1,'[적요]')
		dw_ins.SetColumn("descr")
		dw_ins.SetFocus()
		Return -1
	END IF
ELSE
	sSaupj    = dw_ins.GetItemString(il_currow,"saupj")
	sBalDate  = Trim(dw_ins.GetItemString(il_currow,"bal_date"))
	
	dAmount    = dw_ins2.GetItemNumber(il_currow,"amt")
	sCustCode  = dw_ins2.GetItemString(il_currow,"saup_no")
	sSdeptCode = dw_ins2.GetItemString(il_currow,"sdept_cd")
	sCdeptCode = dw_ins2.GetItemString(il_currow,"cdept_cd")
	
	sInCode    = dw_ins2.GetItemString(il_currow,"in_cd")
	sGyulDate  = Trim(dw_ins2.GetItemString(il_currow,"gyul_date"))
	
	sChaDae    = dw_ins.GetItemString(il_currow,"dcr_gu")
	sAcc1      = dw_ins.GetItemString(il_currow,"acc1_cd")
	sAcc2      = dw_ins.GetItemString(il_currow,"acc2_cd")
	
	IF IsNull(dAmount) THEN
		F_MessageChk(1,'[금액]')
		dw_ins2.SetColumn("amt")
		dw_ins2.SetFocus()
		Return -1
	END IF
	
	IF lstr_account.cus_gu = 'Y' AND (sCustCode = "" OR IsNull(sCustCode)) THEN
		F_MessageChk(1,'[거래처]')
		dw_ins2.SetColumn("saup_no")
		dw_ins2.SetFocus()
		Return -1
	END IF
	
	IF sInCode = "" OR IsNull(sInCode) AND lstr_account.admin_gu = 'Y' THEN
		F_MessageChk(1,'[분류코드]')
		dw_ins2.SetColumn("in_cd")
		dw_ins2.SetFocus()
		Return -1	
	END IF
	
	IF sSdeptCode = "" OR IsNull(sSdeptCode) THEN
		SELECT "DC_GU" 		INTO :sDcGbn 
			FROM "KFZ01OM0" 	WHERE "ACC1_CD" = :sAcc1 AND "ACC2_CD" = :sAcc2;
			
		IF lstr_account.remark1 = 'Y' AND sChaDae = sDcGbn THEN
			F_MessageChk(1,'[원가부문]')
			dw_ins2.SetColumn("sdept_cd")
			dw_ins2.SetFocus()
			Return -1	
		END IF
	ELSE
		SELECT "DC_GU" 		INTO :sDcGbn 
			FROM "KFZ01OM0" 	WHERE "ACC1_CD" = :sAcc1 AND "ACC2_CD" = :sAcc2;
		IF lstr_account.remark1 = 'Y' AND sChaDae = sDcGbn THEN
			IF Wf_Check_Sdept(sAcc1,sAcc2,sSdeptCode) = -1 THEN
				F_MessageChk(20,'[원가부문]')
				dw_ins2.SetColumn("sdept_cd")
				dw_ins2.SetFocus()
				Return -1	
			END IF
		END IF
	END IF
	
//	IF sGyulDate = "" OR IsNull(sGyulDate) THEN
//		SELECT "GBN5", "DC_GU" INTO :sGbn5, :sDcGbn 
//			FROM "KFZ01OM0" WHERE "ACC1_CD" = :sAcc1 AND "ACC2_CD" = :sAcc2;
//		
//		IF sGbn5 = 'Y' AND sChaDae = sDcGbn THEN 
//			F_MessageChk(1,'[자금요청일]')
//			dw_ins2.SetColumn("gyul_date")
//			dw_ins2.SetFocus()
//			Return -1	
//		END IF
//	END IF
	
	IF sChaDae = lstr_account.dcr_gu THEN
		IF lstr_account.yesan_gu = 'Y' OR lstr_account.yesan_gu = 'A' THEN
			IF sCdeptCode = "" OR IsNull(sCdeptCode) THEN
				F_MessageChk(1,'[예산부서]')
				dw_ins2.SetColumn("cdept_cd")
				dw_ins2.SetFocus()
				Return -1		
			END IF
//			IF sModStatus = 'I' THEN
//				/*예산통제 체크*/
//				iFunValue = Sqlca.AcFn050(sSaupj,Left(sBalDate,4),Mid(sBalDate,5,2),sAcc1,sAcc2,&
//																		sCdeptCode,lstr_account.yesan_gu,dAmount,0)
//				IF iFunValue = -1 THEN
//					F_MessageChk(58,'[예산잔액 초과]')
//					dw_ins2.SetColumn("cdept_cd")
//					dw_ins2.SetFocus()
//					Return -1		
//				ELSEIF iFunValue = -2 THEN
//					F_MessageChk(58,'[예산배정 없슴]')
//					dw_ins2.SetColumn("cdept_cd")
//					dw_ins2.SetFocus()
//					Return -1		
//				ELSEIF iFunValue = -3 THEN
//					F_MessageChk(53,'')
//					dw_ins2.SetColumn("cdept_cd")
//					dw_ins2.SetFocus()
//					Return -1		
//				END IF
//			END IF
		END IF
	END IF
	
	IF dw_kwan.Retrieve(sAcc1,sAcc2,sChaDae,'Y') > 0 THEN
		FOR k = 1 TO dw_kwan.RowCount()
			sKwanColId = dw_kwan.GetItemString(k,"kwan_colid")
			sRefGbn    = dw_kwan.GetItemString(k,"ref_gbn")							/*체크구분*/
			
			IF dw_kwan.GetItemString(k,"kwan_type") = '1' THEN						/*문자*/
				sGetData  = dw_ins2.GetItemString(il_currow,sKwanColId)
				IF sGetData ="" OR IsNull(sGetData) THEN
					IF sRefGbn = "" OR IsNull(sRefGbn) THEN
						F_MessageChk(1,'['+dw_ins2.Describe(sKwanColId	+ "_t.text")+']')
					ELSE
						F_MessageChk(1,'['+F_Get_Refferance('CU',sRefGbn)+']')
					END IF
					dw_ins2.SetColumn(sKwanColId)
					dw_ins2.SetFocus()
					Return -1
				END IF
			ELSE
				dGetData  = dw_ins2.GetItemNumber(il_currow,sKwanColId)
				IF dGetData =0 OR IsNull(dGetData) THEN
					F_MessageChk(1,'['+dw_ins2.Describe(sKwanColId	+ "_t.text")+']')
					dw_ins2.SetColumn(sKwanColId)
					dw_ins2.SetFocus()
					Return -1
				END IF
			END IF
		NEXT
	END IF
	
	/*2001.06.22추가 : 영수증관리여부 체크*/
	select nvl(taxgbn,'N'), dc_gu	into :lstr_account.taxgbn, :lstr_account.dcr_gu
		from kfz01om0 where acc1_cd = :sAcc1 and acc2_cd = :sAcc2;
	
	select nvl(to_number(dataname),0)	into :dSysAmount from syscnfg where sysgu = 'A' and serial = 1 and lineno = 90;
	if IsNull(dSysAmount) then dSysAmount = 0
	
	if lstr_account.taxgbn = 'Y' and lstr_account.dcr_gu = sChaDae and dAmount >= dSysAmount then
		sTaxGbn    = dw_ins2.GetItemString(il_currow,"taxgbn")
		dQty       = dw_ins2.GetItemNumber(il_currow,"k_qty")
		IF IsNull(dQty) THEN dQty = 0
		
		if sTaxGbn = '' or IsNull(sTaxGbn) then
			F_MessageChk(1,'[영수증구분]')
			dw_ins2.SetColumn("taxgbn")
			dw_ins2.SetFocus()
			Return -1				
		end if
		if dQty = 0 or IsNull(dQty) then
			F_MessageChk(1,'[건수]')
			dw_ins2.SetColumn("k_qty")
			dw_ins2.SetFocus()
			Return -1				
		end if
	end if
END IF

Return 1
end function

public subroutine wf_sang_delete ();/*****************************************************************************************/
/********** 전표 수정 시 상계 처리하는 계정의 거래처가 변경 될 경우의 처리 ***************/
/*** 1. 이전 거래처로 발생된 상계 내역을 삭제한다.													***/
/*****************************************************************************************/
String sSaupj,sBalDate,sUpmuGbn
Long   lBJunNo,lLinNo,i,iRowCount

sSaupj   = dw_ins.GetItemString(dw_ins.GetRow(),"saupj")
sBalDate = dw_ins.GetItemString(dw_ins.GetRow(),"bal_date") 
sUpmuGbn = dw_ins.GetItemString(dw_ins.GetRow(),"upmu_gu")
lBJunNo  = dw_ins.GetItemNumber(dw_ins.GetRow(),"bjun_no")
lLinNo   = dw_ins.GetItemNumber(dw_ins.GetRow(),"lin_no")

iRowCount = dw_sang.Retrieve(sSaupj,sBalDate,sUpmuGbn,lBJunNo,lLinNo)

IF iRowCount <=0 THEN Return

FOR i = iRowCount TO 1 STEP -1
	dw_sang.DeleteRow(i)
NEXT

IF dw_sang.Update() <> 1 THEN
	F_MessageChk(12,'[상계 내역]')
	rollback;
	Return
END IF

end subroutine

public function integer wf_chk_chaip ();String sChaIp1,sChaIp2,sChaIp3,sbyongAcc

select substr(dataname,1,7),		substr(dataname,8,7), 		substr(dataname,15,7)
	into :sChaIp1,				  		:sChaIp2,						:sChaIp3
	from syscnfg
	where syscnfg.sysgu = 'A' and syscnfg.serial = 1 and syscnfg.lineno = '65';
if sqlca.sqlcode <> 0 then
	sChaIp1 = '0000000';			sChaIp2 = '0000000';
else
	if IsNull(sChaIp1) then sChaIp1 = '0000000'
	if IsNull(sChaIp2) then sChaIp2 = '0000000'
end if

if sChaIp1 = lstr_account.acc1_cd+lstr_account.acc2_cd or sChaIp2 = lstr_account.acc1_cd+lstr_account.acc2_cd or sChaIp3 = lstr_account.acc1_cd+lstr_account.acc2_cd then
	Return 1
else
	declare cur_byonglst	cursor for
		select substr(dataname,1,7)
			from syscnfg
			where sysgu = 'A' and serial = 23 and lineno <> '00';
			
	open Cur_ByongLst;
	do while True
		fetch cur_byonglst into :sbyongAcc;
		if sqlca.sqlcode <> 0 then exit
		
		if sByongAcc = lstr_account.acc1_cd+lstr_account.acc2_cd then
			Close Cur_Byonglst;
			Return 1
		end if
	loop
	Close Cur_Byonglst;
	Return -1
end if

end function

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_detail 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : " + as_titletext , &
		 			  "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 																			question!, yesno!) = 1 THEN
		Return -1						
	ELSE
		Double dCha,dDae

		if Is_JUnGbn <> '3' and sModStatus = 'M' then					
			if dw_rtv.RowCount() > 0 then 
				rollback;
					
				if dw_rtv.GetSelectedRow(0) > 0 then
					Wf_Append_Init(dw_rtv.GetItemNumber(dw_rtv.RowCount(),"lin_no"),dw_rtv.RowCount())
				end if

				Wf_Insert_Cash(Is_JUnGbn,'C')
					
				cb_ins2.TriggerEvent(Clicked!)
				commit;
			end if
		else
			Rollback;
		end if	
	END IF

END IF
																
RETURN 1												// (dw_detail) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 

end function

public function string wf_check_autosungin (string sdept);String sGbn,sSysDept

sGbn = 'N'

DECLARE Cur_ValidDept CURSOR FOR  
	SELECT Substr("SYSCNFG"."DATANAME",1,6)
   	FROM "SYSCNFG"  
   	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 12 ) AND  
         ( "SYSCNFG"."LINENO" <> '00' )   
	ORDER BY "SYSCNFG"."LINENO" ASC  ;

Open Cur_ValidDept;

DO WHILE True
	Fetch Cur_ValidDept INTO :sSysDept;
	IF SQLCA.SQLCODE <> 0 THEN EXIT

	IF sDept = sSysDept THEN
		sGbn = 'Y'
		Exit
	END IF
Loop
Close Cur_ValidDept;

Return sGbn

end function

public subroutine wf_change_data_clear (string scolid, integer icurrow);String snull

SetNull(snull)

IF sColId = 'acc1_cd' or sColId = 'acc2_cd' or sColId = 'dcr_gu' THEN
	dw_ins2.SetItem(iCurRow,"saup_no",snull)
	
	IF Ls_SangGbn = 'Y' THEN
		Wf_Sang_Delete()										/*이전 상계 삭제 */
	END IF
	
	dw_ins2.SetItem(iCurRow,"in_cd" ,snull)
	dw_ins2.SetItem(iCurRow,"kfz21om0_inconm",snull)
	
	if lstr_account.cus_gu = 'Y' then
		dw_ins2.SetItem(iCurRow,"saup_no",snull)	
		dw_ins2.SetItem(iCurRow,"in_nm",snull)	
	end if
//	dw_ins2.SetItem(iCurRow,"sdept_cd",snull)	
//	dw_ins2.SetItem(iCurRow,"cdept_cd",snull)
	
//	dw_ins2.SetItem(iCurRow,"yesan_amt",0)
//	dw_ins2.SetItem(iCurRow,"yesan_jan",0)
ELSEIF sColId = 'saup_no' THEN
	IF Ls_SangGbn = 'Y' THEN
		Wf_Sang_Delete()										/*이전 상계 삭제 */
	END IF
ELSEIF sColId = 'amt' THEN
	IF Ls_SangGbn = 'Y' THEN
		Wf_Sang_Delete()										/*이전 상계 삭제 */
	END IF
END IF

dw_ins2.SetItem(iCurRow,"vat_gu"  ,'N')
dw_ins2.SetItem(iCurRow,"jub_gu"  ,'N')
dw_ins2.SetItem(iCurRow,"jbill_gu",'N')
dw_ins2.SetItem(iCurRow,"rbill_gu",'N')
dw_ins2.SetItem(iCurRow,"chaip_gu",'N')
dw_ins2.SetItem(iCurRow,"secu_gu" ,'N')
dw_ins2.SetItem(iCurRow,"cross_gu",'N')
dw_ins2.SetItem(iCurRow,"aset_gu", 'N')
		
end subroutine

public function integer wf_check_child (integer icurrow);String sDcGbn,sAcc1,sAcc2

dw_ins.AcceptText()
sDcGbn = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu")

sAcc1  = dw_ins.GetItemString(dw_ins.GetRow(),"acc1_cd")
sAcc2  = dw_ins.GetItemString(dw_ins.GetRow(),"acc2_cd")

dw_ins2.AcceptText()

IF Is_UpmuGbn = 'Q' THEN Return 1

IF sDcGbn = lstr_account.dcr_gu AND lstr_account.jubdae_gu ='Y' AND dw_ins2.GetItemSTring(iCurRow,"jub_gu") = 'N' THEN	
	F_MessageChk(17,'[접대비]')
	Return -1
ELSEIF sDcGbn = lstr_account.dcr_gu AND lstr_account.vat_gu ='Y' AND dw_ins2.GetItemSTring(iCurRow,"vat_gu") = 'N' THEN	
	F_MessageChk(17,'[부가세]')
	Return -1
ELSEIF sDcGbn <> lstr_account.dcr_gu AND lstr_account.sang_gu ='Y' AND dw_ins2.GetItemSTring(iCurRow,"cross_gu") = 'N' THEN	
	F_MessageChk(17,'[상계]')		
	Return -1
ELSEIF lstr_account.paybil_gu ='Y' AND dw_ins2.GetItemSTring(iCurRow,"jbill_gu") = 'N' THEN	
	F_MessageChk(17,'[지급어음]')		
	Return -1
ELSEIF lstr_account.rcvbil_gu ='Y' AND dw_ins2.GetItemSTring(iCurRow,"rbill_gu") = 'N' THEN	 
	IF sDcGbn = lstr_account.dcr_gu AND sAcc1 = LsBudoAcc1 AND sAcc2 = LsBudoAcc2 THEN
	ELSE
		F_MessageChk(17,'[받을어음]')		
		Return -1
	END IF
ELSEIF sDcGbn = lstr_account.dcr_gu AND lstr_account.ch_gu ='Y' AND dw_ins2.GetItemSTring(iCurRow,"chaip_gu") = 'N' THEN	
	F_MessageChk(17,'[차입금]')		
	Return -1
ELSEIF sDcGbn = lstr_account.dcr_gu AND lstr_account.yu_gu ='Y' AND dw_ins2.GetItemSTring(iCurRow,"secu_gu") = 'N' THEN	
	F_MessageChk(17,'[유가증권]')		
	Return -1
ELSEIF sDcGbn <> lstr_account.dcr_gu AND lstr_account.fsang_gu ='Y' AND dw_ins2.GetItemSTring(iCurRow,"fsang_gu") = 'N' THEN	
	F_MessageChk(17,'[외화외상매입금]')		
	Return -1
ELSEIF sDcGbn = lstr_account.dcr_gu AND lstr_account.remark3 ='Y' AND dw_ins2.GetItemSTring(iCurRow,"aset_gu") = 'N' THEN	
	F_MessageChk(17,'[고정자산]')		
	Return -1
END IF

Return 1
	
end function

public function integer wf_check_cust (string scust, string schadae, ref string scustname);String sName,sPersonGbn,snull

w_mdi_frame.sle_msg.text =""

SetNull(snull)
SetNull(sCustName)

IF lstr_account.cus_gu = 'Y' THEN
	sName = F_Get_Refferance('CU',lstr_account.gbn1)
	IF IsNull(sName) THEN sName = ''
	
	IF sCust = "" OR IsNull(sCust) THEN
		F_MessageChk(1,'[거래처 ('+sName+')]')
		Return -1
	END IF
	
	IF lstr_account.gbn1 ="" OR IsNull(lstr_account.gbn1) THEN			/*인명구분 없슴*/
		sPersonGbn = "%"
	ELSEIF lstr_account.gbn1 ='6' AND sChaDae = '2' and lstr_account.ch_gu = 'Y' THEN 				/*차입금*/
		
		sCustName = F_Get_PersonLst(lstr_account.gbn1,sCust,'1')
		IF Not IsNull(sCustName) THEN
			F_Messagechk(38,'[거래처 ('+sName+')]')
			Return -1
		ELSE
			SetNull(sCustName)
			Return 1
		END IF
	ELSEIF lstr_account.gbn1 ='7' AND sChaDae = '1' THEN
		sCustName = F_Get_PersonLst(lstr_account.gbn1,sCust,'1')
		IF Not IsNull(sCustName) THEN
			F_Messagechk(38,'[거래처 ('+sName+')]')
			Return -1
		ELSE
			SetNull(sCustName)
			Return 1
		END IF
	ELSE
		sPersonGbn = lstr_account.gbn1
	END IF
	
	sCustName = F_Get_PersonLst(sPersonGbn,sCust,'1')
	IF IsNull(sCustName) THEN
		F_Messagechk(27,'[거래처 ('+sName+')]')
		Return -1	
	END IF
ELSE
//	sPersonGbn = lstr_account.gbn1
//	
//	sCustName = F_Get_PersonLst(sPersonGbn,sCust,'1')
//	IF IsNull(sCustName) THEN
//		F_Messagechk(27,'[거래처 ('+sName+')]')
//		Return -1	
//	END IF
	
	F_MessageChk(35,'')	
	Return -1
END IF

Return 1


end function

public function integer wf_check_kwanno (string skwanno, string scolid);String  sAcc1,sAcc2,sChaDae,sRefGbn,sPjtNo,sCode,sUseGbn,sStatus

dw_ins.AcceptText()
sAcc1   = dw_ins.GetItemString(dw_ins.GetRow(),"acc1_cd")
sAcc2   = dw_ins.GetItemString(dw_ins.GetRow(),"acc2_cd")
sChaDae = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu") 

/*부도어음*/
IF lstr_account.acc1_cd = LsBudoAcc1 AND lstr_account.acc2_cd = LsBudoAcc2 THEN	
	SELECT "KFM02OT0"."STATUS"     	INTO :sStatus  
    	FROM "KFM02OT0"  
   	WHERE "KFM02OT0"."BILL_NO" = :sKwanNo ;
//		AND "KFM02OT0"."STATUS" = '1';
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,dw_ins2.Describe(scolid	+ "_t.text"))
		Return -1
	ELSE
//		IF sStatus <> '1' THEN
//			F_MessageChk(20,dw_ins2.Describe(scolid	+ "_t.text") +'[발행 아님]')
//			Return -1
//		END IF
	END IF
ELSE
	SELECT "KFZ01OT0"."REF_GBN"  	INTO :sRefGbn  
		FROM "KFZ01OT0"  
		WHERE ( "KFZ01OT0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OT0"."ACC2_CD" = :sAcc2 ) AND  
				( "KFZ01OT0"."DC_GU" = :sChaDae ) AND ( "KFZ01OT0"."KWAN_COLID" = :sColId )   ;
	IF SQLCA.SQLCODE = 0 THEN
		IF sRefGbn = "" OR IsNull(sRefGbn) THEN Return 1
		
		IF scolid = 'itm_gu' THEN
		ELSE
			SELECT "KFZ04OM0"."PERSON_CD"  		INTO :sCode  
				FROM "KFZ04OM0"  
				WHERE ( "KFZ04OM0"."PERSON_GU" = :sRefGbn ) AND  
						( "KFZ04OM0"."PERSON_CD" = :sKwanNo ) AND  
						( "KFZ04OM0"."PERSON_STS" = '1' )   ;
			IF SQLCA.SQLCODE <> 0 THEN
				F_MessageChk(20,dw_ins2.Describe(scolid	+ "_t.text"))
				Return -1
			END IF
			
			IF scolid = 'kwan_no' THEN						/*관리번호*/
				IF sRefGbn = '93' THEN								/*수표용지번호*/
					SELECT "KFM06OT0"."USE_GU"  INTO :sUseGbn  
						FROM "KFM06OT0"  
						WHERE "KFM06OT0"."CHECK_NO" = :sKwanNo   ;
					IF SQLCA.SQLCODE = 0 THEN
						IF sUseGbn <> '0' THEN						/*사용구분이 '미사용'이 아니면*/
							F_MessageChk(46,dw_ins2.Describe(scolid	+ "_t.text"))
							Return -1
						END IF
					ELSE
						F_MessageChk(20,dw_ins2.Describe(scolid	+ "_t.text"))
						Return -1
					END IF
				END IF	
	//99.8.10 KWY
				IF sRefGbn = '94' THEN								/*지급어음용지번호*/
					SELECT "KFM01OT0"."STATUS"  INTO :sUseGbn  
						FROM "KFM01OT0"  
						WHERE "KFM01OT0"."BILL_NO" = :sKwanNo   ;
					IF SQLCA.SQLCODE = 0 THEN
	// 99.8.10 KWY
	//					IF sUseGbn <> '0' THEN						/*사용구분이 '미사용'이 아니면*/
	//						F_MessageChk(46,dw_ins2.Describe(scolid	+ "_t.text"))
	//						Return -1
	//					END IF
					ELSE
						F_MessageChk(20,dw_ins2.Describe(scolid	+ "_t.text"))
						Return -1
					END IF
				END IF	
			END IF
		END IF
	END IF
END IF
Return 1
end function

public function integer wf_check_sdept (string sacc1, string sacc2, string sdeptcode);String sGubun,sCostDept

select acc_gbn		into :sGubun 	from cia01m where acc1_cd = :sAcc1 and acc2_cd = :sAcc2;
if sqlca.sqlcode <> 0 then
	sGubun = '%'												
else
	if IsNull(sGubun) then sGubun = '%'
end if

if sGubun = '1' then								/*제조*/
	select a.cost_cd		into :sCostDept
		from cia02m a, cia01m b, reffpf c
		where b.acc1_cd = :sAcc1 and b.acc2_cd = :sAcc2 and b.acc_gbn = c.rfna2 and
				c.rfcod = 'C9' and c.rfgub <> '00' and
				a.cost_gu2 = c.rfgub and a.cost_cd = :sDeptCode and a.usegbn = '1'  ;
else
	select a.cost_cd		into :sCostDept
		from cia02m a
		where a.cost_cd = :sDeptCode and a.usegbn = '1';
end if
if sqlca.sqlcode <> 0 then 
	Return -1
end if
Return 1
end function

public function integer wf_chk_standarddate (string sbaldate);String sFrom, sTo

SELECT "KFZ06OM0"."BALYMD1",   "KFZ06OM0"."BALYMD2"  
	INTO :sFrom,   				 :sTo  
   FROM "KFZ06OM0"  ;
IF SQLCA.SQLCODE <> 0 THEN
	sFrom = '00000000'
	sTo   = '00000000'
ELSE
	IF sFrom = "" OR IsNull(sFrom) THEN	sFrom = '00000000'
	IF sTo   = "" OR IsNull(sTo)   THEN	sTo   = '00000000'
END IF

IF Len(sBalDate) = 8 AND Right(sBalDate,2) <> '00' THEN 
	IF sFrom <= sBalDate AND sBalDate <= sTo THEN
		Return 1	
	ELSE
		Return -1
	END IF
ELSE
	Return -1
END IF
end function

public function integer wf_control_ds_junpoy (string sflag, integer il_currentrow, integer ifrcnt, integer itocnt);///**************************************************************************************/
///****** 본지점 관리하는 계정(kfz01ot2에 있으면)이면 본지점대체전표 발생            	 **/
///*** 1. 신규 일 때 - 본지점전표 발생,본지점전표정보 저장										 **/
///*** 2. 수정 일 때 - 본지점전표정보를 읽어서 본지점전표내역을 갱신						 **/
///*** 3. 삭제 일 때 - 본지점전표정보를 읽어서 본지점전표 삭제								 **/
///*** * return : 1,   -1																					 **/
///*** call하는 곳 : 수정 후 줄 저장 시('MOD',현재 처리 행,0,0)								 **/
///***               줄 삭제 시('DELETE',현재 처리 행,0,0)										 **/
///***               수정에서 계정 변경 시 이전본지점계정 삭제('DELETE',현재 처리행,0,0)*/
///***               신규입력의 완료 시('NEW',0,1,999)											 **/
///***               수정에서 계정 변경 시의 신규본지점('NEW,0,현재처리행,현재처리행)  **/
///**************************************************************************************/
//Integer k,iLinNoS,iLinNoD,iLstCnt,iJunpoyCnt
//String  sSaupjS,sBalDateS,sUpmuGuS,sAcc1S,sAcc2S,sDcrGuS,sSaupjD,sBalDateD,sUpmuGuD,sAcc1D,&
//		  sAcc2D,sDcrGuD,sDeptCode,sSawon,sJunGu,sChaDae,sYesanGbn,sCusGbn,sRemark1		  
//Long    lBJunNoS,lBJunNoD
//
//IF dw_rtv.RowCount() <=0 THEN Return 1
//
//SELECT SUBSTR("LINENO",1,1)  	INTO :sJunGu  									/*전표종류*/
//	FROM "SYSCNFG"  
//	WHERE ( "SYSGU" = 'A' ) AND ( "SERIAL" = 11 ) AND ( "LINENO" = '2' )   ;
//IF SQLCA.SQLCODE <> 0 THEN
//	sJunGu = '1'	
//ELSE
//	IF IsNull(sJunGu) OR sJunGu = "" THEN sJunGu = '1'
//END IF
//
//dw_DaecheLst.Reset()
//dw_Daeche.Reset()
//
//IF sFlag = 'DELETE' THEN														/*삭제이면*/
//	sSaupjS   = dw_rtv.GetItemString(il_CurrentRow,"saupj")			/*발생전표*/
//	sBalDateS = dw_rtv.GetItemString(il_CurrentRow,"bal_date") 
//	sUpmuGuS  = dw_rtv.GetItemString(il_CurrentRow,"upmu_gu") 
//	lBJunNoS  = dw_rtv.GetItemNumber(il_CurrentRow,"bjun_no") 
//	iLinNoS   = dw_rtv.GetItemNumber(il_CurrentRow,"lin_no") 
//	
//	IF dw_DaeCheLst.Retrieve(sSaupjS,sBalDateS,sUpmuGuS,lBJunNoS,iLinNoS) > 0 THEN
//		sSaupjD   = dw_DaeCheLst.GetItemString(1,"saupj_d")							/*대체전표*/
//		sBalDateD = dw_DaeCheLst.GetItemString(1,"bal_date_d") 
//		sUpmuGuD  = dw_DaeCheLst.GetItemString(1,"upmu_gu_d") 
//		lBJunNoD  = dw_DaeCheLst.GetItemNumber(1,"bjun_no_d") 
//		iLinNoD   = dw_DaeCheLst.GetItemNumber(1,"lin_no_d") 
//	
//		dw_DaeCheLst.DeleteRow(0)
//			
//		iJunpoyCnt = dw_DaeChe.Retrieve(sSaupjD,sBalDateD,sUpmuGuD,lBJunNoD,1,9999) 	
//		IF iJunpoyCnt > 0 THEN
//			FOR k = iJunPoyCnt TO 1 STEP -1
//				dw_DaeChe.DeleteRow(k)
//			NEXT
//		END IF
//		
//		IF dw_DaecheLst.Update() <> 1 THEN
//			F_MessageChk(12,'[본지점대체전표정보]')
//			RollBack;
//			Return -1
//		END IF
//	
//		IF dw_Daeche.Update() <> 1 THEN
////			F_MessageChk(12,'[본지점대체전표]')
//			RollBack;
//			Return -1
//		END IF
//	END IF
//ELSEIF sFlag = 'NEW' THEN
//	FOR k = iFrCnt TO iToCnt
//		IF k > dw_rtv.RowCount() THEN Exit 
//		sSaupjS   = dw_rtv.GetItemString(k,"saupj")							/*발생전표*/
//		sBalDateS = dw_rtv.GetItemString(k,"bal_date") 
//		sUpmuGuS  = dw_rtv.GetItemString(k,"upmu_gu") 
//		lBJunNoS  = dw_rtv.GetItemNumber(k,"bjun_no") 
//		iLinNoS   = dw_rtv.GetItemNumber(k,"lin_no") 
//		
//		IF iFrCnt = iToCnt THEN										/*수정에서 CALL하면*/
//			sDcrGuS   = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu") 
//			sAcc1S    = dw_ins.GetItemString(dw_ins.GetRow(),"acc1_cd") 
//			sAcc2S    = dw_ins.GetItemString(dw_ins.GetRow(),"acc2_cd")
//		ELSE
//			sDcrGuS   = dw_rtv.GetItemString(k,"dcr_gu") 
//			sAcc1S    = dw_rtv.GetItemString(k,"acc1_cd") 
//			sAcc2S    = dw_rtv.GetItemString(k,"acc2_cd")
//		END IF
//		
//		SELECT "SSAUPJ",   			SUBSTR("SACCODE",1,5),   		SUBSTR("SACCODE",6,2),
//				 "SDEPT_CD",         "SSAWON"  
//			INTO :sSaupjD,				:sAcc1D,								:sAcc2D,   
//				  :sDeptCode,			:sSawon
//			FROM "KFZ01OT2"  
//			WHERE ( "BSAUPJ" = :sSaupjS ) AND ( "BACCODE" = :sAcc1S||:sAcc2S );
//			
//		IF SQLCA.SQLCODE <> 0 THEN Continue
//		
//		sBalDateD = sBalDateS;		sUpmuGuD = sUpmuGuS;			iLinNoD = 1;
//		
//		lBJunNoD = Sqlca.Fun_Calc_JunNo('B',sSaupjD,sUpmuGuD,sBalDateD)
//		IF lBJunNoD <=0 THEN 
//			f_MessageChk(34,'')
//			Return -1
//		END IF
//		
//		iLstCnt = dw_DaecheLst.InsertRow(0)								/*대체전표 발생내역*/
//		dw_DaecheLst.SetItem(iLstCnt,"saupj_s",		sSaupjS)
//		dw_DaecheLst.SetItem(iLstCnt,"bal_date_s",	sBalDateS)
//		dw_DaecheLst.SetItem(iLstCnt,"upmu_gu_s",		sUpmuGuS)
//		dw_DaecheLst.SetItem(iLstCnt,"bjun_no_s",		lBJunNoS)
//		dw_DaecheLst.SetItem(iLstCnt,"lin_no_s",		iLinNoS)
//		
//		dw_DaecheLst.SetItem(iLstCnt,"saupj_d",		sSaupjD)
//		dw_DaecheLst.SetItem(iLstCnt,"bal_date_d",	sBalDateD)
//		dw_DaecheLst.SetItem(iLstCnt,"upmu_gu_d",		sUpmuGuD)
//		dw_DaecheLst.SetItem(iLstCnt,"bjun_no_d",		lBJunNoD)
//		dw_DaecheLst.SetItem(iLstCnt,"lin_no_d",		iLinNoD)
//		
//		IF sDcrGuS = '1' THEN 											/*대체전표 차대구분*/
//			sDcrGuD = '2' 
//		ELSE
//			sDcrGuD = '1'
//		END IF
//		
//		SELECT "DC_GU",		"YESAN_GU",		"CUS_GU",		"REMARK1"      
//			INTO :sChaDae,		:sYesanGbn,		:sCusGbn,		:sRemark1
//			FROM "KFZ01OM0"  
//			WHERE ( "ACC1_CD" = :sAcc1D ) AND ( "ACC2_CD" = :sAcc2D ) ;
//		
//		iJunPoyCnt = dw_daeche.InsertRow(0)
//			
//		dw_daeche.SetItem(iJunPoyCnt,"saupj",   sSaupjD)
//		dw_daeche.SetItem(iJunPoyCnt,"bal_date",sBalDateD)
//		dw_daeche.SetItem(iJunPoyCnt,"upmu_gu", sUpmuGuD)
//		dw_daeche.SetItem(iJunPoyCnt,"bjun_no", lBJunNoD)
//		dw_daeche.SetItem(iJunPoyCnt,"lin_no",  iLinNoD)
//		
//		dw_daeche.SetItem(iJunPoyCnt,"jun_gu",  sJunGu)
//		
//		dw_daeche.SetItem(iJunPoyCnt,"dept_cd", sDeptCode)	
//		dw_daeche.SetItem(iJunPoyCnt,"acc1_cd", sAcc1D)
//		dw_daeche.SetItem(iJunPoyCnt,"acc2_cd", sAcc2D)
//		dw_daeche.SetItem(iJunPoyCnt,"sawon",   sSawon)
//		dw_daeche.SetItem(iJunPoyCnt,"dcr_gu",  sDcrGuD)
//		
//		IF iFrCnt = iToCnt THEN										/*수정에서 CALL하면*/
//			dw_daeche.SetItem(iJunPoyCnt,"amt",     dw_ins2.GetItemNumber(dw_ins2.GetRow(),"amt"))
//			dw_daeche.SetItem(iJunPoyCnt,"descr",   dw_ins.GetItemString(dw_ins.GetRow(),"descr"))	
//			IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcrGuD = sChaDae THEN
//				dw_daeche.SetItem(iJunPoyCnt,"cdept_cd",dw_ins2.GetItemString(dw_ins2.GetRow(),"cdept_cd"))
//			END IF
//			IF sRemark1 = 'Y' THEN
//				dw_daeche.SetItem(iJunPoyCnt,"sdept_cd",dw_ins2.GetItemString(dw_ins2.GetRow(),"sdept_cd"))
//			END IF
//			
//			IF sCusGbn = 'Y' THEN
//				dw_daeche.SetItem(iJunPoyCnt,"saup_no", dw_ins2.GetItemString(dw_ins2.GetRow(),"saup_no"))
//			END IF
//			dw_daeche.SetItem(iJunPoyCnt,"in_nm",      dw_ins2.GetItemString(dw_ins2.GetRow(),"in_nm"))
//			
//			IF sJunGu = '2' THEN								/*운전자금*/
//				dw_daeche.SetItem(iJunPoyCnt,"gyul_date",  dw_ins2.GetItemString(dw_ins2.GetRow(),"gyul_date"))
//			END IF
//		ELSE
//			dw_daeche.SetItem(iJunPoyCnt,"amt",     dw_rtv.GetItemNumber(k,"amt"))
//			dw_daeche.SetItem(iJunPoyCnt,"descr",   dw_rtv.GetItemString(k,"descr"))	
//			IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcrGuD = sChaDae THEN
//				dw_daeche.SetItem(iJunPoyCnt,"cdept_cd",dw_rtv.GetItemString(k,"cdept_cd"))
//			END IF
//			IF sRemark1 = 'Y' THEN
//				dw_daeche.SetItem(iJunPoyCnt,"sdept_cd",dw_rtv.GetItemString(k,"sdept_cd"))
//			END IF
//			
//			IF sCusGbn = 'Y' THEN
//				dw_daeche.SetItem(iJunPoyCnt,"saup_no", dw_rtv.GetItemString(k,"saup_no"))
//			END IF
//			dw_daeche.SetItem(iJunPoyCnt,"in_nm",      dw_rtv.GetItemString(k,"in_nm"))
//			
//			IF sJunGu = '2' THEN								/*운전자금*/
//				dw_daeche.SetItem(iJunPoyCnt,"gyul_date",  dw_rtv.GetItemString(k,"gyul_date"))
//			END IF
//		END IF
//		
//		dw_daeche.SetItem(iJunPoyCnt,"indat",      F_Today()) 
//	NEXT	
//		
//	IF dw_DaeCheLst.RowCount() > 0 THEN
//		IF dw_DaecheLst.Update() <> 1 THEN
//			F_MessageChk(13,'[본지점대체전표정보]')
//			RollBack;
//			Return -1
//		END IF
//	END IF
//	
//	IF dw_DaeChe.RowCount() > 0 THEN
//		IF dw_Daeche.Update() <> 1 THEN
////			F_MessageChk(13,'[본지점대체전표]')
//			RollBack;
//			Return -1
//		END IF
//	END IF
//ELSEIF sFlag = 'MOD' THEN									/*수정이면*/
//	String  sOldAcc1,sOldAcc2,sNewAcc1,sNewAcc2,sSaupjD_Old,sSaupjD_New
//	Integer iOldCnt,iNewCnt
//	
//	sSaupjS   = dw_rtv.GetItemString(il_CurrentRow,"saupj")			/*발생전표*/
//	sBalDateS = dw_rtv.GetItemString(il_CurrentRow,"bal_date") 
//	sUpmuGuS  = dw_rtv.GetItemString(il_CurrentRow,"upmu_gu") 
//	lBJunNoS  = dw_rtv.GetItemNumber(il_CurrentRow,"bjun_no") 
//	iLinNoS   = dw_rtv.GetItemNumber(il_CurrentRow,"lin_no") 
//
//	/*이전 계정과목*/
//	sOldAcc1  = dw_ins.GetItemString(1,"old_acc1")
//	sOldAcc2  = dw_ins.GetItemString(1,"old_acc2")
//	
//	SELECT "SSAUPJ",   	Count(*)  		INTO :sSaupjD_Old,		:iOldCnt
//		FROM "KFZ01OT2"  
//		WHERE ( "BSAUPJ" = :sSaupjS ) AND ( "BACCODE" = :sOldAcc1||:sOldAcc2 )
//		GROUP BY "SSAUPJ";
//	IF SQLCA.SQLCODE <> 0 THEN
//		iOldCnt = 0
//	ELSE
//		IF IsNull(iOldCnt) THEN iOldCnt = 0	
//	END IF
//	
//	/*새 계정과목*/
//	sNewAcc1  = dw_ins.GetItemString(1,"acc1_cd")
//	sNewAcc2  = dw_ins.GetItemString(1,"acc2_cd")
//	
//	SELECT "SSAUPJ",   			SUBSTR("SACCODE",1,5),   		SUBSTR("SACCODE",6,2),
//			 "SDEPT_CD",         "SSAWON",							Count(*)  
//		INTO :sSaupjD_New,		:sAcc1D,								:sAcc2D,   
//			  :sDeptCode,			:sSawon,								:iNewCnt
//		FROM "KFZ01OT2"  
//		WHERE ( "BSAUPJ" = :sSaupjS ) AND ( "BACCODE" = :sNewAcc1||:sNewAcc2 )
//		GROUP BY "SSAUPJ",  "SACCODE",	"SDEPT_CD", "SSAWON";
//	IF SQLCA.SQLCODE <> 0 THEN
//		iNewCnt = 0
//	ELSE
//		IF IsNull(iNewCnt) THEN iNewCnt = 0	
//	END IF
//	
//	SELECT "DC_GU",		"YESAN_GU",		"CUS_GU",		"REMARK1"      
//		INTO :sChaDae,		:sYesanGbn,		:sCusGbn,		:sRemark1
//		FROM "KFZ01OM0"  
//		WHERE ( "ACC1_CD" = :sAcc1D ) AND ( "ACC2_CD" = :sAcc2D ) ;
//			
//	IF iOldCnt <> 0 AND iNewCnt <> 0 THEN				/*이전계정,변경계정:본지점*/
//		IF sSaupjD_Old = sSaupjD_New	THEN				/*이전,변경계정의 본지점대체 사업장 같으면*/
//			IF dw_DaeCheLst.Retrieve(sSaupjS,sBalDateS,sUpmuGuS,lBJunNoS,iLinNoS,iLinNoS) > 0 THEN
//				sSaupjD   = dw_DaeCheLst.GetItemString(1,"saupj_d")							/*대체전표*/
//				sBalDateD = dw_DaeCheLst.GetItemString(1,"bal_date_d") 
//				sUpmuGuD  = dw_DaeCheLst.GetItemString(1,"upmu_gu_d") 
//				lBJunNoD  = dw_DaeCheLst.GetItemNumber(1,"bjun_no_d") 
//				iLinNoD   = dw_DaeCheLst.GetItemNumber(1,"lin_no_d") 
//			
//				IF dw_DaeChe.Retrieve(sSaupjD,sBalDateD,sUpmuGuD,lBJunNoD,iLinNoD,iLinNoD) = 1 THEN
//					dw_daeche.SetItem(1,"dept_cd", sDeptCode)	
//					dw_daeche.SetItem(1,"acc1_cd", sAcc1D)
//					dw_daeche.SetItem(1,"acc2_cd", sAcc2D)
//					dw_daeche.SetItem(1,"sawon",   sSawon)
//					
//					IF dw_ins.GetItemString(1,"dcr_gu") = '1' THEN
//						sDcrGuD = '2'
//					ELSE
//						sDcrGuD = '1'
//					END IF
//					dw_daeche.SetItem(1,"dcr_gu",  sDcrGuD)
//					
//					dw_daeche.SetItem(1,"amt",     dw_ins2.GetItemNumber(dw_ins2.GetRow(),"amt"))
//					dw_daeche.SetItem(1,"descr",   dw_ins.GetItemString(dw_ins.GetRow(),"descr"))	
//					IF (sYesanGbn = 'Y' or sYesanGbn = 'A') and sDcrGuD = sChaDae THEN
//						dw_daeche.SetItem(1,"cdept_cd",dw_ins2.GetItemString(dw_ins2.GetRow(),"cdept_cd"))
//					END IF
//					
//					IF sRemark1 = 'Y' THEN
//						dw_daeche.SetItem(1,"sdept_cd",dw_ins2.GetItemString(dw_ins2.GetRow(),"sdept_cd"))
//					END IF
//					
//					IF sCusGbn = 'Y' THEN
//						dw_daeche.SetItem(1,"saup_no", dw_ins2.GetItemString(dw_ins2.GetRow(),"saup_no"))
//					END IF
//					dw_daeche.SetItem(1,"in_nm",      dw_ins2.GetItemString(dw_ins2.GetRow(),"in_nm"))
//					
//					IF sJunGu = '2' THEN								/*운전자금*/
//						dw_daeche.SetItem(1,"gyul_date",  dw_ins2.GetItemString(dw_ins2.GetRow(),"gyul_date"))
//					END IF
//					dw_daeche.SetItem(1,"indat",      F_Today()) 
//				END IF
//				
//				IF dw_Daeche.Update() <> 1 THEN
////					F_MessageChk(12,'[본지점대체전표]')
//					RollBack;
//					Return -1
//				END IF
//			END IF	
//		ELSE
//			IF Wf_Control_Ds_Junpoy('DELETE',il_currentrow,0,0) = -1 THEN
//				Rollback;
//				Return -1 	
//			END IF
//			
//			IF Wf_Control_Ds_Junpoy('NEW',0,il_currentrow,il_currentrow) = -1 THEN
//				Rollback;
//				Return -1 	
//			END IF
//		END IF
//		
//	ELSEIF iOldCnt <> 0 AND iNewCnt = 0 THEN			/*이전계정:본지점,변경계정:본지점아님*/
//		IF Wf_Control_Ds_Junpoy('DELETE',il_currentrow,0,0) = -1 THEN
//			Rollback;
//			Return -1 	
//		END IF
//	ELSEIF iOldCnt = 0 AND iNewCnt <> 0 THEN			/*이전계정:본지점아님,변경계정:본지점*/
//		IF Wf_Control_Ds_Junpoy('NEW',0,il_currentrow,il_currentrow) = -1 THEN
//			Rollback;
//			Return -1 	
//		END IF
//	END IF
//END IF
//
Return 1
end function

public subroutine wf_get_syscnfg ();/*********************************************************/
/*환경 파일에서 처리구분 참조하여 처리                   */
/*1. 적요 상세 내역 입력 여부 = Is_SysCnfg_DescFlag      */
/*2. 관리 항목 상세 입력 여부 = Is_SysCnfg_InFlag        */
/*3. 예산 배분 상세 입력 여부 = Is_SysCnfg_YesanFlag     */
/*4. 원가부문 배분 상세 입력 여부 = Is_SysCnfg_WonGaFlag */
/*5. 전표 송부 사용 여부 체크 = Is_AcRcvFlag					*/
/*********************************************************/

//1.
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)  		INTO :Is_SysCnfg_DescFlag  
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	Is_SysCnfg_DescFlag = 'N'
END IF

//2.
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)  		INTO :Is_SysCnfg_InFlag  
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         ( "SYSCNFG"."LINENO" = '2' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	Is_SysCnfg_InFlag = 'N'
END IF

//3.
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)  		INTO :Is_SysCnfg_YesanFlag  
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         ( "SYSCNFG"."LINENO" = '3' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	Is_SysCnfg_YesanFlag = 'N'
END IF

//4.
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)  		INTO : Is_SysCnfg_WonGaFlag
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 4 ) AND  
         ( "SYSCNFG"."LINENO" = '4' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	Is_SysCnfg_WonGaFlag = 'N'
END IF

//5															
SELECT SUBSTR("SYSCNFG"."DATANAME",1,1)      INTO :Is_AcRcvFlag  
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 11 ) AND  
         ( "SYSCNFG"."LINENO" = '1' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	Is_AcRcvFlag = 'N'
END IF	


			
end subroutine

public function integer wf_insert_cash (string sjungbn, string saddmod);/*********************************************************************************/
/*** 현금 출금전표라인 추가                              							 ***/
/*** ARG : sAddMod('C' : DB, 'O' : 차이금액만큼)										 ***/
/*********************************************************************************/

String  sAcc1_Cd,sAcc2_Cd,sSaupj,sDate,sUpmuGu,sDescr
Double  dAmount
Long    lLinNo,lJunNo

select substr(dataname,1,5),	substr(dataname,6,2) 	into :sAcc1_cd,	:sAcc2_cd					
	from syscnfg where sysgu = 'A' and serial = 1 and lineno = '1';
if sjungbn = '1' then									/*입금전표*/
	dw_ins.SetItem(dw_ins.GetRow(),"dcr_gu",   '1')							/*차변*/
	sDescr  = '현금 입금'
else
	dw_ins.SetItem(dw_ins.GetRow(),"dcr_gu",   '2')							/*대변*/
	sDescr  = '현금 출금'
end if
	
dw_ins.SetItem(dw_ins.GetRow(),"acc1_cd",  sAcc1_Cd)
dw_ins.SetItem(dw_ins.GetRow(),"acc2_cd",  sAcc2_Cd)

dw_ins.SetItem(dw_ins.GetRow(),"indat",    f_today())

if sAddMod = 'C' then																/*입출금전표 수정에서 취소 시*/
	sSaupj  = dw_rtv.GetItemString(1,"saupj")
	sDate   = dw_rtv.GetItemString(1,"bal_date")
	sUpmuGu = dw_rtv.GetItemString(1,"upmu_gu") 
	lJunNo  = dw_rtv.GetItemNumber(1,"bjun_no")
	
	select sum(amt),max(lin_no)	 into :dAmount, :lLinNo
		from kfz12ot0
		where saupj = :sSaupj and bal_date = :sDate and upmu_gu = :sUpmuGu and
				bjun_no = :lJunNo and acc1_cd||acc2_cd <> :sAcc1_Cd||:sAcc2_Cd ;
	if IsNull(dAmount) then dAmount = 0
	
	if IsNull(lLinNo) then lLinNo = 0
	lLinNo = lLinNo + 1
	
	dw_ins.SetItem(dw_ins.GetRow(),"lin_no", lLinNo)
else
	dAmount = dw_rtv.GetItemNumber(dw_rtv.RowCount(),"chai_amt")
	sDescr  = dw_rtv.GetItemString(1,"descr")
end if
dw_ins.SetItem(dw_ins.GetRow(),"descr",    sDescr)
dw_ins2.SetItem(dw_ins2.GetRow(),"amt",    dAmount)	

Return 1
end function

public function integer wf_junpoy (string ssaupj, string sbaldate);Long   iJunNo

IF Is_UpmuGbn <> 'A' AND Is_UpmuGbn <> 'Q' THEN 
	F_MessageChk(33,'')
	RETURN -1
END IF

iJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,Is_UpmuGbn,sBalDate)

IF iJunNo > 0 THEN
	dw_ins.SetItem(dw_ins.GetRow(),"bjun_no",iJunNo)
	
	dw_ins.Modify("saupj.protect    = 1")
	dw_ins.Modify("bal_date.protect = 1")
	
	Ib_ClickedFlag = True
	
	w_mdi_frame.sle_msg.text = ''
	
	ib_any_typing = True
ELSE
	IF iJunNo = -1 THEN
		f_MessageChk(34,'')

	ELSEIF iJunNo = -2 THEN
		f_MessageChk(1,'[사업장]')
	ELSEIF iJunNo = -3 THEN
		f_MessageChk(1,'[전표구분]')
	ELSEIF iJunNo = -4 THEN
		f_MessageChk(1,'[발행일자]')
	END IF
	dw_ins.SetItem(dw_ins.GetRow(),"bjun_no",SetNull(iJunNo))
	
	w_mdi_frame.sle_msg.text = "전표번호 채번은 전표번호를 클릭하거나 FUNCTION KEY(F3)을 사용하세요!!"
END IF

Return iJunNo
end function

public subroutine wf_move_ins ();
dw_ins.AcceptText()

dw_ins2.SetItem(dw_ins2.GetRow(),"saupj",   dw_ins.GetItemString(dw_ins.GetRow(),"saupj"))
dw_ins2.SetItem(dw_ins2.GetRow(),"bal_date",dw_ins.GetItemString(dw_ins.GetRow(),"bal_date"))
dw_ins2.SetItem(dw_ins2.GetRow(),"dept_cd", dw_ins.GetItemString(dw_ins.GetRow(),"dept_cd"))
dw_ins2.SetItem(dw_ins2.GetRow(),"upmu_gu", dw_ins.GetItemString(dw_ins.GetRow(),"upmu_gu"))
dw_ins2.SetItem(dw_ins2.GetRow(),"bjun_no", dw_ins.GetItemNumber(dw_ins.GetRow(),"bjun_no"))
dw_ins2.SetItem(dw_ins2.GetRow(),"jun_gu",  dw_ins.GetItemString(dw_ins.GetRow(),"jun_gu"))
dw_ins2.SetItem(dw_ins2.GetRow(),"lin_no",  dw_ins.GetItemNUmber(dw_ins.GetRow(),"lin_no"))
dw_ins2.SetItem(dw_ins2.GetRow(),"sawon",   dw_ins.GetItemString(dw_ins.GetRow(),"sawon"))
dw_ins2.SetItem(dw_ins2.GetRow(),"dcr_gu",  dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu"))
dw_ins2.SetItem(dw_ins2.GetRow(),"acc1_cd", dw_ins.GetItemString(dw_ins.GetRow(),"acc1_cd"))
dw_ins2.SetItem(dw_ins2.GetRow(),"acc2_cd", dw_ins.GetItemString(dw_ins.GetRow(),"acc2_cd"))
dw_ins2.SetItem(dw_ins2.GetRow(),"descr",   dw_ins.GetItemString(dw_ins.GetRow(),"descr"))
dw_ins2.SetItem(dw_ins2.GetRow(),"indat",   dw_ins.GetItemString(dw_ins.GetRow(),"indat"))



end subroutine

public function integer wf_open_finance ();/*현금유관 계정에 대하여 자금 수지 코드를 받아서 처리한다...2001.06.20*/
/*환경파일에 자금수지 실적 자료 생성방법(A-30-1)에 따라서 처리        */

String    sProcGbn,sSysGbn,sCashGbn,sNull,sOldAcc1,sOldAcc2,sOldCashGbn
Double    dOldAmt
Integer   iCount

IF Is_UpmuGbn = 'Q' THEN Return 1

/*1:전표에서 생성, 2: 현금유관계정의 상대계정 자금코드로 결정*/
select nvl(substr(dataname,1,1),'2')		into :sSysGbn					
	from syscnfg
	where sysgu = 'A' and serial = 30 and lineno = '1';
if sSysGbn = '2' then Return 1

dw_ins.AcceptText()
lstr_jpra.saupjang = dw_ins.GetItemString(dw_ins.GetRow(),"saupj")
lstr_jpra.baldate  = dw_ins.GetItemString(dw_ins.GetRow(),"bal_date")
lstr_jpra.upmugu   = dw_ins.GetItemString(dw_ins.GetRow(),"upmu_gu")
lstr_jpra.bjunno   = dw_ins.GetItemNumber(dw_ins.GetRow(),"bjun_no")
lstr_jpra.sortno   = dw_ins.GetItemNumber(dw_ins.GetRow(),"lin_no")
lstr_jpra.chadae   = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu")

lstr_jpra.acc1     = dw_ins.GetItemString(dw_ins.GetRow(),"acc1_cd")
lstr_jpra.acc2     = dw_ins.GetItemString(dw_ins.GetRow(),"acc2_cd")

sOldAcc1           = dw_ins.GetItemString(dw_ins.GetRow(),"old_acc1")
sOldAcc2           = dw_ins.GetItemString(dw_ins.GetRow(),"old_acc2")

dw_ins2.AcceptText()
lstr_jpra.money    = dw_ins2.GetItemNumber(dw_ins2.GetRow(),"amt")

dOldAmt = dw_ins2.GetItemNumber(1,"old_amt")
IF IsNull(dOldAmt) THEN dOldAmt = 0

select Count(*) 	into :iCount from kfz12ot9
	where saupj = :lstr_jpra.saupjang and bal_date = :lstr_jpra.baldate and upmu_gu = :lstr_jpra.upmugu and
			bjun_no = :lstr_jpra.bjunno and lin_no = :lstr_jpra.sortno;
if IsNull(iCount) then iCount = 0

select nvl(cashgbn,'N') 	into :sCashGbn from kfz01om0 where acc1_cd = :lstr_jpra.acc1 and acc2_cd = :lstr_jpra.acc2;
if sCashGbn = 'N' then Return 1

select nvl(cashgbn,'N') 	into :sOldCashGbn from kfz01om0 where acc1_cd = :sOldAcc1 and acc2_cd = :sOldAcc2;
	
IF sModStatus ='M' AND (lstr_jpra.money = dOldAmt and lstr_jpra.acc1+lstr_jpra.acc2 = sOldAcc1+sOldAcc2) THEN 	
	IF sCashGbn = 'Y' AND iCount <> 0 THEN	Return 1	
END IF

IF sModStatus ='M' AND (lstr_jpra.money = dOldAmt and sCashGbn = 'Y' and sOldCashGbn = 'Y' AND iCount <> 0) THEN Return 1

SetNull(sNull)

IF lstr_jpra.bjunno = 0 OR IsNull(lstr_jpra.bjunno) THEN
	f_MessageChk(3,'')
	Return -1
END IF

Open(W_kglb017)

sProcGbn = Left(Message.StringParm,1)

IF sProcGbn <> '1' THEN
	F_MessageChk(17,'[자금수지상세]')
//	Wf_Open_Finance()
	Return -1
END IF
Return 1


end function

public function integer wf_open_vat ();Integer iPos
String  sProcGbn,sNull,sDescr

IF Is_UpmuGbn = 'Q' THEN Return 1

SetNull(sNull)

dw_ins.AcceptText()
lstr_jpra.saupjang = dw_ins.GetItemString(dw_ins.GetRow(),"saupj")
lstr_jpra.baldate  = dw_ins.GetItemString(dw_ins.GetRow(),"bal_date")
lstr_jpra.upmugu   = dw_ins.GetItemString(dw_ins.GetRow(),"upmu_gu")
lstr_jpra.bjunno   = dw_ins.GetItemNumber(dw_ins.GetRow(),"bjun_no")
lstr_jpra.sortno   = dw_ins.GetItemNumber(dw_ins.GetRow(),"lin_no")

lstr_jpra.saupno   = dw_ins2.GetItemString(dw_ins2.GetRow(),"saup_no")
lstr_jpra.chadae   = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu")
lstr_jpra.acc1     = dw_ins.GetItemString(dw_ins.GetRow(),"acc1_cd")
lstr_jpra.acc2     = dw_ins.GetItemString(dw_ins.GetRow(),"acc2_cd")
lstr_jpra.accname  = dw_ins.GetItemString(dw_ins.GetRow(),"acc1_nm") + ' - ' + &
							dw_ins.GetItemString(dw_ins.GetRow(),"acc2_nm") 
lstr_jpra.desc     = dw_ins.GetItemString(dw_ins.GetRow(),"descr")							

lstr_jpra.money    = dw_ins2.GetItemNumber(dw_ins2.GetRow(),"vatamt")
lstr_jpra.ymoney   = dw_ins2.GetItemNumber(dw_ins2.GetRow(),"amt")

IF lstr_jpra.bjunno = 0 OR IsNull(lstr_jpra.bjunno) THEN
	f_MessageChk(3,'')
	Return -1
END IF

iPos = Pos(lstr_jpra.desc,'[')
IF iPos <=0 THEN
ELSE
	lstr_jpra.desc     = Left(lstr_jpra.desc,iPos - 1)
END IF

//IF lstr_account.cus_gu = 'Y' AND (lstr_jpra.saupno = "" OR IsNull(lstr_jpra.saupno)) THEN
//	F_MessageChk(1,'[거래처]')
//	dw_ins2.SetColumn("saup_no")
//	dw_ins2.SetFocus()
//	Return -1
//END IF
	
Open(w_kglb01b) 

sProcGbn = Left(Message.StringParm,1)
IF sProcGbn = '1' THEN
//	sDescr = '['+Mid(Message.StringParm,2,70)+']' + lstr_jpra.desc
//	dw_ins.SetItem(dw_ins.GetRow(),"descr",    Left(sDescr,70))	
	Return 1	
ELSE
	Return -1
END IF



end function

public function integer wf_open_window (string sdcgbn);Str_Win	 Str_Open_WindowName
String    sProcGbn,sNull,sDescr
Integer   iPos

IF Is_UpmuGbn = 'Q' THEN Return 1

SetNull(sNull)

dw_ins.AcceptText()
lstr_jpra.saupjang = dw_ins.GetItemString(dw_ins.GetRow(),"saupj")
lstr_jpra.baldate  = dw_ins.GetItemString(dw_ins.GetRow(),"bal_date")
lstr_jpra.upmugu   = dw_ins.GetItemString(dw_ins.GetRow(),"upmu_gu")
lstr_jpra.bjunno   = dw_ins.GetItemNumber(dw_ins.GetRow(),"bjun_no")
lstr_jpra.sortno   = dw_ins.GetItemNumber(dw_ins.GetRow(),"lin_no")

lstr_jpra.saupno   = dw_ins2.GetItemString(dw_ins2.GetRow(),"saup_no")
lstr_jpra.chadae   = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu")
lstr_jpra.acc1     = dw_ins.GetItemString(dw_ins.GetRow(),"acc1_cd")
lstr_jpra.acc2     = dw_ins.GetItemString(dw_ins.GetRow(),"acc2_cd")
lstr_jpra.accname  = dw_ins.GetItemString(dw_ins.GetRow(),"acc1_nm") + ' - ' + &
							dw_ins.GetItemString(dw_ins.GetRow(),"acc2_nm") 
lstr_jpra.desc     = dw_ins.GetItemString(dw_ins.GetRow(),"descr")							

lstr_jpra.money    = dw_ins2.GetItemNumber(dw_ins2.GetRow(),"amt")
lstr_jpra.ymoney   = 0

lstr_jpra.kwan     = dw_ins2.GetItemString(dw_ins2.GetRow(),"kwan_no")

IF lstr_jpra.bjunno = 0 OR IsNull(lstr_jpra.bjunno) THEN
	f_MessageChk(3,'')
	
	IF Wf_JunPoy(lstr_jpra.saupjang,lstr_jpra.baldate) <= 0 THEN Return -1

	Wf_Button_Sts()
	
	lstr_jpra.bjunno = dw_ins.GetItemNumber(dw_ins.GetRow(),"bjun_no")
END IF

iPos = Pos(lstr_jpra.desc,'[')
IF iPos <=0 THEN
ELSE
	lstr_jpra.desc     = Left(lstr_jpra.desc,iPos - 1)
END IF

IF lstr_account.cus_gu = 'Y' AND (lstr_jpra.saupno = "" OR IsNull(lstr_jpra.saupno)) THEN
	F_MessageChk(1,'[거래처]')
	dw_ins2.SetColumn("saup_no")
	dw_ins2.SetFocus()
	Return -1
END IF
	
IF sDcGbn = '1' THEN														/*차변*/
	IF lstr_account.use_windowc = "" OR IsNull(lstr_account.use_windowc) THEN Return 2
		
	Str_Open_WindowName.name = lstr_account.use_windowc
	OpenWithParm(Str_Open_WindowName.window, Str_Open_WindowName.name, lstr_account.use_windowc) 

ELSE
	IF lstr_account.use_windowd = "" OR IsNull(lstr_account.use_windowd) THEN Return 2
		
	Str_Open_WindowName.name = lstr_account.use_windowd
	OpenWithParm(Str_Open_WindowName.window, Str_Open_WindowName.name, lstr_account.use_windowd) 	
END IF

sProcGbn = Left(Message.StringParm,1)

IF sProcGbn = '1' THEN
	IF lstr_account.jubdae_gu ='Y' THEN		/*접대비 처리 Y,보조 Y*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"jub_gu",'Y')	
	ELSEIF lstr_account.vat_gu ='Y' THEN		/*부가세 처리 Y,보조 Y*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"vat_gu",'Y')	
	ELSEIF lstr_account.sang_gu ='Y'  THEN		/*상계 처리 Y,보조 Y*/

		dw_ins2.SetItem(dw_ins2.GetRow(),"cross_gu",'Y')	
	ELSEIF lstr_account.paybil_gu = 'Y' THEN	/*지급어음 처리 Y,보조 Y*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"jbill_gu",'Y')	
	ELSEIF lstr_account.rcvbil_gu = 'Y' THEN		/*받을어음 처리 Y,보조 Y*/	
		dw_ins2.SetItem(dw_ins2.GetRow(),"rbill_gu",'Y')	
	ELSEIF lstr_account.ch_gu = 'Y' THEN		/*차입금 처리 Y,보조 Y*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"chaip_gu",'Y')	
	ELSEIF lstr_account.yu_gu = 'Y' THEN		/*유가증권 처리 Y,보조 Y*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"secu_gu",'Y')	
	ELSEIF lstr_account.fsang_gu = 'Y' THEN	/*외화외상매입금 처리 Y,보조 Y*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"fsang_gu",'Y')
	ELSEIF lstr_account.remark3 = 'Y' THEN	/*고정자산 처리 Y,보조 Y*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"aset_gu",'Y')	
	END IF
ELSE
	IF lstr_account.jubdae_gu ='Y' THEN		/*접대비 처리 Y,보조 N*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"jub_gu",'N')	
		F_MessageChk(17,'[접대비]')
	ELSEIF lstr_account.vat_gu ='Y' THEN		/*부가세 처리 Y,보조 N*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"vat_gu",'N')	
		F_MessageChk(17,'[부가세]')		
	ELSEIF lstr_account.sang_gu ='Y'  THEN		/*상계 처리 Y,보조 N*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"cross_gu",'N')	
		F_MessageChk(17,'[상계]')		
	ELSEIF lstr_account.paybil_gu ='Y' THEN	/*지급어음 처리 Y,보조 N*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"jbill_gu",'N')	
		F_MessageChk(17,'[지급어음]')		
	ELSEIF lstr_account.rcvbil_gu ='Y' THEN		/*받을어음 처리 Y,보조 N*/	
		dw_ins2.SetItem(dw_ins2.GetRow(),"rbill_gu",'N')	
		F_MessageChk(17,'[받을어음]')		
	ELSEIF lstr_account.ch_gu ='Y' THEN		/*차입금 처리 Y,보조 N*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"chaip_gu",'N')	
		F_MessageChk(17,'[차입금]')		
	ELSEIF lstr_account.yu_gu ='Y' THEN		/*유가증권 처리 Y,보조 N*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"secu_gu",'N')	
		F_MessageChk(17,'[유가증권]')		
	ELSEIF lstr_account.fsang_gu ='Y' THEN	/*외화외상매입금 처리 Y,보조 N*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"fsang_gu",'N')	
		F_MessageChk(17,'[외화외상매입금]')	
	ELSEIF lstr_account.remark3 ='Y' THEN	/*고정자산 처리 Y,보조 N*/
		dw_ins2.SetItem(dw_ins2.GetRow(),"aset_gu",'N')	
		F_MessageChk(17,'[고정자산]')	
	END IF
	Return 3
END IF

IF sProcGbn = '1' AND lstr_account.rcvbil_gu = 'Y' AND sDcGbn = '2' THEN 		/*받을어음 결제*/
	dw_ins2.SetItem(dw_ins2.GetRow(),"kwan_no",lstr_jpra.kwan)
	dw_ins2.SetItem(dw_ins2.GetRow(),"k_eymd", lstr_jpra.k_eymd)	
	dw_ins2.SetItem(dw_ins2.GetRow(),"exp_gu", lstr_jpra.status)
	
	IF Not IsNull(lstr_jpra.bnkname) AND lstr_jpra.bnkname <> "" THEN
		dw_ins.SetItem(dw_ins.GetRow(),"descr",    lstr_jpra.desc +'['+lstr_jpra.bnkname+']')	
	END IF
ELSEIF sProcGbn = '1' AND lstr_account.rcvbil_gu = 'Y' AND sDcGbn = '1' THEN 		/*받을어음 발행*/	
	dw_ins2.SetItem(dw_ins2.GetRow(),"kwan_no",lstr_jpra.kwan)
	dw_ins2.SetItem(dw_ins2.GetRow(),"k_eymd", lstr_jpra.k_eymd)	
ELSEIF sProcGbn = '1' AND lstr_account.paybil_gu = 'Y' AND sDcGbn = '1' THEN	/*지급어음 결제*/	
	dw_ins2.SetItem(dw_ins2.GetRow(),"kwan_no",lstr_jpra.kwan)
	dw_ins2.SetItem(dw_ins2.GetRow(),"k_eymd", lstr_jpra.k_eymd)	
ELSEIF sProcGbn = '1' AND lstr_account.paybil_gu = 'Y' AND sDcGbn = '2' THEN	/*지급어음 발행*/
	dw_ins2.SetItem(dw_ins2.GetRow(),"kwan_no",lstr_jpra.kwan)
	dw_ins2.SetItem(dw_ins2.GetRow(),"k_eymd", lstr_jpra.k_eymd)
//ELSEIF sProcGbn = '1' AND lstr_account.vat_gu ='Y' THEN
//	sDescr = lstr_jpra.desc +'['+Mid(Message.StringParm,2,70)+']'
//	dw_ins.SetItem(dw_ins.GetRow(),"descr",    Left(sDescr,70))	
ELSE
	dw_ins2.SetItem(dw_ins2.GetRow(),"kwan_no",sNull)
	dw_ins2.SetItem(dw_ins2.GetRow(),"exp_gu", sNull)
	dw_ins2.SetItem(dw_ins2.GetRow(),"k_eymd", sNull)	
END IF

/*차입금,유가증권 코드 자릿수 = 6자리 setting*/
IF sProcGbn = '1' AND (lstr_account.ch_gu = 'Y' OR lstr_account.yu_gu = 'Y') THEN
	dw_ins2.SetItem(dw_ins2.GetRow(),"saup_no",lstr_jpra.saupno)	
END IF

Return 1


end function

public subroutine wf_button_sts ();
IF Ib_ClickedFlag = False THEN
	
	dw_ins.Modify("bjun_no_t.visible = 0")
	dw_ins.Modify("dcb_junno.visible = 1")
	
ELSEIF Ib_ClickedFlag = True THEN
	
	dw_ins.Modify("bjun_no_t.visible = 1")
	dw_ins.Modify("dcb_junno.visible = 0")

	dw_ins.SetColumn("lin_no")
	dw_ins.SetFocus()

END IF

end subroutine

public function integer wf_get_account (string sacc1, string sacc2, string sdcgbn);String snull,sCashGbn,sCashAcc

SetNull(snull)

lstr_account.acc1_cd = sacc1
lstr_account.acc2_cd = sacc2

SELECT "KFZ01OM0"."ACC1_NM",   		"KFZ01OM0"."ACC2_NM",   		"KFZ01OM0"."DC_GU",   
       "KFZ01OM0"."CUS_GU",   		"KFZ01OM0"."GBN1",				"KFZ01OM0"."BAL_GU",
		 "KFZ01OM0"."YESAN_GU",			"KFZ01OM0"."SANG_GU",   		"KFZ01OM0"."JUBDAE_GU",
		 "KFZ01OM0"."VAT_GU",			"KFZ01OM0"."PAYBIL_GU",   		"KFZ01OM0"."RCVBIL_GU",
		 "KFZ01OM0"."CH_GU",				"KFZ01OM0"."YU_GU",  			"KFZ01OM0"."FSANG_GU",
		 "KFZ01OM0"."IJA_GU",			"KFZ01OM0"."ADMIN_GU", 	  		"KFZ01OM0"."USE_WINDOWC",
		 "KFZ01OM0"."USE_WINDOWD",    "KFZ01OM0"."GBN5",				"KFZ01OM0"."REMARK1",
		 "KFZ01OM0"."REMARK2",			"KFZ01OM0"."REMARK3",			"KFZ01OM0"."REMARK4",
		 "KFZ01OM0"."TAXGBN"
INTO :lstr_account.acc1_nm,			:lstr_account.acc2_nm,			:lstr_account.dcr_gu,     &
	  :lstr_account.cus_gu,				:lstr_account.gbn1,				:lstr_account.bal_gu,     &
	  :lstr_account.yesan_gu,			:lstr_account.sang_gu,			:lstr_account.jubdae_gu,  &
	  :lstr_account.vat_gu,				:lstr_account.paybil_gu,	   :lstr_account.rcvbil_gu,  &
	  :lstr_account.ch_gu,				:lstr_account.yu_gu,				:lstr_account.fsang_gu,   &
	  :lstr_account.ija_gu,				:lstr_account.admin_gu,			:lstr_account.use_windowc,&
	  :lstr_account.use_windowd,		:lstr_account.gbn5,				:lstr_account.remark1,	  &
	  :lstr_account.remark2,			:lstr_account.remark3,			:lstr_account.remark4,    &
	  :lstr_account.taxgbn
FROM "KFZ01OM0"  
WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
				
IF SQLCA.SQLCODE = -1 OR SQLCA.SQLCODE = 100 THEN
	F_MessageChk(20,'[계정과목]')
	dw_ins2.Modify("saup_no_t.text = '거래처'")
	Return -1
ELSE
	select substr(dataname,1,7)	into :sCashAcc	from syscnfg where sysgu = 'A' and serial = 1 and lineno = '1';
	
//	IF sCashAcc = sAcc1+sAcc2 and (Is_JunGbn = '1' or Is_JunGbn = '2') then
//		F_MessageChk(25,'[입출금전표 <> 현금계정]')
//		Return -1
//	END IF
	IF Is_JunGbn = '3' THEN
		sDcGbn = lstr_account.dcr_gu
	END IF
	
	select nvl(cashgbn,'N') 	into :sCashGbn from kfz01om0 where acc1_cd = :sAcc1 and acc2_cd = :sAcc2;

	IF sCashGbn = 'Y' AND sModStatus ='M' THEN
		dw_ins.Modify("dcb_finance.visible = 1")
	ELSE
		dw_ins.Modify("dcb_finance.visible = 0")		
	END IF
	
	IF lstr_account.gbn1 = "" OR IsNull(lstr_account.gbn1) THEN lstr_account.gbn1 ='%'
	
	IF lstr_account.bal_gu ='4' THEN
		F_MessageChk(16,'[전표발행 불가]')
	ELSEIF lstr_account.bal_gu = '1' AND sdcgbn ='2' THEN
		F_Messagechk(16,'[차변 발행 계정]')
	ELSEIF lstr_account.bal_gu ='2'AND sdcgbn ='1' THEN
		F_Messagechk(16,'[대변 발행 계정]')
	ELSe
		IF lstr_account.dcr_gu = sdcgbn AND (lstr_account.yesan_gu = 'Y' OR lstr_account.yesan_gu = 'A') THEN
			
			dw_ins2.Modify("cdept_cd.protect = 0")				
			p_yesan.Enabled = True
		ELSE
			dw_ins2.Modify("cdept_cd.protect = 1")	
			
			p_yesan.Enabled = False
			
			dw_ins2.SetItem(dw_ins2.GetRow(),"cdept_cd",snull)
		END IF

		IF lstr_account.gbn5 = 'Y' AND sDcGbn = lstr_account.dcr_gu THEN
			dw_ins2.Modify("gyul_date.protect = 0")	
		ELSE
			dw_ins2.Modify("gyul_date.protect = 1")
		END IF
		
		IF lstr_account.cus_gu = 'Y' THEN
			dw_ins2.Modify("saup_no_t.text = '" + f_get_refferance('CU',lstr_account.gbn1) +"'")
		ELSE
			dw_ins2.Modify("saup_no_t.text = '거래처'")
		END IF
				
		IF lstr_account.cus_gu = 'Y' THEN
			dw_ins2.Modify("saup_no.protect = 0")
			
		ELSE
			dw_ins2.Modify("saup_no.protect = 1")				
			
		END IF
		
		IF lstr_account.vat_gu = 'Y' THEN
			dw_ins2.Modify("vat_gu.visible = 0")
			dw_ins2.Modify("vat_gu_t.visible = 0")
		ELSE
			dw_ins2.Modify("vat_gu.visible = 1")	
			dw_ins2.Modify("vat_gu_t.visible = 1")
		END IF
		
		IF lstr_account.remark1 = 'Y' AND sDcGbn = lstr_account.dcr_gu THEN	/*원가부문필수여부*/
			dw_ins2.Modify("sdept_cd.protect = 0")
			
			dw_ins2.Modify("dcb_sdeptdetail.visible = 1")	
		ELSE
			dw_ins2.Modify("sdept_cd.protect = 1")				
			
			dw_ins2.Modify("dcb_sdeptdetail.visible = 0")	
			
			dw_ins2.SetItem(dw_ins2.GetRow(),"sdept_cd",snull)				
		END IF
		
		Return 1
	END IF
	Return -1
END IF

end function

public subroutine wf_position_col (integer iposition, string scolid, string scolname, string sreqgbn, string schkcust);Integer  iXPosition[4]  = {2880, 3227, 3753, 4101}
Integer  iYPosition[9]  = {72,   148,  224,  300,   376,   452,   528,  604,  680}	

Integer  iXPositionReq[2] = {2853, 3726}
Integer  iXPositionBmp[2] = {3154, 4017}

Integer  iX,iY, iX_Req

String   sColColor

IF sReqGbn = 'Y' THEN											/*필수입력*/
	sColColor = String(Rgb(190,225,184))
ELSE
	sColColor = String(Rgb(255,255,255))	
END IF

IF Mod(iPosition,2) <> 0 THEN									/*X 위치 구하기*/
	iX = 1
	iX_Req = 1
ELSE
	iX = 3
	iX_Req = 2
//	iX = Mod(iPosiTion,2)
//	IF iX = 1 THEN
//		iX = iX + 1
//	ELSEIF iX = 3 THEN
//		iX = iX + 2
//	END IF
END IF

//iY = iPosiTion
//IF Mod(iPosition, 2) = 0 THEN										/*Y 위치 구하기*/
//	iY = 1
//ELSE
//	iY = Mod(iPosiTion,2)
//END IF

if iPosition - 1 <=0 then
	iY = 1
else
	iY = Truncate((iPosition - 1) / 2, 0) + 1
end if

CHOOSE CASE sColId
	CASE 'kwan_no'
		dw_ins2.Object.kwan_no_t.X = iXPosition[iX]
		dw_ins2.Object.kwan_no_t.Y = iYPosition[iY]
		
		dw_ins2.Object.kwan_no.X = iXPosition[iX + 1]
		dw_ins2.Object.kwan_no.Y = iYPosition[iY]
		
		dw_ins2.Object.kwan_no_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.kwan_no_t.Y = iYPosition[iY]
		
		IF sChkCust = "" OR IsNull(sChkCust) THEN
			dw_ins2.Modify("kwan_no_t.text ='"+sColName+"'")
//			dw_ins2.Modify("kwan_no.background.color ='"+sColColor+"'")
		ELSE
			dw_ins2.Modify("kwan_no_t.text ='"+F_Get_Refferance('CU',sChkCust)+"'")			
//			dw_ins2.Modify("kwan_no.background.color = 65535")
		END IF
	Case 'itm_gu'
		dw_ins2.Object.itm_gu_t.X = iXPosition[iX]
		dw_ins2.Object.itm_gu_t.Y = iYPosition[iY]
				
		dw_ins2.Object.itm_gu.X = iXPosition[iX + 1]
		dw_ins2.Object.itm_gu.Y = iYPosition[iY]

		dw_ins2.Object.itm_gu_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.itm_gu_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("itm_gu_t.text ='"+sColName+"'")
//		dw_ins2.Modify("itm_gu.background.color ='"+sColColor+"'")
	Case 'k_qty' 
		dw_ins2.Object.k_qty_t.X = iXPosition[iX]
		dw_ins2.Object.k_qty_t.Y = iYPosition[iY]
				
		dw_ins2.Object.k_qty.X = iXPosition[iX + 1]
		dw_ins2.Object.k_qty.Y = iYPosition[iY]
		
		dw_ins2.Object.k_qty_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.k_qty_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("k_qty_t.text ='"+sColName+"'")
//		dw_ins2.Modify("k_qty.background.color ='"+sColColor+"'")
	Case 'k_uprice'
		dw_ins2.Object.k_uprice_t.X = iXPosition[iX]
		dw_ins2.Object.k_uprice_t.Y = iYPosition[iY]
				
		dw_ins2.Object.k_uprice.X = iXPosition[iX + 1]
		dw_ins2.Object.k_uprice.Y = iYPosition[iY]
		
		dw_ins2.Object.k_uprice_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.k_uprice_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("k_uprice_t.text ='"+sColName+"'")
//		dw_ins2.Modify("k_uprice.background.color ='"+sColColor+"'")

	Case 'k_amt'
		dw_ins2.Object.k_amt_t.X = iXPosition[iX]
		dw_ins2.Object.k_amt_t.Y = iYPosition[iY]
				
		dw_ins2.Object.k_amt.X = iXPosition[iX + 1]
		dw_ins2.Object.k_amt.Y = iYPosition[iY]
		
		dw_ins2.Object.k_amt_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.k_amt_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("k_amt_t.text ='"+sColName+"'")
//		dw_ins2.Modify("k_amt.background.color ='"+sColColor+"'")
	
	Case 'k_rate'
		dw_ins2.Object.k_rate_t.X = iXPosition[iX]
		dw_ins2.Object.k_rate_t.Y = iYPosition[iY]
				
		dw_ins2.Object.k_rate.X = iXPosition[iX + 1]
		dw_ins2.Object.k_rate.Y = iYPosition[iY]
		
		dw_ins2.Object.k_rate_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.k_rate_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("k_rate_t.text ='"+sColName+"'")
//		dw_ins2.Modify("k_rate.background.color ='"+sColColor+"'")
	Case 'y_amt'
		dw_ins2.Object.y_amt_t.X = iXPosition[iX]
		dw_ins2.Object.y_amt_t.Y = iYPosition[iY]
				
		dw_ins2.Object.y_amt.X = iXPosition[iX + 1]
		dw_ins2.Object.y_amt.Y = iYPosition[iY]
		
		dw_ins2.Object.y_amt_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.y_amt_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("y_amt_t.text ='"+sColName+"'")
//		dw_ins2.Modify("y_amt.background.color ='"+sColColor+"'")	
	Case 'y_rate'
		dw_ins2.Object.y_rate_t.X = iXPosition[iX]
		dw_ins2.Object.y_rate_t.Y = iYPosition[iY]
				
		dw_ins2.Object.y_rate.X = iXPosition[iX + 1]
		dw_ins2.Object.y_rate.Y = iYPosition[iY]
		
		dw_ins2.Object.y_rate_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.y_rate_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("y_rate_t.text ='"+sColName+"'")
//		dw_ins2.Modify("y_rate.background.color ='"+sColColor+"'")	
	Case 'y_curr'
		dw_ins2.Object.y_curr_t.X = iXPosition[iX]
		dw_ins2.Object.y_curr_t.Y = iYPosition[iY]
				
		dw_ins2.Object.y_curr.X = iXPosition[iX + 1]
		dw_ins2.Object.y_curr.Y = iYPosition[iY]
		
		dw_ins2.Object.y_curr_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.y_curr_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("y_curr_t.text ='"+sColName+"'")
//		dw_ins2.Modify("y_curr.background.color ='"+sColColor+"'")	
	Case 'exp_gu'
		DataWindowChild Dw_Child
		Integer    iVal

		iVal = dw_ins2.GetChild("exp_gu",Dw_Child)
		IF iVal = 1 THEN
			IF lstr_account.ch_gu = 'Y' or Wf_Chk_Chaip() = 1 then
				dw_child.Retrieve('2')
			ELSE
				if lstr_account.gbn1 = '5' then
					dw_child.Retrieve('3')
				else
					dw_child.Retrieve('1')
				end if
			END IF
		END IF

		dw_ins2.Object.exp_gu_t.X = iXPosition[iX]
		dw_ins2.Object.exp_gu_t.Y = iYPosition[iY]
				
		dw_ins2.Object.exp_gu.X = iXPosition[iX + 1]
		dw_ins2.Object.exp_gu.Y = iYPosition[iY]
		
		dw_ins2.Object.exp_gu_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.exp_gu_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("exp_gu_t.text ='"+sColName+"'")
	Case 'k_symd' 
		dw_ins2.Object.k_symd_t.X = iXPosition[iX]
		dw_ins2.Object.k_symd_t.Y = iYPosition[iY]
				
		dw_ins2.Object.k_symd.X = iXPosition[iX + 1]
		dw_ins2.Object.k_symd.Y = iYPosition[iY]
		
		dw_ins2.Object.k_symd_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.k_symd_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("k_symd_t.text ='"+sColName+"'")	
	Case 'k_eymd'
		dw_ins2.Object.k_eymd_t.X = iXPosition[iX]
		dw_ins2.Object.k_eymd_t.Y = iYPosition[iY]
				
		dw_ins2.Object.k_eymd.X = iXPosition[iX + 1]
		dw_ins2.Object.k_eymd.Y = iYPosition[iY]
		
		dw_ins2.Object.k_eymd_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.k_eymd_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("k_eymd_t.text ='"+sColName+"'")	
	CASE 'kwan_no2'
		dw_ins2.Object.kwan_no2_t.X = iXPosition[iX]
		dw_ins2.Object.kwan_no2_t.Y = iYPosition[iY]
		
		dw_ins2.Object.kwan_no2.X = iXPosition[iX + 1]
		dw_ins2.Object.kwan_no2.Y = iYPosition[iY]
		
		dw_ins2.Object.kwan_no2_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.kwan_no2_t.Y = iYPosition[iY]

		dw_ins2.Modify("kwan_no2_t.text ='"+sColName+"'")
	CASE 'kwan_no3'
		dw_ins2.Object.kwan_no3_t.X = iXPosition[iX]
		dw_ins2.Object.kwan_no3_t.Y = iYPosition[iY]
		
		dw_ins2.Object.kwan_no3.X = iXPosition[iX + 1]
		dw_ins2.Object.kwan_no3.Y = iYPosition[iY]
		
		dw_ins2.Object.kwan_no3_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.kwan_no3_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("kwan_no3_t.text ='"+sColName+"'")
	Case 'gyul_date'
		dw_ins2.Object.gyul_date_t.X = iXPosition[iX]
		dw_ins2.Object.gyul_date_t.Y = iYPosition[iY]
				
		dw_ins2.Object.gyul_date.X = iXPosition[iX + 1]
		dw_ins2.Object.gyul_date.Y = iYPosition[iY]
		
		dw_ins2.Object.gyul_date_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.gyul_date_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("gyul_date_t.text ='"+sColName+"'")
	Case 'gyul_method'
		dw_ins2.Object.gyul_method_t.X = iXPosition[iX]
		dw_ins2.Object.gyul_method_t.Y = iYPosition[iY]
				
		dw_ins2.Object.gyul_method.X = iXPosition[iX + 1]
		dw_ins2.Object.gyul_method.Y = iYPosition[iY]
		
		dw_ins2.Object.gyul_method_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.gyul_method_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("gyul_method_t.text ='"+sColName+"'")
	Case 'taxgbn'
		dw_ins2.Object.taxgbn_t.X = iXPosition[iX]
		dw_ins2.Object.taxgbn_t.Y = iYPosition[iY]
				
		dw_ins2.Object.taxgbn.X = iXPosition[iX + 1]
		dw_ins2.Object.taxgbn.Y = iYPosition[iY]
		
		dw_ins2.Object.taxgbn_t.X = iXPositionReq[iX_Req]
		dw_ins2.Object.taxgbn_t.Y = iYPosition[iY]
		
		dw_ins2.Modify("taxgbn_t.text ='"+sColName+"'")	
END CHOOSE
end subroutine

public subroutine wf_append_init (integer llinno, integer irowcount);
Ib_ClickedFlag = True

lLinNo = lLinNo + 1

SetNull(Ls_SangGbn)
SetNull(Ls_SangCust)

dw_ins.SetRedraw(False)
dw_ins.Reset()
dw_ins.InsertRow(0)

dw_ins.SetItem(dw_ins.GetRow(),"saupj",   dw_rtv.GetItemString(iRowCount,"saupj"))
dw_ins.SetItem(dw_ins.GetRow(),"bal_date",dw_rtv.GetItemString(iRowCount,"bal_date"))
dw_ins.SetItem(dw_ins.GetRow(),"dept_cd", dw_rtv.GetItemString(iRowCount,"dept_cd"))
dw_ins.SetItem(dw_ins.GetRow(),"deptname",&
						F_Get_PersonLst('3',dw_rtv.GetItemString(iRowCount,"dept_cd"),'%'))
dw_ins.SetItem(dw_ins.GetRow(),"upmu_gu", dw_rtv.GetItemString(iRowCount,"upmu_gu"))
dw_ins.SetItem(dw_ins.GetRow(),"bjun_no", dw_rtv.GetItemNumber(iRowCount,"bjun_no"))
dw_ins.SetItem(dw_ins.GetRow(),"lin_no",  Llinno)

dw_ins.SetItem(dw_ins.GetRow(),"jun_gu",  dw_rtv.GetItemString(iRowCount,"jun_gu"))

dw_ins.SetItem(dw_ins.GetRow(),"sawon",   dw_rtv.GetItemString(iRowCount,"sawon"))
dw_ins.SetItem(dw_ins.GetRow(),"empname", & 
						F_Get_PersonLst('4',dw_rtv.GetItemString(iRowCount,"sawon"),'%'))
dw_ins.SetItem(dw_ins.GetRow(),"descr",   dw_rtv.GetItemString(iRowCount,"descr"))

dw_ins.SetItem(dw_ins.GetRow(),"jun_gu",  Is_JunGbn)
dw_ins.Modify("jun_gu.protect = 1")

dw_ins.SetItem(dw_ins.GetRow(),"indat",   f_today())

if Is_JunGbn = '3' then									/*대체전표*/
	dw_ins.Modify("dcr_gu.protect = 0")
else
	dw_ins.Modify("dcr_gu.protect = 1")
	
	if Is_JunGbn = '1' then
		dw_ins.SetItem(1,"dcr_gu", '2')
	else
		dw_ins.SetItem(1,"dcr_gu", '1')
	end if
end if

dw_ins.Modify("saupj.protect = 1")
dw_ins.Modify("bal_date.protect = 1")
dw_ins.Modify("dept_cd.protect = 1")
dw_ins.Modify("deptname.protect = 1")
dw_ins.Modify("bjun_no.protect = 1")
dw_ins.Modify("lin_no.protect = 0")
dw_ins.Modify("jun_gu.protect = 1")
dw_ins.Modify("sawon.protect = 1")
dw_ins.Modify("empname.protect = 1")

dw_ins.Modify("dcb_finance.visible = 0")
dw_ins.SetRedraw(True)

dw_ins2.SetRedraw(False)

DataWindowChild Dw_Child
Integer    iVal

dw_ins2.Reset()
iVal = dw_ins2.GetChild("exp_gu",Dw_Child)
IF iVal = 1 THEN
	dw_child.SetTransObject(Sqlca)
	dw_child.Retrieve('1')
END IF
dw_ins2.InsertRow(0)

dw_ins2.SetItem(dw_ins2.GetRow(),"sdept_cd",   dw_rtv.GetItemString(iRowCount,"sdept_cd"))
dw_ins2.SetItem(dw_ins2.GetRow(),"saup_no",    dw_rtv.GetItemString(iRowCount,"saup_no"))
dw_ins2.SetItem(dw_ins2.GetRow(),"in_nm",   	  dw_rtv.GetItemString(iRowCount,"in_nm"))

dw_ins2.SetItem(dw_ins2.GetRow(),"gyul_method",dw_rtv.GetItemString(iRowCount,"gyul_method"))
//dw_ins2.SetItem(dw_ins2.GetRow(),"cr_cd",   	  dw_rtv.GetItemString(iRowCount,"cr_cd"))

dw_ins2.Modify("gyul_date.protect = 1")				

dw_ins2.Modify("saup_no_t.text = '거래처'")
dw_ins2.Modify("vat_gu.visible = 1")	
dw_ins2.Modify("vat_gu_t.visible = 1")	

Wf_Setting_RefLst('00000','00','1')

dw_ins2.SetRedraw(True)

w_mdi_frame.sle_msg.text =""

dw_rtv.ScrollToRow(dw_rtv.RowCount())

Double dCha,dDae

IF Is_JunGbn = '3' THEN			/*대체전표*/
	dCha = dw_rtv.GetItemNumber(dw_rtv.RowCount(),"sum_cha")
	dDae = dw_rtv.GetItemNumber(dw_rtv.RowCount(),"sum_dae")
	IF dCha = dDae THEN
		p_Mod.Enabled = True
	ELSE
		p_mod.Enabled = False
	END IF
ELSE
	p_mod.Enabled = True	
END IF

Wf_Button_Sts()									/*전표 버튼 상태*/

Wf_Clear_Structure('ACCOUNT')					/*계정과목 구조체 초기화*/
Wf_Clear_Structure('CUST')						/*거래처  구조체 초기화*/

p_yesan.Enabled = False

dw_ins.SetColumn("acc1_cd")
dw_ins.SetFocus()


end subroutine

public subroutine wf_insert_init ();/*화면의 초기화                      */
/*등록 모드이면서 첫번째 라인 입력 시*/
String sSdeptCode,snull,sStatusText

SELECT "CIA02M"."COST_CD"      INTO :sSdeptCode  
	FROM "CIA02M"  
   WHERE "CIA02M"."DEPT_CD" = :Gs_Dept;

SetNull(snull)
SetNull(Ls_SangGbn)
SetNull(Ls_SangCust)

dw_descr.Reset()

dw_ins.SetRedraw(False)
dw_ins2.SetRedraw(False)

dw_ins.Reset()
dw_ins.InsertRow(0)

dw_ins.SetItem(1,"saupj",    Str_Junpoy.Saupjang)
dw_ins.SetItem(1,"bal_date", f_today())
dw_ins.SetItem(1,"dept_cd",  gs_dept)
dw_ins.SetItem(1,"deptname", F_Get_PersonLst('3',Gs_Dept,'%'))

dw_ins.SetItem(1,"sawon",    Gs_EmpNo)
dw_ins.SetItem(1,"empname",  F_Get_PersonLst('4',Gs_EmpNo,'1'))

dw_ins.SetItem(1,"upmu_gu",  Is_UpmuGbn)
dw_ins.SetItem(1,"sflag",    'I')

dw_ins.SetItem(1,"jun_gu",   Is_JunGbn)
dw_ins.Modify("jun_gu.protect = 0")

dw_ins.SetItem(1,"indat",    f_today())

dw_ins.Modify("dcb_finance.visible = 0")
ib_any_typing = False

if Is_JunGbn = '3' then									/*대체전표*/
	dw_ins.Modify("dcr_gu.protect = 0")
else
	dw_ins.Modify("dcr_gu.protect = 1")
	
	if Is_JunGbn = '1' then
		dw_ins.SetItem(1,"dcr_gu", '2')
	else
		dw_ins.SetItem(1,"dcr_gu", '1')
	end if
end if

IF sModStatus = 'I' THEN										/*등록*/
	dw_ins.Modify("bjun_no.protect = 1")
	
	Ib_ClickedFlag = False											/*전표번호 채번 여부*/
	p_inq.Enabled = False
	p_print.Enabled = False
ELSE																	
	dw_ins.Modify("bjun_no.protect = 0")
	
	Ib_ClickedFlag = True											/*전표번호 채번 여부*/
	p_inq.Enabled = True	
	p_print.Enabled = True
END IF

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ins.Modify("saupj.protect = 1")
	dw_ins.Modify("dept_cd.protect = 1")
	dw_ins.Modify("deptname.protect = 1")
ELSE
	dw_ins.Modify("saupj.protect = 0")
	dw_ins.Modify("dept_cd.protect = 0")
	dw_ins.Modify("deptname.protect = 0")
END IF
dw_ins.Modify("bal_date.protect = 0")
dw_ins.Modify("jun_gu.protect = 0")
dw_ins.Modify("sawon.protect = 0")
dw_ins.Modify("empname.protect = 0")

Wf_Button_Sts()									/*전표 버튼 상태*/

Wf_Clear_Structure('ACCOUNT')					/*계정과목 구조체 초기화*/
Wf_Clear_Structure('CUST')						/*거래처  구조체 초기화*/

DataWindowChild Dw_Child
Integer    iVal

dw_ins2.Reset()
iVal = dw_ins2.GetChild("exp_gu",Dw_Child)
IF iVal = 1 THEN
	dw_child.SetTransObject(Sqlca)
	dw_child.Retrieve('1')
END IF
dw_ins2.InsertRow(0)

dw_ins2.SetItem(dw_ins2.GetRow(),"sdept_cd", sSdeptCode  )

Wf_Setting_RefLst('00000','00','1')

dw_ins.SetRedraw(True)
dw_ins2.SetRedraw(True)

dw_ins2.Modify("saup_no_t.text = '거래처'")
dw_ins2.Modify("vat_gu.visible = 1")	
dw_ins2.Modify("vat_gu_t.visible = 1")	

dw_rtv.Reset()

p_addrow.Enabled   = True
p_delrow.Enabled   = True
p_yesan.Enabled = False

dw_ins2.Modify("gyul_date.protect = 1")

IF Is_JunGbn = '1' THEN	
	sStatusText = '입금 전표'
ELSEIF Is_JunGbn = '2' THEN	
	sStatusText = '출금 전표'
ELSEIF Is_JunGbn = '3' THEN	
	sStatusText = '대체 전표'
END IF

/*자동 승인 처리 여부*/
sAutoChk = Wf_Check_AutoSungin(Gs_Dept)

this.Title = '전표 조회 [전표구분 : '+F_Get_Refferance('AG',Is_UpmuGbn)+' : '+sStatusText+']'
//w_mdi_frame.sle_msg.text ="전표번호 채번은 전표번호를 클릭하거나 FUNCTION KEY(F3)을 사용하세요!!"

dw_ins.SetColumn("bal_date")
dw_ins.SetFocus()

end subroutine

public subroutine wf_invisible_kwanlst (string scolid, string sstatus, integer itaborder, string sreqstatus);Integer  iValue,iReqSts

/*계정별 관리항목 에서 사용 안하는 항목 숨기기*/
IF sStatus = 'Y' THEN
	iValue = 1
ELSE
	iValue = 0
END IF

if sReqStatus = 'Y' then
	iReqSts = 1
else
	iReqSts = 0
end if

CHOOSE CASE sColId
	CASE 'kwan_no'
		dw_ins2.Object.kwan_no_t.visible = iValue
		dw_ins2.Object.kwan_no.visible = iValue
		dw_ins2.Object.kwan_no.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_kwan_no.visible = iReqSts
//		dw_ins2.Object.p_kwan_no.visible = iValue
	CASE 'itm_gu'
		dw_ins2.Object.itm_gu_t.visible = iValue
		dw_ins2.Object.itm_gu.visible = iValue
		dw_ins2.Object.itm_gu.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_itm_gu.visible = iReqSts
	Case 'k_qty' 
		dw_ins2.Object.k_qty_t.visible = iValue
		dw_ins2.Object.k_qty.visible = iValue
		dw_ins2.Object.k_qty.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_k_qty.visible = iReqSts
	Case 'k_uprice'
		dw_ins2.Object.k_uprice_t.visible = iValue
		dw_ins2.Object.k_uprice.visible = iValue
		dw_ins2.Object.k_uprice.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_k_uprice.visible = iReqSts
	Case 'k_amt'
		dw_ins2.Object.k_amt_t.visible = iValue
		dw_ins2.Object.k_amt.visible = iValue
		dw_ins2.Object.k_amt.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_k_amt.visible = iReqSts
	Case 'k_rate'
		dw_ins2.Object.k_rate_t.visible = iValue
		dw_ins2.Object.k_rate.visible = iValue
		dw_ins2.Object.k_rate.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_k_rate.visible = iReqSts
	Case 'y_amt'
		dw_ins2.Object.y_amt_t.visible = iValue
		dw_ins2.Object.y_amt.visible = iValue
		dw_ins2.Object.y_amt.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_y_amt.visible = iReqSts
	Case 'y_rate'
		dw_ins2.Object.y_rate_t.visible = iValue
		dw_ins2.Object.y_rate.visible = iValue
		dw_ins2.Object.y_rate.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_y_rate.visible = iReqSts
	Case 'y_curr'
		dw_ins2.Object.y_curr_t.visible = iValue
		dw_ins2.Object.y_curr.visible = iValue
		dw_ins2.Object.y_curr.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_y_curr.visible = iReqSts
	Case 'exp_gu'
		dw_ins2.Object.exp_gu_t.visible = iValue
		dw_ins2.Object.exp_gu.visible = iValue
		dw_ins2.Object.exp_gu.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_exp_gu.visible = iReqSts
	Case 'k_symd' 
		dw_ins2.Object.k_symd_t.visible = iValue
		dw_ins2.Object.k_symd.visible = iValue
		dw_ins2.Object.k_symd.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_k_symd.visible = iReqSts
	Case 'k_eymd'
		dw_ins2.Object.k_eymd_t.visible = iValue
		dw_ins2.Object.k_eymd.visible = iValue
		dw_ins2.Object.k_eymd.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_k_eymd.visible = iReqSts
	CASE 'kwan_no2'
		dw_ins2.Object.kwan_no2_t.visible = iValue
		dw_ins2.Object.kwan_no2.visible = iValue
		dw_ins2.Object.kwan_no2.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_kwan_no2.visible = iReqSts
//		dw_ins2.Object.p_kwan_no2.visible = iValue
	CASE 'kwan_no3'
		dw_ins2.Object.kwan_no3_t.visible = iValue
		dw_ins2.Object.kwan_no3.visible = iValue
		dw_ins2.Object.kwan_no3.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_kwan_no3.visible = iReqSts
//		dw_ins2.Object.p_kwan_no3.visible = iValue
	CASE 'gyul_date'
		dw_ins2.Object.gyul_date_t.visible = iValue
		dw_ins2.Object.gyul_date.visible = iValue
		dw_ins2.Object.gyul_date.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_gyul_date.visible = iReqSts
	CASE 'gyul_method'
		dw_ins2.Object.gyul_method_t.visible = iValue
		dw_ins2.Object.gyul_method.visible = iValue
		dw_ins2.Object.gyul_method.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_gyul_method.visible = iReqSts
	CASE 'taxgbn'
		dw_ins2.Object.taxgbn_t.visible = iValue
		dw_ins2.Object.taxgbn.visible = iValue
		dw_ins2.Object.taxgbn.TabSequence = iTabOrder
		
//		dw_ins2.Object.t_taxgbn.visible = iReqSts
END CHOOSE
end subroutine

public subroutine wf_setting_reflst (string sacc1, string sacc2, string schadae);/*계정별로 관리하는 항목의 위치 및 속성 정의*/
String sKwanCol[17] = {'kwan_no',	'itm_gu',	&
							  'k_qty',		'k_uprice',	'k_amt',		'k_rate',&
							  'y_amt',		'y_rate',	'y_curr',	'kwan_no2',&
							  'exp_gu',		'k_symd',	'k_eymd',	'kwan_no3',&
							  'gyul_date',	'gyul_method','taxgbn'}
Boolean bVisibleFlag[17]														/*관리항목 표시 여부*/									  
Integer k,i,iFindRow,iApplyRow = 0, iTabOrder = 80
String  sKwanColName,sRequiredGbn,sKwanGbn,sKwanColId

dw_ins2.SetRedraw(False)
IF dw_kwan.Retrieve(sacc1,sacc2,schadae,'%') <=0 THEN
	dw_ins2.SetItem(dw_ins2.GetRow(),"skwanflag",'0')
	
	FOR k = 1 TO 17
		Wf_InVisible_KwanLst(sKwanCol[k],'N',0,'N')						/*display = no*/
	NEXT
	
ELSE
	dw_ins2.SetItem(dw_ins2.GetRow(),"skwanflag",'1')
	
	/* 99.08.17 수정 : 관리항목의 sort순으로 표시되도록 수정*/
	FOR i = 1 TO dw_kwan.RowCount()
		sKwanColId = dw_kwan.GetItemString(i,"kwan_colid")
		
		FOR k = 1 TO 17
			IF sKwanColId = sKwanCol[k] THEN	
				sKwanColName = dw_kwan.GetItemString(i,"kwan_colnm")			
				sRequiredGbn = dw_kwan.GetItemString(i,"reqchk")			
				sKwanGbn     = dw_kwan.GetItemString(i,"ref_gbn")			
				
				Wf_InVisible_KwanLst(sKwanCol[k],'Y',iTabOrder + k, sRequiredGbn)			/*display = yes*/
				
				iTabOrder = iTabOrder + k
				
				iApplyRow = iApplyRow + 1
				
				Wf_Position_Col(iApplyRow,sKwanCol[k],sKwanColName,sRequiredGbn,sKwanGbn)
				
				bVisibleFlag[k] = True
			ELSE
				IF bVisibleFlag[k] = False THEN
					Wf_InVisible_KwanLst(sKwanCol[k],'N',0,'N')						/*display = no*/
				END IF
			END IF
		NEXT
	NEXT
END IF
dw_ins2.SetRedraw(True)
end subroutine

on w_kgld69c.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_yesan=create cb_yesan
this.dw_rtv=create dw_rtv
this.dw_kwan=create dw_kwan
this.dw_ins2=create dw_ins2
this.dw_ins=create dw_ins
this.dw_print=create dw_print
this.dw_sang=create dw_sang
this.dw_sungin=create dw_sungin
this.dw_descr=create dw_descr
this.p_yesan=create p_yesan
this.cb_ins2=create cb_ins2
this.p_ok=create p_ok
this.rr_5=create rr_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_yesan
this.Control[iCurrent+3]=this.dw_rtv
this.Control[iCurrent+4]=this.dw_kwan
this.Control[iCurrent+5]=this.dw_ins2
this.Control[iCurrent+6]=this.dw_ins
this.Control[iCurrent+7]=this.dw_print
this.Control[iCurrent+8]=this.dw_sang
this.Control[iCurrent+9]=this.dw_sungin
this.Control[iCurrent+10]=this.dw_descr
this.Control[iCurrent+11]=this.p_yesan
this.Control[iCurrent+12]=this.cb_ins2
this.Control[iCurrent+13]=this.p_ok
this.Control[iCurrent+14]=this.rr_5
end on

on w_kgld69c.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.cb_yesan)
destroy(this.dw_rtv)
destroy(this.dw_kwan)
destroy(this.dw_ins2)
destroy(this.dw_ins)
destroy(this.dw_print)
destroy(this.dw_sang)
destroy(this.dw_sungin)
destroy(this.dw_descr)
destroy(this.p_yesan)
destroy(this.cb_ins2)
destroy(this.p_ok)
destroy(this.rr_5)
end on

event open;String sMsgParm

F_Window_Center_Response(This)

Str_Junpoy = Message.PowerObjectParm

/*환경 파일에서 '부도어음' 계정코드 가져오기*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),	  SUBSTR("SYSCNFG"."DATANAME",6,2)
	INTO :LsBudoAcc1,								  :LsBudoAcc2  
	FROM "SYSCNFG"  
	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
			( "SYSCNFG"."LINENO" = '18' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsBudoAcc1 = '00000'
	LsBudoAcc2 = '00'
ELSE
	IF IsNull(LsBudoAcc1) THEN LsBudoAcc1 = '00000'
	IF IsNull(LsBudoAcc2) THEN LsBudoAcc2 = '00'
END IF

/*전표 처리를 위한 dw*/
dw_kwan.SetTransObject(SQLCA)

dw_ins.SetTransObject(SQLCA)
dw_ins2.SetTransObject(SQLCA)
dw_rtv.SetTransObject(SQLCA)

dw_descr.SetTransObject(SQLCA)

Is_UpmuGbn = Str_Junpoy.UpmuGu
Ib_Amt_Chk = False

Wf_Insert_Init()

sModStatus = 'M'														/*수정*/

dw_rtv.Retrieve(Str_Junpoy.Saupjang,Str_Junpoy.AccDate,Str_Junpoy.UpmuGu,Str_Junpoy.JunNo)

IF dw_rtv.RowCount() <= 0 THEN
	Close(this)
ELSE 
	Is_JunGbn = dw_rtv.GetItemString(1,"jun_gu")
	
	Wf_Append_Init(dw_rtv.GetItemNumber(dw_rtv.RowCount(),"lin_no"),dw_rtv.RowCount())
END IF




end event

event closequery;w_mdi_frame.sle_msg.text = ''
end event

type dw_insert from w_inherite`dw_insert within w_kgld69c
integer x = 3945
integer y = 2812
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kgld69c
boolean visible = false
integer x = 3113
integer taborder = 0
end type

event p_delrow::clicked;call super::clicked;Integer ll_lclickedrow,iRowCount
String  sSaupj,sDate,sUpmu,ssaupno,sCurDate, sDeptcd
Long    lJunNo,lLinNo

sCurDate = F_TodaY()

ll_lClickedRow =dw_rtv.GetSelectedRow(0)

If ll_lClickedRow <= 0 then
   MessageBox("확 인", "삭제할 전표라인을 선택한 후 삭제를 누르십시오 ")
   Return
End if

sSaupj = dw_rtv.GetItemString(ll_lClickedRow,"saupj")
sDate  = dw_rtv.GetItemString(ll_lClickedRow,"bal_date")
sUpmu  = dw_rtv.GetItemString(ll_lClickedRow,"upmu_gu")
sDeptcd= dw_rtv.GetItemString(ll_lClickedRow,"dept_cd")
lJunNo = dw_rtv.GetItemNumber(ll_lClickedRow,"bjun_no")
lLinNo = dw_rtv.GetItemNumber(ll_lClickedRow,"lin_no")

IF F_DbConFirm('삭제') = 2 THEN Return

dw_ins.SetRedraw(False)
dw_ins2.SetRedraw(False)

dw_ins2.DeleteRow(0)
IF dw_ins2.Update() <> 1 THEN
	Rollback;
	
	dw_ins.SetRedraw(True)
	
	dw_ins2.SetRedraw(False)
	dw_ins2.Retrieve(sSaupj,sDate,sUpmu,lJunNo,lLinNo,dw_ins.GetItemString(1,"jun_gu"))
	dw_ins2.SetRedraw(True)
	
	Return
ELSE
	dw_rtv.SetRedraw(False)	
	dw_rtv.Retrieve(sSaupj,sDate,sUpmu,lJunNo,sDeptcd,dw_ins.GetItemString(1,"jun_gu"))
						 
	dw_rtv.ScrollToRow(dw_rtv.RowCount())
	dw_rtv.SetRedraw(True)
END IF

iRowCount = dw_rtv.RowCount()
IF iRowCount <= 0 THEN
	
	DELETE FROM "KFZ12OT1"  										/*전표품의내역 삭제*/
   WHERE ( "KFZ12OT1"."SAUPJ"    = :sSaupj  ) AND  
         ( "KFZ12OT1"."BAL_DATE" = :sDate ) AND  
         ( "KFZ12OT1"."UPMU_GU"  = :sUpmu ) AND  
         ( "KFZ12OT1"."JUN_NO"   = :lJunNo ) ;
	
	/*전표 이력 관리*/
	IF F_Control_Junpoy_History('D',	sSaupj,	sDate, sUpmu,  lJunNo,  sDate, '', '', 'B') = -1  THEN
		F_MessageChk(12,'[전표 이력]')
		Rollback;
		Return
	END IF
	
	COMMIT;
	
	Wf_Insert_Init()
ELSE 
	Wf_Append_Init(dw_rtv.GetItemNumber(iRowCount,"lin_no"),iRowCount)
END IF
dw_ins.SetRedraw(True)
dw_ins2.SetRedraw(True)

w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다!!'



end event

type p_addrow from w_inherite`p_addrow within w_kgld69c
boolean visible = false
integer x = 2939
integer taborder = 0
boolean focusrectangle = true
end type

event p_addrow::clicked;call super::clicked;Integer iRowCount,iRtnValue,iFunVal
String  sDcGbn
Double  dYesanRemain,dYesanAmt

IF dw_ins.AcceptText() = -1 THEN RETURN											/*입력1*/
IF dw_ins.GetRow() <=0 THEN Return
IF Wf_RequiredChk(dw_ins.DataObject,dw_ins.GetRow()) <=0 THEN RETURN 

IF dw_ins2.AcceptText() = -1 THEN Return											/*입력2*/
IF dw_ins2.GetRow() <=0 THEN Return
IF Wf_RequiredChk(dw_ins2.DataObject,dw_ins2.GetRow()) <=0 THEN RETURN

IF Wf_Check_Child(dw_ins2.GetRow()) = -1 THEN 									/*보조 처리 여부*/
	sDcGbn = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu")

	iRtnValue = Wf_Open_Window(sDcGbn)
	IF iRtnValue = 3 or iRtnValue = -1 THEN						/*보조등록 처리 안했으면*/
		Return
	END IF					
END IF

IF Wf_Open_Finance() = -1 THEN Return 								/*자금수지 상세 처리*/

dYesanRemain = 0

IF lstr_account.dcr_gu = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu") THEN
	iRtnValue = F_Get_YesanAmt(dw_ins.GetItemString(dw_ins.GetRow(),"saupj"),            &
										Left(dw_ins.GetItemString(dw_ins.GetRow(),"bal_date"),4), &
										Mid(dw_ins.GetItemString(dw_ins.GetRow(),"bal_date"),5,2),&
										dw_ins.GetItemString(dw_ins.GetRow(),"acc1_cd"),          &
										dw_ins.GetItemString(dw_ins.GetRow(),"acc2_cd"),          &
										dw_ins2.GetItemString(dw_ins2.GetRow(),"cdept_cd"),       &
										dw_ins2.GetItemString(dw_ins2.GetRow(),"old_acc1"),       &
										dw_ins2.GetItemString(dw_ins2.GetRow(),"old_acc2"),       &
										dw_ins2.GetItemString(dw_ins2.GetRow(),"old_cdept"),      &
										dw_ins2.GetItemNumber(dw_ins2.GetRow(),"amt"),            &
										dw_ins2.GetItemNumber(dw_ins2.GetRow(),"old_amt"),        &
										dYesanAmt,	dYesanRemain)
	IF iRtnValue <> 1 THEN
		IF iRtnValue = -2 THEN
			F_MessageChk(20014,'')
		ELSEIF iRtnValue = -1 THEN 
			F_MessageChk(53,'')
		ELSEIF iRtnValue = -3 THEN 	
			F_MessageChk(20013,'')
		END IF
		Return
	END IF
END IF

Wf_Move_Ins()																	/*dw_ins의 자료를 dw_ins2로 복사*/

iFunVal = dw_ins2.Update()

IF iFunVal <> 1 THEN
	RollBack;
	Return
ELSE
	dw_rtv.SetRedraw(False)	
	IF dw_rtv.Retrieve(dw_ins2.GetItemString(1,"saupj"),   &
						 dw_ins2.GetItemString(1,"bal_date"),&
						 Is_UpmuGbn,                         &
						 dw_ins2.GetItemNumber(1,"bjun_no"), &
						 dw_ins.GetItemString(1,"dept_cd"),  &
						 dw_ins.GetItemString(1,"jun_gu")) > 0 THEN
		if Is_JunGbn <> '3' then
			String   sCashAcc
			Integer  iFindRow
		
			select substr(dataname,1,7)	into :sCashAcc	from syscnfg where sysgu = 'A' and serial = 1 and lineno = '1';
				
			iFindRow = dw_rtv.Find("accode = '"+sCashAcc+"'",1,dw_rtv.RowCount())
				
			if iFindRow > 0 then
				dw_rtv.DeleteRow(iFindRow)	
				if dw_rtv.Update() <> 1 then
					F_MessageChk(12,'[현금]')
					Rollback;
					Return
				end if
				Commit;
			end if
		end if
	END IF
	
	dw_rtv.ScrollToRow(dw_rtv.RowCount())
	dw_rtv.SetRedraw(True)
END IF

iRowCount = dw_rtv.RowCount()
IF iRowCount <= 0 THEN
	Wf_Insert_Init()
ELSE 
	Wf_Append_Init(dw_rtv.GetItemNumber(iRowCount,"lin_no"),iRowCount)
END IF

w_mdi_frame.sle_msg.text = '자료를 저장하였습니다!!'


end event

type p_search from w_inherite`p_search within w_kgld69c
integer x = 3392
integer y = 2780
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kgld69c
integer x = 3566
integer y = 2780
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kgld69c
boolean visible = false
integer x = 2203
integer taborder = 0
end type

type p_can from w_inherite`p_can within w_kgld69c
boolean visible = false
integer x = 3461
integer taborder = 0
end type

event p_can::clicked;if Is_JUnGbn <> '3' AND sModStatus = 'M' then
	
	if dw_rtv.RowCount() > 0 then
		rollback;
			
		if dw_rtv.GetSelectedRow(0) > 0 then
			Wf_Append_Init(dw_rtv.GetItemNumber(dw_rtv.RowCount(),"lin_no"),dw_rtv.RowCount())
		end if
		Wf_Insert_Cash(Is_JUnGbn,'C')
			
		cb_ins2.TriggerEvent(Clicked!)
		commit;
	end if
else
	rollback;
end if

ib_any_typing = False

Close(Parent)
end event

type p_print from w_inherite`p_print within w_kgld69c
boolean visible = false
integer x = 2021
integer y = 16
integer taborder = 0
end type

event p_print::clicked;call super::clicked;String  sSaupj,sBalDate,sUpmuGu,sGet_ComNm,sGet_EmpNo,sJunGbn,sSungInGbn ='N'
Long    lJunNo

IF dw_rtv.RowCount() <=0 THEN
	F_MessageChk(14,'')
	Return
END IF

IF MessageBox("확 인","전표를 출력하시겠습니까?",Question!,YesNo!,2) =2 THEN RETURN

dw_ins.AcceptText()

sSaupj    = dw_rtv.GetItemString(1,"saupj")
sBalDate  = dw_rtv.GetItemString(1,"bal_date")
sUpmuGu   = dw_rtv.GetItemString(1,"upmu_gu")	
lJunNo    = dw_rtv.GetItemNumber(1,"bjun_no")
sJunGbn   = dw_rtv.GetItemString(1,"jun_gu")	

IF sAutoChk = 'Y' AND Ib_Amt_Chk = True THEN				/*자동승인 = 'Y' AND 대체전표*/
	sSungInGbn ='Y'
ELSE
	sSungInGbn ='N'
END IF

F_Setting_Dw_Junpoy(sSungInGbn,sJunGbn,dw_print)

IF F_Call_JunpoyPrint(dw_print,sSungInGbn,sJunGbn,sSaupj,sBalDate,sUpmuGu,lJunNo,'0','P') = -1 THEN
	F_MessageChk(14,'')
	Return
END IF


end event

type p_inq from w_inherite`p_inq within w_kgld69c
boolean visible = false
integer x = 1833
integer y = 20
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;String  sSaupj,sBalDate,sUpmuGu,sAlcGbn,sAlcDate,sDeptCode,sJunGbn
Long    lJunNo,lAlcNo
Integer iRowCount

IF dw_ins.AcceptText() <= -1 Then Return

sSaupj    = dw_ins.GetItemString(dw_ins.GetRow(),"saupj")
sBalDate  = dw_ins.GetItemString(dw_ins.GetRow(),"bal_date")
sUpmuGu   = dw_ins.GetItemString(dw_ins.GetRow(),"upmu_gu")	
lJunNo    = dw_ins.GetItemNumber(dw_ins.GetRow(),"bjun_no")

sJunGbn   = dw_ins.GetItemString(dw_ins.GetRow(),"jun_gu")
IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ins.SetColumn("saupj")
	dw_ins.SetFocus()
	Return 
END IF
IF sBalDate = "" OR IsNull(sBalDate) THEN
	F_MessageChk(1,'[작성일자]')
	dw_ins.SetColumn("bal_date")
	dw_ins.SetFocus()
	Return 
END IF
IF sUpmuGu = "" OR IsNull(sUpmuGu) THEN
	F_MessageChk(1,'[전표구분]')
	dw_ins.SetFocus()
	Return 
END IF
IF lJunNo = 0 OR IsNull(lJunNo) THEN
	F_MessageChk(1,'[전표번호]')
	dw_ins.SetColumn("bjun_no")
	dw_ins.SetFocus()
	Return 
END IF

sDeptCode = '%'

SELECT DISTINCT "KFZ12OT0"."ALC_GU",	"KFZ10OT0"."ACC_DATE",	"KFZ10OT0"."JUN_NO"
	INTO :sAlcGbn,								:sAlcDate,					:lAlcNo
	FROM "KFZ12OT0","KFZ10OT0"  
   WHERE ( "KFZ12OT0"."SAUPJ"    = "KFZ10OT0"."SAUPJ" (+)) AND
			( "KFZ12OT0"."BAL_DATE" = "KFZ10OT0"."BAL_DATE" (+)) AND
			( "KFZ12OT0"."UPMU_GU"  = "KFZ10OT0"."UPMU_GU" (+)) AND
			( "KFZ12OT0"."BJUN_NO"  = "KFZ10OT0"."BJUN_NO" (+)) AND
			( "KFZ12OT0"."LIN_NO"   = "KFZ10OT0"."LIN_NO" (+)) AND
			( "KFZ12OT0"."SAUPJ" = :sSaupj ) AND  ( "KFZ12OT0"."BAL_DATE" = :sBaldate ) AND  
         ( "KFZ12OT0"."UPMU_GU" = :sUpmugu ) AND ( "KFZ12OT0"."BJUN_NO" = :lJunno ) AND
			( "KFZ12OT0"."JUN_GU"  = :sJunGbn) AND ( "KFZ12OT0"."DEPT_CD" LIKE :sDeptCode) ;
CHOOSE CASE SQLCA.SQLCODE
	CASE 0
		IF sAlcGbn = 'Y' THEN
			MessageBox("확  인","회계전표번호 :"+String(sAlcDate,'@@@@.@@.@@') + '-'+String(lAlcNo,'0000')+"~r~n"+&
									  "이미 승인처리 되었으므로 수정,삭제 할 수 없습니다.")
			
			dw_ins.SetColumn("bjun_no")
			dw_ins.SetFocus()
			
			Ib_AlcFlag = True
		ELSE
			Ib_AlcFlag = False
		END IF
	CASE 100
		F_MessageChk(14,'')
		
		dw_ins.SetColumn("bjun_no")
		dw_ins.SetFocus()
		Return 		
	CASE -1
		MessageBox("확  인","전표 조회 중 에러가 발생하였습니다"+ SQLCA.SQLERRTEXT)
		
		dw_ins.SetColumn("bjun_no")
		dw_ins.SetFocus()
		Return 		
END CHOOSE

dw_rtv.SetRedraw(False)
iRowCount = dw_rtv.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo,sDeptCode,sJunGbn)
dw_rtv.SetRedraw(True)

IF iRowCount <=0 THEN
	Wf_Insert_Init()	
ELSE
	Is_JunGbn = dw_rtv.GetItemString(1,"jun_gu")
	
	Wf_Append_Init(dw_rtv.GetItemNumber(iRowCount,"lin_no"),iRowCount)
	
	if Is_JunGbn <> '3' then
		String   sCashAcc
		Integer  iFindRow
	
		select substr(dataname,1,7)	into :sCashAcc	from syscnfg where sysgu = 'A' and serial = 1 and lineno = '1';
			
		iFindRow = dw_rtv.Find("accode = '"+sCashAcc+"'",1,dw_rtv.RowCount())
			
		if iFindRow > 0 then
			dw_rtv.DeleteRow(0)	
			if dw_rtv.Update() <> 1 then
				F_MessageChk(12,'[현금]')
				Rollback;
				Return
			end if
			Commit;
		end if
	end if
	
	p_addrow.Enabled = True
	p_delrow.Enabled = True
	
	ib_any_Typing = True
	
	if Is_JunGbn <> '3' then
		p_print.Enabled = False
	else
		p_print.Enabled = True
	end if
	
END IF
	

end event

type p_del from w_inherite`p_del within w_kgld69c
integer x = 3744
integer y = 2780
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kgld69c
boolean visible = false
integer x = 3287
integer taborder = 0
end type

event p_mod::clicked;Double   dCha, dDae
Integer  iRowCount,k

iRowCount = dw_rtv.RowCount()
IF iRowCount <= 0 then
   MessageBox("확 인", "전표를 입력하신후 완료를 누르십시오 !")
   return
END IF

if Is_JUnGbn <> '3' then
	IF dw_rtv.GetSelectedRow(0) > 0 THEN
		Wf_Append_Init(dw_rtv.GetItemNumber(iRowCount,"lin_no"),iRowCount)	
	END IF
	Wf_Insert_Cash(Is_JUnGbn,'O')
		
	cb_ins2.TriggerEvent(Clicked!)
	
	if sModStatus = 'M' then
		FOR k = 1 TO dw_rtv.RowCount()
			dw_rtv.SetItem(k,"lin_no", k)
		NEXT
		if dw_rtv.Update() <> 1 then
			F_MessageChk(13,'')
			Rollback;
			Return
		end if
	end if
else
	dCha = dw_rtv.GetItemNumber(iRowCount, "sum_cha")
	dDae = dw_rtv.GetItemNumber(iRowCount, "sum_dae")
	
	IF dCha <> dDae THEN 
		F_MessageChk(45,'')
		return
	END IF
END IF

//IF F_Control_Junpoy_History(sModStatus,								 &
//									 dw_rtv.GetItemString(1,"saupj"),    &
//									 dw_rtv.GetItemString(1,"bal_date"), &
//									 dw_rtv.GetItemString(1,"upmu_gu"),  &
//									 dw_rtv.GetItemNumber(1,"bjun_no"),  &
//									 dw_rtv.GetItemString(1,"bal_date"), &
//									 dw_rtv.GetItemString(1,"dept_cd"),  &
//									 dw_rtv.GetItemString(1,"sawon"),   'B') = -1  THEN
//	F_MessageChk(13,'[전표 이력]')
//	Rollback;
//	Return
//END IF
Commit;

Close(Parent)



end event

type cb_exit from w_inherite`cb_exit within w_kgld69c
integer x = 3803
integer y = 3100
end type

type cb_mod from w_inherite`cb_mod within w_kgld69c
integer x = 2747
integer y = 3100
string text = "완료(&F)"
end type

type cb_ins from w_inherite`cb_ins within w_kgld69c
integer x = 1906
integer y = 3100
integer width = 379
string text = "줄저장(&A)"
end type

type cb_del from w_inherite`cb_del within w_kgld69c
integer x = 2299
integer y = 3100
integer width = 379
string text = "줄삭제(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_kgld69c
integer x = 1513
integer y = 3100
end type

type cb_print from w_inherite`cb_print within w_kgld69c
integer x = 3099
integer y = 3100
end type

type st_1 from w_inherite`st_1 within w_kgld69c
end type

type cb_can from w_inherite`cb_can within w_kgld69c
integer x = 3451
integer y = 3100
end type

type cb_search from w_inherite`cb_search within w_kgld69c
integer x = 1339
integer y = 2804
end type





type gb_10 from w_inherite`gb_10 within w_kgld69c
integer height = 156
end type

type gb_button1 from w_inherite`gb_button1 within w_kgld69c
integer x = 613
integer y = 3056
integer width = 1257
integer height = 168
end type

type gb_button2 from w_inherite`gb_button2 within w_kgld69c
integer x = 2720
integer y = 3056
integer width = 1445
integer height = 168
end type

type cb_2 from commandbutton within w_kgld69c
integer x = 1079
integer y = 3100
integer width = 425
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "전표조회(&Q)"
end type

type cb_yesan from commandbutton within w_kgld69c
integer x = 640
integer y = 3100
integer width = 425
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "예산조회(Y)"
end type

type dw_rtv from datawindow within w_kgld69c
event ue_key pbm_dwnkey
integer x = 46
integer y = 972
integer width = 4535
integer height = 1340
boolean bringtotop = true
string dataobject = "dw_kgld69c3"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;String  sDcGbn
Integer iRtnValue

dw_ins.AcceptText()
IF KeyDown(KeyPageDown!) THEN				/*KEY VALUE : */
	sDcGbn = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu")
		
	iRtnValue = Wf_Open_Window(sDcGbn)
	IF iRtnValue = 3 OR iRtnValue = -1 THEN	/*보조등록 처리 안했으면,에러*/
		this.SetColumn("cdept_cd")
		this.SetFocus()
		Return 1
	END IF
END IF
end event

event clicked;String  sSaupj,sBalDate,sUpmuGu,sAlcGbn
Long    lJunNo,lLinNo

IF Row <=0 THEN Return

this.SelectRow(0,False)
this.SelectRow(row,True)

dw_rtv.AcceptText()

sSaupj    = dw_rtv.GetItemString(Row,"saupj")
sBalDate  = dw_rtv.GetItemString(Row,"bal_date")
sUpmuGu   = dw_rtv.GetItemString(Row,"upmu_gu")	
lJunNo    = dw_rtv.GetItemNumber(Row,"bjun_no")
lLinNo    = dw_rtv.GetItemNumber(Row,"lin_no")

Ls_SangGbn = dw_rtv.GetItemString(Row,"cross_gu")				/*이전자료 상계 여부*/
Ls_SangCust= dw_rtv.GetItemString(Row,"saup_no")				/*이전자료 상계 거래처*/

dw_ins.SetRedraw(False)
dw_ins2.SetRedraw(False)

IF dw_ins.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo,lLinNo,dw_rtv.GetItemString(Row,"jun_gu")) <=0 then Return
dw_ins2.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo,lLinNo,dw_rtv.GetItemString(Row,"jun_gu"))

dw_ins.SetItem(1,"sflag",'M')

dw_ins.SetRedraw(True)

IF dw_rtv.GetItemString(Row,"jun_gu") = '1' THEN			/*대체전표*/
	Ib_Amt_Chk = True
ELSE
	Ib_Amt_Chk = False
END IF
Wf_Get_Account(dw_ins.GetItemString(1,"acc1_cd"),dw_ins.GetItemString(1,"acc2_cd"),&
					dw_ins.GetItemString(1,"dcr_gu"))

Wf_Setting_RefLst(dw_ins.GetItemString(1,"acc1_cd"),dw_ins.GetItemString(1,"acc2_cd"),&
					dw_ins.GetItemString(1,"dcr_gu"))

dw_ins2.SetRedraw(True)

dw_ins.SetColumn("dcr_gu")
dw_ins.SetFocus()
dw_ins.Modify("lin_no.protect = 1")
//dw_ins.Modify("lin_no.background.color ='"+String(RGB(192,192,192))+"'")

//Wf_Append_Init(dw_rtv.GetItemNumber(dw_rtv.RowCount(),"lin_no"),dw_rtv.RowCount())

	

end event

type dw_kwan from datawindow within w_kgld69c
boolean visible = false
integer x = 101
integer y = 2412
integer width = 1189
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "계정별 관리항목 조회"
string dataobject = "dw_kglb01_3"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_ins2 from u_key_enter within w_kgld69c
event ue_key pbm_dwnkey
integer x = 32
integer y = 544
integer width = 4585
integer height = 420
integer taborder = 0
string dataobject = "dw_kgld69c2"
boolean border = false
end type

event ue_key;String  sDcGbn,sSaupj,sBalDate
Integer iRtnValue

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF KeyDown(KeyPageDown!) OR KeyDown(KeyTab!) THEN				/*KEY VALUE : */
	IF this.GetColumnName() = "cr_cd" AND Ib_AlcFlag = False THEN
		sDcGbn = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu")
		
		iRtnValue = Wf_Open_Window(sDcGbn)
		IF iRtnValue = 3 OR iRtnValue = -1 THEN	/*보조등록 처리 안했으면,에러*/
			this.SetColumn("sdept_cd")
			this.SetFocus()
			Return 1
		END IF
	END IF
ELSEIF KeyDown(KeyF3!) THEN
	sSaupj   = dw_ins.GetItemString(dw_ins.GetRow(),"saupj")
	sBalDate = dw_ins.GetItemString(dw_ins.GetRow(),"bal_date")
	
	IF Ib_ClickedFlag = True THEN RETURN
	
	IF Wf_JunPoy(sSaupj,sBalDate) <= 0 THEN Return 1
	
	Wf_Button_Sts()
	
END IF
end event

event editchanged;
String  sVatGbn,sOldVatGbn
Integer iCurRow 

ib_any_typing = True
p_print.Enabled = False

iCurRow = this.GetRow()

sOldVatGbn = this.GetItemString(iCurRow,"vat_gu")

IF this.GetColumnName() = "vat_gu" THEN
	sVatGbn = this.GetText()
	IF sVatGbn = "" OR IsNull(sVatGbn) THEN Return
	
	IF sVatGbn = 'Y' THEN
		IF Wf_Open_Vat() = -1 THEN
			this.SetItem(iCurRow,"vat_gu",'N')
			Return 1
		END IF
	ELSE
		IF dw_ins.GetItemString(dw_ins.GetRow(),"sflag") = 'M' AND sOldVatGbn = 'Y' THEN
			this.SetItem(iCurRow,"vat_gu",'Y')
			IF Wf_Open_Vat() = -1 THEN
				this.SetItem(iCurRow,"vat_gu",'N')
				Return 1
			END IF
			this.SetItem(iCurRow,"vat_gu",'Y')
			Return 1
		END IF
	END IF
END IF
end event

event itemchanged;String  sCustCode,sCustName,sInCode,sInName,sGyulDate,sGyulMethod,sCdeptCode,sBillGbn,sCurr,sChangeMod,&
		  sKwanNo,sPjtNo,sItmGu,sPersonName,sSYmd,sEYmd,sCardCode,sSdeptCode,sVatGbn,sOldVatGbn,sNull,&
		  sOldCdept,sSendBank,sSendDepot,sSendName,sItnbr,sItcls
Integer iCurRow,iRtnValue
Double  dAmt,dOldAmt,dYesanAmt = 0,dYesanRemain = 0

SetNull(snull)

iCurRow = this.GetRow()

sOldVatGbn = this.GetItemString(iCurRow,"vat_gu")
dOldAmt    = this.GetItemNumber(iCurRow,"amt")
sOldCdept  = this.GetItemString(iCurRow,"cdept_cd")

this.AcceptText()
IF this.GetColumnName() = "saup_no" THEN
	sCustCode = this.GetText()
	IF sCustCode = "" OR IsNull(sCustCode) THEN 
		this.SetItem(iCurRow,"in_nm",snull)
		Return
	END IF
	
	IF Wf_Check_Cust(sCustCode,dw_ins.GetItemString(1,"dcr_gu"),sCustName) = -1 THEN 
		this.SetItem(iCurRow,"saup_no",snull)
		this.SetItem(iCurRow,"in_nm",snull)
		RETURN 1
	ELSE
		this.SetItem(iCurRow,"in_nm",Left(sCustName,50))
		
		Wf_Change_Data_Clear(this.GetColumnName(),iCurRow)		/*전표 보조 관련자료 변경 시 관련항목 clear*/
	END IF
END IF

IF this.GetColumnName() = "in_nm" THEN
	sCustName = this.GetText()
	IF sCustName = "" OR IsNull(sCustName) THEN 
		this.SetItem(iCurRow,"saup_no",snull)
		Return
	END IF
	
	IF lstr_account.cus_gu = 'Y' THEN
		SELECT "KFZ04OM0"."PERSON_CD"  INTO :sCustCode  
			FROM "KFZ04OM0"  
			WHERE "KFZ04OM0"."PERSON_GU" LIKE :lstr_account.gbn1 AND

					"KFZ04OM0"."PERSON_NM" = :sCustName and "KFZ04OM0"."PERSON_STS" = '1' ;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(iCurRow,"saup_no",sCustCode)
			
					
			Wf_Change_Data_Clear(this.GetColumnName(),iCurRow)		/*전표 보조 관련자료 변경 시 관련항목 clear*/
		ELSE
			F_MessageChk(20,'[거래처]')
			this.SetItem(iCurRow,"saup_no",snull)
			this.SetItem(iCurRow,"in_nm",  snull)
			
			this.SetItem(iCurRow,"send_bank",sNull)
			this.SetItem(iCurRow,"send_dep", sNull)
			this.SetItem(iCurRow,"send_nm",  sNull)
	
			Return 1
		END IF
	END IF
END IF

IF this.GetcolumnName() = "amt" THEN
	dAmt = Double(this.GetText())
	IF IsNull(dAmt) THEN Return
	
	Wf_Change_Data_Clear(this.GetColumnName(),iCurRow)		/*전표 보조 관련자료 변경 시 관련항목 clear*/		
END IF

IF this.GetcolumnName() = "vatamt" THEN
	dAmt = Double(this.GetText())
	IF IsNull(dAmt) THEN Return
	
	Wf_Change_Data_Clear(this.GetColumnName(),iCurRow)		/*전표 보조 관련자료 변경 시 관련항목 clear*/	
END IF

IF this.GetColumnName() = "vat_gu" THEN
	sVatGbn = this.GetText()
	IF sVatGbn = "" OR IsNull(sVatGbn) THEN Return
	
	IF sVatGbn = 'Y' THEN
		IF Wf_Open_Vat() = -1 THEN
			this.SetItem(iCurRow,"vat_gu",'N')
			Return 1
		END IF
	ELSE
		IF sOldVatGbn = 'Y' THEN
//		IF dw_ins.GetItemString(dw_ins.GetRow(),"sflag") = 'M' AND sOldVatGbn = 'Y' THEN
			this.SetItem(iCurRow,"vat_gu",'Y')
			IF Wf_Open_Vat() = -1 THEN
				this.SetItem(iCurRow,"vat_gu",'N')
				Return 1
			END IF
			this.SetItem(iCurRow,"vat_gu",'Y')
			Return 1
		END IF
	END IF
END IF

IF this.GetColumnName() = "sdept_cd" THEN
	sSdeptCode = this.GetText()	
	IF sSdeptCode = "" OR IsNull(sSdeptCode) THEN RETURN
	
	IF Wf_Check_Sdept(lstr_account.acc1_cd, lstr_account.acc2_cd,sSdeptCode) = -1 THEN
		F_MessageChk(20,'[원가부문]')
		this.SetItem(iCurRow,"sdept_cd",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = 'cr_cd' THEN
	sCardCode = this.GetText()
	IF sCardCode = "" OR IsNull(sCardCode) THEN Return
	
	SELECT "KFZ05OM0"."CARD_NO"  	INTO :sCardCode  
	   FROM "KFZ05OM0"  
   	WHERE "KFZ05OM0"."CARD_NO" = :sCardCode   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[카드번호]')
		this.SetItem(iCurRow,"cr_cd",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "gyul_date" THEN
	sGyulDate = Trim(this.GetText())
	IF sGyulDate = "" OR IsNull(sGyulDate) THEN Return
	
	IF F_DateChk(sGyulDate) = -1 THEN
		F_MessageChk(21,'[자금요청일]')
		this.SetItem(iCurRow,"gyul_date",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "gyul_method" THEN
	sGyulMethod = Trim(this.GetText())
	IF sGyulMethod = "" OR IsNull(sGyulMethod) THEN Return
	
	IF IsNull(F_Get_Refferance('PM',sGyulMethod)) THEN
		F_MessageChk(20,'[지급방식]')
		this.SetItem(iCurRow,"gyul_method",snull)
		Return 1
	ELSE
		sCustCode = this.GetItemString(iCurRow,"saup_no")
		
		IF sGyulMethod = '4' THEN			/*지급방법 = 송금*/
			SELECT "VNDMST"."CVBANK",   "VNDMST"."CVDPNO",   "VNDMST"."DPNAME"  
				INTO :sSendBank,   :sSendDepot,        :sSendName  
			   FROM "VNDMST"  
			   WHERE "VNDMST"."CVCOD" = :sCustCode;
			
			this.SetItem(iCurRow,"send_bank",sSendBank)
			this.SetItem(iCurRow,"send_dep", sSendDepot)
			this.SetItem(iCurRow,"send_nm",  sSendName)
		ELSE
			this.SetItem(iCurRow,"send_bank",sNull)
			this.SetItem(iCurRow,"send_dep", sNull)
			this.SetItem(iCurRow,"send_nm",  sNull)
		END IF
	END IF
END IF

IF this.GetColumnName() = "cdept_cd" THEN
	sCdeptCode = this.GetText()	
	IF sCdeptCode = "" OR IsNull(sCdeptCode) THEN RETURN
	
	SELECT DISTINCT "KFE01OM0"."DEPT_CD"  	INTO :sCdeptCode  
	   FROM "KFE01OM0"  
   	WHERE "KFE01OM0"."DEPT_CD" = :sCdeptCode   ;

	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[예산부서]')
		this.SetItem(iCurRow,"cdept_cd",snull)
		Return 1
	END IF	
END IF

IF this.GetColumnName() = "kwan_no" THEN
	sKwanNo = this.GetText()
	IF sKwanNo = "" OR IsNull(sKwanNo) THEN RETURN
	
	IF Wf_Check_KwanNo(sKwanNo,this.GetColumnName()) = -1 THEN
		this.SetItem(iCurRow,"kwan_no",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "pjt_no" THEN
	sPjtNo = this.GetText()
	IF sPjtNo = "" OR IsNull(sPjtNo) THEN 
		this.SetItem(iCurRow,"itm_gu",snull)
		RETURN
	END IF
	
	IF Wf_Check_KwanNo(sPjtNo,this.GetColumnName()) = -1 THEN
		this.SetItem(iCurRow,"pjt_no",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "itm_gu" THEN
	sItmGu = this.GetText()
	IF sItmGu = "" OR IsNull(sItmGu) THEN RETURN
	
	IF Wf_Check_KwanNo(sItmGu,this.GetColumnName()) = -1 THEN
		this.SetItem(iCurRow,"itm_gu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "exp_gu" THEN
	sBillGbn = this.GetText()
	IF sBillGbn = "" OR IsNull(sBillGbn) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AS',sBillGbn)) THEN
		F_MessageChk(20,'[상태구분]')
		this.SetItem(iCurRow,"exp_gu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "y_curr" THEN
	sCurr = this.GetText()
	IF sCurr = "" OR IsNull(sCurr) THEN RETURN
	
	IF IsNull(F_Get_Refferance('10',sCurr)) THEN
		F_MessageChk(20,'[통화]')
		this.SetItem(iCurRow,"y_curr",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "k_symd" THEN
	sSYmd = Trim(this.GetText())
	IF sSYmd = "" OR IsNull(sSYmd) THEN Return
	
	IF F_DateChk(sSYmd) = -1 THEN
		F_MessageChk(21,This.Describe(This.GetColumnName()	+ "_t.text"))
		this.SetItem(iCurRow,"k_symd",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "k_eymd" THEN
	sEYmd = Trim(this.GetText())
	IF sEYmd = "" OR IsNull(sEYmd) THEN Return
	
	IF F_DateChk(sEYmd) = -1 THEN
		F_MessageChk(21,This.Describe(This.GetColumnName()	+ "_t.text"))
		this.SetItem(iCurRow,"k_eymd",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "kwan_no2" THEN
	sItnbr = this.GetText()
	IF sItnbr = "" OR IsNull(sItnbr) THEN Return
	
	SELECT "ITEMAS"."ITNBR"      INTO :sItnbr  
	   FROM "ITEMAS"  
   	WHERE ( "ITEMAS"."ITNBR" = :sItnbr ) AND ( "ITEMAS"."GBWAN" = 'Y' )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[품목번호]')
		this.SetItem(iCurRow,"kwan_no2",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "kwan_no3" THEN
	sItcls = this.GetText()
	IF sItcls = "" OR IsNull(sItcls) THEN Return
	
	SELECT distinct "ITNCT"."ITCLS"      INTO :sItcls  
	   FROM "ITNCT"  
   	WHERE "ITNCT"."ITCLS" = :sItcls;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[품목문류]')
		this.SetItem(iCurRow,"kwan_no3",snull)
		Return 1
	END IF
END IF

ib_any_typing = True
end event

event rbuttondown;String sKwanChkGbn,sDcGbn,sColumnName,sRefGbn,snull

SetNull(snull)

SetNull(gs_code)
SetNull(gs_codename)

w_mdi_frame.sle_msg.text =""

this.AcceptText()
IF this.GetColumnName() ="saup_no" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = Trim(Left(this.GetItemString(this.GetRow(),"saup_no"),1))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	IF IsNull(lstr_custom.name) THEN
		lstr_custom.name = ""
	END IF
	
	OpenWithParm(W_KFZ04OM0_POPUP,lstr_account.Gbn1)
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"saup_no",lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() = "kwan_no" THEN			/*관리번호*/
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	sColumnName = this.GetColumnName()
	
	IF lstr_account.acc1_cd = LsBudoAcc1 AND lstr_account.acc2_cd = LsBudoAcc2 THEN				/*부도어음*/
		SetNull(Gs_Code)
		
		Gs_code = this.GetItemString(this.GetRow(),"saup_no")
		
		OpenWithParm(W_Kfm02ot0_PopUp,'')
		IF Gs_code = "" OR IsNull(Gs_code) THEN Return
		this.SetItem(this.GetRow(),"kwan_no",Gs_code)
	ELSE
		dw_ins.AcceptText()
		sDcGbn = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu")
		
		SELECT "KFZ01OT0"."REF_GBN"  	INTO :sRefGbn  
			FROM "KFZ01OT0"  
			WHERE ( "KFZ01OT0"."ACC1_CD" = :lstr_account.acc1_cd ) AND
					( "KFZ01OT0"."ACC2_CD" = :lstr_account.acc2_cd ) AND  
					( "KFZ01OT0"."DC_GU"   = :sDcGbn ) AND 
					( "KFZ01OT0"."KWAN_COLID" = :sColumnName )   ;
		IF sRefGbn = "" OR IsNull(sRefGbn) THEN Return
		
		IF sRefGbn = '8' THEN											/*품목번호*/
			SetNull(Gs_Code)
			SetNull(Gs_CodeName)
		
			Open(w_itemas_popup)
			
			IF Gs_Code = "" OR IsNull(Gs_Code) THEN Return
			
			this.SetItem(this.GetRow(),"kwan_no2",Gs_Code)
			this.TriggerEvent(ItemChanged!)
		ELSEIF sRefGbn = 'C' THEN										/*품목분류*/
			SetNull(Gs_Code)
			SetNull(Gs_CodeName)
		
			Open(w_itnct_popup)
			
			IF Gs_Code = "" OR IsNull(Gs_Code) THEN Return
			
			this.SetItem(this.GetRow(),"kwan_no3",Gs_Code)
			this.TriggerEvent(ItemChanged!)
		ELSE
			lstr_custom.code = Trim(Left(this.GetItemString(this.GetRow(),"kwan_no"),1))
			
			IF IsNull(lstr_custom.code) THEN
				lstr_custom.code = ""
			END IF
			
			OpenWithParm(W_KFZ04OM0_POPUP,sRefGbn)
			
			IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
			this.SetItem(this.GetRow(),"kwan_no",lstr_custom.code)
		END IF
	END IF
	
	this.TriggerEvent(ItemChanged!)
	
END IF

IF this.GetColumnName() ="pjt_no" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"pjt_no"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	OpenWithParm(W_KFZ04OM0_POPUP,'90')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"pjt_no",lstr_custom.code)
	this.SetItem(this.GetRow(),"itm_gu",snull)
END IF

IF this.GetColumnName() ="cr_cd" THEN
	SetNull(Gs_Code)
	SetNull(Gs_CodeName)

	Gs_Code = Trim(this.GetItemString(this.GetRow(),"cr_cd"))
	
	IF IsNull(Gs_Code) THEN Gs_Code = ""

	Open(W_KFZ05OM0_POPUP)
	
	IF Gs_Code = "" OR IsNull(Gs_Code) THEN Return
	
	this.SetItem(this.GetRow(),"cr_cd",Gs_Code)
END IF

IF this.GetColumnName() ="kwan_no2" THEN
	SetNull(Gs_Code)
	SetNull(Gs_CodeName)

	Open(w_itemas_popup)
	
	IF Gs_Code = "" OR IsNull(Gs_Code) THEN Return
	
	this.SetItem(this.GetRow(),"kwan_no2",Gs_Code)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="kwan_no3" THEN
	SetNull(Gs_Code)
	SetNull(Gs_CodeName)

	Open(w_itnct_popup)
	
	IF Gs_Code = "" OR IsNull(Gs_Code) THEN Return
	
	this.SetItem(this.GetRow(),"kwan_no3",Gs_Code)
	this.TriggerEvent(ItemChanged!)
END IF

//IF this.GetColumnName() ="itm_gu" THEN
//	SetNull(lstr_custom.code)
//	SetNull(lstr_custom.name)
//
//	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"pjt_no"))
//	
//	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN
//		F_MessageChk(1,'[프로젝트]')
//		dw_ins2.SetColumn("pjt_no")
//		dw_ins2.SetFocus()
//		Return 1
//	END IF
//
//	OpenWithParm(W_KFZ04OM0_ITM_POPUP,'91')
//	
//	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
//	
//	this.SetItem(this.GetRow(),"itm_gu",lstr_custom.code)
//END IF

ib_any_typing = True
end event

event itemerror;
Return 1
end event

event getfocus;this.AcceptText()

end event

event itemfocuschanged;
IF this.GetColumnName() = 'descr' OR this.GetColumnName() = 'cvname' or &
	this.GetColumnName() = 'in_nm' OR this.GetColumnName() = 'send_bank' OR &
	this.GetColumnName() = 'send_nm' OR this.GetColumnName() = "sdept_cd" OR &
	this.GetColumnName() = 'gyul_method' AND this.GetColumnName() = "itm_gu" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event ue_pressenter;String    sDcGbn,sProcGbn
Integer   iRtnValue

dw_ins.AcceptText()
IF this.GetColumnName() = 'cr_cd' and Ib_AlcFlag = False THEN
	sDcGbn = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu")

	iRtnValue = Wf_Open_Window(sDcGbn)
	IF iRtnValue = 3 THEN						/*보조등록 처리 안했으면*/
		Return
	ELSEIF iRtnValue = -1 THEN
		Return 
	ELSEIF iRtnValue = 2 THEN
	ELSE
		p_addrow.TriggerEvent(Clicked!)
	END IF
	Send(Handle(this),256,9,0)
ELSE
	Send(Handle(this),256,9,0)
END IF

Return 1
end event

event buttonclicked;
String   sMsgParm

dw_ins.AcceptText()

IF dwo.name = 'dcb_sdeptdetail' AND Is_SysCnfg_WonGaFlag = 'Y' THEN		/*원가부서 버튼 클릭시*/
	lstr_jpra.saupjang = dw_ins.GetItemString(row,"saupj")
	lstr_jpra.BalDate  = dw_ins.GetItemString(row,"bal_date") 
	lstr_jpra.UpmuGu   = Is_UpmuGbn
	lstr_jpra.bJunNo   = dw_ins.GetItemNumber(row,"bjun_no") 
	lstr_jpra.sortno   = dw_ins.GetItemNumber(row,"lin_no") 
	
	lstr_jpra.money    = this.GetItemNumber(this.GetRow(),"amt") 
	
	IF IsNull(lstr_jpra.bJunNo) OR lstr_jpra.bJunNo = 0 THEN
		f_MessageChk(3,'')
		Return 
	END IF
	
	OpenWithParm(W_kglb016,this.GetItemString(this.GetRow(),"sdept_cd"))
	
	sMsgParm = Message.StringParm
	
	IF Left(sMsgParm,1) = '1' THEN											/*원가 변경 YES*/
		ib_any_typing = True
		this.SetItem(this.GetRow(),"sdept_cd",Mid(sMsgParm,2,6))
	END IF		
END IF	

//IF dwo.name = 'dcb_cdeptdetail' AND Is_SysCnfg_YesanFlag = 'Y' THEN		/*예산부서 버튼 클릭시*/
//	lstr_jpra.saupjang = dw_ins.GetItemString(row,"saupj")
//	lstr_jpra.BalDate  = dw_ins.GetItemString(row,"bal_date") 
//	lstr_jpra.UpmuGu   = Is_UpmuGbn
//	lstr_jpra.bJunNo   = dw_ins.GetItemNumber(row,"bjun_no") 
//	lstr_jpra.sortno   = dw_ins.GetItemNumber(row,"lin_no") 
//	
//	lstr_jpra.money    = this.GetItemNumber(this.GetRow(),"amt") 
//	
//	IF IsNull(lstr_jpra.bJunNo) OR lstr_jpra.bJunNo = 0 THEN
//		f_MessageChk(3,'')
//		Return 
//	END IF
//	
//	OpenWithParm(W_kglb015,this.GetItemString(this.GetRow(),"cdept_cd"))
//	
//	sMsgParm = Message.StringParm
//	
//	IF Left(sMsgParm,1) = '1' THEN											/*예산변경 YES*/
//		ib_any_typing = True
//		this.SetItem(this.GetRow(),"cdept_cd",Mid(sMsgParm,2,6))
//	END IF		
//END IF	




end event

event dberror;
//lDbErrCode = sqldbcode
//
//String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
//Integer iPos, iCount
//
//iCount			= 0
//sNewline			= '~r'
//sReturn			= '~n'
//sErrorcode 		= Left(sqlerrtext, 9)
//iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
//sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))
//
//str_db_error db_error_msg
//db_error_msg.rowno 	 				= row
//db_error_msg.errorcode 				= sErrorCode
//db_error_msg.errorsyntax_system	= sErrorSyntax
//db_error_msg.errorsyntax_user		= sErrorSyntax
//db_error_msg.errorsqlsyntax			= sqlsyntax
//
//OpenWithParm(w_error, db_error_msg)
//
//RETURN 1

end event

type dw_ins from u_key_enter within w_kgld69c
event ue_key pbm_dwnkey
integer x = 32
integer y = 176
integer width = 4585
integer height = 360
integer taborder = 0
string dataobject = "dw_kgld69c1"
boolean border = false
end type

event ue_key;String  sSaupj,sBalDate,sDcGbn
Integer iRtnValue

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF KeyDown(KeyPageDown!) THEN				/*KEY VALUE : */
	sDcGbn = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu")
		
	iRtnValue = Wf_Open_Window(sDcGbn)
	IF iRtnValue = 3 OR iRtnValue = -1 THEN	/*보조등록 처리 안했으면,에러*/
		this.SetColumn("cdept_cd")
		this.SetFocus()
		Return 1
	END IF
ELSEIF KeyDown(KeyF3!) THEN
	this.AcceptText()
	sSaupj   = this.GetItemString(this.GetRow(),"saupj")
	sBalDate = this.GetItemString(this.GetRow(),"bal_date")
	
	IF Ib_ClickedFlag = True THEN RETURN
	
	IF Wf_JunPoy(sSaupj,sBalDate) <= 0 THEN Return 1
	
	Wf_Button_Sts()
END IF
end event

event editchanged;
ib_any_typing = True
p_print.Enabled = False
end event

event itemchanged;String  sSaupj,  sBalDate,sDeptCode,sDeptName,sJpGbn,sEmpNo,sEmpName,sDcGbn,sAcc1_Cd,&
		  sAcc2_Cd,sRmCode, sRmName, sStatusText, sNull
Integer iCurRow,iRtnValue
Long    lJunNo
Double  dYesanAmt,dYesanRemain

SetNull(snull)

iCurRow = this.GetRow()

this.AcceptText()

IF this.GetColumnName() = "jun_gu" THEN
	Is_JunGbn = this.GetText()
	IF Is_JunGbn = "" OR IsNull(Is_JunGbn) THEN RETURN
	
	if Is_JunGbn = '3' then									/*대체전표*/
		dw_ins.Modify("dcr_gu.protect = 0")		
		
		sStatusText = '대체 전표'
	else
		dw_ins.Modify("dcr_gu.protect = 1")
		
		if Is_JunGbn = '1' then
			dw_ins.SetItem(1,"dcr_gu", '2')
			sStatusText = '입금 전표'
		else
			dw_ins.SetItem(1,"dcr_gu", '1')
			sStatusText = '출금 전표'
		end if
	end if
	
	parent.Title = '전표 등록 [전표구분 : '+F_Get_Refferance('AG',Is_UpmuGbn)+' : '+sStatusText+']'
	w_mdi_frame.sle_msg.text ="전표번호 채번은 전표번호를 클릭하거나 FUNCTION KEY(F3)을 사용하세요!!"
END IF

IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN RETURN
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(iCurRow,"saupj",sNull)
		Return 1
	ELSE
		IF sSaupj = '9' THEN
			F_MessageChk(15,'')
			this.SetItem(iCurRow,"saupj",sNull)
			Return 1
		END IF
	END IF
END IF

IF this.GetColumnName() = "bal_date" THEN
	sBalDate = Trim(this.GetText())
	IF sBalDate = "" OR IsNull(sBalDate) THEN RETURN
	
	IF F_DateChk(sBalDate) = -1 THEN
		F_MessageChk(21,'[발행일자]')
		this.SetItem(iCurRow,"bal_date",snull)
		Return 1
	ELSE
		IF Wf_Chk_StandardDate(sBalDate) = -1 THEN							/*회계기준일 체크*/
			F_MessageChk(29,'[발행일자]')
			this.SetItem(iCurRow,"bal_date",snull)
			Return 1
		END IF
	END IF
END IF

IF this.GetColumnName() = "dept_cd" THEN
	sDeptCode = this.GetText()
	IF sDeptCode = "" OR IsNull(sDeptCode) THEN
		this.SetItem(iCurRow,"deptname",snull)
		Return
	END IF
	
	sDeptName = F_Get_PersonLst('3',sDeptCode,'1')
	IF IsNull(sDeptName) THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(iCurRow,"dept_cd",snull)
		this.SetItem(iCurRow,"deptname",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"deptname",sDeptName)
	END IF
END IF

IF this.GetColumnName() = "deptname" THEN
	sDeptName = this.GetText()
	IF sDeptName = "" OR IsNull(sDeptName) THEN
		this.SetItem(iCurRow,"dept_cd",snull)
		Return
	END IF
	
	SELECT "KFZ04OM0"."PERSON_CD"  	INTO :sDeptCode  
	   FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '3' ) AND ( "KFZ04OM0"."PERSON_NM" = :sDeptName ) AND
				( "KFZ04OM0"."PERSON_STS" = '1') ;

	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(iCurRow,"dept_cd",snull)
		this.SetItem(iCurRow,"deptname",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"dept_cd",sDeptCode)
	END IF
END IF

IF this.GetColumnName() = "bjun_no" THEN
	lJunNo = Double(this.GetText())
	IF lJunNo = 0 OR IsNull(lJunNo) THEN Return
	
//	dw_rtv.Retrieve(this.GetItemString(iCurRow,"saupj"),&
//						 this.GetItemString(iCurRow,"bal_date"),&
//						 this.GetItemString(iCurRow,"upmu_gu"),lJunNo)
	
//	cb_inq.TriggerEvent(Clicked!)
END IF

IF this.GetColumnName() = "sawon" THEN
	sEmpNo = this.GetText()
	IF sEmpNo = "" OR IsNull(sEmpNo) THEN
		this.SetItem(iCurRow,"empname",snull)
		Return
	END IF
	
	sEmpName = F_Get_PersonLst('4',sEmpNo,'1')
	IF IsNull(sEmpName) THEN
		F_MessageChk(20,'[작성자]')
		this.SetItem(iCurRow,"sawon",snull)
		this.SetItem(iCurRow,"empname",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"empname",sEmpName)
	END IF
END IF

IF this.GetColumnName() = "empname" THEN
	sEmpName = this.GetText()
	IF sEmpName = "" OR IsNull(sEmpName) THEN
		this.SetItem(iCurRow,"sawon",snull)
		Return
	END IF
	
	SELECT "KFZ04OM0"."PERSON_CD"  	INTO :sEmpNo
	   FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '4' ) AND ( "KFZ04OM0"."PERSON_NM" = :sEmpName ) AND
				( "KFZ04OM0"."PERSON_STS" = '1') ;

	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[작성자]')
		this.SetItem(iCurRow,"sawon",snull)
		this.SetItem(iCurRow,"empname",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"sawon",sEmpNo)
	END IF
END IF

IF this.GetColumnName() = "acc1_cd" THEN
	sAcc1_Cd = this.GetText()
	
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"acc1_nm",snull)
		this.SetItem(iCurRow,"acc2_nm",snull)
		
		Wf_Clear_Structure('ACCOUNT')								/*구조체 초기화*/
		Return 
	END IF
	
	sAcc2_Cd = this.GetItemString(iCurRow,"acc2_cd")
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN RETURN
	sDcGbn = this.GetItemString(iCurRow,"dcr_gu")
	
	IF Wf_Get_Account(sAcc1_Cd,sAcc2_Cd,sDcGbn) = -1 THEN			/*계정과목 관련 자료 읽기*/
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"acc1_nm",snull)
		this.SetItem(iCurRow,"acc2_nm",snull)
		
		Wf_Clear_Structure('ACCOUNT')								/*구조체 초기화*/
		Return 1
	ELSE
		this.SetItem(iCurRow,"acc1_nm",lstr_account.acc1_nm)
		this.SetItem(iCurRow,"acc2_nm",lstr_account.acc2_nm)
		
		IF Is_JunGbn = '3' THEN
			this.SetItem(iCurRow,"dcr_gu", lstr_account.dcr_gu)
			dw_ins2.SetItem(dw_ins2.GetRow(),"dcr_gu", lstr_account.dcr_gu)
		END IF
		
		sDcGbn = this.GetItemString(iCurRow,"dcr_gu")
		IF sDcGbn = "" OR IsNull(sDcGbn) THEN
			F_MessageChk(1,'[차대구분]')
			this.SetColumn("dcr_gu")
			this.SetFocus()
			Return 1
		END IF
	
		Wf_Setting_RefLst(sAcc1_Cd,sAcc2_Cd,sDcGbn)
		
		Wf_Change_Data_Clear(this.GetColumnName(),iCurRow)		/*전표 보조 관련자료 변경 시 관련항목 clear*/
	END IF
END IF

IF this.GetColumnName() = "acc2_cd" THEN
	sAcc2_Cd = this.GetText()
	
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"acc1_nm",snull)
		this.SetItem(iCurRow,"acc2_nm",snull)
		
		Wf_Clear_Structure('ACCOUNT')								/*구조체 초기화*/
		
		this.SetColumn("acc1_cd")
		this.SetFocus()
		Return 
	END IF
	
	sAcc1_Cd = this.GetItemString(iCurRow,"acc1_cd")
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN RETURN
	sDcGbn = this.GetItemString(iCurRow,"dcr_gu")
	
	IF Wf_Get_Account(sAcc1_Cd,sAcc2_Cd,sDcGbn) = -1 THEN			/*계정과목 관련 자료 읽기*/
		this.SetItem(iCurRow,"acc1_cd",snull)
		this.SetItem(iCurRow,"acc2_cd",snull)
		this.SetItem(iCurRow,"acc1_nm",snull)
		this.SetItem(iCurRow,"acc2_nm",snull)
		
		Wf_Clear_Structure('ACCOUNT')								/*구조체 초기화*/
		
		this.SetColumn("acc1_cd")
		this.SetFocus()
		Return 1
	ELSE
		this.SetItem(iCurRow,"acc1_nm",lstr_account.acc1_nm)
		this.SetItem(iCurRow,"acc2_nm",lstr_account.acc2_nm)
		
		IF Is_JunGbn = '3' THEN
			this.SetItem(iCurRow,"dcr_gu", lstr_account.dcr_gu)
			dw_ins2.SetItem(dw_ins2.GetRow(),"dcr_gu", lstr_account.dcr_gu)
		END IF
		
		sDcGbn = this.GetItemString(iCurRow,"dcr_gu")
		IF sDcGbn = "" OR IsNull(sDcGbn) THEN
			F_MessageChk(1,'[차대구분]')
			this.SetColumn("dcr_gu")
			this.SetFocus()
			Return 1
		END IF
		
		Wf_Setting_RefLst(sAcc1_Cd,sAcc2_Cd,sDcGbn)
		
		Wf_Change_Data_Clear(this.GetColumnName(),iCurRow)		/*전표 보조 관련자료 변경 시 관련항목 clear*/
		
	END IF
END IF

IF this.GetColumnName() = "dcr_gu" THEN
	sDcGbn = this.GetText()
	IF sDcGbn = "" OR IsNull(sDcGbn) THEN
		F_MessageChk(1,'[차대구분]')
		this.SetItem(iCurRow,"dcr_gu",snull)
		this.SetColumn("dcr_gu")
		this.SetFocus()
		Return 1
	END IF

	IF sDcGbn <> '1' AND sDcGbn <> '2' THEN
		F_MessageChk(20,'[차대구분]')
		this.SetItem(iCurRow,"dcr_gu",snull)
		Return 1
	END IF
	
	dw_ins2.SetItem(dw_ins2.GetRow(),"dcr_gu", sDcGbn)
	
	sAcc1_Cd = this.GetItemString(iCurRow,"acc1_cd")
	sAcc2_Cd = this.GetItemString(iCurRow,"acc2_cd")
	
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN RETURN
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN RETURN
	
	Wf_Get_Account(sAcc1_Cd,sAcc2_Cd,sDcGbn) 					/*계정과목 관련 자료 읽기*/
	
	Wf_Setting_RefLst(sAcc1_Cd,sAcc2_Cd,sDcGbn)
		
	Wf_Change_Data_Clear(this.GetColumnName(),iCurRow)		/*전표 보조 관련자료 변경 시 관련항목 clear*/
END IF

IF this.GetColumnName() = "rm_cd" THEN
	sRmCode = this.GetText()
	IF sRmCode = "" OR IsNull(sRmCode) THEN RETURN
	
	sAcc1_Cd = this.GetItemString(iCurRow,"acc1_cd")
	IF sAcc1_Cd = "" OR IsNull(sAcc1_Cd) THEN Return
	
	sAcc2_Cd = this.GetItemString(iCurRow,"acc2_cd")
	IF sAcc2_Cd = "" OR IsNull(sAcc2_Cd) THEN Return
	
	sDcGbn   = this.GetItemString(iCurRow,"dcr_gu")
	IF sDcGbn = "" OR IsNull(sDcGbn) THEN Return
	
	SELECT "KFZ07OM0"."RM_DESC"  	INTO :sRmName  
    	FROM "KFZ07OM0"  
   	WHERE ( "KFZ07OM0"."ACC1_CD" = :sAcc1_Cd ) AND ( "KFZ07OM0"."ACC2_CD" = :sAcc2_Cd ) AND  
         	( "KFZ07OM0"."DC_GU" = :sDcGbn ) AND ( "KFZ07OM0"."RM_CD" = :sRmCode )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[적요코드]')
		this.SetItem(iCurRow,"rm_cd",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"descr",sRmName)
	END IF
END IF

ib_any_typing = True
end event

event rbuttondown;String sDcGbn,sAcc1,sAcc2

SetNull(Gs_Code)
SetNull(Gs_CodeName)

SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

sAcc1 = this.GetItemString(this.GetRow(),"acc1_cd")
sAcc2 = this.GetItemString(this.GetRow(),"acc2_cd")
IF IsNull(sAcc1) THEN sAcc1 = ''
IF IsNull(sAcc2) THEN sAcc2 = ''

this.AcceptText()
IF this.GetColumnName() = "acc1_cd" OR this.GetColumnName() = "acc2_cd" THEN
	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)
	
	lstr_account.acc1_cd = Left(this.GetItemString(this.GetRow(),"acc1_cd"),1)
	lstr_account.acc2_cd = this.GetItemString(this.GetRow(),"acc2_cd")
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd = ''
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd = ''
	
	Open(W_Kfz01om0_PopUp)
	
	IF IsNull(lstr_account.acc1_cd) THEN Return
	
	this.SetItem(this.GetRow(),"acc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"acc2_cd",lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"acc1_nm",lstr_account.acc1_nm)
	this.SetItem(this.GetRow(),"acc2_nm",lstr_account.acc2_nm)
	
	IF Ib_Amt_Chk = True THEN
		this.SetItem(this.GetRow(),"dcr_gu", lstr_account.dcr_gu)
	END IF
	
	IF sAcc1 <> lstr_account.acc1_cd OR sAcc2 <> lstr_account.acc2_cd THEN
		this.TriggerEvent(ItemChanged!)
	END IF
END IF

IF this.GetColumnName() = "rm_cd" THEN
	
	gs_code = this.GetItemString(1,"dcr_gu")
	
	OPEN(W_KFZ07OM0_POPUP)
	
	IF IsNull(gs_code) OR IsNull(gs_codename) THEN Return
	
	this.SetItem(this.GetRow(),"rm_cd",gs_code)
	this.SetItem(this.GetRow(),"descr",gs_codename)
END IF

IF this.GetColumnName() ="dept_cd" THEN
	
	OpenWithParm(W_KFZ04OM0_POPUP,'3')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"dept_cd", lstr_custom.code)
	this.SetItem(this.GetRow(),"deptname",lstr_custom.name)
	
END IF

IF this.GetColumnName() ="sawon" THEN
	
	OpenWithParm(W_KFZ04OM0_POPUP,'4')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"sawon", lstr_custom.code)
	this.SetItem(this.GetRow(),"empname",lstr_custom.name)
	
END IF

ib_any_typing = True
end event

event itemerror;
Return 1
end event

event itemfocuschanged;
IF this.GetColumnName() = "deptname" OR this.GetColumnName() = "empname" OR this.GetColumnName() = "descr" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))	
END IF
end event

event getfocus;this.AcceptText()
end event

event buttonclicked;Integer  iJunNo,iRtnValue
String   sSaupj,sBalDate,sMsgParm,sDcGbn,sSysGbn

this.AcceptText()

IF dwo.name = 'dcb_finance' THEN
	IF Is_UpmuGbn = 'Q' THEN Return
	
	/*1:전표에서 생성, 2: 현금유관계정의 상대계정 자금코드로 결정*/
	select nvl(substr(dataname,1,1),'2')		into :sSysGbn					
		from syscnfg
		where sysgu = 'A' and serial = 30 and lineno = '1';
		
	if sSysGbn = '2' then Return 
	
	dw_ins.AcceptText()
	lstr_jpra.saupjang = dw_ins.GetItemString(dw_ins.GetRow(),"saupj")
	lstr_jpra.baldate  = dw_ins.GetItemString(dw_ins.GetRow(),"bal_date")
	lstr_jpra.upmugu   = dw_ins.GetItemString(dw_ins.GetRow(),"upmu_gu")
	lstr_jpra.bjunno   = dw_ins.GetItemNumber(dw_ins.GetRow(),"bjun_no")
	lstr_jpra.sortno   = dw_ins.GetItemNumber(dw_ins.GetRow(),"lin_no")
	lstr_jpra.chadae   = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu")
	
	lstr_jpra.acc1     = dw_ins.GetItemString(dw_ins.GetRow(),"acc1_cd")
	lstr_jpra.acc2     = dw_ins.GetItemString(dw_ins.GetRow(),"acc2_cd")
	
	dw_ins2.AcceptText()
	lstr_jpra.money    = dw_ins2.GetItemNumber(dw_ins2.GetRow(),"amt")
	
	IF lstr_jpra.bjunno = 0 OR IsNull(lstr_jpra.bjunno) THEN
		f_MessageChk(3,'')
		Return 
	END IF
	
	Open(W_kglb017)
//	
//	sProcGbn = Left(Message.StringParm,1)
//	
//	IF sProcGbn <> '1' THEN
//		F_MessageChk(17,'[자금수지상세]')
//		Return 
//	END IF
END IF

IF dwo.name = 'dcb_detail' AND Is_SysCnfg_DescFlag = 'Y' THEN					/*적요내역 버튼 클릭시*/
	lstr_jpra.saupjang = this.GetItemString(row,"saupj")
	lstr_jpra.BalDate  = this.GetItemString(row,"bal_date") 
	lstr_jpra.UpmuGu   = Is_UpmuGbn
	lstr_jpra.bJunNo   = this.GetItemNumber(row,"bjun_no") 
	
	IF IsNull(lstr_jpra.bJunNo) OR lstr_jpra.bJunNo = 0 THEN
		f_MessageChk(3,'')
		Return 
	END IF
	
	OpenWithParm(W_kglb012,this.GetItemString(this.GetRow(),"descr"))
	
	sMsgParm = Message.StringParm
	
	IF Left(sMsgParm,1) = '1' THEN											/*적요 변경 YES*/
		ib_any_typing = True
	END IF		
	
//	this.SetItem(this.GetRow(),"descr",Trim(Mid(sMsgParm,2,80)))
	
ELSEIF dwo.name = 'dcb_junno' THEN				/*전표 채번 버튼 클릭시*/
	sSaupj   = this.GetItemString(this.GetRow(),"saupj")
	sBalDate = this.GetItemString(this.GetRow(),"bal_date")
	
	IF Ib_ClickedFlag = True THEN RETURN
	
	IF Wf_JunPoy(sSaupj,sBalDate) <= 0 THEN Return 1
	
	Wf_Button_Sts()
//ELSEIF dwo.name = 'dcb_openw' THEN					/*보조창 버튼 클릭시*/
//	
//	sDcGbn = dw_ins.GetItemString(dw_ins.GetRow(),"dcr_gu")
//
//	iRtnValue = Wf_Open_Window(sDcGbn)
//	IF iRtnValue = 3 THEN						/*보조등록 처리 안했으면*/
//		Return
//	ELSEIF iRtnValue = -1 THEN
//		Return 
//	END IF
END IF

end event

event ue_pressenter;Long lJunNo

this.AcceptText()
IF this.GetColumnName() = "bjun_no" THEN
	lJunNo = Double(this.GetText())
	IF lJunNo = 0 OR IsNull(lJunNo) THEN Return
	
//	dw_rtv.Retrieve(this.GetItemString(iCurRow,"saupj"),&
//						 this.GetItemString(iCurRow,"bal_date"),&
//						 this.GetItemString(iCurRow,"upmu_gu"),lJunNo)
	
	p_inq.TriggerEvent(Clicked!)
ELSE
	Send(Handle(this),256,9,0)
END IF


end event

type dw_print from datawindow within w_kgld69c
boolean visible = false
integer x = 101
integer y = 2512
integer width = 1189
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "전표 인쇄"
string dataobject = "dw_kglb01_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_sang from datawindow within w_kgld69c
boolean visible = false
integer x = 101
integer y = 2620
integer width = 1189
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "상계내역 삭제(자료 수정시)"
string dataobject = "dw_kglb01_5"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sungin from datawindow within w_kgld69c
boolean visible = false
integer x = 101
integer y = 2720
integer width = 1189
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "승인전표 라인별 저장"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_descr from datawindow within w_kgld69c
boolean visible = false
integer x = 101
integer y = 2820
integer width = 1189
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "전표복사 시 품의 내역 복사"
string dataobject = "dw_kglb01_6"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type p_yesan from uo_picture within w_kgld69c
boolean visible = false
integer x = 2766
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\예산조회_up.gif"
end type

event clicked;call super::clicked;String sCdeptCode

dw_ins.AcceptText()
lstr_jpra.saupjang = dw_ins.GetItemString(dw_ins.GetRow(),"saupj")
lstr_jpra.baldate  = dw_ins.GetItemString(dw_ins.GetRow(),"bal_date")
lstr_jpra.acc1     = dw_ins.GetItemString(dw_ins.GetRow(),"acc1_cd")
lstr_jpra.acc2     = dw_ins.GetItemString(dw_ins.GetRow(),"acc2_cd")
lstr_jpra.acc1_nm  = dw_ins.GetItemString(dw_ins.GetRow(),"acc1_nm")

dw_ins2.AcceptText()
sCdeptCode         = dw_ins2.GetItemString(dw_ins2.GetRow(),"cdept_cd")

IF lstr_jpra.saupjang = "" OR IsNull(lstr_jpra.saupjang) THEN
	F_MessageChk(1,'[사업장]')
	dw_ins.SetColumn("saupj")
	dw_ins.SetFocus()
	Return 
END IF
IF lstr_jpra.baldate = "" OR IsNull(lstr_jpra.baldate) THEN
	F_MessageChk(1,'[작성일자]')
	dw_ins.SetColumn("bal_date")
	dw_ins.SetFocus()
	Return 
END IF

IF lstr_jpra.acc1 = "" OR IsNull(lstr_jpra.acc1) THEN
	F_MessageChk(1,'[계정과목]')
	dw_ins.SetColumn("acc1_cd")
	dw_ins.SetFocus()
	Return 
END IF

IF sCdeptCode = "" OR IsNull(sCdeptCode) THEN
	F_MessageChk(1,'[예산부서]')
	dw_ins2.SetColumn("cdept_cd")
	dw_ins2.SetFocus()
	Return 
END IF

IF lstr_account.Yesan_Gu = 'N' THEN
	F_MessageChk(25,'[예산 비통제]')
	Return
END IF

OpenWithParm(W_KGLB013,sCdeptCode)

end event

type cb_ins2 from commandbutton within w_kgld69c
integer x = 1893
integer y = 2796
integer width = 901
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "입출금전표 수정시 줄저장"
end type

event clicked;Integer iRowCount,iRtnValue,iFunVal
String  sDcGbn

IF dw_ins.AcceptText() = -1 THEN RETURN											/*입력1*/
IF dw_ins.GetRow() <=0 THEN Return
IF Wf_RequiredChk(dw_ins.DataObject,dw_ins.GetRow()) <=0 THEN RETURN 

IF dw_ins2.AcceptText() = -1 THEN Return											/*입력2*/
IF dw_ins2.GetRow() <=0 THEN Return
IF Wf_RequiredChk(dw_ins2.DataObject,dw_ins2.GetRow()) <=0 THEN RETURN

Wf_Move_Ins()																	/*dw_ins의 자료를 dw_ins2로 복사*/

Integer iTemp
select Count(*)	 into :iTemp
	from kfz12ot0
	where saupj = :lstr_jpra.saupjang and bal_date = :lstr_jpra.baldate and upmu_gu = :lstr_jpra.upmugu and
			bjun_no = :lstr_jpra.bjunno  ;
			
iFunVal = dw_ins2.Update()

IF iFunVal <> 1 THEN
	RollBack;
	Return
ELSE	
	dw_rtv.SetRedraw(False)	
	dw_rtv.Retrieve(dw_ins2.GetItemString(1,"saupj"),   &
	 	 				 dw_ins2.GetItemString(1,"bal_date"),&
					    Is_UpmuGbn,                         &
					    dw_ins2.GetItemNumber(1,"bjun_no"),  &
					    dw_ins.GetItemString(1,"dept_cd"),  &
					    dw_ins.GetItemString(1,"jun_gu"))
	dw_rtv.ScrollToRow(dw_rtv.RowCount())
	dw_rtv.SetRedraw(True)
END IF

iRowCount = dw_rtv.RowCount()
IF iRowCount <= 0 THEN
	Wf_Insert_Init()
ELSE 
	Wf_Append_Init(dw_rtv.GetItemNumber(iRowCount,"lin_no"),iRowCount)
END IF

w_mdi_frame.sle_msg.text = '자료를 저장하였습니다!!'
end event

type p_ok from uo_picture within w_kgld69c
integer x = 4425
integer y = 24
integer width = 178
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\confirm.cur"
string picturename = "C:\erpman\image\확인_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\확인_up.gif"
end event

event clicked;call super::clicked;Close(Parent)
end event

type rr_5 from roundrectangle within w_kgld69c
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 964
integer width = 4562
integer height = 1356
integer cornerheight = 40
integer cornerwidth = 55
end type

