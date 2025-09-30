$PBExportHeader$w_kfid07.srw
$PBExportComments$차입금 카드 조회출력
forward
global type w_kfid07 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfid07
end type
end forward

global type w_kfid07 from w_standard_print
string title = "차입금 카드 조회 출력"
rr_1 rr_1
end type
global w_kfid07 w_kfid07

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_lono, ls_frdate, ls_todate

setnull(ls_lono)
setnull(ls_frdate)
setnull(ls_todate)

if dw_ip.accepttext() = -1 then return -1 

ls_lono = dw_ip.getitemstring(dw_ip.getrow(), "lono")
ls_frdate = dw_ip.getitemstring(dw_ip.getrow(), "frdate")
ls_todate = dw_ip.getitemstring(dw_ip.getrow(), "todate")

if ls_lono = "" or isnull(ls_lono) then
	ls_lono = '%'
end if

if ls_frdate = "" or isnull(ls_frdate) then
	ls_frdate = '19000101'
end if

if ls_todate = "" or isnull(ls_todate) then
	ls_todate = '99991231'
end if

//if dw_list.retrieve(ls_lono, ls_frdate, ls_todate) <= 0 then
//	messagebox("확인", "조회한 자료가 없습니다.!!")
//	dw_ip.setcolumn("lono")
//	dw_ip.setfocus()
//	return -1 
//end if

IF dw_print.retrieve(ls_lono, ls_frdate, ls_todate) <= 0 then
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_kfid07.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfid07.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "frdate", f_today())
dw_ip.setitem(1, "todate", f_today())

end event

type p_preview from w_standard_print`p_preview within w_kfid07
end type

type p_exit from w_standard_print`p_exit within w_kfid07
end type

type p_print from w_standard_print`p_print within w_kfid07
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfid07
end type







type st_10 from w_standard_print`st_10 within w_kfid07
end type



type dw_print from w_standard_print`dw_print within w_kfid07
string dataobject = "d_kfid07_1"
end type

type dw_ip from w_standard_print`dw_ip within w_kfid07
integer x = 27
integer y = 0
integer width = 1655
string dataobject = "d_kfid07"
end type

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)

this.accepttext()

if this.getcolumnname() = "lono" then
	gs_code = dw_ip.getitemstring(dw_ip.getrow(), "lono")
   gs_codename = dw_ip.getitemstring(dw_ip.getrow(), "lonm")
	
	if isnull(gs_code) then gs_code = ""
	
	open(w_kfm03ot0_popup)
	
//	if isnull(gs_code) then return	
	dw_ip.setitem(dw_ip.getrow(), "lono", gs_code)
	dw_ip.setitem(dw_ip.getrow(), "lonm", gs_codename)

end if
end event

event dw_ip::itemchanged;call super::itemchanged;string ls_lono, ls_lonm, snull

setnull(snull)

if this.getcolumnname() = "lono" then
	ls_lono = this.gettext()
	if ls_lono = "" or isnull(ls_lono) then
		this.setitem(dw_ip.getrow(), "lono", snull)
		this.setitem(dw_ip.getrow(), "lonm", snull)
	end if 
	
//	SELECT LO_NAME
//	  INTO :ls_lonm
//	  FROM KFM03OT0
//	 WHERE LO_CD = :ls_lono ;
//	 
// 	if sqlca.sqlcode <> 0 then
//		dw_ip.setitem(dw_ip.getrow(), "lono", snull)
//		dw_ip.setitem(dw_ip.getrow(), "lonm", snull)
//		dw_ip.setcolumn("lono")
//		dw_ip.setfocus()
//		return
//	else 
//		dw_ip.setitem(dw_ip.getrow(), "lonm", ls_lonm)
//	end if 
end if
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfid07
integer x = 41
integer y = 280
integer width = 4526
integer height = 1932
string dataobject = "d_kfid07_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfid07
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 272
integer width = 4567
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 55
end type

