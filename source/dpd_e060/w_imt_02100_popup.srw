$PBExportHeader$w_imt_02100_popup.srw
$PBExportComments$외주발주검토-자료를 여러건으로 분할
forward
global type w_imt_02100_popup from window
end type
type st_1 from statictext within w_imt_02100_popup
end type
type dw_1 from datawindow within w_imt_02100_popup
end type
type cb_insert from commandbutton within w_imt_02100_popup
end type
type cb_close from commandbutton within w_imt_02100_popup
end type
type cb_cancel from commandbutton within w_imt_02100_popup
end type
type cb_delete from commandbutton within w_imt_02100_popup
end type
type cb_update from commandbutton within w_imt_02100_popup
end type
type dw_list from datawindow within w_imt_02100_popup
end type
type gb_2 from groupbox within w_imt_02100_popup
end type
type gb_1 from groupbox within w_imt_02100_popup
end type
end forward

global type w_imt_02100_popup from window
integer x = 823
integer y = 360
integer width = 2546
integer height = 1288
boolean titlebar = true
string title = "외주의뢰 분할조정"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
st_1 st_1
dw_1 dw_1
cb_insert cb_insert
cb_close cb_close
cb_cancel cb_cancel
cb_delete cb_delete
cb_update cb_update
dw_list dw_list
gb_2 gb_2
gb_1 gb_1
end type
global w_imt_02100_popup w_imt_02100_popup

type variables
string   is_estno             //의뢰번호
string   is_cnvart            //변환연산자
dec {6}     id_cnvfat       //변환계수

string is_pspec , is_jijil
end variables

forward prototypes
public function integer wf_required_chk (integer i)
end prototypes

public function integer wf_required_chk (integer i);if isnull(dw_list.GetItemString(i,'cvcod')) or &
	dw_list.GetItemString(i,'cvcod') = "" then
	f_message_chk(1400,'[ '+string(i)+' 행  거래처]')
	dw_list.ScrollToRow(i)
	dw_list.SetColumn('cvcod')
	dw_list.SetFocus()
	return -1		
end if	

if isnull(dw_list.GetItemDecimal(i,'vnqty')) or &
	dw_list.GetItemDecimal(i,'vnqty') = 0 then
	f_message_chk(1400,'[ '+string(i)+' 행  분할수량]')
	dw_list.ScrollToRow(i)
	dw_list.SetColumn('vnqty')
	dw_list.SetFocus()
	return -1		
end if	

Return 1

end function

on w_imt_02100_popup.create
this.st_1=create st_1
this.dw_1=create dw_1
this.cb_insert=create cb_insert
this.cb_close=create cb_close
this.cb_cancel=create cb_cancel
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.dw_list=create dw_list
this.gb_2=create gb_2
this.gb_1=create gb_1
this.Control[]={this.st_1,&
this.dw_1,&
this.cb_insert,&
this.cb_close,&
this.cb_cancel,&
this.cb_delete,&
this.cb_update,&
this.dw_list,&
this.gb_2,&
this.gb_1}
end on

on w_imt_02100_popup.destroy
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.cb_insert)
destroy(this.cb_close)
destroy(this.cb_cancel)
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.dw_list)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()		
end choose


end event

event open;is_estno  = gs_code

f_window_center_response(this)

dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)

cb_cancel.TriggerEvent(Clicked!)


end event

type st_1 from statictext within w_imt_02100_popup
integer x = 78
integer y = 912
integer width = 1723
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_imt_02100_popup
integer x = 78
integer y = 16
integer width = 2409
integer height = 424
integer taborder = 10
string dataobject = "d_imt_02100_popup"
boolean border = false
boolean livescroll = true
end type

type cb_insert from commandbutton within w_imt_02100_popup
integer x = 73
integer y = 1048
integer width = 329
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

event clicked;long curr_row, i

if dw_list.AcceptText() = -1 then Return 

FOR i = 1 TO dw_list.RowCount()
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

curr_row = dw_list.insertrow(0)
dw_list.setitem(curr_row, 'cvcod', dw_1.getitemstring(1, 'cvcod'))
dw_list.setitem(curr_row, 'cvnm', dw_1.getitemstring(1, 'vndmst_cvnas2'))
dw_list.setitem(curr_row, 'tuncu', dw_1.getitemstring(1, 'tuncu'))
dw_list.setitem(curr_row, 'nadate', dw_1.getitemstring(1, 'yodat'))
dw_list.setitem(curr_row, 'unprc', dw_1.getitemDecimal(1, 'unprc'))
dw_list.setitem(curr_row, 'cnvprc', dw_1.getitemDecimal(1, 'cnvprc'))

dw_list.scrolltorow(curr_row)
dw_list.setcolumn('cvcod')
dw_list.setfocus()

end event

type cb_close from commandbutton within w_imt_02100_popup
integer x = 2130
integer y = 1048
integer width = 329
integer height = 100
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "닫기(&X)"
end type

event clicked;setnull(gs_code)

CLOSE(PARENT)
end event

type cb_cancel from commandbutton within w_imt_02100_popup
integer x = 1792
integer y = 1048
integer width = 329
integer height = 100
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;if dw_1.retrieve(gs_sabu, is_estno) < 0 then 
	messagebox('확 인', '구매의뢰자료가 없습니다. 의뢰번호를 확인하세요!')
	cb_update.enabled = false
else
	id_cnvfat = dw_1.GetItemDecimal(1, 'cnvfat')
	is_cnvart = dw_1.GetItemString(1, 'cnvart')
	cb_update.enabled = true
end if 

dw_list.reset() 	
dw_list.setcolumn('cvcod')
dw_list.setfocus()

end event

type cb_delete from commandbutton within w_imt_02100_popup
integer x = 411
integer y = 1048
integer width = 329
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&D)"
end type

event clicked;long 	curr_row

curr_row = dw_list.getrow()

if curr_row > 0  then
   dw_list.deleterow(curr_row)
	dw_list.setcolumn('cvcod')
	dw_list.setfocus()
end if

end event

type cb_update from commandbutton within w_imt_02100_popup
integer x = 1454
integer y = 1048
integer width = 329
integer height = 100
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;int i, lCount

lCount = dw_list.RowCount()

if lCount < 1 then return 

if dw_list.AcceptText() = -1 then return -1

FOR i = 1 TO lCount
	IF wf_required_chk(i) = -1 THEN RETURN
NEXT

IF MessageBox("확인", "의뢰자료를 분할 처리 하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

gs_code = 'YES'
SetPointer(HourGlass!)
// Copy the data to the clipboard
dw_list.SaveAs("", Clipboard!, False)
Close(Parent)


end event

type dw_list from datawindow within w_imt_02100_popup
event ue_enterkey pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 37
integer y = 452
integer width = 2464
integer height = 440
integer taborder = 10
string dataobject = "d_imt_02100_popup2"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enterkey;Send( Handle(this), 256, 9, 0 )
Return 1

end event

event ue_key;setnull(gs_code)
setnull(gs_codename)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF this.GetColumnName() = 'cvcod'	THEN
		
		gs_gubun = '1'
		
		Open(w_vndmst_popup)
	
      if gs_code = '' or isnull(gs_code) then return 		
	
		SetItem(this.getrow(),"cvcod",gs_code)

		this.TriggerEvent("itemchanged")
		
	END IF
END IF
end event

event itemerror;return 1
end event

event itemchanged;string sdate, snull, scode, sitem, sopseq, sname, stuncu
long   lrow
dec {5}	dPrice
dec {3}	dQty, doldqty, dtotqty, dvnqty

setnull(snull)
lrow = this.getrow()
dw_1.accepttext()

IF this.GetColumnName() = "cvcod" THEN
	
	sCode  = this.GetText()								
	
	sItem  = dw_1.GetItemString(1, "itnbr")
	sOpseq = dw_1.GetItemString(1, "opseq")	
    
	if sCode = "" or isnull(sCode) then 
		this.setitem(lRow, "cvnm", snull)		
		return 
	end if

	/* 거래처 확인 */
   SELECT A.CVNAS2
     INTO :sName
     FROM VNDMST A
    WHERE A.CVCOD = :sCode
	 	AND A.CVGU IN ('1','2','9'); 
		 
	IF SQLCA.SQLCODE <> 0 THEN
		F_MESSAGE_CHK(33, '[거래처]')
		this.setitem(lRow, "cvcod", snull)		
		this.setitem(lRow, "cvnm", snull)		
		this.setitem(lRow, "unprc", 0)		
		this.setitem(lrow, "tuncu", 'WON')
		RETURN 1
	END IF
	
	this.setitem(lRow, "cvnm", sname)		
	
	dprice = 0
	stuncu = 'WON'
			 
	/* 단가내역 확인 */
   SELECT NVL(B.UNPRC, 0), cunit
     INTO :dPrice, :sTuncu
     FROM DANMST B 
    WHERE B.ITNBR	   = :sItem 
	 	AND B.OPSEQ    = :sopseq
	 	AND B.CVCOD 	= :sCode ; 

	this.setitem(lRow, "cnvprc", DPRICE)
	this.setitem(lrow, "tuncu", stuncu)
	
	// 발주예정단가 변환
	if id_cnvfat = 1   then
		dw_list.setitem(lrow, "unprc", dprice)
	elseif is_cnvart = '/' then
		dw_list.setitem(Lrow, "unprc", round(dprice / id_cnvfat,5))
	else
		dw_list.setitem(Lrow, "unprc", round(dprice * id_cnvfat,5))
	end if	

// 단가
elseif this.getcolumnname() = 'unprc' then
	dprice = dec(this.gettext())
	// 발주예정단가 변환
	if id_cnvfat = 1   then
		dw_list.setitem(lrow, "cnvprc", dprice)
	elseif is_cnvart = '/' then
		dw_list.setitem(Lrow, "cnvprc", round(dprice * id_cnvfat,5))
	else
		dw_list.setitem(Lrow, "cnvprc", round(dprice / id_cnvfat,5))
	end if		
ELSEIF this.getcolumnname() = 'vnqty' then
   dQty = dec(this.GetText())
   doldQty = this.GetItemDecimal(lrow, "vnqty")
	this.accepttext()
  	dtotqty = this.GetItemDecimal(1, "tot_qty")
  	dvnqty  = dw_1.GetItemDecimal(1, "vnqty")
	
	if isnull(dQty) then dQty = 0

   if dtotqty >= dvnqty then 
		messagebox('확 인', '분할수량 TOTAL이 예정수량보다 크거나 같을 수 없습니다.' + &
		                    '분할수량을 확인하세요!')
		this.setitem(Lrow, "vnqty", doldqty)			
      return 1
	end if	
	// 업체발주예정량 변경
	if id_cnvfat = 1   then
		this.setitem(Lrow, "cnvqty", dQty)
	elseif is_cnvart = '/'  then
		IF dQty = 0 then
			this.setitem(Lrow, "cnvqty", 0)			
		else
			this.setitem(Lrow, "cnvqty", ROUND(dQty / id_cnvfat, 3))
		end if
	else
		IF dQty = 0 then
			this.setitem(Lrow, "cnvqty", 0)			
		else
			this.setitem(Lrow, "cnvqty", ROUND(dQty * id_cnvfat, 3))
		end if
	end if
ELSEIF this.GetColumnName() = "nadate" THEN
	sdate = Trim(this.Gettext())
	IF sdate ="" OR IsNull(sdate) THEN RETURN
	
	IF f_datechk(sdate) = -1 THEN
		f_message_chk(35,'[납기요구일]')
		this.SetItem(lrow, "nadate", snull)
		this.Setcolumn("nadate")
		this.SetFocus()
		Return 1
	END IF
END IF
end event

event rbuttondown;long	lRow
lRow  = this.GetRow()	

IF this.GetColumnName() = 'cvcod'	THEN
	st_1.text = '일반 거래처 조회는 F2 KEY 를 누르세요!'
	
	gs_code 		= dw_1.getitemstring(1, "itnbr")
	gs_codename = dw_1.getitemstring(1, "opseq")

	Open(w_danmst_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	this.SetItem(lRow,"cvcod",gs_code)
	
	this.TriggerEvent("itemchanged")
	
END IF


end event

type gb_2 from groupbox within w_imt_02100_popup
integer x = 37
integer y = 992
integer width = 741
integer height = 188
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_imt_02100_popup
integer x = 1413
integer y = 992
integer width = 1083
integer height = 188
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

