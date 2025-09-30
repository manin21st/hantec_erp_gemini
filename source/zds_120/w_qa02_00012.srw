$PBExportHeader$w_qa02_00012.srw
$PBExportComments$** 개선대책 수립
forward
global type w_qa02_00012 from w_inherite
end type
type dw_1 from datawindow within w_qa02_00012
end type
type dw_print from datawindow within w_qa02_00012
end type
type p_1 from picture within w_qa02_00012
end type
type p_2 from picture within w_qa02_00012
end type
type dw_img from datawindow within w_qa02_00012
end type
type p_3 from picture within w_qa02_00012
end type
type p_4 from picture within w_qa02_00012
end type
type gb_3 from groupbox within w_qa02_00012
end type
type gb_1 from groupbox within w_qa02_00012
end type
end forward

global type w_qa02_00012 from w_inherite
integer x = 5
integer y = 100
integer width = 3447
integer height = 2748
string title = "품질 개선 요구서 발행"
string menuname = ""
boolean minbox = false
windowtype windowtype = response!
dw_1 dw_1
dw_print dw_print
p_1 p_1
p_2 p_2
dw_img dw_img
p_3 p_3
p_4 p_4
gb_3 gb_3
gb_1 gb_1
end type
global w_qa02_00012 w_qa02_00012

type prototypes
FUNCTION boolean CopyFileA(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll" alias for "CopyFileA;Ansi"
end prototypes

type variables
n_wininet inv_ftp
end variables

on w_qa02_00012.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_print=create dw_print
this.p_1=create p_1
this.p_2=create p_2
this.dw_img=create dw_img
this.p_3=create p_3
this.p_4=create p_4
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_print
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.p_2
this.Control[iCurrent+5]=this.dw_img
this.Control[iCurrent+6]=this.p_3
this.Control[iCurrent+7]=this.p_4
this.Control[iCurrent+8]=this.gb_3
this.Control[iCurrent+9]=this.gb_1
end on

on w_qa02_00012.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.dw_print)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.dw_img)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event open;call super::open;f_window_center(This)

/* 이상발생 조치내역 */
dw_insert.settransobject(sqlca)
dw_print.settransobject(sqlca)

if dw_insert.retrieve(gs_code) < 1 then
	dw_insert.insertrow(0)
end if

//SetPointer(Arrow!)
//p_3.postevent(clicked!)

dw_insert.setfocus()
end event

type dw_insert from w_inherite`dw_insert within w_qa02_00012
integer x = 46
integer y = 208
integer width = 3360
integer height = 2400
string dataobject = "d_qa02_00011_a_new"
boolean vscrollbar = true
end type

event dw_insert::itemchanged;string snull, sdata 
Long	 Lrow

Setnull(snull)

this.accepttext()
Lrow = this.getrow()

if this.getcolumnname() = 'balsite_dt' then
	sdata = TRIM(this.gettext())
	if isnull(sdata) or trim(sdata) = '' then return
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[발신일자]');
		this.setitem(1, "balsite_dt", snull)
		return 1
	end if
end if

if this.getcolumnname() = 'jochydat' then
	String ls_baldat
	ls_baldat = Trim(Object.balsite_dt[1])
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

if this.getcolumnname() = 'submit_yn' then
	sdata = TRIM(this.gettext())
	if sdata = 'N' then
		this.setitem(1, "submit_ydt", snull)
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

event dw_insert::rbuttondown;call super::rbuttondown;
string	sItem,sNull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

IF	this.Getcolumnname() = "cvcod"	THEN		
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN 
		this.SetItem(1, "cvcod", snull)
		this.setitem(1, "cvnas", snull)		
	end if
		
	gs_gubun = '1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "cvcod", gs_Code)
	this.setitem(1, "cvnas", gs_CodeName)
END IF
end event

type p_delrow from w_inherite`p_delrow within w_qa02_00012
boolean visible = false
integer x = 4663
integer y = 928
end type

type p_addrow from w_inherite`p_addrow within w_qa02_00012
boolean visible = false
integer x = 4489
integer y = 928
end type

type p_search from w_inherite`p_search within w_qa02_00012
boolean visible = false
integer x = 4850
integer y = 916
integer height = 140
end type

type p_ins from w_inherite`p_ins within w_qa02_00012
boolean visible = false
integer x = 4315
integer y = 928
end type

type p_exit from w_inherite`p_exit within w_qa02_00012
integer x = 3177
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_qa02_00012
boolean visible = false
integer x = 5184
integer y = 928
end type

type p_print from w_inherite`p_print within w_qa02_00012
boolean visible = false
integer x = 3547
integer y = 408
end type

event p_print::clicked;call super::clicked;//gi_page = dw_print.GetItemNumber(1,"last_page")
//OpenWithParm(w_print_options, dw_print)
end event

type p_inq from w_inherite`p_inq within w_qa02_00012
boolean visible = false
integer x = 3529
integer y = 448
end type

event p_inq::clicked;call super::clicked;//Long	 Lrow, Lnam, lcurr, llast
//String siojpno, sCvnas
//
//siojpno = dw_1.getitemstring(1, "iojpno")
//
//If Messagebox("저장확인", "저장후 출력하시겠읍니까?", information!, yesno!) = 1 then
//	if dw_insert.accepttext() = -1 then return
//	
//	if dw_insert.update() = 1 then
//		commit;
//	else
//		rollback;
//		f_rollback()
//	end if
//end if
//
//IF dw_print.retrieve(gs_sabu, siojpno) = -1 THEN
//	cb_print.Enabled =False
//	SetPointer(Arrow!)
//	Return
//ELSE
//		
//	/* 한 건당 5건을 기준으로 출력물이 되어있음 */
////	if mod(dw_print.rowcount(), 5) <> 0 then
////		Lnam = 5 - (truncate(mod(dw_print.rowcount(), 5), 0))
////		llast = dw_print.rowcount()
////		for lrow = 1 to Lnam
////			 lcurr = dw_print.insertrow(0)			
////			 dw_print.object.data[lcurr] = dw_print.object.data[llast]
////			 dw_print.setitem(lcurr, "hanmok", '')
////			 dw_print.setitem(lcurr, "bulname", '')
////			 dw_print.setitem(lcurr, "bulsan", '')
////			 dw_print.setitem(lcurr, "silyoq", 0)
////			 dw_print.setitem(lcurr, "bulqty", 0)
////		Next
////	end if
//	
//	/* 자사거래처명 출력 */
//	SELECT CVNAS
//	  INTO :sCvnas
//	  FROM SYSCNFG, vndmst
//	 WHERE SYSGU = 'C' and SERIAL = '4' and LINENO = '1'
//	 	AND DATANAME = CVCOD;	
//		 
//	dw_print.object.last_text.text = sCvnas
//	
//	cb_print.Enabled =True
//	dw_print.object.datawindow.print.preview="yes"
//END IF
//dw_print.scrolltorow(1)
//SetPointer(Arrow!)
end event

type p_del from w_inherite`p_del within w_qa02_00012
integer x = 3003
end type

event p_del::clicked;call super::clicked;String ls_new 

If dw_insert.Rowcount() < 1 Then Return
If dw_insert.AcceptText() < 1 Then Return

ls_new = Trim(dw_insert.Object.is_new[1])

//dw_insert.deleterow(1)

// 발행취소
dw_insert.Object.status[1] = 'N'

//If ls_new = 'N' Then
	
	if dw_insert.update() = 1 then
		commit;
		
	else
		rollback;
		f_rollback()
	end if
//End If

Close(parent)
end event

type p_mod from w_inherite`p_mod within w_qa02_00012
integer x = 2830
end type

event p_mod::clicked;call super::clicked;if dw_insert.accepttext() = -1 then return

String ls_fagno, ls_baldat , ls_balsite_dt , ls_jochydat ,ls_murmks, ls_submit, ls_submitdt
String ls_sfile, ls_dexe ,ls_remote_f ,ls_result
int    li_p

ls_fagno     = Trim(dw_insert.Object.fagno[1])
ls_baldat   = Trim(dw_insert.Object.balsite_dt[1])
ls_jochydat = Trim(dw_insert.Object.jochydat[1])
ls_murmks   = Trim(dw_insert.Object.murmks[1])
ls_submit	= Trim(dw_insert.Object.submit_yn[1])
ls_submitdt = Trim(dw_insert.Object.submit_ydt[1])
//ls_sfile    = Trim(dw_insert.getitemstring(1,"filename_temp"))

If ls_baldat = '' Or isNull(ls_baldat) Or f_datechk(ls_baldat) < 1 Then 
	f_message_chk(35,'[발신일자]')
	dw_insert.setcolumn("balsite_dt")
	dw_insert.setfocus()
	Return
End If

if ls_submit = 'Y' then
	if f_datechk(ls_submitdt) = -1 then
		f_message_chk(35,'[제출요청일자]')
		dw_insert.setcolumn("submit_ydt")
		dw_insert.setfocus()
		Return
	End If
end if

If ls_murmks = '' Or isNull(ls_murmks) Then 
	f_message_chk(40,'[문제점]')
	dw_insert.setcolumn("murmks")
	dw_insert.setfocus()
	Return
End If
dw_insert.Object.status[1] = 'Y'
dw_insert.AcceptText()

setpointer(hourglass!)
if dw_insert.update() <> 1 then
	rollback ;
	messagebox("저장실패", "품질 개선 요구서 저장 실패!!!")
	return
end if

commit ;

//p_3.postevent(clicked!)
//Messagebox('확인','등록되었습니다.')
Close(parent)
end event

type cb_exit from w_inherite`cb_exit within w_qa02_00012
integer x = 5358
integer y = 588
integer taborder = 110
end type

type cb_mod from w_inherite`cb_mod within w_qa02_00012
integer x = 4352
integer y = 320
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

type cb_ins from w_inherite`cb_ins within w_qa02_00012
integer x = 110
integer y = 3600
end type

type cb_del from w_inherite`cb_del within w_qa02_00012
integer x = 4699
integer y = 320
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

type cb_inq from w_inherite`cb_inq within w_qa02_00012
integer x = 4745
integer y = 604
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

type cb_print from w_inherite`cb_print within w_qa02_00012
integer x = 4763
integer y = 752
integer width = 475
integer taborder = 80
boolean enabled = false
end type

event cb_print::clicked;call super::clicked;gi_page = dw_print.GetItemNumber(1,"last_page")
OpenWithParm(w_print_options, dw_print)
end event

type st_1 from w_inherite`st_1 within w_qa02_00012
integer x = 59
integer y = 3572
end type

type cb_can from w_inherite`cb_can within w_qa02_00012
integer x = 462
integer y = 3616
integer taborder = 90
end type

type cb_search from w_inherite`cb_search within w_qa02_00012
integer x = 1499
integer y = 3636
integer taborder = 100
end type

type dw_datetime from w_inherite`dw_datetime within w_qa02_00012
integer x = 3520
integer y = 2408
end type

type sle_msg from w_inherite`sle_msg within w_qa02_00012
integer x = 411
integer y = 3608
integer height = 48
end type

type gb_10 from w_inherite`gb_10 within w_qa02_00012
integer x = 41
integer y = 3520
end type

type gb_button1 from w_inherite`gb_button1 within w_qa02_00012
integer x = 1193
integer y = 3840
end type

type gb_button2 from w_inherite`gb_button2 within w_qa02_00012
integer x = 1737
integer y = 3864
end type

type dw_1 from datawindow within w_qa02_00012
boolean visible = false
integer x = 3575
integer y = 768
integer width = 590
integer height = 424
boolean bringtotop = true
string dataobject = "d_qa02_00011_1"
boolean border = false
boolean livescroll = true
end type

type dw_print from datawindow within w_qa02_00012
boolean visible = false
integer x = 4251
integer y = 1088
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

type p_1 from picture within w_qa02_00012
boolean visible = false
integer x = 3721
integer y = 384
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\미리보기_up.gif"
boolean focusrectangle = false
end type

event clicked;//
//If dw_insert.Rowcount() < 1 Then Return
//OpenWithParm(w_print_preview, dw_print)	
end event

type p_2 from picture within w_qa02_00012
boolean visible = false
integer x = 1623
integer y = 16
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\그림등록.gif"
boolean focusrectangle = false
end type

event clicked;string docpath, docname[] , ls_exe ,ls_new
integer i, li_cnt, li_rtn, li_filenum , li_r ,li_p , ll_max

li_rtn = GetFileOpenName("Select File", docpath, docname[], &
													"Drawing Paper", &
													+"JPEG Files (*.jpeg;*.jpg),*.jpeg;*.jpg," &
													+"BMP Files (*.bmp),*.bmp," &
													+"GIF Files (*gif),*.gif" ,&
													"C:\", 18)
IF li_rtn < 1 THEN return

li_cnt = Upperbound(docname)

If li_cnt = 1 Then
	dw_insert.setitem(1,"filename_temp",docpath)
	dw_img.Retrieve(string(docpath))
End If


/*
long		ll_v
string	ls_s_path, ls_path, ls_file

// 환경설정 - 공통관리 - SCM 연동관리
select dataname into :ls_s_path from syscnfg
 where sysgu = 'C' and serial = 12 and lineno = '2' ;

ll_v = GetFileOpenName("Upload File 선택",ls_path , ls_file , "JPEG Files (*.JPG),*.JPG,"+ &
																				  "BMP","BITMAP Files (*.BMP),*.BMP")

If ll_v = 1 Then
	ls_s_path = ls_s_path + ls_file
	if FileExists(ls_s_path) Then
		messagebox('확인','동일한 파일명이 존재합니다.~n파일명을 바꾸세요.')
		return
	end if

	If CopyFileA(ls_path,ls_s_path,true) = False Then
		MessageBox('확인','File UpLoad Failed')
		Return
	End If

	dw_insert.Object.filename[1]  = ls_s_path	
	dw_insert.Object.file_yn[1] = 'Y'
End If
*/
end event

type dw_img from datawindow within w_qa02_00012
integer x = 3447
integer y = 1428
integer width = 1216
integer height = 456
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa02_00011_a_jpg"
boolean border = false
boolean livescroll = true
end type

type p_3 from picture within w_qa02_00012
boolean visible = false
integer x = 1413
integer y = 12
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
boolean focusrectangle = false
end type

event clicked;string	ls_sfile, ls_result

SetNull(ls_sfile)

ls_sfile = dw_insert.getitemstring(1, "filename")

If FileExists("c:\erpman\temp\"+ls_sfile) Then
	dw_img.Retrieve("c:\erpman\temp\"+ls_sfile )
Else
	If isNull(ls_sfile) = False Then
		
		ls_result = inv_ftp.of_ftp_getfile(ls_sfile, "c:\erpman\temp\"+ls_sfile,false)
			
		If Len(ls_result) > 0 Then
			
			MessageBox("Connect Failed!", ls_result, StopSign!)
			Return
		End If
		
	End If
	dw_img.Retrieve("c:\erpman\temp\"+ls_sfile )
	
End if

end event

type p_4 from picture within w_qa02_00012
boolean visible = false
integer x = 1801
integer y = 16
integer width = 178
integer height = 144
boolean bringtotop = true
string picturename = "C:\erpman\image\그림취소.gif"
boolean focusrectangle = false
end type

event clicked;String ls_sabu, ls_iojp, ls_sfile

ls_sabu  = dw_insert.GetItemString(dw_insert.GetRow(), "sabu")
ls_iojp  = dw_insert.GetItemString(dw_insert.GetRow(), "iojpno")
ls_sfile = dw_insert.GetItemString(dw_insert.GetRow(), "filename")
	
//그림 삭제 버튼을 클릭시 이미지 경로 삭제
//DB 파일명 바로 삭제
IF f_msg_delete() = 1 THEN
	
	UPDATE IMHFAG SET Filename = '' WHERE SABU = :ls_sabu AND iojpno = :ls_iojp ;

	If sqlca.sqlcode <> 0 Then 
		Rollback;
		MessageBox('삭제실패','삭제실패')
		Return
	ELSE
		Commit;

		dw_insert.setitem(dw_insert.getrow(),"filename_temp","")
		dw_insert.setitem(dw_insert.getrow(),"filename", "")
	
		dw_img.Retrieve("")
		If FileExists("c:\erpman\temp\"+ls_sfile) Then
			FileDelete("c:\erpman\temp\"+ls_sfile)
		End iF
	End If
End IF

//inv_ftp.of_ftp_deletefile(ls_sfile)
end event

type gb_3 from groupbox within w_qa02_00012
boolean visible = false
integer x = 4279
integer y = 276
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
end type

type gb_1 from groupbox within w_qa02_00012
boolean visible = false
integer x = 4667
integer y = 540
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
end type

