$PBExportHeader$w_qct_01120.srw
$PBExportComments$이상발생 조치등록
forward
global type w_qct_01120 from w_inherite
end type
type dw_ins from u_key_enter within w_qct_01120
end type
type cb_1 from commandbutton within w_qct_01120
end type
type dw_1 from u_key_enter within w_qct_01120
end type
type rr_1 from roundrectangle within w_qct_01120
end type
type rr_2 from roundrectangle within w_qct_01120
end type
end forward

global type w_qct_01120 from w_inherite
integer width = 4626
integer height = 2460
string title = "이상발생 조치등록"
dw_ins dw_ins
cb_1 cb_1
dw_1 dw_1
rr_1 rr_1
rr_2 rr_2
end type
global w_qct_01120 w_qct_01120

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
if dw_insert.AcceptText() = -1 then return -1
if dw_ins.AcceptText() = -1 then return -1

//if IsNull(dw_insert.object.woningu[1]) or  &
//   dw_insert.object.woningu[1] < 0 and dw_insert.object.woningu[1] > 2 then
//	f_message_chk(30, "[원인구분]")
//	return -1
//end if	
//if IsNull(Trim(dw_insert.object.siloi[1])) or Trim(dw_insert.object.siloi[1]) = "" then
//	f_message_chk(30, "[신뢰성시험여부]")
//	return -1
//end if	
//if IsNull(Trim(dw_insert.object.wonin[1])) or Trim(dw_insert.object.wonin[1]) = "" then
//	f_message_chk(30, "[원인]")
//	return -1
//end if	
//if IsNull(Trim(dw_insert.object.jajaesa[1])) or Trim(dw_insert.object.jajaesa[1]) = "" then
//	f_message_chk(30, "[자재사용유무]")
//	return -1
//end if	
////if dw_insert.object.jochdat[1] < dw_insert.object.occdat[1] then
////	MessageBox("조치일자 확인", "조치일자가 발생일자 이전인 자료는 등록되지 않습니다!")
////	return -1
////end if	
//
//dw_ins.object.sabu[1] = gs_sabu
//dw_ins.object.occjpno[1] = dw_insert.object.occjpno[1]
//		
dw_insert.AcceptText()
dw_ins.AcceptText()

return 1
end function

on w_qct_01120.create
int iCurrent
call super::create
this.dw_ins=create dw_ins
this.cb_1=create cb_1
this.dw_1=create dw_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ins
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rr_1
this.Control[iCurrent+5]=this.rr_2
end on

on w_qct_01120.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ins)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;string ls_deptname

dw_insert.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_insert.ReSet()
dw_insert.InsertRow(0)

dw_ins.ReSet()
dw_ins.InsertRow(0)

dw_insert.SetFocus()

dw_insert.object.year[1] = mid(f_today(), 1, 6)

select deptname 
  into :ls_deptname 
  from p0_dept 
  where deptcode = :gs_dept ;
  
  
dw_insert.object.deptcode[1] = gs_dept
dw_insert.object.deptname[1] = ls_deptname
  







end event

type dw_insert from w_inherite`dw_insert within w_qct_01120
integer x = 14
integer y = 184
integer width = 2277
integer height = 144
integer taborder = 20
string dataobject = "d_qct_01120_01"
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String  s_col, s_cod, s_nam1, s_nam2, snull
Integer i_rtn

ib_any_typing = True //입력필드 변경여부 Yes

s_col = this.GetColumnName()
s_cod = Trim(this.GetText())

s_nam1 = ""
s_nam2 = ""  

setnull(snull)
CHOOSE CASE s_col
//	CASE "occjpno" //문서번호
//		if IsNull(s_cod) or s_cod = "" then return
//		select occjpno
//		  into :s_nam1
//		  from occrpt
//		 where occjpno = :s_cod;
//		if sqlca.sqlcode <> 0 then
//			f_message_chk(33, "[문서번호]")
//		   this.object.occjpno[1] = ""
//			return 1
//		end if	
//		p_inq.TriggerEvent(Clicked!) //조회버튼 
	CASE "deptcode" //조치부서
		i_rtn = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
		this.object.deptcode[1] = s_cod
		this.object.deptname[1] = s_nam1
		return i_rtn
End Choose 
return

end event

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "deptcode" then //조치부서
	Open(w_dept_popup)

   this.object.deptcode[1] = gs_code
	this.object.deptname[1] = gs_codename
End if 
return
end event

event dw_insert::itemfocuschanged;call super::itemfocuschanged;if this.GetColumnName() = "jangdae" then
	f_toggle_kor(Handle(this))
else
	f_toggle_eng(Handle(this))
end if	
end event

event dw_insert::ue_pressenter;//Disable Accestor Script 
end event

type p_delrow from w_inherite`p_delrow within w_qct_01120
boolean visible = false
integer x = 4201
integer y = 3272
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qct_01120
boolean visible = false
integer x = 4027
integer y = 3272
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qct_01120
boolean visible = false
integer x = 3333
integer y = 3272
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_01120
boolean visible = false
integer x = 3854
integer y = 3272
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qct_01120
integer x = 4398
end type

type p_can from w_inherite`p_can within w_qct_01120
integer x = 4224
integer taborder = 60
end type

event p_can::clicked;call super::clicked;IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_qct_01120
boolean visible = false
integer x = 3506
integer y = 3272
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_01120
integer x = 3867
end type

event p_inq::clicked;call super::clicked;String ino, ls_occdat, ls_deptcode
Long   i, ll_count 


if dw_insert.AcceptText() = -1 then
	dw_insert.SetFocus()
	return -1
end if

ls_occdat = dw_insert.object.year[1]  
ls_deptcode = dw_insert.object.deptcode[1]


if trim(ls_deptcode) = '' or isnull(ls_deptcode) then 
	Messagebox('확인', '부서코드를 선택하십시오' ) 
	Return 
else
	select count(*) 
	  into :ll_count 
	  from p0_dept 
	 where deptcode = :ls_deptcode ; 
	
	 if ll_count < 1 or isnull(ll_count) then 
		 Messagebox('확인', '부서코드가 명확하지 않습니다. 부서코드를 확인하세요' ) 
		 Return 
	 End if 
End if 

long ll_row
ll_row  = dw_1.retrieve(ls_occdat, ls_deptcode)
dw_1.setredraw( true ) 


return
end event

type p_del from w_inherite`p_del within w_qct_01120
boolean visible = false
integer x = 4050
integer taborder = 50
end type

event p_del::clicked;call super::clicked;long i, lcRow

if f_msg_delete() = -1 then return

lcRow = dw_insert.GetRow()
dw_insert.SetRedraw(False)
//결과내역을 CLEAR
dw_insert.object.woningu[1] = 0
dw_insert.object.siloi[1] = ""
dw_insert.object.wonin[1] = ""
dw_insert.object.jajaesa[1] = ""
dw_insert.object.comdpt[1] = ""
dw_insert.object.comdptnm[1] = ""
dw_insert.object.jochdat[1] = ""
dw_insert.object.balvnd[1] = ""
dw_insert.object.balvndnm[1] = ""
dw_insert.object.joemp[1] = ""
dw_insert.object.joempnm[1] = ""
dw_insert.object.jangdae[1] = ""
dw_insert.AcceptText()
if dw_insert.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[삭제실패]') 
	w_mdi_frame.sle_msg.Text = "삭제 작업 실패!"
	Return
end if
	
lcRow = dw_ins.GetRow()
dw_ins.SetRedraw(False)
dw_ins.DeleteRow(lcRow)
if dw_ins.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[삭제실패 : Document]') 
	w_mdi_frame.sle_msg.Text = "삭제 작업 실패!"
	Return
end if

COMMIT;

dw_insert.ReSet()
dw_insert.InsertRow(0) 
dw_insert.SetRedraw(True)
	
dw_ins.ReSet()
dw_ins.InsertRow(0) 
dw_ins.SetRedraw(True)

dw_insert.SetFocus()

w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"

ib_any_typing = False //입력필드 변경여부 No
end event

type p_mod from w_inherite`p_mod within w_qct_01120
integer x = 4046
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;Long ll_i, ll_count, ll_row 
String ls_deptcode, ls_order_no

if f_msg_update() = -1 then return  //저장 Yes/No ?
if wf_required_chk() = -1 then return //필수입력항목 체크 

if dw_1.rowcount() < 1 then 
	Messagebox('확인', '조치내역을 등록하세요') 
	RETURN 
End if 

For ll_i = 1 to dw_1.rowcount()  
	 ls_deptcode = dw_1.object.deptcode[ll_i] 
	 
	 select count(*) 
	   into :ll_count 
		from p0_dept 
	 where deptcode = :ls_deptcode ;
	 
	 if ll_count = 0 or isnull(ll_count) then 
		 Messagebox('확인',  '부서코드가 명확하지 않습니다. ~n부서코드를 확인하세요')
		 Return 
	 End if 
Next 

dw_ins.AcceptText()
if dw_ins.Update() <> 1 then
  	ROLLBACK;
	f_message_chk(32,'[자료저장 실패 : Document]') 
	w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if

COMMIT;

w_mdi_frame.sle_msg.text = "저장 되었습니다!"
	
p_del.Enabled = True
p_del.PictureName = 'c:\erpman\image\삭제_up.gif'


ib_any_typing = False //입력필드 변경여부 No

ll_row = dw_1.getrow() 

if ll_row < 1 then return 

dw_1.object.emp_id[ll_row] = dw_ins.object.emp_id[1] 
dw_1.object.empname[ll_row] = dw_ins.object.empname[1] 
dw_1.object.fin_date[ll_row] = dw_ins.object.fin_date[1] 
dw_1.object.est_date[ll_row] = dw_ins.object.est_date[1] 


end event

type cb_exit from w_inherite`cb_exit within w_qct_01120
integer x = 2848
integer y = 3288
end type

type cb_mod from w_inherite`cb_mod within w_qct_01120
integer x = 1801
integer y = 3288
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qct_01120
integer x = 1006
integer y = 2944
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_qct_01120
integer x = 2149
integer y = 3288
boolean enabled = false
string text = " 삭제(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_qct_01120
integer x = 1449
integer y = 3284
end type

type cb_print from w_inherite`cb_print within w_qct_01120
integer x = 1938
integer y = 2948
end type

type st_1 from w_inherite`st_1 within w_qct_01120
end type

type cb_can from w_inherite`cb_can within w_qct_01120
integer x = 2496
integer y = 3288
end type

type cb_search from w_inherite`cb_search within w_qct_01120
integer x = 1435
integer y = 2948
end type





type gb_10 from w_inherite`gb_10 within w_qct_01120
integer x = 9
integer y = 2952
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_01120
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_01120
end type

type dw_ins from u_key_enter within w_qct_01120
integer x = 41
integer y = 1176
integer width = 4503
integer height = 1076
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_qct_01120_03"
boolean border = false
boolean livescroll = false
end type

event itemchanged;string ls_code, ls_codename
this.AcceptText()

if getcolumnname() = 'emp_id' then 
	
	ls_code = gettext() 
	
	select empname 
	  into :ls_codename 
	  from p1_master 
	 where empno = :ls_code ; 
	 

	dw_ins.setitem(1, 'emp_id', ls_codename )
End if 


w_mdi_frame.sle_msg.text = ""
ib_any_typing = True //입력필드 변경여부 Yes




end event

event itemerror;return 1
end event

event getfocus;call super::getfocus;f_toggle_kor(Handle(this))
end event

event losefocus;call super::losefocus;f_toggle_eng(Handle(this))
end event

event ue_pressenter;if this.GetColumnName() <> "content" then  
	Send(Handle(this),256,9,0)
End if 
//Return 1

end event

event rbuttondown;call super::rbuttondown;if getcolumnname() = 'emp_id' or getcolumnname() = 'empname' then 
	open(w_sawon_popup) 
	
	if isnull(gs_code) then return 
	
	dw_ins.setitem(1, 'emp_id', gs_code ) 
	dw_ins.setitem(1, 'empname', gs_codename) 
End if 
end event

type cb_1 from commandbutton within w_qct_01120
boolean visible = false
integer x = 859
integer y = 3284
integer width = 576
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "BOM사용내역 조회"
end type

type dw_1 from u_key_enter within w_qct_01120
integer x = 59
integer y = 352
integer width = 4498
integer height = 772
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_qct_01120_02"
boolean border = false
boolean livescroll = false
end type

event rbuttondown;call super::rbuttondown;String ls_emp_id 

if row < 1 then return 
ls_emp_id = dw_1.object.emp_id[row] 

if trim(ls_emp_id) <> '' and isnull(ls_emp_id) = false then return 

IF GetColumnName() = 'deptname' or GetColumnName() = 'deptcode' THEN

	Open(w_dept_popup)

	If gs_code = '' Or IsNull(gs_code) THEN Return

	SetItem(row, 'deptcode', gs_code)
	SetItem(row, 'deptname', gs_codename)

End if 
end event

event itemchanged;call super::itemchanged;String ls_deptcode, ls_deptname


end event

event clicked;call super::clicked;string ls_order_no, ls_emp_id
long   ll_seq

if row < 1 then  
	dw_ins.reset()
	dw_ins.insertrow(0)
	return
End if

ls_order_no = dw_1.object.order_no[row]
ll_seq      = dw_1.object.seq[row]

dw_ins.retrieve(ls_order_no, ll_seq)

ls_emp_id = dw_ins.object.emp_id[1] 

if trim(ls_emp_id) = '' or isnull(ls_emp_id) then 
	dw_ins.object.emp_id[1] = gs_empno
	dw_ins.object.empname[1] = gs_username
End if 

end event

event rowfocuschanged;call super::rowfocuschanged;STRING s_code 
LONG   ll_seq


if currentrow < 1 then return 
if this.rowcount() < 1 then return 

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)


string ls_order_no, ls_emp_id

if currentrow < 1 then  
	dw_ins.reset()
	dw_ins.insertrow(0)
	return
End if

ls_order_no = dw_1.object.order_no[currentrow]
ll_seq      = dw_1.object.seq[currentrow]

dw_ins.retrieve(ls_order_no, ll_seq)

ls_emp_id = dw_ins.object.emp_id[1] 

if trim(ls_emp_id) = '' or isnull(ls_emp_id) then 
	dw_ins.object.emp_id[1] = gs_empno
	dw_ins.object.empname[1] = gs_username
	dw_ins.object.fin_date[1] = f_today() 
	dw_ins.object.est_date[1] = f_today() 
End if 
end event

type rr_1 from roundrectangle within w_qct_01120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 1160
integer width = 4549
integer height = 1128
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_01120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 360
integer width = 4549
integer height = 808
integer cornerheight = 40
integer cornerwidth = 55
end type

