$PBExportHeader$w_pdm_01370_vendor.srw
$PBExportComments$** 단가마스타 등록(거래처별수정)
forward
global type w_pdm_01370_vendor from w_inherite
end type
type cb_excel_download from commandbutton within w_pdm_01370_vendor
end type
type cb_excel_upload from commandbutton within w_pdm_01370_vendor
end type
type dw_excel_download from datawindow within w_pdm_01370_vendor
end type
end forward

global type w_pdm_01370_vendor from w_inherite
string title = "구매,외주 단가 거래처 수정"
cb_excel_download cb_excel_download
cb_excel_upload cb_excel_upload
dw_excel_download dw_excel_download
end type
global w_pdm_01370_vendor w_pdm_01370_vendor

forward prototypes
public subroutine wf_excel_down (datawindow ar_datawindow)
end prototypes

public subroutine wf_excel_down (datawindow ar_datawindow);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If uf_save_dw_as_excel(ar_datawindow,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end subroutine

on w_pdm_01370_vendor.create
int iCurrent
call super::create
this.cb_excel_download=create cb_excel_download
this.cb_excel_upload=create cb_excel_upload
this.dw_excel_download=create dw_excel_download
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_excel_download
this.Control[iCurrent+2]=this.cb_excel_upload
this.Control[iCurrent+3]=this.dw_excel_download
end on

on w_pdm_01370_vendor.destroy
call super::destroy
destroy(this.cb_excel_download)
destroy(this.cb_excel_upload)
destroy(this.dw_excel_download)
end on

event open;call super::open;dw_input.InsertRow(0)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event activate;gw_window = this

w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", false) //// 추가
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", false) //// 삭제
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true) //// 저장
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true) //// 취소
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", false) //// 찾기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 false) //// 필터
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", true) //// 엑셀다운
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", false) //// 출력
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", false) //// 미리보기
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", true) //// 도움말
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true)

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = false //// 추가
m_main2.m_window.m_del.enabled = false  //// 삭제
m_main2.m_window.m_save.enabled = true //// 저장
m_main2.m_window.m_cancel.enabled = true //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = false  //// 찾기
m_main2.m_window.m_filter.enabled = false //// 필터
m_main2.m_window.m_excel.enabled = true //// 엑셀다운
m_main2.m_window.m_print.enabled = false  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01370_vendor
integer y = 3576
end type

type sle_msg from w_inherite`sle_msg within w_pdm_01370_vendor
integer y = 3392
end type

type dw_datetime from w_inherite`dw_datetime within w_pdm_01370_vendor
integer y = 3392
end type

type st_1 from w_inherite`st_1 within w_pdm_01370_vendor
integer y = 3364
end type

type p_search from w_inherite`p_search within w_pdm_01370_vendor
integer y = 3396
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01370_vendor
integer y = 3396
end type

type p_delrow from w_inherite`p_delrow within w_pdm_01370_vendor
integer y = 3396
end type

type p_mod from w_inherite`p_mod within w_pdm_01370_vendor
integer y = 3396
end type

event p_mod::clicked;call super::clicked;string sopt, sitnbr, sopseq, sguout, scvcod
long   lcount, k, lcnt

IF dw_insert.accepttext() = -1 then return 
if dw_input.accepttext() = -1 then return

IF dw_insert.rowcount() < 1 then return

If dw_input.GetItemString(1, 'gub') = '1' Then
	FOR k=1 TO dw_insert.rowcount()
		 sopt  = dw_insert.getitemstring(k, "opt")
		 
		if sopt = 'Y' then 
			lcount = lcount + 1
			
		end if	 
	NEXT
	
	if lcount < 1 then return 
	
	IF MessageBox("확인", "자료를 저장하시면 단가이력이 생성됩니다." + '~n~n' + & 
                      "자료를 저장하시겠습니까?", question!, yesno!) = 2 THEN	RETURN 1
End If


/////////////////////////////////////////////////////////////////////
dec		dPrice, dTemp
string	sItem, sVendor, sSeq, sToday

sToday = f_Today()

If dw_input.GetItemString(1, 'gub') = '1' Then
	FOR k=1 TO dw_insert.rowcount()
		 sopt  = dw_insert.getitemstring(k, "opt")
		 
		If sopt = 'Y' then 
			sItem   = dw_insert.getitemstring(k, "danmst_itnbr")
			sVendor = dw_insert.getitemstring(k, "danmst_cvcod")
			sSeq    = dw_insert.getitemstring(k, "danmst_opseq")
			dPrice  = dw_insert.getitemdecimal(k, "danmst_unprc")
			dtemp   = dw_insert.getitemdecimal(k, "yunprc")
		
			INSERT INTO "DANHST"  
					  ( "ITNBR", "CVCOD", "CDATE", "OPSEQ", "BAMT", "AAMT", "IDATE", "REMARK" )  
			 VALUES ( :sItem,  :sVendor,:sToday, :sSeq,   :dTemp, :dPrice,:sToday, null )  ;
		
			IF SQLCA.SQLCODE <> 0	THEN
				
				UPDATE DANHST
					SET BAMT = :dTemp,
						 AAMT = :dPrice
				 WHERE ITNBR = :sItem	and
						 CVCOD = :sVendor and
						 CDATE = :sToday  and
						 OPSEQ = :sSeq		;
			END IF
		END IF
	NEXT
End If

IF dw_insert.Update() > 0 THEN		
	
	If dw_input.GetItemString(1, 'gub') = '1' Then
		// 우선거래처 변경
		for k = 1 to dw_insert.rowcount()
			 scvcod = dw_insert.getitemstring(k, "danmst_cvcod")
			 sitnbr = dw_insert.getitemstring(k, "danmst_itnbr")		
			 sopseq = dw_insert.getitemstring(k, "danmst_opseq")		
			 sguout = dw_insert.getitemstring(k, "danmst_guout")
				
			// 다른 거래처는 차선거래처로 변경
			if dw_insert.getitemstring(k, "sltcd") = 'Y' then
				 Update danmst set sltcd = 'N'
				  where itnbr = :sitnbr
					 And opseq = :sopseq
					 And cvcod != :scvcod
					 And guout = :sguout;
			// 다른 거래처를 우선거래처로 변경			
			else
				 lcnt = 0
				 Select count(*) into :lcnt from danmst
				  Where itnbr = :sitnbr and opseq = :sopseq and guout = :sguout and sltcd = 'Y';
				 if lcnt <> 1 then
					 Update danmst set sltcd = 'Y'
					  where itnbr = :sitnbr
						 And opseq = :sopseq
						 And cvcod != :scvcod
						 And guout = :sguout
						 And rownum = 1;			
				 end if
			end if	
		
		Next		
	End If
	
	messagebox("저장완료", "자료에 대한 저장이 완료되었읍니다")	
	
	COMMIT;
ELSE
	ROLLBACK USING sqlca;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
END IF

dw_insert.Retrieve(gs_saupj,TRIM(dw_input.GetItemString(1,"cvcod")), gs_saupj) 
dw_input.SetFocus()

end event

type p_del from w_inherite`p_del within w_pdm_01370_vendor
integer y = 3396
end type

type p_inq from w_inherite`p_inq within w_pdm_01370_vendor
integer y = 3396
end type

event p_inq::clicked;call super::clicked;String scust

dw_input.AcceptText()

sCust = TRIM(dw_input.GetItemString(1,"cvcod"))

if scust = "" or isnull(scust) then 
	MessageBox("확인", "거래처를 입력하십시요.")
	dw_input.SetFocus()
   return 
end if	

IF dw_insert.Retrieve(gs_saupj, scust, gs_saupj) < 1		THEN
	MessageBox("확인", "해당자료가 없습니다.")
	dw_input.SetFocus()
END IF
end event

type p_print from w_inherite`p_print within w_pdm_01370_vendor
integer y = 3396
end type

type p_can from w_inherite`p_can within w_pdm_01370_vendor
integer y = 3396
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()
dw_input.Reset()
dw_input.InsertRow(0)

dw_input.setfocus()
end event

type p_exit from w_inherite`p_exit within w_pdm_01370_vendor
integer y = 3396
end type

type p_ins from w_inherite`p_ins within w_pdm_01370_vendor
integer y = 3396
end type

type p_new from w_inherite`p_new within w_pdm_01370_vendor
integer y = 3396
end type

type dw_input from w_inherite`dw_input within w_pdm_01370_vendor
integer y = 56
integer width = 3488
integer height = 188
string dataobject = "d_pdm_01370_31"
end type

event dw_input::itemchanged;call super::itemchanged;String sCod,sNam,sNam1

scod = this.gettext()
IF	this.Getcolumnname() = "cvcod"	THEN		
	f_get_name2("V1", 'Y', scod, snam, snam1)

	this.SetItem(1, "cvcod", scod)
	this.setitem(1, "cvnas", snam)
end if

IF	this.Getcolumnname() = "gub"	THEN		
	If GetText() = '1' Then
		dw_insert.DataObject = 'd_pdm_01370_3'
		this.object.rmks_t.visible = False
		cb_excel_download.Visible = True
		cb_excel_upload.Visible = True
	Else
		dw_insert.DataObject = 'd_pdm_01370_81'
		this.object.rmks_t.visible = True
		cb_excel_download.Visible = False
		cb_excel_upload.Visible = False
	End If
	dw_insert.SetTransObject(sqlca)
end if
end event

event dw_input::rbuttondown;call super::rbuttondown;String snull

setnull(snull)
setnull(gs_code)
setnull(gs_codename)

IF	this.Getcolumnname() = "cvcod"	THEN		
	gs_code = this.GetText()
	IF IsNull(gs_code) THEN 
		this.SetItem(1, "cvcod", snull)
		this.setitem(1, "cvnas", snull)		
	end if
		
	gs_gubun = '1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "cvcod", gs_Code)
	this.setitem(1, "cvnas", gs_CodeName)
END IF
end event

type cb_delrow from w_inherite`cb_delrow within w_pdm_01370_vendor
boolean visible = false
integer y = 3412
end type

type cb_addrow from w_inherite`cb_addrow within w_pdm_01370_vendor
boolean visible = false
integer y = 3412
end type

type dw_insert from w_inherite`dw_insert within w_pdm_01370_vendor
string dataobject = "d_pdm_01370_81"
end type

event dw_insert::itemchanged;call super::itemchanged;dec  dunprc, dtemp

IF this.getcolumnname() = "danmst_unprc"	THEN
   dunprc = dec(this.gettext())
	dtemp  = this.getitemdecimal(row, 'yunprc')
	IF dunprc = dtemp then 
   	this.setitem(row, 'opt', 'N')
   ELSE
   	this.setitem(row, 'opt', 'Y')
	END IF	
elseif this.getcolumnname() = "sltcd"	THEN
   	this.setitem(row, 'opt', 'Y')	
END IF
end event

event dw_insert::updatestart;call super::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

If dw_input.getitemstring(1,'gub') = '1' then
	FOR k = 1 TO lRowCount
		IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
			This.SetItem(k,'crt_user',gs_userid)
		ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
			This.SetItem(k,'upd_user',gs_userid)
		END IF	  
	NEXT
end if
end event

type cb_mod from w_inherite`cb_mod within w_pdm_01370_vendor
boolean visible = false
integer y = 3412
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01370_vendor
boolean visible = false
integer y = 3412
end type

type cb_del from w_inherite`cb_del within w_pdm_01370_vendor
boolean visible = false
integer y = 3412
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01370_vendor
boolean visible = false
integer y = 3412
end type

type cb_print from w_inherite`cb_print within w_pdm_01370_vendor
boolean visible = false
integer y = 3400
end type

type cb_can from w_inherite`cb_can within w_pdm_01370_vendor
boolean visible = false
integer y = 3412
end type

type cb_search from w_inherite`cb_search within w_pdm_01370_vendor
boolean visible = false
integer y = 3396
end type

type gb_10 from w_inherite`gb_10 within w_pdm_01370_vendor
integer y = 3392
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01370_vendor
integer y = 3392
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01370_vendor
integer y = 3392
end type

type r_head from w_inherite`r_head within w_pdm_01370_vendor
end type

type r_detail from w_inherite`r_detail within w_pdm_01370_vendor
end type

type cb_excel_download from commandbutton within w_pdm_01370_vendor
boolean visible = false
integer x = 2290
integer y = 96
integer width = 357
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "download"
end type

event clicked;wf_excel_down(dw_excel_download)
end event

type cb_excel_upload from commandbutton within w_pdm_01370_vendor
boolean visible = false
integer x = 2674
integer y = 96
integer width = 357
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "upload"
end type

event clicked;Long		lXlrow, lValue, lCnt, lQty[], lTotal, lRow
String		sDocname, sNamed, sPspec
String		sCvcod, sItnbr
long       lDanga
uo_xlobject 		uo_xl
Integer 	i, j, k, iNotNullCnt

// 액셀 IMPORT ***************************************************************

lValue = GetFileOpenName("파일선택", sDocname, sNamed, "XLS", "XLS Files (*.XLS),*.XLS,")
If lValue <> 1 Then Return -1

Setpointer(Hourglass!)

sCvcod = TRIM(dw_input.GetItemString(1,"cvcod"))

////===========================================================================================
////UserObject 생성
w_mdi_frame.sle_msg.text = "액셀 업로드 준비중..."
uo_xl = create uo_xlobject

//엑셀과 연결
uo_xl.uf_excel_connect(sDocname, false , 3)
uo_xl.uf_selectsheet(1)

//Data 시작 Row Setting (행)
//Excel 에서 A: 1 , B :2 로 시작 

lXlrow = 2		// 첫 헤드부터 진행 -첫헤드를 제외하고 두번째행부터 진행-

String ls_cvcod
String ls_itnbr
Long   ll_danga

Long   ll_ins
Long   ll_cnt
Long   ll_dwCnt

ll_dwCnt = 1
Do While(True)
	
	iNotNullCnt = 0
	
	// 사용자 ID(A,1)
	// Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
	For i =1 To 5
		uo_xl.uf_set_format(lXlrow, i, '@' + space(50))
	Next
	
	ls_cvcod = Trim(uo_xl.uf_gettext(lXlrow, 1))					// 거래처코드
	ls_itnbr = Trim(uo_xl.uf_gettext(lXlrow, 3))             // 품번코드
	ll_danga    = Long(Trim(uo_xl.uf_gettext(lXlrow, 5)))     // 단가
	
	If Trim(ls_cvcod) = '' OR IsNull(ls_cvcod) Then
		Exit
	Else
		iNotNullCnt++
		
		ll_ins = ll_dwCnt
		
		sItnbr = dw_insert.getItemString(ll_ins, 'itnbr')
		
		If sItnbr <> ls_itnbr Then
			MessageBox("알림", String(ll_ins) + " 행 의 자료는 엑셀과 품번이 일치하지 않습니다. 엑셀업로드가 중단됩니다.")
			Exit
		End If
		
		dw_insert.SetItem(ll_ins, 'unprc', ll_danga)
		
		dw_insert.SetColumn('unprc')
		dw_insert.SetRow(ll_ins)
		dw_insert.ScrollToRow(ll_ins)

		lCnt++
		ll_dwCnt++
	End If
	
	// 해당 행의 어떤 열에도 값이 지정되지 않았다면 파일 끝으로 인식해서 임포트 종료
	If iNotNullCnt = 0 Then Exit
	
	lXlrow ++
Loop
uo_xl.uf_excel_Disconnect()


//// 엘셀 IMPORT  END ***************************************************************
dw_insert.AcceptText()

MessageBox('확인', String(lCnt) + ' 건의 DATA IMPORT를 완료하였습니다.')
w_mdi_frame.sle_msg.text = ""
DESTROY uo_xl
end event

type dw_excel_download from datawindow within w_pdm_01370_vendor
boolean visible = false
integer x = 3593
integer y = 904
integer width = 302
integer height = 228
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_pdm_01370_3_excel"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

