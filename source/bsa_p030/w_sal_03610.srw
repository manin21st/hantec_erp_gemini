$PBExportHeader$w_sal_03610.srw
$PBExportComments$생산완료 통보서(영업)
forward
global type w_sal_03610 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_03610
end type
type pb_2 from u_pb_cal within w_sal_03610
end type
type rr_1 from roundrectangle within w_sal_03610
end type
end forward

global type w_sal_03610 from w_standard_print
string title = "생산완료 통보서"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_03610 w_sal_03610

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sDatef, sDateT, sDepot, sPdtGu, tx_name, sPrtGb,ssaupj
string old_select, new_select, where_clause, group_clause
Long   dCol

If dw_ip.accepttext() <>  1 Then Return -1

sDatef = Trim(dw_ip.getitemstring(1,"sdatef"))
sDatet = Trim(dw_ip.getitemstring(1,"sdatet"))
sDepot = Trim(dw_ip.getitemstring(1,"depot"))
sPdtGu = Trim(dw_ip.getitemstring(1,"pdtgu"))
sPrtGb = Trim(dw_ip.getitemstring(1,"prtgb"))
ssaupj = dw_ip.getitemstring(1,"saupj")

////필수입력항목 체크///////////////////////////////////////////////
if isnull(sDepot) or sDepot = "" then
	f_message_chk(30,'[입고창고]')
	dw_ip.setcolumn("depot")
	dw_ip.setfocus()
	return -1
end if

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

if isnull(sPdtGu) or sPdtGu = "" then    sPdtGu = ''

old_select = dw_list.GetSQLSelect()

dCol = Pos(old_select,'group')
If dCol > 0 Then
	new_select = Mid(old_select,1,dCol -1 )
	group_clause = Mid(old_select,dCol)
Else
	new_select = old_select
End If

/* 조회하기 위한 sql where 추가 */
where_clause  = " and "
where_clause += "a.sabu  = '" + gs_sabu + "' and "
where_clause += "a.saupj like '" + ssaupj  + "' and "
where_clause += "a.insdat >= '" + sdatef + "' and a.insdat <= '" + sdatet + "' and "
where_clause += "a.depot_no = '" + sDepot + "' "

/* 승인여부 조건 추가 */
Choose Case sPrtGb
	Case '1'
    where_clause += "and a.io_date is not null "		
	Case '2'
    where_clause += "and a.io_date is null "
End Choose

dw_list.SetSqlSelect(new_select + where_clause + ' ' + group_clause)
dw_print.SetSqlSelect(new_select + where_clause + ' ' + group_clause)

//MessageBox('',new_select + where_clause + ' ' + group_clause)
//Return -1

dw_list.SetRedraw(False)

/* 생산팀별 Filtering */
If sPdtGu <> '' Then 
	dw_list.SetFilter("itnct_pdtgu = '" + sPdtGu + "'")
	dw_list.Filter()
	dw_list.GroupCalc()
	
	dw_print.SetFilter("itnct_pdtgu = '" + sPdtGu + "'")
	dw_print.Filter()
	dw_print.GroupCalc()
Else
	dw_list.SetFilter("")
  	dw_list.Filter()
	
	dw_print.SetFilter("")
  	dw_print.Filter()
End If

IF dw_list.retrieve() <= 0 THEN
  	f_message_chk(50,'[생산완료통보서]')
	dw_ip.setfocus()
	dw_list.SetSqlSelect(old_select)
	dw_list.SetRedraw(True)
	Return -1
End If

dw_print.retrieve()

dw_list.Modify("tx_sdatef.text = '"+ string(sdatef,'@@@@.@@.@@')+"'")
dw_list.Modify("tx_sdatet.text = '"+ string(sdatet,'@@@@.@@.@@')+"'")

dw_print.Modify("tx_sdatef.text = '"+ string(sdatef,'@@@@.@@.@@')+"'")
dw_print.Modify("tx_sdatet.text = '"+ string(sdatet,'@@@@.@@.@@')+"'")


tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_pdtgu.text = '"+tx_name+"'")
dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(depot) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_depot.text = '"+tx_name+"'")
dw_print.Modify("tx_depot.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

dw_list.SetSqlSelect(old_select)
dw_print.SetSqlSelect(old_select)

dw_list.SetRedraw(True)

Return 1
end function

on w_sal_03610.create
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

on w_sal_03610.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;string sDate

sDate = f_today()
dw_ip.setitem(1,"sdatef",Left(sDate,6)+'01')
dw_ip.SetItem(1, "sdatet", sDate)
dw_ip.setfocus()

/* 부가 사업장 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//생산팀
rtncode 	= dw_ip.GetChild('pdtgu', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('03',gs_saupj)

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
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

type p_preview from w_standard_print`p_preview within w_sal_03610
end type

type p_exit from w_standard_print`p_exit within w_sal_03610
end type

type p_print from w_standard_print`p_print within w_sal_03610
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_03610
end type







type st_10 from w_standard_print`st_10 within w_sal_03610
end type



type dw_print from w_standard_print`dw_print within w_sal_03610
string dataobject = "d_sal_03610_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_03610
integer x = 37
integer y = 28
integer width = 3383
integer height = 192
string dataobject = "d_sal_03610_1"
end type

event dw_ip::itemchanged;call super::itemchanged;String sNull, sDate

SetNull(snull)

Choose Case GetColumnName() 
/* 일자 */
  Case 'sdatef', 'sdatet'
		sDate = Trim(GetText())
		If f_datechk(sDate) <> 1 Then
			f_message_chk(35,'')
			Return 1
		End If
  case 'saupj ' 
		STRING ls_return, ls_sarea , ls_steam,  ls_pdtgu, ls_saupj, ls_emp_id
		Long	 rtncode 
		Datawindowchild state_child 
		//사업장
		ls_saupj = gettext() 
		
		//생산팀
		rtncode 	= dw_ip.GetChild('pdtgu', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('03',ls_saupj)
		ls_pdtgu = dw_ip.object.pdtgu[1] 
		ls_return = f_saupj_chk_t('4' , ls_pdtgu ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'pdtgu', '')
		End if 

END Choose

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;String sittyp

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

if this.GetColumnName() = 'itcls' Or this.GetColumnName() = 'itclsnm' then
	sIttyp = Trim(GetItemString(GetRow(),'ittyp'))
	If sIttyp = '' Or IsNull(sIttyp) Then sIttyp = '1'
	
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
	this.SetFocus()
end if

If this.GetColumnName() = 'itnbr' then
	Gs_gubun = Trim(GetItemString(GetRow(),'ittyp'))
	If Gs_gubun = '' Or IsNull(Gs_gubun) Then Gs_gubun = '1'
	open(w_itemas_popup)
   
	if gs_code = "" or isnull(gs_code) then return 
		
	this.setitem(1, 'itnbr', gs_code)
   TriggerEvent(ItemChanged!)
End If

end event

type dw_list from w_standard_print`dw_list within w_sal_03610
integer x = 59
integer y = 256
integer width = 4498
integer height = 2036
string dataobject = "d_sal_03610"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_sal_03610
integer x = 731
integer y = 40
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_03610
integer x = 1207
integer y = 40
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_sal_03610
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 244
integer width = 4530
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

