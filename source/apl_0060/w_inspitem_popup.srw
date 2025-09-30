$PBExportHeader$w_inspitem_popup.srw
$PBExportComments$** 품목코드 조회 선택(F1 KEY) 초중종물 기준 등록 품번
forward
global type w_inspitem_popup from w_inherite_popup
end type
type rr_2 from roundrectangle within w_inspitem_popup
end type
type rr_1 from roundrectangle within w_inspitem_popup
end type
end forward

global type w_inspitem_popup from w_inherite_popup
integer x = 357
integer y = 236
integer width = 4014
integer height = 1920
string title = "품목코드 조회(완료품번)"
rr_2 rr_2
rr_1 rr_1
end type
global w_inspitem_popup w_inspitem_popup

type variables
string is_itcls
str_itnct str_sitnct
end variables

on w_inspitem_popup.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_inspitem_popup.destroy
call super::destroy
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

dw_jogun.setitem(1, 'wkctr', gs_gubun)
//dw_jogun.setitem(1, 'ittyp', gs_gubun)

// 부가세 사업장 설정
f_mod_saupj(dw_jogun, 'porgu')

p_inq.TriggerEvent(Clicked!)

//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_jogun.SetItem(1, 'porgu', gs_code)
//   if gs_code <> '%' then
//   	dw_jogun.object.porgu.protect=1
//		dw_jogun.Object.porgu.background.color = rgb(240,244,247)
//   End if
//Else
//	dw_jogun.SetItem(1, 'porgu', gs_code)
//End If
end event

event closequery;call super::closequery;SetNull(gs_codename2)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_inspitem_popup
integer x = 0
integer y = 32
integer width = 2816
integer height = 256
string dataobject = "d_iteminsp_ittyp"
end type

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_name

setnull(snull)

Choose Case GetColumnName() 
	Case 'ittyp'
		s_name = this.gettext()
	 
		IF s_name = "" OR IsNull(s_name) THEN 
			RETURN
		END IF
		
		s_name = f_get_reffer('05', s_name)
		if isnull(s_name) or s_name="" then
			f_message_chk(33,'[품목구분]')
			this.SetItem(1,'ittyp', snull)
			return 1
		end if	
	Case 'itnbr', 'itdsc', 'ispec', 'itm_shtnm'
		p_inq.PostEvent(Clicked!)
END Choose
end event

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "itcls"
		OpenWithParm(w_ittyp_popup, GetItemString(GetRow(),"ittyp"))
		
		str_sitnct = Message.PowerObjectParm	
		
		IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
		
		SetItem(1,"itcls",str_sitnct.s_sumgub)		
		SetColumn('itnbr')
END Choose
end event

type p_exit from w_inherite_popup`p_exit within w_inspitem_popup
integer x = 3739
integer y = 68
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_inspitem_popup
integer x = 3392
integer y = 68
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String scode, sname, sspec, sgu, sitcls, sJijil, ls_porgu, sSht, ls_itgu, ls_wkctr
String sold_sql, swhere_clause, snew_sql

if dw_jogun.AcceptText() = -1 then return

sgu 		= dw_jogun.GetItemString(1,'ittyp')
ls_porgu = dw_jogun.GetItemString(1,'porgu')
sSht		= dw_jogun.GetItemString(1,'itm_shtnm')

//IF IsNull(sgu) THEN 
//	MessageBox('알림','품목구분을 선택하세요')
//	dw_jogun.SetColumn('ittyp')
//	dw_jogun.SetFocus()
//	return
//END IF	

scode  	= trim(dw_jogun.GetItemString(1,'itnbr'))
sspec  	= trim(dw_jogun.GetItemString(1,'ispec'))
sname  	= trim(dw_jogun.GetItemString(1,'itdsc'))
sitcls 	= trim(dw_jogun.GetItemString(1,'itcls'))
sJijil 	= trim(dw_jogun.GetItemString(1,'jijil'))
ls_itgu  = trim(dw_jogun.GetItemString(1,'itgu'))
ls_wkctr  = trim(dw_jogun.GetItemString(1,'wkctr'))

IF IsNull(scode)  	THEN scode  = ""
IF IsNull(sname)  	THEN sname  = ""
IF IsNull(sspec)  	THEN sspec  = ""
IF IsNull(sitcls) 	THEN sitcls = ""
IF IsNull(sJijil) 	THEN sJijil = ""
IF IsNull(sSht) 	   THEN sSht   = ""
If IsNull(ls_itgu) Then ls_itgu = ""
If IsNull(ls_wkctr) Then ls_wkctr = ""
If IsNull(sgu) Then sgu = ""

//if gs_saupj = '%' then
//	sold_sql = "SELECT A.ITNBR, A.ITDSC, A.ISPEC, A.JIJIL,A.ITCLS AS ITCLS, " + &
//							" B.TITNM, A.PDTGU, A.USEYN, A.FILSK, " + &
//							" FUN_GET_BOMCHK2(A.ITNBR, '1') AS EUSE_YN, " +&
//							" FUN_GET_BOMCHK2(A.ITNBR, '2') AS PUSE_YN, " +&
//							" A.GRITU , A.MDL_JIJIL,  " + &
//							" fun_get_itmsht('" + ls_porgu + "', A.ITNBR)," +&
//							" decode(A.ITTYP,'1',fun_get_carcode(A.ITNBR),'2',fun_get_carcode(A.ITNBR), " +&
//                         " 'A',fun_get_carcode(A.ITNBR),fun_get_cartype(A.ITNBR)) AS CARTYPE " +&							
//				  "  FROM ITEMAS A, ITNCT B," + &
//				  "       (SELECT ITNBR, SAUPJ, ITM_SHTNM FROM ITMSHT " + &
//				  "         WHERE SAUPJ = '" + ls_porgu + "'" + &
//				  "           AND ITM_SHTNM LIKE '" + sSht + "%') C  " +&
//				  " WHERE A.ITTYP = B.ITTYP (+) " + &
//					 " AND A.ITCLS = B.ITCLS (+) " + &
//					 " AND A.ITNBR = C.ITNBR(+) " + &
//					 " AND A.GBWAN = 'Y' "         + &
//					 " AND (( B.PORGU LIKE '" + ls_porgu + "%' ) OR ( B.PORGU = 'ALL' ))"
//
//					 
//   dw_1.dataobject = 'd_itemas_popup'					 
//	dw_1.SetTransObject(sqlca)
//else
//	sold_sql = "  SELECT A.ITNBR, A.ITDSC, A.ISPEC, A.JIJIL, A.ITCLS AS ITCLS," + &  
//							" B.TITNM, A.PDTGU, A.USEYN, A.FILSK, " + &  
//							" FUN_GET_BOMCHK2(A.ITNBR, '1') AS EUSE_YN, " +&
//							" FUN_GET_BOMCHK2(A.ITNBR, '2') AS PUSE_YN, " +&
//							" A.GRITU , A.MDL_JIJIL,  "  + &
//							" C.CVCOD, " + &
//							" FUN_GET_CVNAS(C.CVCOD)   CVNAS, " + &
//							" C.BUNBR,  C.BUDSC, " + &
//							" D.ITM_SHTNM," +&
//							" decode(A.ITTYP,'1',fun_get_carcode(A.ITNBR),'2',fun_get_carcode(A.ITNBR), " +&
//                         " 'A',fun_get_carcode(A.ITNBR),fun_get_cartype(A.ITNBR)) AS CARTYPE, " +&							
//						   " CASE WHEN NVL(E.CNT, 0) > 0 THEN 'Y' ELSE 'N' END AS CNT " + &
//				  "  FROM ITEMAS A, ITNCT B, ITMBUY C, " + &
//				  "      (SELECT ITNBR, SAUPJ, ITM_SHTNM FROM ITMSHT " + &
//				  "        WHERE SAUPJ = '" + ls_porgu + "'" + &
//				  "          AND ITM_SHTNM LIKE '" + sSht + "%' ) D, " + & 
//				  "       (  SELECT ITNBR, COUNT('X') AS CNT " + &
//				  "			   FROM ROUTNG " + &
//				  "		  GROUP BY ITNBR ) E " + &
//				  " WHERE A.ITTYP = B.ITTYP (+) " + &
//					 " AND A.ITCLS = B.ITCLS (+) " + &
//					 " AND A.ITNBR = C.ITNBR (+) " + &
//					 " AND A.ITNBR = D.ITNBR (+) " + &
//					 " AND A.ITNBR = E.ITNBR (+) " + &
//					 " AND A.GBWAN = 'Y' "         + &
//					 " AND (( B.PORGU LIKE '" + ls_porgu + "%' ) OR ( B.PORGU = 'ALL' ))"
//
//	dw_1.dataobject = 'd_itemas_popup_2'					 				 
//	dw_1.SetTransObject(sqlca)
//end if

sold_sql = dw_1.GetSqlSelect()

swhere_clause = ' '

//IF 	sgu <> ""  THEN
   	swhere_clause = 	swhere_clause + " AND A.ITTYP LIKE '"		+sgu+"%'"
//END IF
IF 	scode <> "" THEN
	scode = '%' + scode +'%'
	swhere_clause = 	swhere_clause + " AND A.ITNBR LIKE '"	+scode		+"'"
END IF
IF sname <> "" THEN
	sname ='%' + sname +'%'
	swhere_clause = 	swhere_clause + " AND A.ITDSC LIKE '"	+sname		+"'"
END IF
IF 	sspec <> "" THEN
	sspec = '%' + sspec +'%'
	swhere_clause = 	swhere_clause + " AND A.ISPEC LIKE '"	+sspec		+"'"
END IF
IF 	sitcls <> "" THEN
	sitcls = '%' + sitcls +'%'
	swhere_clause = 	swhere_clause + " AND A.ITCLS LIKE '"	+sitcls		+"'"
END IF
IF 	sJijil <> "" THEN
	sJijil = '%' + sJijil +'%'
	swhere_clause = 	swhere_clause + " AND A.JIJIL LIKE '"	+sJijil		+"'"
END IF

if sSht <> "" And Not Isnull(sSht) then
	sSht = '%' + sSht +'%'
	swhere_clause = 	swhere_clause + " AND D.ITM_SHTNM LIKE '"	+sSht		+"'"
end if

if gs_codename2 <> "" And Not Isnull(gs_codename2) then
	swhere_clause = 	swhere_clause + " AND (C.CVCOD IS NULL OR NVL(C.CVCOD,'.') LIKE '%"	+gs_codename2	+"%')"
end if

If ls_itgu <> "" Then
	swhere_clause = swhere_clause + " AND A.ITGU LIKE '" + ls_itgu + "'"
End If

If ls_wkctr <> "" Then
	swhere_clause = swhere_clause + " AND D.WKCTR LIKE '" + ls_wkctr + "%'"
End If


snew_sql = sold_sql + swhere_clause
dw_1.SetSqlSelect(snew_sql)


dw_1.Retrieve()


dw_1.SetSqlSelect(sold_sql)

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_inspitem_popup
integer x = 3566
integer y = 68
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

//IF dw_1.GetItemString(ll_Row, "itemas_useyn") = '1' then
//	f_message_chk(53, "[품번]")
//	Return 
IF dw_1.GetItemString(ll_Row, "itemas_useyn") = '2' then
	f_message_chk(54, "[품번]")
	Return 
END IF

gs_code = dw_1.GetItemString(ll_Row, "itemas_itnbr")
gs_codename = dw_1.GetItemString(ll_row,"itemas_itdsc")
gs_gubun = dw_1.GetItemString(ll_row,"itemas_ispec")
gs_codename2 = dw_1.GetItemString(ll_row,"itemas_jijil")
gs_codename3 = dw_1.GetItemString(ll_row,"itnct_pdtgu")


Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_inspitem_popup
integer x = 27
integer y = 292
integer width = 3515
integer height = 1512
integer taborder = 100
string dataobject = "d_iteminsp_popup"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

//IF dw_1.GetItemString(Row, "itemas_useyn") = '1' then
//	f_message_chk(53, "[품번]")
//	Return 
IF dw_1.GetItemString(Row, "itemas_useyn") = '2' then
	f_message_chk(54, "[품번]")
	Return 
END IF

gs_code= dw_1.GetItemString(Row, "itemas_itnbr")
gs_codename= dw_1.GetItemString(row,"itemas_itdsc")
gs_gubun= dw_1.GetItemString(row,"itemas_ispec")
gs_codename2 = dw_1.GetItemString(row,"itemas_jijil")
gs_codename3 = dw_1.GetItemString(row,"itnct_pdtgu")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_inspitem_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_inspitem_popup
end type

type cb_return from w_inherite_popup`cb_return within w_inspitem_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_inspitem_popup
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_inspitem_popup
end type

type st_1 from w_inherite_popup`st_1 within w_inspitem_popup
end type

type rr_2 from roundrectangle within w_inspitem_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 288
integer width = 3959
integer height = 1536
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_inspitem_popup
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 3328
integer y = 44
integer width = 640
integer height = 200
integer cornerheight = 40
integer cornerwidth = 55
end type

