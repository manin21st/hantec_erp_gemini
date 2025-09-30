$PBExportHeader$w_pif1001.srw
$PBExportComments$** 인사코드 등록
forward
global type w_pif1001 from w_inherite_multi
end type
type ddlb_1 from dropdownlistbox within w_pif1001
end type
type gb_5 from groupbox within w_pif1001
end type
type rb_1 from radiobutton within w_pif1001
end type
type rb_2 from radiobutton within w_pif1001
end type
type dw_main from u_key_enter within w_pif1001
end type
type cb_updept from commandbutton within w_pif1001
end type
type st_5 from statictext within w_pif1001
end type
type dw_ip from datawindow within w_pif1001
end type
type gb_6 from groupbox within w_pif1001
end type
type rr_1 from roundrectangle within w_pif1001
end type
type rr_2 from roundrectangle within w_pif1001
end type
type rr_3 from roundrectangle within w_pif1001
end type
end forward

global type w_pif1001 from w_inherite_multi
string title = "인사코드 등록"
ddlb_1 ddlb_1
gb_5 gb_5
rb_1 rb_1
rb_2 rb_2
dw_main dw_main
cb_updept cb_updept
st_5 st_5
dw_ip dw_ip
gb_6 gb_6
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_pif1001 w_pif1001

type prototypes

end prototypes

type variables
Integer li_sts
end variables

forward prototypes
public function integer wf_requiredchk (string as_codename, integer ll_row)
public subroutine wf_change_flag ()
public subroutine wf_dw_change (string as_dwname, string as_codelen)
end prototypes

public function integer wf_requiredchk (string as_codename, integer ll_row);String scode,sname,updept ,seiscode
long dept_level

dw_main.AcceptText()

scode = dw_main.GetItemString(ll_row,1)
sname = dw_main.GetItemString(ll_row,2)

IF scode = "" OR IsNull(scode) THEN
	MessageBox("확 인",as_codename+"코드를 입력하세요!!")
	dw_main.SetColumn(1)
	dw_main.SetFocus()
	Return -1
END IF

IF sname = "" OR IsNull(sname) THEN
	MessageBox("확 인",as_codename+"명칭을 입력하세요!!")
	dw_main.SetColumn(2)
	dw_main.SetFocus()
	Return -1
END IF

//부서 필수입력CHECK
IF dw_main.DataObject = "d_pif1001_8" THEN
//상위부서 
//	updept = dw_main.GetItemString(ll_row,"updept")
//
//	IF updept ="" OR IsNull(updept) THEN 	
//		MessageBox("확 인","상위부서를 입력하세요!!")
//		dw_main.SetColumn("updept")
//		dw_main.SetFocus()
//		Return -1	
//	END IF
	
//부서 레벨

END IF

Return 1
end function

public subroutine wf_change_flag ();
Integer k,iCount

iCount = dw_main.RowCount()

FOR k = 1 TO iCount
	dw_main.SetItem(k,"flag",'0')
NEXT
end subroutine

public subroutine wf_dw_change (string as_dwname, string as_codelen);If dw_main.dataobject <> as_dwname then
	If dw_main.AcceptText() = 1 Then
		If ib_any_typing = True Then
			IF MessageBox("확 인","저장하지 않은 자료가 존재합니다. 저장하시겠습니까?",Question!,YesNo!) = 2 THEN 
			ELSE
				p_mod.TriggerEvent(Clicked!)
				
				IF ib_any_typing = True THEN RETURN
				
			END IF
		end if
	end if
	dw_main.dataobject = as_dwname
	
	dw_main.settransobject(sqlca)
   dw_main.Reset()
	
	dw_ip.SetItem(dw_ip.GetRow(),"codelen",as_codelen)
	p_inq.triggerevent(Clicked!)
end if
end subroutine

on w_pif1001.create
int iCurrent
call super::create
this.ddlb_1=create ddlb_1
this.gb_5=create gb_5
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_main=create dw_main
this.cb_updept=create cb_updept
this.st_5=create st_5
this.dw_ip=create dw_ip
this.gb_6=create gb_6
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_1
this.Control[iCurrent+2]=this.gb_5
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.dw_main
this.Control[iCurrent+6]=this.cb_updept
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.dw_ip
this.Control[iCurrent+9]=this.gb_6
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.rr_2
this.Control[iCurrent+12]=this.rr_3
end on

on w_pif1001.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_1)
destroy(this.gb_5)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_main)
destroy(this.cb_updept)
destroy(this.st_5)
destroy(this.dw_ip)
destroy(this.gb_6)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_main.SetTransObject(SQLCA)
dw_main.Reset()

ddlb_1.selectitem("부서",1)
ddlb_1.triggerevent(selectionchanged!)

//p_mod.enabled = False
//p_mod.Picturename = "C:\erpman\image\저장_d.gif"
end event

type p_delrow from w_inherite_multi`p_delrow within w_pif1001
boolean visible = false
integer x = 4279
integer y = 2716
end type

type p_addrow from w_inherite_multi`p_addrow within w_pif1001
boolean visible = false
integer x = 4105
integer y = 2716
end type

type p_search from w_inherite_multi`p_search within w_pif1001
boolean visible = false
integer x = 3410
integer y = 2716
end type

type p_ins from w_inherite_multi`p_ins within w_pif1001
integer x = 3703
end type

event p_ins::clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_main.RowCount() <=0 THEN
	il_currow = 1
	il_functionvalue =1
ELSE
	il_functionvalue = wf_requiredchk(ddlb_1.text,dw_main.GetRow())
	
	il_currow = dw_main.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow
	
	dw_main.InsertRow(il_currow)
	dw_main.Setitem(il_currow, "flag", '1') 
	dw_main.ScrollToRow(il_currow)
	IF dw_main.dataobject = "d_pif1001_8"  OR dw_main.dataobject = "d_pif1001_48"  THEN
		dw_main.Setitem(il_currow, "companycode", gs_company)
	END IF
	dw_main.setcolumn(1)
	dw_main.SetFocus()
END IF

w_mdi_frame.sle_msg.text = "새로운 자료를 입력하십시요!!"
end event

type p_exit from w_inherite_multi`p_exit within w_pif1001
integer x = 4398
end type

type p_can from w_inherite_multi`p_can within w_pif1001
integer x = 4224
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text = ''

p_inq.TriggerEvent(Clicked!)
end event

type p_print from w_inherite_multi`p_print within w_pif1001
boolean visible = false
integer x = 3584
integer y = 2716
end type

type p_inq from w_inherite_multi`p_inq within w_pif1001
integer x = 3529
end type

event p_inq::clicked;call super::clicked;
dw_main.SetRedraw(False)
if dw_main.dataobject = "d_pif1001_8" then
	dw_main.Retrieve(gs_company)
else		   
	dw_main.Retrieve()
end if

if dw_main.dataobject <> "d_pif1001_8" then
    rb_1.triggerevent(clicked!)
end if	 
dw_main.ScrollToRow(dw_main.RowCount())
dw_main.SetRedraw(True)

IF dw_main.RowCount() <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	p_ins.SetFocus()
	Return
END IF

ib_any_typing = False
end event

type p_del from w_inherite_multi`p_del within w_pif1001
integer x = 4050
end type

event p_del::clicked;call super::clicked;Int il_currow

il_currow = dw_main.GetRow()
IF il_currow <=0 Then Return

IF	 MessageBox("삭제 확인", "삭제하시겠습니까? ", question!, yesno!) = 2	THEN return
	
dw_main.DeleteRow(il_currow)

IF dw_main.Update() > 0 THEN
	commit;
	IF il_currow = 1 OR il_currow <= dw_main.RowCount() THEN
	ELSE
		dw_main.ScrollToRow(il_currow - 1)
		dw_main.SetColumn(1)
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

type p_mod from w_inherite_multi`p_mod within w_pif1001
integer x = 3877
end type

event p_mod::clicked;call super::clicked;IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_requiredchk(ddlb_1.text,dw_main.GetRow()) = -1 THEN RETURN
END IF

///////////////////////////////////////////////////////////////////////////////////

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

Wf_Change_Flag()

IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	f_rollback()
	ib_any_typing = True
	Return
END IF

dw_main.Setfocus()
if dw_main.dataobject <> "d_pif1001_8" then
    rb_1.triggerevent(clicked!)
else
	p_inq.triggerevent(clicked!)
end if	
dw_main.ScrollToRow(dw_main.RowCount())

end event

type dw_insert from w_inherite_multi`dw_insert within w_pif1001
boolean visible = false
integer x = 823
integer y = 2672
end type

type st_window from w_inherite_multi`st_window within w_pif1001
boolean visible = false
integer y = 2856
end type

type cb_append from w_inherite_multi`cb_append within w_pif1001
boolean visible = false
integer x = 631
integer y = 2672
integer width = 338
integer taborder = 40
end type

event cb_append::clicked;call super::clicked;
Int il_currow,il_functionvalue

IF dw_main.RowCount() <=0 THEN
	il_currow = 0
	il_functionvalue =1
ELSE
	il_functionvalue = wf_requiredchk(ddlb_1.text,dw_main.GetRow())
	
	il_currow = dw_main.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow + 1
	
	dw_main.InsertRow(il_currow)
	dw_main.Setitem(il_currow, "flag", '1') 
	dw_main.ScrollToRow(il_currow)
	IF dw_main.dataobject = "d_pif1001_8"  OR dw_main.dataobject = "d_pif1001_48"THEN
		dw_main.Setitem(il_currow, "companycode", gs_company)
	END IF
	
	dw_main.setcolumn(1)
	dw_main.SetFocus()
END IF
sle_msg.text = "새로운 자료를 입력하십시요!!"






end event

type cb_exit from w_inherite_multi`cb_exit within w_pif1001
boolean visible = false
integer x = 3319
integer y = 2672
integer taborder = 90
end type

event cb_exit::clicked;close(parent)
end event

type cb_update from w_inherite_multi`cb_update within w_pif1001
boolean visible = false
integer x = 2222
integer y = 2672
integer taborder = 60
end type

event cb_update::clicked;call super::clicked;IF dw_main.Accepttext() = -1 THEN 	RETURN

IF dw_main.RowCount() > 0 THEN
	IF wf_requiredchk(ddlb_1.text,dw_main.GetRow()) = -1 THEN RETURN
END IF

///////////////////////////////////////////////////////////////////////////////////

IF MessageBox("확인", "저장하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

Wf_Change_Flag()

IF dw_main.Update() > 0 THEN			
	COMMIT USING sqlca;
	ib_any_typing =False
	sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	f_rollback()
	ib_any_typing = True
	Return
END IF

dw_main.Setfocus()
rb_1.triggerevent(clicked!)
dw_main.ScrollToRow(dw_main.RowCount())

end event

type cb_insert from w_inherite_multi`cb_insert within w_pif1001
boolean visible = false
integer x = 997
integer y = 2672
integer taborder = 50
end type

event cb_insert::clicked;call super::clicked;Int il_currow,il_functionvalue

IF dw_main.RowCount() <=0 THEN
	il_currow = 1
	il_functionvalue =1
ELSE
	il_functionvalue = wf_requiredchk(ddlb_1.text,dw_main.GetRow())
	
	il_currow = dw_main.GetRow() 
END IF

IF il_functionvalue = 1 THEN
	il_currow = il_currow
	
	dw_main.InsertRow(il_currow)
	dw_main.Setitem(il_currow, "flag", '1') 
	dw_main.ScrollToRow(il_currow)
	IF dw_main.dataobject = "d_pif1001_8"  OR dw_main.dataobject = "d_pif1001_48"  THEN
		dw_main.Setitem(il_currow, "companycode", gs_company)
	END IF
	dw_main.setcolumn(1)
	dw_main.SetFocus()
END IF

sle_msg.text = "새로운 자료를 입력하십시요!!"
end event

type cb_delete from w_inherite_multi`cb_delete within w_pif1001
boolean visible = false
integer x = 2587
integer y = 2672
integer taborder = 70
end type

type cb_retrieve from w_inherite_multi`cb_retrieve within w_pif1001
boolean visible = false
integer x = 265
integer y = 2672
integer taborder = 30
end type

event cb_retrieve::clicked;call super::clicked;
dw_main.SetRedraw(False)
if dw_main.dataobject = "d_pif1001_8" then
	dw_main.Retrieve(gs_company)
else		   
	dw_main.Retrieve()
end if

rb_1.triggerevent(clicked!)
dw_main.ScrollToRow(dw_main.RowCount())
dw_main.SetRedraw(True)

IF dw_main.RowCount() <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	p_ins.SetFocus()
	Return
END IF

end event

type st_1 from w_inherite_multi`st_1 within w_pif1001
boolean visible = false
integer y = 2856
end type

type cb_cancel from w_inherite_multi`cb_cancel within w_pif1001
boolean visible = false
integer x = 2953
integer y = 2672
integer taborder = 80
end type

type dw_datetime from w_inherite_multi`dw_datetime within w_pif1001
boolean visible = false
integer y = 2856
end type

type sle_msg from w_inherite_multi`sle_msg within w_pif1001
boolean visible = false
integer y = 2856
end type

type gb_2 from w_inherite_multi`gb_2 within w_pif1001
boolean visible = false
integer x = 2185
integer y = 2612
integer width = 1504
end type

type gb_1 from w_inherite_multi`gb_1 within w_pif1001
boolean visible = false
integer x = 219
integer y = 2612
end type

type gb_10 from w_inherite_multi`gb_10 within w_pif1001
boolean visible = false
integer y = 2804
end type

type ddlb_1 from dropdownlistbox within w_pif1001
event selectionchanged pbm_cbnselchange
integer x = 59
integer y = 156
integer width = 571
integer height = 2124
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean allowedit = true
boolean border = false
boolean showlist = true
boolean vscrollbar = true
string item[] = {"병과","근태","은행","계급","본적","직무","교육","채용","관계","직급","직책","면허","전공","발령","관계처","상벌","저축","학교","학력","외국어","외국어자격","직위","부서","동호회","휴일구분","외국어평가방법","사업장","교육기관","면허등급","우편번호","근무구분","근무일구분"}
end type

event selectionchanged;string ls_sel_text

// iv_sel_text 에는 ddlb_1(DropDownListBox type)에 
//   현재 들어있는 data(string)가 들어가게 된다.

ls_sel_text = trim(ddlb_1.text)

choose case ls_sel_text
	case "관계처"
		wf_dw_change("d_pif1001_1","6")
		li_sts = 1
	case "직무"
		wf_dw_change("d_pif1001_11","2")
		li_sts = 2
	case "교육"
		wf_dw_change("d_pif1001_12","4")
		li_sts = 3
	case "채용"
		wf_dw_change("d_pif1001_13","2")
		li_sts = 4
	case "직위"
		wf_dw_change("d_pif1001_14","2")
		li_sts = 5
	case "직책"
		wf_dw_change("d_pif1001_15","2")
		li_sts = 6
	case "면허"
		wf_dw_change("d_pif1001_16","4")
		li_sts = 7
	case "외국어"
		wf_dw_change("d_pif1001_17","1")
		li_sts = 8
	case "전공"
		wf_dw_change("d_pif1001_18","3")
		li_sts = 9
	case "발령"
		wf_dw_change("d_pif1001_19","3")
		li_sts = 10
	case "병과"
		wf_dw_change("d_pif1001_2","2")
		li_sts = 11
	case "관계"
		wf_dw_change("d_pif1001_20","2")
		li_sts = 12
	case "상벌"
		wf_dw_change("d_pif1001_23","2")
		li_sts = 13
	case "저축"
		wf_dw_change("d_pif1001_24","2")
		li_sts = 14
	case "학교"
		wf_dw_change("d_pif1001_25","5")
		li_sts = 15
	case "학력"
		wf_dw_change("d_pif1001_26","1")
		li_sts = 16
	case "직급"
		wf_dw_change("d_pif1001_29","2")
		li_sts = 18
	case "외국어자격"
		wf_dw_change("d_pif1001_30","1")
		li_sts = 19
	case "동호회"
		wf_dw_change("d_pif1001_31","2")
		li_sts = 20
	case "근태"
		wf_dw_change("d_pif1001_4","2")		
		li_sts = 21
	case "근무일구분"
		wf_dw_change("d_pif1001_41","1")	
		li_sts = 22
	case "요일구분"
		wf_dw_change("d_pif1001_42","1")	
		li_sts = 23
	case "휴일구분"
		wf_dw_change("d_pif1001_43","1")	
		li_sts = 24
	case "은행"
		wf_dw_change("d_pif1001_5","6")
		li_sts = 25
	case "본적"
		wf_dw_change("d_pif1001_6","2")
		li_sts = 26
	case "계급"
		wf_dw_change("d_pif1001_7","2")
		li_sts = 27
	case "부서"     
		wf_dw_change("d_pif1001_8","6")
		li_sts = 28
//	case "거주자(소득)"
//		wf_dw_change("d_pif1001_10", "2")
//		li_sts = 29
//	case "비거주자(소득)"
//		wf_dw_change("d_pif1001_32", "2")
//		li_sts = 30
   case "근무구분"
		wf_dw_change("d_pif1001_44", "2")
		li_sts = 31
	case "외국어평가방법"
		wf_dw_change("d_pif1001_45", "2")
		li_sts = 32		
	case "개인지급품목"
		wf_dw_change("d_pif1001_46", "4")
		li_sts = 33		
	case "개인지급품SIZE"
		wf_dw_change("d_pif1001_47", "2")
		li_sts = 34	
	case "표준근무일구분"
		wf_dw_change("d_pif1001_27", "1")
		li_sts = 35	
	case "사업장"
		wf_dw_change("d_pif1001_48", "2")
		li_sts = 36	
	CASE "교육기관"
		wf_dw_change("d_pif1001_49", "6")
		li_sts = 37	
	CASE "면허등급"
		wf_dw_change("d_pif1001_50", "2")
		li_sts = 38		
	CASE "우편번호"
		wf_dw_change("d_pif1001_51", "6")
		li_sts = 39		
//	CASE "부문"
//		wf_dw_change("d_pif1001_52", "6")
//		li_sts = 40				
	
end choose

//SetNull(sle_find.text)
dw_ip.SetItem(dw_ip.Getrow(),"find","")

//IF dw_main.DataObject = 'd_pif1001_8' THEN
//	p_mod.enabled = True
//	p_mod.Picturename = "C:\erpman\image\저장_up.gif"
//ELSE
//	p_mod.enabled = False
//	p_mod.Picturename = "C:\erpman\image\저장_d.gif"
//END IF

rb_1.Checked = True
rb_2.Checked = False
end event

type gb_5 from groupbox within w_pif1001
integer x = 2382
integer y = 72
integer width = 768
integer height = 180
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "찾기선택 및 정렬"
end type

type rb_1 from radiobutton within w_pif1001
event clicked pbm_bnclicked
integer x = 2469
integer y = 140
integer width = 256
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "코드"
boolean checked = true
end type

event clicked;dw_main.setsort("#1 A")
dw_main.sort()
end event

type rb_2 from radiobutton within w_pif1001
event clicked pbm_bnclicked
integer x = 2866
integer y = 140
integer width = 256
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "명칭"
end type

event clicked;dw_main.setsort("#2 A")
dw_main.sort()
end event

type dw_main from u_key_enter within w_pif1001
event ue_key pbm_dwnkey
integer x = 709
integer y = 320
integer width = 3799
integer height = 1964
integer taborder = 10
string dataobject = "d_pif1001_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_main.scrollpriorpage()
	case keypagedown!
		dw_main.scrollnextpage()
	case keyhome!
		dw_main.scrolltorow(1)
	case keyend!
		dw_main.scrolltorow(dw_main.rowcount())
	case keyF1!
		triggerevent(rbuttondown!)
end choose
end event

event editchanged;call super::editchanged;ib_any_typing =True
end event

event itemchanged;string sCode,sFindCol,snull,sname , seiscode
Int lReturnRow,lRow

SetNull(snull)

dw_main.setredraw(false)

IF this.GetColumn() =1 THEN
	
	lRow = this.GetRow()
	sFindCol = "#1"
	sCode = this.GetText()
	
	lReturnRow = dw_main.find("lower(" + sFindCol + ") = ~"" + lower(sCode) + "~"", 1, dw_main.rowcount())

	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
	
		MessageBox("확인","등록된" + ddlb_1.text +"코드입니다.~r등록할 수 없습니다.")
		this.SetItem(lRow, 1, sNull)
		this.SetItem(lRow, 2, sNull)
		dw_main.setredraw(True)
		RETURN  1
	END IF
END IF
IF this.DataObject = "d_pif1001_8" AND this.GetColumnName() ="deptcode" THEN
	lRow = this.GetRow()
	scode = this.GetText()
	
	IF scode ="" OR IsNull(scode) THEN 
	ELSE
		this.SetItem(lRow,"projectcode",scode)
	END IF
END IF
IF this.DataObject = "d_pif1001_8" AND this.GetColumnName() ="deptname" THEN
	lRow = this.GetRow()
	scode = this.GetText()
	
	IF scode ="" OR IsNull(scode) THEN 
	ELSE
		this.SetItem(lRow,"deptname2",scode)
	END IF
END IF
//상위부서 CHECK
IF this.DataObject = "d_pif1001_8" AND this.GetColumnName() ="updept" THEN
	lRow = this.GetRow()
	scode = this.GetText()
	
	IF scode ="" OR IsNull(scode) THEN 
	ELSE
		  SELECT "P0_DEPT"."DEPTNAME2"  
    		 INTO :sname  
		    FROM "P0_DEPT"  
		   WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
               ( "P0_DEPT"."DEPTCODE" = :scode )   ;

			IF SQLCA.SQLCODE <> 0 THEN
				MessageBox("확 인","등록된 부서코드가 아닙니다. 확인하세요!!")
				this.SetItem(lRow,"updept",snull)
				this.SetFocus()
				dw_main.setredraw(TRUE)
				Return 1	
			END IF
	END IF
END IF

//사업장 CHECK
IF this.DataObject = "d_pif1001_8" AND this.GetColumnName() ="saupcd" THEN
	lRow = this.GetRow()
	scode = this.GetText()
	
	IF scode ="" OR IsNull(scode) THEN 
	ELSE
		 SELECT "P0_SAUPCD"."SAUPNAME"  
	      INTO :sname  
    		FROM "P0_SAUPCD"  
		   WHERE ( "P0_SAUPCD"."COMPANYCODE" = :gs_company ) AND  
      		   ( "P0_SAUPCD"."SAUPCODE" = :scode )   ;

			IF SQLCA.SQLCODE <> 0 THEN
				MessageBox("확 인","등록된 사업장코드가 아닙니다. 확인하세요!!")
				this.SetItem(lRow,"saupcd",snull)
				this.SetFocus()
				dw_main.setredraw(TRUE)
				Return 1	
			END IF
	END IF
END IF

String sKunmuGbn,sKunMuName

IF this.DataObject = "d_pif1001_27" AND this.GetColumnName() = "stmonday" THEN
	
	lRow = this.GetRow()
	this.AcceptText()
	sKunmuGbn =this.GetItemString(lRow,"stmonday")
	
	SELECT "P0_KUNMUIL"."KMNAME"  
     INTO :sKunMuName  
    	FROM "P0_KUNMUIL"  
   	WHERE "P0_KUNMUIL"."KMGUBN" = :sKunMuGbn   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 근무일구분이 아닙니다. 확인하세요!!")
		this.SetItem(lRow,"stmonday",snull)
		this.SetFocus()
		dw_main.setredraw(TRUE)
		Return 1
	END IF
END IF

IF this.DataObject = "d_pif1001_27" AND this.GetColumnName() = "sttuesday" THEN

	lRow = this.GetRow()
	this.AcceptText()
	sKunmuGbn =this.GetItemString(lRow,"sttuesday")
	
	SELECT "P0_KUNMUIL"."KMNAME"  
     INTO :sKunMuName  
    	FROM "P0_KUNMUIL"  
   	WHERE "P0_KUNMUIL"."KMGUBN" = :sKunMuGbn   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 근무일구분이 아닙니다. 확인하세요!!")
		this.SetItem(lRow,"sttuesday",snull)
		this.SetFocus()
		dw_main.setredraw(TRUE)
		Return 1
	END IF
END IF

IF this.DataObject = "d_pif1001_27" AND this.GetColumnName() = "stwednesday" THEN

	lRow = this.GetRow()
	this.AcceptText()
	sKunmuGbn =this.GetItemString(lRow,"stwednesday")
	
	SELECT "P0_KUNMUIL"."KMNAME"  
     INTO :sKunMuName  
     FROM "P0_KUNMUIL"  
    WHERE "P0_KUNMUIL"."KMGUBN" = :sKunMuGbn   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 근무일구분이 아닙니다. 확인하세요!!")
		this.SetItem(lRow,"stwednesday",snull)
		this.SetFocus()
		dw_main.setredraw(TRUE)
		Return 1
	END IF
END IF

IF this.DataObject = "d_pif1001_27" AND this.GetColumnName() = "stthursday" THEN
	
	lRow = this.GetRow()
	this.AcceptText()
	sKunmuGbn =this.GetItemString(lRow,"stthursday")
	
	SELECT "P0_KUNMUIL"."KMNAME"  
     INTO :sKunMuName  
     FROM "P0_KUNMUIL"  
    WHERE "P0_KUNMUIL"."KMGUBN" = :sKunMuGbn   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 근무일구분이 아닙니다. 확인하세요!!")
		this.SetItem(lRow,"stthursday",snull)
		this.SetFocus()
		dw_main.setredraw(TRUE)
		Return 1
	END IF
END IF

IF this.DataObject = "d_pif1001_27" AND this.GetColumnName() = "stfirday" THEN
	
	lRow = this.GetRow()
	this.AcceptText()
	sKunmuGbn =this.GetItemString(lRow,"stfirday")

	SELECT "P0_KUNMUIL"."KMNAME"  
     INTO :sKunMuName  
     FROM "P0_KUNMUIL"  
    WHERE "P0_KUNMUIL"."KMGUBN" = :sKunMuGbn   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 근무일구분이 아닙니다. 확인하세요!!")
		this.SetItem(lRow,"stfirday",snull)
		this.SetFocus()
		dw_main.setredraw(TRUE)
		Return 1
	END IF
END IF

IF this.DataObject = "d_pif1001_27" AND this.GetColumnName() = "stsaturday" THEN

	lRow = this.GetRow()
	this.AcceptText()
	sKunmuGbn =this.GetItemString(lRow,"stsaturday")

   SELECT "P0_KUNMUIL"."KMNAME"  
     INTO :sKunMuName  
     FROM "P0_KUNMUIL"  
    WHERE "P0_KUNMUIL"."KMGUBN" = :sKunMuGbn   ;
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox("확 인","등록된 근무일구분이 아닙니다. 확인하세요!!")
		this.SetItem(lRow,"stsaturday",snull)
		this.SetFocus()
		dw_main.setredraw(TRUE)
		Return 1
	END IF

END IF

IF this.GetColumnName() = "eiscode" THEN   /* Eis 코드 */
	IF this.DataObject = "d_pif1001_8" THEN  /*부서*/
		lRow = this.GetRow()
		this.AcceptText()
		seiscode =this.GetItemString(lRow,"eiscode")
		SELECT "EIS020T"."RFGUB"  	INTO :seiscode  
		 FROM "EIS020T" 
		 where ( "EIS020T"."RFCOD" = 'C2' ) AND  
             ( "EIS020T"."RFGUB" = :seiscode )   ;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("확 인","등록된 Eis코드가 아닙니다. 확인하세요!!")
			this.SetItem(lRow,"eiscode",snull)
			this.SetFocus()
			dw_main.setredraw(TRUE)
			Return 1
		END IF
	END IF
	IF this.DataObject = "d_pif1001_29" THEN  /*직급*/
		lRow = this.GetRow()
		this.AcceptText()
		seiscode =this.GetItemString(lRow,"eiscode")
		SELECT "EIS020T"."RFGUB"  	INTO :seiscode  
		 FROM "EIS020T"  
	    WHERE ( "EIS020T"."RFCOD" = 'C3' ) AND  
             ( "EIS020T"."RFGUB" = :seiscode )   ;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("확 인","등록된 Eis코드가 아닙니다. 확인하세요!!")
			this.SetItem(lRow,"eiscode",snull)
			this.SetFocus()
			dw_main.setredraw(TRUE)
			Return 1
		END IF
	END IF
	
	IF this.DataObject = "d_pif1001_11" THEN  /*직무*/
		lRow = this.GetRow()
		this.AcceptText()
		seiscode =this.GetItemString(lRow,"eiscode")
		SELECT "EIS020T"."RFGUB"  	INTO :seiscode  
		 FROM "EIS020T"  
	    WHERE ( "EIS020T"."RFCOD" = 'C4' ) AND  
             ( "EIS020T"."RFGUB" = :seiscode )   ;

		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox("확 인","등록된 Eis코드가 아닙니다. 확인하세요!!")
			this.SetItem(lRow,"eiscode",snull)
			this.SetFocus()
			dw_main.setredraw(TRUE)
			Return 1
		END IF
	END IF

END IF

dw_main.setredraw(True)
	
end event

event itemfocuschanged;call super::itemfocuschanged;if this.dataobject = "d_pif1001_8" then
  	// dw 가 "부서코드" 이거나 "동호회 코드" 이면
	
	choose case getcolumn()
		case 2, 3									//---> Column No.
			f_toggle_kor(handle(parent))		//---> 한글 입력모드로
		case else									//---> Column No.
			f_toggle_eng(handle(parent))		//---> 영문입력 모드로
	end choose
else
	choose case getcolumn()
		case 2										//---> Column No.
			f_toggle_kor(handle(parent))		//---> 한글 입력모드로
		case else									//---> Column No.
			f_toggle_eng(handle(parent))		//---> 영문입력 모드로
	end choose
end if
end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;//this.SetRowFocusIndicator(Hand!)
this.SelectRow(0,false)	
this.SelectRow(currentrow,true)
  
end event

event rbuttondown;

IF this.getcolumnname() = "empno" THEN
	//Gs_Code = this.GetItemString(this.GetRow(),"EMPNO")
   SetNull(Gs_code)
	SetNull(gs_codename)
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"empno",Gs_code)
END IF

IF this.getcolumnname() = "kuntaeempno" THEN
	//Gs_Code = this.GetItemString(this.GetRow(),"KUNTAEEMPNO")
   SetNull(Gs_code)
	SetNull(gs_codename)
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"kuntaeempno",Gs_code)
END IF

IF this.GetColumnName() ="zipcode" THEN
	
	Open(w_zip_popup)
	
	IF IsNull(Gs_Code) THEN RETURN

	this.SetItem(this.GetRow(),"zipcode", Gs_code)
	this.SetItem(this.GetRow(),"addr",Gs_codename)

	this.SetColumn("addr")
	this.SetFocus()
END IF

end event

event clicked;call super::clicked;this.event Rowfocuschanged(row)
end event

type cb_updept from commandbutton within w_pif1001
boolean visible = false
integer x = 1367
integer y = 2592
integer width = 553
integer height = 108
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "부서배열조정(&C)"
end type

event clicked;String ls_deptcode,ls_UpDept, ls_flag,ls_Saupj,sUpDeptCode[],ls_CurDept
Long   lLevel,i

/*--- 기존자료 삭제처리 ----*/
DELETE FROM "P0_UPDEPT"  ;
COMMIT;

/*--- 자료생성처리 ---*/
ls_flag = 'Y'

DECLARE dept_cur CURSOR FOR  
	SELECT "P0_DEPT"."DEPTCODE", 
			 "P0_DEPT"."UPDEPT",
          "P0_DEPT"."SAUPCD",   
          "P0_DEPT"."DEPT_LEVEL"  
   FROM "P0_DEPT"  
   WHERE ( "P0_DEPT"."COMPANYCODE" = 'GR' ) AND  
         ( "P0_DEPT"."DEPT_LEVEL" <> 1 )   ;

sle_msg.text = '부서 배열 조정 중......'
SetPointer(HourGlass!)

OPEN dept_cur ;
Do WHILE ls_flag = 'Y'
	FETCH dept_cur into :ls_DeptCode,	:ls_UpDept,		:ls_Saupj,	 :lLevel ;
	IF SQLCA.SQLCODE = 100 OR SQLCA.SQLCODE = -1 then
		ls_flag = 'N'
		EXIT
	END IF

	FOR i=1 TO 6
		sUpDeptCode[i] = ''
	NEXT
	
	i = 1
	sUpDeptCode[1] = ls_DeptCode
	ls_CurDept = ls_DeptCode

	Do while ls_CurDept <> '' and ls_CurDept <> '     ' and Not ISNULL(ls_CurDept)
		SELECT "P0_DEPT"."UPDEPT"  
			INTO :ls_UpDept
		   FROM "P0_DEPT"  
   		WHERE ( "P0_DEPT"."COMPANYCODE" = 'GR' ) AND  
         		( "P0_DEPT"."DEPTCODE" = :ls_CurDept )   ;

      IF SQLCA.SQLCODE = 0 THEN
			i += 1
			sUpDeptCode[i] = ls_UpDept
			ls_CurDept = ls_UpDept
		ELSE
			ls_CurDept = ''
		END IF
   Loop
	
	INSERT INTO "P0_UPDEPT"  
   	( "COMPAYCODE",   		 "DEPT1",	   		"DEPT2",   			 "DEPT3",   
		  "DEPT4",   				 "DEPT5",   			"DEPT6",   		 	 "DEPT_LEVLEL" )  
	VALUES ( :gs_company,		 :sUpDeptCode[1],		:sUpDeptCode[2],   :sUpDeptCode[3],   
            :sUpDeptCode[4],   :sUpDeptCode[5],   	:sUpDeptCode[6],   :lLevel )  ;

Loop
close dept_cur ;
COMMIT;

sle_msg.text = '부서 배열 조정 완료'
SetPointer(Arrow!)
end event

type st_5 from statictext within w_pif1001
integer x = 64
integer y = 92
integer width = 457
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "인사코드 항목"
boolean focusrectangle = false
end type

type dw_ip from datawindow within w_pif1001
integer x = 786
integer y = 120
integer width = 1518
integer height = 96
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_pif1001_9"
boolean border = false
boolean livescroll = true
end type

event getfocus;
if rb_1.checked = True then              // "코드" 이면
	f_toggle_eng(handle(parent))		//---> 영문입력 모드로
else
	f_toggle_kor(handle(parent))		//---> 한글 입력모드로
end if
end event

event itemchanged;string ls_findcol
long ll_findrow, ll_row

AcceptText()

ll_row = GetRow()
if len(GetText()) < 1 then return

dw_main.SetRedraw(False)
if rb_1.checked = True then
	ls_findcol = "#1"
else
	ls_findcol = "#2"
end if

// 대소문자 구별없이 자료를 찾는다 
ll_findrow = dw_main.find("lower(" + ls_findcol + ")>=~"" + lower(GetItemString(ll_row,"find")) + "~"", 1, dw_main.rowcount())

if ll_findrow > 0 then
	dw_main.scrolltorow(ll_findrow)
	dw_main.SelectRow(0,false)	
	dw_main.SelectRow(ll_findrow,true)
else
	messagebox("자료 확인", "해당 자료가 없습니다.!", information!)
	SetRow(ll_row)
	return
end if

dw_main.SetRedraw(True)
end event

type gb_6 from groupbox within w_pif1001
boolean visible = false
integer x = 1317
integer y = 2532
integer width = 658
integer height = 200
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type rr_1 from roundrectangle within w_pif1001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 40
integer width = 622
integer height = 2264
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pif1001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 686
integer y = 44
integer width = 2505
integer height = 244
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pif1001
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 690
integer y = 304
integer width = 3835
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

