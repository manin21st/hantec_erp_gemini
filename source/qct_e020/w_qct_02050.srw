$PBExportHeader$w_qct_02050.srw
$PBExportComments$** 제안 실시 결과 등록
forward
global type w_qct_02050 from w_inherite
end type
type gb_3 from groupbox within w_qct_02050
end type
type gb_2 from groupbox within w_qct_02050
end type
type gb_1 from groupbox within w_qct_02050
end type
type dw_1 from u_key_enter within w_qct_02050
end type
type pb_1 from u_pb_cal within w_qct_02050
end type
type pb_2 from u_pb_cal within w_qct_02050
end type
type pb_3 from u_pb_cal within w_qct_02050
end type
type pb_4 from u_pb_cal within w_qct_02050
end type
end forward

global type w_qct_02050 from w_inherite
string title = "제안 실시 결과 등록"
long backcolor = 12632256
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
end type
global w_qct_02050 w_qct_02050

forward prototypes
public function integer wf_required_chk ()
public function integer wf_change_gu (string jpno, string gu, long irow)
end prototypes

public function integer wf_required_chk ();//Long   i, lrow
//
//lCount = dw_insert.RowCount()
//for i = 1 to lCount 
//	if dw_insert.object.propms_jests[i] = '3' then
//		if IsNull(Trim(dw_insert.object.propms_wandat[i])) or &
//			  IsNull(dw_insert.object.propms_soyamt[i]) or &
//			   IsNull(dw_insert.object.propms_julamt[i]) then
//		   messagebox("[실시자료 입력실패]", String(i) + " 번째 ROW~n~n" & 
//			           + "제안일자 : " + String(dw_insert.object.propms_prodat[i], "@@@@.@@.@@") + "~n~n" &
//						  + "제안번호 : " + String(dw_insert.object.propms_prop_jpno[i], "@@@@@@@@-@@@@") + "~n~n" &
//						  + "완료일자, 소요경비,절감금액, 1차확일자는 모두 입력하여야 합니다!")
//		   return -1
//		end if
//	end if	
//next
//
return 1
end function

public function integer wf_change_gu (string jpno, string gu, long irow);Integer iReturn

if gu = '3' then //미실시 -> 실시

	iReturn = MessageBox("미실시 지연사유 삭제","미실시 지연사유를 삭제 하시겠습니까?",Question!, YesNo!, 2)
	if iReturn = 2 then 
		dw_insert.object.propms_jests[irow] = '4'
		return -1		
	end if

	delete from propms_misil
	 where sabu = :gs_sabu and prop_jpno = :jpno;
	 
	if sqlca.sqlcode = 0 then
		commit;
	else
		rollback;
		f_message_chk(32,"[미실시 지연사유 삭제 실패]")
		return -1
	end if	
else             //실시 -> 미실시
	gs_code = jpno
	open(w_qct_02050_popup)
	
	dw_insert.object.propms_wandat[irow] = ""
	dw_insert.object.propms_soyamt[irow] = 0
	dw_insert.object.propms_julamt[irow] = 0
	dw_insert.object.propms_silsi_amt[irow] = 0
end if	
return 1

end function

on w_qct_02050.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.pb_3
this.Control[iCurrent+8]=this.pb_4
end on

on w_qct_02050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_1.InsertRow(0)
dw_1.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_02050
integer x = 41
integer y = 260
integer width = 3552
integer height = 1628
integer taborder = 30
string dataobject = "d_qct_02050_02"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;String s_cod, jpno

s_cod = Trim(this.getText())

if this.GetColumnName() = "propms_jests" Then //구분 : 3-실시, 4-미실시
   //실시 <-> 미실시변경의 경우 제안번호, 실시구분, 현재Row을 넘겨줌
   jpno = this.object.propms_prop_jpno[row]
	if wf_change_gu(jpno, s_cod, row) = -1 then
		return 1 
	end if	
elseif this.GetColumnName() = "propms_wandat" Then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[완료일자]")
		return 1
	end if	
end if	

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::buttonclicked;If row <= 0 Then Return 
gs_code = this.object.propms_prop_jpno[row]
open(w_qct_02050_popup)
	
end event

type p_delrow from w_inherite`p_delrow within w_qct_02050
end type

type p_addrow from w_inherite`p_addrow within w_qct_02050
end type

type p_search from w_inherite`p_search within w_qct_02050
end type

type p_ins from w_inherite`p_ins within w_qct_02050
end type

type p_exit from w_inherite`p_exit within w_qct_02050
end type

type p_can from w_inherite`p_can within w_qct_02050
end type

type p_print from w_inherite`p_print within w_qct_02050
end type

type p_inq from w_inherite`p_inq within w_qct_02050
end type

type p_del from w_inherite`p_del within w_qct_02050
end type

type p_mod from w_inherite`p_mod within w_qct_02050
end type

type cb_exit from w_inherite`cb_exit within w_qct_02050
integer x = 3223
integer y = 1936
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_qct_02050
integer x = 2501
integer y = 1936
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;if dw_1.accepttext() = -1 then return
if dw_insert.accepttext() = -1 then return
if wf_required_chk() = -1 then return

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

type cb_ins from w_inherite`cb_ins within w_qct_02050
boolean visible = false
end type

type cb_del from w_inherite`cb_del within w_qct_02050
boolean visible = false
integer x = 923
end type

type cb_inq from w_inherite`cb_inq within w_qct_02050
integer x = 73
integer y = 1936
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;String dpt, sdate, edate, gu, day1, day2, simdpt

if dw_1.AcceptText() = -1 then
	dw_1.SetFocus()
	return 
end if	

dpt   = Trim(dw_1.object.prodpt[1])
sdate = Trim(dw_1.object.sdate[1]) //완료예정일
edate = Trim(dw_1.object.edate[1])
gu    = Trim(dw_1.object.gu[1])
day1  = Trim(dw_1.object.day1[1])  //제안일자
day2  = Trim(dw_1.object.day2[1]) 
simdpt = Trim(dw_1.object.simdpt[1])

if IsNull(dpt) or dpt = "" then	
	dpt = "%"
else
	dpt = dpt + "%"
end if

if IsNull(simdpt) or simdpt = "" then	simdpt = "%"

if IsNull(sdate) or sdate = '' then sdate = "10000101"
if IsNull(edate) or edate = '' then edate = "99991231"
if IsNull(day1) or day1 = '' then day1 = "10000101"
if IsNull(day2) or day2 = '' then day2 = "99991231"

if IsNull(gu) or gu = "" then
	f_message_chk(30, "[구분]")
   dw_1.SetColumn("gu")
	dw_1.SetFocus()
	return
end if

dw_insert.setredraw(false)

if gu = "X" then //지시    
   dw_insert.SetFilter("isNull(propms_wandat) and propms_jests = '3'")
elseif gu = "O" then //결과 
	dw_insert.SetFilter("(not isNull(propms_wandat)) or propms_jests = '4'")
end if	
dw_insert.Filter( )

if dw_insert.Retrieve(gs_sabu, dpt, sdate, edate, day1, day2, simdpt) < 1 then
	sle_msg.text = "실시지시된 제안제출 자료가 없습니다!"
end if	

dw_insert.setredraw(true)

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_print from w_inherite`cb_print within w_qct_02050
boolean visible = false
end type

type st_1 from w_inherite`st_1 within w_qct_02050
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qct_02050
integer x = 2862
integer y = 1936
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;sle_msg.text =""

IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_insert.ReSet()
ib_any_typing = False //입력필드 변경여부 No
end event

type cb_search from w_inherite`cb_search within w_qct_02050
boolean visible = false
integer x = 1371
integer y = 1956
end type



type sle_msg from w_inherite`sle_msg within w_qct_02050
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qct_02050
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_02050
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_02050
end type

type gb_3 from groupbox within w_qct_02050
integer x = 41
integer y = 4
integer width = 3552
integer height = 240
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_qct_02050
integer x = 37
integer y = 1872
integer width = 411
integer height = 196
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_qct_02050
integer x = 2455
integer y = 1872
integer width = 1143
integer height = 196
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_1 from u_key_enter within w_qct_02050
event ue_key pbm_dwnkey
integer x = 165
integer y = 56
integer width = 3346
integer height = 180
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_02050_01"
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

if this.GetColumnName() = "day1" Then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[제안일자 FROM]")
		this.object.day1[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "day2" Then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[제안일자 TO]")
		this.object.day2[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "sdate" Then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[완료일자 FROM]")
		this.object.sdate[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "edate" Then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[완료일자 TO]")
		this.object.edate[1] = ""
		return 1
	end if	
elseif (this.GetColumnName() = "prodpt") Then
	i_rtn = f_get_name2("부서", "N", s_cod, s_nam1, s_nam2)
	this.object.prodpt[1] = s_cod
	this.object.dptnm[1] = s_nam1
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
END IF

end event

type pb_1 from u_pb_cal within w_qct_02050
integer x = 786
integer y = 132
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('day1')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'day1', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_02050
integer x = 1225
integer y = 136
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('day2')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'day2', gs_code)
end event

type pb_3 from u_pb_cal within w_qct_02050
integer x = 1957
integer y = 132
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'sdate', gs_code)
end event

type pb_4 from u_pb_cal within w_qct_02050
integer x = 2395
integer y = 136
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'edate', gs_code)
end event

