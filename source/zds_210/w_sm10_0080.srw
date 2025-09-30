$PBExportHeader$w_sm10_0080.srw
$PBExportComments$ALC 정보 등록
forward
global type w_sm10_0080 from w_inherite
end type
type dw_1 from datawindow within w_sm10_0080
end type
type rr_1 from roundrectangle within w_sm10_0080
end type
end forward

global type w_sm10_0080 from w_inherite
string title = "ACL 코드 마스타"
dw_1 dw_1
rr_1 rr_1
end type
global w_sm10_0080 w_sm10_0080

on w_sm10_0080.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sm10_0080.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_insert.Retrieve('%','%')

dw_1.InsertRow(0)
end event

type dw_insert from w_inherite`dw_insert within w_sm10_0080
integer x = 46
integer y = 200
integer width = 4539
integer height = 2048
string dataobject = "d_sm10_0080_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;

f_multi_select(dw_insert)
end event

event dw_insert::itemchanged;call super::itemchanged;String ls_col ,ls_value

ls_col = Lower(GetColumnName())

ls_value = String(GetText())
row = GetRow()
Choose Case ls_col
	
	Case 'cvcod'
		String ls_cvnas 
		If ls_value > '' Then
			SELECT "VNDMST"."CVNAS"  
			  INTO :ls_cvnas  
			  FROM "VNDMST"  
			 WHERE ( "VNDMST"."CVCOD" = :ls_value ) AND
					 ( "VNDMST"."CVSTATUS" = '0' ) ;	
			If sqlca.sqlcode <> 0 Then
				f_message_chk(50,'[거래처]')
				Object.cvcod[row] = ''
				Object.cvnas[row] = ''
				SetColumn(ls_col)
				Return 1
			Else
				Object.cvnas[row] = ls_cvnas
			End iF
		Else
			return 1
		End iF
End Choose


end event

event dw_insert::itemerror;call super::itemerror;Return 1
end event

event dw_insert::rbuttondown;call super::rbuttondown;Long nRow

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return
Choose Case GetColumnName() 
	
	/* 거래처 */
	Case "cvcod" 
		If GetColumnName() = "cvnas" then
			gs_codename = Trim(GetText())
		End If
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"cvcod",gs_code)
		TriggerEvent(ItemChanged!)
end Choose
		
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0080
integer x = 3141
end type

event p_delrow::clicked;call super::clicked;Long ll_rcnt , i

ll_rcnt = dw_insert.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
	Return
End IF
if f_msg_delete() = -1 then return

dw_insert.SetRedraw(FALSE)

String ls_citnbr

For i = ll_rcnt To 1 Step -1
	If dw_insert.isSelected(i) Then
		
	
		dw_insert.ScrollToRow(i)
		dw_insert.DeleteRow(i)
	End iF
Next

if dw_insert.Update() = 1 then
	
	commit ;
	sle_msg.text =	"선택한 자료를 삭제하였습니다!!"	
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
dw_insert.SetRedraw(TRUE)


end event

type p_addrow from w_inherite`p_addrow within w_sm10_0080
integer x = 2967
end type

event p_addrow::clicked;call super::clicked;Long ll_r

ll_r = dw_insert.insertRow(0)

dw_insert.ScrollToRow(ll_r)

end event

type p_search from w_inherite`p_search within w_sm10_0080
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_sm10_0080
boolean visible = false
integer x = 3749
end type

event p_ins::clicked;call super::clicked;Long ll_row

ll_row = dw_insert.InsertRow(0)

dw_insert.SetFocus()
dw_insert.ScrollToRow(ll_row)
dw_insert.SetColumn('rfgub')


end event

type p_exit from w_inherite`p_exit within w_sm10_0080
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm10_0080
end type

event p_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)


end event

type p_print from w_inherite`p_print within w_sm10_0080
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_sm10_0080
integer x = 3922
end type

event p_inq::clicked;call super::clicked;
String ls_name , ls_itnbr 

dw_1.AcceptText() 

ls_name = Trim(dw_1.Object.carname[1])
ls_itnbr = Trim(dw_1.Object.itnbr[1])

If isNull(ls_name) Then ls_name = '%'
If isNull(ls_itnbr) Then ls_itnbr = '%'

dw_insert.SetRedraw(False)
dw_insert.Retrieve( ls_itnbr , ls_name )
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sm10_0080
boolean visible = false
end type

event p_del::clicked;call super::clicked;Long i , ll_r , ll_cnt=0 , ll_i=0
String ls_new , ls_carcode

ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
If f_msg_delete() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return 

For i = ll_r To 1 Step -1
	
	If dw_insert.IsSelected(i) Then
		ls_new = Trim(dw_insert.Object.is_new[i])
		If ls_new <> 'Y' Then
			ls_carcode = Trim(dw_insert.Object.rfgub[i])
			Select Count(*) Into :ll_i
			  From CARMST 	
			 Where carcode = :ls_carcode ;
			If ll_i > 0 Then
				If MessageBox("확인", ls_carcode +" 해당 차종코드의 하위 구성정보들을 모두 삭제 하시겠습니까?" , &
				                      Question!, OKCancel!, 2) = 1 Then
					Delete From CARMST WHERE carcode = :ls_carcode ;
				End If
			End If
		End If
		dw_insert.DeleteRow(i)
		ll_cnt++
	End If
Next

If ll_cnt < 1 Then 
	MessageBox('확인','삭제 할 라인(행)을 선택하세요')
Else
	If dw_insert.Update() < 1 Then
		Rollback;
		MessageBox('저장실패','저장실패')
		Return
	Else
		Commit;
	End iF
End IF
end event

type p_mod from w_inherite`p_mod within w_sm10_0080
integer x = 4096
end type

event p_mod::clicked;call super::clicked;Long i , ll_r , ll_cnt=0
String ls_new ,ls_code , ls_name ,ls_sdate , ls_edate ,ls_null , ls_code2 , ls_cvcod

ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
If f_msg_update() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return 

SetNull(ls_null)

For i = ll_r To 1 Step -1
	ls_new = Trim(dw_insert.Object.is_new[i])
	
	If ls_new = 'Y' Then
		ls_code = Trim(dw_insert.Object.alc_code[i])
		ls_cvcod = Trim(dw_insert.Object.cvcod[i])
		
		If ls_code = '' Or isNull(ls_code)  Then
			dw_insert.DeleteRow(i)
			Continue;
		End IF
		
		If ls_cvcod = '' Or isNull(ls_cvcod) Then
			MessageBox('확인',String(i)+' 행의 거래처가 필요합니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn('cvcod')
			Return
		End If
	
		Select Count(*) Into :ll_cnt
		  from itemas_alc
		 where alc_code = :ls_code ;
		 
		If ll_cnt > 0 Then
			MessageBox('확인',String(i)+' 행의 해당 서열코드는 이미 등록된 코드 입니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn('alc_code')
			Return
		End If
	End If
	
Next

dw_insert.AcceptText()

If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('저장실패','저장실패')
	Return
Else
	Commit;
	p_can.TriggerEvent(Clicked!)
End iF

end event

type cb_exit from w_inherite`cb_exit within w_sm10_0080
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0080
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0080
end type

type cb_del from w_inherite`cb_del within w_sm10_0080
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0080
end type

type cb_print from w_inherite`cb_print within w_sm10_0080
end type

type st_1 from w_inherite`st_1 within w_sm10_0080
end type

type cb_can from w_inherite`cb_can within w_sm10_0080
end type

type cb_search from w_inherite`cb_search within w_sm10_0080
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0080
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0080
end type

type dw_1 from datawindow within w_sm10_0080
event ue_keydown pbm_dwnprocessenter
integer x = 27
integer y = 12
integer width = 2752
integer height = 172
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0080_1"
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_sm10_0080
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 192
integer width = 4576
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

