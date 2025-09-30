$PBExportHeader$w_kgld06.srw
$PBExportComments$계정별 원장(거래처기준) 조회 출력
forward
global type w_kgld06 from w_standard_print
end type
type rr_2 from roundrectangle within w_kgld06
end type
end forward

global type w_kgld06 from w_standard_print
integer x = 0
integer y = 0
string title = "계정별 원장(거래처기준) 조회 출력"
rr_2 rr_2
end type
global w_kgld06 w_kgld06

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sSaupj,sDateFrom,sDateTo,sAcc1,sAcc2,eAcc1,eAcc2,sCustF,sSaupName,sAcc,eAcc		  

IF dw_ip.AcceptText() = -1 then return -1

sSaupj    = dw_ip.GetItemString(1,"saupj")
sDateFrom = Trim(dw_ip.GetItemString(1,"k_symd"))
sDateTo   = Trim(dw_ip.GetItemString(1,"k_eymd"))
sCustF    = Trim(dw_ip.GetItemString(1,"fr_incd"))
sAcc1     = dw_ip.getitemstring(1,"sacc1")
sAcc2     = dw_ip.getitemstring(1,"sacc2")
eAcc1     = dw_ip.getitemstring(1,"eacc1")
eAcc2     = dw_ip.getitemstring(1,"eacc2")

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

IF sCustF ="" OR IsNull(sCustF) THEN
	F_Messagechk(1,'[거래처]')
	dw_ip.SetColumn("fr_incd")
	dw_ip.SetFocus()
	Return -1
END IF

IF sAcc1 ="" OR IsNull(sAcc1) THEN
	sAcc = "0000000"
ELSE
	sAcc = sAcc1 + sAcc2
END IF

IF eAcc1 ="" OR IsNull(eAcc1) THEN
	eAcc = "9999999"
ELSE
	eAcc = eAcc1 + eAcc2
END IF

IF sAcc > eAcc THEN
	Messagebox("확인", "시작계정과목이 종료계정과목보다 큽니다")
	dw_ip.SetColumn("sacc1")
	dw_ip.SetFocus()
	Return -1
END IF

SELECT "REFFPF"."RFNA1"  INTO :sSaupName  
	FROM "REFFPF"  
	WHERE "REFFPF"."RFCOD" = 'AD'   AND	"REFFPF"."RFGUB" = :sSaupj ;

dw_print.modify("saup.text ='"+sSaupName+"'") 	

if dw_print.retrieve(sSaupj,sabu_f,sabu_t,sDateFrom,sDateTo,sCustF,sAcc,eAcc) <= 0 then
	F_MessageChk(14,'')
	return -1
end if 
dw_print.sharedata(dw_list)
dw_ip.SetFocus()

Return 1
end function

on w_kgld06.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_kgld06.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.Setitem(1, "saupj", gs_saupj)
dw_ip.setitem(1, "k_symd", Left(f_today(), 6) + "01")
dw_ip.setitem(1, "k_eymd", f_today())
dw_ip.Setitem(1, "sortgb", "1")
end event

type p_preview from w_standard_print`p_preview within w_kgld06
integer x = 4091
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_kgld06
integer x = 4439
integer y = 32
end type

type p_print from w_standard_print`p_print within w_kgld06
integer x = 4265
integer y = 32
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld06
integer x = 3918
integer y = 32
end type







type st_10 from w_standard_print`st_10 within w_kgld06
end type



type dw_print from w_standard_print`dw_print within w_kgld06
integer x = 3995
integer y = 180
integer height = 56
string dataobject = "dw_kgld062_p"
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within w_kgld06
integer y = 28
integer width = 3689
integer height = 208
string dataobject = "dw_kgld061"
end type

event dw_ip::rbuttondown;String ssql_gaej1,sNull

SetNull(sNull)
SetNull(gs_code)
SetNull(gs_codename)

dw_ip.AcceptText()

IF this.GetColumnName() = "sacc1" OR this.GetColumnName() = "sacc2" THEN	
	lstr_account.acc1_cd = Left(Trim(dw_ip.GetItemString(dw_ip.GetRow(), "sacc1")), 1)
	
	IF IsNull(lstr_account.acc1_cd) THEN
		lstr_account.acc1_cd = ""
	END IF
	SetNull(lstr_account.acc2_cd)
	
	Open(W_KFZ01OM0_POPUP)
	
	IF IsNull(lstr_account) THEN
		dw_ip.SetItem(dw_ip.GetRow(), "sacc1", sNull)
		dw_ip.SetItem(dw_ip.GetRow(), "sacc2", sNull)
		dw_ip.SetItem(dw_ip.GetRow(), "saccname",sNull)
		dw_ip.SetColumn("sacc1")
		dw_ip.SetFocus()
	ELSE
		dw_ip.SetItem(dw_ip.GetRow(), "sacc1", lstr_account.acc1_cd)
		dw_ip.SetItem(dw_ip.GetRow(), "sacc2", lstr_account.acc2_cd)
		dw_ip.SetItem(dw_ip.GetRow(), "saccname", lstr_account.acc2_nm)
		Return
	END IF
ELSEIF this.GetColumnName() ="eacc1" OR this.GetColumnName() ="eacc2" THEN	
	lstr_account.acc1_cd = Left(Trim(dw_ip.GetItemString(dw_ip.GetRow(), "eacc1")),1)
	
	IF IsNull(lstr_account.acc1_cd) THEN
		lstr_account.acc1_cd =""
	END IF
	SetNull(lstr_account.acc2_cd)
	
	Open(W_KFZ01OM0_POPUP)
	
	IF IsNull(lstr_account) THEN
		dw_ip.SetItem(dw_ip.GetRow(), "eacc1", sNull)
		dw_ip.SetItem(dw_ip.GetRow(), "eacc2", sNull)
		dw_ip.SetItem(dw_ip.GetRow(), "eaccname",sNull)
		dw_ip.SetColumn("eacc1")
		dw_ip.SetFocus()
	ELSE
		dw_ip.SetItem(dw_ip.GetRow(), "eacc1", lstr_account.acc1_cd)
		dw_ip.SetItem(dw_ip.GetRow(), "eacc2", lstr_account.acc2_cd)
		dw_ip.SetItem(dw_ip.GetRow(), "eaccname", lstr_account.acc2_nm)
		Return
	END IF
ELSEIF this.GetColumnName() ="fr_incd" THEN
	SetNull(lstr_custom.name)
	lstr_custom.code = Trim(dw_ip.GetItemString(dw_ip.GetRow(), "fr_incd"))
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""
	
	OpenWithParm(W_KFZ04OM0_POPUP_ALL,"%")
	
	IF IsNull(lstr_custom) THEN
		dw_ip.SetItem(dw_ip.GetRow(), "fr_incd", sNull)
		dw_ip.SetItem(dw_ip.GetRow(), "fr_innm", sNull)
	ELSE	
		dw_ip.SetItem(dw_ip.GetRow(), "fr_incd", lstr_custom.code)
		dw_ip.SetItem(dw_ip.GetRow(), "fr_innm", lstr_custom.name)
	END IF
ELSE
	RETURN
END IF

dw_ip.SetFocus()
end event

event dw_ip::itemchanged;String sNull,sSaupj,sYearMonthDay,sacc1,sacc2,eacc1,eacc2,ssql_gaej,sCustF,sCustName,&
		 sSortGb,sGbnSaup
 
SetNull(sNull)

This.accepttext()

IF This.GetColumnName() = "saupj" THEN
	sSaupj = This.GetText()
	IF sSaupj = "" OR IsNull(sSaupj) THEN Return
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
		F_MessageChk(20,'[사업장]')
		This.SetItem(This.GetRow(), "saupj", sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() = "gubun_saupj" THEN
	sGbnSaup = this.GetText()
	IF sGbnSaup = "" OR IsNull(sGbnSaup) THEN Return
	
	sSaupj = this.GetItemString(1,"saupj")
	
	dw_list.SetRedraw(False)
	IF sSaupj = '99' AND sGbnSaup = 'Y' then
		dw_list.dataObject='dw_kgld064'
		dw_print.dataObject='dw_kgld064_p'
	ELSE	
		dw_list.dataObject='dw_kgld062'
		dw_print.dataObject='dw_kgld062_p'
	END IF	
	dw_list.SetRedraw(True)
	
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
END IF

IF This.GetColumnName() = "k_symd" THEN
	sYearMonthDay = Trim(This.GetText())
	IF sYearMonthDay = "" OR IsNull(sYearMonthDay) THEN Return
	
	IF F_DateChk(sYearMonthDay) = -1 THEN
		F_MessageChk(21,'[회계일자]')
		This.SetItem(This.GetRow(), "k_symd", sNull)
		Return 1
	END IF
END IF

IF This.GetColumnName() = "k_eymd" THEN
	sYearMonthDay = Trim(This.GetText())
	IF sYearMonthDay = "" OR IsNull(sYearMonthDay) THEN Return
	
	IF F_DateChk(sYearMonthDay) = -1 THEN
		F_MessageChk(21,'[회계일자]')
		This.SetItem(This.GetRow(), "k_eymd", sNull)
		Return 1
	END IF
END IF

IF This.GetColumnName() = "fr_incd" THEN
	sCustF = This.GetText()
	
	This.SetItem(1, "fr_innm", sNull)
	
	IF sCustF = '' OR IsNull(sCustF) THEN Return
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
  		FROM "KFZ04OM0"  
  		WHERE ( "KFZ04OM0"."PERSON_CD" = :sCustF) AND ( "KFZ04OM0"."PERSON_STS" like '%');
	
	IF SQLCA.SQLCODE <> 0 THEN
		f_Messagechk(20, "[거래처]") 
		dw_ip.SetItem(1, "fr_incd", sNull)
		Return 1
	END IF
	
	dw_ip.SetItem(1, "fr_innm", sCustName)
END IF

IF This.GetColumnName() = "sacc1" THEN
	sacc2 = dw_ip.GetItemString(dw_ip.GetRow(), "sacc2")
	
	IF sacc2 = "" OR IsNull(sacc2) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :data) AND  
         	( "KFZ01OM0"."ACC2_CD" = :sacc2 ) ;
	IF SQLCA.SQLCODE <> 0 THEN
	   dw_ip.SetItem(1, "sacc1", sNull)
		dw_ip.SetItem(1, "sacc2", sNull)
		dw_ip.SetItem(1, "saccname", sNull)
		dw_ip.SetColumn("sacc1")
		dw_ip.SetFocus()
	   Return 1
	END IF
	
	dw_ip.SetItem(1, "saccname", ssql_gaej)
END IF

IF This.GetColumnName() = "sacc2" THEN
	sacc1 = dw_ip.GetItemString(dw_ip.GetRow(), "sacc1")
	
	IF sacc1 = "" OR IsNull(sacc1) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc1 ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :data );
	IF SQLCA.SQLCODE <> 0 THEN
	   dw_ip.SetItem(1, "sacc1", sNull)
		dw_ip.SetItem(1, "sacc2", sNull)
		dw_ip.SetItem(1, "saccname", sNull)
		dw_ip.SetColumn("sacc1")
		dw_ip.SetFocus()
      Return 1
	END IF
	dw_ip.SetItem(1, "saccname", ssql_gaej)
END IF

IF This.GetColumnName() = "eacc1" THEN
	eacc2 = dw_ip.GetItemString(dw_ip.GetRow(), "eacc2")
	
	IF eacc2 = "" OR IsNull(eacc2) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :data) AND  
         	( "KFZ01OM0"."ACC2_CD" = :eacc2 ) ;
	IF SQLCA.SQLCODE <> 0 THEN
	   dw_ip.SetItem(1, "eacc1", sNull)
		dw_ip.SetItem(1, "eacc2", sNull)
		dw_ip.SetItem(1, "eaccname", sNull)
		dw_ip.SetColumn("eacc1")
		dw_ip.SetFocus()
	   Return 1
	END IF
	dw_ip.SetItem(1, "eaccname", ssql_gaej)
END IF

IF This.GetColumnName() = "eacc2" THEN
	eacc1 = dw_ip.GetItemString(dw_ip.GetRow(), "eacc1")
	
	IF eacc1 = "" OR IsNull(eacc1) THEN RETURN
	
	SELECT "KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :eacc1 ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :data );
	IF SQLCA.SQLCODE <> 0 THEN
	   dw_ip.SetItem(1, "eacc1", sNull)
		dw_ip.SetItem(1, "eacc2", sNull)
		dw_ip.SetItem(1, "eaccname", sNull)
		dw_ip.SetColumn("eacc1")
		dw_ip.SetFocus()
      Return 1
	END IF
	dw_ip.SetItem(1, "eaccname",ssql_gaej)
END IF

//IF This.GetColumnName() = "sortgb" THEN
//	IF data = "1" THEN
//		dw_list.dataobject = "dw_kgld062"
//		dw_print.dataobject = "dw_kgld062_p"
//	ELSE
//		dw_list.dataobject = "dw_kgld063"
//		dw_print.dataobject = "dw_kgld063_p"
//	END IF
//	dw_list.settransobject(SQLCA)
//	dw_print.settransobject(SQLCA)
//	dw_print.object.datawindow.print.preview = "yes"
//END IF
end event

event dw_ip::itemerror;call super::itemerror;RETURN 1
end event

event dw_ip::losefocus;call super::losefocus;dw_ip.AcceptText()
end event

event dw_ip::getfocus;this.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_kgld06
integer x = 55
integer y = 268
integer width = 4539
integer height = 1928
string title = "거래처원장"
string dataobject = "dw_kgld062"
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

type rr_2 from roundrectangle within w_kgld06
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 256
integer width = 4571
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

