$PBExportHeader$w_kgld75.srw
$PBExportComments$지출증빙 계정원장
forward
global type w_kgld75 from w_standard_print
end type
type rr_3 from roundrectangle within w_kgld75
end type
end forward

global type w_kgld75 from w_standard_print
integer x = 0
integer y = 0
integer height = 2516
string title = "지출증빙 계정원장"
rr_3 rr_3
end type
global w_kgld75 w_kgld75

forward prototypes
public function integer wf_data_chk (string scolname, string scolvalue)
public function integer wf_retrieve ()
end prototypes

public function integer wf_data_chk (string scolname, string scolvalue);String snull,mysql1,sacc,ssql_gaej1,ssql_gaej2,sdate,sLevgu

SetNull(snull)

IF scolname ="sacc1" THEN
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"sacc2")	

	IF sacc ="" OR IsNull(sacc) THEN RETURN 1
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM", "KFZ01OM0"."LEV_GU"
    	INTO :ssql_gaej1,			 :ssql_gaej2,			  :sLevGu
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND ( "KFZ01OM0"."ACC2_CD" = :sacc ) ;
				
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"saccname",ssql_gaej2)
		dw_ip.SetItem(1,"lev",     sLevGu)
	ELSE
   	f_Messagechk(25,"")
	   dw_ip.SetItem(1,"sacc1",   snull)
		dw_ip.SetItem(1,"sacc2",   snull)
		dw_ip.SetItem(1,"saccname",snull)
		dw_ip.SetItem(1,"lev",     snull)
		dw_ip.SetColumn("sacc1")
		dw_ip.SetFocus()
	   Return -1
	END IF
	
ELSEIF scolname ="sacc2" THEN
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"sacc1")	
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 1
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM", "KFZ01OM0"."LEV_GU"
    	INTO :ssql_gaej1,			 :ssql_gaej2,			  :sLevGu
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND ( "KFZ01OM0"."ACC2_CD" = :scolvalue );
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"saccname",ssql_gaej2)
		dw_ip.SetItem(1,"lev",     sLevGu)
	ELSE
   	f_Messagechk(25,"") 
	   dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		dw_ip.SetItem(1,"lev",     snull)
		dw_ip.SetColumn("sacc1")
		dw_ip.SetFocus()
	   Return -1
	END IF
	
END IF
Return 1
end function

public function integer wf_retrieve ();String sSaupj,sSaupjName,sSaupjF,sSaupjT,sacc_ymd, eacc_ymd
string acc_fr, acc_to, acc1_fr, acc1_to, acc2_fr, acc2_to, sTaxGbn, sReportGbn

dw_ip.AcceptText()
sSaupj   = Trim(dw_ip.GetItemString(1,"saupj"))
sacc_ymd = Trim(dw_ip.GetItemString(1,"k_symd"))
eacc_ymd = Trim(dw_ip.GetItemString(1,"k_eymd"))
acc1_fr  = dw_ip.GetItemString(1,"sacc1")
acc2_fr  = dw_ip.GetItemString(1,"sacc2")
acc1_to  = dw_ip.GetItemString(1,"eacc1")
acc2_to  = dw_ip.GetItemString(1,"eacc2")
sTaxGbn  = dw_ip.GetItemString(1,"accls")
sReportGbn = dw_ip.GetItemString(1,"p_gbn")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF sSaupj = '99' THEN
		sSaupjF = '10';			sSaupjT = '98';
	ELSE
		sSaupjF = sSaupj;		sSaupjT = sSaupj;
	END IF
	SELECT "REFFPF"."RFNA1"  
		INTO :sSaupjName  
		FROM "REFFPF"  
		WHERE "REFFPF"."RFCOD" = 'AD'   AND "REFFPF"."RFGUB" = :sSaupj ;
END IF

IF sAcc_Ymd = "" OR IsNull(sAcc_Ymd) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	Return -1
END IF
IF eAcc_Ymd = "" OR IsNull(eAcc_Ymd) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_eymd")
	dw_ip.SetFocus()
	Return -1
END IF
if long(sacc_ymd) > long(eacc_ymd) then
	f_messagechk(24,"")
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	return -1
end if	

if IsNull(acc1_fr) or acc1_fr = '' or acc2_fr = '' or IsNull(acc2_fr) then
	acc_fr ="1000000"
else
	select fracc1_cd||fracc2_cd
		into :acc_fr
		from kfz01om0
		where acc1_cd||acc2_cd = :acc1_fr||:acc2_fr ;
end if

if IsNull(acc1_to) or acc1_to = '' or acc2_to = '' or IsNull(acc2_to) then
	acc_to ="9999999"
else
	select toacc1_cd||toacc2_cd
		into :acc_to
		from kfz01om0
		where acc1_cd||acc2_cd = :acc1_to||:acc2_to ;
end if
if sTaxGbn = '' or IsNull(sTaxGbn) then sTaxGbn = '%'

setpointer(hourglass!)

if sReportGbn = '3' then
	dw_print.modify("saup.text ='"+sSaupjName+"'") 
	dw_print.modify("symd.text ='"+String(sAcc_Ymd,'@@@@.@@.@@')+"'")
	dw_print.modify("eymd.text ='"+String(eAcc_Ymd,'@@@@.@@.@@')+"'")
	
	if dw_print.retrieve(sSaupjF, sSaupjT,acc_fr, acc_to, sacc_ymd, eacc_ymd, sTaxGbn) <= 0 then
		F_MessageChk(14,'')
		return -1
	end if 
	dw_print.sharedata(dw_list)
	dw_ip.SetFocus()
else
	dw_print.sharedataOff()

	if dw_print.retrieve(sSaupjF, sSaupjT,sacc_ymd, eacc_ymd) <= 0 then
		F_MessageChk(14,'')
		return -1
	else
		dw_list.retrieve(sSaupjF, sSaupjT,sacc_ymd, eacc_ymd)	
	end if 	
	dw_ip.SetFocus()	
end if

setpointer(arrow!)
Return 1
end function

on w_kgld75.create
int iCurrent
call super::create
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
end on

on w_kgld75.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_3)
end on

event open;call super::open;dw_ip.SetItem(1,"k_symd",Left(f_today(),6)+'01')
dw_ip.SetItem(1,"k_eymd",f_today())
dw_ip.SetItem(1,"saupj", gs_saupj)

end event

type p_xls from w_standard_print`p_xls within w_kgld75
end type

type p_sort from w_standard_print`p_sort within w_kgld75
end type

type p_preview from w_standard_print`p_preview within w_kgld75
end type

type p_exit from w_standard_print`p_exit within w_kgld75
end type

type p_print from w_standard_print`p_print within w_kgld75
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld75
end type







type st_10 from w_standard_print`st_10 within w_kgld75
end type



type dw_print from w_standard_print`dw_print within w_kgld75
integer x = 4453
integer y = 176
string dataobject = "dw_kgld752_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld75
integer x = 46
integer y = 28
integer width = 3694
integer height = 224
string dataobject = "dw_kgld751"
end type

event dw_ip::rbuttondown;
this.AcceptText()

IF this.GetColumnName()  = "sacc1" or this.GetColumnName() = "sacc2" THEN
	lstr_account.acc1_cd = Left(dw_ip.GetItemString(dw_ip.GetRow(), "sacc1"),1)

	IF IsNull(lstr_account.acc1_cd) then
		lstr_account.acc1_cd = ""
	end if
	SetNull(lstr_account.acc2_cd)

	Open(W_KFZ01OM0_POPUP1)
	
	IF lstr_account.acc1_cd = '' OR IsNull(lstr_account.acc1_cd) then Return
	
	dw_ip.SetItem(dw_ip.GetRow(), "sacc1", lstr_account.acc1_cd)
	dw_ip.SetItem(dw_ip.GetRow(), "sacc2", lstr_account.acc2_cd)
	this.TriggerEvent(ItemChanged!)
	Return
END IF

IF this.GetColumnName()  = "eacc1" or this.GetColumnName() = "eacc2" THEN
	lstr_account.acc1_cd = Left(dw_ip.GetItemString(dw_ip.GetRow(), "eacc1"),1)

	IF IsNull(lstr_account.acc1_cd) then
		lstr_account.acc1_cd = ""
	end if
	
	SetNull(lstr_account.acc2_cd)

	Open(W_KFZ01OM0_POPUP1)
	
	IF lstr_account.acc1_cd = '' OR IsNull(lstr_account.acc1_cd) then Return
	
	dw_ip.SetItem(dw_ip.GetRow(), "eacc1", lstr_account.acc1_cd)
	dw_ip.SetItem(dw_ip.GetRow(), "eacc2", lstr_account.acc2_cd)
	this.TriggerEvent(ItemChanged!)
END IF
end event

event dw_ip::itemchanged;String snull,sColValue,sAcc2Nm,sAcc,sdate,sTaxGbn,sSaupj, sReportGbn

SetNull(snull)

IF this.GetColumnName() ="sacc1" THEN
	scolvalue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"sacc2")	

	IF sacc ="" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC2_NM"
    	INTO 	 :sAcc2Nm
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND ( "KFZ01OM0"."ACC2_CD" = :sacc ) ;
				
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"saccname",sAcc2Nm)
	ELSE
   	f_Messagechk(25,"")
	   dw_ip.SetItem(1,"sacc1",   snull)
		dw_ip.SetItem(1,"sacc2",   snull)
		dw_ip.SetItem(1,"saccname",snull)
	   Return 1
	END IF
	
END IF
IF this.GetColumnName() ="sacc2" THEN
	scolvalue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"sacc1")	
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC2_NM"
    	INTO  :sAcc2Nm
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND ( "KFZ01OM0"."ACC2_CD" = :scolvalue );
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"saccname",sAcc2Nm)
	ELSE
   	f_Messagechk(25,"") 
	   dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
	   Return 1
	END IF
	
END IF

IF this.GetColumnName() ="eacc1" THEN
	scolvalue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"eacc2")	

	IF sacc ="" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC2_NM"
    	INTO :sAcc2Nm
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND ( "KFZ01OM0"."ACC2_CD" = :sacc ) ;
				
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"eaccname",sAcc2Nm)
	ELSE
   	f_Messagechk(25,"")
	   dw_ip.SetItem(1,"eacc1",   snull)
		dw_ip.SetItem(1,"eacc2",   snull)
		dw_ip.SetItem(1,"eaccname",snull)
	   Return 1
	END IF
END IF
IF this.GetColumnName() ="eacc2" THEN
	scolvalue = this.GetText()
	if sColValue = '' or IsNull(sColValue) then Return
	
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"eacc1")	
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 
	
	SELECT "KFZ01OM0"."ACC2_NM"
    	INTO :sAcc2Nm
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND ( "KFZ01OM0"."ACC2_CD" = :scolvalue );
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"eaccname",sAcc2Nm)
	ELSE
   	f_Messagechk(25,"") 
	   dw_ip.SetItem(1,"eacc1",snull)
		dw_ip.SetItem(1,"eacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
	   Return 1
	END IF
END IF

IF this.GetColumnName() ="accls" THEN
	sTaxGbn = this.GetText()
	if sTaxGbn = '' or IsNull(sTaxGbn) then Return
	
	IF IsNull(F_Get_Refferance('TX',sTaxGbn)) THEN
		F_MessageChk(20,'[지출증빙]')
		this.SetItem(this.GetRow(),"accls",sNull)
		Return 1
	END IF
END IF

IF this.GetColumnName() ="p_gbn" THEN
	sReportGbn = this.GetText()
	if sReportGbn = '' or IsNull(sReportGbn) then Return
	
	IF  sReportGbn = '3' THEN
		dw_list.DataObject = 'dw_kgld752'
		dw_print.DataObject = 'dw_kgld752_p'
	else
		dw_list.DataObject = 'dw_kgld753'
		dw_print.DataObject = 'dw_kgld753_p'	
	END IF
	dw_list.SetTransObject(Sqlca)
	dw_print.SetTransObject(Sqlca)
	dw_print.ShareDataOff()
END IF


end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::losefocus;call super::losefocus;dw_ip.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_kgld75
integer x = 69
integer y = 264
integer width = 4539
integer height = 1944
string title = "계정별 원장 조회출력"
string dataobject = "dw_kgld752"
boolean border = false
end type

event dw_list::clicked;call super::clicked;
if row <=0 then return

this.SelectRow(0,False)
this.SelectRow(Row,True)

end event

event dw_list::rowfocuschanged;call super::rowfocuschanged;
if currentrow <=0 then return

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

end event

event dw_list::buttonclicked;call super::buttonclicked;s_Junpoy str_AccJunpoy

IF dwo.name = 'dcb_junpoy' THEN										/*전표 조회*/
	str_AccJunPoy.saupjang = This.GetItemString(This.GetRow(),"saupj")
	str_AccJunPoy.upmugu   = This.GetItemString(This.GetRow(),"upmu_gu")
	str_AccJunPoy.accdate  = Left(This.GetItemString(This.GetRow(),"acdat"),4) + &
									 Mid(This.GetItemString(This.GetRow(),"acdat"),6,2) + &
									 Right(This.GetItemString(This.GetRow(),"acdat"),2) 
	str_AccJunPoy.junno    = This.GetItemNumber(This.GetRow(),"jun_no")

	OpenWithParm(w_kgld69c,Str_AccJunpoy)
END IF
end event

type rr_3 from roundrectangle within w_kgld75
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 256
integer width = 4562
integer height = 1964
integer cornerheight = 40
integer cornerwidth = 55
end type

