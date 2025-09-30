$PBExportHeader$w_kgle39.srw
$PBExportComments$결산부속명세서 조회 출력
forward
global type w_kgle39 from w_standard_print
end type
type tab_list from tab within w_kgle39
end type
type tabpage_list from userobject within tab_list
end type
type rr_2 from roundrectangle within tabpage_list
end type
type dw_fs_print from datawindow within tabpage_list
end type
type tabpage_list from userobject within tab_list
rr_2 rr_2
dw_fs_print dw_fs_print
end type
type tabpage_list2 from userobject within tab_list
end type
type rr_3 from roundrectangle within tabpage_list2
end type
type dw_fs_print2 from datawindow within tabpage_list2
end type
type tabpage_list2 from userobject within tab_list
rr_3 rr_3
dw_fs_print2 dw_fs_print2
end type
type tabpage_list3 from userobject within tab_list
end type
type rr_4 from roundrectangle within tabpage_list3
end type
type dw_fs_print3 from datawindow within tabpage_list3
end type
type tabpage_list3 from userobject within tab_list
rr_4 rr_4
dw_fs_print3 dw_fs_print3
end type
type tabpage_list4 from userobject within tab_list
end type
type rr_5 from roundrectangle within tabpage_list4
end type
type dw_fs_print4 from datawindow within tabpage_list4
end type
type tabpage_list4 from userobject within tab_list
rr_5 rr_5
dw_fs_print4 dw_fs_print4
end type
type tabpage_list5 from userobject within tab_list
end type
type rr_6 from roundrectangle within tabpage_list5
end type
type dw_fs_print5 from datawindow within tabpage_list5
end type
type tabpage_list5 from userobject within tab_list
rr_6 rr_6
dw_fs_print5 dw_fs_print5
end type
type tabpage_list6 from userobject within tab_list
end type
type rr_7 from roundrectangle within tabpage_list6
end type
type dw_fs_print6 from datawindow within tabpage_list6
end type
type tabpage_list6 from userobject within tab_list
rr_7 rr_7
dw_fs_print6 dw_fs_print6
end type
type tabpage_list7 from userobject within tab_list
end type
type rr_8 from roundrectangle within tabpage_list7
end type
type dw_fs_print7 from datawindow within tabpage_list7
end type
type tabpage_list7 from userobject within tab_list
rr_8 rr_8
dw_fs_print7 dw_fs_print7
end type
type tabpage_list8 from userobject within tab_list
end type
type rr_9 from roundrectangle within tabpage_list8
end type
type dw_fs_print8 from datawindow within tabpage_list8
end type
type tabpage_list8 from userobject within tab_list
rr_9 rr_9
dw_fs_print8 dw_fs_print8
end type
type tab_list from tab within w_kgle39
tabpage_list tabpage_list
tabpage_list2 tabpage_list2
tabpage_list3 tabpage_list3
tabpage_list4 tabpage_list4
tabpage_list5 tabpage_list5
tabpage_list6 tabpage_list6
tabpage_list7 tabpage_list7
tabpage_list8 tabpage_list8
end type
end forward

global type w_kgle39 from w_standard_print
integer x = 0
integer y = 0
string title = "결산부속명세서 조회 출력"
tab_list tab_list
end type
global w_kgle39 w_kgle39

type variables
DataWindow  Idw_fs_print
Integer            icur_tabpage
end variables

forward prototypes
public function integer wf_print ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_print ();
IF Idw_fs_print.RowCount() <=0 THEN
	gi_page = Idw_fs_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF

OpenWithParm(w_print_options,Idw_fs_print)

Return -1
end function

public function integer wf_retrieve ();
String  sSaupj,sYearMonthDay,sDcrGbn,sAcc1,sAcc2,sFromAcc,sToAcc,sFromYm,sToYm,sYm00
Integer iRowCount
Long    Lyear,LjYear
Double  dRate

if dw_ip.AcceptText() = -1 then return -1

sSaupj        = dw_ip.GetItemString(1, 'saupj')
sYearMonthDay = trim(dw_ip.GetItemString(1, 'k_symd'))
sAcc1         = trim(dw_ip.GetItemString(1, 'sacc1'))
sAcc2         = trim(dw_ip.GetItemString(1, 'sacc2'))
sDcrGbn       = dw_ip.GetItemString(1, 'dcgu')

IF sSaupj = "" OR IsNull(sSaupj) THEN
	F_MessageChk(1,'[사업장]')
	dw_ip.SetColumn("saupj")
	dw_ip.SetFocus()
	Return -1
END IF

IF sYearMonthDay = "" OR IsNull(sYearMonthDay) THEN
	F_MessageChk(1, "[결산기준일]")				
   dw_ip.SetColumn('k_symd')
	dw_ip.SetFocus()
	return -1
END IF

if f_accountyear (Left(sYearMonthDay,6) , sFromYm, sToYm, sYm00, Lyear, LjYear ) <> 1 then return -1 

IF sAcc1 = "" OR IsNull(sAcc1) THEN
	sFromAcc = '1000000';			sToAcc = '9999999';
ELSE
	SELECT "FRACC1_CD"||"FRACC2_CD",	"TOACC1_CD"||"TOACC2_CD"		
		INTO :sFromAcc,					:sToAcc
		FROM "KFZ01OM0"  
		WHERE "ACC1_CD" = :sAcc1 AND "ACC2_CD" = :sAcc2 ;
	IF SQLCA.SQLCODE = 0 THEN
		IF sFromAcc = "" OR IsNull(sFromAcc) OR sToAcc = "" OR IsNull(sToAcc) THEN
			F_MessageChk(25,'[시작/종료계정]')
			dw_ip.SetColumn("acc1_cd")			
			Return -1
		END IF
	END IF	
END IF	
IF sDcrGbn = '' OR IsNull(sDcrGbn) THEN sDcrGbn = '%'

CHOOSE CASE iCur_TabPage
	CASE 1,2,3,4,7								/*현금예금,외상매출금,외상매입금,외화외상매입금,미지급금*/
		iRowCount = dw_print.Retrieve(sabu_f,sabu_t,sYearMonthDay,sYm00,sFromYm,sToYm)
	CASE 5,6										/*받을어음,지급어음*/
		iRowCount = dw_print.Retrieve(sabu_f,sabu_t,sYearMonthDay)
	CASE 8										/*계정전표*/
		iRowCount = dw_print.Retrieve(sabu_f,sabu_t,sFromAcc, sToAcc, sYearMonthDay,sDcrGbn,sFromYm)		
END CHOOSE

dw_print.sharedata(Idw_fs_print)

return 1
end function

on w_kgle39.create
int iCurrent
call super::create
this.tab_list=create tab_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_list
end on

on w_kgle39.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_list)
end on

event open;call super::open;
dw_ip.SetItem(1,"saupj",   gs_saupj)
dw_ip.SetItem(1,"k_symd",  f_today())

tab_list.tabpage_list.dw_fs_print.SetTransObject(SQLCA)
tab_list.tabpage_list2.dw_fs_print2.SetTransObject(SQLCA)
tab_list.tabpage_list3.dw_fs_print3.SetTransObject(SQLCA)
tab_list.tabpage_list4.dw_fs_print4.SetTransObject(SQLCA)
tab_list.tabpage_list5.dw_fs_print5.SetTransObject(SQLCA)
tab_list.tabpage_list6.dw_fs_print6.SetTransObject(SQLCA)
tab_list.tabpage_list7.dw_fs_print7.SetTransObject(SQLCA)
tab_list.tabpage_list8.dw_fs_print8.SetTransObject(SQLCA)

//tab_list.SelectedTab = 1

idw_fs_print = tab_list.tabpage_list.dw_fs_print
icur_tabpage = 1

dw_ip.Modify("sacc1_t.visible = 0")
dw_ip.Modify("sacc1.visible = 0")
dw_ip.Modify("saccname.visible = 0")
dw_ip.Modify("p_1.visible = 0")

dw_ip.Modify("dcgu_t.visible = 0")
dw_ip.Modify("dcgu.visible = 0")		

dw_ip.SetColumn("k_symd")
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_kgle39
end type

event p_preview::clicked;call super::clicked;//if is_preview = 'no' then
//	if Idw_fs_print.object.datawindow.print.preview = "yes" then
//		Idw_fs_print.object.datawindow.print.preview = "no"
//	else
//		Idw_fs_print.object.datawindow.print.preview = "yes"
//	end if	
//end if
end event

type p_exit from w_standard_print`p_exit within w_kgle39
end type

type p_print from w_standard_print`p_print within w_kgle39
end type

event p_print::clicked;if wf_print() = -1 then return
end event

type p_retrieve from w_standard_print`p_retrieve within w_kgle39
end type







type st_10 from w_standard_print`st_10 within w_kgle39
end type

type gb_10 from w_standard_print`gb_10 within w_kgle39
integer y = 2488
integer width = 3579
integer height = 152
integer textsize = -12
fontcharset fontcharset = defaultcharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_kgle39
string dataobject = "dw_kgle392_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgle39
integer x = 46
integer y = 28
integer width = 2510
integer height = 216
string dataobject = "dw_kgle391"
end type

event dw_ip::itemchanged; 
String sSaupj,sYearMonthDay,sAcc1,sAcc2,snull,sAccName

SetNull(snull)
		 
if this.GetColumnName() = 'saupj' then 
   sSaupj    = this.GetText()	
	if trim(sSaupj) = '' or isnull(sSaupj) then return 
	
	IF IsNull(F_Get_Refferance('AD',sSaupj)) THEN
   	F_MessageChk(20,'[사업장]')
      this.SetItem(row, "saupj", snull)
      return 1
   end if
end if

if this.GetColumnName() = 'k_symd' then
	sYearMonthDay = Trim(this.GetText())
	if isnull(sYearMonthDay) or sYearMonthDay = '' then return 
	
	if f_datechk(sYearMonthDay) = -1 then 
		F_MessageChk(21,'[결산기준일]')
		this.SetItem(row, "k_symd", snull)
		return 1
	end if	
end if

IF this.GetColumnName() = 'sacc2' then 	
	sAcc2 = trim(this.GetText())
	sAcc1 = trim(this.GetItemString(1,"sacc1"))
	
	IF sAcc1 = "" OR IsNull(sAcc1) THEN Return  
	IF sAcc2 = "" OR IsNull(sAcc2) THEN Return  
	
	SELECT "ACC2_NM"  		INTO :sAccName		
	FROM "KFZ01OM0"  		
	WHERE "ACC1_CD" = :sAcc1 AND "ACC2_CD" = :sAcc2 ;
	
	IF SQLCA.SQLCODE = 0 THEN
		this.SetItem(1, 'saccname', sAccName)
//	ELSE
//		this.SetItem(1,"sacc1",   snull)
//		this.SetItem(1,"saccname",snull)
//		Return 1
	END IF
END IF

end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::getfocus;this.AcceptText()
end event

event dw_ip::rbuttondown;this.accepttext()

IF this.GetColumnName() = "sacc1" THEN
	
	setnull(lstr_account.acc1_cd)
	setnull(lstr_account.acc2_cd)
	
	lstr_account.acc1_cd = this.object.sacc1[1]
	
	Open(W_KFZ01OM0_POPUP)
	
	this.SetItem(this.GetRow(), "sacc1", lstr_account.acc1_cd)
	this.SetItem(this.GetRow(), "sacc2", lstr_account.acc2_cd)
	this.SetItem(this.GetRow(), "saccname", lstr_account.acc2_nm)
	
	this.SetColumn("sacc1")
//	this.TriggerEvent(ItemChanged!)

END IF

end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) or keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kgle39
boolean visible = false
integer x = 2117
integer y = 3032
integer width = 681
integer height = 104
boolean hsplitscroll = false
end type

type tab_list from tab within w_kgle39
integer x = 64
integer y = 264
integer width = 4553
integer height = 2036
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_list tabpage_list
tabpage_list2 tabpage_list2
tabpage_list3 tabpage_list3
tabpage_list4 tabpage_list4
tabpage_list5 tabpage_list5
tabpage_list6 tabpage_list6
tabpage_list7 tabpage_list7
tabpage_list8 tabpage_list8
end type

on tab_list.create
this.tabpage_list=create tabpage_list
this.tabpage_list2=create tabpage_list2
this.tabpage_list3=create tabpage_list3
this.tabpage_list4=create tabpage_list4
this.tabpage_list5=create tabpage_list5
this.tabpage_list6=create tabpage_list6
this.tabpage_list7=create tabpage_list7
this.tabpage_list8=create tabpage_list8
this.Control[]={this.tabpage_list,&
this.tabpage_list2,&
this.tabpage_list3,&
this.tabpage_list4,&
this.tabpage_list5,&
this.tabpage_list6,&
this.tabpage_list7,&
this.tabpage_list8}
end on

on tab_list.destroy
destroy(this.tabpage_list)
destroy(this.tabpage_list2)
destroy(this.tabpage_list3)
destroy(this.tabpage_list4)
destroy(this.tabpage_list5)
destroy(this.tabpage_list6)
destroy(this.tabpage_list7)
destroy(this.tabpage_list8)
end on

event selectionchanged;
icur_tabpage = newindex

IF newindex = 1 THEN
	Idw_fs_print = tab_list.tabpage_list.dw_fs_print
   dw_print.dataObject = "dw_kgle392_p"
ELSEIF newindex = 2 THEN
	Idw_fs_print = tab_list.tabpage_list2.dw_fs_print2
   dw_print.dataObject = "dw_kgle393_p"
ELSEIF newindex = 3 THEN
	Idw_fs_print = tab_list.tabpage_list3.dw_fs_print3
   dw_print.dataObject = "dw_kgle396_p"
ELSEIF newindex = 4 THEN
	Idw_fs_print = tab_list.tabpage_list4.dw_fs_print4
   dw_print.dataObject = "dw_kgle397_p"
ELSEIF newindex = 5 THEN
	Idw_fs_print = tab_list.tabpage_list5.dw_fs_print5
   dw_print.dataObject = "dw_kgle394_p"
ELSEIF newindex = 6 THEN
	Idw_fs_print = tab_list.tabpage_list6.dw_fs_print6
   dw_print.dataObject = "dw_kgle395_p"
ELSEIF newindex = 7 THEN
	Idw_fs_print = tab_list.tabpage_list7.dw_fs_print7
   dw_print.dataObject = "dw_kgle398_p"
ELSEIF newindex = 8 THEN
	Idw_fs_print = tab_list.tabpage_list8.dw_fs_print8
   dw_print.dataObject = "dw_kgle399_p" 
END IF
  dw_print.SetTransObject(SQLCA)
  
IF newindex = 8 THEN
	dw_ip.Modify("sacc1_t.visible = 1")
	dw_ip.Modify("sacc1.visible = 1")
	dw_ip.Modify("saccname.visible = 1")
	dw_ip.Modify("p_1.visible = 1")
	
	dw_ip.Modify("dcgu_t.visible = 1")
	dw_ip.Modify("dcgu.visible = 1")
ELSE
	dw_ip.Modify("sacc1_t.visible = 0")
	dw_ip.Modify("sacc1.visible = 0")
	dw_ip.Modify("saccname.visible = 0")
	dw_ip.Modify("p_1.visible = 0")
	
	dw_ip.Modify("dcgu_t.visible = 0")
	dw_ip.Modify("dcgu.visible = 0")		
END IF

IF wf_retrieve() = -1 THEN
	p_print.Enabled = False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
ELSE
	p_print.Enabled = True
	p_print.PictureName = 'C:\erpman\image\인쇄_up.gif'

	p_preview.enabled = True
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
end event

type tabpage_list from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "현금예금"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 33554431
rr_2 rr_2
dw_fs_print dw_fs_print
end type

on tabpage_list.create
this.rr_2=create rr_2
this.dw_fs_print=create dw_fs_print
this.Control[]={this.rr_2,&
this.dw_fs_print}
end on

on tabpage_list.destroy
destroy(this.rr_2)
destroy(this.dw_fs_print)
end on

type rr_2 from roundrectangle within tabpage_list
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 20
integer width = 4471
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print from datawindow within tabpage_list
integer x = 32
integer y = 28
integer width = 4448
integer height = 1888
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kgle392"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list2 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "외상매출금"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_3 rr_3
dw_fs_print2 dw_fs_print2
end type

on tabpage_list2.create
this.rr_3=create rr_3
this.dw_fs_print2=create dw_fs_print2
this.Control[]={this.rr_3,&
this.dw_fs_print2}
end on

on tabpage_list2.destroy
destroy(this.rr_3)
destroy(this.dw_fs_print2)
end on

type rr_3 from roundrectangle within tabpage_list2
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 20
integer width = 4471
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print2 from datawindow within tabpage_list2
integer x = 32
integer y = 24
integer width = 4443
integer height = 1884
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_kgle393"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list3 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "외상매입금"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_4 rr_4
dw_fs_print3 dw_fs_print3
end type

on tabpage_list3.create
this.rr_4=create rr_4
this.dw_fs_print3=create dw_fs_print3
this.Control[]={this.rr_4,&
this.dw_fs_print3}
end on

on tabpage_list3.destroy
destroy(this.rr_4)
destroy(this.dw_fs_print3)
end on

type rr_4 from roundrectangle within tabpage_list3
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 20
integer width = 4471
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print3 from datawindow within tabpage_list3
integer x = 27
integer y = 28
integer width = 4453
integer height = 1884
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kgle396"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list4 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "외화외상매입금"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_5 rr_5
dw_fs_print4 dw_fs_print4
end type

on tabpage_list4.create
this.rr_5=create rr_5
this.dw_fs_print4=create dw_fs_print4
this.Control[]={this.rr_5,&
this.dw_fs_print4}
end on

on tabpage_list4.destroy
destroy(this.rr_5)
destroy(this.dw_fs_print4)
end on

type rr_5 from roundrectangle within tabpage_list4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 20
integer width = 4471
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print4 from datawindow within tabpage_list4
integer x = 27
integer y = 24
integer width = 4448
integer height = 1888
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_kgle397"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list5 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "받을어음"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_6 rr_6
dw_fs_print5 dw_fs_print5
end type

on tabpage_list5.create
this.rr_6=create rr_6
this.dw_fs_print5=create dw_fs_print5
this.Control[]={this.rr_6,&
this.dw_fs_print5}
end on

on tabpage_list5.destroy
destroy(this.rr_6)
destroy(this.dw_fs_print5)
end on

type rr_6 from roundrectangle within tabpage_list5
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 20
integer width = 4471
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print5 from datawindow within tabpage_list5
integer x = 27
integer y = 28
integer width = 4453
integer height = 1888
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kgle394"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list6 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "지급어음"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_7 rr_7
dw_fs_print6 dw_fs_print6
end type

on tabpage_list6.create
this.rr_7=create rr_7
this.dw_fs_print6=create dw_fs_print6
this.Control[]={this.rr_7,&
this.dw_fs_print6}
end on

on tabpage_list6.destroy
destroy(this.rr_7)
destroy(this.dw_fs_print6)
end on

type rr_7 from roundrectangle within tabpage_list6
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 24
integer width = 4471
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print6 from datawindow within tabpage_list6
integer x = 27
integer y = 32
integer width = 4453
integer height = 1888
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kgle395"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list7 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "미지급금"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_8 rr_8
dw_fs_print7 dw_fs_print7
end type

on tabpage_list7.create
this.rr_8=create rr_8
this.dw_fs_print7=create dw_fs_print7
this.Control[]={this.rr_8,&
this.dw_fs_print7}
end on

on tabpage_list7.destroy
destroy(this.rr_8)
destroy(this.dw_fs_print7)
end on

type rr_8 from roundrectangle within tabpage_list7
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 24
integer width = 4471
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print7 from datawindow within tabpage_list7
integer x = 27
integer y = 32
integer width = 4448
integer height = 1884
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_kgle398"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list8 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "계정전표"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_9 rr_9
dw_fs_print8 dw_fs_print8
end type

on tabpage_list8.create
this.rr_9=create rr_9
this.dw_fs_print8=create dw_fs_print8
this.Control[]={this.rr_9,&
this.dw_fs_print8}
end on

on tabpage_list8.destroy
destroy(this.rr_9)
destroy(this.dw_fs_print8)
end on

type rr_9 from roundrectangle within tabpage_list8
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 24
integer width = 4471
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print8 from datawindow within tabpage_list8
integer x = 23
integer y = 28
integer width = 4453
integer height = 1888
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_kgle399"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

