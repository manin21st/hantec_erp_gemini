$PBExportHeader$w_pdm_11640.srw
$PBExportComments$단가마스타출력
forward
global type w_pdm_11640 from w_standard_print
end type
type rb_1 from radiobutton within w_pdm_11640
end type
type rb_2 from radiobutton within w_pdm_11640
end type
type rb_3 from radiobutton within w_pdm_11640
end type
type rb_4 from radiobutton within w_pdm_11640
end type
type rb_5 from radiobutton within w_pdm_11640
end type
type rb_6 from radiobutton within w_pdm_11640
end type
type rb_7 from radiobutton within w_pdm_11640
end type
type rb_8 from radiobutton within w_pdm_11640
end type
type st_1 from statictext within w_pdm_11640
end type
type rb_9 from radiobutton within w_pdm_11640
end type
type rb_10 from radiobutton within w_pdm_11640
end type
type rb_11 from radiobutton within w_pdm_11640
end type
type gb_4 from groupbox within w_pdm_11640
end type
type gb_1 from groupbox within w_pdm_11640
end type
end forward

global type w_pdm_11640 from w_standard_print
integer width = 4677
integer height = 2752
string title = "구매/외주 단가마스타 출력"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
rb_7 rb_7
rb_8 rb_8
st_1 st_1
rb_9 rb_9
rb_10 rb_10
rb_11 rb_11
gb_4 gb_4
gb_1 gb_1
end type
global w_pdm_11640 w_pdm_11640

forward prototypes
public subroutine wf_choosedw (radiobutton rabutton)
public subroutine wf_history ()
public subroutine wf_itcls ()
public subroutine wf_itemas ()
public subroutine wf_vndmst ()
public function integer wf_retrieve ()
public subroutine wf_ret ()
end prototypes

public subroutine wf_choosedw (radiobutton rabutton);string rname

rname = raButton.Classname()	
if rname = "rb_1" then
	dw_ip.DataObject = "d_pdm_11640"
	dw_list.DataObject = "d_pdm_11641"
	dw_print.DataObject = "d_pdm_11641_p"
elseif rname = "rb_2" then	
	dw_ip.DataObject = "d_pdm_11640_2"
	dw_list.DataObject = "d_pdm_11642"
	dw_print.DataObject = "d_pdm_11642_p"
elseif rname = "rb_3" then	
	dw_ip.DataObject = "d_pdm_11640_1"
	dw_list.DataObject = "d_pdm_11643"
	dw_print.DataObject = "d_pdm_11643_p"
elseif rname = "rb_4" then	
	dw_ip.DataObject = "d_pdm_11640_3"
	dw_list.DataObject = "d_pdm_11644"
	dw_print.DataObject = "d_pdm_11644_p"
elseif rname = "rb_11" then	
	dw_ip.DataObject = "d_pdm_11645_2"
	dw_list.DataObject = "d_pdm_11645"
	dw_print.DataObject = "d_pdm_11645_p"
end if
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_ip.insertrow(0)

//----- 사업장 확인..
f_mod_saupj(dw_ip, 'porgu')
//-----------------------------------------------------------------//
dw_ip.SetColumn(1)
dw_ip.Setfocus()

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

if rb_5.Checked then 
elseif rb_6.Checked then 
	swhere_clause = swhere_clause + "AND I.ITGU IN ('1', '2') "
elseif rb_7.Checked then 
	swhere_clause = swhere_clause + "AND I.ITGU IN ('3', '4') "
else
	swhere_clause = swhere_clause + "AND I.ITGU =   '6' "	
end if

snew_sql = sold_sql + swhere_clause

dw_print.SetSqlSelect(snew_sql)

end subroutine

public subroutine wf_itcls ();//단가마스타 (품목분류별) 

String s_ittyp, s_fitcls, s_titcls, s_itgu1, s_itgu2, snew_sql, sold_sql, swhere_clause ,&
       s_guout, ls_porgu, s_hangu

s_ittyp  = Trim(dw_ip.GetItemString(1, "sittyp"))
s_fitcls = Trim(dw_ip.GetItemString(1, "fr_itcls"))
s_titcls = Trim(dw_ip.GetItemString(1, "to_itcls"))
s_guout = Trim(dw_ip.GetItemString(1, "guout"))
ls_porgu = Trim(dw_ip.GetItemString(1, "porgu"))
s_hangu	= Trim(dw_ip.GetItemString(1, "hangu"))

if s_ittyp = '' or isnull(s_ittyp) then s_ittyp ='%' 
if s_fitcls = '' or isnull(s_fitcls) then s_fitcls ='%' 
if s_titcls = '' or isnull(s_titcls) then s_titcls ='%' 

sold_sql =   "SELECT D.*, I.ITDSC, I.ISPEC, I.JIJIL, I.ACCOD, I.ITCLS, I.ITTYP," +&
             "       T.TITNM, V.CVNAS, R.OPDSC, I.JEJOS , D.GONPRC , I.ISPEC_CODE, fun_get_reffpf('AD', T.PORGU ) PORGU, "+&
				 "			I.UNMSR, FUN_GET_ITMSHT('" + gs_saupj + "', I.ITNBR) AS ITM_SHTNM, " +&
			    "       FUN_GET_CARTYPE(D.ITNBR) AS CARTYPE " + &
				 "  FROM DANMST D, ITEMAS I, ITNCT T, VNDMST V, ROUTNG R "+&				 
				 " WHERE D.ITNBR = I.ITNBR AND    "+&
				 "		   I.ITTYP = T.ITTYP(+) AND I.ITCLS = T.ITCLS(+) AND "+&
				 "		   D.CVCOD = V.CVCOD(+) AND D.ITNBR = R.ITNBR(+) AND "+&
				 "			D.OPSEQ = R.OPSEQ(+) AND (T.porgu = 'ALL' OR T.porgu like '" + ls_porgu + "%' " + ' ) '

swhere_clause = " "

IF s_ittyp <> '%'  THEN
	swhere_clause = swhere_clause + "AND I.ITTYP = '"+s_ittyp+"' "
END IF
IF s_fitcls <> '%'  THEN
	swhere_clause = swhere_clause + "AND I.ITCLS >= '"+s_fitcls+"' "
END IF
IF s_titcls <> '%'  THEN
	swhere_clause = swhere_clause + "AND I.ITCLS <= '"+s_titcls+"' "
END IF

IF s_guout <> '0'  THEN
	swhere_clause = swhere_clause + "AND D.GUOUT = '"+s_guout+"' "
END IF

IF s_hangu <> '%'  THEN
	swhere_clause = swhere_clause + "AND D.HANGU = '"+s_hangu+"' "
END IF


if rb_5.Checked then 
elseif rb_6.Checked then 
	swhere_clause = swhere_clause + "AND I.ITGU IN ('1', '2') "
elseif rb_7.Checked then 
	swhere_clause = swhere_clause + "AND I.ITGU IN ('3', '4') "
elseif rb_8.Checked then 
	swhere_clause = swhere_clause + "AND I.ITGU =   '6' "
	
elseif rb_9.Checked then 
	swhere_clause = swhere_clause + "AND D.CNTGU =   '1' "	
elseif rb_10.Checked then 
	swhere_clause = swhere_clause + "AND D.CNTGU =   '2' "	
end if

snew_sql = sold_sql + swhere_clause

dw_print.SetSqlSelect(snew_sql)

end subroutine

public subroutine wf_itemas ();//단가마스타 (품목별) 

String s_ittyp, s_fitnbr, s_titnbr, s_itgu1, s_itgu2, snew_sql, sold_sql, swhere_clause, &
       s_guout, ls_porgu,  s_hangu

s_ittyp  = Trim(dw_ip.GetItemString(1, "sittyp"))
s_fitnbr = Trim(dw_ip.GetItemString(1, "fr_itnbr"))
s_titnbr = Trim(dw_ip.GetItemString(1, "to_itnbr"))
s_guout = Trim(dw_ip.GetItemString(1, "guout"))
ls_porgu = Trim(dw_ip.GetItemString(1, "porgu"))
s_hangu = Trim(dw_ip.GetItemString(1, "hangu"))

if s_ittyp = '' or isnull(s_ittyp) then s_ittyp ='%' 
if s_fitnbr = '' or isnull(s_fitnbr) then s_fitnbr ='%' 
if s_titnbr = '' or isnull(s_titnbr) then s_titnbr ='%' 

sold_sql =   "SELECT D.*, I.ITDSC, I.ISPEC, I.JIJIL, I.ACCOD, I.ITCLS, I.ITTYP," +&
             "       T.TITNM, V.CVNAS, R.OPDSC, I.JEJOS , D.GONPRC, I.ISPEC_CODE, fun_get_reffpf('AD', T.PORGU ) PORGU,  "+&
				 "       I.UNMSR, FUN_GET_ITMSHT(' " + gs_saupj + "', I.ITNBR) AS ITM_SHTNM, " + &
			    "       FUN_GET_CARTYPE(D.ITNBR) AS CARTYPE " + &
				 "  FROM DANMST D, ITEMAS I, ITNCT T, VNDMST V, ROUTNG R "+&
				 " WHERE D.ITNBR = I.ITNBR AND    "+&
				 "		   I.ITTYP = T.ITTYP(+) AND I.ITCLS = T.ITCLS(+) AND "+&
				 "		   D.CVCOD = V.CVCOD(+) AND D.ITNBR = R.ITNBR(+) AND "+&
				 "			D.OPSEQ = R.OPSEQ(+) AND (T.porgu = 'ALL' OR T.porgu like '" + ls_porgu + "%' " + ' ) '

swhere_clause = " "

IF s_ittyp <> '%'  THEN
	swhere_clause = swhere_clause + "AND I.ITTYP = '"+s_ittyp+"' "
END IF
IF s_fitnbr <> '%'  THEN
	swhere_clause = swhere_clause + "AND D.ITNBR >= '"+s_fitnbr+"' "
END IF
IF s_titnbr <> '%'  THEN
	swhere_clause = swhere_clause + "AND D.ITNBR <= '"+s_titnbr+"' "
END IF

IF s_guout <> '0'  THEN
	swhere_clause = swhere_clause + "AND D.GUOUT = '"+s_guout+"' "
END IF

IF s_hangu <> '%'  THEN
	swhere_clause = swhere_clause + "AND D.HANGU = '"+s_hangu+"' "
END IF

if rb_5.Checked then 
elseif rb_6.Checked then 
	swhere_clause = swhere_clause + "AND I.ITGU IN ('1', '2') "
elseif rb_7.Checked then 
	swhere_clause = swhere_clause + "AND I.ITGU IN ('3', '4') "
elseif rb_8.Checked then 
	swhere_clause = swhere_clause + "AND I.ITGU =   '6' "
elseif rb_8.Checked then 
	swhere_clause = swhere_clause + "AND I.ITGU =   '6' "
	
elseif rb_9.Checked then 
	swhere_clause = swhere_clause + "AND D.CNTGU =   '1' "	
elseif rb_10.Checked then 
	swhere_clause = swhere_clause + "AND D.CNTGU =   '2' "	
end if

snew_sql = sold_sql + swhere_clause

dw_print.SetSqlSelect(snew_sql)


end subroutine

public subroutine wf_vndmst ();//단가마스타 (거래처별) 

String s_fcvcod, s_tcvcod, s_itgu1, s_itgu2, snew_sql, sold_sql, swhere_clause, s_guout, ls_porgu, s_hangu  

s_fcvcod = Trim(dw_ip.GetItemString(1, "fr_cvcod"))
s_tcvcod = Trim(dw_ip.GetItemString(1, "to_cvcod"))	

s_guout = Trim(dw_ip.GetItemString(1, "guout"))
ls_porgu = Trim(dw_ip.GetItemString(1, "porgu"))
s_hangu =Trim(dw_ip.GetItemString(1, "hangu"))

if s_fcvcod = '' or isnull(s_fcvcod) then s_fcvcod ='%' 
if s_tcvcod = '' or isnull(s_tcvcod) then s_tcvcod ='%' 

sold_sql =   "SELECT D.*, I.ITDSC, I.ISPEC, I.JIJIL, I.ACCOD, I.ITCLS, " +&
             "       T.TITNM, V.CVNAS, R.OPDSC, I.JEJOS , D.GONPRC , I.ISPEC_CODE, fun_get_reffpf('AD', T.PORGU ) PORGU, "+&
				 "			I.UNMSR, FUN_GET_ITMSHT('" + gs_saupj + "', I.ITNBR) AS ITM_SHTNM, " +&
			    "       FUN_GET_CARTYPE(D.ITNBR) AS CARTYPE " + &
				 "  FROM DANMST D, ITEMAS I, ITNCT T, VNDMST V, ROUTNG R "+&
				 " WHERE D.ITNBR = I.ITNBR AND    "+&
				 "		   I.ITTYP = T.ITTYP(+) AND I.ITCLS = T.ITCLS(+) AND "+&
				 "		   D.CVCOD = V.CVCOD(+) AND D.ITNBR = R.ITNBR(+) AND "+&
				 "			D.OPSEQ = R.OPSEQ(+) AND (T.porgu = 'ALL' OR T.porgu like '" + ls_porgu + "%' " + ' ) '

swhere_clause = " "

IF s_fcvcod <> '%'  THEN
	swhere_clause = swhere_clause + "AND D.CVCOD >= '"+s_fcvcod+"' "
END IF
IF s_tcvcod <> '%'  THEN
	swhere_clause = swhere_clause + "AND D.CVCOD <= '"+s_tcvcod+"' "
END IF

IF s_guout <> '0'  THEN
	swhere_clause = swhere_clause + "AND D.GUOUT = '"+s_guout+"' "
END IF

IF s_hangu <> '%'  THEN
	swhere_clause = swhere_clause + "AND D.HANGU = '"+s_hangu+"' "
END IF

if rb_5.Checked then 
elseif rb_6.Checked then 
	swhere_clause = swhere_clause + "AND I.ITGU IN ('1', '2') "
elseif rb_7.Checked then 
	swhere_clause = swhere_clause + "AND I.ITGU IN ('3', '4') "
elseif rb_8.Checked then 
	swhere_clause = swhere_clause + "AND I.ITGU =   '6' "
	
elseif rb_9.Checked then 
	swhere_clause = swhere_clause + "AND D.CNTGU =   '1' "	
elseif rb_10.Checked then 
	swhere_clause = swhere_clause + "AND D.CNTGU =   '2' "	
end if

snew_sql = sold_sql + swhere_clause

dw_print.SetSqlSelect(snew_sql)

end subroutine

public function integer wf_retrieve ();String ls_porgu, ls_rfna1, ls_rfna2

if dw_ip.AcceptText() = -1 then return -1

if rb_1.Checked then 
	wf_itemas()
elseif rb_2.Checked then 
	wf_vndmst()
elseif rb_3.Checked then 
	wf_itcls()
elseif rb_11.Checked then 
	wf_ret()
	dw_print.sharedata(dw_list)
   return 1
else
	wf_history()
end if

/////////////////////////////////////////////////////////////////////////
if dw_print.Retrieve() <= 0 then
	if rb_1.Checked then 
		f_message_chk(50,'[단가마스타(품목별)]')
	elseif rb_2.Checked then
		f_message_chk(50,'[단가마스타(거래처별)]')
	elseif rb_11.Checked then
		f_message_chk(50,'[단가마스타(납입조정)]')
	elseif rb_3.Checked then
		f_message_chk(50,'[단가마스타(품목분류별)]')
	else
		f_message_chk(50,'[단가변경이력]')
	end if	
	dw_ip.Setcolumn(1)
	dw_ip.Setfocus()
	return -1
end if

//조회 조건에서 사업장 추가 시작
ls_porgu = dw_ip.getItemString(1, "porgu")

SELECT "REFFPF"."RFNA1"  ,
       "REFFPF"."RFGUB"
Into :ls_rfna1, :ls_rfna2
FROM "REFFPF"  
WHERE ( "REFFPF"."SABU" = '1' ) AND  
      ( "REFFPF"."RFCOD" = 'AD' ) AND  
     ( "REFFPF"."RFGUB" NOT IN ('00','99') )
AND "REFFPF"."RFGUB" = :ls_porgu;

if ls_porgu ='%' Then
	dw_print.object.t_100.text = '전체'
ElseIf ls_porgu = ls_rfna2 Then
	dw_print.object.t_100.text = ls_rfna1
End If
//조회 조건에서 사업장 추가 끝

dw_print.sharedata(dw_list)

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

on w_pdm_11640.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.rb_7=create rb_7
this.rb_8=create rb_8
this.st_1=create st_1
this.rb_9=create rb_9
this.rb_10=create rb_10
this.rb_11=create rb_11
this.gb_4=create gb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.rb_5
this.Control[iCurrent+6]=this.rb_6
this.Control[iCurrent+7]=this.rb_7
this.Control[iCurrent+8]=this.rb_8
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.rb_9
this.Control[iCurrent+11]=this.rb_10
this.Control[iCurrent+12]=this.rb_11
this.Control[iCurrent+13]=this.gb_4
this.Control[iCurrent+14]=this.gb_1
end on

on w_pdm_11640.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.rb_7)
destroy(this.rb_8)
destroy(this.st_1)
destroy(this.rb_9)
destroy(this.rb_10)
destroy(this.rb_11)
destroy(this.gb_4)
destroy(this.gb_1)
end on

event open;call super::open;wf_choosedw(rb_1)
dw_ip.SetFocus()


end event

type dw_list from w_standard_print`dw_list within w_pdm_11640
integer y = 464
integer width = 4590
integer height = 1964
string dataobject = "d_pdm_11641"
end type

type cb_print from w_standard_print`cb_print within w_pdm_11640
integer x = 3013
integer y = 2512
end type

type cb_excel from w_standard_print`cb_excel within w_pdm_11640
integer x = 2345
integer y = 2512
end type

type cb_preview from w_standard_print`cb_preview within w_pdm_11640
integer x = 2679
integer y = 2512
end type

type cb_1 from w_standard_print`cb_1 within w_pdm_11640
integer x = 2011
integer y = 2512
end type

type dw_print from w_standard_print`dw_print within w_pdm_11640
integer x = 192
integer y = 2468
string dataobject = "d_pdm_11641_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11640
integer y = 324
integer width = 4590
integer height = 104
string dataobject = "d_pdm_11640_2"
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
	
	this.setitem(1, "to_cvcod", scvcod)
	this.setitem(1, "to_cvnm" , sitdsc)
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
	this.SetItem(1, "to_cvcod", gs_code)
	this.SetItem(1, "to_cvnm", gs_codename)
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

type r_1 from w_standard_print`r_1 within w_pdm_11640
integer y = 460
integer width = 4598
end type

type r_2 from w_standard_print`r_2 within w_pdm_11640
integer y = 320
integer width = 4598
integer height = 112
end type

type rb_1 from radiobutton within w_pdm_11640
integer x = 110
integer y = 220
integer width = 608
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "단가마스타(품목별)"
boolean checked = true
end type

event clicked;wf_choosedw(this)
end event

type rb_2 from radiobutton within w_pdm_11640
integer x = 722
integer y = 220
integer width = 663
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "단가마스타(거래처별)"
end type

event clicked;wf_choosedw(this)
end event

type rb_3 from radiobutton within w_pdm_11640
integer x = 1390
integer y = 220
integer width = 718
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "단가마스타(품목분류별)"
end type

event clicked;wf_choosedw(this)
end event

type rb_4 from radiobutton within w_pdm_11640
integer x = 2112
integer y = 220
integer width = 443
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "단가변경이력"
end type

event clicked;wf_choosedw(this)
end event

type rb_5 from radiobutton within w_pdm_11640
integer x = 119
integer y = 68
integer width = 288
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = " 전  체"
boolean checked = true
end type

type rb_6 from radiobutton within w_pdm_11640
integer x = 421
integer y = 68
integer width = 603
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = " 내자구매/내자외주"
end type

type rb_7 from radiobutton within w_pdm_11640
integer x = 1033
integer y = 68
integer width = 594
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = " 외자구매/외자외주"
end type

type rb_8 from radiobutton within w_pdm_11640
integer x = 1641
integer y = 68
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = " 외  주"
end type

type st_1 from statictext within w_pdm_11640
integer x = 2075
integer y = 76
integer width = 242
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "계약형태"
boolean focusrectangle = false
end type

type rb_9 from radiobutton within w_pdm_11640
integer x = 2313
integer y = 68
integer width = 242
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "계 약"
end type

type rb_10 from radiobutton within w_pdm_11640
integer x = 2597
integer y = 68
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "미계약"
end type

type rb_11 from radiobutton within w_pdm_11640
integer x = 2574
integer y = 216
integer width = 663
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "단가마스타(납입조정)"
end type

event clicked;wf_choosedw(this)
end event

type gb_4 from groupbox within w_pdm_11640
integer x = 37
integer y = 16
integer width = 3081
integer height = 140
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "품목마스타 구입형태"
end type

type gb_1 from groupbox within w_pdm_11640
integer x = 37
integer y = 172
integer width = 3378
integer height = 140
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
string text = "출력내용"
end type

