$PBExportHeader$w_qa01_00030.srw
$PBExportComments$** 정기검사 계획생성/통보
forward
global type w_qa01_00030 from w_inherite
end type
type cb_1 from commandbutton within w_qa01_00030
end type
type dw_ip from datawindow within w_qa01_00030
end type
type p_auto from uo_picture within w_qa01_00030
end type
type cbx_chk from checkbox within w_qa01_00030
end type
type dw_gen from datawindow within w_qa01_00030
end type
type rr_3 from roundrectangle within w_qa01_00030
end type
end forward

global type w_qa01_00030 from w_inherite
integer width = 5083
integer height = 2636
string title = "정기검사 계획생성"
cb_1 cb_1
dw_ip dw_ip
p_auto p_auto
cbx_chk cbx_chk
dw_gen dw_gen
rr_3 rr_3
end type
global w_qa01_00030 w_qa01_00030

type prototypes
FUNCTION boolean CopyFileA(ref string cfrom, ref string cto, boolean flag) LIBRARY "Kernel32.dll"
FUNCTION LONG ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "shell32.DLL" 
end prototypes

type variables
String is_sort
String is_path
end variables

forward prototypes
public function integer wf_init ()
public function long wf_select_chk ()
end prototypes

public function integer wf_init ();String ls_today

ls_today = f_today()

dw_ip.Reset()
dw_ip.InsertRow(0)
dw_ip.Object.yymm_from[1]  = Left(ls_today,6)
dw_ip.Object.yymm_to[1]    = Left(ls_today,6)
dw_ip.Enabled = True

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.SetRedraw(True)

Return 1
end function

public function long wf_select_chk ();If dw_insert.AcceptText() < 1 Then Return -1
If dw_insert.RowCount() < 1 Then Return -1

Long i , ll_cnt=0
String ls_chk

For i = 1 To dw_insert.Rowcount()
	ls_chk = Trim(dw_insert.Object.req_gb[i])
	If ls_chk = '1' Then
		ll_cnt++
	End If
Next

return ll_cnt
end function

on w_qa01_00030.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_ip=create dw_ip
this.p_auto=create p_auto
this.cbx_chk=create cbx_chk
this.dw_gen=create dw_gen
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ip
this.Control[iCurrent+3]=this.p_auto
this.Control[iCurrent+4]=this.cbx_chk
this.Control[iCurrent+5]=this.dw_gen
this.Control[iCurrent+6]=this.rr_3
end on

on w_qa01_00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ip)
destroy(this.p_auto)
destroy(this.cbx_chk)
destroy(this.dw_gen)
destroy(this.rr_3)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_ip.SetTransObject(SQLCA)
dw_gen.SetTransObject(SQLCA)

// 검사성적서 파일다운로드 경로 찾기 2003.12.27 ajh

//SELECT DECODE(DATANAME , NULL ,'', DECODE(SUBSTR(DATANAME , -1,1),'\',DATANAME , DATANAME||'\')) Into : is_path 
//  FROM SYSCNFG 
// WHERE SYSGU = 'C' AND SERIAL = 12 AND LINENO = '1' ;
 

wf_init()

end event

type dw_insert from w_inherite`dw_insert within w_qa01_00030
integer x = 64
integer y = 288
integer width = 4489
integer height = 2012
integer taborder = 20
string dataobject = "d_qa01_00030_a"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String ls_col ,ls_cod
Long   ll_cnt ,ll_row

ib_any_typing = True 
AcceptText()

ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())

Choose Case ls_col
	Case "inspt_mon" 
		If ls_cod = "" Or isNull(ls_cod) Or f_datechk(ls_cod+'01') < 1 Then 
			f_message_chk(35,'[검사년월]')
			Return 1
		End If
	Case "cvcod"
		
		String ls_cvnas
		
		Select cvnas
		  Into :ls_cvnas
		  From vndmst 
		 Where cvcod = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[거래처]")
			This.Object.cvcod[GetRow()] = ""
			Return 1
		End If
		
		This.Object.vndmst_cvnas[GetRow()] = ls_cvnas	

	Case "itnbr" 
		
		String ls_itdsc ,ls_ispec ,ls_jijil
		
		Select itdsc , ispec , jijil 
		  Into :ls_itdsc , :ls_ispec ,:ls_jijil
		  From itemas 
		  Where itnbr = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[품번]")
			This.Object.itnbr[GetRow()] = ""
			Return 1
		End If
		
		This.Object.itemas_itdsc[GetRow()] = ls_itdsc	
		This.Object.itemas_ispec[GetRow()] = ls_ispec
	
	Case "req_dt" 
		If ls_cod = "" Or isNull(ls_cod) Or f_datechk(ls_cod) < 1 Then 
			f_message_chk(35,'[검사의뢰일자]')
			Return 1
		End If
	Case "inspt_dt" 
		If ls_cod = "" Or isNull(ls_cod) Or f_datechk(ls_cod) < 1 Then 
			f_message_chk(35,'[검사일자]')
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
	Case "cvcod"
		gs_gubun ='1'
		Open(w_vndmst_popup)
		IF isnull(gs_Code)  or  gs_Code = ''	then return
		this.SetItem(1, "cvcod", gs_Code)
		this.TriggerEvent("itemchanged")	

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

event dw_insert::buttonclicked;call super::buttonclicked;String ls_s_path ,ls_s_file , ls_path, ls_file ,ls_inspt_dt
Long   ll_v
AcceptText()
Choose Case dwo.name
	Case 'b_down'
		
		ls_s_path = Trim(Object.file_path[row])
		ls_s_file = Trim(Object.file_name[row])
		
		If ls_s_path = '' Or isNull(ls_s_path) Then Return
		
		SetPointer(Hourglass!)
		
	   If FileExists(ls_s_path) = False Then
			MessageBox('확인','파일서버에 해당 파일이 존재하지 않습니다.')
			Return
		End If

		ShellExecuteA(0, "open", ls_s_path , "", "", 1) // 파일 자동 실행 

	Case 'b_up'

		// 환경설정 - 공통관리 - SCM 연동관리
		select dataname into :ls_s_path from syscnfg
		 where sysgu = 'C' and serial = 12 and lineno = '2' ;
		
		ll_v = GetFileOpenName("Upload File 선택",ls_path , ls_file ,"XLS","EXCEL Files (*.XLS),*.XLS,")
		
		If ll_v = 1 And FileExists(ls_path) Then
			ls_s_path = ls_s_path + ls_file
			if FileExists(ls_s_path) Then
				messagebox('확인','동일한 파일명이 존재합니다.~n파일명을 바꾸세요.')
				return
			end if

			If CopyFileA(ls_path,ls_s_path,true) = False Then
				MessageBox('확인','File UpLoad Failed')
				Return
			End If

			dw_insert.Object.local_path[row] = ls_path
			dw_insert.Object.file_path[row]  = ls_s_path
			dw_insert.Object.file_name[row]  = ls_file
			
			dw_insert.Object.file_yn[row] = 'Y'
		Else
			dw_insert.Object.file_yn[row] = 'N'
		End If
End Choose


end event

type p_delrow from w_inherite`p_delrow within w_qa01_00030
boolean visible = false
integer x = 4855
integer y = 192
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qa01_00030
boolean visible = false
integer x = 4681
integer y = 192
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qa01_00030
boolean visible = false
integer x = 3488
integer y = 3320
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qa01_00030
integer x = 3886
integer taborder = 0
end type

event p_ins::clicked;call super::clicked;Long ll_rcnt , ll_r
String ls_cvcod

If dw_ip.AcceptText() < 1 Then Return

ls_cvcod   = Trim(dw_ip.Object.cvcod[1])
If ls_cvcod = '' Or isNull(ls_cvcod) Then
	f_message_chk(33,"[업체코드]")
	dw_ip.SetColumn("cvcod")
	dw_ip.SetFocus()
	Return
End If

ll_rcnt = dw_insert.RowCount()

ll_r = dw_insert.InsertRow(ll_rcnt + 1 )

dw_insert.Object.saupj[ll_r] = gs_saupj
dw_insert.Object.req_dt[ll_r] = is_today
dw_insert.SetFocus()
dw_insert.ScrollToRow(ll_r)
dw_insert.SetColumn("inspt_mon")


end event

type p_exit from w_inherite`p_exit within w_qa01_00030
integer x = 4407
end type

event p_exit::clicked;Close(parent)
end event

type p_can from w_inherite`p_can within w_qa01_00030
integer x = 4233
end type

event p_can::clicked;call super::clicked;
wf_init()

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"

//p_del.Enabled = False
//p_del.PictureName = 'C:\erpman\image\삭제_d.gif'
ib_any_typing = False //입력필드 변경여부 No
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\자료조회_dn.gif"
end event

type p_print from w_inherite`p_print within w_qa01_00030
boolean visible = false
integer x = 3662
integer y = 3320
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qa01_00030
integer x = 3538
end type

event p_inq::clicked;call super::clicked;String ls_cvcod , ls_yymm_f , ls_yymm_t, ls_pdtgu, ls_factory, ls_emp, ls_itnbr
Long   ll_row

If dw_ip.AcceptText() < 1 Then Return
If dw_ip.RowCount() < 1 Then Return

ls_yymm_f  = Trim(dw_ip.Object.yymm_from[1])
ls_yymm_t  = Trim(dw_ip.Object.yymm_to[1])
ls_cvcod   = Trim(dw_ip.Object.cvcod[1])
ls_pdtgu   = Trim(dw_ip.Object.pdtgu[1])
ls_factory = Trim(dw_ip.Object.factory[1])
ls_emp     = Trim(dw_ip.Object.eoemp[1])
ls_itnbr   = Trim(dw_ip.Object.itnbr[1])

If ls_cvcod = '' Or isNull(ls_cvcod) Then
	f_message_chk(33,"[업체코드]")
	dw_ip.SetColumn("cvcod")
	dw_ip.SetFocus()
	Return
End If

If LEFT(ls_yymm_f,4) <> LEFT(ls_yymm_t,4) Then
	MessageBox('확인','검사월은 동일한 년도를 지정해야 합니다!')
	dw_ip.SetColumn("yymm_from")
	dw_ip.SetFocus()
	Return
End If

If Trim(ls_factory) = '' OR IsNull(ls_factory) Then ls_factory = '%'
If Trim(ls_emp) = '' OR IsNull(ls_emp) Then ls_emp = '%'
If Trim(ls_itnbr) = '' OR IsNull(ls_itnbr) Then ls_itnbr = '%'

ll_row = dw_insert.Retrieve(ls_yymm_f , ls_yymm_t , ls_cvcod , gs_saupj, ls_factory, ls_emp, ls_itnbr)

If ll_row > 0 Then
//	dw_ip.Enabled = False
	ib_any_typing = False //입력필드 변경여부 No
Else
	MessageBox('확인','해당 날짜범위에는 정기검사 대상 품번이 존재하지 않습니다.'+ &
	             '~n~r~n~r일괄생성 버턴으로 정기검사 계획을 생성하세요 '+'~t~t')
	
//	dw_ip.Enabled = True
	ib_any_typing = True //입력필드 변경여부 No
End If

end event

type p_del from w_inherite`p_del within w_qa01_00030
integer x = 4059
end type

event p_del::clicked;call super::clicked;String ls_new ,ls_inspt_no ,ls_result , ls_req_gb
Long   ll_r

ll_r = dw_insert.GetRow()
If ll_r < 1 Then Return

ls_new      = Trim(dw_insert.Object.is_new[ll_r])
ls_result   = Trim(dw_insert.Object.result_yn[ll_r])
ls_req_gb   = Trim(dw_insert.Object.req_gb[ll_r])

If ls_req_gb = '1' Then 
	MessageBox('확인','정기검사가 진행 중인 항목입니다. 삭제 불가능 합니다.')
	return
End If

If ls_result > '' Or isNull(ls_result) = False Then
	MessageBox('확인','정기검사가 완료 또는  진행 중인 항목입니다. 삭제 불가능 합니다.')
	return
End If

If f_msg_delete() < 1 Then Return

dw_insert.DeleteRow(ll_r)

If ls_new = 'N' Then
	If dw_insert.Update() = 1 Then
		Commit;
	Else
		Rollback ;
		f_rollback()
		Return
	End If

End If
end event

type p_mod from w_inherite`p_mod within w_qa01_00030
integer x = 3712
end type

event p_mod::clicked;call super::clicked;SetPointer(HourGlass!)

Long 		ll_cnt, i, ll_maxseq
String 	ls_cvcod , ls_yymm_f , ls_yymm_t
String 	ls_result , ls_inspt_dt , ls_spath , ls_lpath

If dw_insert.AcceptText() = -1 Then Return -1
If dw_insert.RowCount() < 1 Then Return

ll_cnt = wf_select_chk()

//MessageBox('ll_cnt',ll_cnt)
ls_cvcod = Trim(dw_ip.Object.cvcod[1])
//If ll_cnt > 0 Then
//	If MessageBox('확인','저장과 동시에 SCM 공지사항으로 등록하시겠습니까?             ',&
//								Question! , Yesno!, 2) = 1 Then 
//		// 공지사항등록 내용을 넣기 
//		String	ls_maxseq, subject, scontent
//		
//		subject = Left(is_today,4) + ' 년  정기검사 통보!!!'
//		scontent= '정기검사 품목이 확정되었습니다.~n업무에 참고하십시오'
//		
//		Select Max(to_number(no)) Into :ll_maxseq
//		  From et_notice ;
//		  
//		If isNull(ll_maxseq) Then ll_maxseq = 0
//		ls_maxseq = String(ll_maxseq+1)
//		
//		insert into et_notice
//		(	no,			   subject,				content,				cre_id,				cre_dt ,      cvcod	)
//		values
//		(	:ls_maxseq,		:subject,			:scontent,			'bds',				sysdate,	     :ls_cvcod) ;
//		if sqlca.sqlcode <> 0 then
//			Rollback;
//			MessageBox(string(sqlca.sqlcode), sqlca.sqlerrtext)
//			Return
//		End If
//		
//	End If
//Else
	If f_msg_update() = -1 Then Return  //저장 Yes/No ?
//End If

//dw_insert.AcceptText()

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

type cb_exit from w_inherite`cb_exit within w_qa01_00030
integer x = 2825
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_qa01_00030
integer x = 1783
integer y = 3292
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qa01_00030
integer x = 942
integer y = 2344
integer taborder = 90
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_qa01_00030
integer x = 2130
integer y = 3292
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qa01_00030
integer x = 1422
integer y = 3296
end type

type cb_print from w_inherite`cb_print within w_qa01_00030
integer x = 1874
integer y = 2348
end type

type st_1 from w_inherite`st_1 within w_qa01_00030
integer x = 0
integer y = 3520
end type

type cb_can from w_inherite`cb_can within w_qa01_00030
integer x = 2478
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_qa01_00030
integer x = 1371
integer y = 2348
end type

type dw_datetime from w_inherite`dw_datetime within w_qa01_00030
integer x = 2843
integer y = 3520
end type

type sle_msg from w_inherite`sle_msg within w_qa01_00030
integer x = 352
integer y = 3520
end type

type gb_10 from w_inherite`gb_10 within w_qa01_00030
integer y = 3488
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_qa01_00030
end type

type gb_button2 from w_inherite`gb_button2 within w_qa01_00030
end type

type cb_1 from commandbutton within w_qa01_00030
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

type dw_ip from datawindow within w_qa01_00030
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 41
integer y = 24
integer width = 3250
integer height = 244
integer taborder = 100
string title = "none"
string dataobject = "d_qa01_00030_1"
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

event itemchanged;String ls_col ,ls_cod , ls_cvnas, ls_cvcod
Long   ll_cnt ,ll_row

AcceptText()

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
		

	Case "yymm_from" ,"yymm_to" 
		ls_cod = ls_cod + '01'
		If ls_cod = '' Or isNull(ls_cod) Or f_datechk(ls_cod) < 0  Then
			f_message_chk(35 , '[검사월]')
			SetColumn(ls_col)
			Return 1
		End If
		
	Case 'factory'
		
		if ls_cod = '.' or isnull(ls_cod) or ls_cod = '' then return
		
		select a.rfna2 , b.cvnas
		  into :ls_cvcod, :ls_cvnas
		  from reffpf a, vndmst b
		 where a.rfcod = '2A' and a.rfgub = :ls_cod and a.rfna2 = b.cvcod ;
		
		If sqlca.sqlcode <> 0 Then
			This.Object.cvcod[GetRow()] = ""
			This.Object.cvnas[GetRow()] = ""
			Return 1
		End If

		This.Object.cvcod[GetRow()] = ls_cvcod
		This.Object.cvnas[GetRow()] = ls_cvnas
		
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

type p_auto from uo_picture within w_qa01_00030
integer x = 3328
integer y = 24
integer width = 183
integer taborder = 30
boolean bringtotop = true
string picturename = "C:\erpman\image\일괄생성_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\일괄생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\일괄생성_up.gif"
end event

event clicked;call super::clicked;String ls_jcvcod ,ls_cvcod ,ls_cvnas , ls_yymm_f , ls_yymm_t
String ls_itnbr , ls_itdsc ,ls_ispec, ls_mon ,ls_mon_rs, ls_place, ls_p
Long   ll_r = 0 , ll_cnt ,ll_mon ,i

If dw_ip.AcceptText() < 1 Then Return
If dw_ip.RowCount() < 1 Then Return

ls_jcvcod   = Trim(dw_ip.Object.cvcod[1])
ls_yymm_f  = Trim(dw_ip.Object.yymm_from[1])
ls_yymm_t  = Trim(dw_ip.Object.yymm_to[1])

If ls_jcvcod = '' Or isNull(ls_jcvcod) Then
	f_message_chk(33,"[업체코드]")
	dw_ip.SetColumn("cvcod")
	dw_ip.SetFocus()
	Return
End If

If LEFT(ls_yymm_f,4) <> LEFT(ls_yymm_t,4) Then
	MessageBox('확인','검사월은 동일한 년도를 지정해야 합니다!')
	dw_ip.SetColumn("yymm_from")
	dw_ip.SetFocus()
	Return
End If

					
//dw_gen.SetTransObject(SQLCA)
dw_gen.ReSet()
dw_insert.Reset()

//If dw_gen.Retrieve(ls_jcvcod , Long(Right(ls_yymm_f,2)) , Long(Right(ls_yymm_t,2))) < 1 Then
If dw_gen.Retrieve(LEFT(ls_yymm_f,4), ls_jcvcod) < 1 Then
	MessageBox('확인','해당 조건에 맞는 정기검사 품번이 존재하지 않습니다.')
	dw_ip.Enabled = True
	Return
Else
	ll_cnt = 0 
	ls_p = ' '
	For i =1 To dw_gen.RowCount()
		
		ll_r = dw_insert.InsertRow(0)
		
		ls_itnbr = Trim(dw_gen.Object.itnbr[i])
		ls_itdsc = Trim(dw_gen.Object.itdsc[i])
		ls_cvcod = Trim(dw_gen.Object.cvcod[i])
		ls_cvnas = Trim(dw_gen.Object.cvnas[i])
		ls_place = Trim(dw_gen.Object.place[i])
		ll_mon   =      dw_gen.Object.mon[i]
		
		dw_insert.Object.saupj[ll_r]    = gs_saupj
		dw_insert.Object.inspt_mon[ll_r]    = Left(is_today,4) + String(ll_mon,'00')
		
		if ls_p <> ls_place then ll_cnt++
		
		dw_insert.Object.inspt_seq[ll_r]    = ll_cnt
		dw_insert.Object.itnbr[ll_r]        = ls_itnbr
		dw_insert.Object.itemas_itdsc[ll_r] = ls_itdsc
		dw_insert.Object.cvcod[ll_r]        = ls_cvcod
		dw_insert.Object.vndmst_cvnas[ll_r] = ls_cvnas
		dw_insert.Object.req_dt[ll_r]       = is_today
		dw_insert.Object.eco_no[ll_r]       = ls_place
		
		ls_p = ls_place
	Next
	dw_ip.Enabled = False
End If
	
	
end event

type cbx_chk from checkbox within w_qa01_00030
boolean visible = false
integer x = 4517
integer y = 176
integer width = 82
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 28144969
end type

event clicked;Long i , ll_rcnt

ll_rcnt = dw_insert.RowCount()
If ll_rcnt < 1 Then Return
If This.Checked Then
	For i =1 To ll_rcnt
		dw_insert.Object.req_gb[i] = '1'
	Next
Else
	For i =1 To ll_rcnt
		dw_insert.Object.req_gb[i] = '0'
	Next
End If
end event

type dw_gen from datawindow within w_qa01_00030
boolean visible = false
integer x = 3863
integer y = 208
integer width = 411
integer height = 432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa01_00030_b2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rr_3 from roundrectangle within w_qa01_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 280
integer width = 4526
integer height = 2036
integer cornerheight = 40
integer cornerwidth = 55
end type

