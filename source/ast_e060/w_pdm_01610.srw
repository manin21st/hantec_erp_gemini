$PBExportHeader$w_pdm_01610.srw
$PBExportComments$** BOM 변경 요청 등록(승인 및 의견)
forward
global type w_pdm_01610 from w_inherite
end type
type pb_1 from u_pb_cal within w_pdm_01610
end type
end forward

global type w_pdm_01610 from w_inherite
integer x = 530
integer y = 212
integer width = 2711
integer height = 1996
string title = "BOM변경 요청 등록(승인 및 의견)"
boolean minbox = false
windowtype windowtype = response!
pb_1 pb_1
end type
global w_pdm_01610 w_pdm_01610

type variables
str_chg chg_str //구조체
end variables

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
if dw_insert.AcceptText() = -1 then return -1

if Isnull(dw_insert.object.chgemp[1]) or dw_insert.object.chgemp[1] =  "" then
   f_message_chk(1400,'[변경담당자]')
   dw_insert.SetColumn('chgemp')
   dw_insert.SetFocus()
   return -1
elseif Isnull(dw_insert.object.cnfemp[1]) or dw_insert.object.cnfemp[1] =  "" then
   f_message_chk(1400,'[승인담당자]')
   dw_insert.SetColumn('cnfemp')
   dw_insert.SetFocus()
   return -1
end if	

return 1
end function

on w_pdm_01610.create
int iCurrent
call super::create
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
end on

on w_pdm_01610.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
end on

event open;call super::open;chg_str = Message.PowerObjectParm //구조체에 파라미터 전달 받음 

dw_insert.SetTransObject(SQLCA)
dw_insert.Setredraw(False)
dw_insert.ReSet()
if dw_insert.Retrieve(chg_str.aft_itnbr, chg_str.chgdat) < 1 then
	dw_insert.InsertRow(0)
end if
dw_insert.object.aft_itnbr[1] = chg_str.aft_itnbr
dw_insert.object.chgdat[1] = chg_str.chgdat
dw_insert.object.bfr_itnbr[1] = chg_str.bfr_itnbr
dw_insert.object.reldpt[1] = chg_str.buse
dw_insert.Setredraw(True)
dw_insert.SetFocus()


end event

type dw_insert from w_inherite`dw_insert within w_pdm_01610
integer x = 23
integer y = 208
integer width = 2633
integer height = 1616
integer taborder = 10
string dataobject = "d_pdm_01610_01"
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::getfocus;sle_msg.Text = ""
end event

event dw_insert::itemfocuschanged;String sCol

sCol = this.GetColumnName()
if sCol = "chgemp" or sCol = "cnfdat" or sCol = "cnfemp" then
	f_toggle_eng(Handle(this))
else	
	f_toggle_kor(Handle(this))
end if	
end event

event dw_insert::itemchanged;string s_cod, s_nam1, s_nam2
integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "cnfdat" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[승인일자]")
		this.setitem(1,"cnfdat","")
		return 1
	end if
elseif this.GetColumnName() = 'chgemp' then   
	i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
	this.setitem(1,"chgemp",s_cod)
	this.setitem(1,"empname1",s_nam1)
	return i_rtn
elseif this.getcolumnname() = 'cnfemp' then   
	i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
	this.setitem(1,"cnfemp",s_cod)
	this.setitem(1,"empname2",s_nam1)
	return i_rtn
end if

end event

event dw_insert::ue_pressenter;String scol

scol = this.GetColumnName()
if scol = "buyrmk" or scol = "mfgrmk" or &
   scol = "yonrmk" or scol = "menrmk" then return
	
Send(Handle(this),256,9,0)
Return 1
end event

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "chgemp"	THEN		
	open(w_sawon_popup)
	this.SetItem(1, "chgemp", gs_code)
	this.SetItem(1, "empname1", gs_codename)
   return
ELSEIF this.getcolumnname() = "cnfemp"	THEN		
	open(w_sawon_popup)
	this.SetItem(1, "cnfemp", gs_code)
	this.SetItem(1, "empname2", gs_codename)
	return 
END IF
end event

type p_delrow from w_inherite`p_delrow within w_pdm_01610
boolean visible = false
integer x = 4306
integer y = 1180
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01610
boolean visible = false
integer x = 4133
integer y = 1180
end type

type p_search from w_inherite`p_search within w_pdm_01610
boolean visible = false
integer x = 3438
integer y = 1180
end type

type p_ins from w_inherite`p_ins within w_pdm_01610
boolean visible = false
integer x = 3959
integer y = 1180
end type

type p_exit from w_inherite`p_exit within w_pdm_01610
integer x = 2478
integer y = 40
end type

type p_can from w_inherite`p_can within w_pdm_01610
integer x = 2304
integer y = 40
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_insert.Setredraw(False)
dw_insert.ReSet()
if dw_insert.Retrieve(chg_str.aft_itnbr, chg_str.chgdat) < 1 then
	dw_insert.InsertRow(0)
end if
dw_insert.object.aft_itnbr[1] = chg_str.aft_itnbr
dw_insert.object.chgdat[1] = chg_str.chgdat
dw_insert.object.bfr_itnbr[1] = chg_str.bfr_itnbr
dw_insert.object.reldpt[1] = chg_str.buse
dw_insert.Setredraw(True)

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_pdm_01610
boolean visible = false
integer x = 3611
integer y = 1180
end type

type p_inq from w_inherite`p_inq within w_pdm_01610
boolean visible = false
integer x = 3785
integer y = 1180
end type

type p_del from w_inherite`p_del within w_pdm_01610
boolean visible = false
integer x = 4654
integer y = 1180
end type

type p_mod from w_inherite`p_mod within w_pdm_01610
integer x = 2130
integer y = 40
end type

event p_mod::clicked;call super::clicked;if f_msg_update() = -1 then return  //저장 Yes/No ?
if wf_required_chk() = -1 then return //필수입력항목 체크 
if dw_insert.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"	
	ib_any_typing = False //입력필드 변경여부 No
else
	f_message_chk(32,'[자료저장 실패]') 
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if
 
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01610
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01610
integer x = 4114
integer y = 1340
string text = "완료(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01610
integer x = 974
integer y = 2344
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01610
integer x = 2267
integer y = 2356
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01610
integer x = 160
integer y = 2384
end type

type cb_print from w_inherite`cb_print within w_pdm_01610
integer x = 1874
integer y = 2348
end type

type st_1 from w_inherite`st_1 within w_pdm_01610
integer y = 2140
end type

type cb_can from w_inherite`cb_can within w_pdm_01610
end type

type cb_search from w_inherite`cb_search within w_pdm_01610
integer x = 1371
integer y = 2348
end type

type dw_datetime from w_inherite`dw_datetime within w_pdm_01610
integer x = 2903
integer y = 2440
end type

type sle_msg from w_inherite`sle_msg within w_pdm_01610
integer y = 2140
integer width = 2267
end type

type gb_10 from w_inherite`gb_10 within w_pdm_01610
integer x = 41
integer y = 2400
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01610
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01610
end type

type pb_1 from u_pb_cal within w_pdm_01610
integer x = 823
integer y = 608
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('cnfdat')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'cnfdat', gs_code)
end event

