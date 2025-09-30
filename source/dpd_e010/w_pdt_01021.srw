$PBExportHeader$w_pdt_01021.srw
$PBExportComments$** 월 생산계획(월 계획 생성)
forward
global type w_pdt_01021 from window
end type
type p_exit from picture within w_pdt_01021
end type
type p_create from picture within w_pdt_01021
end type
type dw_ip from datawindow within w_pdt_01021
end type
type st_msg from statictext within w_pdt_01021
end type
end forward

global type w_pdt_01021 from window
integer x = 997
integer y = 676
integer width = 1467
integer height = 1088
boolean titlebar = true
string title = "월 계획 생성"
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_create p_create
dw_ip dw_ip
st_msg st_msg
end type
global w_pdt_01021 w_pdt_01021

type variables

end variables

event open;f_window_center(this)

dw_ip.settransobject(sqlca)
dw_ip.InsertRow(0)

dw_ip.setitem(1, 'syymm', gs_code)
dw_ip.setitem(1, 'jjcha', integer(gs_codename))

f_mod_saupj(dw_ip, 'saupj')
dw_ip.setfocus()

end event

on w_pdt_01021.create
this.p_exit=create p_exit
this.p_create=create p_create
this.dw_ip=create dw_ip
this.st_msg=create st_msg
this.Control[]={this.p_exit,&
this.p_create,&
this.dw_ip,&
this.st_msg}
end on

on w_pdt_01021.destroy
destroy(this.p_exit)
destroy(this.p_create)
destroy(this.dw_ip)
destroy(this.st_msg)
end on

type p_exit from picture within w_pdt_01021
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1216
integer y = 24
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event ue_lbuttondown;this.PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event ue_lbuttonup;this.PictureName = 'C:\erpman\image\닫기_up.gif'
end event

event clicked;close(parent)
end event

type p_create from picture within w_pdt_01021
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
integer x = 1033
integer y = 24
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

event clicked;string s_yymm, smsgtxt, stext, s_gub, s_toym, s_team, ssaupj
int    i_seq
long   lRtnValue, get_count

if dw_ip.AcceptText() = -1 then return 

ssaupj = trim(dw_ip.GetItemString(1,'saupj'))
s_gub  = trim(dw_ip.GetItemString(1,'gub1'))
s_team  = trim(dw_ip.GetItemString(1,'steam'))
s_yymm = trim(dw_ip.GetItemString(1,'syymm'))
i_seq  = dw_ip.GetItemNumber(1,'jjcha')

if isnull(s_yymm) or s_yymm = "" then
	f_message_chk(30,'[기준년월]')
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
		
	SELECT COUNT(*) 
	  INTO :get_count
	  FROM MONPLN_DTL A, ITEMAS B, ITNCT C
	 WHERE A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq AND
	       A.ITNBR = B.ITNBR AND B.ITTYP = C.ITTYP AND B.ITCLS = C.ITCLS AND 
	       C.PDTGU = :s_team ANd C.PORGU Like :ssaupj;
	
	IF get_count > 0 then 
		smsgtxt = '생산팀 => ' + left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
					 ' 연동 생산계획 일별 자료가 존재합니다. ' + "~n~n" +&
					  '연동 생산계획 일별 자료를 생성 하시겠습니까?'
	ELSE
		smsgtxt = '생산팀 => ' + left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + ' 연동 생산계획 일별 자료를 생성 하시겠습니까?'
	END IF
			
	if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   
	
	SetPointer(HourGlass!)
	st_msg.text = "생산팀별 연동 생산계획 일별 자료 생성 中 .......... "
	
	//표준공정에 평균시간('2') 또는 표준시간('1') 구분
	SELECT DATANAME INTO :s_gub FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 15 AND LINENO = 1 ;
	if trim(s_gub) = "" or isnull(s_gub) then
		s_gub = '1'
	end if
	
	lRtnValue = sqlca.erp000000040(gs_sabu, s_yymm, i_seq, ssaupj, s_team, s_gub)

else
	
	SELECT COUNT(*) 
	  INTO :get_count
	  FROM MONPLN_DTL A, ITEMAS B, ITNCT C
	 WHERE A.SABU = :gs_sabu AND A.MONYYMM = :s_yymm AND A.MOSEQ = :i_seq 
	   AND A.ITNBR = B.ITNBR AND B.ITTYP   = C.ITTYP AND B.ITCLS = C.ITCLS
		AND C.PORGU Like :ssaupj;
	
	IF get_count > 0 then 
		smsgtxt = left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + &
					 ' 연동 생산계획 일별 자료가 존재합니다. ' + "~n~n" +&
					  '연동 생산계획 일별 자료를 생성 하시겠습니까?'
	ELSE
		smsgtxt = left(s_yymm, 4) + '년 ' + mid(s_yymm, 5, 2) + '월 ' + stext + ' 연동 생산계획 일별 자료를 생성 하시겠습니까?'
	END IF
			
	if messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   
	
	SetPointer(HourGlass!)
	st_msg.text = "연동 생산계획 일별 자료 생성 中 .......... "
	
	//표준공정에 평균시간('2') 또는 표준시간('1') 구분
	SELECT DATANAME INTO :s_gub FROM SYSCNFG WHERE SYSGU = 'Y' AND SERIAL = 15 AND LINENO = 1 ;
	if trim(s_gub) = "" or isnull(s_gub) then
		s_gub = '1'
	end if
	
	lRtnValue = sqlca.erp000000040(gs_sabu, s_yymm, i_seq, ssaupj, '%', s_gub)

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

type dw_ip from datawindow within w_pdt_01021
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 32
integer y = 196
integer width = 1381
integer height = 620
integer taborder = 10
string dataobject = "d_pdt_01021"
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
ELSEIF this.GetColumnName() ="gub1" THEN
	this.setitem(1, "steam", sNull)
END IF

end event

event itemerror;RETURN 1
end event

type st_msg from statictext within w_pdt_01021
integer x = 27
integer y = 864
integer width = 1353
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

