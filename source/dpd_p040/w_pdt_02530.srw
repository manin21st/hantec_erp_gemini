$PBExportHeader$w_pdt_02530.srw
$PBExportComments$** 생산승인현황
forward
global type w_pdt_02530 from w_standard_print
end type
type st_1 from statictext within w_pdt_02530
end type
type rb_1 from radiobutton within w_pdt_02530
end type
type rb_2 from radiobutton within w_pdt_02530
end type
type rb_3 from radiobutton within w_pdt_02530
end type
type st_2 from statictext within w_pdt_02530
end type
type ddlb_1 from dropdownlistbox within w_pdt_02530
end type
type rr_1 from roundrectangle within w_pdt_02530
end type
end forward

global type w_pdt_02530 from w_standard_print
string title = "생산승인현황"
st_1 st_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_2 st_2
ddlb_1 ddlb_1
rr_1 rr_1
end type
global w_pdt_02530 w_pdt_02530

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sDate1,sDate2, spdtgu, sittyp, sfitcls, stitcls, sitnbr, sorder_no
String ChkDate1,ChkDate2,ls_gubun

if dw_ip.AcceptText() = -1 then return -1

sPdtgu = dw_ip.GetItemString(1,"pdtgu")
sDate1 = trim(dw_ip.GetItemString(1,"order_date"))
sDate2 = trim(dw_ip.GetItemString(1,"order_date1"))
sittyp = trim(dw_ip.GetItemString(1,"ittyp"))
sfitcls = trim(dw_ip.GetItemString(1,"fitcls"))
stitcls = trim(dw_ip.GetItemString(1,"titcls"))
sitnbr  = trim(dw_ip.GetItemString(1,"itnbr"))
sorder_no  = trim(dw_ip.GetItemString(1,"order_no"))

IF sDate1 = '' OR ISNULL(sDate1) THEN  sDate1 = '10000101'
IF sDate2 = '' OR ISNULL(sDate2) THEN  sDate2 = '99991231'
IF sittyp = '' OR ISNULL(sittyp) THEN  sittyp = '%'
IF sfitcls = '' OR ISNULL(sfitcls) THEN  sfitcls = '.'
IF stitcls = '' OR ISNULL(stitcls) THEN 
	stitcls = 'zzzzzzz'
else
	stitcls = stitcls + 'zzzzzzz'
end if
IF sitnbr = '' OR ISNULL(sitnbr) THEN 
	sitnbr = '%'
else
	sitnbr = sitnbr + '%'
end if
IF sorder_no = '' OR ISNULL(sorder_no) THEN 
	sorder_no = '%'
else
	sorder_no = sorder_no + '%'
end if

IF ChkDate1 > ChkDate2 THEN
	MessageBox("확인","승인일자범위를 확인하세요")
	dw_ip.SetColumn("order_date")
	dw_ip.SetFocus() 
	return -1
END IF	

IF rb_1.Checked THEN  //의뢰시
	dw_print.Dataobject = "dw_pdt_02530"
   dw_list.Dataobject = "dw_pdt_02530"
	dw_print.SetTransObject(sqlca)
	dw_list.SetTransObject(sqlca)
  
	IF dw_print.Retrieve(gs_sabu,sDate1,sDate2, sorder_no, sittyp, sfitcls, stitcls, sitnbr) < 1 THEN
		f_message_chk(50,'')
		return -1		
	END IF
	
	dw_list.Modify( "t_sdate1.Text='" + String(sDate1, '@@@@.@@.@@') + "'")
	dw_list.Modify( "t_sdate2.Text='" + String(sDate2, '@@@@.@@.@@') + "'")
	dw_print.Modify( "t_sdate1.Text='" + String(sDate1, '@@@@.@@.@@') + "'")
	dw_print.Modify( "t_sdate2.Text='" + String(sDate2, '@@@@.@@.@@') + "'")

ELSEIF rb_3.Checked THEN 	 //미승인시
	dw_print.Dataobject = "dw_pdt_02530_1_p"
	dw_list.Dataobject = "dw_pdt_02530_1"
	dw_print.SetTransObject(sqlca)
   dw_list.SetTransObject(sqlca)   

	IF dw_print.Retrieve(gs_sabu, SDATE1, SDATE2, sorder_no, sittyp, sfitcls, stitcls, sitnbr) < 1 THEN
		f_message_chk(50,'')
	   return -1		
	END IF	

ELSEIF rb_2.Checked THEN 	 //승인시
	ls_gubun = trim(ddlb_1.text)
	IF ls_gubun = '확정' THEN                //확정인경우  
	   dw_print.Dataobject = "dw_pdt_02530_2_p"
      dw_list.Dataobject = "dw_pdt_02530_2"
   ELSEIF ls_gubun = '미확정' THEN
      dw_print.Dataobject = "dw_pdt_02530_3_p" //미확정인경우
      dw_list.Dataobject = "dw_pdt_02530_3"
   ELSE
      dw_print.Dataobject = "dw_pdt_02530_4_p" //ALL인경우
      dw_list.Dataobject = "dw_pdt_02530_4" 
   END IF
	
	dw_print.SetTransObject(sqlca)
   dw_list.SetTransObject(sqlca) 
	IF dw_print.Retrieve(gs_sabu,sDate1,sDate2, sorder_no, sittyp, sfitcls, stitcls, sitnbr) < 1 THEN
		f_message_chk(50,'')
	   return -1		
	END IF	

END IF	

if spdtgu = ""	or isnull(spdtgu) then	
  dw_print.setfilter('')  
else	  
  dw_print.setfilter("pdtgu = '"+ spdtgu +"'")  
end if

dw_print.filter()

dw_print.sharedata(dw_list)

return 1
end function

on w_pdt_02530.create
int iCurrent
call super::create
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_2=create st_2
this.ddlb_1=create ddlb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.ddlb_1
this.Control[iCurrent+7]=this.rr_1
end on

on w_pdt_02530.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_2)
destroy(this.ddlb_1)
destroy(this.rr_1)
end on

event open;call super::open;st_2.visible  = False
ddlb_1.visible  = False 
dw_ip.SetItem(1,"order_date",F_today())
dw_ip.SetItem(1,"order_date1",F_today())
ddlb_1.selectitem("확정",1)

end event

type p_preview from w_standard_print`p_preview within w_pdt_02530
end type

type p_exit from w_standard_print`p_exit within w_pdt_02530
end type

type p_print from w_standard_print`p_print within w_pdt_02530
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02530
end type







type st_10 from w_standard_print`st_10 within w_pdt_02530
end type

type gb_10 from w_standard_print`gb_10 within w_pdt_02530
boolean visible = false
integer x = 206
integer y = 2364
integer height = 144
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type dw_print from w_standard_print`dw_print within w_pdt_02530
string dataobject = "dw_pdt_02530_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02530
integer x = 73
integer y = 32
integer width = 2880
integer height = 192
string dataobject = "d_pdt_02530_ret"
end type

event dw_ip::ue_pressenter;send(handle(this), 256, 9, 0)

return 1
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;
string snull, s_cod, sSugugb, sPrint_yn, sPangbn, sAgrdat

SetNull(snull)
Choose Case GetColumnName() 
	 Case "order_date"
			s_cod = Trim(this.GetText())
		   IF s_cod = '' or isnull(s_cod) then return 
 		   if f_datechk(s_cod) = -1 then
				F_message_chk(35,'[수주승인일]')
				setitem(1, 'sdate', snull)
				return 1
			end if 
	 Case "order_date1"
			s_cod = Trim(this.GetText())
		   IF s_cod = '' or isnull(s_cod) then return 
 		   if f_datechk(s_cod) = -1 then
				F_message_chk(35,'[수주승인일]')
				setitem(1, 'edate', snull)
				return 1
			end if 
END Choose


end event

event dw_ip::rbuttondown;call super::rbuttondown;string sittyp
str_itnct lstr_sitnct

setnull( gs_code) 
setnull( gs_codename )
setnull( gs_gubun ) 

IF this.GetColumnName() = 'order_no'	THEN
	Open(w_suju_popup)
	IF gs_code = '' or isnull(gs_code) then return 
	SetItem(1, "order_no", gs_code)
//	this.triggerevent(itemchanged!)
elseif this.GetColumnName() = 'fitcls' then
	sIttyp   = this.getitemstring(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1, "ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1, "fitcls", lstr_sitnct.s_sumgub)
elseif this.GetColumnName() = 'titcls' then
	sIttyp   = this.getitemstring(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1, "ittyp", lstr_sitnct.s_ittyp)
	this.SetItem(1, "titcls", lstr_sitnct.s_sumgub)
elseIF this.GetColumnName() ="itnbr" THEN
	gs_gubun = '1'
	Open(w_itemas_popup3)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"itnbr",gs_code)
END IF

end event

type dw_list from w_standard_print`dw_list within w_pdt_02530
integer x = 96
integer width = 4489
integer height = 1956
string dataobject = "dw_pdt_02530"
boolean controlmenu = true
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type st_1 from statictext within w_pdt_02530
integer x = 1280
integer y = 240
integer width = 256
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "승인구분"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_pdt_02530
integer x = 1541
integer y = 240
integer width = 206
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "의뢰"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
st_2.visible  = False
//rb_4.visible  = False
//rb_5.visible  = False
//rb_6.visible  = False
ddlb_1.visible  = False
end event

type rb_2 from radiobutton within w_pdt_02530
integer x = 1751
integer y = 240
integer width = 206
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "승인"
borderstyle borderstyle = stylelowered!
end type

event clicked;
st_2.visible  = True
//rb_4.visible  = True
//rb_5.visible  = True
//rb_6.visible  = True
ddlb_1.visible  = true
end event

type rb_3 from radiobutton within w_pdt_02530
integer x = 1957
integer y = 240
integer width = 279
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "미승인"
borderstyle borderstyle = stylelowered!
end type

event clicked;
st_2.visible  = False
//rb_4.visible  = False
//rb_5.visible  = False
//rb_6.visible  = False
ddlb_1.visible  = False
end event

type st_2 from statictext within w_pdt_02530
integer x = 96
integer y = 240
integer width = 466
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "승인시 처리구분"
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_pdt_02530
integer x = 599
integer y = 240
integer width = 631
integer height = 484
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean autohscroll = true
boolean hscrollbar = true
string item[] = {"확정","미확정","All"}
borderstyle borderstyle = stylelowered!
end type

type rr_1 from roundrectangle within w_pdt_02530
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 78
integer y = 332
integer width = 4521
integer height = 1976
integer cornerheight = 40
integer cornerwidth = 55
end type

