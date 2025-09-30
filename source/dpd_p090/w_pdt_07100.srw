$PBExportHeader$w_pdt_07100.srw
$PBExportComments$Lot SimulationMain화면
forward
global type w_pdt_07100 from w_inherite
end type
type tab_1 from tab within w_pdt_07100
end type
type tabpage_1 from userobject within tab_1
end type
type p_13 from uo_picture within tabpage_1
end type
type rr_9 from roundrectangle within tabpage_1
end type
type p_6 from uo_picture within tabpage_1
end type
type p_4 from uo_picture within tabpage_1
end type
type p_3 from uo_picture within tabpage_1
end type
type p_12 from uo_picture within tabpage_1
end type
type p_7 from uo_picture within tabpage_1
end type
type p_8 from uo_picture within tabpage_1
end type
type p_1 from uo_picture within tabpage_1
end type
type p_2 from uo_picture within tabpage_1
end type
type p_5 from uo_picture within tabpage_1
end type
type gb_6 from groupbox within tabpage_1
end type
type gb_5 from groupbox within tabpage_1
end type
type gb_1 from groupbox within tabpage_1
end type
type dw_tab1_1 from datawindow within tabpage_1
end type
type dw_tab1_2 from datawindow within tabpage_1
end type
type dw_tab1_3 from datawindow within tabpage_1
end type
type rr_7 from roundrectangle within tabpage_1
end type
type rr_8 from roundrectangle within tabpage_1
end type
type tabpage_1 from userobject within tab_1
p_13 p_13
rr_9 rr_9
p_6 p_6
p_4 p_4
p_3 p_3
p_12 p_12
p_7 p_7
p_8 p_8
p_1 p_1
p_2 p_2
p_5 p_5
gb_6 gb_6
gb_5 gb_5
gb_1 gb_1
dw_tab1_1 dw_tab1_1
dw_tab1_2 dw_tab1_2
dw_tab1_3 dw_tab1_3
rr_7 rr_7
rr_8 rr_8
end type
type tabpage_2 from userobject within tab_1
end type
type rr_6 from roundrectangle within tabpage_2
end type
type p_estima from uo_picture within tabpage_2
end type
type gb_12 from groupbox within tabpage_2
end type
type gb_11 from groupbox within tabpage_2
end type
type dw_tab2_1 from datawindow within tabpage_2
end type
type dw_tab2_2 from datawindow within tabpage_2
end type
type dw_tab2_3 from datawindow within tabpage_2
end type
type gb_2 from groupbox within tabpage_2
end type
type rr_4 from roundrectangle within tabpage_2
end type
type rr_5 from roundrectangle within tabpage_2
end type
type tabpage_2 from userobject within tab_1
rr_6 rr_6
p_estima p_estima
gb_12 gb_12
gb_11 gb_11
dw_tab2_1 dw_tab2_1
dw_tab2_2 dw_tab2_2
dw_tab2_3 dw_tab2_3
gb_2 gb_2
rr_4 rr_4
rr_5 rr_5
end type
type tabpage_3 from userobject within tab_1
end type
type p_9 from uo_picture within tabpage_3
end type
type p_11 from uo_picture within tabpage_3
end type
type p_10 from uo_picture within tabpage_3
end type
type rr_1 from roundrectangle within tabpage_3
end type
type dw_tab3_2 from datawindow within tabpage_3
end type
type sle_1 from singlelineedit within tabpage_3
end type
type st_2 from statictext within tabpage_3
end type
type dw_tab3_1 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
p_9 p_9
p_11 p_11
p_10 p_10
rr_1 rr_1
dw_tab3_2 dw_tab3_2
sle_1 sle_1
st_2 st_2
dw_tab3_1 dw_tab3_1
end type
type tab_1 from tab within w_pdt_07100
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type dw_gijun from datawindow within w_pdt_07100
end type
type dw_print from datawindow within w_pdt_07100
end type
type dw_1 from datawindow within w_pdt_07100
end type
end forward

global type w_pdt_07100 from w_inherite
integer height = 2484
string title = "Lot SimulaTion"
tab_1 tab_1
dw_gijun dw_gijun
dw_print dw_print
dw_1 dw_1
end type
global w_pdt_07100 w_pdt_07100

type variables

end variables

forward prototypes
public function integer wf_jego (ref string arg_itnbr, ref decimal arg_jego, ref decimal arg_hold, ref decimal arg_valid, ref decimal arg_forec, ref string arg_rtnbr, integer arg_gubun)
public subroutine wf_tab2_retrieve (long lrow)
public subroutine wf_tab1_retrieve (long lrow)
public function integer wf_insert_sujuitem (integer arg_cnt)
end prototypes

public function integer wf_jego (ref string arg_itnbr, ref decimal arg_jego, ref decimal arg_hold, ref decimal arg_valid, ref decimal arg_forec, ref string arg_rtnbr, integer arg_gubun);Decimal {3} dJego, dHold, dValid, dForec

dJego 	= 0
dHold 	= 0
dValid	= 0
dForec	= 0

select sum(nvl(a.jego_qty, 0)),	 
		 sum(nvl(a.hold_qty, 0)),
		 sum(nvl(a.valid_qty, 0)),
		 sum((nvl(a.jego_qty, 	0) + nvl(a.prod_qty,	  0)  + nvl(a.jisi_qty, 0) + 
		 	  	nvl(a.balju_qty, 	0) + nvl(a.pob_qc_qty, 0)  + nvl(a.ins_qty,  0) + 
		 	  	nvl(a.gi_qc_qty, 	0) + nvl(a.gita_in_qty,0)) -
		 	  (nvl(a.hold_qty, 	0) + nvl(a.order_qty,  0)  + nvl(a.mfgcnf_qty, 0)))
  INTO :dJego, :dHold, :dValid, :dForec
  from stock a
 where a.itnbr = :arg_itnbr;
 
 if isnull(dJego) 	then dJego = 0
 if isnull(dHold) 	then dHold = 0
 if isnull(dValid)	then dValid = 0
 if isnull(dForec)	then dForec = 0
 
 arg_jego 	= dJego
 arg_hold 	= dHold
 arg_valid	= dValid
 arg_forec	= dForec

 
 if arg_gubun = 2 then return 1
 
 String	sDitnbr, sReff, sReff1

/* BOM이 있는 지 확인
	1. 지시품번에 하위부품이 있는지
	2. 표준품번에 하위부품이 있는지	*/
Long lcnt, Lcnt1
string srtnbr
Lcnt = 0
Select count(*) Into :lcnt from pstruc
 Where pinbr = :arg_itnbr;
 
if Isnull(Lcnt) or Lcnt < 1 then
	Select stdnbr Into :sDitnbr From itemas
	 Where itnbr = :arg_Itnbr;

	/* 대표품번에 대한 BOM 검색 */
	Lcnt = 0
	Select count(*) Into :lcnt from pstruc
	 Where pinbr = :sDitnbr;
	 
	if Isnull(Lcnt) or Lcnt < 1 then		 
		Messagebox("BOM확인", "BOM이 없읍니다")
		return -1
	End if
	sRtnbr = sDitnbr
Else
	sRtnbr = arg_itnbr
end if;

arg_rtnbr = srtnbr

return 1

end function

public subroutine wf_tab2_retrieve (long lrow);if Lrow < 1 then return

String sitnbr, sitdsc
Decimal {3} dJego

sitnbr = tab_1.tabpage_2.dw_tab2_1.getitemstring(Lrow, "itnbr")
sitdsc = tab_1.tabpage_2.dw_tab2_1.getitemstring(Lrow, "itdsc")


if tab_1.tabpage_2.dw_tab2_2.retrieve(sitnbr) > 0 then
	dJego = tab_1.tabpage_2.dw_tab2_2.getitemdecimal(1, "compute_0003")
Else
	dJego = 0
End if
tab_1.tabpage_2.dw_tab2_3.retrieve(gs_sabu, sitnbr, dJego)	

tab_1.tabpage_2.gb_12.text = '창고별 재고내역 [ ' + trim(sitdsc) + ' ]'
tab_1.tabpage_2.gb_2.text = '입출고 예정현황 [ ' + trim(sitdsc) + ' ]'	
end subroutine

public subroutine wf_tab1_retrieve (long lrow);if Lrow < 1 then return

String sitnbr, sitdsc
Decimal {3} dJego

sitnbr = tab_1.tabpage_1.dw_tab1_1.getitemstring(Lrow, "itnbr")
sitdsc = tab_1.tabpage_1.dw_tab1_1.getitemstring(Lrow, "itdsc")

if tab_1.tabpage_1.dw_tab1_2.retrieve(sitnbr) > 0 then
	dJego = tab_1.tabpage_1.dw_tab1_2.getitemdecimal(1, "compute_0003")
Else
	dJego = 0
End if
tab_1.tabpage_1.dw_tab1_3.retrieve(gs_sabu, sitnbr, dJego)	
tab_1.tabpage_1.gb_5.text = '창고별 재고내역 [ ' + trim(sitdsc) + ' ]'
tab_1.tabpage_1.gb_6.text = '입출고 예정현황 [ ' + trim(sitdsc) + ' ]'	
end subroutine

public function integer wf_insert_sujuitem (integer arg_cnt);	String 	sItnbr, sitdsc, sispec, sjijil, sispec_code, sNull, sRtnbr
   Integer 	ireturn
   Long    	Lrow, Lfind, Lqty, Ll
   Decimal {3} dJego, dHold, dValid, dForec
   int i

	for i = 1 to arg_cnt

		Setnull(sNull)
		sItnbr = dw_1.GetItemString(i, 'itnbr')
		Lqty   = dw_1.GetItemDecimal(i, 'order_qty')
		//ireturn = f_get_name4('품번', 'Y', sItnbr, sitdsc, sispec, sjijil, sispec_code) 

	   Select itdsc, ispec, jijil, ispec_code
		  into :sitdsc, :sispec, :sjijil, :sispec_code
		  from itemas
		 where itnbr = :sItnbr;
		 
		lFind = 0
		lFind = tab_1.tabpage_1.dw_tab1_1.Find("itnbr = '"+sItnbr+"' ", 1, tab_1.tabpage_1.dw_tab1_1.RowCount())
	
		if lfind = 0 then
			ll = tab_1.tabpage_1.dw_tab1_1.Insertrow(0)
			tab_1.tabpage_1.dw_tab1_1.setitem(ll, "itnbr", sitnbr)
			tab_1.tabpage_1.dw_tab1_1.setitem(ll, "lotqty", lqty)
			tab_1.tabpage_1.dw_tab1_1.setitem(ll, "itdsc", sitdsc)	
			tab_1.tabpage_1.dw_tab1_1.setitem(ll, "ispec", sispec)
			tab_1.tabpage_1.dw_tab1_1.setitem(ll, "jijil", sjijil)	
			tab_1.tabpage_1.dw_tab1_1.setitem(ll, "ispec_code", sispec_code)
			
			wf_tab1_retrieve(ll)
				
			wf_jego(sItnbr, dJego, dHold, dValid, dForec, srtnbr, 1)	
			
			tab_1.tabpage_1.dw_tab1_1.setitem(ll, "jego_qty", dJego)
			tab_1.tabpage_1.dw_tab1_1.setitem(ll, "hold_qty", dHold)
			tab_1.tabpage_1.dw_tab1_1.setitem(ll, "valid_qty", dValid)
			tab_1.tabpage_1.dw_tab1_1.setitem(ll, "forca_qty", dForec)
			tab_1.tabpage_1.dw_tab1_1.setitem(ll, "stditnbr", srtnbr)	
		else
			tab_1.tabpage_1.dw_tab1_1.setitem(lfind, "lotqty", tab_1.tabpage_1.dw_tab1_1.getitemdecimal(lfind, "lotqty") + lqty)
		End if
			
	next
	
return 1
end function

on w_pdt_07100.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_gijun=create dw_gijun
this.dw_print=create dw_print
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_gijun
this.Control[iCurrent+3]=this.dw_print
this.Control[iCurrent+4]=this.dw_1
end on

on w_pdt_07100.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_gijun)
destroy(this.dw_print)
destroy(this.dw_1)
end on

event open;call super::open;// 기준년월 
dw_1.SetTransObject(sqlca)

dw_gijun.settransobject(sqlca)
dw_gijun.insertrow(0)
dw_gijun.setitem(1, "yymm", left(f_today(), 6))

tab_1.tabpage_1.dw_tab1_1.settransobject(sqlca)
tab_1.tabpage_1.dw_tab1_2.settransobject(sqlca)
tab_1.tabpage_1.dw_tab1_3.settransobject(sqlca)

tab_1.tabpage_2.dw_tab2_1.settransobject(sqlca)
tab_1.tabpage_2.dw_tab2_2.settransobject(sqlca)
tab_1.tabpage_2.dw_tab2_3.settransobject(sqlca)

tab_1.tabpage_3.dw_tab3_1.settransobject(sqlca)
tab_1.tabpage_3.dw_tab3_2.settransobject(sqlca)

IF f_change_name('1') = 'Y' then 
   tab_1.tabpage_1.dw_tab1_1.object.ispec_t.text = f_change_name('2')
   tab_1.tabpage_1.dw_tab1_1.object.jijil_t.text = f_change_name('3')
   tab_1.tabpage_2.dw_tab2_1.object.ispec_t.text = f_change_name('2')
   tab_1.tabpage_2.dw_tab2_1.object.jijil_t.text = f_change_name('3')
END IF
end event

type dw_insert from w_inherite`dw_insert within w_pdt_07100
boolean visible = false
integer x = 3250
integer y = 2428
integer width = 311
integer taborder = 210
boolean enabled = false
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type p_delrow from w_inherite`p_delrow within w_pdt_07100
integer y = 5000
integer taborder = 60
end type

type p_addrow from w_inherite`p_addrow within w_pdt_07100
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_07100
integer y = 5000
integer taborder = 160
end type

type p_ins from w_inherite`p_ins within w_pdt_07100
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_07100
integer y = 5000
integer taborder = 140
end type

type p_can from w_inherite`p_can within w_pdt_07100
integer y = 5000
integer taborder = 120
end type

type p_print from w_inherite`p_print within w_pdt_07100
integer y = 5000
integer taborder = 180
end type

type p_inq from w_inherite`p_inq within w_pdt_07100
integer y = 5000
end type

type p_del from w_inherite`p_del within w_pdt_07100
integer y = 5000
integer taborder = 100
end type

type p_mod from w_inherite`p_mod within w_pdt_07100
integer y = 5000
integer taborder = 80
end type

type cb_exit from w_inherite`cb_exit within w_pdt_07100
boolean visible = false
integer x = 2875
integer y = 2464
integer taborder = 220
boolean enabled = false
end type

type cb_mod from w_inherite`cb_mod within w_pdt_07100
boolean visible = false
integer x = 562
integer y = 2464
integer taborder = 70
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_pdt_07100
boolean visible = false
integer x = 160
integer y = 2488
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdt_07100
boolean visible = false
integer x = 923
integer y = 2464
integer taborder = 110
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_07100
boolean visible = false
integer x = 1285
integer y = 2464
integer taborder = 130
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pdt_07100
boolean visible = false
integer x = 1646
integer y = 2464
integer taborder = 150
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_07100
end type

type cb_can from w_inherite`cb_can within w_pdt_07100
boolean visible = false
integer x = 2007
integer y = 2464
integer taborder = 170
boolean enabled = false
end type

type cb_search from w_inherite`cb_search within w_pdt_07100
boolean visible = false
integer x = 2368
integer y = 2464
integer taborder = 190
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_07100
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_07100
end type

type tab_1 from tab within w_pdt_07100
integer x = 14
integer y = 20
integer width = 4599
integer height = 2308
integer taborder = 40
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
integer width = 4562
integer height = 2180
long backcolor = 32106727
string text = "제품정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "Project!"
long picturemaskcolor = 553648127
p_13 p_13
rr_9 rr_9
p_6 p_6
p_4 p_4
p_3 p_3
p_12 p_12
p_7 p_7
p_8 p_8
p_1 p_1
p_2 p_2
p_5 p_5
gb_6 gb_6
gb_5 gb_5
gb_1 gb_1
dw_tab1_1 dw_tab1_1
dw_tab1_2 dw_tab1_2
dw_tab1_3 dw_tab1_3
rr_7 rr_7
rr_8 rr_8
end type

on tabpage_1.create
this.p_13=create p_13
this.rr_9=create rr_9
this.p_6=create p_6
this.p_4=create p_4
this.p_3=create p_3
this.p_12=create p_12
this.p_7=create p_7
this.p_8=create p_8
this.p_1=create p_1
this.p_2=create p_2
this.p_5=create p_5
this.gb_6=create gb_6
this.gb_5=create gb_5
this.gb_1=create gb_1
this.dw_tab1_1=create dw_tab1_1
this.dw_tab1_2=create dw_tab1_2
this.dw_tab1_3=create dw_tab1_3
this.rr_7=create rr_7
this.rr_8=create rr_8
this.Control[]={this.p_13,&
this.rr_9,&
this.p_6,&
this.p_4,&
this.p_3,&
this.p_12,&
this.p_7,&
this.p_8,&
this.p_1,&
this.p_2,&
this.p_5,&
this.gb_6,&
this.gb_5,&
this.gb_1,&
this.dw_tab1_1,&
this.dw_tab1_2,&
this.dw_tab1_3,&
this.rr_7,&
this.rr_8}
end on

on tabpage_1.destroy
destroy(this.p_13)
destroy(this.rr_9)
destroy(this.p_6)
destroy(this.p_4)
destroy(this.p_3)
destroy(this.p_12)
destroy(this.p_7)
destroy(this.p_8)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_5)
destroy(this.gb_6)
destroy(this.gb_5)
destroy(this.gb_1)
destroy(this.dw_tab1_1)
destroy(this.dw_tab1_2)
destroy(this.dw_tab1_3)
destroy(this.rr_7)
destroy(this.rr_8)
end on

type p_13 from uo_picture within tabpage_1
integer x = 2779
integer y = 12
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\계획검색_up.gif"
end type

event clicked;long rtn, nRowCnt, ix

setNull(gs_gubun)
open(w_sorder_popup2)

	/* ClipBoard의 내용을 copy한다 */
dw_1.Reset()

If 	gs_gubun = '1' then      // Return 받은 내용이 있는지 확인.
	rtn = dw_1.ImportClipBoard()
	nRowCnt = dw_1.RowCount()
End if	
	
	/* key check */
If 	rtn <=0 Then Return 0
If 	nRowCnt <= 0 Then Return 0
	
For ix = 1 To nRowCnt

	rtn = dw_1.SetItemStatus(ix, 0, Primary!, DataModified!)
	If rtn <> 1 Then
		MessageBox('dw_auto status modify failed','전산실로 연락하십시요!!')
		Return
	End If
Next
		
if dw_1.rowcount() > 0 then
	wf_insert_sujuitem(nRowCnt)
end if



PictureName = 'c:\erpman\image\계획검색_d.gif'
enabled = false
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = 'c:\erpman\image\계획검색_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = 'c:\erpman\image\계획검색_dn.gif'
end event

type rr_9 from roundrectangle within tabpage_1
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 172
integer width = 4512
integer height = 776
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_6 from uo_picture within tabpage_1
integer x = 3995
integer y = 12
integer width = 178
string picturename = "c:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;call super::clicked;ib_any_typing =FALSE

// 기준년월 
dw_tab1_1.reset()
dw_tab1_2.reset()
dw_tab1_3.reset()
tab_1.tabpage_2.dw_tab2_1.reset()
tab_1.tabpage_2.dw_tab2_2.reset()
tab_1.tabpage_2.dw_tab2_3.reset()
tab_1.tabpage_3.dw_tab3_1.reset()
tab_1.tabpage_3.dw_tab3_2.reset()

tab_1.tabpage_3.p_9.enabled  = False
tab_1.tabpage_3.p_10.enabled = False
tab_1.tabpage_3.p_11.enabled = False
tab_1.tabpage_1.p_13.enabled = true
tab_1.tabpage_3.p_9.PictureName = "C:\ERPMAN\image\인쇄_d.gif"
tab_1.tabpage_3.p_10.PictureName = "C:\ERPMAN\image\조회_d.gif"
tab_1.tabpage_3.p_11.PictureName = "C:\ERPMAN\image\미리보기_d.gif"
tab_1.tabpage_1.p_13.PictureName = "C:\ERPMAN\image\계획검색_up.gif"

gb_5.text = '창고별 재고내역'
gb_6.text = '입출고 예정현황'
tab_1.tabpage_2.gb_12.text = '창고별 재고내역'
tab_1.tabpage_2.gb_2.text = '입출고 예정현황'
p_5.enabled = false
p_5.PictureName = "c:\erpman\image\조회_d.gif"
tab_1.tabpage_2.p_estima.enabled = False
tab_1.tabpage_2.p_estima.PictureName = "C:\ERPMAN\image\구매의뢰생성_d.gif"

dw_gijun.setredraw(false)
dw_gijun.reset()
dw_gijun.insertrow(0)
dw_gijun.setitem(1, "yymm", left(f_today(), 6))
dw_gijun.enabled = true
dw_gijun.setredraw(true)


end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\취소_up.gif"

end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\취소_dn.gif"
end event

type p_4 from uo_picture within tabpage_1
integer x = 4343
integer y = 12
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

type p_3 from uo_picture within tabpage_1
integer x = 4169
integer y = 12
integer width = 178
string picturename = "c:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;if f_msg_update() = -1 then return

dw_gijun.accepttext()

String 	sYymm, sChoice
decimal 	dseq
Long		Lrow

sYYmm 	= dw_gijun.getitemstring(1, "yymm")
sChoice 	= dw_gijun.getitemstring(1, "choice")
if sChoice = '2' then // 기존분 
	dSeq  	= dw_gijun.getitemdecimal(1, "seq")
else
	dSeq	= 0
	Select Max(seq) into :dSeq
	  From Erp_lotsim
	 where sabu = :gs_sabu
	 	and yymm	= :sYymm;
	if isnull(dseq) then dSeq = 0
	
	dSeq = dseq + 1
	dw_gijun.setitem(1, "seq", dseq)
end if

For Lrow = 1 to dw_tab1_1.rowcount()
	 dw_tab1_1.setitem(Lrow, "sabu", gs_sabu)
	 dw_tab1_1.setitem(Lrow, "yymm", sYymm)
	 dw_tab1_1.setitem(Lrow, "seq", Dseq)
	 
	 if isnull(dw_tab1_1.getitemstring(Lrow, "itnbr")) or &
	    Trim(dw_tab1_1.getitemstring(Lrow, "itnbr")) = '' then
		 Messagebox("품번", "품번을 입력하십시요", stopsign!)
		 dw_tab1_1.scrolltorow(Lrow)
		 dw_tab1_1.setrow(Lrow)
		 dw_tab1_1.setfocus()
		 return
	 end if
Next

String stoday

stoday = f_today()

IF dw_tab1_1.Update() = 1 and tab_1.tabpage_2.dw_tab2_1.update() = 1		THEN
	
	update erp_lotsim set caldate = :stoday
	 Where sabu = :gs_sabu and yymm = :sYymm and seq = :dSeq;
	
	COMMIT;
	Messagebox("저장완료", "저장되었읍니다", information!)
	dw_gijun.setitem(1, "choice", '2')
	p_5.enabled = true
	p_5.PictureName = "c:\erpman\image\조회_up.gif"
	tab_1.tabpage_3.dw_tab3_1.reset()
	tab_1.tabpage_3.dw_tab3_1.insertrow(0)
	tab_1.tabpage_3.dw_tab3_2.dataobject = 'd_pdt_07100_6'
	tab_1.tabpage_3.dw_tab3_2.settransobject(sqlca)
	tab_1.tabpage_3.p_9.enabled = true
	tab_1.tabpage_3.p_10.enabled = true
	tab_1.tabpage_3.p_11.enabled = true	
	tab_1.tabpage_3.p_9.PictureName = "C:\ERPMAN\image\인쇄_up.gif"
   tab_1.tabpage_3.p_10.PictureName = "C:\ERPMAN\image\조회_up.gif"
	tab_1.tabpage_3.p_11.PictureName = "C:\ERPMAN\image\미리보기_up.gif"
	tab_1.tabpage_2.p_estima.enabled = true
	tab_1.tabpage_2.p_estima.PictureName = "C:\ERPMAN\image\구매의뢰생성_up.gif"
	dw_tab1_1.setfocus()
ELSE
	f_Rollback()
	ROLLBACK;
END IF


end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\저장_up.gif"

end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\저장_dn.gif"
end event

type p_12 from uo_picture within tabpage_1
integer x = 3822
integer y = 12
integer width = 178
string picturename = "c:\erpman\image\전체삭제_up.gif"
end type

event clicked;call super::clicked;if MessageBox("전체삭제", "전체내역을 삭제하시겠읍니까?", question!, yesno!) = 2 then return

dw_gijun.accepttext()

String sYymm
decimal dseq

sYYmm = dw_gijun.getitemstring(1, "yymm")
dSeq  = dw_gijun.getitemdecimal(1, "seq")

Delete From erp_lotsim
 Where sabu = :gs_sabu 
   And yymm = :sYymm 
   And seq  = :dSeq;

IF sqlca.sqlcode <> 0 then
	
	Rollback;
	Messagebox("삭제실패", "삭제작업을 실패하였읍니다" + '~n' + sqlca.sqlerrtext, stopsign!)
	return
ELSE
	Commit;
	Messagebox("삭제완료", "전체내역이 삭제되었읍니다", information!)
	p_6.triggerevent(clicked!)
END IF


end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\전체삭제_up.gif"

end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\전체삭제_dn.gif"
end event

type p_7 from uo_picture within tabpage_1
integer x = 3648
integer y = 12
integer width = 178
string picturename = "c:\erpman\image\재고재계산_up.gif"
end type

event clicked;String sItnbr, sRtnbr
Decimal {3} dJego, dHold, dValid, dForec
Long Lrow

setpointer(hourglass!)
w_mdi_frame.sle_msg.text = '재고를 재계산중입니다..........!'

For Lrow = 1 to dw_tab1_1.rowcount()
	 sItnbr = dw_tab1_1.getitemstring(Lrow, "itnbr")

	 wf_jego(sitnbr, dJego, dHold, dValid, dForec, sRtnbr, 1)
	
	 dw_tab1_1.setitem(Lrow, "jego_qty", dJego)
	 dw_tab1_1.setitem(Lrow, "hold_qty", dHold)
	 dw_tab1_1.setitem(Lrow, "valid_qty", dValid)
	 dw_tab1_1.setitem(Lrow, "forca_qty", dForec)
	 dw_tab1_1.setitem(Lrow, "stditnbr", srtnbr)
Next

For Lrow = 1 to tab_1.tabpage_2.dw_tab2_1.rowcount()
	 sItnbr = tab_1.tabpage_2.dw_tab2_1.getitemstring(Lrow, "itnbr")

	 wf_jego(sitnbr, dJego, dHold, dValid, dForec, sRtnbr, 2)
	
	 tab_1.tabpage_2.dw_tab2_1.setitem(Lrow, "jego_qty", dJego)
	 tab_1.tabpage_2.dw_tab2_1.setitem(Lrow, "hold_qty", dHold)
	 tab_1.tabpage_2.dw_tab2_1.setitem(Lrow, "valid_qty", dValid)
	 tab_1.tabpage_2.dw_tab2_1.setitem(Lrow, "forca_qty", dForec)
	 tab_1.tabpage_2.dw_tab2_1.setitem(Lrow, "stditnbr", srtnbr)
Next

w_mdi_frame.sle_msg.text = ''
setpointer(arrow!)

p_3.triggerevent(clicked!)

dw_tab1_1.setfocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\재고재계산_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\재고재계산_up.gif"
end event

type p_8 from uo_picture within tabpage_1
integer x = 3474
integer y = 12
integer width = 178
string picturename = "c:\erpman\image\소요량계산_up.gif"
end type

event clicked;p_3.triggerevent(clicked!)

if dw_gijun.getitemdecimal(1, "seq") = 0 then
	Messagebox("소요량 계산", "저장후 계산하십시요", stopsign!)
	return
end if

integer ii, jj
String swkctr, sWkctr_option, sgbn

sWkctr 			= dw_gijun.getitemstring(1, "wkctr")
sWkctr_option 	= dw_gijun.getitemstring(1, "wkctr_option")

if sWkctr_option = 'Y' or isnull(sWkctr) or trim(swkctr) = '' then
	sWkctr = '9999'
end if


jj =  Messagebox("계산기준", "단단계로 계산하시 겠읍니까?", question!, yesno!, 2) 
sgbn = string(jj)

setpointer(hourglass!)

dw_gijun.accepttext()

ii = sqlca.fun_get_lotsim(gs_sabu, dw_gijun.getitemstring(1, "yymm"), &
												dw_gijun.getitemdecimal(1, "seq"), sWkctr, sgbn)

tab_1.tabpage_2.dw_tab2_1.retrieve(gs_sabu, dw_gijun.getitemstring(1, "yymm"), &
											  dw_gijun.getitemdecimal(1, "seq"))
												
if ii <> 1 then
	Messagebox("소요량 계산", "소요량 계산이 실패하였읍니다.", stopsign!)
	MessageBox(string(ii)+string(sqlca.sqlcode),sqlca.sqlerrtext)
else
	Messagebox("소요량 계산", "소요량 계산이 완료되었읍니다.", information!)	
end if

setpointer(arrow!)
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\소요량계산_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\소요량계산_dn.gif"
end event

type p_1 from uo_picture within tabpage_1
integer x = 3301
integer y = 12
integer width = 178
string picturename = "c:\erpman\image\삭제_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\삭제_dn.gif"
end event

event clicked;call super::clicked;Long Lrow

Lrow = dw_tab1_1.getrow()

If Lrow < 1 then
	Messagebox("삭제선택", "삭제할 내역을 선택하십시요", stopsign!)
	return
end if

if f_msg_delete() = -1 then return

dw_tab1_1.deleterow(Lrow)
dw_tab1_1.setfocus()
end event

type p_2 from uo_picture within tabpage_1
integer x = 3127
integer y = 12
integer width = 178
string picturename = "c:\erpman\image\추가_up.gif"
end type

event clicked;Long Lrow

Lrow = dw_tab1_1.insertrow(0)
dw_tab1_1.scrolltorow(Lrow)
dw_tab1_1.setcolumn("itnbr")
dw_tab1_1.setrow(Lrow)
dw_tab1_1.setfocus()
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\추가_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\추가_dn.gif"
end event

type p_5 from uo_picture within tabpage_1
integer x = 2953
integer y = 12
integer width = 178
string picturename = "c:\erpman\image\조회_d.gif"
end type

event clicked;dw_gijun.accepttext()

String sYymm
decimal dseq

sYYmm = dw_gijun.getitemstring(1, "yymm")
dSeq  = dw_gijun.getitemdecimal(1, "seq")

if dw_tab1_1.retrieve(gs_sabu, syymm, dSeq) < 1 then
	f_message_chk(50, '[Lot Simulation]')
	dw_gijun.setcolumn("yymm")
	dw_gijun.setfocus()
	return
end if

// 소요량 내역 출력
if tab_1.tabpage_2.dw_tab2_1.retrieve(gs_sabu, syymm, dSeq) < 1 then 
   tab_1.tabpage_2.p_estima.enabled = False
	tab_1.tabpage_2.p_estima.PictureName = "C:\ERPMAN\image\구매의뢰생성_d.gif"
else
   tab_1.tabpage_2.p_estima.enabled = True
	tab_1.tabpage_2.p_estima.PictureName = "C:\ERPMAN\image\구매의뢰생성_up.gif"	
end if	

tab_1.tabpage_3.dw_tab3_1.insertrow(0)
tab_1.tabpage_3.dw_tab3_2.dataobject = 'd_pdt_07100_6'
tab_1.tabpage_3.dw_tab3_2.settransobject(sqlca)
tab_1.tabpage_3.p_9.enabled = true
tab_1.tabpage_3.p_10.enabled = true
tab_1.tabpage_3.p_11.enabled = true
tab_1.tabpage_3.p_9.PictureName = "C:\ERPMAN\image\인쇄_up.gif"
tab_1.tabpage_3.p_10.PictureName = "C:\ERPMAN\image\조회_up.gif"
tab_1.tabpage_3.p_11.PictureName = "C:\ERPMAN\image\미리보기_up.gif"

this.enabled = false
this.PictureName = "C:\ERPMAN\image\조회_d.gif"
dw_gijun.enabled = false

dw_tab1_1.setfocus()
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\조회_dn.gif"
end event

type gb_6 from groupbox within tabpage_1
integer x = 1755
integer y = 968
integer width = 2738
integer height = 1180
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "입출고 예정현황"
end type

type gb_5 from groupbox within tabpage_1
integer x = 32
integer y = 968
integer width = 1664
integer height = 1180
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "창고별 재고내역"
end type

type gb_1 from groupbox within tabpage_1
integer x = 32
integer y = 184
integer width = 4462
integer height = 740
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "Lot 내역"
end type

type dw_tab1_1 from datawindow within tabpage_1
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 37
integer y = 244
integer width = 4430
integer height = 664
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_07100_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;String 	sItnbr, sitdsc, sispec, sjijil, sispec_code, sNull, sRtnbr
Integer 	ireturn
Long    	Lrow, Lfind
Decimal {3} dJego, dHold, dValid, dForec

Setnull(sNull)
this.accepttext()
Lrow = this.getrow()

IF GetColumnName() = "itnbr"	THEN
	sItnbr = trim(GetText())
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	
	wf_tab1_retrieve(Lrow)
	
	if ireturn = 1 then
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
 		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF			
	
	lFind = This.Find("itnbr = '"+sItnbr+"' ", 1, This.RowCount())

	IF (lRow <> lFind) and (lFind <> 0)		THEN
		f_message_chk(37,'[품번]')
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
 		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)					
		RETURN  1
	END IF	
	
	setitem(lrow, "itnbr", sitnbr)	
	setitem(lrow, "itdsc", sitdsc)	
	setitem(lrow, "ispec", sispec)
	setitem(lrow, "jijil", sjijil)	
	setitem(lrow, "ispec_code", sispec_code)
	
	if wf_jego(sitnbr, dJego, dHold, dValid, dForec, srtnbr, 1) = -1 then
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
 		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF			
	
	setitem(Lrow, "jego_qty", dJego)
	setitem(Lrow, "hold_qty", dHold)
	setitem(Lrow, "valid_qty", dValid)
	setitem(Lrow, "forca_qty", dForec)
	setitem(Lrow, "stditnbr", srtnbr)	
	
	RETURN ireturn
ELSEIF GetColumnName() = "itdsc"	THEN
	sItdsc = trim(GetText())
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	
	wf_tab1_retrieve(Lrow)
	
	if ireturn = 1 then
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
 		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF			
	
	lFind = This.Find("itnbr = '"+sItnbr+"' ", 1, This.RowCount())	
	IF (lRow <> lFind) and (lFind <> 0)		THEN
		f_message_chk(37,'[품번]')
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF		
	
	setitem(lrow, "itnbr", sitnbr)	
	setitem(lrow, "itdsc", sitdsc)	
	setitem(lrow, "ispec", sispec)
	setitem(lrow, "jijil", sjijil)	
	setitem(lrow, "ispec_code", sispec_code)
	
	if wf_jego(sitnbr, dJego, dHold, dValid, dForec, srtnbr, 1) = -1 then
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
 		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF			
	
	setitem(Lrow, "stditnbr", srtnbr)	
	setitem(Lrow, "jego_qty", dJego)
	setitem(Lrow, "hold_qty", dHold)
	setitem(Lrow, "valid_qty", dValid)
	setitem(Lrow, "forca_qty", dForec)	
	setitem(Lrow, "stditnbr", srtnbr)		
	
	RETURN ireturn
ELSEIF GetColumnName() = "ispec"	THEN
	sIspec = trim(GetText())
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	
	wf_tab1_retrieve(Lrow)
	
	if ireturn = 1 then
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
 		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF			
	
	lFind = This.Find("itnbr = '"+sItnbr+"' ", 1, This.RowCount())	
	IF (lRow <> lFind) and (lFind <> 0)		THEN
		f_message_chk(37,'[품번]')
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF		
	
	setitem(lrow, "itnbr", sitnbr)	
	setitem(lrow, "itdsc", sitdsc)	
	setitem(lrow, "ispec", sispec)
	setitem(lrow, "jijil", sjijil)	
	setitem(lrow, "ispec_code", sispec_code)
	
	if wf_jego(sitnbr, dJego, dHold, dValid, dForec, sRtnbr, 1) = -1 then
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
 		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF			
	
	setitem(Lrow, "stditnbr", srtnbr)
	setitem(Lrow, "jego_qty", dJego)
	setitem(Lrow, "hold_qty", dHold)
	setitem(Lrow, "valid_qty", dValid)
	setitem(Lrow, "forca_qty", dForec)	
	
	RETURN ireturn

ELSEIF GetColumnName() = "jijil"	THEN
	sjijil = trim(GetText())
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	
	wf_tab1_retrieve(Lrow)
	
	if ireturn = 1 then
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
 		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF			
	
	lFind = This.Find("itnbr = '"+sItnbr+"' ", 1, This.RowCount())	
	IF (lRow <> lFind) and (lFind <> 0)		THEN
		f_message_chk(37,'[품번]')
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF		
	
	setitem(lrow, "itnbr", sitnbr)	
	setitem(lrow, "itdsc", sitdsc)	
	setitem(lrow, "ispec", sispec)
	setitem(lrow, "jijil", sjijil)	
	setitem(lrow, "ispec_code", sispec_code)
	
	if wf_jego(sitnbr, dJego, dHold, dValid, dForec, sRtnbr, 1) = -1 then
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
 		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF			
	
	setitem(Lrow, "stditnbr", srtnbr)
	setitem(Lrow, "jego_qty", dJego)
	setitem(Lrow, "hold_qty", dHold)
	setitem(Lrow, "valid_qty", dValid)
	setitem(Lrow, "forca_qty", dForec)	
	
	RETURN ireturn

ELSEIF GetColumnName() = "ispec_code"	THEN
	sispec_code = trim(GetText())
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	
	wf_tab1_retrieve(Lrow)
	
	if ireturn = 1 then
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
 		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF			
	
	lFind = This.Find("itnbr = '"+sItnbr+"' ", 1, This.RowCount())	
	IF (lRow <> lFind) and (lFind <> 0)		THEN
		f_message_chk(37,'[품번]')
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF		
	
	setitem(lrow, "itnbr", sitnbr)	
	setitem(lrow, "itdsc", sitdsc)	
	setitem(lrow, "ispec", sispec)
	setitem(lrow, "jijil", sjijil)	
	setitem(lrow, "ispec_code", sispec_code)
	
	if wf_jego(sitnbr, dJego, dHold, dValid, dForec, sRtnbr, 1) = -1 then
		this.SetItem(lRow, "itnbr", sNull)
		this.SetItem(lRow, "itdsc", sNull)
		this.SetItem(lRow, "ispec", sNull)		
		this.SetItem(lRow, "jijil", sNull)
		this.SetItem(lRow, "ispec_code", sNull)		
		setitem(Lrow, "jego_qty", 0)
		setitem(Lrow, "hold_qty", 0)
 		setitem(Lrow, "valid_qty", 0)
		setitem(Lrow, "forca_qty", 0)
		setitem(Lrow, "stditnbr", snull)
		RETURN  1
	END IF			
	
	setitem(Lrow, "stditnbr", srtnbr)
	setitem(Lrow, "jego_qty", dJego)
	setitem(Lrow, "hold_qty", dHold)
	setitem(Lrow, "valid_qty", dValid)
	setitem(Lrow, "forca_qty", dForec)	
	
	RETURN ireturn

ELSEIF GetColumnName() = "lotqty"	THEN
	if Dec(gettext()) < 1 then
		Messagebox("수량", "수량은 0보다 커야 합니다", stopsign!)
		setitem(Lrow, "lotqty", 1)
		return 1
	end if
End if
end event

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

//For iPos = Len(sErrorSyntax) to 1 STEP -1
//	 sMsg = Mid(sErrorSyntax, ipos, 1)
//	 If sMsg   = sReturn or sMsg = sNewline Then
//		 iCount++
//	 End if
//Next
//
//sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)
//

str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event editchanged;//ib_any_typing =True
end event

event rbuttondown;String colname
Long   lrow

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

colname = this.getcolumnname()
lrow	  = this.getrow()
if colname = "itnbr" then
   gs_gubun = '1' 
	
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(lrow,"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
end if
end event

event itemerror;return 1
end event

event rowfocuschanged;wf_tab1_retrieve(currentrow)
end event

event getfocus;String sItnbr
Long	 Lrow

Lrow = this.getrow()

wf_tab1_retrieve(Lrow)
end event

type dw_tab1_2 from datawindow within tabpage_1
integer x = 46
integer y = 1024
integer width = 1632
integer height = 1104
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_pdt_07100_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_tab1_3 from datawindow within tabpage_1
integer x = 1774
integer y = 1024
integer width = 2697
integer height = 1104
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_pdt_07100_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_7 from roundrectangle within tabpage_1
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 952
integer width = 1705
integer height = 1220
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_8 from roundrectangle within tabpage_1
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 1737
integer y = 952
integer width = 2784
integer height = 1220
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4562
integer height = 2180
long backcolor = 32106727
string text = "소요량 정보"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "ListView!"
long picturemaskcolor = 553648127
rr_6 rr_6
p_estima p_estima
gb_12 gb_12
gb_11 gb_11
dw_tab2_1 dw_tab2_1
dw_tab2_2 dw_tab2_2
dw_tab2_3 dw_tab2_3
gb_2 gb_2
rr_4 rr_4
rr_5 rr_5
end type

on tabpage_2.create
this.rr_6=create rr_6
this.p_estima=create p_estima
this.gb_12=create gb_12
this.gb_11=create gb_11
this.dw_tab2_1=create dw_tab2_1
this.dw_tab2_2=create dw_tab2_2
this.dw_tab2_3=create dw_tab2_3
this.gb_2=create gb_2
this.rr_4=create rr_4
this.rr_5=create rr_5
this.Control[]={this.rr_6,&
this.p_estima,&
this.gb_12,&
this.gb_11,&
this.dw_tab2_1,&
this.dw_tab2_2,&
this.dw_tab2_3,&
this.gb_2,&
this.rr_4,&
this.rr_5}
end on

on tabpage_2.destroy
destroy(this.rr_6)
destroy(this.p_estima)
destroy(this.gb_12)
destroy(this.gb_11)
destroy(this.dw_tab2_1)
destroy(this.dw_tab2_2)
destroy(this.dw_tab2_3)
destroy(this.gb_2)
destroy(this.rr_4)
destroy(this.rr_5)
end on

type rr_6 from roundrectangle within tabpage_2
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer y = 140
integer width = 4535
integer height = 844
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_estima from uo_picture within tabpage_2
integer x = 4055
integer y = 16
integer width = 475
integer height = 100
boolean originalsize = true
string picturename = "C:\ERPMAN\image\구매의뢰생성_up.gif"
end type

event clicked;call super::clicked;
gs_code     = dw_gijun.getitemstring(1, "yymm")
gs_codename = string(dw_gijun.getitemdecimal(1, "seq"))

open(w_pdt_07100_2)


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\ERPMAN\image\구매의뢰생성_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\ERPMAN\image\구매의뢰생성_dn.gif"
end event

type gb_12 from groupbox within tabpage_2
integer x = 23
integer y = 1040
integer width = 1664
integer height = 1112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "창고별 재고내역"
end type

type gb_11 from groupbox within tabpage_2
integer x = 27
integer y = 148
integer width = 4485
integer height = 812
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "소요 품목 내역"
end type

type dw_tab2_1 from datawindow within tabpage_2
integer x = 50
integer y = 200
integer width = 4416
integer height = 720
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_07100_5"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event getfocus;wf_tab2_retrieve(this.getrow())
end event

event rowfocuschanged;wf_tab2_retrieve(currentrow)
end event

type dw_tab2_2 from datawindow within tabpage_2
integer x = 46
integer y = 1104
integer width = 1623
integer height = 1016
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdt_07100_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_tab2_3 from datawindow within tabpage_2
integer x = 1765
integer y = 1104
integer width = 2711
integer height = 1016
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdt_07100_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within tabpage_2
integer x = 1737
integer y = 1040
integer width = 2779
integer height = 1112
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "입출고예정현황"
end type

type rr_4 from roundrectangle within tabpage_2
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 1710
integer y = 1016
integer width = 2830
integer height = 1152
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within tabpage_2
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer y = 1016
integer width = 1701
integer height = 1152
integer cornerheight = 40
integer cornerwidth = 55
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4562
integer height = 2180
long backcolor = 32106727
string text = "Simulation 출력"
long tabtextcolor = 33554432
long tabbackcolor = 32106727
string picturename = "Print!"
long picturemaskcolor = 553648127
p_9 p_9
p_11 p_11
p_10 p_10
rr_1 rr_1
dw_tab3_2 dw_tab3_2
sle_1 sle_1
st_2 st_2
dw_tab3_1 dw_tab3_1
end type

on tabpage_3.create
this.p_9=create p_9
this.p_11=create p_11
this.p_10=create p_10
this.rr_1=create rr_1
this.dw_tab3_2=create dw_tab3_2
this.sle_1=create sle_1
this.st_2=create st_2
this.dw_tab3_1=create dw_tab3_1
this.Control[]={this.p_9,&
this.p_11,&
this.p_10,&
this.rr_1,&
this.dw_tab3_2,&
this.sle_1,&
this.st_2,&
this.dw_tab3_1}
end on

on tabpage_3.destroy
destroy(this.p_9)
destroy(this.p_11)
destroy(this.p_10)
destroy(this.rr_1)
destroy(this.dw_tab3_2)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.dw_tab3_1)
end on

type p_9 from uo_picture within tabpage_3
integer x = 4370
integer y = 20
integer width = 178
boolean enabled = false
boolean originalsize = true
string picturename = "C:\ERPMAN\image\인쇄_d.gif"
end type

event clicked;call super::clicked;dw_print.Reset()
dw_tab3_2.RowsCopy(1, dw_tab3_2.RowCount(), Primary!, dw_print, 1, Primary!)

IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\ERPMAN\image\인쇄_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\ERPMAN\image\인쇄_dn.gif"
end event

type p_11 from uo_picture within tabpage_3
integer x = 4201
integer y = 20
integer width = 178
boolean enabled = false
string picturename = "C:\ERPMAN\image\미리보기_d.gif"
end type

event clicked;call super::clicked;dw_print.Reset()
dw_tab3_2.RowsCopy(1, dw_tab3_2.RowCount(), Primary!, dw_print, 1, Primary!)
OpenWithParm(w_print_preview, dw_print)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\ERPMAN\image\미리보기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\ERPMAN\image\미리보기_dn.gif"
end event

type p_10 from uo_picture within tabpage_3
integer x = 4032
integer y = 20
integer width = 178
boolean enabled = false
boolean originalsize = true
string picturename = "C:\ERPMAN\image\조회_d.gif"
end type

event clicked;call super::clicked;dw_gijun.accepttext()
dw_tab3_1.accepttext()

String 	sYymm, sTxt, sWcdsc, sobject, ssitnbr, seitnbr, svalue
decimal 	dseq
dec {2}  dvalue

sYYmm 	= dw_gijun.getitemstring(1, "yymm")
dSeq  	= dw_gijun.getitemdecimal(1, "seq")
sObject  = dw_tab3_1.getitemstring(1, "gijun")
ssItnbr  = dw_tab3_1.getitemstring(1, "sitnbr")
seItnbr  = dw_tab3_1.getitemstring(1, "eitnbr")
svalue	= dw_tab3_1.getitemstring(1, "gubun")
sTxt		= sle_1.text

if svalue = '1' then
	dvalue = 9999999999999.00
else
	dvalue = 0
end if

if isnull(ssitnbr) or trim(sSitnbr) = '' then sSitnbr = '.'
if isnull(seitnbr) or trim(sEitnbr) = '' then sEitnbr = 'ZZZZZZZZZZZZZZZZz'

setnull(sWcdsc)
select Min(b.wcdsc)
  into :sWcdsc
  from erp_lotsim a,
  		 wrkctr b
 where a.sabu = :gs_sabu
 	and a.yymm = :sYymm
	and a.seq  = :dseq
	and a.gubun = 'G'
	and a.wkctr = b.wkctr;
	
if isnull(sWcdsc) then sWcdsc = '전체작업장'
if sobject = 'd_pdt_07100_6' then	
	IF dw_tab3_2.retrieve(gs_sabu, syymm, dseq, sTxt, sWcdsc) < 1 then
		f_message_chk(50,'[Lot Simulation(전체)]')
	END IF
Elseif sobject = 'd_pdt_07100_7' then	
	IF dw_tab3_2.retrieve(gs_sabu, syymm, dseq, sTxt, sWcdsc, ssitnbr, seitnbr, dvalue) < 1 then
		f_message_chk(50,'[Lot Simulation(제품)]')
	END IF
Elseif sobject = 'd_pdt_07100_8' then	
	IF dw_tab3_2.retrieve(gs_sabu, syymm, dseq, sTxt, sWcdsc, dvalue) < 1 then
		f_message_chk(50,'[Lot Simulation(소요)]')
	END IF
end if
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\ERPMAN\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\ERPMAN\image\조회_dn.gif"
end event

type rr_1 from roundrectangle within tabpage_3
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 180
integer width = 4544
integer height = 1844
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_tab3_2 from datawindow within tabpage_3
integer x = 32
integer y = 200
integer width = 4503
integer height = 1800
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pdt_07100_6"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_1 from singlelineedit within tabpage_3
integer x = 229
integer y = 2044
integer width = 2199
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within tabpage_3
integer x = 23
integer y = 2056
integer width = 197
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "사유"
boolean focusrectangle = false
end type

type dw_tab3_1 from datawindow within tabpage_3
integer x = 5
integer y = 36
integer width = 3264
integer height = 140
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_pdt_07100_9"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long Lrow
string sColumn, sData

sColumn = getcolumnname()

if sColumn = 'gijun' then
	sData = data
	dw_tab3_2.dataobject = sData
	dw_print.dataobject = sData + "_p"
	dw_tab3_2.settransobject(sqlca)
	dw_print.SetTransObject(sqlca)
end if
end event

event itemerror;return 1 
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
gs_gubun = '1' 

if this.getcolumnname() = "sitnbr" then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"sitnbr", gs_code)
elseif this.getcolumnname() = "eitnbr" then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"eitnbr", gs_code)
end if
end event

type dw_gijun from datawindow within w_pdt_07100
integer x = 1655
integer y = 20
integer width = 2057
integer height = 104
integer taborder = 90
boolean bringtotop = true
string dataobject = "d_pdt_07100_2"
boolean border = false
boolean livescroll = true
end type

event itemchanged;if 		dwo.name = 'choice' and data = '2' then
			tab_1.tabpage_1.p_5.enabled = true
			tab_1.tabpage_1.p_5.PictureName = "c:\erpman\image\조회_up.gif"
elseif	dwo.name = 'choice' and data = '1' then
			tab_1.tabpage_1.p_5.enabled = False
			tab_1.tabpage_1.p_5.PictureName = "c:\erpman\image\조회_d.gif"
end if
	
end event

event rbuttondown;dec dseq

if this.getcolumnname() = 'seq' then
	gs_code = getitemstring(1, "yymm")
	
	open(w_pdt_07100_1)
	
	if isnumber(gs_codename) then
		setitem(1, "seq", dec(gs_codename))
	else
		setitem(1, "seq", 0)		
	end if
end if
end event

type dw_print from datawindow within w_pdt_07100
integer x = 4681
integer y = 804
integer width = 146
integer height = 100
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdt_07100_6_p"
boolean border = false
boolean livescroll = true
end type

type dw_1 from datawindow within w_pdt_07100
boolean visible = false
integer x = 654
integer y = 1788
integer width = 1801
integer height = 432
integer taborder = 200
string title = "none"
string dataobject = "d_sorder_popup2_dpd"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

