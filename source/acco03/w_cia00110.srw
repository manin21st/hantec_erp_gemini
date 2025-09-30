$PBExportHeader$w_cia00110.srw
$PBExportComments$외주가공비 투입 명세서
forward
global type w_cia00110 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia00110
end type
type rr_2 from roundrectangle within w_cia00110
end type
end forward

global type w_cia00110 from w_standard_print
integer x = 0
integer y = 0
string title = "외주가공비 투입명세서"
rr_1 rr_1
rr_2 rr_2
end type
global w_cia00110 w_cia00110

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFromYm, sToYm, sNo, sgubun ,scost_sabu,scost_nm

dw_ip.AcceptText()

sFromYm  = dw_ip.GetItemString(1,"sfromym")
sToym = dw_ip.GetItemstring(1, "stoym")

//sNo  = dw_ip.GetItemString(1,"sno")
scost_sabu = dw_ip.GetITemString(1,"cost_sabu") 

IF scost_sabu = '99' or scost_sabu = '' or isnull(scost_sabu) THEN
   scost_sabu = '%'
END IF

select rfna1		
into :scost_nm	
from reffpf 
where rfgub  = :scost_sabu and rfcod = 'C0';

sFromYm = Trim(sFromYm)
IF sFromYm = '' OR ISNULL(sFromYm) THEN
	f_messagechk(1,'[원가년월]')
   dw_ip.SetColumn('sfromym')
	dw_ip.SetFocus()
	Return -1
ELSE
	IF F_DATECHK(sFromYm + '01') = -1 THEN
		f_messagechk(21,'[원가년월]')
	   dw_ip.SetFocus()
	   Return -1	 
	END IF	
END IF	

sToYm = Trim(sToYm)
IF sToYm = '' OR ISNULL(sToYm) THEN
	f_messagechk(1,'[원가년월]')
   dw_ip.SetColumn('stoym')
	dw_ip.SetFocus()
	Return -1
ELSE
	IF F_DATECHK(sToYm + '01') = -1 THEN
		f_messagechk(21,'[원가년월]')
	   dw_ip.SetFocus()
	   Return -1	 
	END IF	
END IF	

If sFromym > sToym then
	f_messagechk(21,'[원가년월범위]')
	dw_ip.SetColumn('sfromym')
	dw_ip.SetFocus()
	Return -1
End If

IF sNo = '' OR ISNULL(sNo) THEN
	sNo = '%'
ELSE
	sNo  = sNo + '%'
END IF	
dw_list.SetTransObject(sqlca)

IF dw_print.Retrieve(scost_sabu,scost_nm,sFromYm, sToYm, sNo) <= 0 THEN
	f_messagechk(14,"") 
	Return -1 
END IF	
dw_print.ShareData(dw_list)
Return 1
end function

on w_cia00110.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.rr_2
end on

on w_cia00110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;String sDate

sDate = Left(F_today(),6)
dw_ip.SetItem(1,'sfromym',sdate)
dw_ip.SetItem(1,'stoym',sdate)
dw_ip.SetColumn('sfromym')
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_cia00110
end type

type p_exit from w_standard_print`p_exit within w_cia00110
end type

type p_print from w_standard_print`p_print within w_cia00110
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia00110
end type







type st_10 from w_standard_print`st_10 within w_cia00110
end type



type dw_print from w_standard_print`dw_print within w_cia00110
integer x = 3776
integer y = 32
string dataobject = "dw_cia00110_2_P"
end type

type dw_ip from w_standard_print`dw_ip within w_cia00110
integer x = 101
integer y = 44
integer width = 2743
integer height = 92
string dataobject = "dw_cia00110_1"
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
end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;this.AcceptText()

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF this.GetColumnName() = 'sno' THEN
   IF This.DataObject  = "dw_cia00070_2"  THEN /*품번 POPUP*/
	   Open(W_ITEMAS_POPUP)
      
   ELSEIF This.DataObject  = "dw_cia00070_1"  THEN /*작업지시 POPUP*/	
	   Open(W_JISI_POPUP)
	
   END IF	
	IF IsNull(gs_code) OR gs_code = "" THEN Return
	
	THIS.SetItem(THIS.GetRow(), "sno", gs_code)
	
END IF	
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia00110
integer x = 73
integer y = 196
integer width = 4512
integer height = 2028
string dataobject = "dw_cia00110_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_cia00110
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 64
integer y = 188
integer width = 4535
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_cia00110
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 64
integer y = 16
integer width = 2871
integer height = 148
integer cornerheight = 40
integer cornerwidth = 55
end type

