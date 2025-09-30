$PBExportHeader$w_cia00055.srw
$PBExportComments$원가수불코드일람표
forward
global type w_cia00055 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia00055
end type
end forward

global type w_cia00055 from w_standard_print
integer width = 4713
string title = "원가수불코드일람표"
rr_1 rr_1
end type
global w_cia00055 w_cia00055

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sGubn


IF dw_list.Retrieve() <=0  THEN
   f_messagechk(14,"") 
	Return -1
END IF

Return 1
end function

on w_cia00055.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia00055.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_cia00055
integer x = 4101
end type

type p_exit from w_standard_print`p_exit within w_cia00055
integer x = 4448
end type

type p_print from w_standard_print`p_print within w_cia00055
integer x = 4274
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia00055
integer x = 3927
end type







type st_10 from w_standard_print`st_10 within w_cia00055
end type



type dw_print from w_standard_print`dw_print within w_cia00055
integer x = 3758
string dataobject = "dw_cia00055_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cia00055
boolean visible = false
integer x = 87
integer width = 517
integer height = 80
boolean enabled = false
end type

type dw_list from w_standard_print`dw_list within w_cia00055
integer x = 69
integer y = 192
integer width = 4549
integer height = 2012
string dataobject = "dw_cia00055_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_cia00055
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 184
integer width = 4576
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

