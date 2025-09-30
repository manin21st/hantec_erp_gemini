$PBExportHeader$w_kgle14.srw
$PBExportComments$결산부속명세서 조회 출력
forward
global type w_kgle14 from w_standard_print
end type
type tab_list from tab within w_kgle14
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
type tabpage_list9 from userobject within tab_list
end type
type rr_10 from roundrectangle within tabpage_list9
end type
type dw_fs_print9 from datawindow within tabpage_list9
end type
type tabpage_list9 from userobject within tab_list
rr_10 rr_10
dw_fs_print9 dw_fs_print9
end type
type tabpage_list10 from userobject within tab_list
end type
type rr_11 from roundrectangle within tabpage_list10
end type
type dw_fs_print10 from datawindow within tabpage_list10
end type
type tabpage_list10 from userobject within tab_list
rr_11 rr_11
dw_fs_print10 dw_fs_print10
end type
type tabpage_list11 from userobject within tab_list
end type
type rr_12 from roundrectangle within tabpage_list11
end type
type dw_fs_print11 from datawindow within tabpage_list11
end type
type tabpage_list11 from userobject within tab_list
rr_12 rr_12
dw_fs_print11 dw_fs_print11
end type
type tabpage_list12 from userobject within tab_list
end type
type rr_13 from roundrectangle within tabpage_list12
end type
type dw_fs_print12 from datawindow within tabpage_list12
end type
type tabpage_list12 from userobject within tab_list
rr_13 rr_13
dw_fs_print12 dw_fs_print12
end type
type tabpage_list13 from userobject within tab_list
end type
type rr_14 from roundrectangle within tabpage_list13
end type
type dw_fs_print13 from datawindow within tabpage_list13
end type
type tabpage_list13 from userobject within tab_list
rr_14 rr_14
dw_fs_print13 dw_fs_print13
end type
type tab_list from tab within w_kgle14
tabpage_list tabpage_list
tabpage_list2 tabpage_list2
tabpage_list3 tabpage_list3
tabpage_list4 tabpage_list4
tabpage_list5 tabpage_list5
tabpage_list7 tabpage_list7
tabpage_list8 tabpage_list8
tabpage_list9 tabpage_list9
tabpage_list10 tabpage_list10
tabpage_list11 tabpage_list11
tabpage_list12 tabpage_list12
tabpage_list13 tabpage_list13
end type
end forward

global type w_kgle14 from w_standard_print
integer x = 0
integer y = 0
string title = "결산부속명세서 조회 출력"
tab_list tab_list
end type
global w_kgle14 w_kgle14

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
String  sSaupj,sYearMonthDay,sDcrGbn,sAcc1,sAcc2,sFromAcc,sToAcc,sFromYm,sToYm,sYm00,ref_saup
Integer iRowCount
Long    Lyear,LjYear
Double  dRate

if dw_ip.AcceptText() = -1 then return -1
sSaupj        = dw_ip.GetItemString(1, 'saupj')
sYearMonthDay = trim(dw_ip.GetItemString(1, 'k_symd'))

IF sSaupj = '' OR IsNull(sSaupj) THEN
	sabu_f = '1';			sabu_t = '98';
ELSE
	sabu_f = sSaupj;		sabu_t = sSaupj;
END IF
IF sYearMonthDay = "" OR IsNull(sYearMonthDay) THEN
	F_MessageChk(1, "[결산기준일]")				
   dw_ip.SetColumn('k_symd')
	dw_ip.SetFocus()
	return -1
END IF

if f_accountyear (Left(sYearMonthDay,6) , sFromYm, sToYm, sYm00, Lyear, LjYear ) <> 1 then return -1 

CHOOSE CASE iCur_TabPage
	CASE 1,4,6,7								/*외상매출금,외상매입금,미지급금,미지급비용*/
		iRowCount = dw_print.Retrieve(sabu_f,sabu_t,sYearMonthDay,sYm00,sFromYm,sToYm)
	CASE 2,5										/*받을어음,지급어음*/
		iRowCount = dw_print.Retrieve(sabu_f,sabu_t,sYearMonthDay)
	CASE 3,8,9										/*선급금, 재고자산, 유형자산 총괄표*/		
		iRowCount = dw_print.Retrieve(sabu_f,sabu_t,sYearMonthDay,sYm00,sFromYm,sToYm)
		
		SELECT "REFFPF"."RFNA1"  
		 INTO :ref_saup  
		 FROM "REFFPF"  
		WHERE "REFFPF"."RFCOD" = 'AD'   AND
				"REFFPF"."RFGUB" = :ssaupj ;
				
		dw_print.object.saupj_t.text = ref_saup	
	CASE 10,11,12									/*감가상각누계액 명세서,국민연금 퇴직전환금 명세서,퇴직급여*/
		iRowCount = dw_print.Retrieve(sabu_f,sabu_t,sYearMonthDay)
		if iCur_TabPage = 10 then
			SELECT "REFFPF"."RFNA1"  
			 INTO :ref_saup  
			 FROM "REFFPF"  
			WHERE "REFFPF"."RFCOD" = 'AD'   AND
					"REFFPF"."RFGUB" = :ssaupj ;
			
			
			dw_print.object.saupj_t.text = ref_saup	
		end if
END CHOOSE

 dw_print.sharedata(Idw_fs_print)
return 1
end function

on w_kgle14.create
int iCurrent
call super::create
this.tab_list=create tab_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_list
end on

on w_kgle14.destroy
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
tab_list.tabpage_list7.dw_fs_print7.SetTransObject(SQLCA)
tab_list.tabpage_list8.dw_fs_print8.SetTransObject(SQLCA)
tab_list.tabpage_list9.dw_fs_print9.SetTransObject(SQLCA)
tab_list.tabpage_list10.dw_fs_print10.SetTransObject(SQLCA)
tab_list.tabpage_list11.dw_fs_print11.SetTransObject(SQLCA)
tab_list.tabpage_list12.dw_fs_print12.SetTransObject(SQLCA)
tab_list.tabpage_list13.dw_fs_print13.SetTransObject(SQLCA)

//tab_list.SelectedTab = 1

idw_fs_print = tab_list.tabpage_list.dw_fs_print
icur_tabpage = 1

dw_ip.SetColumn("k_symd")
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_kgle14
end type

event p_preview::clicked;call super::clicked;//if is_preview = 'no' then
//	if Idw_fs_print.object.datawindow.print.preview = "yes" then
//		Idw_fs_print.object.datawindow.print.preview = "no"
//	else
//		Idw_fs_print.object.datawindow.print.preview = "yes"
//	end if	
//end if
end event

type p_exit from w_standard_print`p_exit within w_kgle14
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_kgle14
integer taborder = 50
end type

event p_print::clicked;if wf_print() = -1 then return
end event

type p_retrieve from w_standard_print`p_retrieve within w_kgle14
end type







type st_10 from w_standard_print`st_10 within w_kgle14
end type

type gb_10 from w_standard_print`gb_10 within w_kgle14
integer y = 2488
integer width = 3579
integer height = 152
integer textsize = -12
fontcharset fontcharset = defaultcharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_kgle14
integer x = 4096
integer y = 184
string dataobject = "dw_kgle392_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kgle14
integer x = 50
integer width = 2007
integer height = 156
string dataobject = "dw_kgle141"
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


end event

event dw_ip::itemerror;call super::itemerror;Return 1
end event

event dw_ip::getfocus;this.AcceptText()
end event

type dw_list from w_standard_print`dw_list within w_kgle14
boolean visible = false
integer x = 2117
integer y = 3032
integer width = 681
integer height = 104
boolean hsplitscroll = false
end type

type tab_list from tab within w_kgle14
integer x = 59
integer y = 168
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
tabpage_list7 tabpage_list7
tabpage_list8 tabpage_list8
tabpage_list9 tabpage_list9
tabpage_list10 tabpage_list10
tabpage_list11 tabpage_list11
tabpage_list12 tabpage_list12
tabpage_list13 tabpage_list13
end type

on tab_list.create
this.tabpage_list=create tabpage_list
this.tabpage_list2=create tabpage_list2
this.tabpage_list3=create tabpage_list3
this.tabpage_list4=create tabpage_list4
this.tabpage_list5=create tabpage_list5
this.tabpage_list7=create tabpage_list7
this.tabpage_list8=create tabpage_list8
this.tabpage_list9=create tabpage_list9
this.tabpage_list10=create tabpage_list10
this.tabpage_list11=create tabpage_list11
this.tabpage_list12=create tabpage_list12
this.tabpage_list13=create tabpage_list13
this.Control[]={this.tabpage_list,&
this.tabpage_list2,&
this.tabpage_list3,&
this.tabpage_list4,&
this.tabpage_list5,&
this.tabpage_list7,&
this.tabpage_list8,&
this.tabpage_list9,&
this.tabpage_list10,&
this.tabpage_list11,&
this.tabpage_list12,&
this.tabpage_list13}
end on

on tab_list.destroy
destroy(this.tabpage_list)
destroy(this.tabpage_list2)
destroy(this.tabpage_list3)
destroy(this.tabpage_list4)
destroy(this.tabpage_list5)
destroy(this.tabpage_list7)
destroy(this.tabpage_list8)
destroy(this.tabpage_list9)
destroy(this.tabpage_list10)
destroy(this.tabpage_list11)
destroy(this.tabpage_list12)
destroy(this.tabpage_list13)
end on

event selectionchanged;
icur_tabpage = newindex

IF newindex = 1 THEN
	Idw_fs_print = tab_list.tabpage_list.dw_fs_print
   dw_print.dataObject = "dw_kgle142_p"
ELSEIF newindex = 2 THEN
	Idw_fs_print = tab_list.tabpage_list2.dw_fs_print2
   dw_print.dataObject = "dw_kgle143_p"
ELSEIF newindex = 3 THEN
	Idw_fs_print = tab_list.tabpage_list3.dw_fs_print3
   dw_print.dataObject = "dw_kgle144_p"
ELSEIF newindex = 4 THEN
	Idw_fs_print = tab_list.tabpage_list4.dw_fs_print4
   dw_print.dataObject = "dw_kgle145_p"
ELSEIF newindex = 5 THEN
	Idw_fs_print = tab_list.tabpage_list5.dw_fs_print5
   dw_print.dataObject = "dw_kgle146_p"
ELSEIF newindex = 6 THEN
	Idw_fs_print = tab_list.tabpage_list7.dw_fs_print7
   dw_print.dataObject = "dw_kgle148_p"
ELSEIF newindex = 7 THEN
	Idw_fs_print = tab_list.tabpage_list8.dw_fs_print8
   dw_print.dataObject = "dw_kgle149_p" 
ELSEIF newindex = 8 THEN
	Idw_fs_print = tab_list.tabpage_list9.dw_fs_print9
   dw_print.dataObject = "dw_kgle147_p" 
ELSEIF newindex = 9 THEN
	Idw_fs_print = tab_list.tabpage_list10.dw_fs_print10
   dw_print.dataObject = "dw_kgle14a_p" 
ELSEIF newindex = 10 THEN
	Idw_fs_print = tab_list.tabpage_list11.dw_fs_print11
   dw_print.dataObject = "dw_kgle14b_p" 
ELSEIF newindex = 11 THEN
	Idw_fs_print = tab_list.tabpage_list12.dw_fs_print12
   dw_print.dataObject = "dw_kgle14c_p" 
ELSEIF newindex = 12 THEN
	Idw_fs_print = tab_list.tabpage_list13.dw_fs_print13
   dw_print.dataObject = "dw_kgle14d_p" 
END IF

dw_print.SetTransObject(SQLCA)
Idw_fs_print.Reset()

//wf_retrieve()
end event

type tabpage_list from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "외상매출금"
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
string dataobject = "dw_kgle142"
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
string text = "받을어음"
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
string dataobject = "dw_kgle143"
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
string text = "선급금"
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
string dataobject = "dw_kgle144"
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
string text = "외상매입금"
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
string dataobject = "dw_kgle145"
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
string text = "지급어음"
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
string dataobject = "dw_kgle146"
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
string dataobject = "dw_kgle148"
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
string text = "미지급비용"
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
integer x = 9
integer y = 20
integer width = 4485
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
string dataobject = "dw_kgle149"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list9 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "재고자산"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_10 rr_10
dw_fs_print9 dw_fs_print9
end type

on tabpage_list9.create
this.rr_10=create rr_10
this.dw_fs_print9=create dw_fs_print9
this.Control[]={this.rr_10,&
this.dw_fs_print9}
end on

on tabpage_list9.destroy
destroy(this.rr_10)
destroy(this.dw_fs_print9)
end on

type rr_10 from roundrectangle within tabpage_list9
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 20
integer width = 4485
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print9 from datawindow within tabpage_list9
integer x = 18
integer y = 32
integer width = 4462
integer height = 1876
integer taborder = 40
string dataobject = "dw_kgle147"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list10 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "유형자산"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_11 rr_11
dw_fs_print10 dw_fs_print10
end type

on tabpage_list10.create
this.rr_11=create rr_11
this.dw_fs_print10=create dw_fs_print10
this.Control[]={this.rr_11,&
this.dw_fs_print10}
end on

on tabpage_list10.destroy
destroy(this.rr_11)
destroy(this.dw_fs_print10)
end on

type rr_11 from roundrectangle within tabpage_list10
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 20
integer width = 4517
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print10 from datawindow within tabpage_list10
integer x = 9
integer y = 32
integer width = 4494
integer height = 1876
integer taborder = 40
string dataobject = "dw_kgle14a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list11 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "감가상각누계액명세서"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_12 rr_12
dw_fs_print11 dw_fs_print11
end type

on tabpage_list11.create
this.rr_12=create rr_12
this.dw_fs_print11=create dw_fs_print11
this.Control[]={this.rr_12,&
this.dw_fs_print11}
end on

on tabpage_list11.destroy
destroy(this.rr_12)
destroy(this.dw_fs_print11)
end on

type rr_12 from roundrectangle within tabpage_list11
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 20
integer width = 4517
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print11 from datawindow within tabpage_list11
integer x = 23
integer y = 28
integer width = 4471
integer height = 1880
integer taborder = 40
string dataobject = "dw_kgle14b"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list12 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "국민연금 퇴직전환금 명세서"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_13 rr_13
dw_fs_print12 dw_fs_print12
end type

on tabpage_list12.create
this.rr_13=create rr_13
this.dw_fs_print12=create dw_fs_print12
this.Control[]={this.rr_13,&
this.dw_fs_print12}
end on

on tabpage_list12.destroy
destroy(this.rr_13)
destroy(this.dw_fs_print12)
end on

type rr_13 from roundrectangle within tabpage_list12
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 20
integer width = 4517
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print12 from datawindow within tabpage_list12
integer x = 9
integer y = 28
integer width = 4489
integer height = 1876
integer taborder = 40
string dataobject = "dw_kgle14c"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type tabpage_list13 from userobject within tab_list
integer x = 18
integer y = 96
integer width = 4517
integer height = 1924
long backcolor = 32106727
string text = "퇴직급여 충당금 명세서"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
rr_14 rr_14
dw_fs_print13 dw_fs_print13
end type

on tabpage_list13.create
this.rr_14=create rr_14
this.dw_fs_print13=create dw_fs_print13
this.Control[]={this.rr_14,&
this.dw_fs_print13}
end on

on tabpage_list13.destroy
destroy(this.rr_14)
destroy(this.dw_fs_print13)
end on

type rr_14 from roundrectangle within tabpage_list13
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer y = 20
integer width = 4517
integer height = 1900
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_fs_print13 from datawindow within tabpage_list13
integer x = 18
integer y = 28
integer width = 4485
integer height = 1880
integer taborder = 40
string dataobject = "dw_kgle14d"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

