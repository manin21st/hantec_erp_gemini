$PBExportHeader$w_pdt_01011.srw
$PBExportComments$** 연동 생산계획(연동 계획 생성)
forward
global type w_pdt_01011 from window
end type
type rb_3 from radiobutton within w_pdt_01011
end type
type rb_2 from radiobutton within w_pdt_01011
end type
type rb_1 from radiobutton within w_pdt_01011
end type
type p_create from picture within w_pdt_01011
end type
type p_exit from picture within w_pdt_01011
end type
type st_1 from statictext within w_pdt_01011
end type
type st_4 from statictext within w_pdt_01011
end type
type cb_3 from commandbutton within w_pdt_01011
end type
type st_3 from statictext within w_pdt_01011
end type
type st_2 from statictext within w_pdt_01011
end type
type cb_2 from commandbutton within w_pdt_01011
end type
type cb_1 from commandbutton within w_pdt_01011
end type
type st_msg from statictext within w_pdt_01011
end type
type cb_exit from commandbutton within w_pdt_01011
end type
type rr_1 from roundrectangle within w_pdt_01011
end type
type dw_ip from datawindow within w_pdt_01011
end type
end forward

global type w_pdt_01011 from window
integer x = 974
integer y = 400
integer width = 1925
integer height = 792
boolean titlebar = true
string title = "연동 계획 생성"
windowtype windowtype = response!
long backcolor = 32106727
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
p_create p_create
p_exit p_exit
st_1 st_1
st_4 st_4
cb_3 cb_3
st_3 st_3
st_2 st_2
cb_2 cb_2
cb_1 cb_1
st_msg st_msg
cb_exit cb_exit
rr_1 rr_1
dw_ip dw_ip
end type
global w_pdt_01011 w_pdt_01011

type variables
string  is_gubun //환경설정==> 영업계획이 없는경우
end variables

event open;f_window_center(this)

dw_ip.settransobject(sqlca)
dw_ip.InsertRow(0)

dw_ip.setitem(1, 'syymm', gs_code)
dw_ip.setitem(1, 'jjcha', integer(gs_codename))

f_mod_saupj(dw_ip, 'saupj')
f_child_saupj(dw_ip, 'steam', gs_saupj)

string sYYmm

  SELECT MAX("PLAN_YYMM")  
    INTO :sYYmm 
    FROM "SHORTSAPLAN"  
   WHERE "SABU" = :gs_sabu   ;

dw_ip.setitem(1, 'sale_yymm', sYYmm)

  SELECT "SYSCNFG"."DATANAME"  
    INTO :is_gubun
    FROM "SYSCNFG"  
   WHERE ( "SYSCNFG"."SYSGU" = 'Y' ) AND  
         ( "SYSCNFG"."SERIAL" = 15 ) AND  
         ( "SYSCNFG"."LINENO" = '2' )   ;

if is_gubun = 'N' or isnull(is_gubun) or is_gubun = '' then 
	is_gubun = 'N'
	dw_ip.object.syscnfg_t.text = '[ 환경설정 : 영업계획이 없거나 0인 경우 생성 안함 ]'
else
	is_gubun = 'Y'
	dw_ip.object.syscnfg_t.text = '[ 환경설정 : 영업계획이 없거나 0인 경우 생성 함 ]'
end if

dw_ip.setfocus()

end event

on w_pdt_01011.create
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.p_create=create p_create
this.p_exit=create p_exit
this.st_1=create st_1
this.st_4=create st_4
this.cb_3=create cb_3
this.st_3=create st_3
this.st_2=create st_2
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_msg=create st_msg
this.cb_exit=create cb_exit
this.rr_1=create rr_1
this.dw_ip=create dw_ip
this.Control[]={this.rb_3,&
this.rb_2,&
this.rb_1,&
this.p_create,&
this.p_exit,&
this.st_1,&
this.st_4,&
this.cb_3,&
this.st_3,&
this.st_2,&
this.cb_2,&
this.cb_1,&
this.st_msg,&
this.cb_exit,&
this.rr_1,&
this.dw_ip}
end on

on w_pdt_01011.destroy
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.p_create)
destroy(this.p_exit)
destroy(this.st_1)
destroy(this.st_4)
destroy(this.cb_3)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_msg)
destroy(this.cb_exit)
destroy(this.rr_1)
destroy(this.dw_ip)
end on

type rb_3 from radiobutton within w_pdt_01011
boolean visible = false
integer x = 942
integer y = 84
integer width = 398
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "생산계획"
end type

type rb_2 from radiobutton within w_pdt_01011
boolean visible = false
integer x = 530
integer y = 84
integer width = 398
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "판매계획2"
end type

type rb_1 from radiobutton within w_pdt_01011
boolean visible = false
integer x = 110
integer y = 84
integer width = 398
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "판매계획1"
boolean checked = true
end type

type p_create from picture within w_pdt_01011
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1472
integer y = 32
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;this.PictureName = 'C:\erpman\image\생성_dn.gif'
end event

event ue_lbuttonup;this.PictureName = 'C:\erpman\image\생성_up.gif'
end event

event clicked;If rb_1.Checked Then
	cb_1.TriggerEvent(Clicked!)
ElseIf rb_2.Checked Then
	cb_2.TriggerEvent(Clicked!)
ElseIf rb_3.Checked Then
	cb_3.TriggerEvent(Clicked!)
End If
	
end event

type p_exit from picture within w_pdt_01011
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1655
integer y = 32
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\close.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;this.PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event ue_lbuttonup;this.PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event clicked;close(parent)
end event

type st_1 from statictext within w_pdt_01011
boolean visible = false
integer x = 421
integer y = 1448
integer width = 1029
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "품목생성기준 적용안됨"
boolean focusrectangle = false
end type

type st_4 from statictext within w_pdt_01011
boolean visible = false
integer x = 64
integer y = 1384
integer width = 1847
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "생산계획  => 연동계획수량은 이전년월 생산계획수량을 동일하게 적용"
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_pdt_01011
integer x = 1033
integer y = 1576
integer width = 439
integer height = 92
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "생산계획"
end type

event clicked;string s_yymm, s_toym,  smsgtxt, stext, s_gub, s_team, sItemgub, ssaupj
int    i_seq, i_jseq 
long   lRtnValue, get_count, lcount

if dw_ip.AcceptText() = -1 then return 
sItemgub  = dw_ip.GetItemString(1,'itemgub')
s_gub     = trim(dw_ip.GetItemString(1,'gub1'))
ssaupj     = trim(dw_ip.GetItemString(1,'saupj'))
s_team    = trim(dw_ip.GetItemString(1,'steam'))
s_yymm    = trim(dw_ip.GetItemString(1,'syymm'))
i_seq     = dw_ip.GetItemNumber(1,'jjcha')

SetPointer(HourGlass!)

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[계획년월]')
	dw_ip.Setcolumn('syymm')
	dw_ip.SetFocus()
	return
end if

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then

	messagebox("확인", "현재 이전 년월은 처리할 수 없습니다!!")

	dw_ip.setcolumn('syymm')
	dw_ip.setfocus()
	return 
end if		

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[확정/조정 구분]')
	dw_ip.Setcolumn('jjcha')
	dw_ip.SetFocus()
	return
else
	if i_seq = 1 then 
		stext = '확정분'
	else
		stext = '조정분'
	end if	
end if	

if s_gub = '2' then 
	if isnull(s_team) or s_team = '' then
		f_message_chk(30,'[생산팀]')
		dw_ip.Setcolumn('steam')
		dw_ip.SetFocus()
		return
	end if	

   SELECT COUNT(*) INTO :lcount
     FROM ITEMAS B, MONPLN_DTL A, ITNCT C
    WHERE ( B.ITNBR = A.ITNBR ) AND  
          ( B.ITTYP = C.ITTYP ) AND  
          ( B.ITCLS = C.ITCLS ) AND  
          ( A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq ) AND    
          ( C.PDTGU = :s_team ) and ( c.porgu like :ssaupj ) ;

	if lcount > 0 then 
		smsgtxt = '생산팀 => ' + &
		          left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
					 ' 월 생산계획자료가 존재합니다. ' + "~n~n" +&
					  '생산팀에 월 생산계획을 삭제하시고 연동 생산계획을 실행 하십시요'
		messagebox("확 인", smsgtxt)
		return 
	end if

	SELECT COUNT(*) 
	  INTO :get_count
	  FROM MONPLN_SUM A, ITEMAS B, ITNCT C
	 WHERE A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq AND
	       A.ITNBR = B.ITNBR AND B.ITTYP = C.ITTYP AND B.ITCLS = C.ITCLS AND 
	       C.PDTGU = :s_team and c.porgu like :ssaupj ;
	
	IF get_count > 0 then 
		smsgtxt = '생산팀 => ' + &
		          left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
					 ' 연동 생산계획자료가 존재합니다. ' + "~n~n" +&
					 '이전 월 연동 생산계획 수량 ▶ 연동 생산계획 수량(마지막 달은 0 생성) ' + "~n~n" +&
					 left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext +& 
					  ' 연동 생산계획을 생성 하시겠습니까?'
	ELSE
		smsgtxt = '생산팀 => ' + &
					 '이전 월 연동 생산계획 수량 ▶ 연동 생산계획 수량(마지막 달은 0 생성) ' + "~n~n" +&
					 left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext +& 
					  ' 연동 생산계획을 생성 하시겠습니까?'
	END IF
			
	if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   
	
	SetPointer(HourGlass!)
	st_msg.text = "생산팀별 연동 생산계획 자료 생성 中 .......... "
	//이전월에 확정,조정구분 가져오기
	  SELECT MAX("MONPLN_SUM"."MOSEQ")  
		 INTO :i_jseq  
		 FROM "MONPLN_SUM"  
		WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND  
				( "MONPLN_SUM"."MONYYMM" =
					 to_char(add_months(to_date(:s_yymm,'yyyymm'),-1),'yyyymm') )   ;
	
	lRtnValue = sqlca.erp000000032_1(gs_sabu, s_yymm, i_seq, i_jseq, s_team, ssaupj)

else
   SELECT COUNT(*) INTO :lcount
     FROM MONPLN_DTL A, ITEMAS B, ITNCT C
    WHERE ( A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq ) 
	 	AND   A.ITNBR = B.ITNBR AND B.ITTYP = C.ITTYP AND B.ITCLS = C.ITCLS AND 
	         C.PDTGU = :s_team and c.porgu like :ssaupj ;

	if lcount > 0 then 
		smsgtxt = left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
					 ' 월 생산계획자료가 존재합니다. ' + "~n~n" +&
					  '월 생산계획을 모두 삭제하시고 연동 생산계획을 실행 하십시요'
		messagebox("확 인", smsgtxt)
		return 
	end if

	SELECT COUNT(*) 
	  INTO :get_count
	  FROM MONPLN_SUM A, ITEMAS B, ITNCT C
	 WHERE A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq 
	 	AND A.ITNBR = B.ITNBR AND B.ITTYP   = C.ITTYP AND B.ITCLS = C.ITCLS
		AND C.PORGU LIKE :SSAUPJ ;
	
	IF get_count > 0 then 
		smsgtxt = left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
					 ' 연동 생산계획자료가 존재합니다. ' + "~n~n" +&
					 '이전 월 연동 생산계획 수량 ▶ 연동 생산계획 수량(마지막 달은 0 생성) ' + "~n~n" +&
					 left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext +& 
					  ' 연동 생산계획을 생성 하시겠습니까?'
	ELSE
		smsgtxt = '이전 월 연동 생산계획 수량 ▶ 연동 생산계획 수량(마지막 달은 0 생성) ' + "~n~n" +&
					 left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext +& 
					  ' 연동 생산계획을 생성 하시겠습니까?'
	END IF
			
	if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   
	
	SetPointer(HourGlass!)
	st_msg.text = "연동 생산계획 자료 생성 中 .......... "
	//이전월에 확정,조정구분 가져오기
	  SELECT MAX("MONPLN_SUM"."MOSEQ")  
		 INTO :i_jseq  
		 FROM "MONPLN_SUM"  
		WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND  
				( "MONPLN_SUM"."MONYYMM" =
					 to_char(add_months(to_date(:s_yymm,'yyyymm'),-1),'yyyymm') )   ;
	
	lRtnValue = sqlca.erp000000032(gs_sabu, s_yymm, i_seq, i_jseq, ssaupj)
end if	

IF lRtnValue < 0 THEN
	ROLLBACK;
	f_message_chk(41,'')
	st_msg.text = string(lRtnValue) 
	Return
ELSE
	commit ;
	st_msg.text = string(lRtnValue) + '건에 자료가 생성처리 되었습니다!!'
END IF


end event

type st_3 from statictext within w_pdt_01011
boolean visible = false
integer x = 64
integer y = 1316
integer width = 1847
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
boolean enabled = false
string text = "판매계획2 => 연동계획수량은 재고[안전재고 MIN]를 감안하여 적용"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pdt_01011
boolean visible = false
integer x = 64
integer y = 1248
integer width = 1847
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
boolean enabled = false
string text = "판매계획1 => 연동계획수량은 판매계획과 동일하게 적용[환경설정적용]"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_pdt_01011
integer x = 585
integer y = 1576
integer width = 439
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "판매계획2"
end type

event clicked;string s_yymm, s_toym,  smsgtxt, stext, s_gub, s_team, sItemgub, SSAUPJ
int    i_seq, i_jseq 
long   lRtnValue, get_count, lcount

if dw_ip.AcceptText() = -1 then return 
sItemgub  = dw_ip.GetItemString(1,'itemgub')
ssaupj  = dw_ip.GetItemString(1,'saupj')
s_gub     = trim(dw_ip.GetItemString(1,'gub1'))
s_team    = trim(dw_ip.GetItemString(1,'steam'))
s_yymm    = trim(dw_ip.GetItemString(1,'syymm'))
i_seq     = dw_ip.GetItemNumber(1,'jjcha')

SetPointer(HourGlass!)

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[계획년월]')
	dw_ip.Setcolumn('syymm')
	dw_ip.SetFocus()
	return
end if

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then

	messagebox("확인", "현재 이전 년월은 처리할 수 없습니다!!")

	dw_ip.setcolumn('syymm')
	dw_ip.setfocus()
	return 
end if		

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[확정/조정 구분]')
	dw_ip.Setcolumn('jjcha')
	dw_ip.SetFocus()
	return
else
	if i_seq = 1 then 
		stext = '확정분'
	else
		stext = '조정분'
	end if	
end if	

if s_gub = '2' then 
	if isnull(s_team) or s_team = '' then
		f_message_chk(30,'[생산팀]')
		dw_ip.Setcolumn('steam')
		dw_ip.SetFocus()
		return
	end if	

   SELECT COUNT(*) INTO :lcount
     FROM ITEMAS B, MONPLN_DTL A, ITNCT C
    WHERE ( B.ITNBR = A.ITNBR ) AND  
          ( B.ITTYP = C.ITTYP ) AND  
          ( B.ITCLS = C.ITCLS ) AND  
          ( A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq ) AND    
          ( B.PDTGU = :s_team )  AND
			 ( (C.PORGU = 'ALL' OR C.PORGU LIKE :SSAUPJ) );

	if lcount > 0 then 
		smsgtxt = '생산팀 => ' + &
		          left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
					 ' 월 생산계획자료가 존재합니다. ' + "~n~n" +&
					  '생산팀에 월 생산계획을 삭제하시고 연동 생산계획을 실행 하십시요'
		messagebox("확 인", smsgtxt)
		return 
	end if

	SELECT COUNT(*) 
	  INTO :get_count
	  FROM MONPLN_SUM A, ITEMAS B, ITNCT C
	 WHERE A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq AND
	       A.ITNBR = B.ITNBR AND B.ITTYP = C.ITTYP AND B.ITCLS = C.ITCLS AND 
	       B.PDTGU = :s_team AND (C.PORGU = 'ALL' OR C.PORGU LIKE :SSAUPJ);
	
	IF get_count > 0 then 
		smsgtxt = '생산팀 => ' + &
		          left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
					 ' 연동 생산계획자료가 존재합니다. ' + "~n~n" +&
					 '영업 판매계획 수량 ▶ 연동 생산계획 수량(재고수량 적용) ' + "~n~n" +&
					 left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext +& 
					  ' 연동 생산계획을 생성 하시겠습니까?'
	ELSE
		smsgtxt = '생산팀 => ' + &
		          '영업 판매계획 수량 ▶ 연동 생산계획 수량(재고수량 적용) ' + "~n~n" +&
					 left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext +& 
					  ' 연동 생산계획을 생성 하시겠습니까?'
	END IF
			
	if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   
	
	SetPointer(HourGlass!)
	st_msg.text = "생산팀별 연동 생산계획 자료 생성 中 .......... "
	//이전월에 확정,조정구분 가져오기
	  SELECT MAX("MONPLN_SUM"."MOSEQ")  
		 INTO :i_jseq  
		 FROM "MONPLN_SUM"  
		WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND  
				( "MONPLN_SUM"."MONYYMM" =
					 to_char(add_months(to_date(:s_yymm,'yyyymm'),-1),'yyyymm') )   ;
	
	lRtnValue = sqlca.erp000000031_1(gs_sabu, s_yymm, i_seq, i_jseq, s_team, sItemgub, ssaupj)

else
   SELECT COUNT(*) INTO :lcount
     FROM MONPLN_DTL A, ITEMAS B, ITNCT C
    WHERE ( A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq 
	   AND  A.ITNBR = B.ITNBR AND B.ITTYP = C.ITTYP AND B.ITCLS = C.ITCLS AND 
	        (C.PORGU = 'ALL' OR C.PORGU LIKE :SSAUPJ));

	if lcount > 0 then 
		smsgtxt = left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
					 ' 월 생산계획자료가 존재합니다. ' + "~n~n" +&
					  '월 생산계획을 모두 삭제하시고 연동 생산계획을 실행 하십시요'
		messagebox("확 인", smsgtxt)
		return 
	end if

	SELECT COUNT(*) 
	  INTO :get_count
	  FROM MONPLN_SUM A, ITEMAS B, ITNCT C
	 WHERE A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq 
	   AND  A.ITNBR = B.ITNBR AND B.ITTYP = C.ITTYP AND B.ITCLS = C.ITCLS AND 
	        (C.PORGU = 'ALL' OR C.PORGU LIKE :SSAUPJ) ;	 
	
	IF get_count > 0 then 
		smsgtxt = left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
					 ' 연동 생산계획자료가 존재합니다. ' + "~n~n" +&
					 '영업 판매계획 수량 ▶ 연동 생산계획 수량(재고수량 적용) ' + "~n~n" +&
					 left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext +& 
					  ' 연동 생산계획을 생성 하시겠습니까?'
	ELSE
		smsgtxt = '영업 판매계획 수량 ▶ 연동 생산계획 수량(재고수량 적용) ' + "~n~n" +&
					 left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext +& 
					  ' 연동 생산계획을 생성 하시겠습니까?'
	END IF
			
	if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   
	
	SetPointer(HourGlass!)
	st_msg.text = "연동 생산계획 자료 생성 中 .......... "
	//이전월에 확정,조정구분 가져오기
	  SELECT MAX("MONPLN_SUM"."MOSEQ")  
		 INTO :i_jseq  
		 FROM "MONPLN_SUM"  
		WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND  
				( "MONPLN_SUM"."MONYYMM" =
					 to_char(add_months(to_date(:s_yymm,'yyyymm'),-1),'yyyymm') )   ;
	
	lRtnValue = sqlca.erp000000031(gs_sabu, s_yymm, i_seq, i_jseq, sItemgub, ssaupj)
end if	

IF lRtnValue < 0 THEN
	ROLLBACK;
	f_message_chk(41,'')
	st_msg.text = string(lRtnValue) 
	Return
ELSE
	commit ;
	st_msg.text = string(lRtnValue) + '건에 자료가 생성처리 되었습니다!!'
END IF

end event

type cb_1 from commandbutton within w_pdt_01011
integer x = 137
integer y = 1576
integer width = 439
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "판매계획1"
end type

event clicked;string s_yymm, s_toym,  smsgtxt, stext, s_gub, s_team, sItemgub, ssaupj
int    i_seq, i_jseq 
long   lRtnValue, get_count, lcount

if dw_ip.AcceptText() = -1 then return 

sItemgub  = dw_ip.GetItemString(1,'itemgub')

s_gub  = trim(dw_ip.GetItemString(1,'gub1'))
s_team  = trim(dw_ip.GetItemString(1,'steam'))
s_yymm = trim(dw_ip.GetItemString(1,'syymm'))
ssaupj  = trim(dw_ip.GetItemString(1,'saupj'))
i_seq  = dw_ip.GetItemNumber(1,'jjcha')

SetPointer(HourGlass!)

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[계획년월]')
	dw_ip.Setcolumn('syymm')
	dw_ip.SetFocus()
	return
end if

s_toym = left(f_today(), 6) 
if s_yymm < s_toym then

	messagebox("확인", "현재 이전 년월은 처리할 수 없습니다!!")

	dw_ip.setcolumn('syymm')
	dw_ip.setfocus()
	return 
end if		

if isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[확정/조정 구분]')
	dw_ip.Setcolumn('jjcha')
	dw_ip.SetFocus()
	return
else
	if i_seq = 1 then 
		stext = '확정분'
	else
		stext = '조정분'
	end if	
end if	

if s_gub = '2' then 
//	if isnull(s_team) or s_team = '' then
//		f_message_chk(30,'[생산팀]')
//		dw_ip.Setcolumn('steam')
//		dw_ip.SetFocus()
//		return
//	end if	
	
   SELECT COUNT(*) INTO :lcount
     FROM ITEMAS B, MONPLN_DTL A
    WHERE ( B.ITNBR = A.ITNBR ) AND  
          ( A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq );
//			 AND   ( B.PDTGU = :s_team ) 

	if lcount > 0 then 
		smsgtxt = '생산팀 => ' + &
		          left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
					 ' 월 생산계획자료가 존재합니다. ' + "~n~n" +&
					  '생산팀에 월 생산계획을 삭제하시고 연동 생산계획을 실행 하십시요'
		messagebox("확 인", smsgtxt)
		return 
	end if

	SELECT COUNT(*) 
	  INTO :get_count
	  FROM MONPLN_SUM A, ITEMAS B
	 WHERE A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq AND
	       A.ITNBR = B.ITNBR ;
			 //AND B.PDTGU = :s_team ;
	
	IF get_count > 0 then 
		smsgtxt = '생산팀 => ' + &
		          left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
					 ' 연동 생산계획자료가 존재합니다. ' + "~n~n" +&
					 '영업 판매계획 수량 ▶ 연동 생산계획 수량 ' + "~n~n" +&
					 left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext +& 
					  ' 연동 생산계획을 생성 하시겠습니까?'
	ELSE
		smsgtxt = '생산팀 => ' + &
		          '영업 판매계획 수량 ▶ 연동 생산계획 수량 ' + "~n~n" +&
					 left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext +& 
					  ' 연동 생산계획을 생성 하시겠습니까?'
	END IF
			
	if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   
	
	SetPointer(HourGlass!)
	st_msg.text = "생산팀별 연동 생산계획 자료 생성 中 .......... "
	//이전월에 확정,조정구분 가져오기
	  SELECT MAX("MONPLN_SUM"."MOSEQ")  
		 INTO :i_jseq  
		 FROM "MONPLN_SUM"  
		WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND  
				( "MONPLN_SUM"."MONYYMM" =
					 to_char(add_months(to_date(:s_yymm,'yyyymm'),-1),'yyyymm') )   ;
	
	lRtnValue = sqlca.erp000000030_1(gs_sabu, s_yymm, i_seq, i_jseq, s_team, is_gubun, sItemgub, ssaupj)
else
//   SELECT COUNT(*) INTO :lcount
//     FROM MONPLN_DTL A, ITEMAS B, ITNCT C
//    WHERE ( A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq AND
//	 			A.ITNBR = B.ITNBR AND B.ITTYP = C.ITTYP AND B.ITCLS = C.ITCLS AND
//				(C.PORGU = 'ALL' OR C.PORGU LIKE :SSAUPJ)) ;
//
//	if lcount > 0 then 
//		smsgtxt = left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
//					 ' 월 생산계획자료가 존재합니다. ' + "~n~n" +&
//					  '월 생산계획을 모두 삭제하시고 연동 생산계획을 실행 하십시요'
//		messagebox("확 인", smsgtxt)
//		return 
//	end if
//
//	SELECT COUNT(*) 
//	  INTO :get_count
//	  FROM MONPLN_SUM A, ITEMAS B, ITNCT C
//	 WHERE A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq 
//	 	AND A.ITNBR = B.ITNBR AND B.ITTYP = C.ITTYP AND B.ITCLS = C.ITCLS
//		AND (C.PORGU = 'ALL' OR C.PORGU LIKE :SSAUPJ);
//	
//	IF get_count > 0 then 
//		smsgtxt = left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
//					 ' 연동 생산계획자료가 존재합니다. ' + "~n~n" +&
//					 '영업 판매계획 수량 ▶ 연동 생산계획 수량 ' + "~n~n" +&
//					 left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext +& 
//					  ' 연동 생산계획을 생성 하시겠습니까?'
//	ELSE
//		smsgtxt = '영업 판매계획 수량 ▶ 연동 생산계획 수량 ' + "~n~n" +&
//					 left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext +& 
//					  ' 연동 생산계획을 생성 하시겠습니까?'
//	END IF
//			
//	if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   
//	
//	SetPointer(HourGlass!)
//	st_msg.text = "연동 생산계획 자료 생성 中 .......... "
//	//이전월에 확정,조정구분 가져오기
//	  SELECT MAX("MONPLN_SUM"."MOSEQ")  
//		 INTO :i_jseq  
//		 FROM "MONPLN_SUM"  
//		WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND  
//				( "MONPLN_SUM"."MONYYMM" =
//					 to_char(add_months(to_date(:s_yymm,'yyyymm'),-1),'yyyymm') )   ;
//	
//	lRtnValue = sqlca.erp000000030(gs_sabu, s_yymm, i_seq, i_jseq, is_gubun, sItemgub, ssaupj)
end if	

IF lRtnValue < 0 THEN
	ROLLBACK;
	f_message_chk(41,'')
	st_msg.text = string(lRtnValue) 
	Return
ELSE
	commit ;
	st_msg.text = string(lRtnValue) + '건에 자료가 생성처리 되었습니다!!'
END IF


end event

type st_msg from statictext within w_pdt_01011
integer x = 50
integer y = 592
integer width = 1856
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_exit from commandbutton within w_pdt_01011
integer x = 1481
integer y = 1576
integer width = 439
integer height = 92
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

type rr_1 from roundrectangle within w_pdt_01011
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 69
integer y = 44
integer width = 1353
integer height = 124
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ip from datawindow within w_pdt_01011
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 64
integer y = 196
integer width = 1774
integer height = 404
integer taborder = 10
string dataobject = "d_pdt_01011"
boolean border = false
boolean livescroll = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF

end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;string snull, syymm, s_gub
int    iseq, inull, get_yeacha

setnull(snull)
setnull(inull)

IF this.GetColumnName() ="syymm" THEN
	syymm = trim(this.GetText())
	
	if syymm = "" or isnull(syymm) then
  		this.setitem(1, 'jjcha', 1)
		return 
	end if	

  	IF f_datechk(syymm + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", sNull)
  		this.setitem(1, 'jjcha', 1)
		return 1
	END IF
	
	SELECT MAX("MONPLN_SUM"."MOSEQ")  
	  INTO :get_yeacha  
	  FROM "MONPLN_SUM"  
	 WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;

	if get_yeacha = 0 or isnull(get_yeacha) then get_yeacha = 1

	this.setitem(1, 'jjcha', get_yeacha )
ELSEIF this.GetColumnName() ="jjcha" THEN
	this.accepttext()
	iseq  = integer(this.gettext())
   syymm = trim(this.getitemstring(1, 'syymm'))
	
	if iseq = 0  or isnull(iseq)  then return 
	
	if syymm = "" or isnull(syymm) then 
		messagebox("확인", "기준년월을 먼저 입력 하십시요!!")
  		this.setitem(1, 'jjcha', inull)
		this.setcolumn('syymm')
		this.setfocus()
		return 1
	end if		
   SELECT MAX("MONPLN_SUM"."MOSEQ")  
	  INTO :get_yeacha  
     FROM "MONPLN_SUM"  
    WHERE ( "MONPLN_SUM"."SABU" = :gs_sabu ) AND ( "MONPLN_SUM"."MONYYMM" = :syymm ) ;
   
	//확정계획이 없는 경우 조정계획을 입력할 수 없고
	if isnull(get_yeacha) or get_yeacha = 0  then
		IF iseq <> 1 then
   		messagebox("확인", left(syymm,4)+"년 "+mid(syymm,5,2)+"월에 확정/조정계획이 없으니 " &
			                   + "확정만 입력가능합니다!!")
	  		this.setitem(1, 'jjcha', 1)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
      end if		
	//조정계획이 있는 경우 확정계획을 입력할 수 없다.	
	elseif get_yeacha = 2 then
		if iseq = 1 then
   		messagebox("확인", left(syymm,4)+"년 "+mid(syymm,5,2)+"월에 조정계획이 있으니 " &
			                   + "확정은 입력할 수 없습니다!!")
	  		this.setitem(1, 'jjcha', 2)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
		end if		
   end if		
//ELSEIF this.GetColumnName() ="salegub" THEN
//   s_gub = this.gettext()
//	
//	if s_gub = '1' then 
//		cb_2.enabled = false
//	else
//		cb_2.enabled = true
//	end if
ELSEIF this.GetColumnName() ="saupj" THEN	
	s_gub = this.gettext()

	f_child_saupj(this, 'steam', s_gub)
END IF

end event

event itemerror;RETURN 1
end event

