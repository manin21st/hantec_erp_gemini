$PBExportHeader$w_cia40200.srw
$PBExportComments$제품별 매출손익 분석표
forward
global type w_cia40200 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia40200
end type
end forward

global type w_cia40200 from w_standard_print
string title = "제품별 매출손익 분석표"
rr_1 rr_1
end type
global w_cia40200 w_cia40200

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYm,spdt_gubn,sitnbr,sittyp, sYmTo,scost_sabu,scost_nm

If dw_ip.AcceptText() <> 1 Then Return -1

scost_sabu = dw_ip.GetITemString(1,"cost_sabu") 
sYm        = Trim(dw_ip.GetITemString(1,"sym"))
sYmTo      = Trim(dw_ip.GetITemString(1,"symto"))
spdt_gubn  = dw_ip.GetITemString(1,"pdt_gubn")
sIttyp     = dw_ip.GetITemString(1,"ittyp")
sitnbr     = dw_ip.GetITemString(1,"itnbr")      

IF scost_sabu = '99' or scost_sabu = '' or isnull(scost_sabu) THEN
   scost_sabu = '%'
END IF

select rfna1 into :scost_nm	from reffpf where rfcod = 'C0' and rfgub  = :scost_sabu ;

IF sYm = '' or isnull(sYm) THEN
   f_messagechk(1,'[계산년월]')
	dw_ip.SetColumn("sym")
	dw_ip.SetFocus()
	Return -1	
ELSE
	IF F_DATECHK(sYm + '01') = -1 THEN
		f_messagechk(21,'[계산년월]')
	   dw_ip.SetColumn("sym")
	   dw_ip.SetFocus()
	   Return -1	 
  END IF	
END IF	

IF sYmTo = '' or isnull(sYmTo) THEN
   f_messagechk(1,'[계산년월]')
	dw_ip.SetColumn("symto")
	dw_ip.SetFocus()
	Return -1	
ELSE
	IF sYmTo < sYm THEN
		f_messagechk(21,'[계산년월]')
	   dw_ip.SetColumn("symto")
	   dw_ip.SetFocus()
	   Return -1	 
  END IF	
END IF	

spdt_gubn = Trim(spdt_gubn)
IF spdt_gubn = '' or IsNull(spdt_gubn) THEN spdt_gubn = '%' 

sitnbr = Trim(sitnbr)
IF sitnbr = '' or IsNull(sitnbr) THEN  sitnbr = '%' 

IF dw_print.Retrieve(scost_sabu,scost_nm,sYm,sYmTo, spdt_gubn ,sitnbr,sIttyp)  <= 0 THEN
   f_messagechk(14,"") 
	Return -1 	
END IF	
dw_print.sharedata(dw_list)
Return 1
end function

on w_cia40200.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia40200.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

DataWindowChild dw_child

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()

IF dw_ip.GetChild("itcls",dw_child) = 1 THEN
	dw_child.SetTransObject(SQLCA)
	dw_child.Retrieve('1') 
END IF
 
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

dw_ip.SetITem(1,"sym",LEFT(f_today(),6))
dw_ip.SetITem(1,"symTO",LEFT(f_today(),6))

dw_ip.SetColumn("sym")
dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_cia40200
integer x = 4082
end type

type p_exit from w_standard_print`p_exit within w_cia40200
integer x = 4430
end type

type p_print from w_standard_print`p_print within w_cia40200
integer x = 4256
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia40200
integer x = 3909
end type







type st_10 from w_standard_print`st_10 within w_cia40200
end type



type dw_print from w_standard_print`dw_print within w_cia40200
integer x = 4361
integer y = 236
string dataobject = "dw_cia402001_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cia40200
integer width = 3863
integer height = 216
string dataobject = "dw_cia40200"
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

event dw_ip::itemchanged;DataWindowChild dw_child
String sitnbr,sitdsc,snull, syymm , spdtgu, spdt_name  , sittyp, sittypname,sitcls

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
   WHERE ( "REFFPF"."RFCOD" = 'C7' ) AND  
         ( "REFFPF"."RFGUB" = :spdtgu ) ;
			
	If Sqlca.Sqlcode <> 0 then
		f_messageChk(20,'[사업부구분]')
		this.Setitem(this.getrow(),"pdt_gubn",snull)
		this.SetColumn("pdt_gubn")
		this.SetFocus()
		Return 1
	end if
END IF

IF this.GetColumnName() = "itcls" THEN
	sitcls = this.GetText()
	IF sitcls= "" OR IsNull(sitcls) THEN RETURN
	
	 SELECT "ITNCT"."ITCLS"   INTO :sitcls  
      FROM "ITNCT"  
     WHERE ( "ITNCT"."ITTYP" = '1' ) AND  
           ( "ITNCT"."ITCLS" = :sitcls ) AND  
           ( "ITNCT"."LMSGU" = 'M' )   ;
		
	If Sqlca.Sqlcode <> 0 then
		f_messageChk(20,'[품목분류]')
		this.Setitem(this.getrow(),"itcls",snull)
		this.SetColumn("itcls")
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

type dw_list from w_standard_print`dw_list within w_cia40200
integer x = 64
integer y = 244
integer width = 4526
integer height = 1964
string dataobject = "dw_cia402001"
boolean border = false
end type

event dw_list::rowfocuschanged;w_mdi_frame.sle_msg.text = ''
end event

type rr_1 from roundrectangle within w_cia40200
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 236
integer width = 4553
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

