$PBExportHeader$w_qa02_00020.srw
$PBExportComments$** 개선대책 검토/승인
forward
global type w_qa02_00020 from w_inherite
end type
type rr_1 from roundrectangle within w_qa02_00020
end type
type dw_1 from datawindow within w_qa02_00020
end type
type dw_print from datawindow within w_qa02_00020
end type
type p_upgw from p_print within w_qa02_00020
end type
type dw_2 from u_key_enter within w_qa02_00020
end type
type gb_3 from groupbox within w_qa02_00020
end type
type gb_1 from groupbox within w_qa02_00020
end type
type rr_2 from roundrectangle within w_qa02_00020
end type
end forward

global type w_qa02_00020 from w_inherite
integer x = 5
integer y = 100
integer width = 5573
integer height = 2980
string title = "개선대책 검토/승인"
string menuname = ""
boolean maxbox = true
boolean resizable = true
rr_1 rr_1
dw_1 dw_1
dw_print dw_print
p_upgw p_upgw
dw_2 dw_2
gb_3 gb_3
gb_1 gb_1
rr_2 rr_2
end type
global w_qa02_00020 w_qa02_00020

type variables

end variables

forward prototypes
public subroutine wf_initial ()
end prototypes

public subroutine wf_initial ();dw_1.reset()
dw_2.reset()
dw_insert.Reset()

dw_2.InsertRow(0)
dw_insert.InsertRow(0)

dw_2.setitem(1,'sdate',left(f_today(),6)+'01')
dw_2.setitem(1,'edate',f_today())
dw_2.SetFocus()

ib_any_typing = false
end subroutine

on w_qa02_00020.create
int iCurrent
call super::create
this.rr_1=create rr_1
this.dw_1=create dw_1
this.dw_print=create dw_print
this.p_upgw=create p_upgw
this.dw_2=create dw_2
this.gb_3=create gb_3
this.gb_1=create gb_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_print
this.Control[iCurrent+4]=this.p_upgw
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.gb_3
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.rr_2
end on

on w_qa02_00020.destroy
call super::destroy
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.dw_print)
destroy(this.p_upgw)
destroy(this.dw_2)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)

wf_initial()
end event

type dw_insert from w_inherite`dw_insert within w_qa02_00020
integer x = 23
integer y = 944
integer width = 4530
integer height = 1340
string dataobject = "d_qa02_00020_a"
boolean border = false
end type

event dw_insert::itemchanged;string snull, sdata 
Long	 Lrow

Setnull(snull)

this.accepttext()
Lrow = this.getrow()

if this.getcolumnname() = 'baldat' then
	sdata = TRIM(this.gettext())
	if isnull(sdata) or trim(sdata) = '' then return
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[발신일자]');
		this.setitem(1, "baldat", snull)
		return 1
	end if
end if

if this.getcolumnname() = 'jochydat' then
	String ls_baldat
	ls_baldat = Trim(Object.baldat[1])
	sdata = TRIM(this.gettext())
	
	if isnull(sdata) or trim(sdata) = '' then return 1
	if f_datechk(sdata) = -1  Or Long(ls_baldat) > Long(sdata) then
		f_message_chk(35,'[조치요청일]');
		this.setitem(1, "jochydat", snull)
		return 1
	end if
end if

if this.getcolumnname() = 'jochwdat' then
	sdata = TRIM(this.gettext())	
	if isnull(sdata) or trim(sdata) = '' then return		
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[조치완료일]');
		this.setitem(1, "jochwdat", snull)
		return 1		
	end if
	if trim(this.getitemstring(1, "jochydat")) > sdata then
		f_message_chk(34,'[조치요청일]');
		this.setitem(1, "jochwdat", snull)
		return 1					
	end if
end if


end event

event dw_insert::itemerror;return 1
end event

event dw_insert::ue_pressenter;Choose Case Lower(GetColumnName())
	Case "murmks" , "datrmks"
		Return
	Case Else
		Send(Handle(this),256,9,0)
		Return 1
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_qa02_00020
boolean visible = false
integer x = 5225
integer y = 1572
end type

type p_addrow from w_inherite`p_addrow within w_qa02_00020
boolean visible = false
integer x = 5051
integer y = 1572
end type

type p_search from w_inherite`p_search within w_qa02_00020
boolean visible = false
integer x = 5413
integer y = 1560
integer height = 140
end type

type p_ins from w_inherite`p_ins within w_qa02_00020
boolean visible = false
integer x = 4878
integer y = 1572
end type

type p_exit from w_inherite`p_exit within w_qa02_00020
integer x = 4370
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_qa02_00020
integer x = 4197
end type

event p_can::clicked;call super::clicked;wf_initial()
end event

type p_print from w_inherite`p_print within w_qa02_00020
boolean visible = false
integer x = 5006
integer y = 32
end type

event p_print::clicked;call super::clicked;//gi_page = dw_print.GetItemNumber(1,"last_page")
//OpenWithParm(w_print_options, dw_print)

//
//If dw_insert.Rowcount() < 1 Then Return
//OpenWithParm(w_print_preview, dw_print)	
end event

type p_inq from w_inherite`p_inq within w_qa02_00020
integer x = 3849
end type

event p_inq::clicked;call super::clicked;string ssdate, sedate, scvcod, sstatus, snull, spdtgu

if dw_2.accepttext() = -1 then return

ssdate  = trim(dw_2.getitemstring(1, "sdate"))
sedate  = trim(dw_2.getitemstring(1, "edate"))
scvcod  = Trim(dw_2.getitemstring(1, "cvcod"))
sstatus = Trim(dw_2.getitemstring(1, "status"))
spdtgu  = dw_2.getitemstring(1, "pdtgu")

if isnull(ssdate) or trim(ssdate) = '' then
	ssdate = '10000101'
end if

if isnull(sedate) or trim(sedate) = '' then
	sedate = '99991231'
end if

if isnull(scvcod) or trim(scvcod) = '' then scvcod = '%'
	
dw_1.setredraw(false)
if dw_1.retrieve(gs_saupj, ssdate, sedate, scvcod, sstatus, spdtgu) < 1 then
   f_message_chk(50, '[부적합 통보서 발행]')
end if

dw_1.setredraw(true)
end event

type p_del from w_inherite`p_del within w_qa02_00020
boolean visible = false
integer x = 4809
integer y = 28
end type

event p_del::clicked;call super::clicked;//String ls_new 
//
//If dw_insert.Rowcount() < 1 Then Return
//If dw_insert.AcceptText() < 1 Then Return
//
//ls_new = Trim(dw_insert.Object.is_new[1])
//
//dw_insert.deleterow(1)
//
//If ls_new = 'N' Then
//	
//	if dw_insert.update() = 1 then
//		commit;
//		
//	else
//		rollback;
//		f_rollback()
//	end if
//End If
//
//CloseWithReturn(parent , "OK")
end event

type p_mod from w_inherite`p_mod within w_qa02_00020
integer x = 4023
end type

event p_mod::clicked;call super::clicked;If dw_insert.accepttext() = -1 then return
If dw_insert.RowCount() < 1 then return


string	ls_new_yn, ls_jochwdat

ls_new_yn = Trim(dw_insert.Object.is_new[1])
if ls_new_yn = 'Y' then return

ls_jochwdat = Trim(dw_insert.Object.jochwdat[1])
if isnull(ls_jochwdat) or ls_jochwdat = '' then
else
	If f_datechk(ls_jochwdat) < 1 Then 
		f_message_chk(35,'[조치완료일]')
		dw_insert.setcolumn("jochwdat")
		dw_insert.setfocus()
		Return
	End If
end if

if f_msg_update() = -1 then return

if dw_insert.update() = 1 then
	commit;
	
else
	rollback;
	f_rollback()
end if

end event

type cb_exit from w_inherite`cb_exit within w_qa02_00020
boolean visible = false
integer x = 5083
integer y = 360
integer taborder = 110
end type

type cb_mod from w_inherite`cb_mod within w_qa02_00020
boolean visible = false
integer x = 4923
integer y = 1132
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;if dw_insert.accepttext() = -1 then return

if    (isnull(dw_insert.getitemstring(1, "jochydat"))  and &
	not isnull(dw_insert.getitemstring(1, "jochwdat"))) then
	    Messagebox("조치일", "요청일 또는 완료일이 부정확합니다", stopsign!)
		 dw_insert.setcolumn("jochwdat")
		 dw_insert.setfocus()	
	return
end if

if    (isnull(dw_insert.getitemstring(1, "jochydat")) and &
	not isnull(dw_insert.getitemstring(1, "murmks")))   or &
  (not isnull(dw_insert.getitemstring(1, "jochydat")) and &
	    isnull(dw_insert.getitemstring(1, "murmks"))) Then 
	    Messagebox("조치요청일", "조치요청일 또는 문제점이 부정확 합니다", stopsign!)
		 dw_insert.setcolumn("jochydat")
		 dw_insert.setfocus()			 
	  	 return
end if

if    (isnull(dw_insert.getitemstring(1, "jochwdat")) and &
	not isnull(dw_insert.getitemstring(1, "datrmks")))   or &
  (not isnull(dw_insert.getitemstring(1, "jochwdat")) and &
	    isnull(dw_insert.getitemstring(1, "datrmks"))) Then 
	    Messagebox("조치완료일", "조치완료일 또는 대책이 부정확 합니다", stopsign!)
		 dw_insert.setcolumn("jochwdat")
		 dw_insert.setfocus()
	  	 return
end if

if dw_insert.update() = 1 then
	commit;
	close(parent)
else
	rollback;
	f_rollback()
end if


end event

type cb_ins from w_inherite`cb_ins within w_qa02_00020
boolean visible = false
integer x = 69
integer y = 2376
end type

type cb_del from w_inherite`cb_del within w_qa02_00020
boolean visible = false
integer x = 5271
integer y = 1132
integer taborder = 60
end type

event cb_del::clicked;call super::clicked;dw_insert.deleterow(1)

if dw_insert.update() = 1 then
	commit;
	close(parent)
else
	rollback;
	f_rollback()
end if

end event

type cb_inq from w_inherite`cb_inq within w_qa02_00020
boolean visible = false
integer x = 4955
integer y = 656
integer width = 475
integer taborder = 70
end type

event cb_inq::clicked;call super::clicked;Long	 Lrow, Lnam, lcurr, llast
String siojpno, sCvnas
siojpno = dw_1.getitemstring(1, "iojpno")

If Messagebox("저장확인", "저장후 출력하시겠읍니까?", information!, yesno!) = 1 then
	if dw_insert.accepttext() = -1 then return
	
	if dw_insert.update() = 1 then
		commit;
	else
		rollback;
		f_rollback()
	end if
end if

IF dw_print.retrieve(gs_sabu, siojpno) = -1 THEN
	cb_print.Enabled =False
	SetPointer(Arrow!)
	Return
ELSE
		
	/* 한 건당 5건을 기준으로 출력물이 되어있음 */
	if mod(dw_print.rowcount(), 5) <> 0 then
		Lnam = 5 - (truncate(mod(dw_print.rowcount(), 5), 0))
		llast = dw_print.rowcount()
		for lrow = 1 to Lnam
			 lcurr = dw_print.insertrow(0)			
			 dw_print.object.data[lcurr] = dw_print.object.data[llast]
			 dw_print.setitem(lcurr, "hanmok", '')
			 dw_print.setitem(lcurr, "bulname", '')
			 dw_print.setitem(lcurr, "bulsan", '')
			 dw_print.setitem(lcurr, "silyoq", 0)
			 dw_print.setitem(lcurr, "bulqty", 0)
		Next
	end if
	
	/* 자사거래처명 출력 */
	SELECT CVNAS
	  INTO :sCvnas
	  FROM SYSCNFG, vndmst
	 WHERE SYSGU = 'C' and SERIAL = '4' and LINENO = '1'
	 	AND DATANAME = CVCOD;	
		 
	dw_print.object.last_text.text = sCvnas
	
	cb_print.Enabled =True
	dw_print.object.datawindow.print.preview="yes"
END IF
dw_print.scrolltorow(1)
SetPointer(Arrow!)

end event

type cb_print from w_inherite`cb_print within w_qa02_00020
boolean visible = false
integer x = 4974
integer y = 804
integer width = 475
integer taborder = 80
boolean enabled = false
end type

event cb_print::clicked;call super::clicked;gi_page = dw_print.GetItemNumber(1,"last_page")
OpenWithParm(w_print_options, dw_print)
end event

type st_1 from w_inherite`st_1 within w_qa02_00020
boolean visible = false
integer y = 2572
end type

type cb_can from w_inherite`cb_can within w_qa02_00020
boolean visible = false
integer x = 421
integer y = 2392
integer taborder = 90
end type

type cb_search from w_inherite`cb_search within w_qa02_00020
boolean visible = false
integer x = 1458
integer y = 2412
integer taborder = 100
end type

type dw_datetime from w_inherite`dw_datetime within w_qa02_00020
boolean visible = false
integer y = 2572
end type

type sle_msg from w_inherite`sle_msg within w_qa02_00020
boolean visible = false
integer y = 2572
end type

type gb_10 from w_inherite`gb_10 within w_qa02_00020
boolean visible = false
integer y = 2520
end type

type gb_button1 from w_inherite`gb_button1 within w_qa02_00020
boolean visible = false
end type

type gb_button2 from w_inherite`gb_button2 within w_qa02_00020
boolean visible = false
end type

type rr_1 from roundrectangle within w_qa02_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 932
integer width = 4571
integer height = 1360
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_qa02_00020
integer x = 27
integer y = 236
integer width = 4544
integer height = 648
boolean bringtotop = true
string dataobject = "d_qa02_00020_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;string 	syn, snull

setnull(snull)

If this.GetColumnName() = "jochyn" Then
	syn = this.gettext()
	
	if syn = 'Y' then
		this.setitem(row,'jochwdat',f_today())
	else
		this.setitem(row,'jochwdat',snull)
	end if		
	
End If

end event

event clicked;If Row <= 0 then
	this.SelectRow(0,False)
	return
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF

string	saupj, sjpno, sdate

saupj = this.getitemstring(row,'saupj')
sjpno= this.getitemstring(row,'iojpno')

dw_insert.setredraw(false)
if dw_insert.retrieve(saupj,sjpno) < 1 then
	dw_insert.insertrow(0)
else
	sdate = trim(dw_insert.getitemstring(1,'jochwdat'))
	if isnull(sdate) or sdate = '' then
//		dw_insert.setitem(1,'jochwdat',f_today())
	end if
end if
dw_insert.setredraw(true)

end event

type dw_print from datawindow within w_qa02_00020
boolean visible = false
integer x = 4928
integer y = 1756
integer width = 1435
integer height = 1356
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "원부자재 문제점 통보서"
string dataobject = "d_qa02_00021_p"
boolean minbox = true
boolean maxbox = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_upgw from p_print within w_qa02_00020
integer x = 4864
integer y = 356
integer taborder = 50
boolean bringtotop = true
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\결재상신_up.gif"
end type

event clicked;String ls_iojpno ,ls_submit_yn ,ls_gw_status

if dw_insert.accepttext() = -1 then return -1

ls_iojpno    = Trim(dw_insert.object.iojpno[1])
ls_submit_yn = Trim(dw_insert.object.submit_yn[1])
ls_gw_status = Trim(dw_insert.object.gw_status[1])

if ls_iojpno = "" or isnull(ls_iojpno) then
	F_Message_Chk(50,'[발행번호]')
	Return
END IF

if ls_submit_yn <> "Y" then
	MessageBox('확인','해당 부적합 통보서에는 개선대책이 수립되지 않았습니다. 결재의뢰가 불가능합니다.')
	Return
END IF

If ls_gw_status <> "1" AND ls_gw_status <> "0" Then
	MessageBox('확인','결재상신 중입니다. 결재의뢰가 불가능합니다.')
	Return
End If

//그룹웨어 연동구분
//STRING s_gwgbn
//
//Select dataname into :s_gwgbn
//	from syscnfg
//	where sysgu = 'W' and
//		 serial = 1 and
//		 lineno = '1';
//
///* 전자결제 상신 */
//IF s_gwgbn = 'Y'  then
//	if Wf_Insert_kfz19ot9gw(ls_date) = -1 then
//		F_MessageChk(13,'[전자결재 상신 자료]')
//		Rollback;
//		Return
//	else
//		Commit;
//	end if
	
	gs_code  = "&sabu=1&iojpno=" + ls_iojpno + ""
	gs_gubun = '0000000081'	//그룹웨어 문서번호
	SetNull(gs_codename)
	
	WINDOW LW_WINDOW
	OpenSheetWithParm(lw_window, 'w_groupware_browser', 'w_groupware_browser', w_mdi_frame, 0, Layered!)
//END IF
end event

event ue_lbuttondown;PictureName = 'C:\erpman\image\결재상신_dn.gif'
end event

event ue_lbuttonup;PictureName = 'C:\erpman\image\결재상신_up.gif'
end event

type dw_2 from u_key_enter within w_qa02_00020
integer x = 5
integer y = 8
integer width = 2843
integer height = 208
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_qa02_00020_3"
boolean border = false
end type

event itemchanged;call super::itemchanged;String	scode, sname, snull

setnull(snull)

// 공급업체
IF this.GetColumnName() = 'cvcod' THEN
	scode = this.gettext()
	
	select cvnas2 into :sname from vndmst
	 where cvcod = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(1,'cvnas',sname)
	else
		this.setitem(1,'cvcod',snull)
		this.setitem(1,'cvnas',snull)
		return 1
	end if
END IF
end event

event rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)


// 공급업체
IF this.GetColumnName() = 'cvcod' THEN
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(1,'cvcod',gs_code)
	this.TriggerEvent(itemchanged!)

END IF
end event

event itemerror;call super::itemerror;return 1
end event

type gb_3 from groupbox within w_qa02_00020
boolean visible = false
integer x = 4850
integer y = 1088
integer width = 850
integer height = 168
integer taborder = 120
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_qa02_00020
boolean visible = false
integer x = 4878
integer y = 592
integer width = 631
integer height = 360
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "원부자재 통보서"
borderstyle borderstyle = stylelowered!
end type

type rr_2 from roundrectangle within w_qa02_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 232
integer width = 4571
integer height = 664
integer cornerheight = 40
integer cornerwidth = 55
end type

