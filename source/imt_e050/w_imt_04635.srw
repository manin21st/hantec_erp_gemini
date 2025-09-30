$PBExportHeader$w_imt_04635.srw
$PBExportComments$금형/치공구 상태 일괄 변경
forward
global type w_imt_04635 from w_inherite
end type
type dw_1 from datawindow within w_imt_04635
end type
type dw_2 from datawindow within w_imt_04635
end type
type dw_3 from datawindow within w_imt_04635
end type
type st_2 from statictext within w_imt_04635
end type
type st_3 from statictext within w_imt_04635
end type
type rr_1 from roundrectangle within w_imt_04635
end type
type rr_2 from roundrectangle within w_imt_04635
end type
type rr_3 from roundrectangle within w_imt_04635
end type
end forward

global type w_imt_04635 from w_inherite
integer height = 2404
string title = "금형/치공구 상태 일괄 변경"
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
st_2 st_2
st_3 st_3
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_imt_04635 w_imt_04635

forward prototypes
public function integer wf_retrieve ()
public function integer wf_requiredchk ()
end prototypes

public function integer wf_retrieve ();string ls_skumno, ls_ekumno , ls_kstat , ls_kumgubn

If dw_1.AcceptText() <> 1 Then Return -1

ls_skumno = trim(dw_1.object.skumno[1])
ls_ekumno = trim(dw_1.object.ekumno[1])
ls_kstat  = trim(dw_1.object.kstat[1])
ls_kumgubn = trim(dw_1.object.kumgubn[1])

If IsNull(ls_skumno) or ls_skumno = "" Then ls_skumno = '.'
If IsNull(ls_ekumno) or ls_ekumno = "" Then ls_ekumno = 'ZZZZZZZZ'
If IsNull(ls_kumgubn) Or ls_kumgubn = '' Then ls_kumgubn = '%'
if IsNull(ls_kstat) or ls_kstat = ""  then ls_kstat = '%'

if dw_insert.Retrieve(gs_sabu, ls_skumno, ls_ekumno, ls_kstat, ls_kumgubn) <= 0 then
	dw_2.reset()
	dw_3.reset()
	f_message_chk(50,'[금형/치공구 상태 일괄변경]')
	dw_1.Setfocus()
	return -1
end if

dw_insert.setfocus()
return 1
end function

public function integer wf_requiredchk ();//필수입력항목 체크
Long   i, j
STring sKstst

j = dw_insert.RowCount() 

for i = 1 to j
	sKstst = Trim(dw_insert.object.kstat[i])
	
	/* 상태가 폐기인 경우 */
	If sKstst = '4' Then
		If IsNull(Trim(dw_insert.object.pedat[i])) or Trim(dw_insert.object.pedat[i]) = '' Then
			f_message_chk(1400,'[폐기일자]')
			dw_insert.ScrollToRow(i)
			dw_insert.SetColumn('pedat')
			dw_insert.SetFocus()
			Return -1
		End If
		
		If IsNull(Trim(dw_insert.object.pesay[i])) or Trim(dw_insert.object.pesay[i]) = '' Then
			f_message_chk(1400,'[폐기사유]')
			dw_insert.ScrollToRow(i)
			dw_insert.SetColumn('pesay')
			dw_insert.SetFocus()
			Return -1
		End If
	End If
next

return 1

end function

on w_imt_04635.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
this.st_2=create st_2
this.st_3=create st_3
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.rr_3
end on

on w_imt_04635.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)

dw_1.insertrow(0)

end event

type dw_insert from w_inherite`dw_insert within w_imt_04635
integer x = 37
integer y = 260
integer width = 4503
integer height = 1320
integer taborder = 30
string dataobject = "d_imt_04635_2"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::clicked;string ls_kumno

this.SelectRow(0,False)

if Row <= 0 then return
this.SelectRow(Row,TRUE)
ls_kumno = this.getitemstring(row, "kumno") 

dw_2.Retrieve(gs_sabu, ls_kumno) 
dw_3.Retrieve(gs_sabu, ls_kumno) 
	

end event

event dw_insert::rowfocuschanged;string ls_kumno

this.SelectRow(0,False)

if currentrow <= 0 then return

this.SelectRow(currentrow,TRUE)
ls_kumno = this.getitemstring( currentrow , "kumno" ) 

dw_2.Retrieve(gs_sabu, ls_kumno ) 
	
dw_3.Retrieve(gs_sabu, ls_kumno ) 
	
end event

event dw_insert::itemchanged;String sNull, sDateFrom, ls_kstat

SetNull(snull)

Choose Case GetColumnName() 
	Case"pedat"
		sDateFrom = Trim(this.GetText())
		IF sDateFrom = "" OR IsNull(sDateFrom) THEN RETURN
		
		IF f_datechk(sDateFrom) = -1 THEN
			f_message_chk(35,'[폐기일자]')
			this.SetItem(row, "pedat", snull)
			Return 1
		END IF	
		
	Case "kstat" 
		 ls_kstat = Trim(this.Gettext())
		 if ls_kstat = '4' then 
			 this.setitem(row, "pegbn", 'Y')
			 this.setitem(row, "pedat", is_today)
		 else
			 this.setitem(row, "pegbn", 'N' ) 
			 this.setitem(row, "pedat", snull)
			 this.setitem(row, "pesay", snull)
		 end if 
End Choose


end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_imt_04635
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_imt_04635
integer y = 5000
end type

type p_search from w_inherite`p_search within w_imt_04635
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_imt_04635
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_imt_04635
end type

type p_can from w_inherite`p_can within w_imt_04635
end type

event p_can::clicked;call super::clicked;dw_2.reset()
dw_3.reset()
dw_insert.reset()
ib_any_typing = False //입력필드 변경여부 No

end event

type p_print from w_inherite`p_print within w_imt_04635
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_imt_04635
integer x = 3922
end type

event p_inq::clicked;call super::clicked;wf_retrieve()

ib_any_typing = False //입력필드 변경여부 No
	
end event

type p_del from w_inherite`p_del within w_imt_04635
integer y = 5000
end type

type p_mod from w_inherite`p_mod within w_imt_04635
integer x = 4096
end type

event p_mod::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return 
if dw_insert.AcceptText() = -1 then return 

if dw_insert.RowCount() < 1 then return 

if wf_requiredchk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return

IF dw_insert.Update() > 0 THEN	
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	w_mdi_frame.sle_msg.text = "저장작업 실패!"
END IF

ib_any_typing = False //입력필드 변경여부 No

end event

type cb_exit from w_inherite`cb_exit within w_imt_04635
boolean visible = false
integer x = 3355
integer y = 5000
integer taborder = 60
end type

type cb_mod from w_inherite`cb_mod within w_imt_04635
boolean visible = false
integer x = 2670
integer y = 5000
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_imt_04635
integer x = 1294
integer y = 2956
end type

type cb_del from w_inherite`cb_del within w_imt_04635
integer x = 1605
integer y = 2956
end type

type cb_inq from w_inherite`cb_inq within w_imt_04635
boolean visible = false
integer x = 2318
integer y = 5000
integer taborder = 20
end type

type cb_print from w_inherite`cb_print within w_imt_04635
integer y = 2956
end type

type st_1 from w_inherite`st_1 within w_imt_04635
end type

type cb_can from w_inherite`cb_can within w_imt_04635
boolean visible = false
integer x = 3013
integer y = 5000
integer taborder = 50
end type

type cb_search from w_inherite`cb_search within w_imt_04635
integer x = 2309
integer y = 2956
end type





type gb_10 from w_inherite`gb_10 within w_imt_04635
integer x = 14
integer y = 2432
end type

type gb_button1 from w_inherite`gb_button1 within w_imt_04635
end type

type gb_button2 from w_inherite`gb_button2 within w_imt_04635
end type

type dw_1 from datawindow within w_imt_04635
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 18
integer y = 16
integer width = 2574
integer height = 220
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_imt_04635_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemchanged;string skumno , snull , skumnm

setnull(snull)

Choose Case GetColumnName()
	Case 'skumno'
		sKumNo = Trim(GetText())
		IF sKumNo ="" OR IsNull(sKumNo) THEN 
			SetItem(1, "skumnam", sNull)
			Return
		end if
		
		SELECT "KUMNAME"  INTO :sKumNm
		  FROM "KUMMST"
		 WHERE "SABU" = :gs_sabu AND "KUMNO" = :sKumNo;
		
		IF SQLCA.SQLCODE <> 0 THEN	
         F_message_chk(33, "[관리번호: " + sKumNo + "]")
			SetItem(1, "skumnam", sNull)
			SetItem(1, "skumno", sNull)
		ELSE
			SetItem(1, "skumnam", sKumNm)
		END IF
		
  Case 'ekumno'
		sKumNo = Trim(GetText())
		IF sKumNo ="" OR IsNull(sKumNo) THEN 
			SetItem(1, "ekumnam", sNull)
			Return
		end if
		
		SELECT "KUMNAME"  INTO :sKumNm
		  FROM "KUMMST"
		 WHERE "SABU" = :gs_sabu AND "KUMNO" = :sKumNo;
		
		IF SQLCA.SQLCODE <> 0 THEN	
         F_message_chk(33, "[관리번호: " + sKumNo + "]")
			SetItem(1, "ekumnam", sNull)
			SetItem(1, "ekumno", sNull)
		ELSE
			SetItem(1, "ekumnam", sKumNm)
		END IF		

END CHOOSE



end event

event rbuttondown;setNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case GetColumnName()
	/* 금형번호 */
	Case "skumno" 
		OPEN(w_imt_04630_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(1,'skumno', gs_code)
		this.TriggerEvent(itemchanged!)
		
	Case "ekumno" 
		OPEN(w_imt_04630_popup)
		If IsNull(gs_code) Or gs_code = '' Then Return
		
		SetItem(1,'ekumno', gs_code)
		this.TriggerEvent(itemchanged!)

 End Choose
end event

event itemerror;return 1
end event

type dw_2 from datawindow within w_imt_04635
integer x = 37
integer y = 1704
integer width = 2130
integer height = 564
boolean bringtotop = true
string dataobject = "d_imt_04635_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within w_imt_04635
integer x = 2235
integer y = 1704
integer width = 2345
integer height = 564
boolean bringtotop = true
string dataobject = "d_imt_04635_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_imt_04635
integer x = 37
integer y = 1616
integer width = 489
integer height = 48
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
string text = "[ UNIT 이력 ]"
boolean focusrectangle = false
end type

type st_3 from statictext within w_imt_04635
integer x = 2235
integer y = 1616
integer width = 686
integer height = 48
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
string text = "[ 제작/수리 의뢰내역 ]"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_imt_04635
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 1692
integer width = 2176
integer height = 592
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_04635
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2217
integer y = 1692
integer width = 2400
integer height = 592
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_imt_04635
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 252
integer width = 4594
integer height = 1340
integer cornerheight = 40
integer cornerwidth = 55
end type

