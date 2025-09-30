$PBExportHeader$w_pdm_11550.srw
$PBExportComments$품목마스타출력
forward
global type w_pdm_11550 from w_standard_print
end type
type dw_1 from datawindow within w_pdm_11550
end type
type tab_1 from tab within w_pdm_11550
end type
type tabpage_1 from userobject within tab_1
end type
type rr_2 from roundrectangle within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rr_2 rr_2
end type
type tabpage_2 from userobject within tab_1
end type
type rr_1 from roundrectangle within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rr_1 rr_1
end type
type tabpage_3 from userobject within tab_1
end type
type rr_3 from roundrectangle within tabpage_3
end type
type tabpage_3 from userobject within tab_1
rr_3 rr_3
end type
type tabpage_4 from userobject within tab_1
end type
type rr_4 from roundrectangle within tabpage_4
end type
type tabpage_4 from userobject within tab_1
rr_4 rr_4
end type
type tabpage_6 from userobject within tab_1
end type
type rr_5 from roundrectangle within tabpage_6
end type
type tabpage_6 from userobject within tab_1
rr_5 rr_5
end type
type tabpage_5 from userobject within tab_1
end type
type rr_6 from roundrectangle within tabpage_5
end type
type tabpage_5 from userobject within tab_1
rr_6 rr_6
end type
type tab_1 from tab within w_pdm_11550
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_6 tabpage_6
tabpage_5 tabpage_5
end type
type pb_1 from u_pb_cal within w_pdm_11550
end type
end forward

global type w_pdm_11550 from w_standard_print
integer height = 2632
string title = "품목마스타 현황"
boolean resizable = true
dw_1 dw_1
tab_1 tab_1
pb_1 pb_1
end type
global w_pdm_11550 w_pdm_11550

type variables
string is_gubun
str_itnct lstr_sitnct
end variables

forward prototypes
public subroutine wf_init2 ()
public subroutine wf_init3 ()
public subroutine wf_init5 ()
public subroutine wf_init1 ()
public function integer wf_retrieve ()
public function integer wf_retrieve1 ()
public function integer wf_retrieve2 ()
public function integer wf_retrieve3 ()
public function integer wf_retrieve4 ()
public function integer wf_retrieve5 ()
protected subroutine wf_choosedw ()
end prototypes

public subroutine wf_init2 ();
string	scd_min, scd_max, scd_str, snm_str, scd_end, snm_end

SELECT MIN(RPAD(I.ITNBR,15)||I.ITDSC), MAX(RPAD(I.ITNBR,15)||I.ITDSC)
  INTO :scd_min, :scd_max
  FROM ITEMAS I;

dw_ip.SetRedraw(False)
dw_ip.DataObject = 'd_pdm_11580'
dw_ip.SetTransObject(sqlca)
dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetRedraw(True)

scd_str = Trim(Mid(scd_min,1,15))
snm_str = Mid(scd_min,16,40)
scd_end = Trim(Mid(scd_max,1,15))
snm_end = Mid(scd_max,16,40)

dw_ip.SetItem(1,"itnbr", scd_str)
dw_ip.SetItem(1,"fname", snm_str)
dw_ip.SetItem(1,"ino",   scd_end)
dw_ip.SetItem(1,"tname", snm_end)

pb_1.visible = false
f_mod_saupj(dw_ip, 'porgu')

end subroutine

public subroutine wf_init3 ();String scd_min,scd_max, scd_str, snm_str, scd_end, snm_end

SELECT MIN(RPAD(I.ITNBR,15)||I.ITDSC), MAX(RPAD(I.ITNBR,15)||I.ITDSC)
  INTO :scd_min, :scd_max
  FROM ITEMAS I;

dw_ip.SetRedraw(False)
if is_Gubun = '3' then
	dw_ip.DataObject = 'd_pdm_11610'
else
	dw_ip.DataObject = 'd_pdm_11620'
end if
dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)
dw_ip.SetRedraw(True)

scd_str = Trim(Mid(scd_min,1,15))
snm_str = Mid(scd_min,16,40)
scd_end = Trim(Mid(scd_max,1,15))
snm_end = Mid(scd_max,16,40)

dw_ip.SetItem(1,"itnbr", scd_str)
dw_ip.SetItem(1,"fname", snm_str)
dw_ip.SetItem(1,"ino",   scd_end)
dw_ip.SetItem(1,"tname", snm_end)

pb_1.visible = false
f_mod_saupj(dw_ip, 'porgu')

string	sToday, sDate
sToday = f_Today()
sDate = Left(sToday,6) + '01'
dw_ip.SetItem(1,"sdate", sDate )
dw_ip.SetItem(1,"edate", sToday)

dw_ip.Setfocus()

end subroutine

public subroutine wf_init5 ();String scd_min,scd_max, scd_str, snm_str, scd_end, snm_end


SELECT MIN(RPAD(I.ITNBR,15)||I.ITDSC), MAX(RPAD(I.ITNBR,15)||I.ITDSC)
  INTO :scd_min, :scd_max
  FROM ITEMAS I;

dw_ip.SetRedraw(False)
if is_Gubun = '5' then
	dw_ip.DataObject = 'd_pdm_11590'
else
	dw_ip.DataObject = 'd_pdm_11590'
end if
dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)
dw_ip.SetRedraw(True)

scd_str = Trim(Mid(scd_min,1,15))
snm_str = Mid(scd_min,16,40)
scd_end = Trim(Mid(scd_max,1,15))
snm_end = Mid(scd_max,16,40)

dw_ip.SetItem(1,"itnbr", scd_str)
dw_ip.SetItem(1,"fname", snm_str)
dw_ip.SetItem(1,"ino",   scd_end)
dw_ip.SetItem(1,"tname", snm_end)

pb_1.visible = false
f_mod_saupj(dw_ip, 'porgu')

////
//string	sStart, sEnd, sName, eName
//SELECT MIN(RPAD(I.ITCLS,7)||I.TITNM), MAX(RPAD(I.ITCLS,7)||I.TITNM)
//  INTO :scd_min, :scd_max
//  FROM ITNCT I 
// WHERE LMSGU = 'S' ;
//
//sStart = Trim(Mid(scd_min,1,7))
//sName  = Mid(scd_min,8,65)
//sEnd   = Trim(Mid(scd_max,1,7))
//eName  = Mid(scd_max,8,65)
//
//
//dw_ip.SetItem(1,"itcls", sStart)
//dw_ip.SetItem(1,"itcls2",sEnd)
//dw_ip.SetItem(1,"sname", sName)
//dw_ip.SetItem(1,"ename", eName)
//

end subroutine

public subroutine wf_init1 ();String scd_min,scd_max, scd_str, snm_str, scd_end, snm_end


SELECT MIN(RPAD(I.ITNBR,15)||I.ITDSC), MAX(RPAD(I.ITNBR,15)||I.ITDSC)
  INTO :scd_min, :scd_max
  FROM ITEMAS I;
  
dw_ip.SetRedraw(False)
dw_ip.DataObject = 'd_pdm_11550'
dw_ip.SetTransObject(sqlca)
dw_ip.InsertRow(0)
dw_ip.SetRedraw(True)

scd_str = Trim(Mid(scd_min,1,15))
snm_str = Mid(scd_min,16,40)
scd_end = Trim(Mid(scd_max,1,15))
snm_end = Mid(scd_max,16,40)

dw_ip.SetItem(1,"itnbr", scd_str)
dw_ip.SetItem(1,"fname", snm_str)
dw_ip.SetItem(1,"ino",   scd_end)
dw_ip.SetItem(1,"tname", snm_end)

pb_1.visible = true 
f_mod_saupj(dw_ip, 'porgu')

end subroutine

public function integer wf_retrieve ();IF (is_Gubun = '1') THEN
	IF wf_retrieve1() = -1 THEN
		Return -1
	ELSE
		Return  1
	END IF
ELSEIF is_Gubun = '5' THEN
	IF wf_retrieve5() = -1 THEN
		Return -1
	ELSE
		Return  1
	END IF
ELSEIF (is_Gubun = '2') OR (is_Gubun = '6')	THEN
	IF wf_retrieve2() = -1 THEN
		Return -1
	ELSE
		Return  1
	END IF
ELSEIF is_Gubun = '3'		THEN
	IF wf_retrieve3() = -1 THEN
		Return -1
	ELSE
		Return  1
	END IF
ELSEIF is_Gubun = '4'		THEN
	IF wf_retrieve4() = -1 THEN
		Return -1
	ELSE
		Return  1
	END IF
END IF

end function

public function integer wf_retrieve1 ();string s_fitno, s_titno, s_itgu, s_min, s_max,	&
		 sStart, sEnd, cdate, smlicd, ls_porgu

if dw_ip.AcceptText() = -1 then return -1

s_fitno 	= trim(dw_ip.GetItemString(1,'itnbr'))
s_titno 	= trim(dw_ip.GetItemString(1,'ino'))
sStart 		= trim(dw_ip.GetItemString(1,'itcls'))
sEnd	 	= trim(dw_ip.GetItemString(1,'eitcls'))
s_itgu  	= trim(dw_ip.GetItemString(1,'itgu'))
smlicd  	= trim(dw_ip.GetItemString(1,'mlicd'))
ls_porgu 	= trim(dw_ip.GetItemString(1,'porgu'))

if (IsNull(s_fitno) or s_fitno = "") or (Isnull(s_titno) or s_titno = "") then
  	SELECT MIN(ITNBR), MAX(ITNBR)
    		INTO :s_min, :s_max  
    		FROM ITEMAS;
end if

IF 	Isnull(s_fitno) or s_fitno = "" then
  	s_fitno = s_min
end if  

IF 	Isnull(s_titno) or s_titno = "" then
  	s_titno = s_max
end if  

if 	s_fitno > s_titno then
   	f_message_chk(34,'[품번]')
   	dw_ip.Setfocus()
   	return -1
end if		
  

//  
if 	IsNull(sStart) or trim(sstart) = '' then
	sStart = '.'
end if	

if 	IsNull(sEnd) or trim(sEnd) = '' then
	send = 'ZZZZZZ'
end if	


//  
if 	IsNull(s_itgu) then
	s_itgu = '%'
else	
   	s_itgu =  s_itgu + '%'
end if	

cdate  = trim(dw_ip.GetItemString(1,'cdate'))

if cdate = '' or isnull(cdate) then 
	dw_1.SetFilter("")
	dw_1.filter()
else	
	dw_1.SetFilter("crt_date >= '"+ cdate +" '")
	dw_1.filter()
end if
//  -- 사업장구분.
if 	ls_porgu <> '%' then
	ls_porgu = ls_porgu + '%'
end if	
//  -- MRP대상
if 	smlicd <> '%' then
	smlicd = smlicd + '%'
end if	
	
if 	dw_print.Retrieve(ls_porgu, s_fitno, s_titno, sStart, sEnd, s_itgu, smlicd) <= 0 then
	f_message_chk(50,'[품목마스타 현황]')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_1)

return 1
end function

public function integer wf_retrieve2 ();string s_fitno, s_titno, s_itgu, s_min, s_max, cdate, ls_porgu

if dw_ip.AcceptText() = -1 then return -1 

s_fitno = trim(dw_ip.GetItemString(1,'itnbr'))
s_titno = trim(dw_ip.GetItemString(1,'ino'))
s_itgu  = trim(dw_ip.GetItemString(1,'itgu'))
ls_porgu 	= trim(dw_ip.GetItemString(1,'porgu'))

if (IsNull(s_fitno) or s_fitno = "") or (Isnull(s_titno) or s_titno = "") then
  SELECT MIN(ITNBR), MAX(ITNBR)
    INTO :s_min, :s_max  
    FROM ITEMAS;
	 
end if

IF Isnull(s_fitno) or s_fitno = "" then
  s_fitno = s_min
end if  

IF Isnull(s_titno) or s_titno = "" then
  s_titno = s_max
end if  

if s_fitno > s_titno then
   f_message_chk(34,'[품번]')
   dw_ip.Setfocus()
   return -1
end if		
  
if IsNull(s_itgu) then
	s_itgu = '%'
else	
   s_itgu = '%' + s_itgu
end if	
	
if dw_print.Retrieve(ls_porgu, s_fitno, s_titno, s_itgu) <= 0 then
	f_message_chk(50,'[품목마스타 현황]')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_1)

return 1
end function

public function integer wf_retrieve3 ();string s_fitno, s_titno, s_itgu, s_min, s_max, cdate, ls_porgu

if dw_ip.AcceptText() = -1 then return -1

s_fitno = trim(dw_ip.GetItemString(1,'itnbr'))
s_titno = trim(dw_ip.GetItemString(1,'ino'))
s_itgu  = trim(dw_ip.GetItemString(1,'itgu'))
ls_porgu 	= trim(dw_ip.GetItemString(1,'porgu'))

if (IsNull(s_fitno) or s_fitno = "") or (Isnull(s_titno) or s_titno = "") then
  SELECT MIN(ITNBR), MAX(ITNBR)
    INTO :s_min, :s_max  
    FROM ITEMAS;
	 
end if

IF Isnull(s_fitno) or s_fitno = "" then
  s_fitno = s_min
end if  

IF Isnull(s_titno) or s_titno = "" then
  s_titno = s_max
end if  

if s_fitno > s_titno then
   f_message_chk(34,'[품번]')
   dw_ip.Setfocus()
   return -1
end if		
  
  
  
// 변경일자
string	sStart, sEnd
sStart = dw_ip.GetItemString(1, "sdate")
sEnd   = dw_ip.GetItemString(1, "edate")

IF IsNull(sStart) or Trim(sStart) = ''		THEN	sStart = '0'
IF IsNull(sEnd) or Trim(sEnd) = ''			THEN	sEnd = '99999999'


if IsNull(s_itgu) then
	s_itgu = '%'
else	
   s_itgu = '%' + s_itgu
end if	
	
//// 출력구분
string	sGubun
sGubun = dw_ip.GetItemString(1, "gubun")
//
//IF (sGubun = '1') or (sGubun = '2') or (sGubun = '6') 	THEN
//	dw_1.DataObject = 'd_pdm_01611'
//ELSE
//	dw_1.DataObject = 'd_pdm_01612'
//END IF
//
//dw_1.SetTransObject(sqlca)

if dw_print.Retrieve(ls_porgu, s_fitno, s_titno, s_itgu, sStart, sEnd, sGubun) <= 0 then
	f_message_chk(50,'[품목변경현황]')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_1)

return 1
end function

public function integer wf_retrieve4 ();string s_fitno, s_titno, s_itgu, s_min, s_max, cdate, ls_porgu

if dw_ip.AcceptText() = -1 then return -1

s_fitno = trim(dw_ip.GetItemString(1,'itnbr'))
s_titno = trim(dw_ip.GetItemString(1,'ino'))
s_itgu  = trim(dw_ip.GetItemString(1,'itgu'))
ls_porgu 	= trim(dw_ip.GetItemString(1,'porgu'))

if (IsNull(s_fitno) or s_fitno = "") or (Isnull(s_titno) or s_titno = "") then
  SELECT MIN(ITNBR), MAX(ITNBR)
    INTO :s_min, :s_max  
    FROM ITEMAS;
	 
end if

IF Isnull(s_fitno) or s_fitno = "" then
  s_fitno = s_min
end if  

IF Isnull(s_titno) or s_titno = "" then
  s_titno = s_max
end if  

if s_fitno > s_titno then
   f_message_chk(34,'[품번]')
   dw_ip.Setfocus()
   return -1
end if		
  
string	sStart, sEnd
sStart = dw_ip.GetItemString(1, "sdate")
sEnd   = dw_ip.GetItemString(1, "edate")

IF IsNull(sStart) or Trim(sStart) = ''		THEN	sStart = '0'
IF IsNull(sEnd) or Trim(sEnd) = ''			THEN	sEnd = '99999999'


if IsNull(s_itgu) then
	s_itgu = '%'
else	
   s_itgu = '%' + s_itgu
end if	
if dw_print.Retrieve(ls_porgu, s_fitno, s_titno, s_itgu, sStart, sEnd) <= 0 then
	f_message_chk(50,'[안전재고]')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_1)

return 1
end function

public function integer wf_retrieve5 ();string s_fitno, s_titno, s_itgu, s_min, s_max,	&
		 sStart, sEnd, cdate, ls_porgu

if dw_ip.AcceptText() = -1 then return -1

s_fitno = trim(dw_ip.GetItemString(1,'itnbr'))
s_titno = trim(dw_ip.GetItemString(1,'ino'))
sStart = trim(dw_ip.GetItemString(1,'itcls'))
sEnd	 = trim(dw_ip.GetItemString(1,'eitcls'))
s_itgu  = trim(dw_ip.GetItemString(1,'itgu'))
ls_porgu 	= trim(dw_ip.GetItemString(1,'porgu'))

if (IsNull(s_fitno) or s_fitno = "") or (Isnull(s_titno) or s_titno = "") then
  SELECT MIN(ITNBR), MAX(ITNBR)
    INTO :s_min, :s_max  
	 FROM ITEMAS;
	 
end if

IF Isnull(s_fitno) or s_fitno = "" then
  s_fitno = s_min
end if  

IF Isnull(s_titno) or s_titno = "" then
  s_titno = s_max
end if  

if s_fitno > s_titno then
   f_message_chk(34,'[품번]')
   dw_ip.Setfocus()
   return -1
end if		
  

//  
if IsNull(sStart) or trim(sstart) = '' then
	sStart = '.'
end if	

if IsNull(sEnd) or trim(sEnd) = '' then
	send = 'ZZZZZZ'
end if	


//  
if IsNull(s_itgu) then
	s_itgu = '%'
else	
   s_itgu = '%' + s_itgu
end if	

cdate  = trim(dw_ip.GetItemString(1,'cdate'))

if cdate = '' or isnull(cdate) then 
	dw_1.SetFilter("")
	dw_1.filter()
else	
	dw_1.SetFilter("crt_date >= '"+ cdate +" '")
	dw_1.filter()
end if
	
if dw_print.Retrieve(ls_porgu, s_fitno, s_titno, sStart, sEnd, s_itgu) <= 0 then
	f_message_chk(50,'[품목마스타 현황]')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_1)

return 1
end function

protected subroutine wf_choosedw ();
string	sGubun

dw_ip.AcceptText()

sGubun = dw_ip.GetItemString(1, "gubun")


IF is_Gubun = '1'		THEN

	CHOOSE CASE sGubun
	CASE '1'
		dw_1.DataObject     = 'd_pdm_11551'
		dw_print.DataObject = 'd_pdm_11551_p'
	CASE '2'
		dw_1.DataObject     = 'd_pdm_11552'
		dw_print.DataObject = 'd_pdm_11552_p'
	CASE '3'
		dw_1.DataObject     = 'd_pdm_11553'
		dw_print.DataObject = 'd_pdm_11553_p'
	CASE '4'
		dw_1.DataObject     = 'd_pdm_11554'
		dw_print.DataObject = 'd_pdm_11554_p'
		
	END CHOOSE

END IF


IF is_Gubun = '2'		THEN

//	CHOOSE CASE sGubun
//	CASE '1'
		dw_1.DataObject     = 'd_pdm_11581'
		dw_print.DataObject = 'd_pdm_11581_p'
//	CASE '2'
//		dw_1.DataObject     = 'd_pdm_11582'
//		dw_print.DataObject = 'd_pdm_11582_p'
//	CASE '3'
//		dw_1.DataObject     = 'd_pdm_11583'
//		dw_print.DataObject = 'd_pdm_11583_p'
		
//	END CHOOSE
END IF


IF is_Gubun = '3'		THEN

	CHOOSE CASE sGubun
	CASE '1','2','6'
		dw_1.DataObject     = 'd_pdm_11611'
		dw_print.DataObject = 'd_pdm_11611_p'
	CASE	ELSE
		dw_1.DataObject     = 'd_pdm_11612'
		dw_print.DataObject = 'd_pdm_11612_p'
	END CHOOSE

END IF

IF is_Gubun = '6'		THEN

//	CHOOSE CASE sGubun
//	CASE '1'
//		dw_1.DataObject     = 'd_pdm_11581'
//		dw_print.DataObject = 'd_pdm_11581_p'
//	CASE '2'
//		dw_1.DataObject     = 'd_pdm_11582'
//		dw_print.DataObject = 'd_pdm_11582_p'
//	CASE '3'
		dw_1.DataObject     = 'd_pdm_11583'
		dw_print.DataObject = 'd_pdm_11583_p'
		
//	END CHOOSE
END IF

p_print.Enabled =False
p_preview.enabled = False

dw_1.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
end subroutine

on w_pdm_11550.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.tab_1=create tab_1
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.pb_1
end on

on w_pdm_11550.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.tab_1)
destroy(this.pb_1)
end on

event open;call super::open;is_gubun = '1'

tab_1.SelectedTab = 1

f_mod_saupj(dw_ip, 'porgu')

end event

event ue_seek;integer ipoint

//ipoint = Dec(em_split.text)

if is_preview = 'no' then

	if dw_1.object.datawindow.print.preview = "yes" then
		dw_1.object.datawindow.print.preview = "no"
	end if	
	dw_1.object.datawindow.horizontalscrollsplit			=	0
	dw_1.object.datawindow.horizontalscrollposition2	= 	0
	openwithparm(w_seek, dw_1)
//	dw_1.object.datawindow.horizontalscrollsplit			=	ipoint
//	dw_1.object.datawindow.horizontalscrollposition2	= 	ipoint
else
	Messagebox("검색", "검색할 수 있는 프로그램이 아닙니다", stopsign!)
end if
end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

type p_xls from w_standard_print`p_xls within w_pdm_11550
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

event p_xls::clicked;//
If this.Enabled Then wf_excel_down(dw_1)
end event

type p_sort from w_standard_print`p_sort within w_pdm_11550
end type

type p_preview from w_standard_print`p_preview within w_pdm_11550
end type

event p_preview::clicked;//dw_print.Reset()
//
//dw_1.RowsCopy(1, dw_1.RowCount(), Primary!, dw_print, 1, Primary!)
OpenWithParm(w_print_preview, dw_print)	

end event

type p_exit from w_standard_print`p_exit within w_pdm_11550
end type

type p_print from w_standard_print`p_print within w_pdm_11550
boolean visible = false
integer x = 4247
integer y = 184
end type

event p_print::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_1)
//OpenWithParm(w_print_options, dw_list)
end event

type p_retrieve from w_standard_print`p_retrieve within w_pdm_11550
end type

event p_retrieve::clicked;//

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event







type st_10 from w_standard_print`st_10 within w_pdm_11550
end type

type gb_10 from w_standard_print`gb_10 within w_pdm_11550
integer x = 59
integer y = 2588
integer width = 4480
integer height = 144
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_pdm_11550
integer x = 3986
integer y = 176
string dataobject = "d_pdm_11551_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdm_11550
integer x = 64
integer y = 24
integer width = 3845
integer height = 224
string dataobject = "d_pdm_11550"
end type

event dw_ip::rbuttondown;String s_colname
string	sIttyp
long nRow

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)
s_colname = GetColumnName()
nRow = GetRow()
if (s_colname = 'itnbr') or (s_colname = 'ino') then 

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	if s_colname = 'itnbr' then
		SetItem(nRow,"itnbr",gs_code)
		SetItem(nRow,"fname",gs_codename)
	elseif s_colname = 'ino' then
		SetItem(nRow,"ino",gs_code)
		SetItem(nRow,"tname",gs_codename)
	end if

end if

if this.GetColumnName() = 'itcls' then
   this.accepttext()

	sIttyp = this.GetItemString(1, 'itgu')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itgu",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetColumn('itcls')
	this.SetFocus()

end if

if this.GetColumnName() = 'eitcls' then
   this.accepttext()

	sIttyp = this.GetItemString(1, 'itgu')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itgu",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"eitcls", lstr_sitnct.s_sumgub)
	this.SetColumn('eitcls')
	this.SetFocus()

end if

end event

event dw_ip::itemchanged;string	sCode, sName, snull

setnull(snull)

//---------------------------------------------------------------------

Choose Case this.GetColumnName()
	Case	"itnbr" 
		sCode = this.GetText()

   		if sCode = '' or isnull(sCode) then 
			SetItem(1, "fname", sNull);		return; 
		end if

		SELECT ITDSC                              
	  		INTO :sName
	  		FROM ITEMAS                           
	 		WHERE ITNBR = :sCode ;                   
	 
		SetItem(1, "fname", sName)
	Case	"ino" 
		sCode = this.GetText()
   		if sCode = '' or isnull(sCode) then 
			SetItem(1, "tname", sNull);		return;
		end if

		SELECT ITDSC                              
	  		INTO :sName
	  		FROM ITEMAS                           
	 		WHERE ITNBR = :sCode ;                   
	 
		if sqlca.sqlcode = 0 then
			SetItem(1, "tname", sName);	return;
		end if
	Case	"cdate" 
		sCode = trim(this.GetText())
	
   		if sCode = '' or isnull(sCode) then return 
	 
		IF f_datechk(scode) = -1 THEN
			f_message_chk(35,'[생성일자]')
			SetItem(1, "cdate", sNull)
			return 1
		end if
	Case	"gubun" 
		wf_Choosedw()	
	Case	"h_dvalue_1" 
End Choose


//---------------------------------------------------------------------


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;string sCol
str_itnct str_sitnct

sCol = GetColumnName()
setnull(gs_code)

IF KeyDown(KeyF2!) THEN
	if sCol = "itnbr" Then
		open(w_itemas_popup4)
		if IsNull(gs_code) or gs_code = "" then return
		SetItem(1,"itnbr",gs_code)
      SetItem(1,"fname",gs_codename)		
	elseif sCol = "ino" Then
      open(w_itemas_popup4)
		if IsNull(gs_code) or gs_code = "" then return
		SetItem(1,"ino",gs_code)
      SetItem(1,"tname",gs_codename)		
	end if
	
	IF sCol = 'itcls'	THEN
		open(w_ittyp_popup3)
		
		str_sitnct = Message.PowerObjectParm
		
		if IsNull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then return
		this.SetItem(1, "itgu", str_sitnct.s_ittyp)
		this.SetItem(1, "itcls", str_sitnct.s_sumgub)
		this.SetItem(1, "sname", str_sitnct.s_titnm)
		
	END IF
		
end if	




end event

type dw_list from w_standard_print`dw_list within w_pdm_11550
boolean visible = false
integer x = 215
integer y = 2292
integer width = 178
integer height = 108
string dataobject = "d_pdm_01551"
end type

type dw_1 from datawindow within w_pdm_11550
integer x = 101
integer y = 372
integer width = 4393
integer height = 1876
integer taborder = 110
string dataobject = "d_pdm_11591"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;	is_preview = 'yes'

end event

type tab_1 from tab within w_pdm_11550
integer x = 59
integer y = 252
integer width = 4489
integer height = 2056
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean fixedwidth = true
boolean raggedright = true
boolean showpicture = false
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_6 tabpage_6
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_6=create tabpage_6
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_6,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_6)
destroy(this.tabpage_5)
end on

event selectionchanged;call super::selectionchanged;
dw_ip.SetRedraw(false)
dw_1.SetRedraw(False)
CHOOSE CASE newindex
	CASE 1		
		is_Gubun = '1'		
		dw_1.DataObject = 'd_pdm_11551'
		dw_print.DataObject = 'd_pdm_11551_p'
		
		wf_init1()				
	CASE 2
		is_Gubun = '2'
		dw_1.DataObject = 'd_pdm_11581'
		dw_print.DataObject = 'd_pdm_11581_p'
		
		wf_init2()		
	CASE 3		
		is_Gubun = '3'		
		dw_1.DataObject = 'd_pdm_11611'
		dw_print.DataObject = 'd_pdm_11611_p'
		
		wf_init3()
	CASE 4		
		is_Gubun = '4'		
		dw_1.DataObject = 'd_pdm_11621'
		dw_print.DataObject = 'd_pdm_11621_p'
		
		wf_init3()
   CASE 5		
		is_Gubun = '5'		
		dw_1.DataObject = 'd_pdm_11591'
		dw_print.DataObject = 'd_pdm_11591_p'
		
		wf_init5()
	CASE 6
		is_Gubun = '6'		
		dw_1.DataObject = 'd_pdm_11583'
		dw_print.DataObject = 'd_pdm_11583_p'
		
		wf_init2()	
END CHOOSE

dw_1.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)
		
p_print.Enabled =False
p_preview.enabled = False

p_print.PictureName ="C:\erpman\image\인쇄_d.gif"
p_preview.PictureName = "C:\erpman\image\미리보기_d.gif"

dw_ip.SetRedraw(true)
dw_1.SetRedraw(True)


end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4453
integer height = 1944
long backcolor = 32106727
string text = "일반 정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
end type

on tabpage_1.create
this.rr_2=create rr_2
this.Control[]={this.rr_2}
end on

on tabpage_1.destroy
destroy(this.rr_2)
end on

type rr_2 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 12
integer width = 4425
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4453
integer height = 1944
long backcolor = 32106727
string text = "대체품"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_1 rr_1
end type

on tabpage_2.create
this.rr_1=create rr_1
this.Control[]={this.rr_1}
end on

on tabpage_2.destroy
destroy(this.rr_1)
end on

type rr_1 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 12
integer width = 4425
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4453
integer height = 1944
long backcolor = 32106727
string text = "변경 정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
end type

on tabpage_3.create
this.rr_3=create rr_3
this.Control[]={this.rr_3}
end on

on tabpage_3.destroy
destroy(this.rr_3)
end on

type rr_3 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 12
integer width = 4425
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4453
integer height = 1944
long backcolor = 32106727
string text = "안전재고"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_4 rr_4
end type

on tabpage_4.create
this.rr_4=create rr_4
this.Control[]={this.rr_4}
end on

on tabpage_4.destroy
destroy(this.rr_4)
end on

type rr_4 from roundrectangle within tabpage_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 12
integer width = 4425
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4453
integer height = 1944
long backcolor = 32106727
string text = "ABC분류"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_5 rr_5
end type

on tabpage_6.create
this.rr_5=create rr_5
this.Control[]={this.rr_5}
end on

on tabpage_6.destroy
destroy(this.rr_5)
end on

type rr_5 from roundrectangle within tabpage_6
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 12
integer width = 4425
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4453
integer height = 1944
long backcolor = 32106727
string text = "관리품번"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_6 rr_6
end type

on tabpage_5.create
this.rr_6=create rr_6
this.Control[]={this.rr_6}
end on

on tabpage_5.destroy
destroy(this.rr_6)
end on

type rr_6 from roundrectangle within tabpage_5
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 12
integer width = 4425
integer height = 1908
integer cornerheight = 40
integer cornerwidth = 55
end type

type pb_1 from u_pb_cal within w_pdm_11550
integer x = 3040
integer y = 120
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('cdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'cdate', gs_code)

end event

