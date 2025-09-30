$PBExportHeader$w_piz1100_2.srw
$PBExportComments$인원현황 조회 화면(Graph)
forward
global type w_piz1100_2 from w_inherite_standard
end type
type dw_graph from datawindow within w_piz1100_2
end type
type st_popup from statictext within w_piz1100_2
end type
type dw_pipe_err from datawindow within w_piz1100_2
end type
type dw_arg_deptkind from datawindow within w_piz1100_2
end type
type dw_arg_jobkind from datawindow within w_piz1100_2
end type
type dw_arg_level from datawindow within w_piz1100_2
end type
type dw_arg_dept from datawindow within w_piz1100_2
end type
type rr_3 from roundrectangle within w_piz1100_2
end type
type rr_2 from roundrectangle within w_piz1100_2
end type
type dw_arg_workdate from u_key_enter within w_piz1100_2
end type
type cb_print from commandbutton within w_piz1100_2
end type
end forward

global type w_piz1100_2 from w_inherite_standard
integer x = 82
integer y = 60
integer width = 3515
integer height = 2076
string title = "그래프"
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_graph pbm_custom01
event ue_open pbm_custom02
dw_graph dw_graph
st_popup st_popup
dw_pipe_err dw_pipe_err
dw_arg_deptkind dw_arg_deptkind
dw_arg_jobkind dw_arg_jobkind
dw_arg_level dw_arg_level
dw_arg_dept dw_arg_dept
rr_3 rr_3
rr_2 rr_2
dw_arg_workdate dw_arg_workdate
cb_print cb_print
end type
global w_piz1100_2 w_piz1100_2

type variables
String     iv_graph_kind
String     iv_workdate
String     iv_deptcode,     iv_deptkindcode
String     iv_levelcode,     iv_jobkindcode
String     iv_business,       iv_jobkindtag


end variables

event ue_graph;long  ll_RowCounts
string arg_date, ls_date, ls_dept, ls_level, ls_jobkind, ls_deptkind

dw_arg_workdate.accepttext()

ls_date     = dw_arg_workdate.GetItemString(1, 1)
ls_dept     = dw_arg_dept.GetItemString(1, 1)
ls_level    = dw_arg_level.GetItemString(1, 1)
ls_jobkind  = dw_arg_jobkind.GetItemString(1, 1)
ls_deptkind = dw_arg_deptkind.GetItemString(1, 1)

Choose Case iv_graph_kind
	Case "dg_piz1100_11", "dg_piz1100_12", "dg_piz1100_13", "dg_piz1100_14", "dg_piz1100_16", "dg_piz1100_34"
      IF dw_graph.Retrieve(gs_company,ls_date, ls_dept)	< 1 THEN
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      cb_print.Enabled =False
	      Return 
      ELSE
	      cb_print.Enabled =True
      END IF
   Case "dg_piz1100_15"
      IF dw_graph.Retrieve(gs_company,ls_dept, gs_today)	< 1 THEN
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      cb_print.Enabled =False
	      Return
      ELSE
	      cb_print.Enabled =True
      END IF
	Case "dg_piz1100_34_all"
      IF dw_graph.Retrieve(gs_company,ls_date)	< 1 THEN
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      cb_print.Enabled =False
	      Return
      ELSE
	      cb_print.Enabled =True
      END IF
	Case "dg_piz1100_11_all"
      IF dw_graph.Retrieve(gs_company, ls_date)	< 1 THEN
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      cb_print.Enabled =False
	      Return
      ELSE
	      cb_print.Enabled =True
      END IF
	Case "dg_piz1100_22", "dg_piz1100_23"			
      IF dw_graph.Retrieve(gs_company,ls_date, ls_level)	< 1 THEN
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      cb_print.Enabled =False
	      Return
      ELSE
	      cb_print.Enabled =True
      END IF
	Case "dg_piz1100_21", "dg_piz1100_24", "dg_piz1100_25", "dg_piz1100_26"
      IF dw_graph.Retrieve(gs_company,ls_level, gs_today) < 1 THEN
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      cb_print.Enabled =False
	      Return
      ELSE
	      cb_print.Enabled =True
      END IF
	Case "dg_piz1100_31"
      IF dw_graph.Retrieve(gs_company,ls_jobkind, gs_today) < 1 THEN
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      cb_print.Enabled =False
	      Return
      ELSE
	      cb_print.Enabled =True
      END IF
	Case "dg_piz1100_32", "dg_piz1100_33"
      IF dw_graph.Retrieve(gs_company,ls_date, ls_jobkind) < 1 THEN
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      cb_print.Enabled =False
	      Return
      ELSE
	      cb_print.Enabled =True
      END IF
	Case "dg_piz1100_41", "dg_piz1100_42", "dg_piz1100_43"
      IF dw_graph.Retrieve(gs_company,ls_date, ls_deptkind) < 1 THEN
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      cb_print.Enabled =False
	      Return
      ELSE
	      cb_print.Enabled =True
      END IF
	Case "dg_piz1100_44"
      IF dw_graph.Retrieve(gs_company,ls_date) < 1 THEN
			MessageBox("확 인","조회한 자료가 없습니다!!")
	      cb_print.Enabled =False
	      Return
      ELSE
	      cb_print.Enabled =True
      END IF
End Choose

end event

event ue_open;String				ls_Rt
Integer				ll_Rt, row1, row2
DataWindowChild	lv_dwc1, lv_dwc2 ,lv_dwc3
String				ls_code

Choose Case iv_graph_kind
	Case "dg_piz1100_11","dg_piz1100_12","dg_piz1100_13","dg_piz1100_14","dg_piz1100_16", "dg_piz1100_34"
		dw_arg_workdate.Visible = True
		dw_arg_dept.Visible = True
		dw_arg_dept.X = dw_arg_level.X
		dw_arg_workdate.SetItem(1, 1, iv_workdate)
		dw_arg_dept.SetItem(1, 1, iv_deptcode)
	Case "dg_piz1100_15"
		dw_arg_dept.Visible = True
		dw_arg_dept.X = dw_arg_workdate.X
		dw_arg_dept.SetItem(1, 1, iv_deptcode)
	Case "dg_piz1100_34_all"
		dw_arg_workdate.Visible = True
		dw_arg_workdate.SetItem(1, 1, iv_workdate)		
	Case "dg_piz1100_11_all"
		dw_arg_workdate.Visible = True
		dw_arg_workdate.SetItem(1, 1, iv_workdate)		
	Case "dg_piz1100_22", "dg_piz1100_23"
		dw_arg_workdate.Visible = True
		dw_arg_level.Visible = True
		dw_arg_workdate.SetItem(1, 1, iv_workdate)
		dw_arg_level.SetItem(1, 1, iv_levelcode)
	Case "dg_piz1100_21", "dg_piz1100_24", "dg_piz1100_25", "dg_piz1100_26"
		dw_arg_level.Visible = True
		dw_arg_level.X = dw_arg_workdate.X
		dw_arg_level.SetItem(1, 1, iv_levelcode)
	Case "dg_piz1100_32", "dg_piz1100_33"
		dw_arg_workdate.Visible = True
		dw_arg_jobkind.Visible = True
		dw_arg_jobkind.X = dw_arg_level.X
		dw_arg_workdate.SetItem(1, 1, iv_workdate)
		dw_arg_jobkind.SetItem(1, 1, iv_jobkindcode)
	Case "dg_piz1100_31"
		dw_arg_jobkind.Visible = True
		dw_arg_jobkind.X = dw_arg_workdate.X
		dw_arg_jobkind.SetItem(1, 1, iv_jobkindcode)
	Case "dg_piz1100_41", "dg_piz1100_42", "dg_piz1100_43"
		dw_arg_workdate.Visible = True
		dw_arg_deptkind.Visible = True
		dw_arg_deptkind.X = dw_arg_level.X
		dw_arg_workdate.SetItem(1, 1, iv_workdate)
		dw_arg_deptkind.SetItem(1, 1, iv_deptkindcode)
//	Case "dg_piz1100_44"
//		dw_arg_workdate.Visible = True
//		dw_arg_workdate.SetItem(1, 1, iv_workdate)
End Choose

this.SetRedraw(True)

TriggerEvent("ue_graph")

end event

event open;call super::open;datawindowchild lv_dwc3
datawindowchild lv_dwc4
st_graph_p	parm

f_window_center(this)

parm = Message.PowerObjectParm

iv_graph_kind = parm.graph_kind
iv_workdate = parm.workdate
iv_deptcode = parm.deptcode
iv_levelcode = parm.levelcode
iv_jobkindcode = parm.jobkindcode
iv_deptkindcode = parm.deptkindcode

this.SetRedraw(False)

dw_graph.DataObject = iv_graph_kind
dw_graph.SetTransObject(SQLCA)

// 3차원막대그래프로 변환 ( 원 dw 는 pie graph 이어야 한다 )
//dw_graph.modify("gr_1.graphtype=9 gr_1.values.labeldispattr.font.escapement=2700")

dw_arg_dept.SetTransObject(SQLCA)
dw_arg_dept.getchild('deptcode',lv_dwc3)

lv_dwc3.settransobject(sqlca)

lv_dwc3.retrieve(gs_company)
dw_arg_deptkind.SetTransObject(SQLCA)
dw_arg_deptkind.getchild('deptkindcode',lv_dwc4)

lv_dwc4.settransobject(sqlca)
lv_dwc4.retrieve(gs_company)

dw_arg_deptkind.SetTransObject(SQLCA)
dw_arg_level.SetTransObject(SQLCA)
dw_arg_jobkind.SetTransObject(SQLCA)
dw_arg_workdate.SetTransObject(SQLCA)

//dw_pipe_err.SetTransObject(SQLCA)          // pipeline error datawindow

dw_arg_dept.InsertRow(0)
dw_arg_deptkind.InsertRow(0)
dw_arg_level.InsertRow(0)
dw_arg_jobkind.InsertRow(0)
dw_arg_workdate.InsertRow(0)

PostEvent("ue_open")

end event

on w_piz1100_2.create
int iCurrent
call super::create
this.dw_graph=create dw_graph
this.st_popup=create st_popup
this.dw_pipe_err=create dw_pipe_err
this.dw_arg_deptkind=create dw_arg_deptkind
this.dw_arg_jobkind=create dw_arg_jobkind
this.dw_arg_level=create dw_arg_level
this.dw_arg_dept=create dw_arg_dept
this.rr_3=create rr_3
this.rr_2=create rr_2
this.dw_arg_workdate=create dw_arg_workdate
this.cb_print=create cb_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_graph
this.Control[iCurrent+2]=this.st_popup
this.Control[iCurrent+3]=this.dw_pipe_err
this.Control[iCurrent+4]=this.dw_arg_deptkind
this.Control[iCurrent+5]=this.dw_arg_jobkind
this.Control[iCurrent+6]=this.dw_arg_level
this.Control[iCurrent+7]=this.dw_arg_dept
this.Control[iCurrent+8]=this.rr_3
this.Control[iCurrent+9]=this.rr_2
this.Control[iCurrent+10]=this.dw_arg_workdate
this.Control[iCurrent+11]=this.cb_print
end on

on w_piz1100_2.destroy
call super::destroy
destroy(this.dw_graph)
destroy(this.st_popup)
destroy(this.dw_pipe_err)
destroy(this.dw_arg_deptkind)
destroy(this.dw_arg_jobkind)
destroy(this.dw_arg_level)
destroy(this.dw_arg_dept)
destroy(this.rr_3)
destroy(this.rr_2)
destroy(this.dw_arg_workdate)
destroy(this.cb_print)
end on

type p_mod from w_inherite_standard`p_mod within w_piz1100_2
boolean visible = false
integer x = 2313
integer y = 2384
end type

type p_del from w_inherite_standard`p_del within w_piz1100_2
boolean visible = false
integer x = 2487
integer y = 2384
end type

type p_inq from w_inherite_standard`p_inq within w_piz1100_2
boolean visible = false
integer x = 1618
integer y = 2384
end type

type p_print from w_inherite_standard`p_print within w_piz1100_2
boolean visible = false
integer x = 1445
integer y = 2384
end type

type p_can from w_inherite_standard`p_can within w_piz1100_2
boolean visible = false
integer x = 2661
integer y = 2384
end type

type p_exit from w_inherite_standard`p_exit within w_piz1100_2
integer x = 3296
integer y = 20
end type

type p_ins from w_inherite_standard`p_ins within w_piz1100_2
boolean visible = false
integer x = 1792
integer y = 2384
end type

type p_search from w_inherite_standard`p_search within w_piz1100_2
boolean visible = false
integer x = 1266
integer y = 2384
end type

type p_addrow from w_inherite_standard`p_addrow within w_piz1100_2
boolean visible = false
integer x = 1966
integer y = 2384
end type

type p_delrow from w_inherite_standard`p_delrow within w_piz1100_2
boolean visible = false
integer x = 2139
integer y = 2384
end type

type dw_insert from w_inherite_standard`dw_insert within w_piz1100_2
boolean visible = false
integer x = 1006
integer y = 2384
end type

type st_window from w_inherite_standard`st_window within w_piz1100_2
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_piz1100_2
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_piz1100_2
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_piz1100_2
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_piz1100_2
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_piz1100_2
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_piz1100_2
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_piz1100_2
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_piz1100_2
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_piz1100_2
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_piz1100_2
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_piz1100_2
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_piz1100_2
boolean visible = false
end type

type dw_graph from datawindow within w_piz1100_2
event ue_rbutton pbm_rbuttonup
integer x = 69
integer y = 240
integer width = 3337
integer height = 1708
integer taborder = 90
boolean bringtotop = true
string dataobject = "dg_piz1100_11"
boolean border = false
boolean livescroll = true
end type

event ue_rbutton;st_popup.visible = False
end event

event clicked;//Integer			li_series, li_category
//grObjectType	le_Type
//wg_pers_graph	ww
//st_graph_parm	parm
//
//Choose Case iv_graph_kind
//	Case "dg_pers12"
//		le_type = this.ObjectAtPointer("gr_1", li_series, li_category)
//		If le_type = TypeData! or le_type = TypeCategory! Then
//			parm.graph_kind = "dg_pers121" 
//			parm.workdate = dw_arg_workdate.GetItemDateTime(1, 1)
//			parm.business = this.categoryname("gr_1", li_category)
//			OpenWithParm(ww, parm)
//		End If
//	Case "dg_pers31"
//		le_type = this.ObjectAtPointer("gr_1", li_series, li_category)
//		If le_type = TypeData! or le_type = TypeCategory! Then
//			parm.graph_kind = "dg_pers311" 
//			parm.workdate = dw_arg_workdate.GetItemDateTime(1, 1)
//			parm.jobkindtag = this.categoryname("gr_1", li_category)
//			OpenWithParm(ww, parm)
//		End If
//	Case "dg_pers32"
//		le_type = this.ObjectAtPointer("gr_1", li_series, li_category)
//		If le_type = TypeData! or le_type = TypeCategory! Then
//			parm.graph_kind = "dg_pers321" 
//			parm.workdate = dw_arg_workdate.GetItemDateTime(1, 1)
//			parm.deptkind = this.categoryname("gr_1", li_category)
//			OpenWithParm(ww, parm)
//		End If
//	Case "dg_pers321"
//		le_type = this.ObjectAtPointer("gr_1", li_series, li_category)
//		If le_type = TypeData! or le_type = TypeCategory! Then
//			parm.graph_kind = "dg_pers3211" 
//			parm.workdate = dw_arg_workdate.GetItemDateTime(1, 1)
//			parm.deptkind = iv_deptkind
//			parm.jobkindtag = this.categoryname("gr_1", li_category)
//			OpenWithParm(ww, parm)
//		End If
//
//End Choose
//
end event

event rbuttondown;// Clicked script for dw_headcount
// This will cause a static text box to appear next to the pointer where the user
// is using right mouse button down. The acutal value for the data item will
// be displayed in the text box.

grObjectType	ClickedObject
string			ls_grgraphname 
int				li_series, li_category


ls_grgraphname = dwo.name

/************************************************************
	Find out where the user clicked in the graph
 ***********************************************************/
ClickedObject = this.ObjectAtPointer (ls_grgraphname, li_series, &
						li_category)

/************************************************************
	If user clicked on data or category, find out which one
 ***********************************************************/
If ClickedObject = TypeData! Then
	st_popup.text = string(this.GetData(ls_grgraphname, li_series, li_category)) 
	st_popup.x = parent.PointerX()
	st_popup.y = parent.PointerY() - 65
	st_popup.visible = true
End If

end event

type st_popup from statictext within w_piz1100_2
boolean visible = false
integer x = 1385
integer y = 2868
integer width = 311
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "Popup"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_pipe_err from datawindow within w_piz1100_2
boolean visible = false
integer x = 311
integer y = 3012
integer width = 425
integer height = 136
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
boolean livescroll = true
end type

type dw_arg_deptkind from datawindow within w_piz1100_2
boolean visible = false
integer x = 887
integer y = 44
integer width = 914
integer height = 84
integer taborder = 100
boolean bringtotop = true
string dataobject = "d_piz1100_4"
boolean border = false
boolean livescroll = true
end type

event itemchanged;
cb_update.Enabled =True


end event

type dw_arg_jobkind from datawindow within w_piz1100_2
boolean visible = false
integer x = 891
integer y = 44
integer width = 850
integer height = 84
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_piz1100_2"
boolean border = false
boolean livescroll = true
end type

event itemchanged;cb_update.Enabled =True


end event

type dw_arg_level from datawindow within w_piz1100_2
boolean visible = false
integer x = 891
integer y = 44
integer width = 978
integer height = 84
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_piz1100_5"
boolean border = false
boolean livescroll = true
end type

event itemchanged;cb_update.Enabled =True


end event

event itemfocuschanged;
cb_update.Enabled =True


end event

type dw_arg_dept from datawindow within w_piz1100_2
boolean visible = false
integer x = 891
integer y = 44
integer width = 1038
integer height = 84
integer taborder = 110
boolean bringtotop = true
string dataobject = "d_piz1100_3"
boolean border = false
boolean livescroll = true
end type

type rr_3 from roundrectangle within w_piz1100_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 212
integer width = 3433
integer height = 1764
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_piz1100_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 16
integer width = 1925
integer height = 156
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_arg_workdate from u_key_enter within w_piz1100_2
boolean visible = false
integer x = 69
integer y = 44
integer width = 690
integer height = 88
integer taborder = 11
string dataobject = "d_piz1100_1"
boolean border = false
end type

type cb_print from commandbutton within w_piz1100_2
boolean visible = false
integer x = 2601
integer y = 2876
integer width = 393
integer height = 120
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "출력(&P)"
end type

event clicked;OpenWithParm(w_print_options, dw_graph)
end event

