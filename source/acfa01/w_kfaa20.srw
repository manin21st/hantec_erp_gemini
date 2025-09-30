$PBExportHeader$w_kfaa20.srw
$PBExportComments$고정자산 취득품의내역 등록
forward
global type w_kfaa20 from w_inherite
end type
type dw_gbn from u_key_enter within w_kfaa20
end type
type dw_lst from u_d_popup_sort within w_kfaa20
end type
type dw_print from datawindow within w_kfaa20
end type
type rr_1 from roundrectangle within w_kfaa20
end type
end forward

global type w_kfaa20 from w_inherite
string title = "고정자산 취득완료내역 등록"
dw_gbn dw_gbn
dw_lst dw_lst
dw_print dw_print
rr_1 rr_1
end type
global w_kfaa20 w_kfaa20

forward prototypes
public function integer wf_requiredchk ()
end prototypes

public function integer wf_requiredchk ();String sPumNo

sPumNo = dw_insert.GetItemString(dw_insert.GetRow(),"pum_no")

if sPumNo = '' or IsNull(sPumNo) then
	F_MessageChk(1,'[품의/보고서 NO]')
	dw_insert.SetColumn("pum_no")
	dw_insert.SetFocus()
	Return -1
end if

Return 1
end function

on w_kfaa20.create
int iCurrent
call super::create
this.dw_gbn=create dw_gbn
this.dw_lst=create dw_lst
this.dw_print=create dw_print
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_gbn
this.Control[iCurrent+2]=this.dw_lst
this.Control[iCurrent+3]=this.dw_print
this.Control[iCurrent+4]=this.rr_1
end on

on w_kfaa20.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_gbn)
destroy(this.dw_lst)
destroy(this.dw_print)
destroy(this.rr_1)
end on

event open;call super::open;dw_gbn.SetTransObject(Sqlca)
dw_gbn.Reset()
dw_gbn.InsertRow(0)
dw_gbn.SetFocus()

dw_lst.SetTransObject(Sqlca)
dw_lst.Reset()

dw_insert.SetTransObject(Sqlca)
dw_insert.InsertRow(0)

dw_print.SetTransObject(Sqlca)

dw_gbn.SetItem(1,"fdate",Left(F_Today(),6)+'01')
dw_gbn.SetItem(1,"tdate",f_today())

p_mod.enabled = False
p_mod.PictureName = "C:\erpman\image\저장_d.gif"
p_print.enabled = False
p_print.PictureName = "C:\erpman\image\인쇄_d.gif"
end event

type dw_insert from w_inherite`dw_insert within w_kfaa20
integer x = 1184
integer y = 172
integer width = 3447
integer height = 2060
integer taborder = 30
string dataobject = "d_kfaa203"
boolean border = false
end type

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::rbuttondown;If this.GetColumnName() = 'jakupjang' then	
	SetNull(gs_code)
	SetNull(gs_codename)
		
	gs_code = this.GetItemString(this.GetRow(), 'jakupjang')
		
	If isnull(gs_code) then gs_code = "" 
	
	Open(w_workplace_popup)
	
	If gs_code = "" or isnull(gs_code) then Return
	
	this.SetItem(this.GetRow(), 'jakupjang', gs_code)
	this.SetItem(this.GetRow(), 'jakupjang_nm', gs_codename)
END IF

end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;
Long wnd

wnd =Handle(this)

IF dwo.name ="yongdo" OR dwo.name ="jejo" OR dwo.name = 'as_dam' OR dwo.name = 'gongjeong' OR &
   dwo.name = 'gitasahang' THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF
end event

event dw_insert::itemchanged;call super::itemchanged;String sNull,sEmpNo,sDeptCode,sGumeGb,sType,sDeptNo,sGb,sDate,sJakUp,sWcDsc
Int    iCurRow

SetNull(sNull)

iCurRow = this.GetRow()

IF this.GetColumnName() = "euroi_empno" THEN
	sEmpNo = this.GetText()
	IF sEmpNo = "" OR IsNull(sEmpNo) THEN
		this.SetItem(iCurRow,"euroi_deptno",sNull)
		Return
	END IF

	If IsNull(F_Get_Personlst('4',sEmpNo,'1')) THEN
		F_MessageChk(20,'[의뢰자]')
		this.SetItem(iCurRow,"euroi_empno",sNull)
		this.SetItem(iCurRow,"euroi_deptno",sNull)
		Return 1
	END IF
	
	Select deptcode
	  Into :sDeptCode
	  From p1_master
	 Where empno = :sEmpNo;
	
	this.SetItem(iCurRow,"euroi_deptno",sDeptCode)
END IF

IF this.GetColumnName() = "gume_gb" THEN
	sGumeGb = this.GetText()
	IF sGumeGb = "" OR IsNull(sGumeGb) THEN Return
	
	IF sGumeGb <> "1" AND sGumeGb <> "2" AND sGumeGb <> "3" AND sGumeGb <> "4" AND sGumeGb <> "5" AND sGumeGb <> "6" THEN
		F_MessageChk(20,'[구매구분]')
		this.SetItem(iCurRow,"gume_gb",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "su_type" THEN
	sType = this.GetText()
	IF sType = "" OR IsNull(sType) THEN Return
	
	IF sType <> "1" AND sType <> "2" AND sType <> "3" THEN
		F_MessageChk(20,'[수량단위]')
		this.SetItem(iCurRow,"su_type",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "jakupjang" THEN
	sJakUp = this.GetText()
	IF sJakUp = "" OR IsNull(sJakUp) THEN
		this.SetItem(iCurRow,"jakupjang_nm",sNull)
		Return
	END IF

	Select wcdsc
	  Into :sWcDsc
	  From wrkctr
	 Where wkctr = :sJakUp;
	
	IF sqlca.sqlcode <> 0 THEN
		F_MessageChk(20,'[작업장]')
		this.SetItem(iCurRow,"jakupjang",sNull)
		this.SetItem(iCurRow,"jakupjang_nm",sNull)
		Return 1
	END IF
	
	this.SetItem(iCurRow,"jakupjang_nm",sWcDsc)
END IF

IF this.GetColumnName() = "sayong_dept" THEN
	sDeptNo = this.GetText()
	IF sDeptNo = "" OR IsNull(sDeptNo) THEN Return

	If IsNull(F_Get_Personlst('3',sDeptNo,'1')) THEN
		F_MessageChk(20,'[사용부서]')
		this.SetItem(iCurRow,"sayong_dept",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "manual_gb" THEN
	sGb = this.GetText()
	IF sGb = "" OR IsNull(sGb) THEN Return
	
	IF sGb <> "Y" AND sGb <> "N" THEN
		F_MessageChk(20,'[MANUAL 유무]')
		this.SetItem(iCurRow,"manual_gb",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "do_gb" THEN
	sGb = this.GetText()
	IF sGb = "" OR IsNull(sGb) THEN Return
	
	IF sGb <> "Y" AND sGb <> "N" THEN
		F_MessageChk(20,'[도면유무]')
		this.SetItem(iCurRow,"do_gb",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "guip_date" then
	sDate = this.GetText()
	IF sDate = '' OR IsNull(sDate) THEN Return
	
	IF F_DateChk(sDate) = -1 THEN
		F_Messagechk(21,'[구입일자]')
		this.SetItem(iCurRow,"guip_date",sNull)
		Return 1
	END IF
END IF
end event

type p_delrow from w_inherite`p_delrow within w_kfaa20
boolean visible = false
integer x = 4082
integer y = 2328
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfaa20
boolean visible = false
integer x = 2011
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfaa20
boolean visible = false
integer x = 1650
integer y = 20
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfaa20
boolean visible = false
integer x = 4256
integer y = 2328
integer taborder = 60
boolean enabled = false
string picturename = "C:\erpman\image\추가_d.gif"
end type

type p_exit from w_inherite`p_exit within w_kfaa20
integer x = 4430
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_kfaa20
integer x = 4256
integer taborder = 90
end type

event p_can::clicked;call super::clicked;dw_gbn.Reset()
dw_gbn.InsertRow(0)

dw_lst.Reset()

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

p_mod.enabled = False
p_mod.PictureName = "C:\erpman\image\저장_d.gif"
p_print.enabled = False
p_print.PictureName = "C:\erpman\image\인쇄_d.gif"
end event

type p_print from w_inherite`p_print within w_kfaa20
integer x = 4082
integer taborder = 0
end type

event p_print::clicked;call super::clicked;dw_gbn.AcceptText()

dw_print.Retrieve(dw_gbn.GetItemString(dw_gbn.GetRow(),"gb"),dw_lst.GetItemString(dw_lst.GetRow(),"kfcod1"),dw_lst.GetItemNumber(dw_lst.GetRow(),"kfcod2"))

iF dw_print.rowcount() > 0 then 
	gi_page = long(dw_print.Describe("evaluate('pagecount()', 1)" ))
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)

w_mdi_frame.sle_msg.text ="인쇄되었습니다."
end event

type p_inq from w_inherite`p_inq within w_kfaa20
integer x = 3735
integer taborder = 50
end type

event p_inq::clicked;call super::clicked;String sGb,sKfcod,sDateF,sDateT

if dw_gbn.AcceptText() = -1 then Return

sGb    = dw_gbn.GetItemString(1,"gb")
sKfcod = dw_gbn.GetItemString(1,"kfcod1")
sDateF = dw_gbn.GetItemString(1,"fdate")
sDateT = dw_gbn.GetItemString(1,"tdate")

if sGb = '' or IsNull(sGb) then
	F_MessageChk(1,'[구분]')
	dw_gbn.SetColumn("gb")
	dw_gbn.SetFocus()
	Return
end if

if sKfcod = '' or IsNull(sKfcod) then
	F_MessageChk(1,'[자산구분]')
	dw_gbn.SetColumn("kfcod1")
	dw_gbn.SetFocus()
	Return
end if

if sDateF = '' or IsNull(sDateF) then sDateF = '00000000'
if sDateT = '' or IsNull(sDateT) then sDateT = '99999999'

dw_lst.Retrieve(sGb,sKfcod,sDateF,sDateT)

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

p_mod.enabled = False
p_mod.PictureName = "C:\erpman\image\저장_d.gif"
p_print.enabled = False
p_print.PictureName = "C:\erpman\image\인쇄_d.gif"
end event

type p_del from w_inherite`p_del within w_kfaa20
boolean visible = false
integer x = 4430
integer y = 2328
integer taborder = 80
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_kfaa20
integer x = 3909
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then Return
if dw_insert.GetRow() <=0 then Return

if Wf_RequiredChk() = -1 then Return

if f_dbconfirm("저장") = 2 then Return

if dw_insert.Update() <> 1 then
	F_MessageChk(12,'')
   ROLLBACK;
	Return
end if

Commit;

p_inq.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text ="저장되었습니다."
end event

type cb_exit from w_inherite`cb_exit within w_kfaa20
end type

type cb_mod from w_inherite`cb_mod within w_kfaa20
end type

type cb_ins from w_inherite`cb_ins within w_kfaa20
end type

type cb_del from w_inherite`cb_del within w_kfaa20
end type

type cb_inq from w_inherite`cb_inq within w_kfaa20
end type

type cb_print from w_inherite`cb_print within w_kfaa20
end type

type st_1 from w_inherite`st_1 within w_kfaa20
end type

type cb_can from w_inherite`cb_can within w_kfaa20
end type

type cb_search from w_inherite`cb_search within w_kfaa20
end type







type gb_button1 from w_inherite`gb_button1 within w_kfaa20
end type

type gb_button2 from w_inherite`gb_button2 within w_kfaa20
end type

type dw_gbn from u_key_enter within w_kfaa20
integer x = 27
integer y = 20
integer width = 3131
integer height = 148
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfaa201"
boolean border = false
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String sGb,sKfCod,sNull,sDate

SetNull(sNull)

if this.GetColumnName() = "gb" then
	sGb = this.GetText()
	if sGb = '' or IsNull(sGb) then Return
	
	if sGb <> "1" AND sGb <> "2" then
		F_MessageChk(20,'[작업구분]')
		this.SetItem(this.GetRow(),"gb", sNull)
		Return 1
	end if
	dw_lst.ReSet()
	dw_insert.SetreDraw(False)
	dw_insert.ReSet()
	dw_insert.InsertRow(0)
	dw_insert.SetreDraw(True)
end if

if this.GetColumnName() = "kfcod1" then
	sKfcod = this.GetText()
	if sKfcod = '' or IsNull(sKfcod) then Return
	
	if IsNull(F_Get_Refferance('F1',sKfcod)) then
		F_MessageChk(20,'[자산구분]')
		this.SetItem(this.GetRow(),"kfcod1", sNull)
		Return 1
	end if
	dw_lst.ReSet()
	dw_insert.SetreDraw(False)
	dw_insert.ReSet()
	dw_insert.InsertRow(0)
	dw_insert.SetreDraw(True)
end if

IF This.GetColumnName() = "fdate" THEN
	sDate = Trim(This.GetText())
	IF sDate = "" OR IsNull(sDate) THEN Return
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[취득일자]')
		This.SetItem(This.GetRow(), "fdate", sNull)
		Return 1
	END IF
END IF

IF This.GetColumnName() = "tdate" THEN
	sDate = Trim(This.GetText())
	IF sDate = "" OR IsNull(sDate) THEN Return
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[취득일자]')
		This.SetItem(This.GetRow(), "tdate", sNull)
		Return 1
	END IF
END IF
end event

type dw_lst from u_d_popup_sort within w_kfaa20
integer x = 46
integer y = 184
integer width = 1115
integer height = 2024
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_kfaa202"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;dw_gbn.AcceptText()


If Row <= 0 then
	dw_lst.SelectRow(0,False)
	b_flag = True
ELSE
	dw_lst.SelectRow(0,False)
	dw_lst.SelectRow(row,True)

	dw_insert.SetRedraw(False)
	dw_insert.Retrieve(dw_gbn.GetItemString(dw_gbn.GetRow(),"gb"),dw_lst.GetItemString(Row,"kfcod1"),dw_lst.GetItemNumber(Row,"kfcod2"))
	dw_insert.SetRedraw(True)
	
	p_mod.enabled = True
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
	p_print.enabled = True
	p_print.PictureName = "C:\erpman\image\인쇄_up.gif"
	
	b_Flag = False
END IF
end event

type dw_print from datawindow within w_kfaa20
boolean visible = false
integer x = 3584
integer y = 36
integer width = 123
integer height = 104
integer taborder = 110
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_kfaa204_p"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kfaa20
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 176
integer width = 1143
integer height = 2040
integer cornerheight = 40
integer cornerwidth = 55
end type

