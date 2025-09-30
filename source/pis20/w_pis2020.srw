$PBExportHeader$w_pis2020.srw
$PBExportComments$복지회비대출 상환/이자납입 계획 생성
forward
global type w_pis2020 from w_inherite_standard
end type
type dw_ip from u_key_enter within w_pis2020
end type
type dw_main from u_key_enter within w_pis2020
end type
type rr_1 from roundrectangle within w_pis2020
end type
type p_remain from uo_picture within w_pis2020
end type
type dw_sub from u_key_enter within w_pis2020
end type
type dw_list from u_d_popup_sort within w_pis2020
end type
type rr_2 from roundrectangle within w_pis2020
end type
end forward

global type w_pis2020 from w_inherite_standard
string title = "대출 상환/이자납입 계획 생성"
dw_ip dw_ip
dw_main dw_main
rr_1 rr_1
p_remain p_remain
dw_sub dw_sub
dw_list dw_list
rr_2 rr_2
end type
global w_pis2020 w_pis2020

type variables
string is_gubun
Boolean Lb_AutoFlag = True
end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
public subroutine wf_recalculation_remain ()
public subroutine wf_calc_pay ()
public subroutine wf_calc_bonus (string m1, string m2, string m3, string m4, string m5, string m6, string m7, string m8, string m9, string m10, string m11, string m12)
public subroutine wf_calc_all (string m1, string m2, string m3, string m4, string m5, string m6, string m7, string m8, string m9, string m10, string m11, string m12)
end prototypes

public function integer wf_requiredchk (integer icurrow);string ls_retdate, snull

setnull(snull)

if dw_main.accepttext() = -1 then return -1

ls_retdate = dw_main.getitemstring(icurrow, 'retdate')

if ls_retdate = '' or isnull(ls_retdate) then
	messagebox("확  인", "상환/지급일자를 입력하세요.")
	return -1
end if

IF f_datechk(ls_retdate) = -1 THEN 
	MessageBox("확  인", "상환/지급일자를 확인하세요.")
	dw_main.setitem(icurrow, 'retdate', snull)
	dw_main.setcolumn('retdate')
	dw_main.setfocus()
	Return -1
END IF

return 1
end function

public subroutine wf_recalculation_remain ();Integer   iRowCount, k
Double    dLendAmt,dLendRemain,dRetAmt,dAllRetAmt
String    sSubGbn

if dw_ip.accepttext() = -1 then return
dLendAmt  = dw_ip.getitemdecimal(dw_ip.getrow(), 'lendamt')
if IsNull(dLendAmt) then dLendAmt = 0

iRowCount = dw_main.RowCount()
if iRowCount <=0 then Return

dLendRemain = dLendAmt

dw_main.SetRedraw(False)
for k = 1 to iRowCount
	dRetAmt    = dw_main.GetItemNumber(k,"retamt")
	dAllRetAmt = dw_main.GetItemNumber(k,"allretamt")
	if IsNull(dRetAmt) then dRetAmt = 0
	if IsNull(dAllRetAmt) then dAllRetAmt = 0
	
	dLendRemain = dLendRemain - dRetAmt - dAllRetAmt
	dw_main.setitem(k, 'janamt',    dLendRemain)
next

for k = iRowCount to 1 Step -1
	sSubGbn = dw_main.GetItemstring(k,"subgbn")
	if IsNull(sSubGbn) then sSubGbn = 'N'
	
	dLendRemain  = dw_main.GetItemNumber(k,"janamt")
	if IsNull(dLendRemain) then dLendRemain = 0
	
	if dLendRemain < 0 and sSubGbn = 'N' then
		dw_main.DeleteRow(k)
	end if
next
dw_main.SetRedraw(True)
end subroutine

public subroutine wf_calc_pay ();String ls_EmpNo, ls_LendDate, ls_LendGbn, ls_LendFrom, ls_LendFrom_eja, ls_RetGbn, ls_SubGbn, ls_lendenddate
String ls_PretYn, ls_PejaDay, ls_PretTag
String ls_CurMaxDate, ls_CreateBaseDate, ls_PCreateDate, ls_PCreateDate2, ls_PInsertRetDate, ls_InsertBaseDate, ls_PInsertRetDate2, ls_CurMaxDate2
String ls_YearCheck, ls_MonthCheck, ls_CashRetDate
Decimal ld_LendAmt, ld_LendMamt, ld_LendMamt2, ld_LendMamt3, ld_Rate, ld_LendRemain, ld_CashAmt, ld_LendEja_Cash, ld_LendEja, ld_LendEja2, ld_MonthRetAmt
Long li_DayCnt, li_DayCnt2, li_PbGbn, li_DayCnt_cash, li_CurRow, li_Start, li_count

IF dw_sub.AcceptText() = -1 THEN Return 

ls_EmpNo    = dw_sub.GetItemString(dw_sub.GetRow(), 'empno')
ls_LendDate = dw_sub.GetItemString(dw_sub.GetRow(), 'lenddate')
ls_LendEndDate = dw_sub.GetItemString(dw_sub.GetRow(), 'lendenddate')
ls_LendGbn = dw_sub.GetItemString(dw_sub.GetRow(), 'lendGbn')
ls_LendFrom = dw_sub.GetItemString(dw_sub.GetRow(), 'lendfrom')
ls_LendFrom_Eja = dw_sub.GetItemString(dw_sub.GetRow(), 'lendfrom_eja')
ls_RetGbn = dw_sub.GetItemString(dw_sub.GetRow(), 'retgubun')

ls_PretYn = dw_sub.GetItemString(dw_sub.GetRow(), 'pretyn')
ls_PejaDay = dw_sub.GetItemString(dw_sub.GetRow(), 'pejaday')
ls_PretTag = dw_sub.GetItemString(dw_sub.GetRow(), 'prettag')

ls_PejaDay = String(Long(ls_PejaDay), '00')

ld_LendAmt  = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendamt')
ld_LendMamt = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendmamt')
ld_Rate     = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'rate')

IF IsNull(ld_LendAmt) THEN ld_LendAmt = 0
IF IsNull(ld_LendMamt) THEN ld_LendMamt = 0
IF ld_lendmamt = 0 OR IsNull(ld_lendmamt) THEN 
	ld_LendMamt2 = 0
	ld_LendMamt3 = 0
ELSE
	ld_LendMamt2 = ld_LendAmt / ld_LendMamt				  // 상환구분이 횟수일때
   ld_LendMamt3 = (ld_LendAmt * ld_LendMamt) / 100      // 상환구분이 비율일때
END IF
IF IsNull(ld_Rate) THEN ld_Rate = 0


/*상환자료 중 제일 최근 상환일자*/
	SELECT max(retdate)	
	  INTO :ls_CurMaxDate	
	  FROM p5_lendsch 
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND 
			 (paygubun like 'P');
			 
			 
	IF Sqlca.SqlCode = 0 THEN
		IF IsNull(ls_CurMaxDate) THEN ls_CurMaxDate = '00000000'     
	ELSE
		ls_CurMaxDate = '00000000'
	END IF


/*최근상환일자/상환잔액 가져오기*/		
	IF dw_main.RowCount() <=0 THEN
		ld_LendRemain = ld_LendAmt			// 생성한 상환자료가 없을때..
		ls_CurMaxDate = '00000000'
	ELSE
		IF dw_main.GetItemString(dw_main.RowCount(), 'paygubun' ) = 'X' THEN          // 생성한 상환자료가 있을때.. 마지막 행이 일시상환일 경우
		   IF dw_main.RowCount() > 1 THEN
				ls_CurMaxDate = dw_main.GetItemString(dw_main.RowCount() - 1, "retdate")   		
				ld_LendRemain = dw_main.GetItemNumber(dw_main.RowCount() - 1, "janamt")
				IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
			ELSE
				ls_CurMaxDate = ls_lenddate   
				ld_LendRemain = ld_lendamt
				IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
			END IF
		ELSE
			ls_CurMaxDate = dw_main.GetItemString(dw_main.RowCount(), "retdate")   
			ld_LendRemain = dw_main.GetItemNumber(dw_main.RowCount(), "janamt")
			IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
		END IF
	END IF


/* 상환자료 중 최근 상환일자 - 전체 */ 
	SELECT max(retdate)	
	  INTO :ls_CurMaxDate2	
	  FROM p5_lendsch 
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND 
			 paygubun like '%';
			 
			 
	IF Sqlca.SqlCode = 0 THEN
		IF IsNull(ls_CurMaxDate2) THEN ls_CurMaxDate2 = '00000000'     
	ELSE
		ls_CurMaxDate2 = '00000000'
	END IF

/* ls_CreateBaseDate는 생성기준일자(YYYYMMDD), ls_CurMaxDate는 생성기준일자 이후 첫번째 달(YYYYMM) */
	IF ls_curmaxdate <> '00000000' THEN 						               // 생성한 상환자료가 있을때..
		ls_CreateBaseDate = ls_CurMaxDate                                // ls_CreateBaseDate에 가장 최근의 생성날짜를 저장.
	  	IF Long(Right(ls_CurMaxDate, 2)) < Long(ls_PejaDay) THEN 			// 같은 달을 포함하기 위해
			ls_CurMaxDate = ls_CurMaxDate2
		ELSE
			ls_CurMaxDate = F_AfterMonth(Left(ls_CurMaxDate, 6), 1)           // ls_CurMaxDate에 ls_CurMaxDate의 한달후의 값을 저장.
		END IF
	ELSE																						// 생성한 상환자료가 없을때..(즉, 처음 상환할 때)
		ls_CreateBaseDate = ls_LendDate 												// ls_CreateBaseDate에 대출한 날짜를 저장.		
		ls_CurMaxDate = ls_LendFrom_eja													// ls_CurMaxDate에 상환시작달을 저장.
	END IF
	
/* 급여기준 일자 생성 */	
	IF ls_PejaDay = '30' THEN															// 급여기준일이 말일일때..																							
		ls_PCreateDate = F_Last_Date(ls_CurMaxDate)  							// ls_PCreateDate는 급여기준일자(일자는 말일)
		ls_PCreateDate2 = F_AfterMonth(Left(ls_PCreateDate, 6), 1) + String('01') // ls_PCreateDate2는 급여기준일자의 다음일자
	ELSE																						// 급여기준일이 말일이 아닐때..								
		ls_PCreateDate = Left(ls_CurMaxDate, 6) + ls_PejaDay					// ls_PCreateDate는 급여기준일자(일자는 선택한 일자)
		ls_PCreateDate2 = Left(ls_PCreateDate, 6) + String(Integer(ls_PejaDay) + 1, '00') 
	END IF
   
/* 상환된 자료의 숫자 생성 */	
	SELECT Count(retdate)
	  INTO :li_count
	  FROM p5_lendsch
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND
			 subgbn = 'Y' AND
			 paygubun like '%';
	
/* 처음 로우 일수 계산 */

	IF Long(ls_lendenddate) > Long(ls_PCreateDate) OR IsNull(ls_LendEndDate) OR ls_LendEndDate = '' THEN // 상환종료일자와 비교후 마지막 로우에 원금 전부 상환여부 체크
		IF li_count = 0 THEN
			li_DayCnt = DaysAfter(Date(String(ls_CreateBaseDate, "@@@@.@@.@@")), Date(string(ls_PCreateDate, "@@@@.@@.@@"))) + 1
		ELSE
			li_DayCnt = DaysAfter(Date(String(F_afterday(ls_CreateBaseDate, 1), "@@@@.@@.@@")), Date(string(ls_PCreateDate, "@@@@.@@.@@"))) + 1
		END IF
		dw_main.SetReDraw(False)
	
	
			ls_InsertBaseDate = ls_CreateBaseDate		
			ls_PInsertRetDate = ls_PCreateDate
			ls_PInsertRetDate2 = ls_PCreateDate2
			
			li_start = 0 // 처음 로우 인지 아닌지 구분.
		
			
			DO UNTIL ld_LendRemain <= 0
				ld_LendEja = 0
		
		
					IF Long(ls_lendenddate) > Long(ls_PInsertRetDate) OR IsNull(ls_LendEndDate) OR ls_LendEndDate = '' THEN
							IF li_start = 1 THEN  // 처음 로우가 아닐 경우 날짜 계산
								li_DayCnt = DaysAfter(Date(String(ls_InsertBaseDate, "@@@@.@@.@@")), Date(String(ls_PInsertRetDate, "@@@@.@@.@@"))) + 1
								li_DayCnt_Cash = 0
							END IF
							
							SELECT sum(nvl(allretamt,0)), retdate 
							  INTO :ld_CashAmt, :ls_CashRetDate   
							  FROM p5_lendsch 		/*급여일시상환자료*/
							 WHERE lendkind = '1' AND
									 lendGbn = :ls_LendGbn AND
									 empno = :ls_EmpNo AND
									 lenddate = :ls_LendDate AND
									 paygubun = 'X' AND
									 retdate >= :ls_InsertBaseDate and retdate < :ls_PInsertRetDate
							 GROUP BY retdate;
							IF Sqlca.SqlCode = 0 THEN
								IF IsNull(ld_CashAmt) then ld_CashAmt = 0
							ELSE
								ld_CashAmt = 0
							END IF			
							
							IF ld_CashAmt <> 0 THEN // 일시상환이 있을경우
								li_DayCnt_cash = DaysAfter(Date(String(F_AfterDay(ls_InsertBaseDate, 1), "@@@@.@@.@@")), Date(String(ls_CashRetDate, "@@@@.@@.@@"))) + 1 //기준일로부터 일시상환일까지의 일수
								ld_LendEja_Cash = Truncate((ld_LendRemain * li_DayCnt_Cash / 365 * (ld_Rate / 100)),0) // 기준일부토 일시상환일까지의 이자.
								
								ld_LendRemain = ld_LendRemain - ld_CashAmt // 일시상환금을 빼고 남은돈.
								ls_CashRetDate = F_AfterDay(ls_CashRetDate, 1) // 상여일시상환일의 다음날
								li_DayCnt = DaysAfter(Date(String(ls_CashRetDate, "@@@@.@@.@@")), Date(String(ls_PInsertRetDate, "@@@@.@@.@@"))) + 1 // 일시상환일의 다음날부터 급여기준말일 까지의 일수				
							ELSE
								li_DayCnt_cash = 0
								ld_LendEja_Cash = 0
							END IF
							
							IF ls_RetGbn = '1' THEN //상환구분이 횟수일때
								IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendMamt2 THEN
										ld_MonthRetAmt = ld_LendMamt2	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF		
							ELSEIF ls_RetGbn = '2' THEN //상환구분이 비율일때
								IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendMamt3 THEN
										ld_MonthRetAmt = ld_LendMamt3	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							ELSEIF ls_RetGbn = '3' THEN //상환구분이 금액일때
								IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendMamt THEN
										ld_MonthRetAmt = ld_LendMamt	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							END IF
						
				
							IF ld_LendRemain > 0 THEN
								li_CurRow = dw_main.insertrow(0)
								
								/*이자계산 : 일단위 버림*/
								ld_LendEja = ld_LendEja_Cash + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) 
								/*일수계산 : 누적 일수 */
								li_DayCnt2 = li_DayCnt + li_DayCnt_Cash
											
								IF ls_prettag = '3' THEN
									dw_main.SetItem(dw_main.RowCount(), 'retamt', 0)
									dw_main.SetItem(li_CurRow, 'janamt',   ld_LendRemain)
									dw_main.SetItem(li_CurRow, 'reteja',   ld_LendEja)
									dw_main.SetItem(li_CurRow, 'ejaday',   li_DayCnt2) 
								ELSEIF ls_prettag = '2' THEN
									dw_main.SetItem(dw_main.RowCount(), 'reteja', 0)
									dw_main.SetItem(li_CurRow, 'janamt',   ld_LendRemain - ld_MonthRetAmt)
									dw_main.SetItem(li_CurRow, 'retamt',   ld_MonthRetAmt)
									dw_main.SetItem(li_CurRow, 'ejaday',   0) 
								ELSE
									IF ls_lendfrom = ls_lendfrom_eja THEN
										dw_main.SetItem(li_CurRow, 'janamt',   ld_LendRemain - ld_MonthRetAmt)
										dw_main.SetItem(li_CurRow, 'reteja',   ld_LendEja)
										dw_main.SetItem(li_CurRow, 'retamt',   ld_MonthRetAmt)
										dw_main.SetItem(li_CurRow, 'ejaday',   li_DayCnt2) 
									ELSE
										dw_main.SetItem(li_CurRow, 'janamt', ld_LendRemain)
										dw_main.SetItem(li_CurRow, 'reteja', ld_LendEja)
										dw_main.SetItem(li_CurRow, 'retamt', 0)
										dw_main.SetItem(li_CurRow, 'ejaday',   li_DayCnt2) 
									END IF
								END IF
								
								dw_main.SetItem(li_CurRow, 'paygubun', 'P')
								dw_main.SetItem(li_CurRow, 'empno',    ls_EmpNo)
								dw_main.SetItem(li_CurRow, 'lendgbn',  ls_LendGbn)
								dw_main.SetItem(li_CurRow, 'lenddate', ls_LendDate)
								dw_main.SetItem(li_CurRow, 'retdate',  ls_PInsertRetDate)
								dw_main.SetItem(li_CurRow, 'rate', ld_Rate)
					
								
								ls_InsertBaseDate = ls_PInsertRetDate2 
								IF ls_PejaDay = '30' THEN																																			
									ls_PInsertRetDate = F_Last_Date(F_AfterMonth(Left(ls_PInsertRetDate, 6), 1))
									ls_PInsertRetDate2 = F_AfterMonth(Left(ls_PInsertRetDate, 6), 1) + String('01') 
								ELSE																					
									ls_PInsertRetDate = F_AfterMonth(Left(ls_PInsertRetDate, 6), 1) + ls_PejaDay				
									ls_PInsertRetDate2 = Left(ls_PInsertRetDate, 6) + String(Integer(ls_PejaDay) + 1, '00') 
								END IF
								
							ELSE
								dw_main.SetItem(dw_main.RowCount(), 'janamt',   0) 
							END IF
						
							IF ls_prettag = '3' THEN
								ld_lendRemain = ld_lendRemain 
							ELSEIF ls_prettag = '2' THEN
								ld_lendRemain = ld_LendRemain - ld_MonthRetAmt
							ELSE 
								IF ls_lendfrom = ls_lendfrom_eja THEN
									ld_LendRemain = ld_LendRemain - ld_MonthRetAmt
								ELSE
									ld_LendRemain = ld_LendRemain
									ls_LendFrom_eja = F_AfterMonth(ls_lendFrom_eja, 1)
								END IF 
							END IF
							
					ELSE 
							IF li_start = 1 THEN  // 처음 로우가 아닐 경우 날짜 계산
								li_DayCnt = DaysAfter(Date(String(ls_InsertBaseDate, "@@@@.@@.@@")), Date(String(ls_LendEndDate, "@@@@.@@.@@"))) + 1
								li_DayCnt_Cash = 0
							END IF
							
							SELECT sum(nvl(allretamt,0)), retdate 
							  INTO :ld_CashAmt, :ls_CashRetDate   
							  FROM p5_lendsch 		/*급여일시상환자료*/
							 WHERE lendkind = '1' AND
									 lendGbn = :ls_LendGbn AND
									 empno = :ls_EmpNo AND
									 lenddate = :ls_LendDate AND
									 paygubun = 'X' AND
									 retdate >= :ls_InsertBaseDate and retdate < :ls_LendEndDate
							 GROUP BY retdate;
							IF Sqlca.SqlCode = 0 THEN
								IF IsNull(ld_CashAmt) then ld_CashAmt = 0
							ELSE
								ld_CashAmt = 0
							END IF			
							
							IF ld_CashAmt <> 0 THEN // 일시상환이 있을경우
								li_DayCnt_cash = DaysAfter(Date(String(F_AfterDay(ls_InsertBaseDate, 1), "@@@@.@@.@@")), Date(String(ls_CashRetDate, "@@@@.@@.@@"))) + 1 //기준일로부터 일시상환일까지의 일수
								ld_LendEja_Cash = Truncate((ld_LendRemain * li_DayCnt_Cash / 365 * (ld_Rate / 100)),0) // 기준일부토 일시상환일까지의 이자.
								
								ld_LendRemain = ld_LendRemain - ld_CashAmt // 일시상환금을 빼고 남은돈.
								ls_CashRetDate = F_AfterDay(ls_CashRetDate, 1) // 상여일시상환일의 다음날
								li_DayCnt = DaysAfter(Date(String(ls_CashRetDate, "@@@@.@@.@@")), Date(String(ls_LendEndDate, "@@@@.@@.@@"))) + 1 // 일시상환일의 다음날부터 급여기준말일 까지의 일수				
							ELSE
								li_DayCnt_cash = 0
								ld_LendEja_Cash = 0
							END IF
							
							IF ls_RetGbn = '1' THEN //상환구분이 횟수일때
								IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendMamt2 THEN
										ld_MonthRetAmt = ld_LendMamt2	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF		
							ELSEIF ls_RetGbn = '2' THEN //상환구분이 비율일때
								IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendMamt3 THEN
										ld_MonthRetAmt = ld_LendMamt3	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							ELSEIF ls_RetGbn = '3' THEN //상환구분이 금액일때
								IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendMamt THEN
										ld_MonthRetAmt = ld_LendMamt	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							END IF
						
				
							IF ld_LendRemain > 0 THEN
								li_CurRow = dw_main.insertrow(0)
								
								/*이자계산 : 일단위 버림*/
								ld_LendEja = ld_LendEja_Cash + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) 
								/*일수계산 : 누적 일수 */
								li_DayCnt2 = li_DayCnt + li_DayCnt_Cash
											
								dw_main.SetItem(dw_main.RowCount(), 'retamt', ld_LendRemain)
								dw_main.SetItem(li_CurRow, 'janamt',   0)
								IF ls_prettag = '2' THEN
									dw_main.SetItem(li_CurRow, 'reteja',   0)
									dw_main.SetItem(li_CurRow, 'ejaday',   0) 
								ELSE
									dw_main.SetItem(li_CurRow, 'reteja',   ld_LendEja)
									dw_main.SetItem(li_CurRow, 'ejaday',   li_DayCnt2) 
								END IF
								
								dw_main.SetItem(li_CurRow, 'paygubun', 'P')
								dw_main.SetItem(li_CurRow, 'empno',    ls_EmpNo)
								dw_main.SetItem(li_CurRow, 'lendgbn',  ls_LendGbn)
								dw_main.SetItem(li_CurRow, 'lenddate', ls_LendDate)
								dw_main.SetItem(li_CurRow, 'retdate',  ls_LendEndDate)
								dw_main.SetItem(li_CurRow, 'rate', ld_Rate)
							ELSE
								dw_main.SetItem(dw_main.RowCount(), 'janamt',   0) 
							END IF
						
							ld_lendRemain = 0												
					END IF				
			li_start = 1
			LOOP

	ELSE
		IF li_count = 0 THEN
			li_DayCnt = DaysAfter(Date(String(ls_CreateBaseDate, "@@@@.@@.@@")), Date(string(ls_LendEndDate, "@@@@.@@.@@"))) + 1
		ELSE
			li_DayCnt = DaysAfter(Date(String(F_afterday(ls_CreateBaseDate, 1), "@@@@.@@.@@")), Date(string(ls_LendEndDate, "@@@@.@@.@@"))) + 1
		END IF
		dw_main.SetReDraw(False)
	
			ls_InsertBaseDate = ls_CreateBaseDate		
			ls_PInsertRetDate = ls_PCreateDate
			ls_PInsertRetDate2 = ls_PCreateDate2
			
			li_start = 0 // 처음 로우 인지 아닌지 구분.
		
			
			DO UNTIL ld_LendRemain <= 0
				ld_LendEja = 0
		
					SELECT sum(nvl(allretamt,0)), retdate 
					  INTO :ld_CashAmt, :ls_CashRetDate   
					  FROM p5_lendsch 		/*급여일시상환자료*/
					 WHERE lendkind = '1' AND
							 lendGbn = :ls_LendGbn AND
							 empno = :ls_EmpNo AND
							 lenddate = :ls_LendDate AND
							 paygubun = 'X' AND
							 retdate >= :ls_InsertBaseDate and retdate < :ls_LendEndDate
					 GROUP BY retdate;
					IF Sqlca.SqlCode = 0 THEN
						IF IsNull(ld_CashAmt) then ld_CashAmt = 0
					ELSE
						ld_CashAmt = 0
					END IF			
					
					IF ld_CashAmt <> 0 THEN // 일시상환이 있을경우
						li_DayCnt_cash = DaysAfter(Date(String(F_AfterDay(ls_InsertBaseDate, 1), "@@@@.@@.@@")), Date(String(ls_CashRetDate, "@@@@.@@.@@"))) + 1 //기준일로부터 일시상환일까지의 일수
						ld_LendEja_Cash = Truncate((ld_LendRemain * li_DayCnt_Cash / 365 * (ld_Rate / 100)),0) // 기준일부토 일시상환일까지의 이자.
						
						ld_LendRemain = ld_LendRemain - ld_CashAmt // 일시상환금을 빼고 남은돈.
						ls_CashRetDate = F_AfterDay(ls_CashRetDate, 1) // 상여일시상환일의 다음날
						li_DayCnt = DaysAfter(Date(String(ls_CashRetDate, "@@@@.@@.@@")), Date(String(ls_LendEndDate, "@@@@.@@.@@"))) + 1 // 일시상환일의 다음날부터 급여기준말일 까지의 일수				
					ELSE
						li_DayCnt_cash = 0
						ld_LendEja_Cash = 0
					END IF
					
					IF ls_RetGbn = '1' THEN //상환구분이 횟수일때
						IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
							IF ld_LendRemain >= ld_LendMamt2 THEN
								ld_MonthRetAmt = ld_LendMamt2	
							ELSE
								ld_MonthRetAmt = ld_LendRemain
							END IF
						ELSE
							ld_MonthRetAmt = 0
						END IF		
					ELSEIF ls_RetGbn = '2' THEN //상환구분이 비율일때
						IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
							IF ld_LendRemain >= ld_LendMamt3 THEN
								ld_MonthRetAmt = ld_LendMamt3	
							ELSE
								ld_MonthRetAmt = ld_LendRemain
							END IF
						ELSE
							ld_MonthRetAmt = 0
						END IF
					ELSEIF ls_RetGbn = '3' THEN //상환구분이 금액일때
						IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
							IF ld_LendRemain >= ld_LendMamt THEN
								ld_MonthRetAmt = ld_LendMamt	
							ELSE
								ld_MonthRetAmt = ld_LendRemain
							END IF
						ELSE
							ld_MonthRetAmt = 0
						END IF
					END IF
				
		
					IF ld_LendRemain > 0 THEN
						li_CurRow = dw_main.insertrow(0)
						
						/*이자계산 : 일단위 버림*/
						ld_LendEja = ld_LendEja_Cash + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) 
						/*일수계산 : 누적 일수 */
						li_DayCnt2 = li_DayCnt + li_DayCnt_Cash
									
						dw_main.SetItem(dw_main.RowCount(), 'retamt', ld_LendRemain)
						dw_main.SetItem(li_CurRow, 'janamt',   0)
						IF ls_prettag = '2' THEN
							dw_main.SetItem(li_CurRow, 'reteja',   0)
							dw_main.SetItem(li_CurRow, 'ejaday',   0) 
						ELSE
							dw_main.SetItem(li_CurRow, 'reteja',   ld_LendEja)
							dw_main.SetItem(li_CurRow, 'ejaday',   li_DayCnt2) 
						END IF						
						dw_main.SetItem(li_CurRow, 'paygubun', 'P')
						dw_main.SetItem(li_CurRow, 'empno',    ls_EmpNo)
						dw_main.SetItem(li_CurRow, 'lendgbn',  ls_LendGbn)
						dw_main.SetItem(li_CurRow, 'lenddate', ls_LendDate)
						dw_main.SetItem(li_CurRow, 'retdate',  ls_LendEndDate)
						dw_main.SetItem(li_CurRow, 'rate', ld_Rate)
									
					ELSE
						dw_main.SetItem(dw_main.RowCount(), 'janamt',   0) 
					END IF
				
					ld_lendRemain = 0 
			li_start = 1
			LOOP
	END IF
			

end subroutine

public subroutine wf_calc_bonus (string m1, string m2, string m3, string m4, string m5, string m6, string m7, string m8, string m9, string m10, string m11, string m12);/* 급여 + 상여시 계산 로직 */
String ls_EmpNo, ls_LendDate, ls_LendGbn, ls_LendFrom, ls_LendFrom_Eja, ls_RetGbn, ls_SubGbn, ls_LendEndDate
String ls_BretYn, ls_BejaDay, ls_BretTag
String ls_CurMaxDate, ls_CreateBaseDate, ls_InsertBaseDate, ls_CurMaxDate2
String ls_YearCheck, ls_MonthCheck, ls_BCreateDate, ls_BCreateDate2, ls_BInsertRetDate, ls_CashRetDate, ls_BInsertRetDate2
Decimal ld_LendAmt, ld_LendBamt, ld_LendBamt2, ld_LendBamt3, ld_Rate, ld_LendRemain, ld_CashAmt, ld_LendEja_Cash, ld_LendEja, ld_LendEja2, ld_MonthRetAmt
Long li_DayCnt, li_DayCnt2, li_PbGbn, li_DayCnt_cash, li_CurRow, li_Start, li_count

IF dw_sub.AcceptText() = -1 THEN Return 

ls_EmpNo    = dw_sub.GetItemString(dw_sub.GetRow(), 'empno')
ls_LendDate = dw_sub.GetItemString(dw_sub.GetRow(), 'lenddate')
ls_LendEndDate = dw_sub.GetItemString(dw_sub.GetRow(), 'lendenddate')
ls_LendGbn = dw_sub.GetItemString(dw_sub.GetRow(), 'lendGbn')
ls_LendFrom = dw_sub.GetItemString(dw_sub.GetRow(), 'lendfrom')
ls_LendFrom_Eja = dw_sub.GetItemString(dw_sub.GetRow(), 'lendfrom_eja')
ls_RetGbn = dw_sub.GetItemString(dw_sub.GetRow(), 'retgubun')

ls_BretYn = dw_sub.GetItemString(dw_sub.GetRow(), 'bretyn')
ls_BejaDay = dw_sub.GetItemString(dw_sub.GetRow(), 'bejaday')
ls_BretTag = dw_sub.GetItemString(dw_sub.GetRow(), 'brettag')

ls_BejaDay = String(Long(ls_BejaDay), '00')

ld_LendAmt  = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendamt')
ld_LendBamt = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendBamt')
ld_Rate     = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'rate')

IF IsNull(ld_LendAmt) THEN ld_LendAmt = 0
IF IsNull(ld_LendBamt) THEN ld_LendBamt = 0
IF ld_lendBamt = 0 OR IsNull(ld_lendBamt) THEN 
	ld_LendBamt2 = 0
	ld_LendBamt3 = 0
ELSE
	ld_LendBamt2 = ld_LendAmt / ld_LendBamt				  // 상환구분이 횟수일때
   ld_LendBamt3 = (ld_LendAmt * ld_LendBamt) / 100      // 상환구분이 비율일때
END IF
IF IsNull(ld_Rate) THEN ld_Rate = 0

/* 상여생성월 check */ 
	IF M1 <> '1' OR IsNull(M1) THEN M1 = '00' ELSE M1 = '01'
	IF M2 <> '2' OR IsNull(M2) THEN M2 = '00' ELSE M2 = '02'
	IF M3 <> '3' OR IsNull(M3) THEN M3 = '00' ELSE M3 = '03'
	IF M4 <> '4' OR IsNull(M4) THEN M4 = '00' ELSE M4 = '04'
	IF M5 <> '5' OR IsNull(M5) THEN M5 = '00' ELSE M5 = '05'
	IF M6 <> '6' OR IsNull(M6) THEN M6 = '00' ELSE M6 = '06'
	IF M7 <> '7' OR IsNull(M7) THEN M7 = '00' ELSE M7 = '07'
	IF M8 <> '8' OR IsNull(M8) THEN M8 = '00' ELSE M8 = '08'
	IF M9 <> '9' OR IsNull(M9) THEN M9 = '00' ELSE M9 = '09'
	IF M10 <> '10' OR IsNull(M10) THEN M10 = '00' ELSE M10 = '10' 
	IF M11 <> '11' OR IsNull(M11) THEN M11 = '00' ELSE M11 = '11' 
	IF M12 <> '12' OR IsNull(M12) THEN M12 = '00' ELSE M12 = '12' 


/*상환자료 중 제일 최근 상환일자*/
	SELECT max(retdate)	
	  INTO :ls_CurMaxDate	
	  FROM p5_lendsch 
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND 
			 paygubun like 'B';
			 
			 
	IF Sqlca.SqlCode = 0 THEN
		IF IsNull(ls_CurMaxDate) THEN ls_CurMaxDate = '00000000'     
	ELSE
		ls_CurMaxDate = '00000000'
	END IF


/*최근상환일자/상환잔액 가져오기*/		
	IF dw_main.RowCount() <=0 THEN
		ld_LendRemain = ld_LendAmt			// 생성한 상환자료가 없을때..
		ls_CurMaxDate = '00000000'
	ELSE
		IF dw_main.GetItemString(dw_main.RowCount(), 'paygubun' ) = 'X' THEN          // 생성한 상환자료가 있을때.. 마지막 행이 일시상환일 경우
			IF dw_main.RowCount() > 1 THEN
				ls_CurMaxDate = dw_main.GetItemString(dw_main.RowCount() - 1, "retdate")   		
				ld_LendRemain = dw_main.GetItemNumber(dw_main.RowCount() - 1, "janamt")
				IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
			ELSE
				ls_CurMaxDate = ls_lenddate   
				ld_LendRemain = ld_lendamt
				IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
			END IF		
		ELSE
			ls_CurMaxDate = dw_main.GetItemString(dw_main.RowCount(), "retdate")   //생성한 상환자료가 있을때...		
			ld_LendRemain = dw_main.GetItemNumber(dw_main.RowCount(), "janamt")
			IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
		END IF
	END IF


/* 상환자료 중 최근 상환일자 - 전체 */ 
	SELECT max(retdate)	
	  INTO :ls_CurMaxDate2	
	  FROM p5_lendsch 
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND 
			 paygubun like '%';
			 
			 
	IF Sqlca.SqlCode = 0 THEN
		IF IsNull(ls_CurMaxDate2) THEN ls_CurMaxDate2 = '00000000'     
	ELSE
		ls_CurMaxDate2 = '00000000'
	END IF


/* ls_CreateBaseDate는 생성기준일자(YYYYMMDD), ls_CurMaxDate는 생성기준일자 이후 첫번째 달(YYYYMM) */
	IF ls_curmaxdate <> '00000000' THEN 						               // 생성한 상환자료가 있을때..
		ls_CreateBaseDate = ls_CurMaxDate                                // ls_CreateBaseDate에 가장 최근의 생성날짜를 저장.
	  	IF Long(Right(ls_CurMaxDate, 2)) < Long(ls_BejaDay) THEN 			// 같은 달을 포함하기 위해
			ls_CurMaxDate = ls_CurMaxDate2
		ELSE
			ls_CurMaxDate = F_AfterMonth(Left(ls_CurMaxDate, 6), 1)           // ls_CurMaxDate에 ls_CurMaxDate의 한달후의 값을 저장.
		END IF
	ELSE																						// 생성한 상환자료가 없을때..(즉, 처음 상환할 때)
		ls_CreateBaseDate = ls_LendDate 												// ls_CreateBaseDate에 대출한 날짜를 저장.		
		ls_CurMaxDate = ls_LendFrom_eja													// ls_CurMaxDate에 상환시작달을 저장.
	END IF


/* 상여기준 일자 생성 */	
	ls_YearCheck = Left(ls_CurMaxDate, 4) 
	ls_MonthCheck = Mid(ls_CurMaxDate, 5, 2)
		
	DO UNTIL Integer(ls_MonthCheck) = Integer(M1) OR Integer(ls_MonthCheck) = Integer(M2) OR Integer(ls_MonthCheck) = Integer(M3) OR Integer(ls_MonthCheck) = Integer(M4) OR Integer(ls_MonthCheck) = Integer(M5) OR &
				Integer(ls_MonthCheck) = Integer(M6) OR Integer(ls_MonthCheck) = Integer(M7) OR Integer(ls_MonthCheck) = Integer(M8) OR Integer(ls_MonthCheck) = Integer(M9) OR Integer(ls_MonthCheck) = Integer(M10) OR &
				Integer(ls_MonthCheck) = Integer(M11) OR Integer(ls_MonthCheck) = Integer(M12) 
				
				ls_MonthCheck = String(Integer(ls_MonthCheck) + 1)
				IF Integer(ls_MonthCheck) > 12 THEN
					ls_MonthCheck = '01'
					ls_YearCheck = String(Long(ls_YearCheck) + 1)
				END IF
	LOOP
					
	ls_MonthCheck = String(Long(ls_MonthCheck),'00')   // ls_MonthCheck의 형식을 두자리로 만들어 줌.
			
	IF ls_BejaDay = '30' THEN 																	  // 상여기준일이 말일일때..
		ls_BCreateDate = F_Last_Date(ls_YearCheck + ls_MonthCheck)					  // ls_BCreateDate는 상여기준일자(일자는 말일)
		ls_BCreateDate2 = F_AfterMonth(Left(ls_BCreateDate, 6), 1) + String('01') // ls_BCreateDate2는 급여기준일자의 다음일자
	ELSE																								  // 상여기준일이 말일이 아닐때..	
		ls_BCreateDate = ls_YearCheck + ls_MonthCheck + ls_BejaDay				  // ls_BCreateDate는 상여기준일자(일자는 선택한 일자)
		ls_BCreateDate2 = Left(ls_BCreateDate, 6) + String(Integer(ls_BejaDay) + 1, '00')
	END IF


   SELECT Count(retdate)
	  INTO :li_count
	  FROM p5_lendsch
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND
			 subgbn = 'Y' AND
			 paygubun like '%';
			 
			 
/* 처음 로우 일수 계산 */
	IF Long(ls_lendenddate) > Long(ls_BCreateDate) OR IsNull(ls_LendEndDate) OR ls_LendEndDate = '' THEN // 상환종료일자와 비교후 마지막 로우에 원금 전부 상환여부 체크
		IF li_count = 0 THEN   // 상환된 자료가 있으면, 상환된날의 다음날부터 일수를 계산하여야 함.
			li_DayCnt = DaysAfter(Date(String(ls_CreateBaseDate, "@@@@.@@.@@")), Date(string(ls_BCreateDate, "@@@@.@@.@@"))) + 1 // 일자 계산
		ELSE
			li_DayCnt = DaysAfter(Date(String(F_afterday(ls_CreateBaseDate, 1), "@@@@.@@.@@")), Date(string(ls_BCreateDate, "@@@@.@@.@@"))) + 1 // 일자 계산
		END IF
		dw_main.SetReDraw(False)
		
		ls_InsertBaseDate = ls_CreateBaseDate
		ls_BInsertRetDate  = ls_BCreateDate
		ls_BInsertRetDate2 = ls_BCreateDate2
		li_start = 0 // 처음 로우 인지 아닌지 구분.
		
		
		DO UNTIL ld_LendRemain <= 0
		  ld_LendEja = 0
		  IF Long(ls_lendenddate) > Long(ls_BInsertRetDate) OR IsNull(ls_LendEndDate) OR ls_LendEndDate = '' THEN
		  		IF li_start = 1 THEN
					li_DayCnt = DaysAfter(Date(String(ls_InsertBaseDate, "@@@@.@@.@@")), Date(String(ls_BInsertRetDate, "@@@@.@@.@@"))) + 1
					li_DayCnt_Cash = 0
				END IF
				
				SELECT SUM(NVL(allretamt,0)), retdate 
				  INTO :ld_CashAmt, :ls_CashRetDate   
				  FROM p5_lendsch 		/* 상여일시상환자료 */
				 WHERE lendGbn = :ls_LendGbn AND
						 empno = :ls_EmpNo AND
						 lenddate = :ls_LendDate AND
						 lendkind = '1' AND
						 paygubun = 'X' AND
						 retdate >= :ls_InsertBaseDate and retdate < :ls_BInsertRetDate
				 GROUP BY retdate;
				IF Sqlca.SqlCode = 0 THEN
					IF IsNull(ld_CashAmt) then ld_CashAmt = 0
				ELSE
					ld_CashAmt = 0
				END IF
							
				IF ld_CashAmt <> 0 THEN // 일시상환이 있을경우
					li_DayCnt_cash = DaysAfter(Date(String(F_afterday(ls_InsertBaseDate, 1), "@@@@.@@.@@")), Date(String(ls_CashRetDate, "@@@@.@@.@@"))) + 1 //기준일로부터 일시상환일까지의 일수
					ld_LendEja_Cash = Truncate((ld_LendRemain * li_DayCnt_Cash / 365 * (ld_Rate / 100)),0) // 기준일부토 일시상환일까지의 이자.
					
					ld_LendRemain = ld_LendRemain - ld_CashAmt // 일시상환금을 빼고 남은돈.
					ls_CashRetDate = F_AfterDay(ls_CashRetDate, 1) // 상여일시상환일의 다음날
					li_DayCnt = DaysAfter(Date(String(ls_CashRetDate, "@@@@.@@.@@")), Date(String(ls_BInsertRetDate, "@@@@.@@.@@"))) + 1 // 일시상환일의 다음날부터 상여기준말일 까지의 일수				
				ELSE
					li_DayCnt_cash = 0
					ld_LendEja_Cash = 0
				END IF
													
				IF ls_RetGbn = '1' THEN //상환구분이 횟수일때
					IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
						IF ld_LendRemain >= ld_LendBamt2 THEN
							ld_MonthRetAmt = ld_LendBamt2	
						ELSE
							ld_MonthRetAmt = ld_LendRemain
						END IF
					ELSE
						ld_MonthRetAmt = 0
					END IF
				ELSEIF ls_RetGbn = '2' THEN //상환구분이 비율일때
					IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
						IF ld_LendRemain >= ld_LendBamt3 THEN
							ld_MonthRetAmt = ld_LendBamt3	
						ELSE
							ld_MonthRetAmt = ld_LendRemain
						END IF
					ELSE
						ld_MonthRetAmt = 0
					END IF
				ELSEIF ls_RetGbn = '3' THEN //상환구분이 금액일때
					IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
						IF ld_LendRemain >= ld_LendBamt THEN
							ld_MonthRetAmt = ld_LendBamt	
						ELSE
							ld_MonthRetAmt = ld_LendRemain
						END IF
					ELSE
						ld_MonthRetAmt = 0
					END IF
				END IF
				
				IF ld_LendRemain > 0 THEN
					li_CurRow = dw_main.insertrow(0)
					
					/*이자계산 : 일단위 버림*/
					ld_LendEja = ld_LendEja_Cash + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) 
					/*일수계산 : 누적 일수 */
					li_DayCnt2 = li_DayCnt + li_DayCnt_Cash
						
					IF ls_brettag = '3' THEN
						dw_main.SetItem(dw_main.RowCount(), 'retamt', 0)
						dw_main.SetItem(li_CurRow, 'janamt',   ld_LendRemain)
						dw_main.SetItem(li_CurRow, 'reteja',   ld_LendEja)
						dw_main.SetItem(li_CurRow, 'ejaday',   li_DayCnt2) 
					ELSEIF ls_brettag = '2' THEN
						dw_main.SetItem(dw_main.RowCount(), 'reteja', 0)
						dw_main.SetItem(li_CurRow, 'janamt',   ld_LendRemain - ld_MonthRetAmt)
						dw_main.SetItem(li_CurRow, 'retamt',   ld_MonthRetAmt)
						dw_main.SetItem(li_CurRow, 'ejaday',   0) 
					ELSE
						IF ls_lendfrom = ls_lendfrom_eja THEN
							dw_main.SetItem(li_CurRow, 'janamt',   ld_LendRemain - ld_MonthRetAmt)
							dw_main.SetItem(li_CurRow, 'reteja',   ld_LendEja)
							dw_main.SetItem(li_CurRow, 'retamt',   ld_MonthRetAmt)
							dw_main.SetItem(li_CurRow, 'ejaday',   li_DayCnt2) 
						ELSE
							dw_main.SetItem(li_CurRow, 'janamt', ld_LendRemain)
							dw_main.SetItem(li_CurRow, 'reteja', ld_LendEja)
							dw_main.SetItem(li_CurRow, 'retamt', 0)
							dw_main.SetItem(li_CurRow, 'ejaday',   li_DayCnt2) 
						END IF
					END IF
					
					dw_main.SetItem(li_CurRow, 'paygubun', 'B')
					dw_main.SetItem(li_CurRow, 'empno',    ls_EmpNo)
					dw_main.SetItem(li_CurRow, 'lendgbn',  ls_LendGbn)
					dw_main.SetItem(li_CurRow, 'lenddate', ls_LendDate)
					dw_main.SetItem(li_CurRow, 'retdate',  ls_BInsertRetDate)
					dw_main.SetItem(li_CurRow, 'rate', ld_Rate)
					
									
					ls_MonthCheck = String(Integer(ls_MonthCheck) + 1)
					IF Integer(ls_MonthCheck) > 12 THEN
						ls_MonthCheck = '01'
						ls_YearCheck = String(Long(ls_YearCheck) + 1)
					END IF
					
					DO UNTIL Integer(ls_MonthCheck) = Integer(M1) OR Integer(ls_MonthCheck) = Integer(M2) OR Integer(ls_MonthCheck) = Integer(M3) OR Integer(ls_MonthCheck) = Integer(M4) OR Integer(ls_MonthCheck) = Integer(M5) OR &
								Integer(ls_MonthCheck) = Integer(M6) OR Integer(ls_MonthCheck) = Integer(M7) OR Integer(ls_MonthCheck) = Integer(M8) OR Integer(ls_MonthCheck) = Integer(M9) OR Integer(ls_MonthCheck) = Integer(M10) OR &
								Integer(ls_MonthCheck) = Integer(M11) OR Integer(ls_MonthCheck) = Integer(M12) 
								
								ls_MonthCheck = String(Integer(ls_MonthCheck) + 1)
								IF Integer(ls_MonthCheck) > 12 THEN
									ls_MonthCheck = '01'
									ls_YearCheck = String(Long(ls_YearCheck) + 1)
								END IF
					LOOP
						
					ls_MonthCheck = String(Long(ls_MonthCheck),'00')
					ls_InsertBaseDate = ls_BInsertRetDate2 
					IF ls_BejaDay = '30' THEN 																	  
						ls_BInsertRetDate = F_Last_Date(ls_YearCheck + ls_MonthCheck)
						ls_BInsertRetDate2 = F_AfterMonth(Left(ls_BInsertRetDate, 6), 1) + String('01')
					ELSE																								 	
						ls_BInsertRetDate = ls_YearCheck + ls_MonthCheck + ls_BejaDay
						ls_BInsertRetDate2 = Left(ls_BInsertRetDate, 6) + String(Integer(ls_BejaDay) + 1, '00')
					END IF
			
				ELSE
					dw_main.SetItem(dw_main.RowCount(), 'janamt',   0) 
				END IF
				
				IF ls_brettag = '3' THEN
					ld_lendRemain = ld_lendRemain 
				ELSEIF ls_brettag = '2' THEN
					ld_lendRemain = ld_LendRemain - ld_MonthRetAmt
				ELSE
					IF ls_lendfrom = ls_lendfrom_eja THEN
						ld_LendRemain = ld_LendRemain - ld_MonthRetAmt
					ELSE
						ld_LendRemain = ld_LendRemain
						ls_LendFrom_eja = F_AfterMonth(ls_lendFrom_eja, 1)
					END IF 
				END IF	
				
			ELSE
		  		IF li_start = 1 THEN
					li_DayCnt = DaysAfter(Date(String(ls_InsertBaseDate, "@@@@.@@.@@")), Date(String(ls_LendEndDate, "@@@@.@@.@@"))) + 1
					li_DayCnt_Cash = 0
				END IF
				
				SELECT SUM(NVL(allretamt,0)), retdate 
				  INTO :ld_CashAmt, :ls_CashRetDate   
				  FROM p5_lendsch 		/* 상여일시상환자료 */
				 WHERE lendGbn = :ls_LendGbn AND
						 empno = :ls_EmpNo AND
						 lenddate = :ls_LendDate AND
						 lendkind = '1' AND
						 paygubun = 'X' AND
						 retdate >= :ls_InsertBaseDate and retdate < :ls_LendEndDate
				 GROUP BY retdate;
				IF Sqlca.SqlCode = 0 THEN
					IF IsNull(ld_CashAmt) then ld_CashAmt = 0
				ELSE
					ld_CashAmt = 0
				END IF
							
				IF ld_CashAmt <> 0 THEN // 일시상환이 있을경우
					li_DayCnt_cash = DaysAfter(Date(String(F_afterday(ls_InsertBaseDate, 1), "@@@@.@@.@@")), Date(String(ls_CashRetDate, "@@@@.@@.@@"))) + 1 //기준일로부터 일시상환일까지의 일수
					ld_LendEja_Cash = Truncate((ld_LendRemain * li_DayCnt_Cash / 365 * (ld_Rate / 100)),0) // 기준일부토 일시상환일까지의 이자.
					
					ld_LendRemain = ld_LendRemain - ld_CashAmt // 일시상환금을 빼고 남은돈.
					ls_CashRetDate = F_AfterDay(ls_CashRetDate, 1) // 상여일시상환일의 다음날
					li_DayCnt = DaysAfter(Date(String(ls_CashRetDate, "@@@@.@@.@@")), Date(String(ls_LendEndDate, "@@@@.@@.@@"))) + 1 // 일시상환일의 다음날부터 상여기준말일 까지의 일수				
				ELSE
					li_DayCnt_cash = 0
					ld_LendEja_Cash = 0
				END IF
													
				IF ls_RetGbn = '1' THEN //상환구분이 횟수일때
					IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
						IF ld_LendRemain >= ld_LendBamt2 THEN
							ld_MonthRetAmt = ld_LendBamt2	
						ELSE
							ld_MonthRetAmt = ld_LendRemain
						END IF
					ELSE
						ld_MonthRetAmt = 0
					END IF
				ELSEIF ls_RetGbn = '2' THEN //상환구분이 비율일때
					IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
						IF ld_LendRemain >= ld_LendBamt3 THEN
							ld_MonthRetAmt = ld_LendBamt3	
						ELSE
							ld_MonthRetAmt = ld_LendRemain
						END IF
					ELSE
						ld_MonthRetAmt = 0
					END IF
				ELSEIF ls_RetGbn = '3' THEN //상환구분이 금액일때
					IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
						IF ld_LendRemain >= ld_LendBamt THEN
							ld_MonthRetAmt = ld_LendBamt	
						ELSE
							ld_MonthRetAmt = ld_LendRemain
						END IF
					ELSE
						ld_MonthRetAmt = 0
					END IF
				END IF
				
				IF ld_LendRemain > 0 THEN
					li_CurRow = dw_main.insertrow(0)
					
					/*이자계산 : 일단위 버림*/
					ld_LendEja = ld_LendEja_Cash + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) 
					/*일수계산 : 누적 일수 */
					li_DayCnt2 = li_DayCnt + li_DayCnt_Cash
						
					dw_main.SetItem(dw_main.RowCount(), 'retamt', ld_LendRemain)
					dw_main.SetItem(li_CurRow, 'janamt',   0)
					IF ls_brettag = '2' THEN
						dw_main.SetItem(li_CurRow, 'reteja',   0)
						dw_main.SetItem(li_CurRow, 'ejaday',   0) 
					ELSE
						dw_main.SetItem(li_CurRow, 'reteja',   ld_LendEja)
						dw_main.SetItem(li_CurRow, 'ejaday',   li_DayCnt2) 
					END IF
					dw_main.SetItem(li_CurRow, 'paygubun', 'B')
					dw_main.SetItem(li_CurRow, 'empno',    ls_EmpNo)
					dw_main.SetItem(li_CurRow, 'lendgbn',  ls_LendGbn)
					dw_main.SetItem(li_CurRow, 'lenddate', ls_LendDate)
					dw_main.SetItem(li_CurRow, 'retdate',  ls_LendEndDate)
					dw_main.SetItem(li_CurRow, 'rate', ld_Rate)
				ELSE
					dw_main.SetItem(dw_main.RowCount(), 'janamt',   0) 
				END IF
				
				ld_lendRemain = 0 				
			END IF	
		li_start = 1							
		LOOP
	ELSE
		IF li_count = 0 THEN   // 상환된 자료가 있으면, 상환된날의 다음날부터 일수를 계산하여야 함.
			li_DayCnt = DaysAfter(Date(String(ls_CreateBaseDate, "@@@@.@@.@@")), Date(string(ls_LendEndDate, "@@@@.@@.@@"))) + 1 // 일자 계산
		ELSE
			li_DayCnt = DaysAfter(Date(String(F_afterday(ls_CreateBaseDate, 1), "@@@@.@@.@@")), Date(string(ls_LendEndDate, "@@@@.@@.@@"))) + 1 // 일자 계산
		END IF
		
		dw_main.SetReDraw(False)
		
		ls_InsertBaseDate = ls_CreateBaseDate
		ls_BInsertRetDate  = ls_BCreateDate
		ls_BInsertRetDate2 = ls_BCreateDate2
		li_start = 0 // 처음 로우 인지 아닌지 구분.
		
		
		DO UNTIL ld_LendRemain <= 0
		  ld_LendEja = 0
							
				SELECT SUM(NVL(allretamt,0)), retdate 
				  INTO :ld_CashAmt, :ls_CashRetDate   
				  FROM p5_lendsch 		/* 상여일시상환자료 */
				 WHERE lendGbn = :ls_LendGbn AND
						 empno = :ls_EmpNo AND
						 lenddate = :ls_LendDate AND
						 lendkind = '1' AND
						 paygubun = 'X' AND
						 retdate >= :ls_InsertBaseDate and retdate < :ls_LendEndDate
				 GROUP BY retdate;
				IF Sqlca.SqlCode = 0 THEN
					IF IsNull(ld_CashAmt) then ld_CashAmt = 0
				ELSE
					ld_CashAmt = 0
				END IF
							
				IF ld_CashAmt <> 0 THEN // 일시상환이 있을경우
					li_DayCnt_cash = DaysAfter(Date(String(F_afterday(ls_InsertBaseDate, 1), "@@@@.@@.@@")), Date(String(ls_CashRetDate, "@@@@.@@.@@"))) + 1 //기준일로부터 일시상환일까지의 일수
					ld_LendEja_Cash = Truncate((ld_LendRemain * li_DayCnt_Cash / 365 * (ld_Rate / 100)),0) // 기준일부토 일시상환일까지의 이자.
					
					ld_LendRemain = ld_LendRemain - ld_CashAmt // 일시상환금을 빼고 남은돈.
					ls_CashRetDate = F_AfterDay(ls_CashRetDate, 1) // 상여일시상환일의 다음날
					li_DayCnt = DaysAfter(Date(String(ls_CashRetDate, "@@@@.@@.@@")), Date(String(ls_LendEndDate, "@@@@.@@.@@"))) + 1 // 일시상환일의 다음날부터 상여기준말일 까지의 일수				
				ELSE
					li_DayCnt_cash = 0
					ld_LendEja_Cash = 0
				END IF
													
				IF ls_RetGbn = '1' THEN //상환구분이 횟수일때
					IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
						IF ld_LendRemain >= ld_LendBamt2 THEN
							ld_MonthRetAmt = ld_LendBamt2	
						ELSE
							ld_MonthRetAmt = ld_LendRemain
						END IF
					ELSE
						ld_MonthRetAmt = 0
					END IF
				ELSEIF ls_RetGbn = '2' THEN //상환구분이 비율일때
					IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
						IF ld_LendRemain >= ld_LendBamt3 THEN
							ld_MonthRetAmt = ld_LendBamt3	
						ELSE
							ld_MonthRetAmt = ld_LendRemain
						END IF
					ELSE
						ld_MonthRetAmt = 0
					END IF
				ELSEIF ls_RetGbn = '3' THEN //상환구분이 금액일때
					IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
						IF ld_LendRemain >= ld_LendBamt THEN
							ld_MonthRetAmt = ld_LendBamt	
						ELSE
							ld_MonthRetAmt = ld_LendRemain
						END IF
					ELSE
						ld_MonthRetAmt = 0
					END IF
				END IF
				
				IF ld_LendRemain > 0 THEN
					li_CurRow = dw_main.insertrow(0)
					
					/*이자계산 : 일단위 버림*/
					ld_LendEja = ld_LendEja_Cash + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) 
					/*일수계산 : 누적 일수 */
					li_DayCnt2 = li_DayCnt + li_DayCnt_Cash
						
					dw_main.SetItem(dw_main.RowCount(), 'retamt', ld_LendRemain)
					dw_main.SetItem(li_CurRow, 'janamt',   0)
					IF ls_brettag = '2' THEN
						dw_main.SetItem(li_CurRow, 'reteja',   0)
						dw_main.SetItem(li_CurRow, 'ejaday',   0) 
					ELSE
						dw_main.SetItem(li_CurRow, 'reteja',   ld_LendEja)
						dw_main.SetItem(li_CurRow, 'ejaday',   li_DayCnt2) 
					END IF
					
					dw_main.SetItem(li_CurRow, 'paygubun', 'B')
					dw_main.SetItem(li_CurRow, 'empno',    ls_EmpNo)
					dw_main.SetItem(li_CurRow, 'lendgbn',  ls_LendGbn)
					dw_main.SetItem(li_CurRow, 'lenddate', ls_LendDate)
					dw_main.SetItem(li_CurRow, 'retdate',  ls_LendEndDate)
					dw_main.SetItem(li_CurRow, 'rate', ld_Rate)
				ELSE
					dw_main.SetItem(dw_main.RowCount(), 'janamt',   0) 
				END IF
				
				ld_lendRemain = 0
		li_start = 1							
		LOOP
	END IF

end subroutine

public subroutine wf_calc_all (string m1, string m2, string m3, string m4, string m5, string m6, string m7, string m8, string m9, string m10, string m11, string m12);/* 급여 + 상여시 계산 로직 */
String ls_EmpNo, ls_LendDate, ls_LendGbn, ls_LendFrom, ls_LendFrom_eja, ls_RetGbn, ls_SubGbn, ls_PayGubun, ls_subdate1, ls_subdate2, ls_lendenddate
String ls_BretYn, ls_BejaDay, ls_BretTag, ls_PretYn, ls_PejaDay, ls_PretTag
String ls_CurMaxDate, ls_CreateBaseDate, ls_PCreateDate, ls_PCreateDate2, ls_PInsertRetDate, ls_InsertBaseDate, ls_PInsertRetDate2, ls_CurMaxDate2, ls_CurMaxDate3
String ls_YearCheck, ls_MonthCheck, ls_BCreateDate, ls_BCreateDate2, ls_BInsertRetDate, ls_CashRetDate, ls_BInsertRetDate2
Decimal ld_LendAmt, ld_LendMamt, ld_LendMamt2, ld_LendMamt3, ld_LendBamt, ld_LendBamt2, ld_LendBamt3, ld_Rate, ld_LendRemain, ld_CashAmt, ld_LendEja_Cash, ld_LendEja, ld_LendEja2, ld_MonthRetAmt, ld_lendeja_sub, ld_LendRemainsub
Long li_DayCnt, li_DayCnt2, li_PbGbn, li_DayCnt_cash, li_CurRow, li_Start, li_row, li_row2, li_subdaycnt, li_count

IF dw_sub.AcceptText() = -1 THEN Return 

ls_EmpNo    = dw_sub.GetItemString(dw_sub.GetRow(), 'empno')
ls_LendDate = dw_sub.GetItemString(dw_sub.GetRow(), 'lenddate')
ls_LendEndDate = dw_sub.GetItemString(dw_sub.GetRow(), 'lendenddate')
ls_LendGbn = dw_sub.GetItemString(dw_sub.GetRow(), 'lendGbn')
ls_LendFrom = dw_sub.GetItemString(dw_sub.GetRow(), 'lendfrom')
ls_LendFrom_Eja = dw_sub.GetItemString(dw_sub.GetRow(), 'lendfrom_eja')
ls_RetGbn = dw_sub.GetItemString(dw_sub.GetRow(), 'retgubun')

ls_BretYn = dw_sub.GetItemString(dw_sub.GetRow(), 'bretyn')
ls_BejaDay = dw_sub.GetItemString(dw_sub.GetRow(), 'bejaday')
ls_BretTag = dw_sub.GetItemString(dw_sub.GetRow(), 'brettag')
ls_PretYn = dw_sub.GetItemString(dw_sub.GetRow(), 'pretyn')
ls_PejaDay = dw_sub.GetItemString(dw_sub.GetRow(), 'pejaday')
ls_PretTag = dw_sub.GetItemString(dw_sub.GetRow(), 'prettag')

ls_PejaDay = String(Long(ls_PejaDay), '00')
ls_BejaDay = String(Long(ls_BejaDay), '00')

ld_LendAmt  = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendamt')
ld_LendMamt = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendmamt')
ld_LendBamt = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendBamt')
ld_Rate     = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'rate')

IF IsNull(ld_LendAmt) THEN ld_LendAmt = 0
IF IsNull(ld_LendMamt) THEN ld_LendMamt = 0
IF ld_lendmamt = 0 OR IsNull(ld_lendmamt) THEN 
	ld_LendMamt2 = 0
	ld_LendMamt3 = 0
ELSE
	ld_LendMamt2 = ld_LendAmt / ld_LendMamt				  // 상환구분이 횟수일때
   ld_LendMamt3 = (ld_LendAmt * ld_LendMamt) / 100      // 상환구분이 비율일때
END IF
IF IsNull(ld_Rate) THEN ld_Rate = 0

IF IsNull(ld_LendBamt) THEN ld_LendBamt = 0
IF ld_lendBamt = 0 OR IsNull(ld_lendBamt) THEN 
	ld_LendBamt2 = 0
	ld_LendBamt3 = 0
ELSE
	ld_LendBamt2 = ld_LendAmt / ld_LendBamt				  // 상환구분이 횟수일때
   ld_LendBamt3 = (ld_LendAmt * ld_LendBamt) / 100      // 상환구분이 비율일때
END IF

/* 상여생성월 check */ 
	IF M1 <> '1' OR IsNull(M1) THEN M1 = '00' ELSE M1 = '01'
	IF M2 <> '2' OR IsNull(M2) THEN M2 = '00' ELSE M2 = '02'
	IF M3 <> '3' OR IsNull(M3) THEN M3 = '00' ELSE M3 = '03'
	IF M4 <> '4' OR IsNull(M4) THEN M4 = '00' ELSE M4 = '04'
	IF M5 <> '5' OR IsNull(M5) THEN M5 = '00' ELSE M5 = '05'
	IF M6 <> '6' OR IsNull(M6) THEN M6 = '00' ELSE M6 = '06'
	IF M7 <> '7' OR IsNull(M7) THEN M7 = '00' ELSE M7 = '07'
	IF M8 <> '8' OR IsNull(M8) THEN M8 = '00' ELSE M8 = '08'
	IF M9 <> '9' OR IsNull(M9) THEN M9 = '00' ELSE M9 = '09'
	IF M10 <> '10' OR IsNull(M10) THEN M10 = '00' ELSE M10 = '10' 
	IF M11 <> '11' OR IsNull(M11) THEN M11 = '00' ELSE M11 = '11' 
	IF M12 <> '12' OR IsNull(M12) THEN M12 = '00' ELSE M12 = '12' 


/*상환자료 중 제일 최근 상환일자 - 급여, 상여내에서*/
	SELECT max(retdate)	
	  INTO :ls_CurMaxDate	
	  FROM p5_lendsch 
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND 
			 (paygubun like 'P' OR 
			  paygubun like 'B');
			 
			 
	IF Sqlca.SqlCode = 0 THEN
		IF IsNull(ls_CurMaxDate) THEN ls_CurMaxDate = '00000000'     
	ELSE
		ls_CurMaxDate = '00000000'
	END IF


/* 상환된 자료 */
SELECT count(retdate)
  INTO :li_row
  FROM p5_lendsch 
 WHERE lendgbn = :ls_LendGbn AND
		 empno = :ls_EmpNo AND 
		 lenddate = :ls_LendDate AND
		 lendkind = '1' AND
		 subgbn = 'Y' AND
		 paygubun LIKE '%';
		 
		 
/*최근상환일자/상환잔액 가져오기*/	
	IF dw_main.RowCount() <=0 THEN
		ld_LendRemain = ld_LendAmt			// 생성한 상환자료가 없을때..
		ls_CurMaxDate = '00000000'
	ELSE
		IF dw_main.GetItemString(li_row, 'paygubun' ) = 'X' THEN          // 생성한 상환자료가 있을때.. 마지막 행이 일시상환일 경우
			IF dw_main.RowCount() > 1 THEN											// 제일 처음 로우가 일시상환인경우 체크
				ls_CurMaxDate = dw_main.GetItemString(li_row - 1, "retdate")   // 처음 로우가 아니면 위의 상환날짜와 잔액 가져옴		
				ld_LendRemain = dw_main.GetItemNumber(li_row - 1, "janamt")
				IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
			ELSE
				ls_CurMaxDate = ls_lenddate   											// 처음 로우이면 대출일자와 대출금액을 가져옴.
				ld_LendRemain = ld_lendamt
				IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
			END IF
		ELSE
			ls_CurMaxDate = dw_main.GetItemString(li_row, "retdate")   //생성한 상환자료가 있을때...		
			ld_LendRemain = dw_main.GetItemNumber(li_row, "janamt")
			IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
		END IF

		/* 상환자료가 있을경우, 앞의 일자의 이자 */	
		IF dw_main.GetItemString(li_row, 'paygubun' ) <> dw_main.GetItemString(li_row - 1, 'paygubun' ) THEN
			ls_subdate1 = F_AfterDay(dw_main.GetItemString(li_row - 1, 'retdate' ), 1)
			ls_subdate2 = dw_main.GetItemString(li_row, 'retdate' )
			ld_LendRemainsub = dw_main.GetItemNumber(li_row - 1, 'janamt' )
			li_subDayCnt = DaysAfter(Date(String(ls_subdate1, "@@@@.@@.@@")), Date(string(ls_subdate2, "@@@@.@@.@@"))) + 1
			ld_LendEja_sub = Truncate((ld_LendRemainsub * li_subDayCnt / 365 * (ld_Rate / 100)),0)	
		ELSE
			li_subDayCnt = 0
			ld_LendEja_sub = 0
		END IF
		IF IsNull(li_subDayCnt) THEN li_subDayCnt = 0
	END IF

	ls_CurMaxDate3 = ls_CurMaxDate   // ls_CurMaxDate는 급여에서 사용. ls_CurMaxDate3는 상여에서 사용.
	


/* 상환자료 중 최근 상환일자 - 전체 */ 
	SELECT max(retdate)	
	  INTO :ls_CurMaxDate2	
	  FROM p5_lendsch 
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND 
			 paygubun like '%';
			 
			 
	IF Sqlca.SqlCode = 0 THEN
		IF IsNull(ls_CurMaxDate2) THEN ls_CurMaxDate2 = '00000000'     
	ELSE
		ls_CurMaxDate2 = '00000000'
	END IF


/* ls_CreateBaseDate는 생성기준일자(YYYYMMDD), ls_CurMaxDate는 ***급여*** 생성기준일자 이후 첫번째 달(YYYYMM) */
	IF ls_curmaxdate <> '00000000' THEN 						               // 생성한 상환자료가 있을때..
		ls_CreateBaseDate = ls_CurMaxDate                                // ls_CreateBaseDate에 가장 최근의 생성날짜를 저장.
	  	IF Long(Right(ls_CurMaxDate2, 2)) < Long(ls_PejaDay) THEN        // 가장 최근의 날짜가 급여기준일보다 작을경우
			ls_CurMaxDate = ls_CurMaxDate2										  // ls_CurMaxDate에 가장 최근상환일자를 저장.
			ls_LendFrom_Eja = ls_CurMaxDate										  // ls_LendFromEja는 거치기준일.
		ELSE
			ls_CurMaxDate = F_AfterMonth(Left(ls_CurMaxDate, 6), 1)           // ls_CurMaxDate에 ls_CurMaxDate의 한달후의 값을 저장.
			ls_LendFrom_Eja = ls_CurMaxDate
		END IF
	ELSE																						// 생성한 상환자료가 없을때..(즉, 처음 상환할 때)
		IF ls_prettag = '3' THEN
			ls_CreateBaseDate = ls_LendDate 												// ls_CreateBaseDate에 대출한 날짜를 저장.		
			ls_CurMaxDate = ls_LendFrom_eja													// ls_CurMaxDate에 상환시작달을 저장.
		ELSE
			ls_CreateBaseDate = ls_LendDate 												// ls_CreateBaseDate에 대출한 날짜를 저장.		
			ls_CurMaxDate = ls_LendFrom													// ls_CurMaxDate에 상환시작달을 저장.
		END IF
	END IF

	
/* 급여기준 일자 생성 */	
	IF ls_PejaDay = '30' THEN															// 급여기준일이 말일일때..																							
		ls_PCreateDate = F_Last_Date(ls_CurMaxDate)  							// ls_PCreateDate는 급여기준일자(일자는 말일)
		ls_PCreateDate2 = F_AfterMonth(Left(ls_PCreateDate, 6), 1) + String('01') // ls_PCreateDate2는 급여기준일자의 다음일자
	ELSE																						// 급여기준일이 말일이 아닐때..								
		ls_PCreateDate = Left(ls_CurMaxDate, 6) + ls_PejaDay					// ls_PCreateDate는 급여기준일자(일자는 선택한 일자)
		ls_PCreateDate2 = Left(ls_PCreateDate, 6) + String(Integer(ls_PejaDay) + 1, '00') 
	END IF
   
	
/* ls_CreateBaseDate는 생성기준일자(YYYYMMDD), ls_CurMaxDate는 ***상여*** 생성기준일자 이후 첫번째 달(YYYYMM) */
	IF ls_curmaxdate3 <> '00000000' THEN 						               // 생성한 상환자료가 있을때..
		ls_CreateBaseDate = ls_CurMaxDate3                                // ls_CreateBaseDate에 가장 최근의 생성날짜를 저장.
	  	IF Long(Right(ls_CurMaxDate2, 2)) < Long(ls_BejaDay) THEN 
			ls_CurMaxDate3 = ls_CurMaxDate2
			ls_LendFrom_Eja = ls_CurMaxDate3
		ELSE
			ls_CurMaxDate3 = F_AfterMonth(Left(ls_CurMaxDate3, 6), 1)           // ls_CurMaxDate3에 ls_CurMaxDate3의 한달후의 값을 저장.
			ls_LendFrom_Eja = ls_CurMaxDate3
		END IF
	ELSE																						// 생성한 상환자료가 없을때..(즉, 처음 상환할 때)
		IF ls_brettag = '3' THEN
			ls_CreateBaseDate = ls_LendDate 												// ls_CreateBaseDate에 대출한 날짜를 저장.		
			ls_CurMaxDate3 = ls_LendFrom_eja													// ls_CurMaxDate3에 상환시작달을 저장.
		ELSE 
			ls_CreateBaseDate = ls_LendDate 												// ls_CreateBaseDate에 대출한 날짜를 저장.		
			ls_CurMaxDate3 = ls_LendFrom													// ls_CurMaxDate3에 상환시작달을 저장.
		END IF
	END IF	
	
	
/* 상여기준 일자 생성 */	
	ls_YearCheck = Left(ls_CurMaxDate3, 4) 
	ls_MonthCheck = Mid(ls_CurMaxDate3, 5, 2)
		
	DO UNTIL Integer(ls_MonthCheck) = Integer(M1) OR Integer(ls_MonthCheck) = Integer(M2) OR Integer(ls_MonthCheck) = Integer(M3) OR Integer(ls_MonthCheck) = Integer(M4) OR Integer(ls_MonthCheck) = Integer(M5) OR &
				Integer(ls_MonthCheck) = Integer(M6) OR Integer(ls_MonthCheck) = Integer(M7) OR Integer(ls_MonthCheck) = Integer(M8) OR Integer(ls_MonthCheck) = Integer(M9) OR Integer(ls_MonthCheck) = Integer(M10) OR &
				Integer(ls_MonthCheck) = Integer(M11) OR Integer(ls_MonthCheck) = Integer(M12) 
				
				ls_MonthCheck = String(Integer(ls_MonthCheck) + 1)
				IF Integer(ls_MonthCheck) > 12 THEN
					ls_MonthCheck = '01'
					ls_YearCheck = String(Long(ls_YearCheck) + 1)
				END IF
	LOOP
					
	ls_MonthCheck = String(Long(ls_MonthCheck),'00')   // ls_MonthCheck의 형식을 두자리로 만들어 줌.
			
	IF ls_BejaDay = '30' THEN 																	  // 상여기준일이 말일일때..
		ls_BCreateDate = F_Last_Date(ls_YearCheck + ls_MonthCheck)					  // ls_BCreateDate는 상여기준일자(일자는 말일)
		ls_BCreateDate2 = F_AfterMonth(Left(ls_BCreateDate, 6), 1) + String('01') // ls_BCreateDate2는 급여기준일자의 다음일자
	ELSE																								  // 상여기준일이 말일이 아닐때..	
		ls_BCreateDate = ls_YearCheck + ls_MonthCheck + ls_BejaDay				  // ls_BCreateDate는 상여기준일자(일자는 선택한 일자)
		ls_BCreateDate2 = Left(ls_BCreateDate, 6) + String(Integer(ls_BejaDay) + 1, '00')
	END IF


/* 처음 로우 일수 계산 */
//   IF li_subDayCnt <> 0 THEN ls_CreateBaseDate = F_AfterDay(ls_CreateBaseDate, 1)
	IF li_Row <> 0 THEN ls_CreateBaseDate = F_AfterDay(ls_CreateBaseDate, 1)
	IF Long(ls_lendenddate) > Long(Min(Long(ls_BCreateDate), Long(ls_PCreateDate))) OR IsNull(ls_LendEndDate) OR ls_LendEndDate = '' THEN // 상환종료일자와 비교후 마지막 로우에 원금 전부 상환여부 체크
			IF Long(ls_BCreateDate) < Long(ls_PCreateDate) THEN
				li_DayCnt = DaysAfter(Date(String(ls_CreateBaseDate, "@@@@.@@.@@")), Date(string(ls_BCreateDate, "@@@@.@@.@@"))) + 1 // 일자 계산
				li_DayCnt2 = 0 // 누적되는 일자 계산
				li_PbGbn = 1  // 상여계산(급상여 구분) 
			ELSE
				li_DayCnt = DaysAfter(Date(String(ls_CreateBaseDate, "@@@@.@@.@@")), Date(string(ls_PCreateDate, "@@@@.@@.@@"))) + 1
				li_DayCnt2 = 0
				li_Pbgbn = 0 // 급여계산(급상여 구분)
			END IF
			dw_main.SetReDraw(False)
			ls_CreateBaseDate = F_AfterDay(ls_CreateBaseDate, -1)
			
			ls_InsertBaseDate = ls_CreateBaseDate		
			ls_PInsertRetDate = ls_PCreateDate
			ls_PInsertRetDate2 = ls_PCreateDate2
			ls_BInsertRetDate  = ls_BCreateDate
			ls_BInsertRetDate2 = ls_BCreateDate2
			li_start = 0 // 처음 로우 인지 아닌지 구분.
			ld_LendEja2 = 0 // 누적되는 이자
				
		
			DO UNTIL ld_LendRemain <= 0
				ld_LendEja = 0
		
				IF li_Pbgbn <> 0 THEN // 상여일때
					IF Long(ls_lendenddate) > Long(ls_BInsertRetDate) OR IsNull(ls_LendEndDate) OR ls_LendEndDate = '' THEN
							IF li_start = 1 THEN
								li_DayCnt = DaysAfter(Date(String(ls_InsertBaseDate, "@@@@.@@.@@")), Date(String(ls_BInsertRetDate, "@@@@.@@.@@"))) + 1
								li_DayCnt_Cash = 0
							END IF
							
							SELECT SUM(NVL(allretamt,0)), retdate 
							  INTO :ld_CashAmt, :ls_CashRetDate   
							  FROM p5_lendsch 		/* 상여일시상환자료 */
							 WHERE lendGbn = :ls_LendGbn AND
									 empno = :ls_EmpNo AND
									 lenddate = :ls_LendDate AND
									 lendkind = '1' AND
									 paygubun = 'X' AND
									 retdate >= :ls_InsertBaseDate and retdate < :ls_BInsertRetDate
							 GROUP BY retdate;
							IF Sqlca.SqlCode = 0 THEN
								IF IsNull(ld_CashAmt) then ld_CashAmt = 0
							ELSE
								ld_CashAmt = 0
							END IF
										
							IF ld_CashAmt <> 0 THEN // 일시상환이 있을경우
								li_DayCnt_cash = DaysAfter(Date(String(F_afterday(ls_InsertBaseDate, 1), "@@@@.@@.@@")), Date(String(ls_CashRetDate, "@@@@.@@.@@"))) + 1 //기준일로부터 일시상환일까지의 일수
								ld_LendEja_Cash = Truncate((ld_LendRemain * li_DayCnt_Cash / 365 * (ld_Rate / 100)),0) // 기준일부토 일시상환일까지의 이자.
								
								ld_LendRemain = ld_LendRemain - ld_CashAmt // 일시상환금을 빼고 남은돈.
								ls_CashRetDate = F_AfterDay(ls_CashRetDate, 1) // 상여일시상환일의 다음날
								li_DayCnt = DaysAfter(Date(String(ls_CashRetDate, "@@@@.@@.@@")), Date(String(ls_BInsertRetDate, "@@@@.@@.@@"))) + 1 // 일시상환일의 다음날부터 상여기준말일 까지의 일수				
								li_subDayCnt = 0
								ld_LendEja_sub = 0
							ELSE
								li_DayCnt_cash = 0
								ld_LendEja_Cash = 0
							END IF
																
							IF ls_RetGbn = '1' THEN //상환구분이 횟수일때
								IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendBamt2 THEN
										ld_MonthRetAmt = ld_LendBamt2	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							ELSEIF ls_RetGbn = '2' THEN //상환구분이 비율일때
								IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendBamt3 THEN
										ld_MonthRetAmt = ld_LendBamt3	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							ELSEIF ls_RetGbn = '3' THEN //상환구분이 금액일때
								IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendBamt THEN
										ld_MonthRetAmt = ld_LendBamt	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							END IF
							
							IF ld_LendRemain > 0 THEN
								li_CurRow = dw_main.insertrow(0)
								
								/*이자계산 : 일단위 버림*/
								ld_LendEja = ld_LendEja_Cash + ld_LendEja_sub + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) 
								/*이자계산 : 누계 이자 */
								ld_LendEja2 = ld_LendEja2 + ld_LendEja
								/*일수계산 : 누적 일수 */
								li_DayCnt2 = li_DayCnt2 + li_DayCnt + li_DayCnt_Cash + li_subDayCnt
								
								ld_LendEja_sub = 0
								li_SubDayCnt = 0
								
								IF ls_brettag = '2' THEN
									IF ld_LendRemain > ld_MonthRetAmt THEN          // 마지막 로우의 이자 계산. 남은 돈이 한달에 갚을 돈보다 큰 경우엔						
										dw_main.SetItem(li_CurRow, 'reteja', 0)		// 마지막 로우가 아님.
										dw_main.SetItem(li_CurRow, 'ejaday', 0)
									ELSE															// 작거나 같을경우엔, 마지막 로우가 됨.
										dw_main.SetItem(li_CurRow, 'reteja', ld_LendEja2)
										dw_main.SetItem(li_CurRow, 'ejaday', li_DayCnt2)
									END IF
									
									IF Long(ls_lendfrom) <= Long(ls_lendfrom_eja) THEN
										dw_main.SetItem(li_CurRow, 'janamt',   ld_LendRemain - ld_MonthRetAmt)
										dw_main.SetItem(li_CurRow, 'retamt',   ld_MonthRetAmt)
									ELSE
										dw_main.SetItem(li_CurRow, 'janamt', ld_LendRemain)
										dw_main.SetItem(li_CurRow, 'retamt', 0)
									END IF
														
								ELSEIF ls_brettag = '3' THEN
									dw_main.SetItem(li_CurRow, 'reteja', ld_LendEja2)
									ld_LendEja2 = 0
									dw_main.SetItem(li_CurRow, 'ejaday', li_DayCnt2)
									li_DayCnt2 = 0
									dw_main.SetItem(li_currow, 'retamt', 0)
									dw_main.SetItem(li_CurRow, 'janamt', ld_LendRemain)
								ELSE 
									dw_main.SetItem(li_CurRow, 'reteja', ld_LendEja2)
									ld_LendEja2 = 0
									dw_main.SetItem(li_CurRow, 'ejaday', li_DayCnt2)
									li_DayCnt2 = 0
//									dw_main.SetItem(li_CurRow, 'janamt',   ld_LendRemain - ld_MonthRetAmt)
//									dw_main.SetItem(li_CurRow, 'retamt',   ld_MonthRetAmt)
									IF Long(ls_lendfrom) <= Long(ls_lendfrom_eja) THEN
										dw_main.SetItem(li_CurRow, 'janamt',   ld_LendRemain - ld_MonthRetAmt)
										dw_main.SetItem(li_CurRow, 'retamt',   ld_MonthRetAmt)
									ELSE
										dw_main.SetItem(li_CurRow, 'janamt', ld_LendRemain)
										dw_main.SetItem(li_CurRow, 'retamt', 0)
									END IF
								END IF
												
								dw_main.SetItem(li_CurRow, 'paygubun', 'B')
								dw_main.SetItem(li_CurRow, 'empno',    ls_EmpNo)
								dw_main.SetItem(li_CurRow, 'lendgbn',  ls_LendGbn)
								dw_main.SetItem(li_CurRow, 'lenddate', ls_LendDate)
								dw_main.SetItem(li_CurRow, 'retdate',  ls_BInsertRetDate)
								dw_main.SetItem(li_CurRow, 'rate', ld_Rate)
								
								ls_MonthCheck = String(Integer(ls_MonthCheck) + 1)
								IF Integer(ls_MonthCheck) > 12 THEN
									ls_MonthCheck = '01'
									ls_YearCheck = String(Long(ls_YearCheck) + 1)
								END IF
								
								DO UNTIL Integer(ls_MonthCheck) = Integer(M1) OR Integer(ls_MonthCheck) = Integer(M2) OR Integer(ls_MonthCheck) = Integer(M3) OR Integer(ls_MonthCheck) = Integer(M4) OR Integer(ls_MonthCheck) = Integer(M5) OR &
											Integer(ls_MonthCheck) = Integer(M6) OR Integer(ls_MonthCheck) = Integer(M7) OR Integer(ls_MonthCheck) = Integer(M8) OR Integer(ls_MonthCheck) = Integer(M9) OR Integer(ls_MonthCheck) = Integer(M10) OR &
											Integer(ls_MonthCheck) = Integer(M11) OR Integer(ls_MonthCheck) = Integer(M12) 
											
											ls_MonthCheck = String(Integer(ls_MonthCheck) + 1)
											IF Integer(ls_MonthCheck) > 12 THEN
												ls_MonthCheck = '01'
												ls_YearCheck = String(Long(ls_YearCheck) + 1)
											END IF
								LOOP
									
								ls_MonthCheck = String(Long(ls_MonthCheck),'00')
								ls_InsertBaseDate = ls_BInsertRetDate2 
								IF ls_BejaDay = '30' THEN 																	  
									ls_BInsertRetDate = F_Last_Date(ls_YearCheck + ls_MonthCheck)
									ls_BInsertRetDate2 = F_AfterMonth(Left(ls_BInsertRetDate, 6), 1) + String('01')
								ELSE																								 	
									ls_BInsertRetDate = ls_YearCheck + ls_MonthCheck + ls_BejaDay
									ls_BInsertRetDate2 = Left(ls_BInsertRetDate, 6) + String(Integer(ls_BejaDay) + 1, '00')
								END IF
								
								li_Pbgbn = 0
									
							ELSE
								dw_main.SetItem(dw_main.RowCount(), 'janamt',   0) 
							END IF
							
							IF ls_brettag = '3' THEN
								ld_MonthRetAmt = 0
								ld_lendRemain = ld_lendRemain
								ls_LendFrom_eja = F_AfterMonth(ls_lendFrom_eja, 1)
							ELSEIF ls_brettag = '2' THEN
								IF Long(ls_lendfrom) <= Long(ls_lendfrom_eja) THEN
									ld_LendRemain = ld_LendRemain - ld_MonthRetAmt
								ELSE
									ld_LendRemain = ld_LendRemain
									ls_LendFrom_eja = F_AfterMonth(ls_lendFrom_eja, 1)
								END IF 
							ELSE
								ld_lendRemain = ld_lendRemain - ld_MonthRetAmt
								ls_LendFrom_eja = F_AfterMonth(ls_lendFrom_eja, 1)
							END IF
					ELSE
							IF li_start = 1 THEN
								li_DayCnt = DaysAfter(Date(String(ls_InsertBaseDate, "@@@@.@@.@@")), Date(String(ls_LendEndDate, "@@@@.@@.@@"))) + 1
								li_DayCnt_Cash = 0
							END IF
							
							SELECT SUM(NVL(allretamt,0)), retdate 
							  INTO :ld_CashAmt, :ls_CashRetDate   
							  FROM p5_lendsch 		/* 상여일시상환자료 */
							 WHERE lendGbn = :ls_LendGbn AND
									 empno = :ls_EmpNo AND
									 lenddate = :ls_LendDate AND
									 lendkind = '1' AND
									 paygubun = 'X' AND
									 retdate >= :ls_InsertBaseDate and retdate < :ls_LendEndDate
							 GROUP BY retdate;
							IF Sqlca.SqlCode = 0 THEN
								IF IsNull(ld_CashAmt) then ld_CashAmt = 0
							ELSE
								ld_CashAmt = 0
							END IF
										
							IF ld_CashAmt <> 0 THEN // 일시상환이 있을경우
								li_DayCnt_cash = DaysAfter(Date(String(F_afterday(ls_InsertBaseDate, 1), "@@@@.@@.@@")), Date(String(ls_CashRetDate, "@@@@.@@.@@"))) + 1 //기준일로부터 일시상환일까지의 일수
								ld_LendEja_Cash = Truncate((ld_LendRemain * li_DayCnt_Cash / 365 * (ld_Rate / 100)),0) // 기준일부토 일시상환일까지의 이자.
								
								ld_LendRemain = ld_LendRemain - ld_CashAmt // 일시상환금을 빼고 남은돈.
								ls_CashRetDate = F_AfterDay(ls_CashRetDate, 1) // 상여일시상환일의 다음날
								li_DayCnt = DaysAfter(Date(String(ls_CashRetDate, "@@@@.@@.@@")), Date(String(ls_LendEndDate, "@@@@.@@.@@"))) + 1 // 일시상환일의 다음날부터 상여기준말일 까지의 일수				
								li_subDayCnt = 0
								ld_LendEja_sub = 0
							ELSE
								li_DayCnt_cash = 0
								ld_LendEja_Cash = 0
							END IF
																
							IF ls_RetGbn = '1' THEN //상환구분이 횟수일때
								IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendBamt2 THEN
										ld_MonthRetAmt = ld_LendBamt2	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							ELSEIF ls_RetGbn = '2' THEN //상환구분이 비율일때
								IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendBamt3 THEN
										ld_MonthRetAmt = ld_LendBamt3	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							ELSEIF ls_RetGbn = '3' THEN //상환구분이 금액일때
								IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendBamt THEN
										ld_MonthRetAmt = ld_LendBamt	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							END IF
							
							IF ld_LendRemain > 0 THEN
								li_CurRow = dw_main.insertrow(0)
								
								/*이자계산 : 일단위 버림*/
								ld_LendEja = ld_LendEja_Cash + ld_LendEja_sub + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) 
								/*이자계산 : 누계 이자 */
								ld_LendEja2 = ld_LendEja2 + ld_LendEja
								/*일수계산 : 누적 일수 */
								li_DayCnt2 = li_DayCnt2 + li_DayCnt + li_DayCnt_Cash + li_subDayCnt
								
								ld_LendEja_sub = 0
								li_SubDayCnt = 0
																
								dw_main.SetItem(dw_main.RowCount(), 'retamt', ld_LendRemain)
								dw_main.SetItem(li_CurRow, 'janamt',   0)
								IF ls_brettag = '2' THEN
									dw_main.SetItem(li_CurRow, 'reteja',   0)
									dw_main.SetItem(li_CurRow, 'ejaday',   0) 
								ELSE
									dw_main.SetItem(li_CurRow, 'reteja',   ld_LendEja)
									dw_main.SetItem(li_CurRow, 'ejaday',   li_DayCnt2) 
								END IF
								IF ls_brettag = '2' and ls_prettag = '3' THEN
									dw_main.SetItem(li_CurRow, 'paygubun', 'B')
								ELSEIF ls_brettag = '3' and ls_prettag = '2' THEN
									dw_main.SetItem(li_CurRow, 'paygubun', 'P')
								END IF
								
								dw_main.SetItem(li_CurRow, 'empno',    ls_EmpNo)
								dw_main.SetItem(li_CurRow, 'lendgbn',  ls_LendGbn)
								dw_main.SetItem(li_CurRow, 'lenddate', ls_LendDate)
								dw_main.SetItem(li_CurRow, 'retdate',  ls_LendEndDate)
								dw_main.SetItem(li_CurRow, 'rate', ld_Rate)
														
							ELSE
								dw_main.SetItem(dw_main.RowCount(), 'janamt',   0) 
							END IF
							
							ld_lendRemain = 0													
					END IF
					li_start = 1	
						 						 
				ELSE			//여기서 부터 급여계산
					IF Long(ls_lendenddate) > Long(ls_PInsertRetDate) OR IsNull(ls_LendEndDate) OR ls_LendEndDate = '' THEN
							IF li_start = 1 THEN
								li_DayCnt = DaysAfter(Date(String(ls_InsertBaseDate, "@@@@.@@.@@")), Date(String(ls_PInsertRetDate, "@@@@.@@.@@"))) + 1
								li_DayCnt_Cash = 0
							END IF
							
							SELECT sum(nvl(allretamt,0)), retdate 
							  INTO :ld_CashAmt, :ls_CashRetDate   
							  FROM p5_lendsch 		/*급여일시상환자료*/
							 WHERE lendkind = '1' AND
									 lendGbn = :ls_LendGbn AND
									 empno = :ls_EmpNo AND
									 lenddate = :ls_LendDate AND
									 paygubun = 'X' AND
									 retdate >= :ls_InsertBaseDate and retdate < :ls_PInsertRetDate
							 GROUP BY retdate;
							IF Sqlca.SqlCode = 0 THEN
								IF IsNull(ld_CashAmt) then ld_CashAmt = 0
							ELSE
								ld_CashAmt = 0
							END IF			
							
							IF ld_CashAmt <> 0 THEN // 일시상환이 있을경우
								li_DayCnt_cash = DaysAfter(Date(String(F_AfterDay(ls_InsertBaseDate, 1), "@@@@.@@.@@")), Date(String(ls_CashRetDate, "@@@@.@@.@@"))) + 1 //기준일로부터 일시상환일까지의 일수
								ld_LendEja_Cash = Truncate((ld_LendRemain * li_DayCnt_Cash / 365 * (ld_Rate / 100)),0) // 기준일부토 일시상환일까지의 이자.
								
								ld_LendRemain = ld_LendRemain - ld_CashAmt // 일시상환금을 빼고 남은돈.
								ls_CashRetDate = F_AfterDay(ls_CashRetDate, 1) // 상여일시상환일의 다음날
								li_DayCnt = DaysAfter(Date(String(ls_CashRetDate, "@@@@.@@.@@")), Date(String(ls_PInsertRetDate, "@@@@.@@.@@"))) + 1 // 일시상환일의 다음날부터 상여기준말일 까지의 일수				
								li_subDayCnt = 0
								ld_LendEja_sub = 0
							ELSE
								li_DayCnt_cash = 0
								ld_LendEja_Cash = 0
							END IF
							
							IF ls_RetGbn = '1' THEN //상환구분이 횟수일때
								IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendMamt2 THEN
										ld_MonthRetAmt = ld_LendMamt2	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							ELSEIF ls_RetGbn = '2' THEN //상환구분이 비율일때
								IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendMamt3 THEN
										ld_MonthRetAmt = ld_LendMamt3	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							ELSEIF ls_RetGbn = '3' THEN //상환구분이 금액일때
								IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendMamt THEN
										ld_MonthRetAmt = ld_LendMamt	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							END IF
						
				
							IF ld_LendRemain > 0 THEN
								li_CurRow = dw_main.insertrow(0)
										
								/*이자계산 : 일단위 버림*/
								ld_LendEja = ld_LendEja_Cash + ld_LendEja_sub + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) 
								/*이자계산 : 누계 이자 */
								ld_LendEja2 = ld_LendEja2 + ld_LendEja
								/*일수계산 : 누적 일수 */
								li_DayCnt2 = li_DayCnt2 + li_DayCnt + li_DayCnt_Cash + li_subDayCnt
								
								ld_LendEja_sub = 0
								li_SubDayCnt = 0
				
								IF ls_prettag = '2' THEN
									IF ld_LendRemain > ld_MonthRetAmt THEN
										dw_main.SetItem(li_CurRow, 'reteja', 0)
										dw_main.SetItem(li_CurRow, 'ejaday', 0)
									ELSE
										dw_main.SetItem(li_CurRow, 'reteja', ld_LendEja2)
										dw_main.SetItem(li_CurRow, 'ejaday', li_DayCnt2)
									END IF
									
									IF Long(ls_lendfrom) <= Long(ls_lendfrom_eja) THEN
										dw_main.SetItem(li_CurRow, 'janamt',   ld_LendRemain - ld_MonthRetAmt)
										dw_main.SetItem(li_CurRow, 'retamt',   ld_MonthRetAmt)
									ELSE
										dw_main.SetItem(li_CurRow, 'janamt', ld_LendRemain)
										dw_main.SetItem(li_CurRow, 'retamt', 0)
									END IF
									
								ELSEIF ls_prettag = '3' THEN
									dw_main.SetItem(li_CurRow, 'reteja', ld_LendEja2)
									ld_LendEja2 = 0
									dw_main.SetItem(li_CurRow, 'ejaday', li_DayCnt2)
									li_DayCnt2 = 0
									dw_main.SetItem(li_currow, 'retamt', 0)
									dw_main.SetItem(li_CurRow, 'janamt', ld_LendRemain)
								ELSE
									dw_main.SetItem(li_CurRow, 'reteja', ld_LendEja2)
									ld_LendEja2 = 0
									dw_main.SetItem(li_CurRow, 'ejaday', li_DayCnt2)
									li_DayCnt2 = 0
//									dw_main.SetItem(li_CurRow, 'janamt',   ld_LendRemain - ld_MonthRetAmt)
//									dw_main.SetItem(li_CurRow, 'retamt',   ld_MonthRetAmt)
									IF Long(ls_lendfrom) <= Long(ls_lendfrom_eja) THEN
										dw_main.SetItem(li_CurRow, 'janamt',   ld_LendRemain - ld_MonthRetAmt)
										dw_main.SetItem(li_CurRow, 'retamt',   ld_MonthRetAmt)
									ELSE
										dw_main.SetItem(li_CurRow, 'janamt', ld_LendRemain)
										dw_main.SetItem(li_CurRow, 'retamt', 0)
									END IF									
								END IF
														
								dw_main.SetItem(li_CurRow, 'paygubun', 'P')
								dw_main.SetItem(li_CurRow, 'empno',    ls_EmpNo)
								dw_main.SetItem(li_CurRow, 'lendgbn',  ls_LendGbn)
								dw_main.SetItem(li_CurRow, 'lenddate', ls_LendDate)
								dw_main.SetItem(li_CurRow, 'retdate',  ls_PInsertRetDate)
								dw_main.SetItem(li_CurRow, 'rate', ld_Rate)
								
								
								ls_InsertBaseDate = ls_PInsertRetDate2 
								IF ls_PejaDay = '30' THEN																																			
									ls_PInsertRetDate = F_Last_Date(F_AfterMonth(Left(ls_PInsertRetDate, 6), 1))
									ls_PInsertRetDate2 = F_AfterMonth(Left(ls_PInsertRetDate, 6), 1) + String('01') 
								ELSE																					
									ls_PInsertRetDate = F_AfterMonth(Left(ls_PInsertRetDate, 6), 1) + ls_PejaDay				
									ls_PInsertRetDate2 = Left(ls_PInsertRetDate, 6) + String(Integer(ls_PejaDay) + 1, '00') 
								END IF
								
								IF Long(ls_PInsertRetDate) > Long(ls_BInsertRetDate) THEN
									li_Pbgbn = 1
								ELSE
									li_Pbgbn = 0
								END IF
								
							ELSE
								dw_main.SetItem(dw_main.RowCount(), 'janamt',   0) 
							END IF
						
							IF ls_prettag = '3' THEN
								ld_MonthRetAmt = 0
								ld_lendRemain = ld_lendRemain									
								ls_LendFrom_eja = F_AfterMonth(ls_lendFrom_eja, 1)
							ELSEIF ls_prettag = '2' THEN
								IF Long(ls_lendfrom) <= Long(ls_lendfrom_eja) THEN
									ld_LendRemain = ld_LendRemain - ld_MonthRetAmt
								ELSE
									ld_LendRemain = ld_LendRemain
									ls_LendFrom_eja = F_AfterMonth(ls_lendFrom_eja, 1)
								END IF 
							ELSE 
								ld_lendRemain = ld_lendRemain - ld_MonthRetAmt
								ls_LendFrom_eja = F_AfterMonth(ls_lendFrom_eja, 1)
							END IF		
		
					ELSE
						   IF li_start = 1 THEN
								li_DayCnt = DaysAfter(Date(String(ls_InsertBaseDate, "@@@@.@@.@@")), Date(String(ls_LendEndDate, "@@@@.@@.@@"))) + 1
								li_DayCnt_Cash = 0
							END IF
							
							SELECT sum(nvl(allretamt,0)), retdate 
							  INTO :ld_CashAmt, :ls_CashRetDate   
							  FROM p5_lendsch 		/*급여일시상환자료*/
							 WHERE lendkind = '1' AND
									 lendGbn = :ls_LendGbn AND
									 empno = :ls_EmpNo AND
									 lenddate = :ls_LendDate AND
									 paygubun = 'X' AND
									 retdate >= :ls_InsertBaseDate and retdate < :ls_LendEndDate
							 GROUP BY retdate;
							IF Sqlca.SqlCode = 0 THEN
								IF IsNull(ld_CashAmt) then ld_CashAmt = 0
							ELSE
								ld_CashAmt = 0
							END IF			
							
							IF ld_CashAmt <> 0 THEN // 일시상환이 있을경우
								li_DayCnt_cash = DaysAfter(Date(String(F_AfterDay(ls_InsertBaseDate, 1), "@@@@.@@.@@")), Date(String(ls_CashRetDate, "@@@@.@@.@@"))) + 1 //기준일로부터 일시상환일까지의 일수
								ld_LendEja_Cash = Truncate((ld_LendRemain * li_DayCnt_Cash / 365 * (ld_Rate / 100)),0) // 기준일부토 일시상환일까지의 이자.
								
								ld_LendRemain = ld_LendRemain - ld_CashAmt // 일시상환금을 빼고 남은돈.
								ls_CashRetDate = F_AfterDay(ls_CashRetDate, 1) // 상여일시상환일의 다음날
								li_DayCnt = DaysAfter(Date(String(ls_CashRetDate, "@@@@.@@.@@")), Date(String(ls_LendEndDate, "@@@@.@@.@@"))) + 1 // 일시상환일의 다음날부터 상여기준말일 까지의 일수				
								li_subDayCnt = 0
								ld_LendEja_sub = 0
							ELSE
								li_DayCnt_cash = 0
								ld_LendEja_Cash = 0
							END IF
							
							IF ls_RetGbn = '1' THEN //상환구분이 횟수일때
								IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendMamt2 THEN
										ld_MonthRetAmt = ld_LendMamt2	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							ELSEIF ls_RetGbn = '2' THEN //상환구분이 비율일때
								IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendMamt3 THEN
										ld_MonthRetAmt = ld_LendMamt3	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							ELSEIF ls_RetGbn = '3' THEN //상환구분이 금액일때
								IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
									IF ld_LendRemain >= ld_LendMamt THEN
										ld_MonthRetAmt = ld_LendMamt	
									ELSE
										ld_MonthRetAmt = ld_LendRemain
									END IF
								ELSE
									ld_MonthRetAmt = 0
								END IF
							END IF
						
				
							IF ld_LendRemain > 0 THEN
								li_CurRow = dw_main.insertrow(0)
										
								/*이자계산 : 일단위 버림*/
								ld_LendEja = ld_LendEja_Cash + ld_LendEja_sub + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) 
								/*이자계산 : 누계 이자 */
								ld_LendEja2 = ld_LendEja2 + ld_LendEja
								/*일수계산 : 누적 일수 */
								li_DayCnt2 = li_DayCnt2 + li_DayCnt + li_DayCnt_Cash + li_subDayCnt
								
								ld_LendEja_sub = 0
								li_SubDayCnt = 0
				
								dw_main.SetItem(dw_main.RowCount(), 'retamt', ld_LendRemain)
								dw_main.SetItem(li_CurRow, 'janamt',   0)
								IF ls_prettag = '2' THEN
									dw_main.SetItem(li_CurRow, 'reteja',   0)
									dw_main.SetItem(li_CurRow, 'ejaday',   0) 
								ELSE
									dw_main.SetItem(li_CurRow, 'reteja',   ld_LendEja)
									dw_main.SetItem(li_CurRow, 'ejaday',   li_DayCnt2) 
								END IF
								IF ls_brettag = '2' and ls_prettag = '3' THEN
									dw_main.SetItem(li_CurRow, 'paygubun', 'B')
								ELSEIF ls_brettag = '3' and ls_prettag = '2' THEN
									dw_main.SetItem(li_CurRow, 'paygubun', 'P')
								END IF
								dw_main.SetItem(li_CurRow, 'empno',    ls_EmpNo)
								dw_main.SetItem(li_CurRow, 'lendgbn',  ls_LendGbn)
								dw_main.SetItem(li_CurRow, 'lenddate', ls_LendDate)
								dw_main.SetItem(li_CurRow, 'retdate',  ls_LendEndDate)
								dw_main.SetItem(li_CurRow, 'rate', ld_Rate)
																
							ELSE
								dw_main.SetItem(dw_main.RowCount(), 'janamt',   0) 
							END IF
						
							ld_lendRemain = 0
					END IF
					li_start = 1
				END IF
			LOOP

	ELSE
			IF ls_brettag = '2' and ls_prettag = '3' THEN
				li_DayCnt = DaysAfter(Date(String(ls_CreateBaseDate, "@@@@.@@.@@")), Date(string(ls_LendEndDate, "@@@@.@@.@@"))) + 1 // 일자 계산
				li_DayCnt2 = 0 // 누적되는 일자 계산
				li_PbGbn = 1  // 상여계산(급상여 구분) 
			ELSEIF ls_brettag = '3' and ls_prettag = '2' THEN
				li_DayCnt = DaysAfter(Date(String(ls_CreateBaseDate, "@@@@.@@.@@")), Date(string(ls_LendEndDate, "@@@@.@@.@@"))) + 1
				li_DayCnt2 = 0
				li_Pbgbn = 0 // 급여계산(급상여 구분)
			END IF
			dw_main.SetReDraw(False)
			ls_CreateBaseDate = F_AfterDay(ls_CreateBaseDate, -1)
				
			ls_InsertBaseDate = ls_CreateBaseDate		
			ls_PInsertRetDate = ls_PCreateDate
			ls_PInsertRetDate2 = ls_PCreateDate2
			ls_BInsertRetDate  = ls_BCreateDate
			ls_BInsertRetDate2 = ls_BCreateDate2
			li_start = 0 // 처음 로우 인지 아닌지 구분.
			ld_LendEja2 = 0 // 누적되는 이자
			
		
			DO UNTIL ld_LendRemain <= 0
				ld_LendEja = 0
		
				IF li_Pbgbn <> 0 THEN // 상여일때
					
					SELECT SUM(NVL(allretamt,0)), retdate 
					  INTO :ld_CashAmt, :ls_CashRetDate   
					  FROM p5_lendsch 		/* 상여일시상환자료 */
					 WHERE lendGbn = :ls_LendGbn AND
							 empno = :ls_EmpNo AND
							 lenddate = :ls_LendDate AND
							 lendkind = '1' AND
							 paygubun = 'X' AND
							 retdate >= :ls_InsertBaseDate and retdate < :ls_LendEndDate
					 GROUP BY retdate;
					IF Sqlca.SqlCode = 0 THEN
						IF IsNull(ld_CashAmt) then ld_CashAmt = 0
					ELSE
						ld_CashAmt = 0
					END IF
								
					IF ld_CashAmt <> 0 THEN // 일시상환이 있을경우
						li_DayCnt_cash = DaysAfter(Date(String(F_afterday(ls_InsertBaseDate, 1), "@@@@.@@.@@")), Date(String(ls_CashRetDate, "@@@@.@@.@@"))) + 1 //기준일로부터 일시상환일까지의 일수
						ld_LendEja_Cash = Truncate((ld_LendRemain * li_DayCnt_Cash / 365 * (ld_Rate / 100)),0) // 기준일부토 일시상환일까지의 이자.
						
						ld_LendRemain = ld_LendRemain - ld_CashAmt // 일시상환금을 빼고 남은돈.
						ls_CashRetDate = F_AfterDay(ls_CashRetDate, 1) // 상여일시상환일의 다음날
						li_DayCnt = DaysAfter(Date(String(ls_CashRetDate, "@@@@.@@.@@")), Date(String(ls_LendEndDate, "@@@@.@@.@@"))) + 1 // 일시상환일의 다음날부터 상여기준말일 까지의 일수				
						li_subDayCnt = 0
						ld_LendEja_sub = 0
					ELSE
						li_DayCnt_cash = 0
						ld_LendEja_Cash = 0
					END IF
														
					IF ls_RetGbn = '1' THEN //상환구분이 횟수일때
						IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
							IF ld_LendRemain >= ld_LendBamt2 THEN
								ld_MonthRetAmt = ld_LendBamt2	
							ELSE
								ld_MonthRetAmt = ld_LendRemain
							END IF
						ELSE
							ld_MonthRetAmt = 0
						END IF
					ELSEIF ls_RetGbn = '2' THEN //상환구분이 비율일때
						IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
							IF ld_LendRemain >= ld_LendBamt3 THEN
								ld_MonthRetAmt = ld_LendBamt3	
							ELSE
								ld_MonthRetAmt = ld_LendRemain
							END IF
						ELSE
							ld_MonthRetAmt = 0
						END IF
					ELSEIF ls_RetGbn = '3' THEN //상환구분이 금액일때
						IF Left(ls_BInsertRetDate, 6) >= ls_LendFrom THEN
							IF ld_LendRemain >= ld_LendBamt THEN
								ld_MonthRetAmt = ld_LendBamt	
							ELSE
								ld_MonthRetAmt = ld_LendRemain
							END IF
						ELSE
							ld_MonthRetAmt = 0
						END IF
					END IF
					
					IF ld_LendRemain > 0 THEN
						li_CurRow = dw_main.insertrow(0)
						
						/*이자계산 : 일단위 버림*/
						ld_LendEja = ld_LendEja_Cash + ld_LendEja_sub + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) 
						/*이자계산 : 누계 이자 */
						ld_LendEja2 = ld_LendEja2 + ld_LendEja
						/*일수계산 : 누적 일수 */
						li_DayCnt2 = li_DayCnt2 + li_DayCnt + li_DayCnt_Cash + li_subDayCnt
						
						ld_LendEja_sub = 0
						li_SubDayCnt = 0
						
						dw_main.SetItem(dw_main.RowCount(), 'retamt', ld_LendRemain)
						dw_main.SetItem(li_CurRow, 'janamt',   0)						
						dw_main.SetItem(li_CurRow, 'reteja',   0)
						dw_main.SetItem(li_CurRow, 'ejaday', 0)
						dw_main.SetItem(li_CurRow, 'paygubun', 'B')
						dw_main.SetItem(li_CurRow, 'empno',    ls_EmpNo)
						dw_main.SetItem(li_CurRow, 'lendgbn',  ls_LendGbn)
						dw_main.SetItem(li_CurRow, 'lenddate', ls_LendDate)
						dw_main.SetItem(li_CurRow, 'retdate',  ls_LendEndDate)
						dw_main.SetItem(li_CurRow, 'rate', ld_Rate)
																		
					ELSE
						dw_main.SetItem(dw_main.RowCount(), 'janamt',   0) 
					END IF
					
					ld_lendRemain = 0
					
					li_start = 1							 
						 
				ELSE			//여기서 부터 급여계산
					
					SELECT sum(nvl(allretamt,0)), retdate 
					  INTO :ld_CashAmt, :ls_CashRetDate   
					  FROM p5_lendsch 		/*급여일시상환자료*/
					 WHERE lendkind = '1' AND
							 lendGbn = :ls_LendGbn AND
							 empno = :ls_EmpNo AND
							 lenddate = :ls_LendDate AND
							 paygubun = 'X' AND
							 retdate >= :ls_InsertBaseDate and retdate < :ls_LendEndDate
					 GROUP BY retdate;
					IF Sqlca.SqlCode = 0 THEN
						IF IsNull(ld_CashAmt) then ld_CashAmt = 0
					ELSE
						ld_CashAmt = 0
					END IF			
					
					IF ld_CashAmt <> 0 THEN // 일시상환이 있을경우
						li_DayCnt_cash = DaysAfter(Date(String(F_AfterDay(ls_InsertBaseDate, 1), "@@@@.@@.@@")), Date(String(ls_CashRetDate, "@@@@.@@.@@"))) + 1 //기준일로부터 일시상환일까지의 일수
						ld_LendEja_Cash = Truncate((ld_LendRemain * li_DayCnt_Cash / 365 * (ld_Rate / 100)),0) // 기준일부토 일시상환일까지의 이자.
						
						ld_LendRemain = ld_LendRemain - ld_CashAmt // 일시상환금을 빼고 남은돈.
						ls_CashRetDate = F_AfterDay(ls_CashRetDate, 1) // 상여일시상환일의 다음날
						li_DayCnt = DaysAfter(Date(String(ls_CashRetDate, "@@@@.@@.@@")), Date(String(ls_LendEndDate, "@@@@.@@.@@"))) + 1 // 일시상환일의 다음날부터 상여기준말일 까지의 일수				
						li_subDayCnt = 0
						ld_LendEja_sub = 0
					ELSE
						li_DayCnt_cash = 0
						ld_LendEja_Cash = 0
					END IF
					
					IF ls_RetGbn = '1' THEN //상환구분이 횟수일때
						IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
							IF ld_LendRemain >= ld_LendMamt2 THEN
								ld_MonthRetAmt = ld_LendMamt2	
							ELSE
								ld_MonthRetAmt = ld_LendRemain
							END IF
						ELSE
							ld_MonthRetAmt = 0
						END IF
					ELSEIF ls_RetGbn = '2' THEN //상환구분이 비율일때
						IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
							IF ld_LendRemain >= ld_LendMamt3 THEN
								ld_MonthRetAmt = ld_LendMamt3	
							ELSE
								ld_MonthRetAmt = ld_LendRemain
							END IF
						ELSE
							ld_MonthRetAmt = 0
						END IF
					ELSEIF ls_RetGbn = '3' THEN //상환구분이 금액일때
						IF Left(ls_PInsertRetDate, 6) >= ls_LendFrom THEN
							IF ld_LendRemain >= ld_LendMamt THEN
								ld_MonthRetAmt = ld_LendMamt	
							ELSE
								ld_MonthRetAmt = ld_LendRemain
							END IF
						ELSE
							ld_MonthRetAmt = 0
						END IF
					END IF
				
		
					IF ld_LendRemain > 0 THEN
						li_CurRow = dw_main.insertrow(0)
								
						/*이자계산 : 일단위 버림*/
						ld_LendEja = ld_LendEja_Cash + ld_LendEja_sub + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) 
						/*이자계산 : 누계 이자 */
						ld_LendEja2 = ld_LendEja2 + ld_LendEja
						/*일수계산 : 누적 일수 */
						li_DayCnt2 = li_DayCnt2 + li_DayCnt + li_DayCnt_Cash + li_subDayCnt
						
						ld_LendEja_sub = 0
						li_SubDayCnt = 0
		
						dw_main.SetItem(dw_main.RowCount(), 'retamt', ld_LendRemain)
						dw_main.SetItem(li_CurRow, 'janamt',   0)						
						dw_main.SetItem(li_CurRow, 'reteja',   0)
						dw_main.SetItem(li_CurRow, 'ejaday', 0)
						dw_main.SetItem(li_CurRow, 'paygubun', 'P')
						dw_main.SetItem(li_CurRow, 'empno',    ls_EmpNo)
						dw_main.SetItem(li_CurRow, 'lendgbn',  ls_LendGbn)
						dw_main.SetItem(li_CurRow, 'lenddate', ls_LendDate)
						dw_main.SetItem(li_CurRow, 'retdate',  ls_LendEndDate)
						dw_main.SetItem(li_CurRow, 'rate', ld_Rate)
											
					ELSE
						dw_main.SetItem(dw_main.RowCount(), 'janamt',   0) 
					END IF
				
					ld_lendRemain = 0
		
					li_start = 1
				END IF
			LOOP
	END IF		
		
end subroutine

on w_pis2020.create
int iCurrent
call super::create
this.dw_ip=create dw_ip
this.dw_main=create dw_main
this.rr_1=create rr_1
this.p_remain=create p_remain
this.dw_sub=create dw_sub
this.dw_list=create dw_list
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ip
this.Control[iCurrent+2]=this.dw_main
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.p_remain
this.Control[iCurrent+5]=this.dw_sub
this.Control[iCurrent+6]=this.dw_list
this.Control[iCurrent+7]=this.rr_2
end on

on w_pis2020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ip)
destroy(this.dw_main)
destroy(this.rr_1)
destroy(this.p_remain)
destroy(this.dw_sub)
destroy(this.dw_list)
destroy(this.rr_2)
end on

event open;call super::open;String ls_code, ls_codename, ls_codename2, ls_empname, ls_lendgbn2, snull

SetNull(snull)

dw_ip.settransobject(sqlca)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetFocus()

SELECT empname
  INTO :ls_empname
  FROM p1_master
 WHERE empno = :gs_code;

IF IsNull(gs_codename2) OR gs_codename2 = "" OR gs_codename2 = '%' THEN 
ELSE
	dw_ip.setitem(1, 'empno', gs_code)
	dw_ip.SetItem(1, 'empname', ls_empname)
	dw_ip.setitem(1, 'lenddate', gs_codename)
	dw_ip.SetItem(1, 'lendgbn', gs_codename2)
END IF

dw_main.settransobject(sqlca)

dw_sub.SetTransObject(Sqlca)
dw_sub.sharedata(dw_list)

is_saupcd = gs_saupcd

IF gs_codename2 = '' OR IsNull(gs_codename2) THEN ls_codename2 = '%'

IF dw_ip.Getrow() > 0  THEN
//	dw_ip.Reset()
//	dw_ip.insertrow(0)
	
	IF gs_code = '' OR IsNull(gs_code) THEN gs_code = '%'
	IF gs_codename = '' OR IsNull(gs_codename) THEN gs_codename = '%'
	IF gs_codename2 = '' OR IsNull(gs_codename2) THEN gs_codename2 = '%'
	
	IF (IsNull(gs_codename2) OR gs_codename2 = "" OR gs_codename2 = '%') and (NOT ISNULL(gs_code) OR gs_code <> "" OR gs_code <> '%') THEN
		dw_sub.Retrieve('%', '%', '%')
	ELSE	
		dw_sub.Retrieve(gs_code, gs_codename, gs_codename2)
		dw_main.retrieve(gs_code, gs_codename, gs_codename2)	
	END IF

//	dw_sub.Retrieve('%', '%', '%')
//	dw_main.retrieve(gs_code, gs_codename, gs_codename2)
	
	
	dw_sub.SetItem(dw_sub.GetRow(), 'pejaday', '10')
   dw_sub.SetItem(dw_Sub.GetRow(), 'bejaday', '30')
	dw_sub.SetItem(dw_Sub.GetRow(), 'm1', '1')
	dw_sub.SetItem(dw_Sub.GetRow(), 'm3', '3')
	dw_sub.SetItem(dw_Sub.GetRow(), 'm5', '5')
	dw_sub.SetItem(dw_Sub.GetRow(), 'm7', '7')
	dw_sub.SetItem(dw_Sub.GetRow(), 'm9', '9')
	dw_sub.SetItem(dw_Sub.GetRow(), 'm11', '11')
	
	IF dw_sub.RowCount() > 0 THEN
		ls_lendgbn2 = dw_sub.GetItemString(dw_sub.GetRow(), 'lendgbn')
		IF ls_lendgbn2 = '1' THEN
			dw_sub.SetItem(dw_sub.GetRow(), 'pretyn', 'Y')
			dw_sub.SetItem(dw_sub.GetRow(), 'bretyn', 'N')
		ELSEIF ls_lendgbn2 = '2' THEN
			dw_sub.SetItem(dw_sub.GetRow(), 'pretyn', 'Y')
			dw_sub.SetItem(dw_sub.GetRow(), 'bretyn', 'Y')
		ELSE
			dw_sub.SetItem(dw_sub.GetRow(), 'pretyn', 'N')
			dw_sub.SetItem(dw_sub.GetRow(), 'bretyn', 'N')
		END IF
		
	
		IF dw_sub.GetItemString(dw_sub.GetRow(), 'pretyn') = 'Y' THEN
			IF dw_sub.GetItemString(dw_sub.GetRow(), 'bretyn') = 'Y' THEN
				dw_sub.SetItem(dw_sub.GetRow(), 'prettag', '3')
				dw_sub.SetItem(dw_sub.GetRow(), 'brettag', '2')
			ELSEIF dw_sub.GetItemString(dw_sub.GetRow(), 'bretyn') = 'N' THEN
				dw_sub.SetItem(dw_sub.GetRow(), 'prettag', '1')
				dw_sub.SetItem(dw_sub.GetRow(), 'brettag', snull)
			END IF
		ELSEIF dw_sub.GetItemString(dw_sub.GetRow(), 'pretyn') = 'N' THEN
			IF dw_sub.GetItemString(dw_sub.GetRow(), 'bretyn') = 'Y' THEN
				dw_sub.SetItem(dw_sub.GetRow(), 'prettag', snull)
				dw_sub.SetItem(dw_sub.GetRow(), 'brettag', '1')
			ELSEIF dw_sub.GetItemString(dw_sub.GetRow(), 'bretyn') = 'N' THEN
				dw_sub.SetItem(dw_sub.GetRow(), 'prettag', snull)
				dw_sub.SetItem(dw_sub.GetRow(), 'brettag', snull)
			END IF
		END IF
	ELSE
		dw_sub.InsertRow(0)
	END IF



//	IF dw_sub.GetItemString(dw_sub.getrow(), 'pretyn') = 'N' THEN
//	   dw_sub.SetItem(1, "prettag",	snull)
//      Return 
//   END IF
//
//   IF dw_sub.GetItemString(dw_sub.getrow(), 'bretyn') = 'N' THEN
//   	dw_sub.SetItem(1, "brettag",	snull)
//      Return 
//   END IF
	
	dw_ip.Modify("empno.protect = 0")
	dw_ip.Modify("lenddate.protect = 0")

else
	dw_ip.Modify("empno.protect = 1")
	dw_ip.Modify("lenddate.protect = 1")
	
	dw_sub.retrieve(gs_code, gs_codename, gs_codename2)
//	dw_sub.retrieve('%', '%', '%')
	dw_main.retrieve(gs_code, gs_codename, gs_codename2)
end if

	p_addrow.enabled = True
	p_addrow.picturename = "C:\erpman\image\이자재계산_up.gif"

	p_search.enabled = True
	p_search.picturename = "C:\erpman\image\생성_up.gif"

ib_any_typing = False


end event

type p_mod from w_inherite_standard`p_mod within w_pis2020
integer x = 3872
integer y = 12
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;String  ls_empno, ls_lenddate,ls_lendgbn
string  ls_empno2, ls_lenddate2, ls_lendgbn2
Decimal ld_janamt, ld_allamt, ld_retamt
Integer li_count

if dw_ip.accepttext() = -1 then return 
ls_empno 	= dw_ip.getitemstring(dw_ip.getrow(), 'empno')
ls_lenddate = dw_ip.getitemstring(dw_ip.getrow(), 'lenddate')
ls_lendgbn = dw_ip.getitemstring(dw_ip.getrow(), 'lendgbn')
w_mdi_frame.sle_msg.text =""

ls_empno2 = dw_sub.GetItemString(dw_sub.GetRow(), 'empno')
ls_lenddate2 = dw_sub.GetItemString(dw_sub.GetRow(), 'lenddate') 
ls_lendgbn2 = dw_sub.GetItemString(dw_sub.GetRow(), 'lendgbn')

dw_main.SetItem(dw_main.GetRow(), 'lendkind', '1')
dw_main.SetItem(dw_main.GetRow(), 'lendgbn', ls_lendgbn2)
dw_main.SetItem(dw_main.GetRow(), 'lenddate', ls_lenddate2)
dw_main.SetItem(dw_main.GetRow(), 'empno', ls_empno2)

IF dw_main.GetRow() <=0 THEN Return
IF dw_main.AcceptText() = -1 then return 

IF Wf_RequiredChk(dw_main.GetRow()) = -1 THEN Return

IF f_dbconfirm("저장") = 2 THEN RETURN

//
//	SELECT SUM(allretamt), SUM(retamt)
//  	  INTO :ld_allamt, :ld_retamt
//	  FROM p5_lendsch
//	 WHERE lendgbn = :ls_LendGbn AND
//			 empno = :ls_EmpNo AND 
//			 lenddate = :ls_LendDate AND
//			 lendkind = '1' AND
//			 subgbn = 'Y' AND
//			 paygubun like '%';
//			 
//			 
//	SELECT count(retdate)
//  	  INTO :li_count
//	  FROM p5_lendsch
//	 WHERE lendgbn = :ls_LendGbn AND
//			 empno = :ls_EmpNo AND 
//			 lenddate = :ls_LendDate AND
//			 lendkind = '1' AND
//			 subgbn = 'Y' AND
//			 paygubun like '%';
//			 
//	IF li_count > 0 THEN
//		SELECT MIN(janamt)
//		  INTO :ld_janamt
//		  FROM p5_lendsch
//		 WHERE lendgbn = :ls_LendGbn AND
//				 empno = :ls_EmpNo AND 
//				 lenddate = :ls_LendDate AND
//				 lendkind = '1' AND
//				 subgbn = 'Y' AND
//				 paygubun like '%';
//	ELSE
//		SELECT lendamt
//		  INTO :ld_janamt
//		  FROM p5_lendmst
//		 WHERE lendgbn = :ls_LendGbn AND
//				 empno = :ls_EmpNo AND 
//				 lenddate = :ls_LendDate AND
//				 lendkind = '1';
//	END IF
//	
//dw_main.SetItem(dw_main.GetRow(), 'janamt', ld_janamt - ld_allamt - ld_retamt)
//dw_main.SetItem(dw_main.GetRow(), 'reteja', dw_main.GetItemdecimal(dw_main.GetRow(), 'allreteja'))
//

IF dw_main.Update() > 0 THEN	
	COMMIT ;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
	
	SELECT SUM(allretamt)
  	  INTO :ld_allamt
	  FROM p5_lendsch
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND
			 subgbn = 'Y' AND
			 paygubun like '%';
		 
	dw_sub.SetItem(dw_sub.GetRow(), 'lendallamt', ld_allamt)
	dw_sub.Update() 
	COMMIT ;	
	
	
ELSE
	ROLLBACK ;
	ib_any_typing = True
	w_mdi_frame.sle_msg.text ="저장 실패!!"
	Return
END IF

 SELECT MIN(janamt)
  INTO :ld_janamt
  FROM p5_lendsch
 WHERE lendgbn = :ls_LendGbn AND
		 empno = :ls_EmpNo AND 
		 lenddate = :ls_LendDate AND
		 lendkind = '1' AND
		 subgbn = 'Y' AND
		 paygubun like '%';
//		 
//		 dw_sub.SetItem(dw_sub.GetRow(), 'lendallamt', ld_janamt)
//			 
////dw_sub.SetItem(dw_sub.GetRow(), 'lendallamt', dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendamt') - dw_main.GetItemDecimal(dw_main.GetRow(),'allretamt'))
//IF dw_sub.Update() > 0 THEN
//	COMMIT;
//ELSE
//	ROLLBACK;
//	RETURN
//END IF

dw_main.Modify("retamt.protect = 0")
dw_main.Modify("allretamt.protect = 1")

p_addrow.enabled = True
p_addrow.picturename = "C:\erpman\image\이자재계산_up.gif"

p_search.enabled = True
p_search.picturename = "C:\erpman\image\생성_up.gif"

p_ins.enabled = True
p_ins.picturename = "C:\erpman\image\추가_up.gif"

p_del.enabled = True
p_del.picturename = "C:\erpman\image\삭제_up.gif"

ib_any_typing = False

p_inq.TriggerEvent(Clicked!)
end event

type p_del from w_inherite_standard`p_del within w_pis2020
integer x = 4046
integer y = 12
integer taborder = 50
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;string ls_empno, ls_lenddate, ls_lendgbn
decimal ld_lendsum, ld_sangsum, ld_janamt, ld_allretamt, ld_lendallamt


ls_empno = dw_sub.GetItemString(dw_sub.GetRow(), 'empno')
ls_lendgbn = dw_sub.GetItemString(dw_sub.GetRow(), 'lendgbn')
ls_lenddate = dw_sub.GetItemString(dw_sub.GetRow(), 'lenddate')
ld_Lendallamt = dw_sub.GetItemDecimal(dw_sub.GetRow(), "lendallamt")
ld_allretamt = dw_main.GetItemDecimal(dw_main.GetRow(),"allretamt")

w_mdi_frame.sle_msg.text =""

if dw_main.GetRow() <=0 then Return

if dw_main.GetItemstring(dw_main.GetRow(),"subgbn") = 'Y' then
	MessageBox('확 인','급여 공제되었으므로 삭제할 수 없습니다.')
	Return
end if

IF f_dbconfirm("삭제") = 2 THEN RETURN

//dw_sub.SetItem(dw_sub.GetRow(), 'lendallamt', dw_sub.GetItemString(dw_sub.GetRow(), 'lendallamt') - dw_main.GetItemDecimal(dw_main.GetRow(), 'allretamt'))
//dw_sub.SetItem(dw_sub.GetRow(), 'lendallamt', dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendallamt') - dw_main.GetItemDecimal(dw_main.GetRow(), 'allretamt'))
dw_main.DeleteRow(0)

IF dw_main.update()= 1 THEN
	COMMIT;
	
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"	
	
	dw_sub.SetItem(dw_sub.GetRow(), 'lendallamt', ld_lendallamt - ld_allretamt)	
	
	dw_sub.update()
	COMMIT;
	
	ib_any_typing = False

ELSE
	w_mdi_frame.sle_msg.text ="자료삭제 실패!!!"	
	ROLLBACK;
	Return
END IF
//
//
// SELECT MIN(janamt)
//  INTO :ld_janamt
//  FROM p5_lendsch
// WHERE lendgbn = :ls_LendGbn AND
//		 empno = :ls_EmpNo AND 
//		 lenddate = :ls_LendDate AND
//		 lendkind = '1' AND
//		 subgbn = 'Y' AND
//		 paygubun like '%';
//		 
//dw_sub.SetItem(dw_sub.GetRow(), 'lendallamt', ld_janamt)
//			 
////dw_sub.SetItem(dw_sub.GetRow(), 'lendallamt', dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendamt') - dw_main.GetItemDecimal(dw_main.GetRow(),'allretamt'))
//IF dw_sub.Update() > 0 THEN
//	COMMIT;
//ELSE
//	ROLLBACK;
//	RETURN
//END IF
//

p_addrow.enabled = True
p_addrow.picturename = "C:\erpman\image\이자재계산_up.gif"

p_search.enabled = True
p_search.picturename = "C:\erpman\image\생성_up.gif"

p_ins.enabled = True
p_ins.picturename = "C:\erpman\image\추가_up.gif"

ib_any_typing = False

end event

type p_inq from w_inherite_standard`p_inq within w_pis2020
integer x = 3525
integer y = 12
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string ls_empno, ls_lenddate, ls_lendgbn, snull, ls_retgbn
string ls_empno2, ls_lenddate2, ls_lendgbn2

SetNull(snull)

IF dw_ip.accepttext() = -1 THEN 
	IF dw_sub.AcceptText() = -1 THEN Return
END IF

ls_empno 	= dw_ip.getitemstring(dw_ip.getrow(), 'empno')
ls_lenddate = dw_ip.getitemstring(dw_ip.getrow(), 'lenddate')
ls_lendgbn = dw_ip.GetItemString(dw_ip.GetRow(), 'lendgbn')

ls_empno2 	= dw_sub.getitemstring(dw_sub.getrow(), 'empno')
ls_lenddate2 = dw_sub.getitemstring(dw_sub.getrow(), 'lenddate')
ls_lendgbn2 = dw_sub.GetItemString(dw_sub.GetRow(), 'lendgbn')
ls_retgbn = dw_sub.GetItemString(dw_sub.GetRow(), 'retgubun')

//if ls_empno = '' or isnull(ls_empno) THEN ls_empno = '%'

if ls_empno = '' or isnull(ls_empno) THEN
//	IF ls_empno2 = '' OR IsNull(ls_empno2) THEN
		messagebox("확  인", "사번을 입력하세요.")
		dw_ip.setcolumn('empno')
		return -1
	END IF
//END IF

//IF ls_lenddate = '' OR isnull(ls_lenddate) THEN ls_lenddate = '%'

IF ls_lenddate = '' OR isnull(ls_lenddate) THEN
//	IF ls_lenddate2 = '' OR isnull(ls_lenddate2) THEN
	   messagebox("확  인", "대출일자를 입력하세요.")
	   dw_ip.setcolumn('lenddate')
	   return -1
   END IF
//END IF

IF ls_lendgbn = '' OR IsNull(ls_lendgbn) THEN ls_lendgbn = '%'
IF ls_lendgbn2 = '' OR IsNull(ls_lendgbn2) THEN ls_lendgbn2 = '%'

p_addrow.enabled = True
p_addrow.picturename = "C:\erpman\image\이자재계산_up.gif"

p_ins.enabled = True
p_ins.picturename = "C:\erpman\image\추가_up.gif"
	
IF ls_retgbn = '4' THEN
	p_search.enabled = False
	p_search.picturename = "C:\erpman\image\생성_d.gif"
ELSE
	p_search.enabled = True
	p_search.picturename = "C:\erpman\image\생성_up.gif"
END IF

ib_any_typing = False

IF dw_sub.Retrieve(ls_empno, ls_lenddate, ls_lendgbn) < 1 THEN
	MessageBox("확 인","조회된 자료가 없습니다.")
	dw_ip.SetColumn('empno')
END IF

IF ls_lendgbn2 = '1' THEN
	dw_sub.SetItem(1, 'pretyn', 'Y')
	dw_sub.SetItem(1, 'bretyn', 'N')
ELSEIF ls_lendgbn2 = '2' THEN
   dw_sub.SetItem(1, 'pretyn', 'Y')
	dw_sub.SetItem(1, 'bretyn', 'Y')
ELSE
	dw_sub.SetItem(1, 'pretyn', 'N')
	dw_sub.SetItem(1, 'bretyn', 'N')
END IF


dw_sub.SetItem(1, 'pejaday', '10')
dw_sub.SetItem(1, 'bejaday', '30')
dw_sub.SetItem(1, 'm2', '2')
dw_sub.SetItem(1, 'm4', '4')
dw_sub.SetItem(1, 'm6', '6')
dw_sub.SetItem(1, 'm8', '8')
dw_sub.SetItem(1, 'm10', '10')
dw_sub.SetItem(1, 'm12', '12')


IF dw_sub.GetItemString(dw_sub.GetRow(), 'pretyn') = 'Y' THEN
	IF dw_sub.GetItemString(dw_sub.GetRow(), 'bretyn') = 'Y' THEN
		dw_sub.SetItem(1, 'prettag', '3')
		dw_sub.SetItem(1, 'brettag', '2')
	ELSEIF dw_sub.GetItemString(dw_sub.GetRow(), 'bretyn') = 'N' THEN
		dw_sub.SetItem(1, 'prettag', '1')
		dw_sub.SetItem(1, 'brettag', snull)
	END IF
ELSEIF dw_sub.GetItemString(dw_sub.GetRow(), 'pretyn') = 'N' THEN
	IF dw_sub.GetItemString(dw_sub.GetRow(), 'bretyn') = 'Y' THEN
		dw_sub.SetItem(1, 'prettag', snull)
		dw_sub.SetItem(1, 'brettag', '1')
	ELSEIF dw_sub.GetItemString(dw_sub.GetRow(), 'bretyn') = 'N' THEN
		dw_sub.SetItem(1, 'prettag', snull)
		dw_sub.SetItem(1, 'brettag', snull)
	END IF
END IF

dw_main.retrieve(ls_empno, ls_lenddate, ls_lendgbn) 

end event

type p_print from w_inherite_standard`p_print within w_pis2020
boolean visible = false
integer x = 3630
integer y = 304
integer taborder = 110
end type

type p_can from w_inherite_standard`p_can within w_pis2020
integer x = 4219
integer y = 12
integer taborder = 80
end type

event p_can::clicked;call super::clicked;
//p_inq.TriggerEvent(clicked!)

setnull(gs_code); setnull(gs_codename); setnull(gs_codename2);

dw_ip.SetRedraw(False)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetRedraw(True)

dw_ip.SetColumn("empno")
dw_ip.SetFocus()

IF gs_code = '' OR IsNull(gs_code) THEN gs_code = '%'
IF gs_codename = '' OR IsNull(gs_codename) THEN gs_codename = '%'
IF gs_codename2 = '' OR IsNull(gs_codename2) THEN gs_codename2 = '%'
dw_sub.Retrieve(gs_code, gs_codename, gs_codename2)

dw_main.Reset()

p_addrow.enabled = false
p_addrow.picturename = "C:\erpman\image\이자재계산_d.gif"

p_search.enabled = false
p_search.picturename = "C:\erpman\image\생성_d.gif"

p_ins.enabled = False
p_ins.picturename = "C:\erpman\image\추가_d.gif"

ib_any_typing = False

end event

type p_exit from w_inherite_standard`p_exit within w_pis2020
integer x = 4393
integer y = 12
integer taborder = 90
end type

event p_exit::clicked;setnull(gs_code); setnull(gs_codename); setnull(gs_codename2);

w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)
end event

type p_ins from w_inherite_standard`p_ins within w_pis2020
integer x = 3698
integer y = 12
integer taborder = 30
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;String ls_LendGbn, ls_Empno, ls_LendDate, ls_paygbn
Int il_currow,il_functionvalue
Decimal ld_janamt

ls_Lendgbn = dw_sub.GetItemString(dw_sub.GetRow(), 'lendgbn')
ls_empno = dw_sub.GetItemString(dw_sub.GetRow(), 'empno')
ls_lenddate = dw_sub.GetItemString(dw_sub.GetRow(), 'lenddate')

w_mdi_frame.sle_msg.text =""

IF dw_main.RowCount() <=0 THEN

	il_functionvalue =1
ELSE
	il_functionvalue = wf_requiredchk(dw_main.GetRow())

END IF

IF il_functionvalue = 1 THEN
	
	SELECT MIN(janamt)
	  INTO :ld_janamt
	  FROM p5_lendsch 
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND
			 subgbn = 'Y' AND
			 paygubun LIKE '%';

	IF ld_janamt = 0 THEN
		MessageBox("확 인", "전부 공제된 자료입니다.")
		Return 1
	ELSE
		il_currow = dw_main.InsertRow(0)
	
		dw_main.setitem(il_currow, 'empno', dw_ip.getitemstring(dw_ip.getrow(), 'empno'))
		dw_main.setitem(il_currow, 'lenddate', dw_ip.getitemstring(dw_ip.getrow(), 'lenddate'))
		dw_main.setitem(il_currow, 'lendkind', is_gubun)
		dw_main.setitem(il_currow, 'paygubun', 'X')
		
		IF dw_main.GetItemString(dw_main.GetRow(), 'subgbn') = 'N' THEN
			dw_main.Modify("retamt.protect = 1")
			dw_main.Modify("allretamt.protect = 0")
		END IF
		dw_main.ScrollToRow(il_currow)
		dw_main.SetColumn("retdate")
		dw_main.SetFocus()	
	END IF
END IF


p_addrow.enabled = false
p_addrow.picturename = "C:\erpman\image\이자재계산_d.gif"

ib_any_typing = True


//IF dw_main.RowCount() <=0 THEN
//	il_currow = 0
//	il_functionvalue =1
//ELSE
//	il_functionvalue = wf_requiredchk(dw_main.GetRow())
//	
//	il_currow = dw_main.GetRow() 
//END IF
//
//IF il_functionvalue = 1 THEN
//	il_currow = il_currow + 1
//	
//	dw_main.InsertRow(il_currow)

	
//	dw_main.InsertRow(0)
//	dw_main.setitem(il_currow, 'empno', dw_ip.getitemstring(dw_ip.getrow(), 'empno'))
//	dw_main.setitem(il_currow, 'lenddate', dw_ip.getitemstring(dw_ip.getrow(), 'lenddate'))
//	dw_main.setitem(il_currow, 'lendkind', is_gubun)
//	dw_main.setitem(il_currow, 'paygubun', 'X')
//	
//	dw_main.Modify("retamt.protect = 1")
//	dw_main.Modify("allretamt.protect = 0")
//	dw_main.ScrollToRow(il_currow)
//	dw_main.SetColumn("retdate")
//	dw_main.SetFocus()	
//END IF


end event

type p_search from w_inherite_standard`p_search within w_pis2020
integer x = 3351
integer y = 12
integer taborder = 70
boolean enabled = false
string picturename = "C:\erpman\image\생성_d.gif"
end type

event p_search::clicked;
string   ls_lendfrom, ls_EmpNo, ls_LendDate, ls_InsertRetDate, ls_LendGbn, ls_RetGbn, ls_paygubn, ls_pretyn, ls_bretyn
string   ls_pejaday, ls_bejaday, ls_prettag, ls_brettag
decimal  ld_LendAmt, ld_LendMAmt, ld_LendMamt2, ld_lendMamt3, ld_LendBamt, ld_LendBamt2, ld_lendBamt3, ld_LendRemain, ld_LendEja, ld_Rate, ld_MonthRetAmt, ld_CashAmt, ld_BefCashHap
long     li_CurRow, li_CurRow1, li_DayCnt, li_DayCnt2, li_RowCnt, li_Cnt, li_RowCount

String   ls_MaxSubDate, ls_RetDate, ls_CurMaxDate, ls_CreateBaseDate, ls_AfterMonth, ls_lastdate,  ls_lastdate2, ls_afterday, ls_lendmamt, ls_lendbamt
String   ls_m1, ls_m2, ls_m3, ls_m4, ls_m5, ls_m6, ls_m7, ls_m8, ls_m9, ls_m10, ls_m11, ls_m12 

string ls_CurMaxDate2, ls_CreateBaseDate2, ls_AfterMonth2, ls_InsertRetDate2
decimal ld_LendRemain2, ld_lendeja2, ld_MonthRetAmt2, ld_CashAmt2

IF dw_sub.AcceptText() = -1 THEN Return

ls_EmpNo    = dw_sub.GetItemString(dw_sub.GetRow(), 'empno')
ls_LendDate = dw_sub.GetItemString(dw_sub.GetRow(), 'lenddate')
ls_LendGbn = dw_sub.GetItemString(dw_sub.GetRow(), 'lendGbn')
ls_LendFrom = dw_sub.GetItemString(dw_sub.GetRow(), 'lendfrom')
ld_LendAmt  = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendamt')
ld_LendMamt = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendmamt')
ld_LendBamt = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendbamt')
ld_Rate     = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'rate')
ls_retgbn = dw_sub.GetItemString(dw_sub.GetRow(), 'retgubun')

ls_pretyn = dw_sub.GetItemString(dw_sub.GetRow(), 'pretyn')
ls_bretyn = dw_sub.GetItemString(dw_sub.GetRow(), 'bretyn')
ls_pejaday = dw_sub.GetItemString(dw_sub.GetRow(), 'pejaday')
ls_bejaday = dw_sub.GetItemString(dw_sub.GetRow(), 'bejaday')
ls_prettag = dw_sub.GetItemString(dw_sub.GetRow(), 'prettag')
ls_brettag = dw_sub.GetItemString(dw_sub.GetRow(), 'brettag')

ls_m1 = dw_sub.GetItemString(dw_sub.GetRow(), 'm1')
ls_m2 = dw_sub.GetItemString(dw_sub.GetRow(), 'm2')
ls_m3 = dw_sub.GetItemString(dw_sub.GetRow(), 'm3')
ls_m4 = dw_sub.GetItemString(dw_sub.GetRow(), 'm4')
ls_m5 = dw_sub.GetItemString(dw_sub.GetRow(), 'm5')
ls_m6 = dw_sub.GetItemString(dw_sub.GetRow(), 'm6')
ls_m7 = dw_sub.GetItemString(dw_sub.GetRow(), 'm7')
ls_m8 = dw_sub.GetItemString(dw_sub.GetRow(), 'm8')
ls_m9 = dw_sub.GetItemString(dw_sub.GetRow(), 'm9')
ls_m10 = dw_sub.GetItemString(dw_sub.GetRow(), 'm10')
ls_m11 = dw_sub.GetItemString(dw_sub.GetRow(), 'm11')
ls_m12 = dw_sub.GetItemString(dw_sub.GetRow(), 'm12')

IF IsNull(ld_LendAmt) THEN ld_LendAmt = 0
IF IsNull(ld_LendMamt) THEN ld_LendMamt = 0
IF IsNull(ld_LendBamt) THEN ld_LendBamt = 0
//IF IsNull(ld_LendMamt2) THEN ld_LendMamt2 = 0
//IF IsNull(ld_LendMamt3) THEN ld_LendMamt3 = 0
IF ld_lendmamt = 0 OR IsNull(ld_lendmamt) THEN            // 만약 lendmamt가 0이면 lendmamt2와 lendmamt3를 0으로 만듬.
	ld_LendMamt2 = 0													 // lendmamt는 갚을돈의 구분이 정액일때.
	ld_LendMamt3 = 0
ELSE
	ld_LendMamt2 = ld_LendAmt / ld_LendMamt
   ld_LendMamt3 = (ld_LendAmt * ld_LendMamt) / 100       // lendmamt가 0이 아닐때 lendmamt2와 lendmamt3의 계산과정.
END IF																	// lendmamt2는 갚을돈의 구분이 횟수일때.
IF IsNull(ld_Rate) THEN ld_Rate = 0								// lendmamt3는 갚을돈의 구분이 비율일때.

IF ld_lendBamt = 0 OR IsNull(ld_lendBamt) THEN            // 만약 lendBamt가 0이면 lendBamt2와 lendBamt3를 0으로 만듬.
	ld_LendBamt2 = 0													 // lendBamt는 갚을돈의 구분이 정액일때.
	ld_LendBamt3 = 0
ELSE
	ld_LendBamt2 = ld_LendAmt / ld_LendBamt
   ld_LendBamt3 = (ld_LendAmt * ld_LendBamt) / 100       // lendBamt가 0이 아닐때 lendBamt2와 lendBamt3의 계산과정.
END IF																	// lendBamt2는 갚을돈의 구분이 횟수일때.
																			// lendBamt3는 갚을돈의 구분이 비율일때.



/*이전 자료 처리*/
IF dw_main.RowCount() > 0 THEN
	/*공제된 내역*/
	SELECT count(*), max(retdate) 
	  INTO :li_RowCnt, :ls_MaxSubDate 
	  FROM p5_lendsch 
	 WHERE lendgbn = :ls_LendGbn AND 
	 		 lendkind = '1' AND
			 empno = :ls_EmpNo AND
			 lenddate = :ls_LendDate AND
			 subgbn = 'Y' AND
			 paygubun like '%';
			 
	IF Sqlca.SqlCode = 0 AND li_RowCnt > 0 THEN
		IF IsNull(ls_MaxSubDate) THEN ls_MaxSubDate = '00000000'
	ELSE
		ls_MaxSubDate = '00000000'
	END IF
	
	IF ls_MaxSubDate <> '00000000' THEN
		IF MessageBox("확  인", "공제한 자료가 존재합니다."+'~n'+&
										"공제이후로 다시 생성하시겠습니까?", Question!,YesNo!) = 2 THEN Return 
		
		DELETE FROM p5_lendsch 
			   WHERE lendgbn = :ls_LendGbn AND 
						lendkind = '1' AND 
						empno = :ls_EmpNo AND
						lenddate = :ls_LendDate AND
				   	retdate > :ls_MaxSubDate AND
						subgbn <> 'Y' AND
						paygubun like '%';	
	ELSE
		IF MessageBox("확  인", "이미 생성된 자료가 존재합니다."+'~n'+&
										"삭제 후 다시 생성하시겠습니까?", Question!,YesNo!) = 2 THEN Return
		DELETE FROM p5_lendsch 
			   WHERE lendgbn = :ls_LendGbn AND
						lendkind = '1' AND
						empno = :ls_EmpNo AND
						lenddate = :ls_LendDate AND
						paygubun like '%';	
	END IF

	dw_main.Retrieve(ls_EmpNo, ls_LendDate, ls_LendGbn)
END IF


/* 급여만 사용할 경우*/
IF ls_pretyn = 'Y' AND ls_bretyn = 'N' THEN
   wf_calc_pay()


/* 상여만 사용할 경우*/
ELSEIF ls_bretyn = 'Y' and ls_pretyn = 'N' THEN
       wf_calc_bonus(ls_m1, ls_m2, ls_m3, ls_m4, ls_m5, ls_m6, ls_m7, ls_m8, ls_m9, ls_m10, ls_m11, ls_m12)
		 

/* 급여, 상여 둘다 사용할 경우*/
ELSEIF ls_pretyn = 'Y' AND ls_bretyn = 'Y' THEN
		 wf_calc_all(ls_m1, ls_m2, ls_m3, ls_m4, ls_m5, ls_m6, ls_m7, ls_m8, ls_m9, ls_m10, ls_m11, ls_m12)
END IF
	
dw_main.SetReDraw(True)

li_RowCount = dw_main.GetRow()

IF li_RowCount > 0 THEN
	dw_main.SetReDraw(True)
	dw_main.modify("allretamt.protect = 1")
//	p_inq.TriggerEvent(clicked!)
ELSE
	dw_main.SetReDraw(True)
	MessageBox("실  패", "상환계획 생성 실패.")	
	Return
END IF

p_addrow.enabled = False
p_addrow.picturename = "C:\erpman\image\이자재계산_up.gif"







end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_addrow from w_inherite_standard`p_addrow within w_pis2020
boolean visible = false
integer x = 594
integer y = 1788
integer width = 206
integer height = 100
integer taborder = 60
string pointer = "C:\erpman\cur\point.cur"
boolean enabled = false
string picturename = "C:\erpman\image\이자재계산_d.gif"
end type

event p_addrow::ue_lbuttonup;PictureName = "C:\erpman\image\이자재계산_up.gif"
end event

event p_addrow::ue_lbuttondown;PictureName = "C:\erpman\image\이자재계산_dn.gif"
end event

event p_addrow::clicked;Integer   li_RowCount, k, li_DayCnt, li_DayCnt2
Double    ld_LendEja, ld_LendAmt, ld_Rate, ld_LendRemain, ld_LendRemain2
String    ls_CurDate, ls_BeforeDate, ls_LendDate, ls_LendFrom, ls_beforedate2, ls_lastday, ls_beforeday
String    ls_Pretyn, ls_Bretyn, ls_Pejaday, ls_Bejaday, ls_PretTag, ls_BretTag, ls_checkyear2, ls_checkmonth2
string    m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12

IF dw_sub.AcceptText() = -1 THEN Return
ls_LendDate = dw_sub.GetItemString(dw_sub.GetRow(), 'lenddate')
ls_LendFrom = dw_sub.GetItemString(dw_sub.GetRow(), 'lendfrom')
ld_LendAmt  = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendamt')
ld_Rate     = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'rate')
ls_pretyn = dw_sub.GetItemString(dw_sub.GetRow(), 'pretyn')
ls_bretyn = dw_sub.GetItemString(dw_sub.GetRow(), 'bretyn')
ls_pejaday = dw_sub.GetItemString(dw_sub.GetRow(), 'pejaday')
ls_bejaday = dw_sub.GetItemString(dw_sub.GetRow(), 'bejaday')
ls_prettag = dw_sub.GetItemString(dw_sub.GetRow(), 'prettag')
ls_brettag = dw_sub.GetItemString(dw_sub.GetRow(), 'brettag')

ls_pejaday = string(long(ls_pejaday), '00')
ls_bejaday = string(long(ls_bejaday), '00')

IF IsNull(ld_LendAmt) THEN ld_LendAmt = 0
IF IsNull(ld_Rate) THEN ld_Rate = 0

li_RowCount = dw_main.RowCount()
IF li_RowCount <=0 THEN Return

IF ls_pretyn = 'Y' AND ls_bretyn = 'N' THEN

		FOR k = 1 TO li_RowCount
			IF dw_main.GetItemString(k,"subgbn") = 'Y' THEN Continue
			IF dw_main.GetItemString(k,"allretdate") <> '' AND Not IsNull(dw_main.GetItemString(k,"allretdate")) THEN Continue
			
			ls_CurDate = dw_main.GetItemString(k,"retdate")
				//ls_Curgubn = dw_main.GetItemString(k, "paygubun")
			
			IF k = 1 THEN
				ls_BeforeDate = ls_LendDate
				ld_LendRemain = ld_LendAmt
			ELSE
				IF ls_pejaday = '30' THEN
        	   	ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + string('01')
				ELSE
					ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + string(integer(ls_pejaday) + 1, '00') 	
				END IF
				ld_LendRemain = dw_main.GetItemNumber(k - 1, "janamt")
				IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
			END IF
			
			li_DayCnt = DaysAfter(Date(String(ls_BeforeDate,"@@@@.@@.@@")),date(string(ls_CurDate,"@@@@.@@.@@"))) + 1
			IF ls_prettag = '2' THEN
				dw_main.SetItem(k, 'reteja', 0)
			ELSE		
				ld_LendEja = truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)), 0)
				dw_main.SetItem(k, 'reteja', ld_LendEja)
			END IF
		next
		
ELSEIF ls_pretyn = 'Y' AND ls_bretyn = 'N' THEN

		FOR k = 1 TO li_RowCount
			IF dw_main.GetItemString(k,"subgbn") = 'Y' THEN Continue
			IF dw_main.GetItemString(k,"allretdate") <> '' AND Not IsNull(dw_main.GetItemString(k,"allretdate")) THEN Continue
			
			ls_CurDate = dw_main.GetItemString(k,"retdate")
		
			
			IF k = 1 THEN
				ls_BeforeDate = ls_LendDate
				ld_LendRemain = ld_LendAmt
			ELSE
				IF ls_bejaday = '30' THEN
        	   	ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + string('01')
				ELSE
					ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + string(integer(ls_bejaday) + 1, '00') 	
				END IF
				ld_LendRemain = dw_main.GetItemNumber(k - 1, "janamt")
				IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
			END IF
			
			li_DayCnt = DaysAfter(Date(String(ls_BeforeDate,"@@@@.@@.@@")),date(string(ls_CurDate,"@@@@.@@.@@"))) + 1
			
			IF ls_prettag = '2' THEN
				dw_main.SetItem(k, 'reteja', 0)
			ELSE		
				ld_LendEja = truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)), 0)
				dw_main.SetItem(k, 'reteja', ld_LendEja)
			END IF
		next

ELSEIF ls_pretyn = 'Y' AND ls_bretyn = 'Y' THEN

		FOR k = 1 TO li_RowCount
			IF dw_main.GetItemString(k,"subgbn") = 'Y' THEN Continue
			IF dw_main.GetItemString(k,"allretdate") <> '' AND Not IsNull(dw_main.GetItemString(k,"allretdate")) THEN Continue
			
			ls_CurDate = dw_main.GetItemString(k, "retdate")
						
			IF dw_main.GetItemString(k, 'paygubun') = 'P' THEN
				IF k = 1 THEN
				ls_BeforeDate = ls_LendDate
				ld_LendRemain = ld_LendAmt
				ELSE
					ls_lastday = Right(f_last_date(Left(dw_main.GetItemString(k - 1, "retdate"), 6)), 2)
					ls_beforeday = Right(dw_main.GetItemString(k - 1, "retdate"), 2)
					IF Right(dw_main.GetItemString(k - 1, "retdate"), 2) = ls_lastday THEN
						ls_BeforeDate = Left(dw_main.GetItemString(k, "retdate"), 6) + string('01')
					ELSE
						ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + string(integer(ls_beforeday) + 1, '00') 	
					END IF
					ld_LendRemain = dw_main.GetItemNumber(k - 1, "janamt")
					IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0	
				END IF
				li_DayCnt = DaysAfter(Date(String(ls_BeforeDate,"@@@@.@@.@@")),date(string(ls_CurDate,"@@@@.@@.@@"))) + 1
				IF ls_prettag = '2' THEN
					ld_LendEja = truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)), 0)				
					dw_main.SetItem(k, 'reteja', 0)
				ELSE
					ld_LendEja = ld_LendEja + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)), 0)
					dw_main.SetItem(k, 'reteja', ld_LendEja)
					ld_LendEja = 0
				END IF
			ELSEIF dw_main.GetItemString(k, 'paygubun') = 'B' THEN
				IF k = 1 THEN
					ls_BeforeDate = ls_LendDate
					ld_LendRemain = ld_LendAmt
				ELSE
					ls_lastday = Right(f_last_date(Left(dw_main.GetItemString(k - 1, "retdate"), 6)), 2)
					ls_beforeday = Right(dw_main.GetItemString(k - 1, "retdate"), 2)
					IF Right(dw_main.GetItemString(k - 1, "retdate"), 2) = ls_lastday THEN
						ls_BeforeDate = Left(dw_main.GetItemString(k, "retdate"), 6) + string('01')
					ELSE
						ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + string(integer(ls_beforeday) + 1, '00') 	
					END IF
					ld_LendRemain = dw_main.GetItemNumber(k - 1, "janamt")
					IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
				END IF
				li_DayCnt = DaysAfter(Date(String(ls_BeforeDate,"@@@@.@@.@@")),date(string(ls_CurDate,"@@@@.@@.@@"))) + 1
				IF ls_brettag = '2' THEN
					ld_LendEja = truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)), 0)				
					//dw_main.SetItem(k, 'reteja', 0)
				ELSE
					ld_LendEja = ld_LendEja + truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)), 0)
					dw_main.SetItem(k, 'reteja', ld_LendEja)
					ld_LendEja = 0
				END IF
			END IF
		next
		
END IF
		
		
		
		
//ELSEIF ls_pretyn = 'Y' AND ls_bretyn = 'Y' THEN
//
//		FOR k = 1 TO li_RowCount
//			IF dw_main.GetItemString(k,"subgbn") = 'Y' THEN Continue
//			IF dw_main.GetItemString(k,"allretdate") <> '' AND Not IsNull(dw_main.GetItemString(k,"allretdate")) THEN Continue
//			
//			IF dw_main.GetItemString(k, 'paygubun') = 'P' THEN
//				ls_CurDate = dw_main.GetItemString(k,"retdate")
//				
//				IF k = 1 THEN
//	//				ls_BeforeDate = ls_LendDate
//					ls_BeforeDate = ls_LendFrom
//					ld_LendRemain = ld_LendAmt
//				ELSE
//					IF ls_pejaday = '30' THEN
//						ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + string('01')
//					ELSE
//						ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + string(integer(ls_pejaday) + 1, '00') 	
//					END IF
//					ld_LendRemain = dw_main.GetItemNumber(k - 1, "janamt")
//					IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
//				END IF
//			ELSEIF dw_main.GetItemString(k, 'paygubun') = 'B' THEN
//				ls_CurDate = dw_main.GetItemString(k,"retdate")
//				
//				IF k = 1 THEN
//	//				ls_BeforeDate = ls_LendDate
//					ls_BeforeDate = ls_LendFrom
//					ld_LendRemain = ld_LendAmt
//				ELSE
//					IF dw_main.GetItemdecimal(k - 1, 'reteja') = 0 THEN
//						IF ls_bejaday = '30' THEN
//							ls_BeforeDate = Left(dw_main.GetItemString(k - 2, "retdate"), 6) + string('01')
//						ELSE
//							ls_BeforeDate = Left(dw_main.GetItemString(k - 2, "retdate"), 6) + string(integer(ls_bejaday) + 1, '00') 	
//						END IF
//						ld_LendRemain = dw_main.GetItemNumber(k - 1, "janamt")
//						IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0				
//					ELSE
//						IF ls_bejaday = '30' THEN
//							ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + string('01')
//						ELSE
//							ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + string(integer(ls_bejaday) + 1, '00') 	
//						END IF
//						ld_LendRemain = dw_main.GetItemNumber(k - 1, "janamt")
//						IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
//					END IF
//				END IF
//			END IF
//			li_DayCnt = DaysAfter(Date(String(ls_BeforeDate,"@@@@.@@.@@")),date(string(ls_CurDate,"@@@@.@@.@@"))) + 1
//			
//			ld_LendEja = truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)), 0)
//			dw_main.SetItem(k, 'reteja', ld_LendEja)
//		next
//		
//END IF
		

		
//ELSEIF ls_Bretyn = 'Y' AND ls_Pretyn = 'N' THEN
//		
//		FOR k = 1 TO li_RowCount
//			IF dw_main.GetItemString(k,"subgbn") = 'Y' THEN Continue
//			IF dw_main.GetItemString(k,"allretdate") <> '' AND Not IsNull(dw_main.GetItemString(k,"allretdate")) THEN Continue
//			
//			ls_CurDate = dw_main.GetItemString(k,"retdate")
//			
//			ls_checkyear2 = left(ls_CurDate, 4)
//			ls_checkmonth2 = mid(ls_CurDate, 5, 2)
//		
//			Do until integer(ls_checkmonth2) = integer(M1) OR integer(ls_checkmonth2) = integer(M2) OR integer(ls_checkmonth2) = integer(M3) OR integer(ls_checkmonth2) = integer(M4) OR integer(ls_checkmonth2) = integer(M5) OR &
//      	   		integer(ls_checkmonth2) = integer(M6) OR integer(ls_checkmonth2) = integer(M7) OR integer(ls_checkmonth2) = integer(M8) OR integer(ls_checkmonth2) = integer(M9) OR integer(ls_checkmonth2) = integer(M10) OR &
//		      		integer(ls_checkmonth2) = integer(M11) OR integer(ls_checkmonth2) = integer(M12) 
//			
//						ls_checkmonth2 = string(integer(ls_checkmonth2) + 1)
//						IF integer(ls_checkmonth2) >= 13 THEN
//							ls_checkmonth2 = '01'
//							string(integer(ls_checkyear2) + 1)
//						END IF
//			Loop
//			
//			IF integer(ls_checkmonth2) = integer(M1) OR integer(ls_checkmonth2) = integer(M2) OR integer(ls_checkmonth2) = integer(M3) OR integer(ls_checkmonth2) = integer(M4) OR integer(ls_checkmonth2) = integer(M5) OR &
//      		integer(ls_checkmonth2) = integer(M6) OR integer(ls_checkmonth2) = integer(M7) OR integer(ls_checkmonth2) = integer(M8) OR integer(ls_checkmonth2) = integer(M9) OR integer(ls_checkmonth2) = integer(M10) OR &
//				integer(ls_checkmonth2) = integer(M11) OR integer(ls_checkmonth2) = integer(M12) THEN
//	 
//	         ls_checkmonth2 = string(long(ls_checkmonth2),'00')
//										/*생성 기준말일*/
//				IF ls_bejaday = '30' THEN
//					ls_Curdate =  ls_checkyear2 + ls_checkmonth2 + Right(f_last_date(ls_checkyear2 + ls_checkmonth2), 2)
//				ELSE
//					ls_Curdate = ls_checkyear2 + ls_checkmonth2 + ls_bejaday 	
//				END IF
//			END IF
//			
//			IF k = 1 THEN
//				ls_BeforeDate = ls_LendFrom
//				ld_LendRemain = ld_LendAmt
//			ELSE
//				IF ls_bejaday = '30' THEN
//        	   	ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + string('01')
//				ELSE
//					ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + string(integer(ls_bejaday) + 1, '00') 	
//				END IF
//				ld_LendRemain = dw_main.GetItemNumber(k - 1, "janamt")
//				IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
//			END IF
//			
//			li_DayCnt = DaysAfter(Date(String(ls_BeforeDate,"@@@@.@@.@@")),date(string(ls_CurDate,"@@@@.@@.@@"))) + 1
//			
//			ld_LendEja = truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0)
//			dw_main.SetItem(k, 'reteja', ld_LendEja)
//		next
		
//ELSEIF ls_pretyn = 'Y' AND ls_bretyn = 'Y' THEN
//
//END IF
ib_any_typing = True

//if dw_1.update() = 1 then
//	commit;
//else
//	messagebox("확 인", "이자 재계산을 실패하였습니다.")	
//	rollback;
//	return
//end if

w_mdi_frame.sle_msg.text = '이자를 재계산하였습니다.'






//Integer   li_RowCount, k, li_DayCnt
//Double    ld_LendEja, ld_LendAmt, ld_Rate, ld_LendRemain
//String    ls_CurDate, ls_BeforeDate, ls_LendDate
//
//IF dw_.AcceptText() = -1 THEN Return
//ls_LendDate = dw_ip.GetItemString(dw_ip.GetRow(), 'lenddate')
//ld_LendAmt  = dw_ip.GetItemDecimal(dw_ip.GetRow(), 'lendamt')
//ld_Rate     = dw_ip.GetItemDecimal(dw_ip.GetRow(), 'rate')
//IF IsNull(ld_LendAmt) THEN ld_LendAmt = 0
//IF IsNull(ld_Rate) THEN ld_Rate = 0
//
//li_RowCount = dw_main.RowCount()
//IF li_RowCount <=0 THEN Return
//
//FOR k = 1 TO li_RowCount
//	IF dw_main.GetItemString(k,"subgbn") = 'Y' THEN Continue
//	IF dw_main.GetItemString(k,"allretdate") <> '' AND Not IsNull(dw_main.GetItemString(k,"allretdate")) THEN Continue
//	
//	ls_CurDate = dw_main.GetItemString(k,"retdate")
//	IF k = 1 THEN
//		ls_BeforeDate = ls_LendDate
//		ld_LendRemain = ld_LendAmt
//	ELSE
//		ls_BeforeDate = Left(dw_main.GetItemString(k - 1, "retdate"), 6) + '11'
//		ld_LendRemain = dw_main.GetItemNumber(k - 1, "janamt")
//		IF IsNull(ld_LendRemain) THEN ld_LendRemain = 0
//	END IF
//	
//	li_DayCnt = DaysAfter(Date(String(ls_BeforeDate,"@@@@.@@.@@")),date(string(ls_CurDate,"@@@@.@@.@@"))) + 1
//	
//	ld_LendEja = Round(truncate((ld_LendRemain * li_DayCnt / 365 * (ld_Rate / 100)),0) / 10,0) * 10
//	dw_main.SetItem(k, 'reteja', ld_LendEja)
//next
//ib_any_typing = True
//
////if dw_1.update() = 1 then
////	commit;
////else
////	messagebox("확 인", "이자 재계산을 실패하였습니다.")	
////	rollback;
////	return
////end if
//
//w_mdi_frame.sle_msg.text = '이자를 재계산하였습니다.'
//
end event

type p_delrow from w_inherite_standard`p_delrow within w_pis2020
boolean visible = false
integer x = 3712
integer y = 492
integer taborder = 0
end type

type dw_insert from w_inherite_standard`dw_insert within w_pis2020
boolean visible = false
integer taborder = 0
end type

type st_window from w_inherite_standard`st_window within w_pis2020
integer taborder = 0
end type

type cb_exit from w_inherite_standard`cb_exit within w_pis2020
integer taborder = 0
end type

type cb_update from w_inherite_standard`cb_update within w_pis2020
integer taborder = 0
end type

type cb_insert from w_inherite_standard`cb_insert within w_pis2020
integer taborder = 0
end type

type cb_delete from w_inherite_standard`cb_delete within w_pis2020
integer taborder = 0
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pis2020
integer taborder = 0
end type

type st_1 from w_inherite_standard`st_1 within w_pis2020
boolean visible = false
integer x = 146
integer y = 2420
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pis2020
integer taborder = 0
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pis2020
end type

type sle_msg from w_inherite_standard`sle_msg within w_pis2020
end type

type gb_2 from w_inherite_standard`gb_2 within w_pis2020
end type

type gb_1 from w_inherite_standard`gb_1 within w_pis2020
end type

type gb_10 from w_inherite_standard`gb_10 within w_pis2020
end type

type dw_ip from u_key_enter within w_pis2020
event ue_key pbm_dwnkey
event ue_processenter pbm_dwnprocessenter
integer x = 69
integer y = 32
integer width = 2766
integer height = 176
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pis2020_1_c"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_processenter;send(handle(this), 255, 9, 0)
return 1
end event

event itemchanged;
String   ls_empno, ls_empname, ls_dept, ls_lenddate, ls_lendfrom, ls_lendgbn, ls_retgubun, snull, ls_consmat
Double   ld_lendamt, ld_lendmamt, ld_rate
SetNull(snull)

IF This.getcolumnname() = 'empno' THEN
	ls_empno = This.GetText()
	IF ls_empno = '' OR IsNull(ls_empno) THEN 
		This.SetItem(this.GetRow(), "empname",	snull)
		Return 
	END IF
	
  	SELECT M.empname, L.lenddate, L.lendgbn
	  INTO :ls_empname, :ls_lenddate, :ls_lendgbn
     FROM p1_master M,
	  		 p5_lendmst L
    WHERE M.empno = :ls_empno AND
	 		 M.empno = L.empno AND
			 L.lendkind = '1';

	This.SetItem(this.GetRow(), "empname", ls_empname)
	This.SetItem(this.GetRow(), "lenddate", ls_lenddate)
	This.SetItem(this.GetRow(), "lendgbn", ls_lendgbn)
	dw_main.Reset()

	select nvl(consmatgubn,'Y'), 	empname 		into :ls_consmat,				:ls_empname
		from p1_master where companycode = 'KN' and empno = :ls_EmpNo;
	if sqlca.sqlcode = 0 then
		if ls_consmat <> 'Y' then
			messagebox("확  인", "복지회에 가입되지 않은 사원입니다.")
			this.setitem(this.GetRow(), 'empno', snull)
			this.setitem(this.GetRow(), 'empname', snull)
			This.SetItem(this.GetRow(), "lenddate", snull)
			This.SetItem(this.GetRow(), "lendgbn", snull)
			
			p_ins.enabled = False
			p_ins.picturename = "C:\erpman\image\추가_d.gif"
			
			p_del.enabled = False
			p_del.picturename = "C:\erpman\image\삭제_d.gif"
	
			dw_main.Reset()
			this.setcolumn('empno')
			return 1
		end if
		this.setitem(this.GetRow(), "empname", 	ls_empname)	
	else
		messagebox("확  인", "등록되지 않은 사원입니다.")
		this.setitem(this.GetRow(), 'empno', snull)
		this.setitem(this.GetRow(), 'empname', snull)
		This.SetItem(this.GetRow(), "lenddate", snull)
		This.SetItem(this.GetRow(), "lendgbn", snull)
	
		dw_main.Reset()	
		this.setcolumn('empno')			
		return 1
	end if

   p_inq.TriggerEvent(Clicked!)
	IF dw_main.GetRow() <= 0 THEN
		MessageBox("확 인", "생성한 계획이 없습니다.")
		dw_main.Reset()
		p_del.enabled = False
		p_del.picturename = "C:\erpman\image\삭제_d.gif"
		dw_sub.setcolumn('pretyn')
		dw_sub.SetFocus()
	ELSE
		p_del.enabled = True
		p_del.picturename = "C:\erpman\image\삭제_up.gif"
	END IF
END IF		


//IF This.getcolumnname() = 'lenddate' THEN
//	ls_LendDate  = this.GetText()
//	if ls_LendDate = '' or IsNull(ls_LendDate) THEN Return
//	
//	ls_EmpNo = Trim(this.GetItemString(this.GetRow(),"empno"))
//	IF IsNull(ls_EmpNo) OR ls_EmpNo = '' THEN Return
//	
//  	SELECT M.empname, L.lenddate, L.lendgbn
//	  INTO :ls_empname, :ls_lenddate, :ls_lendgbn
//     FROM p1_master M,
//	  		 p5_lendmst L
//    WHERE M.empno = :ls_empno AND
//	 		 M.empno = L.empno AND
//			 L.lendkind = '1';
//
//	This.SetItem(This.GetRow(), "empname", ls_empname)
//	This.SetItem(This.GetRow(), "lenddate", ls_lenddate)
//	This.SetItem(This.GetRow(), "lendgbn", ls_lendgbn)
//
//	IF Sqlca.SqlCode <> 0 THEN
//		MessageBox("확  인", "등록된 복지회대출 신청 자료가 없습니다.")
//		This.SetItem(1, 'lenddate', snull)
//		This.SetColumn('lenddate')
//		
//		dw_main.Reset()
//		Return 1
//	END IF
//	p_inq.TriggerEvent(Clicked!)
//end if		
//
//IF this.GetcolumnName() ="lenddate" THEN
//	IF IsNull(data) OR data ="" THEN
//		Return 1
//   END IF
//	If f_datechk(data) = -1 THEN
//		MessageBox("확 인", "대출일자가 부정확합니다.")
//		SetItem(getrow(),'lenddate',snull)
//		SetColumn('lenddate')
//		dw_ip.SetFocus()
//		Return 1
//	END IF
//END IF
//


end event

event rbuttondown;string ls_consmat, ls_empname, ls_empno, snull

SetNull(snull)


if this.getcolumnname() = 'empno' then
	SetNull(Gs_Code);	SetNull(Gs_CodeName);
	SetNull(Gs_gubun)
	
	Gs_gubun = is_saupcd
	open(w_employee_popup_pis2020)
	
	IF IsNull(Gs_code) THEN Return
	
	this.SetItem(this.GetRow(),"empno",   Gs_code)
	this.SetItem(this.GetRow(),"empname", Gs_codename)
	this.TriggerEvent(ItemChanged!)
		
END IF

end event

event getfocus;call super::getfocus;this.AcceptText()
end event

event itemerror;call super::itemerror;Return 1
end event

type dw_main from u_key_enter within w_pis2020
integer x = 1531
integer y = 768
integer width = 3058
integer height = 1472
integer taborder = 130
boolean bringtotop = true
string dataobject = "d_pis2020_1"
boolean vscrollbar = true
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event retrieveend;call super::retrieveend;//Double    dRetAmt,dAllRetAmt,dLendAmt
//Integer   k
//
//if rowcount <=0 then Return
//
//for k = 1 To rowcount
//	if k = 1 then
//		dLendAmt = this.GetItemNumber(k,"lendamt")
//	else
//		dLendAmt = this.GetItemNumber(k - 1,"janamt")
//	end if
//	if IsNull(dLendAmt) then dLendAmt = 0
//	
//	dRetAmt = this.GetItemNumber(k,"retamt")
//	if IsNull(dRetAmt) then dRetAmt = 0
//	
//	dAllRetAmt = this.GetItemNumber(k,"retallamt")
//	if IsNull(dAllRetAmt) then dAllRetAmt = 0
//	
//	this.SetItem(this.GetRow(),"janamt", dLendAmt - dRetAmt - dAllRetAmt)
//next
//
end event

event itemchanged;call super::itemchanged;string snull, ls_allret, ls_reteja, ls_retamt, ls_empno, ls_lendgbn, ls_paygbn
Decimal ld_allret, ld_janamt0, ld_janamt, ld_LendAmt, dnull, ld_jan
String ls_lenddate

SetNull(snull)
SetNull(dnull)

ls_empno = dw_sub.GetItemString(dw_sub.GetRow(), "empno")
ls_lenddate = dw_sub.GetItemString(dw_sub.GetRow(), "lenddate")
ls_lendgbn = dw_sub.GetItemString(dw_sub.GetRow(), "lendgbn")
Ld_LendAmt = dw_sub.GetItemDecimal(dw_sub.GetRow(), "lendamt")

IF this.GetColumnName() = 'retamt' THEN
	ls_retamt = this.GetText()
	
	SELECT MIN(janamt)
  	  INTO :ld_janamt0
	  FROM p5_lendsch
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND
			 subgbn = 'Y' AND
			 paygubun like '%';
			 
	THIS.SetItem(this.GetRow(), 'janamt', ld_janamt0 - long(ls_retamt)) 
END IF

IF this.GetcolumnName() ="retdate" THEN
	ls_LendDate = dw_sub.GetItemString(dw_sub.GetRow(),'lenddate')
	IF IsNull(data) OR data ="" THEN
		Return 1
   END IF
	If f_datechk(data) = -1 THEN
		MessageBox("확 인", "상환일자가 부정확합니다.")
		SetItem(getrow(),'retdate',snull)
		SetColumn('retdate')
		dw_ip.SetFocus()
		Return 1
	END IF
	IF long(data) <= long(ls_lenddate) THEN
		MessageBox("확 인", "상환일자는 대출일자보다 커야합니다.")
		SetItem(getrow(),'retdate',snull)
		SetColumn('retdate')
		dw_ip.SetFocus()
		Return 1
	END IF
	IF this.GetItemString(This.GetRow(), 'paygubun') = 'X' OR this.GetItemString(This.GetRow(), 'paygubun') = 'E' THEN
   	dw_main.SetItem(dw_main.GetRow(), 'allretdate', data)
		dw_main.SetItem(dw_main.GetRow(), 'retgbn', '2')
	END IF
	
END IF

IF this.GetColumnName() = 'paygubun' THEN
	ls_paygbn = this.GetText()
	IF data = 'P' OR data = 'B' THEN
		dw_main.SetItem(dw_main.GetRow(), 'retgbn', '1')
		IF dw_main.GetItemString(dw_main.GetRow(), 'subgbn') = 'N' THEN
			dw_main.Modify("retamt.protect = 0")
			dw_main.Modify("allretamt.protect = 1")
			dw_main.Modify("reteja.protect = 0")
		END IF
	ELSEif data = 'X' OR data = 'E' THEN
		dw_main.SetItem(dw_main.GetRow(), 'retgbn', '2')
		IF dw_main.GetItemString(dw_main.GetRow(), 'subgbn') = 'N' THEN
			dw_main.Modify("retamt.protect = 1")
			dw_main.Modify("allretamt.protect = 0")
			dw_main.Modify("reteja.protect = 0")
		END IF
	END IF
END IF

	
IF this.GetColumnName() = 'reteja' THEN
	IF this.GetItemString(This.GetRow(), 'paygubun') = 'X' OR this.GetItemString(This.GetRow(), 'paygubun') = 'E' THEN
   	This.SetItem(this.GetRow(), 'allreteja', long(data))
	END IF	
	IF IsNUll(long(data)) THEN data = '0'
END IF


IF this.GetColumnName() = 'allretamt' THEN
   ls_allret = this.GetText()
	
	IF IsNull(long(ls_allret)) OR long(ls_allret) = 0 THEN
		MessageBox("확인", "일시상환액을 입력하십시오.")
		Return 1
	END IF
	
	SELECT MIN(janamt)	
	  INTO :ld_jan	
	  FROM p5_lendsch 
	 WHERE lendgbn = :ls_LendGbn AND
			 empno = :ls_EmpNo AND 
			 lenddate = :ls_LendDate AND
			 lendkind = '1' AND 
			 paygubun like '%' AND
			 subgbn = 'Y';
	
	IF this.RowCount() > 1 THEN
		IF LONG(ls_allret) > LONG(ld_janamt) THEN
			MessageBox("확 인", "현잔액보다 작아야 합니다.")
			this.SetItem(this.GetRow(), 'allretamt', dnull)
			Return 1
		END IF
	ELSE
		IF LONG(ls_allret) > LONG(ld_LendAmt) THEN
			MessageBox("확 인", "현잔액보다 작아야 합니다.")
			this.SetItem(this.GetRow(), 'allretamt', dnull)
			Return 1
		END IF
	END IF
	
	IF dw_main.RowCount() > 1 THEN 
   	ld_janamt = dw_main.GetItemDecimal(this.GetRow() - 1, 'janamt')
	ELSE
		ld_janamt = dw_sub.GetItemDecimal(dw_sub.GetRow(), 'lendamt')
	END IF
	ld_janamt = ld_janamt - long(ls_allret)
	This.SetItem(this.GetRow(), 'janamt', ld_janamt)
	
END IF

end event

type rr_1 from roundrectangle within w_pis2020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1518
integer y = 760
integer width = 3081
integer height = 1488
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_remain from uo_picture within w_pis2020
boolean visible = false
integer x = 3854
integer y = 312
integer width = 178
string picturename = "C:\erpman\image\잔액재계산_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\잔액재계산_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\잔액재계산_up.gif"
end event

type dw_sub from u_key_enter within w_pis2020
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 1499
integer y = 224
integer width = 3099
integer height = 496
integer taborder = 120
boolean bringtotop = true
string dataobject = "d_pis2020_2"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

type dw_list from u_d_popup_sort within w_pis2020
integer x = 27
integer y = 232
integer width = 1449
integer height = 2012
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pis2020_3"
boolean border = false
end type

event itemerror;call super::itemerror;RETURN 1
end event

event rowfocuschanged;call super::rowfocuschanged;If currentrow <= 0 then
	dw_sub.SelectRow(0,False)

ELSE

	SelectRow(0, FALSE)
	SelectRow(currentrow,TRUE)
	
	dw_sub.ScrollToRow(currentrow)
END IF

end event

event clicked;call super::clicked;
string ls_empno, ls_empname, ls_lenddate, ls_lendgbn, ls_lendgbn2, ls_pretyn, ls_bretyn, snull, ls_retgubun

IF dw_list.GetClickedrow() > 0 THEN
ls_empno = this.GetItemString(this.GetClickedRow(), 'empno')
ls_empname = this.GetItemString(this.GetClickedRow(), 'empname')
ls_lenddate = this.GetItemString(this.GetClickedRow(), 'lenddate')
ls_lendgbn = this.GetItemString(this.GetClickedRow(), 'lendgbn')
ls_lendgbn2 = dw_sub.GetItemString(this.GetClickedRow(), 'lendgbn')
ls_retgubun = dw_sub.GetItemString(this.GetClickedRow(), 'retgubun')
//ls_bretyn = dw_list.GetItemString(this.GetClickedRow(), 'bretyn')
//ls_pretyn = dw_list.GetItemString(this.GetClickedRow(), 'pretyn')
//

SetNull(snull)

p_addrow.enabled = True
p_addrow.picturename = "C:\erpman\image\이자재계산_up.gif"

IF ls_retgubun = '4' THEN
	p_search.enabled = True
	p_search.picturename = "C:\erpman\image\생성_up.gif"
	
	p_ins.enabled = True
	p_ins.picturename = "C:\erpman\image\추가_up.gif"
ELSE
	p_search.enabled = False
	p_search.picturename = "C:\erpman\image\생성_d.gif"
	
	p_ins.enabled = False
	p_ins.picturename = "C:\erpman\image\추가_d.gif"
END IF

ib_any_typing = False


IF ls_lendgbn2 = '1' THEN
	dw_sub.SetItem(dw_list.GetClickedRow(), 'pretyn', 'Y')
	dw_sub.SetItem(dw_list.GetClickedRow(), 'bretyn', 'N')
ELSEIF ls_lendgbn2 = '2' THEN
   dw_sub.SetItem(dw_list.GetClickedRow(), 'pretyn', 'Y')
	dw_sub.SetItem(dw_list.GetClickedRow(), 'bretyn', 'Y')
ELSE
	dw_sub.SetItem(dw_list.GetClickedRow(), 'pretyn', 'N')
	dw_sub.SetItem(dw_list.GetClickedRow(), 'bretyn', 'N')
END IF

dw_sub.SetItem(dw_list.GetClickedRow(), 'pejaday', '10')
dw_sub.SetItem(dw_list.GetClickedRow(), 'bejaday', '30')
dw_sub.SetItem(dw_list.GetClickedRow(), 'm2', '2')
dw_sub.SetItem(dw_list.GetClickedRow(), 'm4', '4')
dw_sub.SetItem(dw_list.GetClickedRow(), 'm6', '6')
dw_sub.SetItem(dw_list.GetClickedRow(), 'm8', '8')
dw_sub.SetItem(dw_list.GetClickedRow(), 'm10', '10')
dw_sub.SetItem(dw_list.GetClickedRow(), 'm12', '12')

ls_bretyn = dw_list.GetItemString(this.GetClickedRow(), 'bretyn')
ls_pretyn = dw_list.GetItemString(this.GetClickedRow(), 'pretyn')

IF ls_pretyn = 'Y' THEN
	IF ls_bretyn = 'Y' THEN
		dw_sub.SetItem(dw_list.GetClickedRow(), 'prettag', '3')
		dw_sub.SetItem(dw_list.GetClickedRow(), 'brettag', '2')
		
		p_addrow.enabled = True
		p_addrow.picturename = "C:\erpman\image\이자재계산_up.gif"
		
		p_search.enabled = True
		p_search.picturename = "C:\erpman\image\생성_up.gif"
		
		p_ins.enabled = True
		p_ins.picturename = "C:\erpman\image\추가_up.gif"
		
	ELSEIF ls_bretyn = 'N' THEN
		dw_sub.SetItem(dw_list.GetClickedRow(), 'prettag', '1')
		dw_sub.SetItem(dw_list.GetClickedRow(), 'brettag', snull)
		
		p_addrow.enabled = True
		p_addrow.picturename = "C:\erpman\image\이자재계산_up.gif"
		
		p_search.enabled = True
		p_search.picturename = "C:\erpman\image\생성_up.gif"
		
		p_ins.enabled = True
		p_ins.picturename = "C:\erpman\image\추가_up.gif"
		
	END IF
ELSEIF ls_pretyn = 'N' THEN
	IF ls_bretyn = 'Y' THEN
		dw_sub.SetItem(dw_list.GetClickedRow(), 'prettag', snull)
		dw_sub.SetItem(dw_list.GetClickedRow(), 'brettag', '1')
		
		p_addrow.enabled = True
		p_addrow.picturename = "C:\erpman\image\이자재계산_up.gif"
		
		p_search.enabled = True
		p_search.picturename = "C:\erpman\image\생성_up.gif"
		
		p_ins.enabled = True
		p_ins.picturename = "C:\erpman\image\추가_up.gif"
		
	ELSEIF ls_bretyn = 'N' THEN
		dw_sub.SetItem(dw_list.GetClickedRow(), 'prettag', snull)
		dw_sub.SetItem(dw_list.GetClickedRow(), 'brettag', snull)
		
		p_addrow.enabled = False
		p_addrow.picturename = "C:\erpman\image\이자재계산_d.gif"
		
		p_search.enabled = False
		p_search.picturename = "C:\erpman\image\생성_d.gif"
		
		p_ins.enabled = True
		p_ins.picturename = "C:\erpman\image\추가_UP.gif"
	END IF
END IF


If Row <= 0 then
	dw_sub.SelectRow(0,False)
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_sub.ScrollToRow(row)
	dw_sub.setcolumn('pretyn')
	dw_sub.Setfocus()
	
	Lb_AutoFlag = False
		
END IF

dw_ip.SetItem(1, 'empno', ls_empno)
dw_ip.SetItem(1, 'empname', ls_empname)
dw_ip.SetItem(1, 'lenddate', ls_lenddate)
dw_ip.SetItem(1, 'lendgbn', ls_lendgbn)



//dw_main.SetReDraw(False)
IF dw_main.retrieve(ls_empno, ls_lenddate, ls_lendgbn) < 1 THEN
	MessageBox("확 인", "생성한 계획이 없습니다.")
	dw_main.Reset()
	p_del.enabled = False
	p_del.picturename = "C:\erpman\image\삭제_d.gif"
	return -1
ELSE
	p_del.enabled = True
	p_del.picturename = "C:\erpman\image\삭제_up.gif"
END IF
END IF
//dw_main.SetReDraw(True)

end event

type rr_2 from roundrectangle within w_pis2020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 224
integer width = 1467
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

