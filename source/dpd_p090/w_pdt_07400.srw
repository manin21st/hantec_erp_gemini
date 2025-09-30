$PBExportHeader$w_pdt_07400.srw
$PBExportComments$제품별 자재 소요수량 계 조회
forward
global type w_pdt_07400 from w_inherite
end type
type gb_1 from groupbox within w_pdt_07400
end type
type pb_1 from picturebutton within w_pdt_07400
end type
type pb_2 from picturebutton within w_pdt_07400
end type
type pb_3 from picturebutton within w_pdt_07400
end type
type pb_4 from picturebutton within w_pdt_07400
end type
type dw_1 from u_key_enter within w_pdt_07400
end type
type dw_2 from u_key_enter within w_pdt_07400
end type
type dw_3 from datawindow within w_pdt_07400
end type
type dw_4 from datawindow within w_pdt_07400
end type
type dw_5 from datawindow within w_pdt_07400
end type
type rr_1 from roundrectangle within w_pdt_07400
end type
type rr_2 from roundrectangle within w_pdt_07400
end type
type rr_3 from roundrectangle within w_pdt_07400
end type
type rr_4 from roundrectangle within w_pdt_07400
end type
type rr_5 from roundrectangle within w_pdt_07400
end type
end forward

global type w_pdt_07400 from w_inherite
string title = "자재소요수량 계산내역 조회"
boolean minbox = false
windowtype windowtype = response!
gb_1 gb_1
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
dw_4 dw_4
dw_5 dw_5
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
rr_4 rr_4
rr_5 rr_5
end type
global w_pdt_07400 w_pdt_07400

forward prototypes
public subroutine wf_scroll (integer sgubun)
public subroutine wf_month (string syymm)
public subroutine wf_item_set (string sitnbr)
end prototypes

public subroutine wf_scroll (integer sgubun);// 구분 = 1 : First, 2 : Prior, 3 : next , 4 : Last

String sitnbr, sRtnbr

dw_1.accepttext()
sItnbr = dw_1.getitemstring(1, "itnbr")

/* itemas */
Choose Case sgubun 
		 Case 1
 				 select Min(itnbr) 
				  	Into :sRtnbr
				  	from itemas 
				  where ittyp = '3';
		 Case 2
				 select itnbr
				 	into :srtnbr
				   from 
						 (select distinct itnbr      
							 from itemas 
							where itnbr < :sItnbr and ittyp = '3' order by itnbr desc)
				  where rownum = 1;
					
				 if sqlca.sqlcode <> 0 then setnull(sRtnbr)
		 Case 3
				
				 select itnbr
				 	into :srtnbr
				   from 
						 (select distinct itnbr      
							 from itemas 
							where itnbr > :sItnbr and ittyp = '3' order by itnbr)
				  where rownum = 1;
					
				 if sqlca.sqlcode <> 0 then setnull(sRtnbr)				 
		 Case 4
 				 select Max(itnbr) 
				  	Into :sRtnbr
				  	from itemas 
				  where ittyp = '3';			
End choose				


wf_item_set(srtnbr)
end subroutine

public subroutine wf_month (string syymm);Long Lseq

Select Max(Mrseq) 
  Into :Lseq
  From mtrpln_sum 
 Where sabu = :gs_sabu And mtryymm = :syymm;
dw_1.setitem(1, "giseq", Lseq) 

// 월 setting
dw_2.object.wolname.text = String(syymm, '@@@@.@@')
dw_2.object.wol1.text = String(syymm, '@@@@.@@')
dw_2.object.wol2.text = String(f_aftermonth(syymm, 1), '@@@@.@@')
dw_2.object.wol3.text = String(f_aftermonth(syymm, 2), '@@@@.@@')
dw_2.object.wol4.text = String(f_aftermonth(syymm, 3), '@@@@.@@')
dw_2.object.wol5.text = String(f_aftermonth(syymm, 4), '@@@@.@@')
end subroutine

public subroutine wf_item_set (string sitnbr);String sNull, sYymm, sRfna2, sgiyear, stxt
Long	 Lseq, Lactno

Setnull(sNull)

dw_1.setredraw(false)	
if isnull(sitnbr) or trim(sitnbr) = '' then
	dw_1.setitem(1, "bcvnas", sNull)
	dw_1.setitem(1, "bunprc", 0)	
	dw_1.setitem(1, "bcunit", sNull)	
	dw_1.setitem(1, "ccvnas", sNull)
	dw_1.setitem(1, "cunprc", 0)	
	dw_1.setitem(1, "ccunit", sNull)	
	dw_2.reset()
	dw_3.reset()	
	dw_4.reset()
	dw_5.reset()
Else
	sYymm = dw_1.getitemstring(1, "giym")
	Lseq  = dw_1.getitemdecimal(1, "giseq")
	dw_1.retrieve(sitnbr)	
	dw_1.setitem(1, "giym", syymm)
	dw_1.setitem(1, "giseq", Lseq)
	
	dw_2.retrieve(gs_sabu, &
					  dw_1.getitemstring(1, "giym"), &
					  dw_1.getitemstring(1, "itnbr"),  &
					  dw_1.getitemdecimal(1, "giseq"))
	dw_3.retrieve(sitnbr)
	
	// 구매 총소요량에 대한 최종 이력은 참조코드 99-3에 있음(참조명short)
	Setnull(sRfna2)
	select rfna2
	  into :sRfna2
	  From reffpf
	 where sabu ='1' and rfcod = '1A' and rfgub = '3';
	 
	if isnull(sRfna2) or trim(sRfna2) ='' then
		 Lactno  = 0
	Else
		 Lactno  = Dec(sRfna2)
	End if
	 
	if isnull(Lactno) then Lactno = 0
	 
	select mrpgiyymm, mrptxt
	  into :sgiyear, :stxt
	  from mrpsys
	 where sabu = :gs_sabu And actno = :Lactno;
	 
	dw_4.retrieve(gs_sabu, sitnbr, sgiyear, stxt)
	dw_5.retrieve(sitnbr)
End if
dw_1.setredraw(True)
end subroutine

on w_pdt_07400.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.dw_4=create dw_4
this.dw_5=create dw_5
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.rr_4=create rr_4
this.rr_5=create rr_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.pb_4
this.Control[iCurrent+6]=this.dw_1
this.Control[iCurrent+7]=this.dw_2
this.Control[iCurrent+8]=this.dw_3
this.Control[iCurrent+9]=this.dw_4
this.Control[iCurrent+10]=this.dw_5
this.Control[iCurrent+11]=this.rr_1
this.Control[iCurrent+12]=this.rr_2
this.Control[iCurrent+13]=this.rr_3
this.Control[iCurrent+14]=this.rr_4
this.Control[iCurrent+15]=this.rr_5
end on

on w_pdt_07400.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.dw_4)
destroy(this.dw_5)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.rr_5)
end on

event open;call super::open;

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)
dw_4.settransobject(sqlca)
dw_5.settransobject(sqlca)


String sYymm

dw_1.insertrow(0)

if gs_gubun = 'w_imt_01000' then 
	f_window_center_response(this) 
   sYymm = gs_codename
	dw_1.setitem(1, "giym", syymm)
	wf_month(syymm)

	dw_1.setitem(1, "itnbr", gs_code)
	wf_item_set(gs_code)

else
	sYymm = left(f_today(), 6)
	dw_1.setitem(1, "giym", syymm)
	wf_month(syymm)
	dw_1.setfocus()

end if	


end event

type dw_insert from w_inherite`dw_insert within w_pdt_07400
boolean visible = false
integer x = 3182
integer y = 2476
integer width = 411
integer height = 364
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;long	lRow
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = 'itnbr'	OR &
	this.GetColumnName() = 'itdsc'	OR &
 	this.GetColumnName() = 'ispec'	Then

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent("itemchanged")
End if
end event

event dw_insert::ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

type p_delrow from w_inherite`p_delrow within w_pdt_07400
integer x = 2857
integer y = 2744
end type

type p_addrow from w_inherite`p_addrow within w_pdt_07400
integer x = 2683
integer y = 2744
end type

type p_search from w_inherite`p_search within w_pdt_07400
integer x = 1989
integer y = 2744
end type

type p_ins from w_inherite`p_ins within w_pdt_07400
integer x = 2510
integer y = 2744
end type

type p_exit from w_inherite`p_exit within w_pdt_07400
integer x = 4448
integer y = 28
end type

type p_can from w_inherite`p_can within w_pdt_07400
integer x = 3378
integer y = 2744
end type

type p_print from w_inherite`p_print within w_pdt_07400
integer x = 2162
integer y = 2744
end type

type p_inq from w_inherite`p_inq within w_pdt_07400
integer x = 2336
integer y = 2744
end type

type p_del from w_inherite`p_del within w_pdt_07400
integer x = 3205
integer y = 2744
end type

type p_mod from w_inherite`p_mod within w_pdt_07400
integer x = 3031
integer y = 2744
end type

type cb_exit from w_inherite`cb_exit within w_pdt_07400
boolean visible = false
integer x = 1394
integer y = 2772
integer taborder = 60
end type

event cb_exit::clicked;close(parent)

end event

type cb_mod from w_inherite`cb_mod within w_pdt_07400
boolean visible = false
integer x = 503
integer y = 2612
integer taborder = 80
end type

type cb_ins from w_inherite`cb_ins within w_pdt_07400
boolean visible = false
integer x = 142
integer y = 2612
integer taborder = 70
end type

type cb_del from w_inherite`cb_del within w_pdt_07400
boolean visible = false
integer x = 864
integer y = 2612
integer taborder = 90
end type

type cb_inq from w_inherite`cb_inq within w_pdt_07400
boolean visible = false
integer x = 1225
integer y = 2612
integer taborder = 100
end type

type cb_print from w_inherite`cb_print within w_pdt_07400
boolean visible = false
integer x = 1586
integer y = 2612
integer taborder = 110
end type

type st_1 from w_inherite`st_1 within w_pdt_07400
end type

type cb_can from w_inherite`cb_can within w_pdt_07400
boolean visible = false
integer x = 1947
integer y = 2612
integer taborder = 120
end type

type cb_search from w_inherite`cb_search within w_pdt_07400
boolean visible = false
integer x = 2309
integer y = 2612
integer taborder = 130
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_07400
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_07400
end type

type gb_1 from groupbox within w_pdt_07400
integer x = 3063
integer y = 36
integer width = 558
integer height = 136
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
end type

type pb_1 from picturebutton within w_pdt_07400
integer x = 3095
integer y = 68
integer width = 105
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\Erpman\image\first_1.bmp"
alignment htextalign = left!
end type

event clicked;wf_scroll(1)
end event

type pb_2 from picturebutton within w_pdt_07400
integer x = 3223
integer y = 68
integer width = 105
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\Erpman\image\prior_1.bmp"
end type

event clicked;wf_scroll(2)
end event

type pb_3 from picturebutton within w_pdt_07400
integer x = 3351
integer y = 68
integer width = 105
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\Erpman\image\next_1.bmp"
end type

event clicked;wf_scroll(3)
end event

type pb_4 from picturebutton within w_pdt_07400
integer x = 3474
integer y = 68
integer width = 105
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean originalsize = true
string picturename = "C:\Erpman\image\last_1.bmp"
end type

event clicked;wf_scroll(4)
end event

type dw_1 from u_key_enter within w_pdt_07400
event ue_key pbm_dwnkey
integer x = 78
integer y = 40
integer width = 3547
integer height = 392
integer taborder = 0
string dataobject = "d_pdt_07400_1"
boolean border = false
end type

event ue_key;IF KEYDOWN(KEYF1!) THEN
	TRIGGEREVENT(RBUTTONdown!)
END IF
end event

event rbuttondown;long	lRow
lRow  = this.GetRow()	

gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = 'itnbr'	OR &
	this.GetColumnName() = 'itdsc'	OR &
 	this.GetColumnName() = 'ispec'	Then

	open(w_itemas_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	SetItem(lRow,"itnbr",gs_code)
	this.TriggerEvent("itemchanged")
End if
end event

event itemerror;return 1
end event

event itemchanged;String 	sNull, sItnbr, sItdsc, sisPec, syymm, sjijil, sispec_code 
Long		Lrow, Lseq
integer	ireturn

SetNull(sNull)

lRow  = this.GetRow()	
this.accepttext()

If this.GetColumnName() = "giym"	THEN
	syymm = this.gettext()	
	if f_datechk(syymm+'01') = -1 then
		f_message_chk(35,'[기준년월]')		
		this.setitem(lRow, "giym", Left(f_today(), 6))
		wf_month(Left(f_today(), 6))		
		return 1
	END IF

	Lseq = 0
	Select Max(Mrseq) 
	  Into :Lseq
	  From mtrpln_sum 
	 Where sabu = :gs_sabu And mtryymm = :syymm;	
	 
	setitem(Lrow, "giseq", Lseq)
	wf_month(syymm)
	
	sitnbr = dw_1.getitemstring(1, "itnbr")
	wf_item_set(sitnbr)
	
ElseIF this.GetColumnName() = "itnbr"	THEN
	sItnbr = trim(this.GetText())
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code) 
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
	wf_item_set(sitnbr)
	return ireturn
ElseIF this.GetColumnName() = "itdsc"	THEN
	sItdsc = trim(this.GetText())
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)	
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
	wf_item_set(sitnbr)
	RETURN ireturn
ElseIF this.GetColumnName() = "ispec"	THEN
	sIspec = trim(this.GetText())
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
	wf_item_set(sitnbr)
	RETURN ireturn	
ElseIF this.GetColumnName() = "jijil"	THEN
	sjijil = trim(this.GetText())
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
	wf_item_set(sitnbr)
	RETURN ireturn	
ElseIF this.GetColumnName() = "ispec_code"	THEN
	sispec_code = trim(this.GetText())
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(lrow, "itnbr", sitnbr)	
	this.setitem(lrow, "itdsc", sitdsc)	
	this.setitem(lrow, "ispec", sispec)
	this.setitem(lrow, "jijil", sjijil)	
	this.setitem(lrow, "ispec_code", sispec_code)
	wf_item_set(sitnbr)
	RETURN ireturn	
END IF
end event

event editchanged;ib_any_typing =True
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

type dw_2 from u_key_enter within w_pdt_07400
event ue_key pbm_dwnkey
integer x = 242
integer y = 552
integer width = 3461
integer height = 736
integer taborder = 0
string dataobject = "d_pdt_07400_2"
boolean border = false
end type

type dw_3 from datawindow within w_pdt_07400
integer x = 2592
integer y = 1404
integer width = 1993
integer height = 868
boolean bringtotop = true
boolean titlebar = true
string title = "창고별 재고현황"
string dataobject = "d_pdt_07100_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_4 from datawindow within w_pdt_07400
integer x = 91
integer y = 1408
integer width = 1431
integer height = 840
boolean bringtotop = true
string dataobject = "d_pdt_07400_3"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_5 from datawindow within w_pdt_07400
integer x = 1582
integer y = 1412
integer width = 942
integer height = 844
boolean bringtotop = true
string dataobject = "d_pdt_07400_4"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_pdt_07400
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 64
integer y = 32
integer width = 3598
integer height = 424
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_pdt_07400
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 238
integer y = 548
integer width = 3474
integer height = 748
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_pdt_07400
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 82
integer y = 1396
integer width = 1458
integer height = 860
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_4 from roundrectangle within w_pdt_07400
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1573
integer y = 1404
integer width = 960
integer height = 856
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_5 from roundrectangle within w_pdt_07400
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2583
integer y = 1396
integer width = 2016
integer height = 888
integer cornerheight = 40
integer cornerwidth = 46
end type

