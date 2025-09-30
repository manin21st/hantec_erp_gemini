$PBExportHeader$w_sys_mig.srw
$PBExportComments$**24.11.05_소스 마이그레이션
forward
global type w_sys_mig from w_inherite
end type
type st_2 from statictext within w_sys_mig
end type
type sle_user from singlelineedit within w_sys_mig
end type
type gb_1 from groupbox within w_sys_mig
end type
type cb_refresh from commandbutton within w_sys_mig
end type
type dw_insert_all from datawindow within w_sys_mig
end type
type dw_user_all from datawindow within w_sys_mig
end type
type dw_user from u_key_enter within w_sys_mig
end type
type p_1 from picture within w_sys_mig
end type
type cb_migrate from commandbutton within w_sys_mig
end type
type cb_scan from commandbutton within w_sys_mig
end type
type dw_pbl from u_key_enter within w_sys_mig
end type
type cb_test from commandbutton within w_sys_mig
end type
type cb_library_export from commandbutton within w_sys_mig
end type
type dw_mig from u_key_enter within w_sys_mig
end type
type cb_pbl_copy from commandbutton within w_sys_mig
end type
type hpb_sts from hprogressbar within w_sys_mig
end type
type st_sts from statictext within w_sys_mig
end type
type rr_2 from roundrectangle within w_sys_mig
end type
type rr_3 from roundrectangle within w_sys_mig
end type
end forward

global type w_sys_mig from w_inherite
integer width = 4823
integer height = 5284
string title = "소스 마이그레이션"
st_2 st_2
sle_user sle_user
gb_1 gb_1
cb_refresh cb_refresh
dw_insert_all dw_insert_all
dw_user_all dw_user_all
dw_user dw_user
p_1 p_1
cb_migrate cb_migrate
cb_scan cb_scan
dw_pbl dw_pbl
cb_test cb_test
cb_library_export cb_library_export
dw_mig dw_mig
cb_pbl_copy cb_pbl_copy
hpb_sts hpb_sts
st_sts st_sts
rr_2 rr_2
rr_3 rr_3
end type
global w_sys_mig w_sys_mig

type prototypes
function long PBORCA_SessionOpen() library "pborc100.dll"
subroutine   PBORCA_SessionClose(long session) library "pborc100.dll"
function int PBORCA_LibraryCreate(long session, String pblName, String pblComments) library "pborc100.dll"
function int PBORCA_LibraryDelete(long hORCASession, String  LibName ) library "pborc100.dll"
function int PBORCA_LibraryEntryCopy(long hORCASession, String SourceLibName, String DestLibName, String EntryName, int EntryType) library "pborc100.dll"
function int PBORCA_LibraryEntryExport(long hORCASession, String LibName, String EntryName, int EntryType, ref string ExportBuffer, long ExportBufferSize) library "pborc100.dll"
function int PBORCA_DynamicLibraryCreate(long hORCASession, String LibraryName, String PBRName, long Flags) library "pborc100.dll"
function int PBORCA_CompileEntryImport(long hORCASession, String LibraryName, String EntryName, int EntryType, String Comments, String EntrySyntax, long EntrySyntaxBuffSize, long CompErrProc, long UserData)  library "pborc100.dll"

end prototypes

type variables
constant int PBORCA_APPLICATION = 0;
constant int PBORCA_DATAWINDOW = 1;
constant int PBORCA_FUNCTION = 2;
constant int PBORCA_MENU = 3;
constant int PBORCA_QUERY = 4;
constant int PBORCA_STRUCTURE = 5;
constant int PBORCA_USEROBJECT = 6;
constant int PBORCA_WINDOW = 7;
constant int PBORCA_PIPELINE = 8;
constant int PBORCA_PROJECT = 9;
constant int PBORCA_PROXYOBJECT = 10;
constant int PBORCA_BINARY = 11;

constant string DELIMITER = "~t~r~n~"'~~!@#$%^&*()-+=|\[{]};:`<>?,./"

long		ii_sess
string		is_work_dir

end variables

forward prototypes
public function string wf_filter (datawindow dwo, integer row, boolean gb)
public function string xf_getline (string as_content, ref integer ai_pos)
public subroutine xf_window_migrate (string as_library_path, string as_window_id)
public subroutine xf_test (string as_library_path, string as_window_id)
public subroutine wf_list_pbl ()
public function integer wf_export_win ()
public function integer wf_copy_pbl ()
end prototypes

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

public function string xf_getline (string as_content, ref integer ai_pos);integer li_end

li_end = Pos(as_content, "~r~n", ai_pos)
IF li_end = 0 THEN
  li_end = Len(as_content) + 1
END IF

string ls_line
ls_line = Mid(as_content, ai_pos, li_end - ai_pos)
ai_pos = li_end + 2

RETURN ls_line
end function

public subroutine xf_window_migrate (string as_library_path, string as_window_id);// PowerBuilder 스크립트를 사용하여 PBL에서 윈도우 소스를 수정합니다 (from ChatGPT 4o with canvas)
OLEObject oleObject
integer li_rtn
string ls_library_path, ls_window_id, ls_temp_file_path, ls_fileContent

// 수정할 라이브러리와 윈도우 정의
ls_library_path = as_library_path
ls_window_id = as_window_id
//ls_library_path = "c:\temp\test.pbl"
//ls_window_id = "w_test"

// PowerBuilder의 내보내기 기능과 상호작용하기 위해 OLE 객체 생성
oleObject = CREATE OLEObject
li_rtn = oleObject.ConnectToNewObject("pbole.powerscript")
IF li_rtn <> 0 THEN
    MessageBox("오류", "OLEObject 생성 실패.")
    RETURN
END IF

// 라이브러리 경로 하위에 임시 폴더를 생성하고 사용
string ls_temp_folder
ls_temp_folder = Left(ls_library_path, LastPos(ls_library_path, "\")) + "src"
IF NOT DirectoryExists(ls_temp_folder) THEN
	CreateDirectory(ls_temp_folder)
END IF

// 윈도우 소스를 임시 파일로 내보내기
ls_temp_file_path = ls_temp_folder + "\" + ls_window_id + ".txt"
li_rtn = oleObject.LibraryExport(ls_library_path, ls_window_id, ls_temp_file_path)
IF li_rtn <> 1 THEN
    MessageBox("오류", "내보내기 실패.")
    RETURN
END IF

// 파일 내용 읽기
integer li_fileNum
li_fileNum = FileOpen(ls_temp_file_path, StreamMode!, Read!)
IF li_fileNum <= 0 THEN
    MessageBox("오류", "내보낸 파일을 열 수 없습니다.")
    RETURN
END IF

ls_fileContent = ""

string ls_line
DO WHILE FileRead(li_fileNum, ls_line) = 1
    ls_fileContent += ls_line + "~r~n"  // 줄 바꿈 유지
LOOP
FileClose(li_fileNum)

// 파일 내용 수정 - cb_1의 정의와 관련된 모든 이벤트 및 참조 제거 및 sle_1 추가
string ls_newContent
integer li_pos
ls_newContent = ""
li_pos = 1

// cb_1의 정의와 관련된 모든 부분 제거
boolean lb_remove = false
DO WHILE li_pos <= Len(ls_fileContent)
    ls_line = xf_getline(ls_fileContent, li_pos)
    // cb_1 정의 시작 여부 확인
    IF Pos(ls_line, "type cb_1") > 0 THEN
        lb_remove = true
    END IF
    
    // cb_1 정의 끝 여부 확인
    IF lb_remove AND Pos(ls_line, "end type") > 0 THEN
        lb_remove = false
        CONTINUE
    END IF
    
    // cb_1 이벤트 제거 시작 여부 확인
    IF Pos(ls_line, "cb_1::") > 0 THEN
        lb_remove = true
    END IF

    // cb_1 이벤트 끝 여부 확인
    IF lb_remove AND Pos(ls_line, "end event") > 0 THEN
        lb_remove = false
        CONTINUE
    END IF

    // cb_1과 관련된 줄을 제거하는 동안 다음 줄로 넘어감
    IF NOT lb_remove THEN
        ls_newContent += ls_line + "~r~n"
    END IF
LOOP

// 새로운 SingleLineEdit 컨트롤 sle_1 추가
ls_newContent += "type sle_1 from SingleLineEdit within w_test~r~n"
ls_newContent += 'string text = "글자를 입력하세요"~r~n'
ls_newContent += "end type~r~n"

// 수정된 내용을 파일에 다시 쓰기
li_fileNum = FileOpen(ls_temp_file_path, StreamMode!, Write!)
IF li_fileNum <= 0 THEN
    MessageBox("오류", "파일을 쓰기 위해 열 수 없습니다.")
    RETURN
END IF

FileWrite(li_fileNum, ls_newContent)
FileClose(li_fileNum)

// 수정된 소스를 라이브러리에 다시 가져오기
li_rtn = oleObject.LibraryImport(ls_library_path, ls_temp_file_path, Replace!)
IF li_rtn <> 1 THEN
    MessageBox("오류", "가져오기 실패.")
    RETURN
END IF

MessageBox("성공", "윈도우가 성공적으로 수정되었습니다.")

// OLEObject 삭제
DESTROY oleObject
end subroutine

public subroutine xf_test (string as_library_path, string as_window_id);// PowerBuilder 스크립트를 사용하여 PBL에서 윈도우 소스를 수정합니다 (from ChatGPT 4o with canvas)
OLEObject oleObject
integer li_rtn
string ls_library_path, ls_window_id, ls_temp_file_path, ls_fileContent

// 수정할 라이브러리와 윈도우 정의
ls_library_path = as_library_path
ls_window_id = as_window_id
//ls_library_path = "c:\temp\test.pbl"
//ls_window_id = "w_test"

// PowerBuilder의 내보내기 기능과 상호작용하기 위해 OLE 객체 생성
oleObject = CREATE OLEObject
li_rtn = oleObject.ConnectToNewObject("pbole.powerscript")
IF li_rtn <> 0 THEN
    MessageBox("오류", "OLEObject 생성 실패. 오류 코드: " + String(li_rtn))
    RETURN
END IF

// 라이브러리 경로 하위에 임시 폴더를 생성하고 사용
string ls_temp_folder
ls_temp_folder = Left(ls_library_path, LastPos(ls_library_path, "\")) + "src"
IF NOT DirectoryExists(ls_temp_folder) THEN
	CreateDirectory(ls_temp_folder)
END IF

// 윈도우 소스를 임시 파일로 내보내기
ls_temp_file_path = ls_temp_folder + "\" + ls_window_id + ".txt"
li_rtn = oleObject.LibraryExport(ls_library_path, ls_window_id, ls_temp_file_path)
IF li_rtn <> 1 THEN
    MessageBox("오류", "내보내기 실패.")
    RETURN
END IF

// 파일 내용 읽기
integer li_fileNum
li_fileNum = FileOpen(ls_temp_file_path, StreamMode!, Read!)
IF li_fileNum <= 0 THEN
    MessageBox("오류", "내보낸 파일을 열 수 없습니다.")
    RETURN
END IF

ls_fileContent = ""

string ls_line
DO WHILE FileRead(li_fileNum, ls_line) = 1
    ls_fileContent += ls_line + "~r~n"  // 줄 바꿈 유지
LOOP
FileClose(li_fileNum)

// 파일 내용 수정 - cb_1의 정의와 관련된 모든 이벤트 및 참조 제거 및 sle_1 추가
string ls_newContent
integer li_pos
ls_newContent = ""
li_pos = 1

// cb_1의 정의와 관련된 모든 부분 제거
boolean lb_remove = false
DO WHILE li_pos <= Len(ls_fileContent)
    ls_line = xf_getline(ls_fileContent, li_pos)
    // cb_1 정의 시작 여부 확인
    IF Pos(ls_line, "type p_xls") > 0 THEN
        lb_remove = true
    END IF
    
    // cb_1 정의 끝 여부 확인
    IF lb_remove AND Pos(ls_line, "end type") > 0 THEN
        lb_remove = false
        CONTINUE
    END IF
    
    // cb_1 이벤트 제거 시작 여부 확인
    IF Pos(ls_line, "p_xls::") > 0 THEN
        lb_remove = true
    END IF

    // cb_1 이벤트 끝 여부 확인
    IF lb_remove AND Pos(ls_line, "end event") > 0 THEN
        lb_remove = false
        CONTINUE
    END IF

    // cb_1과 관련된 줄을 제거하는 동안 다음 줄로 넘어감
    IF NOT lb_remove THEN
        ls_newContent += ls_line + "~r~n"
    END IF
LOOP

// 새로운 SingleLineEdit 컨트롤 sle_1 추가
ls_newContent += "type sle_1 from SingleLineEdit within w_test~r~n"
ls_newContent += 'string text = "글자를 입력하세요"~r~n'
ls_newContent += "end type~r~n"

// 수정된 내용을 파일에 다시 쓰기
li_fileNum = FileOpen(ls_temp_file_path, StreamMode!, Write!)
IF li_fileNum <= 0 THEN
    MessageBox("오류", "파일을 쓰기 위해 열 수 없습니다.")
    RETURN
END IF

FileWrite(li_fileNum, ls_newContent)
FileClose(li_fileNum)

// 수정된 소스를 라이브러리에 다시 가져오기
li_rtn = oleObject.LibraryImport(ls_library_path, ls_temp_file_path, Replace!)
IF li_rtn <> 1 THEN
    MessageBox("오류", "가져오기 실패.")
    RETURN
END IF

MessageBox("성공", "윈도우가 성공적으로 수정되었습니다.")

// OLEObject 삭제
DESTROY oleObject
end subroutine

public subroutine wf_list_pbl ();Long		i, j, k
String		ls_libraries, ls_library_name, ls_entries, ls_library_array[]
Integer 	li_library_count, li_library_index, li_start, li_end, li_index

ls_libraries = GetLibraryList()

dw_pbl.SetRedraw(FALSE)
dw_pbl.Reset()

li_start = 1
li_index = 1

DO WHILE li_start <= Len(ls_libraries)
	
	li_end = Pos(ls_libraries, ",", li_start)
	IF li_end = 0 THEN
		li_end = Len(ls_libraries) + 1
	END IF
	
	ls_library_name = Trim(Mid(ls_libraries, li_start, li_end - li_start))
	ls_entries = LibraryDirectory(ls_library_name, DirWindow!)
	
	k = dw_pbl.RowCount()
	dw_pbl.ImportString(ls_Entries)
	
	FOR i = k + 1 TO dw_pbl.RowCount()
		dw_pbl.SetItem(i, "pbl_name", ls_library_name)
	NEXT

    li_start = li_end + 1
LOOP

dw_pbl.SetRedraw(TRUE)

end subroutine

public function integer wf_export_win ();string ls_LibName, ls_wLibName
string ls_tar_path
string ls_targetLibName, ls_targetPbdName, ls_Objectname
string ls_filename, ls_syntax
long 	ll_row, ll_rowcount, ll_BufferSize=8192, session
int 	li_rc, li_fileNum, li_error_count_sum

setpointer(HourGlass!)

ls_tar_path = is_work_dir + "\win"
if right(ls_tar_path, 1) <> '\' then ls_tar_path += '\'

if CreateDirectory(ls_tar_path) = -1 then
	messagebox('확인', '작업 폴더 생성 오류!')
	return -1
end if

ll_rowcount = dw_pbl.rowcount()

hpb_sts.position = 0
hpb_sts.maxposition = ll_rowcount
st_sts.text = "Window 소스 추출 중..."

session = PBORCA_SessionOpen()

for ll_row = 1 to ll_rowcount
	hpb_sts.position = ll_row
	
	ls_LibName = dw_pbl.getitemstring(ll_row, 'pbl_name')
	ls_wLibName = f_replace_all(ls_LibName, "\", "\\")
	ls_Objectname = dw_pbl.getitemstring(ll_row, 'obj_name')

	//ls_syntax = LibraryExport(ls_LibName, ls_Objectname, ExportDataWindow!)
	//ls_syntax = LibraryExport(ls_LibName, ls_Objectname, ExportWindow!)
	li_rc = PBORCA_LibraryEntryExport(session, ls_wLibName, ls_Objectname, PBORCA_WINDOW, ls_syntax, 120000)
	if ls_syntax = "" or li_rc <> 0  then
		li_error_count_sum++
		messagebox('Error', 'PBORCA_LibraryEntryExport = ' + String(li_rc))
		return -1
	else
		ls_filename = ls_tar_path + ls_Objectname + ".srw"
		
		li_fileNum = FileOpen(ls_filename, StreamMode!, Write!)
		IF li_fileNum <= 0 THEN
			messagebox("오류", "파일을 쓰기 위해 열 수 없습니다.")
			return -1
		END IF
		
		FileWrite(li_fileNum, ls_syntax)
		FileClose(li_fileNum)
	end if

next

st_sts.text = "Window 소스 추출 완료!"

// PB 환경에서 호출하면 PB 도 다운됨
if Handle(GetApplication()) <> 0 then
	PBORCA_SessionClose(session)
end if

return 1
end function

public function integer wf_copy_pbl ();string ls_LibName
string ls_tar_path
string ls_targetLibName, ls_targetPbdName
string ls_filename
long 	ll_row, ll_rowcount
int 	li_error_count_sum

setpointer(HourGlass!)

ls_tar_path = is_work_dir + "\"			//as_tar_path
if right(ls_tar_path, 1) <> '\' then ls_tar_path += '\'

if CreateDirectory(ls_tar_path) = -1 then
	messagebox('확인', '작업 폴더 생성 오류!')
	return -1
end if

ll_rowcount = dw_pbl.rowcount()

hpb_sts.position = 0
hpb_sts.maxposition = ll_rowcount
st_sts.text = "PBL 파일 복사 중..."

for ll_row = 1 to ll_rowcount
	hpb_sts.position = ll_row
	
	ls_LibName = dw_pbl.getitemstring(ll_row, 'pbl_name')
	ls_filename = Mid(ls_LibName, LastPos(ls_LibName, "\") + 1)
	ls_targetLibName = ls_tar_path + ls_filename
	
	// PBL 없으면 복사..
	if not FileExists(ls_targetLibName) then
		if FileCopy(ls_LibName, ls_targetLibName) < 1 then
			li_error_count_sum++
			continue
		end if
	end if
next

st_sts.text = "PBL 파일 복사 완료!"

return 1
end function

on w_sys_mig.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_user=create sle_user
this.gb_1=create gb_1
this.cb_refresh=create cb_refresh
this.dw_insert_all=create dw_insert_all
this.dw_user_all=create dw_user_all
this.dw_user=create dw_user
this.p_1=create p_1
this.cb_migrate=create cb_migrate
this.cb_scan=create cb_scan
this.dw_pbl=create dw_pbl
this.cb_test=create cb_test
this.cb_library_export=create cb_library_export
this.dw_mig=create dw_mig
this.cb_pbl_copy=create cb_pbl_copy
this.hpb_sts=create hpb_sts
this.st_sts=create st_sts
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_user
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.cb_refresh
this.Control[iCurrent+5]=this.dw_insert_all
this.Control[iCurrent+6]=this.dw_user_all
this.Control[iCurrent+7]=this.dw_user
this.Control[iCurrent+8]=this.p_1
this.Control[iCurrent+9]=this.cb_migrate
this.Control[iCurrent+10]=this.cb_scan
this.Control[iCurrent+11]=this.dw_pbl
this.Control[iCurrent+12]=this.cb_test
this.Control[iCurrent+13]=this.cb_library_export
this.Control[iCurrent+14]=this.dw_mig
this.Control[iCurrent+15]=this.cb_pbl_copy
this.Control[iCurrent+16]=this.hpb_sts
this.Control[iCurrent+17]=this.st_sts
this.Control[iCurrent+18]=this.rr_2
this.Control[iCurrent+19]=this.rr_3
end on

on w_sys_mig.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_user)
destroy(this.gb_1)
destroy(this.cb_refresh)
destroy(this.dw_insert_all)
destroy(this.dw_user_all)
destroy(this.dw_user)
destroy(this.p_1)
destroy(this.cb_migrate)
destroy(this.cb_scan)
destroy(this.dw_pbl)
destroy(this.cb_test)
destroy(this.cb_library_export)
destroy(this.dw_mig)
destroy(this.cb_pbl_copy)
destroy(this.hpb_sts)
destroy(this.st_sts)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;/*
CREATE SEQUENCE SYS_MIG_SEQ MAXVALUE 99999999999 CYCLE START WITH 1;

DROP TABLE SYS_MIG_PBL;
CREATE TABLE SYS_MIG_PBL (
	SEQ_NO					NUMBER NOT NULL,
	MODIFY_TYPE	VARCHAR2(3),					--ADD, DEL, MOD
	OBJECT_TYPE	VARCHAR2(3),				--WIN, DWN
	FIND_TEXT			VARCHAR2(1000),
	REPLACE_TEXT	VARCHAR2(1000),
	WORK_ORDER	VARCHAR2(100),
	WORK_NOTE		VARCHAR2(100)
	);

ALTER TABLE SYS_MIG_PBL ADD (
	CONSTRAINT PK_SYS_MIG_PBL PRIMARY KEY (SEQ_NO));
*/


dw_insert.SetTransObject(sqlca)
dw_user.SetTransObject(sqlca)
dw_mig.SetTransObject(sqlca)

p_inq.TriggerEvent(Clicked!)

is_work_dir = GetCurrentDirectory() + "\mig"

end event

type dw_insert from w_inherite`dw_insert within w_sys_mig
event ue_mousemove pbm_mousemove
event ue_bdown pbm_lbuttondown
event ue_bup pbm_lbuttonup
integer x = 2875
integer y = 2312
integer width = 1669
integer height = 308
integer taborder = 20
string dragicon = "WinLogo!"
string dataobject = "d_sys_mig3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::rowfocuschanged;//This.SelectRow(0,false)
//This.SelectRow(currentrow, True)
//
//if currentrow > 0 then 
//	string swin_id
//	
//	swin_id = this.getitemstring(currentrow, 'window_name')
//	if swin_id > '.' then 
//		dw_1.setitem(1, 'win_nm', this.getitemstring(currentrow, 'sub2_name'))
//		dw_1.setitem(1, 'win_id', swin_id)
//	else
//		dw_1.setitem(1, 'win_nm', '')
//		dw_1.setitem(1, 'win_id', '')
//	end if
//end if
end event

type p_delrow from w_inherite`p_delrow within w_sys_mig
boolean visible = false
integer x = 3813
integer y = 2416
end type

type p_addrow from w_inherite`p_addrow within w_sys_mig
boolean visible = false
integer x = 3630
integer y = 2412
end type

type p_search from w_inherite`p_search within w_sys_mig
boolean visible = false
integer x = 1435
integer y = 2720
end type

type p_ins from w_inherite`p_ins within w_sys_mig
integer x = 3730
integer y = 20
end type

event p_ins::clicked;call super::clicked;Long	lRow

lRow = dw_mig.InsertRow(0)
end event

type p_exit from w_inherite`p_exit within w_sys_mig
integer x = 4425
integer y = 20
end type

type p_can from w_inherite`p_can within w_sys_mig
integer x = 4251
integer y = 20
end type

event p_can::clicked;call super::clicked;
/* 사용자별 Program 조회 */
dw_user.Retrieve(Trim(sle_user.Text))

end event

type p_print from w_inherite`p_print within w_sys_mig
boolean visible = false
integer x = 1170
integer y = 2496
end type

type p_inq from w_inherite`p_inq within w_sys_mig
integer x = 3557
integer y = 20
end type

event p_inq::clicked;call super::clicked;String sUserId
Long   nCnt

sUserId = Trim(sle_user.Text)
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
	
dw_user.Retrieve(sUserId)
dw_user.SetFocus()
dw_user.SetFilter("( sub2_id = 99 or sub2_id = 100 ) ")
dw_user.Filter()

dw_mig.Retrieve()

dw_user.Visible = True
dw_mig.x = dw_user.x + dw_user.width + 37
dw_mig.width = 2889

end event

type p_del from w_inherite`p_del within w_sys_mig
integer x = 3904
integer y = 20
end type

event p_del::clicked;call super::clicked;dw_mig.DeleteRow(0)
end event

type p_mod from w_inherite`p_mod within w_sys_mig
integer x = 4078
integer y = 20
end type

event p_mod::clicked;call super::clicked;long	i, ll_seq
string	ls_modify_type

if dw_mig.AcceptText() = -1 then return 

FOR i = 1 TO dw_mig.RowCount()

	ls_modify_type = dw_mig.GetItemString(i,'modify_type')
	if isnull(ls_modify_type) or ls_modify_type = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 Modify Type]')
		dw_mig.ScrollToRow(i)
		dw_mig.SetColumn('modify_type')
		dw_mig.SetFocus()
		return
	end if	

	if isnull(dw_mig.GetItemString(i,'object_type')) or &
		dw_mig.GetItemString(i,'object_type') = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 Object Type]')
		dw_mig.ScrollToRow(i)
		dw_mig.SetColumn('object_type')
		dw_mig.SetFocus()
		return
	end if	
	
	if isnull(dw_mig.GetItemString(i,'find_text')) or &
		dw_mig.GetItemString(i,'find_text') = "" then
		f_message_chk(1400,'[ '+string(i)+' 행 Find Text]')
		dw_mig.ScrollToRow(i)
		dw_mig.SetColumn('find_text')
		dw_mig.SetFocus()
		return
	end if	

	if ls_modify_type = 'MOD' then
		if isnull(dw_mig.GetItemString(i,'replace_text')) or &
			dw_mig.GetItemString(i,'replace_text') = "" then
			f_message_chk(1400,'[ '+string(i)+' 행 Replace Text]')
			dw_mig.ScrollToRow(i)
			dw_mig.SetColumn('replace_text')
			dw_mig.SetFocus()
			return
		end if	
	end if	

NEXT

// 1. 일련번호(PK) 채번
FOR i = 1 TO dw_mig.RowCount()

	if isnull(dw_mig.GetItemNumber(i,'seq_no')) then
		SELECT SYS_MIG_SEQ.NEXTVAL INTO :ll_seq FROM DUAL;
		dw_mig.SetItem(i, 'seq_no', ll_seq)
	end if	

NEXT


if f_msg_update() = -1 then return
	
if dw_mig.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		

end event

type cb_exit from w_inherite`cb_exit within w_sys_mig
integer x = 2528
integer y = 2452
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_sys_mig
integer x = 640
integer y = 2364
integer width = 411
integer taborder = 60
integer textsize = -9
string text = "일괄처리(&S)"
end type

type cb_ins from w_inherite`cb_ins within w_sys_mig
integer x = 2917
integer y = 2468
integer width = 411
integer taborder = 70
integer textsize = -9
boolean enabled = false
string text = "전체복사(&I)"
end type

type cb_del from w_inherite`cb_del within w_sys_mig
integer x = 2107
integer y = 2444
integer taborder = 80
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_sys_mig
integer x = 1467
integer y = 2796
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_sys_mig
integer x = 1943
integer y = 2796
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sys_mig
end type

type cb_can from w_inherite`cb_can within w_sys_mig
integer x = 2418
integer y = 2796
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_sys_mig
integer x = 2894
integer y = 2796
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_sys_mig
end type

type gb_button2 from w_inherite`gb_button2 within w_sys_mig
end type

type st_2 from statictext within w_sys_mig
integer x = 96
integer y = 40
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

type sle_user from singlelineedit within w_sys_mig
integer x = 389
integer y = 32
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
string text = "ADMIN"
boolean autohscroll = false
textcase textcase = upper!
end type

event rbuttondown;OPEN( w_sys_user_id_popup )
sle_user.text = gs_code

sle_user.triggerevent(modified!)
end event

event modified;p_inq.TriggerEvent(Clicked!)
end event

type gb_1 from groupbox within w_sys_mig
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

type cb_refresh from commandbutton within w_sys_mig
boolean visible = false
integer x = 1586
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

//dw_1.setredraw(false)
//dw_1.reset()
//dw_1.insertrow(0)
//dw_1.setredraw(true)


end event

type dw_insert_all from datawindow within w_sys_mig
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

type dw_user_all from datawindow within w_sys_mig
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

type dw_user from u_key_enter within w_sys_mig
event ue_mousemove pbm_mousemove
event ue_bdown pbm_lbuttondown
event ue_bup pbm_lbuttonup
event ue_keydown pbm_dwnkey
integer x = 46
integer y = 216
integer width = 1627
integer height = 2064
integer taborder = 40
string dragicon = "WinLogo!"
string dataobject = "d_sys_mig1"
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;This.SelectRow(0,false)
This.SelectRow(currentrow, True)
end event

event clicked;call super::clicked;If dwo.name = 'b_1' Then
	//MessageBox('a','b')
	
	dw_mig.width += dw_mig.x - this.x
	dw_mig.x = this.x
	this.Visible = False

End If

//If row <=0 Then Return
//
//Long		ll_row
//String		ls_window_id, ls_pbl_name
//
//ls_window_id = GetItemString(row,'window_name')
//st_5.Text = ls_window_id
//
//ll_row = dw_pbl.Find("obj_name = '" + ls_window_id + "'", 1, dw_pbl.RowCount())
//If ll_row > 0 Then
//	ls_pbl_name = dw_pbl.GetItemString(ll_row, "pbl_name")
//	mle_source.Text = LibraryExport(ls_pbl_name, ls_window_id, ExportWindow!)
//End If
//
////ls_dwsyn = LibraryExport(as_pbl_name, as_obj_name, ExportDataWindow!)
end event

event doubleclicked;call super::doubleclicked;If row <= 0 Then Return

If GetItemNumber(row,'sub2_id') <> 99 and  GetItemNumber(row,'sub2_id') <> 100 Then Return 

If GetItemString(row,'sub') = '0' Then
	SetItem(row,'sub','1')
Else
	SetItem(row,'sub','0')
End If

Post wf_filter(this,row,True)
end event

type p_1 from picture within w_sys_mig
integer x = 302
integer y = 36
integer width = 59
integer height = 56
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\pop_2.jpg"
boolean focusrectangle = false
end type

type cb_migrate from commandbutton within w_sys_mig
integer x = 2542
integer y = 24
integer width = 402
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Migrate"
end type

event clicked;//Long		ll_row
//String		ls_window_id, ls_pbl_name
//
//ls_window_id = st_5.Text
//ll_row = dw_pbl.Find("obj_name = '" + ls_window_id + "'", 1, dw_pbl.RowCount())
//If ll_row > 0 Then
//	ls_pbl_name = dw_pbl.GetItemString(ll_row, "pbl_name")
//	xf_test(ls_pbl_name, ls_window_id)
//End If
//
end event

type cb_scan from commandbutton within w_sys_mig
integer x = 3241
integer y = 52
integer width = 242
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "Filter"
end type

event clicked;String		sNull

SetNull(sNull)
dw_insert.SetFilter(sNull)
dw_insert.Filter()

end event

type dw_pbl from u_key_enter within w_sys_mig
integer x = 539
integer y = 1268
integer width = 1486
integer height = 972
integer taborder = 50
string dragicon = "WinLogo!"
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_sys_mig2"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
end type

type cb_test from commandbutton within w_sys_mig
integer x = 2071
integer y = 24
integer width = 439
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "test"
end type

event clicked;messagebox('GetLibraryList()', GetLibraryList())
end event

type cb_library_export from commandbutton within w_sys_mig
integer x = 1504
integer width = 457
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "LibraryExport"
end type

event clicked;string ls_LibName, ls_wLibName, ls_Objectname, ls_syntax, ls_filename
long 	session
int 	li_rc, li_fileNum


session = PBORCA_SessionOpen()

ls_LibName = "C:\\erpman\\hantec_erp\\conversion_old.pbl"
ls_wLibName = f_replace_all(ls_LibName, "\", "\\")

ls_Objectname = "w_mat_01350"
//ls_syntax = Space(60000)
li_rc = PBORCA_LibraryEntryExport(session, ls_LibName, ls_Objectname, PBORCA_WINDOW, ls_syntax, 120000)
messagebox('PBORCA_LibraryEntryExport', li_rc)

if li_rc = 0 then
	ls_filename = "C:\\erpman\\hantec_erp\\mig\\win\\" + ls_Objectname + ".srw"
	
	li_fileNum = FileOpen(ls_filename, StreamMode!, Write!)
	IF li_fileNum <= 0 THEN
		 messagebox("오류", "파일을 쓰기 위해 열 수 없습니다.")
		 return
	END IF
	
	FileWrite(li_fileNum, ls_syntax)
	FileClose(li_fileNum)
end if

PBORCA_SessionClose(session)

end event

type dw_mig from u_key_enter within w_sys_mig
integer x = 1710
integer y = 200
integer width = 2889
integer height = 2080
integer taborder = 60
string dragicon = "WinLogo!"
boolean bringtotop = true
string dataobject = "d_sys_mig3"
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event ue_pressenter;//Send(Handle(this),256,9,0)
//Return 1
end event

type cb_pbl_copy from commandbutton within w_sys_mig
integer x = 960
integer width = 320
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "PBL Copy"
end type

event clicked;
wf_list_pbl()									// 1. PBL 리스트 (메뉴기준)

if wf_copy_pbl() = -1 then return		// 2. PBL 복사

if wf_export_win() = -1 then return	// 3. Window 소스 저장
end event

type hpb_sts from hprogressbar within w_sys_mig
integer x = 946
integer y = 124
integer width = 800
integer height = 20
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type st_sts from statictext within w_sys_mig
integer x = 1774
integer y = 108
integer width = 800
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 134217750
string text = "none"
boolean focusrectangle = false
end type

type rr_2 from roundrectangle within w_sys_mig
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 192
integer width = 4581
integer height = 2104
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sys_mig
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33554431
integer x = 32
integer y = 8
integer width = 823
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

