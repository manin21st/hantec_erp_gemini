$PBExportHeader$w_sal_02640.srw
$PBExportComments$제품 반품 재검사 대장
forward
global type w_sal_02640 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02640
end type
type pb_2 from u_pb_cal within w_sal_02640
end type
type rr_1 from roundrectangle within w_sal_02640
end type
end forward

global type w_sal_02640 from w_standard_print
integer height = 2448
string title = "반품 재검사 대장"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_02640 w_sal_02640

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sFrom,sTo,sIogbn,sSteamCd,sSarea,sCvcod,ssaupj

If dw_ip.AcceptText() <> 1 Then Return -1

sFrom       = dw_ip.GetItemString(1,"sdatef")
sTo         = dw_ip.GetItemString(1,"sdatet")
sIoGbn      = Trim(dw_ip.GetItemString(1,"iogbn"))
sSteamCd    = Trim(dw_ip.GetItemString(1,"deptcode"))
sSArea      = Trim(dw_ip.GetItemString(1,"areacode"))
sCvcod      = Trim(dw_ip.GetItemString(1,"custcode"))
ssaupj = dw_ip.getitemstring(1,"saupj")

If IsNull(sIogbn ) Then sIoGbn = ''
If IsNull(sSteamCd) Then sSteamCd = ''
If IsNull(sSarea) Then sSarea = ''
If IsNull(sCvcod) Then sCvcod = ''

IF sFrom = "" OR IsNull(sFrom) THEN
	f_message_chk(30,'[기간]')
	dw_ip.SetColumn("sdatef")
	dw_ip.SetFocus()
	Return -1
END IF

IF sTo = "" OR IsNull(sTo) THEN
	f_message_chk(30,'[기간]')
	dw_ip.SetColumn("sdatet")
	dw_ip.SetFocus()
	Return -1
END IF

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If

//IF dw_list.Retrieve(sFrom,sTo,sIogbn+'%',sSteamCd+'%',sSarea+'%',sCvcod+'%',gs_sabu,ssaupj) <=0 THEN
//	f_message_chk(50,'')
//   dw_ip.setcolumn('sdatef')
//	dw_ip.SetFocus()
//	Return -1
//End If

IF dw_print.Retrieve(sFrom,sTo,sIogbn+'%',sSteamCd+'%',sSarea+'%',sCvcod+'%',gs_sabu,ssaupj) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('sdatef')
	dw_ip.SetFocus()
	Return -1
End If

dw_print.ShareData(dw_list)

string tx_name

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(iogbn) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_iogbn.text = '"+tx_name+"'")
dw_print.Modify("tx_iogbn.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(deptcode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_steamcd.text = '"+tx_name+"'")
dw_print.Modify("tx_steamcd.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(areacode) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_sarea.text = '"+tx_name+"'")
dw_print.Modify("tx_sarea.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetItemString(1,'custname'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_cvcod.text = '"+tx_name+"'")
dw_print.Modify("tx_cvcod.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

Return 1

end function

on w_sal_02640.create
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

on w_sal_02640.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;/* User별 관할구역 Setting */
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
//
/* 사업장 구분 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

DataWindowChild state_child
integer rtncode

//영업팀
f_child_saupj(dw_ip, 'deptcode', gs_saupj) 

//관할 구역
f_child_saupj(dw_ip, 'areacode', gs_saupj) 

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 
dw_ip.SetItem(1,"sdatef", Left(is_today,6)+'01')
dw_ip.SetItem(1,"sdatet", is_today)
dw_ip.Setfocus()

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_02640
end type

type p_exit from w_standard_print`p_exit within w_sal_02640
end type

type p_print from w_standard_print`p_print within w_sal_02640
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02640
end type











type dw_print from w_standard_print`dw_print within w_sal_02640
string dataobject = "d_sal_02640_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02640
integer x = 73
integer y = 36
integer width = 3406
integer height = 188
string dataobject = "d_sal_02640_1"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::itemfocuschanged;
IF this.GetColumnName() = "custname" OR this.GetColumnName() ='deptname'THEN
	f_toggle_kor(Handle(this))
ELSE
	f_toggle_eng(Handle(this))
END IF
end event

event dw_ip::itemchanged;String  sDate,sNull,sDept,sIocust,sIocustname,sIocustArea , sCvcod, scvnas, sarea, steam, sSaupj, sName1, ls_saupj

SetNull(sNull)
Choose Case GetColumnName() 
	Case  "sdatef" ,"sdatet" 
	sDate = Trim(this.GetText())
	IF sDate ="" OR IsNull(sDate) THEN RETURN
	
	IF f_datechk(sDate) = -1 THEN
		f_message_chk(35,'[기간]')
		this.SetItem(1,GetColumnName(),'')
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
	
	/* 거래처 */
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			ls_saupj = dw_ip.object.saupj[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"custname", scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 

			Return 1

		END IF
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
				SetItem(1,'custcode', sCvcod)
				SetItem(1,"custname", scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 

			Return 1
			
		END IF
	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam, scode  
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
		
		//영업팀
		f_child_saupj(dw_ip, 'deptcode', ls_saupj) 
		ls_steam = dw_ip.object.deptcode[1] 
		ls_return = f_saupj_chk_t('2' , ls_steam ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'deptcode', '')
		End if 

END Choose

end event

event dw_ip::rbuttondown;string sIoCustName, sIoCustArea,	sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

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

// Case "custcode","custname"
//	gs_gubun = '1'
//	Open(w_agent_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"custcode",gs_code)
//	
//	SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,		:sIoCustArea,			:sDept
//	   FROM "VNDMST","SAREA" 
//   	WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//	IF SQLCA.SQLCODE = 0 THEN
//	  this.SetItem(1,"deptcode",  sDept)
//	  this.SetItem(1,"custname",  sIoCustName)
//	  this.SetItem(1,"areacode",  sIoCustArea)
//	END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02640
integer x = 87
integer y = 260
integer width = 4512
integer height = 2032
string dataobject = "d_sal_02640"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_sal_02640
integer x = 718
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

type pb_2 from u_pb_cal within w_sal_02640
integer x = 1189
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

type rr_1 from roundrectangle within w_sal_02640
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 252
integer width = 4539
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

