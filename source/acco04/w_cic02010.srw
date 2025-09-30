$PBExportHeader$w_cic02010.srw
$PBExportComments$원부재료수불집계
forward
global type w_cic02010 from w_standard_print
end type
end forward

global type w_cic02010 from w_standard_print
string title = "원부재료수불집계"
end type
global w_cic02010 w_cic02010

type variables
string is_fyymm, is_tyymm, is_saupj
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string snull, ls_ittyp
SetNull(snull)

if dw_ip.Accepttext() = -1 then return -1

if IsNull(is_fyymm) or is_fyymm = "" or IsNull(is_tyymm) or is_tyymm = "" then
	 messagebox("확인","조회년월을 입력하세요!")
	 dw_ip.SetColumn("fyymm")
	 dw_ip.Setfocus()
	 return -1
end if

IF is_saupj = '%' THEN
	dw_print.modify("saupj_t.text = '"+'전체'+"'")
ELSE
   dw_print.modify("saupj_t.text = '" + Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj)', 1)")) + "'")
END IF

ls_ittyp = dw_ip.GetItemString(1,"ittyp")

if IsNull(ls_ittyp) or ls_ittyp = "" then ls_ittyp = '%'

if dw_print.Retrieve(is_saupj, is_fyymm, is_tyymm, ls_ittyp) < 1 then
	 w_mdi_frame.sle_msg.text = "조회할 자료가 없습니다!"
   return -1
end if

return 1
end function

on w_cic02010.create
call super::create
end on

on w_cic02010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;String sWorkym
SELECT  nvl(max(workym),substr(to_char(sysdate,'yyyymmdd'),1,6))
   INTO  :sWorkym
   FROM  cic0100;
	
dw_ip.Setitem(1,"saupj", gs_saupj)
//dw_ip.Setitem(1, "fyymm", left(f_today(),4) +'01')
//dw_ip.Setitem(1, "tyymm", left(f_aftermonth(f_today(), -1),6))
//
//is_fyymm = left(f_today(),4) +'01'
//is_tyymm = left(f_aftermonth(f_today(), -1),6)

dw_ip.Setitem(1, "fyymm", left(sWorkym,4) +'01')
dw_ip.Setitem(1, "tyymm", sWorkym)

is_fyymm = left(sWorkym,4) +'01'
is_tyymm = sWorkym

is_saupj = gs_saupj
end event

type p_xls from w_standard_print`p_xls within w_cic02010
end type

type p_sort from w_standard_print`p_sort within w_cic02010
end type

type p_preview from w_standard_print`p_preview within w_cic02010
end type

type p_exit from w_standard_print`p_exit within w_cic02010
end type

type p_print from w_standard_print`p_print within w_cic02010
end type

type p_retrieve from w_standard_print`p_retrieve within w_cic02010
end type







type st_10 from w_standard_print`st_10 within w_cic02010
end type



type dw_print from w_standard_print`dw_print within w_cic02010
string dataobject = "dw_cic02010_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cic02010
integer width = 3067
integer height = 216
string dataobject = "dw_cic02010_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string snull
SetNull(snull)

if dw_ip.Accepttext() = -1 then return

if This.GetColumnName() = "fyymm" then
	is_fyymm = This.Gettext()
	if IsNull(is_fyymm) or is_fyymm = "" then 
	 	 messagebox("확인","년월을 입력하세요!")
		 dw_ip.SetItem(1,"fyymm", snull)
		 dw_ip.SetColumn("fyymm")
		 dw_ip.Setfocus()
		 return
	end if

	if f_datechk(is_fyymm+'01') = -1 then
		messagebox("확인","년월을 확인하세요!")
		dw_ip.SetItem(1,"fyymm", snull)
		dw_ip.SetColumn("fyymm")
		dw_ip.Setfocus()
		return
	end if	
end if	

if This.GetColumnName() = "tyymm" then
	is_tyymm = This.Gettext()
	if IsNull(is_tyymm) or is_tyymm = "" then 
	 	 messagebox("확인","년월을 입력하세요!")
		 dw_ip.SetItem(1,"tyymm", snull)
		 dw_ip.SetColumn("tyymm")
		 dw_ip.Setfocus()
		 return
	end if

	if f_datechk(is_tyymm+'01') = -1 then
		messagebox("확인","년월을 확인하세요!")
		dw_ip.SetItem(1,"tyymm", snull)
		dw_ip.SetColumn("tyymm")
		dw_ip.Setfocus()
		return
	end if	
end if	

if is_fyymm > is_tyymm then
	 messagebox("확인","시작년월이 종료년월보다 클 수 없습니다!")
	 dw_ip.SetItem(1,"fyymm", snull)
	 dw_ip.SetColumn("fyymm")
	 dw_ip.Setfocus()
	 return
end if


if This.GetColumnName() = "saupj" then
	is_saupj = This.Gettext()
	if IsNull(is_saupj) or is_saupj = "" then is_saupj = '%'
end if


end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_cic02010
integer y = 232
integer height = 2020
string dataobject = "dw_cic02010_2"
end type

