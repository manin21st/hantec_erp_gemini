$PBExportHeader$w_pdm_01410.srw
$PBExportComments$** 조별 인원관리
forward
global type w_pdm_01410 from w_inherite
end type
type rr_1 from roundrectangle within w_pdm_01410
end type
type dw_pdt from datawindow within w_pdm_01410
end type
type gb_1 from groupbox within w_pdm_01410
end type
type dw_jo from datawindow within w_pdm_01410
end type
type dw_ins from datawindow within w_pdm_01410
end type
type st_2 from statictext within w_pdm_01410
end type
type st_3 from statictext within w_pdm_01410
end type
type pb_1 from picturebutton within w_pdm_01410
end type
type rr_2 from roundrectangle within w_pdm_01410
end type
type dw_update from u_d_select_sort within w_pdm_01410
end type
end forward

global type w_pdm_01410 from w_inherite
integer height = 3772
string title = "블럭별 인원관리"
rr_1 rr_1
dw_pdt dw_pdt
gb_1 gb_1
dw_jo dw_jo
dw_ins dw_ins
st_2 st_2
st_3 st_3
pb_1 pb_1
rr_2 rr_2
dw_update dw_update
end type
global w_pdm_01410 w_pdm_01410

type variables
long oldrow, ctrl_count=0, target_row, min_row
int flag=0 

end variables

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
Long i

for i = 1 to dw_insert.RowCount()
	if Isnull(dw_insert.object.jocod[i]) or dw_insert.object.jocod[i] =  "" then
	   f_message_chk(1400,'[조코드]')
	   dw_insert.SetColumn('jocod')
	   dw_insert.SetFocus()
	   return -1
   end if	
	
	if Isnull(dw_insert.object.jonam[i]) or dw_insert.object.jonam[i] =  "" then
	   f_message_chk(1400,'[조명]')
	   dw_insert.SetColumn('jonam')
	   dw_insert.SetFocus()
	   return -1
   end if
	
	if Isnull(dw_insert.object.dptno[i]) or dw_insert.object.dptno[i] =  "" then
	   f_message_chk(1400,'[생산팀]')
	   dw_insert.SetColumn('dptno')
	   dw_insert.SetFocus()
	   return -1
   end if
next

return 1
end function

on w_pdm_01410.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_pdt=create dw_pdt
this.gb_1=create gb_1
this.dw_jo=create dw_jo
this.dw_ins=create dw_ins
this.st_2=create st_2
this.st_3=create st_3
this.pb_1=create pb_1
this.rr_2=create rr_2
this.dw_update=create dw_update
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_pdt
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_jo
this.Control[iCurrent+5]=this.dw_ins
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.rr_2
this.Control[iCurrent+10]=this.dw_update
end on

on w_pdm_01410.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_pdt)
destroy(this.gb_1)
destroy(this.dw_jo)
destroy(this.dw_ins)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.pb_1)
destroy(this.rr_2)
destroy(this.dw_update)
end on

event open;call super::open;dw_update.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)
dw_jo.SetTransObject(SQLCA)
dw_pdt.SetTransObject(SQLCA)


dw_update.Reset()

dw_ins.Setredraw(False)
dw_ins.ReSet()
dw_ins.Retrieve()
dw_ins.Setredraw(True)

dw_jo.Setredraw(False)
dw_jo.ReSet()
dw_jo.Retrieve()
dw_jo.Setredraw(True)

dw_pdt.Setredraw(False)
dw_pdt.ReSet()
dw_pdt.InsertRow(0)
dw_pdt.Setredraw(True)

dw_pdt.SetFocus()

p_inq.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_pdm_01410
boolean visible = false
integer x = 119
integer y = 692
integer width = 2597
integer height = 880
integer taborder = 40
string dataobject = "d_pdm_01410_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String sCol, ls_deptcode, ls_joname

sCol = this.GetColumnName()
if sCol = "drtim" then
	dw_insert.object.upd[row] = "UPD"
end if	

if sCol = "jocod" then
	ls_deptcode = this.getitemstring( row, 'deptcode')
	
	SELECT JONAM
	INTO	 :ls_joname
	FROM JOMAST
	WHERE JOCOD = :data
	AND	DPTNO = :ls_deptcode 
	USING SQLCA ;
	
	IF isnull(ls_joname) or ls_joname = "" then
		dw_insert.object.jonam[row] = ""
		return 2
	end if
	dw_insert.object.jonam[row] = ls_joname
	
	
	dw_insert.object.upd[row] = "UPD"
end if	


end event

event dw_insert::getfocus;w_mdi_frame.sle_msg.Text = ""
end event

event dw_insert::clicked;//IF row <= 0	then RETURN									
//this.selectrow(row, True)


// 김성민 2004.12.17
// 수정 다중 선택 프로세스로 처리...

integer li_row, r_count 


if KeyDown(keyshift!) then // shift key가 눌러진 상태라면 
  if row > oldrow then 
	// row는 파빌에서 제공하는 내장 아큐먼트로서 현재행번호를 저장하?있다.
		for li_row = oldrow to row 
			SelectRow(li_row, true) 
		next 
		r_count = (row - oldrow) + 1 
	  st_1.text = string(r_count) + & 
		" 개의 행이 선택되었습니다." 
		target_row = r_count 
		min_row = oldrow 
		flag = 1
		ctrl_count = 0
		// 선택된 행이 oldrow보다 크면 oldrow부터 현재행까지 for 루프를 돌면서 
		// 행을 선택시킨다. r_count에 선택된 행수를 계산하여 넣고 st_1을 출력한다.
 else
		for li_row = oldrow to row step -1 
			 SelectRow(li_row, true)
		next 
		r_count = (oldrow - row ) + 1
		st_1.text = string(r_count) + &
		" 개의 행이 선택되었습니다." 
		target_row = r_count 
		min_row = row
		flag = 1
		ctrl_count = 0 
  end if
	// 선택된 행이 oldrow보다 작을 경우는 현재행까지 for 루프의 증감값을 -1로해서
	// 역으로 선택해 나간다.
elseif KeyDown(keycontrol!) then 
  if IsSelected(row) then 
		 SelectRow(row, false) 
		 ctrl_count = ctrl_count - 1 
	// ctrl키가 눌러졌을 경우 현재행이 선택되어 있는 행이라면 선택을 취소시키고 
	// 컨트롤키로 선택된 행의 개수를 하나 줄인다.
  else 
		 SelectRow(row, true)
		 ctrl_count++ 
  end if
	// 선택되어 있지 않다면 현재행을 선택하고 행개수를 증가시킨다.
  st_1.text = string(ctrl_count) + &
  " 개의 행이 선택되었습니다." 
	flag = 2
else // 아무키도 눌러지지 않았을 경우
	SelectRow(0, false)
	SelectRow(row, true) 
	// 모든행의 선택을 해제한후 현재행만 선택한다.
	oldrow = row 
	ctrl_count = 1
	st_1.text = "1 개의 행이 선택되었습니다." 
	flag = 3
	target_row = row 
end if 

end event

event dw_insert::doubleclicked;if this.IsSelected(row) then
   this.selectrow(row, False)
else	
   this.selectrow(row, True)
end if	

end event

type p_delrow from w_inherite`p_delrow within w_pdm_01410
boolean visible = false
integer x = 4247
integer y = 2528
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01410
boolean visible = false
integer x = 4064
integer y = 2528
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdm_01410
boolean visible = false
integer x = 3529
integer y = 2528
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdm_01410
boolean visible = false
integer x = 3890
integer y = 2528
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_pdm_01410
integer x = 4402
integer taborder = 110
end type

type p_can from w_inherite`p_can within w_pdm_01410
integer x = 4229
integer taborder = 100
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

p_inq.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_pdm_01410
boolean visible = false
integer x = 3707
integer y = 2528
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdm_01410
integer x = 3707
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;String pdtgu, gu
Long l_rcnt

dw_pdt.AcceptText()

//pdtgu = dw_pdt.object.pdtgu[1]
gu = dw_pdt.object.gu[1]

//if IsNull(pdtgu) or pdtgu = "" then
//	f_message_chk(30, "[생산팀]")
//	dw_pdt.SetColumn("pdtgu")
//	dw_pdt.SetFocus()
//	return
//end if
//
dw_update.Setredraw(False)
//l_rcnt = dw_update.Retrieve(pdtgu, gu)  //생산팀별로 구분
l_rcnt = dw_update.Retrieve(gu)
if l_rcnt < 1 then
	dw_update.Reset()
	dw_update.Setredraw(True)
	f_message_chk(50, "[사원]")
	p_mod.Enabled = False
	p_del.Enabled = False
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
	return
end if	
dw_update.Setredraw(True)

dw_jo.SelectRow(0, False)
if gu = '1' then 
	p_mod.Enabled = True
	p_del.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
else	
	p_mod.Enabled = true   //lsh  False
	p_del.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
end if	

dw_update.SetFocus()
ib_any_typing = False
end event

type p_del from w_inherite`p_del within w_pdm_01410
integer x = 4055
integer taborder = 80
end type

event p_del::clicked;call super::clicked;String s_jocod, s_jonam, s_empno
Long i, j

if f_msg_delete() = -1 then return  //삭제 Yes/No ?

dw_jo.AcceptText()
dw_update.AcceptText()

//s_jocod = dw_jo.object.jocod[dw_jo.GetRow()]
//s_jonam = dw_jo.object.jonam[dw_jo.GetRow()]

for i = 1 to dw_update.RowCount()
	if dw_update.IsSelected(i) then
		s_empno = dw_update.object.empname[i]
		if IsNull(dw_update.object.jocod[i]) or dw_update.object.jocod[i] = "" then
			MessageBox("반코드 선택", + &
			"반코드가 선택되지 않은 사원이 있습니다![" + s_empno + "]")
    	   return
		end if	
	end if
next

dw_ins.Setredraw(False)
for i = dw_update.RowCount() to 1 step -1
	if dw_update.IsSelected(i) then
		s_empno = dw_update.object.empno[i]
		j = dw_ins.Find("empno = '" + s_empno + "'", 1, dw_ins.RowCount())
		if not (IsNull(j) or j < 1) then
			dw_ins.DeleteRow(j)
		end if					
	end if	
next	
dw_ins.SetRedraw(True)
dw_ins.AcceptText()

if dw_ins.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"
else	
   ROLLBACK;
	f_message_chk(31,'[삭제실폐]') 
	w_mdi_frame.sle_msg.Text = "삭제 작업 실패!"
	Return
end if

p_inq.TriggerEvent(Clicked!)

dw_update.SelectRow(0,False)
dw_jo.SelectRow(0,False) 
ib_any_typing = False

end event

type p_mod from w_inherite`p_mod within w_pdm_01410
integer x = 3881
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;String s_jocod, s_jonam, s_empno
Long i, j

//s_jocod = dw_jo.object.jocod[dw_jo.GetRow()]
//s_jonam = dw_jo.object.jonam[dw_jo.GetRow()]
//for i = 1 to dw_update.RowCount()
//	if dw_update.IsSelected (i) then
//		dw_update.object.jocod[i] = s_jocod
//		dw_update.object.jonam[i] = s_jonam
//	end if	
//next	

if f_msg_update() = -1 then return  //저장 Yes/No ?

dw_jo.AcceptText()
dw_update.AcceptText()

s_jocod = dw_jo.object.jocod[dw_jo.GetRow()]
s_jonam = dw_jo.object.jonam[dw_jo.GetRow()]
dw_ins.Setredraw(False)
for i = 1 to dw_update.RowCount()
//	if dw_update.IsSelected(i) then
	if dw_update.object.upd[i] = "UPD" then
		if IsNull(dw_update.object.jocod[i]) or dw_update.object.jocod[i] = "" then
			MessageBox("반코드 선택", + &
			"반코드가 선택되지 않은 사원이 있습니다![" + String(dw_update.object.empname[i]) + "]")
    	   return
		end if	
		if IsNull(dw_update.object.drtim[i]) or dw_update.object.drtim[i] = "" then
			
			MessageBox("시간적용구분 선택", + &
			"시간적용구분이 선택되지 않은 사원이 있습니다![" + String(dw_update.object.empname[i]) + "]")
    	   dw_update.SetRow(i)
			dw_update.SetColumn("drtim")
			dw_update.SetFocus() 
			return
		end if	
		

		s_empno = dw_update.object.mempno[i]
		j = dw_ins.Find("empno = '" + s_empno + "'", 1, dw_ins.RowCount())
		if IsNull(j) or j < 1 then
			dw_ins.InsertRow(0)
			j = dw_ins.RowCount()
		end if					
		dw_ins.object.jocod[j] = dw_update.object.jocod[i]
		dw_ins.object.empno[j] = s_empno
		dw_ins.object.josts[j] = dw_update.object.josts[i]
		dw_ins.object.drtim[j] = dw_update.object.drtim[i]
		
		dw_ins.object.sub_jocod[j] = dw_update.object.sub_jocod[i]
		
		dw_ins.AcceptText()
	end if	
next	
dw_ins.Setredraw(True)

if dw_ins.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"	
	//ib_any_typing = False //입력필드 변경여부 No
else
	f_message_chk(32,'[자료저장 실패]') 
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if

p_inq.TriggerEvent(Clicked!)

dw_update.SelectRow(0,False)
dw_jo.SelectRow(0,False) 
ib_any_typing = False


end event

type cb_exit from w_inherite`cb_exit within w_pdm_01410
integer x = 2309
integer y = 2560
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01410
integer x = 1266
integer y = 2560
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01410
integer x = 443
integer y = 2368
integer taborder = 90
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01410
integer x = 1614
integer y = 2560
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01410
integer x = 951
integer y = 2348
end type

type cb_print from w_inherite`cb_print within w_pdm_01410
integer x = 3177
integer y = 2560
end type

type st_1 from w_inherite`st_1 within w_pdm_01410
end type

type cb_can from w_inherite`cb_can within w_pdm_01410
integer x = 1961
integer y = 2560
end type

type cb_search from w_inherite`cb_search within w_pdm_01410
integer x = 2674
integer y = 2560
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01410
integer x = 46
integer y = 2540
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01410
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01410
end type

type rr_1 from roundrectangle within w_pdm_01410
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 110
integer y = 216
integer width = 2629
integer height = 2092
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_pdt from datawindow within w_pdm_01410
integer x = 174
integer y = 56
integer width = 951
integer height = 92
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01410_02"
boolean border = false
boolean livescroll = true
end type

event itemchanged;if dw_update.Retrieve(data) < 1 then
	dw_update.Reset()
	f_message_chk(50, "[사원]")
	p_mod.Enabled = False
	p_del.Enabled = False
	
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
	
	return
end if	

dw_jo.SelectRow(0, False)
if data = '1' then 
	p_mod.Enabled = True
	p_del.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
else	
	p_mod.Enabled = False
	p_del.Enabled = True
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
end if	

dw_update.SetFocus()
ib_any_typing = False
end event

type gb_1 from groupbox within w_pdm_01410
integer x = 110
integer y = 12
integer width = 1042
integer height = 156
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type dw_jo from datawindow within w_pdm_01410
integer x = 2994
integer y = 240
integer width = 1563
integer height = 2056
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pdm_01410_03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;IF row <= 0	then RETURN									

//if this.object.pdtgu[row] <> dw_pdt.object.pdtgu[dw_pdt.GetRow()] and &
//   dw_pdt.object.pdtgu[dw_pdt.GetRow()] <> '9' then
//   MessageBox("부서 확인","부서가 다른 조코드 입니다!")
//	return
//end if	

int i, k

for i = 1 to dw_update.RowCount()
	if dw_update.IsSelected (i) then
		if dw_update.object.deptcode[i] <> this.object.dptno[row] then
    		MessageBox("부서 확인","부서가 다른 조코드는 선택할 수 없습니다!")
			this.selectrow(0, false)
		   return
		end if	
      k = k + 1
   end if	
next	


this.selectrow(0, false)
if k > 0 then
	this.selectrow(Row, true)
else
   MessageBox("확인","FROM 자료를 먼저 선택하십시요!")
end if	
end event

event itemchanged;this.AcceptText()
end event

type dw_ins from datawindow within w_pdm_01410
boolean visible = false
integer x = 50
integer y = 2048
integer width = 1376
integer height = 136
boolean bringtotop = true
string dataobject = "d_pdm_01410_04"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type st_2 from statictext within w_pdm_01410
integer x = 165
integer y = 192
integer width = 178
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "FROM"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdm_01410
integer x = 2949
integer y = 192
integer width = 110
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "TO"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_pdm_01410
integer x = 2761
integer y = 288
integer width = 183
integer height = 164
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\blue33_back.gif"
alignment htextalign = left!
end type

event clicked;String s_jocod, s_jonam, s_empno, s_sub_jocod, s_sub_jonam
Long i, j, k

for i = 1 to dw_jo.RowCount()
	if dw_jo.IsSelected (i) then
		k = i
		EXIT
	end if	
next	

if IsNull(k) or k = 0 then 
	f_message_chk(36,"[반코드]")
   return
else
	s_jocod = dw_jo.object.jocod[k]
	s_jonam = dw_jo.object.jonam[k]
	s_sub_jocod = dw_jo.object.sub_jocod[k]
	s_sub_jonam = dw_jo.object.sub_jonam[k]
end if

for i = 1 to dw_update.RowCount()
	if dw_update.IsSelected (i) then
		dw_update.object.jocod[i] = s_jocod
		dw_update.object.jonam[i] = s_jonam
		dw_update.object.sub_jocod[i] = s_sub_jocod
		dw_update.object.sub_jonam[i] = s_sub_jonam
		dw_update.object.upd[i] = "UPD"
	end if	
next	
dw_update.SelectRow(0,False)
dw_jo.SelectRow(0,False)
end event

type rr_2 from roundrectangle within w_pdm_01410
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2971
integer y = 216
integer width = 1605
integer height = 2092
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_update from u_d_select_sort within w_pdm_01410
integer x = 133
integer y = 260
integer width = 2574
integer height = 2024
integer taborder = 20
string dataobject = "d_pdm_01410_01"
boolean border = false
boolean hsplitscroll = true
end type

event clicked;call super::clicked;//IF row <= 0	then RETURN									
//this.selectrow(row, True)


// 김성민 2004.12.17
// 수정 다중 선택 프로세스로 처리...

integer li_row, r_count 


if KeyDown(keyshift!) then // shift key가 눌러진 상태라면 
  if row > oldrow then 
	// row는 파빌에서 제공하는 내장 아큐먼트로서 현재행번호를 저장하?있다.
		for li_row = oldrow to row 
			SelectRow(li_row, true) 
		next 
		r_count = (row - oldrow) + 1 
	  st_1.text = string(r_count) + & 
		" 개의 행이 선택되었습니다." 
		target_row = r_count 
		min_row = oldrow 
		flag = 1
		ctrl_count = 0
		// 선택된 행이 oldrow보다 크면 oldrow부터 현재행까지 for 루프를 돌면서 
		// 행을 선택시킨다. r_count에 선택된 행수를 계산하여 넣고 st_1을 출력한다.
 else
		for li_row = oldrow to row step -1 
			 SelectRow(li_row, true)
		next 
		r_count = (oldrow - row ) + 1
		st_1.text = string(r_count) + &
		" 개의 행이 선택되었습니다." 
		target_row = r_count 
		min_row = row
		flag = 1
		ctrl_count = 0 
  end if
	// 선택된 행이 oldrow보다 작을 경우는 현재행까지 for 루프의 증감값을 -1로해서
	// 역으로 선택해 나간다.
elseif KeyDown(keycontrol!) then 
  if IsSelected(row) then 
		 SelectRow(row, false) 
		 ctrl_count = ctrl_count - 1 
	// ctrl키가 눌러졌을 경우 현재행이 선택되어 있는 행이라면 선택을 취소시키고 
	// 컨트롤키로 선택된 행의 개수를 하나 줄인다.
  else 
		 SelectRow(row, true)
		 ctrl_count++ 
  end if
	// 선택되어 있지 않다면 현재행을 선택하고 행개수를 증가시킨다.
  st_1.text = string(ctrl_count) + &
  " 개의 행이 선택되었습니다." 
	flag = 2
else // 아무키도 눌러지지 않았을 경우
	SelectRow(0, false)
	SelectRow(row, true) 
	// 모든행의 선택을 해제한후 현재행만 선택한다.
	oldrow = row 
	ctrl_count = 1
	st_1.text = "1 개의 행이 선택되었습니다." 
	flag = 3
	target_row = row 
end if 

end event

event doubleclicked;call super::doubleclicked;if this.IsSelected(row) then
   this.selectrow(row, False)
else	
   this.selectrow(row, True)
end if	

end event

event getfocus;call super::getfocus;w_mdi_frame.sle_msg.Text = ""
end event

event itemchanged;call super::itemchanged;String sCol, ls_deptcode, ls_joname

sCol = this.GetColumnName()
if sCol = "drtim" then
	dw_insert.object.upd[row] = "UPD"
end if	

if sCol = "jocod" then
	ls_deptcode = this.getitemstring( row, 'deptcode')
	
	SELECT JONAM
	INTO	 :ls_joname
	FROM JOMAST
	WHERE JOCOD = :data
	AND	DPTNO = :ls_deptcode 
	USING SQLCA ;
	
	IF isnull(ls_joname) or ls_joname = "" then
		dw_insert.object.jonam[row] = ""
		return 2
	end if
	dw_insert.object.jonam[row] = ls_joname
	
	
	dw_insert.object.upd[row] = "UPD"
end if	


end event

event itemerror;call super::itemerror;RETURN 1
end event

