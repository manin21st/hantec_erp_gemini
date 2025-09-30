$PBExportHeader$w_zds_31010.srw
$PBExportComments$주간 외주계획 현황
forward
global type w_zds_31010 from w_standard_print
end type
type pb_1 from u_pb_cal within w_zds_31010
end type
type cbx_1 from checkbox within w_zds_31010
end type
type rr_1 from roundrectangle within w_zds_31010
end type
end forward

global type w_zds_31010 from w_standard_print
string title = "주간 외주계획 현황"
pb_1 pb_1
cbx_1 cbx_1
rr_1 rr_1
end type
global w_zds_31010 w_zds_31010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();If dw_ip.AcceptText() <> 1 Then Return -1

String ls_date, ls_cvcod ,ls_ittyp, ls_itnbr, ls_saupj
Long   ll_day

ls_saupj = dw_ip.GetItemString(1, 'saupj')

String  ls_pdtgu
If Trim(ls_saupj) = '' Or IsNull(ls_saupj) Or ls_saupj = '%' OR ls_saupj = '.' Then
	ls_saupj = '%'
	ls_pdtgu = '%'
Else
	SELECT RFGUB INTO :ls_pdtgu FROM REFFPF WHERE SABU = '1' AND RFCOD = '03' AND RFNA2 = :ls_saupj ;
End If

ls_date = dw_ip.GetItemString(1, 'd_date')
If Trim(ls_date) = '' OR IsNull(ls_date) Then
	MessageBox('기준일 확인', '기준일은 필수 입력 항목입니다.')
	dw_ip.SetColumn('d_date')
	dw_ip.SetFocus()
	Return -1
End If

ll_day = DayNumber(Date(LEFT(ls_date, 4) + '.' + MID(ls_date, 5, 2) + '.' + RIGHT(ls_date, 2)))
If ll_day <> 2 Then
	MessageBox('기준일자 오류', '기준일자는 월요일이어야 합니다.')
	dw_ip.SetColumn('d_date')
	dw_ip.SetFocus()
	Return -1
End If

ls_cvcod = dw_ip.GetItemString(1, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'

ls_ittyp = dw_ip.GetItemString(1, 'ittyp')
If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then ls_ittyp = '%'

ls_itnbr = dw_ip.GetItemString(1, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_saupj, ls_date, ls_pdtgu, '%', ls_cvcod, ls_ittyp, ls_itnbr)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

//dw_print.ShareData(dw_list)

dw_print.Object.tx_ymd.Text = LEFT(ls_date, 4) + '.' + MID(ls_date, 5, 2) + '.' + RIGHT(ls_date, 2)

Return 1
end function

on w_zds_31010.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.cbx_1=create cbx_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_zds_31010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.cbx_1)
destroy(this.rr_1)
end on

event open;call super::open;/* 최종계획년월을 셋팅 */
string	smaxdate

select max(yymmdd) into :smaxdate from pu03_weekplan
 where waigb = '2' ;
if isnull(smaxdate) or smaxdate = '' then
	smaxdate = f_nearday(f_today(),2)  /* 가장 가까운 월요일 */
	dw_ip.Object.d_date[1] = smaxdate
else
	dw_ip.Object.d_date[1] = smaxdate
end if
end event

type p_xls from w_standard_print`p_xls within w_zds_31010
boolean visible = true
integer x = 4201
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_zds_31010
integer x = 3461
end type

type p_preview from w_standard_print`p_preview within w_zds_31010
integer x = 4027
end type

type p_exit from w_standard_print`p_exit within w_zds_31010
integer x = 4375
end type

type p_print from w_standard_print`p_print within w_zds_31010
boolean visible = false
integer x = 3255
integer y = 40
end type

type p_retrieve from w_standard_print`p_retrieve within w_zds_31010
integer x = 3854
end type

event p_retrieve::clicked;//
//

if is_Upmu = 'A' then
	
	if dw_ip.AcceptText() = -1 then return  

	w_mdi_frame.sle_msg.text =""
	
	sabu_f =Trim(dw_ip.GetItemString(1,"saupj"))
	
	SetPointer(HourGlass!)
	IF sabu_f ="" OR IsNull(sabu_f) OR sabu_f ="99" THEN	//사업장이 전사이거나 없으면 모든 사업장//
		sabu_f ="10"
		sabu_t ="98"
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = '99' )   ;
	ELSE
		sabu_t =sabu_f
		SELECT "REFFPF"."RFNA1"  
		 INTO :sabu_nm  
		 FROM "REFFPF"  
		WHERE ( "REFFPF"."RFCOD" = 'AD' ) AND  
				( "REFFPF"."RFGUB" = :sabu_f )   ;
	END IF
end if

IF wf_retrieve() = -1 THEN
	p_xls.Enabled = False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled = True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

///-----------------------------------------------------------------------------------------
// by 2006.09.30 font채 변경 - 신
String ls_gbn
SELECT DATANAME
  INTO :ls_gbn
  FROM SYSCNFG
 WHERE SYSGU  = 'C'
   AND SERIAL = '81'
   AND LINENO = '1' ;
If ls_gbn = 'Y' Then
	//wf_setfont()
	WindowObject l_object[]
	Long i
	gstr_object_chg lstr_object		
	For i = 1 To UpperBound(Control[])
		lstr_object.lu_object[i] = Control[i]  //Window Object
		lstr_object.li_obj = i						//Window Object 갯수
	Next
	f_change_font(lstr_object)
End If

///-----------------------------------------------------------------------------------------


end event







type st_10 from w_standard_print`st_10 within w_zds_31010
end type



type dw_print from w_standard_print`dw_print within w_zds_31010
integer x = 3662
string dataobject = "d_zds_31010_003"
end type

type dw_ip from w_standard_print`dw_ip within w_zds_31010
integer x = 37
integer width = 3177
integer height = 220
string dataobject = "d_zds_31010_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return 
String snull
String ls_itdsc, sitnbr, sitdsc

setnull(snull)

Choose Case dwo.name
	Case 'cvcod'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvnas', data)
			Return
		End If
		
		This.SetItem(row, 'cvnas', f_get_name5('11', data, ''))
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		Select itnbr , itdsc 
		  Into :sitnbr, :sitdsc
		  From itemas 
		 where itnbr = :sItnbr ;
		 
		If sqlca.sqlcode = 0 Then
			setitem(1, "itnbr", sitnbr)	
			setitem(1, "itdsc", sitdsc)	
		Else
			setitem(1, "itnbr", snull)	
			setitem(1, "itdsc", snull)	
		End IF	
End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'cvcod'
		Open(w_vndmst_popup)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'cvcod', gs_code)
		This.SetItem(row, 'cvnas', gs_codename)
	Case 'itnbr'
		gs_code = Trim(this.GetText())
		gs_gubun = '1'
		open(w_itemas_popup)
		if gs_code = "" or isnull(gs_code) then return 
		this.setitem(1, 'itnbr', gs_code)
		this.setitem(1, 'itdsc', gs_codename)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_zds_31010
integer x = 50
integer y = 284
integer width = 4521
integer height = 1960
string dataobject = "d_zds_31010_002"
boolean border = false
end type

type pb_1 from u_pb_cal within w_zds_31010
integer x = 635
integer y = 40
integer taborder = 51
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('d_date')
IF IsNull(gs_code) THEN Return 

If DayNumber(Date( Left(gs_code,4)+'-'+Mid(gs_code,5,2) +'-'+Right(gs_code,2) )) <> 2 Then
	MessageBox('확 인','주간 외주계획은 월요일부터 가능합니다.!!')
	Return 1
End If

dw_ip.SetItem(1, 'd_date', gs_code)


string	syymm  ,sjucha ,syymmdd ,syymmdd_pre, stemp
Long     ll_jucha , ll_confirm

syymmdd = trim(dw_ip.getitemstring(1,'d_date'))

//select yymmdd into :stemp from PU03_WEEKPLAN
// where sabu = :gs_saupj and yymmdd = :syymmdd and waigb = '2' and cnftime is not null and rownum = 1 ;
//if sqlca.sqlcode = 0 then
//	dw_ip.setitem(1,'cnfirm','Y')
//else
//	dw_ip.setitem(1,'cnfirm','N')
//end if
end event

type cbx_1 from checkbox within w_zds_31010
integer x = 4110
integer y = 184
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "한 줄 보기"
end type

event clicked;If This.Checked = True Then
	dw_list.DataObject = 'd_zds_31010_002-1'
Else
	dw_list.DataObject = 'd_zds_31010_002'
End If

dw_list.SetTransObject(SQLCA)
end event

type rr_1 from roundrectangle within w_zds_31010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 264
integer width = 4549
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

