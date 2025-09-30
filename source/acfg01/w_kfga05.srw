$PBExportHeader$w_kfga05.srw
$PBExportComments$재무분석자료 수정
forward
global type w_kfga05 from w_inherite
end type
type rr_1 from roundrectangle within w_kfga05
end type
type dw_update from u_d_popup_sort within w_kfga05
end type
type st_2 from statictext within w_kfga05
end type
type em_year from editmask within w_kfga05
end type
type em_from from editmask within w_kfga05
end type
type st_3 from statictext within w_kfga05
end type
type st_4 from statictext within w_kfga05
end type
type ln_1 from line within w_kfga05
end type
type ln_2 from line within w_kfga05
end type
type ln_3 from line within w_kfga05
end type
type em_to from editmask within w_kfga05
end type
type rr_2 from roundrectangle within w_kfga05
end type
end forward

global type w_kfga05 from w_inherite
string title = "재무제표분석자료 수정"
rr_1 rr_1
dw_update dw_update
st_2 st_2
em_year em_year
em_from em_from
st_3 st_3
st_4 st_4
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
em_to em_to
rr_2 rr_2
end type
global w_kfga05 w_kfga05

type variables
String    LsFromYm,LsToYm
Integer  LiD_Ses

end variables

forward prototypes
public function integer wf_requiredchk (integer ll_row)
public function integer wf_dup_chk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer ll_row);String  sAcCd

LiD_Ses   = Integer(Trim(em_year.text))
LsFromYm  = Left(Trim(em_from.text),4) + Right(Trim(em_from.text),2)
LsToYm    = Left(Trim(em_to.text),4) + Right(Trim(em_to.text),2)
IF Lid_Ses = 0 OR IsNull(Lid_Ses) THEN
	F_MessageChk(1,'[회기]')
	em_year.SetFocus()
	Return -1
END IF
IF LsFromYm = "" OR IsNull(LsFromYm) THEN
	F_MessageChk(1,'[시작년월]')
	em_from.SetFocus()
	Return -1	
END IF
IF LsToYm = "" OR IsNull(LsToYm) THEN
	F_MessageChk(1,'[종료년월]')
	em_to.SetFocus()
	Return -1
END IF

dw_update.AcceptText()
sAcCd = dw_update.GetItemString(ll_row,"accd") 

IF sAcCd ="" OR IsNull(sAcCd) THEN
	F_MessageChk(1,'[분석코드]')
	dw_update.SetColumn("accd")
	dw_update.SetFocus()
	Return -1
END IF

Return 1
end function

public function integer wf_dup_chk (integer ll_row);String  sAcCd
Integer iReturnRow

dw_update.AcceptText()
sAcCd = dw_update.GetItemString(ll_row,"accd") 

IF sAcCd ="" OR IsNull(sAcCd)   THEN RETURN 1

iReturnRow = dw_update.find("accd ='" + sAcCd + "'", 1, dw_update.RowCount())

IF (ll_row <> iReturnRow) and (iReturnRow <> 0) THEN
	f_MessageChk(10,'[분석코드]')
	RETURN  -1
END IF
	
Return 1
end function

on w_kfga05.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_update=create dw_update
this.st_2=create st_2
this.em_year=create em_year
this.em_from=create em_from
this.st_3=create st_3
this.st_4=create st_4
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.em_to=create em_to
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_update
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_year
this.Control[iCurrent+5]=this.em_from
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.ln_1
this.Control[iCurrent+9]=this.ln_2
this.Control[iCurrent+10]=this.ln_3
this.Control[iCurrent+11]=this.em_to
this.Control[iCurrent+12]=this.rr_2
end on

on w_kfga05.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_update)
destroy(this.st_2)
destroy(this.em_year)
destroy(this.em_from)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.em_to)
destroy(this.rr_2)
end on

event open;call super::open;dw_update.SetTransObject(SQLCA)
dw_update.Reset()

Integer iD_Ses
String  sFromYm,sToYm,sCurYm,sMaxData

SELECT Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT" 
	INTO :sMaxData 
   FROM "KFZ09DAT" 
   WHERE Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT" = 
				(SELECT MAX(Ltrim(TO_CHAR("ACYEAR",'000'))||"ACYMF"||"ACYMT")
					FROM "KFZ09DAT" );							
IF SQLCA.SQLCODE <> 0 THEN
	sCurYm = Left(F_Today(),6)
	
	SELECT "D_SES",   "DYM01",   	"DYM12"  
		INTO :iD_Ses,	:sFromYm,	:sToYm   
		FROM "KFZ08OM0" ;	
ELSE
	iD_Ses  = Integer(Left(sMaxData,3))
	sFromYm = Mid(sMaxData,4,6)
	sToYm   = Right(sMaxData,6)
END IF

em_year.text = String(iD_Ses)
em_from.text = String(sFromYm,'@@@@.@@')
em_to.text   = String(sToYm,'@@@@.@@')

p_inq.SetFocus()

p_ins.Enabled =False

w_mdi_frame.sle_msg.text =""

ib_any_typing =False
end event

type dw_insert from w_inherite`dw_insert within w_kfga05
boolean visible = false
integer x = 41
integer y = 3148
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfga05
boolean visible = false
integer x = 3392
integer y = 3112
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfga05
boolean visible = false
integer x = 3218
integer y = 3112
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfga05
boolean visible = false
integer x = 2523
integer y = 3112
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfga05
integer x = 3749
integer taborder = 50
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue,iRowCount

w_mdi_frame.sle_msg.text =""

iRowCount = dw_update.RowCount()

IF iRowCount > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_update.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
	
	iRowCount = 0
END IF

IF iFunctionValue = 1 THEN
	iCurRow = iRowCount + 1
	
	dw_update.InsertRow(iCurRow)

	dw_update.ScrollToRow(iCurRow)
	dw_update.SetItem(iCurRow,'sflag',   'I')
	dw_update.SetItem(iCurRow,'acyear',  Lid_Ses)
	dw_update.SetItem(iCurRow,'acymf',   LsFromYm)
	dw_update.SetItem(iCurRow,'acymt',   LsToYm)
	
	dw_update.SetColumn("accd")
	dw_update.SetFocus()
	
	ib_any_typing =False

END IF

IF dw_update.RowCount() <=0 THEN
	p_ins.Enabled = False
ELSE
	p_ins.Enabled = True
END IF


end event

type p_exit from w_inherite`p_exit within w_kfga05
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_kfga05
integer taborder = 90
end type

event p_can::clicked;call super::clicked;
p_inq.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text =""

ib_any_typing =False

end event

type p_print from w_inherite`p_print within w_kfga05
boolean visible = false
integer x = 2697
integer y = 3112
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfga05
integer x = 3575
integer taborder = 40
end type

event p_inq::clicked;call super::clicked;
LiD_Ses   = Integer(Trim(em_year.text))
LsFromYm  = Left(Trim(em_from.text),4) + Right(Trim(em_from.text),2)
LsToYm    = Left(Trim(em_to.text),4) + Right(Trim(em_to.text),2)
IF Lid_Ses = 0 OR IsNull(Lid_Ses) THEN
	F_MessageChk(1,'[회기]')
	em_year.SetFocus()
	Return	
END IF
IF LsFromYm = "" OR IsNull(LsFromYm) THEN
	F_MessageChk(1,'[시작년월]')
	em_from.SetFocus()
	Return	
END IF
IF LsToYm = "" OR IsNull(LsToYm) THEN
	F_MessageChk(1,'[종료년월]')
	em_to.SetFocus()
	Return	
END IF

IF dw_update.Retrieve(LiD_Ses,LsFromYm,LsToYm) <=0 THEN
	F_MessageChk(14,'')
	p_ins.TriggerEvent(Clicked!)
END IF

p_ins.Enabled =True


end event

type p_del from w_inherite`p_del within w_kfga05
integer taborder = 80
end type

event p_del::clicked;call super::clicked;Integer k

IF dw_update.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_update.DeleteRow(dw_update.GetRow())
IF dw_update.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_update.RowCount()
		dw_update.SetItem(k,'sflag','M')
	NEXT
	
	dw_update.SetColumn("acvalue")
	dw_update.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_kfga05
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_update.AcceptText() = -1 THEN Return

IF dw_update.RowCount() > 0 THEN
	FOR k = 1 TO dw_update.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_update.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_update.RowCount()
		dw_update.SetItem(k,'sflag','M')
	NEXT

	dw_update.SetColumn("acvalue")
	dw_update.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

IF dw_update.RowCount() <=0 THEN
	p_ins.Enabled = False
ELSE
	p_ins.Enabled = True
END IF


end event

type cb_exit from w_inherite`cb_exit within w_kfga05
boolean visible = false
integer x = 3227
integer y = 2804
end type

type cb_mod from w_inherite`cb_mod within w_kfga05
boolean visible = false
integer x = 2158
integer y = 2808
integer width = 338
end type

type cb_ins from w_inherite`cb_ins within w_kfga05
boolean visible = false
integer x = 416
integer y = 2784
integer width = 338
integer height = 104
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_kfga05
boolean visible = false
integer x = 2519
integer y = 2808
end type

type cb_inq from w_inherite`cb_inq within w_kfga05
boolean visible = false
integer x = 59
integer y = 2784
integer width = 338
end type

type cb_print from w_inherite`cb_print within w_kfga05
boolean visible = false
integer x = 2016
integer y = 2588
end type

type st_1 from w_inherite`st_1 within w_kfga05
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kfga05
boolean visible = false
integer x = 2875
integer y = 2804
end type

type cb_search from w_inherite`cb_search within w_kfga05
boolean visible = false
integer x = 1234
integer y = 2592
integer width = 750
string text = "재무분석코드 출력(&P)"
end type

type dw_datetime from w_inherite`dw_datetime within w_kfga05
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfga05
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfga05
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfga05
boolean visible = false
integer x = 27
integer y = 2728
end type

type gb_button2 from w_inherite`gb_button2 within w_kfga05
boolean visible = false
integer x = 2117
integer y = 2748
end type

type rr_1 from roundrectangle within w_kfga05
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 69
integer y = 24
integer width = 1175
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_update from u_d_popup_sort within w_kfga05
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 87
integer y = 192
integer width = 4517
integer height = 2076
integer taborder = 60
string dataobject = "d_kfga051"
boolean vscrollbar = true
boolean border = false
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event clicked;If Row <= 0 then
	lstr_jpra.rowsflag ='2'
ELSE
	lstr_jpra.rowsflag ='1'
	Return 
END IF

call super ::clicked
end event

event editchanged;ib_any_typing =True
end event

event itemerror;
Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;this.SetRowFocusIndiCator(Hand!)
end event

event itemchanged;String sAcCd,sacname,snull

SetNull(snull)

sle_msg.text =""

IF this.GetColumnName() ="accd" THEN
	sAcCd = This.GetText()
	IF sAcCd = "" OR IsNull(sAcCd) THEN Return
	
	SELECT "KFZ09CDM"."ACCD_NM"     	INTO :sacname  
    	FROM "KFZ09CDM"  
   	WHERE "KFZ09CDM"."ACCD" = :sAcCd ;
	IF SQLCA.SQLCODE <> 0 THEN
		F_MessageChk(20,'[재무분석코드]')
		dw_update.SetItem(this.GetRow(),"accd",snull)
		dw_update.SetItem(this.GetRow(),"accd_nm",snull)
		dw_update.SetColumn("accd")
		Return 1
	ELSE
		dw_update.SetItem(this.GetRow(),"accd_nm",sacname)
	END IF
	
	IF Wf_Dup_Chk(this.GetRow()) = -1 THEN 
		this.SetItem(this.GetRow(),"accd",snull)
		RETURN 1
	END IF
END IF

end event

event rbuttondown;this.accepttext()

SetNull(gs_code)
Setnull(gs_codename)

IF this.GetColumnName() ="accd" THEN
	
	gs_code = this.object.accd[getrow()]
	
	OPEN(W_KFGA02_POPUP)

	IF IsNull(gs_code) THEN RETURN
	
	dw_update.SetItem(this.GetRow(),"accd",gs_code)
	dw_update.SetItem(this.GetRow(),"accd_nm",gs_codename)
	ib_any_typing =True
END IF
end event

event retrieverow;IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

type st_2 from statictext within w_kfga05
integer x = 119
integer y = 76
integer width = 174
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "회기"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_year from editmask within w_kfga05
integer x = 274
integer y = 72
integer width = 215
integer height = 64
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
alignment alignment = center!
string mask = "##0"
end type

event modified;Integer  iD_Ses
String   sFromYm,sToYm

iD_Ses = Integer(Trim(em_year.text))
IF iD_Ses <> 0 AND Not IsNull(iD_Ses) THEN
	SELECT "DYM01",   	"DYM12"  		INTO :sFromYm,	:sToYm   
		FROM "KFZ08OM0"  
		WHERE "KFZ08OM0"."D_SES" = :iD_Ses;
		
	em_from.text = String(sFromYm,'@@@@.@@')
	em_to.text = String(sToYm,'@@@@.@@')
	
	em_from.SetFocus()
	
	dw_update.Reset()
END IF
end event

type em_from from editmask within w_kfga05
integer x = 507
integer y = 72
integer width = 302
integer height = 64
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
boolean autoskip = true
end type

event modified;dw_update.Reset()
end event

type st_3 from statictext within w_kfga05
integer x = 818
integer y = 72
integer width = 46
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_kfga05
integer x = 119
integer y = 100
integer width = 46
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "*"
boolean focusrectangle = false
end type

type ln_1 from line within w_kfga05
integer linethickness = 1
integer beginx = 279
integer beginy = 136
integer endx = 485
integer endy = 136
end type

type ln_2 from line within w_kfga05
integer linethickness = 1
integer beginx = 512
integer beginy = 136
integer endx = 809
integer endy = 136
end type

type ln_3 from line within w_kfga05
integer linethickness = 1
integer beginx = 878
integer beginy = 136
integer endx = 1175
integer endy = 136
end type

type em_to from editmask within w_kfga05
integer x = 873
integer y = 72
integer width = 302
integer height = 64
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
boolean autoskip = true
end type

event modified;dw_update.Reset()
end event

type rr_2 from roundrectangle within w_kfga05
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 180
integer width = 4544
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

