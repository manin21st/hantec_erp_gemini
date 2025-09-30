$PBExportHeader$w_han_01060.srw
$PBExportComments$월 불량률 추이 그래프
forward
global type w_han_01060 from w_standard_print
end type
type dw_1 from datawindow within w_han_01060
end type
type rr_1 from roundrectangle within w_han_01060
end type
end forward

global type w_han_01060 from w_standard_print
string title = "월별 불량률 추이 그래프"
dw_1 dw_1
rr_1 rr_1
end type
global w_han_01060 w_han_01060

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_year

ls_year = dw_ip.GetItemString(row, 'd_year')
If Trim(ls_year) = '' OR IsNull(ls_year) Then
	MessageBox('기준년도 확인', '기준년도는 필수 항목입니다.')
	dw_ip.SetColumn('d_year')
	dw_ip.SetFocus()
	Return -1
End If

String ls_gub

ls_gub = dw_ip.GetItemString(row, 'gubun')

String ls_jocod

If ls_gub = '2' Then	
	ls_jocod = dw_ip.GetItemString(row, 'jocod')
	If Trim(ls_jocod) = '' OR IsNull(ls_jocod) Then
		MessageBox('블럭코드 확인', '블럭코드는 필수 항목입니다.')
		dw_ip.SetColumn('jocod')
		dw_ip.SetFocus()
		Return -1
	End If
Else
	ls_jocod = '%'	
End If

dw_list.Object.gr_1.Title  = ls_year + '년 ' + '공정 월별 불량률 추이 그래프'

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_year+'%', ls_jocod)
dw_list.SetRedraw(True)

dw_1.SetRedraw(False)
dw_1.Retrieve(ls_year+'%', ls_jocod)
dw_1.SetRedraw(True)

Return 1


end function

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'd_year', String(TODAY(), 'yyyy'))
end event

on w_han_01060.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_han_01060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_han_01060
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

event p_xls::clicked;//

If this.Enabled Then wf_excel_down(dw_1)
end event

type p_sort from w_standard_print`p_sort within w_han_01060
end type

type p_preview from w_standard_print`p_preview within w_han_01060
boolean visible = false
integer x = 2811
integer y = 20
end type

type p_exit from w_standard_print`p_exit within w_han_01060
end type

type p_print from w_standard_print`p_print within w_han_01060
boolean visible = false
integer x = 2985
integer y = 20
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_01060
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







type st_10 from w_standard_print`st_10 within w_han_01060
end type



type dw_print from w_standard_print`dw_print within w_han_01060
string dataobject = "d_han_01060_201"
end type

type dw_ip from w_standard_print`dw_ip within w_han_01060
integer x = 32
integer width = 2464
integer height = 188
string dataobject = "d_han_01060_101"
end type

type dw_list from w_standard_print`dw_list within w_han_01060
integer x = 55
integer y = 224
integer width = 4530
integer height = 1540
string dataobject = "d_han_01060_201"
end type

type dw_1 from datawindow within w_han_01060
integer x = 55
integer y = 1776
integer width = 4530
integer height = 452
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_han_01060_202"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
end type

event constructor;This.SetTransObject(SQLCA)
end event

type rr_1 from roundrectangle within w_han_01060
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 212
integer width = 4567
integer height = 2032
integer cornerheight = 40
integer cornerwidth = 55
end type

