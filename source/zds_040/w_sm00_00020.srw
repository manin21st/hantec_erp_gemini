$PBExportHeader$w_sm00_00020.srw
$PBExportComments$년 생산능력 검토
forward
global type w_sm00_00020 from w_inherite
end type
type dw_1 from u_key_enter within w_sm00_00020
end type
type dw_3 from datawindow within w_sm00_00020
end type
type st_2 from statictext within w_sm00_00020
end type
type st_3 from statictext within w_sm00_00020
end type
type rr_1 from roundrectangle within w_sm00_00020
end type
type rr_2 from roundrectangle within w_sm00_00020
end type
type rr_3 from roundrectangle within w_sm00_00020
end type
type dw_jogun from u_key_enter within w_sm00_00020
end type
type ole_chart from uo_chartfx_cs within w_sm00_00020
end type
end forward

global type w_sm00_00020 from w_inherite
string title = "년 생산능력 검토"
dw_1 dw_1
dw_3 dw_3
st_2 st_2
st_3 st_3
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
dw_jogun dw_jogun
ole_chart ole_chart
end type
global w_sm00_00020 w_sm00_00020

type variables
String is_gubun='11111'	// 근무계획
end variables

forward prototypes
public function integer wf_chart (integer arg_row)
end prototypes

public function integer wf_chart (integer arg_row);int				i, j, li_colno = 0, li_rowcnt = 12
st_chartdata	lst_chartdata
string			ls_colname
boolean			lb_sumtag = false

if dw_3.rowcount() <= 0 then return -1

if arg_row <= 0 Then
	lst_chartdata.toptitle  = '생산능력(전체)'
else
	lst_chartdata.toptitle  = dw_3.GetItemString(arg_row, 'wcdsc')
end if

lst_chartdata.rowcnt    = li_rowcnt

// Series 숫자
lst_chartdata.colcnt = 2

for i = 1 to li_rowcnt
	lst_chartdata.rowname[i] = string(i) + ' 월'
next

for i = 1 to 2
	li_colno++

	/* 사용공수 */
	if i = 1 Then
		lst_chartdata.colname[li_colno] = '사용공수'
		lst_chartdata.pointlabels[li_colno] = true
		lst_chartdata.gallery[li_colno] = ole_chart.uc_bar
		
		for j = 1 to li_rowcnt
			if arg_row > 0 then
				lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(arg_row, 'sa' + string(j))
			else
				lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(1, 'sum_sa' + string(j))
			end if
		next
	end if

	/* 보유공수 */
	if i = 2 Then
		lst_chartdata.colname[li_colno] = '보유공수'
		lst_chartdata.pointlabels[li_colno] = true
		lst_chartdata.gallery[li_colno] = ole_chart.uc_lines
		
		for j = 1 to li_rowcnt
			if arg_row > 0 then
				lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(arg_row, 'bo' + string(j))
			else
				lst_chartdata.value[j,li_colno] = dw_3.getitemdecimal(1, 'sum_bo' + string(j))
			end if
		next
	end if
next

ole_chart.setdata(lst_chartdata)

return 1

end function

on w_sm00_00020.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_3=create dw_3
this.st_2=create st_2
this.st_3=create st_3
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.dw_jogun=create dw_jogun
this.ole_chart=create ole_chart
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.rr_3
this.Control[iCurrent+8]=this.dw_jogun
this.Control[iCurrent+9]=this.ole_chart
end on

on w_sm00_00020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
destroy(this.dw_jogun)
destroy(this.ole_chart)
end on

event open;call super::open;String sYymm

dw_1.SetTransObject(sqlca)
dw_3.SetTransObject(sqlca)

dw_insert.SetTransObject(sqlca)
dw_jogun.SetTransObject(sqlca)

dw_1.InsertRow(0)


f_mod_saupj(dw_1, 'saupj')

/* 최종계획년월을 셋팅 */
select MAX(YYYY) Into :sYymm from SM01_YEARPLAN;
dw_1.SetItem(1, 'yymm', sYymm)

p_inq.PostEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_sm00_00020
integer x = 69
integer y = 1128
integer width = 4535
integer height = 1136
string dataobject = "d_sm00_00020_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
end type

event dw_insert::itemchanged;call super::itemchanged;Dec 	 dQty, dAmt, dPrc
Long   nRow
String sCol

nRow = GetRow()
If nRow <= 0 Then Return

sCol = GetColumnName()
Choose Case LEFT(sCol,3)
	Case 'QTY'
		dQty = Dec(GetText())
		If IsNull(dQty) Then dQty = 0
		
		dPrc = GetItemNumber(nRow, 'plan_prc')
		
		dAmt = Round(dQty * dPrc,0)
		
		SetItem(nRow, 'amt_'+Right(sCol,2), dAmt)
End Choose
end event

type p_delrow from w_inherite`p_delrow within w_sm00_00020
boolean visible = false
integer x = 3145
integer y = 32
boolean enabled = false
end type

event p_delrow::clicked;call super::clicked;Long nRow

If f_msg_delete() <> 1 Then	REturn

nRow = dw_insert.GetRow()
If nRow > 0 then
	dw_insert.DeleteRow(nRow)
	
	If dw_insert.Update() <> 1 Then
		RollBack;
		f_message_chk(31,'')
		Return
	End If
	Commit;
End If
end event

type p_addrow from w_inherite`p_addrow within w_sm00_00020
boolean visible = false
integer x = 2962
integer y = 32
boolean enabled = false
end type

event p_addrow::clicked;String sCarCode, sCarGbn1, sCarGbn2
Long	 nRow, dMax

If dw_1.AcceptText() <> 1 Then Return

sCarCode = Trim(dw_1.GetItemString(1, 'carcode'))
sCarGbn1 = Trim(dw_1.GetItemString(1, 'cargbn1'))
sCarGbn2 = Trim(dw_1.GetItemString(1, 'cargbn2'))
If IsNull(sCarCode) Or sCarCode = '' Then
	f_message_chk(1400,'')
	Return
End If

nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, 'carcode', sCarCode)
dw_insert.SetItem(nRow, 'cargbn1', sCargbn1)
dw_insert.SetItem(nRow, 'cargbn2', sCargbn2)

dMax = dw_insert.GetItemNumber(1, 'maxseq')
If IsNull(dMax) then dMax = 0
dMax += 1
dw_insert.SetItem(nRow, 'seq', dMax)
end event

type p_search from w_inherite`p_search within w_sm00_00020
boolean visible = false
integer x = 3918
boolean enabled = false
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sm00_00020
boolean visible = false
integer x = 2761
integer y = 28
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm00_00020
end type

type p_can from w_inherite`p_can within w_sm00_00020
end type

event p_can::clicked;call super::clicked;String sNull
SetNull(sNull)
dw_insert.Reset()
//dw_1.SetItem(1, 'carcode', sNull)
end event

type p_print from w_inherite`p_print within w_sm00_00020
integer x = 2848
integer y = 48
string picturename = "C:\erpman\image\부하계산_up.gif"
end type

event p_print::clicked;String sYear, sdate, edate, sWkctr,sNull
Long   nRow, nChasu
String sSaupj, sChasu

If dw_1.AcceptText() <> 1 Then Return

SetNull(sNull)

sYear = Trim(dw_1.GetItemString(1, 'yymm'))
If IsNull(sYear) Or sYear = '' Then
	f_message_chk(1400, '')
	REturn
End If

nChasu = dw_1.GetItemNumber(1, 'chasu')
If IsNull(nChasu) Or nChasu <= 0 Then
	f_message_chk(1400, '[계획차수]')
	REturn
End If

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return
End If

nRow = dw_3.GetSelectedRow(0)
If nRow > 0 Then
	sWkctr = Trim(dw_3.GetItemString(nRow, 'wkctr'))
End If

SetPointer(HourGlass!)

sChasu = String(nChasu) // 계획차수
sqlca.SM00_CAPA_LOD_YEAR(gs_sabu, sYear, sChasu, sSaupj);
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
	RETURN
END iF

dw_3.Reset()
dw_insert.Reset()

sDate = sYear+'0101'
eDate = sYear+'1231'

dw_1.SetItem(1, 'pdtgu', sNull)
dw_3.Retrieve(sDate, eDate, '%')

If nRow > 0 Then
	dw_3.ScrollToRow(nRow)
	dw_3.SelectRow(0, False)
	dw_3.SelectRow(nRow, True)
End If

wf_chart(nRow)
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\부하계산_up.gif"
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\부하계산_dn.gif"
end event

type p_inq from w_inherite`p_inq within w_sm00_00020
boolean visible = false
integer x = 3493
integer y = 48
end type

event p_inq::clicked;//String syymm, sMagam
//Long	 nCnt
//
//syymm = trim(dw_1.getitemstring(1, 'yymm'))
//
//SELECT COUNT(*), MAX(MANAGEDATE) INTO :nCnt, :sMagam FROM LW_002 WHERE YYMM = :syymm;
//
//If NOT IsNull(smagam) Then
//	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
//	p_mod.Enabled = False
//	p_print.PictureName = 'C:\erpman\image\부하계산_d.gif'
//	p_print.Enabled = False
//	
//	f_message_chk(60,'')
//	
//	Return
//Else
//	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
//	p_mod.Enabled = True
//	p_print.PictureName = 'C:\erpman\image\부하계산_up.gif'
//	p_print.Enabled = True
//	Return				
//End If
end event

type p_del from w_inherite`p_del within w_sm00_00020
boolean visible = false
integer x = 3209
integer y = 64
end type

type p_mod from w_inherite`p_mod within w_sm00_00020
boolean visible = false
integer x = 4096
boolean enabled = false
end type

event p_mod::clicked;Long ix

If dw_insert.AcceptText() <> 1 Then Return

If dw_insert.RowCount() <= 0 Then Return

If dw_insert.Update() <> 1 Then
	RollBack;
	Return
End If

COMMIT;

MessageBox('확 인','저장하였습니다')
end event

type cb_exit from w_inherite`cb_exit within w_sm00_00020
end type

type cb_mod from w_inherite`cb_mod within w_sm00_00020
end type

type cb_ins from w_inherite`cb_ins within w_sm00_00020
end type

type cb_del from w_inherite`cb_del within w_sm00_00020
end type

type cb_inq from w_inherite`cb_inq within w_sm00_00020
end type

type cb_print from w_inherite`cb_print within w_sm00_00020
end type

type st_1 from w_inherite`st_1 within w_sm00_00020
end type

type cb_can from w_inherite`cb_can within w_sm00_00020
end type

type cb_search from w_inherite`cb_search within w_sm00_00020
end type







type gb_button1 from w_inherite`gb_button1 within w_sm00_00020
end type

type gb_button2 from w_inherite`gb_button2 within w_sm00_00020
end type

type dw_1 from u_key_enter within w_sm00_00020
integer x = 64
integer y = 76
integer width = 2725
integer height = 112
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sm00_00020_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;String sYear, sDate, eDate, sPdtgu, sSaupj
Int    nChasu

Choose Case GetColumnName()
	Case 'yymm'
		sYear = GetText()
		
		// 해당년도의 최종차수 계산
		sSaupj = Trim(GetItemString(1, 'saupj'))
		
		SELECT MAX(CHASU) INTO :nChasu FROM SM01_YEARPLAN 
		 WHERE SABU = :gs_sabu 
			AND SAUPJ = :sSaupj 
			AND YYYY = :sYear;
		If IsNull(nChasu) Then nChasu = 1
		SetItem(1, 'chasu', nChasu)
			
		p_inq.PostEvent(Clicked!)
	Case 'pdtgu'
		sPdtgu = Trim(GetText())
		If IsNull(sPdtgu) Then sPdtgu = ''
		
		sYear = GetItemString(1, 'yymm')
		sDate = sYear+'0101'
		eDate = sYear+'1231'	
		
		dw_3.Reset()
		dw_insert.Reset()
		
		dw_3.Retrieve(sDate, eDate, sPdtgu+'%')
End Choose
end event

type dw_3 from datawindow within w_sm00_00020
integer x = 64
integer y = 248
integer width = 2057
integer height = 844
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm00_00020_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;String syymm, swkctr, sMindate, sMaxDate, sCust
String sSaupj
Int    nChasu

If row > 0 Then
	syymm	= dw_1.GetItemString(1, 'yymm')
	swkctr = GetItemString(row, 'wkctr')

	/* 사업장 체크 */
	sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
	If IsNull(sSaupj) Or sSaupj = '' Then
		f_message_chk(1400, '[사업장]')
		dw_1.SetFocus()
		dw_1.SetColumn('saupj')
		Return
	End If

	nChasu= dw_1.GetItemNumber(1, 'chasu')
	
	sCust	= Trim(dw_1.GetItemString(1, 'cust'))
	If IsNull(sCust) Then sCust = ''
	
	dw_insert.Retrieve(gs_sabu, syymm, swkctr, sCust+'%', sSaupj, nChasu)
	
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
	
	wf_chart(row)
Else
	This.SelectRow(0, FALSE)
	wf_chart(0)
	
	dw_jogun.Reset()
End If
end event

type st_2 from statictext within w_sm00_00020
integer x = 4087
integer y = 180
integer width = 517
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "단위 : HOUR"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_sm00_00020
boolean visible = false
integer x = 2295
integer y = 112
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "보유공수 조정"
boolean focusrectangle = false
end type

event clicked;If dw_jogun.Visible = False Then
	dw_jogun.Visible = true
	dw_insert.Visible = false
Else
	dw_jogun.Visible = False
	dw_insert.Visible = true
End If
end event

type rr_1 from roundrectangle within w_sm00_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 244
integer width = 2085
integer height = 860
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sm00_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 36
integer width = 2757
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sm00_00020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 1124
integer width = 4553
integer height = 1144
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_jogun from u_key_enter within w_sm00_00020
boolean visible = false
integer x = 69
integer y = 1128
integer width = 4448
integer height = 1124
integer taborder = 11
string dataobject = "d_sm01_00020_1_1"
boolean border = false
end type

event itemchanged;//String sWkctr, sCldate, sRqcgu, sPdtgu, sDate, edate, sCol
//Dec	 dMin
//Long	 nRow
//
//nRow = dw_3.GetSelectedRow(0)
//If nRow > 0 Then
//	sWkctr = Trim(dw_3.GetItemString(nRow, 'wkctr'))
//Else
//	Return
//End If
//
//sRqcgu = Trim(GetText())
//select to_number(dataname) into :dMin from syscnfg where sysgu = 'Y' and serial = '90' and lineno = :sRqcgu;
//If IsNull(dMin) Then dMin = 0
//
//sCol = GetColumnName()
//sCldate= Trim(GetItemString(Row, 'cldate'))
//
//Choose Case left(GetColumnName(),6)
//	Case 'rqcgu_'
//		UPDATE SM02_CAPA_LOD
//		   SET BOTIME = :dMin + BOTIME2,
//			    BOTIME1 = :dMin,
//			    RTYPE1 = :sRqcgu
//		 WHERE WKCTR = :sWkctr
//		   AND CLDATE = :sCldate;		
//	Case 'rqcgu2'
//		UPDATE SM02_CAPA_LOD
//		   SET BOTIME = BOTIME1 + :dMin,
//			    BOTIME2 = :dMin,
//			    RTYPE2 = :sRqcgu
//		 WHERE WKCTR = :sWkctr
//		   AND CLDATE = :sCldate;
//End Choose
//
//If sqlca.sqlcode <> 0 Then
//	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
//	RollBack;
//	Return
//Else
//	COMMIT;
//End If
//
//dw_3.Reset()
//dw_insert.Reset()
//
////sDate  = dw_2.GetItemString(1, 'week_sdate')
////eDate  = dw_2.GetItemString(dw_2.RowCount(), 'week_edate')
//sPdtgu = dw_1.GetItemString(1, 'pdtgu')
//If IsNull(sPdtgu) Then sPdtgu = ''
//
//dw_3.Retrieve(sDate, eDate, spdtgu+'%')
//
//If nRow > 0 Then
//	dw_3.ScrollToRow(nRow)
//	dw_3.SelectRow(0, False)
//	dw_3.SelectRow(nRow, True)
//End If
//
//wf_chart(nRow)
end event

type ole_chart from uo_chartfx_cs within w_sm00_00020
integer x = 2162
integer y = 256
integer width = 2432
integer height = 844
integer taborder = 80
boolean bringtotop = true
string binarykey = "w_sm00_00020.win"
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Ew_sm00_00020.bin 
2E00001400e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffe00000005fffffffe000000060000000700000008fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000003000000000000000000000000000000000000000000000000000000007380385001c6014200000003000008400000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000b20000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004608e8b1111d13690aa00d48f1c09bd00000000007370f61001c601427380385001c601420000000000000000000000000000000100000002fffffffe0000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f00000020fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0061006100610061006c0069006f006b0067007a006100620070006100610062006400610049004100410041004100410041004100410041004100410041004100510041005a0030004e005900450054004100410041004100410041003d00410074007600740076006a00760075007600710073007400720075007300740071006b0075007500730074007600740075006c00740073006a0074007600750078006b00760073006d006b00670067006500650000006a005c006500720031005c00000300000036fc000015cf48435f5f465452415f5f3458040000002ebf140000020000000246a8ffff00000032ff7f001e001e0000001e00000004000000000050000000000001000020840000001000020004000000000000000000000000000b001900010003000000000001004600000000000000000003000e000000010000008000000000007f00000000000000000000c034000000000000c0340000000000003ff0000000000000000000000000000040590000000000000000000038280002800100000000000200000000000000000000000000003ff000010000001000000001800000100000000080000000000004000000000000000000000000000000000000000000000000000000ffff3ff0ffffffffffff7fefffffffff0000ffef00000000000200000000386800020001000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000300000756000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003ff00000000000000000000180000010000000018000001000000000000000000000040000000000bff0000000000000bff00000000000003ff00000ffffffff7fefffffffffffffffefffff000000000000000038280000000100000000000200000000000040440000000000003ff000010000001000000001800000100000000080000000000004000000000000000000000000000000000000000000000000000000ffff3ff0ffffffffffff7fefffffffff0000ffef000000000002000000003868000200010000000000000000000000003ff000000000000000000001800000100000000180000010000000000000000000000400010000000100000001000000000000000000000000000000000000000000000000080000000020000008000000006000000800000005100000720041006100695f90006c0000000102bc000000000000000000000000000000000000000800000000000000080000000000000008000000000000000800000000000000080000000000000008000000000000000c00000000000a000800000000000000080000000000000008000000050000000200000000000000000000000500000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bff0000000001000100000076010003000000000000000001000001c435000098f39f373b9c11d14d24a000ffff20290001000000000002735b7300001c005c0045005d73450150000002200000016e0001ffff005c001276000126000001216e41001061746f6e54206574626c6f6fffff72610000ffff0001731031000001f39f37c49c11d19824a0003bff20294d2b0000ffe000003003000001100000020001c57300000200000212000000d1000001c40000000200000212000000d10053000d0065697265654c2073646e6567ffff0006ffffffffffffffffffffffff0000ffff0028010000280000000200000004000000040000004d000000040000ffff0000ffffffff0201ffff000140000000000000000004ffffffff0002731233000001f39f37c49c11d19824a0003bff20294d8b0000ff70060070000000001200000100000a73000002000001670000001f000000020000000200000167000000200054000700626c6f6f00067261ffffffffffffffff000001d5000000358000000f000001cd000001b4fffffff00000002800000028000000190000001dffffffffffffffff4000004600000001
20000001020000000100000003000000010000000300000044000400090000000003730f00000001009f37c43111d198f3a0003b9c20294d240000ffff0000302b000000c0000002030118730f000200000118000000e7000001170000000200000119000000e70000000600006567654c0006646effffffffffffffffffffffffffffffff0100000000000028000000280000000200000004000000040000000000000004ffffffffffffffff400003010000000100040000731100000001000437c43100d198f39f003b9c11294d24a000ffff2000302f00000090000001020002731100ae00000018000000e700000102000000ad00000019000000e70000010b0000007461440064452061726f7469ffff0006ffffffffffffffffffffffff0003ffff00280100002800000003000000280000002800000018000000390000ffff0000ffffffff0103ffff00014000731400000001000537c43100d198f39f003b9c11294d24a000ffff200070ab0000005000000100000a731400020000001800000018000001020000000200000019000000190000010a0000006c6150006574746506726142ffffff00ffffffffffffffffffffffff00000fff0000288000002800ffffff00000016ff000016000000160000001600ffffff00ffffffff000140ff0000014006731500000001009f37c43111d198f3a0003b9c20294d240000ffff000070ab0000005000000100000a731500020000011800000018000000020000000200000119000000190000000a000074746150426e726500067261ffffffffffffffffffffffffffffffff8000000f0000002800000028ffffffff00000016000000160000001600000016ffffffffffffffff40000140000000010013ffff006d0073003000300030005f00300030003500340032005f0070005f0064002e006f00770028002000290078002800200038003400350035002900390032002000300030002d0035003100310030002d00200031003900310034003a003a00300035003100000020006400640073005f0030006d005f00310030003000310030005f0035002e0031007700640020006f00780028002000290031002800300031003000360020002900300032003500300031002d002d00320033003100310020003a0034003900330032003a0020003400640000005f0064006d0073003100300030005f00300030003000310033005f0064002e006f007700280020002900780028002000320035003700330020002900300032003500300031002d002d00310031003000310020003a0039003000340031003a0020003500730000005f0064006d0073003100300030005f00300030003500310070005f0070006f007000750031005f0073002e006400720028002000290078002800200037003100380035002900370032002000300030002d0035003000310033002d00200031003100310031003a003a003600360033b1440020d3100020acc4b9e40020d68dc218c81100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Ew_sm00_00020.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
