$PBExportHeader$w_wflow_excel_import.srw
$PBExportComments$엑셀 자료 변환
forward
global type w_wflow_excel_import from w_inherite_popup
end type
type dw_gateway from datawindow within w_wflow_excel_import
end type
type dw_gateway_branch from datawindow within w_wflow_excel_import
end type
type dw_activity from datawindow within w_wflow_excel_import
end type
type dw_activity_branch from datawindow within w_wflow_excel_import
end type
type dw_activity_sub from datawindow within w_wflow_excel_import
end type
type dw_activity_sub_branch from datawindow within w_wflow_excel_import
end type
type st_status from statictext within w_wflow_excel_import
end type
type rr_1 from roundrectangle within w_wflow_excel_import
end type
end forward

global type w_wflow_excel_import from w_inherite_popup
integer width = 2743
integer height = 1880
string title = "엑셀 변환"
dw_gateway dw_gateway
dw_gateway_branch dw_gateway_branch
dw_activity dw_activity
dw_activity_branch dw_activity_branch
dw_activity_sub dw_activity_sub
dw_activity_sub_branch dw_activity_sub_branch
st_status st_status
rr_1 rr_1
end type
global w_wflow_excel_import w_wflow_excel_import

type variables
string is_proj_code
integer ii_proj_seq

end variables

forward prototypes
public function integer wf_display_error (long al_line, string as_column, string as_error)
public function integer wf_excel_ole_import (oleobject aole_sheet)
public function integer wf_excel_dde_import (long al_handle, long al_start_row, long al_end_row)
public function integer wf_get_excel_filename (ref string as_path)
end prototypes

public function integer wf_display_error (long al_line, string as_column, string as_error);long ll_new_row

ll_new_row = dw_1.insertrow(0)
dw_1.setitem(ll_new_row, 'line_num', al_line)
dw_1.setitem(ll_new_row, 'column_name', as_column)
dw_1.setitem(ll_new_row, 'error_desc', as_error)

return 1

end function

public function integer wf_excel_ole_import (oleobject aole_sheet);//----------------------------------------------------------//
//       excel 자료를 읽어서 변환한다.                      //
//----------------------------------------------------------//
// 자료가 일부만 변환되고 종료된 경우에는 중간에 1 라인이 비어있는 경우
//            END OF DATA 로 간주하여 종료한 경우가 대부분.
//
// ---------- COLUMN 설명 ---------------------------
//  1(A) --> GATEWAY 순번   빈칸 : 1 line 전체가 빈칸이면 END OF DATA 이다.
//  2(B) --> GATEWAY 명칭
//  3(C) --> ACTIVITY 순번
//  4(D) --> ACTIVITY 명칭
//  5(E) --> SUB ACTIVITY 순번
//  6(F) --> SUB ACTIVITY 명칭
//  7(G) --> 시작예정일
//  8(H) --> 완료예정일
//  9(I) --> 주관부서(코드)
// 10(J) --> 협조부서(명칭)

constant int POSITION_X = 50
constant int POSITION_W = 800
constant int POSITION_Y = 472

string  ls_gateway_name, ls_activity_name, ls_activity_sub_name
integer li_gateway_disp, li_activity_disp, li_activity_sub_disp
integer li_gateway_pre_disp, li_activity_pre_disp, li_activity_sub_pre_disp
integer li_gateway_seq, li_activity_seq, li_activity_sub_seq
date    ld_from, ld_to, ld_parent
string  ls_deptcode, ls_deptname
string  ls_co_deptcode, ls_co_deptname

datetime ldt_now

long    ll_row, ll_start_row, ll_end_row
long    ll_find, ll_new_row
long    ll_gateway_new_row, ll_activity_new_row, ll_activity_sub_new_row


//string ls_test
//messagebox('B2,1', string(left(aole_Sheet.Cells[2,  2].Value, 100)))
//messagebox('B2,2', string(aole_Sheet.Range("B2").Value))
//ls_test = aole_Sheet.Cells[2,  2].Value
//messagebox('B2,3', ls_test)
//ls_test = aole_Sheet.Range("B2").Value
//messagebox('B2,4', ls_test)



// conversion 시작

ldt_now = datetime(today(), now())

dw_1.Reset()
dw_activity.Reset()

li_gateway_seq = 0
li_activity_seq = 0
li_activity_sub_seq = 0

li_gateway_pre_disp = 0
li_activity_pre_disp = 0
li_activity_sub_pre_disp = 0

ll_start_row = aole_Sheet.UsedRange.Rows(1).Row + 1
ll_end_row = aole_Sheet.UsedRange.Rows(aole_Sheet.UsedRange.Rows.Count).Row
for ll_row = ll_start_row to ll_end_row
	st_status.text = string(ll_row) + '번째 라인 처리중입니다'   // excel line 번호 보여주기

	li_gateway_disp      = dec   (aole_Sheet.Cells[ll_row,  1].Value)
	ls_gateway_name      = string(aole_Sheet.Cells[ll_row,  2].Value)
	li_activity_disp     = dec   (aole_Sheet.Cells[ll_row,  3].Value)
	ls_activity_name     = string(aole_Sheet.Cells[ll_row,  4].Value)
	li_activity_sub_disp = dec   (aole_Sheet.Cells[ll_row,  5].Value)
	ls_activity_sub_name = string(aole_Sheet.Cells[ll_row,  6].Value)
	ld_from              = date  (aole_Sheet.Cells[ll_row,  7].Value)
	ld_to                = date  (aole_Sheet.Cells[ll_row,  8].Value)
	ls_deptcode          = string(aole_Sheet.Cells[ll_row,  9].Value)
	//ls_co_deptcode       = string(aole_Sheet.Cells[ll_row, 10].Value)
	ls_co_deptname       = string(aole_Sheet.Cells[ll_row, 10].Value)

//	if isnull(li_gateway_disp) and isnull(li_activity_disp) and isnull(li_activity_sub_disp) and &
//		isnull(ls_gateway_name) and isnull(ls_activity_name) and isnull(ls_activity_sub_name) then
//		// 빈칸이므로 종료한다.
//		exit
//	end if

	if isnull(li_gateway_disp) then
		wf_display_error(ll_row, 'GATEWAY 순번', '잘못된 값입니다')
		continue
	end if
	if li_gateway_disp <= 0 then
		wf_display_error(ll_row, 'GATEWAY 순번', '잘못된 값입니다')
		continue
	end if

//	if isnull(li_activity_disp) then li_activity_disp = 0
//	if isnull(li_activity_sub_disp) then li_activity_sub_disp = 0

	if li_activity_disp <= 0 then
		wf_display_error(ll_row, 'ACTIVITY 순번', '잘못된 값입니다')
	end if
	if li_activity_sub_disp <= 0 then
		wf_display_error(ll_row, 'SUB ACTIVITY 순번', '잘못된 값입니다')
	end if

	ls_gateway_name  = trim(ls_gateway_name)
	ls_activity_name = trim(ls_activity_name)
	ls_activity_sub_name  = trim(ls_activity_sub_name)

	if len(ls_gateway_name) > 50 then ls_gateway_name = left(ls_gateway_name, 50)
	if len(ls_activity_name) > 50 then ls_activity_name = left(ls_activity_name, 50)
	if len(ls_activity_sub_name) > 50 then ls_activity_sub_name = left(ls_activity_sub_name,  50)

	// 주관부서 검색
	if ls_deptcode = '' or isnull(ls_deptcode) then
		setnull(ls_deptname)
	else
		  select deptname  
		    into :ls_deptname
		    from p0_dept  
		   where companycode = :gs_company
		     and deptcode = :ls_deptcode; 

		if ls_deptname = '' or isnull(ls_deptname) then
			wf_display_error(ll_row, '주관부서', '등록된 부서코드가 없습니다')
			setnull(ls_deptcode)
			setnull(ls_deptname)
		end if
	end if

	if li_gateway_pre_disp <> li_gateway_disp then
		ll_find = dw_gateway.find('display_seq = ' + string(li_gateway_disp), 1, dw_gateway.rowcount())
		if ll_find > 0 then       // 이미등록 되었을때...
			wf_display_error(ll_row, 'GATEWAY 순번', '이미 등록된 값입니다')
		end if

		li_gateway_seq++
		li_activity_seq = 0
		li_activity_sub_seq = 0

		ll_new_row = dw_gateway.insertrow(0)
		ll_gateway_new_row = ll_new_row
		dw_gateway.setitem(ll_new_row, 'proj_code',    is_proj_code)
		dw_gateway.setitem(ll_new_row, 'proj_seq',     ii_proj_seq)
		dw_gateway.setitem(ll_new_row, 'gateway_seq',  li_gateway_seq)
		dw_gateway.setitem(ll_new_row, 'display_seq',  li_gateway_disp)
		dw_gateway.setitem(ll_new_row, 'gateway_name', ls_gateway_name)
		dw_gateway.setitem(ll_new_row, 'object_x',     POSITION_X + POSITION_W * (li_gateway_seq - 1))
		dw_gateway.setitem(ll_new_row, 'object_y',     POSITION_Y)
		dw_gateway.setitem(ll_new_row, 'visible',      'Y')
		if isnull(li_activity_disp) and isnull(li_activity_sub_disp) then
			dw_gateway.setitem(ll_new_row, 'f_date',       ld_from)
			dw_gateway.setitem(ll_new_row, 't_date',       ld_to)
		end if
		dw_gateway.setItem(ll_new_row, 'write_empno',  gs_empno)
		dw_gateway.setItem(ll_new_row, 'write_time',   ldt_now)
	end if

	if isnull(li_activity_disp) = false and (li_gateway_pre_disp <> li_gateway_disp or li_activity_pre_disp <> li_activity_disp) then
		ll_find = dw_activity.find('gateway_seq = ' + string(li_gateway_seq) + ' and ' + 'display_seq = ' + string(li_activity_disp), 1, dw_activity.rowcount())
		if ll_find > 0 then       // 이미등록 되었을때...
			wf_display_error(ll_row, 'ACTIVITY 순번', '이미 등록된 값입니다')
		end if

		li_activity_seq++
		li_activity_sub_seq = 0

		ll_new_row = dw_activity.insertrow(0)
		ll_activity_new_row = ll_new_row
		dw_activity.setitem(ll_new_row, 'proj_code',    is_proj_code)
		dw_activity.setitem(ll_new_row, 'proj_seq',     ii_proj_seq)
		dw_activity.setitem(ll_new_row, 'gateway_seq',  li_gateway_seq)
		dw_activity.setitem(ll_new_row, 'activity_seq', li_activity_seq)
		dw_activity.setitem(ll_new_row, 'display_seq',  li_activity_disp)
		dw_activity.setitem(ll_new_row, 'activity_name', ls_activity_name)
		dw_activity.setitem(ll_new_row, 'object_x',     POSITION_X + POSITION_W * (li_activity_seq - 1))
		dw_activity.setitem(ll_new_row, 'object_y',     POSITION_Y)
		dw_activity.setitem(ll_new_row, 'visible',      'Y')
		if isnull(li_activity_sub_disp) then
			dw_activity.setitem(ll_new_row, 'f_date',       ld_from)
			dw_activity.setitem(ll_new_row, 't_date',       ld_to)
			dw_activity.setItem(ll_new_row, 'deptcode',     ls_deptcode)
			dw_activity.setItem(ll_new_row, 'deptname',     ls_deptname)
			//dw_activity.setItem(ll_new_row, 'co_deptcode',  ls_co_deptcode)
			dw_activity.setItem(ll_new_row, 'co_deptname',  ls_co_deptname)

			// 예정일자를 상위에 기록
			if not isnull(ld_from) then
				ld_parent = date(dw_gateway.getitemdatetime(ll_gateway_new_row, 'f_date'))
				if isnull(ld_parent) or ld_from < ld_parent then
					dw_gateway.setitem(ll_gateway_new_row, 'f_date',       ld_from)
				end if
			end if
			if not isnull(ld_to) then
				ld_parent = date(dw_gateway.getitemdatetime(ll_gateway_new_row, 't_date'))
				if isnull(ld_parent) or ld_to > ld_parent then
					dw_gateway.setitem(ll_gateway_new_row, 't_date',       ld_to)
				end if
			end if
		end if
		dw_activity.setItem(ll_new_row, 'write_empno',  gs_empno)
		dw_activity.setItem(ll_new_row, 'write_time',   ldt_now)
	end if

	if isnull(li_activity_disp) = false and isnull(li_activity_sub_disp) = false and (li_gateway_pre_disp <> li_gateway_disp or li_activity_pre_disp <> li_activity_disp or li_activity_sub_pre_disp <> li_activity_sub_disp) then
		ll_find = dw_activity_sub.find('gateway_seq = ' + string(li_gateway_seq) + ' and ' + 'activity_seq = ' + string(li_activity_seq) + ' and ' + 'display_seq = ' + string(li_activity_sub_disp), 1, dw_activity_sub.rowcount())
		if ll_find > 0 then       // 이미등록 되었을때...
			wf_display_error(ll_row, 'SUB ACTIVITY 순번', '이미 등록된 값입니다')
		end if

		li_activity_sub_seq++

		ll_new_row = dw_activity_sub.insertrow(0)
		ll_activity_sub_new_row = ll_new_row // 사용하지 않지만..
		dw_activity_sub.setitem(ll_new_row, 'proj_code',    is_proj_code)
		dw_activity_sub.setitem(ll_new_row, 'proj_seq',     ii_proj_seq)
		dw_activity_sub.setitem(ll_new_row, 'gateway_seq',  li_gateway_seq)
		dw_activity_sub.setitem(ll_new_row, 'activity_seq', li_activity_seq)
		dw_activity_sub.setitem(ll_new_row, 'activity_sub_seq', li_activity_sub_seq)
		dw_activity_sub.setitem(ll_new_row, 'display_seq',  li_activity_sub_disp)
		dw_activity_sub.setitem(ll_new_row, 'activity_name', ls_activity_sub_name)
		dw_activity_sub.setitem(ll_new_row, 'object_x',     POSITION_X + POSITION_W * (li_activity_sub_seq - 1))
		dw_activity_sub.setitem(ll_new_row, 'object_y',     POSITION_Y)
		dw_activity_sub.setitem(ll_new_row, 'visible',      'Y')
		dw_activity_sub.setitem(ll_new_row, 'f_date',       ld_from)
		dw_activity_sub.setitem(ll_new_row, 't_date',       ld_to)
		dw_activity_sub.setItem(ll_new_row, 'deptcode',     ls_deptcode)
		dw_activity_sub.setItem(ll_new_row, 'deptname',     ls_deptname)
		//dw_activity_sub.setItem(ll_new_row, 'co_deptcode',  ls_co_deptcode)
		dw_activity_sub.setItem(ll_new_row, 'co_deptname',  ls_co_deptname)

		// 예정일자를 상위에 기록
		if not isnull(ld_from) then
			ld_parent = date(dw_activity.getitemdatetime(ll_activity_new_row, 'f_date'))
			if isnull(ld_parent) or ld_from < ld_parent then
				dw_activity.setitem(ll_activity_new_row, 'f_date',       ld_from)

				ld_parent = date(dw_gateway.getitemdatetime(ll_gateway_new_row, 'f_date'))
				if isnull(ld_parent) or ld_from < ld_parent then
					dw_gateway.setitem(ll_gateway_new_row, 'f_date',       ld_from)
				end if
			end if
		end if
		if not isnull(ld_to) then
			ld_parent = date(dw_activity.getitemdatetime(ll_activity_new_row, 't_date'))
			if isnull(ld_parent) or ld_to > ld_parent then
				dw_activity.setitem(ll_activity_new_row, 't_date',       ld_to)

				ld_parent = date(dw_gateway.getitemdatetime(ll_gateway_new_row, 't_date'))
				if isnull(ld_parent) or ld_to > ld_parent then
					dw_gateway.setitem(ll_gateway_new_row, 't_date',       ld_to)
				end if
			end if
		end if

		dw_activity_sub.setItem(ll_new_row, 'write_empno',  gs_empno)
		dw_activity_sub.setItem(ll_new_row, 'write_time',   ldt_now)
	end if

	li_gateway_pre_disp = li_gateway_disp
	li_activity_pre_disp = li_activity_disp
	li_activity_sub_pre_disp = li_activity_sub_disp
next

// 오류 발생
if dw_1.rowcount() > 0 then
	return -1
end if

return 1

end function

public function integer wf_excel_dde_import (long al_handle, long al_start_row, long al_end_row);//----------------------------------------------------------//
//       excel 자료를 읽어서 변환한다.                      //
//----------------------------------------------------------//
// 자료가 일부만 변환되고 종료된 경우에는 중간에 1 라인이 비어있는 경우
//            END OF DATA 로 간주하여 종료한 경우가 대부분.
//
// ---------- COLUMN 설명 ---------------------------
//  1(A) --> GATEWAY 순번   빈칸 : 1 line 전체가 빈칸이면 END OF DATA 이다.
//  2(B) --> GATEWAY 명칭
//  3(C) --> ACTIVITY 순번
//  4(D) --> ACTIVITY 명칭
//  5(E) --> SUB ACTIVITY 순번
//  6(F) --> SUB ACTIVITY 명칭
//  7(G) --> 시작예정일
//  8(H) --> 완료예정일
//  9(I) --> 주관부서(코드)
// 10(J) --> 협조부서(명칭)

constant int POSITION_X = 50
constant int POSITION_W = 800
constant int POSITION_Y = 472
constant int POSITION_H = 700
constant int POSITION_MAX_X = 8600
long ll_gateway_x, ll_gateway_y
long ll_activity_x, ll_activity_y
long ll_activity_sub_x, ll_activity_sub_y

string  ls_gateway_name, ls_activity_name, ls_activity_sub_name
integer li_gateway_disp, li_activity_disp, li_activity_sub_disp
integer li_gateway_pre_disp, li_activity_pre_disp, li_activity_sub_pre_disp
integer li_gateway_seq, li_activity_seq, li_activity_sub_seq
date    ld_from, ld_to, ld_parent
string  ls_deptcode, ls_deptname
string  ls_co_deptcode, ls_co_deptname

datetime ldt_now

long    ll_row
long    ll_find, ll_new_row
long    ll_gateway_new_row, ll_activity_new_row, ll_activity_sub_new_row

integer li_rc
string  ls_str1, ls_str2, ls_str3, ls_str4, ls_str5, ls_str6, ls_str7, ls_str8, ls_str9, ls_str10
string  ls_data1, ls_data2, ls_data3, ls_data4, ls_data5, ls_data6, ls_data7, ls_data8, ls_data9, ls_data10

//// test..test..test
//string ls_test
//li_rc = GetRemote('r6c10',  ls_test, al_handle)
//messagebox('B2,3', ls_test)
//li_rc = GetRemote('J6',  ls_test, al_handle)
//ls_test = trim(left(ls_test, len(ls_test) - 2))
//messagebox('B2,4', ls_test)
//
//return 0


// conversion 시작

ldt_now = datetime(today(), now())

dw_1.Reset()
dw_activity.Reset()

li_gateway_seq = 0
li_activity_seq = 0
li_activity_sub_seq = 0

li_gateway_pre_disp = 0
li_activity_pre_disp = 0
li_activity_sub_pre_disp = 0

ll_gateway_x = POSITION_X
ll_gateway_y = POSITION_Y
ll_activity_x = POSITION_X
ll_activity_y = POSITION_Y
ll_activity_sub_x = POSITION_X
ll_activity_sub_y = POSITION_Y

for ll_row = al_start_row to al_end_row
	st_status.text = string(ll_row) + '번째 라인 처리중입니다'   // excel line 번호 보여주기

	li_rc = GetRemote('r' + string(ll_row) + 'c1',  ls_str1, al_handle)
	li_rc = GetRemote('r' + string(ll_row) + 'c2',  ls_str2, al_handle)
	li_rc = GetRemote('r' + string(ll_row) + 'c3',  ls_str3, al_handle)
	li_rc = GetRemote('r' + string(ll_row) + 'c4',  ls_str4, al_handle)
	li_rc = GetRemote('r' + string(ll_row) + 'c5',  ls_str5, al_handle)
	li_rc = GetRemote('r' + string(ll_row) + 'c6',  ls_str6, al_handle)
	li_rc = GetRemote('r' + string(ll_row) + 'c7',  ls_str7, al_handle)
	li_rc = GetRemote('r' + string(ll_row) + 'c8',  ls_str8, al_handle)
	li_rc = GetRemote('r' + string(ll_row) + 'c9',  ls_str9, al_handle)
	li_rc = GetRemote('r' + string(ll_row) + 'c10', ls_str10,al_handle)
	ls_data1  = trim(left(ls_str1,  len(ls_str1) - 2))
	ls_data2  = trim(left(ls_str2,  len(ls_str2) - 2))
	ls_data3  = trim(left(ls_str3,  len(ls_str3) - 2))
	ls_data4  = trim(left(ls_str4,  len(ls_str4) - 2))
	ls_data5  = trim(left(ls_str5,  len(ls_str5) - 2))
	ls_data6  = trim(left(ls_str6,  len(ls_str6) - 2))
	ls_data7  = trim(left(ls_str7,  len(ls_str7) - 2))
	ls_data8  = trim(left(ls_str8,  len(ls_str8) - 2))
	ls_data9  = trim(left(ls_str9,  len(ls_str9) - 2))
	ls_data10 = trim(left(ls_str10, len(ls_str10) - 2))
	if ls_data1 = '' then setnull(ls_data1)
	if ls_data2 = '' then setnull(ls_data2)
	if ls_data3 = '' then setnull(ls_data3)
	if ls_data4 = '' then setnull(ls_data4)
	if ls_data5 = '' then setnull(ls_data5)
	if ls_data6 = '' then setnull(ls_data6)
	if ls_data7 = '' then setnull(ls_data7)
	if ls_data8 = '' then setnull(ls_data8)
	if ls_data9 = '' then setnull(ls_data9)
	if ls_data10 = '' then setnull(ls_data10)

	li_gateway_disp      = dec   (ls_data1)
	ls_gateway_name      = string(ls_data2)
	li_activity_disp     = dec   (ls_data3)
	ls_activity_name     = string(ls_data4)
	li_activity_sub_disp = dec   (ls_data5)
	ls_activity_sub_name = string(ls_data6)
	ld_from              = date  (ls_data7)
	ld_to                = date  (ls_data8)
	ls_deptcode          = string(ls_data9)
	//ls_co_deptcode       = string(ls_data10)
	ls_co_deptname       = string(ls_data10)

//	if isnull(li_gateway_disp) and isnull(li_activity_disp) and isnull(li_activity_sub_disp) and &
//		isnull(ls_gateway_name) and isnull(ls_activity_name) and isnull(ls_activity_sub_name) then
//		// 빈칸이므로 종료한다.
//		exit
//	end if

	if isnull(li_gateway_disp) then
		wf_display_error(ll_row, 'GATEWAY 순번', '잘못된 값입니다')
		continue
	end if
	if li_gateway_disp <= 0 then
		wf_display_error(ll_row, 'GATEWAY 순번', '잘못된 값입니다')
		continue
	end if

//	if isnull(li_activity_disp) then li_activity_disp = 0
//	if isnull(li_activity_sub_disp) then li_activity_sub_disp = 0

	if li_activity_disp <= 0 then
		wf_display_error(ll_row, 'ACTIVITY 순번', '잘못된 값입니다')
	end if
	if li_activity_sub_disp <= 0 then
		wf_display_error(ll_row, 'SUB ACTIVITY 순번', '잘못된 값입니다')
	end if

	ls_gateway_name  = trim(ls_gateway_name)
	ls_activity_name = trim(ls_activity_name)
	ls_activity_sub_name  = trim(ls_activity_sub_name)

	if len(ls_gateway_name) > 50 then ls_gateway_name = left(ls_gateway_name, 50)
	if len(ls_activity_name) > 50 then ls_activity_name = left(ls_activity_name, 50)
	if len(ls_activity_sub_name) > 50 then ls_activity_sub_name = left(ls_activity_sub_name,  50)

	// 주관부서 검색
	if ls_deptcode = '' or isnull(ls_deptcode) then
		setnull(ls_deptname)
	else
		  select deptname  
		    into :ls_deptname
		    from p0_dept  
		   where companycode = :gs_company
		     and deptcode = :ls_deptcode; 

		if ls_deptname = '' or isnull(ls_deptname) then
			wf_display_error(ll_row, '주관부서', '등록된 부서코드가 없습니다')
			setnull(ls_deptcode)
			setnull(ls_deptname)
		end if
	end if

	if li_gateway_pre_disp <> li_gateway_disp then
		ll_find = dw_gateway.find('display_seq = ' + string(li_gateway_disp), 1, dw_gateway.rowcount())
		if ll_find > 0 then       // 이미등록 되었을때...
			wf_display_error(ll_row, 'GATEWAY 순번', '이미 등록된 값입니다')
		end if

		li_gateway_seq++
		li_activity_seq = 0
		li_activity_sub_seq = 0

		ll_new_row = dw_gateway.insertrow(0)
		ll_gateway_new_row = ll_new_row
		dw_gateway.setitem(ll_new_row, 'proj_code',    is_proj_code)
		dw_gateway.setitem(ll_new_row, 'proj_seq',     ii_proj_seq)
		dw_gateway.setitem(ll_new_row, 'gateway_seq',  li_gateway_seq)
		dw_gateway.setitem(ll_new_row, 'display_seq',  li_gateway_disp)
		dw_gateway.setitem(ll_new_row, 'gateway_name', ls_gateway_name)
		dw_gateway.setitem(ll_new_row, 'object_x',     ll_gateway_x) // POSITION_X + POSITION_W * (li_gateway_seq - 1))
		dw_gateway.setitem(ll_new_row, 'object_y',     ll_gateway_y) // POSITION_Y)
		dw_gateway.setitem(ll_new_row, 'visible',      'Y')
		if isnull(li_activity_disp) and isnull(li_activity_sub_disp) then
			dw_gateway.setitem(ll_new_row, 'f_date',       ld_from)
			dw_gateway.setitem(ll_new_row, 't_date',       ld_to)
		end if
		dw_gateway.setItem(ll_new_row, 'write_empno',  gs_empno)
		dw_gateway.setItem(ll_new_row, 'write_time',   ldt_now)
		
		if ll_gateway_x + POSITION_W < POSITION_MAX_X then
			ll_gateway_x += POSITION_W
		else
			ll_gateway_y += POSITION_H
		end if
		ll_activity_x = POSITION_X
		ll_activity_y = POSITION_Y
		ll_activity_sub_x = POSITION_X
		ll_activity_sub_y = POSITION_Y
	end if

	if isnull(li_activity_disp) = false and (li_gateway_pre_disp <> li_gateway_disp or li_activity_pre_disp <> li_activity_disp) then
		ll_find = dw_activity.find('gateway_seq = ' + string(li_gateway_seq) + ' and ' + 'display_seq = ' + string(li_activity_disp), 1, dw_activity.rowcount())
		if ll_find > 0 then       // 이미등록 되었을때...
			wf_display_error(ll_row, 'ACTIVITY 순번', '이미 등록된 값입니다')
		end if

		li_activity_seq++
		li_activity_sub_seq = 0

		ll_new_row = dw_activity.insertrow(0)
		ll_activity_new_row = ll_new_row
		dw_activity.setitem(ll_new_row, 'proj_code',    is_proj_code)
		dw_activity.setitem(ll_new_row, 'proj_seq',     ii_proj_seq)
		dw_activity.setitem(ll_new_row, 'gateway_seq',  li_gateway_seq)
		dw_activity.setitem(ll_new_row, 'activity_seq', li_activity_seq)
		dw_activity.setitem(ll_new_row, 'display_seq',  li_activity_disp)
		dw_activity.setitem(ll_new_row, 'activity_name', ls_activity_name)
		dw_activity.setitem(ll_new_row, 'object_x',     ll_activity_x) // POSITION_X + POSITION_W * (li_activity_seq - 1))
		dw_activity.setitem(ll_new_row, 'object_y',     ll_activity_y) // POSITION_Y)
		dw_activity.setitem(ll_new_row, 'visible',      'Y')
		if isnull(li_activity_sub_disp) then
			dw_activity.setitem(ll_new_row, 'f_date',       ld_from)
			dw_activity.setitem(ll_new_row, 't_date',       ld_to)
			dw_activity.setItem(ll_new_row, 'deptcode',     ls_deptcode)
			dw_activity.setItem(ll_new_row, 'deptname',     ls_deptname)
			//dw_activity.setItem(ll_new_row, 'co_deptcode',  ls_co_deptcode)
			dw_activity.setItem(ll_new_row, 'co_deptname',  ls_co_deptname)

			// 예정일자를 상위에 기록
			if not isnull(ld_from) then
				ld_parent = date(dw_gateway.getitemdatetime(ll_gateway_new_row, 'f_date'))
				if isnull(ld_parent) or ld_from < ld_parent then
					dw_gateway.setitem(ll_gateway_new_row, 'f_date',       ld_from)
				end if
			end if
			if not isnull(ld_to) then
				ld_parent = date(dw_gateway.getitemdatetime(ll_gateway_new_row, 't_date'))
				if isnull(ld_parent) or ld_to > ld_parent then
					dw_gateway.setitem(ll_gateway_new_row, 't_date',       ld_to)
				end if
			end if
		end if
		dw_activity.setItem(ll_new_row, 'write_empno',  gs_empno)
		dw_activity.setItem(ll_new_row, 'write_time',   ldt_now)

		if ll_activity_x + POSITION_W < POSITION_MAX_X then
			ll_activity_x += POSITION_W
		else
			ll_activity_y += POSITION_H
		end if
		ll_activity_sub_x = POSITION_X
		ll_activity_sub_y = POSITION_Y
	end if

	if isnull(li_activity_disp) = false and isnull(li_activity_sub_disp) = false and (li_gateway_pre_disp <> li_gateway_disp or li_activity_pre_disp <> li_activity_disp or li_activity_sub_pre_disp <> li_activity_sub_disp) then
		ll_find = dw_activity_sub.find('gateway_seq = ' + string(li_gateway_seq) + ' and ' + 'activity_seq = ' + string(li_activity_seq) + ' and ' + 'display_seq = ' + string(li_activity_sub_disp), 1, dw_activity_sub.rowcount())
		if ll_find > 0 then       // 이미등록 되었을때...
			wf_display_error(ll_row, 'SUB ACTIVITY 순번', '이미 등록된 값입니다')
		end if

		li_activity_sub_seq++

		ll_new_row = dw_activity_sub.insertrow(0)
		ll_activity_sub_new_row = ll_new_row // 사용하지 않지만..
		dw_activity_sub.setitem(ll_new_row, 'proj_code',    is_proj_code)
		dw_activity_sub.setitem(ll_new_row, 'proj_seq',     ii_proj_seq)
		dw_activity_sub.setitem(ll_new_row, 'gateway_seq',  li_gateway_seq)
		dw_activity_sub.setitem(ll_new_row, 'activity_seq', li_activity_seq)
		dw_activity_sub.setitem(ll_new_row, 'activity_sub_seq', li_activity_sub_seq)
		dw_activity_sub.setitem(ll_new_row, 'display_seq',  li_activity_sub_disp)
		dw_activity_sub.setitem(ll_new_row, 'activity_name', ls_activity_sub_name)
		dw_activity_sub.setitem(ll_new_row, 'object_x',     ll_activity_sub_x) // POSITION_X + POSITION_W * (li_activity_sub_seq - 1))
		dw_activity_sub.setitem(ll_new_row, 'object_y',     ll_activity_sub_y) // POSITION_Y)
		dw_activity_sub.setitem(ll_new_row, 'visible',      'Y')
		dw_activity_sub.setitem(ll_new_row, 'f_date',       ld_from)
		dw_activity_sub.setitem(ll_new_row, 't_date',       ld_to)
		dw_activity_sub.setItem(ll_new_row, 'deptcode',     ls_deptcode)
		dw_activity_sub.setItem(ll_new_row, 'deptname',     ls_deptname)
		//dw_activity_sub.setItem(ll_new_row, 'co_deptcode',  ls_co_deptcode)
		dw_activity_sub.setItem(ll_new_row, 'co_deptname',  ls_co_deptname)

		// 예정일자를 상위에 기록
		if not isnull(ld_from) then
			ld_parent = date(dw_activity.getitemdatetime(ll_activity_new_row, 'f_date'))
			if isnull(ld_parent) or ld_from < ld_parent then
				dw_activity.setitem(ll_activity_new_row, 'f_date',       ld_from)

				ld_parent = date(dw_gateway.getitemdatetime(ll_gateway_new_row, 'f_date'))
				if isnull(ld_parent) or ld_from < ld_parent then
					dw_gateway.setitem(ll_gateway_new_row, 'f_date',       ld_from)
				end if
			end if
		end if
		if not isnull(ld_to) then
			ld_parent = date(dw_activity.getitemdatetime(ll_activity_new_row, 't_date'))
			if isnull(ld_parent) or ld_to > ld_parent then
				dw_activity.setitem(ll_activity_new_row, 't_date',       ld_to)

				ld_parent = date(dw_gateway.getitemdatetime(ll_gateway_new_row, 't_date'))
				if isnull(ld_parent) or ld_to > ld_parent then
					dw_gateway.setitem(ll_gateway_new_row, 't_date',       ld_to)
				end if
			end if
		end if

		dw_activity_sub.setItem(ll_new_row, 'write_empno',  gs_empno)
		dw_activity_sub.setItem(ll_new_row, 'write_time',   ldt_now)

		if ll_activity_sub_x + POSITION_W < POSITION_MAX_X then
			ll_activity_sub_x += POSITION_W
		else
			ll_activity_sub_y += POSITION_H
		end if
	end if

	li_gateway_pre_disp = li_gateway_disp
	li_activity_pre_disp = li_activity_disp
	li_activity_sub_pre_disp = li_activity_sub_disp
next

// 오류 발생
if dw_1.rowcount() > 0 then
	return -1
end if

return 1

end function

public function integer wf_get_excel_filename (ref string as_path);string ls_path, ls_file

// Excel File Open
if GetFileOpenName('Select File', ls_path, ls_file, 'xls', 'Excel Files (*.xls),*.xls') <> 1 then
	return -1
end if

if RIGHT(UPPER(ls_file), 4) <> '.XLS' then
	messagebox("선택 오류", "선택한 파일이 엑셀 파일이 아닙니다.", StopSign!)
	return -1
end if

as_path = ls_path

return 1

end function

on w_wflow_excel_import.create
int iCurrent
call super::create
this.dw_gateway=create dw_gateway
this.dw_gateway_branch=create dw_gateway_branch
this.dw_activity=create dw_activity
this.dw_activity_branch=create dw_activity_branch
this.dw_activity_sub=create dw_activity_sub
this.dw_activity_sub_branch=create dw_activity_sub_branch
this.st_status=create st_status
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_gateway
this.Control[iCurrent+2]=this.dw_gateway_branch
this.Control[iCurrent+3]=this.dw_activity
this.Control[iCurrent+4]=this.dw_activity_branch
this.Control[iCurrent+5]=this.dw_activity_sub
this.Control[iCurrent+6]=this.dw_activity_sub_branch
this.Control[iCurrent+7]=this.st_status
this.Control[iCurrent+8]=this.rr_1
end on

on w_wflow_excel_import.destroy
call super::destroy
destroy(this.dw_gateway)
destroy(this.dw_gateway_branch)
destroy(this.dw_activity)
destroy(this.dw_activity_branch)
destroy(this.dw_activity_sub)
destroy(this.dw_activity_sub_branch)
destroy(this.st_status)
destroy(this.rr_1)
end on

event open;call super::open;//dw_jogun.InsertRow(0)
//dw_jogun.SetFocus()
//dw_1.Retrieve('%', '%')

string ls_arg
string ls_proj_seq

if isnull(Message.StringParm) then
	messagebox('오류', '초기화 작업(1)중 오류가 발생했습니다.')
	closewithreturn(this, -1)
end if

ls_arg = Message.StringParm
is_proj_code = f_get_token(ls_arg, '~n')
if is_proj_code = '' then
	messagebox('오류', '초기화 작업(2)중 오류가 발생했습니다.')
	closewithreturn(this, -1)
end if

ls_proj_seq = f_get_token(ls_arg, '~n')
if ls_proj_seq = '' then
	messagebox('오류', '초기화 작업(3)중 오류가 발생했습니다.')
	closewithreturn(this, -1)
end if
ii_proj_seq = integer(ls_proj_seq)

dw_gateway.SetTransObject(sqlca)
dw_gateway_branch.SetTransObject(sqlca)
dw_activity.SetTransObject(sqlca)
dw_activity_branch.SetTransObject(sqlca)
dw_activity_sub.SetTransObject(sqlca)
dw_activity_sub_branch.SetTransObject(sqlca)

//dw_gateway.retrieve(is_proj_code, ii_proj_seq)
//if dw_gateway.rowcount() > 0 then
//	messagebox('오류', '초기화 작업(4)중 오류가 발생했습니다.')
//	closewithreturn(this, -1)
//end if

p_inq.postEvent(Clicked!)

end event

type dw_jogun from w_inherite_popup`dw_jogun within w_wflow_excel_import
integer x = 23
integer y = 32
integer width = 1326
integer height = 136
string dataobject = "dc_flow_project_find"
end type

type p_exit from w_inherite_popup`p_exit within w_wflow_excel_import
integer x = 2496
end type

event p_exit::clicked;call super::clicked;Closewithreturn(parent, 0)

end event

type p_inq from w_inherite_popup`p_inq within w_wflow_excel_import
event ue_excel_ole_import ( )
event ue_excel_dde_import ( )
integer x = 2149
string picturename = "C:\erpman\image\엑셀변환_up.gif"
end type

event p_inq::ue_excel_ole_import;string ls_path
OLEObject lole_Excel, lole_Sheet
long ll_find
integer li_rc, li_sheet

if wf_get_excel_filename(ls_path) < 0 then
	return
end if

setpointer(hourglass!)

dw_gateway.reset()
dw_gateway_branch.reset()
dw_activity.reset()
dw_activity_branch.reset()
dw_activity_sub.reset()
dw_activity_sub_branch.reset()

st_status.text = '엑셀 초기화중...'

lole_Excel = Create OLEObject
lole_Sheet = Create OLEObject

li_rc = lole_Excel.ConnectToNewObject("excel.application")
if li_rc < 0 then
	messagebox('error', "link error")
	setpointer(arrow!)
	return
end if

//lole_Excel.Visible = TRUE
lole_Excel.Application.Workbooks.Open(ls_path)
li_sheet = 0
for ll_find = 1 to lole_Excel.Application.ActiveWorkbook.Worksheets.Count
	if lole_Excel.Application.ActiveWorkbook.Worksheets[ll_find].Name = "입력화면" then
		li_sheet = ll_find
		lole_Sheet = lole_Excel.Application.ActiveWorkbook.Worksheets[ll_find]
		exit
	end if
next

if li_sheet = 0 then
//	messagebox("자료변환오류", "해당엑셀파일에는 자료변환할 sheet가 존재하지 않습니다.", stopsign!)
//	lole_Excel.Windows[1].Close
//	lole_Excel.DisconnectObject()
//	setpointer(arrow!)
//	return
	lole_Sheet = lole_Excel.Application.ActiveWorkbook.Worksheets[1]
end if

li_rc = wf_excel_ole_import(lole_Sheet)

lole_Excel.Windows[1].Close
lole_Excel.DisconnectObject()

if li_rc < 0 then 
	st_status.text = '자료 변환중 오류 발생'
	Messagebox("오류", "자료 변환중 오류가 발생 했습니다.")
else
	st_status.text = ''
	Messagebox("알림", "정상적으로 처리되었습니다")
end if

setpointer(arrow!)

end event

event p_inq::ue_excel_dde_import;string ls_path
OLEObject lole_Excel, lole_Sheet
long ll_find
integer li_rc, li_sheet
long    ll_handle
long    ll_start_row, ll_end_row

if wf_get_excel_filename(ls_path) < 0 then
	return
end if

setpointer(hourglass!)

dw_gateway.reset()
dw_gateway_branch.reset()
dw_activity.reset()
dw_activity_branch.reset()
dw_activity_sub.reset()
dw_activity_sub_branch.reset()

st_status.text = '엑셀 초기화중...'

lole_Excel = Create OLEObject
lole_Sheet = Create OLEObject

li_rc = lole_Excel.ConnectToNewObject("excel.application")
if li_rc < 0 then
	messagebox('error', "link error")
	setpointer(arrow!)
	return
end if

//lole_Excel.Visible = TRUE
lole_Excel.Application.Workbooks.Open(ls_path)

ll_handle = OpenChannel("Excel", ls_path)
if ll_handle < 0 then
	lole_Excel.Windows[1].Close
	lole_Excel.DisconnectObject()
	messagebox('error', "OpenChannel error")
	setpointer(arrow!)
	return
end if

lole_Sheet = lole_Excel.Application.ActiveWorkbook.Worksheets[1]
ll_start_row = lole_Sheet.UsedRange.Rows(1).Row + 1
ll_end_row = lole_Sheet.UsedRange.Rows(lole_Sheet.UsedRange.Rows.Count).Row

li_rc = wf_excel_dde_import(ll_handle, ll_start_row, ll_end_row)

//ExecRemote("[Close]", ll_handle)
CloseChannel(ll_handle)

lole_Excel.Windows[1].Close
lole_Excel.DisconnectObject()

if li_rc < 0 then 
	st_status.text = '자료 변환중 오류 발생'
	Messagebox("오류", "자료 변환중 오류가 발생 했습니다.")
else
	st_status.text = ''
	Messagebox("알림", "정상적으로 처리되었습니다")
end if

setpointer(arrow!)

end event

event p_inq::clicked;call super::clicked;//event ue_excel_ole_import()
event ue_excel_dde_import()

end event

event p_inq::ue_lbuttondown;PictureName = "C:\erpman\image\엑셀변환_dn.gif"
end event

event p_inq::ue_lbuttonup;PictureName = "C:\erpman\image\엑셀변환_up.gif"
end event

type p_choose from w_inherite_popup`p_choose within w_wflow_excel_import
integer x = 2322
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_choose::clicked;call super::clicked;if dw_gateway.update() > 0 then
	if dw_activity.update() > 0 then
		if dw_activity_sub.update() > 0 then
			commit;
		else
			rollback;
		end if
	else
		rollback;
	end if
else
	rollback;
end if

Closewithreturn(parent, 1)

end event

event p_choose::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event p_choose::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type dw_1 from w_inherite_popup`dw_1 within w_wflow_excel_import
integer x = 37
integer y = 188
integer width = 2642
integer height = 1556
string dataobject = "dm_flow_import_error"
boolean hscrollbar = true
end type

event dw_1::doubleclicked;call super::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_code= dw_1.GetItemString(Row, "proj_code")
gs_codename = string(dw_1.GetItemNumber(Row, "proj_seq"))

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_wflow_excel_import
end type

type cb_1 from w_inherite_popup`cb_1 within w_wflow_excel_import
end type

type cb_return from w_inherite_popup`cb_return within w_wflow_excel_import
end type

type cb_inq from w_inherite_popup`cb_inq within w_wflow_excel_import
end type

type sle_1 from w_inherite_popup`sle_1 within w_wflow_excel_import
end type

type st_1 from w_inherite_popup`st_1 within w_wflow_excel_import
end type

type dw_gateway from datawindow within w_wflow_excel_import
boolean visible = false
integer x = 69
integer y = 620
integer width = 1093
integer height = 96
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "dw_gateway"
string dataobject = "dm_flow_import_gateway"
end type

type dw_gateway_branch from datawindow within w_wflow_excel_import
boolean visible = false
integer x = 69
integer y = 712
integer width = 1093
integer height = 96
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "dw_gateway_branch"
string dataobject = "dm_flow_import_gateway_branch"
end type

type dw_activity from datawindow within w_wflow_excel_import
boolean visible = false
integer x = 69
integer y = 804
integer width = 1093
integer height = 96
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "dw_activity"
string dataobject = "dm_flow_import_activity"
end type

type dw_activity_branch from datawindow within w_wflow_excel_import
boolean visible = false
integer x = 69
integer y = 896
integer width = 1093
integer height = 96
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "dw_activity_branch"
string dataobject = "dm_flow_import_activity_branch"
end type

type dw_activity_sub from datawindow within w_wflow_excel_import
boolean visible = false
integer x = 69
integer y = 992
integer width = 1093
integer height = 96
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "dw_activity_sub"
string dataobject = "dm_flow_import_activity_sub"
end type

type dw_activity_sub_branch from datawindow within w_wflow_excel_import
boolean visible = false
integer x = 69
integer y = 1084
integer width = 1093
integer height = 96
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "dw_activity_sub_branch"
string dataobject = "dm_flow_import_activity_sub_branch"
end type

type st_status from statictext within w_wflow_excel_import
integer x = 55
integer y = 56
integer width = 1234
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_wflow_excel_import
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 180
integer width = 2665
integer height = 1576
integer cornerheight = 40
integer cornerwidth = 55
end type

