$PBExportHeader$w_qa06_00050.srw
$PBExportComments$**WORST 현황_한텍(17.09.10)
forward
global type w_qa06_00050 from w_standard_print
end type
type rr_1 from roundrectangle within w_qa06_00050
end type
end forward

global type w_qa06_00050 from w_standard_print
integer width = 4690
integer height = 2432
string title = "품질 WORST 현황"
rr_1 rr_1
end type
global w_qa06_00050 w_qa06_00050

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row
String ls_gub, ls_year, ls_itnbr, ls_cvcod

row = dw_ip.GetRow()
If row < 1 Then Return -1

ls_year = dw_ip.GetItemString(row, 'd_year')
If Trim(ls_year) = '' OR IsNull(ls_year) Then
	MessageBox('기준년도 확인', '기준년도는 필수 항목입니다.')
	dw_ip.SetColumn('d_year')
	dw_ip.SetFocus()
	Return -1
End If

ls_gub = dw_ip.GetItemString(row, 'gubun')

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_year+'%', ls_gub)
dw_list.SetRedraw(True)

Return 1


end function

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'd_year', String(TODAY(), 'yyyy'))
end event

on w_qa06_00050.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qa06_00050.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_xls from w_standard_print`p_xls within w_qa06_00050
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

event p_xls::clicked;//
If this.Enabled Then wf_excel_down(dw_list)
end event

type p_sort from w_standard_print`p_sort within w_qa06_00050
integer x = 5083
integer y = 196
end type

type p_preview from w_standard_print`p_preview within w_qa06_00050
boolean visible = false
integer x = 4736
integer y = 196
end type

type p_exit from w_standard_print`p_exit within w_qa06_00050
end type

type p_print from w_standard_print`p_print within w_qa06_00050
boolean visible = false
integer x = 4910
integer y = 196
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa06_00050
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

end event







type st_10 from w_standard_print`st_10 within w_qa06_00050
end type



type dw_print from w_standard_print`dw_print within w_qa06_00050
integer x = 4777
integer y = 44
string dataobject = "d_qa06_00040_2"
end type

type dw_ip from w_standard_print`dw_ip within w_qa06_00050
integer x = 32
integer width = 1769
integer height = 188
string dataobject = "d_qa06_00050_1"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'gubun'		

		
End Choose
			
			

			
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

// 품번
IF this.GetColumnName() = 'itnbr' THEN
	Open(w_itemas_popup)	
	If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
	This.SetItem(row, 'itnbr', gs_code)
END IF

// 귀책처
IF this.GetColumnName() = 'cvcod' THEN
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(1,'cvcod',gs_code)
	this.SetItem(1,'cvnas',gs_codename)
END IF
end event

type dw_list from w_standard_print`dw_list within w_qa06_00050
integer x = 55
integer y = 224
integer width = 4530
integer height = 2008
string dataobject = "d_qa06_00050_21"
boolean border = false
end type

type rr_1 from roundrectangle within w_qa06_00050
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

