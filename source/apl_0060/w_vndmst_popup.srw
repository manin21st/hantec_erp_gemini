$PBExportHeader$w_vndmst_popup.srw
$PBExportComments$** 거래처 조회 선택
forward
global type w_vndmst_popup from w_inherite_popup
end type
type cbx_1 from checkbox within w_vndmst_popup
end type
type cbx_2 from checkbox within w_vndmst_popup
end type
type cbx_3 from checkbox within w_vndmst_popup
end type
type cbx_4 from checkbox within w_vndmst_popup
end type
type cbx_5 from checkbox within w_vndmst_popup
end type
type rr_1 from roundrectangle within w_vndmst_popup
end type
type rr_2 from roundrectangle within w_vndmst_popup
end type
end forward

global type w_vndmst_popup from w_inherite_popup
integer x = 1285
integer y = 148
integer width = 2048
integer height = 2148
string title = "거래처 조회 선택"
cbx_1 cbx_1
cbx_2 cbx_2
cbx_3 cbx_3
cbx_4 cbx_4
cbx_5 cbx_5
rr_1 rr_1
rr_2 rr_2
end type
global w_vndmst_popup w_vndmst_popup

type variables
int  li_use  //거래처마스타는 거래중지인 경우도 조회
end variables

on w_vndmst_popup.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
this.cbx_5=create cbx_5
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.cbx_2
this.Control[iCurrent+3]=this.cbx_3
this.Control[iCurrent+4]=this.cbx_4
this.Control[iCurrent+5]=this.cbx_5
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
end on

on w_vndmst_popup.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_3)
destroy(this.cbx_4)
destroy(this.cbx_5)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;String sgubun,scode,sname,sold_sql,swhere_clause,snew_sql
Int    ipos

dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

//거래처마스타에서 조회한 경우 -1를 가져옴
li_use = gi_page
IF li_use <> -1 then li_use = 0

IF gs_gubun ="" OR IsNull(gs_gubun) THEN
	sgubun = '%'
ELSE
	dw_jogun.SetItem(1,"rfgub",gs_gubun)
	sgubun = dw_jogun.GetItemString(1,"rfgub")
END IF

IF IsNull(gs_code) THEN gs_code =""

dw_jogun.SetItem(1, 'cvcod', gs_Code)
dw_jogun.SetItem(1, 'cvnas', gs_Codename)

scode = gs_code
sname = gs_codename

IF IsNull(scode) THEN scode =""
IF IsNull(sname) THEN sname = ""

IF scode ="" AND sname ="" THEN 
	dw_jogun.SetFocus()
	dw_jogun.SetColumn('cvcod')
	RETURN
END IF

sold_sql = dw_1.Getsqlselect()

IF li_use = -1 then 
	sold_sql = sold_sql + " WHERE"
ELSE
	sold_sql = sold_sql + " WHERE VNDMST.CVSTATUS <> '2'   AND"
END IF	

IF scode <> "" AND sname ="" THEN
	scode = scode +'%'
	swhere_clause =" CVCOD LIKE '"+ scode +"' AND CVGU LIKE'"+sgubun+"'   AND"
ELSEIF sname <> "" AND scode ="" THEN
	sname = sname + '%'
	swhere_clause =" CVNAS2 LIKE '"+ sname +"' AND CVGU LIKE'"+sgubun+"'   AND"
END IF

snew_sql = sold_sql + swhere_clause

ipos = len(snew_sql)

snew_sql = left(snew_sql, ipos - 5 )

dw_1.SetSqlSelect(snew_sql)
	
dw_1.Retrieve()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_vndmst_popup
integer x = 32
integer y = 192
integer width = 1467
integer height = 196
string dataobject = "d_vndmst_popup1"
end type

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

event dw_jogun::ue_pressenter;If This.GetRow() < 1 Then Return 1

Choose Case This.GetColumnName()
	Case 'cvnas'
		p_inq.PostEvent(Clicked!)
		Return 1
End Choose

Send(Handle(this),256,9,0)
Return 1
end event

type p_exit from w_inherite_popup`p_exit within w_vndmst_popup
integer x = 1833
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_vndmst_popup
integer x = 1486
integer y = 16
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String scode,sname,sgubun,snew_sql,sold_sql,swhere_clause, &
          s_saleyn, s_gumaeyn, s_oyjuyn, s_oyjugayn, s_yongyn  , ls_check
Int    ipos

IF dw_jogun.AcceptText() = -1 THEN Return
sgubun = dw_jogun.GetItemString(1,"rfgub")
scode  = Trim(dw_jogun.GetItemString(1,"cvcod"))
sname  = Trim(dw_jogun.GetItemString(1,"cvnas"))

IF sgubun ="" OR IsNull(sgubun) THEN
	sgubun ='%'
END IF

IF IsNull(scode) THEN scode =""
IF IsNull(sname) THEN sname = ""

sold_sql =   "SELECT CVCOD, CVGU, CVNAS, CVNAS2, SANO, CVSTATUS, OWNAM, EMP_ID " + &  
             "  FROM VNDMST " + &  
             " WHERE"   
swhere_clause = ""
SetNull(ls_check)

IF li_use <> -1 then 
	swhere_clause = " VNDMST.CVSTATUS <> '2'   AND"
END IF	

If    (cbx_1.checked = true) or (cbx_2.checked = true)  or (cbx_3.checked = true) or	& 
    	(cbx_4.checked = true) or (cbx_5.checked = true)  then 
	swhere_clause = swhere_clause + " ( "
End If	
		 
IF 	cbx_1.checked = TRUE THEN 
	swhere_clause = swhere_clause + " SALEYN = 'Y'   OR"
END IF
IF 	cbx_2.checked = TRUE THEN 
	swhere_clause = swhere_clause + " GUMAEYN = 'Y'   OR"
END IF
IF 	cbx_3.checked = TRUE THEN 
	swhere_clause = swhere_clause + " OYJUYN = 'Y'   OR"
END IF
IF 	cbx_4.checked = TRUE THEN 
	swhere_clause = swhere_clause + " OYJUGAYN = 'Y'   OR"
END IF
IF 	cbx_5.checked = TRUE THEN 
	swhere_clause = swhere_clause + " YONGYN = 'Y'   OR "
END IF
If    (cbx_1.checked = true) or (cbx_2.checked = true)  or (cbx_3.checked = true) or	& 
    	(cbx_4.checked = true) or (cbx_5.checked = true)  then 
	ipos = len(swhere_clause)

	//where 절 까지 감안하여 5자리 자름 
	swhere_clause = left(swhere_clause, ipos - 5 )
	swhere_clause = swhere_clause + " ) AND "
End If
IF scode <> "" AND sname ="" THEN
	scode = scode +'%'
	swhere_clause = swhere_clause + " CVCOD LIKE '"+ scode +"' AND CVGU LIKE'"+sgubun+"'   AND"
ELSEIF sname <> "" AND scode ="" THEN
	sname = '%' + sname + '%'
	swhere_clause = swhere_clause + " CVNAS2 LIKE '"+ sname +"' AND CVGU LIKE'"+sgubun+"'   AND"
ELSEIF sname <> "" AND scode <>"" THEN
	sname = '%' + sname + '%'
	scode = scode + '%'
	swhere_clause = swhere_clause + " CVNAS2 LIKE '"+ sname +"' AND CVGU LIKE'"+sgubun+"'" + &
	                "AND CVCOD LIKE '"+ scode +"'   AND"
ELSEIF sname = "" AND scode ="" THEN
	swhere_clause = swhere_clause + " CVGU LIKE'"+sgubun+"'   AND" 
END IF

swhere_clause = sold_sql + swhere_clause
ipos = len(swhere_clause)

//where 절 까지 감안하여 5자리 자름 
snew_sql = left(swhere_clause, ipos - 5 )

dw_1.SetSqlSelect(snew_sql)
	
dw_1.Retrieve()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_vndmst_popup
integer x = 1659
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

If gs_codename2 <> 'Y' Then //거래중지 선택 여부 확인 - by shingoon 2015.09.10
	IF dw_1.getitemstring(ll_row, "cvstatus") = '1' and  li_use <> -1 then //거래중지
		MessageBox("확 인", "거래중지인 자료는 선택할 수 없습니다.")
		return
	END IF
End If

gs_gubun= dw_1.GetItemString(ll_Row, "cvgu")
gs_code= dw_1.GetItemString(ll_Row, "cvcod")
gs_codename= dw_1.GetItemString(ll_row,"cvnas2")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_vndmst_popup
integer x = 27
integer y = 508
integer width = 1966
integer height = 1536
integer taborder = 50
string dataobject = "d_vndmst_popup"
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

If gs_codename2 <> 'Y' Then  //거래중지 확인 여부 - by shingoon 2015.09.10
	IF dw_1.getitemstring(row, "cvstatus") = '1' and li_use <> -1 then //거래중지
		MessageBox("확 인", "거래중지인 자료는 선택할 수 없습니다.")
		return
	END IF
End If

gs_gubun= dw_1.GetItemString(Row, "cvgu")
gs_code= dw_1.GetItemString(Row, "cvcod")
gs_codename= dw_1.GetItemString(row,"cvnas2")

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_vndmst_popup
integer x = 599
integer y = 2392
integer width = 1225
end type

type cb_1 from w_inherite_popup`cb_1 within w_vndmst_popup
integer x = 718
integer y = 2344
end type

type cb_return from w_inherite_popup`cb_return within w_vndmst_popup
integer x = 1339
integer y = 2344
end type

type cb_inq from w_inherite_popup`cb_inq within w_vndmst_popup
integer x = 1029
integer y = 2344
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_vndmst_popup
integer x = 398
integer y = 2392
integer width = 197
integer limit = 6
end type

type st_1 from w_inherite_popup`st_1 within w_vndmst_popup
integer x = 69
integer y = 2408
integer width = 315
string text = "거래처코드"
end type

type cbx_1 from checkbox within w_vndmst_popup
integer x = 59
integer y = 392
integer width = 215
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "매출"
end type

type cbx_2 from checkbox within w_vndmst_popup
integer x = 338
integer y = 392
integer width = 215
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "구매"
end type

type cbx_3 from checkbox within w_vndmst_popup
integer x = 617
integer y = 392
integer width = 215
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "외주"
end type

type cbx_4 from checkbox within w_vndmst_popup
integer x = 896
integer y = 392
integer width = 320
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "외주가공"
end type

type cbx_5 from checkbox within w_vndmst_popup
integer x = 1280
integer y = 392
integer width = 215
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "용역"
end type

type rr_1 from roundrectangle within w_vndmst_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 180
integer width = 1989
integer height = 308
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_vndmst_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 504
integer width = 1989
integer height = 1548
integer cornerheight = 40
integer cornerwidth = 55
end type

