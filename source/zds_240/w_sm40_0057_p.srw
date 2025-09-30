$PBExportHeader$w_sm40_0057_p.srw
$PBExportComments$월 마감 현황
forward
global type w_sm40_0057_p from w_standard_print
end type
type rb_2 from radiobutton within w_sm40_0057_p
end type
type rb_1 from radiobutton within w_sm40_0057_p
end type
type gb_1 from groupbox within w_sm40_0057_p
end type
type rr_1 from roundrectangle within w_sm40_0057_p
end type
end forward

global type w_sm40_0057_p from w_standard_print
string title = "월 마감현황"
rb_2 rb_2
rb_1 rb_1
gb_1 gb_1
rr_1 rr_1
end type
global w_sm40_0057_p w_sm40_0057_p

forward prototypes
public subroutine wf_change ()
public function integer wf_retrieve ()
end prototypes

public subroutine wf_change ();DataWindowChild ldwc_fact

If rb_1.Checked Then
	dw_list.DataObject = "d_sm40_0057_p_a"
	dw_print.DataObject = "d_sm40_0057_p_ap"
	
	dw_ip.GetChild("factory", ldwc_fact)
	ldwc_fact.SetTransObject(SQLCA)
	ldwc_fact.Retrieve("H","K")
	
//	p_1.visible = False
Else
	dw_list.DataObject = "d_sm40_0057_p_b"
	dw_print.DataObject = "d_sm40_0057_p_bp"
	
	dw_ip.GetChild("factory", ldwc_fact)
	ldwc_fact.SetTransObject(SQLCA)
	ldwc_fact.Retrieve("M","Z")
	
//	p_1.visible = True
End if

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end subroutine

public function integer wf_retrieve ();string ls_saupj ,ls_sdate, ls_factory, ls_itnbr , snull, ls_ittyp
String ls_gubun, ls_cvcod

if dw_ip.accepttext() = -1 then return -1

ls_saupj  = trim(dw_ip.getitemstring(1, "saupj"))
ls_sdate  = trim(dw_ip.getitemstring(1, "sdate"))
ls_factory  = trim(dw_ip.getitemstring(1, "factory"))
ls_itnbr= trim(dw_ip.getitemstring(1, "itnbr"))
ls_ittyp= trim(dw_ip.getitemstring(1, "ittyp"))
ls_cvcod= trim(dw_ip.getitemstring(1, "cvcod"))

if isnull(ls_sdate) or trim(ls_sdate) = '' then
	f_message_chk(30, '[검수월]')
	dw_ip.SetColumn("sdate")
	dw_ip.SetFocus()
	return -1
end if

if isnull(ls_factory) or trim(ls_factory) = '.' then ls_factory = '%'
if isnull(ls_itnbr) or trim(ls_itnbr) = '' then ls_itnbr = ''
if isnull(ls_ittyp) or trim(ls_ittyp) = '' then ls_ittyp = '%'
if isnull(ls_cvcod) or trim(ls_cvcod) = '' then ls_cvcod = '%'

dw_list.setredraw(false)
dw_list.modify("datawindow.detail.height=72")
if dw_list.Retrieve(ls_saupj , ls_sdate, ls_factory , ls_itnbr+'%', ls_ittyp, ls_cvcod ) > 0 then
	
	if rb_1.Checked then
		ls_gubun = 'HKMC'
	else
		ls_gubun = 'X'
	end if
end if
dw_list.setredraw(true)
dw_list.ShareData(dw_print)

RETURN 1
end function

on w_sm40_0057_p.create
int iCurrent
call super::create
this.rb_2=create rb_2
this.rb_1=create rb_1
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.rr_1
end on

on w_sm40_0057_p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;call super::open;String ls_mondt
//select To_char(ADD_MONTHS(sysdate , -1),'YYYYMM') Into :ls_mondt from dual ;
//마감이 되면 마감된 다음 월을 표시 - BY SHINGOON 2007.04.26 (노상호BJ요청)
SELECT TO_CHAR(ADD_MONTHS(TO_DATE(MAX(MAYYMM), 'YYYYMM'), 1), 'YYYYMM') 
  INTO :ls_mondt 
  FROM SALE_MAGAM ;

dw_ip.Object.sdate[1] = ls_mondt

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_ip.Modify("saupj.protect=1")
		dw_ip.Modify("saupj.background.color = 80859087")
   End if
End If

dw_ip.SetFocus()
dw_ip.SetColumn(1)


end event

type p_xls from w_standard_print`p_xls within w_sm40_0057_p
boolean visible = true
integer x = 4215
integer y = 24
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_sm40_0057_p
integer x = 4059
integer y = 208
end type

type p_preview from w_standard_print`p_preview within w_sm40_0057_p
integer x = 4041
end type

type p_exit from w_standard_print`p_exit within w_sm40_0057_p
integer x = 4389
end type

type p_print from w_standard_print`p_print within w_sm40_0057_p
boolean visible = false
integer x = 4229
integer y = 208
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm40_0057_p
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







type st_10 from w_standard_print`st_10 within w_sm40_0057_p
end type



type dw_print from w_standard_print`dw_print within w_sm40_0057_p
integer x = 4407
integer y = 184
string dataobject = "d_sm40_0057_p_ap"
end type

type dw_ip from w_standard_print`dw_ip within w_sm40_0057_p
integer x = 37
integer width = 3401
integer height = 232
string dataobject = "d_sm40_0057_p_1"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'cvcod'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'cvnas', '')
			Return
		End If
		
		This.SetItem(row, 'cvnas', f_get_name5('11', data, ''))
		
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sm40_0057_p
integer x = 41
integer y = 280
integer width = 4517
integer height = 1936
string dataobject = "d_sm40_0057_p_a"
boolean border = false
end type

type rb_2 from radiobutton within w_sm40_0057_p
integer x = 3497
integer y = 156
integer width = 334
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "기타업체"
end type

event clicked;wf_change()
end event

type rb_1 from radiobutton within w_sm40_0057_p
integer x = 3497
integer y = 64
integer width = 334
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "HKMC"
boolean checked = true
end type

event clicked;wf_change()
end event

type gb_1 from groupbox within w_sm40_0057_p
integer x = 3461
integer width = 411
integer height = 252
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_sm40_0057_p
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 32
integer y = 272
integer width = 4539
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

