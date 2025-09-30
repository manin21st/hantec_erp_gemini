$PBExportHeader$w_sg_00010.srw
$PBExportComments$메뉴 관리
forward
global type w_sg_00010 from w_inherite
end type
type dw_2 from datawindow within w_sg_00010
end type
type rr_1 from roundrectangle within w_sg_00010
end type
type rr_2 from roundrectangle within w_sg_00010
end type
type dw_3 from datawindow within w_sg_00010
end type
type dw_4 from datawindow within w_sg_00010
end type
type dw_5 from datawindow within w_sg_00010
end type
type cb_1 from commandbutton within w_sg_00010
end type
type dw_print from datawindow within w_sg_00010
end type
type rb_1 from radiobutton within w_sg_00010
end type
type rb_2 from radiobutton within w_sg_00010
end type
type st_2 from statictext within w_sg_00010
end type
type st_3 from statictext within w_sg_00010
end type
type cb_2 from commandbutton within w_sg_00010
end type
type hpb_1 from hprogressbar within w_sg_00010
end type
type hpb_2 from hprogressbar within w_sg_00010
end type
type rr_3 from roundrectangle within w_sg_00010
end type
type dw_1 from datawindow within w_sg_00010
end type
type st_4 from statictext within w_sg_00010
end type
type st_5 from statictext within w_sg_00010
end type
type cbx_1 from checkbox within w_sg_00010
end type
end forward

global type w_sg_00010 from w_inherite
integer width = 4667
integer height = 3928
string title = "메뉴 관리"
dw_2 dw_2
rr_1 rr_1
rr_2 rr_2
dw_3 dw_3
dw_4 dw_4
dw_5 dw_5
cb_1 cb_1
dw_print dw_print
rb_1 rb_1
rb_2 rb_2
st_2 st_2
st_3 st_3
cb_2 cb_2
hpb_1 hpb_1
hpb_2 hpb_2
rr_3 rr_3
dw_1 dw_1
st_4 st_4
st_5 st_5
cbx_1 cbx_1
end type
global w_sg_00010 w_sg_00010

type variables
DataWindowChild idw_grp
DataWindowChild idw_sub

String is_sts
String is_user
end variables

forward prototypes
public function integer wf_mod ()
public subroutine wf_setfont ()
end prototypes

public function integer wf_mod ();dw_1.AcceptText()
dw_insert.AcceptText()

Long   ll_cnt1
Long   ll_cnt2

ll_cnt1 = dw_1.RowCount()
If ll_cnt1 < 1 Then Return -1

ll_cnt2 = dw_insert.RowCount()
If ll_cnt2 < 1 Then Return -1

Long   i
Long   l
Long   ll_chk1
Long   ll_chk2
Long   ll_chk3

String ls_main
String ls_sub1
String ls_sub2
String ls_get[]
String ls_user
String ls_chk

hpb_1.Visible = True
hpb_2.Visible = True
st_4.Visible = True
st_5.Visible = True

hpb_1.Position = 0
hpb_2.Position = 0
st_4.Text = ''
st_5.Text = ''

Long   ii, ll
For i = 0 To ll_cnt1
	i = dw_1.Find("chk = 'Y'", i, ll_cnt1)
	If i < 1 Then Exit
	
	ii++
Next

For l = 0 To ll_cnt2
	l = dw_insert.Find("chk = 'Y'", l, ll_cnt2)
	If l < 1 Then Exit
	
	ll++
Next

SetNull(i)
SetNull(l)

Long   a, b

a = 0
b = 0

For i = 1 To ll_cnt1
	ls_chk = dw_1.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		a++
	
		//업무단위
		ls_main = String(dw_1.GetItemNumber(i, 'main_id'))
		ls_sub1 = String(dw_1.GetItemNumber(i, 'sub1_id'))
		ls_sub2 = String(dw_1.GetItemNumber(i, 'sub2_id'))
		//중분류 디렉토리
		SELECT SUB2_ID   , SUB2_NAME
		  INTO :ls_get[1], :ls_get[2]
		  FROM SUB2_T
		 WHERE MAIN_ID  = :ls_main
			AND SUB1_ID  = :ls_sub1
			AND IO_GUBUN = 'A'         ;
		If SQLCA.SQLCODE <> 0 Then
			hpb_1.Visible = False
			hpb_2.Visible = False
			
			st_4.Visible = False
			st_5.Visible = False
			MessageBox('Select Error - MID', 'Select Error' + String(SQLCA.SQLCODE) + '~r~n~n' + ls_main + ' -> ' + ls_sub1)
			Return -1
		End If
		//대분류 디렉토리
		SELECT SUB1_ID   , SUB2_ID   , SUB2_NAME
		  INTO :ls_get[3], :ls_get[4], :ls_get[5]
		  FROM SUB2_T
		 WHERE MAIN_ID  =  :ls_main
			AND SUB1_ID  <> '0'
			AND SUB2_ID  <> '0'
			AND IO_GUBUN =  'T'         ;
		If SQLCA.SQLCODE <> 0 Then
			hpb_1.Visible = False
			hpb_2.Visible = False
			
			st_4.Visible = False
			st_5.Visible = False
			MessageBox('Select Error - GRP', 'Select Error' + String(SQLCA.SQLCODE) + '~r~n~n' + ls_main)
			Return -1
		End If
		//업무분류 디렉토리
		SELECT SUB2_NAME, WINDOW_NAME
		  INTO :ls_get[6], :ls_get[7]
		  FROM SUB2_T
		 WHERE MAIN_ID = :ls_main
			AND SUB1_ID = :ls_sub1
			AND SUB2_ID = :ls_sub2     ;
		If SQLCA.SQLCODE <> 0 Then
			hpb_1.Visible = False
			hpb_2.Visible = False
			
			st_4.Visible = False
			st_5.Visible = False
			MessageBox('Select Error - WIN', 'Select Error' + String(SQLCA.SQLCODE) + '~r~n~n' + ls_main + ' -> ' + ls_sub1 + ' -> ' + ls_sub2)
			Return -1
		End If
		
		SetNull(ls_chk)
		For l = 1 To ll_cnt2
			ls_chk = dw_insert.GetItemString(l, 'chk')
			If ls_chk = 'Y' Then
				b++
				
				ls_user = dw_insert.GetItemString(l, 'empno')
				
				//기존 Window Code 삭제
				SELECT COUNT('X')
				  INTO :ll_chk1
				  FROM SUB2_USER_T
				 WHERE USER_ID     = :ls_user
					AND WINDOW_NAME = :ls_get[7]  ;
				If SQLCA.SQLCODE <> 0 Then
					hpb_1.Visible = False
					hpb_2.Visible = False
					
					st_4.Visible = False
					st_5.Visible = False
					MessageBox('Select Error - Wincod', 'Select Error' + String(SQLCA.SQLCODE))
					Return -1
				End If
				If ll_chk1 > 0 Then
					DELETE SUB2_USER_T
					 WHERE USER_ID     = :ls_user
						AND WINDOW_NAME = :ls_get[7]  ;
					If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA;
						hpb_1.Visible = False
						hpb_2.Visible = False
						
						st_4.Visible = False
						st_5.Visible = False
						MessageBox('기존Window 삭제', '기존 자료 삭제 중 오류가 발생 했습니다.')
						Return -1
					End If
				End If
				
				//대분류 디렉토리 확인
				SELECT COUNT('X')
				  INTO :ll_chk2
				  FROM SUB2_USER_T
				 WHERE USER_ID = :ls_user
					AND MAIN_ID = :ls_main
					AND SUB1_ID = :ls_get[3]
					AND SUB2_ID = :ls_get[4] ;
				If SQLCA.SQLCODE <> 0 Then
					hpb_1.Visible = False
					hpb_2.Visible = False
					
					st_4.Visible = False
					st_5.Visible = False
					MessageBox('Select Error - Grpcod', 'Select Error' + String(SQLCA.SQLCODE))
					Return -1
				End If
				If ll_chk2 < 1 Then
					INSERT INTO SUB2_USER_T ( USER_ID, MAIN_ID, SUB1_ID, SUB2_ID, SUB2_NAME )
					VALUES ( :ls_user, :ls_main, :ls_get[3], :ls_get[4], :ls_get[5] ) ;
					If SQLCA.SQLCODE <> 0 Then 
						ROLLBACK USING SQLCA;
						hpb_1.Visible = False
						hpb_2.Visible = False
						
						st_4.Visible = False
						st_5.Visible = False
						MessageBox('대분류 추가', '대분류 추가 작업 중 오류가 발생 했습니다.')
						Return -1
					End If
				End If
				
				//중분류 디렉토리 확인
				SELECT COUNT('X')
				  INTO :ll_chk3
				  FROM SUB2_USER_T
				 WHERE USER_ID = :ls_user
					AND MAIN_ID = :ls_main
					AND SUB1_ID = :ls_sub1
					AND SUB2_ID = :ls_get[1]  ;
				If SQLCA.SQLCODE <> 0 Then
					hpb_1.Visible = False
					hpb_2.Visible = False
					
					st_4.Visible = False
					st_5.Visible = False
					MessageBox('Select Error - MIDcod', 'Select Error' + String(SQLCA.SQLCODE))
					Return -1
				End If
				If ll_chk3 < 1 Then
					INSERT INTO SUB2_USER_T ( USER_ID, MAIN_ID, SUB1_ID, SUB2_ID, SUB2_NAME )
					VALUES ( :ls_user, :ls_main, :ls_sub1, :ls_get[1], :ls_get[2] ) ;
					If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA;
						hpb_1.Visible = False
						hpb_2.Visible = False
						
						st_4.Visible = False
						st_5.Visible = False
						MessageBox('중분류 추가', '중분류 추가 작업 중 오류가 발생 했습니다.')
						Return -1
					End If
				End If
				
				//업무 디렉토리 확인
				INSERT INTO SUB2_USER_T ( USER_ID, MAIN_ID, SUB1_ID, SUB2_ID, SUB2_NAME, WINDOW_NAME )
				VALUES ( :ls_user, :ls_main, :ls_sub1, :ls_sub2, :ls_get[6], :ls_get[7] ) ;
				If SQLCA.SQLCODE <> 0 Then
					Messagebox(String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
					ROLLBACK USING SQLCA;
					hpb_1.Visible = False
					hpb_2.Visible = False
					
					st_4.Visible = False
					st_5.Visible = False
					MessageBox('업무분류 추가', '업무분류 추가 작업 중 오류가 발생 했습니다.')
					Return -1
				End If
				st_4.Text = String(b) + ' / ' + String(ll)
				hpb_1.Position = (b/ll) * 100
			End If
		Next
		b = 0
		st_5.Text = String(a) + ' / ' + String(ii)
		hpb_2.Position = (a/ii) * 100
	End If
Next

hpb_1.Visible = False
hpb_2.Visible = False

st_4.Visible = False
st_5.Visible = False

Return 1
end function

public subroutine wf_setfont ();WindowObject l_object[]
Long i
gstr_object_chg lstr_object		
For i = 1 To UpperBound(Control[])
	l_object[i] = Control[i]
	lstr_object.lu_object[i] = l_object[i]	//Window Object
	lstr_object.li_obj = i						//Window Object 갯수
Next
f_change_font(lstr_object)
end subroutine

on w_sg_00010.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_3=create dw_3
this.dw_4=create dw_4
this.dw_5=create dw_5
this.cb_1=create cb_1
this.dw_print=create dw_print
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_2=create st_2
this.st_3=create st_3
this.cb_2=create cb_2
this.hpb_1=create hpb_1
this.hpb_2=create hpb_2
this.rr_3=create rr_3
this.dw_1=create dw_1
this.st_4=create st_4
this.st_5=create st_5
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.rr_1
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.dw_3
this.Control[iCurrent+5]=this.dw_4
this.Control[iCurrent+6]=this.dw_5
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.dw_print
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.rb_2
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.hpb_1
this.Control[iCurrent+15]=this.hpb_2
this.Control[iCurrent+16]=this.rr_3
this.Control[iCurrent+17]=this.dw_1
this.Control[iCurrent+18]=this.st_4
this.Control[iCurrent+19]=this.st_5
this.Control[iCurrent+20]=this.cbx_1
end on

on w_sg_00010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.dw_5)
destroy(this.cb_1)
destroy(this.dw_print)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_2)
destroy(this.hpb_1)
destroy(this.hpb_2)
destroy(this.rr_3)
destroy(this.dw_1)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.cbx_1)
end on

event open;call super::open;This.PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_3.GetChild('upmu', idw_grp)

idw_grp.SetTransObject(SQLCA)

dw_3.InsertRow(0)

If idw_grp.Retrieve('%') < 1 Then
	dw_3.SetItem(1, 'upmu', '%')
End If

dw_4.GetChild('upmu', idw_sub)

idw_sub.SetTransObject(SQLCA)

dw_4.InsertRow(0)

If idw_sub.Retrieve('%', '%') < 1 Then
	dw_4.SetItem(1, 'upmu', '%')
End If

dw_insert.SetRedraw(False)
dw_insert.Retrieve('%')
dw_insert.SetRedraw(True)

is_sts = '1'
end event

type dw_insert from w_inherite`dw_insert within w_sg_00010
integer x = 3296
integer y = 384
integer width = 1312
integer height = 1720
string dataobject = "d_sg_00010_003"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::constructor;call super::constructor;This.SetTransObject(SQLCA)

end event

event dw_insert::clicked;call super::clicked;If row < 1 Then Return

This.SelectRow(0, False)
This.SetRow(row)
This.SelectRow(row, True)
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SetRow(currentrow)
This.SelectRow(currentrow, True)
end event

type p_delrow from w_inherite`p_delrow within w_sg_00010
boolean visible = false
integer x = 2661
integer y = 2536
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_sg_00010
boolean visible = false
integer x = 2487
integer y = 2536
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_sg_00010
boolean visible = false
integer x = 1952
integer y = 2532
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_sg_00010
boolean visible = false
integer x = 2313
integer y = 2536
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sg_00010
end type

type p_can from w_inherite`p_can within w_sg_00010
boolean visible = false
integer x = 3182
integer y = 2536
boolean enabled = false
end type

type p_print from w_inherite`p_print within w_sg_00010
boolean visible = false
integer x = 3141
integer y = 28
boolean enabled = false
end type

event p_print::clicked;call super::clicked;If dw_print.RowCount() < 1 Then Return

OpenWithParm(w_print_preview, dw_print)

end event

type p_inq from w_inherite`p_inq within w_sg_00010
integer x = 3922
end type

event p_inq::clicked;call super::clicked;dw_2.AcceptText()
dw_3.AcceptText()
dw_4.AcceptText()

Long   r1
Long   r2
Long   r3

r1 = dw_2.GetRow()
If r1 < 1 Then Return

r2 = dw_3.GetRow()
If r2 < 1 Then Return

r3 = dw_4.GetRow()
If r3 < 1 Then Return

String ls_upmu

ls_upmu = dw_2.GetItemString(r1, 'upmu')
If Trim(ls_upmu) = '' OR IsNull(ls_upmu) Then 
	ls_upmu = '%'
Else
	Choose Case ls_upmu
		Case '10'
			ls_upmu = 'A'
		Case '20'
			ls_upmu = 'P'
		Case '50'
			ls_upmu = 'M'
		Case '99'
			ls_upmu = 'C'
	End Choose
End If

String ls_grp

ls_grp = dw_3.GetItemString(r2, 'upmu')
If Trim(ls_grp) = '' OR IsNull(ls_grp) Then ls_grp = '%'

String ls_sub

ls_sub = dw_4.GetItemString(r3, 'upmu')
If Trim(ls_sub) = '' OR IsNull(ls_sub) Then ls_sub = '%'

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_upmu, ls_grp, ls_sub)
dw_1.SetRedraw(True)

If dw_1.RowCount() < 1 Then Return

dw_1.ShareData(dw_print)

Long   ll_pos
Long   ll_ret

String ls_dept

ls_dept = dw_5.GetItemString(1, 'dept')		
If Trim(ls_dept) = '' OR IsNull(ls_dept) Then 
	ls_dept = '%'
Else
	ll_pos = POS(ls_dept, '0') - 1
	
	ls_dept = LEFT(ls_dept, ll_pos) + '%'
End If	

dw_insert.SetRedraw(False)
dw_insert.Retrieve(ls_dept)
dw_insert.SetRedraw(True)

end event

type p_del from w_inherite`p_del within w_sg_00010
integer x = 4270
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;//messagebox('삭제기능 보류..', '음.. 삭제기능이 아직 완성되지 않았네여.. ∼<>∼')
dw_1.AcceptText()
dw_insert.AcceptText()

//===============================================================
Long   ll_cnt1
Long   ll_cnt2

ll_cnt1 = dw_1.RowCount()
If ll_cnt1 < 1 Then Return

ll_cnt2 = dw_insert.RowCount()
If ll_cnt2 < 1 Then Return

//===============================================================

If f_msg_delete() < 1 Then Return

//===============================================================
Long   ll_find

ll_find = dw_1.FIND("chk = 'Y'", 1, ll_cnt1)
If ll_find < 1 Then
	MessageBox('선택여부', '선택된 메뉴가 없습니다.')
	Return
End If

SetNull(ll_find)

ll_find = dw_insert.FIND("chk = 'Y'", 1, ll_cnt2)
If ll_find < 1 Then 
	MessageBox('선택여부', '선택된 사용자가 없습니다.')
	Return
End If

//===============================================================

//===============================================================
Long   i
Long   l
Long   ll_cnt

String ls_chk
String ls_user
String ls_main
String ls_sub1
String ls_sub2
String ls_get[]

hpb_1.Visible = True
hpb_2.Visible = True
st_4.Visible = True
st_5.Visible = True

hpb_1.Position = 0
hpb_2.Position = 0
st_4.Text = ''
st_5.Text = ''

Long   ii, ll
For i = 0 To ll_cnt1
	i = dw_1.Find("chk = 'Y'", i, ll_cnt1)
	If i < 1 Then Exit
	
	ii++
Next

For l = 0 To ll_cnt2
	l = dw_insert.Find("chk = 'Y'", l, ll_cnt2)
	If l < 1 Then Exit
	
	ll++
Next

Long   a
Long   b

a = 0
b = 0

For i = 1 To ll_cnt1
	ls_chk = dw_1.GetItemString(i, 'chk')
	If ls_chk = 'Y' Then
		a++
		ls_main = String(dw_1.GetItemNumber(i, 'main_id'))
		ls_sub1 = String(dw_1.GetItemNumber(i, 'sub1_id'))
		ls_sub2 = String(dw_1.GetItemNumber(i, 'sub2_id'))
		
		SetNull(ls_chk)
		For l = 1 To ll_cnt2
			ls_chk = dw_insert.GetItemString(l, 'chk')
			If ls_chk = 'Y' Then
				b++
				ls_user = dw_insert.GetItemString(l, 'empno')
				
				SELECT COUNT('X')
				  INTO :ll_cnt
				  FROM SUB2_USER_T
				 WHERE USER_ID = :ls_user
				   AND MAIN_ID = :ls_main
					AND SUB1_ID = :ls_sub1
					AND SUB2_ID = :ls_sub2 ;
				If ll_cnt > 0 Then
					DELETE SUB2_USER_T
					 WHERE USER_ID = :ls_user
				      AND MAIN_ID = :ls_main
					   AND SUB1_ID = :ls_sub1
					   AND SUB2_ID = :ls_sub2 ;
					If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA;
						hpb_1.Visible = False
						hpb_2.Visible = False
						st_4.Visible = False
                  st_5.Visible = False
						MessageBox('저장실패', '자료 삭제 중 오류가 발생 했습니다.')
						Return
					End If
					
					/* 상위 MENU 확인 */
					SetNull(ll_cnt)
					SELECT COUNT('X')
					  INTO :ll_cnt
				     FROM SUB2_USER_T
	             WHERE USER_ID =  :ls_user
              	   AND MAIN_ID =  :ls_main
	               AND SUB1_ID =  :ls_sub1
	               AND SUB2_ID <> '100'    ;
					If ll_cnt < 1 Then
						DELETE SUB2_USER_T
						 WHERE USER_ID = :ls_user
						   AND MAIN_ID = :ls_main
							AND SUB1_ID = :ls_sub1
							AND SUB2_ID = '100'    ;
						If SQLCA.SQLCODE <> 0 Then
							ROLLBACK USING SQLCA;
							hpb_1.Visible = False
							hpb_2.Visible = False
							st_4.Visible = False
							st_5.Visible = False
							MessageBox('저장실패', '자료 삭제 중 오류가 발생 했습니다.')
							Return
						End If
					End If
					
					/* 상위 MENU 확인 */
					SetNull(ll_cnt)
					SELECT COUNT('X')
					  INTO :ll_cnt
				     FROM SUB2_USER_T
	             WHERE USER_ID =  :ls_user
              	   AND MAIN_ID =  :ls_main
	               AND SUB1_ID <> '99'
	               AND SUB2_ID <> '99'    ;
					If ll_cnt < 1 Then
						DELETE SUB2_USER_T
						 WHERE USER_ID = :ls_user
						   AND MAIN_ID = :ls_main
							AND SUB1_ID = '99'
							AND SUB2_ID = '99'    ;
						If SQLCA.SQLCODE <> 0 Then
							ROLLBACK USING SQLCA;
							hpb_1.Visible = False
							hpb_2.Visible = False
							st_4.Visible = False
							st_5.Visible = False
							MessageBox('저장실패', '자료 삭제 중 오류가 발생 했습니다.')
							Return
						End If
					End If	
				End If
				st_4.Text = String(b) + ' / ' + String(ll)
				hpb_1.Position = (b/ll) * 100
			End If
		Next
		b = 0
		ls_chk = 'N'
		st_5.Text = String(a) + ' / ' + String(ii)
		hpb_2.Position = (a/ii) * 100
	End If
Next

hpb_1.Visible = False
hpb_2.Visible = False

st_4.Visible = False
st_5.Visible = False

If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('성공', '성공적으로 처리 되었습니다.')
Else
	ROLLBACK USING SQLCA;
   MessageBox('저장실패', '자료 삭제 중 오류가 발생했습니다.')
End If
	
			

end event

type p_mod from w_inherite`p_mod within w_sg_00010
integer x = 4096
end type

event p_mod::clicked;call super::clicked;If f_msg_update() < 1 Then Return

If wf_mod() < 1 Then
	MessageBox('저장 실패', '저장에 실패 했습니다.')
Else
	COMMIT USING SQLCA;
	MessageBox('저장 성공', '저장에 성공 했습니다.')
End If

end event

type cb_exit from w_inherite`cb_exit within w_sg_00010
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sg_00010
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_sg_00010
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_sg_00010
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sg_00010
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sg_00010
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sg_00010
end type

type cb_can from w_inherite`cb_can within w_sg_00010
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sg_00010
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_sg_00010
boolean enabled = false
end type

type sle_msg from w_inherite`sle_msg within w_sg_00010
boolean enabled = false
end type

type gb_10 from w_inherite`gb_10 within w_sg_00010
boolean enabled = false
end type

type gb_button1 from w_inherite`gb_button1 within w_sg_00010
boolean enabled = false
end type

type gb_button2 from w_inherite`gb_button2 within w_sg_00010
boolean enabled = false
end type

type dw_2 from datawindow within w_sg_00010
integer x = 23
integer y = 20
integer width = 1038
integer height = 172
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sg_00010_101"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event itemchanged;If row < 1 Then Return

dw_3.GetChild('upmu', idw_grp)

idw_grp.SetTransObject(SQLCA)

If Trim(data) = '' OR IsNull(data) Then
	idw_grp.Retrieve('%')
Else
	If data = '10' Then
		idw_grp.Retrieve('A')
	ElseIf data = '20' Then
		idw_grp.Retrieve('P')
	ElseIf data = '50' Then
		idw_grp.Retrieve('M')
	ElseIf data = '99' Then
		idw_grp.Retrieve('C')
	End If
End If
end event

type rr_1 from roundrectangle within w_sg_00010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 200
integer width = 3246
integer height = 2012
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sg_00010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 3282
integer y = 372
integer width = 1339
integer height = 1840
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_3 from datawindow within w_sg_00010
integer x = 1042
integer y = 20
integer width = 1038
integer height = 172
integer taborder = 50
string title = "none"
string dataobject = "d_sg_00010_102"
boolean border = false
boolean livescroll = true
end type

event itemchanged;dw_4.GetChild('upmu', idw_sub)

idw_sub.SetTransObject(SQLCA)

dw_4.InsertRow(0)

String ls_upmu

ls_upmu = dw_2.GetItemString(1, 'upmu')
Choose Case ls_upmu
	Case '10'
		ls_upmu = 'A'
	Case '20'
		ls_upmu = 'P'
	Case '50'
		ls_upmu = 'M'
	Case '99'
		ls_upmu = 'C'
End Choose

If idw_sub.Retrieve(ls_upmu, data) < 1 Then
	dw_4.SetItem(1, 'upmu', '%')
End If

end event

type dw_4 from datawindow within w_sg_00010
integer x = 2062
integer y = 20
integer width = 1079
integer height = 172
integer taborder = 60
string title = "none"
string dataobject = "d_sg_00010_103"
boolean border = false
boolean livescroll = true
end type

event constructor;//This.SetTransObject(SQLCA)
//This.InsertRow(0)
end event

type dw_5 from datawindow within w_sg_00010
integer x = 3282
integer y = 200
integer width = 1344
integer height = 160
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_sg_00010_104"
boolean border = false
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
This.InsertRow(0)
end event

event itemchanged;If row < 1 Then Return

This.AcceptText()

Choose Case dwo.name
	Case 'dept'
		Long   ll_pos
		Long   ll_ret
		
		String ls_dept
				
		If Trim(data) = '' OR IsNull(data) Then 
			ls_dept = '%'
		Else
			ll_pos = POS(data, '0') - 1
			
			ls_dept = LEFT(data, ll_pos) + '%'
		End If	
		
		dw_insert.SetRedraw(False)
		dw_insert.Retrieve(ls_dept)
		dw_insert.SetRedraw(True)
End Choose



end event

type cb_1 from commandbutton within w_sg_00010
integer x = 4215
integer y = 236
integer width = 352
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "사용자복사"
end type

event clicked;Long   ll_cnt

ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

Long   ll_find

ll_find = dw_insert.FIND("chk = 'Y'", 1, ll_cnt)
If ll_find < 1 Then
	MessageBox('대상선택', '기준 사용자를 선택 하십시오.')
	Return
End If

Long   i
Long   ii

ii = 0

String ls_chk

Choose Case is_sts
	Case '1'
		For i = 1 To ll_cnt
			ls_chk = dw_insert.GetItemString(i, 'chk')
			
			If ls_chk = 'Y' Then
				ii++
				If ii > 1 Then 
					MessageBox('다중선택', '기준 사용자는 1명만 선택하십시오.')
					Return
				End If
				is_user = dw_insert.GetItemString(i, 'sub2_user_t_empno')
				
			End If
		Next
		cb_1.Text = '대상선택'
		is_sts    = '2'
		
		For i = 1 To ll_cnt
			dw_insert.SetItem(i, 'chk', 'N')
		Next
		
	Case '2'
		String ls_user
		
		For i = 1 To ll_cnt
			ls_chk = dw_insert.GetItemString(i, 'chk')
			If ls_chk = 'Y' Then
				ls_user = dw_insert.GetItemString(i, 'sub2_user_t_empno')
				
				DELETE SUB2_USER_T
				 WHERE USER_ID = :ls_user;
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA;
					MessageBox('갱신실패', '자료 복사 중 오류가 발생했습니다.')
					Return
				End If
				
				INSERT INTO SUB2_USER_T ( USER_ID, MAIN_ID, SUB1_ID, SUB2_ID, SUB2_NAME, WINDOW_NAME )
				SELECT :ls_user   ,
						 MAIN_ID    ,
						 SUB1_ID    ,
						 SUB2_ID    ,
						 SUB2_NAME  ,
						 WINDOW_NAME
				  FROM SUB2_USER_T
				 WHERE USER_ID = :is_user ;
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA;
					MessageBox('저장실패', '자료 저장 중 오류가 발생했습니다.')
					Return
				End If
			End If
		Next
		
		If SQLCA.SQLCODE = 0 Then
			COMMIT USING SQLCA;
			MessageBox('저장성공', '저장 되었습니다.')
		Else
			ROLLBACK USING SQLCA;
			MessageBox('저장실패', '자료 저장 중 오류가 발생했습니다.')
			Return
		End If
		
		cb_1.Text = '사용자복사'
		is_sts    = '1'
		
		For i = 1 To ll_cnt
			dw_insert.SetItem(i, 'chk', 'N')
		Next
End Choose
		



end event

type dw_print from datawindow within w_sg_00010
boolean visible = false
integer x = 3337
integer y = 32
integer width = 151
integer height = 132
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_sg_00010_002_p"
boolean livescroll = true
end type

type rb_1 from radiobutton within w_sg_00010
integer x = 3639
integer y = 44
integer width = 215
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "등록"
boolean checked = true
end type

event clicked;If This.Checked = True Then
	p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
	p_del.Enabled     = False
	p_inq.PictureName = 'C:\erpman\image\조회_up.gif'
	p_inq.Enabled     = True
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
	p_mod.Enabled     = True
	
	dw_2.SetTabOrder('upmu', 10)
	dw_3.SetTabOrder('upmu', 10)
	dw_4.SetTabOrder('upmu', 10)
	
	dw_2.Modify('upmu.background.color=16777215')
	dw_3.Modify('upmu.background.color=16777215')
	dw_4.Modify('upmu.background.color=16777215')
End If
end event

type rb_2 from radiobutton within w_sg_00010
integer x = 3639
integer y = 108
integer width = 219
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "삭제"
end type

event clicked;If This.Checked = True Then
	p_del.PictureName = 'C:\erpman\image\삭제_up.gif'
	p_del.Enabled     = True
//	p_inq.PictureName = 'C:\erpman\image\조회_d.gif'
//	p_inq.Enabled     = False
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_mod.Enabled     = False
	
//	dw_2.SetTabOrder('upmu', 0)
//	dw_3.SetTabOrder('upmu', 0)
//	dw_4.SetTabOrder('upmu', 0)
//	
//	dw_2.Modify('upmu.background.color=32106727')
//	dw_3.Modify('upmu.background.color=32106727')
//	dw_4.Modify('upmu.background.color=32106727')
//	
//	dw_2.SetItem(1, 'upmu', '%')
//	dw_3.SetItem(1, 'upmu', '%')
//	dw_4.SetItem(1, 'upmu', '%')
	
	dw_1.ReSet()
End If
end event

type st_2 from statictext within w_sg_00010
integer x = 3328
integer y = 2108
integer width = 1111
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "* 사용자가 나타나지 않을 경우"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sg_00010
integer x = 3383
integer y = 2156
integer width = 782
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "사용자 등록을 먼저 하십시오."
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_sg_00010
integer x = 3319
integer y = 44
integer width = 256
integer height = 92
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "전체선택"
end type

event clicked;If dw_1.RowCount() < 1 Then Return

Long   i
For i = 1 To dw_1.RowCount()
	dw_1.SetItem(i, 'chk', 'Y')
Next
end event

type hpb_1 from hprogressbar within w_sg_00010
boolean visible = false
integer x = 974
integer y = 904
integer width = 2267
integer height = 108
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
end type

type hpb_2 from hprogressbar within w_sg_00010
boolean visible = false
integer x = 974
integer y = 1148
integer width = 2267
integer height = 108
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
end type

type rr_3 from roundrectangle within w_sg_00010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 3589
integer y = 24
integer width = 315
integer height = 160
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_sg_00010
integer x = 37
integer y = 212
integer width = 3218
integer height = 1988
integer taborder = 120
string title = "none"
string dataobject = "d_sg_00010_002"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

event rowfocuschanged;If currentrow < 1 Then Return

This.SelectRow(0, False)
This.SetRow(currentrow)
This.SelectRow(currentrow, True)
end event

event clicked;If row < 1 Then Return

This.SelectRow(0, False)
This.SetRow(row)
This.SelectRow(row, True)
end event

type st_4 from statictext within w_sg_00010
boolean visible = false
integer x = 992
integer y = 800
integer width = 809
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = script!
string facename = "은진"
long textcolor = 255
long backcolor = 32106727
boolean focusrectangle = false
boolean disabledlook = true
end type

type st_5 from statictext within w_sg_00010
boolean visible = false
integer x = 992
integer y = 1044
integer width = 809
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = script!
string facename = "은진"
long textcolor = 255
long backcolor = 32106727
boolean focusrectangle = false
boolean disabledlook = true
end type

type cbx_1 from checkbox within w_sg_00010
integer x = 3319
integer y = 392
integer width = 201
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16777215
long backcolor = 28144969
string text = "선택"
end type

event clicked;Long   i

For i = 1 To dw_insert.RowCount()
	If dw_insert.GetItemString(i, 'chk') = 'N' Then
		dw_insert.SetItem(i, 'chk', 'Y')
	Else
		dw_insert.SetItem(i, 'chk', 'N')
	End If
	
Next
end event

