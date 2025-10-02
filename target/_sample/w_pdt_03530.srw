$PBExportHeader$w_pdt_03530.srw
$PBExportComments$** 작업지시번호별 작업실적현황
forward
global type w_pdt_03530 from w_standard_print
end type
end forward

global type w_pdt_03530 from w_standard_print
string title = "작업지시번호별 작업실적현황"
end type
global w_pdt_03530 w_pdt_03530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String spordno

if dw_ip.AcceptText() = -1 then return -1

spordno = Trim(dw_ip.object.pordno[1])

IF dw_print.retrieve(gs_sabu, spordno) <= 0 THEN
   f_message_chk(50,'[작업지시번호]')
	dw_ip.setfocus()
	Return -1
END IF

   dw_print.sharedata(dw_list)
return 1

end function

on w_pdt_03530.create
call super::create
end on

on w_pdt_03530.destroy
call super::destroy
end on

event open;call super::open;
dw_ip.Setfocus()

end event

type dw_list from w_standard_print`dw_list within w_pdt_03530
integer height = 1964
string title = "작업지시번호별 작업실적현황"
string dataobject = "d_pdt_03530"
end type

type cb_print from w_standard_print`cb_print within w_pdt_03530
integer x = 2903
integer y = 744
end type

type cb_excel from w_standard_print`cb_excel within w_pdt_03530
integer x = 2235
integer y = 744
end type

type cb_preview from w_standard_print`cb_preview within w_pdt_03530
integer x = 2569
integer y = 744
end type

type cb_1 from w_standard_print`cb_1 within w_pdt_03530
integer x = 1902
integer y = 744
end type

type dw_print from w_standard_print`dw_print within w_pdt_03530
integer x = 46
integer y = 2284
string dataobject = "d_pdt_03530_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_03530
integer y = 56
integer height = 188
string dataobject = "d_pdt_03530_a"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemchanged;String spordno, sitdsc, sispec, spspec, snull
Long   spdqty

dw_ip.AcceptText()

SetNull(snull)

IF this.GetColumnName() = "pordno" THEN
	spordno = Trim(this.GetText())
	
  SELECT "ITEMAS"."ITDSC","ITEMAS"."ISPEC","MOMAST"."PSPEC","MOMAST"."PDQTY"
    INTO :sitdsc, :sispec, :spspec, :spdqty
    FROM "MOMAST","ITEMAS"  
   WHERE "MOMAST"."SABU"   = '1'        AND
	      "MOMAST"."PORDNO" = :spordno   AND
			"MOMAST"."ITNBR"  = "ITEMAS"."ITNBR" ;

	if sqlca.sqlcode = 0 then
		this.setitem(1,"pordno",spordno)
		this.setitem(1,"itdsc",sitdsc)
		this.setitem(1,"ispec",sispec)
		this.setitem(1,"pspec",spspec)
		this.setitem(1,"pdqty",spdqty)
	else
		f_message_chk(33,'[지시번호]')
		this.SetItem(1,"pordno",snull)
		this.setitem(1,"itdsc",snull)
		this.setitem(1,"ispec",snull)
		this.setitem(1,"pspec",snull)
		this.setitem(1,"pdqty",snull)
      return 1
   end if
END IF

end event

event dw_ip::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

IF this.GetColumnName() = "pordno"	THEN
	
   gs_code = this.GetText()
	open(w_jisi_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1, "pordno", 	 gs_Code)
   TriggerEvent(Itemchanged!)
   return 1
END IF	

end event

type r_1 from w_standard_print`r_1 within w_pdt_03530
end type

type r_2 from w_standard_print`r_2 within w_pdt_03530
end type

