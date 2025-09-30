$PBExportHeader$w_pdm_01440_copy.srw
$PBExportComments$** 표준공정관리(대량복사)
forward
global type w_pdm_01440_copy from window
end type
type st_2 from statictext within w_pdm_01440_copy
end type
type st_1 from statictext within w_pdm_01440_copy
end type
type p_inq2 from uo_picture within w_pdm_01440_copy
end type
type p_save from uo_picture within w_pdm_01440_copy
end type
type p_exit from uo_picture within w_pdm_01440_copy
end type
type p_can from uo_picture within w_pdm_01440_copy
end type
type p_inq1 from uo_picture within w_pdm_01440_copy
end type
type dw_to from datawindow within w_pdm_01440_copy
end type
type dw_from from datawindow within w_pdm_01440_copy
end type
type dw_2 from datawindow within w_pdm_01440_copy
end type
type dw_1 from datawindow within w_pdm_01440_copy
end type
type rr_3 from roundrectangle within w_pdm_01440_copy
end type
type rr_4 from roundrectangle within w_pdm_01440_copy
end type
type rr_5 from roundrectangle within w_pdm_01440_copy
end type
type rr_1 from roundrectangle within w_pdm_01440_copy
end type
type rr_2 from roundrectangle within w_pdm_01440_copy
end type
end forward

global type w_pdm_01440_copy from window
integer x = 73
integer y = 136
integer width = 3749
integer height = 1976
boolean titlebar = true
string title = "표준공정 단품 복사"
windowtype windowtype = response!
long backcolor = 32106727
st_2 st_2
st_1 st_1
p_inq2 p_inq2
p_save p_save
p_exit p_exit
p_can p_can
p_inq1 p_inq1
dw_to dw_to
dw_from dw_from
dw_2 dw_2
dw_1 dw_1
rr_3 rr_3
rr_4 rr_4
rr_5 rr_5
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01440_copy w_pdm_01440_copy

type variables
string  is_gubun
long   d1_currentRow, d2_currentRow
end variables

event open;f_window_center(this)

dw_from.settransobject(sqlca)
dw_to.settransobject(sqlca)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)


dw_from.InsertRow(0)
dw_to.InsertRow(0)
end event

on w_pdm_01440_copy.create
this.st_2=create st_2
this.st_1=create st_1
this.p_inq2=create p_inq2
this.p_save=create p_save
this.p_exit=create p_exit
this.p_can=create p_can
this.p_inq1=create p_inq1
this.dw_to=create dw_to
this.dw_from=create dw_from
this.dw_2=create dw_2
this.dw_1=create dw_1
this.rr_3=create rr_3
this.rr_4=create rr_4
this.rr_5=create rr_5
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.st_2,&
this.st_1,&
this.p_inq2,&
this.p_save,&
this.p_exit,&
this.p_can,&
this.p_inq1,&
this.dw_to,&
this.dw_from,&
this.dw_2,&
this.dw_1,&
this.rr_3,&
this.rr_4,&
this.rr_5,&
this.rr_1,&
this.rr_2}
end on

on w_pdm_01440_copy.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.p_inq2)
destroy(this.p_save)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_inq1)
destroy(this.dw_to)
destroy(this.dw_from)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.rr_5)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type st_2 from statictext within w_pdm_01440_copy
integer x = 1952
integer y = 204
integer width = 206
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "복사처"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pdm_01440_copy
integer x = 142
integer y = 204
integer width = 206
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "복사원"
boolean focusrectangle = false
end type

type p_inq2 from uo_picture within w_pdm_01440_copy
integer x = 3483
integer y = 24
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sItnbr

if dw_to.AcceptText() = -1 then return 
sItnbr = dw_to.GetItemString(1,"itnbr")

IF sItnbr ="" OR IsNull(sItnbr) THEN
	Messagebox("확 인","복사처 품번을 입력하세요!!")
	Return
END IF

dw_2.Retrieve(sitnbr)	
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

type p_save from uo_picture within w_pdm_01440_copy
integer x = 1541
integer y = 24
integer width = 178
integer taborder = 50
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;
string	sParent,		&
			sWorkPlace, sopseq, sOldItnbr
long		lRow

IF	dw_to.AcceptText() = -1	THEN	RETURN
sParent = trim(dw_to.GetItemString(1, "itnbr"))
sOldItnbr = trim(dw_from.GetItemString(1, "itnbr"))

/////////////////////////////////////////////////////////////////////////////

SetPointer(HourGlass!)

IF dw_2.RowCount() > 0	THEN	

	DELETE FROM ROUTNG_RESOURCE
	 WHERE ITNBR = :sparent AND GUBUN = 'M';
	If SQLCA.SQLCODE <> 0 THEN
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		RollBack;
		Return
	End If
		
	FOR lRow = 1	TO	 dw_2.RowCount()
		dw_2.setitem(lRow, "itnbr", sParent)
		
		sopseq = dw_2.GetItemString(lRow, "opseq")

		// 설비내역 복사
		INSERT INTO ROUTNG_RESOURCE
		 ( ITNBR, OPSEQ, RCODE, GUBUN, SDATE, EDATE, RESHR )
			SELECT :sparent, OPSEQ, RCODE, GUBUN, SDATE, EDATE, RESHR
			  FROM ROUTNG_RESOURCE
			 WHERE ITNBR = :sOldItnbr
				AND OPSEQ = :sopseq
				AND GUBUN = 'M';
		If SQLCA.SQLCODE <> 0 THEN
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			Return
		End If
	NEXT

ELSE
	
	FOR lRow = 1	TO	 dw_1.RowCount()

		dw_2.InsertRow(0)
		dw_2.setitem(lRow, "itnbr", 	sParent)
		
		sopseq = dw_1.GetItemString(lRow, "opseq")
		dw_2.setitem(lRow, "opseq", dw_1.GetItemString(lRow, "opseq"))
		dw_2.setitem(lRow, "opdsc", dw_1.GetItemString(lRow, "opdsc"))
		dw_2.setitem(lRow, "wkctr", dw_1.GetItemString(lRow, "wkctr"))
		dw_2.setitem(lRow, "unitq", dw_1.GetItemNumber(lRow, "unitq"))
		dw_2.setitem(lRow, "stdst", dw_1.GetItemNumber(lRow, "stdst"))
		dw_2.setitem(lRow, "stdmc", dw_1.GetItemNumber(lRow, "stdmc"))
		dw_2.setitem(lRow, "manhr", dw_1.GetItemDecimal(lRow, "manhr"))
		dw_2.setitem(lRow, "mchr",  dw_1.GetItemDecimal(lRow, "mchr"))
		dw_2.setitem(lRow, "purgc", dw_1.GetItemString(lRow, "purgc"))
		dw_2.setitem(lRow, "lastc", dw_1.GetItemString(lRow, "lastc"))
		dw_2.setitem(lRow, "manhr1", dw_1.GetItemDecimal(lRow, "manhr1"))
		dw_2.setitem(lRow, "mchr1",  dw_1.GetItemDecimal(lRow, "mchr1"))
		dw_2.setitem(lRow, "roslt", dw_1.GetItemString(lRow, "roslt"))
		dw_2.setitem(lRow, "twocod",  dw_1.GetItemString(lRow, "twocod"))
		dw_2.setitem(lRow, "path", dw_1.GetItemString(lRow, "path"))
		dw_2.setitem(lRow, "tbcqt",  dw_1.GetItemnumber(lRow, "tbcqt"))
		dw_2.setitem(lRow, "uptgu", dw_1.GetItemString(lRow, "uptgu"))
		dw_2.setitem(lRow, "qcgub", dw_1.GetItemString(lRow, "qcgub"))
		dw_2.setitem(lRow, "ostat", dw_1.GetItemString(lRow, "ostat"))
		dw_2.setitem(lRow, "stdmn", dw_1.GetItemDecimal(lRow, "stdmn"))
		dw_2.setitem(lRow, "depot_no", dw_1.GetItemString(lRow, "depot_no"))
		dw_2.setitem(lRow, "wai_itnbr", dw_1.GetItemString(lRow, "wai_itnbr"))
				
		// 설비내역 복사
		INSERT INTO ROUTNG_RESOURCE
		 ( ITNBR, OPSEQ, RCODE, GUBUN, SDATE, EDATE, RESHR )
			SELECT :sparent, OPSEQ, RCODE, GUBUN, SDATE, EDATE, RESHR
			  FROM ROUTNG_RESOURCE
			 WHERE ITNBR = :sOldItnbr
				AND OPSEQ = :sopseq
				AND GUBUN = 'M';
		If SQLCA.SQLCODE <> 0 THEN
			MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
			RollBack;
			Return
		End If
	NEXT

END IF


SetPointer(Arrow!)

/////////////////////////////////////////////////////////////////////////////

IF dw_2.Update() > 0 THEN			

	FOR lRow = 1	TO	 dw_1.RowCount()		

	sWorkPlace = dw_1.GetItemString(lRow, "wkctr")
	if f_WorkCount(sWorkPlace) = -1 then 
      rollback ;
 		messagebox('확 인', '작업장 갱신 실패')
		return 
	end if	
	NEXT	
	COMMIT USING sqlca;
ELSE
	ROLLBACK USING sqlca;
	f_rollback()
END IF
p_can.TriggerEvent("clicked")
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

type p_exit from uo_picture within w_pdm_01440_copy
integer x = 1888
integer y = 24
integer width = 178
integer taborder = 70
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

type p_can from uo_picture within w_pdm_01440_copy
integer x = 1714
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;String snull

SetNull(snull)

dw_from.reset()
dw_from.insertrow(0)
dw_to.reset()
dw_to.insertrow(0)

dw_1.reset()
dw_2.reset()

dw_from.setcolumn('itnbr')
dw_from.SetFocus()
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

type p_inq1 from uo_picture within w_pdm_01440_copy
integer x = 101
integer y = 24
integer width = 178
integer taborder = 30
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sItnbr

if dw_from.AcceptText() = -1 then return 
sItnbr = dw_from.GetItemString(1,"itnbr")

IF sItnbr ="" OR IsNull(sItnbr) THEN
	Messagebox("확 인","복사원 품번을 입력하세요!!")
   dw_from.setcolumn('itnbr')
   dw_from.setfocus()
	Return
END IF

dw_1.Retrieve(sitnbr)	
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

type dw_to from datawindow within w_pdm_01440_copy
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 1915
integer y = 256
integer width = 1669
integer height = 152
integer taborder = 20
string dataobject = "d_pdm_01440_copy1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "itdsc", gs_codename)
		this.SetItem(1, "ispec", gs_gubun)
		
		p_inq2.TriggerEvent(clicked!)
		RETURN 1
	End If
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sitnbr, sitdsc, sispec, sjijil, sispec_code
integer  ireturn

IF this.getcolumnname() = "itnbr"	THEN
	sitnbr = this.gettext()
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
elseIF this.getcolumnname() = "itdsc"	THEN
	sitdsc = this.gettext()
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
ELSEIF this.getcolumnname() = "ispec"	THEN
	sispec = this.gettext()
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
ELSEIF this.getcolumnname() = "jijil"	THEN
	sjijil = this.gettext()
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
ELSEIF this.getcolumnname() = "ispec_code"	THEN
	sispec_code = this.gettext()
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
end if
dw_2.retrieve(sitnbr)
return  ireturn

end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(gsbom)

IF this.GetColumnName() = "itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	this.setItem(1, "jijil", gsbom)
	
	p_inq2.TriggerEvent(clicked!)
	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	this.setitem(1, "jijil", gsbom)
	
	p_inq2.TriggerEvent(clicked!)
	
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	this.setitem(1, "jijil", gsbom)
	
	p_inq2.TriggerEvent(clicked!)
	
END IF

end event

event itemerror;RETURN 1
end event

type dw_from from datawindow within w_pdm_01440_copy
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 96
integer y = 256
integer width = 1760
integer height = 156
integer taborder = 10
string dataobject = "d_pdm_01440_copy1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "itdsc", gs_codename)
		this.SetItem(1, "ispec", gs_gubun)
		
		p_inq1.TriggerEvent(clicked!)
		RETURN 1
	End If
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sitnbr, sitdsc, sispec, sjijil, sispec_code
integer  ireturn

IF this.getcolumnname() = "itnbr"	THEN
	sitnbr = this.gettext()
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
elseIF this.getcolumnname() = "itdsc"	THEN
	sitdsc = this.gettext()
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
ELSEIF this.getcolumnname() = "ispec"	THEN
	sispec = this.gettext()
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
ELSEIF this.getcolumnname() = "jijil"	THEN
	sjijil = this.gettext()
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
ELSEIF this.getcolumnname() = "ispec_code"	THEN
	sispec_code = this.gettext()
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
end if
dw_1.retrieve(sitnbr)
return  ireturn

end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(gsbom)

IF this.GetColumnName() = "itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	this.setitem(1, "jijil", gsbom)
	
	p_inq1.TriggerEvent(clicked!)
	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	this.setitem(1, "jijil", gsbom)
	
	p_inq1.TriggerEvent(clicked!)
	
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	this.setitem(1, "jijil", gsbom)
	
	p_inq1.TriggerEvent(clicked!)
	
END IF

end event

event itemerror;return 1
end event

type dw_2 from datawindow within w_pdm_01440_copy
integer x = 1920
integer y = 412
integer width = 1751
integer height = 1424
string dragicon = "WinLogo!"
string dataobject = "d_pdm_01440_copy3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event dragdrop;
if is_gubun <> 'dw1'		then	return

if dw_to.AcceptText() = -1		then	return


long		lRow
string	sSeq, 		&
			sParent

// 복사원품번
sParent = trim(dw_to.GetItemString(1, 1))

if isnull(sParent) or  sParent = ''		then
	messagebox("확인", "복사원 품번을 입력하세요.")
	dw_to.Setfocus()
	return
end if



// 공정
sSeq = dw_1.getitemstring(d1_currentrow, "opseq")			

IF this.Find("opseq = '"+sSeq+"' ", 1, this.rowcount()) > 0	THEN	RETURN


lRow = this.Insertrow(0)

this.setitem(lRow, "opseq", sSeq)
this.setitem(lRow, "opdsc", dw_1.GetItemString(d1_currentrow, "opdsc"))
this.setitem(lRow, "wkctr", dw_1.GetItemString(d1_currentrow, "wkctr"))
this.setitem(lRow, "unitq", dw_1.GetItemNumber(d1_currentrow, "unitq"))

this.setitem(lRow, "stdst", dw_1.GetItemNumber(d1_currentrow, "stdst"))
this.setitem(lRow, "stdmc", dw_1.GetItemNumber(d1_currentrow, "stdmc"))
this.setitem(lRow, "manhr", dw_1.GetItemDecimal(d1_currentrow, "manhr"))
this.setitem(lRow, "mchr",  dw_1.GetItemDecimal(d1_currentrow, "mchr"))
this.setitem(lRow, "purgc", dw_1.GetItemString(d1_currentrow, "purgc"))
this.setitem(lRow, "lastc", dw_1.GetItemString(d1_currentrow, "lastc"))
this.setitem(lRow, "manhr1",dw_1.GetItemDecimal(d1_currentrow, "manhr1"))
this.setitem(lRow, "mchr1", dw_1.GetItemDecimal(d1_currentrow, "mchr1"))
this.setitem(lRow, "roslt", dw_1.GetItemString(d1_currentrow, "roslt"))
this.setitem(lRow, "twocod",dw_1.GetItemString(d1_currentrow, "twocod"))
this.setitem(lRow, "path",  dw_1.GetItemString(d1_currentrow, "path"))
this.setitem(lRow, "tbcqt", dw_1.GetItemnumber(d1_currentrow, "tbcqt"))
this.setitem(lRow, "uptgu", dw_1.GetItemString(d1_currentrow, "uptgu"))
this.setitem(lRow, "qcgub", dw_1.GetItemString(d1_currentrow, "qcgub"))
this.setitem(lRow, "ostat", dw_1.GetItemString(d1_currentrow, "ostat"))
this.setitem(lRow, "stdmn", dw_1.GetItemDecimal(d1_currentrow, "stdmn"))
this.setitem(lRow, "depot_no", dw_1.GetItemString(d1_currentrow, "depot_no"))

end event

event clicked;
IF Row < 1  THEN	RETURN

is_gubun = 'dw2'

d2_CurrentRow = Row


this.drag(begin!)
this.selectrow(0, false)
this.selectrow(d2_currentrow, true)

end event

event updatestart;/* Update() function 호출시 user 설정 */
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

event itemerror;RETURN 1
end event

event itemchanged;String  sOpseq, sNull

setnull(sNUll)

IF this.GetColumnName() ="opseq" THEN
	sOpseq = this.GetText()
	
	IF Len(sOpseq) <> 4 THEN
		Messagebox("확 인","공정번호는 4자리여야 합니다.")
		this.setitem(row, "opseq", sNull)	
		Return 1
	END IF
	
	IF Not IsNumber(sOpseq) THEN
		Messagebox("확 인","공정번호는 숫자만 입력할 수 있습니다.")
		this.setitem(row, "opseq", sNull)	
		Return 1
	END IF
	IF sOpseq < '0005' THEN
		Messagebox("확 인","공정번호는 0005 보다 적을 수 없습니다.")
		this.setitem(row, "opseq", sNull)	
		Return 1
	END IF
END IF

end event

type dw_1 from datawindow within w_pdm_01440_copy
integer x = 96
integer y = 412
integer width = 1751
integer height = 1424
string dragicon = "WinLogo!"
string dataobject = "d_pdm_01440_copy2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;
IF Row < 1  THEN	RETURN

is_gubun = 'dw1'

d1_CurrentRow = Row


this.drag(begin!)
this.selectrow(0, false)
this.selectrow(d1_currentrow, true)


end event

event dragdrop;
if is_gubun <> 'dw2'			then	return

if d2_currentrow < 1		then	return

dw_2.DeleteRow(d2_currentrow)





end event

type rr_3 from roundrectangle within w_pdm_01440_copy
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 16
integer width = 229
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pdm_01440_copy
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1509
integer y = 16
integer width = 581
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_pdm_01440_copy
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3456
integer y = 16
integer width = 229
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pdm_01440_copy
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 228
integer width = 1792
integer height = 1624
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01440_copy
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1897
integer y = 228
integer width = 1792
integer height = 1624
integer cornerheight = 40
integer cornerwidth = 55
end type

