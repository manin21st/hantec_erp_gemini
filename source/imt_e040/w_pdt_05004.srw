$PBExportHeader$w_pdt_05004.srw
$PBExportComments$입고마감-거래처(입고내역조회)
forward
global type w_pdt_05004 from window
end type
type cbx_1 from checkbox within w_pdt_05004
end type
type dw_1 from u_d_select_sort within w_pdt_05004
end type
type dw_3 from datawindow within w_pdt_05004
end type
type cb_2 from commandbutton within w_pdt_05004
end type
type dw_2 from datawindow within w_pdt_05004
end type
type st_3 from statictext within w_pdt_05004
end type
type st_2 from statictext within w_pdt_05004
end type
type p_exit from uo_picture within w_pdt_05004
end type
type p_can from uo_picture within w_pdt_05004
end type
type p_print from uo_picture within w_pdt_05004
end type
type p_mod from uo_picture within w_pdt_05004
end type
type st_1 from statictext within w_pdt_05004
end type
type cb_1 from commandbutton within w_pdt_05004
end type
type cb_exit from commandbutton within w_pdt_05004
end type
type cb_cancel from commandbutton within w_pdt_05004
end type
type cb_save from commandbutton within w_pdt_05004
end type
type rr_1 from roundrectangle within w_pdt_05004
end type
type rr_2 from roundrectangle within w_pdt_05004
end type
end forward

global type w_pdt_05004 from window
integer x = 59
integer y = 124
integer width = 4649
integer height = 1800
boolean titlebar = true
string title = "마감전표이력"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cbx_1 cbx_1
dw_1 dw_1
dw_3 dw_3
cb_2 cb_2
dw_2 dw_2
st_3 st_3
st_2 st_2
p_exit p_exit
p_can p_can
p_print p_print
p_mod p_mod
st_1 st_1
cb_1 cb_1
cb_exit cb_exit
cb_cancel cb_cancel
cb_save cb_save
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_05004 w_pdt_05004

type variables
str_05000 istr_05000
decimal idamt
end variables

forward prototypes
public subroutine wf_filter ()
end prototypes

public subroutine wf_filter ();string	sittyp1, sittyp2, sittyp3, sittyp4, sittyp0, sfilt

dw_3.accepttext()

sittyp1 = dw_3.getitemstring(1, 'ittyp1')
sittyp2 = dw_3.getitemstring(1, 'ittyp2')
sittyp3 = dw_3.getitemstring(1, 'ittyp3')
sittyp4 = dw_3.getitemstring(1, 'ittyp4')
sittyp0 = dw_3.getitemstring(1, 'ittyp0')

/* 전체 선택된 상태에서 필터 조건이 걸리면 필터된 항목도 선택된 채로 마감내역에 처리되는 현상 발생 - by shingoon 2017.03.13 */
/* 필터 전 선택취소 처리, 필터 끝나는 구문에는 다시 전체선택 처리 */
Long   i
For i = 1 To dw_1.RowCount()
	dw_1.SetItem(i, 'gubun', 'N')
	dw_1.trigger event itemchanged(i, dw_1.object.gubun, 'N')
Next

if sittyp1 = 'Y' then
	sfilt = " itemas_ittyp = '1' "
end if

if sittyp2 = 'Y' then
	if isnull(sfilt) or sfilt = '' then
		sfilt = " itemas_ittyp = '2' "
	else
		sfilt = sfilt + " or itemas_ittyp = '2' "
	end if
end if

if sittyp3 = 'Y' then
	if isnull(sfilt) or sfilt = '' then
		sfilt = " itemas_ittyp = '3' "
	else
		sfilt = sfilt + " or itemas_ittyp = '3' "
	end if
end if

if sittyp4 = 'Y' then
	if isnull(sfilt) or sfilt = '' then
		sfilt = " itemas_ittyp = '4' "
	else
		sfilt = sfilt + " or itemas_ittyp = '4' "
	end if
end if

if sittyp0 = 'Y' then
	if isnull(sfilt) or sfilt = '' then
		sfilt = " itemas_ittyp = '5' or itemas_ittyp = '7' or itemas_ittyp = '8' or itemas_ittyp = '9' "
	else
		sfilt = sfilt + " or itemas_ittyp = '5' or itemas_ittyp = '7' or itemas_ittyp = '8' or itemas_ittyp = '9' "
	end if
end if

dw_1.setfilter(sfilt)
dw_1.filter()
dw_1.groupcalc()
/* 필터 전 선택취소 처리, 필터 끝나는 구문에는 다시 전체선택 처리 */
For i = 1 To dw_1.RowCount()
	dw_1.SetItem(i, 'gubun', 'Y')
	dw_1.trigger event itemchanged(i, dw_1.object.gubun, 'Y')
Next
end subroutine

on w_pdt_05004.create
this.cbx_1=create cbx_1
this.dw_1=create dw_1
this.dw_3=create dw_3
this.cb_2=create cb_2
this.dw_2=create dw_2
this.st_3=create st_3
this.st_2=create st_2
this.p_exit=create p_exit
this.p_can=create p_can
this.p_print=create p_print
this.p_mod=create p_mod
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_exit=create cb_exit
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.cbx_1,&
this.dw_1,&
this.dw_3,&
this.cb_2,&
this.dw_2,&
this.st_3,&
this.st_2,&
this.p_exit,&
this.p_can,&
this.p_print,&
this.p_mod,&
this.st_1,&
this.cb_1,&
this.cb_exit,&
this.cb_cancel,&
this.cb_save,&
this.rr_1,&
this.rr_2}
end on

on w_pdt_05004.destroy
destroy(this.cbx_1)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.cb_2)
destroy(this.dw_2)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_print)
destroy(this.p_mod)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_exit)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;istr_05000 = message.powerobjectparm

f_window_center_response(this) 

dw_1.settransobject(sqlca)

dw_2.settransobject(sqlca)

//p_can.triggerevent(clicked!)

dw_3.insertrow(0)

p_can.PostEvent(clicked!)


end event

type cbx_1 from checkbox within w_pdt_05004
integer x = 119
integer y = 228
integer width = 457
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "전체선택"
boolean checked = true
end type

event clicked;long		lrow
string	schk

dw_1.setredraw(false)
if this.checked then
	schk = 'Y'
else
	schk = 'N'
end if

for lrow = 1 to dw_1.rowcount()
	dw_1.setitem(lrow, 'gubun', schk)
	dw_1.trigger event itemchanged(lrow, dw_1.object.gubun, schk)
next
dw_1.setredraw(true)
end event

type dw_1 from u_d_select_sort within w_pdt_05004
integer x = 46
integer y = 292
integer width = 4494
integer height = 1388
integer taborder = 90
string dataobject = "d_pdt_05004_1"
boolean border = false
boolean hsplitscroll = true
end type

event itemchanged;call super::itemchanged;String sNull
Setnull(sNull)

/* 위 방식에서 아래 방식으로 채용 '20.02.13 BY BHKIM
if this.getcolumnname() = 'gubun' then
	if data = 'N' then
		this.setitem(row, "mayymm", snull)
		this.setitem(row, "mayysq", 0)
	else
		this.setitem(row, "mayymm", istr_05000.mayymm)
		this.setitem(row, "mayysq", istr_05000.mayysq)
	end if
end if
*/

Choose Case dwo.name
	Case 'gubun'
		if data = 'N' then
			this.setitem(row, "mayymm", snull)
			this.setitem(row, "mayysq", 0)
		else
			this.setitem(row, "mayymm", istr_05000.mayymm)
			this.setitem(row, "mayysq", istr_05000.mayysq)
		end if
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

type dw_3 from datawindow within w_pdt_05004
integer x = 50
integer y = 48
integer width = 2213
integer height = 108
integer taborder = 90
string title = "none"
string dataobject = "d_pdt_05004_0"
boolean border = false
boolean livescroll = true
end type

event itemerror;return 1
end event

event itemchanged;post wf_filter()
end event

type cb_2 from commandbutton within w_pdt_05004
boolean visible = false
integer x = 2798
integer y = 8
integer width = 457
integer height = 84
integer taborder = 90
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "정렬"
end type

event clicked;Openwithparm(w_sort, dw_1)
end event

type dw_2 from datawindow within w_pdt_05004
boolean visible = false
integer x = 46
integer y = 1744
integer width = 4494
integer height = 604
integer taborder = 30
string dataobject = "d_pdt_050041"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_pdt_05004
boolean visible = false
integer x = 73
integer y = 1692
integer width = 457
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "▣ 공제내역"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdt_05004
boolean visible = false
integer x = 722
integer y = 236
integer width = 457
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "▣ 매입내역"
boolean focusrectangle = false
end type

type p_exit from uo_picture within w_pdt_05004
integer x = 4443
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

//close(parent)

CloseWithReturn(parent, '2')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_pdt_05004
integer x = 4270
integer y = 24
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

string sgijun
long   lCount

select dataname
  into :sgijun
  from syscnfg
 where sysgu = 'Y' and serial = 23 and lineno = '1';

if sgijun = '' or isnull(sgijun) then sgijun = '1'  //기본 검사일자로 셋팅

// 2000.06.23 유 local 은 사용안함
IF sgijun = '2' THEN  							//승인일자 기준
	dw_1.DataObject = 'd_pdt_05004_1'  
	st_1.text = '일자기준 : [승인일자 기준]'
ELSE 													//검사일자 기준
	dw_1.DataObject = 'd_pdt_05004'
	st_1.text = '일자기준 : [검사일자 기준]'
END IF
dw_1.SetTransObject(SQLCA)

//messagebox('msg',trim(istr_05000.sabu)+'/'+  trim(istr_05000.mayymm)+'/'+ string(istr_05000.mayysq) +'/'+ &
//							  trim(istr_05000.cvcod)+'/'+ trim(istr_05000.sdate)+'/'+  trim(istr_05000.edate)+'/'+ &
//							  trim(istr_05000.gubun)+'/'+ trim(istr_05000.saupj))

lCount = dw_1.retrieve(trim(istr_05000.sabu),  trim(istr_05000.mayymm), istr_05000.mayysq, &
							  trim(istr_05000.cvcod), trim(istr_05000.sdate),  trim(istr_05000.edate), &
							  trim(istr_05000.gubun), trim(istr_05000.saupj) )
if lCount < 1 then
	Messagebox("마감내역", "조회할 내역이 없읍니다", stopsign!)
	Close(parent)
	return
end if

lCount = dw_2.retrieve(trim(istr_05000.sabu),  trim(istr_05000.mayymm), istr_05000.mayysq, &
							  trim(istr_05000.cvcod) )
//if	lCount < 1 then
//	Messagebox("공제내역", "조회할 내역이 없읍니다", stopsign!)
//end if

if	istr_05000.move_yn = 'Y' then 
	p_mod.Enabled = false
	p_mod.picturename = "C:\erpman\image\저장_d.gif"
else	
	p_mod.Enabled = true
	p_mod.picturename = "C:\erpman\image\저장_up.gif"
end if   


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_print from uo_picture within w_pdt_05004
integer x = 4096
integer y = 24
integer width = 178
integer taborder = 100
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
dw_1.print()


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

type p_mod from uo_picture within w_pdt_05004
integer x = 3922
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
Dec{0}  dAmt, dgongamt, dipamt, ld_totamt, ld_totipamt, ld_totgongamt, ld_totvat,ld_mayysq
Long	  Lrow, Lcrow
Datawindow	dwchk
String ls_sabu, ls_mayymm,  ls_cvcod

dwchk = istr_05000.dwname
Lcrow = istr_05000.lrow

// 구분이 old와 new가 동일하면  status를 강제적으로 수정안된것을 처리.
For Lrow = 1 to dw_1.rowcount()
	 if 	dw_1.getitemstring(Lrow, "gubun") = dw_1.getitemstring(Lrow, "old_gubun") then
		dw_1.SetItemStatus(Lrow, 0, Primary!, NotModified!)
	 end if
Next

if 	dw_1.update() = 1 then
	dAmt = 0 ; dgongamt = 0 ; dipamt = 0
	For Lrow = 1 to dw_1.rowcount()
		 if 	dw_1.getitemstring(Lrow, "gubun") = 'Y' then
			dAmt     = dAmt + dw_1.getitemdecimal(lrow, "imhist_ioamt")
			dgongamt = dgongamt + dw_1.getitemdecimal(lrow, "gongamt")
			dipamt   = dipamt + dw_1.getitemdecimal(lrow, "ipamt")
		 End if
	Next
	If	dw_2.update() = 1	then	
		For Lrow = 1 to dw_2.rowcount()
			 if 	dw_2.getitemstring(Lrow, "gubun") = 'Y' then
				dgongamt = dgongamt + dw_2.getitemdecimal(lrow, "gongamt")
			 End if
		Next
		if 	dwchk.getitemdecimal(lcrow, "gongamt") <> dgongamt  then
			dwchk.setitem(lcrow, "gongamt", dgongamt)
		end if
	End If
	
//	(trim(istr_05000.sabu),  trim(istr_05000.mayymm), istr_05000.mayysq, &
//							  trim(istr_05000.cvcod), trim(istr_05000.sdate),  trim(istr_05000.edate), &
//							  trim(istr_05000.gubun), trim(istr_05000.saupj) )
	ls_sabu		= trim(istr_05000.sabu)
	ls_mayymm	= trim(istr_05000.mayymm)
	ld_mayysq	= istr_05000.mayysq
	ls_cvcod		= trim(istr_05000.cvcod)

	ld_totamt 		= truncate(round(dw_1.getItemDecimal( dw_1.RowCount(), "cumsum"), 0), 0)
	ld_totipamt 	= truncate(round(dw_1.getItemDecimal( dw_1.RowCount(), "ipamt_sum"), 0), 0)
	ld_totgongamt 	= truncate(round(dw_1.getItemDecimal( dw_1.RowCount(), "gongamt_sum"), 0), 0)
	ld_totvat		= truncate(round(ld_totamt * 0.1 + 0.0000001, 0), 0)
	
	Update mahist set maamt = :ld_totamt, mavat = :ld_totvat, ipamt = :ld_totipamt, gongamt = :ld_totgongamt
	where sabu = :ls_sabu
	and	mayymm = :ls_mayymm
	and	mayysq = :ld_mayysq
	and	cvcod		= :ls_cvcod;
	
	If sqlca.sqlcode = 0 Then
		Commit;
		CloseWithReturn(parent, '1')
	Else
		Rollback;
		CloseWithReturn(parent, '2')
	End If
	
//	close(parent)
else
	rollback ;
	f_rollback()
end if

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type st_1 from statictext within w_pdt_05004
boolean visible = false
integer x = 2784
integer y = 104
integer width = 869
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pdt_05004
boolean visible = false
integer x = 1861
integer y = 2468
integer width = 517
integer height = 104
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "출력(&P)"
end type

event clicked;dw_1.print()


end event

type cb_exit from commandbutton within w_pdt_05004
boolean visible = false
integer x = 2921
integer y = 2468
integer width = 517
integer height = 104
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;close(parent)
end event

type cb_cancel from commandbutton within w_pdt_05004
boolean visible = false
integer x = 2391
integer y = 2468
integer width = 517
integer height = 104
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;string sgijun
long   lCount

select dataname
  into :sgijun
  from syscnfg
 where sysgu = 'Y' and serial = 23 and lineno = '1';

if sgijun = '' or isnull(sgijun) then sgijun = '1'  //기본 검사일자로 셋팅

// 2000.06.23 유 local 은 사용안함
IF sgijun = '2' THEN  							//승인일자 기준
	dw_1.DataObject = 'd_pdt_05004_1'  
	st_1.text = '일자기준 : [승인일자 기준]'
ELSE 													//검사일자 기준
	dw_1.DataObject = 'd_pdt_05004'
	st_1.text = '일자기준 : [검사일자 기준]'
END IF
dw_1.SetTransObject(SQLCA)

lCount = dw_1.retrieve(istr_05000.sabu,  istr_05000.mayymm, istr_05000.mayysq, &
							  istr_05000.cvcod, istr_05000.sdate,  istr_05000.edate,  &
							  istr_05000.gubun, istr_05000.saupj )
if lCount < 1 then
	Messagebox("마감내역", "조회할 내역이 없읍니다", stopsign!)
	Close(parent)
	return
end if

if istr_05000.move_yn = 'Y' then 
	cb_save.Enabled = false
else	
	cb_save.Enabled = true
end if   


end event

type cb_save from commandbutton within w_pdt_05004
boolean visible = false
integer x = 1330
integer y = 2468
integer width = 517
integer height = 104
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;Dec{0}  dAmt, dgongamt, dipamt
Long	  Lrow, Lcrow
Datawindow	dwchk

dwchk = istr_05000.dwname
Lcrow = istr_05000.lrow

// 구분이 old와 new가 동일하면  status를 
For Lrow = 1 to dw_1.rowcount()
	 if dw_1.getitemstring(Lrow, "gubun") = dw_1.getitemstring(Lrow, "old_gubun") then
		 dw_1.SetItemStatus(Lrow, 0, Primary!, NotModified!)
	 end if
Next

if dw_1.update() = 1 then
	dAmt = 0
	For Lrow = 1 to dw_1.rowcount()
		 if dw_1.getitemstring(Lrow, "gubun") = 'Y' then
			 dAmt     = dAmt + dw_1.getitemdecimal(lrow, "imhist_ioamt")
			 dgongamt = dgongamt + dw_1.getitemdecimal(lrow, "gongamt")
			 dipamt   = dipamt + dw_1.getitemdecimal(lrow, "ipamt")
			 
		 End if
	Next
	if dwchk.getitemdecimal(lcrow, "maamt") <> damt or &
	   dwchk.getitemdecimal(lcrow, "gongamt") <> dgongamt or &
		dwchk.getitemdecimal(lcrow, "ipamt") <> dipamt  then
		dwchk.setitem(lcrow, "maamt", damt)
		dwchk.setitem(lcrow, "gongamt", dgongamt)
		dwchk.setitem(lcrow, "ipamt", dipamt)
		dwchk.setitem(lcrow, "mavat", truncate(damt * 0.1, 0))
	end if
	
	close(parent)
else
	rollback ;
	f_rollback()
end if

end event

type rr_1 from roundrectangle within w_pdt_05004
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 212
integer width = 4521
integer height = 1484
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pdt_05004
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 32
integer y = 24
integer width = 2281
integer height = 168
integer cornerheight = 40
integer cornerwidth = 46
end type

