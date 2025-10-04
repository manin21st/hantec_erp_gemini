$PBExportHeader$w_pdm_11500.srw
$PBExportComments$** 참조코드 현황
forward
global type w_pdm_11500 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdm_11500
end type
end forward

global type w_pdm_11500 from w_standard_print
string title = "참조코드 현황"
rr_1 rr_1
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
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdm_11500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
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

type p_preview from w_standard_print`p_preview within w_pdm_11500
end type

event p_preview::clicked;call super::clicked;//dw_print.Reset()
//dw_list.RowsCopy(1, dw_list.RowCount(), Primary!, dw_print, 1, Primary!)
//OpenWithParm(w_print_preview, dw_print)	
//dw_list.ShareData(dw_print)
end event

type p_exit from w_standard_print`p_exit within w_pdm_11500
end type

type p_print from w_standard_print`p_print within w_pdm_11500
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11500
end type











type dw_print from w_standard_print`dw_print within w_pdm_11500
integer x = 2981
integer y = 44
integer width = 155
integer height = 144
string dataobject = "d_pdm_11500_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11500
integer x = 169
integer y = 52
integer width = 2053
integer height = 176
string dataobject = "d_pdm_11500_a"
end type

type dw_list from w_standard_print`dw_list within w_pdm_11500
integer x = 178
integer y = 252
integer width = 4256
integer height = 2032
string dataobject = "d_pdm_11500"
boolean border = false
end type

type rr_1 from roundrectangle within w_pdm_11500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 169
integer y = 244
integer width = 4283
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

