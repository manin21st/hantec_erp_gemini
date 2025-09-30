$PBExportHeader$w_pip5000.srw
$PBExportComments$** 정산추가자료 입력
forward
global type w_pip5000 from w_inherite_standard
end type
type rr_1 from roundrectangle within w_pip5000
end type
type dw_1 from datawindow within w_pip5000
end type
type dw_main from datawindow within w_pip5000
end type
type rb_1 from radiobutton within w_pip5000
end type
type rb_2 from radiobutton within w_pip5000
end type
type gb_4 from groupbox within w_pip5000
end type
type gb_5 from groupbox within w_pip5000
end type
type dw_emp from u_key_enter within w_pip5000
end type
type pb_1 from picturebutton within w_pip5000
end type
type pb_3 from picturebutton within w_pip5000
end type
type pb_2 from picturebutton within w_pip5000
end type
type pb_4 from picturebutton within w_pip5000
end type
type dw_2 from datawindow within w_pip5000
end type
type cbx_buyang from checkbox within w_pip5000
end type
type dw_temp from datawindow within w_pip5000
end type
type cb_1 from commandbutton within w_pip5000
end type
type dw_saup from datawindow within w_pip5000
end type
type cb_2 from commandbutton within w_pip5000
end type
type cb_3 from commandbutton within w_pip5000
end type
type rr_2 from roundrectangle within w_pip5000
end type
end forward

global type w_pip5000 from w_inherite_standard
integer height = 2576
string title = "정산추가 자료등록"
rr_1 rr_1
dw_1 dw_1
dw_main dw_main
rb_1 rb_1
rb_2 rb_2
gb_4 gb_4
gb_5 gb_5
dw_emp dw_emp
pb_1 pb_1
pb_3 pb_3
pb_2 pb_2
pb_4 pb_4
dw_2 dw_2
cbx_buyang cbx_buyang
dw_temp dw_temp
cb_1 cb_1
dw_saup dw_saup
cb_2 cb_2
cb_3 cb_3
rr_2 rr_2
end type
global w_pip5000 w_pip5000

type variables
String iv_workym,iv_pbtag,iv_empno

end variables

forward prototypes
public function integer wf_required_check (string sdataobj, integer ll_row)
public subroutine wf_check_modified ()
end prototypes

public function integer wf_required_check (string sdataobj, integer ll_row);//String sempno,scompanycode,syear
//Double damount, dpay,dsub
//
//IF sdataobj ="d_pip5000_1" THEN								//급여자료
//	dw_main.AcceptText()
//	sempno = dw_main.GetItemString(1,"empno")	
//	syear   = dw_main.GetItemString(1,"workyear")
//
//	IF sempno ="" OR IsNull(sempno) THEN
//		MessageBox("확 인","사번을 입력하세요!!")
//		dw_emp.SetColumn("empno")
//		dw_emp.SetFocus()
//		Return -1
//	END IF
//	IF syear ="" AND isnull(syear) THEN
//		Messagebox("확 인","작업년도를 입력하세요!!")
//		dw_main.SetColumn("basepay")
//		dw_main.SetFocus()
//		Return -1
//	END IF
//	
//ELSEIF sdataobj ="d_pip5000_2" THEN							//급여자료 CHILD(지급수당)
//	
//	dw_1.AcceptText()
//	scode   = dw_1.GetItemString(ll_row,"allowcode")
//	damount = dw_1.GetItemNumber(ll_row,"allowamt") 
//	
//	IF scode ="" OR IsNull(scode) THEN
//		MessageBox("확 인","수당을 입력하세요!!")
//		dw_1.SetColumn("allowcode")
//		dw_1.SetFocus()
//		Return -1
//	END IF
//	
//	IF damount = 0 OR IsNull(damount) THEN
//		MessageBox("확 인","금액을 입력하세요!!")
//		dw_1.SetColumn("allowamt")
//		dw_1.SetFocus()
//		Return -1
//	END IF
//
//	dw_main.SetItem(1,"etcallowamt",dw_1.GetItemNumber(1,"ctotal"))
//END IF
Return 1
end function

public subroutine wf_check_modified ();w_mdi_frame.sle_msg.text =""
/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_detail 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	CHOOSE CASE MessageBox("확인 : 종료" , &
		 "저장하지 않은 값이 있습니다. ~r~r변경사항을 저장하시겠습니까?", &
		 question!, YesNoCancel!) 
	CASE 1
		IF dw_main.Update() <> 1 THEN
			MessageBox("확 인","자료 저장을 실패하였습니다!!")
			ROLLBACK;
			Return
		ELSE
			IF dw_1.Update() <> 1 THEN
				MessageBox("확 인","자료 저장을 실패하였습니다!!")
				ROLLBACK;
				Return
			END IF
			ib_any_typing = false
			COMMIT;
		END IF
	CASE 3
		ib_any_typing = false
		RETURN
	CASE ELSE
		ib_any_typing = false
		ROLLBACK;
	END CHOOSE

END IF


end subroutine

on w_pip5000.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_1=create dw_1
this.dw_main=create dw_main
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_4=create gb_4
this.gb_5=create gb_5
this.dw_emp=create dw_emp
this.pb_1=create pb_1
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_4=create pb_4
this.dw_2=create dw_2
this.cbx_buyang=create cbx_buyang
this.dw_temp=create dw_temp
this.cb_1=create cb_1
this.dw_saup=create dw_saup
this.cb_2=create cb_2
this.cb_3=create cb_3
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_main
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.gb_4
this.Control[iCurrent+7]=this.gb_5
this.Control[iCurrent+8]=this.dw_emp
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.pb_3
this.Control[iCurrent+11]=this.pb_2
this.Control[iCurrent+12]=this.pb_4
this.Control[iCurrent+13]=this.dw_2
this.Control[iCurrent+14]=this.cbx_buyang
this.Control[iCurrent+15]=this.dw_temp
this.Control[iCurrent+16]=this.cb_1
this.Control[iCurrent+17]=this.dw_saup
this.Control[iCurrent+18]=this.cb_2
this.Control[iCurrent+19]=this.cb_3
this.Control[iCurrent+20]=this.rr_2
end on

on w_pip5000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.dw_main)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.dw_emp)
destroy(this.pb_1)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_4)
destroy(this.dw_2)
destroy(this.cbx_buyang)
destroy(this.dw_temp)
destroy(this.cb_1)
destroy(this.dw_saup)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.rr_2)
end on

event open;call super::open;dw_emp.SetTransObject(SQLCA)
dw_main.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_temp.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_2.InsertRow(0)

iv_workym = Left(gs_today,4)
iv_pbtag  = 'P'

dw_emp.SetRedraw(False)
dw_main.SetRedraw(False)
dw_1.SetRedraw(False)

dw_emp.Reset()
dw_emp.Insertrow(0)

String ls_today
ls_today = f_today()
if mid(ls_today,5,2) = '01' or mid(ls_today,5,2) = '02' then /*1월과 2월에는 작업년도를 작년으로 세팅*/
	ls_today = f_aftermonth(ls_today, -12)
end if
dw_2.Setitem(1,'syear',left(ls_today,4))


dw_main.Reset()
dw_main.InsertRow(0)

dw_1.Reset()
dw_1.InsertRow(0)

dw_saup.SetTransObject(sqlca)
dw_saup.insertrow(0)

f_set_saupcd(dw_saup,'saupcd','1')
dw_saup.modify("deptcode.protect = 1")
is_saupcd = gs_saupcd

dw_emp.SetRedraw(True)
dw_main.SetRedraw(True)
dw_1.SetRedraw(True)


end event

type p_mod from w_inherite_standard`p_mod within w_pip5000
integer x = 3872
integer taborder = 170
end type

event p_mod::clicked;call super::clicked;Int k

IF dw_main.Accepttext() = -1 THEN 	RETURN
IF dw_1.AcceptText() = -1 THEN RETURN

dw_main.SetItem(dw_main.GetRow(), "companycode", gs_company)
dw_main.SetItem(dw_main.GetRow(), "empno", iv_empno)
dw_main.SetItem(dw_main.GetRow(), "workyear", iv_workym)


//dw_1.SetItem(dw_1.GetRow(), "companycode", gs_company)
//dw_1.SetItem(dw_1.GetRow(), "empno", iv_empno)

//IF dw_main.RowCount() > 0 THEN
//	IF wf_required_check(dw_main.DataObject,dw_main.GetRow()) = -1 THEN RETURN
//END IF
//
//IF dw_1.RowCount() > 0 THEN
//	IF wf_required_check(dw_1.DataObject,dw_1.GetRow()) = -1 THEN RETURN
//END IF

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_main.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	MessageBox("확 인","정산자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

IF dw_1.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	MessageBox("확 인","기초공제 자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

COMMIT;

//cb_retrieve.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ib_any_typing = False

dw_main.Setfocus()

end event

type p_del from w_inherite_standard`p_del within w_pip5000
integer x = 4046
integer taborder = 200
end type

event p_del::clicked;call super::clicked;Int il_currow,k,il_rowcount

IF iv_empno ="" OR IsNull(iv_empno) THEN return

il_currow = dw_main.GetRow()

IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "사원번호 :"+iv_empno+"의 정산자료가 모두 삭제됩니다.~n"+&
									 "삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

SetPointer(HourGlass!)

dw_main.SetRedraw(False)

dw_main.DeleteRow(il_currow)

IF dw_main.Update() <> 1 THEN
	MessageBox("확 인","정산자료 삭제 실패!!")
	rollback;
	ib_any_typing =True
	dw_main.SetRedraw(True)
	Return
END IF

dw_1.SetRedraw(False)

il_rowcount = dw_1.GetRow()

dw_1.DeleteRow(il_rowcount)

IF dw_1.Update() <> 1 THEN
	MessageBox("확 인","기초공제자료 삭제 실패!!")
	rollback;
	ib_any_typing =True
	dw_1.SetRedraw(True)
	Return
END IF

dw_main.SetRedraw(True)
dw_1.SetRedraw(True)

commit;

p_can.TriggerEvent(Clicked!)
ib_any_typing =False
w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"

end event

type p_inq from w_inherite_standard`p_inq within w_pip5000
integer x = 3525
end type

event p_inq::clicked;call super::clicked;String sname, sColumnName, sempname

wf_check_modified()

if dw_emp.AcceptText() = -1 then return 
if dw_2.AcceptText() = -1 then return 

iv_workym = dw_2.GetItemString(1,"syear") 
iv_empno = dw_emp.GetItemString(1,"empno") 
sempname = dw_emp.GetItemString(1,"empname") 


dw_main.SetRedraw(False)
dw_1.SetRedraw(False)


IF IsNull(iv_workym) OR iv_workym ="" THEN 
	MessageBox("확 인","작업년도를 확인하세요!")
	dw_2.SetColumn("syear")
	dw_2.SetFocus()
	return
end if	


IF dw_emp.Retrieve(gs_company,iv_empno+'%',sempname+'%') <= 0 THEN
	Messagebox("확 인","등록된 사원이 아닙니다!!")	
	p_can.TriggerEvent(Clicked!)
	dw_main.SetRedraw(True)
	dw_1.SetRedraw(True)
	Return 
END IF

int li_rtn

IF dw_main.Retrieve(gs_company,iv_workym,iv_empno) <=0 THEN
	w_mdi_frame.sle_msg.text ="새로운 자료를 입력하십시요!!"
	//Messagebox("확 인","등록된 자료가 없습니다!!")
	dw_main.Reset()
	dw_main.InsertRow(0)
	dw_main.SetItem(dw_main.GetRow(),"companycode",gs_company)
	dw_main.SetItem(dw_main.GetRow(),"empno",iv_empno)
	dw_main.SetItem(dw_main.GetRow(),"workyear",iv_workym)
		
	dw_main.SetColumn(1)
	dw_main.SetFocus()
ELSE
	w_mdi_frame.sle_msg.text ="조회 완료!!"
END IF

li_rtn = dw_1.Retrieve(iv_workym,iv_empno)						/*작업년도 기초공제 자료 있는지 조회*/

if li_rtn <= 0 then
	if cbx_buyang.checked = false then
		if dw_temp.Retrieve(gs_company,iv_empno) <= 0 then		/*급여기본 데이타 조회*/
			dw_1.InsertRow(0)
			dw_1.SetItem(1,'workyear',iv_workym)
			dw_1.SetItem(1,'empno',iv_empno)
		else
			dw_1.InsertRow(0)
			dw_1.SetItem(1,'workyear',iv_workym)					/*현재 작업년도로 세팅*/
			dw_1.SetItem(1,'empno',dw_temp.GetItemString(1,'empno')) /*급여기본 데이타 COPY*/
			dw_1.SetItem(1,'wifetag',dw_temp.GetItemString(1,'wifetag'))
			dw_1.SetItem(1,'dependent20',dw_temp.GetItemNumber(1,'dependent20'))
			dw_1.SetItem(1,'dependent60',dw_temp.GetItemNumber(1,'dependent60'))
			dw_1.SetItem(1,'respect',dw_temp.GetItemNumber(1,'respect'))
			dw_1.SetItem(1,'respect1',dw_temp.GetItemNumber(1,'respect1'))
			dw_1.SetItem(1,'rubber',dw_temp.GetItemNumber(1,'rubber'))
			dw_1.SetItem(1,'womenhouse',dw_temp.GetItemString(1,'womenhouse'))
			dw_1.SetItem(1,'childcount',dw_temp.GetItemNumber(1,'childcount'))
		end if
	else																		/*전년도 정산용 데이타 조회*/
		if dw_1.Retrieve(string(long(iv_workym) - 1),iv_empno) <= 0 then
			dw_1.InsertRow(0)
			dw_1.SetItem(1,'workyear',iv_workym)
			dw_1.SetItem(1,'empno',iv_empno)
		else
			dw_1.SetItem(1,'workyear',iv_workym)					/*현재 작업년도로 세팅*/
		end if
	end if
end if


IF dw_main.GetItemString(dw_main.GetRow(), 'empno') = '' OR IsNull(dw_main.GetItemString(dw_main.GetRow(), 'empno')) then
	cb_1.enabled = False
	cb_2.enabled = False
	cb_3.enabled = False
ELSE
	cb_1.enabled = True
	cb_2.enabled = True
	cb_3.enabled = True
END IF


dw_main.SetRedraw(True)
dw_1.SetRedraw(True)

ib_any_typing = false

end event

type p_print from w_inherite_standard`p_print within w_pip5000
boolean visible = false
integer x = 2839
integer y = 2912
integer taborder = 290
end type

type p_can from w_inherite_standard`p_can within w_pip5000
integer x = 4219
integer taborder = 220
end type

event p_can::clicked;call super::clicked;dw_emp.SetRedraw(False)
dw_main.SetRedraw(False)
dw_1.SetRedraw(False)

dw_emp.Reset()
dw_emp.InsertRow(0)
dw_emp.SetColumn("empno")
dw_emp.SetFocus()

dw_main.Reset()
dw_main.Insertrow(0)
dw_main.SetItem(dw_main.GetRow(), "companycode", gs_company)
dw_main.SetItem(dw_main.GetRow(), "empno", iv_empno)
dw_main.SetItem(dw_main.GetRow(), "workyear", iv_workym)

dw_1.Reset()
dw_1.Insertrow(0)
dw_1.SetItem(dw_1.GetRow(), "workyear", iv_workym)
dw_1.SetItem(dw_1.GetRow(), "empno", iv_empno)

dw_emp.SetRedraw(True)
dw_main.SetRedraw(True)
dw_1.SetRedraw(True)

ib_any_typing = false

end event

type p_exit from w_inherite_standard`p_exit within w_pip5000
integer x = 4393
integer taborder = 250
end type

event p_exit::clicked;w_mdi_frame.sle_msg.text =""

wf_check_modified()

close(parent)
end event

type p_ins from w_inherite_standard`p_ins within w_pip5000
integer x = 3698
integer taborder = 100
end type

event p_ins::clicked;call super::clicked;wf_check_modified()

p_can.TriggerEvent(clicked!)
end event

type p_search from w_inherite_standard`p_search within w_pip5000
boolean visible = false
integer x = 2665
integer y = 2912
integer taborder = 270
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip5000
boolean visible = false
integer x = 2295
integer y = 2912
integer taborder = 120
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip5000
boolean visible = false
integer x = 2482
integer y = 2904
integer taborder = 140
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip5000
boolean visible = false
integer x = 3077
integer y = 2880
integer taborder = 20
end type

type st_window from w_inherite_standard`st_window within w_pip5000
boolean visible = false
integer taborder = 230
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip5000
boolean visible = false
integer x = 1778
integer y = 2904
integer taborder = 300
end type

type cb_update from w_inherite_standard`cb_update within w_pip5000
boolean visible = false
integer x = 745
integer y = 2900
integer taborder = 240
end type

event cb_update::clicked;call super::clicked;Int k

IF dw_main.Accepttext() = -1 THEN 	RETURN
IF dw_1.AcceptText() = -1 THEN RETURN

dw_main.SetItem(dw_main.GetRow(), "companycode", gs_company)
dw_main.SetItem(dw_main.GetRow(), "empno", iv_empno)
dw_main.SetItem(dw_main.GetRow(), "workyear", iv_workym)


//dw_1.SetItem(dw_1.GetRow(), "companycode", gs_company)
//dw_1.SetItem(dw_1.GetRow(), "empno", iv_empno)

//IF dw_main.RowCount() > 0 THEN
//	IF wf_required_check(dw_main.DataObject,dw_main.GetRow()) = -1 THEN RETURN
//END IF
//
//IF dw_1.RowCount() > 0 THEN
//	IF wf_required_check(dw_1.DataObject,dw_1.GetRow()) = -1 THEN RETURN
//END IF

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_main.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	MessageBox("확 인","정산자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

IF dw_1.Update() <> 1 THEN			
	ROLLBACK USING sqlca;
	MessageBox("확 인","기초공제 자료 저장 실패!!")
	ib_any_typing = True
	Return
END IF

COMMIT;

//cb_retrieve.TriggerEvent(Clicked!)

sle_msg.text ="자료를 저장하였습니다!!"
ib_any_typing = False

dw_main.Setfocus()

end event

type cb_insert from w_inherite_standard`cb_insert within w_pip5000
boolean visible = false
integer x = 379
integer y = 2900
integer taborder = 210
end type

event cb_insert::clicked;call super::clicked;cb_cancel.TriggerEvent(clicked!)


end event

type cb_delete from w_inherite_standard`cb_delete within w_pip5000
boolean visible = false
integer x = 1083
integer y = 2900
integer taborder = 260
end type

event cb_delete::clicked;call super::clicked;Int il_currow,k,il_rowcount

IF iv_empno ="" OR IsNull(iv_empno) THEN return

il_currow = dw_main.GetRow()

IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "사원번호 :"+iv_empno+"의 정산자료가 모두 삭제됩니다.~n"+&
									 "삭제하시겠습니까?",Question!,YesNo!) = 2 THEN RETURN

SetPointer(HourGlass!)

dw_main.SetRedraw(False)

dw_main.DeleteRow(il_currow)

IF dw_main.Update() <> 1 THEN
	MessageBox("확 인","정산자료 삭제 실패!!")
	rollback;
	ib_any_typing =True
	dw_main.SetRedraw(True)
	Return
END IF

dw_1.SetRedraw(False)

//il_rowcount = dw_1.GetRow()
//
////dw_1.DeleteRow(il_rowcount)
//
IF dw_1.Update() <> 1 THEN
	MessageBox("확 인","기초공제자료 삭제 실패!!")
	rollback;
	ib_any_typing =True
	dw_1.SetRedraw(True)
	Return
END IF

dw_main.SetRedraw(True)
dw_1.SetRedraw(True)

commit;

cb_cancel.TriggerEvent(Clicked!)
ib_any_typing =False
sle_msg.text ="자료를 삭제하였습니다!!"

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip5000
boolean visible = false
integer x = 37
integer y = 2892
integer taborder = 180
end type

event cb_retrieve::clicked;call super::clicked;//String sname, sColumnName, sempname
//
//if dw_emp.AcceptText() = -1 then return 
//
//iv_workym = left(em_ym.text,4)
//iv_empno = dw_emp.GetItemString(1,"empno") 
//sempname = dw_emp.GetItemString(1,"empname") 
//
//IF IsNull(iv_workym) OR iv_workym ="" THEN 
//	MessageBox("확 인","작업년도를 확인하세요!")
//	em_ym.setfocus()
//	return
//end if	
//
//IF IsNull(iv_empno) OR iv_empno ="" THEN 
//	iv_empno =""
//ELSE
//	sColumnName = "empno"
//	IF IsNull(wf_exiting_data(sColumnName,iv_empno,"0")) THEN
//		MessageBox("확 인","등록되지 않은 사번입니다!!")
//		dw_emp.setcolumn("empno")
//		dw_emp.setfocus()
//		Return
//	END IF
//END IF
//
//IF IsNull(sempname) OR sempname ="" THEN 
//	sempname =""	
//ELSE
//	sColumnName = "empname"
//	iv_empno = wf_exiting_data(sColumnName,sempname,"0")
//	IF IsNull(iv_empno) THEN
//		MessageBox("확 인","등록되지 않은 사원입니다!!")
//		dw_emp.setcolumn("empname")
//		dw_emp.setfocus()		
//		Return
//	END IF
//END IF
//
//IF dw_emp.Retrieve(gs_company,iv_empno+'%',sempname+'%') <= 0 THEN
//	Messagebox("확 인","등록된 사원이 아닙니다!!")
//	cb_cancel.TriggerEvent(Clicked!)
//	Return 
//END IF
//
//dw_main.SetRedraw(False)
//dw_1.SetRedraw(False)
//
//IF dw_main.Retrieve(gs_company,iv_workym,iv_empno) <=0 THEN
//	sle_msg.text ="새로운 자료를 입력하십시요!!"
//	Messagebox("확 인","등록된 자료가 없습니다!!")
//	dw_main.Reset()
//	dw_main.InsertRow(0)
//	dw_main.SetItem(dw_main.GetRow(),"companycode",gs_company)
//	dw_main.SetItem(dw_main.GetRow(),"empno",iv_empno)
//	dw_main.SetItem(dw_main.GetRow(),"workyear",iv_workym)
//		
//	dw_main.SetColumn(1)
//	dw_main.SetFocus()
//		
////	dw_1.Reset()
////	dw_1.InsertRow(0)
////	dw_1.SetItem(dw_1.GetRow(),"companycode",gs_company)
////	dw_1.SetItem(dw_1.GetRow(),"empno",iv_empno)			
//	dw_1.Retrieve(gs_company,iv_empno)	
//ELSE
//	dw_1.Retrieve(gs_company,iv_empno)
//	sle_msg.text =""
//END IF
//
//dw_main.SetRedraw(True)
//dw_1.SetRedraw(True)
//
//
//
end event

type st_1 from w_inherite_standard`st_1 within w_pip5000
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip5000
boolean visible = false
integer x = 1431
integer y = 2904
integer taborder = 280
end type

event cb_cancel::clicked;call super::clicked;dw_emp.SetRedraw(False)
dw_main.SetRedraw(False)
dw_1.SetRedraw(False)

dw_emp.Reset()
dw_emp.InsertRow(0)
dw_emp.SetColumn("empno")
dw_emp.SetFocus()

dw_main.Reset()
dw_main.Insertrow(0)
dw_main.SetItem(dw_main.GetRow(), "companycode", gs_company)
dw_main.SetItem(dw_main.GetRow(), "empno", iv_empno)
dw_main.SetItem(dw_main.GetRow(), "workyear", iv_workym)

dw_1.Reset()
dw_1.Insertrow(0)
dw_1.SetItem(dw_1.GetRow(), "companycode", gs_company)
dw_1.SetItem(dw_1.GetRow(), "empno", iv_empno)

dw_emp.SetRedraw(True)
dw_main.SetRedraw(True)
dw_1.SetRedraw(True)

end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pip5000
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip5000
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip5000
boolean visible = false
integer x = 2062
integer width = 1531
integer height = 176
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip5000
boolean visible = false
integer x = 64
integer width = 805
integer height = 176
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip5000
boolean visible = false
integer y = 3068
end type

type rr_1 from roundrectangle within w_pip5000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 105
integer y = 188
integer width = 3593
integer height = 200
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_pip5000
event ue_enter pbm_dwnprocessenter
integer x = 3904
integer y = 488
integer width = 626
integer height = 1240
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_pip5000_2"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;RETURN 1
end event

event editchanged;ib_any_typing = true
end event

event itemchanged;ib_any_typing = true
end event

type dw_main from datawindow within w_pip5000
event ue_enter pbm_dwnprocessenter
integer x = 96
integer y = 400
integer width = 3758
integer height = 1964
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pip5000_1"
boolean border = false
boolean livescroll = true
end type

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event getfocus;dw_emp.Accepttext()
end event

event editchanged;ib_any_typing = true
end event

event itemchanged;ib_any_typing = true
end event

type rb_1 from radiobutton within w_pip5000
integer x = 270
integer y = 60
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사번순"
boolean checked = true
end type

type rb_2 from radiobutton within w_pip5000
integer x = 576
integer y = 60
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "성명순"
end type

type gb_4 from groupbox within w_pip5000
integer x = 219
integer width = 695
integer height = 168
integer taborder = 70
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "정렬"
end type

type gb_5 from groupbox within w_pip5000
integer x = 1033
integer y = 4
integer width = 530
integer height = 164
integer taborder = 90
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "자료선택"
end type

type dw_emp from u_key_enter within w_pip5000
event ue_key pbm_dwnkey
integer x = 864
integer y = 196
integer width = 2706
integer height = 180
integer taborder = 40
string dataobject = "d_pip5000_3"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sEmpName,snull, ls_name
Int il_RowCount

SetNull(snull)

iv_workym = dw_2.GetitemString(1,'syear')

wf_check_modified()

dw_main.SetRedraw(False)
dw_1.SetRedraw(False)


If dw_emp.GetColumnName() = "empname" Then
	 sEmpName = this.Gettext()

   iv_empno = wf_exiting_saup_name('empname',sEmpName, '1', is_saupcd)	 
	 if IsNull(iv_empno) then 
		 Setitem(1,'empname',ls_name)
		 Setitem(1,'empno',ls_name)
		 return 1
    end if
	 Setitem(1,"empno",ls_name)
	 ls_name = wf_exiting_saup_name('empno',ls_name, '1', is_saupcd)
	 Setitem(1,"empname",ls_name)
END IF

If dw_emp.GetColumnName() = "empno" Then

	iv_empno = this.GetText()
	
	IF iv_empno ="" OR IsNull(iv_empno) THEN RETURN

	iv_empno = wf_exiting_saup_data("empno",iv_empno,"1",is_saupcd)

	IF IsNull(iv_empno) THEN
		Messagebox("확 인","등록되지 않은 사번이므로 등록할 수 없습니다!!")
		dw_emp.SetRedraw(False)
		dw_emp.Reset()
		dw_emp.InsertRow(0)
		dw_emp.SetColumn("empno")
		dw_emp.SetFocus()
		dw_emp.SetRedraw(True)
		Return 1
	END IF
	
	IF iv_empno = '' THEN
		dw_emp.SetRedraw(False)
		dw_emp.Reset()
		dw_emp.InsertRow(0)
		dw_emp.SetColumn("empno")
		dw_emp.SetFocus()
		dw_emp.SetRedraw(True)
		Return 1
	END IF

END IF

dw_emp.Retrieve(gs_company,iv_empno,'%')
p_inq.TriggerEvent(Clicked!)
end event

event itemfocuschanged;call super::itemfocuschanged;
IF dwo.name ="empname" THEN
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
ELSE
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
END IF	
end event

event rbuttondown;call super::rbuttondown;
SetNull(Gs_code)
SetNull(Gs_codename)
SetNull(Gs_gubun)

this.AcceptText()
dw_saup.AcceptText()

Gs_gubun = is_saupcd

IF This.GetColumnName() = "empname" THEN
	Gs_Codename = this.GetItemString(this.GetRow(),"empname")
	
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empname",Gs_codeName)
	this.TriggerEvent(ItemChanged!)

ELSEIF This.GetColumnName() = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",Gs_code)
	this.TriggerEvent(ItemChanged!)
END IF


end event

event itemerror;call super::itemerror;return 1
end event

type pb_1 from picturebutton within w_pip5000
integer x = 1065
integer y = 60
integer width = 101
integer height = 88
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\first.gif"
alignment htextalign = left!
end type

event clicked;string scode,sname,sMin_name

iv_workym = dw_2.GetitemString(1,'syear')

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_emp.getitemstring(1, "empno")

	SELECT min("P1_MASTER"."EMPNO")  
		INTO :iv_empno  
	   FROM "P1_MASTER", "P0_DEPT" 
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND  
		      "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" and
				"P0_DEPT"."SAUPCD" = :is_saupcd and  servicekindcode <> '3';
	IF IsNull(iv_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_emp.GetItemString(1,"empname")
	
	SELECT min("P1_MASTER"."EMPNAME")  
		INTO :sMin_name  
	   FROM "P1_MASTER", "P0_DEPT" 
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND  
		      "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" and
				"P0_DEPT"."SAUPCD" = :is_saupcd and servicekindcode <> '3';
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :iv_empno 
	   	FROM "P1_MASTER", "P0_DEPT" 
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND  
		      "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" and
				"P0_DEPT"."SAUPCD" = :is_saupcd and "P1_MASTER"."EMPNAME" =:sMin_name and servicekindcode <> '3';
	END IF
End If

dw_emp.SetRedraw(false)
dw_emp.Retrieve(gs_company,iv_empno,'%')
dw_emp.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)

//dw_main.SetRedraw(False)
//dw_1.SetRedraw(False)
//
//if dw_main.Retrieve(gs_company,iv_workym,iv_empno) <= 0 then
//	dw_main.InsertRow(0)
//end if	
//if dw_1.Retrieve(gs_company,iv_empno) <= 0 then
//	dw_1.InsertRow(0)
//end if
//
//dw_main.SetRedraw(True)
//dw_1.SetRedraw(True)
//dw_emp.SetRedraw(True)
end event

type pb_3 from picturebutton within w_pip5000
integer x = 1184
integer y = 60
integer width = 101
integer height = 88
integer taborder = 130
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\prior.gif"
end type

event clicked;string scode,sname,sMax_name

iv_workym = dw_2.GetitemString(1,'syear')

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_emp.getitemstring(1, "empno")
	
	SELECT MAX("P1_MASTER"."EMPNO")  
   	INTO :iv_empno  
	   FROM "P1_MASTER", "P0_DEPT" 
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND  
		      "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" and
				"P0_DEPT"."SAUPCD" = :is_saupcd and "P1_MASTER"."EMPNO" < :scode and servicekindcode <> '3';
	IF IsNull(iv_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_emp.GetItemString(1,"empname")
	
	SELECT MAX("P1_MASTER"."EMPNAME")  
   	INTO :sMax_name 
	   FROM "P1_MASTER", "P0_DEPT" 
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND  
		      "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" and
				"P0_DEPT"."SAUPCD" = :is_saupcd and "P1_MASTER"."EMPNAME" < :sname and servicekindcode <> '3';
	IF IsNull(sMax_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :iv_empno 
	   	FROM "P1_MASTER", "P0_DEPT" 
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND  
		      "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" and
				"P0_DEPT"."SAUPCD" = :is_saupcd and "P1_MASTER"."EMPNAME" =:sMax_name and servicekindcode <> '3';
	END IF
End If


dw_emp.SetRedraw(false)
dw_emp.Retrieve(gs_company,iv_empno,'%')
dw_emp.SetRedraw(True)
p_inq.TriggerEvent(Clicked!)

//dw_main.SetRedraw(False)
//dw_1.SetRedraw(False)
//
//if dw_main.Retrieve(gs_company,iv_workym,iv_empno) <= 0 then
//	dw_main.InsertRow(0)
//end if	
//if dw_1.Retrieve(gs_company,iv_empno) <= 0 then
//	dw_1.InsertRow(0)
//end if
//
//dw_main.SetRedraw(True)
//dw_1.SetRedraw(True)
//dw_emp.SetRedraw(True)

end event

type pb_2 from picturebutton within w_pip5000
integer x = 1303
integer y = 60
integer width = 101
integer height = 88
integer taborder = 150
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\next.gif"
end type

event clicked;string scode,sname,sMin_name

iv_workym = dw_2.GetitemString(1,'syear')

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_emp.getitemstring(1, "empno")
	
	SELECT MIN("P1_MASTER"."EMPNO")  
   	INTO :iv_empno  
   	FROM "P1_MASTER", "P0_DEPT" 
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND  
		      "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" and
				"P0_DEPT"."SAUPCD" = :is_saupcd and  "P1_MASTER"."EMPNO" > :scode and servicekindcode <> '3';
	IF IsNull(iv_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_emp.GetItemString(1,"empname")
	
	SELECT MIN("P1_MASTER"."EMPNAME")  
   	INTO :sMin_name  
   	FROM "P1_MASTER", "P0_DEPT" 
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND  
		      "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" and
				"P0_DEPT"."SAUPCD" = :is_saupcd and "P1_MASTER"."EMPNAME" > :sname and servicekindcode <> '3';
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :iv_empno 
	   	FROM "P1_MASTER", "P0_DEPT" 
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND  
		      "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" and
				"P0_DEPT"."SAUPCD" = :is_saupcd and "P1_MASTER"."EMPNAME" =:sMin_name and servicekindcode <> '3';
	END IF
End If


dw_emp.SetRedraw(false)
dw_emp.Retrieve(gs_company,iv_empno,'%')
dw_emp.SetRedraw(True)
p_inq.TriggerEvent(Clicked!)

//dw_main.SetRedraw(False)
//dw_1.SetRedraw(False)
//
//if dw_main.Retrieve(gs_company,iv_workym,iv_empno) <= 0 then
//	dw_main.InsertRow(0)
//end if	
//if dw_1.Retrieve(gs_company,iv_empno) <= 0 then
//	dw_1.InsertRow(0)
//end if
//
//dw_main.SetRedraw(True)
//dw_1.SetRedraw(True)
//dw_emp.SetRedraw(True)





end event

type pb_4 from picturebutton within w_pip5000
integer x = 1422
integer y = 60
integer width = 101
integer height = 88
integer taborder = 190
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\last.gif"
end type

event clicked;string scode,sname,sMin_name

iv_workym = dw_2.GetitemString(1,'syear')

IF ib_any_typing = True THEN
	MessageBox("확 인","저장하지 않은 자료가 존재합니다!!")
	Return
END IF

IF rb_1.Checked = True THEN
	scode = dw_emp.getitemstring(1, "empno")
	
	SELECT MAX("P1_MASTER"."EMPNO")  
   	INTO :iv_empno  
   	FROM "P1_MASTER", "P0_DEPT" 
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND  
		      "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" and
				"P0_DEPT"."SAUPCD" = :is_saupcd and "P1_MASTER"."EMPNO" > :scode and servicekindcode <> '3';
	IF IsNull(iv_empno) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	END IF
ELSE
	sname = dw_emp.GetItemString(1,"empname")
	
	SELECT MAX("P1_MASTER"."EMPNAME")  
   	INTO :sMin_name  
   	FROM "P1_MASTER", "P0_DEPT" 
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND  
		      "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" and
				"P0_DEPT"."SAUPCD" = :is_saupcd and "P1_MASTER"."EMPNAME" > :sname and servicekindcode <> '3';
	IF IsNull(sMin_name) THEN 
		MessageBox('확 인','더이상 자료가 없습니다.')
		Return
	ELSE
		SELECT "P1_MASTER"."EMPNO"  
			INTO :iv_empno 
	   	FROM "P1_MASTER", "P0_DEPT" 
   	WHERE "P1_MASTER"."COMPANYCODE" = :gs_company AND  
		      "P1_MASTER"."DEPTCODE" = "P0_DEPT"."DEPTCODE" and
				"P0_DEPT"."SAUPCD" = :is_saupcd and "P1_MASTER"."EMPNAME" =:sMin_name and servicekindcode <> '3';
	END IF
End If


dw_emp.SetRedraw(false)
dw_emp.Retrieve(gs_company,iv_empno,'%')
dw_emp.SetRedraw(True)
p_inq.TriggerEvent(Clicked!)

//dw_main.SetRedraw(False)
//dw_1.SetRedraw(False)
//
//if dw_main.Retrieve(gs_company,iv_workym,iv_empno) <= 0 then
//	dw_main.InsertRow(0)
//end if	
//if dw_1.Retrieve(gs_company,iv_empno) <= 0 then
//	dw_1.InsertRow(0)
//end if
//
//dw_main.SetRedraw(True)
//dw_1.SetRedraw(True)
//dw_emp.SetRedraw(True)





end event

type dw_2 from datawindow within w_pip5000
integer x = 123
integer y = 220
integer width = 741
integer height = 120
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pip5000_4"
boolean border = false
boolean livescroll = true
end type

type cbx_buyang from checkbox within w_pip5000
boolean visible = false
integer x = 3785
integer y = 320
integer width = 750
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 27528544
long backcolor = 32106727
string text = "기초공제 전년자료 활용"
end type

type dw_temp from datawindow within w_pip5000
boolean visible = false
integer x = 4018
integer y = 1896
integer width = 485
integer height = 252
integer taborder = 160
string title = "none"
string dataobject = "d_pip5000_21"
boolean border = false
boolean livescroll = true
end type

type cb_1 from commandbutton within w_pip5000
integer x = 2679
integer y = 1624
integer width = 142
integer height = 68
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "등록"
end type

event clicked;muiltstr stparm

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

	IF dw_2.AcceptText() = -1 THEN RETURN
  	gs_gubun = dw_2.GetItemString(dw_2.GetRow(), 'syear')
	
	IF dw_main.AcceptText() = -1 THEN RETURN
	IF dw_main.GetRow() < 1 THEN RETURN
				
	gs_code = dw_main.GetItemString(dw_main.GetRow(), 'empno')
		
	SELECT empname
	  INTO :gs_codename
	  FROM p1_master
	 WHERE empno = :gs_code;
	 
stparm.s[1] = '2'

OpenWithParm(w_pip5003, stparm)

stparm = Message.PowerObjectParm
if gs_gubun <> 'exit' then
	dw_main.SetItem(1,'allpurse',stparm.dc[1])		// 전액기부금
	dw_main.SetItem(1,'politicalamt',stparm.dc[2])	// 정치자금
	dw_main.SetItem(1,'education22',stparm.dc[3])	// 50% 기부금
	dw_main.SetItem(1,'education23',stparm.dc[4])	// 30% 기부금
	dw_main.SetItem(1,'limitpurse',stparm.dc[5])		// 10% 기부금
	dw_main.SetItem(1,'etcpurse',stparm.dc[6])		// 10% 기부금
	SetNull(gs_gubun)
	ib_any_typing = true
end if
end event

type dw_saup from datawindow within w_pip5000
integer x = 1659
integer y = 60
integer width = 672
integer height = 80
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_saupcd_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;this.AcceptText()

IF this.GetColumnName() ="saupcd" THEN 
   is_saupcd = this.GetText()
	IF trim(is_saupcd) = '' OR ISNULL(is_saupcd) THEN is_saupcd = '%'
END IF
end event

event rbuttondown;//IF this.GetColumnName() = "deptcode" THEN
//	SetNull(gs_code)
//	SetNull(gs_codename)
//	SetNull(gs_gubun)
//
//	gs_gubun = this.GetItemString(GetRow(),'saupcd')
//	if isnull(gs_gubun) or trim(gs_gubun) = '' then gs_gubun = '%'
//	Open(w_dept_saup_popup)
//	
//	IF IsNull(Gs_code) THEN RETURN
//	this.SetITem(1,"deptcode",gs_code)
//	this.TriggerEvent(ItemChanged!)
//END IF
end event

type cb_2 from commandbutton within w_pip5000
integer x = 2679
integer y = 656
integer width = 142
integer height = 68
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "등록"
end type

event clicked;muiltstr stparm

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

IF dw_2.AcceptText() = -1 THEN RETURN
gs_gubun = dw_2.GetItemString(dw_2.GetRow(), 'syear')

IF dw_main.AcceptText() = -1 THEN RETURN
IF dw_main.GetRow() < 1 THEN RETURN
			
gs_code = dw_main.GetItemString(dw_main.GetRow(), 'empno')
	
SELECT empname
  INTO :gs_codename
  FROM p1_master
 WHERE empno = :gs_code;

stparm.s[1] = '1'

OpenWithParm(w_pip5003, stparm)

stparm = Message.PowerObjectParm
if gs_gubun <> 'exit' then
	dw_main.SetItem(1,'medrespectfine',stparm.dc[1]) 	//본인.장애.경로의료비
	dw_main.SetItem(1,'medselffine',stparm.dc[2])		//일반의료비
	SetNull(gs_gubun)
	ib_any_typing = true
end if


end event

type cb_3 from commandbutton within w_pip5000
integer x = 3977
integer y = 400
integer width = 521
integer height = 80
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "부양가족 명세등록"
end type

event clicked;muiltstr stparm

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

IF dw_2.AcceptText() = -1 THEN RETURN
gs_codename2 = dw_2.GetItemString(dw_2.GetRow(), 'syear')

IF dw_main.AcceptText() = -1 THEN RETURN
IF dw_main.GetRow() < 1 THEN RETURN
			
gs_code = dw_main.GetItemString(dw_main.GetRow(), 'empno')
	
SELECT empname
  INTO :gs_codename
  FROM p1_master
 WHERE empno = :gs_code;
 
gs_gubun = iv_workym
			
OpenWithParm(w_pip5004, stparm)
 
dw_1.Retrieve(iv_workym,iv_empno) /*기초공제 조회*/

stparm = Message.PowerObjectParm
if gs_gubun <> 'exit' then
	dw_main.SetItem(1,'insuranceamt',			stparm.dc[1])	// 일반보험료
	dw_main.SetItem(1,'rubberinsuranceamt',	stparm.dc[2])	// 장애인보험료
	dw_main.SetItem(1,'medselffine',				stparm.dc[3])	// 일반의료비
	dw_main.SetItem(1,'medrespectfine',			stparm.dc[4])	// 본인.경로.장애의료비
	dw_main.SetItem(1,'cdcardamt',				stparm.dc[5])	// 신용카드등
	dw_main.SetItem(1,'cashbill',					stparm.dc[6])	// 현금영수증
	SetNull(gs_gubun)
	ib_any_typing = true
end if
end event

type rr_2 from roundrectangle within w_pip5000
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 1618
integer y = 40
integer width = 759
integer height = 112
integer cornerheight = 40
integer cornerwidth = 55
end type

