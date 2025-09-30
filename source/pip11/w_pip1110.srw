$PBExportHeader$w_pip1110.srw
$PBExportComments$고정.월변동 항목별 조회
forward
global type w_pip1110 from w_standard_print
end type
type gb_1 from groupbox within w_pip1110
end type
type rr_1 from roundrectangle within w_pip1110
end type
type rb_1 from radiobutton within w_pip1110
end type
type rb_2 from radiobutton within w_pip1110
end type
type rb_3 from radiobutton within w_pip1110
end type
type rb_4 from radiobutton within w_pip1110
end type
end forward

global type w_pip1110 from w_standard_print
string title = "고정.월변동 항목별 조회"
gb_1 gb_1
rr_1 rr_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
end type
global w_pip1110 w_pip1110

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_pbtag, ls_allow, ls_date, ls_code, ls_deptcd, ls_saupcd, ArgBuf, snull
SetNull(snull)

IF dw_ip.AcceptText() = -1 THEN Return -1

ls_pbtag = dw_ip.GetItemString(dw_ip.GetRow(), 'pbtag')
	
IF ls_pbtag = '' OR IsNull(ls_pbtag) THEN
	MessageBox("확인", "급여구분을 입력하세요.")
	dw_ip.SetItem(dw_ip.GetRow(), 'pbtag', snull)
	dw_ip.SetColumn('pbtag')
	dw_ip.SetFocus()
	Return 1
END IF

ls_allow = dw_ip.GetItemString(dw_ip.GetRow(), 'allowcode')
	
IF ls_allow = '' OR IsNull(ls_allow) THEN
	MessageBox("확인", "수당항목을 입력하세요.")
	dw_ip.SetItem(dw_ip.GetRow(), 'allowcode', snull)
	dw_ip.SetColumn('allowcode')
	dw_ip.SetFocus()
	Return 1
END IF

IF rb_3.Checked = TRUE AND rb_4.Checked = False THEN
	ls_code = '1'
ELSEIF rb_4.Checked = True AND rb_3.Checked = False THEN
	ls_code = '2'
END IF

SELECT allowname
  INTO :ArgBuf
  FROM p3_allowance
 WHERE allowcode = :ls_allow and
       paysubtag = :ls_code;
IF SQLCA.sqlcode = 0 THEN dw_print.modify("t_allow.text = '" + ArgBuf + "'")


ls_date = dw_ip.GetItemString(dw_ip.GetRow(), 'kdate')
	
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
		
ls_saupcd = dw_ip.GetItemString(dw_ip.GetRow(), 'saupcd')
ls_deptcd = dw_ip.GetItemString(dw_ip.GetRow(), 'deptcode')

IF ls_saupcd = '' OR IsNull(ls_saupcd) THEN
   ls_saupcd = '%'
	dw_print.modify("t_saup.text = '" + '전체' + "'")
ELSE
	SELECT saupname
	  INTO :ArgBuf
	  FROM p0_saupcd 
	 WHERE saupcode = :ls_saupcd;
	IF SQLCA.sqlcode = 0 THEN dw_print.modify("t_saup.text = '" + ArgBuf + "'")
END IF

IF ls_deptcd = '' OR IsNull(ls_deptcd) THEN
   ls_deptcd = '%'
	dw_print.modify("t_dept.text = '" + '전체' + "'")
ELSE
	SELECT deptname
	  INTO :ArgBuf
	  FROM p0_dept
	 WHERE (deptcode = :ls_deptcd);
	IF SQLCA.sqlcode = 0 THEN dw_print.modify("t_dept.text = '" + ArgBuf + "'")
END IF

dw_list.SetReDraw(False)
w_mdi_frame.sle_msg.text ="조회중입니다..."

IF rb_1.Checked = True AND rb_2.Checked = False THEN
	IF dw_print.Retrieve(ls_saupcd, ls_deptcd, ls_allow, ls_pbtag, ls_code) < 1 THEN
		w_mdi_frame.sle_msg.text ="조회된 자료가 없습니다!!"
		dw_list.SetReDraw(True)
		Return 1
	END IF
ELSEIF rb_1.Checked = False AND rb_2.Checked = True THEN
   IF dw_print.Retrieve(ls_saupcd, ls_deptcd, ls_date, ls_allow, ls_pbtag, ls_code) < 1 THEN
		w_mdi_frame.sle_msg.text ="조회된 자료가 없습니다!!"
		dw_list.SetReDraw(True)
		Return 1
	END IF	
END IF


dw_print.ShareData(dw_list)
dw_list.SetReDraw(True)
w_mdi_frame.sle_msg.text = ""

return 1
end function

on w_pip1110.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rr_1=create rr_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rb_4
end on

on w_pip1110.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()

DataWindowChild state_child

dw_ip.GetChild("allowcode", state_child)

state_child.SetTransObject(SQLCA)
state_child.Reset()
state_child.Retrieve("1", "P", "1") 

dw_ip.InsertRow(0)

dw_ip.SetItem(dw_ip.GetRow(), 'kdate', left(f_today(), 6))

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)







end event

type p_preview from w_standard_print`p_preview within w_pip1110
end type

type p_exit from w_standard_print`p_exit within w_pip1110
end type

type p_print from w_standard_print`p_print within w_pip1110
end type

type p_retrieve from w_standard_print`p_retrieve within w_pip1110
end type

type st_window from w_standard_print`st_window within w_pip1110
boolean visible = false
boolean enabled = true
end type

type sle_msg from w_standard_print`sle_msg within w_pip1110
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within w_pip1110
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within w_pip1110
boolean visible = false
boolean enabled = true
end type

type gb_10 from w_standard_print`gb_10 within w_pip1110
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within w_pip1110
string dataobject = "d_pip1110_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pip1110
integer x = 443
integer width = 3163
integer height = 304
string dataobject = "d_pip1110_c"
end type

event dw_ip::itemchanged;call super::itemchanged;String ls_pbtag, ls_allow, ls_date, ls_deptcd, ls_deptname, snull
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

IF this.GetColumnName() = 'allowcode' THEN
	ls_allow = this.GetText()
	
	IF ls_allow = '' OR IsNull(ls_allow) THEN
		MessageBox("확인", "수당항목을 입력하세요.")
		dw_ip.SetItem(dw_ip.GetRow(), 'allowcode', snull)
		dw_ip.SetColumn('allowcode')
		dw_ip.SetFocus()
		Return 1
	END IF
	
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

IF this.GetColumnName() = 'deptcode' THEN
	ls_deptcd = this.GetText()
	
	IF ls_deptcd = '' OR IsNull(ls_deptcd) THEN 
		this.SetItem(this.GetRow(), "deptcode", snull)
		this.SetItem(this.GetRow(), "deptname", snull)
		Return 1
	ELSE
	
		Select deptname
		  INTO :ls_Deptname
		  FROM p0_Dept
		 WHERE deptcode = :ls_deptcd;
		 
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(this.GetRow(), "deptname", ls_deptname)
		ELSE
			MessageBox("확 인","등록되지 않은 부서입니다!!",StopSign!)
			this.SetItem(this.GetRow(), "deptcode", snull)
			this.SetItem(this.GetRow(), "deptname", snull)
			Return 1
		END IF
	END IF
END IF
	


	
end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_Codename)

IF this.GetColumnName() = 'deptcode' THEN
	gs_codename = this.GetText()
	
	open(w_dept_popup)
	
	IF IsNull(gs_code) THEN Return 
	
   THIS.SetItem(this.GetRow(), 'deptcode', gs_code)
   This.SetItem(this.GetRow(), 'deptname', gs_codename)		
END IF

end event

type dw_list from w_standard_print`dw_list within w_pip1110
integer x = 453
integer width = 3099
integer height = 1904
string dataobject = "d_pip1110_1"
boolean border = false
end type

type gb_1 from groupbox within w_pip1110
integer x = 864
integer y = 20
integer width = 297
integer height = 300
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "지급구분"
end type

type rr_1 from roundrectangle within w_pip1110
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 443
integer y = 328
integer width = 3159
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within w_pip1110
integer x = 462
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

event clicked;string ls_reference, ls_gubun, ls_pbtag, snull
SetNull(snull)

IF rb_1.checked = True THEN
	rb_2.checked = False
	dw_ip.SetItem(dw_ip.GetRow(), 'allowcode', snull)
	
	dw_list.dataobject="d_pip1110_1"
	dw_list.settransobject(sqlca)
	dw_print.dataobject="d_pip1110_1_p"
	dw_print.settransobject(sqlca)
	
	dw_ip.SetReDraw(False)
	dw_ip.modify("t_3.visible = 0")
	dw_ip.modify("kdate_t.visible = 0")
	dw_ip.modify("kdate.visible = 0")
	dw_ip.SetReDraw(True)
	
	dw_ip.AcceptText()
	
	ls_reference = '1'
	
	IF rb_3.Checked  = True AND rb_4.Checked = False THEN
		ls_gubun = '1'
	ELSEIF rb_3.Checked = False AND rb_4.Checked = True THEN
		ls_gubun = '2'
	END IF
	
	ls_pbtag = dw_ip.GetItemString(dw_ip.GetRow(), 'pbtag')
	
	
	DataWindowChild state_child

	dw_ip.GetChild("allowcode", state_child)
	
	state_child.SetTransObject(SQLCA)
	state_child.Reset()
	state_child.Retrieve(ls_reference, ls_pbtag, ls_gubun) 
		
END IF

//p_retrieve.TriggerEvent(Clicked!)
end event

type rb_2 from radiobutton within w_pip1110
integer x = 462
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

event clicked;string ls_reference, ls_pbtag, ls_gubun, snull
SetNull(snull)

IF rb_2.Checked = True THEN
	rb_1.Checked = False
	dw_ip.SetItem(dw_ip.GetRow(), 'allowcode', snull)
	
	dw_list.dataobject="d_pip1110_2"
	dw_list.settransobject(sqlca)
	dw_print.dataobject="d_pip1110_2_p"
	dw_print.settransobject(sqlca)
	
	dw_ip.SetReDraw(False)
	dw_ip.modify("t_3.visible = 1")
	dw_ip.modify("kdate_t.visible = 1")
	dw_ip.modify("kdate.visible = 1")
	dw_ip.SetReDraw(True)
	
	dw_ip.SetItem(dw_ip.GetRow(), 'kdate', left(f_today(), 6))
	
	
	dw_ip.AcceptText()
	
	ls_reference = '2'
	
	IF rb_3.Checked  = True AND rb_4.Checked = False THEN
		ls_gubun = '1'
	ELSEIF rb_3.Checked = False AND rb_4.Checked = True THEN
		ls_gubun = '2'
	END IF
	
	ls_pbtag = dw_ip.GetItemString(dw_ip.GetRow(), 'pbtag')
	
	
	DataWindowChild state_child

	dw_ip.GetChild("allowcode", state_child)
	
	state_child.SetTransObject(SQLCA)
	state_child.Reset()
	state_child.Retrieve(ls_reference, ls_pbtag, ls_gubun) 

END IF

//p_retrieve.TriggerEvent(Cl																																																								icked!)
end event

type rb_3 from radiobutton within w_pip1110
integer x = 901
integer y = 68
integer width = 247
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
string text = "지급"
boolean checked = true
end type

event clicked;string ls_reference, ls_pbtag, ls_gubun, snull
SetNull(snull)

IF rb_3.Checked = TRUE THEN
	rb_4.Checked = False
	dw_ip.SetItem(dw_ip.GetRow(), 'allowcode', snull)
	
	dw_ip.AcceptText()
	
	ls_gubun = '1'
	
	IF rb_1.Checked  = True AND rb_2.Checked = False THEN
		ls_reference = '1'
	ELSEIF rb_1.Checked = False AND rb_2.Checked = True THEN
		ls_reference = '2'
	END IF
	
	ls_pbtag = dw_ip.GetItemString(dw_ip.GetRow(), 'pbtag')
	
	
	DataWindowChild state_child

	dw_ip.GetChild("allowcode", state_child)
	
	state_child.SetTransObject(SQLCA)
	state_child.Reset()
	state_child.Retrieve(ls_reference, ls_pbtag, ls_gubun) 
	
END IF
end event

type rb_4 from radiobutton within w_pip1110
integer x = 901
integer y = 184
integer width = 247
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
string text = "공제"
end type

event clicked;String ls_reference, ls_pbtag, ls_gubun, snull
SetNull(snull)

IF rb_4.Checked = TRUE THEN
	rb_3.Checked = False
	dw_ip.SetItem(dw_ip.GetRow(), 'allowcode', snull)
	
	dw_ip.AcceptText()
	
	ls_gubun = '2'
	
	IF rb_1.Checked  = True AND rb_2.Checked = False THEN
		ls_reference = '1'
	ELSEIF rb_1.Checked = False AND rb_2.Checked = True THEN
		ls_reference = '2'
	END IF
	
	ls_pbtag = dw_ip.GetItemString(dw_ip.GetRow(), 'pbtag')
	
	
	DataWindowChild state_child

	dw_ip.GetChild("allowcode", state_child)
	
	state_child.SetTransObject(SQLCA)
	state_child.Reset()
	state_child.Retrieve(ls_reference, ls_pbtag, ls_gubun) 
	
END IF
end event

