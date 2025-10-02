$PBExportHeader$w_pdm_11540.srw
$PBExportComments$** 분류코드 현황
forward
global type w_pdm_11540 from w_standard_print
end type
end forward

global type w_pdm_11540 from w_standard_print
string title = "품목분류 현황"
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
call super::create
end on

on w_pdm_11540.destroy
call super::destroy
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

type dw_list from w_standard_print`dw_list within w_pdm_11540
integer y = 352
integer width = 3489
integer height = 1964
string dataobject = "d_pdm_11540"
end type

type cb_print from w_standard_print`cb_print within w_pdm_11540
end type

type cb_excel from w_standard_print`cb_excel within w_pdm_11540
end type

type cb_preview from w_standard_print`cb_preview within w_pdm_11540
end type

type cb_1 from w_standard_print`cb_1 within w_pdm_11540
end type

type dw_print from w_standard_print`dw_print within w_pdm_11540
integer x = 3717
integer y = 24
string dataobject = "d_pdm_11540_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11540
integer y = 56
integer height = 232
string dataobject = "d_pdm_11540_a"
end type

type r_1 from w_standard_print`r_1 within w_pdm_11540
integer y = 348
end type

type r_2 from w_standard_print`r_2 within w_pdm_11540
integer height = 240
end type

