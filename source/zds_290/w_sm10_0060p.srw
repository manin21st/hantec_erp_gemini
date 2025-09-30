$PBExportHeader$w_sm10_0060p.srw
$PBExportComments$아산 van 현황
forward
global type w_sm10_0060p from w_standard_print
end type
type cbx_1 from checkbox within w_sm10_0060p
end type
type rr_1 from roundrectangle within w_sm10_0060p
end type
end forward

global type w_sm10_0060p from w_standard_print
integer width = 4667
integer height = 2596
string title = "HMC VAN 현황"
cbx_1 cbx_1
rr_1 rr_1
end type
global w_sm10_0060p w_sm10_0060p

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();If dw_ip.AcceptText() <> 1 Then Return -1

String ls_gub
String ls_sit
String ls_eit
String ls_sdat
String ls_edat
String ls_fac

ls_gub  = dw_ip.GetItemString(1, 'gubun'  )
ls_sit  = dw_ip.GetItemString(1, 'sitnbr' )
ls_eit  = dw_ip.GetItemString(1, 'eitnbr' )
ls_sdat = dw_ip.GetItemString(1, 'sdate'  )
ls_edat = dw_ip.GetItemString(1, 'edate'  )
ls_fac  = dw_ip.GetItemString(1, 'factory')

// 품번 전체를 검색 할 때에 ITEMAS의 최소, 최고 품번을 조회한다.
Long   li_no
If Trim(ls_sit) = '' AND Trim(ls_eit) = '' Then
	SELECT MIN(ITNBR), MAX(ITNBR)
	  INTO :ls_sit  , :ls_eit
	  FROM ITEMAS ;
	If SQLCA.SQLCODE <> 0 Then
		MessageBox('에러', '품목마스터를 조회할 수 없습니다.~n~r전산실에 문의 바랍니다.')
		Return -1
	End If
	
	li_no = 1
Else
	li_no = 2
END IF

If Trim(ls_sit)  = '' OR IsNull(ls_sit)  Then ls_sit  = '.'
If Trim(ls_eit)  = '' OR IsNull(ls_eit)  Then ls_eit  = 'Z'
If Trim(ls_sdat) = '' OR IsNull(ls_sdat) Then ls_sdat = String(TODAY(), 'yyyymmdd')
If Trim(ls_edat) = '' OR IsNull(ls_edat) Then ls_edat = String(TODAY(), 'yyyymmdd')
If Trim(ls_fac)  = '' OR IsNull(ls_fac)  Then ls_fac  = '%'

String ls_saupj
String ls_cust

ls_saupj = dw_ip.GetItemString(1, 'saupj')
SELECT FUN_GET_REFFPF_VALUE('AD', :ls_saupj, '4')
  INTO :ls_cust
  FROM DUAL ;
  
SELECT REPLACE(:ls_gub, 'CK', '')
  INTO :ls_gub
  FROM DUAL ;
  
dw_list.SetRedraw(False)
dw_list.Retrieve(ls_cust, ls_gub + ls_sdat, ls_gub + ls_edat, ls_sit, ls_eit, ls_fac, li_no)
dw_list.SetRedraw(True)

cbx_1.Checked = False


Return 1

end function

on w_sm10_0060p.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sm10_0060p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;SetNull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
End If

dw_ip.SetItem(1, 'sdate', String(TODAY(), 'yyyymmdd'))
dw_ip.SetItem(1, 'edate', String(TODAY(), 'yyyymmdd'))
end event

type p_xls from w_standard_print`p_xls within w_sm10_0060p
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_sm10_0060p
boolean visible = true
integer x = 4096
integer y = 24
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_sm10_0060p
boolean visible = false
integer x = 3557
integer y = 172
end type

type p_exit from w_standard_print`p_exit within w_sm10_0060p
end type

type p_print from w_standard_print`p_print within w_sm10_0060p
boolean visible = false
integer x = 3547
integer y = 20
end type

type p_retrieve from w_standard_print`p_retrieve within w_sm10_0060p
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







type st_10 from w_standard_print`st_10 within w_sm10_0060p
end type



type dw_print from w_standard_print`dw_print within w_sm10_0060p
string dataobject = "d_sm10_0060p_asan_d2"
end type

type dw_ip from w_standard_print`dw_ip within w_sm10_0060p
integer x = 37
integer y = 32
integer width = 3232
integer height = 332
string dataobject = "d_sm10_0060p_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

string	sSitnbr

Choose Case dwo.name
	Case 'gubun'
		Choose Case data
			Case 'D0'
				dw_list.DataObject = 'd_sm10_0060p_asan_d0'
				dw_print.DataObject = 'd_sm10_0060p_asan_d0'
			Case 'D1'
				dw_list.DataObject = 'd_sm10_0060p_asan_d1'
				dw_print.DataObject = 'd_sm10_0060p_asan_d1'
			Case 'D2'
				dw_list.DataObject = 'd_sm10_0060p_asan_d2'
				dw_print.DataObject = 'd_sm10_0060p_asan_d2'
			Case 'D8'
				dw_list.DataObject = 'd_sm10_0060p_asan_d68'
				dw_print.DataObject = 'd_sm10_0060p_asan_d68'
			Case 'CKD9'
				dw_list.DataObject = 'd_sm10_0060p_asan_ckd9'
				dw_print.DataObject = 'd_sm10_0060p_asan_ckd9'
			Case 'P6'
				dw_list.DataObject = 'd_sm10_0060p_asan_p6'
				dw_print.DataObject = 'd_sm10_0060p_asan_p6'
			Case 'CKD6'
				dw_list.DataObject = 'd_sm10_0060p_asan_ckd68'
				dw_print.DataObject = 'd_sm10_0060p_asan_ckd68'
			Case 'CKD2'
				dw_list.DataObject = 'd_sm10_0060p_asan_ckd2'
				dw_print.DataObject = 'd_sm10_0060p_asan_ckd2'
			Case 'CKD0'
				dw_list.DataObject = 'd_sm10_0060p_asan_ckd0'
				dw_print.DataObject = 'd_sm10_0060p_asan_ckd0'
			Case 'CKD1'
				dw_list.DataObject = 'd_sm10_0060p_asan_ckd1'
				dw_print.DataObject = 'd_sm10_0060p_asan_ckd1'
			Case 'D6'
				dw_list.DataObject = 'd_sm10_0060p_asan_d68'
				dw_print.DataObject = 'd_sm10_0060p_asan_d68'
			Case 'D9'
				dw_list.DataObject = 'd_sm10_0060p_asan_d9'
				dw_print.DataObject = 'd_sm10_0060p_asan_d9'
			Case 'DH'
				dw_list.DataObject = 'd_sm10_0060p_asan_dh'
				dw_print.DataObject = 'd_sm10_0060p_asan_dh'
			Case 'P7'
				dw_list.DataObject = 'd_sm10_0060p_asan_p7'
				dw_print.DataObject = 'd_sm10_0060p_asan_p7'
			Case 'CKD8'
				dw_list.DataObject = 'd_sm10_0060p_asan_ckd68'
				dw_print.DataObject = 'd_sm10_0060p_asan_ckd68'
		End Choose
	
	Case 'sitnbr'
		this.setitem(1, 'eitnbr', data)
		
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)
End Choose
end event

type dw_list from w_standard_print`dw_list within w_sm10_0060p
integer x = 50
integer y = 396
integer width = 4562
integer height = 1848
string dataobject = "d_sm10_0060p_asan_d2"
boolean border = false
end type

type cbx_1 from checkbox within w_sm10_0060p
integer x = 3310
integer y = 268
integer width = 375
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = variable!
fontfamily fontfamily = modern!
string facename = "굴림"
boolean underline = true
long textcolor = 128
long backcolor = 32106727
string text = "소계 숨김"
end type

event clicked;If This.Checked Then
	dw_list.Modify("datawindow.trailer.1.height=0")
Else
	dw_list.Modify("datawindow.trailer.1.height=64")
End If
end event

type rr_1 from roundrectangle within w_sm10_0060p
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 384
integer width = 4590
integer height = 1872
integer cornerheight = 40
integer cornerwidth = 55
end type

