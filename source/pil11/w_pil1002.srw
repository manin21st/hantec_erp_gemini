$PBExportHeader$w_pil1002.srw
$PBExportComments$개인별 상환 내역 조회/출력
forward
global type w_pil1002 from w_inherite_standard
end type
type dw_mst from datawindow within w_pil1002
end type
type dw_list from datawindow within w_pil1002
end type
type dw_print from datawindow within w_pil1002
end type
type rr_1 from roundrectangle within w_pil1002
end type
end forward

global type w_pil1002 from w_inherite_standard
string title = "개인별 상환 내역 조회/출력"
dw_mst dw_mst
dw_list dw_list
dw_print dw_print
rr_1 rr_1
end type
global w_pil1002 w_pil1002

on w_pil1002.create
int iCurrent
call super::create
this.dw_mst=create dw_mst
this.dw_list=create dw_list
this.dw_print=create dw_print
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mst
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.dw_print
this.Control[iCurrent+4]=this.rr_1
end on

on w_pil1002.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mst)
destroy(this.dw_list)
destroy(this.dw_print)
destroy(this.rr_1)
end on

event open;call super::open;dw_mst.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

dw_print.SetTransObject(sqlca)

dw_mst.reset()
dw_list.reset()
dw_print.reset()

dw_mst.insertrow(0)
dw_mst.setfocus()
dw_mst.setcolumn('empno')

dw_print.visible = false

end event

type p_mod from w_inherite_standard`p_mod within w_pil1002
boolean visible = false
integer x = 3200
integer y = 2860
end type

type p_del from w_inherite_standard`p_del within w_pil1002
boolean visible = false
integer x = 3374
integer y = 2860
end type

type p_inq from w_inherite_standard`p_inq within w_pil1002
integer x = 4069
end type

event p_inq::clicked;call super::clicked;string ls_empno, ls_empname
long ll_row, ll_gongjae, ll_lendamt, ll_tcnt

if dw_mst.AcceptText() = -1 then return


ll_row = dw_mst.getrow()
ls_empno = dw_mst.GetItemString(ll_row, 'empno')

if ls_empno="" or isnull(ls_empno) then
    f_message_chk(30, '[사원번호]')
     return
end if

dw_list.setredraw(false)
if dw_list.retrieve(ls_empno) <= 0 then
   Messagebox("확 인", "검색된 자료가 존재하지 않습니다.!!")
   dw_list.setredraw(true)	
	return
end if  

ll_lendamt = dw_mst.GetItemNumber(1, 'lendamt')
//ll_gongjae = dw_list.GetItemNumber(1, 'tmp_gongjae') 2003.1.16 고침
ll_gongjae = dw_list.GetItemNumber(1, 'restamt')
if isnull(ll_lendamt) then ll_lendamt = 0

if isnull(ll_gongjae) then ll_gongjae = 0

//미상환액 = 대여금 - 공제금액 합계
ll_tcnt = ll_lendamt - ll_gongjae 

if isnull(ll_tcnt) then ll_tcnt = 0

dw_mst.SetItem(1, 'temp1',  ll_tcnt)


dw_list.setredraw(true)
end event

type p_print from w_inherite_standard`p_print within w_pil1002
integer x = 3895
end type

event p_print::clicked;call super::clicked;string ls_empno, ls_empname
long ll_row, ll_prev_row, Li_row = 1

SetNull(gi_page)

if dw_mst.AcceptText() = -1 then return


ll_row = dw_mst.getrow()
ls_empno = dw_mst.GetItemString(ll_row, 'empno')

if ls_empno="" or isnull(ls_empno) then
    f_message_chk(30, '[사원번호]')
     return
end if

//dw_print.setredraw(false)
if dw_print.retrieve(ls_empno) <= 0 then
   Messagebox("확 인", "검색된 자료가 존재하지 않습니다.!!")
//   dw_print.setredraw(true)	
	return
end if

//dw_list.setredraw(true)
//if dw_print.print() <> 1 then
//	return
//end if

dw_print.object.datawindow.print.preview="yes"

gi_page = 1

do while true
	ll_prev_row = Li_row
	Li_row = dw_list.ScrollNextPage()
	If Li_row = ll_prev_row or Li_row <= 0 then
		exit
	Else
		gi_page++
	End if
loop


OpenWithParm(w_print_options, dw_print)
end event

type p_can from w_inherite_standard`p_can within w_pil1002
integer x = 4242
end type

event p_can::clicked;call super::clicked;dw_mst.setredraw(false)
dw_list.setredraw(false)
dw_mst.reset()
dw_list.reset()

dw_mst.insertrow(0)
dw_mst.setfocus()
dw_mst.setcolumn('empno')
dw_mst.setredraw(true)
dw_list.setredraw(true)
end event

type p_exit from w_inherite_standard`p_exit within w_pil1002
integer x = 4416
end type

type p_ins from w_inherite_standard`p_ins within w_pil1002
boolean visible = false
integer x = 2679
integer y = 2860
end type

type p_search from w_inherite_standard`p_search within w_pil1002
boolean visible = false
integer x = 2505
integer y = 2860
end type

type p_addrow from w_inherite_standard`p_addrow within w_pil1002
boolean visible = false
integer x = 2853
integer y = 2860
end type

type p_delrow from w_inherite_standard`p_delrow within w_pil1002
boolean visible = false
integer x = 3026
integer y = 2860
end type

type dw_insert from w_inherite_standard`dw_insert within w_pil1002
boolean visible = false
integer x = 3643
integer y = 2944
end type

type st_window from w_inherite_standard`st_window within w_pil1002
boolean visible = false
integer x = 2226
integer y = 3076
end type

type cb_exit from w_inherite_standard`cb_exit within w_pil1002
boolean visible = false
integer x = 2062
integer y = 2900
integer taborder = 40
end type

type cb_update from w_inherite_standard`cb_update within w_pil1002
boolean visible = false
integer x = 128
integer y = 2904
integer taborder = 50
boolean enabled = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pil1002
boolean visible = false
integer x = 987
integer y = 2900
integer taborder = 70
string text = "출력(&P)"
end type

event cb_insert::clicked;call super::clicked;string ls_empno, ls_empname
long ll_row, ll_prev_row, Li_row = 1

SetNull(gi_page)

if dw_mst.AcceptText() = -1 then return


ll_row = dw_mst.getrow()
ls_empno = dw_mst.GetItemString(ll_row, 'empno')

if ls_empno="" or isnull(ls_empno) then
    f_message_chk(30, '[사원번호]')
     return
end if

//dw_print.setredraw(false)
if dw_print.retrieve(ls_empno) <= 0 then
   Messagebox("확 인", "검색된 자료가 존재하지 않습니다.!!")
//   dw_print.setredraw(true)	
	return
end if

//dw_list.setredraw(true)
//if dw_print.print() <> 1 then
//	return
//end if

dw_print.object.datawindow.print.preview="yes"

gi_page = 1

do while true
	ll_prev_row = Li_row
	Li_row = dw_list.ScrollNextPage()
	If Li_row = ll_prev_row or Li_row <= 0 then
		exit
	Else
		gi_page++
	End if
loop


OpenWithParm(w_print_options, dw_print)
end event

type cb_delete from w_inherite_standard`cb_delete within w_pil1002
boolean visible = false
integer x = 494
integer y = 2904
integer taborder = 60
boolean enabled = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pil1002
boolean visible = false
integer x = 1358
integer y = 2900
integer taborder = 20
end type

event cb_retrieve::clicked;call super::clicked;string ls_empno, ls_empname
long ll_row, ll_gongjae, ll_lendamt, ll_tcnt

if dw_mst.AcceptText() = -1 then return


ll_row = dw_mst.getrow()
ls_empno = dw_mst.GetItemString(ll_row, 'empno')

if ls_empno="" or isnull(ls_empno) then
    f_message_chk(30, '[사원번호]')
     return
end if

dw_list.setredraw(false)
if dw_list.retrieve(ls_empno) <= 0 then
   Messagebox("확 인", "검색된 자료가 존재하지 않습니다.!!")
   dw_list.setredraw(true)	
	return
end if  
ll_lendamt = dw_mst.GetItemNumber(1, 'lendamt')
ll_gongjae = dw_list.GetItemNumber(1, 'tmp_gongjae')

if isnull(ll_lendamt) then ll_lendamt = 0

if isnull(ll_gongjae) then ll_gongjae = 0

//미상환액 = 대여금 - 공제금액 합계
ll_tcnt = ll_lendamt - ll_gongjae 

if isnull(ll_tcnt) then ll_tcnt = 0

dw_mst.SetItem(1, 'temp1',  ll_tcnt)


dw_list.setredraw(true)

end event

type st_1 from w_inherite_standard`st_1 within w_pil1002
boolean visible = false
integer x = 59
integer y = 3080
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pil1002
boolean visible = false
integer x = 1691
integer y = 2900
integer taborder = 30
end type

event cb_cancel::clicked;call super::clicked;dw_mst.setredraw(false)
dw_list.setredraw(false)
dw_mst.reset()
dw_list.reset()

dw_mst.insertrow(0)
dw_mst.setfocus()
dw_mst.setcolumn('empno')
dw_mst.setredraw(true)
dw_list.setredraw(true)

end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pil1002
boolean visible = false
integer x = 2871
integer y = 3076
end type

type sle_msg from w_inherite_standard`sle_msg within w_pil1002
boolean visible = false
integer x = 389
integer y = 3076
end type

type gb_2 from w_inherite_standard`gb_2 within w_pil1002
boolean visible = false
integer x = 919
integer y = 2840
end type

type gb_1 from w_inherite_standard`gb_1 within w_pil1002
boolean visible = false
integer x = 78
integer y = 2844
boolean enabled = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pil1002
boolean visible = false
integer x = 41
integer y = 3024
end type

type dw_mst from datawindow within w_pil1002
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 649
integer y = 20
integer width = 2569
integer height = 336
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pil1002_1"
boolean border = false
boolean livescroll = true
end type

event ue_enterkey;Send(Handle(this),256,9,0)

Return 1

end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String sEmpNo,sEmpName

dw_mst.SetRedraw(False)

If this.GetColumnName() = "empno" Then

	sempno = this.GetText()
	
	IF sempno ="" OR IsNull(sempno) THEN RETURN
	
	IF IsNull(wf_exiting_data("empno",sempno,"1")) THEN
		Messagebox("확 인","등록되지 않은 사번이므로 조회할 수 없습니다!!")
		this.SetRedraw(False)
		this.Reset()
		this.InsertRow(0)
		this.SetColumn("empno")
		this.SetFocus()
		this.SetRedraw(True)
		dw_list.reset()				
		Return 1
	END IF	
	dw_mst.SetRedraw(false)
	if dw_mst.Retrieve(sempno,'%') <= 0 then
		MessageBox("확 인", "대여금 내역이 존재하지 않는 사번입니다.!!")
		dw_mst.Reset()
		dw_mst.InsertRow(0)
		dw_mst.SetColumn("empno")
		dw_mst.SetFocus()
   	dw_mst.SetRedraw(True)				
		dw_list.reset()				
		return 1
	end if
	dw_mst.SetRedraw(True)
elseIf dw_mst.GetColumnName() = "p1_master_empname" Then
	sempname = this.GetText()
	
	IF sempname ="" OR IsNull(sempname) THEN RETURN
	
	sempno = wf_exiting_data("empname",sempname,"1")	
	IF IsNull(sempno) THEN
		Messagebox("확 인","등록되지 않은 사원이므로 조회할 수 없습니다!!")
		this.SetRedraw(False)
		this.Reset()
		this.InsertRow(0)
		this.SetColumn("p1_master_empname")
		this.SetFocus()
		this.SetRedraw(True)
		dw_list.reset()		
		Return 1
	END IF
   
	dw_mst.SetRedraw(false)
	if dw_mst.Retrieve(sempno,'%') <= 0 then
		MessageBox("확 인", "대여금 내역이 존재하지 않는 사번입니다.!!")
		dw_mst.Reset()
		dw_mst.InsertRow(0)
		dw_mst.SetColumn("empno")
		dw_mst.SetFocus()
   	dw_mst.SetRedraw(True)				
		dw_list.reset()				
		return 1
	end if
	dw_mst.SetRedraw(True)
end if

p_inq.TriggerEvent(Clicked!)
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

this.AcceptText()

IF This.GetColumnName() = "empno" THEN
	SetNull(Gs_Code)	
	SetNull(Gs_Codename)

	open(w_pil1001_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	IF IsNull(Gs_codeName) THEN RETURN		
	
	this.SetItem(this.GetRow(), "empno", Gs_code)
	this.SetItem(this.GetRow(), "p1_master_empname", Gs_code)	
	this.TriggerEvent(ItemChanged!)
END IF


IF This.GetColumnName() = "p1_master_empname" THEN
	SetNull(Gs_Code)	
	SetNull(Gs_Codename)
	
	
	open(w_pil1001_popup)

	IF IsNull(Gs_code) THEN RETURN
	IF IsNull(Gs_codeName) THEN RETURN	
	
	this.SetItem(this.GetRow(), "empno", Gs_code)	
	this.SetItem(this.GetRow(), "p1_master_empname", Gs_codeName)
	this.TriggerEvent(ItemChanged!)
END IF


end event

event itemerror;return 1

end event

type dw_list from datawindow within w_pil1002
integer x = 672
integer y = 392
integer width = 3195
integer height = 1816
boolean bringtotop = true
string dataobject = "d_pil1002_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_print from datawindow within w_pil1002
boolean visible = false
integer x = 2473
integer y = 2752
integer width = 1125
integer height = 100
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "개인별 상환내역 출력"
string dataobject = "d_pil1011_2"
boolean maxbox = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_pil1002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 645
integer y = 372
integer width = 3255
integer height = 1860
integer cornerheight = 40
integer cornerwidth = 55
end type

