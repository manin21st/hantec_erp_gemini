$PBExportHeader$w_cia40100.srw
$PBExportComments$수불구분별 수불현황
forward
global type w_cia40100 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia40100
end type
end forward

global type w_cia40100 from w_standard_print
string title = "수불구분별 수불현황"
rr_1 rr_1
end type
global w_cia40100 w_cia40100

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYm,sit_Gubn,sGubun,sYmt

dw_ip.AcceptText()
sYm        = Trim(dw_ip.GetITemString(1,"sym"))
sYmt       = Trim(dw_ip.GetITemString(1,"symt"))
sit_Gubn   = dw_ip.GetITemString(1,"it_gubn")  /*품목구분*/ 
sgubun     = dw_ip.GetITemString(1,"sgubun")    /*구분*/   

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
	
IF sit_Gubn = '' OR ISNULL(sit_Gubn) THEN
	sit_Gubn = '%'
END IF	

dw_list.ShareDataOff()
IF dw_LIST.Retrieve(sYm, sYmt,sGubun,sit_Gubn)  <= 0 THEN
   f_messagechk(14,"") 
	Return -1 	
END IF	

Return 1
end function

on w_cia40100.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia40100.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;


dw_ip.SetITem(1,"sym",Left(f_today(),6))
dw_ip.SetITem(1,"symt",Left(f_today(),6))	
dw_ip.SetITem(1,"it_gubn",'1')

dw_ip.SetColumn("sym")
dw_ip.SetFocus()


end event

type p_preview from w_standard_print`p_preview within w_cia40100
boolean visible = false
integer x = 4251
integer y = 204
integer taborder = 0
end type

type p_exit from w_standard_print`p_exit within w_cia40100
integer y = 16
integer taborder = 40
end type

type p_print from w_standard_print`p_print within w_cia40100
boolean visible = false
integer x = 4425
integer y = 204
integer taborder = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia40100
integer x = 4270
integer y = 16
end type







type st_10 from w_standard_print`st_10 within w_cia40100
end type



type dw_print from w_standard_print`dw_print within w_cia40100
integer x = 3785
integer y = 28
string dataobject = "dw_cia401001"
end type

type dw_ip from w_standard_print`dw_ip within w_cia40100
integer x = 46
integer y = 0
integer width = 2871
integer height = 160
string dataobject = "dw_cia40100"
end type

event dw_ip::itemchanged;
String snull,sittyp,sittypname

SetNull(snull)
IF This.GetColumnName() = "it_gubn" THEN  /*품목구분*/
   sittyp = This.GetText()
	
	if sIttyp = '' or IsNull(sIttyp) then Return
	
   SELECT"REFFPF"."RFNA1" INTO :sittypname
    FROM "REFFPF"  
   WHERE ( "REFFPF"."RFCOD" = '05' ) AND  
         ( "REFFPF"."RFGUB" = :sittyp )  ;
			
	If Sqlca.Sqlcode <> 0 then
		f_messageChk(20,'[품목구분]')
		this.Setitem(this.getrow(),"it_gubn",snull)
		this.SetColumn("it_gubn")
		this.SetFocus()
		Return 1
	end if
END IF	
end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;this.AcceptText()

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.GetColumnName() = "itnbr" THEN
   
	Open(W_ITEMAS_POPUP3)
      
   IF IsNull(gs_code) OR gs_code = "" THEN Return
	
	THIS.SetItem(THIS.GetRow(), "itnbr", gs_code)
	THIS.SetItem(THIS.GetRow(), "itnbr_name", gs_codename)
	
END IF	
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia40100
integer x = 55
integer y = 176
integer width = 4544
integer height = 2028
string dataobject = "dw_cia401001"
boolean border = false
end type

type rr_1 from roundrectangle within w_cia40100
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 168
integer width = 4567
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

