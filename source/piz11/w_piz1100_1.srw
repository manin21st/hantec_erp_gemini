$PBExportHeader$w_piz1100_1.srw
$PBExportComments$인원현황 조회기본 화면
forward
global type w_piz1100_1 from w_standard_print
end type
type p_1 from picture within w_piz1100_1
end type
type cbx_all from checkbox within w_piz1100_1
end type
type p_2 from uo_picture within w_piz1100_1
end type
type rr_2 from roundrectangle within w_piz1100_1
end type
type rr_3 from roundrectangle within w_piz1100_1
end type
end forward

global type w_piz1100_1 from w_standard_print
integer width = 3474
integer height = 2300
p_1 p_1
cbx_all cbx_all
p_2 p_2
rr_2 rr_2
rr_3 rr_3
end type
global w_piz1100_1 w_piz1100_1

type variables
string      is_objname

long        il_prevrow
end variables

forward prototypes
public subroutine wf_title_set ()
public function integer wf_retrieve ()
end prototypes

public subroutine wf_title_set ();
choose case is_objname

	case "dq_piz1100_11"
		this.title = "부서별 직위별 인원현황"
//		cbx_all.visible = true
//		cbx_all.checked = true
	case "dq_piz1100_12"
		this.title = "부서별 직급별 인원현황"
	case "dq_piz1100_13"
		this.title = "부서별 직책별 인원현황"
	case "dq_piz1100_14"
		this.title = "부서별 연령별 인원현황"
	case "dq_piz1100_15"
		this.title = "부서별 학력별 인원현황"
	   dw_ip.Modify("s_date.TabSequence = 0")
	case "dq_piz1100_16"
		this.title = "부서별 근속년수 인원현황"
	case "dq_piz1100_21"
		this.title = "직급별 학력별 인원현황"
	   dw_ip.Modify("s_date.TabSequence = 0")
	case "dq_piz1100_22"
		this.title = "직급별 연령별 인원현황"
	case "dq_piz1100_23"
		this.title = "직급별 근속년수 인원현황"
	case "dq_piz1100_24"
		this.title = "직급별 출신지별 인원현황"
	   dw_ip.Modify("s_date.TabSequence = 0")
	case "dq_piz1100_25"
		this.title = "직급별 학교별 인원현황"
	   dw_ip.Modify("s_date.TabSequence = 0")
	case "dq_piz1100_26"
		this.title = "직급별 자격증별 인원현황"
	   dw_ip.Modify("s_date.TabSequence = 0")
	case "dq_piz1100_31"
		this.title = "직책별 학력별 인원현황"
	case "dq_piz1100_32"
		this.title = "직책별 연령별 인원현황"
	case "dq_piz1100_33"
		this.title = "직책별 근속년수 인원현황"
	case "dq_piz1100_34"
		this.title = "부서별 직종별 인원현황"
		//cbx_all.visible = true
		//cbx_all.checked = true
	case "dq_piz1100_41"
		this.title = "부문별 직위별 인원현황"
	case "dq_piz1100_42"
		this.title = "부문별 직급별 인원현황"
	case "dq_piz1100_43"
		this.title = "부문별 직책별 인원현황"
//	case "dq_piz1100_44"
//		this.title = "본사/현장  인원현황"
//	case else
end choose

end subroutine

public function integer wf_retrieve ();string ls_date, ls_saup, ls_kunmu

dw_ip.accepttext()

ls_date = dw_ip.getitemstring(1, "s_date")
ls_saup = trim(dw_ip.getitemstring(1, "saup"))
ls_kunmu = trim(dw_ip.getitemstring(1, "kunmu"))

IF f_datechk(ls_date) = -1 THEN
   MessageBox("확 인","기준일자를 확인하세요!!")
   dw_ip.SetFocus( )
	dw_ip.SetColumn(1) 
	Return -1
END IF

IF IsNull(ls_saup) OR ls_saup = '' THEN ls_saup = '%'
IF IsNull(ls_kunmu) OR ls_kunmu = '' THEN ls_kunmu = '%'

dw_list.SetRedraw(False)		

CHOOSE CASE is_objname

	case "dq_piz1100_34"
		//cbx_all.visible = true
		//cbx_all.checked = true
		IF dw_list.Retrieve(gs_company,ls_date,ls_saup,ls_kunmu) <= 0 then
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      sle_msg.text =""
         dw_list.SetRedraw(True)
         return -1
      ELSE
	      sle_msg.text ="조 회"
      END IF
	case "dq_piz1100_15", "dq_piz1100_21", "dq_piz1100_24", "dq_piz1100_25", "dq_piz1100_26"
		IF dw_list.Retrieve(gs_company,gs_today,ls_saup,ls_kunmu) <= 0 THEN
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      sle_msg.text =""
         dw_list.SetRedraw(True)
         return -1
      ELSE
	      sle_msg.text ="조 회"
      END IF
	case else
		IF dw_list.Retrieve(gs_company,ls_date,ls_saup,ls_kunmu) <= 0 THEN
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      sle_msg.text =""
         dw_list.SetRedraw(True)
         return -1
      ELSE
	      sle_msg.text ="조 회"
      END IF
END CHOOSE

dw_list.SetRedraw(True)

return 1
end function

on w_piz1100_1.create
int iCurrent
call super::create
this.p_1=create p_1
this.cbx_all=create cbx_all
this.p_2=create p_2
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.cbx_all
this.Control[iCurrent+3]=this.p_2
this.Control[iCurrent+4]=this.rr_2
this.Control[iCurrent+5]=this.rr_3
end on

on w_piz1100_1.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
destroy(this.cbx_all)
destroy(this.p_2)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;f_window_center_response(this)
is_objname = message.stringparm

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.setitem( 1, "s_date", gs_today)
f_set_saupcd(dw_ip,'saup','1')
is_saupcd = gs_saupcd

dw_list.SetRedraw(False)
	
dw_list.dataObject = is_objname

//IF is_objname = "dq_piz1100_11","dq_piz1100_12" THEN
//   dw_list.title = "부서별 인원 조회 : DOUBLE CLICK"
//ELSEIF is_objname = "dq_piz1100_21" THEN
//   dw_list.title = "직급별 인원 조회 : DOUBLE CLICK"
//END IF

CHOOSE CASE is_objname
CASE "dq_piz1100_11","dq_piz1100_12","dq_piz1100_13","dq_piz1100_14","dq_piz1100_15","dq_piz1100_34","dq_piz1100_16"
      dw_list.title = "부서별 인원 조회 : DOUBLE CLICK" 
CASE "dq_piz1100_21","dq_piz1100_22","dq_piz1100_23","dq_piz1100_24","dq_piz1100_25","dq_piz1100_26"
	   dw_list.title = "직급별 인원 조회 : DOUBLE CLICK"
CASE "dq_piz1100_41","dq_piz1100_42","dq_piz1100_43"
      dw_list.title = "부문별 인원 조회 : DOUBLE CLICK" 
CASE "dq_piz1100_31","dq_piz1100_32","dq_piz1100_33"
	   dw_list.title = "직책별 인원 조회 : DOUBLE CLICK" 
END CHOOSE



dw_list.SetRedraw(True)

wf_title_set()

dw_list.SetTransObject(SQLCA)


end event

type p_xls from w_standard_print`p_xls within w_piz1100_1
boolean visible = true
integer x = 2491
integer y = 20
end type

event p_xls::clicked;//

If dw_list.RowCount() < 1 Then Return

If this.Enabled Then wf_excel_down(dw_list)
end event

type p_sort from w_standard_print`p_sort within w_piz1100_1
integer x = 2766
integer y = 288
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_piz1100_1
integer x = 2670
integer y = 20
boolean enabled = true
end type

event p_preview::clicked;//

OpenWithParm(w_print_preview, dw_list)	

end event

type p_exit from w_standard_print`p_exit within w_piz1100_1
integer x = 3246
integer y = 20
end type

type p_print from w_standard_print`p_print within w_piz1100_1
boolean visible = false
integer x = 4142
integer y = 592
end type

type p_retrieve from w_standard_print`p_retrieve within w_piz1100_1
integer x = 3072
integer y = 20
end type







type st_10 from w_standard_print`st_10 within w_piz1100_1
end type



type dw_print from w_standard_print`dw_print within w_piz1100_1
integer x = 4343
integer y = 600
string dataobject = "dq_piz1100_43"
end type

type dw_ip from w_standard_print`dw_ip within w_piz1100_1
integer x = 69
integer y = 64
integer width = 2368
integer height = 96
string dataobject = "d_piz1100_1"
end type

event dw_ip::itemchanged;call super::itemchanged;this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

end event

type dw_list from w_standard_print`dw_list within w_piz1100_1
integer x = 32
integer y = 236
integer width = 3365
integer height = 1928
integer taborder = 20
string title = "부서별 인원 조회 : DOUBLE CLICK"
string dataobject = "dq_piz1100_41"
boolean border = false
end type

event dw_list::clicked;call super::clicked;

if row <= 0 Then return

this.SelectRow(0,False)
this.SelectRow(row ,True)


if dw_LIST.rowcount() <= 0 then return

//cbx_all.checked = false
end event

event dw_list::doubleclicked;long ll_row
string ls_date
st_codnm dept

if dw_list.rowcount() <= 0 then return
ll_row = dw_list.getrow()

dw_ip.accepttext()

ls_date = dw_ip.getitemstring(1, "s_date")

Choose Case is_objname
	Case "dq_piz1100_11","dq_piz1100_12", "dq_piz1100_13","dq_piz1100_14","dq_piz1100_15","dq_piz1100_16","dq_piz1100_34"
   If row < 1 Then Return
   dept.code = getitemstring(row,'deptcode')
	SELECT "P0_DEPT"."DEPTNAME"  
    INTO :dept.name  
    FROM "P0_DEPT"  
   WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
         ( "P0_DEPT"."DEPTCODE" = :dept.code )   ;
      dept.dd = ls_date
      dept.height = parent.y
		dept.width = parent.workspacewidth()
		openwithparm(w_piz1101, dept)
 Case "dq_piz1100_21","dq_piz1100_22","dq_piz1100_23","dq_piz1100_24","dq_piz1100_25","dq_piz1100_26"
	If row < 1 Then Return
   dept.code = getitemstring(row,'levelcode')
	SELECT "P0_LEVEL"."LEVELNAME"  
    INTO :dept.name  
    FROM "P0_LEVEL"  
   WHERE ( "P0_LEVEL"."LEVELCODE" = :dept.code )   ;
      dept.dd = ls_date
      dept.height = parent.y
		dept.width = parent.workspacewidth()
		openwithparm(w_piz1102, dept)

 Case "dq_piz1100_31","dq_piz1100_32","dq_piz1100_33"
	   If row < 1 Then Return
   	dept.code = getitemstring(row,'jobkindcode')
      dept.name = getitemstring(row,'jobkindname') 
      dept.dd = ls_date
      dept.height = parent.y
		dept.width = parent.workspacewidth()
		openwithparm(w_piz1103, dept)
		
		
 Case	"dq_piz1100_41","dq_piz1100_42","dq_piz1100_43"  /*부문별*/
	   If row < 1 Then Return
      dept.code = getitemstring(row,'deptpart')
      dept.name = getitemstring(row,'dptpartname') 
      dept.dd = ls_date
      dept.height = parent.y
		dept.width = parent.workspacewidth()
		openwithparm(w_piz1106, dept)
End Choose



end event

type p_1 from picture within w_piz1100_1
boolean visible = false
integer x = 1326
integer y = 2400
integer width = 146
integer height = 136
boolean bringtotop = true
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\GRAPH.BMP"
boolean focusrectangle = false
end type

event clicked;//
//Long	ll_row
//
//st_graph_p  parm
//
//dw_ip.accepttext()
//
//ll_row = dw_list.GetSelectedRow(0)
//
//If ll_row < 1 and cbx_all.checked = false Then 
//	messagebox("확 인", "자료를 선택하십시요.!!")
//	Return
//End if
//
//Choose Case is_objname
//	Case "dq_piz1100_11"
//		if cbx_all.checked = true then		
//			parm.graph_kind = "dg_piz1100_11_all"
//			parm.workdate = dw_ip.getitemstring(1, "s_date")
//		else
//			parm.graph_kind = "dg_piz1100_11"
//			parm.workdate = dw_ip.getitemstring(1, "s_date")
//		   parm.deptcode = dw_list.getitemstring(ll_row, "deptcode")
//		end if
//	Case "dq_piz1100_12" 
//		parm.graph_kind = "dg_piz1100_12"
//		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		parm.deptcode = dw_list.getitemstring(ll_row, "deptcode")
//	Case "dq_piz1100_13" 
//		parm.graph_kind = "dg_piz1100_13"
//		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		parm.deptcode = dw_list.getitemstring(ll_row, "deptcode")
//	Case "dq_piz1100_14" 
//		parm.graph_kind = "dg_piz1100_14"
//		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		parm.deptcode = dw_list.getitemstring(ll_row, "deptcode")
//	Case "dq_piz1100_15" 
//		parm.graph_kind = "dg_piz1100_15"
//		parm.deptcode = dw_list.getitemstring(ll_row, "deptcode")
//		parm.workdate = gs_today
//	Case "dq_piz1100_16" 
//		parm.graph_kind = "dg_piz1100_16"
//		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		parm.deptcode = dw_list.getitemstring(ll_row, "deptcode")
//	Case "dq_piz1100_21" 
//		parm.graph_kind = "dg_piz1100_21"
//		parm.levelcode = dw_list.getitemstring(ll_row, "levelcode")
//	Case "dq_piz1100_22" 
//		parm.graph_kind = "dg_piz1100_22"
//		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		parm.levelcode = dw_list.getitemstring(ll_row, "levelcode")
//	Case "dq_piz1100_23" 
//		parm.graph_kind = "dg_piz1100_23"
//		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		parm.levelcode = dw_list.getitemstring(ll_row, "levelcode")
//	Case "dq_piz1100_24" 
//		parm.graph_kind = "dg_piz1100_24"
//		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		parm.levelcode = dw_list.getitemstring(ll_row, "levelcode")
//	Case "dq_piz1100_25" 
//		parm.graph_kind = "dg_piz1100_25"
//		parm.levelcode = dw_list.getitemstring(ll_row, "levelcode")
//	Case "dq_piz1100_26" 
//		parm.graph_kind = "dg_piz1100_26"
//		parm.levelcode = dw_list.getitemstring(ll_row, "levelcode")
//	Case "dq_piz1100_31" 
//		parm.graph_kind = "dg_piz1100_31"
//		parm.jobkindcode = dw_list.getitemstring(ll_row, "jobkindcode")
//	Case "dq_piz1100_32" 
//		parm.graph_kind = "dg_piz1100_32"
//		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		parm.jobkindcode = dw_list.getitemstring(ll_row, "jobkindcode")
//	Case "dq_piz1100_33" 
//		parm.graph_kind = "dg_piz1100_33"
//		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		parm.jobkindcode = dw_list.getitemstring(ll_row, "jobkindcode")
//	Case "dq_piz1100_34"
//		if cbx_all.checked = true then		
//			parm.graph_kind = "dg_piz1100_34_all"
//			parm.workdate = dw_ip.getitemstring(1, "s_date")
//		else
//			parm.graph_kind = "dg_piz1100_34"
//			parm.workdate = dw_ip.getitemstring(1, "s_date")
//		   parm.deptcode = dw_list.getitemstring(ll_row, "deptcode")
//		end if
//	Case "dq_piz1100_41"
//		parm.graph_kind = "dg_piz1100_41"
//		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		parm.deptkindcode = dw_list.getitemstring(ll_row, "deptpart")
//	Case "dq_piz1100_42" 
//		parm.graph_kind = "dg_piz1100_42"
//		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		parm.deptkindcode = dw_list.getitemstring(ll_row, "deptpart")
//	Case "dq_piz1100_43" 
//		parm.graph_kind = "dg_piz1100_43"
//		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		parm.deptkindcode = dw_list.getitemstring(ll_row, "deptpart")
////	Case "dq_piz1100_44" 
////		parm.graph_kind = "dg_piz1100_44"
////		parm.workdate = dw_ip.getitemstring(1, "s_date")
//		
//End Choose
//
//OpenWithParm(w_piz1100_2, parm)
//
end event

type cbx_all from checkbox within w_piz1100_1
boolean visible = false
integer x = 2729
integer y = 140
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "전   체"
end type

type p_2 from uo_picture within w_piz1100_1
boolean visible = false
integer x = 2583
integer y = 288
integer width = 178
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\excel_up.gif"
end type

event clicked;call super::clicked;integer fh, ret

blob Emp_pic
string txtname 
string dw_lists
string defext = "xls"
string Filter = "Excel Files (*.xls), *.xls, Excel with headers (*.xls), *.xls"

ret = GetFileSaveName("Save Excel", txtname, dw_lists, defext, filter)

dw_list.SaveAsAscii(txtname)

end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'C:\erpman\image\excel_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'C:\erpman\image\excel_up.gif'
end event

type rr_2 from roundrectangle within w_piz1100_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 32
integer width = 2450
integer height = 156
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_piz1100_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 220
integer width = 3392
integer height = 1952
integer cornerheight = 40
integer cornerwidth = 55
end type

