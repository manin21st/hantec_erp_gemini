$PBExportHeader$w_kgld83.srw
$PBExportComments$신용카드번호 누락 명세서 조회출력
forward
global type w_kgld83 from w_standard_print
end type
type dw_proclst from datawindow within w_kgld83
end type
type rr_1 from roundrectangle within w_kgld83
end type
end forward

global type w_kgld83 from w_standard_print
integer height = 2404
string title = "신용카드번호 누락 명세서 조회출력"
dw_proclst dw_proclst
rr_1 rr_1
end type
global w_kgld83 w_kgld83

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSaupj,sDateF,sDateT

sle_msg.text = ''

If dw_ip.AcceptText() = -1 Then Return -1

sSaupj  = Trim(dw_ip.GetItemString(dw_ip.GetRow(),'saupj'))
sDatef  = Trim(dw_ip.GetItemString(dw_ip.GetRow(),'k_symd'))
sDatet  = Trim(dw_ip.GetItemString(dw_ip.GetRow(),'k_eymd'))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sSaupj = "99" THEN sSaupj = '%'

IF sDateF = "" OR IsNull(sDateF) THEN
	F_MessageChk(1,'[발행일자]')
	dw_ip.Setcolumn('k_symd')
	dw_ip.SetFocus()
	Return -1
END IF

IF sDateT = "" OR IsNull(sDateT) THEN
	F_MessageChk(1,'[발행일자]')
	dw_ip.Setcolumn('k_eymd')
	dw_ip.SetFocus()
	Return -1
END IF

dw_list.Reset()
dw_list.SetRedraw(False)

IF dw_print.Retrieve(sSaupj,sDateF,sDateT) <= 0 THEN
	F_MessageChk(14, "")
	dw_list.insertrow(0)
	dw_ip.Setcolumn('k_symd')
	dw_ip.Setfocus()
	Return -1
END IF

dw_print.sharedata(dw_list)
dw_list.SetRedraw(True)

Return 1
end function

on w_kgld83.create
int iCurrent
call super::create
this.dw_proclst=create dw_proclst
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_proclst
this.Control[iCurrent+2]=this.rr_1
end on

on w_kgld83.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_proclst)
destroy(this.rr_1)
end on

event open;call super::open;dw_proclst.SetTransObject(SQLCA)

dw_ip.SetTransObject(SQLCA)

dw_ip.SetItem(dw_ip.Getrow(),"saupj",   Gs_Saupj)
dw_ip.SetItem(dw_ip.Getrow(),"k_symd",  Left(f_today(),6)+'01')
dw_ip.SetItem(dw_ip.Getrow(),"k_eymd",  f_today())

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
	dw_ip.Modify("saupj.protect = 1")
ELSE
	dw_ip.Modify("saupj.protect = 0")
END IF	
	
dw_ip.SetColumn("saupj")
dw_ip.SetFocus()

dw_proclst.Settransobject(sqlca)
end event

type p_preview from w_standard_print`p_preview within w_kgld83
end type

type p_exit from w_standard_print`p_exit within w_kgld83
end type

type p_print from w_standard_print`p_print within w_kgld83
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld83
end type



type sle_msg from w_standard_print`sle_msg within w_kgld83
long textcolor = 8388608
long backcolor = 80269524
end type



type st_10 from w_standard_print`st_10 within w_kgld83
end type



type dw_print from w_standard_print`dw_print within w_kgld83
string dataobject = "dw_kgld832_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld83
integer width = 2213
integer height = 144
string dataobject = "dw_kgld831"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::getfocus;this.Accepttext()
end event

event dw_ip::itemchanged;String  sDate,snull

SetNull(snull)

IF this.GetColumnName() = 'k_symd' THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[발행일자]')
		this.SetItem(1,'k_symd',snull)
		Return 1
	ELSE
		this.SetItem(1,'k_symd', sDate)
	END IF
END IF

IF this.GetColumnName() = 'k_eymd' THEN
	sDate = Trim(this.GetText())
	IF sDate = "" OR IsNull(sDate) THEN RETURN
	
	IF F_DateChk(sDate) = -1 THEN
		F_MessageChk(21,'[발행일자]')
		this.SetItem(1,'k_eymd',snull)
		Return 1
	ELSE
		this.SetItem(1,'k_eymd', sDate)
	END IF
END IF
end event

type dw_list from w_standard_print`dw_list within w_kgld83
integer x = 59
integer y = 184
integer width = 4535
integer height = 2020
string dataobject = "dw_kgld832"
boolean border = false
end type

type dw_proclst from datawindow within w_kgld83
boolean visible = false
integer x = 690
integer y = 2312
integer width = 1253
integer height = 96
boolean bringtotop = true
boolean titlebar = true
string title = "선급비용월할 기처리액"
string dataobject = "dw_kgld803"
boolean minbox = true
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kgld83
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 176
integer width = 4571
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

