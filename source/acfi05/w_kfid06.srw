$PBExportHeader$w_kfid06.srw
$PBExportComments$용도별 차입금 집계표
forward
global type w_kfid06 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfid06
end type
end forward

global type w_kfid06 from w_standard_print
string title = "용도별 차입금 집계표"
rr_1 rr_1
end type
global w_kfid06 w_kfid06

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_frdate, ls_gidate, ls_bnkcd, ls_lono

if dw_ip.accepttext() = -1 then return -1

ls_gidate = dw_ip.getitemstring(dw_ip.getrow(), "gidate")
ls_frdate = left(ls_gidate, 6) + '01'
ls_bnkcd = dw_ip.getitemstring(dw_ip.getrow(), "bnkcd")
ls_lono = dw_ip.getitemstring(dw_ip.getrow(), "lono")

if ls_gidate = "" or isnull(ls_gidate) then
	f_messagechk(1, "[기준일자]")
	dw_ip.setcolumn("gidate")
	dw_ip.setfocus()
	return -1 
end if

if f_datechk(ls_gidate) = -1 then
	messagebox("확인", "유효한 일자가 아닙니다.!!")
	dw_ip.setcolumn("gidate")
	dw_ip.setfocus()
	return -1 
end if

if ls_bnkcd = "" or isnull(ls_bnkcd) then
	ls_bnkcd = '%'
end if

if ls_lono = "" or isnull(ls_lono) then
	ls_lono = '%'
end if

dw_list.object.gidate.text = string(ls_gidate, '@@@@.@@.@@')
dw_print.object.gidate.text = string(ls_gidate, '@@@@.@@.@@')

//if dw_list.retrieve(ls_frdate, ls_gidate, ls_bnkcd, ls_lono) <= 0 then
//	messagebox("확인", "조회한 자료가 없습니다.!!")
//	dw_ip.setcolumn("gidate")
//	dw_ip.setfocus()
//	return -1 
//end if

IF dw_print.retrieve(ls_frdate, ls_gidate, ls_bnkcd, ls_lono) <= 0 then
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1

end function

on w_kfid06.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfid06.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1, "gidate", f_today())
end event

type p_preview from w_standard_print`p_preview within w_kfid06
end type

type p_exit from w_standard_print`p_exit within w_kfid06
end type

type p_print from w_standard_print`p_print within w_kfid06
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfid06
end type







type st_10 from w_standard_print`st_10 within w_kfid06
end type



type dw_print from w_standard_print`dw_print within w_kfid06
string dataobject = "d_kfid06_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfid06
integer y = 12
integer width = 3182
integer height = 204
string dataobject = "d_kfid06"
end type

event dw_ip::rbuttondown;call super::rbuttondown;SetNUll(lstr_custom.code)
SetNUll(lstr_custom.name)
setnull(gs_code)
setnull(gs_codename)

this.accepttext()

if this.GetColumnName() = 'bnkcd' then
	
	lstr_custom.code = this.object.bnkcd[1]
	
	OpenWithParm(w_kfz04om0_popup, '2')
	
   this.SetItem(this.GetRow(), 'bnkcd', lstr_custom.code)
   this.SetItem(this.GetRow(), 'bnknm', lstr_custom.name)
elseif this.getcolumnname() = "lono" then
	gs_code = dw_ip.getitemstring(dw_ip.getrow(), "lono")
   gs_codename = dw_ip.getitemstring(dw_ip.getrow(), "lonm")
	
	if isnull(gs_code) then gs_code = ""
	
	open(w_kfm03ot0_popup)
	
//	if isnull(gs_code) then return
	
	dw_ip.setitem(dw_ip.getrow(), "lono", gs_code)
	dw_ip.setitem(dw_ip.getrow(), "lonm", gs_codename)

end if
end event

event dw_ip::itemchanged;call super::itemchanged;string ls_bnkcd, ls_bnknm, ls_lono, ls_lonm, snull

setnull(snull)

if this.getcolumnname() = "bnkcd" then
	ls_bnkcd = this.gettext()
	if ls_bnkcd = "" or isnull(ls_bnkcd) then
		this.setitem(dw_ip.getrow(), "bnkcd", snull)
		this.setitem(dw_ip.getrow(), "bnknm", snull)
	end if
		
//	SELECT PERSON_NM
//	  INTO :ls_bnknm
//	  FROM KFZ04OM0_v2
//	 WHERE PERSON_CD = :ls_bnkcd 
//	   AND PERSON_GU = '2' ;
//		
//   if sqlca.sqlcode <> 0 then
//		dw_ip.setitem(dw_ip.getrow(), "bnkcd", snull)
//		dw_ip.setitem(dw_ip.getrow(), "bnknm", snull)
//		dw_ip.setcolumn("bnkcd")
//		dw_ip.setfocus()
//		return
//	else
//		dw_ip.setitem(dw_ip.getrow(), "bnknm", ls_bnknm)
//	end if
end if

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

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfid06
integer x = 59
integer y = 228
integer width = 4562
integer height = 1972
string dataobject = "d_kfid06_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfid06
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 220
integer width = 4594
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

