$PBExportHeader$w_cia00120.srw
$PBExportComments$계정과목별 원가배부계산표
forward
global type w_cia00120 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia00120
end type
end forward

global type w_cia00120 from w_standard_print
string title = "계정과목별 원가배부계산표"
rr_1 rr_1
end type
global w_cia00120 w_cia00120

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFromym,sToym,sAcc_cd1,sAcc_cd2,sWon_Gubn,sGubn,sCode,scost_sabu,scost_nm


dw_ip.AcceptText()
sFromym   = dw_ip.GetITemString(1,"sfromym")
sToym     = dw_ip.GetItemString(1,"stoym")
sWon_Gubn = dw_ip.GetITemString(1,"sgubn")  
sAcc_cd1  = dw_ip.GetITemString(1,"acc1")
sAcc_cd2  = dw_ip.GetITemString(1,"acc2")

scost_sabu = dw_ip.GetITemString(1,"cost_sabu") 

IF scost_sabu = '99' or scost_sabu = '' or isnull(scost_sabu) THEN
   scost_sabu = '%'
END IF

select rfna1		
into :scost_nm	
from reffpf 
where rfgub  = :scost_sabu and  rfcod = 'C0';

sFromym = Trim(sFromym)
IF sFromym = '' or isnull(sFromym) THEN
   f_messagechk(1,'[원가계산년월]')
	dw_ip.SetColumn("sfromym")
	dw_ip.SetFocus()
	Return -1	
ELSE
	IF F_DATECHK(sFromym + '01') = -1 THEN
		f_messagechk(21,'[원가계산년월]')
	   dw_ip.SetColumn("sfromym")
	   dw_ip.SetFocus()
	   Return -1	 
  END IF	
END IF

sToym = Trim(sToym)
IF sToym = '' or isnull(sToym) THEN
   f_messagechk(1,'[원가계산년월]')
	dw_ip.SetColumn("stoym")
	dw_ip.SetFocus()
	Return -1	
ELSE
	IF F_DATECHK(sToym + '01') = -1 THEN
		f_messagechk(21,'[원가계산년월]')
	   dw_ip.SetColumn("stoym")
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

IF sWon_Gubn = '' OR ISNULL(sWon_Gubn) THEN
	f_messagechk(1,'[원가요소구분]')
	dw_ip.SetColumn("sgubn")
	dw_ip.SetFocus()
	Return -1	
ELSE
	sWon_Gubn = Left(sWon_Gubn,1)+'%'
END IF	
	
	
IF sAcc_cd1 = '' OR ISNULL(sAcc_cd1) AND sAcc_cd2 = '' OR ISNULL(sAcc_cd2)  THEN
	sCode = '%'
ELSE	
	sCode = trim(sAcc_cd1) + trim(sAcc_cd2)
END IF	

IF dw_print.Retrieve(scost_sabu,scost_nm,sFromym,sToym,sWon_Gubn,sCode)  <= 0 THEN
   f_messagechk(14,"") 
	Return -1 	
END IF	
dw_print.ShareData(dw_list)
Return 1
end function

on w_cia00120.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia00120.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetITem(1,"sfromym",Left(f_today(),6))
dw_ip.SetItem(1,"stoym",left(f_today(),6))

dw_ip.SetColumn("sfromym")
dw_ip.Setfocus()
end event

type p_preview from w_standard_print`p_preview within w_cia00120
integer y = 4
end type

type p_exit from w_standard_print`p_exit within w_cia00120
integer y = 4
end type

type p_print from w_standard_print`p_print within w_cia00120
integer y = 4
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia00120
integer y = 4
end type







type st_10 from w_standard_print`st_10 within w_cia00120
end type



type dw_print from w_standard_print`dw_print within w_cia00120
integer x = 4192
integer y = 176
string dataobject = "dw_cia00120_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cia00120
integer x = 46
integer y = 8
integer width = 3049
integer height = 204
string dataobject = "dw_cia00120_1"
end type

event dw_ip::rbuttondown;SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)

this.AcceptText()

IF this.GetColumnName() = "acc1" OR this.GetColumnName() = "acc2" THEN
	lstr_account.acc1_cd = this.object.acc1[1]
	
	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) OR lstr_account.acc1_cd = "" THEN Return
	
	THIS.SetItem(THIS.GetRow(), "acc1", lstr_account.acc1_cd)
	THIS.SetItem(THIS.GetRow(), "acc2", lstr_account.acc2_cd)
	THIS.SetItem(THIS.GetRow(), "acc_name1", lstr_account.acc2_nm)
	
END IF
end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;String sAcc1,sAcc2,sAcc2Name,snull

SetNUll(snull)

IF this.GetColumnName() = "acc1" THEN
	sAcc1 = this.GetText()
	sAcc2 = this.GetItemString(this.GetRow(),"acc2")
	
	IF sAcc1 = "" OR IsNull(sAcc1) AND sAcc2 = "" OR ISNULL(sAcc2) THEN
		this.Setitem(this.getrow(),"acc_name1",sNull)
		RETURN
	END IF	
		
	IF sAcc2 = "" OR IsNull(sAcc2) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"
		INTO :sAcc2Name
	  	FROM "KFZ01OM0"  
	  	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
	If Sqlca.Sqlcode = 0 then
		this.Setitem(this.getrow(),"acc_name1",sAcc2Name)
//	else
//		f_messageChk(20,'[계정과목]')
//		this.Setitem(this.getrow(),"acc1",snull)
//		this.Setitem(this.getrow(),"acc2",snull)
//		this.Setitem(this.getrow(),"acc_name1",sNull)
//		Return 1
	end if
END IF

//IF this.GetColumnName() = "acc2" THEN
//	sAcc2 = this.GetText()
//	sAcc1 = this.GetItemString(this.GetRow(),"acc1")
//	IF sAcc2 = "" OR IsNull(sAcc2) AND sAcc1 = "" OR IsNull(sAcc1)  THEN 
//		this.Setitem(this.getrow(),"acc_name1",sNull)
//		RETURN
//	END IF
//	
//	IF sAcc1 = "" OR IsNull(sAcc1) THEN RETURN
//	
//	SELECT "KFZ01OM0"."ACC2_NM"
//		INTO :sAcc2Name
//	  	FROM "KFZ01OM0"  
//	  	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 ) ;
//	If Sqlca.Sqlcode = 0 then
//		this.Setitem(this.getrow(),"acc_name1",sAcc2Name)
////	else
////		f_messageChk(20,'[계정과목]')
////		this.Setitem(this.getrow(),"acc1",snull)
////		this.Setitem(this.getrow(),"acc2",snull)
////		this.Setitem(this.getrow(),"acc_name1",sNull)
////		Return 1
//		this.SetColumn("acc1")
//		this.SetFocus()
//	end if
//END IF
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_cia00120
integer x = 69
integer y = 228
integer width = 4530
integer height = 2012
string dataobject = "dw_cia00120_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_cia00120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 216
integer width = 4562
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

