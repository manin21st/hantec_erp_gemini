$PBExportHeader$w_kglb01d1.srw
$PBExportComments$전표 등록 : 받을어음 결제
forward
global type w_kglb01d1 from window
end type
type cb_x from commandbutton within w_kglb01d1
end type
type cb_c from commandbutton within w_kglb01d1
end type
type p_exit from uo_picture within w_kglb01d1
end type
type p_can from uo_picture within w_kglb01d1
end type
type dw_ins from u_d_popup_sort within w_kglb01d1
end type
type dw_bill_insert from datawindow within w_kglb01d1
end type
type dw_find from u_key_enter within w_kglb01d1
end type
type dw_disp from datawindow within w_kglb01d1
end type
type rr_1 from roundrectangle within w_kglb01d1
end type
end forward

global type w_kglb01d1 from window
integer x = 59
integer y = 172
integer width = 4475
integer height = 2248
boolean titlebar = true
string title = "받을어음 결제"
windowtype windowtype = response!
long backcolor = 32106727
cb_x cb_x
cb_c cb_c
p_exit p_exit
p_can p_can
dw_ins dw_ins
dw_bill_insert dw_bill_insert
dw_find dw_find
dw_disp dw_disp
rr_1 rr_1
end type
global w_kglb01d1 w_kglb01d1

type variables
Boolean ib_changed
String     sBudoAcc1,sBudoAcc2,sStatus,LsOwrSaupj,LsSaupNo
end variables

forward prototypes
public function integer wf_insert_kfz12otd ()
end prototypes

public function integer wf_insert_kfz12otd ();Integer iFindRow,iCurRow
String  sFullJunNo

iCurRow = dw_ins.RowCount()

//IF dw_ins.GetItemString(iCurRow,"status") = '9' AND &
//	(dw_ins.GetItemNumber(iCurRow,"budo_amt") = 0 OR IsNull(dw_ins.GetItemNumber(iCurRow,"budo_amt"))) THEN Return 1
	
sFullJunNo = '00000'+ String(Integer(lstr_jpra.saupjang),'00')+lstr_jpra.baldate+lstr_jpra.upmugu+&
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

if dw_ins.GetItemString(iCurRow,"status") = '2' then
	dw_bill_insert.SetItem(iFindRow,"mbal_date",		lstr_jpra.baldate)
	dw_bill_insert.SetItem(iFindRow,"mupmu_gu",		lstr_jpra.upmugu)
	dw_bill_insert.SetItem(iFindRow,"mjun_no",		lstr_jpra.bjunno)
	dw_bill_insert.SetItem(iFindRow,"mlin_no",		lstr_jpra.sortno)
end if

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

event open;String  sCvName,sBillNo,sStatus1,sStatus2
Long    iRowCount,iCurRow

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_disp.Reset()

dw_ins.SetTransObject(SQLCA)
dw_bill_insert.SetTransObject(SQLCA)
dw_find.SetTransObject(SQLCA)
dw_find.Reset()
dw_find.InsertRow(0)

IF lstr_jpra.kwan = "" OR IsNull(lstr_jpra.kwan) THEN
	sBillNo = '%'
ELSE
	sBillNo = lstr_jpra.kwan	
END IF

IF lstr_jpra.saupno = '' or IsNull(lstr_jpra.saupno) THEN
	LsSaupNo = '%'
ELSE
	LsSaupNo = Left(lstr_jpra.saupno,6)
END IF

/*환경 파일에서 '부도어음' 계정코드 가져오기*/
SELECT SUBSTR("SYSCNFG"."DATANAME",1,5),	  SUBSTR("SYSCNFG"."DATANAME",6,2)
	INTO :sBudoAcc1,								  :sBudoAcc2  
	FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 1 ) AND  
         ( "SYSCNFG"."LINENO" = '18' )   ;
IF SQLCA.SQLCODE <> 0 THEN
	sBudoAcc1 = '00000'
	sBudoAcc2 = '00'
ELSE
	IF IsNull(sBudoAcc1) THEN sBudoAcc1 = '00000'
	IF IsNull(sBudoAcc2) THEN sBudoAcc2 = '00'
END IF

//IF lstr_account.remark4 = '' OR IsNull(lstr_account.remark4) THEN		/*어음의 소속 사업장*/
	LsOwrSaupj = lstr_jpra.saupjang
//ELSE
//	LsOwrSaupj = lstr_account.remark4
//END IF

IF lstr_account.acc1_cd = sBudoAcc1 AND lstr_account.acc2_cd = sBudoAcc2 THEN
	sStatus1 = '9';	sStatus2 = '9';
ELSE
	sStatus1 = '1';	sStatus2 = '8';
END IF
	
iRowCount = dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno, lstr_jpra.sortno)
IF iRowCount <=0 THEN
	dw_disp.InsertRow(0)

   dw_disp.SetItem(dw_disp.GetRow(),"saupj",    lstr_jpra.saupjang)
   dw_disp.SetItem(dw_disp.GetRow(),"bal_date", lstr_jpra.baldate)
   dw_disp.SetItem(dw_disp.GetRow(),"upmu_gu",  lstr_jpra.upmugu)
   dw_disp.SetItem(dw_disp.GetRow(),"bjun_no",  lstr_jpra.bjunno)
   dw_disp.SetItem(dw_disp.GetRow(),"lin_no",   lstr_jpra.sortno)
	
	dw_disp.SetItem(dw_disp.GetRow(),"saup_no",  LsSaupNo)
	dw_disp.SetItem(dw_disp.GetRow(),"kfz04om0_v1_person_nm",  F_Get_PersonLst('1',LsSaupNo,'1'))
END IF
dw_disp.SetItem(1,"amount",   lstr_jpra.money) 

dw_ins.SetFilter("")
dw_ins.Filter()
		
dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
 					 lstr_jpra.bjunno, lstr_jpra.sortno,LsSaupNo,sStatus1,sStatus2, lstr_jpra.saupjang)
	
ib_changed = False

dw_ins.SetColumn("status")
dw_ins.SetFocus()


end event

on w_kglb01d1.create
this.cb_x=create cb_x
this.cb_c=create cb_c
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_ins=create dw_ins
this.dw_bill_insert=create dw_bill_insert
this.dw_find=create dw_find
this.dw_disp=create dw_disp
this.rr_1=create rr_1
this.Control[]={this.cb_x,&
this.cb_c,&
this.p_exit,&
this.p_can,&
this.dw_ins,&
this.dw_bill_insert,&
this.dw_find,&
this.dw_disp,&
this.rr_1}
end on

on w_kglb01d1.destroy
destroy(this.cb_x)
destroy(this.cb_c)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_ins)
destroy(this.dw_bill_insert)
destroy(this.dw_find)
destroy(this.dw_disp)
destroy(this.rr_1)
end on

type cb_x from commandbutton within w_kglb01d1
integer x = 4686
integer y = 572
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

type cb_c from commandbutton within w_kglb01d1
integer x = 4686
integer y = 480
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

type p_exit from uo_picture within w_kglb01d1
integer x = 4261
integer y = 44
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;Int    iDbCount,iGyelCnt,iFindRow,k
Double dSumAmount
String sRtnValue

sStatus = '1'

dw_ins.AcceptText()
IF dw_ins.RowCount() > 0 THEN
	IF ib_changed = True THEN
		IF lstr_account.acc1_cd = sBudoAcc1 AND lstr_account.acc2_cd = sBudoAcc2 THEN
			dSumAmount = dw_ins.GetItemNumber(dw_ins.GetRow(),"sum_budoamt")
			IF IsNull(dSumAmount) THEN dSumAmount = 0
			
			IF dSumAmount <> lstr_jpra.money THEN
				F_MessageChk(37,'[전표금액/부도어음계]')
				Return	
			END IF
		ELSE
			IF dw_ins.GetItemNumber(1,"yescnt") > 1 THEN
				F_MessageChk(16,'[결제건수가 1이상]')
				Return
			ELSEIF dw_ins.GetItemNumber(1,"yescnt") <= 0 THEN
				F_MessageChk(11,'')
				Return
			END IF
		
			FOR k = 1 TO dw_ins.RowCount()
				IF dw_ins.GetItemString(k,"status") = "" OR IsNull(dw_ins.GetItemString(k,"status")) THEN
					F_MessageChk(1,'[어음상태]')
					dw_ins.SetColumn("status")
					dw_ins.SetFocus()
					Return
				END IF
				
				IF dw_ins.GetItemString(k,"status") = '4' OR dw_ins.GetItemString(k,"status") = '5' THEN
					IF dw_ins.GetItemString(k,"bill_ntinc") = "" OR IsNull(dw_ins.GetItemString(k,"bill_ntinc")) THEN
						F_MessageChk(1,'[변동거래처]')
						dw_ins.ScrollToRow(k)
						dw_ins.SetColumn("bill_ntinc")
						dw_ins.SetFocus()
						Return
					END IF
				END IF
				IF dw_ins.GetItemString(k,"status") = '6' AND dw_ins.GetItemString(k,"owner_saupj") = LsOwrSaupj THEN
					F_MessageChk(16,'[소속사업장 = 전표사업장]')
					dw_ins.ScrollToRow(k)
					dw_ins.SetColumn("owner_saupj")
					dw_ins.SetFocus()
					Return		
				END IF
			NEXT
			
			dSumAmount = dw_ins.GetItemNumber(dw_ins.GetRow(),"sum_gyelamt")
			IF IsNull(dSumAmount) THEN dSumAmount = 0
			
			IF dSumAmount <> lstr_jpra.money THEN
				F_MessageChk(37,'[전표금액/결제어음계]')
				Return	
			END IF
		END IF
	
		IF lstr_account.acc1_cd = sBudoAcc1 AND lstr_account.acc2_cd = sBudoAcc2 THEN
			dw_ins.SetFilter("str_budoamt <> '0' ")
		ELSE
			dw_ins.SetFilter("status <> '1' and status <> '8' ")
		END IF
		
		dw_ins.Filter()
		
		IF F_DbConFirm('저장') = 2  then return
		
		Wf_Insert_Kfz12otd()
		
		IF dw_bill_insert.Update() <> 1 THEN
			Rollback;
			F_messageChk(13,'')
			Return
		END IF
		
		sRtnValue = '1'
	ELSE
		dw_ins.SetFilter("status <> '1' and status <> '8' ")
		dw_ins.Filter()
		
		SELECT Count("KFZ12OTD"."BILL_NO")	   INTO :iDbCount  				/*기존자료 유무*/
			FROM "KFZ12OTD"  
			WHERE ( "KFZ12OTD"."SAUPJ"    = :lstr_jpra.saupjang ) AND  
					( "KFZ12OTD"."BAL_DATE" = :lstr_jpra.baldate ) AND  
					( "KFZ12OTD"."UPMU_GU"  = :lstr_jpra.upmugu ) AND  
					( "KFZ12OTD"."BJUN_NO"  = :lstr_jpra.bjunno ) AND
					( "KFZ12OTD"."LIN_NO"   = :lstr_jpra.sortno) ;
		IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
			sRtnValue = '1'
			
			Wf_Insert_Kfz12otd()
			dw_bill_insert.Update()
		END IF
	END IF
	
	IF dw_ins.RowCount() > 0 THEN
		lstr_jpra.kwan   = dw_ins.GetItemString(1,"bill_no")
		lstr_jpra.k_eymd = dw_ins.GetItemString(1,"bman_dat")
			
		IF dw_ins.GetItemString(1,"status") = '4' OR &
														dw_ins.GetItemString(1,"status") = '5' THEN
			lstr_jpra.bnkname = dw_ins.GetItemString(1,"bill_ntincnm") 
		ELSEIF dw_ins.GetItemString(1,"status") = '6' THEN
			lstr_jpra.bnkname = F_Get_Refferance('AD',dw_ins.GetItemString(1,"owner_saupj")) 
		ELSE
			SetNull(lstr_jpra.bnkname) 
		END IF
	ELSE
		SetNull(lstr_jpra.bnkname);	SetNull(lstr_jpra.kwan);	SetNull(lstr_jpra.k_eymd);
	END IF
ELSE
	sRtnValue = '0'		
END IF

CloseWithReturn(parent,sRtnValue)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_kglb01d1
integer x = 4087
integer y = 44
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;Integer iRowCount
String  sStatus1,sStatus2

IF lstr_account.acc1_cd = sBudoAcc1 AND lstr_account.acc2_cd = sBudoAcc2 THEN
	sStatus1 = '9';	sStatus2 = '9';
ELSE
	sStatus1 = '1';	sStatus2 = '8';
END IF

dw_ins.SetFilter("")
dw_ins.Filter()

dw_ins.SetRedraw(False)	
dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
 					 lstr_jpra.bjunno, lstr_jpra.sortno,lstr_jpra.saupno,sStatus1,sStatus2, lstr_jpra.saupjang)
	
dw_ins.SetRedraw(True)

dw_find.SetRedraw(False)
dw_find.Reset()
dw_find.InsertRow(0)
dw_find.SetRedraw(True)

dw_ins.SetColumn("status")
dw_ins.SetFocus()

ib_changed = False


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type dw_ins from u_d_popup_sort within w_kglb01d1
event ue_key pbm_dwnkey
integer x = 37
integer y = 260
integer width = 4375
integer height = 1848
integer taborder = 20
string dataobject = "dw_kglb01d1_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;ib_changed = True
end event

event getfocus;this.AcceptText()
end event

event itemchanged;
String sBnkCd,sBnkName,sBillSts,sCusGbn,sSaupNo,sSaupName,sNull

SetNull(sNull)

IF this.GetColumnName() = "status" THEN
	sStatus = this.GetText()
	IF sStatus = "" OR IsNull(sStatus) THEN Return
	
	IF IsNull(F_Get_Refferance('AS',sStatus)) THEN
		F_MessageChk(20,'[어음상태]')
		this.SetItem(this.GetRow(),"status",'1')
		Return 1
	END IF
	
	IF sStatus = '1' THEN
		this.SetItem(this.GetRow(),"mbal_date",sNull)
		this.SetItem(this.GetRow(),"mupmu_gu", sNull)
		this.SetItem(this.GetRow(),"mjun_no",  0)
		this.SetItem(this.GetRow(),"mlin_no",  0)
		this.SetItem(this.GetRow(),"bill_change_date",sNull)
		this.SetItem(this.GetRow(),"bill_ntinc",      sNull)
		this.SetItem(this.GetRow(),"owner_saupj",		 lstr_jpra.saupjang)
		this.SetItem(this.GetRow(),"chu_bnk",         sNull)
		this.SetItem(this.GetRow(),"chu_ymd",         sNull)
	ELSE
		this.SetItem(this.GetRow(),"mbal_date",       lstr_jpra.baldate)
		this.SetItem(this.GetRow(),"mupmu_gu",        lstr_jpra.upmugu)
		this.SetItem(this.GetRow(),"mjun_no",         lstr_jpra.bjunno)
		this.SetItem(this.GetRow(),"mlin_no",         lstr_jpra.sortno)
		this.SetItem(this.GetRow(),"bill_change_date",lstr_jpra.baldate)
	END IF
	
END IF

IF this.GetColumnName() ="chu_bnk" THEN
	sBnkCd = this.GetText()
	IF sBnkCd = "" OR IsNull(sBnkCd) THEN 
		this.SetItem(this.GetRow(),"chu_bnkname",snull)
		REturn
	END IF
	
	SELECT "KFZ04OM0_V2"."PERSON_NM"  	INTO :sbnkName
    	FROM "KFZ04OM0_V2"  
   	WHERE ( "KFZ04OM0_V2"."PERSON_CD" = :sBnkCd );
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[추심은행]')
		this.SetItem(this.GetRow(),"chu_bnk",snull)
		this.SetItem(this.GetRow(),"chu_bnkname",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "bill_ntinc" THEN
	sSaupNo = this.GetText()
	IF sSaupNo = "" OR IsNull(sSaupNo) THEN
		this.SetItem(this.GetRow(),"bill_ntincnm",   sNull)
		Return	
	END IF
	
	sBillSts = this.GetItemString(this.Getrow(),"status")
	IF sBillsts = '4' THEN
		sCusGbn = '2'	
	ELSE
		sCusGbn = '1'
	END IF
	
	/*거래처에 따른 처리*/
	SELECT "KFZ04OM0"."PERSON_NM" 	   INTO :sSaupName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_GU" = :sCusGbn) and ( "KFZ04OM0"."PERSON_CD" = :sSaupNo);
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(this.GetRow(),"bill_ntincnm",  sSaupName)
	ELSE
		F_MessageChk(20,'[거래처]')
		
		this.SetItem(this.GetRow(),"bill_ntinc",     sNull)
		this.SetItem(this.GetRow(),"bill_ntincnm",   sNull)
		Return 1
	END IF
END IF
ib_changed = True


end event

event itemerror;Return 1
end event

event rbuttondown;String sBillSts,sCusGbn

IF this.GetColumnName() ="chu_bnk" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"chu_bnk"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	OpenWithParm(W_KFZ04OM0_POPUP,'2')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"chu_bnk",     lstr_custom.code)
	this.SetItem(this.GetRow(),"chu_bnkname",lstr_custom.name)
	Return
END IF

IF this.GetColumnName() ="bill_ntinc" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"bill_ntinc"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	sBillSts = this.GetItemString(this.GetRow(),"status")
	IF sBillSts = '4' THEN
		sCusGbn = '2'
	ELSE
		sCusGbn = '1'
	END IF
	
	OpenWithParm(W_KFZ04OM0_POPUP,sCusGbn)
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"bill_ntinc",     lstr_custom.code)
	this.SetItem(this.GetRow(),"bill_ntincnm",   lstr_custom.name)
	Return
END IF

end event

event clicked;If Row <= 0 then
	b_flag = True
ELSe
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_bill_insert from datawindow within w_kglb01d1
boolean visible = false
integer x = 480
integer y = 2116
integer width = 1179
integer height = 92
boolean titlebar = true
string title = "받을어음 결제 내역 저장"
string dataobject = "dw_kglb01d1_4"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_find from u_key_enter within w_kglb01d1
integer x = 2382
integer width = 1696
integer height = 248
integer taborder = 10
string dataobject = "dw_kglb01d1_5"
boolean border = false
end type

event buttonclicked;String sBillNoF,sBillNoT,sFromDate,sToDate,sBillAmt,sFindString

IF dwo.name = 'dcb_find' THEN
	this.AcceptText()
	sBillNoF  = this.GetItemString(1,"from_billno")
	sBillNoT  = this.GetItemString(1,"to_billno")
	sFromDate = Trim(this.GetItemString(1,"from_mandate"))
	sToDate   = Trim(this.GetItemString(1,"to_mandate"))
	
	IF sBillNoF = '' OR IsNull(sBillNoF) THEN sBillNoF = '0'
	IF sBillNoT = '' OR IsNull(sBillNoT) THEN sBillNoT = 'z'
	IF sFromDate = '' OR IsNull(sFromDate) THEN sFromDate = '00000000'
	IF sToDate = '' OR IsNull(sToDate) THEN sToDate = '99999999'
	
	dw_ins.SetRedraw(False)
	
	IF this.GetItemNumber(1,"billamt") = 0 OR IsNull(this.GetItemNumber(1,"billamt")) THEN
		sFindString = "bill_no >= '"+sBillNoF+"' and bill_no <= '"+sBillNoT +"' and bman_dat >= '"+sFromDate+"' and bman_dat <= '"+sToDate+"'" 
		dw_ins.SetFilter(sFindString)
		dw_ins.Filter()
	ELSE
		sBillAmt = String(this.GetItemNumber(1,"billamt"))
		
		sFindString = "bill_no >= '"+sBillNoF+"' and bill_no <= '"+sBillNoT +"' and bman_dat >= '"+sFromDate+"' and bman_dat <= '"+sToDate+"' and str_billamt = '"+sBillAmt+"'"
		dw_ins.SetFilter(sFindString)
		dw_ins.Filter()		
	END IF
	dw_ins.SetRedraw(True)
END IF

end event

event rbuttondown;IF this.GetColumnName() ="from_billno" THEN
	gs_code =Trim(this.GetItemString(this.GetRow(),"from_billno"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	
	OPEN(W_KFM02OT0_POPUP)
	
	IF IsNull(gs_code) OR Gs_Code = '' THEN Return
	this.SetItem(1,"from_billno",Gs_Code)
END IF

IF this.GetColumnName() ="to_billno" THEN
	gs_code =Trim(this.GetItemString(this.GetRow(),"to_billno"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	
	OPEN(W_KFM02OT0_POPUP)
	
	IF IsNull(gs_code) OR Gs_Code = '' THEN Return
	this.SetItem(1,"to_billno",Gs_Code)
END IF
end event

type dw_disp from datawindow within w_kglb01d1
integer x = 5
integer y = 44
integer width = 2400
integer height = 204
string dataobject = "dw_kglb01d1_1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kglb01d1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 252
integer width = 4407
integer height = 1876
integer cornerheight = 40
integer cornerwidth = 55
end type

