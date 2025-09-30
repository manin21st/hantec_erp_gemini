$PBExportHeader$w_qct_01090.srw
$PBExportComments$** 이상발생통보등록
forward
global type w_qct_01090 from w_inherite
end type
type rb_new from radiobutton within w_qct_01090
end type
type rb_mod from radiobutton within w_qct_01090
end type
type dw_ins from u_key_enter within w_qct_01090
end type
type st_3 from statictext within w_qct_01090
end type
type cb_1 from commandbutton within w_qct_01090
end type
type p_1 from uo_picture within w_qct_01090
end type
type pb_2 from u_pb_cal within w_qct_01090
end type
type rr_1 from roundrectangle within w_qct_01090
end type
type rr_2 from roundrectangle within w_qct_01090
end type
end forward

global type w_qct_01090 from w_inherite
string title = "이상발생 통보등록"
rb_new rb_new
rb_mod rb_mod
dw_ins dw_ins
st_3 st_3
cb_1 cb_1
p_1 p_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_qct_01090 w_qct_01090

forward prototypes
public function integer wf_required_chk ()
public subroutine wf_get_jego (string gubun, string itnbr)
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
String sdate, jpno, sIttyp, sItnbr

if dw_insert.AcceptText() = -1 then return -1
if dw_ins.AcceptText() = -1 then return -1

sdate = f_today() //시스템일자
jpno = String(SQLCA.FUN_JUNPYO(gs_sabu, sdate, 'H0'), "0000") //의뢰번호
if rb_new.Checked = True then
	jpno = sdate + jpno
else
	jpno = Trim(dw_insert.object.occjpno[1])
end if

if IsNull(jpno) or jpno = "" then
	f_message_chk(30, "[문서번호]")
	return -1
end if	

dw_insert.object.sabu[1] = gs_sabu
dw_insert.object.occjpno[1] = jpno

if IsNull(Trim(dw_insert.object.occdat[1])) or Trim(dw_insert.object.occdat[1]) = "" then
	f_message_chk(30, "[발생일자]")
	dw_insert.setcolumn('occdat')
	dw_insert.setfocus()
	return -1
end if	

if IsNull(Trim(dw_insert.object.occtime[1])) or Trim(dw_insert.object.occtime[1]) = "" then
	f_message_chk(30, "[발생시간]")
	dw_insert.setcolumn('occtime')
	dw_insert.setfocus()
	return -1
end if	

if IsNull(Trim(dw_insert.object.occtitle[1])) or Trim(dw_insert.object.occtitle[1]) = "" then
	f_message_chk(30, "[건명]")
	dw_insert.setcolumn('occtitle')
	dw_insert.setfocus()
	return -1
end if

if IsNull(Trim(dw_insert.object.snddpt[1])) or Trim(dw_insert.object.snddpt[1]) = "" then
	f_message_chk(30, "[발견부서]")
	dw_insert.setcolumn('snddpt')
	dw_insert.setfocus()
	return -1
end if	
if IsNull(Trim(dw_insert.object.sndemp[1])) or Trim(dw_insert.object.sndemp[1]) = "" then
	f_message_chk(30, "[발견자]")
	dw_insert.setcolumn('sndemp')
	dw_insert.setfocus()
	return -1
end if	
if IsNull(Trim(dw_insert.object.pordno[1])) or Trim(dw_insert.object.pordno[1]) = "" then
	f_message_chk(30, "[작업지시번호]")
	dw_insert.setcolumn('pordno')
	dw_insert.setfocus()
	return -1
end if	
if IsNull(Trim(dw_insert.object.itnbr[1])) or Trim(dw_insert.object.itnbr[1]) = "" then
	f_message_chk(30, "[작업지시번호 -> 품번]")
	dw_insert.setcolumn('itnbr')
	dw_insert.setfocus()
	return -1
end if	

if IsNull(Trim(dw_insert.object.gubun[1])) or Trim(dw_insert.object.gubun[1]) = "" then
	f_message_chk(30, "[이상발생구분]")
	dw_insert.setcolumn('gubun')
	dw_insert.setfocus()
	return -1
end if	

IF dw_insert.object.gubun[1] = '1' then 
	
	if ( IsNull(dw_insert.object.bupum[1]) or Trim(dw_insert.object.bupum[1]) = "" ) &
	   AND ( IsNull(dw_insert.object.banpum[1]) or Trim(dw_insert.object.banpum[1]) = "" ) then
		f_message_chk(30, "[이상발생품번(반제품/부품)]")
		dw_insert.setcolumn('banpum')
		dw_insert.setfocus()
		return -1
	end if	
	
	if not ( IsNull(dw_insert.object.banpum[1]) or Trim(dw_insert.object.banpum[1]) = "") then
		
		sItnbr = dw_insert.object.banpum[1]
		SELECT ITTYP INTO :sIttyp FROM ITEMAS WHERE ITNBR = :sItnbr;
		
		if sIttyp <> "2" then
			messagebox("이상발생 반제품 확인", "이상발생 반제품코드를 확인하세요!")
			dw_insert.setcolumn('banpum')
			dw_insert.setfocus()
			return -1
		end if	
   end if
	
	if not (IsNull(dw_insert.object.bupum[1]) or Trim(dw_insert.object.bupum[1]) = "" ) then 

		sItnbr = dw_insert.object.bupum[1]
		SELECT ITTYP INTO :sIttyp FROM ITEMAS WHERE ITNBR = :sItnbr;
		
		if sIttyp <> "3" And sIttyp <> "4" then
			messagebox("이상발생품번(부품) 확인","이상발생품번(부품)은 부품만 가능합니다!")
			dw_insert.setcolumn('bupum')
			dw_insert.setfocus()
			return -1
		end if	
	end if	
END IF

dw_ins.object.sabu[1] = gs_sabu
dw_ins.object.occjpno[1] = jpno
		
dw_insert.AcceptText()
dw_ins.AcceptText()

return 1
end function

public subroutine wf_get_jego (string gubun, string itnbr);real curjego, gajego, estjego

select sum(s.jego_qty), sum(s.valid_qty),
       sum(s.jego_qty + s.jisi_qty + s.prod_qty + s.balju_qty +
           s.pob_qc_qty + s.ins_qty + s.gi_qc_qty + s.gita_in_qty) -
       sum(s.hold_qty + s.order_qty + s.mfgcnf_qty)
  into :curjego, :gajego, :estjego		 
  from stock s
 where s.itnbr = :itnbr;

//if sqlca.sqlcode <> 0 then
//	MessageBox("재고계산 실패", "현재고, 가용재고, 예상재고 자료가 없습니다!")
//	return
//end if
if gubun = "2" then //이상발생 반제품
	dw_insert.object.cur_qty3[1] = curjego
	dw_insert.object.ga_qty3[1] = gajego
	dw_insert.object.est_qty3[1] = estjego
elseif gubun = "3" then //이상발생 부품
	dw_insert.object.cur_qty[1] = curjego
	dw_insert.object.ga_qty[1] = gajego
	dw_insert.object.est_qty[1] = estjego
end if

return 
end subroutine

on w_qct_01090.create
int iCurrent
call super::create
this.rb_new=create rb_new
this.rb_mod=create rb_mod
this.dw_ins=create dw_ins
this.st_3=create st_3
this.cb_1=create cb_1
this.p_1=create p_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_new
this.Control[iCurrent+2]=this.rb_mod
this.Control[iCurrent+3]=this.dw_ins
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.rr_1
this.Control[iCurrent+9]=this.rr_2
end on

on w_qct_01090.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_new)
destroy(this.rb_mod)
destroy(this.dw_ins)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.p_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_ins.SetTransObject(SQLCA)

dw_insert.ReSet()
dw_insert.InsertRow(0)

dw_ins.ReSet()
dw_ins.InsertRow(0)

dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_qct_01090
integer x = 73
integer y = 176
integer width = 4521
integer height = 1392
integer taborder = 20
string dataobject = "d_qct_01090_01"
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String  s_col, s_cod, s_nam1, s_nam2, s_nam3, get_bucod, get_name, snull 
Integer i_rtn

ib_any_typing = True //입력필드 변경여부 Yes

s_col = this.GetColumnName()
s_cod = Trim(this.GetText())   
CHOOSE CASE s_col
	CASE "occjpno" //문서번호
		if IsNull(s_cod) or s_cod = "" then return
		select occjpno
		  into :s_nam1
		  from occrpt
		 where occjpno = :s_cod;
		if sqlca.sqlcode <> 0 then
			f_message_chk(33, "[문서번호]")
		   this.object.occjpno[1] = ""
			return 1
		end if	
		p_inq.TriggerEvent(Clicked!) //조회버튼 
	CASE "occdat" //발생일자
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[발생일자]")
		   this.object.occdat[1] = ""
		   return 1
	   end if
	CASE "pordno" //작업지시번호
		if IsNull(s_cod) or s_cod = "" then
			this.object.pordno[1] = ""
			this.object.itnbr[1] = ""
			this.object.itdsc[1] = ""
			this.object.ispec[1] = ""
			this.object.fatrmks[1] = ""
			return 
		end if

      select m.pordno, m.itnbr, i.itdsc, i.ispec
		  into :s_cod, :s_nam1, :s_nam2, :s_nam3
		  from momast m, itemas i
		 where m.sabu = :gs_sabu and m.pordno = :s_cod
		   and m.itnbr = i.itnbr (+);
		
		if sqlca.sqlcode <> 0 or IsNull(s_cod) or s_cod = "" then
			f_message_chk(50,"[작업지시번호]")
			this.object.pordno[1] = ""
			this.object.itnbr[1] = ""
			this.object.itdsc[1] = ""
			this.object.ispec[1] = ""
			this.object.fatrmks[1] = ""
			return 1
      else
		  SELECT B.GUCOD 
		    INTO :get_bucod
			 FROM SHPACT A, SHPFAT B
			WHERE A.SABU    = B.SABU 
			  AND A.SHPJPNO = B.SHPJPNO 
			  AND A.SABU    = :gs_sabu
			  AND A.PORDNO  = :s_cod 
			  AND B.GUBUN   = '1'
		     AND ROWNUM = 1  ;
			  
			if sqlca.sqlcode = 0 then 
				get_name = f_get_reffer('33', get_bucod )
         end if			
			
			this.object.pordno[1] = s_cod
			this.object.itnbr[1] = s_nam1
			this.object.itdsc[1] = s_nam2
			this.object.ispec[1] = s_nam3
			this.object.fatrmks[1] = get_name
			return
		end if	
   CASE "snddpt" //발신부서
		i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
		this.object.snddpt[1] = s_cod
		this.object.snddptnm[1] = s_nam1
		return i_rtn
	CASE "comdpt" //조치부서
		i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
		this.object.comdpt[1] = s_cod
		this.object.comdptnm[1] = s_nam1
		return i_rtn
	CASE "sndemp" //발신자
		i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
		this.object.sndemp[1] = s_cod
		this.object.sndempnm[1] = s_nam1
		return i_rtn
	CASE "gubun" //이상발생구분
		s_nam1 = data
		if s_nam1 = '3' then  // 출하이상기록인 경우에는 공정이 없음
			this.object.opsno[1] = "9999"
			this.object.opdsc[1] = ""		
		end if
		if s_nam1 <> '1' then // 제품이상, 출하이상인 경우에는 반제품, 부품이 없음
			this.object.banpum[1] = ""
			this.object.bupum[1] = ""
			this.object.banpumnm[1] = ""
			this.object.bupumnm[1] = ""			
			dw_insert.object.cur_qty3[1] = 0
			dw_insert.object.ga_qty3[1] = 0
			dw_insert.object.est_qty3[1] = 0
			dw_insert.object.cur_qty[1] = 0
			dw_insert.object.ga_qty[1] = 0
			dw_insert.object.est_qty[1] = 0
		end if
	CASE "opsno" //공정순서
		s_nam1 = Trim(this.object.itnbr[1])
		if IsNull(s_cod) or s_cod = "" then
	   	MessageBox("품번확인", "작업지시번호 또는 해당 품번을 확인 하세요!")
			this.object.opsno[1] = ""
			this.object.opdsc[1] = ""
		   return
	   end if	

		select opdsc into :s_nam2 from routng
		 where itnbr = :s_nam1 and opseq = :s_cod;
		 
		if sqlca.sqlcode <> 0 then
			this.object.opsno[1] = ""
			this.object.opdsc[1] = ""
			f_message_chk(50,"[공정순서]")
			return 1
		else
			this.object.opdsc[1] = s_nam1
		end if
	CASE "reqdat" //조치요청일
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[조치요청일]")
		   this.object.reqdat[1] = ""
		   return 1
	   end if
   CASE "banpum" //이상발생 반제품
		i_rtn = f_get_name2("품번", "Y", s_cod, s_nam1, s_nam2)
		this.object.banpum[1] = s_cod
		this.object.banpumnm[1] = s_nam1
		wf_get_jego("2", s_cod)
		return i_rtn
	CASE "banpumnm" //이상발생 반제품명
		i_rtn = f_get_name2("품명", "Y", s_nam1, s_cod, s_nam2)
		this.object.banpum[1] = s_nam1
		this.object.banpumnm[1] = s_cod
		wf_get_jego("2", s_cod)
		return i_rtn
	CASE "bupum" //이상발생 품번
		i_rtn = f_get_name2("품번", "Y", s_cod, s_nam1, s_nam2)
		this.object.bupum[1] = s_cod
		this.object.bupumnm[1] = s_nam1
		wf_get_jego("3", s_cod)
		return i_rtn
	CASE "bupumnm" //이상발생 품명
		i_rtn = f_get_name2("품명", "Y", s_nam1, s_cod, s_nam2)
		this.object.bupum[1] = s_nam1
		this.object.bupumnm[1] = s_cod
		wf_get_jego("3", s_cod)
		return i_rtn
	CASE "jangidae" //장기대책여부
		if s_cod <> "Y" then
		   this.object.jangemp[1] = ""
		   this.object.jangempnm[1] = ""
			this.object.jangjdat[1] = ""
		end if	
	CASE "jangemp" //장기대책점검자
		i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
		this.object.jangemp[1] = s_cod
		this.object.jangempnm[1] = s_nam1
		return i_rtn
	CASE "jangjdat" //장기대책점검일자
		if IsNull(s_cod) or s_cod = "" then return 
	   if f_datechk(s_cod) = -1 then
		   f_message_chk(35,"[장기대책점검일자]")
		   this.object.jangjdat[1] = ""
		   return 1
	   end if
END CHOOSE

return

end event

event dw_insert::rbuttondown;String s_cod
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.getcolumnname() = "occjpno" then //문서번호
	open(w_occjpno_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.occjpno[1] = gs_code
	p_inq.TriggerEvent(Clicked!) //조회버튼
elseif this.getcolumnname() = "pordno" then //작업지시번호
	open(w_jisi_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.pordno[1] = gs_code
   this.TriggerEvent(itemchanged!)
elseif this.getcolumnname() = "snddpt" then //발신부서
	open(w_vndmst_4_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.snddpt[1] = gs_code
   this.object.snddptnm[1] = gs_codename
elseif this.getcolumnname() = "comdpt" then //조치부서
	open(w_vndmst_4_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.comdpt[1] = gs_code
   this.object.comdptnm[1] = gs_codename
elseif this.getcolumnname() = "sndemp" then //발신자
	open(w_sawon_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.sndemp[1] = gs_code
   this.object.sndempnm[1] = gs_codename
elseif this.getcolumnname() = "opsno" then //공정순서
	s_cod = this.object.itnbr[1]
	if IsNull(s_cod) or s_cod = "" then
		MessageBox("품번확인", "작업지시번호 또는 해당 품번을 확인 하세요!")
		this.object.opsno[1] = ""
		this.object.opdsc[1] = ""
		return
	end if	
	openwithparm(w_routng_popup, s_cod)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.opsno[1] = gs_code
   this.object.opdsc[1] = gs_codename
elseif this.getcolumnname() = "banpum" or this.getcolumnname() = "banpumnm" then //이상발생반제품
	gs_code = this.object.itnbr[1]
	open(w_pstruc_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.banpum[1] = gs_code
	this.object.banpumnm[1] = gs_codename
   this.TriggerEvent(itemchanged!)
elseif this.getcolumnname() = "bupum" or this.getcolumnname() = "bupumnm" then //이상발생품번
	gs_code = this.object.itnbr[1]
	open(w_pstruc_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.bupum[1] = gs_code
   this.object.bupumnm[1] = gs_codename
   this.TriggerEvent(itemchanged!)
elseif this.getcolumnname() = "jangemp" then //장기대책점검자
	open(w_sawon_popup)
	if gs_code = '' or isnull(gs_code) then return 
   this.object.jangemp[1] = gs_code
   this.object.jangempnm[1] = gs_codename
end if



end event

event dw_insert::itemfocuschanged;if this.GetColumnName() = "fatrmks" or this.GetColumnName() = "emrrmks" or this.GetColumnName() = "occtitle" then
   f_toggle_kor(Handle(this))
else
	f_toggle_eng(Handle(this))
end if	


end event

event dw_insert::ue_pressenter;if this.GetColumnName() = "fatrmks" or this.GetColumnName() = "emrrmks" then return 
Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
elseif keydown(keyF2!) THEN 	
	if this.getcolumnname() = "banpum" or this.getcolumnname() = "banpumnm" then //이상발생반제품
	   open(w_itemas_popup2)
      this.object.banpum[1] = gs_code
      this.object.banpumnm[1] = gs_codename
	elseif this.getcolumnname() = "bupum" or this.getcolumnname() = "bupumnm" then //이상발생품번
	   open(w_itemas_popup2)
      this.object.bupum[1] = gs_code
      this.object.bupumnm[1] = gs_codename
	end if	
END IF
end event

type p_delrow from w_inherite`p_delrow within w_qct_01090
boolean visible = false
integer x = 4357
integer y = 3320
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_qct_01090
boolean visible = false
integer x = 4183
integer y = 3320
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_qct_01090
boolean visible = false
integer x = 3488
integer y = 3320
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_qct_01090
boolean visible = false
integer x = 4009
integer y = 3320
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_qct_01090
integer x = 4407
end type

type p_can from w_inherite`p_can within w_qct_01090
integer x = 4233
integer taborder = 60
end type

event p_can::clicked;call super::clicked;IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

rb_mod.Checked = True

rb_mod.TriggerEvent(Clicked!)

w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"

ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_qct_01090
boolean visible = false
integer x = 3662
integer y = 3320
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_qct_01090
integer x = 3712
end type

event p_inq::clicked;call super::clicked;String ino
Long   i

if dw_insert.AcceptText() = -1 then
	dw_insert.SetFocus()
	return -1
end if

ino = dw_insert.object.occjpno[1]

if (IsNull(ino) or ino = "")  then 
	f_message_chk(30, "[문서번호]")
	return 1
end if

if dw_insert.Retrieve(gs_sabu, ino) < 1 then //자료 없을 때
   MessageBox("신규등록", "자료가 없습니다. 신규로 등록하세요!")
   dw_insert.object.gbn[1] =  "1"
	
	p_mod.Enabled = True
	p_mod.PictureName = 'c:\erpman\image\저장_up.gif'
	
	p_del.Enabled = False
	p_del.PictureName = 'c:\erpman\image\삭제_d.gif'

	rb_new.Checked = True
	rb_mod.Checked = False
	
	dw_ins.SetRedraw(False)
	dw_ins.Reset()
	dw_ins.InsertRow(0)
	dw_ins.SetRedraw(True)

	dw_insert.SetRedraw(False)
	dw_insert.Reset()
	dw_insert.InsertRow(0)
   dw_insert.SetColumn("occdat")
   dw_insert.Setfocus()
	dw_insert.SetRedraw(True)
	return
end if

if dw_ins.Retrieve(gs_sabu, ino) < 1 then //자료 없을 때
	dw_ins.SetRedraw(False)
	dw_ins.Reset()
	dw_ins.InsertRow(0)
	dw_ins.SetRedraw(True)
end if

rb_new.Checked = False
rb_mod.Checked = True

//이상발생결과가 등록 여부 Check
if IsNull(Trim(dw_insert.object.wonin[1])) or Trim(dw_insert.object.wonin[1]) = "" then
	p_mod.Enabled = True
	p_mod.PictureName = 'c:\erpman\image\저장_up.gif'
	
	p_del.Enabled = True
	p_del.PictureName = 'c:\erpman\image\삭제_up.gif'
	
   dw_insert.object.gbn[1] = "0"
   dw_insert.SetColumn("occdat")
   dw_insert.Setfocus()
else	
	p_mod.Enabled = False
	p_mod.PictureName = 'c:\erpman\image\저장_d.gif'
	
	p_del.Enabled = False
	p_del.PictureName = 'c:\erpman\image\삭제_d.gif'
	
   w_mdi_frame.sle_msg.Text = "이상발생결과가 등록된 자료 입니다!(수정/삭제 불가)"
end if

return
end event

type p_del from w_inherite`p_del within w_qct_01090
integer x = 4059
integer taborder = 50
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;long i, lcRow

if f_msg_delete() = -1 then return
if dw_insert.AcceptText() = -1 then return 
if dw_ins.AcceptText() = -1 then return 
//이상발생결과가 등록 여부 Check
if IsNull(Trim(dw_insert.object.wonin[1])) or Trim(dw_insert.object.wonin[1]) = "" then
	p_mod.Enabled = True
	p_mod.PictureName = 'c:\erpman\image\저장_up.gif'
	
	p_del.Enabled = True
	p_del.PictureName = 'c:\erpman\image\삭제_up.gif'
else	
	p_mod.Enabled = False
	p_mod.PictureName = 'c:\erpman\image\저장_d.gif'
	
	p_del.Enabled = False
	p_del.PictureName = 'c:\erpman\image\삭제_d.gif'
   MessageBox("이상발생결과 확인", "이상발생결과가 등록된 자료 입니다!(수정/삭제 불가)")
	return 
end if

lcRow = dw_insert.GetRow()
dw_insert.SetRedraw(False)
dw_insert.DeleteRow(lcRow)

if dw_insert.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[삭제실패]') 
	w_mdi_frame.sle_msg.Text = "삭제 작업 실패!"
	Return
end if
	
lcRow = dw_ins.GetRow()
dw_ins.SetRedraw(False)
dw_ins.DeleteRow(lcRow)
if dw_ins.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[삭제실패 : Document]') 
	w_mdi_frame.sle_msg.Text = "삭제 작업 실패!"
	Return
end if

COMMIT;

dw_insert.ReSet()
dw_insert.InsertRow(0) 
dw_insert.SetRedraw(True)
	
dw_ins.ReSet()
dw_ins.InsertRow(0) 
dw_ins.SetRedraw(True)

rb_new.Checked = False
rb_mod.Checked = True

dw_insert.SetFocus()

w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"

ib_any_typing = False //입력필드 변경여부 No
end event

type p_mod from w_inherite`p_mod within w_qct_01090
integer x = 3886
integer taborder = 40
boolean enabled = false
string picturename = "C:\erpman\image\저장_d.gif"
end type

event p_mod::clicked;call super::clicked;if dw_ins.AcceptText() = -1 then return 

if f_msg_update() = -1 then return  //저장 Yes/No ?

SetPointer(HourGlass!)

//이상발생결과가 등록 여부 Check
if IsNull(Trim(dw_insert.object.wonin[1])) or Trim(dw_insert.object.wonin[1]) = "" then
	p_mod.Enabled = True
	p_mod.PictureName = 'c:\erpman\image\저장_up.gif'
	
	p_del.Enabled = True
	p_del.PictureName = 'c:\erpman\image\삭제_up.gif'
else	
	p_mod.Enabled = False
	p_mod.PictureName = 'c:\erpman\image\저장_d.gif'
	
	p_del.Enabled = False
	p_del.PictureName = 'c:\erpman\image\삭제_d.gif'
   MessageBox("이상발생결과 확인", "이상발생결과가 등록된 자료 입니다!(수정/삭제 불가)")
	return 
end if

if wf_required_chk() = -1 then return //필수입력항목 체크 

if dw_insert.Update() <> 1 then
	ROLLBACK;
	f_message_chk(32,'[자료저장 실패]') 
	w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if

dw_ins.AcceptText()
if dw_ins.Update() <> 1 then
  	ROLLBACK;
	f_message_chk(32,'[자료저장 실패 : Document]') 
	w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if

COMMIT;

p_inq.TriggerEvent(Clicked!)
//dw_insert.object.gbn[1] = "0" //문서번호 디스플레이
//
//w_mdi_frame.sle_msg.text = "저장 되었습니다!"
//
//p_del.Enabled = True
//p_del.PictureName = 'c:\erpman\image\삭제_up.gif'
//
//rb_new.checked = False
//rb_mod.checked = True

ib_any_typing = False //입력필드 변경여부 No
 
end event

type cb_exit from w_inherite`cb_exit within w_qct_01090
integer x = 2825
integer y = 3292
end type

type cb_mod from w_inherite`cb_mod within w_qct_01090
integer x = 1783
integer y = 3292
boolean enabled = false
end type

type cb_ins from w_inherite`cb_ins within w_qct_01090
integer x = 942
integer y = 2344
integer taborder = 90
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_qct_01090
integer x = 2130
integer y = 3292
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_qct_01090
integer x = 1422
integer y = 3296
end type

type cb_print from w_inherite`cb_print within w_qct_01090
integer x = 1874
integer y = 2348
end type

type st_1 from w_inherite`st_1 within w_qct_01090
integer x = 0
integer y = 3520
end type

type cb_can from w_inherite`cb_can within w_qct_01090
integer x = 2478
integer y = 3292
end type

type cb_search from w_inherite`cb_search within w_qct_01090
integer x = 1371
integer y = 2348
end type

type dw_datetime from w_inherite`dw_datetime within w_qct_01090
integer x = 2843
integer y = 3520
end type

type sle_msg from w_inherite`sle_msg within w_qct_01090
integer x = 352
integer y = 3520
end type

type gb_10 from w_inherite`gb_10 within w_qct_01090
integer y = 3488
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_qct_01090
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_01090
end type

type rb_new from radiobutton within w_qct_01090
integer x = 2985
integer y = 60
integer width = 283
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
string text = "등  록"
end type

event clicked;rb_mod.Checked = False

p_mod.Enabled = True
p_mod.PictureName = 'c:\erpman\image\저장_up.gif'

p_del.Enabled = False
p_del.PictureName = 'c:\erpman\image\삭제_d.gif'

dw_ins.SetRedraw(False)
dw_ins.Reset()
dw_ins.InsertRow(0)
dw_ins.SetRedraw(True)

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.object.gbn[1] = "1"
dw_insert.SetColumn("occdat")
dw_insert.Setfocus()
dw_insert.SetRedraw(True)
end event

type rb_mod from radiobutton within w_qct_01090
integer x = 3342
integer y = 60
integer width = 283
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
string text = "수  정"
boolean checked = true
end type

event clicked;rb_new.Checked = False

p_mod.Enabled = False
p_mod.PictureName = 'c:\erpman\image\저장_d.gif'

p_del.Enabled = False
p_del.PictureName = 'c:\erpman\image\삭제_d.gif'

dw_ins.SetRedraw(False)
dw_ins.Reset()
dw_ins.InsertRow(0)
dw_ins.SetRedraw(True)

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.object.gbn[1] = "0"
dw_insert.SetColumn("occjpno")
dw_insert.SetRedraw(True)
dw_insert.Setfocus()


end event

type dw_ins from u_key_enter within w_qct_01090
integer x = 169
integer y = 1668
integer width = 4379
integer height = 576
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_qct_01090_02"
boolean border = false
boolean livescroll = false
end type

event itemchanged;this.AcceptText()
w_mdi_frame.sle_msg.text = ""
ib_any_typing = True //입력필드 변경여부 Yes

end event

event itemerror;return 1
end event

event getfocus;call super::getfocus;f_toggle_kor(Handle(this))
end event

event losefocus;call super::losefocus;f_toggle_eng(Handle(this))
end event

event ue_pressenter;if this.GetColumnName() = "occrmks" then return 
Send(Handle(this),256,9,0)
Return 1

end event

type st_3 from statictext within w_qct_01090
integer x = 165
integer y = 1600
integer width = 338
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "[Document]"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_qct_01090
boolean visible = false
integer x = 818
integer y = 3292
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

type p_1 from uo_picture within w_qct_01090
boolean visible = false
integer x = 2286
integer y = 20
integer width = 306
integer taborder = 70
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\BOM사용내역_up.gif"
end type

event clicked;call super::clicked;integer ireturn
String sItnbr, sItdsc

ireturn = MessageBox("BOM사용내역", "기준을 선택하십시요(예:반제품, 아니오:부품)?", &
											question!, yesnocancel!)
											
if ireturn = 3 then return
if ireturn = 1 then
	sItnbr = dw_insert.getitemstring(1, "banpum")
	sItdsc = dw_insert.getitemstring(1, "banpumnm")
	if isnull(sitdsc) or trim(sitdsc) = '' then
		Messagebox("품번", "반제품 품번이 입력되지 않았읍니다", stopsign!)
		return
	end if
else
	sItnbr = dw_insert.getitemstring(1, "bupum")
	sItdsc = dw_insert.getitemstring(1, "bupumnm")	
	if isnull(sitdsc) or trim(sitdsc) = '' then
		Messagebox("품번", "부품 품번이 입력되지 않았읍니다", stopsign!)
		return
	end if	
end if

openwithparm(w_qct_01100_01, sitnbr)
end event

event ue_lbuttondown;call super::ue_lbuttondown;this.PictureName = 'c:\erpman\image\BOM사용내역_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;this.PictureName = 'c:\erpman\image\BOM사용내역_up.gif'
end event

type pb_2 from u_pb_cal within w_qct_01090
integer x = 2542
integer y = 228
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_insert.SetColumn('occdat')
IF IsNull(gs_code) THEN Return
ll_row = dw_insert.GetRow()
If ll_row < 1 Then Return
dw_insert.SetItem(ll_row, 'occdat', gs_code)



end event

type rr_1 from roundrectangle within w_qct_01090
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2935
integer y = 24
integer width = 745
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_qct_01090
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 87
integer y = 1584
integer width = 4494
integer height = 676
integer cornerheight = 40
integer cornerwidth = 55
end type

