$PBExportHeader$w_sal_02530.srw
$PBExportComments$수주 진행 현황 - 거래처별
forward
global type w_sal_02530 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02530
end type
type pb_2 from u_pb_cal within w_sal_02530
end type
type rr_1 from roundrectangle within w_sal_02530
end type
type rr_2 from roundrectangle within w_sal_02530
end type
end forward

global type w_sal_02530 from w_standard_print
string title = "수주 진행 현황 - 거래처별"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_02530 w_sal_02530

type variables
String   sOriginalSql
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,sTeam,sArea,sCust,sTeamName,sAreaName,sIoGbn,sCustName
String sJepumIo, sSaleGu,ls_sugugb,ls_pangb,tx_name,ssaupj ,ls_emp_id, ls_gubun

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = Trim(dw_ip.GetItemString(1,"sdatef"))
sTo         = Trim(dw_ip.GetItemString(1,"sdatet"))
sTeam       = Trim(dw_ip.GetItemString(1,"deptcode"))
sArea       = Trim(dw_ip.GetItemString(1,"areacode"))
sCust       = Trim(dw_ip.GetItemString(1,"custcode"))
sIogbn      = Trim(dw_ip.GetItemString(1,"iogbn"))
ls_sugugb   = Trim(dw_ip.Getitemstring(1,"sugugb"))
ls_pangb    = Trim(dw_ip.getitemstring(1,"pangb"))
ssaupj      = dw_ip.getitemstring(1,"saupj")
ls_emp_id   = dw_ip.getitemstring(1,'emp_id')
ls_gubun    = dw_ip.GetItemString(1, 'sgubun')

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[수주기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[수주기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

IF sTeam = "" OR IsNull(sTeam) THEN sTeam = '%'
IF sArea = "" OR IsNull(sArea) THEN sArea = '%'
IF sCust = "" OR IsNull(sCust) THEN sCust = '%'
if ls_sugugb = "" or isnull(ls_sugugb) then ls_sugugb ='%'
if ls_pangb ="" or isnull(ls_pangb) then ls_pangb = '%'
if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id ='%'

If sIoGbn = 'N' then
/* 무상출고 : 매출여부('N') , 수주출고여부('Y') */
	sJepumIo = 'Y'
	sSaleGu  = 'N'
Else
/* 판매출고 : 매출여부('Y') */
	sJepumIo = '%'
	sSaleGu  = 'Y'
End If

//IF dw_list.Retrieve(gs_sabu,sFrom,sTo,sTeam,sArea,sCust,sJepumIo,sSaleGu,ls_sugugb,ls_pangb,ssaupj ,ls_emp_id) <=0 THEN
//	f_message_chk(50,'')
//   dw_ip.setcolumn('sdatef')
//	dw_ip.SetFocus()
//	Return -1
//End If
//
//

If ls_gubun = '2' Then
	IF dw_print.Retrieve(gs_sabu,sFrom,sTo,sTeam,sArea,sCust,sJepumIo,sSaleGu,ls_sugugb,ls_pangb,ssaupj ,ls_emp_id) <=0 THEN
		f_message_chk(50,'')
		dw_list.Reset()
		dw_ip.setcolumn('sdatef')
		dw_ip.SetFocus()
		Return -1
	End If
Else
	IF dw_print.Retrieve(gs_sabu, sFrom, sTo, sCust, sJepumIo, sSaleGu, ls_sugugb, ls_pangb, ssaupj, ls_emp_id) < 1 THEN
		f_message_chk(50,'')
		dw_list.Reset()
		dw_ip.setcolumn('sdatef')
		dw_ip.SetFocus()
		Return -1
	End If
End If

dw_print.ShareData(dw_list)

///*판매출고 */
//If sIogbn = 'Y' Then
//  IF sTeam ='%' THEN
//	 sTeamName = '전 체'
//  Else
//	 sTeamName = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
//  End If
//  
////  dw_list.Modify("txt_dept_t.text = '영업팀 :'")
////  dw_list.Modify("txt_dept.text = '"+sTeamName+"'")
//
//	dw_print.Modify("txt_dept_t.text = '영업팀 :'")
//	dw_print.Modify("txt_dept.text = '"+sTeamName+"'")
//	
//  IF sArea ='%' THEN
//	 sAreaName = '전 체'
//  Else
//	 sAreaName = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
//  End If
//
////  dw_list.Modify("txt_area_t.visible = 1")
////  dw_list.Modify("txt_area.visible = 1")
////  dw_list.Modify("txt_area.text = '"+sAreaName+"'")
//
//  dw_print.Modify("txt_area_t.visible = 1")
//  dw_print.Modify("txt_area.visible = 1")
//  dw_print.Modify("txt_area.text = '"+sAreaName+"'")
//
//  sCustName = Trim(dw_ip.GetItemString(1,'custname'))
//  If IsNull(sCustName) Or sCustName = '' Then   sCustName = '전체'
//  
////  dw_list.Modify("txt_cvcod_t.visible = 1")
////  dw_list.Modify("txt_cvcod.visible = 1")
////  dw_list.Modify("txt_cvcod.text = '"+sCustName+"'")
//  
//  dw_print.Modify("txt_cvcod_t.visible = 1")
//  dw_print.Modify("txt_cvcod.visible = 1")
//  dw_print.Modify("txt_cvcod.text = '"+sCustName+"'")
//  
///* 무상출고일 경우 부서명만 */
//Else
//  sCustName = Trim(dw_ip.GetItemString(1,'custname'))
//  If IsNull(sCustName) Or sCustName = '' Then   sCustName = '전체'
//
//  dw_print.Modify("txt_dept_t.text = '부  서 :'")
//  dw_print.Modify("txt_dept.text = '"+sCustName+"'")
//  
//  dw_print.Modify("txt_area_t.visible = 0")
//  dw_print.Modify("txt_area.visible = 0")
// 
//  dw_print.Modify("txt_cvcod_t.visible = 0")
//  dw_print.Modify("txt_cvcod.visible = 0")
//  
////  dw_list.Modify("txt_dept_t.text = '부  서 :'")
////  dw_list.Modify("txt_dept.text = '"+sCustName+"'")
////  
////  dw_list.Modify("txt_area_t.visible = 0")
////  dw_list.Modify("txt_area.visible = 0")
//// 
////  dw_list.Modify("txt_cvcod_t.visible = 0")
////  dw_list.Modify("txt_cvcod.visible = 0")
//End If
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sugugb) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
////dw_list.Modify("tx_sugugb.text = '"+tx_name+"'")
//dw_print.Modify("tx_sugugb.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pangb) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
////dw_list.Modify("tx_pangb.text = '"+tx_name+"'")
//dw_print.Modify("tx_pangb.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
////dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
//dw_print.Modify("tx_saupj.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
////dw_list.Modify("tx_emp_id.text = '"+tx_name+"'")
//dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")

Return 1

end function

on w_sal_02530.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_sal_02530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;
sOriginalSql = dw_list.Describe("DataWindow.Table.Select")

/* 사업장 구분 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//영업팀
f_child_saupj(dw_ip, 'deptcode', '%') 

//관할 구역
f_child_saupj(dw_ip, 'areacode', '%') 

//영업담당자
rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 

dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)
dw_ip.SetColumn("deptcode")
dw_ip.Setfocus()

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

type p_xls from w_standard_print`p_xls within w_sal_02530
boolean visible = true
integer x = 4270
integer y = 24
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_sal_02530
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_sal_02530
end type

type p_exit from w_standard_print`p_exit within w_sal_02530
end type

type p_print from w_standard_print`p_print within w_sal_02530
boolean visible = false
integer x = 3058
integer y = 36
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02530
end type

event p_retrieve::clicked;//
if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event











type dw_print from w_standard_print`dw_print within w_sal_02530
integer x = 3598
integer y = 28
integer width = 183
string dataobject = "d_sal_025302-1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02530
integer y = 196
integer width = 4544
integer height = 188
string dataobject = "d_sal_025301-1"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemfocuschanged;IF this.GetColumnName() = "custname" OR this.GetColumnName() ='deptname'THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,sDeptname,sDateFrom,sDateTo,sPrtGbn,snull
String  sIogbn, sGubun , sCvcod, scvnas, sarea, steam, sSaupj, sName1, ls_saupj, scode, ls_sarea, ls_return , ls_steam, ls_emp_id
Long 	  rtncode 
Datawindowchild state_child 

SetNull(snull)

/* 출고구분 */
sIogbn = Trim(GetItemString(1,'iogbn'))

Choose Case GetColumnName() 
 Case "sdatef"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[수주일자]')
		this.SetItem(1,"sdatef",snull)
		Return 1
	END IF
 Case "sdatet"
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[수주일자]')
		this.SetItem(1,"sdatet",snull)
		Return 1
	END IF
/* 출고구분 */
 Case 'iogbn'
	sIogbn = Trim(GetText())
	
	If sIogbn = 'N' Then /* 무상출고 */
		this.SetItem(1,'deptcode',sNull)
		this.SetItem(1,'areacode',sNull)
		this.Modify('deptcode.protect = 1')
		this.Modify('areacode.protect = 1')
		this.Modify("custcode_t.text = '부서'")
		
	Else
		this.Modify('deptcode.protect = 0')
		this.Modify('areacode.protect = 0')
		
		this.Modify("custcode_t.text = '거래처'")
	End If
	
	this.SetItem(1,'custcode',sNull)
	this.SetItem(1,'custname',sNull)
/* 영업팀 */
 Case "deptcode"
   SetItem(1,'areacode',sNull)
	SetItem(1,"custcode",sNull)
	SetItem(1,"custname",sNull)
/* 관할구역 */
 Case "areacode"
	SetItem(1,"custcode",sNull)
	SetItem(1,"custname",sNull)
	
	sIoCustArea = this.GetText()
	IF sIoCustArea = "" OR IsNull(sIoCustArea) THEN RETURN
	
	SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sIoCustArea  ,:sDept
	  FROM "SAREA"  
	 WHERE "SAREA"."SAREA" = :sIoCustArea   ;
		
   SetItem(1,'deptcode',sDept)

	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,'custcode', sCvcod)
			SetItem(1,"custname", scvnas)

			Return 1
		END IF
		
	/* 거래처 */
	Case "custcode"
		sCode = this.GetText()
		If 	f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE
			SetItem(1,"custcode",  		sCode)
			SetItem(1,"custname",		scvnas)
		END IF

	case 'saupj' 
		
		//거래처
		ls_saupj = gettext() 
		sCode 	= this.object.custcode[1] 
		f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
		End if 
//		//관할 구역
//		f_child_saupj(dw_ip, 'areacode', ls_saupj)
//		ls_sarea = dw_ip.object.areacode[1] 
//		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'areacode', '')
//		End if 
//		//영업팀
//		f_child_saupj(dw_ip, 'deptcode', ls_saupj) 
//		ls_steam = dw_ip.object.deptcode[1] 
//		ls_return = f_saupj_chk_t('2' , ls_steam ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'deptcode', '')
//		End if 
		
		//영업담당자
		rtncode 	= dw_ip.GetChild('emp_id', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('47',ls_saupj)
		ls_emp_id = dw_ip.object.emp_id[1] 
		ls_return = f_saupj_chk_t('3' , ls_emp_id ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'emp_id', '')
		End if 

	/* 자료구분 */
	Case 'prtgbn'
		sPrtGbn = GetText()

		sGubun = GetItemString(1, 'sgubun')
		dw_list.SetRedraw(False)
		/* 수주일자 기준 */
		If sGubun = '1' Then
			IF sPrtGbn = '1' THEN													/*생산미처리*/
				dw_list.DataObject = 'd_sal_025303'
				dw_print.DataObject = 'd_sal_025303_p'
			ELSEIF sPrtGbn = '2' THEN												/*수주미처리*/
				dw_list.DataObject = 'd_sal_025304'
				dw_print.DataObject = 'd_sal_025304_p'
			ELSEIF sPrtGbn = '3' THEN												/*수주미처리*/
				dw_list.DataObject = 'd_sal_025308'
				dw_print.DataObject = 'd_sal_025308_p'
			ELSE																			/*전체*/
				dw_list.DataObject = 'd_sal_025302'
				dw_print.DataObject = 'd_sal_025302_p'
			END IF
		Else
			IF sPrtGbn = '1' THEN													/*생산미처리*/
				dw_list.DataObject = 'd_sal_025306'
				dw_print.DataObject = 'd_sal_025306_p'
			ELSEIF sPrtGbn = '2' THEN												/*수주미처리*/
				dw_list.DataObject = 'd_sal_025307'
				dw_print.DataObject = 'd_sal_025307_p'				
			ELSEIF sPrtGbn = '3' THEN												/*수주미처리*/
				dw_list.DataObject = 'd_sal_025309'
				dw_print.DataObject = 'd_sal_025309_p'
			ELSE																			/*전체*/
				dw_list.DataObject = 'd_sal_025305'
				dw_print.DataObject = 'd_sal_025305_p'
			END IF
		End If
		
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)		
		dw_list.Reset()
		dw_print.Reset()
		dw_list.SetRedraw(True)
	/* 자료구분 */
	Case 'sgubun'
		sGubun = GetText()

		sPrtGbn = GetItemString(1, 'prtgbn')
		dw_list.SetRedraw(False)
		/* 수주일자 기준 */
		If sGubun = '1' Then
			IF sPrtGbn = '1' THEN													/*생산미처리*/
				dw_list.DataObject = 'd_sal_025303'
				dw_print.DataObject = 'd_sal_025303_p'
			ELSEIF sPrtGbn = '2' THEN												/*수주미처리*/
				dw_list.DataObject = 'd_sal_025304'
				dw_print.DataObject = 'd_sal_025304_p'
			ELSEIF sPrtGbn = '3' THEN												/*수주미처리*/
				dw_list.DataObject = 'd_sal_025308'
				dw_print.DataObject = 'd_sal_025308_p'
			ELSE																			/*전체*/
//				dw_list.DataObject = 'd_sal_025302'
//				dw_print.DataObject = 'd_sal_025302_p'
				dw_list.DataObject = 'd_sal_025302-1'
				dw_print.DataObject = 'd_sal_025302-1_p'
			END IF
		Else
			IF sPrtGbn = '1' THEN													/*생산미처리*/
				dw_list.DataObject = 'd_sal_025306'
				dw_print.DataObject = 'd_sal_025306_p'
			ELSEIF sPrtGbn = '2' THEN												/*수주미처리*/
				dw_list.DataObject = 'd_sal_025307'
				dw_print.DataObject = 'd_sal_025307_p'
			ELSEIF sPrtGbn = '3' THEN												/*수주미처리*/
				dw_list.DataObject = 'd_sal_025309'
				dw_print.DataObject = 'd_sal_025309_p'
			ELSE																			/*전체*/
//				dw_list.DataObject = 'd_sal_025305'
//				dw_print.DataObject = 'd_sal_025305_p'
				dw_list.DataObject = 'd_sal_025305-1'
				dw_print.DataObject = 'd_sal_025305-1_p'
			END IF
		End If
		
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)		
		dw_list.Reset()
		dw_print.Reset()
		dw_list.SetRedraw(True)
		
END Choose

end event

event dw_ip::rbuttondown;string sIoCustName, sIoCustArea,	sDept,sIoGbn,sNull

SetNull(sNull)
SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02530
integer y = 432
integer width = 4567
integer height = 1792
string dataobject = "d_sal_025302-1"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_02530
integer x = 1449
integer y = 208
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02530
integer x = 1925
integer y = 208
integer height = 76
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 27
integer y = 188
integer width = 4590
integer height = 212
integer cornerheight = 40
integer cornerwidth = 40
end type

type rr_2 from roundrectangle within w_sal_02530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 424
integer width = 4590
integer height = 1808
integer cornerheight = 40
integer cornerwidth = 46
end type

