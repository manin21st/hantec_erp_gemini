$PBExportHeader$w_qct_06030.srw
$PBExportComments$계측기 정기점검 실시결과 등록
forward
global type w_qct_06030 from w_inherite
end type
type gb_6 from groupbox within w_qct_06030
end type
type gb_5 from groupbox within w_qct_06030
end type
type gb_4 from groupbox within w_qct_06030
end type
type gb_3 from groupbox within w_qct_06030
end type
type rb_1 from radiobutton within w_qct_06030
end type
type rb_2 from radiobutton within w_qct_06030
end type
type dw_1 from datawindow within w_qct_06030
end type
type dw_list from datawindow within w_qct_06030
end type
type gb_2 from groupbox within w_qct_06030
end type
type gb_1 from groupbox within w_qct_06030
end type
type dw_item from datawindow within w_qct_06030
end type
type st_2 from statictext within w_qct_06030
end type
type st_3 from statictext within w_qct_06030
end type
type st_4 from statictext within w_qct_06030
end type
type st_yymm from statictext within w_qct_06030
end type
end forward

global type w_qct_06030 from w_inherite
integer height = 2420
string title = "계측기 정기점검 실시결과 등록"
gb_6 gb_6
gb_5 gb_5
gb_4 gb_4
gb_3 gb_3
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
dw_list dw_list
gb_2 gb_2
gb_1 gb_1
dw_item dw_item
st_2 st_2
st_3 st_3
st_4 st_4
st_yymm st_yymm
end type
global w_qct_06030 w_qct_06030

type variables
char    ic_status
string   is_MaxYymm //최종수불마감년월


end variables

forward prototypes
public function integer wf_required_chk ()
public function integer wf_lastday_chk (string gubun)
public function integer wf_retrieve (string sdate, string smchno, integer iseq)
end prototypes

public function integer wf_required_chk ();String sSidat, smchno, scode, siojpno
Int    iseq, i, irow, iJpno
long   lJpno
dec{2} dTime

sSidat = trim(dw_insert.object.sidat[1])
if IsNull(ssidat) or ssidat = "" then
	f_message_chk(1400, "[실시일자]")
	dw_insert.SetColumn("sidat")
	dw_insert.SetFocus()
   Return -1
end if

smchno = trim(dw_insert.object.mchno[1])
if IsNull(smchno) or smchno = "" then
	f_message_chk(1400, "[관리번호]")
	dw_insert.SetColumn("mchno")
	dw_insert.SetFocus()
   Return -1
end if

iseq   = dw_insert.object.seq[1]
if IsNull(iseq) or iseq = 0 then
	f_message_chk(1400, "[점검번호]")
	dw_insert.SetColumn("seq")
	dw_insert.SetFocus()
   Return -1
end if

scode = trim(dw_insert.object.inspbody[1])
if IsNull(scode) or scode = "" then
	f_message_chk(1400, "[점검부위]")
	dw_insert.SetColumn("inspbody")
	dw_insert.SetFocus()
   Return -1
end if
scode = trim(dw_insert.object.insplist[1])
if IsNull(scode) or scode = "" then
	f_message_chk(1400, "[점검항목]")
	dw_insert.SetColumn("insplist")
	dw_insert.SetFocus()
   Return -1
end if
scode = trim(dw_insert.object.rsltxt[1])
if IsNull(scode) or scode = "" then
	f_message_chk(1400, "[점검내용]")
	dw_insert.SetColumn("rsltxt")
	dw_insert.SetFocus()
   Return -1
end if

scode = dw_insert.object.iegbn[1]
if IsNull(scode) or scode = "" then
	f_message_chk(1400, "[사내/외 구분]")
	dw_insert.SetColumn("iegbn")
	dw_insert.SetFocus()
   Return -1
elseif scode = '2' then  //사외인 경우 
	scode = trim(dw_insert.object.cvcod[1])
	if IsNull(scode) or scode = "" then
		f_message_chk(1400, "[거래처]")
		dw_insert.SetColumn("cvcod")
		dw_insert.SetFocus()
		Return -1
	end if
end if

scode = dw_insert.object.rslcod[1]
if IsNull(scode) or scode = "" or scode = 'W' then
	f_message_chk(1400, "[점검결과]")
	dw_insert.SetColumn("rslcod")
	dw_insert.SetFocus()
   Return -1
end if

scode = trim(dw_insert.object.chkman[1])
if IsNull(scode) or scode = ""  then
	f_message_chk(1400, "[점검자]")
	dw_insert.SetColumn("chkman")
	dw_insert.SetFocus()
   Return -1
end if

dTime = dw_insert.object.sutim[1]
if IsNull(dTime) or dTime <= 0  then
	f_message_chk(1400, "[점검시간]")
	dw_insert.SetColumn("sutim")
	dw_insert.SetFocus()
   Return -1
end if

iJpno = 0
irow = dw_item.RowCount()
For i = 1 to iRow
	if IsNull(Trim(dw_item.object.itnbr[i])) or Trim(dw_item.object.itnbr[i]) = "" then
		f_message_chk(1400,"[품번]")
		dw_item.SetRow(i)
		dw_item.SetColumn("itnbr")
		dw_item.SetFocus()
		return -1
	end if
	
	if IsNull(dw_item.object.qtypr[i]) or dw_item.object.qtypr[i] <= 0 then
		f_message_chk(1400,"[사용수량]")
		dw_item.SetRow(i)
		dw_item.SetColumn("qtypr")
		dw_item.SetFocus()
		return -1
	end if

	if IsNull(Trim(dw_item.object.depot_no[i])) or Trim(dw_item.object.depot_no[i]) = "" then
      f_message_chk(30,"[출고창고]")
		dw_item.SetRow(i)
		dw_item.SetColumn("depot_no")
		dw_item.SetFocus()
	   return -1
	end if	
	
	//입출고전표번호
	if IsNull(Trim(dw_item.object.iojpno[i])) or Trim(dw_item.object.iojpno[i]) = "" then
		IF iJpno < 1 THEN 
			lJpno = SQLCA.FUN_JUNPYO(gs_sabu, ssidat, 'C0')
			IF lJpno < 1 then 
				messagebox('확 인', '전표채번을 실패하였습니다. 전산실에 문의하세요!')
				return -1
			ELSE
				COMMIT ;
			END IF
			siojpno = String(lJpno, "0000") 
			iJpno = 1 
		ELSE
			iJpno ++ 
		END IF
		dw_item.object.iojpno[i] = ssidat + siojpno + String(iJpno, "000") 
		dw_item.object.sabu[i]  = gs_sabu
		dw_item.object.sidat[i] = ssidat
		dw_item.object.mchno[i] = smchno
		dw_item.object.gubun[i] = '2'
		dw_item.object.seqno[i] = iseq
   end if	
next

Return 1 


end function

public function integer wf_lastday_chk (string gubun);String smchno, sLastdate, sSidate, sUpdate
Long   i, iseq

smchno  = Trim(dw_insert.object.mchno[1])
iseq    = dw_insert.object.seq[1]
sSidate = dw_insert.object.sidat[1]

if gubun = 'U' then //저장시
	select m.lastinsp
	  into :sLastdate
	  from mchmst_insp m
	 where m.sabu    = :gs_sabu 
		and m.mchno   = :smchno 
		and m.seq     = :iseq 
		and m.inspday = '2'; 
	
	if sqlca.sqlcode <> 0 then 
		return -1
	else
		IF sLastdate >= sSidate then
			return 1
		ELSE
			sUpdate = sSidate
		END IF
	end if
else //삭제시
	
  SELECT MAX(A.SIDAT)  
    into :sUpdate
    FROM MCHRSL A 
   WHERE A.SABU  = :gs_sabu
     AND A.GUBUN = '2'
     AND A.MCHNO = :smchno 
     AND A.SEQ   = :iseq 
     AND A.RSLCOD <> 'W' 
     AND NOT EXISTS ( SELECT SABU 
                        FROM MCHRSL
                       WHERE SABU  = A.SABU
                         AND SIDAT = A.SIDAT
                         AND GUBUN = A.GUBUN
                         AND MCHNO = A.MCHNO
                         AND SEQ   = A.SEQ
                         AND SABU  = :gs_sabu
                         AND SIDAT = :sSidate
                         AND GUBUN = '2' 
                         AND MCHNO = :smchno 
                         AND SEQ   = :iseq ) ;
								 
	if isnull(sUpdate) or sUpdate = '' then  //최종일이 없거나 null이면 현재일 setting 
	   sUpdate = is_today                    //이론상 없을 수가 없음
   end if	
end if
	
Update mchmst_insp set lastinsp = :sUpdate
 where sabu    = :gs_sabu 
	and mchno   = :smchno
	and seq     = :iseq 
	and inspday = '2' ; 
 
if sqlca.sqlcode <> 0 then
	return -1
end if

return 1

end function

public function integer wf_retrieve (string sdate, string smchno, integer iseq);if dw_insert.Retrieve(gs_sabu, sDate, '2', sMchno, iseq) < 1 then 
	dw_insert.insertrow(0)
	dw_insert.setitem(1, "sidat", is_today)
	f_message_chk(50, '')
else
	IF dw_insert.getitemstring(1, 'old_rslcod') <> 'W' then 
		cb_del.enabled = true 
	ELSE
		cb_del.enabled = FALSE 
	END IF
end if

dw_item.Retrieve(gs_sabu, sDate, '2', sMchno, iseq)


Return 1

end function

on w_qct_06030.create
int iCurrent
call super::create
this.gb_6=create gb_6
this.gb_5=create gb_5
this.gb_4=create gb_4
this.gb_3=create gb_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.dw_list=create dw_list
this.gb_2=create gb_2
this.gb_1=create gb_1
this.dw_item=create dw_item
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_yymm=create st_yymm
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_6
this.Control[iCurrent+2]=this.gb_5
this.Control[iCurrent+3]=this.gb_4
this.Control[iCurrent+4]=this.gb_3
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.dw_list
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.dw_item
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.st_4
this.Control[iCurrent+15]=this.st_yymm
end on

on w_qct_06030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_6)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.dw_item)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_yymm)
end on

event open;call super::open;dw_item.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_insert.settransobject(sqlca)
dw_insert.reset()
dw_insert.insertrow(0)
dw_insert.setitem(1, "sidat", is_today)

dw_1.insertrow(0)
dw_1.setitem(1, "from_date", is_today)
dw_1.setitem(1, "to_date", is_today)
dw_1.setcolumn("from_date")
dw_1.setfocus()

SELECT MAX("JUNPYO_CLOSING"."JPDAT") 
  INTO :is_MaxYymm
  FROM "JUNPYO_CLOSING"  
 WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		 ( "JUNPYO_CLOSING"."JPGU" = 'C0' )    ;

st_yymm.text = string(is_MaxYymm, '@@@@.@@')




end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_list.scrollpriorpage()
	case keypagedown!
		dw_list.scrollnextpage()
	case keyhome!
		dw_list.scrolltorow(1)
	case keyend!
		dw_list.scrolltorow(dw_list.rowcount())
	case KeyupArrow!
		dw_list.scrollpriorrow()
	case KeyDownArrow!
		dw_list.scrollnextrow()		
end choose


end event

type dw_insert from w_inherite`dw_insert within w_qct_06030
integer x = 1806
integer y = 60
integer width = 1751
integer height = 1224
integer taborder = 50
string dataobject = "d_qct_06030_3"
end type

event dw_insert::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if	this.getcolumnname() = "mchno" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
	open(w_mchno_popup)
		
	If IsNull(gs_code) Or gs_code = '' Then Return
	
	this.SetItem(1, "mchno", gs_code)
	this.SetItem(1, "mchmst_mchnam", gs_codename)
	this.triggerevent(itemchanged!)
	
elseif this.GetColumnName() = "mchmst_buncd" then
	
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.mchmst_buncd[1] = gs_code
	this.triggerevent(itemchanged!)
		
elseif this.getcolumnname() = "seq" then
	gs_code = this.getitemstring(1, 'mchno')

	open(w_pdt_06100_popup)
	
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "mchno", gs_code)
	this.SetItem(1, "mchmst_mchnam", gs_codename)
	this.SetItem(1, "seq",   gi_page)
	this.triggerevent(itemchanged!)
elseif this.getcolumnname() = "chkman" then
	open(w_sawon_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "chkman", gs_code)
	this.SetItem(1, "empname", gs_codename)
elseif this.getcolumnname() = "cvcod" then
	gs_gubun = '1' 
	open(w_vndmst_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "cvcod", gs_code)
	this.SetItem(1, "cvnas2", gs_codename)
end if


end event

event dw_insert::itemchanged;call super::itemchanged;String s_cod, s_nam1, s_nam2, sNull, sInsplist, sInspbody, buncd, ls_mchno, ls_mchnam
Int    iReturn, iNull, iSeq

SetNull(sNull)
SetNull(iNull)

if this.getcolumnname() = "sidat" then 
	s_cod = Trim(this.gettext())
   if s_cod = "" or IsNull(s_cod) then	return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[실시일자]")
		this.object.sidat[1] = ""
		return 1
	end if
ELSEIF this.GetColumnName() = 'chkman' THEN
   s_cod = this.gettext()
	ireturn = f_get_name2('사번', 'Y', s_cod, s_nam1, s_nam2)	 
	this.setitem(1, "chkman",  s_cod)
	this.setitem(1, "empname", s_nam1)
	return ireturn 			
ELSEIF this.GetColumnName() = 'cvcod' THEN
   s_cod = this.gettext()
	ireturn = f_get_name2('V0', 'Y', s_cod, s_nam1, s_nam2)	 
	this.setitem(1, "cvcod",  s_cod)
	this.setitem(1, "cvnas2", s_nam1)
	return ireturn 			
ELSEIF this.GetColumnName() = 'iegbn' THEN
   s_cod = this.gettext()
   if s_cod = '1' then 
		this.setitem(1, "cvcod",  snull)
		this.setitem(1, "cvnas2", snull)
		this.setitem(1, "damnm",  snull)
	end if
ELSEIF this.GetColumnName() = 'mchno' THEN
	s_cod = GetText()
	If IsNull(s_cod) Or s_cod = '' Then
		SetItem(1, 'mchmst_mchnam', sNull)
		SetItem(1, 'mchmst_buncd', sNull)
		SetItem(1, 'seq', iNull)
		return 
	End If

	SELECT MCHNAM  ,  BUNCD
	  INTO :s_nam1 ,  :buncd
	  FROM MCHMST
	 WHERE SABU  = :gs_sabu 
	   AND MCHNO = :s_cod;
		
	If sqlca.sqlcode <> 0 Then
		f_message_chk(33, "[관리번호]")
		SetItem(1, 'mchno', sNull)
		SetItem(1, 'mchmst_mchnam', sNull)
		SetItem(1, 'mchmst_buncd', sNull)
		SetItem(1, 'seq', iNull)
		Return 1
	End If
	
	SetItem(1, 'mchmst_mchnam', s_nam1)
	SetItem(1, 'mchmst_buncd', buncd )
	SetItem(1, 'seq', iNull)
ELSEIF this.GetColumnName() = 'seq' THEN
	iSeq = integer(GetText())
	If IsNull(iSeq) Or iSeq = 0 Then	return 

   s_cod = this.getitemstring(1, 'sidat')
   IF s_cod = '' or isnull(s_cod) then
		messagebox('확 인', '실시일자를 먼저 입력하세요!')
		SetItem(1, 'seq', iNull)
		SetColumn('sidat')
		return 1
	End If
	
   s_nam1 = this.getitemstring(1, 'mchno')
   IF s_nam1 = '' or isnull(s_nam1) then
		messagebox('확 인', '관리번호를 먼저 입력하세요!')
		SetItem(1, 'seq', iNull)
		SetColumn('mchno')
		return 1
	End If
	
	SELECT "RSLCOD"  
     INTO :s_nam2  
     FROM "MCHRSL"  
    WHERE "SABU"  = :gs_sabu 
	   AND "SIDAT" = :s_cod
		AND "GUBUN" = '2' 
		AND "MCHNO" = :s_nam1
		AND "SEQ"   = :iseq   ;

   IF sqlca.sqlcode = 0 then 
		IF MessageBox('확 인', '등록된 정기점검 자료입니다. 자료를 조회하시겠습니까?', &
			                    Question!,YesNo!,1) = 1 THEN 
			wf_retrieve(s_cod, s_nam1, iseq)
			return 1
		ELSE
			SetItem(1, 'seq', iNull)
			return 1
		END IF
	END IF
	
   SELECT "INSPBODY", "INSPLIST"  
     INTO :sInspbody, :sInsplist
     FROM "MCHMST_INSP"  
    WHERE "SABU"  = :gs_sabu
	   AND "MCHNO" = :s_nam1
		AND "SEQ"   = :iseq  
      AND "INSPDAY" IN ('1', '2') 
		AND ROWNUM = 1 ;
		
   IF sqlca.sqlcode = 0 then 
		SetItem(1, 'inspbody', sinspbody)
		SetItem(1, 'insplist', sinsplist)
	ELSE
		MessageBox('확 인', '등록되지 않은 설비점검기준 자료입니다. 자료를 확인하세요') 
		SetItem(1, 'seq', iNull)
		return 1
	END IF

elseif this.GetColumnName() = "mchmst_buncd" then    // 계측기 관리번호
	s_cod = this.gettext()
	if IsNull(s_cod) or s_cod = "" then
		this.object.mchno[1] = ""
		this.object.mchmst_mchnam[1] = ""
	   return 
	end if
		
	SELECT mchno, mchnam   
	INTO :ls_mchno, :ls_mchnam
   FROM mchmst
	WHERE KEGBN = 'Y'
	AND   BUNCD = :s_cod ; 
	
	if sqlca.sqlcode <> 0  then
		f_message_chk(33, '[계측기관리번호]')
      this.setitem(1,"mchno", snull )
		this.setitem(1,"mchmst_mchnam", snull)
		this.setitem(1,"mchmst_buncd",  snull)
		return  1
	end if
	
	this.setitem(1,"mchno", ls_mchno )
	this.setitem(1,"mchmst_mchnam" , ls_mchnam  )
	

END IF

end event

event dw_insert::itemerror;call super::itemerror;return 1


end event

event dw_insert::losefocus;call super::losefocus;this.accepttext()
end event

event dw_insert::ue_pressenter;if this.GetColumnName() = "insplist" or this.GetColumnName() = "rsltxt" then return

Send(Handle(this),256,9,0)
Return 1
end event

type cb_exit from w_inherite`cb_exit within w_qct_06030
integer y = 1936
integer taborder = 120
end type

type cb_mod from w_inherite`cb_mod within w_qct_06030
integer x = 2176
integer y = 1936
integer taborder = 90
end type

event cb_mod::clicked;call super::clicked;if dw_item.AcceptText() = -1 then return
if dw_insert.AcceptText() = -1 then return

if wf_required_chk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return

IF dw_insert.Update() > 0 and dw_item.Update() > 0 THEN		
	if wf_lastday_chk('U') = -1 then //최종점검일자 등록
	   ROLLBACK;
   	f_message_chk(32, "[저장실패 : 최종점검일자]")
   else
	   COMMIT;
	end if	
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
END IF

cb_can.triggerevent(clicked!)	 
end event

type cb_ins from w_inherite`cb_ins within w_qct_06030
integer x = 896
integer y = 1936
integer width = 393
integer taborder = 60
string text = "행추가(&A)"
end type

event cb_ins::clicked;call super::clicked;String sSidat, smchno
Int    iseq, lrow

if dw_insert.AcceptText() = -1 then return

sSidat = dw_insert.object.sidat[1]
smchno = dw_insert.object.mchno[1]
iseq   = dw_insert.object.seq[1]

if IsNull(ssidat) or ssidat = "" then
	f_message_chk(30, "[실시일자]")
	dw_insert.SetColumn("sidat")
	dw_insert.SetFocus()
   return
end if
if IsNull(smchno) or smchno = "" then
	f_message_chk(30, "[관리번호]")
	dw_insert.SetColumn("mchno")
	dw_insert.SetFocus()
   return
end if
if IsNull(iseq) or iseq = 0 then
	f_message_chk(30, "[점검번호]")
	dw_insert.SetColumn("seq")
	dw_insert.SetFocus()
   return
end if

lRow = dw_item.InsertRow(0)

dw_item.ScrollToRow(lRow)
dw_item.SetColumn("itnbr")
dw_item.SetFocus()

ib_any_typing = true
end event

type cb_del from w_inherite`cb_del within w_qct_06030
integer x = 2523
integer y = 1936
integer taborder = 100
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;string sSidat, sMchno, sNull
int    iseq

setnull(snull)

if dw_insert.AcceptText() = -1 then return
if dw_insert.RowCount() < 1 then return
if dw_insert.getitemstring(1, 'old_rslcod') = 'W' THEN 
   MESSAGEBOX('확 인' ,'삭제 할 자료가 아닙니다. 자료를 확인하세요!')
   RETURN 
end if

sSidat = trim(dw_insert.object.sidat[1])
smchno = trim(dw_insert.object.mchno[1])
iseq   = dw_insert.object.seq[1]

if IsNull(ssidat) or ssidat = "" then
	f_message_chk(30, "[실시일자]")
	dw_insert.SetColumn("sidat")
	dw_insert.SetFocus()
   return
end if
if IsNull(smchno) or smchno = "" then
	f_message_chk(30, "[관리번호]")
	dw_insert.SetColumn("mchno")
	dw_insert.SetFocus()
   return
end if
if IsNull(iseq) or iseq = 0 then
	f_message_chk(30, "[점검번호]")
	dw_insert.SetColumn("seq")
	dw_insert.SetFocus()
   return
end if

IF f_msg_delete() = -1 THEN	RETURN

SetPointer(HourGlass!)

DELETE FROM "MCHCHK_MTR"  
 WHERE ( "MCHCHK_MTR"."SABU"  = :gs_sabu ) AND  
		 ( "MCHCHK_MTR"."SIDAT" = :sSidat ) AND  
		 ( "MCHCHK_MTR"."MCHNO" = :sMchno ) AND  
		 ( "MCHCHK_MTR"."SEQNO" = :iseq ) AND  
		 ( "MCHCHK_MTR"."GUBUN" = '2' )   ;
		 
IF SQLCA.SQLCODE = 0	THEN	
	if wf_lastday_chk('D') = -1 then //최종점검일자 등록
	   ROLLBACK;
   	f_message_chk(32, "[저장실패 : 최종점검일자]")
		return 
	end if	
	
	IF dw_insert.getitemstring(1, 'ins_gub') = '2' then  //계획없이 임의로 생성된 자료
		DELETE FROM "MCHRSL"  
		 WHERE ( "MCHRSL"."SABU"  = :gs_sabu ) AND  
				 ( "MCHRSL"."SIDAT" = :sSidat ) AND  
				 ( "MCHRSL"."GUBUN" = '2' ) AND  
				 ( "MCHRSL"."MCHNO" = :sMchno ) AND  
				 ( "MCHRSL"."SEQ"   = :iseq )   ;
   ELSE
	   UPDATE "MCHRSL"  
         SET "IEGBN"  = '1',    
             "RSLTXT" = null,   
             "RSLCOD" = 'W',   
             "CHKMAN" = null,   
             "SUAMT"  = 0,   
             "SUTIM"  = 0,   
             "JUTIM"  = 0,   
             "WATIM"  = 0,   
             "CVCOD"  = null,   
             "DAMNM"  = null, 
				 "MEAIJ"  = null 
	    WHERE "SABU"   = :gs_sabu
		   AND "SIDAT"  = :ssidat
			AND "GUBUN"  = '2'
			AND "MCHNO"  = :sMchno
			AND "SEQ"    = :iseq ;

	END IF
	
	IF SQLCA.SQLNROWS > 0 AND SQLCA.SQLCODE = 0	THEN	
		COMMIT;
		Messagebox('확 인', '자료를 삭제하였습니다.')
	ELSE
		Rollback;
		f_rollback()
		Return 
	END IF
ELSE
	Rollback;
	Messagebox('삭제실패', '사용자재 삭제를 실패하였습니다.')
	Return 
END IF

cb_can.triggerevent(clicked!)	 
end event

type cb_inq from w_inherite`cb_inq within w_qct_06030
integer x = 73
integer y = 1936
end type

event cb_inq::clicked;call super::clicked;String sSidat, smchno
Int    iseq

if dw_insert.AcceptText() = -1 then return

sSidat = trim(dw_insert.object.sidat[1])
smchno = trim(dw_insert.object.mchno[1])
iseq   = dw_insert.object.seq[1]

if IsNull(ssidat) or ssidat = "" then
	f_message_chk(30, "[실시일자]")
	dw_insert.SetColumn("sidat")
	dw_insert.SetFocus()
   return
end if
if IsNull(smchno) or smchno = "" then
	f_message_chk(30, "[관리번호]")
	dw_insert.SetColumn("mchno")
	dw_insert.SetFocus()
   return
end if
if IsNull(iseq) or iseq = 0 then
	f_message_chk(30, "[점검번호]")
	dw_insert.SetColumn("seq")
	dw_insert.SetFocus()
   return
end if
dw_insert.setredraw(false)
wf_retrieve(ssidat, smchno, iseq)
dw_insert.setredraw(true)


end event

type cb_print from w_inherite`cb_print within w_qct_06030
integer x = 1440
integer y = 64
integer width = 297
integer height = 232
integer taborder = 20
integer textsize = -9
string text = "계획조회"
end type

event cb_print::clicked;call super::clicked;String sdatef, sdatet, sMchno1, sMchno2, buncd, buncd1

IF dw_1.AcceptText() = -1 THEN RETURN 

dw_list.setredraw(false)
dw_list.ReSet()

//dw_insert.setredraw(false)
//dw_insert.ReSet()
//dw_insert.insertrow(0)
//dw_item.ReSet()

sdatef  = TRIM(dw_1.GetItemString(1,"from_date"))
sdatet  = TRIM(dw_1.GetItemString(1,"to_date"))
buncd  = trim(dw_1.object.buncd[1])
buncd1 = trim(dw_1.object.buncd1[1])

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='10000101'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99991231'
END IF

if (IsNull(buncd) or buncd = "" ) then buncd = '.'
if (IsNull(buncd1) or buncd1 = "" ) then buncd1 = 'zzzzzzzzzzzzz' 

if rb_1.checked then 
	dw_list.SetFilter("rslcod = 'W'")
else
	dw_list.SetFilter("rslcod <> 'W'")
end if
dw_list.Filter()

dw_list.Retrieve(gs_sabu, sdatef, sdatet, buncd, buncd1)

dw_list.setredraw(true)

//dw_insert.setredraw(true)
//ib_any_typing = False //입력필드 변경여부 No

end event

type st_1 from w_inherite`st_1 within w_qct_06030
end type

type cb_can from w_inherite`cb_can within w_qct_06030
integer x = 2871
integer y = 1936
integer taborder = 110
end type

event cb_can::clicked;call super::clicked;sle_msg.text =""

dw_list.setredraw(false)
dw_insert.setredraw(false)

cb_print.triggerevent(clicked!)

dw_insert.ReSet()
dw_insert.insertrow(0)
dw_insert.setitem(1, "sidat", is_today)

dw_item.ReSet()

dw_list.setredraw(true)
dw_insert.setredraw(true)

ib_any_typing = False //입력필드 변경여부 No
cb_del.enabled = false 


end event

type cb_search from w_inherite`cb_search within w_qct_06030
integer x = 1303
integer y = 1936
integer width = 393
string text = "행삭제(&L)"
end type

event cb_search::clicked;call super::clicked;long	lrow

lRow = dw_item.GetRow()

IF lRow < 1		THEN	RETURN

dw_item.DeleteRow(lRow)

ib_any_typing = true

end event







type gb_button1 from w_inherite`gb_button1 within w_qct_06030
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_06030
end type

type gb_6 from groupbox within w_qct_06030
integer x = 859
integer y = 1884
integer width = 873
integer height = 184
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "Spare Part"
borderstyle borderstyle = stylelowered!
end type

type gb_5 from groupbox within w_qct_06030
integer x = 1778
integer width = 1806
integer height = 1308
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_4 from groupbox within w_qct_06030
integer x = 389
integer y = 4
integer width = 1381
integer height = 316
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_qct_06030
integer x = 41
integer width = 338
integer height = 320
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_qct_06030
integer x = 101
integer y = 84
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "계획"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;sle_msg.text = ""
dw_1.Modify("date_t.Text='계획일자'")
cb_print.text ='계획조회'
ic_Status = '1'

dw_list.reset()

//dw_insert.setredraw(false)
//dw_insert.reset()
//dw_insert.insertrow(0)
//dw_insert.setredraw(True)
//dw_item.reset()
//
//ib_any_typing = False //입력필드 변경여부 No
end event

type rb_2 from radiobutton within w_qct_06030
integer x = 101
integer y = 192
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "결과"
borderstyle borderstyle = stylelowered!
end type

event clicked;sle_msg.text = ""
dw_1.Modify("date_t.Text='실시일자'")
cb_print.text ='결과조회'
ic_Status = '2'

dw_list.reset()

//dw_insert.setredraw(false)
//dw_insert.reset()
//dw_insert.insertrow(0)
//dw_insert.setredraw(True)
//
//dw_item.reset()
//ib_any_typing = False //입력필드 변경여부 No
end event

type dw_1 from datawindow within w_qct_06030
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 411
integer y = 40
integer width = 1001
integer height = 260
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_06030"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;call super::itemchanged;string s_cod, ls_buncd

if this.getcolumnname() = "from_date"  then  
	s_cod = Trim(this.gettext()) 

   if s_cod = '' or isnull(s_cod) then return 
	if f_datechk(s_cod) = -1 then 
		f_message_chk(35, "[FROM 일자]" )
		this.object.from_date[1] = "" 
		return 1
	end if
elseif this.getcolumnname() = "to_date"  then  
	s_cod = Trim(this.gettext()) 

   if s_cod = '' or isnull(s_cod) then return 
	if f_datechk(s_cod) = -1 then 
		f_message_chk(35, "[TO 일자]" )
		this.object.to_date[1] = "" 
		return 1
	end if
end if
//elseif this.GetColumnName() = "buncd" then    // 계측기 관리번호
//	s_cod = Trim(this.gettext())
//	
//	if IsNull(s_cod) or s_cod = "" then return 
//		
//	SELECT buncd   
//	INTO :ls_buncd
//   FROM mchmst
//	WHERE KEGBN = 'Y'
//	AND   BUNCD = :s_cod ; 
//	   
//	if sqlca.sqlcode <> 0  then
//		f_message_chk(33, '[계측기관리번호]')
//      setitem(1 , "buncd", '')
//		return 1 
//	end if
//
//elseif this.GetColumnName() = "buncd1" then    // 계측기 관리번호
//	s_cod = Trim(this.gettext())
//	
//	if IsNull(s_cod) or s_cod = "" then return 
//		
//	SELECT buncd   
//	INTO :ls_buncd
//	FROM mchmst
//	WHERE KEGBN = 'Y'
//	AND   BUNCD = :s_cod ; 
//	
//	if sqlca.sqlcode <> 0  then
//		f_message_chk(33, '[계측기관리번호]')
//  		setitem(1 , "buncd1", '')
//		return 1 
//	end if
//	
//end if				
//		
end event

event itemerror;return 1

end event

event rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.GetColumnName() = "buncd" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd[1] = gs_code
	
elseif this.GetColumnName() = "buncd1" then
	gs_gubun = 'ALL'
	gs_code = '계측기'
	gs_codename = '계측기관리번호'
	open(w_mchno_popup)
	if isnull(gs_code) or gs_code = '' then return
	this.object.buncd1[1] = gs_code
end if
end event

type dw_list from datawindow within w_qct_06030
integer x = 41
integer y = 328
integer width = 1723
integer height = 980
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_qct_06030_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;STRING sDate, sMchno
int    iSeq

if currentrow < 1 then return 
if this.rowcount() < 1 then return 

this.setredraw(false)
dw_insert.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow) 

sDate  = dw_list.GetItemString(currentrow, "sidat")
sMchno = dw_list.GetItemString(currentrow, "mchno")
iSeq   = dw_list.GetItemNumber(currentrow, "seq")

wf_retrieve(sDate, sMchno, iseq)

this.setredraw(true)
dw_insert.setredraw(true)

end event

event clicked;STRING sDate, sMchno
int    iSeq

if row < 1 then return 
if this.rowcount() < 1 then return 

this.setredraw(false)
dw_insert.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(row,True)

this.ScrollToRow(row) 

sDate  = dw_list.GetItemString(row, "sidat")
sMchno = dw_list.GetItemString(row, "mchno")
iSeq   = dw_list.GetItemNumber(row, "seq")

wf_retrieve(sDate, sMchno, iseq)

this.setredraw(true)
dw_insert.setredraw(true)

end event

type gb_2 from groupbox within w_qct_06030
integer x = 2144
integer y = 1884
integer width = 1445
integer height = 184
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_qct_06030
integer x = 41
integer y = 1884
integer width = 398
integer height = 184
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type dw_item from datawindow within w_qct_06030
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 41
integer y = 1420
integer width = 3547
integer height = 456
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_qct_06030_4"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send(Handle(this),256,9,0)
Return 1
end event

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemerror;RETURN 1
end event

event rbuttondown;Long crow

SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

crow = this.getRow()
IF	this.getcolumnname() = "itnbr"  THEN		 
	gs_gubun = '3' 
	open(w_itemas_popup)
	if isnull(gs_code) or gs_code = '' then return 
	
	this.SetItem(crow, "itnbr", gs_code)
	this.triggerevent(itemchanged!)
	
ELSEIF this.getcolumnname() = "depot_no" THEN		
	open(w_vndmst_46_popup)
	if isnull(gs_code) or gs_code = '' then return 
	this.SetItem(crow, "depot_no", gs_code)
	this.SetItem(crow, "cvnas2", gs_codename)
END IF


end event

event itemchanged;String s_cod, s_nam1, s_nam2, s_nam3, s_nam4 , sitnbr , sitdsc, sispec, sispec_code , sjijil
Integer i_rtn 
Long crow

s_cod = Trim(this.GetText())
crow = this.GetRow()

if	this.getcolumnname() = "itnbr" then
	i_rtn = f_get_name4("품번","Y",s_cod, s_nam1, s_nam2, s_nam3, s_nam4)
	this.object.itnbr[crow] = s_cod
	this.object.itdsc[crow] = s_nam1
	this.object.ispec[crow] = s_nam2
	this.object.jijil[crow] = s_nam3
	this.object.ispec_code[crow] = s_nam4
   return i_rtn  
elseif this.getcolumnname() = "itdsc" then
   i_rtn = f_get_name4("품명", "Y", s_nam1, s_cod, s_nam2, s_nam3, s_nam4)
   this.object.itnbr[crow] = s_nam1
   this.object.itdsc[crow] = s_cod
   this.object.ispec[crow] = s_nam2
	this.object.jijil[crow] = s_nam3
	this.object.ispec_code[crow] = s_nam4
   return i_rtn  
elseif this.getcolumnname() = "ispec" then
   i_rtn = f_get_name4("규격", "Y", s_nam1, s_nam2, s_cod, s_nam3, s_nam4)
   this.object.itnbr[crow] = s_nam1
   this.object.itdsc[crow] = s_nam2
   this.object.ispec[crow] = s_cod
	this.object.jijil[crow] = s_nam3
	this.object.ispec_code[crow] = s_nam4
   return i_rtn  

ELSEIF this.GetColumnName() = "jijil"	THEN
//	sjijil = trim(this.GetText())

	i_rtn = f_get_name4('재질', 'Y', sitnbr, sitdsc, sispec, s_cod, sispec_code)	
	this.setitem(crow, "itnbr", sitnbr)	
	this.setitem(crow, "itdsc", sitdsc)	
	this.setitem(crow, "ispec", sispec)
	this.setitem(crow, "ispec_code", sispec_code)
	this.setitem(crow, "jijil", s_cod)
	RETURN i_rtn
ELSEIF this.GetColumnName() = "ispec_code"	THEN
	//sispec_code = trim(this.GetText())

	i_rtn = f_get_name4('규격코드', 'Y', sitnbr, sitdsc, sispec, sjijil, s_cod)	
	this.setitem(crow, "itnbr", sitnbr)	
	this.setitem(crow, "itdsc", sitdsc)	
	this.setitem(crow, "ispec", sispec)
	this.setitem(crow, "ispec_code", s_cod)
	this.setitem(crow, "jijil", sjijil)
	RETURN i_rtn
	
elseif this.getcolumnname() = "depot_no" then	
	i_rtn = f_get_name2("창고", "Y", s_cod, s_nam1, s_nam2)
   this.object.depot_no[crow] = s_cod
   this.object.cvnas2[crow] = s_nam1
   return i_rtn  
end if


end event

type st_2 from statictext within w_qct_06030
integer x = 46
integer y = 1352
integer width = 558
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean enabled = false
string text = "[사용 SPARE PART]"
boolean focusrectangle = false
end type

type st_3 from statictext within w_qct_06030
integer x = 741
integer y = 1352
integer width = 654
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "[ 최종수불 마감년월 :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_qct_06030
integer x = 1705
integer y = 1352
integer width = 50
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
string text = "]"
boolean focusrectangle = false
end type

type st_yymm from statictext within w_qct_06030
integer x = 1408
integer y = 1352
integer width = 297
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

