$PBExportHeader$w_qa06_00030.srw
$PBExportComments$**시험/측정의뢰 현황_한텍(17.08.24)
forward
global type w_qa06_00030 from w_standard_print
end type
type rr_1 from roundrectangle within w_qa06_00030
end type
end forward

global type w_qa06_00030 from w_standard_print
string title = "시험/측정 의뢰 현황"
rr_1 rr_1
end type
global w_qa06_00030 w_qa06_00030

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();if dw_ip.accepttext() = -1 then return 1

string	ls_saupj, sdate1, sdate2, sempno, sgubun, status

sdate1 = trim(dw_ip.getitemstring(1,'sdate'))
if isnull(sdate1) or sdate1 = "" then sdate1 = '10000101'
sdate2 = trim(dw_ip.getitemstring(1,'edate'))
if isnull(sdate2) or sdate2 = "" then sdate2 = '99991231'
sempno = dw_ip.getitemstring(1,'empno')
if isnull(sempno) or trim(sempno) = '' then sempno = '%'

ls_saupj = dw_ip.GetItemString(1, 'saupj')
sgubun = dw_ip.GetItemString(1, 'gubun')
status = dw_ip.GetItemString(1, 'status')

dw_list.SetRedraw(False)
dw_list.retrieve(sdate1, sdate2, sempno, ls_saupj, status, sgubun)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1
end function

on w_qa06_00030.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qa06_00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'sdate', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'edate', String(TODAY(), 'yyyymmdd'))

f_mod_saupj(dw_ip, 'saupj')

end event

type p_xls from w_standard_print`p_xls within w_qa06_00030
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_qa06_00030
integer x = 4270
integer y = 184
end type

type p_preview from w_standard_print`p_preview within w_qa06_00030
end type

type p_exit from w_standard_print`p_exit within w_qa06_00030
end type

type p_print from w_standard_print`p_print within w_qa06_00030
boolean visible = false
integer x = 4453
integer y = 180
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa06_00030
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







type st_10 from w_standard_print`st_10 within w_qa06_00030
end type



type dw_print from w_standard_print`dw_print within w_qa06_00030
string dataobject = "d_qa06_00030_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qa06_00030
integer x = 37
integer y = 4
integer width = 3456
integer height = 248
string dataobject = "d_qa06_00030_1"
end type

event dw_ip::itemchanged;call super::itemchanged;String ls_col ,ls_cod , ls_cvnas, SNULL
Long   ll_cnt ,ll_row

SETNULL(SNULL)

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())   

Choose Case ls_col
	Case "sdate" , "edate" 
		If ls_cod = '' Or isNull(ls_cod) Or f_datechk(ls_cod) < 0  Then
			f_message_chk(35 , '[의뢰일자]')
			SetColumn(ls_col)
			Return 1
		End If

	Case "empno"
		If Trim(ls_cod) = '' OR IsNull(ls_cod) Then
			This.SetItem(row, 'empname', snull)
			Return
		End If
		
		This.SetItem(row, 'empname', f_get_name5('02', ls_cod, ''))

End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = 'empno'	THEN
	gs_gubun = gs_dept
	open(w_sawon_popup)
	
	if isnull(gs_code) or gs_code = '' then return
	
	SetItem(1,"empno",gs_code)
	SetItem(1,"empname",gs_codename)

END IF
end event

type dw_list from w_standard_print`dw_list within w_qa06_00030
integer x = 50
integer y = 260
integer width = 4558
integer height = 1948
string dataobject = "d_qa06_00030_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_qa06_00030
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 252
integer width = 4585
integer height = 1968
integer cornerheight = 40
integer cornerwidth = 55
end type

