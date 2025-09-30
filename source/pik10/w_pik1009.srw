$PBExportHeader$w_pik1009.srw
$PBExportComments$** 근태입력자 사용부서등록
forward
global type w_pik1009 from w_inherite_multi
end type
type dw_empinfo from u_d_popup_sort within w_pik1009
end type
type dw_ip from datawindow within w_pik1009
end type
type pb_1 from picturebutton within w_pik1009
end type
type pb_2 from picturebutton within w_pik1009
end type
type dw_main from u_d_select_sort within w_pik1009
end type
type dw_total from u_d_select_sort within w_pik1009
end type
type rr_2 from roundrectangle within w_pik1009
end type
type rr_3 from roundrectangle within w_pik1009
end type
type rr_1 from roundrectangle within w_pik1009
end type
end forward

global type w_pik1009 from w_inherite_multi
integer height = 2540
string title = "근태입력자 사용부서등록"
dw_empinfo dw_empinfo
dw_ip dw_ip
pb_1 pb_1
pb_2 pb_2
dw_main dw_main
dw_total dw_total
rr_2 rr_2
rr_3 rr_3
rr_1 rr_1
end type
global w_pik1009 w_pik1009

type variables
String sDate
end variables

forward prototypes
public function integer wf_required_check (integer ll_row)
end prototypes

public function integer wf_required_check (integer ll_row);
String scode

dw_main.AcceptText()
scode   = dw_main.GetItemString(ll_row,"deptcode")

IF scode ="" OR IsNull(scode) THEN
	MessageBox("확 인","부서를 입력하세요!!")
	dw_main.SetColumn("deptcode")
	dw_main.Setfocus()
	Return -1
END IF

Return 1
end function

on w_pik1009.create
int iCurrent
call super::create
this.dw_empinfo=create dw_empinfo
this.dw_ip=create dw_ip
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_main=create dw_main
this.dw_total=create dw_total
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_empinfo
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.dw_main
this.Control[iCurrent+6]=this.dw_total
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.rr_3
this.Control[iCurrent+9]=this.rr_1
end on

on w_pik1009.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_empinfo)
destroy(this.dw_ip)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_main)
destroy(this.dw_total)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_1)
end on

event open;call super::open;
dw_empinfo.SetTransObject(SQLCA)      //사원정보
dw_empinfo.Reset()

dw_main.SetTransObject(SQLCA)
dw_main.Reset()
dw_total.SetTransObject(SQLCA)

dw_ip.SetTransObject(SQLCA)
dw_ip.insertrow(0)
dw_ip.object.workday[1] = left(f_today(),6)+'01'
dw_ip.object.gijun[1] = '1'
dw_ip.object.kuntae[1] = '0'

IF dw_empinfo.Retrieve(gs_company,left(f_today(),6)+'01','%', '%') <= 0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!")
	close(this)
	Return
ELSE
	dw_empinfo.SelectRow(0,False)
	dw_empinfo.SelectRow(1,True)
	
	dw_total.Retrieve(dw_empinfo.GetItemString(1,"empno"))
	IF dw_main.Retrieve(dw_empinfo.GetItemString(1,"empno")) > 0 THEN
		dw_main.ScrollToRow(dw_main.RowCount())
		dw_main.SetFocus()
	END IF
	
END IF

end event

type p_delrow from w_inherite_multi`p_delrow within w_pik1009
boolean visible = false
integer x = 3881
integer y = 2820
end type

type p_addrow from w_inherite_multi`p_addrow within w_pik1009
boolean visible = false
integer x = 3707
integer y = 2820
end type

type p_search from w_inherite_multi`p_search within w_pik1009
boolean visible = false
integer x = 3698
integer y = 2560
end type

type p_ins from w_inherite_multi`p_ins within w_pik1009
boolean visible = false
integer x = 4334
integer y = 192
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_main.RowCount() <=0 THEN
	il_currow = 1
	il_functionvalue = 1
ELSE
	il_functionvalue = wf_required_check(dw_main.GetRow())
	
	il_currow = dw_main.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow 
	
	dw_main.InsertRow(il_currow)
	dw_main.SetItem(il_currow,"empno",&
					dw_empinfo.GetItemString(dw_empinfo.GetRow(),"empno"))
	
	dw_main.ScrollToRow(il_currow)
	dw_main.SetColumn("deptcode")
	dw_main.SetFocus()
	
	
END IF

end event

type p_exit from w_inherite_multi`p_exit within w_pik1009
integer x = 4416
end type

type p_can from w_inherite_multi`p_can within w_pik1009
integer x = 4242
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''

ib_any_typing = false

dw_main.retrieve(dw_empinfo.GetItemString(dw_empinfo.GetSelectedRow(0),"empno"))
dw_main.ScrollToRow(dw_main.RowCount())
dw_main.setfocus()



end event

type p_print from w_inherite_multi`p_print within w_pik1009
boolean visible = false
integer x = 3685
integer y = 2684
end type

type p_inq from w_inherite_multi`p_inq within w_pik1009
integer x = 3720
end type

event p_inq::clicked;call super::clicked;String sempno, ls_saup, ls_dept

dw_ip.AcceptText()
ls_saup = dw_ip.GetItemString(1,"saupcd")
IF ls_saup = '' OR IsNull(ls_saup) THEN ls_saup = '%'
ls_dept = dw_ip.GetItemString(1,"deptcode")
IF ls_dept = '' OR IsNull(ls_dept) THEN ls_dept = '%'

IF dw_empinfo.GetSelectedRow(0) <= 0 THEN
	MessageBox("확 인","조회할 사원을 선택하세요!!")
	Return
ELSE
	sempno = dw_empinfo.GetItemString(dw_empinfo.GetSelectedRow(0),"empno")
END IF

dw_total.retrieve(sempno)
IF dw_main.retrieve(sempno) <= 0 then
//	MessageBox("확 인","등록된 자료가 없습니다!!")
	Return
ELSE
//	dw_main.ScrollToRow(dw_main.RowCount())
	dw_main.ScrollToRow(1)
end if
dw_main.setfocus()
end event

type p_del from w_inherite_multi`p_del within w_pik1009
integer x = 4069
end type

event p_del::clicked;call super::clicked;Int il_currow

il_currow = dw_main.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_main.DeleteRow(il_currow)

IF dw_main.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_main.ScrollToRow(il_currow - 1)
		dw_main.SetColumn("deptcode")
		dw_main.SetFocus()
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_mod from w_inherite_multi`p_mod within w_pik1009
integer x = 3895
end type

event p_mod::clicked;call super::clicked;Int k

IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_required_check(dw_main.GetRow()) = -1 THEN RETURN
END IF

///////////////////////////////////////////////////////////////////////////////////

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF

dw_main.Setfocus()
		

end event

type dw_insert from w_inherite_multi`dw_insert within w_pik1009
boolean visible = false
integer x = 1550
integer y = 2572
end type

type st_window from w_inherite_multi`st_window within w_pik1009
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pik1009
boolean visible = false
integer taborder = 60
end type

event cb_append::clicked;call super::clicked;//Int il_currow,il_functionvalue
//
//IF dw_main.RowCount() <=0 THEN
//	il_currow = 0
//	il_functionvalue =1
//ELSE
//	il_functionvalue = wf_required_check(dw_main.GetRow())
//	
//	il_currow = dw_main.GetRow() 
//END IF
//
//IF il_functionvalue = 1 THEN
//	il_currow = il_currow + 1
//	
//	dw_main.InsertRow(il_currow)
//	dw_main.SetItem(il_currow,"companycode",gs_company)	
//	dw_main.SetItem(il_currow,"empno",&
//					dw_empinfo.GetItemString(dw_empinfo.GetRow(),"empno"))
//	dw_main.SetItem(il_currow,"pbtag",iv_pbtag)	
//	dw_main.SetItem(il_currow,"gubun",iv_pstag)	
//
//	dw_main.ScrollToRow(il_currow)
//	dw_main.SetColumn("allowcode")
//	dw_main.SetFocus()
//	
//END IF
//
end event

type cb_exit from w_inherite_multi`cb_exit within w_pik1009
boolean visible = false
integer taborder = 110
end type

type cb_update from w_inherite_multi`cb_update within w_pik1009
boolean visible = false
integer taborder = 80
end type

type cb_insert from w_inherite_multi`cb_insert within w_pik1009
boolean visible = false
integer taborder = 70
end type

type cb_delete from w_inherite_multi`cb_delete within w_pik1009
boolean visible = false
integer taborder = 90
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pik1009
boolean visible = false
integer taborder = 50
end type

type st_1 from w_inherite_multi`st_1 within w_pik1009
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pik1009
boolean visible = false
integer taborder = 100
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pik1009
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pik1009
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pik1009
boolean visible = false
end type

type gb_1 from w_inherite_multi`gb_1 within w_pik1009
boolean visible = false
end type

type gb_10 from w_inherite_multi`gb_10 within w_pik1009
boolean visible = false
end type

type dw_empinfo from u_d_popup_sort within w_pik1009
integer x = 357
integer y = 356
integer width = 2007
integer height = 1908
boolean bringtotop = true
string dataobject = "d_pik1009_1_all"
boolean vscrollbar = true
boolean border = false
end type

event clicked;If Row <= 0 then
	dw_empinfo.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	p_inq.TriggerEvent(Clicked!)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED

end event

event retrieveend;call super::retrieveend;if rowcount > 0 then
	ScrollToRow(1)
	SelectRow(0, FALSE)
	SelectRow(1,TRUE)
	p_inq.TriggerEvent(Clicked!)
	
	b_flag = False
end if

end event

type dw_ip from datawindow within w_pik1009
event ue_key pbm_dwnkey
event ue_key_enter pbm_dwnprocessenter
integer x = 334
integer y = 32
integer width = 2345
integer height = 272
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_pik1009_c"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_key_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string	ls_saup, sget_name, snull, ls_dept, ls_tag
long		rownum

if AcceptText() = -1 then return -1

setnull(snull)

if dwo.Name = 'workday' then
	sDate= GetText()

	IF sDate ="" OR IsNull(sDate) THEN
		object.workday[1] = ""
		Return 1
	END IF
	
	IF F_datechk(sDate) = -1 then
   	messagebox("확인","일자를 확인하십시오!")
		object.workday[1] = ""
		return 1
	END IF
	
	dw_empinfo.Retrieve(gs_company, sDate, ls_saup, ls_dept)
	
elseif dwo.Name = 'saupcd' then
	ls_saup= GetText()
	if ls_saup = '' OR isnull(ls_saup) then ls_saup = '%'
	sdate = getitemstring(row, "workday")
	ls_dept = getitemstring(row, "deptcode")
	if ls_dept = '' OR isnull(ls_dept) then ls_dept = '%'
	
	dw_empinfo.Retrieve(gs_company, sDate, ls_saup, ls_dept)

elseIF dwo.Name = "deptcode" THEN
	sdate = getitemstring(row, "workday")
	ls_dept = trim(this.GetText())
	
	IF ls_dept ="" OR IsNull(ls_dept) THEN 
		ls_dept = '%'
		this.SetItem(1,"deptname",snull)
	ELSE	
		
		SELECT p0_dept.deptname2  
		  INTO :sget_name  
		  FROM p0_dept  
		 WHERE p0_dept.companycode = :gs_company AND 
				 p0_dept.deptcode = :ls_dept  ;
	
		IF sqlca.sqlcode <> 0 THEN
			MessageBox("확 인","등록되지 않은 부서입니다!!")
			this.SetItem(1,"deptcode",snull)
			this.SetItem(1,"deptname",snull)
			this.SetColumn("deptcode")
			this.Setfocus()
			Return 1
		ELSE
			this.SetItem(1,"deptname",sget_name)
		END IF
	END IF
	
	dw_empinfo.Retrieve(gs_company, sDate, ls_saup, ls_dept)

elseIF dwo.Name = "kuntae" THEN
	ls_tag = trim(this.GetText())
	ls_saup= getitemstring(row, "saupcd")
	if ls_saup = '' OR isnull(ls_saup) then ls_saup = '%'
	sdate = getitemstring(row, "workday")
	ls_dept = getitemstring(row, "deptcode")
	if ls_dept = '' OR isnull(ls_dept) then ls_dept = '%'
	
	IF ls_tag = '1' then
	   dw_empinfo.DataObject  = "d_pik1009_1"           /*근태사용자만*/
	ELSE
		dw_empinfo.DataObject  = "d_pik1009_1_all"       /*전체사원*/
	END IF	
	dw_empinfo.SetTransObject(sqlca) 
	
	dw_empinfo.Retrieve(gs_company, sDate, ls_saup, ls_dept)
END IF

if dwo.Name = 'empname' then
	if object.gijun[1] = '1' then
		rownum = dw_empinfo.find("left(#3," + string(len(GetText())) + ")='" + GetText() + "'", 1, dw_empinfo.rowcount())
	else
		rownum = dw_empinfo.find("left(#2," + string(len(GetText())) + ")='" + GetText() + "'", 1, dw_empinfo.rowcount())
	end if

	if rownum > 0 then
		dw_empinfo.setredraw(false)
		dw_main.SetRedraw(False)
	
		dw_empinfo.SelectRow(0,False)
		dw_empinfo.SelectRow(rownum,True)
	
		IF dw_main.Retrieve(dw_empinfo.GetItemString(rownum,"empno")) > 0 THEN
			dw_main.ScrollToRow(dw_main.RowCount())
			dw_main.SetFocus()
		END IF
		dw_empinfo.ScrollToRow(rownum)
	
		dw_empinfo.setredraw(true)
		dw_main.SetRedraw(True)
	end if
end if

end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() ="deptcode" THEN
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(1,"deptcode",gs_code)
//	this.SetItem(1,"deptname",gs_codename)	
	
	this.TriggerEvent(ItemChanged!)

END IF

end event

type pb_1 from picturebutton within w_pik1009
integer x = 3109
integer y = 1248
integer width = 101
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\up.gif"
end type

event clicked;String sempno, sdeptcode,sdeptName
Long rowcnt , totRow , sRow ,gRow, ll_row
int i

ll_row = dw_empinfo.GetRow()
if ll_row = 0 then 
	MessageBox("확 인","처리할 사원을 선택하세요!!")
	Return
end if
sempno = dw_empinfo.GetItemString(ll_row, "empno")

//dw_main.reset()
totRow =dw_total.Rowcount()
gRow = 0
FOR i = 1 TO totRow
	sRow = dw_total.getselectedrow(gRow)
	IF sRow > 0 THEN
		sdeptcode   = dw_total.GetItemString(sRow, "deptcode")
		sdeptName = dw_total.GetItemString(sRow, "deptname")
		
		rowcnt = dw_main.RowCount() + 1
		dw_main.insertrow(rowcnt)
      dw_main.setitem(rowcnt, "empno", sempno)
      dw_main.setitem(rowcnt, "deptcode", sdeptcode)
		dw_main.setitem(rowcnt, "deptname", sdeptName)

		dw_total.deleterow(sRow)
		gRow = sRow -1
	ELSE
		Exit
	END IF
NEXT	

end event

type pb_2 from picturebutton within w_pik1009
integer x = 3255
integer y = 1248
integer width = 101
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\down.gif"
end type

event clicked;String sEmpNo,sdeptcode, sdeptname
Long rowcnt , totRow , sRow ,gRow
int i

totRow =dw_main.Rowcount()
gRow = 0
FOR i = 1 TO totRow
	sRow = dw_main.getselectedrow(gRow)
	IF sRow > 0 THEN
		sEmpNo   = dw_main.GetItemString(sRow, "empno")
		sdeptcode = dw_main.GetItemString(sRow, "deptcode")
		sdeptname = dw_main.GetItemString(sRow, "deptname")
		
		rowcnt = dw_total.RowCount() + 1
		
		dw_total.insertrow(rowcnt)
      dw_total.setitem(rowcnt, "deptcode", sdeptcode)
		dw_total.setitem(rowcnt, "deptname", sdeptname)

		dw_main.deleterow(sRow)
		gRow = sRow -1
	ELSE
		Exit
	END IF
NEXT	

end event

type dw_main from u_d_select_sort within w_pik1009
integer x = 2432
integer y = 352
integer width = 1719
integer height = 848
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pik1009_2"
boolean border = false
end type

event clicked;//Override Script
If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_total from u_d_select_sort within w_pik1009
integer x = 2432
integer y = 1408
integer width = 1719
integer height = 848
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_pik1009_3"
boolean border = false
end type

event clicked;//Override Script
If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type rr_2 from roundrectangle within w_pik1009
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 343
integer y = 344
integer width = 2039
integer height = 1932
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pik1009
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2414
integer y = 336
integer width = 1755
integer height = 880
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pik1009
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2414
integer y = 1392
integer width = 1755
integer height = 880
integer cornerheight = 40
integer cornerwidth = 55
end type

