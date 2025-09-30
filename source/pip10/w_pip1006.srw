$PBExportHeader$w_pip1006.srw
$PBExportComments$** 월변동 자료 등록
forward
global type w_pip1006 from w_inherite_multi
end type
type sle_find from singlelineedit within w_pip1006
end type
type ddlb_find from dropdownlistbox within w_pip1006
end type
type rb_pstag1 from radiobutton within w_pip1006
end type
type rb_pstag2 from radiobutton within w_pip1006
end type
type gb_4 from groupbox within w_pip1006
end type
type dw_main from u_key_enter within w_pip1006
end type
type st_2 from statictext within w_pip1006
end type
type em_ym from editmask within w_pip1006
end type
type dw_empinfo from u_d_popup_sort within w_pip1006
end type
type st_3 from statictext within w_pip1006
end type
type dw_1 from datawindow within w_pip1006
end type
type dw_saup from datawindow within w_pip1006
end type
type rr_1 from roundrectangle within w_pip1006
end type
type rr_2 from roundrectangle within w_pip1006
end type
type rr_3 from roundrectangle within w_pip1006
end type
type ln_2 from line within w_pip1006
end type
type ln_3 from line within w_pip1006
end type
end forward

global type w_pip1006 from w_inherite_multi
string title = "월변동자료 등록"
sle_find sle_find
ddlb_find ddlb_find
rb_pstag1 rb_pstag1
rb_pstag2 rb_pstag2
gb_4 gb_4
dw_main dw_main
st_2 st_2
em_ym em_ym
dw_empinfo dw_empinfo
st_3 st_3
dw_1 dw_1
dw_saup dw_saup
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
ln_2 ln_2
ln_3 ln_3
end type
global w_pip1006 w_pip1006

type variables
String iv_pbtag,iv_pstag,iv_workym
end variables

forward prototypes
public function integer wf_required_check (integer ll_row)
end prototypes

public function integer wf_required_check (integer ll_row);
String scode
Double damount

iv_workym = Left(Trim(em_ym.text),4) + Right(Trim(em_ym.text),2)

dw_main.AcceptText()
scode   = dw_main.GetItemString(ll_row,"allowcode")
damount = dw_main.GetItemNumber(ll_row,"allowamt") 

IF iv_workym ="" OR IsNull(iv_workym) THEN
	MessageBox("확 인","적용년월을 입력하세요!!")
	em_ym.Setfocus()
	Return -1
END IF

IF scode ="" OR IsNull(scode) THEN
	MessageBox("확 인","수당을 입력하세요!!")
	dw_main.SetColumn("allowcode")
	dw_main.SetFocus()
	Return -1
END IF

IF damount = 0 OR IsNull(damount) THEN
	MessageBox("확 인","금액을 입력하세요!!")
	dw_main.SetColumn("allowamt")
	dw_main.SetFocus()
	Return -1
END IF

Return 1
end function

on w_pip1006.create
int iCurrent
call super::create
this.sle_find=create sle_find
this.ddlb_find=create ddlb_find
this.rb_pstag1=create rb_pstag1
this.rb_pstag2=create rb_pstag2
this.gb_4=create gb_4
this.dw_main=create dw_main
this.st_2=create st_2
this.em_ym=create em_ym
this.dw_empinfo=create dw_empinfo
this.st_3=create st_3
this.dw_1=create dw_1
this.dw_saup=create dw_saup
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.ln_2=create ln_2
this.ln_3=create ln_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_find
this.Control[iCurrent+2]=this.ddlb_find
this.Control[iCurrent+3]=this.rb_pstag1
this.Control[iCurrent+4]=this.rb_pstag2
this.Control[iCurrent+5]=this.gb_4
this.Control[iCurrent+6]=this.dw_main
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.em_ym
this.Control[iCurrent+9]=this.dw_empinfo
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.dw_1
this.Control[iCurrent+12]=this.dw_saup
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_3
this.Control[iCurrent+16]=this.ln_2
this.Control[iCurrent+17]=this.ln_3
end on

on w_pip1006.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_find)
destroy(this.ddlb_find)
destroy(this.rb_pstag1)
destroy(this.rb_pstag2)
destroy(this.gb_4)
destroy(this.dw_main)
destroy(this.st_2)
destroy(this.em_ym)
destroy(this.dw_empinfo)
destroy(this.st_3)
destroy(this.dw_1)
destroy(this.dw_saup)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.ln_2)
destroy(this.ln_3)
end on

event open;call super::open;DataWindowChild dw_child

string sDate

dw_empinfo.SetTransObject(SQLCA)      //사원정보
dw_empinfo.Reset()

dw_main.SetTransObject(SQLCA)
dw_main.Reset()

dw_saup.SetTransObject(SQLCA)
dw_saup.InsertRow(0)

f_set_saupcd(dw_saup, 'sabu', '1')
is_saupcd = gs_saupcd

em_ym.Text = String(Left(Gs_Today,6),"@@@@.@@")
sDate= String(Left(Gs_Today,6),"@@@@.@@") + '01'

IF dw_1.GetChild("code",dw_child) = 1 THEN
	dw_child.SetTransObject(SQLCA)
	IF dw_child.Retrieve('PB') <=0 THEN RETURN 
END IF

dw_1.SetTransObject(SQLCA)      //사원정보
dw_1.Reset()
dw_1.insertrow(0)

iv_workym = Left(Gs_Today,6)
dw_1.setitem(1,"code",'P')
iv_pbtag = "P"
iv_pstag = "1"

IF dw_main.GetChild("allowcode",dw_child) = 1 THEN
	dw_child.SetTransObject(SQLCA)
	
	if dw_child.Retrieve(iv_pstag,'2','Y%','%') <=0 THEN return 
END IF
	
IF dw_empinfo.Retrieve(gs_company,sDate,is_saupcd) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!")
	close(this)
	Return
ELSE
	dw_empinfo.SelectRow(0,False)
	dw_empinfo.SelectRow(1,True)
	
	IF dw_main.Retrieve(gs_company,dw_empinfo.GetItemString(1,"empno"),iv_pbtag,iv_pstag,iv_workym) > 0 THEN
		dw_main.ScrollToRow(dw_main.RowCount())
		dw_main.SetFocus()
	ELSE
		dw_empinfo.SetFocus()
	END IF	
END IF




end event

type p_delrow from w_inherite_multi`p_delrow within w_pip1006
boolean visible = false
integer x = 2981
integer y = 3116
end type

type p_addrow from w_inherite_multi`p_addrow within w_pip1006
boolean visible = false
integer x = 2807
integer y = 3116
end type

type p_search from w_inherite_multi`p_search within w_pip1006
boolean visible = false
integer x = 2441
integer y = 3112
end type

type p_ins from w_inherite_multi`p_ins within w_pip1006
integer x = 3721
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_functionvalue

iv_workym = Left(Trim(em_ym.text),4) + Right(Trim(em_ym.text),2)
IF dw_main.RowCount() <=0 THEN
	il_currow = 1
	il_functionvalue = 1
ELSE
	il_functionvalue = wf_required_check(dw_main.GetRow())
	
	il_currow = dw_main.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow 
	
	DataWindowChild dw_child
	string gubn1, gubn2
	IF iv_pbtag = 'P' THEN
		gubn1= 'Y%' 
		gubn2= '%'
	ELSE
		gubn1= '%' 
		gubn2= 'Y%'
	END IF	
	IF dw_main.GetChild("allowcode",dw_child) = 1 THEN
		dw_child.SetTransObject(SQLCA)
		IF dw_child.Retrieve(iv_pstag,'2',gubn1,gubn2) <=0 THEN 
			Messagebox("확 인","등록된 변동항목이 없습니다!!")
			dw_main.reset()
			return 
		END IF
	END IF	
	
	dw_main.InsertRow(il_currow)
	dw_main.SetItem(il_currow,"companycode",gs_company)	
	dw_main.SetItem(il_currow,"empno",&
	dw_empinfo.GetItemString(dw_empinfo.GetRow(),"empno"))
	dw_main.SetItem(il_currow,"pbtag",iv_pbtag)	
	dw_main.SetItem(il_currow,"gubun",iv_pstag)	
	dw_main.SetItem(il_currow,"workym",iv_workym)	
	
	dw_main.ScrollToRow(il_currow)
	dw_main.SetColumn("allowcode")
	dw_main.SetFocus()
	
	
END IF

end event

type p_exit from w_inherite_multi`p_exit within w_pip1006
integer x = 4416
end type

type p_can from w_inherite_multi`p_can within w_pip1006
integer x = 4242
end type

event p_can::clicked;call super::clicked;
w_mdi_frame.sle_msg.text = ''

ib_any_typing = false

dw_main.retrieve(gs_company,dw_empinfo.GetItemString(dw_empinfo.GetSelectedRow(0),"empno"),&
						iv_pbtag,iv_pstag,iv_workym)
dw_main.ScrollToRow(dw_main.RowCount())
dw_main.setfocus()

end event

type p_print from w_inherite_multi`p_print within w_pip1006
boolean visible = false
integer x = 2615
integer y = 3112
end type

type p_inq from w_inherite_multi`p_inq within w_pip1006
integer x = 3547
end type

event p_inq::clicked;call super::clicked;String sempno, ls_saup

dw_saup.AcceptText()
ls_saup = dw_saup.GetItemString(1,"sabu")
IF ls_saup = '' OR IsNull(ls_saup) THEN ls_saup = '%'

iv_workym = Left(Trim(em_ym.text),4) + Right(Trim(em_ym.text),2)

IF iv_workym ="" OR IsNull(iv_workym) THEN
	MessageBox("확 인","적용년월을 입력하세요!!")
	em_ym.Setfocus()
	Return
END IF

IF dw_empinfo.GetSelectedRow(0) <=0 THEN
	MessageBox("확 인","조회할 사원을 선택하세요!!")
	Return
ELSE
	sempno = dw_empinfo.GetItemString(dw_empinfo.GetSelectedRow(0),"empno")
END IF

IF dw_main.retrieve(gs_company,sempno,iv_pbtag,iv_pstag,iv_workym) <= 0 then
	MessageBox("확 인","등록된 자료가 없습니다!!")
	Return
ELSE
	dw_main.ScrollToRow(dw_main.RowCount())
end if
dw_main.setfocus()
end event

type p_del from w_inherite_multi`p_del within w_pip1006
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
		dw_main.SetColumn("allowcode")
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

type p_mod from w_inherite_multi`p_mod within w_pip1006
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
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
	
ELSE
	ROLLBACK USING sqlca;
	ib_any_typing = True
	Return
END IF

dw_main.Setfocus()
		
end event

type dw_insert from w_inherite_multi`dw_insert within w_pip1006
boolean visible = false
integer x = 1947
integer y = 2720
end type

type st_window from w_inherite_multi`st_window within w_pip1006
boolean visible = false
integer x = 2633
integer y = 2976
end type

type cb_append from w_inherite_multi`cb_append within w_pip1006
boolean visible = false
integer x = 901
integer y = 2804
integer taborder = 70
end type

event cb_append::clicked;call super::clicked;//Int il_currow,il_functionvalue
//
//iv_workym = Left(Trim(em_ym.text),4) + Right(Trim(em_ym.text),2)
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
//	DataWindowChild dw_child
//	string gubn1, gubn2
//	IF iv_pbtag = 'P' THEN
//		gubn1= 'Y%' 
//		gubn2= '%'
//	ELSE
//		gubn1= '%' 
//		gubn2= 'Y%'
//	END IF	
//	IF dw_main.GetChild("allowcode",dw_child) = 1 THEN
//		dw_child.SetTransObject(SQLCA)
//		IF dw_child.Retrieve(iv_pstag,'2',gubn1,gubn2) <=0 THEN 
//			Messagebox("확 인","등록된 변동항목이 없습니다!!")
//			dw_main.reset()
//			return 
//		END IF
//	END IF	
//	
//	
//	dw_main.InsertRow(il_currow)
//	dw_main.SetItem(il_currow,"companycode",gs_company)	
//	dw_main.SetItem(il_currow,"empno",&
//					dw_empinfo.GetItemString(dw_empinfo.GetRow(),"empno"))
//	dw_main.SetItem(il_currow,"pbtag",iv_pbtag)	
//	dw_main.SetItem(il_currow,"gubun",iv_pstag)	
//	dw_main.SetItem(il_currow,"workym",iv_workym)	
//
//	dw_main.ScrollToRow(il_currow)
//	dw_main.SetColumn("allowcode")
//	dw_main.SetFocus()
//	
//END IF
//
end event

type cb_exit from w_inherite_multi`cb_exit within w_pip1006
boolean visible = false
integer x = 3630
integer y = 2804
integer taborder = 120
end type

type cb_update from w_inherite_multi`cb_update within w_pip1006
boolean visible = false
integer x = 2533
integer y = 2804
integer taborder = 90
end type

type cb_insert from w_inherite_multi`cb_insert within w_pip1006
boolean visible = false
integer x = 1266
integer y = 2804
integer taborder = 80
end type

type cb_delete from w_inherite_multi`cb_delete within w_pip1006
boolean visible = false
integer x = 2898
integer y = 2804
integer taborder = 100
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pip1006
boolean visible = false
integer x = 535
integer y = 2804
end type

type st_1 from w_inherite_multi`st_1 within w_pip1006
boolean visible = false
integer x = 471
integer y = 2976
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pip1006
boolean visible = false
integer x = 3264
integer y = 2804
integer taborder = 110
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pip1006
boolean visible = false
integer x = 3282
integer y = 2976
end type

type sle_msg from w_inherite_multi`sle_msg within w_pip1006
boolean visible = false
integer x = 800
integer y = 2976
end type

type gb_2 from w_inherite_multi`gb_2 within w_pip1006
boolean visible = false
integer x = 2491
integer y = 2744
end type

type gb_1 from w_inherite_multi`gb_1 within w_pip1006
boolean visible = false
integer x = 489
integer y = 2744
end type

type gb_10 from w_inherite_multi`gb_10 within w_pip1006
boolean visible = false
integer x = 453
integer y = 2924
end type

type sle_find from singlelineedit within w_pip1006
event modified pbm_enmodified
integer x = 1170
integer y = 68
integer width = 503
integer height = 64
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
end type

event modified;
long row

if ddlb_find.text = '성명' then
	row = dw_empinfo.find("left(#3," + string(len(this.text)) + ")='" + this.text + "'", 1, dw_empinfo.rowcount())
else
	row = dw_empinfo.find("left(#2," + string(len(this.text)) + ")='" + this.text + "'", 1, dw_empinfo.rowcount())
end if

if row > 0 then
	dw_empinfo.setredraw(false)
	dw_main.SetRedraw(False)
	
	dw_empinfo.SelectRow(0,False)
	dw_empinfo.SelectRow(row,True)
	
	IF dw_main.Retrieve(gs_company,dw_empinfo.GetItemString(row,"empno"),iv_pbtag,iv_pstag,iv_workym) > 0 THEN
		dw_main.ScrollToRow(dw_main.RowCount())
		dw_main.SetFocus()
	END IF
	dw_empinfo.ScrollToRow(row)
	
	dw_empinfo.setredraw(true)
	dw_main.SetRedraw(True)
end if


end event

event getfocus;
f_toggle_kor(handle(this))
end event

type ddlb_find from dropdownlistbox within w_pip1006
event selectionchanged pbm_cbnselchange
integer x = 1719
integer y = 64
integer width = 384
integer height = 228
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "성명"
boolean vscrollbar = true
string item[] = {"성명","사번"}
end type

event selectionchanged;
sle_find.triggerevent(modified!)
end event

type rb_pstag1 from radiobutton within w_pip1006
event clicked pbm_bnclicked
integer x = 2254
integer y = 108
integer width = 279
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "지 급"
boolean checked = true
end type

event clicked;iv_pstag = "1"

If ib_any_typing = True Then
	IF MessageBox("자료변경", "변경된 자료를 저장하시겠습니까?", Question!, YesNo!) = 1 THEN
		p_mod.TriggerEvent(Clicked!)
	END IF
END IF

p_inq.TriggerEvent(Clicked!)
end event

type rb_pstag2 from radiobutton within w_pip1006
event clicked pbm_bnclicked
integer x = 2533
integer y = 108
integer width = 256
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "공 제"
end type

event clicked;call super::clicked;iv_pstag = "2"

If ib_any_typing = True Then
	IF MessageBox("자료변경", "변경된 자료를 저장하시겠습니까?", Question!, YesNo!) = 1 THEN
		p_mod.TriggerEvent(Clicked!)
	END IF
END IF

p_inq.TriggerEvent(Clicked!)
end event

type gb_4 from groupbox within w_pip1006
integer x = 2217
integer y = 52
integer width = 603
integer height = 152
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 15073280
long backcolor = 33027312
end type

type dw_main from u_key_enter within w_pip1006
integer x = 2487
integer y = 368
integer width = 1746
integer height = 1844
integer taborder = 50
string dataobject = "d_pip1006_2"
boolean vscrollbar = true
boolean border = false
end type

event itemerror;call super::itemerror;
Beep(1)
Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;
//this.SetRowFocusIndicator(Hand!)
end event

event itemchanged;call super::itemchanged;String sname,snull
Int lReturnRow,il_currow

SetNull(snull)

il_currow = this.GetRow()

IF This.GetColumnName() ="allowcode" THEN
	IF data ="" OR IsNull(data) THEN RETURN 
	
	SELECT "P3_ALLOWANCE"."ALLOWNAME"  
   	INTO :sname  
	   FROM "P3_ALLOWANCE"  
   	WHERE "P3_ALLOWANCE"."PAYSUBTAG" = :iv_pstag AND "P3_ALLOWANCE"."ALLOWCODE" =:data  ;
	IF SQLCA.SQLCODE <> 0 THEN
		w_mdi_frame.sle_msg.text ="수당을 등록하시려면 '급여기준정보'메뉴로 이동하십시요!!"
		Messagebox("확 인","등록된 수당이 아닙니다!!")
		this.SetItem(row,"allowcode",snull)
		Return 1
	END IF
	
	lReturnRow = This.Find("allowcode = '"+data+"' ", 1, This.RowCount())
	
	IF (il_currow <> lReturnRow) and (lReturnRow <> 0)		THEN
		MessageBox("확인","등록된 수당입니다.~r등록할 수 없습니다.")
		this.SetItem(il_currow,"allowcode",snull)
		RETURN  1	
	END IF
	
END IF

end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

event retrievestart;
DataWindowChild dw_child
string gubn1, gubn2
Int il_rtn

IF iv_pbtag = 'P' THEN
	gubn1= 'Y%' 
	gubn2= '%'
ELSE
	gubn1= '%' 
	gubn2= 'Y%'
END IF	

il_rtn = dw_main.GetChild("allowcode",dw_child)
IF il_rtn = 1 THEN
	dw_child.SetTransObject(SQLCA)
	
	IF dw_child.Retrieve(iv_pstag,'2',gubn1,gubn2) <=0 THEN 
		Messagebox("확 인","등록된 변동항목이 없습니다!!")
		dw_main.reset()
		return 1
	END IF
END IF
end event

type st_2 from statictext within w_pip1006
integer x = 357
integer y = 164
integer width = 256
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "적용년월"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ym from editmask within w_pip1006
integer x = 635
integer y = 164
integer width = 288
integer height = 60
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
alignment alignment = center!
textcase textcase = upper!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
string displaydata = "~b"
end type

event modified;string ls_saup

iv_workym = Left(Trim(em_ym.text),4) + Right(Trim(em_ym.text),2)

dw_saup.AcceptText()
ls_saup = dw_saup.GetItemString(1,'sabu')
if ls_saup = '' OR isnull(ls_saup) then ls_saup = '%'

IF dw_empinfo.Retrieve(gs_company,iv_workym+'01',ls_saup) <=0 then
else
	dw_main.retrieve(gs_company,dw_empinfo.GetItemString(1,"empno"),iv_pbtag,iv_pstag,iv_workym) 
END IF
end event

type dw_empinfo from u_d_popup_sort within w_pip1006
integer x = 315
integer y = 368
integer width = 2011
integer height = 1844
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_pip1005_1"
boolean vscrollbar = true
boolean border = false
end type

event clicked;If Row <= 0 then
	dw_empinfo.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	dw_main.retrieve(gs_company,dw_empinfo.GetItemString(row,"empno"),iv_pbtag,iv_pstag,iv_workym)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type st_3 from statictext within w_pip1006
integer x = 987
integer y = 76
integer width = 169
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "찾기"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_pip1006
integer x = 1024
integer y = 152
integer width = 837
integer height = 92
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pip1015_30"
boolean border = false
boolean livescroll = true
end type

event itemchanged;
dw_1.accepttext()

iv_pbtag= dw_1.getitemstring(1,"code")

end event

type dw_saup from datawindow within w_pip1006
integer x = 334
integer y = 44
integer width = 635
integer height = 92
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_saupcd"
boolean border = false
boolean livescroll = true
end type

event itemchanged;string ls_saup, sDate

this.AcceptText()

IF this.GetColumnName() = 'sabu' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

iv_workym = em_ym.text

IF dw_empinfo.Retrieve(gs_company,iv_workym+'01', is_saupcd) <=0 then
else
	dw_main.retrieve(gs_company,dw_empinfo.GetItemString(1,"empno"),iv_pbtag,iv_pstag,iv_workym) 
END IF

end event

type rr_1 from roundrectangle within w_pip1006
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 297
integer y = 20
integer width = 2578
integer height = 244
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip1006
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 306
integer y = 360
integer width = 2034
integer height = 1860
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pip1006
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2473
integer y = 360
integer width = 1769
integer height = 1860
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_2 from line within w_pip1006
integer linethickness = 1
integer beginx = 1179
integer beginy = 132
integer endx = 1673
integer endy = 132
end type

type ln_3 from line within w_pip1006
integer linethickness = 1
integer beginx = 640
integer beginy = 224
integer endx = 923
integer endy = 224
end type

