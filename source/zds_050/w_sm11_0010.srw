$PBExportHeader$w_sm11_0010.srw
$PBExportComments$GM/DAT VAN 접수
forward
global type w_sm11_0010 from w_standard_print
end type
type p_search from uo_picture within w_sm11_0010
end type
type p_delrow from uo_picture within w_sm11_0010
end type
type p_delrow_all from uo_picture within w_sm11_0010
end type
type pb_1 from u_pb_cal within w_sm11_0010
end type
type dw_gm16 from datawindow within w_sm11_0010
end type
type dw_gm19 from datawindow within w_sm11_0010
end type
type dw_gm14 from datawindow within w_sm11_0010
end type
type dw_gm17 from datawindow within w_sm11_0010
end type
type st_state from statictext within w_sm11_0010
end type
type tab_1 from tab within w_sm11_0010
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
type tab_1 from tab within w_sm11_0010
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type pb_2 from u_pb_cal within w_sm11_0010
end type
type p_excel from uo_picture within w_sm11_0010
end type
type dw_gm16_detail from datawindow within w_sm11_0010
end type
type cbx_tab from checkbox within w_sm11_0010
end type
end forward

global type w_sm11_0010 from w_standard_print
integer width = 4677
integer height = 2508
string title = "GM/DAT VAN 접수"
p_search p_search
p_delrow p_delrow
p_delrow_all p_delrow_all
pb_1 pb_1
dw_gm16 dw_gm16
dw_gm19 dw_gm19
dw_gm14 dw_gm14
dw_gm17 dw_gm17
st_state st_state
tab_1 tab_1
pb_2 pb_2
p_excel p_excel
dw_gm16_detail dw_gm16_detail
cbx_tab cbx_tab
end type
global w_sm11_0010 w_sm11_0010

type variables
String is_custid, is_filepath
Long il_err , il_succeed
end variables

forward prototypes
public function integer wf_retrieve ()
public function string wf_choose (string as_gubun)
public function integer wf_van_gm14 (string arg_file_name, string arg_sabu, string arg_datagub)
public function integer wf_van_gm16 (string arg_file_name, string arg_sabu, string arg_datagub)
public function integer wf_van_gm17 (string arg_file_name, string arg_sabu, string arg_datagub)
public function integer wf_van_gm19 (string arg_file_name, string arg_sabu, string arg_datagub)
public subroutine wf_error (string as_gubun, long al_line, string as_bal_no, string as_factory, string as_itnbr, string as_errtext, string as_cvcod)
end prototypes

public function integer wf_retrieve ();Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_sdate  ,ls_edate, ls_saupj_cust 
string ls_factory , ls_itnbr,  ls_from, ls_to
DataWindow ldw_x

If Tab_1.SelectedTab = 1 Then Return -1

if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1

ls_gubun = Trim(dw_ip.Object.gubun[1]) 
ls_saupj = Trim(dw_ip.Object.saupj[1])


ls_sdate = Trim(dw_ip.Object.jisi_date[1])
ls_edate = Trim(dw_ip.Object.jisi_date2[1])

If f_datechk(ls_sdate) < 1 Then
	f_message_chk(35,'[기준일자]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("jisi_date")
	Return -1
End if
	
If f_datechk(ls_edate) < 1 Then
	f_message_chk(35,'[출하일자]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("jisi_date2")
	Return -1
End if

if	ls_sdate > ls_edate	then
	f_message_chk(200,'[기준일자]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("jisi_date")
	Return -1
end if	

ls_factory = Trim(dw_ip.Object.factory[1])

If ls_factory = '' Or isNull(ls_factory) Or ls_factory = '.' Then ls_factory = '%'

ls_from 	= Trim(dw_ip.Object.itnbr_from[1])
ls_to 	= Trim(dw_ip.Object.itnbr_to[1])
IF isNull(ls_from) THEN ls_from = '....'
IF isNull(ls_to) THEN ls_to = 'zzzzzz'

SetNull(ls_saupj_cust)

select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
  from dual ;
If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
	MessageBox('확인','사업장을 선택하세요')
	Return -1
End If
	

If Tab_1.SelectedTab = 1 Then
	dw_list.Retrieve(ls_saupj , ls_sdate ,ls_edate )
Else
	Choose Case ls_gubun 
		Case 'GM16'
			ldw_x = dw_GM16
		Case 'GM19'
			ldw_x = dw_GM19
		Case 'GM14'
			ldw_x = dw_GM14
		Case 'GM17'
			ldw_x = dw_GM17
		
	End Choose
	
	ldw_x.Retrieve(ls_saupj_cust , ls_sdate ,ls_edate, ls_from, ls_to , ls_factory  )
End IF

Return 1
end function

public function string wf_choose (string as_gubun);string ls_modstring, ls_path

Choose Case as_gubun
	Case 'GM14'
		If Tab_1.SelectedTab = 2 Then
			dw_GM14.x = dw_list.x
			dw_GM14.y = dw_list.y
			dw_GM14.width  = dw_list.width
			dw_GM14.height = dw_list.height
			dw_list.visible = False
			
			dw_GM16.visible = False
			dw_GM19.visible = False
			dw_GM14.visible = True
			dw_GM17.visible = False
		End If

		ls_modstring = is_filepath + 'b020B/' + is_filepath + 'b020K/' + is_filepath + 'b020C/'
		dw_ip.object.filename.values = ls_modstring 
		
		return is_filepath + 'b020B'
		
	Case 'GM16'
		If Tab_1.SelectedTab = 2 Then
			dw_GM16.x = dw_list.x
			dw_GM16.y = dw_list.y
			dw_GM16.width  = dw_list.width
			dw_GM16.height = dw_list.height
			
			dw_list.visible = False
			
			dw_GM16.visible = True
			dw_GM19.visible = False
			dw_GM14.visible = False
			dw_GM17.visible = False
		End If
		ls_modstring = is_filepath + 'c020B/' + is_filepath + 'c020K/' + is_filepath + 'c020C/' &
		             + is_filepath + 'c020D/'
		dw_ip.object.filename.values = ls_modstring 
		
		return is_filepath + 'c020B'

	Case 'GM17'
		If Tab_1.SelectedTab = 2 Then
			dw_GM17.x = dw_list.x
			dw_GM17.y = dw_list.y
			dw_GM17.width  = dw_list.width
			dw_GM17.height = dw_list.height
			dw_list.visible = False
			
			dw_GM16.visible = False
			dw_GM19.visible = False
			dw_GM14.visible = False
			dw_GM17.visible = True
		End IF
		ls_modstring = is_filepath + 'c621P/' 
		dw_ip.object.filename.values = ls_modstring 
		
		return is_filepath + 'c621P'

	Case 'GM19'
		If Tab_1.SelectedTab = 2 Then
			dw_GM19.x = dw_list.x
			dw_GM19.y = dw_list.y
			dw_GM19.width  = dw_list.width
			dw_GM19.height = dw_list.height
			
			dw_list.visible = False
			
			dw_GM16.visible = False
			dw_GM19.visible = True
			dw_GM14.visible = False
			dw_GM17.visible = False
		End if
		
		ls_path = 'C:\ERPMAN\GMDAT\'
		
		ls_modstring = ls_path + 'd010B/' + ls_path + 'd010K/' + ls_path + 'd050D/' &
		             + ls_path + 'd010C/' + ls_path + 'd611P/'
		dw_ip.object.filename.values = ls_modstring 
		
		return ls_path + 'd010B'

	Case Else

		dw_GM16.visible = False
		dw_GM19.visible = False
		dw_GM14.visible = False
		dw_GM17.visible = False
		
		dw_list.visible = True

		ls_modstring = is_filepath 
		dw_ip.object.filename.values = ls_modstring 
		
		return is_filepath 
		
End Choose
end function

public function integer wf_van_gm14 (string arg_file_name, string arg_sabu, string arg_datagub);
/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	

string ls_Input_Data ,ls_indate, ls_chdate
integer li_FileNum,li_cnt,li_rowcnt
Long ll_data = 0  , ll_cnt
string ls_CUSTCD,ls_FACTORY,ls_ITNBR,ls_CARCODE,ls_PART_CODE,ls_BODY_COLOR
string ls_CRT_DATE,ls_CRT_TIME,ls_CRT_USER
long  ll_IPSEQ,ll_SUBSEQ
double ld_CUR_SUM,ld_CUR_STOCK,ld_PREV_USE,ld_PREV_NIGHT, &
       ld_PLAN_DD0,ld_PLAN_ND0,ld_PLAN_DD1,ld_PLAN_ND1, ld_PLAN_D2, ld_PLAN_D3, ld_PLAN_D4, &
		 ld_PLAN_D5, ld_PLAN_D6, ld_PLAN_D7, ld_PLAN_D8,  ld_PLAN_D9, ld_PLAN_D10,ld_PLAN_D11,&
		 ld_PLAN_D12,ld_PLAN_D13,ld_PLAN_DJAN,ld_PLAN_M1, ld_PLAN_M2
string ls_MITNBR,ls_MCVCOD,ls_MDCVCOD,ls_citnbr , ls_gubun
String	ls_plnt , ls_splnt              /* 입력에 대한 공장구분 */


//현재 일자,시간 

ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')

ls_gubun = 'GM14'

ls_indate = Trim(dw_ip.Object.jisi_date[1])  // 기준일자
ls_chdate = Trim(dw_ip.Object.jisi_date2[1])  // 출하일자

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_file_name,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!", '')
	
	return -1
end if

li_cnt = 0
st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'
Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	//messagebox('',FileRead(li_FileNum, ls_Input_Data))
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	ls_citnbr = ''
	li_cnt ++

	ls_custcd 		= trim(mid(ls_Input_Data,1,4))
	ls_factory 		= trim(mid(ls_Input_Data,5,2))
	ls_itnbr 		= trim(mid(ls_Input_Data,7,16))
	ls_CARCODE 		= trim(mid(ls_Input_Data,23,3))
	ls_PART_CODE 	=  trim(mid(ls_Input_Data,26,2))
	ls_BODY_COLOR 	= trim(mid(ls_Input_Data,28,3))
	ld_CUR_SUM 		= double(trim(mid(ls_Input_Data,31,7)))
	ld_CUR_STOCK 	= double(trim(mid(ls_Input_Data,38,7)))
	
		// --- 맨처음에만 데이타 Clear
	if	li_cnt = 1	then
		Select Count(*) Into :ll_cnt
		  From van_GM14
		 WHERE SABU 		= :arg_sabu AND
				 WRK_DATE 	= :ls_indate AND
				 CUSTCD 		= :ls_custcd AND
				 DATAGUB like :arg_datagub;
		If ll_cnt > 0 Then
			delete van_GM14
			 WHERE SABU 		= :arg_sabu AND
					 WRK_DATE 	= :ls_indate AND
					 CUSTCD 		= :ls_custcd AND
					 DATAGUB like :arg_datagub;
			if sqlca.sqlcode <> 0 then
				wf_error(ls_gubun,li_cnt,ls_indate, arg_datagub, '.' , '삭제(van_GM14 Error) - 기존자료.', '')
				
				FileClose(li_FileNum)
				return -2
			end if
					 
		End If
	end if	
	
	ld_PREV_USE 	= double(trim(mid(ls_Input_Data,45,5)))
	ld_PREV_NIGHT 	= double(trim(mid(ls_Input_Data,50,5)))
	ld_PLAN_DD0 	= double(trim(mid(ls_Input_Data,55,5)))
	ld_PLAN_ND0 	= double(trim(mid(ls_Input_Data,60,5)))
	ld_PLAN_DD1 	= double(trim(mid(ls_Input_Data,65,5)))
	ld_PLAN_ND1 	= double(trim(mid(ls_Input_Data,70,5)))
	ld_PLAN_D2 		= double(trim(mid(ls_Input_Data,75,5)))
	ld_PLAN_D3 		= double(trim(mid(ls_Input_Data,80,5)))
	ld_PLAN_D4 		= double(trim(mid(ls_Input_Data,85,5)))
	ld_PLAN_D5 		= double(trim(mid(ls_Input_Data,90,5)))
	ld_PLAN_D6 		= double(trim(mid(ls_Input_Data,95,5)))
	ld_PLAN_D7 		= double(trim(mid(ls_Input_Data,100,5)))
	ld_PLAN_D8 		= double(trim(mid(ls_Input_Data,105,5)))
	ld_PLAN_D9 		= double(trim(mid(ls_Input_Data,110,5)))
	ld_PLAN_D10		= double(trim(mid(ls_Input_Data,115,5)))
	ld_PLAN_D11		= double(trim(mid(ls_Input_Data,120,5)))
	ld_PLAN_D12		= double(trim(mid(ls_Input_Data,125,5)))
	ld_PLAN_D13		= double(trim(mid(ls_Input_Data,130,5)))
	ld_PLAN_DJAN	= double(trim(mid(ls_Input_Data,135,7)))
	ld_PLAN_M1 		= double(trim(mid(ls_Input_Data,142,7)))
	ld_PLAN_M2 		= double(trim(mid(ls_Input_Data,149,7)))


	If ls_PART_CODE = '' Or isNull(ls_PART_CODE) then ls_PART_CODE = '.' ;
	If ls_BODY_COLOR = '' Or isNull(ls_BODY_COLOR) then ls_BODY_COLOR = '.' ;
	
	
//납품장소별 거래처 읽어오기  -- RFNA2 : HMC/KMC , RFNA3 : 대우
	select nvl(RFNA2,''),nvl(RFNA2,'')
	into :ls_mcvcod,:ls_mdcvcod
	from reffpf
	where sabu = :arg_sabu and
			rfcod = '8I' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mdcvcod) = '' OR isNull(ls_mdcvcod) then
		wf_error(arg_file_name,li_cnt,ls_PART_CODE,ls_factory,ls_itnbr,'참조테이블에(8I) 하치장(납품장소) 코드가 없습니다.', '')
		
		Continue ;
	end if
	
//	String  ls_itnbr2
//	ls_itnbr2 = trim(mid(ls_itnbr,2,15))  // -- 앞의 한자리는 제외.{P}
	
	
//	//자체품번 읽어오기(자체거래처코드)
//	select fun_get_itnbr_from_cunbr( :ls_itnbr, :ls_mdcvcod )
//	into	 :ls_mitnbr
//	from dual ;
	
	ls_mitnbr = ls_itnbr
	//---------------------------------------------------------

	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		wf_error(arg_file_name,li_cnt,ls_PART_CODE,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.', ls_mdcvcod)
		
		Continue ;
	End IF

	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
	ls_citnbr = trim(ls_citnbr)
	

		insert into van_GM14(SABU,    CUSTCD,    FACTORY,  ITNBR,     CARCODE, PART_CODE, BODY_COLOR,
		 							CUR_SUM, CUR_STOCK, PREV_USE, PREV_NIGHT,PLAN_DD0,PLAN_ND0,  PLAN_DD1,
									PLAN_ND1,PLAN_D2,   PLAN_D3,  PLAN_D4,   PLAN_D5, PLAN_D6,   PLAN_D7,
									PLAN_D8, PLAN_D9,   PLAN_D10, PLAN_D11,  PLAN_D12,PLAN_D13,  PLAN_DJAN,
									PLAN_M1, PLAN_M2,   WRK_DATE, DATAGUB,
		                     CRT_DATE,CRT_TIME,  CRT_USER, MITNBR,    MCVCOD,  MDCVCOD,   CITNBR, work_date)       
			values(:arg_SABU,   :ls_CUSTCD,   :ls_FACTORY, :ls_ITNBR,     :ls_CARCODE, :ls_PART_CODE, :ls_BODY_COLOR,
			       :ld_CUR_SUM, :ld_CUR_STOCK,:ld_PREV_USE,:ld_PREV_NIGHT,:ld_PLAN_DD0,:ld_PLAN_ND0,  :ld_PLAN_DD1,
					 :ld_PLAN_ND1,:ld_PLAN_D2,  :ld_PLAN_D3, :ld_PLAN_D4,   :ld_PLAN_D5, :ld_PLAN_D6,   :ld_PLAN_D7,
					 :ld_PLAN_D8, :ld_PLAN_D9,  :ld_PLAN_D10,:ld_PLAN_D11,  :ld_PLAN_D12,:ld_PLAN_D13,  :ld_PLAN_DJAN,
					 :ld_PLAN_M1, :ld_PLAN_M2,  :ls_INDATE,  :arg_datagub,
 					 :ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,:ls_MITNBR,:ls_mdcvcod,:ls_MDCVCOD,:ls_citnbr , :ls_chdate);
		if sqlca.sqlcode <> 0 then
			
			st_state.Visible = False
			wf_error(arg_file_name,li_cnt,ls_PART_CODE,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']',ls_mdcvcod)
			rollback;
			FileClose(li_FileNum)
			return -3
		end if

	
	
	
	/*******************************************************************/
	il_succeed++
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt)
Loop

// van file close
FileClose(li_FileNum)

//van 파일명 변경

//li_FileNum = FileCopy(arg_file_name,left(arg_file_name,pos(trim(arg_file_name),".")) + "bak",TRUE)
//if li_FileNum <> 1 then
//	Rollback ;
//	st_state.Visible = False
//	wf_error(arg_file_name,0,'','','',"파일변경에 에러가 발생했습니다."  )
//	
//	return -4
//end if

//van 파일 삭제
//if not FileDelete(arg_file_name) then 
//	Rollback ;
//	st_state.Visible = False
//	messagebox('error','화일삭제 에러입니다.')
//	return -4
//end if

commit;

st_state.Visible = False
return ll_data
end function

public function integer wf_van_gm16 (string arg_file_name, string arg_sabu, string arg_datagub);	
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
Long  ll_data = 0, ll_cnt
string ls_SABU,ls_CUSTCD,ls_FACTORY,ls_ITNBR, ls_bal_no, ls_ITDSC 
string ls_DLY_DATE, ls_BAL_DATE, ls_DLY_TIME, ls_QUA_TYPE, &
     	 ls_CARCODE,  ls_DLY_DIV,  ls_PART_CODE, &
		 ls_DLY_CYCLE,ls_RACK_TYPE,ls_BAL_STATUS, ls_DLY_CHASU, ls_DLY_TYPE, &
		 ls_QUA_OK,   ls_GROUP_NO, ls_COLOR_CODE,ls_CNY_CODE

long ll_BAL_QTY,ll_RACK_CARD,ll_RACK_QTY
string ls_CRT_DATE,ls_CRT_TIME,ls_CRT_USER
string ls_MITNBR,ls_MCVCOD,ls_MDCVCOD,ls_citnbr , ls_gubun

//현재 일자,시간 
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')

ls_gubun = 'GM16'

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_file_name,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!",'')
	return -1
end if

ls_indate = Trim(dw_ip.Object.jisi_date[1])  // 기준일자

li_cnt = 0

st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'
Do While	FileRead(li_FileNum, ls_Input_Data) <> -100

	
	SetNull(ls_mitnbr)
	SetNull(ls_mcvcod)
	SetNull(ls_mdcvcod)
	SetNull(ls_citnbr)
	
	li_cnt ++

	ls_custcd 		= trim(mid(ls_Input_Data,1,4))
	ls_factory 		= trim(mid(ls_Input_Data,5,2))
	ls_bal_no 		= trim(mid(ls_Input_Data,7,11))
	ls_itnbr 		= trim(mid(ls_Input_Data,18,16))
	ls_ITDSC 		= trim(mid(ls_Input_Data,34,30))
	ll_BAL_QTY 		= long(mid(ls_Input_Data,64,7))
	ls_DLY_DATE 	= trim(mid(ls_Input_Data,71,8))
	ls_BAL_DATE 	= trim(mid(ls_Input_Data,79,8))
	ls_DLY_TIME 	= trim(mid(ls_Input_Data,87,5))
	ll_RACK_CARD 	= long(mid(ls_Input_Data,92,5))
	ll_RACK_QTY 	= long(mid(ls_Input_Data,97,6))
	ls_QUA_TYPE 	= trim(mid(ls_Input_Data,103,1))
	ls_CARCODE 		= trim(mid(ls_Input_Data,104,3))
	ls_DLY_DIV 		= trim(mid(ls_Input_Data,107,4))
	ls_PART_CODE 	= trim(mid(ls_Input_Data,111,4))
	ls_DLY_CYCLE 	= trim(mid(ls_Input_Data,115,6))
	ls_RACK_TYPE 	= trim(mid(ls_Input_Data,121,4))
	ls_BAL_STATUS 	= trim(mid(ls_Input_Data,125,1))
	ls_DLY_CHASU 	= trim(mid(ls_Input_Data,126,2))
	ls_DLY_TYPE 	= trim(mid(ls_Input_Data,128,1))
	ls_QUA_OK 		= trim(mid(ls_Input_Data,129,1))
	ls_GROUP_NO 	= trim(mid(ls_Input_Data,130,3))
	ls_COLOR_CODE 	= trim(mid(ls_Input_Data,133,3))
	ls_CNY_CODE 	= trim(mid(ls_Input_Data,136,3))

		// --- 맨처음에만 데이타 Clear
	if	li_cnt = 1	then
		Select Count(*) Into :ll_cnt
		  From van_GM16
		 WHERE SABU 		= :arg_sabu AND
				 BAL_DATE 	= :ls_indate AND
				 CUSTCD 		= :ls_custcd AND
				 DATAGUB like :arg_datagub;
		If ll_cnt > 0 Then
			delete van_GM16
			 WHERE SABU 		= :arg_sabu AND
					 BAL_DATE 	= :ls_indate AND
					 CUSTCD 		= :ls_custcd AND
					 DATAGUB like :arg_datagub;
			if sqlca.sqlcode <> 0 then
				wf_error(ls_gubun,li_cnt,ls_indate, arg_datagub, '.' , '삭제(van_GM14 Error) - 기존자료.','')
				
				FileClose(li_FileNum)
				return -2
			end if
					 
		End If
	end if	
	
	
//납품장소별 거래처 읽어오기  -- RFNA2 : HMC/KMC , RFNA3 : 대우
	select nvl(RFNA2,''),nvl(RFNA3,'')
	into :ls_mcvcod,:ls_mdcvcod
	from reffpf
	where sabu = :arg_sabu and
			rfcod = '8I' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mdcvcod) = '' OR isNull(ls_mdcvcod) then
		wf_error(arg_file_name,li_cnt,ls_PART_CODE,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 하치장(납품장소) 코드가 없습니다.', ls_mdcvcod)
		
		Continue ;
	end if
	
//	String  ls_itnbr2
//	ls_itnbr2 = trim(mid(ls_itnbr,2,15))
	
	//자체품번 읽어오기(자체거래처코드)
//	select fun_get_itnbr_from_cunbr( :ls_itnbr, :ls_mdcvcod )
//	into	 :ls_mitnbr
//	from dual ;
	ls_mitnbr = ls_itnbr
	//---------------------------------------------------------

	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		//Rollback;
		wf_error(arg_file_name,li_cnt,ls_bal_no,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.', ls_mdcvcod)
		
		Continue ;
	End IF
	
	ls_mitnbr 	= trim(ls_mitnbr)
	ls_mcvcod 	= trim(ls_mcvcod)
	ls_mdcvcod 	= trim(ls_mdcvcod)
	ls_citnbr 	= trim(ls_citnbr)
   ll_data++
	insert into van_GM16(SABU,  CUSTCD,   FACTORY,   bal_no,   ITNBR,
	                  ITDSC,    BAL_QTY,  DLY_DATE,  DLY_TIME, RACK_CARD,
							RACK_QTY, QUA_TYPE, CARCODE,   DLY_DIV,  PART_CODE,
							DLY_CYCLE,RACK_TYPE,BAL_STATUS,DLY_CHASU,DLY_TYPE,
							QUA_OK,   GROUP_NO, COLOR_CODE,CNY_CODE,
							CRT_DATE,CRT_TIME,CRT_USER,MITNBR,MCVCOD,MDCVCOD,CITNBR,
							DATAGUB)       
	 values(:arg_SABU,:ls_CUSTCD,   :ls_FACTORY,  :ls_bal_no,    :ls_ITNBR,
	        :ls_ITDSC,:ll_BAL_QTY,  :ls_DLY_DATE, :ls_DLY_TIME,  :ll_RACK_CARD,
                  	:ll_RACK_QTY, :ls_CARCODE,  :ls_DLY_DIV,   :ls_PART_CODE,
							:ls_DLY_CYCLE,:ls_RACK_TYPE,:ls_BAL_STATUS,:ls_DLY_TYPE,
							:ls_QUA_OK,   :ls_GROUP_NO, :ls_COLOR_CODE,:ls_CNY_CODE,
							:ls_CRT_DATE,:ls_CRT_TIME,:gs_empno,:ls_MITNBR,:ls_mdcvcod,:ls_MDCVCOD,:ls_CITNBR,
							:arg_datagub);
	
	if sqlca.sqlcode <> 0 then
		
		wf_error(arg_file_name,li_cnt,ls_bal_no,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']',ls_mdcvcod)
		rollback;
		FileClose(li_FileNum)
		st_state.Visible = False
		return -3
	end if
	il_succeed++
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt) 

Loop


// van file close
FileClose(li_FileNum)

//van 파일명 변경

//li_FileNum = FileCopy(arg_file_name,left(arg_file_name,pos(trim(arg_file_name),".")) + "bak",TRUE)
//if li_FileNum <> 1 then
//	Rollback ;
//	st_state.Visible = False
//	wf_error(arg_file_name,0,'','','',"파일변경에 에러가 발생했습니다."  )
//	return -4
//end if

//van 파일 삭제
//if not FileDelete(arg_file_name) then 
//	rollback;
//	st_state.Visible = False
//	messagebox('error','화일삭제 에러입니다.')
//	return -4
//end if 

commit;

st_state.Visible = False
return ll_data
end function

public function integer wf_van_gm17 (string arg_file_name, string arg_sabu, string arg_datagub);/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	

string ls_Input_Data  ,ls_indate
integer li_FileNum,li_cnt,li_rowcnt , li_file_rtn 
Long  ll_data = 0, ll_cnt
string ls_SABU,  ls_bal_no,       ls_CUSTCD,    ls_FACTORY,  ls_ITNBR,    ls_ITDSC, &
       ls_DLY_DATE,  ls_BAL_DATE, ls_MAS_CUSTCD,ls_LS_CHK,   ls_BAL_TYPE, &
		 ls_GAN_STATUS,ls_CUSTNM,   ls_DLY_TIME,  ls_QUA_TYPE, ls_CARCODE,  &
		 ls_DLY_DIV,   ls_PART_CODE,ls_PART_ID,   ls_DLY_CYCLE,ls_RACK_TYPE, &
		 ls_REV_NO,    ls_SAVE_AR,  ls_SHORTAGE,  ls_PO_NO,    ls_PECULIAR, &
		 ls_MV_CARCODE,ls_PACK_LOC, ls_BAL_STATUS,ls_CNY_NAME
Long	 ll_BAL_QTY,   ll_IP_QTY,   ll_RETURN_QTY,ll_RACK_CARD, ll_RACK_QTY
string ls_CRT_DATE, ls_CRT_TIME, ls_CRT_USER, ls_CITNBR, ls_MITNBR, ls_MCVCOD, ls_MDCVCOD, &
		 ls_gubun 

//현재 일자,시간 
ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_crt_user = gs_userid

ls_gubun = 'GM17'

ls_indate = Trim(dw_ip.Object.jisi_date[1])  // 기준일자

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_file_name,li_cnt,'','','',"["+arg_file_name+"]"+" VAN자료가 없습니다.!!", '')
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

	ls_custcd 		= trim(mid(ls_Input_Data,1,4))
	ls_factory 		= trim(mid(ls_Input_Data,5,2))
	ls_bal_no 		= trim(mid(ls_Input_Data,7,11))
	ls_itnbr 		= trim(mid(ls_Input_Data,18,16))
	ls_ITDSC 		= trim(mid(ls_Input_Data,34,30))
	ll_BAL_QTY 		= Long(trim(mid(ls_Input_Data,64,7)))
	ll_IP_QTY 		= Long(trim(mid(ls_Input_Data,71,7)))
	ll_RETURN_QTY 	= Long(trim(mid(ls_Input_Data,78,7)))

		// --- 맨처음에만 데이타 Clear
	if	li_cnt = 1	then
		Select Count(*) Into :ll_cnt
		  From van_GM17
		 WHERE SABU 		= :arg_sabu AND
				 BAL_DATE 	= :ls_indate AND
				 CUSTCD 		= :ls_custcd AND
				 DATAGUB like :arg_datagub;
		If ll_cnt > 0 Then
			delete van_GM17
			 WHERE SABU 		= :arg_sabu AND
					 BAL_DATE 	= :ls_indate AND
					 CUSTCD 		= :ls_custcd AND
					 DATAGUB like :arg_datagub;
			if sqlca.sqlcode <> 0 then
				wf_error(ls_gubun,li_cnt,ls_indate, arg_datagub, '.' , '삭제(van_GM17 Error) - 기존자료.', '')
				
				FileClose(li_FileNum)
				return -2
			end if
					 
		End If
	end if	


	ls_DLY_DATE 	= trim(mid(ls_Input_Data,85,8))
	ls_BAL_DATE 	= trim(mid(ls_Input_Data,93,8))
	ls_MAS_CUSTCD 	= trim(mid(ls_Input_Data,101,1))
	ls_LS_CHK 		= trim(mid(ls_Input_Data,102,1))
	ls_BAL_TYPE 	= trim(mid(ls_Input_Data,103,1))
	ls_GAN_STATUS 	= trim(mid(ls_Input_Data,104,1))
	ls_CUSTNM 		= trim(mid(ls_Input_Data,105,26))
	ls_DLY_TIME 	= trim(mid(ls_Input_Data,131,5))
	ll_RACK_CARD 	= Long(trim(mid(ls_Input_Data,136,5)))
	ll_RACK_QTY 	= Long(trim(mid(ls_Input_Data,141,6)))

	ls_QUA_TYPE 	= trim(mid(ls_Input_Data,147,1))
	ls_CARCODE 		= trim(mid(ls_Input_Data,148,3))
	ls_DLY_DIV 		= trim(mid(ls_Input_Data,151,4))
	ls_PART_CODE 	= trim(mid(ls_Input_Data,155,4))
	ls_PART_ID 		= trim(mid(ls_Input_Data,159,3))
	ls_DLY_CYCLE 	= trim(mid(ls_Input_Data,162,6))
	ls_RACK_TYPE 	= trim(mid(ls_Input_Data,168,4))
	ls_REV_NO 		= trim(mid(ls_Input_Data,172,8))
	ls_SAVE_AR 		= trim(mid(ls_Input_Data,180,8))
	ls_SHORTAGE 	= trim(mid(ls_Input_Data,188,1))
	ls_PO_NO 		= trim(mid(ls_Input_Data,189,7))
	ls_PECULIAR 	= trim(mid(ls_Input_Data,196,1))
	ls_MV_CARCODE 	= trim(mid(ls_Input_Data,197,20))
	ls_PACK_LOC 	= trim(mid(ls_Input_Data,217,1))
	ls_BAL_STATUS 	= trim(mid(ls_Input_Data,218,1))
	ls_CNY_NAME 	= trim(mid(ls_Input_Data,219,8))
	
//납품장소별 거래처 읽어오기  -- RFNA2 : HMC/KMC , RFNA3 : 대우
	select nvl(RFNA2,''),nvl(RFNA3,'')
	into :ls_mcvcod,:ls_mdcvcod
	from reffpf
	where sabu = :arg_sabu and
			rfcod = '8I' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mdcvcod) = '' OR isNull(ls_mdcvcod) then
		wf_error(arg_file_name,li_cnt,ls_PART_CODE,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 하치장(납품장소) 코드가 없습니다.', ls_mdcvcod)
		
		Continue ;
	end if
	
//	String  ls_itnbr2
//	ls_itnbr2 = trim(mid(ls_itnbr,2,15))
	//자체품번 읽어오기(자체거래처코드)
//	select fun_get_itnbr_from_cunbr( :ls_itnbr, :ls_mdcvcod )
//	into	 :ls_mitnbr
//	from dual ;
	ls_mitnbr = ls_itnbr
	//---------------------------------------------------------

	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
	
		wf_error(arg_file_name,li_cnt,ls_bal_no,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.', ls_mdcvcod)
		
		Continue ;
	End IF
	
	ls_mitnbr 	= trim(ls_mitnbr)
	ls_mcvcod 	= trim(ls_mcvcod)
	ls_mdcvcod 	= trim(ls_mdcvcod)
	ls_citnbr 	= trim(ls_citnbr)
   ll_data++
	insert into van_GM17(  SABU, 	CUSTCD, FACTORY,	bal_no, ITNBR,   ITDSC,
						BAL_QTY ,	IP_QTY 	,RETURN_QTY,	ls_DLY_DATE ,	ls_BAL_DATE,
						MAS_CUSTCD,	LS_CHK 	,BAL_TYPE ,	GAN_STATUS,CUSTNM,
						DLY_TIME,	RACK_CARD,RACK_QTY ,	QUA_TYPE,  CARCODE,
						DLY_DIV,	   PART_CODE,PART_ID,	DLY_CYCLE, RACK_TYPE,
						REV_NO,	   SAVE_AR,	 SHORTAGE,	PO_NO,	  PECULIAR,
						MV_CARCODE,	PACK_LOC, BAL_STATUS,CNY_NAME,
						CRT_DATE,   CRT_TIME,   CRT_USER,   CITNBR,   MITNBR,   
						MCVCOD,     MDCVCOD,  DATAGUB )       
		values( :arg_SABU, :ls_bal_no,  :ls_CUSTCD, 	:ls_FACTORY,  :ls_ITNBR,   :ls_ITDSC,     
				  :ll_BAL_QTY ,  :ll_IP_QTY 	,:ll_RETURN_QTY,:ls_DLY_DATE , :ls_BAL_DATE,
				  :ls_MAS_CUSTCD,:ls_LS_CHK 	,:ls_BAL_TYPE , :ls_GAN_STATUS,:ls_CUSTNM,
				  :ls_DLY_TIME,  :ll_RACK_CARD,:ll_RACK_QTY , :ls_QUA_TYPE,	 :ls_CARCODE,
				  :ls_DLY_DIV,	  :ls_PART_CODE,:ls_PART_ID,	 :ls_DLY_CYCLE, :ls_RACK_TYPE,
				  :ls_REV_NO,	  :ls_SAVE_AR,	 :ls_SHORTAGE,	 :ls_PO_NO,	    :ls_PECULIAR,
				  :ls_MV_CARCODE,:ls_PACK_LOC, :ls_BAL_STATUS,:ls_CNY_NAME, 	
				  :ls_CRT_DATE,  :ls_CRT_TIME, :ls_CRT_USER,  :ls_CITNBR,    :ls_MITNBR,   
 				  :ls_mdcvcod,    :ls_MDCVCOD,  :arg_datagub  );
	
	if sqlca.sqlcode <> 0 then
		
		wf_error(arg_file_name,li_cnt,ls_bal_no,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']', ls_mdcvcod)
		rollback;
		FileClose(li_FileNum)
		st_state.Visible = False
		return -3
	end if
	il_succeed++
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt) 

Loop


// van file close
FileClose(li_FileNum)

//van 파일명 변경

//li_FileNum = FileCopy(arg_file_name,left(arg_file_name,pos(trim(arg_file_name),".")) + "bak",TRUE)
//if li_FileNum <> 1 then
//	Rollback ;
//	st_state.Visible = False
//	wf_error(arg_file_name,0,'','','',"파일변경에 에러가 발생했습니다."  )
//	return -4
//end if

//van 파일 삭제
//if not FileDelete(arg_file_name) then 
//	rollback;
//	st_state.Visible = False
//	messagebox('error','화일삭제 에러입니다.')
//	return -4
//end if 

commit;

st_state.Visible = False
return ll_data

return 1
end function

public function integer wf_van_gm19 (string arg_file_name, string arg_sabu, string arg_datagub);/*
  [return 값 정의]
   
   -1 : txt 화일이 존재하지 않습니다.
	-2 : 화일명의 값과 화일내용이 같지 않은 에러
   -3 : 이미 생성된 자료
	-4 : 파일 변경/삭제 에러
    1이상 : 정상적으로 생성 완료  또는 데이타 건수
*/	

string ls_Input_Data ,ls_indate
integer li_FileNum,li_cnt,li_rowcnt
Long   ll_data = 0 , ll_cnt
string ls_CUSTCD,ls_FACTORY,ls_ITNBR, &
       ls_IPNO, ls_LC_CHK, ls_IP_DATE, ls_IP_TIME, ls_IP_UMR, &
		 ls_IP_STATUS, ls_BAL_NOM, ls_WORK_DATE, ls_BAL_NO
string ls_CRT_DATE,ls_CRT_TIME,ls_CRT_USER,ls_MITNBR,ls_MCVCOD,ls_MDCVCOD
long   ll_IP_QTY,ll_IP_DAN,ll_IP_AMT ,ll_NIP_QTY,ll_PO_NO
string ls_CITNBR ,ls_gubun


//현재 일자,시간 

ls_crt_date = string(today(),'yyyymmdd')
ls_crt_time = string(today(),'hhmm')
ls_gubun = 'GM19'

ls_indate = Trim(dw_ip.Object.jisi_date[1])  // 기준일자

li_FileNum = FileOpen(arg_file_name,LineMode!,Read!)
if li_FileNum = -1 then
	wf_error(arg_file_name,li_cnt,ls_bal_no,ls_factory,ls_itnbr,"["+arg_file_name+"]"+" VAN자료가 없습니다.!!", '')
	return -1
end if

li_cnt = 0
il_succeed = 0

st_state.Visible = True
st_state.Text = '데이타를 읽는 중입니다...'

// tab으로 분리된 경우 첫줄 skip
If cbx_tab.Checked And 	li_cnt = 0 Then
	FileRead(li_FileNum, ls_Input_Data)
End If
	
Do While	FileRead(li_FileNum, ls_Input_Data) <> -100
	ls_mitnbr = ''
	ls_mcvcod = ''
	ls_mdcvcod = ''
	li_cnt ++

	If cbx_tab.Checked = False Then
		ls_custcd 	= trim(mid(ls_Input_Data,1,4))
		ls_factory 	= trim(mid(ls_Input_Data,5,2))
		ls_itnbr 	= trim(mid(ls_Input_Data,7,16))
	Else
		ls_custcd 	= trim(f_Get_Token(ls_Input_Data,'~t'))
		ls_factory 	= trim(f_Get_Token(ls_Input_Data,'~t'))
		ls_itnbr 	= trim(f_Get_Token(ls_Input_Data,'~t'))
	End If
	
	// --- 맨처음에만 데이타 Clear
	if	li_cnt = 1	then
		Select Count(*) Into :ll_cnt
		  From van_gumsu
		 WHERE VNDGU 		= :arg_sabu AND
				 REGDATE 	= :ls_indate AND
				 DOCCODE like :arg_datagub;
		If ll_cnt > 0 Then
			delete van_gumsu
			 WHERE VNDGU 		= :arg_sabu AND
				    REGDATE 	= :ls_indate AND
				    DOCCODE like :arg_datagub AND
					 CNFIRM = 'N';
			if sqlca.sqlcode <> 0 then
				wf_error(ls_gubun,li_cnt,ls_indate, arg_datagub, '.' , '삭제(van_gumsu Error) - 기존자료.', '')
				
				FileClose(li_FileNum)
				return -2
			end if					 
		End If
	end if	

	If cbx_tab.Checked = False Then
		ls_IPNO 		= trim(mid(ls_Input_Data,23,13))
		ls_LC_CHK 	= trim(mid(ls_Input_Data,36,1))
		ls_IP_DATE 	= trim(mid(ls_Input_Data,37,8))
		ls_IP_TIME 	= trim(mid(ls_Input_Data,45,5))
		ll_IP_QTY 	= long(mid(ls_Input_Data,50,7))
		ll_IP_DAN 	= long(mid(ls_Input_Data,57,9))
		ll_IP_AMT 	= long(mid(ls_Input_Data,66,11))
	
		ls_IP_UMR 	 = trim(mid(ls_Input_Data,77,1))
		ls_IP_STATUS = trim(mid(ls_Input_Data,78,1))
		ll_NIP_QTY 	 = long(mid(ls_Input_Data,79,7))
		ls_BAL_NOM 	 = trim(mid(ls_Input_Data,86,10))
		ls_WORK_DATE = trim(mid(ls_Input_Data,96,8))
		ll_PO_NO 	 = long(mid(ls_Input_Data,104,7))
		ls_BAL_NO 	 = trim(mid(ls_Input_Data,111,11))
	Else
		ls_IPNO 		= trim(f_Get_Token(ls_Input_Data,'~t'))
		ls_LC_CHK 	= trim(f_Get_Token(ls_Input_Data,'~t'))
		ls_IP_DATE 	= trim(f_Get_Token(ls_Input_Data,'~t'))
		ls_IP_TIME 	= trim(f_Get_Token(ls_Input_Data,'~t'))
		ll_IP_QTY 	= dec(trim(f_Get_Token(ls_Input_Data,'~t')))
		ll_IP_DAN 	= dec(trim(f_Get_Token(ls_Input_Data,'~t')))
		ll_IP_AMT 	= dec(trim(f_Get_Token(ls_Input_Data,'~t')))
	
		ls_IP_UMR 	 = trim(f_Get_Token(ls_Input_Data,'~t'))
		ls_IP_STATUS = trim(f_Get_Token(ls_Input_Data,'~t'))
		ll_NIP_QTY 	 = dec(trim(f_Get_Token(ls_Input_Data,'~t')))
		ls_BAL_NOM 	 = trim(f_Get_Token(ls_Input_Data,'~t'))
		ls_WORK_DATE = trim(f_Get_Token(ls_Input_Data,'~t'))
		ll_PO_NO 	 = dec(trim(f_Get_Token(ls_Input_Data,'~t')))
		ls_BAL_NO 	 = trim(f_Get_Token(ls_Input_Data,'~t'))
	End If
	
	If IsNull(ls_LC_CHK) Or ls_LC_CHK = '' Then ls_LC_CHK = 'V'
	
	//납품장소별 거래처 읽어오기  -- RFNA2 : HMC/KMC , RFNA3 : 대우
	select nvl(RFNA2,''),nvl(RFNA2,'')
	into :ls_mcvcod,:ls_mdcvcod
	from reffpf
	where sabu = :arg_sabu and
			rfcod = '8I' and
			rfgub = :ls_factory;
			
	if sqlca.sqlcode <> 0 or &
	   trim(ls_mdcvcod) = '' OR isNull(ls_mdcvcod) then
		wf_error(arg_file_name,li_cnt,ls_bal_no,ls_factory,ls_itnbr,'참조테이블에(REFFPF) 하치장(납품장소) 코드가 없습니다.', ls_mdcvcod)
		
		Continue ;
	end if
	
	ls_mitnbr = ls_itnbr
	//---------------------------------------------------------
	
	if sqlca.sqlcode <> 0 or trim(ls_mitnbr) = '' or isNull(ls_mitnbr) then
		
		wf_error(arg_file_name,li_cnt,ls_bal_no,ls_factory,ls_itnbr,'품번마스타에 품번이 등록되지 않았습니다.', ls_mdcvcod)
		
		Continue ;
	End IF
	
	ls_mitnbr = trim(ls_mitnbr)
	ls_mcvcod = trim(ls_mcvcod)
	ls_mdcvcod = trim(ls_mdcvcod)
		
	ll_data++

	ll_cnt = 0
	select count(*) into :ll_cnt 
	  from van_gumsu 
	 where partno = :ls_itnbr and baljuno = :ls_IPNO and localyn = :ls_LC_CHK and gumdate = :ls_IP_DATE and regseq = 0 and plnt = :ls_FACTORY;
	 
	If ll_cnt = 0 Then
		/* van_gumsu에 인서트 */
		INSERT INTO VAN_GUMSU
				  ( VNDGU,   REGDATE, REGNO, PARTNO,  VQTY,   VPRC,  VAMT, 
					 BALJUNO, LOCALYN, VTYPE, DOCCODE, CNFIRM, CVCOD, GUMDATE, 
					 REGSEQ,  PLNT,    OQTY)
		 VALUES ( :arg_SABU,    :ls_indate, :ll_data, :ls_ITNBR,:ll_IP_QTY, :ll_IP_DAN, :ll_IP_AMT,
					 :ls_IPNO, :ls_LC_CHK, 'N', :arg_datagub, 'N',:ls_mdcvcod, :ls_IP_DATE,
					 0,  :ls_FACTORY, 0 );
		if sqlca.sqlcode <> 0 then
			messagebox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			st_state.Visible = False
			wf_error(arg_file_name,li_cnt,ls_bal_no,ls_factory,ls_itnbr,sqlca.sqlerrText+" 입력에러가 발생했습니다." + '[열위치:'+string(li_cnt)+']', ls_mdcvcod)
			rollback;
			FileClose(li_FileNum)
			return 0
		end if
		
		il_succeed++
	End If
	
	st_state.Text = "파일명: "+Right(arg_file_name,9) +"  라인수 :" +String(li_cnt) 
Loop

// van file close
FileClose(li_FileNum)

commit;

st_state.Visible = False
return li_cnt
end function

public subroutine wf_error (string as_gubun, long al_line, string as_bal_no, string as_factory, string as_itnbr, string as_errtext, string as_cvcod);Long ll_r

ll_r = dw_list.InsertRow(0)

dw_list.Object.saupj[ll_r] 	= Trim(dw_ip.Object.saupj[1])
dw_list.Object.err_date[ll_r] = Trim(dw_ip.Object.jisi_date[1])
dw_list.Object.err_time[ll_r] = f_totime()
dw_list.Object.doctxt[ll_r] 	= as_gubun
dw_list.Object.err_line[ll_r] = al_line
dw_list.Object.doccode[ll_r] 	= as_bal_no
dw_list.Object.factory[ll_r] 	= as_factory
dw_list.Object.itnbr[ll_r] 	= as_itnbr
dw_list.Object.err_txt[ll_r] 	= as_errtext
dw_list.Object.cvcod[ll_r] 	= as_cvcod

dw_list.scrolltorow(ll_r)
end subroutine

on w_sm11_0010.create
int iCurrent
call super::create
this.p_search=create p_search
this.p_delrow=create p_delrow
this.p_delrow_all=create p_delrow_all
this.pb_1=create pb_1
this.dw_gm16=create dw_gm16
this.dw_gm19=create dw_gm19
this.dw_gm14=create dw_gm14
this.dw_gm17=create dw_gm17
this.st_state=create st_state
this.tab_1=create tab_1
this.pb_2=create pb_2
this.p_excel=create p_excel
this.dw_gm16_detail=create dw_gm16_detail
this.cbx_tab=create cbx_tab
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_search
this.Control[iCurrent+2]=this.p_delrow
this.Control[iCurrent+3]=this.p_delrow_all
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.dw_gm16
this.Control[iCurrent+6]=this.dw_gm19
this.Control[iCurrent+7]=this.dw_gm14
this.Control[iCurrent+8]=this.dw_gm17
this.Control[iCurrent+9]=this.st_state
this.Control[iCurrent+10]=this.tab_1
this.Control[iCurrent+11]=this.pb_2
this.Control[iCurrent+12]=this.p_excel
this.Control[iCurrent+13]=this.dw_gm16_detail
this.Control[iCurrent+14]=this.cbx_tab
end on

on w_sm11_0010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_search)
destroy(this.p_delrow)
destroy(this.p_delrow_all)
destroy(this.pb_1)
destroy(this.dw_gm16)
destroy(this.dw_gm19)
destroy(this.dw_gm14)
destroy(this.dw_gm17)
destroy(this.st_state)
destroy(this.tab_1)
destroy(this.pb_2)
destroy(this.p_excel)
destroy(this.dw_gm16_detail)
destroy(this.cbx_tab)
end on

event open;call super::open;
//==========================================================
/* ODBD CONNECT */
//sqlca.DBMS       = "ODBC"
//SQLCA.SERVERNAME = "RAPDOS"
//SQLCA.DBParm     = "connectstring = 'DSN = orders'"
//
//CONNECT USING SQLCA ;
//
//IF sqlca.sqlcode <> 0 THEN
//	MessageBox ("Cannot Connect to Database!", string(sqlca.sqlcode) + '~n' + sqlca.sqlerrtext)
//   DISCONNECT USING SQLCA;
//   halt close
//END IF

//
dw_ip.Object.jisi_date[1] = is_today
dw_ip.Object.jisi_date2[1] = is_today

dw_GM16.SetTransObject(SQLCA)
dw_GM19.SetTransObject(SQLCA)
dw_GM14.SetTransObject(SQLCA)
dw_GM17.SetTransObject(SQLCA)

dw_GM16_detail.SetTransObject(SQLCA)

dw_GM16.Titlebar = False
dw_GM17.Titlebar = False
dw_GM19.Titlebar = False
dw_GM14.Titlebar = False

dw_GM16_detail.visible = False
	
/* User별 사업장 Setting Start */
String saupj
 
//If f_check_saupj(saupj) = 1 Then
//	dw_ip.Modify("saupj.protect=1")
//End If
//dw_ip.SetItem(1, 'saupj', saupj)
f_mod_saupj(dw_ip, 'saupj')

Select rfna3 Into :is_custid      // -- rfna3 : HMC/KMC ,  rfna5 : GM/DAT
  From reffpf
  Where rfcod = 'AD'
    and rfcod != '00' 
	 and rfgub = :gs_saupj ;
If sqlca.sqlcode <> 0 Then
	f_message_chk(33 ,'[사업장]')
	Return
End If


Select dataname Into :is_filepath      // -- 기본 파일Path을 가져옴 
  From syscnfg
  Where sysgu  = 'S' and serial = '9'
    and lineno = '21';
If sqlca.sqlcode <> 0 Then
	f_message_chk(33 ,'[파일Path]')
	Return
End If

dw_ip.Object.gubun[1] = 'AL'

//Tab_1.Tabpage_2.Enabled = False
end event

event closequery;call super::closequery;

//DISCONNECT USING SQLCA;
end event

type p_preview from w_standard_print`p_preview within w_sm11_0010
boolean visible = false
integer x = 4110
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

type p_exit from w_standard_print`p_exit within w_sm11_0010
end type

event p_exit::clicked;close(parent)

end event

type p_print from w_standard_print`p_print within w_sm11_0010
boolean visible = false
integer x = 4283
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

type p_retrieve from w_standard_print`p_retrieve within w_sm11_0010
integer x = 4270
end type







type st_10 from w_standard_print`st_10 within w_sm11_0010
end type



type dw_print from w_standard_print`dw_print within w_sm11_0010
integer x = 3826
integer y = 232
string dataobject = "d_sm11_0010_GM14"
end type

type dw_ip from w_standard_print`dw_ip within w_sm11_0010
integer x = 23
integer y = 28
integer width = 3717
integer height = 356
string dataobject = "d_sm11_0010_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String ls_col , ls_value, ls_itnbr_t, ls_itnbr_f

ls_col = GetColumnName()
ls_value = Trim(GetText())

Choose Case ls_col
	Case "gubun"
		If ls_value > '' Then
			dw_ip.setitem(1, 'filename', wf_choose(ls_value))
		End If		

	Case "itnbr_from"
		ls_itnbr_t = Trim(This.GetItemString(row, 'itnbr_to'))
		if IsNull(ls_itnbr_t) or ls_itnbr_t = '' then
			This.SetItem(row, 'itnbr_to', ls_value)
	   end if
		
	Case "itnbr_to"
		ls_itnbr_f = Trim(This.GetItemString(row, 'itnbr_from'))
		if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
			This.SetItem(row, 'itnbr_from', ls_value)
	   end if

END CHOOSE
end event

type dw_list from w_standard_print`dw_list within w_sm11_0010
integer x = 59
integer y = 532
integer width = 4503
integer height = 1752
string dataobject = "d_sm11_0010_a"
boolean border = false
end type

event dw_list::clicked;//f_multi_select(this)
end event

event dw_list::rowfocuschanged;//
end event

type p_search from uo_picture within w_sm11_0010
integer x = 3749
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;Long ll_cnt, ll_ix
string ls_filename , ls_gubun , ls_reg_gb, ls_indate, ls_chdate


If dw_ip.AcceptText() < 1 Then Return
If dw_ip.AcceptText() < 1 Then Return
If dw_ip.RowCount() < 1 Then Return

ls_gubun		= Trim(dw_ip.Object.gubun[1])
ls_indate 	= Trim(dw_ip.GetItemString(1, 'jisi_date'))
ls_chdate 	= Trim(dw_ip.GetItemString(1, 'jisi_date2'))

If f_datechk(ls_indate) < 1 Then
	f_message_chk(35,'[기준일자]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("jisi_date")
	Return -1
End if
	
If f_datechk(ls_chdate) < 1 Then
	f_message_chk(35,'[출하일자]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("jisi_date2")
	Return -1
End if

if	ls_indate < ls_chdate	then
	messagebox('확인','[출하일자가 기준일자보다 작아야 합니다.]')
	dw_ip.SetFocus()
	dw_ip.SetColumn("jisi_date")
	Return -1
end if	

pointer oldpointer
oldpointer = SetPointer(HourGlass!)

dw_list.reset()

string  sFind   = '/' , sFind2 = '	' , sFind3 = '\'
string  sToken, ls_accept1, ls_return , ls_typenum 
long  llStart, llEnd , llStart2, llEnd2 , llStart3, llEnd3
String  ls_modstring, ls_datagub

/* 해당 file 목록들 Capture */
ls_accept1 = dw_ip.Describe("filename.values") 
llEnd = Len(ls_accept1) + 1
SetNull(ls_return)

//ls_return  = 
Choose Case ls_gubun
	Case "GM14"
	   il_succeed = 0
		ll_cnt=0
		ls_gubun = "GM14"

		 DO
			llStart 		= LastPos(ls_accept1, sFind, llEnd)
			sToken 		= Mid(ls_accept1, (llStart + 1), (llEnd - llStart))
			llEnd2      = Len(sToken) + 1
			llStart2 	= LastPos(sToken, sFind2, llEnd2)
			ls_return	= Mid(Stoken, (llStart2 + 1) , (llEnd2 - llStart2))
			if	ls_return <>'' and not isNull(ls_return) then
				//-- 파일이름 가져오기 -
				ls_filename = ls_return +  '-' + ls_indate + ".TXT"
				//-- 해당 파일이름 구분값 조회 -
				llEnd3      = Len(ls_return) + 1
				llStart3 	= LastPos(ls_return, sFind3, llEnd3)
				ls_datagub	= Mid(ls_return, (llStart3 + 1) , (llEnd3 - llStart3))
				ll_cnt = wf_van_GM14(ls_filename,gs_sabu,ls_datagub )
				If ll_cnt > 0 Then
					wf_error(ls_gubun,ll_cnt, ls_filename, ls_gubun ,'','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.', '')
				End if
			End if
			llEnd = llStart - 1
		 LOOP WHILE llStart > 1
		
		
	Case "GM16"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "GM16"

	 	DO
			llStart 		= LastPos(ls_accept1, sFind, llEnd)
			sToken 		= Mid(ls_accept1, (llStart + 1), (llEnd - llStart))
			llEnd2      = Len(sToken) + 1
			llStart2 	= LastPos(sToken, sFind2, llEnd2)
			ls_return	= Mid(Stoken, (llStart2 + 1) , (llEnd2 - llStart2))
			if	ls_return <>'' and not isNull(ls_return) then
				//-- 파일이름 가져오기 -
				ls_filename = ls_return +  '-' + ls_indate + ".TXT"
				//-- 해당 파일이름 구분값 조회 -
				llEnd3      = Len(ls_return) + 1
				llStart3 	= LastPos(ls_return, sFind3, llEnd3)
				ls_datagub	= Mid(ls_return, (llStart3 + 1) , (llEnd3 - llStart3))
				ll_cnt = wf_van_GM16(ls_filename,gs_sabu, ls_datagub)
				If ll_cnt > 0 Then
					wf_error(ls_gubun,ll_cnt,ls_filename,ls_gubun,'','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.', '')
				End if
			End if
			llEnd = llStart - 1
		LOOP WHILE llStart > 1
	Case "GM17"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "GM17"
	 	DO
			llStart 		= LastPos(ls_accept1, sFind, llEnd)
			sToken 		= Mid(ls_accept1, (llStart + 1), (llEnd - llStart))
			llEnd2      = Len(sToken) + 1
			llStart2 	= LastPos(sToken, sFind2, llEnd2)
			ls_return	= Mid(Stoken, (llStart2 + 1) , (llEnd2 - llStart2))
			if	ls_return <>'' and not isNull(ls_return) then
				//-- 파일이름 가져오기 -
				ls_filename = ls_return +  '-' + ls_indate + ".TXT"
				//-- 해당 파일이름 구분값 조회 -
				llEnd3      = Len(ls_return) + 1
				llStart3 	= LastPos(ls_return, sFind3, llEnd3)
				ls_datagub	= Mid(ls_return, (llStart3 + 1) , (llEnd3 - llStart3))
				ll_cnt = wf_van_GM17(ls_filename,gs_sabu, ls_datagub)
				If ll_cnt > 0 Then
					wf_error(ls_gubun,ll_cnt,ls_filename,ls_gubun,'','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.', '')
				End if
			End if
			llEnd = llStart - 1
		LOOP WHILE llStart > 1
	Case "GM19"
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "GM19"
		DO
			llStart 		= LastPos(ls_accept1, sFind, llEnd)
			sToken 		= Mid(ls_accept1, (llStart + 1), (llEnd - llStart))
			llEnd2      = Len(sToken) + 1
			llStart2 	= LastPos(sToken, sFind2, llEnd2)
			ls_return	= Mid(Stoken, (llStart2 + 1) , (llEnd2 - llStart2))
			if	ls_return <>'' and not isNull(ls_return) then
				//-- 파일이름 가져오기 -
				ls_filename = ls_return +  '-' + ls_indate + ".TXT"
				//-- 해당 파일이름 구분값 조회 -
				llEnd3      = Len(ls_return) + 1
				llStart3 	= LastPos(ls_return, sFind3, llEnd3)
				ls_datagub	= Mid(ls_return, (llStart3 + 1) , (llEnd3 - llStart3))
				ll_cnt = wf_van_GM19(ls_filename,gs_sabu, ls_datagub)
				If ll_cnt > 0 Then
					wf_error(ls_gubun,ll_cnt,ls_filename,ls_gubun,'','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.', '')
				End if
			End if
			llEnd = llStart - 1
		LOOP WHILE llStart > 1
	Case Else
		// GM14 ===========================================================================
	   il_succeed = 0
		ll_cnt=0
		ls_gubun = "GM14"
		ls_modstring = is_filepath + 'b020B/' + is_filepath + 'b020K/' + is_filepath + 'b020C/'
		dw_ip.object.filename.values = ls_modstring 
		ls_accept1 = dw_ip.Describe("filename.values") 
		llEnd = Len(ls_accept1) + 1
		SetNull(ls_return)
		DO
			llStart 		= LastPos(ls_accept1, sFind, llEnd)
			sToken 		= Mid(ls_accept1, (llStart + 1), (llEnd - llStart))
			llEnd2      = Len(sToken) + 1
			llStart2 	= LastPos(sToken, sFind2, llEnd2)
			ls_return	= Mid(Stoken, (llStart2 + 1) , (llEnd2 - llStart2))
			if	ls_return <>'' and not isNull(ls_return) then
				//-- 파일이름 가져오기 -
				ls_filename = ls_return +  '-' + ls_indate + ".TXT"
				//-- 해당 파일이름 구분값 조회 -
				llEnd3      = Len(ls_return) + 1
				llStart3 	= LastPos(ls_return, sFind3, llEnd3)
				ls_datagub	= Mid(ls_return, (llStart3 + 1) , (llEnd3 - llStart3))
				ll_cnt = wf_van_GM14(ls_filename,gs_sabu, ls_datagub)
				If ll_cnt > 0 Then
					wf_error(ls_gubun,ll_cnt, ls_filename, ls_gubun ,'','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.', '')
				End if
			End if
			llEnd = llStart - 1
		LOOP WHILE llStart > 1
		// GM16 ===========================================================================
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "GM16"
		ls_modstring = is_filepath + 'c020B/' + is_filepath + 'c020K/' + is_filepath + 'c020C/' &
		             + is_filepath + 'c020D/'
		dw_ip.object.filename.values = ls_modstring 
		ls_accept1 = dw_ip.Describe("filename.values") 
		llEnd = Len(ls_accept1) + 1
		SetNull(ls_return)
	 	DO
			llStart 		= LastPos(ls_accept1, sFind, llEnd)
			sToken 		= Mid(ls_accept1, (llStart + 1), (llEnd - llStart))
			llEnd2      = Len(sToken) + 1
			llStart2 	= LastPos(sToken, sFind2, llEnd2)
			ls_return	= Mid(Stoken, (llStart2 + 1) , (llEnd2 - llStart2))
			if	ls_return <>'' and not isNull(ls_return) then
				//-- 파일이름 가져오기 -
				ls_filename = ls_return +  '-' + ls_indate + ".TXT"
				//-- 해당 파일이름 구분값 조회 -
				llEnd3      = Len(ls_return) + 1
				llStart3 	= LastPos(ls_return, sFind3, llEnd3)
				ls_datagub	= Mid(ls_return, (llStart3 + 1) , (llEnd3 - llStart3))
				ll_cnt = wf_van_GM16(ls_filename,gs_sabu, ls_datagub)
				If ll_cnt > 0 Then
					wf_error(ls_gubun,ll_cnt,ls_filename,ls_gubun,'','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.', '')
				End if
			End if
			llEnd = llStart - 1
		LOOP WHILE llStart > 1
		// GM17 ===========================================================================
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "GM17"
		ls_modstring = is_filepath + 'c621P/' 
		dw_ip.object.filename.values = ls_modstring 
		ls_accept1 = dw_ip.Describe("filename.values") 
		llEnd = Len(ls_accept1) + 1
		SetNull(ls_return)
	 	DO
			llStart 		= LastPos(ls_accept1, sFind, llEnd)
			sToken 		= Mid(ls_accept1, (llStart + 1), (llEnd - llStart))
			llEnd2      = Len(sToken) + 1
			llStart2 	= LastPos(sToken, sFind2, llEnd2)
			ls_return	= Mid(Stoken, (llStart2 + 1) , (llEnd2 - llStart2))
			if	ls_return <>'' and not isNull(ls_return) then
				//-- 파일이름 가져오기 -
				ls_filename = ls_return +  '-' + ls_indate + ".TXT"
				//-- 해당 파일이름 구분값 조회 -
				llEnd3      = Len(ls_return) + 1
				llStart3 	= LastPos(ls_return, sFind3, llEnd3)
				ls_datagub	= Mid(ls_return, (llStart3 + 1) , (llEnd3 - llStart3))
				ll_cnt = wf_van_GM17(ls_filename,gs_sabu, ls_datagub)
				If ll_cnt > 0 Then
					wf_error(ls_gubun,ll_cnt,ls_filename,ls_gubun,'','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.', '')
				End if
			End if
			llEnd = llStart - 1
		LOOP WHILE llStart > 1
		// GM19 ===========================================================================
		il_succeed = 0
		ll_cnt=0
		ls_gubun = "GM19"
		ls_modstring = is_filepath + 'd010B/' + is_filepath + 'd010K/' + is_filepath + 'd050D/' &
		             + is_filepath + 'd010C/' + is_filepath + 'd611P/'
		dw_ip.object.filename.values = ls_modstring 
		ls_accept1 = dw_ip.Describe("filename.values") 
		llEnd = Len(ls_accept1) + 1
		SetNull(ls_return)
		DO
			llStart 		= LastPos(ls_accept1, sFind, llEnd)
			sToken 		= Mid(ls_accept1, (llStart + 1), (llEnd - llStart))
			llEnd2      = Len(sToken) + 1
			llStart2 	= LastPos(sToken, sFind2, llEnd2)
			ls_return	= Mid(Stoken, (llStart2 + 1) , (llEnd2 - llStart2))
			if	ls_return <>'' and not isNull(ls_return) then
				//-- 파일이름 가져오기 -
				ls_filename = ls_return +  '-' + ls_indate + ".TXT"
				//-- 해당 파일이름 구분값 조회 -
				llEnd3      = Len(ls_return) + 1
				llStart3 	= LastPos(ls_return, sFind3, llEnd3)
				ls_datagub	= Mid(ls_return, (llStart3 + 1) , (llEnd3 - llStart3))
				ll_cnt = wf_van_GM19(ls_filename,gs_sabu, ls_datagub)
				If ll_cnt > 0 Then
					wf_error(ls_gubun,ll_cnt,ls_filename,ls_gubun,'','총건수 :'+String(ll_cnt) + '(에러 : '+String(ll_cnt - il_succeed)+',성공 :'+String(il_succeed) + ') 데이타 처리를 하였습니다.', '')
				End if
			End if
			llEnd = llStart - 1
		LOOP WHILE llStart > 1		
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

type p_delrow from uo_picture within w_sm11_0010
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 4096
integer y = 24
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
//ls_cvcod = Trim(dw_ip.Object.mcvcod[1])

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
		Case 'GM16'
			ldw_x = dw_GM16
		Case 'GM19'
			ldw_x = dw_GM19
		Case 'GM14'
			ldw_x = dw_GM14
		Case 'GM17'
			ldw_x = dw_GM17
		
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
		
		If ls_gubun = 'GM19' or ls_gubun = 'D8' or ls_gubun = 'GI' Then
			ls_citnbr =  Trim(ldw_x.Object.citnbr[i])
			
			If ls_citnbr = '1' or ls_citnbr = '2' Then 
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

type p_delrow_all from uo_picture within w_sm11_0010
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 3922
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\전체삭제_up.gif"
end type

event clicked;call super::clicked;Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust
DataWindow ldw_x

if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1

ls_gubun = Trim(dw_ip.Object.gubun[1]) 
ls_saupj = Trim(dw_ip.Object.saupj[1])
//ls_cvcod = Trim(dw_ip.Object.mcvcod[1])

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
		Case 'GM14'
			ldw_x = dw_GM14
		Case 'GM16'
			ldw_x = dw_GM16
		Case 'GM17'
			ldw_x = dw_GM17
		Case 'GM19'
			ldw_x = dw_GM19
		
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
	
	If ls_gubun = 'GM16' or ls_gubun = 'GM17' Then
		ls_citnbr =  Trim(ldw_x.Object.citnbr[i])
		
		If ls_citnbr = '1' or ls_citnbr = '2' Then 
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

type pb_1 from u_pb_cal within w_sm11_0010
integer x = 1705
integer y = 64
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

type dw_gm16 from datawindow within w_sm11_0010
boolean visible = false
integer x = 869
integer y = 1328
integer width = 686
integer height = 400
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "GM16"
string dataobject = "d_sm11_0010_GM16"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;//f_multi_select(this)
end event

type dw_gm19 from datawindow within w_sm11_0010
boolean visible = false
integer x = 2473
integer y = 1332
integer width = 686
integer height = 400
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "GM19"
string dataobject = "d_sm11_0010_gm19"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;//f_multi_select(this)
end event

type dw_gm14 from datawindow within w_sm11_0010
boolean visible = false
integer x = 101
integer y = 1364
integer width = 686
integer height = 400
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "GM14"
string dataobject = "d_sm11_0010_GM14"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;//f_multi_select(this)
end event

event doubleclicked;//String ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itnbr
//			
////DataWindow 크기 재정의			
//dw_d2_detail.x = 443
//dw_d2_detail.y = 1196
//dw_d2_detail.Width = 3621
//dw_d2_detail.Height = 1144
//
////DoubleClick한 Row의 PK 값을 받아온다
//ls_sabu    = This.GetItemString(This.GetRow(), "van_hkcd2_sabu")
//ls_doccode = This.GetItemString(This.GetRow(), "van_hkcd2_doccode")
//ls_custcd  = This.GetItemString(This.GetRow(), "van_hkcd2_custcd")
//ls_factory = This.GetItemString(This.GetRow(), "van_hkcd2_factory")
//ls_itnbr   = This.GetItemString(This.GetRow(), "van_hkcd2_itnbr")
//
//dw_d2_detail.Visible = True
//
//dw_d2_detail.Retrieve(ls_sabu, ls_doccode, ls_custcd, ls_factory, ls_itnbr)
end event

type dw_gm17 from datawindow within w_sm11_0010
boolean visible = false
integer x = 1678
integer y = 1324
integer width = 686
integer height = 400
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "GM17"
string dataobject = "d_sm11_0010_GM17"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;//f_multi_select(this)
end event

type st_state from statictext within w_sm11_0010
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

type tab_1 from tab within w_sm11_0010
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

dw_ip.SetRedraw(false)
IF newindex = 1 Then
	
	dw_ip.DataObject = "d_sm11_0010_1"
	
	dw_GM14.visible = False
	dw_GM16.visible = False
	dw_GM17.visible = False
	dw_GM19.visible = False
	
	dw_list.visible = True
	p_excel.visible = True
	p_search.visible = True
	pb_2.X = 2980
	
Else

	dw_ip.DataObject = "d_sm11_0010_2"
	p_excel.visible = False
	p_search.visible = False
	pb_2.X = 2249

	Choose Case ls_gubun
		Case 'GM16'
				dw_GM16.x = dw_list.x
				dw_GM16.y = dw_list.y
				dw_GM16.width  = dw_list.width
				dw_GM16.height = dw_list.height
				
				dw_list.visible = False
				
				dw_GM16.visible = True
				dw_GM19.visible = False
				dw_GM14.visible = False
				dw_GM17.visible = False
			
		Case 'GM19'
			
				dw_GM19.x = dw_list.x
				dw_GM19.y = dw_list.y
				dw_GM19.width  = dw_list.width
				dw_GM19.height = dw_list.height
				
				dw_list.visible = False
				
				dw_GM16.visible = False
				dw_GM19.visible = True
				dw_GM14.visible = False
				dw_GM17.visible = False
			
		Case 'GM14'
			
				dw_GM14.x = dw_list.x
				dw_GM14.y = dw_list.y
				dw_GM14.width  = dw_list.width
				dw_GM14.height = dw_list.height
				dw_list.visible = False
				
				dw_GM16.visible = False
				dw_GM19.visible = False
				dw_GM14.visible = True
				dw_GM17.visible = False
		
		Case 'GM17'
			
				dw_GM17.x = dw_list.x
				dw_GM17.y = dw_list.y
				dw_GM17.width  = dw_list.width
				dw_GM17.height = dw_list.height
				dw_list.visible = False
				
				dw_GM16.visible = False
				dw_GM19.visible = False
				dw_GM14.visible = False
				dw_GM17.visible = True
		
	End Choose
End If

dw_ip.SetTransObject(SQLCA)
dw_ip.InsertRow(0)

dw_ip.SetRedraw(true)
/* User별 사업장 Setting Start */
String saupj
 
//If f_check_saupj(saupj) = 1 Then
//	dw_ip.Modify("saupj.protect=1")
//End If
//dw_ip.SetItem(1, 'saupj', saupj)
f_mod_saupj(dw_ip, 'saupj')

dw_ip.Object.jisi_date[1] = ls_jisi_date
dw_ip.Object.jisi_date2[1] = ls_jisi_date2

string ls_modstring 


IF newindex = 1 Then
	
	If ls_gubun = '' Or isNull(ls_gubun) Then
		ls_gubun ='AL'
	End If
   
	dw_ip.Object.gubun[1] = ls_gubun

	ls_modstring = is_filepath 
	dw_ip.object.filename.values = ls_modstring 
	dw_ip.setitem(1, 'filename', is_filepath)

Else
	If ls_gubun = 'AL' Then 
		dw_ip.Object.gubun[1] = 'GM14'
		wf_choose('GM14')
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

type pb_2 from u_pb_cal within w_sm11_0010
integer x = 2249
integer y = 64
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

type p_excel from uo_picture within w_sm11_0010
integer x = 4443
integer y = 260
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
end type

event clicked;call super::clicked;//If dw_list.RowCount() < 1 Then Return
If Tab_1.SelectedTab <> 1 Then Return
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", ls_path, ls_file, "XLS", "Excel Files (*.xls),*.xls")
dw_list.SaveAs(ls_path, Excel!, FALSE)
end event

type dw_gm16_detail from datawindow within w_sm11_0010
boolean visible = false
integer x = 667
integer y = 676
integer width = 2473
integer height = 536
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "소요량 상세"
string dataobject = "d_sm10_p0030_D2_detail"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;This.Visible = False
end event

type cbx_tab from checkbox within w_sm11_0010
integer x = 2656
integer y = 280
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "탭으로 분리"
end type

