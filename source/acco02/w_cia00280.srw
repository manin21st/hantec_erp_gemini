$PBExportHeader$w_cia00280.srw
$PBExportComments$물류수불부와 원가수불부 비교
forward
global type w_cia00280 from w_standard_print
end type
type dw_list2 from datawindow within w_cia00280
end type
type rr_1 from roundrectangle within w_cia00280
end type
type rr_2 from roundrectangle within w_cia00280
end type
end forward

global type w_cia00280 from w_standard_print
string title = "제조원가명세서와 수불부 비교"
dw_list2 dw_list2
rr_1 rr_1
rr_2 rr_2
end type
global w_cia00280 w_cia00280

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
String sYm, lsitnbr,sSaup,lsIttyp

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sYm    = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"io_ym"))
sSaup  = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"csaup"))
lsIttyp = dw_ip.GetItemString(dw_ip.GetRow(),"ittyp")
lsitnbr = dw_ip.GetItemString(dw_ip.GetRow(),"itnbr")

IF sYm = "" OR IsNull(sYm) THEN
	f_MessageChk(1,'[원가계산년월]')
	dw_ip.SetColumn("io_ym")
	dw_ip.SetFocus()
	Return -1
END IF
IF sSaup = "" OR IsNull(sSaup) THEN
	f_MessageChk(1,'[사업부]')
	dw_ip.SetColumn("csaup")
	dw_ip.SetFocus()
	Return -1
END IF
IF lsIttyp = "" OR IsNull(lsIttyp) THEN
	f_MessageChk(1,'[품목구분]')
	dw_ip.SetColumn("ittyp")
	dw_ip.SetFocus()
	Return -1
END IF
IF lsItnbr = "" OR IsNull(LsItnbr) THEN LsItnbr = '%'

IF dw_print.Retrieve(sYm,sSaup,LsIttyp,Lsitnbr)  <= 0 THEN
   f_messagechk(14,"") 
	Return -1 	
END IF	
dw_print.ShareData(dw_list)

dw_list.SetFilter("")
dw_list.Filter()

dw_list2.Retrieve(LsIttyp)

Return 1
end function

on w_cia00280.create
int iCurrent
call super::create
this.dw_list2=create dw_list2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list2
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
end on

on w_cia00280.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetITem(1,"io_ym",Left(f_today(),6))

dw_ip.SetColumn("io_ym")
dw_ip.SetFocus()

dw_list2.SetTransObject(Sqlca)
end event

type p_preview from w_standard_print`p_preview within w_cia00280
boolean visible = false
integer x = 3735
integer y = 16
end type

type p_exit from w_standard_print`p_exit within w_cia00280
integer y = 0
end type

type p_print from w_standard_print`p_print within w_cia00280
boolean visible = false
integer x = 3909
integer y = 16
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia00280
integer x = 4270
integer y = 0
end type







type st_10 from w_standard_print`st_10 within w_cia00280
end type



type dw_print from w_standard_print`dw_print within w_cia00280
integer x = 3653
integer y = 108
string dataobject = "dw_cia002102"
end type

type dw_ip from w_standard_print`dw_ip within w_cia00280
integer x = 32
integer width = 4096
integer height = 156
string dataobject = "dw_cia002801"
end type

event dw_ip::rbuttondown;SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)

this.AcceptText()

IF this.GetColumnName() = "acc1" OR this.GetColumnName() = "acc2" THEN
	lstr_account.acc1_cd = this.object.acc1[1]
	
	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) OR lstr_account.acc1_cd = "" THEN Return
	
	THIS.SetItem(THIS.GetRow(), "acc1", lstr_account.acc1_cd)
	THIS.SetItem(THIS.GetRow(), "acc2", lstr_account.acc2_cd)
	THIS.SetItem(THIS.GetRow(), "acc_name1", lstr_account.acc2_nm)
	
END IF
end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;String sGbun,snull

SetNUll(snull)

IF this.GetColumnName() = "gbn" THEN
	sGbun    = this.GetText()
	
	dw_list.SetRedraw(False)
	if sGbun  = '1' then 			/*품목별*/
		dw_list.DataObject = 'dw_cia002802'
		dw_print.DataObject = 'dw_cia002802'
	elseif sGbun = '2' then		/*합계*/
		dw_list.DataObject = 'dw_cia0028021'
		dw_print.DataObject = 'dw_cia0028021'
	end if
	dw_list.SetTransObject(Sqlca)
	dw_list.SetRedraw(True)

END IF


end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia00280
integer x = 41
integer y = 180
integer width = 3214
integer height = 2040
string dataobject = "dw_cia002802"
boolean border = false
end type

type dw_list2 from datawindow within w_cia00280
integer x = 3305
integer y = 184
integer width = 1280
integer height = 1644
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "dw_cia002803"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_cia00280
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 172
integer width = 3250
integer height = 2068
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_cia00280
integer linethickness = 4
long fillcolor = 32106727
integer x = 3296
integer y = 176
integer width = 1312
integer height = 1668
integer cornerheight = 40
integer cornerwidth = 55
end type

