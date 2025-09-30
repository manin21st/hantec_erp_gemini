$PBExportHeader$w_kfid23.srw
$PBExportComments$대출금현황
forward
global type w_kfid23 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfid23
end type
end forward

global type w_kfid23 from w_standard_print
integer x = 0
integer y = 0
integer height = 2468
string title = "대출금현황"
rr_1 rr_1
end type
global w_kfid23 w_kfid23

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_acc_ymd, ls_pre_mm
long ll_row

ll_row = dw_ip.GetRow()
if ll_row < 1 then return -1
if dw_ip.AcceptText() = -1 then return -1

ls_acc_ymd = dw_ip.GetItemString(ll_row, 'acc_ymd')

if trim(ls_acc_ymd) = '' or isnull(ls_acc_ymd) then 
	F_MessageChk(1, "[기준일자]")
	dw_ip.SetColumn('acc_ymd')
	dw_ip.SetFocus()
	return -1
else 
	if f_datechk(ls_acc_ymd+'0101') = -1 then 
		F_MessageChk(21, "[기준일자]")
		dw_ip.SetColumn('acc_ymd')
		dw_ip.SetFocus()
		return -1		
	end if
end if

dw_list.SetRedraw(false)

if dw_print.retrieve(ls_acc_ymd) < 1 then 
	F_MessageChk(14, "")
	dw_ip.SetColumn('acc_ymd')
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	//return -1
end if
dw_print.sharedata(dw_list)
dw_list.SetRedraw(true)

return 1
end function

on w_kfid23.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfid23.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.GetRow(), 'acc_ymd', left(f_today(), 4))
dw_ip.SetColumn('acc_ymd')
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_kfid23
integer x = 4069
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_kfid23
integer x = 4416
integer y = 12
end type

type p_print from w_standard_print`p_print within w_kfid23
integer x = 4242
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfid23
integer x = 3895
integer y = 12
end type







type st_10 from w_standard_print`st_10 within w_kfid23
end type



type dw_print from w_standard_print`dw_print within w_kfid23
string dataobject = "dw_kfid232_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfid23
integer x = 50
integer width = 3241
integer height = 156
string dataobject = "dw_kfid231"
end type

event dw_ip::itemchanged;string ls_acc_ymd,sPrtGbn

if this.GetColumnName() ='acc_ymd' then
	ls_acc_ymd = this.GetText()
	if trim(ls_acc_ymd) = '' or isnull(ls_acc_ymd) then
		F_MessageChk(1, "[기준일자]")
		return 1
	else 
		if f_datechk(ls_acc_ymd+'0101') = -1 then
			F_MessageChk(21, "[기준일자]")
			return 1
		end if
	end if
end if

if this.GetColumnName() ='gubun' then
	sPrtGbn = this.GetText()
	if sPrtGbn = '' or IsNull(sPrtGbn) then Return
	
	dw_list.SetRedraw(False)
	dw_print.SetRedraw(False)
	if sPrtGbn = '1' then
		dw_list.DataObject  = 'dw_kfid232'
		dw_print.DataObject = 'dw_kfid232_p' 
	elseif sPrtGbn = '2' then
		dw_list.DataObject  = 'dw_kfid233'
		dw_print.DataObject = 'dw_kfid233_p' 
	elseif sPrtGbn = '3' then
		dw_list.DataObject  = 'dw_kfid234'
		dw_print.DataObject = 'dw_kfid234_p' 
	end if
	dw_list.SetRedraw(True)
	dw_print.SetRedraw(True)
	
	dw_list.SetTransObject(Sqlca)
	dw_print.SetTransObject(Sqlca)
end if
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_kfid23
integer x = 69
integer y = 184
integer width = 4512
integer height = 2064
string title = "대출금현황"
string dataobject = "dw_kfid232"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfid23
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 176
integer width = 4549
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

