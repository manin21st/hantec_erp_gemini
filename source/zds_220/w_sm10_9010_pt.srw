$PBExportHeader$w_sm10_9010_pt.srw
$PBExportComments$일간/주간 생산코드계획
forward
global type w_sm10_9010_pt from w_standard_print
end type
type rb_1 from radiobutton within w_sm10_9010_pt
end type
type rb_2 from radiobutton within w_sm10_9010_pt
end type
type dw_1 from datawindow within w_sm10_9010_pt
end type
type pb_1 from u_pb_cal within w_sm10_9010_pt
end type
type rr_1 from roundrectangle within w_sm10_9010_pt
end type
type rr_2 from roundrectangle within w_sm10_9010_pt
end type
end forward

global type w_sm10_9010_pt from w_standard_print
string title = "생산코드 전개현황(파워텍)"
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
pb_1 pb_1
rr_1 rr_1
rr_2 rr_2
end type
global w_sm10_9010_pt w_sm10_9010_pt

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

If dw_ip.GetRow() < 1 Then Return -1

String ls_st
String ls_gbn
String ls_fac
String ls_itnbr

ls_st    = dw_ip.GetItemString(1, 'd_st'   )
ls_gbn   = dw_ip.GetItemString(1, 'gubun'  )
ls_fac   = dw_ip.GetItemString(1, 'factory')
ls_itnbr = dw_ip.GetItemString(1, 'itnbr'  )

If Trim(ls_st) = '' OR IsNull(ls_st) Then
	MessageBox('일자확인', '기준일은 필수 입력 입니다.')
	Return -1
End If

If Trim(ls_gbn)   = '' OR IsNull(ls_gbn)   Then ls_gbn   = '%'
If Trim(ls_fac)   = '' OR IsNull(ls_fac)   Then ls_fac   = '%'
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_gbn, ls_fac, ls_itnbr)
dw_list.SetRedraw(True)

Return 0
end function

on w_sm10_9010_pt.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.pb_1=create pb_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_sm10_9010_pt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymmdd'))
end event

type p_xls from w_standard_print`p_xls within w_sm10_9010_pt
boolean visible = true
integer x = 4178
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_sm10_9010_pt
integer x = 3223
integer y = 28
end type

type p_preview from w_standard_print`p_preview within w_sm10_9010_pt
boolean visible = false
integer x = 3397
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_sm10_9010_pt
integer x = 4352
end type

type p_print from w_standard_print`p_print within w_sm10_9010_pt
boolean visible = false
integer x = 3570
integer y = 32
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm10_9010_pt
integer x = 3831
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

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled =True
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







type st_10 from w_standard_print`st_10 within w_sm10_9010_pt
end type



type dw_print from w_standard_print`dw_print within w_sm10_9010_pt
integer x = 3593
integer y = 160
integer width = 137
boolean enabled = false
string dataobject = "d_sm10_9010_pt_002"
end type

type dw_ip from w_standard_print`dw_ip within w_sm10_9010_pt
integer x = 37
integer y = 32
integer width = 2834
integer height = 212
string dataobject = "d_sm10_9010_pt_001-1"
end type

type dw_list from w_standard_print`dw_list within w_sm10_9010_pt
integer x = 50
integer y = 264
integer width = 4512
integer height = 1968
string dataobject = "d_sm10_9010_pt_002"
boolean border = false
end type

type rb_1 from radiobutton within w_sm10_9010_pt
integer x = 2944
integer y = 52
integer width = 215
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "일간"
boolean checked = true
end type

event clicked;If rb_1.Checked = True Then
	dw_list.DataObject = 'd_sm10_9010_pt_002'
	dw_print.DataObject = 'd_sm10_9010_pt_002'
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
End If
end event

type rb_2 from radiobutton within w_sm10_9010_pt
integer x = 2944
integer y = 124
integer width = 215
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "주간"
end type

event clicked;If rb_2.Checked = True Then
	dw_list.DataObject = 'd_sm10_9010_pt_003'
	dw_print.DataObject = 'd_sm10_9010_pt_003'
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
End If
end event

type dw_1 from datawindow within w_sm10_9010_pt
boolean visible = false
integer x = 2647
integer y = 1260
integer width = 1861
integer height = 964
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
boolean titlebar = true
string title = "주간LIST"
string dataobject = "d_sm10_9010_pt_003"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sm10_9010_pt
integer x = 603
integer y = 84
integer height = 76
integer taborder = 160
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_st', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return

end event

type rr_1 from roundrectangle within w_sm10_9010_pt
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 2889
integer y = 32
integer width = 306
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_sm10_9010_pt
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 252
integer width = 4539
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

