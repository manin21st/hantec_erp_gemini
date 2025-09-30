$PBExportHeader$w_sal_06530.srw
$PBExportComments$ ===> Order 접수 현황
forward
global type w_sal_06530 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_06530
end type
type pb_2 from u_pb_cal within w_sal_06530
end type
type rr_1 from roundrectangle within w_sal_06530
end type
end forward

global type w_sal_06530 from w_standard_print
string title = "Order 접수 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_06530 w_sal_06530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom, sTo, sS, sS_Name ,ls_saupj ,tx_name, ls_emp_id

If dw_ip.AcceptText() <> 1 Then Return -1

ls_saupj  = Trim(dw_ip.getitemstring(1,'saupj'))
ls_emp_id = Trim(dw_ip.getitemstring(1,'emp_id'))
If ls_saupj  = '' Or IsNull(ls_saupj)  Then ls_saupj = '%'
If ls_emp_id = '' Or IsNull(ls_emp_id) Then ls_emp_id = '%'

sFrom = Trim(dw_ip.GetItemString(1,'d_from'))
if	(sFrom = '') or isNull(sFrom) then
	f_Message_Chk(35, '[시작일자]')
	dw_ip.setcolumn('d_from')
	dw_ip.setfocus()
	Return -1
end if

sTo = Trim(dw_ip.GetItemString(1,'d_to'))
if	(sTo = '') or isNull(sTo) then
	f_Message_Chk(35, '[종료일자]')
	dw_ip.setcolumn('d_to')
	dw_ip.setfocus()
	Return -1
end if

if	( sFrom > sTo ) then
	f_message_Chk(200, '[시작 및 종료일 CHECK]')
	dw_ip.setcolumn('d_to')
	dw_ip.setfocus()
	Return -1
END IF

// 관할구역 선택
sS = Trim(dw_ip.GetItemString(1,'sarea'))
if isNull(sS) or (sS = '') then
	sS = ''
	sS_Name = '전  체'
else
	Select sareanm Into :sS_Name 
	From sarea
	Where sarea = :sS;
	if isNull(sS_Name) then
		sS_Name = ''
	end if
end if
sS = sS + '%'

dw_print.object.r_gigan.Text = Left(sFrom,4)+'.'+Mid(sFrom,5,2)+'.'+Right(sFrom,2) + ' - ' + &
                               Left(sTo,4)+'.'+Mid(sTo,5,2)+'.'+Right(sTo,2)
dw_print.object.r_sarea.Text = sS_Name

if dw_print.Retrieve(gs_sabu, sFrom, sTo, sS ,ls_saupj, ls_emp_id) < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.setcolumn('sarea')
	dw_ip.setfocus()
	dw_list.insertrow(0)
	//return -1
end if
dw_print.sharedata(dw_list)
tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_empid.text = '"+tx_name+"'")


return 1
end function

on w_sal_06530.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_sal_06530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;/* User별 관할구역 Setting */
String sarea, steam, saupj

//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.Modify("sarea.protect=1")
//	dw_ip.Modify("sarea.background.color = 80859087")
//End If
//dw_ip.SetItem(1, "saupj", saupj)
//dw_ip.SetItem(1, "sarea", sarea)

/* 사업장 구분 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//관할 구역
f_child_saupj(dw_ip, 'sarea', gs_saupj) 

//영업담당자
rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 
dw_ip.setitem(1,'d_from',left(f_today(),6) + '01')
dw_ip.setitem(1,'d_to',left(f_today(),8))

sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
end event

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
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')
end event

type p_preview from w_standard_print`p_preview within w_sal_06530
end type

type p_exit from w_standard_print`p_exit within w_sal_06530
end type

type p_print from w_standard_print`p_print within w_sal_06530
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06530
end type







type st_10 from w_standard_print`st_10 within w_sal_06530
end type



type dw_print from w_standard_print`dw_print within w_sal_06530
string dataobject = "d_sal_06530_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06530
integer x = 14
integer y = 0
integer width = 2482
integer height = 240
string dataobject = "d_sal_06530_01"
end type

event dw_ip::itemchanged;String sCol_Name, sNull, svndcod, scvname, ls_saupj

dw_Ip.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
   // 시작일자 유효성 Check
	Case "d_from"  
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[시작일자]')
			this.SetItem(1, "d_from", sNull)
			return 1
		end if
		
	// 끝일자 유효성 Check
   Case "d_to"
		if f_DateChk(Trim(this.getText())) = -1 then
			this.SetItem(1, "d_to", sNull)
			f_Message_Chk(35, '[종료일자]')
			return 1
		end if
		if Long(this.GetItemString(1,'d_from')) > Long(this.GetText()) then
       	MessageBox("확 인","시작일과 종료일 CHECK!")
         this.SetItem(1, "d_to", sNull)
      	this.setcolumn('d_to')
       	this.setfocus()			
			return 1
		end if
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 
		//관할 구역
		f_child_saupj(dw_ip, 'sarea', ls_saupj)
		ls_sarea = dw_ip.object.sarea[1] 
		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'sarea', '')
		End if 
		
end Choose


end event

type dw_list from w_standard_print`dw_list within w_sal_06530
integer y = 264
integer width = 4576
integer height = 2064
string dataobject = "d_sal_06530"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_06530
integer x = 814
integer y = 40
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_from')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_from', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06530
integer x = 1312
integer y = 40
integer height = 80
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_to')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_to', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 248
integer width = 4608
integer height = 2092
integer cornerheight = 40
integer cornerwidth = 55
end type

