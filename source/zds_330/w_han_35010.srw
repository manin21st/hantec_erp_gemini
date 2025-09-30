$PBExportHeader$w_han_35010.srw
$PBExportComments$발주 대 실적
forward
global type w_han_35010 from w_standard_print
end type
type pb_1 from u_pb_cal within w_han_35010
end type
type st_1 from statictext within w_han_35010
end type
type rr_1 from roundrectangle within w_han_35010
end type
end forward

global type w_han_35010 from w_standard_print
string title = "발주 대비 실적 현황"
pb_1 pb_1
st_1 st_1
rr_1 rr_1
end type
global w_han_35010 w_han_35010

type variables
String is_date
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_st

ls_st = dw_ip.GetItemString(row, 'd_mon')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	MessageBox('기준일 확인', '기준일은 필수 입력 항목입니다.')
	Return -1
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + '01') = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_mon')
		dw_ip.SetFocus()
		Return -1
	End If
End If

String ls_ittyp

ls_ittyp = dw_ip.GetItemString(row, 'ittyp')
If Trim(ls_ittyp) = '' OR IsNull(ls_ittyp) Then ls_ittyp = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(is_date, ls_ittyp)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

Return 1
end function

on w_han_35010.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_han_35010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'd_mon', String(TODAY(), 'yyyymm'))

String ls_today
Long   ll_year
Long   ll_mon

ls_today = String(TODAY(), 'yyyymm')
ll_year  = Long(LEFT(ls_today, 4))
ll_mon   = Long(RIGHT(ls_today, 2))

Long   ll_st
Long   ll_ed

ll_st = ll_mon - 1
ll_ed = ll_mon + 1

String ls_yst
String ls_yed

ls_yst = String(ll_year, '0000')
ls_yed = String(ll_year, '0000')

If ll_st = 0  Then
	ll_st  = 12
	ls_yst = String(ll_year - 1)
End If

If ll_ed = 13 Then 
	ll_ed  = 01
	ls_yed = String(ll_year + 1)
End If

String ls_st
String ls_ed

ls_st = ls_yst + String(ll_st, '00')
ls_ed = ls_yed + String(ll_ed, '00')

String ls_dst
String ls_ded

SELECT MAX(CLDATE)
  INTO :ls_dst
  FROM P4_CALENDAR
 WHERE COMPANYCODE =    'KN'
   AND CLDATE      LIKE :ls_st||'%'
   AND TO_CHAR(TO_DATE(CLDATE, 'YYYYMMDD'), 'D') = '1' ;

SELECT TO_CHAR(TO_DATE(MIN(CLDATE), 'YYYYMMDD') - 1, 'YYYYMMDD')
  INTO :ls_ded
  FROM P4_CALENDAR
 WHERE CLDATE >= TO_CHAR(TO_DATE(:ls_dst, 'YYYYMMDD') + 35, 'YYYYMMDD')
   AND CLDATE <= TO_CHAR(TO_DATE(:ls_dst, 'YYYYMMDD') + 35 + 6, 'YYYYMMDD') ;

is_date = ls_dst

st_1.Text = '(' + LEFT(ls_dst, 4) + '.' + MID(ls_dst, 5, 2) + '.' + RIGHT(ls_dst, 2) + ' ∼ ' + &
                  LEFT(ls_ded, 4) + '.' + MID(ls_ded, 5, 2) + '.' + RIGHT(ls_ded, 2) + ')'




end event

type p_xls from w_standard_print`p_xls within w_han_35010
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_35010
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_35010
boolean visible = false
integer x = 2871
integer y = 28
end type

type p_exit from w_standard_print`p_exit within w_han_35010
end type

type p_print from w_standard_print`p_print within w_han_35010
boolean visible = false
integer x = 3045
integer y = 28
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_35010
integer x = 4096
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
	p_xls.Enabled =False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

//	p_preview.enabled = False
//	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
	p_xls.PictureName =  'C:\erpman\image\엑셀변환_up.gif'
//	p_preview.enabled = true
//	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
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







type st_10 from w_standard_print`st_10 within w_han_35010
end type



type dw_print from w_standard_print`dw_print within w_han_35010
string dataobject = "d_han_35010_002"
end type

type dw_ip from w_standard_print`dw_ip within w_han_35010
integer x = 37
integer width = 2226
integer height = 164
string dataobject = "d_han_35010_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'd_mon'
		String ls_today
		Long   ll_year
		Long   ll_mon
		
		ls_today = data
		ll_year  = Long(LEFT(ls_today, 4))
		ll_mon   = Long(RIGHT(ls_today, 2))
		
		Long   ll_st
		
		ll_st = ll_mon - 1
		
		String ls_yst
		
		ls_yst = String(ll_year, '0000')
		
		If ll_st = 0  Then
			ll_st  = 12
			ls_yst = String(ll_year - 1)
		End If
		
		String ls_st
		
		ls_st = ls_yst + String(ll_st, '00')
				
		SELECT MAX(CLDATE)
		  INTO :is_date
		  FROM P4_CALENDAR
		 WHERE COMPANYCODE =    'KN'
			AND CLDATE      LIKE :ls_st||'%'
			AND TO_CHAR(TO_DATE(CLDATE, 'YYYYMMDD'), 'D') = '1' ;
End Choose
end event

type dw_list from w_standard_print`dw_list within w_han_35010
integer x = 50
integer y = 200
integer width = 4535
integer height = 2028
string dataobject = "d_han_35010_002"
boolean border = false
end type

type pb_1 from u_pb_cal within w_han_35010
boolean visible = false
integer x = 2766
integer y = 60
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('d_st')
If IsNull(gs_code) Then Return
dw_ip.SetItem(1, 'd_st', gs_code)

If DayNumber(Date( Left(gs_code,4)+'-'+Mid(gs_code,5,2) +'-'+Right(gs_code,2) )) <> 2 Then
	MessageBox('확 인','주간 계획은 월요일부터 확인 가능합니다.!!')
	dw_ip.SetItem(1, 'd_st', '')
	Return
End If
end event

type st_1 from statictext within w_han_35010
integer x = 631
integer y = 72
integer width = 827
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_han_35010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 188
integer width = 4562
integer height = 2052
integer cornerheight = 40
integer cornerwidth = 55
end type

