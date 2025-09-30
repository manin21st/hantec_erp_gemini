$PBExportHeader$w_sm01_03020.srw
$PBExportComments$주간 생산능력 검토
forward
global type w_sm01_03020 from w_inherite
end type
type dw_1 from u_key_enter within w_sm01_03020
end type
type dw_3 from datawindow within w_sm01_03020
end type
type dw_jogun from u_key_enter within w_sm01_03020
end type
type st_3 from statictext within w_sm01_03020
end type
type ole_chart from uo_chartfx_cs within w_sm01_03020
end type
type rr_1 from roundrectangle within w_sm01_03020
end type
type rr_2 from roundrectangle within w_sm01_03020
end type
type rr_3 from roundrectangle within w_sm01_03020
end type
end forward

global type w_sm01_03020 from w_inherite
string title = "주간 생산능력 검토"
dw_1 dw_1
dw_3 dw_3
dw_jogun dw_jogun
st_3 st_3
ole_chart ole_chart
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_sm01_03020 w_sm01_03020

type variables
String is_gubun='1111111'	// 근무계획
end variables

forward prototypes
public function integer wf_chart (integer arg_row)
end prototypes

public function integer wf_chart (integer arg_row);int				i, j, li_colno = 0, li_rowcnt = 7
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

lst_chartdata.rowname[1] = '월'
lst_chartdata.rowname[2] = '화'
lst_chartdata.rowname[3] = '수'
lst_chartdata.rowname[4] = '목'
lst_chartdata.rowname[5] = '금'
lst_chartdata.rowname[6] = '토'
lst_chartdata.rowname[7] = '일'

for i = 1 to 2	
	li_colno++

	/* 사용공수 */
	if i = 1 Then
		lst_chartdata.colname[li_colno] = '사용공수'
		lst_chartdata.pointlabels[li_colno] = true
		lst_chartdata.gallery[li_colno] = ole_chart.uc_bar
		
		for j = 1 to 7
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
		
		for j = 1 to 7
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

on w_sm01_03020.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_3=create dw_3
this.dw_jogun=create dw_jogun
this.st_3=create st_3
this.ole_chart=create ole_chart
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_3
this.Control[iCurrent+3]=this.dw_jogun
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.ole_chart
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_2
this.Control[iCurrent+8]=this.rr_3
end on

on w_sm01_03020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_3)
destroy(this.dw_jogun)
destroy(this.st_3)
destroy(this.ole_chart)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)

dw_3.SetTransObject(sqlca)
dw_jogun.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_1.InsertRow(0)
dw_jogun.InsertRow(0)

/* 최종계획년월을 셋팅 */
String sDate
select MAX(YYMMDD) INTO :sDate from SM03_WEEKPLAN_ITEM;

dw_1.SetItem(1, 'yymm', sDate)

f_mod_saupj(dw_1, 'saupj')
end event

type dw_insert from w_inherite`dw_insert within w_sm01_03020
integer x = 69
integer y = 1128
integer width = 4526
integer height = 1124
string dataobject = "d_sm01_03020_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;Dec dmmqty, davg
Long nJucha, ix, nRow

nRow = GetRow()
If nRow <= 0 Then Return
end event

type p_delrow from w_inherite`p_delrow within w_sm01_03020
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

type p_addrow from w_inherite`p_addrow within w_sm01_03020
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

type p_search from w_inherite`p_search within w_sm01_03020
boolean visible = false
integer x = 3918
boolean enabled = false
string picturename = "C:\erpman\image\생성_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event p_search::ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_ins from w_inherite`p_ins within w_sm01_03020
boolean visible = false
integer x = 2761
integer y = 28
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_sm01_03020
end type

type p_can from w_inherite`p_can within w_sm01_03020
end type

event p_can::clicked;call super::clicked;String sNull
SetNull(sNull)
dw_insert.Reset()

end event

type p_print from w_inherite`p_print within w_sm01_03020
integer x = 2629
integer y = 52
string picturename = "C:\erpman\image\부하계산_up.gif"
end type

event p_print::clicked;String syymm, sdate, edate, sWkctr, sNull
Long   nRow
String sSaupj

If dw_1.AcceptText() <> 1 Then Return

SetNull(sNull)

syymm = Trim(dw_1.GetItemString(1, 'yymm'))
If IsNull(syymm) Or syymm = '' Then
	f_message_chk(1400, '')
	REturn
End If

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

nRow = dw_3.GetSelectedRow(0)
If nRow > 0 Then
	sWkctr = Trim(dw_3.GetItemString(nRow, 'wkctr'))
End If

//is_gubun  = Trim(dw_jogun.GetItemString(1, 'week1'))
//is_gubun += Trim(dw_jogun.GetItemString(1, 'week2'))
//is_gubun += Trim(dw_jogun.GetItemString(1, 'week3'))
//is_gubun += Trim(dw_jogun.GetItemString(1, 'week4'))
//is_gubun += Trim(dw_jogun.GetItemString(1, 'week5'))
//is_gubun += Trim(dw_jogun.GetItemString(1, 'week6'))
//is_gubun += Trim(dw_jogun.GetItemString(1, 'week7'))

sqlca.SM01_CAPA_LOD_WEEK(sSaupj, syymm, is_gubun);
If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode), SQLCA.SQLERRTEXT)
	RETURN
END iF

select week_sdate, week_ldate into :sdate, :edate from pdtweek where week_sdate = :syymm;

dw_3.Reset()
dw_insert.Reset()

dw_1.SetItem(1, 'pdtgu', sNull)
dw_3.Retrieve(sSaupj, sDate, eDate, '%')

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

type p_inq from w_inherite`p_inq within w_sm01_03020
integer x = 3918
end type

event p_inq::clicked;String syymm, sMagam, sPdtgu, sdate, edate
Long	 nCnt
String sSaupj

syymm = trim(dw_1.getitemstring(1, 'yymm'))


/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

sPdtgu = trim(dw_1.getitemstring(1, 'pdtgu'))
If IsNull(sPdtgu) Then sPdtgu = ''

select week_sdate, week_ldate into :sdate, :edate from pdtweek where week_sdate = :syymm;

dw_3.Reset()
dw_insert.Reset()

dw_3.Retrieve(sSaupj, sDate, eDate, sPdtgu+'%')

SELECT COUNT(*), MAX(CNFIRM) INTO :nCnt, :sMagam FROM SM03_WEEKPLAN_ITEM WHERE SAUPJ = :sSaupj AND YYMMDD = :syymm;

If NOT IsNull(smagam) Then
	p_mod.PictureName = 'C:\erpman\image\저장_d.gif'
	p_mod.Enabled = False
	p_print.PictureName = 'C:\erpman\image\부하계산_d.gif'
	p_print.Enabled = False
	
	f_message_chk(60,'')
	
	Return
Else
	p_mod.PictureName = 'C:\erpman\image\저장_up.gif'
	p_mod.Enabled = True
	p_print.PictureName = 'C:\erpman\image\부하계산_up.gif'
	p_print.Enabled = True
	Return				
End If
end event

type p_del from w_inherite`p_del within w_sm01_03020
boolean visible = false
integer x = 3209
integer y = 64
end type

type p_mod from w_inherite`p_mod within w_sm01_03020
integer x = 4096
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

type cb_exit from w_inherite`cb_exit within w_sm01_03020
end type

type cb_mod from w_inherite`cb_mod within w_sm01_03020
end type

type cb_ins from w_inherite`cb_ins within w_sm01_03020
end type

type cb_del from w_inherite`cb_del within w_sm01_03020
end type

type cb_inq from w_inherite`cb_inq within w_sm01_03020
end type

type cb_print from w_inherite`cb_print within w_sm01_03020
end type

type st_1 from w_inherite`st_1 within w_sm01_03020
end type

type cb_can from w_inherite`cb_can within w_sm01_03020
end type

type cb_search from w_inherite`cb_search within w_sm01_03020
end type







type gb_button1 from w_inherite`gb_button1 within w_sm01_03020
end type

type gb_button2 from w_inherite`gb_button2 within w_sm01_03020
end type

type dw_1 from u_key_enter within w_sm01_03020
integer x = 91
integer y = 48
integer width = 2359
integer height = 168
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_sm01_03020_1"
boolean border = false
end type

event itemchanged;String sDate, eDate, sPdtgu, sYymm, sCvcod, sCust
String sSaupj

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

Choose Case GetColumnName()
	Case 'yymm'
		sDate = GetText()
		
		If DayNumber(Date( Left(sDate,4)+'-'+Mid(sDate,5,2) +'-'+Right(sDate,2) )) <> 2 Then
			MessageBox('확 인','주간 판매계획은 월요일부터 가능합니다.!!')
			Return 1
			Return
		End If
	Case 'pdtgu'
		sPdtgu = Trim(GetText())
		If IsNull(sPdtgu) Then sPdtgu = ''
		
		sYymm = GetItemString(1, 'yymm')
		select week_sdate, week_ldate into :sdate, :edate from pdtweek where week_sdate = :syymm;
		
		dw_3.Reset()
		dw_insert.Reset()
		
		dw_3.Retrieve(sSaupj, sDate, eDate, sPdtgu+'%')
	/* 1차 벤더 조회 */
	Case 'cvcod_40'
		sCvcod = Trim(GetText())
		If IsNull(sCvcod) Or sCvcod = '' Then
			dw_insert.Reset()
		Else
			sDate = GetItemString(1, 'yymm')
			sCust = GetItemString(1, 'cust')
			If IsNull(sCust) Then sCust = ''
			
			// 고객구분이 외주완성품일 경우 고객구분은 전체로 지정
			If sCust = '99' Then	sCust = ''
			
			dw_insert.Retrieve(sSaupj, sDate, '%', sCust+'%', sCvcod+'%')
		End If
	/* 고객구분 */
	Case 'cust'
		If GetText() = '99' Then	// 외주완제품
			dw_insert.DataObject = 'd_sm01_03020_4'
			dw_insert.SetTransObject(sqlca)
			
			sDate = GetItemString(1, 'yymm')
			dw_insert.Retrieve(sSaupj, sDate, '%', '%', '%')
		Else
			dw_insert.DataObject = 'd_sm01_03020_3'
			dw_insert.SetTransObject(sqlca)
		End If
End Choose
end event

type dw_3 from datawindow within w_sm01_03020
integer x = 64
integer y = 248
integer width = 2267
integer height = 844
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm01_03020_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;String syymm, swkctr, sMinDate, sMaxDate, sCust, sGbn, sCvcod
String sSaupj

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

If dw_1.AcceptText() <> 1 Then REturn

If row > 0 Then
	syymm	= dw_1.GetItemString(1, 'yymm')
	sGbn   = dw_1.GetItemString(1, 'gbn')
	scust	= Trim(dw_1.GetItemString(1, 'cust'))
	If IsNull(sCust) Then sCust = ''

	sCvcod = dw_1.GetItemString(1, 'cvcod_40')
	If IsNull(sCvcod) Then sCvcod = ''
	
	swkctr = GetItemString(row, 'wkctr')
	
	// 상품일 경우
	If sWkctr = 'ZZZZZZ' Then
		dw_insert.DataObject = 'd_sm01_03020_4'
	Else
		dw_insert.DataObject = 'd_sm01_03020_3'
	End If
	dw_insert.SetTransObject(sqlca)

	// 품목별일 경우 작업장과 무관하게 조회한다
	If sGbn = '2' And sWkctr <> 'ZZZZZZ' Then sWkctr = ''
	
	dw_insert.Retrieve(sSaupj, syymm, swkctr+'%', sCust+'%', sCvcod+'%')
	
	This.SelectRow(0, FALSE)
	This.SelectRow(row, TRUE)
	
	wf_chart(row)
	
	/* 근무형태 */
	select week_sdate, week_ldate into :sMinDate, :sMaxDate from pdtweek where week_sdate = :syymm;
	dw_jogun.Retrieve(sMindate, sMaxDate, sWkctr)
Else
	This.SelectRow(0, FALSE)
	
	wf_chart(0)
	
	dw_jogun.Reset()
End If
end event

type dw_jogun from u_key_enter within w_sm01_03020
boolean visible = false
integer x = 69
integer y = 1128
integer width = 4448
integer height = 1124
integer taborder = 21
boolean bringtotop = true
string dataobject = "d_sm01_00020_1_1"
boolean border = false
end type

event itemchanged;String sWkctr, sCldate, sRqcgu, sPdtgu, sDate, edate, sCol, syymm
Dec	 dMin
Long	 nRow
String sSaupj

/* 사업장 체크 */
sSaupj= Trim(dw_1.GetItemString(1, 'saupj'))
If IsNull(sSaupj) Or sSaupj = '' Then
	f_message_chk(1400, '[사업장]')
	dw_1.SetFocus()
	dw_1.SetColumn('saupj')
	Return -1
End If

nRow = dw_3.GetSelectedRow(0)
If nRow > 0 Then
	sWkctr = Trim(dw_3.GetItemString(nRow, 'wkctr'))
Else
	Return
End If

syymm = dw_1.GetItemString(1, 'yymm')

sRqcgu = Trim(GetText())
select to_number(dataname) into :dMin from syscnfg where sysgu = 'Y' and serial = '90' and lineno = :sRqcgu;
If IsNull(dMin) Then dMin = 0

sCol = GetColumnName()
sCldate= Trim(GetItemString(Row, 'cldate'))

Choose Case left(GetColumnName(),6)
	Case 'rqcgu_'
		UPDATE SM02_CAPA_LOD
		   SET BOTIME = :dMin + BOTIME2,
			    BOTIME1 = :dMin,
			    RTYPE1 = :sRqcgu
		 WHERE WKCTR = :sWkctr
		   AND CLDATE = :sCldate;		
	Case 'rqcgu2'
		UPDATE SM02_CAPA_LOD
		   SET BOTIME = BOTIME1 + :dMin,
			    BOTIME2 = :dMin,
			    RTYPE2 = :sRqcgu
		 WHERE WKCTR = :sWkctr
		   AND CLDATE = :sCldate;
End Choose

If sqlca.sqlcode <> 0 Then
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	RollBack;
	Return
Else
	COMMIT;
End If

dw_3.Reset()
dw_insert.Reset()

select week_sdate, week_ldate into :sdate, :edate from pdtweek where week_sdate = :syymm;

sPdtgu = dw_1.GetItemString(1, 'pdtgu')
If IsNull(sPdtgu) Then sPdtgu = ''

dw_3.Retrieve(sSaupj, sDate, eDate, spdtgu+'%')

If nRow > 0 Then
	dw_3.ScrollToRow(nRow)
	dw_3.SelectRow(0, False)
	dw_3.SelectRow(nRow, True)
End If

wf_chart(nRow)
end event

type st_3 from statictext within w_sm01_03020
boolean visible = false
integer x = 2834
integer y = 148
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

type ole_chart from uo_chartfx_cs within w_sm01_03020
integer x = 2377
integer y = 248
integer taborder = 80
boolean bringtotop = true
string binarykey = "w_sm01_03020.win"
end type

type rr_1 from roundrectangle within w_sm01_03020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 244
integer width = 2286
integer height = 860
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sm01_03020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 36
integer width = 2551
integer height = 196
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_sm01_03020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 59
integer y = 1124
integer width = 4549
integer height = 1144
integer cornerheight = 40
integer cornerwidth = 55
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
02w_sm01_03020.bin 
2900001200e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffe00000005fffffffe0000000600000007fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000005f956cd001c80d4200000003000007c00000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff00000003608e8b1111d13690aa00d48f1c09bd00000000005f956cd001c80d425f956cd001c80d42000000000000000000000000004f00010065006c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000102000affffffff00000004ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001efffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
20ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff020000010000000800000000000000000000000000209820000000000000000000000000000000000000000000000000000000000000000000000000000000000000030000003343000015cf48435f5f465452415f5f3458040000002ebf140000020000000246a8ffff00000032ff7f001e001e0000001e00000004000000000050000000000001000020840000001000020004000000000000000000000000000b001900010003000000000001004600000000000000000003000e000000010000008000000000007f00000000000000000000c034000000000000c0340000000000003ff0000000000000000000000000000040590000000000000000000038280002800100000000000200000000000000000000000000003ff000010000001000000001800000100000000080000000000004000000000000000000000000000000000000000000000000000000ffff3ff0ffffffffffff7fefffffffff0000ffef000000000002000000003868000200010000000000000000000000003ff00000000000000000000180000010000000018000001000000000000000000000040000000000bff0000000000000bff00000000000003ff00000ffffffff7fefffffffffffffffefffff000000000000000038280000000100000000000200000000000040440000000000003ff000010000001000000001800000100000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020012ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000100000756000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000004000000000000000000000000000000000000000000000000000000ffff3ff0ffffffffffff7fefffffffff0000ffef000000000002000000003868000200010000000000000000000000003ff000000000000000000001800000100000000180000010000000000000000000000400010000000100000001000000000000000000000000000000000000000000000000080000000020000008000000006000000800000005100000720041006100695f90006c0000000102bc000000000000000000000000000000000000000800000000000000080000000000000008000000000000000800000000000000080000000000000008000000000000000c00000000000a000800000000000000080000000000000008000000050000000200000000000000000000000500000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bff0000000001000100000076010003000000000000000001000001c435000098f39f373b9c11d14d24a000ffff20290001000000000002735b7300001c005c0045005d73450150000002200000016e0001ffff005c001276000126000001216e41001061746f6e54206574626c6f6fffff72610000ffff0001731031000001f39f37c49c11d19824a0003bff20294d2b0000ffe000003003000001100000020001a173000002000001ee000000d1000001a000000002000001ee000000d10053000d0065697265654c2073646e6567ffff0006ffffffffffffffffffffffff0000ffff0028010000280000000200000004000000040000004d000000040000ffff0000ffffffff0201ffff000140000000000000000004ffffffff0002731233000001f39f37c49c11d19824a0003bff20294d8b0000ff70060070000000001200000100000a73000002000001670000001f000000020000000200000167000000200054000700626c6f6f00067261ffffffffffffffff000001d5000000358000000f000001cd000001b4fffffff00000002800000028000000190000001dffffffffffffffff4000004600000001000001020000000100000003000000010000000300000044000400090000000003730f00000001009f37c43111d198f3a0003b9c20294d240000ffff0000302b000000c0000002030118730f000200000118000000e7000001170000000200000119000000e70000000600006567654c0006646effffffffffffffffffffffff
2Dffffffff0100000000000028000000280000000200000004000000040000000000000004ffffffffffffffff400003010000000100040000731100000001000437c43100d198f39f003b9c11294d24a000ffff2000302f00000090000001020002731100ae00000018000000e700000102000000ad00000019000000e70000010b0000007461440064452061726f7469ffff0006ffffffffffffffffffffffff0003ffff00280100002800000003000000280000002800000018000000390000ffff0000ffffffff0103ffff00014000731400000001000537c43100d198f39f003b9c11294d24a000ffff200070ab0000005000000100000a731400020000001800000018000001020000000200000019000000190000010a0000006c6150006574746506726142ffffff00ffffffffffffffffffffffff00000fff0000288000002800ffffff00000016ff000016000000160000001600ffffff00ffffffff000140ff0000014006731500000001009f37c43111d198f3a0003b9c20294d240000ffff000070ab0000005000000100000a731500020000011800000018000000020000000200000119000000190000000a000074746150426e726500067261ffffffffffffffffffffffffffffffff8000000f0000002800000028ffffffff00000016000000160000001600000016ffffffffffffffff40000140000000010000ffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12w_sm01_03020.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
