$PBExportHeader$w_kifb02.srw
$PBExportComments$매출 현황
forward
global type w_kifb02 from w_standard_print
end type
type cb_excel from commandbutton within w_kifb02
end type
type dw_detail from datawindow within w_kifb02
end type
type rr_1 from roundrectangle within w_kifb02
end type
type rr_2 from roundrectangle within w_kifb02
end type
end forward

global type w_kifb02 from w_standard_print
integer x = 0
integer y = 0
string title = "매출 현황"
cb_excel cb_excel
dw_detail dw_detail
rr_1 rr_1
rr_2 rr_2
end type
global w_kifb02 w_kifb02

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sFromDate, sToDate, sSaupj,sCust

if dw_ip.AcceptText() = -1 then return -1

sle_msg.text =""

sSaupj    = dw_ip.GetItemString(1, "saupj")
sFromDate = Trim(dw_ip.GetItemString(1, "sfrom"))
sToDate   = Trim(dw_ip.GetItemString(1, "sto"))
sCust     = dw_ip.GetItemString(1, "scust")

IF sSaupj = '' or isnull(sSaupj) THEN
	F_MessageChk(1, "[사업장]")
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	return -1
END IF

IF trim(sFromDate) = '' or isnull(sFromDate) THEN
	F_MessageChk(1, "[계산서일자]")
	dw_ip.SetColumn("sfrom")
	dw_ip.SetFocus()
	return -1
END IF

IF trim(sToDate) = '' or isnull(sToDate) THEN
	F_MessageChk(1, "[계산서일자]")
	dw_ip.SetColumn("sto")
	dw_ip.SetFocus()
	return -1
END IF

IF sCust = "" OR IsNull(sCust) THEN sCust = '%'

IF dw_print.retrieve(sSaupj,sFromDate, sToDate, sCust) < 1 THEN
	F_MessageChk(14, "")
	dw_list.insertrow(0)
	dw_ip.SetColumn('sfrom')
	dw_ip.SetFocus()
  // Return -1
END IF
dw_print.sharedata(dw_list)
Return 1
end function

on w_kifb02.create
int iCurrent
call super::create
this.cb_excel=create cb_excel
this.dw_detail=create dw_detail
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_excel
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_kifb02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_excel)
destroy(this.dw_detail)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;String sDeptCode

lstr_jpra.flag =True

dw_datetime.settransobject(sqlca)

dw_ip.SetItem(dw_ip.GetRow(), "saupj", Gs_Saupj)
dw_ip.SetItem(dw_ip.GetRow(), "sfrom", Left(F_today(),6) + '01')
dw_ip.SetItem(dw_ip.GetRow(), "sto",   F_today())

dw_ip.SetColumn("sfrom")
dw_ip.SetFocus()
dw_detail.SetTransobject(sqlca)
dw_list.settransobject(sqlca)

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

end event

type p_preview from w_standard_print`p_preview within w_kifb02
end type

type p_exit from w_standard_print`p_exit within w_kifb02
end type

type p_print from w_standard_print`p_print within w_kifb02
end type

type p_retrieve from w_standard_print`p_retrieve within w_kifb02
end type





type dw_datetime from w_standard_print`dw_datetime within w_kifb02
integer y = 5000
integer width = 754
end type

type st_10 from w_standard_print`st_10 within w_kifb02
end type



type dw_print from w_standard_print`dw_print within w_kifb02
string dataobject = "d_kifb022_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kifb02
integer x = 0
integer y = 0
integer width = 2112
integer height = 272
string dataobject = "d_kifb021"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string sDate,sCustCode,sCustName,snull

SetNull(snull)

if this.GetColumnName() = 'sfrom' then 
	sDate = Trim(this.GetText())
	if sDate = '' or isnull(sDate) then Return
	
	if f_datechk(sdate) = -1 then
  		F_MessageChk(21, "[계산서일자]")
		this.SetItem(1,"sfrom",snull)
	   return 1
	end if
end if

if this.GetColumnName() = 'sto' then 
	sDate = Trim(this.GetText())
	if sDate = '' or isnull(sDate) then Return
	
	if f_datechk(sdate) = -1 then
  		F_MessageChk(21, "[계산서일자]")
		this.SetItem(1,"sto",snull)
	   return 1
	end if
end if

IF this.GetColumnName() = "scust" THEN
	sCustCode = this.GetText()	
	IF sCustCode = "" OR IsNull(sCustCode) THEN 
		this.SetItem(1,"scustnm",   sNull)
		RETURN
	END IF
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
	   FROM "KFZ04OM0"
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :sCustCode) AND ( "KFZ04OM0"."PERSON_GU" = '1' OR "KFZ04OM0"."PERSON_GU" = '99');
	IF SQLCA.SQLCODE <> 0 THEN
//		F_MessageChk(20,'[거래처]')
		this.SetItem(1,"scust",  snull)
		this.SetItem(1,"scustnm",sNull)
		Return 
	END IF
	this.SetItem(1,"scustnm",   sCustName)
END IF

end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::rbuttondown;this.accepttext()

IF this.GetColumnName() ="scust" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)
	
	lstr_custom.code = this.getitemstring(this.getrow(), "scust")
	
	if	lstr_custom.code = '' or isnull(lstr_custom.code) then lstr_custom.code = ''
	
	OpenWithParm(W_Kfz04om0_POPUP,'1')
	
	IF IsNull(lstr_custom.code) THEN RETURN
	
	dw_ip.SetItem(dw_ip.GetRow(),"scust",   lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"scustnm", lstr_custom.name)
end if
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kifb02
integer x = 32
integer y = 292
integer width = 2747
integer height = 2036
string dataobject = "d_kifb022"
boolean border = false
end type

event dw_list::clicked;call super::clicked;if this.Rowcount() < 1 then return
if row < 1 then return 

this.Selectrow(0, false)
this.Selectrow(this.getrow(), true)

string ls_chkno


ls_chkno  = this.GetItemString(this.GetRow(), 'checkno')

if dw_detail.Retrieve(ls_chkno) < 1 then return 1
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;string ls_chkno

If currentrow > 0 then
	this.SelectRow(0,False)
	this.SelectRow(currentrow,True)
	
	dw_list.SetRedraw(False)
   ls_chkno  = this.GetItemString(this.GetRow(), 'checkno')

    if dw_detail.Retrieve(ls_chkno) < 1 then return 1
	dw_list.SetRedraw(True)

   this.scrollTorow(currentrow)
	this.setFocus()
END IF
end event

type cb_excel from commandbutton within w_kifb02
event clicked pbm_bnclicked
integer x = 1682
integer y = 5000
integer width = 521
integer height = 92
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "엑셀(&E)"
end type

event clicked;dw_list.SaveAs()
end event

type dw_detail from datawindow within w_kifb02
integer x = 2830
integer y = 292
integer width = 1797
integer height = 2036
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_kifb0221_r"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kifb02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 272
integer width = 2798
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kifb02
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2816
integer y = 272
integer width = 1824
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

