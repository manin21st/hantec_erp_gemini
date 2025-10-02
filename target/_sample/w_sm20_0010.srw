$PBExportHeader$w_sm20_0010.srw
$PBExportComments$ 거래처 제품단가 등록(VNDDAN)
forward
global type w_sm20_0010 from w_inherite
end type
type gb_3 from groupbox within w_sm20_0010
end type
type dw_list from u_d_popup_sort within w_sm20_0010
end type
type pb_1 from u_pic_cal within w_sm20_0010
end type
type rb_1 from radiobutton within w_sm20_0010
end type
type rb_2 from radiobutton within w_sm20_0010
end type
type st_3 from statictext within w_sm20_0010
end type
type cb_1 from commandbutton within w_sm20_0010
end type
type dw_cvlist from datawindow within w_sm20_0010
end type
type dw_form from datawindow within w_sm20_0010
end type
type cb_form from commandbutton within w_sm20_0010
end type
type gb_1 from groupbox within w_sm20_0010
end type
type r_list from rectangle within w_sm20_0010
end type
end forward

global type w_sm20_0010 from w_inherite
integer width = 4677
integer height = 2736
string title = "거래처 제품단가 등록"
boolean minbox = false
boolean resizable = false
gb_3 gb_3
dw_list dw_list
pb_1 pb_1
rb_1 rb_1
rb_2 rb_2
st_3 st_3
cb_1 cb_1
dw_cvlist dw_cvlist
dw_form dw_form
cb_form cb_form
gb_1 gb_1
r_list r_list
end type
global w_sm20_0010 w_sm20_0010

type variables
str_itnct lstr_sitnct
string is_itnbr, snull
end variables

forward prototypes
public function integer wf_key_protect (string gb)
public subroutine wf_change ()
end prototypes

public function integer wf_key_protect (string gb);Choose Case gb
	Case '조회'
		dw_insert.Modify('cvcod.protect = 1')
		dw_insert.Modify('itnbr.protect = 1')
		dw_insert.Modify('start_date.protect = 1')

	Case '신규'
		
		dw_insert.Modify('cvcod.protect = 0')
		dw_insert.Modify('itnbr.protect = 0')
		dw_insert.Modify('start_date.protect = 0')

End Choose

//p_addrow.enabled 	= false
//p_delrow.enabled 	= false

//p_addrow.PictureName  	= "..\image\행추가_d.gif"
//p_delrow.PictureName  	= "..\image\행삭제_d.gif"

return 1
end function

public subroutine wf_change ();String ls_cvcod , ls_cvnas
String ls_itnbr , ls_itdsc ,ls_ispec ,ls_jijil
Long   ll_r
dw_insert.AcceptText()

ls_cvcod = Trim(dw_insert.GetItemString(1,'cvcod'))
ls_cvnas = Trim(dw_insert.GetItemString(1,'cvnas'))

ls_itnbr = Trim(dw_insert.GetItemString(1,'itnbr'))
ls_itdsc = Trim(dw_insert.GetItemString(1,'itdsc'))
ls_ispec = Trim(dw_insert.GetItemString(1,'ispec'))
ls_jijil = Trim(dw_insert.GetItemString(1,'jijil'))

dw_insert.Reset()
ll_r=	dw_insert.InsertRow(0)
	
If rb_1.checked Then
	dw_list.DataObject = "d_sm20_0010_02"
	dw_list.SetTransObject(sqlca)

	dw_insert.Object.itnbr_t.y = 28
	dw_insert.Object.itnbr.y = 28
	dw_insert.Object.itdsc.y = 28
	
	dw_insert.Object.t_1.y = 112
	dw_insert.Object.cvcod.y = 112
	dw_insert.Object.cvnas.y = 112
	
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	
	dw_insert.SetTabOrder("itnbr",10)
	dw_insert.SetTabOrder("cvcod",30)
	dw_insert.Object.start_date[ll_r] = is_today
	wf_key_protect("신규")
	If isNull(ls_itnbr) = false and len(ls_itnbr) > 0 Then
			
		dw_insert.Object.itnbr[ll_r] = ls_itnbr
		dw_insert.Object.itdsc[ll_r] = ls_itdsc
		dw_insert.Object.ispec[ll_r] = ls_ispec
		dw_insert.Object.jijil[ll_r] = ls_jijil
		
		p_inq.TriggerEvent(Clicked!)
	End IF
Else
	dw_list.DataObject = "d_sm20_0010_04"
	dw_list.SetTransObject(sqlca)
	
	dw_insert.Object.itnbr_t.y = 112
	dw_insert.Object.itnbr.y = 112
	dw_insert.Object.itdsc.y = 112
	
	dw_insert.Object.t_1.y = 28
	dw_insert.Object.cvcod.y = 28
	dw_insert.Object.cvnas.y = 28
	
	dw_insert.SetColumn("cvcod")
	dw_insert.SetFocus()
	
	dw_insert.SetTabOrder("cvcod",10)
	dw_insert.SetTabOrder("itnbr",30)
	dw_insert.Object.start_date[ll_r] = is_today
	wf_key_protect("신규")
	If isNull(ls_cvcod) = false and len(ls_cvcod) > 0  Then
			
		dw_insert.Object.cvcod[ll_r] = ls_cvcod
		dw_insert.Object.cvnas[ll_r] = ls_cvnas
		
		p_inq.TriggerEvent(Clicked!)
	End IF
	
End IF


	
end subroutine

on w_sm20_0010.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.dw_list=create dw_list
this.pb_1=create pb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_3=create st_3
this.cb_1=create cb_1
this.dw_cvlist=create dw_cvlist
this.dw_form=create dw_form
this.cb_form=create cb_form
this.gb_1=create gb_1
this.r_list=create r_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.dw_cvlist
this.Control[iCurrent+9]=this.dw_form
this.Control[iCurrent+10]=this.cb_form
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.r_list
end on

on w_sm20_0010.destroy
call super::destroy
destroy(this.gb_3)
destroy(this.dw_list)
destroy(this.pb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.dw_cvlist)
destroy(this.dw_form)
destroy(this.cb_form)
destroy(this.gb_1)
destroy(this.r_list)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_cvlist.settransobject(sqlca)

p_can.TriggerEvent(Clicked!)

dw_insert.SetFocus()
dw_insert.SetColumn("cvcod")

dw_form.InsertRow(0)
end event

event resize;r_list.width = this.width - 60
r_list.height = this.height - r_list.y - 65
dw_list.width = this.width - 70
dw_list.height = this.height - dw_list.y - 70
end event

event activate;gw_window = this

if gs_lang = "CH" then   //// 중문일 경우
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("追加(&A)", true) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?除(&D)", true) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?存(&S)", true) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("取消(&Z)", true) //// 취소
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("淸除(&C)", false) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&T)", false) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&F)", false) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("Excel??(&E)", false) //// 엑셀다운
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?出(&P)", false) //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("??(&R)", false) //// 미리보기 
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled("?助?(&G)", true) //// 도움말
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)  //// PDF변환
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true) //// 설정
else
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("조회") + "(&Q)", true) //// 조회
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("추가") + "(&A)", true) //// 추가
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("삭제") + "(&D)", true) //// 삭제
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("저장") + "(&S)", true) //// 저장
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("취소") + "(&Z)", true) //// 취소
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("신규") + "(&C)", false) //// 신규
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("찾기") + "(&T)", false) //// 찾기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("필터") + "(&F)",	 false) //// 필터
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("엑셀변환") + "(&E)", false) //// 엑셀다운
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("출력") + "(&P)", false) //// 출력
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("미리보기") + "(&R)", false) //// 미리보기
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("도움말") + "(&G)", true) //// 도움말
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("PDF") + "(&P)", true)
	w_mdi_frame.uo_toolbarstrip.of_SetEnabled(f_get_trans_word("설정") + "(&C)", true)
end if

//// 단축키 활성화 처리
m_main2.m_window.m_inq.enabled = true //// 조회
m_main2.m_window.m_add.enabled = true //// 추가
m_main2.m_window.m_del.enabled = true  //// 삭제
m_main2.m_window.m_save.enabled = true //// 저장
m_main2.m_window.m_cancel.enabled = true //// 취소
m_main2.m_window.m_new.enabled = false //// 신규
m_main2.m_window.m_find.enabled = false  //// 찾기
m_main2.m_window.m_filter.enabled = false //// 필터
m_main2.m_window.m_excel.enabled = false //// 엑셀다운
m_main2.m_window.m_print.enabled = false  //// 출력
m_main2.m_window.m_preview.enabled = false //// 미리보기

w_mdi_frame.st_window.Text = Upper(is_window_id)
end event

event ue_append;call super::ue_append;p_ins.TriggerEvent(Clicked!)
end event

event ue_cancel;call super::ue_cancel;p_can.TriggerEvent(Clicked!)
end event

event ue_delete;call super::ue_delete;p_del.TriggerEvent(Clicked!)
end event

event ue_retrieve;call super::ue_retrieve;p_inq.TriggerEvent(Clicked!)
end event

event ue_update;call super::ue_update;p_mod.TriggerEvent(Clicked!)
end event

type cb_exit from w_inherite`cb_exit within w_sm20_0010
end type

type sle_msg from w_inherite`sle_msg within w_sm20_0010
end type

type dw_datetime from w_inherite`dw_datetime within w_sm20_0010
end type

type st_1 from w_inherite`st_1 within w_sm20_0010
integer y = 3400
end type

type p_search from w_inherite`p_search within w_sm20_0010
end type

type p_addrow from w_inherite`p_addrow within w_sm20_0010
integer x = 4256
integer y = 288
integer taborder = 0
string picturename = "..\image\행추가_d.gif"
end type

type p_delrow from w_inherite`p_delrow within w_sm20_0010
integer x = 4430
integer y = 284
integer taborder = 0
string picturename = "..\image\행삭제_d.gif"
end type

type p_mod from w_inherite`p_mod within w_sm20_0010
integer y = 3200
end type

event p_mod::clicked;call super::clicked;string s_itnbr, s_itdsc, s_ispec, s_cvcod, sfrdate, stodate, sCurr, sCurr2
Long   l_row, ll_row, inull,nRow
Double dSalesPrc,dDcRate , ld_mprice ,ld_bprice, ld_TARI_PRICE

String ls_dangu , ls_crt_date ,ls_crt_time ,ls_upd_date ,ls_upd_time , ls_bigo ,ls_bcurr
String ls_cvnas ,ls_jijil, ls_GIANDOCNO 									


setnull(snull)
setnull(inull)

IF dw_insert.Accepttext() = -1 THEN 	RETURN

s_cvcod 	= dw_insert.GetItemString(1, "cvcod")       //직판점
s_itnbr 	= dw_insert.GetItemString(1, "itnbr")       //품번
s_itdsc 	= dw_insert.GetItemString(1, "itdsc")       //품명
s_ispec 	= dw_insert.GetItemString(1, "ispec")       //규격
sfrdate 	= dw_insert.GetItemString(1, "start_date")     
stodate 	= dw_insert.GetItemString(1, "end_date")
sCurr   	= dw_insert.GetItemString(1, "curr")

dSalesPrc = dw_insert.GetItemNumber(1, "sales_price")
dDcRate  	= dw_insert.GetItemNumber(1, "dc_rate")

ld_bprice 			= dw_insert.Object.broad_price[1]
ls_dangu  			= Trim(dw_insert.Object.dangu[1])
ls_bcurr  			=  Trim(dw_insert.Object.broad_curr[1])
ls_bigo   			= Trim(dw_insert.Object.bigo[1])
ld_TARI_PRICE   	= dw_insert.Object.gita_price[1]
//ls_GIANDOCNO   	= Trim(dw_insert.Object.giandocno[1])

ls_cvnas 	= dw_insert.GetItemString(1, "cvnas")      
ls_jijil 	= dw_insert.GetItemString(1, "jijil") 

////필수입력 항목 체크/////////////////////////////////////////////////
IF 	IsNull(s_cvcod) or trim(s_cvcod) = '' THEN
	f_message_chk(30,'[거래처]')
	dw_insert.SetColumn("cvcod")
	dw_insert.SetFocus()
	RETURN 
END IF

IF 	IsNull(s_itnbr) or trim(s_itnbr) = '' THEN
	f_message_chk(30,'[품번]')
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	RETURN 
END IF

IF 	IsNull(sfrdate) or trim(sfrdate) = '' THEN
	f_message_chk(30,'[적용시작일]')
	dw_insert.SetColumn("start_date")
	dw_insert.SetFocus()
	RETURN 
END IF

If dSalesPrc <= 0 Then
	f_message_chk(1400,'[단가]')
	dw_insert.SetColumn("sales_price")
	dw_insert.SetFocus()
	RETURN 
END IF

////기존의 입력된 data와 중복되는 것을 피하기 위해 (primary key)///////////////////////////////////
SELECT COUNT(ITNBR)                     
  INTO :ll_row                               
  FROM VNDDAN
 WHERE CVCOD = :s_cvcod AND
		 ITNBR = :s_itnbr and                  
		 START_DATE = :sfrdate ;

If 	ll_row > 0 then  
	
	ls_upd_date = is_today 
	ls_upd_time = is_totime 
	
	update vnddan
	   set end_date = :sTodate,
		    sales_price = :dSalesPrc,
			 broad_price = :ld_bprice,
			 curr = :sCurr,	 
			 broad_curr = :ls_bcurr,
			 dangu = :ls_dangu ,
			 bigo = :ls_bigo ,
			 GITA_PRICE = :ld_tari_price, 
// 			 GIANDOCNO = :ls_giandocno, 									
			 upd_date = :ls_upd_date ,
			 upd_time = :ls_upd_time ,
			 upd_user = :gs_userid
    WHERE CVCOD = :s_cvcod AND
	    	 ITNBR = :s_itnbr and                  
		    START_DATE = :sfrdate ;
Else
	ls_crt_date = is_today 
	ls_crt_time = is_totime 
	
	Insert into vnddan (    CVCOD,
									ITNBR,
									START_DATE,   
									END_DATE,  
									SALES_PRICE,   
									CURR,   								
									BROAD_PRICE,   
									BROAD_CURR , 
									DANGU,   
									BIGO, 
									GITA_PRICE, 								
									CRT_DATE,   
									CRT_TIME,   
									CRT_USER )
	               values ( :s_cvcod, 
						         :s_itnbr, 
									:sfrdate, 
									:sToDate, 
									:dSalesPrc ,
									:sCurr ,								
									:ld_bprice,
									:ls_bcurr ,
									:ls_dangu,
									:ls_bigo ,
									:ld_TARI_PRICE, 								
									:ls_crt_date ,
									:ls_crt_time ,
									:gs_userid );
End If

//+++++++++++++++++++
if Sqlca.sqlcode = 0 then
	commit using sqlca;
else
	MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
	rollback using sqlca ;
	return
end if

/* 완제품 단가 등록/수정시 원품번에 등록된 MES 품번의 단가 일괄 변경 2019.04.24 bhkim */
string ls_ittyp
SELECT ITTYP
  INTO :ls_ittyp
  FROM ITEMAS
 WHERE ITNBR = :s_itnbr;
 
if ls_ittyp = '1' then 
 
	SELECT COUNT(ITNBR)                     
	  INTO :ll_row                               
	  FROM VNDDAN
	 WHERE CVCOD = :s_cvcod AND
			 ITNBR like :s_itnbr || '%' and                  
	 		 ITNBR <> :s_itnbr and                  
			 START_DATE = :sfrdate ;

	If 	ll_row > 0 then  
	
		ls_upd_date = is_today 
		ls_upd_time = is_totime 
	
		update vnddan
		   set end_date = :sTodate,
			    sales_price = :dSalesPrc,
				 broad_price = :ld_bprice,
				 curr = :sCurr,	 
				 broad_curr = :ls_bcurr,
				 dangu = :ls_dangu ,
				 bigo = :ls_bigo ,
				 GITA_PRICE = :ld_tari_price, 
	// 			 GIANDOCNO = :ls_giandocno, 									
				 upd_date = :ls_upd_date ,
				 upd_time = :ls_upd_time ,
				 upd_user = :gs_userid
   	 WHERE CVCOD = :s_cvcod AND
		    	 ITNBR like :s_itnbr || '%' and                  
	 		 	 ITNBR <> :s_itnbr and                  
			    START_DATE = :sfrdate ;
	Else
		ls_crt_date = is_today 
		ls_crt_time = is_totime 
		
		Insert into vnddan (    CVCOD,
										ITNBR,
										START_DATE,   
										END_DATE,  
										SALES_PRICE,   
										CURR,   								
										BROAD_PRICE,   
										BROAD_CURR , 
										DANGU,   
										BIGO, 
										GITA_PRICE, 								
										CRT_DATE,   
										CRT_TIME,   
										CRT_USER )
		select A.CVCOD, B.ITNBR, A.START_DATE, A.END_DATE,
		   	 A.SALES_PRICE, A.CURR, A.BROAD_PRICE, A.BROAD_CURR ,
		   	 A.DANGU, A.BIGO, A.GITA_PRICE, A.CRT_DATE,
		   	 A.CRT_TIME, A.CRT_USER
	  	  from ( select	CVCOD,
								START_DATE,
								END_DATE,
								SALES_PRICE,
								CURR,
								BROAD_PRICE,
								BROAD_CURR ,
								DANGU,
								BIGO,
								GITA_PRICE,
								CRT_DATE,
								CRT_TIME,
								CRT_USER
					  from	VNDDAN
					 where	CVCOD = :s_cvcod and
		    	 				ITNBR = :s_itnbr and
			    				START_DATE = :sfrdate) A,
				 ( select	ITNBR
				 	  from	ITEMAS
					 where	ITNBR like :s_itnbr || '%' and ITNBR <> :s_itnbr) B;
	End If

	if Sqlca.sqlcode = 0 then
		commit using sqlca;
	else
		MessageBox(string(sqlca.sqlcode),sqlca.sqlerrtext)
		rollback using sqlca ;
		return
	end if
	
end if	
/* ---------------------------------------------------------------- 2019.04.24 bhkim */

dw_insert.setredraw(false)	 
p_inq.triggerevent(Clicked!)

dw_insert.reset()
nRow = dw_insert.insertrow(0)

dw_insert.SetItem(nRow, "cvcod", s_cvcod)
dw_insert.SetItem(nRow, "cvnas", ls_cvnas)
dw_insert.SetItem(nRow, "start_date", f_today())
dw_insert.SetItem(nRow, "itnbr", s_itnbr)
dw_insert.SetItem(nRow, "itdsc", s_itdsc)
dw_insert.SetItem(nRow, "ispec", s_ispec)
dw_insert.SetItem(nRow, "jijil", ls_jijil)
dw_insert.SetFocus()
dw_insert.SetRow(nRow)
dw_insert.SetColumn("itnbr")

wf_key_protect('신규')
dw_insert.setredraw(true)


sle_msg.text = "저장하였습니다!!"



end event

type p_del from w_inherite`p_del within w_sm20_0010
integer y = 3200
end type

event p_del::clicked;call super::clicked;string  ls_cvcod, s_ittyp, s_itcls, ls_itnbr, ls_start

If dw_insert.RowCount() 	<= 0 Then Return

ls_cvcod  	= Trim(dw_insert.getitemstring(1, "cvcod"))
ls_itnbr  	= Trim(dw_insert.getitemstring(1, "itnbr"))
ls_start  	= Trim(dw_insert.getitemstring(1, "start_date"))

if messagebox("삭 제","삭제하시겠습니까?", question!, yesno!, 2) = 2 then
	return
else
	Delete From VNDDAN
		 Where cvcod = :ls_cvcod And itnbr = :ls_itnbr and start_date = :ls_start ;
	commit ;
end if

ib_any_typing = false

dw_insert.ReSet()
dw_insert.InsertRow(0)

dw_insert.SetItem(1, 'cvcod', ls_cvcod)
dw_insert.SetItem(1, 'start_date', String(TODAY(), 'yyyymmdd'))
dw_insert.SetItem(1, 'cvnas', f_get_name5('11', ls_cvcod, ''))

p_inq.triggerevent(clicked!)

end event

type p_inq from w_inherite`p_inq within w_sm20_0010
integer y = 3200
end type

event p_inq::clicked;call super::clicked;string  s_cvcod,s_ittyp, s_itcls, ls_itnbr


If dw_insert.AcceptText() 	= -1 Then Return
If dw_insert.RowCount() 	<= 0 Then Return


s_cvcod  	= Trim(dw_insert.getitemstring(1, "cvcod"))
ls_itnbr  	= Trim(dw_insert.getitemstring(1, "itnbr"))

////필수입력항목을 입력하지 않고 [조회]를 click한 경우///////////////////
IF rb_1.Checked = True THEN
	if 	ls_itnbr = "" or isnull(ls_itnbr) then 
		f_message_chk(30,'[품번]')
		dw_insert.setcolumn("itnbr")
		dw_insert.setfocus()
			return 
	end if
	if IsNull(s_cvcod) or s_cvcod = '' then s_cvcod = '%'
ELSE
	if s_cvcod = "" or isnull(s_cvcod) then 
		f_message_chk(30,'[거래처]')
		dw_insert.setcolumn("cvcod")
		dw_insert.setfocus()
			return 
	end if
	If IsNull(ls_itnbr) or ls_itnbr = '' Then		ls_itnbr = '%'
END IF	
////////////////////////////////////////////////////////////////////////////////

dw_insert.setredraw(false)	 // 화면이 껌벅거리는 것을 막기 위해... (false ~ true)

if dw_list.retrieve(s_cvcod,  ls_itnbr) <= 0 then
//  	f_message_chk(50,'[거래처 단가 등록]')	
   dw_insert.setredraw(true)	
	return	
end if

dw_insert.setredraw(true)	

ib_any_typing = false
end event

type p_print from w_inherite`p_print within w_sm20_0010
integer y = 3200
end type

type p_can from w_inherite`p_can within w_sm20_0010
integer y = 3200
end type

event p_can::clicked;call super::clicked;string scvcod,scvnas
int nRow

//nRow = dw_insert.GetRow()
//If nRow > 0 Then 
//   scvcod = Trim(dw_insert.GetItemString(nRow,'cvcod'))
//Else
//	SetNull(scvcod)
//	SetNull(ls_itnbr)
//End If

dw_insert.setredraw(false)	 

dw_list.Reset()
dw_insert.reset()

rb_2.Checked = True

dw_list.DataObject = "d_sm20_0010_04"
dw_list.SetTransObject(sqlca)

dw_insert.Object.itnbr_t.y = 112
dw_insert.Object.itnbr.y = 112
dw_insert.Object.itdsc.y = 112

dw_insert.Object.t_1.y = 28
dw_insert.Object.cvcod.y = 28
dw_insert.Object.cvnas.y = 28

nRow = dw_insert.insertrow(0)
dw_insert.SetItem(nRow, "cvcod", '')
dw_insert.SetItem(nRow, "cvnas", '')
dw_insert.SetItem(nRow, "itnbr", '')
dw_insert.SetItem(nRow, "itdsc", '')
dw_insert.SetItem(nRow, "start_date", f_today())
dw_insert.SetRow(nRow)

dw_insert.SetFocus()
dw_insert.SetColumn("cvcod")

dw_insert.SetTabOrder("cvcod",10)
dw_insert.SetTabOrder("itnbr",30)

wf_key_protect('신규')
dw_insert.setredraw(true)


end event

type p_exit from w_inherite`p_exit within w_sm20_0010
integer y = 3200
end type

event p_exit::clicked;//
close(parent)
end event

type p_ins from w_inherite`p_ins within w_sm20_0010
integer y = 3200
end type

event p_ins::clicked;string scvcod,scvnas , ls_itnbr, ls_itdsc , ls_ispec , ls_jijil
int nRow

w_mdi_frame.sle_msg.text =""

nRow = dw_insert.GetRow()
If nRow > 0 Then 
   scvcod = Trim(dw_insert.GetItemString(nRow,'cvcod'))
   scvnas = Trim(dw_insert.GetItemString(nRow,'cvnas'))
	
	ls_itnbr = Trim(dw_insert.GetItemString(nRow,'itnbr'))
	ls_itdsc = Trim(dw_insert.GetItemString(nRow,'itdsc'))
	ls_ispec = Trim(dw_insert.GetItemString(nRow,'ispec'))
	ls_jijil = Trim(dw_insert.GetItemString(nRow,'jijil'))
	
Else
	SetNull(scvcod)
End If

dw_insert.setredraw(false)	 

dw_insert.reset()

nRow = dw_insert.insertrow(0)
If rb_1.checked Then
	If ls_itnbr = '' or isNull(ls_itnbr) Then
		dw_insert.SetFocus()
		dw_insert.SetRow(nRow)
		dw_insert.SetColumn("itnbr")
	Else
		dw_insert.SetItem(nRow, "itnbr", ls_itnbr)
		dw_insert.SetItem(nRow, "itdsc", ls_itdsc)
		dw_insert.SetItem(nRow, "ispec", ls_ispec)
		dw_insert.SetItem(nRow, "jijil", ls_jijil)
		dw_insert.SetItem(nRow, "start_date", f_today())
		dw_insert.SetFocus()
		dw_insert.SetRow(nRow)
		dw_insert.SetColumn("cvcod")
	End If
Else
	IF scvcod = '' or isNull(scvcod) then
		dw_insert.SetFocus()
		dw_insert.SetRow(nRow)
		dw_insert.SetColumn("cvcod")
	Else
		dw_insert.SetItem(nRow, "cvcod", scvcod)
		dw_insert.SetItem(nRow, "cvnas", scvnas)
		dw_insert.SetItem(nRow, "start_date", f_today())
		
		dw_insert.SetFocus()
		dw_insert.SetRow(nRow)
		dw_insert.SetColumn("itnbr")
	End If
End If
wf_key_protect('신규')
dw_insert.setredraw(true)
end event

type p_new from w_inherite`p_new within w_sm20_0010
integer y = 3200
end type

type dw_input from w_inherite`dw_input within w_sm20_0010
boolean visible = false
integer y = 2436
end type

type cb_delrow from w_inherite`cb_delrow within w_sm20_0010
boolean visible = false
integer y = 3400
end type

type cb_addrow from w_inherite`cb_addrow within w_sm20_0010
boolean visible = false
integer y = 3400
end type

type dw_insert from w_inherite`dw_insert within w_sm20_0010
integer x = 37
integer y = 56
integer width = 3538
integer height = 476
string dataobject = "d_sm20_0010_01"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
end type

event dw_insert::itemchanged;String sarea, steam, sCvcod, scvnas, sSaupj, sName1
String ssNull, sTodate, sFrdate, sName, sGet_name, steamcd
String sItdsc, sIspec, sJijil, sIspeccode
long   lcount, l_data, inull,nRtn, ireturn
string sitnbr,scurr,spricegbn
double dc_rate , ld_price

SetNull(ssNull)
setnull(inull)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName() 
	/* 거래처 */
	Case "cvcod"
		sCvcod = Trim(GetText())
		IF 	sCvcod ="" OR IsNull(sCvcod) THEN
			SetItem(1,"cvnas",ssNull)
			Return
		END IF

		If 	f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
			SetItem(1, "cvcod", ssNull)
			SetItem(1, "cvnas", ssNull)
			Return 1
		ELSE
			SetItem(1,"cvnas",	scvnas)
			p_inq.TriggerEvent(Clicked!)
		END IF
	/* 품번 */
	Case "itnbr"
		sItnbr = trim(GetText())
	
		//ireturn = f_get_name4_sale('품번', 'Y', sitnbr, sitdsc, sispec, sjijil, sispeccode)	
		Select itnbr , itdsc , ispec , jijil
		  Into :sitnbr, :sitdsc, :sispec, :sjijil
		  From itemas 
		 where itnbr = :sItnbr ;
		 
		If sqlca.sqlcode = 0 Then
			setitem(1, "itnbr", sitnbr)	
			setitem(1, "itdsc", sitdsc)	
			setitem(1, "ispec", sispec)
			setitem(1, "jijil", sjijil)
			
			p_inq.TriggerEvent(Clicked!)
//		Else
//			setitem(1, "itnbr", ssNull)	
//			setitem(1, "itdsc", ssNull)	
//			setitem(1, "ispec", ssNull)
//			setitem(1, "jijil", ssNull)
//			f_message_chk(33,'[품번]')
//			Return 1
		End IF
		
	Case "start_date"
		IF 	f_datechk(trim(gettext())) = -1	then
      		f_message_chk(35,'[적용시작일]')
			setitem(1, "start_date", ssNull)
		return 1
		END IF
	Case "end_date"
		stodate = trim(gettext())
		IF 	f_datechk(stodate) = -1	then
			f_message_chk(35,'[적용마감일]')
			setitem(1, "end_date", ssNull)
			return 1
		END IF
	
   		sfrdate = dw_insert.GetItemString(1,"start_date")
   		If 	sfrdate > stodate then
	   		f_message_chk(200,'[마감일자]')
	   		return 1
   		End if
 	Case 'sales_price'
		ld_price = Double(GetText())
		If ld_price <= 0 Then
			f_message_chk(80,'')
			Return 1
		End If
		
		
end Choose

ib_any_typing = false

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;Long nRow

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

nRow = GetRow()
If nRow <= 0 Then Return
Choose Case GetColumnName() 
	Case 'itnbr'
		gs_code = Trim(this.GetText())
		gs_gubun = '1'
		open(w_itemas_popup)
		if gs_code = "" or isnull(gs_code) then return 
		this.setitem(1, 'itnbr', gs_code)
		this.setitem(1, 'itdsc', gs_codename)
		this.setitem(1, 'ispec', gs_gubun)
		this.setcolumn("end_date")
		this.setfocus()
	/* 거래처 */
	Case "cvcod"
	
		gs_gubun = '1' 
		Open(w_vndmst_popup)
		
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"cvcod",gs_code)
		SetColumn("cvcod")
		TriggerEvent(ItemChanged!)
end Choose

end event

event dw_insert::ue_key;call super::ue_key;str_itnct str_sitnct

setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"itnbr",gs_code)
//		cb_inq.TriggerEvent(Clicked!)
		RETURN 1
	End if	
END IF		
end event

event dw_insert::clicked;//
end event

event dw_insert::rowfocuschanged;//
end event

event dw_insert::doubleclicked;//
end event

type cb_mod from w_inherite`cb_mod within w_sm20_0010
boolean visible = false
integer y = 3400
end type

type cb_ins from w_inherite`cb_ins within w_sm20_0010
boolean visible = false
integer y = 3400
end type

type cb_del from w_inherite`cb_del within w_sm20_0010
boolean visible = false
integer y = 3400
end type

type cb_inq from w_inherite`cb_inq within w_sm20_0010
boolean visible = false
integer y = 3400
end type

type cb_print from w_inherite`cb_print within w_sm20_0010
boolean visible = false
integer y = 3400
end type

type cb_can from w_inherite`cb_can within w_sm20_0010
boolean visible = false
integer y = 3400
end type

type cb_search from w_inherite`cb_search within w_sm20_0010
boolean visible = false
integer y = 3400
end type

type gb_10 from w_inherite`gb_10 within w_sm20_0010
end type

type gb_button1 from w_inherite`gb_button1 within w_sm20_0010
end type

type gb_button2 from w_inherite`gb_button2 within w_sm20_0010
end type

type r_head from w_inherite`r_head within w_sm20_0010
boolean visible = false
integer y = 2432
end type

type r_detail from w_inherite`r_detail within w_sm20_0010
integer y = 52
integer width = 3546
integer height = 484
end type

type gb_3 from groupbox within w_sm20_0010
integer x = 2080
integer y = 2772
integer width = 1536
integer height = 208
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_list from u_d_popup_sort within w_sm20_0010
integer x = 37
integer y = 636
integer width = 4544
integer height = 1724
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sm20_0010_04"
boolean border = false
end type

event clicked;call super::clicked;string s_cvcod,s_itnbr,s_sdate
string s_itdsc,s_ispec
int      nRow

If row <= 0 then
	this.SelectRow(0,False)
	Return
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(row,TRUE)
END IF

////  행을 선택하여 dw_insert로 retrieve             //////////////////////////
////  해당 행에서 키(품번, 적용시작일)를 retrieve    ////////////////////////// 

s_cvcod 	= trim(this.getitemstring(Row, "cvcod"))
s_itnbr 	= this.getitemstring(Row, "itnbr")
s_itdsc 	= this.getitemstring(Row, "itdsc")
s_ispec 	= this.getitemstring(Row, "ispec")
s_sdate 	= this.getitemstring(Row, "start_date")
If 	IsNull(s_itdsc) Then s_itdsc = ''
If 	IsNull(s_ispec) Then s_ispec = ''

nRow = dw_insert.retrieve(s_cvcod,s_itnbr, s_sdate)        // 기존에 등록된 데이타이면..
wf_key_protect('조회')

SetNull(is_itnbr)

is_itnbr = dw_list.GetItemString(Row,"itnbr")
	

//p_addrow.enabled 	= true
//p_delrow.enabled 	= true

//p_addrow.PictureName  	= "..\image\행추가_up.gif"
//p_delrow.PictureName  	= "..\image\행삭제_up.gif"

this.SetRedraw(true)

end event

type pb_1 from u_pic_cal within w_sm20_0010
integer x = 2560
integer y = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_insert.SetColumn('start_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_insert.SetItem(1, 'start_date', gs_code)

end event

type rb_1 from radiobutton within w_sm20_0010
integer x = 3717
integer y = 268
integer width = 210
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "품번"
end type

event clicked;wf_change()
end event

type rb_2 from radiobutton within w_sm20_0010
integer x = 3963
integer y = 268
integer width = 265
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "거래처"
boolean checked = true
end type

event clicked;wf_change()
end event

type st_3 from statictext within w_sm20_0010
integer x = 82
integer y = 556
integer width = 1979
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 16777215
string text = "* CKD 단가는  HMC,MOBIS A/S 수출용입니다."
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_sm20_0010
integer x = 3598
integer y = 420
integer width = 626
integer height = 128
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "단가일괄등록"
end type

event clicked;uo_xlobject uo_xl , uo_xltemp
string ls_itnbr, ls_cvcod, ls_mcvcod, ls_ymd, ls_today, ls_totime
string ls_docname, ls_named[], ls_line 
Long   ll_xl_row , ll_r , ix ,i , ll_cnt=0 , ll_c , ll_value , iii=0
Long   ll_err , ll_succeed  
String ls_file , ls_cvlist[]
Long ll_seq , ll_jpno  , ll_count
decimal	ld_eaprc, ld_ckdprc
string	ls_eamsr, ls_ckdmsr, ls_type, ls_sayu, ls_auto


ls_today = f_today()
ls_totime = f_totime()

// 엘셀 IMPORT ***************************************************************
ll_value = GetFileOpenName("제품단가등록 데이타 가져오기", ls_docname, ls_named[], & 
             "XLS", "XLS Files (*.XLS),*.XLS,")
If ll_value <> 1 Then Return

Setpointer(Hourglass!)

ll_err = 0
ll_succeed = 0
ll_cnt = 0

If  FileExists('date_conv.xls') = False Then
	MessageBox('확인','date_conv.xls'+' 파일이 존재하지 않습니다.')
	Return
End If 

uo_xltemp = create uo_xlobject
uo_xltemp.uf_excel_connect('date_conv.xls', false , 3)
uo_xltemp.uf_selectsheet(1)
uo_xltemp.uf_set_format(1,1, '@' + space(30))

w_mdi_frame.sle_msg.visible = True

For ix = 1 To UpperBound(ls_named)
	
	If UpperBound(ls_named) = 1 Then
		ls_file = ls_docname
	else
		ls_file = ls_docname +'\'+ ls_named[ix]
	end if
	
	w_mdi_frame.sle_msg.text = ls_file + " 파일을 읽고 있습니다."
	
	If  FileExists(ls_file) = False Then
		MessageBox('확인',ls_file+' 파일이 존재하지 않습니다.')
		w_mdi_frame.sle_msg.visible = false
		Return
	End If 
	
			
	//엑셀과 연결
	uo_xl = create uo_xlobject
	uo_xl.uf_excel_connect(ls_file, false , 3)
	uo_xl.uf_selectsheet(1)
	
	ll_cnt = 0
	//Data 시작 Row Setting
	ll_xl_row = 6		

	Do While(True)
		
		//Data가 없을경우엔 Return...........
		if isnull(uo_xl.uf_gettext(ll_xl_row,2)) or trim(uo_xl.uf_gettext(ll_xl_row,2)) = '' then exit
		
		For i =1 To 15
			uo_xl.uf_set_format(ll_xl_row,i, '@' + space(30))
		Next
		
		SetNull(ls_itnbr)
		SetNull(ls_cvcod)
		
		ll_cnt ++
		yield()
	
		ls_cvcod	= Trim(uo_xl.uf_gettext(ll_xl_row,1))
		ls_itnbr	= Trim(uo_xl.uf_gettext(ll_xl_row,2))
		ls_ymd	= Trim(uo_xl.uf_gettext(ll_xl_row,3))
		ld_eaprc	= Dec(Trim(uo_xl.uf_gettext(ll_xl_row,4)))
		ls_eamsr	= Trim(uo_xl.uf_gettext(ll_xl_row,5))
		ld_ckdprc= Dec(Trim(uo_xl.uf_gettext(ll_xl_row,6)))
		ls_ckdmsr= Trim(uo_xl.uf_gettext(ll_xl_row,7))
		ls_type	= Trim(uo_xl.uf_gettext(ll_xl_row,8))
		ls_sayu	= Trim(uo_xl.uf_gettext(ll_xl_row,9))
		ls_auto	= Trim(uo_xl.uf_gettext(ll_xl_row,10))
		
		
		w_mdi_frame.sle_msg.text =String(ll_xl_row) +" 행의 " +ls_itnbr+ ' 품번을 읽고 있습니다.'
	
		// 1. 거래처정보 확인
		select cvcod Into :ls_cvcod from vndmst where cvcod = :ls_cvcod ;				
		if sqlca.sqlcode <> 0 then
			MessageBox(ls_cvcod,'거래처코드가 잘못 지정되었습니다.')
			ll_err++
			ll_xl_row ++
			Continue ;
		end if

		// 2. 품번정보 확인
		select itnbr Into :ls_itnbr from itemas where itnbr = :ls_itnbr ;				
		if sqlca.sqlcode <> 0 then
			MessageBox(ls_itnbr,'품번이 잘못 지정되었습니다.')
			ll_err++
			ll_xl_row ++
			Continue ;
		end if

		// 3. 적용일자 확인
		if f_datechk(ls_ymd) = -1 then
			MessageBox(ls_ymd,'적용일자가 잘못 지정되었습니다.')
			ll_err++
			ll_xl_row ++
			Continue ;
		end if

		// 4. EA단가 확인
		if isnull(ld_eaprc) or ld_eaprc < 0 then
			MessageBox(string(ld_eaprc),'단가가 잘못 지정되었습니다.')
			ll_err++
			ll_xl_row ++
			Continue ;
		end if
		
		// 5. EA통화단위 확인
		select rfgub Into :ls_eamsr from reffpf where rfcod = '10' and rfgub = :ls_eamsr ;				
		if sqlca.sqlcode <> 0 then
			MessageBox(ls_eamsr,'통화단위가 잘못 지정되었습니다.')
			ll_err++
			ll_xl_row ++
			Continue ;
		end if
		
		// 6. CKD단가 확인
		if isnull(ld_ckdprc) or ld_ckdprc < 0 then
			MessageBox(string(ld_ckdprc),'단가가 잘못 지정되었습니다.')
			ll_err++
			ll_xl_row ++
			Continue ;
		end if
		
		// 7. CKD통화단위 확인
		select rfgub Into :ls_ckdmsr from reffpf where rfcod = '10' and rfgub = :ls_ckdmsr ;				
		if sqlca.sqlcode <> 0 then
			MessageBox(ls_ckdmsr,'통화단위가 잘못 지정되었습니다.')
			ll_err++
			ll_xl_row ++
			Continue ;
		end if

		// 8. 단가유형 확인
		if isnull(ls_type) or ls_type = '' or ( ls_type <> '1' and ls_type <> '0' ) then
			MessageBox(ls_type,'단가유형이 잘못 지정되었습니다.')
			ll_err++
			ll_xl_row ++
			Continue ;
		end if

		// 9. 변동사유 확인
		select rfgub Into :ls_sayu from reffpf where rfcod = '2V' and rfgub = :ls_sayu ;				
		if sqlca.sqlcode <> 0 then
			MessageBox(ls_sayu,'변동사유가 잘못 지정되었습니다.')
			ll_err++
			ll_xl_row ++
			Continue ;
		end if

		// 10. 일괄적용 확인
		if isnull(ls_auto) or ls_auto = '' or ls_auto <> 'Y' then
			ls_auto = 'N'
		end if

		
		ll_cnt = 0 


		///////////////////////////////////////////////////////////////////////////////////////////////////////
		// 개별적용
		If ls_auto = 'N' Then
			select count(*) Into :ll_cnt
			  from vnddan
			 where cvcod = :ls_cvcod
				and itnbr = :ls_itnbr   
				and start_date = :ls_ymd ;

			If ll_cnt > 0 Then
				delete from vnddan 
				 where cvcod = :ls_cvcod and itnbr = :ls_itnbr and start_date = :ls_ymd ;
			end if

			insert into vnddan
			(	cvcod,		itnbr,		start_date,		end_date,		sales_price,	curr,
				crt_date,   crt_time,   crt_user,      broad_price,   broad_curr,    dangu,      bigo	)
			values
			(	:ls_cvcod, :ls_itnbr,	:ls_ymd,			'99991231',		:ld_eaprc,		:ls_eamsr,
				:ls_today,	:ls_totime,	:gs_userid, :ld_ckdprc, :ls_ckdmsr, :ls_type,	:ls_sayu	) ;

		///////////////////////////////////////////////////////////////////////////////////////////////////////
		// 일괄적용
		Else
			select count(*) Into :ll_cnt
			  from vnddan
			 where itnbr = :ls_itnbr   
				and start_date = :ls_ymd ;
				
			dw_cvlist.retrieve(ls_cvcod, ls_itnbr)

			if ll_cnt > 0 then
				for ll_c = 1 to dw_cvlist.rowcount()
					ls_mcvcod = dw_cvlist.getitemstring(ll_c, 'cvcod')
					
					delete from vnddan 
					 where cvcod = :ls_mcvcod and itnbr = :ls_itnbr and start_date = :ls_ymd ;
				next
			end if

			for ll_c = 1 to dw_cvlist.rowcount()
				ls_mcvcod = dw_cvlist.getitemstring(ll_c, 'cvcod')
				
				insert into vnddan
				(	cvcod,		itnbr,		start_date,		end_date,		sales_price,	curr,
					crt_date,   crt_time,   crt_user,      broad_price,   broad_curr,    dangu,      bigo	)
				values
				(	:ls_mcvcod, :ls_itnbr,	:ls_ymd,			'99991231',		:ld_eaprc,		:ls_eamsr,
					:ls_today,	:ls_totime,	:gs_userid, :ld_ckdprc, :ls_ckdmsr, :ls_type,	:ls_sayu	) ;
			next

		End If
			
	
		if sqlca.sqlcode <> 0 then
			MessageBox(ls_itnbr,'제품단가 등록 오류가 발생했습니다!!!')
			rollback;
			uo_xltemp.uf_excel_Disconnect()
			uo_xl.uf_excel_Disconnect()
			w_mdi_frame.sle_msg.visible = false
			return
		end if

		ll_xl_row ++
		ll_succeed++
		
		w_mdi_frame.sle_msg.text = ls_named[ix]+ ' 파일의 '+String(ll_xl_row) + '행을 읽고 있습니다.'
		
	Loop
	
	uo_xl.uf_excel_Disconnect()
	// 엘셀 IMPORT  END ***************************************************************

Next

//w_mdi_frame.sle_msg.text =' 데이타를 저장 중입니다.'

commit;

uo_xltemp.uf_excel_Disconnect()
if ll_succeed > 0 then
	messagebox('확인','데이타 접수완료!!!')
else
	messagebox('확인','접수된 자료가 없습니다!!!')
end if
p_inq.triggerevent(clicked!)
end event

type dw_cvlist from datawindow within w_sm20_0010
boolean visible = false
integer x = 4256
integer y = 912
integer width = 183
integer height = 208
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm20_0010_09"
boolean border = false
boolean livescroll = true
end type

type dw_form from datawindow within w_sm20_0010
boolean visible = false
integer x = 3538
integer y = 912
integer width = 686
integer height = 400
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm20_0010_form"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.SetTransObject(SQLCA)
end event

type cb_form from commandbutton within w_sm20_0010
integer x = 4238
integer y = 420
integer width = 366
integer height = 128
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "FORM"
end type

event clicked;String	ls_quota_no
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
	
 	If uf_save_dw_as_excel(dw_form,ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end event

type gb_1 from groupbox within w_sm20_0010
integer x = 3579
integer y = 196
integer width = 736
integer height = 176
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "구분"
end type

type r_list from rectangle within w_sm20_0010
long linecolor = 28543105
integer linethickness = 4
long fillcolor = 33028087
integer x = 32
integer y = 632
integer width = 4552
integer height = 1732
end type

