$PBExportHeader$w_pdm_01625.srw
$PBExportComments$업체 근무일력 등록
forward
global type w_pdm_01625 from w_inherite
end type
type dw_detail from datawindow within w_pdm_01625
end type
type uo_1 from u_ddcal1 within w_pdm_01625
end type
end forward

global type w_pdm_01625 from w_inherite
string title = "모기업 근무일력 등록"
dw_detail dw_detail
uo_1 uo_1
end type
global w_pdm_01625 w_pdm_01625

on w_pdm_01625.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.uo_1
end on

on w_pdm_01625.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.uo_1)
end on

event open;call super::open;is_window_id = Message.StringParm	
is_today = f_today()
is_totime = f_totime()

dw_detail.settransobject(sqlca)
dw_detail.insertrow(0)

uo_1.init_cal(today())

string 	date_format
date_format = "yyyy/mm/dd"
uo_1.set_date_format ( date_format )
uo_1.fu_init_datawindow(dw_detail)

//dw_detail.retrieve(is_today)



end event

event closequery;call super::closequery;//string s_frday, s_frtime
//
//IF is_usegub = 'Y' THEN
//	s_frday = f_today()
//	
//	s_frtime = f_totime()
//
//   UPDATE "PGM_HISTORY"  
//      SET "EDATE" = :s_frday,   
//          "ETIME" = :s_frtime  
//    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
//          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
//          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
//          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;
//
//	IF SQLCA.SQLCODE = 0 THEN 
//	   COMMIT;
//   ELSE 	  
//	   ROLLBACK;
//   END IF	  
//END IF	  
//
end event

type dw_insert from w_inherite`dw_insert within w_pdm_01625
boolean visible = false
end type

type p_delrow from w_inherite`p_delrow within w_pdm_01625
boolean visible = false
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01625
boolean visible = false
end type

type p_search from w_inherite`p_search within w_pdm_01625
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_pdm_01625
boolean visible = false
end type

type p_exit from w_inherite`p_exit within w_pdm_01625
end type

type p_can from w_inherite`p_can within w_pdm_01625
boolean visible = false
end type

type p_print from w_inherite`p_print within w_pdm_01625
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_pdm_01625
boolean visible = false
end type

type p_del from w_inherite`p_del within w_pdm_01625
boolean visible = false
end type

type p_mod from w_inherite`p_mod within w_pdm_01625
integer x = 4265
end type

event p_mod::clicked;call super::clicked;String ls_bigo ,ls_cvcod ,ls_yymm 
Long   rtn ,ll_gd , ll_bgd ,ll_sum ,ll_maxdate ,ll_count

if dw_detail.accepttext() <> 1 then return -1
if uo_1.dw_2.accepttext() <> 1 then return -1
if uo_1.dw_date.accepttext() <> 1 then return -1

ls_cvcod = Trim(dw_detail.getitemstring(1,'cvcod'))
ls_yymm  = left(Trim(dw_detail.getitemstring(1,'vcl_date')),6)
ll_gd    = uo_1.dw_date.getitemnumber(1,'gd_date')
ll_bgd   = uo_1.dw_date.getitemnumber(1,'bgd_date')

if ls_cvcod = "" or isnull(ls_cvcod) then
	f_message_chk(30,'[업체]')
	return -1
end if

rtn = dw_detail.Update()

IF rtn = 1 AND SQLCA.SQLNRows > 0 THEN
		COMMIT USING SQLCA;
		sle_msg.text = '데이타를 저장 하였습니다.'

ELSE
		ROLLBACK USING SQLCA;
		sle_msg.text = '저장에 실패했습니다.'

END IF

// 업체 근무일력 등록 //
if ll_gd = 0 and ll_bgd = 0 then
	return 0
else
	ll_sum  = ll_gd + ll_bgd
   
	SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(:ls_yymm,'YYYY/MM')),'DD')) 
	INTO :ll_maxdate FROM DUAL ;
   
	if ll_maxdate <> ll_sum then
		messagebox('확인','입력하신 일자의 합이 해당월의 일수와 다릅니다.')
		return -1
	end if
	
	SELECT COUNT(*) INTO :ll_count FROM CUST_DATE 
	WHERE CVCOD = :ls_cvcod AND YYMM = :ls_yymm ;
	
	if ll_count < 1 then
		
		INSERT INTO CUST_DATE (CVCOD , YYMM , GD_DATE ,BGD_DATE)
		VALUES (:ls_cvcod , :ls_yymm , :ll_gd ,:ll_bgd);
		
		if sqlca.sqlcode <> 0 then
			messagebox('Error',Sqlca.SqlErrText)
			return -1
		end if
		
	else

		UPDATE CUST_DATE
		   SET GD_DATE = :ll_gd , BGD_DATE = :ll_bgd
		 WHERE CVCOD = :ls_cvcod AND YYMM = :ls_yymm ;
		 
       if sqlca.sqlcode <> 0 then
			messagebox('Error',Sqlca.SqlErrText)
			return -1
		end if 
   end if
	
	COMMIT ;
	
END IF
	

end event

type cb_exit from w_inherite`cb_exit within w_pdm_01625
boolean visible = false
integer x = 1559
integer y = 0
integer height = 68
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01625
boolean visible = false
integer x = 1413
integer y = 0
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01625
boolean visible = false
end type

type cb_del from w_inherite`cb_del within w_pdm_01625
boolean visible = false
integer x = 2373
integer y = 1512
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01625
boolean visible = false
integer x = 2368
integer y = 1300
end type

type cb_print from w_inherite`cb_print within w_pdm_01625
boolean visible = false
integer x = 1893
integer y = 1560
end type

type st_1 from w_inherite`st_1 within w_pdm_01625
end type

type cb_can from w_inherite`cb_can within w_pdm_01625
boolean visible = false
integer x = 2848
end type

event cb_can::clicked;call super::clicked;//SetPointer(HourGlass!)
//
//dw_detail.setredraw(false)
//
//dw_detail.Reset()
//
//uo_1.SetRedraw(FALSE)
//
//uo_1.init_cal(today())
//
//string 	date_format
//date_format = "yyyy/mm/dd"
//uo_1.set_date_format ( date_format )
//
//uo_1.fu_init_datawindow(dw_detail)
//
//
///*====================================================
//	 WINDOW  datawindow(dw_1) 에 현재일자 retrieve
//=====================================================*/
//string 	retrieve_format 
//
//retrieve_format = String( today(), "yyyymmdd" )
//
//dw_detail.retrieve( retrieve_format )
//
//uo_1.SetRedraw(true)
//dw_detail.setredraw(true)
//
//uo_2.visible = false
//
//if b_check1 = true then 
//	b_check1 = false
//	b_check3 = false
//end if
//
//if b_check2 = true then 
//	b_check2 = false
//	b_check4 = false
//end if
//
//st_4.text = ''	
end event

type cb_search from w_inherite`cb_search within w_pdm_01625
boolean visible = false
integer x = 2469
integer y = 1452
end type







type gb_button1 from w_inherite`gb_button1 within w_pdm_01625
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01625
end type

type dw_detail from datawindow within w_pdm_01625
integer x = 2103
integer y = 528
integer width = 1637
integer height = 1256
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01625_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String sCVcod, sBudo

Choose Case GetColumnName()
		
	Case 'budo'
		sBudo = GetText()
		
		sCvcod = GetItemString(1, 'cvcod')
		
		UPDATE VNDMST SET BUDO = :sBudo WHERE CVCOD = :scvcod;
		COMMIT;
		
End Choose
end event

type uo_1 from u_ddcal1 within w_pdm_01625
event destroy ( )
integer x = 215
integer y = 352
integer height = 1520
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call u_ddcal1::destroy
end on

