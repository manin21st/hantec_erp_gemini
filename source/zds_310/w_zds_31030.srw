$PBExportHeader$w_zds_31030.srw
$PBExportComments$월 수불내역
forward
global type w_zds_31030 from w_standard_print
end type
type pb_1 from u_pb_cal within w_zds_31030
end type
type cb_1 from commandbutton within w_zds_31030
end type
type rr_1 from roundrectangle within w_zds_31030
end type
end forward

global type w_zds_31030 from w_standard_print
string title = "월 수불내역"
pb_1 pb_1
cb_1 cb_1
rr_1 rr_1
end type
global w_zds_31030 w_zds_31030

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

String ls_ym

ls_ym = dw_ip.GetItemString(1, 'ym')
If Trim(ls_ym) = '' Or IsNull(ls_ym) Then
	MessageBox('기준 월 확인!', '기준 월은 필수 입력 사항입니다!', Information!)
	Return -1
End If

String ls_fac

ls_fac = dw_ip.GetItemString(1, 'fac')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then
	MessageBox('공장 확인!', '공장은 필수 선택 사항입니다!', Information!)
	Return -1
End If

Long   i
String ls_ymd[], ls_date[]

For i = 1 To 31
	ls_ymd[i]  = 'D2' + ls_ym + String(i, '00') + ls_fac
//	ls_date[i] = ls_ym + String(i, '00')
Next

dw_list.SetRedraw(False)
dw_list.Retrieve(ls_fac, ls_ym, ls_ymd[])
dw_list.SetRedraw(True)

If dw_list.RowCount() > 0 Then
	cb_1.TriggerEvent('Clicked')
End If

Return 1
end function

on w_zds_31030.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.cb_1=create cb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.rr_1
end on

on w_zds_31030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.cb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;dw_ip.SetItem(1, 'ym', String(TODAY(), 'yyyymm'))
end event

type p_xls from w_standard_print`p_xls within w_zds_31030
boolean visible = true
integer x = 4219
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_zds_31030
integer x = 3502
integer y = 36
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_zds_31030
boolean visible = false
integer x = 3145
end type

type p_exit from w_standard_print`p_exit within w_zds_31030
integer x = 4393
end type

type p_print from w_standard_print`p_print within w_zds_31030
boolean visible = false
integer x = 3319
end type

type p_retrieve from w_standard_print`p_retrieve within w_zds_31030
integer x = 4046
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







type st_10 from w_standard_print`st_10 within w_zds_31030
end type



type dw_print from w_standard_print`dw_print within w_zds_31030
string dataobject = "d_zds_31030_002"
end type

type dw_ip from w_standard_print`dw_ip within w_zds_31030
integer x = 37
integer y = 32
integer width = 2002
integer height = 200
string dataobject = "d_zds_31030_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If This.GetRow() < 1 Then Return -1

Choose Case dwo.name
	Case 'fac'
		If Trim(data) = '' OR IsNull(data) Then Return
		
		Choose Case data
			Case 'HE21', 'HK21', 'HV21'
				If dw_list.DataObject = 'd_zds_31030_003' Then Return -1

				dw_list.DataObject = 'd_zds_31030_003'
				dw_print.DataObject = 'd_zds_31030_003'
			Case Else
				If dw_list.DataObject = 'd_zds_31030_002' Then Return -1

				dw_list.DataObject = 'd_zds_31030_002'
				dw_print.DataObject = 'd_zds_31030_002'
		End Choose
		
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)
End Choose

end event

type dw_list from w_standard_print`dw_list within w_zds_31030
integer x = 50
integer y = 248
integer width = 4512
integer height = 1984
string dataobject = "d_zds_31030_002"
boolean border = false
end type

event dw_list::doubleclicked;call super::doubleclicked;If row < 1 Then Return

String ls_dwo

ls_dwo = dwo.name

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_codename2)

gs_code      = String(This.GetItemNumber(row, ls_dwo))  //재고
gs_codename  = This.GetItemString(row, 'factory'     )  //공장
gs_codename2 = This.GetItemString(row, 'mitnbr'      )  //품번
gs_gubun     = This.GetItemString(row, 'ym'          )  //기준년월

If LEFT(dwo.name, 2) = 'e_' Then
	Open(w_stock_napum_ewol)
End If
end event

type pb_1 from u_pb_cal within w_zds_31030
integer x = 530
integer y = 80
integer height = 76
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('ym')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'ym', LEFT(gs_code, 6))

end event

type cb_1 from commandbutton within w_zds_31030
boolean visible = false
integer x = 2176
integer y = 96
integer width = 402
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "none"
end type

event clicked;String ls_ym
String ls_fac
String ls_itn
String ls_doc
Long   ll_d1, ll_d2, ll_d3 , ll_d4 , ll_d5 , ll_d6 , ll_d7
Long   ll_d8, ll_d9, ll_d10, ll_d11, ll_d12, ll_d13, ll_d14

ls_ym  = dw_ip.GetItemString(1, 'ym')
ls_fac = dw_ip.GetItemString(1, 'fac')
ls_doc = 'D2' + String(TODAY(), 'yyyymmdd') + ls_fac

Long   i

If ls_ym <> String(TODAY(), 'yyyymm') Then Return

For i = 1 To dw_list.RowCount()
	ls_itn = dw_list.GetItemString(i, 'mitnbr')
	
	If ls_fac = 'HE21' OR ls_fac = 'HV21' OR ls_fac = 'HK21' Then
		  SELECT PLAN_D1TQTY, PLAN_D2TQTY, PLAN_D3TQTY, PLAN_D4TQTY, PLAN_D5QTY , PLAN_D6QTY , PLAN_D7QTY ,
					PLAN_D8QTY , PLAN_D9QTY , PLAN_D10QTY, PLAN_D11QTY, PLAN_D12QTY, PLAN_D13QTY, PLAN_D14QTY
			 INTO :ll_d1, :ll_d2, :ll_d3 , :ll_d4 , :ll_d5 , :ll_d6 , :ll_d7 ,
					:ll_d8, :ll_d9, :ll_d10, :ll_d11, :ll_d12, :ll_d13, :ll_d14
			 FROM VAN_ERPD2
			WHERE SABU    = :gs_sabu
			  AND DOCCODE = :ls_doc
			  AND MITNBR  = :ls_itn  ;
		If SQLCA.SQLCODE <> 0 Then	Continue
		
	Else
		
		  SELECT PLAN_D1TQTY, PLAN_D2TQTY, PLAN_D3TQTY, PLAN_D4TQTY, PLAN_D5QTY , PLAN_D6QTY , PLAN_D7QTY ,
					PLAN_D8QTY , PLAN_D9QTY , PLAN_D10QTY, PLAN_D11QTY, PLAN_D12QTY, PLAN_D13QTY, PLAN_D14QTY
			 INTO :ll_d1, :ll_d2, :ll_d3 , :ll_d4 , :ll_d5 , :ll_d6 , :ll_d7 ,
					:ll_d8, :ll_d9, :ll_d10, :ll_d11, :ll_d12, :ll_d13, :ll_d14
			 FROM VAN_HKCD2
			WHERE SABU    = :gs_sabu
			  AND DOCCODE = :ls_doc
			  AND MITNBR  = :ls_itn  ;
		If SQLCA.SQLCODE <> 0 Then	Continue
	End If
		
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 1) , 'mm') Then
		dw_list.SetItem(i, 'p' + String(RelativeDate(TODAY(), 1) , 'dd'), ll_d1 )
	End If
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 2) , 'mm') Then
		dw_list.SetItem(i, 'p' + String(RelativeDate(TODAY(), 2) , 'dd'), ll_d2 )
	End If
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 3) , 'mm') Then
		dw_list.SetItem(i, 'p' + String(RelativeDate(TODAY(), 3) , 'dd'), ll_d3 )
	End If
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 4) , 'mm') Then
		dw_list.SetItem(i, 'p' + String(RelativeDate(TODAY(), 4) , 'dd'), ll_d4 )
	End If
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 5) , 'mm') Then
		dw_list.SetItem(i, 'p' + String(RelativeDate(TODAY(), 5) , 'dd'), ll_d5 )
	End If
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 6) , 'mm') Then
		dw_list.SetItem(i, 'p' + String(RelativeDate(TODAY(), 6) , 'dd'), ll_d6 )
	End If
	If String(TODAY(), 'mm') = String(RelativeDate(TODAY(), 7) , 'mm') Then
		dw_list.SetItem(i, 'p' + String(RelativeDate(TODAY(), 7) , 'dd'), ll_d7 )
	End If
Next
end event

type rr_1 from roundrectangle within w_zds_31030
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 37
integer y = 240
integer width = 4539
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 55
end type

