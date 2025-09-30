$PBExportHeader$w_pdt_06590.srw
$PBExportComments$** 수리미완료 현황
forward
global type w_pdt_06590 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_06590
end type
end forward

global type w_pdt_06590 from w_standard_print
string title = "수리미완료 현황"
rr_1 rr_1
end type
global w_pdt_06590 w_pdt_06590

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  sgubun, sempno, gub1, gub2, fdptno, tdptno

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sgubun = dw_ip.object.gubun[1]
sempno = trim(dw_ip.object.empno[1])
fdptno = trim(dw_ip.object.fdptno[1])
tdptno = trim(dw_ip.object.tdptno[1])

if IsNull(sempno) or sempno = "" then sempno = "%"
if IsNull(fdptno) or fdptno = "" then fdptno = "."
if IsNull(tdptno) or tdptno = "" then tdptno = "zzzzzz"
//if sgubun = '1' then //테스트 미완료
//   gub1 = 'W'
//	gub2 = '3' 
//else
   gub1 = 'W'
	gub2 = 'W' 
//end if
if dw_print.Retrieve(gs_sabu, gub1, gub2, sempno, fdptno, tdptno) <= 0 then
	f_message_chk(50,"[수리미완료 현황]")
	dw_ip.Setfocus()
	//return -1
	dw_list.insertrow(0)
end if

dw_print.sharedata(dw_list)

return 1
end function

on w_pdt_06590.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_06590.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_pdt_06590
end type

type p_sort from w_standard_print`p_sort within w_pdt_06590
end type

type p_preview from w_standard_print`p_preview within w_pdt_06590
end type

type p_exit from w_standard_print`p_exit within w_pdt_06590
end type

type p_print from w_standard_print`p_print within w_pdt_06590
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_06590
end type







type st_10 from w_standard_print`st_10 within w_pdt_06590
end type



type dw_print from w_standard_print`dw_print within w_pdt_06590
string dataobject = "d_pdt_06590_02"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_06590
integer x = 27
integer y = 12
integer width = 2135
integer height = 204
string dataobject = "d_pdt_06590_01"
end type

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

//gs_gubun = 'ALL'  //구매일자 관계없이 전체

//IF	this.getcolumnname() = "smchno" THEN		
//	open(w_mchno_popup)
//	if gs_code = '' or isnull(gs_code) then return 
//	this.SetItem(1, "smchno", gs_code)
//	this.SetItem(1, "smchnam", gs_codename)
//ELSEIF this.getcolumnname() = "emchno" THEN		
//	open(w_mchno_popup)
//	if gs_code = '' or isnull(gs_code) then return 
//	this.SetItem(1, "emchno", gs_code)
//	this.SetItem(1, "emchnam", gs_codename)
//END IF
//
IF	this.getcolumnname() = "fdptno" THEN		
	open( w_vndmst_4_popup ) 
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "fdptno", gs_code)
ELSEIF this.getcolumnname() = "tdptno" THEN		
	open( w_vndmst_4_popup ) 
	if gs_code = '' or isnull(gs_code) then return 
	this.SetItem(1, "tdptno", gs_code)
END IF

end event

event dw_ip::itemchanged;//String  s_cod, ls_mchnam , snull
//
//setnull(snull)
//
//s_cod = Trim(this.GetText())
//
//if this.GetColumnName() = "smchno" then // 시작 설비번호  
//	
// 	if IsNull(s_cod) or s_cod = ""  then
//		this.object.smchnam[1] = ""
//		return 1
//	end if
//	
//	select mchnam 
//	  into :ls_mchnam
//  	  from mchmst
//	 where sabu = :gs_sabu and mchno = :s_cod ;
//	
//	if sqlca.sqlcode <> 0 then
//		f_message_chk(33, '[관리번호]')
//		this.setitem(1,"smchno", snull )
//		this.setitem(1,"smchnam", snull)
//		return 1
//	end if
//	
//	this.setitem(1,"smchnam", ls_mchnam ) 
//	
//elseif this.GetColumnName() = "emchno" then // 끝 설비번호  
//	
// 	if IsNull(s_cod) or s_cod = ""  then
//		this.object.emchnam[1] = ""
//		return 1
//	end if
//	
//	select mchnam 
//	  into :ls_mchnam
//  	  from mchmst
//	 where sabu = :gs_sabu and mchno = :s_cod ;
//	
//	if sqlca.sqlcode <> 0 then
//		f_message_chk(33, '[관리번호]')
//		this.setitem(1,"emchno", snull)
//		this.setitem(1,"emchnam", snull)
//		return 1
//	end if
//	
//	this.setitem(1,"emchnam", ls_mchnam ) 	
//	
//end if
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_06590
integer x = 50
integer y = 284
integer width = 4558
integer height = 1972
string dataobject = "d_pdt_06590_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_06590
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 272
integer width = 4594
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

