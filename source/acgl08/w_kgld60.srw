$PBExportHeader$w_kgld60.srw
$PBExportComments$계정별 외화 잔액 명세서 조회 출력
forward
global type w_kgld60 from w_standard_print
end type
type rb_1 from radiobutton within w_kgld60
end type
type rb_2 from radiobutton within w_kgld60
end type
type rr_1 from roundrectangle within w_kgld60
end type
type rr_2 from roundrectangle within w_kgld60
end type
end forward

global type w_kgld60 from w_standard_print
integer x = 0
integer y = 0
string title = "계정별 외화잔액 명세서 조회 출력"
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_kgld60 w_kgld60

forward prototypes
public function integer wf_print ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_print ();Return 1
end function

public function integer wf_retrieve ();String  sSaupj,sBaseYm,sAcc1,sAcc2,sAccName,sCustF,sCustT,sSaupName, sAccode,sGbn6
Integer k

IF dw_ip.AcceptText() = -1 then return -1

sSaupj  = dw_ip.GetItemString(1,"saupj")
sBaseYm = Trim(dw_ip.GetItemString(1,"acc_ym"))
sAcc1   = dw_ip.getitemstring(1,"sacc1")
sAcc2   = dw_ip.getitemstring(1,"sacc2")
sCustF  = Trim(dw_ip.GetItemString(1,"fr_incd"))
sCustT  = Trim(dw_ip.GetItemString(1,"to_incd"))

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
ELSE
	SELECT "REFFPF"."RFNA1"  INTO :sSaupName  
		FROM "REFFPF"  
		WHERE "REFFPF"."RFCOD" = 'AD'   AND	"REFFPF"."RFGUB" = :sSaupj ;
END IF

IF sBaseYm = "" OR IsNull(sBaseYm) THEN
	F_MessageChk(1,'[회계년월]')
	dw_ip.SetColumn("acc_ym")
	dw_ip.SetFocus()
	Return -1
END IF

IF sAcc1 ="" OR IsNull(sAcc1) OR sAcc2 = '' OR IsNull(sAcc2) THEN
   sAccode = '%'	
else
	SELECT "GBN6"      INTO :sGbn6  FROM "KFZ01OM0"	 WHERE "ACC1_CD"  =  :sAcc1 and "ACC2_CD"  =  :sAcc2;
	if sqlca.sqlcode <> 0 OR sGbn6 <> 'Y' then
		F_Messagechk(1,'[계정과목]')
	   dw_ip.SetColumn("sacc2")
	   dw_ip.SetFocus()
	   Return -1
	end if
   sAccode = sAcc1 + sAcc2
End if

IF sCustF = "" OR IsNull(sCustF) THEN
	sCustF = '0'
END IF
IF sCustT = "" OR IsNull(sCustT) THEN
	sCustT = 'ZZZZZZZZZZZZZZZZZZZZ'
END IF

dw_print.modify("saup.text ='"+sSaupName+"'") 									
if dw_print.retrieve(sSaupj, Left(sBaseYm,4), Mid(sBaseYm,5,2),sAccode, sCustF,sCustT) <= 0 then
	F_MessageChk(14,'')
	dw_list.insertrow(0)
   dw_list.SetRedraw(true)	
	dw_ip.SetFocus()	
	//return -1
end if 
dw_print.sharedata(dw_list)
dw_list.SetRedraw(true)	

Return 1
end function

on w_kgld60.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_kgld60.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;
dw_ip.SetItem(1,"acc_ym", left(f_today(), 6))
dw_ip.SetItem(1,"saupj", gs_saupj)

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)

end event

type p_xls from w_standard_print`p_xls within w_kgld60
end type

type p_sort from w_standard_print`p_sort within w_kgld60
end type

type p_preview from w_standard_print`p_preview within w_kgld60
integer y = 12
end type

type p_exit from w_standard_print`p_exit within w_kgld60
integer y = 12
end type

type p_print from w_standard_print`p_print within w_kgld60
integer y = 12
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld60
integer y = 12
end type

type st_window from w_standard_print`st_window within w_kgld60
integer x = 2405
integer width = 466
end type

type sle_msg from w_standard_print`sle_msg within w_kgld60
integer width = 2011
end type

type dw_datetime from w_standard_print`dw_datetime within w_kgld60
integer x = 2866
end type

type st_10 from w_standard_print`st_10 within w_kgld60
end type

type gb_10 from w_standard_print`gb_10 within w_kgld60
integer width = 3616
end type

type dw_print from w_standard_print`dw_print within w_kgld60
integer x = 4151
integer y = 216
string dataobject = "dw_kgld602_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld60
integer x = 32
integer width = 3141
integer height = 220
string dataobject = "dw_kgld601"
end type

event dw_ip::rbuttondown;String ssql_gaej1,snull, ls_acc1_cd

SetNull(snull)

dw_ip.AcceptText()

IF this.GetColumnName() ="sacc1" THEN	
	SetNull(lstr_account.acc1_cd)
	SetNull(lstr_account.acc2_cd)
	
	lstr_account.acc1_cd = dw_ip.GetItemString(dw_ip.GetRow(), "sacc1")
	IF IsNull(lstr_account.acc1_cd) THEN
		lstr_account.acc1_cd =""
	END IF
	
	Open(W_KFZ01OM0_POPUP_WOIHWA)
	
	IF IsNull(lstr_account.acc1_cd) THEN 
		dw_ip.SetItem(dw_ip.GetRow(), "sacc1", snull)
		dw_ip.SetItem(dw_ip.GetRow(), "sacc2", snull)
		dw_ip.SetItem(dw_ip.GetRow(), "saccname",snull)
		Return
	END IF
	
	this.SetItem(1,"sacc1",lstr_account.acc1_cd)
	this.SetItem(1,"sacc2",lstr_account.acc2_cd)
	this.SetItem(1,"saccname",lstr_account.acc2_nm)
	this.TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() ="fr_incd" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)
	
	lstr_custom.code = dw_ip.GetItemString(dw_ip.GetRow(),"fr_incd")
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF
	
	ls_acc1_cd = dw_ip.getitemstring(dw_ip.getrow(), "sacc1")
	
	if ls_acc1_cd = '' or isnull(ls_acc1_cd) then 
		setnull(lstr_account.gbn1)
		if isnull(lstr_account.gbn1) then lstr_account.gbn1 = '%'
		OpenWithParm(W_KFZ04OM0_POPUP, lstr_account.gbn1)
	else
		gs_code = dw_ip.getitemstring(dw_ip.getrow(), "sacc1") + dw_ip.getitemstring(dw_ip.getrow(), "sacc2")
		if lstr_account.gbn1 = "" or isnull(lstr_account.gbn1) then lstr_account.gbn1 = '%'
		OpenWithParm(W_KFZ04OM0_POPUP_KWAN, lstr_account.gbn1)
	end if
	
	IF IsNull(lstr_custom) THEN
		dw_ip.SetItem(dw_ip.GetRow(), "fr_incd",snull)
		dw_ip.SetItem(dw_ip.GetRow(), "fr_innm",snull)
	ELSE	
		dw_ip.SetItem(dw_ip.GetRow(), "fr_incd",lstr_custom.code)
		dw_ip.SetItem(dw_ip.GetRow(), "fr_innm",lstr_custom.name)
	END IF
ELSEIF this.GetColumnName() ="to_incd" THEN
	SetNull(lstr_custom.code)
	SetNull(lstr_custom.name)

	lstr_custom.code = dw_ip.GetItemString(dw_ip.GetRow(),"to_incd")
	IF IsNull(lstr_custom.code) THEN
		lstr_custom.code = ""
	END IF
	
	ls_acc1_cd = dw_ip.getitemstring(dw_ip.getrow(), "sacc1")
	
	if ls_acc1_cd = '' or isnull(ls_acc1_cd) then 
		setnull(lstr_account.gbn1)
		if isnull(lstr_account.gbn1) then lstr_account.gbn1 = '%'
		OpenWithParm(W_KFZ04OM0_POPUP, lstr_account.gbn1)
	else
		gs_code = dw_ip.getitemstring(dw_ip.getrow(), "sacc1") + dw_ip.getitemstring(dw_ip.getrow(), "sacc2")
		if lstr_account.gbn1 = "" or isnull(lstr_account.gbn1) then lstr_account.gbn1 = '%'
		OpenWithParm(W_KFZ04OM0_POPUP_KWAN, lstr_account.gbn1)
	end if
	
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
String snull,sSaupj,sYearMonth,sAcc1,sAcc2,sSql_gaej1,sSql_gaej2,sBalGbn,sCustF,sCustT,sCustName,&
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

IF this.GetColumnName() = "acc_ym" THEN
	sYearMonth = Trim(this.GetText())
	IF sYearMonth = "" OR IsNull(sYearMonth) THEN Return
	
	IF F_DateChk(sYearMonth + '01') = -1 THEN
		F_MessageChk(21,'[회계년월]')
		this.SetItem(this.GetRow(),"acc_ym",sNull)
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
		dw_ip.SetItem(1,"saccname",ssql_gaej1+'-'+ssql_gaej2)
		
	ELSE
//     	f_Messagechk(28,"")
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
		dw_ip.SetItem(1,"saccname",ssql_gaej1+'-'+ssql_gaej2)
	ELSE
//     	f_Messagechk(28,"")
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
		lstr_account.gbn1 = '%'
	END IF
	
	SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
		FROM "KFZ04OM0"  
		WHERE ( "KFZ04OM0"."PERSON_CD" = :sCustF) AND 
				( "KFZ04OM0"."PERSON_GU" like :lstr_account.gbn1) AND
				( "KFZ04OM0"."PERSON_STS" like '%');
		
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
				( "KFZ04OM0"."PERSON_GU" like :lstr_account.gbn1) AND
				( "KFZ04OM0"."PERSON_STS" like '%');
	
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

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::ue_key;IF key = keyf1! THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kgld60
integer x = 41
integer y = 240
integer width = 4558
integer height = 1972
string title = "계정 잔액 명세서"
string dataobject = "dw_kgld602"
boolean border = false
end type

type rb_1 from radiobutton within w_kgld60
integer x = 3227
integer y = 72
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = " 코드순"
end type

event clicked;dw_list.SetRedraw(False)

IF rb_1.Checked =True THEN
   dw_list.setsort("acc1_cd a, acc2_cd a,person_cd a") 
   dw_list.sort()
END IF
dw_list.SetRedraw(True)

dw_list.settransobject(sqlca)

end event

type rb_2 from radiobutton within w_kgld60
integer x = 3552
integer y = 72
integer width = 302
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = " 명칭순"
end type

event clicked;dw_list.SetRedraw(False)

IF rb_2.Checked =True THEN
	dw_list.setsort("acc1_cd a, acc2_cd a, person_nm a")
   dw_list.sort()
END IF

dw_list.SetRedraw(True)

dw_list.settransobject(sqlca)

end event

type rr_1 from roundrectangle within w_kgld60
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 3186
integer y = 16
integer width = 722
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kgld60
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 236
integer width = 4576
integer height = 1988
integer cornerheight = 40
integer cornerwidth = 55
end type

