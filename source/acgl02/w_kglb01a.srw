$PBExportHeader$w_kglb01a.srw
$PBExportComments$전표 등록 : 접대비 등록
forward
global type w_kglb01a from window
end type
type cb_x from commandbutton within w_kglb01a
end type
type cb_c from commandbutton within w_kglb01a
end type
type cb_d from commandbutton within w_kglb01a
end type
type cb_t from commandbutton within w_kglb01a
end type
type p_exit from uo_picture within w_kglb01a
end type
type p_can from uo_picture within w_kglb01a
end type
type p_del from uo_picture within w_kglb01a
end type
type p_ins from uo_picture within w_kglb01a
end type
type dw_ins from datawindow within w_kglb01a
end type
type dw_list from datawindow within w_kglb01a
end type
type dw_disp from u_key_enter within w_kglb01a
end type
type cb_3 from commandbutton within w_kglb01a
end type
type rr_1 from roundrectangle within w_kglb01a
end type
type rr_2 from roundrectangle within w_kglb01a
end type
end forward

global type w_kglb01a from window
integer x = 1061
integer y = 124
integer width = 3209
integer height = 2276
boolean titlebar = true
string title = "접대비내역 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_x cb_x
cb_c cb_c
cb_d cb_d
cb_t cb_t
p_exit p_exit
p_can p_can
p_del p_del
p_ins p_ins
dw_ins dw_ins
dw_list dw_list
dw_disp dw_disp
cb_3 cb_3
rr_1 rr_1
rr_2 rr_2
end type
global w_kglb01a w_kglb01a

type variables
Boolean ib_changed
end variables

forward prototypes
public function integer wf_requiredchk (integer icurrow)
end prototypes

public function integer wf_requiredchk (integer icurrow);String  sBilDate,sJubJiGbn,sJubGbn,sJubArea,sCardNo,sRecp_Sawon,sRecp_Purpose,sRecp_Sno,sRecp_sName,&
		  sJub_Cnm,sJub_Cno
Integer iSeqNo
Double  dAmount

dw_ins.AcceptText()
sBilDate  = Trim(dw_ins.GetItemString(iCurRow,"bil_date"))
iSeqNo    = dw_ins.GetItemNumber(iCurRow,"seq_no")
sJubJiGbn = dw_ins.GetItemString(iCurRow,"jub_jigu")
sJubArea  = dw_ins.GetItemString(iCurRow,"jub_area")

sJubGbn   = dw_ins.GetItemString(iCurRow,"jub_gu")
dAmount   = dw_ins.GetItemNumber(iCurRow,"jub_amt")
sCardNo   = dw_ins.GetItemString(iCurRow,"card_no")

sRecp_Sawon   = dw_ins.GetItemString(iCurRow,"jun_nm")
sRecp_Purpose = dw_ins.GetItemString(iCurRow,"recp_purpose")
sRecp_Sno     = dw_ins.GetItemString(iCurRow,"recp_cust")
sRecp_Sname   = dw_ins.GetItemString(iCurRow,"recp_custnm")
sJub_Cnm      = dw_ins.GetItemString(iCurRow,"jub_cnm1")
sJub_Cno      = dw_ins.GetItemString(iCurRow,"jub_cno")

IF sBilDate = "" OR IsNull(sBilDate) THEN 
	F_MessageChk(1,'[영수일자]')
	dw_ins.SetColumn("bil_date")
	dw_ins.SetFocus()
	Return -1
END IF
IF iSeqNo = 0 OR IsNull(iSeqNo) THEN 
	F_MessageChk(1,'[영수번호]')
	dw_ins.SetColumn("seq_no")
	dw_ins.SetFocus()
	Return -1
END IF
IF sJubJiGbn = "" OR IsNull(sJubJiGbn) THEN 
	F_MessageChk(1,'[접대지출구분]')
	dw_ins.SetColumn("jub_jigu")
	dw_ins.SetFocus()
	Return -1
END IF

//IF sJubJiGbn = '1' and (sJubArea = "" OR IsNull(sJubArea)) THEN 
//	F_MessageChk(1,'[접대지역]')
//	dw_ins.SetColumn("jub_area")
//	dw_ins.SetFocus()
//	Return -1
//END IF

IF sJubGbn = "" OR IsNull(sJubGbn) THEN 
	F_MessageChk(1,'[접대구분]')
	dw_ins.SetColumn("jub_gu")
	dw_ins.SetFocus()
	Return -1
ELSE
	IF sJubGbn = '2' and (sCardNo = '' or IsNull(sCardNo)) THEN
		F_MessageChk(1,'[카드번호]')
		dw_ins.SetColumn("card_no")
		dw_ins.SetFocus()
		Return -1	
	END IF
END IF
	
IF IsNull(dAmount) THEN 
	F_MessageChk(1,'[접대금액]')
	dw_ins.SetColumn("jub_amt")
	dw_ins.SetFocus()
	Return -1
END IF

IF dAmount >= 500000 THEN				/*50만원 이상*/
	IF sRecp_Sawon = "" OR IsNull(sRecp_Sawon) THEN 
		F_MessageChk(1,'[접대자]')
		dw_ins.SetColumn("jun_nm")
		dw_ins.SetFocus()
		Return -1
	END IF	
	IF sRecp_Purpose = "" OR IsNull(sRecp_Purpose) THEN 
		F_MessageChk(1,'[접대목적]')
		dw_ins.SetColumn("recp_purpose")
		dw_ins.SetFocus()
		Return -1
	END IF	
	IF sJubJiGbn = '1' AND (sRecp_Sno = "" OR IsNull(sRecp_Sno)) THEN 
		F_MessageChk(1,'[접대상대방-사업자번호]')
		dw_ins.SetColumn("recp_cust")
		dw_ins.SetFocus()
		Return -1
	END IF	
	IF sRecp_Sname = "" OR IsNull(sRecp_Sname) THEN 
		F_MessageChk(1,'[접대상대방-상호]')
		dw_ins.SetColumn("recp_custnm")
		dw_ins.SetFocus()
		Return -1
	END IF	
	IF sJub_Cnm = "" OR IsNull(sJub_Cnm) THEN 
		F_MessageChk(1,'[접대처-상호]')
		dw_ins.SetColumn("jub_cnm1")
		dw_ins.SetFocus()
		Return -1
	END IF	
	IF sJubJiGbn = '1' AND (sJub_Cno = "" OR IsNull(sJub_Cno)) THEN 
		F_MessageChk(1,'[접대처-사업자번호]')
		dw_ins.SetColumn("jub_cno")
		dw_ins.SetFocus()
		Return -1
	END IF	
END IF

Return 1
end function

event open;
Long iRowCount,iCurRow

f_window_center_Response(this)

dw_disp.SetTransObject(SQLCA)
dw_disp.Reset()
dw_ins.SetTransObject(SQLCA)
dw_ins.Reset()

dw_ins.ShareData(dw_list)											/*dw_ins와 dw_list 공유*/

iRowCount = dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)
IF iRowCount <=0 THEN
	dw_disp.InsertRow(0)

   dw_disp.SetItem(dw_disp.GetRow(),"saupj",    lstr_jpra.saupjang)
   dw_disp.SetItem(dw_disp.GetRow(),"bal_date", lstr_jpra.baldate)
   dw_disp.SetItem(dw_disp.GetRow(),"upmu_gu",  lstr_jpra.upmugu)
   dw_disp.SetItem(dw_disp.GetRow(),"bjun_no",  lstr_jpra.bjunno)
   dw_disp.SetItem(dw_disp.GetRow(),"lin_no",   lstr_jpra.sortno)
	
	iCurRow = dw_ins.InsertRow(0)

   dw_ins.SetItem(iCurRow,"saupj",    lstr_jpra.saupjang)
   dw_ins.SetItem(iCurRow,"bal_date", lstr_jpra.baldate)
   dw_ins.SetItem(iCurRow,"upmu_gu",  lstr_jpra.upmugu)
   dw_ins.SetItem(iCurRow,"bjun_no",  lstr_jpra.bjunno)
   dw_ins.SetItem(iCurRow,"lin_no",   lstr_jpra.sortno)

	dw_ins.SetItem(iCurRow,"bil_date", lstr_jpra.baldate)
	dw_ins.SetItem(iCurRow,"seq_no",   1)
	
	dw_ins.ScrollToRow(iCurRow)
	
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(iCurRow,True)
	
	dw_ins.SetFocus()
	
	ib_changed = False
ELSE
	dw_ins.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)															
	dw_ins.ScrollToRow(1)
	
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(1,True)
	
	dw_ins.SetFocus()
	
	ib_changed = True
END IF
dw_disp.SetItem(dw_disp.GetRow(),"amount",   lstr_jpra.money) 




end event

on w_kglb01a.create
this.cb_x=create cb_x
this.cb_c=create cb_c
this.cb_d=create cb_d
this.cb_t=create cb_t
this.p_exit=create p_exit
this.p_can=create p_can
this.p_del=create p_del
this.p_ins=create p_ins
this.dw_ins=create dw_ins
this.dw_list=create dw_list
this.dw_disp=create dw_disp
this.cb_3=create cb_3
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.cb_x,&
this.cb_c,&
this.cb_d,&
this.cb_t,&
this.p_exit,&
this.p_can,&
this.p_del,&
this.p_ins,&
this.dw_ins,&
this.dw_list,&
this.dw_disp,&
this.cb_3,&
this.rr_1,&
this.rr_2}
end on

on w_kglb01a.destroy
destroy(this.cb_x)
destroy(this.cb_c)
destroy(this.cb_d)
destroy(this.cb_t)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_del)
destroy(this.p_ins)
destroy(this.dw_ins)
destroy(this.dw_list)
destroy(this.dw_disp)
destroy(this.cb_3)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type cb_x from commandbutton within w_kglb01a
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

type cb_c from commandbutton within w_kglb01a
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

type cb_d from commandbutton within w_kglb01a
integer x = 3593
integer y = 416
integer width = 279
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&D)"
end type

event clicked;p_del.TriggerEvent(Clicked!)
end event

type cb_t from commandbutton within w_kglb01a
integer x = 3593
integer y = 324
integer width = 279
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&T)"
end type

event clicked;p_ins.TriggerEvent(Clicked!)
end event

type p_exit from uo_picture within w_kglb01a
integer x = 2976
integer y = 4
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;Int    k,iRowCount,iDbCount
Double dAmount,dSumAmount
String sRtnValue

IF ib_changed = True THEN
	iRowCount = dw_ins.RowCount()
	IF iRowCount <=0 THEN 
		sRtnValue = '0'
	ELSE
		FOR k = 1 TO iRowCount
			IF Wf_RequiredChk(k) = -1 THEN ReTurn
			
			dw_ins.SetItem(k,"seq_no",k)
		NEXT
		
		IF F_DbConFirm('저장') = 2  then return
	
		dSumAmount = dw_list.GetItemNumber(dw_list.RowCount(),"sum_amount")
		IF IsNull(dSumAmount) THEN dSumAmount = 0
		
		IF dSumAmount <> lstr_jpra.money THEN
			F_MessageChk(37,'')
			Return	
		END IF
				
		IF dw_ins.Update() <> 1 THEN
			Rollback;
			F_messageChk(13,'')
			Return
		END IF
		sRtnValue = '1'
	END IF
ELSE
	SELECT Count("KFZ12OTA"."BIL_DATE")	   INTO :iDbCount  				/*기존자료 유무*/
	   FROM "KFZ12OTA"  
   	WHERE ( "KFZ12OTA"."SAUPJ" = :lstr_jpra.saupjang ) AND  
      	   ( "KFZ12OTA"."BAL_DATE" = :lstr_jpra.baldate ) AND  
         	( "KFZ12OTA"."UPMU_GU" = :lstr_jpra.upmugu ) AND  
	         ( "KFZ12OTA"."BJUN_NO" = :lstr_jpra.bjunno ) AND  
   	      ( "KFZ12OTA"."LIN_NO" = :lstr_jpra.sortno )   ;
	IF SQLCA.SQLCODE = 0 AND iDbCount <> 0 AND Not IsNull(iDbCount) THEN
		sRtnValue = '1'	
		dw_ins.Update()
	ELSE
		sRtnValue = '0'
	END IF
END IF

CloseWithReturn(parent,sRtnValue)
end event

type p_can from uo_picture within w_kglb01a
integer x = 2802
integer y = 4
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;Integer iRowCount,iCurRow

//ROLLBACK;

dw_ins.SetRedraw(False)
dw_ins.Reset()

iRowCount = dw_disp.Retrieve(lstr_jpra.saupjang,lstr_jpra.baldate,lstr_jpra.upmugu,&
																		lstr_jpra.bjunno,lstr_jpra.sortno)
IF iRowCount <=0 THEN
	dw_disp.InsertRow(0)

   dw_disp.SetItem(dw_disp.GetRow(),"saupj",    lstr_jpra.saupjang)
   dw_disp.SetItem(dw_disp.GetRow(),"bal_date", lstr_jpra.baldate)
   dw_disp.SetItem(dw_disp.GetRow(),"upmu_gu",  lstr_jpra.upmugu)
   dw_disp.SetItem(dw_disp.GetRow(),"bjun_no",  lstr_jpra.bjunno)
   dw_disp.SetItem(dw_disp.GetRow(),"lin_no",   lstr_jpra.sortno)
	
	iCurRow = dw_ins.InsertRow(0)

   dw_ins.SetItem(iCurRow,"saupj",    lstr_jpra.saupjang)
   dw_ins.SetItem(iCurRow,"bal_date", lstr_jpra.baldate)
   dw_ins.SetItem(iCurRow,"upmu_gu",  lstr_jpra.upmugu)
   dw_ins.SetItem(iCurRow,"bjun_no",  lstr_jpra.bjunno)
   dw_ins.SetItem(iCurRow,"lin_no",   lstr_jpra.sortno)

	dw_ins.SetItem(iCurRow,"bil_date", lstr_jpra.baldate)
	dw_ins.SetItem(iCurRow,"seq_no",   1)
	
	dw_ins.ScrollToRow(iCurRow)
	
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(iCurRow,True)
ELSE
	dw_ins.ScrollToRow(1)
	
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(1,True)
END IF
dw_disp.SetItem(dw_disp.GetRow(),"amount",   lstr_jpra.money) 
dw_ins.SetRedraw(True)

ib_changed = False

end event

type p_del from uo_picture within w_kglb01a
integer x = 2629
integer y = 4
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

event clicked;call super::clicked;Integer iCurRow

iCurRow = dw_list.GetSelectedRow(0)

IF iCurRow <=0 THEN REturn

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_ins.DeleteRow(iCurRow)
IF dw_ins.Update() <> 1 THEN
	F_MessageChk(12,'')
   ROLLBACK;
	Return
END IF
ib_changed = True


end event

type p_ins from uo_picture within w_kglb01a
integer x = 2455
integer y = 4
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

event clicked;call super::clicked;Integer  iCurRow,iFunctionValue

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
	
	dw_ins.SetItem(iCurRow,"bil_date",  lstr_jpra.baldate)
	IF iCurRow = 1 THEN
		dw_ins.SetItem(iCurRow,"seq_no",    1)
	ELSE
		dw_ins.SetItem(iCurRow,"seq_no",    dw_list.GetItemNumber(iCurRow - 1,"seq_no") + 1)
	END IF
	
	dw_ins.ScrollToRow(iCurRow)
		
	dw_ins.SetColumn("bil_date")
	dw_ins.SetFocus()
	
	dw_list.SelectRow(0,False)
	dw_list.SelectRow(iCurRow,True)
	
	dw_list.ScrollToRow(iCurRow)
END IF
ib_changed = True

end event

type dw_ins from datawindow within w_kglb01a
event ue_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 1376
integer y = 228
integer width = 1728
integer height = 1880
integer taborder = 30
string dataobject = "dw_kglb01a_2"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event editchanged;ib_changed = True
end event

event getfocus;this.AcceptText()


end event

event itemerror;Return 1
end event

event itemchanged;String  sBilDate,sJubJiGbn,sJubGbn,sCardNo,sRefData,sOwner,sNull,sJubNm,sCustNo,sCustNm,sJubCnm2
Integer iCurRow
Double  dJubAmt

iCurRow = this.GetRow()

IF this.GetColumnName() = "bil_date" THEN
	sBilDate = Trim(this.GetText())
	IF sBilDate = "" OR IsNull(sBilDate) THEN Return
	
	IF F_DateChk(sBilDate) = -1 THEN
		F_MessageChk(21,'[영수일자]')
		this.SetItem(iCurRow,"bil_date",sNull)
		Return 1
	END IF
END IF
IF this.GetColumnName() ="jub_jigu" THEN
	sJubJiGbn = this.GetText()
	IF sJubJiGbn = "" OR IsNull(sJubJiGbn) THEN Return
	
	SELECT "REFFPF"."RFNA1"  INTO :sRefData
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = 'AI' ) AND	( "REFFPF"."RFGUB" = :sJubJiGbn )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[접대 지출 구분]')
		this.SetItem(iCurRow,"jub_jigu",snull)
		Return 1
	END IF
END IF
IF this.GetColumnName() = "jub_amt" THEN
	dJubAmt = Double(this.GetText())
	if IsNull(dJubAmt) then dJubAmt = 0
	
	select rfgub	into :sJubGbn	from reffpf
		where rfcod = 'AJ' and 
				:dJubAmt >= to_number(substr(rfna2,1,6)) and
				:dJubAmt <= to_number(substr(rfna2,7,10)) ;
				
	this.SetItem(this.GetRow(),"jub_gu", sJubGbn)				
END IF
IF this.GetColumnName() ="jub_gu" THEN
	sJubGbn = this.GetText()
	IF sJubGbn = "" OR IsNull(sJubGbn) THEN Return
	
	SELECT "REFFPF"."RFNA1"  	INTO :sRefData
	  	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = 'AJ' ) AND  ( "REFFPF"."RFGUB" = :sJubGbn )   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[접대구분]')
		this.SetItem(iCurRow,"jub_gu",snull)
		Return 1
	ELSE
		this.SetItem(iCurRow,"card_no",snull)
		this.SetItem(iCurRow,"jun_nm",snull)
		this.SetItem(iCurRow,"jub_cno",snull)
	END IF
END IF

IF this.GetColumnName() ='jun_nm' then
	sJubNm = this.GetText()
	if sJubNm = '' or IsNull(sJubNm) then Return
	
	this.SetItem(this.GetRow(),"recp_name",F_Get_Personlst('4',sJubNm,'%'))
END IF

IF this.GetColumnName() ='jub_cnm2' then
	sJubCnm2 = this.GetText()
	if sJubCnm2 = '' or IsNull(sJubCnm2) then Return
	
	this.SetItem(this.GetRow(),"recp_dpt_name",F_Get_Personlst('3',sJubCnm2,'%'))
END IF

IF this.GetColumnName() ='recp_cust' then
	sCustNo = this.GetText()
	if sCustNo = '' or IsNull(sCustNo) then Return
	
	select cvnas	into :sCustNm	from vndmst where sano = :sCustNo;
	
	this.SetItem(this.GetRow(),"recp_custnm", sCustNm)
END IF

IF this.GetColumnName() ="card_no" THEN
	sCardNo = this.GetText()
	IF sCardNo = "" OR IsNull(sCardNo) THEN Return
	
	SELECT "KFZ05OM0"."OWNER"   	INTO :sOwner
	  	FROM "KFZ05OM0"  
   	WHERE "KFZ05OM0"."CARD_NO" = :sCardNo   ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[카드번호]')
		this.SetItem(iCurRow,"card_no",snull)
		Return 1
	END IF
END IF

end event

event itemfocuschanged;
IF this.GetColumnName() = "jun_nm" OR this.GetColumnName() = "jub_cnm1" OR &
	this.GetColumnName() = "recp_purpose" OR this.GetColumnName() = "jub_owner" OR &
	this.GetColumnName() = "jub_adr1" OR this.GetColumnName() = "recp_charge" OR &
	this.GetColumnName() = "recp_charge_dept" OR &
	this.GetColumnName() = "uptae" OR this.GetColumnName() = "upjong" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event rowfocuschanged;IF currentrow <=0 then Return

ScrollToRow(currentrow)

dw_list.SelectRow(0,False)
dw_list.SelectRow(currentrow,True)
end event

event rbuttondown;String sSano

SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "jun_nm" THEN
	SetNull(lstr_custom.code);			SetNull(lstr_custom.name);
	
	OpenWithParm(W_Kfz04om0_Popup,'4')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"jun_nm",    lstr_custom.code)
	this.SetItem(this.GetRow(),"recp_name", lstr_custom.name)
	this.Setfocus()
END IF

IF this.GetColumnName() = "jub_cnm2" THEN
	SetNull(lstr_custom.code);			SetNull(lstr_custom.name);
	
	OpenWithParm(W_Kfz04om0_Popup,'3')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"jub_cnm2",      lstr_custom.code)
	this.SetItem(this.GetRow(),"recp_dpt_name", lstr_custom.name)
	this.Setfocus()
END IF

IF this.GetColumnName() = "recp_cust" THEN
	SetNull(gs_code);			SetNull(gs_codename);
	
	Open(W_vndmst_Popup)
	
	IF gs_code = "" OR IsNull(gs_code) THEN Return
	
	select sano	into :sSano	from vndmst where cvcod = :gs_code ;
	
	this.SetItem(this.GetRow(),"recp_cust",   sSano)
	this.SetItem(this.GetRow(),"recp_custnm", gs_codename)
	this.SetColumn("recp_charge")
	this.Setfocus()
END IF

IF this.GetColumnName() = "jub_adr1" THEN
	Open(W_Zip_PopUp)
	
	IF Gs_code = "" OR IsNull(Gs_code) THEN Return
	
	this.SetItem(this.GetRow(),"jub_adr1",gs_codename)
	this.Setfocus()
END IF

IF this.GetColumnName() ="card_no" THEN
	SetNull(Gs_Code)
	SetNull(Gs_CodeName)

	Gs_Code = Trim(this.GetItemString(this.GetRow(),"card_no"))
	
	IF IsNull(Gs_Code) THEN Gs_Code = ""

	Open(W_KFZ05OM0_POPUP)
	
	IF Gs_Code = "" OR IsNull(Gs_Code) THEN Return
	
	this.SetItem(this.GetRow(),"card_no",Gs_Code)
	this.TriggerEvent(ItemChanged!)
	
END IF

ib_changed = True
end event

type dw_list from datawindow within w_kglb01a
integer x = 55
integer y = 224
integer width = 1262
integer height = 1908
integer taborder = 10
string dataobject = "dw_kglb01a_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;
If Row <= 0 then Return

SelectRow(0, FALSE)
SelectRow(Row,TRUE)

dw_ins.ScrollToRow(row)
end event

event rowfocuschanged;If currentrow <= 0 then Return

SelectRow(0, FALSE)
SelectRow(currentrow,TRUE)

dw_ins.ScrollToRow(currentrow)
end event

type dw_disp from u_key_enter within w_kglb01a
integer x = 27
integer y = 4
integer width = 2185
integer height = 212
integer taborder = 0
string dataobject = "dw_kglb01a_1"
boolean border = false
end type

event itemchanged;//IF dwo.name ="bil_date" THEN
//	IF data ="" OR IsNull(data) THEN RETURN 1
//END IF
//
//IF dwo.name ="jub_jigu" THEN
//	IF data ="" OR IsNull(data) THEN RETURN 1
//END IF
//
//IF dwo.name ="jub_gu" THEN
//	IF data ="" OR IsNull(data) THEN RETURN 1
//END IF
//
//IF dwo.name ="jub_amt" THEN
//	IF data ="" OR IsNull(data) THEN RETURN 1
//END IF
//
//IF WF_DATA_CHK(dwo.name,data) = -1 THEN
//	itemerr = True
//	RETURN 1
//END IF
//
end event

type cb_3 from commandbutton within w_kglb01a
boolean visible = false
integer x = 1417
integer y = 1424
integer width = 311
integer height = 92
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = roman!
string facename = "바탕체"
string text = "완료(OLD)"
end type

event clicked;//String ls_jub_cus, ls_jub_gu, ls_bon_amt
//String ls_card_no, ls_jun_nm, ls_jub_owner, ls_jub_cno
//String ls_jub_cnm1, ls_jub_cnm2,ls_jub_adr1, ls_jub_adr2
//String ls_date
//String MYSQL1,MYSQL2, MYSQL3,mysqla, mysqlb
//Double mysqlc
//Long ll_row, ll_jub_no,ll_sortno,CHK
//Double ldb_jub_amt, ldb_bon_amt
//
//dw_1.AcceptText()    
//ll_row = dw_1.GetRow()
//ll_sortno =dw_1.GetItemNumber(ll_row,"lin_no")
//ls_bil_yy  = Trim(dw_1.GetItemString(ll_row,"bil_yy"))
//ls_bil_mm  = Trim(dw_1.GetItemString(ll_row,"bil_mm"))
//ls_bil_dd  = Trim(dw_1.GetItemString(ll_row,"bil_dd"))
//ldb_jub_amt= dw_1.GetItemNumber(ll_row,"jub_amt")
//ls_jub_cus = dw_1.GetItemString(ll_row,"jub_cus")
//ls_jub_gu  = dw_1.GetItemString(ll_row,"jub_gu")
//ldb_bon_amt  = dw_1.GetItemNumber(ll_row,"bon_amt")
//
//
//IF ls_jub_gu = "2" THEN  //**카드시
//   dw_3.AcceptText()
//   ll_row = dw_3.GetRow()
//   ls_card_no  = Trim(dw_3.GetItemString(ll_row,"kfz15ot0_card_no"))
//   ls_jun_nm   = dw_3.GetItemString(ll_row,"kfz05om0_owner")
//   ls_jub_owner= dw_3.GetItemString(ll_row,"kfz15ot0_jub_owner")
//   ls_jub_cno  = Trim(dw_3.GetItemString(ll_row,"kfz15ot0_jub_cno"))
//
//ELSE
//   dw_2.AcceptText()
//   ll_row = dw_2.GetRow()
//   ls_jub_cnm1  = dw_2.GetItemString(ll_row,"jub_cnm1")
//   ls_jub_cnm2  = dw_2.GetItemString(ll_row,"jub_cnm2")
//   ls_jub_owner = dw_2.GetItemString(ll_row,"jub_owner")
//   ls_jub_adr1  = dw_2.GetItemString(ll_row,"jub_adr1")
//   ls_jub_adr2  = dw_2.GetItemString(ll_row,"jub_adr2")
//   ls_jub_cno   = Trim(dw_2.GetItemString(ll_row,"jub_cno"))
//END IF
//
//// // 자료check //
//ls_date =  ls_bil_yy + ls_bil_mm + ls_bil_dd
//date_chk = Dateck1(ls_date)
//IF  date_chk = 0  THEN
//  MessageBox("확인", "영수증일자를 확인하십시오")
//  dw_1.SetColumn("bil_yy")
//  dw_1.SetFocus()
//  Return
//END IF
//IF is_button_chk = "조회" THEN
//	IF gl_yymm="수정" THEN
//  		SELECT "KFZ15OT0"."SEQ_NO"  
//    		INTO :get_jub_no
//    		FROM "KFZ15OT0"  
//   		WHERE ( "KFZ15OT0"."SAUPJ" = :lstr_jpra.saupjang ) AND  
//         		( "KFZ15OT0"."BAL_YY" = :lstr_jpra.publyy ) AND  
//         		( "KFZ15OT0"."BAL_MM" = :lstr_jpra.publmm ) AND  
//         		( "KFZ15OT0"."BAL_DD" = :lstr_jpra.publdd ) AND  
//         		( "KFZ15OT0"."UPMU_GU" = :lstr_jpra.jonpoyno2 ) AND  
//         		( "KFZ15OT0"."JUN_NO" = :lstr_jpra.jonpoyno1 ) AND  
//         		( "KFZ15OT0"."LIN_NO" = :lstr_jpra.sortno )   ;
//			IF SQLCA.SQLCODE =0 THEN
//			ELSE		
//				MessageBox("확  인","접대비 번호를 찾을 수 없습니다.!!!")
//				Return
//			END IF		
//	END IF
//ELSE
//	SELECT MAX("KFZ15OT0"."SEQ_NO")
//    	INTO :get_jub_no  
//    	FROM "KFZ15OT0"  
//    	WHERE "KFZ15OT0"."BAL_YY" = :lstr_jpra.publyy ;
//	IF SQLCA.SQLCODE =0 THEN
//		IF IsNull(get_jub_no) OR get_jub_no =0 THEN
//			get_jub_no =1
//		ELSE	
//			get_jub_no =get_jub_no + 1
//		END IF
//	END IF
//	CHK =get_jub_no
//	SELECT "KFZ15OT0"."SEQ_NO"  
//   	INTO :ll_jub_no  
//   	FROM "KFZ15OT0"  
//   	WHERE ( "KFZ15OT0"."BIL_YY" = :ls_bil_yy ) AND  
//         	( "KFZ15OT0"."BIL_MM" = :ls_bil_mm ) AND  
//         	( "KFZ15OT0"."BIL_DD" = :ls_bil_dd ) AND  
//         	( "KFZ15OT0"."SEQ_NO" = :get_jub_no )   ;
//	IF SQLCA.SQLCODE =0 THEN
//		MessageBox("확인","영수증일자,접대번호가 중복됩니다.!!!")
//		dw_1.SetColumn("bil_yy")
//		dw_1.SetFocus()
//		Return	
//	ELSE
//		INSERT INTO "KFZ15OT0"  
//         	(  "BIL_YY",   
//           		"BIL_MM",   
//           		"BIL_DD",   
//           		"SEQ_NO",
//					"BAL_YY")  
//  		VALUES ( :ls_bil_yy,   
//           		:ls_bil_mm,   
//           		:ls_bil_dd,   
//           		:get_jub_no,
//					:lstr_jpra.publyy);
//		IF SQLCA.SQLCODE <> 0 THEN
//			MessageBox("확 인","접대비 번호 채번을 실패했습니다.!!!")
//			ROLLBACK;
//			dw_1.SetColumn("seq_no")	
//			dw_1.SetFocus()
//			Return
//		END IF		
//	END IF
//END IF
//
//IF  ldb_jub_amt <= 0  or IsNull(ldb_jub_amt) THEN
//  MessageBox("확인", "접대금액을 확인하십시오")
//	cb_2.TriggerEvent("ue_jubno_cancel")
//	dw_1.SetColumn("jub_amt")
//	dw_1.SetFocus()
//  Return
//END IF
//
//IF ldb_jub_amt > lstr_jpra.money THEN
//	MessageBox("확 인","접대금액이 전표 입력 금액보다 큽니다.!!!")
//	cb_2.TriggerEvent("ue_jubno_cancel")
//	dw_1.SetColumn("jub_amt")
//	dw_1.SetFocus()
//	Return
//END IF
//
//IF ldb_jub_amt < ldb_bon_amt THEN
//	MessageBox("확  인","봉사료가 접대금액보다 큽니다.!!!")
//	cb_2.TriggerEvent("ue_jubno_cancel")
//	dw_1.SetColumn("bon_amt")
//	dw_1.SetFocus()
//	Return
//END IF	
//IF ls_jub_gu = "" or IsNull(ls_jub_gu) THEN
//   MessageBox("확인", "접대비구분을 확인하십시오")
//	cb_2.TriggerEvent("ue_jubno_cancel")
//	dw_1.SetColumn("jub_gu")
//	dw_1.SetFocus()
//   Return
//END IF
//
//IF ls_jub_gu = "2" THEN         //신용카드입력시 CHECK//
//  IF ls_card_no = "" or IsNull(ls_card_no) THEN
//    MessageBox("확인", "카드번호를 확인하십시오")
//	cb_2.TriggerEvent("ue_jubno_cancel")
//	dw_3.SetColumn("kfz15ot0_card_no")
//	dw_3.SetFocus()
//    Return
//  END IF
//
//  IF ls_jun_nm = "" or IsNull(ls_jun_nm) THEN
//    MessageBox("확인", "회원명을 입력하십시오")
//	cb_2.TriggerEvent("ue_jubno_cancel")
//	dw_3.SetColumn("kfz05om0_owner")
//	dw_3.SetFocus()
//    Return
//  END IF
//  
//  IF ls_jub_owner = "" or IsNull(ls_jub_owner) THEN
//    MessageBox("확인", "카드종류를 확인하십시오")
//	cb_2.TriggerEvent("ue_jubno_cancel")
//	dw_3.SetColumn("kfz15ot0_jub_owner")
//	dw_3.SetFocus()
//    Return
//  ELSE
//    SELECT "VNDMST"."VNDMST_CVCOD"  
//    	INTO :MYSQL1  
//    	FROM "VNDMST"  
//   	WHERE ( "VNDMST"."VNDMST_CVCOD" = :ls_jub_owner ) AND  
//         	( "VNDMST"."VNDMST_CVGU" = '6' )   ;
//
//    IF SQLCA.SQLCODE <> 0  THEN
//      MessageBox("확인", "카드종류를 확인하십시오")
//		cb_2.TriggerEvent("ue_jubno_cancel")
//		dw_3.SetColumn("kfz15ot0_jub_owner")
//		dw_3.SetFocus()
//    	RETURN
//    END IF
//  END IF
//
//  IF ls_jub_cno = "" or IsNull(ls_jub_cno) THEN
////    MessageBox("확인", "사업자번호 또는 주민등록번호를 입력하십시오")
////		cb_2.TriggerEvent("ue_jubno_cancel")
////		dw_3.SetColumn("kfz15ot0_jub_cno")
////		dw_3.SetFocus()
////    Return
//  ELSE
//  END IF  
//
//
//ELSE                          //신용카드이외 입력시 CHECK //
// IF ls_jub_gu = "1" THEN     //고액현금일때//
////  IF ls_jub_cnm1 = "" or IsNull(ls_jub_cnm1) THEN
////    	MessageBox("확인", "업소명을 입력하십시오")
////		cb_2.TriggerEvent("ue_jubno_cancel")
////		dw_2.SetColumn("jub_cnm1")
////		dw_2.SetFocus()
////    	Return
////  END IF
//
////  IF ls_jub_owner = "" or IsNull(ls_jub_owner) THEN
////    MessageBox("확인", "대표자명을 입력하십시오")
////		cb_2.TriggerEvent("ue_jubno_cancel")
////		dw_2.SetColumn("jub_owner")
////		dw_2.SetFocus()
////    Return
////  END IF
//
//  IF ls_jub_adr1 = "" or IsNull(ls_jub_adr1) THEN
////    MessageBox("확인", "업소주소를 입력하십시오")
////	 dw_2.SetColumn("jub_adr1")
////	 dw_2.SetFocus()
////    Return
//  END IF
//
//  IF ls_jub_cno = "" or IsNull(ls_jub_cno) THEN
////     MessageBox("확인", "사업자번호 또는 주민등록번호를 입력하십시오")
////		cb_2.TriggerEvent("ue_jubno_cancel")
////		dw_2.SetColumn("jub_cno")
////		dw_2.SetFocus()
////    Return
//  END IF
//
//  END IF    
//END IF
//
//IF ls_jub_gu = "2" THEN  //**카드시
//  UPDATE "KFZ15OT0"  
//  SET "JUN_NM"    = :ls_jun_nm,
//		"JUB_CUS"   = :ls_jub_cus,
//		"JUB_GU"    = :ls_jub_gu,
//		"CARD_NO"	= :ls_card_no,                          
//		"JUB_CNO" 	=:ls_jub_cno,
//		"JUB_OWNER" =:ls_jub_owner,                          
//      "JUB_AMT" 	= :ldb_jub_amt,
//		"BON_AMT" 	= :ldb_bon_amt,
//		"SAUPJ"		= :lstr_jpra.saupjang,                          
//      "BAL_MM"		=:lstr_jpra.publmm,
//		"BAL_DD"		=:lstr_jpra.publdd,              
//      "UPMU_GU" 	= :lstr_jpra.jonpoyno2,
//		"JUN_NO"		=:lstr_jpra.jonpoyno1,
//		"LIN_NO"		=:ll_sortno              
//   WHERE ( "KFZ15OT0"."BIL_YY" = :ls_bil_yy ) AND  
//         ( "KFZ15OT0"."BIL_MM" = :ls_bil_mm ) AND  
//         ( "KFZ15OT0"."BIL_DD" = :ls_bil_dd ) AND  
//         ( "KFZ15OT0"."SEQ_NO" = :get_jub_no )   ;
//ELSE
//  UPDATE "KFZ15OT0"  
//  SET "JUB_CUS"  = :ls_jub_cus,"JUB_GU" = :ls_jub_gu,"JUB_CNM1"= :ls_jub_cnm1,                          
//      "JUB_CNM2" =:ls_jub_cnm2,"JUB_CNO" 	=:ls_jub_cno,"JUB_OWNER"=:ls_jub_owner, 
//		"JUB_ADR1" =:ls_jub_adr1,"JUB_ADR2" =:ls_jub_adr2,                         
//      "JUB_AMT" = :ldb_jub_amt,"BON_AMT" = :ldb_bon_amt,"SAUPJ"= :lstr_jpra.saupjang,                          
//      "BAL_YY"=:lstr_jpra.publyy,"BAL_MM"=:lstr_jpra.publmm,"BAL_DD"=:lstr_jpra.publdd,              
//      "UPMU_GU" = :lstr_jpra.jonpoyno2,"JUN_NO"=:lstr_jpra.jonpoyno1,"LIN_NO"=:ll_sortno              
//   WHERE ( "KFZ15OT0"."BIL_YY" = :ls_bil_yy ) AND  
//         ( "KFZ15OT0"."BIL_MM" = :ls_bil_mm ) AND  
//         ( "KFZ15OT0"."BIL_DD" = :ls_bil_dd ) AND  
//         ( "KFZ15OT0"."SEQ_NO" = :get_jub_no )   ;
//END IF
//IF SQLCA.SQLCODE <> 0 THEN
//	MessageBox("확인","접대비 저장 처리를 실패했습니다.!!!")
//	cb_2.TriggerEvent("ue_jubno_cancel")
//	ROLLBACK;
//	Return
//END IF
//lstr_jpra.flag_jupdae = "Y"
//gl_yymm =""
//close(parent)
//
//
//
end event

type rr_1 from roundrectangle within w_kglb01a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 216
integer width = 1298
integer height = 1928
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kglb01a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1358
integer y = 216
integer width = 1792
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

