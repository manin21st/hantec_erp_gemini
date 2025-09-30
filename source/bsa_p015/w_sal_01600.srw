$PBExportHeader$w_sal_01600.srw
$PBExportComments$===> 성장율 현황
forward
global type w_sal_01600 from w_standard_print
end type
type tab_1 from tab within w_sal_01600
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_4 dw_4
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from datawindow within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
end type
type tabpage_6 from userobject within tab_1
end type
type dw_6 from datawindow within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_6 dw_6
end type
type tab_1 from tab within w_sal_01600
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
end forward

global type w_sal_01600 from w_standard_print
string title = "성장율현황"
tab_1 tab_1
end type
global w_sal_01600 w_sal_01600

type variables
string is_gubun
str_itnct lstr_sitnct
boolean s_p1,s_p2,s_p3,s_p4,s_p5,s_p6
string s_syy, s_s1fyy , s_s4fyy, s_sfmm , s_stmm 
string s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm
string s_svndcod, s_svndnm, s_spteam, s_spteamnm
string s_sittyp, s_sitcls, s_sitname, s_itnbr, s_itdsc
string s_cvcod, s_cvcodnm
end variables

forward prototypes
public function integer wf_retrieve1 ()
public function integer wf_retrieve2 ()
public function integer wf_retrieve3 ()
public function integer wf_retrieve4 ()
public function integer wf_retrieve5 ()
public function integer wf_retrieve6 ()
public function integer wf_datacheck ()
end prototypes

public function integer wf_retrieve1 ();														
if tab_1.tabpage_1.dw_1.Retrieve(s_syy,s_s1fyy, s_s4fyy, s_sfmm, s_stmm , &
                           s_spteam,s_spteamnm,s_sittyp, s_sitcls, s_sitname, s_itnbr+'%') <= 0 then
	f_message_chk(50,'[영업팀별 성장율 현황]')
	dw_ip.setcolumn('syy')
	dw_ip.Setfocus()
   p_print.Enabled =False
	s_p1 = False
   SetPointer(Arrow!)
	return -1
else
	tab_1.tabpage_1.dw_1.Modify("txt_itnbr.text = '"+s_itdsc+"'")
	
	p_print.Enabled =True
	s_p1 = True
//	tab_1.tabpage_1.dw_1.object.datawindow.print.preview="yes"
	gi_page = tab_1.tabpage_1.dw_1.GetItemNumber(1,"last_page")
	tab_1.tabpage_1.dw_1.scrolltorow(1)
end if

return 1

end function

public function integer wf_retrieve2 ();
if tab_1.tabpage_2.dw_2.Retrieve(s_syy, s_s1fyy, s_s4fyy, s_sfmm, s_stmm, &
                                 s_ssteam, s_ssteamnm , s_spteam, s_spteamnm, &
											s_sittyp, s_sitcls, s_sitname, s_itnbr+'%') <= 0 then
	f_message_chk(50,'[관할구역별 성장율 현황]')
	dw_ip.setcolumn('syy')
	dw_ip.Setfocus()
   p_print.Enabled =False
	s_p2 = False
   SetPointer(Arrow!)
	return -1
else
	tab_1.tabpage_2.dw_2.Modify("txt_itnbr.text = '"+s_itdsc+"'")

	p_print.Enabled =True
	s_p2 = True
//	tab_1.tabpage_2.dw_2.object.datawindow.print.preview="yes"
	gi_page = tab_1.tabpage_2.dw_2.GetItemNumber(1,"last_page")
	tab_1.tabpage_2.dw_2.scrolltorow(1)
end if

return 1

end function

public function integer wf_retrieve3 ();														
if tab_1.tabpage_3.dw_3.Retrieve(s_syy, s_s1fyy, s_s4fyy, s_sfmm, s_stmm, & 
                                 s_ssteam, s_ssteamnm,s_ssarea, s_ssareanm, &
											s_cvcod, &
											s_spteam,s_spteamnm, &
                                 s_sittyp, s_sitcls, s_sitname, s_itnbr+'%') <= 0 then
	f_message_chk(50,'[거래처별 성장율 현황]')
	dw_ip.setcolumn('syy')
	dw_ip.Setfocus()
   p_print.Enabled =False
	s_p3 = False
   SetPointer(Arrow!)
	return -1
else
	tab_1.tabpage_3.dw_3.Modify("txt_itnbr.text = '"+s_itdsc+"'")
	tab_1.tabpage_3.dw_3.Modify("txt_cvcod.text = '"+s_cvcodnm+"'")
	
	p_print.Enabled =True
	s_p3 = True
//	tab_1.tabpage_3.dw_3.object.datawindow.print.preview="yes"
	gi_page = tab_1.tabpage_3.dw_3.GetItemNumber(1,"last_page")
	tab_1.tabpage_3.dw_3.scrolltorow(1)
end if

return 1

end function

public function integer wf_retrieve4 ();														
if tab_1.tabpage_4.dw_4.Retrieve(s_syy, s_s1fyy, s_s4fyy, s_sfmm, s_stmm, & 
                                 s_ssteam, s_ssteamnm, s_ssarea, s_ssareanm, s_cvcod, & 
											s_spteam,s_spteamnm, &
											s_sittyp, s_sitcls, s_sitname, s_itnbr) <= 0 then
	f_message_chk(50,'[제품군별 성장율 현황]')
	dw_ip.setcolumn('syy')
	dw_ip.Setfocus()
   p_print.Enabled =False
	s_p4 = False
   SetPointer(Arrow!)
	return -1
else
	tab_1.tabpage_4.dw_4.Modify("txt_itnbr.text = '"+s_itdsc+"'")
	tab_1.tabpage_4.dw_4.Modify("txt_cvcod.text = '"+s_cvcodnm+"'")
	
	p_print.Enabled =True
	s_p4 = True
//	tab_1.tabpage_4.dw_4.object.datawindow.print.preview="yes"
	gi_page = tab_1.tabpage_4.dw_4.GetItemNumber(1,"last_page")
	tab_1.tabpage_4.dw_4.scrolltorow(1)
end if

return 1

end function

public function integer wf_retrieve5 ();														
if tab_1.tabpage_5.dw_5.Retrieve(s_syy, s_s1fyy, s_s4fyy, s_sfmm, s_stmm, &
                                 s_ssteam, s_ssteamnm, s_ssarea, s_ssareanm, s_cvcod ,&
											s_spteam,s_spteamnm, &
                                 s_sittyp, s_sitcls, s_sitname, s_itnbr) <= 0 then
	f_message_chk(50,'[시리즈별 성장율 현황]')
	dw_ip.setcolumn('syy')
	dw_ip.Setfocus()
   p_print.Enabled =False
	s_p5 = False
   SetPointer(Arrow!)
	return -1
else
	tab_1.tabpage_5.dw_5.Modify("txt_itnbr.text = '"+s_itdsc+"'")
	tab_1.tabpage_5.dw_5.Modify("txt_cvcod.text = '"+s_cvcodnm+"'")
	
	p_print.Enabled =True
	s_p5 = True
//	tab_1.tabpage_5.dw_5.object.datawindow.print.preview="yes"
	gi_page = tab_1.tabpage_5.dw_5.GetItemNumber(1,"last_page")
	tab_1.tabpage_5.dw_5.scrolltorow(1)
end if

return 1

end function

public function integer wf_retrieve6 ();														
if tab_1.tabpage_6.dw_6.Retrieve(s_syy, s_s1fyy, s_s4fyy, s_sfmm, s_stmm, &
                                 s_ssteam, s_ssteamnm, & 
                                 s_ssarea, s_ssareanm, s_cvcod, s_spteam,s_spteamnm, &
                                 s_sittyp, s_sitcls, s_sitname, s_itnbr) <= 0 then
	f_message_chk(50,'[제품별 성장율 현황]')
	dw_ip.setcolumn('syy')
	dw_ip.Setfocus()
   p_print.Enabled =False
	s_p6 = False
   SetPointer(Arrow!)
	return -1
else
	tab_1.tabpage_6.dw_6.Modify("txt_itnbr.text = '"+s_itdsc+"'")
	tab_1.tabpage_6.dw_6.Modify("txt_cvcod.text = '"+s_cvcodnm+"'")
	
	p_print.Enabled =True
	s_p6 = True
//	tab_1.tabpage_6.dw_6.object.datawindow.print.preview="yes"
	gi_page = tab_1.tabpage_6.dw_6.GetItemNumber(1,"last_page")
	tab_1.tabpage_6.dw_6.scrolltorow(1)
end if

return 1
end function

public function integer wf_datacheck ();If dw_ip.AcceptText() <> 1 then Return -1

s_syy     = trim(dw_ip.GetItemString(1,'syy'))
s_s4fyy   = string(integer(s_syy) - 5,'0000')
s_s1fyy   = string(integer(s_syy) - 1,'0000')
s_syy     = string(integer(s_syy),'0000')
s_sfmm    = trim(dw_ip.GetItemString(1,'sfmm'))
s_sfmm    = string(integer(s_sfmm),'00')
s_stmm    = trim(dw_ip.GetItemString(1,'stmm'))
s_stmm    = string(integer(s_stmm),'00')
s_ssteam  = trim(dw_ip.GetItemString(1,'ssteam'))
s_ssarea  = trim(dw_ip.GetItemString(1,'ssarea'))
s_spteam  = trim(dw_ip.GetItemString(1,'spteam'))
s_sittyp  = trim(dw_ip.GetItemString(1,'ittyp'))
s_sitcls  = trim(dw_ip.GetItemString(1,'itcls'))
s_sitname = trim(dw_ip.GetItemString(1,'itclsnm'))
s_itnbr   = trim(dw_ip.GetItemString(1,'itnbr'))
s_cvcod   = trim(dw_ip.GetItemString(1,'custcode'))
s_cvcodnm = trim(dw_ip.GetItemString(1,'custname'))

if	(s_syy='') or isNull(s_syy) or s_syy < '1990' then           //계획년도 CHECK
	f_Message_Chk(35, '[계획년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1
end if

//판매시작월 CHECK
if	(s_sfmm ='') or isNull(s_sfmm) or integer(s_sfmm) = 0 or integer(s_sfmm) > 12 then
	f_Message_Chk(35, '[판매시작월]')
	dw_ip.setcolumn('sfmm')
	dw_ip.setfocus()
	Return -1
//판매종료월 CHECK
elseif	(s_stmm ='') or isNull(s_stmm) or integer(s_stmm) = 0 or integer(s_stmm) > 12 then
	f_Message_Chk(35, '[판매종료월]')
	dw_ip.setcolumn('stmm')
	dw_ip.setfocus()
	Return -1
elseif	integer(s_stmm) < integer(s_sfmm) then
	f_Message_Chk(35, '[판매시작월]')
	dw_ip.setcolumn('sfmm')
	dw_ip.setfocus()
	Return -1
end if

if s_ssteam = "" or IsNull(s_ssteam) then     // 영업팀처리
	s_ssteam = '%'
	s_ssteamnm = '전  체'
else
   SELECT STEAMNM
     INTO :s_ssteamnm  
     FROM STEAM
	 WHERE STEAMCD = :s_ssteam;
end if	

if s_ssarea = "" or IsNull(s_ssarea) then     // 관할구역처리
	s_ssarea = '%'
	s_ssareanm = '전  체'
else
   SELECT SAREANM
     INTO :s_ssareanm  
     FROM SAREA
	 WHERE SAREA = :s_ssarea;
end if

if s_spteam = "" or IsNull(s_spteam) then     // 생산팀 처리
	s_spteam = '%'
	s_spteamnm = '전  체'
else
   SELECT RFNA1
     INTO :s_spteamnm 
     FROM REFFPF
	 WHERE RFCOD = '03'  AND
	       SABU  = '1'   AND
			 RFGUB = :s_spteam;
end if

if s_sittyp = "" or IsNull(s_sittyp) then     // 제품구분
	s_sittyp = '%'
end if

if s_itnbr = "" or IsNull(s_itnbr) then     // 제품구분
	s_itnbr = '%'
end if

if s_cvcod = "" or IsNull(s_cvcod) then     // 거래처
	s_cvcod   = '%'
	s_cvcodnm = '전  체'
end if

if s_sitcls = "" or IsNull(s_sitcls) then     // 제품분류
	s_sitcls = '%'
	s_sitname = '전  체'
else
	s_sitcls = s_sitcls + '%'
end if

s_itdsc = Trim(dw_ip.GetitemString(1,'itdsc'))
If IsNull(s_itdsc) Or s_itdsc = '' Then s_itdsc = '전체'

return 1
end function

on w_sal_01600.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_sal_01600.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_open;call super::ue_open;tab_1.tabpage_1.dw_1.settransobject(sqlca)
tab_1.tabpage_2.dw_2.settransobject(sqlca)
tab_1.tabpage_3.dw_3.settransobject(sqlca)
tab_1.tabpage_4.dw_4.settransobject(sqlca)
tab_1.tabpage_5.dw_5.settransobject(sqlca)
tab_1.tabpage_6.dw_6.settransobject(sqlca)

tab_1.SelectedTab = 1 

dw_ip.setitem(1,'syy',left(f_today(),4))
dw_ip.setitem(1,'sfmm','01')
dw_ip.setitem(1,'stmm',mid(f_today(),5,2))

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, 'ssarea', sarea)
	dw_ip.SetItem(1, 'ssteam', steam)
	dw_ip.Modify("ssarea.protect=1")
	dw_ip.Modify("ssteam.protect=1")
	dw_ip.Modify("ssarea.background.color = 80859087")
	dw_ip.Modify("ssteam.background.color = 80859087")
End If




sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"
end event

type p_preview from w_standard_print`p_preview within w_sal_01600
end type

event p_preview::clicked;
Choose Case tab_1.SelectedTab
	Case 1
		dw_print.DataObject = 'd_sal_01600_01_p'
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_1.dw_1.ShareData(dw_print)
	Case 2
		dw_print.DataObject = 'd_sal_01600_02_p'
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_2.dw_2.ShareData(dw_print)		
	Case 3
		dw_print.DataObject = 'd_sal_01600_03_p'
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_3.dw_3.ShareData(dw_print)
	Case 4
		dw_print.DataObject = 'd_sal_01600_04_p'
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_4.dw_4.ShareData(dw_print)		
	Case 5
		dw_print.DataObject = 'd_sal_01600_05_p'
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_5.dw_5.ShareData(dw_print)
	Case 6
		dw_print.DataObject = 'd_sal_01600_06_p'
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_6.dw_6.ShareData(dw_print)				
	
End Choose

OpenWithParm(w_print_preview, dw_print)


end event

type p_exit from w_standard_print`p_exit within w_sal_01600
end type

type p_print from w_standard_print`p_print within w_sal_01600
end type

event p_print::clicked;gi_page = 1

CHOOSE CASE tab_1.selectedtab
	CASE 1
		IF tab_1.tabpage_1.dw_1.rowcount() > 0 then 	gi_page = tab_1.tabpage_1.dw_1.GetItemNumber(1,"last_page")
      OpenWithParm(w_print_options, tab_1.tabpage_1.dw_1)
   CASE 2
		IF tab_1.tabpage_2.dw_2.rowcount() > 0 then 	gi_page = tab_1.tabpage_2.dw_2.GetItemNumber(1,"last_page")
      OpenWithParm(w_print_options, tab_1.tabpage_2.dw_2)
   CASE 3
		IF tab_1.tabpage_3.dw_3.rowcount() > 0 then 	gi_page = tab_1.tabpage_3.dw_3.GetItemNumber(1,"last_page")
      OpenWithParm(w_print_options, tab_1.tabpage_3.dw_3)
   CASE 4
		IF tab_1.tabpage_4.dw_4.rowcount() > 0 then 	gi_page = tab_1.tabpage_4.dw_4.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options, tab_1.tabpage_4.dw_4)
	CASE 5
		IF tab_1.tabpage_5.dw_5.rowcount() > 0 then 	gi_page = tab_1.tabpage_5.dw_5.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options, tab_1.tabpage_5.dw_5)
	CASE 6
		IF tab_1.tabpage_6.dw_6.rowcount() > 0 then 	gi_page = tab_1.tabpage_6.dw_6.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options, tab_1.tabpage_6.dw_6)
END CHOOSE

end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_01600
end type

event p_retrieve::clicked;call super::clicked;
if wf_datacheck() = -1 then
	return
end if
	
//dw_ip.SetRedraw(false)

CHOOSE CASE tab_1.selectedtab

	CASE 1
		IF wf_retrieve1() = -1 THEN
			p_print.Enabled =False
			p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
		
			p_preview.enabled = False
			p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
			SetPointer(Arrow!)
			Return
		Else
			p_print.Enabled =True
			p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
			p_preview.enabled = true
			p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
		END IF
   CASE 2
		IF wf_retrieve2() = -1 THEN
			p_print.Enabled =False
			p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
		
			p_preview.enabled = False
			p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
			SetPointer(Arrow!)
			Return
		Else
			p_print.Enabled =True
			p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
			p_preview.enabled = true
			p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
		END IF
   CASE 3
		IF wf_retrieve3() = -1 THEN
			p_print.Enabled =False
			p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
		
			p_preview.enabled = False
			p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
			SetPointer(Arrow!)
			Return
		Else
			p_print.Enabled =True
			p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
			p_preview.enabled = true
			p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
		END IF
   CASE 4
		IF wf_retrieve4() = -1 THEN
			p_print.Enabled =False
			p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
		
			p_preview.enabled = False
			p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
			SetPointer(Arrow!)
			Return
		Else
			p_print.Enabled =True
			p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
			p_preview.enabled = true
			p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
		END IF
   CASE 5
		IF wf_retrieve5() = -1 THEN
			p_print.Enabled =False
			p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
		
			p_preview.enabled = False
			p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
			SetPointer(Arrow!)
			Return
		Else
			p_print.Enabled =True
			p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
			p_preview.enabled = true
			p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
		END IF
   CASE 6
		IF wf_retrieve6() = -1 THEN
			p_print.Enabled =False
			p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
		
			p_preview.enabled = False
			p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
			SetPointer(Arrow!)
			Return
		Else
			p_print.Enabled =True
			p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
			p_preview.enabled = true
			p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
		END IF
		
END CHOOSE

SetPointer(Arrow!)

//dw_ip.SetRedraw(true)
end event







type st_10 from w_standard_print`st_10 within w_sal_01600
end type



type dw_print from w_standard_print`dw_print within w_sal_01600
string dataobject = "d_sal_01600_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_01600
integer x = 9
integer y = 28
integer width = 3918
integer height = 284
string dataobject = "d_sal_01600"
end type

event dw_ip::itemchanged;String sItemCls, sItemgbn, sitemclsname, sitnbr, sittyp, sitcls,sitdsc, sispec, sJijil, sispeccode
String sarea, steam, sCvcod, scvnas, sSaupj, sName1
String sNull, s_name
Int    ireturn , nRow

setnull(sNull)

nRow = GetRow()
If nRow <= 0 Then Return

CHOOSE CASE GetColumnName()
	CASE 'syy'
		
		accepttext()
		
		s_syy = GetText()
		
		s_syy = Mid('000'+s_syy,len(s_syy),4)
		
      setitem(1, 'syy', s_syy)
		
		return
		
	CASE 'sfmm'
		
		accepttext()
		
		s_sfmm = GetText()
		
		s_sfmm = Mid('0'+s_sfmm,len(s_sfmm),2)
		
      setitem(1, 'sfmm', s_sfmm)
		
		return
		
	CASE 'stmm'
		
		accepttext()
		
		s_stmm = GetText()
		
		s_stmm = Mid('0'+s_stmm,len(s_stmm),2)
		
      setitem(1, 'stmm', s_stmm)
		return
		
	CASE 'spteam'
		
		s_spteam = GetText()
		
		if s_spteam = "" or isnull(s_spteam) then 
         return 
	   end if	
		
		s_spteamnm = f_get_reffer('03',s_spteam)
		
		if	(s_spteamnm = '') or isNull(s_spteamnm) then    // 생산팀 CHECK
       	f_Message_Chk(33, '[생산팀]')
			setitem(1, 'spteam', snull)
      	Return 1
      end if

	/* 품목구분 */
	Case "ittyp"
		SetItem(nRow,'itcls',sNull)
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
//		SetItem(nRow,'ispec',sNull)
	/* 품목분류 */
	Case "itcls"
		SetItem(nRow,'itclsnm',sNull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
//		SetItem(nRow,'ispec',sNull)
		
		sItemCls = Trim(GetText())
		IF sItemCls = "" OR IsNull(sItemCls) THEN 		RETURN
		
		sItemGbn = GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
			
			SELECT "ITNCT"."TITNM"  	INTO :sItemClsName  
			  FROM "ITNCT"  
			 WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."ITCLS" = :sItemCls )   ;
				
			IF SQLCA.SQLCODE <> 0 THEN
				TriggerEvent(RButtonDown!)
				Return 2
			ELSE
				SetItem(1,"itclsnm",sItemClsName)
			END IF
		END IF
	/* 품목명 */
	Case "itclsnm"
		SetItem(1,"itcls",snull)
		SetItem(nRow,'itnbr',sNull)
		SetItem(nRow,'itdsc',sNull)
//		SetItem(nRow,'ispec',sNull)
		
		sItemClsName = GetText()
		IF sItemClsName = "" OR IsNull(sItemClsName) THEN return
		
		sItemGbn = GetItemString(1,"ittyp")
		IF sItemGbn <> "" AND Not IsNull(sItemGbn) THEN 
		  SELECT "ITNCT"."ITCLS"	INTO :sItemCls
			 FROM "ITNCT"  
			WHERE ( "ITNCT"."ITTYP" = :sItemGbn ) AND ( "ITNCT"."TITNM" = :sItemClsName )   ;
				
		  IF SQLCA.SQLCODE <> 0 THEN
			 TriggerEvent(RButtonDown!)
			 Return 2
		  ELSE
			 SetItem(1,"itcls",sItemCls)
		  END IF
		END IF
	/* 품번 */
	  Case	"itnbr" 
		 sItnbr = Trim(GetText())
		 IF sItnbr ="" OR IsNull(sItnbr) THEN
			SetItem(nRow,'itdsc',sNull)
//			SetItem(nRow,'ispec',sNull)
			Return
		 END IF
		
		 SELECT  "ITEMAS"."ITTYP", "ITEMAS"."ITCLS", "ITEMAS"."ITDSC",   "ITEMAS"."ISPEC","ITNCT"."TITNM"
			INTO :sIttyp, :sItcls, :sItdsc, :sIspec ,:sItemClsName
			FROM "ITEMAS","ITNCT"
		  WHERE "ITEMAS"."ITTYP" = "ITNCT"."ITTYP" AND
				  "ITEMAS"."ITCLS" = "ITNCT"."ITCLS" AND
				  "ITEMAS"."ITNBR" = :sItnbr ;
	
		 IF SQLCA.SQLCODE <> 0 THEN
			PostEvent(RbuttonDown!)
			Return 2
		 END IF
		
		 SetItem(nRow,"ittyp", sIttyp)
		 SetItem(nRow,"itdsc", sItdsc)
//		 SetItem(nRow,"ispec", sIspec)
		 SetItem(nRow,"itcls", sItcls)
		 SetItem(nRow,"itclsnm", sItemClsName)
	/* 품명 */
	 Case "itdsc"
		 sItdsc = trim(GetText())	
		 IF sItdsc ="" OR IsNull(sItdsc) THEN
			 SetItem(nRow,'itnbr',sNull)
			 SetItem(nRow,'itdsc',sNull)
//			 SetItem(nRow,'ispec',sNull)
			Return
		 END IF
		 
		/* 품명으로 품번찾기 */
		f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		 If IsNull(sItnbr ) Then
			 Return 1
		 ElseIf sItnbr <> '' Then
			 SetItem(nRow,"itnbr",sItnbr)
			 SetColumn("itnbr")
			 SetFocus()
			 TriggerEvent(ItemChanged!)
			 Return 1
		 ELSE
			 SetItem(nRow,'itnbr',sNull)
			 SetItem(nRow,'itdsc',sNull)
//			 SetItem(nRow,'ispec',sNull)
			 SetColumn("itdsc")
			 Return 1
		End If	
	/* 규격 */
	Case "ispec"
		sIspec = trim(GetText())	
		IF sIspec = ""	or	IsNull(sIspec)	THEN
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
			SetItem(nRow,'ispec',sNull)
			Return
		END IF
	
	   /* 규격으로 품번찾기 */
	   f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		If IsNull(sItnbr ) Then
			Return 1
		ElseIf sItnbr <> '' Then
			SetItem(nRow,"itnbr",sItnbr)
			SetColumn("itnbr")
			SetFocus()
			TriggerEvent(ItemChanged!)
			Return 1
		ELSE
			SetItem(nRow,'itnbr',sNull)
			SetItem(nRow,'itdsc',sNull)
//			SetItem(nRow,'ispec',sNull)
			SetColumn("ispec")
			Return 1
	  End If
	/* 영업팀 */
	Case "ssteam"
		SetItem(1,'ssarea',sNull)
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
	/* 관할구역 */
	Case "ssarea"
		SetItem(1,"custcode",sNull)
		SetItem(1,"custname",sNull)
		
		sarea = GetText()
		IF sarea = "" OR IsNull(sarea) THEN RETURN
		
		SELECT "SAREA"."SAREA" ,"SAREA"."STEAMCD" 	INTO :sarea  ,:steam
		  FROM "SAREA"  
		 WHERE "SAREA"."SAREA" = :sarea   ;
		
		SetItem(1,'ssteam',steam)
	/* 거래처 */
	Case "custcode"
		sCvcod = Trim(GetText())
		IF sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"custname",snull)
			Return
		END IF

		If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,"ssteam",   steam)
			SetItem(1,"custname", scvnas)
			SetItem(1,"ssarea",   sarea)
		END IF
	/* 거래처명 */
	Case "custname"
		scvnas = Trim(GetText())
		IF scvnas ="" OR IsNull(scvnas) THEN
			SetItem(1,"custcode",snull)
			Return
		END IF
		
		If f_get_cvnames('2', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, 'custcode', sNull)
			SetItem(1, 'custname', snull)
			Return 1
		ELSE		
			SetItem(1,"ssteam",   steam)
			SetItem(1,'custcode', sCvcod)
			SetItem(1,"custname", scvnas)
			SetItem(1,"ssarea",   sarea)
			
			Return 1
		END IF
END CHOOSE

end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;str_itnct str_sitnct
String sIocustName, sIocustarea, sDept
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetcolumnName() 
	Case "custcode", "custname"
		gs_gubun = '1'
		If GetColumnName() = "custname" then
			gs_codename = Trim(GetText())
		End If
		Open(w_agent_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"custcode",gs_code)
		SetColumn("custcode")
		TriggerEvent(ItemChanged!)
  Case "itcls"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
	
    str_sitnct = Message.PowerObjectParm	
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",str_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",  str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
  Case "itclsnm"
	 OpenWithParm(w_ittyp_popup, this.GetItemString(this.GetRow(),"ittyp"))
    str_sitnct = Message.PowerObjectParm
	
	 IF str_sitnct.s_ittyp ="" OR IsNull(str_sitnct.s_ittyp) THEN RETURN
	
	 this.SetItem(1,"itcls",   str_sitnct.s_sumgub)
	 this.SetItem(1,"itclsnm", str_sitnct.s_titnm)
	 this.SetItem(1,"ittyp",   str_sitnct.s_ittyp)
	 
	 SetColumn('itnbr')
/* ---------------------------------------- */
  Case "itnbr" ,"itdsc", "ispec"
		gs_gubun = Trim(GetItemString(1,'ittyp'))
	  Open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	  this.SetItem(1,"itnbr",gs_code)
	  this.SetFocus()
	  this.SetColumn('itnbr')
	  this.PostEvent(ItemChanged!)
END Choose
end event

event dw_ip::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
		IF This.GetColumnName() = "sitcls"  Then
   		this.accepttext()
			gs_code = this.getitemstring(1, 'sittyp')
			
			open(w_ittyp_popup3)
			
			str_sitnct = Message.PowerObjectParm	
			
			if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
				return
			end if
		
			this.SetItem(1,"sittyp", str_sitnct.s_ittyp)
			this.SetItem(1,"sitcls", str_sitnct.s_sumgub)
			this.SetItem(1,"sitname", str_sitnct.s_titnm)
		END IF	
END IF

end event

type dw_list from w_standard_print`dw_list within w_sal_01600
boolean visible = false
integer x = 997
integer y = 1460
integer width = 1746
integer height = 376
end type

type tab_1 from tab within w_sal_01600
event create ( )
event destroy ( )
integer x = 41
integer y = 328
integer width = 4549
integer height = 2000
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
end on

event selectionchanged;CHOOSE CASE newindex

	CASE 1		
		p_print.Enabled = s_p1
	CASE 2
		p_print.Enabled = s_p2
	CASE 3	
		p_print.Enabled = s_p3
	CASE 4
		p_print.Enabled = s_p4
	CASE 5
		p_print.Enabled = s_p5
	CASE 6
		p_print.Enabled = s_p6
END CHOOSE


end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4512
integer height = 1888
long backcolor = 32106727
string text = "영업팀별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 553648127
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within tabpage_1
integer x = 41
integer y = 32
integer width = 4425
integer height = 1784
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_01600_01"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4512
integer height = 1888
long backcolor = 32106727
string text = "관할구역별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from datawindow within tabpage_2
integer x = 41
integer y = 32
integer width = 4425
integer height = 1784
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_01600_02"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4512
integer height = 1888
long backcolor = 32106727
string text = "거래처별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_3
integer x = 41
integer y = 32
integer width = 4425
integer height = 1784
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_01600_03"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_4 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4512
integer height = 1888
long backcolor = 32106727
string text = "대분류별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_4 dw_4
end type

on tabpage_4.create
this.dw_4=create dw_4
this.Control[]={this.dw_4}
end on

on tabpage_4.destroy
destroy(this.dw_4)
end on

type dw_4 from datawindow within tabpage_4
integer x = 41
integer y = 32
integer width = 4425
integer height = 1784
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_01600_04"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_5 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4512
integer height = 1888
long backcolor = 32106727
string text = "중분류별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
end on

type dw_5 from datawindow within tabpage_5
integer x = 41
integer y = 32
integer width = 4425
integer height = 1784
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_01600_05"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_6 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 96
integer width = 4512
integer height = 1888
long backcolor = 32106727
string text = "제 품 별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_6.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_6.destroy
destroy(this.dw_6)
end on

type dw_6 from datawindow within tabpage_6
integer x = 41
integer y = 32
integer width = 4425
integer height = 1784
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_01600_06"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

