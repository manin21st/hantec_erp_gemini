$PBExportHeader$w_han_07010.srw
$PBExportComments$생산 회수율 현황
forward
global type w_han_07010 from w_standard_print
end type
type rr_1 from roundrectangle within w_han_07010
end type
end forward

global type w_han_07010 from w_standard_print
string title = "생산 회수율 현황"
rr_1 rr_1
end type
global w_han_07010 w_han_07010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_mon, sDate, eDate, sError

ls_mon = dw_ip.GetItemString(row, 'd_mon')
If Trim(ls_mon) = '' OR IsNull(ls_mon) Then
	MessageBox('기준월 확인', '기준월은 필수 항목입니다.')
	dw_ip.SetColumn('d_mon')
	dw_ip.SetFocus()
	Return -1
Else
	If IsDate(LEFT(ls_mon, 4) + '.' + RIGHT(ls_mon, 2) + '.01') = False Then
		MessageBox('기준월 확인', '기준월 일자형식이 잘못 되었습니다.')
		dw_ip.SetColumn('d_mon')
		dw_ip.SetFocus()
		Return -1
	End If
End If

sDate = ls_mon+'01'
eDate = f_last_date(ls_mon)

/* 생산회수율 계산  - 2007.04.05 - 송병호 */
SetPointer(HourGlass!)

sError = 'X';
sqlca.RPT_PROD_COIL_RATE(gs_sabu, sDate, eDate, gs_userid, sError);
if sError = 'X' or sError = 'Y' then
	f_message_chk(41, '[생산회수율 계산]')
	Rollback;
	return -1
end if
Commit;
//RPT_PROD_COIL_RATE(string AR_SABU,string AR_SDATE,string AR_EDATE,string AR_USERID,ref string AR_ERROR)

dw_list.SetRedraw(False)
dw_list.Retrieve()
dw_list.SetRedraw(True)

Return 1


end function

on w_han_07010.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_han_07010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'd_mon', String(TODAY(), 'yyyymm'))
end event

type p_xls from w_standard_print`p_xls within w_han_07010
boolean visible = true
integer x = 4096
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_07010
boolean visible = true
integer x = 4270
integer y = 24
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_07010
boolean visible = false
integer x = 4261
integer y = 172
end type

type p_exit from w_standard_print`p_exit within w_han_07010
end type

type p_print from w_standard_print`p_print within w_han_07010
boolean visible = false
integer x = 4434
integer y = 172
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_07010
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
	p_xls.Enabled = False
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_d.gif'
//	p_print.Enabled =False
//	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
//
//	p_preview.enabled = False
//	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_xls.Enabled = True
	p_xls.PictureName = 'C:\erpman\image\엑셀변환_up.gif'
//	p_print.Enabled =True
//	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
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







type st_10 from w_standard_print`st_10 within w_han_07010
end type



type dw_print from w_standard_print`dw_print within w_han_07010
string dataobject = "d_han_06010_002"
end type

type dw_ip from w_standard_print`dw_ip within w_han_07010
integer x = 37
integer width = 731
integer height = 188
string dataobject = "d_han_07010_001"
end type

event dw_ip::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	Case 'itnbr_st'
		Open(w_itemas_popup3)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'itnbr_st', gs_code)
		This.SetItem(row, 'itnbr_ed', gs_code)
	
	Case 'itnbr_ed'
		Open(w_itemas_popup3)
		
		If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
		
		This.SetItem(row, 'itnbr_ed', gs_code)

End Choose
end event

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

Choose Case dwo.name
	Case 'itnbr_st'
		If Trim(data) = '' OR IsNull(data) Then
			This.SetItem(row, 'itnbr_ed', '')
			Return
		End If
		
		This.SetItem(row, 'itnbr_ed', data)
		
End Choose
end event

type dw_list from w_standard_print`dw_list within w_han_07010
integer x = 46
integer y = 236
integer width = 4526
integer height = 1992
string dataobject = "d_han_07010_002"
boolean border = false
end type

type rr_1 from roundrectangle within w_han_07010
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 32
integer y = 220
integer width = 4553
integer height = 2024
integer cornerheight = 40
integer cornerwidth = 55
end type

