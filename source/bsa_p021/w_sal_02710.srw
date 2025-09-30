$PBExportHeader$w_sal_02710.srw
$PBExportComments$공사수주대장
forward
global type w_sal_02710 from w_standard_print
end type
end forward

global type w_sal_02710 from w_standard_print
string title = "공사수주대장"
end type
global w_sal_02710 w_sal_02710

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_saupj, ls_sdate, ls_edate, ls_cvcod ,tx_name

if dw_ip.accepttext() <> 1 then return -1 

ls_saupj  =  Trim(dw_ip.getitemstring(1,'saupj'))
ls_sdate  =  Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate  =  Trim(dw_ip.getitemstring(1,'edate'))
ls_cvcod  =  Trim(dw_ip.getitemstring(1,'cvcod'))

if ls_sdate = "" or isnull(ls_sdate) then
	f_message_chk(1400,'[수주기간 FROM]')
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	Return -1
elseif ls_edate = "" or isnull(ls_edate) then
	f_message_chk(1400,'[수주기간 TO]')
	dw_ip.setcolumn('edate')
	dw_ip.setfocus()
	Return -1
END IF

if ls_cvcod = "" or isnull(ls_cvcod) then ls_cvcod= '%'

if ls_saupj = "" or isnull(ls_saupj) then ls_saupj = '%'

if dw_list.retrieve(gs_sabu, ls_saupj, ls_sdate, ls_edate, ls_cvcod + '%') <= 0	then
	f_message_chk(50,"")
	dw_ip.setcolumn('saupj')
	dw_ip.setfocus()
	Return -1
End if

tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(saupj) ', 1)"))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_saupj.text = '"+tx_name+"'")

tx_name = Trim(dw_ip.GetitemString(1,'cvcodnm'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_list.Modify("tx_cvcodnm.text = '"+tx_name+"'")

return 1
end function

on w_sal_02710.create
call super::create
end on

on w_sal_02710.destroy
call super::destroy
end on

event open;call super::open;dw_ip.setitem(1,'sdate',left(f_today(),6) + '01')
dw_ip.setitem(1,'edate',left(f_today(),8))

/* User별 관할구역 Setting */
String sarea, steam , saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'saupj', saupj)
End If

sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_02710
end type

type p_exit from w_standard_print`p_exit within w_sal_02710
end type

type p_print from w_standard_print`p_print within w_sal_02710
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_02710
end type







type st_10 from w_standard_print`st_10 within w_sal_02710
end type



type dw_print from w_standard_print`dw_print within w_sal_02710
end type

type dw_ip from w_standard_print`dw_ip within w_sal_02710
integer x = 46
integer y = 44
integer height = 1036
string dataobject = "d_sal_02710"
end type

event dw_ip::itemchanged;call super::itemchanged;String  snull ,ls_text ,ls_cvcod ,ls_cvcodnm ,ls_gubun , sCvcod, scvnas, sarea, steam, sSaupj, sName1

SetNull(snull)

Choose Case GetColumnName() 
  Case "sdate"
	ls_text = Trim(this.GetText())
	IF ls_text ="" OR IsNull(ls_text) THEN RETURN
	
	IF f_datechk(ls_text) = -1 THEN
		f_message_chk(35,'[기준일자]')
		this.SetItem(1,"sdate",snull)
		Return 1
	END IF
  Case "edate"
	ls_text = Trim(this.GetText())
	IF ls_text ="" OR IsNull(ls_text) THEN RETURN
	
	IF f_datechk(ls_text) = -1 THEN
		f_message_chk(35,'[기준일자]')
		this.SetItem(1,"edate",snull)
		Return 1
	END IF 
 Case "gubun" 
	   ls_gubun = this.gettext()
		
		dw_list.setredraw(false)
		if ls_gubun ='1' then
			dw_list.dataobject = 'd_sal_02710_1'
		else
			dw_list.dataobject = 'd_sal_02710_2'
		end if
		dw_list.settransobject(sqlca)
		dw_list.setredraw(true)
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvcodnm",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvcodnm', snull)
			Return 1
		ELSE		
			SetItem(1,"cvcodnm", scvnas)
			
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
			SetItem(1,'cvcod', sCvcod)
			SetItem(1,"cvcodnm", scvnas)
			
			Return 1
		END IF
//	/* 거래처 */
//	Case "cvcod"
//		ls_cvcod = this.GetText()
//		IF ls_cvcod ="" OR IsNull(ls_cvcod) THEN
//			this.SetItem(1,"cvcodnm",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVNAS2"
//		  INTO :ls_cvcodnm
//		  FROM "VNDMST" 
//		 WHERE "VNDMST"."CVCOD" = :ls_cvcod   ;
//		IF SQLCA.SQLCODE <> 0 THEN
//			this.TriggerEvent(RbuttonDown!)
//			Return 2
//		ELSE
//			this.SetItem(1,"cvcodnm",  ls_cvcodnm)
//			
//		END IF
//	/* 거래처명 */
//	Case "cvcodnm"
//		ls_cvcodnm = Trim(GetText())
//		IF ls_cvcodnm ="" OR IsNull(ls_cvcodnm) THEN
//			this.SetItem(1,"cvcod",snull)
//			Return
//		END IF
//		
//		SELECT "VNDMST"."CVCOD","VNDMST"."CVNAS2"
//		  INTO :ls_cvcod ,:ls_cvcodnm
//		  FROM "VNDMST" 
//		 WHERE  "VNDMST"."CVNAS2" = :ls_cvcodnm;
//		IF SQLCA.SQLCODE <> 0 THEN
//			this.TriggerEvent(RbuttonDown!)
//			Return 2
//		ELSE
//			SetItem(1,"cvcod",  ls_cvcod)
//			SetItem(1,"cvcodnm",  ls_cvcodnm)
//			Return
//		END IF
END Choose

end event

event dw_ip::rbuttondown;call super::rbuttondown;string sIoCustName,sIoCustArea,sDept

SetNull(Gs_Gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case this.GetColumnName() 
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
// Case "cvcod"
//	gs_gubun = '1'
//	Open(w_agent_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"cvcod",gs_code)
//	
//	SELECT "VNDMST"."CVNAS2","VNDMST"."CVCOD"
//		INTO :sIoCustName,					:sDept
//	   FROM "VNDMST" 
//   	WHERE  "VNDMST"."CVCOD" = :gs_code;
//	IF SQLCA.SQLCODE = 0 THEN
//	  this.SetItem(1,"cvcod",  sDept)
//	  this.SetItem(1,"cvcodnm",  sIoCustName)
//	 
//	END IF
///* 거래처명 */
// Case "cvcodnm"
//	gs_gubun = '1'
//	gs_codename = Trim(GetText())
//	Open(w_agent_popup)
//	
//	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
//	
//	this.SetItem(1,"cvcod",gs_code)
//	this.SetItem(1,"cvcodnm",gs_codename)
//	
//	SELECT "VNDMST"."CVNAS2",		"SAREA"."STEAMCD"
//		INTO :sIoCustName,	:sDept
//	   FROM "VNDMST" 
//   	WHERE  "VNDMST"."CVCOD" = :gs_code;
//	IF SQLCA.SQLCODE = 0 THEN
//	  this.SetItem(1,"cvcod",  sDept)
//	  this.SetItem(1,"cvcodnm",  sIoCustName)
//	  
//	END IF
END Choose

end event

event dw_ip::dberror;call super::dberror;return 1
end event

event dw_ip::error;call super::error;return
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_02710
integer x = 818
string dataobject = "d_sal_02710_1"
end type

