$PBExportHeader$w_qct_02020.srw
$PBExportComments$** 제안제출등록
forward
global type w_qct_02020 from w_inherite
end type
type gb_3 from groupbox within w_qct_02020
end type
type gb_2 from groupbox within w_qct_02020
end type
type gb_1 from groupbox within w_qct_02020
end type
type dw_1 from u_key_enter within w_qct_02020
end type
type dw_sel from datawindow within w_qct_02020
end type
type rb_new from radiobutton within w_qct_02020
end type
type rb_mod from radiobutton within w_qct_02020
end type
type pb_1 from u_pb_cal within w_qct_02020
end type
type pb_2 from u_pb_cal within w_qct_02020
end type
end forward

global type w_qct_02020 from w_inherite
string title = "제안 제출 등록"
long backcolor = 12632256
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_1 dw_1
dw_sel dw_sel
rb_new rb_new
rb_mod rb_mod
pb_1 pb_1
pb_2 pb_2
end type
global w_qct_02020 w_qct_02020

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
if dw_insert.AcceptText() = -1 then
	dw_insert.SetFocus()
	return -1
end if	

if IsNull(Trim(dw_insert.object.kwa_no[1])) or Trim(dw_insert.object.kwa_no[1]) = "" then
	f_message_chk(1400,'[제안번호]')
	dw_insert.SetColumn('kwa_no')
	dw_insert.SetFocus()
	return -1 
elseif Isnull(Trim(dw_insert.object.prop_name[1])) or Trim(dw_insert.object.prop_name[1]) = "" then
  	f_message_chk(1400,'[제안명]')
	dw_insert.SetColumn('prop_name')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.prodat[1])) or Trim(dw_insert.object.prodat[1]) = "" then
  	f_message_chk(35,'[제안일자]')
	dw_insert.SetColumn('prodat')
	dw_insert.SetFocus()
	return -1
elseif IsNull(Trim(dw_insert.object.prodpt[1])) or Trim(dw_insert.object.prodpt[1]) = "" then
  	f_message_chk(1400,'[제안부서]')
	dw_insert.SetColumn('prodpt')
	dw_insert.SetFocus()
	return -1
elseif IsNull(Trim(dw_insert.object.simdpt[1])) or Trim(dw_insert.object.simdpt[1]) = "" then
  	f_message_chk(1400,'[심사부서]')
	dw_insert.SetColumn('simdpt')
	dw_insert.SetFocus()
	return -1
elseif IsNull(Trim(dw_insert.object.jipdpt[1])) or Trim(dw_insert.object.jipdpt[1]) = "" then
  	f_message_chk(1400,'[집계부서]')
	dw_insert.SetColumn('jipdpt')
	dw_insert.SetFocus()
	return -1
end if	

if rb_new.checked = True then
	string sdate, jpno 
	sdate = f_today()
	jpno = String(SQLCA.FUN_JUNPYO(gs_sabu, sdate, 'D0'), "0000")
	
	dw_insert.object.prop_jpno[1] = sdate + jpno
	dw_insert.object.sabu[1] = gs_sabu //사업장구분
end if	

if Isnull(Trim(dw_insert.object.prop_jpno[1])) or Trim(dw_insert.object.prop_jpno[1]) = "" then
  	f_message_chk(1400,'[제안번호]')
	dw_insert.SetColumn('prop_jpno')
	dw_insert.SetFocus()
	return -1
end if

return 1

end function

on w_qct_02020.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_1=create dw_1
this.dw_sel=create dw_sel
this.rb_new=create rb_new
this.rb_mod=create rb_mod
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_sel
this.Control[iCurrent+6]=this.rb_new
this.Control[iCurrent+7]=this.rb_mod
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.pb_2
end on

on w_qct_02020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.dw_sel)
destroy(this.rb_new)
destroy(this.rb_mod)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_sel.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.Setredraw(True)

dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.Setredraw(True)
dw_1.SetFocus()

rb_new.Checked = True
rb_new.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_qct_02020
integer x = 1394
integer y = 224
integer width = 2203
integer height = 1644
integer taborder = 40
boolean enabled = false
string dataobject = "d_qct_02020_03"
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;String s_cod, s_nam, s_dpt, s_job, s_updept
int    ilevel


s_cod = Trim(this.GetText())

if (this.GetColumnName() = "prop_jpno") Then
	dw_insert.SetRedraw(False)
	if dw_insert.Retrieve(gs_sabu, s_cod) < 1 then
	   dw_insert.Reset()
		dw_insert.InsertRow(0)
		rb_new.TriggerEvent(Clicked!)
		rb_new.checked = True
		sle_msg.text = "등록된 제안제출 자료가 없습니다! 신규로 등록하세요!"
   else
		dw_insert.object.prop_jpno_t.visible = True
      dw_insert.object.prop_jpno.visible = True 
	   rb_mod.checked = True
   end if	
	dw_insert.SetRedraw(True)
elseif (this.GetColumnName() = "empno") Then
	if IsNull(s_cod) or s_cod = "" then
	   this.object.empnm[1] = ""
		this.object.deptcode[1] = ""
		this.object.jobkindcode[1] = ""
//		this.object.jipdpt[1] = ""
		return 
	end if  
	
   SELECT p1.empname, p1.deptcode, p1.jobkindcode, p0.updept, p0.dept_level
     INTO :s_nam, :s_dpt, :s_job, :s_updept, :ilevel
     FROM p1_master p1, p0_dept p0
    WHERE p1.empno = :s_cod
	   and p1.servicekindcode <> '3'
		and p0.deptcode (+) = p1.deptcode;
		
	if sqlca.sqlcode = 0 then
		this.object.empnm[1] = s_nam
		this.object.deptcode[1] = s_dpt
		this.object.prodpt[1] = s_dpt
		this.object.jobkindcode[1] = s_job
//		if ilevel > 2 then 
//			this.object.jipdpt[1] = s_updept
//		else
//			this.object.jipdpt[1] = s_dpt
//		end if
	else
		f_message_chk(33, "[제안자 : " + s_cod + "]")
		this.object.empno[1] = ""
		this.object.empnm[1] = ""
		this.object.deptcode[1] = ""
		this.object.prodpt[1] = ""
		this.object.jobkindcode[1] = ""
//		this.object.jipdpt[1] = ""
		return 1
	end if
elseif (this.GetColumnName() = "prodat") Then
	if IsNull(s_cod) or s_cod = "" or f_datechk(s_cod) = -1 then
		f_message_chk(35, "[제안일자]")
		this.object.prodat[1] = ""
		return 1
	end if
end if	

return
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF	this.getcolumnname() = "empno"	THEN		
	open(w_sawon_popup)
	this.SetItem(1, "empno", gs_code)
	this.SetItem(1, "empnm", gs_codename)
	this.TriggerEvent(itemchanged!)
	return 
END IF
end event

event dw_insert::itemfocuschanged;if (this.GetColumnName() = "prop_name") or (this.GetColumnName() = "bunim") Then
	f_toggle_kor(handle(this))
else	 
	f_toggle_eng(handle(this))
end if	
end event

type p_delrow from w_inherite`p_delrow within w_qct_02020
end type

type p_addrow from w_inherite`p_addrow within w_qct_02020
end type

type p_search from w_inherite`p_search within w_qct_02020
end type

type p_ins from w_inherite`p_ins within w_qct_02020
end type

type p_exit from w_inherite`p_exit within w_qct_02020
end type

type p_can from w_inherite`p_can within w_qct_02020
end type

type p_print from w_inherite`p_print within w_qct_02020
end type

type p_inq from w_inherite`p_inq within w_qct_02020
end type

type p_del from w_inherite`p_del within w_qct_02020
end type

type p_mod from w_inherite`p_mod within w_qct_02020
end type

type cb_exit from w_inherite`cb_exit within w_qct_02020
integer x = 3232
integer y = 1936
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_qct_02020
integer x = 2496
integer y = 1936
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;string s_sabu, s_mokyy

if f_msg_update() = -1 then return

if wf_required_chk() = -1 then 
	ROLLBACK;
	return //필수입력항목 체크 
END IF	

IF dw_insert.Update() > 0 THEN		
	COMMIT;
	sle_msg.Text = "저장 되었습니다!"
//	cb_inq.TriggerEvent(Clicked!)
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	sle_msg.Text = "저장작업 실패!"
END IF

cb_inq.TriggerEvent(Clicked!)


end event

type cb_ins from w_inherite`cb_ins within w_qct_02020
boolean visible = false
integer taborder = 80
end type

type cb_del from w_inherite`cb_del within w_qct_02020
boolean visible = false
integer x = 923
integer taborder = 90
end type

type cb_inq from w_inherite`cb_inq within w_qct_02020
integer x = 73
integer y = 1936
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;String sdate, edate, emp

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return -1
end if	

sdate = Trim(dw_1.object.sdate[1])
edate = Trim(dw_1.object.edate[1])
emp = Trim(dw_1.object.empno[1])

if IsNull(sdate) or sdate = '' then sdate = "11111111"
if IsNull(edate) or edate = '' then edate = "99999999"
if IsNull(emp) or emp = "" then
	emp = "%"
else
	emp = emp + "%"
end if	
 
dw_sel.SetRedraw(False)
if dw_sel.Retrieve(sdate, edate, emp) < 1 then
	sle_msg.text = "등록된 제안제출 자료가 없습니다! 신규로 등록하세요!"
else
	sle_msg.text = ""

end if
dw_sel.SetRedraw(True)

rb_new.checked = True
rb_new.TriggerEvent(Clicked!)


end event

type cb_print from w_inherite`cb_print within w_qct_02020
boolean visible = false
integer taborder = 100
end type

type st_1 from w_inherite`st_1 within w_qct_02020
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qct_02020
integer x = 2871
integer y = 1936
end type

event cb_can::clicked;call super::clicked;sle_msg.text =""

IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

cb_inq.TriggerEvent(Clicked!)


end event

type cb_search from w_inherite`cb_search within w_qct_02020
boolean visible = false
integer x = 1371
integer y = 1956
integer taborder = 110
end type



type sle_msg from w_inherite`sle_msg within w_qct_02020
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qct_02020
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_02020
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_02020
end type

type gb_3 from groupbox within w_qct_02020
integer x = 1394
integer y = 28
integer width = 768
integer height = 172
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "제출내용"
end type

type gb_2 from groupbox within w_qct_02020
integer x = 37
integer y = 1868
integer width = 411
integer height = 200
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_qct_02020
integer x = 2455
integer y = 1868
integer width = 1143
integer height = 200
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_1 from u_key_enter within w_qct_02020
event ue_key pbm_dwnkey
integer x = 37
integer y = 28
integer width = 1280
integer height = 188
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_02020_01"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;return 1
end event

event itemchanged;String s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" Then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "edate" Then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if	
elseif (this.GetColumnName() = "empno") Then
	i_rtn = f_get_name2("사번", "N", s_cod, s_nam1, s_nam2)
	this.object.empno[1] = s_cod
	this.object.empnm[1] = s_nam1
	return i_rtn
end if	
return


end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "empno"	THEN		
	open(w_sawon_popup)
	this.SetItem(1, "empno", gs_code)
	this.SetItem(1, "empnm", gs_codename)
	return 
END IF
end event

type dw_sel from datawindow within w_qct_02020
integer x = 37
integer y = 224
integer width = 1349
integer height = 1644
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_qct_02020_02"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;this.SelectRow(0,False)

if Row <= 0 then return
this.SelectRow(0, FALSE)
this.SelectRow(Row,TRUE)
if dw_insert.Retrieve(gs_sabu, Trim(this.object.prop_jpno[Row])) < 1 then
	dw_insert.Enabled = True
	rb_new.checked = True
else
	rb_mod.checked = True
	dw_insert.object.prop_jpno_t.visible = True
   dw_insert.object.prop_jpno.visible = True
	if dw_insert.object.jests[1] = "1" then
		sle_msg.Text = ""
		dw_insert.Enabled = True
		dw_sel.SetFocus()
		dw_insert.SetColumn("prop_jpno")
      dw_insert.SetFocus()
	else
		sle_msg.Text = "채택된 내용은 수정이 불가능합니다![제안상태 확인]"
		if not (IsNull(Trim(dw_insert.object.wandat[1])) or Trim(dw_insert.object.wandat[1]) = "") then
			dw_insert.object.jests[1] = "5"
		end if	
		dw_insert.Enabled = False
	end if	
end if	
end event

type rb_new from radiobutton within w_qct_02020
integer x = 1495
integer y = 92
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "등록"
end type

event clicked;dw_insert.Enabled = True
dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)
dw_insert.object.prop_jpno_t.visible = False
dw_insert.object.prop_jpno.visible = False
dw_insert.SetColumn("kwa_no")
dw_insert.SetFocus()

ib_any_typing = False //입력필드 변경여부 No
end event

type rb_mod from radiobutton within w_qct_02020
integer x = 1838
integer y = 92
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "수정"
end type

event clicked;dw_insert.Enabled = True
dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)
dw_insert.object.prop_jpno_t.visible = True
dw_insert.object.prop_jpno.visible = True
dw_insert.SetColumn("prop_jpno")
dw_insert.SetFocus()

ib_any_typing = False //입력필드 변경여부 No
end event

type pb_1 from u_pb_cal within w_qct_02020
integer x = 622
integer y = 32
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_02020
integer x = 1047
integer y = 32
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'edate', gs_code)
end event

