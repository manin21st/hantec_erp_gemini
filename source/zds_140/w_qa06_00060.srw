$PBExportHeader$w_qa06_00060.srw
$PBExportComments$**검사성적서 항목 등록_한텍(17.10.30)
forward
global type w_qa06_00060 from w_inherite
end type
type cb_1 from commandbutton within w_qa06_00060
end type
type dw_ip from datawindow within w_qa06_00060
end type
type dw_list from datawindow within w_qa06_00060
end type
type p_1 from picture within w_qa06_00060
end type
type pb_1 from picturebutton within w_qa06_00060
end type
type p_2 from picture within w_qa06_00060
end type
type dw_hidden from datawindow within w_qa06_00060
end type
type rr_3 from roundrectangle within w_qa06_00060
end type
type rr_2 from roundrectangle within w_qa06_00060
end type
end forward

global type w_qa06_00060 from w_inherite
integer width = 4663
integer height = 2512
string title = "검사성적서 항목 등록"
cb_1 cb_1
dw_ip dw_ip
dw_list dw_list
p_1 p_1
pb_1 pb_1
p_2 p_2
dw_hidden dw_hidden
rr_3 rr_3
rr_2 rr_2
end type
global w_qa06_00060 w_qa06_00060

type variables
DataWindowChild	dw_itcls, dw_itcls1, dw_itcls2

end variables

forward prototypes
public function integer wf_select_chk ()
public function integer wf_required_chk ()
public subroutine wf_init ()
public function integer wf_reset ()
public function integer wf_re ()
public function integer wf_fileup (long ar_row)
public function integer wf_filedel (long ar_row)
public function integer wf_down (long ar_row)
public function integer wf_insert ()
public function integer wf_save ()
public function integer wf_delete ()
end prototypes

public function integer wf_select_chk ();If dw_ip.AcceptText() < 1 Then Return -1
If dw_ip.RowCount() < 1 Then Return -1

String ls_date_st , ls_date_ft ,ls_gubun , ls_saupj
Long   ll_row

ls_date_st = Trim(dw_ip.Object.sdate[1])
ls_date_ft = Trim(dw_ip.Object.edate[1])
//ls_saupj   = Trim(dw_ip.Object.saupj[1])
ls_gubun   = Trim(dw_ip.Object.cvgub[1])

If ls_date_st = '' Or isNull(ls_date_st) Or f_datechk(ls_date_st) < 0  Then
	f_message_chk(35 , '[접수일자]')
	dw_ip.SetColumn("sdate")
	Return -1
End If

If ls_date_ft = '' Or isNull(ls_date_ft) Or f_datechk(ls_date_ft) < 0  Then
	f_message_chk(35 , '[접수일자]')
	dw_ip.SetColumn("edate")
	Return -1
End If

//If ls_saupj = '' Or isNull(ls_saupj) Then
//	f_message_chk(1400 , '[사업장]')
//	dw_ip.SetColumn("saupj")
//	Return -1
//End If
return 1
end function

public function integer wf_required_chk ();If dw_insert.AcceptText() < 1 Then Return -1
If dw_insert.RowCount() < 1 Then Return -1

String sQanew_no, sItnbr , sCvcod ,sCvgub ,sAct_dt ,sResult, sAccept_dt, sAccept_emp, ls_cnf_dt, ls_insert_dt, ls_insert_txt, sdate, sjpno
Long   ll_row, ll_Cnt, lseq

dw_list.AcceptText()
dw_list.SetFocus()
ll_Cnt = dw_list.Rowcount()	
IF dw_list.ModifiedCount() >= 1 THEN 
	DO WHILE ll_row <= ll_Cnt
		ll_Row = dw_list.GetNextModified(ll_row, Primary!)
		IF ll_Row > 0 THEN
			sQanew_no = Trim(dw_list.Object.qanew_no[ll_row])
			If sQanew_no = '' Or isNull(sQanew_no) Then
				sdate = string(f_today(),'yyyymmdd')
				lseq  = sqlca.fun_junpyo(gs_sabu,sdate,'E2')
				sjpno = sdate + string(lseq,'000')
				dw_list.setitem(ll_row,'qanew_no',sjpno)
			End If
			
			sItnbr   = Trim(dw_list.Object.itnbr[ll_row])
			If sItnbr = '' Or isNull(sItnbr) Then
				f_message_chk(33 , '[품번]')
				dw_insert.SetColumn("itnbr")
				dw_insert.SetFocus()
				Return -1
			End If

			sCvcod   = Trim(dw_list.Object.cvcod[ll_row])	
			If sCvcod = '' Or isNull(sCvcod) Then
				f_message_chk(33 , '[제출업체]')
				dw_insert.SetColumn("cvcod")
				dw_insert.SetFocus()
				Return -1
			End If
			
			ls_insert_dt  = Trim(dw_list.Object.insert_dt[ll_row])
			If f_datechk(ls_insert_dt) < 0  Then
				f_message_chk(35 , '[제출일자]')
				dw_insert.SetColumn("insert_dt")
				dw_insert.SetFocus()
				Return -1
			End If
			
			ls_insert_txt  = Trim(dw_list.Object.insert_txt[ll_row])
			If ls_insert_txt = '' Or isNull(ls_insert_txt) Then
				f_message_chk(33 , '[사유]')
				dw_insert.SetColumn("insert_txt")
				dw_insert.SetFocus()
				Return -1
			End If
		ELSE
				EXIT
		END IF
	LOOP
END IF

//sCvgub   = Trim(dw_insert.Object.cvgub[1])
//sAct_dt  = Trim(dw_insert.Object.act_dt[1])
//sAccept_dt  = Trim(dw_insert.Object.accept_dt[1])
//sAccept_emp = Trim(dw_insert.Object.accept_emp[1])
//sResult  = Trim(dw_insert.Object.result_yn[1])
//ls_cnf_dt  = Trim(dw_insert.Object.cnf_dt[1])

//If f_datechk(sAct_dt) < 0  Then
//	f_message_chk(35 , '[처리일자]')
//	dw_insert.SetColumn("act_dt")
//	dw_insert.SetFocus()
//	Return -1
//End If
//
//If f_datechk(sAccept_dt) < 0 Then
//	f_message_chk(33 , '[접수일자]')
//	dw_insert.SetColumn("accept_dt")
//	dw_insert.SetFocus()
//	Return -1
//End If
//
//If sAccept_emp = '' Or isNull(sAccept_emp) Then
//	f_message_chk(33 , '[접수자]')
//	dw_insert.SetColumn("accept_emp")
//	dw_insert.SetFocus()
//	Return -1
//End If
//
//If sResult = '' Or isNull(sResult) Then
//	f_message_chk(33 , '[판정]')
//	dw_insert.SetColumn("result_yn")
//	dw_insert.SetFocus()
//	Return -1
//End If

//If sResult = 'Y' and f_datechk(ls_cnf_dt) < 0 Then
//	f_message_chk(33 , '[승인일자]')
//	dw_insert.SetColumn("cnf_dt")
//	dw_insert.SetFocus()
//	Return -1
//End If

return 1
end function

public subroutine wf_init ();dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.SetItem(1, 'sdate', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'edate', String(TODAY(), 'yyyymmdd'))

dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.SetItem(1, 'mesrst_saupj', gs_saupj)
dw_insert.SetItem(1, 'mesrst_reqdat', String(TODAY(), 'yyyymmdd'))

f_mod_saupj(dw_ip, 'saupj')

end subroutine

public function integer wf_reset ();dw_ip.reset( )
dw_ip.insertrow(0)

wf_re( )
return 1
end function

public function integer wf_re ();string	sItnbr, sGijong

if dw_ip.accepttext( ) = -1 then return -1

sItnbr	=	dw_ip.getitemstring(1, 'itnbr')

if sItnbr = '' or isnull(sItnbr)	then	sItnbr = '%'


string sgubun, sitcls1, sitcls2, sitcls3, sitcls, sittyp

sgubun = dw_ip.getitemstring(1, 'gubun')
sitcls1 = dw_ip.getitemstring(1, 'itcls')
sitcls2 = dw_ip.getitemstring(1, 'itcls1')
sitcls3 = dw_ip.getitemstring(1, 'itcls2')
sittyp  = dw_ip.getitemstring(1, 'ittyp')

sitcls = '%'
if sitcls1 <> '%' and sitcls1 > '.' then sitcls = sitcls1
if sitcls2 <> '%' and sitcls2 > '.' then sitcls = sitcls2
if sitcls3 <> '%' and sitcls3 > '.' then sitcls = sitcls3

if sitcls = '' or isnull(sitcls) then sitcls = '%'
if sittyp = '' or isnull(sittyp) then sittyp = '%'

dw_insert.reset( )
dw_list.retrieve(sgubun, sItnbr, sittyp, sitcls)

return 1
end function

public function integer wf_fileup (long ar_row);//long 		nGetRow, nNewRow, value
//string	sfile_fold, sftp_code, sFile, sitnbr, sitnbrf, sEcono
//
//sitnbr = dw_list.getitemstring(ar_row, 'itnbr')
//sEcono = dw_list.getitemstring(ar_row, 'eco_no')
//
//sitnbrf = f_replace(sitnbr, '#','_')
//
//sfile_fold = is_window_id+'/'+sitnbrf
//
//sFile = f_comm_web_fileupload(sfile_fold)
// 
//If	IsNull( sFile ) or sFile = '' then
//	MessageBox("파일업로드", "파일업로드 되지 않았습니다...!!!", information!)
//else
//	sfile_fold = "popman/" + sfile_fold + "/" + sFile
//	dw_list.setitem(ar_row, 'selfckfile',	sfile_fold)
//	
//	UPDATE ECOMST
//	SET SELFCKFILE = :sfile_fold
//	WHERE ITNBR = :sitnbr AND ECO_NO = :sEcono;
//	
//	COMMIT;
//End if

return 0
end function

public function integer wf_filedel (long ar_row);//long 		nGetRow, nNewRow, value
//string	sfile_fold, sftp_code, sFile, sitnbr, sitnbrf, sEcono
//
//sitnbr = dw_list.getitemstring(ar_row, 'itnbr')
//sEcono = dw_list.getitemstring(ar_row, 'eco_no')
//
//sitnbrf = f_replace(sitnbr, '#','_')
//	
//UPDATE ECOMST
//SET SELFCKFILE = ''
//WHERE ITNBR = :sitnbr AND ECO_NO = :sEcono;
//
//COMMIT;
//
//dw_list.setitem(ar_row, 'selfckfile',	'')

return 0
end function

public function integer wf_down (long ar_row);//string sFile_name
//
//sFile_name = dw_list.getitemstring(ar_row, 'selfckfile')
//gs_code = sFile_name
//open(w_webdown) 

return 0
end function

public function integer wf_insert ();if dw_list.accepttext( ) = -1 then return -1
if dw_insert.accepttext( ) = -1 then return -1

long nRow, nMax_seq, nInsert
string sitnbr, sgubun

nRow = dw_list.getrow( )

if nRow < 1 then return -1

sgubun = dw_ip.getitemstring(1, 'gubun')
sitnbr = dw_list.getitemstring(nRow, 'itnbr')

if dw_insert.rowcount() > 0 then
	nMax_seq = dw_insert.getitemnumber(1, 'max_seq')
	nMax_seq = nMax_seq + 1
else
	nMax_seq = 1
end if

nInsert = dw_insert.insertrow(1)

dw_insert.setitem(nInsert, 'gubun', sgubun)
dw_insert.setitem(nInsert, 'itnbr', sitnbr)
dw_insert.setitem(nInsert, 'check_seq', nMax_seq)

return 1
end function

public function integer wf_save ();if dw_insert.accepttext( ) = -1 then return -1

long		nCount, ii, nCheck_seq
string		sgubun

nCount = dw_insert.rowcount( )

sgubun = dw_ip.getitemstring(1, 'gubun')

for ii = 1 to nCount
	nCheck_seq = dw_insert.getitemnumber(ii, 'check_seq')
	
	if nCheck_seq < 1 or isnull(nCheck_seq) then
//		messagebox('순서 확인', string(ii) + 'Row 순서를 확인하세요')
		messagebox("확인", string(ii) + 'Row'+ "순서를 확인하세요")
		return -1
	end if
	
	dw_insert.setitem(1, 'gubun', sgubun)
next

If MessageBox('저장','변경된 내용을 저장하시겠습니까?',Exclamation!, OKCancel!, 2 ) = 2  then return -1

if dw_insert.update( ) <> 1 then
	rollback;
//	messagebox('저장 실패', '저장에 실패하였습니다.')
	f_message_chk(240,'[저장실패]')
	return -1
end if

commit;

ib_any_typing = false

return 1
end function

public function integer wf_delete ();if dw_insert.accepttext( ) = -1 then return -1

long nDelete

nDelete = dw_insert.getrow( )

if nDelete < 1 then return -1

If MessageBox('삭제','선택한 ' + string(nDelete) + 'ROW 삭제하시겠습니까?~n~n삭제후에는 저장버튼을 클릭해야 저장됩니다.',Exclamation!, OKCancel!, 2 ) = 2  then return -1

dw_insert.deleterow(nDelete)

return 1
end function

on w_qa06_00060.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_ip=create dw_ip
this.dw_list=create dw_list
this.p_1=create p_1
this.pb_1=create pb_1
this.p_2=create p_2
this.dw_hidden=create dw_hidden
this.rr_3=create rr_3
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.dw_list
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.p_2
this.Control[iCurrent+7]=this.dw_hidden
this.Control[iCurrent+8]=this.rr_3
this.Control[iCurrent+9]=this.rr_2
end on

on w_qa06_00060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ip)
destroy(this.dw_list)
destroy(this.p_1)
destroy(this.pb_1)
destroy(this.p_2)
destroy(this.dw_hidden)
destroy(this.rr_3)
destroy(this.rr_2)
end on

event open;call super::open;//f_window_center(this)

is_window_id = this.ClassName()
is_today	=	f_today()

dw_ip.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_ip.GetChild("itcls",  dw_itcls)
dw_ip.GetChild("itcls1", dw_itcls1)
dw_ip.GetChild("itcls2", dw_itcls2)
dw_itcls.settransobject(sqlca)
dw_itcls1.settransobject(sqlca)
dw_itcls2.settransobject(sqlca)
wf_reset( )
end event

type dw_insert from w_inherite`dw_insert within w_qa06_00060
integer x = 1925
integer y = 180
integer width = 2638
integer height = 2128
integer taborder = 20
string dataobject = "d_qa06_00060_3"
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;if row < 1 then return

if dwo.name = 'check_type' then
	if data = '1' then
		this.setitem(row, 'speccd', '')
	end if
end if
end event

event dw_insert::clicked;call super::clicked;if row < 1 then
	return
end if

this.SetRedraw(false)
this.SelectRow(0, false)
this.SelectRow(row, true)
this.SetRow(row)
this.SetRedraw(true)
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;If currentrow < 1 Then
	return
end if

this.SetRedraw(false)
this.SelectRow(0, false)
this.SelectRow(currentrow, true)
this.SetRow(currentrow)
this.SetRedraw(true)
end event

type p_delrow from w_inherite`p_delrow within w_qa06_00060
boolean visible = false
integer x = 5189
integer y = 108
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qa06_00060
boolean visible = false
integer x = 5015
integer y = 108
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qa06_00060
boolean visible = false
integer x = 3488
integer y = 3320
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qa06_00060
boolean visible = false
integer x = 4009
integer y = 3320
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qa06_00060
integer x = 4398
integer y = 0
end type

type p_can from w_inherite`p_can within w_qa06_00060
integer x = 4224
integer y = 0
integer taborder = 60
end type

event p_can::clicked;call super::clicked;wf_reset( )

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\자료조회_dn.gif"
end event

type p_print from w_inherite`p_print within w_qa06_00060
boolean visible = false
integer x = 3662
integer y = 3320
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qa06_00060
integer x = 3529
integer y = 0
end type

event p_inq::clicked;call super::clicked;wf_re()
end event

type p_del from w_inherite`p_del within w_qa06_00060
integer x = 4050
integer y = 0
integer taborder = 50
end type

event p_del::clicked;call super::clicked;wf_delete( )
end event

type p_mod from w_inherite`p_mod within w_qa06_00060
integer x = 3877
integer y = 0
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;wf_save( )
end event

type cb_exit from w_inherite`cb_exit within w_qa06_00060
integer x = 2825
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_qa06_00060
integer x = 1783
integer y = 3292
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qa06_00060
integer x = 942
integer y = 2344
integer taborder = 90
boolean enabled = false
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_qa06_00060
integer x = 2130
integer y = 3292
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qa06_00060
integer x = 1422
integer y = 3296
end type

type cb_print from w_inherite`cb_print within w_qa06_00060
integer x = 1874
integer y = 2348
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_qa06_00060
integer x = 0
integer y = 3520
end type

type cb_can from w_inherite`cb_can within w_qa06_00060
integer x = 2478
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_qa06_00060
integer x = 1371
integer y = 2348
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_qa06_00060
integer x = 2843
integer y = 3520
end type

type sle_msg from w_inherite`sle_msg within w_qa06_00060
integer x = 352
integer y = 3520
end type

type gb_10 from w_inherite`gb_10 within w_qa06_00060
integer y = 3488
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_qa06_00060
end type

type gb_button2 from w_inherite`gb_button2 within w_qa06_00060
end type

type cb_1 from commandbutton within w_qa06_00060
boolean visible = false
integer x = 2267
integer y = 2344
integer width = 576
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "BOM사용내역 조회"
end type

type dw_ip from datawindow within w_qa06_00060
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 46
integer y = 16
integer width = 2414
integer height = 132
integer taborder = 90
string title = "none"
string dataobject = "d_qa06_00060_1"
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

event itemerror;RETURN 1
end event

event itemchanged;String ls_col ,ls_cod , ls_cvnas, SNULL
Long   ll_cnt ,ll_row

SETNULL(SNULL)

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())   

Choose Case ls_col
	Case "sdate" , "edate" 
		If ls_cod = '' Or isNull(ls_cod) Or f_datechk(ls_cod) < 0  Then
			f_message_chk(35 , '[의뢰일자]')
			SetColumn(ls_col)
			Return 1
		End If

	Case "empno"
		If Trim(ls_cod) = '' OR IsNull(ls_cod) Then
			This.SetItem(row, 'empname', snull)
			Return
		End If
		
		This.SetItem(row, 'empname', f_get_name5('02', ls_cod, ''))

End Choose
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = 'itnbr'	THEN
	Open(w_itemas_popup)

	IF gs_code = '' or isnull(gs_code) then return 

	SetItem(1,"itnbr",gs_code)
	SetItem(1,"itdsc",gs_codename)

ELSEIF this.GetColumnName() = 'empno'	THEN
	gs_gubun = gs_dept
	open(w_sawon_popup)
	
	if isnull(gs_code) or gs_code = '' then return
	
	SetItem(1,"empno",gs_code)
	SetItem(1,"empname",gs_codename)

END IF
end event

type dw_list from datawindow within w_qa06_00060
integer x = 50
integer y = 180
integer width = 1815
integer height = 2128
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa06_00060_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;if row < 1 then return

this.SetRedraw(false)
this.SelectRow(0, false)
this.SelectRow(row, true)
this.SetRow(row)
this.SetRedraw(true)

String sFilepath
Long  nMsg

if dwo.name = 'b_fileup' then
		
	sFilepath = this.getitemstring(row, 'selfckfile')
	if sFilepath = '' or isNull(sFilepath) then
		wf_fileup(row)
	else
		nMsg = MessageBox('확인','파일 다운로드는 [예], 파일 삭제는 [아니오] 를 선택 해 주세요.', Question!, YesNoCancel!, 1)
		if nMsg = 1 then
			wf_down(row)
		elseif nMsg = 2 then
			wf_filedel(row)
		end if
	end if	
	
end if
end event

event rowfocuschanged;If currentrow < 1 Then
	dw_insert.reset( )
	return
end if

this.SetRedraw(false)
this.SelectRow(0, false)
this.SelectRow(currentrow, true)
this.SetRow(currentrow)
this.SetRedraw(true)

string sitnbr, sgubun

sgubun = dw_ip.getitemstring(1, 'gubun')
sitnbr = this.getitemstring(currentrow, 'itnbr')

dw_insert.retrieve(sgubun, sitnbr)

end event

event retrieveend;If rowcount > 0 Then Event RowFocusChanged(1)
end event

event itemerror;return 1
end event

type p_1 from picture within w_qa06_00060
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 3223
integer y = 2336
integer width = 178
integer height = 144
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\ERPMAN\image\복사_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\복사_dn.gif"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\복사_up.gif"
end event

event clicked;if dw_list.rowcount() <= 0 then return

Integer j
Long lnewrow, lrow, lseq, lrcnt, lMax
String sDate, sJpno

lrow = dw_list.getrow()
lnewrow = lrow + 1
if lrow <= 0 then 
	messagebox('확인','선택된 행이 없습니다.')
	return -1
else
//	lnewrow = dw_list.insertrow(0)
	sJpno = string(Long(dw_list.object.max_no[1]) + 1)
	dw_list.RowsCopy(lrow, lrow, Primary!, dw_list, lnewrow, Primary!)
	dw_list.accepttext()
	dw_list.setitem(lnewrow,'qanew_no',sjpno)
	dw_list.setitem(lnewrow,'saupj',gs_saupj)
	dw_list.scrolltorow(lnewrow)
//	dw_list.setitem(lnewrow,'qanew_no',sjpno)
//	dw_list.setitem(lnewrow,'saupj',gs_saupj)
//	dw_list.scrolltorow(lnewrow)
	dw_insert.setfocus()
	dw_insert.setcolumn('insert_dt')
end if

ib_any_typing = true
end event

type pb_1 from picturebutton within w_qa06_00060
boolean visible = false
integer x = 2949
integer y = 2336
integer width = 375
integer height = 144
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "제출업체선택"
boolean originalsize = true
vtextalign vtextalign = vcenter!
end type

event clicked;//if dw_ip.accepttext() <> 1 then return
//
//String scvcod, scvnas, sqweno, sopt, sDate, sJpno
//Long lrow, k, lrowcnt, lseq, lMax 
//
//gs_gubun = dw_ip.object.itnbr[1]
//if gs_gubun = "" or isnull(gs_gubun) then 
//	f_message_chk(30,'[품번]')
//	dw_ip.setcolumn('itnbr')
//	dw_ip.setfocus()
//	return -1
//end if
//
//gs_code = "%"
//gs_codename = "%"
//
//open(w_vndmst_popup_qa)
//if gs_code = "" or isnull(gs_code) then return
//
//SetPointer(HourGlass!)
//
//lrowcnt = dw_insert.rowcount()
//
//dw_hidden.reset()
//dw_hidden.ImportClipboard()
//	
//for k = 1 to dw_hidden.rowcount()
//	sopt = dw_hidden.getitemstring(k, 'opt')
//	if sopt  = 'Y' then
//		if dw_list.rowcount() > 0 then
//			sJpno = string(Long(dw_list.object.max_no[1]) + 1)
//		else
//			sDate = left(f_today(),6)
//			
//			SELECT TO_NUMBER(MAX(SUBSTR(QANEW_NO,7,3)))
//			INTO :lMax
//			FROM QC_SAMPL
//			WHERE SUBSTR(QANEW_NO,1,6) = :sDate;
//			
//			if isnull(lMax) or lMax = 0 then
//				lMax = 1
//			else
//				lMax = lMax + 1
//			end if
//			sJpno = sDate + string(lMax,'000')
//		end if
//
//		lrow  = dw_list.insertrow(0)
//		
//		dw_list.setitem(lrow,'qanew_no',sJpno)
//		
//		scvcod = dw_hidden.getitemstring(k, 'cvcod' )
//		scvnas = dw_hidden.getitemstring(k, 'cvnas' )
//		
//		dw_list.setItem(lrow,"itnbr",gs_gubun)
//		dw_list.setItem(lrow,"cvcod",scvcod)
//		dw_list.setitem(lrow,'vndmst_cvnas', scvnas)
//		dw_list.setitem(lrow, 'saupj', gs_saupj)
//	end if
//next	
//
//dw_list.ScrollToRow(lrow)
//dw_list.setrow(lrow)
//dw_list.SetColumn("insert_dt")
//dw_list.SetFocus()
//
//ib_any_typing = true
//
//
end event

type p_2 from picture within w_qa06_00060
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 3703
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\ERPMAN\image\추가_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"
end event

event ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"

end event

event clicked;wf_insert( )

end event

type dw_hidden from datawindow within w_qa06_00060
boolean visible = false
integer x = 3227
integer y = 2360
integer width = 128
integer height = 108
integer taborder = 90
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_vndmst_popup_qa"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_3 from roundrectangle within w_qa06_00060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 172
integer width = 1847
integer height = 2152
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qa06_00060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1920
integer y = 172
integer width = 2656
integer height = 2144
integer cornerheight = 40
integer cornerwidth = 55
end type

