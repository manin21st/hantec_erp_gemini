$PBExportHeader$w_cia00150.srw
$PBExportComments$재공수불부
forward
global type w_cia00150 from w_standard_print
end type
end forward

global type w_cia00150 from w_standard_print
integer width = 4681
integer height = 2428
string title = "재공수불부"
end type
global w_cia00150 w_cia00150

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYm,sSaup_Gubn


dw_ip.AcceptText()
sYm        = dw_ip.GetITemString(1,"sym")
sSaup_Gubn = dw_ip.GetITemString(1,"sgubn")    /*사업구분*/


sYm = Trim(sYm)
IF sYm = '' or isnull(sYm) THEN
   f_messagechk(1,'[원가계산년월]')
	dw_ip.SetColumn("sym")
	dw_ip.SetFocus()
	Return -1	
ELSE
	IF F_DATECHK(sYm + '01') = -1 THEN
		f_messagechk(21,'[원가계산년월]')
	   dw_ip.SetColumn("sym")
	   dw_ip.SetFocus()
	   Return -1	 
  END IF	
END IF

IF sSaup_Gubn = '' OR ISNULL(sSaup_Gubn) THEN
	sSaup_Gubn = '%'
END IF	
	

IF dw_list.Retrieve(sYm,sSaup_Gubn)  <= 0 THEN
   f_messagechk(14,"") 
	Return -1 	
END IF	

Return 1
end function

on w_cia00150.create
call super::create
end on

on w_cia00150.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_ip.SetITem(1,"sym",Left(f_today(),6))
end event

type p_preview from w_standard_print`p_preview within w_cia00150
end type

type p_exit from w_standard_print`p_exit within w_cia00150
end type

type p_print from w_standard_print`p_print within w_cia00150
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia00150
end type







type st_10 from w_standard_print`st_10 within w_cia00150
end type



type dw_print from w_standard_print`dw_print within w_cia00150
end type

type dw_ip from w_standard_print`dw_ip within w_cia00150
integer x = 37
integer y = 24
integer width = 1920
integer height = 200
string dataobject = "dw_cia00150_1"
end type

type dw_list from w_standard_print`dw_list within w_cia00150
integer y = 240
string dataobject = "dw_cia00150_2"
end type

