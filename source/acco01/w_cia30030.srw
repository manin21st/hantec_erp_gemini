$PBExportHeader$w_cia30030.srw
$PBExportComments$원가손익배부율표
forward
global type w_cia30030 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia30030
end type
end forward

global type w_cia30030 from w_standard_print
string title = "원가손익배부율표"
event ue_open ( )
rr_1 rr_1
end type
global w_cia30030 w_cia30030

forward prototypes
public function integer wf_retrieve ()
end prototypes

event ue_open;dw_ip.SetItem(1,"io_yymm", Left(F_Today(),6))
dw_ip.SetItem(1,"io_yymmt", Left(F_Today(),6))
dw_ip.SetColumn("io_yymm")
dw_ip.SetFocus()
end event

public function integer wf_retrieve ();String scostgu,sIoYm,sGbn,sIoYmt

dw_ip.AcceptText()
sIoYm    = Trim(dw_ip.GetITemString(1,"io_yymm"))
sIoYmt   = Trim(dw_ip.GetITemString(1,"io_yymmt"))
sGbn     = dw_ip.GetITemString(1,"crt_gbn")
scostgu  = dw_ip.GetITemString(1,"cost_gubn")

if sIoYm = '' or IsNull(sIoYm) then
	F_MessageChk(1,'[원가년월')
	dw_ip.SetColumn("io_yymm")
	dw_ip.SetFocus()
	Return -1
end if
if sIoYmt = '' or IsNull(sIoYmt) then
	F_MessageChk(1,'[원가년월')
	dw_ip.SetColumn("io_yymmt")
	dw_ip.SetFocus()
	Return -1
end if

scostgu = Trim(scostgu)
IF scostgu = '' or IsNull(scostgu) THEN scostgu = '%' 

IF dw_print.Retrieve(sIoYm,sIoYmt,sGbn,scostgu)  <= 0 THEN
   f_messagechk(14,"") 
	Return -1 	
END IF	
dw_print.ShareData(dw_list)
Return 1
end function

on w_cia30030.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia30030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;postevent("ue_open")
end event

type p_preview from w_standard_print`p_preview within w_cia30030
integer y = 0
end type

type p_exit from w_standard_print`p_exit within w_cia30030
integer y = 0
end type

type p_print from w_standard_print`p_print within w_cia30030
integer y = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia30030
integer y = 0
end type

type st_window from w_standard_print`st_window within w_cia30030
integer x = 2373
integer width = 494
end type





type st_10 from w_standard_print`st_10 within w_cia30030
end type



type dw_print from w_standard_print`dw_print within w_cia30030
integer x = 3410
integer y = 0
string dataobject = "dw_cia30030_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cia30030
integer x = 32
integer y = 4
integer width = 3415
integer height = 144
string dataobject = "dw_cia30030_1"
end type

event dw_ip::rbuttondown;String ls_pordno, ls_itnbr

SetNull(gs_code)
SetNull(gs_codename)

This.AcceptText()

IF this.GetColumnName() = "itnbr"  THEN
	ls_itnbr = THIS.GetItemString(THIS.GetRow(), "itnbr")
	gs_code = ls_itnbr
		
	Open(W_ITEMAS_POPUP3)

	IF IsNull(gs_code) THEN Return
	
	THIS.SetItem(THIS.GetRow(), "itnbr", gs_code)
	THIS.SetItem(THIS.GetRow(), "itdsc", gs_codename)
	
END IF
end event

event dw_ip::itemerror;Return 1 
end event

event dw_ip::itemchanged;String  snull,   scostgu ,scustname

SetNUll(snull)


IF this.GetColumnName() = "cost_gubn" THEN
	scostgu = this.GetText()
	IF scostgu= "" OR IsNull(scostgu) THEN RETURN
	
   SELECT"REFFPF"."RFNA1" INTO :scustname
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = 'C9' ) AND  
         ( "REFFPF"."RFGUB" = :scostgu ) AND  
         ( "REFFPF"."SABU" = '1' )    ;
			
	If Sqlca.Sqlcode <> 0 then
		f_messageChk(20,'[부문구분]')
		this.Setitem(this.getrow(),"cost_gubn",snull)
		this.SetColumn("cost_gubn")
		this.SetFocus()
		Return 1
	end if
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia30030
integer x = 50
integer y = 160
integer width = 4553
integer height = 2020
string dataobject = "dw_cia30030_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_cia30030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 152
integer width = 4576
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

