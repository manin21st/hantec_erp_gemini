$PBExportHeader$w_sal_01900.srw
$PBExportComments$견적의뢰 승인 등록
forward
global type w_sal_01900 from w_inherite
end type
type dw_1 from u_key_enter within w_sal_01900
end type
type gb_2 from groupbox within w_sal_01900
end type
type gb_3 from groupbox within w_sal_01900
end type
type rr_1 from roundrectangle within w_sal_01900
end type
end forward

global type w_sal_01900 from w_inherite
string title = "견적의뢰 승인 등록"
dw_1 dw_1
gb_2 gb_2
gb_3 gb_3
rr_1 rr_1
end type
global w_sal_01900 w_sal_01900

forward prototypes
public function string wf_sts (string arg_ofno)
end prototypes

public function string wf_sts (string arg_ofno);Long nCnt, nDic

SELECT COUNT(*) , SUM(DECODE( CFMDATE, NULL, 0, 1) ) 
  INTO :nCnt, :nDic
  FROM OFDETL
 WHERE SABU = :gs_sabu AND
       OFNO = :arg_ofno;

If IsNull(nDic) Or nDic = 0 Then Return '1'
If IsNull(nCnt) Or nCnt = 0 Then Return '1'

If nCnt = nDic Then
	Return '2'
Else
	Return '1'
End If

Return '1'
end function

on w_sal_01900.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_3
this.Control[iCurrent+4]=this.rr_1
end on

on w_sal_01900.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
dw_insert.settransobject(sqlca)

dw_1.insertrow(0)
dw_1.setitem(1,'sdate',left(f_today(),6) + '01' )
dw_1.setitem(1,'edate',left(f_today(),8))

end event

type dw_insert from w_inherite`dw_insert within w_sal_01900
integer x = 174
integer y = 264
integer width = 4261
integer height = 2024
integer taborder = 10
string dataobject = "d_sal_01900"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::dberror;call super::dberror;RETURN 1
end event

event dw_insert::error;call super::error;RETURN
end event

event dw_insert::itemchanged;call super::itemchanged;Long nRow, nFind
String sChk, sCstNo

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName()
	Case 'choice'
		sChk = GetText()
		
		If sChk = 'Y' Then
			sCstNo = GetItemString(nRow, 'calcsth_cstno')
			
			nFind = Find("choice = 'Y' and calcsth_cstno = '" + sCstNo + "'",1, RowCount())
			If nFind > 0 And nFind <> nRow Then
				MessageBox('확 인','견적계산내역은 하나만 선택할 수 있습니다.!!')
				Return 2
			End If
		End If
End Choose

end event

event constructor;call super::constructor;//Modify("ispec_t.text = '" + f_change_name('2') + "'" )
//Modify("jijil_t.text = '" + f_change_name('3') + "'" )
//
end event

type p_delrow from w_inherite`p_delrow within w_sal_01900
boolean visible = false
integer x = 3552
integer y = 2784
end type

type p_addrow from w_inherite`p_addrow within w_sal_01900
boolean visible = false
integer x = 3378
integer y = 2784
end type

type p_search from w_inherite`p_search within w_sal_01900
boolean visible = false
integer x = 2683
integer y = 2784
end type

type p_ins from w_inherite`p_ins within w_sal_01900
boolean visible = false
integer x = 3205
integer y = 2784
end type

type p_exit from w_inherite`p_exit within w_sal_01900
end type

type p_can from w_inherite`p_can within w_sal_01900
end type

event p_can::clicked;call super::clicked;dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)
dw_1.setitem(1,'sdate',left(f_today(),6) + '01' )
dw_1.setitem(1,'edate',left(f_today(),8))

end event

type p_print from w_inherite`p_print within w_sal_01900
boolean visible = false
integer x = 2857
integer y = 2784
end type

type p_inq from w_inherite`p_inq within w_sal_01900
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string ls_sdate , ls_edate, sGubun, sEmpno

if dw_1.accepttext() <> 1 then return

ls_sdate = Trim(dw_1.getitemstring(1,'sdate'))
ls_edate = Trim(dw_1.getitemstring(1,'edate'))
sGubun   = Trim(dw_1.getitemstring(1,'gubun'))
sEmpno   = Trim(dw_1.getitemstring(1,'empno'))
If IsNull(sEmpNo) then sEmpNo = ''

if ls_sdate = "" or isnull(ls_sdate) then
	f_message_chk(30,'[접수일자 FROM]')
	dw_1.setcolumn('sdate')
	dw_1.setfocus()
	return
end if

if ls_edate = "" or isnull(ls_edate) then
	f_message_chk(30,'[접수일자 TO]')
	dw_1.setcolumn('edate')
	dw_1.setfocus()
	return
end if

if dw_insert.retrieve(gs_sabu, ls_sdate, ls_edate, sgubun, sEmpNo+'%') < 1 then
	f_message_chk(300,'')
	dw_1.setcolumn('sdate')
	dw_1.setfocus()
	return
end if
end event

type p_del from w_inherite`p_del within w_sal_01900
boolean visible = false
integer x = 3899
integer y = 2784
end type

type p_mod from w_inherite`p_mod within w_sal_01900
integer x = 4096
end type

event p_mod::clicked;call super::clicked;String sGubun, sday
Long i

if messagebox('확인','저장하시겠습니까',Question!,YesNo! ,1) <> 1 then return

if dw_1.accepttext() <> 1 then return 

sGubun = dw_1.GetItemString(1, 'gubun')
If sGubun = '0' Then
	sGubun = '1'
	sDay	 = is_today
Else
	sGubun = '0'
	SetNull(sDay)
End If

for i = 1 to dw_insert.rowcount()
	if dw_insert.getitemstring(i,'chk') <> 'Y' then Continue

	dw_insert.setitem(i,'ofsts', 	  sGubun)
	dw_insert.setitem(i,'ofokdate', sDay)
next

If dw_insert.update() <> 1 then 
	rollback using sqlca;
	w_mdi_frame.sle_msg.text='저장에 실패하였습니다.'
Else
	commit using sqlca;	
	p_inq.TriggerEvent(Clicked!)
	w_mdi_frame.sle_msg.text='저장에 성공하였습니다.'
End If
end event

type cb_exit from w_inherite`cb_exit within w_sal_01900
boolean visible = false
integer x = 3913
integer y = 3152
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_sal_01900
boolean visible = false
integer x = 3237
integer y = 3152
integer taborder = 60
end type

event cb_mod::clicked;call super::clicked;//String sGubun, sday
//Long i
//
//if messagebox('확인','저장하시겠습니까',Question!,YesNo! ,1) <> 1 then return
//
//if dw_1.accepttext() <> 1 then return 
//
//sGubun = dw_1.GetItemString(1, 'gubun')
//If sGubun = '0' Then
//	sGubun = '1'
//	sDay	 = is_today
//Else
//	sGubun = '0'
//	SetNull(sDay)
//End If
//
//for i = 1 to dw_insert.rowcount()
//	if dw_insert.getitemstring(i,'chk') <> 'Y' then Continue
//
//	dw_insert.setitem(i,'ofsts', 	  sGubun)
//	dw_insert.setitem(i,'ofokdate', sDay)
//next
//
//If dw_insert.update() <> 1 then 
//	rollback using sqlca;
//	sle_msg.text='저장에 실패하였습니다.'
//Else
//	commit using sqlca;	
//	cb_inq.TriggerEvent(Clicked!)
//	sle_msg.text='저장에 성공하였습니다.'
//End If
end event

type cb_ins from w_inherite`cb_ins within w_sal_01900
integer x = 722
integer y = 2724
integer taborder = 50
end type

type cb_del from w_inherite`cb_del within w_sal_01900
integer x = 1184
integer y = 2800
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_sal_01900
boolean visible = false
integer x = 169
integer y = 3204
integer taborder = 80
end type

event cb_inq::clicked;call super::clicked;//string ls_sdate , ls_edate, sGubun, sEmpno
//
//if dw_1.accepttext() <> 1 then return
//
//ls_sdate = Trim(dw_1.getitemstring(1,'sdate'))
//ls_edate = Trim(dw_1.getitemstring(1,'edate'))
//sGubun   = Trim(dw_1.getitemstring(1,'gubun'))
//sEmpno   = Trim(dw_1.getitemstring(1,'empno'))
//If IsNull(sEmpNo) then sEmpNo = ''
//
//if ls_sdate = "" or isnull(ls_sdate) then
//	f_message_chk(30,'[접수일자 FROM]')
//	dw_1.setcolumn('sdate')
//	dw_1.setfocus()
//	return
//end if
//
//if ls_edate = "" or isnull(ls_edate) then
//	f_message_chk(30,'[접수일자 TO]')
//	dw_1.setcolumn('edate')
//	dw_1.setfocus()
//	return
//end if
//
//if dw_insert.retrieve(gs_sabu, ls_sdate, ls_edate, sgubun, sEmpNo+'%') < 1 then
//	f_message_chk(300,'')
//	dw_1.setcolumn('sdate')
//	dw_1.setfocus()
//	return
//end if
end event

type cb_print from w_inherite`cb_print within w_sal_01900
integer x = 1431
integer y = 2796
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_sal_01900
end type

type cb_can from w_inherite`cb_can within w_sal_01900
boolean visible = false
integer x = 3575
integer y = 3152
integer taborder = 100
end type

event cb_can::clicked;call super::clicked;//dw_1.reset()
//dw_insert.reset()
//
//dw_1.insertrow(0)
//dw_1.setitem(1,'sdate',left(f_today(),6) + '01' )
//dw_1.setitem(1,'edate',left(f_today(),8))
//
end event

type cb_search from w_inherite`cb_search within w_sal_01900
integer x = 2048
integer y = 2772
integer taborder = 110
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_01900
integer x = 933
integer y = 3132
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01900
end type

type dw_1 from u_key_enter within w_sal_01900
integer x = 160
integer y = 64
integer width = 3227
integer height = 168
integer taborder = 20
string dataobject = "d_sal_019001"
boolean border = false
end type

event itemchanged;String snull

setnull(snull)

Choose Case this.getcolumnname()
	Case 'sdate'
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[접수일자 FROM]')
			this.SetItem(1, "sdate", sNull)
			return 1
		end if
	Case 'edate'
		if f_DateChk(Trim(this.getText())) = -1 then
			f_Message_Chk(35, '[접수일자 FROM]')
			this.SetItem(1, "sdate", sNull)
			return 1
		end if
End Choose
end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

Choose Case this.getcolumnname()
	Case 'cfmempno'
		open(w_sawon_popup)
		
		this.SetItem(1, 'cfmempno', gs_code)
		this.SetItem(1, 'cfmempnm', gs_codename)
		return 1
End Choose
end event

type gb_2 from groupbox within w_sal_01900
boolean visible = false
integer x = 151
integer y = 3164
integer width = 370
integer height = 164
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type gb_3 from groupbox within w_sal_01900
boolean visible = false
integer x = 3218
integer y = 3112
integer width = 1051
integer height = 164
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

type rr_1 from roundrectangle within w_sal_01900
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 165
integer y = 252
integer width = 4306
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

