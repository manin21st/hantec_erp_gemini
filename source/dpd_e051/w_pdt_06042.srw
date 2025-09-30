$PBExportHeader$w_pdt_06042.srw
$PBExportComments$주유실적등록
forward
global type w_pdt_06042 from w_inherite
end type
type dw_1 from datawindow within w_pdt_06042
end type
type gb_2 from groupbox within w_pdt_06042
end type
type rb_insert from radiobutton within w_pdt_06042
end type
type rb_update from radiobutton within w_pdt_06042
end type
type st_3 from statictext within w_pdt_06042
end type
type st_yymm from statictext within w_pdt_06042
end type
type rr_1 from roundrectangle within w_pdt_06042
end type
end forward

global type w_pdt_06042 from w_inherite
integer height = 2392
string title = "주유실적 등록"
dw_1 dw_1
gb_2 gb_2
rb_insert rb_insert
rb_update rb_update
st_3 st_3
st_yymm st_yymm
rr_1 rr_1
end type
global w_pdt_06042 w_pdt_06042

type variables
char ic_status
string   is_MaxYymm //최종수불마감년월
end variables

forward prototypes
public subroutine wf_setnull (long lrow, string gub)
public function integer wf_required_chk ()
public function integer wf_required_chk2 ()
public function integer wf_lastday_chk (string gubun, long lrow)
end prototypes

public subroutine wf_setnull (long lrow, string gub);string snull
int    inull

setnull(snull)
setnull(inull)

if gub = 'ALL' then 
	dw_insert.setitem(lRow, "mchno",  snull)
	dw_insert.setitem(lRow, "mchnam", snull)
end if

dw_insert.setitem(lRow, "seq",    inull)
dw_insert.setitem(lRow, "inspbody", snull )
dw_insert.setitem(lRow, "sutim",  0 )
dw_insert.setitem(lRow, "jutim",  0 )
dw_insert.setitem(lRow, "watim",  0 )
dw_insert.setitem(lRow, "yeqty",  0 )
dw_insert.setitem(lRow, "siqty",  0 )
dw_insert.setitem(lRow, "depot_no",  snull )
dw_insert.setitem(lRow, "itnbr",  snull )
dw_insert.setitem(lRow, "itemas_itdsc", snull)
dw_insert.setitem(lRow, "itemas_unmsr", snull)

end subroutine

public function integer wf_required_chk ();String sSidat, sWidpt, sWiemp, sMchno, sOption, sIns_gub, sDepot_No, sitnbr, sIojpno
int    iSeq, iJpno
dec{2} dSutim
dec{3} dSiqty
long   i, lCount, lJpno

sSidat = trim(dw_1.getitemstring(1, "sidat"))
sWidpt = trim(dw_1.getitemstring(1, "widpt"))
swiemp = trim(dw_1.getitemstring(1, "wiemp"))

if IsNULL(sSidat) or sSidat = "" then 
	f_message_chk (1400, "[실시일자]")
	dw_1.setcolumn("sidat")
	dw_1.setfocus()
	return -1
end if
if IsNULL(swiemp) or swiemp = "" then 
	f_message_chk (1400, "[담당자]")
	dw_1.setcolumn("wiemp")
	dw_1.setfocus()
	return -1
end if
if IsNULL(sWidpt) or sWidpt = "" then 
	f_message_chk (1400, "[담당부서]")
	dw_1.setcolumn("widpt")
	dw_1.setfocus()
	return -1
end if

lCount = dw_insert.RowCount()
iJpno  = 0 

For i = 1 to lCount
	sOption = dw_insert.getitemstring(i, "choice")
	
	IF sOption = 'Y' then 
		sMchno = dw_insert.getitemstring(i, "mchno" )
		IF Isnull(sMchno) or sMchno = "" then
			f_message_chk(1400, "[관리번호]")
			dw_insert.ScrollToRow(i)
			dw_insert.SetColumn("mchno")
			dw_insert.SetFocus()
			return -1
		end if
			
		iSeq = dw_insert.getitemnumber(i, "seq" )
		if Isnull(iseq) or iseq <= 0 then
			f_message_chk(1400, "[주유번호]")
			dw_insert.ScrollToRow(i)
			dw_insert.setcolumn("seq")
			dw_insert.setfocus()
			return -1
		end if

		sDepot_no = dw_insert.getitemstring(i, "depot_no" )
		IF Isnull(sDepot_no) or sDepot_no = "" then
			f_message_chk(1400, "[출고창고]")
			dw_insert.ScrollToRow(i)
			dw_insert.SetColumn("depot_no")
			dw_insert.SetFocus()
			return -1
		end if
		
		sitnbr = dw_insert.getitemstring(i, "itnbr" )
		IF Isnull(sitnbr) or sitnbr = "" then
			f_message_chk(1400, "[주유품번]")
			dw_insert.ScrollToRow(i)
			dw_insert.SetColumn("itnbr")
			dw_insert.SetFocus()
			return -1
		end if
		
		dSiqty = dw_insert.getitemDecimal(i, "siqty" ) 
		if IsNull(dSiqty ) or dSiqty  <= 0 then
			f_message_chk(1400,"[주유급유량]")
			dw_insert.ScrollToRow(i)
			dw_insert.setcolumn("siqty")
			dw_insert.setfocus()
			return -1
		end if	
		
		dSutim = dw_insert.getitemDecimal(i, "sutim" ) 
		if IsNull(dSutim)  then
			f_message_chk(1400,"[주유시간]")
			dw_insert.ScrollToRow(i)
			dw_insert.setcolumn("sutim")
			dw_insert.setfocus()
			return -1
		end if	
		
		sins_gub = dw_insert.getitemstring(i, "ins_gub" )
		If sIns_gub = '2' Then  //임의생성시 필수 입력데이타 Set
		   dw_insert.setitem(i, 'sabu',  gs_sabu)
			dw_insert.setitem(i, 'sidat', sSidat)
    	END IF

  	   //출고전표번호 생성
		IF iJpno < 1 THEN 
			lJpno = SQLCA.FUN_JUNPYO(gs_sabu, sSidat, 'C0')
			IF lJpno < 1 then 
				messagebox('확 인', '전표채번을 실패하였습니다. 전산실에 문의하세요!')
				Return -1
			ELSE
				COMMIT ;
			END IF
			siojpno = String(lJpno, "0000") 
			iJpno = 1 
		ELSE
			iJpno ++ 
		END IF
		
		dw_insert.setitem(i, 'iojpno', sSidat + siojpno + String(iJpno, "000")) 
		dw_insert.setitem(i, 'rslcod', '4') //교환으로 변경
		dw_insert.setitem(i, 'chkman', swiemp) 
		dw_insert.setitem(i, 'wiemp', swiemp) 
		dw_insert.setitem(i, 'widpt', swidpt) 
	ELSE
		dw_insert.SetItemStatus(i, 0, Primary!, NotModified!)
	END IF	
Next 

Return 1
end function

public function integer wf_required_chk2 ();dec{2} dSutim
dec{3} dSiqty
long   i, lCount

lCount = dw_insert.RowCount()

For i = 1 to lCount
	dSiqty = dw_insert.getitemDecimal(i, "siqty" ) 
	if IsNull(dSiqty) or dSiqty <= 0 then
		f_message_chk(1400,"[주유급유량]")
		dw_insert.ScrollToRow(i)
		dw_insert.setcolumn("siqty")
		dw_insert.setfocus()
		return -1
	end if	
	
	dSutim = dw_insert.getitemDecimal(i, "sutim" ) 
	if IsNull(dSutim) then
		f_message_chk(1400,"[주유시간]")
		dw_insert.ScrollToRow(i)
		dw_insert.setcolumn("sutim")
		dw_insert.setfocus()
		return -1
	end if	
Next 

Return 1
end function

public function integer wf_lastday_chk (string gubun, long lrow);String smchno, sLastdate, sSidate, sUpdate
Long   i, iseq

smchno  = dw_insert.object.mchno[lRow]
iseq    = dw_insert.object.seq[lRow]
sSidate = dw_insert.object.sidat[lRow]

if gubun = 'U' then //저장시
	select m.lastinsp
	  into :sLastdate
	  from mchmst_insp m
	 where m.sabu    = :gs_sabu 
		and m.mchno   = :smchno 
		and m.seq     = :iseq 
		and m.inspday = '3'; 
	
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
     AND A.GUBUN = '3'
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
                         AND GUBUN = '3' 
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
	and inspday = '3' ; 
 
if sqlca.sqlcode <> 0 then
	return -1
end if

return 1

end function

event open;call super::open;SELECT MAX("JUNPYO_CLOSING"."JPDAT") 
  INTO :is_MaxYymm
  FROM "JUNPYO_CLOSING"  
 WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
		 ( "JUNPYO_CLOSING"."JPGU" = 'C0' )    ;

st_yymm.text = string(is_MaxYymm, '@@@@.@@')

rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

on w_pdt_06042.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.gb_2=create gb_2
this.rb_insert=create rb_insert
this.rb_update=create rb_update
this.st_3=create st_3
this.st_yymm=create st_yymm
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.rb_insert
this.Control[iCurrent+4]=this.rb_update
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_yymm
this.Control[iCurrent+7]=this.rr_1
end on

on w_pdt_06042.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.gb_2)
destroy(this.rb_insert)
destroy(this.rb_update)
destroy(this.st_3)
destroy(this.st_yymm)
destroy(this.rr_1)
end on

type dw_insert from w_inherite`dw_insert within w_pdt_06042
integer x = 23
integer y = 476
integer width = 4576
integer height = 1724
integer taborder = 30
string dataobject = "d_pdt_06042_02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event dw_insert::itemchanged;string sCode, s_nam1, s_nam2, snull, sInspbody, sItnbr, sITdsc, sUnmsr, sdepot_no, sFind
long   lRow, lReturnRow
int    iSeq, iNull
dec{3} dPrqty

setnull(sNull)
setnull(iNull)

lRow = this.getrow()

IF this.getcolumnname() = "choice" THEN
   sCode = this.gettext()
	if sCode = 'N' then
      this.setitem(lRow, "jutim", 0)	
      this.setitem(lRow, "sutim", 0)	
      this.setitem(lRow, "watim", 0)	
	end if

ELSEIF this.GetColumnName() = 'mchno' THEN
   sCode = this.gettext()
	
	If IsNull(sCode) Or sCode = '' Then
		wf_setnull(lRow, 'ALL')
		return 
	End If

	SELECT MCHNAM 
	  INTO :s_nam1
	  FROM MCHMST
	 WHERE SABU  = :gs_sabu 
	   AND MCHNO = :sCode;
		
	If sqlca.sqlcode <> 0 Then
		f_message_chk(33, "[관리번호]")
		wf_setnull(lRow, 'ALL')
		Return 1
	End If
	
	SetItem(lRow, 'mchnam', s_nam1)
	wf_setnull(lRow, 'N')
	
ELSEIF this.GetColumnName() = 'seq' THEN
	iSeq = integer(GetText())
	
	If IsNull(iSeq) Or iSeq = 0 Then
		wf_setnull(lRow, 'N')
		return 
	END IF
	
   sCode = dw_1.getitemstring(1, 'sidat')
   IF sCode = '' or isnull(sCode) then
		messagebox('확 인', '실시일자를 먼저 입력하세요!')
		wf_setnull(lRow, 'N')
		dw_1.SetColumn('sidat')
		dw_1.setfocus()
		return 1
	End If
	
   s_nam1 = this.getitemstring(lRow, 'mchno')
   IF s_nam1 = '' or isnull(s_nam1) then
		messagebox('확 인', '관리번호를 먼저 입력하세요!')
		wf_setnull(lRow, 'N')
		this.SetColumn('mchno')
		return 1
	End If
	
	//저장된 주유번호인지를 체크
	SELECT "RSLCOD"  
     INTO :s_nam2  
     FROM "MCHRSL"  
    WHERE "SABU"  = :gs_sabu 
	   AND "SIDAT" = :sCode
		AND "GUBUN" = '3' 
		AND "MCHNO" = :s_nam1
		AND "SEQ"   = :iseq   ;

   IF sqlca.sqlcode = 0 then 
		IF MessageBox('확 인', '등록된 주유점검 자료입니다. 자료를 확인하세요!') = 1 THEN 
			wf_setnull(lRow, 'N')
			return 1
		END IF
	END IF

   //입력된 자료중에서 똑같은 자료가 입력되었는지 체크
	sfind = s_nam1 + '||' + string(iSeq)
	
	lReturnRow = This.Find("sfind = '"+ sfind +"' ", 1, This.RowCount())
	
	IF (lRow <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(37,'[주유번호]') 
		wf_setnull(lRow, 'N')
		return 1
	END IF

   SELECT A.INSPBODY, A.ITNBR, A.PRQTY, B.ITDSC, B.UNMSR, A.DEPOT_NO
     INTO :sInspbody, :sItnbr, :dPrqty, :sITdsc, :sUnmsr, :sDepot_no
     FROM MCHMST_INSP A, ITEMAS B  
    WHERE A.ITNBR   = B.ITNBR(+)
	   AND A.SABU    = :gs_sabu
	   AND A.MCHNO   = :s_nam1
		AND A.SEQ     = :iseq  
      AND A.INSPDAY = '3' 
		AND ROWNUM    = 1 ;
		
   IF sqlca.sqlcode = 0 then 
		dw_insert.setitem(lRow, "inspbody", sinspbody)
		dw_insert.setitem(lRow, "yeqty",  dPrqty )
		dw_insert.setitem(lRow, "siqty",  dPrqty )
		dw_insert.setitem(lRow, "depot_no", sdepot_no )
		dw_insert.setitem(lRow, "itnbr",  sitnbr )
		dw_insert.setitem(lRow, "itemas_itdsc", sitdsc)
		dw_insert.setitem(lRow, "itemas_unmsr", sunmsr)
	ELSE
		MessageBox('확 인', '등록되지 않은 주유점검기준 자료입니다. 자료를 확인하세요') 
		wf_setnull(lRow, 'N')
		return 1
	END IF

END IF

end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

long lRow

lRow = this.getrow()

if	this.getcolumnname() = "mchno" then
	open(w_mchno_popup)
	
	If IsNull(gs_code) Or gs_code = '' Then Return
	
	this.SetItem(lRow, "mchno",  gs_code)
	this.triggerevent(itemchanged!)
elseif this.getcolumnname() = "seq" then
	gs_code = this.getitemstring(lRow, 'mchno')

	open(w_pdt_06042_pop_up)
	
	If IsNull(gs_code) Or gs_code = '' Then Return
	
	this.SetItem(lRow, "mchno",  gs_code)
	this.SetItem(lRow, "mchnam", gs_codename)
	this.SetItem(lRow, "seq",    gi_page)
	this.triggerevent(itemchanged!)
end if


end event

type p_delrow from w_inherite`p_delrow within w_pdt_06042
integer x = 3095
integer y = 5000
end type

type p_addrow from w_inherite`p_addrow within w_pdt_06042
integer x = 2921
integer y = 5000
end type

type p_search from w_inherite`p_search within w_pdt_06042
integer x = 2738
integer y = 5000
end type

type p_ins from w_inherite`p_ins within w_pdt_06042
integer x = 4256
integer y = 304
string picturename = "c:\erpman\image\행추가_up.gif"
end type

event p_ins::ue_mousemove;//iF flags = 0 Then wf_onmouse(p_addrow)

end event

event p_ins::ue_lbuttonup;picturename = "c:\erpman\image\행추가_up.gif"
end event

event p_ins::ue_lbuttondown;call super::ue_lbuttondown;picturename = "c:\erpman\image\행추가_dn.gif"
end event

event p_ins::clicked;Long   ll_row
String  sSidat

if dw_1.AcceptText() = -1 then return
if dw_insert.AcceptText() = -1 then return

sSidat = trim(dw_1.object.sidat[1])

if sSidat = "" or isnull(sSidat) then 
	f_message_chk(30, '[실시일자]')
	dw_1.setcolumn('sidat')
	dw_1.setfocus()
	return 
end if

ll_row = dw_insert.insertrow(0)       
dw_insert.scrolltorow(ll_row)
dw_insert.setcolumn("mchno")
dw_insert.setfocus()

ib_any_typing = true //입력필드 변경여부 No

end event

type p_exit from w_inherite`p_exit within w_pdt_06042
integer x = 4430
integer y = 84
end type

type p_can from w_inherite`p_can within w_pdt_06042
integer x = 4256
integer y = 84
end type

event p_can::clicked;call super::clicked;rb_insert.checked = true

rb_insert.TriggerEvent("clicked")


end event

type p_print from w_inherite`p_print within w_pdt_06042
integer x = 4430
integer y = 304
string picturename = "c:\erpman\image\행삭제_up.gif"
end type

event p_print::clicked;Long   lRow

if dw_insert.AcceptText() = -1 then return
if dw_insert.RowCount() < 1 then return 

lRow = dw_insert.getrow()

if lRow < 1 then 
	messagebox('확 인', '삭제할 자료를 선택하세요!')
	dw_insert.setfocus()
	return 
end if

if dw_insert.getitemstring(lRow, 'ins_gub') = '2' then 
	dw_insert.DeleteRow(lRow)       
else
	MessageBox("확 인","삭제 할 수 없는 자료입니다." + "~n~n" + &
							 "생성구분이 임의에 자료만 삭제할 수 있습니다.!" )
   return 	
end if

end event

event p_print::ue_lbuttondown;picturename = "c:\erpman\image\행삭제_dn.gif"
end event

event p_print::ue_lbuttonup;picturename = "c:\erpman\image\행삭제_up.gif"
end event

type p_inq from w_inherite`p_inq within w_pdt_06042
integer x = 3735
integer y = 84
end type

event p_inq::clicked;call super::clicked;String  sSidat, sTodate, ls_wiemp, ls_widpt ,ls_gubun

if dw_1.AcceptText() = -1 then return 

sSidat = trim(dw_1.object.sidat[1])
ls_gubun = dw_1.getitemstring(1,'gubun')

if ic_status = '1' then //실적 등록시
	if sSidat = "" or isnull(sSidat) then 
		f_message_chk(30, '[실시일자]')
		dw_1.setcolumn('sidat')
		dw_1.setfocus()
		return 
	end if
	
	if dw_insert.retrieve(gs_sabu, sSidat,ls_gubun) <= 0 then
		f_message_chk(50, "")
	end if
	
	dw_1.SetTabOrder("sidat",  0)
//   dw_1.Object.sidat.Background.Color= 79741120

	p_ins.Enabled = true
	p_print.Enabled = true
	p_ins.picturename = "c:\erpman\image\행추가_up.gif"
	p_print.picturename = "c:\erpman\image\행삭제_up.gif"
	
else
	if sSidat = "" or isnull(sSidat) then 
		f_message_chk(30, '[실시일자 FROM]')
		dw_1.setcolumn('sidat')
		dw_1.setfocus()
		return 
	end if
	
	sTodate  = trim(dw_1.object.todate[1])
	if sTodate = "" or isnull(sTodate) then 
		f_message_chk(30, '[실시일자 TO]')
		dw_1.setcolumn('todate')
		dw_1.setfocus()
		return 
	end if
	
	ls_wiemp = dw_1.object.wiemp[1]
	ls_widpt = dw_1.object.widpt[1]
	
	if ls_wiemp = "" or isnull(ls_wiemp) then  ls_wiemp = '%'
	if ls_widpt = "" or isnull(ls_widpt) then  ls_widpt = '%'
	
	if dw_insert.retrieve(gs_sabu, sSidat, sTodate, ls_widpt, ls_wiemp,ls_gubun) <= 0 then
		f_message_chk(50, "")
	end if
	p_del.Enabled = true
	p_del.picturename = "c:\erpman\image\삭제_up.gif"


end if	

p_mod.Enabled = true
p_mod.picturename = "c:\erpman\image\저장_up.gif"

sle_msg.text =""
ib_any_typing = False //입력필드 변경여부 No

end event

type p_del from w_inherite`p_del within w_pdt_06042
integer x = 4082
integer y = 84
end type

event p_del::clicked;call super::clicked;int    iseq 
long   lReturnRow, lCount, k
string sSidat, sMchno, sNull

setnull(snull)

SetPointer(HourGlass!)

IF dw_1.AcceptText() = -1		THEN	RETURN

lCount = dw_insert.RowCount()
IF lCount < 1		THEN 	RETURN 
IF dw_insert.AcceptText() = -1	THEN	RETURN

lReturnRow = dw_insert.Find("del = 'Y'", 1, lCount)
IF lReturnRow = 0	THEN
	messagebox('확 인', '삭제 할 자료를 선택하세요!')
	return 
END IF

IF f_msg_delete() = -1 THEN	RETURN

FOR k = 1 TO lCount
	if dw_insert.getitemstring(k, 'del') = 'N' then continue
	
	if wf_lastday_chk('D', k) = -1 then //최종점검일자 등록
		ROLLBACK;
		f_message_chk(32, "[저장실패 : 최종점검일자]")
		return 
	end if	

	sSidat = dw_insert.object.sidat[k]
	smchno = dw_insert.object.mchno[k]
	iseq   = dw_insert.object.seq[k]
	
	IF dw_insert.getitemstring(k, 'ins_gub') = '2' then  //계획없이 임의로 생성된 자료
		DELETE FROM "MCHRSL"  
		 WHERE ( "MCHRSL"."SABU"  = :gs_sabu ) AND  
				 ( "MCHRSL"."SIDAT" = :sSidat ) AND  
				 ( "MCHRSL"."GUBUN" = '3' ) AND  
				 ( "MCHRSL"."MCHNO" = :sMchno ) AND  
				 ( "MCHRSL"."SEQ"   = :iseq )   ;
	ELSE
		UPDATE "MCHRSL"  
			SET "RSLCOD" = 'W',   
				 "CHKMAN" = null,   
				 "WIDPT"  = null,      
				 "WIEMP"  = null,      
				 "SUTIM"  = 0,   
				 "JUTIM"  = 0,   
				 "WATIM"  = 0,   
				 "IOJPNO" = null   
		 WHERE "SABU"   = :gs_sabu
			AND "SIDAT"  = :ssidat
			AND "GUBUN"  = '3'
			AND "MCHNO"  = :sMchno
			AND "SEQ"    = :iseq ;
	END IF
	
	IF SQLCA.SQLNROWS <= 0 or SQLCA.SQLCODE <> 0	THEN	
		Rollback;
		f_rollback()
		Return 
	END IF
NEXT

Commit;
p_inq.triggerevent(clicked!)	 
end event

type p_mod from w_inherite`p_mod within w_pdt_06042
integer x = 3909
integer y = 84
end type

event p_mod::clicked;call super::clicked;if dw_1.AcceptText() = -1 then return
if dw_insert.AcceptText() = -1 then return

long lReturnRow, lCount, k

lCount = dw_insert.RowCount()
if lCount < 1 then return

SetPointer(HourGlass!)

IF ic_status = '1' THEN 
	lReturnRow = dw_insert.Find("choice = 'Y'", 1, lCount)
	IF lReturnRow = 0	THEN
		messagebox('확 인', '저장 할 자료를 선택하세요!')
		return 
	END IF
	
	if wf_required_chk() = -1 then return 
ELSE
	if wf_required_chk2() = -1 then return 
END IF

IF f_msg_update() = -1 	THEN	RETURN

IF ic_status = '1' THEN 
	For k = 1 to lCount
		IF dw_insert.getitemstring(k, "choice") = 'Y' then 
			if wf_lastday_chk('U', k) = -1 then //최종점검일자 등록
				ROLLBACK;
				f_message_chk(32, "[저장실패 : 최종점검일자]")
				return 
			end if	
		END IF	
	Next 
END IF	

IF dw_insert.Update() > 0 THEN
	COMMIT;
	sle_msg.Text = "저장 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
END IF

p_inq.triggerevent(clicked!)	 

end event

type cb_exit from w_inherite`cb_exit within w_pdt_06042
integer x = 3058
integer y = 5000
integer taborder = 90
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06042
integer x = 1911
integer y = 5000
integer taborder = 60
end type

type cb_ins from w_inherite`cb_ins within w_pdt_06042
boolean visible = false
integer x = 1289
integer y = 5000
integer width = 379
integer taborder = 40
string text = "행추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdt_06042
integer x = 2327
integer y = 5000
integer taborder = 70
end type

type cb_inq from w_inherite`cb_inq within w_pdt_06042
integer x = 1545
integer y = 5000
integer taborder = 20
end type

type cb_print from w_inherite`cb_print within w_pdt_06042
boolean visible = false
integer x = 1682
integer y = 5000
integer width = 379
string text = "행삭제(&L)"
end type

type st_1 from w_inherite`st_1 within w_pdt_06042
end type

type cb_can from w_inherite`cb_can within w_pdt_06042
integer x = 2711
integer y = 5000
integer taborder = 80
end type

type cb_search from w_inherite`cb_search within w_pdt_06042
boolean visible = false
integer x = 2446
integer y = 2592
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_06042
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_06042
end type

type dw_1 from datawindow within w_pdt_06042
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer y = 4
integer width = 3118
integer height = 384
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_06042_01"
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

event rbuttondown;setnull(gs_code ) 
setnull(gs_codename)
setnull(gs_gubun)

if this.getcolumnname() = "wiemp" then
	gs_gubun = this.getitemstring(1, "widpt")
	open(w_sawon_popup ) 
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(1,"wiemp", gs_code)
	this.TriggerEvent(ItemChanged!)
	
elseif this.getcolumnname() = "widpt" then
	open( w_vndmst_4_popup ) 
	if gs_code = '' or isnull(gs_code) then return 
	this.setitem(1, "widpt",  gs_code)
	this.setitem(1, "deptnam", gs_codename)
end if

end event

event itemchanged;string  s_cod, scode, sname, sname2, ls_cvcod, ls_cvnas
integer ireturn

s_cod = this.getcolumnname()
scode = trim(this.gettext())

if s_cod = "sidat" then     

   if scode = '' or isnull(scode) then return 
	
	if f_datechk(scode) = -1 then
		f_message_chk(35, "[실시일자]")
		this.object.sidat[1] = ""
		return 1
	end if
elseif s_cod = "todate" then
   if scode = '' or isnull(scode) then return 
	
	if f_datechk(scode) = -1 then
		f_message_chk(35, "[실시일자]")
		this.object.todate[1] = ""
		return 1
	end if
elseif s_cod = "wiemp" then    //  담당자 
	ireturn = f_get_name2('사번', 'Y', scode, sname, sname2)  
	
	this.setitem(1, "wiemp", scode )
	this.setitem(1, "empnam", sname )
	
	IF ireturn = 0 then 
	   SELECT A.DEPTCODE, B.CVNAS2
   	  INTO :ls_cvcod,   :ls_cvnas
        FROM P1_MASTER A, VNDMST B  
       WHERE A.DEPTCODE = B.CVCOD(+)
         AND A.EMPNO    = :scode ;
	 
		 this.setitem(1, "widpt", ls_cvcod )
		 this.setitem(1, "deptnam", ls_cvnas )
	END IF
	
   Return iReturn 
 
elseif s_cod = "widpt" then 
	ireturn = f_get_name2('부서' , 'Y' , scode, sname, sname2)
	this.setitem(1,"widpt", scode )
	this.setitem(1,"deptnam", sname )
   return ireturn
end if

end event

event itemerror;return 1
end event

type gb_2 from groupbox within w_pdt_06042
integer x = 3141
integer y = 8
integer width = 475
integer height = 356
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
borderstyle borderstyle = stylelowered!
end type

type rb_insert from radiobutton within w_pdt_06042
integer x = 3214
integer y = 100
integer width = 361
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
string text = "실적등록"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;ic_status = '1'	// 등록

sle_msg.text =""
dw_insert.SetRedraw(False)
dw_1.SetRedraw(False)

dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetTabOrder("sidat",  10)
//dw_1.Object.sidat.Background.Color = 12639424

dw_1.setitem(1, "sidat", is_today )
dw_1.setitem(1, "gub", '1' )

dw_insert.DataObject = 'd_pdt_06042_02'
dw_insert.SetTransObject(sqlca)
dw_insert.Reset()

dw_insert.SetRedraw(True)
dw_1.SetRedraw(True)

dw_1.SetFocus()

ib_any_typing = False //입력필드 변경여부 No

p_del.Enabled = false 
p_ins.Enabled = false 
p_print.Enabled = false 
p_mod.Enabled = false 
p_ins.picturename = "c:\erpman\image\행추가_d.gif"
p_print.picturename = "c:\erpman\image\행삭제_d.gif"
p_del.picturename = "c:\erpman\image\삭제_d.gif"
p_mod.picturename = "c:\erpman\image\저장_d.gif"



end event

type rb_update from radiobutton within w_pdt_06042
integer x = 3214
integer y = 224
integer width = 361
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
string text = "실적조정"
borderstyle borderstyle = stylelowered!
end type

event clicked;ic_status = '2'	// 수정시

sle_msg.text =""
dw_insert.SetRedraw(False)
dw_1.SetRedraw(False)

dw_1.Reset()
dw_1.InsertRow(0)

dw_1.SetTabOrder("sidat",  10)
//dw_1.Object.sidat.Background.Color = 12639424

dw_1.setitem(1, "sidat",  left(is_today, 6) + '01' )
dw_1.setitem(1, "todate", is_today )
dw_1.setitem(1, "gub", '2' )

dw_insert.DataObject = 'd_pdt_06042_03'
dw_insert.SetTransObject(sqlca)
dw_insert.Reset()

dw_insert.SetRedraw(True)
dw_1.SetRedraw(True)

dw_1.SetFocus()

ib_any_typing = False //입력필드 변경여부 No

p_del.Enabled = false 
p_ins.Enabled = false 
p_print.Enabled = false 
p_mod.Enabled = false 
p_ins.picturename = "c:\erpman\image\행추가_d.gif"
p_print.picturename = "c:\erpman\image\행삭제_d.gif"
p_del.picturename = "c:\erpman\image\삭제_d.gif"
p_mod.picturename = "c:\erpman\image\저장_d.gif"

end event

type st_3 from statictext within w_pdt_06042
integer x = 41
integer y = 392
integer width = 654
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
string text = "[ 최종수불 마감년월 ]"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_yymm from statictext within w_pdt_06042
integer x = 713
integer y = 392
integer width = 297
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_pdt_06042
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 464
integer width = 4617
integer height = 1752
integer cornerheight = 40
integer cornerwidth = 55
end type

