$PBExportHeader$w_sm10_0100.srw
forward
global type w_sm10_0100 from w_inherite
end type
type p_excel_upload from uo_picture within w_sm10_0100
end type
type dw_1 from datawindow within w_sm10_0100
end type
type pb_2 from u_pb_cal within w_sm10_0100
end type
type pb_1 from u_pb_cal within w_sm10_0100
end type
type rr_1 from roundrectangle within w_sm10_0100
end type
end forward

global type w_sm10_0100 from w_inherite
string title = "PO 등록(FUSO)"
p_excel_upload p_excel_upload
dw_1 dw_1
pb_2 pb_2
pb_1 pb_1
rr_1 rr_1
end type
global w_sm10_0100 w_sm10_0100

type variables
uo_xlobject uo_xl

string is_cur_directory

//정렬 사용 변수
String is_old_dwobject_name,is_old_color
Boolean b_flag

//Multi Select 사용 변수
long il_lastclickedrow
boolean ib_action_on_buttonup
end variables

forward prototypes
public function integer us_sort (string as_dwobject_name)
public function integer uf_sort (string as_dwobject_name)
public function integer ufi_shift_highlight (long al_aclickedrow)
end prototypes

public function integer us_sort (string as_dwobject_name);String ls_setsort, ls_lowered = '5', ls_raised = '6'

ls_setsort = Left(as_dwobject_name, Len(as_dwobject_name) - 2)

If ls_setsort = "" Then Return -1

If dw_insert.Describe("type.border") = ls_lowered Then &
 ls_setsort = ls_setsort + " d"
If dw_insert.SetSort(ls_setsort) = -1 Then
	MessageBox("SetSort()", "Parameter : '" + ls_setsort + "'")
	Return -1
End If

dw_insert.Sort()
//dw_insert.ScrollToRow(dw_insert.GetSelectedRow(0))

Return 0
end function

public function integer uf_sort (string as_dwobject_name);String ls_setsort, ls_lowered = '5', ls_raised = '6'

ls_setsort = Left(as_dwobject_name, Len(as_dwobject_name) - 2)

If ls_setsort = "" Then Return -1

If dw_insert.Describe("type.border") = ls_lowered Then &
 ls_setsort = ls_setsort + " d"
If dw_insert.SetSort(ls_setsort) = -1 Then
	MessageBox("SetSort()", "Parameter : '" + ls_setsort + "'")
	Return -1
End If

dw_insert.Sort()
//dw_insert.ScrollToRow(dw_insert.GetSelectedRow(0))

Return 0
end function

public function integer ufi_shift_highlight (long al_aclickedrow);int li_idx

dw_insert.SetRedraw(FALSE)
dw_insert.SelectRow(0, FALSE)            

IF il_lastclickedrow = 0 THEN
	dw_insert.SetRedraw(TRUE)
	RETURN 1
END IF

IF il_lastclickedrow > al_aclickedrow THEN
	FOR li_idx = il_lastclickedrow TO al_aclickedrow STEP -1
		dw_insert.SelectRow(li_idx, TRUE)
	END FOR
ELSE
	FOR li_idx = il_lastclickedrow TO al_aclickedrow
		dw_insert.SelectRow(li_idx, TRUE)
	NEXT
END IF
dw_insert.SetRedraw(TRUE)
RETURN 1

end function

on w_sm10_0100.create
int iCurrent
call super::create
this.p_excel_upload=create p_excel_upload
this.dw_1=create dw_1
this.pb_2=create pb_2
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_excel_upload
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.rr_1
end on

on w_sm10_0100.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_excel_upload)
destroy(this.dw_1)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_1.InsertRow(0)

dw_1.SetItem(1, "sdate", mid(f_today(), 1, 4) + "0101")
dw_1.SetItem(1, "edate", f_today())

is_cur_directory = GetCurrentDirectory()
end event

type dw_insert from w_inherite`dw_insert within w_sm10_0100
integer x = 46
integer y = 200
integer width = 4539
integer height = 2048
string dataobject = "d_sm10_0100_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;int  li_loc, li_i
String ls_raised = '6' , ls_lowered = '5' 
string ls_dwobject, ls_dwobject_name
String ls_modify, ls_rc, ls_col_no

SetPointer(HourGlass!)

IF row <= 0 THEN 
	ls_dwobject = GetObjectAtPointer()
	li_loc = Pos(ls_dwobject, '~t')
	
	If li_loc = 0 Then Return
	
	ls_dwobject_name = Left(ls_dwobject, li_loc - 1)
		
	//유 상웅 추가(99.04) 헤드에 _t가 없으면 바로 RETURN  
	if '_t' <> Right(ls_dwobject_name, 2) then return 
	
	IF b_flag =False THEN 
		b_flag =True
		RETURN
	END IF 
	
	If ls_dwobject_name = 'type'  Then
		If Describe(ls_dwobject_name + ".border") = ls_lowered Then
			ls_modify = ls_dwobject_name + ".border=" + ls_raised
			ls_modify = ls_modify + " " + ls_dwobject_name + &
			 ".text=" + "'오름차순'"
		Else
			ls_modify = ls_dwobject_name + ".border=" + ls_lowered
			ls_modify = ls_modify + " " + ls_dwobject_name + &
			 ".text=" + "'내림차순'"
		End If
	
		ls_rc = Modify(ls_modify)
		If ls_rc <> "" Then
			MessageBox("dwModify", ls_rc + " : " + ls_modify)
			Return
		End If
		uf_sort(is_old_dwobject_name)
		Return
	End If
	
	If is_old_dwobject_name <> ls_dwobject_name Then 
		If uf_sort(ls_dwobject_name) = -1 Then Return
		If is_old_dwobject_name = "" Then
			ls_col_no = String(Describe("datawindow.column.count"))
			For li_i = 1 To Integer(ls_col_no)
				If Describe("#" + ls_col_no + ".border") = ls_lowered Then
					is_old_dwobject_name = Describe("#" + ls_col_no + &
					 + ".name") + "_t"
					is_old_color = Describe(is_old_dwobject_name + ".color")
					Exit
				End If
			Next
		End If
		If is_old_dwobject_name <> "" Then
			ls_modify = is_old_dwobject_name + ".border=" + ls_raised
			ls_modify = ls_modify + " " + &
			 is_old_dwobject_name + ".color=" + is_old_color
			ls_rc = Modify(ls_modify)
			If ls_rc <> "" Then
				MessageBox("dwModify", ls_rc + " : " + ls_modify)
				Return
			End If
		End If
		is_old_color = Describe(ls_dwobject_name + ".color")
		ls_modify = ls_dwobject_name + ".border=" + ls_lowered
		ls_modify = ls_modify + " " + &
		 ls_dwobject_name + ".color=" + String(RGB(0, 0, 128))
		ls_rc = Modify(ls_modify)
		If ls_rc <> "" Then
			MessageBox("Modify", ls_rc + " : " + ls_modify)
			Return
		End If
	
		is_old_dwobject_name = ls_dwobject_name
	End If

ELSE
	IF Keydown(KeyShift!) THEN
		ufi_shift_highlight(ROW)
	
	ELSEIF this.IsSelected(ROW) THEN
		il_lastclickedrow = ROW
		ib_action_on_buttonup = TRUE
	ELSEIF Keydown(KeyControl!) THEN
		il_lastclickedrow = ROW
		this.SelectRow(ROW, TRUE)
	ELSE
		il_lastclickedrow = ROW
		this.SelectRow(0, FALSE)
		this.SelectRow(ROW, TRUE)
	END IF 
END IF




end event

type p_delrow from w_inherite`p_delrow within w_sm10_0100
integer y = 3092
end type

type p_addrow from w_inherite`p_addrow within w_sm10_0100
integer y = 3092
end type

type p_search from w_inherite`p_search within w_sm10_0100
integer y = 3092
end type

type p_ins from w_inherite`p_ins within w_sm10_0100
integer y = 3092
end type

type p_exit from w_inherite`p_exit within w_sm10_0100
end type

type p_can from w_inherite`p_can within w_sm10_0100
end type

event p_can::clicked;call super::clicked;dw_1.SetItem(1, "sdate", f_today())
dw_1.SetItem(1, "edate", f_today())
dw_1.SetItem(1, "pono", '')
dw_1.SetItem(1, "itnbr", '')

dw_insert.reset()
end event

type p_print from w_inherite`p_print within w_sm10_0100
integer y = 3092
end type

type p_inq from w_inherite`p_inq within w_sm10_0100
integer x = 3749
end type

event p_inq::clicked;call super::clicked;string ls_sdate, ls_edate, ls_pono, ls_itnbr

if dw_1.AcceptText() = -1 then return

ls_sdate = trim(dw_1.GetItemString(1, 'sdate'))
ls_edate = trim(dw_1.GetItemString(1, 'edate'))

ls_pono = trim(dw_1.GetItemString(1, 'pono'))

ls_itnbr = trim(dw_1.GetItemString(1, 'itnbr'))

dw_insert.Retrieve(ls_sdate, ls_edate, ls_pono, ls_itnbr)
end event

type p_del from w_inherite`p_del within w_sm10_0100
end type

event p_del::clicked;call super::clicked;long ll_row

ll_row = dw_insert.GetRow()
if ll_row <= 0 then return

dw_insert.DeleteRow(ll_row)
end event

type p_mod from w_inherite`p_mod within w_sm10_0100
end type

event p_mod::clicked;call super::clicked;If dw_insert.Update() < 1 Then
	Rollback;
	MessageBox('저장실패','저장실패')
	Return
Else
	Commit;
End iF
end event

type cb_exit from w_inherite`cb_exit within w_sm10_0100
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0100
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0100
end type

type cb_del from w_inherite`cb_del within w_sm10_0100
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0100
end type

type cb_print from w_inherite`cb_print within w_sm10_0100
end type

type st_1 from w_inherite`st_1 within w_sm10_0100
end type

type cb_can from w_inherite`cb_can within w_sm10_0100
end type

type cb_search from w_inherite`cb_search within w_sm10_0100
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0100
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0100
end type

type p_excel_upload from uo_picture within w_sm10_0100
integer x = 3589
integer y = 24
boolean bringtotop = true
string picturename = "C:\erpman\image\from_excel.gif"
end type

event clicked;call super::clicked;string  ls_docname, ls_named ,ls_line 
Long    ll_FileNum ,ll_value
String  ls_gubun , ls_col ,ls_line_t , ls_data[]
Long    ll_xl_row , ll_r , i

String  ls_pono, ls_aitnbr, ls_itnbr, ls_itdsc, ls_order_date, ls_shipped_date, ls_arrive_date
String  ls_crt_date, ls_crt_time, ls_crt_user
String  ls_date, ls_time, ls_user
long    ll_poseq
dec {3} ld_total_qty, ld_shipped_qty

long   ll_count

If dw_1.AcceptText() = -1 Then Return

ll_value = GetFileOpenName("UPLOAD 데이타 가져오기", ls_docname, ls_named, & 
             "XLSX", "XLS Files (*.XLS),*.XLS," + "XLSX Files (*.XLSX),*.XLSX")

If ll_value <> 1 Then Return
//UserObject 생성

dw_insert.Reset()

w_mdi_frame.sle_msg.Text = "EXCEL DATA IMPORT 중입니다..........."

Setpointer(Hourglass!)

uo_xl = create uo_xlobject
		
//엑셀과 연결
uo_xl.uf_excel_connect(ls_docname, false , 3)

//Sheet 선택
uo_xl.uf_selectsheet(1)

//Data 시작 Row Setting
ll_xl_row =2

ChangeDirectory(is_cur_directory)


select to_char(sysdate, 'yyyymmdd'),
       to_char(sysdate, 'hh24miss')
  into :ls_date,
       :ls_time
  from dual;

ls_user = gs_userid

Do While(True)
	
	//Data가 없을경우엔 Return...........
	ls_line = trim(uo_xl.uf_gettext(ll_xl_row,1))
	if isnull(uo_xl.uf_gettext(ll_xl_row,1)) or trim(uo_xl.uf_gettext(ll_xl_row,1)) = '' then exit
	
	//사용자 ID(A,1)
	//Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
	For i =1 To 27
		if i = 5 or i = 6 or i = 7 then
		else
			uo_xl.uf_set_format(ll_xl_row,i, '@' + space(50))
		end if
	Next
	
	SetNull(ls_pono)
	SetNull(ll_poseq)
	SetNull(ls_aitnbr)
	SetNull(ls_itnbr)
	SetNull(ls_order_date)
	SetNull(ls_shipped_date)
	SetNull(ls_arrive_date)
	SetNull(ld_total_qty)
	SetNull(ld_shipped_qty)
	SetNull(ls_crt_date)
	SetNull(ls_crt_time)
	SetNull(ls_crt_user)
	
	ls_pono  =  Trim(uo_xl.uf_getvalue(ll_xl_row,3))
	if IsNull(ls_pono) or ls_pono = '' then
		uo_xl.uf_excel_Disconnect()
		MessageBox('확인', string(ll_xl_row) + "행 PO No. 값이 없습니다.")
		return
	end if
	
	ll_poseq  =  long(Trim(uo_xl.uf_getvalue(ll_xl_row,4)))
	if IsNull(ll_poseq) then
		uo_xl.uf_excel_Disconnect()
		MessageBox('확인', string(ll_xl_row) + "행 Item No. 값이 없습니다.")
		return
	end if
		
	ls_aitnbr  =  Trim(uo_xl.uf_getvalue(ll_xl_row,1))
	if IsNull(ls_aitnbr) or ls_aitnbr = '' then
		uo_xl.uf_excel_Disconnect()
		MessageBox('확인', string(ll_xl_row) + "행 품번 값이 없습니다.")
		return
	end if
	
	select a.itnbr, a.itdsc
	  into :ls_itnbr, :ls_itdsc
	  from itemas a
	 where replace(a.itnbr, '-', '') = replace(:ls_aitnbr, '-', '');
	if IsNull(ls_itnbr) or ls_itnbr = '' then
//		uo_xl.uf_excel_Disconnect()
		MessageBox('확인', string(ll_xl_row) + "행 품번 값이 품목마스타에 등록되어 있지 않습니다.")
//		return
		ll_xl_row ++
		continue
	end if
	
	ls_order_date  =  Trim(uo_xl.uf_getvalue(ll_xl_row,5))
	ls_order_date = mid(f_replace(ls_order_date, "-", ""), 1, 8)
	ls_shipped_date  =  Trim(uo_xl.uf_getvalue(ll_xl_row,6))
	ls_shipped_date = mid(f_replace(ls_shipped_date, "-", ""), 1, 8)
	ls_arrive_date  =  Trim(uo_xl.uf_getvalue(ll_xl_row,7))
	ls_arrive_date = mid(f_replace(ls_arrive_date, "-", ""), 1, 8)
	
	ld_total_qty  =  Dec(uo_xl.uf_getvalue(ll_xl_row,8))
	ld_shipped_qty  =  Dec(uo_xl.uf_getvalue(ll_xl_row,9))
	
	ll_r = dw_insert.InsertRow(0) 
	
	//dw_insert.Selectrow(0,false)
	dw_insert.Scrolltorow(ll_r)
	//dw_insert.Selectrow(ll_r,true)
	
	dw_insert.object.pono[ll_r]         =  ls_pono
	dw_insert.object.poseq[ll_r]        =  ll_poseq
	dw_insert.object.itnbr[ll_r]        =  ls_itnbr
	dw_insert.object.itdsc[ll_r]        =  ls_itdsc
	dw_insert.object.order_date[ll_r]   =  ls_order_date
	dw_insert.object.shipped_date[ll_r] =  ls_shipped_date
	dw_insert.object.arrive_date[ll_r]  =  ls_arrive_date
	dw_insert.object.total_qty[ll_r]    =  ld_total_qty
	dw_insert.object.shipped_qty[ll_r]  =  ld_shipped_qty
	
	select count('x')
	  into :ll_count
	  from sm_plan_excel_fuso
	 where pono = :ls_pono
	   and poseq = :ll_poseq;
	
	if ll_count > 0 then
		select crt_date, crt_time, crt_user
		  into :ls_crt_date, :ls_crt_time, :ls_crt_user
		  from sm_plan_excel_fuso
		 where pono = :ls_pono
			and poseq = :ll_poseq;
		
		delete from sm_plan_excel_fuso
		 where pono = :ls_pono
			and poseq = :ll_poseq;
		
		commit;
		dw_insert.object.crt_date[ll_r] = ls_crt_date
		dw_insert.object.crt_time[ll_r] = ls_crt_time
		dw_insert.object.crt_user[ll_r] = ls_crt_user
		dw_insert.object.upd_date[ll_r] = ls_date
		dw_insert.object.upd_time[ll_r] = ls_time
		dw_insert.object.upd_user[ll_r] = ls_user
	else
		dw_insert.object.crt_date[ll_r] = ls_date
		dw_insert.object.crt_time[ll_r] = ls_time
		dw_insert.object.crt_user[ll_r] = ls_user
	end if

	
	ll_xl_row ++
	
Loop

//MessageBox('확인',String(ll_r)+'건의 CLAIM DATA IMPORT 를 완료하였습니다.')

uo_xl.uf_excel_Disconnect()
dw_insert.AcceptText()
w_mdi_frame.sle_msg.Text = "DATA 를 저장 중입니다..........."
// 데이타 바루 저장 

If dw_insert.RowCount() < 1 Then Return

dw_insert.AcceptText()

IF dw_insert.Update()  = 1  THEN	
	COMMIT;
	w_mdi_frame.sle_msg.Text = "저장 되었습니다!"
	
	p_inq.TriggerEvent(Clicked!)
	
ELSE
	ROLLBACK;
	//messagebox('',sqlca.sqlerrText)
	f_message_chk(32, "[저장실패]")
	w_mdi_frame.sle_msg.Text = "저장작업 실패!"
END IF
w_mdi_frame.sle_msg.Text = String(ll_r)+'건의 CLAIM DATA IMPORT 를 완료하였습니다.'
MessageBox('확인',String(ll_r)+'건의 CLAIM DATA IMPORT 를 완료하였습니다.')

ib_any_typing = False //입력필드 변경여부 No


end event

type dw_1 from datawindow within w_sm10_0100
integer x = 27
integer y = 12
integer width = 3456
integer height = 172
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0100_1"
boolean border = false
boolean livescroll = true
end type

type pb_2 from u_pb_cal within w_sm10_0100
integer x = 681
integer y = 64
integer height = 76
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'sdate', gs_code)

end event

type pb_1 from u_pb_cal within w_sm10_0100
integer x = 1239
integer y = 64
integer height = 76
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'edate', gs_code)

end event

type rr_1 from roundrectangle within w_sm10_0100
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

