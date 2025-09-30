$PBExportHeader$w_pm05_10020.srw
$PBExportComments$주간 생산계획대비원자재소요량
forward
global type w_pm05_10020 from w_standard_print
end type
type pb_1 from u_pb_cal within w_pm05_10020
end type
type p_1 from picture within w_pm05_10020
end type
type rr_2 from roundrectangle within w_pm05_10020
end type
type rr_1 from roundrectangle within w_pm05_10020
end type
end forward

global type w_pm05_10020 from w_standard_print
integer height = 2472
string title = "생산계획 대비 원자재 소요량"
pb_1 pb_1
p_1 p_1
rr_2 rr_2
rr_1 rr_1
end type
global w_pm05_10020 w_pm05_10020

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYymm, sPdtgu, sJocod

If dw_ip.AcceptText() <> 1 Then Return -1

sYymm = Trim(dw_ip.GetItemString(1, 'yymm'))
If IsNull(sYymm) Or sYymm = '' Then
	f_message_chk(1400,'')
	Return -1
End If

If DayNumber(Date( Left(sYymm,4)+'-'+Mid(sYymm,5,2) +'-'+Right(sYymm,2) )) <> 2 Then
	MessageBox('확 인','주간 계획은 월요일부터 가능합니다.!!')
	Return -1
End If
sPdtgu = Trim(dw_ip.GetItemString(1, 'pdtgu'))

sJocod = Trim(dw_ip.GetItemString(1, 'jocod'))
If IsNull(sJocod) Then sJocod = ''

String sitnbr

sitnbr = dw_ip.GetItemString(1, 'itnbr')
If Trim(sitnbr) = '' OR IsNull(sitnbr) Then sitnbr = '%'

IF dw_list.Retrieve(gs_saupj, syymm, sJocod+'%') < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)

// Argument 표시
//String sDd1,sDd2,sDd3,sDd4,sDd5,sDd6,sDd7
//
//select to_char(to_date(:syymm,'yyyymmdd'),'DD'),
//       to_char(to_date(:syymm,'yyyymmdd')+1,'DD'),
//       to_char(to_date(:syymm,'yyyymmdd')+2,'DD'),
//       to_char(to_date(:syymm,'yyyymmdd')+3,'DD'),
//       to_char(to_date(:syymm,'yyyymmdd')+4,'DD'),
//       to_char(to_date(:syymm,'yyyymmdd')+5,'DD'),
//       to_char(to_date(:syymm,'yyyymmdd')+6,'DD')
//  into :sDd1,:sDd2,:sDd3,:sDd4,:sDd5,:sDd6,:sDd7
//  from dual;
//  
//dw_print.object.t_yymm.text = left(sYymm,4) + '.' + mid(sYymm,5,2) + '.' + mid(sYymm,7,2) 
//dw_print.object.t_dd1.text  = sDd1 + ' 일'
//dw_print.object.t_dd2.text  = sDd2 + ' 일'
//dw_print.object.t_dd3.text  = sDd3 + ' 일'
//dw_print.object.t_dd4.text  = sDd4 + ' 일'
//dw_print.object.t_dd5.text  = sDd5 + ' 일'
//dw_print.object.t_dd6.text  = sDd6 + ' 일'
//dw_print.object.t_dd7.text  = sDd7 + ' 일'
//dw_list.object.t_dd1.text  = sDd1 + ' 일'
//dw_list.object.t_dd2.text  = sDd2 + ' 일'
//dw_list.object.t_dd3.text  = sDd3 + ' 일'
//dw_list.object.t_dd4.text  = sDd4 + ' 일'
//dw_list.object.t_dd5.text  = sDd5 + ' 일'
//dw_list.object.t_dd6.text  = sDd6 + ' 일'
//dw_list.object.t_dd7.text  = sDd7 + ' 일'

//String tx_name
//
//tx_name = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(pdtgu) ', 1)"))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_pdtgu.text = '"+tx_name+"'")
//
//tx_name = Trim(dw_ip.GetItemString(1, 'jonam'))
//If IsNull(tx_name) Or tx_name = '' Then tx_name = '전체'
//dw_print.Modify("tx_jocod.text = '"+tx_name+"'")
//
//
return 1
end function

on w_pm05_10020.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.p_1=create p_1
this.rr_2=create rr_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.rr_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_pm05_10020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.p_1)
destroy(this.rr_2)
destroy(this.rr_1)
end on

event open;call super::open;String sDate, stoday

stoday = f_today()

select min(week_sdate) INTO :sDate from pdtweek where week_sdate <= :stoday and week_ldate >= :stoday;

dw_ip.SetItem(1, 'yymm', sDate)
end event

type p_xls from w_standard_print`p_xls within w_pm05_10020
boolean visible = true
integer x = 4096
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_pm05_10020
integer x = 3616
integer y = 12
integer width = 119
integer height = 92
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_pm05_10020
integer x = 3922
end type

type p_exit from w_standard_print`p_exit within w_pm05_10020
end type

type p_print from w_standard_print`p_print within w_pm05_10020
end type

type p_retrieve from w_standard_print`p_retrieve within w_pm05_10020
integer x = 3749
end type

event p_retrieve::clicked;//

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
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	
	p_xls.Enabled = False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	
	p_xls.Enabled = True
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
	
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	

w_mdi_frame.sle_msg.text =""

/////-----------------------------------------------------------------------------------------
//// by 2006.09.30 font채 변경 - 신
//String ls_gbn
//SELECT DATANAME
//  INTO :ls_gbn
//  FROM SYSCNFG
// WHERE SYSGU  = 'C'
//   AND SERIAL = '81'
//   AND LINENO = '1' ;
//If ls_gbn = 'Y' Then
//	//wf_setfont()
//	WindowObject l_object[]
//	Long i
//	gstr_object_chg lstr_object		
//	For i = 1 To UpperBound(Control[])
//		lstr_object.lu_object[i] = Control[i]  //Window Object
//		lstr_object.li_obj = i						//Window Object 갯수
//	Next
//	f_change_font(lstr_object)
//End If
//
/////-----------------------------------------------------------------------------------------


end event







type st_10 from w_standard_print`st_10 within w_pm05_10020
end type



type dw_print from w_standard_print`dw_print within w_pm05_10020
integer x = 3401
integer y = 28
integer width = 174
integer height = 152
string dataobject = "d_pm05_10020_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pm05_10020
integer x = 59
integer y = 68
integer width = 3022
integer height = 96
string dataobject = "d_pm05_10020_1"
end type

event dw_ip::itemchanged;String sDate, sData, sNull,sName

SetNull(sNull)

Choose Case GetColumnName()
	Case 'yymm'
		sDate = GetText()
		If DayNumber(Date( Left(sDate,4)+'-'+Mid(sDate,5,2) +'-'+Right(sDate,2) )) <> 2 Then
			MessageBox('확 인','주간 계획은 월요일부터 가능합니다.!!')
			Return 1
			Return
		End If
	Case 'jocod'
		sData = this.gettext()
		Select jonam into :sName From jomast
		Where jocod = :sData;
		if sqlca.sqlcode <> 0 then
		f_message_chk(33,'[반코드]')
			setitem(1, "jocod", sNull)
			setitem(1, "jonam", sNull)
			setcolumn("jocod")
			setfocus()
			Return 1					
		End if
		setitem(1, "jonam", sName)
	Case 'gubun'
		sData = this.gettext()
		if sData = '1' then
//			dw_list.Visible = False
//			dw_list2.Visible = True
			dw_list.dataobject = 'd_pm05_00020_3'
			dw_print.dataobject = 'd_pm05_00020_3_p'
		else
//			dw_list.Visible = True
//			dw_list.Visible = False
			dw_list.dataobject = 'd_pm05_00020_3_han2'
			dw_print.dataobject = 'd_pm05_00020_3_han_p'
		end if
		dw_list.settransobject(sqlca)
		dw_print.settransobject(sqlca)
End Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;String sData
long lrow

SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName()
	Case 'jocod'
		Open(w_jomas_popup)
		SetItem(1,'jocod',gs_code)
		SetItem(1,'jonam',gs_codename)
	Case 'itnbr'
		open(w_itemas_popup)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"itnbr",gs_code)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_pm05_10020
integer x = 27
integer y = 212
integer width = 4576
integer height = 2080
string dataobject = "d_pm05_10020_2"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)
else
	selectrow(0, false)
end if
	
end event

type pb_1 from u_pb_cal within w_pm05_10020
integer x = 718
integer y = 92
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('yymm')
IF IsNull(gs_code) THEN Return
If dw_ip.Object.yymm.protect = '1' Or dw_ip.Object.yymm.TabSequence = '0' Then Return

dw_ip.SetItem(1, 'yymm', gs_code)
end event

type p_1 from picture within w_pm05_10020
string tag = "소요량 계산"
integer x = 3159
integer y = 28
integer width = 178
integer height = 144
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\소요량계산_up.gif"
boolean focusrectangle = false
end type

event clicked;String ls_saupj , ls_factory , ls_ymd , ls_itnbr_from, ls_itnbr_to, ls_from, ls_to, tx_saupj

If dw_ip.AcceptText() < 1 Then Return

//ls_saupj = Trim(dw_1.Object.saupj[1])
ls_ymd = Trim(dw_ip.Object.yymm[1])

If IsNull(ls_ymd) Or ls_ymd = '' Then
	f_message_chk(1400,'[기준일자]')
	Return
End If


/* 사업장 체크 */
//ls_saupj= Trim(dw_1.GetItemString(1, 'saupj'))
//If IsNull(ls_saupj) Or ls_saupj = '' Then
//	f_message_chk(1400, '[사업장]')
//	dw_1.SetFocus()
//	dw_1.SetColumn('saupj')
//	Return
//End If

Long   ll_cnt,ll_rtn
String smsgtxt
ll_cnt = 0 

Select Count(*) Into :ll_cnt 
  from PM02_WEEKPLAN_SUM
 where sabu = '1'
	and yymmdd = :ls_ymd 
	and MOSEQ = 0;      /* 생산계획 확정 */
If ll_cnt > 0 Then	
//	dw_1.Object.confirm[1] = '2'		
Else
//	dw_1.Object.confirm[1] = '1'
	messageBox('확정오류','해당 기준일자로 주간생산계획 확정 된 내용이 없습니다.')
	Return
End If

Select Count(*) Into :ll_cnt 
  from PM02_WEEKPLAN_SUM_SOYO
 where saupj = :gs_saupj
	and yymmdd = :ls_ymd;
	
If ll_cnt > 0 Then	
	smsgtxt = '기준일자의 주간 생산자재 소요계획을 삭제하고 소요량 계산을 다시 하시겠습니까?'
	if MessageBox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return 
End If

SetPointer(HourGlass!)

ll_rtn = SQLCA.FUN_PM02_WEEKPLAN_SUM_SOYO(gs_saupj, ls_ymd);

SetPointer(Arrow!)

If ll_rtn < 1 Then
	MessageBox('오류','소요량 계산 중 오류가 발생 했습니다.')
	Return
End If

p_retrieve.TriggerEvent(Clicked!)
end event

type rr_2 from roundrectangle within w_pm05_10020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 14
integer y = 24
integer width = 3104
integer height = 172
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pm05_10020
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 204
integer width = 4594
integer height = 2092
integer cornerheight = 40
integer cornerwidth = 55
end type

