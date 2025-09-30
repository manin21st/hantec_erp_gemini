$PBExportHeader$w_qct_02000.srw
$PBExportComments$** 제안목표등록(개인별)
forward
global type w_qct_02000 from w_inherite
end type
type gb_5 from groupbox within w_qct_02000
end type
type gb_2 from groupbox within w_qct_02000
end type
type gb_1 from groupbox within w_qct_02000
end type
type dw_1 from u_key_enter within w_qct_02000
end type
type dw_ins from datawindow within w_qct_02000
end type
end forward

global type w_qct_02000 from w_inherite
integer height = 2404
string title = "제안 목표 등록(개인별)"
long backcolor = 12632256
gb_5 gb_5
gb_2 gb_2
gb_1 gb_1
dw_1 dw_1
dw_ins dw_ins
end type
global w_qct_02000 w_qct_02000

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크 + Fill
Long i, j, lval
String scol

if Isnull(Trim(dw_1.object.mokyy[1])) or Trim(dw_1.object.mokyy[1]) = "" then
  	f_message_chk(1400,'[기준년도]')
	dw_1.SetColumn('mokyy')
	dw_1.SetFocus()
	return -1
end if	

for i = 1 to dw_insert.RowCount()
   dw_insert.object.sabu[i] = gs_sabu
	dw_insert.object.mokyy[i] = dw_1.object.mokyy[1]
	dw_insert.object.empno[i] = Trim(dw_insert.object.p1_master_empno[i])
	for j = 1 to 12 
		scol = "gen" + String(j, "00")
		lval = dw_insert.GetItemNumber(i, scol)
		if IsNull(lval) then dw_insert.SetItem(i, scol, 0)
		
		scol = "tem" + String(j, "00")
		lval = dw_insert.GetItemNumber(i, scol)
		if IsNull(lval) then dw_insert.SetItem(i, scol, 0)
	next 
next

dw_insert.AcceptText()
dw_ins.Reset()

if dw_insert.RowsCopy(1, dw_insert.RowCount(), Primary!, dw_ins, 1, Primary!) <> 1 then
   f_message_chk(32, "[저장실패-RowsCopy]")
	return -1
end if

return 1
end function

on w_qct_02000.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_1=create dw_1
this.dw_ins=create dw_ins
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_ins
end on

on w_qct_02000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.dw_ins)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.Setredraw(True)
dw_1.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_02000
integer x = 41
integer y = 148
integer width = 3552
integer height = 1704
integer taborder = 30
string dataobject = "d_qct_02000_02"
boolean vscrollbar = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;this.AcceptText()
sle_msg.text = ""
ib_any_typing = True //입력필드 변경여부 Yes
end event

event dw_insert::itemerror;return 1
end event

type cb_exit from w_inherite`cb_exit within w_qct_02000
integer y = 1932
end type

type cb_mod from w_inherite`cb_mod within w_qct_02000
integer x = 2496
integer y = 1932
integer taborder = 60
end type

event cb_mod::clicked;call super::clicked;string s_sabu, s_mokyy, s_buse

if f_msg_update() = -1 then return
if dw_insert.AcceptText() = -1 then return
if wf_required_chk() = -1 then return //필수입력항목 체크 
if dw_ins.AcceptText() = -1 then return

s_sabu = Trim(dw_ins.object.sabu[1])
s_mokyy = Trim(dw_ins.object.mokyy[1])
s_buse = Trim(dw_1.object.buse[1])

delete from propln_emp p
 where p.sabu = :s_sabu
   and p.mokyy = :s_mokyy
   and p.empno = (select m.empno 
                  from p1_master m
                 where m.deptcode = :s_buse
                   and m.empno = p.empno);   
						 
if sqlca.sqlcode <> 0 then
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	sle_msg.Text = "저장작업 실패!"
	return
END IF

IF dw_ins.Update() > 0 THEN		
	COMMIT;
	sle_msg.Text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	sle_msg.Text = "저장작업 실패!"
END IF

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_ins from w_inherite`cb_ins within w_qct_02000
boolean visible = false
integer taborder = 0
end type

type cb_del from w_inherite`cb_del within w_qct_02000
boolean visible = false
integer x = 923
integer taborder = 0
end type

type cb_inq from w_inherite`cb_inq within w_qct_02000
integer x = 73
integer y = 1932
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;String s_mokyy, s_buse

if dw_1.AcceptText() = -1 then 
	dw_1.SetFocus()
	return
end if	

s_mokyy = dw_1.object.mokyy[1]
s_buse = dw_1.object.buse[1]

if IsNull(s_mokyy) or s_mokyy = '' then
	f_message_chk(35, "[기준년도]")
	dw_1.SetColumn("mokyy")
	dw_1.SetFocus()
	return 
end if

if IsNull(s_buse)	or s_buse = ''	then
	f_message_chk(30, "[부서코드]")
	dw_1.SetColumn("buse")
	dw_1.SetFocus()
	return
end if

dw_insert.SetRedraw(False)
dw_insert.ReSet()
if dw_insert.Retrieve(s_mokyy, s_buse) > 0 then
	dw_insert.SetFocus()
else
	MessageBox("부서확인","사원마스터에 해당부서로 등록된 사원이 없습니다!")
end if	
dw_insert.SetRedraw(True)
end event

type cb_print from w_inherite`cb_print within w_qct_02000
integer x = 1376
integer y = 1932
integer width = 517
integer textsize = -9
string text = "선택처리(&Q)"
end type

event cb_print::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return

gs_code = dw_1.object.mokyy[1]

open(w_qct_02000_popup)

if dw_insert.rowcount() > 0 then 
	cb_inq.triggerevent(clicked!)
end if
end event

type st_1 from w_inherite`st_1 within w_qct_02000
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qct_02000
integer x = 2857
integer y = 1932
end type

event cb_can::clicked;call super::clicked;sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

cb_inq.TriggerEvent(Clicked!)
ib_any_typing = False //입력필드 변경여부 No
end event

type cb_search from w_inherite`cb_search within w_qct_02000
integer x = 846
integer y = 1932
integer width = 517
integer taborder = 40
integer textsize = -9
string text = "부서별처리(&W)"
end type

event cb_search::clicked;call super::clicked;Long crow, i

if dw_insert.AcceptText() = -1 then return

crow = dw_insert.GetRow()

if crow < 1 or crow > dw_insert.RowCount() then
	MessageBox("사원 선택","사원을 먼저 선택하세요!")
	return
end if

if MessageBox("기준 적용", "'" + String(dw_insert.object.p1_master_empname[crow]) + "' " + & 
  "의 목표치로 해당부서의 모든 사원을 일괄적용 하시겠습니까?",Question!, YesNo!, 2) = 2 then return

for i = 1 to crow - 1
    dw_insert.object.gen01[i] = dw_insert.object.gen01[crow]
    dw_insert.object.gen02[i] = dw_insert.object.gen02[crow]
	 dw_insert.object.gen03[i] = dw_insert.object.gen03[crow]
    dw_insert.object.gen04[i] = dw_insert.object.gen04[crow]
	 dw_insert.object.gen05[i] = dw_insert.object.gen05[crow]
    dw_insert.object.gen06[i] = dw_insert.object.gen06[crow]
	 dw_insert.object.gen07[i] = dw_insert.object.gen07[crow]
    dw_insert.object.gen08[i] = dw_insert.object.gen08[crow]
	 dw_insert.object.gen09[i] = dw_insert.object.gen09[crow]
    dw_insert.object.gen10[i] = dw_insert.object.gen10[crow]
	 dw_insert.object.gen11[i] = dw_insert.object.gen11[crow]
    dw_insert.object.gen12[i] = dw_insert.object.gen12[crow]

    dw_insert.object.tem01[i] = dw_insert.object.tem01[crow]
    dw_insert.object.tem02[i] = dw_insert.object.tem02[crow]
	 dw_insert.object.tem03[i] = dw_insert.object.tem03[crow]
    dw_insert.object.tem04[i] = dw_insert.object.tem04[crow]
	 dw_insert.object.tem05[i] = dw_insert.object.tem05[crow]
    dw_insert.object.tem06[i] = dw_insert.object.tem06[crow]
	 dw_insert.object.tem07[i] = dw_insert.object.tem07[crow]
    dw_insert.object.tem08[i] = dw_insert.object.tem08[crow]
	 dw_insert.object.tem09[i] = dw_insert.object.tem09[crow]
    dw_insert.object.tem10[i] = dw_insert.object.tem10[crow]
	 dw_insert.object.tem11[i] = dw_insert.object.tem11[crow]
    dw_insert.object.tem12[i] = dw_insert.object.tem12[crow]
next

if crow >= dw_insert.RowCount() then return
for i = crow + 1 to dw_insert.RowCount()
    dw_insert.object.gen01[i] = dw_insert.object.gen01[crow]
    dw_insert.object.gen02[i] = dw_insert.object.gen02[crow]
	 dw_insert.object.gen03[i] = dw_insert.object.gen03[crow]
    dw_insert.object.gen04[i] = dw_insert.object.gen04[crow]
	 dw_insert.object.gen05[i] = dw_insert.object.gen05[crow]
    dw_insert.object.gen06[i] = dw_insert.object.gen06[crow]
	 dw_insert.object.gen07[i] = dw_insert.object.gen07[crow]
    dw_insert.object.gen08[i] = dw_insert.object.gen08[crow]
	 dw_insert.object.gen09[i] = dw_insert.object.gen09[crow]
    dw_insert.object.gen10[i] = dw_insert.object.gen10[crow]
	 dw_insert.object.gen11[i] = dw_insert.object.gen11[crow]
    dw_insert.object.gen12[i] = dw_insert.object.gen12[crow]

    dw_insert.object.tem01[i] = dw_insert.object.tem01[crow]
    dw_insert.object.tem02[i] = dw_insert.object.tem02[crow]
	 dw_insert.object.tem03[i] = dw_insert.object.tem03[crow]
    dw_insert.object.tem04[i] = dw_insert.object.tem04[crow]
	 dw_insert.object.tem05[i] = dw_insert.object.tem05[crow]
    dw_insert.object.tem06[i] = dw_insert.object.tem06[crow]
	 dw_insert.object.tem07[i] = dw_insert.object.tem07[crow]
    dw_insert.object.tem08[i] = dw_insert.object.tem08[crow]
	 dw_insert.object.tem09[i] = dw_insert.object.tem09[crow]
    dw_insert.object.tem10[i] = dw_insert.object.tem10[crow]
	 dw_insert.object.tem11[i] = dw_insert.object.tem11[crow]
    dw_insert.object.tem12[i] = dw_insert.object.tem12[crow]
next

end event



type sle_msg from w_inherite`sle_msg within w_qct_02000
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qct_02000
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_02000
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_02000
end type

type gb_5 from groupbox within w_qct_02000
integer x = 786
integer y = 1872
integer width = 1157
integer height = 196
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "기준적용"
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_qct_02000
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
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_qct_02000
integer x = 2450
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
borderstyle borderstyle = stylelowered!
end type

type dw_1 from u_key_enter within w_qct_02000
event ue_key pbm_dwnkey
integer x = 37
integer y = 28
integer width = 1682
integer height = 108
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_02000_01"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "buse"	THEN		
	open(w_vndmst_4_popup)
	this.SetItem(1, "buse", gs_code)
	this.SetItem(1, "bunm", gs_codename)
	return 
END IF
end event

event itemerror;return 1
end event

event itemchanged;String  s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if (this.GetColumnName() = "mokyy") Then
	if f_datechk(s_cod + "0101") = -1 then
		f_message_chk(35, "[기준년도]")
		this.object.mokyy[1] = ""
		return 1
	end if	
elseif (this.GetColumnName() = "buse") Then
	i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
	this.object.buse[1] = s_cod
	this.object.bunm[1] = s_nam1
	return i_rtn
end if	
end event

event getfocus;dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.SetRedraw(True)
end event

type dw_ins from datawindow within w_qct_02000
boolean visible = false
integer x = 183
integer y = 1116
integer width = 3227
integer height = 360
boolean bringtotop = true
string dataobject = "d_qct_02000_02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

