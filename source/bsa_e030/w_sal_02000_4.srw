$PBExportHeader$w_sal_02000_4.srw
$PBExportComments$수주 등록(생산항목별 조건 입력)
forward
global type w_sal_02000_4 from window
end type
type p_exit from uo_picture within w_sal_02000_4
end type
type p_mod from uo_picture within w_sal_02000_4
end type
type p_del from uo_picture within w_sal_02000_4
end type
type p_ins from uo_picture within w_sal_02000_4
end type
type dw_1 from datawindow within w_sal_02000_4
end type
type st_itdsc from statictext within w_sal_02000_4
end type
type st_itnbr from statictext within w_sal_02000_4
end type
type st_orderno from statictext within w_sal_02000_4
end type
type dw_list from datawindow within w_sal_02000_4
end type
type rr_1 from roundrectangle within w_sal_02000_4
end type
type rr_2 from roundrectangle within w_sal_02000_4
end type
end forward

global type w_sal_02000_4 from window
integer x = 1056
integer y = 484
integer width = 2176
integer height = 1472
boolean titlebar = true
string title = "생산항목별 조건 입력"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_mod p_mod
p_del p_del
p_ins p_ins
dw_1 dw_1
st_itdsc st_itdsc
st_itnbr st_itnbr
st_orderno st_orderno
dw_list dw_list
rr_1 rr_1
rr_2 rr_2
end type
global w_sal_02000_4 w_sal_02000_4

on w_sal_02000_4.create
this.p_exit=create p_exit
this.p_mod=create p_mod
this.p_del=create p_del
this.p_ins=create p_ins
this.dw_1=create dw_1
this.st_itdsc=create st_itdsc
this.st_itnbr=create st_itnbr
this.st_orderno=create st_orderno
this.dw_list=create dw_list
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_exit,&
this.p_mod,&
this.p_del,&
this.p_ins,&
this.dw_1,&
this.st_itdsc,&
this.st_itnbr,&
this.st_orderno,&
this.dw_list,&
this.rr_1,&
this.rr_2}
end on

on w_sal_02000_4.destroy
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.p_del)
destroy(this.p_ins)
destroy(this.dw_1)
destroy(this.st_itdsc)
destroy(this.st_itnbr)
destroy(this.st_orderno)
destroy(this.dw_list)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;String sIspec, sJijil, sIspecCode
/* gs_code : 품번
   gs_codename : 품명
	gs_gubun : 수주번호 */
dw_1.InsertRow(0)

If IsNull(gs_gubun) Or Trim(gs_gubun) = '' Then
	Close(this)
	Return
End If

SELECT ISPEC, JIJIL, ISPEC_CODE
  INTO :sIspec, :sJijil, :sIspecCode
  FROM ITEMAS
 WHERE ITNBR = :gs_code;
   
dw_1.SetItem(1, 'order_no', gs_gubun)
dw_1.SetItem(1, 'itnbr',	 gs_code)
dw_1.SetItem(1, 'itdsc',	 gs_codename)
dw_1.SetItem(1, 'ispec',	 sIspec)
dw_1.SetItem(1, 'jijil',	 sJijil)
dw_1.SetItem(1, 'ispec_code',	 sIspecCode)

dw_list.SetTransObject(Sqlca)
dw_list.Retrieve(gs_sabu, gs_gubun)

f_window_center_response(this)
end event

type p_exit from uo_picture within w_sal_02000_4
integer x = 1957
integer y = 24
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;Close(Parent)


end event

type p_mod from uo_picture within w_sal_02000_4
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
	sPcode = Trim(dw_list.GetItemString(ix,'pcode'))
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

type p_del from uo_picture within w_sal_02000_4
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

type p_ins from uo_picture within w_sal_02000_4
integer x = 1435
integer y = 24
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;Long nRow

nRow = dw_list.InsertRow(0)

dw_list.SetItem(nRow, 'sabu', gs_sabu)
dw_list.SetItem(nRow, 'order_no', gs_gubun)
end event

type dw_1 from datawindow within w_sal_02000_4
integer x = 55
integer y = 184
integer width = 2071
integer height = 300
integer taborder = 70
string dataobject = "d_sal_02000_41"
boolean border = false
boolean livescroll = true
end type

type st_itdsc from statictext within w_sal_02000_4
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

type st_itnbr from statictext within w_sal_02000_4
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

type st_orderno from statictext within w_sal_02000_4
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

type dw_list from datawindow within w_sal_02000_4
integer x = 55
integer y = 520
integer width = 2071
integer height = 824
integer taborder = 10
string dataobject = "d_sal_02000_4"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long   nRow, nFnd
String sPcode

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'pcode'
		sPcode = Trim(GetText())
		
		nFnd = Find("pcode = '" + sPcode + "'",1,RowCount())
		If nFnd > 0 And nFnd <> nRow Then
			f_message_chk(1,'')
			Return 2
		End If
End Choose
end event

type rr_1 from roundrectangle within w_sal_02000_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 172
integer width = 2085
integer height = 324
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sal_02000_4
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 50
integer y = 512
integer width = 2085
integer height = 840
integer cornerheight = 40
integer cornerwidth = 55
end type

