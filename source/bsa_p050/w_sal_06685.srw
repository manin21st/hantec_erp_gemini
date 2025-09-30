$PBExportHeader$w_sal_06685.srw
$PBExportComments$Buyer별 수주 미선적 현황
forward
global type w_sal_06685 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_06685
end type
type pb_2 from u_pb_cal within w_sal_06685
end type
type rr_1 from roundrectangle within w_sal_06685
end type
end forward

global type w_sal_06685 from w_standard_print
string title = "Buyer별 수주 미선적 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_06685 w_sal_06685

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	sfrdate,stodate,steamcd,sarea,sCvcod ,ls_saupj, ls_emp_id
string   tx_steamnm,tx_sareanm,tx_cvcodnm

////////////////////////////////////////////////////// 조건절값
If dw_ip.accepttext() <> 1 Then Return -1

sfrdate   = trim(dw_ip.getitemstring(1, 'sfrdate'))
stodate   = trim(dw_ip.getitemstring(1, 'stodate'))
steamcd   = trim(dw_ip.getitemstring(1, 'deptcode'))
sarea     = trim(dw_ip.getitemstring(1, 'areacode'))
sCvcod    = trim(dw_ip.getitemstring(1, 'custcode'))
ls_saupj  = dw_ip.getitemstring(1,'saupj')
ls_emp_id = Trim(dw_ip.getitemstring(1,'emp_id'))

If ls_emp_id = '' Or IsNull(ls_emp_id) Then ls_emp_id = '%'
If IsNull(steamcd) Then steamcd = ''
If IsNull(sarea)   Then sarea = ''
If IsNull(scvcod)  Then scvcod = ''
////////////////////////////////////////////////////// 기간 유효성 check
IF	f_datechk(sfrdate) = -1 then
   f_message_chk(30,'[수주기간]')
	dw_ip.setcolumn('sfrdate')
	dw_ip.setfocus()
	Return -1
END IF

IF	f_datechk(stodate) = -1 then
   f_message_chk(30,'[수주기간]')
	dw_ip.setcolumn('stodate')
	dw_ip.setfocus()
	Return -1
END IF
////////////////////////////////////////////////////// 검색
SetPointer(HourGlass!)

If dw_print.retrieve(sfrdate, stodate, sArea+'%', sCvcod+'%', gs_sabu,ls_saupj, ls_emp_id) < 1	then
	f_message_chk(50,"")
	dw_ip.setcolumn('sfrdate')
	dw_ip.setfocus()
	dw_list.insertrow(0)
	//Return -1
End If

////////////////////////////////////////////////////// 타이틀 설정
string tx_name

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Object.tx_sarea.text = tx_name

tx_name = trim(dw_ip.getitemstring(1, 'custname'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Object.tx_cvcod.text = tx_name

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(emp_id) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_empid.text = '"+tx_name+"'")

dw_print.sharedata(dw_list)
Return 1
end function

on w_sal_06685.create
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

on w_sal_06685.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;DataWindowChild state_child
integer rtncode
String sDate

f_mod_saupj(dw_ip, 'saupj') 

//관할 구역
f_child_saupj(dw_ip, 'areacode', gs_saupj) 

//영업담당자
rtncode 	= dw_ip.GetChild('emp_id', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업담당자")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('47',gs_saupj)

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 

dw_ip.setitem(1,'sfrdate',left(f_today(),6) + '01')
dw_ip.setitem(1,'stodate',left(f_today(),8))

w_mdi_frame.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

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

type p_preview from w_standard_print`p_preview within w_sal_06685
end type

type p_exit from w_standard_print`p_exit within w_sal_06685
end type

type p_print from w_standard_print`p_print within w_sal_06685
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06685
end type







type st_10 from w_standard_print`st_10 within w_sal_06685
end type



type dw_print from w_standard_print`dw_print within w_sal_06685
string dataobject = "d_sal_06685_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06685
integer x = 0
integer y = 0
integer width = 3689
integer height = 252
string dataobject = "d_sal_06685_01"
end type

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
	/* 거래처 */
	Case "custcode"
		gs_gubun = '2'
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
	/* 거래처명 */
	Case "custname"
		gs_gubun = '2'
		gs_codename = Trim(GetText())
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		this.SetItem(1,"custcode",gs_code)
		
		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
		  INTO :sIoCustName,		:sIoCustArea,			:sDept
		  FROM "VNDMST","SAREA" 
		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
		IF SQLCA.SQLCODE = 0 THEN
			this.SetItem(1,"deptcode",  sDept)
			this.SetItem(1,"custname",  sIoCustName)
			this.SetItem(1,"areacode",  sIoCustArea)
		END IF
END Choose

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String sNull, sIoCustArea, sDept, sIocust, sIocustname,sCode, scvnas, sarea, steam, sSaupj, sName1, ls_saupj, sCvcod

SetNull(sNull)

Choose Case  GetColumnName() 
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
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode",  		sCode)
				SetItem(1,"custname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCode +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 

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
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custcode",  		sCode)
				SetItem(1,"custname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCode +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
		END IF
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 
		//거래처
		sCode 	= this.object.custcode[1] 
		f_get_cvnames('1', sCode, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
		End if 
 
		//관할 구역
		f_child_saupj(dw_ip, 'areacode', ls_saupj)
		ls_sarea = dw_ip.object.areacode[1] 
		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'areacode', '')
		End if 
		
End Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_06685
integer x = 23
integer y = 264
integer width = 4581
integer height = 2056
string dataobject = "d_sal_06685"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type pb_1 from u_pb_cal within w_sal_06685
integer x = 713
integer y = 36
integer height = 80
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sfrdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sfrdate', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_06685
integer x = 1179
integer y = 36
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('stodate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'stodate', gs_code)

end event

type rr_1 from roundrectangle within w_sal_06685
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 5
integer y = 252
integer width = 4622
integer height = 2092
integer cornerheight = 40
integer cornerwidth = 55
end type

