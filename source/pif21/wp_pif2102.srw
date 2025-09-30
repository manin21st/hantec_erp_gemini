$PBExportHeader$wp_pif2102.srw
$PBExportComments$** 인사 대장(사용)
forward
global type wp_pif2102 from w_standard_print
end type
type rr_2 from roundrectangle within wp_pif2102
end type
type rb_1 from radiobutton within wp_pif2102
end type
type rb_2 from radiobutton within wp_pif2102
end type
type rb_3 from radiobutton within wp_pif2102
end type
type sle_1 from singlelineedit within wp_pif2102
end type
type sle_2 from singlelineedit within wp_pif2102
end type
type st_1 from statictext within wp_pif2102
end type
type sle_name1 from singlelineedit within wp_pif2102
end type
type sle_name2 from singlelineedit within wp_pif2102
end type
type st_2 from statictext within wp_pif2102
end type
type dw_1 from datawindow within wp_pif2102
end type
type rr_1 from roundrectangle within wp_pif2102
end type
end forward

global type wp_pif2102 from w_standard_print
integer x = 0
integer y = 0
string title = "인사 대장"
rr_2 rr_2
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
sle_1 sle_1
sle_2 sle_2
st_1 st_1
sle_name1 sle_name1
sle_name2 sle_name2
st_2 st_2
dw_1 dw_1
rr_1 rr_1
end type
global wp_pif2102 wp_pif2102

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_code1, ls_code2,ls_gubun, sKunmu, sSaup, ls_fdate, ls_tdate, ls_dategbn
String GetMaxEmpno,GetMaxEmpname,GetMinEmpno,GetMinEmpname, ArgBuf, snull

SetNull(snull)

setpointer(hourglass!)

dw_ip.AcceptText()
dw_1.AcceptText()
//dw_list.reset()

ls_code1 = dw_1.GetItemString(1,"empno")
ls_code2 = dw_1.GetItemString(1,"empno2")
ls_gubun = trim(dw_ip.GetItemString(1,"jikjong"))
sKunmu = trim(dw_ip.GetItemString(1,"kunmu"))
sSaup = trim(dw_ip.GetItemString(1,"saup"))
ls_fdate = dw_ip.GetItemString(dw_ip.GetRow(), 'fdate')
ls_tdate = dw_ip.GetItemString(dw_ip.GetRow(), 'tdate')
ls_dategbn = dw_Ip.GetItemString(dw_ip.GetRow(), 'gubn')

IF ls_gubun = '' or isnull(ls_gubun) THEN
	ls_gubun = '%'
	dw_print.modify("t_jikjong.text = '"+'전체'+"'")
ELSE
	SELECT "CODENM"
     INTO :ArgBuf
     FROM "P0_REF"
    WHERE ( "CODEGBN" = 'JJ') AND
          ( "CODE" <> '00' ) AND
			 ( "CODE" = :ls_gubun);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_jikjong.text = '" + ArgBuf + "'")
END IF

IF sSaup = '' OR IsNull(sSaup) THEN
	sSaup = '%'
	dw_print.modify("t_saup.text = '"+'전체'+"'")
ELSE
	SELECT "SAUPNAME"
     INTO :ArgBuf
     FROM "P0_SAUPCD"
    WHERE ( "SAUPCODE" = :sSaup);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_saup.text = '" + ArgBuf + "'")
END IF

IF sKunmu = '' OR IsNull(sKunmu) THEN
	sKunmu = '%'
	dw_print.modify("t_kunmu.text = '"+'전체'+"'")
ELSE
	SELECT "KUNMUNAME"
     INTO :ArgBuf
     FROM "P0_KUNMU"
    WHERE ( "KUNMUGUBN" = :sKunmu);
	IF SQLCA.SQLCode = 0 THEN dw_print.modify("t_kunmu.text = '" + ArgBuf + "'")
END IF

IF isnull(ls_code1) or ls_code1 = '' THEN
	SELECT MIN(P1_MASTER.EMPNO)
	 INTO:GetMinEmpno
	 FROM P1_MASTER  ;
  
  SELECT P1_MASTER.EMPNAME
	  INTO :GetMinEmpname
	  FROM  P1_MASTER
	  WHERE P1_MASTER.EMPNO = :GetMinEmpno ;
 ls_code1 = GetMinEmpno
ELSE
    GetMinEmpname = dw_1.GetITemString(1,"empname1")
END IF

IF isnull(ls_code2) or ls_code2 = '' then 
	SELECT MAX(P1_MASTER.EMPNO)
	  INTO:GetMaxEmpno
	 FROM P1_MASTER  ;
	 
	SELECT P1_MASTER.EMPNAME
	  INTO :GetMaxEmpname
	  FROM  P1_MASTER
	  WHERE P1_MASTER.EMPNO = :GetMaxEmpno ;
	
	ls_code2 = GetMaxEmpno
ELSE
	GetMaxEmpname = dw_1.GetITemString(1,"empname2")
END IF

if ls_code1 > ls_code2 then
	messagebox("범위 확인", "입력 범위가 부정확합니다.!", information!)
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	return -1
end if

IF ls_dategbn = '' OR IsNull(ls_dategbn) THEN
	ls_dategbn = '%'
ELSE
	IF f_datechk(ls_fdate) = -1 THEN
		MessageBox("확인", "조회일자(fr)을 확인하세요.")
		dw_ip.SetItem(dw_ip.GetRow(), 'fdate', snull)
		dw_ip.SetColumn('fdate')
		dw_ip.SetFocus()
		Return 1
	END IF
	
	IF ls_fdate = '' OR IsNull(Ls_fdate) THEN
		MessageBox("확인", "조회일자(fr)을 입력하세요.")
		dw_ip.SetItem(dw_ip.GetRow(), 'fdate', snull)
		dw_ip.SetColumn('fdate')
		dw_ip.SetFocus()
		Return 1
	END IF
		
	IF f_datechk(ls_tdate) = -1 THEN
		MessageBox("확인", "조회일자(to)을 확인하세요.")
		dw_ip.SetItem(dw_ip.GetRow(), 'tdate', snull)
		dw_ip.SetColumn('tdate')
		dw_ip.SetFocus()
		Return 1
	END IF
		
	IF ls_tdate = '' OR IsNull(ls_tdate) THEN
		MessageBox("확인", "조회일자(to)을 입력하세요.")
		dw_ip.SetItem(dw_ip.GetRow(), 'fdate', snull)
		dw_ip.SetColumn('fdate')
		dw_ip.SetFocus()
		Return 1
	END IF	
		
	IF long(ls_fdate) > long(ls_tdate) THEN
		MessageBox("확인", "조회기간을 확인하세요.")
		dw_ip.SetItem(dw_ip.GetRow(), 'fdate', snull)
		dw_ip.SetColumn('fdate')
		dw_ip.SetFocus()
		Return 1
	END IF
END IF

IF dw_print.retrieve(ls_code1, ls_code2,ls_gubun, sKunmu, sSaup, ls_fdate, ls_tdate, ls_dategbn) < 1 then
	w_mdi_frame.sle_msg.text = "해당 자료가 없습니다.!"	
	dw_1.SetColumn("empno")
	dw_1.SetFocus()
	RETURN -1
END IF
dw_print.sharedata(dw_list)

dw_print.modify("startempname.text = '" + GetMinEmpname + "'")
dw_print.modify("endempname.text   = '" + GetMaxEmpname + "'")


setpointer(arrow!)
return 1
end function

on wp_pif2102.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.sle_1=create sle_1
this.sle_2=create sle_2
this.st_1=create st_1
this.sle_name1=create sle_name1
this.sle_name2=create sle_name2
this.st_2=create st_2
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.sle_1
this.Control[iCurrent+6]=this.sle_2
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.sle_name1
this.Control[iCurrent+9]=this.sle_name2
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.dw_1
this.Control[iCurrent+12]=this.rr_1
end on

on wp_pif2102.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.sle_1)
destroy(this.sle_2)
destroy(this.st_1)
destroy(this.sle_name1)
destroy(this.sle_name2)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_list.settransobject(sqlca)

dw_1.SetTransObject(sqlca)
dw_1.InsertRow(0)

dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)
dw_ip.SetItem(dw_ip.GetRow(), 'fdate', left(f_today(), 4) + '0101')
dw_ip.SetItem(dw_ip.GetRow(), 'tdate', f_today())

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd

p_retrieve.TriggerEvent(Clicked!)
end event

type p_preview from w_standard_print`p_preview within wp_pif2102
integer x = 4087
integer y = 4
end type

type p_exit from w_standard_print`p_exit within wp_pif2102
integer x = 4434
integer y = 4
end type

type p_print from w_standard_print`p_print within wp_pif2102
integer x = 4261
integer y = 4
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pif2102
integer x = 3913
integer y = 4
end type

type st_window from w_standard_print`st_window within wp_pif2102
integer y = 4000
end type

type sle_msg from w_standard_print`sle_msg within wp_pif2102
integer y = 4000
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pif2102
integer y = 4000
end type

type st_10 from w_standard_print`st_10 within wp_pif2102
integer y = 4000
end type

type gb_10 from w_standard_print`gb_10 within wp_pif2102
integer y = 4000
end type

type dw_print from w_standard_print`dw_print within wp_pif2102
string dataobject = "dp_pif2102_1_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pif2102
integer x = 55
integer y = 36
integer width = 2885
integer height = 180
integer taborder = 60
string dataobject = "dp_pif2102_4"
end type

event dw_ip::itemchanged;call super::itemchanged;string ls_fdate, ls_tdate, ls_gubn, snull
SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF


IF this.GetColumnName() = 'fdate' THEN
	ls_fdate = this.GetText()
	ls_tdate = this.GetItemString(this.GetRow(), 'tdate')
	
	IF f_datechk(ls_fdate) = -1 THEN
		MessageBox("확인", "조회일자(fr)을 확인하세요.")
		this.SetItem(this.GetRow(), 'fdate', snull)
		this.SetColumn('fdate')
		this.SetFocus()
		Return 1
	END IF
	
	IF IsNull(ls_fdate) OR ls_fdate = '' THEN
		MessageBox("확인", "조회일자(fr)을 입력하세요.")
		this.SetItem(this.GetRow(), 'fdate', snull)
		this.SetColumn('fdate')
		this.SetFocus()
		Return 1
	END IF
	
	IF long(ls_fdate) > long(ls_tdate) THEN
		MessageBox("확인", "조회기간을 확인하세요.")
		this.SetItem(this.GetRow(), 'fdate', snull)
		this.SetColumn('fdate')
		this.SetFocus()
		Return 1
	END IF
END IF


IF this.GetColumnName() = 'tdate' THEN
	ls_tdate = this.GetText()
	ls_fdate = this.GetItemString(this.GetRow(), 'fdate')
	
	IF f_datechk(ls_tdate) = -1 THEN
		MessageBox("확인", "조회일자(to)을 확인하세요.")
		this.SetItem(this.GetRow(), 'tdate', snull)
		this.SetColumn('tdate')
		this.SetFocus()
		Return 1
	END IF
	
	IF IsNull(ls_tdate) OR ls_tdate = '' THEN
		MessageBox("확인", "조회일자(to)을 입력하세요.")
		this.SetItem(this.GetRow(), 'tdate', snull)
		this.SetColumn('tdate')
		this.SetFocus()
		Return 1
	END IF
	
	IF long(ls_fdate) > long(ls_tdate) THEN
		MessageBox("확인", "조회기간을 확인하세요.")
		this.SetItem(this.GetRow(), 'tdate', snull)
		this.SetColumn('tdate')
		this.SetFocus()
		Return 1
	END IF
END IF

IF this.GetColumnName() = 'gubn' THEN
	ls_gubn = this.GetText()
	
	IF ls_gubn = '' OR IsNull(ls_gubn) THEN
		dw_ip.Modify('t_4.visible = 0')
		dw_ip.Modify('fdate.visible = 0')
		dw_ip.Modify('t_5.visible = 0')
		dw_ip.Modify('tdate.visible = 0')		
		dw_ip.Modify('t_6.visible = 0')
		dw_ip.SetItem(dw_ip.GetRow(), 'fdate', left(f_today(), 4) + '0101')
		dw_ip.SetItem(dw_ip.GetRow(), 'tdate', f_today())		
	ELSE
		dw_ip.Modify('t_4.visible = 1')
		dw_ip.Modify('fdate.visible = 1')
		dw_ip.Modify('t_5.visible = 1')
		dw_ip.Modify('tdate.visible = 1')
		dw_ip.Modify('t_6.visible = 1')
		dw_ip.SetItem(dw_ip.GetRow(), 'fdate', left(f_today(), 4) + '0101')
		dw_ip.SetItem(dw_ip.GetRow(), 'tdate', f_today())		
	END IF
END IF
p_retrieve.TriggerEvent(Clicked!)
end event

type dw_list from w_standard_print`dw_list within wp_pif2102
integer x = 14
integer y = 272
integer width = 4585
integer height = 2048
string dataobject = "dp_pif2102_1"
boolean border = false
end type

type rr_2 from roundrectangle within wp_pif2102
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 12
integer width = 2944
integer height = 240
integer cornerheight = 40
integer cornerwidth = 46
end type

type rb_1 from radiobutton within wp_pif2102
integer x = 2075
integer y = 144
integer width = 288
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "입사일"
boolean checked = true
end type

event clicked;if rb_1.checked = true then
	rb_2.checked = false
	rb_3.checked = false
	
	dw_list.dataobject="dp_pif2102_1"
	dw_list.settransobject(sqlca)
	dw_print.dataobject="dp_pif2102_1_p"
	dw_print.settransobject(sqlca)
	
	
end if

p_retrieve.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within wp_pif2102
integer x = 2368
integer y = 144
integer width = 288
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "부서별"
end type

event clicked;if rb_2.checked = true then
	rb_1.checked = false
	rb_3.checked = false
	dw_list.dataobject="dp_pif2102_2"
	dw_list.settransobject(sqlca)
	dw_print.dataobject="dp_pif2102_2_p"
	dw_print.settransobject(sqlca)
end if

p_retrieve.TriggerEvent(Clicked!)
end event

type rb_3 from radiobutton within wp_pif2102
integer x = 2661
integer y = 144
integer width = 288
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "직급별"
end type

event clicked;if rb_3.checked = true then
	rb_1.checked = false
	rb_2.checked = false
	dw_list.dataobject="dp_pif2102_3"
	dw_list.settransobject(sqlca)
	dw_print.dataobject="dp_pif2102_3_p"
	dw_print.settransobject(sqlca)
end if

p_retrieve.TriggerEvent(Clicked!)
end event

type sle_1 from singlelineedit within wp_pif2102
integer x = 151
integer y = 5000
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 65535
boolean autohscroll = false
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event rbuttondown;setnull(gs_code)
setnull(gs_codename)

gs_code = sle_1.text

open(w_employee_popup)

if isnull(gs_code) or gs_code = '' then return

sle_1.text = gs_code
sle_name1.text = gs_codename
sle_2.SetFocus()

end event

event modified;String sEmpNo,sEmpName

sEmpNo = Trim(sle_1.Text)

IF sEmpNo="" THEN
   sle_name1.text =""
   sle_2.setfocus()
ELSE	
		SELECT "P1_MASTER"."EMPNAME"  
			INTO :sEmpName  
			FROM "P1_MASTER"  
			WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
					( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
		 
		 IF SQLCA.SQLCODE<>0 THEN
			 MessageBox("확 인","사원번호를 확인하세요!!") 
			 sle_1.text = ""
			 sle_name1.text =""
			 sle_1.SetFocus()
			 RETURN   
		 END IF
         sle_name1.text = sEmpName
         sle_2.setfocus()
END IF

end event

type sle_2 from singlelineedit within wp_pif2102
event ue_keyenter pbm_keydown
integer x = 151
integer y = 5000
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 65535
boolean autohscroll = false
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event ue_keyenter;IF key = KeyEnter! THEN
	Send(Handle(this),256,9,0)
	Return 1
END IF
end event

event rbuttondown;//setnull(gs_code)
//setnull(gs_codename)
//
//gs_code = sle_2.text
//
//open(w_employee_popup)
//
//if isnull(gs_code) or gs_code = '' then return
//
//sle_2.text = gs_code
//sle_name2.text = gs_codename
//cb_update.SetFocus()
end event

event modified;//String sEmpNo,sEmpName
//
//sEmpNo = Trim(sle_2.Text)
//IF sEmpNo="" THEN
//   sle_name2.text =""
//	cb_update.setfocus()
//ELSE	
//		SELECT "P1_MASTER"."EMPNAME"  
//			INTO :sEmpName  
//			FROM "P1_MASTER"  
//			WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
//					( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
//		 
//		 IF SQLCA.SQLCODE<>0 THEN
//			 MessageBox("확 인","사원번호를 확인하세요!!") 
//			 sle_2.text = ""
//			 sle_name2.text =""
//			 sle_2.SetFocus()
//			 RETURN   
//		 END IF
//         sle_name2.text = sEmpName
//         cb_update.setfocus()
//END IF
//
end event

type st_1 from statictext within wp_pif2102
integer x = 151
integer y = 5000
integer width = 334
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 79741120
boolean enabled = false
string text = "사원번호 "
boolean focusrectangle = false
end type

type sle_name1 from singlelineedit within wp_pif2102
integer x = 384
integer y = 5000
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean autohscroll = false
textcase textcase = upper!
integer limit = 6
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_name2 from singlelineedit within wp_pif2102
integer x = 384
integer y = 5000
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean autohscroll = false
textcase textcase = upper!
integer limit = 6
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within wp_pif2102
integer x = 1810
integer y = 152
integer width = 238
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "정    렬  "
boolean focusrectangle = false
end type

type dw_1 from datawindow within wp_pif2102
event ue_enter pbm_dwnprocessenter
event ue_key pbm_keydown
event ue_f1key pbm_dwnkey
boolean visible = false
integer x = 2990
integer y = 4
integer width = 274
integer height = 256
integer taborder = 10
string dataobject = "dw_pif2102ret"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_f1key;IF keydown(KeyF1!) THEN
	TriggerEvent(rbuttondown!)
END IF
end event

event itemerror;return 1
end event

event itemchanged;String sEmpNo,sEmpName,SetNull

dw_1.AcceptText()

if dw_1.GetColumnName() = "empno" then
  sEmpNo = dw_1.GetItemString(1,"empno")

	  IF sEmpNo = '' or isnull(sEmpNo) THEN
		  dw_1.SetITem(1,"empno",SetNull)
		  dw_1.SetITem(1,"empname1",SetNull)
	  ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 dw_1.SetITem(1,"empno",SetNull)
				 dw_1.SetITem(1,"empname1",SetNull)
				 RETURN 1 
			 END IF
				dw_1.SetITem(1,"empname1",sEmpName  )
				
	 END IF
elseif  dw_1.GetColumnName() = "empno2" then
	sEmpNo = dw_1.GetItemString(1,"empno2")

	  IF sEmpNo = '' or isnull(sEmpNo) THEN
		  dw_1.SetITem(1,"empno2",SetNull)
		  dw_1.SetITem(1,"empname2",SetNull)
	  ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 dw_1.SetITem(1,"empno2",SetNull)
				 dw_1.SetITem(1,"empname2",SetNull)
				 RETURN 1 
			 END IF
				dw_1.SetITem(1,"empname2",sEmpName  )
				
	 END IF
	
end if

end event

event rbuttondown;IF dw_1.GetColumnName() = "empno"  THEN
	setnull(gs_code)
   setnull(gs_codename)

  gs_code = dw_1.GetItemString(1,"empno")

  open(w_employee_popup)

  if isnull(gs_code) or gs_code = '' then return

	dw_1.SetITem(1,"empno",gs_code)
	dw_1.SetITem(1,"empname1",gs_codename)
ELSEIF dw_1.GetColumnName() = "empno2"  THEN
	setnull(gs_code)
   setnull(gs_codename)

  gs_code = dw_1.GetItemString(1,"empno2")

  open(w_employee_popup)

  if isnull(gs_code) or gs_code = '' then return

	dw_1.SetITem(1,"empno2",gs_code)
	dw_1.SetITem(1,"empname2",gs_codename)
		
END IF	
end event

type rr_1 from roundrectangle within wp_pif2102
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 268
integer width = 4608
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

