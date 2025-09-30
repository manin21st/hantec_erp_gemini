$PBExportHeader$w_wflow_file_copy_sub.srw
$PBExportComments$참조파일 서버로 등록
forward
global type w_wflow_file_copy_sub from window
end type
type sle_src_nm from singlelineedit within w_wflow_file_copy_sub
end type
type st_2 from statictext within w_wflow_file_copy_sub
end type
type st_1 from statictext within w_wflow_file_copy_sub
end type
type cb_1 from commandbutton within w_wflow_file_copy_sub
end type
type rb_3 from radiobutton within w_wflow_file_copy_sub
end type
type st_tar from statictext within w_wflow_file_copy_sub
end type
type st_src from statictext within w_wflow_file_copy_sub
end type
type cb_cancel from commandbutton within w_wflow_file_copy_sub
end type
type cb_ok from commandbutton within w_wflow_file_copy_sub
end type
type sle_tar from singlelineedit within w_wflow_file_copy_sub
end type
type cb_tar from commandbutton within w_wflow_file_copy_sub
end type
type cb_src from commandbutton within w_wflow_file_copy_sub
end type
type sle_src from singlelineedit within w_wflow_file_copy_sub
end type
type rb_2 from radiobutton within w_wflow_file_copy_sub
end type
type rb_1 from radiobutton within w_wflow_file_copy_sub
end type
type browseinfo from structure within w_wflow_file_copy_sub
end type
end forward

type BROWSEINFO from structure
	long		lngOwner
	long		lngRoot
	string		pszDisplayName
	string		Title
	long		ulFlags
	long		lpfn
	long		lParam
	long		iImage
end type

global type w_wflow_file_copy_sub from window
integer width = 1435
integer height = 656
boolean titlebar = true
string title = "파일 등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
sle_src_nm sle_src_nm
st_2 st_2
st_1 st_1
cb_1 cb_1
rb_3 rb_3
st_tar st_tar
st_src st_src
cb_cancel cb_cancel
cb_ok cb_ok
sle_tar sle_tar
cb_tar cb_tar
cb_src cb_src
sle_src sle_src
rb_2 rb_2
rb_1 rb_1
end type
global w_wflow_file_copy_sub w_wflow_file_copy_sub

type prototypes
FUNCTION ulong WNetGetConnectionA(ref string drv, ref string unc, ref ulong buf) &
	LIBRARY "mpr.dll" alias for "WNetGetConnectionA;Ansi"
Function Long SHGetPathFromIDListA(long pidl, ref string pszPath) LIBRARY "shell32.dll" alias for "SHGetPathFromIDListA;Ansi"
Function Long SHBrowseForFolderA(ref BROWSEINFO lpBrowseInfo) LIBRARY "shell32.dll" alias for "SHBrowseForFolderA;Ansi"

end prototypes

type variables
string is_proj_code
string is_filepath
STRING is_column
long 	 il_proj_seq = 1
LONG   il_gateway_seq = 1
LONG   il_activity_seq = 1
LONG	 il_activity_sub_seq = 1
string is_path
string is_file
end variables

forward prototypes
public function integer wnetgetconnectiona (ref string drv, ref string unc, ref unsignedlong buf)
public function string wf_path_to_unc (string as_path)
public function integer wf_file_copy (string as_src_file, string as_tar_file)
public function integer wf_get_directory (string as_title, ref string as_directory)
end prototypes

public function integer wnetgetconnectiona (ref string drv, ref string unc, ref unsignedlong buf);BROWSEINFO bInfo
string ls_path
long ll_rc
long ll_item
int intSpace

//If as_title = '' Then
//	bInfo.Title = "대상 폴더를 선택하세요"
//Else
//	bInfo.Title = as_title
//End If

ll_item = SHBrowseForFolderA(bInfo)
ls_path = Space(512)
ll_rc = SHGetPathFromIDListA(ll_item, ls_path)

If ll_rc > 0 Then
	return 1
Else
	ls_path = ''
	return -1
End If

end function

public function string wf_path_to_unc (string as_path);//To convert a normal paths (N:\PATH) to UNC (\\SERVER\PATH)
string    ls_tmp, ls_unc
Ulong     ll_rc, ll_size

ls_tmp = upper(left(as_path,2))
IF right(ls_tmp,1) <> ":" THEN RETURN as_path

ll_size = 255
ls_unc = Space(ll_size)

ll_rc = WNetGetConnectionA(ls_tmp, ls_unc, ll_size)
IF ll_rc = 2250 THEN
	// prbably local drive
	RETURN as_path
END IF

IF ll_rc <> 0 THEN
	MessageBox("UNC Error", "Error " + string(ll_rc) + " retrieving UNC for " + ls_tmp)
	RETURN as_path
END IF

// Concat and return full path
IF len(as_path) > 2 THEN
   ls_unc = ls_unc + mid(as_path,3)
END IF

RETURN ls_unc

end function

public function integer wf_file_copy (string as_src_file, string as_tar_file);INT li_FileNum, li_FileNum2
int li_loops, i
LONG ll_flen, ll_bytes_read
LONG ll_flen2
BLOB lb_data

// as_src_file 원본파일이름(경로포함)
// as_tar_file 복사파일이름(경로포함)

if FileExists(as_tar_file) then
	if MessageBox("복사 확인", "파일이 존재합니다.~r~n바꾸시겠습니까?", Question!, YesNo!) <> 1 then
		return -1
	end if
end if

SetPointer(HourGlass!)
ll_flen = FileLength(as_src_file)
li_FileNum = FileOpen(as_src_file, StreamMode!, Read!, LockRead!)
li_FileNum2 = FileOpen(as_tar_file, StreamMode!, write!, LockRead!, Replace!)

IF ll_flen > 32765 THEN
   IF Mod(ll_flen, 32765) = 0 THEN
       li_loops = ll_flen / 32765
   ELSE
       li_loops = (ll_flen / 32765) + 1 
   END IF
ELSE
   li_loops = 1
END IF

FOR i = 1 TO li_loops
    ll_bytes_read = FileRead(li_FileNum, lb_data)
    FileWrite(li_FileNum2, lb_data)
NEXT

FileClose(li_FileNum) 
FileClose(li_FileNum2)

ll_flen2 = filelength(as_tar_file)

IF ll_flen <> ll_flen2 THEN
   MessageBox("복사 실패", "복사에 실패 했습니다.", StopSign!)
	return -1
END IF

return 1

end function

public function integer wf_get_directory (string as_title, ref string as_directory);BROWSEINFO bInfo
string ls_path
long ll_rc
long ll_item
int intSpace

If as_title = '' Then
	bInfo.Title = "대상 폴더를 선택하세요"
Else
	bInfo.Title = as_title
End If

ll_item = SHBrowseForFolderA(bInfo)
if ll_item = 0 then
	return -1
end if
ls_path = Space(512)
ll_rc = SHGetPathFromIDListA(ll_item, ls_path)

If ll_rc > 0 Then
	as_directory = ls_path
	return 1
Else
	return -1
End If

end function

on w_wflow_file_copy_sub.create
this.sle_src_nm=create sle_src_nm
this.st_2=create st_2
this.st_1=create st_1
this.cb_1=create cb_1
this.rb_3=create rb_3
this.st_tar=create st_tar
this.st_src=create st_src
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.sle_tar=create sle_tar
this.cb_tar=create cb_tar
this.cb_src=create cb_src
this.sle_src=create sle_src
this.rb_2=create rb_2
this.rb_1=create rb_1
this.Control[]={this.sle_src_nm,&
this.st_2,&
this.st_1,&
this.cb_1,&
this.rb_3,&
this.st_tar,&
this.st_src,&
this.cb_cancel,&
this.cb_ok,&
this.sle_tar,&
this.cb_tar,&
this.cb_src,&
this.sle_src,&
this.rb_2,&
this.rb_1}
end on

on w_wflow_file_copy_sub.destroy
destroy(this.sle_src_nm)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.rb_3)
destroy(this.st_tar)
destroy(this.st_src)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.sle_tar)
destroy(this.cb_tar)
destroy(this.cb_src)
destroy(this.sle_src)
destroy(this.rb_2)
destroy(this.rb_1)
end on

event open;string ls_filepath
wstr_parm ls_str_parm

f_window_center(this)

ls_str_parm = message.powerobjectparm


is_filepath 		= UPPER(ls_str_parm.s_parm[1])
is_proj_code 		= ls_str_parm.s_parm[2]
il_proj_seq  		= long(ls_str_parm.s_parm[3] )
il_gateway_seq 	= long(ls_str_parm.s_parm[4] )
il_activity_seq 	= long(ls_str_parm.s_parm[5] )
il_activity_sub_seq 	= long(ls_str_parm.s_parm[7] )
is_column       	= UPPER(ls_str_parm.s_parm[6])



//	ls_str_parm.s_parm[1] = ls_filepath 
//	ls_str_parm.s_parm[2] = THIS.OBJECT.proj_code[1]
//	ls_str_parm.s_parm[3] = string(THIS.OBJECT.proj_seq[1] )
//	ls_str_parm.s_parm[4] = string(This.object.gateway_seq[1] )
//	ls_str_parm.s_parm[5] = string(this.object.activity_seq[1] )
//	ls_str_parm.s_parm[6] = ls_column 
end event

type sle_src_nm from singlelineedit within w_wflow_file_copy_sub
integer x = 293
integer y = 292
integer width = 1001
integer height = 88
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_wflow_file_copy_sub
integer x = 23
integer y = 316
integer width = 256
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "저장명 :"
boolean focusrectangle = false
end type

type st_1 from statictext within w_wflow_file_copy_sub
integer x = 5
integer y = 32
integer width = 1280
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217729
long backcolor = 67108864
string text = "파일을 선택해 주십시오!"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_wflow_file_copy_sub
boolean visible = false
integer x = 901
integer y = 160
integer width = 402
integer height = 84
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "none"
end type

event clicked;Integer 	li_fp, li_loops, i, li_complete, li_rc
Long    	ll_new_pos, ll_flen, ll_bytes_read
Blob    	lbb_file_data, lbb_chunk
String  	ls_folder, ls_file_name, ls_file_id, ls_upd_dtms, ls_upd_check

SetPointer(HourGlass!)

ls_file_name = 'dddd.txt'
//			
//	SELECTBLOB FILE_DATA 
//	      INTO :lbb_file_data 
//			FROM Z_SOURCE
//	     WHERE FILE_ID = :ls_file_id	;

SELECTBLOB PRODUCT_FILE_BLOB1  
		 into :lbb_file_data 
		 From Flow_ACTIVITY_BLOB ;
//	  where PROJ_CODE  = :is_proj_code and
//			  proj_seq = :il_proj_seq and
//			  gateway_seq = :il_gateway_seq and
//			  activity_seq = :il_activity_seq ;



	If IsNull(lbb_file_data) Then
		messagebox('확인',ls_file_name +' DownLoad할 자료가 없습니다.~r~n시스템 담당자에게 문의하십시오.')
//		close(w_getblob)
//		GoTo next_rtn
	End If
	
	IF SQLCA.SQLCode = 0 AND Not IsNull(lbb_file_data) THEN
		li_fp = FileOpen(trim(ls_file_name) , StreamMode!, Write!, LockWrite!, replace!)

		ll_new_pos 	= 1
		li_loops 	= 0
		ll_flen 		= 0

		IF li_fp = -1 or IsNull(li_fp) then
			messagebox('확인',ls_folder + ' Folder가 존재치 않거나 사용중인 자료입니다.')
//			close(w_getblob)
//			GoTo next_rtn
		Else
			ll_flen = len(lbb_file_data)
			
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
				ll_bytes_read = filewrite(li_fp,lbb_file_data)
				Yield()					
//				w_getblob.uo_3d_meter.uf_set_position(100)	
			else
				for i = 1 to li_loops
					if i = li_loops then
						lbb_chunk = blobmid(lbb_file_data,ll_new_pos)
					else
						lbb_chunk = blobmid(lbb_file_data,ll_new_pos,32765)
					end if
					ll_bytes_read = filewrite(li_fp,lbb_chunk)
					ll_new_pos = ll_new_pos + ll_bytes_read

					Yield()
					li_complete = ( (32765 * i ) / len(lbb_file_data)) * 100
	//				w_getblob.uo_3d_meter.uf_set_position(li_complete)	
				next
					Yield()
	//				w_getblob.uo_3d_meter.uf_set_position(100)	
			end if
			
			li_rc = 0 
			
			FileClose(li_fp)

	//		SetProfileString(arg_ini, 'LIBRARY', ls_file_id, ls_upd_dtms)
	//		close(w_getblob)
			
		END IF
	END IF

end event

type rb_3 from radiobutton within w_wflow_file_copy_sub
boolean visible = false
integer x = 110
integer y = 36
integer width = 754
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "데이타베이스에 저장"
boolean checked = true
end type

event clicked;sle_tar.enabled = false
cb_tar.enabled = false

end event

type st_tar from statictext within w_wflow_file_copy_sub
boolean visible = false
integer x = 110
integer y = 564
integer width = 155
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "대상 :"
boolean focusrectangle = false
end type

type st_src from statictext within w_wflow_file_copy_sub
integer x = 18
integer y = 192
integer width = 265
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "원본파일 :"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_wflow_file_copy_sub
integer x = 987
integer y = 420
integer width = 311
integer height = 104
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "취소"
boolean cancel = true
end type

event clicked;setnull(gs_code) 
closewithreturn(parent, '')


end event

type cb_ok from commandbutton within w_wflow_file_copy_sub
integer x = 530
integer y = 420
integer width = 311
integer height = 104
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "등록"
end type

event clicked;Integer	li_row, li_rtn, li_rc
long 		ll_count
string	ls_path, ls_file, ls_dt_tm, ls_exec_id, ls_check, ls_app_id, ls_dtms, ls_folder
string 	ls_src_path, ls_tar_path
string	ls_src_path_temp, ls_file_nm
wstr_parm ls_str_parm

ls_src_path = sle_src.text
ls_file_nm  = sle_src_nm.text 
ls_tar_path = sle_tar.text

if trim(ls_src_path) = '' or isnull(ls_src_path) then
	messagebox('선택', '원본 파일을 선택하세요.')
	sle_src.setfocus()
	return
end if

if trim(ls_file_nm) = '' or isnull(ls_file_nm) then 
	messagebox('선택', '저장 파일명을 입력하세요.')
	sle_src_nm.setfocus() 
	return
end if 


if rb_1.checked then
	// 서버로 복사
	if ls_tar_path = '' then
		messagebox('선택', '대상 폴더를 선택하세요.')
		return
	end if
	// unc 로 변환(사용자마다 드라이브 지정이 다르므로)
	ls_tar_path = wf_path_to_unc(ls_tar_path)
	if right(ls_tar_path, 1) <> '\' then ls_tar_path += '\'
	ls_src_path_temp = ls_src_path // f_get_token_last() 에서 변경되므로 임시 저장
	ls_tar_path += f_get_token_last(ls_src_path_temp, '\')

	if wf_file_copy(ls_src_path, ls_tar_path) < 0 then
		return
	end if
	closewithreturn(parent, ls_tar_path)
elseIF rb_2.checked then 
	// unc 로 변환(사용자마다 드라이브 지정이 다르므로)
	ls_src_path = wf_path_to_unc(ls_src_path)
	closewithreturn(parent, ls_src_path)

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////
//데이타베이스 저장
/////////////////////


elseif rb_3.checked then 
		
	ls_file 		= upper(is_file)
	ls_path     = upper(is_path) 

	//////////////////////////////////////////
	// 선택한 FILE을 READ하여 DB에 INSERT
	//////////////////////////////////////////
	integer 	li_FileNum, loops, i
	long 		flen, bytes_read, new_pos
	blob 		b, tot_b
	
	flen = FileLength(ls_path)
	li_FileNum = FileOpen(ls_path, StreamMode!, Read!, LockRead!)
	
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
	
	FOR i = 1 to loops
		bytes_read = FileRead(li_FileNum, b)
		tot_b = tot_b + b
	NEXT
	
	FileClose(li_FileNum)	
	
	select to_char(sysdate,'YYYYMMDDHH24MISS') into :ls_dtms from dual;

		//Column별로 업데이트 내지 인서트 
		select count(proj_code) 
		  into :ll_count 
		  from FLOW_ACTIVITY_SUB_BLOB 
		 where PROJ_CODE  = :is_proj_code and
				 proj_seq = :il_proj_seq and
				 gateway_seq = :il_gateway_seq and
				 activity_seq = :il_activity_seq and
				 activity_sub_seq = :il_activity_sub_seq ;
		If SQLCA.SQLCODE <> 0 Then
				messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
				ROLLBACK USING SQLCA	;
				Return
		End if
		if ll_count = 0 or isnull(ll_count) then 
			//Insert
			if is_column = 'PRODUCT_FILE1' then 
				
				INSERT INTO FLOW_ACTIVITY_SUB_BLOB 
								( PROJ_CODE ,     
								PROJ_SEQ    ,   
								GATEWAY_SEQ ,   
								ACTIVITY_SEQ,
								ACTIVITY_SUB_SEQ,
								PRODUCT_FILE1, 
								IN_DT) 
					  VALUES (:is_proj_code, 
								:il_proj_seq,
								:il_gateway_seq,
								:il_activity_seq,
								:il_activity_sub_seq,
								:ls_file,  
								SYSDATE );
				If SQLCA.SQLCODE <> 0 Then
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						ROLLBACK USING SQLCA	;
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set PRODUCT_FILE_BLOB1 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq and 
							  activity_sub_seq = :il_activity_sub_seq ;
				
				If SQLCA.SQLCODE <> 0 Then
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
				   ROLLBACK USING SQLCA	;
					Return
				End if				
								
			elseif is_column = 'PRODUCT_FILE2' then 
				INSERT INTO FLOW_ACTIVITY_SUB_BLOB 
								( PROJ_CODE ,     
								PROJ_SEQ    ,   
								GATEWAY_SEQ ,   
								ACTIVITY_SEQ, 
								ACTIVITY_SUB_SEQ,
								PRODUCT_FILE2, 
								IN_DT) 
					  VALUES (:is_proj_code, 
								:il_proj_seq,
								:il_gateway_seq,
								:il_activity_seq,
								:il_activity_sub_seq,
								:ls_file,  
								SYSDATE );
				If SQLCA.SQLCODE <> 0 Then
					   MESSAGEBOX('ERR', SQLCA.SQLERRTEXT ) 
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT)
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set PRODUCT_FILE_BLOB2 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and 
				 			  activity_seq = :il_activity_seq and 
							  activity_sub_seq = :il_activity_sub_seq	;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT)
					Return
				End if				
			
			elseif is_column = 'PRODUCT_FILE3' then 
				INSERT INTO FLOW_ACTIVITY_SUB_BLOB 
								( PROJ_CODE ,     
								PROJ_SEQ    ,   
								GATEWAY_SEQ ,   
								ACTIVITY_SEQ, 
								ACTIVITY_SUB_SEQ, 
								PRODUCT_FILE3, 
								IN_DT) 
					  VALUES (:is_proj_code, 
								:il_proj_seq,
								:il_gateway_seq,
								:il_activity_seq,
								:il_activity_sub_seq,
								:ls_file,  
								SYSDATE );
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set PRODUCT_FILE_BLOB3 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq and
				 			  activity_sub_seq = :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'PRODUCT_FILE4' then 
				INSERT INTO FLOW_ACTIVITY_SUB_BLOB 
								( PROJ_CODE ,     
								PROJ_SEQ    ,   
								GATEWAY_SEQ ,   
								ACTIVITY_SEQ, 
								ACTIVITY_SUB_SEQ, 
								PRODUCT_FILE4, 
								IN_DT) 
					  VALUES (:is_proj_code, 
								:il_proj_seq,
								:il_gateway_seq,
								:il_activity_seq,
								:il_activity_sub_seq,
								:ls_file,  
								SYSDATE );
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set PRODUCT_FILE_BLOB4 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq and
				 			  activity_sub_seq = :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'PRODUCT_FILE5' then 
				INSERT INTO FLOW_ACTIVITY_SUB_BLOB 
								( PROJ_CODE ,     
								PROJ_SEQ    ,   
								GATEWAY_SEQ ,   
								ACTIVITY_SEQ, 
								ACTIVITY_SUB_SEQ, 
								PRODUCT_FILE5, 
								IN_DT) 
					  VALUES (:is_proj_code, 
								:il_proj_seq,
								:il_gateway_seq,
								:il_activity_seq,
								:il_activity_sub_seq,
								:ls_file,  
								SYSDATE );
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set PRODUCT_FILE_BLOB5 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq and
				 			  activity_sub_seq = :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'ATTACH_FILE1' then 
				INSERT INTO FLOW_ACTIVITY_SUB_BLOB 
								( PROJ_CODE ,     
								PROJ_SEQ    ,   
								GATEWAY_SEQ ,   
								ACTIVITY_SEQ, 
								ACTIVITY_SUB_SEQ, 
								ATTACH_FILE1, 
								IN_DT) 
					  VALUES (:is_proj_code, 
								:il_proj_seq,
								:il_gateway_seq,
								:il_activity_seq,
								:il_activity_sub_seq,
								:ls_file,  
								SYSDATE );
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set ATTACH_FILE_BLOB1 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq and
				 			  activity_sub_seq = :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'ATTACH_FILE2' then 
				INSERT INTO FLOW_ACTIVITY_SUB_BLOB 
								( PROJ_CODE ,     
								PROJ_SEQ    ,   
								GATEWAY_SEQ ,   
								ACTIVITY_SEQ, 
								ACTIVITY_SUB_SEQ, 
								ATTACH_FILE2, 
								IN_DT) 
					  VALUES (:is_proj_code, 
								:il_proj_seq,
								:il_gateway_seq,
								:il_activity_seq,
								:il_activity_sub_seq,
								:ls_file,  
								SYSDATE );
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set ATTACH_FILE_BLOB2 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq and
				 			  activity_sub_seq = :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'ATTACH_FILE3' then 
				INSERT INTO FLOW_ACTIVITY_SUB_BLOB 
								( PROJ_CODE ,     
								PROJ_SEQ    ,   
								GATEWAY_SEQ ,   
								ACTIVITY_SEQ, 
								ACTIVITY_SUB_SEQ, 
								ATTACH_FILE3, 
								IN_DT) 
					  VALUES (:is_proj_code, 
								:il_proj_seq,
								:il_gateway_seq,
								:il_activity_seq,
								:il_activity_sub_seq,
								:ls_file,  
								SYSDATE );
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set ATTACH_FILE_BLOB3 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq and
				 			  activity_sub_seq = :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'ATTACH_FILE4' then 
				INSERT INTO FLOW_ACTIVITY_SUB_BLOB 
								( PROJ_CODE ,     
								PROJ_SEQ    ,   
								GATEWAY_SEQ ,   
								ACTIVITY_SEQ, 
								ACTIVITY_SUB_SEQ, 
								ATTACH_FILE4, 
								IN_DT) 
					  VALUES (:is_proj_code, 
								:il_proj_seq,
								:il_gateway_seq,
								:il_activity_seq,
								:il_activity_sub_seq,
								:ls_file,  
								SYSDATE );
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set ATTACH_FILE_BLOB4 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq and
				 			  activity_sub_seq = :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'ATTACH_FILE5' then 
				INSERT INTO FLOW_ACTIVITY_SUB_BLOB 
								( PROJ_CODE ,     
								PROJ_SEQ    ,   
								GATEWAY_SEQ ,   
								ACTIVITY_SEQ, 
								ACTIVITY_SUB_SEQ, 
								ATTACH_FILE5, 
								IN_DT) 
					  VALUES (:is_proj_code, 
								:il_proj_seq,
								:il_gateway_seq,
								:il_activity_seq,
								:il_activity_sub_seq,
								:ls_file,  
								SYSDATE );
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set PATTACH_FILE_BLOB5 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq and
				 			  activity_sub_seq = :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if
			end if 	
	   elseif ll_count = 1 then 
	 		//Update 
			if is_column = 'PRODUCT_FILE1' then 
				
				UPDATE FLOW_ACTIVITY_SUB_BLOB 
					SET PRODUCT_FILE1 = :ls_file, 
						 MOD_DT 			= SYSDATE  
				 WHERE PROJ_CODE 		= :is_proj_code and
						 PROJ_SEQ    	= :il_proj_seq AND 
						 GATEWAY_SEQ 	= :il_gateway_seq AND
						 ACTIVITY_SEQ	= :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
						 
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set PRODUCT_FILE_BLOB1 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
								
			elseif is_column = 'PRODUCT_FILE2' then 
				UPDATE FLOW_ACTIVITY_SUB_BLOB 
					SET PRODUCT_FILE2 = :ls_file, 
						 MOD_DT 			= SYSDATE  
				 WHERE PROJ_CODE 		= :is_proj_code and
						 PROJ_SEQ    	= :il_proj_seq AND 
						 GATEWAY_SEQ 	= :il_gateway_seq AND
						 ACTIVITY_SEQ	= :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;

				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set PRODUCT_FILE_BLOB2 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			
			elseif is_column = 'PRODUCT_FILE3' then 
				UPDATE FLOW_ACTIVITY_SUB_BLOB 
					SET PRODUCT_FILE3 = :ls_file, 
						 MOD_DT 			= SYSDATE  
				 WHERE PROJ_CODE 		= :is_proj_code and
						 PROJ_SEQ    	= :il_proj_seq AND 
						 GATEWAY_SEQ 	= :il_gateway_seq AND
						 ACTIVITY_SEQ	= :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' )
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set PRODUCT_FILE_BLOB3 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'PRODUCT_FILE4' then 
				UPDATE FLOW_ACTIVITY_SUB_BLOB 
					SET PRODUCT_FILE4 = :ls_file, 
						 MOD_DT 			= SYSDATE  
				 WHERE PROJ_CODE 		= :is_proj_code and
						 PROJ_SEQ    	= :il_proj_seq AND 
						 GATEWAY_SEQ 	= :il_gateway_seq AND
						 ACTIVITY_SEQ	= :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set PRODUCT_FILE_BLOB4 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'PRODUCT_FILE5' then 
				UPDATE FLOW_ACTIVITY_SUB_BLOB 
					SET PRODUCT_FILE5 = :ls_file, 
						 MOD_DT 			= SYSDATE  
				 WHERE PROJ_CODE 		= :is_proj_code and
						 PROJ_SEQ    	= :il_proj_seq AND 
						 GATEWAY_SEQ 	= :il_gateway_seq AND
						 ACTIVITY_SEQ	= :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set PRODUCT_FILE_BLOB5 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'ATTACH_FILE1' then 
				UPDATE FLOW_ACTIVITY_SUB_BLOB 
					SET ATTACH_FILE1 = :ls_file, 
						 MOD_DT 			= SYSDATE  
				 WHERE PROJ_CODE 		= :is_proj_code and
						 PROJ_SEQ    	= :il_proj_seq AND 
						 GATEWAY_SEQ 	= :il_gateway_seq AND
						 ACTIVITY_SEQ	= :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set ATTACH_FILE_BLOB1 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'ATTACH_FILE2' then 
				UPDATE FLOW_ACTIVITY_SUB_BLOB 
					SET ATTACH_FILE2 = :ls_file, 
						 MOD_DT 			= SYSDATE  
				 WHERE PROJ_CODE 		= :is_proj_code and
						 PROJ_SEQ    	= :il_proj_seq AND 
						 GATEWAY_SEQ 	= :il_gateway_seq AND
						 ACTIVITY_SEQ	= :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;

				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set ATTACH_FILE_BLOB2 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'ATTACH_FILE3' then 
				UPDATE FLOW_ACTIVITY_SUB_BLOB 
					SET ATTACH_FILE3 = :ls_file, 
						 MOD_DT 			= SYSDATE  
				 WHERE PROJ_CODE 		= :is_proj_code and
						 PROJ_SEQ    	= :il_proj_seq AND 
						 GATEWAY_SEQ 	= :il_gateway_seq AND
						 ACTIVITY_SEQ	= :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;

				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set ATTACH_FILE_BLOB3 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'ATTACH_FILE4' then 
				UPDATE FLOW_ACTIVITY_SUB_BLOB 
					SET ATTACH_FILE4 = :ls_file, 
						 MOD_DT 			= SYSDATE  
				 WHERE PROJ_CODE 		= :is_proj_code and
						 PROJ_SEQ    	= :il_proj_seq AND 
						 GATEWAY_SEQ 	= :il_gateway_seq AND
						 ACTIVITY_SEQ	= :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;

				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set ATTACH_FILE_BLOB4 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if				
			elseif is_column = 'ATTACH_FILE5' then 
				UPDATE FLOW_ACTIVITY_SUB_BLOB 
					SET ATTACH_FILE5 = :ls_file, 
						 MOD_DT 			= SYSDATE  
				 WHERE PROJ_CODE 		= :is_proj_code and
						 PROJ_SEQ    	= :il_proj_seq AND 
						 GATEWAY_SEQ 	= :il_gateway_seq AND
						 ACTIVITY_SEQ	= :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;

				If SQLCA.SQLCODE <> 0 Then
						ROLLBACK USING SQLCA	;
						messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
						Return
				End if
				
				//Blob 저장
				UpdateBlob FLOW_ACTIVITY_SUB_BLOB  
				       set ATTACH_FILE_BLOB5 = :tot_b
		 			  where PROJ_CODE  = :is_proj_code and
				 			  proj_seq = :il_proj_seq and
				 			  gateway_seq = :il_gateway_seq and
				 			  activity_seq = :il_activity_seq AND
						 ACTIVITY_SUB_SEQ	= :il_activity_sub_seq;
				
				If SQLCA.SQLCODE <> 0 Then
					ROLLBACK USING SQLCA	;
					messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					Return
				End if
			end if 	
			 
		else
			//알수 없는 에러
			messagebox('Err' , '알수가 없어~~~`')
		end if 

			
	COMMIT USING SQLCA	;
	
	IF ls_file = '' or isnull(ls_file) then 	
   	ls_str_parm.s_parm[1] = is_path
		setnull(gs_code) 
	else 
		ls_str_parm.s_parm[1] = ls_file_nm
		gs_code = 'Y'
	end if 
	closewithreturn(parent, ls_str_parm)

end if

end event

type sle_tar from singlelineedit within w_wflow_file_copy_sub
boolean visible = false
integer x = 265
integer y = 552
integer width = 1001
integer height = 88
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_tar from commandbutton within w_wflow_file_copy_sub
boolean visible = false
integer x = 1275
integer y = 552
integer width = 91
integer height = 88
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_path

ls_path = sle_tar.text
if wf_get_directory('대상 폴더를 선택하세요', ls_path) = 1 then
	sle_tar.text = ls_path
end if

end event

type cb_src from commandbutton within w_wflow_file_copy_sub
integer x = 1303
integer y = 172
integer width = 91
integer height = 88
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_path, ls_file

if GetFileOpenName('원본 파일을 선택하세요', ls_path, ls_file) = 1 then
	sle_src.text = ls_path
	sle_src_nm.text = ls_file
	is_path = ls_path 
	is_file = ls_file
end if

end event

type sle_src from singlelineedit within w_wflow_file_copy_sub
integer x = 293
integer y = 172
integer width = 1001
integer height = 88
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type rb_2 from radiobutton within w_wflow_file_copy_sub
boolean visible = false
integer x = 123
integer y = 188
integer width = 754
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "서버에 있는 파일 지정"
end type

event clicked;sle_tar.enabled = false
cb_tar.enabled = false

end event

type rb_1 from radiobutton within w_wflow_file_copy_sub
boolean visible = false
integer x = 123
integer y = 72
integer width = 768
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "내 PC에서 서버로 복사"
end type

event clicked;sle_tar.enabled = true
cb_tar.enabled = true

end event

