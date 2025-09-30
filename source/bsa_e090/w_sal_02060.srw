$PBExportHeader$w_sal_02060.srw
$PBExportComments$ ** 특정제품 할인율 등록(ITDC)=========> 미사용
forward
global type w_sal_02060 from w_inherite
end type
type gb_5 from groupbox within w_sal_02060
end type
type gb_4 from groupbox within w_sal_02060
end type
type gb_1 from groupbox within w_sal_02060
end type
type rb_1 from radiobutton within w_sal_02060
end type
type rb_2 from radiobutton within w_sal_02060
end type
type dw_list from u_key_enter within w_sal_02060
end type
type dw_1 from datawindow within w_sal_02060
end type
type gb_3 from groupbox within w_sal_02060
end type
end forward

global type w_sal_02060 from w_inherite
integer width = 3657
string title = "특정제품 할인율 등록"
long backcolor = 80859087
gb_5 gb_5
gb_4 gb_4
gb_1 gb_1
rb_1 rb_1
rb_2 rb_2
dw_list dw_list
dw_1 dw_1
gb_3 gb_3
end type
global w_sal_02060 w_sal_02060

type variables
str_itnct lstr_sitnct
end variables

forward prototypes
public subroutine wf_radio (radiobutton radio)
public function integer wf_key_protect (boolean gb)
end prototypes

public subroutine wf_radio (radiobutton radio);if radio.Classname() = "rb_1" then
   dw_list.DataObject = "d_sal_02060_04"
elseif radio.Classname() = "rb_2" then	
	dw_list.DataObject = "d_sal_02060_03"
end if

dw_list.SetTransObject(SQLCA)

end subroutine

public function integer wf_key_protect (boolean gb);Choose Case gb
	Case True
		dw_insert.Modify('salegu.protect = 1')
		dw_insert.Modify('itnbr.protect = 1')
		dw_insert.Modify('itdsc.protect = 1')
		dw_insert.Modify('ispec.protect = 1')
		dw_insert.Modify('start_date.protect = 1')
      dw_insert.Modify("salegu.background.color = 80859087") 
      dw_insert.Modify("itnbr.background.color = 80859087")  
      dw_insert.Modify("itdsc.background.color = 80859087")
      dw_insert.Modify("ispec.background.color = 80859087")
      dw_insert.Modify("start_date.background.color = 80859087")
	Case False
		dw_insert.Modify('salegu.protect = 0')
		dw_insert.Modify('itnbr.protect = 0')
		dw_insert.Modify('itdsc.protect = 0')
		dw_insert.Modify('ispec.protect = 0')
		dw_insert.Modify('start_date.protect = 0')
      dw_insert.Modify("salegu.background.color = '"+ String(Rgb(190,225,184))+"'")  //mint
      dw_insert.Modify("itnbr.background.color = 65535")  //yellow
      dw_insert.Modify("itdsc.background.color = '" + String(Rgb(255,255,255))+"'") //white
      dw_insert.Modify("ispec.background.color = '" + String(Rgb(255,255,255))+"'") //white
      dw_insert.Modify("start_date.background.color = '"+String(Rgb(190,225,184))+"'")
End Choose

return 1
end function

on w_sal_02060.create
int iCurrent
call super::create
this.gb_5=create gb_5
this.gb_4=create gb_4
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_list=create dw_list
this.dw_1=create dw_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_5
this.Control[iCurrent+2]=this.gb_4
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.dw_list
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.gb_3
end on

on w_sal_02060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_5)
destroy(this.gb_4)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_list)
destroy(this.dw_1)
destroy(this.gb_3)
end on

event open;call super::open;dw_insert.settransobject(sqlca)
dw_1.settransobject(sqlca)
dw_list.settransobject(sqlca)
dw_1.InsertRow(0)
cb_can.TriggerEvent(clicked!)


end event

type dw_insert from w_inherite`dw_insert within w_sal_02060
integer x = 87
integer y = 88
integer width = 3259
integer height = 292
integer taborder = 10
string dataobject = "d_sal_02060_01"
end type

event dw_insert::rbuttondown;setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)

////품번//////////////////////////////////////////////////////////////////
if this.GetColumnName() = 'itnbr' then
	gs_code = this.GetText()
	
	open(w_itemas_popup)
   
	if gs_code = "" or isnull(gs_code) then return 
		
	this.setitem(1, 'itnbr', gs_code)
	this.setitem(1, 'itdsc', gs_codename)
	this.setitem(1, 'ispec', gs_gubun)
   	
   this.setcolumn("end_date")
	this.setfocus()	
   return 1
	
////품명///////////////////////////////////////////////////////////////////	
elseif this.GetColumnName() = 'itdsc' then	
	gs_codename = this.GetText()
	
	open(w_itemas_popup)
   
	if gs_code = "" or isnull(gs_code) then return 
		
	this.setitem(1, 'itnbr', gs_code)
	this.setitem(1, 'itdsc', gs_codename)
	this.setitem(1, 'ispec', gs_gubun)
	return 1
end if
/////////////////////////////////////////////////////////////////////// 
ib_any_typing = false
end event

event dw_insert::ue_key;call super::ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"itnbr",gs_code)
//		cb_inq.TriggerEvent(Clicked!)
		RETURN 1
	End if	
END IF		
end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;String sget_name, snull, sitem, sname, sname2, sgub
long   lcount, l_data, inull

SetNull(snull)
setnull(inull)
SetNull(gs_code)
SetNull(gs_codename)

////품번일 경우/////////////////////////////////////////////////////////////
IF this.GetColumnName() = "itnbr"	THEN
	sItem = trim(this.GetText())
	IF sItem = '' or	IsNull(sItem)	THEN
		this.setitem(1, "itdsc", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN 
	END IF
	
	SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC", "ITEMAS"."GBWAN"       
	  INTO :sName, :sName2, :sGub  
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ITNBR" = :sItem ;
	
	IF sqlca.sqlcode <> 0		THEN
		f_message_chk(33, "[품번]" )
		this.setitem(1, "itnbr", snull)	
		this.setitem(1, "itdsc", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN 1
	ELSE
		IF sgub <> 'Y' then
			messagebox("확인", "개발중인 품목입니다." )
			this.setitem(1, "itnbr", snull)	
			this.setitem(1, "itdsc", snull)	
			this.setitem(1, "ispec", snull)	
			RETURN 1
		END IF
		
		this.setitem(1, "itdsc", sname)	
		this.setitem(1, "ispec", sname2)	
	END IF	
	
////품명일 경우////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "itdsc"	THEN
	sName = trim(this.GetText())
	IF sName = ''	or	IsNull(sName)	THEN
		this.setitem(1, "itnbr", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN 
	END IF

	SELECT COUNT(*), MAX("ITEMAS"."ITNBR"), MAX("ITEMAS"."ISPEC")
	  INTO :lCount,  :sitem, :sName2
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ITDSC" = :sName AND "ITEMAS"."GBWAN" = 'Y' ;

   if isnull(lcount) then lcount = 0 

	IF lcount = 0	THEN
		this.setitem(1, "itnbr", snull)	
		this.setitem(1, "itdsc", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN  1
	ELSEIF lcount = 1 THEN	
		this.setitem(1, "itnbr", sitem)	
		this.setitem(1, "ispec", sname2)	
	ELSE
		gs_codename = '품명'
		gs_code = sName
		open(w_itemas_popup5)
		if isnull(gs_code) or gs_code = "" then 
			this.setitem(1, "itnbr", snull)	
			this.setitem(1, "itdsc", snull)	
			this.setitem(1, "ispec", snull)	
			return 1
		end if
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "ispec", gs_gubun)
	END IF	
	
////규격일 경우/////////////////////////////////////////////////////////////////
ELSEIF this.GetColumnName() = "ispec"	THEN
	sName = trim(this.GetText())
	
	IF sName = ''	or	IsNull(sName)	THEN
		this.setitem(1, "itnbr", snull)	
		this.setitem(1, "itdsc", snull)	
		RETURN 
	END IF

	SELECT COUNT(*), MAX("ITEMAS"."ITNBR"), MAX("ITEMAS"."ITDSC")
	  INTO :lCount,  :sitem, :sName2
	  FROM "ITEMAS"  
	 WHERE "ITEMAS"."ISPEC" = :sName AND "ITEMAS"."GBWAN" = 'Y' ;

   if isnull(lcount) then lcount = 0 

	IF lcount = 0	THEN
		this.setitem(1, "itnbr", snull)	
		this.setitem(1, "itdsc", snull)	
		this.setitem(1, "ispec", snull)	
		RETURN  1
	ELSEIF lcount = 1 THEN	
		this.setitem(1, "itnbr", sitem)	
		this.setitem(1, "itdsc", sname2)	
	ELSE
		gs_codename = '규격'
		gs_code = sName
		open(w_itemas_popup5)
		if isnull(gs_code) or gs_code = "" then 
			this.setitem(1, "itnbr", snull)	
			this.setitem(1, "itdsc", snull)	
			this.setitem(1, "ispec", snull)	
			return 1
		end if
		
		this.SetItem(1, "itnbr", gs_code)
		this.SetItem(1, "itdsc", gs_codename)
	END IF	
END IF

////적용(시작/마감)일 유효성 체크////////////////////////////////////////////////////
IF	this.getcolumnname() = "start_date" THEN
	IF f_datechk(trim(this.gettext())) = -1 then
      f_message_chk(35,'[적용시작일]')
		this.setitem(1, "start_date", sNull)
		return 1
	END IF

ELSEIF this.getcolumnname() = "end_date" THEN
	IF f_datechk(trim(this.gettext())) = -1 then
		f_message_chk(35,'[적용마감일]')
		this.setitem(1, "end_date", sNull)
		return 1
	END IF
end if

////할인율값 유효성 체크//////////////////////////////////////////////////////////////
if this.getcolumnname() = "dc_rate" then
 	l_data = long(this.gettext())
	if l_data > 100 then
		messagebox("확 인","할인율은 100%를 초과할 수 없습니다!!")
		this.setitem(1, "dc_rate", inull)
		this.setcolumn("dc_rate")
		this.setfocus()
		return 1
	end if
end if
/////////////////////////////////////////////////////////////////////////////////////
ib_any_typing = false
end event

type cb_exit from w_inherite`cb_exit within w_sal_02060
integer x = 3141
integer y = 1924
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_sal_02060
integer x = 2002
integer y = 1924
integer taborder = 40
end type

event cb_mod::clicked;call super::clicked;string s_salegu,s_itnbr, s_itdsc, s_ispec, s_gub
string s_frdate, s_todate, snull
int    l_row, ll_row, inull
dec    d_rate  

setnull(snull)
setnull(inull)

IF dw_insert.Accepttext() = -1 THEN 	
	dw_insert.setfocus()
	RETURN
END IF

IF dw_1.Accepttext() = -1 THEN 	return

s_salegu  = dw_insert.GetItemString(1, "salegu")     //영업구분
s_itnbr  = dw_insert.GetItemString(1, "itnbr")       //품번
s_itdsc  = dw_insert.GetItemString(1, "itdsc")       //품명
s_ispec  = dw_insert.GetItemString(1, "ispec")       //규격
s_frdate = dw_insert.GetItemString(1, "start_date")     
s_todate = dw_insert.GetItemString(1, "end_date")     
d_rate   = dw_insert.GetItemNumber(1, "dc_rate")     //할인율 

////필수입력 항목 체크/////////////////////////////////////////////////////////////////////////
IF IsNull(s_salegu) or trim(s_salegu) = '' THEN
	f_message_chk(30,'[영업구분]')
	dw_insert.SetColumn("salegu")
	dw_insert.SetFocus()
	RETURN 
END IF

IF IsNull(s_itnbr) or trim(s_itnbr) = '' THEN
	f_message_chk(30,'[품번]')
	dw_insert.SetColumn("itnbr")
	dw_insert.SetFocus()
	RETURN 
END IF

IF IsNull(s_frdate) or trim(s_frdate) = '' THEN
	f_message_chk(30,'[적용시작일]')
	dw_insert.SetColumn("start_date")
	dw_insert.SetFocus()
	RETURN 
END IF

IF IsNull(d_rate) THEN
	f_message_chk(30,'[할인율]')
	dw_insert.SetColumn("dc_rate")
	dw_insert.SetFocus()
	RETURN 
END IF

////날짜 from ~ to 유효성 확인//////////////////////////////////////////////////////////////////
if s_frdate > s_todate then
	f_message_chk(35,'[적용마감일]')
	dw_insert.setcolumn("end_date")
	dw_insert.setfocus()
	return 
end if

If dw_insert.GetItemStatus(1,0,primary!) = NewModified! Then           // 신규입력일 경우
   SELECT nvl(count(itnbr) ,0)   INTO :l_row
     FROM ITDC
    WHERE ( SALEGU     = :s_salegu ) AND
          ( ITNBR      = :s_itnbr) AND                  
          ( START_DATE = :s_frdate) ;

   if l_row >= 1 then
	   f_message_chk(1,'[적용일자]')
	   dw_insert.setcolumn("start_date")
	   dw_insert.setfocus()
	   return
   end if
End If	
//------------------------------------------------------------//
if dw_insert.update() > 0 then
	commit using sqlca;
else
	rollback using sqlca ;
	return
end if

sle_msg.text = "저장하였습니다!!"
ib_any_typing = false

cb_inq.TriggerEvent(Clicked!)    // 조회
wf_key_protect(true)
end event

type cb_ins from w_inherite`cb_ins within w_sal_02060
boolean visible = false
integer x = 50
integer y = 2356
integer taborder = 0
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_sal_02060
integer x = 2363
integer y = 1924
integer width = 361
integer taborder = 50
end type

event cb_del::clicked;call super::clicked;long l_row

dw_insert.accepttext()
l_row = dw_list.getrow()

IF l_row <=0 THEN
	messagebox("확 인","삭제할 행이 없습니다. ~n~n삭제할 행을 선택하고 [삭제]하세요!!")
	Return
END IF

/////////////////////////////////////////////////////////////////////////////////////////////
if messagebox("삭 제","삭제하시겠습니까?", question!, yesno!, 2) = 2 then
	return
else
	dw_list.deleterow(l_row)
	
	if dw_list.update() > 0 then
		commit ;
		sle_msg.text = "자료가 삭제되었습니다!!"
		ib_any_typing = false
	else 
		rollback;
	end if		
end if

cb_can.TriggerEvent(Clicked!)

end event

type cb_inq from w_inherite`cb_inq within w_sal_02060
integer x = 87
integer y = 1924
integer taborder = 30
end type

event cb_inq::clicked;call super::clicked;string s_salegu,s_ittyp, s_itcls
int nRow

if dw_1.accepttext() <> 1 then return 

nRow = dw_insert.GetRow()
If nRow <=0 Then Return

s_salegu = dw_insert.getitemstring(nRow, "salegu")
s_ittyp = dw_1.getitemstring(1, "ittyp")
s_itcls = dw_1.getitemstring(1, "itcls")

////제품분류를 입력하지 않고 [조회]를 click한 경우///////////////////////////////
if s_salegu = "" or isnull(s_salegu) then 
	f_message_chk(30,'[영업구분구분]')
	dw_insert.setcolumn("salegu")
	dw_insert.setfocus()
   return 
end if
if s_ittyp = "" or isnull(s_ittyp) then 
	f_message_chk(30,'[품목구분]')
	dw_1.setcolumn("ittyp")
	dw_1.setfocus()
   return 
end if

If IsNull(s_itcls) Then s_itcls = ''

dw_1.setredraw(false)

if dw_list.retrieve(s_salegu,s_ittyp, s_itcls+'%') <= 0 then  	f_message_chk(50,'')

dw_1.setredraw(true)	
dw_1.setcolumn("itcls")
dw_1.setfocus()
	
ib_any_typing = false

end event

type cb_print from w_inherite`cb_print within w_sal_02060
boolean visible = false
integer x = 384
integer y = 2356
integer taborder = 0
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_sal_02060
long backcolor = 80859087
end type

type cb_can from w_inherite`cb_can within w_sal_02060
integer x = 2752
integer y = 1924
integer width = 361
end type

event cb_can::clicked;call super::clicked;string salegu,sittyp
int nRow

nRow = dw_insert.GetRow()
If nRow > 0 Then 
   salegu = Trim(dw_insert.GetItemString(nRow,'salegu'))
Else
	salegu = '1'
End If

dw_insert.SetRedraw(False)
dw_insert.Reset()
nRow = dw_insert.InsertRow(0)
dw_insert.SetItem(nRow, "salegu", salegu)
dw_insert.SetItem(nRow, "start_date", f_today())
dw_insert.SetRow(nRow)
wf_key_protect(false)
dw_insert.SetRedraw(True)

dw_insert.SetFocus()
dw_insert.SetColumn('itnbr')
end event

type cb_search from w_inherite`cb_search within w_sal_02060
boolean visible = false
integer x = 718
integer y = 2356
integer taborder = 0
boolean enabled = false
end type



type sle_msg from w_inherite`sle_msg within w_sal_02060
long backcolor = 80859087
end type

type gb_10 from w_inherite`gb_10 within w_sal_02060
fontcharset fontcharset = ansi!
long backcolor = 80859087
end type

type gb_5 from groupbox within w_sal_02060
integer x = 1957
integer y = 1868
integer width = 1563
integer height = 200
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

type gb_4 from groupbox within w_sal_02060
integer x = 41
integer y = 1868
integer width = 434
integer height = 200
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

type gb_1 from groupbox within w_sal_02060
integer x = 41
integer y = 48
integer width = 3552
integer height = 348
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

type rb_1 from radiobutton within w_sal_02060
integer x = 2455
integer y = 460
integer width = 439
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "완료자료 배제"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_1.SetFocus()

wf_radio(this)
end event

type rb_2 from radiobutton within w_sal_02060
integer x = 2944
integer y = 460
integer width = 439
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "완료자료 포함"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_1.SetFocus()

wf_radio(this)
end event

type dw_list from u_key_enter within w_sal_02060
integer x = 73
integer y = 552
integer width = 3497
integer height = 1284
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_sal_02060_03"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string s_salegu,s_itnbr,s_sdate

////선택한 행 반전//////////////////////////////////////////////////////////
If Row <= 0 then
	dw_1.SelectRow(0,False)
	dw_1.setfocus()
	return
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
END IF

////  행을 선택하여 dw_insert로 retrieve             //////////////////////////
////  해당 행에서 키(품번, 적용시작일)를 retrieve    ////////////////////////// 

s_salegu = this.getitemstring(Row, "itdc_salegu")
s_itnbr = this.getitemstring(Row, "itdc_itnbr")
s_sdate  = this.getitemstring(Row, "itdc_start_date")

IF dw_insert.retrieve(s_salegu,s_itnbr, s_sdate) <= 0	THEN
   f_message_chk(50, '[특정제품 할인율 등록]') 
	cb_can.TriggerEvent(clicked!)
else
	wf_key_protect(True)
	dw_insert.setcolumn('start_date')
	dw_insert.setfocus()
END IF

end event

type dw_1 from datawindow within w_sal_02060
event ue_key pbm_dwnkey
event ue_enter pbm_dwnprocessenter
integer x = 69
integer y = 456
integer width = 2368
integer height = 76
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sal_02060_02"
boolean border = false
boolean livescroll = true
end type

event ue_key;str_itnct str_sitnct
string snull

setnull(gs_code)
setnull(snull)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "itcls" Then
		open(w_ittyp_popup3)
		
		str_sitnct  = Message.PowerObjectParm
				
		if isnull(str_sitnct.s_sumgub) or str_sitnct.s_sumgub = "" then return
		this.SetItem(1,"ittyp", str_sitnct.s_ittyp )		
		this.SetItem(1,"itcls", str_sitnct.s_sumgub )
		this.SetItem(1,"itclsnm", str_sitnct.s_titnm )
//		cb_inq.TriggerEvent(Clicked!)
		RETURN 1
	End if	
END IF		
end event

event ue_enter;Send(Handle(this),256,9,0)
Return 1
end event

event rbuttondown;String s_colname,	sIttyp
long nRow

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

this.accepttext()
nRow = GetRow()

if this.GetColumnName() = 'itcls' then
	sIttyp = This.GetItemString(row,'ittyp')
	OpenWithParm(w_ittyp_popup8, sIttyp)
	
   lstr_sitnct = Message.PowerObjectParm
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"itclsnm", lstr_sitnct.s_titnm)
	this.SetColumn('itcls')
   This.TriggerEvent(Itemchanged!)
end if
 
end event

event itemchanged;string itclsnm,itcls,s_itnbr, s_itdsc, s_ispec
string s_name,s_itt,snull,get_nm,sDate

Choose Case  GetColumnName() 
	Case 'ittyp'
		dw_list.reset()
		this.SetItem(row,'itcls','')
		this.SetItem(row,'itclsnm','')
	Case 'itcls'
		s_name = Trim(this.gettext())
      s_itt  = This.GetItemString(row,'ittyp')
      IF s_itt = "" OR IsNull(s_itt) THEN 	
		   This.setColumn('ittyp')
		   RETURN 2
	   END IF
	
      SELECT "ITNCT"."TITNM"  
        INTO :get_nm  
        FROM "ITNCT"  
       WHERE ( "ITNCT"."ITTYP" = :s_itt ) AND  
             ( "ITNCT"."ITCLS" = :s_name ) ;

   	IF SQLCA.SQLCODE = 0 THEN
		   This.setitem(1, 'itclsnm', get_nm)
			cb_inq.TriggerEvent(Clicked!)
		Else
			Return 1
      END IF
End Choose

end event

event itemerror;RETURN 1
end event

type gb_3 from groupbox within w_sal_02060
integer x = 41
integer y = 408
integer width = 3552
integer height = 1448
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

