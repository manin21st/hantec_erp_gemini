$PBExportHeader$w_pdm_11713.srw
$PBExportComments$외주bom(대량복사-시리즈별)
forward
global type w_pdm_11713 from window
end type
type rb_2 from radiobutton within w_pdm_11713
end type
type rb_1 from radiobutton within w_pdm_11713
end type
type cbx_1 from checkbox within w_pdm_11713
end type
type p_save from uo_picture within w_pdm_11713
end type
type p_inq2 from uo_picture within w_pdm_11713
end type
type p_exit from uo_picture within w_pdm_11713
end type
type p_inq1 from uo_picture within w_pdm_11713
end type
type st_2 from statictext within w_pdm_11713
end type
type st_1 from statictext within w_pdm_11713
end type
type dw_update from datawindow within w_pdm_11713
end type
type dw_1 from datawindow within w_pdm_11713
end type
type dw_to from datawindow within w_pdm_11713
end type
type dw_from from datawindow within w_pdm_11713
end type
type dw_2 from datawindow within w_pdm_11713
end type
type rr_1 from roundrectangle within w_pdm_11713
end type
type rr_2 from roundrectangle within w_pdm_11713
end type
type p_can from uo_picture within w_pdm_11713
end type
type rr_3 from roundrectangle within w_pdm_11713
end type
type rr_4 from roundrectangle within w_pdm_11713
end type
type rr_5 from roundrectangle within w_pdm_11713
end type
type rr_6 from roundrectangle within w_pdm_11713
end type
end forward

global type w_pdm_11713 from window
integer x = 96
integer y = 136
integer width = 3735
integer height = 1968
boolean titlebar = true
string title = "BOM 대량 복사(시리즈별)"
windowtype windowtype = response!
long backcolor = 32106727
rb_2 rb_2
rb_1 rb_1
cbx_1 cbx_1
p_save p_save
p_inq2 p_inq2
p_exit p_exit
p_inq1 p_inq1
st_2 st_2
st_1 st_1
dw_update dw_update
dw_1 dw_1
dw_to dw_to
dw_from dw_from
dw_2 dw_2
rr_1 rr_1
rr_2 rr_2
p_can p_can
rr_3 rr_3
rr_4 rr_4
rr_5 rr_5
rr_6 rr_6
end type
global w_pdm_11713 w_pdm_11713

type variables
string  is_gubun, is_cvcod
long   d1_currentRow, d2_currentRow
str_itnct lstr_sitnct
end variables

event open;is_cvcod = message.stringparm

f_window_center_response(this)

dw_from.settransobject(sqlca)
dw_to.settransobject(sqlca)
dw_update.settransobject(sqlca)

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)

dw_from.InsertRow(0)
dw_to.InsertRow(0)


end event

on w_pdm_11713.create
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cbx_1=create cbx_1
this.p_save=create p_save
this.p_inq2=create p_inq2
this.p_exit=create p_exit
this.p_inq1=create p_inq1
this.st_2=create st_2
this.st_1=create st_1
this.dw_update=create dw_update
this.dw_1=create dw_1
this.dw_to=create dw_to
this.dw_from=create dw_from
this.dw_2=create dw_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.p_can=create p_can
this.rr_3=create rr_3
this.rr_4=create rr_4
this.rr_5=create rr_5
this.rr_6=create rr_6
this.Control[]={this.rb_2,&
this.rb_1,&
this.cbx_1,&
this.p_save,&
this.p_inq2,&
this.p_exit,&
this.p_inq1,&
this.st_2,&
this.st_1,&
this.dw_update,&
this.dw_1,&
this.dw_to,&
this.dw_from,&
this.dw_2,&
this.rr_1,&
this.rr_2,&
this.p_can,&
this.rr_3,&
this.rr_4,&
this.rr_5,&
this.rr_6}
end on

on w_pdm_11713.destroy
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cbx_1)
destroy(this.p_save)
destroy(this.p_inq2)
destroy(this.p_exit)
destroy(this.p_inq1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_update)
destroy(this.dw_1)
destroy(this.dw_to)
destroy(this.dw_from)
destroy(this.dw_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.p_can)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.rr_5)
destroy(this.rr_6)
end on

type rb_2 from radiobutton within w_pdm_11713
integer x = 864
integer y = 64
integer width = 343
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "생산BOM"
end type

event clicked;dw_1.dataobject = 'd_pdm_01555_3'
dw_1.settransobject(sqlca)
end event

type rb_1 from radiobutton within w_pdm_11713
integer x = 503
integer y = 64
integer width = 343
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "설계BOM"
boolean checked = true
end type

event clicked;dw_1.dataobject = 'd_pdm_01470_3'
dw_1.settransobject(sqlca)
end event

type cbx_1 from checkbox within w_pdm_11713
integer x = 3077
integer y = 120
integer width = 357
integer height = 64
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
   		 dw_2.Setitem(Lrow, "opt", 'Y')
    	 end if	 
	Next
	
Else
	For Lrow = 1 to dw_2.rowcount()
		 dw_2.Setitem(Lrow, "opt", 'N')
	Next
	
End if
end event

type p_save from uo_picture within w_pdm_11713
integer x = 1504
integer y = 24
integer width = 178
integer taborder = 50
boolean bringtotop = true
string picturename = "C:\erpman\image\복사_up.gif"
end type

event clicked;call super::clicked;string	sitnbr, sparent, sittyp, scinbr
long		lRow, lrow2, cur_row, lsec2

IF	dw_to.AcceptText() = -1	THEN	RETURN
IF	dw_1.AcceptText() = -1	THEN	RETURN
IF	dw_2.AcceptText() = -1	THEN	RETURN

sitnbr = trim(dw_from.GetItemString(1, "itnbr"))

IF sItnbr ="" OR IsNull(sItnbr) THEN
	Messagebox("확 인","복사원 품번을 입력하세요!!")
   dw_from.setcolumn('itnbr')
   dw_from.setfocus()
	Return
END IF

IF dw_1.RowCount() < 1	THEN	return  
IF dw_2.RowCount() < 1	THEN	return  

IF MessageBox("확인", "자료를 복사 하시겠습니까?", question!, yesno!) = 2	THEN	
	RETURN
End if
/////////////////////////////////////////////////////////////////////////////
SetPointer(HourGlass!)

datastore ds_dan
ds_dan = create datastore	
if dw_1.dataobject = 'd_pdm_01555_3' then
	ds_dan.dataobject  = "d_pdm_11713_pstruc"	
else 
	ds_dan.dataobject  = "d_pdm_11713_estruc"
end if
ds_dan.settransobject(sqlca)	

FOR lRow = 1	TO	 dw_2.RowCount()   //품번을 읽고
   if dw_2.getitemstring(lrow, 'opt') = 'Y' then   //체크품번만 복사
		sparent = dw_2.GetItemString(lRow, "itnbr")
		
		FOR lRow2 = 1	TO	 dw_1.RowCount()  //하위품번을 읽고
			
			// 대체품이면제외한다
			if dw_1.dataobject = 'd_pdm_01555_3' then			
				if dw_1.getitemstring(lrow2, "pstruc_gubun") = '2' then
					continue
				End if
			Else
				if dw_1.getitemstring(lrow2, "estruc_gubun") = '2' then
					continue
				End if				
			End if
			
			// 가상품목이면 하위품목을 복사한다.
			if dw_1.dataobject = 'd_pdm_01555_3' then
				scinbr =  dw_1.getitemstring(lrow2, "pstruc_cinbr")
			else
				scinbr =  dw_1.getitemstring(lrow2, "estruc_cinbr")
			end if
				
			select ittyp into :sittyp from itemas where itnbr = :scinbr;
			if sittyp = '8' then
							 
					 ds_dan.reset()
					 ds_dan.retrieve(scinbr, scinbr)
					 For lsec2 = 1 to ds_dan.rowcount()
						  cur_row = dw_update.insertrow(0)
						  dw_update.setitem(cur_row, "pinbr", sParent)
						  
							if dw_1.dataobject = 'd_pdm_01555_3' then
								  dw_update.setitem(cur_row, "cinbr", ds_dan.getitemstring(lsec2, "pstruc_cinbr"))
							else
								  dw_update.setitem(cur_row, "cinbr", ds_dan.getitemstring(lsec2, "estruc_cinbr"))
							end if						  
						  dw_update.setitem(cur_row, "usseq", ds_dan.GetItemString(lsec2, "usseq"))
						  dw_update.setitem(cur_row, "qtypr", ds_dan.GetItemNumber(lsec2, "qtypr"))
						  dw_update.setitem(cur_row, "gubun", ds_dan.GetItemstring(lsec2, "gubun"))	
						  dw_update.setitem(cur_row, "efrdt", ds_dan.GetItemString(lsec2, "efrdt"))
						  dw_update.setitem(cur_row, "eftdt", ds_dan.GetItemString(lsec2, "eftdt"))
						  dw_update.setitem(cur_row, "dcinbr",ds_dan.GetItemString(lsec2, "dcinbr"))
						  dw_update.setitem(cur_row, "opsno",	ds_dan.GetItemString(lsec2, "opsno"))
						  dw_update.setitem(cur_row, "gubun2",ds_dan.GetItemString(lsec2, "gubun2"))
						  dw_update.setitem(cur_row, "cvcod", is_cvcod)						 
					 Next
					 
					 Continue
			end if					 
		
			
			
			
			cur_row = dw_update.insertrow(0)
			dw_update.setitem(cur_row, "pinbr", sParent)
			if dw_1.dataobject = 'd_pdm_01555_3' then
				dw_update.setitem(cur_row, "cinbr", dw_1.getitemstring(lrow2, "pstruc_cinbr"))
				dw_update.setitem(cur_row, "usseq", dw_1.GetItemString(lRow2, "pstruc_usseq"))
				dw_update.setitem(cur_row, "qtypr", dw_1.GetItemNumber(lRow2, "pstruc_qtypr"))
				dw_update.setitem(cur_row, "gubun", dw_1.GetItemstring(lRow2, "pstruc_gubun"))	
				dw_update.setitem(cur_row, "adtin", dw_1.GetItemNumber(lRow2, "pstruc_adtin"))
				dw_update.setitem(cur_row, "efrdt", dw_1.GetItemString(lRow2, "pstruc_efrdt"))
				dw_update.setitem(cur_row, "eftdt", dw_1.GetItemString(lRow2, "pstruc_eftdt"))
				dw_update.setitem(cur_row, "pcbloc",dw_1.GetItemString(lRow2, "pstruc_pcbloc"))
				dw_update.setitem(cur_row, "dcinbr",dw_1.GetItemString(lRow2, "pstruc_dcinbr"))
				dw_update.setitem(cur_row, "opsno",	dw_1.GetItemString(lRow2, "pstruc_opsno"))
				dw_update.setitem(cur_row, "rmks",	dw_1.GetItemString(lRow2, "pstruc_rmks"))
				dw_update.setitem(cur_row, "gubun2",dw_1.GetItemString(lRow2, "pstruc_gubun2"))
			else
				dw_update.setitem(cur_row, "cinbr", dw_1.getitemstring(lrow2, "estruc_cinbr"))
				dw_update.setitem(cur_row, "usseq", dw_1.GetItemString(lRow2, "estruc_usseq"))
				dw_update.setitem(cur_row, "qtypr", dw_1.GetItemNumber(lRow2, "estruc_qtypr"))
				dw_update.setitem(cur_row, "gubun", dw_1.GetItemstring(lRow2, "estruc_gubun"))	
				dw_update.setitem(cur_row, "adtin", dw_1.GetItemNumber(lRow2, "estruc_adtin"))
				dw_update.setitem(cur_row, "efrdt", dw_1.GetItemString(lRow2, "estruc_efrdt"))
				dw_update.setitem(cur_row, "eftdt", dw_1.GetItemString(lRow2, "estruc_eftdt"))
				dw_update.setitem(cur_row, "pcbloc",dw_1.GetItemString(lRow2, "estruc_pcbloc"))
				dw_update.setitem(cur_row, "dcinbr",dw_1.GetItemString(lRow2, "estruc_dcinbr"))
				dw_update.setitem(cur_row, "opsno",	dw_1.GetItemString(lRow2, "estruc_opsno"))
				dw_update.setitem(cur_row, "rmks",	dw_1.GetItemString(lRow2, "estruc_rmks"))
				dw_update.setitem(cur_row, "gubun2",dw_1.GetItemString(lRow2, "estruc_gubun2"))				
			end if
			
			dw_update.setitem(cur_row, "cvcod", is_cvcod)
   	NEXT
	end if	
NEXT

destroy ds_dan

/////////////////////////////////////////////////////////////////////////////
IF dw_update.Update() > 0 THEN			
   COMMIT USING sqlca;
	Messagebox("복사완료", "복사되었읍니다")
   p_inq2.TriggerEvent(Clicked!)
ELSE
	ROLLBACK;
END IF

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

type p_inq2 from uo_picture within w_pdm_11713
integer x = 3470
integer y = 24
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;String sIttyp, sitcls
String sItnbr

if dw_from.AcceptText() = -1 then return 
if dw_to.AcceptText() = -1 then return 

sItnbr = dw_from.GetItemString(1,"itnbr")
sIttyp = dw_to.GetItemString(1,"ittyp")
sItcls = dw_to.GetItemString(1,"itcls")

IF sItnbr ="" OR IsNull(sItnbr) THEN
	Messagebox("확 인","복사원 품번을 입력하세요!!")
   dw_from.setcolumn('itnbr')
   dw_from.setfocus()
	Return
END IF

IF sIttyp ="" OR IsNull(sIttyp) THEN
	f_message_chk(30,'[품목구분]')
	dw_to.Setcolumn('ittyp')
	dw_to.SetFocus()
	return
END IF
IF sItcls ="" OR IsNull(sItcls) THEN
	f_message_chk(30,'[품목분류]')
	dw_to.Setcolumn('itcls')
	dw_to.SetFocus()
	return
ELSE
	sItcls = sItcls + '%'
END IF

dw_2.Retrieve(sitnbr, sittyp, sitcls, is_cvcod)	

cbx_1.Checked = True

end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

type p_exit from uo_picture within w_pdm_11713
integer x = 1851
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

type p_inq1 from uo_picture within w_pdm_11713
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

type st_2 from statictext within w_pdm_11713
integer x = 1952
integer y = 196
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

type st_1 from statictext within w_pdm_11713
integer x = 142
integer y = 196
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

type dw_update from datawindow within w_pdm_11713
boolean visible = false
integer x = 695
integer y = 2220
integer width = 1303
integer height = 160
string dataobject = "d_pdm_11713_5"
boolean border = false
boolean livescroll = true
end type

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

type dw_1 from datawindow within w_pdm_11713
integer x = 91
integer y = 420
integer width = 1755
integer height = 1404
string dataobject = "d_pdm_01470_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_to from datawindow within w_pdm_11713
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 1911
integer y = 252
integer width = 1659
integer height = 168
integer taborder = 20
string dataobject = "d_pdm_01555_2"
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

event itemchanged;string	s_Itcls, s_Name, s_itt, snull
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
   ireturn = f_get_name2('품목분류2', 'Y', s_itcls, s_name, s_itt)
	This.setitem(1, 'itcls', s_itcls)
   This.setitem(1, 'itnm', s_name)
   dw_2.reset()
	return ireturn 
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

type dw_from from datawindow within w_pdm_11713
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 110
integer y = 252
integer width = 1669
integer height = 168
integer taborder = 10
string dataobject = "d_pdm_01555_1"
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
		
		this.TriggerEvent(ItemChanged!)
	End If
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string	sitnbr, sitdsc, sispec, sjijil, sispec_code
integer ii, ireturn

IF this.getcolumnname() = "itnbr"	THEN
	sitnbr  = this.gettext()
	ireturn = f_get_name4('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
	dw_1.retrieve(sitnbr)
	if dw_to.retrieve(sitnbr) < 1 then 
		dw_to.insertrow(0)
	end if	
   dw_2.reset()
	return ireturn
elseIF this.getcolumnname() = "itdsc"	THEN
	sitdsc  = this.gettext()
	ireturn = f_get_name4('품명', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
	dw_1.retrieve(sitnbr)
	if dw_to.retrieve(sitnbr) < 1 then 
		dw_to.insertrow(0)
	end if	
   dw_2.reset()
	return ireturn
ELSEIF this.getcolumnname() = "ispec"	THEN
	sispec  = this.gettext()
	ireturn = f_get_name4('규격', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
	dw_1.retrieve(sitnbr)
	if dw_to.retrieve(sitnbr) < 1 then 
		dw_to.insertrow(0)
	end if	
   dw_2.reset()
	return  ireturn
ELSEIF this.getcolumnname() = "jijil"	THEN
	sjijil  = this.gettext()
	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
	dw_1.retrieve(sitnbr)
	if dw_to.retrieve(sitnbr) < 1 then 
		dw_to.insertrow(0)
	end if	
   dw_2.reset()
	return  ireturn
ELSEIF this.getcolumnname() = "ispec_code"	THEN
	sispec_code  = this.gettext()
	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)
	this.setitem(1, "itnbr", sitnbr)	
	this.setitem(1, "itdsc", sitdsc)	
	this.setitem(1, "ispec", sispec)
	this.setitem(1, "jijil", sjijil)	
	this.setitem(1, "ispec_code", sispec_code)
	dw_1.retrieve(sitnbr)
	if dw_to.retrieve(sitnbr) < 1 then 
		dw_to.insertrow(0)
	end if	
   dw_2.reset()
	return  ireturn
end if



end event

event rbuttondown;setnull(gs_code)
setnull(gs_codename)
Setnull(Gs_Gubun)

IF this.GetColumnName() = "itnbr"	THEN
	gs_code = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	this.TriggerEvent(ItemChanged!)
	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	this.TriggerEvent(ItemChanged!)
	
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	this.TriggerEvent(ItemChanged!)
	
END IF
end event

event itemerror;return 1
end event

type dw_2 from datawindow within w_pdm_11713
integer x = 1897
integer y = 420
integer width = 1755
integer height = 1404
string dataobject = "d_pdm_11713_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type rr_1 from roundrectangle within w_pdm_11713
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 220
integer width = 1792
integer height = 1624
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_11713
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1883
integer y = 220
integer width = 1792
integer height = 1624
integer cornerheight = 40
integer cornerwidth = 55
end type

type p_can from uo_picture within w_pdm_11713
integer x = 1678
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

type rr_3 from roundrectangle within w_pdm_11713
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

type rr_4 from roundrectangle within w_pdm_11713
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1472
integer y = 16
integer width = 581
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_pdm_11713
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3442
integer y = 16
integer width = 229
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pdm_11713
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 443
integer y = 20
integer width = 791
integer height = 152
integer cornerheight = 40
integer cornerwidth = 55
end type

