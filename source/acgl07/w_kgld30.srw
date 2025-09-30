$PBExportHeader$w_kgld30.srw
$PBExportComments$발행부서별전표명세서 조회 출력
forward
global type w_kgld30 from w_standard_print
end type
type rb_1 from radiobutton within w_kgld30
end type
type rb_2 from radiobutton within w_kgld30
end type
type rb_sung from radiobutton within w_kgld30
end type
type rb_mi from radiobutton within w_kgld30
end type
type rb_all from radiobutton within w_kgld30
end type
type gb_2 from groupbox within w_kgld30
end type
type rr_2 from roundrectangle within w_kgld30
end type
type gb_1 from groupbox within w_kgld30
end type
end forward

global type w_kgld30 from w_standard_print
integer x = 0
integer y = 0
string title = "발행부서별 전표명세서 조회"
rb_1 rb_1
rb_2 rb_2
rb_sung rb_sung
rb_mi rb_mi
rb_all rb_all
gb_2 gb_2
rr_2 rr_2
gb_1 gb_1
end type
global w_kgld30 w_kgld30

forward prototypes
public function integer wf_retrieve ()
public function integer wf_data_chk (string scolname, string scolvalue)
end prototypes

public function integer wf_retrieve ();string sSaupj, sacc_ymd, eacc_ymd, sdept, sgb,sawon,sUpmuGu
string acc_fr, acc_to, acc1_fr, acc1_to, acc2_fr, acc2_to

dw_ip.AcceptText()

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

sacc_ymd =dw_ip.GetItemString(1,"k_symd")
sacc_ymd = Trim(sacc_ymd)                
IF sAcc_Ymd = "" OR IsNull(sAcc_Ymd) THEN
	F_MessageChk(1,'[작성일자]')
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	Return 1
END IF

eacc_ymd =dw_ip.GetItemString(1,"k_eymd")
eacc_ymd = Trim(eacc_ymd)                
IF eAcc_Ymd = "" OR IsNull(eAcc_Ymd) THEN
	F_MessageChk(1,'[작성일자]')
	dw_ip.SetColumn("k_eymd")
	dw_ip.SetFocus()
	Return 1
END IF

//날짜범위 체크
if long(sacc_ymd) > long(eacc_ymd) then
	f_messagechk(24,"")
	dw_ip.SetColumn("k_symd")
	dw_ip.SetFocus()
	return 1
end if	

sawon = dw_ip.GetItemString(1,"sawon")
sawon = Trim(sawon)
IF sawon = "" OR IsNull(sawon) THEN sawon = "%"

sUpmuGu = Trim(dw_ip.GetItemString(1,"upmu_gu"))
IF sUpmuGu = "" OR IsNull(sUpmuGu) THEN sUpmuGu = "%"

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
	acc_to ="8999999"
END IF

//출력구분
IF rb_sung.checked = True THEN
	sgb = "Y%"
ELSEIF rb_mi.checked = True THEN
	sgb = "N%"
ELSE
	sgb = "%"
END IF

setpointer(hourglass!)

if rb_1.checked = true then
  if dw_print.retrieve(sabu_f, sabu_t, sdept, sacc_ymd, eacc_ymd, acc_fr, acc_to, sgb, sawon, sUpmuGu) <= 0 then
	  messagebox("확인","조회한 자료가 없습니다.!!") 
	  return -1
  end if 
else
  if dw_print.retrieve(sabu_f, sabu_t, sdept, sacc_ymd, eacc_ymd, acc_fr, acc_to, sgb, sawon, sUpmuGu) <= 0 then
	  messagebox("확인","조회한 자료가 없습니다.!!") 
	  return -1
  end if 	
end if
dw_print.sharedata(dw_list)
dw_ip.SetFocus()
setpointer(arrow!)

Return 1
end function

public function integer wf_data_chk (string scolname, string scolvalue);String snull,mysql1,sacc,ssql_gaej1,ssql_gaej2,sdate,sEmpName

SetNull(snull)

IF scolname = "sawon" THEN
	IF sColValue ="" OR IsNull(sColValue) THEN
		dw_ip.SetItem(1,"empname",snull)
		RETURN 1
	END IF
	
	sEmpName = F_Get_PersonLst('4',sColValue,'1')
	IF IsNull(sEmpName) THEN
		F_MessageChk(20,'[작성자]')
		dw_ip.SetItem(1,"sawon",snull)
		dw_ip.SetItem(1,"empname",snull)
		Return -1
	ELSE
		dw_ip.SetItem(1,"empname",sEmpName)
	END IF
END IF

IF scolname ="upmu_gu" THEN
	IF sColValue ="" OR IsNull(sColValue) THEN Return 1
	
	IF IsNull(f_Get_Refferance('AG',sColValue)) THEN
		f_messagechk(20,"전표구분")
		dw_ip.SetItem(1,"upmu_gu",snull)
		dw_ip.SetColumn("upmu_gu")
		Return -1
	END IF
END IF

IF scolname ="sacc1" THEN
//	IF sColValue = "" OR IsNull(sColValue) THEN Return 1
//	
//	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"sacc2")	

	IF sColValue ="" OR IsNull(sColValue) THEN 
		dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		RETURN 1
	END IF
//	
//	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
//    	INTO :ssql_gaej1,:ssql_gaej2
//    	FROM "KFZ01OM0"  
//   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND  
//         	( "KFZ01OM0"."ACC2_CD" = :sacc ) ;
//				
//	IF SQLCA.SQLCODE = 0 THEN
//		dw_ip.SetItem(1,"saccname",ssql_gaej1+' - '+ssql_gaej2)
//	ELSE
//		f_messagechk(25,"")
//		dw_ip.SetItem(1,"sacc1",snull)
//		dw_ip.SetItem(1,"sacc2",snull)
//		dw_ip.SetItem(1,"saccname",snull)
//		dw_ip.SetColumn("sacc1")
//		dw_ip.Setfocus()
//		RETURN -1
ELSEIF scolname ="sacc2" THEN
	IF sColValue = "" OR IsNull(sColValue) THEN Return 1
	
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"sacc1")	
	
	IF sacc ="" OR IsNull(sacc) THEN 
		dw_ip.SetItem(1,"sacc1",snull)
		dw_ip.SetItem(1,"sacc2",snull)
		dw_ip.SetItem(1,"saccname",snull)
		RETURN 1
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
//		RETURN -1
	END IF
	
ELSEIF scolname ="eacc1" THEN
//	IF sColValue = "" OR IsNull(sColValue) THEN Return 1
//	
//	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"eacc2")	
//
	IF sColValue ="" OR IsNull(sColValue) THEN 
		dw_ip.SetItem(1,"eacc1",snull)
		dw_ip.SetItem(1,"eacc2",snull)
		dw_ip.SetItem(1,"eaccname",snull)
		RETURN 1
	END IF
//	
//	SELECT "KFZ01OM0"."ACC1_NM","KFZ01OM0"."ACC2_NM"
//    	INTO :ssql_gaej1,:ssql_gaej2
//    	FROM "KFZ01OM0"  
//   	WHERE ( "KFZ01OM0"."ACC1_CD" = :scolvalue) AND  
//         	( "KFZ01OM0"."ACC2_CD" = :sacc ) ;
//				
//	IF SQLCA.SQLCODE = 0 THEN
//		dw_ip.SetItem(1,"eaccname",ssql_gaej1+' - '+ssql_gaej2)
//	ELSE
//		f_messagechk(25,"")
//		dw_ip.SetItem(1,"eacc1",snull)
//		dw_ip.SetItem(1,"eacc2",snull)
//		dw_ip.SetItem(1,"eaccname",snull)
//		dw_ip.SetColumn("eacc1")
//		dw_ip.Setfocus()
//		RETURN -1
//	END IF
ELSEIF scolname ="eacc2" THEN
	IF sColValue = "" OR IsNull(sColValue) THEN Return 1
	
	sacc =dw_ip.GetItemString(dw_ip.GetRow(),"eacc1")	
	
	IF sacc ="" OR IsNull(sacc) THEN 
		dw_ip.SetItem(1,"eacc1",snull)
		dw_ip.SetItem(1,"eacc2",snull)
		dw_ip.SetItem(1,"eaccname",snull)
		RETURN 1
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
//		RETURN -1
	END IF
END IF

IF scolname ="k_symd" THEN
	sdate = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"k_symd"))
	IF sDate = "" OR IsNull(sDate) THEN Return 1
	
	IF f_datechk(sDate) = -1 THEN
		F_MessageChk(21,'[작성일자]')
		dw_ip.SetColumn("k_symd")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF
IF scolname ="k_eymd" THEN
	sdate = Trim(dw_ip.GetItemString(dw_ip.GetRow(),"k_eymd"))
	IF sDate = "" OR IsNull(sDate) THEN Return 1
	
	IF f_datechk(sDate) = -1 THEN
		F_MessageChk(21,'[작성일자]')
		dw_ip.SetColumn("k_eymd")
		dw_ip.SetFocus()
		Return -1
	END IF	
END IF

Return 1
end function

on w_kgld30.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_sung=create rb_sung
this.rb_mi=create rb_mi
this.rb_all=create rb_all
this.gb_2=create gb_2
this.rr_2=create rr_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_sung
this.Control[iCurrent+4]=this.rb_mi
this.Control[iCurrent+5]=this.rb_all
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_kgld30.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_sung)
destroy(this.rb_mi)
destroy(this.rb_all)
destroy(this.gb_2)
destroy(this.rr_2)
destroy(this.gb_1)
end on

event open;call super::open;
dw_ip.SetItem(1,"k_symd", left(f_today(), 6) +"01")
dw_ip.SetItem(1,"k_eymd", f_today())
dw_ip.SetItem(1,"saupj", gs_saupj)
dw_ip.SetItem(1,"dept_cd", gs_dept)

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/
	dw_ip.SetItem(dw_ip.GetRow(),"dept_cd",    Gs_Dept)
	
	dw_ip.Modify("dept_cd.protect = 1")
	dw_ip.Modify("dept_cd.background.color ='"+String(RGB(192,192,192))+"'")
ELSE
	dw_ip.Modify("dept_cd.protect = 0")
	dw_ip.Modify("dept_cd.background.color ='"+String(RGB(255,255,255))+"'")
END IF
end event

type p_preview from w_standard_print`p_preview within w_kgld30
string picturename = "c:\erpman\image\미리보기_d.gif"
end type

type p_exit from w_standard_print`p_exit within w_kgld30
string picturename = "c:\erpman\image\닫기_up.gif"
end type

type p_print from w_standard_print`p_print within w_kgld30
string picturename = "c:\erpman\image\인쇄_d.gif"
end type

type p_retrieve from w_standard_print`p_retrieve within w_kgld30
string picturename = "c:\erpman\image\조회_up.gif"
end type







type st_10 from w_standard_print`st_10 within w_kgld30
end type



type dw_print from w_standard_print`dw_print within w_kgld30
integer x = 4288
integer y = 180
string dataobject = "dw_kgld302_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgld30
integer x = 59
integer y = 24
integer width = 2971
integer height = 304
string dataobject = "dw_kgld301"
end type

event dw_ip::rbuttondown;SetNull(lstr_account.acc1_cd)
SetNull(lstr_account.acc2_cd)
SetNull(lstr_custom.code)
SetNull(lstr_account.acc1_nm)
SetNull(lstr_account.acc2_nm)
SetNull(lstr_custom.name)

IF this.GetColumnName() <>"sacc1" AND this.GetColumnName() <>"sacc2" and this.GetColumnName() <>"eacc1" and this.GetColumnName() <>"eacc2" and this.GetColumnName() <>"sawon" THEN RETURN

dw_ip.AcceptText()

IF this.GetColumnName() = "sawon" THEN
	
	OpenWithParm(W_KFZ04OM0_POPUP,'4')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	dw_ip.SetItem(dw_ip.GetRow(),"sawon", lstr_custom.code)
	dw_ip.SetItem(dw_ip.GetRow(),"empname",lstr_custom.name)
	
ELSEIF this.GetColumnName() = "sacc1" THEN
	
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
	IF this.GetColumnName() = "sacc1" THEN
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
	
	Open(W_KFZ01OM0_POPUP)
	IF this.GetColumnName() = "eacc1" THEN 
		dw_ip.SetItem(dw_ip.GetRow(), "eacc1", lstr_account.acc1_cd)
		dw_ip.SetItem(dw_ip.GetRow(), "eacc2", lstr_account.acc2_cd)
		dw_ip.SetItem(dw_ip.Getrow(),"eaccname",lstr_account.acc1_nm+" - "+lstr_account.acc2_nm)
	END IF
	
END IF

dw_ip.SetFocus()
end event

event dw_ip::itemchanged;IF WF_DATA_CHK(dwo.name,data) = -1 THEN RETURN 1
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::losefocus;call super::losefocus;dw_ip.AcceptText()
end event

event dw_ip::ue_key;call super::ue_key;//IF keydown(keytab!) THEN
//	TriggerEvent(RbuttonDown!)
//END IF
end event

type dw_list from w_standard_print`dw_list within w_kgld30
integer x = 69
integer width = 4549
string title = "발행부서별 거래품의서조회"
string dataobject = "dw_kgld302"
boolean border = false
end type

type rb_1 from radiobutton within w_kgld30
integer x = 3077
integer y = 228
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "계정별"
boolean checked = true
end type

event clicked;//dw_rtv.SetRedraw(False)
//dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN
	dw_list.dataObject='dw_kgld302'
	dw_print.dataObject='dw_kgld302_p'
END IF

dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_print.object.datawindow.print.preview = "yes"
end event

type rb_2 from radiobutton within w_kgld30
integer x = 3575
integer y = 228
integer width = 265
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전표별"
end type

event clicked;//dw_rtv.SetRedraw(False)
//dw_list.SetRedraw(False)
IF rb_2.Checked =True THEN
	dw_list.dataObject='dw_kgld303'
	dw_print.dataObject='dw_kgld303_p'
END IF

dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_print.object.datawindow.print.preview = "yes"
end event

type rb_sung from radiobutton within w_kgld30
integer x = 3077
integer y = 68
integer width = 215
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "승인"
end type

type rb_mi from radiobutton within w_kgld30
integer x = 3328
integer y = 68
integer width = 261
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "미승인"
end type

type rb_all from radiobutton within w_kgld30
integer x = 3639
integer y = 68
integer width = 215
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체"
boolean checked = true
end type

type gb_2 from groupbox within w_kgld30
integer x = 3031
integer y = 12
integer width = 869
integer height = 136
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "출력구분"
borderstyle borderstyle = styleraised!
end type

type rr_2 from roundrectangle within w_kgld30
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 332
integer width = 4567
integer height = 1928
integer cornerheight = 40
integer cornerwidth = 55
end type

type gb_1 from groupbox within w_kgld30
integer x = 3031
integer y = 184
integer width = 864
integer height = 128
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "출력선택"
borderstyle borderstyle = styleraised!
end type

