$PBExportHeader$w_sm40_0010_pop1.srw
$PBExportComments$랩도스 추가
forward
global type w_sm40_0010_pop1 from w_inherite_popup
end type
type dw_2 from datawindow within w_sm40_0010_pop1
end type
end forward

global type w_sm40_0010_pop1 from w_inherite_popup
integer x = 357
integer y = 236
integer width = 3511
integer height = 1128
string title = "HKMC 랩도스 추가"
boolean controlmenu = true
dw_2 dw_2
end type
global w_sm40_0010_pop1 w_sm40_0010_pop1

type variables
string is_itcls

str_code ist_code
end variables

forward prototypes
public function integer wf_junpyo_closing (string syymm)
end prototypes

public function integer wf_junpyo_closing (string syymm);///* 매출 마감여부                  */
///* Return : 0(마감전), > 0 (마감) */
//Long nCnt
//
//  SELECT count("JUNPYO_CLOSING"."JPDAT"  )
//    INTO :nCnt
//    FROM "JUNPYO_CLOSING"  
//   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
//         ( "JUNPYO_CLOSING"."JPGU" = 'G0' ) AND  
//         ( "JUNPYO_CLOSING"."JPDAT" = :sYYmm )   ;
//
//If nCnt > 0 Then
//	f_message_chk(60,'[매출월마감]')
//	Return nCnt
//End If
//
Return 0
//
end function

on w_sm40_0010_pop1.create
int iCurrent
call super::create
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
end on

on w_sm40_0010_pop1.destroy
call super::destroy
destroy(this.dw_2)
end on

event open;call super::open;dw_2.SetTransObject(SQLCA)

f_window_center_response(this) 

dw_2.insertRow(0)

SETNULL(GS_CODE)
end event

event key;//call super::key;choose case key
//	case keypageup!
//		dw_1.scrollpriorpage()
//	case keypagedown!
//		dw_1.scrollnextpage()
//	case keyhome!
//		dw_1.scrolltorow(1)
//	case keyend!
//		dw_1.scrolltorow(dw_1.rowcount())
//end choose
//
//If keyDown(keyQ!) And keyDown(keyAlt!) Then
//	p_inq.TriggerEvent(Clicked!)
//End If
//
//If keyDown(keyV!) And keyDown(keyAlt!) Then
//	p_choose.TriggerEvent(Clicked!)
//End If
//
//If keyDown(keyC!) And keyDown(keyAlt!) Then
//	p_exit.TriggerEvent(Clicked!)
//End If
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_sm40_0010_pop1
boolean visible = false
integer x = 23
integer y = 148
integer width = 3401
integer height = 832
integer taborder = 0
string dataobject = "d_sm40_0010_pop1"
end type

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

event dw_jogun::itemchanged;call super::itemchanged;String sNull, sDate
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(sNull)

Choose Case GetColumnName()
	Case "yymmdd"  , "arrymd"
		sDate = Trim(GetText())
		if f_DateChk(sDate) = -1 then
			f_Message_Chk(35, '[일자]')
			SetItem(1,GetColumnName(),sNull)
			return 1
		end if
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			
			SetItem(1,"cvnas",	scvnas)
		END IF
End Choose

end event

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod"
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

event dw_jogun::ue_key;//Parent.event key(key, keyflags)
end event

type p_exit from w_inherite_popup`p_exit within w_sm40_0010_pop1
integer x = 3141
integer y = 0
integer taborder = 30
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_sm40_0010_pop1
boolean visible = false
integer x = 1001
integer y = 8
integer taborder = 10
boolean originalsize = false
string picturename = "C:\erpman\image\처리_up.gif"
end type

type p_choose from w_inherite_popup`p_choose within w_sm40_0010_pop1
integer x = 2967
integer y = 0
integer taborder = 20
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_choose::ue_lbuttondown;//
PictureName = 'C:\erpman\image\저장_dn.gif'
end event

event p_choose::ue_lbuttonup;PictureName = 'C:\erpman\image\저장_up.gif'
end event

event p_choose::clicked;call super::clicked;string	ls_saupj, ls_itnbr, ls_ncar, ls_custcd, ls_ymd, ls_plant, ls_factory
string	ls_newits, ls_cvcod, ls_btime, ls_arrymd, ls_arrtime, ls_orderno
long		ll_cnt, ll_seq, ll_ordqty, ll_napqty, ll_jpno


If dw_2.AcceptText() <> 1 Then Return -1

//ls_saupj = Trim(dw_2.Object.saupj[1]) 

if dw_2.Object.is_new[1] = 'N' then return

//-------------------------------------------------------------------------------------------------
// 01-자료 유효성 체크
ls_ymd = dw_2.Object.yymmdd[1]
if f_datechk(ls_ymd) = -1 then
	messagebox('확인','발행일자가 잘못지정되었습니다!!!')
	dw_2.setcolumn('yymmdd')
	dw_2.setfocus()
	return 
end if

ls_btime	= dw_2.Object.btime[1]
if f_timechk(ls_btime) = -1 then
	messagebox('확인','시간이 잘못지정되었습니다!!!')
	dw_2.setcolumn('btime')
	dw_2.setfocus()
	return 
end if

ls_ncar = trim(dw_2.Object.ncarno[1])
if ls_ncar = '' or isnull(ls_ncar) then
	messagebox('확인','차량번호를 지정하십시오!!!')
	dw_2.setcolumn('ncarno')
	dw_2.setfocus()
	return 
end if

ls_custcd = dw_2.Object.custcd[1]
if ls_custcd = '' or isnull(ls_custcd) then
	messagebox('확인','업체코드를 지정하십시오!!!')
	dw_2.setcolumn('custcd')
	dw_2.setfocus()
	return 
end if

ls_factory = dw_2.Object.factory[1]
if ls_factory = '' or isnull(ls_factory) then
	messagebox('확인','업체코드를 지정하십시오!!!')
	dw_2.setcolumn('factory')
	dw_2.setfocus()
	return
end if

ls_newits = dw_2.Object.newits[1]
if ls_newits = '' or isnull(ls_newits) then
	messagebox('확인','하치장코드를 지정하십시오!!!')
	dw_2.setcolumn('newits')
	dw_2.setfocus()
	return
end if

ls_itnbr = dw_2.Object.itnbr[1]
select count(*) into :ll_cnt from itemas where itnbr = :ls_itnbr ;
if ll_cnt = 0 then
	messagebox('확인','등록된 품번이 아닙니다!!!')
	dw_2.setcolumn('itnbr')
	dw_2.setfocus()
	return
end if
	
ls_orderno = dw_2.Object.orderno[1]
if ls_orderno = '' or isnull(ls_orderno) then
else
    select count(*) into :ll_cnt from van_hkcd68 where orderno = :ls_orderno ;
	 if ll_cnt = 0 then
		select count(*) into :ll_cnt from van_gingub where orderno = :ls_orderno ;
		if ll_cnt = 0 then
			messagebox('확인','등록된 발주번호가 아닙니다!!!')
			dw_2.setcolumn('orderno')
			dw_2.setfocus()
			return
		end if
	end if
end if			

ll_seq = dw_2.Object.oseq[1]
if isnull(ll_seq) then
	messagebox('확인','SEQ를 지정하십시오!!!')
	dw_2.setcolumn('oseq')
	dw_2.setfocus()
	return
end if

ll_ordqty = dw_2.Object.ordqty[1]
if isnull(ll_ordqty) then
	messagebox('확인','발주수량을 지정하십시오!!!')
	dw_2.setcolumn('ordqty')
	dw_2.setfocus()
	return
end if

ll_napqty = dw_2.Object.napqty[1]
if isnull(ll_napqty) then
	messagebox('확인','납품수량을 지정하십시오!!!')
	dw_2.setcolumn('napqty')
	dw_2.setfocus()
	return
end if

dw_2.Object.yebid1[1] = ll_napqty  

ls_arrymd = dw_2.Object.arrymd[1]
if f_datechk(ls_arrymd) = -1 then
	messagebox('확인','도착일자가 잘못지정되었습니다!!!')
	dw_2.setcolumn('arrymd')
	dw_2.setfocus()
	return 
end if

ls_arrtime = dw_2.Object.arrtime[1]
if f_timechk(ls_arrtime) = -1 then
	messagebox('확인','시간이 잘못지정되었습니다!!!')
	dw_2.setcolumn('arrtime')
	dw_2.setfocus()
	return 
end if

//dw_2.Object.seogu[ll_r]       = Trim(uo_xl.uf_gettext(ll_xl_row,14))   
Select count(*) Into :ll_cnt From reffpf 
 Where rfcod = '2U'
	and rfgub = substr(:ls_orderno , -1 , 1 )
	and rfna3 = 'Y' ;
If ll_cnt = 0 Then
	dw_2.Object.seogu[1] = 'Y' 
else
	dw_2.Object.seogu[1] = 'N'
end If 

//dw_2.Object.pilotgu[1] = 

ls_cvcod = dw_2.Object.cvcod[1]
select count(*) into :ll_cnt from vndmst where cvcod = :ls_cvcod ;
if ll_cnt = 0 then
	messagebox('확인','등록된 거래처코드가 아닙니다!!!')
	dw_2.setcolumn('cvcod')
	dw_2.setfocus()
	return
end if
		
dw_2.Object.yebis2[1] = 'HK'



//-------------------------------------------------------------------------------------------------
// 02-중복자료 확인-추가발행하는 자료는 중복인 경우가 많음 - 서선주 주임 - 2006.11.22
//Select Count(*) Into :ll_c
//  From SM04_DAILY_ITEM_SALE
//  Where saupj = :gs_saupj
//	 and yymmdd = :ls_ymd
//	 and btime = :ls_btime
//	 and factory = :ls_factory
//	 and itnbr = :ls_itnbr
//	 and orderno = :ls_orderno ;
//	 
//If ll_c > 0 Or sqlca.sqlcode <> 0 Then
//	MessageBox('확인','해당 날짜에 이미 등록된 품번입니다.')
//	w_mdi_frame.sle_msg.text ='해당 날짜에 이미 등록된 품번입니다.'
//	uo_xl.uf_excel_Disconnect()
//	uo_xltemp.uf_excel_Disconnect()
//	Return -1
//End If

				 
Setpointer(Hourglass!)	

//-------------------------------------------------------------------------------------------------
// 03-전표 채번
/*송장번호 채번*/
ll_seq = sqlca.fun_junpyo(gs_sabu,ls_ymd,'C0')
IF ll_seq <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return -1
END IF
Commit;
ll_jpno = 1

dw_2.Object.iojpno[1] = ls_ymd + String(ll_seq,'0000')+String(ll_jpno,'000')
dw_2.Object.saupj[1] = gs_saupj



//-------------------------------------------------------------------------------------------------
// 04-자료저장
dw_2.AcceptText()
If dw_2.Update() < 1 Then
	Rollback;
	MessageBox('확인','저장실패')
	Return
Else
	Commit;
End if

dw_2.Object.is_new[1] = 'N'


messagebox('확인','자료저장이 완료되었습니다!!!')
gs_code = 'OK'
close(parent)
end event

type dw_1 from w_inherite_popup`dw_1 within w_sm40_0010_pop1
boolean visible = false
integer x = 2240
integer y = 4
integer width = 174
integer height = 108
string dataobject = "d_sm40_0010_pop1"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::clicked;//
end event

type sle_2 from w_inherite_popup`sle_2 within w_sm40_0010_pop1
end type

type cb_1 from w_inherite_popup`cb_1 within w_sm40_0010_pop1
end type

type cb_return from w_inherite_popup`cb_return within w_sm40_0010_pop1
end type

type cb_inq from w_inherite_popup`cb_inq within w_sm40_0010_pop1
end type

type sle_1 from w_inherite_popup`sle_1 within w_sm40_0010_pop1
end type

type st_1 from w_inherite_popup`st_1 within w_sm40_0010_pop1
end type

type dw_2 from datawindow within w_sm40_0010_pop1
integer x = 37
integer y = 148
integer width = 3401
integer height = 832
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm40_0010_pop1"
boolean border = false
end type

event itemchanged;String sNull, sDate
String sarea, steam, sCvcod, scvnas, sSaupj, sName1

SetNull(sNull)

Choose Case GetColumnName()
	Case "yymmdd"  , "arrymd"
		sDate = Trim(GetText())
		if f_DateChk(sDate) = -1 then
			f_Message_Chk(35, '[일자]')
			SetItem(1,GetColumnName(),sNull)
			return 1
		end if
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'cvcod', sNull)
			SetItem(1, 'cvnas', snull)
			Return 1
		ELSE		
			
			SetItem(1,"cvnas",	scvnas)
		END IF
End Choose

end event

event itemerror;RETURN 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 거래처 */
	Case "cvcod"
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
End Choose
end event

