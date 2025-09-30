$PBExportHeader$w_kfic13.srw
$PBExportComments$리스현황 조회 출력
forward
global type w_kfic13 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfic13
end type
end forward

global type w_kfic13 from w_standard_print
integer x = 0
integer y = 0
string title = "리스현황 조회 출력"
rr_1 rr_1
end type
global w_kfic13 w_kfic13

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string s_giyear, s_giyear2, s_giyear3, s_giyear4

if dw_ip.accepttext() = -1 then return -1

s_giyear = dw_ip.getitemstring(1, "giyear")

if s_giyear = "" or isnull(s_giyear) then
	f_messagechk(1, "[기준년도]")
	dw_ip.setcolumn("giyear")
	dw_ip.setfocus()
	return -1 
end if

dw_list.object.giyear.text = string(s_giyear, "@@@@")
dw_list.object.ym1.text = s_giyear + "년"
dw_list.object.ym2.text = string(integer(left(s_giyear, 4)) + 1) + "년"
dw_list.object.ym3.text = string(integer(left(s_giyear, 4)) + 2) + "년"
dw_list.object.ym4.text = string(integer(left(s_giyear, 4)) + 3) + "년 이후" 

dw_print.object.giyear.text = string(s_giyear, "@@@@")
dw_print.object.ym1.text = s_giyear + "년"
dw_print.object.ym2.text = string(integer(left(s_giyear, 4)) + 1) + "년"
dw_print.object.ym3.text = string(integer(left(s_giyear, 4)) + 2) + "년"
dw_print.object.ym4.text = string(integer(left(s_giyear, 4)) + 3) + "년 이후" 

s_giyear2 = left(dw_list.object.ym2.text, 4)
s_giyear3 = left(dw_list.object.ym3.text , 4)
s_giyear4 = left(dw_list.object.ym4.text  , 4)

//if dw_list.retrieve(s_giyear, s_giyear2, s_giyear3, s_giyear4) <= 0 then
//	messagebox("확인", "조회한 자료가 없습니다.")
//	return -1 
//end if
 
IF dw_print.retrieve(s_giyear, s_giyear2, s_giyear3, s_giyear4) <= 0 then
	f_message_chk(50,"[리스 현황]")
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
	
end function

on w_kfic13.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfic13.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string s_giyear

s_giyear= left(f_today(), 4)

dw_ip.setitem(1, "giyear", s_giyear)
end event

type p_preview from w_standard_print`p_preview within w_kfic13
end type

type p_exit from w_standard_print`p_exit within w_kfic13
end type

type p_print from w_standard_print`p_print within w_kfic13
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfic13
end type







type st_10 from w_standard_print`st_10 within w_kfic13
end type



type dw_print from w_standard_print`dw_print within w_kfic13
string dataobject = "d_kfic13_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfic13
integer x = 27
integer y = 32
integer width = 649
integer height = 136
string dataobject = "d_kfic13"
end type

type dw_list from w_standard_print`dw_list within w_kfic13
integer x = 50
integer y = 248
integer width = 4553
integer height = 2076
string title = "리스현황 조회 출력"
string dataobject = "d_kfic13_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfic13
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 228
integer width = 4594
integer height = 2120
integer cornerheight = 40
integer cornerwidth = 55
end type

