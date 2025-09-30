$PBExportHeader$w_pip5001.srw
$PBExportComments$** 정산전근무지 자료등록
forward
global type w_pip5001 from w_inherite_standard
end type
type rr_1 from roundrectangle within w_pip5001
end type
type dw_main from datawindow within w_pip5001
end type
type rb_1 from radiobutton within w_pip5001
end type
type rb_2 from radiobutton within w_pip5001
end type
type gb_4 from groupbox within w_pip5001
end type
type gb_6 from groupbox within w_pip5001
end type
type dw_emp from u_key_enter within w_pip5001
end type
type pb_1 from picturebutton within w_pip5001
end type
type pb_3 from picturebutton within w_pip5001
end type
type pb_2 from picturebutton within w_pip5001
end type
type pb_4 from picturebutton within w_pip5001
end type
type dw_1 from datawindow within w_pip5001
end type
type dw_saup from datawindow within w_pip5001
end type
type rr_2 from roundrectangle within w_pip5001
end type
end forward

global type w_pip5001 from w_inherite_standard
string title = "정산전근무지 자료등록"
rr_1 rr_1
dw_main dw_main
rb_1 rb_1
rb_2 rb_2
gb_4 gb_4
gb_6 gb_6
dw_emp dw_emp
pb_1 pb_1
pb_3 pb_3
pb_2 pb_2
pb_4 pb_4
dw_1 dw_1
dw_saup dw_saup
rr_2 rr_2
end type
global w_pip5001 w_pip5001

type variables
String iv_workym,iv_pbtag,iv_empno
end variables

forward prototypes
public function integer wf_required_check ()
end prototypes

public function integer wf_required_check ();String scompanycode

scompanycode = dw_main.GetitemString(dw_main.getrow(),'companyno')

if IsNull(scompanycode) or scompanycode = '' then
   messagebox("확인","사업자번호를 입력하세요!!")
	dw_main.SetColumn('companyno')
	dw_main.Setfocus()
	return -1
end if

Return 1

end function

on w_pip5001.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_main=create dw_main
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_4=create gb_4
this.gb_6=create gb_6
this.dw_emp=create dw_emp
this.pb_1=create pb_1
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_4=create pb_4
this.dw_1=create dw_1
this.dw_saup=create dw_saup
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_main
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.gb_4
this.Control[iCurrent+6]=this.gb_6
this.Control[iCurrent+7]=this.dw_emp
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_3
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.pb_4
this.Control[iCurrent+12]=this.dw_1
this.Control[iCurrent+13]=this.dw_saup
this.Control[iCurrent+14]=this.rr_2
end on

on w_pip5001.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_main)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_4)
destroy(this.gb_6)
destroy(this.dw_emp)
destroy(this.pb_1)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_4)
destroy(this.dw_1)
destroy(this.dw_saup)
destroy(this.rr_2)
end on

event open;call super::open;
dw_emp.SetTransObject(SQLCA)
dw_main.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_1.insertrow(0)

String ls_today
ls_today = f_today()
if mid(ls_today,5,2) = '01' or mid(ls_today,5,2) = '02' then /*1월과 2월에는 작업년도를 작년으로 세팅*/
	ls_today = f_aftermonth(ls_today, -12)
end if
dw_1.Setitem(1,'syear',Left(ls_today,4))
dw_1.SetFocus()

iv_workym = Left(gs_today,4)
iv_pbtag  = 'P'

dw_emp.SetRedraw(False)
dw_main.SetRedraw(False)

dw_emp.Reset()
dw_emp.Insertrow(0)

dw_main.Reset()
dw_main.InsertRow(0)

dw_emp.SetRedraw(True)
dw_main.SetRedraw(True)


dw_saup.SetTransObject(sqlca)
dw_saup.insertrow(0)
f_set_saupcd(dw_saup,'saupcd','1')
is_saupcd = gs_saupcd
end event

type p_mod from w_inherite_standard`p_mod within w_pip5001
integer x = 3872
integer taborder = 120
end type

event p_mod::clicked;call super::clicked;Int k

IF dw_main.Accepttext() = -1 THEN 	RETURN

dw_main.SetItem(dw_main.GetRow(), "companycode", gs_company)
dw_main.SetItem(dw_main.GetRow(), "empno", iv_empno)
dw_main.SetItem(dw_main.GetRow(), "workyear", iv_workym)

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

if wf_required_check() = -1 then return

IF dw_main.Update() <> 1 THEN
	ROLLBACK USING sqlca;
	MessageBox("확 인","정산자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

COMMIT;

w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ib_any_typing = False

dw_main.SetColumn('companyname')
dw_main.Setfocus()

end event

type p_del from w_inherite_standard`p_del within w_pip5001
integer x = 4046
integer taborder = 140
end type

event p_del::clicked;call super::clicked;Int il_currow,k,il_rowcount

IF iv_empno ="" OR IsNull(iv_empno) THEN return

il_currow = dw_main.GetRow()

IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "사원번호 :"+iv_empno+"의 정산자료가 모두 삭제됩니다.~n"+&
									 "삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

SetPointer(HourGlass!)

dw_main.SetRedraw(False)

dw_main.DeleteRow(il_currow)

IF dw_main.Update() <> 1 THEN
	MessageBox("확 인","정산자료 삭제 실패!!")
	rollback;
	ib_any_typing =True
	dw_main.SetRedraw(True)
	Return
END IF

commit;

dw_main.Reset()
dw_main.Insertrow(0)
dw_main.SetRedraw(True)

ib_any_typing =False
w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"

end event

type p_inq from w_inherite_standard`p_inq within w_pip5001
integer x = 3525
end type

event p_inq::clicked;call super::clicked;String sname, sColumnName, sempname
INT iv_seq
if dw_emp.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

iv_workym = dw_1.GetItemString(1,"syear") 
iv_empno = dw_emp.GetItemString(1,"empno") 
sempname = dw_emp.GetItemString(1,"empname") 
iv_seq = dw_emp.GetItemnumber(1,"seq") 

IF IsNull(iv_workym) OR iv_workym ="" THEN 
	MessageBox("확 인","작업년도를 확인하세요!")
	dw_1.setfocus()
	return 1
end if

IF (IsNull(sempname) OR sempname ="") AND (IsNull(iv_empno) OR iv_empno ="" )THEN 
	MessageBox("확 인","사번이나 성명을 입력하십시오!!")
	dw_emp.setcolumn("empno")
	dw_emp.setfocus()		
	Return 1

END IF	
IF iv_seq <> 1 and iv_seq <> 2 then
	MessageBox("확 인","순번을 확인하십시오!!")
	p_ins.TriggerEvent(Clicked!)
	Return 1
END IF	

dw_main.SetRedraw(False)

IF dw_main.Retrieve(gs_company,iv_workym,iv_empno,iv_seq) <=0 THEN
   p_ins.TriggerEvent(Clicked!)
	dw_main.SetItem(1,'seq',iv_seq)
	dw_main.SetColumn(1)
	dw_main.SetFocus()
		
ELSE
	
	w_mdi_frame.sle_msg.text =""
END IF
ib_any_typing = false
dw_main.SetRedraw(True)

end event

type p_print from w_inherite_standard`p_print within w_pip5001
boolean visible = false
integer x = 3639
integer y = 2384
integer taborder = 230
end type

type p_can from w_inherite_standard`p_can within w_pip5001
integer x = 4219
integer taborder = 160
end type

event p_can::clicked;call super::clicked;dw_emp.SetRedraw(False)
dw_main.SetRedraw(False)

dw_emp.Reset()
dw_emp.InsertRow(0)
dw_emp.SetColumn("empno")
dw_emp.SetFocus()

dw_main.Reset()
dw_main.Insertrow(0)

dw_emp.SetRedraw(True)
dw_main.SetRedraw(True)

ib_any_typing = False


end event

type p_exit from w_inherite_standard`p_exit within w_pip5001
integer x = 4393
integer taborder = 190
end type

event p_exit::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("종료") = -1 THEN  	RETURN

close(parent)
end event

type p_ins from w_inherite_standard`p_ins within w_pip5001
integer x = 3698
integer taborder = 30
end type

event p_ins::clicked;call super::clicked;Int	 li_seq_1, li_seq_2

IF wf_warndataloss("종료") = -1 THEN  	RETURN

if dw_emp.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

iv_workym = dw_1.GetItemString(1,"syear") 
iv_empno = dw_emp.GetItemString(1,"empno") 

IF IsNull(iv_workym) OR iv_workym ="" THEN 
	MessageBox("확 인","작업년도를 확인하세요!")
	dw_1.setfocus()
	return
end if

IF IsNull(iv_empno) OR iv_empno ="" THEN
	MessageBox("확 인","사번을 입력하세요!")
	dw_emp.setcolumn("empno")
	dw_emp.setfocus()
	Return
END IF	

  SELECT COUNT("P3_ACNT_PREV_COMPANY"."SEQ")
	 INTO :li_seq_1
    FROM "P3_ACNT_PREV_COMPANY"
   WHERE ( "P3_ACNT_PREV_COMPANY"."WORKYEAR" = :iv_workym ) AND 
         ( "P3_ACNT_PREV_COMPANY"."EMPNO" = :iv_empno ) AND
         ( "P3_ACNT_PREV_COMPANY"."COMPANYCODE" = :gs_company ) AND
			( "P3_ACNT_PREV_COMPANY"."SEQ" = 1 );

  SELECT COUNT("P3_ACNT_PREV_COMPANY"."SEQ")
	 INTO :li_seq_2
    FROM "P3_ACNT_PREV_COMPANY"
   WHERE ( "P3_ACNT_PREV_COMPANY"."WORKYEAR" = :iv_workym ) AND 
         ( "P3_ACNT_PREV_COMPANY"."EMPNO" = :iv_empno ) AND
         ( "P3_ACNT_PREV_COMPANY"."COMPANYCODE" = :gs_company ) AND
			( "P3_ACNT_PREV_COMPANY"."SEQ" = 2 );

IF li_seq_1 = 1 THEN 
	IF li_seq_2 = 1 THEN
		MessageBox('확 인','이미 2건의 전근무지 자료가 등록되어 있습니다!!',StopSign!)
		return
	ELSE
		dw_main.SetRedraw(false)
		dw_main.Reset()
		dw_main.Insertrow(0)
		dw_emp.SetItem(dw_emp.getrow(),'seq',2)
		dw_main.SetItem(dw_main.getrow(),'seq',2)
		dw_main.SetRedraw(true)
	END IF
ELSE
	dw_main.SetRedraw(false)
	dw_main.Reset()
	dw_main.Insertrow(0)
	dw_emp.SetItem(dw_emp.getrow(),'seq',1)
	dw_main.SetItem(dw_main.getrow(),'seq',1)		
	dw_main.SetRedraw(true)
END IF
w_mdi_frame.sle_msg.text = "등록된 자료가 없습니다. 새로운 자료를 입력하세요!!"

dw_main.SetColumn('companyname')
dw_main.Setfocus()
end event

type p_search from w_inherite_standard`p_search within w_pip5001
boolean visible = false
integer x = 4201
integer y = 2380
integer taborder = 210
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip5001
boolean visible = false
integer x = 3826
integer y = 2384
integer taborder = 80
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip5001
boolean visible = false
integer x = 4005
integer y = 2384
integer taborder = 100
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip5001
boolean visible = false
integer x = 3680
integer y = 2656
integer taborder = 20
end type

type st_window from w_inherite_standard`st_window within w_pip5001
boolean visible = false
integer taborder = 170
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip5001
boolean visible = false
integer x = 3195
integer y = 2412
integer taborder = 220
end type

type cb_update from w_inherite_standard`cb_update within w_pip5001
boolean visible = false
integer x = 2139
integer y = 2412
integer taborder = 150
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip5001
boolean visible = false
integer x = 430
integer y = 2412
integer taborder = 130
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip5001
boolean visible = false
integer x = 2491
integer y = 2412
integer taborder = 180
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip5001
boolean visible = false
integer x = 46
integer y = 2428
integer taborder = 110
end type

type st_1 from w_inherite_standard`st_1 within w_pip5001
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip5001
boolean visible = false
integer x = 2843
integer y = 2412
integer taborder = 200
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip5001
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip5001
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip5001
boolean visible = false
integer x = 2062
integer width = 1531
integer height = 176
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip5001
boolean visible = false
integer x = 64
integer width = 805
integer height = 176
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip5001
boolean visible = false
integer y = 2868
end type

type rr_1 from roundrectangle within w_pip5001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 315
integer y = 248
integer width = 2784
integer height = 456
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_main from datawindow within w_pip5001
event ue_enter pbm_dwnprocessenter
integer x = 283
integer y = 748
integer width = 3424
integer height = 1208
integer taborder = 90
boolean bringtotop = true
string dataobject = "d_pip5001"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemfocuschanged;IF dwo.name ="companyname" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	
end event

event itemerror;return 1
end event

event dberror;return 1
end event

event itemchanged;ib_any_typing = true
end event

type rb_1 from radiobutton within w_pip5001
integer x = 370
integer y = 104
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사번순"
boolean checked = true
end type

type rb_2 from radiobutton within w_pip5001
integer x = 677
integer y = 104
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "성명순"
end type

type gb_4 from groupbox within w_pip5001
integer x = 320
integer y = 44
integer width = 695
integer height = 168
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "정렬"
end type

type gb_6 from groupbox within w_pip5001
integer x = 1134
integer y = 48
integer width = 530
integer height = 164
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

type dw_emp from u_key_enter within w_pip5001
event ue_key pbm_dwnkey
integer x = 366
integer y = 376
integer width = 2706
integer height = 296
integer taborder = 70
string dataobject = "d_pip5001_1"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;call super::itemchanged;String sEmpName,snull, ls_name
Int il_RowCount, iv_seq

dw_1.Accepttext()
Accepttext()
iv_workym = dw_1.GetitemString(1,'syear')
SetNull(snull)

IF ib_any_typing =True THEN
	MessageBox("확 인","저장하지 않은 자료가 있습니다.!!")
	w_mdi_frame.sle_msg.text = "자료를 저장하지 않으려면 취소를 누르십시요!!"
	Return 1
END IF

If dw_emp.GetColumnName() = "seq" Then
	iv_seq = integer(this.GetText())
END IF	

 

If dw_emp.GetColumnName() = "empname" Then

	sEmpName = this.Gettext()

   iv_empno = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'empname',ls_name)
		 Setitem(1,'empno',ls_name)
		 return 1
    end if
	 Setitem(1,"empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"empname",ls_name)
	
	dw_emp.SetRedraw(False)
	dw_emp.Retrieve(gs_company,iv_empno,'%')

elseIf dw_emp.GetColumnName() = "empno" Then

	iv_empno = trim(this.GetText())
	
	IF iv_empno ="" OR IsNull(iv_empno) THEN RETURN
	
	iv_empno = wf_exiting_saup_data("empno",iv_empno,"1",is_saupcd)

	IF IsNull(iv_empno) THEN
		Messagebox("확 인","등록되지 않은 사번이므로 등록할 수 없습니다!!")
		dw_emp.SetRedraw(False)
		dw_emp.Reset()
		dw_emp.InsertRow(0)
		dw_emp.SetColumn("empno")
		dw_emp.SetFocus()
		dw_emp.SetRedraw(True)
		Return 1
	END IF
	
	IF iv_empno = '' THEN
		dw_emp.SetRedraw(False)
		dw_emp.Reset()
		dw_emp.InsertRow(0)
		dw_emp.SetColumn("empno")
		dw_emp.SetFocus()
		dw_emp.SetRedraw(True)
		Return 1
	END IF
	
	dw_emp.SetRedraw(False)
	dw_emp.Retrieve(gs_company,iv_empno,'%')
END IF

IF iv_seq = 0  or isnull(iv_seq) then
	dw_emp.SetItem(1,'seq',1)
end if	
p_inq.TriggerEvent(clicked!)
dw_emp.SetRedraw(True)
return 1


end event

event itemfocuschanged;call super::itemfocuschanged;
IF dwo.name ="empname" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	
end event

event rbuttondown;call super::rbuttondown;
SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_gubun)

this.AcceptText()

Gs_gubun = is_saupcd
IF This.GetColumnName() = "empname" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empname")
		
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empname",Gs_codeName)
	this.TriggerEvent(ItemChanged!)

ELSEIF This.GetColumnName() = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",Gs_code)
	this.TriggerEvent(ItemChanged!)
END IF


end event

event itemerror;call super::itemerror;return 1
end event

type pb_1 from picturebutton within w_pip5001
integer x = 1166
integer y = 104
integer width = 101
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\first.gif"
alignment htextalign = left!
end type

event clicked;string scode,sname,sMin_name

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_emp.getitemstring(1, "empno")

	SELECT min("P1_MASTER"."EMPNO")  
		INTO :iv_empno  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company and servicekindcode <> '3';
	IF IsNull(iv_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_emp.GetItemString(1,"empname")
	
	SELECT min("P1_MASTER"."EMPNAME")  
		INTO :sMin_name  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company and servicekindcode <> '3';
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :iv_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMin_name and servicekindcode <> '3';
	END IF
End If

dw_emp.SetRedraw(false)
dw_emp.Retrieve(gs_company,iv_empno,'%')
dw_emp.SetItem(dw_emp.GetRow(),'seq',1)
dw_emp.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)
end event

type pb_3 from picturebutton within w_pip5001
integer x = 1285
integer y = 104
integer width = 101
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\prior.gif"
end type

event clicked;string scode,sname,sMax_name

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_emp.getitemstring(1, "empno")
	
	SELECT MAX("P1_MASTER"."EMPNO")  
   	INTO :iv_empno  
	   FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" < :scode and servicekindcode <> '3';
	IF IsNull(iv_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_emp.GetItemString(1,"empname")
	
	SELECT MAX("P1_MASTER"."EMPNAME")  
   	INTO :sMax_name 
	   FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" < :sname and servicekindcode <> '3';
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :iv_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMax_name and servicekindcode <> '3';
	END IF
End If

dw_emp.SetRedraw(false)
dw_emp.Retrieve(gs_company,iv_empno,'%')
dw_emp.SetItem(dw_emp.GetRow(),'seq',1)
dw_emp.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)
end event

type pb_2 from picturebutton within w_pip5001
integer x = 1403
integer y = 104
integer width = 101
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\next.gif"
end type

event clicked;string scode,sname,sMin_name

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_emp.getitemstring(1, "empno")
	
	SELECT MIN("P1_MASTER"."EMPNO")  
   	INTO :iv_empno  
   	FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNO" > :scode and servicekindcode <> '3';
	IF IsNull(iv_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_emp.GetItemString(1,"empname")
	
	SELECT MIN("P1_MASTER"."EMPNAME")  
   	INTO :sMin_name  
   	FROM "P1_MASTER"  
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" > :sname and servicekindcode <> '3';
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :iv_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMin_name and servicekindcode <> '3';
	END IF
End If

dw_emp.SetRedraw(false)
dw_emp.Retrieve(gs_company,iv_empno,'%')
dw_emp.SetItem(dw_emp.GetRow(),'seq',1)
dw_emp.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)





end event

type pb_4 from picturebutton within w_pip5001
integer x = 1522
integer y = 104
integer width = 101
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\last.gif"
end type

event clicked;string scode,sname,sMax_name

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_emp.getitemstring(1, "empno")

	SELECT Max("P1_MASTER"."EMPNO")  
		INTO :iv_empno  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company and servicekindcode <> '3';
	IF IsNull(iv_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_emp.GetItemString(1,"empname")
	
	SELECT Max("P1_MASTER"."EMPNAME")  
		INTO :sMax_name  
	   FROM "P1_MASTER"  
	   WHERE "P1_MASTER"."COMPANYCODE" = :gs_company and servicekindcode <> '3';
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :iv_empno 
	   	FROM "P1_MASTER"  
	   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND "P1_MASTER"."EMPNAME" =:sMax_name and servicekindcode <> '3';
	END IF
End If

dw_emp.SetRedraw(false)
dw_emp.Retrieve(gs_company,iv_empno,'%')
dw_emp.SetItem(dw_emp.GetRow(),'seq',1)
dw_emp.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)
end event

type dw_1 from datawindow within w_pip5001
integer x = 334
integer y = 256
integer width = 741
integer height = 100
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pip5001_2"
boolean border = false
boolean livescroll = true
end type

type dw_saup from datawindow within w_pip5001
integer x = 1760
integer y = 108
integer width = 672
integer height = 80
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_saupcd_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;this.AcceptText()

IF this.GetColumnName() ="saupcd" THEN 
   is_saupcd = this.GetText()
	IF trim(is_saupcd) = '' OR ISNULL(is_saupcd) THEN is_saupcd = '%'
END IF
end event

event rbuttondown;//IF this.GetColumnName() = "deptcode" THEN
//	SetNull(gs_code)
//	SetNull(gs_codename)
//	SetNull(gs_gubun)
//
//	gs_gubun = this.GetItemString(GetRow(),'saupcd')
//	if isnull(gs_gubun) or trim(gs_gubun) = '' then gs_gubun = '%'
//	Open(w_dept_saup_popup)
//	
//	IF IsNull(Gs_code) THEN RETURN
//	this.SetITem(1,"deptcode",gs_code)
//	this.TriggerEvent(ItemChanged!)
//END IF
end event

type rr_2 from roundrectangle within w_pip5001
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 1719
integer y = 88
integer width = 759
integer height = 112
integer cornerheight = 40
integer cornerwidth = 55
end type

