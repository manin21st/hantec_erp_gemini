$PBExportHeader$w_qct_02010.srw
$PBExportComments$** 제안목표등록(부서별)
forward
global type w_qct_02010 from w_inherite
end type
type dw_1 from u_key_enter within w_qct_02010
end type
type gb_2 from groupbox within w_qct_02010
end type
type gb_1 from groupbox within w_qct_02010
end type
end forward

global type w_qct_02010 from w_inherite
string title = "제안 목표 등록(부서별)"
long backcolor = 12632256
dw_1 dw_1
gb_2 gb_2
gb_1 gb_1
end type
global w_qct_02010 w_qct_02010

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크 + Fill
Long mon, lval
String scol

dw_insert.object.sabu[1] = gs_sabu
dw_insert.object.mokyy[1] = dw_1.object.mokyy[1]
dw_insert.object.dptno[1] = dw_1.object.dptno[1]

if IsNull(Trim(dw_insert.object.mokyy[1])) or Trim(dw_insert.object.mokyy[1]) = "" then
	f_message_chk(35, "[기준년도]")
	return -1
end if	
if IsNull(Trim(dw_insert.object.dptno[1])) or Trim(dw_insert.object.dptno[1]) = "" then
	f_message_chk(35, "[부서코드]")
	return -1
end if	

if IsNull(Trim(dw_insert.object.updept[1])) or Trim(dw_insert.object.updept[1]) = "" then
	f_message_chk(35, "[상위부서]")
	dw_insert.SetColumn("updept")
	dw_insert.SetFocus()
	return -1
end if	

for mon = 1 to 12 
	scol = "propln_dpt_genil_" + String(mon, "00")
	lval = dw_insert.GetItemNumber(1, scol)
	if IsNull(lval) then dw_insert.SetItem(1, scol, 0)
		
	scol = "propln_dpt_temil_" + String(mon, "00")
	lval = dw_insert.GetItemNumber(1, scol)
	if IsNull(lval) then dw_insert.SetItem(1, scol, 0)
		
	scol = "propln_dpt_gench_" + String(mon, "00")
	lval = dw_insert.GetItemNumber(1, scol)
	if IsNull(lval) then dw_insert.SetItem(1, scol, 0)
	
	scol = "propln_dpt_temch_" + String(mon, "00")
	lval = dw_insert.GetItemNumber(1, scol)
	if IsNull(lval) then dw_insert.SetItem(1, scol, 0)
	
	scol = "propln_dpt_genam_" + String(mon, "00")
	lval = dw_insert.GetItemNumber(1, scol)
	if IsNull(lval) then dw_insert.SetItem(1, scol, 0)
		
	scol = "propln_dpt_temam_" + String(mon, "00")
	lval = dw_insert.GetItemNumber(1, scol)
	if IsNull(lval) then dw_insert.SetItem(1, scol, 0)
next 

dw_insert.AcceptText()

return 1
end function

on w_qct_02010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
end on

on w_qct_02010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

sle_msg.Text = "기준년도와 부서를 입력한 다음 조회 버튼을 CLICK 하세요!"
dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.Setredraw(True)
dw_1.SetFocus()



end event

type dw_insert from w_inherite`dw_insert within w_qct_02010
integer x = 14
integer y = 136
integer width = 3616
integer height = 1712
integer taborder = 30
string dataobject = "d_qct_02010_02"
boolean border = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;String  s_cod, s_nam1, s_nam2
integer i_rtn

sle_msg.text = ""
ib_any_typing = True //입력필드 변경여부 Yes

s_cod = Trim(this.GetText())

if this.GetColumnName() = "updept" Then	
	i_rtn = f_get_name2("부서","Y", s_cod, s_nam1, s_nam2)
	this.object.updept[1] = s_cod
	this.object.updeptnm[1] = s_nam1
	return i_rtn
end if
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "updept"	THEN		
	open(w_vndmst_4_popup)
	this.SetItem(1, "updept", gs_code)
	this.SetItem(1, "updeptnm", gs_codename)
	return 
END IF
end event

type cb_exit from w_inherite`cb_exit within w_qct_02010
integer x = 3255
integer y = 1932
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_qct_02010
integer x = 2213
integer y = 1932
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;string s_sabu, s_mokyy

if f_msg_update() = -1 then return
if wf_required_chk() = -1 then return //필수입력항목 체크 
if dw_insert.AcceptText() = -1 then return

IF dw_insert.Update() > 0 THEN		
	COMMIT;
	sle_msg.Text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	sle_msg.Text = "저장작업 실패!"
	return
END IF

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_ins from w_inherite`cb_ins within w_qct_02010
boolean visible = false
integer taborder = 80
end type

type cb_del from w_inherite`cb_del within w_qct_02010
integer x = 2560
integer y = 1932
integer taborder = 50
end type

event cb_del::clicked;call super::clicked;if f_msg_delete() = -1 then return

dw_insert.SetReDraw(False)
dw_insert.DeleteRow(1)
if dw_insert.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[삭제실패]') 
	sle_msg.Text = "삭제 작업 실패!"
	Return
else
   COMMIT;		
end if
dw_insert.SetReDraw(True)

dw_1.SetReDraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.SetReDraw(True)
dw_1.SetFocus()


sle_msg.Text = "삭제 되었습니다!"
ib_any_typing = False //입력필드 변경여부 No
end event

type cb_inq from w_inherite`cb_inq within w_qct_02010
integer x = 59
integer y = 1932
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;String s_mokyy, s_dptno, cod, nam

sle_msg.Text = ""

if dw_1.AcceptText() = -1 then 
	dw_1.SetFocus()
	return
end if
s_mokyy = dw_1.object.mokyy[1]
s_dptno = dw_1.object.dptno[1]

if IsNull(s_mokyy) or s_mokyy = '' then
	f_message_chk(35, "[기준년도]")
	dw_1.SetColumn("mokyy")
	dw_1.SetFocus()
	return 
end if 

if IsNull(s_dptno) or s_dptno = '' then
	f_message_chk(35, "[부서코드]")
	dw_1.SetColumn("dptno")
	dw_1.SetFocus()
	return 
end if 

dw_insert.Enabled = True

dw_insert.SetRedraw(False)
if dw_insert.Retrieve(gs_sabu, s_mokyy, s_dptno) < 1 then
   dw_insert.ReSet()
	dw_insert.InsertRow(0)
		
	select p0.updept, v.cvnas2 into :cod, :nam
	  from p0_dept p0, vndmst v
	 where p0.deptcode = :s_dptno
	   and p0.updept = v.cvcod (+);
	if sqlca.sqlcode <> 0 then
		cod = ""
		nam = ""
	end if	
	dw_insert.object.updept[1] = cod	
	dw_insert.object.updeptnm[1] = nam	 
	sle_msg.Text = "신규로 등록하세요!"	
end if	
dw_insert.SetRedraw(True)

dw_insert.SetFocus() 
end event

type cb_print from w_inherite`cb_print within w_qct_02010
boolean visible = false
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_qct_02010
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qct_02010
integer x = 2907
integer y = 1932
end type

event cb_can::clicked;call super::clicked;sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.Setredraw(True)
dw_1.SetFocus()

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_search from w_inherite`cb_search within w_qct_02010
boolean visible = false
integer x = 1371
integer y = 1956
integer taborder = 100
end type



type sle_msg from w_inherite`sle_msg within w_qct_02010
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qct_02010
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_02010
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_02010
end type

type dw_1 from u_key_enter within w_qct_02010
event ue_key pbm_dwnkey
integer x = 32
integer y = 16
integer width = 1806
integer height = 108
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_02010_01"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	this.TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;return 1
end event

event itemchanged;String  s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "mokyy" Then
	if f_datechk(s_cod + "0101") = -1 then
		f_message_chk(35, "[기준년도]")
		this.object.mokyy[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "dptno" Then	
	i_rtn = f_get_name2("부서","N", s_cod, s_nam1, s_nam2)
	this.object.dptno[1] = s_cod
	this.object.dptnm[1] = s_nam1
	return i_rtn
end if	
end event

event getfocus;dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.Setredraw(True)
dw_insert.Enabled = False


end event

event rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "dptno"	THEN		
	open(w_vndmst_4_popup)
	this.SetItem(1, "dptno", gs_code)
	this.SetItem(1, "dptnm", gs_codename)
	return 
END IF
end event

type gb_2 from groupbox within w_qct_02010
integer x = 2171
integer y = 1876
integer width = 1458
integer height = 192
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_qct_02010
integer x = 23
integer y = 1876
integer width = 411
integer height = 192
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

