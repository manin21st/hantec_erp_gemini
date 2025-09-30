$PBExportHeader$w_kgle11.srw
$PBExportComments$계정별 일일잔액 조회
forward
global type w_kgle11 from w_standard_print
end type
type pb_1 from picturebutton within w_kgle11
end type
type pb_2 from picturebutton within w_kgle11
end type
type pb_3 from picturebutton within w_kgle11
end type
type pb_4 from picturebutton within w_kgle11
end type
type gb_5 from groupbox within w_kgle11
end type
type rr_3 from roundrectangle within w_kgle11
end type
end forward

global type w_kgle11 from w_standard_print
integer x = 0
integer y = 0
string title = "계정별 일일잔액 조회"
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
gb_5 gb_5
rr_3 rr_3
end type
global w_kgle11 w_kgle11

forward prototypes
public function integer wf_retrieve ()
public function integer wf_data_chk (string scolname, string scolvalue)
end prototypes

public function integer wf_retrieve ();String sSaupj,sSaupjName,sSaupjF,sSaupjT
string sacc_ymd, eacc_ymd
string acc_fr, acc_to, sAcc1,sAcc2

dw_ip.AcceptText()
sSaupj   = Trim(dw_ip.GetItemString(1,"saupj"))
sacc_ymd = Trim(dw_ip.GetItemString(1,"acc_ym"))

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
END IF
IF sAcc_Ymd = "" OR IsNull(sAcc_Ymd) THEN
	F_MessageChk(1,'[해당년월]')
	dw_ip.SetColumn("acc_ym")
	dw_ip.SetFocus()
	Return -1
END IF
	
SELECT "REFFPF"."RFNA1"  
	INTO :sSaupjName  
   FROM "REFFPF"  
	WHERE "REFFPF"."RFCOD" = 'AD'   AND "REFFPF"."RFGUB" = :sSaupj ;

sAcc1 = dw_ip.GetItemString(1,"sacc1")
sAcc2 = dw_ip.GetItemString(1,"sacc2")
IF sAcc1 = '' or IsNull(sAcc1) or sAcc2 = '' or IsNull(sAcc2) then
	F_MessageChk(1,'[계정과목]')
	dw_ip.SetColumn("sacc1")
	dw_ip.SetFocus()
	Return -1
end if
//acc1_to = dw_ip.GetItemString(1,"eacc1")
//acc2_to = dw_ip.GetItemString(1,"eacc2")

//acc_fr = acc1_fr + acc2_fr
//acc_to = acc1_to + acc2_to

SELECT "KFZ01OM0"."FRACC1_CD"||"KFZ01OM0"."FRACC2_CD",
		 "KFZ01OM0"."TOACC1_CD"||"KFZ01OM0"."TOACC2_CD"  
	INTO :acc_fr,        :acc_to   
   FROM "KFZ01OM0" 
	WHERE "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" = :sAcc1||:sAcc2;

setpointer(hourglass!)
//dw_print.modify("saup.text ='"+sSaupjName+"'") 
//dw_print.modify("symd.text ='"+String(sAcc_Ymd,'@@@@.@@')+"'")

if dw_print.retrieve(sSaupj,Left(sAcc_ymd,4),acc_fr,acc_to,sSaupjF,sSaupjT,sacc_ymd) <= 0 then
	messagebox("확인","조회한 자료가 없습니다.!!") 
	return -1
end if 
dw_print.sharedata(dw_list)
dw_ip.SetFocus()
setpointer(arrow!)
Return 1
end function

public function integer wf_data_chk (string scolname, string scolvalue);String snull,mysql1,sacc,ssql_gaej1,ssql_gaej2,sdate

SetNull(snull)

IF scolname ="sacc1" THEN
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"sacc2")	

	IF sacc ="" OR IsNull(sacc) THEN RETURN 1
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND  
         	( "KFZ01OM0"."ACC2_CD" = :sacc ) AND ( "KFZ01OM0"."BAL_GU" <> '4') ;
				
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"saccname",ssql_gaej2)
	ELSE
   	f_Messagechk(25,"")
	   dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		dw_ip.SetColumn("sacc1")
		dw_ip.SetFocus()
	   Return -1
	END IF
END IF

IF scolname ="sacc2" THEN
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"sacc1")	
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 1
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :scolvalue ) AND ( "KFZ01OM0"."BAL_GU" <> '4');
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"saccname",ssql_gaej2)
	ELSE
   	f_Messagechk(25,"") 
	   dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		dw_ip.SetColumn("sacc1")
		dw_ip.SetFocus()
	   Return -1
	END IF
END IF

IF scolname ="eacc1" THEN
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"eacc2")	

	IF sacc ="" OR IsNull(sacc) THEN RETURN 1
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND  
         	( "KFZ01OM0"."ACC2_CD" = :sacc ) ;
				
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"eaccname",ssql_gaej2)
	ELSE
//   	f_Messagechk(25,"") 
	   dw_ip.SetItem(1,"eacc1",snull)
		dw_ip.SetItem(1,"eacc2",snull)
		dw_ip.SetItem(1,"eaccname",snull)
		dw_ip.SetColumn("eacc1")
		dw_ip.SetFocus()
	   Return -1
	END IF
END IF

IF scolname ="eacc2" THEN
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"eacc1")	
	
	IF sacc ="" OR IsNull(sacc) THEN RETURN 1
	
	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
    	INTO :ssql_gaej1,:ssql_gaej2
    	FROM "KFZ01OM0"  
   	WHERE ( "KFZ01OM0"."ACC1_CD" = :sacc ) AND  
         	( "KFZ01OM0"."ACC2_CD" = :scolvalue );
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"eaccname",ssql_gaej2)
	ELSE
//   	f_Messagechk(25,"") 
	   dw_ip.SetItem(1,"eacc1",snull)
		dw_ip.SetItem(1,"eacc2",snull)
		dw_ip.SetItem(1,"eaccname",snull)
		dw_ip.SetColumn("eacc1")
		dw_ip.SetFocus()
	   Return -1
	END IF
END IF
Return 1
end function

on w_kgle11.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.gb_5=create gb_5
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_3
this.Control[iCurrent+4]=this.pb_4
this.Control[iCurrent+5]=this.gb_5
this.Control[iCurrent+6]=this.rr_3
end on

on w_kgle11.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.gb_5)
destroy(this.rr_3)
end on

event open;call super::open;dw_ip.SetItem(1,"acc_ym",Left(f_today(),6))
dw_ip.SetItem(1,"saupj", gs_saupj)


end event

type p_preview from w_standard_print`p_preview within w_kgle11
boolean visible = false
integer x = 4265
integer y = 204
end type

type p_exit from w_standard_print`p_exit within w_kgle11
integer x = 4434
integer y = 0
integer taborder = 40
end type

type p_print from w_standard_print`p_print within w_kgle11
boolean visible = false
integer x = 4448
integer y = 208
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgle11
integer x = 4256
integer y = 0
integer taborder = 20
end type







type st_10 from w_standard_print`st_10 within w_kgle11
end type



type dw_print from w_standard_print`dw_print within w_kgle11
integer x = 4160
integer y = 136
string dataobject = "dw_kgle112"
end type

type dw_ip from w_standard_print`dw_ip within w_kgle11
integer x = 46
integer width = 3058
integer height = 140
integer taborder = 10
string dataobject = "dw_kgle111"
end type

event dw_ip::rbuttondown;setnull(lstr_account.acc1_cd)
setnull(lstr_account.acc2_cd)

IF this.GetColumnName() <>"sacc1" AND this.GetColumnName() <>"eacc1" THEN RETURN

dw_ip.AcceptText()

IF this.GetColumnName() = "sacc1" THEN
	lstr_account.acc1_cd = dw_ip.GetItemString(dw_ip.GetRow(), "sacc1") 
//	lstr_account.acc2_cd = dw_ip.GetItemString(dw_ip.GetRow(), "sacc2") 

	IF IsNull(lstr_account.acc1_cd) then
		lstr_account.acc1_cd = ""
	end if
	IF IsNull(lstr_account.acc2_cd) then
		lstr_account.acc2_cd = ""
	end if
	lstr_account.acc1_cd = Trim(lstr_account.acc1_cd)
	lstr_account.acc2_cd = Trim(lstr_account.acc2_cd)
	
	Open(W_KFZ01OM0_POPUP)
	
	dw_ip.SetItem(dw_ip.GetRow(), "sacc1", lstr_account.acc1_cd)
	dw_ip.SetItem(dw_ip.GetRow(), "sacc2", lstr_account.acc2_cd)
	dw_ip.SetItem(dw_ip.Getrow(),"saccname",lstr_account.acc1_nm+" - "+lstr_account.acc2_nm)
	
ELSEIF this.GetColumnName() = "eacc1" THEN 
	lstr_account.acc1_cd = dw_ip.GetItemString(dw_ip.GetRow(), "eacc1")
//	lstr_account.acc2_cd = dw_ip.GetItemString(dw_ip.GetRow(), "eacc2") 

	IF IsNull(lstr_account.acc1_cd) then
		lstr_account.acc1_cd = ""
	end if
	IF IsNull(lstr_account.acc2_cd) then
		lstr_account.acc2_cd = ""
	end if
	lstr_account.acc1_cd = Trim(lstr_account.acc1_cd)
	lstr_account.acc2_cd = Trim(lstr_account.acc2_cd)
	
	Open(W_KFZ01OM0_POPUP)
	
	dw_ip.SetItem(dw_ip.GetRow(), "eacc1", lstr_account.acc1_cd)
	dw_ip.SetItem(dw_ip.GetRow(), "eacc2", lstr_account.acc2_cd)
	dw_ip.SetItem(dw_ip.Getrow(),"eaccname",lstr_account.acc1_nm+" - "+lstr_account.acc2_nm)

END IF
dw_ip.SetFocus()
end event

event dw_ip::itemchanged;IF WF_DATA_CHK(dwo.name,data) = -1 THEN RETURN 2
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::losefocus;call super::losefocus;dw_ip.AcceptText()
end event

event dw_ip::ue_key;call super::ue_key;//IF keydown(keytab!) THEN
//	TriggerEvent(RbuttonDown!)
//END IF
end event

type dw_list from w_standard_print`dw_list within w_kgle11
integer x = 64
integer y = 168
integer width = 4535
integer height = 2036
integer taborder = 30
string title = "계정별 일일잔액 조회"
string dataobject = "dw_kgle112"
boolean border = false
end type

event dw_list::doubleclicked;call super::doubleclicked;//if row <= 0 then return
//
//if f_call_junpyo(dw_ip.object.saupj[1], this.object.acdat[row], this.object.jun_no[row], this.object.lin_no[row]) = 1 then
//	OpenSheetWithParm(w_kglc01b,'',w_mdi_frame,2,Layered!)
//end if
end event

type pb_1 from picturebutton within w_kgle11
integer x = 3141
integer y = 44
integer width = 82
integer height = 72
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

type pb_2 from picturebutton within w_kgle11
integer x = 3232
integer y = 44
integer width = 82
integer height = 72
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

type pb_3 from picturebutton within w_kgle11
integer x = 3323
integer y = 44
integer width = 82
integer height = 72
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

type pb_4 from picturebutton within w_kgle11
integer x = 3415
integer y = 44
integer width = 82
integer height = 72
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

type gb_5 from groupbox within w_kgle11
integer x = 3109
integer width = 434
integer height = 144
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "자료선택"
end type

type rr_3 from roundrectangle within w_kgle11
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 160
integer width = 4562
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

