$PBExportHeader$w_kfia02a.srw
$PBExportComments$받을어음 조회 출력
forward
global type w_kfia02a from w_standard_print
end type
type rr_1 from roundrectangle within w_kfia02a
end type
end forward

global type w_kfia02a from w_standard_print
integer x = 0
integer y = 0
string title = "받을어음 조회 출력"
rr_1 rr_1
end type
global w_kfia02a w_kfia02a

type variables
String scustf,scustt,sdatef,sdatet,schdatef,schdatet,sstatus,scustfnm,scusttnm,sstatus_name
end variables

forward prototypes
public function integer wf_chk_cond ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_chk_cond ();String snull

SetNull(snull)

dw_ip.AcceptText()

sabu_f = dw_ip.GetItemString(dw_ip.Getrow(), 'saupj')
sabu_t = dw_ip.GetItemString(dw_ip.Getrow(), 'saupj')

scustf =dw_ip.GetItemString(dw_ip.Getrow(),"custf")
scustt =dw_ip.GetItemString(dw_ip.Getrow(),"custt")

sdatef =dw_ip.GetItemString(dw_ip.Getrow(),"datef")
sdatet =dw_ip.GetItemString(dw_ip.Getrow(),"datet")

schdatef = dw_ip.GetitemString(dw_ip.Getrow(),"chdatef")
schdatet = dw_ip.GetitemString(dw_ip.Getrow(),"chdatet")
if schdatef = '' or IsNull(sChdateF) then sChdateF = '00000000'
if schdateT = '' or IsNull(sChdateT) then sChdateT = '99999999'

If sabu_f = "" or Isnull(sabu_f) Then
	sabu_f = '1'
	sabu_t = '98'
End If

SELECT "KFZ04OM0"."PERSON_NM"
   INTO :scustfnm
   FROM "KFZ04OM0"  
   WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) AND
			( "KFZ04OM0"."PERSON_CD" = :scustf) ;
			
SELECT "KFZ04OM0"."PERSON_NM"
   INTO :scusttnm
   FROM "KFZ04OM0"  
   WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) AND
			( "KFZ04OM0"."PERSON_CD" = :scustt) ;
			
IF scustf > scustt THEN
	MessageBox("확  인","거래처 범위가 잘못 지정되었습니다. 확인하세요.!!!")
	Return -1
END IF

IF DaysAfter(Date(Left(sdatef,4)+"/"+Mid(sdatef,5,2)+"/"+Right(sdatef,2)),&
				 Date(Left(sdatet,4)+"/"+Mid(sdatet,5,2)+"/"+Right(sdatet,2))) < 0 THEN
	MessageBox("확  인","날짜 범위가 잘못 지정되었습니다. 확인하세요.!!!")
	dw_ip.SetColumn("datet")
	dw_ip.SetFocus()
	Return -1
END IF

IF DaysAfter(Date(Left(schdatef,4)+"/"+Mid(schdatef,5,2)+"/"+Right(schdatef,2)),&
				 Date(Left(schdatet,4)+"/"+Mid(schdatet,5,2)+"/"+Right(schdatet,2))) < 0 THEN
	MessageBox("확  인","날짜 범위가 잘못 지정되었습니다. 확인하세요.!!!")
	dw_ip.SetColumn("chdatet")
	dw_ip.SetFocus()
	Return -1
END IF

Return 1

end function

public function integer wf_retrieve ();Int ll_retrow
String sGbn,sGetSqlSyntax

IF dw_ip.AcceptText() = -1 THEN RETURN -1

IF wf_chk_cond() = -1 THEN RETURN -1

sGbn = dw_ip.GetItemString(dw_ip.GetRow(),"gubun")

IF dw_ip.GetItemString(1,"status1") = '0' AND dw_ip.GetItemString(1,"status2") = '0' AND &
	dw_ip.GetItemString(1,"status3") = '0' AND dw_ip.GetItemString(1,"status4") = '0' AND &
	dw_ip.GetItemString(1,"status5") = '0' AND dw_ip.GetItemString(1,"status6") = '0' AND &
	dw_ip.GetItemString(1,"status7") = '0' AND dw_ip.GetItemString(1,"status8") = '0' then
	F_MessageChk(1,'[어음상태]')
	Return -1
END IF

IF sGbn = '1' THEN
	dw_list.Title ="만기일자별 어음번호순"
	dw_list.DataObject ="d_kfia02a"
	dw_print.DataObject ="d_kfia02a_p"
ELSEIF sGbn = '2' THEN
	dw_list.Title ="거래처별 만기일자순"
	dw_list.DataObject ="d_kfia02a_0"
	dw_print.DataObject ="d_kfia02a_0_p"
//ELSEIF sGbn = '3' THEN	
//	dw_list.Title ="받을어음 미결제분"
//	dw_list.DataObject ="d_kfia02a_2"
//	dw_print.DataObject ="d_kfia02a_2_p"
ELSEIF sGbn = '4' THEN
	dw_list.Title ="만기일자별 어음번호순"
	dw_list.DataObject ="d_kfia02a_3"
	dw_print.DataObject ="d_kfia02a_3_p"
END IF

dw_print.SetTransObject(Sqlca)
dw_print.Reset()

sGetSqlSynTax = dw_print.GetSqlSelect()

sGetSqlSynTax = sGetSqlSyntax + " and " +&
                " ((kfm02ot0.owner_saupj >= '" + sabu_f + "' ) and " +&
					 "  (kfm02ot0.owner_saupj <= '" + sabu_t + "' )) and " + &
					 " ((kfm02ot0.saup_no >= '" + scustf + "' ) and "  + &
					 " (kfm02ot0.saup_no <= '" + scustt + "' )) and " + & 
         		 " (((kfm02ot0.bman_dat >= '" + sdatef + "' ) and " + &
         		 "	  (kfm02ot0.bman_dat <= '" + sdatet + "' )) or " + &
          		 " ((nvl(kfm02ot0.bill_change_date,'00000000') >= '" + schdatef + "' ) and " + &
         		 "	 (nvl(kfm02ot0.bill_change_date,'99999999') <= '" + schdatet + "' ))) and "

sGetSqlSynTax = sGetSqlSynTax + " ("
IF dw_ip.GetItemString(1,"status1") = '1' THEN
	sGetSqlSyntax = sGetSqlSyntax + "(kfm02ot0.status = '" + "1" + "') or" 
END IF
IF dw_ip.GetItemString(1,"status2") = '1' THEN
	sGetSqlSyntax = sGetSqlSyntax + "(kfm02ot0.status = '" + "2" + "') or" 
END IF
IF dw_ip.GetItemString(1,"status3") = '1' THEN
	sGetSqlSyntax = sGetSqlSyntax + "(kfm02ot0.status = '" + "3" + "') or" 
END IF
IF dw_ip.GetItemString(1,"status4") = '1' THEN
	sGetSqlSyntax = sGetSqlSyntax + "(kfm02ot0.status = '" + "4" + "') or" 
END IF
IF dw_ip.GetItemString(1,"status5") = '1' THEN
	sGetSqlSyntax = sGetSqlSyntax + "(kfm02ot0.status = '" + "5" + "') or" 
END IF
IF dw_ip.GetItemString(1,"status6") = '1' THEN
	sGetSqlSyntax = sGetSqlSyntax + "(kfm02ot0.status = '" + "6" + "') or" 
END IF
IF dw_ip.GetItemString(1,"status8") = '1' THEN
	sGetSqlSyntax = sGetSqlSyntax + "(kfm02ot0.status = '" + "8" + "') or" 
END IF
IF dw_ip.GetItemString(1,"status7") = '1' THEN
	sGetSqlSyntax = sGetSqlSyntax + "(kfm02ot0.status = '" + "9" + "') or" 
END IF

sGetSqlSyntax = Left(sGetSqlSyntax, Len(sGetSqlSyntax) - 2) + ')'

dw_print.SetSqlSelect(sGetSqlSyntax)
dw_list.SetTransObject(SQLCA)

ll_retrow = dw_print.Retrieve(sabu_f,sabu_t,scustf,scustt,sdatef,sdatet,schdatef,schdatet,sstatus,scustfnm,scusttnm,sstatus_name) 

IF ll_retrow <=0 THEN
	f_messagechk(14,"")
	Return -1
END IF

dw_print.sharedata(dw_list)

Return 1
end function

on w_kfia02a.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfia02a.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String scust_min,scust_max

SELECT MIN("KFZ04OM0"."PERSON_CD"),MAX("KFZ04OM0"."PERSON_CD")  
   INTO :scust_min,:scust_max
   FROM "KFZ04OM0"  
   WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) ;

dw_list.SetTransObject(SQLCA)

dw_ip.SetItem(dw_ip.GetRow(),'saupj', Gs_Saupj)				
dw_ip.SetItem(dw_ip.GetRow(),"custf",scust_min)
dw_ip.SetItem(dw_ip.Getrow(),"custt",scust_max)
dw_ip.SetItem(dw_ip.GetRow(),"datef",Left(f_today(),6)+'01')
dw_ip.SetItem(dw_ip.GetRow(),"datet",f_today())
dw_ip.SetItem(dw_ip.GetRow(),"chdatef",Left(f_today(),6)+'01')
dw_ip.SetItem(dw_ip.GetRow(),"chdatet",f_today())

IF f_Authority_Fund_Chk(Gs_Dept) = -1 THEN
	dw_ip.Modify('saupj.protect = 1')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(192,192,192))+"'") 
Else
	dw_ip.Modify('saupj.protect = 0')
//	dw_ip.Modify("saupj.BackGround.Color = '"+String(Rgb(255,255,255))+"'")  //MINT COLOR
End if

dw_ip.SetColumn("saupj")
dw_ip.Setfocus()
end event

type p_preview from w_standard_print`p_preview within w_kfia02a
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kfia02a
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kfia02a
string pointer = ""
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfia02a
string pointer = ""
end type



type sle_msg from w_standard_print`sle_msg within w_kfia02a
boolean enabled = false
end type



type st_10 from w_standard_print`st_10 within w_kfia02a
end type



type dw_print from w_standard_print`dw_print within w_kfia02a
integer x = 3602
integer width = 256
integer height = 224
string dataobject = "d_kfia02a_p"
boolean border = false
end type

type dw_ip from w_standard_print`dw_ip within w_kfia02a
integer x = 37
integer y = 0
integer width = 3451
integer height = 364
string dataobject = "d_kfia02a_1"
end type

event dw_ip::itemerror;Return 1
end event

event dw_ip::itemchanged;String snull,sacc1,sacc2,sgubun

SetNull(snull)
sle_msg.text =""

IF dwo.name ="custf" THEN
	SELECT "KFZ04OM0"."PERSON_NM"
   	INTO :scustfnm
   	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) AND
				( "KFZ04OM0"."PERSON_CD" = :data) ;

	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"거래처") 
//		dw_ip.SetItem(dw_ip.GetRow(),"custf",snull)
//		Return 1
	ELSE
		dw_ip.SetItem(dw_ip.GetRow(),"custf_1",scustfnm)
	END IF
END IF

IF dwo.name ="custt" THEN
	SELECT "KFZ04OM0"."PERSON_NM"
   	INTO :scusttnm
   	FROM "KFZ04OM0"  
   	WHERE ( "KFZ04OM0"."PERSON_GU" = '1' ) AND
				( "KFZ04OM0"."PERSON_CD" = :data) ;

	IF SQLCA.SQLCODE <> 0 THEN
//		f_messagechk(20,"거래처")
//		dw_ip.SetItem(dw_ip.GetRow(),"custt",snull)
//		Return 1
	ELSE
		dw_ip.SetItem(dw_ip.GetRow(),"custt_1",scusttnm)
	END IF
END IF

IF dwo.name ="datef" THEN
	
	IF f_datechk(data) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datef",snull)
		Return 1
	END IF
END IF

IF dwo.name ="datet" THEN
	
	IF f_datechk(data) = -1 THEN 
		f_messagechk(20,"날짜")
		dw_ip.SetItem(dw_ip.Getrow(),"datet",snull)
		Return 1
	END IF
END IF

IF dwo.name ="gubun" THEN
	dw_ip.SetRedraw(False)
	IF data ='1' THEN
		dw_list.Title ="만기일자별 어음번호순"
		dw_list.DataObject ="d_kfia02a"
	ELSEIF data ='2' THEN
		dw_list.Title ="거래처별 만기일자순"
		dw_list.DataObject ="d_kfia02a_0"
//	ELSEIF data ='3' THEN
//		dw_list.Title ="받을어음 미결제분"
//		dw_list.DataObject ="d_kfia02a_2"
	ELSEIF data ='4' THEN
		dw_list.Title ="만기일자별 어음번호순"
		dw_list.DataObject ="d_kfia02a_3"
	ELSE
		MessageBox("확 인","출력구분을 입력하시요.!!")
		Return 1
	END IF
	dw_ip.SetRedraw(True)
	dw_list.SetTransObject(SQLCA)
END IF


end event

event dw_ip::rbuttondown;String snull

SetNull(snull)
SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

this.accepttext()

IF this.GetColumnName() ="custf" THEN
	lstr_custom.code =dw_ip.GetItemString(1,"custf")

	IF IsNull(lstr_custom.code) then
   	lstr_custom.code = ""
	end if

	OpenWithParm(w_kfz04om0_popup1,'1')
	
	IF Not IsNull(lstr_custom.code) THEN
		dw_ip.SetItem(1,"custf",lstr_custom.code)
	END IF
END IF

IF this.GetColumnName() ="custt" THEN
	lstr_custom.code =dw_ip.GetItemString(1,"custt")

	IF IsNull(lstr_custom.code) then
   	lstr_custom.code = ""
	end if
	
	OpenWithParm(w_kfz04om0_popup1,'1')
	
	IF Not IsNull(lstr_custom.code) THEN
		dw_ip.SetItem(1,"custt",lstr_custom.code)
	END IF
END IF

end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfia02a
integer x = 59
integer y = 380
integer width = 4544
integer height = 1952
string dataobject = "d_kfia02a"
boolean border = false
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_kfia02a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 368
integer width = 4585
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

