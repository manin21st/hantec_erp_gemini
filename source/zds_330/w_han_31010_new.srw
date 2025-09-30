$PBExportHeader$w_han_31010_new.srw
$PBExportComments$매출 대비 검수
forward
global type w_han_31010_new from w_standard_print
end type
type st_1 from statictext within w_han_31010_new
end type
type pb_1 from u_pb_cal within w_han_31010_new
end type
type pb_2 from u_pb_cal within w_han_31010_new
end type
type rb_2 from radiobutton within w_han_31010_new
end type
type rb_1 from radiobutton within w_han_31010_new
end type
type gb_1 from groupbox within w_han_31010_new
end type
type rr_1 from roundrectangle within w_han_31010_new
end type
end forward

global type w_han_31010_new from w_standard_print
integer height = 2496
string title = "월 마감현황(기간별)"
st_1 st_1
pb_1 pb_1
pb_2 pb_2
rb_2 rb_2
rb_1 rb_1
gb_1 gb_1
rr_1 rr_1
end type
global w_han_31010_new w_han_31010_new

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_change ()
end prototypes

public function integer wf_retrieve ();dw_ip.AcceptText()

Long   row

row = dw_ip.GetRow()
If row < 1 Then Return -1

String ls_ym, ls_ym2

ls_ym = dw_ip.GetItemString(row, 'yymm')
If Trim(ls_ym) = '' Or IsNull(ls_ym) Then
	MessageBox('기준월 확인', '기준일은 필수 입력 항목입니다.')
	dw_ip.SetColumn('yymm')
	dw_ip.SetFocus()
	Return -1
End If

ls_ym2 = dw_ip.GetItemString(row, 'yymm2')
If Trim(ls_ym2) = '' Or IsNull(ls_ym2) Then
	MessageBox('기준월 확인', '기준일은 필수 입력 항목입니다.')
	dw_ip.SetColumn('yymm2')
	dw_ip.SetFocus()
	Return -1
End If

String ls_itnbr

ls_itnbr = dw_ip.GetItemString(row, 'itnbr')
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

String ls_cvcod

ls_cvcod = dw_ip.GetItemString(row, 'cvcod')
If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then ls_cvcod = '%'

String ls_fac

ls_fac = dw_ip.GetItemString(row, 'factory')
If Trim(ls_fac) = '' OR IsNull(ls_fac) Then ls_fac = '%'

dw_list.SetRedraw(False)
dw_list.Retrieve(gs_sabu, ls_ym, ls_ym2, ls_cvcod, ls_itnbr, ls_fac)
dw_list.SetRedraw(True)

If dw_list.Rowcount() < 1 Then Return 0

dw_list.ShareData(dw_print)

Return 0



end function

public subroutine wf_change ();DataWindowChild ldwc_fact

If rb_1.Checked Then
	dw_list.DataObject = "d_han_31010_new_002_1"

Else
	dw_list.DataObject = "d_han_31010_new_002_2"

End if

dw_list.SetTransObject(SQLCA)

end subroutine

on w_han_31010_new.create
int iCurrent
call super::create
this.st_1=create st_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rb_2=create rb_2
this.rb_1=create rb_1
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.rr_1
end on

on w_han_31010_new.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;f_mod_saupj(dw_ip, 'saupj')

//dw_ip.SetItem(1, 'yymm', String(TODAY(), 'yyyymmdd'))
//dw_ip.SetItem(1, 'yymm2', String(TODAY(), 'yyyymm')+'31')
dw_ip.SetItem(1, 'yymm', left(f_today(),6))
dw_ip.SetItem(1, 'yymm2', left(f_today(),6))
end event

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY", "SUB2_T"."UPMU"  
  INTO :is_usegub,  :is_upmu 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id  ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

IF is_upmu = 'A' THEN //회계인 경우
   int iRtnVal 

	IF Upper(Mid(is_window_id,4,2)) = 'BG' THEN							   /*예산*/
		IF F_Valid_EmpNo(Gs_EmpNo) = 'N' THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF
	ELSE
		IF Upper(Mid(is_window_id,4,2)) = 'FI' THEN							/*자금*/
			iRtnVal = F_Authority_Fund_Chk(Gs_Dept)	
		ELSE
			iRtnVal = F_Authority_Chk(Gs_Dept)
		END IF
		IF iRtnVal = -1 THEN							/*권한 체크- 현업 여부*/
			dw_ip.SetItem(dw_ip.GetRow(),"saupj",   Gs_Saupj)
			
			dw_ip.Modify("saupj.protect = 1")
		ELSE
			dw_ip.Modify("saupj.protect = 0")
		END IF	
	END IF
END IF
dw_print.object.datawindow.print.preview = "yes"	

PostEvent('ue_open')
end event

type p_xls from w_standard_print`p_xls within w_han_31010_new
boolean visible = true
integer x = 4270
integer y = 24
boolean enabled = false
string picturename = "C:\erpman\image\엑셀변환_d.gif"
end type

type p_sort from w_standard_print`p_sort within w_han_31010_new
integer x = 4101
integer y = 176
boolean enabled = false
boolean originalsize = false
end type

type p_preview from w_standard_print`p_preview within w_han_31010_new
end type

type p_exit from w_standard_print`p_exit within w_han_31010_new
end type

type p_print from w_standard_print`p_print within w_han_31010_new
boolean visible = false
integer x = 4265
integer y = 176
end type

type p_retrieve from w_standard_print`p_retrieve within w_han_31010_new
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
	
	IF rb_2.Checked THEN
		p_preview.enabled = False
		p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	END IF
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







type st_10 from w_standard_print`st_10 within w_han_31010_new
end type



type dw_print from w_standard_print`dw_print within w_han_31010_new
integer x = 4443
integer y = 192
string dataobject = "d_han_31010_new_003"
end type

type dw_ip from w_standard_print`dw_ip within w_han_31010_new
integer x = 37
integer width = 3346
integer height = 256
string dataobject = "d_han_31010_new_001"
end type

event dw_ip::itemchanged;call super::itemchanged;If row < 1 Then Return

String sCvcod
String snull

Choose Case dwo.name
	Case 'cvcod'
		sCvcod = Data
		IF sCvcod = '' OR IsNull(sCvcod) THEN
			This.SetItem(row, 'cvnas', snull)
			Return
		END IF
			
		This.SetItem(row, 'cvnas', f_get_name5('11', sCvcod, ''))
End Choose
end event

event dw_ip::rbuttondown;call super::rbuttondown;If row < 1 Then Return

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Choose Case dwo.name
	/* 거래처 */
	Case 'cvcod'
		gs_gubun = '1'
		Open(w_vndmst_popup)
		
		IF gs_code = '' OR IsNull(gs_code) THEN RETURN
		
		This.SetItem(row, 'cvcod', gs_code)
		This.SetItem(row, 'cvnas', gs_codename)
		
End Choose
end event

type dw_list from w_standard_print`dw_list within w_han_31010_new
integer y = 308
integer width = 4512
integer height = 1936
string dataobject = "d_han_31010_new_002_1"
boolean border = false
end type

type st_1 from statictext within w_han_31010_new
integer x = 2144
integer y = 176
integer width = 645
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 128
long backcolor = 33027312
string text = "※ 제품창고 출고 기준"
boolean focusrectangle = false
end type

type pb_1 from u_pb_cal within w_han_31010_new
integer x = 1851
integer y = 56
integer height = 76
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;string ls_date
//해당 컬럼 지정
dw_ip.SetColumn('yymm')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
//ls_date를 활용하여 년월 값 지정 '21.10.06 BY JHKIM
ls_date = left(gs_code, 6)
dw_ip.SetItem(1, 'yymm', ls_date)
end event

type pb_2 from u_pb_cal within w_han_31010_new
integer x = 2304
integer y = 56
integer height = 76
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;string ls_date
//해당 컬럼 지정
dw_ip.SetColumn('yymm2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
//ls_date를 활용하여 년월 값 지정 '21.10.06 BY JHKIM
ls_date = left(gs_code, 6)
dw_ip.SetItem(1, 'yymm2', ls_date)
end event

type rb_2 from radiobutton within w_han_31010_new
integer x = 3488
integer y = 168
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

type rb_1 from radiobutton within w_han_31010_new
integer x = 3488
integer y = 76
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

type gb_1 from groupbox within w_han_31010_new
integer x = 3451
integer y = 12
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

type rr_1 from roundrectangle within w_han_31010_new
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 37
integer y = 312
integer width = 4535
integer height = 1956
integer cornerheight = 40
integer cornerwidth = 55
end type

