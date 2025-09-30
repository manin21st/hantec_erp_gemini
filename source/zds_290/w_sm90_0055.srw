$PBExportHeader$w_sm90_0055.srw
$PBExportComments$주간 계획 대 실적
forward
global type w_sm90_0055 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sm90_0055
end type
type pb_2 from u_pb_cal within w_sm90_0055
end type
type st_1 from statictext within w_sm90_0055
end type
type rr_1 from roundrectangle within w_sm90_0055
end type
end forward

global type w_sm90_0055 from w_standard_print
string title = "주간 계획 대 실적"
pb_1 pb_1
pb_2 pb_2
st_1 st_1
rr_1 rr_1
end type
global w_sm90_0055 w_sm90_0055

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

String ls_st

ls_st = dw_ip.GetItemString(1, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	MessageBox('확인', '기준일을 확인 하십시오.')
	Return -1
End If

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st)
dw_list.SetRedraw(True)

Return 0

end function

on w_sm90_0055.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_sm90_0055.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_sm90_0055
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = true
integer x = 4215
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

event p_xls::ue_lbuttondown;This.PictureName = 'C:\erpman\image\엑셀변환_dn.gif'
end event

event p_xls::ue_lbuttonup;This.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
end event

type p_sort from w_standard_print`p_sort within w_sm90_0055
integer x = 3182
end type

type p_preview from w_standard_print`p_preview within w_sm90_0055
boolean visible = false
integer x = 4041
end type

type p_exit from w_standard_print`p_exit within w_sm90_0055
integer x = 4389
end type

type p_print from w_standard_print`p_print within w_sm90_0055
boolean visible = false
integer x = 2994
integer y = 36
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm90_0055
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
//	p_print.Enabled =False
//	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	p_xls.Enabled = False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
//	p_print.Enabled =True
//	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	p_xls.Enabled = True
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
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







type st_10 from w_standard_print`st_10 within w_sm90_0055
end type



type dw_print from w_standard_print`dw_print within w_sm90_0055
integer x = 3675
string dataobject = "d_sm90_0055_2"
end type

type dw_ip from w_standard_print`dw_ip within w_sm90_0055
integer x = 37
integer y = 32
integer width = 2162
integer height = 188
string dataobject = "d_sm90_0055_1"
end type

type dw_list from w_standard_print`dw_list within w_sm90_0055
integer x = 50
integer y = 308
integer width = 4512
integer height = 1924
string dataobject = "d_sm90_0055_2"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sm90_0055
integer x = 626
integer y = 80
integer height = 76
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_st')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_st', gs_code)

end event

type pb_2 from u_pb_cal within w_sm90_0055
boolean visible = false
integer x = 992
integer y = 80
integer height = 76
integer taborder = 110
boolean bringtotop = true
boolean enabled = false
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('d_ed')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'd_ed', gs_code)

end event

type st_1 from statictext within w_sm90_0055
integer x = 50
integer y = 232
integer width = 1207
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "※ 기준일은 주간계획 작성일 기준입니다."
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_sm90_0055
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 296
integer width = 4539
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 55
end type

