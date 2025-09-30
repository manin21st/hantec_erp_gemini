$PBExportHeader$w_sm40_0057_popup.srw
$PBExportComments$월간 검수
forward
global type w_sm40_0057_popup from window
end type
type cb_10 from commandbutton within w_sm40_0057_popup
end type
type cb_9 from commandbutton within w_sm40_0057_popup
end type
type cb_8 from commandbutton within w_sm40_0057_popup
end type
type cb_7 from commandbutton within w_sm40_0057_popup
end type
type cb_6 from commandbutton within w_sm40_0057_popup
end type
type em_1 from editmask within w_sm40_0057_popup
end type
type cb_5 from commandbutton within w_sm40_0057_popup
end type
type cb_4 from commandbutton within w_sm40_0057_popup
end type
type cb_3 from commandbutton within w_sm40_0057_popup
end type
type cb_2 from commandbutton within w_sm40_0057_popup
end type
type p_2 from uo_picture within w_sm40_0057_popup
end type
type dw_imhist from datawindow within w_sm40_0057_popup
end type
type dw_jo from datawindow within w_sm40_0057_popup
end type
type st_2 from statictext within w_sm40_0057_popup
end type
type st_1 from statictext within w_sm40_0057_popup
end type
type dw_2 from datawindow within w_sm40_0057_popup
end type
type st_3 from statictext within w_sm40_0057_popup
end type
type p_exit from uo_picture within w_sm40_0057_popup
end type
type p_can from uo_picture within w_sm40_0057_popup
end type
type p_print from uo_picture within w_sm40_0057_popup
end type
type p_mod from uo_picture within w_sm40_0057_popup
end type
type cb_1 from commandbutton within w_sm40_0057_popup
end type
type cb_exit from commandbutton within w_sm40_0057_popup
end type
type cb_cancel from commandbutton within w_sm40_0057_popup
end type
type cb_save from commandbutton within w_sm40_0057_popup
end type
type rr_1 from roundrectangle within w_sm40_0057_popup
end type
type rr_2 from roundrectangle within w_sm40_0057_popup
end type
type dw_1 from datawindow within w_sm40_0057_popup
end type
end forward

global type w_sm40_0057_popup from window
integer x = 59
integer y = 124
integer width = 4667
integer height = 2564
boolean titlebar = true
string title = "매출조정 POPUP"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cb_10 cb_10
cb_9 cb_9
cb_8 cb_8
cb_7 cb_7
cb_6 cb_6
em_1 em_1
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
p_2 p_2
dw_imhist dw_imhist
dw_jo dw_jo
st_2 st_2
st_1 st_1
dw_2 dw_2
st_3 st_3
p_exit p_exit
p_can p_can
p_print p_print
p_mod p_mod
cb_1 cb_1
cb_exit cb_exit
cb_cancel cb_cancel
cb_save cb_save
rr_1 rr_1
rr_2 rr_2
dw_1 dw_1
end type
global w_sm40_0057_popup w_sm40_0057_popup

type variables
str_05000 istr_05000

decimal idamt, imtmp

str_code ist_code

Long il_lastclickedrow
end variables

on w_sm40_0057_popup.create
this.cb_10=create cb_10
this.cb_9=create cb_9
this.cb_8=create cb_8
this.cb_7=create cb_7
this.cb_6=create cb_6
this.em_1=create em_1
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.p_2=create p_2
this.dw_imhist=create dw_imhist
this.dw_jo=create dw_jo
this.st_2=create st_2
this.st_1=create st_1
this.dw_2=create dw_2
this.st_3=create st_3
this.p_exit=create p_exit
this.p_can=create p_can
this.p_print=create p_print
this.p_mod=create p_mod
this.cb_1=create cb_1
this.cb_exit=create cb_exit
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.rr_1=create rr_1
this.rr_2=create rr_2
this.dw_1=create dw_1
this.Control[]={this.cb_10,&
this.cb_9,&
this.cb_8,&
this.cb_7,&
this.cb_6,&
this.em_1,&
this.cb_5,&
this.cb_4,&
this.cb_3,&
this.cb_2,&
this.p_2,&
this.dw_imhist,&
this.dw_jo,&
this.st_2,&
this.st_1,&
this.dw_2,&
this.st_3,&
this.p_exit,&
this.p_can,&
this.p_print,&
this.p_mod,&
this.cb_1,&
this.cb_exit,&
this.cb_cancel,&
this.cb_save,&
this.rr_1,&
this.rr_2,&
this.dw_1}
end on

on w_sm40_0057_popup.destroy
destroy(this.cb_10)
destroy(this.cb_9)
destroy(this.cb_8)
destroy(this.cb_7)
destroy(this.cb_6)
destroy(this.em_1)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.p_2)
destroy(this.dw_imhist)
destroy(this.dw_jo)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_2)
destroy(this.st_3)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_print)
destroy(this.p_mod)
destroy(this.cb_1)
destroy(this.cb_exit)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.dw_1)
end on

event open;ist_code = message.powerobjectparm

f_window_center_response(this) 
dw_imhist.settransobject(sqlca)
dw_jo.settransobject(sqlca)

dw_jo.insertRow(0)
dw_jo.object.saupj[1] = Trim(ist_code.sgubun3[1]) 
dw_jo.object.sdate[1] = Trim(ist_code.sgubun2[1])+'01'
dw_jo.object.edate[1] = f_last_date(Trim(ist_code.sgubun2[1])+'01')

imtmp = gi_page
setnull(gi_page)

Setnull(gi_page)
p_can.PostEvent(clicked!)


end event

event key;//Choose Case key
//	Case KeyW!
//		p_print.TriggerEvent(Clicked!)
//	Case KeyQ!
//		p_can.TriggerEvent(Clicked!)
////	Case KeyT!
////		p_ins.TriggerEvent(Clicked!)
////	Case KeyA!
////		p_addrow.TriggerEvent(Clicked!)
////	Case KeyE!
////		p_delrow.TriggerEvent(Clicked!)
//	Case KeyS!
//		p_mod.TriggerEvent(Clicked!)
//	Case KeyD!
//		p_2.TriggerEvent(Clicked!)
////	Case KeyC!
////		p_can.TriggerEvent(Clicked!)
//	Case KeyX!
//		p_exit.TriggerEvent(Clicked!)
//End Choose
end event

type cb_10 from commandbutton within w_sm40_0057_popup
integer x = 2414
integer y = 2604
integer width = 183
integer height = 112
integer taborder = 110
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "닫기(&X)"
end type

event clicked;//MESSAGEBOX('1', '5')
p_exit.TriggerEvent(Clicked!)
end event

type cb_9 from commandbutton within w_sm40_0057_popup
integer x = 2254
integer y = 2624
integer width = 178
integer height = 112
integer taborder = 120
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "삭제(&D)"
end type

event clicked;//MESSAGEBOX('1', '4')
p_2.TriggerEvent(Clicked!)
end event

type cb_8 from commandbutton within w_sm40_0057_popup
integer x = 2062
integer y = 2616
integer width = 197
integer height = 112
integer taborder = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "인쇄(&W)"
end type

event clicked;//MESSAGEBOX('1', '3')
p_print.TriggerEvent(Clicked!)
end event

type cb_7 from commandbutton within w_sm40_0057_popup
integer x = 1851
integer y = 2612
integer width = 197
integer height = 112
integer taborder = 110
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;//MESSAGEBOX('1', '2')
p_mod.TriggerEvent(Clicked!)
end event

type cb_6 from commandbutton within w_sm40_0057_popup
integer x = 1632
integer y = 2604
integer width = 215
integer height = 112
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&Q)"
end type

event clicked;//MESSAGEBOX('1', '1')
p_can.TriggerEvent(Clicked!)
end event

type em_1 from editmask within w_sm40_0057_popup
integer x = 2862
integer y = 48
integer width = 457
integer height = 72
integer taborder = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
string mask = "###,###.00 "
end type

type cb_5 from commandbutton within w_sm40_0057_popup
integer x = 3319
integer y = 44
integer width = 402
integer height = 84
integer taborder = 110
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "금액일괄적용"
end type

event clicked;//ioprc_new

Decimal ldc_prc
ldc_prc = Dec(em_1.Text)
If ldc_prc <= 0 Then
	MessageBox('금액 확인', '입력 된 금액이 없습니다.')
	Return
End If

Integer li_cnt
li_cnt = dw_1.RowCount()
If li_cnt < 1 Then
	MessageBox('확인', '조회된 내용이 없습니다.')
	Return
End If

Integer i
Integer ii ; ii = 0
For i = 1 To li_cnt
	If dw_1.IsSelected(i) = True Then
		ii++
	End If
Next

If ii < 1 Then
	If MessageBox('선택 행 확인', '선택 된 행이 없습니다. 전체 단가를 적용 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return
	
	SetNull(i)
	For i = 1 To li_cnt
		dw_1.SetItem(i, 'ioprc_new', ldc_prc)
	Next
	
	Return
Else
	SetNull(i)
	For i = 1 To li_cnt
		If dw_1.IsSelected(i) = True Then
			dw_1.SetItem(i, 'ioprc_new', ldc_prc)
		End If
	Next
End If
end event

type cb_4 from commandbutton within w_sm40_0057_popup
boolean visible = false
integer x = 3310
integer y = 232
integer width = 421
integer height = 124
integer taborder = 120
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "수출단가적용"
end type

event clicked;long		lrow
decimal	dunprc

if dw_2.rowcount() <= 0 then return

// 수출단가-입고소스가 L
setpointer(hourglass!)

lrow = dw_2.find("ipsource='L'",1,dw_2.rowcount())
if lrow > 0 then
	dunprc = dw_2.getitemnumber(lrow,'unprc')
	for lrow = 1 to dw_1.rowcount()
		if dw_1.getitemstring(lrow,'lclgbn') = 'L' then
			dw_1.setitem(lrow,'ioprc_new',dunprc)
		end if
	next
end if

messagebox('확인','단가 갱신 완료!!!')
end event

type cb_3 from commandbutton within w_sm40_0057_popup
boolean visible = false
integer x = 3328
integer y = 132
integer width = 398
integer height = 124
integer taborder = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "단가소급"
end type

event clicked;String ls_gubun , ls_sudat ,ls_saupj ,ls_cvcod , ls_itnbr ,ls_null
Long   ll_cnt ,ll_maxjpno ,ll_maxseq
String ls_junpo_gb ,ls_jpno ,ls_iogbn
String ls_depot_no ,ls_iocnf ,ls_gumsu ,ls_new, sNull
Long   i ,ll_rcnt, ll_r
Dec    ld_ioamt

String sIogubun, srcvcod, sHousegubun, stagbn, sqcgub, sTaOutJpno, sTaInjpno, sSaleyn, sIojpno, sJnpcrt

SetNull(ls_null)
SetNull(snull)

If dw_1.Rowcount() < 1 Then Return

Dec ld_cvamt9 , ld_clamt9 , ld_cvamt , ld_clamt
Dec ld_cvqty9 , ld_clqty9 , ld_cvqty , ld_clqty

ls_saupj = Trim(dw_jo.object.saupj[1])

ld_cvqty9 = dw_2.GetItemDecimal(1, "cv_qty")
ld_clqty9 = dw_2.GetItemDecimal(1, "cl_qty")

ld_cvqty = dw_1.GetItemDecimal(1, "cv_qty")
ld_clqty = dw_1.GetItemDecimal(1, "cl_qty")

ld_cvamt9 = dw_2.GetItemDecimal(1, "cv_amt")
ld_clamt9 = dw_2.GetItemDecimal(1, "cl_amt")

ld_cvamt = dw_1.GetItemDecimal(1, "cv_amt")
ld_clamt = dw_1.GetItemDecimal(1, "cl_amt")

If (ld_cvqty9 <> ld_cvqty) or (ld_clqty9 <> ld_clqty) Then
	MessageBox('확인','단가 소급할 수량이 서로 맞지 않습니다')
	Return
End if

If ld_cvamt9 = ld_cvamt and ld_clamt9 = ld_clamt Then
	MessageBox('확인','단가 소급할 데이타가 없습니다.')
	Return
End if

SELECT cvcod  into :ls_depot_no
  From vndmst
 where cvgu = '5'
   and ipjogun = :ls_saupj
	and soguan = '1' ;

/* 매출마감 여부 체크  ========================================== */
SELECT COUNT(*)  INTO :ll_cnt
  FROM JUNPYO_CLOSING  
WHERE SABU = :gs_sabu 
   AND JPGU = 'G0' 
	AND JPDAT >= substr(:ls_sudat,1,6)  ;
		
If ll_cnt >= 1 then
	f_message_chk(60,'[매출마감]')
	Return
End if
//================================================================

dw_imhist.Reset()
ls_sudat = f_last_date(Trim(ist_code.sgubun2[1]) +'01')

ls_junpo_gb = 'C0'
ll_maxjpno = sqlca.fun_junpyo(gs_sabu,ls_sudat,ls_junpo_gb)
IF ll_maxjpno <= 0 THEN
	f_message_chk(51,'')
	ROLLBACK;
	Return 1
END IF
commit;
ls_jpno = ls_sudat + String(ll_maxjpno,'0000')
ll_maxseq = 0

If  ld_cvamt9 <> ld_cvamt  Then
	
	If ld_cvqty = 0 and ld_cvamt9 <> 0 Then 
		ld_cvqty = 1 
	End if	
	
	For i = 1 TO 2
		
		ll_r = dw_imhist.InsertRow(0)
		ll_maxseq = ll_maxseq + 1
		dw_imhist.SetItem(ll_r,"sabu",       gs_sabu)
		dw_imhist.SetItem(ll_r,"iojpno",     ls_jpno+String(ll_maxseq,'000'))
		
		If i= 1  Then
			dw_imhist.SetItem(ll_r,"iogbn", 		 'OY6')
			dw_imhist.SetItem(ll_r,"ioqty",       ld_cvqty * -1 )
			dw_imhist.SetItem(ll_r,"ioreqty",     ld_cvqty * -1)
			dw_imhist.SetItem(ll_r,"iosuqty",     ld_cvqty * -1)
			dw_imhist.SetItem(ll_r,"ioamt",       ld_cvamt * -1)
			dw_imhist.SetItem(ll_r,"ioprc",      Round(ld_cvamt/ld_cvqty,5))
			dw_imhist.SetItem(ll_r,"inpcnf", 'I')
		Else
			dw_imhist.SetItem(ll_r,"iogbn", 		 'OY5')
			dw_imhist.SetItem(ll_r,"ioqty",       ld_cvqty )
			dw_imhist.SetItem(ll_r,"ioreqty",     ld_cvqty)
			dw_imhist.SetItem(ll_r,"iosuqty",     ld_cvqty)
			dw_imhist.SetItem(ll_r,"ioamt",      ld_cvamt9)
			dw_imhist.SetItem(ll_r,"ioprc",      Round(ld_cvamt9/ld_cvqty,5))
			dw_imhist.SetItem(ll_r,"inpcnf", 'O')
		End If
		
		dw_imhist.SetItem(ll_r,"sudat", 		 ls_sudat )
		dw_imhist.SetItem(ll_r,"cvcod",      Trim(dw_1.object.cvcod[1]))
		dw_imhist.SetItem(ll_r,"depot_no",   ls_depot_no)
		
		dw_imhist.SetItem(ll_r,"itnbr",     Trim(ist_code.code[1])) 
		dw_imhist.SetItem(ll_r,"insdat",     ls_sudat)
	
		dw_imhist.SetItem(ll_r,"io_confirm", ls_iocnf)
		dw_imhist.SetItem(ll_r,"io_date",    ls_sudat)
		dw_imhist.SetItem(ll_r,"filsk",      'N')
		dw_imhist.SetItem(ll_r,"decisionyn", 'Y')
		dw_imhist.SetItem(ll_r,"yebi1",      ls_sudat)
		
		dw_imhist.SetItem(ll_r,"ioreemp",    gs_empno)
		dw_imhist.SetItem(ll_r,"saupj",      ls_saupj )
		dw_imhist.SetItem(ll_r,"facgbn",     Trim(ist_code.sgubun1[1])  )
		dw_imhist.SetItem(ll_r,"lclgbn",     'V' )
		
		dw_imhist.SetItem(ll_r,"botimh",'')
		dw_imhist.SetItem(ll_r,"outchk",'N')
		dw_imhist.SetItem(ll_r,"qcgub",'1')
		dw_imhist.SetItem(ll_r,"jnpcrt",'036')
		dw_imhist.SetItem(ll_r,"bigo",'마감 단가소급')
	Next
	
End if

If  ld_clamt9 <> ld_clamt  Then
	
	If ld_clqty = 0  and ld_clamt9 <> 0 Then
		
		ld_clqty = 1 
	End if
	
	For i = 1 TO 2
	
		ll_r = dw_imhist.InsertRow(0)
		ll_maxseq = ll_maxseq + 1
		dw_imhist.SetItem(ll_r,"sabu",       gs_sabu)
		dw_imhist.SetItem(ll_r,"iojpno",     ls_jpno+String(ll_maxseq,'000'))
		
		If i= 1  Then
			dw_imhist.SetItem(ll_r,"iogbn", 		 'OY6')
			dw_imhist.SetItem(ll_r,"ioqty",       ld_clqty * -1 )
			dw_imhist.SetItem(ll_r,"ioreqty",     ld_clqty * -1)
			dw_imhist.SetItem(ll_r,"iosuqty",     ld_clqty * -1)
			dw_imhist.SetItem(ll_r,"ioamt",       ld_clamt * -1)
			dw_imhist.SetItem(ll_r,"ioprc",      Round(ld_clamt/ld_clqty,5))
			dw_imhist.SetItem(ll_r,"inpcnf", 'I')
		Else
			dw_imhist.SetItem(ll_r,"iogbn", 		 'OY5')
			dw_imhist.SetItem(ll_r,"ioqty",       ld_clqty )
			dw_imhist.SetItem(ll_r,"ioreqty",     ld_clqty)
			dw_imhist.SetItem(ll_r,"iosuqty",     ld_clqty)
			dw_imhist.SetItem(ll_r,"ioamt",      ld_clamt9)
			dw_imhist.SetItem(ll_r,"ioprc",      Round(ld_clamt9/ld_clqty,5))
			dw_imhist.SetItem(ll_r,"inpcnf", 'O')
		End If
		
		dw_imhist.SetItem(ll_r,"sudat", 		 ls_sudat )
		dw_imhist.SetItem(ll_r,"cvcod",      Trim(dw_1.object.cvcod[1]))
		dw_imhist.SetItem(ll_r,"depot_no",   ls_depot_no)
		
		dw_imhist.SetItem(ll_r,"itnbr",     Trim(ist_code.code[1])) 
		dw_imhist.SetItem(ll_r,"insdat",     ls_sudat)
	
		dw_imhist.SetItem(ll_r,"io_confirm", ls_iocnf)
		dw_imhist.SetItem(ll_r,"io_date",    ls_sudat)
		dw_imhist.SetItem(ll_r,"filsk",      'N')
		dw_imhist.SetItem(ll_r,"decisionyn", 'Y')
		dw_imhist.SetItem(ll_r,"yebi1",      ls_sudat)
		
		dw_imhist.SetItem(ll_r,"ioreemp",    gs_empno)
		dw_imhist.SetItem(ll_r,"saupj",      ls_saupj )
		dw_imhist.SetItem(ll_r,"facgbn",     Trim(ist_code.sgubun1[1]) )
		dw_imhist.SetItem(ll_r,"lclgbn",     'L' )
		
		dw_imhist.SetItem(ll_r,"botimh",'')
		dw_imhist.SetItem(ll_r,"outchk",'N')
		dw_imhist.SetItem(ll_r,"qcgub",'1')
		dw_imhist.SetItem(ll_r,"jnpcrt",'036')
		dw_imhist.SetItem(ll_r,"bigo",'마감 단가소급')
	Next
	
End if

dw_imhist.AcceptText()
If dw_imhist.RowCount() > 0 Then
	IF dw_imhist.Update() <> 1 THEN
		ROLLBACK;
		Return
	END IF
	
	COMMIT;
End if
p_can.TriggerEvent(Clicked!)

end event

type cb_2 from commandbutton within w_sm40_0057_popup
boolean visible = false
integer x = 3337
integer y = 32
integer width = 398
integer height = 124
integer taborder = 90
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "매출생성"
end type

event clicked;w_mdi_frame.sle_msg.text =""
Long lCount
Double dcnt
String ls_factory , ls_itnbr , ls_yymm , ls_sdate , ls_edate , ls_saupj ,ls_custcd
String ls_err
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

If dw_jo.AcceptText() < 1 Then Return


ls_itnbr   = Trim(ist_code.code[1]) 
ls_factory = Trim(ist_code.sgubun1[1]) 
ls_yymm    = Trim(ist_code.sgubun2[1]) 
ls_saupj   = Trim(ist_code.sgubun3[1]) 

ls_sdate = Trim(dw_jo.object.sdate[1]) 
ls_edate = Trim(dw_jo.object.edate[1]) 

ls_err = 'Y'

//sqlca.SP_DAILY_GUMSU( ls_saupj , ls_sdate , ls_edate , ls_itnbr , ls_err , dcnt )  ;

If dcnt > 0 Then
	MessageBox('확인', String(Long(dcnt)) + ' 건의 매출실적이 생성되었습니다.')
	p_can.TriggerEvent(Clicked!)
End if
end event

type p_2 from uo_picture within w_sm40_0057_popup
integer x = 4270
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

If dw_1.AcceptText() < 1 Then Return

Long i ,li_rtn
String ls_iojpno , ls_iogbn
String ls_gubun
String ls_sale_mayymm

li_rtn = MessageBox('확인','단가소급한 자료를 삭제 합니다. 계속 진행하시겠습니까?' , Exclamation!, OKCancel!, 2)

if li_rtn = 2 Then return


For i = dw_1.RowCount() To 1 Step -1
	
	ls_gubun = Trim(dw_1.object.gubun[i])
	If ls_gubun = 'N' Then Continue ;
	
	
		
	ls_iogbn = Trim(dw_1.object.imhist_iogbn[i])
	If ls_iogbn = 'OY5' or ls_iogbn = 'OY6' Then
		
		ls_sale_mayymm = dw_1.object.imhist_sale_mayymm[i] 
		if isNull(ls_sale_mayymm ) = false then
			MessageBox('확인','마감한 자료입니다. 삭제 불가합니다.')
			continue ;
		end if
	
		ls_iojpno = Trim(dw_1.object.imhist_iojpno[i])
		
		Delete From imhist where sabu = :gs_sabu
		                     and iojpno = :ls_iojpno ;
		If sqlca.sqlcode <> 0 Then
			Rollback;
			MessageBox('확인','삭제실패')
			Return
		End if
	End if
	
Next

Commit ;

p_can.TriggerEvent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type dw_imhist from datawindow within w_sm40_0057_popup
boolean visible = false
integer x = 2683
integer y = 1232
integer width = 1778
integer height = 1024
integer taborder = 160
boolean titlebar = true
string title = "none"
string dataobject = "d_imhist"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
boolean livescroll = true
end type

type dw_jo from datawindow within w_sm40_0057_popup
integer x = 32
integer y = 8
integer width = 2825
integer height = 156
integer taborder = 170
string title = "none"
string dataobject = "d_sm40_0057_pupop_1"
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within w_sm40_0057_popup
integer x = 73
integer y = 1644
integer width = 498
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "월간검수자료[D9]"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_sm40_0057_popup
integer x = 73
integer y = 164
integer width = 320
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "출고자료"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_2 from datawindow within w_sm40_0057_popup
integer x = 46
integer y = 1696
integer width = 4544
integer height = 652
integer taborder = 180
string title = "none"
string dataobject = "d_sm40_0057_popup2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type st_3 from statictext within w_sm40_0057_popup
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

type p_exit from uo_picture within w_sm40_0057_popup
integer x = 4443
integer y = 24
integer width = 178
integer taborder = 150
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("종료") = -1 THEN  	RETURN

//close(parent)


CloseWithReturn(parent, 'OK')
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_sm40_0057_popup
integer x = 3922
integer y = 24
integer width = 178
integer taborder = 130
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
Long lCount
String ls_factory , ls_itnbr , ls_yymm , ls_sdate , ls_edate , ls_saupj ,ls_custcd ,ls_checkdt , ls_datechk
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

If dw_jo.AcceptText() < 1 Then Return

ls_itnbr   = Trim(ist_code.code[1]) 
ls_factory = Trim(ist_code.sgubun1[1]) 
ls_yymm    = Trim(ist_code.sgubun2[1]) 
ls_saupj   = Trim(ist_code.sgubun3[1]) 

ls_sdate = Trim(dw_jo.object.sdate[1]) 
ls_edate = Trim(dw_jo.object.edate[1]) 

ls_checkdt = dw_jo.GetItemString(1 ,'datechk')


IF  ls_checkdt  = 'Y'  THEN
	ls_datechk = '20150101'
else
	ls_datechk = '19000101'
END IF



lCount = dw_1.retrieve(gs_sabu,  ls_factory, ls_itnbr , ls_sdate , ls_edate , ls_saupj,ls_datechk )

if lCount < 1 then
	Messagebox("마감내역", "매출 데이타이 내역이 없습니다", stopsign!)
	//Close(parent)
	//return
end if



Select Fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_custcd From dual ;

ls_yymm = f_aftermonth(ls_yymm , 1 )

lCount = dw_2.retrieve(ls_custcd,  ls_yymm  ,ls_itnbr ,ls_factory )

if lCount < 1 then
	Messagebox("마감내역", "검수합격통보서(월집계표 D9) 조회할 내역이 없습니다.", stopsign!)
	//Close(parent)
	//return
end if

//lCount = dw_2.retrieve(trim(istr_05000.sabu),  trim(istr_05000.mayymm), istr_05000.mayysq, &
//							  trim(istr_05000.cvcod) )
//if 	lCount < 1 then
//	Messagebox("비가동내역", "조회할 내역이 없읍니다", stopsign!)
//end if
//
//if 	istr_05000.move_yn = 'Y' then 
//	p_mod.Enabled = false
//	p_mod.picturename = "C:\erpman\image\저장_d.gif"
//else	
//	p_mod.Enabled = true
//	p_mod.picturename = "C:\erpman\image\저장_up.gif"
//end if   


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type p_print from uo_picture within w_sm40_0057_popup
integer x = 4096
integer y = 24
integer width = 178
integer taborder = 190
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

type p_mod from uo_picture within w_sm40_0057_popup
integer x = 3749
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

If dw_1.AcceptText() < 1 Then Return

Long i 

String ls_sale_mayymm

For i = 1 To dw_1.RowCount()
	
//	ls_sale_mayymm = dw_1.object.imhist_sale_mayymm[i] 
//	if isNull(ls_sale_mayymm ) = false then
//		Continue ;
//	end if
	
	If dw_1.object.ioprc[i] <> dw_1.object.ioprc_new[i] and dw_1.object.imhist_iogbn[i] <> 'OY3' Then
		dw_1.object.ioprc[i] = dw_1.object.ioprc_new[i]
//		dw_1.object.imhist_ioamt[i] = dw_1.object.cipamt[i]
		/* 저장 후 반품금액이 "-"로 update됨. 2007.04.21 by shingoon */
//		dw_1.object.imhist_ioamt[i] = Truncate(dw_1.object.ioprc_new[i]* dw_1.object.imhist_ioqty[i] , 0 )
      dw_1.object.imhist_ioamt[i] = Truncate(round((dw_1.object.ioprc_new[i] * dw_1.object.imhist_ioqty[i]), 2), 0 )
		
	End if

	If dw_1.object.cipamt[i] <> dw_1.object.imhist_ioamt[i] Then
		dw_1.object.ioprc[i] = dw_1.object.ioprc_new[i]
//		dw_1.object.imhist_ioamt[i] = dw_1.object.cipamt[i]
      /* 저장 후 반품금액이 "-"로 update됨. 2007.04.21 by shingoon */
//		dw_1.object.imhist_ioamt[i] = Truncate(dw_1.object.ioprc_new[i]* dw_1.object.imhist_ioqty[i] , 0 )
      dw_1.object.imhist_ioamt[i] = Truncate(round((dw_1.object.ioprc_new[i] * dw_1.object.imhist_ioqty[i]), 2), 0 )
		
	End if
	
Next


If dw_1.Update() < 1 Then
	w_mdi_frame.sle_msg.text = sqlca.sqlerrText
	Rollback;
	MessageBox('확인','저장실패')
	Return
End if

Commit ;

w_mdi_frame.sle_msg.text =""

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type cb_1 from commandbutton within w_sm40_0057_popup
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

type cb_exit from commandbutton within w_sm40_0057_popup
boolean visible = false
integer x = 2921
integer y = 2468
integer width = 517
integer height = 104
integer taborder = 70
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

type cb_cancel from commandbutton within w_sm40_0057_popup
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
	
ELSE 													//검사일자 기준
	dw_1.DataObject = 'd_pdt_05004'
	
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

type cb_save from commandbutton within w_sm40_0057_popup
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

type rr_1 from roundrectangle within w_sm40_0057_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 180
integer width = 4567
integer height = 1448
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_2 from roundrectangle within w_sm40_0057_popup
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 1656
integer width = 4567
integer height = 704
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_sm40_0057_popup
integer x = 46
integer y = 212
integer width = 4544
integer height = 1408
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sm40_0057_popup"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;String   sNull , ls_today
Decimal	dprc, dqty, damt

Setnull(sNull)

if this.getcolumnname() = 'gubun' then
	if data = 'Y' then
		
		this.setitem(row, "yebi1",f_last_date(Trim(ist_code.sgubun2[1])+'01')  )
	else
		this.setitem(row, "yebi1", snull)
	end if
ElseIf This.GetColumnName() = 'amt' Then
//	 ioprc_new
	damt = Dec(data)
	dqty = This.GetItemDecimal(row, 'cnqty')
	If IsNull(damt) OR damt = 0 Then
		dprc = 0
	Else
		dprc = damt / dqty
	End If
	This.SetItem(row, 'ioprc_new', dprc)
end if
end event

event doubleclicked;If row < 1 Then Return

ist_code.sgubun4[1] =  Trim(this.object.lotsno[row])

//openwithparm(w_sm40_0057_popup3 , ist_code)

end event

event clicked;Long	ll_i, snull

IF row <= 0 THEN 

	this.SelectRow(0, False)
	Setnull(snull)
	
	if dwo.name = 'gubun_t' then
		if this.RowCount() <= 0 then return
		if this.object.gubun_t.text = '▣' then 
			for ll_i = 1 to this.RowCount() 
				SetItem(ll_i, 'gubun', 'N')
//				SetItem(ll_i, 'yebi1', snull)
				SetItem(ll_i, 'yebi1', '')
			next
			this.object.gubun_t.text = '□'
		else
			for ll_i = 1 to this.RowCount()   
				SetItem(ll_i, 'gubun', 'Y') 
				SetItem(ll_i, 'yebi1',f_last_date(Trim(ist_code.sgubun2[1])+'01')  )
			next
			this.object.gubun_t.text = '▣'
		end if
		return
	end if
	
ELSE
	f_multi_select(This)
END IF 


end event

event retrieveend;string ls_iogbn
int i
long ll_soamt = 0, ll_qty = 0
Dec ld_dan

for i = 1 to dw_1.rowcount()
	if dw_1.GetItemString(i, 'imhist_iogbn') = 'OY3' then
		ll_soamt = ll_soamt + dw_1.GetItemNumber(i, 'compute_2')
	elseif dw_1.GetItemString(i, 'imhist_iogbn') = 'O02' and dw_1.GetItemString(i, 'gubun') = 'Y' then
		ll_qty = ll_qty + dw_1.GetItemNumber(i, 'cnqty')		
	end if
next

if ll_qty <> 0 then
	ld_dan = (imtmp - ll_soamt) / ll_qty
else
	ld_dan = 0
end if

em_1.text = string(ld_dan)
end event

