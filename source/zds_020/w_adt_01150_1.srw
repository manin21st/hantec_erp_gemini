$PBExportHeader$w_adt_01150_1.srw
$PBExportComments$설비/계측기/ROLL 도면관리(등록)
forward
global type w_adt_01150_1 from w_inherite
end type
type rr_3 from roundrectangle within w_adt_01150_1
end type
type dw_1 from datawindow within w_adt_01150_1
end type
type rr_4 from roundrectangle within w_adt_01150_1
end type
type dw_detail from datawindow within w_adt_01150_1
end type
end forward

global type w_adt_01150_1 from w_inherite
integer width = 4123
integer height = 1672
string title = "도면등록"
string menuname = ""
boolean minbox = false
windowtype windowtype = response!
rr_3 rr_3
dw_1 dw_1
rr_4 rr_4
dw_detail dw_detail
end type
global w_adt_01150_1 w_adt_01150_1

type prototypes
FUNCTION long ShellExecuteA &
    (long hwnd, string lpOperation, &
    string lpFile, string lpParameters,  string lpDirectory, &
    integer nShowCmd ) LIBRARY "SHELL32" alias for "ShellExecuteA;Ansi"
end prototypes

type variables
char   ic_status
string is_Last_Jpno, is_Date, is_gubun, is_path, is_file
int    ii_Last_Jpno



end variables

forward prototypes
public subroutine wf_taborderzero ()
public subroutine wf_taborder ()
public subroutine wf_reset ()
public function integer wf_delete ()
public subroutine wf_new ()
public subroutine wf_query ()
end prototypes

public subroutine wf_taborderzero ();dw_detail.SetTabOrder("poblno", 0)

end subroutine

public subroutine wf_taborder ();dw_detail.SetTabOrder("poblno", 10)
dw_detail.SetColumn("poblno")
end subroutine

public subroutine wf_reset ();string   snull
integer  iNull
long		lRow

SetNull(sNull)
SetNull(iNull)
lRow  = dw_insert.GetRow()	
dw_insert.setitem(lRow, 'polcno', snull)
dw_insert.setitem(lRow, 'itnbr', snull)
dw_insert.setitem(lRow, 'itdsc', snull)
dw_insert.setitem(lRow, 'ispec', snull)
dw_insert.setitem(lRow, 'jijil', snull)
dw_insert.setitem(lRow, 'ispec_code', snull)
dw_insert.setitem(lRow, 'polchd_pocurr', snull)
dw_insert.setitem(lRow, 'baljpno', snull)
dw_insert.setitem(lRow, 'balseq', inull)
dw_insert.setitem(lRow, 'poblsq', inull)
dw_insert.setitem(lRow, 'polcdt_lcqty', 0)
dw_insert.setitem(lRow, 'polcdt_blqty', 0)
dw_insert.setitem(lRow, 'blqty', 0)
dw_insert.setitem(lRow, 'polcdt_lcprc', 0)
dw_insert.SetItem(lRow, "amt", 0)		// LC금액
dw_insert.setitem(lRow, 'saupj', snull)

end subroutine

public function integer wf_delete ();long	lRow, lRowCount


lRowCount = dw_insert.RowCount()

FOR  lRow = lRowCount 	TO	 1		STEP -1
	
	dw_insert.DeleteRow(lRow)
	
NEXT


RETURN 1
end function

public subroutine wf_new ();//ic_status = '1'
//w_mdi_frame.sle_msg.text = "등록"
//
/////////////////////////////////////////////////
//dw_detail.setredraw(false)
//
//dw_detail.reset()
//dw_detail.insertrow(0)
//dw_detail.setitem(1, "sabu", gs_sabu)
//
//wf_TabOrder()
//dw_detail.setredraw(true)
/////////////////////////////////////////////////
//dw_detail.enabled = true
//dw_insert.enabled = true
//
//p_mod.enabled = false
//p_del.enabled = false
//p_inq.enabled = true
//
//p_mod.PictureName = "C:\erpman\image\저장_d.gif"
//p_del.PictureName = "C:\erpman\image\삭제_d.gif"
//
//dw_detail.SetFocus()
//
//rb_3.checked = true
//rb_4.checked = false
//
//ib_any_typing = false
//
//
end subroutine

public subroutine wf_query ();w_mdi_frame.sle_msg.text = "조회"
ic_Status = '2'

wf_TabOrderZero()
dw_detail.SetFocus()
	
// button
p_mod.enabled = true
p_del.enabled = true
//cb_insert.enabled = false

p_mod.PictureName = "C:\erpman\image\저장_up.gif"
p_del.PictureName = "C:\erpman\image\삭제_up.gif"



end subroutine

on w_adt_01150_1.create
int iCurrent
call super::create
this.rr_3=create rr_3
this.dw_1=create dw_1
this.rr_4=create rr_4
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_3
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rr_4
this.Control[iCurrent+4]=this.dw_detail
end on

on w_adt_01150_1.destroy
call super::destroy
destroy(this.rr_3)
destroy(this.dw_1)
destroy(this.rr_4)
destroy(this.dw_detail)
end on

event open;call super::open;string s_code
f_window_center_response(this)
dw_detail.settransobject(sqlca)
dw_insert.settransobject(sqlca)

dw_detail.insertrow(0)

If gs_gubun = 'Y' or gs_gubun = 'N' or gs_gubun = 'N' Then
	s_code = gs_gubun
Else
	s_code = 'N'
End If


If Not IsNull(gs_code) Then
	dw_detail.setitem(1, 'mchno', gs_code)
	dw_detail.setitem(1, 'mchnm', gs_codename)
End If

if not(isnull(s_code) or s_code = "") then
   dw_detail.setitem(1, 'gubun', s_code)
//	if s_code = 'R' then
//		dw_detail.Modify("mchno.Format='@@-@@-@@-@@@-@''")
//	else	
//	   dw_detail.Modify("mchno.Format='@@-@@-@@-@@@''")
//	end if
end if	

p_ins.enabled = false
p_mod.enabled = false
p_del.enabled = false
p_ins.PictureName = "C:\erpman\image\추가_d.gif"
p_mod.PictureName = "C:\erpman\image\저장_d.gif"
p_del.PictureName = "C:\erpman\image\삭제_d.gif"

ib_any_typing = false

end event

type dw_insert from w_inherite`dw_insert within w_adt_01150_1
integer x = 27
integer y = 308
integer width = 4014
integer height = 1192
integer taborder = 20
string dataobject = "d_adt_01150_1e"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;string ls_path, ls_file_name, ls_Null, ls_mchgb, ls_mchno, ls_mapno, ls_revno, ls_file
long   i, ll_seq, ll_new_pos, ll_flen, ll_bytes_read, ll_rc
int    li_fp, li_loops, li_complete, li_rc
blob   b_data, b_data2

// 열기 버튼
if dwo.type = 'button' then
	ls_mchgb     = dw_insert.GetitemString(row,'mchgb')
	ls_mchno     = dw_insert.GetitemString(row,'mchno')
	ls_mapno     = dw_insert.GetitemString(row,'mapno')
	ls_revno     = dw_insert.GetitemString(row,'rev_no')
	ls_file_name = dw_insert.GetitemString(row,'file_nm')
	
	if dwo.name = 'b_path' then
		if GetFileOpenName('원본 파일을 선택하세요', &
										 + ls_path, ls_file, "DWG", &
										 + "CAD Files (*.DWG), *.DWG," &
										 + "JPEG Files (*.JPG), *.JPG," &
										 + "BMP Files (*.BMP), *.BMP") = 1 then
			dw_insert.setitem(row,'path', ls_path)
		   dw_insert.setitem(row,'file_nm', ls_file)
			is_path = ls_path 
			is_file = ls_file
      end if		
   elseif dwo.name = 'b_dis' then
		ls_path = 'c:\erpman\doc' 	
		if not directoryexists(ls_path) then 
			createdirectory(ls_path) 
		End if 
		
		selectblob image into :b_data
				from mchmap
			  where mchgb  = :ls_mchgb
				 and mchno  = :ls_mchno
				 and mapno  = :ls_mapno
				 and rev_no = :ls_revno;
		If IsNull(b_data) Then
			messagebox('확인',ls_file_name +' DownLoad할 자료가 없습니다.~r~n시스템 담당자에게 문의하십시오.')
		End If		
			IF SQLCA.SQLCode = 0 AND Not IsNull(b_data) THEN
				ls_file_name = ls_path + '\' + ls_file_name
				li_fp = FileOpen(trim(ls_file_name) , StreamMode!, Write!, LockWrite!, replace!)
		
				ll_new_pos 	= 1
				li_loops 	= 0
				ll_flen 		= 0
		
				IF li_fp = -1 or IsNull(li_fp) then
					messagebox('확인',ls_path + ' Folder가 존재치 않거나 사용중인 자료입니다.')
				Else
					ll_flen = len(b_data)
					
					if ll_flen > 32765 then
						if mod(ll_flen,32765) = 0 then
							li_loops = ll_flen / 32765
						else
							li_loops = (ll_flen/32765) + 1
						end if
					else
						li_loops = 1
					end if
		
					if li_loops = 1 then 
						ll_bytes_read = filewrite(li_fp,b_data)
						Yield()					
					else
						for i = 1 to li_loops
							if i = li_loops then
								b_data2 = blobmid(b_data,ll_new_pos)
							else
								b_data2 = blobmid(b_data,ll_new_pos,32765)
							end if
							ll_bytes_read = filewrite(li_fp,b_data2)
							ll_new_pos = ll_new_pos + ll_bytes_read
		
							Yield()
							li_complete = ( (32765 * i ) / len(b_data)) * 100
						next
							Yield()
					end if
					
					li_rc = 0 
					
					FileClose(li_fp)
				END IF
			END IF
		//==[프로그램 실행/다운완료후]
		ll_rc = ShellExecuteA(handle(parent), 'open', ls_file_name, ls_Null, ls_Null, 1)
		return		
	end if
End if 
ib_any_typing = true

end event

type p_delrow from w_inherite`p_delrow within w_adt_01150_1
boolean visible = false
integer x = 5102
integer y = 92
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;string sblno
long	lrow, lcount
lRow = dw_insert.GetRow()

IF lRow < 1		THEN	RETURN

// 물대비용이 등록된 경우에는 수정불가
SELECT COUNT(*)  INTO :lcount
  FROM IMPEXP 
 WHERE SABU = :gs_sabu AND POBLNO = :sBlno and mulgu = 'Y'  ;
 
IF lcount > 0 then 
	MessageBox("확인", "구매결제된 B/L번호는 삭제할 수 없습니다.")
	RETURN 
END IF	

//IF f_msg_delete() = -1 THEN	RETURN

dw_insert.DeleteRow(lRow)
//sBlno = trim(dw_detail.GetItemString(1, "poblno"))
//
//if dw_insert.rowcount() < 1 then
//	
//	// 수입비용이 등록된 경우에는 수정불가
//	SELECT COUNT(*)  INTO :lcount
//	  FROM IMPEXP 
//	 WHERE SABU = :gs_sabu AND POBLNO = :sBlno;
//	 
//	IF lcount > 0 then 
//		MessageBox("확인", "수입비용이 등록된 B/L번호는 삭제할 수 없습니다.")
//		RETURN 
//	END IF		
//	
//	// HEAD삭제
//	DELETE POLCBLHD
//	 WHERE SABU = :gs_sabu AND POBLNO = :sBlno   ;
//	IF SQLCA.SQLCODE <> 0 THEN
//		rollback;
//		MESSAGEBOX("B/L-HEAD", "B/L-HEAD삭제시 오류가 발생", stopsign!)
//		return
//	END IF	
//end if
//

ib_any_typing = true

end event

type p_addrow from w_inherite`p_addrow within w_adt_01150_1
boolean visible = false
integer x = 4923
integer y = 96
integer taborder = 50
end type

event p_addrow::clicked;call super::clicked;IF dw_detail.AcceptText() = -1	THEN	RETURN

if f_CheckRequired(dw_insert) = -1	then	return


//////////////////////////////////////////////////////////
long		lRow
string  	sBlno

sBlno	= dw_detail.getitemstring(1, "poblno")


lRow = dw_insert.InsertRow(0)

dw_insert.ScrollToRow(lRow)
dw_insert.SetColumn("polcno")
dw_insert.SetFocus()

ib_any_typing = true
end event

type p_search from w_inherite`p_search within w_adt_01150_1
boolean visible = false
integer x = 4567
integer y = 104
integer taborder = 0
string picturename = "C:\erpman\image\도면조회_up.gif"
end type

event p_search::clicked;call super::clicked;string ls_path, ls_mchno, ls_mchgb, ls_revno, ls_mapno, ls_file_name, ls_Null
long   i, ll_seq, ll_new_pos, ll_flen, ll_bytes_read, ll_rc, ll_row
int    li_fp, li_loops, li_complete, li_rc
blob   b_data, b_data2

SetNull(ls_Null)


ll_row = dw_insert.getrow()

SetPointer(HourGlass!)
ls_mchgb     = dw_insert.getitemstring(ll_row, 'mchgb'  )
ls_mchno     = dw_insert.getitemstring(ll_row, 'mchno'  )
ls_revno     = dw_insert.getitemstring(ll_row, 'rev_no')
ls_mapno     = dw_insert.getitemstring(ll_row, 'mapno')
ls_file_name = dw_insert.getitemstring(ll_row, 'file_nm')


ls_path = 'c:\erpman\map' 	
if not directoryexists(ls_path) then 
	createdirectory(ls_path) 
End if 

selectblob image into :b_data
		from mchmap
	  where mchgb  = :ls_mchgb
		 and mchno  = :ls_mchno
		 and mapno  = :ls_mapno
		 and rev_no = :ls_revno;
If IsNull(b_data) Then
	messagebox('확인',ls_file_name +' DownLoad할 자료가 없습니다.~r~n시스템 담당자에게 문의하십시오.')
End If		
	IF SQLCA.SQLCode = 0 AND Not IsNull(b_data) THEN
		ls_file_name = ls_path + '\' + ls_file_name
		li_fp = FileOpen(trim(ls_file_name) , StreamMode!, Write!, LockWrite!, replace!)

		ll_new_pos 	= 1
		li_loops 	= 0
		ll_flen 		= 0

		IF li_fp = -1 or IsNull(li_fp) then
			messagebox('확인',ls_path + ' Folder가 존재치 않거나 사용중인 자료입니다.')
		Else
			ll_flen = len(b_data)
			
			if ll_flen > 32765 then
				if mod(ll_flen,32765) = 0 then
					li_loops = ll_flen / 32765
				else
					li_loops = (ll_flen/32765) + 1
				end if
			else
				li_loops = 1
			end if

			if li_loops = 1 then 
				ll_bytes_read = filewrite(li_fp,b_data)
				Yield()					
			else
				for i = 1 to li_loops
					if i = li_loops then
						b_data2 = blobmid(b_data,ll_new_pos)
					else
						b_data2 = blobmid(b_data,ll_new_pos,32765)
					end if
					ll_bytes_read = filewrite(li_fp,b_data2)
					ll_new_pos = ll_new_pos + ll_bytes_read

					Yield()
					li_complete = ( (32765 * i ) / len(b_data)) * 100
				next
					Yield()
			end if
			
			li_rc = 0 
			
			FileClose(li_fp)
		END IF
	END IF
//==[프로그램 실행/다운완료후]
ll_rc = ShellExecuteA(handle(parent), 'open', ls_file_name, ls_Null, ls_Null, 1)
return		



end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\도면조회_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\도면조회_up.gif"
end event

type p_ins from w_inherite`p_ins within w_adt_01150_1
integer x = 3351
integer y = 32
integer taborder = 40
string picturename = "C:\erpman\image\추가_d.gif"
end type

event p_ins::clicked;call super::clicked;string ls_gubun, ls_mchno
long   ll_row

IF dw_detail.AcceptText() = -1	THEN	RETURN

ls_gubun	= dw_detail.getitemstring(1, "gubun")
ls_mchno	= dw_detail.getitemstring(1, "mchno")

/* 업무구분 */
if isnull(ls_gubun) or ls_gubun = "" then
	f_message_chk(30,'[구분]')
	dw_detail.Setcolumn('gubun')
	dw_detail.SetFocus()
	return
end if

/* 코드 */
if isnull(ls_mchno) or ls_mchno = "" then
	f_message_chk(30,'[관리코드]')
	dw_detail.Setcolumn('mchno')
	dw_detail.SetFocus()
	return
end if

ll_row = dw_insert.rowcount()

p_mod.enabled = true
p_del.enabled = true
p_mod.PictureName = "C:\erpman\image\저장_up.gif"
p_del.PictureName = "C:\erpman\image\삭제_up.gif"
	
dw_insert.insertrow(ll_row+1)
dw_insert.setitem(ll_row+1,'mchgb',ls_gubun)
dw_insert.setitem(ll_row+1,'mchno',ls_mchno)
dw_insert.scrolltorow(ll_row+1)
dw_insert.setcolumn('mapno')
dw_insert.setfocus()


end event

type p_exit from w_inherite`p_exit within w_adt_01150_1
integer x = 3872
integer y = 32
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_adt_01150_1
boolean visible = false
integer x = 1655
integer y = 416
integer taborder = 90
end type

event p_can::clicked;call super::clicked;//w_mdi_frame.sle_msg.text = ''
//
//Rollback ;
//
//wf_New()
//
//dw_insert.Reset()
//dw_insert.dataobject = "d_adt_01300_1"
//dw_insert.settransobject(sqlca)
//
//p_del.Enabled = false	
//p_del.Picturename = 'c:\erpman\image\삭제_d.gif'
//p_mod.Enabled = true	
//p_mod.Picturename = 'c:\erpman\image\저장_up.gif'
//
//is_gubun = '0'
//cbx_1.checked = false
end event

type p_print from w_inherite`p_print within w_adt_01150_1
boolean visible = false
integer x = 4741
integer y = 92
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_adt_01150_1
integer x = 3177
integer y = 32
integer taborder = 30
end type

event p_inq::clicked;call super::clicked;string  ls_mchno, ls_null, ls_gubun
BLOB    B_IMAGE

if dw_detail.Accepttext() = -1	then 	return
			
SetNull(ls_null)

ls_gubun	= dw_detail.getitemstring(1, "gubun")
ls_mchno	= dw_detail.getitemstring(1, "mchno")

IF isnull(ls_gubun) or ls_gubun = "" 	THEN
	f_message_chk(30,'[구분]')
	dw_detail.SetColumn("gubun")
	dw_detail.SetFocus()
	RETURN
END IF

IF isnull(ls_mchno) or ls_mchno = "" 	THEN
	f_message_chk(30,'[관리코드]')
	dw_detail.SetColumn("mchno")
	dw_detail.SetFocus()
	RETURN
END IF

dw_detail.SetRedraw(False)

IF dw_insert.Retrieve(ls_gubun, ls_mchno) < 1	THEN
	f_message_chk(50, '')
	dw_detail.setcolumn("mchno")
	dw_detail.setfocus()
	ib_any_typing = False
	
	p_ins.enabled = true
   p_mod.enabled = false
	p_del.enabled = false
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
	p_mod.PictureName = "C:\erpman\image\저장_d.gif"
	p_del.PictureName = "C:\erpman\image\삭제_d.gif"

	RETURN
ELSE
	p_ins.enabled = true
	p_mod.enabled = true
	p_del.enabled = true
	p_ins.PictureName = "C:\erpman\image\추가_up.gif"
	p_mod.PictureName = "C:\erpman\image\저장_up.gif"
	p_del.PictureName = "C:\erpman\image\삭제_up.gif"
END IF


dw_detail.SetRedraw(True)

ib_any_typing = False

end event

type p_del from w_inherite`p_del within w_adt_01150_1
integer x = 3698
integer y = 32
integer taborder = 80
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;string ls_mchgb, ls_mchno, ls_mapno, ls_rev_no
long   nRow

if dw_insert.rowcount() < 1 then
	Messagebox('알림', '삭제할 자료가 없습니다.')
	return
end if	

nRow  = dw_insert.GetRow()
If nRow <= 0 Then 
	Messagebox('알림', '삭제할 자료를 선택하세요.')
	Return
end if

//ls_mchgb    = dw_insert.GetitemString(nRow,'mchgb')
//ls_mchno    = dw_insert.GetitemString(nRow,'mchno')
//ls_mapno    = dw_insert.GetitemString(nRow,'mapno')
//ls_rev_no   = dw_insert.GetitemString(nRow,'rev_no')
//
IF MessageBox("삭 제","해당 도면을 삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN

If dw_insert.DeleteRow(nRow) = 1 Then
   IF dw_insert.Update() <> 1 THEN
      MessageBox("삭제실패","삭제 작업 실패(1)!")
		ROLLBACK;
      Return
   End If
 	COMMIT;
	w_mdi_frame.sle_msg.text ='자료를 삭제하였습니다!!'
	MessageBox("삭 제","삭제 작업 완료!")
	ib_any_typing = false
end if


end event

type p_mod from w_inherite`p_mod within w_adt_01150_1
integer x = 3525
integer y = 32
integer taborder = 70
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;string  ls_mchgb, ls_mchno, ls_mapno, ls_rev_no, ls_filepath, ls_rev_dat, ls_filename, ls_file, ls_path
integer i, j, k, fnum, loops
long    ll_cnt, bytes_read, lgth, ll_row, filelength
blob    b, imagedata, imagedata2


dw_insert.accepttext() 

if dw_insert.rowcount() < 1 then
	Messagebox('알림', '저장할 자료가 없습니다.')
	return
end if	

if ib_any_typing = false then
	Messagebox('알림', '수정사항이 없습니다.')
	return
end if	

//내용없는 자료삭제 
For k = dw_insert.rowcount() To 1 step -1
	 ls_mchgb    = dw_insert.GetitemString(k,'mchgb')
    ls_mchno    = dw_insert.GetitemString(k,'mchno')
	 ls_mapno    = dw_insert.GetitemString(k,'mapno')
	 ls_rev_no   = dw_insert.GetitemString(k,'rev_no')
    ls_filename = dw_insert.GetitemString(k,'file_nm')
    
	 if (ls_mchgb = '' or isnull(ls_mchgb)) or (ls_mapno = '' or isnull(ls_mapno)) &
	    or (ls_rev_no = '' or isnull(ls_rev_no)) or (ls_filename = '' or isnull(ls_filename))  then
		 dw_insert.deleterow(k)
	 end if
next	

If dw_insert.Update() <> 1 then  
	messagebox("확인","저장실패!")
	Rollback;
	return -1
Else
	Commit;	
	
	integer 	li_FileNum
	long 		flen, new_pos
	blob 		tot_b
	tot_b = Blob(Space(0))
	b = Blob(Space(0))
	/* 이미지 저장 */
	for i = 1 to  dw_insert.rowcount()
		 ls_mchgb    = dw_insert.GetitemString(i,'mchgb')
		 ls_mchno    = dw_insert.GetitemString(i,'mchno')
		 ls_mapno    = dw_insert.GetitemString(i,'mapno')
		 ls_rev_no   = dw_insert.GetitemString(i,'rev_no')

		/* 문서저장 */
		ls_file 		= dw_insert.GetitemString(i,'file_nm')
		ls_path     = dw_insert.GetitemString(i,'path')
		
		//////////////////////////////////////////
		// 선택한 FILE을 READ하여 DB에 UPDATE
		//////////////////////////////////////////
		flen = FileLength(ls_path)
		li_FileNum = FileOpen(ls_path, StreamMode!, Read!, LockRead!)
		
		if li_FileNum = -1 then	continue
		
		IF flen > 32765 THEN
			IF Mod(flen, 32765) = 0 THEN
				loops = flen/32765
			ELSE
				loops = (flen/32765) + 1
			END IF
		ELSE
			loops = 1
		END IF
		
		new_pos = 1
		
		FOR j = 1 to loops
			bytes_read = FileRead(li_FileNum, b)
			tot_b = tot_b + b
		NEXT
			
		FileClose(li_FileNum)	
		
		//Blob 저장
		UPDATEBLOB mchmap
		  	    SET image  = :tot_b
			  where mchgb  = :ls_mchgb
				 and mchno  = :ls_mchno
				 and mapno  = :ls_mapno
				 and rev_no = :ls_rev_no;			
		If SQLCA.SQLCODE <> 0 Then
			messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
			ROLLBACK USING SQLCA	;
			Return
		End if				
										
		COMMIT USING SQLCA	;
		tot_b = Blob(Space(0))
		b = Blob(Space(0))
	next	
End if
MessageBox('알림', '저장 완료.')
		
ib_any_typing = false

end event

type cb_exit from w_inherite`cb_exit within w_adt_01150_1
end type

type cb_mod from w_inherite`cb_mod within w_adt_01150_1
end type

type cb_ins from w_inherite`cb_ins within w_adt_01150_1
end type

type cb_del from w_inherite`cb_del within w_adt_01150_1
end type

type cb_inq from w_inherite`cb_inq within w_adt_01150_1
end type

type cb_print from w_inherite`cb_print within w_adt_01150_1
end type

type st_1 from w_inherite`st_1 within w_adt_01150_1
end type

type cb_can from w_inherite`cb_can within w_adt_01150_1
integer x = 2094
integer y = 2780
end type

type cb_search from w_inherite`cb_search within w_adt_01150_1
end type







type gb_button1 from w_inherite`gb_button1 within w_adt_01150_1
end type

type gb_button2 from w_inherite`gb_button2 within w_adt_01150_1
end type

type rr_3 from roundrectangle within w_adt_01150_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 28
integer width = 2706
integer height = 232
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_adt_01150_1
boolean visible = false
integer x = 837
integer y = 2540
integer width = 411
integer height = 432
boolean bringtotop = true
string title = "none"
string dataobject = "d_lc_detail_popup1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_4 from roundrectangle within w_adt_01150_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 288
integer width = 4050
integer height = 1220
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_detail from datawindow within w_adt_01150_1
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 37
integer y = 96
integer width = 2363
integer height = 100
integer taborder = 10
string title = "none"
string dataobject = "d_adt_01150_e"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;String  ls_mchgb, s_cod, s_nam1, s_nam2, snull
integer i_rtn

setnull(snull)
ls_mchgb = this.GetItemString(row, "gubun")

if this.GetColumnName() = "gubun" then 
	this.setitem(1,'mchno',snull)
   this.setitem(1,'mchnm',snull)
   this.setcolumn('mchno')
   this.setfocus()
elseif this.GetColumnName() = "mchno" then 
	s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then 
		this.setitem(1,'mchno',snull)
		this.setitem(1,'mchnm',snull)
		this.setcolumn('mchno')
   	this.setfocus()
		return
	end if	
	
	if ls_mchgb = 'R' then //ROLL
		select rollnm  into :s_nam1
		  from rollmst
		 where sabu   = :gs_sabu and rollno = :s_cod;
		 
		 if sqlca.sqlcode <> 0 then 
		    messagebox('알림','관리코드가 존재하지 않습니다.')
		    this.setitem(1,'mchno',snull)
			 this.setitem(1,'mchnm',snull)
			 this.setcolumn('mchno')
			 this.setfocus()
		    return
	    end if
   else //설비,계측기
		select mchnam into :s_nam1 
		  from mchmst
		 where sabu = :gs_sabu and mchno = :s_cod;
		 
		 if sqlca.sqlcode <> 0 then 
		    messagebox('알림','관리코드가 존재하지 않습니다.')
		    this.setitem(1,'mchno',snull)
			 this.setitem(1,'mchnm',snull)
			 this.setcolumn('mchno')
			 this.setfocus()
		    return
	    end if
	end if
	
	this.setitem(1,'mchno', s_cod)
	this.setitem(1,'mchnm', s_nam1)
	dw_insert.reset()
//	p_inq.triggerevent(Clicked!)
end if

ib_any_typing = false
end event

event itemerror;RETURN 1
end event

event losefocus;this.accepttext()
end event

event rbuttondown;string ls_mchgb

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ls_mchgb = this.GetItemString(row, "gubun")

if this.GetColumnName() = "mchno" then
	gs_gubun = 'ALL'
	if ls_mchgb = 'R' then   //ROLL 번호
//	   open(w_rollno_popup)
	else	
	   open(w_mchno_popup)   //설비,계측기번호
	end if	
	
	if isnull(gs_code) or gs_code = '' then return 
	this.object.mchno[1] = gs_code
	this.object.mchnm[1] = gs_codename
   dw_insert.reset()
//	p_inq.triggerevent(Clicked!)
end if	

end event

