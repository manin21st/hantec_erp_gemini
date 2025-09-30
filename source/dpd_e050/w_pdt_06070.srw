$PBExportHeader$w_pdt_06070.srw
$PBExportComments$** 설비그룹코드 등록
forward
global type w_pdt_06070 from w_inherite
end type
type rr_1 from roundrectangle within w_pdt_06070
end type
type gb_2 from groupbox within w_pdt_06070
end type
type cb_add from commandbutton within w_pdt_06070
end type
type st_2 from statictext within w_pdt_06070
end type
type st_3 from statictext within w_pdt_06070
end type
end forward

global type w_pdt_06070 from w_inherite
string title = "설비그룹코드 등록"
boolean resizable = true
rr_1 rr_1
gb_2 gb_2
cb_add cb_add
st_2 st_2
st_3 st_3
end type
global w_pdt_06070 w_pdt_06070

forward prototypes
public function integer wf_required_chk ()
public function integer wf_delete_chk (string scode)
end prototypes

public function integer wf_required_chk ();String grpcod, grpnam
Long i, ll_found, lCount

lCount = dw_insert.RowCount()
for i = 1 to lCount
	if IsNull(Trim(dw_insert.object.grpcod[i])) or Trim(dw_insert.object.grpcod[i]) = "" then
		f_message_chk(1400,"[그룹코드]")
		dw_insert.SetRow(i)
		dw_insert.SetColumn("grpcod")
		dw_insert.SetFocus()
		return -1
	end if
	if IsNull(dw_insert.object.grpnam[i]) or dw_insert.object.grpnam[i] = "" then
		f_message_chk(1400,"[그 룹 명]")
		dw_insert.SetRow(i)
		dw_insert.SetColumn("grpnam")
		dw_insert.SetFocus()
		return -1
	end if
	grpcod = dw_insert.object.grpcod[i] 
	if i < dw_insert.RowCount() then
      ll_found = dw_insert.Find("grpcod = '" + grpcod + "'", i + 1, dw_insert.RowCount())
		if ll_found > 0 then
			MessageBox("코드 중복", String(ll_found) + " 번째 Row의 그룹코드가 중복입니다!(등록 불가능!)")
			return -1
		end if	
   end if
next

return 1
end function

public function integer wf_delete_chk (string scode);Long icnt = 0

select count(*) into :icnt 
  from mchmst
 where sabu   = :gs_sabu 
   and grpcod = :scode;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[설비마스터]')
	return -1
end if

return 1
end function

on w_pdt_06070.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.gb_2=create gb_2
this.cb_add=create cb_add
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.cb_add
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
end on

on w_pdt_06070.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.gb_2)
destroy(this.cb_add)
destroy(this.st_2)
destroy(this.st_3)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_insert.Setredraw(False)
if dw_insert.Retrieve() < 1 then
	dw_insert.InsertRow(0)
end if	
dw_insert.Setredraw(True)
dw_insert.SetFocus()


end event

type dw_insert from w_inherite`dw_insert within w_pdt_06070
integer x = 1513
integer y = 216
integer width = 1627
integer height = 1968
integer taborder = 10
string dataobject = "d_pdt_06070_01"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;this.SetRowFocusIndicator(HAND!)
end event

type p_delrow from w_inherite`p_delrow within w_pdt_06070
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_06070
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_06070
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_06070
integer x = 2290
integer y = 28
end type

event p_ins::clicked;call super::clicked;Long crow

dw_insert.Setredraw(False)
crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	crow = dw_insert.InsertRow(0)
end if	
dw_insert.ScrollToRow(crow)
dw_insert.Setredraw(True)
dw_insert.SetColumn("grpcod")
dw_insert.SetFocus()
end event

type p_exit from w_inherite`p_exit within w_pdt_06070
integer x = 2985
integer y = 28
end type

type p_can from w_inherite`p_can within w_pdt_06070
integer x = 2811
integer y = 28
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_insert.SetRedraw(False)
dw_insert.Retrieve()
dw_insert.SetRedraw(True)

ib_any_typing = False //입력필드 변경여부 No
end event

type p_print from w_inherite`p_print within w_pdt_06070
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_06070
boolean visible = false
integer x = 2117
integer y = 5000
end type

type p_del from w_inherite`p_del within w_pdt_06070
integer x = 2638
integer y = 28
end type

event p_del::clicked;call super::clicked;Long    crow 
Boolean fg
string  sCode

if dw_insert.accepttext() = -1 then return 

if f_msg_delete() = -1 then return

crow = dw_insert.GetRow()
if crow < 1 or crow > dw_insert.RowCount() then
	w_mdi_frame.sle_msg.text = "해당 그룹코드를 선택한 다음 진행하세요!"
	return
end if	

sCode = dw_insert.getitemstring(crow, 'grpcod')

if wf_delete_chk(sCode) = -1 then return 

if dw_insert.object.gubun[crow] = "Y" then
	fg = True
else
	fg = False
end if	

dw_insert.Setredraw(False)
dw_insert.DeleteRow(crow)
if fg = True then
   if dw_insert.Update() <> 1 then
      ROLLBACK;
      f_message_chk(31,'[삭제실패 : 설비그룹코드]') 
      w_mdi_frame.sle_msg.text = "삭제 작업 실패!"
      dw_insert.Setredraw(True)
	   Return
   else
      COMMIT;
	end if
end if

dw_insert.Setredraw(True)
w_mdi_frame.sle_msg.text = "삭제 되었습니다!"

end event

type p_mod from w_inherite`p_mod within w_pdt_06070
integer x = 2464
integer y = 28
end type

event p_mod::clicked;call super::clicked;Long i

if f_msg_update() = -1 then return
if dw_insert.AcceptText() = -1 then return

if wf_required_chk() = -1 then return //필수입력항목 체크 

IF dw_insert.Update() > 0 THEN
	COMMIT;
	for i = 1 to dw_insert.RowCount()
	    dw_insert.object.gubun[i] = "Y"
   next
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"
	p_del.Enabled = True
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	w_mdi_frame.sle_msg.text = "저장작업 실패!"
END IF

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_exit from w_inherite`cb_exit within w_pdt_06070
boolean visible = false
integer x = 3433
integer y = 5000
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06070
boolean visible = false
integer x = 3328
integer y = 5000
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06070
boolean visible = false
integer x = 503
integer y = 5000
integer taborder = 80
end type

type cb_del from w_inherite`cb_del within w_pdt_06070
boolean visible = false
integer x = 3287
integer y = 5000
end type

type cb_inq from w_inherite`cb_inq within w_pdt_06070
boolean visible = false
integer x = 3287
integer y = 5000
integer taborder = 70
end type

type cb_print from w_inherite`cb_print within w_pdt_06070
boolean visible = false
integer x = 869
integer y = 5000
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_pdt_06070
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_pdt_06070
boolean visible = false
integer x = 3022
integer y = 5000
integer taborder = 50
end type

type cb_search from w_inherite`cb_search within w_pdt_06070
boolean visible = false
integer x = 1920
integer y = 2364
integer width = 334
integer taborder = 100
string text = "IMAGE"
end type



type sle_msg from w_inherite`sle_msg within w_pdt_06070
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_pdt_06070
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_06070
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06070
end type

type rr_1 from roundrectangle within w_pdt_06070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1499
integer y = 204
integer width = 1659
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 55
end type

type gb_2 from groupbox within w_pdt_06070
integer x = 727
integer y = 184
integer width = 750
integer height = 284
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "입력방법"
borderstyle borderstyle = stylelowered!
end type

type cb_add from commandbutton within w_pdt_06070
boolean visible = false
integer x = 3278
integer y = 5000
integer width = 334
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

type st_2 from statictext within w_pdt_06070
integer x = 763
integer y = 268
integer width = 677
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "설비 그룹코드 : 6자리"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdt_06070
integer x = 763
integer y = 368
integer width = 690
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "설비 그 룹 명 : 30자리"
boolean focusrectangle = false
end type

