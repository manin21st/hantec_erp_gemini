$PBExportHeader$w_pdt_01005.srw
$PBExportComments$** 년간 생산계획 조정
forward
global type w_pdt_01005 from w_inherite
end type
type dw_1 from u_key_enter within w_pdt_01005
end type
type rr_1 from roundrectangle within w_pdt_01005
end type
end forward

global type w_pdt_01005 from w_inherite
string title = "년 판매계획 접수"
dw_1 dw_1
rr_1 rr_1
end type
global w_pdt_01005 w_pdt_01005

type variables
string ls_text, is_pspec, is_jijil
Long   ilby
end variables

forward prototypes
public subroutine wf_modify (string ar_gub)
public subroutine wf_reset ()
end prototypes

public subroutine wf_modify (string ar_gub);//BackGround.Color ==> 12639424:Mint, 65535:노란색, 16777215:횐색, 12632256:회색	
//                     79741120 :Button face
string snull

setnull(snull)

IF ar_gub = '0' THEN
   dw_insert.DataObject ="d_pdt_01000_2" 
   dw_insert.SetTransObject(SQLCA)
ELSE
   dw_insert.DataObject ="d_pdt_01000_1" 
   dw_insert.SetTransObject(SQLCA)
END IF

end subroutine

public subroutine wf_reset ();string s_nextyear
int    get_yeacha

dw_1.setredraw(false)
dw_insert.setredraw(false)

dw_1.reset()
dw_insert.reset()

dw_1.insertrow(0)

s_nextyear = string(long(left(f_today(), 4)) + 1)

dw_1.setitem(1, 'syear', s_nextyear)

SELECT MAX("YEAPLN"."YEACHA")  
  INTO :get_yeacha  
  FROM "YEAPLN"  
 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
		 ( substr("YEAPLN"."YEAYYMM", 1, 4) = :s_nextyear )   ;

dw_1.setitem(1, "jjcha", get_yeacha)
dw_1.SetFocus()

dw_1.setredraw(true)
dw_insert.setredraw(true)

end subroutine

on w_pdt_01005.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_pdt_01005.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)

string s_nextyear
int    get_yeacha

s_nextyear = string(long(left(f_today(), 4)) + 1)

dw_1.setitem(1, 'syear', s_nextyear)

SELECT MAX("YEAPLN"."YEACHA")  
  INTO :get_yeacha  
  FROM "YEAPLN"  
 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
		 ( "YEAPLN"."YEAYYMM" like :s_nextyear||'%' )   ;

f_mod_saupj(dw_1, 'porgu')
f_child_saupj(dw_1, 'steam', gs_saupj)

// M환산기준
select to_number(dataname) INTO :ilby from syscnfg where sysgu = 'Y' and serial = 2 and lineno = :gs_saupj;
If IsNull(ilby) Or ilby <= 0 Then ilby = 500000

dw_1.setitem(1, "jjcha", get_yeacha)
dw_1.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_pdt_01005
integer x = 59
integer y = 404
integer width = 4512
integer height = 1808
string dataobject = "d_pdt_01005_1"
boolean border = false
boolean hsplitscroll = true
end type

type p_delrow from w_inherite`p_delrow within w_pdt_01005
boolean visible = false
integer y = 192
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdt_01005
boolean visible = false
integer y = 192
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdt_01005
integer x = 2309
integer y = 88
string picturename = "C:\erpman\image\판매계획_up.gif"
end type

event p_search::clicked;call super::clicked;string s_year
int    i_seq

if dw_1.AcceptText() = -1 then return 
s_year = trim(dw_1.GetItemString(1,'syear'))
i_seq  = dw_1.GetItemNumber(1,'jjcha')

if isnull(s_year) or s_year = "" then
	f_message_chk(30,'[계획년도]')
	dw_1.Setcolumn('syear')
	dw_1.SetFocus()
	return
end if

gs_code = s_year
gs_codename = string(i_seq) 
		
Open(w_pdt_01001)


end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\판매계획_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\판매계획_up.gif"
end event

type p_ins from w_inherite`p_ins within w_pdt_01005
boolean visible = false
integer y = 192
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdt_01005
end type

type p_can from w_inherite`p_can within w_pdt_01005
end type

event p_can::clicked;call super::clicked;wf_reset()

dw_insert.DataObject ="d_pdt_01005_1" 
dw_insert.SetTransObject(SQLCA)

dw_1.enabled = true
p_search.enabled = true
p_print.enabled = true
p_search.PictureName = "c:\erpman\image\판매계획_up.gif"
p_print.PictureName = "c:\erpman\image\계획조정_up.gif"
p_ins.enabled = false
p_del.enabled = false
p_ins.PictureName = "c:\erpman\image\추가_d.gif"
p_del.PictureName = "c:\erpman\image\삭제_d.gif"

ib_any_typing = FALSE

dw_1.setfocus()

end event

type p_print from w_inherite`p_print within w_pdt_01005
boolean visible = false
integer y = 192
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdt_01005
integer x = 4091
end type

event p_inq::clicked;call super::clicked;string s_gub, s_team, s_year, s_ittyp, s_fritcls, s_toitcls, s_fritnbr, s_toitnbr , ls_porgu
Int    i_seq

if dw_1.AcceptText() = -1 then return 

s_gub  	= dw_1.GetItemString(1,'sgub')
s_team 	= dw_1.GetItemString(1,'steam')
s_year 	= trim(dw_1.GetItemString(1,'syear'))
i_seq  	= dw_1.GetItemNumber(1,'jjcha')
ls_porgu 	= dw_1.GetItemString(1,'porgu')

if 	isnull(s_team) or s_team = "" then
	f_message_chk(30,'[생산팀]')
	dw_1.Setcolumn('steam')
	dw_1.SetFocus()
	return
end if	
if 	isnull(s_year) or s_year = "" then
	f_message_chk(30,'[계획년도]')
	dw_1.Setcolumn('syear')
	dw_1.SetFocus()
	return
end if	
if 	isnull(i_seq) or i_seq = 0 then
	f_message_chk(30,'[조정차수]')
	dw_1.Setcolumn('jjcha')
	dw_1.SetFocus()
	return
end if	

s_ittyp   = dw_1.GetItemString(1,'sittyp')
if	isnull(s_ittyp) or s_ittyp = "" then
	f_message_chk(30,'[품목구분]')
	dw_1.Setcolumn('sittyp')
	dw_1.SetFocus()
	return
end if	

s_fritcls = trim(dw_1.GetItemString(1,'fr_itcls'))
if	isnull(s_fritcls) or s_fritcls = "" then
		s_fritcls = '.'
	end if	
s_toitcls = trim(dw_1.GetItemString(1,'to_itcls'))
if	isnull(s_toitcls) or s_toitcls = "" then
	s_toitcls = 'zzzzzzz'
end if	

if	s_fritcls > s_toitcls then 
	f_message_chk(34,'[품목분류]')
	dw_1.Setcolumn('fr_itcls')
	dw_1.SetFocus()
	return
end if
	

// [ 구분   0 : 품목분류 , 1: 품번 ]
If 	s_gub = '0' then //품목분류로 조회
	if 	dw_insert.Retrieve(gs_sabu, ls_porgu, s_team,s_year,i_seq,s_ittyp,s_fritcls,s_toitcls) <= 0 then 
		f_message_chk(50,'')
		dw_1.Setcolumn('steam')
		dw_1.SetFocus()
		p_ins.enabled = true
		p_del.enabled = true
		p_ins.PictureName = "c:\erpman\image\추가_up.gif"
      	p_del.PictureName = "c:\erpman\image\삭제_up.gif"
      	return
	end if	
Else   //품번으로 조회
   	s_fritnbr = trim(dw_1.GetItemString(1,'fr_itnbr'))
	if 	isnull(s_fritnbr) or s_fritnbr = "" then
      	s_fritnbr = '.'
   	end if	
   	s_toitnbr = trim(dw_1.GetItemString(1,'to_itnbr'))
	if 	isnull(s_toitnbr) or s_toitnbr = "" then
      	s_toitnbr = 'zzzzzzzzzzzzzzz'
   	end if	
   	if 	s_fritnbr > s_toitnbr then 
		f_message_chk(34,'[품번]')
		dw_1.Setcolumn('fr_itnbr')
		dw_1.SetFocus()
		return
	end if	
	if 	dw_insert.Retrieve(gs_sabu, ls_porgu, s_team,s_year,i_seq,s_ittyp,s_fritcls,s_toitcls, ilby) <= 0 then 
		f_message_chk(50,'')
		dw_1.Setcolumn('steam')
		dw_1.SetFocus()
		p_ins.enabled = true
		p_del.enabled = true
		p_ins.PictureName = "c:\erpman\image\추가_up.gif"
      	p_del.PictureName = "c:\erpman\image\삭제_up.gif"
      	return
   	end if	
End if	

p_ins.enabled = true
p_del.enabled = true
p_ins.PictureName = "c:\erpman\image\추가_up.gif"
p_del.PictureName = "c:\erpman\image\삭제_up.gif"
dw_1.enabled = false
p_search.enabled = false
p_print.enabled = false
p_search.PictureName = "c:\erpman\image\판매계획_d.gif"
p_print.PictureName = "c:\erpman\image\계획조정_d.gif"
ib_any_typing = FALSE

end event

type p_del from w_inherite`p_del within w_pdt_01005
boolean visible = false
integer y = 196
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_pdt_01005
boolean visible = false
integer y = 196
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_pdt_01005
end type

type cb_mod from w_inherite`cb_mod within w_pdt_01005
end type

type cb_ins from w_inherite`cb_ins within w_pdt_01005
end type

type cb_del from w_inherite`cb_del within w_pdt_01005
end type

type cb_inq from w_inherite`cb_inq within w_pdt_01005
end type

type cb_print from w_inherite`cb_print within w_pdt_01005
end type

type st_1 from w_inherite`st_1 within w_pdt_01005
end type

type cb_can from w_inherite`cb_can within w_pdt_01005
end type

type cb_search from w_inherite`cb_search within w_pdt_01005
end type







type gb_button1 from w_inherite`gb_button1 within w_pdt_01005
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_01005
end type

type dw_1 from u_key_enter within w_pdt_01005
integer x = 50
integer y = 84
integer width = 2245
integer height = 296
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_pdt_01005_a"
boolean border = false
end type

event itemchanged;call super::itemchanged;string snull, syear, s_name, s_itt, s_nextyear, s_gub, steam, steamnm, stitnm, stextnm
int    iseq, inull, get_yeacha, i

setnull(snull)
setnull(inull)
IF this.GetColumnName() ="porgu" THEN
	s_gub = trim(this.GetText())
	
	//생산팀
	f_child_saupj(this, 'steam', s_gub)
ELSEIF this.GetColumnName() ="syear" THEN
	syear = trim(this.GetText())
	
	if syear = "" or isnull(syear) then
  		this.setitem(1, 'jjcha', inull)
		return 
	end if	

	SELECT MAX("YEAPLN"."YEACHA")  
	  INTO :get_yeacha  
	  FROM "YEAPLN"  
	 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
			 ( "YEAPLN"."YEAYYMM" like :syear||'%' )   ;
	
	this.setitem(1, 'jjcha', get_yeacha)

ELSEIF this.GetColumnName() ="jjcha" THEN
	this.accepttext()
	iseq = integer(this.GetText())
   syear = this.getitemstring(1, 'syear')
	
	if iseq = 0  or isnull(iseq)  then return 
	
	if syear = "" or isnull(syear) then 
		messagebox("확인", "계획년도를 먼저 입력 하십시요!!")
		this.setcolumn('syear')
		this.setfocus()
		return 1
	end if		
		
	SELECT MAX("YEAPLN"."YEACHA")  
	  INTO :get_yeacha  
	  FROM "YEAPLN"  
	 WHERE ( "YEAPLN"."SABU" = :gs_sabu ) AND  
			 ( "YEAPLN"."YEAYYMM" like :syear||'%' )  ;
			 
	if isnull(get_yeacha) or get_yeacha = 0  then
		IF iseq <> 1 then
   		messagebox("확인", syear + "년에 최종 조정차수가 없으니 " &
			                   + "1차만 입력가능합니다!!")
	  		this.setitem(1, 'jjcha', 1)
       	this.setcolumn('jjcha')
         this.setfocus()
 			return 1
      end if		
	else
		if iseq > get_yeacha + 1 then
   		messagebox("확인", syear + "년에 최종 조정차수가 " + &
			                   string(get_yeacha) + "차 입니다!!")
			this.setitem(1, 'jjcha', get_yeacha)
       	this.setcolumn('jjcha')
         this.setfocus()
			return 1
		end if		
   end if		
ELSEIF this.GetColumnName() = 'sittyp' THEN
	s_itt = this.gettext()
 
   IF s_itt = "" OR IsNull(s_itt) THEN 
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_itt)
	IF	isnull(s_name) or s_name="" THEN
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'sittyp', snull)
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		return 1
   ELSEIF s_itt = '1' or s_itt = '2' or s_itt = '6' THEN //1완제품, 2반제품, 6상품  
   ELSE 	
		f_message_chk(61,'[품목구분]')
		this.SetItem(1,'sittyp', snull)
		this.SetItem(1,'fr_itcls', snull)
		this.SetItem(1,'to_itcls', snull)
		return 1
   END IF	
ELSEIF this.GetColumnName() = 'sgub' THEN
	s_gub = this.gettext()
    	
	wf_modify(s_gub)
END IF

end event

event itemerror;call super::itemerror;return 1
end event

event rbuttondown;call super::rbuttondown;string  sname
str_itnct lstr_sitnct

setnull(gs_code)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
   	gs_code = this.GetText()
     	setNull(gs_gubun)
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
elseif this.GetColumnName() = 'to_itnbr' then
     	setNull(gs_gubun)
   	gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
elseif this.GetColumnName() = 'fr_itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'sittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
		return 
	elseif lstr_sitnct.s_ittyp = '1' or lstr_sitnct.s_ittyp = '2' or &
		    lstr_sitnct.s_ittyp = '6' THEN //1완제품, 2반제품, 6상품  
		this.SetItem(1,"sittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"fr_itcls", lstr_sitnct.s_sumgub)
	else
		f_message_chk(61,'[품목구분]')
		return 1
 	end if	
elseif this.GetColumnName() = 'to_itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'sittyp')
	OpenWithParm(w_ittyp_popup, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then 
		return 
	elseif lstr_sitnct.s_ittyp = '1' or lstr_sitnct.s_ittyp = '2' or &
		    lstr_sitnct.s_ittyp = '6' THEN //1완제품, 2반제품, 6상품  
		this.SetItem(1,"sittyp",lstr_sitnct.s_ittyp)
		this.SetItem(1,"to_itcls", lstr_sitnct.s_sumgub)
	else
		f_message_chk(61,'[품목구분]')
		return 1
 	end if	
end if	

end event

type rr_1 from roundrectangle within w_pdt_01005
long linecolor = 29455689
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 396
integer width = 4544
integer height = 1836
integer cornerheight = 40
integer cornerwidth = 55
end type

