$PBExportHeader$w_kgle41.srw
$PBExportComments$결산대체전표 처리
forward
global type w_kgle41 from w_inherite
end type
type dw_junpoy from datawindow within w_kgle41
end type
type dw_sungin from datawindow within w_kgle41
end type
type dw_print from datawindow within w_kgle41
end type
type dw_ip from u_key_enter within w_kgle41
end type
type rr_2 from roundrectangle within w_kgle41
end type
type dw_rtv from datawindow within w_kgle41
end type
type dw_sonik from datawindow within w_kgle41
end type
type p_create from uo_picture within w_kgle41
end type
type rb_1 from radiobutton within w_kgle41
end type
type rb_2 from radiobutton within w_kgle41
end type
type gb_1 from groupbox within w_kgle41
end type
type gb_2 from groupbox within w_kgle41
end type
type rr_1 from roundrectangle within w_kgle41
end type
end forward

global type w_kgle41 from w_inherite
integer x = 5
integer y = 4
string title = "결산대체전표 처리"
dw_junpoy dw_junpoy
dw_sungin dw_sungin
dw_print dw_print
dw_ip dw_ip
rr_2 rr_2
dw_rtv dw_rtv
dw_sonik dw_sonik
p_create p_create
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
gb_2 gb_2
rr_1 rr_1
end type
global w_kgle41 w_kgle41

type variables

String sUpmuGbn = 'Q',LsAutoSungGbn, LsStatus ='I'
end variables

forward prototypes
public function integer wf_delete_kfz12ot0 ()
public function integer wf_create_kfz12ot0 (string ssaupj, string sbaldate)
public subroutine wf_calculation ()
public subroutine wf_replacejpy_profit (string ssaupj, string sbaldate, long ljunno, string sfrym, string stoym)
public subroutine wf_replacejpy_product (string ssaupj, string sbaldate, long ljunno, string sfrym, string stoym)
end prototypes

public function integer wf_delete_kfz12ot0 ();Integer iFindRow,iRowCount,i
String  sSaupj,sBalDate,sUpmuGu,sJunNo
Long    lJunNo

IF MessageBox('확 인','전표를 삭제하시겠습니까?',Question!,YesNo!) = 2 then Return 1

dw_junpoy.Reset()

SetPointer(HourGlass!)

if dw_rtv.RowCount() > 0 then
	iFindRow = dw_rtv.Find("jpygbn <> '1'",1,dw_rtv.RowCount())
else
	iFindRow = dw_sonik.Find("jpygbn <> '1'",1,dw_sonik.RowCount())
end if
if iFindRow > 0 then
	if dw_rtv.RowCount() > 0 then
		sJunno = dw_rtv.GetItemString(iFindRow,"max_accno")
		if sJunNo = '' or IsNull(sJunNo) then
			iFindRow = dw_sonik.Find("jpygbn <> '1'",1,dw_sonik.RowCount())	
			sJunno = dw_sonik.GetItemString(iFindRow,"max_accno")
		end if			
	else
		sJunno = dw_sonik.GetItemString(iFindRow,"max_accno")
	end if	
	
	sSaupj   = Left(sJunNo,2)
	sBalDate = Mid(sJunNo,3,8)
	sUpmuGu  = Mid(sJunNo,11,1)
	lJunNo   = Long(Mid(sJunNo,12,4))
	
	iRowCount = dw_junpoy.Retrieve(sSaupj,sBalDate,sUpmuGu,lJunNo)
	IF iRowCount > 0 THEN
			
		FOR i = iRowCount TO 1 STEP -1							/*전표 삭제*/
			dw_junpoy.DeleteRow(i)		
		NEXT
		
		IF dw_junpoy.Update() <> 1 THEN
			F_MessageChk(12,'[미승인전표]')
			SetPointer(Arrow!)
			Return -1
		ELSE
			DELETE FROM "KFZ12OT1"  										/*전표품의내역 삭제*/
			WHERE ( "KFZ12OT1"."SAUPJ"    = :sSaupj  ) AND  
					( "KFZ12OT1"."BAL_DATE" = :sBalDate ) AND  
					( "KFZ12OT1"."UPMU_GU"  = :sUpmuGu ) AND  
					( "KFZ12OT1"."JUN_NO"   = :lJunNo ) ;		
		END IF
	END IF
	
	UPDATE "KFZ35OT0"
		SET "ACCJUNNO" = NULL
		WHERE "ACCJUNNO" = :sJunno;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(12,'[결산조정자료]')
		SetPointer(Arrow!)
		Return -1
	END IF
end if

SetPointer(Arrow!)
Return 1

end function

public function integer wf_create_kfz12ot0 (string ssaupj, string sbaldate);///**********************************************************************************/
/* 결산대체조정자료를 자동으로 전표 처리한다.													*/
/************************************************************************************/
String  sFromYm,sToYm
Long    lJunNo

sFromym = dw_ip.GetItemString(dw_ip.GetRow(),"frym")
sToYm   = dw_ip.GetItemString(dw_ip.GetRow(),"toym")

w_mdi_frame.sle_msg.text ="결산대체 전표 처리 중 ..."
SetPointer(HourGlass!)

dw_junpoy.Reset()

/*전표번호 채번*/
lJunNo = Sqlca.Fun_Calc_JunNo('B',sSaupj,sUpmuGbn,sBalDate)

Wf_ReplaceJpy_Product(sSaupj,sBalDate,lJunNo,sFromym,sToYm)

Wf_ReplaceJpy_Profit(sSaupj,sBalDate,lJunNo,sFromym,sToYm)

if dw_junpoy.RowCount() > 0 then
	IF dw_junpoy.Update() <> 1 THEN
//		F_MessageChk(13,'[미승인전표]')
//		SetPointer(Arrow!)
		Return -1
	END IF
	
	IF dw_rtv.Update() <> 1 THEN
		F_MessageChk(13,'[결산조정자료-제조]')
		SetPointer(Arrow!)	
		RETURN -1
	END IF
	
	IF dw_sonik.Update() <> 1 THEN
		F_MessageChk(13,'[결산조정자료-손익]')
		SetPointer(Arrow!)	
		RETURN -1
	END IF
	Commit;
end if

w_mdi_frame.sle_msg.text ="결산대체 전표 처리 완료!!"
SetPointer(Arrow!)

Return 1
end function

public subroutine wf_calculation ();Integer  iRowcount, k, i,iFindRow
Long     lBalanceCd
Double   dAmount,dResult = 0
String	sEditGbn,sCalcTag
String   sColNm[4]  = {'ref_cd1', 'ref_cd2', 'ref_cd3', 'ref_cd4'}
String   sCalcNm[4] = {'   ',     'calc1',   'calc2',   'calc3'}

dw_rtv.AcceptText()

iRowCount = dw_rtv.RowCount()
For k = 1 To iRowCount
	sEditGbn = dw_rtv.GetItemString(k,"editgbn")
	
	if sEditGbn = '4' then 		/*자동계산*/
		For i = 1 To 4
			lBalanceCd = dw_rtv.GetItemNumber(k,sColNm[i])
			if lBalanceCd = 0 or IsNull(lBalanceCd) then
				dAmount = 0
			else
				iFindRow = dw_rtv.Find("str_balance_cd = '"+String(lBalanceCd)+"'",1,iRowCount)
				if iFindRow > 0 then
					dAmount = dw_rtv.GetItemNumber(iFindRow,"amount")
					if IsNull(dAmount) then dAmount = 0
				else
					dAmount = 0
				end if
			end if
			
			if i = 1 then
				sCalcTag = '+'
			else
				sCalcTag   = dw_rtv.GetItemString(k,sCalcNm[i])
			end if
			
			if sCalcTag = '+' then
				dResult = dResult + dAmount
			elseif sCalcTag = '-' then
				dResult = dResult - dAmount
			end if
		Next
		dw_rtv.SetItem(k, "amount", dResult)	
		
		dResult = 0
	end if	
Next

dw_sonik.AcceptText()

iRowCount = dw_sonik.RowCount()
For k = 1 To iRowCount
	sEditGbn = dw_sonik.GetItemString(k,"editgbn")
	
	if sEditGbn = '4' then 		/*자동계산*/
		For i = 1 To 4
			lBalanceCd = dw_sonik.GetItemNumber(k,sColNm[i])
			if lBalanceCd = 0 or IsNull(lBalanceCd) then
				dAmount = 0
			else
				iFindRow = dw_sonik.Find("str_balance_cd = '"+String(lBalanceCd)+"'",1,iRowCount)
				if iFindRow > 0 then
					dAmount = dw_sonik.GetItemNumber(iFindRow,"amount")
					if IsNull(dAmount) then dAmount = 0
				else
					dAmount = 0
				end if
			end if
			
			if i = 1 then
				sCalcTag = '+'
			else
				sCalcTag   = dw_sonik.GetItemString(k,sCalcNm[i])
			end if
			
			if sCalcTag = '+' then
				dResult = dResult + dAmount
			elseif sCalcTag = '-' then
				dResult = dResult - dAmount
			end if
		Next
		dw_sonik.SetItem(k, "amount", dResult)	
		
		dResult = 0	
	elseif sEditGbn = '3' then 		/*제조코드 참조*/
		lBalanceCd = dw_sonik.GetItemNumber(k,  "ref_balcd")
		if lBalanceCd = 0 or IsNull(lBalanceCd) then
			dAmount = 0
		else
			iFindRow = dw_rtv.Find("str_balance_cd = '"+String(lBalanceCd)+"'",1,dw_rtv.RowCount())
			if iFindRow > 0 then
				dAmount = dw_rtv.GetItemNumber(iFindRow,"amount")
				if IsNull(dAmount) then dAmount = 0
			else
				dAmount = 0
			end if
		end if
		dw_sonik.SetItem(k, "amount", dAmount)	
	end if
Next

end subroutine

public subroutine wf_replacejpy_profit (string ssaupj, string sbaldate, long ljunno, string sfrym, string stoym);String   sBalGbn,sBalAcCd,sJpyGbn,sAmtGbn,sSysAcc,sAcc_Cha,sDcGbn,sAcc_Dae,sDescr,sAcc,sAccDc
Long     lBalCd,iCurRow
Double   dAmount,dAmtJpy
Integer  k

w_mdi_frame.sle_msg.text ="결산대체 전표[손익] 처리 중 ..."
SetPointer(HourGlass!)

For k = 1 To dw_sonik.RowCount()
	lBalCd   = dw_sonik.GetItemNumber(k,"balance_cd")
	dAmount  = dw_sonik.GetItemNumber(k,"amount")
	sJpyGbn  = dw_sonik.GetItemString(k,"jpygbn")
	if IsNull(dAmount) then dAmount = 0
	
	if dAmount <> 0 then
		if sJpyGbn = '2' then					/*계정별 발행*/
			sBalAcCd = dw_sonik.GetItemString(k,"balance_accd")
			sAmtGbn  = dw_sonik.GetItemString(k,"amtgbn")
	
			select nvl(acc2_nm,' '), dc_gu	into :sDescr, :sAccDc 	from kfz01om0 where acc1_cd||acc2_cd = :sBalAcCd;
			
			Declare Cur_MonthLst Cursor For
				select a.acc1_cd||a.acc2_cd,  
						 sum(decode(:sAmtGbn,'2', nvl(a.dr_amt,0) ,'3',nvl(a.cr_amt,0),'4',decode(c.dc_gu,'1', nvl(a.dr_amt,0) - nvl(a.cr_amt,0),'2',nvl(a.cr_amt,0) - nvl(a.dr_amt,0)),0))
					from kfz14ot0 a, kfz01om0 c
					where a.acc1_cd = c.acc1_cd and a.acc2_cd = c.acc2_cd and
							a.saupj = :sSaupj and 
							a.acc_yy||a.acc_mm >= :sFrYm and a.acc_yy||a.acc_mm <= :sToYm and
							a.acc1_cd||a.acc2_cd >= 
								(select fracc1_cd||fracc2_cd from kfz01om0 where acc1_cd||acc2_cd = :sBalAcCd) and
							a.acc1_cd||a.acc2_cd <= 
								(select toacc1_cd||toacc2_cd from kfz01om0 where acc1_cd||acc2_cd = :sBalAcCd) and	
							c.bal_gu <> '4' 
					group by a.acc1_cd||a.acc2_cd;
					
			open Cur_MonthLst;
			Do While True
				Fetch Cur_MonthLst into :sAcc, :dAmtJpy ;
				if sqlca.sqlcode <> 0 then Exit
				if IsNull(dAmtJpy) then dAmtJpy = 0
				
				if sAccDc = '1' then					/*차변*/
					sDcGbn = '2'
				elseif sAccDc = '2' then				/*대변*/
					sDcGbn = '1'
				end if
				
				if dAmtJpy <> 0 then
					iCurRow = dw_junpoy.InsertRow(0)
				
					dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
					dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
					dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
					dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
					dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
					
					dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
					dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc,5))
					dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc,2))
					dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
					dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					dw_junpoy.SetItem(iCurRow,"amt",     dAmtJpy)			
					dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[손익]'+'-'+sDescr)		
					dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 					
				end if
			Loop
			Close Cur_MonthLst;
			
			sDcGbn = sAccDc
			
			/*손익대체계정*/
			select substr(dataname,1,7) into :sAcc	from syscnfg 
				where sysgu = 'A' and serial = 94 and lineno = '22';
			
			iCurRow = dw_junpoy.InsertRow(0)
		
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc,5))
			dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc,2))
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)			
			dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[손익]'+'-'+sDescr)		
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			
			dw_sonik.SetItem(k,"accjunno",sSaupj+sBalDate+sUpmuGbn+String(lJunNo,'0000'))
		elseif sJpyGbn = '3' then				/*자기계정 발행*/
			sSysAcc  = dw_sonik.GetItemString(k,"sys_acc")
			
			select acc2_nm into :sDescr	from kfz01om0 where acc1_cd||acc2_cd = substr(:sSysAcc,8,7) ;
				
			sDcGbn = '1'											/*차변*/
			sAcc_Cha  = Left(sSysAcc,7)			
		
			iCurRow = dw_junpoy.InsertRow(0)
		
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Cha,5))
			dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Cha,2))
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)			
			dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[손익]'+'-'+sDescr)	
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			
			sDcGbn = '2'									/*대변*/
			sAcc_Dae  = Mid(sSysAcc,8,7)			
		
			iCurRow = dw_junpoy.InsertRow(0)
		
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Dae,5))
			dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Dae,2))
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)			
			dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[손익]'+'-'+sDescr)	
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 			
			
			dw_sonik.SetItem(k,"accjunno",sSaupj+sBalDate+sUpmuGbn+String(lJunNo,'0000'))
			
			if lBalCd = 1800 or lBalCd = 2800 then					/*손익대체-매출원가*/
				sDcGbn = '1'												/*차변*/
				
				select substr(dataname,1,7) into :sAcc_Cha	from syscnfg 
					where sysgu = 'A' and serial = 94 and lineno = '22';	
				
				select acc2_nm into :sDescr	from kfz01om0 where acc1_cd||acc2_cd = :sAcc_Cha ;
				
				iCurRow = dw_junpoy.InsertRow(0)
	
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
				
				dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Cha,5))
				dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Cha,2))
				dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				dw_junpoy.SetItem(iCurRow,"amt",     dAmount)			
				dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[손익]'+'-'+sDescr)		
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
				
				sDcGbn    = '2'												/*대변*/
				sSysAcc   = dw_sonik.GetItemString(k,"sys_acc")
				sAcc_Dae  = Left(sSysAcc,7)
				
				select acc2_nm into :sDescr	from kfz01om0 where acc1_cd||acc2_cd = :sAcc_Dae ;
				
				iCurRow = dw_junpoy.InsertRow(0)
			
				dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
				dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
				dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
				dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
				dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
				
				dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
				dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Dae,5))
				dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Dae,2))
				dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
				dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
				dw_junpoy.SetItem(iCurRow,"amt",     dAmount)			
				dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[손익]'+'-'+sDescr)	
				dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			
			end if
			
		end if
	end if	
Next

/*당기순이익 손익 대체*/
String   sSonIkCd = '12000'
Integer  iFindRow

iFindRow = dw_sonik.Find("str_balance_cd = '"+sSonIkCd+"'",1,dw_sonik.RowCount())
if iFindRow > 0 then
	dAmount = dw_sonik.GetItemNumber(iFindRow,"amount")
	if IsNull(dAmount) then dAmount = 0
else
	dAmount = 0
end if

if dAmount <> 0 then
	if dAmount > 0 then
		sDcGbn = '1'											/*차변*/
		
		select substr(dataname,1,7) into :sAcc_Cha	from syscnfg 
					where sysgu = 'A' and serial = 94 and lineno = '22';	
	
		iCurRow = dw_junpoy.InsertRow(0)
	
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Cha,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Cha,2))
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		dw_junpoy.SetItem(iCurRow,"amt",     dAmount)			
		dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[당기순이익]')		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		sDcGbn = '2'												/*대변*/
		
		select substr(dataname,1,7) into :sAcc_Dae	from syscnfg 
					where sysgu = 'A' and serial = 94 and lineno = '23';	
		
		iCurRow = dw_junpoy.InsertRow(0)
	
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Dae,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Dae,2))
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		dw_junpoy.SetItem(iCurRow,"amt",     dAmount)			
		dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[당기순이익]')		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	else
		sDcGbn = '1'											/*차변*/
		
		select substr(dataname,1,7) into :sAcc_Cha	from syscnfg 
					where sysgu = 'A' and serial = 94 and lineno = '23';	
		
		iCurRow = dw_junpoy.InsertRow(0)
	
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Cha,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Cha,2))
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		dw_junpoy.SetItem(iCurRow,"amt",     Abs(dAmount))			
		dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[당기순이익]')		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
		sDcGbn = '2'												/*대변*/
			
		select substr(dataname,1,7) into :sAcc_Dae	from syscnfg 
					where sysgu = 'A' and serial = 94 and lineno = '22';	
	
		iCurRow = dw_junpoy.InsertRow(0)
	
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Dae,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Dae,2))
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		dw_junpoy.SetItem(iCurRow,"amt",     Abs(dAmount))			
		dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[당기순이익]')		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	end if
	dw_sonik.SetItem(iFindRow,"accjunno",sSaupj+sBalDate+sUpmuGbn+String(lJunNo,'0000'))
end if
end subroutine

public subroutine wf_replacejpy_product (string ssaupj, string sbaldate, long ljunno, string sfrym, string stoym);String   sBalGbn,sBalAcCd,sJpyGbn,sAmtGbn,sSysAcc,sAcc_Cha,sDcGbn,sAcc_Dae,sDescr
Long     lBalCd,iCurRow
Double   dAmount,dAmtJpy
Integer  k

w_mdi_frame.sle_msg.text ="결산대체 전표[제조] 처리 중 ..."
SetPointer(HourGlass!)

For k = 1 To dw_rtv.RowCount()
	lBalCd   = dw_rtv.GetItemNumber(k,"balance_cd")
	dAmount  = dw_rtv.GetItemNumber(k,"amount")
	sJpyGbn  = dw_rtv.GetItemString(k,"jpygbn")
	if IsNull(dAmount) then dAmount = 0
	
	if dAmount <> 0 then
		if sJpyGbn = '2' then					/*계정별 발행*/
			sBalAcCd = dw_rtv.GetItemString(k,"balance_accd")
			sAmtGbn  = dw_rtv.GetItemString(k,"amtgbn")
	
			select nvl(acc2_nm,' ')	into :sDescr	from kfz01om0 where acc1_cd||acc2_cd = :sBalAcCd;
			
			sDcGbn = '1'											/*차변*/
			
			select substr(dataname,1,7) into :sAcc_Cha	from syscnfg 
				where sysgu = 'A' and serial = 94 and lineno = '13';
			
			iCurRow = dw_junpoy.InsertRow(0)
		
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Cha,5))
			dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Cha,2))
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)			
			dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[제조]'+'-'+sDescr)		
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			
			dw_rtv.SetItem(k,"accjunno",sSaupj+sBalDate+sUpmuGbn+String(lJunNo,'0000'))
			
			Declare Cur_MonthLst Cursor For
				select a.acc1_cd||a.acc2_cd,  
						 sum(decode(:sAmtGbn,'2', nvl(a.dr_amt,0) ,'3',nvl(a.cr_amt,0),'4',decode(c.dc_gu,'1', nvl(a.dr_amt,0) - nvl(a.cr_amt,0),'2',nvl(a.cr_amt,0) - nvl(a.dr_amt,0)),0))
					from kfz14ot0 a, kfz01om0 c
					where a.acc1_cd = c.acc1_cd and a.acc2_cd = c.acc2_cd and
							a.saupj = :sSaupj and 
							a.acc_yy||a.acc_mm >= :sFrYm and a.acc_yy||a.acc_mm <= :sToYm and
							a.acc1_cd||a.acc2_cd >= 
								(select fracc1_cd||fracc2_cd from kfz01om0 where acc1_cd||acc2_cd = :sBalAcCd) and
							a.acc1_cd||a.acc2_cd <= 
								(select toacc1_cd||toacc2_cd from kfz01om0 where acc1_cd||acc2_cd = :sBalAcCd) and	
							c.bal_gu <> '4' 
					group by a.acc1_cd||a.acc2_cd;
				
				
			open Cur_MonthLst;
			Do While True
				Fetch Cur_MonthLst into :sAcc_Dae, :dAmtJpy ;
				if sqlca.sqlcode <> 0 then Exit
				if IsNull(dAmtJpy) then dAmtJpy = 0
		
		
				if dAmtJpy <> 0 then
					sDcGbn = '2'												/*대변*/
					
					iCurRow = dw_junpoy.InsertRow(0)
				
					dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
					dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
					dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
					dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
					dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
					
					dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
					dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Dae,5))
					dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Dae,2))
					dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
					dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
					dw_junpoy.SetItem(iCurRow,"amt",     dAmtJpy)			
					dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[제조]'+'-'+sDescr)		
					dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 					
				end if
			Loop
			Close Cur_MonthLst;
			
		elseif sJpyGbn = '3' then				/*자기계정 발행*/
			sSysAcc  = dw_rtv.GetItemString(k,"sys_acc")
				
			sDcGbn = '1'											/*차변*/
			sAcc_Cha  = Left(sSysAcc,7)			
		
			select acc2_nm into :sDescr	from kfz01om0 where acc1_cd||acc2_cd = :sAcc_Cha ;
			
			iCurRow = dw_junpoy.InsertRow(0)
		
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Cha,5))
			dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Cha,2))
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)			
			dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[제조]'+'-'+sDescr)		
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
			
			sDcGbn = '2'									/*대변*/
			sAcc_Dae  = Mid(sSysAcc,8,7)			
		
			iCurRow = dw_junpoy.InsertRow(0)
		
			dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
			dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
			dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
			dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
			dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
			
			dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
			dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Dae,5))
			dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Dae,2))
			dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
			dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
			dw_junpoy.SetItem(iCurRow,"amt",     dAmount)			
			dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[제조]'+'-'+sDescr)			
			dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 			
			
			dw_rtv.SetItem(k,"accjunno",sSaupj+sBalDate+sUpmuGbn+String(lJunNo,'0000'))
		end if
	end if	
Next

/*재료비-제조대체계정으로 대체*/
Double dAmount1,dAmount2
String sCd1 = '1900',sCd2 = '2700'

if dw_rtv.Find("str_balance_cd = '"+sCd1+"'",1,dw_rtv.RowCount()) > 0 then
	dAmount1 = dw_rtv.GetItemNumber(dw_rtv.Find("str_balance_cd = '"+sCd1+"'",1,dw_rtv.RowCount()),"amount")
	if IsNull(dAmount1) then dAmount1 = 0
else
	dAmount1 = 0
end if

if dw_rtv.Find("str_balance_cd = '"+sCd2+"'",1,dw_rtv.RowCount()) > 0 then
	dAmount2 = dw_rtv.GetItemNumber(dw_rtv.Find("str_balance_cd = '"+sCd2+"'",1,dw_rtv.RowCount()),"amount")
	if IsNull(dAmount2) then dAmount2 = 0
else
	dAmount2 = 0
end if

if dAmount1 + dAmount2 <> 0 then
	sDcGbn = '1'											/*차변*/
	
	select substr(dataname,1,7) into :sAcc_Cha	from syscnfg 
				where sysgu = 'A' and serial = 94 and lineno = '13';	

	iCurRow = dw_junpoy.InsertRow(0)

	dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
	dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
	dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
	dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
	dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
	
	dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
	dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Cha,5))
	dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Cha,2))
	dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
	dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
	dw_junpoy.SetItem(iCurRow,"amt",     dAmount1 + dAmount2)			
	dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[제조]')		
	dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
		
	if dAmount1 <> 0 then
		sDcGbn = '2'									/*대변*/
		
		select substr(dataname,1,7) into :sAcc_Dae	from syscnfg 
				where sysgu = 'A' and serial = 94 and lineno = '10';
	
		iCurRow = dw_junpoy.InsertRow(0)
	
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Dae,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Dae,2))
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		dw_junpoy.SetItem(iCurRow,"amt",     dAmount1)			
		dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[제조]')		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	end if
	
	if dAmount2 <> 0 then
		sDcGbn = '2'									/*대변*/
		
		select substr(dataname,1,7) into :sAcc_Dae	from syscnfg 
				where sysgu = 'A' and serial = 94 and lineno = '11';
	
		iCurRow = dw_junpoy.InsertRow(0)
	
		dw_junpoy.SetItem(iCurRow,"saupj",   sSaupj)
		dw_junpoy.SetItem(iCurRow,"bal_date",sBalDate)
		dw_junpoy.SetItem(iCurRow,"upmu_gu", sUpmuGbn)
		dw_junpoy.SetItem(iCurRow,"bjun_no", lJunNo)
		dw_junpoy.SetItem(iCurRow,"lin_no",  iCurRow)
		
		dw_junpoy.SetItem(iCurRow,"dept_cd", Gs_Dept)	
		dw_junpoy.SetItem(iCurRow,"acc1_cd", Left(sAcc_Dae,5))
		dw_junpoy.SetItem(iCurRow,"acc2_cd", Right(sAcc_Dae,2))
		dw_junpoy.SetItem(iCurRow,"sawon",   Gs_EmpNo)	
		dw_junpoy.SetItem(iCurRow,"dcr_gu",  sDcGbn)
		dw_junpoy.SetItem(iCurRow,"amt",     dAmount2)			
		dw_junpoy.SetItem(iCurRow,"descr",   '결산대체 전표[제조]')		
		dw_junpoy.SetItem(iCurRow,"indat",   F_Today()) 
	end if
end if
end subroutine

on w_kgle41.create
int iCurrent
call super::create
this.dw_junpoy=create dw_junpoy
this.dw_sungin=create dw_sungin
this.dw_print=create dw_print
this.dw_ip=create dw_ip
this.rr_2=create rr_2
this.dw_rtv=create dw_rtv
this.dw_sonik=create dw_sonik
this.p_create=create p_create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_junpoy
this.Control[iCurrent+2]=this.dw_sungin
this.Control[iCurrent+3]=this.dw_print
this.Control[iCurrent+4]=this.dw_ip
this.Control[iCurrent+5]=this.rr_2
this.Control[iCurrent+6]=this.dw_rtv
this.Control[iCurrent+7]=this.dw_sonik
this.Control[iCurrent+8]=this.p_create
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.rb_2
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.rr_1
end on

on w_kgle41.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_junpoy)
destroy(this.dw_sungin)
destroy(this.dw_print)
destroy(this.dw_ip)
destroy(this.rr_2)
destroy(this.dw_rtv)
destroy(this.dw_sonik)
destroy(this.p_create)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.Getrow(),"saupj",gs_saupj)

dw_ip.SetItem(dw_ip.Getrow(),"frym",Left(f_today(),6))
dw_ip.SetItem(dw_ip.Getrow(),"toym",Left(f_today(),6))

dw_ip.SetItem(dw_ip.Getrow(),"acc_date",f_today())

dw_rtv.SetTransObject(SQLCA)
dw_sonik.SetTransObject(SQLCA)
dw_insert.SetTransObject(Sqlca)

dw_print.SetTransObject(SQLCA)

dw_junpoy.SetTransObject(SQLCA)
dw_sungin.SetTransObject(SQLCA)

p_mod.Enabled =False

SELECT "SYSCNFG"."DATANAME"      INTO :LsAutoSungGbn  			/*자동 승인 여부 체크*/
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 9 ) AND  
         ( "SYSCNFG"."LINENO" = '90' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	LsAutoSungGbn = 'N'
ELSE
	IF IsNull(LsAutoSungGbn) THEN LsAutoSungGbn = 'N'
END IF

dw_ip.SetColumn("frym")
dw_ip.SetFocus()

end event

type dw_insert from w_inherite`dw_insert within w_kgle41
integer x = 192
integer y = 2776
integer width = 1029
integer height = 96
integer taborder = 0
boolean titlebar = true
string title = "저장"
string dataobject = "dw_kgle413"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

type p_delrow from w_inherite`p_delrow within w_kgle41
boolean visible = false
integer x = 2747
integer y = 2848
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kgle41
boolean visible = false
integer x = 2574
integer y = 2848
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kgle41
boolean visible = false
integer x = 1879
integer y = 2848
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kgle41
boolean visible = false
integer x = 2400
integer y = 2848
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kgle41
integer y = 16
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_kgle41
boolean visible = false
integer x = 3269
integer y = 2848
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_kgle41
boolean visible = false
integer x = 2158
integer y = 2864
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kgle41
integer x = 3749
integer y = 12
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String   sSaupj,sFrym,sToYm,sJunno,sAlcGbn
Integer  iCount,iFindRow

IF dw_ip.AcceptText() = -1 THEN RETURN

sSaupj  = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sFrym   = dw_ip.GetItemString(dw_ip.GetRow(),"frym")
sToYm   = dw_ip.GetItemString(dw_ip.GetRow(),"toym")

IF ssaupj ="" OR IsNull(ssaupj) THEN
	F_MessageChk(1,'[사업장]')	
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return 
END IF

IF sFrym = "" OR IsNull(sFrym) THEN
	F_MessageChk(1,'[결산조정년월]')	
	dw_ip.SetColumn("frym")
	dw_ip.SetFocus()
	Return 
END IF

IF sToym = "" OR IsNull(sToym) THEN
	F_MessageChk(1,'[결산조정년월]')	
	dw_ip.SetColumn("toym")
	dw_ip.SetFocus()
	Return 
END IF

select Count(*)	into :iCount
	from kfz35ot0
	where saupj = :sSaupj and fromym = :sFrYm and toym = :sToYm;
if sqlca.sqlcode = 0 and iCount > 0 then			/*수정*/
	LsStatus = 'M'	
else															/*신규*/
	LsStatus = 'I'	
end if

dw_rtv.SetRedraw(False)
dw_sonik.SetRedraw(False)
if LsStatus = 'M' then
	dw_rtv.DataObject   = 'dw_kgle413'
	dw_sonik.DataObject = 'dw_kgle413'
else
	dw_rtv.DataObject   = 'dw_kgle412'
	dw_sonik.DataObject = 'dw_kgle412'
end if
dw_rtv.SetTransObject(Sqlca)
dw_sonik.SetTransObject(Sqlca)

dw_rtv.Retrieve(sSaupj,sFrYm,sToYm,'1')
dw_sonik.Retrieve(sSaupj,sFrYm,sToYm,'2')

dw_rtv.SetRedraw(True)
dw_sonik.SetRedraw(True)

if LsStatus = 'I' then
	Wf_Calculation()
	
	p_del.Enabled = False
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"
	
	p_mod.Enabled = True
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
	
	p_create.Enabled = False
	p_create.PictureName = "C:\erpman\image\처리_d.gif"	
			
	rb_1.Checked = True
	rb_2.Checked = False
else
	if dw_rtv.RowCount() > 0 then
		iFindRow = dw_rtv.Find("jpygbn <> '1'",1,dw_rtv.RowCount())
	else
		iFindRow = dw_sonik.Find("jpygbn <> '1'",1,dw_sonik.RowCount())
	end if
	
	if iFindRow > 0 then
		if dw_rtv.RowCount() > 0 then
			sJunno = dw_rtv.GetItemString(iFindRow,"max_accno")
			if sJunNo = '' or IsNull(sJunNo) then
				iFindRow = dw_sonik.Find("jpygbn <> '1'",1,dw_sonik.RowCount())	
				sJunno = dw_sonik.GetItemString(iFindRow,"max_accno")
			end if
		else
			sJunno = dw_sonik.GetItemString(iFindRow,"max_accno")
		end if
		
		if sJunNo = '' or IsNull(sJunNo) then				/*전표 처리 안 했으면*/
			p_del.Enabled = True
			p_del.PictureName = "C:\erpman\image\삭제_up.gif"
			
			p_mod.Enabled = True
			p_mod.PictureName = "C:\erpman\image\저장_up.gif"	
			
			p_create.Enabled = True
			p_create.PictureName = "C:\erpman\image\처리_up.gif"	
			
			rb_1.Checked = True
			rb_2.Checked = False
		else
			select distinct alc_gu	into :sAlcGbn	from kfz12ot0
				where saupj   = substr(:sJunNo,1,2) and bal_date = substr(:sJunNo,3,8) and
						upmu_gu = substr(:sJunNo,11,1) and bjun_no = to_number(substr(:sJunNo,12,4)) ;
			if sqlca.sqlcode = 0 then
				if IsNull(sAlcGbn) then sAlcGbn = 'N'
			else
				sAlcGbn = 'N'
			end if
			
			if sAlcGbn = 'Y' then
				p_del.Enabled = False
				p_del.PictureName = "C:\erpman\image\삭제_d.gif"
				
				p_mod.Enabled = False
				p_mod.PictureName = "C:\erpman\image\저장_d.gif"	
				
				p_create.Enabled = False
				p_create.PictureName = "C:\erpman\image\처리_d.gif"	
			else
				p_del.Enabled = False
				p_del.PictureName = "C:\erpman\image\삭제_d.gif"
				
				p_mod.Enabled = False
				p_mod.PictureName = "C:\erpman\image\저장_d.gif"	
				
				p_create.Enabled = True
				p_create.PictureName = "C:\erpman\image\처리_up.gif"	
				
				rb_1.Checked = False
				rb_2.Checked = True
			end if
		end if
	else
		p_del.Enabled = False
		p_del.PictureName = "C:\erpman\image\삭제_d.gif"
		
		p_mod.Enabled = False
		p_mod.PictureName = "C:\erpman\image\저장_d.gif"
		
		p_create.Enabled = False
		p_create.PictureName = "C:\erpman\image\처리_d.gif"	
	end if
end if


end event

type p_del from w_inherite`p_del within w_kgle41
integer y = 12
integer taborder = 0
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;Integer iFlag,k,iRowCount
String   sSaupj,sFrym,sToYm

IF dw_ip.AcceptText() = -1 THEN RETURN
sSaupj  = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sFrym   = dw_ip.GetItemString(dw_ip.GetRow(),"frym")
sToYm   = dw_ip.GetItemString(dw_ip.GetRow(),"toym")

IF f_dbConFirm('삭제') = 2 THEN RETURN

iRowCount = dw_rtv.RowCount()
dw_rtv.SetRedraw(False)
For k = iRowCount To 1 Step -1
	dw_rtv.DeleteRow(k)
Next
dw_rtv.SetRedraw(True)

iRowCount = dw_sonik.RowCount()
dw_sonik.SetRedraw(False)
For k = iRowCount To 1 Step -1
	dw_sonik.DeleteRow(k)
Next
dw_sonik.SetRedraw(True)

if dw_rtv.Update() = 1 and dw_sonik.Update() = 1 then
	commit;
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다."
else
	ROLLBACK;
	f_messagechk(12,'')
	Return	
end if


	
end event

type p_mod from w_inherite`p_mod within w_kgle41
integer y = 12
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event p_mod::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event p_mod::clicked;call super::clicked;Integer iFlag,k,iRowCount,iCurRow
String   sSaupj,sFrym,sToYm

IF dw_ip.AcceptText() = -1 THEN RETURN
sSaupj  = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sFrym   = dw_ip.GetItemString(dw_ip.GetRow(),"frym")
sToYm   = dw_ip.GetItemString(dw_ip.GetRow(),"toym")

if dw_rtv.AcceptText() = -1 then Return
if dw_sonik.AcceptText() = -1 then Return

Wf_Calculation()

IF f_dbConFirm('저장') = 2 THEN RETURN
SetPointer(HourGlass!)

if LsStatus = 'I' then					/*신규*/
	
	dw_insert.Retrieve(sSaupj,sFrYm,sToYm,'%')
	
	iRowCount = dw_rtv.RowCount()
	For k = 1 To iRowCount
		iCurRow = dw_insert.InsertRow(0)
		
		dw_insert.SetItem(iCurRow,"saupj",   sSaupj)
		dw_insert.SetItem(iCurRow,"fromym",  sFrym)
		dw_insert.SetItem(iCurRow,"toym",    sToym)
		dw_insert.SetItem(iCurRow,"bal_gu",  '1')
		dw_insert.SetItem(iCurRow,"bal_cd",  dw_rtv.GetItemNumber(k,"balance_cd"))
		dw_insert.SetItem(iCurRow,"amount",  dw_rtv.GetItemNumber(k,"amount"))
	Next
	
	iRowCount = dw_sonik.RowCount()
	For k = 1 To iRowCount
		iCurRow = dw_insert.InsertRow(0)
		
		dw_insert.SetItem(iCurRow,"saupj",   sSaupj)
		dw_insert.SetItem(iCurRow,"fromym",  sFrym)
		dw_insert.SetItem(iCurRow,"toym",    sToym)
		dw_insert.SetItem(iCurRow,"bal_gu",  '2')
		dw_insert.SetItem(iCurRow,"bal_cd",  dw_sonik.GetItemNumber(k,"balance_cd"))
		dw_insert.SetItem(iCurRow,"amount",  dw_sonik.GetItemNumber(k,"amount"))
	Next
	iFlag = dw_insert.Update()		
else
	if dw_rtv.Update() = 1 and dw_sonik.Update() = 1 then
		iFlag = 1
	else
		iFlag = -1
	end if
end if
SetPointer(Arrow!)

IF iFlag = 1 THEN
	commit;
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
	Return
END IF	
p_inq.TriggerEvent(Clicked!)

if MessageBox('확 인','전표 처리하시겠습니까?',Question!,YesNo!) = 1 then
	p_create.TriggerEvent(Clicked!)
end if




	
end event

type cb_exit from w_inherite`cb_exit within w_kgle41
integer x = 4055
integer y = 2792
end type

type cb_mod from w_inherite`cb_mod within w_kgle41
integer x = 3717
integer y = 2792
string text = "처리(&P)"
end type

type cb_ins from w_inherite`cb_ins within w_kgle41
integer x = 2464
integer y = 2592
end type

type cb_del from w_inherite`cb_del within w_kgle41
integer x = 2871
integer y = 2584
end type

type cb_inq from w_inherite`cb_inq within w_kgle41
integer x = 3355
integer y = 2792
end type

type cb_print from w_inherite`cb_print within w_kgle41
integer x = 2121
integer y = 2592
end type

event cb_print::clicked;call super::clicked;//String  sSaupj,sUpmuGu,sBalDate,sCvcod,sMaYm
//Long    lBJunNo,lSeqNo
//Integer i
//
//IF MessageBox("확 인", "출력하시겠습니까?", Question!, OkCancel!, 2) = 2 THEN RETURN
//
//FOR i = 1 TO dw_rtv.RowCount()
//	IF dw_rtv.GetItemString(i,"chk") = '1' THEN
//		sCvcod   = dw_rtv.GetItemString(i,"cvcod")
//		sMaYm    = dw_rtv.GetItemString(i,"mayymm")
//		lSeqNo   = dw_rtv.GetItemNumber(i,"mayyseq")
//		
//		sSaupj   = dw_rtv.GetItemString(i,"saupj")
//		sBalDate = dw_rtv.GetItemString(i,"bal_date") 
//		sUpmuGu  = dw_rtv.GetItemString(i,"upmu_gu") 
//		lBJunNo  = dw_rtv.GetItemNumber(i,"bjun_no") 
//		
//		IF F_Print_Junpoy(dw_print,sSaupj,sBalDate,sUpmuGu,lBJunNo,'%') = -1 THEN
//			F_MessageChk(14,'')
//			Return 1
//		ELSE
//			dw_print.object.datawindow.print.preview="yes"
//			OpenWithParm(w_print_options, dw_Print)
//		END IF
//	END IF
//NEXT
//
end event

type st_1 from w_inherite`st_1 within w_kgle41
integer x = 0
integer y = 2376
end type

type cb_can from w_inherite`cb_can within w_kgle41
integer x = 3218
integer y = 2580
end type

type cb_search from w_inherite`cb_search within w_kgle41
integer x = 1609
integer y = 2596
integer width = 498
string text = "품목보기(&V)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kgle41
integer x = 2853
integer y = 2380
end type

type sle_msg from w_inherite`sle_msg within w_kgle41
integer x = 352
integer y = 2376
end type

type gb_10 from w_inherite`gb_10 within w_kgle41
integer y = 2336
end type

type gb_button1 from w_inherite`gb_button1 within w_kgle41
integer x = 2811
integer y = 2532
end type

type gb_button2 from w_inherite`gb_button2 within w_kgle41
integer x = 1563
integer y = 2768
integer width = 1129
end type

type dw_junpoy from datawindow within w_kgle41
boolean visible = false
integer x = 187
integer y = 2488
integer width = 1623
integer height = 136
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

event dberror;MessageBox('error',sqlerrtext+sTRING(sqldbcode)+String(row))
end event

type dw_sungin from datawindow within w_kgle41
boolean visible = false
integer x = 192
integer y = 2576
integer width = 1029
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "승인전표 라인별 저장"
string dataobject = "dw_kglc014"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_print from datawindow within w_kgle41
boolean visible = false
integer x = 192
integer y = 2672
integer width = 1029
integer height = 96
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

type dw_ip from u_key_enter within w_kgle41
event ue_key pbm_dwnkey
integer x = 23
integer y = 4
integer width = 2976
integer height = 216
integer taborder = 10
string dataobject = "dw_kgle411"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  snull,ssql,sSaupj,sDate,sChoose,sdeptCode,sSdeptCode
Integer i

SetNull(snull)

w_mdi_frame.sle_msg.text = ''

IF this.GetColumnName() ="saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :ssql
		FROM "REFFPF"  
  		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND ( "REFFPF"."RFGUB" <> '99' )   AND 
  	         ( "REFFPF"."RFGUB" = :sSaupj )   ;
	IF sqlca.sqlcode <> 0 then
  	  	f_messagechk(20,"[사업장]")
		dw_ip.SetItem(1,"saupj",snull)
		Return 1
  	end if
END IF

IF this.GetColumnName() ="baldate" THEN
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN 
	
	IF f_datechk(sDate) = -1 THEN
		f_messagechk(20,"결산기준일")
		dw_ip.SetItem(1,"baldate",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "deptcode" THEN
	sdeptCode = this.GetText()	
	IF sdeptCode = "" OR IsNull(sdeptCode) THEN RETURN
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sSql
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sDeptCode) AND ( "KFZ04OM0"."PERSON_GU" = '3');
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[작성부서]')
		this.SetItem(1,"deptcode",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "sdeptcode" THEN
	sSdeptCode = this.GetText()	
	IF sSdeptCode = "" OR IsNull(sSdeptCode) THEN RETURN
	
	SELECT "VW_CDEPT_CODE"."COST_CD"  INTO :sSdeptCode  
		FROM "VW_CDEPT_CODE"  
		WHERE "VW_CDEPT_CODE"."COST_CD" = :sSdeptCode   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[원가부문]')
		this.SetItem(1,"sdeptcode",snull)
		Return 1
	END IF
END IF

end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="custf" THEN
	
	OpenWithParm(W_Kfz04om0_POPUP,'1')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"custf",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"custfname", lstr_custom.name)
ELSEIF this.GetColumnName() ="custt" THEN
	OpenWithParm(W_Kfz04om0_POPUP,'1')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"custt",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"custtname", lstr_custom.name)
ELSEIF this.GetColumnName() ="deptf" THEN
	OpenWithParm(W_Kfz04om0_POPUP,'3')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"deptf",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"deptfname", lstr_custom.name)
ELSEIF this.GetColumnName() ="deptt" THEN
	OpenWithParm(W_Kfz04om0_POPUP,'3')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"deptt",     lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"depttname", lstr_custom.name)
END IF

end event

event getfocus;this.AcceptText()
end event

type rr_2 from roundrectangle within w_kgle41
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 220
integer width = 4576
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_rtv from datawindow within w_kgle41
integer x = 123
integer y = 284
integer width = 1915
integer height = 1872
integer taborder = 30
string dataobject = "dw_kgle412"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;this.AcceptText()
end event

event itemchanged;
Wf_Calculation()
end event

event itemerror;Return 1
end event

type dw_sonik from datawindow within w_kgle41
integer x = 2240
integer y = 284
integer width = 1915
integer height = 1872
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_kgle412"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;this.AcceptText()
end event

event itemerror;Return 1
end event

event itemchanged;Wf_Calculation()
end event

type p_create from uo_picture within w_kgle41
integer x = 4270
integer y = 12
integer width = 178
integer taborder = 60
boolean bringtotop = true
string pointer = "C:\erpman\cur\create.cur"
boolean enabled = false
string picturename = "C:\erpman\image\처리_d.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

event clicked;String sSaupj,sBalDate

IF dw_ip.AcceptText() = -1 THEN RETURN
sSaupj   = dw_ip.GetItemString(dw_ip.GetRow(),"saupj")
sBalDate = dw_ip.GetItemString(dw_ip.GetRow(),"acc_date")

if dw_rtv.RowCount() <=0 and dw_sonik.RowCount() <=0 then
	MessageBox('확인','처리할 자료가 없습니다')
	Return
end if

IF rb_1.Checked =True THEN
	IF sBalDate = "" OR IsNull(sBalDate) THEN
		F_MessageChk(1,'[전표일자]')
		dw_ip.Setcolumn("acc_date")
		dw_ip.SetFocus()
		Return 
	ELSE
		IF F_Check_LimitDate(sBalDate,'B') = -1 THEN
			F_MessageChk(29,'[발행일자]')
			Return 
		END IF
	END IF
	
	IF Wf_Create_Kfz12ot0(sSaupj,sBalDate) = -1 THEN
		Rollback;
		Return
	ELSE	
		Commit;
		/*자동 승인 처리*/
		IF LsAutoSungGbn = 'Y' THEN
			w_mdi_frame.sle_msg.text = '승인 처리 중...'
			IF F_Insert_SungIn(dw_junpoy,dw_sungin) = -1 THEN 
				Rollback;
				F_MessageChk(13,'[전표 승인]')
				Return
			END IF
		END IF
	END IF
	
ELSE
	IF dw_rtv.RowCount() <=0 and dw_sonik.RowCount() <=0 THEN Return
	
	IF Wf_Delete_Kfz12ot0() = -1 THEN
		Rollback;
		Return
	ELSE
		Commit;
	END IF
END IF

p_inq.TriggerEvent(Clicked!)

end event

type rb_1 from radiobutton within w_kgle41
integer x = 3067
integer y = 36
integer width = 471
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "전표발행처리"
boolean checked = true
end type

event clicked;//IF rb_1.Checked =True THEN
//	dw_rtv.Title ="외화평가 자동전표 발행"
//
//	dw_rtv.Visible =True
//	dw_delete.Visible =False
//END IF
//dw_rtv.Reset()
//
//dw_ip.SetColumn("baldate")
//dw_ip.SetFocus()
//
//



end event

type rb_2 from radiobutton within w_kgle41
integer x = 3072
integer y = 108
integer width = 471
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "전표삭제처리"
end type

event clicked;//IF rb_2.Checked =True THEN
//	dw_delete.Title ="외화평가 자동전표 삭제"
//	
//	dw_rtv.Visible =False
//	dw_delete.Visible =True
//END IF
//dw_delete.Reset()
//
//dw_ip.SetColumn("baldate")
//dw_ip.SetFocus()
//
//
end event

type gb_1 from groupbox within w_kgle41
integer x = 2185
integer y = 232
integer width = 2030
integer height = 1956
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "손익"
end type

type gb_2 from groupbox within w_kgle41
integer x = 73
integer y = 232
integer width = 2030
integer height = 1956
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "제조"
end type

type rr_1 from roundrectangle within w_kgle41
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3008
integer y = 16
integer width = 590
integer height = 180
integer cornerheight = 40
integer cornerwidth = 55
end type

