$PBExportHeader$w_sal_06710.srw
$PBExportComments$ ===> BUYER별 미수금 현황
forward
global type w_sal_06710 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_06710
end type
type pb_2 from u_pb_cal within w_sal_06710
end type
type rr_1 from roundrectangle within w_sal_06710
end type
end forward

global type w_sal_06710 from w_standard_print
string title = "BUYER별 미수금 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_06710 w_sal_06710

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sDatef, sDatet, sArea, sCvcod ,ls_saupj ,tx_name

If dw_ip.AcceptText() <> 1 then Return -1

ls_saupj = dw_ip.getitemstring(1,'saupj')

if ls_saupj = "" or isnull(ls_saupj) then ls_saupj = '%'

sDatef = Trim(dw_ip.GetItemString(1,'sdatef'))
sDatet = Trim(dw_ip.GetItemString(1,'sdatet'))
sArea = Trim(dw_ip.GetItemString(1,'sarea'))
sCvcod = Trim(dw_ip.GetItemString(1,'cvcod'))

dw_ip.setfocus()
If f_datechk(sDatef) <> 1 Then
	f_Message_Chk(35, '[선적기간]')
	dw_ip.setcolumn('sdatef')
	Return -1
End If

If f_datechk(sDatet) <> 1 Then
	f_Message_Chk(35, '[선적기간]')
	dw_ip.setcolumn('sdatet')
	Return -1
End If

If IsNull(sArea) then sArea = ''
If IsNull(sCvcod) then sCvcod = ''

if dw_list.Retrieve(gs_sabu, sDatef, sDatet, sArea+'%',sCvcod+'%',ls_saupj) < 1 then
  f_message_Chk(300, '[출력조건 CHECK]')
 	dw_ip.setcolumn('sdatef')
	dw_ip.setfocus()
 	return -1
end if

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_saupj.text = '"+tx_name+"'")

return 1

end function

on w_sal_06710.create
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

on w_sal_06710.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.setitem(1,'sdatef',left(f_today(),6) + '01')
dw_ip.setitem(1,'sdatet',left(f_today(),8))
sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

///* User별 관할구역 Setting */
//String sarea, steam , saupj
//
//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'sarea', sarea)
//	dw_ip.SetItem(1, 'saupj', saupj)
//   dw_ip.Modify("sarea.protect=1")
//	dw_ip.Modify("sarea.background.color = 80859087")
//End If

/* 사업장 구분 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//관할 구역
f_child_saupj(dw_ip, 'sarea', gs_saupj) 

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 

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

type p_preview from w_standard_print`p_preview within w_sal_06710
end type

type p_exit from w_standard_print`p_exit within w_sal_06710
end type

type p_print from w_standard_print`p_print within w_sal_06710
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06710
end type







type st_10 from w_standard_print`st_10 within w_sal_06710
end type



type dw_print from w_standard_print`dw_print within w_sal_06710
string dataobject = "d_sal_06710"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06710
integer x = 37
integer y = 20
integer width = 2651
integer height = 256
string dataobject = "d_sal_06710_01"
end type

event dw_ip::itemchanged;String sNull, sIoCustArea, sDept, sIoCust, sIoCustName , sCvcod, scvnas, sarea, steam, sSaupj, sName1, ls_saupj

SetNull(sNull)

Choose Case GetColumnName()
	Case "sdatef",'sdatet'
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[선적기간]')
			this.SetItem(1, GetColumnName(), sNull)
			return 1
		end if
	/* 관할구역 */
	Case "sarea"
		SetItem(1,"cvcod",sNull)
		SetItem(1,"cvcodnm",sNull)
	/* 거래처 */
	Case "cvcod"
		sCvcod = this.GetText()
		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"cvcod",  		sCvcod)
				SetItem(1,"cvcodnm",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ]에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
		END IF

	/* 거래처명 */
	Case "cvcodnm"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"cvcod",  		sCvcod )
				SetItem(1,"cvcodnm",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ]에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 

			Return 1
		END IF
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 
		//거래처
		sCvcod 	= this.object.cvcod[1] 
		f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
		End if 
 
		//관할 구역
		f_child_saupj(dw_ip, 'sarea', ls_saupj)
		ls_sarea = dw_ip.object.sarea[1] 
		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'sarea', '')
		End if 
end Choose

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;String sIoCustName, sIoCustArea, sDept

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	Case "cvcod", "cvcodnm"
		gs_gubun = '1'
		If GetColumnName() = "cvcodnm" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
///* 거래처 */
//Case "cvcod"
//	gs_gubun = '2'
//	Open(w_agent_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"cvcod",gs_code)
//	
//	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//	   FROM "VNDMST","SAREA" 
//   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//	IF SQLCA.SQLCODE = 0 THEN
//	  this.SetItem(1,"cvcodnm",  sIoCustName)
//	  this.SetItem(1,"sarea",  sIoCustArea)
//	END IF
//Case "cvcodnm"
//	gs_codename = Trim(GetText())
//	gs_gubun = '2'
//	Open(w_agent_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"cvcod",gs_code)
//	
//	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//	   FROM "VNDMST","SAREA" 
//   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//	IF SQLCA.SQLCODE = 0 THEN
//	  this.SetItem(1,"cvcodnm",  sIoCustName)
//	  this.SetItem(1,"sarea",  sIoCustArea)
//	END IF
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_06710
integer x = 55
integer y = 296
integer width = 4558
integer height = 2040
string dataobject = "d_sal_06710"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_06710
integer x = 745
integer y = 52
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatef')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatef', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06710
integer x = 1211
integer y = 52
integer height = 80
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdatet')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdatet', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06710
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 280
integer width = 4590
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

