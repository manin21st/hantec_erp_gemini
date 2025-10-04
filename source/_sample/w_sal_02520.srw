$PBExportHeader$w_sal_02520.srw
$PBExportComments$수주 접수 현황 - 기간별
forward
global type w_sal_02520 from w_standard_print
end type
type rb_1 from radiobutton within w_sal_02520
end type
type rb_2 from radiobutton within w_sal_02520
end type
type pb_1 from u_pb_cal within w_sal_02520
end type
type pb_2 from u_pb_cal within w_sal_02520
end type
type pb_3 from u_pb_cal within w_sal_02520
end type
type pb_4 from u_pb_cal within w_sal_02520
end type
type rr_1 from roundrectangle within w_sal_02520
end type
type rr_2 from roundrectangle within w_sal_02520
end type
end forward

global type w_sal_02520 from w_standard_print
string title = "수주 접수 현황 - 기간별"
rb_1 rb_1
rb_2 rb_2
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_02520 w_sal_02520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,sTeam,sArea,sCust,sSpecGbn,sSpecialGbn,sSpec = '.'
String sTeamName, sAreaName, sSaleGu, sPdtgu, sPdtguName,ls_sugugb,ls_pangb,tx_name,ssaupj ,ls_emp_id
String ls_st, ls_ed

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = dw_ip.GetItemString(1,"sdatef")
sTo         = dw_ip.GetItemString(1,"sdatet")
sTeam       = dw_ip.GetItemString(1,"deptcode")
sArea       = dw_ip.GetItemString(1,"areacode")
sCust       = dw_ip.GetItemString(1,"custcode")
sSpecGbn    = dw_ip.GetItemString(1,"specgbn")
sSpecialGbn = dw_ip.GetItemString(1,"specialyn")
sSaleGu     = dw_ip.GetItemString(1,"salegu")
sPdtgu      = dw_ip.GetItemString(1,"pdtgu")
ls_sugugb   = dw_ip.Getitemstring(1,"sugugb")
ls_pangb    = dw_ip.Getitemstring(1,"pangb")
ssaupj      = dw_ip.getitemstring(1,"saupj")
ls_emp_id   = dw_ip.getitemstring(1,'emp_id')
ls_st       = dw_ip.GetItemString(1,'napst')
ls_ed       = dw_ip.GetItemString(1,'naped')

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

IF ls_st = "" OR IsNull(ls_st) THEN ls_st = '19000101'

IF ls_ed = "" OR IsNull(ls_ed) THEN ls_ed = '29991231'

If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400,'[부가사업장]')
	dw_ip.SetFocus()
	Return -1
End If

IF sTeam = "" OR IsNull(sTeam) THEN sTeam = '%'

IF sArea = "" OR IsNull(sArea) THEN sArea = '%'
IF sCust = "" OR IsNull(sCust) THEN sCust = '%'
IF sPdtgu = "" OR IsNull(sPdtgu) THEN sPdtgu = '%'
if ls_sugugb = "" or isnull(ls_sugugb) then ls_sugugb = ''
if ls_pangb = "" or isnull(ls_pangb) then ls_pangb = ''
if ls_emp_id = "" or isnull(ls_emp_id) then ls_emp_id ='%'

/* 특출구분 */
IF sSpecialGbn <> 'Y' THEN sSpecialGbn = ''

/* 특수사양 */
IF sSpecGbn <> 'Y' THEN 	sSpecGbn = ''

/* 출고구분 (A:전체, Y:판매출고, N:무상출고 */
If sSaleGu = 'A' Then sSaleGu = ''

//IF dw_list.Retrieve(gs_sabu,sFrom,sTo,sTeam,sArea,sCust,sSpecialGbn+'%',sSpecGbn+'%', sSaleGu+'%', sPdtgu,ls_sugugb+'%',ls_pangb+'%',ssaupj,ls_emp_id) <=0 THEN
//	f_message_chk(50,'')
//   dw_ip.setcolumn('sdatef')
//	dw_ip.SetFocus()
//	Return -1
//End If

IF dw_print.Retrieve(gs_sabu,sFrom,sTo,sTeam,sArea,sCust,sSpecialGbn+'%',sSpecGbn+'%', &
                     sSaleGu+'%', sPdtgu,ls_sugugb+'%',ls_pangb+'%',ssaupj,ls_emp_id, ls_st, ls_ed) <= 0 THEN
	f_message_chk(50, '')
	dw_list.Reset()
	dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
END IF
			
dw_print.ShareData(dw_list)

IF sTeam ='%' THEN
	sTeamName = '전 체'
Else
	sTeamName = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
End If

IF sArea ='%' THEN
	sAreaName = '전 체'
Else
	sAreaName = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
End If

IF sPdtgu ='%' THEN
	sPdtguName = '전 체'
Else
	sPdtguName = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
End If

dw_print.Modify("txt_dept.text = '"+sTeamName+"'")
dw_print.Modify("txt_area.text = '"+sAreaName+"'")
dw_print.Modify("txt_pdtgu.text = '"+sPdtguName+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sugugb) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_sugugb.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pangb) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_pangb.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_emp_id.text = '"+tx_name+"'")


//dw_list.Modify("txt_dept.text = '"+sTeamName+"'")
//dw_list.Modify("txt_area.text = '"+sAreaName+"'")
//dw_list.Modify("txt_pdtgu.text = '"+sPdtguName+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(sugugb) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_sugugb.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pangb) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_pangb.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_emp_id.text = '"+tx_name+"'")
//
Return 1
end function

on w_sal_02520.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.pb_4
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
end on

on w_sal_02520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;rb_1.Checked = True
rb_1.TriggerEvent(Clicked!)

/* User별 관할구역 Setting */
String sarea, steam , saupj

//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'areacode', sarea)
//	dw_ip.SetItem(1, 'deptcode', steam)
//	dw_ip.SetItem(1, 'saupj', saupj)
//   dw_ip.Modify("areacode.protect=1")
//	dw_ip.Modify("deptcode.protect=1")
//	dw_ip.Modify("areacode.background.color = 80859087")
//	dw_ip.Modify("deptcode.background.color = 80859087")
//End If

/* 사업장 구분 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode
 
//생산팀
rtncode 	= dw_ip.GetChild('pdtgu', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('03',gs_saupj)

//영업팀
rtncode 	= dw_ip.GetChild('deptcode', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업팀")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('%')

//영업 담당자
rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

//관할 구역
rtncode 	= dw_ip.GetChild('areacode', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 관할구역")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('%')
//
dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 

dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)
dw_ip.SetColumn("deptcode")
dw_ip.Setfocus()
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

type p_xls from w_standard_print`p_xls within w_sal_02520
end type

type p_sort from w_standard_print`p_sort within w_sal_02520
end type

type p_preview from w_standard_print`p_preview within w_sal_02520
end type

type p_exit from w_standard_print`p_exit within w_sal_02520
end type

type p_print from w_standard_print`p_print within w_sal_02520
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02520
end type











type dw_print from w_standard_print`dw_print within w_sal_02520
string dataobject = "d_sal_025202_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02520
integer x = 50
integer y = 220
integer width = 4558
integer height = 300
string dataobject = "d_sal_025201"
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

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,sDeptname,sDateFrom,sDateTo,snull
string  sCvcod, scvnas, sarea, steam, sSaupj, sName1 
String ls_saupj, scode, ls_sarea, ls_return, ls_steam, ls_emp_id, ls_pdtgu
long rtncode 
Datawindowchild state_child 

SetNull(snull)

Choose Case GetColumnName() 
 Case "sdatef","sdatet"
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[수주일자]')
		this.SetItem(1,GetColumnName(),snull)
		Return 1
	END IF
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
			SetItem(1,"custcode",  		sCvcod)
			SetItem(1,"custname",		scvnas)

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
		
		//영업 담당자
		rtncode 	= dw_ip.GetChild('emp_id', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업 담당자")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('47',ls_saupj)
		ls_emp_id = dw_ip.object.emp_id[1]
		ls_return = f_saupj_chk_t('3' , ls_emp_id ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'emp_id', '')
		End if 
		
		//생산팀
		rtncode 	= dw_ip.GetChild('pdtgu', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('03',ls_saupj)
		ls_saupj = dw_ip.object.saupj[1]
		ls_return = f_saupj_chk_t('4' , ls_saupj ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'pdtgu', '')
		End if 


END Choose



end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

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
//	Case "custcode"
//		gs_gubun = '1'
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
//	Case "custname"
//		gs_gubun = '1'
//		gs_codename = Trim(GetText())
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//			this.SetItem(1,"deptcode",  sDept)
//			this.SetItem(1,"custname",  sIoCustName)
//			this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02520
integer x = 69
integer y = 560
integer width = 4503
integer height = 1760
string dataobject = "d_sal_025202"
boolean border = false
end type

type rb_1 from radiobutton within w_sal_02520
integer x = 114
integer y = 84
integer width = 329
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "기간별"
boolean checked = true
end type

event clicked;dw_list.DataObject = 'd_sal_025202'
dw_print.DataObject = 'd_sal_025202_p'
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rb_2 from radiobutton within w_sal_02520
integer x = 489
integer y = 84
integer width = 329
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "거래처별"
end type

event clicked;dw_list.DataObject = 'd_sal_025203'
dw_print.DataObject = 'd_sal_025203_p'
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

w_mdi_frame.sle_msg.text = ''
end event

type pb_1 from u_pb_cal within w_sal_02520
integer x = 736
integer y = 228
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

type pb_2 from u_pb_cal within w_sal_02520
integer x = 1230
integer y = 228
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

type pb_3 from u_pb_cal within w_sal_02520
integer x = 736
integer y = 416
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('napst')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'napst', gs_code)

end event

type pb_4 from u_pb_cal within w_sal_02520
integer x = 1230
integer y = 416
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('nated')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'nated', gs_code)

end event

type rr_1 from roundrectangle within w_sal_02520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 55
integer y = 56
integer width = 818
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 55
integer y = 552
integer width = 4530
integer height = 1776
integer cornerheight = 40
integer cornerwidth = 55
end type

