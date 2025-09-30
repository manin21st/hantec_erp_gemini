$PBExportHeader$w_sal_05910.srw
$PBExportComments$영업팀별 무상공급 현황(출고구분별)
forward
global type w_sal_05910 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_05910
end type
end forward

global type w_sal_05910 from w_standard_print
string title = "무상출고 현황"
rr_1 rr_1
end type
global w_sal_05910 w_sal_05910

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string	syear1,syear2, sCvcod, sPrtgbn, tx_name,ls_gubun, sgbn, srate
decimal  drate

//////////////////////////////////////////////////////////////////
If dw_ip.accepttext() <> 1 Then Return -1

syear1  = dw_ip.GetItemString(1,'syymm1')
syear2  = dw_ip.GetItemString(1,'syymm2')
//sPrtgbn = dw_ip.GetItemString(1,'prtgbn')
sCvcod   = dw_ip.GetItemString(1,'cvcod')
ls_gubun  = dw_ip.Getitemstring(1,'gubun')

If IsNull(sCvcod) Then sCvcod = ''

IF	f_datechk(syear1+'01') <> 1 then
	f_message_chk(1400,'[출고기간]')
	dw_ip.setcolumn('syymm1')
	dw_ip.setfocus()
	Return -1
END IF

IF	f_datechk(syear2+'01') <> 1 then
	f_message_chk(1400,'[출고기간]')
	dw_ip.setcolumn('syymm2')
	dw_ip.setfocus()
	Return -1
END IF

////////////////////////////////////////////////////////////////

if ls_gubun = '1' or ls_gubun = '2' then
	if dw_print.retrieve(gs_saupj, syear1, syear2, sCvcod+'%') <= 0	then
		f_message_chk(50,"")
		dw_ip.setcolumn('syymm1')
		dw_ip.setfocus()
		dw_print.InsertRow(0)
//		return -1
else
	dw_print.sharedata(dw_list)
	end if
Else
	
	/* 평가기준 검색 */
	select dataname
	  into :sgbn
	  from syscnfg
	 where sysgu = 'S' and serial = 8 and lineno = '30';
	 
	If isNull(sgbn) or Trim(sgbn) = '' then
		sgbn = '3'
	End if
	
	select dataname
	  into :srate
	  from syscnfg
	 where sysgu = 'S' and serial = 8 and lineno = '31';
	 
	If isNull(srate) or Trim(srate) = '' then
		srate = '0'
	End if	
	drate = dec(srate)
	
	if dw_print.retrieve(gs_saupj, syear1, syear2, sgbn, drate) <= 0	then
		f_message_chk(50,"")
		dw_ip.setcolumn('syymm1')
		dw_ip.setfocus()
		dw_print.InsertRow(0)
//		return -1
	else
		dw_print.sharedata(dw_list)
	end if	
End if

tx_name = Trim(dw_ip.GetItemString(1,'cvnas'))
If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
dw_print.Modify("tx_cvcod.text = '"+tx_name+"'")

Return 1

end function

on w_sal_05910.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_05910.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;string syear,ls_year

syear = Left(f_today(),4)
ls_year = Left(f_today(),6)
dw_ip.SetItem(1,'syymm1',syear+'01')
dw_ip.SetItem(1,'syymm2',ls_year)


end event

type p_preview from w_standard_print`p_preview within w_sal_05910
string picturename = "C:\ERPMAN\image\미리보기_d.gif"
end type

type p_exit from w_standard_print`p_exit within w_sal_05910
string picturename = "C:\ERPMAN\image\닫기_up.gif"
end type

type p_print from w_standard_print`p_print within w_sal_05910
string picturename = "C:\ERPMAN\image\인쇄_d.gif"
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_05910
string picturename = "C:\ERPMAN\image\조회_up.gif"
end type







type st_10 from w_standard_print`st_10 within w_sal_05910
end type



type dw_print from w_standard_print`dw_print within w_sal_05910
string dataobject = "d_sal_05910_10_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_05910
integer x = 37
integer y = 24
integer width = 3634
integer height = 168
string dataobject = "d_sal_05910_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String sOrderCust, sNull, sOrderCustName

SetNull(sNull)

Choose Case GetColumnName()
	Case 'gubun'
		dw_list.SetRedraw(False)
		If GetText() = '1' Then
			dw_list.DataObject = 'd_sal_05910_10'
			dw_print.DataObject = 'd_sal_05910_10_p'
		Elseif gettext() = '2' then
			dw_list.DataObject = 'd_sal_05910_30'
			dw_print.DataObject = 'd_sal_05910_30_p'
		Else
			dw_list.dataobject = 'd_sal_05905'
			dw_print.DataObject = 'd_sal_05905_p'
		End If
		dw_print.SetTransObject(sqlca)
		dw_list.SetTransObject(sqlca)
		dw_list.SetRedraw(True)
	/* 의뢰부서 */
	Case "cvcod"
		sOrderCust = GetText()
		IF sOrderCust ="" OR IsNull(sOrderCust) THEN
			SetItem(1,"cvnas",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVNAS2"
		  INTO :sOrderCustName
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVCOD" = :sOrderCust AND "VNDMST"."CVGU" ='4'   ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			PostEvent(RbuttonDown!)
			Return 2
		ELSE
			SetItem(1,"cvnas",sOrderCustName)
		END IF
	/* 의뢰부서명 */
	Case "cvnas"
		sOrderCustName = GetText()
		IF sOrderCustName ="" OR IsNull(sOrderCustName) THEN
			SetItem(1,"cvcod",snull)
			Return
		END IF
		
		SELECT "VNDMST"."CVCOD"
		  INTO :sOrderCust
		  FROM "VNDMST"  
		 WHERE "VNDMST"."CVNAS2" = :sOrderCustName AND "VNDMST"."CVGU" ='4'  ;
		IF SQLCA.SQLCODE <> 0 THEN
			TriggerEvent(RbuttonDown!)
			IF gs_code ="" OR IsNull(gs_code) THEN
				SetItem(1,"cvcod",snull)
				SetItem(1,"cvnas",snull)
				Return 2
			END IF
		ELSE
			SetItem(1,"cvcod",sOrderCust)
		END IF
End Choose
end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(Gs_Code)
SetNull(Gs_CodeName)

Choose Case GetColumnName()
	/* 반품의뢰부서 */
   Case "cvcod"
	  Open(w_vndmst_4_popup)
	  IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	  SetItem(1,"cvcod",gs_code)
	  SetItem(1,"cvnas",gs_codename)
   Case "cvnas"
	  Open(w_vndmst_4_popup)
	  IF gs_codename ="" OR IsNull(gs_codename) THEN RETURN

	  SetItem(1,"cvcod",gs_code)	
	  SetItem(1,"cvnas",gs_codename)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sal_05910
integer x = 46
integer y = 204
integer width = 4544
integer height = 2112
string title = "무상출고현황"
string dataobject = "d_sal_05910_10"
boolean border = false
end type

event dw_list::retrievestart;This.SetRedraw(False)
end event

event dw_list::retrieveend;This.SetRedraw(True)
end event

type rr_1 from roundrectangle within w_sal_05910
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 196
integer width = 4558
integer height = 2128
integer cornerheight = 40
integer cornerwidth = 55
end type

