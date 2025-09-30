$PBExportHeader$w_kfia55.srw
$PBExportComments$정기예,적금 은행별 합계표 조회 및 출력
forward
global type w_kfia55 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia55
end type
end forward

global type w_kfia55 from w_standard_print
integer x = 0
integer y = 0
string title = "정기예,적금 은행별 합계표"
rr_1 rr_1
end type
global w_kfia55 w_kfia55

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
	if f_datechk(ls_acc_ymd) = -1 then 
		F_MessageChk(21, "[기준일자]")
		dw_ip.SetColumn('acc_ymd')
		dw_ip.SetFocus()
		return -1		
	end if
end if

ls_pre_mm = mid(ls_acc_ymd, 5, 2)

if ls_pre_mm = '01' then 
	ls_pre_mm = '00'
else
	ls_pre_mm = string(long(ls_pre_mm) - 1, '00')
end if

dw_list.SetRedraw(false)

if dw_print.retrieve(ls_acc_ymd, ls_pre_mm) < 1 then 
	F_MessageChk(14, "")
	dw_list.reset()
	dw_list.insertrow(0)
	dw_ip.SetColumn('acc_ymd')
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	//return -1
end if

dw_print.object.acc_ymd_t.text = left(ls_acc_ymd, 4) + "." + mid(ls_acc_ymd, 5, 2) + &
                            "." + right(ls_acc_ymd, 2)
									 
dw_print.sharedata(dw_list)
dw_list.SetRedraw(true)

return 1
end function

on w_kfia55.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia55.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

dw_ip.SetItem(dw_ip.GetRow(), 'acc_ymd', f_today())
dw_ip.SetColumn('acc_ymd')
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_kfia55
end type

type p_exit from w_standard_print`p_exit within w_kfia55
end type

type p_print from w_standard_print`p_print within w_kfia55
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia55
end type







type st_10 from w_standard_print`st_10 within w_kfia55
end type



type dw_print from w_standard_print`dw_print within w_kfia55
string dataobject = "dw_kfia55_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia55
integer x = 46
integer y = 56
integer width = 960
integer height = 132
string dataobject = "dw_kfia55_01"
end type

event dw_ip::itemchanged;string ls_acc_ymd

if this.GetColumnName() ='acc_ymd' then
	ls_acc_ymd = this.GetText()
	if trim(ls_acc_ymd) = '' or isnull(ls_acc_ymd) then
		F_MessageChk(1, "[기준일자]")
		return 1
	else 
		if f_datechk(ls_acc_ymd) = -1 then
			F_MessageChk(21, "[기준일자]")
			return 1
		end if
	end if
end if
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_kfia55
integer x = 69
integer y = 232
integer width = 4507
integer height = 2056
string title = "정기예,적금 은행별 합계표"
string dataobject = "dw_kfia55_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia55
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 216
integer width = 4549
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

