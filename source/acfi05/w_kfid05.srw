$PBExportHeader$w_kfid05.srw
$PBExportComments$월별 차입금 거래현황 조회출력
forward
global type w_kfid05 from w_standard_print
end type
type dw_1 from datawindow within w_kfid05
end type
type rr_1 from roundrectangle within w_kfid05
end type
type dw_2 from datawindow within w_kfid05
end type
end forward

global type w_kfid05 from w_standard_print
string title = "월별 차입금 거래 현황"
dw_1 dw_1
rr_1 rr_1
dw_2 dw_2
end type
global w_kfid05 w_kfid05

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_accym, ls_bnkcd, ls_lono

dw_print.reset()
if dw_ip.accepttext() = -1 then return -1

ls_accym = dw_ip.getitemstring(dw_ip.getrow(), "accym")
ls_bnkcd = dw_ip.getitemstring(dw_ip.getrow(), "bnkcd")
ls_lono = dw_ip.getitemstring(dw_ip.getrow(), "lono")

if ls_accym = "" or isnull(ls_accym) then
	f_messagechk(1, "[회계년월]")
	dw_ip.setcolumn("accym")
	dw_ip.setfocus()
	return -1 
end if

if f_datechk(ls_accym + '01') = -1 then
	messagebox("확인", "유효한 회계년월이 아닙니다.!!")
	dw_ip.setcolumn("accym")
	dw_ip.setfocus()
	return -1 
end if

if ls_bnkcd = "" or isnull(ls_bnkcd) then
	ls_bnkcd = '%'
end if

if ls_lono = "" or isnull(ls_lono) then
	ls_lono = '%'
end if

//if dw_list.retrieve(ls_accym, ls_bnkcd, ls_lono) <= 0 then
//	messagebox("확인", "조회한 자료가 없습니다.!!")
//	dw_ip.setcolumn("accym")
//	dw_ip.setfocus()
//	return -1 
//end if

long a,b 

 a=dw_1.retrieve(ls_accym, ls_bnkcd, ls_lono)
 b=dw_2.retrieve(ls_accym, ls_bnkcd, ls_lono) 
 
if a>0 or b>0 then
	
  dw_print.retrieve(ls_accym, ls_bnkcd, ls_lono)
 return 1

else

   messagebox("확인", "조회한 자료가 없습니다.!!")
	dw_ip.setcolumn("accym")
	dw_ip.setfocus()

Return -1

end if

return 1
end function

on w_kfid05.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.dw_2
end on

on w_kfid05.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.dw_2)
end on

event open;call super::open;dw_ip.setitem(1, "accym", left(f_today(), 6))

dw_1.setTransObject(sqlca)
dw_2.setTransObject(sqlca)
end event

type p_preview from w_standard_print`p_preview within w_kfid05
end type

type p_exit from w_standard_print`p_exit within w_kfid05
end type

type p_print from w_standard_print`p_print within w_kfid05
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfid05
end type







type st_10 from w_standard_print`st_10 within w_kfid05
end type



type dw_print from w_standard_print`dw_print within w_kfid05
boolean visible = true
integer x = 50
integer y = 276
integer width = 4558
integer height = 1940
string dataobject = "d_kfid05_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_ip from w_standard_print`dw_ip within w_kfid05
integer x = 37
integer y = 4
integer width = 2176
string dataobject = "d_kfid05"
end type

event dw_ip::itemerror;call super::itemerror;return 1 
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
//	 WHERE PERSON_CD like :ls_bnkcd 
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

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfid05
integer x = 69
integer width = 4526
integer height = 1800
string dataobject = "d_kfid05_3"
boolean border = false
end type

type dw_1 from datawindow within w_kfid05
boolean visible = false
integer x = 3666
integer y = 68
integer width = 178
integer height = 168
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_kfid05_1"
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_kfid05
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 268
integer width = 4581
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from datawindow within w_kfid05
boolean visible = false
integer x = 3675
integer y = 80
integer width = 133
integer height = 152
integer taborder = 20
string title = "none"
string dataobject = "d_kfid05_2"
boolean livescroll = true
end type

