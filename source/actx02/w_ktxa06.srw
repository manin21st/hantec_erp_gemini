$PBExportHeader$w_ktxa06.srw
$PBExportComments$매출세금계산서 출력
forward
global type w_ktxa06 from w_standard_print
end type
type rb_2 from radiobutton within w_ktxa06
end type
type st_5 from statictext within w_ktxa06
end type
type rb_1 from radiobutton within w_ktxa06
end type
type tab_vat from tab within w_ktxa06
end type
type tabpage_lst from userobject within tab_vat
end type
type dw_lst from u_d_popup_sort within tabpage_lst
end type
type tabpage_lst from userobject within tab_vat
dw_lst dw_lst
end type
type tabpage_print from userobject within tab_vat
end type
type dw_main_print from datawindow within tabpage_print
end type
type tabpage_print from userobject within tab_vat
dw_main_print dw_main_print
end type
type tab_vat from tab within w_ktxa06
tabpage_lst tabpage_lst
tabpage_print tabpage_print
end type
type st_1 from statictext within w_ktxa06
end type
type rr_1 from roundrectangle within w_ktxa06
end type
end forward

global type w_ktxa06 from w_standard_print
integer x = 0
integer y = 0
integer height = 2396
string title = "매출 세금 계산서 출력"
rb_2 rb_2
st_5 st_5
rb_1 rb_1
tab_vat tab_vat
st_1 st_1
rr_1 rr_1
end type
global w_ktxa06 w_ktxa06

type variables
string sjasacod
end variables

forward prototypes
public function integer wf_retrieve ()
public function integer wf_print (integer irow)
public subroutine wf_print_multy ()
end prototypes

public function integer wf_retrieve ();string sDatefrom, sDateto 
LONG   snofrom, sNoto 

tab_vat.tabpage_lst.dw_lst.reset()

sjasacod = dw_ip.GetItemstring(dw_ip.getrow(),"jasacod")
if isnull(sjasacod) or sjasacod = '' then 
	sjasacod = '%'
end if	
sDatefrom = Trim(dw_ip.GetItemString(dw_ip.getrow(),"k_symd"))
sDateto   = Trim(dw_ip.GetItemString(dw_ip.getrow(),"k_eymd"))

if sDatefrom > sDateto then
	f_messagechk(26,"세금계산서일자")
	dw_ip.setfocus()
	dw_ip.setcolumn("k_symd")
	Return -1
end if	

sNofrom = dw_ip.GetItemnumber(dw_ip.getrow(),"JASAF")
snoto = dw_ip.GetItemnumber(dw_ip.getrow(),"JASAT")

if isnull(snofrom) or snofrom = 0 then snofrom = 1
if isnull(snoto) or snoto = 0 then snoto = 9999

if snofrom > snoto then
	f_messagechk(26,"세금계산서번호의")
	dw_ip.SetFocus()
	dw_ip.setcolumn("jasaf")
	Return -1
end if	

if dw_print.retrieve(sabu_f, sabu_t, sjasacod, sDatefrom, sDateto, snofrom, snoto) < 1 then
	f_messagechk(14,"") 
	dw_ip.SetFocus()
	Return -1
end if	
dw_print.sharedata(tab_vat.tabpage_lst.dw_lst)
return 1

end function

public function integer wf_print (integer irow);
Long    lJunNo,lSeqNo,lLinNo,iRowCount
String  sSaupj,sBalDate,sUpmuGbn,sGeyDate

sSaupj   = tab_vat.tabpage_lst.dw_lst.GetItemString(irow, "kfz17ot0_saupj")
sBalDate = tab_vat.tabpage_lst.dw_lst.GetItemString(irow, "kfz17ot0_bal_date")
sUpmuGbn = tab_vat.tabpage_lst.dw_lst.GetItemString(irow, "kfz17ot0_upmu_gu")
lJunNo   = tab_vat.tabpage_lst.dw_lst.GetItemNumber(irow, "kfz17ot0_bjun_no")
lLinNo   = tab_vat.tabpage_lst.dw_lst.GetItemNumber(irow, "kfz17ot0_lin_no")
		
sGeyDate = tab_vat.tabpage_lst.dw_lst.GetItemString(irow, "kfz17ot0_gey_date")
lSeqNo   = tab_vat.tabpage_lst.dw_lst.GetItemNumber(irow, "kfz17ot0_seq_no")
		
iRowCount = tab_vat.tabpage_print.dw_main_print.Retrieve(sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo,sGeyDate,lSeqNo) 

Return iRowCount
end function

public subroutine wf_print_multy ();Integer i
Long    lJunNo,lSeqNo,lLinNo,iRowCount
String  sSaupj,sBalDate,sUpmuGbn,sGeyDate,sChk

tab_vat.tabpage_lst.dw_lst.Accepttext()

For i = 1 To tab_vat.tabpage_lst.dw_lst.rowcount()
	
	sChk = tab_vat.tabpage_lst.dw_lst.GetItemString(i, "checking")
	
	IF sChk = "Y" THEN
		
		sSaupj   = tab_vat.tabpage_lst.dw_lst.GetItemString(i, "kfz17ot0_saupj")
		sBalDate = tab_vat.tabpage_lst.dw_lst.GetItemString(i, "kfz17ot0_bal_date")
		sUpmuGbn = tab_vat.tabpage_lst.dw_lst.GetItemString(i, "kfz17ot0_upmu_gu")
		lJunNo   = tab_vat.tabpage_lst.dw_lst.GetItemNumber(i, "kfz17ot0_bjun_no")
		lLinNo   = tab_vat.tabpage_lst.dw_lst.GetItemNumber(i, "kfz17ot0_lin_no")

		sGeyDate = tab_vat.tabpage_lst.dw_lst.GetItemString(i, "kfz17ot0_gey_date")
		lSeqNo   = tab_vat.tabpage_lst.dw_lst.GetItemNumber(i, "kfz17ot0_seq_no")
				
		tab_vat.tabpage_print.dw_main_print.Retrieve(sSaupj,sBalDate,sUpmuGbn,lJunNo,lLinNo,sGeyDate,lSeqNo)
		
		tab_vat.tabpage_print.dw_main_print.Print()
		
	END IF
	
Next
end subroutine

on w_ktxa06.create
int iCurrent
call super::create
this.rb_2=create rb_2
this.st_5=create st_5
this.rb_1=create rb_1
this.tab_vat=create tab_vat
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.tab_vat
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.rr_1
end on

on w_ktxa06.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.st_5)
destroy(this.rb_1)
destroy(this.tab_vat)
destroy(this.st_1)
destroy(this.rr_1)
end on

event open;call super::open;tab_vat.tabpage_lst.dw_lst.settransobject(sqlca)
tab_vat.tabpage_print.dw_main_print.settransobject(sqlca)

dw_ip.Setitem(1,"k_symd", left(f_today(), 6) + "01")
dw_ip.Setitem(1,"k_eymd", f_today())

dw_ip.SetItem(1,"saupj",gs_saupj)
dw_ip.SetFocus()

dw_ip.Modify("saupj.protect = 0")
dw_ip.Modify("saupj.background.color ='"+String(RGB(255,255,255))+"'")


rb_2.Checked = True
rb_2.TriggerEvent(Clicked!)


end event

type p_preview from w_standard_print`p_preview within w_ktxa06
string pointer = ""
end type

event p_preview::clicked;OpenWithParm(w_print_preview, tab_vat.tabpage_print.dw_main_print)
end event

type p_exit from w_standard_print`p_exit within w_ktxa06
integer taborder = 70
string pointer = ""
end type

type p_print from w_standard_print`p_print within w_ktxa06
string pointer = ""
end type

event p_print::clicked;IF tab_vat.SelectedTab = 1 THEN
	Wf_Print_Multy()
ELSE
	IF tab_vat.tabpage_print.dw_main_print.rowcount() > 0 then 
		gi_page = tab_vat.tabpage_print.dw_main_print.GetItemNumber(1,"last_page")
	ELSE
		gi_page = 1
	END IF
	OpenWithParm(w_print_options, tab_vat.tabpage_print.dw_main_print)
END IF
end event

type p_retrieve from w_standard_print`p_retrieve within w_ktxa06
string pointer = ""
end type

type st_window from w_standard_print`st_window within w_ktxa06
integer x = 2427
integer width = 462
end type

type sle_msg from w_standard_print`sle_msg within w_ktxa06
integer width = 2034
end type

type dw_datetime from w_standard_print`dw_datetime within w_ktxa06
integer x = 2885
end type

type st_10 from w_standard_print`st_10 within w_ktxa06
end type

type gb_10 from w_standard_print`gb_10 within w_ktxa06
integer width = 3630
end type

type dw_print from w_standard_print`dw_print within w_ktxa06
string dataobject = "dw_ktxa062_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxa06
integer y = 36
integer width = 2583
integer height = 212
string dataobject = "dw_ktxa061"
end type

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_ktxa06
boolean visible = false
integer x = 1367
integer y = 2468
integer width = 695
integer height = 104
string title = "매출 세금계산서 출력"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type rb_2 from radiobutton within w_ktxa06
integer x = 2697
integer y = 168
integer width = 402
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "개별선택"
end type

event clicked;long		lrow, lrowcount
string	sPrintGubun

lrowcount = tab_vat.tabpage_lst.dw_lst.rowcount()

IF THIS.CHECKED = TRUE	THEN
	sPrintGubun = 'N'
END IF

for lrow = 1	to	lrowcount

	tab_vat.tabpage_lst.dw_lst.Setitem(lrow, "checking", sPrintGubun)
	
next
end event

type st_5 from statictext within w_ktxa06
integer x = 2661
integer y = 56
integer width = 434
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "작업선택"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_ktxa06
integer x = 2697
integer y = 108
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "전체선택"
end type

event clicked;long		lrow, lrowcount
string	sPrintGubun

lrowcount = tab_vat.tabpage_lst.dw_lst.rowcount()

IF THIS.CHECKED = TRUE	THEN
	sPrintGubun = 'Y'
END IF

for lrow = 1	to	lrowcount

	tab_vat.tabpage_lst.dw_lst.Setitem(lrow, "checking", sPrintGubun)
	
next
end event

type tab_vat from tab within w_ktxa06
integer x = 55
integer y = 272
integer width = 4553
integer height = 2008
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
tabpage_lst tabpage_lst
tabpage_print tabpage_print
end type

on tab_vat.create
this.tabpage_lst=create tabpage_lst
this.tabpage_print=create tabpage_print
this.Control[]={this.tabpage_lst,&
this.tabpage_print}
end on

on tab_vat.destroy
destroy(this.tabpage_lst)
destroy(this.tabpage_print)
end on

event selectionchanging;
IF newindex = 2 THEN
	IF tab_vat.tabpage_lst.dw_lst.GetSelectedRow(0) <=0 THEN Return 1
	
	IF Wf_Print(tab_vat.tabpage_lst.dw_lst.GetSelectedRow(0)) <= 0 THEN Return 1
END IF
end event

type tabpage_lst from userobject within tab_vat
integer x = 18
integer y = 96
integer width = 4517
integer height = 1896
long backcolor = 32106727
string text = "발행내역"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_lst dw_lst
end type

on tabpage_lst.create
this.dw_lst=create dw_lst
this.Control[]={this.dw_lst}
end on

on tabpage_lst.destroy
destroy(this.dw_lst)
end on

type dw_lst from u_d_popup_sort within tabpage_lst
integer y = 12
integer width = 4512
integer height = 1884
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_ktxa062"
boolean vscrollbar = true
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
	
	this.SelectRow(0,False)
	this.SelectRow(row,True)
END IF

CALL SUPER ::CLICKED
end event

event rbuttondown;IF Row <=0 THEN Return

SelectRow(Row,False)
end event

type tabpage_print from userobject within tab_vat
integer x = 18
integer y = 96
integer width = 4517
integer height = 1896
long backcolor = 32106727
string text = "세금계산서 미리보기"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
long picturemaskcolor = 536870912
dw_main_print dw_main_print
end type

on tabpage_print.create
this.dw_main_print=create dw_main_print
this.Control[]={this.dw_main_print}
end on

on tabpage_print.destroy
destroy(this.dw_main_print)
end on

type dw_main_print from datawindow within tabpage_print
integer y = 8
integer width = 4512
integer height = 1888
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_ktxa063_1"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ktxa06
integer x = 1033
integer y = 300
integer width = 1138
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "*미리보기는 반전된 자료만 볼 수 있습니다."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_ktxa06
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2629
integer y = 36
integer width = 489
integer height = 208
integer cornerheight = 40
integer cornerwidth = 55
end type

