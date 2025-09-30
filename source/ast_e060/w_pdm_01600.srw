$PBExportHeader$w_pdm_01600.srw
$PBExportComments$** BOM변경 요청 등록
forward
global type w_pdm_01600 from w_inherite
end type
type rr_1 from roundrectangle within w_pdm_01600
end type
type gb_2 from groupbox within w_pdm_01600
end type
type gb_1 from groupbox within w_pdm_01600
end type
type dw_list from u_key_enter within w_pdm_01600
end type
type pb_1 from u_pb_cal within w_pdm_01600
end type
type pb_2 from u_pb_cal within w_pdm_01600
end type
end forward

global type w_pdm_01600 from w_inherite
string title = "BOM 변경 요청 등록"
rr_1 rr_1
gb_2 gb_2
gb_1 gb_1
dw_list dw_list
pb_1 pb_1
pb_2 pb_2
end type
global w_pdm_01600 w_pdm_01600

forward prototypes
public function integer wf_required_chk ()
public function boolean wf_duplication_chk (integer crow)
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
Long i
if dw_insert.AcceptText() = -1 then return -1
for i = 1 to dw_insert.RowCount()
   dw_insert.object.reldpt[i] = dw_list.object.buse[1]
	
	if Isnull(Trim(dw_insert.object.chgdat[i])) or Trim(dw_insert.object.chgdat[i]) =  "" then
   	f_message_chk(1400,'[변경일자]')
	   dw_insert.SetRow(i)
		dw_insert.SetColumn('chgdat')
	   dw_insert.SetFocus()
	   return -1
   end if	

	if Isnull(Trim(dw_insert.object.aft_itnbr[i])) or Trim(dw_insert.object.aft_itnbr[i]) =  "" then
   	f_message_chk(1400,'[품번]')
	   dw_insert.SetRow(i)
		dw_insert.SetColumn('aft_itnbr')
	   dw_insert.SetFocus()
	   return -1
   end if	
next

return 1
end function

public function boolean wf_duplication_chk (integer crow);String s1, s2
long   ll_frow

s1 = Trim(dw_insert.object.aft_itnbr[crow])
s2 = Trim(dw_insert.object.chgdat[crow])

ll_frow = dw_insert.Find("aft_itnbr = '" + s1 + "'", 1, crow - 1)
if not (IsNull(ll_frow) or ll_frow < 1) and ll_frow <> crow then
	ll_frow = dw_insert.Find("chgdat = '" + s2 + "'", ll_frow, ll_frow)
	if not (IsNull(ll_frow) or ll_frow < 1) and ll_frow <> crow then
	   f_message_chk(1, "[" + String(ll_Frow) + " 번째ROW]")
	   return False
	end if	
end if

ll_frow = dw_insert.Find("aft_itnbr = '" + s1 + "'", crow + 1, dw_insert.Rowcount())
if not (IsNull(ll_frow) or ll_frow < 1) and ll_frow <> crow then
	ll_frow = dw_insert.Find("chgdat = '" + s2 + "'", ll_frow, ll_frow)
	if not (IsNull(ll_frow) or ll_frow < 1) and ll_frow <> crow then
	   f_message_chk(1, "[" + String(ll_Frow) + " 번째ROW]")
	   return False
	end if	
end if

return True
end function

on w_pdm_01600.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_list=create dw_list
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
end on

on w_pdm_01600.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_list)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_insert.ReSet()
dw_list.SetTransObject(SQLCA)
dw_list.ReSet()
dw_list.InsertRow(0)
dw_list.SetFocus()


end event

type dw_insert from w_inherite`dw_insert within w_pdm_01600
integer x = 37
integer y = 208
integer width = 4558
integer height = 2092
integer taborder = 20
string dataobject = "d_pdm_01600_02"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::rbuttondown;Long crow
SetNull(gs_code)
SetNull(gs_codename)
gs_gubun = '1'

crow = this.GetRow()
IF	this.getcolumnname() = "aft_itnbr"	THEN		
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(crow, "aft_itnbr", gs_code)
	this.triggerevent(itemchanged!)
	return 1
elseif this.getcolumnname() = "bfr_itnbr"	THEN		
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(crow, "bfr_itnbr", gs_code)
	this.triggerevent(itemchanged!)
	return 1	
END IF
end event

event dw_insert::ue_key;call super::ue_key;Long lrow

lrow = this.GetRow()
IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "aft_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then 
			this.SetItem(lrow, "aft_itnbr", "")
         this.SetItem(lrow, "aft_itdsc", "")
			return
		else
			this.SetItem(lrow, "aft_itnbr", gs_code)
         this.SetItem(lrow, "aft_itdsc", gs_codename)
		end if
		THIS.triggerevent(itemchanged!)		
		RETURN 1
	elseif This.GetColumnName() = "bfr_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then 
         this.SetItem(lrow, "bfr_itnbr", "")
         this.SetItem(lrow, "bfr_itdsc", "")
			return
      else
	      this.SetItem(lrow, "bfr_itnbr", gs_code)
         this.SetItem(lrow, "bfr_itdsc", gs_codename)
		end if	
		THIS.triggerevent(itemchanged!)		
		RETURN 1
	End If
END IF  
end event

event dw_insert::itemchanged;call super::itemchanged;String s_cod, s_itnbr, s_itdsc, s_ispec , s_jijil ,s_ispec_code
Long   crow

s_cod = Trim(this.GetText())
w_mdi_frame.sle_msg.Text = ""
crow = this.GetRow()

if IsNull(crow) or crow < 1 then return
if (this.GetColumnName() = "aft_itnbr") Then
   if wf_duplication_chk(crow) = False then
		this.object.aft_itdsc[crow] = ""
		this.object.aft_ispec[crow] = ""
		this.object.aft_itnbr[crow] = ""
		this.object.aft_jijil[crow] = ""
		this.object.aft_ispec_code[crow] = ""
		return 1
	end if
	
	s_itnbr = s_cod
	
   SELECT ITDSC, ISPEC , JIJIL , ISPEC_CODE
     INTO :s_itdsc, :s_ispec , :s_jijil , :s_ispec_code
     FROM ITEMAS  
    WHERE ITNBR = :s_itnbr;
	   
	if sqlca.sqlcode < 0 or sqlca.sqlcode = 100 then
		messagebox("확인","등록된 품번이 아닙니다.[" + s_itnbr + "]")
		this.object.aft_itdsc[crow] = ""
		this.object.aft_ispec[crow] = ""
		this.object.aft_itnbr[crow] = ""
      this.object.aft_jijil[crow] = ""		
		this.object.aft_ispec_code[crow] = ""
		return 1
	end if  
	this.object.aft_itdsc[crow] = s_itdsc
	this.object.aft_ispec[crow] = s_ispec
	this.object.aft_jijil[crow] = s_jijil
	this.object.aft_ispec_code[crow] = s_ispec_code
elseif this.GetColumnName() = "bfr_itnbr" Then
   s_itnbr = s_cod
	if IsNull(s_itnbr) or s_itnbr = "" then
	   this.object.bfr_itdsc[crow] = ""
		this.object.bfr_ispec[crow] = ""
		this.object.bfr_jijil[crow] = ""
		this.object.bfr_ispec_code[crow] = ""
		return
	end if	
	
	SELECT ITDSC, ISPEC , JIJIL , ISPEC_CODE
     INTO :s_itdsc, :s_ispec , :s_jijil , :s_ispec_code
     FROM ITEMAS  
    WHERE ITNBR = :s_itnbr;
	   
	if sqlca.sqlcode < 0 or sqlca.sqlcode = 100 then
		messagebox("확인","등록된 품번이 아닙니다.[" + s_itnbr + "]")
		this.object.bfr_itdsc[crow] = ""
		this.object.bfr_ispec[crow] = ""
		this.object.bfr_itnbr[crow] = ""
		this.object.bfr_jijil[crow] = ""
		this.object.bfr_ispec_code[crow] = ""
		return 1
	end if  
	this.object.bfr_itdsc[crow] = s_itdsc
	this.object.bfr_ispec[crow] = s_ispec
	this.object.bfr_jijil[crow] = s_jijil
	this.object.bfr_ispec_code[crow] = s_ispec_code
elseif this.GetColumnName() = "chgdat" Then
	if f_datechk(s_cod) = -1 then
		f_message_chk(35,"[날짜]")
		this.object.chgdat[crow] = ""
		return 1
	end if
	if wf_duplication_chk(crow) = False then
		this.object.chgdat[crow] = ""
		return 1
	end if
end if	

end event

event dw_insert::rowfocuschanged;//this.SetRowFocusIndicator(HAND!)
end event

event dw_insert::doubleclicked;call super::doubleclicked;this.ScrollToRow(Row)
p_search.TriggerEvent(Clicked!)
end event

type p_delrow from w_inherite`p_delrow within w_pdm_01600
boolean visible = false
integer x = 3945
integer y = 3088
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01600
boolean visible = false
integer x = 3771
integer y = 3088
end type

type p_search from w_inherite`p_search within w_pdm_01600
integer x = 3273
integer width = 306
string picturename = "C:\erpman\image\승인및의견등록_up.gif"
end type

event p_search::clicked;call super::clicked;str_chg chg_str //구조체 선언
Long crow

crow = dw_insert.GetRow()
if IsNull(crow) or crow < 1 then 
	MessageBox("품번 선택","품번을 선택한 후에 진행하세요!")
	return
end if	
if dw_list.AcceptText() = -1 then return
if dw_insert.AcceptText() = -1 then return
chg_str.buse = dw_list.object.buse[1]
chg_str.chgdat = dw_insert.object.chgdat[crow]
chg_str.aft_itnbr = dw_insert.object.aft_itnbr[crow]
chg_str.bfr_itnbr = dw_insert.object.bfr_itnbr[crow]
if IsNull(chg_str.buse) or chg_str.buse = "" then
	MessageBox("의뢰부서 선택","의뢰부서를 선택한 후에 진행하세요!")
	return
end if
OpenWithParm(w_pdm_01610, chg_str)
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\승인및의견등록_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\승인및의견등록_up.gif"
end event

type p_ins from w_inherite`p_ins within w_pdm_01600
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Long crow

String s_buse

dw_list.AcceptText()
s_buse = dw_list.object.buse[1]
IF IsNull(s_buse)	 or  s_buse = ''	THEN
	MessageBox("확 인", "의뢰부서를 먼저 입력하세요.")
	dw_list.SetColumn("buse")
	dw_list.SetFocus()
	RETURN
END IF

dw_insert.Setredraw(False)
crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	dw_insert.InsertRow(0)
end if	
dw_insert.ScrollToRow(crow)
dw_insert.Setredraw(True)
dw_insert.SetColumn("chgdat") 
dw_insert.SetFocus()

end event

type p_exit from w_inherite`p_exit within w_pdm_01600
end type

type p_can from w_inherite`p_can within w_pdm_01600
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

p_inq.TriggerEvent(Clicked!)
ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_pdm_01600
boolean visible = false
integer x = 3250
integer y = 3088
end type

type p_inq from w_inherite`p_inq within w_pdm_01600
integer x = 3575
end type

event p_inq::clicked;call super::clicked;String s_buse, s_sdate, s_edate

dw_list.AcceptText()
s_buse = dw_list.object.buse[1]
s_sdate = dw_list.object.sdate[1]
s_edate = dw_list.object.edate[1]
IF IsNull(s_buse)	 or  s_buse = ''	THEN
	MessageBox("확 인", "의뢰부서를 먼저 입력하세요.")
	dw_list.SetColumn("buse")
	dw_list.SetFocus()
	RETURN
END IF
IF IsNull(s_sdate) or s_sdate = '' THEN s_sdate = '11110101'
IF IsNull(s_edate) or s_edate = '' THEN s_edate = '99999999'
dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.Retrieve(s_buse, s_sdate, s_edate)
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_pdm_01600
end type

event p_del::clicked;call super::clicked;if f_msg_delete() = -1 then return

dw_insert.DeleteRow(dw_insert.GetRow())
dw_insert.AcceptText()

IF dw_insert.Update() > 0	 THEN
   COMMIT;
	w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(31,"[삭제실패]")
	w_mdi_frame.sle_msg.Text = "삭제작업 실패!"
	Return
END IF

ib_any_typing = False //입력필드 변경여부 No
end event

type p_mod from w_inherite`p_mod within w_pdm_01600
end type

event p_mod::clicked;call super::clicked;if f_msg_update() = -1 then return
if wf_required_chk() = -1 then return //필수입력항목 체크 

IF dw_insert.Update() > 0 THEN		
	COMMIT;
	w_mdi_frame.sle_msg.Text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	w_mdi_frame.sle_msg.Text = "저장작업 실패!"
END IF

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01600
boolean visible = false
integer x = 3621
integer y = 2832
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01600
boolean visible = false
integer x = 2578
integer y = 2832
integer taborder = 30
end type

event cb_mod::clicked;call super::clicked;//if f_msg_update() = -1 then return
//if wf_required_chk() = -1 then return //필수입력항목 체크 
//
//IF dw_insert.Update() > 0 THEN		
//	COMMIT;
//	sle_msg.Text = "저장 되었습니다!"
//ELSE
//	ROLLBACK;
//	f_message_chk(32, "[저장실패]")
//	sle_msg.Text = "저장작업 실패!"
//END IF
//
//ib_any_typing = False //입력필드 변경여부 No
end event

type cb_ins from w_inherite`cb_ins within w_pdm_01600
boolean visible = false
integer x = 631
integer y = 2824
integer taborder = 80
string text = "추가(&A)"
end type

event cb_ins::clicked;call super::clicked;Long crow

String s_buse

dw_list.AcceptText()
s_buse = dw_list.object.buse[1]
IF IsNull(s_buse)	 or  s_buse = ''	THEN
	MessageBox("확 인", "의뢰부서를 먼저 입력하세요.")
	dw_list.SetColumn("buse")
	dw_list.SetFocus()
	RETURN
END IF

dw_insert.Setredraw(False)
crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	dw_insert.InsertRow(0)
end if	
dw_insert.ScrollToRow(crow)
dw_insert.Setredraw(True)
dw_insert.SetColumn("chgdat") 
dw_insert.SetFocus()

end event

type cb_del from w_inherite`cb_del within w_pdm_01600
boolean visible = false
integer x = 2926
integer y = 2832
integer taborder = 40
end type

event cb_del::clicked;call super::clicked;//if f_msg_delete() = -1 then return
//
//dw_insert.DeleteRow(dw_insert.GetRow())
//dw_insert.AcceptText()
//
//IF dw_insert.Update() > 0	 THEN
//   COMMIT;
//	sle_msg.Text = "삭제 되었습니다!"
//ELSE
//	ROLLBACK;
//	f_message_chk(31,"[삭제실패]")
//	sle_msg.Text = "삭제작업 실패!"
//	Return
//END IF
//
//ib_any_typing = False //입력필드 변경여부 No
end event

type cb_inq from w_inherite`cb_inq within w_pdm_01600
boolean visible = false
integer x = 283
integer y = 2824
integer taborder = 70
end type

event cb_inq::clicked;call super::clicked;//String s_buse, s_sdate, s_edate
//
//dw_list.AcceptText()
//s_buse = dw_list.object.buse[1]
//s_sdate = dw_list.object.sdate[1]
//s_edate = dw_list.object.edate[1]
//IF IsNull(s_buse)	 or  s_buse = ''	THEN
//	MessageBox("확 인", "의뢰부서를 먼저 입력하세요.")
//	dw_list.SetColumn("buse")
//	dw_list.SetFocus()
//	RETURN
//END IF
//IF IsNull(s_sdate) or s_sdate = '' THEN s_sdate = '11110101'
//IF IsNull(s_edate) or s_edate = '' THEN s_edate = '99999999'
//dw_insert.SetRedraw(False)
//dw_insert.ReSet()
//dw_insert.Retrieve(s_buse, s_sdate, s_edate)
//dw_insert.SetRedraw(True)
end event

type cb_print from w_inherite`cb_print within w_pdm_01600
boolean visible = false
integer x = 1984
integer y = 2860
end type

type st_1 from w_inherite`st_1 within w_pdm_01600
end type

type cb_can from w_inherite`cb_can within w_pdm_01600
boolean visible = false
integer x = 3273
integer y = 2832
integer taborder = 50
end type

event cb_can::clicked;call super::clicked;//sle_msg.text =""
//IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 
//
//cb_inq.TriggerEvent(Clicked!)
//ib_any_typing = False //입력필드 변경여부 No
//
//
end event

type cb_search from w_inherite`cb_search within w_pdm_01600
integer x = 3781
integer y = 2972
integer width = 667
integer taborder = 90
string text = "승인 및 의견 등록"
end type

event clicked;//str_chg chg_str //구조체 선언
//Long crow
//
//crow = dw_insert.GetRow()
//if IsNull(crow) or crow < 1 then 
//	MessageBox("품번 선택","품번을 선택한 후에 진행하세요!")
//	return
//end if	
//if dw_list.AcceptText() = -1 then return
//if dw_insert.AcceptText() = -1 then return
//chg_str.buse = dw_list.object.buse[1]
//chg_str.chgdat = dw_insert.object.chgdat[crow]
//chg_str.aft_itnbr = dw_insert.object.aft_itnbr[crow]
//chg_str.bfr_itnbr = dw_insert.object.bfr_itnbr[crow]
//if IsNull(chg_str.buse) or chg_str.buse = "" then
//	MessageBox("의뢰부서 선택","의뢰부서를 선택한 후에 진행하세요!")
//	return
//end if
//OpenWithParm(w_pdm_01610, chg_str)
end event





type gb_10 from w_inherite`gb_10 within w_pdm_01600
integer x = 123
integer y = 2964
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01600
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01600
end type

type rr_1 from roundrectangle within w_pdm_01600
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 200
integer width = 4581
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

type gb_2 from groupbox within w_pdm_01600
boolean visible = false
integer x = 2542
integer y = 2772
integer width = 1454
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_pdm_01600
boolean visible = false
integer x = 238
integer y = 2764
integer width = 763
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_list from u_key_enter within w_pdm_01600
event ue_key pbm_dwnkey
integer x = 27
integer y = 52
integer width = 2555
integer height = 128
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_01600_01"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
end if	
end event

event itemchanged;String s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText()) 

if this.GetColumnName() = "buse" then
	i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)	
	this.object.buse[1] = s_cod
	this.object.bunm[1] = s_nam1
	return i_rtn
elseif this.GetColumnName() = "sdate" then	
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then	
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
end if
end event

event itemerror;return 1
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

type pb_1 from u_pb_cal within w_pdm_01600
integer x = 2021
integer y = 72
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_list.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_list.SetItem(dw_list.getrow(), 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_pdm_01600
integer x = 2482
integer y = 72
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_list.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_list.SetItem(dw_list.getrow(), 'edate', gs_code)

end event

