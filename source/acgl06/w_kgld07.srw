$PBExportHeader$w_kgld07.srw
$PBExportComments$거래처/관리번호 원장 조회 출력
forward
global type w_kgld07 from w_standard_print
end type
type rr_2 from roundrectangle within w_kgld07
end type
end forward

global type w_kgld07 from w_standard_print
integer x = 0
integer y = 0
string title = "거래처(관리번호) 원장 조회 출력"
rr_2 rr_2
end type
global w_kgld07 w_kgld07

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sSaupj,sDateFrom,sDateTo,sAcc1,sAcc2,sAccName,sCustF,sCustT,sSaupName,&
		  sAcc1From,sAcc2From,sAcc1To,sAcc2To,sPrtGbn

IF dw_ip.AcceptText() = -1 then return -1

sSaupj    = dw_ip.GetItemString(1,"saupj")
sDateFrom = Trim(dw_ip.GetItemString(1,"k_symd"))
sDateTo   = Trim(dw_ip.GetItemString(1,"k_eymd"))
sAcc1     = dw_ip.getitemstring(1,"sacc1")
sAcc2     = dw_ip.getitemstring(1,"sacc2")
sCustF    = Trim(dw_ip.GetItemString(1,"fr_incd"))
sCustT    = Trim(dw_ip.GetItemString(1,"to_incd"))
sPrtGbn   = Trim(dw_ip.GetItemString(1,"prtgbn"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF sSaupj = '99' THEN
		sabu_f = '10';			sabu_t = '98';
	ELSE
		sabu_f = sSaupj;		sabu_t = sSaupj;
	END IF
	
END IF

IF sDateFrom = "" OR IsNull(sDateFrom) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	Return -1
END IF

IF sDateTo = "" OR IsNull(sDateTo) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_eymd")
	dw_ip.SetFocus()
	Return -1
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

SELECT "KFZ01OM0"."FRACC1_CD", 				"KFZ01OM0"."FRACC2_CD",   
       "KFZ01OM0"."TOACC1_CD",   			"KFZ01OM0"."TOACC2_CD",
		 "KFZ01OM0"."GBN1"  
	INTO :sAcc1From,								:sAcc2From,
		  :sAcc1To,									:sAcc2To,
		  :lstr_account.gbn1	
	FROM "KFZ01OM0"  
   WHERE ( "KFZ01OM0"."ACC1_CD" = :sAcc1 ) AND ( "KFZ01OM0"."ACC2_CD" = :sAcc2 )   ;

IF lstr_account.gbn1 = "" OR IsNull(lstr_account.gbn1) THEN lstr_account.gbn1 = '%'

IF sCustF = "" OR IsNull(sCustF) THEN
	SELECT MIN("KFZ04OM0"."PERSON_CD")		INTO :sCustF
		FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" like :lstr_account.gbn1) AND
				( "KFZ04OM0"."PERSON_STS" = '1');
END IF
IF sCustT = "" OR IsNull(sCustT) THEN
	SELECT MAX("KFZ04OM0"."PERSON_CD")		INTO :sCustT
		FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" like :lstr_account.gbn1) AND
				( "KFZ04OM0"."PERSON_STS" = '1');
END IF

SELECT "REFFPF"."RFNA1"  INTO :sSaupName  
	FROM "REFFPF"  
	WHERE "REFFPF"."RFCOD" = 'AD'   AND	"REFFPF"."RFGUB" = :sSaupj ;

dw_print.modify("saup.text ='"+sSaupName+"'") 	

IF dw_print.retrieve(sSaupj,Left(sDateFrom,4),sCustF,sCustT,sabu_f,sabu_t,sDateFrom,&
								sDateTo,sAcc1 + sAcc2, sAcc1From + sAcc2From,sAcc1To + sAcc2To) <= 0 then
	F_MessageChk(14,'')
	Return -1
END IF

dw_print.sharedata(dw_list)
dw_ip.SetFocus()

Return 1
end function

on w_kgld07.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_kgld07.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1,"saupj", gs_saupj)

dw_ip.setitem(1,"k_symd", left(f_today(), 6) + "01")
dw_ip.setitem(1,"k_eymd", f_today())
dw_ip.SetItem(1,"prtgbn", "1")



end event

type p_preview from w_standard_print`p_preview within w_kgld07
integer x = 4087
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_kgld07
integer x = 4434
integer y = 32
end type

type p_print from w_standard_print`p_print within w_kgld07
integer x = 4261
integer y = 32
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld07
integer x = 3913
integer y = 32
end type







type st_10 from w_standard_print`st_10 within w_kgld07
end type



type dw_print from w_standard_print`dw_print within w_kgld07
integer x = 3986
integer y = 208
string dataobject = "dw_kgld072_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld07
integer x = 23
integer y = 28
integer width = 3890
integer height = 228
string dataobject = "dw_kgld071"
end type

event dw_ip::rbuttondown;String ssql_gaej1,snull

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)

dw_ip.AcceptText()

IF this.GetColumnName() ="sacc1" OR this.GetColumnName() ="sacc2" THEN	
	lstr_account.acc1_cd = Left(Trim(dw_ip.GetItemString(dw_ip.GetRow(), "sacc1")),1)
	
	IF IsNull(lstr_account.acc1_cd) THEN
		lstr_account.acc1_cd =""
	END IF
	SetNull(lstr_account.acc2_cd)
	
	Open(W_KFZ01OM0_POPUP)
	
	IF IsNull(lstr_account) THEN
		dw_ip.SetItem(dw_ip.GetRow(), "sacc1", snull)
		dw_ip.SetItem(dw_ip.GetRow(), "sacc2", snull)
		dw_ip.SetItem(dw_ip.GetRow(), "saccname",snull)
		dw_ip.SetColumn("sacc1")
		dw_ip.SetFocus()
	ELSE
		dw_ip.SetItem(dw_ip.GetRow(), "sacc1", lstr_account.acc1_cd)
		dw_ip.SetItem(dw_ip.GetRow(), "sacc2", lstr_account.acc2_cd)
		
		this.TriggerEvent(ItemChanged!)
		Return
	END IF
ELSEIF this.GetColumnName() ="fr_incd" THEN
	SetNull(lstr_custom.name)
	lstr_custom.code = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"fr_incd"))
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF
	
	IF lstr_account.gbn1 = "" OR IsNull(lstr_account.gbn1) THEN lstr_account.gbn1 = '%'
	
	OpenWithParm(W_KFZ04OM0_POPUP1,lstr_account.gbn1)
	
	IF IsNull(lstr_custom) THEN
		dw_ip.SetItem(dw_ip.GetRow(), "fr_incd",snull)
		dw_ip.SetItem(dw_ip.GetRow(), "fr_innm",snull)
	ELSE	
		dw_ip.SetItem(dw_ip.GetRow(), "fr_incd",lstr_custom.code)
		dw_ip.SetItem(dw_ip.GetRow(), "fr_innm",lstr_custom.name)
	END IF
ELSEIF this.GetColumnName() ="to_incd" THEN
	SetNull(lstr_custom.name)
	lstr_custom.code = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"to_incd"))
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF
	
	IF lstr_account.gbn1 = "" OR IsNull(lstr_account.gbn1) THEN lstr_account.gbn1 = '%'
	
	OpenWithParm(W_KFZ04OM0_POPUP1,lstr_account.gbn1)
	
	IF IsNull(lstr_custom) THEN
		dw_ip.SetItem(dw_ip.GetRow(), "to_incd",snull)
		dw_ip.SetItem(dw_ip.GetRow(), "to_innm",snull)
	ELSE	
		dw_ip.SetItem(dw_ip.GetRow(), "to_incd",lstr_custom.code)
		dw_ip.SetItem(dw_ip.GetRow(), "to_innm",lstr_custom.name)
	END IF
ELSE
	RETURN
END IF
dw_ip.SetFocus()

end event

event dw_ip::itemchanged;
String snull,sSaupj,sYearMonthDay,sAcc1,sAcc2,sSql_gaej1,sSql_gaej2,sBalGbn,sCustF,sCustT,sCustName,&
		 sCustPrtGbn,sGbnSaup
 
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

IF this.GetColumnName() = "gubun_saupj" THEN
	sGbnSaup = this.GetText()
	IF sGbnSaup = "" OR IsNull(sGbnSaup) THEN Return
	
	sSaupj = this.GetItemString(1,"saupj")
	
	dw_list.SetRedraw(False)
	IF sSaupj = '99' AND sGbnSaup = 'Y' then
		dw_list.dataObject='dw_kgld074'
		dw_print.dataObject='dw_kgld074_p'
	ELSE	
		dw_list.dataObject='dw_kgld072'
		dw_print.dataObject='dw_kgld072_p'
	END IF	
	dw_list.SetRedraw(True)
	
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
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
	 		  "KFZ01OM0"."GBN1",		"KFZ01OM0"."BAL_GU"
    	INTO :ssql_gaej1,				:ssql_gaej2,					 :sCustPrtGbn,	
		 	  :lstr_account.gbn1,	:sBalGbn
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
		IF sCustPrtGbn = 'N' OR sCustPrtGbn = "" OR IsNull(sCustPrtGbn) THEN
			f_Messagechk(25,"[거래처원장관리]")
		   dw_ip.SetItem(1,"sacc1",snull)
			dw_ip.SetItem(1,"sacc2",snull)
			dw_ip.SetItem(1,"saccname",snull)
			SetNull(lstr_account.gbn1)
			Return 1
		END IF
		dw_ip.SetItem(1,"saccname",ssql_gaej2)
	ELSE
     	f_Messagechk(28,"")
	   dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		
		SetNull(lstr_account.gbn1)
		
		dw_ip.SetColumn("sacc1")
		dw_ip.SetFocus()
	   Return 1
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
	 		  "KFZ01OM0"."GBN1",		"KFZ01OM0"."BAL_GU"
    	INTO :ssql_gaej1,				:ssql_gaej2,				    :sCustPrtGbn,
		 	  :lstr_account.gbn1,	:sBalGbn
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
		IF sCustPrtGbn = 'N' OR sCustPrtGbn = "" OR IsNull(sCustPrtGbn) THEN
			f_Messagechk(25,"[거래처원장관리]")
		   dw_ip.SetItem(1,"sacc1",snull)
			dw_ip.SetItem(1,"sacc2",snull)
			dw_ip.SetItem(1,"saccname",snull)
			SetNull(lstr_account.gbn1)
			Return 1
		END IF
		dw_ip.SetItem(1,"saccname",ssql_gaej2)
		
	ELSE
     	f_Messagechk(28,"")
	   dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		
		SetNull(lstr_account.gbn1)
		
		dw_ip.SetColumn("sacc1")
		dw_ip.SetFocus()
	   Return 1
	END IF
END IF

IF this.GetColumnName() ="fr_incd" THEN
	sCustF = this.GetText()
	IF sCustF = '' OR IsNull(sCustF) THEN
		this.SetItem(1,"fr_innm",snull)
		Return
	END IF
	
	IF lstr_account.gbn1 ="" OR IsNull(lstr_account.gbn1) OR lstr_account.gbn1 =' ' THEN
		SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
	  		FROM "KFZ04OM0"  
   		WHERE ( "KFZ04OM0"."PERSON_CD" = :sCustF) AND ( "KFZ04OM0"."PERSON_STS" like '%');
	ELSE
		SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
	  		FROM "KFZ04OM0"  
   		WHERE ( "KFZ04OM0"."PERSON_CD" = :sCustF) AND 
					(( "KFZ04OM0"."PERSON_GU" = :lstr_account.gbn1) OR 
					( "KFZ04OM0"."PERSON_GU" = '99')) AND
					( "KFZ04OM0"."PERSON_STS" like '%');
	END IF
	
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"fr_innm",sCustName)
	ELSE
		f_Messagechk(20,"[거래처]") 
		dw_ip.SetItem(1,"fr_incd",snull)
		dw_ip.SetItem(1,"fr_innm",snull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="to_incd" THEN
	sCustT = this.GetText()
	IF sCustT = '' OR IsNull(sCustT) THEN
		this.SetItem(1,"to_innm",snull)
		Return
	END IF
	
	IF lstr_account.gbn1 ="" OR IsNull(lstr_account.gbn1) OR lstr_account.gbn1 =' ' THEN
		SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
	  		FROM "KFZ04OM0"  
   		WHERE ( "KFZ04OM0"."PERSON_CD" = :sCustT) AND ( "KFZ04OM0"."PERSON_STS" like '%');
	ELSE
		SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
	  		FROM "KFZ04OM0"  
   		WHERE ( "KFZ04OM0"."PERSON_CD" = :sCustT) AND 
					(( "KFZ04OM0"."PERSON_GU" = :lstr_account.gbn1) OR 
					( "KFZ04OM0"."PERSON_GU" = '99')) AND
					( "KFZ04OM0"."PERSON_STS" like '%');
	END IF
	
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"to_innm",sCustName)
	ELSE
		f_Messagechk(20,"[거래처]") 
		dw_ip.SetItem(1,"to_incd",snull)
		dw_ip.SetItem(1,"to_innm",snull)
		Return 1
	END IF
END IF
end event

event dw_ip::itemerror;call super::itemerror;RETURN 1
end event

event dw_ip::losefocus;call super::losefocus;dw_ip.AcceptText()
end event

event dw_ip::getfocus;this.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_kgld07
integer y = 268
integer width = 4549
integer height = 1928
string title = "거래처원장"
string dataobject = "dw_kgld072"
boolean border = false
end type

event dw_list::clicked;call super::clicked;if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(Row,True)
end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)
end event

event dw_list::buttonclicked;call super::buttonclicked;s_Junpoy  str_AccJunpoy

String    sSaupj,sGbnSaup

dw_ip.AcceptText()
sSaupj   = dw_ip.GetItemString(1,"saupj")
sGbnSaup = dw_ip.GetItemString(1,"gubun_saupj")

IF dwo.name = 'dcb_junpoy' THEN										/*전표 조회*/
	if sSaupj = '99' and sGbnSaup = 'Y' then
		str_AccJunPoy.saupjang = this.GetItemString(this.GetRow(),"saupj")
	else
		str_AccJunPoy.saupjang = dw_ip.GetItemString(1,"saupj")
	end if
	str_AccJunPoy.upmugu   = This.GetItemString(This.GetRow(),"upmu_gu")
	str_AccJunPoy.accdate  = Left(This.GetItemString(This.GetRow(),"acdat"),4) + &
									 Mid(This.GetItemString(This.GetRow(),"acdat"),6,2) + &
									 Right(This.GetItemString(This.GetRow(),"acdat"),2) 
	str_AccJunPoy.junno    = This.GetItemNumber(This.GetRow(),"jun_no")

	OpenWithParm(w_kgld69c,Str_AccJunpoy)
END IF
end event

type rr_2 from roundrectangle within w_kgld07
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 256
integer width = 4581
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

