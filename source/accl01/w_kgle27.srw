$PBExportHeader$w_kgle27.srw
$PBExportComments$외화평가익손 계산 명세서 조회 출력
forward
global type w_kgle27 from w_standard_print
end type
type dw_insert from datawindow within w_kgle27
end type
type p_save from p_retrieve within w_kgle27
end type
type rr_1 from roundrectangle within w_kgle27
end type
end forward

global type w_kgle27 from w_standard_print
integer x = 0
integer y = 0
integer width = 4640
string title = "외화평가손익 계산명세서 조회 출력"
dw_insert dw_insert
p_save p_save
rr_1 rr_1
end type
global w_kgle27 w_kgle27

forward prototypes
public function integer wf_insert_kfz34ot0 (string ssaupj, string sbasedate)
public function integer wf_calculation_chaipf (string sratedate)
public function integer wf_retrieve ()
end prototypes

public function integer wf_insert_kfz34ot0 (string ssaupj, string sbasedate);DataStore  Ids_DataLst
String     sAryObject[] ={'dw_kgle272','dw_kgle273','dw_kgle274','dw_kgle275','dw_kgle276'}	
String     sMsg[] = {'외화예금','외화외상매출금','외화외상매입금','외화단기차입금','외화장기차입금'}
Integer    k,iRowCount,iCurRow,i
String     sAcc1[5],sAcc2[5]

SELECT '' AS DP_ACC1,					'' AS DP_ACC2,
		 B.ACC1 AS MAICHUL_ACC1,		B.ACC2 AS MAICHUL_ACC2,
		 C.ACC1 AS MAIIP_ACC1,			B.ACC2 AS MAIIP_ACC2,
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
				
Ids_DataLst = Create DataStore

SetPointer(HourGlass!)

dw_insert.Reset()
FOR k = 1 TO 5
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
		w_mdi_frame.sle_msg.text = sMsg[k]+' 총 '+String(iRowCount)+' 건 중 ' +String(i) + '건 처리 중...'
		
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
NEXT

IF iCurRow <= 0 THEN Return -2

IF dw_insert.Update() = 1 THEN
	Commit;
	w_mdi_frame.sle_msg.text = '자료 저장 완료...'
	Destroy Ids_DataLst
ELSE
	Destroy Ids_DataLst
	Return -1
END IF

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

public function integer wf_retrieve ();String  sBaseDate,sSaupj,sGubun,sAcc1,sAcc2
Integer iCnt,iAcCnt,iRtnValue

w_mdi_frame.sle_msg.text =""

dw_ip.AcceptText()
sGubun    = dw_ip.GetItemString(1,"gubun")
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

IF sGubun = '1' THEN							/*외화예금*/
	IF dw_print.Retrieve(sSaupj, sBaseDate) <=0 THEN
		F_MessageChk(14,'')
		Return -1
	END IF
else
	Choose Case sGubun
		Case '2'									/*외화외상매출금*/
			SELECT SUBSTR("DATANAME",1,5) AS ACC1,
					 SUBSTR("DATANAME",6,2) AS ACC2
				INTO :sAcc1,   :sAcc2
				FROM "SYSCNFG"
				WHERE "SYSGU" = 'A' AND "SERIAL" = 18 AND "LINENO" = '2';
		Case '3'									/*외화외상매입금*/
			SELECT SUBSTR("DATANAME",1,5) AS ACC1,
					 SUBSTR("DATANAME",6,2) AS ACC2
				INTO :sAcc1,   :sAcc2
				FROM "SYSCNFG"
				WHERE "SYSGU" = 'A' AND "SERIAL" = 18 AND "LINENO" = '3';
		Case '4'									/*외화단기차입금*/
			SELECT SUBSTR("DATANAME",1,5) AS ACC1,
					 SUBSTR("DATANAME",6,2) AS ACC2
				INTO :sAcc1,   :sAcc2
				FROM "SYSCNFG"
				WHERE "SYSGU" = 'A' AND "SERIAL" = 18 AND "LINENO" = '4';
		Case '5'									/*외화장기차입금*/
			SELECT SUBSTR("DATANAME",1,5) AS ACC1,
					 SUBSTR("DATANAME",6,2) AS ACC2
				INTO :sAcc1,   :sAcc2
				FROM "SYSCNFG"
				WHERE "SYSGU" = 'A' AND "SERIAL" = 18 AND "LINENO" = '5';
	End Choose
	
	IF dw_print.Retrieve(sSaupj,sBaseDate, sAcc1, sAcc2) <=0 THEN
		F_MessageChk(14,'')
		Return -1
	END IF
     	  dw_print.sharedata(dw_list)

end if
//select count(*) into :iCnt from kfz34ot0 
//	where owner_saupj = :sSaupj and closing_date = :sBaseDate;
//if sqlca.sqlcode = 0 and (iCnt <> 0 and Not IsNull(iCnt)) then
//	select count(*) into :iAcCnt from kfz34ot0
//		where owner_saupj = :sSaupj and closing_date = :sBaseDate and
//				bal_date <> '' and bal_date is not null ;
//	if sqlca.sqlcode = 0 and (iAcCnt <> 0 and Not IsNull(iAcCnt)) then
//		MessageBox('확 인','이미 전표 발행 되었으므로 다시 생성할 수 없습니다...')
//		Return -1	
//	end if
//end if
//
//if sqlca.sqlcode = 0 and (iCnt <> 0 and Not IsNull(iCnt)) then
//	IF MessageBox('확 인',"자료를 삭제 후 다시 생성합니다. 계속하시겠습니까",Question!,YesNo!) = 2 THEN Return 1
//
//	delete from kfz34ot0 
//		where owner_saupj = :sSaupj and closing_date = :sBaseDate;
//	Commit;
//end if
//
///*kfz34ot0*/							 
//iRtnValue = Wf_Insert_Kfz34ot0(sSaupj,sBaseDate)
//IF iRtnValue = -1 THEN 
//	F_MessageChk(13,'[외환평가손익 계산 명세서]')
//	Rollback;
//	Return -1
//ELSEif iRtnValue = -2 THEN 
//	F_MessageChk(14,'')
//	Return -1	
//END IF
//
//iRtnValue = Wf_Calculation_ChaipF(sBaseDate)
//IF iRtnValue = -1 THEN 
//	F_MessageChk(13,'[외화차입금 환평가 갱신]')
//	Rollback;
//	Return -1
//ELSEif iRtnValue = -2 THEN 
//	F_MessageChk(14,'')
//	Return -1	
//ELSE
//	Commit;
//END IF

Return 1
end function

on w_kgle27.create
int iCurrent
call super::create
this.dw_insert=create dw_insert
this.p_save=create p_save
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_insert
this.Control[iCurrent+2]=this.p_save
this.Control[iCurrent+3]=this.rr_1
end on

on w_kgle27.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_insert)
destroy(this.p_save)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.GetRow(),"saupj",   gs_saupj)
dw_ip.SetItem(dw_ip.GetRow(),"basedate",F_Today())

dw_ip.Setcolumn("saupj")
dw_ip.SetFocus()


dw_list.DataObject = 'dw_kgle272q'
dw_print.DataObject = 'dw_kgle272' 
dw_list.SetTransObject(Sqlca)
dw_print.SetTransObject(Sqlca)
 dw_print.sharedata(dw_list)
	
dw_insert.SetTransObject(Sqlca)

end event

type p_xls from w_standard_print`p_xls within w_kgle27
end type

type p_sort from w_standard_print`p_sort within w_kgle27
end type

type p_preview from w_standard_print`p_preview within w_kgle27
integer x = 4069
integer y = 0
integer taborder = 50
boolean enabled = true
string picturename = "C:\erpman\image\미리보기_up.gif"
end type

event p_preview::clicked;String  sBaseDate,sSaupj

w_mdi_frame.sle_msg.text =""

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

IF dw_print.Retrieve(sSaupj, sBaseDate) <=0 THEN
	F_MessageChk(14,'')
	Return -1
END IF

p_print.Enabled   = True
p_print.PictureName = 'C:\erpman\image\인쇄_up.gif'

OpenWithParm(w_print_preview, dw_print)	
end event

type p_exit from w_standard_print`p_exit within w_kgle27
integer x = 4416
integer y = 0
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_kgle27
integer x = 4242
integer y = 0
integer taborder = 60
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgle27
integer x = 3721
integer y = 0
end type

event p_retrieve::clicked;call super::clicked;p_save.Enabled    = True
p_save.PictureName = 'C:\erpman\image\저장_up.gif'

end event

type st_window from w_standard_print`st_window within w_kgle27
integer x = 2331
integer width = 535
integer height = 80
end type

type sle_msg from w_standard_print`sle_msg within w_kgle27
integer width = 1934
integer height = 80
end type



type st_10 from w_standard_print`st_10 within w_kgle27
integer height = 80
end type



type dw_print from w_standard_print`dw_print within w_kgle27
integer x = 2738
integer y = 28
integer width = 521
integer height = 184
string dataobject = "dw_kgle273"
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within w_kgle27
integer x = 59
integer y = 0
integer width = 2638
integer height = 228
string dataobject = "dw_kgle271"
end type

event dw_ip::itemchanged;call super::itemchanged;
if dwo.name = 'gubun' then
	dw_list.SetRedraw(False)
	if data = '1' then				/*외화예금*/	
		dw_list.DataObject = 'dw_kgle272q'
	   dw_print.DataObject = 'dw_kgle272' 
   elseif data = '2' then				/*외화외상매출금*/
		dw_list.DataObject = 'dw_kgle273q'
	   dw_print.DataObject = 'dw_kgle273'
   elseif data = '3' then				/*외화외상매입금*/
		dw_list.DataObject = 'dw_kgle274q'
	   dw_print.DataObject = 'dw_kgle274'
   elseif data = '4' then				/*외화단기차입금*/
		dw_list.DataObject = 'dw_kgle275q'
	   dw_print.DataObject = 'dw_kgle275' 
   elseif data = '5' then				/*외화장기차입금*/
		dw_list.DataObject = 'dw_kgle276q'
	   dw_print.DataObject = 'dw_kgle276'
   end if
	dw_list.SetTransObject(Sqlca)
	dw_print.SetTransObject(Sqlca)
	dw_list.SetRedraw(True)
	dw_list.Reset()
end if
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

type dw_list from w_standard_print`dw_list within w_kgle27
integer x = 78
integer y = 240
integer width = 4475
integer height = 2024
string dataobject = "dw_kgle272q"
boolean hscrollbar = false
boolean border = false
boolean hsplitscroll = false
end type

type dw_insert from datawindow within w_kgle27
boolean visible = false
integer x = 210
integer y = 2300
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

type p_save from p_retrieve within w_kgle27
integer x = 3895
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event ue_lbuttondown;PictureName = 'C:\erpman\image\저장_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\저장_up.gif'
end event

event clicked;String  sBaseDate,sSaupj
Integer iCnt,iAcCnt,iRtnValue

w_mdi_frame.sle_msg.text =""

dw_ip.AcceptText()

sSaupj    = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"saupj"))
sBaseDate = Trim(dw_ip.GetItemString(dw_ip.Getrow(),"basedate"))

If MessageBox('확 인','외화평가대상 자료로 저장하시겠습니까?',Question!,YesNo!,1) = 2 then Return

select count(*) into :iCnt from kfz34ot0 
	where owner_saupj = :sSaupj and closing_date = :sBaseDate;
if sqlca.sqlcode = 0 and (iCnt <> 0 and Not IsNull(iCnt)) then
	select count(*) into :iAcCnt from kfz34ot0
		where owner_saupj = :sSaupj and closing_date = :sBaseDate and
				bal_date <> '' and bal_date is not null ;
	if sqlca.sqlcode = 0 and (iAcCnt <> 0 and Not IsNull(iAcCnt)) then
		MessageBox('확 인','이미 전표 발행 되었으므로 다시 생성할 수 없습니다...')
		Return 	
	end if
end if

if sqlca.sqlcode = 0 and (iCnt <> 0 and Not IsNull(iCnt)) then
	IF MessageBox('확 인',"자료를 삭제 후 다시 생성합니다. 계속하시겠습니까",Question!,YesNo!) = 2 THEN Return 1

	delete from kfz34ot0 
		where owner_saupj = :sSaupj and closing_date = :sBaseDate;
	Commit;
end if

/*kfz34ot0*/							 
iRtnValue = Wf_Insert_Kfz34ot0(sSaupj,sBaseDate)
IF iRtnValue = -1 THEN 
	F_MessageChk(13,'[외환평가손익 계산 명세서]')
	Rollback;
	Return 
ELSEif iRtnValue = -2 THEN 
	F_MessageChk(14,'')
	Return	
END IF

iRtnValue = Wf_Calculation_ChaipF(sBaseDate)
IF iRtnValue = -1 THEN 
	F_MessageChk(13,'[외화차입금 환평가 갱신]')
	Rollback;
	Return
ELSEif iRtnValue = -2 THEN 
	F_MessageChk(14,'')
	Return	
ELSE
	Commit;
END IF

end event

type rr_1 from roundrectangle within w_kgle27
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 232
integer width = 4503
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

