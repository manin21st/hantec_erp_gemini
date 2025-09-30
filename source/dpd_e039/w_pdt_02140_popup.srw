$PBExportHeader$w_pdt_02140_popup.srw
$PBExportComments$*부적합품 입고
forward
global type w_pdt_02140_popup from w_inherite_popup
end type
type p_mod from uo_picture within w_pdt_02140_popup
end type
type rr_2 from roundrectangle within w_pdt_02140_popup
end type
end forward

global type w_pdt_02140_popup from w_inherite_popup
integer x = 357
integer y = 236
integer width = 1746
integer height = 1880
string title = "부적합품 입고"
boolean controlmenu = true
p_mod p_mod
rr_2 rr_2
end type
global w_pdt_02140_popup w_pdt_02140_popup

type variables
string	is_itcls, is_rtnstatus
end variables

on w_pdt_02140_popup.create
int iCurrent
call super::create
this.p_mod=create p_mod
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_mod
this.Control[iCurrent+2]=this.rr_2
end on

on w_pdt_02140_popup.destroy
call super::destroy
destroy(this.p_mod)
destroy(this.rr_2)
end on

event open;call super::open;long			i, ll_count, ll_inser_count
String		ls_opt
w_pdt_02140	w_parent
str_win		str_win

str_win = Message.PowerObjectParm

is_rtnstatus = '0'

w_parent = str_win.window
ll_count = long(str_win.name)
ll_inser_count = 0

If ll_count > 0 Then
	For i = 1 to w_parent.dw_insert.RowCount()
		ls_opt = w_parent.dw_insert.getitemstring(i, "opt")
		if ls_opt = 'Y' then
			ll_inser_count = 1 + ll_inser_count
			dw_1.insertRow(0)
			dw_1.setItem(ll_inser_count, 'itnbr_old', w_parent.dw_insert.getitemstring(i, "itnbr"))
			dw_1.setItem(ll_inser_count, 'faqty', w_parent.dw_insert.getitemNumber(i, "faqty"))
			dw_1.setItem(ll_inser_count, 'pordno', w_parent.dw_insert.getitemString(i, "pordno"))
			dw_1.setItem(ll_inser_count, 'shpjpno', w_parent.dw_insert.getitemString(i, "shpjpno"))
			dw_1.SelectRow(ll_inser_count,False)
		End If
//		dw_1.SelectRow(ll_inser_count,False)
	Next
End If
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdt_02140_popup
boolean visible = false
integer x = 1906
integer y = 48
integer width = 178
integer height = 116
boolean enabled = false
string title = ""
end type

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_name

setnull(snull)

IF this.GetColumnName() = 'econo' THEN
	s_name = this.gettext()
 
   IF s_name = "" OR IsNull(s_name) THEN 
		RETURN
   END IF
	
//	s_name = f_get_reffer('05', s_name)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[ECO No]')
		this.SetItem(1,'econo', snull)
		return 1
   end if	
END IF
end event

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

type p_exit from w_inherite_popup`p_exit within w_pdt_02140_popup
integer x = 1522
integer y = 36
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

CloseWithReturn(Parent, is_rtnstatus )
end event

type p_inq from w_inherite_popup`p_inq within w_pdt_02140_popup
boolean visible = false
integer x = 2944
integer y = 1396
boolean enabled = false
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String ls_econo
String sold_sql, swhere_clause, snew_sql

if dw_jogun.AcceptText() = -1 then return 

ls_econo = dw_jogun.GetItemString(1,'eco_no')

IF IsNull(ls_econo) THEN ls_econo = ""

sold_sql = " SELECT	ECO_NO, " + &
			" ITNBR, " + &
			" RFGUB, " + &
			" FUN_GET_REFFPF('01',ECOMST.RFGUB) RFNA1, " + &
			" FUN_GET_REFFPF_VALUE('01',ECOMST.RFGUB,'2') RFNA3, " + &
			" ECOMST.RECEIPT_DATE, " + &  
			" ECOMST.ECO_DATE" + &
			" FROM ECOMST "

swhere_clause = " WHERE ECO_NO LIKE '" + ls_econo + "%'"

snew_sql = sold_sql + swhere_clause
dw_1.SetSqlSelect(snew_sql)
If dw_1.Retrieve() = 0 Then
	f_message_chk(50, 'ECO NO ')
	return
End If
	
//dw_1.SelectRow(0,False)
//dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_pdt_02140_popup
boolean visible = false
integer x = 2944
integer y = 1560
boolean enabled = false
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

//IF dw_1.GetItemString(ll_Row, "itemas_useyn") = '1' then
//	f_message_chk(53, "[품번]")
//	Return 
//IF dw_1.GetItemString(ll_Row, "itemas_useyn") = '2' then
//	f_message_chk(54, "[품번]")
//	Return 
//END IF

gs_code = dw_1.GetItemString(ll_Row, "ecomst_eco_no")
gs_codename = dw_1.GetItemString(ll_row,"ecomst_itnbr")
gs_gubun = dw_1.GetItemString(ll_row,"reffpf_rfna1")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_pdt_02140_popup
integer x = 32
integer y = 208
integer width = 1627
integer height = 1468
integer taborder = 100
string dataobject = "d_pdt_02140_popup"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_1::clicked;//If Row <= 0 then
//	dw_1.SelectRow(0,False)
//	b_flag =True
//ELSE
//
	SelectRow(0, FALSE)
	SelectRow(Row, False)
//	
//	b_flag = False
//END IF

//CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;//IF Row <= 0 THEN
//   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
//   return
//END IF
//
//p_choose.TriggerEvent(Clicked!)
end event

event dw_1::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

IF this.GetColumnName() = "itnbr_new" THEN
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then return
	this.SetItem(row,"itnbr_new",gs_code)
	SetNull(Gs_code)
	SetNull(Gs_codename)
END IF
end event

event dw_1::itemchanged;call super::itemchanged;String ls_itnbrold, ls_itnbrnew

If this.GetColumnName() = "itnbr_old" Then
	ls_itnbrold = this.GetText()
		
	SELECT itnbr
	INTO  :ls_itnbrnew
	FROM  itemas
	WHERE	itnbr = :ls_itnbrold;
	
	if sqlca.sqlcode <> 0 then            // 0 : 정상 , -1 : Error , 100 : Not found
		messageBox('확인','등록되지 않은 품번입니다.')
		this.setitem(1, "itnbr_old", '')	
		dw_1.setfocus()
		dw_1.setcolumn(1)
		return 1
	end if
	this.setitem(1, "itnbr", ls_itnbrnew)
End If
end event

type sle_2 from w_inherite_popup`sle_2 within w_pdt_02140_popup
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdt_02140_popup
end type

type cb_return from w_inherite_popup`cb_return within w_pdt_02140_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdt_02140_popup
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdt_02140_popup
end type

type st_1 from w_inherite_popup`st_1 within w_pdt_02140_popup
end type

type p_mod from uo_picture within w_pdt_02140_popup
integer x = 1349
integer y = 36
integer width = 178
integer taborder = 50
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;String ls_newitnbr, ls_jakjino, ls_jaksino, ls_today, ls_totime, ls_jnpcrt, ls_newipjpno, ls_olditnbr
long	li_faqty, i, ld_jpno, li_ipgoqty

dw_1.AcceptText()

For i = 1 To dw_1.RowCount()
	ls_olditnbr = dw_1.getitemString(i, "itnbr_old")
	ls_newitnbr = dw_1.getitemString(i, "itnbr_new")
	ls_jakjino  = dw_1.getitemString(i, "pordno")
	ls_jaksino  = dw_1.getitemString(i, "shpjpno")
	li_faqty    = dw_1.getitemNumber(i, "faqty")
	li_ipgoqty  = dw_1.getitemNumber(i, "ipgoqty")
	ls_today    = f_today()
	ls_totime	= f_totime()
	
	If li_faqty < 1 Then
		MessageBox("Error","불량수량이 0인 것은 입고처리할 수 없습니다.~r입고처리는 생략하고 다음을 진행합니다.")
		continue;
	End If

	If li_ipgoqty < 1 or isNull(li_ipgoqty) Then
		MessageBox("Error","입고 수량이 0인 것은 처리할 수 없습니다.")
		dw_1.SetFocus()
		dw_1.SetColumn('ipgoqty')
		return
	End If

	If li_ipgoqty > li_faqty  Then
		MessageBox("Error","불량수량보다 입고수량이 클수 없습니다.")
		dw_1.SetFocus()
		dw_1.SetColumn('ipgoqty')
		return
	End If

	ld_jpno = sqlca.fun_junpyo(gs_sabu,ls_today,'CO')
	
	If ld_jpno < 0 Then continue;
	
	Select jnpcrt 
	into   :ls_jnpcrt
	From  iomatrix
	where iogbn = 'I97'
	and   sabu  = :gs_sabu;
	
	If sqlca.sqlcode <> 0 Then
		ls_jnpcrt = '009'
	End If

	ls_newipjpno = ls_today + String(ld_jpno,'0000') + '001'

	Insert Into IMHIST( SABU, IOJPNO, IOGBN, SUDAT, ITNBR, PSPEC, OPSEQ, 
					DEPOT_NO, CVCOD, SAREA, PDTGU,CUST_NO, IOQTY, IOPRC, 
					IOAMT, IOREQTY, INSDAT, INSEMP, QCGUB, IOFAQTY, IOPEQTY, 
					IOSPQTY, IOCDQTY,IOSUQTY, IO_CONFIRM, IO_DATE, IO_EMPNO, 
					LOTSNO, LOTENO, HOLD_NO, ORDER_NO, INV_NO, INV_SEQ, FILSK,
					BALJPNO, BALSEQ, POLCNO, POBLNO, POBLSQ, BIGO, BOTIMH, 
					IP_JPNO, ITGU, SICDAT, MAYYMM, INPCNF,JAKJINO, JAKSINO, 
					JNPCRT, OUTCHK, MAYYSQ, IOREDEPT, IOREEMP, DCRATE, JUKSDAT, 
					JUKEDAT, PRVPRC,AFTPRC, SILQTY, SILAMT, GURDAT, TUKDAT, TUKEMP, 
					TUKQTY, TUKSUDAT, CRT_DATE, CRT_TIME, CRT_USER,UPD_DATE, UPD_TIME, 
					UPD_USER, CHECKNO, PJT_CD, FIELD_CD, AREA_CD, YEBI1, YEBI2, YEBI3, 
					YEBI4,DYEBI1, DYEBI2, DYEBI3, CNVFAT, CNVART, CNVIORE, CNVIOFA, 
					CNVIOPE, CNVIOSP, CNVIOCD, CNVIOSU,GONGQTY, GONGPRC, SAUPJ, CNVGONG, 
					DECISIONYN, SILYOQTY, CHAAMT, OUTPRC, OUTAMT, YEBI5, LOCALDAE, FORAMT, 
					FACGBN, LCLGBN, GUNGBN, PACPRC )
	Select      SABU, :ls_newipjpno, 'I97', :ls_today, :ls_newitnbr, PSPEC, OPSEQ, 
					DEPOT_NO, CVCOD, SAREA, PDTGU, CUST_NO, :li_ipgoqty, IOPRC, 
					IOAMT, :li_ipgoqty, INSDAT, INSEMP, QCGUB, IOFAQTY, IOPEQTY, 
					IOSPQTY, IOCDQTY,IOSUQTY, IO_CONFIRM, IO_DATE, IO_EMPNO, 
					LOTSNO, LOTENO, HOLD_NO, ORDER_NO, INV_NO, INV_SEQ, FILSK,
					BALJPNO, BALSEQ, POLCNO, POBLNO, POBLSQ, BIGO, BOTIMH, 
					IP_JPNO, ITGU, SICDAT, MAYYMM, INPCNF, :ls_jakjino, :ls_jaksino, 
					:ls_jnpcrt, OUTCHK, MAYYSQ, IOREDEPT, IOREEMP, DCRATE, JUKSDAT, 
					JUKEDAT, PRVPRC,AFTPRC, SILQTY, SILAMT, GURDAT, TUKDAT, TUKEMP, 
					TUKQTY, TUKSUDAT, :ls_today, :ls_totime, :gs_userid, NULL, NULL, 
					NULL, CHECKNO, PJT_CD, FIELD_CD, AREA_CD, YEBI1, YEBI2, YEBI3, 
					YEBI4,DYEBI1, DYEBI2, DYEBI3, CNVFAT, CNVART, CNVIORE, CNVIOFA, 
					CNVIOPE, CNVIOSP, CNVIOCD, CNVIOSU,GONGQTY, GONGPRC, SAUPJ, CNVGONG, 
					DECISIONYN, SILYOQTY, CHAAMT, OUTPRC, OUTAMT, YEBI5, LOCALDAE, FORAMT, 
					FACGBN, LCLGBN, GUNGBN, PACPRC 
	From 	IMHIST
	WHERE	JAKJINO =  :ls_jakjino
	and	ITNBR   =  :ls_olditnbr;
	
	If sqlca.sqlcode <> 0 Then
		MessageBox("Error","부적합품 입고를 처리가 실패했습니다.")
		rollback;
		is_rtnstatus = '0'
		return
	Else
		is_rtnstatus = '1'
	End If
Next

If is_rtnstatus ='1' Then
	Commit;
	MessageBox("확인","부적합품 입고 처리가 완료 되었습니다.")
	p_exit.TriggerEvent(Clicked!)
End If
end event

type rr_2 from roundrectangle within w_pdt_02140_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 200
integer width = 1673
integer height = 1500
integer cornerheight = 40
integer cornerwidth = 55
end type

