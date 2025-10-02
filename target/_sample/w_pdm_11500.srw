$PBExportHeader$w_pdm_11500.srw
$PBExportComments$** 참조코드 현황
forward
global type w_pdm_11500 from w_standard_print
end type
end forward

global type w_pdm_11500 from w_standard_print
string title = "참조코드 현황"
end type
global w_pdm_11500 w_pdm_11500

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String scd_min,scd_max,sguf,sgut,sgunamef,sgunamet, sgub

SELECT MIN("REFFPF"."RFCOD") ,MAX("REFFPF"."RFCOD")
  INTO :scd_min ,:scd_max 
  FROM "REFFPF"  
  WHERE ( "REFFPF"."SABU" = '1' ) AND  
        ( "REFFPF"."RFGUB" = '00' )   ;
			
IF dw_ip.AcceptText() = -1 THEN RETURN -1

sguf =dw_ip.GetItemString(1,"sgubun")
sgut =dw_ip.GetItemString(1,"egubun")
sgub =dw_ip.GetItemString(1,"gub")

IF sguf ="" OR IsNull(sguf) THEN
	sguf =scd_min	
END IF
SELECT "REFFPF"."RFNA1"
  INTO :sgunamef
  FROM "REFFPF"  
  WHERE ( "REFFPF"."SABU" = '1' ) AND  
        ( "REFFPF"."RFGUB" = '00' ) AND
		  ( "REFFPF"."RFCOD"  = :sguf) ;
IF sgut ="" OR IsNull(sgut) THEN
	sgut =scd_max
END IF
SELECT "REFFPF"."RFNA1"
  INTO :sgunamet
  FROM "REFFPF"  
  WHERE ( "REFFPF"."SABU" = '1' ) AND  
        ( "REFFPF"."RFGUB" = '00' ) AND
		  ( "REFFPF"."RFCOD"  = :sgut) ;
		  
//if sgub = 'Y' then 
//	dw_list.DataObject = 'd_pdm_11500_1'
//else
//	dw_list.DataObject = 'd_pdm_11500'
//end if
//dw_list.SetTransObject(SQLCA)

IF dw_print.Retrieve(sguf,sgut,sgunamef,sgunamet) <=0 THEN
	IF f_message_chk(50,'') = -1 THEN RETURN -1
	dw_ip.SetFocus()
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1

end function

on w_pdm_11500.create
call super::create
end on

on w_pdm_11500.destroy
call super::destroy
end on

event open;call super::open;String scd_min,scd_max

  SELECT MIN("REFFPF"."RFCOD") ,MAX("REFFPF"."RFCOD")
    INTO :scd_min ,:scd_max 
    FROM "REFFPF"  
   WHERE ( "REFFPF"."SABU" = '1' ) AND  
         ( "REFFPF"."RFGUB" = '00' )   ;

dw_ip.SetItem(1,"sgubun",scd_min)
dw_ip.SetItem(1,"egubun",scd_max)
dw_ip.Setfocus()
dw_print.SettransObject(sqlca)
end event

type dw_list from w_standard_print`dw_list within w_pdm_11500
integer width = 3489
integer height = 1964
string dataobject = "d_pdm_11500"
end type

type cb_print from w_standard_print`cb_print within w_pdm_11500
end type

type cb_excel from w_standard_print`cb_excel within w_pdm_11500
end type

type cb_preview from w_standard_print`cb_preview within w_pdm_11500
end type

type cb_1 from w_standard_print`cb_1 within w_pdm_11500
end type

type dw_print from w_standard_print`dw_print within w_pdm_11500
integer x = 2981
integer width = 155
integer height = 144
string dataobject = "d_pdm_11500_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11500
integer y = 56
integer width = 3489
integer height = 188
string dataobject = "d_pdm_11500_a"
end type

type r_1 from w_standard_print`r_1 within w_pdm_11500
end type

type r_2 from w_standard_print`r_2 within w_pdm_11500
end type

