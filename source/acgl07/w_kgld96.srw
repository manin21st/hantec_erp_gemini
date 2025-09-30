$PBExportHeader$w_kgld96.srw
$PBExportComments$원가부문별 계정명세서
forward
global type w_kgld96 from w_standard_print
end type
type rr_1 from roundrectangle within w_kgld96
end type
end forward

global type w_kgld96 from w_standard_print
integer x = 0
integer y = 0
string title = "원가부문별 계정명세서"
rr_1 rr_1
end type
global w_kgld96 w_kgld96

forward prototypes
public function integer wf_retrieve ()
public function integer wf_data_chk (string scolname, string scolvalue)
end prototypes

public function integer wf_retrieve ();string sSaupj, sacc_ymd, eacc_ymd, sdept
string acc_fr, acc_to, acc1_fr, acc1_to, acc2_fr, acc2_to

sSaupj =Trim(dw_ip.GetItemString(1,"saupj"))
IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

sdept =Trim(dw_ip.GetItemString(1,"dept_cd"))
IF sdept ="" OR IsNull(sdept) THEN	
	sdept ='%'
END IF

sacc_ymd = Trim(dw_ip.GetItemString(1,"k_symd")) 
eacc_ymd = Trim(dw_ip.GetItemString(1,"k_eymd")) 

if long(sacc_ymd) > long(eacc_ymd) then
	f_messagechk(24,"")
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	return -1
end if	

acc1_fr = dw_ip.GetItemString(1,"sacc1")
acc2_fr = dw_ip.GetItemString(1,"sacc2")
acc1_to = dw_ip.GetItemString(1,"eacc1")
acc2_to = dw_ip.GetItemString(1,"eacc2")

acc_fr = acc1_fr + acc2_fr
acc_to = acc1_to + acc2_to

acc_fr =Trim(acc_fr)
IF acc_fr ="" OR IsNull(acc_fr) THEN	//계정코드from이 없으면 처음부터 
	acc_fr ="1000000"
END IF

acc_to =Trim(acc_to)
IF acc_to ="" OR IsNull(acc_to) THEN	//계정코드to가 없으면 끝까지
	acc_to ="9999999"
END IF

setpointer(hourglass!)

if dw_print.retrieve(sabu_f, sabu_t, sdept, sacc_ymd, eacc_ymd, acc_fr, acc_to) <= 0 then
	messagebox("확인","조회한 자료가 없습니다.!!") 
	//return -1
	dw_list.insertrow(0)
end if 
dw_print.sharedata(dw_list)
dw_ip.SetFocus()
setpointer(arrow!)
Return 1
end function

public function integer wf_data_chk (string scolname, string scolvalue);Return 1
end function

on w_kgld96.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kgld96.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"k_symd", left(f_today(), 6) + "01")
dw_ip.SetItem(1,"k_eymd", f_today())
dw_ip.SetItem(1,"saupj",  gs_saupj)
dw_ip.SetFocus()


end event

type p_preview from w_standard_print`p_preview within w_kgld96
end type

type p_exit from w_standard_print`p_exit within w_kgld96
end type

type p_print from w_standard_print`p_print within w_kgld96
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld96
end type







type st_10 from w_standard_print`st_10 within w_kgld96
end type



type dw_print from w_standard_print`dw_print within w_kgld96
string dataobject = "dw_kgld962_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld96
integer x = 46
integer y = 20
integer width = 3081
integer height = 224
string dataobject = "dw_kgld961"
end type

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)

IF this.GetColumnName() <>"sacc1" AND this.GetColumnName() <>"sacc2" and this.GetColumnName() <>"eacc1" and this.GetColumnName() <>"eacc2" THEN RETURN

dw_ip.AcceptText()

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
	
	Open(W_KFZ01OM0_POPUP_COST)
	
	IF this.GetColumnName() = "sacc1" OR this.GetColumnName() = "sacc2" THEN
		dw_ip.SetItem(dw_ip.GetRow(), "sacc1", lstr_account.acc1_cd)
		dw_ip.SetItem(dw_ip.GetRow(), "sacc2", lstr_account.acc2_cd)
		dw_ip.SetItem(dw_ip.Getrow(),"saccname",lstr_account.acc1_nm+" - "+lstr_account.acc2_nm)
	END IF
ELSEIF this.GetColumnName() = "eacc1" THEN
	lstr_account.acc1_cd = dw_ip.GetItemString(dw_ip.GetRow(), "eacc1")
	lstr_account.acc2_cd = dw_ip.GetItemString(dw_ip.GetRow(), "eacc2")

	IF IsNull(lstr_account.acc1_cd) then
		lstr_account.acc1_cd = ""
	end if
	IF IsNull(lstr_account.acc2_cd) then
		lstr_account.acc2_cd = ""
	end if
	lstr_account.acc1_cd = Trim(lstr_account.acc1_cd)
	lstr_account.acc2_cd = Trim(lstr_account.acc2_cd)
	
	Open(W_KFZ01OM0_POPUP_COST)
	
	IF this.GetColumnName() = "eacc1" OR this.GetColumnName() = "eacc2" THEN
		dw_ip.SetItem(dw_ip.GetRow(), "eacc1", lstr_account.acc1_cd)
		dw_ip.SetItem(dw_ip.GetRow(), "eacc2", lstr_account.acc2_cd)
		dw_ip.SetItem(dw_ip.Getrow(),"eaccname",lstr_account.acc1_nm+" - "+lstr_account.acc2_nm)
	END IF
END IF

dw_ip.SetFocus()

end event

event dw_ip::itemchanged;//IF WF_DATA_CHK(dwo.name,data) = -1 THEN RETURN 1

String snull,mysql1,sacc,ssql_gaej1,ssql_gaej2,sdate, scolvalue

SetNull(snull)

IF dwo.name ="sacc1" THEN
	scolvalue = data
	IF scolvalue = "" OR IsNull(scolvalue) THEN
		dw_ip.SetItem(1,"sacc2",sNull)
		dw_ip.SetItem(1,"saccname",sNull)
		Return
	END IF
	
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"sacc2")	

	IF sacc ="" OR IsNull(sacc) THEN 
		RETURN 
	END IF
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND  
         	( "KFZ01OM0"."ACC2_CD" = :sacc ) ;
				
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"saccname",ssql_gaej1+' - '+ssql_gaej2)
	ELSE
//		f_messagechk(25,"")
//		dw_ip.SetItem(1,"sacc1",snull)
//		dw_ip.SetItem(1,"sacc2",snull)
//		dw_ip.SetItem(1,"saccname",snull)
//		dw_ip.SetColumn("sacc1")
//		dw_ip.Setfocus()
//		RETURN 1
	END IF
ELSEIF dwo.name ="sacc2" THEN
	scolvalue = data
	
	IF scolvalue = "" OR IsNull(scolvalue) THEN
		dw_ip.SetItem(1,"sacc1",sNull)
		dw_ip.SetItem(1,"saccname",sNull)
		Return
	END IF
	
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"sacc1")	
	
	IF sacc ="" OR IsNull(sacc) THEN 
		RETURN 
	END IF
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :scolvalue );
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"saccname",ssql_gaej1+' - '+ssql_gaej2)
	ELSE
//		f_messagechk(25,"")
//		dw_ip.SetItem(1,"sacc1",snull)
//		dw_ip.SetItem(1,"sacc2",snull)
//		dw_ip.SetItem(1,"saccname",snull)
//		dw_ip.SetColumn("sacc1")
//		dw_ip.Setfocus()
//		RETURN 1
	END IF
	
ELSEIF dwo.name ="eacc1" THEN
	scolvalue = data
	
	IF scolvalue = "" OR IsNull(scolvalue) THEN
		dw_ip.SetItem(1,"eacc1",sNull)
		dw_ip.SetItem(1,"eaccname",sNull)
		Return
	END IF
	
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"eacc2")	

	IF sacc ="" OR IsNull(sacc) THEN
		RETURN 
	END IF
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND  
         	( "KFZ01OM0"."ACC2_CD" = :sacc ) ;
				
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"eaccname",ssql_gaej1+' - '+ssql_gaej2)
	ELSE
//		f_messagechk(25,"")
//		dw_ip.SetItem(1,"eacc1",snull)
//		dw_ip.SetItem(1,"eacc2",snull)
//		dw_ip.SetItem(1,"eaccname",snull)
//		dw_ip.SetColumn("eacc1")
//		dw_ip.Setfocus()
//		RETURN 1
	END IF
ELSEIF dwo.name ="eacc2" THEN
	scolvalue = data
	
	IF scolvalue = "" OR IsNull(scolvalue) THEN
		dw_ip.SetItem(1,"eacc1",sNull)
		dw_ip.SetItem(1,"eaccname",sNull)
		Return
	END IF
	
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"eacc1")	
	
	IF sacc ="" OR IsNull(sacc) THEN 
		RETURN 
	END IF
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :scolvalue );
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"eaccname",ssql_gaej1+' - '+ssql_gaej2)
	ELSE
//		f_messagechk(25,"")
//		dw_ip.SetItem(1,"eacc1",snull)
//		dw_ip.SetItem(1,"eacc2",snull)
//		dw_ip.SetItem(1,"eaccname",snull)
//		dw_ip.SetColumn("eacc1")
//		dw_ip.Setfocus()
//		RETURN 1
	END IF
END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::losefocus;call super::losefocus;dw_ip.AcceptText()
end event

event dw_ip::ue_key;call super::ue_key;//IF keydown(keytab!) THEN
//	TriggerEvent(RbuttonDown!)
//END IF
end event

type dw_list from w_standard_print`dw_list within w_kgld96
integer x = 59
integer y = 256
integer width = 4539
integer height = 1948
string title = "원가부문별 계정명세서"
string dataobject = "dw_kgld962"
boolean border = false
end type

type rr_1 from roundrectangle within w_kgld96
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 248
integer width = 4571
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

