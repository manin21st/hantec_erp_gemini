$PBExportHeader$w_pdm_01480.srw
$PBExportComments$기술BOM일괄 완료/취소 처리
forward
global type w_pdm_01480 from window
end type
type cbx_1 from checkbox within w_pdm_01480
end type
type p_save from uo_picture within w_pdm_01480
end type
type p_exit from uo_picture within w_pdm_01480
end type
type p_can from uo_picture within w_pdm_01480
end type
type dw_to from datawindow within w_pdm_01480
end type
type dw_2 from datawindow within w_pdm_01480
end type
type rr_1 from roundrectangle within w_pdm_01480
end type
type p_inq from uo_picture within w_pdm_01480
end type
type p_1 from uo_picture within w_pdm_01480
end type
type p_2 from uo_picture within w_pdm_01480
end type
end forward

global type w_pdm_01480 from window
integer x = 233
integer y = 212
integer width = 4069
integer height = 2056
boolean titlebar = true
string title = "BOM 일괄 처리"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cbx_1 cbx_1
p_save p_save
p_exit p_exit
p_can p_can
dw_to dw_to
dw_2 dw_2
rr_1 rr_1
p_inq p_inq
p_1 p_1
p_2 p_2
end type
global w_pdm_01480 w_pdm_01480

type variables
string  is_gubun
long   d1_currentRow, d2_currentRow
str_itnct lstr_sitnct
end variables

event open;f_window_center_response(this)

dw_to.settransobject(sqlca)
dw_2.settransobject(sqlca)

dw_to.InsertRow(0)
end event

on w_pdm_01480.create
this.cbx_1=create cbx_1
this.p_save=create p_save
this.p_exit=create p_exit
this.p_can=create p_can
this.dw_to=create dw_to
this.dw_2=create dw_2
this.rr_1=create rr_1
this.p_inq=create p_inq
this.p_1=create p_1
this.p_2=create p_2
this.Control[]={this.cbx_1,&
this.p_save,&
this.p_exit,&
this.p_can,&
this.dw_to,&
this.dw_2,&
this.rr_1,&
this.p_inq,&
this.p_1,&
this.p_2}
end on

on w_pdm_01480.destroy
destroy(this.cbx_1)
destroy(this.p_save)
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.dw_to)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.p_inq)
destroy(this.p_1)
destroy(this.p_2)
end on

type cbx_1 from checkbox within w_pdm_01480
integer x = 2290
integer y = 152
integer width = 347
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;Long Lrow

If this.Checked = True Then
	For Lrow = 1 to dw_2.rowcount()
		 if dw_2.getitemstring(lrow, 'usegu') = 'Y' then 
   		 dw_2.Setitem(Lrow, "opt2", 'Y')
  		 else
   		 dw_2.Setitem(Lrow, "opt1", 'Y')
       end if	 
	Next
	
Else
	For Lrow = 1 to dw_2.rowcount()
		 dw_2.Setitem(Lrow, "opt1", 'N')
		 dw_2.Setitem(Lrow, "opt2", 'N')
	Next
	
End if
end event

type p_save from uo_picture within w_pdm_01480
integer x = 3259
integer y = 16
integer width = 178
integer taborder = 50
boolean bringtotop = true
string picturename = "C:\erpman\image\완료취소_up.gif"
end type

event clicked;call super::clicked;string	sitnbr, sparent
long		lRow, lrow2, cur_row

IF	dw_to.AcceptText() = -1	THEN	RETURN
IF	dw_2.AcceptText() = -1	THEN	RETURN

IF dw_2.RowCount() < 1	THEN	return  

IF MessageBox("확인", "선택한 자료를 완료 취소 처리 하시겠습니까?", question!, yesno!) = 2	THEN	
	RETURN
End if
/////////////////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)

FOR lRow = 1	TO	 dw_2.RowCount()   //품번을 읽고
   if dw_2.getitemstring(lrow, 'opt2') = 'Y' then   //체크품번만 복사
		sparent = dw_2.GetItemString(lRow, "itnbr")
		Update ESTRUC
			Set bomend = 'N', upd_user = :gs_userid
		 where pinbr||cinbr IN
					(select pinbr||cinbr
					   from estruc
					connect by prior cinbr = pinbr
					start with pinbr = :sparent);		
	end if	
NEXT

/////////////////////////////////////////////////////////////////////////////
IF sqlca.sqlcode <> 0 THEN			
	ROLLBACK USING sqlca;
	Messagebox("확 인", "취소처리가 실패하였습니다.", StopSign!)
ELSE
   COMMIT USING sqlca;
	Messagebox("취소처리", "취소처리가 완료되었습니다.")
   p_can.TriggerEvent(Clicked!)
END IF

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\완료취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\완료취소_up.gif"
end event

type p_exit from uo_picture within w_pdm_01480
integer x = 3822
integer y = 20
integer width = 178
integer taborder = 70
boolean bringtotop = true
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;
close(parent)


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_pdm_01480
integer x = 3648
integer y = 20
integer width = 178
integer taborder = 60
boolean bringtotop = true
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;String snull

SetNull(snull)

dw_to.reset()
dw_to.insertrow(0)

dw_2.reset()

dw_to.setcolumn('ittyp')
dw_to.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type dw_to from datawindow within w_pdm_01480
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 14
integer y = 8
integer width = 2277
integer height = 220
integer taborder = 10
string dataobject = "d_pdm_01480_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;str_itnct str_sitnct

setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itcls" OR This.GetColumnName() = "ittyp" Then
		this.accepttext()
		gs_code = this.getitemstring(1, 'ittyp')
		
		open(w_ittyp_popup2)
		
		str_sitnct = Message.PowerObjectParm	
		
		if isnull(str_sitnct.s_ittyp) or str_sitnct.s_ittyp = "" then 
			return
		end if
	
		this.SetItem(1,"ittyp", str_sitnct.s_ittyp)
		this.SetItem(1,"itcls", str_sitnct.s_sumgub)
		this.SetItem(1,"itnm", str_sitnct.s_titnm)
		this.SetColumn('itcls')
      dw_2.reset()
		this.SetFocus()
	End If
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	s_Itcls, s_Name, s_itt, snull, s_gubun
int      ireturn 

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
      dw_2.reset()
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_itt)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
		return 1
	else	
		this.SetItem(1,'itcls', snull)
		this.SetItem(1,'itnm', snull)
      dw_2.reset()
   end if
ELSEIF this.GetColumnName() = "itcls"	THEN
	s_itcls = this.gettext()
   s_itt  = this.getitemstring(1, 'ittyp')
   ireturn = f_get_name2('품목분류', 'Y', s_itcls, s_name, s_itt)
	This.setitem(1, 'itcls', s_itcls)
   This.setitem(1, 'itnm', s_name)
   dw_2.reset()
	return ireturn 
ELSEIF this.GetColumnName() = "gub"	THEN
	s_gubun = this.gettext()
	
	if s_gubun = '1' then 
		dw_2.SetFilter("usegu = 'Y'")
	elseif s_gubun = '2' then 	
		dw_2.SetFilter("usegu = 'N'")
	else
		dw_2.SetFilter("")
   end if
	dw_2.Filter( )
END IF
end event

event rbuttondown;string sname

if this.GetColumnName() = 'itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itnm", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
   dw_2.reset()
	this.SetFocus()
end if	
end event

event itemerror;RETURN 1
end event

type dw_2 from datawindow within w_pdm_01480
integer x = 59
integer y = 240
integer width = 3931
integer height = 1676
string dataobject = "d_pdm_01480_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdm_01480
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 228
integer width = 3959
integer height = 1700
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_inq from uo_picture within w_pdm_01480
integer x = 3474
integer y = 20
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sIttyp, sitcls, sitnbr, sGubun
long   k, get_count

if dw_to.AcceptText() = -1 then return 

sIttyp = dw_to.GetItemString(1,"ittyp")
sItcls = dw_to.GetItemString(1,"itcls")
sGubun = dw_to.GetItemString(1,"gub")

IF sIttyp ="" OR IsNull(sIttyp) THEN
	f_message_chk(30,'[품목구분]')
	dw_to.Setcolumn('ittyp')
	dw_to.SetFocus()
	return
END IF
IF sItcls ="" OR IsNull(sItcls) THEN
	sitcls = '%'
//	f_message_chk(30,'[품목분류]')
//	dw_to.Setcolumn('itcls')
//	dw_to.SetFocus()
//	return
ELSE 
	sitcls = sitcls + '%'
END IF

SetPointer(HourGlass!)
dw_2.setredraw(false)

dw_2.SetFilter("")
dw_2.Filter( )
dw_2.Retrieve(sittyp, sitcls)	

FOR k=1 TO dw_2.rowcount() 
	sitnbr = dw_2.getitemstring(k, 'itnbr')

	select count(*)
	  into :get_count
	  from estruc
	 where bomend = 'N'
	connect by prior cinbr = pinbr
	      start with pinbr = :sitnbr ;
	if get_count > 0 then 
      dw_2.setitem(k, 'usegu', 'N')
	else
      dw_2.setitem(k, 'usegu', 'Y')
   end if		
	
NEXT

if sgubun = '1' THEN 
	dw_2.SetFilter("usegu = 'Y'")
	dw_2.Filter( )
elseif sgubun = '2' THEN
	dw_2.SetFilter("usegu = 'N'")
	dw_2.Filter( )
else
	dw_2.SetFilter("")
	dw_2.Filter( )
end if

dw_2.setredraw(true)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type p_1 from uo_picture within w_pdm_01480
integer x = 2912
integer y = 16
integer width = 178
integer taborder = 30
string picturename = "C:\erpman\image\단단계완료_up.gif"
end type

event clicked;call super::clicked;string	sitnbr, sparent
long		lRow, lrow2, cur_row

IF	dw_to.AcceptText() = -1	THEN	RETURN
IF	dw_2.AcceptText() = -1	THEN	RETURN

IF dw_2.RowCount() < 1	THEN	return  

IF MessageBox("확인", "선택한 자료를 단단계 완료 처리 하시겠습니까?", question!, yesno!) = 2	THEN	
	RETURN
End if
/////////////////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)

FOR lRow = 1	TO	 dw_2.RowCount()   //품번을 읽고
   if dw_2.getitemstring(lrow, 'opt1') = 'Y' then   //체크품번만 복사
		sparent = dw_2.GetItemString(lRow, "itnbr")
		Update estruc
			Set bomend = 'Y', upd_user = :gs_userid
		 where pinbr||cinbr IN
					(select pinbr||cinbr
					   from estruc
					where pinbr = :sparent
 			connect by prior cinbr = pinbr
					start with pinbr = :sparent);		
	end if	
NEXT

/////////////////////////////////////////////////////////////////////////////
IF sqlca.sqlcode <> 0 THEN			
	ROLLBACK USING sqlca;
	Messagebox("확 인", "단단계 완료처리가 실패하였습니다.", StopSign!)
ELSE
   COMMIT USING sqlca;
	Messagebox("완료처리", "단단계 완료처리가 완료되었습니다.")
   p_can.TriggerEvent(Clicked!)
END IF

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\단단계완료_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\단단계완료_up.gif"
end event

type p_2 from uo_picture within w_pdm_01480
integer x = 3086
integer y = 16
integer width = 178
integer taborder = 40
string picturename = "C:\erpman\image\다단계완료_up.gif"
end type

event clicked;call super::clicked;string	sitnbr, sparent
long		lRow, lrow2, cur_row

IF	dw_to.AcceptText() = -1	THEN	RETURN
IF	dw_2.AcceptText() = -1	THEN	RETURN

IF dw_2.RowCount() < 1	THEN	return  

IF MessageBox("확인", "선택한 자료를 다단계 완료 처리 하시겠습니까?", question!, yesno!) = 2	THEN	
	RETURN
End if
/////////////////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)

FOR lRow = 1	TO	 dw_2.RowCount()   //품번을 읽고
   if dw_2.getitemstring(lrow, 'opt1') = 'Y' then   //체크품번만 복사
		sparent = dw_2.GetItemString(lRow, "itnbr")
		Update estruc
			Set bomend = 'Y', upd_user = :gs_userid
		 where pinbr||cinbr IN
					(select pinbr||cinbr
					   from estruc
 			connect by prior cinbr = pinbr
					start with pinbr = :sparent);		
	end if	
NEXT

/////////////////////////////////////////////////////////////////////////////
IF sqlca.sqlcode <> 0 THEN			
	ROLLBACK USING sqlca;
	Messagebox("확 인", "다단계 완료처리가 실패하였습니다.", StopSign!)
ELSE
   COMMIT USING sqlca;
	Messagebox("완료처리", "다단계 완료처리가 완료되었습니다.")
   p_can.TriggerEvent(Clicked!)
END IF

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\다단계완료_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\다단계완료_up.gif"
end event

