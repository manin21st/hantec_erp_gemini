$PBExportHeader$w_pdm_01415.srw
$PBExportComments$** 일별 조 인원조정
forward
global type w_pdm_01415 from w_inherite
end type
type gb_5 from groupbox within w_pdm_01415
end type
type gb_4 from groupbox within w_pdm_01415
end type
type dw_1 from datawindow within w_pdm_01415
end type
type dw_2 from datawindow within w_pdm_01415
end type
type pb_1 from u_pb_cal within w_pdm_01415
end type
type pb_2 from u_pb_cal within w_pdm_01415
end type
type rr_1 from roundrectangle within w_pdm_01415
end type
type rr_2 from roundrectangle within w_pdm_01415
end type
end forward

global type w_pdm_01415 from w_inherite
integer height = 3620
string title = "일별 조 인원 조정"
gb_5 gb_5
gb_4 gb_4
dw_1 dw_1
dw_2 dw_2
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_pdm_01415 w_pdm_01415

type variables

end variables

forward prototypes
public function integer wf_required_chk ()
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
Long i

for i = 1 to dw_insert.RowCount()
	if Isnull(dw_insert.object.jocode[i]) or dw_insert.object.jocode[i] =  "" then
	   f_message_chk(1400,'[조코드]')
		dw_insert.ScrollToRow(i)
	   dw_insert.SetColumn('jocode')
	   dw_insert.SetFocus()
	   return -1
   end if	
next

return 1
end function

on w_pdm_01415.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_4=create gb_4
this.dw_1=create dw_1
this.dw_2=create dw_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.rr_1
this.Control[iCurrent+8]=this.rr_2
end on

on w_pdm_01415.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_insert.settransobject(sqlca)

dw_1.InsertRow(0)
dw_1.setitem(1, 'fdate', left(is_today, 6) + '01')
dw_1.setitem(1, 'tdate', is_today)
dw_1.setfocus()

dw_2.InsertRow(0)


end event

type dw_insert from w_inherite`dw_insert within w_pdm_01415
integer x = 187
integer y = 316
integer width = 4379
integer height = 1964
integer taborder = 30
string dataobject = "d_pdm_01415"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

IF	this.getcolumnname() = "jocode"	THEN		
	open(w_jomas_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return
	this.SetItem(this.getrow(), "jocode", gs_code)
	this.triggerevent(itemchanged!)
END IF
end event

event dw_insert::itemchanged;string s_cod, s_nam1, s_nam2, get_nm
integer i_rtn

s_cod = Trim(this.GetText())

if this.getcolumnname() = 'jocode' then   
	i_rtn = f_get_name2("조", "Y", s_cod, s_nam1, s_nam2)
	this.setitem(this.getrow(),"jocode", s_cod)
	this.setitem(this.getrow(),"jonam", s_nam1)
	if s_cod = '' or isnull(s_cod) then
		this.setitem(this.getrow(),"pdtgu", s_cod)
	else
	   SELECT "JOMAST"."PDTGU"  
        INTO :get_nm
		  FROM "JOMAST"  
		 WHERE "JOMAST"."JOCOD" = :s_cod   ;
   
		this.setitem(this.getrow(),"pdtgu", get_nm)
	end if	
	
	return i_rtn
end if

end event

type p_delrow from w_inherite`p_delrow within w_pdm_01415
boolean visible = false
integer x = 3474
integer y = 2796
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01415
boolean visible = false
integer x = 3301
integer y = 2796
end type

type p_search from w_inherite`p_search within w_pdm_01415
integer x = 3621
integer width = 306
string picturename = "C:\erpman\image\생산근태일괄조정_up.gif"
end type

event p_search::clicked;call super::clicked;open(w_pdm_01415_popup) 

if gs_code = 'Y' then 
	dw_insert.Reset()
	ib_any_typing = false
END IF
end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\생산근태일괄조정_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\생산근태일괄조정_up.gif"
end event

type p_ins from w_inherite`p_ins within w_pdm_01415
boolean visible = false
integer x = 3127
integer y = 2796
end type

type p_exit from w_inherite`p_exit within w_pdm_01415
end type

type p_can from w_inherite`p_can within w_pdm_01415
end type

event p_can::clicked;call super::clicked;dw_insert.Reset()
ib_any_typing = false
end event

type p_print from w_inherite`p_print within w_pdm_01415
integer x = 2725
integer y = 88
integer width = 306
string picturename = "C:\erpman\image\조일괄조정_up.gif"
end type

event p_print::clicked;call super::clicked;long   lcount, k
string scode, sname, spdtgu

if dw_2.AcceptText() = -1 then return 

lcount = dw_insert.rowcount()
if lcount < 1 then return 

scode = dw_2.getitemstring(1, 'jocode')
sname = dw_2.getitemstring(1, 'jonam')

if scode = '' or isnull(scode) then
	messagebox('확 인', '조코드를 입력하세요!')
	dw_2.setfocus()
	return 1
else
	SELECT "JOMAST"."PDTGU"  
	  INTO :spdtgu
	  FROM "JOMAST"  
	 WHERE "JOMAST"."JOCOD" = :scode   ;

end if	

FOR k = 1 TO lcount
    dw_insert.setitem(k, 'jocode', scode) 					
    dw_insert.setitem(k, 'jonam', sname) 					
    dw_insert.setitem(k, 'pdtgu', spdtgu) 					
NEXT

end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\조일괄조정_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\조일괄조정_up.gif"
end event

type p_inq from w_inherite`p_inq within w_pdm_01415
integer x = 3922
end type

event p_inq::clicked;string sfdate, stdate, sfempno, stempno, sdptno, sJo

If 	dw_1.AcceptText() <> 1 Then Return

sfdate  	= Trim(dw_1.GetItemString(1,'fdate'))
stdate  	= Trim(dw_1.GetItemString(1,'tdate'))
sfempno 	= dw_1.GetItemString(1,'fempno')
stempno 	= dw_1.GetItemString(1,'tempno')
sdptno  	= dw_1.GetItemString(1,'dptno')
sjo  		= dw_2.GetItemString(1,'jocode')

if 	sfdate = '' or isnull(sfdate) 		then sfdate = '10000101'
if 	stdate = '' or isnull(stdate) 		then stdate = '99991231'
if 	sfempno = '' or isnull(sfempno) then sfempno = '.'
if 	stempno = '' or isnull(stempno) then stempno = 'ZZZZZZ'
if 	sdptno = '' or isnull(sdptno) 	then sdptno = '%'
if 	sJo = '' or isnull(sJo) 			then sJo = '%'

if 	dw_insert.retrieve(sfdate, stdate, sfempno, stempno, sdptno, sJo) <= 0 then
	f_message_chk(50,'')
	p_print.enabled = false
	p_print.PictureName = 'C:\erpman\image\조일괄조정_d.gif'
	dw_1.Setfocus()
else
	p_print.enabled = true
	p_print.PictureName = 'C:\erpman\image\조일괄조정_up.gif'
	dw_insert.Setfocus()
end if

ib_any_typing = false

end event

type p_del from w_inherite`p_del within w_pdm_01415
boolean visible = false
integer x = 3822
integer y = 2796
end type

type p_mod from w_inherite`p_mod within w_pdm_01415
integer x = 4096
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if wf_required_chk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return  //저장 Yes/No ?

if dw_insert.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"	
	ib_any_typing = False //입력필드 변경여부 No
else
	ROLLBACK;
	f_message_chk(32,'[자료저장 실패]') 
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if
 
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01415
boolean visible = false
integer x = 3287
integer y = 3104
integer taborder = 100
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01415
boolean visible = false
integer x = 2592
integer y = 3104
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;//if dw_insert.AcceptText() = -1 then return 
//
//if wf_required_chk() = -1 then return //필수입력항목 체크 
//
//if f_msg_update() = -1 then return  //저장 Yes/No ?
//
//if dw_insert.Update() = 1 then
//	COMMIT;
//	sle_msg.text = "저장 되었습니다!"	
//	ib_any_typing = False //입력필드 변경여부 No
//else
//	ROLLBACK;
//	f_message_chk(32,'[자료저장 실패]') 
//   sle_msg.text = "저장작업 실패 하였습니다!"
//	return 
//end if
// 
end event

type cb_ins from w_inherite`cb_ins within w_pdm_01415
boolean visible = false
integer x = 174
integer y = 2632
end type

type cb_del from w_inherite`cb_del within w_pdm_01415
boolean visible = false
integer x = 1211
integer y = 2616
integer taborder = 50
boolean enabled = false
end type

event cb_del::clicked;call super::clicked;//String sSalegu, sIttyp, sItcls, sDate
//Long   nRow
//
//sSalegu = Trim(dw_insert.GetItemString(1,'salegu'))
//sIttyp  = Trim(dw_insert.GetItemString(1,'ittyp'))
//sDate   = Trim(dw_insert.GetItemString(1,'start_date'))
//
///* 삭제 */
//If dw_1.tag = 'this' Then
//	wf_delete(dw_1)
//	
//	dw_1.retrieve(sSalegu, sIttyp, sDate) // 대분류 조회
//Else
//	nRow = dw_2.GetRow()
//	If nRow <= 0 Then Return
//	
//	sItcls  = Trim(dw_2.GetItemString(nRow,'itcls'))
//	
//	wf_delete(dw_2)
//	
//	dw_1.retrieve(sSalegu, sIttyp, sDate ) // 대분류 조회
//	dw_2.retrieve(sSalegu, sIttyp, Left(sItcls,2)+'%', sDate)     // 중분류 조회
//End If
//dw_1.ScrollToRow(nRow)
//
//ib_any_typing = false
end event

type cb_inq from w_inherite`cb_inq within w_pdm_01415
boolean visible = false
integer x = 169
integer y = 3104
integer taborder = 20
end type

event clicked;call super::clicked;//string sfdate, stdate, sfempno, stempno, sdptno
//
//If dw_1.AcceptText() <> 1 Then Return
//
//sfdate  = Trim(dw_1.GetItemString(1,'fdate'))
//stdate  = Trim(dw_1.GetItemString(1,'tdate'))
//sfempno = dw_1.GetItemString(1,'fempno')
//stempno = dw_1.GetItemString(1,'tempno')
//sdptno  = dw_1.GetItemString(1,'dptno')
//
//if sfdate = '' or isnull(sfdate) then sfdate = '10000101'
//if stdate = '' or isnull(stdate) then stdate = '99991231'
//if sfempno = '' or isnull(sfempno) then sfempno = '.'
//if stempno = '' or isnull(stempno) then stempno = 'ZZZZZZ'
//if sdptno = '' or isnull(sdptno) then sdptno = '%'
//
//if dw_insert.retrieve(sfdate, stdate, sfempno, stempno, sdptno) <= 0 then
//	f_message_chk(50,'')
//	cb_print.enabled = false
//	dw_1.Setfocus()
//else
//	cb_print.enabled = true
//	dw_insert.Setfocus()
//end if
//
//ib_any_typing = false
//
end event

type cb_print from w_inherite`cb_print within w_pdm_01415
integer x = 1938
integer y = 2820
integer width = 640
integer height = 76
integer taborder = 80
integer textsize = -9
boolean enabled = false
string text = "조 코드일괄지정(&Q)"
end type

event cb_print::clicked;call super::clicked;long   lcount, k
string scode, sname, spdtgu

if dw_2.AcceptText() = -1 then return 

lcount = dw_insert.rowcount()
if lcount < 1 then return 

scode = dw_2.getitemstring(1, 'jocode')
sname = dw_2.getitemstring(1, 'jonam')

if scode = '' or isnull(scode) then
	messagebox('확 인', '조코드를 입력하세요!')
	dw_2.setfocus()
	return 1
else
	SELECT "JOMAST"."PDTGU"  
	  INTO :spdtgu
	  FROM "JOMAST"  
	 WHERE "JOMAST"."JOCOD" = :scode   ;

end if	

FOR k = 1 TO lcount
    dw_insert.setitem(k, 'jocode', scode) 					
    dw_insert.setitem(k, 'jonam', sname) 					
    dw_insert.setitem(k, 'pdtgu', spdtgu) 					
NEXT

end event

type st_1 from w_inherite`st_1 within w_pdm_01415
long backcolor = 80859087
end type

type cb_can from w_inherite`cb_can within w_pdm_01415
boolean visible = false
integer x = 2939
integer y = 3104
end type

event cb_can::clicked;call super::clicked;//dw_insert.Reset()
//ib_any_typing = false
end event

type cb_search from w_inherite`cb_search within w_pdm_01415
integer x = 1445
integer y = 2776
integer width = 626
integer taborder = 90
integer textsize = -9
string text = "생산근태 일괄조정(&E)"
end type

event cb_search::clicked;call super::clicked;open(w_pdm_01415_popup) 

if gs_code = 'Y' then 
	dw_insert.Reset()
	ib_any_typing = false
END IF
end event



type sle_msg from w_inherite`sle_msg within w_pdm_01415
long backcolor = 80859087
end type

type gb_10 from w_inherite`gb_10 within w_pdm_01415
integer y = 2972
integer height = 136
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 80859087
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01415
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01415
end type

type gb_5 from groupbox within w_pdm_01415
boolean visible = false
integer x = 128
integer y = 3056
integer width = 416
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_4 from groupbox within w_pdm_01415
boolean visible = false
integer x = 2551
integer y = 3056
integer width = 1106
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_1 from datawindow within w_pdm_01415
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
string tag = "dw_2"
integer x = 169
integer y = 48
integer width = 2505
integer height = 236
integer taborder = 10
string dataobject = "d_pdm_01415_a"
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

event itemerror;return 1
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

choose case 	this.GetColumnName()
	Case 	"dptno" 
		Open(w_vndmst_4_popup)
	
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
	
		this.SetItem(this.getrow(), "dptno", gs_Code)
		this.SetItem(this.getrow(), "dptnm", gs_Codename)
	Case 	"fempno"			
		open(w_sawon_popup)
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
		this.SetItem(1, "fempno", gs_code)
		this.SetItem(1, "fempnm", gs_codename)
	Case 	"tempno"			
		open(w_sawon_popup)
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
		this.SetItem(1, "tempno", gs_code)
		this.SetItem(1, "tempnm", gs_codename)
	Case 	"Mjocod"
		open(w_jomas_popup)
		IF isnull(gs_Code)  or  gs_Code = ''	then  return
		this.SetItem(1, "Mjocod", gs_code)
		this.SetItem(1, "Mjonam", gs_codename)
end choose


end event

event itemchanged;String s_dptno, s_name, s_name2, s_date, snull
int    ireturn

setnull(snull)
choose case 	this.GetColumnName()
	Case 	"dptno" 
		s_dptno = this.gettext()
	 
			ireturn = f_get_name2('부서', 'Y', s_dptno, s_name, s_name2)
		this.SetItem(Row, "dptno", s_dptno)
		this.SetItem(Row, "dptnm", s_name)
		return ireturn 
	Case 	"fempno" 
		s_dptno = this.gettext()
	 
			ireturn = f_get_name2('사번', 'N', s_dptno, s_name, s_name2)
		this.SetItem(Row, "fempno", s_dptno)
		this.SetItem(Row, "fempnm", s_name)
		this.SetItem(Row, "tempno", s_dptno)
		this.SetItem(Row, "tempnm", s_name)
		return ireturn 
	Case 	"tempno" 
		s_dptno = this.gettext()
	 
			ireturn = f_get_name2('사번', 'N', s_dptno, s_name, s_name2)
		this.SetItem(Row, "tempno", s_dptno)
		this.SetItem(Row, "tempnm", s_name)
		return ireturn 
	Case	"fdate" 
		s_date = trim(this.GetText())
		
		if s_date = "" or isnull(s_date) then return 
	
		IF f_datechk(s_date) = -1	then
			f_message_chk(35, '[근태일자]')
			this.setitem(1, "fdate", snull)
			return 1
		END IF
	Case	"tdate" 
		s_date = trim(this.GetText())
		
		if s_date = "" or isnull(s_date) then return 
	
		IF f_datechk(s_date) = -1	then
			f_message_chk(35, '[근태일자]')
			this.setitem(1, "tdate", snull)
			return 1
		END IF
end choose

end event

type dw_2 from datawindow within w_pdm_01415
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 3035
integer y = 68
integer width = 530
integer height = 164
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_pdm_01415_b"
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

event itemchanged;string s_cod, s_nam1, s_nam2, get_nm
integer i_rtn

s_cod = Trim(this.GetText())

if this.getcolumnname() = 'jocode' then   
	i_rtn = f_get_name2("조", "Y", s_cod, s_nam1, s_nam2)
	this.setitem(1,"jocode", s_cod)
	this.setitem(1,"jonam", s_nam1)
	return i_rtn
end if

end event

event itemerror;return 1
end event

event rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

IF	this.getcolumnname() = "jocode"	THEN		
	open(w_jomas_popup)
	IF isnull(gs_Code)  or  gs_Code = ''	then  return
	this.SetItem(this.getrow(), "jocode", gs_code)
	this.SetItem(this.getrow(), "jonam", gs_codename)
END IF
end event

type pb_1 from u_pb_cal within w_pdm_01415
integer x = 864
integer y = 76
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('fdate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'fdate', gs_code)

end event

type pb_2 from u_pb_cal within w_pdm_01415
integer x = 1285
integer y = 76
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.SetColumn('tdate')
IF Isnull(gs_code) THEN Return
dw_1.SetItem(dw_1.getrow(), 'tdate', gs_code)

end event

type rr_1 from roundrectangle within w_pdm_01415
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2697
integer y = 48
integer width = 901
integer height = 232
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_01415
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 174
integer y = 308
integer width = 4430
integer height = 1992
integer cornerheight = 40
integer cornerwidth = 55
end type

