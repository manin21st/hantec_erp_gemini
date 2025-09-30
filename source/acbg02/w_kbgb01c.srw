$PBExportHeader$w_kbgb01c.srw
$PBExportComments$예산 특인 신청서
forward
global type w_kbgb01c from w_standard_print
end type
type rr_1 from roundrectangle within w_kbgb01c
end type
end forward

global type w_kbgb01c from w_standard_print
integer x = 0
integer y = 0
integer height = 2500
string title = "예산 특인 신청서"
boolean maxbox = true
rr_1 rr_1
end type
global w_kbgb01c w_kbgb01c

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupj, ls_acc_yy, ls_ye_gu, ls_dept_cd, ls_acc1f, ls_acc1t, ls_comments, get_code, get_name, snull, sqlfd1, sqlfd2, sempno
Int ls_count
long lno, lno2


ls_count = 1

if dw_ip.acceptText() = -1 then return -1
if dw_ip.GetRow() < 1 then return -1

ls_saupj   = dw_ip.Getitemstring(dw_ip.Getrow(),"saupj")
ls_acc_yy  = dw_ip.Getitemstring(dw_ip.Getrow(),"ag_yymmdd")
ls_dept_cd = dw_ip.Getitemstring(dw_ip.Getrow(),"ag_dept")
ls_comments = dw_ip.Getitemstring(dw_ip.Getrow(),"ag_comments")
lno = dw_ip.GetitemNumber(dw_ip.Getrow(),"ag_no")
lno2 = dw_ip.GetitemNumber(dw_ip.Getrow(),"ag_no2")

//DECLARE Cur_ValidDept CURSOR FOR  
//	SELECT Substr("SYSCNFG"."DATANAME",1,6)
//   	FROM "SYSCNFG"  
//   	WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 10 ) AND  
//         ( "SYSCNFG"."LINENO" <> '00' )   
//	ORDER BY "SYSCNFG"."LINENO" ASC  ;
//
//OPEN Cur_ValidDept;
//
//DO WHILE True
//	Fetch Cur_ValidDept INTO :sEMPNO;
//	IF SQLCA.SQLCODE <> 0 THEN 
//		MessageBox("확 인", "데이타 조회 권한이 없습니다!!")		
//		return -1		
//	END IF
//
//	IF sempno = gs_empno THEN
//	   EXIT
//	END IF 	
//Loop
//CLOSE Cur_ValidDept;


//
//
//	SELECT SUBSTR("SYSCNFG"."DATANAME",1,6)    INTO :sEMPNO	 				/*관리자 여부*/
//		FROM "SYSCNFG"  
//	   WHERE ( "SYSCNFG"."SYSGU" = 'A' ) AND ( "SYSCNFG"."SERIAL" = 10 ) AND  
//	         ( "SYSCNFG"."LINENO"  '1' )   ;
//	IF SQLCA.SQLCODE <> 0 THEN 
//		sEMPNO = ''
//	ELSE
//		IF IsNull(sEMPNO) OR sEMPNO = "" THEN sEMPNO = ''
//	END IF
//
//	if ls_dept_cd <> gs_dept then
//		if sempno <> gs_empno then
//				MessageBox("확 인", "데이타 조회 권한이 없습니다!!")		
//				return -1
//		end if
//	end if 	

IF trim(ls_saupj) = '' or isnull(ls_saupj) THEN
	F_MessageChk(1, "[사업장]")
	dw_ip.SetColumn('saupj')
	dw_ip.SetFocus()
   return -1 
END IF

if trim(ls_acc_yy) = '' or isnull(ls_acc_yy) then 
	F_MessageChk(1, "[예산년도]")
	dw_ip.SetColumn('ag_yymmdd')
	dw_ip.SetFocus()	
	return -1
end if

//if ls_ye_gu = ""  or IsNull(ls_ye_gu) then
//   ls_ye_gu = "%"
//ELSE
//	SELECT "REFFPF"."RFNA1"  
//   	INTO  :s_yesanname
//   	FROM "REFFPF"  
//   	WHERE "REFFPF"."RFGUB" = :ls_ye_gu and
//         	"REFFPF"."RFCOD" = 'AB'      and  
//				"REFFPF"."RFCOD" <> '00' using sqlca ;
//		if sqlca.sqlcode <> 0 then 
//   		MessageBox("확 인", "예산구분 코드를 확인하십시오!!")		
//			dw_ip.SetColumn('ye_gu')
//			dw_ip.SetFocus()			
//			return -1
//		end if 
//end if

// 예산부서
if isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then
	ls_dept_cd = "%"
else
	SELECT "KFE03OM0"."DEPTCODE",
	       "KFE03OM0"."DEPTNAME"
		INTO :get_code, :get_name
		FROM "KFE03OM0"  
	  WHERE "KFE03OM0"."DEPTCODE" = :ls_dept_cd   ;
	if sqlca.sqlcode <> 0 then 	
		F_MessageChk(41, "[배정부서]")									
		dw_ip.SetItem(dw_ip.GetRow(), 'dept_cd', snull)
		dw_ip.SetColumn('dept_cd')
		dw_ip.SetFocus()
		return -1
	end if 
end if


dw_list.SetRedraw(false)

IF dw_list.Retrieve(ls_saupj, ls_acc_yy,ls_dept_cd,ls_comments,lno,lno2) < 1 THEN
	MessageBox("확 인","조회한 자료가 없습니다.!!")
	dw_list.reset()
	dw_list.insertrow(0)
	dw_ip.SetColumn('saupj')	
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)	
	Return -1
END IF

dw_list.SetRedraw(true)	
 
Return 1

end function

on w_kbgb01c.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kbgb01c.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
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
//dw_print.settransobject(sqlca)

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
dw_list.object.datawindow.print.preview = "yes"	

//dw_print.ShareData(dw_list)

//PostEvent('ue_open')




















dw_ip.SetItem(1, 'saupj', gs_saupj)
dw_ip.SetItem(1, 'ag_yymmdd', f_today())
dw_ip.SetItem(1, 'ag_dept', gs_dept)
dw_ip.SetItem(1, 'ag_no', 1)
dw_ip.SetItem(1, 'ag_no2', 99999)

dw_ip.SetColumn("ag_comments")

dw_ip.setfocus()
end event

type p_xls from w_standard_print`p_xls within w_kbgb01c
end type

type p_sort from w_standard_print`p_sort within w_kbgb01c
end type

type p_preview from w_standard_print`p_preview within w_kbgb01c
boolean visible = false
integer x = 4352
integer y = 232
string pointer = ""
end type

type p_exit from w_standard_print`p_exit within w_kbgb01c
integer taborder = 40
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_kbgb01c
integer taborder = 30
string pointer = ""
end type

event p_print::clicked;//Override

IF dw_list.rowcount() > 0 then
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF

OpenWithParm(w_print_options, dw_list)
end event

type p_retrieve from w_standard_print`p_retrieve within w_kbgb01c
integer x = 4096
string pointer = ""
end type







type st_10 from w_standard_print`st_10 within w_kbgb01c
end type



type dw_print from w_standard_print`dw_print within w_kbgb01c
integer x = 18469
integer y = 9800
integer width = 1211
integer height = 544
boolean dragauto = true
boolean titlebar = true
string dataobject = "dw_kbgb01_7"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_ip from w_standard_print`dw_ip within w_kbgb01c
integer x = 37
integer y = 12
integer width = 3909
integer height = 300
string dataobject = "dw_kbgb01_7_cdt"
end type

event dw_ip::itemchanged;string ls_saupj, sqlfd, snull, ls_acc_yy, ls_acc1_cd1, &
       ls_ye_gu, get_ye_gu, s_sql, ls_acc1_cd2, get_code, get_name, &
		 ls_dept_cd

SetNull(snull)

if this.GetColumnName() = 'saupj' then 
	
   ls_saupj    = this.GetText()
	
	if trim(ls_saupj) = '' or isnull(ls_saupj) then 
      F_MessageChk(1, "[사업장]")		
		return 1
	end if
	
//	SELECT "REFFPF"."RFGUB"  
//   INTO :sqlfd
//   FROM "REFFPF"
//   WHERE "REFFPF"."RFCOD" = 'AD' and
//         "REFFPF"."RFGUB" = :ls_saupj and 
//			"REFFPF"."RFGUB" <> '00'	;
//   if sqlca.sqlcode <> 0 then
//      Messagebox("확 인","사업장코드를 확인하십시오")
//      this.SetItem(row, "saupj", snull)
//      return 1
//   end if
	
end if

if this.GetColumnName() = 'ag_yymmdd' then
	
	ls_acc_yy = this.GetText()
	
	if isnull(ls_acc_yy) or trim(ls_acc_yy) = '' then
      F_MessageChk(1, "[회계년도]")				
   	return 1
	end if
	
end if

	
//if this.GetcolumnName() = 'ye_gu' then 
//	ls_ye_gu = this.GetText()
//	if isnull(ls_ye_gu) or trim(ls_ye_gu) = '' then 
//		return
//	end if
//    SELECT "REFFPF"."RFGUB"
//    INTO :get_ye_gu
//    FROM "REFFPF" 
//	 WHERE "REFFPF"."SABU" = :gs_saupj AND     
//         "REFFPF"."RFCOD" = 'AB'   AND   
//         "REFFPF"."RFGUB" = :ls_ye_gu AND   
//			"REFFPF"."RFGUB" <> '00';  
//	if sqlca.sqlcode = 0 and isnull(get_ye_gu) = false then 
//	   return 
//	else 
//		MessageBox("확 인", "예산구분 코드를 확인하십시오!!")		
//		this.SetItem(1, 'ye_gu', snull)
//		return 1
//	end if
//end if 	

// 특인부서
if this.GetColumnName() = 'ag_dept' then
	
	ls_dept_cd = this.GetText()
	
	if isnull(ls_dept_cd) or trim(ls_dept_cd) = "" then
		return 
		
	else
		SELECT DISTINCT "KFE01OM0"."DEPT_CD"  	INTO :get_code
			FROM "KFE01OM0"  
			WHERE "KFE01OM0"."DEPT_CD" = :ls_dept_cd   ;

		if sqlca.sqlcode = 0 then 	
			this.SetItem(dw_ip.GetRow(), 'ag_dept', get_code)
		else
         F_MessageChk(20,'[예산부서]')						
			this.SetItem(dw_ip.GetRow(), 'ag_dept', snull)
			return 1
		end if 

	end if
end if


end event

event dw_ip::ue_pressenter;if this.GetColumnName() <> 'arg_comments' then 
//   Send(Handle(this),256,9,0)
//   Return 1
end if
end event

event dw_ip::rbuttondown;SetNull(gs_code)

IF this.GetColumnName() = "ag_no"  THEN 
   open(w_kbgb01a)
   if Not Isnull(gs_code) then
     dw_ip.Setitem(dw_ip.Getrow(),"ag_saupj",   Left(gs_code,2))          /* 사업장      */
     dw_ip.Setitem(dw_ip.Getrow(),"ag_yymmdd", Mid(gs_code,3,8))         /* 조정 처리일 */
     dw_ip.Setitem(dw_ip.Getrow(),"ag_no",  long(Mid(gs_code,11,6)))  /* 조정번호    */ 
   end if
end if

IF this.GetColumnName() = "ag_no2"  THEN 
   open(w_kbgb01a)
   if Not Isnull(gs_code) then
     dw_ip.Setitem(dw_ip.Getrow(),"ag_saupj",   Left(gs_code,2))          /* 사업장      */
     dw_ip.Setitem(dw_ip.Getrow(),"ag_yymmdd", Mid(gs_code,3,8))         /* 조정 처리일 */
     dw_ip.Setitem(dw_ip.Getrow(),"ag_no2",  long(Mid(gs_code,11,6)))  /* 조정번호    */ 
   end if
end if
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kbgb01c
integer x = 379
integer y = 324
integer width = 3630
integer height = 1980
string title = "추가 예산 편성 신청서"
string dataobject = "dw_kbgb01_7"
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type rr_1 from roundrectangle within w_kbgb01c
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 316
integer width = 4539
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

