$PBExportHeader$w_cic04500.srw
$PBExportComments$원가계산실행
forward
global type w_cic04500 from w_inherite
end type
type dw_c from datawindow within w_cic04500
end type
type shl_1 from statichyperlink within w_cic04500
end type
type rr_1 from roundrectangle within w_cic04500
end type
end forward

global type w_cic04500 from w_inherite
integer width = 4667
integer height = 2600
string title = "원가계산실행"
dw_c dw_c
shl_1 shl_1
rr_1 rr_1
end type
global w_cic04500 w_cic04500

on w_cic04500.create
int iCurrent
call super::create
this.dw_c=create dw_c
this.shl_1=create shl_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_c
this.Control[iCurrent+2]=this.shl_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_cic04500.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_c)
destroy(this.shl_1)
destroy(this.rr_1)
end on

event open;call super::open;ib_any_typing = false

dw_c.InsertRow(0)

// 2007.4.19 수정 kwy, id 'BDS'가 아니면 처리구분 선택못하도록 한 내역
//if gs_userid = "BDS" then
//
//else
//	dw_c.object.traceyn_t.visible	= False
//	dw_c.object.traceyn.visible	= False
//	dw_c.Width	= 613
//	rr_1.Width	= 681
//end if


string	ls_yymm, ls_colx
ls_yymm = f_aftermonth(string(Today(), "YYYYMM"), -1)
dw_c.object.workym[1] = ls_yymm

ls_colx = dw_insert.object.opdesc.X
dw_insert.object.datawindow.horizontalscrollsplit = ls_colx


p_inq.Post Event Clicked()

end event

event resize;call super::resize;//rr_2.Width 			= NewWidth - 70
//dw_insert.Width	= NewWidth - 120
//
//rr_2.Height 		= NewHeight - 240
//dw_insert.Height	= NewHeight - 270

end event

type dw_insert from w_inherite`dw_insert within w_cic04500
boolean visible = false
integer x = 859
integer y = 2556
integer width = 1266
integer height = 108
integer taborder = 0
string dataobject = "d_cic04500_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)

end event

event dw_insert::retrieveend;call super::retrieveend;if rowcount > 0 then This.Event RowFocusChanged(1)

end event

event dw_insert::doubleclicked;call super::doubleclicked;// Datawindow 정렬하기.
//f_sort(This)

end event

event dw_insert::constructor;call super::constructor;This.SetTransObject(sqlca)

end event

type p_delrow from w_inherite`p_delrow within w_cic04500
boolean visible = false
integer x = 3922
integer y = 2664
integer taborder = 0
end type

event p_delrow::clicked;call super::clicked;dw_insert.Deleterow(0)

if dw_insert.RowCount() <> 0 Then
	dw_insert.SelectRow(0, FALSE)
	dw_insert.SelectRow(dw_insert.getrow(), TRUE)
end if

end event

type p_addrow from w_inherite`p_addrow within w_cic04500
boolean visible = false
integer x = 3749
integer y = 2664
integer taborder = 0
end type

event p_addrow::clicked;call super::clicked;dw_insert.Object.workym.Initial	= dw_c.object.workym[1]

If dw_insert.RowCount() < 1 Then
	dw_insert.Insertrow(1)
Else
	dw_insert.Insertrow(dw_insert.GetRow())
End If

end event

type p_search from w_inherite`p_search within w_cic04500
integer x = 4242
integer y = 16
integer taborder = 20
string picturename = "C:\erpman\image\처리_up.gif"
end type

event p_search::clicked;call super::clicked;string	ls_ftime, ls_ttime, ls_sparam="<PARAM>", ls_eparam="</PARAM>", ls_param, ls_rtn, ls_traceyn
string	ls_workym, ls_minym, ls_date_val, ls_cbgbn
ls_ftime = String(Today(), "hh:mm:ss")


ls_workym	= dw_c.object.workym[1]
ls_cbgbn	= dw_c.object.cbgbn[1]

if IsNull(ls_workym) then
	MessageBox("기준년월 입력확인", "기준년월 조회조건을 설정하십시오.")
	Return
end if

if IsNull(ls_cbgbn) then
	MessageBox("처리모듈선택", "원가배부계산 처리모듈을 선택하십시오.")
	Return
end if

ls_date_val = mid(ls_workym, 1, 4) + '-' + mid(ls_workym, 5, 2) + "-01"
if Not IsDate(ls_date_val) then
	MessageBox("기준년월 입력확인", "기준년월 조회조건을 확인하십시오.")
	Return
end if


// 원가계산 작업을 실행할때 작업년월 이전 자료가 기초재공/기초재고에 입력되었다면 작업을 중단함.
//select
//	min(workym) as workym
//into
//	:ls_minym
//from
//	(
//	/* 기초재고 테이블에서 입력된 가장 작은 작업년월 */
//	select
//		min(workym) as workym
//	from
//		kuck_cic_rst_stockqty
//	where
//		input_yn = 'Y'
//	
//	/* 기초재공 테이블에서 입력된 가장 작은 작업년월 */
//	union all
//	select
//		min(workym) as workym
//	from
//		cic_rst_prgsqty
//	where
//		input_yn = 'Y'
//	)
//;
//
//if isNull(ls_minym) or ls_minym < ls_workym then
//else
//	MessageBox("원가계산", "작업년월 이전 자료가 기초재공/기초재고에 입력되어있습니다. 작업할 수 없습니다.")
//	Return
//end if


// 원가계산
If MessageBox("원가계산", "원가계산을 처리하시겠습니까?", question!, yesno!, 2) = 2 Then Return

/*--------------------------------------------------------------------------------------------*/
// 원가마감여부 체크
select fun_wonga_magam(:ls_workym) into :ls_rtn  from dual ;
if ls_rtn = 'Y' then
   messagebox('확인','마감 처리된 원가계산년월 입니다! 마감취소후 실행하십시오!')
   Return
end if
/*--------------------------------------------------------------------------------------------*/
SetPointer(HourGlass!)

ls_param 	= ls_sparam + ls_workym + ls_eparam
ls_traceyn	= dw_c.object.traceyn[1]
//ls_rtn		= Sqlca.FUN_CIC_PROCESS00(ls_traceyn, ls_cbgbn, '10', 1, ls_param) ;
// 이전의 방식으로 실행시(UE_CREATETRANSACTION에 설정해야함
	/*-------------------------------------------------------------------------------------------------
	  DB Function Call (원가계산 실행)
	-------------------------------------------------------------------------------------------------*/
	DECLARE fun_cic_process00 PROCEDURE FOR FUN_CIC_PROCESS00(:ls_traceyn, :ls_cbgbn, '10', 1, :ls_param) USING SQLCA;
	EXECUTE fun_cic_process00;
	If SQLCA.SQLCODE < 0 Then
		f_message_chk(57, "~r~n~r~n[EXECUTE FUN_CIC_PROCESS00]~r~n~r~n" + SQLCA.SQLERRTEXT)	// 자료를 처리할 수 없습니다.
		CLOSE fun_cic_process00;
		Return
	End If
	
	FETCH fun_cic_process00 INTO :ls_rtn;

	CLOSE fun_cic_process00;

ls_ttime = String(Today(), "hh:mm:ss")


MessageBox("원가계산", ls_rtn + "~r~n" + ls_ttime + " - " + ls_ftime)

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\처리_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\처리_up.gif"
end event

type p_ins from w_inherite`p_ins within w_cic04500
boolean visible = false
integer x = 4027
integer y = 2836
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_cic04500
integer x = 4430
integer y = 16
integer taborder = 30
end type

type p_can from w_inherite`p_can within w_cic04500
boolean visible = false
integer x = 4375
integer y = 2836
integer taborder = 0
end type

type p_print from w_inherite`p_print within w_cic04500
boolean visible = false
integer x = 3854
integer y = 2836
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cic04500
boolean visible = false
integer x = 4288
integer y = 2660
integer taborder = 0
end type

event p_inq::clicked;call super::clicked;string	ls_date_val, ls_workym

dw_c.AcceptText()

ls_workym = dw_c.object.workym[1]


if IsNull(ls_workym) then
	MessageBox("기준년월 입력확인", "기준년월 조회조건을 설정하십시오.")
	Return
end if
ls_date_val = mid(ls_workym, 1, 4) + '-' + mid(ls_workym, 5, 2) + "-01"
if Not IsDate(ls_date_val) then
	MessageBox("기준년월 입력확인", "기준년월 조회조건을 확인하십시오.")
	Return
end if


dw_insert.retrieve()

end event

type p_del from w_inherite`p_del within w_cic04500
boolean visible = false
integer x = 4201
integer y = 2836
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_cic04500
boolean visible = false
integer x = 4096
integer y = 2664
integer taborder = 0
end type

event p_mod::clicked;call super::clicked;IF dw_insert.Accepttext() = -1 THEN RETURN

if dw_insert.ModifiedCount() + dw_insert.DeletedCount() = 0 then Return

// 저장메세지 function
IF f_msg_update() = -1 THEN RETURN

IF dw_insert.Update() > 0 THEN			
	COMMIT;
	ib_any_typing =False
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK;
	ib_any_typing = True
END IF

end event

type cb_exit from w_inherite`cb_exit within w_cic04500
end type

type cb_mod from w_inherite`cb_mod within w_cic04500
end type

type cb_ins from w_inherite`cb_ins within w_cic04500
end type

type cb_del from w_inherite`cb_del within w_cic04500
end type

type cb_inq from w_inherite`cb_inq within w_cic04500
end type

type cb_print from w_inherite`cb_print within w_cic04500
end type

type st_1 from w_inherite`st_1 within w_cic04500
end type

type cb_can from w_inherite`cb_can within w_cic04500
end type

type cb_search from w_inherite`cb_search within w_cic04500
end type







type gb_button1 from w_inherite`gb_button1 within w_cic04500
end type

type gb_button2 from w_inherite`gb_button2 within w_cic04500
end type

type dw_c from datawindow within w_cic04500
integer x = 1568
integer y = 1096
integer width = 1573
integer height = 116
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_cic04500_00"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String	ls_date_val

Choose Case GetColumnName()
	Case "workym"

		if IsNull(data) then
			MessageBox("기준년월 입력확인", "기준년월 조회조건을 설정하십시오.")
			Return 1
		end if

		ls_date_val = mid(data, 1, 4) + '-' + mid(data, 5, 2) + "-01"
		if Not IsDate(ls_date_val) then
			MessageBox("기준년월 입력확인", "기준년월 조회조건을 확인하십시오.")
			Return 1
		end if

	Case Else

End Choose

end event

event itemerror;Return 1

end event

type shl_1 from statichyperlink within w_cic04500
boolean visible = false
integer x = 3904
integer y = 444
integer width = 677
integer height = 92
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 32106727
boolean enabled = false
string text = "원가계산 작업"
alignment alignment = center!
long bordercolor = 32106727
boolean focusrectangle = false
end type

event clicked;string	ls_ftime, ls_ttime, ls_sparam="<PARAM>", ls_eparam="</PARAM>", ls_param, ls_rtn, ls_traceyn
string	ls_workym, ls_minym, ls_date_val, ls_cbgbn
ls_ftime = String(Today(), "hh:mm:ss")


ls_workym	= dw_c.object.workym[1]
ls_cbgbn	= dw_c.object.cbgbn[1]

if IsNull(ls_workym) then
	MessageBox("기준년월 입력확인", "기준년월 조회조건을 설정하십시오.")
	Return
end if

if IsNull(ls_cbgbn) then
	MessageBox("처리모듈선택", "원가계산 처리모듈을 선택하십시오.")
	Return
end if

ls_date_val = mid(ls_workym, 1, 4) + '-' + mid(ls_workym, 5, 2) + "-01"
if Not IsDate(ls_date_val) then
	MessageBox("기준년월 입력확인", "기준년월 조회조건을 확인하십시오.")
	Return
end if


// 원가계산 작업을 실행할때 작업년월 이전 자료가 기초재공/기초재고에 입력되었다면 작업을 중단함.
//select
//	min(workym) as workym
//into
//	:ls_minym
//from
//	(
//	/* 기초재고 테이블에서 입력된 가장 작은 작업년월 */
//	select
//		min(workym) as workym
//	from
//		kuck_cic_rst_stockqty
//	where
//		input_yn = 'Y'
//	
//	/* 기초재공 테이블에서 입력된 가장 작은 작업년월 */
//	union all
//	select
//		min(workym) as workym
//	from
//		cic_rst_prgsqty
//	where
//		input_yn = 'Y'
//	)
//;
//
//if isNull(ls_minym) or ls_minym < ls_workym then
//else
//	MessageBox("원가계산", "작업년월 이전 자료가 기초재공/기초재고에 입력되어있습니다. 작업할 수 없습니다.")
//	Return
//end if


// 원가계산
If MessageBox("원가계산", "원가계산 생성(매월작업)을 처리하시겠습니까?", question!, yesno!, 2) = 2 Then Return


ls_param 	= ls_sparam + ls_workym + ls_eparam
ls_traceyn	= dw_c.object.traceyn[1]
//ls_rtn		= Sqlca.FUN_CIC_PROCESS00(ls_traceyn, ls_cbgbn, '10', 1, ls_param) ;
	/*-------------------------------------------------------------------------------------------------
	  DB Function Call (원가계산 실행)
	-------------------------------------------------------------------------------------------------*/
	DECLARE fun_cic_process00 PROCEDURE FOR FUN_CIC_PROCESS00(:ls_traceyn, :ls_cbgbn, '10', 1, :ls_param) USING SQLCA;
	EXECUTE fun_cic_process00;
	If SQLCA.SQLCODE < 0 Then
		f_message_chk(57, "~r~n~r~n[EXECUTE FUN_CIC_PROCESS00]~r~n~r~n" + SQLCA.SQLERRTEXT)	// 자료를 처리할 수 없습니다.
		CLOSE fun_cic_process00;
		Return
	End If
	
	FETCH fun_cic_process00 INTO :ls_rtn;

	CLOSE fun_cic_process00;

ls_ttime = String(Today(), "hh:mm:ss")


MessageBox("원가계산", ls_rtn + "~r~n" + ls_ttime + " - " + ls_ftime)

end event

type rr_1 from roundrectangle within w_cic04500
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1527
integer y = 944
integer width = 1687
integer height = 416
integer cornerheight = 40
integer cornerwidth = 55
end type

