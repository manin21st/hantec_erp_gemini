$PBExportHeader$w_sm10_0030.srw
$PBExportComments$VAN 접수
forward
global type w_sm10_0030 from w_standard_print
end type
type p_search from uo_picture within w_sm10_0030
end type
type p_delrow from uo_picture within w_sm10_0030
end type
type p_delrow_all from uo_picture within w_sm10_0030
end type
type pb_1 from u_pb_cal within w_sm10_0030
end type
type dw_d2 from datawindow within w_sm10_0030
end type
type dw_d0 from datawindow within w_sm10_0030
end type
type dw_d68 from datawindow within w_sm10_0030
end type
type dw_gi from datawindow within w_sm10_0030
end type
type dw_dh from datawindow within w_sm10_0030
end type
type dw_p6 from datawindow within w_sm10_0030
end type
type dw_p7 from datawindow within w_sm10_0030
end type
type dw_d1 from datawindow within w_sm10_0030
end type
type dw_d9 from datawindow within w_sm10_0030
end type
type dw_d3 from datawindow within w_sm10_0030
end type
type st_state from statictext within w_sm10_0030
end type
type tab_1 from tab within w_sm10_0030
end type
type tabpage_1 from userobject within tab_1
end type
type rr_1 from roundrectangle within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rr_1 rr_1
end type
type tabpage_2 from userobject within tab_1
end type
type rr_2 from roundrectangle within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rr_2 rr_2
end type
type tab_1 from tab within w_sm10_0030
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type pb_2 from u_pb_cal within w_sm10_0030
end type
type p_excel from uo_picture within w_sm10_0030
end type
type st_caption from statictext within w_sm10_0030
end type
type p_mod from uo_picture within w_sm10_0030
end type
type cb_d9_et from commandbutton within w_sm10_0030
end type
type cb_1 from commandbutton within w_sm10_0030
end type
type dw_d2_detail from datawindow within w_sm10_0030
end type
end forward

global type w_sm10_0030 from w_standard_print
integer width = 4677
integer height = 2508
string title = "KMC VAN 접수"
p_search p_search
p_delrow p_delrow
p_delrow_all p_delrow_all
pb_1 pb_1
dw_d2 dw_d2
dw_d0 dw_d0
dw_d68 dw_d68
dw_gi dw_gi
dw_dh dw_dh
dw_p6 dw_p6
dw_p7 dw_p7
dw_d1 dw_d1
dw_d9 dw_d9
dw_d3 dw_d3
st_state st_state
tab_1 tab_1
pb_2 pb_2
p_excel p_excel
st_caption st_caption
p_mod p_mod
cb_d9_et cb_d9_et
cb_1 cb_1
dw_d2_detail dw_d2_detail
end type
global w_sm10_0030 w_sm10_0030

type variables
String is_custid
Long il_err , il_succeed


DataWindowChild idwc_d0
end variables

forward prototypes
public function integer wf_retrieve ()
public function long wf_van_scan_chk (string arg_value, string arg_value_1)
public function integer wf_van_d2 (string arg_file_name, string arg_sabu)
public function string wf_choose (string as_gubun)
public function integer wf_van_d1 (string arg_file_name, string arg_sabu)
public function integer wf_van_d68 (string arg_file_name, string arg_sabu)
public function integer wf_van_d9 (string arg_file_name, string arg_sabu)
public function double wf_van_scan_chk2 (string arg_gubun, string arg_value, string arg_value_1)
public function long wf_van_p7 (string arg_file_name, string arg_sabu)
public function integer wf_van_d0 (string arg_file_name, string arg_sabu)
public function integer wf_van_gi (string arg_file_name, string arg_sabu)
public function integer wf_van_dh (string arg_file_name, string arg_sabu)
public function integer wf_van_p6 (string arg_file_name, string arg_sabu)
public function integer wf_van_d3 (string arg_file_name, string arg_sabu)
public function long wf_itnbr_insert (string ar_itnbr, string ar_itdsc)
public function long wf_error (string as_gubun, long al_line, string as_doccode, string as_factory, string as_itnbr, string as_errtext)
public function integer wf_file_copy (string arg_file)
public function integer wf_van_d9_et (string arg_file_name, string arg_sabu)
end prototypes

public function integer wf_retrieve ();Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_sdate  ,ls_edate, ls_saupj_cust 
string ls_factory , ls_itnbr, ls_itnbr_from, ls_itnbr_to, ls_from, ls_to
Integer li_no
String ls_empno
DataWindow ldw_x

If Tab_1.SelectedTab = 1 Then Return -1

if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1

ls_gubun = Trim(dw_ip.Object.gubun[1]) 
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_cvcod = Trim(dw_ip.Object.mcvcod[1])

ls_empno = Trim(dw_ip.Object.empno[1])

ls_sdate = Trim(dw_ip.Object.jisi_date[1])
ls_edate = Trim(dw_ip.Object.jisi_date2[1])

//ls_itnbr = Trim(dw_ip.Object.itnbr[1])
ls_factory = Trim(dw_ip.Object.factory[1])

If ls_empno = '' Or isNull(ls_empno) Then ls_empno = '%'

If ls_itnbr = '' Or isNull(ls_itnbr) Then ls_itnbr = ''
If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'

ls_itnbr_from = Trim(dw_ip.Object.itnbr_from[1])
IF isNull(ls_itnbr_from) THEN ls_itnbr_from = ''
ls_itnbr_to = Trim(dw_ip.Object.itnbr_to[1])
IF isNull(ls_itnbr_to) THEN ls_itnbr_to = ''

SetNull(ls_saupj_cust)

select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
  from dual ;
If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
	MessageBox('확인','사업장을 선택하세요')
	Return -1
End If
	
// 품번 전체를 검색 할 때에 ITEMAS의 최소, 최고 품번을 조회한다.	
IF ls_itnbr_from = '' and ls_itnbr_to = '' THEN	
	SELECT MIN(ITNBR), MAX(ITNBR) 
	INTO   :ls_from, :ls_to
	FROM   ITEMAS;
	
	If sqlca.sqlcode <> 0 Then
		MessageBox('에러','품번마스터를 조회할 수 없습니다.~n전산실에 문의 바랍니다.')
		Return -1
	End If
	li_no = 1
ELSE
	ls_from = ls_itnbr_from
	ls_to = ls_itnbr_to
	li_no = 2
END IF

If Tab_1.SelectedTab = 1 Then
	dw_list.Retrieve(ls_saupj , ls_sdate ,ls_edate )
Else
	Choose Case ls_gubun 
		Case 'D0'
			ldw_x = dw_d0
		Case 'D2'
			ldw_x = dw_d2
		Case 'D6'
			ldw_x = dw_d68
		Case 'D8'
			ldw_x = dw_d68
		Case 'GI'
			ldw_x = dw_gi
		Case 'DH'
			ldw_x = dw_dh
		Case 'P6'
			ldw_x = dw_p6
		Case 'P7'
			ldw_x = dw_p7
		Case 'D1'
			ldw_x = dw_d1
		Case 'D9'
			ldw_x = dw_d9
		Case 'D3'
			ldw_x = dw_d3
		
	End Choose
	
	//Messagebox('',ls_saupj_cust +'  '+ ls_gubun+'  '+ls_sdate +'  '+ls_gubun+'  '+ls_edate+'  '+ ls_from+'  '+ ls_to +'  '+ ls_factory +'  '+ ls_cvcod+'  '+ string(li_no)  )
	
	ldw_x.Retrieve(ls_saupj_cust , ls_gubun+ls_sdate ,ls_gubun+ls_edate, ls_from, ls_to , ls_factory ,  li_no , ls_empno)
End IF

Return 1
end function

public function long wf_van_scan_chk (string arg_value, string arg_value_1);//정수형
long ll_asc_value
long ll_return_value

ll_asc_value = asc(arg_value_1)
// 'A' ~ 'I'
if ll_asc_value >= 64 and ll_asc_value <= 73 then
	ll_return_value = long(arg_value) * 10 + ll_asc_value - 64
// 'J' ~ 'R'
elseif ll_asc_value >= 74 and ll_asc_value <= 82 then
	ll_return_value = (long(arg_value) * 10 + ll_asc_value - 73) * -1
// '{'
elseif ll_asc_value = 123 then
	ll_return_value = long(arg_value) * 10
// '}'
elseif ll_asc_value = 125 then
	ll_return_value = long(arg_value) * -10
else
	ll_return_value = long(arg_value) * 10 + long(arg_value_1)
end if
	
return ll_return_value
end function

public function integer wf_van_d2 (string arg_file_name, string arg_sabu);/* 값변환 참조
	{:+0  	}:-0
	A:1  B:2  C:3  D:4  E:5  F:6  G:7  H:8  I:9
	J:-1 K:-2 L:-3 M:-4 N:-5 O:-6 P:-7 Q:-8 R:-9  */
	
/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	

string ls_Input_Data  ,ls_indate
integer li_FileNum,li_cnt,li_rowcnt , li_file_rtn 
Long  ll_data = 0
string ls_SABU,ls_DOCCODE,ls_CUSTCD,ls_FACTORY,ls_ITNBR
long ll_CUR_STOCK,ll_ACTUAL_STOCK,ll_PREV_RESULT,ll_PLAN_D8HQTY,ll_PLAN_D10HQTY,ll_PLAN_D13HQTY,ll_PLAN_D15HQTY,ll_PLAN_D18HQTY,ll_PLAN_D21HQTY
long ll_PLAN_D23HQTY,ll_PLAN_D2HQTY,ll_PLAN_D4HQTY,ll_PLAN_D6HQTY,ll_PLAN_DQTY,ll_PLAN_D1TQTY,ll_PLAN_D2TQTY,ll_PLAN_D3TQTY,ll_PLAN_D4TQTY,ll_PLAN_D5QTY
long ll_PLAN_D6QTY,ll_PLAN_D7QTY,ll_PLAN_D8QTY,ll_PLAN_D9QTY,ll_PLAN_D10QTY,ll_PLAN_D11QTY,ll_PLAN_D12QTY,ll_PLAN_D13QTY,ll_PLAN_D14QTY,ll_PLAN_D15QTY
long ll_PLAN_D16QTY,ll_PLAN_D17QTY,ll_PLAN_D18QTY,ll_PLAN_D19QTY,ll_PLAN_D20QTY,ll_PLAN_D21QTY,ll_PLAN_D22QTY,ll_PLAN_D23QTY,ll_PLAN_D24QTY,ll_PLAN_D25QTY
long ll_PLAN_D26QTY,ll_PLAN_D27QTY,ll_PLAN_D28QTY,ll_PLAN_D29QTY,ll_PLAN_D30QTY,ll_PLAN_D45QTY,ll_TODAY_IPQTY
string ls_ORDER_TYPE,ls_CRT_DATE,ls_CRT_TIME,ls_CRT_USER
long ll_PLAN_D1QTY1,ll_PLAN_D1QTY2,ll_PLAN_D1QTY3,ll_PLAN_D1QTY4,ll_PLAN_D1QTY5,ll_PLAN_D1QTY6,ll_PLAN_D1QTY7,ll_PLAN_D1QTY8,ll_PLAN_D1QTY9,ll_PLAN_D1QTY10
long ll_PLAN_D2QTY1,ll_PLAN_D2QTY2,ll_PLAN_D2QTY3,ll_PLAN_D2QTY4,ll_PLAN_D2QTY5,ll_PLAN_D2QTY6,ll_PLAN_D2QTY7,ll_PLAN_D2QTY8,ll_PLAN_D2QTY9,ll_PLAN_D2QTY10
long ll_PLAN_D3QTY1,ll_PLAN_D3QTY2,ll_PLAN_D3QTY3,ll_PLAN_D3QTY4,ll_PLAN_D3QTY5,ll_PLAN_D3QTY6,ll_PLAN_D3QTY7,ll_PLAN_D3QTY8,ll_PLAN_D3QTY9,ll_PLAN_D3QTY10
long ll_PLAN_D4QTY1,ll_PLAN_D4QTY2,ll_PLAN_D4QTY3,ll_PLAN_D4QTY4,ll_PLAN_D4QTY5,ll_PLAN_D4QTY6,ll_PLAN_D4QTY7,ll_PLAN_D4QTY8,ll_PLAN_D4QTY9,ll_PLAN_D4QTY10
string ls_MITNBR,ls_MCVCOD,ls_MDCVCOD,ls_citnbr , ls_gubun

Long ll_cnt

//현재 일자,시간 
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')

Long ll_p , ll_px

ll_p = LastPos(arg_file_name , '\')
ll_px = LastPos(Upper(arg_file_name) , '.TXT')

ls_gubun = Upper(Mid(arg_file_name , ll_p + 1 , ll_px - ( ll_p + 1 ) ))

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(ls_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	return -1
end if

li_cnt = 0

st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'
Do While	FileRead(li_FileNum, ls_Input_Data) <> -100

	
	SetNull(ls_mitnbr)
	SetNull(ls_mcvcod)
	SetNull(ls_mdcvcod)
	SetNull(ls_citnbr)
	
	li_cnt ++
	
	yield()
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt) 
	
	ls_doccode = trim(mid(ls_Input_Data,1,12))
	ls_indate = Trim(dw_ip.Object.jisi_date[1])
	// 파일 날짜 체크
//	if ls_indate <> Mid(ls_doccode,3,8) then
//		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "파일의 수신일자와 등록일자가 상이합니다.")
//		Continue ;
//	end if
	
	if ls_indate <> Mid(ls_doccode,3,8) then
		ls_indate = Mid(ls_doccode,3,8)
	end if
	
	// 화일명의 값과 필드값을 체크
	if upper(left(right(arg_file_name,6),2)) <> upper(left(ls_doccode,2)) then
		rollback;
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,'','',"화일명과 화일의 필드값이 틀립니다.")
		FileClose(li_FileNum)
		return -2
	end if

	ls_custcd = trim(mid(ls_Input_Data,13,4))
	ls_factory = trim(mid(ls_Input_Data,17,2))
	ls_itnbr = trim(mid(ls_Input_Data,19,15))
	ll_cur_stock = wf_van_scan_chk(mid(ls_Input_Data,34,6),mid(ls_Input_Data,40,1))
	ll_actual_stock =  wf_van_scan_chk(mid(ls_Input_Data,41,6),mid(ls_Input_Data,47,1))
	ll_prev_result = wf_van_scan_chk(mid(ls_Input_Data,48,4),mid(ls_Input_Data,52,1))
	ll_plan_d8hqty = wf_van_scan_chk(mid(ls_Input_Data,53,4),mid(ls_Input_Data,57,1))
	ll_plan_d10hqty = wf_van_scan_chk(mid(ls_Input_Data,58,4),mid(ls_Input_Data,62,1))
	ll_plan_d13hqty = wf_van_scan_chk(mid(ls_Input_Data,63,4),mid(ls_Input_Data,67,1))
	ll_plan_d15hqty = wf_van_scan_chk(mid(ls_Input_Data,68,4),mid(ls_Input_Data,72,1))
	ll_plan_d18hqty = wf_van_scan_chk(mid(ls_Input_Data,73,4),mid(ls_Input_Data,77,1))
	ll_plan_d21hqty = wf_van_scan_chk(mid(ls_Input_Data,78,4),mid(ls_Input_Data,82,1))
	ll_plan_d23hqty = wf_van_scan_chk(mid(ls_Input_Data,83,4),mid(ls_Input_Data,87,1))
	ll_plan_d2hqty = wf_van_scan_chk(mid(ls_Input_Data,88,4),mid(ls_Input_Data,92,1))
	ll_plan_d4hqty = wf_van_scan_chk(mid(ls_Input_Data,93,4),mid(ls_Input_Data,97,1))
	ll_plan_d6hqty = wf_van_scan_chk(mid(ls_Input_Data,98,4),mid(ls_Input_Data,102,1))
	ll_plan_dqty = wf_van_scan_chk(mid(ls_Input_Data,103,4),mid(ls_Input_Data,107,1))
	ll_PLAN_D1QTY1 = long(mid(ls_Input_Data,108,5))
	ll_PLAN_D1QTY2 = long(mid(ls_Input_Data,113,5))
	ll_PLAN_D1QTY3 = long(mid(ls_Input_Data,118,5))
	ll_PLAN_D1QTY4 = long(mid(ls_Input_Data,123,5))
	ll_PLAN_D1QTY5 = long(mid(ls_Input_Data,128,5))
	ll_PLAN_D1QTY6 = long(mid(ls_Input_Data,133,5))
	ll_PLAN_D1QTY7 = long(mid(ls_Input_Data,138,5))
	ll_PLAN_D1QTY8 = long(mid(ls_Input_Data,143,5))
	ll_PLAN_D1QTY9 = long(mid(ls_Input_Data,148,5))
	ll_PLAN_D1QTY10 = long(mid(ls_Input_Data,153,5))
	ll_plan_d1tqty = wf_van_scan_chk(mid(ls_Input_Data,158,4),mid(ls_Input_Data,162,1))
   ll_PLAN_D2QTY1 = long(mid(ls_Input_Data,163,5))
	ll_PLAN_D2QTY2 = long(mid(ls_Input_Data,168,5))
	ll_PLAN_D2QTY3 = long(mid(ls_Input_Data,173,5))
	ll_PLAN_D2QTY4 = long(mid(ls_Input_Data,178,5))
	ll_PLAN_D2QTY5 = long(mid(ls_Input_Data,183,5))
	ll_PLAN_D2QTY6 = long(mid(ls_Input_Data,188,5))
	ll_PLAN_D2QTY7 = long(mid(ls_Input_Data,193,5))
	ll_PLAN_D2QTY8 = long(mid(ls_Input_Data,198,5))
	ll_PLAN_D2QTY9 = long(mid(ls_Input_Data,203,5))
	ll_PLAN_D2QTY10 = long(mid(ls_Input_Data,208,5))
	ll_plan_d2tqty = wf_van_scan_chk(mid(ls_Input_Data,213,4),mid(ls_Input_Data,217,1))
	ll_PLAN_D3QTY1 = long(mid(ls_Input_Data,218,5))
	ll_PLAN_D3QTY2 = long(mid(ls_Input_Data,223,5))
	ll_PLAN_D3QTY3 = long(mid(ls_Input_Data,228,5))
	ll_PLAN_D3QTY4 = long(mid(ls_Input_Data,233,5))
	ll_PLAN_D3QTY5 = long(mid(ls_Input_Data,238,5))
	ll_PLAN_D3QTY6 = long(mid(ls_Input_Data,243,5))
	ll_PLAN_D3QTY7 = long(mid(ls_Input_Data,248,5))
	ll_PLAN_D3QTY8 = long(mid(ls_Input_Data,253,5))
	ll_PLAN_D3QTY9 = long(mid(ls_Input_Data,258,5))
	ll_PLAN_D3QTY10 = long(mid(ls_Input_Data,263,5))	
	ll_plan_d3tqty = wf_van_scan_chk(mid(ls_Input_Data,268,4),mid(ls_Input_Data,272,1))
	ll_PLAN_D4QTY1 = long(mid(ls_Input_Data,273,5))	
	ll_PLAN_D4QTY2 = long(mid(ls_Input_Data,278,5))	
	ll_PLAN_D4QTY3 = long(mid(ls_Input_Data,283,5))	
	ll_PLAN_D4QTY4 = long(mid(ls_Input_Data,288,5))	
	ll_PLAN_D4QTY5 = long(mid(ls_Input_Data,293,5))	
	ll_PLAN_D4QTY6 = long(mid(ls_Input_Data,298,5))	
	ll_PLAN_D4QTY7 = long(mid(ls_Input_Data,303,5))	
	ll_PLAN_D4QTY8 = long(mid(ls_Input_Data,308,5))	
	ll_PLAN_D4QTY9 = long(mid(ls_Input_Data,313,5))	
	ll_PLAN_D4QTY10 = long(mid(ls_Input_Data,318,5))	
	ll_plan_d4tqty = wf_van_scan_chk(mid(ls_Input_Data,323,4),mid(ls_Input_Data,327,1))
	ll_plan_d5qty = wf_van_scan_chk(mid(ls_Input_Data,328,4),mid(ls_Input_Data,332,1))
	ll_plan_d6qty = wf_van_scan_chk(mid(ls_Input_Data,333,4),mid(ls_Input_Data,337,1))
	ll_plan_d7qty = wf_van_scan_chk(mid(ls_Input_Data,338,4),mid(ls_Input_Data,342,1))
	ll_plan_d8qty = wf_van_scan_chk(mid(ls_Input_Data,343,4),mid(ls_Input_Data,347,1))
	ll_plan_d9qty = wf_van_scan_chk(mid(ls_Input_Data,348,4),mid(ls_Input_Data,352,1))
	ll_plan_d10qty = wf_van_scan_chk(mid(ls_Input_Data,353,4),mid(ls_Input_Data,357,1))
	ll_plan_d11qty = wf_van_scan_chk(mid(ls_Input_Data,358,4),mid(ls_Input_Data,362,1))
	ll_plan_d12qty = wf_van_scan_chk(mid(ls_Input_Data,363,4),mid(ls_Input_Data,367,1))
	ll_plan_d13qty = wf_van_scan_chk(mid(ls_Input_Data,368,4),mid(ls_Input_Data,372,1))
	ll_plan_d14qty = wf_van_scan_chk(mid(ls_Input_Data,373,4),mid(ls_Input_Data,377,1))
	ll_plan_d15qty = wf_van_scan_chk(mid(ls_Input_Data,378,4),mid(ls_Input_Data,382,1))
	ll_plan_d16qty = wf_van_scan_chk(mid(ls_Input_Data,383,4),mid(ls_Input_Data,387,1))
	ll_plan_d17qty = wf_van_scan_chk(mid(ls_Input_Data,388,4),mid(ls_Input_Data,392,1))
	ll_plan_d18qty = wf_van_scan_chk(mid(ls_Input_Data,393,4),mid(ls_Input_Data,397,1))
	ll_plan_d19qty = wf_van_scan_chk(mid(ls_Input_Data,398,4),mid(ls_Input_Data,402,1))
	ll_plan_d20qty = wf_van_scan_chk(mid(ls_Input_Data,403,4),mid(ls_Input_Data,407,1))
	ll_plan_d21qty = wf_van_scan_chk(mid(ls_Input_Data,408,4),mid(ls_Input_Data,412,1))
	ll_plan_d22qty = wf_van_scan_chk(mid(ls_Input_Data,413,4),mid(ls_Input_Data,417,1))
	ll_plan_d23qty = wf_van_scan_chk(mid(ls_Input_Data,418,4),mid(ls_Input_Data,422,1))
	ll_plan_d24qty = wf_van_scan_chk(mid(ls_Input_Data,423,4),mid(ls_Input_Data,427,1))
	ll_plan_d25qty = wf_van_scan_chk(mid(ls_Input_Data,428,4),mid(ls_Input_Data,432,1))
	ll_plan_d26qty = wf_van_scan_chk(mid(ls_Input_Data,433,4),mid(ls_Input_Data,437,1))
	ll_plan_d27qty = wf_van_scan_chk(mid(ls_Input_Data,438,4),mid(ls_Input_Data,442,1))
	ll_plan_d28qty = wf_van_scan_chk(mid(ls_Input_Data,443,4),mid(ls_Input_Data,447,1))
	ll_plan_d29qty = wf_van_scan_chk(mid(ls_Input_Data,448,4),mid(ls_Input_Data,452,1))
	ll_plan_d30qty = wf_van_scan_chk(mid(ls_Input_Data,453,4),mid(ls_Input_Data,457,1))
	ll_plan_d45qty = wf_van_scan_chk(mid(ls_Input_Data,458,5),mid(ls_Input_Data,463,1))
	ll_today_ipqty = wf_van_scan_chk(mid(ls_Input_Data,464,6),mid(ls_Input_Data,470,1))
	ls_order_type = trim(mid(ls_Input_Data,471,1))
	

	//자체품번 읽어오기(자체거래처코드)
//	select itnbr
//	into :ls_mitnbr
//	from itemas
//	where replace(itnbr,'-','') = :ls_itnbr ;

//	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
	
	ls_mitnbr = sqlca.fun_get_buitnbr(ls_itnbr , '') ;
	
	if trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		//Rollback;
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')
		
		Continue ;
	End IF
	
	//공장별 거래처 읽어오기
   select fun_get_scvcod( :ls_factory , :ls_mitnbr ,''  ),
			 nvl(RFNA3,'')
	  Into :ls_mcvcod , :ls_mdcvcod
	  from reffpf 
	where sabu = :arg_sabu and
			rfcod = '2A' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
		il_err++
		Continue ;
	end if
	
	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
   ll_data++
	
	
	// 한텍 요청 //////////////////////////////////////////////////////
   ll_cnt = 0 
	select count(*) Into :ll_cnt
	  from van_hkcd2
	 where SABU=   :gs_SABU
		and DOCCODE = :ls_DOCCODE   
		and CUSTCD = :ls_CUSTCD  
		and FACTORY = :ls_FACTORY 
		and ITNBR = :ls_ITNBR ;
	
	If ll_cnt > 0 Then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(li_cnt)+']')
		Continue ;
	end if
/////////////////////////////////////////////////////////

	insert into van_hkcd2(SABU,DOCCODE,CUSTCD,FACTORY,ITNBR,CUR_STOCK,ACTUAL_STOCK,PREV_RESULT,PLAN_D8HQTY,PLAN_D10HQTY,
                  	PLAN_D13HQTY,PLAN_D15HQTY,PLAN_D18HQTY,PLAN_D21HQTY,PLAN_D23HQTY,PLAN_D2HQTY,PLAN_D4HQTY,PLAN_D6HQTY,
							PLAN_DQTY,PLAN_D1QTY1,PLAN_D1QTY2,PLAN_D1QTY3,PLAN_D1QTY4,PLAN_D1QTY5,PLAN_D1QTY6,PLAN_D1QTY7,PLAN_D1QTY8,
							PLAN_D1QTY9,PLAN_D1QTY10,PLAN_D1TQTY,PLAN_D2QTY1,PLAN_D2QTY2,PLAN_D2QTY3,PLAN_D2QTY4,PLAN_D2QTY5,PLAN_D2QTY6,
							PLAN_D2QTY7,PLAN_D2QTY8,PLAN_D2QTY9,PLAN_D2QTY10,PLAN_D2TQTY,PLAN_D3QTY1,PLAN_D3QTY2,PLAN_D3QTY3,PLAN_D3QTY4,
							PLAN_D3QTY5,PLAN_D3QTY6,PLAN_D3QTY7,PLAN_D3QTY8,PLAN_D3QTY9,PLAN_D3QTY10,PLAN_D3TQTY,PLAN_D4QTY1,PLAN_D4QTY2,
							PLAN_D4QTY3,PLAN_D4QTY4,PLAN_D4QTY5,PLAN_D4QTY6,PLAN_D4QTY7,PLAN_D4QTY8,PLAN_D4QTY9,PLAN_D4QTY10,PLAN_D4TQTY,
							PLAN_D5QTY,PLAN_D6QTY,PLAN_D7QTY,PLAN_D8QTY,PLAN_D9QTY,PLAN_D10QTY,PLAN_D11QTY,PLAN_D12QTY,PLAN_D13QTY,
							PLAN_D14QTY,PLAN_D15QTY,PLAN_D16QTY,PLAN_D17QTY,PLAN_D18QTY,PLAN_D19QTY,PLAN_D20QTY,PLAN_D21QTY,PLAN_D22QTY,
							PLAN_D23QTY,PLAN_D24QTY,PLAN_D25QTY,PLAN_D26QTY,PLAN_D27QTY,PLAN_D28QTY,PLAN_D29QTY,PLAN_D30QTY,PLAN_D45QTY,
							TODAY_IPQTY,ORDER_TYPE,CRT_DATE,CRT_TIME,CRT_USER,MITNBR,MCVCOD,MDCVCOD,CITNBR)       
					values(:arg_SABU,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_ITNBR,:ll_CUR_STOCK,:ll_ACTUAL_STOCK,:ll_PREV_RESULT,:ll_PLAN_D8HQTY,:ll_PLAN_D10HQTY,
                  	:ll_PLAN_D13HQTY,:ll_PLAN_D15HQTY,:ll_PLAN_D18HQTY,:ll_PLAN_D21HQTY,:ll_PLAN_D23HQTY,:ll_PLAN_D2HQTY,:ll_PLAN_D4HQTY,:ll_PLAN_D6HQTY,
							:ll_PLAN_DQTY,:ll_PLAN_D1QTY1,:ll_PLAN_D1QTY2,:ll_PLAN_D1QTY3,:ll_PLAN_D1QTY4,:ll_PLAN_D1QTY5,:ll_PLAN_D1QTY6,:ll_PLAN_D1QTY7,:ll_PLAN_D1QTY8,
							:ll_PLAN_D1QTY9,:ll_PLAN_D1QTY10,:ll_PLAN_D1TQTY,:ll_PLAN_D2QTY1,:ll_PLAN_D2QTY2,:ll_PLAN_D2QTY3,:ll_PLAN_D2QTY4,:ll_PLAN_D2QTY5,:ll_PLAN_D2QTY6,
							:ll_PLAN_D2QTY7,:ll_PLAN_D2QTY8,:ll_PLAN_D2QTY9,:ll_PLAN_D2QTY10,:ll_PLAN_D2TQTY,:ll_PLAN_D3QTY1,:ll_PLAN_D3QTY2,:ll_PLAN_D3QTY3,:ll_PLAN_D3QTY4,
							:ll_PLAN_D3QTY5,:ll_PLAN_D3QTY6,:ll_PLAN_D3QTY7,:ll_PLAN_D3QTY8,:ll_PLAN_D3QTY9,:ll_PLAN_D3QTY10,:ll_PLAN_D3TQTY,:ll_PLAN_D4QTY1,:ll_PLAN_D4QTY2,
							:ll_PLAN_D4QTY3,:ll_PLAN_D4QTY4,:ll_PLAN_D4QTY5,:ll_PLAN_D4QTY6,:ll_PLAN_D4QTY7,:ll_PLAN_D4QTY8,:ll_PLAN_D4QTY9,:ll_PLAN_D4QTY10,:ll_PLAN_D4TQTY,
							:ll_PLAN_D5QTY,:ll_PLAN_D6QTY,:ll_PLAN_D7QTY,:ll_PLAN_D8QTY,:ll_PLAN_D9QTY,:ll_PLAN_D10QTY,:ll_PLAN_D11QTY,:ll_PLAN_D12QTY,:ll_PLAN_D13QTY,
							:ll_PLAN_D14QTY,:ll_PLAN_D15QTY,:ll_PLAN_D16QTY,:ll_PLAN_D17QTY,:ll_PLAN_D18QTY,:ll_PLAN_D19QTY,:ll_PLAN_D20QTY,:ll_PLAN_D21QTY,:ll_PLAN_D22QTY,
							:ll_PLAN_D23QTY,:ll_PLAN_D24QTY,:ll_PLAN_D25QTY,:ll_PLAN_D26QTY,:ll_PLAN_D27QTY,:ll_PLAN_D28QTY,:ll_PLAN_D29QTY,:ll_PLAN_D30QTY,:ll_PLAN_D45QTY,
							:ll_TODAY_IPQTY,:ls_ORDER_TYPE,:ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,:ls_MITNBR,:ls_MCVCOD,:ls_MDCVCOD,:ls_CITNBR);
	
	if sqlca.sqlcode <> 0 then
		
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		st_state.Visible = False
		return -3
	end if
	il_succeed++


Loop


// van file close
FileClose(li_FileNum)

commit;

wf_file_copy(arg_file_name)

st_state.Visible = False
return li_cnt
end function

public function string wf_choose (string as_gubun);

Choose Case as_gubun
	Case 'D0'
		If Tab_1.SelectedTab = 2 Then
			dw_d0.x = dw_list.x
			dw_d0.y = dw_list.y
			dw_d0.width  = dw_list.width
			dw_d0.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = True
			dw_d2.visible = False
			dw_d68.visible = False
			dw_gi.visible = False
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
		End If
		return 'C:\HKC\VAN\HKCD0.TXT'
	Case 'D2'
		If Tab_1.SelectedTab = 2 Then
			dw_d2.x = dw_list.x
			dw_d2.y = dw_list.y
			dw_d2.width  = dw_list.width
			dw_d2.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = True
			dw_d68.visible = False
			dw_gi.visible = False
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
		End If
		return 'C:\HKC\VAN\HKCD2.TXT'
	Case 'D6'
		If Tab_1.SelectedTab = 2 Then
			dw_d68.x = dw_list.x
			dw_d68.y = dw_list.y
			dw_d68.width  = dw_list.width
			dw_d68.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_d68.visible = True
			dw_gi.visible = False
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
		End if
		return 'C:\HKC\VAN\HKCD6.TXT'
	Case 'D8'
		If Tab_1.SelectedTab = 2 Then
			dw_d68.x = dw_list.x
			dw_d68.y = dw_list.y
			dw_d68.width  = dw_list.width
			dw_d68.height = dw_list.height
			
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_d68.visible = True
			dw_gi.visible = False
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
		End If
		return 'C:\HKC\VAN\HKCD8.TXT'	
	Case 'GI'
		If Tab_1.SelectedTab = 2 Then
			dw_gi.x = dw_list.x
			dw_gi.y = dw_list.y
			dw_gi.width  = dw_list.width
			dw_gi.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_d68.visible = False
			dw_gi.visible = True
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
		End If
		return 'C:\HKC\VAN\GINGUB.TXT'
	Case 'DH'
		If Tab_1.SelectedTab = 2 Then
			dw_dh.x = dw_list.x
			dw_dh.y = dw_list.y
			dw_dh.width  = dw_list.width
			dw_dh.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_d68.visible = False
			dw_gi.visible = False
			dw_dh.visible = True
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
		End IF
		return 'C:\HKC\VAN\HKCDH.TXT'
	Case 'P6'
		If Tab_1.SelectedTab = 2 Then
			dw_p6.x = dw_list.x
			dw_p6.y = dw_list.y
			dw_p6.width  = dw_list.width
			dw_p6.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_d68.visible = False
			dw_gi.visible = False
			dw_dh.visible = False
			dw_p6.visible = True
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
		End IF
		return 'C:\HKC\VAN\HKCP6.TXT'
	Case 'P7'
		If Tab_1.SelectedTab = 2 Then
			dw_p7.x = dw_list.x
			dw_p7.y = dw_list.y
			dw_p7.width  = dw_list.width
			dw_p7.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_d68.visible = False
			dw_gi.visible = False
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = True
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = False
		End IF
		return 'C:\HKC\VAN\HKCP7.TXT'
	Case 'D1'
		If Tab_1.SelectedTab = 2 Then
			dw_d1.x = dw_list.x
			dw_d1.y = dw_list.y
			dw_d1.width  = dw_list.width
			dw_d1.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_d68.visible = False
			dw_gi.visible = False
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = True
			dw_d9.visible = False
			dw_d3.visible = False
		End If
		return 'C:\HKC\VAN\HKCD1.TXT'
	Case 'D9'
		If Tab_1.SelectedTab = 2 Then
			dw_d9.x = dw_list.x
			dw_d9.y = dw_list.y
			dw_d9.width  = dw_list.width
			dw_d9.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_d68.visible = False
			dw_gi.visible = False
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = True
			dw_d3.visible = False
		End If
		return 'C:\HKC\VAN\HKCD9.TXT'
	Case 'D3'
		If Tab_1.SelectedTab = 2 Then
			dw_d3.x = dw_list.x
			dw_d3.y = dw_list.y
			dw_d3.width  = dw_list.width
			dw_d3.height = dw_list.height
			dw_list.visible = False
			
			dw_d0.visible = False
			dw_d2.visible = False
			dw_d68.visible = False
			dw_gi.visible = False
			dw_dh.visible = False
			dw_p6.visible = False
			dw_p7.visible = False
			dw_d1.visible = False
			dw_d9.visible = False
			dw_d3.visible = True
		End IF
		return 'C:\HKC\VAN\HKCD3.TXT'
	Case Else
//		If Tab_1.SelectedTab = 2 Then
//			//Tab_1.SelectedTab = 1
//		End IF


		dw_d0.visible = False
		dw_d2.visible = False
		dw_d68.visible = False
		dw_gi.visible = False
		dw_dh.visible = False
		dw_p6.visible = False
		dw_p7.visible = False
		dw_d1.visible = False
		dw_d9.visible = False
		dw_d3.visible = False
		
		dw_list.visible = True

		return 'C:\HKC\VAN'
		
End Choose
end function

public function integer wf_van_d1 (string arg_file_name, string arg_sabu);/* 값변환 참조
	{:+0  	}:-0
	A:1  B:2  C:3  D:4  E:5  F:6  G:7  H:8  I:9
	J:-1 K:-2 L:-3 M:-4 N:-5 O:-6 P:-7 Q:-8 R:-9  */
	
/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	

string ls_Input_Data ,ls_indate
integer li_FileNum,li_cnt,li_rowcnt
Long ll_data = 0  , ll_cnt
string ls_DOCCODE,ls_CUSTCD,ls_FACTORY,ls_ITNBR,ls_IPHDATE,ls_IPNO,ls_IPSOURCE,ls_IPGUBUN,ls_IPBAD_CD
string ls_CONFIRM_NO,ls_IPDATE,ls_ORDERNO,ls_LC_CHA,ls_LC_NO,ls_SHOPCODE,ls_FIL,ls_CRT_DATE,ls_CRT_TIME,ls_CRT_USER
long  ll_IPSEQ,ll_SUBSEQ
double ld_IPHQTY,ld_IPQTY,ld_LC_CHAQTY,ld_LC_CHASUM,ld_PACKQTY,ld_IPAMT,ld_IPDAN,ld_PACKDAN
string ls_MITNBR,ls_MCVCOD,ls_MDCVCOD,ls_citnbr , ls_gubun, ls_new
//현재 일자,시간 

Double ld_price ,ld_bprice 
Long   ll_f
String ls_start_date


ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')

Long ll_p , ll_px

ll_p = LastPos(arg_file_name , '\')
ll_px = LastPos(Upper(arg_file_name) , '.TXT')

ls_gubun = Upper(Mid(arg_file_name , ll_p + 1 , ll_px - ( ll_p + 1 ) ))


li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(ls_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	
	return -1
end if

li_cnt = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

/* 일, 월 검수 자료는 매출마감이 되면 받을 수 없음. - 2007.05.05 BY SHINGOON(노상호BJ요청) */
String ls_magam
SELECT MAX(MAYYMM)
  INTO :ls_magam
  FROM SALE_MAGAM;
/*******************************************************************************************/

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	//messagebox('',FileRead(li_FileNum, ls_Input_Data))
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	ls_citnbr = ''
	li_cnt ++
	ls_doccode = trim(mid(ls_Input_Data,1,12))
	
	// 화일명의 값과 필드값을 체크
	if upper(left(right(arg_file_name,6),2)) <> upper(left(ls_doccode,2)) then
		rollback;
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "화일명과 화일의 필드값이 틀립니다.")
		FileClose(li_FileNum)
		return -2
	end if
	
	ls_iphdate = trim(mid(ls_Input_Data,34,8))
	/* Y공장은 해당 일자가 없이 van접수 됨. - 해당 일자가 없으면 문서번호의 일자를 적용 - 2006.12.08 by shingoon */
	If Trim(ls_iphdate) = '' OR IsNull(ls_iphdate) Then
		ls_iphdate = MID(ls_doccode, 3, 8)
	End If
	/* 매출마감이 되어 있는 월의 일 검수 자료가 선택될 경우 Return - BY SHINGOON (노상호BJ요청) 2007.05.05 */
	If ls_magam >= LEFT(ls_iphdate, 6) Then
		ROLLBACK USING SQLCA;
		wf_error(ls_gubun, li_cnt, ls_doccode, '', '', '해당 검수(D1) 자료는 이미 매출마감이 완료된 자료입니다.')
		FileClose(li_FileNum)
		Return -2
	End If
	/********************************************************************************************/

	ls_custcd = trim(mid(ls_Input_Data,13,4))
	ls_factory = trim(mid(ls_Input_Data,17,2))
	ls_itnbr = trim(mid(ls_Input_Data,19,15))
	
	ls_ipno =  trim(mid(ls_Input_Data,42,4))
	ls_ipsource = trim(mid(ls_Input_Data,46,1))
	ls_ipgubun = trim(mid(ls_Input_Data,47,2))
	ld_iphqty = wf_van_scan_chk2('1',mid(ls_Input_Data,49,6),mid(ls_Input_Data,55,1))
	ld_ipqty = wf_van_scan_chk2('1',mid(ls_Input_Data,56,6),mid(ls_Input_Data,62,1))
	
	// 단가소급의 경우는 수량이 0 이면서 금액이 들어옴 - 2007.02.21 - 송병호
	//제외대상(입고구분) 'C' 
//	if ld_ipqty = 0 then continue
	
	ld_ipamt = wf_van_scan_chk2('1',mid(ls_Input_Data,63,10),mid(ls_Input_Data,73,1))
	ls_ipbad_cd = trim(mid(ls_Input_Data,74,2))
	ls_confirm_no = trim(mid(ls_Input_Data,76,7))
	ld_ipdan = wf_van_scan_chk2('2',mid(ls_Input_Data,83,8),mid(ls_Input_Data,91,2))
	ls_ipdate = trim(mid(ls_Input_Data,93,8))
	ls_orderno = trim(mid(ls_Input_Data,101,11))
	
//	//제외대상(입고구분) 'A' 이고 발주번호가 없는 것
//	IF ls_ipgubun = 'A' AND (isnull(ls_orderno) OR trim(ls_orderno) = '') then continue
//	//제외대상(입고구분) 'EE' 이고 발주번호가 없는 것
//	IF ls_ipgubun = 'EE' AND (isnull(ls_orderno) OR trim(ls_orderno) = '') then continue
//	//제외대상(입고구분) 'OD'
//	IF ls_ipgubun = 'OD' OR ls_ipgubun = '2D' OR ls_ipgubun = 'VC' OR ls_ipgubun = 'OS' OR ls_ipgubun = 'LD' then continue
//	//제외대상(입고구분) 'SB','SA' 서로 상계처리된 취소분
//	IF ls_ipgubun = 'SA' OR ls_ipgubun = 'SB' then continue

	If ls_ipno = '' Or isNull(ls_ipno) then ls_ipno = '.' ;
	If ls_ipsource = '' Or isNull(ls_ipsource) then ls_ipsource = '.' ;
	If ls_orderno = '' Or isNull(ls_orderno) then ls_orderno = '.' ;
	
	ls_lc_cha = trim(mid(ls_Input_Data,112,2))
	ld_lc_chaqty = wf_van_scan_chk2('1',mid(ls_Input_Data,114,6),mid(ls_Input_Data,120,1))
	ld_lc_chasum = wf_van_scan_chk2('1',mid(ls_Input_Data,121,6),mid(ls_Input_Data,127,1))
	ls_lc_no = trim(mid(ls_Input_Data,128,13))
	ld_packdan = wf_van_scan_chk2('2',mid(ls_Input_Data,141,6),mid(ls_Input_Data,147,2))
	ld_packqty = wf_van_scan_chk2('1',mid(ls_Input_Data,149,6),mid(ls_Input_Data,155,1))
	ls_shopcode = trim(mid(ls_Input_Data,156,2))
	ll_ipseq = long(mid(ls_Input_Data,158,7))
	ll_subseq = long(mid(ls_Input_Data,165,1))
	ls_fil = trim(mid(ls_Input_Data,166,3))
	
	
	//자체품번 읽어오기(자체거래처코드)
//	select itnbr
//	into :ls_mitnbr
//	from itemas
//	where replace(itnbr,'-','') = :ls_itnbr ;

//	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
	
		
	ls_mitnbr = sqlca.fun_get_buitnbr(ls_itnbr , '') ;
	
	if trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')
		
		Continue ;
	End IF
	
	//공장별 거래처 읽어오기
   select fun_get_scvcod( :ls_factory , :ls_mitnbr ,''  ),
			 nvl(RFNA3,'')
	  Into :ls_mcvcod , :ls_mdcvcod
	  from reffpf 
	where sabu = :arg_sabu and
			rfcod = '2A' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
		il_err++
		Continue ;
	end if


	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
	
	ls_indate = Trim(dw_ip.Object.jisi_date[1])
	// 파일 날짜 체크
//	if ls_indate <> Mid(ls_doccode,3,8) then
//		
//		Select Count(*) Into :ll_cnt
//		  From VAN_HKCD1
//		 WHERE SABU = :arg_sabu AND
//				 DOCCODE = :ls_doccode AND
//				 CUSTCD = :ls_custcd AND
//				 FACTORY = :ls_factory AND
//				 ITNBR = :ls_itnbr and
//				 IPNO =  :ls_ipno And 
//				 IPSOURCE = :ls_ipsource ;
//		If ll_cnt > 0 Then
//			
//			st_state.Visible = False
//			wf_error(ls_gubun,li_cnt,ls_doccode,'','', '중복데이타가 발생하였습니다. 해당라인은 입력 취소되었습니다.')
//		
//			FileClose(li_FileNum)
//			return -2
//		End If
//	end if
	
	ll_data++
//	IF ls_ipgubun = 'AD' THEN
//		UPDATE VAN_HKCD1
//		SET IPQTY = IPQTY + :ld_ipqty,
//			 IPAMT = IPAMT + :ld_ipamt
//		WHERE SABU = :arg_sabu AND
//				DOCCODE = :ls_doccode AND
//				CUSTCD = :ls_custcd AND
//				FACTORY = :ls_factory AND
//				ITNBR = :ls_itnbr;
//		if sqlca.sqlcode = 0 and sqlca.sqlnrows = 0 then
//			insert into van_hkcd1(SABU,DOCCODE,CUSTCD,FACTORY,ITNBR,IPHDATE,IPNO,IPSOURCE,IPGUBUN,IPHQTY,IPQTY,IPAMT,
//								IPBAD_CD,CONFIRM_NO,IPDAN,IPDATE,ORDERNO,LC_CHA,LC_CHAQTY,LC_CHASUM,LC_NO,PACKDAN,PACKQTY,
//								SHOPCODE,IPSEQ,SUBSEQ,FIL,CRT_DATE,CRT_TIME,CRT_USER,MITNBR,MCVCOD,MDCVCOD,CITNBR)       
//							values(:arg_SABU,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_ITNBR,:ls_IPHDATE,:ls_IPNO,:ls_IPSOURCE,:ls_IPGUBUN,:ld_IPHQTY,:ld_IPQTY,:ld_IPAMT,
//								:ls_IPBAD_CD,:ls_CONFIRM_NO,:ld_IPDAN,:ls_IPDATE,:ls_ORDERNO,:ls_LC_CHA,:ld_LC_CHAQTY,:ld_LC_CHASUM,:ls_LC_NO,:ld_PACKDAN,:ld_PACKQTY,
//								:ls_SHOPCODE,:ll_IPSEQ,:ll_SUBSEQ,:ls_FIL,:ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,:ls_MITNBR,:ls_MCVCOD,:ls_MDCVCOD,:ls_citnbr);
//			if sqlca.sqlcode <> 0 then
//			//	rollback;
//				st_state.Visible = False
//				wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+'] ')
//				rollback ;
//				FileClose(li_FileNum)
//				return -3
//			end if
//		end if
//	ELSE


// 한텍 요청 //////////////////////////////////////////////////////
   ll_cnt = 0 
	select count(*) Into :ll_cnt
	  from van_hkcd1
	 where SABU=   :gs_SABU
		and DOCCODE = :ls_DOCCODE   
		and CUSTCD = :ls_CUSTCD  
		and FACTORY = :ls_FACTORY 
		and ITNBR = :ls_ITNBR 
		and IPNO = :ls_ipno
		and IPSOURCE = :ls_ipsource
		and ORDERNO = :ls_orderno
		and IPSEQ = :ll_ipseq
		and SUBSEQ = :ll_subseq ;
		
	If ll_cnt > 0 Then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(li_cnt)+']')
		Continue ;
	end if
/////////////////////////////////////////////////////////

		insert into van_hkcd1(SABU,DOCCODE,CUSTCD,FACTORY,ITNBR,IPHDATE,IPNO,IPSOURCE,IPGUBUN,IPHQTY,IPQTY,IPAMT,
							IPBAD_CD,CONFIRM_NO,IPDAN,IPDATE,ORDERNO,LC_CHA,LC_CHAQTY,LC_CHASUM,LC_NO,PACKDAN,PACKQTY,
							SHOPCODE,IPSEQ,SUBSEQ,FIL,CRT_DATE,CRT_TIME,CRT_USER,MITNBR,MCVCOD,MDCVCOD,CITNBR)       
						values(:arg_SABU,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_ITNBR,:ls_IPHDATE,:ls_IPNO,:ls_IPSOURCE,:ls_IPGUBUN,:ld_IPHQTY,:ld_IPQTY,:ld_IPAMT,
							:ls_IPBAD_CD,:ls_CONFIRM_NO,:ld_IPDAN,:ls_IPDATE,:ls_ORDERNO,:ls_LC_CHA,:ld_LC_CHAQTY,:ld_LC_CHASUM,:ls_LC_NO,:ld_PACKDAN,:ld_PACKQTY,
							:ls_SHOPCODE,:ll_IPSEQ,:ll_SUBSEQ,:ls_FIL,:ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,:ls_MITNBR,:ls_MCVCOD,:ls_MDCVCOD,:ls_citnbr);
//		IF SQLCA.SQLCode = -1 THEN 
//     		MessageBox("SQL error", SQLCA.SQLErrText)
//		END IF
		if sqlca.sqlcode <> 0 then
			
			st_state.Visible = False
			wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
			rollback;
			FileClose(li_FileNum)
			return -3
		end if
//	END IF
	
	
	
	IF ls_IPGUBUN = 'A' AND ld_IPDAN > 0 THEN
		/* 단가 Update *******************************************************************/
		/* 단가이력 등록 수정 - 2006.12.01 - 송병호 */
		/* 단가이력 등록 수정 - 2007.01.11 - 송병호 */

		Select fun_vnddan_danga(:ls_IPDATE, :ls_mitnbr, :ls_mcvcod)
		  Into :ld_price From dual ;
		  
		if ld_price <> ld_IPDAN then
			ls_new = 'Y'
		else
			ls_new = 'N'
		end if

		Select Count(*) Into :ll_cnt From vnddan 
		 Where cvcod = :ls_mcvcod and itnbr = :ls_mitnbr and start_date = :ls_IPDATE ; 
	
		If ll_cnt > 0 Then
			ls_new = 'N'
		end if

		  
//		Select Count(*) Into :ll_cnt From vnddan 
//		 Where cvcod = :ls_mcvcod and itnbr = :ls_mitnbr and start_date = :ls_IPDATE ; 
//	
//		If ll_cnt = 0 Then
//			Select Max(start_date) Into :ls_start_date From vnddan 
//			 Where cvcod = :ls_mcvcod and itnbr = :ls_mitnbr and start_date < :ls_IPDATE ; 
//		
//			if isnull(ls_start_date) then
//				ls_new = 'Y'
//			else
//				Select Nvl(sales_price,0) , Nvl(broad_price,0)
//				  Into :ld_price , :ld_bprice
//				  From vnddan
//				 Where cvcod = :ls_mcvcod 
//					and itnbr = :ls_mitnbr
//					and start_date = :ls_start_date ;
//		
//				if ld_price <> ld_ipdan then
//					ls_new = 'Y'
//				else
//					ls_new = 'N'
//				end if
//		
//			end if
//			
//		Else
//			ls_new = 'N'
//			ls_start_date = ls_IPDATE
//		End If


		If ls_new = 'Y' Then
			
			If ls_factory = 'Y' Then
				Insert Into vnddan ( CVCOD       , ITNBR       , START_DATE  ,                                                      
											END_DATE    , SALES_PRICE , CURR ,
											BROAD_PRICE , BROAD_CURR  ,                                               
											CRT_DATE    , CRT_TIME    , CRT_USER,
											DANGU       , BIGO        )                                                           
								values(  :ls_mcvcod  ,:ls_mitnbr ,:ls_IPDATE ,                                              
											'99991231'  ,:ld_ipdan ,'WON' ,                                                             
											:ld_ipdan   ,'WON' ,                                                     
											:is_today   ,:is_totime , :gs_userid ,
											'1'         ,'0010' ) ; 
			Else
				Insert Into vnddan ( CVCOD       , ITNBR      , START_DATE  ,                                                      
											END_DATE    , SALES_PRICE, CURR ,
											BROAD_PRICE , BROAD_CURR ,                                               
											CRT_DATE    , CRT_TIME   , CRT_USER,
											DANGU       , BIGO         )                                                           
								values(  :ls_mcvcod  , :ls_mitnbr ,:ls_IPDATE ,                                              
											'99991231'  , :ld_ipdan ,'WON' ,                                                             
											0 ,'WON' ,                                                     
											:is_today ,:is_totime , :gs_userid ,
											'1'         ,'0010'  ) ; 
			End if
//		Else
//		
//			If ls_factory = 'Y' and (ld_bprice <> ld_IPDAN ) Then
//			
//					Update vnddan Set broad_price = :ld_ipdan ,
//											broad_curr  = 'WON',
//											upd_date = :is_today ,
//											upd_time = :is_totime ,
//											upd_user = :gs_userid ,
//											Bigo = '0010' 
//									Where cvcod = :ls_mcvcod 
//									  and itnbr = :ls_mitnbr
//									  and start_date = :ls_start_date ;
//			
//			ElseIf ls_factory <> 'Y' and (ld_price <> ld_IPDAN ) Then
//				
//					Update vnddan Set sales_price = :ld_ipdan ,
//											curr  = 'WON',
//											upd_date = :is_today ,
//											upd_time = :is_totime ,
//											upd_user = :gs_userid ,
//											Bigo = '0010' 
//									Where cvcod = :ls_mcvcod 
//									  and itnbr = :ls_mitnbr
//									  and start_date = :ls_start_date ;
//			
//			End if
		End If
	
		If sqlca.sqlcode <> 0 Then
			st_state.Visible = False
			wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,"[단가입력 에러]"+sqlca.sqlerrText)
			rollback;
			FileClose(li_FileNum)
			return -3
		end if
	/*******************************************************************/
	END IF
	
	il_succeed++
	yield()
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt)
Loop

// van file close
FileClose(li_FileNum)


commit;

wf_file_copy(arg_file_name)

st_state.Visible = False
return li_cnt

end function

public function integer wf_van_d68 (string arg_file_name, string arg_sabu);/* 값변환 참조
	{:+0  	}:-0
	A:1  B:2  C:3  D:4  E:5  F:6  G:7  H:8  I:9
	J:-1 K:-2 L:-3 M:-4 N:-5 O:-6 P:-7 Q:-8 R:-9 
	
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수 */	

string ls_Input_Data ,ls_indate
integer li_FileNum,li_cnt,li_rowcnt
Long ll_data = 0 
string ls_DOCCODE,ls_CUSTCD,ls_FACTORY,ls_ITNBR,ls_ORDER_GB,ls_ORDERNO,ls_ORDER_DATE,ls_ORDER_TYPE
string ls_CRT_DATE,ls_CRT_TIME,ls_CRT_USER,ls_FORM_ORDERNO,ls_COUNTRY_CARKIND
string ls_TO_ORDERNO,ls_LOCNO_CKD,ls_YARDNO_CKD,ls_PACKCON_CKD,ls_MITNBR,ls_MCVCOD,ls_MDCVCOD
long  ll_ORDER_TIME,ll_ORDER_MIN,ll_seqno ,ll_check
double  ld_ORDER_QTY,ld_IPDAN,ld_PACKUNI
string ls_CITNBR ,ls_gubun
Long ll_cnt

//현재 일자,시간 
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')

Long ll_p , ll_px
ll_p = LastPos(arg_file_name , '\')
ll_px = LastPos(Upper(arg_file_name) , '.TXT')
ls_gubun = Upper(Mid(arg_file_name , ll_p + 1 , ll_px - ( ll_p + 1 ) ))
li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	return -1
end if

li_cnt = 0

st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	Setnull(ls_citnbr)
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	li_cnt ++
	
	yield()
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt)
	
	ls_doccode = trim(mid(ls_Input_Data,1,12))	
	ls_indate = Trim(dw_ip.Object.jisi_date[1])
//	// 파일 날짜 체크
//	if ls_indate <> Mid(ls_doccode,3,8) then
//		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "파일의 수신일자와 등록일자가 상이합니다.")
//		Continue ;
//	end if	
	if ls_indate <> Mid(ls_doccode,3,8) then
		ls_indate = Mid(ls_doccode,3,8)
	end if
	
	// 화일명의 값과 필드값을 체크
	if upper(left(right(arg_file_name,6),2)) <> upper(left(ls_doccode,2)) then
		rollback;
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,"화일명과 화일의 필드값이 틀립니다.")
		FileClose(li_FileNum)
		return -2
	end if

	ls_custcd = trim(mid(ls_Input_Data,13,4))
	ls_factory = trim(mid(ls_Input_Data,17,2))
	ls_itnbr = trim(mid(ls_Input_Data,19,15))
	ls_order_gb = trim(mid(ls_Input_Data,34,1))
	ls_orderno =  trim(mid(ls_Input_Data,35,11))
	ld_order_qty = wf_van_scan_chk2('1',mid(ls_Input_Data,46,6),mid(ls_Input_Data,52,1))
	ld_ipdan = wf_van_scan_chk2('2',mid(ls_Input_Data,53,8),mid(ls_Input_Data,61,2))
	ls_order_date = trim(mid(ls_Input_Data,63,8))
	ls_order_type = trim(mid(ls_Input_Data,71,1))
	ll_order_time = long(mid(ls_Input_Data,72,2))
	ll_order_min = long(mid(ls_Input_Data,74,2))
	ld_packuni = wf_van_scan_chk2('1',mid(ls_Input_Data,76,5),mid(ls_Input_Data,81,1))
	ls_form_orderno = trim(mid(ls_Input_Data,82,15))
	ls_country_carkind = trim(mid(ls_Input_Data,97,5))
	ls_to_orderno = trim(mid(ls_Input_Data,102,15))
	ls_locno_ckd = trim(mid(ls_Input_Data,117,10))
	ls_yardno_ckd = trim(mid(ls_Input_Data,127,4))
	ls_packcon_ckd = trim(mid(ls_Input_Data,131,3))	
	
	//자체품번 읽어오기(자체거래처코드)
//	select itnbr
//	into :ls_mitnbr
//	from itemas
//	where replace(itnbr,'-','') = :ls_itnbr ;
//	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then

	ls_mitnbr = sqlca.fun_get_buitnbr(ls_itnbr , '') ;	
	if trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then		
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')		
		Continue ;
	End IF
	
	//공장별 거래처 읽어오기
   select fun_get_scvcod( :ls_factory , :ls_mitnbr ,:ls_packcon_ckd  ),
			 nvl(RFNA3,'')
	  Into :ls_mcvcod , :ls_mdcvcod
	  from reffpf 
	where sabu = :arg_sabu and
			rfcod = '2A' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
		il_err++
		Continue ;
	end if
	
	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)

	// D68 에서 중복 스킵
	If Right(ls_gubun,2) = 'D6' Then		
		ll_check = 0 
		
		Select Count(*) Into :ll_check
		  From van_hkcd68
		 Where sabu = :gs_sabu
		   and custcd = :ls_CUSTCD
			and itnbr = :ls_itnbr 
			and factory = :ls_factory
			and order_qty = :ld_ORDER_QTY
			and orderno = :ls_orderno ;			
		If ll_check > 0 Then Continue;			
	End if	
	
	// D68 에서 입고 구분자가 E 인 오더번호는 전오더(15일 이상경과하고 미납처리된 오더)를 마감해야한다.(이중발주)
	If Right(ls_gubun,2) = 'D8' and ls_ORDER_GB = 'E' Then		
		ll_check = 0 
		
		Select Count(*) Into :ll_check
		  From van_hkcd68
		 Where sabu = :gs_sabu
		   and custcd = :ls_CUSTCD
			and itnbr = :ls_itnbr 
			and factory = :ls_factory
			and orderno = :ls_orderno ;

		//D6에 citnbr에 구분채크 안되는거 수정. 2005.04.12. 이수철		
		If ll_check > 0 Then			
			Update van_hkcd68 Set citnbr = '2' 
			                Where sabu = :gs_sabu
									and custcd = :ls_CUSTCD
									and itnbr = :ls_itnbr 
									and factory = :ls_factory
									and orderno = :ls_orderno ;
			
			if sqlca.sqlcode <> 0 then		
				st_state.Visible = False
				wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
				rollback;
				FileClose(li_FileNum)
				return 0
			end if			
		End if

		//출하등록시 List 안보이도록 수정. 2005.04.12. 이수철
		DELETE FROM SM04_DAILY_ITEM WHERE YYMMDD = :ls_crt_date AND BALJU_NO = :ls_orderno ;		
		ls_citnbr = '2'		
	End If
	//===================================================================================================	
	// 한텍 요청 //////////////////////////////////////////////////////
   ll_cnt = 0 
	select count(*) Into :ll_cnt
	  from van_hkcd68
	 where SABU=   :gs_SABU
		and DOCCODE = :ls_DOCCODE   
		and CUSTCD = :ls_CUSTCD  
		and FACTORY = :ls_FACTORY 
		and ITNBR = :ls_ITNBR 
		and ORDERNO = :ls_ORDERNO ;
		
	If ll_cnt > 0 Then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(li_cnt)+']')
		Continue ;
	end if	
/////////////////////////////////////////////////////////	
	ll_data++
	insert into van_hkcd68(SABU,DOCCODE,CUSTCD,FACTORY,ITNBR,ORDER_GB,ORDERNO,ORDER_QTY,IPDAN,ORDER_DATE,ORDER_TYPE,     
								ORDER_TIME,ORDER_MIN,PACKUNI,FORM_ORDERNO,COUNTRY_CARKIND,TO_ORDERNO,LOCNO_CKD,YARDNO_CKD,
								PACKCON_CKD,CRT_DATE,CRT_TIME,CRT_USER,MITNBR,MCVCOD,MDCVCOD,CITNBR,SEQNO,
								BALYN, ORDER_DATE_HANTEC)       
					values(:arg_SABU,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_ITNBR,:ls_ORDER_GB,:ls_ORDERNO,:ld_ORDER_QTY,:ld_IPDAN,:ls_ORDER_DATE,:ls_ORDER_TYPE,
						:ll_ORDER_TIME,:ll_ORDER_MIN,:ld_PACKUNI,:ls_FORM_ORDERNO,:ls_COUNTRY_CARKIND,:ls_TO_ORDERNO,:ls_LOCNO_CKD,:ls_YARDNO_CKD,
						:ls_PACKCON_CKD,:ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,:ls_MITNBR,:ls_MCVCOD,:ls_MDCVCOD,:ls_CITNBR,:ll_seqno,
						NULL, :ls_order_date);
						/*NULL, DECODE(:ls_factory, 'Y', :ls_order_date, NULL) 납기일 수정에서 담당자 결정NULL);*/
						/* 한텍납품일을 고객납품일로 지정 - by shingoon 2013.10.21 (한텍납품일 사용 안함) */
	if sqlca.sqlcode <> 0 then
		
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		return 0
	end if
	il_succeed++ 
Loop

// van file close
FileClose(li_FileNum)

commit;

wf_file_copy(arg_file_name)

st_state.Visible = False
return li_cnt
end function

public function integer wf_van_d9 (string arg_file_name, string arg_sabu);/* 값변환 참조
	{:+0  	}:-0
	A:1  B:2  C:3  D:4  E:5  F:6  G:7  H:8  I:9
	J:-1 K:-2 L:-3 M:-4 N:-5 O:-6 P:-7 Q:-8 R:-9  */
	
/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	


string ls_Input_Data ,ls_indate
integer li_FileNum,li_cnt,li_rowcnt
Long  ll_data = 0
string ls_SABU,ls_DOCCODE,ls_CUSTCD,ls_FACTORY,ls_ITNBR,ls_IPSOURCE,ls_IPGUBUN
double ld_IPTQTY,ld_IPTAMT,ld_PACKTAMT
string ls_CRT_DATE,ls_CRT_TIME,ls_CRT_USER,ls_mcvcod,ls_mdcvcod,ls_mitnbr,ls_citnbr ,ls_gubun
Long 	ll_seqno

Long ll_cnt

//현재 일자,시간 
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')

Long ll_p , ll_px

ll_p = LastPos(arg_file_name , '\')
ll_px = LastPos(Upper(arg_file_name) , '.TXT')

ls_gubun = Upper(Mid(arg_file_name , ll_p + 1 , ll_px - ( ll_p + 1 ) ))

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(ls_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	return -1
end if

li_cnt = 0

st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

/* 일, 월 검수 자료는 매출마감이 되면 받을 수 없음. - 2007.05.05 BY SHINGOON(노상호BJ요청) */
/* 월 검수는 (마감월 + 1) 한 값으로 비교 C로 시작되는 공장코드는 당월 검수자료 받음.         */
/* 6월 마감일 경우 C로 시작되는 공장코드는 6월 검수자료가 접수됨. C공장코드 이외에는 7월접수 */
String ls_magam
SELECT TO_CHAR(TO_DATE(MAX(MAYYMM) + 1, 'YYYYMM'), 'YYYYMM')
  INTO :ls_magam
  FROM SALE_MAGAM;
/*******************************************************************************************/

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100

	
	SetNull(ls_mitnbr)
	SetNull(ls_mcvcod)
	SetNull(ls_mdcvcod)
	SetNull(ls_citnbr)
	
	li_cnt ++
	yield()
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt) 
	
	ls_doccode = trim(mid(ls_Input_Data,1,12))	
	ls_indate = Trim(dw_ip.Object.jisi_date[1])
	// 파일 날짜 체크
//	if ls_indate <> Mid(ls_doccode,3,8) then
//		
//		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "파일의 수신일자와 등록일자가 상이합니다.")
//		Continue ;
//	end if


	// 화일명의 값과 필드값을 체크
	if upper(left(right(arg_file_name,6),2)) <> upper(left(ls_doccode,2)) then
		rollback;
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,'','',"화일명과 화일의 필드값이 틀립니다.")
		FileClose(li_FileNum)
		return -2
	end if

	ls_custcd = trim(mid(ls_Input_Data,13,4))
	ls_factory = trim(mid(ls_Input_Data,17,2))
	ls_itnbr = trim(mid(ls_Input_Data,19,15))
	ls_ipsource = trim(mid(ls_Input_Data,34,1))
	ls_ipgubun = trim(mid(ls_Input_Data,35,2))
	
	If isNull(ls_ipsource)  Or ls_ipsource = "" Then ls_ipsource = "." 
	
	If isNull(ls_ipgubun)  Or ls_ipgubun = "" Then  ls_ipgubun = "." 

	ld_iptqty = wf_van_scan_chk(mid(ls_Input_Data,37,7),mid(ls_Input_Data,44,1))
	ld_iptamt =  wf_van_scan_chk(mid(ls_Input_Data,45,10),mid(ls_Input_Data,55,1))
	ld_packtamt = wf_van_scan_chk(mid(ls_Input_Data,56,9),mid(ls_Input_Data,65,1))
	
	/* 매출마감이 되어 있는 월의 일 검수 자료가 선택될 경우 Return - BY SHINGOON (노상호BJ요청) 2007.05.05 */
   /* 월 검수는 (마감월 + 1) 한 값으로 비교 C로 시작되는 공장코드는 당월 검수자료 받음.         */
   /* 6월 마감일 경우 C로 시작되는 공장코드는 6월 검수자료가 접수됨. C공장코드 이외에는 7월접수 */
	If ls_magam >= MID(ls_doccode, 3, 6) Then
		If LEFT(ls_factory, 1) <> 'C' Then
			ROLLBACK USING SQLCA;
			wf_error(ls_gubun, li_cnt, ls_doccode, '', '', '해당 검수(D9) 자료는 이미 매출마감이 완료된 자료입니다.')
			FileClose(li_FileNum)
			return -2
		End If
	End If
	/********************************************************************************************/	
	
	
	//자체품번 읽어오기(자체거래처코드)
//	select itnbr
//	into :ls_mitnbr
//	from itemas
//	where replace(itnbr,'-','') = :ls_itnbr ;
//	
//	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then

	ls_mitnbr = sqlca.fun_get_buitnbr(ls_itnbr , '') ;
	
	if trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		il_err++
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')
		
		Continue ;
	End IF
	
	//공장별 거래처 읽어오기
   select fun_get_scvcod( :ls_factory , :ls_mitnbr ,''  ),
			 nvl(RFNA3,'')
	  Into :ls_mcvcod , :ls_mdcvcod
	  from reffpf 
	where sabu = :arg_sabu and
			rfcod = '2A' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
		il_err++
		Continue ;
	end if
	
	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
   ll_data++
	
	// 한텍 요청 //////////////////////////////////////////////////////
   ll_cnt = 0 
//-------------------------------------------------------------------------------------------------------------------------------------------------
	/* 거래처/품번에 같은 불량코드(IPSOURCE)값이 2건이상 발생.
	   수량이 서로 다른 자료임.
		같은 불량코드로 다른 반품자료가 등록되면 1건만 등록되고 나머지는 중복으로 나타나서 누락처리 됨.
		중복 확인에 수량도 추가. - BY SHINGOON 2007.08.25
	select count(*) Into :ll_cnt
	  from van_hkcd9
	 where SABU=   :gs_SABU
		and DOCCODE = :ls_DOCCODE   
		and CUSTCD = :ls_CUSTCD  
		and FACTORY = :ls_FACTORY 
		and ITNBR = :ls_ITNBR 
		and IPSOURCE = :ls_ipsource 
		and IPGUBUN = :ls_ipgubun;
	If ll_cnt > 0 Then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(li_cnt)+']')
		Continue ;
	end if */

	//PK 중복 확인
	SELECT COUNT('X')
	  INTO :ll_cnt
	  FROM VAN_HKCD9
	 WHERE SABU     = :gs_sabu
	   AND DOCCODE  = :ls_doccode
		AND CUSTCD   = :ls_custcd
		AND FACTORY  = :ls_factory
		AND ITNBR    = :ls_itnbr
		AND IPSOURCE = :ls_ipsource
		AND IPGUBUN  = :ls_ipgubun ;
		
	If ll_cnt > 0 Then
		//글로비스 2공장일 경우 수량까지 중복 확인
		SetNull(ll_cnt)
		If ls_factory = 'L2' Then
			SELECT COUNT('X')
			  INTO :ll_cnt
			  FROM VAN_HKCD9
			 WHERE SABU     = :gs_sabu
				AND DOCCODE  = :ls_doccode
				AND CUSTCD   = :ls_custcd
				AND FACTORY  = :ls_factory
				AND ITNBR    = :ls_itnbr
				AND IPSOURCE = :ls_ipsource
				AND IPGUBUN  = :ls_ipgubun
				AND IPTQTY   = :ld_iptqty  ;
			If ll_cnt < 1 Then
				UPDATE VAN_HKCD9
				   SET IPTQTY   = IPTQTY   + :ld_iptqty  ,
					    IPTAMT   = IPTAMT   + :ld_iptamt  ,
						 PACKTAMT = PACKTAMT + :ld_packtamt
				 WHERE SABU     = :gs_sabu
					AND DOCCODE  = :ls_doccode
					AND CUSTCD   = :ls_custcd
					AND FACTORY  = :ls_factory
					AND ITNBR    = :ls_itnbr
					AND IPSOURCE = :ls_ipsource
					AND IPGUBUN  = :ls_ipgubun  ;
				If SQLCA.SQLCODE <> 0 Then
					wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
					ROLLBACK USING SQLCA;
					FileClose(li_filenum)
					st_state.Visible = False
					Return -4
				End If
				Continue ;
			End If
		Else
			wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(li_cnt)+']')
			Continue ;
		End If
		
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(li_cnt)+']')
		Continue ;
	end if
//-------------------------------------------------------------------------------------------------------------------------------------------------
	
/////////////////////////////////////////////////////////
	
	insert into van_hkcd9(SABU,DOCCODE,CUSTCD,FACTORY,ITNBR,IPSOURCE,IPGUBUN,IPTQTY,IPTAMT,PACKTAMT,CRT_DATE,CRT_TIME,CRT_USER,CITNBR,
	                                 MITNBR,MCVCOD,MDCVCOD)       
					values(:arg_SABU,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_ITNBR,:ls_IPSOURCE,:ls_IPGUBUN,:ld_IPTQTY,:ld_IPTAMT,:ld_PACKTAMT,:ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,:ls_citnbr,
					           :ls_MITNBR,:ls_MCVCOD,:ls_MDCVCOD);

	if sqlca.sqlcode <> 0 then
		
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		st_state.Visible = False
		return -3
	end if
	il_succeed++


Loop

// van file close
FileClose(li_FileNum)

commit;

wf_file_copy(arg_file_name)

st_state.Visible = False
return li_cnt

end function

public function double wf_van_scan_chk2 (string arg_gubun, string arg_value, string arg_value_1);//정수형
long ll_asc_value
double ld_return_value
if arg_gubun = '1' then
	ll_asc_value = asc(arg_value_1)
	// 'A' ~ 'I'
	if ll_asc_value >= 64 and ll_asc_value <= 73 then
		ld_return_value = double(arg_value) * 10 + ll_asc_value - 64
	// 'J' ~ 'R'
	elseif ll_asc_value >= 74 and ll_asc_value <= 82 then
		ld_return_value = (double(arg_value) * 10 + ll_asc_value - 73) * -1
	// '{'
	elseif ll_asc_value = 123 then
		ld_return_value = double(arg_value) * 10
	// '}'
	elseif ll_asc_value = 125 then
		ld_return_value = double(arg_value) * -10
	else
		ld_return_value = double(arg_value) * 10 + double(arg_value_1)
	end if
//실수형
else 
	ll_asc_value = asc(right(arg_value_1,1))
	// 'A' ~ 'I'
	if ll_asc_value >= 64 and ll_asc_value <= 73 then
		ld_return_value = double(arg_value) + &
								(double(left(arg_value_1,1)) * 0.1) + &
								((ll_asc_value - 64) * 0.01)
	// 'J' ~ 'R'
	elseif ll_asc_value >= 74 and ll_asc_value <= 82 then
		ld_return_value = (double(arg_value) + &
								(double(left(arg_value_1,1)) * 0.1) + &
								((ll_asc_value - 73) * 0.01)) * -1
	// '{'
	elseif ll_asc_value = 123 then
		ld_return_value = (double(arg_value) + &
								(double(left(arg_value_1,1)) * 0.1)) * 1 &
	// '}'
	elseif ll_asc_value = 125 then
		ld_return_value = (double(arg_value) + &
								(double(left(arg_value_1,1)) * 0.1)) * -1  
	else
		ld_return_value = double(arg_value) + (double(arg_value) * 0.01)
	end if
	
end if
	
return ld_return_value
end function

public function long wf_van_p7 (string arg_file_name, string arg_sabu);/* 값변환 참조
	{:+0  	}:-0
	A:1  B:2  C:3  D:4  E:5  F:6  G:7  H:8  I:9
	J:-1 K:-2 L:-3 M:-4 N:-5 O:-6 P:-7 Q:-8 R:-9  */
	
/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	

string ls_Input_Data ,ls_indate
integer li_FileNum,li_cnt,li_rowcnt,li_gubun
Long  ll_data = 0

string ls_SABU,ls_DOCCODE,ls_CUSTCD,ls_FILEID,ls_MANAGEGB,ls_DATAGB,ls_ITEMSER,ls_ITEMNAME,ls_ITEMCODE,ls_FACTORY
long ll_TRIM_RESULT,ll_PBS,ll_PAINT_REJ,ll_WBS,ll_REMAIN_QTY,ll_CONF_TQTY,ll_MITU,ll_PRESEQ,ll_MON_MIJAN,ll_NMON_PRORDER
long ll_MON_TOTAL,ll_RSV,ll_D12SCHED1,ll_D12SCHED2,ll_D12SCHED3,ll_D12SCHED4,ll_D12SCHED5,ll_D12SCHED6,ll_D12SCHED7
long ll_D12SCHED8,ll_D12SCHED9,ll_D12SCHED10,ll_D12SCHED11,ll_D12SCHED12,ll_D12SCHED13     
string ls_MODEL_CODE,ls_CRT_DATE,ls_CRT_TIME,ls_CRT_USER,ls_mcvcod,ls_mdcvcod,ls_mitnbr
string ls_imsi_mcvcod,ls_imsi_mitnbr,ls_citnbr, ls_gubun

String ls_itnbr

//현재 일자,시간 
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')

Long ll_p , ll_px

ll_p = LastPos(arg_file_name , '\')
ll_px = LastPos(Upper(arg_file_name) , '.TXT')

ls_gubun = Upper(Mid(arg_file_name , ll_p + 1 , ll_px - ( ll_p + 1 ) ))

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(ls_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	return -1
end if

li_cnt = 0

st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'
Do While	FileRead(li_FileNum, ls_Input_Data) <> -100

	
	SetNull(ls_mitnbr)
	SetNull(ls_mcvcod)
	SetNull(ls_mdcvcod)
	SetNull(ls_citnbr)
	
	li_cnt ++
	yield()
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt) 
	
	ls_doccode = trim(mid(ls_Input_Data,1,12))
	ls_indate = Trim(dw_ip.Object.jisi_date[1])
	
	// 파일 날짜 체크
	if ls_indate <> Mid(ls_doccode,3,8) then
		
		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "파일의 수신일자와 등록일자가 상이합니다.")
		Continue ;
	end if
	// 화일명의 값과 필드값을 체크
	if upper(left(right(arg_file_name,6),2)) <> upper(left(ls_doccode,2)) then
		rollback;
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,'','',"화일명과 화일의 필드값이 틀립니다.")
		FileClose(li_FileNum)
		return -2
	end if

	ls_custcd = trim(mid(ls_Input_Data,13,4))
	ls_fileid = trim(mid(ls_Input_Data,17,2))
	ls_managegb = trim(mid(ls_Input_Data,19,1))
	ls_datagb = trim(mid(ls_Input_Data,20,1))
	ls_itemser = trim(mid(ls_Input_Data,21,3))
//	ls_itemname = trim(mid(ls_Input_Data,24,19))
	ls_itemname = trim(mid(ls_Input_Data,24,20))
	ls_itemcode = trim(mid(ls_Input_Data,44,15))	
//	ls_itemcode = trim(mid(ls_Input_Data,43,16))
	if ls_itemcode = '' then ls_itemcode = 'T'
	ls_factory = trim(mid(ls_Input_Data,59,2))
	if ls_factory = '21' then ls_factory = '2'
	ll_trim_result = wf_van_scan_chk(mid(ls_Input_Data,61,3),mid(ls_Input_Data,64,1))
	ll_pbs =  wf_van_scan_chk(mid(ls_Input_Data,65,2),mid(ls_Input_Data,67,1))
	ll_paint_rej = wf_van_scan_chk(mid(ls_Input_Data,68,3),mid(ls_Input_Data,71,1))
	ll_wbs = wf_van_scan_chk(mid(ls_Input_Data,72,2),mid(ls_Input_Data,74,1))
	ll_D12SCHED1 = long(mid(ls_Input_Data,75,4))
	ll_D12SCHED2 = long(mid(ls_Input_Data,79,4))
	ll_D12SCHED3 = long(mid(ls_Input_Data,83,4))
	ll_D12SCHED4 = long(mid(ls_Input_Data,87,4))
	ll_D12SCHED5 = long(mid(ls_Input_Data,91,4))
	ll_D12SCHED6 = long(mid(ls_Input_Data,95,4))
	ll_D12SCHED7 = long(mid(ls_Input_Data,99,4))
	ll_D12SCHED8 = long(mid(ls_Input_Data,103,4))
	ll_D12SCHED9 = long(mid(ls_Input_Data,107,4))
	ll_D12SCHED10 = long(mid(ls_Input_Data,111,4))
	ll_D12SCHED11 = long(mid(ls_Input_Data,115,4))
	ll_D12SCHED12 = long(mid(ls_Input_Data,119,4))
	ll_D12SCHED13 = long(mid(ls_Input_Data,123,4))
	ll_remain_qty = wf_van_scan_chk(mid(ls_Input_Data,127,3),mid(ls_Input_Data,130,1))
	ll_conf_tqty = wf_van_scan_chk(mid(ls_Input_Data,131,4),mid(ls_Input_Data,135,1))
	ll_mitu = wf_van_scan_chk(mid(ls_Input_Data,136,3),mid(ls_Input_Data,139,1))
	ll_preseq = wf_van_scan_chk(mid(ls_Input_Data,140,3),mid(ls_Input_Data,143,1))
	ll_mon_mijan = wf_van_scan_chk(mid(ls_Input_Data,144,4),mid(ls_Input_Data,148,1))
	ll_nmon_prorder = wf_van_scan_chk(mid(ls_Input_Data,149,4),mid(ls_Input_Data,153,1))
	ll_mon_total = wf_van_scan_chk(mid(ls_Input_Data,154,4),mid(ls_Input_Data,158,1))
	ls_model_code = trim(mid(ls_Input_Data,159,4))
	ll_rsv = wf_van_scan_chk(mid(ls_Input_Data,163,2),mid(ls_Input_Data,165,1))
	
	ls_itnbr = ls_itemcode
	If ls_itemcode = '' Or isNull(ls_itemcode) Then ls_itemcode = '.'

	
		//공장별 거래처 읽어오기
   select fun_get_scvcod( :ls_factory , :ls_mitnbr ,''  ),
			 nvl(RFNA3,'')
	  Into :ls_mcvcod , :ls_mdcvcod
	  from reffpf 
	where sabu = :arg_sabu and
			rfcod = '2A' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
		il_err++
		Continue ;
	end if
	
	//자체품번 읽어오기(자체거래처코드)
//	select itnbr
//	into :ls_mitnbr
//	from itemas
//	where replace(itnbr,'-','') = :ls_itnbr ;
//	
//	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
//		
//		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')
//		
//		Continue ;
//	End IF
//	
//	ls_mitnbr = trim(ls_mitnbr)
//	ls_mcvcod = trim(ls_mcvcod)
//	ls_mdcvcod = trim(ls_mdcvcod)
//	ls_citnbr = trim(ls_citnbr)
   ll_data++
	
	insert into van_hkcp7(SABU,DOCCODE,CUSTCD,FILEID,MANAGEGB,DATAGB,ITEMSER,ITEMNAME,ITEMCODE,FACTORY,TRIM_RESULT,PBS,PAINT_REJ,WBS,
					D12SCHED1,D12SCHED2,D12SCHED3,D12SCHED4,D12SCHED5,D12SCHED6,D12SCHED7,D12SCHED8,D12SCHED9,D12SCHED10,D12SCHED11,D12SCHED12,
					D12SCHED13,REMAIN_QTY,CONF_TQTY,MITU,PRESEQ,MON_MIJAN,NMON_PRORDER,MON_TOTAL,MODEL_CODE,RSV,CRT_DATE,CRT_TIME,CRT_USER,MITNBR,MCVCOD,MDCVCOD,CITNBR)					
			values(:arg_SABU,:ls_DOCCODE,:ls_CUSTCD,:ls_FILEID,:ls_MANAGEGB,:ls_DATAGB,:ls_ITEMSER,:ls_ITEMNAME,:ls_ITEMCODE,:ls_FACTORY,:ll_TRIM_RESULT,:ll_PBS,:ll_PAINT_REJ,:ll_WBS,
					:ll_D12SCHED1,:ll_D12SCHED2,:ll_D12SCHED3,:ll_D12SCHED4,:ll_D12SCHED5,:ll_D12SCHED6,:ll_D12SCHED7,:ll_D12SCHED8,:ll_D12SCHED9,:ll_D12SCHED10,:ll_D12SCHED11,:ll_D12SCHED12,
					:ll_D12SCHED13,:ll_REMAIN_QTY,:ll_CONF_TQTY,:ll_MITU,:ll_PRESEQ,:ll_MON_MIJAN,:ll_NMON_PRORDER,:ll_MON_TOTAL,:ls_MODEL_CODE,:ll_RSV,:ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,
					:ls_MITNBR,:ls_MCVCOD,:ls_MDCVCOD,:ls_citnbr);
	
	if sqlca.sqlcode <> 0 then
		
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		st_state.Visible = False
		return -3
	end if
	il_succeed++
	

Loop


// van file close
FileClose(li_FileNum)

commit;

wf_file_copy(arg_file_name)

st_state.Visible = False
return li_cnt


end function

public function integer wf_van_d0 (string arg_file_name, string arg_sabu);/* 값변환 참조
	{:+0  	}:-0
	A:1  B:2  C:3  D:4  E:5  F:6  G:7  H:8  I:9
	J:-1 K:-2 L:-3 M:-4 N:-5 O:-6 P:-7 Q:-8 R:-9  
*/
/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	

string ls_Input_Data , ls_indate
integer li_FileNum,li_cnt,li_rowcnt
Long   ll_data = 0 
String ls_SABU,    & 
       ls_DOCCODE, &   
       ls_CUSTCD,  & 
       ls_FACTORY,  & 
       ls_ITNBR,   &
       ls_ITDSC,   &
       ls_UNMSR,   &
       ls_NEWITS,   &
       ls_CARCODE,   &
       ls_CONTAINGU,  & 
       ls_CONTAINQTY , &
       ls_LOCATSITE,   &
       ls_RES_USER,   &
       ls_CONTAINQTY1, &  
       ls_INSPYN,   &
       ls_BALJUGU,   &
       ls_SILGU,   &
       ls_CITNBR,   &
       ls_MITNBR,   &
       ls_MCVCOD,   &
       ls_MDCVCOD,   &
       ls_CRT_DATE,   &
       ls_CRT_TIME,   &
       ls_CRT_USER ,ls_gubun
Double  ld_CONTAINQTY, ld_CONTAINQTY1 

Long ll_cnt

Long ll_p , ll_px

ll_p = LastPos(arg_file_name , '\')
ll_px = LastPos(Upper(arg_file_name) , '.TXT')

ls_gubun = Upper(Mid(arg_file_name , ll_p + 1 , ll_px - ( ll_p + 1 ) ))

//현재 일자,시간 

ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 


li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(ls_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_cnt = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'
Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	ls_citnbr = ''
	li_cnt ++
	
	Yield()
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt)
	
	ls_doccode = trim(mid(ls_Input_Data,1,12))
	ls_indate = Trim(dw_ip.Object.jisi_date[1])
	

//	IF MessageBox("Result", li_cnt, Exclamation!, OKCancel!, 1) = 2 THEN
//	   exit ;
//	ELSE
//		Continue ;
//	END IF
	
	// 파일 날짜 체크
//	if ls_indate <> Mid(ls_doccode,3,8) then
//		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "파일의 수신일자와 등록일자가 상이합니다.")
//		il_err++
//		Continue ;
//	end if
	
	if ls_indate <> Mid(ls_doccode,3,8) then
		ls_indate = Mid(ls_doccode,3,8)
	end if
	
	// 화일명의 값과 필드값을 체크
	if upper(left(right(arg_file_name,6),2)) <> upper(left(ls_doccode,2)) then
		rollback;
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "화일명과 화일의 필드값이 틀립니다.")
		FileClose(li_FileNum)
		return -2
	end if
	
	if len(ls_Input_Data) >= 89 then
		ls_custcd = trim(mid(ls_Input_Data,13,4))
		ls_factory = trim(mid(ls_Input_Data,17,2))
		ls_itnbr = trim(mid(ls_Input_Data,19,15))
		ls_itdsc = trim(mid(ls_Input_Data,34,20))
		ls_unmsr = trim(mid(ls_Input_Data,54,2))
		ls_newits = trim(mid(ls_Input_Data,56,4))
		ls_carcode = trim(mid(ls_Input_Data,60,2))
		ls_CONTAINGU = trim(mid(ls_Input_Data,62,7))
		ld_CONTAINQTY = wf_van_scan_chk2('1',mid(ls_Input_Data,69,4),mid(ls_Input_Data,73,1))
		ls_LOCATSITE  = trim(mid(ls_Input_Data,74,6))
		ls_RES_USER   = trim(mid(ls_Input_Data,80,2))
		ld_CONTAINQTY1   = wf_van_scan_chk2('1',mid(ls_Input_Data,82,4),mid(ls_Input_Data,86,1))
		ls_INSPYN = trim(mid(ls_Input_Data,87,1))
		ls_BALJUGU = trim(mid(ls_Input_Data,88,1))
		ls_SILGU = trim(mid(ls_Input_Data,89,1))
	else
		ls_custcd = trim(mid(ls_Input_Data,13,4))
		ls_factory = trim(mid(ls_Input_Data,17,2))
		ls_itnbr = trim(mid(ls_Input_Data,19,15))
		ls_itdsc = trim(mid(ls_Input_Data,34,20))
		ls_unmsr = trim(mid(ls_Input_Data,54,2))
		ls_newits = trim(mid(ls_Input_Data,56,4))
		ls_carcode = trim(mid(ls_Input_Data,60,2))
		ls_CONTAINGU = trim(mid(ls_Input_Data,62,6))
		ld_CONTAINQTY = wf_van_scan_chk2('1',mid(ls_Input_Data,68,4),mid(ls_Input_Data,72,1))
		ls_LOCATSITE  = trim(mid(ls_Input_Data,73,6))
		ls_RES_USER   = trim(mid(ls_Input_Data,79,2))
		ld_CONTAINQTY1   = wf_van_scan_chk2('1',mid(ls_Input_Data,81,4),mid(ls_Input_Data,85,1))
		ls_INSPYN = trim(mid(ls_Input_Data,86,1))
		ls_BALJUGU = trim(mid(ls_Input_Data,87,1))
		ls_SILGU = trim(mid(ls_Input_Data,88,1))
	end if
	
	
	//자체품번 읽어오기(자체거래처코드)
//	select itnbr
//	into :ls_mitnbr
//	from itemas
//	where replace(itnbr,'-','') = :ls_itnbr ;
	
//		If len(trim(ls_itnbr)) < 10 then
//			ls_mitnbr = ls_itnbr
//		else
//			ls_mitnbr = trim(left(ls_itnbr,5))+'-'+trim(mid(ls_itnbr,6,20))
//		end if
//			
//		If wf_itnbr_insert( ls_mitnbr , ls_itdsc ) < 0 Then
//			wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')
//			il_err++
//			continue ;
//		else
//			
//			wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번을 임시로 생성하였습니다.')
//		end if

	ls_mitnbr = sqlca.fun_get_buitnbr(ls_itnbr , '') ;
	
	if trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		ls_mitnbr = trim(left(ls_itnbr,5))+'-'+trim(mid(ls_itnbr,6))
		
		If wf_itnbr_insert( ls_mitnbr , ls_itdsc ) < 0 Then
			wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')
			il_err++
			continue ;
		else
			wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번을 임시로 생성하였습니다.')
		end if
		
	End IF
	
	
//공장별 거래처 읽어오기
   select fun_get_scvcod( :ls_factory , :ls_mitnbr ,:ls_newits  ),
			 nvl(RFNA3,'')
	  Into :ls_mcvcod , :ls_mdcvcod
	  from reffpf 
	where sabu = :arg_sabu and
			rfcod = '2A' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
		il_err++
		Continue ;
	end if

	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
	
	ll_data++
	
//	MESSAGEBOX('',STRING(LL_DATA) )

// 한텍 요청 //////////////////////////////////////////////////////
   ll_cnt = 0 
	select count(*) Into :ll_cnt
	  from van_hkcd0
	 where SABU=   :gs_SABU
		and DOCCODE = :ls_DOCCODE   
		and CUSTCD = :ls_CUSTCD  
		and FACTORY = :ls_FACTORY 
		and ITNBR = :ls_ITNBR ;
	
	If ll_cnt > 0 Then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(li_cnt)+']')
		Continue ;
	end if
/////////////////////////////////////////////////////////

	insert into van_hkcd0(	SABU,   
									DOCCODE,   
									CUSTCD,   
									FACTORY,   
									ITNBR,   
									ITDSC,   
									UNMSR,   
									NEWITS,   
									CARCODE,   
									CONTAINGU,   
									CONTAINQTY,   
									LOCATSITE,   
									RES_USER,   
									CONTAINQTY1,   
									INSPYN,   
									BALJUGU,   
									SILGU,   
									CITNBR,   
									MITNBR,   
									MCVCOD,   
									MDCVCOD,   
									CRT_DATE,   
									CRT_TIME,   
									CRT_USER  )
					values(		:gs_SABU,    
									:ls_DOCCODE,  
									:ls_CUSTCD,  
								   :ls_FACTORY,  
									:ls_ITNBR, 
									:ls_ITDSC,  
									:ls_UNMSR,   
									:ls_NEWITS,  
									:ls_CARCODE,  
								   :ls_CONTAINGU,  
									:ld_CONTAINQTY ,
									:ls_LOCATSITE,  
									:ls_RES_USER,  
									:ld_CONTAINQTY1,
								   :ls_INSPYN,  
									:ls_BALJUGU,   
									:ls_SILGU,  
									:ls_CITNBR,  
									:ls_MITNBR,   
									:ls_MCVCOD,  
									:ls_MDCVCOD,  
									:ls_CRT_DATE,  
									:ls_CRT_TIME,  
									:ls_CRT_USER ) ; 

	if sqlca.sqlcode <> 0 then
	 
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
		Rollback;
		FileClose(li_FileNum)
		return -3
	end if
	il_succeed++

	
Loop

// van file close
FileClose(li_FileNum)

commit;

wf_file_copy(arg_file_name)
	

st_state.Visible = False
return li_cnt

end function

public function integer wf_van_gi (string arg_file_name, string arg_sabu);/* 값변환 참조
	{:+0  	}:-0
	A:1  B:2  C:3  D:4  E:5  F:6  G:7  H:8  I:9
	J:-1 K:-2 L:-3 M:-4 N:-5 O:-6 P:-7 Q:-8 R:-9  */
	
/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	

string ls_Input_Data  
integer li_FileNum,li_cnt,li_rowcnt , li_file_rtn 
Long  ll_data = 0

String ls_SABU,    &
       ls_CUSTCD,   &
       ls_CARDEX,   &
       ls_FACTORY,   &
       ls_ITNBR,    &
       ls_ORDER_DATE  
Long   ll_ORDER_TIME,   &
       ll_ORDER_MIN,   &
       ll_ORDER_QTY 
String ls_ORDERNO,   &
       ls_BAL_DATE
Long   ll_SUSIN
String ls_ORDER_GB, &  
       ls_GATE_NO
Long   ll_FEEDER
String ls_CRT_DATE,  & 
       ls_CRT_TIME,   &
       ls_CRT_USER,   &
       ls_CITNBR,   &
       ls_MITNBR,   &
       ls_MCVCOD ,ls_mdcvcod , ls_gubun
		 
Long ll_cnt


//현재 일자,시간 
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid

Long ll_p , ll_px

ll_p = LastPos(arg_file_name , '\')
ll_px = LastPos(Upper(arg_file_name) , '.TXT')

ls_gubun = Upper(Mid(arg_file_name , ll_p + 1 , ll_px - ( ll_p + 1 ) ))

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(ls_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	return -1
end if

li_cnt = 0

st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100

	SetNull(ls_mitnbr)
	SetNull(ls_mcvcod)
	SetNull(ls_mdcvcod)
	SetNull(ls_citnbr)
	
	li_cnt ++
	
	yield()
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt) 
	
	ls_CUSTCD = Trim(Mid(ls_Input_Data,1,4))
	ls_CARDEX = Trim(Mid(ls_Input_Data,5,2))
	ls_FACTORY = Trim(Mid(ls_Input_Data,7,2))
	ls_ITNBR = Trim(Mid(ls_Input_Data,9,15))
	ls_ORDER_DATE = Trim(Mid(ls_Input_Data,24,8))
	ll_ORDER_TIME= Long(Trim(Mid(ls_Input_Data,32,2)))
	ll_ORDER_MIN= Long(Trim(Mid(ls_Input_Data,34,2)))
	ll_ORDER_QTY= Long(Trim(Mid(ls_Input_Data,36,9)))
	ls_ORDERNO= Trim(Mid(ls_Input_Data,45,11))
	ls_BAL_DATE= Trim(Mid(ls_Input_Data,56,8))
	ll_SUSIN= Long(Trim(Mid(ls_Input_Data,64,1)))
	ls_ORDER_GB= Trim(Mid(ls_Input_Data,65,1))
	ls_GATE_NO= Trim(Mid(ls_Input_Data,66,4))
	ll_FEEDER= Long(Trim(Mid(ls_Input_Data,70,2)))
  
	
	//자체품번 읽어오기(자체거래처코드)
//	select itnbr
//	into :ls_mitnbr
//	from itemas
//	where replace(itnbr,'-','') = :ls_itnbr ;
//	
//	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
	ls_mitnbr = sqlca.fun_get_buitnbr(ls_itnbr , '') ;
	
	if trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		wf_error(ls_gubun,li_cnt,ls_gubun,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')
		
		Continue ;
	End IF
	
	//공장별 거래처 읽어오기
   select fun_get_scvcod( :ls_factory , :ls_mitnbr ,''  ),
			 nvl(RFNA3,'')
	  Into :ls_mcvcod , :ls_mdcvcod
	  from reffpf 
	where sabu = :arg_sabu and
			rfcod = '2A' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(ls_gubun,li_cnt,ls_gubun,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
		
		Continue ;
	end if
	
	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
   ll_data++
	
	
		// 한텍 요청 //////////////////////////////////////////////////////
   ll_cnt = 0 
	select count(*) Into :ll_cnt
	  from van_gingub
	 where SABU=   :gs_SABU
		and CUSTCD = :ls_CUSTCD  
		and CARDEX = :ls_CARDEX   
		and FACTORY = :ls_FACTORY 
		and ITNBR = :ls_ITNBR 
		and ORDERNO = :ls_ORDERNO ;
		
	If ll_cnt > 0 Then
		wf_error(ls_gubun,li_cnt,ls_CARDEX,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(li_cnt)+']')
		Continue ;
	end if
	
/////////////////////////////////////////////////////////

	insert into van_gingub( SABU,   
									CUSTCD,   
									CARDEX,   
									FACTORY,   
									ITNBR,   
									ORDER_DATE,   
									ORDER_TIME,   
									ORDER_MIN,   
									ORDER_QTY,   
									ORDERNO,   
									BAL_DATE,   
									SUSIN,   
									ORDER_GB,   
									GATE_NO,   
									FEEDER,   
									CRT_DATE,   
									CRT_TIME,   
									CRT_USER,   
									CITNBR,   
									MITNBR,   
									MCVCOD,   
									MDCVCOD )      
						 values( :arg_SABU,  
       							:ls_CUSTCD,   
									:ls_CARDEX,  
									:ls_FACTORY, 
									:ls_ITNBR,   
									:ls_ORDER_DATE , 
									:ll_ORDER_TIME,   
								   :ll_ORDER_MIN,   
									:ll_ORDER_QTY ,
								   :ls_ORDERNO,  
								   :ls_BAL_DATE,  
									:ll_SUSIN,
								   :ls_ORDER_GB, 
									:ls_GATE_NO,   
									:ll_FEEDER ,
								   :ls_CRT_DATE,  
									:ls_CRT_TIME,  
									:ls_CRT_USER, 
									:ls_CITNBR,  
									:ls_MITNBR,   
									:ls_MCVCOD,
									:ls_mdcvcod);
	
	if sqlca.sqlcode <> 0 then
		
		
		wf_error(ls_gubun,li_cnt,ls_gubun,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		st_state.Visible = False
		return -3
	end if
	il_succeed++


Loop


// van file close
FileClose(li_FileNum)

commit;

wf_file_copy(arg_file_name)

st_state.Visible = False
return li_cnt

end function

public function integer wf_van_dh (string arg_file_name, string arg_sabu);/* 값변환 참조
	{:+0  	}:-0
	A:1  B:2  C:3  D:4  E:5  F:6  G:7  H:8  I:9
	J:-1 K:-2 L:-3 M:-4 N:-5 O:-6 P:-7 Q:-8 R:-9  */
	
/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	

string ls_Input_Data ,ls_indate
integer li_FileNum,li_cnt,li_rowcnt 
Long   ll_data = 0 

String ls_SABU,   &
       ls_DOCCODE,   &
       ls_CUSTCD,   &
       ls_FACTORY,   &
       ls_CARCODE,  & 
       ls_UPITNBR,  & 
       ls_JRCODE,  & 
       ls_ITNBR,   &
       ls_SHOP_1,  & 
       ls_LINE_1,   &
       ls_OPSEQ_1,  & 
       ls_RACK_1,  & 
       ls_HOUSE_LOT_1,   &
       ls_SHOP_2, &  
       ls_LINE_2,  & 
       ls_OPSEQ_2,  & 
       ls_RACK_2,   &
       ls_HOUSE_LOT_2,   &
       ls_GL_OUTMARK,  & 
       ls_IN_DATE,  & 
       ls_OUT_DATE,   &
       ls_CARNAME,   &
       ls_JR_CDATE_1, &   
       ls_LOT_CDATE,   &
       ls_JR_CDATE_2,   &
       ls_RACK_CDATE,  & 
       ls_kname,  & 		 
       ls_lane,  & 		 
       ls_prono,  & 		 
       ls_alccode,  & 		 		 
       ls_CRT_DATE,   &
       ls_CRT_TIME,   &
       ls_CRT_USER,   &
       ls_CITNBR,   &
       ls_MITNBR,   &
       ls_MCVCOD,   &
       ls_MDCVCOD , ls_gubun
		 
String ls_tt

//현재 일자,시간 

ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid 

Long ll_p , ll_px

ll_p = LastPos(arg_file_name , '\')
ll_px = LastPos(Upper(arg_file_name) , '.TXT')

ls_gubun = Upper(Mid(arg_file_name , ll_p + 1 , ll_px - ( ll_p + 1 ) ))

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(ls_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	FileClose(li_FileNum)
	return -1
end if

li_cnt = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'


Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	
	if len(ls_Input_Data) < 20 then continue ;
	
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	ls_citnbr = ''
	li_cnt ++
	
	yield()
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt)
	
	ls_doccode = trim(mid(ls_Input_Data,1,12))
	
	ls_indate = Trim(dw_ip.Object.jisi_date[1])

	// 파일 날짜 체크
//	if ls_indate <> Mid(ls_doccode,3,8) then
//	
//		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "파일의 수신일자와 등록일자가 상이합니다.")
//		Continue ;
//	end if
	
	if ls_indate <> Mid(ls_doccode,3,8) then
		ls_indate = Mid(ls_doccode,3,8)
	end if
	
	
	// 화일명의 값과 필드값을 체크
	if upper(left(right(arg_file_name,6),2)) <> upper(left(ls_doccode,2)) then
		rollback;
		st_state.Visible = False
		
		//MessageBox( '' ,ls_doccode  +' | '+  upper(left(right(arg_file_name,6),2)) +' | '+ upper(left(ls_doccode,2)) )
		
		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "화일명과 화일의 필드값이 틀립니다.")
		FileClose(li_FileNum)
		return -2
	end if

   ls_CUSTCD  = Trim(Mid(ls_Input_Data,13,4))
   ls_FACTORY = Trim(Mid(ls_Input_Data,17,2))
   ls_CARCODE = Trim(Mid(ls_Input_Data,19,2))
   ls_UPITNBR = Trim(Mid(ls_Input_Data,21,4))
   ls_JRCODE  = Trim(Mid(ls_Input_Data,25,4))
   ls_ITNBR   = Trim(Mid(ls_Input_Data,29,15))
   ls_SHOP_1  = Trim(Mid(ls_Input_Data,44,1))
   ls_LINE_1  = Trim(Mid(ls_Input_Data,45,1))
   ls_OPSEQ_1 = Trim(Mid(ls_Input_Data,46,4))
   ls_RACK_1  = Trim(Mid(ls_Input_Data,50,3))
   ls_HOUSE_LOT_1 = Trim(Mid(ls_Input_Data,53,4))
   ls_SHOP_2      = Trim(Mid(ls_Input_Data,57,1))
   ls_LINE_2      = Trim(Mid(ls_Input_Data,58,1))
   ls_OPSEQ_2     = Trim(Mid(ls_Input_Data,59,4))
   ls_RACK_2      = Trim(Mid(ls_Input_Data,63,3))
   ls_HOUSE_LOT_2 = Trim(Mid(ls_Input_Data,66,4))
   ls_GL_OUTMARK  = Trim(Mid(ls_Input_Data,70,1))
   ls_IN_DATE     = Trim(Mid(ls_Input_Data,71,6))
   ls_OUT_DATE    = Trim(Mid(ls_Input_Data,77,6))
   ls_CARNAME     = Trim(Mid(ls_Input_Data,83,20))
   ls_JR_CDATE_1  = Trim(Mid(ls_Input_Data,103,8))
   ls_LOT_CDATE   = Trim(Mid(ls_Input_Data,111,8))
   ls_JR_CDATE_2  = Trim(Mid(ls_Input_Data,119,8))
   ls_RACK_CDATE  = Trim(Mid(ls_Input_Data,127,8))
   ls_kname		   = Trim(Mid(ls_Input_Data,135,20))	
   ls_lane		   = Trim(Mid(ls_Input_Data,155,16))	 
   ls_prono		   = Trim(Mid(ls_Input_Data,171,75))	 
   ls_alccode	   = Trim(Mid(ls_Input_Data,246,60))
	ls_tt	         = Trim(Mid(ls_Input_Data,306,2))
	
	//자체품번 읽어오기(자체거래처코드)
//	select itnbr 
//	into :ls_mitnbr 
//	from itemas
//	where replace(itnbr,'-','') = :ls_itnbr ;
//	
//	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
//		If len(trim(ls_itnbr)) < 10 then
//			ls_mitnbr = ls_itnbr
//		else
//			ls_mitnbr = trim(left(ls_itnbr,5))+'-'+trim(mid(ls_itnbr,6,20))
//		end if
//			
//		If wf_itnbr_insert( ls_mitnbr , "임시등록" ) < 0 Then
//			wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')
//			il_err++
//			continue ;
//		else
//			
//			wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번을 임시로 생성하였습니다.')
//		end if

	ls_mitnbr = sqlca.fun_get_buitnbr(ls_itnbr , '') ;
	
	if trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		ls_mitnbr = trim(left(ls_itnbr,5))+'-'+trim(mid(ls_itnbr,6))
		
		If wf_itnbr_insert( ls_mitnbr , '' ) < 0 Then
			wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')
			il_err++
			continue ;
		else
			wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번을 임시로 생성하였습니다.')
		end if
	End IF
	
	//공장별 거래처 읽어오기
   select fun_get_scvcod( :ls_factory , :ls_mitnbr ,''  ),
			 nvl(RFNA3,'')
	  Into :ls_mcvcod , :ls_mdcvcod
	  from reffpf 
	where sabu = :arg_sabu and
			rfcod = '2A' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
		il_err++
		Continue ;
	end if

	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
	
	ll_data++
	
	
	insert into van_hkcdh(	SABU,   
									DOCCODE,   
									CUSTCD,   
									FACTORY,   
									CARCODE,   
									UPITNBR,   
									JRCODE,   
									ITNBR,   
									SHOP_1,   
									LINE_1,   
									OPSEQ_1,   
									RACK_1,   
									HOUSE_LOT_1,   
									SHOP_2,   
									LINE_2,   
									OPSEQ_2,   
									RACK_2,   
									HOUSE_LOT_2,   
									GL_OUTMARK,   
									IN_DATE,   
									OUT_DATE,   
									CARNAME,   
									JR_CDATE_1,   
									LOT_CDATE,   
									JR_CDATE_2,   
									RACK_CDATE, 
									kname,
									lane,
									prono,
									alccode,
									CRT_DATE,   
									CRT_TIME,   
									CRT_USER,   
									CITNBR,   
									MITNBR,   
									MCVCOD,   
									MDCVCOD   )
					values(		:gs_SABU,    
									 :ls_DOCCODE,  
									 :ls_CUSTCD,   
									 :ls_FACTORY,   
									 :ls_CARCODE,  
									 :ls_UPITNBR,  
									 :ls_JRCODE,   
									 :ls_ITNBR,   
									 :ls_SHOP_1,   
									 :ls_LINE_1,   
									 :ls_OPSEQ_1,  
									 :ls_RACK_1,   
									 :ls_HOUSE_LOT_1,   
									 :ls_SHOP_2,   
									 :ls_LINE_2,   
									 :ls_OPSEQ_2, 
									 :ls_RACK_2,  
									 :ls_HOUSE_LOT_2,   
									 :ls_GL_OUTMARK, 
									 :ls_IN_DATE,  
									 :ls_OUT_DATE,   
									 :ls_CARNAME,   
									 :ls_JR_CDATE_1,   
									 :ls_LOT_CDATE,   
									 :ls_JR_CDATE_2,  
									 :ls_RACK_CDATE,   
									 :ls_kname,
									 :ls_lane,
									 :ls_prono,
									 :ls_alccode,
									 :ls_CRT_DATE,  
									 :ls_CRT_TIME,   
									 :ls_CRT_USER,   
									 :ls_CITNBR,   
									 :ls_MITNBR,   
									 :ls_MCVCOD,   
									 :ls_MDCVCOD ) ;

	IF SQLCA.SQLCode <> 0 THEN 
		MessageBox("SQL error", SQLCA.SQLErrText)
	END IF
	if sqlca.sqlcode <> 0 then
		rollback;
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,"자료가 존재하거나 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
		FileClose(li_FileNum)
		return -3
	end if
	
	il_succeed++

	
Loop

// van file close
FileClose(li_FileNum)

commit;

wf_file_copy(arg_file_name)

st_state.Visible = False
return li_cnt

end function

public function integer wf_van_p6 (string arg_file_name, string arg_sabu);/* 값변환 참조
	{:+0  	}:-0
	A:1  B:2  C:3  D:4  E:5  F:6  G:7  H:8  I:9
	J:-1 K:-2 L:-3 M:-4 N:-5 O:-6 P:-7 Q:-8 R:-9  */
	
/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	

string ls_Input_Data ,ls_indate
integer li_FileNum,li_cnt,li_rowcnt,li_gubun
Long  ll_data = 0

string ls_SABU,ls_DOCCODE,ls_CUSTCD,ls_FILEID,ls_MANAGEGB,ls_DATAGB,ls_ITEMSER,ls_ITEMNAME,ls_ITEMCODE,ls_FACTORY
long ll_TRIM_RESULT,ll_PBS,ll_PAINT_REJ,ll_WBS
  
Long ll_D_SCH1	 , ll_D_SCH2  , ll_D_SCH3	, ll_D_SCH4  , ll_D_SCH5  , ll_D_SCH6  , ll_D_SCH7	 , ll_D_SCH8  , ll_D_SCH9	, ll_D_SCH10    ,ll_DSCHED_TOT      
Long ll_D1_SCH1 , ll_D1_SCH2 , ll_D1_SCH3 , ll_D1_SCH4 , ll_D1_SCH5 , ll_D1_SCH6 , ll_D1_SCH7 , ll_D1_SCH8 , ll_D1_SCH9 , ll_D1_SCH10  
Long ll_D2_SCH1 , ll_D2_SCH2 , ll_D2_SCH3 , ll_D2_SCH4 , ll_D2_SCH5 , ll_D2_SCH6 , ll_D2_SCH7 , ll_D2_SCH8 , ll_D2_SCH9 , ll_D2_SCH10  
Long ll_D3_SCH1 , ll_D3_SCH2 , ll_D3_SCH3 , ll_D3_SCH4 , ll_D3_SCH5 , ll_D3_SCH6 , ll_D3_SCH7 , ll_D3_SCH8 , ll_D3_SCH9 , ll_D3_SCH10 
Long ll_D4_SCH1 , ll_D4_SCH2 , ll_D4_SCH3 , ll_D4_SCH4 , ll_D4_SCH5 , ll_D4_SCH6 , ll_D4_SCH7 , ll_D4_SCH8 , ll_D4_SCH9 , ll_D4_SCH10  

long ll_REMAIN_QTY,ll_CONF_TQTY 
string ls_MODEL_CODE,ls_RSV ,ls_CRT_DATE,ls_CRT_TIME,ls_CRT_USER,ls_CITNBR, ls_MITNBR,ls_MCVCOD,ls_MDCVCOD  
string ls_gubun
String ls_itnbr

//현재 일자,시간 
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')

Long ll_p , ll_px

ll_p = LastPos(arg_file_name , '\')
ll_px = LastPos(Upper(arg_file_name) , '.TXT')

ls_gubun = Upper(Mid(arg_file_name , ll_p + 1 , ll_px - ( ll_p + 1 ) ))

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(ls_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	return -1
end if

li_cnt = 0

st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100

	
	SetNull(ls_mitnbr)
	SetNull(ls_mcvcod)
	SetNull(ls_mdcvcod)
	SetNull(ls_citnbr)
	
	li_cnt ++
	yield()
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt) 
	
	ls_doccode = trim(mid(ls_Input_Data,1,12))
	ls_indate = Trim(dw_ip.Object.jisi_date[1])
//	// 파일 날짜 체크
//	if ls_indate <> Mid(ls_doccode,3,8) then
//	
//		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "파일의 수신일자와 등록일자가 상이합니다.")
//		Continue ;
//	end if

	if ls_indate <> Mid(ls_doccode,3,8) then
		ls_indate = Mid(ls_doccode,3,8)
	end if
	// 화일명의 값과 필드값을 체크
	if upper(left(right(arg_file_name,6),2)) <> upper(left(ls_doccode,2)) then
		rollback;
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,'','',"화일명과 화일의 필드값이 틀립니다.")
		FileClose(li_FileNum)
		return -2
	end if

	ls_custcd = trim(mid(ls_Input_Data,13,4))
	ls_fileid = trim(mid(ls_Input_Data,17,2))
	ls_managegb = trim(mid(ls_Input_Data,19,1))
	ls_datagb = trim(mid(ls_Input_Data,20,1))
	ls_itemser = trim(mid(ls_Input_Data,21,3))
//	ls_itemname = trim(mid(ls_Input_Data,24,19))
	ls_itemname = trim(mid(ls_Input_Data,24,20))
	ls_itemcode = trim(mid(ls_Input_Data,44,15))	
//	ls_itemcode = trim(mid(ls_Input_Data,43,16))
	if ls_itemcode = '' then ls_itemcode = 'T'
	ls_factory = trim(mid(ls_Input_Data,59,2))
	if ls_factory = '21' then ls_factory = '2'	
	ll_trim_result = wf_van_scan_chk(mid(ls_Input_Data,61,3),mid(ls_Input_Data,64,1))
	ll_pbs =  wf_van_scan_chk(mid(ls_Input_Data,65,2),mid(ls_Input_Data,67,1))
	ll_paint_rej = wf_van_scan_chk(mid(ls_Input_Data,68,3),mid(ls_Input_Data,71,1))
	ll_wbs = wf_van_scan_chk(mid(ls_Input_Data,72,2),mid(ls_Input_Data,74,1))
	
	ll_D_SCH1	= Long(Mid(ls_Input_Data,75,3))       
	ll_D_SCH2	= Long(Mid(ls_Input_Data,78,3))       
	ll_D_SCH3	= Long(Mid(ls_Input_Data,81,3))       
	ll_D_SCH4   = Long(Mid(ls_Input_Data,84,3)) 
	ll_D_SCH5	= Long(Mid(ls_Input_Data,87,3))       
	ll_D_SCH6   = Long(Mid(ls_Input_Data,90,3)) 
	ll_D_SCH7	= Long(Mid(ls_Input_Data,93,3))       
	ll_D_SCH8   = Long(Mid(ls_Input_Data,96,3)) 
	ll_D_SCH9	= Long(Mid(ls_Input_Data,99,3))       
	ll_D_SCH10  = Long(Mid(ls_Input_Data,102,3)) 
																				
	ll_DSCHED_TOT   = Long(Mid(ls_Input_Data,105,4)) 
																				
	ll_D1_SCH1	= Long(Mid(ls_Input_Data,109,3))       
	ll_D1_SCH2  = Long(Mid(ls_Input_Data,112,3)) 
	ll_D1_SCH3  = Long(Mid(ls_Input_Data,115,3)) 
	ll_D1_SCH4  = Long(Mid(ls_Input_Data,118,3)) 
	ll_D1_SCH5  = Long(Mid(ls_Input_Data,121,3)) 
	ll_D1_SCH6  = Long(Mid(ls_Input_Data,124,3)) 
	ll_D1_SCH7  = Long(Mid(ls_Input_Data,127,3)) 
	ll_D1_SCH8  = Long(Mid(ls_Input_Data,130,3)) 
	ll_D1_SCH9  = Long(Mid(ls_Input_Data,133,3)) 
	ll_D1_SCH10 = Long(Mid(ls_Input_Data,136,3)) 
																		 
	ll_D2_SCH1  = Long(Mid(ls_Input_Data,139,3))       
	ll_D2_SCH2  = Long(Mid(ls_Input_Data,142,3)) 
	ll_D2_SCH3  = Long(Mid(ls_Input_Data,145,3)) 
	ll_D2_SCH4  = Long(Mid(ls_Input_Data,148,3)) 
	ll_D2_SCH5  = Long(Mid(ls_Input_Data,151,3)) 
	ll_D2_SCH6  = Long(Mid(ls_Input_Data,154,3)) 
	ll_D2_SCH7  = Long(Mid(ls_Input_Data,157,3)) 
	ll_D2_SCH8  = Long(Mid(ls_Input_Data,160,3)) 
	ll_D2_SCH9  = Long(Mid(ls_Input_Data,163,3)) 
	ll_D2_SCH10 = Long(Mid(ls_Input_Data,166,3)) 
																				
	ll_D3_SCH1  = Long(Mid(ls_Input_Data,169,3))       
	ll_D3_SCH2  = Long(Mid(ls_Input_Data,172,3)) 
	ll_D3_SCH3  = Long(Mid(ls_Input_Data,175,3)) 
	ll_D3_SCH4  = Long(Mid(ls_Input_Data,178,3)) 
	ll_D3_SCH5  = Long(Mid(ls_Input_Data,181,3)) 
	ll_D3_SCH6  = Long(Mid(ls_Input_Data,184,3)) 
	ll_D3_SCH7  = Long(Mid(ls_Input_Data,187,3)) 
	ll_D3_SCH8  = Long(Mid(ls_Input_Data,190,3)) 
	ll_D3_SCH9  = Long(Mid(ls_Input_Data,193,3)) 
	ll_D3_SCH10 = Long(Mid(ls_Input_Data,196,3)) 
																				
	ll_D4_SCH1  = Long(Mid(ls_Input_Data,199,3))       
	ll_D4_SCH2  = Long(Mid(ls_Input_Data,202,3)) 
	ll_D4_SCH3  = Long(Mid(ls_Input_Data,205,3)) 
	ll_D4_SCH4  = Long(Mid(ls_Input_Data,208,3)) 
	ll_D4_SCH5  = Long(Mid(ls_Input_Data,211,3)) 
	ll_D4_SCH6  = Long(Mid(ls_Input_Data,214,3)) 
	ll_D4_SCH7  = Long(Mid(ls_Input_Data,217,3)) 
	ll_D4_SCH8  = Long(Mid(ls_Input_Data,220,3)) 
	ll_D4_SCH9  = Long(Mid(ls_Input_Data,223,3)) 
	ll_D4_SCH10 = Long(Mid(ls_Input_Data,226,3)) 
	
	ll_REMAIN_QTY = Long(Mid(ls_Input_Data,229,6)) 
	ll_CONF_TQTY  = Long(Mid(ls_Input_Data,235,6)) 
	
	ls_MODEL_CODE	= trim(mid(ls_Input_Data,241,4))
	ls_RSV         = trim(mid(ls_Input_Data,245,3))
	
	ls_itnbr = ls_itemcode
	
	If ls_itemcode = '' Or isNull(ls_itemcode) Then ls_itemcode = '.'
	

	//공장별 거래처 읽어오기
   select fun_get_scvcod( :ls_factory , :ls_mitnbr ,''  ),
			 nvl(RFNA3,'')
	  Into :ls_mcvcod , :ls_mdcvcod
	  from reffpf 
	where sabu = :arg_sabu and
			rfcod = '2A' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
		il_err++
		Continue ;
	end if
	
	//자체품번 읽어오기(자체거래처코드)
//	select itnbr
//	into :ls_mitnbr
//	from itemas
//	where replace(itnbr,'-','') = :ls_itnbr ;
//	
//	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
//		
//		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')
//		
//		Continue ;
//	End IF
//	
//	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
//	ls_mdcvcod = trim(ls_mdcvcod)
//	ls_citnbr = trim(ls_citnbr)
   ll_data++

	
	insert into van_hkcp6(  SABU,   
									DOCCODE,   
									CUSTCD,   
									FILEID,   
									MANAGEGB,   
									DATAGB,   
									ITEMSER,   
									ITEMNAME,   
									ITEMCODE,   
									FACTORY,   
									TRIM_RESULT,   
									PBS,   
									PAINT_REJ,   
									WBS,   
									D_SCH1,   D_SCH2,   D_SCH3,   D_SCH4,   D_SCH5,   D_SCH6,   D_SCH7,   D_SCH8,   D_SCH9,   D_SCH10,   DSCHED_TOT,   
									D1_SCH1,  D1_SCH2,  D1_SCH3,  D1_SCH4,  D1_SCH5,  D1_SCH6,  D1_SCH7,  D1_SCH8,  D1_SCH9,  D1_SCH10,   
									D2_SCH1,  D2_SCH2,  D2_SCH3,  D2_SCH4,  D2_SCH5,  D2_SCH6,  D2_SCH7,  D2_SCH8,  D2_SCH9,  D2_SCH10,   
									D3_SCH1,  D3_SCH2,  D3_SCH3,  D3_SCH4,  D3_SCH5,  D3_SCH6,  D3_SCH7,  D3_SCH8,  D3_SCH9,  D3_SCH10,   
									D4_SCH1,  D4_SCH2,  D4_SCH3,  D4_SCH4,  D4_SCH5,  D4_SCH6,  D4_SCH7,  D4_SCH8,  D4_SCH9,  D4_SCH10,   
									REMAIN_QTY,   
									CONF_TQTY,   
									MODEL_CODE,   
									RSV,   
									CRT_DATE,   
									CRT_TIME,   
									CRT_USER,   
									CITNBR,   
									MITNBR,   
									MCVCOD,   
									MDCVCOD    )					
			          values( :arg_SABU,   
									:ls_DOCCODE,   
									:ls_CUSTCD,   
									:ls_FILEID,   
									:ls_MANAGEGB,   
									:ls_DATAGB,   
									:ls_ITEMSER,   
									:ls_ITEMNAME,   
									:ls_ITEMCODE,   
									:ls_FACTORY,   
									:ll_TRIM_RESULT,   
									:ll_PBS,   
									:ll_PAINT_REJ,   
									:ll_WBS,   
									:ll_D_SCH1	, :ll_D_SCH2  , :ll_D_SCH3  , :ll_D_SCH4  , :ll_D_SCH5  , :ll_D_SCH6  , :ll_D_SCH7	, :ll_D_SCH8  , :ll_D_SCH9	, :ll_D_SCH10    ,:ll_DSCHED_TOT  ,      
									:ll_D1_SCH1 , :ll_D1_SCH2 , :ll_D1_SCH3 , :ll_D1_SCH4 , :ll_D1_SCH5 , :ll_D1_SCH6 , :ll_D1_SCH7 , :ll_D1_SCH8 , :ll_D1_SCH9 , :ll_D1_SCH10  ,
									:ll_D2_SCH1 , :ll_D2_SCH2 , :ll_D2_SCH3 , :ll_D2_SCH4 , :ll_D2_SCH5 , :ll_D2_SCH6 , :ll_D2_SCH7 , :ll_D2_SCH8 , :ll_D2_SCH9 , :ll_D2_SCH10  ,
									:ll_D3_SCH1 , :ll_D3_SCH2 , :ll_D3_SCH3 , :ll_D3_SCH4 , :ll_D3_SCH5 , :ll_D3_SCH6 , :ll_D3_SCH7 , :ll_D3_SCH8 , :ll_D3_SCH9 , :ll_D3_SCH10  ,
									:ll_D4_SCH1 , :ll_D4_SCH2 , :ll_D4_SCH3 , :ll_D4_SCH4 , :ll_D4_SCH5 , :ll_D4_SCH6 , :ll_D4_SCH7 , :ll_D4_SCH8 , :ll_D4_SCH9 , :ll_D4_SCH10  ,
									:ll_REMAIN_QTY,   
									:ll_CONF_TQTY,   
									:ls_MODEL_CODE,   
									:ls_RSV,   
									:ls_CRT_DATE,   
									:ls_CRT_TIME,   
									:ls_CRT_USER,   
									:ls_CITNBR,   
									:ls_MITNBR,   
									:ls_MCVCOD,   
									:ls_MDCVCOD  );
	
	if sqlca.sqlcode <> 0 then
		Messagebox('',sqlca.sqlerrText)
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+"입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		st_state.Visible = False
		return -3
	end if
	il_succeed++
	

Loop


// van file close
FileClose(li_FileNum)

commit;

wf_file_copy(arg_file_name)

st_state.Visible = False
return li_cnt



end function

public function integer wf_van_d3 (string arg_file_name, string arg_sabu);/* 값변환 참조
	{:+0  	}:-0
	A:1  B:2  C:3  D:4  E:5  F:6  G:7  H:8  I:9
	J:-1 K:-2 L:-3 M:-4 N:-5 O:-6 P:-7 Q:-8 R:-9  */
	
/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	

string ls_Input_Data  ,ls_indate
integer li_FileNum,li_cnt,li_rowcnt , li_file_rtn 
Long  ll_data = 0
string ls_SABU,      &
		 ls_DOCCODE,    &
		 ls_CUSTCD,    &
		 ls_FACTORY,   & 
		 ls_ITNBR,    &
		 ls_ORDER_GB,   & 
		 ls_ORDERNO
Long	 ll_ORDER_QTY
Double ld_DANGA
string ls_ORDER_DATE,   & 
		 ls_LC_GUBUN, &   
		 ls_ECO_NO,    &
		 ls_APPLY_DT,    &
	    ls_END_INDATE
Long	 ll_END_INQTY
Long	 ll_ORDER_JQTY
Long	 ll_ONE_QTY
string ls_BAL_DATE,   & 
		 ls_CRT_DATE,  &  
		 ls_CRT_TIME,   & 
		 ls_CRT_USER,   & 
		 ls_CITNBR,   & 
		 ls_MITNBR,    &
		 ls_MCVCOD,    &
		 ls_MDCVCOD  , &
		 ls_gubun 
		 
Long   ll_cnt

//현재 일자,시간 
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid

Long ll_p , ll_px

ll_p = LastPos(arg_file_name , '\')
ll_px = LastPos(Upper(arg_file_name) , '.TXT')

ls_gubun = Upper(Mid(arg_file_name , ll_p + 1 , ll_px - ( ll_p + 1 ) ))

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(ls_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	return -1
end if

li_cnt = 0

st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'
Do While	FileRead(li_FileNum, ls_Input_Data) <> -100

	
	SetNull(ls_mitnbr)
	SetNull(ls_mcvcod)
	SetNull(ls_mdcvcod)
	SetNull(ls_citnbr)
	
	li_cnt ++
	
	yield()
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt) 
	
	ls_doccode = trim(mid(ls_Input_Data,1,12))
	
	ls_indate = Trim(dw_ip.Object.jisi_date[1])
//	// 파일 날짜 체크
//	if ls_indate <> Mid(ls_doccode,3,8) then
//		
//		//st_state.Visible = False
//		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "파일의 수신일자와 등록일자가 상이합니다.")
//		
//		Continue ;
//	end if
	
	if ls_indate <> Mid(ls_doccode,3,8) then
		ls_indate = Mid(ls_doccode,3,8)
	end if
	
	// 화일명의 값과 필드값을 체크
	if upper(left(right(arg_file_name,6),2)) <> upper(left(ls_doccode,2)) then
		rollback;
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,'','',"화일명과 화일의 필드값이 틀립니다.")
		FileClose(li_FileNum)
		return -2
	end if

	ls_custcd 	= trim(mid(ls_Input_Data,13,4))
	ls_factory 	= trim(mid(ls_Input_Data,17,2))
	ls_itnbr 	= trim(mid(ls_Input_Data,19,15))
	
	ls_ORDER_GB	= trim(mid(ls_Input_Data,34,1))
	ls_ORDERNO	= trim(mid(ls_Input_Data,35,11))
	ll_ORDER_QTY = wf_van_scan_chk2('1',mid(ls_Input_Data,46,6),mid(ls_Input_Data,52,1))
   ld_DANGA 	 = wf_van_scan_chk2('2',mid(ls_Input_Data,53,8),mid(ls_Input_Data,61,2))
   ls_ORDER_DATE= trim(mid(ls_Input_Data,63,8))
	ls_LC_GUBUN	 = trim(mid(ls_Input_Data,71,1))
	ls_ECO_NO	 = trim(mid(ls_Input_Data,72,8))
	ls_APPLY_DT	 = trim(mid(ls_Input_Data,80,8))
	ls_END_INDATE= trim(mid(ls_Input_Data,88,8))
	ll_END_INQTY = wf_van_scan_chk2('1',mid(ls_Input_Data,96,6),mid(ls_Input_Data,102,1))
	ll_ORDER_JQTY= wf_van_scan_chk2('1',mid(ls_Input_Data,103,6),mid(ls_Input_Data,109,1))
	ll_ONE_QTY   = wf_van_scan_chk2('1',mid(ls_Input_Data,110,6),mid(ls_Input_Data,116,1))
   ls_BAL_DATE  = trim(mid(ls_Input_Data,117,8))
	
	
	//자체품번 읽어오기(자체거래처코드)
//	select itnbr
//	into :ls_mitnbr
//	from itemas
//	where replace(itnbr,'-','') = :ls_itnbr ;
	
//	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
	
	ls_mitnbr = sqlca.fun_get_buitnbr(ls_itnbr , '') ;
	
	if trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')
		
		Continue ;
	End IF
	
	//공장별 거래처 읽어오기
   select fun_get_scvcod( :ls_factory , :ls_mitnbr ,''  ),
			 nvl(RFNA3,'')
	  Into :ls_mcvcod , :ls_mdcvcod
	  from reffpf 
	where sabu = :arg_sabu and
			rfcod = '2A' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
		il_err++
		Continue ;
	end if
	
	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
   ll_data++
	
	// 한텍 요청 //////////////////////////////////////////////////////
   ll_cnt = 0 
	select count(*) Into :ll_cnt
	  from van_hkcd3
	 where SABU=   :gs_SABU
		and DOCCODE = :ls_DOCCODE   
		and CUSTCD = :ls_CUSTCD  
		and FACTORY = :ls_FACTORY 
		and ITNBR = :ls_ITNBR 
		and ORDERNO = :ls_ORDERNO ;
		
	If ll_cnt > 0 Then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(li_cnt)+']')
		Continue ;
	end if
	
/////////////////////////////////////////////////////////
	
	
	insert into van_hkcd3(  SABU,   
									DOCCODE,   
									CUSTCD,   
									FACTORY,   
									ITNBR,   
									ORDER_GB,   
									ORDERNO,   
									ORDER_QTY,   
									DANGA,   
									ORDER_DATE,   
									LC_GUBUN,   
									ECO_NO,   
									APPLY_DT,   
									END_INDATE,   
									END_INQTY,   
									ORDER_JQTY,   
									ONE_QTY,   
									BAL_DATE,   
									CRT_DATE,   
									CRT_TIME,   
									CRT_USER,   
									CITNBR,   
									MITNBR,   
									MCVCOD,   
									MDCVCOD )       
					values( 		:arg_SABU,      
		 							:ls_DOCCODE,    
									:ls_CUSTCD,    
									:ls_FACTORY,  
									:ls_ITNBR,    
									:ls_ORDER_GB,   
									:ls_ORDERNO,
	 								:ll_ORDER_QTY,
 									:ld_DANGA,
 									:ls_ORDER_DATE,   
		 							:ls_LC_GUBUN,  
		 							:ls_ECO_NO,   
		 							:ls_APPLY_DT,   
	    							:ls_END_INDATE,
									:ll_END_INQTY,
									:ll_ORDER_JQTY,
									:ll_ONE_QTY,
 									:ls_BAL_DATE,   
									:ls_CRT_DATE,  
									:ls_CRT_TIME,   
									:ls_CRT_USER,   
									:ls_CITNBR,   
									:ls_MITNBR,   
									:ls_MCVCOD,   
									:ls_MDCVCOD  
									 );
	
	if sqlca.sqlcode <> 0 then
		
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		st_state.Visible = False
		return -3
	end if
	il_succeed++

Loop

// van file close
FileClose(li_FileNum)

commit;

wf_file_copy(arg_file_name)

st_state.Visible = False
return li_cnt

end function

public function long wf_itnbr_insert (string ar_itnbr, string ar_itdsc);INSERT INTO ITEMAS
	(	 SABU,   
         ITNBR,   
         ITDSC,   
         ISPEC,   
         JIJIL,   
         ITTYP,   
         ITCLS,   
         LOTGUB,   
         GBWAN,   
         GBDATE,   
         GBGUB,   
         USEYN,   
         PUMSR,   
         CNVFAT,   
         UNMSR,   
         WAGHT,   
         FILSK,   
         ITGU,   
         WONPRC,   
         WONSRC,   
         MLICD,   
         LDTIM,   
         LDTIM2,   
         MINSAF,   
         MIDSAF,   
         MAXSAF,   
         SHRAT,   
         MINQT,   
         MULQT,   
         MAXQT,   
         AUTO,   
         BASEQTY,   
         PACKQTY,   
         AUTOHOLD,   
         LOT,   
         BALRATE,   
         RMARK2	)  
   VALUES ( '1',   
         :AR_ITNBR ,   
         :AR_ITDSC ,   
         NULL,   
         NULL,   
         '1',   
         '9999',   
         'N',   
         'Y',   
         '20060904',   
         '1',   
         '0',   
         'EA',   
         1,   
         'EA',   
         0,   
         'Y',   
         '5',   
         0,    
         0, 
         '1',   
         0,   
         0,   
         0,   
         0,   
         0,   
         0,   
         0,   
         0,   
         0,   
         'N',   
         0,   
         0,   
         'N',   
         'N',   
         0,   
         NULL ) ;
			
If sqlca.sqlcode <> 0 Then
	rollback;
	return -1
end iF

commit;

return 1
end function

public function long wf_error (string as_gubun, long al_line, string as_doccode, string as_factory, string as_itnbr, string as_errtext);Long ll_r

ll_r = dw_list.InsertRow(0)

dw_list.Object.saupj[ll_r] = Trim(dw_ip.Object.saupj[1])
dw_list.Object.err_date[ll_r] = Trim(dw_ip.Object.jisi_date[1])
dw_list.Object.err_time[ll_r] = f_totime()
dw_list.Object.doctxt[ll_r] = as_gubun
dw_list.Object.err_line[ll_r] = al_line
dw_list.Object.doccode[ll_r] = as_doccode
dw_list.Object.factory[ll_r] = as_factory
dw_list.Object.itnbr[ll_r] = as_itnbr
dw_list.Object.err_txt[ll_r] = as_errtext

dw_list.scrolltorow(ll_r)

Return ll_r
end function

public function integer wf_file_copy (string arg_file);Long ll_p , ll_px ,ll_s
String ls_dir , ls_file ,ls_nfile  , ls_totime

ll_p = LastPos(arg_file , '\')
ls_dir = Upper(Left(arg_file , ll_p ))

ls_dir = ls_dir+'\'+is_today

If DirectoryExists ( ls_dir ) = false Then
	If CreateDirectory ( ls_dir ) < 1 Then
		MessageBox('확인','파일백업 실패1')
		Return -1
	end if
end if

select to_char(sysdate,'yyyymmddhh24miss') into :ls_totime from dual ;

ll_px = LastPos(Upper(arg_file) , '.TXT')
ls_file = Upper(Mid(arg_file , ll_p + 1 , ll_px - ( ll_p + 1 ) )) + '_'+ls_totime+'.TXT'

ls_nfile = ls_dir+"\"+ls_file

If FileCopy(arg_file,ls_nfile ,false) < 1 Then
	MessageBox('확인','파일백업 실패2')
	Return -1
End if

return 1
end function

public function integer wf_van_d9_et (string arg_file_name, string arg_sabu);/* 값변환 참조
	{:+0  	}:-0
	A:1  B:2  C:3  D:4  E:5  F:6  G:7  H:8  I:9
	J:-1 K:-2 L:-3 M:-4 N:-5 O:-6 P:-7 Q:-8 R:-9  */
	
/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	


string ls_Input_Data ,ls_indate
integer li_FileNum,li_cnt,li_rowcnt
Long  ll_data = 0
string ls_SABU,ls_DOCCODE,ls_CUSTCD,ls_FACTORY,ls_ITNBR,ls_IPSOURCE,ls_IPGUBUN
double ld_IPTQTY,ld_IPTAMT,ld_PACKTAMT
string ls_CRT_DATE,ls_CRT_TIME,ls_CRT_USER,ls_mcvcod,ls_mdcvcod,ls_mitnbr,ls_citnbr ,ls_gubun
Long 	ll_seqno

Long ll_cnt

//현재 일자,시간 
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')

Long ll_p , ll_px

ll_p = LastPos(arg_file_name , '\')
ll_px = LastPos(Upper(arg_file_name) , '.TXT')

ls_gubun = Upper(Mid(arg_file_name , ll_p + 1 , ll_px - ( ll_p + 1 ) ))

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(ls_gubun,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!")
	return -1
end if

li_cnt = 0

st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

/* 일, 월 검수 자료는 매출마감이 되면 받을 수 없음. - 2007.05.05 BY SHINGOON(노상호BJ요청)   */
/* 월 검수는 (마감월 + 1) 한 값으로 비교 C로 시작되는 공장코드는 당월 검수자료 받음.         */
/* 6월 마감일 경우 C로 시작되는 공장코드는 6월 검수자료가 접수됨. C공장코드 이외에는 7월접수 */
String ls_magam
SELECT TO_CHAR(TO_DATE(MAX(MAYYMM) + 1, 'YYYYMM'), 'YYYYMM')
  INTO :ls_magam
  FROM SALE_MAGAM;
/*******************************************************************************************/

Do While	FileRead(li_FileNum, ls_Input_Data) <> -100

	
	SetNull(ls_mitnbr)
	SetNull(ls_mcvcod)
	SetNull(ls_mdcvcod)
	SetNull(ls_citnbr)
	
	li_cnt ++
	yield()
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt) 
	
	ls_doccode = trim(mid(ls_Input_Data,1,12))
	ls_indate = Trim(dw_ip.Object.jisi_date[1])

	// 파일 날짜 체크
//	if ls_indate <> Mid(ls_doccode,3,8) then
//		
//		wf_error(ls_gubun,li_cnt,ls_doccode,'','', "파일의 수신일자와 등록일자가 상이합니다.")
//		Continue ;
//	end if


	// 화일명의 값과 필드값을 체크
	if upper(left(right(arg_file_name,6),2)) <> upper(left(ls_doccode,2)) then
		rollback;
		st_state.Visible = False
		wf_error(ls_gubun,li_cnt,ls_doccode,'','',"화일명과 화일의 필드값이 틀립니다.")
		FileClose(li_FileNum)
		return -2
	end if

	ls_custcd = trim(mid(ls_Input_Data,13,4))
	ls_factory = trim(mid(ls_Input_Data,17,2))
	ls_itnbr = trim(mid(ls_Input_Data,19,15))
	ls_ipsource = trim(mid(ls_Input_Data,34,1))
	ls_ipgubun = trim(mid(ls_Input_Data,35,2))
	
	If isNull(ls_ipsource)  Or ls_ipsource = "" Then ls_ipsource = "." 
	
	If isNull(ls_ipgubun)  Or ls_ipgubun = "" Then  ls_ipgubun = "." 

	ld_iptqty = wf_van_scan_chk(mid(ls_Input_Data,37,7),mid(ls_Input_Data,44,1))
	ld_iptamt =  wf_van_scan_chk(mid(ls_Input_Data,45,10),mid(ls_Input_Data,55,1))
	ld_packtamt = wf_van_scan_chk(mid(ls_Input_Data,56,9),mid(ls_Input_Data,65,1))
	
	/* 매출마감이 되어 있는 월의 일 검수 자료가 선택될 경우 Return - BY SHINGOON (노상호BJ요청) 2007.05.05 */
   /* 월 검수는 (마감월 + 1) 한 값으로 비교 C로 시작되는 공장코드는 당월 검수자료 받음.         */
   /* 6월 마감일 경우 C로 시작되는 공장코드는 6월 검수자료가 접수됨. C공장코드 이외에는 7월접수 */
	If ls_magam >= MID(ls_doccode, 3, 6) Then
		If LEFT(ls_factory, 1) <> 'C' Then
			ROLLBACK USING SQLCA;
			wf_error(ls_gubun, li_cnt, ls_doccode, '', '', '해당 검수(D9) 자료는 이미 매출마감이 완료된 자료입니다.')
			FileClose(li_FileNum)
			return -2
		End If
	End If
	/********************************************************************************************/	
	
	
	//자체품번 읽어오기(자체거래처코드)
//	select itnbr
//	into :ls_mitnbr
//	from itemas
//	where replace(itnbr,'-','') = :ls_itnbr ;
//	
//	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then

	ls_mitnbr = sqlca.fun_get_buitnbr(ls_itnbr , '') ;
	
	if trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		il_err++
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')
		
		Continue ;
	End IF
	
	//공장별 거래처 읽어오기
   select fun_get_scvcod( :ls_factory , :ls_mitnbr ,''  ),
			 nvl(RFNA3,'')
	  Into :ls_mcvcod , :ls_mdcvcod
	  from reffpf 
	where sabu = :arg_sabu and
			rfcod = '2A' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
		isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
		il_err++
		Continue ;
	end if
	
	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
   ll_data++
	
	// 한텍 요청 //////////////////////////////////////////////////////
   ll_cnt = 0 
	select count(*) Into :ll_cnt
	  from van_hkcd9
	 where SABU=   :gs_SABU
		and DOCCODE = :ls_DOCCODE   
		and CUSTCD = :ls_CUSTCD  
		and FACTORY = :ls_FACTORY 
		and ITNBR = :ls_ITNBR 
		and IPSOURCE = :ls_ipsource 
		and IPGUBUN = :ls_ipgubun ;
		
	If ll_cnt > 0 Then
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(li_cnt)+']')
		Continue ;
	end if
	
/////////////////////////////////////////////////////////
	
	insert into van_hkcd9(SABU,DOCCODE,CUSTCD,FACTORY,ITNBR,IPSOURCE,IPGUBUN,IPTQTY,IPTAMT,PACKTAMT,CRT_DATE,CRT_TIME,CRT_USER,CITNBR,
	                                 MITNBR,MCVCOD,MDCVCOD)       
					values(:arg_SABU,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_ITNBR,:ls_IPSOURCE,:ls_IPGUBUN,:ld_IPTQTY,:ld_IPTAMT,:ld_PACKTAMT,:ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,:ls_citnbr,
					           :ls_MITNBR,:ls_MCVCOD,:ls_MDCVCOD);

	if sqlca.sqlcode <> 0 then
		
		wf_error(ls_gubun,li_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']')
		rollback;
		FileClose(li_FileNum)
		st_state.Visible = False
		return -3
	end if
	il_succeed++


Loop

// van file close
FileClose(li_FileNum)

commit;

wf_file_copy(arg_file_name)

st_state.Visible = False
return li_cnt

end function

on w_sm10_0030.create
int iCurrent
call super::create
this.p_search=create p_search
this.p_delrow=create p_delrow
this.p_delrow_all=create p_delrow_all
this.pb_1=create pb_1
this.dw_d2=create dw_d2
this.dw_d0=create dw_d0
this.dw_d68=create dw_d68
this.dw_gi=create dw_gi
this.dw_dh=create dw_dh
this.dw_p6=create dw_p6
this.dw_p7=create dw_p7
this.dw_d1=create dw_d1
this.dw_d9=create dw_d9
this.dw_d3=create dw_d3
this.st_state=create st_state
this.tab_1=create tab_1
this.pb_2=create pb_2
this.p_excel=create p_excel
this.st_caption=create st_caption
this.p_mod=create p_mod
this.cb_d9_et=create cb_d9_et
this.cb_1=create cb_1
this.dw_d2_detail=create dw_d2_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_search
this.Control[iCurrent+2]=this.p_delrow
this.Control[iCurrent+3]=this.p_delrow_all
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.dw_d2
this.Control[iCurrent+6]=this.dw_d0
this.Control[iCurrent+7]=this.dw_d68
this.Control[iCurrent+8]=this.dw_gi
this.Control[iCurrent+9]=this.dw_dh
this.Control[iCurrent+10]=this.dw_p6
this.Control[iCurrent+11]=this.dw_p7
this.Control[iCurrent+12]=this.dw_d1
this.Control[iCurrent+13]=this.dw_d9
this.Control[iCurrent+14]=this.dw_d3
this.Control[iCurrent+15]=this.st_state
this.Control[iCurrent+16]=this.tab_1
this.Control[iCurrent+17]=this.pb_2
this.Control[iCurrent+18]=this.p_excel
this.Control[iCurrent+19]=this.st_caption
this.Control[iCurrent+20]=this.p_mod
this.Control[iCurrent+21]=this.cb_d9_et
this.Control[iCurrent+22]=this.cb_1
this.Control[iCurrent+23]=this.dw_d2_detail
end on

on w_sm10_0030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_search)
destroy(this.p_delrow)
destroy(this.p_delrow_all)
destroy(this.pb_1)
destroy(this.dw_d2)
destroy(this.dw_d0)
destroy(this.dw_d68)
destroy(this.dw_gi)
destroy(this.dw_dh)
destroy(this.dw_p6)
destroy(this.dw_p7)
destroy(this.dw_d1)
destroy(this.dw_d9)
destroy(this.dw_d3)
destroy(this.st_state)
destroy(this.tab_1)
destroy(this.pb_2)
destroy(this.p_excel)
destroy(this.st_caption)
destroy(this.p_mod)
destroy(this.cb_d9_et)
destroy(this.cb_1)
destroy(this.dw_d2_detail)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
//dw_print.object.datawindow.print.preview = "yes"	
//
//dw_print.ShareData(dw_list)

PostEvent('ue_open')

dw_ip.Object.jisi_date[1] = is_today
dw_ip.Object.jisi_date2[1] = is_today

dw_d0.SetTransObject(SQLCA)
dw_d2.SetTransObject(SQLCA)
dw_d68.SetTransObject(SQLCA)
dw_gi.SetTransObject(SQLCA)
dw_dh.SetTransObject(SQLCA)
dw_p6.SetTransObject(SQLCA)
dw_p7.SetTransObject(SQLCA)
dw_d1.SetTransObject(SQLCA)
dw_d9.SetTransObject(SQLCA)
dw_d3.SetTransObject(SQLCA)

dw_d2_detail.SetTransObject(SQLCA)

dw_d0.Titlebar = False
dw_d2.Titlebar = False
dw_d68.Titlebar = False
dw_gi.Titlebar = False
dw_dh.Titlebar = False
dw_p6.Titlebar = False
dw_p7.Titlebar = False
dw_d1.Titlebar = False
dw_d9.Titlebar = False
dw_d3.Titlebar = False

dw_d2_detail.visible = False
	
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_ip.Modify("saupj.protect=1")
   End if
End If

Select rfna5 Into :is_custid
  From reffpf
  Where rfcod = 'AD'
    and rfcod != '00' 
	 and rfgub = :gs_code ;
If sqlca.sqlcode <> 0 Then
	f_message_chk(33 ,'[사업장]')
	Return
End If

dw_ip.Object.gubun[1] = 'AL'

dw_d0.GetChild("newits", idwc_d0)

idwc_d0.SetTransObject(SQLCA)

idwc_d0.Retrieve("%")

//Tab_1.Tabpage_2.Enabled = False






end event

type p_xls from w_standard_print`p_xls within w_sm10_0030
integer x = 3127
integer y = 36
end type

type p_sort from w_standard_print`p_sort within w_sm10_0030
integer x = 2949
integer y = 36
end type

type p_preview from w_standard_print`p_preview within w_sm10_0030
boolean visible = false
integer x = 2926
integer y = 228
end type

event p_preview::clicked;//if dw_1.visible then
//	OpenWithParm(w_print_preview, dw_1)
//	dw_1.visible = FALSE
//	dw_list.visible = TRUE
//
//	p_retrieve.triggerevent('clicked')
//else
//	OpenWithParm(w_print_preview, dw_print)
//end if

end event

type p_exit from w_standard_print`p_exit within w_sm10_0030
integer x = 4421
end type

event p_exit::clicked;close(parent)

end event

type p_print from w_standard_print`p_print within w_sm10_0030
boolean visible = false
integer x = 3099
integer y = 228
end type

event p_print::clicked;//IF dw_1.visible then
//	OpenWithParm(w_print_options,dw_1)
//	dw_1.visible = FALSE
//	dw_list.visible = TRUE
//
//	p_retrieve.triggerevent('clicked')
//ELSE
//	IF dw_print.rowcount() > 0 then 
//		gi_page = dw_print.GetItemNumber(1,"last_page")
//	ELSE
//		gi_page = 1
//	END IF
//	OpenWithParm(w_print_options, dw_print)
//END IF
end event

type p_retrieve from w_standard_print`p_retrieve within w_sm10_0030
integer x = 4073
end type







type st_10 from w_standard_print`st_10 within w_sm10_0030
end type



type dw_print from w_standard_print`dw_print within w_sm10_0030
integer x = 3360
integer y = 20
string dataobject = "d_van_t_10020_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm10_0030
integer x = 23
integer y = 28
integer width = 3314
integer height = 356
string dataobject = "d_sm10_0030_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String ls_col , ls_value, ls_itnbr_t, ls_itnbr_f

ls_col = GetColumnName()
ls_value = Trim(GetText())

Choose Case ls_col
	Case "gubun"
		If ls_value > '' Then
			Object.filename[1] = ' '+ wf_choose(ls_value)
		End If		
	Case "itnbr_from"
		ls_itnbr_t = Trim(This.GetItemString(row, 'itnbr_to'))
		This.SetItem(row, 'itnbr_to', ls_value)
//		if IsNull(ls_itnbr_t) or ls_itnbr_t = '' then
//			This.SetItem(row, 'itnbr_to', ls_value)
//	   end if
	Case "itnbr_to"
		ls_itnbr_f = Trim(This.GetItemString(row, 'itnbr_from'))
		if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
			This.SetItem(row, 'itnbr_from', ls_value)
	   end if
	
END CHOOSE

if ls_value = 'AL' Then st_caption.Text = ' '
if ls_value = 'D0' Then st_caption.Text = '품목정보'
if ls_value = 'DH' Then st_caption.Text = 'HPC-CODE 기초정보'
if ls_value = 'D1' Then st_caption.Text = '검수합격통보서(DOC코드기준)'
if ls_value = 'D2' Then st_caption.Text = '주간(부품) 소요량'
if ls_value = 'D6' Then st_caption.Text = '일별.주간 납입지시(정규발주)'
if ls_value = 'D8' Then st_caption.Text = '일별.주간 납입지시 변동분(추가,분납,삭제)'
if ls_value = 'GI' Then st_caption.Text = ' '
if ls_value = 'P6' Then st_caption.Text = '서열부품집계표(상세용)'
if ls_value = 'P7' Then st_caption.Text = '서열부품집계표(종합용)'
if ls_value = 'D9' Then st_caption.Text = '검수합격통보서(월집계표)'
if ls_value = 'D3' Then st_caption.Text = '초도발주'
end event

type dw_list from w_standard_print`dw_list within w_sm10_0030
integer x = 59
integer y = 532
integer width = 4503
integer height = 1752
string dataobject = "d_sm10_0030_a"
boolean border = false
end type

event dw_list::clicked;f_multi_select(this)
end event

event dw_list::rowfocuschanged;//
end event

type p_search from uo_picture within w_sm10_0030
integer x = 3899
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;Long ll_cnt
string ls_filename , ls_gubun , ls_reg_gb
Long ll_r

If dw_ip.AcceptText() < 1 Then Return
If dw_ip.AcceptText() < 1 Then Return
If dw_ip.RowCount() < 1 Then Return

ls_gubun = Trim(dw_ip.Object.gubun[1])


pointer oldpointer
oldpointer = SetPointer(HourGlass!)

dw_list.reset()

Choose Case ls_gubun
	Case "D0"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD0"
		ls_filename = "C:\HKC\VAN\HKCD0.TXT"
		ll_cnt = wf_van_d0(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD0"
		ls_filename = "C:\HKC\VAN\PTD0.TXT"
		ll_cnt = wf_van_d0(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD0"
		ls_filename = "C:\HKC\VAN\SAD0.TXT"
		ll_cnt = wf_van_d0(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1
		End if
		
	Case "D2"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD2"
		ls_filename = "C:\HKC\VAN\HKCD2.TXT"
		ll_cnt = wf_van_d2(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD2"
		ls_filename = "C:\HKC\VAN\PTCD2.TXT"
		ll_cnt = wf_van_d2(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD2"
		ls_filename = "C:\HKC\VAN\SAD2.TXT"
		ll_cnt = wf_van_d2(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1
		End if
		
	Case "D6"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD6"
		ls_filename = "C:\HKC\VAN\HKCD6.TXT"
		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD6"
		ls_filename = "C:\HKC\VAN\PTD6.TXT"
		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD6"
		ls_filename = "C:\HKC\VAN\SAD6.TXT"
		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1
		End if
	Case "D8"
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD8"
		ls_filename = "C:\HKC\VAN\HKCD8.TXT"
		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		dw_list.object.err_seq[ll_r] = 1	
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD8"
		ls_filename = "C:\HKC\VAN\PTD8.TXT"
		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		dw_list.object.err_seq[ll_r] = 1	
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD8"
		ls_filename = "C:\HKC\VAN\SAD8.TXT"
		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
		dw_list.object.err_seq[ll_r] = 1	
		End if
		
	Case "GI"
		il_succeed = 0	
		ll_cnt=0
		ls_gubun = "GINGUB"
		ls_filename = "C:\HKC\VAN\GINGUB.TXT"
		ll_cnt = wf_van_gi(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',ls_gubun + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		il_succeed = 0	
		ll_cnt=0
		ls_gubun = "PTGINGUB"
		ls_filename = "C:\HKC\VAN\PTGINGUB.TXT"
		ll_cnt = wf_van_gi(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',ls_gubun + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		il_succeed = 0	
		ll_cnt=0
		ls_gubun = "SAGINGUB"
		ls_filename = "C:\HKC\VAN\SAGINGUB.TXT"
		ll_cnt = wf_van_gi(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',ls_gubun + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
	Case "DH"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCDH"
		ls_filename = "C:\HKC\VAN\HKCDH.TXT"
		ll_cnt = wf_van_dh(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTDH"
		ls_filename = "C:\HKC\VAN\PTDH.TXT"
		ll_cnt = wf_van_dh(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SADH"
		ls_filename = "C:\HKC\VAN\SADH.TXT"
		ll_cnt = wf_van_dh(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
	/* 한텍은 적용 안함 
	Case "P6"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCP6"
		ls_filename = "C:\HKC\VAN\HKCP6.TXT"
		ll_cnt = wf_van_p6(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
	Case "P7"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCP7"
		ls_filename = "C:\HKC\VAN\HKCP7.TXT"
		ll_cnt = wf_van_P7(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
	*/
	Case "D1"
	   il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD1"
		ls_filename = "C:\HKC\VAN\HKCD1.TXT"
		ll_cnt = wf_van_d1(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		 il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD1"
		ls_filename = "C:\HKC\VAN\PTD1.TXT"
		ll_cnt = wf_van_d1(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		 il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD1"
		ls_filename = "C:\HKC\VAN\SAD1.TXT"
		ll_cnt = wf_van_d1(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
	Case "D9"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD9"
		ls_filename = "C:\HKC\VAN\HKCD9.TXT"
		ll_cnt = wf_van_d9(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD9"
		ls_filename = "C:\HKC\VAN\PTD9.TXT"
		ll_cnt = wf_van_d9(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD9"
		ls_filename = "C:\HKC\VAN\SAD9.TXT"
		ll_cnt = wf_van_d9(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
	Case "D3"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD3"
		ls_filename = "C:\HKC\VAN\HKCD3.TXT"
		ll_cnt = wf_van_d3(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD3"
		ls_filename = "C:\HKC\VAN\PTD3.TXT"
		ll_cnt = wf_van_d3(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD3"
		ls_filename = "C:\HKC\VAN\SAD3.TXT"
		ll_cnt = wf_van_d3(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
	Case Else
		// D0
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD0"
		ls_filename = "C:\HKC\VAN\HKCD0.TXT"
		ll_cnt = wf_van_d0(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		// DH
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCDH"
		ls_filename = "C:\HKC\VAN\HKCDH.TXT"
		ll_cnt = wf_van_dh(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		il_succeed = 0
		// D2
		ll_cnt=0
		ls_gubun = "HKCD2"
		ls_filename = "C:\HKC\VAN\HKCD2.TXT"
		ll_cnt = wf_van_d2(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// D6
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD6"
		ls_filename = "C:\HKC\VAN\HKCD6.TXT"
		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// D8
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD8"
		ls_filename = "C:\HKC\VAN\HKCD8.TXT"
		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// GINGUB
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "GINGUB"
		ls_filename = "C:\HKC\VAN\GINGUB.TXT"
		ll_cnt = wf_van_gi(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',ls_gubun + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		/*
		// P6
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCP6"
		ls_filename = "C:\HKC\VAN\HKCP6.TXT"
		ll_cnt = wf_van_p6(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// P7
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCP7"
		ls_filename = "C:\HKC\VAN\HKCP7.TXT"
		ll_cnt = wf_van_P7(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		*/
		// D1
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD1"
		ls_filename = "C:\HKC\VAN\HKCD1.TXT"
		ll_cnt = wf_van_d1(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// D9
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD9"
		ls_filename = "C:\HKC\VAN\HKCD9.TXT"
		ll_cnt = wf_van_d9(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// D3
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "HKCD3"
		ls_filename = "C:\HKC\VAN\HKCD3.TXT"
		ll_cnt = wf_van_d3(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		// 현대 파워텍 ===========================================================================================
		// D0
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD0"
		ls_filename = "C:\HKC\VAN\PTD0.TXT"
		ll_cnt = wf_van_d0(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		// DH
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTDH"
		ls_filename = "C:\HKC\VAN\PTDH.TXT"
		ll_cnt = wf_van_dh(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		il_succeed = 0
		// D2
		ll_cnt=0
		ls_gubun = "PTD2"
		ls_filename = "C:\HKC\VAN\PTD2.TXT"
		ll_cnt = wf_van_d2(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// D6
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD6"
		ls_filename = "C:\HKC\VAN\PTD6.TXT"
		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// D8
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD8"
		ls_filename = "C:\HKC\VAN\PTD8.TXT"
		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// GINGUB
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTGINGUB"
		ls_filename = "C:\HKC\VAN\PTGINGUB.TXT"
		ll_cnt = wf_van_gi(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',ls_gubun + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		// D1
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD1"
		ls_filename = "C:\HKC\VAN\PTD1.TXT"
		ll_cnt = wf_van_d1(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// D9
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD9"
		ls_filename = "C:\HKC\VAN\PTD9.TXT"
		ll_cnt = wf_van_d9(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// D3
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "PTD3"
		ls_filename = "C:\HKC\VAN\PTD3.TXT"
		ll_cnt = wf_van_d3(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		// 동희오토  ===========================================================================================
		// D0
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD0"
		ls_filename = "C:\HKC\VAN\SAD0.TXT"
		ll_cnt = wf_van_d0(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		// DH
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SADH"
		ls_filename = "C:\HKC\VAN\SADH.TXT"
		ll_cnt = wf_van_dh(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		il_succeed = 0
		// D2
		ll_cnt=0
		ls_gubun = "SAD2"
		ls_filename = "C:\HKC\VAN\SAD2.TXT"
		ll_cnt = wf_van_d2(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// D6
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD6"
		ls_filename = "C:\HKC\VAN\SAD6.TXT"
		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// D8
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD8"
		ls_filename = "C:\HKC\VAN\SAD8.TXT"
		ll_cnt = wf_van_d68(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// GINGUB
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAGINGUB"
		ls_filename = "C:\HKC\VAN\SAGINGUB.TXT"
		ll_cnt = wf_van_gi(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',ls_gubun + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		// D1
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD1"
		ls_filename = "C:\HKC\VAN\SAD1.TXT"
		ll_cnt = wf_van_d1(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// D9
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD9"
		ls_filename = "C:\HKC\VAN\SAD9.TXT"
		ll_cnt = wf_van_d9(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		// D3
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "SAD3"
		ls_filename = "C:\HKC\VAN\SAD3.TXT"
		ll_cnt = wf_van_d3(ls_filename,gs_sabu)
		If ll_cnt > 0 Then
			ll_r = wf_error(ls_gubun,ll_cnt,'','','',Right(ls_gubun,2) + ' 총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하엿습니다.')
			dw_list.object.err_seq[ll_r] = 1	
		End if
		
		
End Choose

SetPointer(oldpointer)

If ll_cnt > 0 Then
	p_print.Enabled =True
	p_print.PictureName = 'C:\erpman\image\인쇄_up.gif'

	p_preview.enabled = True
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
Else
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
End If	
SetPointer(Arrow!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_delrow from uo_picture within w_sm10_0030
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4123
integer y = 240
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

event clicked;call super::clicked;Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust 
DataWindow ldw_x

if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1

ls_gubun = Trim(dw_ip.Object.gubun[1]) 
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_cvcod = Trim(dw_ip.Object.mcvcod[1])

ls_date = Trim(dw_ip.Object.jisi_date[1])

SetNull(ls_saupj_cust)

select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
  from dual ;
If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
	MessageBox('확인','사업장을 선택하세요')
	Return -1
End If
	
If Tab_1.SelectedTab = 1 Then
	ldw_x = dw_list

Else
	Choose Case ls_gubun 
		Case 'D0'
			ldw_x = dw_d0
		Case 'D2'
			ldw_x = dw_d2
		Case 'D6'
			ldw_x = dw_d68
		Case 'D8'
			ldw_x = dw_d68
		Case 'GI'
			ldw_x = dw_gi
		Case 'DH'
			Messagebox('확인','DH는 삭제처리 하지 않아도 됩니다.[삭제 불가능]')
			Return
			ldw_x = dw_dh
		Case 'P6'
			ldw_x = dw_p6
		Case 'P7'
			ldw_x = dw_p7
		Case 'D1'
			ldw_x = dw_d1
		Case 'D9'
			ldw_x = dw_d9
		Case 'D3'
			ldw_x = dw_d3
		
	End Choose
	
End IF


ll_rcnt = ldw_x.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
	Return
End IF
if f_msg_delete() = -1 then return

ldw_x.SetRedraw(FALSE)

String ls_citnbr

For i = ll_rcnt To 1 Step -1
	If ldw_x.isSelected(i) Then
		
		If ls_gubun = 'D6' or ls_gubun = 'D8' or ls_gubun = 'GI' Then
			ls_citnbr =  Trim(ldw_x.Object.citnbr[i])
			
			//If ls_citnbr = '1' or ls_citnbr = '2' Then 
			If ls_citnbr = '1' Then 
				MessageBox('확인','출하등록 완료된 상태입니다. 삭제불가능합니다.')
				Return
			End iF
		End iF
		
		ldw_x.ScrollToRow(i)
		ldw_x.DeleteRow(i)
	End iF
Next

if ldw_x.Update() = 1 then
	
	commit ;
	sle_msg.text =	"모든자료를 삭제하였습니다!!"	
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
ldw_x.SetRedraw(TRUE)


end event

type p_delrow_all from uo_picture within w_sm10_0030
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3950
integer y = 240
integer width = 178
integer taborder = 90
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\전체삭제_up.gif"
end type

event clicked;call super::clicked;Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust
DataWindow ldw_x

if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1

ls_gubun = Trim(dw_ip.Object.gubun[1]) 
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_cvcod = Trim(dw_ip.Object.mcvcod[1])

ls_date = Trim(dw_ip.Object.jisi_date[1])

SetNull(ls_saupj_cust)

select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
  from dual ;
If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
	MessageBox('확인','사업장을 선택하세요')
	Return -1
End If
	
If Tab_1.SelectedTab = 1 Then
	ldw_x = dw_list

Else
	Choose Case ls_gubun 
		Case 'D0'
			ldw_x = dw_d0
		Case 'D2'
			ldw_x = dw_d2
		Case 'D6'
			ldw_x = dw_d68
		Case 'D8'
			ldw_x = dw_d68
		Case 'GI'
			ldw_x = dw_gi
		Case 'DH'
			Messagebox('확인','DH는 삭제처리 하지 않아도 됩니다.[삭제 불가능]')
			Return
			ldw_x = dw_dh
		Case 'P6'
			ldw_x = dw_p6
		Case 'P7'
			ldw_x = dw_p7
		Case 'D1'
			ldw_x = dw_d1
		Case 'D9'
			ldw_x = dw_d9
		Case 'D3'
			ldw_x = dw_d3
		
	End Choose
	
End IF


ll_rcnt = ldw_x.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
	Return
End IF
if f_msg_delete() = -1 then return

ldw_x.SetRedraw(FALSE)

String ls_citnbr

For i = ll_rcnt To 1 Step -1
	
	If ls_gubun = 'D6' or ls_gubun = 'D8' or ls_gubun = 'GI' Then
		ls_citnbr =  Trim(ldw_x.Object.citnbr[i])
		
		//	If ls_citnbr = '1' or ls_citnbr = '2' Then 
		If ls_citnbr = '1' Then
			MessageBox('확인','출하등록 완료된 상태입니다. 삭제불가능합니다.')
			Return
		End iF
	End iF
	
	ldw_x.ScrollToRow(i)
	ldw_x.DeleteRow(i)
	
Next

if ldw_x.Update() = 1 then
	
	commit ;
	sle_msg.text =	"모든자료를 삭제하였습니다!!"	
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
ldw_x.SetRedraw(TRUE)




end event

type pb_1 from u_pb_cal within w_sm10_0030
integer x = 814
integer y = 276
integer height = 76
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('jisi_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'jisi_date', gs_code)

end event

type dw_d2 from datawindow within w_sm10_0030
integer x = 882
integer y = 1172
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "D2"
string dataobject = "d_sm10_0030_d2"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

event doubleclicked;String ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itnbr
			
//DataWindow 크기 재정의			
dw_d2_detail.x = 443
dw_d2_detail.y = 1196
dw_d2_detail.Width = 3621
dw_d2_detail.Height = 1144

//DoubleClick한 Row의 PK 값을 받아온다
ls_sabu    = This.GetItemString(This.GetRow(), "van_hkcd2_sabu")
ls_doccode = This.GetItemString(This.GetRow(), "van_hkcd2_doccode")
ls_custcd  = This.GetItemString(This.GetRow(), "van_hkcd2_custcd")
ls_factory = This.GetItemString(This.GetRow(), "van_hkcd2_factory")
ls_itnbr   = This.GetItemString(This.GetRow(), "van_hkcd2_itnbr")

dw_d2_detail.Visible = True

dw_d2_detail.Retrieve(ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itnbr)
end event

type dw_d0 from datawindow within w_sm10_0030
integer x = 174
integer y = 1172
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "D0"
string dataobject = "d_sm10_0030_d0"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

event itemfocuschanged;
If row < 1 Then Return

String ls_factory

ls_factory  = Trim(object.factory[row])

idwc_d0.Retrieve(ls_factory)
end event

type dw_d68 from datawindow within w_sm10_0030
integer x = 1591
integer y = 1176
integer width = 686
integer height = 400
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "D68"
string dataobject = "d_sm10_0030_d68"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_gi from datawindow within w_sm10_0030
integer x = 2309
integer y = 1184
integer width = 686
integer height = 400
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "긴급"
string dataobject = "d_sm10_0030_gi"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_dh from datawindow within w_sm10_0030
integer x = 3022
integer y = 1188
integer width = 686
integer height = 400
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "DH"
string dataobject = "d_sm10_0030_dh"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_p6 from datawindow within w_sm10_0030
integer x = 183
integer y = 1624
integer width = 686
integer height = 400
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "P6"
string dataobject = "d_sm10_0030_p6"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

event doubleclicked;String ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itemser, ls_itemname, ls_itemcode
			
//DataWindow 크기 재정의			
dw_d2_detail.x = 475
dw_d2_detail.y = 1304
dw_d2_detail.Width = 3621
dw_d2_detail.Height = 1064

//DoubleClick한 Row의 PK 값을 받아온다
ls_sabu    = This.GetItemString(This.GetRow(), "sabu")
ls_doccode = This.GetItemString(This.GetRow(), "doccode")
ls_custcd  = This.GetItemString(This.GetRow(), "custcd")
ls_factory = This.GetItemString(This.GetRow(), "factory")
ls_itemser   = This.GetItemString(This.GetRow(), "itemser")
ls_itemname  = This.GetItemString(This.GetRow(), "itemname")
ls_itemcode  = This.GetItemString(This.GetRow(), "itemcode")

dw_d2_detail.Visible = True

//해당 상세 DataWindow를 연결한다.
dw_d2_detail.DataObject = "d_sm10_p0030_p6_detail"
dw_d2_detail.SetTransObject(SQLCA)

dw_d2_detail.Retrieve(ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itemser, ls_itemname, ls_itemcode)
end event

type dw_p7 from datawindow within w_sm10_0030
integer x = 878
integer y = 1628
integer width = 686
integer height = 400
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "P7"
string dataobject = "d_sm10_0030_p7"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

event doubleclicked;String ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itemser, ls_itemname, ls_itemcode
			
//DataWindow 크기 재정의			
dw_d2_detail.x = 635
dw_d2_detail.y = 1624
dw_d2_detail.Width = 3323
dw_d2_detail.Height = 716

//DoubleClick한 Row의 PK 값을 받아온다
ls_sabu    = This.GetItemString(This.GetRow(), "sabu")
ls_doccode = This.GetItemString(This.GetRow(), "doccode")
ls_custcd  = This.GetItemString(This.GetRow(), "custcd")
ls_factory = This.GetItemString(This.GetRow(), "factory")
ls_itemser   = This.GetItemString(This.GetRow(), "itemser")
ls_itemname  = This.GetItemString(This.GetRow(), "itemname")
ls_itemcode  = This.GetItemString(This.GetRow(), "itemcode")

dw_d2_detail.Visible = True

//해당 상세 DataWindow를 연결한다.
dw_d2_detail.DataObject = "d_sm10_p0030_p7_detail"
dw_d2_detail.SetTransObject(SQLCA)

dw_d2_detail.Retrieve(ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itemser, ls_itemname, ls_itemcode)
end event

type dw_d1 from datawindow within w_sm10_0030
integer x = 1573
integer y = 1628
integer width = 686
integer height = 400
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "D1"
string dataobject = "d_sm10_0030_d1"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_d9 from datawindow within w_sm10_0030
integer x = 2299
integer y = 1632
integer width = 686
integer height = 400
integer taborder = 100
boolean bringtotop = true
boolean titlebar = true
string title = "D9"
string dataobject = "d_sm10_0030_d9"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type dw_d3 from datawindow within w_sm10_0030
integer x = 3031
integer y = 1632
integer width = 686
integer height = 400
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "D3"
string dataobject = "d_sm10_0030_d3"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;f_multi_select(this)
end event

type st_state from statictext within w_sm10_0030
boolean visible = false
integer x = 1691
integer y = 936
integer width = 1440
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "데이타를 읽는 중입니다..."
alignment alignment = center!
boolean focusrectangle = false
end type

type tab_1 from tab within w_sm10_0030
integer x = 18
integer y = 396
integer width = 4594
integer height = 1932
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;String ls_gubun , ls_jisi_date , ls_jisi_date2
dw_ip.AcceptText()
ls_gubun = Trim(dw_ip.Object.gubun[1])
ls_jisi_date = Trim(dw_ip.Object.jisi_date[1])
ls_jisi_date2 = Trim(dw_ip.Object.jisi_date2[1])
IF newindex = 1 Then
	
	dw_ip.DataObject = "d_sm10_0030_1"
	
	dw_d0.visible = False
	dw_d2.visible = False
	dw_d68.visible = False
	dw_gi.visible = False
	dw_dh.visible = False
	dw_p6.visible = False
	dw_p7.visible = False
	dw_d1.visible = False
	dw_d9.visible = False
	dw_d3.visible = False
	
	dw_list.visible = True
//	p_excel.visible = True
	pb_2.visible = False
	p_search.visible = True
//	cb_d9_et.visible = True
Else

	dw_ip.DataObject = "d_sm10_0030_2"
//	p_excel.visible = False
	pb_2.visible = True
	p_search.visible = False
//	cb_d9_et.visible = False

	Choose Case ls_gubun
		Case 'D0'
			
				dw_d0.x = dw_list.x
				dw_d0.y = dw_list.y
				dw_d0.width  = dw_list.width
				dw_d0.height = dw_list.height
				
				dw_list.visible = False
				
				dw_d0.visible = True
				dw_d2.visible = False
				dw_d68.visible = False
				dw_gi.visible = False
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False
				dw_d1.visible = False
				dw_d9.visible = False
				dw_d3.visible = False
			
		Case 'D2'
			
				dw_d2.x = dw_list.x
				dw_d2.y = dw_list.y
				dw_d2.width  = dw_list.width
				dw_d2.height = dw_list.height
				
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_d2.visible = True
				dw_d68.visible = False
				dw_gi.visible = False
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False
				dw_d1.visible = False
				dw_d9.visible = False
				dw_d3.visible = False
			
		Case 'D6'
			
				dw_d68.x = dw_list.x
				dw_d68.y = dw_list.y
				dw_d68.width  = dw_list.width
				dw_d68.height = dw_list.height
				
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_d2.visible = False
				dw_d68.visible = True
				dw_gi.visible = False
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False
				dw_d1.visible = False
				dw_d9.visible = False
				dw_d3.visible = False
			
		Case 'D8'
			
				dw_d68.x = dw_list.x
				dw_d68.y = dw_list.y
				dw_d68.width  = dw_list.width
				dw_d68.height = dw_list.height
				
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_d2.visible = False
				dw_d68.visible = True
				dw_gi.visible = False
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False
				dw_d1.visible = False
				dw_d9.visible = False
				dw_d3.visible = False
			
		Case 'GI'
			
				dw_gi.x = dw_list.x
				dw_gi.y = dw_list.y
				dw_gi.width  = dw_list.width
				dw_gi.height = dw_list.height
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_d2.visible = False
				dw_d68.visible = False
				dw_gi.visible = True
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False
				dw_d1.visible = False
				dw_d9.visible = False
				dw_d3.visible = False
			
		Case 'DH'
			
				dw_dh.x = dw_list.x
				dw_dh.y = dw_list.y
				dw_dh.width  = dw_list.width
				dw_dh.height = dw_list.height
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_d2.visible = False
				dw_d68.visible = False
				dw_gi.visible = False
				dw_dh.visible = True
				dw_p6.visible = False
				dw_p7.visible = False
				dw_d1.visible = False
				dw_d9.visible = False
				dw_d3.visible = False
			
		Case 'P6'
			
				dw_p6.x = dw_list.x
				dw_p6.y = dw_list.y
				dw_p6.width  = dw_list.width
				dw_p6.height = dw_list.height
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_d2.visible = False
				dw_d68.visible = False
				dw_gi.visible = False
				dw_dh.visible = False
				dw_p6.visible = True
				dw_p7.visible = False
				dw_d1.visible = False
				dw_d9.visible = False
				dw_d3.visible = False
			
		Case 'P7'
			
				dw_p7.x = dw_list.x
				dw_p7.y = dw_list.y
				dw_p7.width  = dw_list.width
				dw_p7.height = dw_list.height
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_d2.visible = False
				dw_d68.visible = False
				dw_gi.visible = False
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = True
				dw_d1.visible = False
				dw_d9.visible = False
				dw_d3.visible = False
		
		Case 'D1'
			
				dw_d1.x = dw_list.x
				dw_d1.y = dw_list.y
				dw_d1.width  = dw_list.width
				dw_d1.height = dw_list.height
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_d2.visible = False
				dw_d68.visible = False
				dw_gi.visible = False
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False
				dw_d1.visible = True
				dw_d9.visible = False
				dw_d3.visible = False
		
		Case 'D9'
			
				dw_d9.x = dw_list.x
				dw_d9.y = dw_list.y
				dw_d9.width  = dw_list.width
				dw_d9.height = dw_list.height
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_d2.visible = False
				dw_d68.visible = False
				dw_gi.visible = False
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False
				dw_d1.visible = False
				dw_d9.visible = True
				dw_d3.visible = False
		
		Case 'D3'
			
				dw_d3.x = dw_list.x
				dw_d3.y = dw_list.y
				dw_d3.width  = dw_list.width
				dw_d3.height = dw_list.height
				dw_list.visible = False
				
				dw_d0.visible = False
				dw_d2.visible = False
				dw_d68.visible = False
				dw_gi.visible = False
				dw_dh.visible = False
				dw_p6.visible = False
				dw_p7.visible = False
				dw_d1.visible = False
				dw_d9.visible = False
				dw_d3.visible = True
		
	End Choose
End If

dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_ip.Modify("saupj.protect=1")
   End if
End If

dw_ip.Object.jisi_date[1] = ls_jisi_date
dw_ip.Object.jisi_date2[1] = ls_jisi_date2

IF newindex = 1 Then
	
	If ls_gubun = '' Or isNull(ls_gubun) Then
		ls_gubun ='AL'
	End If
   
	dw_ip.Object.gubun[1] = ls_gubun
	
Else
	If ls_gubun = 'AL' Then 
		dw_ip.Object.gubun[1] = 'D1'
		wf_choose('D1')
	Else
		dw_ip.Object.gubun[1] =  ls_gubun
	End iF
End if



end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4558
integer height = 1804
long backcolor = 32106727
string text = " VAN 자료 생성"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "Compile!"
long picturemaskcolor = 536870912
rr_1 rr_1
end type

on tabpage_1.create
this.rr_1=create rr_1
this.Control[]={this.rr_1}
end on

on tabpage_1.destroy
destroy(this.rr_1)
end on

type rr_1 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 9
integer y = 16
integer width = 4535
integer height = 1780
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4558
integer height = 1804
long backcolor = 32106727
string text = " VAN 자료 조회"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "Asterisk!"
long picturemaskcolor = 536870912
rr_2 rr_2
end type

on tabpage_2.create
this.rr_2=create rr_2
this.Control[]={this.rr_2}
end on

on tabpage_2.destroy
destroy(this.rr_2)
end on

type rr_2 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 9
integer y = 16
integer width = 4535
integer height = 1780
integer cornerheight = 40
integer cornerwidth = 55
end type

type pb_2 from u_pb_cal within w_sm10_0030
boolean visible = false
integer x = 1298
integer y = 276
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('jisi_date2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'jisi_date2', gs_code)

end event

type p_excel from uo_picture within w_sm10_0030
integer x = 4421
integer y = 240
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
end type

event clicked;call super::clicked;DataWindow ldw_x

if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1


If Tab_1.SelectedTab = 1 Then	
	ldw_x = dw_list
Else
	String ls_gubun
	
	ls_gubun = Trim(dw_ip.Object.gubun[1]) 
	
	Choose Case ls_gubun 
		Case 'D0'
			ldw_x = dw_d0
		Case 'D2'
			ldw_x = dw_d2
		Case 'D6'
			ldw_x = dw_d68
		Case 'D8'
			ldw_x = dw_d68
		Case 'GI'
			ldw_x = dw_gi
		Case 'DH'
			ldw_x = dw_dh
		Case 'P6'
			ldw_x = dw_p6
		Case 'P7'
			ldw_x = dw_p7
		Case 'D1'
			ldw_x = dw_d1
		Case 'D9'
			ldw_x = dw_d9
		Case 'D3'
			ldw_x = dw_d3
		
	End Choose
End if

string ls_path, ls_file
int li_rc

If ldw_x.RowCount() < 1 Then Return
If this.Enabled Then wf_excel_down(ldw_x)
//li_rc = GetFileSaveName ( "Select File", ls_path, ls_file, "XLS", "Excel Files (*.xls),*.xls",'C:\HKC\', 32770)
//ldw_x.SaveAs(ls_path, Excel!, FALSE)
end event

type st_caption from statictext within w_sm10_0030
integer x = 1207
integer y = 416
integer width = 1902
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
boolean focusrectangle = false
end type

type p_mod from uo_picture within w_sm10_0030
integer x = 4247
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;If Tab_1.SelectedTab = 2 Then
	
	If dw_ip.AcceptText() < 1 Then Return
	
	If Trim(dw_ip.Object.gubun[1]) = "D0" Then
		
	   if f_msg_update() < 1 Then Return
		
		If dw_d0.AcceptText() < 1 Then Return
		
		If dw_d0.Update() < 1 Then
			MessageBox("DB ERROR",sqlca.sqlerrText)
			Rollback;
			Return
		Else
			Commit;
		End iF
	End IF

Else
	MessageBox('확인','조회 상태에만 저장 가능합니다.')
	Return
End IF
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type cb_d9_et from commandbutton within w_sm10_0030
boolean visible = false
integer x = 3346
integer y = 252
integer width = 530
integer height = 128
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "월검수등록(기타)"
end type

event clicked;uo_xlobject uo_xl , uo_xltemp
string ls_doccode, ls_ipsource, ls_ipgubun
string ls_mitnbr, ls_mcvcod, ls_mdcvcod, ls_citnbr, ls_CRT_DATE, ls_CRT_TIME
String ls_saupj , ls_itnbr , ls_ymd ,ls_plant,ls_factory ,ls_cvcod ,ls_btime , ls_arrymd , ls_arrtime
string ls_docname, ls_named[] ,ls_line 
Long   ll_xl_row , ll_r , ix ,i , ll_cnt=0 , ll_c , ll_value , iii=0
Long   ll_err , ll_succeed  
String ls_file , ls_orderno
Long ll_seq , ll_jpno  , ll_count
String ls_custcd , ls_iojpno[]
double ld_IPTQTY,ld_IPTAMT,ld_PACKTAMT

If dw_ip.AcceptText() <> 1 Then Return

ls_saupj = Trim(dw_ip.Object.saupj[1]) 


// 엘셀 IMPORT ***************************************************************
ll_value = GetFileOpenName("일일 납품실적 데이타 가져오기", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")
If ll_value <> 1 Then Return

Setpointer(Hourglass!)

ll_err = 0
ll_succeed = 0
ll_cnt = 0

If  FileExists('c:\erpman\bin\date_conv.xls') = False Then
	MessageBox('확인','date_conv.xls'+' 파일이 존재하지 않습니다.')
	Return
End If 

uo_xltemp = create uo_xlobject
uo_xltemp.uf_excel_connect('c:\erpman\bin\date_conv.xls', false , 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1,1, '@' + space(30))

st_state.visible = True

Select fun_get_reffpf_value('AD' , :ls_saupj , 4 ) Into :ls_custcd from dual ; 

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	st_state.text = ls_file + " 파일을 읽고 있습니다."
	
	If  FileExists(ls_file) = False Then
		MessageBox('확인',ls_file+' 파일이 존재하지 않습니다.')
		st_state.visible = false
		Return
	End If 
	
			
	//엑셀과 연결
	uo_xl = create uo_xlobject
	uo_xl.uf_excel_connect(ls_file, false , 3)
	uo_xl.uf_selectsheet(1)
	
	ll_cnt = 0
	//Data 시작 Row Setting
	ll_xl_row = 6		

	Do While(True)
		
		//Data가 없을경우엔 Return...........
		if isnull(uo_xl.uf_gettext(ll_xl_row,2)) or trim(uo_xl.uf_gettext(ll_xl_row,2)) = '' then exit
		
		For i =1 To 15
			uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))
		Next
		
		SetNull(ls_mitnbr)
		SetNull(ls_mcvcod)
		SetNull(ls_mdcvcod)
		SetNull(ls_citnbr)
		
		ll_cnt ++
		yield()
	
		ls_doccode = Trim(uo_xl.uf_gettext(ll_xl_row,2))
		ls_custcd  = ls_custcd
		ls_factory = Trim(uo_xl.uf_gettext(ll_xl_row,3))
		ls_itnbr   = Trim(uo_xl.uf_gettext(ll_xl_row,4))
		ls_ipsource= 'V'
		ls_ipgubun = 'A'
		
		st_state.text =String(ll_xl_row) +" 행의 " +ls_itnbr+ ' 품번을 읽고 있습니다.'
	
		If isNull(ls_ipsource)  Or ls_ipsource = "" Then ls_ipsource = "."	
		If isNull(ls_ipgubun)  Or ls_ipgubun = "" Then  ls_ipgubun = "." 
	
		ld_iptqty  = Long(Trim(uo_xl.uf_gettext(ll_xl_row,7)))
		ld_iptamt  = Long(Trim(uo_xl.uf_gettext(ll_xl_row,8)))
		ld_packtamt= 0
		
		
		//공장별 거래처 읽어오기
		select fun_get_scvcod( :ls_factory , :ls_mitnbr ,''  ),
				 nvl(RFNA3,'')
		  Into :ls_mcvcod , :ls_mdcvcod
		  from reffpf 
		where sabu = :gs_sabu and
				rfcod = '2A' and
				rfgub = :ls_factory;
				
		if sqlca.sqlcode <> 0 or &
			trim(ls_mcvcod)	= '' or trim(ls_mdcvcod) = '' or &
			isNull(ls_mcvcod)	 or isNull(ls_mdcvcod) then
			wf_error(ls_file,ll_cnt,ls_doccode,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 납품공장-거래처 코드가 없습니다.')
			ll_err++
			Continue ;
		end if
		
		ls_mcvcod = trim(ls_mcvcod)
		ls_mdcvcod = trim(ls_mdcvcod)
	
		// 한텍 요청 //////////////////////////////////////////////////////
		ll_cnt = 0 
		select count(*) Into :ll_cnt
		  from van_hkcd9
		 where SABU=   :gs_SABU
			and DOCCODE = :ls_DOCCODE   
			and CUSTCD = :ls_CUSTCD  
			and FACTORY = :ls_FACTORY 
			and ITNBR = :ls_ITNBR 
			and IPSOURCE = :ls_ipsource 
			and IPGUBUN = :ls_ipgubun ;
			
		If ll_cnt > 0 Then
			wf_error(ls_file,ll_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(ll_cnt)+']')
			Continue ;
		end if
		
	
		/////////////////////////////////////////////////////////
		insert into van_hkcd9(SABU,DOCCODE,CUSTCD,FACTORY,ITNBR,IPSOURCE,IPGUBUN,IPTQTY,IPTAMT,PACKTAMT,CRT_DATE,CRT_TIME,CRT_USER,CITNBR,
													MITNBR,MCVCOD,MDCVCOD)       
						values(:gs_SABU,:ls_DOCCODE,:ls_CUSTCD,:ls_FACTORY,:ls_ITNBR,:ls_IPSOURCE,:ls_IPGUBUN,:ld_IPTQTY,:ld_IPTAMT,:ld_PACKTAMT,:ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,NULL,
									  :ls_ITNBR,:ls_MCVCOD,:ls_MDCVCOD);
	
		if sqlca.sqlcode <> 0 then		
			wf_error(ls_file,ll_cnt,ls_doccode,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(ll_cnt)+']')
			rollback;
			uo_xltemp.uf_excel_Disconnect()
			uo_xl.uf_excel_Disconnect()
			st_state.visible = false
			return
		end if

		ll_xl_row ++		
		ll_succeed++
		
		w_mdi_frame.sle_msg.text = ls_named[ix]+ ' 파일의 '+String(ll_xl_row) + '행을 읽고 있습니다.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	// 엘셀 IMPORT  END ***************************************************************

Next

//st_state.text =' 데이타를 저장 중입니다.'

commit;

st_state.visible = false
uo_xltemp.uf_excel_Disconnect()
messagebox('확인','데이타 접수완료!!!')
st_state.text =''
end event

type cb_1 from commandbutton within w_sm10_0030
boolean visible = false
integer x = 3346
integer y = 100
integer width = 530
integer height = 128
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "위아포승생성"
end type

event clicked;Long   lvalue
Long   lXlrow
Long   i
Long   ll_balqty
Long   lcnt
Long   li_cnt
Long   ll_check
Long   ll_cnt
Int    iNotNullCnt
String ls_orderno
String ls_napdat
String ls_seqno
String ls_factory
String ls_mcvcod
String ls_mdcvcod
String sdocname
String snamed
String ls_doccode
String ls_itnbr
String ls_mitnbr
String ls_ordergb

// 액셀 IMPORT ***************************************************************

lValue = GetFileOpenName("파일선택", sDocname, sNamed, "XLS", "XLS Files (*.XLS),*.XLS", "C:\HKC\VAN")
If lValue <> 1 Then Return

Setpointer(Hourglass!)

////===========================================================================================
////UserObject 생성
w_mdi_frame.sle_msg.text = "액셀 업로드 준비중..."

uo_xlobject	uo_xl
uo_xl = create uo_xlobject

//엑셀과 연결
uo_xl.uf_excel_connect(sDocname, false , 3)
uo_xl.uf_selectsheet(1)

//Data 시작 Row Setting (행)
//Excel 에서 A:1, B:1 로 시작 

lXlrow = 9		// 9번 헤드부터 진행 

String ls_jisidat

ls_jisidat = dw_ip.GetItemString(1, 'jisi_date')
If Trim(ls_jisidat) = '' OR IsNull(ls_jisidat) Then
	MessageBox('기준일자 확인', '기준일자를 입력하십시오.')
	dw_ip.SetColumn('jisi_date')
	dw_ip.SetFocus()
	Return
End If

Do While(True)
	li_cnt ++
	
	iNotNullCnt = 0
	
	// Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
	// 총 22개 열로 구성
	For i =1 To 22
		uo_xl.uf_set_format(lXlrow, i, '@' + space(50))
	Next
	
	ls_orderno = Trim(uo_xl.uf_gettext(lXlrow, 1))			//발주번호
	ls_napdat  = Trim(uo_xl.uf_gettext(lXlrow, 12))			//납품일
	//발주번호 "4500720111(00010)" -> 4500720111, 00010형식으로 변경
	//납품일 "2009.05.28" -> "20090528" 형식으로 변경
	SELECT SUBSTR(REPLACE(REPLACE(:ls_orderno, '(', ''), ')', ''), 1, 10),
          SUBSTR(REPLACE(REPLACE(:ls_orderno, '(', ''), ')', ''), 11, 5),
			 REPLACE(:ls_napdat, '.', '')
	  INTO :ls_orderno, :ls_seqno, :ls_napdat //발주번호, 발주순번, 납품일
	  FROM DUAL ;
	
	ls_factory = Trim(uo_xl.uf_gettext(lXlrow, 5))			//공장
	SELECT RFNA2, RFNA3
	  INTO :ls_mcvcod, :ls_mdcvcod
     FROM REFFPF
    WHERE RFCOD = '2A'
      AND RFGUB = :ls_factory ;
	
	ll_balqty  = Long(Trim(uo_xl.uf_gettext(lXlrow, 7)))	//발주수량
	
	ls_doccode = 'D6' + ls_jisidat + 'WP'						//문서코드
	
	ls_itnbr   = Trim(uo_xl.uf_gettext(lXlrow, 3))			//품번
	//품번 제일 앞자리에 'A'코드가 있을 경우는 위아포승 CKD발주 - 'A'코드 제외한 나머지는 품번코드
	If LEFT(ls_itnbr, 1) = 'A' Then
		ls_itnbr   = MID(ls_itnbr, 2, LEN(ls_itnbr))
		ls_ordergb = 'A'
	End If
	
	SELECT ITNBR
	  INTO :ls_mitnbr
	  FROM ITEMAS
	 WHERE REPLACE(ITNBR, '-', '') = :ls_itnbr ;
	If Trim(ls_mitnbr) = '' OR IsNull(ls_mitnbr) Then
		MessageBox('품번확인', ls_itnbr + '은(는) 미 등록된 품번입니다.')
		uo_xl.uf_excel_Disconnect()
		DESTROY uo_xl
		Return
	End If
	
	ls_mitnbr = sqlca.fun_get_buitnbr(ls_itnbr , '') ;	
	if trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then		
		wf_error('WP-D68',li_cnt,ls_doccode,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.')		
		Continue ;
	End IF
	
	//중복 스킵	
	ll_check = 0 
	
	Select Count(*) Into :ll_check
	  From van_hkcd68
	 Where sabu = :gs_sabu
		and custcd = 'P655'
		and itnbr = :ls_itnbr 
		and factory = :ls_factory
		and order_qty = :ll_balqty
		and orderno = :ls_orderno
		and to_orderno = :ls_seqno ;			
	If ll_check > 0 Then Continue;
	
	// 한텍 요청 //////////////////////////////////////////////////////
   ll_cnt = 0 
	select count(*) Into :ll_cnt
	  from van_hkcd68
	 where SABU=   :gs_SABU
		and DOCCODE = :ls_DOCCODE   
		and CUSTCD = 'P655'  
		and FACTORY = :ls_FACTORY 
		and ITNBR = :ls_ITNBR 
		and ORDERNO = :ls_ORDERNO ;
		
	If ll_cnt > 0 Then
		wf_error('WP-D68',li_cnt,ls_doccode,ls_factory,ls_itnbr," 이미 입력된 데이타입니다.(계속진행..)" + '[열위치:'+string(li_cnt)+']')
		Continue ;
	end if	
	/////////////////////////////////////////////////////////
	
	If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then
		Exit
	Else
		iNotNullCnt++
		
		INSERT INTO VAN_HKCD68
		(SABU      , DOCCODE   , CUSTCD    , FACTORY    , ITNBR    , ORDER_GB, ORDERNO     , ORDER_QTY      ,
		 IPDAN     , ORDER_DATE, ORDER_TYPE, ORDER_TIME , ORDER_MIN, PACKUNI , FORM_ORDERNO, COUNTRY_CARKIND,
		 TO_ORDERNO, LOCNO_CKD , YARDNO_CKD, PACKCON_CKD, CRT_DATE , CRT_TIME, CRT_USER    , MITNBR         ,
		 MCVCOD    , MDCVCOD   , CITNBR    , SEQNO      , BALYN    , ORDER_DATE_HANTEC)
		VALUES
		(:gs_sabu  , :ls_doccode, 'P655', :ls_factory, :ls_itnbr                   , :ls_ordergb                 , :ls_orderno, :ll_balqty,
		 0         , :ls_napdat , '6'   , NULL       , NULL                        , NULL                        , NULL       , NULL      ,
		 :ls_seqno , NULL       , NULL  , NULL       , TO_CHAR(SYSDATE, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'HH24MISS'), :gs_empno  , :ls_mitnbr,
		 :ls_mcvcod, :ls_mdcvcod, NULL  , 0          , NULL                        , NULL) ;
		If SQLCA.SQLCODE <> 0 Then
			MessageBox('생성오류' + String(SQLCA.SQLCODE), '자료 추가 중 오류가 발생했습니다. ~r~n~n' + SQLCA.SQLERRTEXT)
			uo_xl.uf_excel_Disconnect()
			DESTROY uo_xl
			Return
		End If
		
		lCnt++
	End If
	
	// 해당 행의 어떤 열에도 값이 지정되지 않았다면 파일 끝으로 인식해서 임포트 종료
	If iNotNullCnt = 0 Then Exit
	
	lXlrow ++
Loop
uo_xl.uf_excel_Disconnect()


//// 엘셀 IMPORT  END ***************************************************************
//dw_insert.AcceptText()

MessageBox('확인', String(lCnt) + ' 건의 DATA IMPORT를 완료하였습니다.')
w_mdi_frame.sle_msg.text = ""
DESTROY uo_xl
end event

type dw_d2_detail from datawindow within w_sm10_0030
boolean visible = false
integer x = 1097
integer y = 1792
integer width = 3621
integer height = 1172
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "소요량 상세"
string dataobject = "d_sm10_p0030_d2_detail"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;This.Visible = False
end event

