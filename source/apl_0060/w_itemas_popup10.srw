$PBExportHeader$w_itemas_popup10.srw
$PBExportComments$** 품목코드 조회 선택 완료처리된 품목(약호)
forward
global type w_itemas_popup10 from w_inherite_popup
end type
type rr_2 from roundrectangle within w_itemas_popup10
end type
end forward

global type w_itemas_popup10 from w_inherite_popup
integer x = 357
integer y = 236
integer width = 3666
integer height = 1920
string title = "품목코드 조회(완료품번)"
rr_2 rr_2
end type
global w_itemas_popup10 w_itemas_popup10

type variables
string is_itcls
end variables

on w_itemas_popup10.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_itemas_popup10.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

dw_jogun.setitem(1, 'ittyp', gs_gubun)

// 부가세 사업장 설정
f_mod_saupj(dw_jogun, 'porgu')


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

type dw_jogun from w_inherite_popup`dw_jogun within w_itemas_popup10
integer x = 0
integer y = 32
integer width = 2807
integer height = 400
string dataobject = "d_itemas_ittyp"
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

type p_exit from w_inherite_popup`p_exit within w_itemas_popup10
integer x = 3465
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itemas_popup10
integer x = 3118
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String scode, sname, sspec, sgu, sitcls, sJijil, ls_porgu, sSht, ls_itgu
String sold_sql, swhere_clause, snew_sql

if dw_jogun.AcceptText() = -1 then return

sgu 		= dw_jogun.GetItemString(1,'ittyp')
ls_porgu = dw_jogun.GetItemString(1,'porgu')
sSht		= dw_jogun.GetItemString(1,'itm_shtnm')

IF IsNull(sgu) or sgu = '' THEN 
	MessageBox('알림','품목구분을 선택하세요')
	dw_jogun.SetColumn('ittyp')
	dw_jogun.SetFocus()
	return
END IF	

scode  	= trim(dw_jogun.GetItemString(1,'itnbr'))
sspec  	= trim(dw_jogun.GetItemString(1,'ispec'))
sname  	= trim(dw_jogun.GetItemString(1,'itdsc'))
sitcls 	= trim(dw_jogun.GetItemString(1,'itcls'))
sJijil 	= trim(dw_jogun.GetItemString(1,'jijil'))
ls_itgu = trim(dw_jogun.GetItemString(1,'itgu'))

IF IsNull(scode)  	THEN scode  = ""
IF IsNull(sname)  	THEN sname  = ""
IF IsNull(sspec)  	THEN sspec  = ""
IF IsNull(sitcls) 	THEN sitcls = ""
IF IsNull(sJijil) 	THEN sJijil = ""
IF IsNull(sSht) 	   THEN sSht   = ""
If IsNull(ls_itgu) Then ls_itgu = ""

//if gs_saupj = '%' then
	sold_sql = "SELECT A.ITNBR, A.ITDSC, A.ISPEC, A.JIJIL, " + &
							" B.TITNM, B.PDTGU, A.USEYN, A.FILSK, " + &
							" FUN_GET_BOMCHK2(A.ITNBR, '2') AS PUSE_YN, " +&
							" A.GRITU , A.MDL_JIJIL " + &
				  "  FROM ITEMAS A, ITNCT B" + &
				  " WHERE A.ITTYP = B.ITTYP (+) " + &
					 " AND A.ITCLS = B.ITCLS (+) " + &
					 " AND A.GBWAN = 'Y' "         + &
					 " AND (( B.PORGU LIKE '" + ls_porgu + "%' ) OR ( B.PORGU = 'ALL' ))"
			
   dw_1.dataobject = 'd_itemas_popup_10'					 
	dw_1.SetTransObject(sqlca)
//else
//	sold_sql = "SELECT A.ITNBR, A.ITDSC, A.ISPEC, A.JIJIL, " + &  
//							" B.TITNM, B.PDTGU, A.USEYN, A.FILSK, " + &  
//							" FUN_GET_BOMCHK2(A.ITNBR, '2') AS PUSE_YN, " +&
//							" A.GRITU , A.MDL_JIJIL, "  + &
//							" C.CVCOD, " + &
//							" FUN_GET_CVNAS(C.CVCOD)   CVNAS, " + &
//							" C.BUNBR,  C.BUDSC, " + &
//							" D.ITM_SHTNM" +&
//				  "  FROM ITEMAS A, ITNCT B, ITMBUY C, " + &
//				  "      (SELECT ITNBR, SAUPJ, ITM_SHTNM FROM ITMSHT " + &
//				  "        WHERE SAUPJ = '" + ls_porgu + "'" + &
//				  "          AND ITM_SHTNM LIKE '" + sSht + "%' ) D" + & 
//				  " WHERE A.ITTYP = B.ITTYP (+) " + &
//					 " AND A.ITCLS = B.ITCLS (+) " + &
//					 " AND A.ITNBR = C.ITNBR (+) " + &
//					 " AND A.ITNBR = D.ITNBR (+) " + &
//					 " AND A.GBWAN = 'Y' "         + &
//					 " AND (( B.PORGU LIKE '" + ls_porgu + "%' ) OR ( B.PORGU = 'ALL' ))"
//
//	dw_1.dataobject = 'd_itemas_popup_2'					 				 
//	dw_1.SetTransObject(sqlca)
//end if

swhere_clause = ""

IF 	sgu <> ""  THEN
   	swhere_clause = 	swhere_clause + " AND A.ITTYP ='"		+sgu			+"'"
END IF
IF 	scode <> "" THEN
	scode = '%' + scode +'%'
	swhere_clause = 	swhere_clause + " AND A.ITNBR LIKE '"	+scode		+"'"
END IF
IF sname <> "" THEN
	sname = '%' + sname +'%'
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
If ls_itgu <> "" Then
	swhere_clause = swhere_clause + " AND A.ITGU LIKE '" + ls_itgu + "'"
End If

snew_sql = sold_sql + swhere_clause

dw_1.SetSqlSelect(snew_sql)

dw_1.Retrieve()

if ssht <> '' And Not Isnull(ssht) then
	dw_1.SetFilter("item_shtnm like '" + sSht + "%'")
	dw_1.Filter()
end if

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_itemas_popup10
integer x = 3291
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
gs_codename = dw_1.GetItemString(ll_row,"itemas_item_shtnm")


Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itemas_popup10
integer x = 27
integer y = 460
integer width = 3589
integer height = 1336
integer taborder = 100
string dataobject = "d_itemas_popup_10"
boolean hscrollbar = true
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
gs_codename2 = dw_1.GetItemString(row,"item_shtnm")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_itemas_popup10
end type

type cb_1 from w_inherite_popup`cb_1 within w_itemas_popup10
end type

type cb_return from w_inherite_popup`cb_return within w_itemas_popup10
end type

type cb_inq from w_inherite_popup`cb_inq within w_itemas_popup10
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itemas_popup10
end type

type st_1 from w_inherite_popup`st_1 within w_itemas_popup10
end type

type rr_2 from roundrectangle within w_itemas_popup10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 456
integer width = 3611
integer height = 1364
integer cornerheight = 40
integer cornerwidth = 55
end type

