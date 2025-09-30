$PBExportHeader$w_itemas_multi_popup_yongcha.srw
$PBExportComments$용차사용내역 품번멀티 선택
forward
global type w_itemas_multi_popup_yongcha from w_inherite_popup
end type
type rr_2 from roundrectangle within w_itemas_multi_popup_yongcha
end type
end forward

global type w_itemas_multi_popup_yongcha from w_inherite_popup
integer x = 357
integer y = 236
integer width = 3675
integer height = 2000
string title = "품목코드 조회(Mulit Selected)"
rr_2 rr_2
end type
global w_itemas_multi_popup_yongcha w_itemas_multi_popup_yongcha

type variables
string is_itcls

str_code istr_itnbr
end variables

on w_itemas_multi_popup_yongcha.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_itemas_multi_popup_yongcha.destroy
call super::destroy
destroy(this.rr_2)
end on

event open;call super::open;Long i

For i=1 To UpperBound(istr_itnbr.code)
	SetNull(istr_itnbr.code[i])
	SetNull(istr_itnbr.codename[i])
Next


dw_jogun.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

dw_jogun.setitem(1, 'ittyp', gs_gubun)

f_mod_saupj(dw_jogun, 'porgu')



end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itemas_multi_popup_yongcha
integer x = 0
integer y = 32
integer width = 2729
integer height = 400
string dataobject = "d_itemas_ittyp_yongcha"
end type

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_name

setnull(snull)

Choose	Case 	this.GetColumnName() 
	Case	'ittyp' 
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
END Choose

//P_INQ.triggerEvent(Clicked!)


end event

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

type p_exit from w_inherite_popup`p_exit within w_itemas_multi_popup_yongcha
integer x = 3465
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Long i

For i=1 To UpperBound(istr_itnbr.code)
	SetNull(istr_itnbr.code[i])
	SetNull(istr_itnbr.codename[i])
Next

CloseWithReturn(Parent,istr_itnbr)
end event

type p_inq from w_inherite_popup`p_inq within w_itemas_multi_popup_yongcha
integer x = 3118
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String scode, sname, sspec, sgu, sitcls, sJijil, ls_porgu, ls_itgu
String sold_sql, swhere_clause, snew_sql
string suseyn

if dw_jogun.AcceptText() = -1 then return 

sgu 		= dw_jogun.GetItemString(1,'ittyp')
ls_porgu = dw_jogun.GetItemString(1,'porgu')

IF IsNull(sgu) THEN sgu = ""

scode  	= trim(dw_jogun.GetItemString(1,'itnbr'))
sname  	= trim(dw_jogun.GetItemString(1,'itdsc'))
sspec  	= trim(dw_jogun.GetItemString(1,'ispec'))
sitcls 	= trim(dw_jogun.GetItemString(1,'itcls'))
sJijil 	= trim(dw_jogun.GetItemString(1,'jijil'))
suseyn 	= '0'
ls_itgu  = trim(dw_jogun.GetItemString(1,'itgu'))

IF IsNull(scode)  	THEN scode  = ""
IF IsNull(sname)  	THEN sname  = ""
IF IsNull(sspec)  	THEN sspec  = ""
IF IsNull(sitcls) 	THEN sitcls = ""
IF IsNull(sJijil) 	THEN sJijil = ""
IF IsNull(suseyn)    or suseyn <> '0' THEN suseyn = "2"
If IsNull(ls_itgu) Then ls_itgu = ""

   sold_sql =  " SELECT A.ITNBR,   											" + &  
					"			A.ITDSC,   											" + &  
					"			A.ISPEC,   											" + &  
					"			A.JIJIL,    										" + &  
					"			B.TITNM,   											" + &  
					"			B.PDTGU,    										" + &  
					"			A.USEYN,   											" + &  
					"			A.FILSK,												" + &  
					"			FUN_GET_BOMCHK2(A.ITNBR, '2') AS PUSE_YN,	" + &  
					"			A.GRITU,												" + &  
					"			A.MDL_JIJIL,										" + &  
					"			A.LOCFR,										      " + &  
					"			A.PRPGUB,									      " + & 
					"			A.UNMSR, 									      " + &          
					"			'N' is_chek,										" + &  
					"			0 AS QTY 											" + &  
					"	 FROM ITEMAS A,   										" + &  
					"			ITNCT B												" + &  
					"	WHERE ( A.ITTYP = B.ITTYP(+) ) and  				" + &  
					"			( A.ITCLS = B.ITCLS(+) ) and  				" + &  
					"			( A.GBWAN = 'Y' )  								" + &  
					"	  AND	( A.USEYN = '" + suseyn + "')"              + &  
					"    AND (B.PORGU = 'ALL' OR B.PORGU LIKE '" + ls_porgu + "%')"
					
	
   dw_1.dataobject = 'd_itemas_multi_popup_yongcha'					 
	dw_1.SetTransObject(sqlca)

swhere_clause = ""
/* 유,무상 구분으로 조회처리.*/
IF	not isnull(gs_codename2)	and gs_codename <> ''	then
   	swhere_clause = 	swhere_clause + "AND NVL(A.PRPGUB, '0')  <> '0' "
end if
	
IF 	sgu <> ""  THEN 
   	swhere_clause = 	swhere_clause + "AND A.ITTYP ='"		+sgu			+"'"
END IF

IF 	sgu <> ""  THEN 
   	swhere_clause = 	swhere_clause + "AND A.ITTYP ='"		+sgu			+"'"
END IF
IF 	scode <> "" THEN
	scode = '%' + scode +'%'
	swhere_clause = 	swhere_clause + "AND A.ITNBR LIKE '"	+scode		+"'"
END IF
IF 	sname <> "" THEN
	sname = '%' + sname +'%'
	swhere_clause = 	swhere_clause + "AND A.ITDSC LIKE '"	+sname		+"'"
END IF
IF 	sspec <> "" THEN
	sspec = '%' + sspec +'%'
	swhere_clause = 	swhere_clause + "AND A.ISPEC LIKE '"	+sspec		+"'"
END IF
IF 	sitcls <> "" THEN
	sitcls = sitcls +'%'
	swhere_clause = 	swhere_clause + "AND A.ITCLS LIKE '"	+sitcls		+"'"
END IF
IF 	sJijil <> "" THEN
	sJijil = '%' + sJijil +'%'
	swhere_clause = 	swhere_clause + "AND A.JIJIL LIKE '"	+sJijil		+"'"
END IF
If ls_itgu <> "" Then
	swhere_clause = swhere_clause + "AND A.ITGU LIKE '" + ls_itgu + "'"
End If
		
snew_sql = sold_sql + swhere_clause

dw_1.SetSqlSelect(snew_sql)

dw_1.Retrieve()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_itemas_multi_popup_yongcha
integer x = 3291
end type

event p_choose::clicked;call super::clicked;dw_1.AcceptText()

Long ll_row , i , ii=0

ll_Row = dw_1.RowCount()

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

For i = 1 To ll_row
	If dw_1.Object.is_chek[i] = 'Y' Then
		IF dw_1.GetItemString(i, "itemas_useyn") = '2' then
			f_message_chk(54, "[품번]")
			Return 
		END IF
		ii++
		
		istr_itnbr.code[ii]     = dw_1.Object.itemas_itnbr[i]
		istr_itnbr.codename[ii] = dw_1.Object.itemas_itdsc[i]
		istr_itnbr.sgubun1[ii]  = dw_1.Object.itemas_ispec[i]
		istr_itnbr.sgubun2[ii]  = dw_1.Object.itemas_jijil[i]
		istr_itnbr.sgubun3[ii]  = dw_1.Object.itemas_useyn[i]
		
		istr_itnbr.sgubun4[ii]  = dw_1.Object.itemas_unmsr[i]
		istr_itnbr.dgubun1[ii]  = dw_1.Object.qty[i]
	End If
Next

CloseWithReturn(Parent , istr_itnbr)

end event

type dw_1 from w_inherite_popup`dw_1 within w_itemas_multi_popup_yongcha
integer x = 27
integer y = 444
integer width = 3602
integer height = 1356
integer taborder = 100
string dataobject = "d_itemas_multi_popup_yongcha"
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

IF dw_1.GetItemString(Row, "itemas_useyn") = '2' then
	f_message_chk(54, "[품번]")
	Return 
END IF

istr_itnbr.code[1]     = dw_1.Object.itemas_itnbr[Row]
istr_itnbr.codename[1] = dw_1.Object.itemas_itdsc[Row]
istr_itnbr.sgubun1[1]  = dw_1.Object.itemas_ispec[Row]
istr_itnbr.sgubun2[1]  = dw_1.Object.itemas_jijil[Row]
istr_itnbr.sgubun3[1]  = dw_1.Object.itemas_useyn[Row]

CloseWithReturn(Parent , istr_itnbr)

//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
////IF dw_1.GetItemString(Row, "itemas_useyn") = '1' then
////	f_message_chk(53, "[품번]")
////	Return 
//IF dw_1.GetItemString(Row, "itemas_useyn") = '2' then
//	f_message_chk(54, "[품번]")
//	Return 
//END IF
//
//gs_code= dw_1.GetItemString(Row, "itemas_itnbr")
//gs_codename= dw_1.GetItemString(row,"itemas_itdsc")
//gs_gubun= dw_1.GetItemString(row,"itemas_ispec")
//gs_codename2 = dw_1.GetItemString(row,"itemas_jijil")
//
//Close(Parent)
//
end event

type sle_2 from w_inherite_popup`sle_2 within w_itemas_multi_popup_yongcha
end type

type cb_1 from w_inherite_popup`cb_1 within w_itemas_multi_popup_yongcha
end type

type cb_return from w_inherite_popup`cb_return within w_itemas_multi_popup_yongcha
end type

type cb_inq from w_inherite_popup`cb_inq within w_itemas_multi_popup_yongcha
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itemas_multi_popup_yongcha
end type

type st_1 from w_inherite_popup`st_1 within w_itemas_multi_popup_yongcha
end type

type rr_2 from roundrectangle within w_itemas_multi_popup_yongcha
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 432
integer width = 3625
integer height = 1384
integer cornerheight = 40
integer cornerwidth = 55
end type

