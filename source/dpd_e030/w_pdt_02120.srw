$PBExportHeader$w_pdt_02120.srw
$PBExportComments$작업실적시 사용자재 편집
forward
global type w_pdt_02120 from w_inherite
end type
type dw_hidden from datawindow within w_pdt_02120
end type
type cb_1 from commandbutton within w_pdt_02120
end type
type rr_1 from roundrectangle within w_pdt_02120
end type
end forward

global type w_pdt_02120 from w_inherite
integer width = 3497
integer height = 1732
string title = "사용자재 편집"
boolean minbox = false
windowtype windowtype = response!
dw_hidden dw_hidden
cb_1 cb_1
rr_1 rr_1
end type
global w_pdt_02120 w_pdt_02120

type variables
string shpjpno
end variables

forward prototypes
public function integer wf_requiredchk ()
end prototypes

public function integer wf_requiredchk ();Long		 Lrow
Integer	 iCnt = 0
String	 sDate
Decimal   dSeq

sDate = f_today()

For Lrow = 1 to dw_insert.rowcount()
	// 품번 check
	If isnull(dw_insert.getitemstring(Lrow, "imhist_itnbr")) or &
	 	trim(dw_insert.getitemstring(Lrow, "imhist_itnbr")) = '' Then
		f_message_chk(30,'[품번]')
		dw_insert.ScrollToRow(lrow)
		dw_insert.Setcolumn("imhist_itnbr")
		dw_insert.setfocus()
	   RETURN -1		  
	End if
	 
	// 사양 check(없으면 '.'을 입력)
	If isnull(dw_insert.getitemstring(Lrow, "imhist_pspec")) or &
	   trim(dw_insert.getitemstring(Lrow, "imhist_pspec")) = '' Then
		dw_insert.setitem(Lrow, "imhist_pspec", '.')
	End if	 
	 
	// 출고창고 check
	If isnull(dw_insert.getitemstring(Lrow, "imhist_depot_no")) or &
	 	trim(dw_insert.getitemstring(Lrow, "imhist_depot_no")) = '' Then
		f_message_chk(30,'[출고창고]')
		dw_insert.ScrollToRow(lrow)
		dw_insert.Setcolumn("imhist_depot_no")
		dw_insert.setfocus()
	 	RETURN -1
	End if	 
	
	// 수량 check
	If isnull(dw_insert.getitemdecimal(Lrow, "imhist_ioreqty")) or &
	 	dw_insert.getitemdecimal(Lrow, "imhist_ioreqty") = 0 Then
		f_message_chk(30,'[수량]')
		dw_insert.ScrollToRow(lrow)
		dw_insert.Setcolumn("imhist_ioreqty")
		dw_insert.setfocus()
	   RETURN -1
	End if
	 
	//출고번호가 없는 경우 첫번째자료에서 전표를 채번
	If (isnull(dw_insert.getitemstring(Lrow, "imhist_iojpno")) or &
	 	 trim(dw_insert.getitemstring(Lrow, "imhist_iojpno")) = '') And &
		icnt = 0 then
		dSeq = SQLCA.FUN_JUNPYO(gs_sabu, sDate, 'C0')
		IF dSeq < 0		THEN			
			rollback;
			f_message_chk(51,'[출고번호]')					
			RETURN -1
		end if
		icnt = 1
		Commit;
	end if
	
	If  isnull(dw_insert.getitemstring(Lrow, "imhist_iojpno")) or &
	 	 trim(dw_insert.getitemstring(Lrow, "imhist_iojpno")) = '' Then
		 dw_insert.setitem(Lrow, "imhist_iojpno", sDate + string(dSeq, '0000') + String(Lrow, '000'))	 
	End if
	
Next

return 1
end function

on w_pdt_02120.create
int iCurrent
call super::create
this.dw_hidden=create dw_hidden
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_hidden
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_pdt_02120.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_hidden)
destroy(this.cb_1)
destroy(this.rr_1)
end on

event open;call super::open;shpjpno = gs_code

f_window_center_response(this)

dw_insert.settransobject(sqlca)
dw_hidden.settransobject(sqlca)
dw_insert.retrieve(gs_sabu, shpjpno)
dw_insert.setfocus()
end event

type dw_insert from w_inherite`dw_insert within w_pdt_02120
integer x = 32
integer y = 184
integer width = 3401
integer height = 1428
string dataobject = "d_pdt_02120"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;String 	sItnbr, sItdsc, sIspec, sjijil, sIspec_code
Long	 	Lrow
Integer	iReturn
Decimal {3} dQTy

Lrow = getrow()

IF this.GetColumnName() = "imhist_itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sIspec_code)
	this.setitem(lrow, "imhist_itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.setitem(lrow, "itemas_jijil", sjijil)	
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sIspec_code)
	this.setitem(lrow, "imhist_itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.setitem(lrow, "itemas_jijil", sjijil)	
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sIspec_code)
	this.setitem(lrow, "imhist_itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.setitem(lrow, "itemas_jijil", sjijil)	
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_jijil"	THEN
	sjijil = trim(this.GetText())
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sIspec_code)
	this.setitem(lrow, "imhist_itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.setitem(lrow, "itemas_jijil", sjijil)	
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	RETURN ireturn
ELSEIF this.GetColumnName() = "itemas_ispec_code"	THEN
	sispec_code = trim(this.GetText())
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sIspec_code)
	this.setitem(lrow, "imhist_itnbr", sitnbr)	
	this.setitem(lrow, "itemas_itdsc", sitdsc)	
	this.setitem(lrow, "itemas_ispec", sispec)
	this.setitem(lrow, "itemas_jijil", sjijil)	
	this.setitem(lrow, "itemas_ispec_code", sispec_code)
	RETURN ireturn
ELSEIF this.getcolumnname() = "imhist_ioreqty" THEN
	dQTY = Dec(this.gettext())
	this.setitem(Lrow, "imhist_ioqty", dQty)
	this.setitem(Lrow, "imhist_iosuqty", dQty)
END IF
end event

event dw_insert::rbuttondown;Long Lrow

Lrow = this.getrow()
gs_code = ''
gs_codename = ''
// 품번
IF this.GetColumnName() = 'imhist_itnbr'	THEN
   gs_gubun = '1'
	open(w_itemas_popup)
   IF gs_code = '' or isnull(gs_code) then return 
	SetItem(lRow,"imhist_itnbr",gs_code)
	
	this.TriggerEvent("itemchanged")
END IF
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02120
boolean visible = false
integer x = 1486
integer y = 1828
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02120
boolean visible = false
integer x = 1303
integer y = 1824
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdt_02120
boolean visible = false
integer x = 1568
integer y = 1880
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdt_02120
integer x = 2587
integer y = 16
end type

event p_ins::clicked;call super::clicked;Long Lrow
String sIogbn, sDepot, sdptno, sPdtgu, sSidat, sPordno, sOpseq

/* 자동출고시에는 할당의 수불구분을 이용하지 않고 iomatrix의 자동출고를 이용하여 설정 */
select iogbn into :sIogbn from iomatrix where sabu = :gs_sabu and autbacp = 'Y';
If sqlca.sqlcode <> 0 then
	Messagebox("출고구분", "IOMATRIX에서 자동출고를 검색할 수 없읍니다", stopsign!)
	return
end if

/* 생산실적에서 실적일자를 검색 */
Select a.sidat, a.pordno, a.opsno
  Into :sSidat, :sPordno, :sOpseq
  from shpact a
 where a.sabu  = :gs_sabu and a.shpjpno = :shpjpno;
 
If sqlca.sqlcode <> 0 then
	Messagebox("작업일보", "생산실적 내역을 검색할 수 없읍니다", stopsign!)
	return
end if 

/* 해당생산팀에 대한 기본창고를 검색 */
Select a.pdtgu
  Into :sPdtgu
  from momast a
 where a.sabu  = :gs_sabu and a.pordno = :sPordno;
 
If sqlca.sqlcode <> 0 then
	Messagebox("작업지시", "작업지시 내역을 검색할 수 없읍니다", stopsign!)
	return
end if

// 창고(생산) : 자재창고 없음
select cvcod, deptcode into :sdepot, :sdptno 
  from vndmst 
 where cvgu = '5' and jumaechul = '1' and ipjogun = :gs_saupj and jumaeip = :spdtgu and rownum = 1 ;
 

Lrow = dw_insert.insertrow(0)

// 기본자료를 Setting
dw_insert.setitem(Lrow, "imhist_sabu",  	 gs_sabu)
dw_insert.setitem(Lrow, "imhist_iogbn", 	 sIogbn)
dw_insert.setitem(Lrow, "imhist_sudat", 	 f_today())
dw_insert.setitem(Lrow, "imhist_opseq", 	 sOpseq)
dw_insert.setitem(Lrow, "imhist_depot_no", sDepot)
dw_insert.setitem(Lrow, "imhist_pdtgu", 	 sPdtgu)
dw_insert.setitem(Lrow, "imhist_insdat", 	 sSidat)
dw_insert.setitem(Lrow, "imhist_io_date",  sSidat)
dw_insert.setitem(Lrow, "imhist_filsk",  	 'Y')
dw_insert.setitem(Lrow, "imhist_bigo",  	 '생산출고수동생성')
dw_insert.setitem(Lrow, "imhist_jakjino",  sPordno)
dw_insert.setitem(Lrow, "imhist_jaksino",  shpjpno)
dw_insert.setitem(Lrow, "imhist_jnpcrt",   '013')
dw_insert.setitem(Lrow, "imhist_outchk",   'N')
dw_insert.setitem(Lrow, "imhist_ioredept", sDptno)

dw_insert.scrolltorow(Lrow)
dw_insert.setcolumn("imhist_itnbr")
dw_insert.setfocus()
end event

type p_exit from w_inherite`p_exit within w_pdt_02120
integer x = 3282
integer y = 16
end type

type p_can from w_inherite`p_can within w_pdt_02120
integer x = 3109
integer y = 16
end type

event p_can::clicked;call super::clicked;dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.retrieve(gs_sabu, shpjpno)
dw_insert.setredraw(True)
end event

type p_print from w_inherite`p_print within w_pdt_02120
boolean visible = false
integer x = 1742
integer y = 1880
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdt_02120
boolean visible = false
integer x = 1915
integer y = 1880
boolean enabled = false
end type

type p_del from w_inherite`p_del within w_pdt_02120
integer x = 2935
integer y = 16
end type

event p_del::clicked;call super::clicked;String sName
Long   Lrow

Lrow 	= dw_insert.getrow()
if Lrow < 1 then return

IF not isnull(dw_insert.getitemstring(Lrow, "imhist_hold_no")) then
	Messagebox("삭제불가", "할당에 의한 출고자료는 조정할 수 없읍니다", stopsign!)
	return
end if

sName	= dw_insert.getitemstring(Lrow, "itemas_itdsc")
If isnull(sName) or trim(sName) = '' then
	dw_insert.Deleterow(Lrow)
Else
	If Messagebox("삭제확인", "삭제하시겠읍니까?", question!, yesno!, 2) = 1 then
		dw_insert.Deleterow(Lrow)
	end if
end if


end event

type p_mod from w_inherite`p_mod within w_pdt_02120
integer x = 2761
integer y = 16
end type

event p_mod::clicked;call super::clicked;if dw_insert.accepttext() = -1 then return

if wf_requiredchk() = -1 then 
	rollback;
	return
end if

if dw_insert.update() = -1 then
	Rollback;
	f_rollback()
else
	Commit;
	ib_any_typing = false
	p_exit.triggerevent(clicked!)
end if

end event

type cb_exit from w_inherite`cb_exit within w_pdt_02120
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02120
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02120
end type

type cb_del from w_inherite`cb_del within w_pdt_02120
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02120
integer x = 1490
integer y = 2572
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_pdt_02120
integer x = 1851
integer y = 2572
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_02120
integer y = 2088
end type

type cb_can from w_inherite`cb_can within w_pdt_02120
end type

type cb_search from w_inherite`cb_search within w_pdt_02120
integer x = 2213
integer y = 2572
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_pdt_02120
integer y = 2088
end type

type sle_msg from w_inherite`sle_msg within w_pdt_02120
integer y = 2088
end type

type gb_10 from w_inherite`gb_10 within w_pdt_02120
integer y = 2036
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02120
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02120
end type

type dw_hidden from datawindow within w_pdt_02120
boolean visible = false
integer x = 658
integer y = 4
integer width = 1769
integer height = 176
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_pstruc_popup_1_1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_pdt_02120
integer x = 46
integer y = 16
integer width = 402
integer height = 132
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "BOM 조회"
end type

event clicked;Long Lrow, k
String sIogbn, sDepot, sdptno, sPdtgu, sSidat, sPordno, sOpseq, sItnbr, sopt

/* 자동출고시에는 할당의 수불구분을 이용하지 않고 iomatrix의 자동출고를 이용하여 설정 */
select iogbn into :sIogbn from iomatrix where sabu = :gs_sabu and autbacp = 'Y';
If sqlca.sqlcode <> 0 then
	Messagebox("출고구분", "IOMATRIX에서 자동출고를 검색할 수 없읍니다", stopsign!)
	return
end if

/* 생산실적에서 실적일자를 검색 */
Select a.sidat, a.pordno, a.opsno
  Into :sSidat, :sPordno, :sOpseq
  from shpact a
 where a.sabu  = :gs_sabu and a.shpjpno = :shpjpno;
 
If sqlca.sqlcode <> 0 then
	Messagebox("작업일보", "생산실적 내역을 검색할 수 없읍니다", stopsign!)
	return
end if 

/* 해당생산팀에 대한 기본창고를 검색 */
Select a.pdtgu, a.itnbr
  Into :sPdtgu, :sItnbr
  from momast a
 where a.sabu  = :gs_sabu and a.pordno = :sPordno;
 
If sqlca.sqlcode <> 0 then
	Messagebox("작업지시", "작업지시 내역을 검색할 수 없읍니다", stopsign!)
	return
end if

// 창고(생산) : 자재창고 없음
select cvcod, deptcode into :sdepot, :sdptno 
  from vndmst 
 where cvgu = '5' and jumaechul = '1' and ipjogun = :gs_saupj and jumaeip = :spdtgu and rownum = 1 ;

/////////////////////////////////////////////////////////////////
gs_gubun = sItnbr
Open(w_pstruc_popup_1)
if Isnull(gs_code) or Trim(gs_code) = "" then return

SetPointer(HourGlass!)

dw_hidden.reset()
dw_hidden.ImportClipboard()
/////////////////////////////////////////////////////////////////

FOR k=1 TO dw_hidden.rowcount()
	sopt = dw_hidden.getitemstring(k, 'opt')
	if 	sopt = 'Y' then 
		Lrow = dw_insert.insertrow(9999)
		
		// 기본자료를 Setting
		dw_insert.setitem(Lrow, "imhist_sabu",  	 gs_sabu)
		dw_insert.setitem(Lrow, "imhist_iogbn", 	 sIogbn)
		dw_insert.setitem(Lrow, "imhist_sudat", 	 f_today())
		dw_insert.setitem(Lrow, "imhist_opseq", 	 sOpseq)
		dw_insert.setitem(Lrow, "imhist_depot_no", sDepot)
		dw_insert.setitem(Lrow, "imhist_pdtgu", 	 sPdtgu)
		dw_insert.setitem(Lrow, "imhist_insdat", 	 sSidat)
		dw_insert.setitem(Lrow, "imhist_io_date",  sSidat)
		dw_insert.setitem(Lrow, "imhist_filsk",  	 'Y')
		dw_insert.setitem(Lrow, "imhist_bigo",  	 '생산출고수동생성')
		dw_insert.setitem(Lrow, "imhist_jakjino",  sPordno)
		dw_insert.setitem(Lrow, "imhist_jaksino",  shpjpno)
		dw_insert.setitem(Lrow, "imhist_jnpcrt",   '013')
		dw_insert.setitem(Lrow, "imhist_outchk",   'N')
		dw_insert.setitem(Lrow, "imhist_ioredept", sDptno)
		
		dw_insert.SetItem(Lrow, 'imhist_itnbr', dw_hidden.GetItemString(k, 'itnbr'))
		dw_insert.SetItem(Lrow, 'itemas_itdsc', dw_hidden.GetItemString(k, 'itemas_itdsc'))
		dw_insert.SetItem(Lrow, 'itemas_ispec', dw_hidden.GetItemString(k, 'itemas_ispec'))
		dw_insert.SetItem(Lrow, 'itemas_jijil', dw_hidden.GetItemString(k, 'itemas_jijil'))
	end if
Next

dw_insert.scrolltorow(Lrow)
dw_insert.setcolumn("imhist_itnbr")
dw_insert.setfocus()


dw_hidden.reset()
end event

type rr_1 from roundrectangle within w_pdt_02120
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 172
integer width = 3419
integer height = 1452
integer cornerheight = 40
integer cornerwidth = 55
end type

