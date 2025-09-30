$PBExportHeader$w_kfia13.srw
$PBExportComments$지급어음검색 조회 출력
forward
global type w_kfia13 from w_standard_print
end type
type dw_1 from datawindow within w_kfia13
end type
type dw_cust from datawindow within w_kfia13
end type
type rr_1 from roundrectangle within w_kfia13
end type
type rr_2 from roundrectangle within w_kfia13
end type
end forward

global type w_kfia13 from w_standard_print
integer x = 0
integer y = 0
string title = "지급어음 검색 명세서 출력"
dw_1 dw_1
dw_cust dw_cust
rr_1 rr_1
rr_2 rr_2
end type
global w_kfia13 w_kfia13

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();
string sfrom               //어음번호
string sDatefrom, sDateto       //만기일
string sstatusf      //어음상태
string scustfrom, scustto      //거래처번호
string snamefrom, snameto       //발행일

dw_list.reset()
if dw_ip.AcceptText() = -1 then return -1
if dw_1.AcceptText() = -1 then return -1

///어음번호 검색하기////////////////////////////////////////////////////////

sfrom = dw_ip.GetItemString(1,"aeumno_f")

if isnull(sfrom) or sfrom = '' then sfrom = '%'

///만기일 검색하기//////////////////////////////////////////////////////
sDatefrom = Trim(dw_1.GetItemString(dw_1.getrow(),"k_symd"))
sDateto   = Trim(dw_1.GetItemString(dw_1.getrow(),"k_eymd"))

if isnull(sdatefrom) or sdatefrom = '' then sdatefrom = '00000000'
if isnull(sdateto)   or sdateto = '' then   sdateto   = '99999999'

if sDatefrom > sDateto then
	f_messagechk(26,"만기일자")
	dw_1.setfocus()
	dw_1.setcolumn("k_symd")
	Return -1
end if	


///어음상태 검색하기//////////////////////////////////////////////////////
sstatusf = dw_1.getitemstring(dw_1.getrow(),"status_f")

if isnull(sstatusf) or sstatusf = '' then sstatusf = '%'

///거래처 검색하기////////////////////////////////////////////////////////
if dw_cust.AcceptText() = -1 then return -1

scustfrom = dw_cust.GetItemString(dw_cust.GetRow(),"kfz10ot0_saup_no")
scustto   = dw_cust.GetItemString(dw_cust.GetRow(),"esaup")

if isnull(scustfrom) or scustfrom = '' then scustfrom = '100000'
if isnull(scustto) or scustto = '' then scustto = '999999'

///발행일자 검색하기////////////////////////////////////////////////////////
snamefrom = Trim(dw_1.GetItemString(dw_1.getrow(),"balname_f"))
snameto   = Trim(dw_1.GetItemString(dw_1.getrow(),"balname_t"))

if isnull(snamefrom) or snamefrom = '' then snamefrom = '00000000'
if isnull(snameto)   or snameto = '' then   snameto   = '99999999'

if snamefrom > snameto then 
	f_messagechk(26,"발행일자")
	dw_1.SetFocus()
	dw_1.setcolumn("balname_f")	
	return -1
end if

if dw_print.retrieve(sfrom, sdatefrom, sdateto, sstatusf, scustfrom, scustto, snamefrom, snameto) <= 0 then
	f_messagechk(14,"")
	dw_ip.SetFocus()
	//Return -1
	dw_list.insertrow(0)
end if	
dw_print.sharedata(dw_list)
return 1

end function

on w_kfia13.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_cust=create dw_cust
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_cust
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_kfia13.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_cust)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_cust.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

dw_cust.InsertRow(0)
dw_1.InsertRow(0)

dw_1.setitem(dw_1.getrow(),"k_symd",string(Today(),"yyyymm01"))
dw_1.setitem(dw_1.getrow(),"k_eymd",string(Today(),"yyyymmdd"))

dw_1.setitem(dw_1.getrow(),"balname_f",string(Today(),"yyyymm01"))
dw_1.setitem(dw_1.getrow(),"balname_t",string(Today(),"yyyymmdd"))

dw_ip.setitem(dw_ip.getrow(),"saupj", Gs_Saupj)
IF f_Authority_Fund_Chk(Gs_Dept) = -1 THEN
	dw_ip.Modify('saupj.protect = 1')
	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(192,192,192))+"'") 
Else
	dw_ip.Modify('saupj.protect = 0')
	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(255,255,255))+"'")  //MINT COLOR
End if



end event

type p_preview from w_standard_print`p_preview within w_kfia13
integer taborder = 20
end type

type p_exit from w_standard_print`p_exit within w_kfia13
integer taborder = 50
end type

type p_print from w_standard_print`p_print within w_kfia13
integer taborder = 40
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia13
end type







type st_10 from w_standard_print`st_10 within w_kfia13
end type



type dw_print from w_standard_print`dw_print within w_kfia13
string dataobject = "d_kfia13_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfia13
integer x = 50
integer y = 48
integer width = 933
integer height = 80
string dataobject = "d_kfia131"
end type

type dw_list from w_standard_print`dw_list within w_kfia13
integer y = 348
integer width = 4558
integer height = 1972
string title = "지급 어음 검색"
string dataobject = "d_kfia13"
boolean border = false
end type

type dw_1 from datawindow within w_kfia13
event ue_pressenter pbm_dwnprocessenter
integer x = 50
integer y = 124
integer width = 2665
integer height = 172
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_kfia133"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String s_symd_f, s_symd_t, s_bal_f, s_bal_t,snull

SetNull(snull)

IF This.AcceptText() = -1 THEN Return

//만기일  from check
IF this.GetColumnName() = "k_symd" THEN
	s_symd_f    = Trim(this.GetText())
	IF s_symd_f = "" OR IsNull(s_symd_f) THEN RETURN
	
	IF F_DateChk(s_symd_f) = -1 THEN
		F_MessageChk(21,'[만기일자]')
		this.SetItem(row, "k_symd", snull)
		Return 1
	END IF
END IF

//만기일  to check
IF this.GetColumnName() = "k_eymd" THEN
	s_symd_t      = Trim(this.GetText())
	IF s_symd_t = "" OR IsNull(s_symd_t) THEN RETURN
	
	IF F_DateChk(s_symd_t) = -1 THEN
		F_MessageChk(21,'[만기일자]')
		this.SetItem(Row, "k_eymd", snull)
		Return 1
	END IF
END IF


//발행일  from check
IF this.GetColumnName() = "balname_f" THEN
	s_bal_f    = Trim(this.GetText())
	IF s_bal_f = "" OR IsNull(s_bal_f) THEN RETURN
	
	IF F_DateChk(s_bal_f) = -1 THEN
		F_MessageChk(21,'[발행일자]')
		this.SetItem(row, "balname_f", snull)
		Return 1
	END IF
END IF

//발행일  to check
IF this.GetColumnName() = "balname_t" THEN
	s_bal_t      = Trim(this.GetText())
	IF s_bal_t = "" OR IsNull(s_bal_t) THEN RETURN
	
	IF F_DateChk(s_bal_t) = -1 THEN
		F_MessageChk(21,'[발행일자]')
		this.SetItem(Row, "balname_t", snull)
		Return 1
	END IF
END IF


end event

event itemerror;return 1
end event

type dw_cust from datawindow within w_kfia13
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 978
integer y = 48
integer width = 1737
integer height = 80
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_kfia132"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

dw_cust.AcceptText()

IF this.GetColumnName() = "kfz10ot0_saup_no"  THEN
	lstr_custom.code = trim(dw_cust.GetItemString(dw_cust.GetRow(), "kfz10ot0_saup_no"))
   lstr_custom.name = dw_cust.GetItemString(dw_cust.GetRow(), "custname")
  
   IF IsNull(lstr_custom.code) then
      lstr_custom.code = ""
   end if
  
	lstr_account.gbn1 = '1'
   OpenWithParm(w_kfz04om0_popup1,'1')
	
	   dw_cust.SetItem(dw_cust.GetRow(), "kfz10ot0_saup_no", lstr_custom.code)
	   dw_cust.SetItem(dw_cust.Getrow(), "custname", lstr_custom.name)

ELSEIF this.GetColumnName() = "esaup"  THEN
	lstr_custom.code = trim(dw_cust.GetItemString(dw_cust.GetRow(), "esaup"))
   lstr_custom.name = dw_cust.GetItemString(dw_cust.GetRow(), "ecustname")
  
   IF IsNull(lstr_custom.code) then
      lstr_custom.code = ""
   end if
  
	lstr_account.gbn1 = '1'
   OpenWithParm(w_kfz04om0_popup1,'1')
	
	   dw_cust.SetItem(dw_cust.GetRow(), "esaup", lstr_custom.code)
	   dw_cust.SetItem(dw_cust.Getrow(), "ecustname", lstr_custom.name)

END IF

//dw_cust.SetFocus()
//dw_cust.Setcolumn("esaup")
end event

event itemchanged;string   scust1, cust_NM1, snull

SetNull(snull)

IF dwo.name = "kfz10ot0_saup_no" THEN
	scust1 = This.GetText()
	
	IF IsNull(scust1) OR sCust1 = "" then
		dw_cust.SetItem(dw_cust.GetRow(),"custname",snull)
		Return 
	END IF

	SELECT "KFZ04OM0_V1"."PERSON_NM"      INTO :cust_nm1  
	   FROM "KFZ04OM0_V1"  
   	WHERE "KFZ04OM0_V1"."PERSON_CD" = :scust1   ;
	if sqlca.sqlcode <> 0 then 
//		F_MessageChk(20,'[거래처]')
//		this.SetItem(row, "kfz10ot0_saup_no", snull)
//		dw_cust.Setcolumn("kfz10ot0_saup_no")
//		dw_cust.SetFocus()
//		Return 1
	else
		dw_cust.SetItem(dw_cust.GetRow(),"custname",cust_nm1)
	end if
ELSEIF dwo.name = "esaup" THEN
	scust1 = This.GetText()
	
	IF IsNull(scust1) OR sCust1 = "" then
		dw_cust.SetItem(dw_cust.GetRow(),"ecustname",snull)
		Return 
	END IF

	SELECT "KFZ04OM0_V1"."PERSON_NM"      INTO :cust_nm1  
	   FROM "KFZ04OM0_V1"  
   	WHERE "KFZ04OM0_V1"."PERSON_CD" = :scust1   ;
	if sqlca.sqlcode <> 0 then 
//		F_MessageChk(20,'[거래처]')
//		this.SetItem(row, "kfz10ot0_saup_no", snull)
//		dw_cust.Setcolumn("kfz10ot0_saup_no")
//		dw_cust.SetFocus()
//		Return 1
	else
		dw_cust.SetItem(dw_cust.GetRow(),"ecustname",cust_nm1)
	end if
	
//else
//	return 1
END IF




end event

event itemerror;return 1
end event

event getfocus;this.AcceptText()
end event

type rr_1 from roundrectangle within w_kfia13
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 20
integer width = 2743
integer height = 288
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfia13
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 328
integer width = 4608
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

