$PBExportHeader$w_kglb02.srw
$PBExportComments$전표 인쇄
forward
global type w_kglb02 from w_standard_print
end type
type st_2 from statictext within w_kglb02
end type
type tab_junpoy from tab within w_kglb02
end type
type tabpage_lst from userobject within tab_junpoy
end type
type dw_lst from u_d_select_sort within tabpage_lst
end type
type rr_1 from roundrectangle within tabpage_lst
end type
type tabpage_lst from userobject within tab_junpoy
dw_lst dw_lst
rr_1 rr_1
end type
type tabpage_print from userobject within tab_junpoy
end type
type dw_jpy_print from datawindow within tabpage_print
end type
type rr_2 from roundrectangle within tabpage_print
end type
type tabpage_print from userobject within tab_junpoy
dw_jpy_print dw_jpy_print
rr_2 rr_2
end type
type tabpage_lst_print from userobject within tab_junpoy
end type
type dw_lst_print from datawindow within tabpage_lst_print
end type
type rr_3 from roundrectangle within tabpage_lst_print
end type
type tabpage_lst_print from userobject within tab_junpoy
dw_lst_print dw_lst_print
rr_3 rr_3
end type
type tab_junpoy from tab within w_kglb02
tabpage_lst tabpage_lst
tabpage_print tabpage_print
tabpage_lst_print tabpage_lst_print
end type
end forward

global type w_kglb02 from w_standard_print
integer x = 0
integer y = 0
string title = "전표 조회 출력"
st_2 st_2
tab_junpoy tab_junpoy
end type
global w_kglb02 w_kglb02

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_preview (integer irow)
public function integer wf_print ()
end prototypes

public function integer wf_retrieve ();
Long ll_junnof,ll_junnot,k,ll_junno  
String ls_baldate1,ls_baldate2,ssaupj,sdate,sdescr,s_upmu,sSawon,sJunGbn,sDept
Double ldb_amt

w_mdi_frame.sle_msg.text =""

dw_ip.AcceptText()

ls_baldate1 = dw_ip.GetItemString(dw_ip.GetRow(),"symd")
ls_baldate2 = dw_ip.GetItemString(dw_ip.GetRow(),"eymd")

ll_junnof = dw_ip.GetItemNumber(dw_ip.GetRow(),"sno")
IF ll_junnof =0 THEN
	ll_junnof =1
END IF

ll_junnot = dw_ip.GetItemNumber(dw_ip.GetRow(),"eno")
IF ll_junnot =0 THEN
	ll_junnot =9999
END IF

s_upmu = Trim(dw_ip.GetItemString(1,'jungu'))
IF s_upmu = "" OR IsNull(s_upmu) THEN
	s_upmu = '%'
END IF

sSawon = dw_ip.GetItemString(1,"sawon")
IF sSawon = "" OR IsNull(sSawon) THEN sSawon = '%'
	
sJunGbn = dw_ip.GetItemString(1,"jungubun")									/*전표 종류*/

sDept  = dw_ip.GetItemString(1,"dept")
IF sDept = "" OR IsNull(sDept) THEN sDept = '%'	

tab_junpoy.tabpage_lst.dw_lst.Reset()
tab_junpoy.tabpage_lst.dw_lst.SetRedraw(False)

IF tab_junpoy.tabpage_lst.dw_lst.Retrieve(sabu_f,sabu_t,ls_baldate1,ls_baldate2,ll_junnof,ll_junnot,s_upmu,sSawon,sJunGbn,sDept) <=0 THEN
	F_MessageChk(14,'')
   tab_junpoy.tabpage_lst.dw_lst.SetRedraw(True)
	Return -1
ELSE
	tab_junpoy.tabpage_lst_print.dw_lst_print.Retrieve(sabu_f,sabu_t,ls_baldate1,ls_baldate2,ll_junnof,ll_junnot,s_upmu,sSawon,sJunGbn,sDept)	
	tab_junpoy.tabpage_lst_print.dw_lst_print.object.datawindow.print.preview = "yes"	
END IF
tab_junpoy.tabpage_lst.dw_lst.SetRedraw(True)

sle_msg.text ="자료를 조회하였습니다."

SetPointer(Arrow!)


Return 1



end function

public function integer wf_preview (integer irow);Long       lJunNo
String     sSaupj,sAccDate,sUpmuGbn,sDcGbn,sRptGbn,sAlcGbn,sSungGbn
DataWindow dw_Obj

tab_junpoy.tabpage_print.dw_jpy_print.Reset()

dw_ip.AcceptText()
sAlcGbn = dw_ip.GetItemString(1,"gubun")

IF sAlcGbn = '1' THEN
	sSungGbn = 'N'
ELSE
	sSungGbn = 'Y'
END IF

SetPointer (HourGlass!)
	
IF sAlcGbn = '2' THEN				/*승인전표*/
	sSaupj   = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iRow, "saupj"  )
	sAccDate = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iRow, "acc_date" )
  	sUpmuGbn = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iRow, "upmu_gu")
   lJunNo   = tab_junpoy.tabpage_lst.dw_lst.GetItemNumber(iRow, "jun_no" )
	
	sRptGbn = tab_junpoy.tabpage_lst.dw_lst.GetItemString(irow,"jungu")
ELSE
	sSaupj   = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iRow, "saupj"  )
	sAccDate = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iRow, "bal_date" )
  	sUpmuGbn = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iRow, "upmu_gu")
   lJunNo   = tab_junpoy.tabpage_lst.dw_lst.GetItemNumber(iRow, "bjun_no" )
	
	sRptGbn = tab_junpoy.tabpage_lst.dw_lst.GetItemString(irow,"jungu")
END IF

IF F_Call_JunpoyPrint(tab_junpoy.tabpage_print.dw_jpy_print,sSungGbn,sRptGbn,sSaupj,sAccDate,sUpmuGbn,lJunNo,'0','V') = -1 THEN
	F_MessageChk(14,'')
	Return -1
ELSE
	Integer iCount
	
	iCount = dw_ip.GetItemNumber(1,"empcnt")
	
	if iCount = 1 then
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl1.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl2.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl3.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		
	elseif iCount = 2 then
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl1.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl2.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl3.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	elseif iCount = 3 then
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl1.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl2.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl3.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl4.visible='0~t "+ "If( page() = 1, 1, 0 )'")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	elseif iCount = 4 then
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl1.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl2.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl3.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl4.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl5.visible='0~t "+ "If( page() = 1, 1, 0 )'")
	elseif iCount = 5 then
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl1.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl2.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl3.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl4.visible = 0")
		tab_junpoy.tabpage_print.dw_jpy_print.Modify("t_gl5.visible = 0")
	end if

END IF
	
Return 1

end function

public function integer wf_print ();Integer iSelectedRow,iRtnVal
Long    lJunNo
String  sSaupj,sAccDate,sUpmuGbn,sDcGbn,sAlcGbn,sPrintFlag = '0',sSungGbn,sRptGbn

dw_ip.AcceptText()
sAlcGbn = dw_ip.GetItemString(1,"gubun")

If tab_junpoy.tabpage_lst.dw_lst.GetSelectedRow(0) <= 0 then
	MessageBox("확 인", "출력할 전표를 선택하십시요")
	Return -1
End if

IF MessageBox("확 인", "출력하시겠습니까 ?", Question!, OkCancel!, 2) = 2 THEN RETURN -1

IF sAlcGbn = '1' THEN
	sSungGbn = 'N'
ELSE
	sSungGbn = 'Y'
END IF

SetPointer (HourGlass!)
DO WHILE true
	iSelectedRow = 	tab_junpoy.tabpage_lst.dw_lst.GetSelectedRow(0)
	If iSelectedRow = 0 then
		exit
	END IF
	
	IF sAlcGbn = '2' THEN				/*승인전표*/
		sSaupj   = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iSelectedRow, "saupj"  )
		sAccDate = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iSelectedRow, "acc_date" )
		sUpmuGbn = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iSelectedRow, "upmu_gu")
		lJunNo   = tab_junpoy.tabpage_lst.dw_lst.GetItemNumber(iSelectedRow, "jun_no" )
		
		sRptGbn = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iSelectedRow,"jungu")
	ELSE
		sSaupj   = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iSelectedRow, "saupj"  )
		sAccDate = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iSelectedRow, "bal_date" )
		sUpmuGbn = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iSelectedRow, "upmu_gu")
		lJunNo   = tab_junpoy.tabpage_lst.dw_lst.GetItemNumber(iSelectedRow, "bjun_no" )
		
		sRptGbn = tab_junpoy.tabpage_lst.dw_lst.GetItemString(iSelectedRow,"jungu")
	END IF
	
	iRtnVal = F_Call_JunpoyPrint(tab_junpoy.tabpage_print.dw_jpy_print,sSungGbn,sRptGbn,sSaupj,sAccDate,sUpmuGbn,lJunNo,sPrintFlag,'P')
	IF iRtnVal = -1 THEN
		F_MessageChk(14,'')
		Return -1
	ELSEIF iRtnVal = -2 THEN
		Return 1
	ELSE
		sPrintFlag = '1'
	END IF
		
	tab_junpoy.tabpage_lst.dw_lst.SelectRow(iSelectedRow,FALSE)
LOOP

Return 1

end function

on w_kglb02.create
int iCurrent
call super::create
this.st_2=create st_2
this.tab_junpoy=create tab_junpoy
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.tab_junpoy
end on

on w_kglb02.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.tab_junpoy)
end on

event open;call super::open;String sDeptCode

tab_junpoy.tabpage_lst.dw_lst.SetTransObject(SQLCA)
tab_junpoy.tabpage_print.dw_jpy_print.SetTransObject(SQLCA)
tab_junpoy.tabpage_lst_print.dw_lst_print.SetTransObject(SQLCA)

dw_ip.SetItem(dw_ip.Getrow(),"saupj",  gs_saupj)
dw_ip.SetItem(dw_ip.Getrow(),"symd",   Left(f_today(),6)+"01")
dw_ip.SetItem(dw_ip.GetRow(),"eymd",   f_today())

dw_ip.SetItem(dw_ip.GetRow(),"sno",1)
dw_ip.SetItem(dw_ip.GetRow(),"eno",9999)

IF F_Authority_Chk(Gs_Dept) = -1 THEN							/*권한 체크- 현업 여부*/

	dw_ip.SetItem(dw_ip.GetRow(),"dept",    Gs_Dept)
	dw_ip.SetItem(dw_ip.GetRow(),"deptname",F_Get_PersonLst('3',Gs_Dept,'1'))

	dw_ip.Modify("saupj.protect = 1")

	dw_ip.Modify("dept.protect = 1")
ELSE
	dw_ip.Modify("saupj.protect = 0")
	
	dw_ip.Modify("dept.protect = 0")
END IF

F_Setting_Dw_Junpoy('Y','1',tab_junpoy.tabpage_print.dw_jpy_print)

dw_ip.SetColumn("eymd")
dw_ip.SetFocus()

st_2.Visible = True



end event

type p_xls from w_standard_print`p_xls within w_kglb02
integer x = 3959
integer y = 184
end type

type p_sort from w_standard_print`p_sort within w_kglb02
end type

type p_preview from w_standard_print`p_preview within w_kglb02
boolean visible = false
integer x = 4146
integer y = 188
integer taborder = 0
end type

type p_exit from w_standard_print`p_exit within w_kglb02
integer x = 4434
integer taborder = 30
end type

type p_print from w_standard_print`p_print within w_kglb02
integer x = 4261
integer taborder = 20
end type

event p_print::clicked;
if tab_junpoy.SelectedTab = 1 then
	if Wf_Print() = -1 then Return
elseif tab_junpoy.SelectedTab = 2 then
	IF tab_junpoy.tabpage_print.dw_jpy_print.rowcount() > 0 then 
		gi_page = tab_junpoy.tabpage_print.dw_jpy_print.GetItemNumber(1,"last_page")
	ELSE
		gi_page = 1
	END IF
	OpenWithParm(w_print_options, tab_junpoy.tabpage_print.dw_jpy_print)
elseif tab_junpoy.SelectedTab = 3 then
	IF tab_junpoy.tabpage_lst_print.dw_lst_print.rowcount() > 0 then 
		gi_page = tab_junpoy.tabpage_lst_print.dw_lst_print.GetItemNumber(1,"last_page")
	ELSE
		gi_page = 1
	END IF
	OpenWithParm(w_print_options, tab_junpoy.tabpage_lst_print.dw_lst_print)
end if


end event

type p_retrieve from w_standard_print`p_retrieve within w_kglb02
integer x = 4087
integer taborder = 10
end type







type st_10 from w_standard_print`st_10 within w_kglb02
end type



type dw_print from w_standard_print`dw_print within w_kglb02
integer x = 3973
integer y = 136
string dataobject = "dw_kglb0221"
end type

type dw_ip from w_standard_print`dw_ip within w_kglb02
integer x = 37
integer width = 4005
integer height = 292
integer taborder = 0
string dataobject = "dw_kglb021"
end type

event dw_ip::itemchanged;String snull,sEmpNo,sEmpName,sRptGbn,sAlcGbn,sDept,sDeptname

SetNull(snull)

IF this.GetColumnName() = "dept" THEN
	sDept = this.GetText()
	IF sDept = "" OR IsNull(sDept) THEN
		this.SetItem(1,"deptname",snull)
		Return
	END IF
	
	sDeptName = F_Get_PersonLst('3',sDept,'1')
	IF IsNull(sDeptName) THEN
//		F_MessageChk(20,'[작성부서]')
//		this.SetItem(1,"dept",snull)
//		this.SetItem(1,"deptname",snull)
//		Return 1
	ELSE
		this.SetItem(1,"deptname",sDeptName)
	END IF
END IF

IF dwo.name ="symd" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
	
	IF f_datechk(data) = -1 THEN
		f_messagechk(20,"작성일자")
		dw_ip.SetItem(1,"symd",snull)
		dw_ip.SetColumn("symd")
		Return 1
	END IF
END IF

IF dwo.name ="eymd" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
	
	IF f_datechk(data) = -1 THEN
		f_messagechk(20,"작성일자")
		dw_ip.SetItem(1,"eymd",snull)
		dw_ip.SetColumn("eymd")
		Return 1
	END IF
END IF

IF dwo.name ="jungu" THEN
	IF data ="" OR IsNull(data) THEN Return
	
	IF IsNull(f_Get_Refferance('AG',data)) THEN
		f_messagechk(20,"전표구분")
		dw_ip.SetItem(1,"jungu",snull)
		dw_ip.SetColumn("jungu")
		Return 1
	END IF
END IF

IF this.GetColumnName() = "sawon" THEN
	sEmpNo = this.GetText()
	IF sEmpNo = "" OR IsNull(sEmpNo) THEN
		this.SetItem(1,"sawonname",snull)
		Return
	END IF
	
	sEmpName = F_Get_PersonLst('4',sEmpNo,'1')
	IF IsNull(sEmpName) THEN
//		F_MessageChk(20,'[작성자]')
//		this.SetItem(1,"sawon",snull)
//		this.SetItem(1,"sawonname",snull)
//		Return 1
	ELSE
		this.SetItem(1,"sawonname",sEmpName)
	END IF
END IF

IF dwo.name ="gubun" THEN
	
	tab_junpoy.tabpage_lst.dw_lst.SetRedraw(False)
	IF data ='1' THEN													//미승인전표
		tab_junpoy.tabpage_lst.dw_lst.DataObject ="dw_kglb023"
		dw_ip.Modify("txt_junpoy_t.text = 전표발의번호")
		tab_junpoy.tabpage_lst.Text ="미승인 전표"
		
		F_Setting_Dw_Junpoy('N','1',tab_junpoy.tabpage_print.dw_jpy_print)
		tab_junpoy.tabpage_lst_print.dw_lst_print.DataObject ="dw_kglb0231"		
	ELSE
		tab_junpoy.tabpage_lst.dw_lst.DataObject ="dw_kglb022"
		dw_ip.Modify("txt_junpoy_t.text = 전표승인번호")		
		tab_junpoy.tabpage_lst.Text ="승인 전표"
		
		F_Setting_Dw_Junpoy('Y','1',tab_junpoy.tabpage_print.dw_jpy_print)
		tab_junpoy.tabpage_lst_print.dw_lst_print.DataObject ="dw_kglb0221"		
	END IF
	tab_junpoy.tabpage_lst.dw_lst.SetRedraw(False)
	tab_junpoy.tabpage_lst.dw_lst.Reset()
	tab_junpoy.tabpage_lst.dw_lst.SetTransObject(SQLCA)
	
	tab_junpoy.tabpage_lst_print.dw_lst_print.SetTransObject(SQLCA)
	tab_junpoy.tabpage_lst_print.dw_lst_print.Reset()
END IF

IF this.GetColumnName() = "bef_sawon" THEN
	sEmpNo = this.GetText()
	IF sEmpNo = "" OR IsNull(sEmpNo) THEN
		this.SetItem(1,"bef_sawon_name",snull)
		Return
	END IF
	
	sEmpName = F_Get_PersonLst('4',sEmpNo,'1')
	IF IsNull(sEmpName) THEN
//		F_MessageChk(20,'[작성자]')
//		this.SetItem(1,"sawon",snull)
//		this.SetItem(1,"sawonname",snull)
//		Return 1
	ELSE
		this.SetItem(1,"bef_sawon_name",sEmpName)
	END IF
END IF


end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::rbuttondown;
SetNull(lstr_custom.code)
SetNull(lstr_custom.name)

this.accepttext()

IF this.GetColumnName() ="sawon" THEN
	
	lstr_custom.code = this.getitemstring(this.getrow(), "sawon")
	
	OpenWithParm(W_KFZ04OM0_POPUP,'4')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"sawon",    lstr_custom.code)
	this.SetItem(this.GetRow(),"sawonname",lstr_custom.name)
	
END IF

IF this.GetColumnName() ="dept" THEN
	
	lstr_custom.code = this.getitemstring(this.getrow(), "dept")
	
	OpenWithParm(W_KFZ04OM0_POPUP,'3')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"dept",    lstr_custom.code)
	this.SetItem(this.GetRow(),"deptname",lstr_custom.name)
	
END IF

IF this.GetColumnName() ="bef_sawon" THEN
	
	OpenWithParm(W_KFZ04OM0_POPUP,'4')
	
	IF lstr_custom.code = "" OR IsNull(lstr_custom.code) THEN Return
	
	this.SetItem(this.GetRow(),"bef_sawon",    lstr_custom.code)
	this.SetItem(this.GetRow(),"bef_sawon_name",lstr_custom.name)
	
END IF

end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kglb02
boolean visible = false
integer x = 1861
integer y = 2680
integer width = 1024
integer height = 112
integer taborder = 0
string title = "전표 인쇄"
string dataobject = "dw_kglb0221"
boolean hscrollbar = false
boolean vscrollbar = false
boolean resizable = true
boolean hsplitscroll = false
end type

type st_2 from statictext within w_kglb02
integer x = 1495
integer y = 344
integer width = 1394
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "<선택한 자료 상세 조회는 더블클릭으로 한다.>"
alignment alignment = center!
boolean focusrectangle = false
end type

type tab_junpoy from tab within w_kglb02
event create ( )
event destroy ( )
integer x = 46
integer y = 316
integer width = 4553
integer height = 1948
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_lst tabpage_lst
tabpage_print tabpage_print
tabpage_lst_print tabpage_lst_print
end type

on tab_junpoy.create
this.tabpage_lst=create tabpage_lst
this.tabpage_print=create tabpage_print
this.tabpage_lst_print=create tabpage_lst_print
this.Control[]={this.tabpage_lst,&
this.tabpage_print,&
this.tabpage_lst_print}
end on

on tab_junpoy.destroy
destroy(this.tabpage_lst)
destroy(this.tabpage_print)
destroy(this.tabpage_lst_print)
end on

event selectionchanging;
//IF oldindex = 1 AND newindex = 2 THEN
IF newindex = 2 THEN
	IF tab_junpoy.tabpage_lst.dw_lst.GetSelectedRow(0) <=0 THEN Return 1
	
	IF Wf_Preview(tab_junpoy.tabpage_lst.dw_lst.GetSelectedRow(0)) <= 0 THEN Return 1
END IF

IF newindex = 2 THEN
	st_2.visible = False
	if tab_junpoy.tabpage_print.dw_jpy_print.RowCount() <=0 then return 1
ELSEIF newindex = 1 THEN
	st_2.visible = True
ELSE
	st_2.visible = False
END IF
end event

type tabpage_lst from userobject within tab_junpoy
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4517
integer height = 1836
long backcolor = 32106727
string text = "승인전표"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_lst dw_lst
rr_1 rr_1
end type

on tabpage_lst.create
this.dw_lst=create dw_lst
this.rr_1=create rr_1
this.Control[]={this.dw_lst,&
this.rr_1}
end on

on tabpage_lst.destroy
destroy(this.dw_lst)
destroy(this.rr_1)
end on

type dw_lst from u_d_select_sort within tabpage_lst
integer x = 27
integer y = 28
integer width = 4462
integer height = 1784
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kglb022"
boolean hscrollbar = false
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
	
END IF

CALL SUPER ::CLICKED
end event

event rbuttondown;call super::rbuttondown;IF Row <=0 THEN Return

SelectRow(Row,False)
end event

event doubleclicked;call super::doubleclicked;If Row <= 0 then
   return
END IF

IF dw_ip.GetItemString(1,'gubun') = '1' THEN
	lstr_jpra.saupjang   = This.GetItemString(Row, "saupj")
	lstr_jpra.dept       = This.GetItemString(Row, "dept_cd")
	lstr_jpra.baldate   = This.GetItemString(Row, "bal_date")
	lstr_jpra.upmugu  = This.GetItemString(Row, "upmu_gu")
	lstr_jpra.bjunno  = This.GetItemNumber(Row, "bjun_no")

   Open(w_kglc01a)
ELSE
	lstr_jpra.saupjang   = This.GetItemString(Row, "saupj")
	lstr_jpra.dept       = This.GetItemString(Row, "dept_cd")
	lstr_jpra.baldate   = This.GetItemString(Row, "acc_date")
	lstr_jpra.upmugu  = This.GetItemString(Row, "upmu_gu")
	lstr_jpra.bjunno  = This.GetItemNumber(Row, "jun_no")

   Open(w_kglc02a)
END IF
end event

type rr_1 from roundrectangle within tabpage_lst
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 20
integer width = 4485
integer height = 1804
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_print from userobject within tab_junpoy
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4517
integer height = 1836
long backcolor = 32106727
string text = "전표 미리보기"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_jpy_print dw_jpy_print
rr_2 rr_2
end type

on tabpage_print.create
this.dw_jpy_print=create dw_jpy_print
this.rr_2=create rr_2
this.Control[]={this.dw_jpy_print,&
this.rr_2}
end on

on tabpage_print.destroy
destroy(this.dw_jpy_print)
destroy(this.rr_2)
end on

type dw_jpy_print from datawindow within tabpage_print
integer x = 27
integer y = 32
integer width = 4457
integer height = 1772
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kglc045"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_2 from roundrectangle within tabpage_print
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 20
integer width = 4485
integer height = 1800
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_lst_print from userobject within tab_junpoy
integer x = 18
integer y = 96
integer width = 4517
integer height = 1836
long backcolor = 32106727
string text = "조회 내역 미리보기"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_lst_print dw_lst_print
rr_3 rr_3
end type

on tabpage_lst_print.create
this.dw_lst_print=create dw_lst_print
this.rr_3=create rr_3
this.Control[]={this.dw_lst_print,&
this.rr_3}
end on

on tabpage_lst_print.destroy
destroy(this.dw_lst_print)
destroy(this.rr_3)
end on

type dw_lst_print from datawindow within tabpage_lst_print
integer x = 23
integer y = 32
integer width = 4466
integer height = 1780
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kglb0221"
boolean vscrollbar = true
boolean border = false
end type

type rr_3 from roundrectangle within tabpage_lst_print
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 20
integer width = 4485
integer height = 1808
integer cornerheight = 40
integer cornerwidth = 55
end type

