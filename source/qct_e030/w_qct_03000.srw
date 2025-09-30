$PBExportHeader$w_qct_03000.srw
$PBExportComments$VOC 등록
forward
global type w_qct_03000 from w_inherite
end type
type rb_new from radiobutton within w_qct_03000
end type
type rb_mod from radiobutton within w_qct_03000
end type
type dw_sel from datawindow within w_qct_03000
end type
type dw_lot from u_key_enter within w_qct_03000
end type
type p_1 from uo_picture within w_qct_03000
end type
type p_2 from uo_picture within w_qct_03000
end type
type rr_1 from roundrectangle within w_qct_03000
end type
type dw_1 from u_key_enter within w_qct_03000
end type
type pb_1 from u_pb_cal within w_qct_03000
end type
type pb_2 from u_pb_cal within w_qct_03000
end type
type p_3 from u_pb_cal within w_qct_03000
end type
type p_4 from u_pb_cal within w_qct_03000
end type
end forward

global type w_qct_03000 from w_inherite
boolean visible = false
integer width = 4654
integer height = 2496
string title = "VOC 등록"
windowstate windowstate = maximized!
rb_new rb_new
rb_mod rb_mod
dw_sel dw_sel
dw_lot dw_lot
p_1 p_1
p_2 p_2
rr_1 rr_1
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
p_3 p_3
p_4 p_4
end type
global w_qct_03000 w_qct_03000

type prototypes
FUNCTION long ShellExecuteA &
    (long hwnd, string lpOperation, &
    string lpFile, string lpParameters,  string lpDirectory, &
    integer nShowCmd ) LIBRARY "SHELL32" alias for "ShellExecuteA;Ansi"
end prototypes

type variables
string is_path, is_file
end variables

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
Long i, j
Real qty
String sdate, jpno

sdate = f_today() //시스템일자
jpno = String(SQLCA.FUN_JUNPYO(gs_sabu, sdate, 'E0'), "0000") //문서번호

//LOT No가 Null이고 QTY가 Null이면 삭제 
for i = dw_lot.RowCount() to 1 step -1 
	if (IsNull(Trim(dw_lot.object.cl_lotno[i])) or Trim(dw_lot.object.cl_lotno[i]) = "") and &
	   IsNull(dw_lot.object.cl_qty[i]) then
		dw_lot.DeleteRow(i)
	end if
next

for i = 1 to dw_lot.RowCount() 
	dw_lot.object.sabu[i] = gs_sabu
	if rb_new.checked = True then  //문서번호
	   dw_lot.object.cl_jpno[i] = sdate + jpno
	else
		dw_lot.object.cl_jpno[i] = Trim(dw_insert.object.cl_jpno[1])
	end if	
	dw_lot.object.cl_seq[i] = i
	if IsNull(Trim(dw_lot.object.cl_lotno[i])) or Trim(dw_lot.object.cl_lotno[i]) = "" then
		 dw_lot.object.cl_lotno[i] = "Unknown"
	end if

	if dw_lot.object.cl_lotno[i] < '.' or dw_lot.object.cl_lotno[i] > 'zzzzzz' then
    	MessageBox("LOT No 범위 확인","LOT No는 문자나 숫자를 입력하세요!")
		dw_lot.ScrollToRow(i) 
	   dw_lot.SetColumn('cl_lotno')
	   dw_lot.SetFocus()
	   return -1
	end if	
	
	if IsNull(dw_lot.object.cl_qty[i]) or dw_lot.object.cl_qty[i] <= 0 then
    	MessageBox("LOT No 확인(1)","LOT No는 적어도 하나 이상이 입력되어야 합니다")
		dw_lot.ScrollToRow(i) 
	   dw_lot.SetColumn('cl_qty')
	   dw_lot.SetFocus()
	   return -1
	end if	
next

dw_insert.object.sabu[1] = gs_sabu //사업장구분

if rb_new.checked = True then  //문서번호
	dw_insert.object.cl_jpno[1] = sdate + jpno
end if	

if Isnull(Trim(dw_insert.object.cl_jpno[1])) or Trim(dw_insert.object.cl_jpno[1]) = "" then
  	f_message_chk(1400,'[문서번호]')
	dw_insert.SetColumn('cl_jpno')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.daecod[1])) or Trim(dw_insert.object.daecod[1]) = "" then
  	f_message_chk(1400,'[거래처(판매처)]')
	dw_insert.SetColumn('daecod')
	dw_insert.SetFocus()
	return -1
//elseif Isnull(Trim(dw_insert.object.cust_no[1])) or Trim(dw_insert.object.cust_no[1]) = "" then
//  	f_message_chk(1400,'[고객번호]')
//	dw_insert.SetColumn('cust_no')
//	dw_insert.SetFocus()
//	return -1
elseif Isnull(Trim(dw_insert.object.snddtp[1])) or Trim(dw_insert.object.snddtp[1]) = "" then
  	f_message_chk(1400,'[접수부서]')
	dw_insert.SetColumn('snddtp')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.sndemp[1])) or Trim(dw_insert.object.sndemp[1]) = "" then
  	f_message_chk(1400,'[접수담당자]')
	dw_insert.SetColumn('sndemp')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.clrdat[1])) or Trim(dw_insert.object.clrdat[1]) = "" then
  	f_message_chk(1400,'[접수일자]')
	dw_insert.SetColumn('clrdat')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.qcrdat[1])) or Trim(dw_insert.object.qcrdat[1]) = "" then
  	f_message_chk(1400,'[발송일자]')
	dw_insert.SetColumn('qcrdat')
	dw_insert.SetFocus()
	return -1
elseif Isnull(Trim(dw_insert.object.itnbr[1])) or Trim(dw_insert.object.itnbr[1]) = "" then
  	f_message_chk(1400,'[품번]')
	dw_insert.SetColumn('itnbr')
	dw_insert.SetFocus()
	return -1
elseif Isnull(dw_insert.object.clqty[1]) or dw_insert.object.clqty[1] <= 0 then
  	f_message_chk(1400,'[수량]')
	dw_insert.SetColumn('clqty')
	dw_insert.SetFocus()
	return -1
end if	

return 1
end function

on w_qct_03000.create
int iCurrent
call super::create
this.rb_new=create rb_new
this.rb_mod=create rb_mod
this.dw_sel=create dw_sel
this.dw_lot=create dw_lot
this.p_1=create p_1
this.p_2=create p_2
this.rr_1=create rr_1
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.p_3=create p_3
this.p_4=create p_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_new
this.Control[iCurrent+2]=this.rb_mod
this.Control[iCurrent+3]=this.dw_sel
this.Control[iCurrent+4]=this.dw_lot
this.Control[iCurrent+5]=this.p_1
this.Control[iCurrent+6]=this.p_2
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.p_3
this.Control[iCurrent+12]=this.p_4
end on

on w_qct_03000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_new)
destroy(this.rb_mod)
destroy(this.dw_sel)
destroy(this.dw_lot)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.p_3)
destroy(this.p_4)
end on

event open;call super::open;dw_1.SetTransObject(SQLCA)
dw_sel.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)
dw_lot.SetTransObject(SQLCA)

dw_1.Setredraw(False)
dw_1.ReSet()
dw_1.InsertRow(0)
dw_1.Setredraw(True)

dw_sel.ReSet()
dw_lot.ReSet()

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)

String is_ispec, is_jijil
IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_insert.object.ispec_t.text = is_ispec
	dw_insert.object.jijil_t.text = is_jijil
END IF

dw_insert.Setredraw(True)
dw_1.SetFocus()

rb_new.Checked = True
rb_new.TriggerEvent(Clicked!)
end event

type dw_insert from w_inherite`dw_insert within w_qct_03000
integer x = 64
integer y = 692
integer width = 4530
integer height = 1624
integer taborder = 40
boolean enabled = false
string dataobject = "d_qct_03000_03"
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemchanged;String  s_cod, s_nam1, s_nam2, s_nam3, s_nam4 , sjijil, sitnbr, sitdsc, sispec, sispec_code
Integer i_rtn, ireturn
dec{2}  dItemPrice, dqty

s_cod = Trim(this.getText())

if (this.GetColumnName() = "cl_jpno") Then //문서번호
	dw_insert.SetRedraw(False)
	if dw_insert.Retrieve(gs_sabu, s_cod) < 1 then
	   dw_insert.Reset()
		dw_insert.InsertRow(0)
		dw_lot.Reset()
		rb_new.TriggerEvent(Clicked!)
		rb_new.checked = True
		w_mdi_frame.sle_msg.text = "등록된 자료가 없습니다! 신규로 등록하세요!"
   else
		dw_lot.Retrieve(gs_sabu, s_cod)
		
		dw_insert.object.cl_jpno_t.visible = True
      dw_insert.object.cl_jpno.visible = True 
	   rb_mod.checked = True
		if dw_insert.object.clsts[1] = "2" then
			dw_insert.Enabled = False
			dw_lot.Enabled = False
			p_del.Enabled = False
			w_mdi_frame.sle_msg.Text = "이미 완료처리된 자료입니다![수정불가능]"
		else
			p_del.Enabled = True
			dw_insert.Enabled = True
			dw_lot.Enabled = True
		end if	
   end if	
	dw_insert.SetRedraw(True)
elseif (this.GetColumnName() = "daecod") Then //대리점
	i_rtn = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
	this.object.daecod[1] = s_cod
	this.object.daename[1] = s_nam1
	return i_rtn
//elseif (this.GetColumnName() = "cust_no") Then //고객번호
//	i_rtn = f_get_name2("C0", "Y", s_cod, s_nam1, s_nam2)
//	this.object.cust_no[1] = s_cod
//	this.object.cust_name[1] = s_nam1
//	return i_rtn
elseif (this.GetColumnName() = "clrdat") Then //접수일자
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[접수일자]")
		this.setitem(1, 'clrdat', '')
		return 1
	end if
elseif (this.GetColumnName() = "qcrdat") Then //QC발송일
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[발송일자]")
		this.setitem(1, 'qcrdat', '')
		return 1
	end if
elseif (this.GetColumnName() = "snddtp") Then //접수부서
	i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
	this.object.snddtp[1] = s_cod
	this.object.dptname[1] = s_nam1
	return i_rtn
elseif (this.GetColumnName() = "sndemp") Then //접수담당자
	i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
	this.object.sndemp[1] = s_cod
	this.object.empname[1] = s_nam1
	return i_rtn
elseif (this.GetColumnName() = "itnbr") Then //품번
	i_rtn = f_get_name4("품번", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	this.object.itnbr[1] = s_cod
	this.object.itdsc[1] = s_nam1
	this.object.ispec[1] = s_nam2
//	this.object.jijil[1] = s_nam3
//	this.object.ispec_code[1] = s_nam4
	if s_cod > '.' then 
		dItemPrice = sqlca.Fun_Erp100000012(is_today, s_cod, '.') 
		dQty       = this.GetItemDecimal(1, "clqty")
		if isnull(dqty) then dqty = 0
		if isnull(dItemPrice) then dItemPrice = 0
		
		this.SetItem(1, "clamst_gongprc", dItemPrice)
		this.SetItem(1, "clamst_reprc", truncate(dqty * ditemprice, 0))
	else
		this.SetItem(1, "clamst_gongprc", 0)
		this.SetItem(1, "clamst_reprc", 0)
   end if
	return i_rtn
elseif (this.GetColumnName() = "itdsc") Then //품명
   s_nam1 = Trim(this.getText())	
	i_rtn = f_get_name4("품명", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
   this.object.itnbr[1] = s_cod
	this.object.itdsc[1] = s_nam1
	this.object.ispec[1] = s_nam2
//	this.object.jijil[1] = s_nam3
//	this.object.ispec_code[1] = s_nam4
	if s_cod > '.' then 
		dItemPrice = sqlca.Fun_Erp100000012(is_today, s_cod, '.') 
		dQty       = this.GetItemDecimal(1, "clqty")
		if isnull(dqty) then dqty = 0
		if isnull(dItemPrice) then dItemPrice = 0
		
		this.SetItem(1, "clamst_gongprc", dItemPrice)
		this.SetItem(1, "clamst_reprc", truncate(dqty * ditemprice, 0))
	else
		this.SetItem(1, "clamst_gongprc", 0)
		this.SetItem(1, "clamst_reprc", 0)
   end if
	return i_rtn
elseif (this.GetColumnName() = "ispec") Then //규격
   s_nam2 = Trim(this.getText())		
	i_rtn = f_get_name4("규격", "Y", s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
   this.object.itnbr[1] = s_cod
	this.object.itdsc[1] = s_nam1
	this.object.ispec[1] = s_nam2
//	this.object.jijil[1] = s_nam3
//	this.object.ispec_code[1] = s_nam4
	if s_cod > '.' then 
		dItemPrice = sqlca.Fun_Erp100000012(is_today, s_cod, '.') 
		dQty       = this.GetItemDecimal(1, "clqty")
		if isnull(dqty) then dqty = 0
		if isnull(dItemPrice) then dItemPrice = 0
		
		this.SetItem(1, "clamst_gongprc", dItemPrice)
		this.SetItem(1, "clamst_reprc", truncate(dqty * ditemprice, 0))
	else
		this.SetItem(1, "clamst_gongprc", 0)
		this.SetItem(1, "clamst_reprc", 0)
   end if
	return i_rtn
	

//ELSEIF this.GetColumnName() = "jijil"	THEN  // 재질
//	sjijil = trim(this.GetText())
//	ireturn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
//	this.setitem(1, "itnbr", sitnbr)	
//	this.setitem(1, "itdsc", sitdsc)	
//	this.setitem(1, "ispec", sispec)
//	this.setitem(1, "ispec_code", sispec_code)
//	this.setitem(1, "jijil", sjijil)
//	if sitnbr > '.' then 
//		dItemPrice = sqlca.Fun_Erp100000012(is_today, s_cod, '.') 
//		dQty       = this.GetItemDecimal(1, "clqty")
//		if isnull(dqty) then dqty = 0
//		if isnull(dItemPrice) then dItemPrice = 0
//		
//		this.SetItem(1, "clamst_gongprc", dItemPrice)
//		this.SetItem(1, "clamst_reprc", truncate(dqty * ditemprice, 0))
//	else
//		this.SetItem(1, "clamst_gongprc", 0)
//		this.SetItem(1, "clamst_reprc", 0)
//   end if
//	RETURN ireturn
//	
//ELSEIF this.GetColumnName() = "ispec_code"	THEN  // 규격코드 
//	sispec_code = trim(this.GetText())
//
//	ireturn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, sispec_code)	
//	this.setitem(1, "itnbr", sitnbr)	
//	this.setitem(1, "itdsc", sitdsc)	
//	this.setitem(1, "ispec", sispec)
//	this.setitem(1, "ispec_code", sispec_code)
//	this.setitem(1, "jijil", sjijil)
//	if sitnbr > '.' then 
//		dItemPrice = sqlca.Fun_Erp100000012(is_today, s_cod,'.') 
//		dQty       = this.GetItemDecimal(1, "clqty")
//		if isnull(dqty) then dqty = 0
//		if isnull(dItemPrice) then dItemPrice = 0
//		
//		this.SetItem(1, "clamst_gongprc", dItemPrice)
//		this.SetItem(1, "clamst_reprc", truncate(dqty * ditemprice, 0))
//	else
//		this.SetItem(1, "clamst_gongprc", 0)
//		this.SetItem(1, "clamst_reprc", 0)
//   end if
//	RETURN ireturn
	
elseif this.GetColumnName() = "clqty" Then 
   dQty = Dec(this.getText())		
	dItemPrice = this.GetItemDecimal(1, "clamst_gongprc")
	
	if isnull(dqty) then dqty = 0
	if isnull(dItemPrice) then dItemPrice = 0
	this.SetItem(1, "clamst_reprc", truncate(dqty * ditemprice, 0))
	
elseif this.GetColumnName() = "clamst_gongprc" Then 
   dItemPrice = Dec(this.getText())		
	dQty = this.GetItemDecimal(1, "clqty")
	
	if isnull(dqty) then dqty = 0
	if isnull(dItemPrice) then dItemPrice = 0
	this.SetItem(1, "clamst_reprc", truncate(dqty * ditemprice, 0))
	
end if

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if (this.GetColumnName() = "cl_jpno") Then //문서번호
	open(w_claimno_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.cl_jpno[1] = gs_code
   this.TriggerEvent(itemchanged!)
elseif	this.getcolumnname() = "daecod" then //대리점
	open(w_vndmst_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.daecod[1] = gs_code
	this.object.daename[1] = gs_codename
//elseif this.getcolumnname() = "cust_no" then //고객번호
//	open(w_cust_popup)
//	if gs_code = '' or isnull(gs_code) then return 
//	this.object.cust_no[1] = gs_code
//	this.object.cust_name[1] = gs_codename
elseif this.getcolumnname() = "snddtp" then //접수부서
	open(w_vndmst_4_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.snddtp[1] = gs_code
	this.object.dptname[1] = gs_codename
elseif this.getcolumnname() = "sndemp" then //접수담당자
	open(w_sawon_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.sndemp[1] = gs_code
	this.object.empname[1] = gs_codename
elseif this.getcolumnname() = "itnbr"  then //품번
	open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.itnbr[1] = gs_code
   this.TriggerEvent(itemchanged!)
end if

end event

event dw_insert::ue_key;call super::ue_key;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if keydown(keyF2!) THEN
	if This.GetColumnName() = "itnbr" or &
      this.getcolumnname() = "itdsc" or this.getcolumnname() = "ispec" then //품번,품명,규격
		open(w_itemas_popup2)
		this.object.itnbr[1] = gs_code
		this.object.itdsc[1] = gs_codename
		this.object.ispec[1] = gs_gubun
		return
	end if
end if		
end event

event dw_insert::ue_pressenter;if this.GetColumnName() = "muntxt" OR this.GetColumnName() = "wontxt" then return

Send(Handle(this),256,9,0)
Return 1
end event

event dw_insert::itemfocuschanged;if this.GetColumnName() = "muntxt" then
	f_toggle_kor(Handle(this))
else
	f_toggle_eng(Handle(this))
end if
end event

event dw_insert::clicked;call super::clicked;string ls_path, ls_file, ls_file_name, ls_Null, ls_jpno,ls_nm
blob   b_data, b_data2
long   i, ll_seq, ll_new_pos, ll_flen, ll_bytes_read, ll_rc, ll_cnt
int    li_fp, li_loops, li_complete, li_rc

setnull(ls_Null)	
ls_jpno = this.getitemstring(1,'cl_jpno')

if dwo.type = 'button' then
	if dwo.name = 'b_1' then //경로
		if GetFileOpenName('원본 파일을 선택하세요', ls_path, ls_file) = 1 then
			dw_insert.setitem(1,'ann_path',ls_path)
			is_path = ls_path 
			is_file = ls_file
			dw_insert.setitem(1,'ann_filenm',ls_file)
		end if
	elseif dwo.name = 'b_2' then //파일조회
		
		ls_path = 'c:\erpman\doc' 	
		if not directoryexists(ls_path) then 
			createdirectory(ls_path) 
		End if 
		
		//파일이름
		select ann_filenm into :ls_file_name
 	     from clamst_doc
	    where sabu    = :gs_sabu
		   and cl_jpno = :ls_jpno;
		if ls_file_name = '' or isnull(ls_file_name) then
			messagebox('확인','파일이 존재하지 않습니다.')
			return
		end if	
		
		//문서파일
		selectblob ann_file into :b_data
				from clamst_doc
			  where sabu    = :gs_sabu
				 and cl_jpno = :ls_jpno;
				 
		If IsNull(b_data) Then
			messagebox('확인',ls_file_name +' DownLoad할 자료가 없습니다.~r~n시스템 담당자에게 문의하십시오.')
			return
		End If		
			IF SQLCA.SQLCode = 0 AND Not IsNull(b_data) THEN
				ls_file_name = ls_path + '\' + ls_file_name
				li_fp = FileOpen(trim(ls_file_name) , StreamMode!, Write!, LockWrite!, replace!)
		
				ll_new_pos 	= 1
				li_loops 	= 0
				ll_flen 		= 0
		
				IF li_fp = -1 or IsNull(li_fp) then
					messagebox('확인',ls_path + ' Folder가 존재치 않거나 사용중인 자료입니다.')
				Else
					ll_flen = len(b_data)
					
					if ll_flen > 32765 then
						if mod(ll_flen,32765) = 0 then
							li_loops = ll_flen / 32765
						else
							li_loops = (ll_flen/32765) + 1
						end if
					else
						li_loops = 1
					end if
		
					if li_loops = 1 then 
						ll_bytes_read = filewrite(li_fp,b_data)
						Yield()					
					else
						for i = 1 to li_loops
							if i = li_loops then
								b_data2 = blobmid(b_data,ll_new_pos)
							else
								b_data2 = blobmid(b_data,ll_new_pos,32765)
							end if
							ll_bytes_read = filewrite(li_fp,b_data2)
							ll_new_pos = ll_new_pos + ll_bytes_read
		
							Yield()
							li_complete = ( (32765 * i ) / len(b_data)) * 100
						next
							Yield()
					end if
					
					li_rc = 0 
					
					FileClose(li_fp)
				END IF
			END IF
		//==[프로그램 실행/다운완료후]
		ll_rc = ShellExecuteA(handle(parent), 'open', ls_file_name, ls_Null, ls_Null, 1)
		return
	elseif dwo.name = 'b_3' then //파일삭제	
		if trim(ls_jpno) = '' or isnull(ls_jpno) then
			messagebox('선택', '문서번호가 존재하지 않습니다.~n 조회후 작업이 가능합니다.')
			return
		end if
		
	   //문서 존재여부
	   select count(*) into :ll_cnt
		  from clamst_doc
	 	 where sabu     = :gs_sabu
		   and cl_jpno  = :ls_jpno;
			  
  		 if ll_cnt = 0 then
			messagebox('확인','삭제할 자료가 존재하지 않습니다.' ) 
			return
		 else
			select re_filenm into :ls_nm
			  from clamst_doc
			 where sabu     = :gs_sabu
				and cl_jpno  = :ls_jpno;
			  
			 if isnull(ls_nm)  then //대책서가 존재하지 않을경우 삭제
				delete from clamst_doc where sabu = :gs_sabu and cl_jpno  = :ls_jpno;
				if sqlca.sqlcode = 0 then
					messagebox('확인','첨부 자료가 삭제되었습니다.') 
					commit;
				else
					messagebox('확인2[DELETE]','첨부 자료삭제 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					rollback;
					return
				end if	
			 else	//대책서가 존재할경우 의뢰파일만 UPDATE
				//파일명,등록자update
				Update clamst_doc
					set ann_filenm = null,
						 ann_empno  = null
				 where sabu     = :gs_sabu
					and cl_jpno  = :ls_jpno;						
				if sqlca.sqlcode = 0 then
					messagebox('확인','첨부 자료가 삭제되었습니다.') 
					commit;
				else
					messagebox('확인1[DELETE]','첨부 자료삭제 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					rollback;
					return
				end if	
			
//			 //파일 update
//			 UpdateBlob clamst_doc
//				 set ann_file = Space(0)
//			  where sabu     = :gs_sabu
//				 and cl_jpno  = :ls_jpno;						
//			if sqlca.sqlcode = 0 then
//				messagebox('확인','첨부 자료가 삭제되었습니다.') 
//				commit;
//			else
//				messagebox('확인2[DELETE]','첨부 자료삭제 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
//				rollback;
//				return
//			end if	
        end if
		 end if
	end if	
end if	


end event

type p_delrow from w_inherite`p_delrow within w_qct_03000
boolean visible = false
integer x = 3680
integer y = 3524
integer taborder = 0
string picturename = "C:\erpman\image\up.gif"
end type

type p_addrow from w_inherite`p_addrow within w_qct_03000
boolean visible = false
integer x = 3502
integer y = 3520
integer taborder = 0
string picturename = "C:\erpman\image\up.gif"
end type

type p_search from w_inherite`p_search within w_qct_03000
boolean visible = false
integer x = 3374
integer y = 2420
integer taborder = 0
string picturename = "C:\erpman\image\등록_up.gif"
end type

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\등록_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\등록_up.gif"
end event

type p_ins from w_inherite`p_ins within w_qct_03000
integer x = 3177
integer y = 2464
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qct_03000
integer x = 4425
integer taborder = 90
end type

type p_can from w_inherite`p_can within w_qct_03000
integer x = 4251
integer taborder = 80
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

p_inq.TriggerEvent(Clicked!)


end event

type p_print from w_inherite`p_print within w_qct_03000
boolean visible = false
integer x = 3927
integer y = 3372
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_03000
integer x = 3730
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;String sdate, edate, daecod, cust_no

if dw_1.AcceptText() = -1 then 
	dw_1.SetFocus()
	return
end if	

sdate = Trim(dw_1.object.sdate[1])
edate = Trim(dw_1.object.edate[1])
daecod = Trim(dw_1.object.daecod[1])

if IsNull(sdate) or sdate = "" then sdate = "10000101"
if IsNull(edate) or edate = "" then edate = "99991231"
if IsNull(daecod) or daecod = "" then 
	daecod = "%"
else
	daecod = daecod + "%"
end if	


if dw_sel.Retrieve(gs_sabu, sdate, edate, daecod) < 1 then
	w_mdi_frame.sle_msg.text = "등록된 자료가 없습니다! 신규로 등록하세요!"
	rb_new.checked = True
else	
	w_mdi_frame.sle_msg.text = ""
end if	

if rb_new.checked = True then
	rb_new.TriggerEvent(Clicked!)
else
	rb_mod.TriggerEvent(Clicked!)
end if	




end event

type p_del from w_inherite`p_del within w_qct_03000
integer x = 4078
integer taborder = 70
end type

event p_del::clicked;call super::clicked;String s_cod

if f_msg_delete() = -1 then return

if dw_insert.object.clsts[1] = "2" then
	MessageBox("처리완료된 자료", "VOC 결과등록 완료된 자료는 삭제할 수 없습니다.")
	return
end if

s_cod = dw_insert.object.cl_jpno[1]
if IsNull(s_cod) or s_cod = "" then
	MessageBox("문서번호 확인", "문서번호를 확인하세요.")
	return
end if

delete from clamst where sabu = :gs_sabu and cl_jpno = :s_cod;
if sqlca.sqlcode <> 0 then
	ROLLBACK;
   f_message_chk(32, "[삭제실패]")
	w_mdi_frame.sle_msg.Text = "삭제작업 실패!"
	return
end if	

delete from clamst_lot where sabu = :gs_sabu and cl_jpno = :s_cod;
if sqlca.sqlcode <> 0 then
	ROLLBACK;
   f_message_chk(32, "[Lot 삭제실패]")
	w_mdi_frame.sle_msg.Text = "삭제작업 실패!"
	return
end if	

COMMIT;
w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"

p_inq.TriggerEvent(Clicked!)
end event

type p_mod from w_inherite`p_mod within w_qct_03000
integer x = 3904
integer taborder = 60
end type

event p_mod::clicked;call super::clicked;string ls_file, ls_path, ls_jpno, ls_filenm
long   ll_cnt

if dw_insert.AcceptText() = -1 then return 
if dw_lot.AcceptText() = -1 then return 

if f_msg_update() = -1 then return

if wf_required_chk() = -1 then return //필수입력항목 체크 

ls_jpno = dw_insert.getitemstring(1,'cl_jpno')
IF dw_insert.Update() > 0 THEN	
	if dw_lot.Update() > 0 then
		//의뢰문서저장
		ls_file 		= upper(is_file)
	   ls_path     = upper(is_path) 
		
		if ls_path <> '' and not(isnull(is_path)) then
			ls_filenm = dw_insert.getitemstring(1,'ann_filenm')
			//////////////////////////////////////////
			// 선택한 FILE을 READ하여 DB에 UPDATE
			//////////////////////////////////////////
			integer 	li_FileNum, loops, i
			long 		flen, bytes_read, new_pos
			blob 		b, tot_b
			
		  //문서 저장
		  select count(*) into :ll_cnt
			 from clamst_doc
			where sabu     = :gs_sabu
			  and cl_jpno  = :ls_jpno;
			  
			if ll_cnt = 0 then
				insert into clamst_doc 
						  (sabu, cl_jpno, ann_filenm, ann_empno)
				 values (:gs_sabu, :ls_jpno, :ls_filenm, :gs_empno) ;
				if sqlca.sqlcode = 0 then
					commit;
				else
					messagebox('확인[INSERT]','첨부 자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					rollback;
					return
				end if	
			else
				update clamst_doc
				   set ann_filenm = :ls_filenm
				 where sabu     = :gs_sabu
				   and cl_jpno  = :ls_jpno;				
				if sqlca.sqlcode = 0 then
					commit;
				else
					messagebox('확인[UPDATE]','첨부 자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
					rollback;
					return
				end if	
			end if	
			
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
						
			//Blob 저장
			UpdateBlob clamst_doc
					 set ann_file = :tot_b
				  where sabu     = :gs_sabu
				    and cl_jpno  = :ls_jpno;
					 
			If SQLCA.SQLCODE <> 0 Then
				messagebox('확인','자료저장 중 오류가 발생 했습니다.' + SQLCA.SQLERRTEXT) 
				ROLLBACK USING SQLCA	;
				Return
			End if				
											
			COMMIT USING SQLCA	;
				
			w_mdi_frame.sle_msg.text ="문서가 추가등록 되었습니다!"
		end if	
		///////////////////////////////////////////////////
		
	   COMMIT;
	   w_mdi_frame.sle_msg.Text = "저장 되었습니다!"
	   p_inq.TriggerEvent(Clicked!)
	else
		ROLLBACK;
   	f_message_chk(32, "[저장실패]")
	   w_mdi_frame.sle_msg.Text = "저장작업 실패!"
	end if	
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	w_mdi_frame.sle_msg.Text = "저장작업 실패!"
END IF

ib_any_typing = False //입력필드 변경여부 No

end event

type cb_exit from w_inherite`cb_exit within w_qct_03000
integer x = 2825
integer y = 3288
end type

type cb_mod from w_inherite`cb_mod within w_qct_03000
integer x = 1783
integer y = 3288
end type

type cb_ins from w_inherite`cb_ins within w_qct_03000
integer x = 846
integer y = 2788
end type

type cb_del from w_inherite`cb_del within w_qct_03000
integer x = 2130
integer y = 3288
end type

type cb_inq from w_inherite`cb_inq within w_qct_03000
integer x = 1435
integer y = 3292
end type

type cb_print from w_inherite`cb_print within w_qct_03000
end type

type st_1 from w_inherite`st_1 within w_qct_03000
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_qct_03000
integer x = 2478
integer y = 3288
end type

type cb_search from w_inherite`cb_search within w_qct_03000
integer x = 1230
integer y = 2792
end type



type sle_msg from w_inherite`sle_msg within w_qct_03000
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_qct_03000
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_03000
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_03000
end type

type rb_new from radiobutton within w_qct_03000
integer x = 4178
integer y = 824
integer width = 315
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "등   록"
end type

event clicked;p_del.Enabled = False

p_1.Enabled = True
p_2.Enabled = True
p_3.Enabled = True
p_4.Enabled = True
		
dw_lot.Enabled = True
dw_lot.ReSet()

dw_insert.Enabled = True
dw_insert.modify("cl_jpno.protect = 0")
dw_insert.modify("daecod.protect = 0")
dw_insert.modify("snddtp.protect = 0")
dw_insert.modify("sndemp.protect = 0")
dw_insert.modify("clsts.protect = 0")
dw_insert.modify("clrdat.protect = 0")
dw_insert.modify("clamst_result_cust.protect = 0")
dw_insert.modify("clevel.protect = 0")
dw_insert.modify("clamst_measure.protect = 0")
dw_insert.modify("qcrdat.protect = 0")
dw_insert.modify("clamst_accept.protect = 0")
dw_insert.modify("clamst_importance.protect = 0")
dw_insert.modify("itnbr.protect = 0")
dw_insert.modify("clamst_gongprc.protect = 0")
dw_insert.modify("clqty.protect = 0")
dw_insert.modify("itdsc.protect = 0")
dw_insert.modify("ispec.protect = 0")
dw_insert.modify("clamst_reprc.protect = 0")
dw_insert.modify("wontxt.protect = 0")
		
dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)
dw_insert.object.cl_jpno_t.visible = False
dw_insert.object.cl_jpno.visible = False
dw_insert.SetColumn("daecod")
dw_insert.SetFocus()

ib_any_typing = False //입력필드 변경여부 No
end event

type rb_mod from radiobutton within w_qct_03000
integer x = 4178
integer y = 928
integer width = 315
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "수   정"
boolean checked = true
end type

event clicked;p_del.Enabled = False

dw_lot.Enabled = True
dw_lot.ReSet()

dw_insert.Enabled = True
dw_insert.SetRedraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)
dw_insert.object.cl_jpno_t.visible = True
dw_insert.object.cl_jpno.visible = True
dw_insert.SetColumn("cl_jpno")
dw_insert.SetFocus()

ib_any_typing = False //입력필드 변경여부 No
end event

type dw_sel from datawindow within w_qct_03000
integer x = 1280
integer y = 220
integer width = 3314
integer height = 444
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_qct_03000_02"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;this.SelectRow(0,False)

if Row <= 0 then return
this.SelectRow(Row,TRUE)
if dw_insert.Retrieve(gs_sabu, Trim(this.object.cl_jpno[Row])) < 1 then
   dw_insert.Enabled = True
	p_del.Enabled = False
	rb_new.checked = True
else
	rb_mod.checked = True	
	dw_insert.object.cl_jpno_t.visible = True
   dw_insert.object.cl_jpno.visible = True
	
	dw_lot.Retrieve(gs_sabu, Trim(this.object.cl_jpno[Row]))
	
	if dw_insert.object.clsts[1] = "1" then
		p_1.Enabled = True
		p_2.Enabled = True
		p_3.Enabled = True
		p_4.Enabled = True
		
		p_del.Enabled = True

		dw_insert.Enabled = True
		dw_insert.modify("cl_jpno.protect = 0")
		dw_insert.modify("daecod.protect = 0")
		dw_insert.modify("snddtp.protect = 0")
		dw_insert.modify("sndemp.protect = 0")
		dw_insert.modify("clsts.protect = 0")
		dw_insert.modify("clrdat.protect = 0")
		dw_insert.modify("clamst_result_cust.protect = 0")
		dw_insert.modify("clevel.protect = 0")
		dw_insert.modify("clamst_measure.protect = 0")
		dw_insert.modify("qcrdat.protect = 0")
		dw_insert.modify("clamst_accept.protect = 0")
		dw_insert.modify("clamst_importance.protect = 0")
		dw_insert.modify("itnbr.protect = 0")
		dw_insert.modify("clamst_gongprc.protect = 0")
		dw_insert.modify("clqty.protect = 0")
		dw_insert.modify("itdsc.protect = 0")
		dw_insert.modify("ispec.protect = 0")
		dw_insert.modify("clamst_reprc.protect = 0")
		dw_insert.modify("wontxt.protect = 0")
		
		dw_lot.Enabled = True
		dw_insert.SetColumn("cl_jpno")
      dw_insert.SetFocus()
		w_mdi_frame.sle_msg.Text = ""
	else
		p_1.Enabled = False
		p_2.Enabled = False
		p_3.Enabled = False
		p_4.Enabled = False
		
		p_del.Enabled = False
		
////		dw_insert.Enabled = False
		dw_insert.modify("cl_jpno.protect = 1")
		dw_insert.modify("daecod.protect = 1")
		dw_insert.modify("snddtp.protect = 1")
		dw_insert.modify("sndemp.protect = 1")
		dw_insert.modify("clsts.protect = 1")
		dw_insert.modify("clrdat.protect = 1")
		dw_insert.modify("clamst_result_cust.protect = 1")
		dw_insert.modify("clevel.protect = 1")
		dw_insert.modify("clamst_measure.protect = 1")
		dw_insert.modify("qcrdat.protect = 1")
		dw_insert.modify("clamst_accept.protect = 1")
		dw_insert.modify("clamst_importance.protect = 1")
		dw_insert.modify("itnbr.protect = 1")
		dw_insert.modify("clamst_gongprc.protect = 1")
		dw_insert.modify("clqty.protect = 1")
		dw_insert.modify("itdsc.protect = 1")
		dw_insert.modify("ispec.protect = 1")
		dw_insert.modify("clamst_reprc.protect = 1")
		dw_insert.modify("wontxt.protect = 1")
		
		dw_lot.Enabled = False
		messagebox("알림","[완료처리된 자료]담당 소견만 수정가능 합니다!")
		dw_insert.SetColumn("muntxt")
      dw_insert.SetFocus()
		w_mdi_frame.sle_msg.Text = "이미 완료처리된 자료입니다![담당 소견만 수정가능]"
	end if	
end if	

ib_any_typing = False //입력필드 변경여부 No
end event

type dw_lot from u_key_enter within w_qct_03000
integer x = 110
integer y = 1488
integer width = 1435
integer height = 640
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_qct_03000_04"
boolean vscrollbar = true
end type

event itemerror;return 1
end event

event rowfocuschanged;//this.SetRowFocusIndicator(HAND!)
end event

type p_1 from uo_picture within w_qct_03000
integer x = 105
integer y = 2132
integer width = 178
integer taborder = 100
boolean bringtotop = true
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event clicked;call super::clicked;Integer iCurRow

iCurRow = dw_lot.GetRow()

dw_lot.InsertRow(iCurRow + 1)

dw_lot.ScrollToRow(iCurRow + 1)

dw_lot.SetFocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_2 from uo_picture within w_qct_03000
integer x = 279
integer y = 2132
integer width = 178
integer taborder = 110
boolean bringtotop = true
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event clicked;call super::clicked;if dw_lot.GetRow() < 1 then 
	MessageBox("자료선택","삭제하고자 하는 LOT NO을 선택한 다음 진행하세요!")
	return
end if	
if f_msg_delete() = 1 then 
   dw_lot.DeleteRow(dw_lot.GetRow())
end if	

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type rr_1 from roundrectangle within w_qct_03000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1271
integer y = 212
integer width = 3333
integer height = 464
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from u_key_enter within w_qct_03000
event ue_key pbm_dwnkey
integer x = 59
integer y = 204
integer width = 1175
integer height = 476
integer taborder = 10
string dataobject = "d_qct_03000_01"
boolean border = false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;String  s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" Then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" Then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif (this.GetColumnName() = "daecod") Then //대리점
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.object.daecod[1] = s_cod
	this.object.daename[1] = s_nam1
	return i_rtn
//elseif (this.GetColumnName() = "cust_no") Then //고객번호
//	i_rtn = f_get_name2("C0", "N", s_cod, s_nam1, s_nam2)
//	this.object.cust_no[1] = s_cod
//	this.object.cust_name[1] = s_nam1
//	return i_rtn
end if
end event

event itemerror;return 1
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if	this.getcolumnname() = "daecod" then //대리점
	open(w_vndmst_popup)
	this.object.daecod[1] = gs_code
	this.object.daename[1] = gs_codename
	return
//elseif this.getcolumnname() = "cust_no" then //고객번호
//	open(w_cust_popup)
//   this.object.cust_no[1] = gs_code
//   this.object.cust_name[1] = gs_codename
//	return
end if	
end event

type pb_1 from u_pb_cal within w_qct_03000
integer x = 690
integer y = 312
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_03000
integer x = 1088
integer y = 312
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'edate', gs_code)
end event

type p_3 from u_pb_cal within w_qct_03000
integer x = 2423
integer y = 832
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('clrdat')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'clrdat', gs_code)
end event

type p_4 from u_pb_cal within w_qct_03000
integer x = 3758
integer y = 832
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('qcrdat')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'qcrdat', gs_code)
end event

