$PBExportHeader$w_kfic17.srw
$PBExportComments$기준일자별 리스현황 조회출력
forward
global type w_kfic17 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfic17
end type
end forward

global type w_kfic17 from w_standard_print
integer x = 0
integer y = 0
string title = "기준일자별 리스현황"
rr_1 rr_1
end type
global w_kfic17 w_kfic17

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_gidate

if dw_ip.accepttext() = -1 then return -1

ls_gidate = dw_ip.getitemstring(1, "gidate")

if ls_gidate = "" or isnull(ls_gidate) then
	f_messagechk(1, "[기준일자]")
	dw_ip.setcolumn("gidate")
	dw_ip.setfocus()
	return -1 
end if

dw_list.object.t_1.text = string(ls_gidate, "@@@@.@@.@@")
dw_print.object.t_3.text = string(ls_gidate, "@@@@.@@.@@")

//if dw_list.retrieve(ls_gidate) <= 0 then
//	messagebox("확인", "조회한 자료가 없습니다.!!!")
//	return -1 
//end if

IF dw_print.retrieve(ls_gidate) <= 0 then
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1

end function

on w_kfic17.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfic17.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string s_gidate 

s_gidate = f_today()
dw_ip.setitem(dw_ip.getrow(), "gidate", s_gidate)
end event

type p_preview from w_standard_print`p_preview within w_kfic17
end type

type p_exit from w_standard_print`p_exit within w_kfic17
end type

type p_print from w_standard_print`p_print within w_kfic17
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfic17
end type







type st_10 from w_standard_print`st_10 within w_kfic17
end type



type dw_print from w_standard_print`dw_print within w_kfic17
string dataobject = "d_kfic17_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfic17
integer x = 27
integer y = 48
integer width = 727
integer height = 164
string dataobject = "d_kfic17"
end type

event dw_ip::itemchanged;call super::itemchanged;string ls_gidate

if this.getcolumnname() = "gidate" then
	ls_gidate = this.gettext()
	if f_datechk(ls_gidate) = -1 then
		messagebox("확인", "기준일자를 확인하십시오.")
		this.setcolumn("gidate")
		this.setfocus()
		return
	end if 
end if
end event

type dw_list from w_standard_print`dw_list within w_kfic17
integer x = 55
integer y = 264
integer width = 4553
integer height = 2060
string dataobject = "d_kfic17_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfic17
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 240
integer width = 4594
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

