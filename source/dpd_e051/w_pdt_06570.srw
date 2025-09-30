$PBExportHeader$w_pdt_06570.srw
$PBExportComments$** 설비소요/보유 현황
forward
global type w_pdt_06570 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_06570
end type
end forward

global type w_pdt_06570 from w_standard_print
string title = "설비소요/보유 현황"
rr_1 rr_1
end type
global w_pdt_06570 w_pdt_06570

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string grpcod1, grpcod2, grpnam1, grpnam2

// 소요수량이 0인것은 삭제한다.
Delete mchgrp_use
 Where use_qty = 0;

Update mchgrp_use
   Set save_qty	= 0;

// 사용자별 그룹에 규격을 저장한다.
INSERT INTO "MCHGRP_USE"  
         ( "GRPCOD",   "SPEC",   "USE_QTY",   "SAVE_QTY" )  
	  Select b.grpcod, b.spec, 0, 0
	    From mchmst b
		where not exists ( select 'x' from mchgrp_use c
								  where c.grpcod = b.grpcod and c.spec = b.spec)
        and b.grpcod is not null 
        and b.spec   is not null 
		Group by b.grpcod, b.spec;
		
if sqlca.sqlcode <> 0 then
	Messagebox("설비그룹", "설비그룹 저장중 오류발생" + '~n' + &
								  sqlca.sqlerrtext, stopsign!)
	rollback;
	return -1
end if

// 사용자별 그룹에 보유수량을 정리한다.

Update mchgrp_use a
	Set a.save_qty = (select NVL(count(*), 0)
							  From mchmst b
							 where a.grpcod = b.grpcod 
							   and a.spec   = b.spec 
								and b.pedat is null);
							 
if sqlca.sqlcode <> 0 then
	Messagebox("설비보유수량", "설비보유수량 저장중 오류발생" + '~n' + &
								  sqlca.sqlerrtext, stopsign!)
	rollback;
	return -1
end if							 
							 
commit;

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

grpcod1 = trim(dw_ip.object.grpcod1[1])
grpcod2 = trim(dw_ip.object.grpcod2[1])

if (IsNull(grpcod1) or grpcod1 = "") then grpcod1 = "."
if (IsNull(grpcod2) or grpcod2 = "") then grpcod2 = "ZZZZZZ"

if dw_list.Retrieve(grpcod1, grpcod2) <= 0 then
	f_message_chk(50,"[설비 소유/보유 현황]")
	dw_ip.Setfocus()
	return -1
end if


return 1
end function

on w_pdt_06570.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_06570.destroy
call super::destroy
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_pdt_06570
end type

type p_exit from w_standard_print`p_exit within w_pdt_06570
end type

type p_print from w_standard_print`p_print within w_pdt_06570
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_06570
end type







type st_10 from w_standard_print`st_10 within w_pdt_06570
end type



type dw_print from w_standard_print`dw_print within w_pdt_06570
string dataobject = "d_pdt_06570_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_06570
integer x = 110
integer y = 60
integer width = 2341
integer height = 128
string dataobject = "d_pdt_06570_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;//String  s_cod, s_nam1, s_nam2
//integer i_rtn
//
//s_cod = Trim(this.GetText())
//
//if this.GetColumnName() = "mchno1" then 
//	if IsNull(s_cod) or s_cod = "" then 
//		this.object.mchnam1[1] = ""
//		return 
//	end if
//	
//	select mchnam into :s_nam1 from mchmst
//	 where sabu = :gs_sabu and mchno = :s_cod;
//	 
//	if sqlca.sqlcode <> 0 then 
//	   this.object.mchno1[1] = ""
//	   this.object.mchnam1[1] = ""
//	else
//	   this.object.mchno1[1] = s_cod
//	   this.object.mchnam1[1] = s_nam1
//   end if
//elseif this.GetColumnName() = "mchno2" then 
//	if IsNull(s_cod) or s_cod = "" then 
//	   this.object.mchnam2[1] = ""
//		return 
//	end if
//	
//	select mchnam into :s_nam1 from mchmst
//	 where sabu = :gs_sabu and mchno = :s_cod;
//	 
//	if sqlca.sqlcode <> 0 then 
//	   this.object.mchno2[1] = ""
//	   this.object.mchnam2[1] = ""
//	else
//	   this.object.mchno2[1] = s_cod
//	   this.object.mchnam2[1] = s_nam1
//   end if
//end if
//
//return
end event

event dw_ip::rbuttondown;//SetNull(gs_code)
//SetNull(gs_codename)
//SetNull(gs_gubun)
//
//if this.GetColumnName() = "mchno1" then
//	open(w_mchno_popup)
//	this.object.mchno1[1] = gs_code
//	this.object.mchnam1[1] = gs_codename
//	return
//elseif this.GetColumnName() = "mchno2" then
//   open(w_mchno_popup)
//	this.object.mchno2[1] = gs_code
//	this.object.mchnam2[1] = gs_codename
//	return
//end if	
end event

type dw_list from w_standard_print`dw_list within w_pdt_06570
integer x = 123
integer y = 212
integer width = 4416
integer height = 2056
string dataobject = "d_pdt_06570_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdt_06570
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 110
integer y = 200
integer width = 4462
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

