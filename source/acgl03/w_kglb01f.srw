$PBExportHeader$w_kglb01f.srw
$PBExportComments$전표 등록 : 유가증권 등록
forward
global type w_kglb01f from window
end type
type cb_c from commandbutton within w_kglb01f
end type
type cb_x from commandbutton within w_kglb01f
end type
type p_exit from uo_picture within w_kglb01f
end type
type p_can from uo_picture within w_kglb01f
end type
type dw_ins from u_key_enter within w_kglb01f
end type
type dw_kfz04om0_update from datawindow within w_kglb01f
end type
end forward

global type w_kglb01f from window
integer x = 219
integer y = 236
integer width = 2944
integer height = 1336
boolean titlebar = true
string title = "유가증권 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_c cb_c
cb_x cb_x
p_exit p_exit
p_can p_can
dw_ins dw_ins
dw_kfz04om0_update dw_kfz04om0_update
end type
global w_kglb01f w_kglb01f

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

scode  = dw_ins.GetItemString(dw_ins.GetRow(),"jz_illd")
sname  = dw_ins.GetItemString(dw_ins.GetRow(),"jz_name")
sbnkcd = dw_ins.GetItemString(dw_ins.GetRow(),"bnk_cd")
sno    = ''

sgu ='7'

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

public function integer wf_requiredchk ();String  sJzName,sBal,sGbn,sBnkCd
Double  dRate,dJzCamt

dw_ins.AcceptText()
sJzName   = dw_ins.GetItemString(dw_ins.GetRow(),"jz_name")
sBnkCd    = dw_ins.GetItemString(dw_ins.GetRow(),"bnk_cd")
sbal      = dw_ins.GetItemString(dw_ins.GetRow(),"jz_bald")
sGbn    = dw_ins.GetItemString(dw_ins.GetRow(),"jz_jeng")

dRate     = dw_ins.GetItemNumber(dw_ins.GetRow(),"jz_rat")
dJzCamt   = dw_ins.GetItemNumber(dw_ins.GetRow(),"jz_camt")

IF sJzName ="" OR IsNull(sJzName) THEN
	F_MessageChk(1,'[증권명]')
	dw_ins.SetColumn("jz_name")
	dw_ins.SetFocus()
	Return -1
END IF
//IF sBnkCd ="" OR IsNull(sBnkCd) THEN
//	F_MessageChk(1,'[예탁은행]')
//	dw_ins.SetColumn("bnk_cd")
//	dw_ins.SetFocus()
//	Return -1
//END IF

IF sBal ="" OR IsNull(sBal) THEN
	F_MessageChk(1,'[발행일자]')
	dw_ins.SetColumn("jz_bald")
	dw_ins.SetFocus()
	Return -1
END IF

IF dJzCamt =0 OR IsNull(dJzCamt) THEN
	F_MessageChk(1,'[취득금액]')
	dw_ins.SetColumn("jz_camt")
	dw_ins.SetFocus()
	Return -1
END IF
IF sGbn ="" OR IsNull(sGbn) THEN
	F_MessageChk(1,'[상환완료여부]')
	dw_ins.SetColumn("jz_jeng")
	dw_ins.SetFocus()
	Return -1
END IF

//IF dRate =0 OR IsNull(dRate) THEN
//	F_MessageChk(1,'[이율]')
//	dw_ins.SetColumn("jz_rat")
//	dw_ins.SetFocus()
//	Return -1
//END IF

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

	dw_ins.SetItem(iCurRow,"jz_bald", lstr_jpra.baldate)
	
	dw_ins.setItem(iCurRow,"acc1_cd",  lstr_jpra.acc1)
	dw_ins.setItem(iCurRow,"acc2_cd",  lstr_jpra.acc2)
	dw_ins.setItem(iCurRow,"accname",  lstr_jpra.accname)
	
	dw_ins.setItem(iCurRow,"jz_illd",    Left(lstr_jpra.saupno,6))
	ib_changed = True				
ELSE
	iCurRow = dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)	
	dw_ins.setItem(iCurRow,"jz_illd",    Left(lstr_jpra.saupno,6))
														
END IF
dw_ins.setItem(iCurRow,"jz_camt",  lstr_jpra.money)

dw_ins.SetColumn("jz_name")
dw_ins.SetFocus()




end event

on w_kglb01f.create
this.cb_c=create cb_c
this.cb_x=create cb_x
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_ins=create dw_ins
this.dw_kfz04om0_update=create dw_kfz04om0_update
this.Control[]={this.cb_c,&
this.cb_x,&
this.p_exit,&
this.p_can,&
this.dw_ins,&
this.dw_kfz04om0_update}
end on

on w_kglb01f.destroy
destroy(this.cb_c)
destroy(this.cb_x)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_ins)
destroy(this.dw_kfz04om0_update)
end on

type cb_c from commandbutton within w_kglb01f
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

type cb_x from commandbutton within w_kglb01f
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
string text = "저장(&S)"
end type

event clicked;p_exit.TriggerEvent(Clicked!)
end event

type p_exit from uo_picture within w_kglb01f
integer x = 2706
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

lstr_jpra.saupname = dw_ins.GetItemString(1,"jz_name")

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
	
	lstr_jpra.saupno = Left(lstr_jpra.saupno,6)
	
	sRtnValue = '1'
ELSE
	SELECT Count("KFZ12OTF"."JZ_ILLD")	   INTO :iDbCount  				/*기존자료 유무*/
	   FROM "KFZ12OTF"  
   	WHERE ( "KFZ12OTF"."SAUPJ" = :lstr_jpra.saupjang ) AND  
      	   ( "KFZ12OTF"."BAL_DATE" = :lstr_jpra.baldate ) AND  
         	( "KFZ12OTF"."UPMU_GU" = :lstr_jpra.upmugu ) AND  
	         ( "KFZ12OTF"."BJUN_NO" = :lstr_jpra.bjunno ) AND  
   	      ( "KFZ12OTF"."LIN_NO" = :lstr_jpra.sortno )   ;
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

type p_can from uo_picture within w_kglb01f
integer x = 2533
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

type dw_ins from u_key_enter within w_kglb01f
event ue_key pbm_dwnkey
integer x = 9
integer y = 4
integer width = 2898
integer height = 1208
integer taborder = 10
string dataobject = "dw_kglb01f_1"
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

event itemchanged;String  sJzGbn,sBnkCode,sBnkName,sBalDat,sManDat,sGuDat,sGbn,sNull
Integer iCurRow,lnull

SetNull(snull)
SetNull(lnull)

iCurRow = this.GetRow()
IF this.GetColumnName() = "jz_gbn" THEN
	sJzGbn = this.GetText()
	IF sJzGbn = "" OR IsNull(sJzGbn) THEN REturn
	
	IF IsNull(F_Get_Refferance('JZ',sJzGbn)) THEN
		F_MessageChk(20,'[증권종류]')
		this.Setitem(iCurRow,"jz_gbn",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="bnk_cd" THEN
	sBnkCode = this.GetText()
	IF sBnkCode = "" OR IsNull(sBnkCode) THEN
		this.SetItem(iCurRow,"bankname",snull)
		Return
	END IF
	
   SELECT "KFZ04OM0_V2"."PERSON_NM"  INTO :sBnkName
	   FROM "KFZ04OM0_V2"  
   	WHERE ( "KFZ04OM0_V2"."PERSON_CD" = :sBnkCode )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[예탁은행]')
		this.Setitem(iCurRow,"bnk_cd",snull)
		this.Setitem(iCurRow,"bankname",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="jz_bald" THEN
	sBalDat = Trim(this.GetText())
	IF sBalDat = "" OR IsNull(sBalDat) THEN Return
	
	IF f_datechk(sBalDat) = -1 THEN 
		F_MessageChk(21,'[발행일자]')
		this.SetItem(iCurRow,"jz_bald",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="jz_mand" THEN
	sManDat = Trim(this.GetText())
	IF sManDat = "" OR IsNull(sManDat) THEN Return
	
	IF f_datechk(sManDat) = -1 THEN 
		F_MessageChk(21,'[만기일자]')
		this.SetItem(iCurRow,"jz_mand",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="jz_jeng" THEN
	sGbn = this.GetText()
	IF sGbn = "" OR isNull(sGbn) THEN Return
	
	IF sGbn <> "Y" AND sGbn <> "N" THEN
		F_MessageChk(20,'[상환완료여부]')
		dw_ins.SetItem(iCurRow,"jz_jeng",snull)
		Return 1
	END IF
END IF

end event

event itemerror;Return 1
end event

event itemfocuschanged;
IF this.GetcolumnName() = "dambos" OR this.GetColumnName() = "jz_name" THEN
	f_toggle_kor(handle(this))
ELSE
	f_toggle_eng(handle(this))	
END IF
end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

IF this.GetColumnName() ="bnk_cd" THEN

	lstr_custom.code = Trim(this.GetItemString(this.GetRow(),"bnk_cd"))
	
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF
   
	OpenWithParm(W_KFZ04OM0_POPUP,'2')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"bnk_cd",lstr_custom.code)
	this.SetItem(this.GetRow(),"bankname",lstr_custom.name)	
END IF

end event

type dw_kfz04om0_update from datawindow within w_kglb01f
boolean visible = false
integer x = 306
integer y = 1224
integer width = 937
integer height = 96
boolean titlebar = true
string title = "회계인명 저장"
string dataobject = "dw_kglb01e_2"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
end type

