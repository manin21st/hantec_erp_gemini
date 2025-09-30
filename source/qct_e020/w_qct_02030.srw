$PBExportHeader$w_qct_02030.srw
$PBExportComments$** 제안 심사 등록
forward
global type w_qct_02030 from w_inherite
end type
type gb_3 from groupbox within w_qct_02030
end type
type gb_2 from groupbox within w_qct_02030
end type
type gb_1 from groupbox within w_qct_02030
end type
type dw_1 from u_key_enter within w_qct_02030
end type
type pb_1 from u_pb_cal within w_qct_02030
end type
type pb_2 from u_pb_cal within w_qct_02030
end type
end forward

global type w_qct_02030 from w_inherite
string title = "제안 심사 등록"
long backcolor = 12632256
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
end type
global w_qct_02030 w_qct_02030

forward prototypes
public function real wf_projum (string gu)
public function decimal wf_sisang_amt (string gu)
end prototypes

public function real wf_projum (string gu);//제안 심사등급에 따른 심사점수 가져옴

real jum

select rfna2 
  into :jum
  from reffpf
 where rfcod = '23'
   and rfgub = :gu;
	
if sqlca.sqlcode = 0 then
	return jum
else	
	return -1
end if	
end function

public function decimal wf_sisang_amt (string gu);//제안 심사등급에 따른 시상금 가져옴

dec {0} damt

select rfna4
  into :damt
  from reffpf
 where rfcod = '23'
   and rfgub = :gu;
	
if sqlca.sqlcode = 0 then
	return damt
else	
	return 0
end if	
end function

on w_qct_02030.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
end on

on w_qct_02030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Setredraw(True)

dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.Setredraw(True)
dw_1.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_02030
integer x = 41
integer y = 240
integer width = 3561
integer height = 1628
integer taborder = 30
string dataobject = "d_qct_02030_02"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;String s_lvl, s_temp
Long l_row
dec{2} dJum

sle_msg.text = ""
ib_any_typing = True //입력필드 변경여부 Yes
l_row = this.GetRow()

if this.GetColumnName() = "prolvl" then
	s_lvl = Trim(this.GetText())
   
	//등급이 등록되면 심사완료
	if IsNull(s_lvl) or s_lvl = "" then
		this.object.jests[l_row] = "1" 
		this.object.projum[l_row] = 0
		this.object.sisang_amt[l_row] = 0
		return
	end if	
	
	this.object.jests[l_row] = "2"
	//등급에 따른 제안 점수 계산
	dJum = wf_projum(s_lvl)
	this.object.projum[l_row] = dJum
	this.object.sisang_amt[l_row] = wf_sisang_amt(s_lvl)
	if this.object.projum[l_row] < -0.5 then
		this.object.prolvl[l_row] = ""
		this.object.projum[l_row] = 0
		this.object.sisang_amt[l_row] = 0
		this.object.jests[l_row] = "1" 
		MessageBox("제안점수 확인","제안점수가 등록되지 않은 자료입니다!~n~n" + &
		                           "참조코드 23번을 확인 하세요!")
		return 1
	end if	
end if	

return

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemfocuschanged;if (this.GetColumnName() = "prop_name") or (this.GetColumnName() = "bunim") Then
	f_toggle_kor(handle(this))
else	 
	f_toggle_eng(handle(this))
end if	
end event

type p_delrow from w_inherite`p_delrow within w_qct_02030
end type

type p_addrow from w_inherite`p_addrow within w_qct_02030
end type

type p_search from w_inherite`p_search within w_qct_02030
end type

type p_ins from w_inherite`p_ins within w_qct_02030
end type

type p_exit from w_inherite`p_exit within w_qct_02030
end type

type p_can from w_inherite`p_can within w_qct_02030
end type

type p_print from w_inherite`p_print within w_qct_02030
end type

type p_inq from w_inherite`p_inq within w_qct_02030
end type

type p_del from w_inherite`p_del within w_qct_02030
end type

type p_mod from w_inherite`p_mod within w_qct_02030
end type

type cb_exit from w_inherite`cb_exit within w_qct_02030
integer x = 3232
integer y = 1936
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_qct_02030
integer x = 2496
integer y = 1936
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;string s_sabu, s_mokyy

if dw_insert.AcceptText() = -1 then 
	dw_insert.SetFocus()
	return 
end if

if dw_insert.RowCount() < 1 then
	messagebox("자료확인", "등록할 자료가 없습니다!")
	return
end if	

if f_msg_update() = -1 then return

IF dw_insert.Update() > 0 THEN		
	COMMIT;
	cb_inq.TriggerEvent(Clicked!)
	sle_msg.Text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	sle_msg.Text = "저장작업 실패!"
END IF


end event

type cb_ins from w_inherite`cb_ins within w_qct_02030
boolean visible = false
integer taborder = 70
end type

type cb_del from w_inherite`cb_del within w_qct_02030
boolean visible = false
integer x = 923
integer taborder = 80
end type

type cb_inq from w_inherite`cb_inq within w_qct_02030
integer x = 73
integer y = 1936
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;String sdate, edate, gu, dpt, emp, simdpt

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return 
end if	

simdpt = Trim(dw_1.object.simdpt[1])
sdate = Trim(dw_1.object.sdate[1])
edate = Trim(dw_1.object.edate[1])
gu = Trim(dw_1.object.jests[1])
dpt = Trim(dw_1.object.prodpt[1])
emp = Trim(dw_1.object.empno[1])

if IsNull(simdpt) or simdpt = "" then
	f_message_chk(30, "[심사부서]")
   dw_1.SetColumn("simdpt")
	dw_1.SetFocus()
	return
end if

if IsNull(sdate) or sdate = '' then sdate = "10000101"
if IsNull(edate) or edate = '' then edate = "99991231"
if IsNull(gu) or gu = "" then
	f_message_chk(30, "[구분]")
   dw_1.SetColumn("jests")
	dw_1.SetFocus()
	return
end if

if IsNull(dpt) or dpt = "" then
	dpt = "%"
else
	dpt = dpt + "%"
end if

if IsNull(emp) or emp = "" then
	emp = "%"
else
	emp = emp + "%"
end if	

if dw_insert.Retrieve(gs_sabu, simdpt, sdate, edate, gu, dpt, emp) < 1 then
	//f_message_chk(50, "[제안 심사 등록]")
	sle_msg.text = "등록된 제안제출 자료가 없습니다!"
end if	

ib_any_typing = False //입력필드 변경여부 No

end event

type cb_print from w_inherite`cb_print within w_qct_02030
boolean visible = false
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_qct_02030
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qct_02030
integer x = 2871
integer y = 1936
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;sle_msg.text =""

IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

cb_inq.TriggerEvent(Clicked!)

end event

type cb_search from w_inherite`cb_search within w_qct_02030
boolean visible = false
integer x = 1371
integer y = 1956
integer taborder = 100
end type



type sle_msg from w_inherite`sle_msg within w_qct_02030
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qct_02030
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_02030
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_02030
end type

type gb_3 from groupbox within w_qct_02030
integer x = 41
integer width = 3561
integer height = 232
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_qct_02030
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

type gb_1 from groupbox within w_qct_02030
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

type dw_1 from u_key_enter within w_qct_02030
event ue_key pbm_dwnkey
integer x = 137
integer y = 40
integer width = 3333
integer height = 180
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_02030_01"
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

s_cod = Trim(this.getText())

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
elseif (this.GetColumnName() = "prodpt") Then
	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
	this.object.prodpt[1] = s_cod
	this.object.dptnm[1] = s_nam1
	return i_rtn
elseif (this.GetColumnName() = "empno") Then
	i_rtn = f_get_name2("사번", "N", s_cod, s_nam1, s_nam2)
	this.object.empno[1] = s_cod
	this.object.empnm[1] = s_nam1
	return i_rtn
end if
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "prodpt"	THEN		
	open(w_vndmst_4_popup)
	this.SetItem(1, "prodpt", gs_code)
	this.SetItem(1, "dptnm", gs_codename)
	return 
elseif this.getcolumnname() = "empno" THEN		
	open(w_sawon_popup)
	this.SetItem(1, "empno", gs_code)
	this.SetItem(1, "empnm", gs_codename)
	return 
END IF
end event

event getfocus;//dw_insert.SetRedraw(False)
//dw_insert.ReSet()
//dw_insert.SetRedraw(True)
end event

type pb_1 from u_pb_cal within w_qct_02030
integer x = 1701
integer y = 44
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_02030
integer x = 2158
integer y = 44
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'edate', gs_code)
end event

