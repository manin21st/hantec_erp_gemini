$PBExportHeader$w_cia00400.srw
$PBExportComments$원가수불부 수정
forward
global type w_cia00400 from w_inherite
end type
type dw_list from datawindow within w_cia00400
end type
type gb_4 from groupbox within w_cia00400
end type
type dw_1 from datawindow within w_cia00400
end type
type rr_1 from roundrectangle within w_cia00400
end type
end forward

global type w_cia00400 from w_inherite
string title = "원가수불부 수정"
event ue_seek pbm_custom01
dw_list dw_list
gb_4 gb_4
dw_1 dw_1
rr_1 rr_1
end type
global w_cia00400 w_cia00400

type variables
Boolean itemerr =False
String     LsIttyp
end variables

forward prototypes
public function integer wf_dup_chk (integer ll_row)
public function integer wf_requiredchk (integer ll_row)
end prototypes

event ue_seek;integer ipoint


dw_list.object.datawindow.print.preview = "no"

dw_list.object.datawindow.horizontalscrollsplit			=	0
dw_list.object.datawindow.horizontalscrollposition2	= 	0
openwithparm(w_seek, dw_list)
//dw_list.object.datawindow.horizontalscrollsplit			=	ipoint
//dw_list.object.datawindow.horizontalscrollposition2	= 	ipoint

end event

public function integer wf_dup_chk (integer ll_row);String  sIoYm,sItnbr
Integer iReturnRow

dw_1.AcceptText()
sIoYm = Trim(dw_1.GetItemString(1,"io_ym"))

dw_list.AcceptText()
sItnbr = dw_list.GetItemString(ll_row,"itnbr")

IF sIoYm  ="" OR IsNull(sIoYm)  THEN RETURN 1
IF sItnbr ="" OR IsNull(sItnbr) THEN RETURN 1

IF LsIttyp = '%' THEN
	iReturnRow = dw_list.find("io_yymm ='" + sIoYm + "' and itnbr = '" + sItnbr + "'", 1, dw_list.RowCount())
ELSE
	iReturnRow = dw_list.find("io_yymm ='" + sIoYm + "' and itnbr = '" + sItnbr + "' and itemas_ittyp = '" + LsIttyp + "'", 1, dw_list.RowCount())	
END IF

IF (ll_row <> iReturnRow) and (iReturnRow <> 0) THEN
	f_MessageChk(10,'[품번]')
	RETURN  -1
END IF
	
Return 1
end function

public function integer wf_requiredchk (integer ll_row);String sItnbr,sIoYm

dw_list.AcceptText()
sIoYm  = dw_list.GetItemString(ll_row,"io_yymm")
sItnbr = dw_list.GetItemString(ll_row,"itnbr")

IF sIoYm = "" OR IsNull(sIoYm) THEN
	f_messagechk(1,'[원가계산년월]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return -1
END IF
IF sItnbr = "" OR IsNull(sItnbr) THEN
	f_messagechk(1,'[품번]')
	dw_list.SetColumn("itnbr")
	dw_list.SetFocus()
	Return -1
END IF
Return 1
end function

on w_cia00400.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.gb_4=create gb_4
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_cia00400.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.gb_4)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetItem(1,"io_ym",Left(F_Today(),6))
dw_1.SetItem(1,"io_ymt",Left(F_Today(),6))
dw_1.SetFocus()

dw_list.SetTransObject(SQLCA)
dw_list.Reset()

end event

type dw_insert from w_inherite`dw_insert within w_cia00400
boolean visible = false
integer x = 69
integer y = 2584
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cia00400
boolean visible = false
integer x = 3785
integer y = 2876
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_cia00400
boolean visible = false
integer x = 3611
integer y = 2876
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_cia00400
boolean visible = false
integer x = 2917
integer y = 2876
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_cia00400
boolean visible = false
integer x = 4032
integer y = 2716
integer taborder = 0
end type

event p_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue
String   sYm

sle_msg.text =""

IF dw_1.AcceptText() = -1 THEN RETURN
sYm = Trim(dw_1.GetItemString(1,"io_ym"))
IF sYm = "" OR IsNull(sYm) THEN
	F_MessageChk(1,'[원가계산년월]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return
END IF

IF dw_list.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_list.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_list.InsertRow(0)

	dw_list.ScrollToRow(iCurRow)
	dw_list.SetItem(iCurRow,'io_yymm',sYm)
	dw_list.SetItem(iCurRow,'sflag','I')
	dw_list.SetColumn("itnbr")
	dw_list.SetFocus()
	
	ib_any_typing =False

END IF

end event

type p_exit from w_inherite`p_exit within w_cia00400
integer x = 4434
integer y = 0
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_cia00400
integer x = 4261
integer y = 0
integer taborder = 50
end type

event p_can::clicked;call super::clicked;String sIttyp,sIoYm,sItnbr

w_mdi_frame.sle_msg.text =""

dw_list.Reset()

ib_any_typing =False


end event

type p_print from w_inherite`p_print within w_cia00400
boolean visible = false
integer x = 3090
integer y = 2876
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cia00400
integer x = 3913
integer y = 0
end type

event p_inq::clicked;String sYm, lsitnbr,sSaup,sYmt

IF dw_1.Accepttext() = -1 THEN RETURN

sYm    = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ym"))
sYmt    = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ymt"))
sSaup  = Trim(dw_1.GetItemString(dw_1.GetRow(),"csaup"))
lsIttyp = dw_1.GetItemString(dw_1.GetRow(),"ittyp")
lsitnbr = dw_1.GetItemString(dw_1.GetRow(),"itnbr")

IF sYm = "" OR IsNull(sYm) THEN
	f_MessageChk(1,'[원가년월]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return
END IF
IF sYmt = "" OR IsNull(sYmt) THEN
	f_MessageChk(1,'[원가년월]')
	dw_1.SetColumn("io_ymt")
	dw_1.SetFocus()
	Return
END IF
IF sSaup = "" OR IsNull(sSaup) THEN
	f_MessageChk(1,'[사업부]')
	dw_1.SetColumn("csaup")
	dw_1.SetFocus()
	Return
END IF
IF lsIttyp = "" OR IsNull(lsIttyp) THEN
	f_MessageChk(1,'[품목구분]')
	dw_1.SetColumn("ittyp")
	dw_1.SetFocus()
	Return
END IF
IF lsItnbr = "" OR IsNull(LsItnbr) THEN LsItnbr = '%'

w_mdi_frame.sle_msg.Text = '조회 중...'

SetPointer(HourGlass!)
dw_list.SetRedraw(False)
IF dw_list.Retrieve(sSaup,sYm,sYmt,LsIttyp,lsitnbr) <=0 THEN
	F_MESSAGECHK(14,"")
	dw_1.SetFocus()
	dw_list.SetRedraw(True)
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return
ELSE
	dw_list.SetColumn("iwol_qty")
	dw_list.SetFocus()
END IF
dw_list.SetRedraw(True)

w_mdi_frame.sle_msg.text = '조회 완료'
SetPointer(Arrow!)
end event

type p_del from w_inherite`p_del within w_cia00400
boolean visible = false
integer x = 4210
integer y = 2712
integer taborder = 0
end type

event p_del::clicked;call super::clicked;Integer k

IF dw_list.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF dw_list.GetItemNumber(dw_list.GetRow(),"sum_gita") = 0 OR IsNull(dw_list.GetItemNumber(dw_list.GetRow(),"sum_gita")) THEN
	IF F_DbConFirm('삭제') = 2 THEN RETURN
ELSE
	IF MessageBox("확 인","선택하신 자료에 이월 이외의 자료(입고,출고,재고)가 존재합니다.~r"+&
								 "삭제하시겠습니까?",Question!,YesNo!,2) = 2 THEN Return
END IF

dw_list.DeleteRow(0)
IF dw_list.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_list.RowCount()
		dw_list.SetItem(k,'sflag','M')
	NEXT
	
	dw_list.SetColumn("iwol_qty")
	dw_list.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_mod from w_inherite`p_mod within w_cia00400
integer x = 4087
integer y = 0
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_list.AcceptText() = -1 THEN Return

IF dw_list.RowCount() > 0 THEN
	FOR k = 1 TO dw_list.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_list.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_list.RowCount()
		dw_list.SetItem(k,'sflag','M')
	NEXT

	dw_list.SetColumn("iwol_qty")
	dw_list.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_exit from w_inherite`cb_exit within w_cia00400
boolean visible = false
integer x = 2930
integer y = 2688
end type

type cb_mod from w_inherite`cb_mod within w_cia00400
boolean visible = false
integer x = 2103
integer y = 2688
end type

event cb_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_list.AcceptText() = -1 THEN Return

IF dw_list.RowCount() > 0 THEN
	FOR k = 1 TO dw_list.RowCount()
		iRtnValue = Wf_RequiredChk(k)
		IF iRtnValue = -1 THEN RETURN
	NEXT
ELSE
	Return
END IF

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_list.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_list.RowCount()
		dw_list.SetItem(k,'sflag','M')
	NEXT

	dw_list.SetColumn("iwol_qty")
	dw_list.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_ins from w_inherite`cb_ins within w_cia00400
boolean visible = false
integer x = 407
integer y = 2688
end type

event cb_ins::clicked;call super::clicked;Integer  iCurRow,iFunctionValue
String   sYm

sle_msg.text =""

IF dw_1.AcceptText() = -1 THEN RETURN
sYm = Trim(dw_1.GetItemString(1,"io_ym"))
IF sYm = "" OR IsNull(sYm) THEN
	F_MessageChk(1,'[원가계산년월]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return
END IF

IF dw_list.RowCount() > 0 THEN
	iFunctionValue = Wf_RequiredChk(dw_list.GetRow())
	IF iFunctionValue <> 1 THEN RETURN
ELSE
	iFunctionValue = 1	
END IF

IF iFunctionValue = 1 THEN
	iCurRow = dw_list.InsertRow(0)

	dw_list.ScrollToRow(iCurRow)
	dw_list.SetItem(iCurRow,'io_yymm',sYm)
	dw_list.SetItem(iCurRow,'sflag','I')
	dw_list.SetColumn("itnbr")
	dw_list.SetFocus()
	
	ib_any_typing =False

END IF

end event

type cb_del from w_inherite`cb_del within w_cia00400
boolean visible = false
integer x = 2455
integer y = 2688
end type

event cb_del::clicked;call super::clicked;Integer k

IF dw_list.GetRow() <= 0 THEN
	f_messagechk(11,'')
	Return
END IF

IF dw_list.GetItemNumber(dw_list.GetRow(),"sum_gita") = 0 OR IsNull(dw_list.GetItemNumber(dw_list.GetRow(),"sum_gita")) THEN
	IF F_DbConFirm('삭제') = 2 THEN RETURN
ELSE
	IF MessageBox("확 인","선택하신 자료에 이월 이외의 자료(입고,출고,재고)가 존재합니다.~r"+&
								 "삭제하시겠습니까?",Question!,YesNo!,2) = 2 THEN Return
END IF

dw_list.DeleteRow(0)
IF dw_list.Update() = 1 THEN
	commit;
	
	FOR k = 1 TO dw_list.RowCount()
		dw_list.SetItem(k,'sflag','M')
	NEXT
	
	dw_list.SetColumn("iwol_qty")
	dw_list.SetFocus()
	
	ib_any_typing = False
	sle_msg.text ="자료가 삭제되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type cb_inq from w_inherite`cb_inq within w_cia00400
boolean visible = false
integer x = 46
integer y = 2688
end type

event cb_inq::clicked;call super::clicked;String sYm, lsitnbr

IF dw_1.Accepttext() = -1 THEN RETURN

sYm    = Trim(dw_1.GetItemString(dw_1.GetRow(),"io_ym"))
lsIttyp = dw_1.GetItemString(dw_1.GetRow(),"ittyp")
lsitnbr = dw_1.GetItemString(dw_1.GetRow(),"itnbr")

IF sYm = "" OR IsNull(sYm) THEN
	f_MessageChk(1,'[원가계산년월]')
	dw_1.SetColumn("io_ym")
	dw_1.SetFocus()
	Return
END IF

IF lsIttyp = "" OR IsNull(LsIttyp) THEN LsIttyp = '%'
IF lsItnbr = "" OR IsNull(LsItnbr) THEN LsItnbr = '%'

sle_msg.Text = '조회 중...'
SetPointer(HourGlass!)
dw_list.SetRedraw(False)
IF dw_list.Retrieve(sYm,LsIttyp,lsitnbr) <=0 THEN
	F_MESSAGECHK(14,"")
	dw_1.SetFocus()
	dw_list.SetRedraw(True)
	sle_msg.text = ''
	SetPointer(Arrow!)
	Return
ELSE
	dw_list.SetColumn("iwol_qty")
	dw_list.SetFocus()
END IF
dw_list.SetRedraw(True)

sle_msg.text = '조회 완료'
SetPointer(Arrow!)
end event

type cb_print from w_inherite`cb_print within w_cia00400
boolean visible = false
integer x = 1701
integer y = 2744
end type

type st_1 from w_inherite`st_1 within w_cia00400
integer width = 293
end type

type cb_can from w_inherite`cb_can within w_cia00400
boolean visible = false
integer x = 2811
integer y = 2688
end type

event cb_can::clicked;call super::clicked;String sIttyp,sIoYm,sItnbr

sle_msg.text =""
sIoYm  = Trim(dw_1.GetItemString(1,"io_ym"))
sIttyp = dw_1.GetItemString(1,"ittyp")
sItnbr = dw_1.GetItemString(1,"itnbr")

IF sIttyp = "" OR IsNull(sIttyp) THEN sIttyp = '%'
IF sItnbr = "" OR IsNull(sItnbr) THEN sItnbr = '%'

dw_list.SetRedraw(False)
IF dw_list.Retrieve(sIoYm,sIttyp,sItnbr) > 0 THEN
	dw_list.ScrollToRow(1)
	dw_list.SetColumn("iwol_qty")
	dw_list.SetFocus()
ELSE
	cb_ins.SetFocus()
END IF
dw_list.SetRedraw(True)

ib_any_typing =False


end event

type cb_search from w_inherite`cb_search within w_cia00400
boolean visible = false
integer x = 2103
integer y = 2752
end type

type dw_datetime from w_inherite`dw_datetime within w_cia00400
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_cia00400
integer x = 329
integer width = 2533
end type

type gb_10 from w_inherite`gb_10 within w_cia00400
integer width = 3607
end type

type gb_button1 from w_inherite`gb_button1 within w_cia00400
boolean visible = false
integer x = 14
integer y = 2632
end type

type gb_button2 from w_inherite`gb_button2 within w_cia00400
boolean visible = false
integer x = 2057
integer y = 2632
end type

type dw_list from datawindow within w_cia00400
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 27
integer y = 164
integer width = 4576
integer height = 2052
integer taborder = 30
string dataobject = "dw_cia004001"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;String sItnbr,sName,sPdtGbn,sIttyp,sNull

SetNull(snull)

sle_msg.text =""
dw_list.ACCEPTtEXT()

IF this.GetColumnName() = "itnbr" THEN
   sItnbr = this.GetText()
	IF sItnbr = '' OR ISNULL(sItnbr) THEN RETURN
	
	SELECT "ITEMAS"."ITDSC","ITEMAS"."ITTYP","ITNCT"."PDTGU"
		INTO :sName, :sIttyp,	:sPdtGbn
		FROM "ITEMAS","ITNCT"  
		WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
			  "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
			  "ITEMAS"."ITNBR" = :sItnbr   ;
	IF SQLCA.SQLCODE = 0 THEN
		IF LsIttyp = '%' THEN
			this.SetITem(this.GetRow(),"itemas_itdsc",sName)
			this.SetITem(this.GetRow(),"itemas_ittyp",sIttyp)
			this.SetITem(this.GetRow(),"pdtgu",       sPdtGbn)
		ELSE
			IF LsIttyp <> sIttyp THEN
				f_messagechk(20,'[품목구분]')
				this.SetItem(this.GetRow(),"itnbr",snull)
				this.SetItem(this.GetRow(),"itemas_itdsc",snull)
				this.SetITem(this.GetRow(),"itemas_ittyp",sNull)
				this.SetITem(this.GetRow(),"pdtgu",       sNull)
				Return 1
			ELSE
				this.SetITem(this.GetRow(),"itemas_itdsc",sName)
				this.SetITem(this.GetRow(),"itemas_ittyp",sIttyp)
				this.SetITem(this.GetRow(),"pdtgu",       sPdtGbn)
			END IF
		END IF
	ELSE
		f_messagechk(20,'[품번]')
		this.SetItem(this.GetRow(),"itnbr",snull)
		this.SetItem(this.GetRow(),"itemas_itdsc",snull)
		this.SetITem(this.GetRow(),"itemas_ittyp",sNull)
		this.SetITem(this.GetRow(),"pdtgu",       sNull)
		Return 1
	END IF
	
	IF Wf_Dup_Chk(this.GetRow()) = -1 THEN 
		this.SetItem(this.GetRow(),"itnbr",snull)
		this.SetItem(this.GetRow(),"itemas_itdsc",snull)
		this.SetITem(this.GetRow(),"itemas_ittyp",sNull)
		this.SetITem(this.GetRow(),"pdtgu",       sNull)
		Return 1
	END IF	
END IF	 

// 수량, 단가 변경시 재고수량, 재고금액을 변경시켜준다//
double diwol, dip, dipt,	dti, dop,      dopt,dto, dim, &
       dmiwol, dmip, dmti, dmop, dmopt,   dmto, dmim, &
		 dliwol, dlip, dlti, dlop, dlopt,   dlto, dlim, &
		 doiwol, doip, doti, doop, doopt,	doto, doim, dprc
		 
diwol = this.GetItemDecimal(this.GetRow(),"iwol_qty")
dip   = this.GetItemDecimal(this.GetRow(),"ip_qty")
dipt   = this.GetItemDecimal(this.GetRow(),"ipt_qty")
dti   = this.GetItemDecimal(this.GetRow(),"ti_qty")
dop   = this.GetItemDecimal(this.GetRow(),"op_qty")
dopt   = this.GetItemDecimal(this.GetRow(),"opt_qty")
dto   = this.GetItemDecimal(this.GetRow(),"to_qty")

dmiwol = this.GetItemDecimal(this.GetRow(),"iwol_mat")
dmip   = this.GetItemDecimal(this.GetRow(),"ip_mat")
dmti   = this.GetItemDecimal(this.GetRow(),"ti_mat")
dmop   = this.GetItemDecimal(this.GetRow(),"op_mat")
dmopt   = this.GetItemDecimal(this.GetRow(),"opt_mat")
dmto   = this.GetItemDecimal(this.GetRow(),"to_mat")

dliwol = this.GetItemDecimal(this.GetRow(),"iwol_lab")
dlip   = this.GetItemDecimal(this.GetRow(),"ip_lab")
dlti   = this.GetItemDecimal(this.GetRow(),"ti_lab")
dlop   = this.GetItemDecimal(this.GetRow(),"op_lab")
dlopt   = this.GetItemDecimal(this.GetRow(),"opt_lab")
dlto   = this.GetItemDecimal(this.GetRow(),"to_lab")

doiwol = this.GetItemDecimal(this.GetRow(),"iwol_over")
doip   = this.GetItemDecimal(this.GetRow(),"ip_over")
doti   = this.GetItemDecimal(this.GetRow(),"ti_over")
doop   = this.GetItemDecimal(this.GetRow(),"op_over")
doopt   = this.GetItemDecimal(this.GetRow(),"opt_over")
doto   = this.GetItemDecimal(this.GetRow(),"to_over")

dim    = diwol + dip + dipt + dti - dop - dopt - dto
dmim   = dmiwol + dmip + dmti - dmop - dmopt - dmto
dlim   = dliwol + dlip + dlti - dlop - dlopt - dlto
doim   = doiwol + doip + doti - doop - doopt - doto

if dim = 0 or IsNull(dim) then
	dprc = 0
else
	dprc = round((dmim + dlim + doim) / dim,5)
end if

this.SetItem(this.GetRow(),"im_qty",dim)
this.SetItem(this.GetRow(),"im_mat",dmim)
this.SetItem(this.GetRow(),"im_lab",dlim)
this.SetItem(this.GetRow(),"im_over",doim)
this.SetItem(this.GetRow(),"im_uprc",dprc)

ib_any_typing =True
end event

event rbuttondown;
SetNull(gs_code)
SetNull(gs_codename)

if this.GetColumnName() = "itnbr" then												 /*품번*/
	open(w_itemas_popup)
	
	if gs_code = '' or isnull(gs_code) then return
	
	this.SetITem(this.GetRow(),"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
end if

ib_any_typing =True
end event

event retrieverow;
IF row > 0 THEN
	this.SetItem(row,'sflag','M')
END IF
end event

event rowfocuschanged;//this.SetRowFocusIndicator(Hand!)
end event

event retrieveend;Integer k

FOR k = 1 TO rowcount
	this.SetItem(k,'sflag','M')
NEXT
end event

event itemerror;Return 1
end event

event getfocus;this.AcceptText()
end event

type gb_4 from groupbox within w_cia00400
boolean visible = false
integer x = 14
integer y = 2960
integer width = 3598
integer height = 140
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 12632256
end type

type dw_1 from datawindow within w_cia00400
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 18
integer y = 8
integer width = 3662
integer height = 144
integer taborder = 20
string dataobject = "dw_cia004002"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String snull,sYm

SetNull(snull)

sle_msg.text =""

IF this.GetColumnName() ="io_ym" THEN
	sYm = Trim(this.GetText())
	IF sYm = "" OR IsNull(sYm) THEN RETURN
	
	IF F_DateChk(sYm+'01') = -1 THEN 
		F_MessageChk(21,'[원가계산년월]')
		dw_1.SetItem(1,"io_ym",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="ittyp" THEN
	LsIttyp = this.GetText()
	IF LsIttyp = "" OR IsNull(LsIttyp) THEN REturn
	
	SELECT "REFFPF"."RFGUB"  INTO :LsIttyp
    	FROM "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = '05' ) AND  ( "REFFPF"."RFGUB" =:LsIttyp) ;
	IF SQLCA.SQLCODE <> 0 THEN
		f_messagechk(20,"품목구분") 
		dw_1.SetItem(1,"ittyp",snull)
		Return 1
	END IF
	
END IF

end event

event itemerror;Return 1

end event

event rbuttondown;String ls_itnbr

SetNull(gs_code)
SetNull(gs_codename)

This.AcceptText()

IF this.GetColumnName() = "itnbr"  THEN
	ls_itnbr = THIS.GetItemString(THIS.GetRow(), "itnbr")
	gs_code = ls_itnbr
		
	Open(W_ITEMAS_POPUP3)

	IF IsNull(gs_code) THEN Return
	
	THIS.SetItem(THIS.GetRow(), "itnbr", gs_code)

END IF
end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF dwo.name ="person_nm" OR dwo.name ="person_tx" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event getfocus;this.AcceptText()
end event

type rr_1 from roundrectangle within w_cia00400
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 156
integer width = 4594
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 46
end type

