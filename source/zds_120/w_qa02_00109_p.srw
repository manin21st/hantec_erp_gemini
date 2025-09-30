$PBExportHeader$w_qa02_00109_p.srw
$PBExportComments$불량폐기 현황
forward
global type w_qa02_00109_p from w_standard_print
end type
type rr_1 from roundrectangle within w_qa02_00109_p
end type
end forward

global type w_qa02_00109_p from w_standard_print
string title = "불량폐기 현황"
rr_1 rr_1
end type
global w_qa02_00109_p w_qa02_00109_p

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_saupj

String ls_st
String ls_ed

ls_st = dw_ip.GetItemString(row, 'd_st')
If Trim(ls_st) = '' OR IsNull(ls_st) Then
	ls_st = '19000101'
Else
	If IsDate(LEFT(ls_st, 4) + '.' + MID(ls_st, 5, 2) + '.' + RIGHT(ls_st, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_st')
		dw_ip.SetFocus()
		Return -1
	End If
End If

ls_ed = dw_ip.GetItemString(row, 'd_ed')
If Trim(ls_ed) = '' OR IsNull(ls_ed) Then
	ls_ed = '29991231'
Else
	If IsDate(LEFT(ls_ed, 4) + '.' + MID(ls_ed, 5, 2) + '.' + RIGHT(ls_ed, 2)) = False Then
		MessageBox('일자형식 확인', '일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_ed')
		dw_ip.SetFocus()
		Return -1
	End If
End If

If ls_st > ls_ed Then
	MessageBox('기간확인', '시작일 보다 종료일이 빠릅니다.')
	dw_ip.SetColumn('d_st')
	dw_ip.SetFocus()
	Return -1
End If

String ls_jocod, ls_gubun

ls_jocod = dw_ip.GetItemString(1, 'jocod')
If Trim(ls_jocod) = '' OR IsNull(ls_jocod) Then
	ls_jocod = '%'
Else
	ls_jocod = ls_jocod + '%'
End If

ls_gubun = dw_ip.GetItemString(1, 'gubun')


dw_list.SetRedraw(False)
dw_list.Retrieve(ls_st, ls_ed, ls_jocod, ls_gubun)
dw_list.SetRedraw(True)

If dw_list.RowCount() < 1 Then Return -1

dw_list.ShareData(dw_print)

Return 1
end function

on w_qa02_00109_p.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qa02_00109_p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.settransobject(SQLCA)
dw_list.settransobject(SQLCA)

dw_ip.InsertRow(0)

dw_ip.SetItem(1, 'd_st', String(TODAY(), 'yyyymm' + '01'))
dw_ip.SetItem(1, 'd_ed', String(TODAY(), 'yyyymmdd'))
dw_ip.SetItem(1, 'okdate', String(TODAY(), 'yyyymmdd'))
end event

type p_xls from w_standard_print`p_xls within w_qa02_00109_p
boolean visible = true
integer x = 4215
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_qa02_00109_p
integer x = 4206
integer y = 180
end type

type p_preview from w_standard_print`p_preview within w_qa02_00109_p
integer x = 4041
end type

type p_exit from w_standard_print`p_exit within w_qa02_00109_p
integer x = 4389
end type

type p_print from w_standard_print`p_print within w_qa02_00109_p
boolean visible = false
integer x = 4389
integer y = 184
end type

type p_retrieve from w_standard_print`p_retrieve within w_qa02_00109_p
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







type st_10 from w_standard_print`st_10 within w_qa02_00109_p
end type



type dw_print from w_standard_print`dw_print within w_qa02_00109_p
integer x = 3419
integer y = 44
string dataobject = "d_qa02_00099_p_ap"
end type

type dw_ip from w_standard_print`dw_ip within w_qa02_00109_p
integer x = 37
integer y = 12
integer width = 2757
integer height = 200
string dataobject = "d_qa02_00109_p_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string snull, sdata , sname, scode
Long	 Lrow

Setnull(snull)

this.accepttext()
Lrow = this.getrow()

if this.getcolumnname() = 'sdate' then
	sdata = this.gettext()
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[시작일자]');
		this.setitem(1, "sdate", snull)
		return 1
	end if
end if

if this.getcolumnname() = 'edate' then
	sdata = this.gettext()	
	if f_datechk(sdata) = -1 then
		f_message_chk(35,'[종료일자]');
		this.setitem(1, "edate", snull)
		return 1		
	end if
	if this.getitemstring(1, "sdate") > sdata then
		
		
	end if
	
end if


// 공급업체
IF this.GetColumnName() = 'cvcod' THEN
	scode = this.gettext()
	
	select cvnas2 into :sname from vndmst
	 where cvcod = :scode ;
	
	if sqlca.sqlcode = 0 then
		this.setitem(1,'cvnas',sname)
	else
		this.setitem(1,'cvcod',snull)
		this.setitem(1,'cvnas',snull)
		return 1
	end if
END IF
end event

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)


// 공급업체
IF this.GetColumnName() = 'cvcod' THEN
	Open(w_vndmst_popup)
	if Isnull(gs_code) or Trim(gs_code) = "" then return

	this.SetItem(1,'cvcod',gs_code)
	this.TriggerEvent(itemchanged!)

END IF
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qa02_00109_p
integer x = 50
integer y = 220
integer width = 4535
integer height = 2016
string dataobject = "d_qa02_00099_p_a"
boolean border = false
end type

type rr_1 from roundrectangle within w_qa02_00109_p
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 212
integer width = 4562
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

