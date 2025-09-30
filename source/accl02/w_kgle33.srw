$PBExportHeader$w_kgle33.srw
$PBExportComments$이자율 명세서
forward
global type w_kgle33 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgle33
end type
end forward

global type w_kgle33 from w_standard_print
string title = "이자율 명세서"
rr_1 rr_1
end type
global w_kgle33 w_kgle33

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sSaupj,sSdate,sTdate,sSacc1_cd,sSAcc2_Cd,sTacc1_cd,sTacc2_cd
Int     il_rowCount, i
		  
dw_ip.AcceptText()

sle_msg.text =""

sSaupj      = dw_ip.GetItemString(1,"saupj")
sSdate      = Trim(dw_ip.GetItemString(1,"sdate"))
sTdate      = Trim(dw_ip.GetItemString(1,"tdate"))
sSacc1_cd   = dw_ip.GetItemString(1,"sacc1_cd")
sSacc2_cd   = dw_ip.GetItemString(1,"sacc2_cd")
sTacc1_cd   = dw_ip.GetItemString(1,"tacc1_cd")
sTacc2_cd   = dw_ip.GetItemString(1,"tacc2_cd")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sSaupj = "99" THEN sSaupj = '%'

IF sSdate = "" OR IsNull(sSdate) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	Return -1
END IF
IF sTdate = "" OR IsNull(sTdate) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("tdate")
	dw_ip.SetFocus()
	Return -1
END IF

IF sSacc1_cd = "" OR IsNull(sSacc1_cd) THEN sSacc1_cd = '00000'
IF sSacc2_cd = "" OR IsNull(sSacc2_cd) THEN sSacc2_cd = '00'

IF sTacc1_cd = "" OR IsNull(sTacc1_cd) THEN sTacc1_Cd = '99999'
IF sTacc2_cd = "" OR IsNull(sTacc2_cd) THEN sTacc2_Cd = '99'

IF dw_print.Retrieve(sSaupj,sSdate,sTdate,sSacc1_cd+sSacc2_Cd,sTacc1_cd+sTacc2_cd) <=0 THEN
	f_MessageChk(14,"")
	Return -1
END IF

dw_print.ShareData(dw_list)

Return 1
end function

on w_kgle33.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgle33.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.Getrow(),"sdate",Left(f_today(),4)+'0101')
dw_ip.SetItem(dw_ip.Getrow(),"tdate",f_today())
dw_ip.SetFocus()

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
	
	dw_ip.Modify("saupj.protect = 1")
//	dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
ELSE
	dw_ip.Modify("saupj.protect = 0")
//	dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")
END IF	

end event

type p_preview from w_standard_print`p_preview within w_kgle33
end type

type p_exit from w_standard_print`p_exit within w_kgle33
end type

type p_print from w_standard_print`p_print within w_kgle33
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgle33
end type







type st_10 from w_standard_print`st_10 within w_kgle33
end type



type dw_print from w_standard_print`dw_print within w_kgle33
string dataobject = "d_kgle332_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgle33
integer y = 24
integer width = 3762
integer height = 160
string dataobject = "d_kgle331"
end type

event dw_ip::itemchanged;String sAcc1,sAcc2,sAccName,sBalGbn,sNull

SetNull(sNull)

//IF this.GetColumnName() ="sacc1_cd" THEN
//	sAcc1 = this.GetText()
//	IF sAcc1 = "" OR IsNull(sAcc1) THEN 
//		this.SetItem(this.GetRow(),"sacc_nm",snull)
//		Return
//	END IF
//	
//	sAcc2 = this.GetItemString(1,"sacc2_cd")
//	IF sAcc2 = "" OR IsNull(sAcc2) THEN 
//		this.SetItem(this.GetRow(),"sacc_nm",snull)
//		Return
//	END IF
//	
//	SELECT "ACC2_NM",	"BAL_GU"	   	INTO :sAccname,	:sBalGbn
//   	FROM "KFZ01OM0"  
//   	WHERE ( "ACC1_CD"||"ACC2_CD" = :sAcc1||:sAcc2) ;				
//	IF SQLCA.SQLCODE = -1 OR SQLCA.SQLCODE = 100 THEN
//		F_MessageChk(20,'[계정과목]')
//		this.SetItem(this.GetRow(),"sacc1_cd",snull)
//		this.SetItem(this.GetRow(),"sacc2_cd",snull)
//		this.SetItem(this.GetRow(),"sacc_nm",snull)
//		Return 1
//	ELSE
//		IF sBalGbn ='4' THEN
//			F_MessageChk(16,'[전표발행불가]')
//			this.SetItem(this.GetRow(),"sacc1_cd",snull)
//			this.SetItem(this.GetRow(),"sacc2_cd",snull)
//			this.SetItem(this.GetRow(),"sacc_nm",snull)
//			Return 1
//		END IF
//		this.SetItem(this.GetRow(),"sacc_nm",sAccName)
//	END IF
//END IF

IF this.GetColumnName() ="sacc2_cd" THEN
	sAcc2 = this.GetText()
	IF sAcc2= "" OR IsNull(sAcc2) THEN 
		this.SetItem(this.GetRow(),"sacc_nm",snull)
		Return
	END IF
	
	sAcc1 = this.GetItemString(1,"sacc1_cd")
	IF sAcc1 = "" OR IsNull(sAcc1) THEN 
		this.SetItem(this.GetRow(),"sacc_nm",snull)
		Return
	END IF
	
	SELECT "ACC2_NM",	"BAL_GU"	   	INTO :sAccname,	:sBalGbn
   	FROM "KFZ01OM0"  
   	WHERE ( "ACC1_CD"||"ACC2_CD" = :sAcc1||:sAcc2) ;				
	IF SQLCA.SQLCODE = -1 OR SQLCA.SQLCODE = 100 THEN
//		F_MessageChk(20,'[계정과목]')
//		this.SetItem(this.GetRow(),"sacc1_cd",snull)
//		this.SetItem(this.GetRow(),"sacc2_cd",snull)
//		this.SetItem(this.GetRow(),"sacc_nm",snull)
//		Return 1
	ELSE
		IF sBalGbn ='4' THEN
			F_MessageChk(16,'[전표발행불가]')
			this.SetItem(this.GetRow(),"sacc1_cd",snull)
			this.SetItem(this.GetRow(),"sacc2_cd",snull)
			this.SetItem(this.GetRow(),"sacc_nm",snull)
			Return 1
		END IF
		this.SetItem(this.GetRow(),"sacc_nm",sAccName)
	END IF
END IF

//IF this.GetColumnName() ="tacc1_cd" THEN
//	sAcc1 = this.GetText()
//	IF sAcc1 = "" OR IsNull(sAcc1) THEN 
//		this.SetItem(this.GetRow(),"tacc_nm",snull)
//		Return 
//	END IF
//
//	sAcc2 = this.GetItemString(1,"tacc2_cd")
//	IF sAcc2 = "" OR IsNull(sAcc2) THEN 
//		this.SetItem(this.GetRow(),"tacc_nm",snull)
//		Return
//	END IF
//
//	SELECT "ACC2_NM",	"BAL_GU"	   	INTO :sAccname,	:sBalGbn
//   	FROM "KFZ01OM0"  
//   	WHERE ( "ACC1_CD"||"ACC2_CD" = :sAcc1||:sAcc2) ;				
//	IF SQLCA.SQLCODE = -1 OR SQLCA.SQLCODE = 100 THEN
//		F_MessageChk(20,'[계정과목]')
//		this.SetItem(this.GetRow(),"tacc1_cd",snull)
//		this.SetItem(this.GetRow(),"tacc2_cd",snull)
//		this.SetItem(this.GetRow(),"tacc_nm",snull)
//		Return 1
//	ELSE
//		IF sBalGbn ='4' THEN
//			F_MessageChk(16,'[전표발행불가]')
//			this.SetItem(this.GetRow(),"tacc1_cd",snull)
//			this.SetItem(this.GetRow(),"tacc2_cd",snull)
//			this.SetItem(this.GetRow(),"tacc_nm",snull)
//			Return 1
//		END IF
//		this.SetItem(this.GetRow(),"tacc_nm",sAccName)
//	END IF
//END IF
//
IF this.GetColumnName() ="tacc2_cd" THEN
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN 
		this.SetItem(this.GetRow(),"tacc_nm",snull)
		Return 
	END IF

	sAcc1 = this.GetItemString(1,"tacc1_cd")
	IF sAcc1 = "" OR IsNull(sAcc1) THEN 
		this.SetItem(this.GetRow(),"tacc_nm",snull)
		Return
	END IF

	SELECT "ACC2_NM",	"BAL_GU"	   	INTO :sAccname,	:sBalGbn
   	FROM "KFZ01OM0"  
   	WHERE ( "ACC1_CD"||"ACC2_CD" = :sAcc1||:sAcc2) ;				
	IF SQLCA.SQLCODE = -1 OR SQLCA.SQLCODE = 100 THEN
//		F_MessageChk(20,'[계정과목]')
//		this.SetItem(this.GetRow(),"tacc1_cd",snull)
//		this.SetItem(this.GetRow(),"tacc2_cd",snull)
//		this.SetItem(this.GetRow(),"tacc_nm",snull)
//		Return 1
	ELSE
		IF sBalGbn ='4' THEN
			F_MessageChk(16,'[전표발행불가]')
			this.SetItem(this.GetRow(),"tacc1_cd",snull)
			this.SetItem(this.GetRow(),"tacc2_cd",snull)
			this.SetItem(this.GetRow(),"tacc_nm",snull)
			Return 1
		END IF
		this.SetItem(this.GetRow(),"tacc_nm",sAccName)
	END IF
END IF


end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;this.accepttext()

SetNull(lstr_account.acc1_cd)	
SetNull(lstr_account.acc2_cd)
SetNull(lstr_account.acc1_nm)	
SetNull(lstr_account.acc2_nm)

IF this.GetColumnName() ="sacc1_cd" THEN
 		
	lstr_account.acc1_cd = this.object.sacc1_cd[this.getrow()]
	lstr_account.acc2_cd = this.object.sacc2_cd[this.getrow()]

	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	this.SetItem(this.GetRow(),"sacc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"sacc2_cd",lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"sacc_nm",lstr_account.acc2_nm)
//	this.TriggerEvent(ItemChanged!)
	Return
END IF

IF this.GetColumnName() ="tacc1_cd" THEN
	
	lstr_account.acc1_cd = this.object.tacc1_cd[this.getrow()]
	lstr_account.acc2_cd = this.object.tacc2_cd[this.getrow()]

	Open(W_KFZ01OM0_POPUP)

	IF IsNull(lstr_account.acc1_cd) AND IsNull(lstr_account.acc2_cd) THEN RETURN
	
	this.SetItem(this.GetRow(),"tacc1_cd",lstr_account.acc1_cd)
	this.SetItem(this.GetRow(),"tacc2_cd",lstr_account.acc2_cd)
	this.SetItem(this.GetRow(),"tacc_nm",lstr_account.acc2_nm)
//	this.TriggerEvent(ItemChanged!)
	Return
END IF

end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kgle33
integer x = 64
integer y = 188
integer width = 4521
integer height = 2016
string dataobject = "d_kgle332"
boolean border = false
end type

type rr_1 from roundrectangle within w_kgle33
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 184
integer width = 4558
integer height = 2028
integer cornerheight = 40
integer cornerwidth = 55
end type

