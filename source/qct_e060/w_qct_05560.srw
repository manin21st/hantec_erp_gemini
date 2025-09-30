$PBExportHeader$w_qct_05560.srw
$PBExportComments$계측기 수리미완료 현황
forward
global type w_qct_05560 from w_standard_print
end type
end forward

global type w_qct_05560 from w_standard_print
string title = "계측기 수리미완료 현황"
end type
global w_qct_05560 w_qct_05560

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  sgubun, sempno, gub1, gub2

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sgubun = dw_ip.object.gubun[1]
sempno = trim(dw_ip.object.empno[1])

if IsNull(sempno) or sempno = "" then sempno = "%"
if sgubun = '1' then //테스트 미완료
   gub1 = 'W'
	gub2 = '3' 
else
   gub1 = 'W'
	gub2 = 'W' 
end if

//if dw_list.Retrieve(gs_sabu, gub1, gub2, sempno) <= 0 then
//	f_message_chk(50,"[수리미완료 현황]")
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, gub1, gub2, sempno) <= 0 then
	f_message_chk(50,"[수리미완료 현황]")
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_qct_05560.create
call super::create
end on

on w_qct_05560.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type p_preview from w_standard_print`p_preview within w_qct_05560
end type

type p_exit from w_standard_print`p_exit within w_qct_05560
end type

type p_print from w_standard_print`p_print within w_qct_05560
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_05560
end type







type st_10 from w_standard_print`st_10 within w_qct_05560
end type



type dw_print from w_standard_print`dw_print within w_qct_05560
string dataobject = "d_qct_05560_02"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_05560
integer x = 46
integer y = 0
integer width = 1298
integer height = 236
string dataobject = "d_qct_05560_01"
end type

event dw_ip::rbuttondown;//SetNull(gs_code)
//SetNull(gs_codename)
//
//gs_gubun = 'ALL'  //구매일자 관계없이 전체
//
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
//	 where sabu = :gs_saupj and mchno = :s_cod ;
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
//	 where sabu = :gs_saupj and mchno = :s_cod ;
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

type dw_list from w_standard_print`dw_list within w_qct_05560
string dataobject = "d_qct_05560_02"
end type

