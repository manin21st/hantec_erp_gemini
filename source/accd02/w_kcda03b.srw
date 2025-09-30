$PBExportHeader$w_kcda03b.srw
$PBExportComments$참조코드 출력
forward
global type w_kcda03b from w_standard_print
end type
type rr_1 from roundrectangle within w_kcda03b
end type
type rr_2 from roundrectangle within w_kcda03b
end type
end forward

global type w_kcda03b from w_standard_print
integer width = 4000
integer height = 2340
string title = "참조코드 조회 출력"
rr_1 rr_1
rr_2 rr_2
end type
global w_kcda03b w_kcda03b

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String scd_min,scd_max,sguf,sgut,sgunamef,sgunamet

SELECT MIN("REFFPF"."RFCOD") ,MAX("REFFPF"."RFCOD")
  INTO :scd_min ,:scd_max 
  FROM "REFFPF"  
  WHERE ( "REFFPF"."SABU" = :gs_saupj ) AND  
        ( "REFFPF"."RFGUB" = '00' )   ;
			
IF dw_ip.AcceptText() = -1 THEN RETURN -1

sguf =dw_ip.GetItemString(1,"sgubun")
sgut =dw_ip.GetItemString(1,"egubun")

IF sguf ="" OR IsNull(sguf) THEN
	sguf =scd_min	
END IF
SELECT "REFFPF"."RFNA1"
  INTO :sgunamef
  FROM "REFFPF"  
  WHERE ( "REFFPF"."SABU" = :gs_saupj ) AND  
        ( "REFFPF"."RFGUB" = '00' ) AND
		  ( "REFFPF"."RFCOD"  = :sguf) ;
IF sgut ="" OR IsNull(sgut) THEN
	sgut =scd_max
END IF
SELECT "REFFPF"."RFNA1"
  INTO :sgunamet
  FROM "REFFPF"  
  WHERE ( "REFFPF"."SABU" = :gs_saupj ) AND  
        ( "REFFPF"."RFGUB" = '00' ) AND
		  ( "REFFPF"."RFCOD"  = :sgut) ;
		  

IF dw_print.Retrieve(sguf,sgut,sgunamef,sgunamet) <=0 THEN
	f_messagechk(14,"")
	dw_ip.SetFocus()
END IF
dw_print.ShareData(dw_list)

Return 1

end function

on w_kcda03b.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_kcda03b.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;String scd_min,scd_max

F_Window_Center_Response(This)

  SELECT MIN("REFFPF"."RFCOD") ,MAX("REFFPF"."RFCOD")
    INTO :scd_min ,:scd_max 
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFGUB" = '00' )   ;

dw_ip.SetItem(1,"sgubun",scd_min)
dw_ip.SetItem(1,"egubun",scd_max)
dw_ip.Setfocus()

end event

type p_preview from w_standard_print`p_preview within w_kcda03b
integer x = 3451
end type

type p_exit from w_standard_print`p_exit within w_kcda03b
integer x = 3799
end type

type p_print from w_standard_print`p_print within w_kcda03b
integer x = 3625
end type

type p_retrieve from w_standard_print`p_retrieve within w_kcda03b
integer x = 3278
end type

type st_window from w_standard_print`st_window within w_kcda03b
integer x = 2373
integer y = 3044
end type

type sle_msg from w_standard_print`sle_msg within w_kcda03b
integer x = 398
integer y = 3044
end type

type dw_datetime from w_standard_print`dw_datetime within w_kcda03b
integer x = 2866
integer y = 3044
end type

type st_10 from w_standard_print`st_10 within w_kcda03b
integer x = 37
integer y = 3044
end type

type gb_10 from w_standard_print`gb_10 within w_kcda03b
integer x = 23
integer y = 3008
end type

type dw_print from w_standard_print`dw_print within w_kcda03b
integer x = 3086
string dataobject = "dw_kcda03b_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kcda03b
integer x = 329
integer y = 92
integer width = 2126
integer height = 132
string dataobject = "dw_kcda03b_2"
end type

type dw_list from w_standard_print`dw_list within w_kcda03b
integer x = 219
integer y = 284
integer width = 3474
integer height = 1900
string dataobject = "dw_kcda03b_1"
boolean hscrollbar = false
boolean border = false
end type

type rr_1 from roundrectangle within w_kcda03b
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 270
integer y = 52
integer width = 2272
integer height = 192
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_kcda03b
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 215
integer y = 276
integer width = 3511
integer height = 1936
integer cornerheight = 40
integer cornerwidth = 46
end type

