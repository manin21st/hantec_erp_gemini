$PBExportHeader$w_kglb01c1.srw
$PBExportComments$전표 등록 : 지급어음 결제
forward
global type w_kglb01c1 from window
end type
type cb_c from commandbutton within w_kglb01c1
end type
type cb_x from commandbutton within w_kglb01c1
end type
type p_exit from uo_picture within w_kglb01c1
end type
type p_can from uo_picture within w_kglb01c1
end type
type dw_bill_insert from datawindow within w_kglb01c1
end type
type dw_ins from datawindow within w_kglb01c1
end type
type dw_disp from datawindow within w_kglb01c1
end type
type rr_1 from roundrectangle within w_kglb01c1
end type
end forward

global type w_kglb01c1 from window
integer x = 59
integer y = 188
integer width = 3022
integer height = 1928
boolean titlebar = true
string title = "지급어음 결제"
windowtype windowtype = response!
long backcolor = 32106727
cb_c cb_c
cb_x cb_x
p_exit p_exit
p_can p_can
dw_bill_insert dw_bill_insert
dw_ins dw_ins
dw_disp dw_disp
rr_1 rr_1
end type
global w_kglb01c1 w_kglb01c1

type variables
Boolean ib_changed
String     sStatus,LsOwrSaupj,LsSaupNo
end variables

forward prototypes
public function integer wf_insert_kfz12otc ()
end prototypes

public function integer wf_insert_kfz12otc ();Integer iFindRow,iCurRow
String  sFullJunNo

iCurRow = dw_ins.RowCount()

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

dw_bill_insert.SetItem(iFindRow,"mbal_date",			lstr_jpra.baldate)
dw_bill_insert.SetItem(iFindRow,"mupmu_gu",			lstr_jpra.upmugu)
dw_bill_insert.SetItem(iFindRow,"mjun_no",			lstr_jpra.bjunno)
dw_bill_insert.SetItem(iFindRow,"mlin_no",			lstr_jpra.sortno)
	
dw_bill_insert.SetItem(iFindRow,"bill_no",			dw_ins.GetItemString(iCurRow,"bill_no"))
dw_bill_insert.SetItem(iFindRow,"saup_no",			dw_ins.GetItemString(iCurRow,"saup_no"))
dw_bill_insert.SetItem(iFindRow,"bnk_cd",				dw_ins.GetItemString(iCurRow,"bnk_cd"))
dw_bill_insert.SetItem(iFindRow,"bbal_dat",			dw_ins.GetItemString(iCurRow,"bbal_dat"))
dw_bill_insert.SetItem(iFindRow,"bman_dat",			dw_ins.GetItemString(iCurRow,"bman_dat"))
dw_bill_insert.SetItem(iFindRow,"bill_amt",			dw_ins.GetItemNumber(iCurRow,"bill_amt"))
dw_bill_insert.SetItem(iFindRow,"bill_nm",			dw_ins.GetItemString(iCurRow,"bill_nm"))
dw_bill_insert.SetItem(iFindRow,"status",				dw_ins.GetItemString(iCurRow,"status"))

dw_bill_insert.SetItem(iFindRow,"remark1",			lstr_jpra.desc)

dw_bill_insert.SetItem(iFindRow,"owner_saupj",		dw_ins.GetItemString(iCurRow,"owner_saupj"))

Return 1
end function

event open;String  sCvName,sBillNo
Long    iRowCount,iCurRow

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_disp.Reset()

dw_ins.SetTransObject(SQLCA)
dw_bill_insert.SetTransObject(SQLCA)

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

//IF lstr_account.remark4 = '' OR IsNull(lstr_account.remark4) THEN		/*어음의 소속 사업장*/
	LsOwrSaupj = lstr_jpra.saupjang
//ELSE
//	LsOwrSaupj = lstr_account.remark4
//END IF
	
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
							 					 lstr_jpra.bjunno, lstr_jpra.sortno,LsSaupNo,'1',LsOwrSaupj)
	
ib_changed = False

dw_ins.SetColumn("status")
dw_ins.SetFocus()


end event

on w_kglb01c1.create
this.cb_c=create cb_c
this.cb_x=create cb_x
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_bill_insert=create dw_bill_insert
this.dw_ins=create dw_ins
this.dw_disp=create dw_disp
this.rr_1=create rr_1
this.Control[]={this.cb_c,&
this.cb_x,&
this.p_exit,&
this.p_can,&
this.dw_bill_insert,&
this.dw_ins,&
this.dw_disp,&
this.rr_1}
end on

on w_kglb01c1.destroy
destroy(this.cb_c)
destroy(this.cb_x)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_bill_insert)
destroy(this.dw_ins)
destroy(this.dw_disp)
destroy(this.rr_1)
end on

type cb_c from commandbutton within w_kglb01c1
integer x = 3593
integer y = 508
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

type cb_x from commandbutton within w_kglb01c1
integer x = 3593
integer y = 600
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

type p_exit from uo_picture within w_kglb01c1
integer x = 2802
integer y = 4
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;Int    iDbCount,iGyelCnt,iFindRow,k
Double dSumAmount
String sRtnValue

dw_ins.AcceptText()
IF dw_ins.RowCount() > 0 THEN
	IF ib_changed = True THEN
		IF dw_ins.GetItemNumber(1,"yescnt") > 1 THEN
			F_MessageChk(16,'[결제건수가 1이상]')
			Return
		ELSEIF dw_ins.GetItemNumber(1,"yescnt") <= 0 THEN
			F_MessageChk(11,'')
			Return
		END IF
	
		dSumAmount = dw_ins.GetItemNumber(dw_ins.GetRow(),"sum_gyelamt")
		IF IsNull(dSumAmount) THEN dSumAmount = 0
			
		IF dSumAmount <> lstr_jpra.money THEN
			F_MessageChk(37,'[전표금액/결제어음계]')
			Return	
		END IF
	
		dw_ins.SetFilter("status <> '1' ")
		dw_ins.Filter()
		
		IF F_DbConFirm('저장') = 2  then return
		
		Wf_Insert_Kfz12otc()
		
		IF dw_bill_insert.Update() <> 1 THEN
			Rollback;
			F_messageChk(13,'')
			Return
		END IF
		
		sRtnValue = '1'
	ELSE
		dw_ins.SetFilter("status <> '1' ")
		dw_ins.Filter()
		
		SELECT Count("KFZ12OTC"."BILL_NO")	   INTO :iDbCount  				/*기존자료 유무*/
			FROM "KFZ12OTC"  
			WHERE ( "KFZ12OTC"."SAUPJ"    = :lstr_jpra.saupjang ) AND  
					( "KFZ12OTC"."BAL_DATE" = :lstr_jpra.baldate ) AND  
					( "KFZ12OTC"."UPMU_GU"  = :lstr_jpra.upmugu ) AND  
					( "KFZ12OTC"."BJUN_NO"  = :lstr_jpra.bjunno ) AND
					( "KFZ12OTC"."LIN_NO"   = :lstr_jpra.sortno) ;
		IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
			sRtnValue = '1'
			
			Wf_Insert_Kfz12otc()
			dw_bill_insert.Update()
		END IF
	END IF
	
	IF dw_ins.RowCount() > 0 THEN
		lstr_jpra.kwan   = dw_ins.GetItemString(1,"bill_no")
		lstr_jpra.k_eymd = dw_ins.GetItemString(1,"bman_dat")
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

type p_can from uo_picture within w_kglb01c1
integer x = 2629
integer y = 4
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;Integer iRowCount

dw_ins.SetFilter("")
dw_ins.Filter()

dw_ins.SetRedraw(False)	
dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
 					 lstr_jpra.bjunno, lstr_jpra.sortno,LsSaupNo,'1',LsOwrSaupj)
	
dw_ins.SetRedraw(True)

dw_ins.SetColumn("status")
dw_ins.SetFocus()

ib_changed = False


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type dw_bill_insert from datawindow within w_kglb01c1
boolean visible = false
integer x = 361
integer y = 1704
integer width = 1179
integer height = 92
boolean titlebar = true
string title = "지급어음 결제 내역 저장"
string dataobject = "dw_kglb01c1_3"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

type dw_ins from datawindow within w_kglb01c1
event ue_key pbm_dwnkey
integer x = 50
integer y = 220
integer width = 2907
integer height = 1532
integer taborder = 10
string dataobject = "dw_kglb01c1_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;ib_changed = True
end event

event itemerror;
Return 1
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
	ELSE
		this.SetItem(this.GetRow(),"mbal_date",       lstr_jpra.baldate)
		this.SetItem(this.GetRow(),"mupmu_gu",        lstr_jpra.upmugu)
		this.SetItem(this.GetRow(),"mjun_no",         lstr_jpra.bjunno)
		this.SetItem(this.GetRow(),"mlin_no",         lstr_jpra.sortno)
	END IF
END IF
ib_changed = True


end event

event getfocus;
this.AcceptText()
end event

event retrieverow;//
//IF row > 0 THEN
//	IF lstr_account.acc1_cd = sBudoAcc1 AND lstr_account.acc2_cd = sBudoAcc2 THEN
//		this.SetItem(row,'sflag','9')
//	ELSE
//		this.SetItem(row,'sflag','1')
//	END IF
//END IF
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

type dw_disp from datawindow within w_kglb01c1
integer x = 23
integer width = 2491
integer height = 204
string dataobject = "dw_kglb01c1_1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kglb01c1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 208
integer width = 2939
integer height = 1560
integer cornerheight = 40
integer cornerwidth = 55
end type

