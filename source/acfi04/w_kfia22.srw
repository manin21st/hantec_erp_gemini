$PBExportHeader$w_kfia22.srw
$PBExportComments$자금계획 고정금액 등록
forward
global type w_kfia22 from w_inherite
end type
type dw_update from datawindow within w_kfia22
end type
type dw_cond from u_key_enter within w_kfia22
end type
type rr_1 from roundrectangle within w_kfia22
end type
end forward

global type w_kfia22 from w_inherite
string title = "자금계획 고정금액 등록"
dw_update dw_update
dw_cond dw_cond
rr_1 rr_1
end type
global w_kfia22 w_kfia22

forward prototypes
public function integer wf_requiredchk (integer ll_row)
end prototypes

public function integer wf_requiredchk (integer ll_row);String  sYm,sday,scode
Double  damount

sYm     = dw_update.GetItemString(ll_row,"finance_ym")
sday    = dw_update.GetItemString(ll_row,"finamce_day")
scode   = dw_update.GetItemString(ll_row,"finance_cd")
damount = dw_update.GetItemNumber(ll_row,"plan_amt")

IF sYm ="" OR IsNull(sYm) THEN
	F_MessageChk(1,'[계획년월]')
	dw_cond.SetColumn("sfinanceym")
	dw_cond.SetFocus()
	Return -1
END IF

IF sday ="" OR IsNull(sday) THEN
	F_MessageChk(1,'[일자]')
	dw_update.SetColumn("finamce_day")
	dw_update.SetFocus()
	Return -1
END IF

IF scode ="" OR IsNull(scode) THEN
	F_MessageChk(1,'[자금수지코드]')
	dw_update.SetColumn("finance_cd")
	dw_update.SetFocus()
	Return -1
END IF

IF damount =0 OR IsNull(damount) THEN
	F_MessageChk(1,'[계획금액]')
	dw_update.SetColumn("plan_amt")
	dw_update.SetFocus()
	Return -1
END IF

Return 1
end function

on w_kfia22.create
int iCurrent
call super::create
this.dw_update=create dw_update
this.dw_cond=create dw_cond
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_update
this.Control[iCurrent+2]=this.dw_cond
this.Control[iCurrent+3]=this.rr_1
end on

on w_kfia22.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_update)
destroy(this.dw_cond)
destroy(this.rr_1)
end on

event open;call super::open;dw_cond.SetTransObject(SQLCA)
dw_cond.Reset()
dw_cond.InsertRow(0)
dw_cond.SetItem(1,"sfinanceym", Left(F_Today(),6))
dw_cond.SetColumn("sfinanceym")
dw_cond.SetFocus()

dw_update.SetTransObject(SQLCA)
dw_update.Reset()

p_ins.PictureName = "C:\erpman\image\추가_d.gif"
p_ins.Enabled     = False

p_search.PictureName = "C:\erpman\image\복사_d.gif"
p_search.Enabled     = False




end event

type dw_insert from w_inherite`dw_insert within w_kfia22
boolean visible = false
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfia22
boolean visible = false
integer x = 4050
integer y = 2896
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfia22
boolean visible = false
integer x = 3877
integer y = 2896
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfia22
integer x = 3387
integer taborder = 80
string picturename = "C:\erpman\image\복사_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

event p_search::clicked;call super::clicked;String   sYm
Integer  iCount

dw_cond.AcceptText()
sYm = dw_cond.GetItemString(1,"sfinanceym")
if sYm = '' or IsNull(sYm) then
	F_MessageChk(1,'[계획년월]')
	dw_cond.SetColumn("sfinanceym")
	dw_cond.SetFocus()
	Return
end if

select Count(*)	into :iCount  from kfm13ot0 where finance_ym = :sYm ;
if sqlca.sqlcode = 0 then
	if IsNull(iCount) then iCount = 0
else
	iCount = 0
end if
if iCount > 0 then
	if MessageBox('확 인','자료가 존재합니다.삭제하시고 다시 생성하시겠습니까?',Question!,YesNo!) = 2 then Return

	delete from kfm13ot0 where finance_ym = :sYm;
	Commit;
end if

OpenWithParm(w_kfia22a,sYm)

if Message.StringParm <> '0' then
	dw_update.Retrieve(sYm)
end if
	
end event

type p_ins from w_inherite`p_ins within w_kfia22
integer x = 3735
integer taborder = 40
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_functionvalue

w_mdi_frame.sle_msg.text =""

IF dw_update.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue =1
ELSE
	il_functionvalue = wf_requiredchk(dw_update.GetRow())
	
	il_currow = dw_update.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_update.InsertRow(il_currow)
	
	dw_update.ScrollToRow(il_currow)
	dw_update.SetItem(il_currow,"finance_ym", dw_cond.GetItemString(1,"sfinanceym"))
	
	dw_update.SetColumn("finamce_day")
	dw_update.SetFocus()	
END IF

end event

type p_exit from w_inherite`p_exit within w_kfia22
integer x = 4430
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_kfia22
integer x = 4256
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

dw_update.Reset()

p_ins.PictureName = "C:\erpman\image\추가_d.gif"
p_ins.Enabled     = False

p_search.PictureName = "C:\erpman\image\복사_d.gif"
p_search.Enabled     = False

ib_any_typing =False
end event

type p_print from w_inherite`p_print within w_kfia22
boolean visible = false
integer x = 3355
integer y = 2896
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfia22
integer x = 3561
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;String sYm

dw_cond.AcceptText()
sYm = dw_cond.GetItemString(1,"sfinanceym")
if sYm = '' or IsNull(sYm) then
	F_MessageChk(1,'[계획년월]')
	dw_cond.SetColumn("sfinanceym")
	dw_cond.SetFocus()
	Return
end if

p_ins.PictureName = "C:\erpman\image\추가_up.gif"
p_ins.Enabled     = True

p_search.PictureName = "C:\erpman\image\복사_up.gif"
p_search.Enabled     = True

IF dw_update.Retrieve(sYm) <=0 THEN
	F_MessageChk(14,'')
	Return
END IF
w_mdi_frame.sle_msg.text ="자료를 조회하였습니다!!"

end event

type p_del from w_inherite`p_del within w_kfia22
integer x = 4082
end type

event p_del::clicked;call super::clicked;Int il_currow

w_mdi_frame.sle_msg.text =""

il_currow = dw_update.GetRow()

IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_update.DeleteRow(il_currow)

IF dw_update.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_update.ScrollToRow(il_currow - 1)
		dw_update.SetColumn("finamce_day")
		dw_update.SetFocus()
	END IF
	ib_any_typing =False
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_mod from w_inherite`p_mod within w_kfia22
integer x = 3909
end type

event p_mod::clicked;call super::clicked;
w_mdi_frame.sle_msg.text =""

IF dw_update.Accepttext() = -1 THEN 	RETURN
if dw_update.RowCount() <=0 then Return

IF dw_update.RowCount() > 0 THEN
	IF wf_requiredchk(dw_update.GetRow()) = -1 THEN RETURN
END IF

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN
	
IF dw_update.Update() > 0 THEN			
	COMMIT ;
	ib_any_typing =False
	
ELSE
	ROLLBACK ;
	ib_any_typing = True
	Return
END IF

dw_update.Setfocus()
		

end event

type cb_exit from w_inherite`cb_exit within w_kfia22
boolean visible = false
integer x = 3817
integer y = 2768
integer height = 104
end type

type cb_mod from w_inherite`cb_mod within w_kfia22
boolean visible = false
integer x = 2752
integer y = 2764
integer height = 104
end type

type cb_ins from w_inherite`cb_ins within w_kfia22
boolean visible = false
integer x = 2418
integer y = 2768
integer width = 325
integer height = 104
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_kfia22
boolean visible = false
integer x = 3113
integer y = 2764
integer height = 104
end type

type cb_inq from w_inherite`cb_inq within w_kfia22
boolean visible = false
integer x = 2071
integer y = 2768
integer width = 325
integer height = 104
end type

type cb_print from w_inherite`cb_print within w_kfia22
boolean visible = false
integer x = 1029
integer y = 2776
end type

type st_1 from w_inherite`st_1 within w_kfia22
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kfia22
boolean visible = false
integer x = 3474
integer y = 2764
integer height = 104
end type

type cb_search from w_inherite`cb_search within w_kfia22
boolean visible = false
integer x = 1394
integer y = 2772
integer width = 599
integer height = 104
string text = "자금계획생성(U)"
end type

event cb_search::clicked;//
//sle_msg.text =""
//
//open(w_kfia22a)
//
//
end event

type dw_datetime from w_inherite`dw_datetime within w_kfia22
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfia22
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfia22
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfia22
boolean visible = false
integer x = 695
integer y = 3060
integer width = 1371
end type

type gb_button2 from w_inherite`gb_button2 within w_kfia22
boolean visible = false
integer x = 2638
integer y = 3060
end type

type dw_update from datawindow within w_kfia22
event ue_key pbm_dwnkey
event ue_keyenter pbm_dwnprocessenter
integer x = 91
integer y = 200
integer width = 4494
integer height = 2012
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_kfia22_1"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
elseif keydown(keytab!) and dw_update.getcolumnname() = "apply_gu" then
   if dw_update.rowcount() = dw_update.getrow() then
     	p_ins.postevent(clicked!)
   end if
end if
end event

event ue_keyenter;Send(Handle(this),256,9,0)
end event

event rowfocuschanged;this.SetRowFocusIndicator(Hand!)
end event

event editchanged;ib_any_typing =True
end event

event rbuttondown;
SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() ="finance_cd" THEN
	
	OpenWithParm(W_KFM10OM0_POPUP,'N')

	IF IsNull(gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"finance_cd",gs_code)
	
	this.TriggerEvent(ItemChanged!)
END IF
end event

event itemchanged;String snull,scode,sname,sday
Int    lReturnRow,lRow

SetNull(snull)

lRow = this.GetRow()
IF this.GetColumnName() = "finamce_day" THEN
	sday = this.GetText()
	
	IF Long(sday) > 31 OR Long(sday) < 1 THEN
		MessageBox("확 인","일자를 확인하십시요!!")
		this.SetItem(lRow,"finamce_day",snull)
		Return 1
	END IF
	
	IF Len(sday) < 2 THEN
		this.SetItem(lRow,"finamce_day",'0'+sday)
		Return 2
	END IF
END IF

IF this.GetColumnName() = "finance_cd"THEN
	
	scode = this.GetText()
	
	SELECT "FINANCE_NAME" INTO :sname
		FROM "KFM10OM0"
		WHERE "KFM10OM0"."FINANCE_CD" = :scode ;
	IF SQLCA.SQLCODE <> 0 THEN
		Messagebox("확 인","등록된 자금수지코드가 아닙니다!!")
		this.SetItem(lRow,"finance_cd",snull)
		this.SetItem(lRow,"kfm10om0_finance_name",snull)
		this.SetItem(lRow,"finance_desc",sNull)
		Return 1
	END IF
	this.SetItem(lRow,"kfm10om0_finance_name",sname)
	this.SetItem(lRow,"finance_desc",  Trim(sname))
	
	sday = THIS.GetItemString(lRow,"finamce_day")					
	
	lReturnRow = This.Find("finamce_day = '"+sday+"'"+"and finance_cd = '"+scode + "' ", 1, This.RowCount())
	
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
	
		MessageBox("확인","등록된 일자와 자금수지코드 입니다.~r등록할 수 없습니다.")
		this.SetItem(lRow,"finance_cd",snull)
		this.SetItem(lRow,"kfm10om0_finance_name",snull)
		this.SetItem(lRow,"finance_desc",sNull)
		RETURN  1
	END IF
END IF
ib_any_typing =True
end event

event itemerror;Return 1
end event

event itemfocuschanged;
IF this.GetColumnName() ="finance_desc" THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))	
END IF
end event

type dw_cond from u_key_enter within w_kfia22
integer x = 73
integer y = 16
integer width = 827
integer height = 160
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfia22_2"
boolean border = false
end type

event itemchanged;call super::itemchanged;String   sYm,sNull

SetNull(sNull)

if this.GetColumnName() = "sfinanceym" then
	sYm = Trim(this.GetText())
	if sYm = '' or IsNull(sYm) then Return
	
	if F_DateChk(sYm+'01') = -1 then
		F_MessageChk(21,'')
		this.SetItem(this.GetRow(),"sfinanceym", sNull)
		Return 1
	end if
	
	dw_update.Reset()
	p_ins.PictureName = "C:\erpman\image\추가_d.gif"
	p_ins.Enabled     = False
	
	p_search.PictureName = "C:\erpman\image\복사_d.gif"
	p_search.Enabled     = False

end if
end event

event itemerror;call super::itemerror;Return 1
end event

type rr_1 from roundrectangle within w_kfia22
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 188
integer width = 4526
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

