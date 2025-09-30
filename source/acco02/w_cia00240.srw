$PBExportHeader$w_cia00240.srw
$PBExportComments$원가요소 배부내역표
forward
global type w_cia00240 from w_standard_print
end type
type rr_1 from roundrectangle within w_cia00240
end type
end forward

global type w_cia00240 from w_standard_print
string title = "원가요소 배부내역표"
rr_1 rr_1
end type
global w_cia00240 w_cia00240

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFromym,sToym,sAcc_cd1,sAcc_cd2,sWon_Gubn,sGubn,sCode,sSaupj

w_mdi_frame.sle_msg.text = ''

dw_ip.AcceptText()
sSaupj    = dw_ip.GetITemString(1,"cost_saup")
sFromym   = dw_ip.GetITemString(1,"sfromym")
sToym     = dw_ip.GetItemString(1,"stoym")
sWon_Gubn = dw_ip.GetITemString(1,"sgubn")  
sAcc_cd1  = dw_ip.GetITemString(1,"acc1")
sAcc_cd2  = dw_ip.GetITemString(1,"acc2")

IF sSaupj = '' or IsNull(sSaupj) then sSaupj = '%'

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
	sWon_Gubn = '%'
END IF	
	
	
IF sAcc_cd1 = '' OR ISNULL(sAcc_cd1) AND sAcc_cd2 = '' OR ISNULL(sAcc_cd2)  THEN
	sCode = '%'
ELSE	
	sCode = trim(sAcc_cd1) + trim(sAcc_cd2)
END IF	

IF dw_print.Retrieve(sSaupj,sFromym,sToym,sWon_Gubn,sCode)  <= 0 THEN
   f_messagechk(14,"") 
	Return -1 	
END IF	
dw_print.ShareData(dw_list)

w_mdi_frame.sle_msg.text = '[부문별상세:F2 품목별상세:F3]'
Return 1
end function

on w_cia00240.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cia00240.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetITem(1,"sfromym",Left(f_today(),6))
dw_ip.SetItem(1,"stoym",left(f_today(),6))

dw_ip.SetColumn("sfromym")
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_cia00240
boolean visible = false
integer x = 3835
integer y = 0
end type

type p_exit from w_standard_print`p_exit within w_cia00240
end type

type p_print from w_standard_print`p_print within w_cia00240
boolean visible = false
integer x = 4009
integer y = 0
end type

type p_retrieve from w_standard_print`p_retrieve within w_cia00240
integer x = 4270
end type







type st_10 from w_standard_print`st_10 within w_cia00240
end type



type dw_print from w_standard_print`dw_print within w_cia00240
integer x = 3689
integer y = 24
string dataobject = "dw_cia002402"
end type

type dw_ip from w_standard_print`dw_ip within w_cia00240
integer x = 37
integer y = 32
integer width = 3872
integer height = 136
string dataobject = "dw_cia002401"
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

type dw_list from w_standard_print`dw_list within w_cia00240
integer x = 55
integer y = 192
integer width = 4512
integer height = 2004
string dataobject = "dw_cia002402"
boolean border = false
end type

event dw_list::u_key;String sArg

choose case key
	case keyF2!
		sArg = this.GetItemString(GetSelectedRow(0),"cost_guc") + &
				 dw_ip.GetItemString(1,"sfromym") +&
				 this.GetItemString(GetSelectedRow(0),"accode") + &
				 this.GetItemString(GetSelectedRow(0),"cia20ot_ucost_cd")
		OpenWithParm(w_cia00242, sArg)
	case keyF3!
		sArg = this.GetItemString(GetSelectedRow(0),"cost_guc") + &
				 this.GetItemString(GetSelectedRow(0),"pdtgu") + &
				 this.GetItemString(GetSelectedRow(0),"accode") + &
				 dw_ip.GetItemString(1,"sfromym") + &
				 this.GetItemString(GetSelectedRow(0),"cia02m_cost_nm")
		OpenWithParm(w_cia00241, sArg)
end choose
end event

event dw_list::clicked;call super::clicked;

if row <=0 then Return

SelectRow(0,False)
SelectRow(row,True)


end event

type rr_1 from roundrectangle within w_cia00240
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 180
integer width = 4576
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

