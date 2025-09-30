$PBExportHeader$w_pdt_07200.srw
$PBExportComments$자동생성검토화면
forward
global type w_pdt_07200 from w_inherite
end type
type cb_prtinq from commandbutton within w_pdt_07200
end type
type dw_2 from datawindow within w_pdt_07200
end type
type cb_1 from commandbutton within w_pdt_07200
end type
type cbx_1 from checkbox within w_pdt_07200
end type
type cb_2 from commandbutton within w_pdt_07200
end type
type st_2 from statictext within w_pdt_07200
end type
type dw_1 from datawindow within w_pdt_07200
end type
type dw_list from u_d_popup_sort within w_pdt_07200
end type
type p_prtinq from uo_picture within w_pdt_07200
end type
type p_1 from uo_picture within w_pdt_07200
end type
type p_2 from uo_picture within w_pdt_07200
end type
type rr_1 from roundrectangle within w_pdt_07200
end type
type rr_2 from roundrectangle within w_pdt_07200
end type
end forward

global type w_pdt_07200 from w_inherite
integer height = 2400
string title = "자동생성검토"
cb_prtinq cb_prtinq
dw_2 dw_2
cb_1 cb_1
cbx_1 cbx_1
cb_2 cb_2
st_2 st_2
dw_1 dw_1
dw_list dw_list
p_prtinq p_prtinq
p_1 p_1
p_2 p_2
rr_1 rr_1
rr_2 rr_2
end type
global w_pdt_07200 w_pdt_07200

on w_pdt_07200.create
int iCurrent
call super::create
this.cb_prtinq=create cb_prtinq
this.dw_2=create dw_2
this.cb_1=create cb_1
this.cbx_1=create cbx_1
this.cb_2=create cb_2
this.st_2=create st_2
this.dw_1=create dw_1
this.dw_list=create dw_list
this.p_prtinq=create p_prtinq
this.p_1=create p_1
this.p_2=create p_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_prtinq
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.dw_list
this.Control[iCurrent+9]=this.p_prtinq
this.Control[iCurrent+10]=this.p_1
this.Control[iCurrent+11]=this.p_2
this.Control[iCurrent+12]=this.rr_1
this.Control[iCurrent+13]=this.rr_2
end on

on w_pdt_07200.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_prtinq)
destroy(this.dw_2)
destroy(this.cb_1)
destroy(this.cbx_1)
destroy(this.cb_2)
destroy(this.st_2)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.p_prtinq)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;String sDate

select max(widat) into :sDate
  from estima_examination;
  
dw_1.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_2.settransobject(sqlca)

dw_1.insertrow(0)
dw_1.setitem(1, "sdate", sDATE)



end event

type dw_insert from w_inherite`dw_insert within w_pdt_07200
boolean visible = false
integer x = 1243
integer y = 2488
integer width = 709
integer height = 108
integer taborder = 0
boolean enabled = false
boolean hscrollbar = true
boolean vscrollbar = true
end type

type p_delrow from w_inherite`p_delrow within w_pdt_07200
integer x = 4032
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_07200
integer x = 4389
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_07200
integer x = 4187
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_07200
integer x = 4215
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_07200
integer x = 4407
integer y = 4
end type

type p_can from w_inherite`p_can within w_pdt_07200
integer x = 4233
integer y = 4
end type

event p_can::clicked;call super::clicked;dw_list.reset()
dw_1.setfocus()
end event

type p_print from w_inherite`p_print within w_pdt_07200
integer x = 3886
integer y = 4
boolean enabled = false
string picturename = "C:\erpman\image\인쇄_d.gif"
end type

event p_print::clicked;call super::clicked;if dw_2.rowcount() > 0 then
	gi_page = dw_2.GetItemNumber(1,"last_page")
	OpenWithParm(w_print_options, dw_2)
end if


end event

type p_inq from w_inherite`p_inq within w_pdt_07200
integer x = 3365
integer y = 4
string picturename = "C:\erpman\image\조회R_up.gif"
end type

event p_inq::clicked;call super::clicked;String sitnbr, eitnbr, sgubun, sittyp, sitcls, titcls, sdate, sgubun2

if dw_1.accepttext() = -1 then return 

sdate  = trim(dw_1.getitemstring(1, "sdate"))
sittyp = trim(dw_1.getitemstring(1, "ittyp"))
sitcls = dw_1.getitemstring(1, "itcls")
titcls = dw_1.getitemstring(1, "titcls")

sitnbr = dw_1.getitemstring(1, "sitnbr")
eitnbr = dw_1.getitemstring(1, "eitnbr")
sgubun = dw_1.getitemstring(1, "gubun")

IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[계산일자]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	RETURN
END IF

if sgubun = '1' then 
	sgubun = '2%'
	sgubun2 = '%'
elseif sgubun = '2' then 
	sgubun = '2%'
	sgubun2 = 'Y'
elseif sgubun = '3' then 
	sgubun = '3%'
	sgubun2 = '%'
else
	sgubun = '%'
	sgubun2 = '%'
end if

if isnull(sittyp) or trim(sittyp) = '' then sittyp = '%'

if isnull(sitcls) or trim(sitcls) = '' then sitcls = '.'
if isnull(titcls) or trim(titcls) = '' then 
	titcls = 'zzzzzzz'
else
	titcls = titcls  + 'zzzzzzz'
end if
if isnull(sitnbr) or trim(sitnbr) = '' then sitnbr = '.'
if isnull(eitnbr) or trim(eitnbr) = '' then eitnbr = 'ZZZZZZZZZZZZZZZZZZZZZZ'

if dw_list.retrieve(gs_sabu, sitnbr, eitnbr, sgubun, sittyp, sitcls, titcls, sdate, sgubun2) < 1 then
	Messagebox("자동생성", "생성된 자료가 없읍니다")
	dw_1.setfocus()
	return
end if

dw_list.setfocus()
end event

event p_inq::ue_lbuttondown;PictureName = "C:\erpman\image\조회R_dn.gif"
end event

event p_inq::ue_lbuttonup;PictureName = "C:\erpman\image\조회R_up.gif"
end event

type p_del from w_inherite`p_del within w_pdt_07200
integer x = 3538
integer y = 4
end type

event p_del::clicked;call super::clicked;Long Lrow 

Lrow = dw_list.getrow()

if Lrow < 1 then return

if f_msg_delete() = -1 then return

dw_list.deleterow(Lrow)
IF dw_list.Update() > 0		THEN
	COMMIT;

ELSE
	ROLLBACK;
	f_Rollback()
END IF

dw_list.setfocus()
end event

type p_mod from w_inherite`p_mod within w_pdt_07200
integer x = 4059
integer y = 4
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)

IF dw_list.RowCount() < 1			THEN 	RETURN 
////////////////////////////////////////////////////////////////////////
IF dw_list.Update() > 0		THEN
	COMMIT;
   Messagebox("저장완료", "저장이 완료되었읍니다", information!)
ELSE
	ROLLBACK;
	f_Rollback()
END IF

p_can.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type cb_exit from w_inherite`cb_exit within w_pdt_07200
integer x = 4187
integer y = 5000
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_pdt_07200
integer x = 3794
integer y = 5000
integer taborder = 50
end type

type cb_ins from w_inherite`cb_ins within w_pdt_07200
boolean visible = false
integer x = 155
integer y = 2424
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_pdt_07200
integer x = 3803
integer y = 5000
end type

type cb_inq from w_inherite`cb_inq within w_pdt_07200
integer x = 3790
integer y = 5000
integer taborder = 30
end type

type cb_print from w_inherite`cb_print within w_pdt_07200
integer x = 4169
integer y = 5000
integer taborder = 100
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_pdt_07200
end type

type cb_can from w_inherite`cb_can within w_pdt_07200
integer x = 3799
integer y = 5000
integer taborder = 110
end type

type cb_search from w_inherite`cb_search within w_pdt_07200
boolean visible = false
integer x = 517
integer y = 2428
boolean enabled = false
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_07200
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_07200
end type

type cb_prtinq from commandbutton within w_pdt_07200
integer x = 3776
integer y = 5000
integer width = 334
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&Q)"
end type

type dw_2 from datawindow within w_pdt_07200
integer x = 3442
integer y = 172
integer width = 709
integer height = 108
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "발주검토내역"
string dataobject = "d_pdt_07200_3"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_pdt_07200
integer x = 3776
integer y = 5000
integer width = 334
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "구매전송"
end type

type cbx_1 from checkbox within w_pdt_07200
integer x = 2784
integer y = 40
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "전체선택"
end type

event clicked;Long Lrow

if checked then
	text = '전체해제'
	For Lrow = 1 to dw_list.rowcount()
		 if dw_list.getitemstring(Lrow, "blynd") <> '3' then	// 전송완료가 아닌 자료만 가능
			 dw_list.setitem(Lrow, "choice", 'Y')
		 end if
	Next
else
	text = '전체선택'
	For Lrow = 1 to dw_list.rowcount()
		 if dw_list.getitemstring(Lrow, "blynd") <> '3' then	// 전송완료가 아닌 자료만 가능		
			 dw_list.setitem(Lrow, "choice", 'N')
		 end if
	Next	
end if
end event

type cb_2 from commandbutton within w_pdt_07200
integer x = 4160
integer y = 5000
integer width = 471
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "전송취소"
end type

type st_2 from statictext within w_pdt_07200
integer x = 32
integer y = 244
integer width = 2647
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = " [ 소요량에 대한 현황 조회는 Double Click을 하시면 조회할 수 있읍니다. ]"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_pdt_07200
event ue_key pbm_dwnkey
event ue_processenter pbm_dwnprocessenter
integer x = 9
integer y = 8
integer width = 3195
integer height = 220
integer taborder = 10
string dataobject = "d_pdt_07200_2"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_processenter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;String colname, sittyp
str_itnct lstr_sitnct

SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

colname = this.getcolumnname()

if colname = "sitnbr" then
   gs_gubun = '3'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"sitnbr",gs_code)
elseif colname = "eitnbr" then
   gs_gubun = '3'
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"eitnbr",gs_code)
elseif this.GetColumnName() = 'itcls' then

	sIttyp = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
elseif this.GetColumnName() = 'titcls' then

	sIttyp = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"titcls", lstr_sitnct.s_sumgub)
end if		

end event

event itemchanged;String sitnbr, sItdsc, sIspec, sdate
integer ireturn
Long Lrow

Lrow = getrow()

IF GetColumnName() = "sdate"	THEN
	sDate  = trim(this.gettext())
	
	if sdate = '' or isnull(sdate) then return 
	
	IF f_datechk(sDate) = -1 then
		f_message_chk(35,'[계산일자]')
		this.setitem(1, "sdate", f_today())
		return 1
	END IF
ELSEIF GetColumnName() = "sitnbr"	THEN
	sItnbr = trim(GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	setitem(lrow, "sitnbr", sitnbr)	
	setitem(lrow, "sitdsc", sitdsc)		
	RETURN ireturn
ELSEIF GetColumnName() = "sitdsc"	THEN
	sItdsc = trim(GetText())
	ireturn = f_get_name2('품명', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	setitem(lrow, "sitnbr", sitnbr)	
	setitem(lrow, "sitdsc", sitdsc)	
	RETURN ireturn
ELSEIF GetColumnName() = "eitnbr"	THEN
	sItnbr = trim(GetText())
	ireturn = f_get_name2('품번', 'N', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	setitem(lrow, "eitnbr", sitnbr)	
	setitem(lrow, "eitdsc", sitdsc)		
	RETURN ireturn
ELSEIF GetColumnName() = "eitdsc"	THEN
	sItdsc = trim(GetText())
	ireturn = f_get_name2('품명', 'Y', sitnbr, sitdsc, sispec)    //1이면 실패, 0이 성공	
	setitem(lrow, "eitnbr", sitnbr)	
	setitem(lrow, "eitdsc", sitdsc)	
	RETURN ireturn	
End if
end event

event itemerror;return 1
end event

type dw_list from u_d_popup_sort within w_pdt_07200
integer x = 32
integer y = 324
integer width = 4553
integer height = 1940
integer taborder = 20
string dataobject = "d_pdt_07200_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_list::doubleclicked;call super::doubleclicked;if row > 0 then
	gs_code 		= getitemstring(row, "estima_examination_itnbr")
	gs_codename = getitemstring(row, "itemas_itdsc")
	open(w_pdt_07400)
	SEtnull(gs_code)
	SEtnull(gs_codename)
end if
end event

event clicked;call super::clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
	SetRow(row)
END IF

CALL SUPER ::CLICKED
end event

type p_prtinq from uo_picture within w_pdt_07200
integer x = 3712
integer y = 4
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "c:\erpman\image\조회_up.gif"
end type

event clicked;String sitnbr, eitnbr, sgubun, sittyp, sitcls, titcls, sdate

if dw_1.accepttext() = -1 then return 

sdate  = trim(dw_1.getitemstring(1, "sdate"))

IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[계산일자]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	RETURN
END IF

sittyp = trim(dw_1.getitemstring(1, "ittyp"))
sitcls = dw_1.getitemstring(1, "itcls")
titcls = dw_1.getitemstring(1, "titcls")
sitnbr = dw_1.getitemstring(1, "sitnbr")
eitnbr = dw_1.getitemstring(1, "eitnbr")
sgubun = dw_1.getitemstring(1, "gubun")

if sgubun = '1' then 
	sgubun = '2%'
elseif sgubun = '2' then 
	sgubun = '2%'
elseif sgubun = '3' then 
	sgubun = '3%'
else
	sgubun = '%'
end if

if isnull(sittyp) or trim(sittyp) = '' then sittyp = '%'
if isnull(sitcls) or trim(sitcls) = '' then sitcls = '.'
if isnull(titcls) or trim(titcls) = '' then 
	titcls = 'zzzzzzz'
else
	titcls = titcls  + 'zzzzzzz'
end if

if isnull(sitnbr) or trim(sitnbr) = '' then sitnbr = '.'
if isnull(eitnbr) or trim(eitnbr) = '' then eitnbr = 'ZZZZZZZZZZZZZZZZZZZZZZ'

if dw_2.retrieve(gs_sabu, sitnbr, eitnbr, sgubun, sittyp, sitcls, titcls, sdate) < 1 then
	Messagebox("자동생성", "생성된 자료가 없읍니다")
	dw_1.setfocus()
	return
else
	Messagebox("자동생성", "조회완료")	
	p_print.enabled = true
	p_print.PictureName = "c:\erpman\image\인쇄_up.gif"
end if


end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\조회_dn.gif"
end event

type p_1 from uo_picture within w_pdt_07200
integer x = 4233
integer y = 152
integer width = 178
boolean bringtotop = true
string picturename = "C:\ERPMAN\image\구매전송_up.gif"
end type

event clicked;if dw_list.rowcount() < 1 then
	Messagebox("자료선택", "자료선택후 실행하십시요", stopsign!)
	return
end if

if messagebox("구매전송", "자료는 자동으로 저장된 후 전송됩니다", question!, yesno!) = 2 then
	return
end if

Long Lrow

if dw_list.accepttext() = -1 then return 
For Lrow = 1 to dw_list.rowcount()
	 if dw_list.getitemstring(Lrow, "choice") = 'Y' and dw_list.getitemstring(Lrow, "blynd") = '2' then
		 dw_list.setitem(Lrow, "blynd", 'X')	
	 end if
Next

IF dw_list.Update() > 0		THEN
	COMMIT;
   Messagebox("저장완료", "저장이 완료되었읍니다", information!)
ELSE
	ROLLBACK;
	f_Rollback()
END IF


// 구매전송

Insert into estima
		(sabu, 		estno, 			estgu, 		itnbr, 			pspec, 			unprc, 
		 cvcod, 		guqty, 			vnqty,	  	widat, 			
		 yodat, 		blynd, 			rdate, 		
		 rdptno, 	order_no, 		rempno, 		sempno, 		   project_no, 
		 itgu, 		plncrt, 			yongdo, 		ipdpt, 			prcgu, 			tuncu, 
		 gurmks,   	sakgu, 			choyo, 		baljutime, 		opseq, 			suipgu, 
		 baljpno, 	balseq, 			pordno,	  	autcrt, 
		 cnvfat,    cnvqty,        cnvart,     cnvprc, 
		 yebi1,     saupj  )
Select sabu, 		estno, 			estgu, 		itnbr, 			pspec, 			unprc, 
		 cvcod, 		guqty, 			vnqty,	  	widat, 			
		 yodat, 		'2',	 			rdate, 		
		 rdptno, 	order_no, 		rempno, 		sempno, 		   project_no, 
		 itgu, 		'4', 				yongdo, 		ipdpt, 			prcgu, 			tuncu, 
		 gurmks,   	sakgu, 			choyo, 		baljutime, 		opseq, 			suipgu, 
		 baljpno, 	balseq, 			pordno,	  	autcrt,
       FUN_GET_CNV(itnbr, '1', 0), 
       FUN_GET_CNV(itnbr, '3', vnqty), 
       decode(FUN_GET_CNV(itnbr, '2', 0), 1, '*', '/'), 
       FUN_GET_CNV(itnbr, '4', unprc), 
		 FUN_GET_ITNACC(itnbr, '4'), saupj 
  From estima_examination
 where sabu = :gs_sabu and blynd = 'X';
 
If sqlca.sqlcode <> 0 then
	rollback;
	Messagebox("구매전송", "구매전송 작업이 실패하였읍니다", stopsign!)
else
	
	Update Estima_examination
	   set blynd = '3'
	 where sabu = :gs_sabu and blynd = 'X';		
	 
	If sqlca.sqlcode <> 0 then
		rollback;
		Messagebox("구매전송", "구매전송 작업이 실패하였읍니다", stopsign!)
	else	 
		commit;
		
		p_inq.triggerevent(clicked!)
	end if
end if

end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\ERPMAN\image\구매전송_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "C:\ERPMAN\image\구매전송_dn.gif"
end event

type p_2 from uo_picture within w_pdt_07200
integer x = 4407
integer y = 152
integer width = 178
boolean bringtotop = true
string picturename = "C:\ERPMAN\image\전송취소_up.gif"
end type

event clicked;call super::clicked;string sdate

if dw_1.accepttext() = -1 then return 

sdate  = trim(dw_1.getitemstring(1, "sdate"))

IF isnull(sDate) or sDate = "" 	THEN
	f_message_chk(30,'[계산일자]')
	dw_1.SetColumn("sdate")
	dw_1.SetFocus()
	RETURN
END IF

gs_code = sdate

open(w_pdt_07300)
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\ERPMAN\image\전송취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "C:\ERPMAN\image\전송취소_dn.gif"
end event

type rr_1 from roundrectangle within w_pdt_07200
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 312
integer width = 4594
integer height = 1972
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdt_07200
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 3387
integer y = 160
integer width = 832
integer height = 136
integer cornerheight = 40
integer cornerwidth = 55
end type

