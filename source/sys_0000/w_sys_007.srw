$PBExportHeader$w_sys_007.srw
$PBExportComments$USER별 프로그램 등록
forward
global type w_sys_007 from w_inherite
end type
type st_2 from statictext within w_sys_007
end type
type sle_user from singlelineedit within w_sys_007
end type
type gb_1 from groupbox within w_sys_007
end type
type cb_refresh from commandbutton within w_sys_007
end type
type dw_insert_all from datawindow within w_sys_007
end type
type dw_user_all from datawindow within w_sys_007
end type
type dw_1 from datawindow within w_sys_007
end type
type dw_user from u_key_enter within w_sys_007
end type
type p_1 from picture within w_sys_007
end type
type st_3 from statictext within w_sys_007
end type
type st_4 from statictext within w_sys_007
end type
type st_5 from statictext within w_sys_007
end type
type rr_1 from roundrectangle within w_sys_007
end type
type rr_2 from roundrectangle within w_sys_007
end type
type rr_3 from roundrectangle within w_sys_007
end type
end forward

global type w_sys_007 from w_inherite
integer height = 2476
string title = "USER별 프로그램 등록"
st_2 st_2
sle_user sle_user
gb_1 gb_1
cb_refresh cb_refresh
dw_insert_all dw_insert_all
dw_user_all dw_user_all
dw_1 dw_1
dw_user dw_user
p_1 p_1
st_3 st_3
st_4 st_4
st_5 st_5
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_sys_007 w_sys_007

type variables
datawindow  dw_source, dw_target
int            drag_start_row, drag_end_row, oldrow
String       drag_start_col
boolean    ib_down
end variables

forward prototypes
public function integer wf_create_sub (integer srow, integer erow, integer nsub1id)
public function integer wf_create_middle (integer srow, integer erow, integer nmainid, integer nsub1id, string subyn)
public function integer wf_renumbering (integer nmainid, integer nsub1id)
public function integer wf_find_next (datawindow dwo, string scolname)
public function integer wf_delete_row (integer nrow)
public function integer wf_copy_to_target (integer srow, integer erow)
public function string wf_filter (datawindow dwo, integer row, boolean gb)
public function integer wf_copy_row (integer srow, integer erow, integer nmainid, integer nsub1id)
end prototypes

public function integer wf_create_sub (integer srow, integer erow, integer nsub1id);Integer  nSub2Id
Long ix, nRow

nRow = eRow

/* 대분류안에 포함된 중분류 생성 */
For ix = srow to dw_source.RowCount()
	If dw_source.GetItemNumber(ix, 'sub1_id') <> nSub1Id Then Exit
	
	nSub2Id = dw_source.GetItemNumber(ix, 'sub2_id')
	If nSub2Id <> 100 And nSub2Id <> 99 Then //중분류이면...
		nRow = wf_copy_row(ix, nRow, dw_source.GetItemNumber(ix, 'main_id'), nSub1Id )		
	End If
Next

Return nRow

end function

public function integer wf_create_middle (integer srow, integer erow, integer nmainid, integer nsub1id, string subyn);Integer  nSub2Id
Long ix, nRow

nRow = eRow

/* 중분류코드가 0이면 대분류안의 모든 중분류 생성 */
/* 중분류코드가 0이아니면  해당 중분류만 생성 */

For ix = srow to dw_source.RowCount()
	If dw_source.GetItemNumber(ix, 'main_id') <> nMainId Then Exit
	If nSub1Id <> 0 Then
		If nSub1Id <> dw_source.GetItemNumber(ix, 'sub1_id') Then Exit
	End If

	nSub2Id = dw_source.GetItemNumber(ix, 'sub2_id')
	If nSub2Id = 100 Then //중분류이면...생성

		nRow = wf_copy_row(ix, nrow, nMainId, dw_source.GetItemNumber(ix, 'sub1_id') )
		
		/* 프로그램 생성 */
		If subYN = 'Y' Then
			nRow = wf_create_sub(ix , nRow, dw_source.GetItemNumber(ix, 'sub1_id'))
		End If
	End If
Next

Return nRow

end function

public function integer wf_renumbering (integer nmainid, integer nsub1id);/* 대분류,중분류에 속한 메뉴에 대해 재배열 한다 */
Long nStep, nCnt, nRow, ix
Long nMainId1_t, nSub1Id_t
String sUser

sUser = Trim(sle_user.Text)
If IsNull(sUser) or sUser = '' Then
	f_message_chk(1400,'[USER]')
	dw_target.Reset()
End If

nStep = 5 //증가율

nCnt = dw_target.RowCount()
If nCnt <= 0 Then Return 0

nRow = dw_target.Find("main_id = " + string(nMainId) + " and sub1_id = " + string(nSub1Id),1, nCnt)
DO WHILE nRow > 0

   dw_target.SetItem(nRow,'user_id',sUser)

	Choose Case dw_target.GetItemNumber(nRow,'sub2_id')
		Case 99,100
		Case Else
		   dw_target.SetItem(nRow, 'sub2_id',nStep)
		   nStep += 5
			If nStep = 100 Then nStep += 5
	End Choose
	
	nRow++

	IF nRow > nCnt THEN EXIT
	nRow = dw_target.Find("main_id = " + string(nMainId) + " and sub1_id = " + string(nSub1Id),nRow, nCnt)
LOOP

Return 1
end function

public function integer wf_find_next (datawindow dwo, string scolname);Long nRow, nCnt, nMainId, nSub1Id

If dwo.RowCount() < 0 Then Return 0

nCnt = dwo.RowCount()
nRow = dwo.GetRow()
If nRow <=0 Then nRow = 1

nMainId = dwo.GetItemNumber(nRow,'main_id')
nSub1Id = dwo.GetItemNumber(nRow,'sub1_id')

Choose Case sColName
	Case 'tit1_t' // 대분류 
		nRow = dwo.Find('main_id <> ' + string(nMainId), nRow, nCnt)
	Case 'tit2_t' // 중분류
		nRow = dwo.Find('sub1_id <> ' + string(nSub1Id), nRow, nCnt)
End Choose

If nRow > 0 Then
	dwo.SetFocus()
	dwo.ScrollToRow(nRow)
	dwo.SelectRow(0,False)
	dwo.SelectRow(nRow,True)
End If

Return 0
end function

public function integer wf_delete_row (integer nrow);Long nMainId, nSub1Id, nSub2Id
String sSubName, sUserId

If dw_user.RowCount() < nRow Then Return 0

/* 삭제할 실제 row */
nRow = dw_user.GetItemNumber(nrow,'seq')
nRow = dw_user_all.Find("seq = " + String(nRow),1, dw_user_all.RowCount())

nMainId  = dw_user_all.GetItemNumber(nRow, 'main_id')
nSub1Id  = dw_user_all.GetItemNumber(nRow, 'sub1_id')
nSub2Id  = dw_user_all.GetItemNumber(nRow, 'sub2_id')
sSubName = dw_user_all.GetItemString(nRow, 'sub2_name')
sUserId  = dw_user_all.GetItemString(nRow, 'user_id')

If nSub1Id = 99 Then	
   IF MessageBox("대분류 삭 제",sSubName + "의 하위메뉴가 삭제됩니다." +"~n~n" +&
              	  "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN 0

   Delete from sub2_user_t
	 where user_id = :sUserId and
	       main_id = :nMainId;

ElseIf nSub2Id = 100 Then	
   IF MessageBox("중분류 삭 제",sSubName + "의 하위메뉴가 삭제됩니다." +"~n~n" +&
              	  "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN 0

   Delete from sub2_user_t
	 where user_id = :sUserId and
	       main_id = :nMainId and
			 sub1_id = :nSub1Id;
Else
   Delete from sub2_user_t
	 where user_id = :sUserId and
	       main_id = :nMainId and
			 sub1_id = :nSub1Id and
			 sub2_id = :nSub2Id;
			
End If

If sqlca.sqlcode <> 0 Then
	RollBack;
	MessageBox('확 인','삭제에 실패하였습니다')
	sle_user.Text = ''
	dw_user_all.Reset()
Else
	Commit;
End If

dw_user_all.DeleteRow(nRow)

Return 0
end function

public function integer wf_copy_to_target (integer srow, integer erow);Long  nMainId, nSub1Id, nSub2Id
Long  nMainId_t, nSub1Id_t, nSub2Id_t
Long  nRtn, nRow, ix
String sSub2Name, sWindowName, sFilter

If dw_source.RowCount() <=0 Then Return 0

SetPointer(HourGlass!)

/* dw_source */
nMainId     = dw_source.GetItemNumber(srow,'main_id')
nSub1Id     = dw_source.GetItemNumber(srow,'sub1_id')
nSub2Id     = dw_source.GetItemNumber(srow,'sub2_id')
sSub2Name   = dw_source.GetItemString(srow,'sub2_name')
sWindowName = dw_source.GetItemString(srow,'window_name')

/* target */
If erow > 0 Then
	nMainId_t = dw_target.GetItemNumber(erow,'main_id')
	nSub1Id_t = dw_target.GetItemNumber(erow,'sub1_id')
	nSub2Id_t = dw_target.GetItemNumber(erow,'sub2_id')
End If

/* 조회후 filter string */
sFilter = wf_filter(dw_user,erow,False)

/* 대분류를 드래그 */
If nSub2Id = 99 Then
	If dw_source = dw_target Then Return 0
	
	/* 중복여부 */
	nRow = dw_target.Find("main_id = " + string(nMainId),1,dw_target.Rowcount())
	If nRow > 0 Then
		MessageBox('대분류 중복',sSub2Name+'는 이미 등록된 메뉴입니다')
		dw_target.ScrollToRow(nRow)
		dw_target.SelectRow(0,false)
		dw_target.SelectRow(nRow,True)
		Return 0
	End If
	
	open(w_question_popup1)
	nRtn = Message.DoubleParm
	If nRtn = 4 Then Return 0

	/* user의 추가할 위치 */
	nRow = dw_target.Find("main_id > " + string(nMainId), 1, dw_target.Rowcount())
   If nRow > 0 Then 
		nRow = nRow - 1
	Else
		If IsNull(nRow) oR nRow = 0 Then nRow = dw_target.RowCount()
	End If
	
	/* 대분류 생성 */
	nRow = wf_copy_row(srow, nRow, nMainId, 99)
	
   Choose Case nRtn		
		Case 2 
			wf_create_middle(srow, nRow, nMainId, 0, 'N')
		Case 3
			wf_create_middle(srow, nRow, nMainId, 0, 'Y') // 프로그램 생성 
	End Choose

	/* 추가된 위치 표시 */
//	dw_target.ScrollToRow(nRow+1)
//	dw_target.SelectRow(0,false)
//	dw_target.SelectRow(nRow+1,True)
	
/* 중분류를 드래그 */
ElseIf nSub2Id = 100 Then
	If dw_target.RowCount() <= 0 Then Return 0

   If dw_source = dw_target Then Return 0
	
	/* 대분류가 다를 경우 */
	If nMainId <> nMainId_t Then
		MessageBox('대분류 오류',sSub2Name+'는 이곳에 올 수 없습니다.')
		Return 0
	End If
	
	/* 중복여부 */	
	nRow = dw_target.Find("main_id = " + string(nMainId) + " and sub1_id = " + string(nSub1Id),1,dw_target.Rowcount())
	If nRow > 0 Then
		MessageBox('중분류 중복',sSub2Name+'는 이미 등록된 메뉴입니다')
		dw_target.ScrollToRow(nRow)
		dw_target.SelectRow(0,false)
		dw_target.SelectRow(nRow,True)
		Return 0
	End If
	
	open(w_question_popup2)
	nRtn = Message.DoubleParm
	
	/* user의 추가할 위치 */
	nRow = dw_target.Find("main_id = " + string(nMainId_t) + " and sub1_id <> 99 and sub1_id > " + string(nSub1Id),1,dw_target.Rowcount())

   If nRow > 0 Then    /* 복사하는 메뉴보다 큰 중분류가 있을 경우 */
		nRow = nRow - 1
	Else
		/* */
		nRow = dw_target.Find("main_id > " + string(nMainId), 1, dw_target.Rowcount())
		If nRow > 0 Then 
			nRow = nRow - 1
		Else
			If IsNull(nRow) oR nRow = 0 Then nRow = dw_target.RowCount()
		End If
	End If
		
	If nRtn = 2 Then
		wf_create_middle(srow, nRow, nMainId, nSub1Id, 'N')
	ElseIf nRtn = 3 Then
		wf_create_middle(srow, nRow, nMainId, nSub1Id, 'Y') // 프로그램 생성 
	Else
		Return 0
	End If

	/* 추가된 위치 표시 */
//	dw_target.ScrollToRow(nRow+1)
//	dw_target.SelectRow(0,false)
//	dw_target.SelectRow(nRow+1,True)

/* 프로그램을 드래그 */	
Else
	If dw_target.RowCount() < erow Then Return 0
	If erow <= 0 Then Return 0

   /* dw_target에서 동일 대분류,중분류내에서 프로그램 이동은 않됨 */
   If nMainId = nMainId_t and nSub1Id = nSub1Id_t and dw_source = dw_target Then	Return 0

	If nSub2Id_t <> 99 Then  //대분류밑으로 들어갈 수 없음
      /* 동일 중분류내에 같은 프로그램 중복 불가 */
		nRow = dw_target.Find("main_id = "      + string(nMainId_t) + &
									 " and sub1_id = " + string(nSub1Id_t) + &
									 " and window_name = '" + sWindowName + "'",1,dw_target.Rowcount())

		If nRow > 0 Then
			MessageBox('프로그램 중복',sSub2Name+'은(는) 이미 등록된 프로그램입니다.')
			dw_target.ScrollToRow(nRow)
			dw_target.SelectRow(0,false)
			dw_target.SelectRow(nRow,True)
			Return 0
		End If

		nRow = wf_copy_row(srow, eRow, nMainId_t, nSub1Id_t)
	
	   /* 프로그램 순번 재분류 */
		wf_renumbering(nMainId_t, nSub1Id_t)
		
		/* 삭제 : dw_user일 경우만 해당 */	
		If dw_source = dw_target Then
			nRow = dw_source.Find("main_id = "      + string(nMainId) + &
										 " and sub1_id = " + string(nSub1Id) + &
										 " and sub2_id = " + string(nSub2Id),1,dw_source.Rowcount())

			If nRow > 0 Then 	dw_source.DeleteRow(nRow)

		End If
	End If
End If

/* 저장 */
If dw_target.Update() <> 1 Then
	rollback;
	MessageBox('오 류','wf_copy_to_target()')	
Else
	Commit;
End If

/* 저장후 조회 */
dw_user.SetRedraw(False)
dw_user.Retrieve(Trim(sle_user.text))
If OldRow > 0 Then
	dw_user.ScrollToRow(OldRow+1)
End If

dw_user.SetFilter(sFilter)
dw_user.Filter()

dw_user.SetRedraw(True)

dw_target.SetFocus()

Return 0
end function

public function string wf_filter (datawindow dwo, integer row, boolean gb);String sMainFilter = "( sub2_id = 99 or sub2_id = 100 ) "
String sModFilter
Long   ix, mainId, sub1Id, sub2Id

//or ( main_id = 50 and sub1_id = 100 )"

For ix = 1 To dwo.RowCount()
	If dwo.GetItemString(ix,'sub') = '0' Then Continue
	
	mainId = dwo.GetItemNumber(ix,'main_id')
	sub1Id = dwo.GetItemNumber(ix,'sub1_id')
	sub2Id = dwo.GetItemNumber(ix,'sub2_id')
	
	If sub2Id = 100 Then
		/* 중분류 */
		sMainfilter += ( " or ( main_id = " + string(mainId) + " and sub1_id = " + string(sub1Id) + " )" ) 
	Else
		/* 대분류 */
		sMainfilter += ( " or ( main_id = " + string(mainId) + ") " ) 		
	End If
Next

If gb = True Then
	dwo.SetRedraw(False)
	dwo.SetFilter(sMainFilter)
	dwo.Filter()
	
	dwo.ScrollToRow(row)
	
	dwo.SetRedraw(True)
End If

Return sMainFilter
end function

public function integer wf_copy_row (integer srow, integer erow, integer nmainid, integer nsub1id);String sUserId, sTit1, sTit2, sTit3, sSub2Name, sWindowName
Long   nSub2Id

sUserId = Trim(sle_user.Text)
If IsNull(sUserId ) or sUserId = '' Then Return erow

sTit1        = dw_source.GetItemString(srow,'tit1')
sTit2        = dw_source.GetItemString(srow,'tit2')
sTit3        = dw_source.GetItemString(srow,'tit3')
sSub2Name    = dw_source.GetItemString(srow,'sub2_name')
sWindowName  = dw_source.GetItemString(srow,'window_name')

nSub2Id      = dw_source.GetItemNumber(srow,'sub2_id')

eRow = dw_target.InsertRow(eRow+1)

dw_target.SetItem(eRow, 'tit1',        sTit1 )
dw_target.SetItem(eRow, 'tit2',        sTit2 )
dw_target.SetItem(eRow, 'tit3',        sTit3 )

dw_target.SetItem(eRow, 'main_id',     nMainId)  //USER 대분류
dw_target.SetItem(eRow, 'sub1_id',     nSub1Id)  //USER 중분류

If nSub1Id = 99 Then // 대분류일 경우 
	dw_target.SetItem(eRow, 'sub2_id',  99)
Else
	dw_target.SetItem(eRow, 'sub2_id',  nSub2Id)
End If

dw_target.SetItem(eRow, 'user_id',     sUserId )
dw_target.SetItem(eRow, 'sub2_name',   sSub2Name)
dw_target.SetItem(eRow, 'window_name', sWindowName)

Return erow

end function

on w_sys_007.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_user=create sle_user
this.gb_1=create gb_1
this.cb_refresh=create cb_refresh
this.dw_insert_all=create dw_insert_all
this.dw_user_all=create dw_user_all
this.dw_1=create dw_1
this.dw_user=create dw_user
this.p_1=create p_1
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_user
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.cb_refresh
this.Control[iCurrent+5]=this.dw_insert_all
this.Control[iCurrent+6]=this.dw_user_all
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.dw_user
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.rr_1
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_3
end on

on w_sys_007.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_user)
destroy(this.gb_1)
destroy(this.cb_refresh)
destroy(this.dw_insert_all)
destroy(this.dw_user_all)
destroy(this.dw_1)
destroy(this.dw_user)
destroy(this.p_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_user.SetTransObject(sqlca)

dw_insert_all.SetTransObject(sqlca)
dw_user_all.SetTransObject(sqlca)

p_can.TriggerEvent(Clicked!)

end event

type dw_insert from w_inherite`dw_insert within w_sys_007
event ue_mousemove pbm_mousemove
event ue_bdown pbm_lbuttondown
event ue_bup pbm_lbuttonup
integer x = 64
integer y = 240
integer width = 2240
integer height = 1784
integer taborder = 20
string dragicon = "WinLogo!"
string dataobject = "d_sys_007"
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::ue_mousemove;/* --------------------------------------------------------------- */
/* 마우스를 누른체 움직일 경우 drag                                */
/* --------------------------------------------------------------- */
string  ls_col,ls_colnm

int		li_row,li_pos

ls_col = this.GetObjectAtPointer() 

if Len (ls_col) > 0 then
	drag_start_row = 0
	li_pos = Pos (ls_col, '~t')

   /* row와 column name을 구분 */ 
	if li_pos > 0 then
		li_row = Integer (Right (ls_col, Len (ls_col) - li_pos))
		ls_colnm = Trim(Left(ls_col,li_pos - 1))
	Else
		Return
	end if

   If li_row <= 0 Then Return
	
	/* 마으스버튼이 눌릴경우 ue_bdown */
	if ib_down then
		this.Drag (begin!)
		
		dw_source = dw_insert_all
      drag_start_row = li_row
		drag_start_col = ls_colnm
	end if

end if

end event

event dw_insert::ue_bdown;string  ls_col,ls_colnm
int		li_row,li_pos

ls_col = this.GetObjectAtPointer() 

if Len (ls_col) > 0 then
	drag_start_row = 0
	li_pos = Pos (ls_col, '~t')

	if li_pos > 0 then
		li_row = Integer (Right (ls_col, Len (ls_col) - li_pos))
		ls_colnm = Trim(Left(ls_col,li_pos - 1))
	Else
		Return
	end if

   If li_row > 0 Then
		If Right(ls_colnm,2) <> '_t' Then
			SetRow(li_row)
	   	ib_down = true
		Else
			wf_find_next(this, ls_colnm)
		End If
	End If
End if

end event

event dw_insert::ue_bup;ib_down = false

This.Drag(End!)
end event

event dw_insert::dragdrop;dw_target    = dw_insert_all
drag_end_row = row
ib_down      = true

If dw_source = dw_user_all Then
	cb_del.PostEvent(Clicked!)
end If

end event

event dw_insert::rowfocuschanged;This.SelectRow(0,false)
This.SelectRow(currentrow, True)

if currentrow > 0 then 
	string swin_id
	
	swin_id = this.getitemstring(currentrow, 'window_name')
	if swin_id > '.' then 
		dw_1.setitem(1, 'win_nm', this.getitemstring(currentrow, 'sub2_name'))
		dw_1.setitem(1, 'win_id', swin_id)
	else
		dw_1.setitem(1, 'win_nm', '')
		dw_1.setitem(1, 'win_id', '')
	end if
end if
end event

event dw_insert::retrieveend;if gs_digital = 'D' then
	dw_insert_all.Retrieve('%')
Else	
	dw_insert_all.retrieve('E')
end if
end event

event dw_insert::doubleclicked;If row <= 0 Then Return

If GetItemNumber(row,'sub2_id') <> 99 and  GetItemNumber(row,'sub2_id') <> 100 Then Return 

If GetItemString(row,'sub') = '0' Then
	SetItem(row,'sub','1')
Else
	SetItem(row,'sub','0')
End If

Post wf_filter(this,row,True)
end event

type p_delrow from w_inherite`p_delrow within w_sys_007
boolean visible = false
integer x = 2304
integer y = 2720
end type

type p_addrow from w_inherite`p_addrow within w_sys_007
boolean visible = false
integer x = 2130
integer y = 2720
end type

type p_search from w_inherite`p_search within w_sys_007
boolean visible = false
integer x = 1435
integer y = 2720
end type

type p_ins from w_inherite`p_ins within w_sys_007
boolean visible = false
integer x = 1957
integer y = 2720
end type

type p_exit from w_inherite`p_exit within w_sys_007
integer x = 4425
integer y = 20
end type

type p_can from w_inherite`p_can within w_sys_007
integer x = 4247
integer y = 20
end type

event p_can::clicked;call super::clicked;/* Main Program 조회 */
if gs_digital = 'D' then
	dw_insert.Retrieve('%')
Else
	dw_insert.Retrieve('E')
End if
dw_insert.SetFilter("( sub2_id = 99 or sub2_id = 100 ) ")
dw_insert.Filter()

/* 사용자별 Program 조회 */
dw_user.Retrieve(Trim(sle_user.Text))

dw_1.setredraw(false)
dw_1.reset()
dw_1.insertrow(0)
dw_1.setredraw(true)


end event

type p_print from w_inherite`p_print within w_sys_007
boolean visible = false
integer x = 1609
integer y = 2720
end type

type p_inq from w_inherite`p_inq within w_sys_007
boolean visible = false
integer x = 1783
integer y = 2720
end type

type p_del from w_inherite`p_del within w_sys_007
integer x = 4069
integer y = 20
end type

event p_del::clicked;call super::clicked;Long nRow, nCnt

nRow = dw_user.GetRow()
If nRow <= 0 Then Return

dw_user.SetRedraw(False)

/* 삭제후 재조회 */
wf_delete_row(nRow) 

nCnt = dw_user.Retrieve(Trim(sle_user.Text))
If nCnt > 0 Then
   If nCnt < nRow Then nRow = nCnt
	
	dw_user.SetFocus()
	dw_user.SetRow(nRow)
	dw_user.ScrollToRow(nRow)
	dw_user.SelectRow(0,False)
	dw_user.SelectRow(nRow,True)
End If

dw_user.SetRedraw(True)
end event

type p_mod from w_inherite`p_mod within w_sys_007
boolean visible = false
integer x = 2478
integer y = 2720
end type

type cb_exit from w_inherite`cb_exit within w_sys_007
integer x = 2528
integer y = 2452
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sys_007
boolean visible = true
integer x = 1440
integer y = 28
integer width = 411
integer taborder = 60
integer textsize = -9
string text = "일괄처리(&S)"
end type

event cb_mod::clicked;String spgm_id, sdept, sempno
Int    iReturn

if dw_1.accepttext() = -1 then return 

spgm_id = dw_1.getitemstring(1, 'win_id')
sdept   = dw_1.getitemstring(1, 's_dept')
sempno  = dw_1.getitemstring(1, 's_fremp')

If IsNull(spgm_id) or spgm_id = '' Then 
	MessageBox("확 인", "일괄 처리 할 프로그램 ID를 선택하세요" )
	Return
end if

IF MessageBox("일괄처리", spgm_id + " 를 일괄처리 하시겠습니까? ", Question!, YesNo!, 2) = 2 THEN RETURN

SetPointer(HourGlass!)

If IsNull(sdept)  or sdept  = '' Then sdept = '%'
If IsNull(sempno) or sempno = '' Then sempno = '%'

iReturn = sqlca.fun_sub2_user_create(spgm_id, sdept, sempno);
If ireturn < 0  then
	rollback;	
	f_message_chk(89,'[일괄 생성] [ ' + string(ireturn) + ' ]') 
	return 1
end if
	
Commit;


end event

type cb_ins from w_inherite`cb_ins within w_sys_007
boolean visible = true
integer x = 1874
integer y = 28
integer width = 411
integer taborder = 70
integer textsize = -9
string text = "전체복사(&I)"
end type

event cb_ins::clicked;call super::clicked;String sUserId, sdigital

sUserId = sle_user.Text
If IsNull(sUserId) or sUserId = '' Then Return

If gs_digital = 'D' then
	sdigital = '%'
Else
	sdigital = 'E'
End if

IF MessageBox("전체복사", "현 유저의 모든 메뉴를 삭제하고 기본메뉴가 등록됩니다." +"~n~n" +&
				  "계속 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

Delete from sub2_user_t
 where user_id = :sUserId;

If sqlca.sqlcode <> 0 Then
	RollBack;
	MessageBox('확 인','삭제에 실패하였습니다')
Else
	
	Insert into sub2_user_t 
	 select :sUserId, main_id, sub1_id, sub2_id, sub2_name, window_name , null
	   from sub2_t
	  where digital Like :sdigital;

   If sqlca.sqlcode <> 0 Then
		MessageBox('확 인','복사에 실패하였습니다')
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
	Else
		Commit;
	End If
End If

dw_user.Retrieve(sUserId)

end event

type cb_del from w_inherite`cb_del within w_sys_007
integer x = 2107
integer y = 2444
integer taborder = 80
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sys_007
integer x = 1467
integer y = 2796
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sys_007
integer x = 1943
integer y = 2796
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sys_007
end type

type cb_can from w_inherite`cb_can within w_sys_007
integer x = 2418
integer y = 2796
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sys_007
integer x = 2894
integer y = 2796
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_sys_007
end type

type gb_button2 from w_inherite`gb_button2 within w_sys_007
end type

type st_2 from statictext within w_sys_007
integer x = 2391
integer y = 56
integer width = 247
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33554431
boolean enabled = false
string text = "USER ID"
boolean focusrectangle = false
end type

type sle_user from singlelineedit within w_sys_007
integer x = 2683
integer y = 48
integer width = 379
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
end type

event modified;String sUserId
Long   nCnt

sUserId = Trim(This.Text)
If IsNull(sUserId) or sUserId = '' Then 
	dw_user.Reset()
	Return
End If

select count(*) into :nCnt
  from login_t
 where l_userid = :suserid and
       l_gubun = 1;

If IsNull(nCnt) Then nCnt = 0

If nCnt <= 0 Then
	MessageBox('확 인','등록되지 않은 User Id입니다'+sUserId)
	Return
End If
	
If dw_user.Retrieve(sUserId) <= 0 Then	Return

dw_user.SetFocus()
dw_user.SetFilter("( sub2_id = 99 or sub2_id = 100 ) ")
dw_user.Filter()
end event

event rbuttondown;OPEN( w_sys_user_id_popup )
sle_user.text = gs_code

sle_user.triggerevent(modified!)
end event

type gb_1 from groupbox within w_sys_007
integer x = 1815
integer y = 2840
integer width = 1650
integer height = 188
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type cb_refresh from commandbutton within w_sys_007
boolean visible = false
integer x = 1582
integer y = 2404
integer width = 357
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Refresh(&F)"
end type

event clicked;/* Main Program 조회 */
if gs_digital = 'D' then
	dw_insert.Retrieve('%')
Else
	dw_insert.Retrieve('E')
End if
dw_insert.SetFilter("( sub2_id = 99 or sub2_id = 100 ) ")
dw_insert.Filter()

/* 사용자별 Program 조회 */
dw_user.Retrieve(Trim(sle_user.Text))

dw_1.setredraw(false)
dw_1.reset()
dw_1.insertrow(0)
dw_1.setredraw(true)


end event

type dw_insert_all from datawindow within w_sys_007
boolean visible = false
integer y = 2728
integer width = 1691
integer height = 116
boolean bringtotop = true
string dataobject = "d_sys_007"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_user_all from datawindow within w_sys_007
boolean visible = false
integer x = 1710
integer y = 2684
integer width = 1650
integer height = 104
boolean bringtotop = true
string dataobject = "d_sys_007_user"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_sys_007
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 2044
integer width = 2299
integer height = 284
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sys_007_01"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() = "s_dept" THEN
	Open(w_vndmst_4_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_dept", gs_Code)
	this.SetItem(1, "s_deptnm", gs_Codename)
ELSEIF this.GetColumnName() = "s_fremp" THEN
	Open(w_sawon_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_fremp", gs_Code)
	this.SetItem(1, "s_frnm", gs_Codename)
ELSEIF this.GetColumnName() = "s_frnm" THEN
		
	gs_codename = this.GetItemString(1,"s_frnm")
	IF IsNull(gs_codename) THEN 
		gs_codename =""
	END IF
	
	Open(w_sawon_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "s_fremp", gs_Code)
	this.SetItem(1, "s_frnm", gs_Codename)
END IF

end event

event itemerror;return 1
end event

event itemchanged;STRING sempno,sempnm,snull,sget_name,sdptno

setnull(snull)

IF this.GetColumnName() ="s_dept" THEN
	
	sdptno = this.GetText()
	
	IF sdptno ="" OR IsNull(sdptno) THEN 
		this.SetItem(1,"s_deptnm",snull)
		RETURN
	END IF
	
  SELECT "P0_DEPT"."DEPTNAME"  
    INTO :sget_name  
    FROM "P0_DEPT"  
   WHERE "P0_DEPT"."DEPTCODE" = :sdptno   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_deptnm",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.SetItem(1,"s_dept",snull)
			this.SetItem(1,"s_deptnm",snull)
		END IF
		
		Return 1	
	END IF
ELSEIF this.GetColumnName() ="s_fremp" THEN
	sempno = this.GetText()
	IF sempno ="" OR IsNull(sempno) THEN 
		this.SetItem(1,"s_frnm",snull)
		RETURN
	END IF

  SELECT EMPNAME
    INTO :sget_name  
    FROM "P1_MASTER"  
   WHERE "EMPNO" = :sempno   ;
   
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_frnm",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.Setitem(1,"s_fremp",snull)
			this.SetItem(1,"s_frnm",snull)
		END IF
		Return 1
	END IF
ELSEIF this.GetColumnName() ="s_frnm" THEN
	sempnm = this.GetText()
	IF sempnm ="" OR IsNull(sempnm) THEN 
		this.SetItem(1,"s_fremp",snull)
		RETURN
	END IF

  SELECT EMPNO
    INTO :sget_name  
    FROM "P1_MASTER"  
   WHERE "EMPNAME" = :sempnm   ;

	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1,"s_fremp",sget_name)
	ELSE
		this.TriggerEvent(RbuttonDown!)
		
		IF gs_code ="" OR IsNull(gs_code) THEN 
			this.Setitem(1,"s_fremp",snull)
			this.SetItem(1,"s_frnm",snull)
		END IF
		
		Return 1
	END IF
END IF
end event

type dw_user from u_key_enter within w_sys_007
event ue_mousemove pbm_mousemove
event ue_bdown pbm_lbuttondown
event ue_bup pbm_lbuttonup
event ue_keydown pbm_dwnkey
integer x = 2350
integer y = 240
integer width = 2240
integer height = 2064
integer taborder = 40
string dragicon = "WinLogo!"
string dataobject = "d_sys_007_user"
boolean vscrollbar = true
boolean border = false
end type

event ue_mousemove;/* --------------------------------------------------------------- */
/* 마우스를 누른체 움직일 경우 drag                                */
/* --------------------------------------------------------------- */
string  ls_col,ls_colnm

int		li_row,li_pos

ls_col = this.GetObjectAtPointer() 

if Len (ls_col) > 0 then
	drag_start_row = 0
	li_pos = Pos (ls_col, '~t')

   /* row와 column name을 구분 */ 
	if li_pos > 0 then
		li_row = Integer (Right (ls_col, Len (ls_col) - li_pos))
		ls_colnm = Trim(Left(ls_col,li_pos - 1))
	Else
		Return
	end if

   If li_row <= 0 Then Return
	
	/* 마으스버튼이 눌릴경우 ue_bdown */
	if ib_down then
		this.Drag (begin!)
		
		dw_source = dw_user_all
      drag_start_row = li_row
		drag_start_col = ls_colnm
	end if

end if
end event

event ue_bdown;string  ls_col,ls_colnm
int		li_row,li_pos

ls_col = this.GetObjectAtPointer() 

if Len (ls_col) > 0 then
	drag_start_row = 0
	li_pos = Pos (ls_col, '~t')

	if li_pos > 0 then
		li_row = Integer (Right (ls_col, Len (ls_col) - li_pos))
		ls_colnm = Trim(Left(ls_col,li_pos - 1))
	Else
		Return
	end if

   If li_row > 0 Then
		If Right(ls_colnm,2) <> '_t' Then
			SetRow(li_row)
	   	ib_down = true
		Else
			wf_find_next(this, ls_colnm)
		End If
	End If
End if


end event

event ue_bup;ib_down = false

This.Drag(End!)
end event

event ue_keydown;Long nRow

nRow = GetRow()
If nRow <= 0 Then Return 

If key = keydelete! Then	cb_del.PostEvent(Clicked!)
end event

event dragdrop;dw_target    = dw_user_all
drag_end_row = row
ib_down      = true

//If dw_target = dw_source Then Return

/* Program Menu 저장후 원래 위치로 이동하기 위해 row를 저장한다 */
OldRow = Row

/* 실제 start row의 위치를 찾는다 */
If drag_start_row <= 0 Then Return
If dw_target <> dw_source Then
	drag_start_row = dw_insert.GetItemNumber(drag_start_row,'seq')
Else
	drag_start_row = dw_user.GetItemNumber(drag_start_row,'seq')
End If
drag_start_row = dw_source.Find("seq = " + String(drag_start_row),1, dw_source.RowCount())

/* 실제 end row의 위치를 찾는다 */
If drag_end_row > 0 Then
	/* target위치가 중분류 일 경우 프로그램menu를 보여주기 위해 */
	If dw_user.GetItemNumber(drag_end_row,'sub2_id') = 100 Then
		dw_user.SetItem(drag_end_row,'sub','1')
	End If
	
	drag_end_row = dw_user.GetItemNumber(drag_end_row,'seq')
	drag_end_row = dw_target.Find("seq = " + String(drag_end_row),1, dw_target.RowCount())
Else
	drag_end_row = 0
	OldRow = 0
End If

Post wf_copy_to_target(drag_start_row, drag_end_row)
end event

event rowfocuschanged;This.SelectRow(0,false)
This.SelectRow(currentrow, True)
end event

event retrieveend;dw_user_all.Retrieve(Trim(sle_user.Text))
end event

event doubleclicked;If row <= 0 Then Return

If GetItemNumber(row,'sub2_id') <> 99 and  GetItemNumber(row,'sub2_id') <> 100 Then Return 

If GetItemString(row,'sub') = '0' Then
	SetItem(row,'sub','1')
Else
	SetItem(row,'sub','0')
End If

Post wf_filter(this,row,True)
end event

type p_1 from picture within w_sys_007
integer x = 2597
integer y = 52
integer width = 59
integer height = 56
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\pop_2.jpg"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sys_007
integer x = 2341
integer y = 56
integer width = 50
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33554431
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_sys_007
integer x = 119
integer y = 168
integer width = 398
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "시스템 메뉴"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_sys_007
integer x = 2409
integer y = 168
integer width = 398
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "사용자 메뉴"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sys_007
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 188
integer width = 2272
integer height = 1848
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sys_007
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2331
integer y = 188
integer width = 2272
integer height = 2128
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sys_007
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33554431
integer x = 2327
integer y = 24
integer width = 823
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

