$PBExportHeader$w_sal_04600.srw
$PBExportComments$월별 이자지급 현황
forward
global type w_sal_04600 from w_standard_print
end type
type tab_1 from tab within w_sal_04600
end type
type tab1 from userobject within tab_1
end type
type dw_list1 from datawindow within tab1
end type
type tab1 from userobject within tab_1
dw_list1 dw_list1
end type
type tab2 from userobject within tab_1
end type
type dw_list2 from datawindow within tab2
end type
type tab2 from userobject within tab_1
dw_list2 dw_list2
end type
type tab3 from userobject within tab_1
end type
type dw_list3 from datawindow within tab3
end type
type tab3 from userobject within tab_1
dw_list3 dw_list3
end type
type tab4 from userobject within tab_1
end type
type dw_list4 from datawindow within tab4
end type
type tab4 from userobject within tab_1
dw_list4 dw_list4
end type
type tab_1 from tab within w_sal_04600
tab1 tab1
tab2 tab2
tab3 tab3
tab4 tab4
end type
end forward

global type w_sal_04600 from w_standard_print
integer height = 2388
string title = "월별 이자지급 현황"
long backcolor = 80859087
tab_1 tab_1
end type
global w_sal_04600 w_sal_04600

type variables
datawindow dw_select
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sYear, sYM, sMonth, sSteam, sT_Name, sSarea, sS_Name
long ll_gubun

If dw_ip.AcceptText() <> 1 Then Return 0

ll_gubun=dw_ip.getitemnumber(1,'gubun')

sYear = Trim(dw_ip.GetItemString(1,'syy'))
if	(sYear='') or isNull(sYear) then
	f_Message_Chk(35, '[기준년도]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1
end if

if tab_1.SelectedTab > 2 then
   sMonth = Trim(dw_ip.GetItemString(1,'smm'))
   if	(sMonth='') or isNull(sMonth) then
	   f_Message_Chk(35, '[기준월]')
	   dw_ip.setcolumn('smm')
	   dw_ip.setfocus()
	   Return -1
   end if	
end if

sSteam = Trim(dw_ip.GetItemString(1,'ssteam'))
if isNull(sSteam) or (sSteam = '') then
	sSteam = ''
	sT_Name = '전 체'
else
	Select steamnm Into :sT_Name 
	From steam
	Where steamcd = :sSteam;
	if isNull(sT_Name) then
		sT_Name = ''
	end if	
end if

sSarea = Trim(dw_ip.GetItemString(1,'ssarea'))
if isNull(sSarea) or (sSarea = '') then
	sSarea = ''
	sS_Name = '전 체'
else
	Select sareanm Into :sS_Name 
	From sarea
	Where sarea = :sSarea;
	if isNull(sS_Name) then
		sS_Name = ''
	end if
end if

sSteam = sSteam + '%'
sSarea = sSarea + '%'

string ls_silgu

SELECT DATANAME
INTO   :ls_silgu
FROM   SYSCNFG
WHERE  SYSGU = 'S'   AND
       SERIAL = '8'  AND
       LINENO = '40' ;

Choose Case tab_1.SelectedTab
	Case 1
      sYM = sYear + '01'
      dw_select.object.r_yy.Text = sYear + '년'
      dw_select.object.r_steam.Text = sT_Name
      dw_select.object.r_sarea.Text = sT_Name
		
		if dw_select.Retrieve(gs_sabu, sYear, sYM, sSteam, sSarea,ll_gubun) < 1 then
      	f_message_Chk(300, '[출력조건 CHECK]')
      	dw_ip.setcolumn('syy')
      	dw_ip.setfocus()
      	return -1
      end if
		if ll_gubun=1 then
			 dw_select.object.tx_gubun.text ='장려금'
		else
			dw_select.object.tx_gubun.text ='지체상금'
		end if
	Case 2
      dw_select.object.r_yy.Text = sYear + '년'
      dw_select.object.r_steam.Text = sT_Name
      dw_select.object.r_sarea.Text = sT_Name

      if dw_select.Retrieve(gs_sabu, sYear, sSteam, sSarea,ll_gubun,ls_silgu) < 1 then
      	f_message_Chk(300, '[출력조건 CHECK]')
      	dw_ip.setcolumn('syy')
      	dw_ip.setfocus()
      	return -1
      end if
		if ll_gubun=1 then
			 dw_select.object.ija_t.text='장려금'
			 dw_select.object.ija1_t.text='장려금'
			 dw_select.object.ija2_t.text='장려금'
			 dw_select.object.ija3_t.text='장려금'
			 dw_select.object.tx_gubun.text ='장려금'
		else
			dw_select.object.ija_t.text='지체상금'
			dw_select.object.ija1_t.text='지체상금'
			dw_select.object.ija2_t.text='지체상금'
			dw_select.object.ija3_t.text='지체상금'
			dw_select.object.tx_gubun.text ='지체상금'
		end if
	Case 3
      sYM = sYear + sMonth
      dw_select.object.r_title.Text = String(Integer(sMonth)) + '월 수금분 이자정산 내역'
      dw_select.object.r_yy.Text = sYear + '년'		
      dw_select.object.r_steam.Text = sT_Name
      dw_select.object.r_sarea.Text = sT_Name

      if dw_select.Retrieve(sYM, sSteam, sSarea,ll_gubun,ls_silgu) < 1 then
      	f_message_Chk(300, '[출력조건 CHECK]')
      	dw_ip.setcolumn('syy')
      	dw_ip.setfocus()
      	return -1
      end if
		if ll_gubun=1 then
			 dw_select.object.ac_ija_t.text='장려금'
			 dw_select.object.tx_gubun.text ='장려금'
		else
			dw_select.object.ac_ija_t.text='지체상금'
			dw_select.object.tx_gubun.text ='지체상금'
		end if
		
	Case 4
      sYM = sYear + sMonth
      dw_select.object.r_ym.Text = sYear + '년 ' + sMonth + '월'
      dw_select.object.r_steam.Text = sT_Name
      dw_select.object.r_sarea.Text = sT_Name

      if dw_select.Retrieve(gs_sabu, sYM, sSteam, sSarea,ll_gubun) < 1 then
      	f_message_Chk(300, '[출력조건 CHECK]')
      	dw_ip.setcolumn('syy')
      	dw_ip.setfocus()
      	return -1
      end if		
	  	if ll_gubun=1 then
			 dw_select.object.ija_amt_t.text='장려금'
			 dw_select.object.tx_gubun.text ='장려금'
		else
			dw_select.object.ija_amt_t.text='지체상금'
			dw_select.object.tx_gubun.text ='지체상금'
		end if	
end Choose

return 1
end function

on w_sal_04600.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_sal_04600.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event open;call super::open;tab_1.SelectedTab = 1

dw_select = tab_1.tab1.dw_list1
tab_1.TriggerEvent(SelectionChanged!)

sle_msg.Text = '출력선택을 선택하고 출력조건을 입력하세요'

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.Modify("ssteam.protect=1")
	dw_ip.Modify("ssteam.background.color = 80859087")
	dw_ip.Modify("ssarea.protect=1")
	dw_ip.Modify("ssarea.background.color = 80859087")
End If
dw_ip.SetItem(1, "ssteam", sarea)
dw_ip.SetItem(1, "ssarea", sarea)

dw_ip.setitem(1,'syy',left(f_today(),4))
dw_ip.setitem(1,'smm',mid(f_today(),5,2))
dw_ip.SetFocus()

/* 야금 사용안함 */
tab_1.tab4.visible = false
tab_1.tab3.visible = false


end event

type p_preview from w_standard_print`p_preview within w_sal_04600
string picturename = "c:\erpman\image\미리보기_d.gif"
end type

type p_exit from w_standard_print`p_exit within w_sal_04600
string picturename = "c:\erpman\image\닫기_up.gif"
end type

type p_print from w_standard_print`p_print within w_sal_04600
string picturename = "c:\erpman\image\인쇄_d.gif"
end type

event p_print::clicked;IF dw_select.rowcount() > 0 then 
	gi_page = dw_select.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_select)


end event

type p_retrieve from w_standard_print`p_retrieve within w_sal_04600
string picturename = "c:\erpman\image\조회_up.gif"
end type





type st_10 from w_standard_print`st_10 within w_sal_04600
end type



type dw_ip from w_standard_print`dw_ip within w_sal_04600
integer height = 952
string dataobject = "d_sal_04600"
end type

event dw_ip::itemchanged;String sCol_Name, sNull, s_mm

dw_Ip.AcceptText()
sCol_Name = This.GetColumnName()
SetNull(sNull)

Choose Case sCol_Name
   // 기준년도 유효성 Check
	Case "syy"  
		if (Not(isNumber(Trim(this.getText())))) or (Len(Trim(this.getText())) <> 4) then
			f_Message_Chk(35, '[기준년도]')
			this.SetItem(1, "syy", sNull)
			return 1
		end if
		
   // 기준월 유효성 Check
	Case "smm"  
		s_mm = Trim(this.GetText())
		if Integer(s_mm) < 1 or Integer(s_mm) > 12 then
			f_Message_Chk(35, '[기준월]')
			this.SetItem(1, "smm", sNull)
			return 1
		end if
		s_mm = Mid('0' + s_mm, Len(s_mm), 2)
		this.SetItem(1, 'smm', s_mm)
		return 2
	Case 'prtgbn'

end Choose
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_04600
boolean visible = false
integer x = 402
integer y = 2164
integer width = 745
integer height = 524
boolean enabled = false
string dataobject = ""
end type

type tab_1 from tab within w_sal_04600
integer x = 809
integer y = 24
integer width = 2830
integer height = 2048
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tab1 tab1
tab2 tab2
tab3 tab3
tab4 tab4
end type

on tab_1.create
this.tab1=create tab1
this.tab2=create tab2
this.tab3=create tab3
this.tab4=create tab4
this.Control[]={this.tab1,&
this.tab2,&
this.tab3,&
this.tab4}
end on

on tab_1.destroy
destroy(this.tab1)
destroy(this.tab2)
destroy(this.tab3)
destroy(this.tab4)
end on

event selectionchanged;//dw_ip.Object.prtgbn_t.visible = '0'
//dw_ip.Object.prtgbn.visible = '0'

Choose Case newindex
	Case 1
  		dw_select = tab_1.tab1.dw_list1			
	Case 2
//		dw_ip.Object.prtgbn_t.visible = '1'
//		dw_ip.Object.prtgbn.visible = '1'
		
		dw_select = tab_1.tab2.dw_list2
	Case 3
		dw_select = tab_1.tab3.dw_list3
	Case 4
		dw_select = tab_1.tab4.dw_list4		
End Choose
	
dw_select.SetTransObject(sqlca)
end event

type tab1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2793
integer height = 1936
long backcolor = 79741120
string text = "수금분이자정산금액현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_list1 dw_list1
end type

on tab1.create
this.dw_list1=create dw_list1
this.Control[]={this.dw_list1}
end on

on tab1.destroy
destroy(this.dw_list1)
end on

type dw_list1 from datawindow within tab1
integer x = 14
integer y = 20
integer width = 2766
integer height = 1908
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_04600_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tab2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2793
integer height = 1936
long backcolor = 79741120
string text = "수금분이자정산지급현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_list2 dw_list2
end type

on tab2.create
this.dw_list2=create dw_list2
this.Control[]={this.dw_list2}
end on

on tab2.destroy
destroy(this.dw_list2)
end on

type dw_list2 from datawindow within tab2
integer x = 14
integer y = 20
integer width = 2766
integer height = 1908
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_04600_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tab3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2793
integer height = 1936
long backcolor = 79741120
string text = "월수금분이자정산내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_list3 dw_list3
end type

on tab3.create
this.dw_list3=create dw_list3
this.Control[]={this.dw_list3}
end on

on tab3.destroy
destroy(this.dw_list3)
end on

type dw_list3 from datawindow within tab3
integer x = 14
integer y = 20
integer width = 2766
integer height = 1908
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_04600_03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type tab4 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 2793
integer height = 1936
long backcolor = 79741120
string text = "월현금수금현황"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_list4 dw_list4
end type

on tab4.create
this.dw_list4=create dw_list4
this.Control[]={this.dw_list4}
end on

on tab4.destroy
destroy(this.dw_list4)
end on

type dw_list4 from datawindow within tab4
integer x = 14
integer y = 20
integer width = 2766
integer height = 1908
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sal_04600_04"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

