$PBExportHeader$w_adt_01270_01.srw
$PBExportComments$문서 등록 추가
forward
global type w_adt_01270_01 from window
end type
type st_2 from statictext within w_adt_01270_01
end type
type pb_4 from picturebutton within w_adt_01270_01
end type
type pb_3 from picturebutton within w_adt_01270_01
end type
type cbx_2 from checkbox within w_adt_01270_01
end type
type cbx_1 from checkbox within w_adt_01270_01
end type
type dw_3 from datawindow within w_adt_01270_01
end type
type dw_2 from datawindow within w_adt_01270_01
end type
type pb_2 from u_pb_cal within w_adt_01270_01
end type
type pb_1 from u_pb_cal within w_adt_01270_01
end type
type p_exit from uo_picture within w_adt_01270_01
end type
type p_mod from uo_picture within w_adt_01270_01
end type
type dw_add from datawindow within w_adt_01270_01
end type
type rr_1 from roundrectangle within w_adt_01270_01
end type
type rr_2 from roundrectangle within w_adt_01270_01
end type
type rr_3 from roundrectangle within w_adt_01270_01
end type
end forward

global type w_adt_01270_01 from window
integer x = 951
integer y = 336
integer width = 3826
integer height = 2444
boolean titlebar = true
string title = "문서등록추가"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
st_2 st_2
pb_4 pb_4
pb_3 pb_3
cbx_2 cbx_2
cbx_1 cbx_1
dw_3 dw_3
dw_2 dw_2
pb_2 pb_2
pb_1 pb_1
p_exit p_exit
p_mod p_mod
dw_add dw_add
rr_1 rr_1
rr_2 rr_2
rr_3 rr_3
end type
global w_adt_01270_01 w_adt_01270_01

type variables
decimal is_danga
string is_cvcod, &
         is_year, &
         is_series
integer is_chasu

string is_filepath
string is_path
string is_file

string is_itcls
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_check_itnbr (string sitnbr)
public function integer wf_calc_danga (integer nrow, string itnbr, double ditemqty)
public function integer wf_auth_update ()
end prototypes

public function integer wf_check_itnbr (string sitnbr);//Long   cnt, iRtnValue
//String sNull
//Dec    dDanga
//
//SetNull(sNull)
//
////**********************************************		
//Select count(*) Into :cnt From yearsaplan
//Where (sabu = :gs_sabu) and (substr(plan_yymm,1,4)) = (:is_year) and 
//		(plan_chasu = :is_chasu) and (cvcod = :is_cvcod) and (itnbr = :sitnbr);	
////**********************************************
//
//if cnt > 0 then
//	f_message_Chk(1, '[해당품목의 년간계획 존재유무 확인]')
//	dw_ip.SetItem(1,"itnbr",   sNull)
//	dw_ip.SetItem(1,"itdsc",   sNull)
//	dw_ip.SetItem(1,"ispec",   sNull)
//	dw_ip.SetItem(1,"ispec_code",   sNull)
//	dw_ip.SetItem(1,"shtnm",   sNull)
//	dw_ip.SetItem(1,"tuncu",   sNull)
//	dw_ip.SetItem(1,"dprice",   0)
//	Return -1
//End If
//
//
////iRtnValue = wf_calc_danga(1, sItnbr, 0)
//
////SELECT Fun_Erp100000012(to_char(sysdate,'yyyymmdd'), :sitnbr, '.')		  INTO :dDanga	  FROM DUAL;
//
////If IsNull(dDanga) Then dDanga = 0
////
////is_danga = dDanga
////dw_ip.setitem(1, "dprice", ddanga)
//
//
//		
Return 1
end function

public function integer wf_calc_danga (integer nrow, string itnbr, double ditemqty);///* 판매단가및 할인율 */
///* --------------------------------------------------- */
///* 가격구분 : 2000.05.16('0' 추가됨)                   */
///* 0 - 수량별 할인율 등록 단가              		       */ 
///* 1 - 특별출하 거래처 등록 단가                       */ 
///* 2 - 이벤트 할인율 등록 단가                    	    */ 
///* 3 - 거래처별 제품단가 등록 단가                     */ 
///* 4 - 거래처별 할인율 등록 단가                       */ 
///* 5 - 품목마스타 등록 단가                  		    */ 
///* 9 - 미등록 단가                         		       */ 
///* --------------------------------------------------- */
//string sOrderDate, sCvcod, sOrderSpec, sSalegu, sOutgu 
//int    iRtnValue = -1, iRtn
//double ditemprice,ddcrate, dQtyPrice, dQtyRate
//
//sOrderDate 	= f_today()
//sCvcod 	  	= is_cvcod
//sOrderSpec = '.'
//
///* 수량 */
//IF IsNull(dItemQty) THEN dItemQty =0
//
//
///* 무상출고일 경우 */
//sSalegu 	='Y'
//If 	sSaleGu = 'N' Then
//	dItemPrice = sqlca.Fun_Erp100000025(Itnbr,sOrderSpec, sOrderDate) 
//	If IsNull(dItemPrice) Then dItemPrice = 0
//	dw_ip.SetItem(1, 'dprice', dItemPrice)
//	Return 0
//End If
//		
///* 수량이 0이상일 경우 수량base단가,할인율을 구한다 */
//If dItemQty > 0 Then
//	iRtnValue = sqlca.Fun_Erp100000021(gs_sabu, sOrderDate, sCvcod, Itnbr, dItemQty, &
//                                    'WON', dQtyPrice, dQtyRate) 
//End If
//
//If IsNull(dQtyPrice) Then dQtyPrice = 0
//If IsNull(dQtyRate)	Then dQtyRate = 0
//
///* 판매 기본단가,할인율를 구한다 */
//iRtnValue  = sqlca.Fun_Erp100000016(gs_sabu,  sOrderDate, sCvcod, Itnbr, sOrderSpec, &
//												'WON','1', dItemPrice, dDcRate) 
//
///* 특출단가나 거래처단가일경우 수량별 할인율은 적용안함 */
//If iRtnValue = 1 Or iRtnValue = 3 Then		dQtyRate = 0
//
///* 기본할인율 적용단가 * 수량별 할인율 */
//If dQtyRate <> 0 Then
//	
//	dItemPrice = dItemPrice * (100 - dQtyRate)/100
//	
//	/* 수소점2자리 */
//	dItemPrice = Truncate(dItemPrice , 2) 
//	
//	/* 할인율 재계산 */
//   iRtn = sqlca.fun_erp100000014(itnbr,sOrderSpec, dItemPrice, sOrderDate, 'WON', '1', dDcRate)
//   If iRtn = -1 Then dDcRate = 0
//End If
//
//If IsNull(dItemPrice) Then dItemPrice = 0
//If IsNull(dDcRate) 	 Then dDcRate = 0
//
///* 단가 : 절삭 */
//dItemPrice = truncate(dItemPrice,0)
//
//Choose Case iRtnValue
//	Case IS < 0 
//		f_message_chk(41,'[단가 계산]'+string(irtnvalue))
//		Return 1
//	Case Else
//		dw_ip.SetItem(1,"dprice",	dItemPrice)
//End Choose
//
//is_danga = dw_ip.GetItemDecimal(1, "dprice")
Return 0
end function

public function integer wf_auth_update ();if dw_3.rowcount() < 1 then
	Return 0
end if

If dw_3.Update() = -1 then  
	Rollback;
	messagebox("확인","권한설정 저장실패!")
	Return -1
End if

Commit;
Return 1

end function

on w_adt_01270_01.create
this.st_2=create st_2
this.pb_4=create pb_4
this.pb_3=create pb_3
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.dw_3=create dw_3
this.dw_2=create dw_2
this.pb_2=create pb_2
this.pb_1=create pb_1
this.p_exit=create p_exit
this.p_mod=create p_mod
this.dw_add=create dw_add
this.rr_1=create rr_1
this.rr_2=create rr_2
this.rr_3=create rr_3
this.Control[]={this.st_2,&
this.pb_4,&
this.pb_3,&
this.cbx_2,&
this.cbx_1,&
this.dw_3,&
this.dw_2,&
this.pb_2,&
this.pb_1,&
this.p_exit,&
this.p_mod,&
this.dw_add,&
this.rr_1,&
this.rr_2,&
this.rr_3}
end on

on w_adt_01270_01.destroy
destroy(this.st_2)
destroy(this.pb_4)
destroy(this.pb_3)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.dw_add)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;string ls_empnm, ls_no, ls_pritype, ls_docno
long   ll_seq, ll_docseq
str_doc str_1

f_window_center_response(this)

dw_add.SetTransObject(sqlca)
dw_2.settransobject(sqlca)
dw_3.settransobject(sqlca)

dw_add.reset()
dw_add.InsertRow(0)
dw_add.accepttext()

str_1 =  Message.PowerObjectParm

ls_no  = str_1.st_docno
ll_seq = str_1.st_seq


if dw_add.retrieve(ls_no, ll_seq) <= 0 then
//	p_save.enabled 	 = false
//	p_save.PictureName = "c:\erpman\image\저장_d.gif"
	pb_3.enabled 		 = false
	pb_3.PictureName   = "c:\erpman\image\PRIOR_3.bmp"
	pb_4.enabled 		 = false
	pb_4.PictureName   = "c:\erpman\image\NEXT_3.bmp"
	dw_add.reset()
   dw_add.InsertRow(0)
	
	//등록자 셋팅
	select empname into :ls_empnm
	from p1_master where empno = :gs_empno;
	dw_add.setitem(1,'empno',gs_empno)
	dw_add.setitem(1,'empname',ls_empnm)	
else	
//	p_save.enabled 	 = true
//	p_save.PictureName = "c:\erpman\image\저장_up.gif"
	pb_3.enabled 		 = true
	pb_3.PictureName   = "c:\erpman\image\PRIOR_1.bmp"
	pb_4.enabled 		 = true
	pb_4.PictureName   = "c:\erpman\image\NEXT_1.bmp"
	ls_pritype = dw_add.getitemstring(1,'pritype')
	dw_2.reset()
	dw_3.reset()
	cbx_1.text = '전체선택'
	cbx_1.checked = false
	cbx_2.text = '전체선택'
	cbx_2.checked = false	
	if ls_pritype = '2' then //부서
		//권한등록 datawindow
		dw_3.retrieve(ls_no, ll_seq) 
		dw_3.Modify("code_t.Text='부서코드'")
		dw_3.Modify("codenm_t.Text='부서명'")
		
		//부서코드 조회
		dw_2.dataobject = 'd_adt_01270_vndmst'
		dw_2.settransobject(sqlca)
		dw_2.retrieve()	
	elseif ls_pritype = '4' then //개인
		//권한등록 datawindow
		dw_3.retrieve(ls_no, ll_seq) 
		dw_3.Modify("code_t.Text='사원번호'")
		dw_3.Modify("codenm_t.Text='사원명'")
		
		dw_2.dataobject = 'd_adt_01270_sawon'
		dw_2.settransobject(sqlca)
		dw_2.retrieve()	
	end if
end if	



end event

event close;setnull(gs_gubun)
end event

event closequery;setnull(gs_gubun)
end event

type st_2 from statictext within w_adt_01270_01
integer x = 50
integer y = 1040
integer width = 530
integer height = 60
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 33027312
string text = "[ 권한 등록 ]"
boolean focusrectangle = false
end type

type pb_4 from picturebutton within w_adt_01270_01
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1687
integer y = 1528
integer width = 178
integer height = 148
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\NEXT_1.bmp"
alignment htextalign = left!
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\NEXT_2.bmp"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\NEXT_1.bmp"
end event

event clicked;string ls_chk, ls_text, ls_code, ls_no, ls_empno, ls_gubun, ls_name
long   ll_cnt, ll_row, ll_max, ll_seq, lReturnRow
int    i, j, h

if dw_2.AcceptText() = -1 then return -1
if dw_3.AcceptText() = -1 then return -1
if dw_add.AcceptText() = -1 then return -1

ls_no    = dw_add.getitemstring(1,'docno')
ll_seq   = dw_add.getitemnumber(1,'docseq')
ls_empno = dw_add.getitemstring(1,'empno')
ls_gubun = dw_add.getitemstring(1,'pritype')

if ls_gubun = '2' then //부서
	//권한등록 datawindow
	dw_3.retrieve(ls_no, ll_seq) 
	dw_3.Modify("code_t.Text='부서코드'")
	dw_3.Modify("codenm_t.Text='부서명'")
elseif ls_gubun = '4' then //개인
	//권한등록 datawindow
	dw_3.retrieve(ls_no, ll_seq) 
	dw_3.Modify("code_t.Text='사원번호'")
	dw_3.Modify("codenm_t.Text='사원명'")
end if

//권한부여자 체크(등록자와 로그인 사번이 동일할 경우만 가능함)
if ls_empno <> gs_empno then
   MessageBox('알림', '자료에 대한 권한이 없습니다.~n 본인이 등록한 자료만 작업가능합니다.')
   return
end if		

//권한 부서/사번 선택여부
ll_cnt = 0
for h = 1 to dw_2.rowcount()
	 ls_chk = dw_2.GetItemString(h,'chk')
	 if ls_chk = 'Y' then
		 ll_cnt++
	 end if
next	

if ls_gubun = '1' then
	MessageBox('확인','권한이 전사로 설정 되어있습니다')
	return
elseif ls_gubun = '2' then  //부서별 권한
	ls_text = '부서코드'
elseif ls_gubun = '4' then  //개인별 권한
	ls_text = '사원코드'	
elseif ls_gubun = '9' then	
   MessageBox('확인','권한이 비공개로 설정 되어있습니다')
	return	
end if	
if ll_cnt < 1 then	
	MessageBox('확인','권한 등록할 ' + ls_text + '를 선택하세요')
	return
end if	

/* Max Seq */
select nvl(max(seq),0) + 1 into :ll_max
  from docsec
 where docno  = :ls_no
   and docseq = :ll_seq;
	
for j = 1 to dw_2.rowcount()
	 ls_chk = dw_2.GetItemString(j,'chk')
	 if ls_chk = 'Y' then
		 if ls_gubun = '2' then      //부서별 권한
			 ls_code = dw_2.GetItemString(j,'cvcod')
			 ls_name = dw_2.GetItemString(j,'cvnas2')
		 elseif ls_gubun = '4' then  //개인별 권한
			 ls_code = dw_2.GetItemString(j,'empno')
			 ls_name = dw_2.GetItemString(j,'empname')
		 end if	
		 

		lReturnRow = dw_3.Find("code = '"+ls_code+"' ", 1, dw_3.RowCount())
		IF lReturnRow = 0 THEN
			 ll_row = dw_3.insertrow(0)		 
			 dw_3.setitem(ll_row, 'docno', ls_no)
			 dw_3.setitem(ll_row, 'docseq', ll_seq)
			 dw_3.setitem(ll_row, 'seq', ll_max)
			 dw_3.setitem(ll_row, 'pritype', ls_gubun)
			 dw_3.setitem(ll_row, 'code', ls_code)		 
			 dw_3.setitem(ll_row, 'codenm', ls_name)	
			 
			 ll_max++
		END IF
	 end if
next 	
end event

type pb_3 from picturebutton within w_adt_01270_01
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1687
integer y = 1672
integer width = 178
integer height = 148
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\image\PRIOR_1.bmp"
alignment htextalign = left!
end type

event ue_lbuttondown;PictureName = "C:\erpman\image\PRIOR_2.bmp"
end event

event ue_lbuttonup;PictureName = "C:\erpman\image\PRIOR_1.bmp"
end event

event clicked;string ls_chk, ls_code, ls_no, ls_empno
long   ll_cnt, ll_row, ll_max, ll_seq
int    i, j, h

if dw_2.AcceptText() = -1 then return -1
if dw_3.AcceptText() = -1 then return -1
if dw_add.AcceptText() = -1 then return -1



ls_no    = dw_add.getitemstring(1,'docno')
ll_seq   = dw_add.getitemnumber(1,'docseq')
ls_empno = dw_add.getitemstring(1,'empno')


//권한부여자 체크(등록자와 로그인 사번이 동일할 경우만 가능함)
if ls_empno <> gs_empno then
   MessageBox('알림', '자료에 대한 권한이 없습니다.~n 본인이 등록한 자료만 작업가능합니다.')
   return
end if

//권한 삭제 선택여부
ll_cnt = 0
for h = 1 to dw_3.rowcount()
	 ls_chk = dw_3.GetItemString(h,'chk')
	 if ls_chk = 'Y' then
		 ll_cnt++
	 end if
next	

if ll_cnt < 1 then	
	MessageBox('확인','권한 삭제할 자료를 선택하세요')
	return
end if	

for j = dw_3.rowcount() to 1 step -1
	 if dw_3.GetItemString(j,'chk') = 'Y' then
		 dw_3.deleterow(j)
	 end if
next 	
end event

type cbx_2 from checkbox within w_adt_01270_01
integer x = 3328
integer y = 1140
integer width = 375
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;long ll_count, lCount
string ls_status

if this.checked = true then
	ls_status='Y'
	this.text = '전체해제'
else
	ls_status='N'
	this.text = '전체선택'
end if

SetPointer(HourGlass!)

lCount = dw_3.rowcount() 

for ll_count=1 to lCount
	dw_3.setitem(ll_count, 'chk', ls_status)
next


end event

type cbx_1 from checkbox within w_adt_01270_01
integer x = 1248
integer y = 1140
integer width = 375
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;long ll_count, lCount
string ls_status

if this.checked = true then
	ls_status='Y'
	this.text = '전체해제'
else
	ls_status='N'
	this.text = '전체선택'
end if

SetPointer(HourGlass!)

lCount = dw_2.rowcount() 

for ll_count=1 to lCount
	dw_2.setitem(ll_count, 'chk', ls_status)
next


end event

type dw_3 from datawindow within w_adt_01270_01
integer x = 1934
integer y = 1216
integer width = 1746
integer height = 1056
integer taborder = 110
string title = "none"
string dataobject = "d_adt_01270_3"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;if row = 0 then
	f_sort_asc(this,dwo.name)  
end if
end event

type dw_2 from datawindow within w_adt_01270_01
integer x = 59
integer y = 1216
integer width = 1550
integer height = 1056
integer taborder = 110
string title = "none"
string dataobject = "d_adt_01270_vndmst"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;if row = 0 then
	f_sort_asc(this,dwo.name)  
end if
end event

type pb_2 from u_pb_cal within w_adt_01270_01
boolean visible = false
integer x = 1714
integer y = 2408
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_add.SetColumn('crtdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_add.GetRow()
If ll_row < 1 Then Return
dw_add.SetItem(ll_row, 'crtdate', gs_code)



end event

type pb_1 from u_pb_cal within w_adt_01270_01
integer x = 718
integer y = 560
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_add.SetColumn('uptdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_add.GetRow()
If ll_row < 1 Then Return
dw_add.SetItem(ll_row, 'uptdate', gs_code)



end event

type p_exit from uo_picture within w_adt_01270_01
integer x = 3552
integer y = 16
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;setnull(gs_gubun)
CloseWithReturn(parent,-1)	

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_mod from uo_picture within w_adt_01270_01
integer x = 3378
integer y = 16
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;String  ls_jpno, ls_src_path, ls_file_nm, ls_file, ls_path
string  ls_docno, ls_docty, ls_pritype, ls_old_gubun
Long    ll_maxno, ll_seq, ll_cnt, ll_auth_flag=0

dw_add.AcceptText()
dw_3.AcceptText()

/* 권한설정 변경여부 Check(dw_3) */
If f_ischanged(dw_3) <> False Then
	ll_auth_flag = wf_auth_update()
End If

/* 변경된거 없으면 return */
If f_ischanged(dw_add) = False Then 
	If ll_auth_flag = 1 Then
		messagebox("확인","문서에 대한 권한부여가 처리 되었습니다!")
	End If
	Return
End If

ls_src_path   = dw_add.getitemstring(1,'path')
ls_file_nm    = dw_add.getitemstring(1,'docname')
ll_seq        = dw_add.getitemnumber(1,'docseq')
ls_docty      = dw_add.getitemstring(1,'doctype')
ls_pritype    = dw_add.getitemstring(1,'pritype')
ls_old_gubun  = dw_add.getitemstring(1,'old_gubun')
ls_docno      = dw_add.getitemstring(1,'docno')

if ll_seq = 0 or isnull(ll_seq) then 
	messagebox('선택', '차수를 입력하세요.')
	dw_add.setcolumn('docseq')
	dw_add.setfocus() 
	return
end if 

if trim(ls_docty) = '' or isnull(ls_docty) then
	messagebox('선택', '문서유형을 선택하세요.')
	dw_add.setcolumn('doctype')
	dw_add.setfocus()
	return
end if

if trim(ls_file_nm) = '' or isnull(ls_file_nm) then 
	messagebox('선택', '문서명(FILE명)을 입력하세요.')
	dw_add.setcolumn('docname')
	dw_add.setfocus() 
	return
end if 

//if trim(ls_src_path) = '' or isnull(ls_src_path) then
//	messagebox('선택', '파일경로를 선택하세요.')
//	dw_add.setcolumn('path')
//	dw_add.setfocus()
//	return
//end if

//권한설정 수정시 권한 기존 테이블삭제
if gs_gubun = '2' then //수정모드
   select Count(*) into :ll_cnt
	 from  docsec
	 where docno = :ls_docno and docseq = :ll_seq;
	if ll_cnt > 0 then 
		if ls_pritype <> ls_old_gubun  then
			If Messagebox("확인", "권한설정이 변경되어 기존 권한자료가 삭제됩니다.~n 권한설정을 변경하시겠습니까?", question!, yesno!, 2) = 1 then
				Delete from docsec where docno = :ls_docno and docseq = :ll_seq;
				commit;
				
				dw_2.reset()
				dw_3.reset()
				cbx_1.text = '전체선택'
				cbx_1.checked = false
				cbx_2.text = '전체선택'
				cbx_2.checked = false	
				if ls_pritype = '2' then //부서
					//권한등록 datawindow
					dw_3.retrieve(ls_docno, ll_seq) 
					dw_3.Modify("code_t.Text='부서코드'")
					dw_3.Modify("codename_t.Text='부서명'")
					
					//부서코드 조회
					dw_2.dataobject = 'd_adt_01270_vndmst'
					dw_2.settransobject(sqlca)
					dw_2.retrieve()	
				elseif ls_pritype = '4' then //개인
					//권한등록 datawindow
					dw_3.retrieve(ls_docno, ll_seq) 
					dw_3.Modify("code_t.Text='사원번호'")
					dw_3.Modify("codename_t.Text='사원명'")
					
					dw_2.dataobject = 'd_adt_01270_sawon'
					dw_2.settransobject(sqlca)
					dw_2.retrieve()	
				end if
			else
				return
			end if
		end if  
	end if	
end if	

if ls_docno ='' or isnull(ls_docno) then
	//문서번호채번
	ll_maxno = sqlca.fun_junpyo(gs_sabu, f_Today(), 'Y6') 
	commit;
	
	ls_jpno  = f_Today() + string(ll_maxno, '0000')
	dw_add.SetItem(1, 'docno', ls_jpno)
else
	ls_jpno  = dw_add.getitemstring(1,'docno')
end if	


If dw_add.Update() = -1 then  
	messagebox("확인","추가작업실패!")
	Rollback;
Else
	Commit;	
	
	ls_file = upper(is_file)
	ls_path = upper(is_path) 

   if not(ls_path = '' or isnull(ls_path)) then
		//////////////////////////////////////////
		// 선택한 FILE을 READ하여 DB에 UPDATE
		//////////////////////////////////////////
		integer 	li_FileNum, loops, i
		long 		flen, bytes_read, new_pos
		blob 		b, tot_b
		
		flen = FileLength(ls_path)
		li_FileNum = FileOpen(ls_path, StreamMode!, Read!, LockRead!)
			
		IF flen > 32765 THEN
			IF Mod(flen, 32765) = 0 THEN
				loops = flen/32765
			ELSE
				loops = (flen/32765) + 1
			END IF
		ELSE
			loops = 1
		END IF
		
		new_pos = 1
		
		FOR i = 1 to loops
			bytes_read = FileRead(li_FileNum, b)
			tot_b = tot_b + b
		NEXT
			
		FileClose(li_FileNum)	
//		messagebox('',ls_path)
//		messagebox('',ls_jpno)
//		messagebox('',ll_seq)
		//Blob 저장
		UpdateBlob DOCMST  
				 set docimg = :tot_b
			  where docno  = :ls_jpno 
				 and docseq = :ll_seq;
				 
		If SQLCA.SQLCODE <> 0 Then
			messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
			ROLLBACK USING SQLCA	;
			Return
		End if				
										
		COMMIT USING SQLCA	;
	end if
	gs_gubun = '2' //저장후 수정모드로 전환	
	dw_add.setitem(1,'old_gubun', dw_add.getitemstring(1,'pritype'))
	w_mdi_frame.sle_msg.text =""
	messagebox("확인","문서가 추가등록 되었습니다!")
//	p_save.enabled 	 = true
//	p_save.PictureName = "c:\erpman\image\저장_up.gif"
	pb_3.enabled 		 = true
	pb_3.PictureName   = "c:\erpman\image\PRIOR_1.bmp"
	pb_4.enabled 		 = true
	pb_4.PictureName   = "c:\erpman\image\NEXT_1.bmp"
End if


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type dw_add from datawindow within w_adt_01270_01
event ue_pressenter pbm_dwnprocessenter
integer x = 55
integer y = 264
integer width = 3662
integer height = 680
integer taborder = 20
string dataobject = "d_adt_01270_2"
boolean border = false
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event itemerror;return 1
end event

event itemchanged;string	ls_Data, ls_name, ls_name2, sNull
String   sCvcod, scvnas, sarea, steam, sSaupj, sName1
string   ls_pritype, ls_docno, ls_old_gubun 
long     ll_seq
int      ireturn
SetNull(sNull)

// 문서유형
IF this.GetColumnName() = 'doctype' THEN
	ls_Data = this.GetText()	
	SELECT "REFFPF"."RFNA1"  
	  INTO :ls_name  
     FROM "REFFPF"  
    WHERE ( "REFFPF"."SABU"  = '1' )  
      AND ( "REFFPF"."RFCOD" = '12' )
      AND ( "REFFPF"."RFGUB" = :ls_Data ) ;
	IF SQLCA.SQLCODE <> 0 THEN
	   this.SetItem(1,"doctynm",sNull)
	ELSE	
		this.SetItem(1,"doctynm", left(ls_name, 20))
 	END IF
ELSEIF this.GetcolumnName() = 'empno'	THEN //등록자
	ls_Data = trim(this.gettext())	 
  	ireturn = f_get_name2('사번', 'Y', ls_Data, ls_name, ls_name2) 
	this.setitem(1, "empno", ls_Data)
	this.setitem(1, "empname", ls_name)
	return ireturn 	 
ELSEIF this.GetcolumnName() = 'crtdate'	THEN 
	ls_Data = trim(this.gettext())
   if ls_Data = '' or isnull(ls_Data) then return 
	if f_datechk(ls_Data) = -1 then 
		f_message_chk(35, "[재정일자]" )
		this.SetItem(1,"crtdate",sNull)
		return 1
	end if
ELSEIF this.GetcolumnName() = 'uptdate'	THEN 	
	ls_Data = trim(this.gettext())
   if ls_Data = '' or isnull(ls_Data) then return 
	if f_datechk(ls_Data) = -1 then 
		f_message_chk(35, "[개정일자]" )
		this.SetItem(1,"uptdate",sNull)
		return 1
	end if
ELSEIF this.GetcolumnName() = 'cvcod'	THEN 	
	sCvcod = Trim(GetText())
	IF sCvcod ="" OR IsNull(sCvcod) THEN
		SetItem(1,"cvnas",snull)
		Return 1
	END IF

	If f_get_cvnames('1', sCvcod, scvnas, sarea, steam, sSaupj, sName1) <> 1 Then
		SetItem(1, 'cvcod', sNull)
		SetItem(1, 'cvnas', snull)
		Return 1
	ELSE
		SetItem(1,"cvnas",	scvnas)
	END IF
elseif this.GetcolumnName() = 'pritype'	then
	ls_pritype     = trim(this.gettext())
	ls_docno       = this.getitemstring(1,'docno')
	ll_seq         = this.getitemnumber(1,'docseq')
	ls_old_gubun   = this.getitemstring(1,'old_gubun')
	
	if gs_gubun = '2' then
		if ls_pritype <> ls_old_gubun then
//			p_save.enabled 		= false
//			p_save.PictureName = "c:\erpman\image\저장_d.gif"
			pb_3.enabled 		 = false
			pb_3.PictureName   = "c:\erpman\image\PRIOR_3.bmp"
			pb_4.enabled 		 = false
			pb_4.PictureName   = "c:\erpman\image\NEXT_3.bmp"
		end if	
	end if
	
	dw_2.reset()
	dw_3.reset()
	cbx_1.text = '전체선택'
	cbx_1.checked = false
	cbx_2.text = '전체선택'
	cbx_2.checked = false	
	if ls_pritype = '2' then //부서
		//권한등록 datawindow
		dw_3.retrieve(ls_docno, ll_seq) 
		dw_3.Modify("code_t.Text='부서코드'")
		dw_3.Modify("codename_t.Text='부서명'")
		
		//부서코드 조회
		dw_2.dataobject = 'd_adt_01270_vndmst'
		dw_2.settransobject(sqlca)
		dw_2.retrieve()	
	elseif ls_pritype = '4' then //개인
		//권한등록 datawindow
		dw_3.retrieve(ls_docno, ll_seq) 
		dw_3.Modify("code_t.Text='사원번호'")
		dw_3.Modify("codename_t.Text='사원명'")
		
		dw_2.dataobject = 'd_adt_01270_sawon'
		dw_2.settransobject(sqlca)
		dw_2.retrieve()	
	end if
END IF


end event

event rbuttondown;string colname, sdata, sjocod
long   lrow

gs_code = ''
gs_codename = ''
gs_gubun = ''

lrow = this.getrow()
if  this.getcolumnname() = "empno" then
	 open(w_sawon_popup)
	 if isnull(gs_code) or gs_code = "" then return
	 this.setitem(lrow, "empno", gs_code)
	 this.setitem(lrow, "empname", gs_codename)
	 this.triggerevent(itemchanged!) 	 
end if

if  this.getcolumnname() = "cvcod" then
	Open(w_vndmst_popup)
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	SetItem(1,"cvcod",gs_code)
	SetItem(1,"cvnas",gs_codename)
end if

end event

event clicked;string ls_path, ls_file

	
if dwo.type = 'button' then
	if GetFileOpenName('원본 파일을 선택하세요', ls_path, ls_file) = 1 then
		dw_add.setitem(1,'path',ls_path)
		is_path = ls_path 
		is_file = ls_file
		dw_add.setitem(1,'filename',ls_file)
	end if
end if	




end event

type rr_1 from roundrectangle within w_adt_01270_01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 196
integer width = 3685
integer height = 816
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_adt_01270_01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 1124
integer width = 1605
integer height = 1176
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_adt_01270_01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1902
integer y = 1124
integer width = 1833
integer height = 1176
integer cornerheight = 40
integer cornerwidth = 55
end type

