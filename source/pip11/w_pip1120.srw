$PBExportHeader$w_pip1120.srw
$PBExportComments$고정.월변동 개인별 조회
forward
global type w_pip1120 from w_standard_print
end type
type rb_1 from radiobutton within w_pip1120
end type
type rb_2 from radiobutton within w_pip1120
end type
type rr_1 from roundrectangle within w_pip1120
end type
end forward

global type w_pip1120 from w_standard_print
string title = "고정.월변동 개인별 조회"
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
end type
global w_pip1120 w_pip1120

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_pbtag, ls_empno, ls_empname, ls_date, ArgBuf, ls_allow, ls_reference, ls_gubun, ls_refer, snull
SetNull(snull)
dataWindowChild state_child, state_child2

IF dw_ip.AcceptText() = -1 THEN Return -1


ls_pbtag = dw_ip.GetItemString(dw_ip.GetRow(), 'pbtag')
ls_empno = dw_ip.GetItemString(dw_ip.GetRow(), 'empno')
ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'kdate')
ls_refer = dw_ip.GetItemString(dw_ip.GetRow(), 'refer')	
		
IF ls_pbtag = '' OR IsNull(ls_pbtag) THEN
	MessageBox("확인", "급여구분을 입력하세요.")
	dw_ip.SetItem(dw_ip.GetRow(), 'pbtag', snull)
	dw_ip.SetColumn('pbtag')
	dw_ip.SetFocus()
	Return 1
END IF

IF ls_empno = '' OR IsNull(ls_empno) THEN
   ls_empno = '%'
	dw_print.modify("empno_t.text = '" + '전체' + "'")
ELSE
	SELECT M.empname
	  INTO :ArgBuf
	  FROM p1_master M
	 WHERE (M.empno = :ls_empno);
	IF SQLCA.sqlcode = 0 THEN dw_print.modify("empno_t.text = '" + ArgBuf + "'")
END IF

IF ls_date = '' OR IsNull(ls_date) THEN
	MessageBox("확인", "조회년월을 입력하세요.")
	dw_ip.SetItem(dw_ip.GetRow(), 'kdate', snull)
	dw_ip.SetColumn('kdate')
	dw_ip.SetFocus()
	Return 1
END IF
	
IF f_datechk(ls_date + '01') = -1 THEN
	MessageBox("확인", "조회년월을 확인하세요.")
	dw_ip.SetItem(dw_ip.GetRow(), 'kdate', snull)
	dw_ip.SetColumn('kdate')
	dw_ip.SetFocus()
	Return 1
END IF

IF ls_refer = '' OR IsNull(ls_refer) THEN
	MessageBox("확인", "지급구분을 입력하세요.")
	dw_ip.SetItem(dw_ip.GetRow(), 'refer', snull)
	dw_ip.SetColumn('refer')
	dw_ip.SetFocus()
	Return 1
END IF

dw_list.SetReDraw(False)
w_mdi_frame.sle_msg.text ="조회중입니다..."

IF rb_1.Checked = True AND rb_2.Checked = False THEN
	ls_gubun = '1'

	dw_list.AcceptText()
	dw_print.AcceptText()
	
	dw_list.GetChild("allowcode", state_child)
	dw_print.GetChild("allowcode", state_child2)
	
	state_child.SetTransObject(SQLCA)
	state_child.Reset()
	state_child.Retrieve(ls_refer, ls_gubun) 

   state_child2.SetTransObject(SQLCA)
	state_child2.Reset()
	state_child2.Retrieve(ls_refer, ls_gubun) 
	
	IF dw_print.Retrieve(ls_pbtag, ls_empno, ls_refer) < 1 THEN
		w_mdi_frame.sle_msg.text ="조회된 자료가 없습니다!!"
		dw_list.SetReDraw(True)
		Return 1
	END IF
ELSEIF rb_1.Checked = False AND rb_2.Checked = True THEN
	ls_gubun = '2'

   dw_list.AcceptText()
	dw_print.AcceptText()
	
	dw_list.GetChild("allowcode", state_child)
	dw_print.GetChild("allowcode", state_child2)
	
	state_child.SetTransObject(SQLCA)
	state_child.Reset()
	state_child.Retrieve(ls_refer, ls_gubun) 

   state_child2.SetTransObject(SQLCA)
	state_child2.Reset()
	state_child2.Retrieve(ls_refer, ls_gubun) 
			
   IF dw_print.Retrieve(ls_pbtag, ls_empno, ls_refer, ls_Date) < 1 THEN
		w_mdi_frame.sle_msg.text ="조회된 자료가 없습니다!!"
		dw_list.SetReDraw(True)
		Return 1
	END IF	
END IF

dw_print.ShareData(dw_list)
dw_list.SetReDraw(True)
w_mdi_frame.sle_msg.text = ""

Return 1
end function

on w_pip1120.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_pip1120.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetItem(dw_ip.GetRow(), 'kdate', left(f_today(), 6))
end event

type p_preview from w_standard_print`p_preview within w_pip1120
end type

type p_exit from w_standard_print`p_exit within w_pip1120
end type

type p_print from w_standard_print`p_print within w_pip1120
end type

type p_retrieve from w_standard_print`p_retrieve within w_pip1120
end type

type st_window from w_standard_print`st_window within w_pip1120
boolean visible = false
boolean enabled = true
end type

type sle_msg from w_standard_print`sle_msg within w_pip1120
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within w_pip1120
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within w_pip1120
boolean visible = false
boolean enabled = true
end type

type gb_10 from w_standard_print`gb_10 within w_pip1120
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within w_pip1120
string dataobject = "d_pip1120_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pip1120
integer x = 846
integer width = 2697
integer height = 304
string dataobject = "d_pip1120_c"
end type

event dw_ip::itemchanged;call super::itemchanged;String ls_pbtag, ls_empno, sEmpName, ls_date, ls_refer, snull, ls_name
SetNull(snull)

dw_ip.AcceptText()

IF this.GetColumnName() = 'pbtag' THEN
	ls_pbtag = this.GetText()
	
	IF ls_pbtag = '' OR IsNull(ls_pbtag) THEN
		MessageBox("확인", "급여구분을 입력하세요.")
		dw_ip.SetItem(dw_ip.GetRow(), 'pbtag', snull)
		dw_ip.SetColumn('pbtag')
		dw_ip.SetFocus()
		Return 1
	END IF
	
END IF

IF this.GetColumnName() = 'empno' THEN
	ls_empno = this.GetText()
	
	IF ls_empno = '' OR IsNull(ls_empno) THEN
		this.SetItem(this.GetRow(), "empno", snull)
		this.SetItem(this.GetRow(), "empname", snull)
	ELSE	
		
		Select empname
		  INTO :sEmpName
		  FROM p1_master
		 WHERE empno = :ls_empno;
		 
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(this.GetRow(), "empname", sEmpName)
		ELSE
			MessageBox("확 인","등록되지 않은 사원입니다!!",StopSign!)
			this.SetItem(this.GetRow(), "empno", snull)
			this.SetItem(this.GetRow(), "empname", snull)
		END IF
	END IF
END IF

IF GetColumnName() = "empname" then
  sEmpName = GetItemString(1,"empname")

   ls_name = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(ls_name) then 
		 Setitem(1,'empname',ls_name)
		 Setitem(1,'empno',ls_name)
		 return 1
    end if
	 Setitem(1,"empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"empname",ls_name)
	 return 1
END IF
	

IF this.GetColumnName() = 'kdate' THEN
	ls_date = this.GetText()
	
	IF ls_date = '' OR IsNull(ls_date) THEN
		MessageBox("확인", "조회년월을 입력하세요.")
		dw_ip.SetItem(dw_ip.GetRow(), 'kdate', snull)
		dw_ip.SetColumn('kdate')
		dw_ip.SetFocus()
		Return 1
	END IF
	
	IF f_datechk(ls_date + '01') = -1 THEN
		MessageBox("확인", "조회년월을 확인하세요.")
		dw_ip.SetItem(dw_ip.GetRow(), 'kdate', snull)
		dw_ip.SetColumn('kdate')
		dw_ip.SetFocus()
		Return 1
	END IF
		
END IF

IF this.GetColumnName() = 'refer' THEN
	ls_refer = this.GetText()
	
	IF ls_refer = '' OR IsNull(ls_refer) THEN
		MessageBox("확인", "지급구분을 입력하세요.")
		dw_ip.SetItem(dw_ip.GetRow(), 'refer', snull)
		dw_ip.SetColumn('refer')
		dw_ip.SetFocus()
		Return 1
	END IF
	
END IF

	
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_Codename)

IF this.GetColumnName() = 'empno' THEN
	gs_codename = this.GetText()
	
	open(w_employee_popup)
	
	IF IsNull(gs_code) THEN Return 
	
   THIS.SetItem(this.GetRow(), 'empno', gs_code)
   This.SetItem(this.GetRow(), 'empname', gs_codename)		
END IF

end event

type dw_list from w_standard_print`dw_list within w_pip1120
integer x = 855
integer width = 2633
integer height = 1904
string dataobject = "d_pip1120_1"
boolean border = false
end type

type rb_1 from radiobutton within w_pip1120
integer x = 901
integer y = 68
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "고정항목"
boolean checked = true
end type

event clicked;String ls_gubun, ls_refer, snull
SetNull(snull)

IF rb_1.checked = True THEN
	rb_2.checked = False
	dw_list.SetItem(dw_list.GetRow(), 'allowcode', snull)
	
	dw_list.dataobject="d_pip1120_1"
	dw_list.settransobject(sqlca)
	dw_print.dataobject="d_pip1120_1_p"
	dw_print.settransobject(sqlca)
	
	dw_ip.modify("t_3.visible = 0")
	dw_ip.modify("kdate_t.visible = 0")
	dw_ip.modify("kdate.visible = 0")
	
//	ls_gubun = '1'
//		
//	dw_ip.AcceptText()
//	dw_list.AcceptText()
//	dw_print.AcceptText()
//	
//	dataWindowChild state_child, state_child2
//		
//	dw_list.GetChild("allowcode", state_child)
//	dw_print.GetChild("allowcode", state_child2)
//	
//	state_child.SetTransObject(SQLCA)
//	state_child.Reset()
//	state_child.Retrieve(ls_refer, ls_gubun) 
//
//   state_child2.SetTransObject(SQLCA)
//	state_child2.Reset()
//	state_child2.Retrieve(ls_refer, ls_gubun) 
		
END IF

//p_retrieve.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within w_pip1120
integer x = 901
integer y = 184
integer width = 375
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "월변동항목"
end type

event clicked;String ls_gubun, ls_refer, snull
SetNull(snull)

IF rb_2.checked = True THEN
	rb_1.checked = False
	
	dw_list.dataobject="d_pip1120_2"
	dw_list.settransobject(sqlca)
	dw_print.dataobject="d_pip1120_2_p"
	dw_print.settransobject(sqlca)
	
	dw_ip.modify("t_3.visible = 1")
	dw_ip.modify("kdate_t.visible = 1")
	dw_ip.modify("kdate.visible = 1")
	
//	ls_gubun = '2'
//	
//	dw_ip.AcceptText()
//	dw_list.AcceptText()
//	dw_print.AcceptText()
//	
//	dataWindowChild state_child, state_child2
//	
//	dw_list.GetChild("allowcode", state_child)
//	dw_print.GetChild("allowcode", state_child2)
//	
//	state_child.SetTransObject(SQLCA)
//	state_child.Reset()
//	state_child.Retrieve(ls_refer, ls_gubun) 
//
//   state_child2.SetTransObject(SQLCA)
//	state_child2.Reset()
//	state_child2.Retrieve(ls_refer, ls_gubun) 
	
END IF

//p_retrieve.TriggerEvent(Clicked!)
end event

type rr_1 from roundrectangle within w_pip1120
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 846
integer y = 328
integer width = 2693
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

