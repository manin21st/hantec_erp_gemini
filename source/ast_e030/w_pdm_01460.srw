$PBExportHeader$w_pdm_01460.srw
$PBExportComments$기술bom(대량대체)
forward
global type w_pdm_01460 from window
end type
type cbx_1 from checkbox within w_pdm_01460
end type
type p_save from uo_picture within w_pdm_01460
end type
type dw_list1 from datawindow within w_pdm_01460
end type
type dw_2 from datawindow within w_pdm_01460
end type
type st_4 from statictext within w_pdm_01460
end type
type dw_1 from datawindow within w_pdm_01460
end type
type st_3 from statictext within w_pdm_01460
end type
type dw_list from datawindow within w_pdm_01460
end type
type p_exit from uo_picture within w_pdm_01460
end type
type rr_1 from roundrectangle within w_pdm_01460
end type
type rr_2 from roundrectangle within w_pdm_01460
end type
end forward

global type w_pdm_01460 from window
integer width = 3835
integer height = 2064
boolean titlebar = true
string title = "대량 대체"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
cbx_1 cbx_1
p_save p_save
dw_list1 dw_list1
dw_2 dw_2
st_4 st_4
dw_1 dw_1
st_3 st_3
dw_list dw_list
p_exit p_exit
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01460 w_pdm_01460

type variables
string  is_gubun
long   d1_currentRow, d2_currentRow
end variables

forward prototypes
public function integer wf_substitution ()
end prototypes

public function integer wf_substitution ();String  Prv_itnbr,Chg_itnbr
Long	  L_count

dw_1.accepttext()
dw_2.accepttext()
Prv_itnbr = dw_1.getitemstring(1, 1)
Chg_itnbr = dw_2.getitemstring(1, 1)

/* 상위Loop 검색 */
L_count = 0
select count(*)
  Into :L_count
  from (select level, pinbr, cinbr
		  from estruc
		 connect by  prior pinbr = cinbr
		 start with cinbr = :Prv_itnbr) a
 where a.pinbr = :Chg_itnbr;
 
 If L_count > 0 Then Return -1
		 
/* 하위 Loop 검색 */
L_count = 0
select count(*)
  Into :L_count
  from (select level, pinbr, cinbr
		  from estruc
		 connect by  prior cinbr = pinbr
		 start with pinbr =  :Prv_itnbr) a
 where a.Cinbr = :Chg_itnbr;
 
 If L_count > 0 Then Return -2


return 0
end function

event open;f_window_center_response(this)

dw_list.settransobject(sqlca)
dw_list1.settransobject(sqlca)

dw_1.InsertRow(0)
dw_2.InsertRow(0)

dw_1.setcolumn('itnbr')
dw_1.setfocus()
end event

on w_pdm_01460.create
this.cbx_1=create cbx_1
this.p_save=create p_save
this.dw_list1=create dw_list1
this.dw_2=create dw_2
this.st_4=create st_4
this.dw_1=create dw_1
this.st_3=create st_3
this.dw_list=create dw_list
this.p_exit=create p_exit
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.cbx_1,&
this.p_save,&
this.dw_list1,&
this.dw_2,&
this.st_4,&
this.dw_1,&
this.st_3,&
this.dw_list,&
this.p_exit,&
this.rr_1,&
this.rr_2}
end on

on w_pdm_01460.destroy
destroy(this.cbx_1)
destroy(this.p_save)
destroy(this.dw_list1)
destroy(this.dw_2)
destroy(this.st_4)
destroy(this.dw_1)
destroy(this.st_3)
destroy(this.dw_list)
destroy(this.p_exit)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type cbx_1 from checkbox within w_pdm_01460
integer x = 3209
integer y = 184
integer width = 352
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
	For Lrow = 1 to dw_list.rowcount()
		 dw_list.Setitem(Lrow, "choice", 'Y')
	Next
	
	For Lrow = 1 to dw_list1.rowcount()
		 dw_list1.Setitem(Lrow, "choice", 'Y')
	Next
Else
	For Lrow = 1 to dw_list.rowcount()
		 dw_list.Setitem(Lrow, "choice", 'N')
	Next
	
	For Lrow = 1 to dw_list1.rowcount()
		 dw_list1.Setitem(Lrow, "choice", 'N')
	Next
End if
end event

type p_save from uo_picture within w_pdm_01460
integer x = 3429
integer y = 20
integer width = 178
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\대체_up.gif"
end type

event clicked;call super::clicked;
If Messagebox("대체확인", "대체하시겠읍니까?", question!, yesno!) = 2 then
	return
End if

Integer Ichk
Long	  Lrow
String  Chg_itnbr, snull

setnull(snull)

Ichk = wf_substitution()

Choose case Ichk
		 Case -1
				Messagebox("상위Loop", "변경후 품목이 상위에 이미 구성되어 있읍니다", stopsign!)
				Return
		 Case -2
				Messagebox("하위Loop", "변경후 품목이 하위에 이미 구성되어 있읍니다", stopsign!)
				Return
End choose

Chg_itnbr = dw_2.getitemstring(1, 1)
For Lrow = 1 to dw_list.rowcount()
	 If dw_list.object.choice[Lrow] = 'Y' Then
		 dw_list.object.estruc_cinbr[Lrow] = Chg_itnbr
	 End if
Next
For Lrow = 1 to dw_list1.rowcount()
	 If dw_list1.object.choice[Lrow] = 'Y' Then	
		 dw_list1.object.estruc_Pinbr[Lrow] = Chg_itnbr
	 End if
Next

IF dw_list.Update() > 0 And dw_list1.update() > 0 THEN
	COMMIT USING sqlca;
ELSE
	ROLLBACK USING sqlca;
	f_RollBack()
	RETURN
END IF

Messagebox("대체완료", "대체되었읍니다")

dw_list.reset()
dw_list1.reset()

dw_1.setitem(1, "itnbr", snull)	
dw_1.setitem(1, "itdsc", snull)	
dw_1.setitem(1, "ispec", snull)	

dw_1.setcolumn('itnbr')
dw_1.setfocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\대체_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\대체_up.gif"
end event

type dw_list1 from datawindow within w_pdm_01460
integer x = 1947
integer y = 272
integer width = 1806
integer height = 1640
string dragicon = "Rectangle!"
string dataobject = "d_pdm_01460_2"
boolean hscrollbar = true
boolean vscrollbar = true
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

type dw_2 from datawindow within w_pdm_01460
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 338
integer y = 132
integer width = 2871
integer height = 116
integer taborder = 20
string dataobject = "d_pdm_01460_0"
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
		
		p_save.enabled = true
		RETURN 1
	End If
END IF



end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;long    lcount
string	sItem, sName, sName2, sGub, sNull

SetNull(snull)
IF this.GetColumnName() = "itnbr"	THEN
	sItem = trim(this.GetText())
	IF sItem = ''	or		IsNull(sItem)	THEN
		p_save.enabled = false
		this.setitem(1, "itdsc", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN 
	END IF
	SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."GBWAN"       
	  INTO :sName, :sName2, :sGub  
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ITNBR" = :sItem ;
	
	IF sqlca.sqlcode <> 0		THEN
		f_message_chk(33, "[품번]" )
		p_save.enabled = false
		this.setitem(1, "itnbr", snull)	
		this.setitem(1, "itdsc", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN 1
	ELSE
		IF sgub <> 'Y' then
			messagebox("확인", "개발중인 품목입니다." )
			this.setitem(1, "itnbr", snull)	
			this.setitem(1, "itdsc", snull)	
			this.setitem(1, "ispec", snull)	
			dw_list.reset()
			dw_list1.reset()
			RETURN 1
		END IF
		this.setitem(1, "itdsc", sname)	
		this.setitem(1, "ispec", sname2)	
		p_save.enabled = true
	END IF	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sName = trim(this.GetText())
	
	IF sName = ''	or	IsNull(sName)	THEN
		p_save.enabled = false
		this.setitem(1, "itnbr", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN 
	END IF

	SELECT COUNT(*), MAX("ITEMAS"."ITNBR"), MAX("ITEMAS"."ISPEC")
	  INTO :lCount,  :sitem, :sName2
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ITDSC" = :sName AND "ITEMAS"."GBWAN" = 'Y' ;

   if isnull(lcount) then lcount = 0 

	IF lcount = 0	THEN
		p_save.enabled = false
		this.setitem(1, "itnbr", snull)	
		this.setitem(1, "itdsc", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN  1
	ELSEIF lcount = 1 THEN	
		this.setitem(1, "itnbr", sitem)	
		this.setitem(1, "ispec", sname2)	
		p_save.enabled = true
	ELSE
		gs_code = sName
		open(w_itemas_popup5)
		if isnull(gs_code) or gs_code = "" then 
			p_save.enabled = false
			this.setitem(1, "itnbr", snull)	
			this.setitem(1, "itdsc", snull)	
			this.setitem(1, "ispec", snull)	
			return 1
		end if
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "ispec", gs_gubun)
		p_save.enabled = true
	END IF	
END IF

end event

event itemerror;RETURN 1
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
	
	p_save.enabled = true
	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	p_save.enabled = true
	
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	p_save.enabled = true
	
END IF

end event

type st_4 from statictext within w_pdm_01460
integer x = 69
integer y = 168
integer width = 279
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "대체(後)"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_pdm_01460
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 338
integer y = 24
integer width = 2885
integer height = 120
integer taborder = 10
string dataobject = "d_pdm_01460_0"
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
		
		dw_list.Retrieve(gs_code)
		dw_list1.Retrieve(gs_code)
		RETURN 1
	End If
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;long    lcount
string	sItem, sName, sName2, sGub, sNull

SetNull(snull)
IF this.GetColumnName() = "itnbr"	THEN
	sItem = trim(this.GetText())
	IF sItem = ''	or		IsNull(sItem)	THEN
		dw_list.reset()
		dw_list1.reset()
		this.setitem(1, "itdsc", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN 
	END IF
	SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."GBWAN"       
	  INTO :sName, :sName2, :sGub  
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ITNBR" = :sItem ;
	
	IF sqlca.sqlcode <> 0		THEN
		f_message_chk(33, "[품번]" )
		dw_list.reset()
		dw_list1.reset()
		this.setitem(1, "itnbr", snull)	
		this.setitem(1, "itdsc", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN 1
	ELSE
		IF sgub <> 'Y' then
			messagebox("확인", "개발중인 품목입니다." )
			this.setitem(1, "itnbr", snull)	
			this.setitem(1, "itdsc", snull)	
			this.setitem(1, "ispec", snull)	
			dw_list.reset()
			dw_list1.reset()
			RETURN 1
		END IF
		this.setitem(1, "itdsc", sname)	
		this.setitem(1, "ispec", sname2)	
		dw_list.Retrieve(sItem)
		dw_list1.Retrieve(sItem)
	END IF	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sName = trim(this.GetText())
	
	IF sName = ''	or	IsNull(sName)	THEN
		dw_list.reset()
		dw_list1.reset()
		this.setitem(1, "itnbr", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN 
	END IF

	SELECT COUNT(*), MAX("ITEMAS"."ITNBR"), MAX("ITEMAS"."ISPEC")
	  INTO :lCount,  :sitem, :sName2
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ITDSC" = :sName AND "ITEMAS"."GBWAN" = 'Y' ;

   if isnull(lcount) then lcount = 0 

	IF lcount = 0	THEN
		dw_list.reset()
		dw_list1.reset()
		this.setitem(1, "itnbr", snull)	
		this.setitem(1, "itdsc", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN  1
	ELSEIF lcount = 1 THEN	
		this.setitem(1, "itnbr", sitem)	
		this.setitem(1, "ispec", sname2)	
		dw_list.Retrieve(sItem)
		dw_list1.Retrieve(sItem)
	ELSE
		gs_code = sName
		open(w_itemas_popup5)
		if isnull(gs_code) or gs_code = "" then 
			dw_list.reset()
			dw_list1.reset()
			this.setitem(1, "itnbr", snull)	
			this.setitem(1, "itdsc", snull)	
			this.setitem(1, "ispec", snull)	
			return 1
		end if
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "ispec", gs_gubun)
		
		dw_list.Retrieve(gs_code)
		dw_list1.Retrieve(gs_code)
	END IF	
END IF

end event

event itemerror;RETURN 1
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
	
	dw_list.Retrieve(gs_code)
	dw_list1.Retrieve(gs_code)
	
ELSEIF this.GetColumnName() = "itdsc"	THEN
	gs_codename = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	dw_list.Retrieve(gs_code)
	dw_list1.Retrieve(gs_code)
	
ELSEIF this.GetColumnName() = "ispec"	THEN
	gs_gubun = this.GetText()
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = "" then 
		return
   end if
	
	this.SetItem(1, "itnbr", gs_code)
	this.SetItem(1, "itdsc", gs_codename)
	this.SetItem(1, "ispec", gs_gubun)
	
	dw_list.Retrieve(gs_code)
	dw_list1.Retrieve(gs_code)
	
END IF

end event

type st_3 from statictext within w_pdm_01460
integer x = 69
integer y = 56
integer width = 279
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "대체(前)"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_list from datawindow within w_pdm_01460
integer x = 91
integer y = 272
integer width = 1806
integer height = 1640
string dragicon = "Rectangle!"
string dataobject = "d_pdm_01460_1"
boolean hscrollbar = true
boolean vscrollbar = true
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

type p_exit from uo_picture within w_pdm_01460
integer x = 3602
integer y = 20
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type rr_1 from roundrectangle within w_pdm_01460
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 256
integer width = 1838
integer height = 1668
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01460
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1934
integer y = 256
integer width = 1838
integer height = 1668
integer cornerheight = 40
integer cornerwidth = 55
end type

