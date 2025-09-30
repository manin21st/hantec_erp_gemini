$PBExportHeader$w_kfib04.srw
$PBExportComments$받을어음 이력
forward
global type w_kfib04 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfib04
end type
end forward

global type w_kfib04 from w_standard_print
integer x = 0
integer y = 0
string title = "받을어음 이력"
rr_1 rr_1
end type
global w_kfib04 w_kfib04

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sBillNo,sCust,sDateFrom,sDateTo

dw_list.reset()

if dw_ip.AcceptText() = -1 then return -1

sbillNo = dw_ip.GetItemString(1,"billno")
if isnull(sBillNo) or sBillNo = '' then sBillNo = '%'

scust = dw_ip.GetItemString(1,"custf")
if isnull(scust) or scust = '' then scust = '%'

sDatefrom = Trim(dw_ip.GetItemString(dw_ip.getrow(),"datef"))
sDateto   = Trim(dw_ip.GetItemString(dw_ip.getrow(),"datet"))
if isnull(sdatefrom) or sdatefrom = '' then sdatefrom = '00000000'
if isnull(sdateto)   or sdateto   = '' then   sdateto = '99999999'

if sDatefrom > sDateto then
	f_messagechk(26,"발행일자")
	dw_ip.setfocus()
	dw_ip.setcolumn("datef")
	Return -1
end if	

If dw_print.retrieve(sBillNo,sCust,sDateFrom,sDateTo) < 1 then
	f_messagechk(14,"")
	dw_ip.SetFocus()
	dw_list.insertrow(0)
	//Return -1
END IF
dw_print.sharedata(dw_list)
return 1

end function

on w_kfib04.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfib04.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"saupj",Gs_Saupj)

dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_kfib04
integer x = 4059
integer y = 36
end type

type p_exit from w_standard_print`p_exit within w_kfib04
integer x = 4416
integer y = 36
end type

type p_print from w_standard_print`p_print within w_kfib04
integer x = 4238
integer y = 36
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfib04
integer x = 3881
integer y = 36
end type







type st_10 from w_standard_print`st_10 within w_kfib04
end type



type dw_print from w_standard_print`dw_print within w_kfib04
integer x = 3630
integer y = 60
string dataobject = "dw_kfib042_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfib04
integer x = 27
integer y = 32
integer width = 1979
integer height = 236
string dataobject = "dw_kfib041"
end type

event dw_ip::itemchanged;String snull,sacc1,sacc2,sgubun,sCustfNm

SetNull(snull)
sle_msg.text =""

IF dwo.name ="custf" THEN
	IF data = "" OR IsNull(data) THEN Return
	
	SELECT "KFZ04OM0"."PERSON_NM"
   	INTO :scustfnm
   	FROM "KFZ04OM0"  
   	WHERE (( "KFZ04OM0"."PERSON_GU" = '1' ) OR ( "KFZ04OM0"."PERSON_GU" = '99' )) AND
				( "KFZ04OM0"."PERSON_CD" = :data) ;

	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"거래처")
//		dw_ip.SetItem(dw_ip.GetRow(),"custf",snull)
//		Return 1
	ELSE
		dw_ip.SetItem(dw_ip.GetRow(),"custf_1",scustfnm)
	END IF
END IF

IF dwo.name ="datef" THEN
	IF Trim(data) = "" OR IsNull(Trim(data)) THEN Return
	
	IF f_datechk(Trim(data)) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datef",snull)
		Return 1
	END IF
END IF

IF dwo.name ="datef" THEN
	IF Trim(data) = "" OR IsNull(Trim(data)) THEN Return
	
	IF f_datechk(Trim(data)) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datet",snull)
		Return 1
	END IF
END IF


end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;String snull

SetNull(snull)

this.accepttext()

IF this.GetColumnName() ="billno" THEN
	SetNull(gs_code)
	SetNull(gs_codename)

	gs_code =Trim(this.GetItemString(this.GetRow(),"billno"))
	IF IsNull(gs_code) THEN
		gs_code =""
	END IF
	OPEN(W_KFM02OT0_POPUP)
	IF Not IsNull(gs_code) THEN
		this.SetItem(this.GetRow(),"billno",gs_code)
	END IF
END IF

IF this.GetColumnName() ="custf" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code =dw_ip.GetItemString(1,"custf")

	IF IsNull(lstr_custom.code) then
   	lstr_custom.code = ""
	end if

	OpenWithParm(w_kfz04om0_popup1,'1')
	
	IF Not IsNull(lstr_custom.code) THEN
		dw_ip.SetItem(1,"custf",lstr_custom.code)
	END IF
END IF


end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfib04
integer x = 59
integer y = 292
integer width = 4544
integer height = 2028
string dataobject = "dw_kfib042"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfib04
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 284
integer width = 4567
integer height = 2048
integer cornerheight = 40
integer cornerwidth = 55
end type

