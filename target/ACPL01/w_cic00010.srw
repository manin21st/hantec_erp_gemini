$PBExportHeader$w_cic00010.srw
$PBExportComments$품목별 진척도 등록
forward
event ue_enterkey ( )
event ue_key ( )
event ue_pressenter ( )
event ue_retrieve()
event ue_update()
event ue_delete()
event ue_append()
event ue_cancel()
event ue_print()
global type w_cic00010 from w_inherite
end type
type dw_2 from datawindow within w_cic00010
end type

type dw_1 from datawindow within w_cic00010
end type

end forward

global type w_cic00010 from w_inherite
integer height = 3264
string title = "품목별 진척도 등록"
dw_2 dw_2
dw_1 dw_1
end type
global w_cic00010 w_cic00010

type variables

end variables


event ue_retrieve;if IsValid(p_inq) then p_inq.TriggerEvent(Clicked!)end event

event ue_update;if IsValid(p_mod) then p_mod.TriggerEvent(Clicked!)end event

event ue_delete;if IsValid(p_del) then p_del.TriggerEvent(Clicked!)end event

event ue_append;if IsValid(p_addrow) then p_addrow.TriggerEvent(Clicked!)end event

event ue_cancel;if IsValid(p_can) then p_can.TriggerEvent(Clicked!)end event

event ue_print;if IsValid(p_print) then p_print.TriggerEvent(Clicked!)end event

on w_cic00010.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_cic00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.dw_1)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_1.Reset()

DataWindowChild  Dw_Child
Integer          iVal

iVal = dw_1.GetChild("itcls",Dw_Child)
IF iVal = 1 THEN
	dw_child.SetTransObject(Sqlca)
	if dw_child.Retrieve('1') <=0 then
		dw_child.InsertRow(0)
	end if
END IF

dw_1.InsertRow(0)
dw_1.SetFocus()

dw_2.SetTransObject(SQLCA)
dw_2.Reset()

ib_any_typing = False

end event

type dw_insert from w_inherite`dw_insert within w_cic00010
boolean x = 2727
		y = 1500
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cic00010
boolean x = 2727
		y = 1500
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_cic00010
boolean x = 2727
		y = 1500
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_cic00010
boolean x = 2727
		y = 1500
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_cic00010
boolean x = 2727
		y = 1500
integer taborder = 0
string pointer = "C:\erpman\cur\new.cur"
end type

type p_exit from w_inherite`p_exit within w_cic00010
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_cic00010
integer taborder = 50
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

dw_2.Reset()

ib_any_typing =False

end event

type p_print from w_inherite`p_print within w_cic00010
boolean x = 2727
		y = 1500
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cic00010
end type

event p_inq::clicked;call super::clicked;String sItcls,sIttyp,sItnbr

w_mdi_frame.sle_msg.text = ''
IF dw_1.Accepttext() = -1 THEN RETURN
sIttyp = dw_1.GetItemString(dw_1.GetRow(),"pum_gubn")
sItcls = dw_1.GetItemString(dw_1.GetRow(),"itcls")
sItnbr = dw_1.GetItemString(dw_1.GetRow(),"itnbr")

IF sIttyp = "" OR IsNull(sIttyp) THEN
	f_MessageChk(1,'[품목구분]')
	dw_1.SetColumn("pum_gubn")
	dw_1.SetFocus()
	Return
END IF
IF IsNull(sItcls) or sItcls = '' then sItcls = '%'
IF IsNull(sItnbr) or sItnbr = '' then sItnbr = '%'

SetPointer(HourGlass!)
dw_2.SetRedraw(False)
IF dw_2.Retrieve(sIttyp,sItcls,sItnbr) <=0 THEN
	F_MESSAGECHK(14,"")
	dw_1.SetFocus()
	dw_2.SetRedraw(True)
	w_mdi_frame.sle_msg.text = ''
	SetPointer(Arrow!)
	Return
ELSE
	dw_2.SetColumn("itemas_newite")
	dw_2.SetFocus()
END IF
dw_2.SetRedraw(True)

w_mdi_frame.sle_msg.text = '조회 완료'
SetPointer(Arrow!)
end event

type p_del from w_inherite`p_del within w_cic00010
boolean x = 2727
		y = 1500
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_cic00010
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;Integer k,iRtnValue

IF dw_2.AcceptText() = -1 THEN Return

IF f_dbConFirm('저장') = 2 THEN RETURN

IF dw_2.Update() = 1 THEN
	commit;
	
	dw_2.SetColumn("itemas_newite")
	dw_2.SetFocus()
	
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 저장되었습니다.!!!"
ELSE
	ROLLBACK;
	f_messagechk(13,'')
END IF

end event

type cb_exit from w_inherite`cb_exit within w_cic00010
boolean x = 2727
		y = 1500
end type

type cb_mod from w_inherite`cb_mod within w_cic00010
boolean x = 2727
		y = 1500
end type

type cb_ins from w_inherite`cb_ins within w_cic00010
boolean x = 2727
		y = 1500
end type

type cb_del from w_inherite`cb_del within w_cic00010
boolean x = 2727
		y = 1500
end type

type cb_inq from w_inherite`cb_inq within w_cic00010
boolean x = 2727
		y = 1500
end type

type cb_print from w_inherite`cb_print within w_cic00010
boolean x = 2727
		y = 1500
end type

type st_1 from w_inherite`st_1 within w_cic00010
boolean x = 2727
		y = 1500
integer width = 293
end type

type cb_can from w_inherite`cb_can within w_cic00010
boolean x = 2727
		y = 1500
end type

type cb_search from w_inherite`cb_search within w_cic00010
boolean x = 2727
		y = 1500
end type

type dw_datetime from w_inherite`dw_datetime within w_cic00010
boolean x = 2727
		y = 1500
integer height = 88
end type

type sle_msg from w_inherite`sle_msg within w_cic00010
boolean x = 2727
		y = 1500
integer width = 2533
end type

type dw_2 from datawindow within w_cic00010
event ue_key pbm_dwnkey
event ue_enterkey pbm_dwnprocessenter
integer x = 114
integer y = 172
integer width = 4430
integer height = 2020
integer taborder = 30
string dataobject = "dw_cic000102"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey;Send(Handle(this),256,9,0)
Return 1
end event

event editchanged;ib_any_typing =True
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

event retrieveend;//Integer k
//
//FOR k = 1 TO rowcount
//	this.SetItem(k,'sflag','M')
//NEXT
end event

event itemerror;Return 1
end event

event itemchanged;ib_any_typing = True
end event

type dw_1 from datawindow within w_cic00010
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 105
integer y = 20
integer width = 3557
integer height = 132
integer taborder = 20
string dataobject = "dw_cic000101"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String           snull,sIttyp,sItnbr,sItdsc,sItcls,sTitNm
DataWindowChild  Dw_Child
Integer          iVal

SetNull(snull)

w_mdi_frame.sle_msg.text =""

IF this.GetColumnName() ="pum_gubn" THEN
	sIttyp = this.GetText()
	IF sIttyp = "" OR IsNull(sIttyp) THEN REturn
	
	iVal = dw_1.GetChild("itcls",Dw_Child)
	IF iVal = 1 THEN
		dw_child.SetTransObject(Sqlca)
		if dw_child.Retrieve(sIttyp) <=0 then
			dw_child.InsertRow(0)
		end if
	END IF
END IF

IF this.GetColumnName() = "itcls" THEN
   sItcls = this.GetText()      
   IF IsNull(sItcls) OR sItcls = '' THEN Return
	
	sIttyp = this.GetItemString(1,"pum_gubn")
	if sIttyp = '' or IsNull(sIttyp) then Return
	
	select titnm	into :sTitNm	from itnct	where ittyp = :sIttyp and itcls = :sItcls;
	if sqlca.sqlcode <> 0 then
		F_MessageChk(20,'[품목분류]')
		Return 1
	end if
	
END IF	

IF this.GetColumnName() = "itnbr" THEN
   sItnbr = this.GetText()      
   IF IsNull(sItnbr) OR sItnbr = '' THEN Return
	
	select itdsc	into :sItdsc	from itemas where itnbr = :sItnbr ;
	if sqlca.sqlcode = 0 then
		this.SetItem(THIS.GetRow(), "itnbr_name", sItdsc)
	else
		F_MessageChk(20,'[품번]')
		this.SetItem(THIS.GetRow(), "itnbr_name", sNull)
		Return 1
	end if	
END IF	

end event

event itemerror;Return 1

end event

event getfocus;this.AcceptText()
end event

event rbuttondown;IF this.GetColumnName() = "sitnbr" THEN
   SetNull(Gs_Code);		SetNull(Gs_CodeName);
	
	Open(W_ITEMAS_POPUP3)
      
   IF IsNull(gs_code) OR gs_code = "" THEN Return
	
	THIS.SetItem(THIS.GetRow(), "itnbr",      gs_code)
	THIS.SetItem(THIS.GetRow(), "itnbr_name", gs_codename)
	
END IF	
end event



event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", true)

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event