$PBExportHeader$w_kglb01e.srw
$PBExportComments$전표 등록 : 차입금 등록
forward
global type w_kglb01e from window
end type
type cb_c from commandbutton within w_kglb01e
end type
type cb_x from commandbutton within w_kglb01e
end type
type p_exit from uo_picture within w_kglb01e
end type
type p_can from uo_picture within w_kglb01e
end type
type dw_kfz04om0_update from datawindow within w_kglb01e
end type
type dw_ins from u_key_enter within w_kglb01e
end type
end forward

global type w_kglb01e from window
integer x = 219
integer y = 236
integer width = 3703
integer height = 1880
boolean titlebar = true
string title = "차입금 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_c cb_c
cb_x cb_x
p_exit p_exit
p_can p_can
dw_kfz04om0_update dw_kfz04om0_update
dw_ins dw_ins
end type
global w_kglb01e w_kglb01e

type variables
Boolean Ib_Changed
end variables

forward prototypes
public function integer wf_kfz04om0_update ()
public function integer wf_requiredchk ()
end prototypes

public function integer wf_kfz04om0_update ();String scode,sname,sgu,sno,sbnkcd
Int ll_row

dw_ins.AcceptText()

scode  = dw_ins.GetItemString(dw_ins.GetRow(),"lo_cd")
sname  = dw_ins.GetItemString(dw_ins.GetRow(),"lo_name")
sbnkcd = dw_ins.GetItemString(dw_ins.GetRow(),"lo_bnkcd")
sno    = dw_ins.GetItemString(dw_ins.GetRow(),"lo_bnkno")

sgu ='6'

IF dw_kfz04om0_update.Retrieve(sgu,scode) <= 0 THEN
	ll_row = dw_kfz04om0_update.InsertRow(0)
	
	dw_kfz04om0_update.SetItem(ll_row,"person_gu",sgu)
	dw_kfz04om0_update.SetItem(ll_row,"person_cd",scode)
	dw_kfz04om0_update.SetItem(ll_row,"person_nm",sname)
	dw_kfz04om0_update.SetItem(ll_row,"person_no",sno)
	dw_kfz04om0_update.SetItem(ll_row,"person_bnk",sbnkcd)
	dw_kfz04om0_update.SetItem(ll_row,"person_ac1",lstr_jpra.acc1)
	dw_kfz04om0_update.SetItem(ll_row,"person_cd2",lstr_jpra.acc2)
	dw_kfz04om0_update.SetItem(ll_row,"person_tx",' ')
	dw_kfz04om0_update.SetItem(ll_row,"person_sts",'1')
     
ELSE
	dw_kfz04om0_update.SetItem(1,"person_nm",sname)
	dw_kfz04om0_update.SetItem(1,"person_no",sno)
	dw_kfz04om0_update.SetItem(1,"person_bnk",sbnkcd)
	dw_kfz04om0_update.SetItem(1,"person_ac1",lstr_jpra.acc1)
	dw_kfz04om0_update.SetItem(1,"person_cd2",lstr_jpra.acc2)
	dw_kfz04om0_update.SetItem(1,"person_tx",' ')
	dw_kfz04om0_update.SetItem(1,"person_sts",'1')
END IF

IF dw_kfz04om0_update.Update() <> 1 THEN
	Return -1
END IF

Return 1

end function

public function integer wf_requiredchk ();String  sLoName,sBal,sAtGbn,sAtBank,sAtBankNo,sBnkCd,sIjaDay,sMan,sLoGbn
Double  dRate,dLoCamt

dw_ins.AcceptText()
sLoName   = dw_ins.GetItemString(dw_ins.GetRow(),"lo_name")
sBnkCd    = dw_ins.GetItemString(dw_ins.GetRow(),"lo_bnkcd")
sbal      = dw_ins.GetItemString(dw_ins.GetRow(),"lo_afdt")
sMan      = dw_ins.GetItemString(dw_ins.GetRow(),"lo_atdt")
sIjaDay   = dw_ins.GetItemString(dw_ins.GetRow(),"lo_aday")
sAtGbn    = dw_ins.GetItemString(dw_ins.GetRow(),"lo_atgb")
sAtBank   = dw_ins.GetItemString(dw_ins.GetRow(),"lo_atbnkcd")
sAtBankno = dw_ins.GetItemString(dw_ins.GetRow(),"lo_atbnkno")

dRate     = dw_ins.GetItemNumber(dw_ins.GetRow(),"lo_rat")
dLoCamt   = dw_ins.GetItemNumber(dw_ins.GetRow(),"lo_camt")
sLoGbn    = dw_ins.GetItemString(dw_ins.GetRow(),"lo_gbn")

IF sLoName ="" OR IsNull(sLoName) THEN
	F_MessageChk(1,'[차입금명]')
	dw_ins.SetColumn("lo_name")
	dw_ins.SetFocus()
	Return -1
END IF
IF sBnkCd ="" OR IsNull(sBnkCd) THEN
	F_MessageChk(1,'[차입은행]')
	dw_ins.SetColumn("lo_bnkcd")
	dw_ins.SetFocus()
	Return -1
END IF
IF sLoGbn ="" OR IsNull(sLoGbn) THEN
	F_MessageChk(1,'[차입종류]')
	dw_ins.SetColumn("lo_gbn")
	dw_ins.SetFocus()
	Return -1
END IF
IF sBal ="" OR IsNull(sBal) THEN
	F_MessageChk(1,'[차입일자]')
	dw_ins.SetColumn("lo_afdt")
	dw_ins.SetFocus()
	Return -1
END IF
IF sMan ="" OR IsNull(sMan) THEN
	F_MessageChk(1,'[만기일자]')
	dw_ins.SetColumn("lo_atdt")
	dw_ins.SetFocus()
	Return -1
END IF

IF sIjaDay ="" OR IsNull(sIjaDay) THEN
	F_MessageChk(1,'[이자지급일]')
	dw_ins.SetColumn("lo_aday")
	dw_ins.SetFocus()
	Return -1
END IF
IF dRate =0 OR IsNull(dRate) THEN
	F_MessageChk(1,'[이율]')
	dw_ins.SetColumn("lo_rat")
	dw_ins.SetFocus()
	Return -1
END IF
IF sAtGbn ="" OR IsNull(sAtGbn) THEN
	F_MessageChk(1,'[자동이체여부]')
	dw_ins.SetColumn("lo_afgb")
	dw_ins.SetFocus()
	Return -1
END IF

IF sAtGbn = "Y" THEN
	IF satbank ="" OR IsNull(satbank) THEN							//이체은행
		F_MessageChk(1,'[이체은행]')
		dw_ins.SetColumn("lo_atbnkcd")
		dw_ins.SetFocus()
		Return -1
	END IF
		
	IF satbankno ="" OR IsNull(satbankno) THEN
		F_MessageChk(1,'[이체계좌번호]')
		dw_ins.SetColumn("lo_atbnkno")
		dw_ins.SetFocus()
		Return -1	
	END IF
END IF

IF dLoCamt =0 OR IsNull(dLoCamt) THEN
	F_MessageChk(1,'[차입금액]')
	dw_ins.SetColumn("lo_camt")
	dw_ins.SetFocus()
	Return -1
END IF

Return 1
end function

event open;
Long    iRowCount,iCurRow

f_window_center_Response(this)

dw_kfz04om0_update.SetTransObject(SQLCA)
dw_kfz04om0_update.Reset()

dw_ins.SetTransObject(SQLCA)
dw_ins.Reset()

iRowCount = dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)
IF iRowCount <=0 THEN
	iCurRow = dw_ins.InsertRow(0)

   dw_ins.SetItem(iCurRow,"saupj",    lstr_jpra.saupjang)
   dw_ins.SetItem(iCurRow,"bal_date", lstr_jpra.baldate)
   dw_ins.SetItem(iCurRow,"upmu_gu",  lstr_jpra.upmugu)
   dw_ins.SetItem(iCurRow,"bjun_no",  lstr_jpra.bjunno)
   dw_ins.SetItem(iCurRow,"lin_no",   lstr_jpra.sortno)

	dw_ins.SetItem(iCurRow,"lo_afdt", lstr_jpra.baldate)
	
	dw_ins.setItem(iCurRow,"acc1_cd",  lstr_jpra.acc1)
	dw_ins.setItem(iCurRow,"acc2_cd",  lstr_jpra.acc2)
	dw_ins.setItem(iCurRow,"accname",  lstr_jpra.accname)
	
	dw_ins.setItem(iCurRow,"lo_aday",  Right(lstr_jpra.baldate,2))
	
	dw_ins.setItem(iCurRow,"lo_cd",    lstr_jpra.saupno)
	ib_changed = True			
ELSE
	iCurRow = dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)	
																		
	dw_ins.setItem(iCurRow,"lo_cd",    lstr_jpra.saupno)
END IF
dw_ins.setItem(iCurRow,"lo_camt",  lstr_jpra.money)

dw_ins.SetColumn("lo_name")
dw_ins.SetFocus()




end event

on w_kglb01e.create
this.cb_c=create cb_c
this.cb_x=create cb_x
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_kfz04om0_update=create dw_kfz04om0_update
this.dw_ins=create dw_ins
this.Control[]={this.cb_c,&
this.cb_x,&
this.p_exit,&
this.p_can,&
this.dw_kfz04om0_update,&
this.dw_ins}
end on

on w_kglb01e.destroy
destroy(this.cb_c)
destroy(this.cb_x)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_kfz04om0_update)
destroy(this.dw_ins)
end on

type cb_c from commandbutton within w_kglb01e
integer x = 4297
integer y = 444
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

type cb_x from commandbutton within w_kglb01e
integer x = 4297
integer y = 536
integer width = 279
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;p_exit.TriggerEvent(Clicked!)
end event

type p_exit from uo_picture within w_kglb01e
integer x = 3474
integer y = 12
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;Int    iDbCount
Double dAmount
String sRtnValue

IF dw_ins.GetRow() <=0 THEN Return

IF Wf_RequiredChk() = -1 THEN Return

lstr_jpra.saupname = dw_ins.GetItemString(1,"lo_name")

IF ib_changed = True THEN
	
	IF F_DbConFirm('저장') = 2  then return
					
	IF dw_ins.Update() <> 1 THEN
		Rollback;
		F_messageChk(13,'')
		Return
	END IF
	
//	IF wf_kfz04om0_update() = -1 THEN 
//		F_messageChk(13,'[회계인명]')
//		Rollback;
//		Return
//	END IF
	
	lstr_jpra.saupno = lstr_jpra.saupno
	
	sRtnValue = '1'
ELSE
	SELECT Count("KFZ12OTE"."LO_CD")	   INTO :iDbCount  				/*기존자료 유무*/
	   FROM "KFZ12OTE"  
   	WHERE ( "KFZ12OTE"."SAUPJ" = :lstr_jpra.saupjang ) AND  
      	   ( "KFZ12OTE"."BAL_DATE" = :lstr_jpra.baldate ) AND  
         	( "KFZ12OTE"."UPMU_GU" = :lstr_jpra.upmugu ) AND  
	         ( "KFZ12OTE"."BJUN_NO" = :lstr_jpra.bjunno ) AND  
   	      ( "KFZ12OTE"."LIN_NO" = :lstr_jpra.sortno )   ;
	IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
		sRtnValue = '1'	
		dw_ins.Update()
	ELSE
		sRtnValue = '0'
	END IF
END IF

CloseWithReturn(parent,sRtnValue)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_can from uo_picture within w_kglb01e
integer x = 3301
integer y = 12
integer width = 178
integer taborder = 30
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;String sRtnValue

dw_ins.SetRedraw(False)
dw_ins.DeleteRow(0)
IF dw_ins.Update() <> 1 THEN
	F_MessageChk(12,'')
   ROLLBACK;
	Return
END IF
dw_ins.SetRedraw(True)

sRtnValue = '0'
CloseWithReturn(parent,sRtnValue)




end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type dw_kfz04om0_update from datawindow within w_kglb01e
boolean visible = false
integer x = 498
integer y = 1860
integer width = 937
integer height = 96
boolean titlebar = true
string title = "회계인명 저장"
string dataobject = "dw_kglb01e_2"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
end type

type dw_ins from u_key_enter within w_kglb01e
event ue_key pbm_dwnkey
integer x = 18
integer y = 16
integer width = 3648
integer height = 1748
integer taborder = 10
string dataobject = "dw_kglb01e_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String  sIoGbn,sBnkCode,sBnkName,sAfDat,sAtDat,sIjaDay,sAtGbn,sCurr,sNull
Integer iCurRow,lnull
Double  dYcAmt,dRate,dFamt,dJamt,dYfAmt,dLoAmt

SetNull(snull)
SetNull(lnull)

iCurRow = this.GetRow()
IF this.GetColumnName() = "lo_gbn" THEN
	sIoGbn = this.GetText()
	IF sIoGbn = "" OR IsNull(sIoGbn) THEN REturn
	
	IF IsNull(F_Get_Refferance('IO',sIoGbn)) THEN
		F_MessageChk(20,'[차입종류]')
		this.Setitem(iCurRow,"lo_gbn",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="lo_bnkcd" THEN
	sBnkCode = this.GetText()
	IF sBnkCode = "" OR IsNull(sBnkCode) THEN
		this.SetItem(iCurRow,"bankname",snull)
		Return
	END IF
	
   SELECT "KFZ04OM0_V2"."PERSON_NM"  INTO :sBnkName
	   FROM "KFZ04OM0_V2"  
   	WHERE ( "KFZ04OM0_V2"."PERSON_CD" = :sBnkCode )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[차입은행]')
		this.Setitem(iCurRow,"lo_bnkcd",snull)
		this.Setitem(iCurRow,"bankname",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="lo_afdt" THEN
	sAfDat = Trim(this.GetText())
	IF sAfDat = "" OR IsNull(sAfDat) THEN Return
	
	IF f_datechk(sAfDat) = -1 THEN 
		F_MessageChk(21,'[차입일자]')
		this.SetItem(iCurRow,"lo_afdt",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="lo_atdt" THEN
	sAtDat = Trim(this.GetText())
	IF sAtDat = "" OR IsNull(sAtDat) THEN Return
	
	IF f_datechk(sAtDat) = -1 THEN 
		F_MessageChk(21,'[만기일자]')
		this.SetItem(iCurRow,"lo_atdt",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="lo_aday" THEN
	sIjaDay = this.GetText()
	IF sIjaDay = "" OR IsNull(sIjaDay) THEN Return
	
	IF Integer(sIjaDay) > 31 THEN
		F_MessageChk(20,'[이자지급일]')
		this.SetItem(iCurRow,"lo_aday",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="lo_curr" THEN
	sCurr = this.GetText()
	IF sCurr = "" OR IsNull(sCurr) THEN Return
	
	IF IsNull(F_Get_Refferance('10',sCurr)) THEN
		F_MessageChk(20,'[통화단위]')
		this.SetItem(iCurRow,"lo_curr",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="lo_atgb" THEN
	sAtGbn = this.GetText()
	IF sAtGbn = "" OR isNull(sAtGbn) THEN Return
		
	IF sAtGbn <> "Y" AND sAtGbn <> "N" THEN
		F_MessageChk(20,'[자동이체여부]')
		this.SetItem(iCurRow,"lo_atgb",snull)
		Return 1
	END IF
	IF sAtGbn = 'N' THEN
		this.SetItem(iCurRow,"lo_atbnkcd",  snull)
		this.SetItem(iCurRow,"autobankname",snull)
		this.SetItem(iCurRow,"lo_atbnkno",  snull)
	END IF
END IF

IF this.GetColumnName() ="lo_atbnkcd" THEN
	sBnkCode = this.GetText()
	IF sBnkCode = "" OR IsNull(sBnkCode) THEN
		this.SetItem(iCurRow,"autobankname",snull)
		Return
	END IF
	
   SELECT "KFZ04OM0_V2"."PERSON_NM"  INTO :sBnkName
	   FROM "KFZ04OM0_V2"  
   	WHERE ( "KFZ04OM0_V2"."PERSON_CD" = :sBnkCode )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[이체은행]')
		this.Setitem(iCurRow,"lo_atbnkcd",snull)
		this.Setitem(iCurRow,"autobankname",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "lo_camt" THEN
	dLoAmt = Double(this.GetText())
	IF IsNull(dLoAmt) THEN dLoAmt = 0
	
	dFamt = this.GetItemNumber(iCurRow,"lo_famt")
	IF IsNull(dFamt) THEN dFamt = 0
	
	IF dLoAmt < dFamt THEN
		MessageBox("확  인","차입금액보다 유동성채무액이 크면 안됩니다.확인하세요.!!!")
		dw_ins.SetItem(iCurRow,"lo_camt",lnull)
		Return 1
	END IF
END IF

IF this.GetcolumnName() ="lo_famt" THEN
	dFamt = Double(this.GetText())
	IF dFamt = 0 OR IsNull(dFamt) THEN Return
	
	dLoamt = this.GetItemNumber(iCurRow,"lo_camt")
	IF IsNull(dLoamt) THEN dLoamt = 0
	
	IF dLoamt < dFamt  THEN
		MessageBox("확  인","차입금액보다 유동성채무액이 크면 안됩니다.확인하세요.!!!")
		dw_ins.SetItem(iCurRow,"lo_famt",lnull)
		Return 1
	END IF
END IF

IF this.GetcolumnName() ="lo_jamt" THEN
	dJamt = Double(this.GetText())
	IF dJamt = 0 OR IsNull(dJamt) THEN Return
	
	dLoamt = this.GetItemNumber(iCurRow,"lo_camt")
	IF IsNull(dLoamt) THEN dLoamt = 0
	
	IF dLoamt < dJamt THEN
		MessageBox("확  인","차입금액이 상환금액보다 작습니다.확인하세요.!!!")
		dw_ins.SetItem(iCurRow,"lo_jamt",lnull)
		Return 1
	END IF
	
	IF dLoamt = dJamt THEN							/*차입완료*/
		dw_ins.SetItem(iCurRow,"lo_sgbn",'2')
	END IF
END IF

IF this.GetColumnName() ="lo_excrat" THEN
	dRate = Double(this.GetText())
	IF IsNull(dRate) THEN dRate = 0
	
	dYcAmt = this.GetItemNumber(iCurRow,"lo_ycamt")
	IF IsNull(dYcAmt) THEN dYcAmt = 0
	
	this.SetItem(iCurRow,"lo_camt",dYcAmt * dRate) 
END IF

IF this.GetColumnName() ="lo_ycamt" THEN
	dYcAmt = Double(this.GetText())
	IF IsNull(dYcAmt) THEN dYcAmt = 0
	
	dYfAmt = this.GetItemNumber(iCurRow,"lo_yfamt")
	IF IsNull(dYfAmt) THEN dYfAmt = 0
	
	IF dYcAmt < dYfAmt  THEN
		MessageBox("확  인","외화차입금액보다 외화유동성채무액이 크면 안됩니다.확인하세요.!!!")
		this.SetItem(iCurRow,"lo_ycamt",lnull)
		Return 1
	END IF

	dRate = this.GetItemNumber(iCurRow,"lo_excrat")
	IF IsNull(dRate) THEN dRate = 0
	
	this.SetItem(iCurRow,"lo_camt",dYcAmt * dRate) 
END IF

IF this.GetColumnName() ="lo_yfamt" THEN
	dYfAmt = Double(this.GetText())
	IF IsNull(dYfAmt) THEN dYfAmt = 0
	
	dYcAmt = this.GetItemNumber(iCurRow,"lo_ycamt")
	IF IsNull(dYcAmt) THEN dYcAmt = 0
	
	IF dYcAmt < dYfAmt  THEN
		MessageBox("확  인","외화차입금액보다 외화유동성채무액이 크면 안됩니다.확인하세요.!!!")
		this.SetItem(iCurRow,"lo_yfamt",lnull)
		Return 1
	END IF
END IF

end event

event itemerror;Return 1
end event

event editchanged;ib_changed = True
end event

event getfocus;this.AcceptText()
end event

event itemfocuschanged;
IF this.GetcolumnName() = "dambos" OR this.GetColumnName() = "lo_name" THEN
	f_toggle_kor(handle(this))
ELSE
	f_toggle_eng(handle(this))	
END IF
end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="lo_bnkcd" THEN

	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"lo_bnkcd"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	OpenWithParm(W_KFZ04OM0_POPUP,'2')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"lo_bnkcd",lstr_custom.code)
	this.SetItem(this.GetRow(),"bankname",lstr_custom.name)	
END IF

IF this.GetColumnName() ="lo_atbnkcd" THEN

	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"lo_atbnkcd"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF

	OpenWithParm(W_KFZ04OM0_POPUP,'2')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"lo_atbnkcd",lstr_custom.code)
	this.SetItem(this.GetRow(),"autobankname",lstr_custom.name)	
END IF

end event

