$PBExportHeader$w_pdm_30010.srw
$PBExportComments$단가마스터 가단가/미단가 조회 (경리용)
forward
global type w_pdm_30010 from w_standard_print
end type
type rb_1 from radiobutton within w_pdm_30010
end type
type pb_1 from u_pic_cal within w_pdm_30010
end type
type pb_2 from u_pic_cal within w_pdm_30010
end type
type cbx_1 from checkbox within w_pdm_30010
end type
type cbx_2 from checkbox within w_pdm_30010
end type
type cbx_3 from checkbox within w_pdm_30010
end type
type cbx_4 from checkbox within w_pdm_30010
end type
type cbx_5 from checkbox within w_pdm_30010
end type
type cbx_6 from checkbox within w_pdm_30010
end type
type cbx_7 from checkbox within w_pdm_30010
end type
type cbx_8 from checkbox within w_pdm_30010
end type
type cbx_9 from checkbox within w_pdm_30010
end type
type cbx_10 from checkbox within w_pdm_30010
end type
end forward

global type w_pdm_30010 from w_standard_print
integer width = 4731
integer height = 2512
string title = "가단가/미단가 조회"
rb_1 rb_1
pb_1 pb_1
pb_2 pb_2
cbx_1 cbx_1
cbx_2 cbx_2
cbx_3 cbx_3
cbx_4 cbx_4
cbx_5 cbx_5
cbx_6 cbx_6
cbx_7 cbx_7
cbx_8 cbx_8
cbx_9 cbx_9
cbx_10 cbx_10
end type
global w_pdm_30010 w_pdm_30010

forward prototypes
public subroutine wf_choosedw (radiobutton rabutton)
public subroutine wf_history ()
public subroutine wf_itcls ()
public subroutine wf_itemas ()
public subroutine wf_vndmst ()
public function integer wf_retrieve ()
public subroutine wf_ret ()
end prototypes

public subroutine wf_choosedw (radiobutton rabutton);dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
//dw_print.SetTransObject(SQLCA)
dw_ip.insertrow(0)

//----- 사업장 확인..
f_mod_saupj(dw_ip, 'porgu')
//-----------------------------------------------------------------//
dw_ip.SetColumn(1)
dw_ip.Setfocus()

//ddlb_zoom.text = '100'
//cb_ruler.text = '여백ON'

end subroutine

public subroutine wf_history ();//단가 변경 이력

String s_ittyp, s_fitnbr, s_titnbr, s_itgu1, s_itgu2, snew_sql, sold_sql, swhere_clause, &
       s_fdate, s_tdate, ls_porgu, s_cvcod, s_hangu 

s_ittyp  = Trim(dw_ip.GetItemString(1, "sittyp"))
s_fitnbr = Trim(dw_ip.GetItemString(1, "fr_itnbr"))
s_cvcod  = Trim(dw_ip.GetItemString(1, "fr_cvcod"))
s_titnbr = Trim(dw_ip.GetItemString(1, "to_itnbr"))
s_fdate  = Trim(dw_ip.GetItemString(1, "fr_date"))
s_tdate  = Trim(dw_ip.GetItemString(1, "to_date"))
ls_porgu = Trim(dw_ip.GetItemString(1, "porgu"))
s_hangu = Trim(dw_ip.GetItemString(1, "hangu"))

if s_ittyp  = '' or isnull(s_ittyp) then s_ittyp ='%' 
if s_fitnbr = '' or isnull(s_fitnbr) then s_fitnbr ='%' 
if s_titnbr = '' or isnull(s_titnbr) then s_titnbr ='%' 
if s_cvcod = '' or isnull(s_fitnbr) then s_cvcod ='%' 
if s_fdate  = '' or isnull(s_fdate) then s_fdate ='%' 
if s_tdate  = '' or isnull(s_tdate) then s_tdate ='%' 

sold_sql =   "SELECT D.ITNBR, D.CVCOD, D.OPSEQ, D.BAMT, D.AAMT, D.REMARK, D.CDATE, A.CUNIT, D.IDATE, A.HANGU, "+&
             "       I.ITDSC, I.ISPEC, I.JIJIL, I.ACCOD, I.ITCLS, I.ITTYP, I.JEJOS, " +&
				 " 		V.CVNAS, R.OPDSC,  " +&
				 "		   A.CNTGU, A.PIQNO, A.UNPRC, A.EFRDT, A.EFTDT, A.GONPRC , I.ISPEC_CODE, fun_get_reffpf('AD', T.PORGU ) PORGU, " +&
			    "       FUN_GET_CARTYPE(D.ITNBR) AS CARTYPE " + &
				 "  FROM DANHST D, ITEMAS I, VNDMST V, ROUTNG R, DANMST A, ITNCT T "+&
				 " WHERE D.ITNBR = I.ITNBR(+) AND D.ITNBR = A.ITNBR(+) AND  "+&
				 "   	   D.CVCOD = A.CVCOD(+) AND D.OPSEQ = A.OPSEQ(+) AND  "+&
				 " 		D.CVCOD = V.CVCOD(+) AND D.ITNBR = R.ITNBR(+) AND  "+&
				 "		   I.ITTYP = T.ITTYP(+) AND I.ITCLS = T.ITCLS(+) AND "+&
				 "			D.OPSEQ = R.OPSEQ(+) AND (T.porgu = 'ALL' OR T.porgu like '" + ls_porgu + "%' " + ' ) '

swhere_clause = " "

IF s_ittyp <> '%'  THEN
	swhere_clause = swhere_clause + "AND I.ITTYP = '"+s_ittyp+"' "
END IF
IF s_fitnbr <> '%'  THEN
	swhere_clause = swhere_clause + "AND D.ITNBR = '"+s_fitnbr+"' "
END IF

IF s_cvcod <> '%'  THEN
	swhere_clause = swhere_clause + "AND D.CVCOD = '"+s_cvcod+"' "
END IF

//IF s_titnbr <> '%'  THEN
//	swhere_clause = swhere_clause + "AND D.ITNBR <= '"+s_titnbr+"' "
//END IF

IF s_fdate <> '%'  THEN
	swhere_clause = swhere_clause + "AND D.CDATE >= '"+s_fdate+"' "
END IF
IF s_tdate <> '%'  THEN
	swhere_clause = swhere_clause + "AND D.CDATE <= '"+s_tdate+"' "
END IF

IF s_hangu <> '%'  THEN
	swhere_clause = swhere_clause + "AND A.HANGU = '"+s_hangu+"' "
END IF

//if rb_5.Checked then 
//elseif rb_6.Checked then 
//	swhere_clause = swhere_clause + "AND I.ITGU IN ('1', '2') "
//elseif rb_7.Checked then 
//	swhere_clause = swhere_clause + "AND I.ITGU IN ('3', '4') "
//else
//	swhere_clause = swhere_clause + "AND I.ITGU =   '6' "	
//end if

snew_sql = sold_sql + swhere_clause

//dw_print.SetSqlSelect(snew_sql)

end subroutine

public subroutine wf_itcls ();////단가마스타 (품목분류별) 
//
//String s_ittyp, s_fitcls, s_titcls, s_itgu1, s_itgu2, snew_sql, sold_sql, swhere_clause ,&
//       s_guout, ls_porgu, s_hangu
//
//s_ittyp  = Trim(dw_ip.GetItemString(1, "sittyp"))
//s_fitcls = Trim(dw_ip.GetItemString(1, "fr_itcls"))
//s_titcls = Trim(dw_ip.GetItemString(1, "to_itcls"))
//s_guout = Trim(dw_ip.GetItemString(1, "guout"))
//ls_porgu = Trim(dw_ip.GetItemString(1, "porgu"))
//s_hangu	= Trim(dw_ip.GetItemString(1, "hangu"))
//
//if s_ittyp = '' or isnull(s_ittyp) then s_ittyp ='%' 
//if s_fitcls = '' or isnull(s_fitcls) then s_fitcls ='%' 
//if s_titcls = '' or isnull(s_titcls) then s_titcls ='%' 
//
//sold_sql =   "SELECT D.*, I.ITDSC, I.ISPEC, I.JIJIL, I.ACCOD, I.ITCLS, I.ITTYP," +&
//             "       T.TITNM, V.CVNAS, R.OPDSC, I.JEJOS , D.GONPRC , I.ISPEC_CODE, fun_get_reffpf('AD', T.PORGU ) PORGU, "+&
//				 "			I.UNMSR, FUN_GET_ITMSHT('" + gs_saupj + "', I.ITNBR) AS ITM_SHTNM, " +&
//			    "       FUN_GET_CARTYPE(D.ITNBR) AS CARTYPE " + &
//				 "  FROM DANMST D, ITEMAS I, ITNCT T, VNDMST V, ROUTNG R "+&				 
//				 " WHERE D.ITNBR = I.ITNBR AND    "+&
//				 "		   I.ITTYP = T.ITTYP(+) AND I.ITCLS = T.ITCLS(+) AND "+&
//				 "		   D.CVCOD = V.CVCOD(+) AND D.ITNBR = R.ITNBR(+) AND "+&
//				 "			D.OPSEQ = R.OPSEQ(+) AND (T.porgu = 'ALL' OR T.porgu like '" + ls_porgu + "%' " + ' ) '
//
//swhere_clause = " "
//
//IF s_ittyp <> '%'  THEN
//	swhere_clause = swhere_clause + "AND I.ITTYP = '"+s_ittyp+"' "
//END IF
//IF s_fitcls <> '%'  THEN
//	swhere_clause = swhere_clause + "AND I.ITCLS >= '"+s_fitcls+"' "
//END IF
//IF s_titcls <> '%'  THEN
//	swhere_clause = swhere_clause + "AND I.ITCLS <= '"+s_titcls+"' "
//END IF
//
//IF s_guout <> '0'  THEN
//	swhere_clause = swhere_clause + "AND D.GUOUT = '"+s_guout+"' "
//END IF
//
//IF s_hangu <> '%'  THEN
//	swhere_clause = swhere_clause + "AND D.HANGU = '"+s_hangu+"' "
//END IF
//
//
//if rb_5.Checked then 
//elseif rb_6.Checked then 
//	swhere_clause = swhere_clause + "AND I.ITGU IN ('1', '2') "
//elseif rb_7.Checked then 
//	swhere_clause = swhere_clause + "AND I.ITGU IN ('3', '4') "
//elseif rb_8.Checked then 
//	swhere_clause = swhere_clause + "AND I.ITGU =   '6' "
//	
//elseif rb_9.Checked then 
//	swhere_clause = swhere_clause + "AND D.CNTGU =   '1' "	
//elseif rb_10.Checked then 
//	swhere_clause = swhere_clause + "AND D.CNTGU =   '2' "	
//end if
//
//snew_sql = sold_sql + swhere_clause
//
//dw_print.SetSqlSelect(snew_sql)
//
end subroutine

public subroutine wf_itemas ();////단가마스타 (품목별) 
//
//String s_ittyp, s_fitnbr, s_titnbr, s_itgu1, s_itgu2, snew_sql, sold_sql, swhere_clause, &
//       s_guout, ls_porgu,  s_hangu
//
//s_ittyp  = Trim(dw_ip.GetItemString(1, "sittyp"))
//s_fitnbr = Trim(dw_ip.GetItemString(1, "fr_itnbr"))
//s_titnbr = Trim(dw_ip.GetItemString(1, "to_itnbr"))
//s_guout = Trim(dw_ip.GetItemString(1, "guout"))
//ls_porgu = Trim(dw_ip.GetItemString(1, "porgu"))
//s_hangu = Trim(dw_ip.GetItemString(1, "hangu"))
//
//if s_ittyp = '' or isnull(s_ittyp) then s_ittyp ='%' 
//if s_fitnbr = '' or isnull(s_fitnbr) then s_fitnbr ='%' 
//if s_titnbr = '' or isnull(s_titnbr) then s_titnbr ='%' 
//
//sold_sql =   "SELECT D.*, I.ITDSC, I.ISPEC, I.JIJIL, I.ACCOD, I.ITCLS, I.ITTYP," +&
//             "       T.TITNM, V.CVNAS, R.OPDSC, I.JEJOS , D.GONPRC, I.ISPEC_CODE, fun_get_reffpf('AD', T.PORGU ) PORGU,  "+&
//				 "       I.UNMSR, FUN_GET_ITMSHT(' " + gs_saupj + "', I.ITNBR) AS ITM_SHTNM, " + &
//			    "       FUN_GET_CARTYPE(D.ITNBR) AS CARTYPE " + &
//				 "  FROM DANMST D, ITEMAS I, ITNCT T, VNDMST V, ROUTNG R "+&
//				 " WHERE D.ITNBR = I.ITNBR AND    "+&
//				 "		   I.ITTYP = T.ITTYP(+) AND I.ITCLS = T.ITCLS(+) AND "+&
//				 "		   D.CVCOD = V.CVCOD(+) AND D.ITNBR = R.ITNBR(+) AND "+&
//				 "			D.OPSEQ = R.OPSEQ(+) AND (T.porgu = 'ALL' OR T.porgu like '" + ls_porgu + "%' " + ' ) '
//
//swhere_clause = " "
//
//IF s_ittyp <> '%'  THEN
//	swhere_clause = swhere_clause + "AND I.ITTYP = '"+s_ittyp+"' "
//END IF
//IF s_fitnbr <> '%'  THEN
//	swhere_clause = swhere_clause + "AND D.ITNBR >= '"+s_fitnbr+"' "
//END IF
//IF s_titnbr <> '%'  THEN
//	swhere_clause = swhere_clause + "AND D.ITNBR <= '"+s_titnbr+"' "
//END IF
//
//IF s_guout <> '0'  THEN
//	swhere_clause = swhere_clause + "AND D.GUOUT = '"+s_guout+"' "
//END IF
//
//IF s_hangu <> '%'  THEN
//	swhere_clause = swhere_clause + "AND D.HANGU = '"+s_hangu+"' "
//END IF
//
//if rb_5.Checked then 
//elseif rb_6.Checked then 
//	swhere_clause = swhere_clause + "AND I.ITGU IN ('1', '2') "
//elseif rb_7.Checked then 
//	swhere_clause = swhere_clause + "AND I.ITGU IN ('3', '4') "
//elseif rb_8.Checked then 
//	swhere_clause = swhere_clause + "AND I.ITGU =   '6' "
//elseif rb_8.Checked then 
//	swhere_clause = swhere_clause + "AND I.ITGU =   '6' "
//	
//elseif rb_9.Checked then 
//	swhere_clause = swhere_clause + "AND D.CNTGU =   '1' "	
//elseif rb_10.Checked then 
//	swhere_clause = swhere_clause + "AND D.CNTGU =   '2' "	
//end if
//
//snew_sql = sold_sql + swhere_clause
//
//dw_print.SetSqlSelect(snew_sql)
//
//
end subroutine

public subroutine wf_vndmst ();////단가마스타 (거래처별) 
//
//String s_fcvcod, s_tcvcod, s_itgu1, s_itgu2, snew_sql, sold_sql, swhere_clause, s_guout, ls_porgu, s_hangu  
//
//s_fcvcod = Trim(dw_ip.GetItemString(1, "fr_cvcod"))
//s_tcvcod = Trim(dw_ip.GetItemString(1, "to_cvcod"))	
//
//s_guout = Trim(dw_ip.GetItemString(1, "guout"))
//ls_porgu = Trim(dw_ip.GetItemString(1, "porgu"))
//s_hangu =Trim(dw_ip.GetItemString(1, "hangu"))
//
//if s_fcvcod = '' or isnull(s_fcvcod) then s_fcvcod ='%' 
//if s_tcvcod = '' or isnull(s_tcvcod) then s_tcvcod ='%' 
//
//sold_sql =   "SELECT D.*, I.ITDSC, I.ISPEC, I.JIJIL, I.ACCOD, I.ITCLS, " +&
//             "       T.TITNM, V.CVNAS, R.OPDSC, I.JEJOS , D.GONPRC , I.ISPEC_CODE, fun_get_reffpf('AD', T.PORGU ) PORGU, "+&
//				 "			I.UNMSR, FUN_GET_ITMSHT('" + gs_saupj + "', I.ITNBR) AS ITM_SHTNM, " +&
//			    "       FUN_GET_CARTYPE(D.ITNBR) AS CARTYPE " + &
//				 "  FROM DANMST D, ITEMAS I, ITNCT T, VNDMST V, ROUTNG R "+&
//				 " WHERE D.ITNBR = I.ITNBR AND    "+&
//				 "		   I.ITTYP = T.ITTYP(+) AND I.ITCLS = T.ITCLS(+) AND "+&
//				 "		   D.CVCOD = V.CVCOD(+) AND D.ITNBR = R.ITNBR(+) AND "+&
//				 "			D.OPSEQ = R.OPSEQ(+) AND (T.porgu = 'ALL' OR T.porgu like '" + ls_porgu + "%' " + ' ) '
//
//swhere_clause = " "
//
//IF s_fcvcod <> '%'  THEN
//	swhere_clause = swhere_clause + "AND D.CVCOD >= '"+s_fcvcod+"' "
//END IF
//IF s_tcvcod <> '%'  THEN
//	swhere_clause = swhere_clause + "AND D.CVCOD <= '"+s_tcvcod+"' "
//END IF
//
//IF s_guout <> '0'  THEN
//	swhere_clause = swhere_clause + "AND D.GUOUT = '"+s_guout+"' "
//END IF
//
//IF s_hangu <> '%'  THEN
//	swhere_clause = swhere_clause + "AND D.HANGU = '"+s_hangu+"' "
//END IF
//
//if rb_5.Checked then 
//elseif rb_6.Checked then 
//	swhere_clause = swhere_clause + "AND I.ITGU IN ('1', '2') "
//elseif rb_7.Checked then 
//	swhere_clause = swhere_clause + "AND I.ITGU IN ('3', '4') "
//elseif rb_8.Checked then 
//	swhere_clause = swhere_clause + "AND I.ITGU =   '6' "
//	
//elseif rb_9.Checked then 
//	swhere_clause = swhere_clause + "AND D.CNTGU =   '1' "	
//elseif rb_10.Checked then 
//	swhere_clause = swhere_clause + "AND D.CNTGU =   '2' "	
//end if
//
//snew_sql = sold_sql + swhere_clause
//
//dw_print.SetSqlSelect(snew_sql)
//
end subroutine

public function integer wf_retrieve ();String ls_porgu, ls_rfna1, ls_rfna2, s_fitnbr, s_titnbr, s_hangu, s_cvcod, e_cvcod
String ls_fr_ymd, ls_to_ymd, ls_cbx1, ls_cbx2, ls_cbx3, ls_cbx4, ls_cbx5, ls_cbx6, ls_cbx7, ls_cbx8, ls_cbx9

if dw_ip.AcceptText() = -1 then return -1

s_fitnbr = Trim(dw_ip.GetItemString(1, "fr_itnbr"))
s_titnbr = Trim(dw_ip.GetItemString(1, "to_itnbr"))
s_hangu = Trim(dw_ip.GetItemString(1, "hangu"))
s_cvcod = Trim(dw_ip.GetItemString(1, "fr_cvcod"))

if s_fitnbr = '' or isnull(s_fitnbr) then s_fitnbr ='%' 
if s_titnbr = '' or isnull(s_titnbr) then s_titnbr ='%' 
if s_cvcod = '' or isnull(s_cvcod) then s_cvcod ='%' 

ls_fr_ymd = Trim(dw_ip.GetItemString(1, "fr_ymd"))
ls_to_ymd = Trim(dw_ip.GetItemString(1, "to_ymd"))

if(cbx_2.checked = True) then
	ls_cbx1 = '1'
end if

if(cbx_3.checked = True) then
	ls_cbx2 = '2'
end if

if(cbx_4.checked = True) then
	ls_cbx3 = '3'
end if

if(cbx_5.checked = True) then
	ls_cbx4 = '4'
end if

if(cbx_6.checked = True) then
	ls_cbx5 = '5'
end if

if(cbx_7.checked = True) then
	ls_cbx6 = '6'
end if

if(cbx_8.checked = True) then
	ls_cbx7 = '7'
end if

if(cbx_9.checked = True) then
	ls_cbx8 = '8'
end if

if(cbx_10.checked = True) then
	ls_cbx9 = '9'
end if

if dw_list.Retrieve(s_fitnbr,s_titnbr,s_cvcod,s_hangu,ls_fr_ymd, ls_to_ymd, ls_cbx1,ls_cbx2,ls_cbx3,ls_cbx4,ls_cbx5,ls_cbx6,ls_cbx7,ls_cbx8,ls_cbx9) <= 0 then
	dw_ip.Setcolumn(1)
	dw_ip.Setfocus()
	return -1
end if

return 1

end function

public subroutine wf_ret ();String sDatef, sDatet,ssaupj,scvcod

if dw_ip.AcceptText() <> 1 Then Return 

sCvcod      = dw_ip.GetItemString(1,"fr_cvcod")

If IsNull(sCvcod) Or sCvcod = '' Then
	f_message_chk(1400,'[거래처]')
	dw_ip.SetFocus()
	Return 
End If

IF dw_print.Retrieve(sCvcod) <= 0 THEN
	f_message_chk(50, '')
	dw_list.Reset()
	dw_ip.setcolumn('fr_cvcod')
	dw_ip.SetFocus()
	Return 
END IF

end subroutine

on w_pdm_30010.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.cbx_1=create cbx_1
this.cbx_2=create cbx_2
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
this.cbx_5=create cbx_5
this.cbx_6=create cbx_6
this.cbx_7=create cbx_7
this.cbx_8=create cbx_8
this.cbx_9=create cbx_9
this.cbx_10=create cbx_10
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.cbx_2
this.Control[iCurrent+6]=this.cbx_3
this.Control[iCurrent+7]=this.cbx_4
this.Control[iCurrent+8]=this.cbx_5
this.Control[iCurrent+9]=this.cbx_6
this.Control[iCurrent+10]=this.cbx_7
this.Control[iCurrent+11]=this.cbx_8
this.Control[iCurrent+12]=this.cbx_9
this.Control[iCurrent+13]=this.cbx_10
end on

on w_pdm_30010.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.cbx_1)
destroy(this.cbx_2)
destroy(this.cbx_3)
destroy(this.cbx_4)
destroy(this.cbx_5)
destroy(this.cbx_6)
destroy(this.cbx_7)
destroy(this.cbx_8)
destroy(this.cbx_9)
destroy(this.cbx_10)
end on

event open;call super::open;wf_choosedw(rb_1)
dw_ip.SetFocus()

dw_ip.SetItem(1, 'fr_ymd', f_today())
dw_ip.SetItem(1, 'to_ymd', f_today())

end event

type dw_list from w_standard_print`dw_list within w_pdm_30010
integer y = 320
integer width = 4292
integer height = 1964
string dataobject = "d_pdm_30010_1"
end type

type cb_print from w_standard_print`cb_print within w_pdm_30010
end type

type cb_excel from w_standard_print`cb_excel within w_pdm_30010
end type

type cb_preview from w_standard_print`cb_preview within w_pdm_30010
end type

type cb_1 from w_standard_print`cb_1 within w_pdm_30010
end type

type dw_print from w_standard_print`dw_print within w_pdm_30010
string dataobject = "d_pdm_30010_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_30010
integer y = 56
integer width = 4292
integer height = 220
string dataobject = "d_pdm_30010"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;string  sitnbr, sitdsc, sispec, scvcod, sdate
int     ireturn
string  s_Itcls, s_Name, s_itt, snull

setnull(snull)

if this.accepttext() = -1 then return 

IF this.GetColumnName() = 'sittyp' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_itt)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'sittyp', snull)
		return 1
   end if
ELSEIF this.GetColumnName() = "fr_itcls"	THEN
	s_itcls = this.gettext()
   s_itt  = this.getitemstring(1, 'sittyp')
   ireturn = f_get_name2('품목분류', 'N', s_itcls, s_name, s_itt)
	This.setitem(1, 'fr_itcls', s_itcls)
   This.setitem(1, 'fr_nm',    s_name)
	return ireturn 
ELSEIF this.GetColumnName() = "to_itcls"	THEN
	s_itcls = this.gettext()
   s_itt  = this.getitemstring(1, 'sittyp')
   ireturn = f_get_name2('품목분류', 'N', s_itcls, s_name, s_itt)
	This.setitem(1, 'to_itcls', s_itcls)
   This.setitem(1, 'to_nm',    s_name)
	return ireturn 
ELSEIF this.GetColumnName() = "fr_cvcod"	THEN
	scvcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', scvcod, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_cvcod", scvcod)	
	this.setitem(1, "fr_cvnm", sitdsc)	
	
//	this.setitem(1, "to_cvcod", scvcod)
//	this.setitem(1, "to_cvnm" , sitdsc)
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_cvcod"	THEN
	scvcod = trim(this.GetText())
	ireturn = f_get_name2('V1', 'N', scvcod, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_cvcod", scvcod)	
	this.setitem(1, "to_cvnm", sitdsc)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[변동일자]')
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "to_date"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[변동일자]')
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "fr_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "fr_itnbr", sitnbr)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "to_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	this.setitem(1, "to_itnbr", sitnbr)	
	RETURN ireturn
ELSEIF this.GetColumnName() = "fr_ymd"	THEN
	if f_DateChk(Trim(this.getText())) = -1 then
		this.SetItem(1, "fr_ymd", sNull)
		f_Message_Chk(35, '[입고기간 FROM]')
		return 1
	end if
ELSEIF this.GetColumnName() = "to_ymd"	THEN
	if f_DateChk(Trim(this.getText())) = -1 then
		this.SetItem(1, "to_ymd", sNull)
		f_Message_Chk(35, '[입고기간 TO]')
		return 1
	end if
END IF



end event

event dw_ip::rbuttondown;string sname
str_itnct str_sitnct

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

if  this.accepttext() = -1 then return 


IF this.GetColumnName() = 'fr_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
ELSEIF this.GetColumnName() = 'to_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
ELSEIF this.GetColumnName() = "fr_cvcod" THEN
   gs_gubun = '1'	
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "fr_cvcod", gs_Code)
	this.SetItem(1, "fr_cvnm", gs_Codename)
//	this.SetItem(1, "to_cvcod", gs_code)
//	this.SetItem(1, "to_cvnm", gs_codename)
ELSEIF this.GetColumnName() = "to_cvcod" THEN
   gs_gubun = '1'	
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "to_cvcod", gs_Code)
	this.SetItem(1, "to_cvnm", gs_Codename)
ELSEIF this.GetColumnName() = 'fr_itcls' then
	sname = this.GetItemString(1, 'sittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   str_sitnct = Message.PowerObjectParm	
	
	if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"sittyp",str_sitnct.s_ittyp)
   
	this.SetItem(1,"fr_itcls", str_sitnct.s_sumgub)
	this.SetItem(1,"fr_nm", str_sitnct.s_titnm)
ELSEIF this.GetColumnName() = 'to_itcls' then
	sname = this.GetItemString(1, 'sittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   str_sitnct = Message.PowerObjectParm	
	
	if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"sittyp",str_sitnct.s_ittyp)
   
	this.SetItem(1,"to_itcls", str_sitnct.s_sumgub)
	this.SetItem(1,"to_nm", str_sitnct.s_titnm)
END IF
end event

type r_1 from w_standard_print`r_1 within w_pdm_30010
integer y = 316
integer width = 4300
end type

type r_2 from w_standard_print`r_2 within w_pdm_30010
integer width = 4300
integer height = 228
end type

type rb_1 from radiobutton within w_pdm_30010
boolean visible = false
integer x = 3767
integer y = 92
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
boolean enabled = false
string text = "none"
end type

type pb_1 from u_pic_cal within w_pdm_30010
integer x = 690
integer y = 184
integer height = 76
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('fr_ymd')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'fr_ymd', gs_code)

end event

type pb_2 from u_pic_cal within w_pdm_30010
integer x = 1166
integer y = 184
integer height = 76
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('to_ymd')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'to_ymd', gs_code)

end event

type cbx_1 from checkbox within w_pdm_30010
integer x = 1349
integer y = 196
integer width = 233
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "전체"
end type

event clicked;if (This.checked = True) then
	cbx_2.checked = True
	cbx_3.checked = True
	cbx_4.checked = True
	cbx_5.checked = True
	cbx_6.checked = True
	cbx_7.checked = True
	cbx_8.checked = True
	cbx_9.checked = True
	cbx_10.checked = True
else
	cbx_2.checked = False
	cbx_3.checked = False
	cbx_4.checked = False
	cbx_5.checked = False
	cbx_6.checked = False
	cbx_7.checked = False
	cbx_8.checked = False
	cbx_9.checked = False
	cbx_10.checked = False
end if
end event

type cbx_2 from checkbox within w_pdm_30010
integer x = 1600
integer y = 196
integer width = 251
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "완제품"
boolean checked = true
end type

event clicked;if THIS.checked = False then
	cbx_1.checked = False
end if
end event

type cbx_3 from checkbox within w_pdm_30010
integer x = 1856
integer y = 196
integer width = 251
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "반제품"
boolean checked = true
end type

event clicked;if THIS.checked = False then
	cbx_1.checked = False
end if
end event

type cbx_4 from checkbox within w_pdm_30010
integer x = 2107
integer y = 196
integer width = 251
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "원자재"
boolean checked = true
end type

event clicked;if THIS.checked = False then
	cbx_1.checked = False
end if
end event

type cbx_5 from checkbox within w_pdm_30010
integer x = 2359
integer y = 196
integer width = 251
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "부자재"
boolean checked = true
end type

event clicked;if THIS.checked = False then
	cbx_1.checked = False
end if
end event

type cbx_6 from checkbox within w_pdm_30010
integer x = 2610
integer y = 196
integer width = 251
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "저장품"
end type

event clicked;if THIS.checked = False then
	cbx_1.checked = False
end if
end event

type cbx_7 from checkbox within w_pdm_30010
integer x = 2866
integer y = 196
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "사무용품/비품"
end type

event clicked;if THIS.checked = False then
	cbx_1.checked = False
end if
end event

type cbx_8 from checkbox within w_pdm_30010
integer x = 3323
integer y = 196
integer width = 224
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "상품"
end type

event clicked;if THIS.checked = False then
	cbx_1.checked = False
end if
end event

type cbx_9 from checkbox within w_pdm_30010
integer x = 3520
integer y = 196
integer width = 251
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "가상품"
end type

event clicked;if THIS.checked = False then
	cbx_1.checked = False
end if
end event

type cbx_10 from checkbox within w_pdm_30010
integer x = 3767
integer y = 196
integer width = 210
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12639424
string text = "기타"
end type

event clicked;if THIS.checked = False then
	cbx_1.checked = False
end if
end event

