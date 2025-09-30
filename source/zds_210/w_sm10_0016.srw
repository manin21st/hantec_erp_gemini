$PBExportHeader$w_sm10_0016.srw
$PBExportComments$납품장소 등록
forward
global type w_sm10_0016 from w_inherite
end type
type dw_1 from datawindow within w_sm10_0016
end type
type dw_list from datawindow within w_sm10_0016
end type
type rr_1 from roundrectangle within w_sm10_0016
end type
type rr_2 from roundrectangle within w_sm10_0016
end type
end forward

global type w_sm10_0016 from w_inherite
string title = "차종정보 등록"
dw_1 dw_1
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
end type
global w_sm10_0016 w_sm10_0016

type variables
String is_carcode
end variables

on w_sm10_0016.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_sm10_0016.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

dw_list.Retrieve('%')

dw_1.InsertRow(0)
end event

type dw_insert from w_inherite`dw_insert within w_sm10_0016
integer x = 1298
integer y = 208
integer width = 3291
integer height = 2052
string dataobject = "d_sm10_0016_b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::clicked;call super::clicked;//If row <= 0 then
//	this.SelectRow(0,False)
//ELSE
//	this.SelectRow(0, FALSE)
//	this.SelectRow(row,TRUE)
//END IF

f_multi_select(dw_insert)
end event

event dw_insert::itemchanged;call super::itemchanged;String ls_col ,ls_value ,ls_null
SetNull(ls_null)
ls_col = Lower(GetColumnName())

Choose Case ls_col
	Case 'seq'
		ls_value = String(GetText())
		If isNull(ls_value ) or ls_value = "" Or Long(ls_value) = 0 Then 
			dw_insert.Object.seq[row] = ls_null
			Return 1
		End if
		
		dw_insert.Object.seq[row] = ls_value
		
End Choose


end event

event dw_insert::itemerror;call super::itemerror;return 1
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
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
end Choose
		
		
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0016
boolean visible = false
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0016
boolean visible = false
end type

type p_search from w_inherite`p_search within w_sm10_0016
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_sm10_0016
integer x = 3735
end type

event p_ins::clicked;call super::clicked;Long ll_row , ll_max , ll_cnt

ll_cnt = dw_list.RowCount()
	
If ll_cnt < 1 Then
	MessageBox('확인','오른쪽 리스트에서 차종코드를 선택하세요.')
	Return
End If

ll_row = dw_insert.InsertRow(0)

dw_insert.SetFocus()
dw_insert.ScrollToRow(ll_row)

dw_insert.Object.carcode[ll_row] = is_carcode
ll_max = Long(dw_insert.Object.max_seq[1])

If ll_max <= 0 or isNull(ll_max) Then 
	ll_max = 10
Else
	ll_max = ll_max + 10
End If

dw_insert.Object.seq[ll_row] = String( ll_max , '000')
dw_insert.SetColumn('seq')


end event

type p_exit from w_inherite`p_exit within w_sm10_0016
integer x = 4430
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm10_0016
integer x = 4256
end type

event p_can::clicked;call super::clicked;dw_1.SetRedraw(False)
dw_1.Reset()
dw_1.InsertRow(0)
dw_1.SetRedraw(True)

p_inq.TriggerEvent(Clicked!)


end event

type p_print from w_inherite`p_print within w_sm10_0016
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_sm10_0016
integer x = 3561
end type

event p_inq::clicked;call super::clicked;
String ls_code 

dw_1.AcceptText() 

ls_code = Trim(dw_1.Object.carcode[1])

If isNull(ls_code) Then 
	ls_code = '%'
else
	ls_code = ls_code+ '%'
end if

dw_list.SetRedraw(False)

If dw_list.Retrieve(ls_code) > 0 Then
	dw_list.SelectRow(0, FALSE)
	dw_list.SelectRow(1,TRUE)
	is_carcode = Trim(dw_list.Object.carcode[1])
	dw_insert.Retrieve(is_carcode)
	
End If

dw_list.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_sm10_0016
integer x = 4082
end type

event p_del::clicked;call super::clicked;Long i , ll_r , ll_cnt=0

ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
If f_msg_delete() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return 

String ls_carcode , ls_seq

For i = ll_r To 1 Step -1
	
	If dw_insert.IsSelected(i) Then
		
		ls_carcode = Trim(dw_insert.object.carcode[i])
		ls_seq = Trim(dw_insert.object.seq[i])
		
		ll_cnt = 0
		SELECT count(*) Into :ll_cnt
		  From carbom
		 Where carcode = :ls_carcode
		   and seq = :ls_seq ;
		If ll_cnt > 0 Then
			MessageBox('확인','이미 차종 BOM 에 등록된 모델코드입니다. 삭제 불가합니다.')
			dw_insert.ScrollToRow(i)
			Return
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

type p_mod from w_inherite`p_mod within w_sm10_0016
integer x = 3909
end type

event p_mod::clicked;call super::clicked;Long i , ll_r , ll_cnt=0  , ll_seq
String ls_new ,ls_null , ls_seq

ll_r = dw_insert.RowCount()

If ll_r < 1 Then Return
If f_msg_update() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return 

SetNull(ls_null)

For i = ll_r To 1 Step -1
	ls_new = Trim(dw_insert.Object.is_new[i])
	
	If ls_new = 'Y' Then
		ls_seq = dw_insert.Object.seq[i]

		If ls_seq = '' Or isNull(ll_seq) Then
			MessageBox('확인',String(i)+' 행의 모델순번이 필요합니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn('seq')
			Return
		End IF
		
		Select Count(*) Into :ll_cnt
		  from carmst
		 where  carcode = :is_carcode and seq = :ls_seq ;
		 
		If ll_cnt > 0 Then
			MessageBox('확인',String(i)+' 행의 해당 모델순번은 이미 등록된 코드 입니다.')
			dw_insert.ScrollToRow(i)
			dw_insert.SetFocus()
			dw_insert.SetColumn('seq')
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
	dw_insert.SetRedraw(false)

	dw_insert.Retrieve(is_carcode)
	dw_insert.SetRedraw(true)
End iF

end event

type cb_exit from w_inherite`cb_exit within w_sm10_0016
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0016
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0016
end type

type cb_del from w_inherite`cb_del within w_sm10_0016
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0016
end type

type cb_print from w_inherite`cb_print within w_sm10_0016
end type

type st_1 from w_inherite`st_1 within w_sm10_0016
end type

type cb_can from w_inherite`cb_can within w_sm10_0016
end type

type cb_search from w_inherite`cb_search within w_sm10_0016
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0016
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0016
end type

type dw_1 from datawindow within w_sm10_0016
event ue_keydown pbm_dwnprocessenter
integer x = 27
integer y = 16
integer width = 2053
integer height = 172
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0016_1"
boolean border = false
boolean livescroll = true
end type

event ue_keydown;p_inq.TriggerEvent(Clicked!)
end event

type dw_list from datawindow within w_sm10_0016
integer x = 41
integer y = 208
integer width = 1216
integer height = 2052
integer taborder = 120
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0016_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;If row <= 0 then
	this.SelectRow(0,False)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
	
	SetNull(gs_code)
	dw_insert.SetRedraw(false)
	is_carcode = Trim(This.Object.carcode[row])
	//gs_gubun = Trim(This.Object.rfna5[row])
	dw_insert.Retrieve(is_carcode)
	dw_insert.SetRedraw(true)
END IF
end event

type rr_1 from roundrectangle within w_sm10_0016
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 1285
integer y = 200
integer width = 3323
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sm10_0016
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 27
integer y = 200
integer width = 1243
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

