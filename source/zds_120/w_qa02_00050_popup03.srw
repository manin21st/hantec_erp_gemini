$PBExportHeader$w_qa02_00050_popup03.srw
$PBExportComments$** 이상발생처리 - 소재불량판정
forward
global type w_qa02_00050_popup03 from window
end type
type p_1 from picture within w_qa02_00050_popup03
end type
type st_3 from statictext within w_qa02_00050_popup03
end type
type st_2 from statictext within w_qa02_00050_popup03
end type
type dw_2 from datawindow within w_qa02_00050_popup03
end type
type p_del from picture within w_qa02_00050_popup03
end type
type p_ins from picture within w_qa02_00050_popup03
end type
type p_exit from picture within w_qa02_00050_popup03
end type
type p_mod from picture within w_qa02_00050_popup03
end type
type st_1 from statictext within w_qa02_00050_popup03
end type
type dw_1 from datawindow within w_qa02_00050_popup03
end type
type cb_exit from commandbutton within w_qa02_00050_popup03
end type
type cb_delete from commandbutton within w_qa02_00050_popup03
end type
type cb_insert from commandbutton within w_qa02_00050_popup03
end type
type cb_save from commandbutton within w_qa02_00050_popup03
end type
type dw_list from datawindow within w_qa02_00050_popup03
end type
type rr_2 from roundrectangle within w_qa02_00050_popup03
end type
type rr_1 from roundrectangle within w_qa02_00050_popup03
end type
end forward

global type w_qa02_00050_popup03 from window
integer x = 379
integer y = 312
integer width = 4233
integer height = 1992
boolean titlebar = true
string title = "수정 불합격 처리 [불량소재등록]"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_1 p_1
st_3 st_3
st_2 st_2
dw_2 dw_2
p_del p_del
p_ins p_ins
p_exit p_exit
p_mod p_mod
st_1 st_1
dw_1 dw_1
cb_exit cb_exit
cb_delete cb_delete
cb_insert cb_insert
cb_save cb_save
dw_list dw_list
rr_2 rr_2
rr_1 rr_1
end type
global w_qa02_00050_popup03 w_qa02_00050_popup03

type variables
char c_status

// 자료변경여부 검사
Boolean ib_any_typing 

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

str_qct_01040 str_01040
str_qa01_00020 str_00020

Datawindow  idw_imhfat
end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
public subroutine wf_initial ()
public function integer wf_checkrequiredfield ()
end prototypes

public function integer wf_warndataloss (string as_titletext);/*===================================================================
 1. window-level user function : 종료, 등록, 조회시 호출됨
    dw_detail, dw_list 의 typing(datawindow) 변경사항 검사

 2. 계속진행할 경우 변경사항이 저장되지 안음을 경고                                                               

 3. Argument:  as_titletext (warning messagebox)                                                                          
    Return values:                                                   
                                                                  
      *  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
		* -1 : 진행을 중단할 경우.                      
=====================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : " + as_titletext , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		dw_list.SetFocus()						// yes 일 경우: focus 'dw_detail' 
		RETURN -1									

	END IF

END IF
																
RETURN 1																// (dw_detail) 에 변경사항이 없거나 no일 경우
																		// 변경사항을 저장하지 않고 계속진행 


end function

public subroutine wf_initial ();//
//string	sDateFrom,	&
//			sDateTo,		&
//			sRemark,		&
//			sRemark2, sItnbr, sGrpno1, sIttyp, sjijil, sispec_code 
//			
//		
///* 기본내역 */
//dw_1.Reset()
//dw_1.insertrow(0)
//dw_1.setitem(1, "iojpno", str_00020.iojpno)
//dw_1.setitem(1, "itnbr",  str_00020.itnbr)
//dw_1.setitem(1, "itdsc",  str_00020.itdsc)
//dw_1.setitem(1, "ispec",  str_00020.ispec)
//dw_1.setitem(1, "ioqty",  str_00020.ioqty)
//dw_1.setitem(1, "buqty",  str_00020.buqty)
//
///* 검사항목 */
//sItnbr = str_00020.itnbr;
//
//Select a.ittyp, b.grpno1, a.jijil, a.ispec_code 
//  into :sIttyp, :sgrpno1, :sjijil, :sispec_code 
//  from itemas a,  itemas_inspection b
// where a.itnbr = :sItnbr and a.itnbr = b.itnbr;
//
//dw_1.setitem(1, "ittyp",  sIttyp)
//dw_1.setitem(1, "insgbn", sGrpno1)
//dw_1.setitem(1, "jijil",  sjijil)
//dw_1.setitem(1, "ispec_code", sispec_code)
//
///* 검사상세항목 */
//datawindowchild dws1
//dw_list.getchild("bulcod", dws1)
//dws1.settransobject(sqlca)
//
//if dws1.retrieve('%')	  < 1 then
////	Messagebox("검사항목", "품목에 대한 검사항목이 없읍니다" + '~n' + &
////								  "전체검사항목이 출력됩니다")
//	dws1.retrieve('%')
//end if
//
//dw_list.Retrieve(gs_sabu, str_00020.iojpno)
//
//
end subroutine

public function integer wf_checkrequiredfield ();long		lrow, lqty, lsumqty1, lsumqty2
string	sitnbr, scvcod, sapear, scause 

FOR lRow = 1	TO		dw_list.RowCount()
	
	// 소재품번
	sitnbr = dw_list.getitemstring(lrow,'itnbr')
	if isnull(sitnbr) or sitnbr = '' then
		f_message_chk(30,'[소재품번]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("itnbr")
		dw_list.setfocus()
		return -1
	end if
	
	// 공급업체
	scvcod = dw_list.getitemstring(lrow,'cvcod')
	if isnull(scvcod) or scvcod = '' then
		f_message_chk(30,'[공급업체]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("cvcod")
		dw_list.setfocus()
		return -1
	end if

	// 현상코드
	sapear = dw_list.getitemstring(lrow,'hcode')
	if isnull(sapear) or sapear = '' then
		f_message_chk(30,'[현상코드]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("hcode")
		dw_list.setfocus()
		return -1
	end if
	
	// 원인코드
	scause = dw_list.getitemstring(lrow,'wcode')
	if isnull(scause) or scause = '' then
		f_message_chk(30,'[원인코드]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("wcode")
		dw_list.setfocus()
		return -1
	end if
	
	// 불량수량
	lqty = dw_list.Getitemnumber(lRow, "qaqty")
	if isnull(lqty) or lqty <= 0 then
		f_message_chk(30,'[불량수량]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("qaqty")
		dw_list.setfocus()
		return -1
	end if
NEXT

lsumqty1 = dw_2.Getitemnumber(1, "sum_qty")
lsumqty2 = dw_list.Getitemnumber(1, "sum_qty")

if lsumqty2 > lsumqty1 then
	messagebox('확인','품질판정수량이 생산판정수량을 초과합니다')
	return -1
end if

RETURN 1
end function

event open;f_window_center_response(This)

/* 검사상세항목 */
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)	

dw_1.retrieve(gs_sabu,gs_code)
dw_2.retrieve(gs_sabu,gs_code)
dw_list.retrieve(gs_sabu,gs_code)
end event

on w_qa02_00050_popup03.create
this.p_1=create p_1
this.st_3=create st_3
this.st_2=create st_2
this.dw_2=create dw_2
this.p_del=create p_del
this.p_ins=create p_ins
this.p_exit=create p_exit
this.p_mod=create p_mod
this.st_1=create st_1
this.dw_1=create dw_1
this.cb_exit=create cb_exit
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.cb_save=create cb_save
this.dw_list=create dw_list
this.rr_2=create rr_2
this.rr_1=create rr_1
this.Control[]={this.p_1,&
this.st_3,&
this.st_2,&
this.dw_2,&
this.p_del,&
this.p_ins,&
this.p_exit,&
this.p_mod,&
this.st_1,&
this.dw_1,&
this.cb_exit,&
this.cb_delete,&
this.cb_insert,&
this.cb_save,&
this.dw_list,&
this.rr_2,&
this.rr_1}
end on

on w_qa02_00050_popup03.destroy
destroy(this.p_1)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_2)
destroy(this.p_del)
destroy(this.p_ins)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.cb_exit)
destroy(this.cb_delete)
destroy(this.cb_insert)
destroy(this.cb_save)
destroy(this.dw_list)
destroy(this.rr_2)
destroy(this.rr_1)
end on

type p_1 from picture within w_qa02_00050_popup03
integer x = 3205
integer y = 76
integer width = 178
integer height = 144
string picturename = "C:\erpman\image\BOM조회.gif"
boolean focusrectangle = false
end type

event clicked;long		ll_row
string	snull

ll_row = dw_list.GetRow()
If ll_row < 1 Then Return

IF dw_list.GetColumnName() = "itnbr" THEN
	gs_gubun = Trim(dw_1.getitemstring(1,'itnbr'))

	Open(w_qa02_00050_popup01)
	
	IF isnull(gs_Code)  or  gs_Code = '' or &
	   isnull(gs_Codename)  or  gs_Codename = '' then 
		dw_list.setitem(ll_row,'itnbr',snull)
		dw_list.setitem(ll_row,'itdsc',snull)
		dw_list.setitem(ll_row,'cvcod',snull)
		dw_list.setitem(ll_row,'cvnas',snull)
		return
	End If
	
	String ls_itdsc, ls_cvnas
	
	SELECT B.ITDSC, C.CVNAS2
	  Into :ls_itdsc, :ls_cvnas 
	  FROM DANMST A, ITEMAS B, VNDMST C
	 WHERE A.ITNBR = :gs_code
	   AND A.CVCOD = :gs_codename
		AND A.ITNBR = B.ITNBR
		AND A.CVCOD = C.CVCOD ;

	If SQLCA.SQLCODE <> 0 Then
		f_message_chk(33,'')
	Else
		dw_list.setitem(ll_row,'itnbr',gs_code)
		dw_list.setitem(ll_row,'itdsc',ls_itdsc)
		dw_list.setitem(ll_row,'cvcod',gs_codename)
		dw_list.setitem(ll_row,'cvnas',ls_cvnas)
	End If
END IF
end event

type st_3 from statictext within w_qa02_00050_popup03
integer x = 1175
integer y = 296
integer width = 320
integer height = 56
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 28144969
long backcolor = 32106727
string text = "품질판정"
boolean focusrectangle = false
end type

type st_2 from statictext within w_qa02_00050_popup03
integer x = 32
integer y = 296
integer width = 320
integer height = 56
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 28144969
long backcolor = 32106727
string text = "생산판정"
boolean focusrectangle = false
end type

type dw_2 from datawindow within w_qa02_00050_popup03
integer x = 27
integer y = 380
integer width = 1088
integer height = 1416
integer taborder = 30
string title = "none"
string dataobject = "d_qa02_00050_popup03_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type p_del from picture within w_qa02_00050_popup03
integer x = 3726
integer y = 76
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean focusrectangle = false
end type

event clicked;long	lrow

lRow = dw_list.GetRow()
IF lRow < 1	THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN

dw_list.DeleteRow(lRow)

IF dw_list.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
	Return
Else
	Commit ;
END IF
end event

type p_ins from picture within w_qa02_00050_popup03
integer x = 3552
integer y = 76
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\추가_up.gif"
boolean focusrectangle = false
end type

event clicked;long	lRow
lRow = dw_list.InsertRow(0)

dw_list.ScrollToRow(lRow)
dw_list.SetColumn("hcode")
dw_list.SetFocus()




end event

type p_exit from picture within w_qa02_00050_popup03
integer x = 3899
integer y = 76
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event clicked;decimal	dsumqty

dsumqty = dw_list.Getitemdecimal(1,"sum_qty")
CloseWithReturn(parent,dsumqty)
end event

type p_mod from picture within w_qa02_00050_popup03
integer x = 3378
integer y = 76
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event clicked;IF dw_list.AcceptText() = -1 THEN RETURN 
if dw_2.rowcount() < 1 then return
IF	wf_CheckRequiredField() = -1	THEN	RETURN
If f_msg_update() < 1 Then Return

long		lrow
string	sabu, sjpno, sitnbr

sabu	= dw_2.getitemstring(1,'sabu')
sjpno	= dw_2.getitemstring(1,'shpjpno')

FOR lrow = 1 TO dw_list.rowcount()
	dw_list.setitem(lrow,'sabu',sabu)
	dw_list.setitem(lrow,'shpjpno',sjpno)
	dw_list.setitem(lrow,'cdate',f_today())
NEXT
	

////////////////////////////////////////////////////////////////////////
IF dw_list.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
Else
	Commit ;
END IF

ib_any_typing = False
p_exit.TriggerEvent(Clicked!)
end event

type st_1 from statictext within w_qa02_00050_popup03
boolean visible = false
integer x = 1001
integer y = 2000
integer width = 1225
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 79741120
boolean enabled = false
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_qa02_00050_popup03
integer width = 2971
integer height = 264
integer taborder = 10
string dataobject = "d_qa02_00050_popup03_1"
boolean border = false
boolean livescroll = true
end type

type cb_exit from commandbutton within w_qa02_00050_popup03
boolean visible = false
integer x = 2702
integer y = 1980
integer width = 329
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;If Messagebox("불량요인", "해당 전표에 대한 불량내역은 자동으로 삭제됩니다" + '~n' + &
								  "계속하시겠읍니까?", question!, yesno!) = 2 then
	Return										  
end if

SetPointer(HourGlass!)

String iojpno
Long   lrow
Datawindow dwname

iojpno = str_01040.iojpno
Lrow	 = str_01040.rowno
dwname = str_01040.dwname
/* 불량 및 조건부 내역 */
Delete from imhfat
 Where sabu = :gs_sabu and iojpno = :iojpno;

IF sqlca.sqlcode < 0		THEN
	ROLLBACK;
	f_Rollback()
	close(parent)
END IF

/* 입고이력에 불량,조건부를 0로 setting */
dwname.setitem(lrow, "imhist_iofaqty", 0)
dwname.setitem(lrow, "imhist_iocdqty", 0)

if str_01040.gubun = 'Y' then  //수입검사에서 open한 경우만 공제와 변환쪽에 0 셋팅
	dwname.setitem(lrow, "imhist_cnviofa", 0)
	dwname.setitem(lrow, "imhist_cnviocd", 0)
	dwname.setitem(lrow, "imhist_gongqty", 0)
	dwname.setitem(lrow, "imhist_cnvgong", 0)
	dwname.setitem(lrow, "imhist_gongprc", 0)
end if

/* 원자재 이상 통지 내역 */
Delete from imhfag
 Where sabu = :gs_sabu and iojpno = :iojpno; 

IF sqlca.sqlcode < 0		THEN
	ROLLBACK;
	f_Rollback()
END IF

SetPointer(Arrow!)
 
close(parent)

end event

type cb_delete from commandbutton within w_qa02_00050_popup03
boolean visible = false
integer x = 489
integer y = 1980
integer width = 407
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "행삭제(&L)"
end type

event clicked;long	lrow
lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN
	
dw_list.DeleteRow(0)




end event

type cb_insert from commandbutton within w_qa02_00050_popup03
boolean visible = false
integer x = 64
integer y = 1980
integer width = 407
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "행추가(&A)"
end type

event clicked;
IF f_CheckRequired(dw_list) = -1	THEN	RETURN


//////////////////////////////////////////////////////////////////////////
long	lRow
lRow = dw_list.InsertRow(0)

dw_list.setitem(lrow, "silyoq", str_01040.siqty)
dw_list.ScrollToRow(lRow)
dw_list.SetColumn("bulcod")
dw_list.SetFocus()


end event

type cb_save from commandbutton within w_qa02_00050_popup03
boolean visible = false
integer x = 2350
integer y = 1980
integer width = 329
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;SetPointer(HourGlass!)

if str_01040.buqty > 0 or str_01040.joqty > 0 then
	if dw_list.rowcount() = 0 then
		MessageBox("확인", "자료를 입력하시기 바랍니다.")
		dw_list.SetFocus()
		RETURN
	END IF	
end if

IF dw_list.AcceptText() = -1 THEN RETURN 

IF	wf_CheckRequiredField() = -1		THEN		RETURN

dec{3} dSum_Qty

IF dw_list.RowCount() > 0	THEN
	dSum_Qty = dw_list.GetItemDecimal(1, "buqty")
	if str_01040.buqty > 0 then
		IF dSum_qty < 1	THEN
			MessageBox("확인", "불량수량은 0이상이어야 합니다.")
			dw_list.SetFocus()
			RETURN
		END IF
	end if
	
	dSum_Qty = dw_list.GetItemDecimal(1, "joqty")	
	IF dSum_qty <> str_01040.joqty	THEN
		MessageBox("확인", "조건부수량이 같지 않습니다.")
		dw_list.SetFocus()
		RETURN
	END IF	

END IF

IF f_msg_update() = -1 	THEN	RETURN

st_1.TEXT = '자료를 저장중.......'

////////////////////////////////////////////////////////////////////////
IF dw_list.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
END IF

SetPointer(Arrow!)

close(parent)

/////////////////////////////////////////////////////////////////////////


end event

type dw_list from datawindow within w_qa02_00050_popup03
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 1170
integer y = 380
integer width = 3003
integer height = 1416
integer taborder = 20
string dataobject = "d_qa02_00050_popup03_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;
RETURN 1
end event

on editchanged; ib_any_typing = true
end on

event rowfocuschanged;//this.setrowfocusindicator ( HAND! )
end event

event itemchanged;Long		ll_row 
String	scode, sname, snull

ll_row = this.GetRow()
If ll_row < 1 Then Return

setnull(snull)

// 소재품번
IF this.GetColumnName() = 'itnbr' THEN
	scode = this.gettext()
	
	select itdsc into :sname from itemas
	 where itnbr = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(ll_row,'itdsc',sname)
	else
		this.setitem(ll_row,'itnbr',snull)
		this.setitem(ll_row,'itdsc',snull)
		return 1
	end if

// 공급업체
ELSEIF this.GetColumnName() = 'cvcod' THEN
	scode = this.gettext()
	
	select cvnas into :sname from vndmst
	 where cvcod = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(ll_row,'cvnas',sname)
	else
		this.setitem(ll_row,'cvcod',snull)
		this.setitem(ll_row,'cvnas',snull)
		return 1
	end if

END IF
end event

event rbuttondown;Long	ll_row 

ll_row = this.GetRow()
If ll_row < 1 Then Return

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

// 품번
IF this.GetColumnName() = 'itnbr' THEN
	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	
	this.SetItem(ll_row,'itnbr',gs_code)
	this.TriggerEvent(itemchanged!)

// 공급업체
ELSEIF this.GetColumnName() = 'cvcod' THEN
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(ll_row,'cvcod',gs_code)
	this.TriggerEvent(itemchanged!)

END IF
end event

type rr_2 from roundrectangle within w_qa02_00050_popup03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1161
integer y = 372
integer width = 3022
integer height = 1436
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_qa02_00050_popup03
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 372
integer width = 1106
integer height = 1436
integer cornerheight = 40
integer cornerwidth = 55
end type

