$PBExportHeader$w_sal_01530.srw
$PBExportComments$===> 년간판매 계획서
forward
global type w_sal_01530 from w_standard_print
end type
type tab_1 from tab within w_sal_01530
end type
type tabpage_1 from userobject within tab_1
end type
type rr_1 from roundrectangle within tabpage_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rr_1 rr_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type rr_2 from roundrectangle within tabpage_2
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rr_2 rr_2
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type rr_3 from roundrectangle within tabpage_3
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
rr_3 rr_3
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type rr_4 from roundrectangle within tabpage_4
end type
type dw_4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
rr_4 rr_4
dw_4 dw_4
end type
type tabpage_5 from userobject within tab_1
end type
type rr_5 from roundrectangle within tabpage_5
end type
type dw_5 from datawindow within tabpage_5
end type
type tabpage_5 from userobject within tab_1
rr_5 rr_5
dw_5 dw_5
end type
type tabpage_6 from userobject within tab_1
end type
type rr_7 from roundrectangle within tabpage_6
end type
type dw_6 from datawindow within tabpage_6
end type
type tabpage_6 from userobject within tab_1
rr_7 rr_7
dw_6 dw_6
end type
type tabpage_8 from userobject within tab_1
end type
type rr_6 from roundrectangle within tabpage_8
end type
type dw_8 from datawindow within tabpage_8
end type
type tabpage_8 from userobject within tab_1
rr_6 rr_6
dw_8 dw_8
end type
type tabpage_7 from userobject within tab_1
end type
type rr_8 from roundrectangle within tabpage_7
end type
type dw_7 from datawindow within tabpage_7
end type
type tabpage_7 from userobject within tab_1
rr_8 rr_8
dw_7 dw_7
end type
type tabpage_9 from userobject within tab_1
end type
type rr_9 from roundrectangle within tabpage_9
end type
type dw_9 from datawindow within tabpage_9
end type
type tabpage_9 from userobject within tab_1
rr_9 rr_9
dw_9 dw_9
end type
type tab_1 from tab within w_sal_01530
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_8 tabpage_8
tabpage_7 tabpage_7
tabpage_9 tabpage_9
end type
end forward

global type w_sal_01530 from w_standard_print
string title = "년간판매계획서"
tab_1 tab_1
end type
global w_sal_01530 w_sal_01530

type variables
string is_gubun
boolean s_p1,s_p2,s_p3,s_p4,s_p5,s_p6,s_p7, s_p9
str_itnct lstr_sitnct
integer s_schasu
string s_syy, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm
string s_svndcod, s_svndnm, s_spteam, s_spteamnm
string s_sittyp, s_sitcls, s_sitname, s_sporgu
end variables

forward prototypes
public function integer wf_retrieve2 ()
public function integer wf_retrieve3 ()
public function integer wf_retrieve4 ()
public function integer wf_retrieve5 ()
public function integer wf_retrieve6 ()
public function integer wf_retrieve7 ()
public function integer wf_retrieve8 ()
public function integer wf_datacheck ()
public function integer wf_retrieve ()
public function integer wf_retrieve1 ()
public function integer wf_retrieve9 ()
end prototypes

public function integer wf_retrieve2 ();string ls_gubun , ls_fm , ls_tm

ls_gubun = dw_ip.getitemstring(1,'gubun')

if ls_gubun = '2' then
	ls_fm = Trim(dw_ip.getitemstring(1,'fm'))
	ls_tm = Trim(dw_ip.getitemstring(1,'tm'))
	
	if ls_fm = "" or isnull(ls_fm) then
		f_message_chk(30,'전년도 계획월 FROM')
		dw_ip.setcolumn('fm')
		dw_ip.setfocus()
		return -1
	end if
	if ls_tm = "" or isnull(ls_tm) then
		f_message_chk(30,'전년도 계획월 TO')
		dw_ip.setcolumn('tm')
		dw_ip.setfocus()
		return -1
	end if
end if

if ls_gubun = '1' then
	if tab_1.tabpage_2.dw_2.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea, s_svndcod, &
						  s_spteam,s_spteamnm, s_sittyp, s_sitcls,s_sitname, s_sporgu) <= 0 then
		f_message_chk(50,'[관할구역별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p1 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p1 = True
//		tab_1.tabpage_2.dw_2.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_2.dw_2.GetItemNumber(1,"last_page")
		tab_1.tabpage_2.dw_2.scrolltorow(1)
	end if
else
	if tab_1.tabpage_2.dw_2.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea, s_svndcod, &
						  s_spteam,s_spteamnm, s_sittyp, s_sitcls,s_sitname,ls_fm,ls_tm, s_sporgu) <= 0 then
		f_message_chk(50,'[관할구역별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p1 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p1 = True
//		tab_1.tabpage_2.dw_2.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_2.dw_2.GetItemNumber(1,"last_page")
		tab_1.tabpage_2.dw_2.scrolltorow(1)
	end if
end if	
	
return 1


end function

public function integer wf_retrieve3 ();string ls_gubun , ls_fm , ls_tm

ls_gubun = dw_ip.getitemstring(1,'gubun')

if ls_gubun = '2' then
	ls_fm = Trim(dw_ip.getitemstring(1,'fm'))
	ls_tm = Trim(dw_ip.getitemstring(1,'tm'))
	
	if ls_fm = "" or isnull(ls_fm) then
		f_message_chk(30,'전년도 계획월 FROM')
		dw_ip.setcolumn('fm')
		dw_ip.setfocus()
		return -1
	end if
	if ls_tm = "" or isnull(ls_tm) then
		f_message_chk(30,'전년도 계획월 TO')
		dw_ip.setcolumn('tm')
		dw_ip.setfocus()
		return -1
	end if
end if

if ls_gubun = '1' then
	if tab_1.tabpage_3.dw_3.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, &
												s_svndcod, s_spteam,s_spteamnm, s_sittyp, &
												s_sitcls,s_sitname, s_sporgu) <= 0 then
		f_message_chk(50,'[거래처별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p3 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p3 = True
//		tab_1.tabpage_3.dw_3.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_3.dw_3.GetItemNumber(1,"last_page")
		tab_1.tabpage_3.dw_3.scrolltorow(1)
	end if
else
   if tab_1.tabpage_3.dw_3.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, &
												s_svndcod, s_spteam,s_spteamnm, s_sittyp, &
												s_sitcls,s_sitname,ls_fm,ls_tm, s_sporgu) <= 0 then
		f_message_chk(50,'[거래처별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p3 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p3 = True
//		tab_1.tabpage_3.dw_3.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_3.dw_3.GetItemNumber(1,"last_page")
		tab_1.tabpage_3.dw_3.scrolltorow(1)
	end if
end if

return 1
end function

public function integer wf_retrieve4 ();string ls_gubun , ls_fm , ls_tm

ls_gubun = dw_ip.getitemstring(1,'gubun')

if ls_gubun = '2' then
	ls_fm = Trim(dw_ip.getitemstring(1,'fm'))
	ls_tm = Trim(dw_ip.getitemstring(1,'tm'))
	
	if ls_fm = "" or isnull(ls_fm) then
		f_message_chk(30,'전년도 계획월 FROM')
		dw_ip.setcolumn('fm')
		dw_ip.setfocus()
		return -1
	end if
	if ls_tm = "" or isnull(ls_tm) then
		f_message_chk(30,'전년도 계획월 TO')
		dw_ip.setcolumn('tm')
		dw_ip.setfocus()
		return -1
	end if
end if

if ls_gubun = '1' then
	if tab_1.tabpage_4.dw_4.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, & 
												s_svndcod, s_svndnm, s_spteam,s_spteamnm, s_sittyp, & 
												s_sitcls,s_sitname, s_sporgu) <= 0 then
		f_message_chk(50,'[생산팀별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p4 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p4 = True
//		tab_1.tabpage_4.dw_4.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_4.dw_4.GetItemNumber(1,"last_page")
		tab_1.tabpage_4.dw_4.scrolltorow(1)
	end if
else
	if tab_1.tabpage_4.dw_4.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, & 
												s_svndcod, s_svndnm, s_spteam,s_spteamnm, s_sittyp, & 
												s_sitcls,s_sitname,ls_fm,ls_tm, s_sporgu) <= 0 then
		f_message_chk(50,'[생산팀별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p4 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p4 = True
//		tab_1.tabpage_4.dw_4.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_4.dw_4.GetItemNumber(1,"last_page")
		tab_1.tabpage_4.dw_4.scrolltorow(1)
	end if
end if

return 1
end function

public function integer wf_retrieve5 ();string ls_gubun , ls_fm , ls_tm

ls_gubun = dw_ip.getitemstring(1,'gubun')

if ls_gubun = '2' then
	ls_fm = Trim(dw_ip.getitemstring(1,'fm'))
	ls_tm = Trim(dw_ip.getitemstring(1,'tm'))
	
	if ls_fm = "" or isnull(ls_fm) then
		f_message_chk(30,'전년도 계획월 FROM')
		dw_ip.setcolumn('fm')
		dw_ip.setfocus()
		return -1
	end if
	if ls_tm = "" or isnull(ls_tm) then
		f_message_chk(30,'전년도 계획월 TO')
		dw_ip.setcolumn('tm')
		dw_ip.setfocus()
		return -1
	end if
end if

if ls_gubun = '1' then
	if tab_1.tabpage_5.dw_5.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, & 
												s_svndcod, s_svndnm, s_spteam,s_spteamnm, s_sittyp, & 
												s_sitcls,s_sitname,s_sporgu) <= 0 then
		f_message_chk(50,'[제품군별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p5 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p5 = True
//		tab_1.tabpage_5.dw_5.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_5.dw_5.GetItemNumber(1,"last_page")
		tab_1.tabpage_5.dw_5.scrolltorow(1)
	end if
else
	if tab_1.tabpage_5.dw_5.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, & 
												s_svndcod, s_svndnm, s_spteam,s_spteamnm, s_sittyp, & 
												s_sitcls,s_sitname,ls_fm,ls_tm,s_sporgu) <= 0 then
		f_message_chk(50,'[제품군별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p5 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p5 = True
//		tab_1.tabpage_5.dw_5.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_5.dw_5.GetItemNumber(1,"last_page")
		tab_1.tabpage_5.dw_5.scrolltorow(1)
	end if
end if

return 1
end function

public function integer wf_retrieve6 ();string ls_gubun , ls_fm , ls_tm

ls_gubun = dw_ip.getitemstring(1,'gubun')

if ls_gubun = '2' then
	ls_fm = Trim(dw_ip.getitemstring(1,'fm'))
	ls_tm = Trim(dw_ip.getitemstring(1,'tm'))
	
	if ls_fm = "" or isnull(ls_fm) then
		f_message_chk(30,'전년도 계획월 FROM')
		dw_ip.setcolumn('fm')
		dw_ip.setfocus()
		return -1
	end if
	if ls_tm = "" or isnull(ls_tm) then
		f_message_chk(30,'전년도 계획월 TO')
		dw_ip.setcolumn('tm')
		dw_ip.setfocus()
		return -1
	end if
end if

if ls_gubun = '1' then
	if tab_1.tabpage_6.dw_6.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, & 
												s_svndcod, s_svndnm, s_spteam,s_spteamnm, s_sittyp, & 
												s_sitcls,s_sitname,s_sporgu) <= 0 then
		f_message_chk(50,'[시리즈별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p6 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p6 = True
//		tab_1.tabpage_6.dw_6.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_6.dw_6.GetItemNumber(1,"last_page")
		tab_1.tabpage_6.dw_6.scrolltorow(1)
	end if
else
	if tab_1.tabpage_6.dw_6.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, & 
												s_svndcod, s_svndnm, s_spteam,s_spteamnm, s_sittyp, & 
												s_sitcls,s_sitname,ls_fm,ls_tm,s_sporgu) <= 0 then
		f_message_chk(50,'[시리즈별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p6 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p6 = True
//		tab_1.tabpage_6.dw_6.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_6.dw_6.GetItemNumber(1,"last_page")
		tab_1.tabpage_6.dw_6.scrolltorow(1)
	end if
end if

return 1
end function

public function integer wf_retrieve7 ();string ls_gubun , ls_fm , ls_tm

ls_gubun = dw_ip.getitemstring(1,'gubun')

if ls_gubun = '2' then
	ls_fm = Trim(dw_ip.getitemstring(1,'fm'))
	ls_tm = Trim(dw_ip.getitemstring(1,'tm'))
	
	if ls_fm = "" or isnull(ls_fm) then
		f_message_chk(30,'전년도 계획월 FROM')
		dw_ip.setcolumn('fm')
		dw_ip.setfocus()
		return -1
	end if
	if ls_tm = "" or isnull(ls_tm) then
		f_message_chk(30,'전년도 계획월 TO')
		dw_ip.setcolumn('tm')
		dw_ip.setfocus()
		return -1
	end if
end if

if ls_gubun = '1' then
	if tab_1.tabpage_7.dw_7.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, & 
												s_svndcod, s_svndnm, s_spteam,s_spteamnm, s_sittyp, & 
												s_sitcls,s_sitname,s_sporgu) <= 0 then
		f_message_chk(50,'[제품별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p7 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p7 = True
//		tab_1.tabpage_7.dw_7.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_7.dw_7.GetItemNumber(1,"last_page")
		tab_1.tabpage_7.dw_7.scrolltorow(1)
	end if
else
	if tab_1.tabpage_7.dw_7.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, & 
												s_svndcod, s_svndnm, s_spteam,s_spteamnm, s_sittyp, & 
												s_sitcls,s_sitname,ls_fm,ls_tm,s_sporgu) <= 0 then
		f_message_chk(50,'[제품별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p7 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p7 = True
//		tab_1.tabpage_7.dw_7.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_7.dw_7.GetItemNumber(1,"last_page")
		tab_1.tabpage_7.dw_7.scrolltorow(1)
	end if
end if
	
return 1
end function

public function integer wf_retrieve8 ();string ls_gubun , ls_fm , ls_tm

ls_gubun = dw_ip.getitemstring(1,'gubun')

if ls_gubun = '2' then
	ls_fm = Trim(dw_ip.getitemstring(1,'fm'))
	ls_tm = Trim(dw_ip.getitemstring(1,'tm'))
	
	if ls_fm = "" or isnull(ls_fm) then
		f_message_chk(30,'전년도 계획월 FROM')
		dw_ip.setcolumn('fm')
		dw_ip.setfocus()
		return -1
	end if
	if ls_tm = "" or isnull(ls_tm) then
		f_message_chk(30,'전년도 계획월 TO')
		dw_ip.setcolumn('tm')
		dw_ip.setfocus()
		return -1
	end if
end if

if ls_gubun = '1' then
	if tab_1.tabpage_8.dw_8.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, & 
												s_svndcod, s_svndnm, s_spteam,s_spteamnm, s_sittyp, & 
												s_sitcls,s_sitname,s_sporgu) <= 0 then
		f_message_chk(50,'[소분류별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p6 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p6 = True
//		tab_1.tabpage_8.dw_8.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_8.dw_8.GetItemNumber(1,"last_page")
		tab_1.tabpage_8.dw_8.scrolltorow(1)
	end if
else
	if tab_1.tabpage_8.dw_8.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, & 
												s_svndcod, s_svndnm, s_spteam,s_spteamnm, s_sittyp, & 
												s_sitcls,s_sitname,ls_fm,ls_tm,s_sporgu) <= 0 then
		f_message_chk(50,'[소분류별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p6 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p6 = True
//		tab_1.tabpage_8.dw_8.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_8.dw_8.GetItemNumber(1,"last_page")
		tab_1.tabpage_8.dw_8.scrolltorow(1)
	end if
end if

return 1
end function

public function integer wf_datacheck ();If dw_ip.AcceptText() <> 1 Then Return -1

s_syy     = trim(dw_ip.GetItemString(1,'syy'))
s_schasu  = 0
s_schasu  = dw_ip.GetItemNumber(1,'schasu')
s_ssteam  = trim(dw_ip.GetItemString(1,'ssteam'))
s_ssarea  = trim(dw_ip.GetItemString(1,'ssarea'))
s_svndcod = trim(dw_ip.GetItemString(1,'svndcod'))
s_svndnm  = trim(dw_ip.GetItemString(1,'svndnm'))
s_spteam  = trim(dw_ip.GetItemString(1,'spteam'))
s_sittyp  = trim(dw_ip.GetItemString(1,'sittyp'))
s_sitcls  = trim(dw_ip.GetItemString(1,'sitcls'))
s_sitname = trim(dw_ip.GetItemString(1,'sitname'))
s_sporgu   = trim(dw_ip.GetItemString(1,'porgu'))

if	(s_syy='') or isNull(s_syy) then           //계획년도 CHECK
	f_Message_Chk(35, '[계획년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1
end if

if	s_schasu = 0 then           //계획차수 CHECK
	f_Message_Chk(35, '[계획차수]')
	dw_ip.setcolumn('schasu')
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

if s_svndcod = "" or IsNull(s_svndcod) then   // 거래처처리 
	s_svndcod = '%'
	s_svndnm = '전  체'
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

if s_sitcls = "" or IsNull(s_sitcls) then     // 제품분류
	s_sitcls = '%'
	s_sitname = '전  체'
else
	s_sitcls = s_sitcls + '%'
end if

return 1
end function

public function integer wf_retrieve ();//Return -1
Return 0
end function

public function integer wf_retrieve1 ();string ls_gubun , ls_fm , ls_tm

ls_gubun = dw_ip.getitemstring(1,'gubun')

if ls_gubun = '2' then
	ls_fm = Trim(dw_ip.getitemstring(1,'fm'))
	ls_tm = Trim(dw_ip.getitemstring(1,'tm'))
	
	if ls_fm = "" or isnull(ls_fm) then
		f_message_chk(30,'전년도 계획월 FROM')
		dw_ip.setcolumn('fm')
		dw_ip.setfocus()
		return -1
	end if
	if ls_tm = "" or isnull(ls_tm) then
		f_message_chk(30,'전년도 계획월 TO')
		dw_ip.setcolumn('tm')
		dw_ip.setfocus()
		return -1
	end if
end if

if ls_gubun = '1' then
	if tab_1.tabpage_1.dw_1.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea, s_svndcod, &
						  s_spteam,s_spteamnm, s_sittyp, s_sitcls,s_sitname, s_sporgu) <= 0 then
		f_message_chk(50,'[영업팀별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p2 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p2 = true
//		tab_1.tabpage_1.dw_1.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_1.dw_1.GetItemNumber(1,"last_page")
		tab_1.tabpage_1.dw_1.scrolltorow(1)
	end if
else
	if tab_1.tabpage_1.dw_1.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea, s_svndcod, &
						  s_spteam,s_spteamnm, s_sittyp, s_sitcls,s_sitname,ls_fm,ls_tm, s_sporgu) <= 0 then
		f_message_chk(50,'[영업팀별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p2 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p2 = true
//		tab_1.tabpage_1.dw_1.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_1.dw_1.GetItemNumber(1,"last_page")
		tab_1.tabpage_1.dw_1.scrolltorow(1)
	end if
end if

return 1
end function

public function integer wf_retrieve9 ();string ls_gubun , ls_fm , ls_tm

ls_gubun = dw_ip.getitemstring(1,'gubun')

if ls_gubun = '2' then
	ls_fm = Trim(dw_ip.getitemstring(1,'fm'))
	ls_tm = Trim(dw_ip.getitemstring(1,'tm'))
	
	if ls_fm = "" or isnull(ls_fm) then
		f_message_chk(30,'전년도 계획월 FROM')
		dw_ip.setcolumn('fm')
		dw_ip.setfocus()
		return -1
	end if
	if ls_tm = "" or isnull(ls_tm) then
		f_message_chk(30,'전년도 계획월 TO')
		dw_ip.setcolumn('tm')
		dw_ip.setfocus()
		return -1
	end if
end if

if ls_gubun = '1' then
	if tab_1.tabpage_9.dw_9.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, & 
												s_svndcod, s_svndnm, s_spteam,s_spteamnm, s_sittyp, & 
												s_sitcls,s_sitname,s_sporgu) <= 0 then
		f_message_chk(50,'[차종별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p9 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p9 = True
//		tab_1.tabpage_8.dw_8.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_9.dw_9.GetItemNumber(1,"last_page")
		tab_1.tabpage_9.dw_9.scrolltorow(1)
	end if
else
	if tab_1.tabpage_9.dw_9.Retrieve(s_syy,s_schasu, s_ssteam,s_ssteamnm, s_ssarea,s_ssareanm, & 
												s_svndcod, s_svndnm, s_spteam,s_spteamnm, s_sittyp, & 
												s_sitcls,s_sitname,ls_fm,ls_tm,s_sporgu) <= 0 then
		f_message_chk(50,'[차종별 년간 판매계획 현황]')
		dw_ip.setcolumn('syy')
		dw_ip.Setfocus()
	//	cb_print.Enabled = False
		s_p9 = False
		SetPointer(Arrow!)
		return -1
	else
	//	cb_print.Enabled = True
		s_p9 = True
//		tab_1.tabpage_8.dw_8.object.datawindow.print.preview="yes"
		gi_page = tab_1.tabpage_9.dw_9.GetItemNumber(1,"last_page")
		tab_1.tabpage_9.dw_9.scrolltorow(1)
	end if
end if

return 1
end function

on w_sal_01530.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_sal_01530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_open;call super::ue_open;sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 가로방향"

tab_1.tabpage_1.dw_1.settransobject(sqlca)
tab_1.tabpage_2.dw_2.settransobject(sqlca)
tab_1.tabpage_3.dw_3.settransobject(sqlca)
tab_1.tabpage_4.dw_4.settransobject(sqlca)
tab_1.tabpage_5.dw_5.settransobject(sqlca)
tab_1.tabpage_6.dw_6.settransobject(sqlca)
tab_1.tabpage_7.dw_7.settransobject(sqlca)
tab_1.tabpage_8.dw_8.settransobject(sqlca)
tab_1.tabpage_9.dw_9.settransobject(sqlca)

tab_1.SelectedTab = 1

dw_ip.setitem(1,'syy',left(f_today(),4))

/* User별 관할구역 Setting */
String sarea, steam, saupj

//If f_check_sarea(sarea, steam, saupj) = 1 Then
//	dw_ip.SetItem(1, 'ssarea', sarea)
//	dw_ip.SetItem(1, 'ssteam', steam)
//	dw_ip.Modify("ssarea.protect=1")
//	dw_ip.Modify("ssteam.protect=1")
//End If
//
/* 사업장 구분 */
setnull(gs_code)
f_mod_saupj(dw_ip, 'porgu')

DataWindowChild state_child
integer rtncode

//영업팀
f_child_saupj(dw_ip, 'ssteam', gs_saupj) 

//관할 구역
f_child_saupj(dw_ip, 'ssarea', gs_saupj) 

//생산팀
rtncode 	= dw_ip.GetChild('spteam', state_child)
IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
state_child.SetTransObject(SQLCA)
state_child.Retrieve('03',gs_saupj)

dw_ip.reset() 
dw_ip.insertrow(0)
dw_ip.setitem(1, 'porgu', gs_saupj )
end event

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

dw_ip.SetTransObject(SQLCA)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

dw_print.ShareData(dw_list)

PostEvent('ue_open')
end event

type p_preview from w_standard_print`p_preview within w_sal_01530
end type

event p_preview::clicked;Int li_tab
String ls_gubun

ls_gubun = dw_ip.getitemstring(1,'gubun')

Choose Case tab_1.SelectedTab
	Case 1
		if ls_gubun = '1' then
			dw_print.DataObject = 'd_sal_01530_01_p'
		Else
			dw_print.dataobject = 'd_sal_01530_11_p'
		End If
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_1.dw_1.ShareData(dw_print)
	Case 2
		if ls_gubun = '1' then
			dw_print.DataObject = 'd_sal_01530_02_p'
		Else
			dw_print.dataobject = 'd_sal_01530_12_p'
		End If
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_2.dw_2.ShareData(dw_print)		
	Case 3
		if ls_gubun = '1' then
			dw_print.DataObject = 'd_sal_01530_03_p'
		Else
			dw_print.dataobject = 'd_sal_01530_13_p'
		End If
		
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_3.dw_3.ShareData(dw_print)
	Case 4
		if ls_gubun = '1' then
			dw_print.DataObject = 'd_sal_01530_04_p'
		Else
			dw_print.dataobject = 'd_sal_01530_14_p'
		End If
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_4.dw_4.ShareData(dw_print)		
	Case 5
		if ls_gubun = '1' then
			dw_print.DataObject = 'd_sal_01530_05_p'
		Else
			dw_print.dataobject = 'd_sal_01530_15_p'
		End If
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_5.dw_5.ShareData(dw_print)
	Case 6
		if ls_gubun = '1' then
			dw_print.DataObject = 'd_sal_01530_06_p'
		Else
			dw_print.dataobject = 'd_sal_01530_16_p'
		End If
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_6.dw_6.ShareData(dw_print)				
	Case 7
		if ls_gubun = '1' then
			dw_print.DataObject = 'd_sal_01530_08_p'
		Else
			dw_print.dataobject = 'd_sal_01530_18_p'
		End If
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_8.dw_8.ShareData(dw_print)
	Case 8
		if ls_gubun = '1' then
			dw_print.DataObject = 'd_sal_01530_07_p'
		Else
			dw_print.dataobject = 'd_sal_01530_17_p'
		End If
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_7.dw_7.ShareData(dw_print)
	Case 9
		if ls_gubun = '1' then
			dw_print.DataObject = 'd_sal_01530_09_p'
		Else
			dw_print.dataobject = 'd_sal_01530_19_p'
		End If
		dw_print.SetTransObject(sqlca)
		tab_1.tabpage_9.dw_9.ShareData(dw_print)
End Choose

String ls_syy, ls_steam, ls_sarea, ls_svndnm, ls_spteam, ls_ittyp, ls_itname

dw_print.object.t_100.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(porgu) ', 1)"))
dw_print.object.t_110.text = trim(dw_ip.GetItemString(1,'syy')) + ' 년'

//영업팀
ls_steam  = trim(dw_ip.GetItemString(1,'ssteam'))
If ls_steam = '' or isNull(ls_steam) Then
	dw_print.object.t_120.text = '전 체'
Else
	dw_print.object.t_120.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ssteam) ', 1)"))
End If

//관할구역
ls_sarea  = trim(dw_ip.GetItemString(1,'ssarea'))
If ls_sarea = '' or isNull(ls_sarea) Then
	dw_print.object.t_130.text = '전 체'
Else
	dw_print.object.t_130.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ssarea) ', 1)"))
End If

//거래처
ls_svndnm  = trim(dw_ip.GetItemString(1,'svndnm'))
If ls_svndnm = '' or isNull(ls_svndnm) Then
	dw_print.object.t_140.text = '전 체'
Else
	dw_print.object.t_140.text = ls_svndnm
End If

//생산팀
ls_spteam  = trim(dw_ip.GetItemString(1,'spteam'))
If ls_spteam = '' or isNull(ls_spteam) Then
	dw_print.object.t_150.text = '전 체'
Else
	dw_print.object.t_150.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(spteam) ', 1)"))
End If

//제품 분류
ls_itname = trim(dw_ip.GetItemString(1,'sitname'))
If ls_svndnm = '' or isNull(ls_svndnm) Then
	dw_print.object.t_160.text = '전 체'
Else
	dw_print.object.t_160.text = ls_svndnm
End If

OpenWithParm(w_print_preview, dw_print)

//dw_print.ShareData(dw_list)
end event

type p_exit from w_standard_print`p_exit within w_sal_01530
end type

type p_print from w_standard_print`p_print within w_sal_01530
end type

event p_print::clicked;gi_page = 1
String ls_syy, ls_steam, ls_sarea, ls_svndnm, ls_spteam, ls_ittyp, ls_itname

dw_print.object.t_100.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(porgu) ', 1)"))
dw_print.object.t_110.text = trim(dw_ip.GetItemString(1,'syy'))  + ' 년'

//영업팀
ls_steam  = trim(dw_ip.GetItemString(1,'ssteam'))
If ls_steam = '' or isNull(ls_steam) Then
	dw_print.object.t_120.text = '전 체'
Else
	dw_print.object.t_120.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ssteam) ', 1)"))
End If

//관할구역
ls_sarea  = trim(dw_ip.GetItemString(1,'ssarea'))
If ls_sarea = '' or isNull(ls_sarea) Then
	dw_print.object.t_130.text = '전 체'
Else
	dw_print.object.t_130.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(ssarea) ', 1)"))
End If

//거래처
ls_svndnm  = trim(dw_ip.GetItemString(1,'svndnm'))
If ls_svndnm = '' or isNull(ls_svndnm) Then
	dw_print.object.t_140.text = '전 체'
Else
	dw_print.object.t_140.text = ls_svndnm
End If

//생산팀
ls_spteam  = trim(dw_ip.GetItemString(1,'spteam'))
If ls_spteam = '' or isNull(ls_spteam) Then
	dw_print.object.t_150.text = '전 체'
Else
	dw_print.object.t_150.text = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(spteam) ', 1)"))
End If

//제품 분류
ls_itname = trim(dw_ip.GetItemString(1,'sitname'))
If ls_svndnm = '' or isNull(ls_svndnm) Then
	dw_print.object.t_160.text = '전 체'
Else
	dw_print.object.t_160.text = ls_svndnm
End If


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
	CASE 7
		IF tab_1.tabpage_8.dw_8.rowcount() > 0 then 	gi_page = tab_1.tabpage_8.dw_8.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options, tab_1.tabpage_8.dw_8)
	CASE 8
		IF tab_1.tabpage_7.dw_7.rowcount() > 0 then 	gi_page = tab_1.tabpage_7.dw_7.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options, tab_1.tabpage_7.dw_7)
	CASE 9
		IF tab_1.tabpage_9.dw_9.rowcount() > 0 then 	gi_page = tab_1.tabpage_9.dw_9.GetItemNumber(1,"last_page")
		OpenWithParm(w_print_options, tab_1.tabpage_9.dw_9)
END CHOOSE





end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_01530
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
   CASE 7
		IF wf_retrieve8() = -1 THEN
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
   CASE 8
		IF wf_retrieve7() = -1 THEN
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
   CASE 9
		IF wf_retrieve9() = -1 THEN
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







type st_10 from w_standard_print`st_10 within w_sal_01530
end type



type dw_print from w_standard_print`dw_print within w_sal_01530
integer x = 4265
integer y = 180
string dataobject = "d_sal_01530_01_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_01530
integer x = 14
integer y = 28
integer width = 3904
string dataobject = "d_sal_01530"
end type

event dw_ip::itemchanged;string s_itcls, snull, s_itnm, s_ittyp, s_name , ls_gubun,scvnas, sarea, steam, sSaupj, sName1
String scvcod, ls_pdtgu
Long   rtncode 
Datawindowchild state_child
String ls_saupj
int    ireturn 

setnull(snull)

CHOOSE CASE this.GetColumnName()
	Case 'gubun'
		ls_gubun = this.gettext()
	    
		 tab_1.tabpage_1.dw_1.setredraw(false)
		 tab_1.tabpage_2.dw_2.setredraw(false)
		 tab_1.tabpage_3.dw_3.setredraw(false)
		 tab_1.tabpage_4.dw_4.setredraw(false)
		 tab_1.tabpage_5.dw_5.setredraw(false)
		 tab_1.tabpage_6.dw_6.setredraw(false)
		 tab_1.tabpage_7.dw_7.setredraw(false)
		 tab_1.tabpage_8.dw_8.setredraw(false)
		 tab_1.tabpage_9.dw_9.setredraw(false)
		 
		if ls_gubun = '1' then
			tab_1.tabpage_1.dw_1.dataobject = 'd_sal_01530_01'
			tab_1.tabpage_2.dw_2.dataobject = 'd_sal_01530_02'
			tab_1.tabpage_3.dw_3.dataobject = 'd_sal_01530_03'
			tab_1.tabpage_4.dw_4.dataobject = 'd_sal_01530_04'
			tab_1.tabpage_5.dw_5.dataobject = 'd_sal_01530_05'
			tab_1.tabpage_6.dw_6.dataobject = 'd_sal_01530_06'
			tab_1.tabpage_7.dw_7.dataobject = 'd_sal_01530_07'
			tab_1.tabpage_8.dw_8.dataobject = 'd_sal_01530_08'
			tab_1.tabpage_9.dw_9.dataobject = 'd_sal_01530_09'
		else
			tab_1.tabpage_1.dw_1.dataobject = 'd_sal_01530_11'
			tab_1.tabpage_2.dw_2.dataobject = 'd_sal_01530_12'
			tab_1.tabpage_3.dw_3.dataobject = 'd_sal_01530_13'
			tab_1.tabpage_4.dw_4.dataobject = 'd_sal_01530_14'
			tab_1.tabpage_5.dw_5.dataobject = 'd_sal_01530_15'
			tab_1.tabpage_6.dw_6.dataobject = 'd_sal_01530_16'
			tab_1.tabpage_7.dw_7.dataobject = 'd_sal_01530_17'
			tab_1.tabpage_8.dw_8.dataobject = 'd_sal_01530_18'
			tab_1.tabpage_9.dw_9.dataobject = 'd_sal_01530_19'
		end if
		
		 tab_1.tabpage_1.dw_1.setredraw(true)
		 tab_1.tabpage_2.dw_2.setredraw(true)
		 tab_1.tabpage_3.dw_3.setredraw(true)
		 tab_1.tabpage_4.dw_4.setredraw(true)
		 tab_1.tabpage_5.dw_5.setredraw(true)
		 tab_1.tabpage_6.dw_6.setredraw(true)
		 tab_1.tabpage_7.dw_7.setredraw(true)
		 tab_1.tabpage_8.dw_8.setredraw(true)
		 tab_1.tabpage_9.dw_9.setredraw(true)
		
		tab_1.tabpage_1.dw_1.settransobject(sqlca)
		tab_1.tabpage_2.dw_2.settransobject(sqlca)
		tab_1.tabpage_3.dw_3.settransobject(sqlca)
		tab_1.tabpage_4.dw_4.settransobject(sqlca)
		tab_1.tabpage_5.dw_5.settransobject(sqlca)
		tab_1.tabpage_6.dw_6.settransobject(sqlca)
		tab_1.tabpage_7.dw_7.settransobject(sqlca)
		tab_1.tabpage_8.dw_8.settransobject(sqlca)
		tab_1.tabpage_9.dw_9.settransobject(sqlca)

	CASE 'ssteam'
   	this.accepttext()
	
	   s_ssteam = this.GetText()
   
	   if s_ssteam = "" or isnull(s_ssteam) then 
		   this.setitem(1, 'ssteam', snull)
         return 
	   end if	
	
   	ireturn = f_get_name2('영업팀', 'Y', s_ssteam, s_name, s_ittyp)	

      this.setitem(1, 'ssteam', s_ssteam)
	
	   return ireturn 

	CASE 'ssarea'
   	this.accepttext()
	
	   s_ssarea = this.GetText()
	
	   if s_ssarea = "" or isnull(s_ssarea) then 
		   this.setitem(1, 'ssarea', snull)
         return 
	   end if	
	
   	ireturn = f_get_name2('관할구역', 'Y', s_ssarea, s_name, s_ittyp)	

      this.setitem(1, 'ssarea', s_ssarea)
	
	   return ireturn 

   CASE 'svndcod'

		s_svndcod = this.GetText()
   	If 	f_get_cvnames('1', s_svndcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
				SetItem(1,"svndcod",  		snull)
				SetItem(1,"svndnm",		snull)
			Return 1
		ELSE
			ls_saupj = dw_ip.object.porgu[1] 
			if ls_saupj = sSaupj or ls_saupj = '%' then 
				SetItem(1,"svndcod",  		s_svndcod)
				SetItem(1,"svndnm",		scvnas)
			else
				Messagebox('확인', scvnas + '[ ' + s_svndcod +  ' ]에 등록된 사업장 다릅니다. ~n 사업장 정보를 확인하세요' )
				
			End if 
		END IF
		
		return 1 
		
		
	CASE 'spteam'
		
		s_spteam = this.GetText()
		
		if s_spteam = "" or isnull(s_spteam) then 
         return 
	   end if	
		
		s_spteamnm = f_get_reffer('03',s_spteam)
		
		if	(s_spteamnm = '') or isNull(s_spteamnm) then    // 생산팀 CHECK
       	f_Message_Chk(33, '[생산팀]')
			this.setitem(1, 'spteam', snull)
      	Return 1
      end if

	CASE 'sittyp'
		
		s_sittyp = this.GetText()
		
		if s_sittyp = "" or isnull(s_sittyp) then 
         return 
	   end if	
		
		s_name = f_get_reffer('05',s_sittyp)
		
		if	(s_name = '') or isNull(s_name) then    // 품목구분 CHECK
       	f_Message_Chk(33, '[제품구분]')
			this.setitem(1, 'sittyp', snull)
      	Return 1
      end if
		 
	CASE 'sitcls'
   	this.accepttext()
	
	   s_itcls = this.GetText()
	
   	s_ittyp = this.getitemstring(1, 'sittyp')
   
	   if s_itcls = "" or isnull(s_itcls) then 
		   this.setitem(1, 'sitname', snull)
         return 
	   end if	
	
   	ireturn = f_get_name2('품목분류', 'Y', s_itcls, s_itnm, s_ittyp)	

      this.setitem(1, 'sitcls', s_itcls)
      this.setitem(1, 'sitname', s_itnm)
	
	   return ireturn 
	
	case 'porgu' 
		STRING ls_return, ls_sarea , ls_steam, ls_emp_id
			  
		ls_saupj = gettext() 
		//거래처
		sCvcod 	= this.object.svndcod[1] 
		f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1)
		if ls_saupj <> ssaupj and ls_saupj <> '%' then 
			SetItem(1, 'svndcod', sNull)
			SetItem(1, 'svndnm', snull)
		End if 
 
		//관할 구역
		f_child_saupj(dw_ip, 'ssarea', ls_saupj)
		ls_sarea = dw_ip.object.ssarea[1] 
		ls_return = f_saupj_chk_t('1' , ls_sarea ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'ssarea', '')
		End if 
		//영업팀
		f_child_saupj(dw_ip, 'ssteam', ls_saupj) 
		ls_steam = dw_ip.object.ssteam[1] 
		ls_return = f_saupj_chk_t('2' , ls_steam ) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'ssteam', '')
		End if 

		//생산팀
		rtncode 	= dw_ip.GetChild('spteam', state_child)
		IF rtncode = -1 THEN MessageBox("Error", "Not a DataWindowChild - 생산팀")
		state_child.SetTransObject(SQLCA)
		state_child.Retrieve('03',ls_saupj)
		ls_pdtgu = dw_ip.object.spteam[1] 
		ls_return = f_saupj_chk_t('4' , ls_pdtgu) 
		if ls_return <> ls_saupj and ls_saupj <> '%' then 
				dw_ip.setitem(1, 'spteam', '')
		End if 
		
END CHOOSE


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;string sname
str_itnct sStr_sitnct

setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'sitcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'sittyp')
	OpenWithParm(w_ittyp_popup9, sname)
	
   sStr_sitnct = Message.PowerObjectParm	
	
	if isnull(sstr_sitnct.s_ittyp) or sstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"sittyp",sstr_sitnct.s_ittyp)
   
	this.SetItem(1,"sitcls", sstr_sitnct.s_sumgub)
	this.SetItem(1,"sitname", sstr_sitnct.s_titnm)
ELSEIF this.GetColumnName() = "svndcod" THEN
	gs_gubun = '1'
	
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	dw_ip.SetItem(1, "svndcod", gs_Code)
	dw_ip.SetItem(1, "svndnm",  gs_CodeName)
	
	
END IF

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

type dw_list from w_standard_print`dw_list within w_sal_01530
boolean visible = false
integer x = 3931
integer y = 224
integer width = 169
integer height = 36
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type tab_1 from tab within w_sal_01530
integer x = 55
integer y = 316
integer width = 4539
integer height = 1968
integer taborder = 40
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
tabpage_8 tabpage_8
tabpage_7 tabpage_7
tabpage_9 tabpage_9
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_8=create tabpage_8
this.tabpage_7=create tabpage_7
this.tabpage_9=create tabpage_9
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_8,&
this.tabpage_7,&
this.tabpage_9}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_8)
destroy(this.tabpage_7)
destroy(this.tabpage_9)
end on

event selectionchanged;
CHOOSE CASE newindex

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

	CASE 7
		p_print.Enabled = s_p7

	CASE 9
		p_print.Enabled = s_p9

END CHOOSE
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4503
integer height = 1856
long backcolor = 32106727
string text = "영업팀별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 553648127
rr_1 rr_1
dw_1 dw_1
end type

on tabpage_1.create
this.rr_1=create rr_1
this.dw_1=create dw_1
this.Control[]={this.rr_1,&
this.dw_1}
end on

on tabpage_1.destroy
destroy(this.rr_1)
destroy(this.dw_1)
end on

type rr_1 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 32
integer width = 4439
integer height = 1804
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within tabpage_1
integer x = 41
integer y = 40
integer width = 4416
integer height = 1784
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_01530_01"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4503
integer height = 1856
long backcolor = 32106727
string text = "관할구역별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_2 rr_2
dw_2 dw_2
end type

on tabpage_2.create
this.rr_2=create rr_2
this.dw_2=create dw_2
this.Control[]={this.rr_2,&
this.dw_2}
end on

on tabpage_2.destroy
destroy(this.rr_2)
destroy(this.dw_2)
end on

type rr_2 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 32
integer width = 4439
integer height = 1804
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from datawindow within tabpage_2
integer x = 41
integer y = 40
integer width = 4416
integer height = 1788
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_01530_02"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4503
integer height = 1856
long backcolor = 32106727
string text = "거래처별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_3 dw_3
end type

on tabpage_3.create
this.rr_3=create rr_3
this.dw_3=create dw_3
this.Control[]={this.rr_3,&
this.dw_3}
end on

on tabpage_3.destroy
destroy(this.rr_3)
destroy(this.dw_3)
end on

type rr_3 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 32
integer width = 4439
integer height = 1804
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_3 from datawindow within tabpage_3
integer x = 41
integer y = 40
integer width = 4416
integer height = 1788
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_01530_03"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4503
integer height = 1856
long backcolor = 32106727
string text = "생산팀별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_4 rr_4
dw_4 dw_4
end type

on tabpage_4.create
this.rr_4=create rr_4
this.dw_4=create dw_4
this.Control[]={this.rr_4,&
this.dw_4}
end on

on tabpage_4.destroy
destroy(this.rr_4)
destroy(this.dw_4)
end on

type rr_4 from roundrectangle within tabpage_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 32
integer width = 4439
integer height = 1804
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_4 from datawindow within tabpage_4
integer x = 41
integer y = 40
integer width = 4421
integer height = 1784
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_01530_04"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4503
integer height = 1856
long backcolor = 32106727
string text = "대분류별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_5 rr_5
dw_5 dw_5
end type

on tabpage_5.create
this.rr_5=create rr_5
this.dw_5=create dw_5
this.Control[]={this.rr_5,&
this.dw_5}
end on

on tabpage_5.destroy
destroy(this.rr_5)
destroy(this.dw_5)
end on

type rr_5 from roundrectangle within tabpage_5
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 32
integer width = 4439
integer height = 1804
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_5 from datawindow within tabpage_5
integer x = 41
integer y = 40
integer width = 4416
integer height = 1788
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_01530_05"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4503
integer height = 1856
long backcolor = 32106727
string text = "중분류별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_7 rr_7
dw_6 dw_6
end type

on tabpage_6.create
this.rr_7=create rr_7
this.dw_6=create dw_6
this.Control[]={this.rr_7,&
this.dw_6}
end on

on tabpage_6.destroy
destroy(this.rr_7)
destroy(this.dw_6)
end on

type rr_7 from roundrectangle within tabpage_6
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 28
integer width = 4453
integer height = 1816
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_6 from datawindow within tabpage_6
integer x = 46
integer y = 36
integer width = 4421
integer height = 1808
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_01530_06"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_8 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 96
integer width = 4503
integer height = 1856
long backcolor = 32106727
string text = "소분류별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_6 rr_6
dw_8 dw_8
end type

on tabpage_8.create
this.rr_6=create rr_6
this.dw_8=create dw_8
this.Control[]={this.rr_6,&
this.dw_8}
end on

on tabpage_8.destroy
destroy(this.rr_6)
destroy(this.dw_8)
end on

type rr_6 from roundrectangle within tabpage_8
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 32
integer width = 4439
integer height = 1804
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_8 from datawindow within tabpage_8
integer x = 37
integer y = 36
integer width = 4421
integer height = 1792
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_01530_08"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 4503
integer height = 1856
long backcolor = 32106727
string text = "제품별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_8 rr_8
dw_7 dw_7
end type

on tabpage_7.create
this.rr_8=create rr_8
this.dw_7=create dw_7
this.Control[]={this.rr_8,&
this.dw_7}
end on

on tabpage_7.destroy
destroy(this.rr_8)
destroy(this.dw_7)
end on

type rr_8 from roundrectangle within tabpage_7
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 32
integer width = 4439
integer height = 1804
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_7 from datawindow within tabpage_7
integer x = 37
integer y = 36
integer width = 4421
integer height = 1792
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_01530_07"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_9 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 96
integer width = 4503
integer height = 1856
long backcolor = 32106727
string text = "차종/모델별"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_9 rr_9
dw_9 dw_9
end type

on tabpage_9.create
this.rr_9=create rr_9
this.dw_9=create dw_9
this.Control[]={this.rr_9,&
this.dw_9}
end on

on tabpage_9.destroy
destroy(this.rr_9)
destroy(this.dw_9)
end on

type rr_9 from roundrectangle within tabpage_9
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 32
integer width = 4439
integer height = 1804
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_9 from datawindow within tabpage_9
integer x = 37
integer y = 36
integer width = 4421
integer height = 1792
integer taborder = 30
string title = "none"
string dataobject = "d_sal_01530_09"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

