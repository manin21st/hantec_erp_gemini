$PBExportHeader$w_pdt_06000.srw
$PBExportComments$** 설비마스터 등록( 명칭변경)
forward
global type w_pdt_06000 from w_inherite
end type
type dw_ins1 from u_key_enter within w_pdt_06000
end type
type st_2 from statictext within w_pdt_06000
end type
type p_tdel from uo_picture within w_pdt_06000
end type
type p_1 from uo_picture within w_pdt_06000
end type
type p_2 from uo_picture within w_pdt_06000
end type
type p_add from uo_picture within w_pdt_06000
end type
type p_3 from uo_picture within w_pdt_06000
end type
type p_img from picture within w_pdt_06000
end type
type cb_1 from commandbutton within w_pdt_06000
end type
type p_img_in from picture within w_pdt_06000
end type
type p_5 from picture within w_pdt_06000
end type
type rr_1 from roundrectangle within w_pdt_06000
end type
end forward

global type w_pdt_06000 from w_inherite
integer width = 4686
integer height = 2968
string title = "설비마스터 등록"
dw_ins1 dw_ins1
st_2 st_2
p_tdel p_tdel
p_1 p_1
p_2 p_2
p_add p_add
p_3 p_3
p_img p_img
cb_1 cb_1
p_img_in p_img_in
p_5 p_5
rr_1 rr_1
end type
global w_pdt_06000 w_pdt_06000

type variables
str_itnct  lstr_itnct
string is_del_path

blob	iblobBMP
end variables

forward prototypes
public function integer wf_delete_chk (string smchno)
public function integer wf_required_chk ()
public function integer wf_save_image ()
public function integer wf_load_image ()
end prototypes

public function integer wf_delete_chk (string smchno);Long icnt = 0

select count(*) into :icnt 
  from mesmst
 where sabu = :gs_sabu 
   and mchno = :smchno;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[계측기마스터]')
	return -1
end if

select count(*) into :icnt 
  from mchmst_insp
 where sabu  = :gs_sabu 
   and mchno = :smchno;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[설비점검기준]')
	return -1
end if

select count(*) into :icnt 
  from shpact
 where sabu   = :gs_sabu 
   and mchcod = :smchno and rownum = 1 ;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[작업실적]')
	return -1
end if

select count(*) into :icnt 
  from morout
 where sabu   = :gs_sabu 
   and mchcod = :smchno  and rownum = 1 ;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[작업지시 공정상세]')
	return -1
end if

select count(*) into :icnt 
  from kumest
 where sabu  = :gs_sabu 
   and mchno = :smchno  ;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[금형/치공구 제작/수리 의뢰]')
	return -1
end if

select count(*) into :icnt 
  from mchmst_send
 where sabu  = :gs_sabu 
   and mchno = :smchno  ;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[설비지급이력]')
	return -1
end if

return 1
end function

public function integer wf_required_chk ();//필수입력항목 체크 + Fill
Long i, ll_found, inull
String s_itnbr, sLisGu, sDate, stopdat, pedat, sBuncd, sMchno, smax, sGrpcod
Int  imax

setnull(inull)

if dw_insert.AcceptText() = -1 then return -1

sGrpcod = Trim(dw_insert.object.grpcod[1])
if Isnull(Trim(dw_insert.object.grpcod[1])) or Trim(dw_insert.object.grpcod[1]) = "" then
  	f_message_chk(1400,'[그룹코드]')
	dw_insert.SetColumn('grpcod')
	dw_insert.SetFocus()
	return -1
end if

sBuncd = Trim(dw_insert.object.buncd[1])
//if Isnull(Trim(dw_insert.object.buncd[1])) or Trim(dw_insert.object.buncd[1]) = "" then
//  	f_message_chk(1400,'[관리번호]')
//	dw_insert.SetColumn('buncd')
//	dw_insert.SetFocus()
//	return -1
//end if

sMchno = Trim(dw_insert.object.mchno[1])
If IsNull(sMchno) Or sMchNo = '' Then
	SELECT MAX(MCHNO) INTO :smax FROM MCHMST WHERE GRPCOD = :sGrpCod;
	If IsNull(sMax) Or Trim(sMax) ='' Then
		imax = 1
	Else
		imax = integer(mid(smax,2,5)) + 1
	End If
	
	sMchno = Left(sGrpCod,1) + string(imax,'00000')
	dw_insert.Setitem(1, 'mchno', smchno)
	MessageBox('확인','신규 설비번호는 ' + smchno + ' 입니다.!!')
End If

if Isnull(Trim(dw_insert.object.sabu[1])) or Trim(dw_insert.object.sabu[1]) = "" then
	dw_insert.object.sabu[1] = gs_sabu
end if	

if Isnull(Trim(dw_insert.object.mchno[1])) or Trim(dw_insert.object.mchno[1]) = "" then
  	f_message_chk(1400,'[설비번호]')
	dw_insert.SetColumn('mchno')
	dw_insert.SetFocus()
	return -1
end if	
if Isnull(Trim(dw_insert.object.gubun[1])) or Trim(dw_insert.object.gubun[1]) = "" then
  	f_message_chk(1400,'[설비구분]')
	dw_insert.SetColumn('gubun')
	dw_insert.SetFocus()
	return -1
end if	
if Isnull(Trim(dw_insert.object.mchnam[1])) or Trim(dw_insert.object.mchnam[1]) = "" then
  	f_message_chk(1400,'[설비명]')
	dw_insert.SetColumn('mchnam')
	dw_insert.SetFocus()
	return -1
end if	
if Isnull(Trim(dw_insert.object.gudat[1])) or Trim(dw_insert.object.gudat[1]) = "" then /* 구입일자 필수값 추가 2024.04.01 by dykim */
  	f_message_chk(1400,'[구입일자]')
	dw_insert.SetColumn('gudat')
	dw_insert.SetFocus()
	return -1
end if	

//if Isnull(Trim(dw_insert.object.spec[1])) or Trim(dw_insert.object.spec[1]) = "" then
//  	f_message_chk(1400,'[규  격]')
//	dw_insert.SetColumn('spec')
//	dw_insert.SetFocus()
//	return -1
//end if

/* 설비 조회 pop-up에서 대표작업장 누락으로 조회되지 않는 현상 발생되어 필수 입력되도록 요청 함 - by shingoon 20180328 */
if Isnull(Trim(dw_insert.object.wkctr[1])) or Trim(dw_insert.object.wkctr[1]) = "" then
  	f_message_chk(1400,'[대표작업장]')
	dw_insert.SetColumn('wkctr')
	dw_insert.SetFocus()
	return -1
end if


//자산번호 : 설비구분이 '1'(자산)이면 필수, '2'(비자산)이면 Blank
if Trim(dw_insert.object.gubun[1]) = "1" and &
   ( Isnull(Trim(dw_insert.object.kfcod1[1])) or Trim(dw_insert.object.kfcod1[1]) = "") then
  	f_message_chk(1400,'[자산번호]')
	dw_insert.SetColumn('kfcod1')
	dw_insert.SetFocus()
	return -1
elseif dw_insert.object.gubun[1] = "2" then
	dw_insert.object.kfcod1[1] = ""
end if

if Trim(dw_insert.object.gubun[1]) = "1" and &
   Isnull(dw_insert.GetItemNumber(1, 'kfcod2'))  then
  	f_message_chk(1400,'[자산번호]')
	dw_insert.SetColumn('kfcod2')
	dw_insert.SetFocus()
	return -1
elseif dw_insert.object.gubun[1] = "2" then
	dw_insert.object.kfcod2[1] = inull
end if	

//일보유공수 : 생산실적 집계 여부 에 따라
if Trim(dw_insert.GetItemString(1,'sum_yn')) = 'Y' Then
	If ((Isnull(dw_insert.object.dailyhr[1]) or dw_insert.object.dailyhr[1] <= 0)) then
		f_message_chk(1400,'[일일 보유공수]')
		dw_insert.SetColumn('dailyhr')
		dw_insert.SetFocus()
		return -1
	End If
else
	dw_insert.SetItem(1,'dailyhr', 0)
end if

if Isnull(Trim(dw_insert.object.dptno[1])) or Trim(dw_insert.object.dptno[1]) = "" then
  	f_message_chk(1400,'[사용부서]')
	dw_insert.SetColumn('dptno')
	dw_insert.SetFocus()
	return -1
end if	
//if Isnull(Trim(dw_insert.object.jenam[1])) or Trim(dw_insert.object.jenam[1]) = "" then
//  	f_message_chk(1400,'[제작처]')
//	dw_insert.SetColumn('jenam')
//	dw_insert.SetFocus()
//	return -1
//end if	
//if Isnull(Trim(dw_insert.object.jedat[1])) or Trim(dw_insert.object.jedat[1]) = "" then
//  	f_message_chk(1400,'[제작일자]')
//	dw_insert.SetColumn('jedat')
//	dw_insert.SetFocus()
//	return -1
//end if	
//if Isnull(Trim(dw_insert.object.gunam[1])) or Trim(dw_insert.object.gunam[1]) = "" then
//  	f_message_chk(1400,'[구입처]')
//	dw_insert.SetColumn('gunam')
//	dw_insert.SetFocus()
//	return -1
//end if	
//if Isnull(Trim(dw_insert.object.gudat[1])) or Trim(dw_insert.object.gudat[1]) = "" then
//  	f_message_chk(1400,'[구입일자]')
//	dw_insert.SetColumn('gudat')
//	dw_insert.SetFocus()
//	return -1
//end if	
//구입금액 : 설비구분이 '1'(자산)이면 100만원 이상, '2'(비자산)이면 100만원 미만
//if Isnull(dw_insert.object.guamt[1]) or dw_insert.object.guamt[1] < 0 then
//  	f_message_chk(1400,'[구입금액]')
//	dw_insert.SetColumn('guamt')
//	dw_insert.SetFocus()
//	return -1
//end if	

if Isnull(Trim(dw_insert.object.kegbn[1])) or Trim(dw_insert.object.kegbn[1]) = "" then
  	f_message_chk(1400,'[교정/비교정구분]')
	dw_insert.SetColumn('kegbn')
	dw_insert.SetFocus()
	return -1
end if	

/* 리스 시작일,종료일 */
//sLisGu = dw_insert.GetItemString(1,'lisgu')
//If sLisGu = 'Y' Then
//	sDate = Trim(dw_insert.GetItemString(1,'lisstd'))
//
//	If f_datechk(sDate) <> 1 Then
//		f_message_chk(1400,'[리스시작일]')
//		dw_insert.SetColumn('lisstd')
//		Return -1
//	End If
//	
//	sDate = Trim(dw_insert.GetItemString(1,'lisetd'))
//
//	If f_datechk(sDate) <> 1 Then
//		f_message_chk(1400,'[리스종료일]')
//		dw_insert.SetColumn('lisetd')
//		Return -1
//	End If
//End If
sDate = Trim(dw_insert.GetItemString(1,'lisstd'))
if isNull(sDate) or sDate = "" then
Else
	If f_datechk(sDate + '01') <> 1 Then
		f_message_chk(1400,'[차기점검월]')
		dw_insert.SetColumn('lisstd')
		Return -1
	End If
End if
///* 폐기일자 있으면 폐기사용 필수 */
//pedat = trim(dw_insert.GetItemString(1,'pedat'))
//If not (isnull(pedat) or pedat = '' ) Then
//	if Isnull(Trim(dw_insert.object.pesau[1])) or Trim(dw_insert.object.pesau[1]) = "" then
//		f_message_chk(1400,'[폐기사유]')
//		dw_insert.SetColumn('pesau')
//		dw_insert.SetFocus()
//		return -1
//	else
//		stopdat = Trim(dw_insert.object.stopdat[1])
//		if IsNull(stopdat) or stopdat = "" or stopdat > pedat then
//			dw_insert.object.stopdat[1] = dw_insert.object.pedat[1]
//		end if	
//		
//	end if	
//End If

for i = 1 to dw_ins1.RowCount()
   dw_ins1.object.sabu[i] = gs_sabu
	dw_ins1.object.mchno[i] = dw_insert.object.mchno[1]
   if Isnull(Trim(dw_ins1.object.itnbr[i])) or Trim(dw_ins1.object.itnbr[i]) = "" then
  	   f_message_chk(1400,'[품번]')
		dw_ins1.SetRow(i)  
	   dw_ins1.SetColumn('itnbr')
	   dw_ins1.SetFocus()
	   return -1
   end if	
   if Isnull(dw_ins1.object.qtypr[i]) or dw_ins1.object.qtypr[i] <= 0 then
  	   f_message_chk(1400,'[소요수량]')
		dw_ins1.SetRow(i)  
	   dw_ins1.SetColumn('qtypr')
	   dw_ins1.SetFocus()
	   return -1
   end if
   s_itnbr = dw_ins1.object.itnbr[i] 
	if i < dw_ins1.RowCount() then
      ll_found = dw_ins1.Find("itnbr = '" + s_itnbr + "'", i + 1, dw_ins1.RowCount())
		if ll_found > 0 then
			MessageBox("SPARE PART LIST 중복", String(ll_found) + " 번째 Row의 품번이 중복입니다!(등록 불가능!)")
			return -1
		end if	
   end if
next

return 1
end function

public function integer wf_save_image ();String	sMchNo

If Not p_img.Visible Then Return 0
if len(iblobBMP) = 0 then return 0

sMchNo = dw_insert.getitemstring(1,"mchno")

sqlca.autocommit = TRUE

//////////////////////////////////////////////////////////////////////////////////////////////
// 계측기 이미지 저장
Updateblob lw_mchmes_image
   Set image = :iblobBMP
 Where sabu = :gs_sabu And mchgb = '1' And mchno = :sMchNo ;

If SQLCA.SQLCode = -1 Then
	MessageBox("Save Image SQL error",SQLCA.SQLErrText,Information!)
	Return -1
End If

Commit;

sqlca.autocommit = FALSE

Return 1
end function

public function integer wf_load_image ();string	sMchNo
int 		iCnt
blob		lblobBMP

p_img.Visible = False

sMchNo = dw_insert.getitemstring(1,"mchno")
///////////////////////////////////////////////////////////////////////////////////////////////
Select count(*) Into :iCnt From lw_mchmes_image
 Where sabu = :gs_sabu And mchgb = '1' And mchno = :sMchNo   ;

If iCnt = 0 Then Return -1

SELECTBLOB image into :lblobBMP from lw_mchmes_image
 Where sabu = :gs_sabu And mchgb = '1' And mchno = :sMchNo ;
 
If sqlca.sqlcode = -1 Then
	MessageBox("SQL error",SQLCA.SQLErrText,Information!)
	Return -1
End If

// Instance 변수에 보관
iblobBMP = lblobBMP

If p_img.SetPicture(iblobBMP) = 1 Then
	p_img.Visible = True
End if

Return 1
end function

on w_pdt_06000.create
int iCurrent
call super::create
this.dw_ins1=create dw_ins1
this.st_2=create st_2
this.p_tdel=create p_tdel
this.p_1=create p_1
this.p_2=create p_2
this.p_add=create p_add
this.p_3=create p_3
this.p_img=create p_img
this.cb_1=create cb_1
this.p_img_in=create p_img_in
this.p_5=create p_5
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_ins1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.p_tdel
this.Control[iCurrent+4]=this.p_1
this.Control[iCurrent+5]=this.p_2
this.Control[iCurrent+6]=this.p_add
this.Control[iCurrent+7]=this.p_3
this.Control[iCurrent+8]=this.p_img
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.p_img_in
this.Control[iCurrent+11]=this.p_5
this.Control[iCurrent+12]=this.rr_1
end on

on w_pdt_06000.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_ins1)
destroy(this.st_2)
destroy(this.p_tdel)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_add)
destroy(this.p_3)
destroy(this.p_img)
destroy(this.cb_1)
destroy(this.p_img_in)
destroy(this.p_5)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_ins1.SetTransObject(SQLCA)

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.InsertRow(0)
dw_insert.Setredraw(True)

dw_ins1.Setredraw(False)
dw_ins1.ReSet()


/* 규격,재질 Text 변경 */
If f_change_name('1') = 'Y' Then
	String sIspecText, sJijilText
	
	sIspecText = f_change_name('2')
	sJijilText = f_change_name('3')
	
	dw_ins1.Object.ispec_t.text =  sIspecText 
	dw_ins1.Object.jijil_t.text =  sJijilText
End If

dw_ins1.Setredraw(True)

dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_pdt_06000
integer x = 37
integer y = 200
integer width = 4535
integer height = 1536
integer taborder = 10
string dataobject = "d_pdt_06000_01"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event dw_insert::itemchanged;String s_cod, s_nam1, s_nam2, sNull,Sbuncd, ls_buncd, smchno
Integer i_rtn, iNull, i_cnt
long    ll_cnt
Real    guamt

SetNull(sNull)
SetNull(iNull)

w_mdi_frame.sle_msg.text = ""
s_cod = Trim(this.GetText())

Choose Case 	this.getcolumnname()
	Case 		"mchno"		//설비번호
		s_cod = Trim(GetText())
		
		select count(mchno) into :i_cnt from mchmst
 		where sabu = :gs_sabu and mchno = :s_cod and kegbn = 'N';
 
 		If i_cnt > 0 Then
			p_inq.TriggerEvent(Clicked!)
//		Else
//			MessageBox('확인','설비번호는 자동채번입니다.!!')
//			Return 2
		End If
	Case 		"wkctr"		     //작업장
		i_rtn = f_get_name2("작업장", "Y", s_cod, s_nam1, s_nam2)
		this.object.wkctr[1] = s_cod
		this.object.wcdsc[1] = s_nam1
		if 	IsNull(s_cod) or s_cod = "" then this.object.dailyhr[1] = 0
		return i_rtn
	Case 		"gubun"	 	//설비구분
		if s_cod = '2' then
			this.object.kfcod1[1] = snull
			this.object.kfcod2[1] = inull
		end if
	Case 		"dptno"		//관리부서
		i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
		this.object.dptno[1] = s_cod
		this.object.cvnas2[1] = s_nam1
		return i_rtn
   Case 		"gunam"		//구입부서
		i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
		this.object.gunam[1] = s_cod
		this.object.gu_cvnas2[1] = s_nam1
		return i_rtn		
	Case 		"jedat"		     //제작일자
		if IsNull(s_cod) or s_cod = "" or f_datechk(s_cod) = -1 then
			f_message_chk(35, "[제작일자]")
			this.object.jedat[1] = ""
			return 1
		end if
	Case 		"gudat"	 	//구입일자
		if IsNull(s_cod) or s_cod = "" or f_datechk(s_cod) = -1 then
			f_message_chk(35, "[구입일자]")
			this.object.gudat[1] = ""
			return 1
		end if
	Case 		"pedat"	 	//폐기일자
		if 	IsNull(s_cod) or s_cod = "" then 
			This.object.stopdat[1] = ""
			return 
		End If
		if 	f_datechk(s_cod) = -1 then
			f_message_chk(35, "[폐기일자]")
			this.object.pedat[1] = ""
			return 1
		end if
		
		This.SetItem(1, 'stopdat', s_cod)
	Case 		"stopdat"	 	//사용중지일자
		if 	IsNull(s_cod) or s_cod = "" then return
		if 	f_datechk(s_cod) = -1 then
			f_message_chk(35, "[사용중지일자]")
			this.object.stopdat[1] = ""
			return 1
		end if
	Case 		"lisstd"	 		//리스시작일
		if 	IsNull(s_cod) or s_cod = "" then return
		if 	f_datechk(s_cod + '01') = -1 then
			f_message_chk(35, "[차기점검월]")
			this.object.lisstd[1] = ""
			return 1
		end if
	Case 		"lisetd"	 		//리스종료일
		if 	IsNull(s_cod) or s_cod = "" then return
		if 	f_datechk(s_cod) = -1 then
			f_message_chk(35, "[리스종료일]")
			this.object.lisetd[1] = ""
			return 1
		end if
	Case 		"jidate"	 	//지원일자
		if 	IsNull(s_cod) or s_cod = "" then return
		if 	f_datechk(s_cod) = -1 then
			f_message_chk(35, "[지급일자]")
			this.object.jidate[1] = ""
			return 1
		end if
//	Case 		"maincd"	 //Main 설비
//		String sMainCd, sMainNam
//	
//		sMainCd = Trim(GetText())
//		If 	IsNull(sMainCd) Or sMainCd = '' Then
//			SetItem(1, 'maincd_nam', sNull)
//		End If
//
//		SELECT MCHNAM INTO :sMainNam
//	  		FROM MCHMST
//	 		WHERE SABU = :gs_sabu AND
//	       			MCHNO = :sMainCd;
//		If 	sqlca.sqlcode <> 0 Then
//			SetItem(1, 'maincd', sNull)
//			SetItem(1, 'maincd_nam', sNull)
//			Return 1
//		End If
//	
//		SetItem(1, 'maincd_nam', sMainNam)
//	case      "buncd"   // 분류코드 
//		Sbuncd = trim(GetText())
//		if IsNull(Sbuncd) or Sbuncd = '' then return
//		
//		SELECT COUNT(*)  
//		  INTO :ll_cnt
//		  FROM MITNCT
//		 WHERE KEGBN = 'N'
//			AND LMSGU = 'S'
//			AND BUNCD = :Sbuncd ; 
//		
//		if ll_cnt = 0 then
//			MessageBox('확인' , '등록되지않은 설비 분류코드 입니다(소분류만 가능).')
//			setitem(1,'buncd',snull)
//			return 1
//		end if 	
	case      "buncd"   // 관리번호
		Sbuncd = Trim(GetText())
		
		smchno = Trim(GetItemString(1, 'mchno'))
		
		If Sbuncd > '' Then
			select max(mchno), count(*) into :s_cod, :ll_cnt from mchmst where buncd = :sBuncd;
			
			If smchno > '' Then
				If ll_cnt > 0 and smchno <> s_cod Then
					MessageBox('확인' , '설비번호 :' + s_cod + '로 등록되어있습니다')
					SetItem(1, 'buncd', '')
					Return 2
				End If
			Else
				If ll_cnt > 0 Then
					MessageBox('확인' , '설비번호 :' + s_cod + '로 등록되어있습니다')
					SetItem(1, 'buncd', '')
					SetItem(1, 'mchno', s_cod)
               p_inq.TriggerEvent(Clicked!)
//					Return 2
				End If
			End If
		End If
End Choose 		




//elseif this.getcolumnname() = "grpcod" then //그룹코드
//	select grpnam into :s_nam1 from mchgrp
//	 where grpcod = :s_cod;
//	if sqlca.sqlcode <> 0 then
//		f_message_chk(35, "[그룹코드]")
//		this.object.grpcod[1] = ""
//		return 1
//	end if	
//elseif this.getcolumnname() = "guamt" then //구입금액
//	guamt = Real(s_cod)
//	if guamt < 0 then 
//		MessageBox("구입금액", "구입금액을 입력하세요! (Zero원 이상!)")
//		this.object.gubun[1] = "1"
//		
//		SetItem(1, 'kfcod1', sNull)
//		SetItem(1, 'kfcod2', iNull)
//
//		this.object.guamt[1] = 0
//	elseif guamt < 1000000 then //100만원 이상 자산, 아니면 비자산	
//		this.object.gubun[1] = "2"
//		SetItem(1, 'kfcod1', sNull)
//		SetItem(1, 'kfcod2', iNull)
//	else	
//		this.object.gubun[1] = "1"
//	end if	



return
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Choose Case 	this.getcolumnname()
	Case 		"mchno"		//설비번호
		gs_gubun = 'ALL'
	
		open(w_mchno_popup)
		If IsNull(gs_code) Then Return
		
		this.SetItem(1, "mchno", gs_code)
		this.SetItem(1, "mchnam", gs_codename)
		if 	not (IsNull(gs_code) or gs_codename = "") then
			p_inq.TriggerEvent(Clicked!)
		end if	
		return
	Case 		"wkctr"		     //작업장
		open(w_workplace_popup)
		If 	IsNull(gs_code) Or gs_code = '' Then Return
		this.SetItem(1, "wkctr", gs_code)
		this.SetItem(1, "wcdsc", gs_codename)
		return
	Case 		"kfcod2"	 	//고정자산 일련번호.
		gs_code = this.getitemstring(1, 'kfcod1')
		gs_codename = ''
		open(w_kfaa02b)
		If IsNull(gs_code) Or gs_code = '' Then Return

		SetItem(1,'kfcod1', gs_code)
		SetItem(1,'kfcod2', dec(gs_codename))
	Case 		"dptno"		//관리부서
		open(w_vndmst_4_popup)
		If 	IsNull(gs_code) Or gs_code = '' Then Return
		this.SetItem(1, "dptno", gs_code)
		this.SetItem(1, "cvnas2", gs_codename)
		return
	Case 		"gunam"		//구입부서 => 2006.09.19 구입처로 사용
//		open(w_vndmst_4_popup)
//		If 	IsNull(gs_code) Or gs_code = '' Then Return
//		this.SetItem(1, "gunam", gs_code)
//		this.SetItem(1, "gu_cvnas2", gs_codename)
//		return

      Open(w_vndmst_popup)
		IF gs_code ="" OR IsNull(gs_code) THEN RETURN
		
		SetItem(1,"gunam",gs_code)
 	   SetItem(1,"gu_cvnas2",gs_codename)

//	Case 		"maincd"	 //Main 설비
//		gs_gubun = 'ALL'
//		open(w_mchno_popup)
//		If IsNull(gs_code) Or gs_code = '' Then Return
//	
//		SetItem(1, "maincd", gs_code)
//		SetItem(1, "maincd_nam", gs_codename)
//	Case 		"buncd"	//설비분류명
//		gs_gubun = 'N'
//		Open(w_mittyp_popup)
//		If IsNull(gs_code) Or gs_code = '' Then Return
//
//		If gs_gubun <> 'S' Then
//			MessageBox('확인','소분류만 선택하실 수 있습니다.!!')
//			Return 2
//		End If
//		
//      lstr_itnct = Message.PowerObjectParm	
//	
//		SetItem(1, "buncd", gs_code)		
End Choose 		



end event

event dw_insert::doubleclicked;call super::doubleclicked;if this.getcolumnname() = "imgpath" then	
   p_search.TriggerEvent(Clicked!)	
end if
end event

event dw_insert::buttonclicked;call super::buttonclicked;string pathname, filename, sMchno
integer value

if dwo.name <> "btn1" then return

this.AcceptText()
pathname = Trim(this.object.imgpath[1])

sMchno = dw_insert.GetItemString(1, 'mchno')

pathname = "..\mchimg\" + sMchno + ".jpg"

//if IsNull(pathname) or pathname = "" then
//	value = GetFileOpenName("열기", pathname, filename, "BMP", "Image Files (*.BMP),*.BMP")
//   if value = 0 THEN return
//   if value <> 1 then
//	   MessageBox("열기 윈도우 실패","전산실로 문의 하세요!")
//      return
//   end if
//end if	
////이미지 등록 윈도우 Call
OpenWithParm(w_pdt_06010, pathname)
pathname = Message.StringParm
if not (IsNull(pathname) or pathname = "") then
   dw_insert.object.imgpath[1] = Trim(pathname)
end if	

end event

event dw_insert::editchanged;RETURN 1
end event

type p_delrow from w_inherite`p_delrow within w_pdt_06000
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_06000
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_06000
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_06000
integer y = 5000
end type

type p_exit from w_inherite`p_exit within w_pdt_06000
integer x = 4343
integer y = 20
end type

type p_can from w_inherite`p_can within w_pdt_06000
integer x = 4169
integer y = 20
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
//IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_ins1.SetRedraw(False)
dw_ins1.Reset()
dw_ins1.SetRedraw(True)

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)
dw_insert.SetFocus()

p_del.Enabled = False
p_tdel.Enabled = False
p_1.enabled = false
p_del.PictureName = "c:\erpman\image\삭제_d.gif"
p_tdel.PictureName = "c:\erpman\image\전체삭제_d.gif"
p_1.PictureName = "c:\erpman\image\지급이력_d.gif"
//p_img.picturename = ''
p_img.Visible = False
ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_pdt_06000
integer y = 5000
end type

type p_inq from w_inherite`p_inq within w_pdt_06000
integer x = 3648
integer y = 20
end type

event p_inq::clicked;call super::clicked;String s_mchno
Long   i_cnt

if dw_insert.AcceptText() = -1 then return

s_mchno = dw_insert.object.mchno[1]

if IsNull(s_mchno) or s_mchno = '' then
	p_can.triggerevent(clicked!)
	w_mdi_frame.sle_msg.text = "관리번호를 먼저 입력한 후 진행하세요!"
	dw_insert.SetColumn("mchno")
	dw_insert.SetFocus()
	return 
end if

//설비번호를 체크한다. (신규로 생성시 이전 데이터 남겨놓기 위해) - 임시 99.07.23
select count(mchno) into :i_cnt from mchmst
 where sabu = :gs_sabu and mchno = :s_mchno;
 
if sqlca.sqlcode <> 0 or i_cnt < 1 then
	p_tdel.Enabled = False
	p_1.Enabled = False
	p_tdel.PictureName = "c:\erpman\image\전체삭제_d.gif"
	p_1.PictureName = "c:\erpman\image\지급이력_d.gif"
	

   dw_insert.object.gudat[1] = "" //구입일자 CLEAR
	
	dw_ins1.SetRedraw(False)
	dw_ins1.ReSet()
	dw_ins1.SetRedraw(True)

   dw_insert.SetColumn("gubun")
   dw_insert.SetFocus() 

   dw_insert.SetItemStatus(1, 0, primary!, new!)

   MessageBox("신규등록", "신규로 등록 합니다!")
	w_mdi_frame.sle_msg.text = "신규로 등록 합니다!"
	return
end if	


dw_insert.SetRedraw(False)
if dw_insert.Retrieve(gs_sabu, s_mchno) < 1 then
	p_tdel.Enabled = False
	p_1.Enabled = False
	p_tdel.PictureName = "c:\erpman\image\전체삭제_d.gif"
	p_1.PictureName = "c:\erpman\image\지급이력_d.gif"
	
	dw_ins1.SetRedraw(False)
	dw_ins1.ReSet()
	dw_ins1.SetRedraw(True)
	
	dw_insert.ReSet()
	dw_insert.InsertRow(0)
	dw_insert.object.mchno[1] = s_mchno 
	w_mdi_frame.sle_msg.text = "신규로 등록 합니다!"
else
	/* Main CD */
	String sMainCd, sMainNam
	
	sMainCd = Trim(dw_insert.GetItemString(1,'maincd'))
	If IsNull(sMainCd) Or sMainCd = '' Then sMainNam = ''

	SELECT MCHNAM INTO :sMainNam
	  FROM MCHMST
	 WHERE SABU = :gs_sabu AND
	       MCHNO = :sMainCd;
	
	dw_insert.SetItem(1, 'maincd_nam', sMainNam)
	
	p_tdel.Enabled = True
	p_1.Enabled = True
	p_tdel.PictureName = "c:\erpman\image\전체삭제_up.gif"
	p_1.PictureName = "c:\erpman\image\지급이력_up.gif"
	
	
	dw_ins1.Retrieve(gs_sabu, s_mchno)
	w_mdi_frame.sle_msg.text = "수정작업을 진행하세요!!"
	
	wf_load_image()
//	cb_1.TriggerEvent(clicked!)
end if	
dw_insert.SetColumn("gubun")
dw_insert.SetFocus() 
dw_insert.SetRedraw(True)
end event

type p_del from w_inherite`p_del within w_pdt_06000
integer x = 4393
integer y = 1760
boolean enabled = false
boolean originalsize = true
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;long lcRow
Boolean fg

lcRow = dw_ins1.GetRow()

if lcRow < 1 then 
	messagebox('확 인', '삭제할 자료를 선택하세요!')
	return 
end if

if f_msg_delete() = -1 then return

if IsNull(dw_ins1.object.sabu[lcRow]) or dw_ins1.object.sabu[lcRow] = "" then
	fg = False
else
	fg = True
end if	
dw_ins1.DeleteRow(lcRow)

if fg = True then
   if dw_ins1.Update(false, true) <> 1 then
      ROLLBACK;
	   f_message_chk(31,'[삭제실패 : 설비자재 등록]') 
	   w_mdi_frame.sle_msg.text = "삭제 작업 실패!"
	   Return
   else
      COMMIT;		
		dw_ins1.ResetUpdate()
   end if
end if

w_mdi_frame.sle_msg.text = "삭제 되었습니다!"

end event

type p_mod from w_inherite`p_mod within w_pdt_06000
integer x = 3822
integer y = 20
end type

event p_mod::clicked;call super::clicked;String pedat, stopdat, ls_no
Long   icnt

if dw_insert.AcceptText() = -1 then return
if dw_ins1.AcceptText() = -1 then return

if wf_required_chk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return
ls_no = dw_insert.GetItemString(1,'mchno')

IF dw_insert.Update(true, false) > 0 THEN		
	IF dw_ins1.Update(true, false) > 0 THEN		
	   COMMIT;
		dw_insert.ResetUpdate()
		dw_ins1.ResetUpdate()
	   w_mdi_frame.sle_msg.text = "저장 되었습니다!"
		p_tdel.Enabled = True
		p_1.Enabled = True
		p_tdel.PictureName = "c:\erpman\image\전체삭제_up.gif"
		p_1.PictureName = "c:\erpman\image\지급이력_up.gif"

		///////////////////////////////////////////////////////////////////////////////////////////////
		Select count(*) Into :iCnt From lw_mchmes_image
		 Where sabu = :gs_sabu And mchgb = '1' And mchno = :ls_no   ;
		 
		If iCnt = 0 Then
			Insert Into lw_mchmes_image
			( sabu,				mchgb,		mchno )
			Values
			( :gs_sabu,			'1',			:ls_no ) ;
						
			if sqlca.sqlcode <> 0 then
				rollback ;
				messagebox("확인", "설비 이미지 저장 실패!!!")
				return
			end if
		End If
		///////////////////////////////////////////////////////////////////////////////////////////////

	ELSE
	   ROLLBACK;
	   f_message_chk(32, "[저장실패-ins1]")
	   w_mdi_frame.sle_msg.text = "저장작업 실패!"
   END IF
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패-insert]")
	w_mdi_frame.sle_msg.text = "저장작업 실패!"
END IF

//최종수정일 UPDATE
update mchmst
	set msq_date = to_char(sysdate,'YYYYMMDD'),
		 msqyn    = to_char(sysdate,'hh24mi')
 where sabu     = :gs_sabu
	and mchno    = :ls_no;
commit;

wf_save_image()

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_exit from w_inherite`cb_exit within w_pdt_06000
integer x = 4302
integer y = 5000
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06000
integer x = 4279
integer y = 5000
integer taborder = 80
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06000
integer x = 503
integer y = 5000
integer taborder = 130
end type

type cb_del from w_inherite`cb_del within w_pdt_06000
integer x = 919
integer y = 5000
integer taborder = 60
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_pdt_06000
integer x = 2318
integer y = 5000
end type

type cb_print from w_inherite`cb_print within w_pdt_06000
integer x = 869
integer y = 5000
integer taborder = 140
end type

type st_1 from w_inherite`st_1 within w_pdt_06000
long backcolor = 12632256
end type

type cb_can from w_inherite`cb_can within w_pdt_06000
integer x = 4274
integer y = 5000
integer taborder = 100
end type

type cb_search from w_inherite`cb_search within w_pdt_06000
integer x = 2510
integer y = 44
integer width = 334
integer taborder = 110
boolean enabled = false
string text = "IMAGE"
end type



type sle_msg from w_inherite`sle_msg within w_pdt_06000
long backcolor = 12632256
end type

type gb_10 from w_inherite`gb_10 within w_pdt_06000
integer x = 27
integer y = 2428
long backcolor = 12632256
end type

type gb_button1 from w_inherite`gb_button1 within w_pdt_06000
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06000
end type

type dw_ins1 from u_key_enter within w_pdt_06000
event ue_key pbm_dwnkey
integer x = 50
integer y = 1768
integer width = 4110
integer height = 492
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_pdt_06000_02"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;Long nRow

nRow = GetRow()
If nRow <= 0 Then Return

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

Choose Case GetColumnName()
	/* 품번 */
	Case "itnbr"
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow, "itnbr", gs_code)
		SetColumn('itnbr')
		PostEvent(ItemChanged!)
End Choose
end event

event itemerror;return 1
end event

event itemchanged;Long nRow, ireturn
String sItnbr, sItdsc, sIspec, sIspec_code, sJijil, sNull

nRow = GetRow()
If nRow <= 0 then Return

SetNull(sNull)

Choose Case GetColumnName()
	/* 품번 */
	Case	"itnbr" 
		sItnbr  = Trim(GetText())
		ireturn = f_get_name4('품번', 'Y', sItnbr, sItdsc, sIspec, sJijil, sIspec_code)
		SetItem(nRow, "itnbr", sItnbr)
		SetItem(nRow, "itdsc", sItdsc)
		SetItem(nRow, "ispec", sIspec)
		SetItem(nRow, "jijil", sJijil)
		SetItem(nRow, "Ispec_code", sIspec_code)
		RETURN ireturn
   Case "itdsc"	
		sitdsc = trim(this.GetText())
		ireturn = f_get_name4('품명', 'Y', sItnbr, sItdsc, sIspec, sJijil, sIspec_code)
		SetItem(nRow, "itnbr", sItnbr)
		SetItem(nRow, "itdsc", sItdsc)
		SetItem(nRow, "ispec", sIspec)
		SetItem(nRow, "jijil", sJijil)
		SetItem(nRow, "Ispec_code", sIspec_code)
		RETURN ireturn
   Case "ispec"	
		sispec = trim(this.GetText())
		ireturn = f_get_name4('규격', 'Y', sItnbr, sItdsc, sIspec, sJijil, sIspec_code)
		SetItem(nRow, "itnbr", sItnbr)
		SetItem(nRow, "itdsc", sItdsc)
		SetItem(nRow, "ispec", sIspec)
		SetItem(nRow, "jijil", sJijil)
		SetItem(nRow, "Ispec_code", sIspec_code)
		RETURN ireturn
   Case "jijil"	
		sjijil = trim(this.GetText())
		ireturn = f_get_name4('재질', 'Y', sItnbr, sItdsc, sIspec, sJijil, sIspec_code)
		SetItem(nRow, "itnbr", sItnbr)
		SetItem(nRow, "itdsc", sItdsc)
		SetItem(nRow, "ispec", sIspec)
		SetItem(nRow, "jijil", sJijil)
		SetItem(nRow, "Ispec_code", sIspec_code)
		RETURN ireturn
   Case "ispec_code"	
		sispec_code = trim(this.GetText())
		ireturn = f_get_name4('규격코드', 'Y', sItnbr, sItdsc, sIspec, sJijil, sIspec_code)
		SetItem(nRow, "itnbr", sItnbr)
		SetItem(nRow, "itdsc", sItdsc)
		SetItem(nRow, "ispec", sIspec)
		SetItem(nRow, "jijil", sJijil)
		SetItem(nRow, "Ispec_code", sIspec_code)
		RETURN ireturn
End Choose

end event

event clicked;call super::clicked;if row < 1 and row > this.RowCount() then
	p_del.Enabled = False
	p_del.PictureName = "c:\erpman\image\삭제_d.gif"
else
	p_del.Enabled = True
	p_del.PictureName = "c:\erpman\image\삭제_up.gif"
end if	

end event

type st_2 from statictext within w_pdt_06000
integer x = 46
integer y = 1692
integer width = 722
integer height = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "[SPARE PART LIST]"
boolean focusrectangle = false
end type

type p_tdel from uo_picture within w_pdt_06000
integer x = 3995
integer y = 20
integer width = 178
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\전체삭제_d.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;picturename = "C:\erpman\image\전체삭제_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = "C:\erpman\image\전체삭제_dn.gif"
end event

event clicked;call super::clicked;long lcRow
String mchno

mchno = dw_insert.object.mchno[1]

//삭제 가능여부 체크가 있어야 함 
if wf_delete_chk(mchno) = -1 then return 

if f_msg_delete() = -1 then return

lcRow = dw_insert.GetRow()
dw_insert.DeleteRow(lcRow)
for lcRow = 1 to dw_ins1.RowCount()
	dw_ins1.DeleteRow(lcRow)
next	

if dw_insert.Update() <> 1 then
   ROLLBACK;
	f_message_chk(31,'[삭제실패 : 설비마스터]') 
	w_mdi_frame.sle_msg.text = "삭제 작업 실패!"
	Return
else
   if dw_ins1.Update() <> 1 then
      ROLLBACK;
	   f_message_chk(31,'[삭제실패 : 설비자재]') 
	   w_mdi_frame.sle_msg.text = "삭제 작업 실패!"
	   Return
   else
      COMMIT;		
   end if
end if

p_can.triggerevent(clicked!)

end event

type p_1 from uo_picture within w_pdt_06000
boolean visible = false
integer x = 1536
integer y = 16
integer width = 178
boolean bringtotop = true
boolean enabled = false
string picturename = "c:\erpman\image\지급이력_d.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\지급이력_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\지급이력_dn.gif"
end event

event clicked;call super::clicked;if dw_insert.accepttext() = -1 then return 

string sSabu

sSabu = dw_insert.getitemstring(1, "sabu")

if sSAbu = '' or isnull(sSabu) then 
	messagebox('확 인', '자료를 저장 후 처리하세요!.')
	return 
end if

gs_code = dw_insert.getitemstring(1, "mchno")
open(w_pdt_06000_01)
end event

type p_2 from uo_picture within w_pdt_06000
boolean visible = false
integer x = 46
integer y = 20
integer width = 178
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\자동채번_up.gif"
end type

event clicked;call super::clicked;///////////////////////////////  자동채번 /////////////////////////////////////////
Long   lMchno
String skegbn, ls_max, sGubun

if dw_insert.accepttext() = -1 then return 

skegbn = trim(dw_insert.Getitemstring(1, 'kegbn'))

if skegbn = 'Y' then      //교정 'G'로 시작
   sGubun = 'G' 

	SELECT MAX(SUBSTR(MCHNO, 2, 5))
	  INTO :ls_max    
	  FROM MCHMST
	 WHERE SABU  = :gs_sabu 
		AND MCHNO LIKE 'G%'
		AND SUBSTR(MCHNO, 2, 5) BETWEEN '00000' AND '99999' ;
elseif skegbn = 'N' then  //비교정(설비) 'M'으로 시작
   sGubun = 'M' 

	SELECT MAX(SUBSTR(MCHNO, 2, 5))
	  INTO :ls_max    
	  FROM MCHMST
	 WHERE SABU  = :gs_sabu 
		AND MCHNO LIKE 'M%'
		AND SUBSTR(MCHNO, 2, 5) BETWEEN '00000' AND '99999' ;
end if
	
IF  IsNull(ls_max) or IsNumber(ls_max) = false  THEN
	 ls_max = '00000'
end if 

lMchno = long(ls_max) + 1

if lMchno > 99999 then 
	messagebox('확 인', '채번할 번호가 유효값에 범위를 넘었습니다. 자료를 확인하세요!')
	return 0
end if

dw_insert.setitem(1, "mchno", sGubun + string(lMchno, '00000'))

p_inq.TriggerEvent(Clicked!)


end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\erpman\image\자동채번_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "C:\erpman\image\자동채번_dn.gif"
end event

type p_add from uo_picture within w_pdt_06000
integer x = 4215
integer y = 1760
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;Long crow

dw_ins1.Setredraw(False)
crow = dw_ins1.InsertRow(dw_ins1.GetRow() + 1)
if IsNull(crow) then 
	crow = dw_ins1.InsertRow(0)
end if	
dw_ins1.ScrollToRow(crow)
dw_ins1.Setredraw(True)
dw_ins1.SetColumn("itnbr")
dw_ins1.SetFocus()
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\erpman\image\추가_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "C:\erpman\image\추가_dn.gif"
end event

type p_3 from uo_picture within w_pdt_06000
boolean visible = false
integer x = 1719
integer y = 12
integer width = 178
boolean bringtotop = true
boolean enabled = false
string picturename = "c:\erpman\image\도면관리_up.gif"
end type

event clicked;call super::clicked;string ls_mchno

setnull(gs_gubun)
setnull(gs_code)
if dw_insert.accepttext() = -1 then return 

gs_code = dw_insert.GetItemString(1, 'mchno')
gs_codename = dw_insert.GetItemString(1, 'mchnam')
gs_gubun = 'N'
Open(w_adt_01150_1)

end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\도면관리_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\도면관리_up.gif"
end event

type p_img from picture within w_pdt_06000
integer x = 3013
integer y = 216
integer width = 1490
integer height = 1448
boolean bringtotop = true
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pdt_06000
boolean visible = false
integer x = 2075
integer y = 44
integer width = 402
integer height = 84
integer taborder = 120
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "도면"
end type

event clicked;string  ls_mchno, ls_mapno, ls_rev_no, ls_file_path, ls_file_nm, ls_save_path, ls_rev_dat
long    ll_FileLength, ll_rtn
blob    imagedata, imagedata2
int     li_TotalWrites, li_FileNum, loops, fnum, i

imagedata = Blob(Space(0))
imagedata = imagedata2
p_img.picturename = ''
if dw_insert.accepttext() = -1 then return -1

ls_mchno = dw_insert.GetItemString(1,'mchno')
if ls_mchno = "" or isNull(ls_mchno) then return

select a.mapno,
       a.rev_no,
		 a.rev_dat
  into :ls_mapno, :ls_rev_no, :ls_rev_dat
  from (	  SELECT MAPNO,
						REV_NO,
						REV_DAT
				 FROM MCHMAP
				WHERE MCHNO = :ls_mchno
			ORDER BY REV_DAT DESC) a
 where rownum < 2;

//파일종류
SELECT FILE_NM  INTO :ls_file_nm FROM MCHMAP
 WHERE MCHNO  = :ls_mchno
   AND MAPNO  = :ls_mapno
   AND REV_NO = :ls_rev_no;

ls_save_path = "C:\erpman\" + ls_file_nm

//PC 임시저장 삭제
FileDelete(is_del_path)
is_del_path     = '' 
 
//이미지 DB => DISPLAY
SELECTBLOB IMAGE  INTO :imagedata FROM MCHMAP
	  WHERE MCHNO  = :ls_mchno
	    AND MAPNO  = :ls_mapno
		 AND REV_NO = :ls_rev_no;

ll_FileLength = Len(imagedata)

IF IsNull(imagedata) or len(imagedata) <= 0 THEN 
   return
END IF

IF ll_FileLength > 32765 THEN
  IF Mod(ll_FileLength, 32765) = 0 THEN
     loops = ll_FileLength/32765
  ELSE
     loops = (ll_FileLength/32765) + 1
  END IF
ELSE
  loops = 1
END IF

ls_file_path = ls_save_path
fnum = FileOpen(ls_file_path, StreamMode!, Write!, Shared!, Replace!)

// Read the file
FOR i = 1 to loops
   ll_rtn = FileWrite(fnum, imagedata)
   if ll_rtn=32765 then
      imagedata = BlobMid(imagedata, 32766)
   end if
NEXT

FileClose(fnum)

p_img.picturename = ls_save_path
is_del_path     = ls_save_path
end event

type p_img_in from picture within w_pdt_06000
integer x = 3333
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\그림등록.gif"
boolean focusrectangle = false
string powertiptext = "Image등록"
end type

event clicked;String	sPath, sFileName
Int 		iRtn, iFHandle, i
Long		lFileLen, lLoops, lReadBytes
Blob		blobTot, blobA


iRtn = GetFileOpenName("이미지 파일지정",sPath,sFileName,"IMAGE","Bitmap Files (*.BMP),*.BMP,JPEG Files (*.JPG),*.JPG")
If iRtn = 1 Then
	lFileLen = FileLength(sPath)
	iFHandle = FileOpen(sPath, StreamMode!, Read!, LockRead!)

	if iFHandle <> -1 then
		////////////////////////////////////////////////////////////////////////////////////////
		// 파일size가 FileRead 한도를 초과하는 경우 처리
		if lFileLen > 32765 then
			if Mod(lFileLen, 32765) = 0 then
				lLoops = lFileLen/32765
			else
				lLoops = (lFileLen/32765) + 1
			end if		
		else
			lLoops = 1		
		end if


		////////////////////////////////////////////////////////////////////////////////////////
		FOR i = 1 to lLoops
			lReadBytes = FileRead(iFHandle, blobA)
			blobTot    = blobTot + blobA
		NEXT

		FileClose(iFHandle)
		
		iblobBMP = blobTot
		p_img.SetPicture(blobTot)
		p_img.Visible = True
	end if
elseif iRtn = -1 Then
	p_img.Visible = False
	Return
End If
end event

type p_5 from picture within w_pdt_06000
integer x = 3159
integer y = 20
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\그림취소.gif"
boolean focusrectangle = false
end type

event clicked;Long   row

row = dw_insert.GetRow()
If row < 1 Then Return

If MessageBox('이미지 삭제', '해당 이미지를 삭제 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return

String ls_mchno

ls_mchno = dw_insert.GetItemString(row, 'mchno')
If Trim(ls_mchno) = '' OR IsNull(ls_mchno) Then
	MessageBox('확인', '선택된 설비코드가 없습니다.')
	Return
End If

Long   ll_cnt
SELECT COUNT('X')
  INTO :ll_cnt
  FROM LW_MCHMES_IMAGE
 WHERE SABU  = :gs_sabu
   AND MCHGB = '1'
	AND MCHNO = :ls_mchno ;
If ll_cnt < 1 OR IsNull(ll_cnt) Then
	MessageBox('이미지 확인', '등록된 이미지가 없습니다.')
	Return
End If

DELETE LW_MCHMES_IMAGE
 WHERE SABU  = :gs_sabu
   AND MCHGB = '1'
	AND MCHNO = :ls_mchno ;
If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
Else
	ROLLBACK USING SQLCA;
	MessageBox('삭제 실패', '이미지 삭제 중 오류가 발생했습니다.')
End If

p_inq.TriggerEvent(Clicked!)
end event

type rr_1 from roundrectangle within w_pdt_06000
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 1764
integer width = 4155
integer height = 528
integer cornerheight = 40
integer cornerwidth = 55
end type

