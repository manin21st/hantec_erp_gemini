$PBExportHeader$w_kfic16.srw
$PBExportComments$년도별 리스현황 조회출력
forward
global type w_kfic16 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfic16
end type
end forward

global type w_kfic16 from w_standard_print
integer x = 0
integer y = 0
string title = "년도별 리스현황 조회출력"
rr_1 rr_1
end type
global w_kfic16 w_kfic16

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_year, ls_lscono, ls_lsco, ls_lsno, snull, ls_year2, &
       ls_year3, ls_year4, ls_year5, ls_year6, ls_year7, sClosing_date
decimal ld_currate

if dw_ip.accepttext() = -1 then return -1

setnull(snull)

ls_year = dw_ip.getitemstring(dw_ip.getrow(), "giyear")
ls_lscono = dw_ip.getitemstring(dw_ip.getrow(), "lscono")
ls_lsno = dw_ip.getitemstring(dw_ip.getrow(), "lsno")

if ls_year = "" or isnull(ls_year) then
	f_messagechk(1, "[기준년도]")
	dw_ip.setcolumn("giyear")
	dw_ip.setfocus()
	return -1
end if

SELECT CLOSING_DATE
  into :sClosing_date
  FROM KFZ34OT1
 WHERE CLOSING_DATE <= :ls_year||'1231'
   AND ROWNUM = 1;

if sqlca.sqlcode <> 0 then
	messagebox("확인", "적용할 환율이 없습니다. 먼저 환율을 등록하십시오!!")
	dw_ip.setfocus()
	return -1
end if 

if ls_lscono = "" or isnull(ls_lscono) then
	ls_lscono = '%'
end if

if ls_lsno = "" or isnull(ls_lsno) then
	ls_lsno = '%'
end if

dw_list.object.t_1.text = ls_year + "년"
dw_list.object.txt_1.text = ls_year + "년"
dw_list.object.txt_2.text = string(integer(ls_year)+1) + "년"  
dw_list.object.txt_3.text = string(integer(ls_year)+2) + "년"  
dw_list.object.txt_4.text = string(integer(ls_year)+3) + "년"  
dw_list.object.txt_5.text = string(integer(ls_year)+4) + "년"  
dw_list.object.txt_6.text = string(integer(ls_year)+5) + "년"  
dw_list.object.txt_7.text = string(integer(ls_year)+6) + "년"  

dw_print.object.t_year.text = ls_year + "년"
dw_print.object.txt_1.text = ls_year + "년"
dw_print.object.txt_2.text = string(integer(ls_year)+1) + "년"  
dw_print.object.txt_3.text = string(integer(ls_year)+2) + "년"  
dw_print.object.txt_4.text = string(integer(ls_year)+3) + "년"  
dw_print.object.txt_5.text = string(integer(ls_year)+4) + "년"  
dw_print.object.txt_6.text = string(integer(ls_year)+5) + "년"  
dw_print.object.txt_7.text = string(integer(ls_year)+6) + "년"  

ls_year2 = string(integer(ls_year)+1)
ls_year3 = string(integer(ls_year)+2)
ls_year4 = string(integer(ls_year)+3)
ls_year5 = string(integer(ls_year)+4)
ls_year6 = string(integer(ls_year)+5)
ls_year7 = string(integer(ls_year)+6)


//if dw_list.retrieve(ls_year, ls_year2, ls_year3, ls_year4, ls_year5, ls_year6, &
//                    ls_year7, ls_lscono, ls_lsno) <= 0 then
//   messagebox("확인", "조회된 자료가 없습니다.")
//	return -1 
//end if 

IF dw_print.retrieve(ls_year, ls_year2, ls_year3, ls_year4, ls_year5, ls_year6, &
                    ls_year7, ls_lscono, ls_lsno) <= 0 then
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1

end function

on w_kfic16.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfic16.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string ls_year

ls_year = left(f_today(), 4)

dw_ip.setitem(dw_ip.getrow(), "giyear", ls_year)
end event

type p_preview from w_standard_print`p_preview within w_kfic16
end type

type p_exit from w_standard_print`p_exit within w_kfic16
end type

type p_print from w_standard_print`p_print within w_kfic16
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfic16
end type







type st_10 from w_standard_print`st_10 within w_kfic16
end type



type dw_print from w_standard_print`dw_print within w_kfic16
string dataobject = "d_kfic16_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfic16
integer x = 5
integer y = 4
integer width = 2309
integer height = 252
string dataobject = "d_kfic16"
end type

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)

this.accepttext()

if this.getcolumnname() = "lsno" then
   gs_code = dw_ip.getitemstring(dw_ip.getrow(), "lsno")
	if isnull(gs_code) then gs_code = ""
	
	open(w_kfic10_popup)
	
	if isnull(gs_code) then return
	
	dw_ip.setitem(dw_ip.getrow(), "lsno", gs_code)
//	p_retrieve.TriggerEvent(clicked!)
	
end if
	
if this.getcolumnname() = "lscono" then
	gs_code = dw_ip.getitemstring(dw_ip.getrow(), "lscono")
   gs_codename = dw_ip.getitemstring(dw_ip.getrow(), "lsco")
	
	if isnull(gs_code) then gs_code = ""
	
	open(w_kfic10_popup1)
	
	if isnull(gs_code) then return
	
	dw_ip.setitem(dw_ip.getrow(), "lscono", gs_code)
	dw_ip.setitem(dw_ip.getrow(), "lsco", gs_codename)
//	p_retrieve.TriggerEvent(clicked!)
	
end if	
	
	
	
end event

event dw_ip::itemchanged;call super::itemchanged;string ls_lscono, ls_lsco, snull

setnull(snull)

if this.getcolumnname() = "lscono" then
	ls_lscono = this.gettext()
	if ls_lscono = "" or isnull(ls_lscono) then
		this.setitem(dw_ip.getrow(), "lscono", snull)
		this.setitem(dw_ip.getrow(), "lsco", snull)
	end if

	SELECT "LSCO"
  	INTO :ls_lsco
 	FROM "KFM20M"
 	WHERE "LSCONO" = :ls_lscono ;
	 
 	if sqlca.sqlcode <> 0 then
//	 	dw_ip.setitem(dw_ip.getrow(), "lscono", snull)
//		 dw_ip.setitem(dw_ip.getrow(), "lsco", snull)		 
//   	 dw_ip.setcolumn("lscono")
//		 dw_ip.setfocus()
//		 return 
	else
 	 	dw_ip.setitem(dw_ip.getrow(), "lsco", ls_lsco)
	end if
end if
end event

event dw_ip::getfocus;call super::getfocus;this.accepttext()
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfic16
integer x = 32
integer y = 284
integer width = 4571
integer height = 2040
string dataobject = "d_kfic16_1"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfic16
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 272
integer width = 4617
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

