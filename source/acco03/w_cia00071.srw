$PBExportHeader$w_cia00071.srw
$PBExportComments$원자재투입명세서
forward
global type w_cia00071 from w_standard_print
end type
type rr_2 from roundrectangle within w_cia00071
end type
end forward

global type w_cia00071 from w_standard_print
string title = "원자재투입명세서"
boolean maxbox = true
rr_2 rr_2
end type
global w_cia00071 w_cia00071

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFromYm, sToYm, sNo, sgubun,scost_sabu,scost_nm,sIttyp

dw_ip.AcceptText()

sFromYm  = dw_ip.GetItemString(1,"sfromym")
sToym    = dw_ip.GetItemstring(1, "stoym")
sNo      = dw_ip.GetItemString(1,"sno") 
sIttyp   = dw_ip.GetItemString(1,"ittyp") 
scost_sabu = dw_ip.GetITemString(1,"cost_sabu") 

IF scost_sabu = '99' or scost_sabu = '' or isnull(scost_sabu) THEN
   scost_sabu = '%'
END IF

select rfna1		
into :scost_nm	
from reffpf 
where rfgub  = :scost_sabu and
		sabu = '1'	and 
		rfcod = 'C0';
//----------------------------------------------------
sFromYm = Trim(sFromYm)
IF sFromYm = '' OR ISNULL(sFromYm) THEN
	f_messagechk(1,'[출력년월]')
   dw_ip.SetColumn('sfromym')
	dw_ip.SetFocus()
	Return -1
ELSE
	IF F_DATECHK(sFromYm + '01') = -1 THEN
		f_messagechk(21,'[회계년월]')
	   dw_ip.SetFocus()
	   Return -1	 
	END IF	
END IF	

sToYm = Trim(sToYm)
IF sToYm = '' OR ISNULL(sToYm) THEN
	f_messagechk(1,'[출력년월]')
   dw_ip.SetColumn('stoym')
	dw_ip.SetFocus()
	Return -1
ELSE
	IF F_DATECHK(sToYm + '01') = -1 THEN
		f_messagechk(21,'[회계년월]')
	   dw_ip.SetFocus()
	   Return -1	 
	END IF	
END IF	

If sFromym > sToym then
	f_messagechk(21,'[출력년월범위]')
	dw_ip.SetColumn('sfromym')
	dw_ip.SetFocus()
	Return -1
End If

IF sNo = '' OR ISNULL(sNo) THEN
	sNo = '%'
ELSE
	sNo  = sNo + '%'
END IF	


	dw_list.DataObject = "dw_cia00071_5"	/*투입품번별*/

dw_list.SetTransObject(sqlca)

IF dw_print.Retrieve(scost_sabu,scost_nm,sFromYm, sToYm, sIttyp,sNo) <= 0 THEN
	f_messagechk(14,"") 
	Return -1 
END IF	

dw_print.ShareData(dw_list)

Return 1
end function

on w_cia00071.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_cia00071.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;String sDate

sDate = Left(F_today(),6)
dw_ip.SetItem(1,'sfromym',sdate)
dw_ip.SetItem(1,'stoym',sdate)
dw_ip.SetColumn('sfromym')
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_cia00071
integer taborder = 30
end type

type p_exit from w_standard_print`p_exit within w_cia00071
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_cia00071
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia00071
end type







type st_10 from w_standard_print`st_10 within w_cia00071
end type



type dw_print from w_standard_print`dw_print within w_cia00071
string dataobject = "dw_cia00071_5_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cia00071
integer x = 37
integer y = 20
integer width = 3721
integer height = 160
string dataobject = "dw_cia00071_2"
end type

event dw_ip::itemchanged;String sNo,spordNo,sItnbr,snull

SetNull(snull)

this.AcceptText()

IF This.GetColumnName() = "sno" THEN
   sNo = This.GetText() 
	IF sNo = '' OR ISNULL(sNo) THEN RETURN
		  SELECT "ITEMAS"."ITNBR"  
        INTO :sItnbr  
        FROM "ITEMAS" 
		  WHERE "ITEMAS"."ITNBR" = :sNo ;
		  IF sItnbr = '' OR ISNULL(sItnbr) THEN  
	        f_messagechk(20,'[품번]')
			  this.SetItem(Row,"sno",snull)
			  Return 1 
        END IF
   END IF		

			dw_list.title ="투입품목별"
			dw_list.DataObject ="dw_cia00071_5"
			dw_list.SetTransObject(SQLCA)
			dw_list.Reset()
			dw_print.DataObject ="dw_cia00071_5_p"
			dw_print.SetTransObject(SQLCA)
			dw_print.Reset()
	
	sle_msg.text =""

end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;this.AcceptText()

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.GetColumnName() = "sno" THEN
	   Open(W_ITEMAS_POPUP)
	
	
	IF IsNull(gs_code) OR gs_code = "" THEN Return
	
	THIS.SetItem(THIS.GetRow(), "sno", gs_code)
	
END IF	
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia00071
integer x = 41
integer y = 196
integer width = 4562
integer height = 2040
integer taborder = 40
string dataobject = "dw_cia00071_5"
boolean border = false
end type

type rr_2 from roundrectangle within w_cia00071
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 188
integer width = 4581
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

