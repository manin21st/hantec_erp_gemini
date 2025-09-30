$PBExportHeader$w_cia00050.srw
$PBExportComments$계정과목별 원가배부기준일람표
forward
global type w_cia00050 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia00050
end type
end forward

global type w_cia00050 from w_standard_print
string title = "계정과목별 원가배부기준 일람표"
rr_1 rr_1
end type
global w_cia00050 w_cia00050

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sGubn,sAcc_1,sAcc_2,sBcc_1,sBcc_2,snull

dw_ip.AcceptText()

SetNull(snull)

sGubn  = dw_ip.GetItemString(1,"gubn")
sAcc_1 = dw_ip.GetItemString(1,"acc1")
sAcc_2 = dw_ip.GetItemString(1,"acc2")
sBcc_1 = dw_ip.GetItemString(1,"bcc1")
sBcc_2 = dw_ip.GetItemString(1,"bcc2")

		  
IF sGubn = '4' THEN
	sGubn = '%'
END IF	
IF sAcc_1 = '' OR ISNULL(sAcc_1) THEN
	sAcc_1 = '00000'
END IF	
IF sAcc_2 = '' OR ISNULL(sAcc_2) THEN
	sAcc_2 = '00'
END IF	
IF sBcc_1 = '' OR ISNULL(sBcc_1) THEN
	sBcc_1 = '99999'
END IF	
IF sBcc_2 = '' OR ISNULL(sBcc_2) THEN
	sBcc_2 = '99'
END IF	

IF sAcc_1 > sBcc_1 THEN
   F_MessageChk(26, "[계정과목]")					
	dw_ip.SetITem(1,"acc1",snull)
	dw_ip.SetITem(1,"acc2",snull)
	dw_ip.SetITem(1,"bcc1",snull)
	dw_ip.SetITem(1,"bcc2",snull)
	Return -1
END IF	

IF dw_print.Retrieve(sGubn,sAcc_1,sAcc_2,sBcc_1,sBcc_2) <= 0 THEN
    F_MessageChk(14, "")
	 Return -1
END IF
dw_print.ShareData(dw_list)
Return 1
end function

on w_cia00050.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia00050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_cia00050
integer x = 4091
integer taborder = 30
end type

type p_exit from w_standard_print`p_exit within w_cia00050
integer x = 4439
integer taborder = 50
end type

type p_print from w_standard_print`p_print within w_cia00050
integer x = 4265
integer taborder = 40
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia00050
integer x = 3918
end type







type st_10 from w_standard_print`st_10 within w_cia00050
end type



type dw_print from w_standard_print`dw_print within w_cia00050
string dataobject = "dw_cia00050_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cia00050
integer x = 73
integer width = 3378
integer height = 152
string dataobject = "dw_cia00050_1"
end type

event dw_ip::rbuttondown;SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)

this.AcceptText()

IF this.GetColumnName() = "acc1" THEN
	lstr_account.acc1_cd = this.getitemstring(this.getrow(), "acc1")
	lstr_account.acc2_cd = this.getitemstring(this.getrow(), "acc2")
	
	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) OR lstr_account.acc1_cd = "" THEN Return
	
	THIS.SetItem(THIS.GetRow(), "acc1", lstr_account.acc1_cd)
	THIS.SetItem(THIS.GetRow(), "acc2", lstr_account.acc2_cd)
	THIS.SetItem(THIS.GetRow(), "acc_name", lstr_account.acc2_nm)
	
END IF

IF this.GetColumnName() = "bcc1" THEN
	lstr_account.acc1_cd = this.getitemstring(this.getrow(), "bcc1")
	lstr_account.acc2_cd = this.getitemstring(this.getrow(), "bcc2")
	
	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) OR lstr_account.acc1_cd = "" THEN Return
	
	THIS.SetItem(THIS.GetRow(), "bcc1", lstr_account.acc1_cd)
	THIS.SetItem(THIS.GetRow(), "bcc2", lstr_account.acc2_cd)
	THIS.SetItem(THIS.GetRow(), "bcc_name", lstr_account.acc2_nm)
	
END IF

end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;String  sAcc1,sAcc2,sAcc2Name,snull


this.AcceptText()
SetNull(snull)

IF this.GetColumnName() = "acc1" THEN
	sAcc1 = this.GetText()
	IF sAcc1 = "" OR IsNull(sAcc1) THEN 
		this.Setitem(this.getrow(),"acc2",snull)
		this.Setitem(this.getrow(),"acc_name",sNull)
		RETURN
	END IF
	
	sAcc2 = this.GetItemString(this.GetRow(),"acc2")
	IF sAcc2 = "" OR IsNull(sAcc2) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"
		INTO :sAcc2Name
	  	FROM "KFZ01OM0"  
	  	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"acc_name",sAcc2Name)
	else
//		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"acc1",snull)
		this.Setitem(this.getrow(),"acc2",snull)
		this.Setitem(this.getrow(),"acc_name",sNull)
		Return 
	end if
END IF

IF this.GetColumnName() = "acc2" THEN
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc1) THEN
		this.Setitem(this.getrow(),"acc2",snull)
		this.Setitem(this.getrow(),"acc_name",sNull)
		RETURN
	END IF
	
	sAcc1 = this.GetItemString(this.GetRow(),"acc1")
	IF sAcc1 = "" OR IsNull(sAcc2) THEN	RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"
		INTO :sAcc2Name
	  	FROM "KFZ01OM0"  
	  	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"acc_name",sAcc2Name)
	else
//		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"acc1",snull)
		this.Setitem(this.getrow(),"acc2",snull)
		this.Setitem(this.getrow(),"acc_name",sNull)
		Return 
		this.SetColumn("acc1")
		this.SetFocus()
	end if
END IF

IF this.GetColumnName() = "bcc1" THEN
	sAcc1 = this.GetText()
	IF sAcc1 = "" OR IsNull(sAcc1) THEN 
		this.Setitem(this.getrow(),"bcc2",snull)
		this.Setitem(this.getrow(),"bcc_name",sNull)
		RETURN
	END IF
	
	sAcc2 = this.GetItemString(this.GetRow(),"bcc2")
	IF sAcc2 = "" OR IsNull(sAcc2) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"
		INTO :sAcc2Name
	  	FROM "KFZ01OM0"  
	  	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"bcc_name",sAcc2Name)
	else
//		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"bcc1",snull)
		this.Setitem(this.getrow(),"bcc2",snull)
		this.Setitem(this.getrow(),"bcc_name",sNull)
		Return 
	end if
END IF

IF this.GetColumnName() = "bcc2" THEN
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN
		this.Setitem(this.getrow(),"bcc1_cd",snull)
		this.Setitem(this.getrow(),"bcc_name",sNull)
		RETURN
	END IF
	
	sAcc1 = this.GetItemString(this.GetRow(),"bcc1")
	IF sAcc1 = "" OR IsNull(sAcc2) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"
		INTO :sAcc2Name
	  	FROM "KFZ01OM0"  
	  	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"bcc_name",sAcc2Name)
	else
//		f_messageChk(20,'[계정과목]')
		this.Setitem(this.getrow(),"bcc1_cd",snull)
		this.Setitem(this.getrow(),"bcc2_cd",snull)
		this.Setitem(this.getrow(),"bcc_name",sNull)
		Return 
		this.SetColumn("bcc1")
		this.SetFocus()
	end if
END IF

end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia00050
integer x = 78
integer y = 192
integer width = 4521
integer height = 2068
string dataobject = "dw_cia00050_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_cia00050
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 184
integer width = 4544
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

