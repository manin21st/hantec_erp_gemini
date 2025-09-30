$PBExportHeader$w_kgld26.srw
$PBExportComments$기간별 반제 처리 명세서 조회 출력
forward
global type w_kgld26 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgld26
end type
end forward

global type w_kgld26 from w_standard_print
integer x = 0
integer y = 0
string title = "기간별 반제 처리 명세서 출력"
rr_1 rr_1
end type
global w_kgld26 w_kgld26

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSaupj, sac1_cd, sac2_cd, sdatefrom, sdateto, sdatef, sdatet,sAccName,  snull
Long   LROW, LROWCOUNT

setnull(snull)

dw_ip.AcceptText()

sSaupj =Trim(dw_ip.GetItemString(dw_ip.GetRow(),"saupj"))
sAc1_cd = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"sacc1"))
sAc2_cd = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"sacc2"))
sDatefrom = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"k_symd"))
sDateto = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"k_eymd"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

if (isnull(sAc1_cd) or sAc1_cd = '') AND (isnull(sAc2_cd) or sAc2_cd = '') then
	f_messagechk(20,"[계정과목]")
	dw_ip.setcolumn("sacc1")
	dw_ip.SetFocus()
	Return -1
ELSE
	sAccName = dw_ip.GetItemString(1,"saccname")
end if

if isnull(sDateFrom) or sDateFrom = '' then
	f_messagechk(20,"[반제처리일자]")
	dw_ip.setcolumn("k_symd")
	dw_ip.SetFocus()	
	Return -1
end if
if isnull(sDateTo) or sDateTo = '' then
	f_messagechk(20,"[반제처리일자]")
	dw_ip.setcolumn("k_eymd")
	dw_ip.SetFocus()	
	Return -1
end if
if sDatefrom > sDateto then
	f_messagechk(26,"회계일자")
	dw_ip.setcolumn("k_symd")
	dw_ip.SetFocus()
	Return -1
end if	

if dw_print.retrieve(sabu_f, sabu_t, sac1_cd, sac2_cd, sDatefrom, sDateto,sAccName) < 1 then
	dw_list.SetRedraw(true)
	f_messagechk(14,"") 
	dw_ip.SetFocus()
	Return -1
end if

dw_print.sharedata(dw_list)

return 1
end function

on w_kgld26.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgld26.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,"k_symd",string(Today(),"yyyymm01"))
dw_ip.setitem(1,"k_eymd",string(Today(),"yyyymmdd"))

dw_ip.SetItem(1,"saupj",gs_saupj)

end event

type p_preview from w_standard_print`p_preview within w_kgld26
integer x = 4091
integer y = 4
end type

type p_exit from w_standard_print`p_exit within w_kgld26
integer x = 4439
integer y = 4
end type

type p_print from w_standard_print`p_print within w_kgld26
integer x = 4265
integer y = 4
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld26
integer x = 3918
integer y = 4
end type







type st_10 from w_standard_print`st_10 within w_kgld26
end type



type dw_print from w_standard_print`dw_print within w_kgld26
integer x = 3794
integer y = 44
string dataobject = "dw_kgld262_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld26
integer x = 50
integer y = 24
integer width = 3753
integer height = 144
string dataobject = "dw_kgld261"
end type

event dw_ip::itemchanged;String snull,sSaupj,sYearMonthDay,sAcc1,sAcc2,sSql_gaej1,sSql_gaej2,sSangGbn,sBalGbn,sCustF,sCustT,sCustName,&
		 sCustPrtGbn,sPrintGu
 
SetNull(snull)

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

end event

event dw_ip::rbuttondown;
SetNull(gs_code)
SetNull(gs_codename)
SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)

IF this.GetColumnName() <>"sacc1" AND this.GetColumnName() <>"sacc2" THEN RETURN 

if dw_ip.AcceptText() = -1 then return 

IF this.GetColumnName() = "sacc1" THEN
	lstr_account.acc1_cd = dw_ip.GetItemString(dw_ip.GetRow(), "sacc1")
	lstr_account.acc2_cd = dw_ip.GetItemString(dw_ip.GetRow(), "sacc2")

	IF IsNull(lstr_account.acc1_cd) then
		lstr_account.acc1_cd = ""
	end if
	IF IsNull(lstr_account.acc2_cd) then
		lstr_account.acc2_cd = ""
	end if
	lstr_account.acc1_cd = Trim(lstr_account.acc1_cd)
	lstr_account.acc2_cd = Trim(lstr_account.acc2_cd)
	
	Open(W_KFZ01OM0_POPUP)
	IF this.GetColumnName() = "sacc1" OR this.GetColumnName() = "sacc2" THEN
		dw_ip.SetItem(dw_ip.GetRow(), "sacc1", lstr_account.acc1_cd)
		dw_ip.SetItem(dw_ip.GetRow(), "sacc2", lstr_account.acc2_cd)
		dw_ip.SetItem(dw_ip.Getrow(),"saccname",lstr_account.acc1_nm+" - "+lstr_account.acc2_nm)
	END IF
END IF
dw_ip.SetFocus()

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::losefocus;call super::losefocus;dw_ip.accepttext()
end event

event dw_ip::ue_key;call super::ue_key;//IF keydown(keytab!) THEN
//	TriggerEvent(RbuttonDown!)
//END IF
end event

type dw_list from w_standard_print`dw_list within w_kgld26
integer x = 59
integer y = 184
integer width = 4549
integer height = 2076
string title = "반제처리 명세서"
string dataobject = "dw_kgld262"
boolean border = false
end type

type rr_1 from roundrectangle within w_kgld26
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 180
integer width = 4567
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

