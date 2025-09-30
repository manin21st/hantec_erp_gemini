$PBExportHeader$w_qa01_00040.srw
$PBExportComments$** 정기검사 결과 등록
forward
global type w_qa01_00040 from w_inherite
end type
type cb_1 from commandbutton within w_qa01_00040
end type
type dw_ip from datawindow within w_qa01_00040
end type
type p_auto from uo_picture within w_qa01_00040
end type
type rb_1 from radiobutton within w_qa01_00040
end type
type rb_2 from radiobutton within w_qa01_00040
end type
type gb_1 from groupbox within w_qa01_00040
end type
type rr_3 from roundrectangle within w_qa01_00040
end type
end forward

global type w_qa01_00040 from w_inherite
integer width = 4622
integer height = 2480
string title = "정기검사 결과 등록"
cb_1 cb_1
dw_ip dw_ip
p_auto p_auto
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
rr_3 rr_3
end type
global w_qa01_00040 w_qa01_00040

type prototypes
FUNCTION boolean CopyFileA(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll"
FUNCTION LONG ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "shell32.DLL" 

end prototypes

type variables
String is_sort
end variables

forward prototypes
public function integer wf_select_chk ()
public function integer wf_init ()
end prototypes

public function integer wf_select_chk ();If dw_ip.AcceptText() < 1 Then Return -1
If dw_ip.RowCount() < 1 Then Return -1


String ls_cvcod , ls_syymm ,ls_eyymm

ls_cvcod = Trim(dw_ip.Object.cvcod[1])
ls_syymm  = Trim(dw_ip.Object.syymm[1])
ls_eyymm  = Trim(dw_ip.Object.eyymm[1])

If ls_cvcod = '' Or isNull(ls_cvcod) Then
	f_message_chk(40,'[거래처코드]')
	Return -1
End If

If ls_syymm = '' Or isNull(ls_syymm) Or f_datechk(ls_syymm+'01') < 1 Or & 
   ls_eyymm = '' Or isNull(ls_eyymm) Or f_datechk(ls_eyymm+'01') < 1 Then
	f_message_chk(35,'[검사월]')
	Return -1
End If

return 1
end function

public function integer wf_init ();String ls_today

ls_today = f_today()

dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.Object.syymm[1]  = Left(ls_today,4) + '01'
dw_ip.Object.eyymm[1]  = Left(ls_today,6)
dw_ip.Enabled = True

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.SetRedraw(True)

Return 1
end function

on w_qa01_00040.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_ip=create dw_ip
this.p_auto=create p_auto
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.p_auto
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.rr_3
end on

on w_qa01_00040.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ip)
destroy(this.p_auto)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.rr_3)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)

wf_init()

end event

type dw_insert from w_inherite`dw_insert within w_qa01_00040
integer x = 64
integer y = 212
integer width = 4489
integer height = 2076
integer taborder = 20
string dataobject = "d_qa01_00040_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String ls_col ,ls_cod ,ls_null
Long   ll_cnt ,ll_row

ib_any_typing = True //입력필드 변경여부 Yes
AcceptText()

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())
SetNull(ls_null)

Choose Case ls_col
	Case 'result_yn'
		If ls_cod = 'Y' Then
			Object.wan_date[row] = is_today
		Else
			Object.wan_date[row] = ls_null
		End If
	Case 'inspt_dt'
		If f_datechk(ls_cod) < 1 or isNull(ls_cod) Or ls_cod = '' Then
			f_message_chk(35 , '검사일자')
			Return 1
		End If
		
End Choose
 
end event

event dw_insert::rbuttondown;String ls_cod
Long   ll_row

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

ll_row = GetRow()

Choose Case Lower(GetColumnName())
	Case "itnbr"
		gs_code = this.GetText()
		open(w_itemas_popup)
	
		if isnull(gs_code) or gs_code = "" then return
		This.Object.itnbr[ll_row] = gs_code
	
		TriggerEvent('ItemChanged')
	
End Choose

end event

event dw_insert::clicked;call super::clicked;String ls_sort

If Right(dwo.Name, 2) = '_t' Then
	ls_sort = left(dwo.Name, Pos(dwo.Name, '_t') - 1) + ' A'
	If ls_sort <> is_sort Then
		is_sort = ls_sort
		SetSort(is_sort)
		Sort()
	End If
End If
end event

event dw_insert::buttonclicked;call super::buttonclicked;AcceptText()
String ls_spath , ls_path , ls_file , ls_inspt_dt
Long   ll_v

Choose Case dwo.name
	
	Case 'b_down'
		ls_spath = Trim(Object.file_path[row])
		
		If ls_spath = '' Or isNull(ls_spath) Then Return
		
		SetPointer(Hourglass!)
		
	   If FileExists(ls_spath) = False Then
			MessageBox('확인','파일서버에 해당 파일이 존재하지 않습니다.')
			Return
		End If
		
		ShellExecuteA(0, "open", ls_spath , "", "", 1) // 파일 자동 실행 

End Choose
		


end event

type p_delrow from w_inherite`p_delrow within w_qa01_00040
boolean visible = false
integer x = 4882
integer y = 432
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qa01_00040
boolean visible = false
integer x = 4709
integer y = 432
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qa01_00040
boolean visible = false
integer x = 3488
integer y = 3320
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qa01_00040
boolean visible = false
integer x = 4009
integer y = 3320
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qa01_00040
integer x = 4407
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_qa01_00040
integer x = 4233
integer taborder = 60
end type

event p_can::clicked;call super::clicked;
wf_init()

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"

p_del.Enabled = False
p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
ib_any_typing = False //입력필드 변경여부 No


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\자료조회_dn.gif"
end event

type p_print from w_inherite`p_print within w_qa01_00040
boolean visible = false
integer x = 3662
integer y = 3320
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qa01_00040
integer x = 3886
end type

event p_inq::clicked;call super::clicked;String ls_cvcod , ls_syymm , ls_eyymm , ls_result, ls_pdtgu
Long   ll_row

If wf_select_chk() < 1 Then Return

ls_cvcod = Trim(dw_ip.Object.cvcod[1])
if isnull(ls_cvcod) or ls_cvcod = '' then ls_cvcod = '%'

ls_syymm  = Trim(dw_ip.Object.syymm[1])
ls_eyymm  = Trim(dw_ip.Object.eyymm[1])
ls_pdtgu  = Trim(dw_ip.Object.pdtgu[1])

If rb_1.Checked Then
	ls_result = 'Y'
ElseIf rb_2.Checked Then
	ls_result = 'N'
End If

ll_row = dw_insert.Retrieve(ls_cvcod, ls_syymm , ls_eyymm,ls_result,gs_saupj)

If ll_row > 0 Then
	dw_ip.Enabled = False
	ib_any_typing = False //입력필드 변경여부 No
Else
	f_message_chk(50, "")
End If

end event

type p_del from w_inherite`p_del within w_qa01_00040
boolean visible = false
integer x = 4965
integer y = 236
integer taborder = 50
end type

event p_del::clicked;call super::clicked;//String ls_new ,ls_inspt_no
//Long   ll_r
//
//ll_r = dw_insert.GetRow()
//If ll_r < 1 Then Return
//
//ls_new = Trim(dw_insert.Object.is_new[ll_r])
//ls_inspt_no = Trim(dw_insert.Object.inspt_no[ll_r])
//
//If ls_inspt_no > '' Then
//	MessageBox('확인','검사성적서가 첨부되어 정기검사 중인 항목입니다. 삭제 불가능 합니다.')
//	return
//End If
//
//If f_msg_delete() < 1 Then Return
//
//dw_insert.DeleteRow(ll_r)
//
//If ls_new = 'N' Then
//	If dw_insert.Update() = 1 Then
//		Commit;
//		
//	Else
//		Rollback ;
//		f_rollback()
//		Return
//	End If
//
//End If
end event

type p_mod from w_inherite`p_mod within w_qa01_00040
integer x = 4059
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)
Long i
String ls_cvcod , ls_yymm ,ls_inspt_dt , ls_result ,ls_itnbr
String ls_spath , ls_lpath
If dw_insert.AcceptText() = -1 Then Return -1
If dw_insert.RowCount() < 1 Then Return

If wf_select_chk() < 1 Then Return

If f_msg_update() = -1 Then Return  //저장 Yes/No ?

For i =1 To dw_insert.RowCount()
	ls_cvcod 	= Trim(dw_insert.Object.cvcod[i])
	ls_result   = Trim(dw_insert.Object.result_yn[i])
	ls_inspt_dt = Trim(dw_insert.Object.wan_date[i])
	ls_itnbr    = Trim(dw_insert.Object.itnbr[i])
	
	If ls_result = 'Y'  Then
		If ls_inspt_dt = '' Or isNull(ls_inspt_dt) Or f_datechk(ls_inspt_dt) < 1 Then
			f_message_chk(35 , '[검사일자]')
			Return
		End If
		// 정기검사 기준정보 Update ==========
		UPDATE INSPECT_JUGI SET INSPECT_DT  = :ls_inspt_dt
		              WHERE CVCOD = :ls_cvcod
						    AND ITNBR = :ls_itnbr ;
		If SQLCA.SQLCODE <> 0 Then
			Rollback;
			MessageBox('확인','정기검사 기준정보 Update 실패 ')
			Return
		End If
	End If
	
	
Next
dw_insert.AcceptText()

If dw_insert.Update() <> 1 Then
	ROLLBACK;
	f_message_chk(32,'[자료저장 실패]') 
	w_mdi_frame.sle_msg.text = "저장작업을 실패 하였습니다!"
	Return
Else
	Commit ;
	w_mdi_frame.sle_msg.text = "저장작업을 완료 하였습니다!"
	p_inq.TriggerEvent(Clicked!)
End If

ib_any_typing = False //입력필드 변경여부 No

SetPointer(Arrow!)
 
end event

type cb_exit from w_inherite`cb_exit within w_qa01_00040
integer x = 2825
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_qa01_00040
integer x = 1783
integer y = 3292
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qa01_00040
integer x = 942
integer y = 2344
integer taborder = 90
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_qa01_00040
integer x = 2130
integer y = 3292
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qa01_00040
integer x = 1422
integer y = 3296
end type

type cb_print from w_inherite`cb_print within w_qa01_00040
integer x = 1874
integer y = 2348
end type

type st_1 from w_inherite`st_1 within w_qa01_00040
integer x = 0
integer y = 3520
end type

type cb_can from w_inherite`cb_can within w_qa01_00040
integer x = 2478
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_qa01_00040
integer x = 1371
integer y = 2348
end type

type dw_datetime from w_inherite`dw_datetime within w_qa01_00040
integer x = 2843
integer y = 3520
end type

type sle_msg from w_inherite`sle_msg within w_qa01_00040
integer x = 352
integer y = 3520
end type

type gb_10 from w_inherite`gb_10 within w_qa01_00040
integer y = 3488
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_qa01_00040
end type

type gb_button2 from w_inherite`gb_button2 within w_qa01_00040
end type

type cb_1 from commandbutton within w_qa01_00040
boolean visible = false
integer x = 2267
integer y = 2344
integer width = 576
integer height = 108
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "BOM사용내역 조회"
end type

type dw_ip from datawindow within w_qa01_00040
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 24
integer width = 2194
integer height = 164
integer taborder = 90
string title = "none"
string dataobject = "d_qa01_00040_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)

END IF
end event

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;RETURN 1
end event

event itemchanged;String ls_col ,ls_cod , ls_cvnas, ls_null
Long   ll_cnt ,ll_row

setnull(ls_null)
ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())   

Choose Case ls_col
	Case "cvcod" 
		If ls_cod = '' Or isNull(ls_cod)  Then
			f_message_chk(33 , '[거래처]')
			SetColumn(ls_col)
			Return 1
		End If
		
		Select cvnas 
		  Into :ls_cvnas 
		  From vndmst
		  Where cvcod = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[거래처]")
			This.Object.cvcod[GetRow()] = ""
			Return 1
		End If
		
		This.Object.cvnas[GetRow()] = ls_cvnas
		

	Case "yymm" 
		ls_cod = ls_cod + '01'
		If ls_cod = '' Or isNull(ls_cod) Or f_datechk(ls_cod) < 0  Then
			f_message_chk(35 , '[검사월]')
			SetColumn(ls_col)
			Return 1
		End If

	Case "cvnas"
		if isnull(ls_cod) or ls_cod = '' then return
		
		select cvcod, cvnas2 into :ls_cod, :ls_cvnas from vndmst
		 where cvnas2 like '%'||:ls_cod||'%' and rownum = 1 ;
		if sqlca.sqlcode = 0 then
			this.setitem(1,'cvcod',ls_cod)
			this.setitem(1,'cvnas',ls_cvnas)
		else
			this.setitem(1,'cvcod',ls_null)
			this.setitem(1,'cvnas',ls_null)
		end if
		
		return 2
End Choose
 
end event

event rbuttondown;gs_code = ''
gs_codename = ''
gs_gubun = ''

IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then return
	this.SetItem(1, "cvcod", gs_Code)
	this.TriggerEvent("itemchanged")	
END IF
end event

type p_auto from uo_picture within w_qa01_00040
boolean visible = false
integer x = 4773
integer y = 244
integer width = 183
integer taborder = 30
boolean bringtotop = true
string picturename = "C:\erpman\image\일괄지정_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\일괄지정_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\일괄지정_up.gif"
end event

event clicked;call super::clicked;String ls_cvcod , ls_yymm
String ls_itnbr , ls_itdsc ,ls_ispec, ls_expt_dt
Long   ll_r = 0

If wf_select_chk() < 1 Then Return

ls_cvcod = Trim(dw_ip.Object.cvcod[1])
ls_yymm  = Trim(dw_ip.Object.yymm[1])


DECLARE itnbr_cur CURSOR FOR 
	
	SELECT A.ITNBR ,
			 B.ITDSC ,
			 B.ISPEC ,
			 A.EXPT_DT
	  FROM INSPECT_JUGI A ,ITEMAS B 
	 WHERE A.ITNBR = B.ITNBR
		AND A.CVCOD = :ls_cvcod
		AND (CASE WHEN A.MON_01 ='Y' THEN '01' 
					 WHEN A.MON_02 ='Y' THEN '02'
					 WHEN A.MON_03 ='Y' THEN '03'
					 WHEN A.MON_04 ='Y' THEN '04'
					 WHEN A.MON_05 ='Y' THEN '05'
					 WHEN A.MON_06 ='Y' THEN '06'
					 WHEN A.MON_07 ='Y' THEN '07'
					 WHEN A.MON_08 ='Y' THEN '08'
					 WHEN A.MON_09 ='Y' THEN '09'
					 WHEN A.MON_10 ='Y' THEN '10'
					 WHEN A.MON_11 ='Y' THEN '11'
					 WHEN A.MON_12 ='Y' THEN '12'END 
					 )  = Substr(:ls_yymm,5,2) ;
		
Open itnbr_cur ;
	
Do While True
		
	FETCH itnbr_cur Into :ls_itnbr , :ls_itdsc ,:ls_ispec, :ls_expt_dt ;
		
	If sqlca.sqlcode <> 0 Then Exit 
		
	ll_r = dw_insert.InsertRow(0)
	dw_insert.Object.itnbr[ll_r]        = ls_itnbr
	dw_insert.Object.itemas_itdsc[ll_r] = ls_itdsc
	dw_insert.Object.itemas_ispec[ll_r] = ls_ispec
	dw_insert.Object.req_dt[ll_r]       = ls_expt_dt
	
Loop
	
Close itnbr_cur ;

If ll_r < 1 Then
	MessageBox('확인','해당 조건에 맞는 정기검사 품번이 존재하지 않습니다.')
	dw_ip.Enabled = True
	Return
Else
	dw_ip.Enabled = False
End If
	



end event

type rb_1 from radiobutton within w_qa01_00040
integer x = 2313
integer y = 48
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
string text = "검사완료"
end type

type rb_2 from radiobutton within w_qa01_00040
integer x = 2313
integer y = 112
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
string text = "검사대기"
boolean checked = true
end type

type gb_1 from groupbox within w_qa01_00040
integer x = 2272
integer width = 425
integer height = 188
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
end type

type rr_3 from roundrectangle within w_qa01_00040
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 200
integer width = 4526
integer height = 2100
integer cornerheight = 40
integer cornerwidth = 55
end type

