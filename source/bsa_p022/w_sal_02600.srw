$PBExportHeader$w_sal_02600.srw
$PBExportComments$ ** 반품 명세서 출력
forward
global type w_sal_02600 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_02600
end type
type pb_2 from u_pb_cal within w_sal_02600
end type
type rr_1 from roundrectangle within w_sal_02600
end type
end forward

global type w_sal_02600 from w_standard_print
string title = "반품 명세서 출력"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_sal_02600 w_sal_02600

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sIoDate, sSteamCd, sSarea, sIojpno, sCvcod, sIogbn, ls_edate
string s_get_cvcod, tx_name,ssaupj

If dw_ip.accepttext() <> 1 Then Return -1

sIoDate   = dw_ip.getitemstring(1,"sdate")
ls_edate   = dw_ip.getitemstring(1,"edate")
sIojpno  = dw_ip.getitemstring(1,"iojpno")
sSteamCd = dw_ip.getitemstring(1,"deptcode")
sSarea   = dw_ip.getitemstring(1,"areacode")
sCvcod   = dw_ip.getitemstring(1,"custcode")
sIoGbn    = dw_ip.getitemstring(1,"iogbn")
ssaupj = dw_ip.getitemstring(1,"saupj")

If IsNull(sSteamCd) then sSteamCd = ''
If IsNull(sSarea)   then sSarea   = ''
If IsNull(sCvcod)   then sCvcod 	= ''
If IsNull(sIojpno)  then sIojpno  = ''
If IsNull(sIogbn) 	then sIogbn 	= ''
////필수입력항목 체크///////////////////////////////////
if f_datechk(sIoDate) <> 1 then
	f_message_chk(30,'[반품일자]')
	dw_ip.setfocus()
	return -1
end if

If IsNull(sSaupj) Or sSaupj = '' Then sSaupj = '%'
//	f_message_chk(1400,'[부가사업장]')
//	dw_ip.SetFocus()
//	Return -1
//End If
//// <조회> ///////////////////////////////////////////////////////////////////////////////////////////
//IF dw_list.retrieve(gs_sabu, sIoDate, sSteamCd+'%',sSarea+'%', sCvcod+'%', sIojpno+'%', sIogbn+'%',ssaupj) <= 0 THEN
//   f_message_chk(50,'[반품명세서]')
//	dw_ip.setfocus()
////	cb_print.Enabled =False
//	SetPointer(Arrow!)
//	Return -1
//END IF

IF dw_print.retrieve(gs_sabu, sIoDate,ls_edate, sSteamCd+'%',sSarea+'%', sCvcod+'%', sIojpno+'%', sIogbn+'%',ssaupj) <= 0 THEN
   f_message_chk(50,'[반품명세서]')
	dw_ip.setfocus()
	SetPointer(Arrow!)
	Return -1
END IF

dw_print.ShareData(dw_list)

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(iogbn) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("txt_iogbn.text = '"+tx_name+"'")
dw_print.Modify("txt_iogbn.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_list.Modify("tx_saupj.text = '"+tx_name+"'")
dw_print.Modify("tx_saupj.text = '"+tx_name+"'")

return 1
end function

on w_sal_02600.create
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

on w_sal_02600.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;DataWindowChild state_child
integer rtncode

//영업팀
rtncode 	= dw_ip.GetChild('deptcode', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 영업팀")
state_child.SetTransObject(SQLCA)
state_child.Retrieve(gs_saupj)

//관할 구역
rtncode 	= dw_ip.GetChild('areacode', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 관할구역")
state_child.SetTransObject(SQLCA)
state_child.Retrieve(gs_saupj)

/* 부가 사업장 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'saupj')

dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 

dw_ip.setfocus()
dw_ip.SetItem(1,'sdate',Left(f_today(),6) + '01')
dw_ip.SetItem(1,'edate',f_today())

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_02600
end type

type p_exit from w_standard_print`p_exit within w_sal_02600
end type

type p_print from w_standard_print`p_print within w_sal_02600
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02600
end type







type st_10 from w_standard_print`st_10 within w_sal_02600
end type



type dw_print from w_standard_print`dw_print within w_sal_02600
string dataobject = "d_sal_02600_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02600
integer x = 59
integer y = 32
integer width = 3758
integer height = 188
string dataobject = "d_sal_02600_01"
end type

event dw_ip::itemchanged;String  sIoCust,sIoCustArea,sIoCustName,sDept,snull,sIoJpno,sIoconfirm,sIoDate,sInsDat
string  sCvcod, scvnas, sarea, steam, sSaupj, sName1, ls_saupj

SetNull(snull)

Choose Case GetColumnName() 
/* 반품일자 */
 Case "sdate"
	sIoDate = Trim(this.GetText())
	IF sIoDate ="" OR IsNull(sIoDate) THEN RETURN
	
	IF f_datechk(sIoDate) = -1 THEN
		f_message_chk(35,'[반품일자]')
		this.SetItem(1,"sdate",snull)
		Return 1
	END IF
/* 반품의뢰번호 */
 Case "iojpno"
	sIoJpNo = Mid(this.GetText(),1,12)
	IF sIoJpNo = "" OR IsNull(sIoJpNo) THEN RETURN
	
	SELECT DISTINCT "IMHIST"."IO_CONFIRM", "IMHIST"."CVCOD",
	                "IMHIST"."IO_DATE", "IMHIST"."INSDAT"
     INTO :sIoconFirm  ,:sIoCust, :sIoDate, :sInsDat
	  FROM "IMHIST"  
    WHERE ( "IMHIST"."SABU" = :gs_sabu ) AND ( SUBSTR("IMHIST"."IOJPNO",1,12) = :sIoJpNo ) AND
			 ( "IMHIST"."JNPCRT" ='005');

	IF SQLCA.SQLCODE <> 0 THEN
	  this.TriggerEvent(RButtonDown!)
	  Return 2
	ELSE
	  IF IsNull(sInsDat) or IsNull(sIoDate) THEN
	    f_message_chk(59,'[반품 확인]')
	    this.SetItem(1,"iojpno",snull)
		 Return 1
	  Else 
		 this.SetItem(1,"sdate",sIoDate)
		 this.SetItem(1,"custcode",sIoCust)
		 this.SetColumn("custcode")
		 this.SetFocus()
		
       this.TriggerEvent(ItemChanged!)
		 Return 1
	  END IF
   End If
/* 영업팀 */
 Case "deptcode"
	SetItem(1,'areacode',sNull)
	SetItem(1,"custcode",sNull)
	SetItem(1,"custname",sNull)
	SetItem(1,"iojpno",sNull)
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
				SetItem(1,"custcode",  		sCvcod)
				SetItem(1,"custname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
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
				SetItem(1,"custcode",  		sCvcod)
				SetItem(1,"custname",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + sCvcod +  ' ] 거래처에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
			End if 
			Return 1
		END IF

	case 'saupj' 
		STRING ls_return, ls_sarea , ls_steam  
		ls_saupj = gettext() 
		//거래처
		sCvcod 	= this.object.custcode[1] 
		f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
		End if 
 
		//관할 구역
		f_child_saupj(dw_ip, 'areacode', ls_saupj)
		ls_sarea = dw_ip.object.areacode[1] 
//		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'areacode', '')
//		End if 
		//영업팀
		f_child_saupj(dw_ip, 'deptcode', ls_saupj) 
		ls_steam = dw_ip.object.deptcode[1] 
//		ls_return = f_saupj_chk_t('2' , ls_steam ) 
//		if ls_return <> ls_saupj and ls_saupj <> '%' then 
//				dw_ip.setitem(1, 'deptcode', '')
//		End if 
	
END Choose

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string sIoCustName,sIoCustArea,sDept,siojpno,siocust,sIoDate,sInsDat
Long   nRow

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	Case "iojpno"
		gs_code = GetItemString(nRow,'custcode')
		gs_codename = 'A'
		gs_gubun = '005' 
		Open(w_imhist_02600_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SELECT DISTINCT SUBSTR("IMHIST"."IOJPNO",1,12),"IMHIST"."CVCOD", 
				"IMHIST"."IO_DATE", "IMHIST"."INSDAT"
	  	  INTO :sIoJpNo,  :sIoCust ,:sIoDate, :sInsDat
		  FROM "IMHIST"  
		 WHERE ( "IMHIST"."JNPCRT" = '005' ) AND ( "IMHIST"."IOJPNO" = :gs_code )   ;
		
		SetItem(1,"iojpno",sIoJpNo)
		SetItem(1,"sdate",sIoDate)
		
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
//		Open(w_vndmst_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//			SetItem(1,"deptcode",  sDept)
//			SetItem(1,"custname",  sIoCustName)
//			SetItem(1,"areacode",  sIoCustArea)
//		END IF
//	Case "custname"
//		gs_codename = Trim(GetText())
//		gs_gubun = '1'
//		Open(w_vndmst_popup)
//		
//		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//		
//		SetItem(1,"custcode",gs_code)
//		
//		SELECT "VNDMST"."CVNAS2",	"VNDMST"."SAREA",		"SAREA"."STEAMCD"
//		  INTO :sIoCustName,		:sIoCustArea,			:sDept
//		  FROM "VNDMST","SAREA" 
//		 WHERE "VNDMST"."SAREA" = "SAREA"."SAREA" AND "VNDMST"."CVCOD" = :gs_code;
//		IF SQLCA.SQLCODE = 0 THEN
//			SetItem(1,"deptcode",  sDept)
//			SetItem(1,"custname",  sIoCustName)
//			SetItem(1,"areacode",  sIoCustArea)
//		END IF
END Choose

end event

type dw_list from w_standard_print`dw_list within w_sal_02600
integer x = 78
integer y = 260
integer width = 4526
integer height = 2040
string dataobject = "d_sal_02600_02"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_sal_02600
integer x = 686
integer y = 124
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'edate', gs_code)

end event

type pb_2 from u_pb_cal within w_sal_02600
integer x = 686
integer y = 40
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdate', gs_code)
end event

type rr_1 from roundrectangle within w_sal_02600
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 69
integer y = 252
integer width = 4549
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

