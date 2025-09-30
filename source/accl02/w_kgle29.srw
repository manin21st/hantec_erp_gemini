$PBExportHeader$w_kgle29.srw
$PBExportComments$외화평가익손 계산 명세서 조회 출력(반제사용안함)
forward
global type w_kgle29 from w_standard_print
end type
type dw_insert from datawindow within w_kgle29
end type
type rr_1 from roundrectangle within w_kgle29
end type
end forward

global type w_kgle29 from w_standard_print
integer x = 0
integer y = 0
string title = "외화평가손익 계산명세서 조회 출력"
dw_insert dw_insert
rr_1 rr_1
end type
global w_kgle29 w_kgle29

forward prototypes
public function integer wf_retrieve ()
public function integer wf_calculation_chaipf (string sratedate)
public function integer wf_create_acc (string sbasedate, string ssaupj, string sacc1, string sacc2, string sdcgbn)
public function integer wf_insert_kfz34ot0 (string ssaupj, string sbasedate)
end prototypes

public function integer wf_retrieve ();String  sBaseDate,sSaupj
Integer iCnt,iAcCnt,iRtnValue

sle_msg.text =""

dw_ip.AcceptText()

sSaupj    = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"saupj"))
sBaseDate = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"basedate"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sBaseDate = "" OR IsNull(sBaseDate) THEN
	F_MessageChk(1,'[결산기준일]')
	dw_ip.SetColumn("basedate")
	dw_ip.SetFocus()
	Return -1
END IF

IF dw_print.Retrieve(sSaupj,sBaseDate) > 0 THEN
	select count(*) into :iCnt from kfz34ot0 
		where owner_saupj = :sSaupj and closing_date = :sBaseDate;
	if sqlca.sqlcode = 0 and (iCnt <> 0 and Not IsNull(iCnt)) then
		select count(*) into :iAcCnt from kfz34ot0
			where owner_saupj = :sSaupj and closing_date = :sBaseDate and
					bal_date <> '' and bal_date is not null ;
		if sqlca.sqlcode = 0 and (iAcCnt <> 0 and Not IsNull(iAcCnt)) then
			MessageBox('확 인','이미 전표 발행 되었으므로 다시 생성할 수 없습니다...')
			Return -1	
		end if
	end if
	
	if sqlca.sqlcode = 0 and (iCnt <> 0 and Not IsNull(iCnt)) then
		IF MessageBox('확 인',"자료를 삭제 후 다시 생성합니다. 계속하시겠습니까",Question!,YesNo!) = 2 THEN Return 1
	
		delete from kfz34ot0 
			where owner_saupj = :sSaupj and closing_date = :sBaseDate;
		Commit;
	end if
END IF

/*kfz34ot0*/							 
iRtnValue = Wf_Insert_Kfz34ot0(sSaupj,sBaseDate)
IF iRtnValue = -1 THEN 
	F_MessageChk(13,'[외환평가손익 계산 명세서]')
	Rollback;
	Return -1
ELSEif iRtnValue = -2 THEN 
	F_MessageChk(14,'')
	Return -1	
ELSE
	dw_print.Retrieve(sSaupj,sBaseDate)
END IF

iRtnValue = Wf_Calculation_ChaipF(sBaseDate)
IF iRtnValue = -1 THEN 
	F_MessageChk(13,'[외화차입금 환평가 갱신]')
	Rollback;
	Return -1
ELSEif iRtnValue = -2 THEN 
	F_MessageChk(14,'[외화차입금 환평가]')
	Return -1	
ELSE
	Commit;
END IF

dw_print.ShareData(dw_list)

Return 1
end function

public function integer wf_calculation_chaipf (string sratedate);String   sLoCd,sRsDate,sCurr
Double   dRsAmtF, dRsItAmtF, dRsAmtW, dRsItAmtW, dRate
Integer  iWeight,iCount

select Count(*)		into :iCount
	from kfm03ot0 b,  kfm03ot1 a
	where b.lo_cd = a.lo_cd and substr(a.rs_date,1,4) > Substr(:sRateDate,1,4) and
			b.lo_curr <> 'WON' ;
if sqlca.sqlcode <> 0 or iCount <= 0 then
	Return -2
end if

DECLARE Cursor_Lst CURSOR FOR  
	select a.lo_cd,			a.rs_date,		nvl(a.rs_ycamt,0),			nvl(a.rs_yitamt,0),			b.lo_curr
		from kfm03ot0 b,  kfm03ot1 a
		where b.lo_cd = a.lo_cd and substr(a.rs_date,1,4) > Substr(:sRateDate,1,4) and
				b.lo_curr <> 'WON'
		order by a.lo_cd, a.rs_date;
		
Open Cursor_Lst;

Do While True
	Fetch Cursor_Lst Into :sLoCd,		:sRsDate,		:dRsAmtF,		:dRsItAmtF,		:sCurr;
	IF Sqlca.Sqlcode <> 0 then Exit
	
	select nvl(to_number(rfna2,1)      into :iWeight  						/*가중치*/
		from reffpf
		where rfcod = '10' and rfgub = :sCurr;
	IF SQLCA.SQLCODE <> 0 THEN
		iWeight = 1
	ELSE
		IF IsNull(iWeight) THEN iWeight = 1
	END IF

	select nvl(y_rate,0)			into :dRate
		from kfz34ot1
		where closing_date = :sRateDate and y_curr = :sCurr ;	
	if sqlca.sqlcode <> 0 then
		dRate = 0
	else
		if IsNull(dRate) then dRate = 0
	end if
	
	dRsAmtW    = Round((dRsAmtF * dRate) / iWeight,0)
	dRsItAmtW  = Round((dRsItAmtF * dRate) / iWeight,0)
		
	update kfm03ot1
		set rs_camt   = :dRsAmtW,
			 rs_itamt  = :dRsItAmtW
		where lo_cd = :sLoCd and rs_date = :sRsDate ;
	if sqlca.sqlcode <> 0 then
		Return -1
	end if
Loop
Close Cursor_Lst;

Return 1
end function

public function integer wf_create_acc (string sbasedate, string ssaupj, string sacc1, string sacc2, string sdcgbn);DataStore  Ids_RemainLst, Ids_DetailLst
Integer    iLoopCnt,k,iDetailCnt,iWeight,i,iCurRow
String     sSaupNo,sCurr,sDataGbn
Double     dRemainW,dRemainY,dYRate,dYAmt_Crt,dYRate_Crt,dAmt_Crt,dPRate_Crt,dIk_Crt,dSon_Crt,&
			  dYAmt_Bal,dAmt_Bal

Ids_RemainLst = Create DataStore
Ids_RemainLst.DataObject = 'dw_kgle296'
Ids_RemainLst.SetTransObject(Sqlca)
Ids_RemainLst.Reset()

Ids_DetailLst = Create DataStore
Ids_DetailLst.DataObject = 'dw_kgle295'
Ids_DetailLst.SetTransObject(Sqlca)
Ids_DetailLst.Reset()

if sDcGbn = '1' then											/*외화외상매출금*/
	sDataGbn = '2'
else																/*외화외상매입금*/	
	sDataGbn = '3'
end if

iLoopCnt = Ids_RemainLst.Retrieve(sSaupj,sBaseDate,sAcc1,sAcc2,sDcGbn)
if iLoopCnt <=0 then Return 0

FOR k = 1 TO iLoopCnt
	sSaupNo  = Ids_RemainLst.GetItemString(k,"saup_no")
	sCurr    = Ids_RemainLst.GetItemString(k,"curr")
	dRemainW = Ids_RemainLst.GetItemNumber(k,"wamt_jan")
	dRemainY = Ids_RemainLst.GetItemNumber(k,"famt_jan")
	
	iWeight  = Ids_RemainLst.GetItemNumber(k,"weight")
	dYRate   = Ids_RemainLst.GetItemNumber(k,"y_rate")
	
	if IsNull(dRemainW) then dRemainW = 0
	if IsNull(dRemainY) then dRemainY = 0
	
	if dRemainW = 0 or dRemainY = 0 then Continue
	
	iDetailCnt = Ids_DetailLst.Retrieve(sSaupj,sBaseDate,sAcc1,sAcc2,sSaupNo,sCurr,sDcgbn)
	FOR i = 1 TO iDetailCnt
		if dRemainY <=0 then Exit
		
		dYAmt_Bal = Ids_DetailLst.GetItemNumber(i,"y_amt")
		if IsNull(dYAmt_Bal) then dYAmt_Bal = 0
		
		dAmt_Bal = Ids_DetailLst.GetItemNumber(i,"amt")
		if IsNull(dAmt_Bal) then dAmt_Bal = 0
		
		if dRemainY > dYAmt_Bal then
			dYAmt_Crt = dYAmt_Bal
			dAmt_Crt  = dAmt_Bal 
			
			dRemainY = dRemainY - dYAmt_Bal
			dRemainW = dRemainW - dAmt_Bal
		elseif dRemainY <= dYAmt_Bal then
			dYAmt_Crt = dRemainY
			dAmt_Crt  = dRemainW
			
			dRemainY = 0
			dRemainW = 0
		end if
		
		if dYAmt_Crt = 0 or IsNull(dYAmt_Crt) then				/*발생환율*/
			dYRate_Crt = 0
		else
			dYRate_Crt =  Truncate((dAmt_Crt  /  dYAmt_Crt) *  iWeight ,3)
		end if
		
		if dYRate = 0 or IsNull(dYRate) then						/*평가환율*/
			dPRate_Crt = dYRate_Crt
		else
			dPRate_Crt = dYRate
		end if
		if sDataGbn = '2' then				/*외화외상매출금*/
			if ((dYAmt_Crt * dPRate_Crt) / iWeight ) -  dAmt_Crt > 0 then
				dIk_Crt = Truncate(Abs( ((dYAmt_Crt * dPRate_Crt) / iWeight ) -  dAmt_Crt),0)
				dSon_Crt = 0			
			else
				dSon_Crt = Truncate(Abs( ((dYAmt_Crt * dPRate_Crt) / iWeight ) -  dAmt_Crt),0)
				dIk_Crt =  0
			end if
		else
			if ((dYAmt_Crt * dPRate_Crt) / iWeight ) -  dAmt_Crt < 0 then
				dIk_Crt = Truncate(Abs( ((dYAmt_Crt * dPRate_Crt) / iWeight ) -  dAmt_Crt),0)
				dSon_Crt = 0			
			else
				dSon_Crt = Truncate(Abs( ((dYAmt_Crt * dPRate_Crt) / iWeight ) -  dAmt_Crt),0)
				dIk_Crt =  0
			end if
		end if
		if dIk_Crt = 0 and dSon_Crt = 0 then Continue
		
		iCurRow = dw_insert.InsertRow(0)
			
		dw_insert.SetItem(iCurRow,"closing_date", sBaseDate)
		dw_insert.SetItem(iCurRow,"owner_saupj",  sSaupj)
		
		dw_insert.SetItem(iCurRow,"acc1_cd",   sAcc1)
		dw_insert.SetItem(iCurRow,"acc2_cd",   sAcc2)
		
		dw_insert.SetItem(iCurRow,"saup_no",   sSaupNo)
		dw_insert.SetItem(iCurRow,"seq_no",    iCurRow)
		
		dw_insert.SetItem(iCurRow,"y_amt",     dYAmt_Crt)
		dw_insert.SetItem(iCurRow,"y_rate",    dYRate_Crt)
		dw_insert.SetItem(iCurRow,"amt",       dAmt_Crt)
		dw_insert.SetItem(iCurRow,"y_curr",    sCurr)
		dw_insert.SetItem(iCurRow,"p_rate",    dPRate_Crt)
		dw_insert.SetItem(iCurRow,"pamt_ik",   dIk_Crt)
		dw_insert.SetItem(iCurRow,"pamt_son",  dSon_Crt)
		dw_insert.SetItem(iCurRow,"datagu",    sDataGbn)
	NEXT	
NEXT

Destroy Ids_RemainLst
Destroy Ids_DetailLst

Return 1
end function

public function integer wf_insert_kfz34ot0 (string ssaupj, string sbasedate);DataStore  Ids_DataLst
String     sAryObject[] ={'dw_kgle272','dw_kgle273',     'dw_kgle274',    'dw_kgle275',    'dw_kgle276'}	
String     sMsg[]       ={'외화예금',  '외화외상매출금', '외화외상매입금','외화단기차입금','외화장기차입금'}
Integer    k,iRowCount,iCurRow,i
String     sAcc1[5],sAcc2[5],sChaDae

SELECT '' AS DP_ACC1,					'' AS DP_ACC2,
		 B.ACC1 AS MAICHUL_ACC1,		B.ACC2 AS MAICHUL_ACC2,
		 C.ACC1 AS MAIIP_ACC1,			C.ACC2 AS MAIIP_ACC2,
		 D.ACC1 AS SCH_ACC1,				D.ACC2 AS SCH_ACC2,
		 E.ACC1 AS LCH_ACC1,				E.ACC2 AS LCH_ACC2
	INTO :sAcc1[1],						:sAcc2[1],
		  :sAcc1[2],						:sAcc2[2],
		  :sAcc1[3],						:sAcc2[3],
		  :sAcc1[4],						:sAcc2[4],
		  :sAcc1[5],						:sAcc2[5]
	FROM(SELECT SUBSTR("DATANAME",1,5) AS ACC1,
					 SUBSTR("DATANAME",6,2) AS ACC2
				FROM "SYSCNFG"
				WHERE "SYSGU" = 'A' AND "SERIAL" = 18 AND "LINENO" = '2') B,
		  (SELECT SUBSTR("DATANAME",1,5) AS ACC1,
					 SUBSTR("DATANAME",6,2) AS ACC2
				FROM "SYSCNFG"
				WHERE "SYSGU" = 'A' AND "SERIAL" = 18 AND "LINENO" = '3') C,
		  (SELECT SUBSTR("DATANAME",1,5) AS ACC1,
					 SUBSTR("DATANAME",6,2) AS ACC2
				FROM "SYSCNFG"
				WHERE "SYSGU" = 'A' AND "SERIAL" = 18 AND "LINENO" = '4') D,
		  (SELECT SUBSTR("DATANAME",1,5) AS ACC1,
					 SUBSTR("DATANAME",6,2) AS ACC2
				FROM "SYSCNFG"
				WHERE "SYSGU" = 'A' AND "SERIAL" = 18 AND "LINENO" = '5') E;
				
SetPointer(HourGlass!)

dw_insert.Reset()
FOR k = 1 TO 5
	if k = 2 or k= 3 then								
		if k = 2 then 										/*외화외상매출금*/
			sChaDae = '1'
		else													/*외화외상매입금*/
			sChaDae = '2'
		end if
		iCurRow = Wf_Create_Acc(sBaseDate,sSaupj,sAcc1[k],sAcc2[k],sChaDae)
	else
		Ids_DataLst = Create DataStore

		Ids_DataLst.DataObject = sAryObject[k]
		Ids_DataLst.SetTransObject(Sqlca)
		Ids_DataLst.Reset()
		
		IF k = 1 THEN									/*외화 예금*/
			iRowCount = Ids_DataLst.Retrieve(sSaupj,sBaseDate)
		ELSE
			iRowCount = Ids_DataLst.Retrieve(sSaupj,sBaseDate,sAcc1[k],sAcc2[k])
		END IF
		
		IF iRowCount <=0 THEN Continue
	
		FOR i = 1 TO iRowCount
			sle_msg.text = sMsg[k]+' 총 '+String(iRowCount)+' 건 중 ' +String(i) + '건 처리 중...'
			
			iCurRow = dw_insert.InsertRow(0)
			
			dw_insert.SetItem(iCurRow,"closing_date", sBaseDate)
			dw_insert.SetItem(iCurRow,"owner_saupj",  sSaupj)
			IF k = 1 THEN
				dw_insert.SetItem(iCurRow,"acc1_cd",   Ids_DataLst.GetItemString(i,"acc1"))
				dw_insert.SetItem(iCurRow,"acc2_cd",   Ids_DataLst.GetItemString(i,"acc2"))
			ELSE
				dw_insert.SetItem(iCurRow,"acc1_cd",   sAcc1[k])
				dw_insert.SetItem(iCurRow,"acc2_cd",   sAcc2[k])
			END IF
			
			dw_insert.SetItem(iCurRow,"saup_no",      Ids_DataLst.GetItemString(i,"saupno"))
			dw_insert.SetItem(iCurRow,"seq_no",       iCurRow)
			
			dw_insert.SetItem(iCurRow,"y_amt",        Ids_DataLst.GetItemNumber(i,"famt_jan"))
			dw_insert.SetItem(iCurRow,"y_rate",       Ids_DataLst.GetItemNumber(i,"bal_rate"))
			dw_insert.SetItem(iCurRow,"amt",          Ids_DataLst.GetItemNumber(i,"wamt_jan"))
			dw_insert.SetItem(iCurRow,"y_curr",       Ids_DataLst.GetItemString(i,"curr"))
			dw_insert.SetItem(iCurRow,"p_rate",       Ids_DataLst.GetItemNumber(i,"curr_rate"))
			dw_insert.SetItem(iCurRow,"pamt_ik",      Ids_DataLst.GetItemNumber(i,"ik"))
			dw_insert.SetItem(iCurRow,"pamt_son",     Ids_DataLst.GetItemNumber(i,"son"))
			dw_insert.SetItem(iCurRow,"datagu",       String(k))
		NEXT
		Destroy Ids_DataLst
	end if	
NEXT

IF dw_insert.RowCount() <= 0 THEN Return -2

IF dw_insert.Update() = 1 THEN
	Commit;
	sle_msg.text = '자료 저장 완료...'
ELSE
	Return -1
END IF

Return 1
end function

on w_kgle29.create
int iCurrent
call super::create
this.dw_insert=create dw_insert
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_insert
this.Control[iCurrent+2]=this.rr_1
end on

on w_kgle29.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_insert)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.GetRow(),"saupj",   gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(),"basedate",F_Today())

dw_ip.Setcolumn("saupj")
dw_ip.SetFocus()

dw_insert.SetTransObject(Sqlca)


end event

type p_preview from w_standard_print`p_preview within w_kgle29
integer x = 4087
integer y = 0
integer taborder = 40
end type

type p_exit from w_standard_print`p_exit within w_kgle29
integer x = 4434
integer y = 0
integer taborder = 60
end type

type p_print from w_standard_print`p_print within w_kgle29
integer x = 4261
integer y = 0
integer taborder = 50
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgle29
integer x = 3913
integer y = 0
integer taborder = 20
end type

type st_window from w_standard_print`st_window within w_kgle29
integer x = 2331
integer width = 530
integer height = 80
end type

type sle_msg from w_standard_print`sle_msg within w_kgle29
integer width = 1934
integer height = 80
end type



type st_10 from w_standard_print`st_10 within w_kgle29
integer height = 80
end type



type dw_print from w_standard_print`dw_print within w_kgle29
string dataobject = "dw_kgle297_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgle29
integer x = 37
integer y = 12
integer width = 2455
integer height = 140
integer taborder = 10
string dataobject = "dw_kgle291"
end type

type dw_list from w_standard_print`dw_list within w_kgle29
integer x = 69
integer y = 176
integer width = 4512
integer height = 2100
integer taborder = 30
string dataobject = "dw_kgle297"
boolean border = false
end type

type dw_insert from datawindow within w_kgle29
boolean visible = false
integer x = 1138
integer y = 2656
integer width = 1202
integer height = 100
boolean bringtotop = true
boolean titlebar = true
string title = "외환평가손익 계산 명세서 저장"
string dataobject = "dw_kgle278"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kgle29
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 164
integer width = 4549
integer height = 2124
integer cornerheight = 40
integer cornerwidth = 55
end type

