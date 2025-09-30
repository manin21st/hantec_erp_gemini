$PBExportHeader$w_pdt_02840.srw
$PBExportComments$** 공수/비가동 현황
forward
global type w_pdt_02840 from w_standard_print
end type
type rb_02730 from radiobutton within w_pdt_02840
end type
type rb_02840 from radiobutton within w_pdt_02840
end type
type rb_02845 from radiobutton within w_pdt_02840
end type
type rb_02850 from radiobutton within w_pdt_02840
end type
type rb_02855 from radiobutton within w_pdt_02840
end type
type gb_1 from groupbox within w_pdt_02840
end type
type rr_1 from roundrectangle within w_pdt_02840
end type
end forward

global type w_pdt_02840 from w_standard_print
string title = "공수/비가동 현황"
rb_02730 rb_02730
rb_02840 rb_02840
rb_02845 rb_02845
rb_02850 rb_02850
rb_02855 rb_02855
gb_1 gb_1
rr_1 rr_1
end type
global w_pdt_02840 w_pdt_02840

forward prototypes
public function integer wf_retrieve_02845 ()
public function integer wf_retrieve_02850 ()
public function integer wf_retrieve_02855 ()
public function integer wf_retrieve_02730 ()
public function integer wf_retrieve_02840 ()
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve_02845 ();String  s_frTeam, s_toteam, s_yymm, sgub, s_frjo, s_tojo
long    lcount

sgub   = dw_ip.GetItemString(1,"gub")
s_yymm = trim(dw_ip.GetItemString(1,"syymm"))

IF s_yymm = "" OR IsNull(s_yymm) THEN
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("syymm")
	dw_ip.SetFocus()
	Return -1
END IF

s_frTeam  = dw_ip.GetItemString(1,"fr_pdtgu")
s_toTeam  = dw_ip.GetItemString(1,"to_pdtgu")

IF s_frteam = "" OR IsNull(s_frteam) THEN s_frteam = '.'
IF s_toteam = "" OR IsNull(s_toteam) THEN s_toteam = 'zzzzzz'

IF sgub = '1' THEN
	s_frjo    = dw_ip.GetItemString(1,"fr_jocod")
	s_tojo    = dw_ip.GetItemString(1,"to_jocod")
	IF s_frjo = "" OR IsNull(s_frjo) THEN s_frjo = '.'
	IF s_tojo = "" OR IsNull(s_tojo) THEN s_tojo = 'zzzzzz'
	dw_list.DataObject = "d_pdt_02845_1"
	dw_print.DataObject = "d_pdt_02845_1_p"
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	lCount = dw_list.Retrieve(gs_sabu, s_yymm, s_frteam, s_toteam, s_frjo, s_tojo)
	lCount = dw_print.Retrieve(gs_sabu, s_yymm, s_frteam, s_toteam, s_frjo, s_tojo)
ELSEIF sgub = '2' THEN 
	dw_list.DataObject = "d_pdt_02845_2"   //생산팀별
	dw_print.DataObject = "d_pdt_02845_2_p" 
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	lCount = dw_list.Retrieve(gs_sabu, s_yymm, s_frteam, s_toteam)
	lCount = dw_print.Retrieve(gs_sabu, s_yymm, s_frteam, s_toteam)
ELSE
	dw_list.DataObject = "d_pdt_02845_3"   //전체
	dw_print.DataObject = "d_pdt_02845_3_p"
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	lCount = dw_list.Retrieve(gs_sabu, s_yymm, s_frteam, s_toteam)
	lCount = dw_print.Retrieve(gs_sabu, s_yymm, s_frteam, s_toteam)
END IF

IF lCount < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
End if

Return 1



end function

public function integer wf_retrieve_02850 ();string sdate 

sdate = trim(dw_ip.object.sdate[1])

if IsNull(sdate) or sdate = "" then 
	f_message_chk(30,'[기준년도]')
	dw_ip.Setcolumn('sdate')
	dw_ip.SetFocus()
	return -1
end if	

dw_list.DataObject = "d_pdt_02850_1"   
dw_print.DataObject = "d_pdt_02850_1_p" 

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

if dw_print.Retrieve(gs_sabu, sdate) <= 0 then
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

dw_print.ShareData(dw_list)   

return 1
end function

public function integer wf_retrieve_02855 ();string sdate, sgub 

sdate = trim(dw_ip.object.sdate[1])

if IsNull(sdate) or sdate = "" then 
	f_message_chk(30,'[기준년도]')
	dw_ip.Setcolumn('sdate')
	dw_ip.SetFocus()
	return -1
end if	

//회수공수 시간적용구분( S => S/T, A => A/T )
SELECT DATANAME  
  INTO :sgub 
  FROM SYSCNFG  
 WHERE SYSGU = 'Y' AND SERIAL = 34 AND LINENO = '1' ;

IF sgub = '' or isnull(sgub) then sgub = 'S' 

dw_list.DataObject = "d_pdt_02855_1"   
dw_print.DataObject = "d_pdt_02855_1_p" 

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

if dw_print.Retrieve(gs_sabu, sdate, sgub) <= 0 then
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if
   
dw_print.sharedata(dw_list)
return 1
end function

public function integer wf_retrieve_02730 ();String sFrom,sTo,sGubn,snull,scodefrom, scodeto
string txt1, txt2 ,txt3, txt4, txt5, txt6, txt7, txt8, txt9,txt10, &
	 	 txt11,txt12,txt13,txt14,txt15,txt16,txt17,txt18,txt19,txt20

setnull(snull)

sFrom       = trim(dw_ip.GetItemString(1,"ntdat"))
sTo         = trim(dw_ip.GetItemString(1,"ntdatto"))
scodeFrom   = trim(dw_ip.GetItemString(1,"pdtgu"))
scodeTo     = trim(dw_ip.GetItemString(1,"pdtguto"))

IF sFrom ="" OR IsNull(sFrom) THEN sfrom = '10000101'

IF sTo ="" OR IsNull(sTo) THEN  sto = '99991231'

IF scodeFrom = "" OR isnull(scodeFrom) THEN
	  SELECT MIN("REFFPF"."RFGUB")  
	    INTO :scodeFrom  
  		 FROM "REFFPF"  
	   WHERE ( "REFFPF"."SABU" = '1' ) AND  
            ( "REFFPF"."RFCOD" = '03' )   ;
END IF

IF scodeTo = "" OR isnull(scodeTo) THEN
	  SELECT MAX("REFFPF"."RFGUB")  
	    INTO :scodeTo  
  		 FROM "REFFPF"  
	   WHERE ( "REFFPF"."SABU" = '1' ) AND  
            ( "REFFPF"."RFCOD" = '03' )   ;
END IF	

IF	( scodeFrom > scodeTo  )	  then
	MessageBox("확인","생산팀의 범위를 확인하세요!")
	dw_ip.setcolumn('pdtgu')
	dw_ip.setfocus()
	Return -1
END IF

//비가동인명 setting
 SELECT max(decode("REFFPF"."RFGUB",'100001', "REFFPF"."RFNA1" ))as text1,
			max(decode("REFFPF"."RFGUB",'100002', "REFFPF"."RFNA1" ))as text2,
			max(decode("REFFPF"."RFGUB",'100003', "REFFPF"."RFNA1" ))as text3,
			max(decode("REFFPF"."RFGUB",'100004', "REFFPF"."RFNA1" ))as text4,
			max(decode("REFFPF"."RFGUB",'100005', "REFFPF"."RFNA1" ))as text5,
			max(decode("REFFPF"."RFGUB",'100006', "REFFPF"."RFNA1" ))as text6,
			max(decode("REFFPF"."RFGUB",'100007', "REFFPF"."RFNA1" ))as text7,
			max(decode("REFFPF"."RFGUB",'100008', "REFFPF"."RFNA1" ))as text8,
			max(decode("REFFPF"."RFGUB",'100009', "REFFPF"."RFNA1" ))as text9,
			max(decode("REFFPF"."RFGUB",'100010', "REFFPF"."RFNA1" ))as text10,
			max(decode("REFFPF"."RFGUB",'200001', "REFFPF"."RFNA1" ))as text11,
			max(decode("REFFPF"."RFGUB",'200002', "REFFPF"."RFNA1" ))as text12,
			max(decode("REFFPF"."RFGUB",'200003', "REFFPF"."RFNA1" ))as text13,
			max(decode("REFFPF"."RFGUB",'200004', "REFFPF"."RFNA1" ))as text14,
			max(decode("REFFPF"."RFGUB",'200005', "REFFPF"."RFNA1" ))as text15,
			max(decode("REFFPF"."RFGUB",'200006', "REFFPF"."RFNA1" ))as text16,
			max(decode("REFFPF"."RFGUB",'200007', "REFFPF"."RFNA1" ))as text17,
			max(decode("REFFPF"."RFGUB",'200008', "REFFPF"."RFNA1" ))as text18,
			max(decode("REFFPF"."RFGUB",'200009', "REFFPF"."RFNA1" ))as text19,
			max(decode("REFFPF"."RFGUB",'200010', "REFFPF"."RFNA1" ))as text20 
	 INTO :txt1, :txt2 ,:txt3, :txt4, :txt5, :txt6, :txt7, :txt8, :txt9,:txt10,
	 		:txt11,:txt12,:txt13,:txt14,:txt15,:txt16,:txt17,:txt18,:txt19,:txt20
    FROM "REFFPF"  
   WHERE ( "REFFPF"."SABU" = '1' ) AND  
         ( "REFFPF"."RFCOD" = '35' )  AND
			( "REFFPF"."RFGUB" <> '00' )  ;


	dw_print.modify("text_1.text = '"+txt1+"'")
	dw_print.modify("text_2.text = '"+txt2+"'")
	dw_print.modify("text_3.text = '"+txt3+"'")
	dw_print.modify("text_4.text = '"+txt4+"'")
	dw_print.modify("text_5.text = '"+txt5+"'")
	dw_print.modify("text_6.text = '"+txt6+"'")
	dw_print.modify("text_7.text = '"+txt7+"'")
	dw_print.modify("text_8.text = '"+txt8+"'")
	dw_print.modify("text_9.text = '"+txt9+"'")
	dw_print.modify("text_10.text = '"+txt10+"'")
	
	dw_print.modify("text_a.text = '"+txt11+"'")
	dw_print.modify("text_b.text = '"+txt12+"'")
	dw_print.modify("text_c.text = '"+txt13+"'")
	dw_print.modify("text_d.text = '"+txt14+"'")
	dw_print.modify("text_e.text = '"+txt15+"'")
	dw_print.modify("text_f.text = '"+txt16+"'")
	dw_print.modify("text_g.text = '"+txt17+"'")
	dw_print.modify("text_h.text = '"+txt18+"'")
	dw_print.modify("text_i.text = '"+txt19+"'")
	dw_print.modify("text_j.text = '"+txt20+"'")

IF dw_print.Retrieve(gs_sabu,sFrom,sTo,scodefrom,scodeto) <=0 THEN
	f_message_chk(50,'')
   dw_ip.setcolumn('ntdat')
	dw_ip.SetFocus()
	Return -1
END IF
   
//dw_print.sharedata(dw_list)
Return 1

end function

public function integer wf_retrieve_02840 ();String  s_frTeam, s_toteam, s_yymm, sgub, s_frjo, s_tojo 
long    lcount

sgub   = dw_ip.GetItemString(1,"gub")
s_yymm = trim(dw_ip.GetItemString(1,"syymm"))

IF s_yymm = "" OR IsNull(s_yymm) THEN
	f_message_chk(30,'[기준년월]')
	dw_ip.SetColumn("syymm")
	dw_ip.SetFocus()
	Return -1
END IF

s_frTeam  = dw_ip.GetItemString(1,"fr_pdtgu")
s_toTeam  = dw_ip.GetItemString(1,"to_pdtgu")

IF s_frteam = "" OR IsNull(s_frteam) THEN s_frteam = '.'
IF s_toteam = "" OR IsNull(s_toteam) THEN s_toteam = 'zzzzzz'

dw_list.sharedata(dw_print)

IF sgub = '1' THEN
	s_frjo    = dw_ip.GetItemString(1,"fr_jocod")
	s_tojo    = dw_ip.GetItemString(1,"to_jocod")
	IF s_frjo = "" OR IsNull(s_frjo) THEN s_frjo = '.'
	IF s_tojo = "" OR IsNull(s_tojo) THEN s_tojo = 'zzzzzz'
	dw_list.DataObject = "d_pdt_02840_1"
	dw_print.DataObject = "d_pdt_02840_1_p"
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	lCount = dw_list.Retrieve(gs_sabu, s_yymm, s_frjo, s_tojo, s_frteam, s_toteam)
	lCount = dw_print.Retrieve(gs_sabu, s_yymm, s_frjo, s_tojo, s_frteam, s_toteam)
ELSEIF sgub = '2' THEN 
	dw_list.DataObject = "d_pdt_02840_2"   //생산팀별
	dw_print.DataObject = "d_pdt_02840_2_p" 
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	lCount = dw_list.Retrieve(gs_sabu, s_yymm, s_frteam, s_toteam)
	lCount = dw_print.Retrieve(gs_sabu, s_yymm, s_frteam, s_toteam)
ELSE
	dw_list.DataObject = "d_pdt_02840_3"   //전체
	dw_print.DataObject = "d_pdt_02840_3_p"
	dw_list.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)
	lCount = dw_list.Retrieve(gs_sabu, s_yymm, s_frteam, s_toteam)
	lCount = dw_print.Retrieve(gs_sabu, s_yymm, s_frteam, s_toteam)
END IF

IF lCount < 1 THEN
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
End if

Return 1
end function

public function integer wf_retrieve ();Integer i_rtn 

if dw_ip.AcceptText() = -1 then return -1

//dw_print.DataObject = "d_pdt_02730_1_p"
if rb_02730.Checked then
	i_rtn = wf_retrieve_02730()
elseif rb_02840.Checked then
	i_rtn = wf_retrieve_02840()
elseif rb_02845.Checked then
	i_rtn = wf_retrieve_02845()
elseif rb_02850.Checked then
	i_rtn = wf_retrieve_02850()
elseif rb_02855.Checked then
	i_rtn = wf_retrieve_02855()
else
	MessageBox("출력구분 확인", "출력구분을 확인 하세요!")
	i_rtn = -1
end if	

return i_rtn


end function

on w_pdt_02840.create
int iCurrent
call super::create
this.rb_02730=create rb_02730
this.rb_02840=create rb_02840
this.rb_02845=create rb_02845
this.rb_02850=create rb_02850
this.rb_02855=create rb_02855
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_02730
this.Control[iCurrent+2]=this.rb_02840
this.Control[iCurrent+3]=this.rb_02845
this.Control[iCurrent+4]=this.rb_02850
this.Control[iCurrent+5]=this.rb_02855
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.rr_1
end on

on w_pdt_02840.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_02730)
destroy(this.rb_02840)
destroy(this.rb_02845)
destroy(this.rb_02850)
destroy(this.rb_02855)
destroy(this.gb_1)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.Setfocus()


end event

type p_preview from w_standard_print`p_preview within w_pdt_02840
integer x = 4082
integer y = 32
end type

type p_exit from w_standard_print`p_exit within w_pdt_02840
integer x = 4430
integer y = 32
end type

type p_print from w_standard_print`p_print within w_pdt_02840
integer x = 4256
integer y = 32
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_02840
integer x = 3909
integer y = 32
end type











type dw_print from w_standard_print`dw_print within w_pdt_02840
string dataobject = "d_pdt_02730_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_02840
integer x = 69
integer y = 184
integer width = 3438
integer height = 208
string dataobject = "d_pdt_02730_0"
end type

event dw_ip::itemerror;
Return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "fr_jocod"	THEN		
	gs_code = this.GetText()
	open(w_jomas_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "fr_jocod", gs_code)
	this.SetItem(1, "fr_jonm", gs_codename)
ELSEIF this.getcolumnname() = "to_jocod"	THEN		
	gs_code = this.GetText()
	open(w_jomas_popup)
	if isnull(gs_code) or gs_code = "" then 	return
	this.SetItem(1, "to_jocod", gs_code)
	this.SetItem(1, "to_jonm", gs_codename)
END IF
end event

event dw_ip::itemchanged;string snull, syymm, sjocod, sjonm, sjonm2, sdate
String sDateFrom,sDateTo 
int    ireturn 

SetNull(snull)

IF this.GetColumnName() = "ntdat" THEN
	sDateFrom = Trim(this.GetText())
	IF sDateFrom ="" OR IsNull(sDateFrom) THEN RETURN
	
	IF f_datechk(sDateFrom) = -1 THEN
		f_message_chk(35,'[발생일자기간]')
		this.SetItem(1,"ntdat",snull)
		Return 1
	END IF
elseIF this.GetColumnName() = "ntdatto" THEN
	sDateTo = Trim(this.GetText())
	IF sDateTo ="" OR IsNull(sDateTo) THEN RETURN
	
	IF f_datechk(sDateTo) = -1 THEN
		f_message_chk(35,'[발생일자기간]')
		this.SetItem(1,"ntdatto",snull)
		Return 1
	END IF
elseIF this.GetColumnName() ="syymm" THEN
	syymm = trim(this.GetText())
	if syymm = "" or isnull(syymm) then	return 
  	IF f_datechk(syymm + '01') = -1	then
      f_message_chk(35, '[기준년월]')
		this.setitem(1, "syymm", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "fr_jocod"	THEN
	sjocod = trim(this.gettext())
   ireturn = f_get_name2('조', 'N', sjocod, sjonm, sjonm2)
	this.setitem(1, 'fr_jocod', sjocod)
	this.setitem(1, 'fr_jonm',  sjonm)
	return ireturn
ELSEIF this.GetColumnName() = "to_jocod"	THEN
	sjocod = trim(this.gettext())
   ireturn = f_get_name2('조', 'N', sjocod, sjonm, sjonm2)
	this.setitem(1, 'to_jocod', sjocod)
	this.setitem(1, 'to_jonm',  sjonm)
	return ireturn
ELSEIF this.GetColumnName() = "sdate"	THEN	
	sdate = trim(this.gettext())
	if sdate = "" or isnull(sdate) then	return 
  	IF f_datechk(sdate + '0101') = -1	then
      f_message_chk(35, '[기준년도]')
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
END IF 

return
end event

type dw_list from w_standard_print`dw_list within w_pdt_02840
integer x = 82
integer y = 412
integer width = 4512
integer height = 1860
string dataobject = "d_pdt_02730_1"
boolean border = false
boolean hsplitscroll = false
end type

type rb_02730 from radiobutton within w_pdt_02840
integer x = 114
integer y = 80
integer width = 695
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "기간별 비가동 내역LIST"
boolean checked = true
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02730_0"
dw_list.DataObject = "d_pdt_02730_1"
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

//cb_ruler.Enabled = false
p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
//ddlb_zoom.text = '100'
//cb_ruler.text = '여백ON'

end event

type rb_02840 from radiobutton within w_pdt_02840
integer x = 882
integer y = 80
integer width = 549
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "공수 집계현황"
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02840_a"
dw_list.DataObject = "d_pdt_02840_1"
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type rb_02845 from radiobutton within w_pdt_02840
integer x = 1454
integer y = 80
integer width = 695
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "공수 집계현황 - 비가동"
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02845_a"
dw_list.DataObject = "d_pdt_02845_1"
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type rb_02850 from radiobutton within w_pdt_02840
integer x = 2231
integer y = 80
integer width = 695
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "년간 생산팀별 공수현황"
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02850_a"
dw_list.DataObject = "d_pdt_02850_1"
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type rb_02855 from radiobutton within w_pdt_02840
integer x = 3008
integer y = 80
integer width = 695
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "년간 생산팀별 효율분석"
end type

event clicked;dw_ip.Setredraw(False)
dw_list.Setredraw(False)
dw_ip.DataObject = "d_pdt_02850_a"
dw_list.DataObject = "d_pdt_02855_1"
dw_ip.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)
dw_ip.InsertRow(0)
dw_ip.Setredraw(True)
dw_list.Setredraw(True)
dw_ip.SetFocus()

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type gb_1 from groupbox within w_pdt_02840
integer x = 73
integer y = 28
integer width = 3698
integer height = 144
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "출력구분"
end type

type rr_1 from roundrectangle within w_pdt_02840
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 404
integer width = 4535
integer height = 1904
integer cornerheight = 40
integer cornerwidth = 55
end type

