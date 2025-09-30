$PBExportHeader$w_kgld11.srw
$PBExportComments$미반제내역 조회 출력(월집계)
forward
global type w_kgld11 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgld11
end type
end forward

global type w_kgld11 from w_standard_print
integer x = 0
integer y = 0
string title = "미반제 내역 조회 출력(월집계)"
rr_1 rr_1
end type
global w_kgld11 w_kgld11

forward prototypes
public function integer wf_print ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_print ();Return 1
end function

public function integer wf_retrieve ();String  sSaupj,sBaseDate,sAcc1,sAcc2,sAccName,sCustF,sCustT,sBeforeYm[6],sDcrGu,sSaupName
Integer k

IF dw_ip.AcceptText() = -1 then return -1

sSaupj    = dw_ip.GetItemString(1,"saupj")
sBaseDate = Trim(dw_ip.GetItemString(1,"k_symd"))
sAcc1     = dw_ip.getitemstring(1,"sacc1")
sAcc2     = dw_ip.getitemstring(1,"sacc2")
sCustF    = Trim(dw_ip.GetItemString(1,"fr_incd"))
sCustT    = Trim(dw_ip.GetItemString(1,"to_incd"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sBaseDate = "" OR IsNull(sBaseDate) THEN
	F_MessageChk(1,'[기준일자]')
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	Return -1
ELSE
	sBeforeYm[1] = Left(sBaseDate,6)
	FOR k = 1 TO 5
		IF Integer(Mid(sBaseDate,5,2)) <= k THEN						/*시작년월 = 기준년월 - 5*/
			sBeforeYm[k + 1] = String(Integer(Left(sBaseDate,4)) - 1,'0000') + &
												String((Integer(Mid(sBaseDate,5,2)) - k) + 12,'00')
		ELSE
			sBeforeYm[k + 1] = String(Integer(Left(sBaseDate,4)),'0000') + &
												String(Integer(Mid(sBaseDate,5,2)) - k,'00')								
		END IF
	NEXT
END IF

IF sAcc1 ="" OR IsNull(sAcc1) THEN
	F_Messagechk(1,'[계정과목]')
	dw_ip.SetColumn("sacc1")
	dw_ip.SetFocus()
	Return -1
END IF

IF sAcc2 ="" OR IsNull(sAcc2) THEN
	F_Messagechk(1,'[계정과목]')
	dw_ip.SetColumn("sacc2")
	dw_ip.SetFocus()
	Return -1
END IF
sAccName = dw_ip.getitemstring(1,"saccname")						/*계정과목명*/

SELECT "KFZ01OM0"."DC_GU","KFZ01OM0"."GBN1"  INTO :sDcrGu, :lstr_account.gbn1	/*차대구분*/
	FROM "KFZ01OM0"  
   WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 )   ;

IF sCustF = "" OR IsNull(sCustF) THEN sCustF = '0'
IF sCustT = "" OR IsNull(sCustT) THEN sCustT = 'z'

dw_list.SetRedraw(false)
IF dw_print.Retrieve(sabu_f,	sabu_t,	sAcc1 + sAcc2,	sAccName,sBaseDate,	 sCustF,	sCustT,&
						  sBeforeYm[6],sBeforeYm[5],sBeforeYm[4],sBeforeYm[3],sBeforeYm[2],sBeforeYm[1]) <=0 THEN
	f_Messagechk(14, "")
   dw_list.SetRedraw(true)		
	return -1
END IF
dw_print.sharedata(dw_list)
dw_list.SetRedraw(true)		
Return 1
end function

on w_kgld11.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgld11.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"k_symd", f_today())
dw_ip.SetItem(1,"saupj",  gs_saupj)
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

type p_preview from w_standard_print`p_preview within w_kgld11
integer x = 4082
integer y = 16
end type

type p_exit from w_standard_print`p_exit within w_kgld11
integer x = 4430
integer y = 16
end type

type p_print from w_standard_print`p_print within w_kgld11
integer x = 4256
integer y = 16
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld11
integer x = 3909
integer y = 16
end type

type st_window from w_standard_print`st_window within w_kgld11
integer x = 2414
integer width = 457
end type

type sle_msg from w_standard_print`sle_msg within w_kgld11
integer width = 2021
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgld11
integer x = 2866
end type

type st_10 from w_standard_print`st_10 within w_kgld11
end type

type gb_10 from w_standard_print`gb_10 within w_kgld11
integer width = 3607
end type

type dw_print from w_standard_print`dw_print within w_kgld11
string dataobject = "dw_kgld112_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld11
integer x = 37
integer y = 12
integer width = 3616
integer height = 216
string dataobject = "dw_kgld111"
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
ELSEIF this.GetColumnName() ="to_incd" THEN
	SetNull(lstr_custom.code)

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
		 sCustPrtGbn,sPrintGu
 
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
		F_MessageChk(21,'[기준일자]')
		this.SetItem(this.GetRow(),"k_symd",sNull)
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
		END IF
		dw_ip.SetItem(1,"saccname",ssql_gaej1+'-'+ssql_gaej2)
		
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
		END IF
		dw_ip.SetItem(1,"saccname",ssql_gaej1+'-'+ssql_gaej2)
		
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
	end if
		
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
	end if
		
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

IF this.GetColumnName() = "prtgbn" THEN
	sPrintGu = this.GetText()
	
	dw_list.SetRedraw(False)
	IF sPrintGu = '1' THEN
		dw_list.DataObject = 'dw_kgld112'
	ELSE
		dw_list.DataObject = 'dw_kgld112'		
	END IF
	dw_list.SetRedraw(True)
	dw_list.SetTransObject(Sqlca)
	dw_list.Reset()
	
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

type dw_list from w_standard_print`dw_list within w_kgld11
integer x = 46
integer y = 240
integer width = 4553
integer height = 1968
string title = "미반제 내역"
string dataobject = "dw_kgld112"
boolean border = false
end type

type rr_1 from roundrectangle within w_kgld11
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 232
integer width = 4576
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type

