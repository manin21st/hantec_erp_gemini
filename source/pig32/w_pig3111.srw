$PBExportHeader$w_pig3111.srw
$PBExportComments$차량이력  - 출력
forward
global type w_pig3111 from w_standard_print
end type
end forward

global type w_pig3111 from w_standard_print
end type
global w_pig3111 w_pig3111

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_carno, ls_costgbn, ls_status

ls_carno = Trim(dw_ip.GetItemString(1,"carno"))
ls_costgbn = dw_ip.GetItemString(1,"costgbn")
ls_status = dw_ip.GetItemString(1, "status")

if ls_carno = ''  or IsNull(ls_carno) then
	ls_carno = '%'
end if

if ls_costgbn = ''  or  IsNull(ls_costgbn) then
	ls_costgbn = '%'
end if

if ls_status = ''  or IsNull(ls_status) then
	ls_status = '%'
end if

if dw_Print.Retrieve(ls_carno, ls_costgbn,ls_status) < 1 then
	messagebox("자료확인","해당자료가 없습니다.")
	return -1;
end if
dw_print.Sharedata(dw_list)
return 1

end function

on w_pig3111.create
call super::create
end on

on w_pig3111.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

dw_list.Modify("carno.protect = 1")
dw_list.Modify("jdate.protect = 1")
dw_list.Modify("costgbn.protect = 1")
dw_list.Modify("costmemo.protect = 1")
dw_list.Modify("costamt.protect = 1")
dw_list.Modify("remark.protect = 1")
end event

type p_preview from w_standard_print`p_preview within w_pig3111
end type

type p_exit from w_standard_print`p_exit within w_pig3111
end type

type p_print from w_standard_print`p_print within w_pig3111
end type

type p_retrieve from w_standard_print`p_retrieve within w_pig3111
end type







type st_10 from w_standard_print`st_10 within w_pig3111
end type



type dw_print from w_standard_print`dw_print within w_pig3111
string dataobject = "d_pig3111_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pig3111
integer width = 3319
integer height = 240
string dataobject = "d_pig3111_1"
end type

event dw_ip::rbuttondown;call super::rbuttondown;open(w_car_popup)

dw_ip.SetItem(1, "carno", gs_code)
end event

type dw_list from w_standard_print`dw_list within w_pig3111
string dataobject = "d_pig3110_3"
end type

