$PBExportHeader$w_kfic22.srw
$PBExportComments$만기일별 보험가입현황
forward
global type w_kfic22 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfic22
end type
end forward

global type w_kfic22 from w_standard_print
integer x = 0
integer y = 0
string title = "만기일별보험관리현황"
rr_1 rr_1
end type
global w_kfic22 w_kfic22

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String syy,smm,sdd,symd_text,styy,stmm,stdd,stymd_text
String sFrom_Date,sTo_Date,sInsur_Co,sInsur_Type

dw_ip.AcceptText()

sFrom_Date  = Trim(dw_ip.GetItemString(1,"from_date"))
sTo_Date    = Trim(dw_ip.GetItemString(1,"to_date"))
sInsur_Type = Trim(dw_ip.GetItemString(1,"insur_type"))
sInsur_Co   = Trim(dw_ip.GetItemString(1,"insur_co"))

IF sFrom_Date = "" OR IsNull(sFrom_Date) THEN
	F_MessageChk(1,'[만기일자]')
	dw_ip.SetColumn("from_date")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(sFrom_Date) = -1 THEN
		f_messagechk(23, "")
		dw_ip.SetColumn("sFrom_Date")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

IF sTo_Date = "" OR IsNull(sTo_Date) THEN
	F_MessageChk(1,'[만기일자]')
	dw_ip.SetColumn("to_date")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(sTo_Date) = -1 THEN
		f_messagechk(23, "")
		dw_ip.SetColumn("sTo_Date")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

//날짜 출력물 헤드에 modify
syy = left(sFrom_date, 4)
smm = mid(sFrom_date,5,2)
sdd = right(sFrom_date,2)
symd_text = syy + '.'+ smm + '.' + sdd

styy = left(sTo_date, 4)
stmm = mid(sTo_date,5,2)
stdd = right(sTo_date,2)
stymd_text = styy + '.'+ stmm + '.' + stdd

//dw_list.modify("symd.text ='"+symd_text+"'")
//dw_list.modify("stymd.text ='"+stymd_text+"'")

dw_print.modify("symd.text ='"+symd_text+"'")
dw_print.modify("stymd.text ='"+stymd_text+"'")

setpointer(hourglass!)

//if dw_list.retrieve(sFrom_Date,sTo_Date,sInsur_Type,sInsur_Co) <= 0 then
//	messagebox("확인","조회한 자료가 없습니다.!!") 
//	return -1
//end if 

IF dw_print.retrieve(sFrom_Date,sTo_Date,sInsur_Type,sInsur_Co) <= 0 then
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

dw_ip.SetFocus()
setpointer(arrow!)

Return 1

end function

on w_kfic22.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfic22.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_kfic22
end type

type p_exit from w_standard_print`p_exit within w_kfic22
end type

type p_print from w_standard_print`p_print within w_kfic22
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfic22
end type







type st_10 from w_standard_print`st_10 within w_kfic22
end type



type dw_print from w_standard_print`dw_print within w_kfic22
string dataobject = "dw_kfic22_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfic22
integer x = 9
integer y = 4
integer width = 2144
integer height = 252
string dataobject = "dw_kfic22_a"
end type

event dw_ip::itemchanged;call super::itemchanged;String sFrom_Date,sTo_Date,sInsur_Co,sInsur_Co_Nm,sNull

SetNull(sNull)
IF this.GetColumnName() = "insur_co" THEN
   sInsur_Co = this.GetText()
	
	if sinsur_co = '' or isnull(sinsur_co) then
		this.Setitem(this.getrow(),"insur_conm",snull)
	end if

   SELECT "KFZ04OM0"."PERSON_NM"
     INTO :sInsur_Co_Nm
     FROM "KFZ04OM0"  
    WHERE "KFZ04OM0"."PERSON_CD" = :sInsur_Co
	   AND "KFZ04OM0"."PERSON_GU" = '2';
   If Sqlca.Sqlcode = 0 then
	      this.Setitem(this.getrow(),"insur_co_nm",sInsur_Co_Nm)
	else
//  		f_messagechk(11,'[주간사]')
//      this.Setitem(this.getrow(),"insur_co",sNull)
//      this.Setitem(this.getrow(),"insur_co_nm",sNull)
//		Return 1
	END IF	
END IF


end event

event dw_ip::rbuttondown;this.accepttext()

IF this.GetColumnName() = "insur_co" THEN
	SetNUll(lstr_custom.code)
	SetNUll(lstr_custom.name)
	
	lstr_custom.code = this.getitemstring(this.getrow(), "insur_co")

	OpenWithParm(w_kfz04om0_popup, '2')
	
   dw_ip.SetItem(this.getrow(),'insur_co', lstr_custom.code)
   dw_ip.SetItem(this.getrow(), "insur_co_nm", lstr_custom.name)
//	this.TriggerEvent(ItemChanged!)
END IF

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfic22
integer y = 292
integer width = 4558
integer height = 2040
string dataobject = "dw_kfic22"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfic22
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 276
integer width = 4613
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

