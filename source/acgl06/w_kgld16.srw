$PBExportHeader$w_kgld16.srw
$PBExportComments$건설가계정 발생내역 조회 출력
forward
global type w_kgld16 from w_standard_print
end type
type rr_2 from roundrectangle within w_kgld16
end type
end forward

global type w_kgld16 from w_standard_print
integer x = 0
integer y = 0
string title = "건설가계정 발생내역 조회 출력"
rr_2 rr_2
end type
global w_kgld16 w_kgld16

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sKwanNo,sSysDate,sBefDate

IF dw_ip.AcceptText() = -1 then return -1

sKwanNo = dw_ip.GetItemString(dw_ip.GetRow(),"kwan_no")

IF sKwanNo = "" OR IsNull(sKwanNo) THEN
	sKwanNo = "%"
ELSE
	sKwanNo = "%"+sKwanNo+"%"
END IF

sSysDate = F_Today()

Select to_char(add_months(:sSysDate,-5),'yyyymmdd')
  Into :sBefDate
  From Dual;

IF dw_print.Retrieve(sKwanNo,sSysDate,sBefDate) <= 0 then
	F_MessageChk(14,'')
	Return -1
END IF

Return 1
end function

on w_kgld16.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_kgld16.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

type p_preview from w_standard_print`p_preview within w_kgld16
end type

type p_exit from w_standard_print`p_exit within w_kgld16
end type

type p_print from w_standard_print`p_print within w_kgld16
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld16
end type

type st_window from w_standard_print`st_window within w_kgld16
integer x = 2409
integer width = 462
end type

type sle_msg from w_standard_print`sle_msg within w_kgld16
integer width = 2011
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgld16
integer x = 2866
end type

type st_10 from w_standard_print`st_10 within w_kgld16
end type

type gb_10 from w_standard_print`gb_10 within w_kgld16
integer width = 3616
end type

type dw_print from w_standard_print`dw_print within w_kgld16
integer x = 3771
string dataobject = "dw_kgld162_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld16
integer x = 32
integer width = 1175
integer height = 156
string dataobject = "dw_kgld161"
end type

type dw_list from w_standard_print`dw_list within w_kgld16
integer x = 46
integer y = 180
integer width = 4558
integer height = 2028
string title = "건설가계정 발생내역"
string dataobject = "dw_kgld162"
boolean border = false
end type

type rr_2 from roundrectangle within w_kgld16
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 172
integer width = 4576
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

