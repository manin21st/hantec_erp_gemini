$PBExportHeader$w_kfia63.srw
$PBExportComments$차입금 상환계획 등록2
forward
global type w_kfia63 from w_inherite
end type
type dw_list from datawindow within w_kfia63
end type
type gb_5 from groupbox within w_kfia63
end type
type dw_mst from datawindow within w_kfia63
end type
type p_1 from picture within w_kfia63
end type
type p_2 from picture within w_kfia63
end type
type p_3 from picture within w_kfia63
end type
type p_4 from picture within w_kfia63
end type
type p_calc from uo_picture within w_kfia63
end type
type p_remain from uo_picture within w_kfia63
end type
type p_calc_rs from uo_picture within w_kfia63
end type
type p_calc_plan from uo_picture within w_kfia63
end type
type p_plan_pay from uo_picture within w_kfia63
end type
type rr_1 from roundrectangle within w_kfia63
end type
type rr_2 from roundrectangle within w_kfia63
end type
end forward

global type w_kfia63 from w_inherite
string title = "차입금 상환계획 등록"
dw_list dw_list
gb_5 gb_5
dw_mst dw_mst
p_1 p_1
p_2 p_2
p_3 p_3
p_4 p_4
p_calc p_calc
p_remain p_remain
p_calc_rs p_calc_rs
p_calc_plan p_calc_plan
p_plan_pay p_plan_pay
rr_1 rr_1
rr_2 rr_2
end type
global w_kfia63 w_kfia63

forward prototypes
public function integer wf_create_plan_pay ()
public subroutine wf_change_flag (boolean arg_mode)
public function integer wf_create_plan_pay1 ()
public function integer wf_create_plan_pay2 ()
public function integer wf_delete_data (string sflag)
public function integer wf_insert_kfm03ot1 (string sflag, string scode, string sdate, double damount, double damountf, double drate, double dremain, double dremainf, string smaxdate)
public function integer wf_calc_rs (string sflag)
public function integer wf_create_plan ()
end prototypes

public function integer wf_create_plan_pay ();Integer iTermMnF
String  sFirstFdate,sICondCd
Double  dChaIpAmtW

dw_mst.AcceptText()
sICondCd    = dw_mst.GetItemString(1,"icond_cd")										/*이자지급방법*/
iTermMnF    = dw_mst.GetItemNumber(1,"ejugi")
sFirstFdate = Trim(dw_mst.GetItemString(1,"jigub_date"))
dChaIpAmtW  = dw_mst.GetItemNumber(1,"lo_camt")
IF IsNull(dChaIpAmtW) THEN dChaIpAmtW = 0

IF iTermMnF = 0 OR IsNull(iTermMnF) THEN
	F_MessageChk(1,'[지급주기]')
	dw_mst.SetColumn("lo_cd")
	dw_mst.Setfocus()
	Return -1
END IF 

IF sFirstFdate = '' OR IsNull(sFirstFdate) THEN
	F_MessageChk(1,'[최초지급일]')
	dw_mst.SetColumn("lo_cd")
	dw_mst.Setfocus()
	Return -1
END IF 

IF dChaIpAmtW = 0 OR IsNull(dChaIpAmtW) THEN
	F_MessageChk(1,'[차입금액]')
	dw_mst.SetColumn("lo_cd")
	dw_mst.Setfocus()
	Return -1
END IF 
if sICondCd = '1' then
	IF Wf_Create_Plan_Pay1() = -1 THEN 								/*이자 선급*/
		
		Return -1
	END IF	
else
	IF Wf_Create_Plan_Pay2() = -1 THEN 								/*이자 후급*/
		
		Return -1
	END IF		
end if

Return 1


end function

public subroutine wf_change_flag (boolean arg_mode);boolean lb_mode
long k,iCount

lb_mode = arg_mode

if not lb_mode then 
	iCount = dw_list.RowCount()
	
	FOR k = 1 TO iCount
		
		dw_list.SetItem(k,"flag",'0')
		
	NEXT
end if
end subroutine

public function integer wf_create_plan_pay1 ();
String    sLoCd,sLoFrom,sLoTo,sLoADay,sCurr,sFirstFDate,sCalcFromF,sCurDatef,sBaseCalcDate,sMaxFeeDate,sRsDate,sMaxItDate
Double    dLoRate,dChaipAmtW,dChaipAmtF,dCur_Camt,dCur_YcAmt,dRemainW,dRemainF,dCalcIja,dCalcIjaF,dSumIt,dSumItY
Integer   iTermMnF,iDay,iCalcYear,iCalcMonth,iTotalDays

dw_mst.AcceptText()
sLoCd       = dw_mst.GetItemString(1,"lo_cd")
dLoRate     = dw_mst.GetItemNumber(1,"lo_rat")
sLoFrom     = Trim(dw_mst.GetItemString(1,"lo_afdt"))
sLoTo       = Trim(dw_mst.GetItemString(1,"lo_atdt"))

sCurr       = dw_mst.GetItemString(1,"lo_curr")

sLoADay     = dw_mst.GetItemString(1,"lo_aday")											/*이자지급일자*/

iTermMnF    = dw_mst.GetItemNumber(1,"ejugi")
sFirstFdate = Trim(dw_mst.GetItemString(1,"jigub_date"))

dChaIpAmtW  = dw_mst.GetItemNumber(1,"lo_camt")
dChaIpAmtF  = dw_mst.GetItemNumber(1,"lo_ycamt")
IF IsNull(dChaIpAmtW) THEN dChaIpAmtW = 0
IF IsNull(dChaIpAmtF) THEN dChaIpAmtF = 0

IF iTermMnF = 0 OR IsNull(iTermMnF) THEN
	F_MessageChk(1,'[지급주기]')
	dw_mst.SetColumn("lo_cd")
	dw_mst.Setfocus()
	Return -1
END IF 

IF sFirstFdate = '' OR IsNull(sFirstFdate) THEN
	F_MessageChk(1,'[최초지급일]')
	dw_mst.SetColumn("lo_cd")
	dw_mst.Setfocus()
	Return -1
END IF 

IF dChaIpAmtW = 0 OR IsNull(dChaIpAmtW) THEN
	F_MessageChk(1,'[차입금액]')
	dw_mst.SetColumn("lo_cd")
	dw_mst.Setfocus()
	Return -1
END IF 

IF dw_list.RowCount() > 0 THEN
	dSumIt  = dw_list.GetItemNumber(1,"sum_itamt")
	dSumItY = dw_list.GetItemNumber(1,"sum_itamty")
	IF IsNull(dSumIt) THEN dSumIt   = 0
	IF IsNull(dSumItY) THEN dSumItY = 0
ELSE
	dSumIt   = 0;			dSumItY = 0;
END IF

IF dSumIt <> 0 OR dSumItY <> 0 THEN
	sMaxItDate = dw_list.GetItemString(1,"max_itdate")
	IF IsNull(sMaxItDate) OR sMaxItDate = '0' THEn sMaxItDate = ''
END IF

IF IsNull(dLoRate) THEN dLoRate = 0

w_mdi_frame.sle_msg.text = '상환 계획(이자) 생성 중...'
SetPointer(HourGlass!)

IF sMaxItDate <> '' and Not IsNull(sMaxItDate) and sMaxItDate <> '0' THEN			/*2001.06.19 추가*/
	iCalcYear   = Integer(Left(sMaxItDate,4))	
	iCalcMonth  = Integer(Mid(sMaxItDate,5,2))
	
	sCalcFromF  = sMaxItDate
	sCurDateF   = sMaxItDate
	iDay = Integer(Right(sMaxItDate,2))
ELSE
	iCalcYear   = Integer(Left(sLoFrom,4))						/*차입일자 => 년,월,일*/
	iCalcMonth  = Integer(Mid(sLoFrom,5,2))
	
	sCalcFromF  = sFirstFdate
	sCurDateF   = sFirstFdate
	
	iDay = Integer(sLoADay)
END IF

Do	
	select sum(nvl(rs_camt,0)),		sum(nvl(rs_ycamt,0))									/*처리년월 현재 상환금액*/
		into :dCur_CAmt,					:dCur_YcAmt
		from kfm03ot1
		where lo_cd = :sLoCd and substr(rs_date,1,6) <= substr(:sCalcFromF,1,6) ;
	
	if sqlca.sqlcode <> 0 then
		dCur_Camt = 0;			dCur_YcAmt = 0;
	else
		if IsNull(dCur_Camt) then dCur_Camt = 0
		if IsNull(dCur_YCamt) then dCur_YCamt = 0
	end if
	
	IF sCurr = 'WON' THEN
		dRemainW = dChaIpAmtW - dCur_Camt															/*현재 잔액*/
		dRemainF = 0
		IF dRemainW <=0 THEN Exit
	ELSE
		dRemainW = 0
		dRemainF = dChaIpAmtF - dCur_YCamt
		IF dRemainF <=0 THEN Exit
	END IF

	IF sMaxItDate = sCurDateF THEN
		IF Integer(Mid(sCurDateF,5,2)) + iTermMnF > 12 THEN
			sCalcFromF = String(Long(Left(sCurDateF,4)) + 1,'0000')+ String(Integer(Mid(sCurDateF,5,2)) + iTermMnF - 12,'00')+ String(iDay,'00')
		ELSE
			sCalcFromF = Left(sCurDateF,4) + String(Integer(Mid(sCurDateF,5,2)) + iTermMnF,'00')+String(iDay,'00')
		END IF
		sCurDateF = sCalcFromF
		
		iCalcYear   = Integer(Left(sCalcFromF,4))						
		iCalcMonth  = Integer(Mid(sCalcFromF,5,2))
	ELSE		
		/*이자 계산*/
		IF Left(sCalcFromF,6) = Left(sCurDateF,6) THEN
			select nvl(max(rs_pdate),'')
				into :sMaxFeeDate
				from kfm03ot1
				where lo_cd = :sLoCd and rs_date < :sCurDateF and (nvl(rs_itamt,0) <> 0 or nvl(rs_yitamt,0) <> 0);
			if sqlca.sqlcode <> 0 then
				sMaxFeeDate = sLoFrom
			else
				if IsNull(sMaxFeeDate) or sMaxFeeDate = '' then sMaxFeeDate = sLoFrom
			end if
			
			IF Integer(Mid(sCurDateF,5,2)) + iTermMnF > 12 THEN
				sBaseCalcDate = String(Long(Left(sCurDateF,4)) + 1,'0000')+ String(Integer(Mid(sCurDateF,5,2)) + iTermMnF - 12,'00')+ String(iDay,'00')
			ELSE
				sBaseCalcDate = Left(sCurDateF,4) + String(Integer(Mid(sCurDateF,5,2)) + iTermMnF,'00')+String(iDay,'00')
			END IF
			/*계산된 날짜가 유효한 날짜가 아니면 그달의 마지막 날짜:2001.07.07*/
			IF IsDate(sBaseCalcDate) = False THEN
				sBaseCalcDate = F_Last_Date(Left(sBaseCalcDate,6))
			END IF
			IF sBaseCalcDate > sLoTo THEN
				sBaseCalcDate = sLoTo
			END IF
			
			IF sBaseCalcDate <= sLoto then
				iTotalDays = DaysAfter(Date(Left(sMaxFeeDate,4)+'.'+Mid(sMaxFeeDate,5,2)+'.'+Right(sMaxFeeDate,2)),&
											  Date(Left(sBaseCalcDate,4)+'.'+Mid(sBaseCalcDate,5,2)+'.'+Right(sBaseCalcDate,2)))
				/*일수 계산 :2001.07.04수정 => +1 안함*/
				IF sCurr = 'WON' THEN
					dCalcIja  = dRemainW * (iTotalDays / 365) * (dLoRate / 100)				/*이자 금액*/
					dCalcIjaF = 0
				ELSE
					dCalcIja  = 0
					dCalcIjaF = dRemainF * (iTotalDays / 360) * (dLoRate / 100)				/*이자 금액-외화*/ 
				END IF
				
				sRsDate = sCurDateF
				IF Wf_Insert_Kfm03ot1('IJA',sLoCd,sRsDate,dCalcIja,dCalcIjaF,dLoRate,dRemainW,dRemainF,sBaseCalcDate) = -1 THEN
					F_MessageChk(13,'[차입금 이자]')
					rollback;
					Return -1
				END IF
				
				IF iCalcMonth + 1 > 12 THEN
					iCalcYear = iCalcYear + 1;		iCalcMonth = 1;
				ELSE
					iCalcYear = iCalcYear;			iCalcMonth = iCalcMonth + 1
				END IF
				
				if IsDate(String(iCalcYear,'0000')+'.'+String(iCalcMonth,'00')+'.'+sLoADay) = False then		/*계산 기준일*/
					sCurDateF = F_Last_Date(String(iCalcYear,'0000')+String(iCalcMonth,'00'))
				else
					sCurDateF = String(iCalcYear,'0000')+String(iCalcMonth,'00')+sLoADay
				end if			
			END IF
			
			sCalcFromF = sBaseCalcDate
		ELSE
			IF iCalcMonth + 1 > 12 THEN
				iCalcYear = iCalcYear + 1;		iCalcMonth = 1;
			ELSE
				iCalcYear = iCalcYear;			iCalcMonth = iCalcMonth + 1
			END IF
			
			if IsDate(String(iCalcYear,'0000')+'.'+String(iCalcMonth,'00')+'.'+sLoADay) = False then		/*계산 기준일*/
				sCurDateF = F_Last_Date(String(iCalcYear,'0000')+String(iCalcMonth,'00'))
			else
				sCurDateF = String(iCalcYear,'0000')+String(iCalcMonth,'00')+sLoADay
			end if			
		END IF
	END IF
Loop While Left(sLoTo,6) >= Left(sCalcFromF,6)
w_mdi_frame.sle_msg.text = '상환 계획(이자) 생성 완료'
SetPointer(Arrow!)

Return 1


end function

public function integer wf_create_plan_pay2 ();Integer iTermMnF,iDay,iCalcYear,iCalcMonth,iTotalDays
String  sCurr,sLoCd,sFirstFdate,sLoFrom,sLoTo,sCurDateF,sCurDateW,sCalcFromW,sCalcFromF,sMaxFeeDate,sRsDate,&
		  sICondCd,sLoADay,sBaseCalcDate,sMaxItDate
Double  dChaIpAmtW,dChaIpAmtF,dCalcIja =0,dCalcIjaF,dLoRate,dRemainW,dRemainF,dCur_CAmt,dCur_YcAmt,dSumIt,dSumItY

dw_mst.AcceptText()
sLoCd       = dw_mst.GetItemString(1,"lo_cd")
dLoRate     = dw_mst.GetItemNumber(1,"lo_rat")
sLoFrom     = Trim(dw_mst.GetItemString(1,"lo_afdt"))
sLoTo       = Trim(dw_mst.GetItemString(1,"lo_atdt"))
sCurr       = dw_mst.GetItemString(1,"lo_curr")
sICondCd    = dw_mst.GetItemString(1,"icond_cd")										/*이자지급방법*/
sLoADay     = dw_mst.GetItemString(1,"lo_aday")											/*이자지급일자*/

iTermMnF    = dw_mst.GetItemNumber(1,"ejugi")
sFirstFdate = Trim(dw_mst.GetItemString(1,"jigub_date"))

dChaIpAmtW  = dw_mst.GetItemNumber(1,"lo_camt")
dChaIpAmtF  = dw_mst.GetItemNumber(1,"lo_ycamt")
IF IsNull(dChaIpAmtW) THEN dChaIpAmtW = 0
IF IsNull(dChaIpAmtF) THEN dChaIpAmtF = 0

IF iTermMnF = 0 OR IsNull(iTermMnF) THEN
	F_MessageChk(1,'[지급주기]')
	dw_mst.SetColumn("lo_cd")
	dw_mst.Setfocus()
	Return -1
END IF 

IF sFirstFdate = '' OR IsNull(sFirstFdate) THEN
	F_MessageChk(1,'[최초지급일]')
	dw_mst.SetColumn("lo_cd")
	dw_mst.Setfocus()
	Return -1
END IF 

IF dChaIpAmtW = 0 OR IsNull(dChaIpAmtW) THEN
	F_MessageChk(1,'[차입금액]')
	dw_mst.SetColumn("lo_cd")
	dw_mst.Setfocus()
	Return -1
END IF 

IF dw_list.RowCount() > 0 THEN
	dSumIt  = dw_list.GetItemNumber(1,"sum_itamt")
	dSumItY = dw_list.GetItemNumber(1,"sum_itamty")
	IF IsNull(dSumIt) THEN dSumIt   = 0
	IF IsNull(dSumItY) THEN dSumItY = 0
ELSE
	dSumIt   = 0;			dSumItY = 0;
END IF

IF dSumIt <> 0 OR dSumItY <> 0 THEN
	sMaxItDate = dw_list.GetItemString(1,"max_itdate")
	IF IsNull(sMaxItDate) OR sMaxItDate = '0' THEn sMaxItDate = ''
END IF

IF IsNull(dLoRate) THEN dLoRate = 0

w_mdi_frame.sle_msg.text = '상환 계획(이자) 생성 중...'
SetPointer(HourGlass!)

IF sMaxItDate <> '' and Not IsNull(sMaxItDate) and sMaxItDate <> '0' THEN			/*2001.06.19 추가*/
	iCalcYear   = Integer(Left(sMaxItDate,4))	
	iCalcMonth  = Integer(Mid(sMaxItDate,5,2))
	
	sCalcFromF  = sMaxItDate
	sCurDateF   = sMaxItDate
ELSE
	iCalcYear   = Integer(Left(sLoFrom,4))						/*차입일자 => 년,월,일*/
	iCalcMonth  = Integer(Mid(sLoFrom,5,2))
	
	sCalcFromF  = sFirstFdate
	sCurDateF   = sFirstFdate
END IF

Do	
	select sum(nvl(rs_camt,0)),		sum(nvl(rs_ycamt,0))									/*처리년월 현재 상환금액*/
		into :dCur_CAmt,					:dCur_YcAmt
		from kfm03ot1
		where lo_cd = :sLoCd and substr(rs_date,1,6) < substr(:sCalcFromF,1,6) ;
	if sqlca.sqlcode <> 0 then
		dCur_Camt = 0;			dCur_YcAmt = 0;
	else
		if IsNull(dCur_Camt) then dCur_Camt = 0
		if IsNull(dCur_YCamt) then dCur_YCamt = 0
	end if
	
	IF sCurr = 'WON' THEN
		dRemainW = dChaIpAmtW - dCur_Camt															/*현재 잔액*/
		dRemainF = 0
	ELSE
		dRemainW = 0
		dRemainF = dChaIpAmtF - dCur_YCamt
	END IF
	
	IF sMaxItDate = sCalcFromF THEN
		iCalcYear   = Integer(Left(sMaxItDate,4))	
		iCalcMonth  = Integer(Mid(sMaxItDate,5,2))	
		
		iDay = Integer(Right(sMaxItDate,2))
	ELSE	
		IF Left(sCalcFromF,6) = Left(sLoFrom,6) THEN
			iCalcYear   = Integer(Left(sLoFrom,4))	
			iCalcMonth  = Integer(Mid(sLoFrom,5,2))	
		ELSE
			IF iCalcMonth + 1 > 12 THEN
				iCalcYear = iCalcYear + 1;		iCalcMonth = 1;
			ELSE
				iCalcYear = iCalcYear;			iCalcMonth = iCalcMonth + 1
			END IF
		END IF
		
		if String(iCalcYear,'0000')+String(iCalcMonth,'00') = Left(sLoTo,6) THEN
			iDay = Integer(Right(sLoTo,2))
		else
			iDay = Integer(Right(sFirstFdate,2))
		end if	
	END IF
	
	if IsDate(String(iCalcYear,'0000')+'.'+String(iCalcMonth,'00')+'.'+String(iDay,'00')) = False then
		sCurDateF = F_Last_Date(String(iCalcYear,'0000')+String(iCalcMonth,'00'))
	else
		sCurDateF = String(iCalcYear,'0000')+String(iCalcMonth,'00')+String(iDay,'00')
	end if
	sBaseCalcDate = sCurDateF
	
	IF sMaxItDate = sCalcFromF THEN		
		IF Integer(Mid(sCurDateF,5,2)) + iTermMnF > 12 THEN
			sCalcFromF = String(Long(Left(sCurDateF,4)) + 1,'0000')+ String(Integer(Mid(sCurDateF,5,2)) + iTermMnF - 12,'00')+ String(iDay,'00')
		ELSE
			sCalcFromF = Left(sCurDateF,4) + String(Integer(Mid(sCurDateF,5,2)) + iTermMnF,'00')+String(iDay,'00')
		END IF
	ELSE
		/*이자 계산*/
		IF Left(sCalcFromF,6) = Left(sCurDateF,6) THEN 
			select max(rs_pdate) into :sMaxFeeDate
				from kfm03ot1
				where lo_cd = :sLoCd and rs_date <= :sCurDateF and
						(nvl(rs_itamt,0) <> 0 or nvl(rs_yitamt,0) <> 0);
			if sqlca.sqlcode <> 0 then
				sMaxFeeDate = sLoFrom
			else
				if IsNull(sMaxFeeDate) or sMaxFeeDate = '' then sMaxFeeDate = sLoFrom
			end if
			
			iTotalDays = DaysAfter(Date(Left(sMaxFeeDate,4)+'.'+Mid(sMaxFeeDate,5,2)+'.'+Right(sMaxFeeDate,2)),&
										  Date(Left(sBaseCalcDate,4)+'.'+Mid(sBaseCalcDate,5,2)+'.'+Right(sBaseCalcDate,2)))
			/*일수 계산 :2001.07.04수정 => +1 안함*/
			IF sCurr = 'WON' THEN
				dCalcIja  = dRemainW * (iTotalDays / 365) * (dLoRate / 100)				/*이자 금액*/
				dCalcIjaF = 0
			ELSE
				dCalcIja  = 0
				dCalcIjaF = dRemainF * (iTotalDays / 360) * (dLoRate / 100)				/*이자 금액-외화*/ 
			END IF
			
			IF Integer(Mid(sCurDateF,5,2)) + iTermMnF > 12 THEN
				sCalcFromF = String(Long(Left(sCurDateF,4)) + 1,'0000')+ String(Integer(Mid(sCurDateF,5,2)) + iTermMnF - 12,'00')+ String(iDay,'00')
			ELSE
				sCalcFromF = Left(sCurDateF,4) + String(Integer(Mid(sCurDateF,5,2)) + iTermMnF,'00')+String(iDay,'00')
			END IF
			
			sRsDate = sCurDateF
			
			sMaxFeeDate = sBaseCalcDate
			IF Wf_Insert_Kfm03ot1('IJA',sLoCd,sRsDate,dCalcIja,dCalcIjaF,dLoRate,dRemainW,dRemainF,sMaxFeeDate) = -1 THEN
				F_MessageChk(13,'[차입금 이자]')
				rollback;
				Return -1
			ELSE
				COMMIT;
			END IF	
		END IF
	END IF
Loop While Left(sLoTo,6) >= Left(sCalcFromF,6)
w_mdi_frame.sle_msg.text = '상환 계획(이자) 생성 완료'
SetPointer(Arrow!)

Return 1


end function

public function integer wf_delete_data (string sflag);
Integer i,iRowCount
Double  dAmt,dAmtY,dIja,dIjaY

iRowCount = dw_list.RowCount()
//dw_list.SetRedraw(False)
FOR i = iRowCount TO 1 Step -1
	IF dw_list.GetItemString(i,"rs_gbn") = 'N' or IsNull(dw_list.GetItemString(i,"rs_gbn")) THEN
		dAmt  = dw_list.GetItemNumber(i,"rs_camt")
		dAmtY = dw_list.GetItemNumber(i,"rs_ycamt")
		
		dIja  = dw_list.GetItemNumber(i,"rs_itamt")
		dIjaY = dw_list.GetItemNumber(i,"rs_yitamt")
		IF IsNull(dAmt) THEN dAmt =0
		IF IsNull(dAmtY) THEN dAmtY =0
		IF IsNull(dIja) THEN dIja =0
		IF IsNull(dIjaY) THEN dIjaY =0
	
		IF sFlag = 'W' THEN										/*원금 상환*/
			IF dIja = 0 and dIjaY = 0 THEN
				dw_list.DeleteRow(i)
			ELSE
				dw_list.SetItem(i,"rs_camt",  0)
				dw_list.SetItem(i,"rs_ycamt", 0)
			END IF	
		ELSE
			IF dAmt = 0 and dAmtY = 0 THEN
				dw_list.DeleteRow(i)
			ELSE
				dw_list.SetItem(i,"rs_itamt",  0)
				dw_list.SetItem(i,"rs_yitamt", 0)			
			END IF
		END IF
	END IF
NEXT
//dw_list.SetRedraw(True)
IF dw_list.Update() <> 1 THEN
	F_MessageChk(13,'[자료 초기화]')
	Rollback;
	Return -1
END IF
Return 1
end function

public function integer wf_insert_kfm03ot1 (string sflag, string scode, string sdate, double damount, double damountf, double drate, double dremain, double dremainf, string smaxdate);Integer iCount

IF dAmount = 0 and dAmountF = 0 THEN Return 1

select count(*) 	into :icount
	from kfm03ot1
	where lo_cd = :sCode and rs_date = :sDate;

IF sFlag = 'IJA' THEN													/*이자*/
	if sqlca.sqlcode = 0 and (iCount > 0 and Not IsNull(iCount)) then
		update kfm03ot1
			set rs_itamt  = :dAmount,				 rs_yitamt = :dAmountF,
				 rs_flrate = :dRate,				 	 rs_gbn    = 'N',
				 rs_pdate  = :sMaxDate
			where lo_cd = :sCode and rs_date = :sDate;
	else
		insert into kfm03ot1
			(lo_cd,			rs_date,			rs_camt,				 rs_itamt,
			 rs_ycamt,		rs_yitamt,	 	rs_flrate,			 rs_gbn,
			 rs_jamt,		rs_yjamt,		rs_pdate)
		values
			(:sCode,			:sDate,			0,			 			 :dAmount,
			 0,				:dAmountF,		:dRate,			 	 'N',
			 :dRemain,		:dRemainF,		:sMaxDate);
	end if
ELSE
	if sqlca.sqlcode = 0 and (iCount > 0 and Not IsNull(iCount)) then
		update kfm03ot1
			set rs_camt   = :dAmount,				 rs_ycamt  = :dAmountF,
				 rs_gbn    = 'N',						 rs_jamt   = :dRemain,
				 rs_yjamt  = :dRemainF,				 rs_pdate  = :sMaxDate
			where lo_cd = :sCode and rs_date = :sDate;
	else
		insert into kfm03ot1
			(lo_cd,			rs_date,			rs_camt,				 rs_itamt,
			 rs_ycamt,		rs_yitamt,	 	rs_flrate,			 rs_gbn,
			 rs_jamt,		rs_yjamt,		rs_pdate)
		values
			(:sCode,			:sDate,			:dAmount,			 0,
			 :dAmountF,		0,					0,						 'N',
			 :dRemain,		:dRemainF,		:sMaxDate);
	end if
END IF
	
if sqlca.sqlcode <> 0 then
	Return -1
end if
Return 1
end function

public function integer wf_calc_rs (string sflag);Integer k,iWeight
Double  dYAmt,dYItAmt,dRate,dWAmt,dWItAmt,dLoExcRate
String  sCurr,sRsDate,sRsYear,sBaseYear

dw_mst.AcceptText()
sCurr      = dw_mst.GetItemString(1,"lo_curr")
dLoExcRate = dw_mst.GetItemNumber(1,"lo_excrat")

sBaseYear  = Left(F_Today(),4)											/*현재 년도*/

IF IsNull(dLoExcRate) THEN dLoExcRate = 0

IF sCurr = 'WON' or sCurr = '' OR IsNull(sCurr) THEN Return 1

SELECT NVL(TO_NUMBER("REFFPF"."RFNA2"),1)      INTO :iWeight  						/*가중치*/
   FROM "REFFPF"  
  	WHERE ( "REFFPF"."RFCOD" = '10' ) AND ( "REFFPF"."RFGUB" = :sCurr );
IF SQLCA.SQLCODE <> 0 THEN
	iWeight = 1
ELSE
	IF IsNull(iWeight) THEN iWeight = 1
END IF

SetPointer(HourGlass!)
IF sFlag = 'W' THEN
	sle_msg.text = '외화 환산 중(원금)...'
ELSE
	sle_msg.text = '외화 환산 중(이자)...'
END IF
FOR k = 1 TO dw_list.RowCount()
	sRsDate = dw_list.GetItemString(k,"rs_date")
	sRsYear = Left(sRsDate,4)
	
	IF sRsYear > sBaseYear THEN
		select nvl(y_rate,0)			into :dRate
			from kfz34ot1
			where closing_date = (select max(closing_date) from kfz34ot1
											where closing_date < :sBaseYear||'0101' and y_curr = :sCurr) and
					y_curr = :sCurr ;	
		if sqlca.sqlcode <> 0 OR dRate = 0 then
			F_MessageChk(1,'[외화평가환율]')
			Return  -1
		END IF
	ELSE
		dRate = 0
	END IF
	
	IF dRate = 0 THEN dRate = dLoExcRate
	
	IF sFlag = 'W' THEN
		dYAmt   = dw_list.GetItemNumber(k,"rs_ycamt")
		IF IsNull(dYAmt) THEN dYAmt = 0
		
		dWAmt   = Round((dYAmt * dRate) / iWeight,0)
		
		dw_list.SetItem(k,"rs_camt",  dWAmt)
		ib_any_typing = True
	ELSE
		dYItAmt = dw_list.GetItemNumber(k,"rs_yitamt")
		IF IsNull(dYItAmt) THEN dYItAmt = 0
		
		dWItAmt = Round((dYItAmt * dRate) / iWeight,0)
		
		dw_list.SetItem(k,"rs_itamt", dWItAmt)
		ib_any_typing = True		
	END IF
NEXT
SetPointer(Arrow!)
w_mdi_frame.sle_msg.text = '외화 환산 완료'

Return 1
end function

public function integer wf_create_plan ();Integer iPassYear,iPayYear,iTermMnW,iCalcYear,iCalcMonth,iDay
String  sLoCd,sFirstWdate,sLoFrom,sLoTo,sCurDateF,sCurDateW,sCalcFromW,sCalcFromF,&
		  sMaxFeeDate,sRsDate,sChaipGbn,sGubun,sCurr,sMaxSangDate,sWcond
Double  dChaIpAmtW,dChaIpAmtF,dCalcAmt =0,dCalcAmtF,dRemainW =0,dRemainF = 0,dSumSang,dSumSangY

dw_mst.AcceptText()
sLoCd       = dw_mst.GetItemString(1,"lo_cd")
sLoFrom     = Trim(dw_mst.GetItemString(1,"lo_afdt"))
sLoTo       = Trim(dw_mst.GetItemString(1,"lo_atdt"))
sCurr       = dw_mst.GetItemString(1,"lo_curr")
sGubun		= dw_mst.GetItemString(1,"gubun")											/*장단기구분*/
sWcond      = dw_mst.GetItemString(1,"wcond")											/*상환구분*/

iPassYear   = dw_mst.GetItemNumber(1,"guchi")
iPayYear	   = dw_mst.GetItemNumber(1,"bunhal")
iTermMnW    = dw_mst.GetItemNumber(1,"wjugi")
sFirstWdate = Trim(dw_mst.GetItemString(1,"sang_date"))

dChaIpAmtW  = dw_mst.GetItemNumber(1,"lo_camt")
dChaIpAmtF  = dw_mst.GetItemNumber(1,"lo_ycamt")
IF IsNull(dChaIpAmtW) THEN dChaIpAmtW = 0
IF IsNull(dChaIpAmtF) THEN dChaIpAmtF = 0

IF sGubun = '1' THEN
	sChaipGbn = '0'											/*단기*/
ELSE
	sChaipGbn = '1'											/*장기*/
	
	if sWcond <> '1000' then
		IF iPayYear = 0 OR IsNull(iPayYear) THEN
			F_MessageChk(1,'[상환분할년]')
			dw_mst.SetColumn("lo_cd")
			dw_mst.Setfocus()
			Return -1
		END IF 
		IF iTermMnW = 0 OR IsNull(iTermMnW) THEN
			F_MessageChk(1,'[상환주기]')
			dw_mst.SetColumn("lo_cd")
			dw_mst.Setfocus()
			Return -1
		END IF 
		IF sFirstWdate = '' OR IsNull(sFirstWdate) THEN
			F_MessageChk(1,'[최초상환일]')
			dw_mst.SetColumn("lo_cd")
			dw_mst.Setfocus()
			Return -1
		END IF 
	end if
END IF 
IF dChaIpAmtW = 0 OR IsNull(dChaIpAmtW) THEN
	F_MessageChk(1,'[차입금액]')
	dw_mst.SetColumn("lo_cd")
	dw_mst.Setfocus()
	Return -1
END IF 

IF dw_list.RowCount() > 0 THEN
	dSumSang  = dw_list.GetItemNumber(1,"sum_sang")
	dSumSangY = dw_list.GetItemNumber(1,"sum_sangy")
	IF IsNull(dSumSang) THEN dSumSang   = 0
	IF IsNull(dSumSangY) THEN dSumSangY = 0
ELSE
	dSumSang   = 0;			dSumSangY = 0;
END IF

IF dSumSang <> 0 OR dSumSangY <> 0 THEN
	dChaIpAmtW = dChaIpAmtW - dSumSang
	dChaIpAmtF = dChaIpAmtF - dSumSangY;
	
	sMaxSangDate = dw_list.GetItemString(1,"max_sangdate")
	IF IsNull(sMaxSangDate) OR sMaxSangDate = '0' THEn sMaxSangDate = ''
END IF

w_mdi_frame.sle_msg.text = '상환 계획(원금) 생성 중...'
SetPointer(HourGlass!)
IF sChaipGbn = '1' THEN										/*장기*/
	IF sWcond = '1000' THEN									/*일시상환*/
		IF sCurr = 'WON' THEN
			dRemainW = dChaIpAmtW										/*원금 잔액*/
		ELSE
			dRemainW = 0;
		END IF
		dRemainF    = dChaIpAmtF
				
		/*원금 계산*/				
		IF Wf_Insert_Kfm03ot1('CHAIP',sLoCd,sLoTo,dChaIpAmtW,dChaIpAmtF,0,0,0,sMaxFeeDate) = -1 THEN
			F_MessageChk(13,'[차입금 원금]')
			rollback;
			Return -1
		END IF	
		Return 1
	END IF
	IF sMaxSangDate <> '' AND Not IsNull(sMaxSangDate) AND sMaxSangDate <> '0' THEN
		iCalcYear   = Integer(Left(sMaxSangDate,4))						/*차입일자 => 년,월,일*/
		iCalcMonth  = Integer(Mid(sMaxSangDate,5,2))
	
		sCurDateW  = sMaxSangDate
		sCalcFromW = sMaxSangDate
	ELSE
		iCalcYear   = Integer(Left(sLoFrom,4))						/*차입일자 => 년,월,일*/
		iCalcMonth  = Integer(Mid(sLoFrom,5,2))
	
		sCalcFromW  = sFirstWdate
	END IF
	
	dRemainW    = dChaIpAmtW
	dRemainF    = dChaIpAmtF

	Do	
		IF sMaxSangDate = sCalcFromW THEN
			iCalcYear   = Integer(Left(sCalcFromW,4))	
			iCalcMonth  = Integer(Mid(sCalcFromW,5,2))	
		ELSE
			IF Left(sCalcFromW,6) = Left(sLoFrom,6) THEN
				iCalcYear   = Integer(Left(sLoFrom,4))	
				iCalcMonth  = Integer(Mid(sLoFrom,5,2))	
			ELSE
				IF iCalcMonth + 1 > 12 THEN
					iCalcYear = iCalcYear + 1;		iCalcMonth = 1;
				ELSE
					iCalcYear = iCalcYear;			iCalcMonth = iCalcMonth + 1
				END IF
			END IF
		END IF
		
		if IsDate(String(iCalcYear,'0000')+'.'+String(iCalcMonth,'00')+'.'+Right(sFirstWdate,2)) = False then
			sCurDateW = F_Last_Date(String(iCalcYear,'0000')+String(iCalcMonth,'00'))
			iDay	    = Integer(Right(sCurDateW,2))
		else
			sCurDateW = String(iCalcYear,'0000')+String(iCalcMonth,'00')+Right(sFirstWdate,2)
			iDay	    = Integer(Right(sFirstWdate,2))
		end if
		
		IF sCurr = 'WON' THEN
			IF dRemainW <=0 THEN
				IF Integer(Mid(sCurDateW,5,2)) + iTermMnW > 12 THEN
					sCalcFromW = String(Long(Left(sCurDateW,4)) + 1,'0000')+ String(Integer(Mid(sCurDateW,5,2)) + iTermMnW - 12,'00')+ String(iDay,'00')
				ELSE
					sCalcFromW = Left(sCurDateW,4) + String(Integer(Mid(sCurDateW,5,2)) + iTermMnW,'00')+String(iDay,'00')
				END IF
				Continue
			END IF
		ELSE
			IF dRemainF <=0 THEN
				IF Integer(Mid(sCurDateW,5,2)) + iTermMnW > 12 THEN
					sCalcFromW = String(Long(Left(sCurDateW,4)) + 1,'0000')+ String(Integer(Mid(sCurDateW,5,2)) + iTermMnW - 12,'00')+ String(iDay,'00')
				ELSE
					sCalcFromW = Left(sCurDateW,4) + String(Integer(Mid(sCurDateW,5,2)) + iTermMnW,'00')+String(iDay,'00')
				END IF
				Continue
			END IF
		END IF
		
		IF sMaxSangDate = sCalcFromW THEN		
			IF Integer(Mid(sCurDateW,5,2)) + iTermMnW > 12 THEN
				sCalcFromW = String(Long(Left(sCurDateW,4)) + 1,'0000')+ String(Integer(Mid(sCurDateW,5,2)) + iTermMnW - 12,'00')+ String(iDay,'00')
			ELSE
				sCalcFromW = Left(sCurDateW,4) + String(Integer(Mid(sCurDateW,5,2)) + iTermMnW,'00')+String(iDay,'00')
			END IF
		ELSE
			/*원금 계산*/	
			IF Left(sCalcFromW,6) = Left(sCurDateW,6) THEN 
				select max(rs_date) into :sMaxFeeDate
					from kfm03ot1
					where lo_cd = :sLoCd and rs_date < :sCurDateW and nvl(rs_camt,0) <> 0;
				if sqlca.sqlcode <> 0 then
					sMaxFeeDate = sLoFrom
				else
					if IsNull(sMaxFeeDate) or sMaxFeeDate = '' then sMaxFeeDate = sLoFrom
				end if
			
				dCalcAmt  = Round(dChaIpAmtW / ((iPayYear * 12) / iTermMnW),0)		/*상환금액*/
				if dRemainW - dCalcAmt < dCalcAmt then
					dCalcAmt  = dCalcAmt + (dRemainW - dCalcAmt)
				else
					dCalcAmt  = Round(dChaIpAmtW / ((iPayYear * 12) / iTermMnW),0)		/*상환금액*/
				end if
				
				dCalcAmtF = Round(dChaIpAmtF / ((iPayYear * 12) / iTermMnW),2)		/*상환금액-외화*/	
				if dRemainF - dCalcAmtF < dCalcAmtF then
					dCalcAmtF = dCalcAmtF + (dRemainF - dCalcAmtF)
				else
					dCalcAmtF = Round(dChaIpAmtF / ((iPayYear * 12) / iTermMnW),2)		/*상환금액-외화*/	
				end if
								
				IF Integer(Mid(sCurDateW,5,2)) + iTermMnW > 12 THEN
					sCalcFromW = String(Long(Left(sCurDateW,4)) + 1,'0000')+ String(Integer(Mid(sCurDateW,5,2)) + iTermMnW - 12,'00')+ String(iDay,'00')
				ELSE
					sCalcFromW = Left(sCurDateW,4) + String(Integer(Mid(sCurDateW,5,2)) + iTermMnW,'00')+String(iDay,'00')
				END IF
				
				IF sCurr = 'WON' THEN
					dRemainW = Round(dRemainW - dCalcAmt,0)										/*원금 잔액*/
				ELSE
					dRemainW = 0;			dCalcAmt = 0;
				END IF
				dRemainF = Round(dRemainF - dCalcAmtF,2)										/*원금 잔액-외화*/
				
				sRsDate = sCurDateW
				IF Wf_Insert_Kfm03ot1('CHAIP',sLoCd,sRsDate,dCalcAmt,dCalcAmtF,0,dRemainW,dRemainF,sMaxFeeDate) = -1 THEN
					F_MessageChk(13,'[차입금 원금]')
					rollback;
					Return -1
				END IF
			END IF	
		END IF
	Loop While Left(sLoTo,6) >= Left(sCalcFromW,6)
ELSE
	iCalcYear   = Integer(Left(sLoFrom,4))						/*차입일자 => 년,월,일*/
	iCalcMonth  = Integer(Mid(sLoFrom,5,2))
		
	IF sCurr = 'WON' THEN
		dRemainW = dChaIpAmtW										/*원금 잔액*/
	ELSE
		dRemainW = 0;
	END IF
	dRemainF    = dChaIpAmtF
			
	/*원금 계산*/				
	IF Wf_Insert_Kfm03ot1('CHAIP',sLoCd,sLoTo,dChaIpAmtW,dChaIpAmtF,0,0,0,sMaxFeeDate) = -1 THEN
		F_MessageChk(13,'[차입금 원금]')
		rollback;
		Return -1
	END IF	
END IF
w_mdi_frame.sle_msg.text = '상환 계획(원금) 생성 완료'
SetPointer(Arrow!)

Return 1


end function

on w_kfia63.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.gb_5=create gb_5
this.dw_mst=create dw_mst
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.p_4=create p_4
this.p_calc=create p_calc
this.p_remain=create p_remain
this.p_calc_rs=create p_calc_rs
this.p_calc_plan=create p_calc_plan
this.p_plan_pay=create p_plan_pay
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.gb_5
this.Control[iCurrent+3]=this.dw_mst
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.p_2
this.Control[iCurrent+6]=this.p_3
this.Control[iCurrent+7]=this.p_4
this.Control[iCurrent+8]=this.p_calc
this.Control[iCurrent+9]=this.p_remain
this.Control[iCurrent+10]=this.p_calc_rs
this.Control[iCurrent+11]=this.p_calc_plan
this.Control[iCurrent+12]=this.p_plan_pay
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
end on

on w_kfia63.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.gb_5)
destroy(this.dw_mst)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.p_calc)
destroy(this.p_remain)
destroy(this.p_calc_rs)
destroy(this.p_calc_plan)
destroy(this.p_plan_pay)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;String sMsg

sMsg = Message.StringParm

dw_mst.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_list.Reset()

dw_mst.Reset()
dw_mst.insertrow(0)
dw_mst.SetColumn('lo_cd')
dw_mst.SetFocus()

IF sMsg = '' OR IsNull(sMsg) OR sMsg = this.ClassName() THEN
	dw_mst.Modify('lo_cd.protect = 0')

	p_can.enabled = True
	p_del.enabled = False
ELSE
	
	p_can.enabled = False
	p_del.enabled = True
		
	dw_mst.Setitem(1,"lo_cd",sMsg)
	
	p_inq.TriggerEvent(Clicked!)
	
	dw_mst.Modify('lo_cd.protect = 1')
END IF
end event

type dw_insert from w_inherite`dw_insert within w_kfia63
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia63
boolean visible = false
integer x = 4389
integer y = 1172
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfia63
boolean visible = false
integer x = 4215
integer y = 1172
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfia63
boolean visible = false
integer x = 3854
integer y = 1176
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfia63
integer x = 3749
integer y = 20
integer taborder = 40
end type

event p_ins::clicked;call super::clicked;string sLoCd, ls_hdate, get_hdate, ls_rs_date
long ll_currow, ll_rowcnt

if dw_mst.AcceptText() = -1 then return 

ll_rowcnt = dw_mst.GetRow()
if ll_rowcnt < 1 then return

sLoCd = dw_mst.GetItemString(dw_mst.GetRow(), 'lo_cd')
if trim(sLoCd) = '' or isnull(sLoCd) then 
	F_MessageChk(1, "[차입금 코드]")
	dw_mst.SetColumn('lo_cd')
	dw_mst.SetFocus()
	return 
end if

ll_currow = dw_list.RowCount()

IF ll_currow <=0 THEN
	ll_currow = 0
	// 현재 날짜 -1 일
	ls_rs_date = string(RelativeDate (date(Left(f_today(),4)+'.'+Mid(f_today(),5,2)+'.'+Right(f_today(),2)), -1), 'YYYYMMDD')
else 
	// 맨 마지막 일자
	ls_rs_date = dw_list.GetItemString(ll_currow, 'rs_date')
END IF

ls_rs_date = string(RelativeDate(date(left(ls_rs_date, 4) +"/" + &
             mid(ls_rs_date, 5, 2) +"/" + right(ls_rs_date, 2)), 1), 'YYYYMMDD')

ll_currow = dw_list.InsertRow(0)

dw_list.SetItem(ll_currow, 'lo_cd', sLoCd)
dw_list.Setitem(ll_currow, "rs_date", ls_rs_date)
dw_list.Setitem(ll_currow, "flag", "1")
dw_list.ScrollToRow(ll_currow)

dw_list.setcolumn('rs_date')
dw_list.SetFocus()

w_mdi_frame.sle_msg.text = "새로운 자료를 입력하십시요!!"

end event

type p_exit from w_inherite`p_exit within w_kfia63
integer taborder = 120
end type

type p_can from w_inherite`p_can within w_kfia63
end type

event p_can::clicked;call super::clicked;dw_mst.SetRedraw(false)
dw_mst.reset()
dw_mst.insertrow(0)
dw_mst.SetRedraw(true)

dw_list.reset()

dw_mst.setcolumn('lo_cd')
dw_mst.setfocus()

p_del.enabled  = false
p_Calc.Enabled = False
p_Remain.Enabled = False

ib_any_typing = False
	
end event

type p_print from w_inherite`p_print within w_kfia63
boolean visible = false
integer x = 4027
integer y = 1176
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia63
integer x = 3575
integer y = 20
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string ls_lo_cd
long ll_rowcnt

ll_rowcnt = dw_mst.GetRow()
if ll_rowcnt < 1 then return 

if dw_mst.AcceptText() = -1 then return 

ls_lo_cd = dw_mst.GetItemString(ll_rowcnt, 'lo_cd')
if trim(ls_lo_cd) = '' or isnull(ls_lo_cd) then 
	F_MessageChk(1, "[차입금 코드]")
	dw_mst.SetColumn('lo_cd')
	dw_mst.SetFocus()
	return 
end if
if dw_mst.Retrieve(ls_lo_cd) < 1 then 
	
	dw_mst.insertrow(0)
	
	F_MessageChk(14, "")
	
   dw_mst.SetColumn('lo_cd')
	dw_mst.SetFocus()
	
   p_del.enabled = false	
	p_Calc.Enabled = False
	p_Calc_Plan.Enabled = False
	p_Plan_Pay.Enabled = False
	p_remain.Enabled = False
	
   return 
end if
dw_list.Retrieve(ls_lo_cd)

p_del.enabled = true
p_Calc.Enabled = True
p_Calc_Plan.Enabled = True
p_Plan_Pay.Enabled = True
p_remain.Enabled = True

if dw_mst.GetItemString(1,"lo_curr") = 'WON' then
	p_calc_rs.Enabled = False
else
	p_calc_rs.Enabled = True
end if
	
end event

type p_del from w_inherite`p_del within w_kfia63
end type

event p_del::clicked;call super::clicked;string ls_rs_date

Int ll_currow

ll_currow = dw_list.GetRow()
IF ll_currow <=0 Then Return

IF F_DbConFirm('삭제') = 2 THEN Return
	
dw_list.DeleteRow(ll_currow)
IF dw_list.Update() > 0 THEN
	commit;
	
	IF ll_currow = 1 OR ll_currow <= dw_list.RowCount() THEN
		dw_list.ScrollToRow(ll_currow - 1)
		dw_list.SetColumn('rs_camt')				
		dw_list.SetFocus()		
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	MessageBox("확 인", "자료를 삭제하는 도중에 ~r~r에러가 발생하였습니다.!!")
	w_mdi_frame.sle_msg.text ="자료를 삭제하는 도중 에러가 발생하였습니다.!!"		
	ib_any_typing =True
	Return
END IF
p_Calc.Enabled = True
	


end event

type p_mod from w_inherite`p_mod within w_kfia63
end type

event p_mod::clicked;call super::clicked;string ls_lo_cd, ls_rs_date 

long lrow, ll_totcnt

if dw_mst.AcceptText() = -1 then return
IF dw_list.Accepttext() = -1 THEN 	RETURN

ll_totcnt = dw_list.RowCount()
lrow = dw_list.GetRow()
if lrow <= 0 then  return 

ls_lo_cd   = dw_mst.GetItemString(dw_mst.GetRow(), 'lo_cd')
ls_rs_date = dw_list.GetItemString(lrow, 'rs_date')

if trim(ls_rs_date) = '' or isnull(ls_rs_date)  then 
	F_MessageChk(1, "[상환/지급일]")
   dw_list.SetColumn('rs_date')
	dw_list.SetFocus()
	return 
end if

IF F_DbConFirm('저장') = 2 THEN RETURN

IF dw_list.Update() > 0 THEN			
	COMMIT ;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
   Wf_Change_Flag(ib_any_typing)	  // protect = '1' 로 setting 
ELSE
	ROLLBACK ;
   MessageBox("확 인", "자료를 저장하는데 실패하였습니다.!!")
	ib_any_typing = True
   Wf_Change_Flag(ib_any_typing)	 // protect를 setting 하지 않음
	Return
END IF

dw_list.ScrollToRow(dw_list.RowCount())
dw_list.Setfocus()

p_del.enabled = true
p_Calc.Enabled = True
	
end event

type cb_exit from w_inherite`cb_exit within w_kfia63
integer x = 4315
integer y = 1940
integer width = 288
end type

type cb_mod from w_inherite`cb_mod within w_kfia63
integer x = 3401
integer y = 1940
integer width = 288
end type

type cb_ins from w_inherite`cb_ins within w_kfia63
integer x = 3045
integer y = 1932
integer width = 288
end type

type cb_del from w_inherite`cb_del within w_kfia63
integer x = 3707
integer y = 1940
integer width = 288
end type

type cb_inq from w_inherite`cb_inq within w_kfia63
integer x = 2743
integer y = 1932
integer width = 288
end type

type cb_print from w_inherite`cb_print within w_kfia63
integer x = 1541
integer y = 2856
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kfia63
integer y = 2972
end type

type cb_can from w_inherite`cb_can within w_kfia63
integer x = 4009
integer y = 1940
integer width = 288
end type

type cb_search from w_inherite`cb_search within w_kfia63
integer x = 1893
integer y = 2856
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_kfia63
integer x = 2848
end type

type sle_msg from w_inherite`sle_msg within w_kfia63
integer width = 2464
end type

type gb_10 from w_inherite`gb_10 within w_kfia63
integer width = 3602
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia63
integer x = 2715
integer y = 1876
integer width = 645
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia63
integer x = 3369
integer y = 1884
integer width = 1262
end type

type dw_list from datawindow within w_kfia63
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 69
integer y = 532
integer width = 4521
integer height = 1688
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kfia632"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;Send(Handle(this), 256,9,0)
This.SelectRow(0, FALSE)

// 자동으로 다음 row 추가 
IF This.GetColumnName() = 'etc' then 
	if this.Getrow() = this.RowCount() then 
   	cb_ins.TriggerEvent(Clicked!)
	end if
END IF

Return 1 




end event

event ue_key;choose case key
	case keypageup!
		this.scrollpriorpage()
	case keypagedown!
		this.scrollnextpage()
	case keyhome!
		this.scrolltorow(1)
	case keyend!
		this.scrolltorow(this.rowcount())
end choose

end event

event itemerror;return 1
end event

event itemchanged;string   ls_rs_date, sFindCol, sCurr,snull
Double   dRate,dAmount
long     lRow, lReturnRow,lWeight

SetNull(snull)

lRow = this.GetRow()
if this.GetColumnName() = 'rs_date' then
	ls_rs_date = this.GetText()
   if trim(ls_rs_date) = '' or isnull(ls_rs_date) then 
		F_MessageChk(1, "[상환/지급일]")
		return 1
	else
		if f_datechk(ls_rs_date) = -1 then 
			F_MessageChk(21, "[상환/지급일]")
			return -1
		end if
	end if
		
	lRow = this.GetRow()
	sFindCol = GetColumnName()
	
	lReturnRow = this.find("lower(" + sFindCol + ") = ~"" + lower(ls_rs_date) + "~"", 1, this.rowcount())

	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		MessageBox("확인", "이미 등록된 [상환/지급일]입니다." + "~n" + "~n" + &
		                   "일자를 확인하십시오.")
		this.SetItem(lRow, 'rs_date', sNull)
		RETURN  1
	END IF	
end if

IF this.GetColumnName() = 'rs_ycamt' THEN
	dAmount = Double(this.GetText())
	IF IsNull(dAmount) THEN dAmount = 0
	
	sCurr = dw_mst.GetItemString(1,"lo_curr")
	IF sCurr = '' OR IsNull(sCurr) OR sCurr = 'WON' THEN Return
	
	ls_rs_date = Trim(this.GetItemString(this.GetRow(),"rs_date"))
	IF ls_rs_date = '' OR IsNull(ls_rs_date) THEN Return
	
	select nvl(y_rate,0)			into :dRate
		from kfz34ot1
		where closing_date = (select max(closing_date) from kfz34ot1
										where closing_date < :ls_rs_Date and y_curr = :sCurr) and
				y_curr = :sCurr ;
	if sqlca.sqlcode <> 0 then
		dRate = 0
	else
		if IsNull(dRate) THEN dRate = 0
	END IF
	
	SELECT NVL(TO_NUMBER("REFFPF"."RFNA2"),1)      INTO :lWeight  
	   FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = '10' ) AND ( "REFFPF"."RFGUB" = :sCurr );
	IF SQLCA.SQLCODE <> 0 THEN
		lWeight = 1
	ELSE
		IF IsNull(lWeight) THEN lWeight = 1
	END IF
	
	this.SetItem(lRow,"rs_camt", Truncate((dAmount * dRate) / lWeight,0))
END IF

IF this.GetColumnName() = 'rs_yitamt' THEN
	dAmount = Double(this.GetText())
	IF IsNull(dAmount) THEN dAmount = 0
	
	sCurr = dw_mst.GetItemString(1,"lo_curr")
	IF sCurr = '' OR IsNull(sCurr) OR sCurr = 'WON' THEN Return
	
	ls_rs_date = Trim(this.GetItemString(this.GetRow(),"rs_date"))
	IF ls_rs_date = '' OR IsNull(ls_rs_date) THEN Return
	
	select nvl(y_rate,0)			into :dRate
		from kfz34ot1
		where closing_date = (select max(closing_date) from kfz34ot1
										where closing_date < :ls_rs_Date and y_curr = :sCurr) and
				y_curr = :sCurr ;
	if sqlca.sqlcode <> 0 then
		dRate = 0
	else
		if IsNull(dRate) THEN dRate = 0
	END IF
	
	SELECT NVL(TO_NUMBER("REFFPF"."RFNA2"),1)      INTO :lWeight  
	   FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = '10' ) AND ( "REFFPF"."RFGUB" = :sCurr );
	IF SQLCA.SQLCODE <> 0 THEN
		lWeight = 1
	ELSE
		IF IsNull(lWeight) THEN lWeight = 1
	END IF
	
	this.SetItem(lRow,"rs_itamt", Truncate((dAmount * dRate) / lWeight,0))
END IF



end event

event editchanged;ib_any_typing = true 
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

f_toggle_eng(wnd)



end event

event rowfocuschanged;dw_list.SetRowFocusIndicator(Hand!)
end event

type gb_5 from groupbox within w_kfia63
integer x = 3186
integer y = 4
integer width = 379
integer height = 148
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "자료선택"
end type

type dw_mst from datawindow within w_kfia63
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 41
integer width = 3122
integer height = 516
integer taborder = 10
string dataobject = "dw_kfia631"
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;send(handle(this), 256, 9, 0)
return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;String snull

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)

this.accepttext()

IF this.GetColumnName() ="lo_cd" THEN
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	
	gs_code = this.object.lo_cd[1]
	
	OPEN(W_KFM03OT0_POPUP)
	IF IsNull(gs_code) OR gs_code = '' THEN Return
	
	this.SetItem(row, 'lo_cd', gs_code)
	this.TriggerEvent(ItemChanged!)
end if
end event

event itemchanged;String  sLoCd, snull, ls_name
Integer iCount

SetNull(snull)

if this.GetColumnName() = 'lo_cd' then 
	sLoCd = this.GetText()
	IF sLoCd = "" OR IsNull(sLoCd) THEN Return
	
	SELECT Count(*)	INTO :iCount
		FROM "KFM03OT0"  
	   WHERE "LO_CD" = :sLoCd ;
	IF SQLCA.SQLCODE <> 0 OR IsNull(iCount) OR iCount = 0 THEN
		F_MessageChk(20,'[차입금코드]')
		this.SetItem(this.GetRow(), 'lo_cd',   snull)
     	return 1
	END IF
	
	SELECT lo_name	INTO :ls_name
		FROM "KFM03OT0"  
	   WHERE "LO_CD" = :sLoCd ;
		
	if sqlca.sqlcode = 0 then	
		this.SetItem(this.GetRow(), 'lo_name',   ls_name)
	end if
	p_inq.TriggerEvent(Clicked!)
  
end if


end event

event itemerror;return 1
end event

event getfocus;this.AcceptText()
end event

type p_1 from picture within w_kfia63
integer x = 3227
integer y = 64
integer width = 55
integer height = 48
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\first.gif"
boolean focusrectangle = false
end type

event clicked;String sLoCd,sNewLoCd

dw_mst.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sLoCd = dw_mst.GetItemString(dw_mst.GetRow(),"lo_cd")

SELECT MIN("KFM03OT1"."LO_CD") INTO :sNewLoCd
	FROM "KFM03OT1"  ;

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sNewLoCd) OR sNewLoCd = "" THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	IF sLoCd = sNewLoCd THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	dw_mst.SetItem(dw_mst.GetRow(),"lo_cd", sNewLoCd)
	dw_mst.SetColumn("lo_cd")
	dw_mst.SetFocus()
	dw_mst.TriggerEvent(ItemChanged!)
	
END IF
	
end event

type p_2 from picture within w_kfia63
integer x = 3305
integer y = 64
integer width = 55
integer height = 48
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\prior.gif"
boolean focusrectangle = false
end type

event clicked;String sLoCd,sNewLoCd

dw_mst.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sLoCd = dw_mst.GetItemString(dw_mst.GetRow(),"lo_cd")

SELECT MAX("KFM03OT1"."LO_CD") INTO :sNewLoCd
	FROM "KFM03OT1" 
	WHERE "LO_CD" < :sLoCd;

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sNewLoCd) OR sNewLoCd = "" THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	dw_mst.SetItem(dw_mst.GetRow(),"lo_cd", sNewLoCd)
	
	dw_mst.SetColumn("lo_cd")
	dw_mst.SetFocus()
	dw_mst.TriggerEvent(ItemChanged!)

END IF
	
end event

type p_3 from picture within w_kfia63
integer x = 3383
integer y = 64
integer width = 55
integer height = 48
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\next.gif"
boolean focusrectangle = false
end type

event clicked;String sLoCd,sNewLoCd

dw_mst.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sLoCd = dw_mst.GetItemString(dw_mst.GetRow(),"lo_cd")

SELECT MIN("KFM03OT1"."LO_CD") INTO :sNewLoCd
	FROM "KFM03OT1" 
	WHERE "LO_CD" > :sLoCd;

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sNewLoCd) OR sNewLoCd = "" THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	dw_mst.SetItem(dw_mst.GetRow(),"lo_cd", sNewLoCd)
	
	dw_mst.SetColumn("lo_cd")
	dw_mst.SetFocus()
	dw_mst.TriggerEvent(ItemChanged!)

END IF
	
end event

type p_4 from picture within w_kfia63
integer x = 3461
integer y = 64
integer width = 55
integer height = 48
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\last.gif"
boolean focusrectangle = false
end type

event clicked;String sLoCd,sNewLoCd

dw_mst.AcceptText()
IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

sLoCd = dw_mst.GetItemString(dw_mst.GetRow(),"lo_cd")

SELECT MAX("KFM03OT1"."LO_CD") INTO :sNewLoCd
	FROM "KFM03OT1"  ;

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sNewLoCd) OR sNewLoCd = "" THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF

	If sLoCd = sNewLoCd THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF

	dw_mst.SetItem(dw_mst.GetRow(),"lo_cd", sNewLoCd)
	
	dw_mst.SetColumn("lo_cd")
	dw_mst.SetFocus()
	dw_mst.TriggerEvent(ItemChanged!)

END IF
	
end event

type p_calc from uo_picture within w_kfia63
integer x = 3625
integer y = 224
integer width = 178
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\이자재계산_up.gif"
end type

event clicked;call super::clicked;String   sMsgParm,sFromYm,sLendDate,sRsGbn,sPayDate,sTmpDate,sCurr
Double   dRate,dLendAmt,dLendAmtF,dCurAmt,dCurAmtF,dWonAmt,dForAmt,dIjaAmt,dIjaAmtF,dRsRate
Integer  k,iDays,iWeight

IF dw_list.RowCount() <=0 THEN Return

OpenWithParm(w_kfia50a,dw_mst.GetItemString(dw_mst.GetRow(),"lo_cd"))

sMsgParm = Message.StringParm

IF sMsgParm = '0' THEN Return

sFromYm = Left(sMsgParm,7)
dRate   = Double(Mid(sMsgParm,8,6))

dw_mst.AcceptText()
sLendDate = dw_mst.GetItemString(1,"lo_afdt")
dLendAmt  = dw_mst.GetItemNumber(1,"lo_camt")
dLendAmtF = dw_mst.GetItemNumber(1,"lo_ycamt")
sCurr     = dw_mst.GetItemString(1,"lo_curr")

IF IsNull(dLendAmt) THEN dLendAmt = 0
IF IsNull(dLendAmtF) THEN dLendAmtF = 0

sTmpDate = sLendDate
dCurAmt  = dLendAmt
dCurAmtF = dLendAmtF
FOR k = 1 TO dw_list.RowCount()
	sPayDate = Trim(dw_list.GetItemString(k,"rs_date"))
	sRsGbn   = dw_list.GetItemString(k,"rs_gbn")
	
	IF k <> 1 THEN
		dWonAmt  = dw_list.GetItemNumber(k - 1,"rs_camt") 
		IF IsNull(dWonAmt) THEN dWonAmt = 0
		
		dForAmt  = dw_list.GetItemNumber(k - 1,"rs_ycamt") 
		IF IsNull(dForAmt) THEN dForAmt = 0
		
		dCurAmt = dCurAmt - dWonAmt
		dCurAmtF = dCurAmtF - dForAmt
	END IF
	
	IF sRsGbn = 'Y' THEN 
		sTmpDate = 	sPayDate
		Continue																		/*이미 지급이면 skip*/
	END IF
	
	iDays = DaysAfter(Date(Left(sTmpDate,4)+'.'+Mid(sTmpDate,5,2)+'.'+Right(sTmpDate,2)),&
							Date(Left(sPayDate,4)+'.'+Mid(sPayDate,5,2)+'.'+Right(sPayDate,2)))
	
	dIjaAmtF = Truncate((dCurAmtF * (iDays / 365) * (dRate / 100)) / 100,0) * 100

	IF sCurr = 'WON' THEN
		dIjaAmt  = Truncate((dCurAmt * (iDays / 365) * (dRate / 100)) / 100,0) * 100
	ELSE
		select nvl(y_rate,0)			into :dRsRate
			from kfz34ot1
			where closing_date = (select max(closing_date) from kfz34ot1
											where closing_date < :sPayDate and y_curr = :sCurr) and
					y_curr = :sCurr ;
		if sqlca.sqlcode <> 0 then
			dRsRate = 0
		else
			if IsNull(dRsRate) THEN dRsRate = 0
		END IF
		
		SELECT NVL(TO_NUMBER("REFFPF"."RFNA2"),1)      INTO :iWeight  
			FROM "REFFPF"  
			WHERE ( "REFFPF"."RFCOD" = '10' ) AND ( "REFFPF"."RFGUB" = :sCurr );
		IF SQLCA.SQLCODE <> 0 THEN
			iWeight = 1
		ELSE
			IF IsNull(iWeight) THEN iWeight = 1
		END IF
		
		dIjaAmt = Truncate((dIjaAmtF * dRsRate) / iWeight,0)
	END IF
	
	dw_list.SetItem(k,"rs_itamt",   dIjaAmt)
	dw_list.SetItem(k,"rs_yitamt",  dIjaAmtF)
	
	sTmpDate = sPayDate
NEXT

ib_any_typing = True





end event

type p_remain from uo_picture within w_kfia63
integer x = 3799
integer y = 224
integer width = 178
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\잔액재계산_up.gif"
end type

event clicked;call super::clicked;Integer k
Double  dRemainW,dRemainF,dSangAmtW,dSangAmtF
String  sCurr

if dw_list.RowCount() <=0 then Return
sCurr    = dw_mst.GetItemString(1,"lo_curr")

dRemainW = dw_mst.GetItemNumber(1,"lo_camt")
dRemainF = dw_mst.GetItemNumber(1,"lo_ycamt")
IF IsNull(dRemainW) THEN dRemainW = 0
IF IsNull(dRemainF) THEN dRemainF = 0

sle_msg.text = '잔액을 다시 계산 중...'
SetPointer(HourGlass!)
FOR k = 1 TO dw_list.RowCount()
	dSangAmtW = dw_list.GetItemNumber(k,"rs_camt")
	dSangAmtF = dw_list.GetItemNumber(k,"rs_ycamt")
	IF IsNull(dSangAmtW) THEN dSangAmtW = 0
	IF IsNull(dSangAmtF) THEN dSangAmtF = 0

	IF sCurr = 'WON' THEN
		dRemainW = dRemainW - dSangAmtW
	ELSE
		dRemainW = 0
	END IF
	dRemainF = dRemainF - dSangAmtF
	
	dw_list.SetItem(k,"rs_jamt",   dRemainW)
	dw_list.SetItem(k,"rs_yjamt",  dRemainF)
NEXT
ib_any_typing = true 
sle_msg.text = '잔액을 재계산 완료'
SetPointer(Arrow!)

end event

type p_calc_rs from uo_picture within w_kfia63
boolean visible = false
integer x = 4151
integer y = 436
integer width = 306
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\외화평가환산_up.gif"
end type

event clicked;call super::clicked;if Wf_Calc_Rs('W') = -1 then Return

if Wf_Calc_Rs('F') = -1 then Return

end event

type p_calc_plan from uo_picture within w_kfia63
integer x = 3968
integer y = 224
integer width = 306
integer taborder = 100
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\상환계획생성(원금)_up.gif"
end type

event clicked;call super::clicked;String   sLoCd
Double   dChaipAmt,dChaipAmtY, dPlanAmt,dPlanAmtY

dw_mst.AcceptText()
sLocd      = dw_mst.GetItemString(1,"lo_cd")
dChaipAmt  = dw_mst.GetItemNumber(1,"lo_camt")
dChaipAmtY = dw_mst.GetItemNumber(1,"lo_ycamt")
IF IsNull(dChaipAmt) THEN dChaipAmt =0
IF IsNull(dChaipAmtY) THEN dChaipAmtY = 0

IF dw_list.RowCount() > 0 THEN
	IF MessageBox('확 인','자료를 삭제 후 다시 생성합니다...'+'~n'+&
								 '계속하시겠습니까?',Question!,YesNo!) = 2 THEN Return
								 
	IF Wf_Delete_Data('W') = -1 THEN Return
	commit;
END IF

IF Wf_Create_Plan() = -1 THEN 
	sle_msg.text = ''
	SetPointer(Arrow!)
	Return
ELSE
	
	select sum(rs_camt),sum(rs_ycamt) into :dPlanAmt, :dPlanAmtY from kfm03ot1 where lo_cd = :sLoCd ;
	if IsNull(dPlanAmt) THEN dPlanAmt = 0
	if IsNull(dPlanAmtY) THEN dPlanAmtY = 0
	
	if dw_mst.GetItemString(1,"lo_curr") = 'WON' then
		update kfm03ot1
			set rs_camt  = rs_camt   + (:dChaIpAmt - :dPlanAmt),
				 rs_jamt  = rs_jamt   - (:dChaIpAmt - :dPlanAmt)
			where lo_cd = :sLoCd and 
					rs_date = (select max(rs_date) from kfm03ot1 where lo_cd = :sLoCd and nvl(rs_camt,0) <> 0);		
	else
		update kfm03ot1
			set rs_camt  = rs_camt   + (:dChaIpAmt - :dPlanAmt),
				 rs_ycamt = rs_ycamt  + (:dChaIpAmtY - :dPlanAmtY),
				 rs_jamt  = 0,
				 rs_yjamt  = rs_yjamt - (:dChaIpAmtY - :dPlanAmtY)
			where lo_cd = :sLoCd and 
					rs_date = (select max(rs_date) from kfm03ot1 where lo_cd = :sLoCd and nvl(rs_ycamt,0) <> 0);	
	end if	
END IF
dw_list.Retrieve(sLoCd)

//if Wf_Calc_Rs('W') = -1 then Return

if dw_mst.GetItemString(1,"lo_curr") = 'WON' then
	Commit;
end if


end event

type p_plan_pay from uo_picture within w_kfia63
integer x = 4265
integer y = 224
integer width = 306
integer taborder = 110
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\지급계획생성(이자)_up.gif"
end type

event clicked;call super::clicked;String sLoCd 

dw_mst.AcceptText()
sLocd = dw_mst.GetItemString(1,"lo_cd")

IF dw_list.RowCount() > 0 THEN
	IF MessageBox('확 인','자료를 삭제 후 다시 생성합니다...'+'~n'+&
								 '계속하시겠습니까?',Question!,YesNo!) = 2 THEN Return
								 
	IF Wf_Delete_Data('F') = -1 THEN Return
	commit;
else
	messagebox("확인", "상환계획생성(원금)을 먼저 처리하십시오!!")
	return 
END IF

IF Wf_Create_Plan_Pay() = -1 THEN 
	sle_msg.text = ''
	SetPointer(Arrow!)

	Return
END IF

dw_list.Retrieve(sLoCd)

//if Wf_Calc_Rs('F') = -1 then return 

if dw_mst.GetItemString(1,"lo_curr") = 'WON' then
	Commit;
end if
end event

type rr_1 from roundrectangle within w_kfia63
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3579
integer y = 196
integer width = 1029
integer height = 216
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfia63
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 520
integer width = 4549
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

