$PBExportHeader$w_kglb01c.srw
$PBExportComments$전표 등록 : 지급어음 발행
forward
global type w_kglb01c from window
end type
type cb_x from commandbutton within w_kglb01c
end type
type cb_c from commandbutton within w_kglb01c
end type
type p_exit from uo_picture within w_kglb01c
end type
type p_can from uo_picture within w_kglb01c
end type
type cb_del from commandbutton within w_kglb01c
end type
type cb_ins from commandbutton within w_kglb01c
end type
type dw_ins from datawindow within w_kglb01c
end type
type dw_disp from u_key_enter within w_kglb01c
end type
type rr_1 from roundrectangle within w_kglb01c
end type
end forward

global type w_kglb01c from window
integer x = 997
integer y = 288
integer width = 1618
integer height = 1452
boolean titlebar = true
string title = "지급어음 발행"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_x cb_x
cb_c cb_c
p_exit p_exit
p_can p_can
cb_del cb_del
cb_ins cb_ins
dw_ins dw_ins
dw_disp dw_disp
rr_1 rr_1
end type
global w_kglb01c w_kglb01c

type variables
Boolean  Ib_Changed
String      LsOwrSaupj

end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
public function integer wf_dup_chk (string sbillno, integer icurrow)
end prototypes

public function integer wf_requiredchk (integer icurrow);String  sBillNo,sBalDate,sManDate,sBnkCd,sBillGbn,sAutoNoGbn,sOwner  
Double  dAmount

dw_ins.AcceptText()
sBillGbn = dw_ins.GetItemString(iCurRow,"bill_gbn")

sBillNo  = dw_ins.GetItemString(iCurRow,"bill_no")
sBalDate = dw_ins.GetItemString(iCurRow,"bbal_dat") 
sManDate = dw_ins.GetItemString(iCurRow,"bman_dat")
sBnkCd   = dw_ins.GetItemString(iCurRow,"bnk_cd")
dAmount  = dw_ins.GetItemNumber(iCurRow,"bill_amt") 

select substr(nvl(dataname,'N'),1,1)	into :sAutoNoGbn	from syscnfg where sysgu = 'A' and serial = '29' and lineno = '1';

if sBillGbn = '2' and sAutoNoGbn = 'Y' then						/*전자어음*/
	if sBillNo = '' or IsNull(sBillNo) then
		Integer iMaxNo
		String  sMaxBillNo
		
		select max(k.billno)	into :sMaxBillNo
			from( select max(bill_no) as billno	from kfm01ot0 
						where bill_gbn = '2' and saup_no = :lstr_jpra.saupno and 
								bbal_dat like substr(:sBalDate,1,6)||'%'
					union all
					select max(bill_no) as billno	from kfz12otc 
						where bill_gbn = '2' and saup_no = :lstr_jpra.saupno and 
								bbal_dat like substr(:sBalDate,1,6)||'%'
				 ) k ;
		if sqlca.sqlcode = 0 then
			if IsNull(sMaxBillNo) then sMaxBillNo = '0'	
		else
			sMaxBillNo = '0'	
		end if
		iMaxNo = Integer(Right(sMaxBillNo,2)) + 1
		
		dw_ins.SetItem(1,"bill_no",lstr_jpra.saupno+Mid(sBalDate,3,4)+String(iMaxNo,'00'))
		
		/*발행인*/
		SELECT substr("SYSCNFG"."DATANAME",1,20)  	INTO :sOwner  
			FROM "SYSCNFG"  
			WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
					( "SYSCNFG"."LINENO" = '80' )   ;
		dw_ins.SetItem(1,"bill_nm",sOwner)

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
IF dAmount = 0 OR IsNull(dAmount) THEN 
	F_MessageChk(1,'[어음금액]')
	dw_ins.SetColumn("bill_amt")
	dw_ins.SetFocus()
	Return -1
END IF

Return 1

end function

public function integer wf_dup_chk (string sbillno, integer icurrow);String  sNull,sUseTag,sBnkCd,sOwner,sBillGbn
Integer iReturnRow,iDbCount

dw_ins.AcceptText()
sBillGbn = dw_ins.GetItemString(iCurRow,"bill_gbn")

SetNull(snull)

iReturnRow = dw_ins.find("bill_no ='" + sBillNo + "'", 1, dw_ins.RowCount())	/*중복 체크*/

IF (iCurRow <> iReturnRow) and (iReturnRow <> 0) THEN
	f_MessageChk(10,'[어음번호]')
	dw_ins.SetItem(iCurRow,"bill_no",snull)
	dw_ins.SetItem(iCurRow,"bnk_cd",snull)
	dw_ins.SetItem(iCurRow,"kfz04om0_v2_person_nm",snull)
	RETURN  -1
END IF

if sBillGbn = '1' then
	/*수표.어음책*/
	SELECT "KFM06OT0"."USE_GU","KFM06OT0"."CHECK_BNK"  INTO :sUseTag, :sBnkCd
		FROM "KFM06OT0"  
		WHERE "KFM06OT0"."CHECK_NO" = :sBillNo   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[수표용지번호]')
		dw_ins.SetItem(iCurRow,"bill_no",snull)
		dw_ins.SetItem(iCurRow,"bnk_cd",snull)
		dw_ins.SetItem(iCurRow,"kfz04om0_v2_person_nm",snull)
		Return -1
	END IF

	/*상태 <> '미사용'*/
	IF sUseTag <> '0' THEN
		F_MessageChk(10,'[수표용지번호]')
		dw_ins.SetItem(iCurRow,"bill_no",snull)
		dw_ins.SetItem(iCurRow,"bnk_cd",snull)
		dw_ins.SetItem(iCurRow,"kfz04om0_v2_person_nm",snull)
		Return -1
	END IF
end if

/*지급어음 마스타*/
SELECT COUNT("KFM01OT0"."BILL_NO")	INTO :iDbCount  
	FROM "KFM01OT0"  
	WHERE "KFM01OT0"."BILL_NO" = :sBillNo   ;
IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
	F_MessageChk(10,'[어음번호]')
	dw_ins.SetItem(iCurRow,"bill_no",snull)
	dw_ins.SetItem(iCurRow,"bnk_cd",snull)
	dw_ins.SetItem(iCurRow,"kfz04om0_v2_person_nm",snull)
	Return -1
END IF

/*전표의 지급어음(TEMP)*/
SELECT COUNT("KFZ12OTC"."BILL_NO")	INTO :iDbCount  
	FROM "KFZ12OTC"  
	WHERE "KFZ12OTC"."BILL_NO" = :sBillNo   ;
IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
	F_MessageChk(10,'[어음번호]')
	dw_ins.SetItem(iCurRow,"bill_no",snull)
	dw_ins.SetItem(iCurRow,"bnk_cd",snull)
	dw_ins.SetItem(iCurRow,"kfz04om0_v2_person_nm",snull)
	Return -1
END IF

dw_ins.SetItem(iCurRow,"bnk_cd",sBnkCd)
dw_ins.SetItem(iCurRow,"kfz04om0_v2_person_nm",F_Get_Personlst('2',sBnkCd,'1'))

/*발행인*/
SELECT substr("SYSCNFG"."DATANAME",1,20)  	INTO :sOwner  
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '80' )   ;
dw_ins.SetItem(iCurRow,"bill_nm",sOwner)

dw_ins.SetItem(iCurRow,"bbal_dat",lstr_jpra.baldate)

Return 1
end function

event open;String  sCvName
Long    iRowCount,iCurRow

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_disp.Reset()
dw_ins.SetTransObject(SQLCA)
dw_ins.Reset()

//IF lstr_account.remark4 = '' OR IsNull(lstr_account.remark4) THEN		/*어음의 소속 사업장*/
	LsOwrSaupj = lstr_jpra.saupjang
//ELSE
//	LsOwrSaupj = lstr_account.remark4
//END IF

iRowCount = dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)
IF iRowCount <=0 THEN
	dw_disp.InsertRow(0)

   dw_disp.SetItem(dw_disp.GetRow(),"saupj",    lstr_jpra.saupjang)
   dw_disp.SetItem(dw_disp.GetRow(),"bal_date", lstr_jpra.baldate)
   dw_disp.SetItem(dw_disp.GetRow(),"upmu_gu",  lstr_jpra.upmugu)
   dw_disp.SetItem(dw_disp.GetRow(),"bjun_no",  lstr_jpra.bjunno)
   dw_disp.SetItem(dw_disp.GetRow(),"lin_no",   lstr_jpra.sortno)
	
	dw_disp.SetItem(dw_disp.GetRow(),"saup_no",  Left(lstr_jpra.saupno,6))
	dw_disp.SetItem(dw_disp.GetRow(),"kfz04om0_v1_person_nm",  F_Get_PersonLst('1',Left(lstr_jpra.saupno,6),'1'))
	
	dw_ins.SetColumn("bill_no")
	
	ib_changed = False
	
	dw_disp.SetItem(dw_disp.GetRow(),"amount",   lstr_jpra.money) 
	
	cb_ins.TriggerEvent(Clicked!)
ELSE
	dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)

	dw_disp.SetItem(dw_disp.GetRow(),"saup_no",  Left(lstr_jpra.saupno,6))
	dw_disp.SetItem(dw_disp.GetRow(),"kfz04om0_v1_person_nm",  F_Get_PersonLst('1',Left(lstr_jpra.saupno,6),'1'))

	ib_changed = True
	
	dw_ins.SetColumn("bbal_dat")
	
	dw_disp.SetItem(dw_disp.GetRow(),"amount",   lstr_jpra.money) 
	dw_ins.SetItem(dw_ins.GetRow(),"saup_no",    Left(lstr_jpra.saupno,6))
	dw_ins.SetFocus()
END IF



end event

on w_kglb01c.create
this.cb_x=create cb_x
this.cb_c=create cb_c
this.p_exit=create p_exit
this.p_can=create p_can
this.cb_del=create cb_del
this.cb_ins=create cb_ins
this.dw_ins=create dw_ins
this.dw_disp=create dw_disp
this.rr_1=create rr_1
this.Control[]={this.cb_x,&
this.cb_c,&
this.p_exit,&
this.p_can,&
this.cb_del,&
this.cb_ins,&
this.dw_ins,&
this.dw_disp,&
this.rr_1}
end on

on w_kglb01c.destroy
destroy(this.cb_x)
destroy(this.cb_c)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.cb_del)
destroy(this.cb_ins)
destroy(this.dw_ins)
destroy(this.dw_disp)
destroy(this.rr_1)
end on

type cb_x from commandbutton within w_kglb01c
integer x = 1993
integer y = 580
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

type cb_c from commandbutton within w_kglb01c
integer x = 1993
integer y = 488
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

type p_exit from uo_picture within w_kglb01c
integer x = 1385
integer y = 16
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;Int    iDbCount,k
Double dSumAmount
String sRtnValue

IF ib_changed = True THEN
	IF Wf_RequiredChk(dw_ins.GetRow()) = -1 THEN Return
	
	dSumAmount = dw_ins.GetItemNumber(dw_ins.GetRow(),"sum_billamt")
	IF IsNull(dSumAmount) THEN dSumAmount = 0
	
	IF dSumAmount <> lstr_jpra.money THEN
		F_MessageChk(37,'')
		dw_ins.SetColumn("bill_amt")
		dw_ins.SetFocus()
		Return	
	END IF
	
	FOR k = 1 TO dw_ins.RowCount()
		dw_ins.SetItem(k,"saup_no",   Left(lstr_jpra.saupno,6))	
	NEXT
	
	IF F_DbConFirm('저장') = 2  then return
					
	IF dw_ins.Update() <> 1 THEN
		Rollback;
		F_messageChk(13,'')
		Return
	END IF
	
	lstr_jpra.kwan    = dw_ins.GetItemString(1,"bill_no")	
	lstr_jpra.k_eymd  = dw_ins.GetItemString(1,"bman_dat")
	lstr_jpra.itm_gu  = dw_ins.GetItemString(1,"kfz04om0_v2_person_nm")
	
	sRtnValue = '1'
ELSE
	SELECT Count("KFZ12OTC"."BILL_NO")	   INTO :iDbCount  				/*기존자료 유무*/
	   FROM "KFZ12OTC"  
   	WHERE ( "KFZ12OTC"."SAUPJ" = :lstr_jpra.saupjang ) AND  
      	   ( "KFZ12OTC"."BAL_DATE" = :lstr_jpra.baldate ) AND  
         	( "KFZ12OTC"."UPMU_GU" = :lstr_jpra.upmugu ) AND  
	         ( "KFZ12OTC"."BJUN_NO" = :lstr_jpra.bjunno ) AND  
   	      ( "KFZ12OTC"."LIN_NO" = :lstr_jpra.sortno )   ;
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

type p_can from uo_picture within w_kglb01c
integer x = 1211
integer y = 16
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;
dw_ins.Reset()

dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)	

dw_ins.SetFocus()

ib_changed = False


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type cb_del from commandbutton within w_kglb01c
integer x = 567
integer y = 1720
integer width = 297
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&D)"
end type

event clicked;//String snull
//
//SetNull(snull)
//
//IF dw_ins.RowCount() <=0 THEN RETURN
//
//IF F_DbConFirm('삭제') = 2  then return
//
//dw_ins.SetRedraw(False)
//dw_ins.DeleteRow(0)
//
//IF dw_ins.Update() <> 1 THEN
//	rollback;
//	f_messagechk(12,'')
//	Return
//END IF
//dw_ins.SetRedraw(True)
//
//ib_changed = True
//
end event

type cb_ins from commandbutton within w_kglb01c
integer x = 256
integer y = 1720
integer width = 297
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

	sFullJunNo = '00000'+String(Integer(lstr_jpra.saupjang),'00')+lstr_jpra.baldate+lstr_jpra.upmugu+&
					 			String(lstr_jpra.bjunno,'0000')+String(lstr_jpra.sortno,'000')

	dw_ins.SetItem(iCurRow,"saupj",     lstr_jpra.saupjang)
	dw_ins.SetItem(iCurRow,"bal_date",  lstr_jpra.baldate)
	dw_ins.SetItem(iCurRow,"upmu_gu",   lstr_jpra.upmugu)
	dw_ins.SetItem(iCurRow,"bjun_no",   lstr_jpra.bjunno)
	dw_ins.SetItem(iCurRow,"lin_no",    lstr_jpra.sortno)		

	dw_ins.SetItem(iCurRow,"saup_no",   Left(lstr_jpra.saupno,6))
	
	IF iCurRow = 1 THEN
		dw_ins.SetItem(iCurRow,"bill_amt",    lstr_jpra.money)		
	END IF
	
	dw_ins.SetItem(iCurRow,"sflag",         'I')
	dw_ins.SetItem(iCurRow,"owner_saupj",   LsOwrSaupj)
	dw_ins.SetItem(iCurRow,"full_junno",    sFullJunNo)
	dw_ins.SetItem(iCurRow,"remark1",       lstr_jpra.desc)
	
	dw_ins.ScrollToRow(iCurRow)
		
	dw_ins.SetColumn("bill_no")
	dw_ins.SetFocus()
END IF

end event

type dw_ins from datawindow within w_kglb01c
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 233
integer y = 380
integer width = 1111
integer height = 832
integer taborder = 10
string dataobject = "dw_kglb01c_2"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;
Return 1
end event

event itemchanged;String  sBillNo,sBalDate,sManDate,sBnkCd,sBnkName,sNull
Integer iCurRow,lnull
Double  dAmount

SetNull(snull)
SetNull(lnull)

iCurRow = this.GetRow()
IF dw_ins.GetColumnName() ="bill_no" THEN
	sBillNo = this.GetText()
	IF sBillNo = "" OR IsNull(sBillNo) THEN REturn
	
	IF Wf_Dup_Chk(sBillNo,iCurRow) = -1 THEN Return 1

END IF

//어음발행일자//
IF dw_ins.GetColumnName() ="bbal_dat" THEN
	sBalDate = Trim(this.GetText())
	IF sBalDate ="" OR isNull(sBalDate) THEN REturn
	
	IF F_DateChk(sBalDate) = -1 THEN 
		F_MessageChk(21,'[발행일자]')
		this.SetItem(iCurRow,"bbal_dat",snull)
		Return 1
	END IF
END IF

//어음만기일자//
IF dw_ins.GetColumnName() ="bman_dat" THEN
	sManDate = Trim(this.GetText())
	IF sManDate = "" OR IsNull(sManDate) THEN REturn
	
	IF F_DateChk(sManDate) = -1 THEN 
		F_MessageChk(21,'[만기일자]')
		this.SetItem(iCurRow,"bman_dat",snull)
		Return 1
	END IF
END IF

IF dw_ins.GetColumnName() ="bnk_cd" THEN
	sBnkCd = this.GetText()
	IF sBnkCd = "" OR IsNull(sBnkCd) THEN 
		this.SetItem(iCurRow,"kfz04om0_v2_person_nm",snull)
		REturn
	END IF
	
	SELECT "KFZ04OM0_V2"."PERSON_NM"  	INTO :sbnkName
    	FROM "KFZ04OM0_V2"  
   	WHERE ( "KFZ04OM0_V2"."PERSON_CD" = :sBnkCd );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[지급은행]')
		this.SetItem(iCurRow,"bnk_cd",snull)
		this.SetItem(iCurRow,"kfz04om0_v2_person_nm",snull)
		Return 1
	END IF
	this.SetItem(iCurRow,"kfz04om0_v2_person_nm",sbnkName)
END IF

IF dw_ins.GetColumnName() ="bill_amt" THEN
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

event rbuttondown;String sBillGbn

this.AcceptText()
IF this.GetColumnName() ="bill_no" THEN
	SetNull(gs_code)
	SetNull(gs_codename)

	gs_code = this.GetItemString(this.GetRow(),"bill_no")
	sBillGbn = this.GetItemString(this.GetRow(),"bill_gbn")
	
	if sBillGbn = '1' then
		OpenWithParm(W_KFM06OT0_POPUP,'2')
		
		IF gs_code = "" OR IsNull(gs_code) THEN REturn
		
		this.SetItem(this.GetRow(),"bill_no",gs_code)
		this.TriggerEvent(ItemChanged!)
	end if
END IF

IF this.GetColumnName() ="bnk_cd" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"bnk_cd"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	OpenWithParm(W_KFZ04OM0_POPUP,'2')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"bnk_cd",lstr_custom.code)
	this.TriggerEvent(ItemChanged!)
END IF


end event

event getfocus;this.AcceptText()
end event

event editchanged;ib_changed =True
end event

event retrieverow;
IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF

end event

event itemfocuschanged;
IF this.GetColumnName() = "bill_nm" THEN
	F_toggle_kor(Handle(this))
ELSE
	F_toggle_eng(Handle(this))	
END IF
end event

type dw_disp from u_key_enter within w_kglb01c
event ue_key pbm_dwnkey
integer x = 23
integer width = 1193
integer height = 332
integer taborder = 0
string dataobject = "dw_kglb01c_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type rr_1 from roundrectangle within w_kglb01c
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 340
integer width = 1518
integer height = 956
integer cornerheight = 40
integer cornerwidth = 55
end type

