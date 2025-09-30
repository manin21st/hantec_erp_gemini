$PBExportHeader$w_han_34020.srw
$PBExportComments$금형 폐기 현황
forward
global type w_han_34020 from w_standard_print
end type
type pb_1 from u_pb_cal within w_han_34020
end type
type pb_2 from u_pb_cal within w_han_34020
end type
type rr_1 from roundrectangle within w_han_34020
end type
end forward

global type w_han_34020 from w_standard_print
string title = "금형 폐기 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_han_34020 w_han_34020

on w_han_34020.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_han_34020.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm') + '01')
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
end event

type p_xls from w_standard_print`p_xls within w_han_34020
boolean visible = true
integer x = 4215
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_34020
integer x = 3305
integer y = 24
end type

type p_preview from w_standard_print`p_preview within w_han_34020
integer x = 4041
end type

type p_exit from w_standard_print`p_exit within w_han_34020
integer x = 4389
end type

type p_print from w_standard_print`p_print within w_han_34020
boolean visible = false
integer x = 3488
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_34020
integer x = 3867
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







type st_10 from w_standard_print`st_10 within w_han_34020
end type



type dw_print from w_standard_print`dw_print within w_han_34020
integer x = 3675
string dataobject = "d_han_34020_003"
end type

type dw_ip from w_standard_print`dw_ip within w_han_34020
integer x = 37
integer y = 20
integer width = 2377
integer height = 196
string dataobject = "d_han_34020_001"
end type

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code    )
SetNull(gs_codename)

Choose Case dwo.name
	Case 'kum1'
		gs_gubun = 'M'
		Open(w_imt_04630_popup)
		If IsNull(gs_code) OR Trim(gs_code) = '' Then Return
		
		This.SetItem(row, 'kum1', gs_code)
		This.SetItem(row, 'kum2', gs_code)
		
	Case 'kum2'
		gs_gubun = 'M'
		Open(w_imt_04630_popup)
		If IsNull(gs_code) OR Trim(gs_code) = '' Then Return
		
		This.SetItem(row, 'kum2', gs_code)
End Choose
end event

event dw_ip::itemchanged;call super::itemchanged;This.AcceptText()

Choose Case dwo.name
	Case 'kum1'
		This.SetItem(row, 'kum2', data)
End Choose
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_han_34020
integer x = 50
integer y = 248
integer width = 4512
integer height = 2032
string dataobject = "d_han_34020_002"
boolean border = false
end type

type pb_1 from u_pb_cal within w_han_34020
integer x = 1783
integer y = 68
integer height = 76
integer taborder = 120
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

type pb_2 from u_pb_cal within w_han_34020
integer x = 2213
integer y = 68
integer height = 76
integer taborder = 130
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_ed')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_ed', gs_code)

If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
end event

type rr_1 from roundrectangle within w_han_34020
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 236
integer width = 4539
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

