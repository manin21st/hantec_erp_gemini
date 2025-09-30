$PBExportHeader$w_cia30040.srw
$PBExportComments$기초재공재고현황
forward
global type w_cia30040 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia30040
end type
end forward

global type w_cia30040 from w_standard_print
string title = "기초재공재고현황"
event ue_open ( )
rr_1 rr_1
end type
global w_cia30040 w_cia30040

forward prototypes
public function integer wf_retrieve ()
end prototypes

event ue_open;dw_ip.SetITem(1,"sym",LEFT(f_today(),6))
dw_ip.SetITem(1,"symt",LEFT(f_today(),6))
dw_ip.SetColumn("sym")
dw_ip.SetFocus()
end event

public function integer wf_retrieve ();String sYm,spdt_gubn,sitnbr,sittyp,scost_sabu,scost_nm,sYmt

dw_ip.AcceptText()
sYm        = Trim(dw_ip.GetITemString(1,"sym"))
sYmt       = Trim(dw_ip.GetITemString(1,"symt"))
spdt_gubn  = dw_ip.GetITemString(1,"pdt_gubn")
sittyp  = dw_ip.GetITemString(1,"ittyp")
sitnbr     = dw_ip.GetITemString(1,"itnbr")      
//---------------------------------------------------
scost_sabu = dw_ip.GetITemString(1,"cost_sabu") 

IF scost_sabu = '99' or scost_sabu = '' or isnull(scost_sabu) THEN
   scost_sabu = '%'
END IF

select rfna1 into :scost_nm  from reffpf where rfgub  = :scost_sabu and rfcod = 'C0';

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
IF sYmt = '' or isnull(sYmt) THEN
   f_messagechk(1,'[원가계산년월]')
	dw_ip.SetColumn("symt")
	dw_ip.SetFocus()
	Return -1	
ELSE
	IF F_DATECHK(sYmt + '01') = -1 THEN
		f_messagechk(21,'[원가계산년월]')
	   dw_ip.SetColumn("symt")
	   dw_ip.SetFocus()
	   Return -1	 
  END IF	
END IF	

sittyp = Trim(sittyp)
IF sittyp = '' or IsNull(sittyp) THEN 
   f_messagechk(1,'[품목구분]')
	dw_ip.SetColumn("ittyp")
	dw_ip.SetFocus()
	Return -1
END IF

spdt_gubn = Trim(spdt_gubn)
IF spdt_gubn = '' or IsNull(spdt_gubn) THEN spdt_gubn = '%' 

sitnbr = Trim(sitnbr)
IF sitnbr = '' or IsNull(sitnbr) THEN  sitnbr = '%' 

IF dw_print.Retrieve(scost_sabu,scost_nm,sYm,sYmt,spdt_gubn ,sittyp ,sitnbr)  <= 0 THEN
   f_messagechk(14,"") 
	Return -1 	
END IF	
dw_print.ShareData(dw_list)
Return 1
end function

on w_cia30040.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia30040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;postevent("ue_open")
end event

type p_preview from w_standard_print`p_preview within w_cia30040
end type

type p_exit from w_standard_print`p_exit within w_cia30040
end type

type p_print from w_standard_print`p_print within w_cia30040
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia30040
end type







type st_10 from w_standard_print`st_10 within w_cia30040
end type



type dw_print from w_standard_print`dw_print within w_cia30040
string dataobject = "dw_cia30040_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cia30040
integer x = 0
integer y = 0
integer width = 3813
integer height = 208
string dataobject = "dw_cia30040_1"
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

event dw_ip::itemchanged;String sitnbr,sitdsc,snull, syymm , spdtgu, spdt_name  , sittyp, sittypname

SetNUll(snull)

IF this.GetColumnName() = "sym" THEN
	syymm = this.GetText()
	
	IF F_DATECHK(syymm + '01') = -1 THEN
		f_messagechk(21,'[원가계산년월]')
	   this.Setitem(this.getrow(),"sym", snull)
		this.SetColumn("sym")
	   this.SetFocus()
		return 1
  END IF		
END IF

IF this.GetColumnName() = "pdt_gubn" THEN
	spdtgu = this.GetText()
	IF spdtgu= "" OR IsNull(spdtgu) THEN RETURN
	
   SELECT"REFFPF"."RFNA1" INTO :spdt_name
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '03' ) AND  
         ( "REFFPF"."RFGUB" = :spdtgu ) AND  
         ( "REFFPF"."SABU" = '1' )    ;
			
	If Sqlca.Sqlcode <> 0 then
		f_messageChk(20,'[생산팀]')
		this.Setitem(this.getrow(),"pdt_gubn",snull)
		this.SetColumn("pdt_gubn")
		this.SetFocus()
		Return 1
	end if
END IF

IF this.GetColumnName() = "ittyp" THEN
	sittyp = this.GetText()
	IF sittyp= "" OR IsNull(sittyp) THEN RETURN
	
   SELECT"REFFPF"."RFNA1" INTO :sittypname
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '05' ) AND  
         ( "REFFPF"."RFGUB" = :sittyp ) AND  
         ( "REFFPF"."SABU" = '1' )    ;
			
	If Sqlca.Sqlcode <> 0 then
		f_messageChk(20,'[품목구분]')
		this.Setitem(this.getrow(),"ittyp",snull)
		this.SetColumn("ittyp")
		this.SetFocus()
		Return 1
	end if
END IF

IF this.GetColumnName() = "itnbr" THEN
	sitnbr = this.GetText()
	IF sitnbr = "" OR IsNull(sitnbr) THEN 
		this.Setitem(this.getrow(),"itdsc",sNull)
		RETURN
	END IF
	
	SELECT "ITEMAS"."ITDSC"   INTO :sitdsc 
     FROM "ITEMAS"  
    WHERE ( "ITEMAS"."SABU" = '1' ) AND  
          ( "ITEMAS"."ITNBR" = :sitnbr ) 	 ;

	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"itdsc",sitdsc)
	else
		f_messageChk(20,'[품번]')
		this.Setitem(this.getrow(),"itnbr",snull)
		this.Setitem(this.getrow(),"itdsc",snull)
		this.SetColumn("itnbr")
		this.SetFocus()
		Return 1
	end if
END IF
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia30040
integer x = 23
integer y = 216
integer width = 4558
integer height = 1980
string dataobject = "dw_cia30040_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_cia30040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 208
integer width = 4603
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

