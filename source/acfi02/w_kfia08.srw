$PBExportHeader$w_kfia08.srw
$PBExportComments$예금거래현황 조회출력
forward
global type w_kfia08 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia08
end type
end forward

global type w_kfia08 from w_standard_print
string tag = "예금거래현황 조회출력"
integer x = 0
integer y = 0
string title = "예금거래현황 조회 출력"
rr_1 rr_1
end type
global w_kfia08 w_kfia08

forward prototypes
public function integer wf_retrieve ()
public function integer wf_data_chk (string scolname, string scolvalue)
end prototypes

public function integer wf_retrieve ();String sSaupj, sFrom,sTo,sBnkF,sBnkT, sGbn

dw_ip.AcceptText()

sSaupj = dw_ip.GetItemString(1,"saupj")
sFrom  = Trim(dw_ip.GetItemString(1,"k_symd"))
sTo    = Trim(dw_ip.GetItemString(1,"k_eymd"))

sBnkF  = dw_ip.GetItemString(1,"fr_incd")
sBnkT  = dw_ip.GetItemString(1,"to_incd")
sGbn   = dw_ip.GetItemString(1,"sgbn")

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sFrom = "" OR IsNull(sFrom) THEN
	F_MessageChk(1,'[거래일자]')
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(sFrom) = -1 THEN
		f_messagechk(23, "")
		dw_ip.SetColumn("k_symd")
		dw_ip.SetFocus()
		Return -1
	END IF	
END IF

IF sTo = "" OR IsNull(sTo) THEN
	F_MessageChk(1,'[거래일자]')
	dw_ip.SetColumn("k_eymd")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(sTo) = -1 THEN
		f_messagechk(23, "")
		dw_ip.SetColumn("k_eymd")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

if long(sFrom) > long(sTo) then
	f_messagechk(24,"")
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	return -1
end if	

IF sBnkF ="" OR IsNull(sBnkF) THEN	
	SELECT MIN("KFZ04OM0"."PERSON_CD")       INTO :sBnkF
		FROM "KFZ04OM0"  
    	WHERE ( "KFZ04OM0"."PERSON_GU" = '2');
END IF
IF sBnkT ="" OR IsNull(sBnkT) THEN	
	SELECT MAX("KFZ04OM0"."PERSON_CD")       INTO :sBnkT
		FROM "KFZ04OM0"  
    	WHERE ( "KFZ04OM0"."PERSON_GU" = '2')   ;
END IF

If sGbn = '3' then sGbn = '%'

dw_list.Reset()

IF dw_print.Retrieve(sabu_f,sabu_t,sBnkF,sBnkT,sFrom,sTo,sGbn) <=0 THEN
	F_MessageChk(14,'')
	Return -1
	//dw_list.insertrow(0)
END IF

dw_print.sharedata(dw_list)
dw_ip.SetFocus()

Return 1
end function

public function integer wf_data_chk (string scolname, string scolvalue);string mysql1, snull

SetNull(snull)

IF scolname ="fr_incd" THEN
	SELECT "KFZ04OM0"."PERSON_NM"     	INTO :mysql1
		FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_CD" = :scolvalue ) AND  ( "KFZ04OM0"."PERSON_GU" = '2')   ;

	IF SQLCA.SQLCODE = 0 THEN
   	dw_ip.SetItem(1,"fr_innm",mysql1)
   ELSE
//   	f_Messagechk(20,'[은행]')
//	   dw_ip.SetItem(1,"fr_incd",snull)
//		dw_ip.SetItem(1,"fr_innm",snull)
//		dw_ip.SetColumn("fr_incd")
//		dw_ip.SetFocus()
//		Return -1
   END IF
	
ELSEIF scolname ="to_incd" THEN
	SELECT "KFZ04OM0"."PERSON_NM"     	INTO :mysql1
    	FROM "KFZ04OM0"  
  		WHERE ( "KFZ04OM0"."PERSON_CD" = :scolvalue ) AND  ( "KFZ04OM0"."PERSON_GU" = '2')   ;
	
	IF SQLCA.SQLCODE = 0 THEN
   	dw_ip.SetItem(1,"to_innm",mysql1)
   ELSE
//   	f_Messagechk(20,'[은행]')
//	   dw_ip.SetItem(1,"to_incd",snull)
//		dw_ip.SetItem(1,"to_innm",snull)
//		dw_ip.SetColumn("to_incd")
//		dw_ip.SetFocus()
//		Return -1
   END IF
END IF
Return 1

end function

on w_kfia08.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia08.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"k_symd",Left(f_today(),6)+'01')
dw_ip.SetItem(1,"k_eymd",f_today())
dw_ip.SetItem(1,"saupj", gs_saupj)

IF f_Authority_Fund_Chk(Gs_Dept) = -1 THEN
	dw_ip.Modify('saupj.protect = 1')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(192,192,192))+"'") 
Else
	dw_ip.Modify('saupj.protect = 0')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(255,255,255))+"'")  //MINT COLOR
End if

dw_ip.SetFocus()

end event

type p_preview from w_standard_print`p_preview within w_kfia08
end type

type p_exit from w_standard_print`p_exit within w_kfia08
end type

type p_print from w_standard_print`p_print within w_kfia08
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia08
end type







type st_10 from w_standard_print`st_10 within w_kfia08
end type



type dw_print from w_standard_print`dw_print within w_kfia08
string dataobject = "dw_kfia08_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia08
integer x = 46
integer width = 2368
integer height = 348
string dataobject = "dw_kfia08_1"
end type

event dw_ip::itemchanged;sle_msg.text =""

IF dwo.name ="fr_incd" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
END IF

IF dwo.name ="to_incd" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
END IF

IF WF_DATA_CHK(dwo.name,data) = -1 THEN 
	Return 1
END IF


end event

event dw_ip::itemerror;call super::itemerror;RETURN 1
end event

event dw_ip::rbuttondown;
SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

dw_ip.AcceptText()

IF this.GetColumnName() = "fr_incd"  THEN
	lstr_custom.code = trim(dw_ip.GetItemString(dw_ip.GetRow(), "fr_incd"))
	lstr_custom.name = dw_ip.GetItemString(dw_ip.GetRow(), "fr_innm")
	
	IF IsNull(lstr_custom.code) then
  	 	lstr_custom.code = ""
	end if
	
	lstr_account.gbn1 = '2'
	
	OpenWithParm(w_kfz04om0_popup1,'2')

	dw_ip.SetItem(dw_ip.GetRow(), "fr_incd", lstr_custom.code)
	dw_ip.SetItem(dw_ip.Getrow(), "fr_innm", lstr_custom.name)
ELSEIF this.GetColumnName() = "to_incd" THEN 
	lstr_custom.code = trim(dw_ip.GetItemString(dw_ip.GetRow(), "to_incd"))
	lstr_custom.name = dw_ip.GetItemString(dw_ip.GetRow(), "to_innm")
	
	IF IsNull(lstr_custom.code) then
   	lstr_custom.code = ""
	end if
	
	lstr_account.gbn1 = '2'
	
	OpenWithParm(w_kfz04om0_popup1,'2')
	
	dw_ip.SetItem(dw_ip.GetRow(), "to_incd", lstr_custom.code)
	dw_ip.SetItem(dw_ip.Getrow(), "to_innm", lstr_custom.name)
END IF

dw_ip.SetFocus()
end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfia08
integer x = 69
integer y = 384
integer width = 4517
integer height = 1924
string title = "예금거래현황"
string dataobject = "dw_kfia08_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfia08
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 372
integer width = 4549
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 55
end type

