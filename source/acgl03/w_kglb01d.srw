$PBExportHeader$w_kglb01d.srw
$PBExportComments$전표 등록 : 받을어음 수취
forward
global type w_kglb01d from window
end type
type cb_c from commandbutton within w_kglb01d
end type
type cb_x from commandbutton within w_kglb01d
end type
type p_exit from uo_picture within w_kglb01d
end type
type p_can from uo_picture within w_kglb01d
end type
type dw_bill_insert from datawindow within w_kglb01d
end type
type dw_ins from u_key_enter within w_kglb01d
end type
type cb_ins from commandbutton within w_kglb01d
end type
type dw_disp from u_key_enter within w_kglb01d
end type
type rr_1 from roundrectangle within w_kglb01d
end type
end forward

global type w_kglb01d from window
integer x = 416
integer y = 172
integer width = 3182
integer height = 1392
boolean titlebar = true
string title = "받을어음 수취"
windowtype windowtype = response!
long backcolor = 32106727
cb_c cb_c
cb_x cb_x
p_exit p_exit
p_can p_can
dw_bill_insert dw_bill_insert
dw_ins dw_ins
cb_ins cb_ins
dw_disp dw_disp
rr_1 rr_1
end type
global w_kglb01d w_kglb01d

type variables
Boolean  Ib_Changed
String      LsOwrSaupj,sStatus,LsSaupNo

end variables

forward prototypes
public function integer wf_insert_kfz12otd ()
public function integer wf_dup_chk (string sbillno, integer icurrow)
public function integer wf_requiredchk (integer icurrow)
end prototypes

public function integer wf_insert_kfz12otd ();Integer iFindRow,iCurRow
String  sFullJunNo

iCurRow = dw_ins.RowCount()

sFullJunNo = '00000'+String(Integer(lstr_jpra.saupjang),'00')+lstr_jpra.baldate+lstr_jpra.upmugu+&
					      String(lstr_jpra.bjunno,'0000')+String(lstr_jpra.sortno,'000')
					 
iFindRow = dw_bill_insert.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
												 					   lstr_jpra.bjunno, lstr_jpra.sortno)
IF iFindRow <=0 THEN
	iFindRow = dw_bill_insert.InsertRow(0)
	
	dw_bill_insert.SetItem(iFindRow,"saupj",			lstr_jpra.saupjang)
	dw_bill_insert.SetItem(iFindRow,"bal_date",		lstr_jpra.baldate)
	dw_bill_insert.SetItem(iFindRow,"upmu_gu",		lstr_jpra.upmugu)
	dw_bill_insert.SetItem(iFindRow,"bjun_no",		lstr_jpra.bjunno)
	dw_bill_insert.SetItem(iFindRow,"lin_no",			lstr_jpra.sortno)
	dw_bill_insert.SetItem(iFindRow,"full_junno",	sFullJunNo)
END IF

dw_bill_insert.SetItem(iFindRow,"mbal_date",		lstr_jpra.baldate)
dw_bill_insert.SetItem(iFindRow,"mupmu_gu",		lstr_jpra.upmugu)
dw_bill_insert.SetItem(iFindRow,"mjun_no",		lstr_jpra.bjunno)
dw_bill_insert.SetItem(iFindRow,"mlin_no",		lstr_jpra.sortno)
	
dw_bill_insert.SetItem(iFindRow,"bill_no",			dw_ins.GetItemString(iCurRow,"bill_no"))
dw_bill_insert.SetItem(iFindRow,"saup_no",			dw_ins.GetItemString(iCurRow,"saup_no"))
dw_bill_insert.SetItem(iFindRow,"bnk_cd",				dw_ins.GetItemString(iCurRow,"bnk_cd"))
dw_bill_insert.SetItem(iFindRow,"bbal_dat",			dw_ins.GetItemString(iCurRow,"bbal_dat"))
dw_bill_insert.SetItem(iFindRow,"bman_dat",			dw_ins.GetItemString(iCurRow,"bman_dat"))
dw_bill_insert.SetItem(iFindRow,"bill_amt",			dw_ins.GetItemNumber(iCurRow,"bill_amt"))
dw_bill_insert.SetItem(iFindRow,"bill_nm",			dw_ins.GetItemString(iCurRow,"bill_nm"))
dw_bill_insert.SetItem(iFindRow,"bill_ris",			dw_ins.GetItemString(iCurRow,"bill_ris"))
dw_bill_insert.SetItem(iFindRow,"bill_gu",			dw_ins.GetItemString(iCurRow,"bill_gu"))
dw_bill_insert.SetItem(iFindRow,"bill_jigu",			dw_ins.GetItemString(iCurRow,"bill_jigu"))
dw_bill_insert.SetItem(iFindRow,"chu_ymd",			dw_ins.GetItemString(iCurRow,"chu_ymd"))
dw_bill_insert.SetItem(iFindRow,"chu_bnk",			dw_ins.GetItemString(iCurRow,"chu_bnk"))
dw_bill_insert.SetItem(iFindRow,"status",				dw_ins.GetItemString(iCurRow,"status"))
dw_bill_insert.SetItem(iFindRow,"bill_ntinc",		dw_ins.GetItemString(iCurRow,"bill_ntinc"))
dw_bill_insert.SetItem(iFindRow,"budo_amt",			dw_ins.GetItemNumber(iCurRow,"budo_amt"))
dw_bill_insert.SetItem(iFindRow,"bill_change_date",dw_ins.GetItemString(iCurRow,"bill_change_date"))
dw_bill_insert.SetItem(iFindRow,"temp_bill_yn",		dw_ins.GetItemString(iCurRow,"temp_bill_yn"))
dw_bill_insert.SetItem(iFindRow,"limit_aplgbn",		dw_ins.GetItemString(iCurRow,"limit_aplgbn"))

dw_bill_insert.SetItem(iFindRow,"remark1",			lstr_jpra.desc)

dw_bill_insert.SetItem(iFindRow,"owner_saupj",		dw_ins.GetItemString(iCurRow,"owner_saupj"))

Return 1
end function

public function integer wf_dup_chk (string sbillno, integer icurrow);String  sNull
Integer iReturnRow,iDbCount

SetNull(snull)

iReturnRow = dw_ins.find("bill_no ='" + sBillNo + "'", 1, dw_ins.RowCount())	/*중복 체크*/

IF (iCurRow <> iReturnRow) and (iReturnRow <> 0) THEN
	f_MessageChk(10,'[어음번호]')
	dw_ins.SetItem(iCurRow,"bill_no",snull)
	RETURN  -1
END IF

/*받을어음 마스타*/
SELECT COUNT("KFM02OT0"."BILL_NO")	INTO :iDbCount  
	FROM "KFM02OT0"  
	WHERE "KFM02OT0"."BILL_NO" = :sBillNo   ;
IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
	F_MessageChk(10,'[어음번호]')
	dw_ins.SetItem(iCurRow,"bill_no",snull)
	Return -1
END IF

/*전표의 받을어음(TEMP)*/
SELECT COUNT("KFZ12OTD"."BILL_NO")	INTO :iDbCount  
	FROM "KFZ12OTD"  
	WHERE "KFZ12OTD"."BILL_NO" = :sBillNo   ;
IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
	F_MessageChk(10,'[어음번호]')
	dw_ins.SetItem(iCurRow,"bill_no",snull)
	Return -1
END IF
	
Return 1
end function

public function integer wf_requiredchk (integer icurrow);String  sBillNo,sBalDate,sManDate,sBnkCd,sbillnm,sbillris,sbillgu,sbilljigu,sAutoNoGbn
Double  dAmount

dw_ins.AcceptText()
sBillNo  = dw_ins.GetItemString(iCurRow,"bill_no")
sBalDate = dw_ins.GetItemString(iCurRow,"bbal_dat") 
sManDate = dw_ins.GetItemString(iCurRow,"bman_dat")
sBnkCd   = dw_ins.GetItemString(iCurRow,"bnk_cd")
sbillnm   = dw_ins.GetItemString(iCurRow,"bill_nm")
sbillris   = dw_ins.GetItemString(iCurRow,"bill_ris")
sbillgu   = dw_ins.GetItemString(iCurRow,"bill_gu")
sbilljigu   = dw_ins.GetItemString(iCurRow,"bill_jigu")
dAmount  = dw_ins.GetItemNumber(iCurRow,"bill_amt") 

select substr(nvl(dataname,'N'),1,1)	into :sAutoNoGbn	from syscnfg where sysgu = 'A' and serial = '29' and lineno = '2';

if sbillgu = '4' and sAutoNoGbn = 'Y' then						/*전자어음*/
	if sBillNo = '' or IsNull(sBillNo) then
		Integer iMaxNo
		String  sMaxBillNo
		
		select max(k.billno)	into :sMaxBillNo
			from( select max(bill_no) as billno	from kfm02ot0 
						where bill_gu = '4' and saup_no = :lstr_jpra.saupno and 
								bbal_dat like substr(:sBalDate,1,6)||'%'
					union all
					select max(bill_no) as billno	from kfz12otd 
						where bill_gu = '4' and saup_no = :lstr_jpra.saupno and 
								bbal_dat like substr(:sBalDate,1,6)||'%'
				 ) k ;
		if sqlca.sqlcode = 0 then
			if IsNull(sMaxBillNo) then sMaxBillNo = '0'	
		else
			sMaxBillNo = '0'	
		end if
		iMaxNo = Integer(Right(sMaxBillNo,2)) + 1
		
		dw_ins.SetItem(1,"bill_no",lstr_jpra.saupno+Mid(sBalDate,3,4)+String(iMaxNo,'00'))
	end if
else		
	IF sBillNo = "" OR IsNull(sBillNo) THEN 
		F_MessageChk(1,'[어음번호]')
		dw_ins.SetColumn("bill_no")
		dw_ins.SetFocus()
		Return -1
	END IF
end if

IF sBalDate = "" OR IsNull(sBalDate) THEN 
	F_MessageChk(1,'[발행일자]')
	dw_ins.SetColumn("bbal_dat")
	dw_ins.SetFocus()
	Return -1
END IF
IF sManDate = "" OR IsNull(sManDate) THEN 
	F_MessageChk(1,'[만기일자]')
	dw_ins.SetColumn("bman_dat")
	dw_ins.SetFocus()
	Return -1
END IF
IF sBnkCd = "" OR IsNull(sBnkCd) THEN 
	F_MessageChk(1,'[지급은행]')
	dw_ins.SetColumn("bnk_cd")
	dw_ins.SetFocus()
	Return -1
END IF
IF sbillnm = "" OR IsNull(sbillnm) THEN 
	F_MessageChk(1,'[발행인]')
	dw_ins.SetColumn("bill_nm")
	dw_ins.SetFocus()
	Return -1
END IF

IF sbillgu = "" OR IsNull(sbillgu) THEN 
	F_MessageChk(1,'[어음종류]')
	dw_ins.SetColumn("bill_gu")
	dw_ins.SetFocus()
	Return -1
END IF
IF sbilljigu = "" OR IsNull(sbilljigu) THEN 
	F_MessageChk(1,'[어음구분]')
	dw_ins.SetColumn("bill_jigu")
	dw_ins.SetFocus()
	Return -1
END IF
IF dAmount = 0 OR IsNull(dAmount) THEN 
	F_MessageChk(1,'[어음금액]')
	dw_ins.SetColumn("bill_amt")
	dw_ins.SetFocus()
	Return -1
END IF

Return 1

end function

event open;String  sCvName
Long    iRowCount,iCurRow

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_disp.Reset()

dw_bill_insert.SetTransObject(SQLCA)

//IF lstr_account.remark4 = '' OR IsNull(lstr_account.remark4) THEN		/*어음의 소속 사업장*/
	LsOwrSaupj = lstr_jpra.saupjang
//ELSE
//	LsOwrSaupj = lstr_account.remark4
//END IF

IF lstr_jpra.saupno = '' or IsNull(lstr_jpra.saupno) THEN
	LsSaupNo = '%'
ELSE
	LsSaupNo = Left(lstr_jpra.saupno,6)
END IF

iRowCount = dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)
IF iRowCount <=0 THEN
	dw_disp.InsertRow(0)

   dw_disp.SetItem(dw_disp.GetRow(),"saupj",    lstr_jpra.saupjang)
   dw_disp.SetItem(dw_disp.GetRow(),"bal_date", lstr_jpra.baldate)
   dw_disp.SetItem(dw_disp.GetRow(),"upmu_gu",  lstr_jpra.upmugu)
   dw_disp.SetItem(dw_disp.GetRow(),"bjun_no",  lstr_jpra.bjunno)
   dw_disp.SetItem(dw_disp.GetRow(),"lin_no",   lstr_jpra.sortno)
	
	dw_disp.SetItem(dw_disp.GetRow(),"saup_no",  LsSaupNo)
	dw_disp.SetItem(dw_disp.GetRow(),"kfz04om0_v1_person_nm",  F_Get_PersonLst('1',LsSaupNo,'1'))
	ib_changed = False	
ELSE
	dw_disp.Modify("status.protect = 1")
	
	ib_changed = True
END IF
dw_disp.SetItem(1,"amount",   lstr_jpra.money) 

IF dw_disp.GetItemString(1,"status") = '1' THEN 				/*수취*/
	dw_ins.DataObject = 'dw_kglb01d_2'
	dw_ins.SetTransObject(Sqlca)
	dw_ins.Reset()
	dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																	lstr_jpra.bjunno,lstr_jpra.sortno)	
	IF dw_ins.RowCount() <=0 THEN
		cb_ins.TriggerEvent(Clicked!)
		dw_ins.SetColumn("bill_no")	
	ELSE
		dw_ins.SetColumn("bbal_dat")	
	END IF	
	sStatus = '1'
	dw_ins.SetItem(dw_ins.GetRow(),"bbal_dat",     lstr_jpra.baldate)
ELSE
	dw_ins.DataObject = 'dw_kglb01d_3'
	dw_ins.SetTransObject(Sqlca)
	dw_ins.Reset()
	dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
						 lstr_jpra.bjunno,lstr_jpra.sortno, LsSaupNo,'6',LsOwrSaupj)	
	dw_ins.SetColumn("status")	
	sStatus = '8'
END IF

dw_ins.SetItem(dw_ins.GetRow(),"saup_no",      Left(lstr_jpra.saupno,6))
dw_ins.SetFocus()
end event

on w_kglb01d.create
this.cb_c=create cb_c
this.cb_x=create cb_x
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_bill_insert=create dw_bill_insert
this.dw_ins=create dw_ins
this.cb_ins=create cb_ins
this.dw_disp=create dw_disp
this.rr_1=create rr_1
this.Control[]={this.cb_c,&
this.cb_x,&
this.p_exit,&
this.p_can,&
this.dw_bill_insert,&
this.dw_ins,&
this.cb_ins,&
this.dw_disp,&
this.rr_1}
end on

on w_kglb01d.destroy
destroy(this.cb_c)
destroy(this.cb_x)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_bill_insert)
destroy(this.dw_ins)
destroy(this.cb_ins)
destroy(this.dw_disp)
destroy(this.rr_1)
end on

type cb_c from commandbutton within w_kglb01d
integer x = 3374
integer y = 1064
integer width = 279
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;p_can.TriggerEvent(Clicked!)
end event

type cb_x from commandbutton within w_kglb01d
integer x = 3374
integer y = 1156
integer width = 279
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "닫기(&X)"
end type

event clicked;p_exit.TriggerEvent(Clicked!)
end event

type p_exit from uo_picture within w_kglb01d
integer x = 2967
integer y = 32
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;Int    iDbCount,k
Double dAmount
String sRtnValue

IF ib_changed = True THEN
	dw_disp.AcceptText()
	IF dw_disp.GetItemString(1,"status") = '1' THEN				/*수취*/
		IF Wf_RequiredChk(dw_ins.GetRow()) = -1 THEN Return
	
		dAmount = dw_ins.GetItemNumber(dw_ins.GetRow(),"bill_amt")
		IF IsNull(dAmount) THEN dAmount = 0
		
		IF dAmount <> lstr_jpra.money THEN
			F_MessageChk(37,'')
			Return	
		END IF
		
		dw_ins.SetItem(dw_ins.GetRow(),"saup_no",      Left(lstr_jpra.saupno,6))	
		
		IF F_DbConFirm('저장') = 2  then return
						
		IF dw_ins.Update() <> 1 THEN
			Rollback;
			F_messageChk(13,'')
			Return
		END IF
		
		lstr_jpra.kwan    = dw_ins.GetItemString(1,"bill_no")	
		lstr_jpra.k_eymd  = dw_ins.GetItemString(1,"bman_dat")
	ELSE
		IF dw_ins.GetItemNumber(1,"yescnt") > 1 THEN
			F_MessageChk(16,'[인수건수가 1이상]')
			Return
		ELSEIF dw_ins.GetItemNumber(1,"yescnt") <= 0 THEN
			F_MessageChk(11,'')
			Return
		END IF
	
		dAmount = dw_ins.GetItemNumber(dw_ins.GetRow(),"sum_gyelamt")
		IF IsNull(dAmount) THEN dAmount = 0
		
		IF dAmount <> lstr_jpra.money THEN
			F_MessageChk(37,'[전표금액/인수어음계]')
			Return	
		END IF
	
		dw_ins.SetFilter("status = '8' ")
		dw_ins.Filter()
		
		IF F_DbConFirm('저장') = 2  then return
		
		Wf_Insert_Kfz12otd()
		
		IF dw_bill_insert.Update() <> 1 THEN
			Rollback;
			F_messageChk(13,'')
			Return
		END IF
		lstr_jpra.kwan    = dw_ins.GetItemString(1,"bill_no")	
		lstr_jpra.k_eymd  = dw_ins.GetItemString(1,"bman_dat")
	END IF
		
	sRtnValue = '1'
ELSE
	SELECT Count("KFZ12OTD"."BILL_NO")	   INTO :iDbCount  				/*기존자료 유무*/
	   FROM "KFZ12OTD"  
   	WHERE ( "KFZ12OTD"."SAUPJ" = :lstr_jpra.saupjang ) AND  
      	   ( "KFZ12OTD"."BAL_DATE" = :lstr_jpra.baldate ) AND  
         	( "KFZ12OTD"."UPMU_GU" = :lstr_jpra.upmugu ) AND  
	         ( "KFZ12OTD"."BJUN_NO" = :lstr_jpra.bjunno ) AND  
   	      ( "KFZ12OTD"."LIN_NO" = :lstr_jpra.sortno )   ;
	IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
		sRtnValue = '1'	
		dw_ins.Update()
	ELSE
		sRtnValue = '0'
	END IF
END IF

CloseWithReturn(parent,sRtnValue)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_kglb01d
integer x = 2793
integer y = 32
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;ib_changed = False
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type dw_bill_insert from datawindow within w_kglb01d
boolean visible = false
integer x = 315
integer y = 1308
integer width = 1120
integer height = 96
boolean titlebar = true
string title = "어음 인수내역 저장"
string dataobject = "dw_kglb01d1_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_ins from u_key_enter within w_kglb01d
integer x = 46
integer y = 232
integer width = 3072
integer height = 972
integer taborder = 10
string dataobject = "dw_kglb01d_2"
boolean vscrollbar = true
boolean border = false
end type

event itemerror;
Return 1
end event

event itemchanged;String  sBillNo,sBalDate,sManDate,sBillGbn,sBillJiGbn,sNull
Integer iCurRow,iReturnRow,lnull
Double  dAmount

SetNull(snull)
SetNull(lnull)

iCurRow = this.GetRow()
IF this.GetColumnName() ="bill_no" THEN
	sBillNo = this.GetText()
	IF sBillNo = "" OR IsNull(sBillNo) THEN REturn
	
	IF Wf_Dup_chk(sBillNo,iCurRow) = -1 THEN Return 1
END IF

//어음발행일자//
IF this.GetColumnName() ="bbal_dat" THEN
	sBalDate = Trim(this.GetText())
	IF sBalDate ="" OR isNull(sBalDate) THEN REturn
	
	IF F_DateChk(sBalDate) = -1 THEN 
		F_MessageChk(21,'[발행일자]')
		this.SetItem(iCurRow,"bbal_dat",snull)
		Return 1
	END IF
END IF

//어음만기일자//
IF this.GetColumnName() ="bman_dat" THEN
	sManDate = Trim(this.GetText())
	IF sManDate = "" OR IsNull(sManDate) THEN REturn
	
	IF F_DateChk(sManDate) = -1 THEN 
		F_MessageChk(21,'[만기일자]')
		this.SetItem(iCurRow,"bman_dat",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bill_nm" THEN
	if data = '' or isnull(data) then 
		F_MessageChk(1,'[발행인]')
		this.SetItem(iCurRow,"bill_nm",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bill_ris" THEN
	if data = '' or isnull(data) then 
		F_MessageChk(1,'[대표자]')
		this.SetItem(iCurRow,"bill_ris",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bill_gu" THEN
	sBillGbn = this.GetText()
	IF sBillGbn = "" OR IsNull(sBillGbn) THEN Return
	
	IF IsNull(F_Get_Refferance('BJ',sBillGbn)) THEN
		F_MessageChk(20,'[어음종류]')
		this.SetItem(iCurRow,"bill_gu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bill_jigu" THEN
	sBillJiGbn = this.GetText()
	IF sBillJiGbn = "" OR IsNull(sBillJiGbn) THEN Return
	
	IF IsNull(F_Get_Refferance('BG',sBillJiGbn)) THEN
		F_MessageChk(20,'[어음구분]')
		this.SetItem(iCurRow,"bill_jigu",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bill_amt" THEN
	dAmount = Double(this.GetText())
	IF IsNull(dAmount) THEN dAmount = 0
	
	IF dAmount = 0 THEN 
		F_MessageChk(1,'[어음금액]')
		this.SetItem(iCurRow,"bill_amt",lnull)
		Return 1
	END IF
END IF

ib_changed =True
end event

event retrieverow;dw_disp.AcceptText()
IF sStatus = '1' THEN
	IF row > 0 THEN
		this.SetItem(row,'sflag','M')
	END IF
END IF
end event

event editchanged;ib_changed = True
end event

event getfocus;this.AcceptText()
end event

event itemfocuschanged;
IF this.GetColumnName() = "bnk_cd" OR this.GetColumnName() = "bill_nm" or this.GetColumnName() = "bill_ris" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

type cb_ins from commandbutton within w_kglb01d
boolean visible = false
integer x = 1783
integer y = 1332
integer width = 361
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

event clicked;Integer  iCurRow,iFunctionValue
String   sFullJunNo

IF dw_ins.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_ins.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_ins.InsertRow(0)

	dw_ins.SetItem(iCurRow,"saupj",     lstr_jpra.saupjang)
	dw_ins.SetItem(iCurRow,"bal_date",  lstr_jpra.baldate)
	dw_ins.SetItem(iCurRow,"upmu_gu",   lstr_jpra.upmugu)
	dw_ins.SetItem(iCurRow,"bjun_no",   lstr_jpra.bjunno)
	dw_ins.SetItem(iCurRow,"lin_no",    lstr_jpra.sortno)		

	sFullJunNo = '00000'+String(Integer(lstr_jpra.saupjang),'00')+lstr_jpra.baldate+lstr_jpra.upmugu+&
					 			String(lstr_jpra.bjunno,'0000')+String(lstr_jpra.sortno,'000')
					 
	dw_ins.SetItem(iCurRow,"saup_no",       LsSaupNo)
	dw_ins.SetItem(iCurRow,"owner_saupj",   LsOwrSaupj)
	dw_ins.SetItem(iCurRow,"full_junno",    sFullJunNo)
	dw_ins.SetItem(iCurRow,"remark1",    	 lstr_jpra.desc)
	
	dw_ins.SetItem(iCurRow,"bill_nm",    	 f_get_personlst('1',LsSaupNo,'%'))
	IF iCurRow = 1 THEN
		dw_ins.SetItem(iCurRow,"bill_amt",    lstr_jpra.money)		
	END IF
	
	dw_ins.SetItem(iCurRow,"sflag",     'I')
	
	dw_ins.ScrollToRow(iCurRow)
		
	dw_ins.SetColumn("bill_no")
	dw_ins.SetFocus()
	
	ib_changed = True
END IF

end event

type dw_disp from u_key_enter within w_kglb01d
event ue_key pbm_dwnkey
integer x = 27
integer y = 16
integer width = 2752
integer height = 208
integer taborder = 0
string dataobject = "dw_kglb01d_1"
boolean border = false
end type

event itemerror;Return 1
end event

event itemchanged;

IF this.GetColumnName() = "status" THEN
	sStatus = this.GetText()
	
	IF sStatus = '1' THEN							/*수취*/
		dw_ins.DataObject = 'dw_kglb01d_2'
		dw_ins.SetTransObject(Sqlca)
		dw_ins.Reset()
		dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)	
		IF dw_ins.RowCount() <=0 THEN
			cb_ins.TriggerEvent(Clicked!)
		END IF
		dw_ins.SetColumn("bbal_dat")	
	ELSE
		dw_ins.DataObject = 'dw_kglb01d_3'
		dw_ins.SetTransObject(Sqlca)
		dw_ins.Reset()
		dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
							 lstr_jpra.bjunno,lstr_jpra.sortno, LsSaupNo,'6',LsOwrSaupj)	

		dw_ins.SetColumn("status")	
	END IF
	ib_changed = False
END IF
end event

type rr_1 from roundrectangle within w_kglb01d
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 224
integer width = 3095
integer height = 996
integer cornerheight = 40
integer cornerwidth = 55
end type

