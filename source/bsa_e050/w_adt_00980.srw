$PBExportHeader$w_adt_00980.srw
$PBExportComments$거래처별 환율등록
forward
global type w_adt_00980 from w_inherite
end type
type gb_3 from groupbox within w_adt_00980
end type
type gb_2 from groupbox within w_adt_00980
end type
type gb_1 from groupbox within w_adt_00980
end type
type dw_ip from u_key_enter within w_adt_00980
end type
type rr_1 from roundrectangle within w_adt_00980
end type
end forward

global type w_adt_00980 from w_inherite
string title = "거래처별 환율등록"
gb_3 gb_3
gb_2 gb_2
gb_1 gb_1
dw_ip dw_ip
rr_1 rr_1
end type
global w_adt_00980 w_adt_00980

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();string ls_yymm, ls_curr, ls_cvcod
//필수입력항목 체크
if dw_ip.AcceptText() = -1 then
	return -1
end if	

if dw_insert.AcceptText() = -1 then
	return -1
end if	

//조회조건
ls_yymm  = Trim(dw_ip.GetItemString(1, 'yyyymm'))
ls_curr  = Trim(dw_ip.GetItemString(1, 'ratunit'))
ls_cvcod = Trim(dw_ip.GetItemString(1, 'cvcod'))

//조건체크
if IsNull(ls_yymm) or ls_yymm = "" then
	MessageBox("확인","기준년월을 입력하세요!")
	dw_ip.SetColumn('yyyymm')
	dw_ip.SetFocus()
	return -1
else
	ls_yymm = ls_yymm + '%'
end if
if IsNull(ls_curr) or ls_curr = "" then
	MessageBox("확인","통화단위를 선택하세요!")
	dw_ip.SetColumn('ratunit')
	dw_ip.SetFocus()
	return -1
end if
if IsNull(ls_cvcod) or ls_cvcod = "" then
	MessageBox("확인","거래처코드를 입력하세요!")
	dw_ip.SetColumn('cvcod')
	dw_ip.SetFocus()
	return -1
end if
	
if dw_insert.RowCount() <= 0 then
	MessageBox("자료 확인","저장할 자료가 없습니다!")
	return -1
end if

return 1
end function

on w_adt_00980.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_ip=create dw_ip
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_ip
this.Control[iCurrent+5]=this.rr_1
end on

on w_adt_00980.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_ip)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_ip.Setredraw(False)
dw_ip.ReSet()
dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_ip.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_adt_00980
integer x = 1531
integer y = 412
integer width = 1294
integer height = 1836
integer taborder = 30
string dataobject = "d_adt_00980_02"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::rowfocuschanged;//this.SetRowFocusIndicator(HAND!)
end event

type p_delrow from w_inherite`p_delrow within w_adt_00980
boolean visible = false
integer x = 3689
integer y = 2816
end type

type p_addrow from w_inherite`p_addrow within w_adt_00980
boolean visible = false
integer x = 3515
integer y = 2816
end type

type p_search from w_inherite`p_search within w_adt_00980
boolean visible = false
integer x = 2821
integer y = 2816
end type

type p_ins from w_inherite`p_ins within w_adt_00980
boolean visible = false
integer x = 3342
integer y = 2816
end type

type p_exit from w_inherite`p_exit within w_adt_00980
end type

type p_can from w_inherite`p_can within w_adt_00980
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Setredraw(True)

dw_ip.reset()
dw_ip.insertrow(0)
dw_ip.SetFocus()
w_mdi_frame.sle_msg.Text = "작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_adt_00980
boolean visible = false
integer x = 2994
integer y = 2816
end type

type p_inq from w_inherite`p_inq within w_adt_00980
integer x = 3922
end type

event p_inq::clicked;call super::clicked;String  ls_yymm, ls_curr, ls_cvcod, ls_date
long    ll_row

dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.SetRedraw(True)
	
if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return
end if

//조회조건
ls_yymm  = Trim(dw_ip.GetItemString(1, 'yyyymm'))
ls_curr  = Trim(dw_ip.GetItemString(1, 'ratunit'))
ls_cvcod = Trim(dw_ip.GetItemString(1, 'cvcod'))

//조건체크
if IsNull(ls_yymm) or ls_yymm = "" then
	MessageBox("확인","기준년월을 입력하세요!")
	dw_ip.SetColumn('yyyymm')
	dw_ip.SetFocus()
	return
else
	ls_yymm = ls_yymm + '%'
end if
if IsNull(ls_curr) or ls_curr = "" then
	MessageBox("확인","통화단위를 선택하세요!")
	dw_ip.SetColumn('ratunit')
	dw_ip.SetFocus()
	return
end if
if IsNull(ls_cvcod) or ls_cvcod = "" then
	MessageBox("확인","거래처코드를 입력하세요!")
	dw_ip.SetColumn('cvcod')
	dw_ip.SetFocus()
	return
end if


if dw_insert.Retrieve(ls_yymm, ls_curr, ls_cvcod ) < 1 then
	MessageBox('알림','등록된 자료가 없습니다! 신규로 등록하세요!')
	w_mdi_frame.sle_msg.Text = "등록된 자료가 없습니다! 신규로 등록하세요!"
	
	Declare cur_1 cursor for
		 select cldate from p4_calendar 
		  where companycode ='KN' and cldate like :ls_yymm
		  order by cldate asc;
	
	   Open cur_1;	
		 Do while true
			 fetch cur_1 into :ls_date;
			 if sqlca.sqlcode <> 0 then
				 exit
			 else				
				ll_row = dw_insert.insertrow(0)
				dw_insert.SetItem(ll_row, 'rdate' , ls_date)
				dw_insert.SetItem(ll_row, 'rstan' , 0)
				dw_insert.SetItem(ll_row, 'rcurr' , ls_curr)
				dw_insert.SetItem(ll_row, 'cvcod' , ls_cvcod)
				dw_insert.SetItem(ll_row, 'usdrat', 1)
			 end if
		 Loop		
	    Close cur_1;	
else	
	w_mdi_frame.sle_msg.Text = ""
end if	

dw_insert.SetRow(1)
dw_insert.SetFocus()

end event

type p_del from w_inherite`p_del within w_adt_00980
boolean visible = false
integer x = 3867
integer y = 2816
end type

type p_mod from w_inherite`p_mod within w_adt_00980
integer x = 4096
end type

event p_mod::clicked;call super::clicked;String  ls_yymm, ls_curr, ls_cvcod, ls_date
Long    i
Dec     ld_rate

if f_msg_update() = -1 then return    //저장 Yes/No ?
if wf_required_chk() = -1 then return //필수입력항목 체크 

//조건
ls_yymm  = Trim(dw_ip.GetItemString(1, 'yyyymm'))
ls_curr  = Trim(dw_ip.GetItemString(1, 'ratunit'))
ls_cvcod = Trim(dw_ip.GetItemString(1, 'cvcod'))


for i = 1 to dw_insert.rowcount()
	ld_rate = dw_insert.SetItem(i, 'rcurr' , ls_curr)
	
	dw_insert.GetItemNumber(i,'rstan')	
	dw_insert.SetItem(i, 'cvcod' , ls_cvcod)
	dw_insert.SetItem(i, 'usdrat', 1)	
		
	if IsNull(ld_rate) or ld_rate < 0 or IsNumber(String(ld_rate)) = False  then
		dw_insert.SetItem(i,'rstan', 0)
	end if	
next

if dw_insert.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"	
	ib_any_typing = False     //입력필드 변경여부 No
else
	f_message_chk(32,'[자료저장 실패]') 
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if
 
end event

type cb_exit from w_inherite`cb_exit within w_adt_00980
integer x = 1705
integer y = 3172
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_adt_00980
integer x = 923
integer y = 3172
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;//Long i
//
//if f_msg_update() = -1 then return  //저장 Yes/No ?
//if wf_required_chk() = -1 then return //필수입력항목 체크 
//
//for i = 1 to 12 
//	if IsNull(dw_insert.object.exchrate[i]) or dw_insert.object.exchrate[i] < 0 or &
//	   IsNumber(String(dw_insert.object.exchrate[i])) = False  then
//		dw_insert.object.exchrate[i] = 0
//	end if	
//next
//
//if dw_insert.Update() = 1 then
//	COMMIT;
//	sle_msg.text = "저장 되었습니다!"	
//	ib_any_typing = False //입력필드 변경여부 No
//else
//	f_message_chk(32,'[자료저장 실패]') 
//	ROLLBACK;
//   sle_msg.text = "저장작업 실패 하였습니다!"
//	return 
//end if
// 
end event

type cb_ins from w_inherite`cb_ins within w_adt_00980
integer x = 1097
integer y = 2840
integer taborder = 40
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_adt_00980
integer x = 2423
integer y = 2848
end type

type cb_inq from w_inherite`cb_inq within w_adt_00980
integer x = 498
integer y = 3176
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;//String  yyyy, ratunit
//Integer i
//
//dw_insert.SetRedraw(False)
//dw_insert.ReSet()
//dw_insert.SetRedraw(True)
//	
//if dw_ip.AcceptText() = -1 then
//	dw_ip.SetFocus()
//	return
//end if
//
//yyyy = Trim(dw_ip.object.yyyy[1])
//ratunit = Trim(dw_ip.object.ratunit[1])
//
//if IsNull(yyyy) or yyyy = "" then
//	MessageBox("기준년도 확인","기준년도를 입력하세요!")
//	return -1
//end if
//if IsNull(ratunit) or ratunit = "" then
//	MessageBox("통화단위 확인","통화단위를 선택하세요!")
//	return -1
//end if
//
//if dw_insert.Retrieve(yyyy, ratunit) < 1 then
//	for i = 1 to 12
//		dw_insert.InsertRow(0)			
//	   dw_insert.object.base_yymm[i] = yyyy + String(i,"00")	
//		dw_insert.object.ratunit[i] = ratunit 
//	next
//	sle_msg.Text = "등록된 자료가 없습니다! 신규로 등록하세요!"
//else	
//	sle_msg.Text = ""
//end if	
//
//dw_insert.SetRow(1)
//dw_insert.SetFocus()
//
end event

type cb_print from w_inherite`cb_print within w_adt_00980
integer x = 2048
integer y = 2848
end type

type st_1 from w_inherite`st_1 within w_adt_00980
end type

type cb_can from w_inherite`cb_can within w_adt_00980
integer x = 1280
integer y = 3172
end type

event cb_can::clicked;call super::clicked;//sle_msg.text =""
//IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 
//
//dw_insert.Setredraw(False)
//dw_insert.ReSet()
//dw_insert.Setredraw(True)
//
//dw_ip.object.yyyy[1] = ""
//dw_ip.SetFocus()
//sle_msg.Text = "작업을 취소 하였습니다!"
//ib_any_typing = False //입력필드 변경여부 No
//
//
end event

type cb_search from w_inherite`cb_search within w_adt_00980
integer x = 1545
integer y = 2848
end type





type gb_10 from w_inherite`gb_10 within w_adt_00980
integer x = 174
integer y = 2580
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_adt_00980
integer width = 480
integer height = 300
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_adt_00980
integer width = 480
integer height = 300
boolean enabled = false
end type

type gb_3 from groupbox within w_adt_00980
boolean visible = false
integer x = 1669
integer y = 3104
integer width = 402
integer height = 208
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_adt_00980
boolean visible = false
integer x = 891
integer y = 3104
integer width = 754
integer height = 208
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_adt_00980
boolean visible = false
integer x = 462
integer y = 3104
integer width = 407
integer height = 208
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_ip from u_key_enter within w_adt_00980
integer x = 1495
integer y = 188
integer width = 1358
integer height = 204
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_adt_00980_01"
boolean border = false
end type

event itemchanged;call super::itemchanged;String s_cod, ls_cvcod, ls_cvnas, ls_area, ls_team, ls_Saupj, ls_Name1, ls_null
SetNull(ls_null)

if this.GetColumnName() = "yyyymm" then //기준년월
	s_cod = Trim(this.GetText())
	if f_datechk(s_cod + "01") = -1 then
		f_message_chk(35, "[기준년도]")
		this.SetItem(1,'yyyymm', ls_null)
		return 1
	end if
elseif this.GetColumnName() = "cvcod" then //거래처코드
	ls_cvcod = Trim(GetText())
	IF ls_cvcod ="" OR IsNull(ls_cvcod) THEN
		this.SetItem(1,'cvnas2',ls_null)
		Return
	END IF

	If f_get_cvnames('1', ls_cvcod, ls_cvnas, ls_area, ls_team, ls_Saupj, ls_Name1) <> 1 Then
		this.SetItem(1, 'cvcod', ls_null)
		this.SetItem(1, 'cvnas', ls_null)
		Return 1
	ELSE		
		this.SetItem(1, 'cvcod', ls_cvcod)
		this.SetItem(1, 'cvnas', ls_cvnas)						
	END IF	
end if


end event

event getfocus;call super::getfocus;dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Setredraw(True)

end event

event itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;String sIoCustName, sIocustarea, sdept

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "cvcod"
	   gs_gubun = '1'
		open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"cvcod",gs_code)
		this.SetColumn("cvcod")
		this.TriggerEvent(ItemChanged!)
END Choose
end event

type rr_1 from roundrectangle within w_adt_00980
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1522
integer y = 400
integer width = 1312
integer height = 1856
integer cornerheight = 40
integer cornerwidth = 55
end type

