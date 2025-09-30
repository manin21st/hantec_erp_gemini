$PBExportHeader$w_han_31010.srw
$PBExportComments$매출 대비 검수
forward
global type w_han_31010 from w_standard_print
end type
type st_1 from statictext within w_han_31010
end type
type rr_1 from roundrectangle within w_han_31010
end type
end forward

global type w_han_31010 from w_standard_print
string title = "매출 대비 검수"
st_1 st_1
rr_1 rr_1
end type
global w_han_31010 w_han_31010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_ym

ls_ym = dw_ip.GetItemString(row, 'yymm')
If Trim(ls_ym) = '' Or IsNull(ls_ym) Then
	MessageBox('기준월 확인', '기준월은 필수 입력 항목입니다.')
	dw_ip.SetColumn('yymm')
	dw_ip.SetFocus()
	Return -1
End If

String ls_itnbr

ls_itnbr = dw_ip.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

String ls_cvcod

ls_cvcod = dw_ip.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'

String ls_fac

ls_fac = dw_ip.GetItemString(row, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then ls_fac = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(gs_sabu, ls_ym, ls_cvcod, ls_itnbr, ls_fac)
dw_list.SetRedraw(True)

If dw_list.Rowcount() < 1 Then Return 0

dw_list.ShareData(dw_print)

Return 0



end function

on w_han_31010.create
int iCurrent
call super::create
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_han_31010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;f_mod_saupj(dw_ip, 'saupj')

dw_ip.SetItem(1, 'yymm', String(TODAY(), 'yyyymm'))
end event

type p_xls from w_standard_print`p_xls within w_han_31010
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_31010
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_31010
end type

type p_exit from w_standard_print`p_exit within w_han_31010
end type

type p_print from w_standard_print`p_print within w_han_31010
boolean visible = false
integer x = 3415
integer y = 36
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_31010
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







type st_10 from w_standard_print`st_10 within w_han_31010
end type



type dw_print from w_standard_print`dw_print within w_han_31010
string dataobject = "d_han_31010_003"
end type

type dw_ip from w_standard_print`dw_ip within w_han_31010
integer x = 37
integer width = 2944
integer height = 256
string dataobject = "d_han_31010_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

String sCvcod
String snull

Choose Case dwo.name
	Case 'cvcod'
		sCvcod = Data
		IF sCvcod = '' OR IsNull(sCvcod) THEN
			This.SetItem(row, 'cvnas', snull)
			Return
		END IF
			
		This.SetItem(row, 'cvnas', f_get_name5('11', sCvcod, ''))
End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	/* 거래처 */
	Case 'cvcod'
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code = '' OR IsNull(gs_code) THEN RETURN
		
		This.SetItem(row, 'cvcod', gs_code)
		This.SetItem(row, 'cvnas', gs_codename)
		
End Choose
end event

type dw_list from w_standard_print`dw_list within w_han_31010
integer x = 50
integer y = 308
integer width = 4512
integer height = 1936
string dataobject = "d_han_31010_002"
boolean border = false
end type

type st_1 from statictext within w_han_31010
integer x = 2144
integer y = 176
integer width = 645
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 128
long backcolor = 33027312
string text = "※ 제품창고 출고 기준"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_han_31010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 296
integer width = 4539
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

