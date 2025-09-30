$PBExportHeader$w_pdt_01002.srw
$PBExportComments$** 년간 생산계획 조정(계획 일괄 조정)
forward
global type w_pdt_01002 from window
end type
type p_4 from uo_picture within w_pdt_01002
end type
type p_cancel from uo_picture within w_pdt_01002
end type
type p_2 from uo_picture within w_pdt_01002
end type
type p_1 from uo_picture within w_pdt_01002
end type
type dw_update from datawindow within w_pdt_01002
end type
type dw_list from datawindow within w_pdt_01002
end type
type dw_ip from datawindow within w_pdt_01002
end type
type rr_1 from roundrectangle within w_pdt_01002
end type
end forward

global type w_pdt_01002 from window
integer x = 123
integer y = 124
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "계획 일괄 조정"
windowtype windowtype = response!
long backcolor = 32106727
p_4 p_4
p_cancel p_cancel
p_2 p_2
p_1 p_1
dw_update dw_update
dw_list dw_list
dw_ip dw_ip
rr_1 rr_1
end type
global w_pdt_01002 w_pdt_01002

type variables
str_itnct lstr_sitnct
string   is_year

end variables

event open;f_window_center(this)
//f_window_center_response(this)

is_year = gs_code
if 	is_year = '' or isnull(is_year) then 
	is_year = string(long(left(f_today(), 4)) + 1) 
end if

dw_update.SetTransObject(SQLCA)
p_cancel.TriggerEvent(Clicked!)

f_mod_saupj(dw_ip, 'porgu')
end event

on w_pdt_01002.create
this.p_4=create p_4
this.p_cancel=create p_cancel
this.p_2=create p_2
this.p_1=create p_1
this.dw_update=create dw_update
this.dw_list=create dw_list
this.dw_ip=create dw_ip
this.rr_1=create rr_1
this.Control[]={this.p_4,&
this.p_cancel,&
this.p_2,&
this.p_1,&
this.dw_update,&
this.dw_list,&
this.dw_ip,&
this.rr_1}
end on

on w_pdt_01002.destroy
destroy(this.p_4)
destroy(this.p_cancel)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_update)
destroy(this.dw_list)
destroy(this.dw_ip)
destroy(this.rr_1)
end on

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
	/* 단축키 */
	Case KeyQ!
		p_1.TriggerEvent(Clicked!)
	Case KeyC!
		p_cancel.TriggerEvent(Clicked!)
	Case KeyX!
		p_4.TriggerEvent(Clicked!)
end choose
end event

type p_4 from uo_picture within w_pdt_01002
integer x = 4439
integer y = 28
integer width = 178
string picturename = "c:\erpman\image\닫기_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\닫기_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\닫기_dn.gif"
end event

event clicked;call super::clicked;close(parent)
end event

type p_cancel from uo_picture within w_pdt_01002
integer x = 4265
integer y = 28
integer width = 178
string picturename = "c:\erpman\image\취소_up.gif"
end type

event clicked;Int iMaxSeq

dw_ip.reset()
dw_ip.settransobject(sqlca)
dw_list.reset()
dw_update.reset()
dw_list.DataObject = 'd_pdt_01002_2'
dw_list.settransobject(sqlca)

dw_ip.InsertRow(0)

dw_ip.setitem(1, 'syear', is_year)

  SELECT MAX("YEAPLN"."YEACHA")  
    INTO :iMaxSeq
    FROM "YEAPLN"  
   WHERE ( "YEAPLN"."SABU"    = :gs_sabu ) AND  
         ( "YEAPLN"."YEAYYMM" LIKE :is_year||'%' ) AND  
         ( "YEAPLN"."YEAGU"   = 'A' )   ;

dw_ip.setitem(1, 'jjcha', iMaxSeq)

dw_ip.setfocus()


end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\취소_dn.gif"
end event

type p_2 from uo_picture within w_pdt_01002
integer x = 4091
integer y = 28
integer width = 178
string picturename = "c:\erpman\image\일괄조정_up.gif"
end type

event clicked;string s_year, s_Jyear, sitnbr, sgub, smsgtxt, ls_porgu
int    i_seq
long   lRtnValue, lcount, k, i, lrow
dec {2} drate

if 	dw_ip.AcceptText() = -1 then return 
if 	dw_list.AcceptText() = -1 then return 

lcount = dw_list.rowcount()

if 	lcount < 1 then
	messagebox('확 인', '처리 할 자료가 없습니다. 자료를 먼저 조회하세요!')
	return 
end if

dw_update.reset()

s_year 	= dw_list.GetItemString(1, 'syear')
i_seq  	= dw_list.GetItemNumber(1, 'lseq')
sgub   	= dw_list.GetItemString(1, 'gubun')  //1:분류코드, 2:품번
ls_porgu 	= dw_list.GetItemString(1, 'porgu')

smsgtxt 	= s_year + '년 ' + string(i_seq) + '차 생산계획을 일괄조정 처리 하시겠습니까?'

if 	messagebox("확 인", smsgtxt, Question!, YesNo!, 2) = 2 then return   

// sgub 구분 (1:분류코드, 2:품번)
if 	sgub 	= '1'	then
	DELETE  
		FROM "YEAPLN_RATE"  Y2
 		WHERE 	EXISTS(SELECT * FROM ITNCT WHERE ITNCT.ITTYP = Y2.ITTYP AND ITNCT.ITCLS = Y2.ITNBR AND ITNCT.PORGU LIKE :ls_porgu)
					AND  	( Y2."SABU"      	=  :gs_sabu) AND  
		 					( Y2."YEAYEAR" 	=  :s_year ) AND  
		 					( Y2."YEACHA" 	=  :i_seq)   ;
Else
	DELETE  
		FROM "YEAPLN_RATE"  Y2
 		WHERE 	EXISTS(	SELECT * FROM ITEMAS, ITNCT 
		 						WHERE ITEMAS.ITNBR = Y2.ITNBR AND 
								 ITNCT.ITCLS = ITEMAS.ITCLS AND 
								 ITNCT.ITTYP = ITEMAS.ITTYP AND 
								 ITNCT.PORGU LIKE :ls_porgu)
					AND  	( Y2."SABU"      	=  :gs_sabu) AND  
		 					( Y2."YEAYEAR" 	=  :s_year ) AND  
		 					( Y2."YEACHA" 	=  :i_seq)   ;
End if	

//DELETE FROM "YEAPLN_RATE"  
// WHERE ( "YEAPLN_RATE"."SABU" =  :gs_sabu) AND  
//		 ( "YEAPLN_RATE"."YEAYEAR" = :s_year ) AND  
//		 ( "YEAPLN_RATE"."YEACHA" =  :i_seq)   ;

if 	sqlca.sqlcode <> 0 then 
	rollback ;
   	messagebox("삭제실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if

FOR k = 1 TO lcount
	dRate = dw_list.getitemdecimal(k, 'p_rate') 
	
	if drate = 0 then continue 
	i ++ 
	
	lrow = dw_update.insertrow(0)
	
	dw_update.setitem(lrow, 'sabu', gs_sabu)
	dw_update.setitem(lrow, 'yeayear', s_year)
	dw_update.setitem(lrow, 'yeacha', i_seq)
	dw_update.setitem(lrow, 'gubun', sgub)
	dw_update.setitem(lrow, 'itnbr', dw_list.getitemstring(k, 'itnbr'))
	dw_update.setitem(lrow, 'ittyp', dw_list.getitemstring(k, 'ittyp'))
	dw_update.setitem(lrow, 'rate',  dRate)
	
NEXT

if i < 1 then
	messagebox('확 인', '처리 할 자료가 없습니다. 수량 조정율을 입력하세요!')
	return 
end if

if 	dw_update.update() = 1 then
	commit ;
else
	rollback ;
   	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	

lRtnValue = sqlca.erp000000025(gs_sabu, ls_porgu,s_year, i_seq, sgub)

IF 	lRtnValue < 0 THEN
	ROLLBACK;
	f_message_chk(41,'ERROR CODE ' + STRING(lRtnValue) )
	Return
ELSE
	commit ;
   	messagebox("완료", "자료처리가 완료되었습니다.")
	p_1.triggerevent(clicked!)
END IF


end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\일괄조정_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\일괄조정_dn.gif"
end event

type p_1 from uo_picture within w_pdt_01002
integer x = 3918
integer y = 28
integer width = 178
boolean originalsize = true
string picturename = "c:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;string s_year, s_jyear, s_gub, spdtgu, sittyp, sitcls, sfitnbr, stitnbr, sLms, sLms2, sLms3, ls_porgu
int    i_seq

if dw_ip.AcceptText() = -1 then return 
s_year  	= dw_ip.GetItemString(1,'syear')
s_gub   	= dw_ip.GetItemString(1,'gub')
sittyp  		= dw_ip.GetItemString(1,'ittyp')
spdtgu  	= dw_ip.GetItemString(1,'steam')
ls_porgu 	= dw_ip.GetItemString(1,'porgu')

i_seq  	= dw_ip.GetItemNumber(1,'jjcha')

if 	isnull(s_year) or s_year = "" then
	f_message_chk(30,'[계획년도]')
	dw_ip.Setcolumn('syear')
	dw_ip.SetFocus()
	return
else
	s_jyear = string(long(s_year) - 1)
end if

if 	isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[최종차수]')
	dw_ip.Setcolumn('syear')
	dw_ip.SetFocus()
	return
end if

if 	isnull(spdtgu) or spdtgu = "" then spdtgu = '%'

if 	s_gub = '1' then 
	sitcls = dw_ip.GetItemString(1,'itcls')
	sLms   = dw_ip.GetItemString(1,'smlgub')
	if isnull(sitcls) or sitcls = "" then 
		sitcls = '%'
	else
		sitcls = sitcls + '%'
	end if
   	if 	slms = 'L' then 	
		slms2 = 'M'
		slms3 = 'S'
   	else
		slms2 = 'S'
		slms3 = 'S'
	end if
	if 	dw_list.retrieve(gs_sabu, ls_porgu, s_year, i_seq, s_jyear, sitcls, sLms, sLms2, sLms3,  &
	                    spdtgu, sittyp) < 1 then 
		f_message_chk(50,'')
		dw_ip.SetFocus()
   	end if
else
	sfitnbr = dw_ip.GetItemString(1,'fitnbr')
	stitnbr = dw_ip.GetItemString(1,'titnbr')
	
	if 	isnull(sfitnbr) or sfitnbr = "" then sfitnbr = '.'
	if 	isnull(stitnbr) or stitnbr = "" then stitnbr = 'zzzzzzzzzzzzzzz'
	
	if 	dw_list.retrieve(gs_sabu, ls_porgu, s_year, i_seq, s_jyear, sfitnbr, stitnbr,  &
	                    spdtgu, sittyp) < 1 then 
		f_message_chk(50,'')
		dw_ip.SetFocus()
   end if
end if


end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "c:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;pictureName = "c:\erpman\image\조회_dn.gif"
end event

type dw_update from datawindow within w_pdt_01002
boolean visible = false
integer x = 3369
integer y = 244
integer width = 1202
integer height = 120
string dataobject = "d_pdt_01002_update"
borderstyle borderstyle = stylelowered!
end type

type dw_list from datawindow within w_pdt_01002
event ue_pressenter pbm_dwnprocessenter
integer x = 18
integer y = 428
integer width = 4535
integer height = 1872
integer taborder = 30
string dataobject = "d_pdt_01002_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

type dw_ip from datawindow within w_pdt_01002
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 9
integer width = 3141
integer height = 400
integer taborder = 10
string dataobject = "d_pdt_01002"
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

event itemchanged;string snull, syear, scode, sname, sittyp  
int    inull, get_yeacha, ireturn 

setnull(snull)
setnull(inull)

IF this.GetColumnName() ="syear" THEN
	syear = trim(this.GetText())
	
	if syear = "" or isnull(syear) then
  		this.setitem(1, 'jjcha', inull)
		return 
	end if	

	SELECT MAX("YEAPLN"."YEACHA")  
	  INTO :get_yeacha  
	  FROM "YEAPLN"  
	 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
			 ( "YEAPLN"."YEAYYMM" like :syear||'%' )  AND  
          ( "YEAPLN"."YEAGU"   = 'A' )   ;
	
	this.setitem(1, 'jjcha', get_yeacha)
ELSEIF this.GetColumnName() ="gub" THEN
	scode   = this.GetText()
	
	if scode = '1' then 
		dw_list.DataObject = 'd_pdt_01002_2'
	else
		dw_list.DataObject = 'd_pdt_01002_1'
		IF f_change_name('1') = 'Y' then 
			string is_pspec, is_jijil 
			is_pspec = f_change_name('2')
			is_jijil = f_change_name('3')
			dw_list.object.ispec_t.text = is_pspec
			dw_list.object.jijil_t.text = is_jijil
		END IF
	end if
	dw_list.settransobject(sqlca)
ELSEIF this.GetColumnName() ="ittyp" THEN
	this.setitem(1, "itcls", snull)
	this.setitem(1, "itnm",  snull)
ELSEIF this.GetColumnName() ="itcls" THEN
	scode   = trim(this.GetText())
	sittyp  = this.getitemstring(1, 'ittyp')
  	ireturn = f_get_name2('품목분류', 'Y', scode, sname, sittyp) 
	this.setitem(1, "itcls", scode)
	this.setitem(1, "itnm",  sname)
	return ireturn 	
END IF

end event

event itemerror;RETURN 1
end event

event rbuttondown;string sittyp

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

//this.accepttext()
if this.GetColumnName() = 'itcls' then

	sIttyp = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	this.SetItem(1,"ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.setitem(1, "itnm", lstr_sitnct.s_titnm)
elseif this.GetColumnName() = 'fitnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fitnbr",gs_code)
	this.SetItem(1,"titnbr",gs_code)
elseif this.GetColumnName() = 'titnbr' then
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"titnbr",gs_code)
end if	


end event

type rr_1 from roundrectangle within w_pdt_01002
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 416
integer width = 4613
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

