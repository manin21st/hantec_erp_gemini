$PBExportHeader$w_sal_01780.srw
$PBExportComments$견적승인
forward
global type w_sal_01780 from w_inherite
end type
type dw_1 from u_key_enter within w_sal_01780
end type
type gb_2 from groupbox within w_sal_01780
end type
type gb_3 from groupbox within w_sal_01780
end type
type rr_1 from roundrectangle within w_sal_01780
end type
end forward

global type w_sal_01780 from w_inherite
string title = "견적승인"
dw_1 dw_1
gb_2 gb_2
gb_3 gb_3
rr_1 rr_1
end type
global w_sal_01780 w_sal_01780

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

on w_sal_01780.create
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

on w_sal_01780.destroy
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

dw_1.Modify("cfmempno.Protect=1")
//dw_1.Modify("cfmempno.Background.Color='79741120'")


end event

type dw_insert from w_inherite`dw_insert within w_sal_01780
integer x = 82
integer y = 308
integer width = 4485
integer height = 1976
integer taborder = 10
string dataobject = "d_sal_01780_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
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

event dw_insert::constructor;call super::constructor;//Modify("ispec_t.text = '" + f_change_name('2') + "'" )
//Modify("jijil_t.text = '" + f_change_name('3') + "'" )
//
end event

type p_delrow from w_inherite`p_delrow within w_sal_01780
boolean visible = false
integer x = 3419
integer y = 2776
end type

type p_addrow from w_inherite`p_addrow within w_sal_01780
boolean visible = false
integer x = 3246
integer y = 2776
end type

type p_search from w_inherite`p_search within w_sal_01780
boolean visible = false
integer x = 2551
integer y = 2776
end type

type p_ins from w_inherite`p_ins within w_sal_01780
boolean visible = false
integer x = 3072
integer y = 2776
end type

type p_exit from w_inherite`p_exit within w_sal_01780
end type

type p_can from w_inherite`p_can within w_sal_01780
end type

event p_can::clicked;call super::clicked;dw_1.reset()
dw_insert.reset()
dw_1.Modify("cfmempno.Protect=1")
//dw_1.Modify("cfmempno.Background.Color='79741120'")

dw_1.insertrow(0)
dw_1.setitem(1,'sdate',left(f_today(),6) + '01' )
dw_1.setitem(1,'edate',left(f_today(),8))

end event

type p_print from w_inherite`p_print within w_sal_01780
boolean visible = false
integer x = 2725
integer y = 2776
end type

type p_inq from w_inherite`p_inq within w_sal_01780
integer x = 3922
end type

event p_inq::clicked;call super::clicked;string ls_sdate , ls_edate, sPdmf, sPdmt, sMin, sMax

if dw_1.accepttext() <> 1 then return

ls_sdate = Trim(dw_1.getitemstring(1,'sdate'))
ls_edate = Trim(dw_1.getitemstring(1,'edate'))

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

/* Pdm */
select min(rfgub), max(rfgub) into :sMin, :sMax from reffpf where rfcod = '42' and rfgub <> '00';

sPdmf	= Trim(dw_1.GetItemString(1, 'pdmf'))
sPdmt	= Trim(dw_1.GetItemString(1, 'pdmt'))
If IsNull(sPdmf) Or sPdmf = '' Then	sPdmf = sMin
If IsNull(sPdmt) Or sPdmt = '' Then	sPdmt = sMax

if dw_insert.retrieve(gs_sabu, ls_sdate, ls_edate, sPdmf, sPdmt) < 1 then
	f_message_chk(300,'')
	dw_1.setcolumn('sdate')
	dw_1.setfocus()
	return
end if

dw_1.Modify("cfmempno.Protect=0")
//dw_1.Modify("cfmempno.Background.Color='65535'")
end event

type p_del from w_inherite`p_del within w_sal_01780
boolean visible = false
integer x = 3767
integer y = 2776
end type

type p_mod from w_inherite`p_mod within w_sal_01780
integer x = 4096
end type

event p_mod::clicked;call super::clicked;string ls_cfmempno , snull , ls_choice , sOfNo, sSts
long   ll_row, ll_count ,i ,ll_check
Dec    dIrate, dTTamt

setnull(snull)

ll_check = messagebox('확인','저장하시겠습니까',Question!,YesNo! ,1)

if ll_check <> 1 then return

if dw_1.accepttext() <> 1 then return 

ll_count = dw_insert.rowcount()

if ll_count < 1 then
	messagebox('확인','저장할 데이타가 없습니다.')
	return
end if

/* 승인처리시 */
If dw_1.getitemstring(1,'gubun') = '1' Then
	ls_cfmempno = dw_1.getitemstring(1,'cfmempno')
	
	if ls_cfmempno = "" or isnull(ls_cfmempno) then
		f_message_chk(40,'[승인자 명]')
		dw_1.setcolumn('cfmempno')
		dw_1.setfocus()
		return
	end if
	
	for i = 1 to ll_count
		ls_choice = dw_insert.getitemstring(i,'choice')
		
		if ls_choice = 'Y' then
			dw_insert.setitem(i,'ofdetl_cfmempno',ls_cfmempno)
			dw_insert.setitem(i,'ofdetl_cfmdate', left(is_today,8))
			dw_insert.setitem(i,'ofdetl_ofsts',   '2')
			
			dTtAmt = dw_insert.GetItemNumber(i, 'calcsth_ttamt')
			dw_insert.setitem(i,'pdamt', dw_insert.GetItemNumber(i, 'cal_pdamt'))
			dw_insert.setitem(i,'ttamt', dTtAmt)
			dw_insert.setitem(i,'ofdetl_cstno',  dw_insert.GetItemString(i, 'calcsth_cstno'))
			dw_insert.setitem(i,'ofdetl_cstseq', dw_insert.GetItemString(i, 'calcsth_cstseq'))
			dw_insert.setitem(i,'ofdetl_cdate',  dw_insert.GetItemString(i, 'calcsth_cstdat'))

			dIRate = dw_insert.GetItemNumber(i, 'ofdetl_irate')
			If IsNull(dIrate) Then dIrate = 0 
			
			dw_insert.SetItem(i, 'ofdetl_ofamt', truncate( dttamt + (dttamt * dirate/100),0))
		end if
	next
Else
	for i = 1 to ll_count
		ls_choice = dw_insert.getitemstring(i,'choice')
		
		if ls_choice = 'Y' then
			dw_insert.setitem(i,'ofdetl_cfmempno', sNull)
			dw_insert.setitem(i,'ofdetl_cfmdate', sNull)
			dw_insert.setitem(i,'ofdetl_ofsts',   '1')
			
			dw_insert.setitem(i,'pdamt', 0)
			dw_insert.setitem(i,'ttamt', 0)
			dw_insert.setitem(i,'ofdetl_cstno', sNull)
			dw_insert.setitem(i,'ofdetl_cstseq', sNull)
			dw_insert.setitem(i,'ofdetl_cdate',  sNull)
			dw_insert.setitem(i,'ofdetl_ofamt',  0)
		end if
	next
End If

if dw_insert.update() <> 1 then 
	rollback using sqlca;
	w_mdi_frame.sle_msg.text='저장에 실패하였습니다.'
end if

/* 견적의뢰 상태 변경 */
For i = 1 to ll_count
	sOfNo = dw_insert.GetItemString(i,'calcsth_ofno')
	sSts  = wf_sts(sOfno)
	
	update ofhead
		set ofsts = :sSts
	 where sabu = :gs_sabu and
			 ofno = :sOfNo;
	If sqlca.sqlcode <> 0 Then
		RollBack;
		f_message_chk(32,'')
		Return
	End If			
Next

commit using sqlca;

p_inq.TriggerEvent(Clicked!)
w_mdi_frame.sle_msg.text='저장에 성공하였습니다.'

end event

type cb_exit from w_inherite`cb_exit within w_sal_01780
boolean visible = false
integer x = 3246
integer y = 3124
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_sal_01780
boolean visible = false
integer x = 2569
integer y = 3124
integer taborder = 60
end type

event cb_mod::clicked;call super::clicked;//string ls_cfmempno , snull , ls_choice , sOfNo, sSts
//long   ll_row, ll_count ,i ,ll_check
//Dec    dIrate, dTTamt
//
//setnull(snull)
//
//ll_check = messagebox('확인','저장하시겠습니까',Question!,YesNo! ,1)
//
//if ll_check <> 1 then return
//
//if dw_1.accepttext() <> 1 then return 
//
//ll_count = dw_insert.rowcount()
//
//if ll_count < 1 then
//	messagebox('확인','저장할 데이타가 없습니다.')
//	return
//end if
//
///* 승인처리시 */
//If dw_1.getitemstring(1,'gubun') = '1' Then
//	ls_cfmempno = dw_1.getitemstring(1,'cfmempno')
//	
//	if ls_cfmempno = "" or isnull(ls_cfmempno) then
//		f_message_chk(40,'[승인자 명]')
//		dw_1.setcolumn('cfmempno')
//		dw_1.setfocus()
//		return
//	end if
//	
//	for i = 1 to ll_count
//		ls_choice = dw_insert.getitemstring(i,'choice')
//		
//		if ls_choice = 'Y' then
//			dw_insert.setitem(i,'ofdetl_cfmempno',ls_cfmempno)
//			dw_insert.setitem(i,'ofdetl_cfmdate', left(is_today,8))
//			dw_insert.setitem(i,'ofdetl_ofsts',   '2')
//			
//			dTtAmt = dw_insert.GetItemNumber(i, 'calcsth_ttamt')
//			dw_insert.setitem(i,'pdamt', dw_insert.GetItemNumber(i, 'cal_pdamt'))
//			dw_insert.setitem(i,'ttamt', dTtAmt)
//			dw_insert.setitem(i,'ofdetl_cstno',  dw_insert.GetItemString(i, 'calcsth_cstno'))
//			dw_insert.setitem(i,'ofdetl_cstseq', dw_insert.GetItemString(i, 'calcsth_cstseq'))
//			dw_insert.setitem(i,'ofdetl_cdate',  dw_insert.GetItemString(i, 'calcsth_cstdat'))
//
//			dIRate = dw_insert.GetItemNumber(i, 'ofdetl_irate')
//			If IsNull(dIrate) Then dIrate = 0 
//			
//			dw_insert.SetItem(i, 'ofdetl_ofamt', truncate( dttamt + (dttamt * dirate/100),0))
//		end if
//	next
//Else
//	for i = 1 to ll_count
//		ls_choice = dw_insert.getitemstring(i,'choice')
//		
//		if ls_choice = 'Y' then
//			dw_insert.setitem(i,'ofdetl_cfmempno', sNull)
//			dw_insert.setitem(i,'ofdetl_cfmdate', sNull)
//			dw_insert.setitem(i,'ofdetl_ofsts',   '1')
//			
//			dw_insert.setitem(i,'pdamt', 0)
//			dw_insert.setitem(i,'ttamt', 0)
//			dw_insert.setitem(i,'ofdetl_cstno', sNull)
//			dw_insert.setitem(i,'ofdetl_cstseq', sNull)
//			dw_insert.setitem(i,'ofdetl_cdate',  sNull)
//			dw_insert.setitem(i,'ofdetl_ofamt',  0)
//		end if
//	next
//End If
//
//if dw_insert.update() <> 1 then 
//	rollback using sqlca;
//	sle_msg.text='저장에 실패하였습니다.'
//end if
//
///* 견적의뢰 상태 변경 */
//For i = 1 to ll_count
//	sOfNo = dw_insert.GetItemString(i,'calcsth_ofno')
//	sSts  = wf_sts(sOfno)
//	
//	update ofhead
//		set ofsts = :sSts
//	 where sabu = :gs_sabu and
//			 ofno = :sOfNo;
//	If sqlca.sqlcode <> 0 Then
//		RollBack;
//		f_message_chk(32,'')
//		Return
//	End If			
//Next
//
//commit using sqlca;
//
//cb_inq.TriggerEvent(Clicked!)
//sle_msg.text='저장에 성공하였습니다.'
//
end event

type cb_ins from w_inherite`cb_ins within w_sal_01780
integer x = 658
integer y = 2676
integer taborder = 50
end type

type cb_del from w_inherite`cb_del within w_sal_01780
integer x = 1120
integer y = 2752
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_sal_01780
boolean visible = false
integer x = 78
integer y = 3124
integer taborder = 80
end type

event cb_inq::clicked;call super::clicked;//string ls_sdate , ls_edate, sPdmf, sPdmt, sMin, sMax
//
//if dw_1.accepttext() <> 1 then return
//
//ls_sdate = Trim(dw_1.getitemstring(1,'sdate'))
//ls_edate = Trim(dw_1.getitemstring(1,'edate'))
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
///* Pdm */
//select min(rfgub), max(rfgub) into :sMin, :sMax from reffpf where rfcod = '42' and rfgub <> '00';
//
//sPdmf	= Trim(dw_1.GetItemString(1, 'pdmf'))
//sPdmt	= Trim(dw_1.GetItemString(1, 'pdmt'))
//If IsNull(sPdmf) Or sPdmf = '' Then	sPdmf = sMin
//If IsNull(sPdmt) Or sPdmt = '' Then	sPdmt = sMax
//
//if dw_insert.retrieve(gs_sabu, ls_sdate, ls_edate, sPdmf, sPdmt) < 1 then
//	f_message_chk(300,'')
//	dw_1.setcolumn('sdate')
//	dw_1.setfocus()
//	return
//end if
//
//dw_1.Modify("cfmempno.Protect=0")
//dw_1.Modify("cfmempno.Background.Color='65535'")
end event

type cb_print from w_inherite`cb_print within w_sal_01780
integer x = 1367
integer y = 2748
integer taborder = 90
end type

type st_1 from w_inherite`st_1 within w_sal_01780
end type

type cb_can from w_inherite`cb_can within w_sal_01780
boolean visible = false
integer x = 2907
integer y = 3124
integer taborder = 100
end type

event cb_can::clicked;call super::clicked;//dw_1.reset()
//dw_insert.reset()
//dw_1.Modify("cfmempno.Protect=1")
//dw_1.Modify("cfmempno.Background.Color='79741120'")
//
//dw_1.insertrow(0)
//dw_1.setitem(1,'sdate',left(f_today(),6) + '01' )
//dw_1.setitem(1,'edate',left(f_today(),8))
//
end event

type cb_search from w_inherite`cb_search within w_sal_01780
integer x = 1984
integer y = 2724
integer taborder = 110
end type







type gb_button1 from w_inherite`gb_button1 within w_sal_01780
end type

type gb_button2 from w_inherite`gb_button2 within w_sal_01780
end type

type dw_1 from u_key_enter within w_sal_01780
integer x = 69
integer y = 56
integer width = 2999
integer height = 228
integer taborder = 20
string dataobject = "d_sal_01780"
boolean border = false
end type

event itemchanged;call super::itemchanged;string ls_empno , ls_empname , snull

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
	Case 'cfmempno'
		
		ls_empno = Trim(this.gettext())
		
		if ls_empno = "" or isnull(ls_empno) then
			this.setitem(1,"cfmempnm",snull)
			return
		end if
		
		SELECT EMPNAME
		INTO   :ls_empname
		FROM   P1_MASTER
		WHERE  EMPNO = :ls_empno ;
		
		IF SQLCA.SQLCODE <> 0 THEN
			this.TriggerEvent(RButtonDown!)
			Return 2
		ELSE
			this.SetItem(1,"cfmempnm",ls_empname)
		END IF
	Case 'gubun'
		
		dw_insert.setredraw(false)
		
		if this.gettext() = '1' then
			dw_insert.dataobject = 'd_sal_01780_01'
		else
			dw_insert.dataobject = 'd_sal_01780_02'
		end if

		dw_insert.Modify("ispec_t.text = '" + f_change_name('2') + "'" )
		dw_insert.Modify("jijil_t.text = '" + f_change_name('3') + "'" )

		dw_insert.settransobject(sqlca)
		dw_insert.setredraw(true)		
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

type gb_2 from groupbox within w_sal_01780
boolean visible = false
integer x = 59
integer y = 3084
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

type gb_3 from groupbox within w_sal_01780
boolean visible = false
integer x = 2551
integer y = 3084
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

type rr_1 from roundrectangle within w_sal_01780
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 300
integer width = 4507
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

