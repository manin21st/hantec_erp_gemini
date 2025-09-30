$PBExportHeader$w_pdt_02140.srw
$PBExportComments$** 폐기승인 처리
forward
global type w_pdt_02140 from w_inherite
end type
type dw_1 from datawindow within w_pdt_02140
end type
type rr_4 from roundrectangle within w_pdt_02140
end type
type dw_2 from datawindow within w_pdt_02140
end type
type pb_1 from u_pb_cal within w_pdt_02140
end type
type pb_2 from u_pb_cal within w_pdt_02140
end type
end forward

global type w_pdt_02140 from w_inherite
string title = "폐기 승인 처리"
dw_1 dw_1
rr_4 rr_4
dw_2 dw_2
pb_1 pb_1
pb_2 pb_2
end type
global w_pdt_02140 w_pdt_02140

type variables

end variables

on w_pdt_02140.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_4=create rr_4
this.dw_2=create dw_2
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_4
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
end on

on w_pdt_02140.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_4)
destroy(this.dw_2)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_2.InsertRow(0)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.setitem(1, 'fr_date', left(is_today,6) + '01')
dw_1.setitem(1, 'to_date', is_today)
dw_1.SetFocus()

f_mod_saupj(dw_1, 'saupj')

end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_pdt_02140
integer x = 37
integer y = 300
integer width = 4571
integer height = 1848
integer taborder = 30
string dataobject = "d_pdt_02140_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String scode, sname, sname2, sopt, snull, sgub
int    ireturn, lrow

lrow = this.getrow()
setnull(snull)
dw_1.accepttext()

sgub = dw_1.getitemstring(1, 'gub')

IF this.GetColumnName() = "opt" THEN
	
	sopt = trim(this.gettext())
   if sopt = 'Y' and sgub = 'N' then
		this.setitem(lRow, "pedptno", snull)	
		this.setitem(lRow, "dptnm", snull)	
   end if		
	
ELSEIF this.GetColumnName() = "pedptno"	THEN
	scode = trim(this.gettext())

   if scode = '' or isnull(scode) then 
		this.setitem(lRow, "dptnm", snull)	
		RETURN 
	end if
		
    SELECT "VNDMST"."CVNAS2"  
      INTO :sname  
      FROM "VNDMST"  
     WHERE ( "VNDMST"."CVCOD" = :scode ) AND  
           ( "VNDMST"."CVGU" in ('1', '4') )   ;

   IF SQLCA.SQLCODE <> 0 THEN 
		MESSAGEBOX('확 인', '제공부서는 부서와 외주처만 입력가능합니다. 자료를 확인하세요!') 
		this.setitem(lRow, "pedptno", snull)	
		this.setitem(lRow, "dptnm", snull)	
		RETURN 1
	end if
		
	this.setitem(lRow, "dptnm", sname)	
END IF

end event

event dw_insert::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

IF this.GetColumnName() = "pedptno" THEN
	gs_gubun = '4' 
	
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(this.getrow(), "pedptno", gs_Code)
	this.triggerevent(itemchanged!)
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

event dw_insert::getfocus;Long Lrow
String sShpjpno


Lrow = getrow()
if getrow() > 0 then
	sShpjpno = getitemstring(Lrow, "shpjpno")	
	scrolltorow(Lrow)
	IF dw_2.retrieve(gs_sabu, sShpjpno) <= 0 THEN
		dw_2.InsertRow(0)
	END IF
End if
end event

event dw_insert::rowfocuschanged;Long Lrow
String sShpjpno

Lrow = currentrow
if getrow() > 0 then
	sShpjpno = getitemstring(Lrow, "shpjpno")	
	IF dw_2.retrieve(gs_sabu, sShpjpno) <= 0 THEN
		dw_2.InsertRow(0)
	END IF
End if
end event

event dw_insert::doubleclicked;Long Lrow
String sShpjpno

Lrow = GETROW()
if lROW > 0 then
	sShpjpno = getitemstring(Lrow, "shpjpno")	
	scrolltorow(Lrow)
	IF dw_2.retrieve(gs_sabu, sShpjpno)<= 0 THEN
		dw_2.InsertRow(0)
	END IF
End if
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02140
boolean visible = false
integer x = 4270
integer y = 2532
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02140
boolean visible = false
integer x = 4037
integer y = 2536
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdt_02140
boolean visible = false
integer x = 3442
integer y = 2524
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdt_02140
boolean visible = false
integer x = 3817
integer y = 2544
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_pdt_02140
integer taborder = 70
end type

type p_can from w_inherite`p_can within w_pdt_02140
integer taborder = 60
end type

event p_can::clicked;call super::clicked;dw_insert.setredraw(false)
dw_1.setredraw(false)

dw_insert.reset()
dw_1.reset()
dw_2.reset()

dw_insert.DataObject ="d_pdt_02140_1" 
dw_insert.SetTransObject(SQLCA)

dw_1.insertrow(0)
dw_1.setitem(1, 'fr_date', left(is_today,6) + '01')
dw_1.setitem(1, 'to_date', is_today)
dw_1.SetFocus()

dw_insert.setredraw(True)
dw_1.setredraw(True)
dw_2.InsertRow(0)
ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_pdt_02140
boolean visible = false
integer x = 3616
integer y = 2540
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdt_02140
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string s_fdate, s_tdate, s_gub, stext, spdtgu, ls_saupj

if dw_1.AcceptText() = -1 then return 

s_gub   	= trim(dw_1.GetItemString(1,'gub'))
s_fdate 	= trim(dw_1.GetItemString(1,'fr_date'))
s_tdate 	= trim(dw_1.GetItemString(1,'to_date'))
spdtgu   	= trim(dw_1.GetItemString(1,'pdtgu'))
ls_saupj  	= trim(dw_1.GetItemString(1,'saupj'))

if s_gub = 'Y' then 
	stext = '폐기승인일자'
else
	stext = '수리실적일자'
end if
	
if isnull(s_fdate) or s_fdate = "" then
	f_message_chk(30,'['+ stext +']')
	dw_1.Setcolumn('fr_date')
	dw_1.SetFocus()
	return
end if	
if isnull(s_Tdate) or s_Tdate = "" then
	f_message_chk(30,'['+ stext +']')
	dw_1.Setcolumn('to_date')
	dw_1.SetFocus()
	return
end if	
if s_fdate > s_tdate then 
	f_message_chk(34,'[' + stext + ']')
	dw_1.Setcolumn('fr_date')
	dw_1.SetFocus()
	return 
end if	

if isnull(spdtgu) or trim(spdtgu) = '' then
	spdtgu = '%'
end if

if dw_insert.Retrieve(gs_sabu, s_fdate, s_tdate, spdtgu,ls_saupj) <= 0 then 
	f_message_chk(50,'')
	dw_2.reset()
	dw_1.Setcolumn('fr_date')
	dw_1.SetFocus()
	dw_2.InsertRow(0)
end if	

dw_insert.setfocus()

//dw_insert.SetRowFocusIndicator(Hand!)
ib_any_typing = FALSE


end event

type p_del from w_inherite`p_del within w_pdt_02140
boolean visible = false
integer x = 3246
integer y = 2520
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_pdt_02140
integer x = 4096
end type

event p_mod::clicked;call super::clicked;long    	i, li_faqty, ll_count = 0 
double  	ld_jpno
string  	sopt, sgub, snull, ls_rtn
Str_win	str_win

setnull(snull)

if dw_insert.AcceptText() = -1 then return 
if dw_1.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then
	return 
end if	

sgub = dw_1.getitemstring(1, "gub")

IF sgub = 'N' then   //폐기승인처리시
   if Messagebox('저 장','폐기승인처리 하시겠습니까?',Question!,YesNo!,1) = 2 then return
ELSE
   if Messagebox('저 장','폐기승인취소 하시겠습니까?',Question!,YesNo!,1) = 2 then return
END IF

SetPointer(HourGlass!)

dw_insert.setredraw(false)

FOR i=1 TO dw_insert.rowcount()
	If sgub = 'N' then
		sopt = dw_insert.getitemstring(i, "opt")
		if sopt = 'Y' then
			if isnull(dw_insert.getitemstring(i, "dptnm")) or &
				trim(dw_insert.getitemstring(i, "dptnm")) = '' then
				f_message_chk(30,'[ 원인 제공 부서 ]')
				dw_insert.setcolumn("pedptno")
				dw_insert.scrolltorow(i)
				dw_insert.setfocus()
				dw_insert.setredraw(true)
				return
			end if
			ll_count = ll_count + 1	
		End If
	End If
Next

If ll_count > 0 Then
	If gs_saupj = '11' or gs_saupj = '%' Then
		if Messagebox('저 장','부적합품 입고를 처리하시겠습니까?',Question!,YesNo!,1) = 1 then
			str_win.window = parent
			str_win.name   = String(ll_count)
			OpenWithParm(w_pdt_02140_popup, str_win)
			
			ls_rtn = Message.StringParm
			// 부적합품 입력이 실패한경우
			If ls_rtn = '0' Then 
				p_can.TriggerEvent(Clicked!)
				p_inq.TriggerEvent(Clicked!)
				return
			End If
		End If
	End If
End If

IF sgub = 'N' then   //폐기승인처리시
	FOR i=1 TO dw_insert.rowcount()
		 sopt = dw_insert.getitemstring(i, "opt")
		 if sopt = 'Y' then
//			 if isnull(dw_insert.getitemstring(i, "dptnm")) or &
//			 	 trim(dw_insert.getitemstring(i, "dptnm")) = '' then
//				 f_message_chk(30,'[ 원인 제공 부서 ]')
//				 dw_insert.setcolumn("pedptno")
//				 dw_insert.scrolltorow(i)
//				 dw_insert.setfocus()
//				 dw_insert.setredraw(true)
//				 return
//			 end if
			dw_insert.setitem(i, "pedat", f_today())
		 end if
	NEXT
ELSE                //폐기승인취소시
	FOR i=1 TO dw_insert.rowcount()
		 sopt = dw_insert.getitemstring(i, "opt")
		 if sopt = 'Y' then
			 dw_insert.setitem(i, "pedat",   snull)
			 dw_insert.setitem(i, "pedptno", snull)
			 dw_insert.setitem(i, "dptnm", snull)
		 end if
	NEXT
END IF	

if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text  = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
   dw_insert.setredraw(true)
	return 
end if	

string s_fdate, s_tdate, spdtgu


spdtgu   = trim(dw_1.GetItemString(1,'pdtgu'))
if isnull(spdtgu) or trim(spdtgu) = '' then
	spdtgu = '%'
end if

s_fdate = trim(dw_1.GetItemString(1,'fr_date'))
s_tdate = trim(dw_1.GetItemString(1,'to_date'))
if dw_insert.Retrieve(gs_sabu, s_fdate, s_tdate, spdtgu, gs_saupj) <= 0 then 
	dw_1.Setcolumn('fr_date')
	dw_1.SetFocus()
end if	
dw_insert.setredraw(true)
		
end event

type cb_exit from w_inherite`cb_exit within w_pdt_02140
integer x = 2345
integer y = 2628
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02140
integer x = 1737
integer y = 2532
string text = "처리(&E)"
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02140
integer x = 539
integer y = 2532
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_02140
integer x = 1143
integer y = 2532
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02140
integer x = 1431
integer y = 2532
end type

type cb_print from w_inherite`cb_print within w_pdt_02140
integer x = 2359
integer y = 2596
end type

type st_1 from w_inherite`st_1 within w_pdt_02140
end type

type cb_can from w_inherite`cb_can within w_pdt_02140
integer x = 2062
integer y = 2532
end type

type cb_search from w_inherite`cb_search within w_pdt_02140
integer x = 2619
integer y = 2532
end type





type gb_10 from w_inherite`gb_10 within w_pdt_02140
integer x = 110
integer y = 2524
integer width = 1687
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_02140
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02140
end type

type dw_1 from datawindow within w_pdt_02140
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 23
integer y = 16
integer width = 3488
integer height = 256
integer taborder = 20
string dataobject = "d_pdt_02140_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string snull, s_gub, sdate

setnull(snull)

IF this.GetColumnName() ="gub" THEN
	s_gub = trim(this.GetText())
	
	IF	s_gub = 'N' Then
		dw_insert.DataObject ="d_pdt_02140_1" 
		dw_insert.SetTransObject(SQLCA)
	ELSE
		dw_insert.DataObject ="d_pdt_02140_2" 
		dw_insert.SetTransObject(SQLCA)
	END IF
ELSEIF this.GetColumnName() ="fr_date" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[FROM일자]')
		this.setitem(1, "fr_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() ="to_date" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[TO일자]')
		this.setitem(1, "to_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() ="pdtgu" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF isnull(f_get_reffer('03', sdate))	then
      f_message_chk(33, '[생산팀]')
		this.setitem(1, "pdtgu", sNull)
		return 1
	END IF	
END IF	
end event

event itemerror;return 1
end event

type rr_4 from roundrectangle within w_pdt_02140
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 292
integer width = 4590
integer height = 1868
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from datawindow within w_pdt_02140
integer x = 23
integer y = 2168
integer width = 4608
integer height = 160
integer taborder = 40
string dataobject = "d_pdt_02140_3"
boolean border = false
boolean livescroll = true
end type

type pb_1 from u_pb_cal within w_pdt_02140
integer x = 1669
integer y = 148
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.Setcolumn('fr_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'fr_date', gs_code)
end event

type pb_2 from u_pb_cal within w_pdt_02140
integer x = 2130
integer y = 148
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.Setcolumn('to_date')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'to_date', gs_code)
end event

