$PBExportHeader$w_pig2003.srw
$PBExportComments$교육훈련 이수결과등록
forward
global type w_pig2003 from w_inherite_standard
end type
type gb_5 from groupbox within w_pig2003
end type
type dw_emp from datawindow within w_pig2003
end type
type dw_mst from datawindow within w_pig2003
end type
type pb_1 from picturebutton within w_pig2003
end type
type pb_2 from picturebutton within w_pig2003
end type
type dw_personal from u_d_select_sort within w_pig2003
end type
type uo_progress from u_progress_bar within w_pig2003
end type
type dw_total from u_d_select_sort within w_pig2003
end type
type p_1 from uo_picture within w_pig2003
end type
type gb_4 from groupbox within w_pig2003
end type
type rr_1 from roundrectangle within w_pig2003
end type
end forward

global type w_pig2003 from w_inherite_standard
string title = "교육훈련 이수결과 등록"
gb_5 gb_5
dw_emp dw_emp
dw_mst dw_mst
pb_1 pb_1
pb_2 pb_2
dw_personal dw_personal
uo_progress uo_progress
dw_total dw_total
p_1 p_1
gb_4 gb_4
rr_1 rr_1
end type
global w_pig2003 w_pig2003

type variables
str_edu istr_edu
//Y : 신규등록, N : 조회
string is_gub 


end variables

forward prototypes
public function integer wf_reper (string arg_no, string arg_year, long arg_seq)
public function integer wf_retot (string arg_no, string arg_year, long arg_seq)
public function integer wf_pedu ()
public subroutine wf_init ()
public subroutine wf_setting_retrievemode (string mode)
public function long wf_date (string sdate, string edate)
public function long wf_time (string stime, string etime)
public function integer wf_required_chk ()
public function integer wf_totupdate (long arg_cnt)
public function long wf_count ()
end prototypes

public function integer wf_reper (string arg_no, string arg_year, long arg_seq);dw_personal.setredraw(false)
dw_personal.SetTransObject(sqlca)
dw_personal.reset()
dw_personal.insertrow(0)

dw_personal.retrieve(gs_company, arg_no, arg_year, arg_seq)

dw_personal.setredraw(true)

return 1
end function

public function integer wf_retot (string arg_no, string arg_year, long arg_seq);dw_total.setredraw(false)

dw_total.SetTransObject(sqlca)
dw_total.reset()
dw_total.insertrow(0)

dw_total.retrieve(gs_company, arg_no, arg_year, arg_seq)

dw_total.setredraw(true)

return 1
end function

public function integer wf_pedu ();/*  wf_pedu()  교육계획 자료를 넘기기 위한 함수             */
/* return -1 : 실패                                         */
/* return 1 : 정상, return : 2 실적순번을 조회하기 위한 값  */

string ls_code, ls_empno, ls_peduyear
long ll_pempseq, ll_empseq, ll_cnt, ll_emp_empseq
int ll_msg

string  get_company,   get_empno,   get_eduyear,   get_sdate,  get_edate, &
         get_egubn,    get_eoffice, get_edept,     get_ekind,  get_eduteacher,   &
         get_edudepmentt,  get_edugubn, get_eduarea,   get_eduarea1,  get_edubook,   &
         get_edubook1,  get_educdesc, get_remark,   get_bgubn,  get_totchk,   &
         get_prostate, get_educur  
			
long get_empseq, &  
     get_datesu, &  
	  get_stime, get_etime,  get_ehour, &
	  get_eno,   &
     get_educost, &  
     get_cost,   &
     get_housepay, &   
     get_amt,   &
     get_daypay, &  
     get_eamt

if dw_emp.AcceptText() = -1 then return -1 
if dw_mst.AcceptText() = -1 then return -1 

ls_code = gs_company

ll_emp_empseq =dw_emp.GetItemNumber(1, 'empseq')
ls_empno = dw_emp.GetItemString(1, 'empno')

ls_peduyear = dw_mst.GetItemString(1, 'peduyear')
ll_pempseq = dw_mst.GetItemNumber(1, 'pempseq')


if isnull(ll_emp_empseq) or trim(string(ll_emp_empseq)) = "" then 
	ll_emp_empseq = 0 
end if 


	SELECT COMPANYCODE, EMPNO, EDUYEAR, EMPSEQ, STARTDATE, ENDDATE, DATESU,       
			 ENO, STARTTIME, ENDTIME, EHOUR, EGUBN, EOFFICE, EDEPT, EKIND,    
			 EDUTEACHER, EDUDEPMENTT, EDUGUBN, EDUAREA, EDUAREA1, EDUBOOK,  
			 EDUBOOK1, EDUCDESC, EDUCOST, COST, HOUSEPAY, AMT, DAYPAY,  
			 EAMT, REMARK, BGUBN, TOTCHK, PROSTATE, EDUCUR     
	 INTO :get_company, :get_empno, :get_eduyear, :get_empseq,  :get_sdate, :get_edate,   
			:get_datesu,  :get_eno,  :get_stime, :get_etime, :get_ehour, :get_egubn, 
			:get_eoffice, :get_edept, :get_ekind, :get_eduteacher, :get_edudepmentt,   
			:get_edugubn, :get_eduarea, :get_eduarea1, :get_edubook, :get_edubook1,   
			:get_educdesc, :get_educost, :get_cost, :get_housepay, :get_amt, :get_daypay,   
			:get_eamt,  :get_remark, :get_bgubn, :get_totchk, :get_prostate, :get_educur  
	 FROM P5_EDUCATIONS_P  
	WHERE ( COMPANYCODE = :ls_code ) AND  
			( EMPNO = :ls_empno ) AND  
			( EDUYEAR = :ls_peduyear ) AND  
			( EMPSEQ = :ll_pempseq );
	if sqlca.sqlcode = 100 then
		MessageBox("확 인", "조회한 교육훈련자료가 ~r존재하지 않습니다.!!")
		return -1
	elseif sqlca.sqlcode < 0 then
		MessageBox("저장중 에러 발생", string(sqlca.sqlcode)+ " : "+ sqlca.SQLErrText)
		return -1 
	end if		
	

if get_totchk <> 'Y' then // 취소
	MessageBox("확 인", "교육훈련계획에서 총무 확인 ~r~r처리를 하지 않았습니다.!!")
	return -1
end if

//중복되는 교육훈련 계획 자료 check
if (isnull(get_eduyear) = false or  trim(get_eduyear) <> "" ) or &
   (isnull(get_empseq) = false or  trim(string(get_empseq)) <> "" ) then
		SELECT "P5_EDUCATIONS_S"."EMPSEQ", count(*)   
			INTO :ll_empseq,   
			     :ll_cnt  
		FROM "P5_EDUCATIONS_S"   
		WHERE ( "P5_EDUCATIONS_S"."COMPANYCODE" = :gs_company ) AND   
		      ( "P5_EDUCATIONS_S"."PEDUYEAR" = :get_eduyear ) AND     
       		( "P5_EDUCATIONS_S"."PEMPSEQ" = :get_empseq ) AND  
				( "P5_EDUCATIONS_S"."EMPNO"   = :get_empno )  AND  
				( "P5_EDUCATIONS_S"."EDUEMPNO" = :get_empno)          
		GROUP BY "P5_EDUCATIONS_S"."EMPSEQ";
	
	if sqlca.sqlcode = 0 and ( ll_cnt > 0 and  ll_empseq <> ll_emp_empseq ) then 
			ll_msg = MessageBox("확 인", "실적순번 : " + &
												string(ll_empseq) + " 로 이미 등록되어 있는 " + "~n" +&
												"계획 자료입니다.!!"+ "~n" + "~n"  + "~n" +&
												"실적 자료를 조회하시겠습니까?", &
												Question!, YesNo!, 2)
			if ll_msg = 1 then // 실적 순번 조회
				dw_emp.SetItem(1, 'empseq', ll_empseq)			
				return 2   // 실적순번을 조회하기 위해서 값을 return
			end if
	elseif sqlca.sqlcode < 0 then
		MessageBox("저장중 에러 발생", string(sqlca.sqlcode)+ " : "+ sqlca.SQLErrText)
		return -1 
	end if		

end if


dw_mst.SetItem(1, 'companycode', gs_company)

dw_mst.SetItem(1, 'empno', get_empno)
dw_mst.SetItem(1, 'eduempno', get_empno)	

dw_mst.SetItem(1, 'eduyear', get_eduyear)   // 실적년도

dw_mst.SetItem(1,'peduyear', get_eduyear)	 // 계획년도
dw_mst.SetItem(1, 'pempseq', get_empseq)	 // 계획순번 
dw_mst.SetItem(1, 'strtdate', get_sdate)   // 계획 시작일자
dw_mst.SetItem(1, 'enddate', get_edate)    // 계획 종료일자


dw_mst.SetItem(1, 'restartdate', get_sdate)  //실교육 시작일자
dw_mst.SetItem(1, 'reenddate', get_edate)    // 실교육 종료일자

dw_mst.SetItem(1, 'datesu', get_datesu)
dw_mst.SetItem(1, 'ekitainwon', get_eno)
dw_mst.SetItem(1, 'starttime', get_stime)
dw_mst.SetItem(1, 'endtime', get_etime)
dw_mst.SetItem(1, 'ehour', get_ehour)
dw_mst.SetItem(1, 'egubn', get_egubn)
dw_mst.SetItem(1, 'eoffice', get_eoffice)
dw_mst.SetItem(1, 'edudept', get_edept)
dw_mst.SetItem(1, 'ekind', get_ekind)
dw_mst.SetItem(1, 'eduteacher', get_eduteacher)
dw_mst.SetItem(1, 'edudepmant', get_edudepmentt)
dw_mst.SetItem(1, 'edugun', get_edugubn)
dw_mst.SetItem(1, 'eduarea', get_eduarea)
dw_mst.SetItem(1, 'eduarea1', get_eduarea1)
dw_mst.SetItem(1, 'edubook', get_edubook)
dw_mst.SetItem(1, 'edubook1', get_edubook1)
dw_mst.SetItem(1, 'edudesc', get_educdesc)
dw_mst.SetItem(1, 'eduamt', get_educost)
dw_mst.SetItem(1, 'cost', get_cost)
dw_mst.SetItem(1, 'housepay', get_housepay)
dw_mst.SetItem(1, 'amt', get_amt)
dw_mst.SetItem(1, 'daypay', get_daypay)
dw_mst.SetItem(1, 'eamt', get_eamt)
dw_mst.SetItem(1, 'reamark', get_remark)
dw_mst.SetItem(1, 'bgubn', get_bgubn)
// 추가 (1999.09.02)
dw_mst.SetItem(1, 'educur', get_educur)

dw_mst.SetColumn('strtdate')
dw_mst.setfocus()

return 1
end function

public subroutine wf_init ();// dw_mst만 초기화 시킴

dw_mst.SetRedraw(false)
dw_total.SetRedraw(false)
dw_personal.SetRedraw(false)


dw_mst.Reset()
dw_total.Reset()
dw_personal.Reset()

dw_mst.insertRow(0)
dw_mst.setItem(1, 'companycode', gs_company)
dw_mst.setItem(1, 'eduyear', dw_emp.GetItemString(1, 'eduyear'))

dw_mst.SetRedraw(true)
dw_total.SetRedraw(true)
dw_personal.SetRedraw(true)
		  
dw_mst.setfocus()
dw_mst.SetColumn("peduyear")

end subroutine

public subroutine wf_setting_retrievemode (string mode);
//dw_mst.SetRedraw(False)
////cb_ins.Enabled =True
//cb_update.Enabled =True
//IF mode ="조회" THEN							//수정
//	dw_mst.SetTabOrder("empno", 0)
//	dw_mst.SetTabOrder("eduyear", 0)
//	dw_mst.SetTabOrder("empseq", 0)
//	dw_mst.SetTabOrder("eduempno",0)
//
//	cb_delete.Enabled =True
//	dw_mst.SetColumn("education1")
//	
//ELSEIF mode ="등록" THEN					//입력
//	dw_mst.SetTabOrder("empno", 10)
//	dw_mst.SetTabOrder("eduyear", 20)
//	dw_mst.SetTabOrder("empseq", 30)
//	dw_mst.SetTabOrder("eduempno", 40)
//	cb_delete.Enabled =False
//	dw_mst.SetColumn("empno")
//END IF
//
//dw_mst.SetFocus()
//dw_mst.SetRedraw(True)
//
end subroutine

public function long wf_date (string sdate, string edate);string temp_date1, temp_date2
long ll_temp1

if isnull(sdate) or sdate = "" then return -1
if isnull(edate) or edate = "" then return -1

temp_date1 = string(left(sdate, 4) + "/"+ mid(sdate, 5,2) + "/" + &
				 right(sdate, 2))
temp_date2 = string(left(edate, 4) + "/"+ mid(edate, 5,2) + "/" + &
				 right(edate, 2))
ll_temp1 = 	daysafter(date(temp_date1), date(temp_date2)) + 1

return ll_temp1

end function

public function long wf_time (string stime, string etime);string ls_stime, ls_etime
long ll_time1, ll_time2

ls_stime = stime
ls_etime = etime

if isnull(ls_stime) or  ls_stime = "" then return -1
if isnull(ls_etime) or  ls_etime = "" then return -1

ll_time1 = (long ( left (ls_etime, 2 ) ) * 60  + long ( right (ls_etime, 2))) - &
				(long ( left (ls_stime, 2 ) ) * 60  + long (right (ls_stime, 2)))

if ll_time1 < 60 then
  	ll_time2	= 0
else 
	ll_time2 = truncate(ll_time1/60, 0) // + (mod(ll_time1, 60 ))/100 
	
end if

return ll_time2

end function

public function integer wf_required_chk ();string ls_peduyear, ls_restartdate, ls_reenddate

long ll_row, ll_pempseq

ll_row = dw_mst.Getrow()


if ll_row <= 0 then return -1

ls_peduyear = dw_mst.GetItemString(ll_row, 'peduyear')
ll_pempseq = dw_mst.GetItemNumber(ll_row, 'pempseq') 

ls_restartdate =  dw_mst.GetItemString(ll_row,'restartdate')
ls_reenddate = dw_mst.GetItemString(ll_row,'reenddate')

if isnull(ls_peduyear) = false then
  If f_datechk(ls_peduyear+'01'+'01') = -1 Then 
      MessageBox("확 인", "유효한 년도가 아닙니다.")	
		dw_mst.setcolumn('peduyear')
		dw_mst.setfocus()
	return -1
  end if
end if

if ( isnull(ls_peduyear) or ls_peduyear = "" ) or &
   ( isnull(ll_pempseq) or string(ll_pempseq) = "" ) then
   dw_mst.SetItem(ll_row, 'bgubn', "S") // 교육계획 자료가 아닌 기타 자료 (S)
end if

if isnull(ls_restartdate) or ls_restartdate = "" then
	MessageBox("확 인", "실적시작일자는 필수입력사항입니다.!!")
	dw_mst.SetColumn('restartdate')
	dw_mst.SetFocus()
	return -1
elseIf f_datechk(ls_restartdate) = -1 Then 
   MessageBox("확 인", "유효한 실적 시작일자가 아닙니다.")	
	dw_mst.SetColumn('restartdate')
	dw_mst.SetFocus()
	return -1
end if	

if isnull(ls_reenddate) or ls_reenddate = "" then
	MessageBox("확 인", "실적종료일자는 필수입력사항입니다.!!")
	dw_mst.SetColumn('reenddate')
	dw_mst.SetFocus()
	return -1
elseIf f_datechk(ls_reenddate) = -1 Then 
   MessageBox("확 인", "유효한 실적 종료일자가 아닙니다.")	
	dw_mst.SetColumn('reenddate')
	dw_mst.SetFocus()
	return -1
end if	

if  ls_restartdate > ls_reenddate then
	MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
							 "클 수는 없습니다.!!", stopsign!)
	return -1
end if

return 1

end function

public function integer wf_totupdate (long arg_cnt);String  ls_code, ls_empno, ls_eduyear, ls_eduempno

string ls_peduyear, &
       ls_psdate, ls_pedate, ls_rsdate, ls_redate, &
		 ls_egubn, ls_eoffice, ls_ekind, ls_eduteacher, &
		 ls_edudepmant, ls_edugun, ls_eduarea, ls_eduarea1, &
       ls_edubook, ls_edubook1, ls_edudesc, ls_edudept, ls_eduno, &
		 ls_remark, ls_bgubn, ls_isu, ls_document, ls_pheungga, ls_educur

long ll_pempseq,  &
     ll_datesu, ll_starttime, ll_endtime, ll_ehour 
double ls_rebackamt, ls_educost

Long   sEmpRow, sRow, rowcnt, ll_empseq, ll_emprow, ll_mstrow
int i

rowcnt =  arg_cnt  // argument 값을 받아서 처리

if dw_emp.AcceptText() = -1 then return -1
if dw_mst.AcceptText() = -1 then return -1

sRow = dw_mst.RowCount()
sEmpRow = dw_emp.RowCount()

if sEmpRow <= 0 then 
	return -1
else
	ll_emprow = dw_emp.getrow()
	if ll_emprow <= 0 then return -1
end if

If sRow <= 0 Then  
	return -1

else
	ll_mstrow = dw_mst.getrow()
	if ll_mstrow <= 0 then return -1		
end if


ls_code = gs_company
ls_empno  = dw_emp.GetItemString(ll_emprow, "empno")

ls_eduyear = dw_emp.GetItemString(ll_emprow, 'eduyear')

if isnull(ls_code) or trim(ls_code) = "" then return -1
if isnull(ls_empno) or trim(ls_empno) = "" then return -1
if isnull(ls_eduyear) or trim(ls_eduyear) = "" then return -1


ls_peduyear  = dw_mst.GetItemString(ll_emprow, "peduyear")   //교육계획 년도
ll_pempseq  = dw_mst.GetItemNumber(ll_mstrow, "pempseq")     //교육계획 순번

ls_eduyear  = dw_mst.GetItemString(ll_mstrow, "eduyear")   //교육실적 년도
ls_rsdate  = dw_mst.GetItemString(ll_mstrow, "restartdate") //교육실적 시작일자
ls_redate  = dw_mst.GetItemString(ll_mstrow, "reenddate")   //교육실적 종료일자
ls_psdate  = dw_mst.GetItemString(ll_mstrow, "strtdate")    //교육계획 시작일자
ls_pedate  = dw_mst.GetItemString(ll_mstrow, "enddate")      //교육계획 종료일자
ll_datesu  = dw_mst.GetItemNumber(ll_mstrow, "datesu")       //실 교육 총일수
ll_starttime  = dw_mst.GetItemNumber(ll_mstrow, "starttime") //시작시간
ll_endtime  = dw_mst.GetItemNumber(ll_mstrow, "endtime")     //종료시간
ll_ehour  = dw_mst.GetItemNumber(ll_mstrow, "ehour")         //총 교육시간
ls_egubn = dw_mst.GetItemString(ll_mstrow, "egubn")          // 교육구분
ls_eoffice = dw_mst.GetItemString(ll_mstrow, "eoffice")      // 교육기관
ls_ekind = dw_mst.GetItemString(ll_mstrow, "ekind")          // 교육종류
ls_eduteacher =dw_mst.GetItemString(ll_mstrow, "eduteacher") // 교육강사명
ls_edudepmant =dw_mst.GetItemString(ll_mstrow, "edudepmant") // 강사소속명
ls_edugun = dw_mst.GetItemString(ll_mstrow, "edugun")        // 법정교육여부
ls_eduarea = dw_mst.GetItemString(ll_mstrow, "eduarea")      // 교육장소
ls_eduarea1 = dw_mst.GetItemString(ll_mstrow, "eduarea1")    // 약도
ls_edubook = dw_mst.GetItemString(ll_mstrow, "edubook")      // 교재명
ls_edubook1 = dw_mst.GetItemString(ll_mstrow, "edubook1")    // 교안명
ls_edudesc = dw_mst.GetItemString(ll_mstrow, "edudesc")      // 교육내용
ls_edudept = dw_mst.GetItemString(ll_mstrow, "edudept")      // 주관부서
ls_eduno = dw_mst.GetItemString(ll_mstrow, "eduno")          // 수료증번호
ls_remark = dw_mst.GetItemString(ll_mstrow, "reamark")        // 사유
ls_bgubn = dw_mst.GetItemString(ll_mstrow, "bgubn")          // 자교구분(계획, 신청, 기타)
ls_isu = dw_mst.GetItemString(ll_mstrow, "isu")              // 이수구분
ls_document = dw_mst.GetItemString(ll_mstrow, "document")    // 보고서 작성 유무
ls_pheungga = dw_mst.GetItemString(ll_mstrow, "pheungga")    // 평가
ls_educur = dw_mst.GetItemString(ll_mstrow, "educur")
ls_rebackamt = dw_mst.GetItemNumber(ll_mstrow, "rebackamt")
ls_educost = dw_mst.GetItemNumber(ll_mstrow, "educost")


//dw_personal.SetItemStatus(rowcnt, 0,Primary!, NotModified!)
//dw_personal.SetItemStatus(rowcnt, 0,Primary!, New!)


dw_personal.setitem(rowcnt, "companycode", ls_code)
dw_personal.setitem(rowcnt, "empno", ls_empno)               // 대표사원

// 실적순번은 함수 밖에서 setting 한다.

dw_personal.SetItem(rowcnt, "peduyear", ls_peduyear )  //교육계획 년도
dw_personal.SetItem(rowcnt, "pempseq", ll_pempseq)     //교육계획 순번
dw_personal.SetItem(rowcnt, "strtdate", ls_psdate)     //교육계획 시작일자
dw_personal.SetItem(rowcnt, "enddate", ls_pedate)      //교육계획 종료일자
dw_personal.SetItem(rowcnt, "eduyear", ls_eduyear)      //교육실적 년도
dw_personal.SetItem(rowcnt, "restartdate", ls_rsdate)  //교육실적 시작일자
dw_personal.SetItem(rowcnt, "reenddate", ls_redate)    //교육실적 종료일자

dw_personal.SetItem(rowcnt, "datesu", ll_datesu)       //실 교육 총일수
dw_personal.SetItem(rowcnt, "starttime", ll_starttime) //시작시간
dw_personal.SetItem(rowcnt, "endtime", ll_endtime)     //종료시간
dw_personal.SetItem(rowcnt, "ehour", ll_ehour)         //총 교육시간
dw_personal.SetItem(rowcnt, "egubn", ls_egubn)          // 교육구분
dw_personal.SetItem(rowcnt, "eoffice", ls_eoffice)      // 교육기관
dw_personal.SetItem(rowcnt, "ekind", ls_ekind)          // 교육종류
dw_personal.SetItem(rowcnt, "eduteacher", ls_eduteacher) // 교육강사명
dw_personal.SetItem(rowcnt, "edudepmant", ls_edudepmant) // 강사소속명
dw_personal.SetItem(rowcnt, "edugun", ls_edugun)        // 법정교육여부
dw_personal.SetItem(rowcnt, "eduarea", ls_eduarea)      // 교육장소
dw_personal.SetItem(rowcnt, "eduarea1", ls_eduarea1)    // 약도
dw_personal.SetItem(rowcnt, "edubook", ls_edubook)      // 교재명
dw_personal.SetItem(rowcnt, "edubook1", ls_edubook1)    // 교안명
dw_personal.SetItem(rowcnt, "edudesc", ls_edudesc)      // 교육내용
dw_personal.SetItem(rowcnt, "edudept", ls_edudept)      // 주관부서
dw_personal.SetItem(rowcnt, "eduno", ls_eduno)          // 수료증번호
dw_personal.SetItem(rowcnt, "reamark", ls_remark)        // 사유
dw_personal.SetItem(rowcnt, "bgubn", ls_bgubn)          // 자교구분(계획, 신청, 기타)
dw_personal.SetItem(rowcnt, "isu", ls_isu)              // 이수구분
dw_personal.SetItem(rowcnt, "document", ls_document)    // 보고서 작성 유무
dw_personal.SetItem(rowcnt, "pheungga", ls_pheungga)    // 평가
dw_personal.SetItem(rowcnt, "educur", ls_educur)        // 교육명
dw_personal.SetItem(rowcnt, "rebackamt", ls_rebackamt)  // 환급비
dw_personal.SetItem(rowcnt, "educost", ls_educost)      // 순교육비
return 1
end function

public function long wf_count ();string ls_company, ls_empno, ls_eduyear
int ll_empseq
//long ll_empseq

if dw_emp.AcceptText() = -1 then return -1

ls_company  = dw_mst.GetItemString(1, 'companycode')
ls_empno    =  dw_mst.GetItemString(1, 'empno')
ls_eduyear  =  dw_mst.GetItemString(1, 'eduyear')		

SELECT max("P5_EDUCATIONS_S"."EMPSEQ")
INTO :ll_empseq  
FROM "P5_EDUCATIONS_S"  
WHERE ( "P5_EDUCATIONS_S"."COMPANYCODE" = :ls_company ) AND  
      ( "P5_EDUCATIONS_S"."EMPNO" = :ls_empno ) AND  
      ( "P5_EDUCATIONS_S"."EDUYEAR" = :ls_eduyear )   ;
if sqlca.sqlcode <> 0 then
	MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
	//f_message_chk(51, "실적등록")
	return -1
end if

if ll_empseq = 0 or isnull(ll_empseq) then
	ll_empseq = 0 
end if

ll_empseq = ll_empseq + 1

dw_emp.SetItem(1, 'empseq', ll_empseq)
dw_mst.SetItem(1, 'empseq', ll_empseq)

dw_emp.SetColumn("empseq")

return 1

end function

on w_pig2003.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.dw_emp=create dw_emp
this.dw_mst=create dw_mst
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_personal=create dw_personal
this.uo_progress=create uo_progress
this.dw_total=create dw_total
this.p_1=create p_1
this.gb_4=create gb_4
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.dw_emp
this.Control[iCurrent+3]=this.dw_mst
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
this.Control[iCurrent+6]=this.dw_personal
this.Control[iCurrent+7]=this.uo_progress
this.Control[iCurrent+8]=this.dw_total
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.gb_4
this.Control[iCurrent+11]=this.rr_1
end on

on w_pig2003.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.dw_emp)
destroy(this.dw_mst)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_personal)
destroy(this.uo_progress)
destroy(this.dw_total)
destroy(this.p_1)
destroy(this.gb_4)
destroy(this.rr_1)
end on

event open;call super::open;dw_emp.SetTransObject(sqlca)
dw_mst.SetTransObject(sqlca)

dw_emp.reset()
dw_mst.reset()

dw_emp.insertrow(0)
dw_mst.insertrow(0)

dw_emp.setItem(1, 'eduyear', string(today(), 'YYYY'))
dw_mst.setItem(1, 'eduyear', string(today(), 'YYYY'))

dw_emp.setfocus()

//dw_1.setitem("empno")

uo_progress.Hide()

is_gub = "등록"

p_del.enabled = false
p_ins.enabled = false
end event

type p_mod from w_inherite_standard`p_mod within w_pig2003
integer x = 3886
end type

event p_mod::clicked;call super::clicked;string ls_emp_company, ls_emp_empno, ls_emp_eduyear, &
       ls_mst_company, ls_mst_empno, ls_mst_eduyear, ls_mst_peduyear, &
       ls_isu, ls_egubn, ls_mst_eduempno, get_eduyear  
long ll_emp_empseq, ll_mst_empseq, ll_mst_pempseq

long ll_empseq, ll_cnt, ll_pempseq,  get_seq, get_empseq
long ll_mrow, ll_ekitainwon, ll_meterPosition

if dw_emp.AcceptText() = -1 then return 
if dw_mst.AcceptText() = -1 then return 

ll_mrow = dw_mst.GetRow()

if ll_mrow <= 0 then return 

//  dw_emp의 값
ls_emp_company  =  dw_emp.GetItemString(1, 'companycode')
ls_emp_empno    =  dw_emp.GetItemString(1, 'empno')
ls_emp_eduyear  =  dw_emp.GetItemString(1, 'eduyear')
ll_emp_empseq  =  dw_emp.GetItemNumber(1, 'empseq')

// 필수 입력사항 check
if isnull(ls_emp_empno) or ls_emp_empno = "" then
	MessageBox("확 인", "사번은 필수 입력사항입니다.!!")
   dw_emp.Setcolumn('empno')
	dw_emp.setfocus()
	return
end if

if isnull(ls_emp_empno) or ls_emp_empno = "" then
	MessageBox("확 인", "실적년도는 필수 입력사항입니다.!!")
   dw_emp.Setcolumn('eduyear')
	dw_emp.setfocus()
	return
end if

if isnull(ll_emp_empseq) or trim(string(ll_emp_empseq)) = "" then 
	ll_emp_empseq = 0 
end if 

// dw_mst의 값
ls_mst_company  =  dw_mst.GetItemString(ll_mrow, 'companycode')
ls_mst_empno    =  dw_mst.GetItemString(ll_mrow, 'empno')
ls_mst_eduyear  =  dw_mst.GetItemString(ll_mrow, 'eduyear')   // 실적년도
ls_mst_eduempno =  dw_mst.GetItemString(ll_mrow, 'eduempno')  // 참석사번

ll_mst_empseq  = dw_mst.GetItemNumber(ll_mrow, 'empseq')      // 실적순번

ls_mst_peduyear = dw_mst.GetItemString(ll_mrow, 'peduyear')  // 계획년도
ll_mst_pempseq  = dw_mst.GetItemNumber(ll_mrow, 'pempseq')   // 계획순번

// 순번이 입력되지 않으면, dw_mst에 값이 들어가지 않는 경우가 있음.

//법인코드
if isnull(ls_mst_company) or ls_mst_company = "" then
	ls_mst_company = gs_company
   dw_mst.SetItem(1, 'companycode', ls_mst_company)	
end if

//사번
if isnull(ls_mst_empno) or trim(ls_mst_empno) = "" then
    ls_mst_empno = ls_emp_empno
    dw_mst.SetItem(1, 'empno', ls_mst_empno)	
end if

//실적년도
if isnull(ls_mst_eduyear) or ls_mst_eduyear = "" then
	ls_mst_eduyear = ls_emp_eduyear
   dw_mst.SetItem(1, 'eduyear', ls_mst_eduyear)	
end if

// 참석 사번은 대표사번과 동일하게 입력(참석사번)
if isnull(ls_mst_eduempno) or ls_mst_eduempno = "" then
	ls_mst_eduempno = ls_emp_empno
   dw_mst.SetItem(1, 'eduempno', ls_mst_eduempno)	
end if

//필수 입력 항목 check
if wf_required_chk() = -1 then return		


ls_isu  =  dw_mst.GetItemString(1, 'isu')		//이수처리 여부 (총무에서 확인)
                                             // 이수처리가 되어 있으면 자료 입력 불가
															// 총무과에서 확인

if ls_isu = "Y" then
	MessageBox("확 인", "이미 이수처리가 되어 있으므로, " + "~n" + "~n" + &
	                    "자료를 수정할 수 없습니다.")
	return
end if 

//중복되는 교육훈련 계획 자료 check
if (isnull(ls_mst_peduyear) = false or  trim(ls_mst_peduyear) <> "" ) or &
   (isnull(ll_mst_pempseq) = false or  trim(string(ll_mst_pempseq)) <> "" ) then
		SELECT "P5_EDUCATIONS_S"."EDUYEAR",   
		       "P5_EDUCATIONS_S"."EMPSEQ", count(*)    
			INTO :get_eduyear, 
			     :get_empseq,  :get_seq  
		FROM "P5_EDUCATIONS_S"   
		WHERE ( "P5_EDUCATIONS_S"."COMPANYCODE" = :gs_company ) AND   
		      ( "P5_EDUCATIONS_S"."PEDUYEAR" = :ls_mst_peduyear ) AND       
       		( "P5_EDUCATIONS_S"."PEMPSEQ" = :ll_mst_pempseq ) AND  
				( "P5_EDUCATIONS_S"."EMPNO"   = :ls_emp_empno )  AND   
				( "P5_EDUCATIONS_S"."EDUEMPNO" = :ls_emp_empno)           
		GROUP BY "P5_EDUCATIONS_S"."EDUYEAR", 
		         "P5_EDUCATIONS_S"."EMPSEQ";     

		if sqlca.sqlcode = 0 and ( get_seq > 0 and  get_empseq <> ll_emp_empseq ) then  
			 MessageBox("확 인", "실적순번 : " + string(get_empseq) + & 
			                     " 로 이미 등록되어 있는 " + "~n" +& 
									  "계획 자료입니다.!!")
			return
		end if 
		if sqlca.sqlcode < 0 then
			MessageBox("저장중 에러 발생", string(sqlca.sqlcode)+ " : "+ sqlca.SQLErrText)
			return 
		end if
end if


if f_msg_update() = -1 then return

  SELECT count(*)
    INTO :ll_cnt   
    FROM "P5_EDUCATIONS_S"  
   WHERE ( "P5_EDUCATIONS_S"."COMPANYCODE" = :gs_company ) AND  
         ( "P5_EDUCATIONS_S"."EMPNO" = :ls_emp_empno ) AND  
         ( "P5_EDUCATIONS_S"."EDUYEAR" = :ls_emp_eduyear ) AND  
         ( "P5_EDUCATIONS_S"."EMPSEQ" = :ll_emp_empseq )   ;
			
if sqlca.sqlcode = 0 and ll_cnt <=0 then
   is_gub = "등록"
elseif sqlca.sqlcode = 0 and ll_cnt > 0 then 
   is_gub = "조회"
end if


if is_gub = "등록"  then
	if wf_count() = -1 then return //자동채번
end if


if dw_mst.update() <> 1 then
   rollback using sqlca;
	MessageBox("확 인", "저장중 오류가 발생하였습니다.!!")
   return 
end if

// 참석 사번의 data를 update 해 준다.

commit using sqlca;


ll_emp_empseq   =  dw_mst.GetItemNumber(1, 'empseq')

int i, ll_irow

ll_irow = dw_personal.rowcount()

if ll_irow > 0 then 
   uo_progress.Show()	
	for i = 1 to ll_irow
//		dw_personal.SetItem(i, 'companycode', ls_mst_company)


		dw_personal.setItem(i, 'empseq', ll_emp_empseq)
      if wf_totupdate(i) = -1 then 
   		MessageBox("확 인", "참석차번 저장중 에러 발생" + dw_personal.GetItemString(i, 'eduempno'))			
			EXIT
		end if
      ll_meterPosition = (i/ ll_irow) * 100		
      uo_progress.uf_set_position (ll_meterPosition)		
	next
	
	if dw_personal.update() <> 1 then
		rollback using sqlca;
		MessageBox("저장실패", "저장중 에러발생")

	else
		commit using sqlca;
	end if
   uo_progress.hide()	
	
//	if dw_personal.update() <> 1 then
//		rollback using sqlca;
//		MessageBox("저장실패", "저장중 에러발생" + dw_personal.GetItemString(i, 'eduempno'))
//
//		return 
//	else
//		commit using sqlca;
//	end if
end if

ls_egubn = dw_mst.GetItemString(1, 'egubn')
ll_ekitainwon = dw_mst.GetItemNumber(1, 'ekitainwon')

// 교육구분 (1 : 사내, 2 : 사외)
if ( ll_ekitainwon > 0 ) and ls_egubn = "1"  then       //사내면, 외인원이 0보다 크면
	wf_reper(ls_emp_empno, ls_emp_eduyear, ll_emp_empseq)
	wf_retot(ls_emp_empno, ls_emp_eduyear, ll_emp_empseq)
else
	
	DELETE FROM p5_educations_s
	  WHERE companycode = :ls_mst_company AND
			  empno = :ls_emp_empno AND 
			  eduyear = :ls_emp_eduyear AND 
			  empseq  = :ll_emp_empseq AND 
			  eduempno <> :ls_emp_empno ; 
	  if sqlca.sqlcode <> 0 then 
		  rollback using sqlca;
		  MessageBox("저장실패", "참석사번 삭제도중 오류발생!!")
		  return
	  end if	
	  commit using sqlca;
		dw_total.reset()	
		dw_personal.reset()		
	  
end if


// 이미 저장이 되었음을 나타냄
w_mdi_frame.sle_msg.text = "자료가 저장되었습니다.!!"

is_gub = "조회"

ib_any_typing = false

dw_emp.enabled = false

p_del.enabled = true
p_ins.enabled = true

end event

type p_del from w_inherite_standard`p_del within w_pig2003
integer x = 4059
end type

event p_del::clicked;call super::clicked;string ls_companycode, ls_empno, ls_eduyear, ls_isu
long ll_empseq
int li_currow

if dw_emp.AcceptText() = -1 then return
if dw_mst.AcceptText() = -1 then return

if f_msg_delete() = -1 then return

ls_companycode = gs_company
ls_empno = dw_emp.GetItemString(1, "empno")
ls_eduyear = dw_emp.GetItemString(1, "eduyear")
ll_empseq = dw_emp.GetItemNumber(1, "empseq")

if isnull(ls_empno) or trim(ls_empno) = "" then 
	MessageBox("확 인",  "대표사번은 필수 입력사항입니다.!!")
	dw_emp.setcolumn('empno')
	dw_emp.setfocus()
	return 
end if

if isnull(ls_eduyear) or trim(ls_eduyear) = "" then 
	MessageBox("확 인",  "실적년도는 필수 입력사항입니다.!!")
	dw_emp.setcolumn('eduyear')
	dw_emp.setfocus()
	return 
end if

if isnull(ll_empseq) or trim(string(ll_empseq)) = ""  or ll_empseq <= 0 then 
	MessageBox("확 인",  "실적순번은 필수 입력사항입니다.!!")
	dw_emp.setcolumn('empseq')
	dw_emp.setfocus()
	return 
end if


ls_isu  =  dw_mst.GetItemString(1, 'isu')		//이수처리 여부 (총무에서 확인)
                                             // 이수처리가 되어 있으면 자료 입력 불가
															// 총무과에서 확인

if ls_isu = "Y" then
	MessageBox("확 인", "이미 이수처리가 되어 있으므로, " + "~n" + "~n" + &
	                    "자료를 삭제할 수 없습니다.")
   w_mdi_frame.sle_msg.text = "자료를 삭제하지 못하였습니다.!!"							  
	return
end if 

dw_mst.SetRedraw(false)		
	
DELETE FROM p5_educations_s
  WHERE companycode = :ls_companycode AND
        empno = :ls_empno AND 
        eduyear = :ls_eduyear AND 
        empseq  = :ll_empseq ; 
  if sqlca.sqlcode <> 0 then 
     rollback using sqlca;
	  MessageBox("확 인", "자료를 삭제하는데, 실패하였습니다.!!")
     return
  end if
		
// 이미 삭제 처리가 되어 저장됨을 나타냄		
ib_any_typing = false

commit using sqlca;
		
w_mdi_frame.sle_msg.text = "자료를 삭제하였습니다.!!"

dw_mst.SetRedraw(true)			

wf_init()

dw_emp.enabled = true

dw_emp.SetRedraw(false)			
dw_emp.reset()
dw_emp.insertrow(0)
dw_emp.setfocus()
dw_emp.SetItem(1, 'eduyear', string(today(), 'YYYY'))
dw_emp.SetColumn('empno')
dw_emp.SetRedraw(true)

is_gub = "등록"
p_del.enabled = false
p_ins.enabled = false  

end event

type p_inq from w_inherite_standard`p_inq within w_pig2003
integer x = 3712
end type

event p_inq::clicked;call super::clicked;string ls_code, ls_empno, ls_eduyear, &
       ls_bgubn, ls_egubn, snull
		 
long ll_empseq, ll_ekitainwon

SetNull(snull)
	
 if  dw_emp.AcceptText() = -1 then return
	
if dw_emp.RowCount() <= 0 then
	dw_emp.setfocus()
	return
end if

ls_empno = dw_emp.GetItemString(1, "empno")
ls_eduyear= dw_emp.GetItemString(1, "eduyear")
ll_empseq = dw_emp.GetItemNumber(1, "empseq")

 if ls_empno="" or isnull(ls_empno) then
     MessageBox("확 인", "사번은 필수 입력사항입니다.!!")
     dw_emp.setcolumn('empno')
	  dw_emp.setfocus()
     return	  
  elseif ls_eduyear="" or isnull(ls_eduyear) then
     MessageBox("확 인", "계획년도 필수 입력사항입니다.!!")
     dw_emp.setcolumn('eduyear')
	  dw_emp.setfocus()
     return	
  end if

dw_mst.SetRedraw(false)

if dw_mst.Retrieve(gs_company, ls_empno, ls_eduyear, ll_empseq, ls_empno) < 1 then
	
	MessageBox("확 인", "조회한 값이 존재하지 않습니다.!!")
	
   wf_init()
	dw_mst.SetItem(1, 'companycode', gs_company)
	dw_mst.SetItem(1, 'empno', ls_empno)	
	dw_mst.SetItem(1, 'eduempno', ls_empno)
	is_gub = "등록"
   p_del.enabled = false	
   p_ins.enabled = false	
 else
   dw_mst.SetRedraw(true)
	
   ls_egubn = dw_mst.GetItemString(1, 'egubn')

	ll_ekitainwon = dw_mst.GetItemNumber(1, 'ekitainwon')

	if isnull(ll_ekitainwon) or trim(string(ll_ekitainwon)) = "" then
		ll_ekitainwon = 0 
	end if
	
	if ls_egubn = "1" and ( ll_ekitainwon > 0 ) then       //사내면
      wf_reper(ls_empno, ls_eduyear, ll_empseq)
      wf_retot(ls_empno, ls_eduyear, ll_empseq)
	else  // 기타 이거나 사외면
		dw_total.reset()
		dw_personal.reset()		
	end if
	
	is_gub = "조회"	
   p_del.enabled = true
   p_ins.enabled = true
end if

dw_mst.SetRedraw(true)

dw_emp.enabled = false	
dw_mst.setfocus()
dw_mst.setcolumn('peduyear')

w_mdi_frame.sle_msg.text = "자료가 조회되었습니다.!!"
end event

type p_print from w_inherite_standard`p_print within w_pig2003
integer x = 197
integer y = 4832
end type

type p_can from w_inherite_standard`p_can within w_pig2003
integer x = 4233
end type

event p_can::clicked;call super::clicked;dw_emp.SetRedraw(false)
dw_mst.SetRedraw(false)
dw_total.SetRedraw(false)
dw_personal.SetRedraw(false)

dw_emp.reset()
dw_mst.reset()
dw_total.reset()
dw_personal.reset()

dw_emp.insertrow(0)
dw_mst.insertrow(0)

dw_emp.setItem(1, 'eduyear', string(today(), 'YYYY'))

dw_emp.SetRedraw(true)
dw_mst.SetRedraw(true)
dw_total.SetRedraw(true)
dw_personal.SetRedraw(true)

dw_emp.enabled = true

dw_emp.setColumn('empno')
dw_emp.setfocus()

p_del.enabled = false
p_ins.enabled = false

ib_any_typing = false

w_mdi_frame.sle_msg.text = "자료를 취소하였습니다.!!"

end event

type p_exit from w_inherite_standard`p_exit within w_pig2003
integer x = 4407
end type

type p_ins from w_inherite_standard`p_ins within w_pig2003
integer x = 4123
integer y = 4988
end type

event p_ins::clicked;call super::clicked;long ll_row, ll_mrow


if dw_emp.AcceptText() = -1 then return

if dw_mst.AcceptText() = -1 then return

ll_row = dw_emp.getrow()

if ll_row <= 0 then 	return 


ll_mrow = dw_mst.getrow()

if ll_mrow <= 0 then return 

istr_edu.str_empno = dw_emp.Getitemstring(1, "empno")        // 사번
istr_edu.str_eduyear = dw_emp.Getitemstring(1, "eduyear")    // 실적년도
istr_edu.str_empseq  = dw_emp.GetitemNumber(1, "empseq")     // 일련번호
istr_edu.str_eduempno = istr_edu.str_empno

istr_edu.str_sdate = dw_mst.Getitemstring(ll_mrow, "restartdate")   // 실교육시작일자
istr_edu.str_edate = dw_mst.Getitemstring(ll_mrow, "reenddate")    // 실교육종료일자

IF	IsNull(istr_edu.str_empno) or istr_edu.str_empno = "" THEN RETURN
IF	IsNull(istr_edu.str_eduyear) or istr_edu.str_eduyear= "" THEN RETURN
IF	IsNull(istr_edu.str_empseq) or  &
   string(istr_edu.str_empseq)  = "" or istr_edu.str_empseq= 0 THEN RETURN

if isnull(istr_edu.str_sdate) then istr_edu.str_sdate = ""
if isnull(istr_edu.str_edate) then istr_edu.str_edate = ""


//openwithparm(w_pig2002_01, istr_edu)

end event

type p_search from w_inherite_standard`p_search within w_pig2003
integer x = 23
integer y = 4832
end type

type p_addrow from w_inherite_standard`p_addrow within w_pig2003
integer x = 718
integer y = 4832
end type

type p_delrow from w_inherite_standard`p_delrow within w_pig2003
integer x = 891
integer y = 4832
end type

type dw_insert from w_inherite_standard`dw_insert within w_pig2003
integer x = 87
integer y = 4544
end type

type st_window from w_inherite_standard`st_window within w_pig2003
integer x = 2181
integer y = 4616
end type

type cb_exit from w_inherite_standard`cb_exit within w_pig2003
integer x = 1787
integer y = 5312
integer width = 375
integer height = 148
integer taborder = 80
end type

type cb_update from w_inherite_standard`cb_update within w_pig2003
integer x = 1403
integer y = 5136
integer width = 375
integer height = 148
integer taborder = 40
end type

type cb_insert from w_inherite_standard`cb_insert within w_pig2003
integer x = 1787
integer y = 4960
integer width = 375
integer height = 148
integer taborder = 60
string text = "보고서(&I)"
end type

type cb_delete from w_inherite_standard`cb_delete within w_pig2003
integer x = 1403
integer y = 5312
integer width = 375
integer height = 148
integer taborder = 50
end type

event cb_delete::clicked;call super::clicked;string ls_companycode, ls_empno, ls_eduyear, ls_isu
long ll_empseq
int li_currow

if dw_emp.AcceptText() = -1 then return
if dw_mst.AcceptText() = -1 then return

if f_msg_delete() = -1 then return

ls_companycode = gs_company
ls_empno = dw_emp.GetItemString(1, "empno")
ls_eduyear = dw_emp.GetItemString(1, "eduyear")
ll_empseq = dw_emp.GetItemNumber(1, "empseq")

if isnull(ls_empno) or trim(ls_empno) = "" then 
	MessageBox("확 인",  "대표사번은 필수 입력사항입니다.!!")
	dw_emp.setcolumn('empno')
	dw_emp.setfocus()
	return 
end if

if isnull(ls_eduyear) or trim(ls_eduyear) = "" then 
	MessageBox("확 인",  "실적년도는 필수 입력사항입니다.!!")
	dw_emp.setcolumn('eduyear')
	dw_emp.setfocus()
	return 
end if

if isnull(ll_empseq) or trim(string(ll_empseq)) = ""  or ll_empseq <= 0 then 
	MessageBox("확 인",  "실적순번은 필수 입력사항입니다.!!")
	dw_emp.setcolumn('empseq')
	dw_emp.setfocus()
	return 
end if


ls_isu  =  dw_mst.GetItemString(1, 'isu')		//이수처리 여부 (총무에서 확인)
                                             // 이수처리가 되어 있으면 자료 입력 불가
															// 총무과에서 확인

if ls_isu = "Y" then
	MessageBox("확 인", "이미 이수처리가 되어 있으므로, " + "~n" + "~n" + &
	                    "자료를 삭제할 수 없습니다.")
   sle_msg.text = "자료를 삭제하지 못하였습니다.!!"							  
	return
end if 

dw_mst.SetRedraw(false)		
	
DELETE FROM p5_educations_s
  WHERE companycode = :ls_companycode AND
        empno = :ls_empno AND 
        eduyear = :ls_eduyear AND 
        empseq  = :ll_empseq ; 
  if sqlca.sqlcode <> 0 then 
     rollback using sqlca;
	  MessageBox("확 인", "자료를 삭제하는데, 실패하였습니다.!!")
     return
  end if
		
// 이미 삭제 처리가 되어 저장됨을 나타냄		
ib_any_typing = false

commit using sqlca;
		
sle_msg.text = "자료를 삭제하였습니다.!!"

dw_mst.SetRedraw(true)			

wf_init()

dw_emp.enabled = true

dw_emp.SetRedraw(false)			
dw_emp.reset()
dw_emp.insertrow(0)
dw_emp.setfocus()
dw_emp.SetItem(1, 'eduyear', string(today(), 'YYYY'))
dw_emp.SetColumn('empno')
dw_emp.SetRedraw(true)

is_gub = "등록"
cb_delete.enabled = false
cb_insert.enabled = false  

end event

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pig2003
integer x = 1403
integer y = 4960
integer width = 375
integer height = 148
integer taborder = 30
end type

event cb_retrieve::clicked;call super::clicked;string ls_code, ls_empno, ls_eduyear, &
       ls_bgubn, ls_egubn, snull
		 
long ll_empseq, ll_ekitainwon

SetNull(snull)
	
 if  dw_emp.AcceptText() = -1 then return
	
if dw_emp.RowCount() <= 0 then
	dw_emp.setfocus()
	return
end if

ls_empno = dw_emp.GetItemString(1, "empno")
ls_eduyear= dw_emp.GetItemString(1, "eduyear")
ll_empseq = dw_emp.GetItemNumber(1, "empseq")

 if ls_empno="" or isnull(ls_empno) then
     MessageBox("확 인", "사번은 필수 입력사항입니다.!!")
     dw_emp.setcolumn('empno')
	  dw_emp.setfocus()
     return	  
  elseif ls_eduyear="" or isnull(ls_eduyear) then
     MessageBox("확 인", "계획년도 필수 입력사항입니다.!!")
     dw_emp.setcolumn('eduyear')
	  dw_emp.setfocus()
     return	
  end if

dw_mst.SetRedraw(false)

if dw_mst.Retrieve(gs_company, ls_empno, ls_eduyear, ll_empseq, ls_empno) < 1 then
	
	MessageBox("확 인", "조회한 값이 존재하지 않습니다.!!")
	
   wf_init()
	dw_mst.SetItem(1, 'companycode', gs_company)
	dw_mst.SetItem(1, 'empno', ls_empno)	
	dw_mst.SetItem(1, 'eduempno', ls_empno)
	is_gub = "등록"
   cb_delete.enabled = false	
   cb_insert.enabled = false	
 else
   dw_mst.SetRedraw(true)
	
   ls_egubn = dw_mst.GetItemString(1, 'egubn')

	ll_ekitainwon = dw_mst.GetItemNumber(1, 'ekitainwon')

	if isnull(ll_ekitainwon) or trim(string(ll_ekitainwon)) = "" then
		ll_ekitainwon = 0 
	end if
	
	if ls_egubn = "1" and ( ll_ekitainwon > 0 ) then       //사내면
      wf_reper(ls_empno, ls_eduyear, ll_empseq)
      wf_retot(ls_empno, ls_eduyear, ll_empseq)
	else  // 기타 이거나 사외면
		dw_total.reset()
		dw_personal.reset()		
	end if
	
	is_gub = "조회"	
   cb_delete.enabled = true
   cb_insert.enabled = true
end if

dw_mst.SetRedraw(true)

dw_emp.enabled = false	
dw_mst.setfocus()
dw_mst.setcolumn('peduyear')

sle_msg.text = "자료가 조회되었습니다.!!"
end event

type st_1 from w_inherite_standard`st_1 within w_pig2003
integer x = 14
integer y = 4616
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pig2003
integer x = 1787
integer y = 5136
integer width = 375
integer height = 148
integer taborder = 70
end type

event cb_cancel::clicked;call super::clicked;dw_emp.SetRedraw(false)
dw_mst.SetRedraw(false)
dw_total.SetRedraw(false)
dw_personal.SetRedraw(false)

dw_emp.reset()
dw_mst.reset()
dw_total.reset()
dw_personal.reset()

dw_emp.insertrow(0)
dw_mst.insertrow(0)

dw_emp.setItem(1, 'eduyear', string(today(), 'YYYY'))

dw_emp.SetRedraw(true)
dw_mst.SetRedraw(true)
dw_total.SetRedraw(true)
dw_personal.SetRedraw(true)

dw_emp.enabled = true

dw_emp.setColumn('empno')
dw_emp.setfocus()

cb_delete.enabled = false
cb_insert.enabled = false

ib_any_typing = false

sle_msg.text = "자료를 취소하였습니다.!!"

end event

type dw_datetime from w_inherite_standard`dw_datetime within w_pig2003
integer x = 2825
integer y = 4616
end type

type sle_msg from w_inherite_standard`sle_msg within w_pig2003
integer x = 343
integer y = 4616
end type

type gb_2 from w_inherite_standard`gb_2 within w_pig2003
integer x = 1367
integer y = 4876
integer width = 841
integer height = 668
end type

type gb_1 from w_inherite_standard`gb_1 within w_pig2003
boolean visible = false
integer x = 32
integer y = 4384
boolean enabled = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pig2003
boolean visible = false
integer x = 434
integer y = 4428
long backcolor = 32106727
boolean enabled = false
end type

type gb_5 from groupbox within w_pig2003
integer x = 2222
integer y = 1504
integer width = 1189
integer height = 668
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "참석 인원"
borderstyle borderstyle = stylelowered!
end type

type dw_emp from datawindow within w_pig2003
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 549
integer y = 32
integer width = 2775
integer height = 180
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pig2003_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;
Send(Handle(this),256,9,0)

Return 1


end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String 	sEmpNo, sEmpName, sEnterDate, is_empno, &
         snull, get_name, ls_empno, ls_eduyear, ls_egubn
			
long ll_empseq, ll_ekitainwon
		
SetNull(snull)

w_mdi_frame.sle_msg.text = ""

If dwo.name = "empno" Then
	sempno = trim(data)
 	IF IsNull(wf_exiting_data(dw_emp.GetColumnName(),sempno,"1")) THEN	
  	   MessageBox("확 인","등록되지 않은 사원이므로 등록할 수 없습니다.!!")
     	Return 1
   end if
	SELECT "P1_MASTER"."EMPNAME"  
		 INTO :get_name  
		 FROM "P1_MASTER"  
		WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
				( "P1_MASTER"."EMPNO" = :data )   ;	
	if sqlca.sqlcode = 0 then 
		dw_emp.SetItem(1, 'p1_master_empname', get_name)		
		
		dw_mst.SetItem(1, 'companycode', gs_company)
		dw_mst.SetItem(1, 'empno', dw_emp.GetItemString(1, 'empno'))	
	else
		dw_emp.SetItem(1, 'empno', snull)	
		dw_emp.SetItem(1, 'p1_master_empname', snull)		
		return 1
    end if
end if

If dwo.name = "eduyear" Then
	if isnull(data) or trim(data) = "" then
		return 1
	end if
	If f_datechk(data+'01'+'01') = -1 Then
		MessageBox("확 인", "유효한 년도가 아닙니다.")
		Return 1
	end if
end if

If dwo.name = "empseq" Then
	
	ls_empno = dw_emp.GetItemstring(row, 'empno')
	ls_eduyear = dw_emp.GetItemstring(row, 'eduyear')
	ll_empseq = long(trim(data)) 

	dw_mst.SetRedraw(false)
	
   if dw_mst.Retrieve(gs_company, ls_empno, ls_eduyear, &
	   ll_empseq, ls_empno) <= 0 then

		wf_init()

   	dw_mst.SetItem(1, 'companycode', gs_company)
   	dw_mst.SetItem(1, 'empno', dw_emp.GetItemString(1, 'empno'))	
   	dw_mst.SetItem(1, 'eduempno', dw_emp.GetItemString(1, 'empno'))			
	   dw_mst.setcolumn('peduyear')     // 계획년도
   	dw_mst.setfocus()
		is_gub = "등록"

		p_del.enabled = false
		p_ins.enabled = false		
   	dw_mst.SetRedraw(true)		
		dw_total.reset()
		dw_personal.reset()		
		
		return 
   else

		ls_egubn = dw_mst.GetItemString(1, 'egubn')
	
		ll_ekitainwon = dw_mst.GetItemNumber(1, 'ekitainwon')
	
		if isnull(ll_ekitainwon) or trim(string(ll_ekitainwon)) = "" then
			ll_ekitainwon = 0 
		end if
		
		if ( ll_ekitainwon > 0 ) and ls_egubn = "1"  then       //사내면
			wf_reper(ls_empno, ls_eduyear, ll_empseq)
			wf_retot(ls_empno, ls_eduyear, ll_empseq)
		else  // 기타 이거나 사외면
			dw_total.reset()
			dw_personal.reset()		
		end if
		
		is_gub = "조회"
   	dw_mst.SetRedraw(true)		
		p_del.enabled = true		
		p_ins.enabled = true				
		
   end if	
		
end if

end event

event rbuttondown;string snull, ls_empno, ls_company, ls_eduyear, ls_egubn
int li_count 
long ll_ekitainwon

SetNull(Gs_code)
SetNull(Gs_codename)

this.AcceptText()

IF This.GetColumnName() = "empno" THEN
	Gs_Code = this.GetItemString(this.GetRow(),"empno")
	
	open(w_employee_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(), "empno", Gs_code)
	this.SetItem(this.GetRow(), "p1_master_empname", Gs_codename)	
	this.SetColumn('empno')
END IF

IF This.GetColumnName() = "eduyear" or This.GetColumnName() = "empseq" THEN

	Gs_Code  = gs_company

   istr_edu.str_empno   = dw_emp.Getitemstring(1, "empno")  // 사번
   istr_edu.str_eduyear = dw_emp.Getitemstring(1, "eduyear")// 계획년도
   istr_edu.str_empseq  = this.GetitemNumber(1, "empseq")  // 	일련번호

	openwithparm(w_stot_popup, istr_edu)
	
	istr_edu = Message.PowerObjectParm	     // return value

	if isnull(istr_edu.str_empno) or isNull(istr_edu.str_eduyear) or &
	   IsNull(istr_edu.str_empseq) or IsNull(istr_edu.str_gbn) THEN 
   	this.SetItem(1, "eduyear", string(today(), "YYYY"))
		return
   else
		
      this.SetItem(1, "eduyear", istr_edu.str_eduyear)
    	this.SetItem(1, "empseq", istr_edu.str_empseq)

      dw_mst.SetRedraw(false)
      if dw_mst.Retrieve(gs_company, istr_edu.str_empno, istr_edu.str_eduyear, &
		                   istr_edu.str_empseq, istr_edu.str_empno) < 1  then
         wf_init()
			
      	dw_mst.SetItem(1, 'companycode', gs_company)
      	dw_mst.SetItem(1, 'empno', ls_empno)	
      	dw_mst.SetItem(1, 'eduempno', ls_empno)
			
   	   is_gub = "등록"
         dw_mst.SetRedraw(true)
			p_del.enabled = false			
			p_ins.enabled = false						
      else

			ls_egubn = dw_mst.GetItemString(1, 'egubn')
			
			ll_ekitainwon = dw_mst.GetItemNumber(1, 'ekitainwon')
		
			if isnull(ll_ekitainwon) or trim(string(ll_ekitainwon)) = "" then
				ll_ekitainwon = 0 
			end if
			
   		if ( ll_ekitainwon > 0 ) and ls_egubn = "1"  then       //사내면
            wf_reper(istr_edu.str_empno, istr_edu.str_eduyear, istr_edu.str_empseq)
            wf_retot(istr_edu.str_empno, istr_edu.str_eduyear, istr_edu.str_empseq)
	   	else  // 기타 이거나 사외면
				dw_personal.reset()
				dw_total.reset()				
			end if
			
      	is_gub = "조회"
         dw_mst.SetRedraw(true)
			p_del.enabled = true
			p_ins.enabled = true									
      end if
      dw_mst.setfocus()
      dw_mst.SetColumn('peduyear')
		dw_emp.enabled = false
   end if
END IF

end event

event itemerror;return 1
end event

type dw_mst from datawindow within w_pig2003
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 617
integer y = 248
integer width = 3109
integer height = 1236
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pig2003_2"
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

event rbuttondown;string ls_egubn, snull
long ll_ekitainwon 

SetNull(snull)
IF this.GetColumnName() = "peduyear" or this.GetColumnName() = "pempseq" THEN

	Gs_Code  = gs_company
   istr_edu.str_empno   = dw_emp.Getitemstring(1, "empno")      // 대표사번
   istr_edu.str_eduyear = this.object.peduyear[GetRow()]             // 계획년도
   istr_edu.str_empseq  = this.Object.pempseq[GetRow()]              // 일련번호

	openwithparm(w_etot_popup, istr_edu)
	
	istr_edu = Message.PowerObjectParm	     // return value

	IF ( IsNull(Gs_code) or trim(Gs_code) = "" ) or &
	   ( IsNull(istr_edu.str_empno) or trim(istr_edu.str_empno) = "" ) or &
      ( IsNull(istr_edu.str_eduyear) or istr_edu.str_eduyear= "" ) or  &
      ( IsNull(istr_edu.str_empseq) or trim(string(istr_edu.str_empseq)) = "" or &  
		  istr_edu.str_empseq= 0 ) or &
      ( IsNull(istr_edu.str_gbn) or trim(istr_edu.str_gbn) = "" ) then 
		
		wf_init()
		this.setItem(1, 'empno', dw_emp.GetItemString(1, 'empno'))		
		this.setItem(1, 'eduempno', dw_emp.GetItemString(1, 'empno'))				
		this.SetItem(1, 'bgubn', "S") // 교육계획 자료가 아닌 기타 자료 (S)
    	this.SetItem(1, "peduyear", snull)
 	   this.SetItem(1, "pempseq", snull)
		
		this.SetColumn('restartdate')		

      return 		
	end if

	
 	this.SetItem(1, "peduyear", istr_edu.str_eduyear)
 	this.SetItem(1, "pempseq", istr_edu.str_empseq)
	
//	if wf_pedu()  = -1 then return
//	
//	ls_egubn = dw_mst.GetItemString(1, 'egubn')
//	
//	ll_ekitainwon = dw_mst.GetItemNumber(1, 'ekitainwon')
//
//	if isnull(ll_ekitainwon) or trim(string(ll_ekitainwon)) = "" then
//		ll_ekitainwon = 0 
//	end if
//	
//	if ( ll_ekitainwon > 0 ) and ls_egubn = "1"  then       //사내면
//		wf_reper(istr_edu.str_empno, istr_edu.str_eduyear, istr_edu.str_empseq)
//      wf_retot(istr_edu.str_empno, istr_edu.str_eduyear, istr_edu.str_empseq)		
//	else  // 기타 이거나 사외면
//		dw_personal.reset()
//		dw_total.reset()				
//	end if
//	
   this.TriggerEvent(ItemChanged!)
	this.SetColumn('peduyear')
END IF

IF this.GetColumnName() ="edudept" THEN
	
	Open(w_dept_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	
	this.SetItem(this.GetRow(),"edudept",gs_code)
   this.TriggerEvent(ItemChanged!)	
	
END IF

end event

event itemchanged;string ls_empno, ls_eduyear, ls_sdate, ls_edate, svalue, &
       ls_restartdate, ls_reenddate, &
		 temp_date1, temp_date2, &
		 ls_starttime, ls_endtime, &
		 ls_edudept, ls_peduyear

string sdeptcode, sdeptcodename, ls_egubn
double sreamt, seduamt
long ll_empseq, ll_pempseq, ll_temp1  

long ll_datesu, ll_time1, ll_time2, &
     ll_ekitainwon  
	  
int ll_pedu	  

w_mdi_frame.sle_msg.text =""

setNull(svalue)

//계획년도 check
if this.GetColumnName() = 'peduyear' then
	
	ls_peduyear = this.GetItemString(1, 'peduyear')
	ll_pempseq =  this.GetItemNumber(1, 'pempseq')

   ll_empseq = dw_emp.GetItemNumber(1, 'empseq')
	
	
	If f_datechk(ls_peduyear+'01'+'01') = -1 Then 
		MessageBox("확 인", "유효한 년도가 아닙니다.")	
		return 1
	end if
	
   if isnull(ll_pempseq) or trim(string(ll_pempseq)) = "" then return  

	if isnull(ll_empseq) or trim(string(ll_empseq)) = "" then 
		setnull(ll_empseq)
	end if 
	
	
	ll_pedu = wf_pedu()
	
	if ll_pedu  = -1 then
		wf_init()
		
   	this.setItem(1, 'empseq', ll_empseq)						
		this.setItem(1, 'empno', dw_emp.GetItemString(1, 'empno'))		
		this.setItem(1, 'eduempno', dw_emp.GetItemString(1, 'empno'))				
		this.SetItem(1, 'bgubn', "S") // 교육계획 자료가 아닌 기타 자료 (S)
		this.SetItem(1, 'pempseq', svalue)
		this.SetItem(1, 'peduyear', svalue)
		this.SetColumn('restartdate')		
		return
	elseif ll_pedu = 2 then		
		p_inq.TriggerEvent(Clicked!)
		return 
	end if

	ls_egubn = dw_mst.GetItemString(1, 'egubn')
	
	ll_ekitainwon = dw_mst.GetItemNumber(1, 'ekitainwon')
	
	if isnull(ll_ekitainwon) or trim(string(ll_ekitainwon)) = "" then
		ll_ekitainwon = 0 
	end if
	
	if ( ll_ekitainwon > 0 ) and ls_egubn = "1"  then       //사내면
		wf_reper(istr_edu.str_empno, istr_edu.str_eduyear, istr_edu.str_empseq)
		wf_retot(istr_edu.str_empno, istr_edu.str_eduyear, istr_edu.str_empseq)		
	else  // 기타 이거나 사외면
		dw_personal.reset()
		dw_total.reset()				
	end if

  
end if

//계획순번
IF this.GetColumnName() ="pempseq" THEN
	
	ls_peduyear = this.GetItemString(1, 'peduyear') 
	ll_pempseq =  this.GetItemNumber(1, 'pempseq')

	ll_empseq   = dw_emp.GetItemNumber(1, 'empseq')	
	
	if isnull(ll_empseq) or trim(string(ll_empseq)) = "" then 
		setnull(ll_empseq)
	end if 
		
	// 계획자료를 이수처리자료로 전환하는 function
   ll_pedu = wf_pedu()  
	
	if ll_pedu  = -1 then   //자료가 존재하지 않을 경우
		wf_init()
		
		this.setItem(1, 'empseq', ll_empseq)				
		this.setItem(1, 'empno', dw_emp.GetItemString(1, 'empno'))		
		this.setItem(1, 'eduempno', dw_emp.GetItemString(1, 'empno'))				
		this.SetItem(1, 'bgubn', "S") // 교육계획 자료가 아닌 기타 자료 (S)
		this.SetItem(1, 'pempseq', svalue)
		this.SetItem(1, 'peduyear', svalue)
		this.SetColumn('restartdate')		
		return
	elseif ll_pedu = 2 then		
		p_inq.TriggerEvent(Clicked!)
		return 
	end if
	
	ls_egubn = dw_mst.GetItemString(1, 'egubn')
	
	ll_ekitainwon = dw_mst.GetItemNumber(1, 'ekitainwon')

	if isnull(ll_ekitainwon) or trim(string(ll_ekitainwon)) = "" then
		ll_ekitainwon = 0 
	end if
	
	if ( ll_ekitainwon > 0 ) and ls_egubn = "1"  then       //사내면
		wf_reper(istr_edu.str_empno, istr_edu.str_eduyear, istr_edu.str_empseq)
      wf_retot(istr_edu.str_empno, istr_edu.str_eduyear, istr_edu.str_empseq)		
	else  // 기타 이거나 사외면
		dw_personal.reset()
		dw_total.reset()				
	end if
	
END IF

// 실교육일자
IF this.GetColumnName() ="restartdate"THEN
	if isnull(data) or trim(data) = "" then 
		MessageBox("확 인", "교육 시작일자는 필수입력사항입니다.!!")			
		return 1
	end if
	If f_datechk(data) = -1 Then
		MessageBox("확 인", "유효한 일자가 아닙니다.")
		Return 1
	end if
	ls_restartdate = data
	ls_reenddate = this.GetItemstring(1, 'reenddate')
	
	//종료일자가 존재하지 않으면, 시작일자를 입력한다.
	if isnull(ls_reenddate) or trim(ls_reenddate) = "" then 
		ls_reenddate = ls_restartdate
		this.SetItem(1, 'reenddate', ls_reenddate)			
	end if
	
	// 총일수를 구하는 function(일수는 구하는데 실패하면 -1, 아니면 총일수 값을 return )
	if wf_date(ls_restartdate, ls_reenddate) = -1 then 
		MessageBox("확 인", "일수를 구하는데 실패하였습니다.!!")
		return 1
	else
	  ll_datesu = wf_date(ls_restartdate, ls_reenddate)			
	end if
	
	this.setItem(1, 'datesu', ll_datesu)		
	
	ll_time1 = this.GetItemNumber(1, 'temp1')		
	
	if isnull(ll_time1) or  string(ll_time1) = "" then 
		ll_time1 = 0 
	end if
	
	// 총일수와 총시간을 수정한다.		
	this.setItem(1, 'datesu', ll_datesu)		
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    
		
END IF

IF this.GetColumnName() ="reenddate"THEN
	if isnull(data) or trim(data) = "" then 
		MessageBox("확 인", "교육 종료일자는 필수입력사항입니다.!!")
		return 1		
	end if
	If f_datechk(data) = -1 Then
		MessageBox("확 인", "유효한 일자가 아닙니다.")
		Return 1
	end if
	
	ls_restartdate = this.GetItemstring(1, 'restartdate')
	ls_reenddate = data		
	
	if  ls_restartdate > ls_reenddate then
		MessageBox("확 인", "시작일자가 종료일자보다" + "~n" + &
								 "클 수는 없습니다.!!", stopsign!)
		return 1
	end if
	
	//종료일자가 존재하지 않으면, 시작일자를 입력한다.
	if isnull(ls_restartdate) or ls_restartdate = "" then 
		ls_restartdate = ls_reenddate 
		this.SetItem(1, 'restartdate', ls_restartdate)						
	end if
	
	// 총일수를 구하는 function(일수는 구하는데 실패하면 -1, 아니면 총일수 값을 return )
	if wf_date(ls_restartdate, ls_reenddate) = -1 then 
		MessageBox("확 인", "일수를 구하는데 실패하였습니다.!!")
		return 
	else
	  ll_datesu = wf_date(ls_restartdate, ls_reenddate)			
	end if
	
	if isnull(ll_datesu) or string(ll_datesu) = "" then
		ll_datesu= 0 
	end if
	
	ll_time1 = this.GetItemNumber(1, 'temp1')		
	
	if isnull(ll_time1) or string(ll_time1) = "" then 
		ll_time1 = 0 
	end if
	
	// 총일수와 총시간을 수정한다.		
	this.setItem(1, 'datesu', ll_datesu)		
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    

END IF


if this.GetColumnName() = 'starttime' then
	ls_starttime = string(long(data), '00:00')
	if Istime(ls_starttime) = false Then
		MessageBox("확 인", "유효한 시간이 아닙니다.")			
		return 1
	end if
	//temp1의 computed field에 들어갈 값
	//  truncate( ((  long(left(string(endtime, '0000'), 2)) * 60  + &
	//  long (right(string(endtime, '0000'), 2))) - (long(left(string(starttime, '0000'), 2)) &
	//  * 60  + long (right(string(starttime, '0000'), 2)) )) / 60, 0)		
	
	ls_endtime = string(this.GetItemNumber(1, 'endtime'), '00:00')
	
	if isnull(ls_endtime) or ls_endtime = ""  or ls_endtime ="00:00" then
		ls_endtime = data
		this.SetItem(1, 'endtime',  long(ls_endtime))			
	end if
	
	ll_datesu = this.GetItemNumber(1, 'datesu')				

	if isnull(ll_datesu) or string(ll_datesu) = "" then
		ll_datesu = 0 
	end if
	
//		ll_time1 = tab_1.tabpage_1.dw_main1.GetItemNumber(1, 'temp1')		
	if wf_time(ls_starttime, ls_endtime) = -1 then 
		MessageBox("확 인", "시간 산출 에러")
		return 1
	else 
		ll_time1 = wf_time(ls_starttime, ls_endtime)
	end if
	
	if isnull(ll_time1) or string(ll_time1) = ""  then ll_time1 = 0
	
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    		
end if

if this.GetColumnName() = 'endtime' then
	ls_endtime = string(long(data), '00:00')
	if Istime(ls_endtime) = false Then
		MessageBox("확 인", "유효한 시간이 아닙니다.")			
		return 1
	end if
	ls_starttime = string(this.GetItemNumber(1, 'starttime'), & 
										'00:00')
	if ls_starttime > ls_endtime then
		MessageBox("확 인", "시작 시간이 종료시간보다" + "~n" + & 
								 "클 수는 없습니다.!!")			
		return 1
	end if
	
	if isnull(ls_starttime) or string(ls_starttime) = "" then
		ls_starttime = data  
		this.SetItem(1, 'starttime',  long(ls_starttime))			
	end if

	ll_datesu = this.GetItemNumber(1, 'datesu')				
	
	if isnull(ll_datesu) or string(ll_datesu) = "" then
		ll_datesu = 0 
	end if
	
	if wf_time(ls_starttime, ls_endtime) = -1 then 
		MessageBox("확 인", "시간 산출 에러")
		return 1
	else 
		ll_time1 = wf_time(ls_starttime, ls_endtime)
	end if

	if isnull(ll_time1) or string(ll_time1) = "" then ll_time1 = 0
		
	this.setItem(1, 'ehour', ll_datesu * ll_time1)    		

end if

if this.GetColumnName() = 'datesu' then
	ll_datesu = long(data)
	if isnull(ll_datesu)  or ll_datesu = 0 or string(ll_datesu) = "" then 
		ll_datesu = 0
		this.setItem(1, 'datsu', 0)    		
	end if
	
	// 총교육시간, 교육일수 * 교육시간
	ll_time1 = this.GetItemNumber(1, 'temp1') 
	if isnull(ll_time1) or string(ll_time1) = "" then
		ll_time1 = 0 
	end if
	
	this.SetItem(1, 'ehour', ll_datesu * ll_time1)
end if


// 교육구분(1 : 사내, 2 : 사외)
IF this.GetColumnName() ="egubn"THEN
	IF IsNull(data) OR data ="" THEN Return 1
	
	ls_empno = dw_emp.GetItemString(1, 'empno')
	ls_eduyear = dw_emp.GetItemString(1, 'eduyear')
	ll_empseq = dw_emp.GetItemNumber(1, 'empseq')

	ll_ekitainwon = this.GetItemNumber(row, 'ekitainwon')

	if isnull(ll_ekitainwon) or trim(string(ll_ekitainwon)) = "" then
		ll_ekitainwon = 0 
	end if
	
	
	if ( ll_ekitainwon > 0 ) and data = "1"  then       //사내면
      wf_reper(ls_empno, ls_eduyear, ll_empseq)
      wf_retot(ls_empno, ls_eduyear, ll_empseq)
	else  // 기타 이거나 사외면
		dw_total.reset()
		dw_personal.reset()		
	end if
END IF

	
IF this.GetColumnName() ="edugun"THEN
	IF IsNull(data) OR data ="" THEN Return 
END IF


IF this.GetColumnName() ="ekind"THEN
	IF IsNull(data) OR data ="" THEN Return 
END IF

// 교육기관이 선택되면, 
IF this.GetColumnName() ="eoffice"THEN
	if trim(data) = "" or isnull(data) then return 
END IF

// 주관부서
IF this.GetColumnName() ="edudept"THEN
	ls_edudept = this.GetItemString(1, 'edudept')
	
	if trim(ls_edudept) = "" or isnull(ls_edudept) then return
	
	select deptcode, deptname
	into   :sdeptcode, :sdeptcodename
	from p0_dept
	where companycode = :gs_company and
			deptcode    = :ls_edudept ;
	if sqlca.sqlcode <> 0 then
		MessageBox("확 인", "조회한 자료가 없습니다.")
	   this.SetItem(row, 'edudept', svalue)
		return 1
	end if

END IF

//외인원이 0보다 크면, 부서 list표시
IF this.GetColumnName() ="ekitainwon"THEN
	IF IsNull(data) OR data ="" THEN 
		ll_ekitainwon = 0
	end if

	ls_empno = dw_emp.GetItemString(1, 'empno')
	ls_eduyear = dw_emp.GetItemString(1, 'eduyear')
	ll_empseq = dw_emp.GetItemNumber(1, 'empseq')

   ll_ekitainwon = long(data)
	ls_egubn = this.GetItemString(1, 'egubn')

	if ( ll_ekitainwon > 0 ) and ls_egubn = "1"  then       //사내면, 외인원이 0보다 크면
      wf_reper(ls_empno, ls_eduyear, ll_empseq)
      wf_retot(ls_empno, ls_eduyear, ll_empseq)
	elseif  ls_egubn = "2" then 
		dw_personal.reset()		
	else
		dw_total.reset()
		dw_personal.reset()		
	end if
	
   Return 	
END IF

IF this.GetColumnName() ="rebackamt"THEN
	IF IsNull(data) OR data ="" THEN 
	ELSE
		if dw_mst.Accepttext() = -1 then return
		sreamt = dw_mst.GetItemNumber(1,"rebackamt")
		seduamt = dw_mst.GetItemNumber(1,"eduamt")
		
		seduamt = seduamt - sreamt
		dw_mst.setitem(1,'educost',seduamt)
	END IF
END IF


IF this.GetColumnName() ="eduteacher"THEN
	IF IsNull(data) OR data ="" THEN Return 
END IF


IF this.GetColumnName() ="eduno"THEN
	IF IsNull(data) OR data ="" THEN Return 
END IF

IF this.GetColumnName() ="edudesc"THEN
	IF IsNull(data) OR data ="" THEN Return 
END IF

end event

event itemfocuschanged;Long wnd

wnd =Handle(this)

IF this.GetColumnName() ="eduteacher" OR this.GetColumnName() ="edudepmant" OR &
   this.GetColumnName() ="eduarea" OR this.GetColumnName() ="edubook" OR &
	this.GetColumnName() ="edubook1" or this.GetColumnName() ="edudesc" THEN
	f_toggle_kor(wnd)
ELSE
	f_toggle_eng(wnd)
END IF

end event

event editchanged;ib_any_typing = false
end event

event itemerror;return 1
end event

type pb_1 from picturebutton within w_pig2003
integer x = 2080
integer y = 1620
integer width = 101
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\Erpman\image\next.gif"
alignment htextalign = left!
end type

event clicked;String  ls_code, ls_empno, ls_eduyear, ls_eduempno, &
        sEmpNo, sEmpName, sDeptName
Long   totRow , sRow, rowcnt, ll_empseq, row
long i

if dw_emp.AcceptText() = -1 then return 

ls_empno = dw_emp.GetItemString(1, 'empno')

if isnull(ls_empno) or trim(ls_empno) = "" then 
	MessageBox("확 인", "대표사번은 필수 입력사항입니다.!!")
	dw_emp.SetColumn('empno')
	dw_emp.setfocus()
	return 
end if

sRow = dw_total.getselectedrow(sRow)

If sRow <= 0 Then 
   MessageBox("확인", "선택된 사원이 없습니다")
  return
end if


totrow =dw_total.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_total.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo      = dw_total.GetItemString(sRow, "p1_master_empno")
   sEmpName    = dw_total.GetItemString(sRow, "p1_master_empname")
   sDeptName   = dw_total.GetItemString(sRow, "p0_dept_deptname")
	
	rowcnt = dw_personal.RowCount() + 1
	if ls_empno <> sEmpNo then 
		dw_personal.insertrow(rowcnt)
		dw_personal.setitem(rowcnt, "p1_master_empname", sEmpName)	 // 참석사원명
		dw_personal.setitem(rowcnt, "deptname", sDeptName)           // 참석사원 부서명	
		dw_personal.setitem(rowcnt, "eduempno", sEmpNo)              // 참석사번
	end if
	
	dw_total.deleterow(sRow)
NEXT	

end event

type pb_2 from picturebutton within w_pig2003
integer x = 2080
integer y = 1728
integer width = 101
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\Erpman\image\prior.gif"
alignment htextalign = left!
end type

event clicked;String ls_code, ls_empno, ls_eduyear, ls_eduempno, ls_isu
string sEmpNo, sEmpName, sDeptName
Long   totRow , sRow, rowcnt, ll_empseq, ll_cnt
int i

if dw_emp.AcceptText() = -1 then return 
if dw_mst.AcceptText() = -1 then return 

ls_empno  = dw_emp.GetItemString(1, "empno")
ls_eduyear = dw_mst.GetItemString(1, 'eduyear')
ll_empseq = dw_mst.GetItemNumber(1, 'empseq')
ls_isu = dw_mst.GetItemString(1, 'isu')

if ls_isu = 'Y' then
	MessageBox("확 인", "이미 이수처리가 되어 있으므로, " + "~n" + "~n" + &
							  "자료를 수정할 수 없습니다.")
   return 	
end if

sRow = dw_personal.getselectedrow(0)
If sRow <= 0 Then
  MessageBox("확인", "선택된 사원이 없습니다")
  Return
end if


sRow = 0
do while true
	sRow = dw_personal.getselectedrow(0)
	If sRow <= 0 Then	  Exit

	sEmpNo      = dw_personal.GetItemString(sRow, "eduempno")
   sEmpName    = dw_personal.GetItemString(sRow, "p1_master_empname")
   sDeptName   = dw_personal.GetItemString(sRow, "deptname")
	

   rowcnt = dw_total.RowCount() + 1	
	
   dw_total.insertrow(rowcnt)	
	
	dw_total.setitem(rowcnt, "p1_master_empname", sEmpName)	 
	dw_total.setitem(rowcnt, "p0_dept_deptname", sDeptName)   
	dw_total.setitem(rowcnt, "p1_master_empno", sEmpNo)       
	
   
	dw_personal.deleterow(sRow)
  
Loop

 SELECT count(*)   
 INTO :ll_cnt 
 FROM "P5_EDUCATIONS_S" 
 WHERE ( "P5_EDUCATIONS_S"."COMPANYCODE" = :gs_company )  AND 
		 ( "P5_EDUCATIONS_S"."EMPNO" =  :ls_empno ) AND 
		 ( "P5_EDUCATIONS_S"."EDUYEAR" = :ls_eduyear ) AND
		 ( "P5_EDUCATIONS_S"."EMPSEQ" = :ll_empseq )  AND 
		 ( "P5_EDUCATIONS_S"."EDUEMPNO" = :ls_empno ) ;
 if sqlca.sqlcode = 0 and ll_cnt > 0 then 
		if dw_personal.update() <> 1 then 
			MessageBox("확 인", "저장중 에러가 발생하였습니다.!!")
			rollback using sqlca;
			return 
		end if
		commit using sqlca;
		wf_reper(ls_empno, ls_eduyear, ll_empseq)
		wf_retot(ls_empno, ls_eduyear, ll_empseq)
  end if 	

end event

type dw_personal from u_d_select_sort within w_pig2003
integer x = 2245
integer y = 1560
integer width = 1143
integer height = 592
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_pig2003_4"
boolean hscrollbar = false
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event resize;//If sizetype = 1 Then // min
//   this.x = 1902
//	this.y = 1552
//   this.width = 1294
//	this.height = 356
//End If
//
//If sizetype = 2 Then // max
//
//   this.visible = false
//   this.x = 1902
//	this.y = 652
//   this.width = 1294
//	this.height = 1228
//   this.visible = true
//End If
//
//
end event

type uo_progress from u_progress_bar within w_pig2003
integer x = 873
integer y = 2640
integer width = 1083
integer height = 72
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type dw_total from u_d_select_sort within w_pig2003
integer x = 896
integer y = 1560
integer width = 1129
integer height = 592
integer taborder = 0
string dataobject = "d_pig2003_3"
boolean hscrollbar = false
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event resize;//If sizetype = 1 Then // min
//   this.x = 174
//	this.y = 1544
//   this.width = 1207
//	this.height = 360
//End If
//
//If sizetype = 2 Then // max
//   this.visible = false
//   this.x = 174
//	this.y = 652
//   this.width = 1207
//	this.height = 1260
//   this.visible = true
//End If
//
//
end event

type p_1 from uo_picture within w_pig2003
boolean visible = false
integer x = 4658
integer y = 336
boolean bringtotop = true
string picturename = "C:\Erpman\image\보고서_up.gif"
end type

event clicked;call super::clicked;//long ll_row, ll_mrow
//
//
//if dw_emp.AcceptText() = -1 then return
//
//if dw_mst.AcceptText() = -1 then return
//
//ll_row = dw_emp.getrow()
//
//if ll_row <= 0 then 	return 
//
//
//ll_mrow = dw_mst.getrow()
//
//if ll_mrow <= 0 then return 
//
//istr_edu.str_empno = dw_emp.Getitemstring(1, "empno")        // 사번
//istr_edu.str_eduyear = dw_emp.Getitemstring(1, "eduyear")    // 실적년도
//istr_edu.str_empseq  = dw_emp.GetitemNumber(1, "empseq")     // 일련번호
//istr_edu.str_eduempno = istr_edu.str_empno
//
//istr_edu.str_sdate = dw_mst.Getitemstring(ll_mrow, "restartdate")   // 실교육시작일자
//istr_edu.str_edate = dw_mst.Getitemstring(ll_mrow, "reenddate")    // 실교육종료일자
//
//IF	IsNull(istr_edu.str_empno) or istr_edu.str_empno = "" THEN RETURN
//IF	IsNull(istr_edu.str_eduyear) or istr_edu.str_eduyear= "" THEN RETURN
//IF	IsNull(istr_edu.str_empseq) or  &
//   string(istr_edu.str_empseq)  = "" or istr_edu.str_empseq= 0 THEN RETURN
//
//if isnull(istr_edu.str_sdate) then istr_edu.str_sdate = ""
//if isnull(istr_edu.str_edate) then istr_edu.str_edate = ""
//
//
////openwithparm(w_pig2002_01, istr_edu)
//
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\보고서_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\보고서_dn.gif"
end event

type gb_4 from groupbox within w_pig2003
integer x = 864
integer y = 1504
integer width = 1189
integer height = 668
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "대상 인원"
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_pig2003
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 581
integer y = 244
integer width = 3163
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

