$PBExportHeader$w_sal_02690.srw
$PBExportComments$반품 현황
forward
global type w_sal_02690 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02690
end type
type pb_2 from u_pb_cal within w_sal_02690
end type
type rr_1 from roundrectangle within w_sal_02690
end type
end forward

global type w_sal_02690 from w_standard_print
string title = "반품 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_02690 w_sal_02690

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sIoDatef, sIodatet, s_steamcd, s_sarea, s_cvcod
string s_get_cvcod , tx_name,ssaupj

If dw_ip.accepttext() <> 1 Then Return -1

sIoDatef  = dw_ip.getitemstring(1,"sdatef")
sIoDatet  = dw_ip.getitemstring(1,"sdatet")
s_steamcd = dw_ip.getitemstring(1,"deptcode")
s_sarea   = dw_ip.getitemstring(1,"areacode")
s_cvcod  = dw_ip.getitemstring(1,"custcode")
ssaupj = dw_ip.getitemstring(1,"saupj")

If IsNull(s_steamcd) then s_steamcd = ''
If IsNull(s_sarea) then s_sarea = ''
If IsNull(s_cvcod) then s_cvcod = ''

////필수입력항목 체크///////////////////////////////////
If f_datechk(sIoDatef) <> 1 then
	f_message_chk(30,'[반품기간]')
	dw_ip.setfocus()
	Return -1
End If

If f_datechk(sIoDatet) <> 1 then
	f_message_chk(30,'[반품기간]')
	dw_ip.setfocus()
	Return -1
End If

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

//// <조회> ///////////////////////////////////////////////////////////////////////////////////////////
//IF dw_list.retrieve(gs_sabu, sIoDatef, sIoDatet, s_steamcd+'%',s_sarea+'%', s_cvcod+'%',ssaupj) <= 0 THEN
//   f_message_chk(50,'[반품현황]')
//	dw_ip.setfocus()
////	cb_print.Enabled =False
//	SetPointer(Arrow!)
//	Return -1
//END IF

IF dw_print.retrieve(gs_sabu, sIoDatef, sIoDatet, s_steamcd+'%',s_sarea+'%', s_cvcod+'%',ssaupj) <= 0 THEN
   f_message_chk(50,'[반품현황]')
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
END IF

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_steam.text = '"+tx_name+"'")
dw_print.Modify("txt_steam.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_sarea.text = '"+tx_name+"'")
dw_print.Modify("txt_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

Return 1
end function

on w_sal_02690.create
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

on w_sal_02690.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;
/* User별 관할구역 Setting */
String sarea, steam , saupj
//
//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'areacode', sarea)
//	dw_ip.SetItem(1, 'deptcode', steam)
//	dw_ip.SetItem(1, 'saupj', saupj)
//   dw_ip.Modify("areacode.protect=1")
//	dw_ip.Modify("deptcode.protect=1")
//	dw_ip.Modify("areacode.background.color = 80859087")
//	dw_ip.Modify("deptcode.background.color = 80859087")
//
//End If
//
/* User별 사업장 Setting */

setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//영업팀
f_child_saupj(dw_ip, 'deptcode', '%') 

//관할 구역
f_child_saupj(dw_ip, 'areacode', '%') 

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 
dw_ip.SetItem(1,'sdatef',Left(is_today,6)+'01')
dw_ip.SetItem(1,'sdatet',is_today)
dw_ip.setfocus()
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

type p_preview from w_standard_print`p_preview within w_sal_02690
integer x = 4082
end type

type p_exit from w_standard_print`p_exit within w_sal_02690
integer x = 4430
end type

type p_print from w_standard_print`p_print within w_sal_02690
integer x = 4256
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02690
integer x = 3909
end type







type st_10 from w_standard_print`st_10 within w_sal_02690
end type



type dw_print from w_standard_print`dw_print within w_sal_02690
integer x = 4133
integer y = 176
string dataobject = "d_sal_02690_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02690
integer y = 36
integer width = 3643
integer height = 212
string dataobject = "d_sal_02690"
end type

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,snull,sIoDate,sInsDat
string  sCvcod, scvnas, sarea, steam, sSaupj, sName1
String ls_saupj, ls_sarea, ls_return, ls_steam, ls_emp_id, ls_pdtgu, scode
long rtncode 
Datawindowchild state_child 

SetNull(snull)

Choose Case GetColumnName() 
	/* 반품일자 */
	Case "sdatef", "sdatet"
		sIoDate = Trim(this.GetText())
		IF sIoDate ="" OR IsNull(sIoDate) THEN RETURN
		
		IF f_datechk(sIoDate) = -1 THEN
			f_message_chk(35,'[반품기간]')
			this.SetItem(1,GetColumnName() ,snull)
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
	

	Case "custcode"
		sCvcod = Trim(GetText())
		IF 	sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1, 'custcode', sCvcod)
			SetItem(1,"custname", scvnas)
		END IF
		
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		If 	f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,'custcode', sCvcod)
			SetItem(1,"custname", scvnas)			
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
	
	/* 발행구분 */
	Case 'prtgbn'
		dw_list.SetRedraw(False)
		If GetItemString(1, 'salegu') = 'N' Then
			If Trim(GetText()) = '1' Then /* 기간별 */
				dw_list.DataObject = 'd_sal_02690_1'
				dw_print.DataObject = 'd_sal_02690_1_p'
			Else                 /* 거래처별 */
				dw_list.DataObject = 'd_sal_02690_2'
				dw_print.DataObject = 'd_sal_02690_2_p'
			End If
		Else
			/* 수출일 경우 */
			If Trim(GetText()) = '1' Then /* 기간별 */
				dw_list.DataObject = 'd_sal_02690_3'
				dw_print.DataObject = 'd_sal_02690_3_p'
			Else                 /* 거래처별 */
				dw_list.DataObject = 'd_sal_02690_4'
				dw_print.DataObject = 'd_sal_02690_4_p'
			End If
		End If
		dw_print.SetTransObject(sqlca)
		dw_list.SetTransObject(sqlca)
		dw_list.SetRedraw(True)
	/* 발행구분 */
	Case 'salegu'
		dw_list.SetRedraw(False)
		If GetText() = 'N' Then
			If Trim(GetItemString(1,'prtgbn')) = '1' Then /* 기간별 */
				dw_list.DataObject = 'd_sal_02690_1'
				dw_print.DataObject = 'd_sal_02690_1_p'
			Else                 /* 거래처별 */
				dw_list.DataObject = 'd_sal_02690_2'
				dw_print.DataObject = 'd_sal_02690_2_p'
			End If
		Else
			/* 수출일 경우 */
			If Trim(GetItemString(1,'prtgbn')) = '1' Then /* 기간별 */
				dw_list.DataObject = 'd_sal_02690_3'
				dw_print.DataObject = 'd_sal_02690_3_p'
			Else                 /* 거래처별 */
				dw_list.DataObject = 'd_sal_02690_4'
				dw_print.DataObject = 'd_sal_02690_4_p'
			End If
		End If
		dw_print.SetTransObject(sqlca)
		dw_list.SetTransObject(sqlca)
		dw_list.SetRedraw(True)
END Choose

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept,siojpno,siocust,sIoDate,sInsDat
Long nRow

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case this.GetColumnName() 
	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
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
//		gs_codename = Trim(GetText())
//		gs_gubun = '1'
//		Open(w_agent_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		this.SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//			INTO :sIoCustName,		:sIoCustArea,			:sDept
//			FROM "VNDMST","SAREA" 
//			WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//		  this.SetItem(1,"deptcode",  sDept)
//		  this.SetItem(1,"custname",  sIoCustName)
//		  this.SetItem(1,"areacode",  sIoCustArea)
//		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02690
integer x = 50
integer y = 272
integer width = 4535
integer height = 2048
string dataobject = "d_sal_02690_1"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_02690
integer x = 759
integer y = 52
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

type pb_2 from u_pb_cal within w_sal_02690
integer x = 1239
integer y = 52
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

type rr_1 from roundrectangle within w_sal_02690
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 264
integer width = 4553
integer height = 2072
integer cornerheight = 40
integer cornerwidth = 55
end type

