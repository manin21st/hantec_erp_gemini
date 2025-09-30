$PBExportHeader$w_pip1004.srw
$PBExportComments$** 개인별 국민연금/건강보험 수정
forward
global type w_pip1004 from w_inherite_multi
end type
type gb_4 from groupbox within w_pip1004
end type
type dw_main from u_d_select_sort within w_pip1004
end type
type dw_1 from datawindow within w_pip1004
end type
type dw_ip from datawindow within w_pip1004
end type
type rr_1 from roundrectangle within w_pip1004
end type
end forward

global type w_pip1004 from w_inherite_multi
string title = "개인별 국민연금/건강보험 수정"
gb_4 gb_4
dw_main dw_main
dw_1 dw_1
dw_ip dw_ip
rr_1 rr_1
end type
global w_pip1004 w_pip1004

type variables

end variables

on w_pip1004.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.dw_main=create dw_main
this.dw_1=create dw_1
this.dw_ip=create dw_ip
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.dw_main
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_ip
this.Control[iCurrent+5]=this.rr_1
end on

on w_pip1004.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.dw_main)
destroy(this.dw_1)
destroy(this.dw_ip)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_ip.Insertrow(0)
dw_ip.SetItem(1,'sdate',f_today())

dw_main.SetTransObject(SQLCA)
dw_main.Retrieve(gs_company,'%','%','%','%')

end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1004
boolean visible = false
integer x = 4192
integer y = 2792
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1004
boolean visible = false
integer x = 4018
integer y = 2792
end type

type p_search from w_inherite_multi`p_search within w_pip1004
boolean visible = false
integer x = 3675
integer y = 2788
end type

type p_ins from w_inherite_multi`p_ins within w_pip1004
integer x = 3712
end type

event p_ins::clicked;call super::clicked;Int	 il_currow,il_functionvalue
String ls_empno

IF dw_main.RowCount() <=0 THEN
	il_currow = 1
ELSE
	il_currow = dw_main.GetRow() 
END IF

ls_empno = trim(dw_main.GetItemString(il_currow, 'empno'))

IF IsNull(ls_empno) OR ls_empno = '' THEN
	MessageBox('확 인','사번을 입력하셔야 합니다!!')
	return
END IF

dw_main.InsertRow(il_currow)
dw_main.SetItem(il_currow,'companycode',gs_company)
dw_main.ScrollToRow(il_currow)
dw_main.SetColumn('empno')
dw_main.SetFocus()

end event

type p_exit from w_inherite_multi`p_exit within w_pip1004
integer x = 4407
end type

type p_can from w_inherite_multi`p_can within w_pip1004
integer x = 4233
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''

ib_any_typing = false

p_inq.TriggerEvent(Clicked!)
end event

type p_print from w_inherite_multi`p_print within w_pip1004
boolean visible = false
integer x = 3849
integer y = 2788
end type

type p_inq from w_inherite_multi`p_inq within w_pip1004
integer x = 3538
end type

event p_inq::clicked;call super::clicked;String ls_saup, ls_deptcode, ls_jikjong, ls_kunmu, ls_date

w_mdi_frame.sle_msg.text = '조회중.....'

dw_ip.AcceptText()
ls_saup		= dw_ip.GetItemString(1,'saup')
ls_deptcode	= dw_ip.GetItemString(1,'deptcode')
ls_jikjong	= dw_ip.GetItemString(1,'jikjong')
ls_kunmu		= dw_ip.GetItemString(1,'kunmu')
ls_date		= dw_ip.GetItemString(1,'sdate')

IF f_datechk(ls_date) = -1 THEN
	Messagebox('확인','퇴직기준일자를 확인하세요!')
	dw_ip.SetColumn('sdate')
	dw_ip.SetFocus()
END IF

IF IsNull(ls_saup)		OR ls_saup = '' 		THEN ls_saup = '%'
IF IsNull(ls_deptcode)	OR ls_deptcode = ''	THEN ls_deptcode = '%'
IF IsNull(ls_jikjong)	OR ls_jikjong = ''	THEN ls_jikjong = '%'
IF IsNull(ls_kunmu)		OR ls_kunmu = ''		THEN ls_kunmu = '%'

IF dw_main.Retrieve(gs_company,ls_saup,ls_deptcode,ls_jikjong,ls_kunmu, ls_date) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!",StopSign!)
	Return
END IF

w_mdi_frame.sle_msg.text = "조회를 완료하였습니다!!"

dw_main.SetFocus()

end event

type p_del from w_inherite_multi`p_del within w_pip1004
integer x = 4059
end type

event p_del::clicked;call super::clicked;String ls_empname
Int	 il_currow

il_currow = dw_main.GetRow()
IF il_currow <=0 Then Return
ls_empname = dw_main.GetItemString(il_currow, 'empname')
IF IsNull(ls_empname) THEN ls_empname = ''

IF	MessageBox("삭제 확인", "삭제하면 "+ls_empname+" 사원의 급여 관련 데이터가 모두 삭제됩니다.~r삭제하시겠습니까? ",&
					question!, yesno!) = 2 THEN return
	
dw_main.DeleteRow(il_currow)

IF dw_main.Update() > 0 THEN
	commit;
	IF il_currow = 1 THEN
	ELSE
		dw_main.ScrollToRow(il_currow - 1)
	END IF
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
ELSE
	rollback;
	ib_any_typing =True
	Return
END IF

end event

type p_mod from w_inherite_multi`p_mod within w_pip1004
integer x = 3886
end type

event p_mod::clicked;call super::clicked;string ls_empno

IF dw_main.Accepttext() = -1 THEN 	RETURN

ls_empno = trim(dw_main.GetItemString(dw_main.GetRow(), 'empno'))

IF IsNull(ls_empno) OR ls_empno = '' THEN
	MessageBox('확 인','사번을 입력하셔야 합니다!!')
	return
END IF

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF

dw_main.Setfocus()
end event

type dw_insert from w_inherite_multi`dw_insert within w_pip1004
boolean visible = false
integer x = 1431
integer y = 2600
end type

type st_window from w_inherite_multi`st_window within w_pip1004
boolean visible = false
end type

type cb_append from w_inherite_multi`cb_append within w_pip1004
boolean visible = false
integer taborder = 40
end type

event cb_append::clicked;call super::clicked;//Int il_currow,il_functionvalue
//
//IF dw_main.RowCount() <=0 THEN
//	il_currow = 0
//	il_functionvalue =1
//ELSE
//	il_functionvalue = wf_requiredcheck(dw_main.GetRow())
//	
//	il_currow = dw_main.GetRow() 
//END IF
//
//IF il_functionvalue = 1 THEN
//	il_currow = il_currow + 1
//	
//	dw_main.InsertRow(il_currow)
//	IF rb_2.Checked = True THEN
//		dw_main.SetItem(il_currow,"companycode",gs_company)	
//		dw_main.SetColumn("meddegree")
//	ELSE
//		dw_main.SetColumn("pendegree")
//	END IF
//	
//	dw_main.ScrollToRow(il_currow)
//	dw_main.SetFocus()
//	
//END IF
//
end event

type cb_exit from w_inherite_multi`cb_exit within w_pip1004
boolean visible = false
integer taborder = 90
end type

type cb_update from w_inherite_multi`cb_update within w_pip1004
boolean visible = false
integer taborder = 60
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip1004
boolean visible = false
integer taborder = 50
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip1004
boolean visible = false
integer taborder = 70
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1004
boolean visible = false
integer taborder = 30
end type

type st_1 from w_inherite_multi`st_1 within w_pip1004
boolean visible = false
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1004
boolean visible = false
integer taborder = 80
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1004
boolean visible = false
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1004
boolean visible = false
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1004
boolean visible = false
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1004
boolean visible = false
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1004
boolean visible = false
end type

type gb_4 from groupbox within w_pip1004
boolean visible = false
integer x = 1815
integer y = 2496
integer width = 1847
integer height = 208
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
end type

type dw_main from u_d_select_sort within w_pip1004
event ue_pressenter pbm_dwnprocessenter
integer x = 494
integer y = 264
integer width = 3566
integer height = 1960
integer taborder = 20
string dataobject = "d_pip1004_1"
boolean border = false
end type

event ue_pressenter;send(handle(this), 256, 9, 0)
return 1
end event

event itemchanged;call super::itemchanged;Int il_currow
String slevel, snull, ls_empno, ls_dept, ls_empname, ls_deptname 
double dAmount,samount

SetNull(snull)

il_currow = this.GetRow()

IF this.GetColumnName() = 'empno' THEN
	ls_empno = this.GetText()
	
	IF ls_empno = "" OR IsNull(ls_empno) THEN
		this.SetItem(il_currow,"companycode",snull)
		this.SetItem(il_currow,"deptcode",snull)		
		this.SetItem(il_currow,"deptname",snull)
		this.SetItem(il_currow,"empname",snull)
		return
	END IF
	
	//사원 정보 가져오기
	SELECT	"P1_MASTER"."EMPNAME",
				"P0_DEPT"."DEPTCODE",
			 	"P0_DEPT"."DEPTNAME"
		 INTO :ls_empname, :ls_dept, :ls_deptname
		 FROM "P1_MASTER", "P0_DEPT"
		WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND
				( "P1_MASTER"."EMPNO" = :ls_empno ) AND
				( "P0_DEPT"."COMPANYCODE" = "P1_MASTER"."COMPANYCODE" ) AND
				( "P0_DEPT"."DEPTCODE" = "P1_MASTER"."DEPTCODE" )   ;
	if sqlca.sqlcode <> 0 then
		messagebox("확인","사번을 확인하십시오!")
		this.SetItem(il_currow,"empno",snull)
		this.setcolumn("empno")
		return 1
	end if
	
		this.SetItem(il_currow,"companycode",gs_company)
		this.SetItem(il_currow,"deptcode",ls_dept)		
		this.SetItem(il_currow,"deptname",ls_deptname)
		this.SetItem(il_currow,"empname",ls_empname)
END IF


IF this.GetColumnName() = "meddegree" THEN											//의료보험
	
	slevel = THIS.GETTEXT()
	SELECT "P3_MEDINSURANCETABLE"."MEDSELFFINE", "P3_MEDINSURANCETABLE"."MEDSTANDARDWAGE"
	   INTO :dAmount  , :samount
	   FROM "P3_MEDINSURANCETABLE"
   	WHERE ( "P3_MEDINSURANCETABLE"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P3_MEDINSURANCETABLE"."MEDDEGREE" = :slevel );
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(il_currow,"medamt",damount)
		this.SetItem(il_currow,"medstandardwage",samount)
	ELSE
		MessageBox('확 인','등록되지 않은 등급입니다!!',stopsign!)
		this.SetItem(il_currow,"meddegree",snull)
		return 1
	END IF
END IF

IF this.GetColumnName() = "pendegree" THEN											//국민연금
	
	slevel = THIS.GETTEXT()
	SELECT "P3_PENSIONTABLE"."PENSELFFINE", "P3_PENSIONTABLE"."PENSTANDARDWAGE"
	   INTO :dAmount  , :samount
	   FROM "P3_PENSIONTABLE"  
   	WHERE "P3_PENSIONTABLE"."PENDEGREE" = :slevel;
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(il_currow,"penstandardwage",samount)
		this.SetItem(il_currow,"penamt",damount)
	ELSE
		MessageBox('확 인','등록되지 않은 등급입니다!!',stopsign!)
		this.SetItem(il_currow,"pendegree",snull)
		return 1
	END IF
END IF


end event

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;this.SelectRow(0, FALSE)
this.SelectRow(currentrow, TRUE)

end event

event editchanged;call super::editchanged;ib_any_typing =True


end event

event itemfocuschanged;call super::itemfocuschanged;
//IF dwo.name = "allowname" THEN
//	f_toggle_kor(handle(parent))
//ELSE
//	f_toggle_eng(handle(parent))
//END IF
end event

event rbuttondown;call super::rbuttondown;double damount, samount
SetNull(Gs_code)

IF this.GetColumnName() = "empno" THEN

	open(w_employee_popup)
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",Gs_code)
	TriggerEvent(ItemChanged!)
END IF

IF this.GetColumnName() = "meddegree" THEN

	open(w_medde_popup)
	damount = 0
	samount = 0	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"meddegree",Gs_code)
	SELECT "P3_MEDINSURANCETABLE"."MEDSELFFINE", "P3_MEDINSURANCETABLE"."MEDSTANDARDWAGE"
	   INTO :dAmount  , :samount
	   FROM "P3_MEDINSURANCETABLE"
   	WHERE ( "P3_MEDINSURANCETABLE"."COMPANYCODE" = :gs_company ) AND  
      	   ( "P3_MEDINSURANCETABLE"."MEDDEGREE" = :gs_code )   ;
	IF SQLCA.SQLCODE = 0 THEN
	   this.SetItem(this.GetRow(),"meddegree",Gs_code)
		this.SetItem(this.GetRow(),"medamt",damount)
		this.SetItem(this.GetRow(),"medstandardwage",samount)
	end if
END IF

IF this.GetColumnName() = "pendegree" THEN

	open(w_pende_popup)
	damount = 0
	samount = 0
	IF IsNull(Gs_code) THEN RETURN

	this.SetItem(this.GetRow(),"pendegree",Gs_code)
	SELECT "P3_PENSIONTABLE"."PENSELFFINE", "P3_PENSIONTABLE"."PENSTANDARDWAGE"
	   INTO :dAmount  , :samount
	   FROM "P3_PENSIONTABLE"  
   	WHERE "P3_PENSIONTABLE"."PENDEGREE" = :gs_code   ;
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(this.GetRow(),"pendegree",Gs_code)
		this.SetItem(this.GetRow(),"penstandardwage",samount)
		this.SetItem(this.GetRow(),"penamt",damount)
	end if
END IF
end event

type dw_1 from datawindow within w_pip1004
boolean visible = false
integer x = 1829
integer y = 2552
integer width = 1815
integer height = 96
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_pip1003_1"
boolean border = false
boolean livescroll = true
end type

type dw_ip from datawindow within w_pip1004
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 494
integer y = 24
integer width = 2450
integer height = 216
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pip1004_2"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;//F1 key를 누르면 코드조회처리함	

if KeyDown(KeyF1!) then
	TriggerEvent(RbuttonDown!)
end if
end event

event itemchanged;String ls_deptcode, ls_dept, ls_deptname, snull

w_mdi_frame.sle_msg.text =""

SetNull(snull)

IF this.GetColumnName() = 'deptcode' THEN
	ls_deptcode = this.GetText()
	
	IF ls_deptCode = "" OR IsNull(ls_deptCode) THEN
		p_inq.TriggerEvent(Clicked!)
		return
	END IF
	
	//부서코드 검사
	SELECT "P0_DEPT"."DEPTCODE",
			 "P0_DEPT"."DEPTNAME"
		 INTO :ls_dept, :ls_deptname
		 FROM "P0_DEPT"
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND
				( "P0_DEPT"."DEPTCODE" = :ls_deptcode )   ;
	if sqlca.sqlcode <> 0 then
		messagebox("확인","부서코드를 확인하십시오!")
		this.SetItem(1,"deptcode",snull)
		this.setcolumn("deptcode")
		return 1
	end if
	
	this.SetItem(1,"deptname",ls_deptname)
END IF

p_inq.TriggerEvent(Clicked!)
end event

event itemerror;Return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.GetColumnName() = "deptcode" THEN

	Open(w_dept_popup)

	IF IsNull(Gs_code) THEN RETURN

	this.SetItem(this.GetRow(),"deptcode",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF

end event

type rr_1 from roundrectangle within w_pip1004
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 480
integer y = 256
integer width = 3593
integer height = 1980
integer cornerheight = 40
integer cornerwidth = 55
end type

