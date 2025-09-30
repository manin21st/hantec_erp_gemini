$PBExportHeader$w_pdt_07700.srw
$PBExportComments$매입금액분석
forward
global type w_pdt_07700 from w_inherite
end type
type tab_1 from tab within w_pdt_07700
end type
type tabpage_1 from userobject within tab_1
end type
type p_2 from uo_picture within tabpage_1
end type
type p_1 from uo_picture within tabpage_1
end type
type dw_tab12 from u_d_select_sort within tabpage_1
end type
type dw_tab11 from datawindow within tabpage_1
end type
type rr_3 from roundrectangle within tabpage_1
end type
type tabpage_1 from userobject within tab_1
p_2 p_2
p_1 p_1
dw_tab12 dw_tab12
dw_tab11 dw_tab11
rr_3 rr_3
end type
type tabpage_2 from userobject within tab_1
end type
type rr_2 from roundrectangle within tabpage_2
end type
type p_4 from uo_picture within tabpage_2
end type
type p_3 from uo_picture within tabpage_2
end type
type dw_tab21 from datawindow within tabpage_2
end type
type dw_tab22 from u_d_select_sort within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rr_2 rr_2
p_4 p_4
p_3 p_3
dw_tab21 dw_tab21
dw_tab22 dw_tab22
end type
type tabpage_3 from userobject within tab_1
end type
type rr_1 from roundrectangle within tabpage_3
end type
type p_6 from uo_picture within tabpage_3
end type
type p_5 from uo_picture within tabpage_3
end type
type dw_tab32 from u_d_select_sort within tabpage_3
end type
type dw_tab31 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
rr_1 rr_1
p_6 p_6
p_5 p_5
dw_tab32 dw_tab32
dw_tab31 dw_tab31
end type
type tab_1 from tab within w_pdt_07700
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_pdt_07700 from w_inherite
integer height = 2516
string title = "매입마감금액분석"
tab_1 tab_1
end type
global w_pdt_07700 w_pdt_07700

type variables
string  is_ispec, is_jijil
end variables

on w_pdt_07700.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_pdt_07700.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event open;call super::open;tab_1.tabpage_1.dw_tab11.settransobject(sqlca)
tab_1.tabpage_1.dw_tab12.settransobject(sqlca)
tab_1.tabpage_2.dw_tab21.settransobject(sqlca)
tab_1.tabpage_2.dw_tab22.settransobject(sqlca)
tab_1.tabpage_3.dw_tab31.settransobject(sqlca)
tab_1.tabpage_3.dw_tab32.settransobject(sqlca)

tab_1.tabpage_1.dw_tab11.insertrow(0)
tab_1.tabpage_1.dw_tab11.setitem(1, "sdate", left(f_today(), 6)+'01')
tab_1.tabpage_1.dw_tab11.setitem(1, "edate", left(f_today(), 6)+'31')

tab_1.tabpage_2.dw_tab21.insertrow(0)
tab_1.tabpage_2.dw_tab21.setitem(1, "sdate", left(f_today(), 6)+'01')
tab_1.tabpage_2.dw_tab21.setitem(1, "edate", left(f_today(), 6)+'31')

tab_1.tabpage_3.dw_tab31.insertrow(0)
tab_1.tabpage_3.dw_tab31.setitem(1, "sdate", left(f_today(), 6))
tab_1.tabpage_3.dw_tab31.setitem(1, "edate", left(f_today(), 6))

// 환경설정에 의한 기준 setting
String soption
select dataname
  into :soption
  from syscnfg
 where sysgu = 'Y' and serial = '23' and lineno = '1';
 
if soption = '1' then
	tab_1.tabpage_1.dw_tab11.setitem(1, "option", '1')	
	tab_1.tabpage_2.dw_tab21.setitem(1, "option", '1')		
	tab_1.tabpage_3.dw_tab31.setitem(1, "option", '1')		
else
	tab_1.tabpage_1.dw_tab11.setitem(1, "option", '2')	
	tab_1.tabpage_2.dw_tab21.setitem(1, "option", '2')	
	tab_1.tabpage_3.dw_tab31.setitem(1, "option", '2')	
end if

IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
   tab_1.tabpage_1.dw_tab12.object.ispec_t.text = is_ispec
   tab_1.tabpage_1.dw_tab12.object.jijil_t.text = is_jijil
END IF

/* 부가 사업장(tabpage_1) */
setnull(gs_code)
If f_check_saupj() = 1 Then
	tab_1.tabpage_1.dw_tab11.SetItem(1, 'saupj', gs_code)
	if gs_code <> '%' then
		tab_1.tabpage_1.dw_tab11.Modify("saupj.protect=1")
		tab_1.tabpage_1.dw_tab11.Modify("saupj.background.color = 80859087")
	End if
End If

/* 부가 사업장(tabpage_2) */
setnull(gs_code)
If f_check_saupj() = 1 Then
	tab_1.tabpage_2.dw_tab21.SetItem(1, 'saupj', gs_code)
	if gs_code <> '%' then
		tab_1.tabpage_2.dw_tab21.Modify("saupj.protect=1")
		tab_1.tabpage_2.dw_tab21.Modify("saupj.background.color = 80859087")
	End if
End If

/* 부가 사업장(tabpage_3) */
setnull(gs_code)
If f_check_saupj() = 1 Then
	tab_1.tabpage_3.dw_tab31.SetItem(1, 'saupj', gs_code)
	if gs_code <> '%' then
		tab_1.tabpage_3.dw_tab31.Modify("saupj.protect=1")
		tab_1.tabpage_3.dw_tab31.Modify("saupj.background.color = 80859087")
	End if
End If

end event

type dw_insert from w_inherite`dw_insert within w_pdt_07700
boolean visible = false
integer x = 27
integer y = 2284
integer width = 882
integer height = 196
boolean enabled = false
end type

type p_delrow from w_inherite`p_delrow within w_pdt_07700
boolean visible = false
end type

type p_addrow from w_inherite`p_addrow within w_pdt_07700
boolean visible = false
end type

type p_search from w_inherite`p_search within w_pdt_07700
boolean visible = false
end type

type p_ins from w_inherite`p_ins within w_pdt_07700
boolean visible = false
end type

type p_exit from w_inherite`p_exit within w_pdt_07700
boolean visible = false
end type

type p_can from w_inherite`p_can within w_pdt_07700
boolean visible = false
end type

type p_print from w_inherite`p_print within w_pdt_07700
boolean visible = false
end type

type p_inq from w_inherite`p_inq within w_pdt_07700
boolean visible = false
end type

type p_del from w_inherite`p_del within w_pdt_07700
boolean visible = false
end type

type p_mod from w_inherite`p_mod within w_pdt_07700
boolean visible = false
end type

type cb_exit from w_inherite`cb_exit within w_pdt_07700
boolean visible = false
integer x = 2418
integer y = 2344
integer taborder = 100
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_pdt_07700
boolean visible = false
integer x = 855
integer y = 2544
integer taborder = 40
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_07700
boolean visible = false
integer x = 466
integer y = 2544
integer taborder = 30
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdt_07700
boolean visible = false
integer x = 1253
integer y = 2536
integer taborder = 50
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_07700
boolean visible = false
integer x = 1623
integer y = 2532
integer taborder = 60
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pdt_07700
boolean visible = false
integer x = 2039
integer y = 2512
integer taborder = 70
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_07700
end type

type cb_can from w_inherite`cb_can within w_pdt_07700
boolean visible = false
integer x = 1810
integer y = 2572
integer taborder = 80
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pdt_07700
boolean visible = false
integer x = 2793
integer y = 2520
integer taborder = 90
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_07700
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_07700
end type

type tab_1 from tab within w_pdt_07700
integer x = 32
integer y = 32
integer width = 4590
integer height = 2304
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4553
integer height = 2176
long backcolor = 32106727
string text = "품목별 매입금액 분석"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "ListView!"
long picturemaskcolor = 553648127
p_2 p_2
p_1 p_1
dw_tab12 dw_tab12
dw_tab11 dw_tab11
rr_3 rr_3
end type

on tabpage_1.create
this.p_2=create p_2
this.p_1=create p_1
this.dw_tab12=create dw_tab12
this.dw_tab11=create dw_tab11
this.rr_3=create rr_3
this.Control[]={this.p_2,&
this.p_1,&
this.dw_tab12,&
this.dw_tab11,&
this.rr_3}
end on

on tabpage_1.destroy
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_tab12)
destroy(this.dw_tab11)
destroy(this.rr_3)
end on

type p_2 from uo_picture within tabpage_1
integer x = 4370
integer y = 208
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;P_exit.triggerevent(clicked!)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\닫기_dn.gif"
end event

type p_1 from uo_picture within tabpage_1
integer x = 4201
integer y = 208
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sdate, edate, sittyp, sitcls, ssitnbr, seitnbr, spdtgu, spdtname, soption, &
       sgubun, swaigu, ssaupj

if dw_tab11.accepttext() = -1 then return 

sdate 	= trim(dw_tab11.getitemstring(1, "sdate"))
edate 	= trim(dw_tab11.getitemstring(1, "edate"))
sittyp	= dw_tab11.getitemstring(1, "ittyp")
sgubun	= dw_tab11.getitemstring(1, "gubun")
sitcls	= dw_tab11.getitemstring(1, "itcls")
ssitnbr	= dw_tab11.getitemstring(1, "itnbr1")
seitnbr	= dw_tab11.getitemstring(1, "itnbr2")
soption	= dw_tab11.getitemstring(1, "option")
swaigu	= dw_tab11.getitemstring(1, "maip")
ssaupj	= dw_tab11.getitemstring(1, "saupj")

if (IsNull(sdate) or sdate = "")  then 
	f_message_chk(30,'[기준일자]')
	dw_tab11.SetColumn("sdate")
	dw_tab11.Setfocus()
	return 
end if

if (IsNull(edate) or edate = "")  then 
	f_message_chk(30,'[기준일자]')
	dw_tab11.SetColumn("edate")
	dw_tab11.Setfocus()
	return 
end if

if isnull(sittyp)  	or trim(sittyp)  	= '' then sittyp = '%';
if isnull(sitcls)  	or trim(sitcls)  	= '' then sitcls = '%';
if isnull(sgubun)  	or trim(sgubun)  	= '' then sgubun = '%';
if isnull(ssitnbr) 	or trim(ssitnbr) 	= '' then ssitnbr = '.';
if isnull(seitnbr) 	or trim(seitnbr) 	= '' then seitnbr = 'ZZZZZZZZZZZZZZZ';

if soption = '1' then
	dw_tab12.dataobject = 'd_pdt_07700_1'
else
	dw_tab12.dataobject = 'd_pdt_07700_2'	
end if

dw_tab12.settransobject(sqlca)

IF f_change_name('1') = 'Y' then 
   tab_1.tabpage_1.dw_tab12.object.ispec_t.text = is_ispec
   tab_1.tabpage_1.dw_tab12.object.jijil_t.text = is_jijil
END IF

if dw_tab12.retrieve(gs_sabu, sdate, edate, sgubun, sittyp, sitcls, ssitnbr, seitnbr, &
                     swaigu, ssaupj) < 1 then
	f_message_chk(50,'')
	dw_tab11.Setcolumn('sdate')
	dw_tab11.Setfocus()
	Return -1	
end if

dw_tab12.setsort("amt D")
dw_tab12.sort()

setpointer(hourglass!)

decimal a,b
Long Lrow, Lcnt = 1
dw_tab12.setitem(1, "seqno", Lcnt)	
For Lrow = 2 to dw_tab12.rowcount()
	 a = dw_tab12.getitemdecimal(Lrow, "amt")
	 b = dw_tab12.getitemdecimal(Lrow - 1, "amt")
	 if dw_tab12.getitemdecimal(Lrow, "amt") < dw_tab12.getitemdecimal(Lrow - 1, "amt") then
		 Lcnt++
	 End if
	 dw_tab12.setitem(Lrow, "seqno", Lcnt)	
Next

setpointer(arrow!)

RETURN 1
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\조회_dn.gif"
end event

type dw_tab12 from u_d_select_sort within tabpage_1
integer x = 14
integer y = 380
integer width = 4517
integer height = 1772
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_07700_1"
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;Long	 Lrow
String sParm

Lrow = this.getrow()

if Lrow > 0 then
	sParm = dw_tab11.getitemstring(1, "option") + dw_tab11.getitemstring(1, "maip") + &
			  dw_tab11.getitemstring(1, "sdate")  + dw_tab11.getitemstring(1, "edate")  + &
  			  dw_tab11.getitemstring(1, "gubun")  + getitemstring(Lrow, "itnbr")

   gs_code = dw_tab11.getitemstring(1, "saupj")
	
	openwithparm(w_pdt_07700_1, sparm)
end if
end event

type dw_tab11 from datawindow within tabpage_1
event ue_key pbm_dwnkey
event ue_keyenter pbm_dwnprocessenter
integer x = 9
integer y = 8
integer width = 3223
integer height = 352
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdt_07700_0"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_keyenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string  snull, sdate, sData, sittyp, sitem, sname, sspec
integer ireturn
long lrow

lrow = this.getrow()

setnull(snull)

this.accepttext()

IF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[시작일자]')
		this.setitem(1, "sdate", f_today())
		return 1
	END IF
ElseIF this.GetColumnName() = "edate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[종료일자]')
		this.setitem(1, "edate", f_today())
		return 1
	END IF
Elseif this.GetColumnName() = "itcls"	THEN
	sDate 	= trim(this.GetText())
	sIttyp	= this.getitemstring(1, "ittyp")
	Setnull(sData)
	
	select titnm into :sData 
	  From itnct 
	 where ittyp = :sittyp and itcls = :sDate;

	if sqlca.sqlcode <> 0 then
      f_message_chk(33, '[품목분류]')
		this.setitem(1, "itcls", sNull)
		return 1		
	end if	
Elseif this.GetColumnName() = "itnbr1"	THEN
	sitem = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', sitEM, sname, sspec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr1", sitem)	
	this.setitem(lrow, "itdsc1", sname)	
	this.setitem(lrow, "ispec1", sspec)
	RETURN ireturn
ElseIF this.GetColumnName() = "itdsc1"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', sitEM, sname, sspec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr1", sitem)	
	this.setitem(lrow, "itdsc1", sname)	
	this.setitem(lrow, "ispec1", sspec)
	RETURN ireturn
ElseIF this.GetColumnName() = "ispec1"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name2('규격', 'Y', sitEM, sname, sspec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr1", sitem)	
	this.setitem(lrow, "itdsc1", sname)	
	this.setitem(lrow, "ispec1", sspec)
	RETURN ireturn	
Elseif this.GetColumnName() = "itnbr2"	THEN
	sitem = trim(this.GetText())
	ireturn = f_get_name2('품번', 'Y', sitEM, sname, sspec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr2", sitem)	
	this.setitem(lrow, "itdsc2", sname)	
	this.setitem(lrow, "ispec2", sspec)
	RETURN ireturn
ElseIF this.GetColumnName() = "itdsc2"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name2('품명', 'Y', sitEM, sname, sspec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr2", sitem)	
	this.setitem(lrow, "itdsc2", sname)	
	this.setitem(lrow, "ispec2", sspec)
	RETURN ireturn
ElseIF this.GetColumnName() = "ispec2"	THEN
	sNAME = trim(this.GetText())
	ireturn = f_get_name2('규격', 'Y', sitEM, sname, sspec)    //1이면 실패, 0이 성공	
	this.setitem(lrow, "itnbr2", sitem)	
	this.setitem(lrow, "itdsc2", sname)	
	this.setitem(lrow, "ispec2", sspec)
	RETURN ireturn		
END IF
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
gs_gubun = ''
string	sName

str_itnct lstr_sitnct


if this.GetColumnName() = 'itcls' then
   this.accepttext()
	
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
// 품번
ELSEIF this.GetColumnName() = 'itnbr1'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"itnbr1",gs_code)
	SetItem(1,"itdsc1",gs_codename)
	SetItem(1,"ispec1",gs_gubun)
	
	this.TriggerEvent("itemchanged")
// 품번
ELSEIF this.GetColumnName() = 'itnbr2'	THEN

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(1,"itnbr2",gs_code)
	SetItem(1,"itdsc2",gs_codename)
	SetItem(1,"ispec2",gs_gubun)
	
	this.TriggerEvent("itemchanged")	
end if
end event

type rr_3 from roundrectangle within tabpage_1
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 368
integer width = 4539
integer height = 1800
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 4553
integer height = 2176
long backcolor = 32106727
string text = "거래처별 매입금액 분석"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "Report!"
long picturemaskcolor = 553648127
rr_2 rr_2
p_4 p_4
p_3 p_3
dw_tab21 dw_tab21
dw_tab22 dw_tab22
end type

on tabpage_2.create
this.rr_2=create rr_2
this.p_4=create p_4
this.p_3=create p_3
this.dw_tab21=create dw_tab21
this.dw_tab22=create dw_tab22
this.Control[]={this.rr_2,&
this.p_4,&
this.p_3,&
this.dw_tab21,&
this.dw_tab22}
end on

on tabpage_2.destroy
destroy(this.rr_2)
destroy(this.p_4)
destroy(this.p_3)
destroy(this.dw_tab21)
destroy(this.dw_tab22)
end on

type rr_2 from roundrectangle within tabpage_2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 232
integer width = 4539
integer height = 1940
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_4 from uo_picture within tabpage_2
integer x = 4366
integer y = 68
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;p_exit.triggerevent(clicked!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\닫기_up.gif"
end event

type p_3 from uo_picture within tabpage_2
integer x = 4192
integer y = 68
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sdate, edate, sscvcod, secvcod, soption, sgubun, swaigu, ssaupj 

if dw_tab21.accepttext() = -1 then return -1

sdate 	= trim(dw_tab21.getitemstring(1, "sdate"))
edate 	= trim(dw_tab21.getitemstring(1, "edate"))
sgubun	= dw_tab21.getitemstring(1, "gubun")
sscvcod	= dw_tab21.getitemstring(1, "cvcod1")
secvcod	= dw_tab21.getitemstring(1, "cvcod2")
soption	= dw_tab21.getitemstring(1, "option")
swaigu	= dw_tab21.getitemstring(1, "maip")
ssaupj	= dw_tab21.getitemstring(1, "saupj")

if (IsNull(sdate) or sdate = "")  then 
	f_message_chk(30,'[기준일자]')
	dw_tab21.SetColumn("sdate")
	dw_tab21.Setfocus()
	return 
end if

if (IsNull(edate) or edate = "")  then 
	f_message_chk(30,'[기준일자]')
	dw_tab21.SetColumn("edate")
	dw_tab21.Setfocus()
	return 
end if

if isnull(sgubun)  	or trim(sgubun)  	= '' then sgubun = '%';
if isnull(sscvcod) 	or trim(sscvcod) 	= '' then sscvcod = '.';
if isnull(secvcod) 	or trim(secvcod) 	= '' then secvcod = 'ZZZZZZ';

if soption = '1' then
	dw_tab22.dataobject = 'd_pdt_07700_5'
else
	dw_tab22.dataobject = 'd_pdt_07700_6'	
end if

dw_tab22.settransobject(sqlca)

if dw_tab22.retrieve(gs_sabu, sdate, edate, sgubun, sscvcod, secvcod, swaigu, ssaupj) < 1 then
	f_message_chk(50,'')
	dw_tab21.Setcolumn('sdate')
	dw_tab21.Setfocus()
	Return -1	
end if

dw_tab22.setsort("amt D")
dw_tab22.sort()

setpointer(hourglass!)

decimal a,b
Long Lrow, Lcnt = 1
dw_tab22.setitem(1, "seqno", Lcnt)	
For Lrow = 2 to dw_tab22.rowcount()
	 a = dw_tab22.getitemdecimal(Lrow, "amt")
	 b = dw_tab22.getitemdecimal(Lrow - 1, "amt")
	 if dw_tab22.getitemdecimal(Lrow, "amt") < dw_tab22.getitemdecimal(Lrow - 1, "amt") then
		 Lcnt++
	 End if
	 dw_tab22.setitem(Lrow, "seqno", Lcnt)	
Next

setpointer(arrow!)

RETURN 1
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\조회_dn.gif"
end event

type dw_tab21 from datawindow within tabpage_2
event ue_key pbm_dwnkey
event ue_keyenter pbm_dwnprocessenter
integer x = 9
integer y = 16
integer width = 2807
integer height = 216
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pdt_07700_9"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_keyenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string  snull, sdate, sData, sittyp, sitem, sname, sspec
integer ireturn
long lrow

lrow = this.getrow()

setnull(snull)

this.accepttext()

IF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[시작일자]')
		this.setitem(1, "sdate", f_today())
		return 1
	END IF
ElseIF this.GetColumnName() = "edate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[종료일자]')
		this.setitem(1, "edate", f_today())
		return 1
	END IF
END IF
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
gs_gubun = ''
string	sName

str_itnct lstr_sitnct


if this.GetColumnName() = 'cvcod1' then
   this.accepttext()
	
	Open(w_vndmst_popup)
	
	this.SetItem(1,"cvcod1", gs_code)
elseif this.GetColumnName() = 'cvcod2' then
   this.accepttext()
	
	Open(w_vndmst_popup)
	
	this.SetItem(1,"cvcod2", gs_code)	
end if
end event

type dw_tab22 from u_d_select_sort within tabpage_2
integer x = 18
integer y = 240
integer width = 4503
integer height = 1912
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdt_07700_6"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;Long	 Lrow
String sParm

Lrow = this.getrow()

if Lrow > 0 then
	sParm = dw_tab21.getitemstring(1, "option") + dw_tab21.getitemstring(1, "maip") + &
			  dw_tab21.getitemstring(1, "sdate")  + dw_tab21.getitemstring(1, "edate")  + &
  			  dw_tab21.getitemstring(1, "gubun")  + getitemstring(Lrow, "cvcod")

   gs_code = dw_tab21.getitemstring(1, "saupj")
	openwithparm(w_pdt_07700_2, sparm)
end if
end event

type tabpage_3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 4553
integer height = 2176
long backcolor = 32106727
string text = "거래처별 매입금액 비교"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "Report!"
long picturemaskcolor = 553648127
rr_1 rr_1
p_6 p_6
p_5 p_5
dw_tab32 dw_tab32
dw_tab31 dw_tab31
end type

on tabpage_3.create
this.rr_1=create rr_1
this.p_6=create p_6
this.p_5=create p_5
this.dw_tab32=create dw_tab32
this.dw_tab31=create dw_tab31
this.Control[]={this.rr_1,&
this.p_6,&
this.p_5,&
this.dw_tab32,&
this.dw_tab31}
end on

on tabpage_3.destroy
destroy(this.rr_1)
destroy(this.p_6)
destroy(this.p_5)
destroy(this.dw_tab32)
destroy(this.dw_tab31)
end on

type rr_1 from roundrectangle within tabpage_3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 232
integer width = 4526
integer height = 1940
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_6 from uo_picture within tabpage_3
integer x = 4366
integer y = 68
integer width = 178
string picturename = "c:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;p_exit.triggerevent(clicked!)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\닫기_dn.gif"
end event

type p_5 from uo_picture within tabpage_3
integer x = 4192
integer y = 68
integer width = 178
string picturename = "c:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sdate, edate, sscvcod, secvcod, soption, ssaupj

if dw_tab31.accepttext() = -1 then return -1

sdate 	= trim(dw_tab31.getitemstring(1, "sdate"))
edate 	= trim(dw_tab31.getitemstring(1, "edate"))
sscvcod	= dw_tab31.getitemstring(1, "cvcod1")
secvcod	= dw_tab31.getitemstring(1, "cvcod2")
soption	= dw_tab31.getitemstring(1, "option")
ssaupj	= dw_tab31.getitemstring(1, "saupj")

if (IsNull(sdate) or sdate = "")  then 
	f_message_chk(30,'[기준일자]')
	dw_tab31.SetColumn("sdate")
	dw_tab31.Setfocus()
	return 
end if

if (IsNull(edate) or edate = "")  then 
	f_message_chk(30,'[기준일자]')
	dw_tab31.SetColumn("edate")
	dw_tab31.Setfocus()
	return 
end if

if isnull(sscvcod) 	or trim(sscvcod) 	= '' then sscvcod = '.';
if isnull(secvcod) 	or trim(secvcod) 	= '' then secvcod = 'ZZZZZZZZZZZZZZZ';

if soption = '1' then
	dw_tab32.dataobject = 'd_pdt_07700_10'
else
	dw_tab32.dataobject = 'd_pdt_07700_11'	
end if

dw_tab32.settransobject(sqlca)

if dw_tab32.retrieve(gs_sabu, sdate, edate, sscvcod, secvcod, ssaupj) < 1 then
	f_message_chk(50,'')
	dw_tab31.Setcolumn('sdate')
	dw_tab31.Setfocus()
	Return -1	
end if


RETURN 1
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "c:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "c:\erpman\image\조회_dn.gif"
end event

type dw_tab32 from u_d_select_sort within tabpage_3
integer x = 23
integer y = 236
integer width = 4494
integer height = 1916
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_pdt_07700_11"
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_tab31 from datawindow within tabpage_3
event ue_key pbm_dwnkey
event ue_keyenter pbm_dwnprocessenter
integer x = 9
integer y = 16
integer width = 2880
integer height = 216
integer taborder = 30
string dataobject = "d_pdt_07700_12"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_keyenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string  snull, sdate, sData, sittyp, sitem, sname, sspec
integer ireturn
long lrow

lrow = this.getrow()

setnull(snull)

this.accepttext()

IF this.GetColumnName() = "sdate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "sdate", left(is_today, 6))
		return 1
	END IF
ElseIF this.GetColumnName() = "edate"	THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "edate", left(is_today, 6))
		return 1
	END IF
END IF
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
gs_gubun = ''
string	sName

str_itnct lstr_sitnct


if this.GetColumnName() = 'cvcod1' then
   this.accepttext()
	
	Open(w_vndmst_popup)
	
	this.SetItem(1,"cvcod1", gs_code)
elseif this.GetColumnName() = 'cvcod2' then
   this.accepttext()
	
	Open(w_vndmst_popup)
	
	this.SetItem(1,"cvcod2", gs_code)	
end if
end event

