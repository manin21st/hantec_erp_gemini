$PBExportHeader$w_kfic14.srw
$PBExportComments$리스설비현황 조회출력
forward
global type w_kfic14 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfic14
end type
end forward

global type w_kfic14 from w_standard_print
integer x = 0
integer y = 0
string title = "리스설비현황"
rr_1 rr_1
end type
global w_kfic14 w_kfic14

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_lsno, ls_accdate

if dw_ip.accepttext() = -1 then return -1

ls_accdate = dw_ip.Getitemstring(1, 'acc_date')
ls_lsno = dw_ip.getitemstring(1, "lsno")

dw_list.object.t_1.text = ls_lsno
dw_print.object.t_1.text = ls_lsno

If ls_accdate = "" or Isnull(ls_accdate) then
	f_messagechk(1,'[기준일자]')
	dw_ip.Setcolumn('acc_date')
	dw_ip.Setfocus()
	Return -1 
ELSE
	IF f_datechk(ls_accdate) = -1 THEN
		f_messagechk(23, "")
		dw_ip.SetColumn("acc_date")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF
	
if ls_lsno = "" or isnull(ls_lsno) then
	ls_lsno = '%'
	dw_list.object.t_1.text = '전체'
	dw_print.object.t_1.text = '전체'
end if

//if dw_list.retrieve(ls_accdate, ls_lsno) <= 0 then
//	messagebox("확인", "조회한 자료가 없습니다.!!!")
//	return -1
//end if

IF dw_print.retrieve(ls_accdate, ls_lsno) <= 0 then
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_kfic14.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfic14.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Setitem(1,'acc_date',f_today())
end event

type p_preview from w_standard_print`p_preview within w_kfic14
end type

type p_exit from w_standard_print`p_exit within w_kfic14
end type

type p_print from w_standard_print`p_print within w_kfic14
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfic14
end type



type sle_msg from w_standard_print`sle_msg within w_kfic14
integer x = 384
end type

type dw_datetime from w_standard_print`dw_datetime within w_kfic14
integer x = 2825
end type

type st_10 from w_standard_print`st_10 within w_kfic14
integer x = 23
end type

type gb_10 from w_standard_print`gb_10 within w_kfic14
integer x = 5
integer width = 3584
end type

type dw_print from w_standard_print`dw_print within w_kfic14
string dataobject = "d_kfic14_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfic14
integer x = 18
integer width = 1138
integer height = 276
string dataobject = "d_kfic14_1"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;string snull

SetNull(gs_code)
SetNull(gs_codename)
setnull(snull)

if dw_ip.accepttext() = -1 then return

IF dw_ip.GetColumnName() = "lsno" THEN
	gs_code = dw_ip.getitemstring(1, "lsno")	
	
	if isnull(gs_code) then gs_code = ""
	
	Open(w_kfic10_popup)
	
	IF IsNull(gs_code) THEN
		dw_ip.SetItem(1, "lsno", snull)
		RETURN
	else	
		dw_ip.SetItem(1, "lsno", gs_code)
	end if
	
end if

	
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfic14
integer x = 46
integer y = 316
integer width = 4558
integer height = 2008
string title = "리스설비 현황"
string dataobject = "d_kfic14_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfic14
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 296
integer width = 4608
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

