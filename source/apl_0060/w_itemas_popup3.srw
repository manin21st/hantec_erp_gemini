$PBExportHeader$w_itemas_popup3.srw
$PBExportComments$** 품목코드 조회 선택(F1 KEY)전체품목
forward
global type w_itemas_popup3 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_itemas_popup3
end type
end forward

global type w_itemas_popup3 from w_inherite_popup
integer x = 357
integer y = 236
integer width = 3255
integer height = 1872
string title = "품목코드 조회(전체품번)"
rr_1 rr_1
end type
global w_itemas_popup3 w_itemas_popup3

type variables
string is_itcls
end variables

on w_itemas_popup3.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_itemas_popup3.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

dw_jogun.setitem(1, 'ittyp', gs_gubun)

setnull(gs_code)
f_mod_saupj(dw_jogun, 'porgu')
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itemas_popup3
integer x = 0
integer y = 4
integer width = 2674
integer height = 376
string dataobject = "d_itemas_popup3_1"
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

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::getfocus;call super::getfocus;IF GetColumnName() = 'itdsc' THEN
	f_toggle_eng(Handle(this))
END IF
end event

event dw_jogun::rbuttondown;call super::rbuttondown;string sname
str_itnct lstr_sitnct

dw_jogun.accepttext()
sname = GetItemString(1, 'ittyp')

if sname = "" or isnull(sname) then sname = '1'
OpenWithParm(w_ittyp_popup, sname)
	
lstr_sitnct = Message.PowerObjectParm	
	
if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
	return 
else
	SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
	SetItem(1,"itcls",lstr_sitnct.s_sumgub)
end if	
end event

type p_exit from w_inherite_popup`p_exit within w_itemas_popup3
integer x = 3058
integer y = 12
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itemas_popup3
integer x = 2702
integer y = 12
end type

event p_inq::clicked;call super::clicked;String scode, sname, sspec, sgu, sitcls, sJijil, sGbwan, ls_porgu, ssht, ls_itgu
String sold_sql, swhere_clause, snew_sql

if dw_jogun.AcceptText() = -1 then return 

sgu 	 	= dw_jogun.GetItemString(1,'ittyp')
scode  	= dw_jogun.GetItemString(1,'itnbr')
sname  	= dw_jogun.GetItemString(1,'itdsc')
sspec  	= dw_jogun.GetItemString(1,'ispec')
sitcls 	= dw_jogun.GetItemString(1,'itcls')
sJijil 	= dw_jogun.GetItemString(1,'jijil')
sGbwan 	= dw_jogun.GetItemString(1,'gbwan')
ls_porgu = dw_jogun.GetItemString(1,'porgu')
ssht     = dw_jogun.GetItemString(1,'itm_shtnm')
ls_itgu  = dw_jogun.GetItemString(1,'itgu')

IF IsNull(ssht) 	THEN ssht = ""
IF IsNull(scode) 	THEN scode  = ""
IF IsNull(sname) 	THEN sname  = ""
IF IsNull(sspec)  THEN sspec  = ""
IF IsNull(sitcls) THEN sitcls = ""
IF IsNull(sJijil) THEN sJijil = ""
IF IsNull(sGbwan) THEN sGbwan = ""
IF IsNull(ls_itgu) THEN ls_itgu = ""

IF IsNull(sgu) or sgu = ''  THEN 
	MessageBox('알림','품목구분을 선택하세요')
	dw_jogun.SetColumn('ittyp')
	dw_jogun.SetFocus()
	return
END IF	
//IF IsNull(ls_porgu) THEN ls_porgu = "%"

sold_sql = "SELECT A.ITNBR, A.ITDSC, A.ISPEC, A.JIJIL, " + &  
                  " B.TITNM, B.PDTGU, A.USEYN, A.FILSK, " + &  
			         " FUN_GET_BOMCHK2(A.ITNBR, '2') AS PUSE_YN, " +&
                  " A.GRITU , "  + &
                  " A.MDL_JIJIL, "  + &
						" C.CVCOD, " + &
						" FUN_GET_CVNAS(C.CVCOD) CVNAS, " + &
						" C.BUNBR, " + &
						" D.ITM_SHTNM" + &
           "  FROM ITEMAS A, ITNCT B, ITMBUY C, " + & 
			  "       ( SELECT ITNBR, SAUPJ, ITM_SHTNM FROM ITMSHT " + &
			  "          WHERE SAUPJ = '" + ls_porgu + "'" + &
			  "             ) D" +&
           " WHERE A.ITTYP = B.ITTYP (+) " + &
			  " AND A.ITCLS = B.ITCLS (+) " + &
			  " AND A.ITNBR = C.ITNBR (+) " + &
			  " AND ( B.PORGU = 'ALL' "         + &
			  "       OR B.PORGU like '" + ls_porgu + "' ) " +&
			  " AND A.ITNBR = D.ITNBR(+) "

//AND ITM_SHTNM LIKE '"+ssht+"'

swhere_clause = ""

IF 	sgu <> ""  THEN 
   	swhere_clause = swhere_clause + " AND A.ITTYP ='"+sgu+"'"
END IF
IF 	scode <> "" THEN
	scode = '%' + scode +'%'
	swhere_clause = swhere_clause + " AND A.ITNBR LIKE '"+scode+"'"
END IF
IF 	sname <> "" THEN
	sname = '%' + sname +'%'
	swhere_clause = swhere_clause + " AND A.ITDSC LIKE '"+sname+"'"
END IF
IF 	sspec <> "" THEN
	sspec = '%' + sspec +'%'
	swhere_clause = swhere_clause + " AND A.ISPEC LIKE '"+sspec+"'"
END IF
IF 	sitcls <> "" THEN
	sitcls = '%' + sitcls +'%'
	swhere_clause = swhere_clause + " AND A.ITCLS LIKE '"+sitcls+"'"
END IF
IF 	sJijil <> "" THEN
	sJijil = '%' + sJijil +'%'
	swhere_clause = swhere_clause + " AND A.JIJIL LIKE '"+sJijil+"'"
END IF

IF	ssht <> "" THEN
	ssht = '%' + ssht +'%'
	swhere_clause = swhere_clause + " AND D.ITM_SHTNM LIKE '"+ssht+"'"
END IF

IF sGbwan = 'Y' THEN         
	swhere_clause = swhere_clause + " AND A.GBWAN = 'Y' "
ELSEIF sGbwan = 'N' THEN
	swhere_clause = swhere_clause + " AND A.GBWAN = 'N' "
END IF
IF ls_itgu <> "" Then
	swhere_clause = swhere_clause + " AND A.ITGU LIKE '" + ls_itgu + "'"
End If
// ------------------------------ 추가 (사업장)
//IF ls_porgu <> "" THEN
//	swhere_clause = swhere_clause + " AND B.PORGU LIKE '"+ls_porgu+"%'"
//END IF

snew_sql = sold_sql + swhere_clause

dw_1.SetSqlSelect(snew_sql)
	
dw_1.Retrieve()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_itemas_popup3
integer x = 2880
integer y = 12
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code = dw_1.GetItemString(ll_Row, "itemas_itnbr")
gs_codename = dw_1.GetItemString(ll_row,"itemas_itdsc")
gs_gubun = dw_1.GetItemString(ll_row,"itemas_ispec")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itemas_popup3
integer x = 32
integer y = 404
integer width = 3186
integer height = 1356
integer taborder = 90
string dataobject = "d_itemas_popup3"
boolean hscrollbar = true
boolean hsplitscroll = true
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

gs_code= dw_1.GetItemString(Row, "itemas_itnbr")
gs_codename= dw_1.GetItemString(row,"itemas_itdsc")
gs_gubun= dw_1.GetItemString(row,"itemas_ispec")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_itemas_popup3
boolean visible = false
integer x = 786
integer y = 1876
integer width = 526
integer taborder = 40
boolean enabled = false
end type

type cb_1 from w_inherite_popup`cb_1 within w_itemas_popup3
integer x = 366
integer y = 1904
integer taborder = 100
end type

type cb_return from w_inherite_popup`cb_return within w_itemas_popup3
integer x = 987
integer y = 1904
integer taborder = 120
end type

type cb_inq from w_inherite_popup`cb_inq within w_itemas_popup3
integer x = 677
integer y = 1904
integer taborder = 110
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itemas_popup3
boolean visible = false
integer x = 375
integer y = 1876
integer width = 411
integer taborder = 30
boolean enabled = false
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_itemas_popup3
boolean visible = false
integer x = 119
integer y = 1888
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_itemas_popup3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 392
integer width = 3209
integer height = 1384
integer cornerheight = 40
integer cornerwidth = 55
end type

