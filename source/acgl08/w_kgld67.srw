$PBExportHeader$w_kgld67.srw
$PBExportComments$반제처리 현황 조회 출력
forward
global type w_kgld67 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgld67
end type
end forward

global type w_kgld67 from w_standard_print
integer x = 0
integer y = 0
string title = "반제 처리 현황 조회 출력"
rr_1 rr_1
end type
global w_kgld67 w_kgld67

forward prototypes
public function integer wf_print ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_print ();Return 1
end function

public function integer wf_retrieve ();String sSaupj,sBaseDateF,sBaseDateT,sAcc1,sAcc2,sCustF,sCustT,sAcc,sSaupName,sAccName

IF dw_ip.AcceptText() = -1 then return -1

sSaupj    = dw_ip.GetItemString(1,"saupj")

sBaseDateF = Trim(dw_ip.GetItemString(1,"k_symd"))
sBaseDateT = Trim(dw_ip.GetItemString(1,"k_eymd"))

sAcc1     = dw_ip.getitemstring(1,"sacc1")
sAcc2     = dw_ip.getitemstring(1,"sacc2")
sAccName  = dw_ip.getitemstring(1,"saccname")

sCustF    = Trim(dw_ip.GetItemString(1,"fr_incd"))
sCustT    = Trim(dw_ip.GetItemString(1,"to_incd"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sBaseDateF = "" OR IsNull(sBaseDateF) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	Return -1
END IF
IF sBaseDateT = "" OR IsNull(sBaseDateT) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_eymd")
	dw_ip.SetFocus()
	Return -1
END IF
IF sAcc1 ="" OR IsNull(sAcc1) OR sAcc2 = "" OR IsNull(sAcc2) THEN
	F_MessageChk(1,'[계정과목]')
	dw_ip.SetColumn("sacc1")
	dw_ip.SetFocus()
	Return -1
ELSE
	sAcc = sAcc1 + sAcc2
END IF

IF sCustF = "" OR IsNull(sCustF) THEN sCustF = '0'
IF sCustT = "" OR IsNull(sCustT) THEN sCustT = 'zzzzzzzzzzzzzzzzzzzz'

dw_list.SetRedraw(false)
IF dw_print.Retrieve(sabu_f,	sabu_t,	sAcc,	sBaseDateF,	 sBaseDateT,sCustF,	sCustT, sAccName) <=0 THEN
	f_Messagechk(14, "")
	dw_list.insertrow(0)
 	dw_list.Reset()
   dw_list.SetRedraw(true)		
//	return -1
END IF
dw_print.sharedata(dw_list)
dw_list.SetRedraw(true)

Return 1
end function

on w_kgld67.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgld67.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"saupj", gs_saupj)
dw_ip.SetItem(1,"k_symd", Left(f_today(),6)+'01')
dw_ip.SetItem(1,"k_eymd", f_today())
dw_ip.Setfocus()

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
	
	dw_ip.Modify("saupj.protect = 1")
//	dw_ip.Modify("saupj.background.color ='"+String(RGB(192,192,192))+"'")
ELSE
	dw_ip.Modify("saupj.protect = 0")
//	dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")
END IF	


end event

type p_preview from w_standard_print`p_preview within w_kgld67
end type

type p_exit from w_standard_print`p_exit within w_kgld67
end type

type p_print from w_standard_print`p_print within w_kgld67
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld67
end type

type st_window from w_standard_print`st_window within w_kgld67
integer x = 2409
integer width = 462
end type

type sle_msg from w_standard_print`sle_msg within w_kgld67
integer width = 2011
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgld67
integer x = 2866
end type

type st_10 from w_standard_print`st_10 within w_kgld67
end type

type gb_10 from w_standard_print`gb_10 within w_kgld67
integer width = 3607
end type

type dw_print from w_standard_print`dw_print within w_kgld67
string dataobject = "dw_kgld672_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld67
integer x = 46
integer width = 3163
integer height = 316
string dataobject = "dw_kgld671"
end type

event dw_ip::rbuttondown;String ssql_gaej1,snull

SetNull(snull)

dw_ip.AcceptText()

IF this.GetColumnName() ="sacc1" THEN	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)
	
	lstr_account.acc1_cd = dw_ip.GetItemString(dw_ip.GetRow(), "sacc1")
	lstr_account.acc2_cd = dw_ip.GetItemString(dw_ip.GetRow(), "sacc2")
	
	IF IsNull(lstr_account.acc1_cd) THEN
		lstr_account.acc1_cd =""
	END IF
	
	IF IsNull(lstr_account.acc2_cd) THEN
		lstr_account.acc2_cd =""
	END IF
	
	Open(W_KFZ01OM0_POPUP)
	
	IF IsNull(lstr_account.acc1_cd) OR lstr_account.acc1_cd = "" THEN Return
	
	this.SetItem(1,"sacc1",lstr_account.acc1_cd)
	this.SetItem(1,"sacc2",lstr_account.acc2_cd)
	this.SetItem(1,"saccname",lstr_account.acc2_nm)
	this.TriggerEvent(ItemChanged!)
	Return
END IF
IF this.GetColumnName() ="fr_incd" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)
	
	lstr_custom.code = dw_ip.GetItemString(dw_ip.GetRow(),"fr_incd")
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF
	
	if lstr_account.gbn1 = '' or isnull(lstr_account.gbn1) then lstr_account.gbn1 = '%'
	
	OpenWithParm(W_KFZ04OM0_POPUP,lstr_account.gbn1)
	
	IF IsNull(lstr_custom) THEN
		dw_ip.SetItem(dw_ip.GetRow(), "fr_incd",snull)
		dw_ip.SetItem(dw_ip.GetRow(), "fr_innm",snull)
	ELSE	
		dw_ip.SetItem(dw_ip.GetRow(), "fr_incd",lstr_custom.code)
		dw_ip.SetItem(dw_ip.GetRow(), "fr_innm",lstr_custom.name)
	END IF
END IF

IF this.GetColumnName() ="to_incd" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = dw_ip.GetItemString(dw_ip.GetRow(),"to_incd")
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF
	
	if lstr_account.gbn1 = '' or isnull(lstr_account.gbn1) then lstr_account.gbn1 = '%'
		
	OpenWithParm(W_KFZ04OM0_POPUP,lstr_account.gbn1)
	
	IF IsNull(lstr_custom) THEN
		dw_ip.SetItem(dw_ip.GetRow(), "to_incd",snull)
		dw_ip.SetItem(dw_ip.GetRow(), "to_innm",snull)
	ELSE	
		dw_ip.SetItem(dw_ip.GetRow(), "to_incd",lstr_custom.code)
		dw_ip.SetItem(dw_ip.GetRow(), "to_innm",lstr_custom.name)
	END IF
END IF

end event

event dw_ip::itemchanged;
String snull,sSaupj,sYearMonthDay,sAcc1,sAcc2,sSql_gaej1,sSql_gaej2,sSangGbn,sBalGbn,sCustF,sCustT,sCustName,&
		 sCustPrtGbn
 
SetNull(snull)

IF this.GetColumnName() = "saupj" THEN
	sSaupj = this.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		this.SetItem(this.GetRow(),"saupj",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "k_symd" THEN
	sYearMonthDay = Trim(this.GetText())
	IF sYearMonthDay = "" OR IsNull(sYearMonthDay) THEN Return
	
	IF F_DateChk(sYearMonthDay) = -1 THEN
		F_MessageChk(21,'[회계일자]')
		this.SetItem(this.GetRow(),"k_symd",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "k_eymd" THEN
	sYearMonthDay = Trim(this.GetText())
	IF sYearMonthDay = "" OR IsNull(sYearMonthDay) THEN Return
	
	IF F_DateChk(sYearMonthDay) = -1 THEN
		F_MessageChk(21,'[회계일자]')
		this.SetItem(this.GetRow(),"k_eymd",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="sacc1" THEN
	sAcc1 = this.GetText()
	IF sAcc1 = "" OR IsNull(sAcc1) THEN
		dw_ip.SetItem(1,"sacc2",sNull)
		dw_ip.SetItem(1,"saccname",sNull)
		Return
	END IF
	
	sAcc2 = dw_ip.GetItemString(dw_ip.GetRow(),"sacc2")	
	IF sacc2 ="" OR IsNull(sacc2) THEN Return
	
    SELECT "KFZ01OM0"."ACC1_NM",	"KFZ01OM0"."ACC2_NM",		 "KFZ01OM0"."GBN6",
	 		  "KFZ01OM0"."GBN1",		"KFZ01OM0"."SANG_GU",		 "KFZ01OM0"."BAL_GU"
    	INTO :ssql_gaej1,				:ssql_gaej2,					 :sCustPrtGbn,	
		 	  :lstr_account.gbn1,	:sSangGbn,						 :sBalGbn
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 );  
			
	IF SQLCA.SQLCODE = 0 THEN
		IF sBalGbn = '4' THEN
			f_Messagechk(28,"")
		   dw_ip.SetItem(1,"sacc1",snull)
			dw_ip.SetItem(1,"sacc2",snull)
			dw_ip.SetItem(1,"saccname",snull)
			SetNull(lstr_account.gbn1)
			Return 1
		END IF
		
		IF sSangGbn = 'N' OR IsNull(sSangGbn) OR sSangGbn = '' THEN
			F_MessageChk(31,'')
			dw_ip.SetItem(1,"sacc1",sNull)
			dw_ip.SetItem(1,"sacc2",sNull)
			dw_ip.SetItem(1,"saccname",sNull)
			Return 1
		ELSE
			dw_ip.SetItem(1,"saccname",ssql_gaej1+'-'+ssql_gaej2)
		END IF
	ELSE
//     	f_Messagechk(28,"")
//	   dw_ip.SetItem(1,"sacc1",snull)
//		dw_ip.SetItem(1,"sacc2",snull)
//		dw_ip.SetItem(1,"saccname",snull)
//		
//		SetNull(lstr_account.gbn1)
//		
//		dw_ip.SetColumn("sacc1")
//		dw_ip.SetFocus()
//	   Return 1
	END IF
END IF

IF this.GetColumnName() ="sacc2" THEN
	sAcc2 = this.GetText()
	IF sAcc2 = "" OR IsNull(sAcc2) THEN
		dw_ip.SetItem(1,"saccname",sNull)
		Return
	END IF
	
	sAcc1 = dw_ip.GetItemString(dw_ip.GetRow(),"sacc1")	
	IF sacc1 ="" OR IsNull(sacc1) THEN Return
	
    SELECT "KFZ01OM0"."ACC1_NM",	"KFZ01OM0"."ACC2_NM",	    "KFZ01OM0"."GBN6",
	 		  "KFZ01OM0"."GBN1",		"KFZ01OM0"."SANG_GU",		 "KFZ01OM0"."BAL_GU"
    	INTO :ssql_gaej1,				:ssql_gaej2,				    :sCustPrtGbn,
		 	  :lstr_account.gbn1,	:sSangGbn,						 :sBalGbn
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 );  
			
	IF SQLCA.SQLCODE = 0 THEN
		IF sBalGbn = '4' THEN
			f_Messagechk(28,"")
		   dw_ip.SetItem(1,"sacc1",snull)
			dw_ip.SetItem(1,"sacc2",snull)
			dw_ip.SetItem(1,"saccname",snull)
			SetNull(lstr_account.gbn1)
			dw_ip.SetColumn("sacc1")
			dw_ip.SetFocus()
			Return 1
		END IF
		
		IF sSangGbn = 'N' OR IsNull(sSangGbn) OR sSangGbn = '' THEN
			F_MessageChk(31,'')
			dw_ip.SetItem(1,"sacc1",sNull)
			dw_ip.SetItem(1,"sacc2",sNull)
			dw_ip.SetItem(1,"saccname",sNull)
			Return 1
		ELSE
			dw_ip.SetItem(1,"saccname",ssql_gaej1+'-'+ssql_gaej2)
		END IF
	ELSE
//     	f_Messagechk(28,"")
//	   dw_ip.SetItem(1,"sacc1",snull)
//		dw_ip.SetItem(1,"sacc2",snull)
//		dw_ip.SetItem(1,"saccname",snull)
//		
//		SetNull(lstr_account.gbn1)
//		
//		dw_ip.SetColumn("sacc1")
//		dw_ip.SetFocus()
//	   Return 1
	END IF
END IF

IF this.GetColumnName() ="fr_incd" THEN
	sCustF = this.GetText()
	IF sCustF = '' OR IsNull(sCustF) THEN
		this.SetItem(1,"fr_innm",snull)
		Return
	END IF
	
	IF lstr_account.gbn1 ="" OR IsNull(lstr_account.gbn1) OR lstr_account.gbn1 =' ' THEN
		lstr_account.gbn1 = '%'
	END IF
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
		FROM "KFZ04OM0"  
		WHERE ( "KFZ04OM0"."PERSON_CD" = :sCustF) AND 
				(( "KFZ04OM0"."PERSON_GU" like :lstr_account.gbn1) OR 
				( "KFZ04OM0"."PERSON_GU" = '99')) AND
				( "KFZ04OM0"."PERSON_STS" = '1');
	
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"fr_innm",sCustName)
	ELSE
//		f_Messagechk(20,"[거래처]") 
//		dw_ip.SetItem(1,"fr_incd",snull)
//		dw_ip.SetItem(1,"fr_innm",snull)
//		Return 1
	END IF
END IF

IF this.GetColumnName() ="to_incd" THEN
	sCustT = this.GetText()
	IF sCustT = '' OR IsNull(sCustT) THEN
		this.SetItem(1,"to_innm",snull)
		Return
	END IF
	
	IF lstr_account.gbn1 ="" OR IsNull(lstr_account.gbn1) OR lstr_account.gbn1 =' ' THEN
		lstr_account.gbn1 = '%'
	END IF
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
		FROM "KFZ04OM0"  
		WHERE ( "KFZ04OM0"."PERSON_CD" = :sCustT) AND 
				(( "KFZ04OM0"."PERSON_GU" like :lstr_account.gbn1) OR 
				( "KFZ04OM0"."PERSON_GU" = '99')) AND
				( "KFZ04OM0"."PERSON_STS" = '1');
	
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"to_innm",sCustName)
	ELSE
//		f_Messagechk(20,"[거래처]") 
//		dw_ip.SetItem(1,"to_incd",snull)
//		dw_ip.SetItem(1,"to_innm",snull)
//		Return 1
	END IF
END IF


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::ue_key;IF key = keyf1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kgld67
integer x = 73
integer y = 352
integer width = 4512
integer height = 1944
string title = "반제처리 현황"
string dataobject = "dw_kgld672"
boolean border = false
end type

type rr_1 from roundrectangle within w_kgld67
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 340
integer width = 4558
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

