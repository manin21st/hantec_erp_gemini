$PBExportHeader$w_pdm_11540.srw
$PBExportComments$** 분류코드 현황
forward
global type w_pdm_11540 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_11540
end type
end forward

global type w_pdm_11540 from w_standard_print
string title = "품목분류 현황"
rr_1 rr_1
end type
global w_pdm_11540 w_pdm_11540

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String scd_min,scd_max,sguf,sgut,sgunamef,sgunamet, ls_dcomp

SELECT MIN("REFFPF"."RFGUB") ,MAX("REFFPF"."RFGUB")
  INTO :scd_min ,:scd_max 
  FROM "REFFPF"  
  WHERE ( "REFFPF"."SABU" = :gs_sabu ) AND    
        ( "REFFPF"."RFCOD" = '05' )  AND    
		  ( "REFFPF"."RFGUB" <> '00' )   ;
			
IF dw_ip.AcceptText() = -1 THEN RETURN -1

sguf         =dw_ip.GetItemString(1,"sgubun")
sgut         =dw_ip.GetItemString(1,"egubun")
ls_dcomp =dw_ip.GetItemString(1,"dcomp")

IF sguf ="" OR IsNull(sguf) THEN
	sguf =scd_min	
END IF

IF sgut ="" OR IsNull(sgut) THEN
	sgut =scd_max
END IF

IF ls_dcomp ="" OR IsNull(ls_dcomp) THEN
	ls_dcomp = '%'
END IF

IF ls_dcomp <>"%"  THEN
	ls_dcomp = ls_dcomp + '%'
END IF


IF dw_print.Retrieve(ls_dcomp,sguf,sgut) <=0 THEN
	IF f_message_chk(50,'') = -1 THEN RETURN -1
     		dw_ip.setcolumn('sgubun')
		dw_ip.SetFocus()
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1

end function

on w_pdm_11540.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdm_11540.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String scd_min,scd_max

SELECT MIN("REFFPF"."RFGUB") ,MAX("REFFPF"."RFGUB")
  INTO :scd_min ,:scd_max 
  FROM "REFFPF"  
  WHERE ( "REFFPF"."RFCOD" = '05' )  AND    
		  ( "REFFPF"."RFGUB" <> '00' )   ;
		  
dw_ip.SetItem(1,"sgubun",scd_min)
dw_ip.SetItem(1,"egubun",scd_max)
dw_ip.Setfocus()

f_mod_saupj(dw_ip, 'dcomp')


end event

type p_sort from w_standard_print`p_sort within w_pdm_11540
boolean visible = true
end type

type p_preview from w_standard_print`p_preview within w_pdm_11540
integer x = 4082
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_pdm_11540
integer x = 4430
integer y = 12
end type

type p_print from w_standard_print`p_print within w_pdm_11540
integer x = 4256
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11540
integer x = 3909
integer y = 12
end type











type dw_print from w_standard_print`dw_print within w_pdm_11540
integer x = 3717
integer y = 24
string dataobject = "d_pdm_11540_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11540
integer x = 27
integer y = 24
integer width = 1801
integer height = 248
string dataobject = "d_pdm_11540_a"
end type

type dw_list from w_standard_print`dw_list within w_pdm_11540
integer y = 316
integer width = 4567
integer height = 1984
string dataobject = "d_pdm_11540"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdm_11540
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 308
integer width = 4590
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 55
end type

