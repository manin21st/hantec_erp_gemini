$PBExportHeader$w_cia30010.srw
$PBExportComments$작업실적 집계표
forward
global type w_cia30010 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia30010
end type
end forward

global type w_cia30010 from w_standard_print
string title = "작업실적 집계표(작업지시번호별)"
rr_1 rr_1
end type
global w_cia30010 w_cia30010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYm,spdt_gubn,spordno,sitnbr,scost_sabu,scost_nm,sYmt


dw_ip.AcceptText()
sYm        = Trim(dw_ip.GetITemString(1,"sym"))
sYmt       = Trim(dw_ip.GetITemString(1,"symt"))
spdt_gubn  = dw_ip.GetITemString(1,"pdt_gubn")
spordno    = dw_ip.GetITemString(1,"pordno")  
sitnbr     = dw_ip.GetITemString(1,"itnbr")      
//---------------------------------------------------
scost_sabu = dw_ip.GetITemString(1,"cost_sabu") 

IF scost_sabu = '99' or scost_sabu = '' or isnull(scost_sabu) THEN
   scost_sabu = '%'
END IF

select rfna1  into :scost_nm	from reffpf where rfgub  = :scost_sabu and rfcod = 'C0';
//----------------------------------------------------
IF sYm = '' or isnull(sYm) THEN
   f_messagechk(1,'[원가년월]')
	dw_ip.SetColumn("sym")
	dw_ip.SetFocus()
	Return -1	
ELSE
	IF F_DATECHK(sYm + '01') = -1 THEN
		f_messagechk(21,'[원가년월]')
	   dw_ip.SetColumn("sym")
	   dw_ip.SetFocus()
	   Return -1	 
  END IF	
END IF	
IF sYmt = '' or isnull(sYmt) THEN
   f_messagechk(1,'[원가년월]')
	dw_ip.SetColumn("symt")
	dw_ip.SetFocus()
	Return -1	
ELSE
	IF F_DATECHK(sYmt + '01') = -1 THEN
		f_messagechk(21,'[원가년월]')
	   dw_ip.SetColumn("symt")
	   dw_ip.SetFocus()
	   Return -1	 
  END IF	
END IF	

spdt_gubn = Trim(spdt_gubn)
IF spdt_gubn = '' or IsNull(spdt_gubn) THEN spdt_gubn = '%' 

spordno = Trim(spordno)
IF spordno = '' or IsNull(spordno) THEN spordno = '%' 

sitnbr = Trim(sitnbr)
IF sitnbr = '' or IsNull(sitnbr) THEN  sitnbr = '%' 

IF dw_print.Retrieve(scost_sabu,scost_nm,sYm,spdt_gubn,spordno,sitnbr)  <= 0 THEN
   f_messagechk(14,"") 
	Return -1 	
END IF
dw_print.ShareData(dw_list)

Return 1
end function

on w_cia30010.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia30010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetITem(1,"sym",LEFT(f_today(),6))
dw_ip.SetITem(1,"symt",LEFT(f_today(),6))
dw_ip.SetColumn("sym")
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_cia30010
end type

type p_exit from w_standard_print`p_exit within w_cia30010
end type

type p_print from w_standard_print`p_print within w_cia30010
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia30010
end type







type st_10 from w_standard_print`st_10 within w_cia30010
end type



type dw_print from w_standard_print`dw_print within w_cia30010
integer x = 3877
integer y = 84
string dataobject = "dw_cia30010_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cia30010
integer x = 0
integer y = 0
integer width = 3840
integer height = 220
string dataobject = "dw_cia30010_1"
end type

event dw_ip::rbuttondown;String ls_pordno, ls_itnbr

SetNull(gs_code)
SetNull(gs_codename)

This.AcceptText()

IF this.GetColumnName() = "pordno"  THEN
	ls_pordno = THIS.GetItemString(THIS.GetRow(), "pordno")
	gs_code = ls_pordno
		
	Open(W_JISI_POPUP)

	IF IsNull(gs_code) THEN Return
	
	THIS.SetItem(THIS.GetRow(), "pordno", gs_code)
	
END IF


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

event dw_ip::itemchanged;String spordno,sitnbr,sitdsc,snull, syymm , spdtgu, spdt_name

SetNUll(snull)

IF this.GetColumnName() = "sym" THEN
	syymm = this.GetText()
	
	IF F_DATECHK(syymm + '01') = -1 THEN
		f_messagechk(21,'[기준년월]')
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
   WHERE ( "REFFPF"."RFCOD" = 'C7' ) AND  
         ( "REFFPF"."RFGUB" = :spdtgu ) ;
			
	If Sqlca.Sqlcode <> 0 then
		f_messageChk(20,'[사업부문]')
		this.Setitem(this.getrow(),"pdt_gubn",snull)
		this.SetColumn("pdt_gubn")
		this.SetFocus()
		Return 1
	end if
END IF

IF this.GetColumnName() = "pordno" THEN
	spordno = this.GetText()
	IF spordno = "" OR IsNull(spordno) THEN 
		this.Setitem(this.getrow(),"pordno",sNull)
		RETURN
	END IF
	
	SELECT "MOMAST"."PORDNO"  INTO :spordno 
    FROM "MOMAST"  
   WHERE ( "MOMAST"."SABU" = '1' ) AND  
         ( "MOMAST"."PORDNO" = :spordno ) AND
			( "MOMAST"."PDSTS" in ('1','2') ) ;

	If Sqlca.Sqlcode <> 0 then
		f_messageChk(20,'[작업지시번호]')
		this.Setitem(this.getrow(),"pordno",snull)
		this.SetColumn("pordno")
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
		f_messageChk(20,'[작업지시품번]')
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

type dw_list from w_standard_print`dw_list within w_cia30010
integer x = 18
integer y = 228
integer height = 1980
string dataobject = "dw_cia30010_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_cia30010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 224
integer width = 4617
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 55
end type

