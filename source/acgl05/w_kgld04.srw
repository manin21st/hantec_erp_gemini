$PBExportHeader$w_kgld04.srw
$PBExportComments$총계정원장 조회출력
forward
global type w_kgld04 from w_standard_print
end type
type rb_1 from radiobutton within w_kgld04
end type
type rb_2 from radiobutton within w_kgld04
end type
type rb_3 from radiobutton within w_kgld04
end type
type rb_4 from radiobutton within w_kgld04
end type
type gb_1 from groupbox within w_kgld04
end type
type rr_1 from roundrectangle within w_kgld04
end type
type rr_2 from roundrectangle within w_kgld04
end type
type gb_2 from groupbox within w_kgld04
end type
type gb_3 from groupbox within w_kgld04
end type
end forward

global type w_kgld04 from w_standard_print
integer height = 2400
string title = "총계정원장 조회 출력"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
gb_1 gb_1
rr_1 rr_1
rr_2 rr_2
gb_2 gb_2
gb_3 gb_3
end type
global w_kgld04 w_kgld04

forward prototypes
public function integer wf_retrieve ()
public function integer wf_data_chk (string scolname, string scolvalue)
end prototypes

public function integer wf_retrieve ();String symd_text, eymd_text, saup_text, ref_saup    
string sacc_ymd, eacc_ymd
string syy, smm, sdd, eyy, emm, edd                 
string acc_fr, acc_to, acc1_fr, acc1_to, acc2_fr, acc2_to
string sabu_z,sYearMonth

dw_ip.AcceptText()

sacc_ymd = Trim(dw_ip.GetItemString(1,"k_symd"))
IF sAcc_Ymd = "" OR IsNull(sAcc_Ymd) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(sacc_ymd) = -1 THEN
		f_messagechk(23, "")
		dw_ip.SetColumn("k_symd")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

eacc_ymd = Trim(dw_ip.GetItemString(1,"k_eymd"))
IF eAcc_Ymd = "" OR IsNull(eAcc_Ymd) THEN
	F_MessageChk(1,'[회계일자]')
	dw_ip.SetColumn("k_eymd")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(eacc_ymd) = -1 THEN
		f_messagechk( 23, "")
		dw_ip.SetColumn("k_eymd")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

if long(sacc_ymd) > long(eacc_ymd) then
	f_messagechk(24,"")
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	return -1
end if	

//날짜 출력물 헤드에 modify
syy = left(sacc_ymd, 4)
smm = mid(sacc_ymd,5,2)
sdd = right(sacc_ymd,2)
symd_text = syy + '.'+ smm + '.' + sdd
sYearMonth = left(sacc_ymd,6)

dw_print.modify("symd.text ='"+symd_text+"'")

eyy = left(eacc_ymd, 4)
emm = mid(eacc_ymd,5,2)
edd = right(eacc_ymd,2)
eymd_text = eyy + '.'+ emm + '.' + edd
dw_print.modify("eymd.text ='"+eymd_text+"'")

//사업장 헤드에 modify
saup_text =Trim(dw_ip.GetItemString(1,"saupj"))

IF saup_text ="" OR IsNull(saup_text) OR saup_text ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
	saup_text ="99"
END IF

SELECT "REFFPF"."RFNA1"      INTO :ref_saup  
	FROM "REFFPF"  
	WHERE "REFFPF"."RFCOD" = 'AD'   AND "REFFPF"."RFGUB" = :saup_text ;

dw_print.modify("saup.text ='"+ref_saup+"'") // 사업명 move

acc1_fr = dw_ip.GetItemString(1,"sacc1")
acc2_fr = dw_ip.GetItemString(1,"sacc2")

acc_fr = acc1_fr + acc2_fr

SELECT "KFZ01OM0"."FRACC1_CD",       "KFZ01OM0"."FRACC2_CD",
		 "KFZ01OM0"."TOACC1_CD",       "KFZ01OM0"."TOACC2_CD"  
	INTO :acc1_fr,   				       :acc2_fr,
   	  :acc1_to,  				       :acc2_to   
   FROM "KFZ01OM0" 
	WHERE "KFZ01OM0"."ACC1_CD"||"KFZ01OM0"."ACC2_CD" = :acc_fr;

acc_fr = acc1_fr + acc2_fr
acc_to = acc1_to + acc2_to
 
IF acc_fr ="" OR IsNull(acc_fr) THEN	//계정코드from이 없으면 처음부터 
	acc_fr ="1000000"
END IF

IF acc_to ="" OR IsNull(acc_to) THEN	//계정코드to가 없으면 끝까지
	acc_to ="9999999"
END IF

IF sabu_f ="10" and sabu_t ="98" then 
	sabu_z = "99"
ELSE
	sabu_z = sabu_f
END IF

setpointer(hourglass!)

if dw_print.retrieve(sabu_z,syy,acc_fr,acc_to,sabu_f,sabu_t,sacc_ymd,eacc_ymd) <= 0 then
	messagebox("확인","조회한 자료가 없습니다.!!") 
	dw_print.insertrow(0)
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
         	( "KFZ01OM0"."ACC2_CD" = :sacc ) ;
				
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"saccname",ssql_gaej1+' - '+ssql_gaej2)
	ELSE
//   	f_Messagechk(25,"[계정과목]")
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
         	( "KFZ01OM0"."ACC2_CD" = :scolvalue );
	IF SQLCA.SQLCODE = 0 THEN
		dw_ip.SetItem(1,"saccname",ssql_gaej1+' - '+ssql_gaej2)
	ELSE
//   	f_Messagechk(25,"[계정과목]")
	   dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		dw_ip.SetColumn("sacc1")
		dw_ip.SetFocus()
      Return -1
	END IF

END IF
Return 1
end function

on w_kgld04.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.gb_3
end on

on w_kgld04.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;
dw_ip.SetItem(1,"k_symd",Left(f_today(),6)+'01')
dw_ip.SetItem(1,"k_eymd",f_today())

dw_ip.SetItem(1,"saupj", gs_saupj)

end event

type p_preview from w_standard_print`p_preview within w_kgld04
integer taborder = 50
end type

type p_exit from w_standard_print`p_exit within w_kgld04
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_kgld04
integer taborder = 60
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld04
integer taborder = 30
end type







type st_10 from w_standard_print`st_10 within w_kgld04
end type



type dw_print from w_standard_print`dw_print within w_kgld04
string dataobject = "dw_kgld042_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld04
integer y = 32
integer width = 1614
integer height = 324
string dataobject = "dw_kgld041"
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
	
	if rb_3.checked = true then 
		Open(W_KFZ01OM0_POPUP3)
	elseif rb_4.checked = true then 
		Open(W_KFZ01OM0_POPUP)
	end if
	
	dw_ip.SetItem(dw_ip.GetRow(), "sacc1", lstr_account.acc1_cd)
	dw_ip.SetItem(dw_ip.GetRow(), "sacc2", lstr_account.acc2_cd)
	dw_ip.SetItem(dw_ip.Getrow(),"saccname",lstr_account.acc1_nm+" - "+lstr_account.acc2_nm)
END IF

dw_ip.SetFocus()
end event

event dw_ip::itemchanged;IF WF_DATA_CHK(dwo.name,data) = -1 THEN RETURN 2
end event

event dw_ip::itemerror;call super::itemerror;//return 1
end event

event dw_ip::losefocus;call super::losefocus;dw_ip.AcceptText()
end event

event dw_ip::ue_key;call super::ue_key;//IF keydown(keytab!) THEN
//	TriggerEvent(RbuttonDown!)
//END IF
end event

type dw_list from w_standard_print`dw_list within w_kgld04
integer x = 64
integer y = 376
integer width = 4535
integer height = 1880
integer taborder = 40
string title = "총계정원장"
string dataobject = "dw_kgld042"
boolean border = false
end type

type rb_1 from radiobutton within w_kgld04
integer x = 2354
integer y = 140
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "일반"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.SetRedraw(False)
IF rb_3.Checked =True THEN
	dw_list.dataObject='dw_kgld042'
	dw_print.dataObject='dw_kgld042_p'
	dw_list.title ="계정과목 원장"
else 
	dw_list.dataObject='dw_kgld043'
	dw_print.dataObject='dw_kgld043_p'
	dw_list.title ="계정세목 원장"
END IF
dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rb_2 from radiobutton within w_kgld04
integer x = 2354
integer y = 212
integer width = 384
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "Dot Printer"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.SetRedraw(False)
IF rb_3.Checked =True THEN
	dw_list.dataObject='dw_kgld042_dot'
	dw_print.dataObject='dw_kgld042_dot_p'
	dw_list.title ="계정과목 원장"
else 
	dw_list.dataObject='dw_kgld043_dot'
	dw_print.dataObject='dw_kgld043_dot_p'
	dw_list.title ="계정세목 원장"
END IF

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rb_3 from radiobutton within w_kgld04
integer x = 1719
integer y = 136
integer width = 489
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "계정과목 원장"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN
	dw_list.dataObject='dw_kgld042'
	dw_print.dataObject='dw_kgld042_p'
else 
	dw_list.dataObject='dw_kgld042_dot'
	dw_print.dataObject='dw_kgld042_dot_p'
END IF
dw_list.title ="계정과목 원장"

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rb_4 from radiobutton within w_kgld04
integer x = 1719
integer y = 208
integer width = 489
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "세목 원장"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN
	dw_list.dataObject='dw_kgld043'
	dw_print.dataObject='dw_kgld043_p'
else 
	dw_list.dataObject='dw_kgld043_dot'	
	dw_print.dataObject='dw_kgld043_dot_p'	
END IF
dw_list.title ="계정세목 원장"

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type gb_1 from groupbox within w_kgld04
integer x = 1687
integer y = 56
integer width = 539
integer height = 268
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "출력구분"
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_kgld04
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1655
integer y = 32
integer width = 1193
integer height = 312
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kgld04
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 360
integer width = 4567
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

type gb_2 from groupbox within w_kgld04
integer x = 1687
integer y = 56
integer width = 539
integer height = 268
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "출력구분"
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_kgld04
integer x = 2286
integer y = 56
integer width = 530
integer height = 268
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "프린트 구분"
borderstyle borderstyle = stylelowered!
end type

