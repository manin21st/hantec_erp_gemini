$PBExportHeader$w_kgle10.srw
$PBExportComments$전표조회
forward
global type w_kgle10 from w_standard_print
end type
type pb_1 from picturebutton within w_kgle10
end type
type pb_2 from picturebutton within w_kgle10
end type
type pb_3 from picturebutton within w_kgle10
end type
type pb_4 from picturebutton within w_kgle10
end type
type rr_2 from roundrectangle within w_kgle10
end type
end forward

global type w_kgle10 from w_standard_print
integer x = 0
integer y = 0
string title = "전표조회"
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
rr_2 rr_2
end type
global w_kgle10 w_kgle10

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sSaupj, sDateFrom, sDateTo, sAcc1, sAcc2, sCustF, sPrtGbn, sAcCd, sCustName

IF dw_ip.AcceptText() = -1 then return -1

sSaupj    = dw_ip.GetItemString(1,"saupj")
sDateFrom = Trim(dw_ip.GetItemString(1,"k_symd"))
sDateTo   = Trim(dw_ip.GetItemString(1,"k_eymd"))
sAcc1     = dw_ip.getitemstring(1,"sacc1")
sAcc2     = dw_ip.getitemstring(1,"sacc2")
sCustF    = Trim(dw_ip.GetItemString(1,"fr_incd"))
sPrtGbn   = dw_ip.getitemstring(1,"prtgbn")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
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

if sPrtGbn = '1' or sPrtGbn = '2' or sPrtGbn = '4' then
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
	sAcCd = sAcc1+sAcc2
else
	sAcCd = '%'
end if

if sPrtGbn = '2' or sPrtGbn = '3' then
	IF sCustF = "" OR IsNull(sCustF) THEN
		F_Messagechk(1,'[거래처]')
		dw_ip.SetColumn("fr_incd")
		dw_ip.SetFocus()
		Return -1
	END IF
elseif sPrtGbn = '4' or sPrtGbn = '5' then
	IF sCustF = "" OR IsNull(sCustF) THEN
		F_Messagechk(1,'[관리번호]')
		dw_ip.SetColumn("fr_incd")
		dw_ip.SetFocus()
		Return -1
	END IF
else
	sCustF = '%'
end if


//SELECT "KFZ04OM0"."PERSON_NM"		INTO :sCustName
//	  		FROM "KFZ04OM0"  
//   		WHERE ( "KFZ04OM0"."PERSON_CD" = :sCustF) AND ( "KFZ04OM0"."PERSON_STS" like '%');

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
			
dw_print.modify("custnm.text ='"+sCustName+"'") 			

if dw_print.retrieve(sSaupj,sDateFrom,sDateTo,sAcCd,sCustF) <= 0 then
	F_MessageChk(14,'')
	return -1
end if 

dw_print.sharedata(dw_list)
Return 1
end function

on w_kgle10.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_3
this.Control[iCurrent+4]=this.pb_4
this.Control[iCurrent+5]=this.rr_2
end on

on w_kgle10.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.rr_2)
end on

event open;call super::open;
dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF

dw_ip.setitem(1,"k_symd", left(f_today(), 6) + "01")
dw_ip.setitem(1,"k_eymd", f_today())

dw_ip.SetItem(1,"saupj", gs_saupj)

pb_1.Visible = True
pb_2.Visible = True
pb_3.Visible = True
pb_4.Visible = True

end event

type p_preview from w_standard_print`p_preview within w_kgle10
integer taborder = 50
end type

type p_exit from w_standard_print`p_exit within w_kgle10
end type

type p_print from w_standard_print`p_print within w_kgle10
integer taborder = 30
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgle10
end type







type st_10 from w_standard_print`st_10 within w_kgle10
end type



type dw_print from w_standard_print`dw_print within w_kgle10
integer x = 3415
integer y = 112
string dataobject = "dw_kgle102_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgle10
integer y = 4
integer width = 3365
integer height = 344
string dataobject = "dw_kgle101"
end type

event dw_ip::rbuttondown;String snull,sPrtGbn

SetNull(snull)

IF this.GetColumnName() ="sacc1" OR this.GetColumnName() ="sacc2" THEN	
	lstr_account.acc1_cd = Left(Trim(dw_ip.GetItemString(dw_ip.GetRow(), "sacc1")),1)
	
	IF IsNull(lstr_account.acc1_cd) THEN lstr_account.acc1_cd =""
	IF IsNull(lstr_account.acc2_cd) THEN lstr_account.acc2_cd =""
	
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
END IF

IF this.GetColumnName() ="fr_incd" THEN
	SetNull(lstr_custom.name)

	lstr_custom.code = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"fr_incd"))
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""
	
	sPrtGbn = this.GetItemString(this.GetRow(),"prtgbn")
	if sPrtGbn = '2' or sPrtGbn = '3' then
		lstr_account.gbn1 = '1'
	elseif sPrtGbn = '1' then
		lstr_account.gbn1 = ''
	end if
	
	IF lstr_account.gbn1 = "" OR IsNull(lstr_account.gbn1) THEN lstr_account.gbn1 = ''
	
	OpenWithParm(W_KFZ04OM0_POPUP1,lstr_account.gbn1)
	
	IF IsNull(lstr_custom) THEN
		dw_ip.SetItem(dw_ip.GetRow(), "fr_incd",snull)
		dw_ip.SetItem(dw_ip.GetRow(), "fr_innm",snull)
	ELSE	
		dw_ip.SetItem(dw_ip.GetRow(), "fr_incd",lstr_custom.code)
		dw_ip.SetItem(dw_ip.GetRow(), "fr_innm",lstr_custom.name)
	END IF
END IF

IF this.GetColumnName() ="to_incd" THEN
	SetNull(lstr_custom.name)
	
	lstr_custom.code = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"to_incd"))
	IF IsNull(lstr_custom.code) THEN lstr_custom.code = ""
	
	sPrtGbn = this.GetItemString(this.GetRow(),"prtgbn")
	if sPrtGbn = '2' or sPrtGbn = '3' then
		lstr_account.gbn1 = '1'
	elseif sPrtGbn = '1' then
		lstr_account.gbn1 = ''
	end if
	
	IF lstr_account.gbn1 = "" OR IsNull(lstr_account.gbn1) THEN lstr_account.gbn1 = ''
	
	OpenWithParm(W_KFZ04OM0_POPUP1,lstr_account.gbn1)
	
	IF IsNull(lstr_custom) THEN
		dw_ip.SetItem(dw_ip.GetRow(), "to_incd",snull)
		dw_ip.SetItem(dw_ip.GetRow(), "to_innm",snull)
	ELSE	
		dw_ip.SetItem(dw_ip.GetRow(), "to_incd",lstr_custom.code)
		dw_ip.SetItem(dw_ip.GetRow(), "to_innm",lstr_custom.name)
	END IF
END IF

dw_ip.SetFocus()

end event

event dw_ip::itemchanged;
String snull,sSaupj,sYearMonthDay,sAcc1,sAcc2,sSql_gaej1,sSql_gaej2,sBalGbn,sCustF,sCustT,sCustName,&
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
	
    SELECT "ACC1_NM",		"ACC2_NM",		 	"GBN6",	  		decode("GBN6",'Y',"GBN1",''),	"BAL_GU"
    	INTO :ssql_gaej1,		:ssql_gaej2,		:sCustPrtGbn,	:lstr_account.gbn1,				:sBalGbn
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
	
    SELECT "ACC1_NM",		"ACC2_NM",		 	"GBN6",	  		decode("GBN6",'Y',"GBN1",''),	"BAL_GU"
    	INTO :ssql_gaej1,		:ssql_gaej2,		:sCustPrtGbn,	:lstr_account.gbn1,				:sBalGbn
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

if this.GetColumnName() = 'prtgbn' then
	dw_list.SetRedraw(False)
	if this.GetText() = '1' then						/*계정별*/
		dw_list.DataObject = 'dw_kgle102'
		dw_print.DataObject = 'dw_kgle102_p'
		
		pb_1.Visible = True
		pb_2.Visible = True
		pb_3.Visible = True
		pb_4.Visible = True
	elseif this.GetText() = '3' then					/*업체/일자별*/
		dw_list.DataObject = 'dw_kgle103'
		dw_print.DataObject = 'dw_kgle103_p'
		
		pb_1.Visible = False
		pb_2.Visible = False
		pb_3.Visible = False
		pb_4.Visible = False
	elseif this.GetText() = '2' then					/*계정/업체별*/
		dw_list.DataObject = 'dw_kgle104'
		dw_print.DataObject = 'dw_kgle104_p'
		
		pb_1.Visible = False
		pb_2.Visible = False
		pb_3.Visible = False
		pb_4.Visible = False
	elseif this.GetText() = '4' then					/*계정/관리항목별*/
		dw_list.DataObject = 'dw_kgle1041'
		dw_print.DataObject = 'dw_kgle1041_p'
		
		pb_1.Visible = False
		pb_2.Visible = False
		pb_3.Visible = False
		pb_4.Visible = False
	elseif this.GetText() = '5' then					/*관리항목/일자별*/
		dw_list.DataObject = 'dw_kgle1031'
		dw_print.DataObject = 'dw_kgle1031_p'
		
		pb_1.Visible = False
		pb_2.Visible = False
		pb_3.Visible = False
		pb_4.Visible = False
	end if
	dw_list.SetRedraw(True)
	dw_list.SetTransObject(Sqlca)
	dw_print.SetTransObject(Sqlca)
end if


end event

event dw_ip::itemerror;call super::itemerror;RETURN 1
end event

event dw_ip::losefocus;call super::losefocus;dw_ip.AcceptText()
end event

event dw_ip::getfocus;this.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_kgle10
integer x = 55
integer y = 352
integer width = 4539
integer height = 1860
integer taborder = 40
string dataobject = "dw_kgle102"
boolean border = false
end type

type pb_1 from picturebutton within w_kgle10
integer x = 1198
integer y = 236
integer width = 82
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\FIRST.gif"
alignment htextalign = left!
end type

event clicked;String sAcc1,sAcc2,sAccName,sGetAccCode

dw_ip.AcceptText()
sAcc1 = dw_ip.GetItemString(dw_ip.GetRow(),"sacc1")
sAcc2 = dw_ip.GetItemString(dw_ip.GetRow(),"sacc2")

SELECT MIN("KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD")  
	INTO :sGetAccCode
   FROM "KFZ01OM0"
	WHERE "BAL_GU" <> '4' ;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetAccCode) OR sGetAccCode = "" THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	IF sAcc1 + sAcc2 = sGetAccCode THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	select acc2_nm	into :sAccName from kfz01om0 where acc1_cd||acc2_cd = :sGetAccCode ;
	
	dw_ip.SetItem(dw_ip.GetRow(),"sacc1",    Left(sGetAccCode,5))
	dw_ip.SetItem(dw_ip.GetRow(),"sacc2",    Mid(sGetAccCode,6,2))
	dw_ip.SetItem(dw_ip.GetRow(),"saccname", sAccName)
	

p_retrieve.TriggerEvent(Clicked!)
END IF
	
end event

type pb_2 from picturebutton within w_kgle10
integer x = 1289
integer y = 236
integer width = 82
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\prior.gif"
alignment htextalign = left!
end type

event clicked;String sAcc1,sAcc2,sGetAccCode,sAcc,sAccName

dw_ip.AcceptText()
sAcc1 = dw_ip.GetItemString(dw_ip.GetRow(),"sacc1")
sAcc2 = dw_ip.GetItemString(dw_ip.GetRow(),"sacc2")

sAcc = sAcc1 + sAcc2

//p_retrieve.PostEvent(Clicked!)

SELECT MAX("ACC1_CD"||"ACC2_CD")  
	INTO :sGetAccCode
   FROM "KFZ01OM0"
	WHERE "ACC1_CD"||"ACC2_CD" < :sAcc and "BAL_GU" <> '4' ;

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetAccCode) THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
		
	select acc2_nm	into :sAccName from kfz01om0 where acc1_cd||acc2_cd = :sGetAccCode ;
	
	dw_ip.SetItem(dw_ip.GetRow(),"sacc1",    Left(sGetAccCode,5))
	dw_ip.SetItem(dw_ip.GetRow(),"sacc2",    Mid(sGetAccCode,6,2))
	dw_ip.SetItem(dw_ip.GetRow(),"saccname", sAccName)
	
p_retrieve.TriggerEvent(Clicked!)
END IF

end event

type pb_3 from picturebutton within w_kgle10
integer x = 1381
integer y = 236
integer width = 82
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\next.gif"
alignment htextalign = left!
end type

event clicked;String sAcc1,sAcc2,sGetAccCode,sAcc,sAccName

dw_ip.AcceptText()
sAcc1 = dw_ip.GetItemString(dw_ip.GetRow(),"sacc1")
sAcc2 = dw_ip.GetItemString(dw_ip.GetRow(),"sacc2")

sAcc = sAcc1 + sAcc2

SELECT MIN("ACC1_CD"||"ACC2_CD")  
	INTO :sGetAccCode
   FROM "KFZ01OM0"
	WHERE "ACC1_CD"||"ACC2_CD" > :sAcc and "BAL_GU" <> '4' ;

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetAccCode) THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
		
	select acc2_nm	into :sAccName from kfz01om0 where acc1_cd||acc2_cd = :sGetAccCode ;
	
	dw_ip.SetItem(dw_ip.GetRow(),"sacc1",    Left(sGetAccCode,5))
	dw_ip.SetItem(dw_ip.GetRow(),"sacc2",    Mid(sGetAccCode,6,2))
	dw_ip.SetItem(dw_ip.GetRow(),"saccname", sAccName)
	

p_retrieve.TriggerEvent(Clicked!)
END IF
end event

type pb_4 from picturebutton within w_kgle10
integer x = 1472
integer y = 236
integer width = 82
integer height = 72
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\last.gif"
alignment htextalign = left!
end type

event clicked;String sAcc1,sAcc2,sAccName,sGetAccCode

dw_ip.AcceptText()
sAcc1 = dw_ip.GetItemString(dw_ip.GetRow(),"sacc1")
sAcc2 = dw_ip.GetItemString(dw_ip.GetRow(),"sacc2")

SELECT MAX("KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD")  
	INTO :sGetAccCode
   FROM "KFZ01OM0"
	WHERE "BAL_GU" <> '4' ;
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('확 인','더이상 자료가 없습니다.')
	Return
ELSE
	If IsNull(sGetAccCode) OR sGetAccCode = "" THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	IF sAcc1 + sAcc2 = sGetAccCode THEN
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
	
	select acc2_nm	into :sAccName from kfz01om0 where acc1_cd||acc2_cd = :sGetAccCode ;
	
	dw_ip.SetItem(dw_ip.GetRow(),"sacc1",    Left(sGetAccCode,5))
	dw_ip.SetItem(dw_ip.GetRow(),"sacc2",    Mid(sGetAccCode,6,2))
	dw_ip.SetItem(dw_ip.GetRow(),"saccname", sAccName)
	

p_retrieve.TriggerEvent(Clicked!)
END IF
	
end event

type rr_2 from roundrectangle within w_kgle10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 348
integer width = 4571
integer height = 1880
integer cornerheight = 40
integer cornerwidth = 55
end type

