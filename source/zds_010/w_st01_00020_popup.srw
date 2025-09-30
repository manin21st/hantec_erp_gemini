$PBExportHeader$w_st01_00020_popup.srw
$PBExportComments$업체별 할당량
forward
global type w_st01_00020_popup from window
end type
type sle_1 from singlelineedit within w_st01_00020_popup
end type
type st_1 from statictext within w_st01_00020_popup
end type
type p_exit from uo_picture within w_st01_00020_popup
end type
type p_mod from uo_picture within w_st01_00020_popup
end type
type p_del from uo_picture within w_st01_00020_popup
end type
type p_ins from uo_picture within w_st01_00020_popup
end type
type st_itdsc from statictext within w_st01_00020_popup
end type
type st_itnbr from statictext within w_st01_00020_popup
end type
type st_orderno from statictext within w_st01_00020_popup
end type
type dw_list from datawindow within w_st01_00020_popup
end type
type rr_2 from roundrectangle within w_st01_00020_popup
end type
end forward

global type w_st01_00020_popup from window
integer x = 1056
integer y = 484
integer width = 2176
integer height = 1472
boolean titlebar = true
string title = "업체별 할당량"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
sle_1 sle_1
st_1 st_1
p_exit p_exit
p_mod p_mod
p_del p_del
p_ins p_ins
st_itdsc st_itdsc
st_itnbr st_itnbr
st_orderno st_orderno
dw_list dw_list
rr_2 rr_2
end type
global w_st01_00020_popup w_st01_00020_popup

type variables
st_carmst stcmt
end variables

on w_st01_00020_popup.create
this.sle_1=create sle_1
this.st_1=create st_1
this.p_exit=create p_exit
this.p_mod=create p_mod
this.p_del=create p_del
this.p_ins=create p_ins
this.st_itdsc=create st_itdsc
this.st_itnbr=create st_itnbr
this.st_orderno=create st_orderno
this.dw_list=create dw_list
this.rr_2=create rr_2
this.Control[]={this.sle_1,&
this.st_1,&
this.p_exit,&
this.p_mod,&
this.p_del,&
this.p_ins,&
this.st_itdsc,&
this.st_itnbr,&
this.st_orderno,&
this.dw_list,&
this.rr_2}
end on

on w_st01_00020_popup.destroy
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_ins)
destroy(this.st_itdsc)
destroy(this.st_itnbr)
destroy(this.st_orderno)
destroy(this.dw_list)
destroy(this.rr_2)
end on

event open;stcmt = Message.PowerObjectparm
f_window_center_response(this)

dw_list.SetTransObject(Sqlca)
dw_list.Retrieve(stcmt.carcode, stcmt.cargbn1, stcmt.cargbn2, stcmt.seq, stcmt.itnbr)

sle_1.Text = stcmt.itnbr

end event

type sle_1 from singlelineedit within w_st01_00020_popup
integer x = 283
integer y = 108
integer width = 571
integer height = 68
integer taborder = 90
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean border = false
boolean displayonly = true
end type

type st_1 from statictext within w_st01_00020_popup
integer x = 87
integer y = 108
integer width = 215
integer height = 68
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "품번 :"
boolean focusrectangle = false
end type

type p_exit from uo_picture within w_st01_00020_popup
integer x = 1957
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;Close(Parent)


end event

type p_mod from uo_picture within w_st01_00020_popup
integer x = 1609
integer y = 24
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;Long nCnt, ix
String sPcode

If dw_list.AcceptText() <> 1 Then Return

nCnt = dw_list.Rowcount()
If nCnt <= 0 Then Return

For ix = nCnt To 1 Step -1
	sPcode = Trim(dw_list.GetItemString(ix,'cvcod'))
	If IsNull(sPcode) Or sPcode = '' Then
		dw_list.DeleteRow(ix)
		Continue
	End If
Next

If dw_list.Update() <> 1 Then
	RollBack;
	f_message_chk(32,'')
	Return
End If

COMMIT;

Close(Parent)
end event

type p_del from uo_picture within w_st01_00020_popup
integer x = 1783
integer y = 24
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;if f_msg_delete() = -1 then return

dw_list.deleterow(0)
IF dw_list.Update() = 1 THEN
	COMMIT;
ELSE
	ROLLBACK;
	f_message_chk(31,'')
	RETURN
END IF

end event

type p_ins from uo_picture within w_st01_00020_popup
integer x = 1435
integer y = 24
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;Long nRow

nRow = dw_list.InsertRow(0)

dw_list.SetItem(nRow, 'carcode', stcmt.carcode)
dw_list.SetItem(nRow, 'cargbn1', stcmt.cargbn1)
dw_list.SetItem(nRow, 'cargbn2', stcmt.cargbn2)
dw_list.SetItem(nRow, 'seq', stcmt.seq)
dw_list.SetItem(nRow, 'itnbr', stcmt.itnbr)

end event

type st_itdsc from statictext within w_st01_00020_popup
boolean visible = false
integer x = 1161
integer y = 164
integer width = 960
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type st_itnbr from statictext within w_st01_00020_popup
boolean visible = false
integer x = 393
integer y = 164
integer width = 411
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type st_orderno from statictext within w_st01_00020_popup
boolean visible = false
integer x = 393
integer y = 84
integer width = 727
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type dw_list from datawindow within w_st01_00020_popup
integer x = 55
integer y = 248
integer width = 2071
integer height = 1096
integer taborder = 10
string dataobject = "d_st01_00020_popup_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Int lRow, lReturnRow
string s_cvcod, sNull, get_nm

SetNull(snull)

IF this.GetColumnName() = "cvcod" THEN
	lRow  = this.GetRow()	
	s_cvcod = this.GetText()								
    
	if s_cvcod = "" or isnull(s_cvcod) then 
		this.setitem(lrow, 'vndmst_cvnas', snull)
		return 
	end if
	
   SELECT "VNDMST"."CVNAS"  
     INTO :get_nm  
     FROM "VNDMST"  
    WHERE "VNDMST"."CVCOD" = :s_cvcod  ;

	if sqlca.sqlcode = 0 then 
		this.setitem(lrow, 'vndmst_cvnas', get_nm)
	else
		this.triggerevent(RbuttonDown!)
	   return 1
   end if	
	
	lReturnRow = This.Find("cvcod = '"+s_cvcod+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
		messagebox('확 인','등록된 거래처입니다. 순번을 증가시켜야 합니다.') 
//		RETURN  1
	END IF
END IF
end event

event itemerror;return 1
end event

event rbuttondown;int lreturnrow, lrow
string snull

setnull(gs_code)
setnull(gs_codename)
setnull(snull)

lrow = this.getrow()

IF this.GetColumnName() = "cvcod" THEN
	gs_code = this.GetText()
	IF Gs_code ="" OR IsNull(gs_code) THEN 
		gs_code =""
	END IF
	
//	gs_gubun = '2'
	Open(w_vndmst_popup)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  
		this.SetItem(lrow, "cvcod", snull)
		this.SetItem(lrow, "vndmst_cvnas", snull)
   	return
   ELSE
		lReturnRow = This.Find("cvcod = '"+gs_code+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
			f_message_chk(37,'[거래처]') 
			this.SetItem(lRow, "cvcod", sNull)
		   this.SetItem(lRow, "vndmst_cvnas", sNull)
			RETURN  1
		END IF
   END IF	

	this.SetItem(lrow, "cvcod", gs_Code)
	this.SetItem(lrow, "vndmst_cvnas", gs_Codename)
END IF

end event

type rr_2 from roundrectangle within w_st01_00020_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 228
integer width = 2085
integer height = 1124
integer cornerheight = 40
integer cornerwidth = 55
end type

