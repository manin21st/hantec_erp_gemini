$PBExportHeader$w_pdm_t_00060.srw
$PBExportComments$차종별 BOM 구성
forward
global type w_pdm_t_00060 from w_inherite
end type
type rr_2 from roundrectangle within w_pdm_t_00060
end type
type gb_3 from groupbox within w_pdm_t_00060
end type
type gb_2 from groupbox within w_pdm_t_00060
end type
type dw_1 from datawindow within w_pdm_t_00060
end type
type rr_1 from roundrectangle within w_pdm_t_00060
end type
type dw_list from datawindow within w_pdm_t_00060
end type
type rr_3 from roundrectangle within w_pdm_t_00060
end type
end forward

global type w_pdm_t_00060 from w_inherite
string title = "차종별 BOM 구성"
rr_2 rr_2
gb_3 gb_3
gb_2 gb_2
dw_1 dw_1
rr_1 rr_1
dw_list dw_list
rr_3 rr_3
end type
global w_pdm_t_00060 w_pdm_t_00060

type variables
string is_itnbr
str_itnct lstr_sitnct


end variables

forward prototypes
public subroutine wf_color_change ()
public function integer wf_itemchk (string sitem)
public subroutine wf_reset ()
public subroutine wf_all_retrieve (string s_code)
public function integer wf_required_chk ()
end prototypes

public subroutine wf_color_change ();//long k, lcount
//
//if dw_insert.AcceptText() = -1 then return 
//
//lcount = dw_insert.rowcount()
//
//if lcount < 1 then return 
//
//FOR k=2 TO dw_insert.rowcount()
////	sitnbr = dw_insert.getitemstring(
//	
//	if dw_insert.getitemstring(k - 1, 'stdnbr') <> dw_insert.getitemstring(k, 'stdnbr') then 
//		if dw_insert.getitemstring(k - 1, 'yopt') = 'Y'	then
//			dw_insert.setitem(k, 'yopt', 'N')
//		else
//			dw_insert.setitem(k, 'yopt', 'Y')
//		end if	
//	else
//		dw_insert.setitem(k, 'yopt', dw_insert.getitemstring(k - 1, 'yopt'))
//	end if	
//NEXT
//
//
//
end subroutine

public function integer wf_itemchk (string sitem);string s_itnbr
long   get_count, lrow

lrow = dw_insert.getrow()

s_itnbr = dw_insert.GetItemString(lrow, "itemas_itnbr")

If s_itnbr = sitem then
	f_message_chk(44,'[표준품번]')
	return -1
Else		   
//	SELECT COUNT(*)  
//	  INTO :get_count  
//	  FROM "PSTRUC"  
//	 WHERE "PSTRUC"."PINBR" = :sitem   ;
//	
//	if get_count > 0 then
//      SELECT COUNT(*)
//		  INTO :get_count  
//		  FROM "ROUTNG"  
//		 WHERE "ROUTNG"."ITNBR" = :sitem   ;
//		
//		if get_count > 0 then 
//			return 1
//		else
//			f_message_chk(113,'[표준품번]')
//			return -1
//		end if
//	else
//		f_message_chk(55,'[표준품번]')
//		return -1
//	end if
End if

end function

public subroutine wf_reset ();
dw_insert.setredraw(false)
dw_list.setredraw(false)
dw_1.setredraw(false)

ib_any_typing = FALSE
//
dw_insert.reset()
dw_list.reset()
dw_1.reset()

dw_1.setcolumn('porgu')
dw_1.setfocus()
dw_1.insertrow(0)
//dw_insert.insertRow(0)

dw_1.setredraw(true)
dw_insert.setredraw(true)
dw_list.setredraw(true)




end subroutine

public subroutine wf_all_retrieve (string s_code);
dw_insert.retrieve(s_code)
dw_insert.SetTaborder('itnbr',0)
ib_any_typing = FALSE

p_del.enabled 	= true
p_print.enabled 	= true

p_del.PictureName  	= "C:\erpman\image\삭제_up.gif"
p_print.PictureName  	= "C:\erpman\image\인쇄_up.gif"





end subroutine

public function integer wf_required_chk ();int k

// 필수 입력사항 확인.

FOR 	k=1 TO dw_insert.rowcount()
	// 거래처코드
	if 	isnull(dw_insert.GetItemString(k,'cvcod')) or &
		dw_insert.GetItemString(k,'cvcod') = "" then
		f_message_chk(1400,'[cvcod]')
		dw_insert.SetRow(k)
		dw_insert.SetColumn('cvcod')
		dw_insert.SetFocus()
		return -1
	end if	
	// 관리품번
	if 	isnull(dw_insert.GetItemString(k,'bunbr')) or &
		dw_insert.GetItemString(k,'bunbr') = "" then
		f_message_chk(1400,'[관리품번]')
		dw_insert.SetRow(k)
		dw_insert.SetColumn('bunbr')
		dw_insert.SetFocus()
		return -1
	end if	
	// 관리품명
	if 	isnull(dw_insert.GetItemString(k,'budsc')) or &
		dw_insert.GetItemString(k,'budsc') = "" then
		f_message_chk(1400,'[관리품명]')
		dw_insert.SetRow(k)
		dw_insert.SetColumn('budsc')
		dw_insert.SetFocus()
		return -1
	end if	
	
//  나중에는 자동으로 순번을 채번할 수 있도록 지정.....	
//	dw_insert.SetItem(k, "seqno", k)
	
NEXT


return 1
end function

on w_pdm_t_00060.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.gb_3=create gb_3
this.gb_2=create gb_2
this.dw_1=create dw_1
this.rr_1=create rr_1
this.dw_list=create dw_list
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.gb_3
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.dw_list
this.Control[iCurrent+7]=this.rr_3
end on

on w_pdm_t_00060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.dw_1)
destroy(this.rr_1)
destroy(this.dw_list)
destroy(this.rr_3)
end on

event open;call super::open;dw_list.SetTransObject(sqlca)
dw_insert.SetTransObject(sqlca)

dw_1.SetTransObject(sqlca)
dw_1.insertrow(0)
dw_1.SetFocus()

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'porgu', gs_code)
	if gs_code <> '%' then
		dw_1.Modify("porgu.protect=1")
		dw_1.Modify("porgu.background.color = 80859087")
	End if
End If
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

type dw_insert from w_inherite`dw_insert within w_pdm_t_00060
integer x = 2290
integer y = 516
integer width = 2309
integer height = 1760
integer taborder = 40
string dataobject = "d_pdm_t_00060_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::rbuttondown;int lreturnrow, lrow
string snull

setnull(gs_code)
setnull(gs_codename)
setnull(snull)

lrow = this.getrow()

IF 	this.GetColumnName() = "cvcod" THEN
	gs_code = this.GetText()
	IF 	Gs_code ="" OR IsNull(gs_code) THEN 
		gs_code =""
	END IF
	
	Open(w_vndmst_popup)
	
	IF 	isnull(gs_Code)  or  gs_Code = ''	then  
		this.SetItem(lrow, "cvcod", snull)
		this.SetItem(lrow, "cvnam", snull)
   	return
   ELSE
		lReturnRow = This.Find("cvcod = '"+gs_code+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
			f_message_chk(37,'[거래처]') 
			this.SetItem(lRow, "cvcod", sNull)
		   	this.SetItem(lRow, "cvnam", sNull)
			RETURN  1
		END IF
   END IF	

	this.SetItem(lrow, "cvcod", gs_Code)
	this.SetItem(lrow, "cvnam", gs_Codename)
END IF

end event

event dw_insert::updatestart;///* Update() function 호출시 user 설정 */
//long k, lRowCount
//
//lRowCount = this.RowCount()
//
//FOR k = 1 TO lRowCount
//   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
// 	   This.SetItem(k,'crt_user',gs_userid)
//   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
//	   This.SetItem(k,'upd_user',gs_userid)
//   END IF	  
//NEXT
//
//
end event

event dw_insert::itemchanged;call super::itemchanged;Int lRow, lReturnRow
string s_cvcod, sNull, get_nm

SetNull(snull)

IF this.GetColumnName() = "cvcod" THEN
	lRow  = this.GetRow()	
	s_cvcod = this.GetText()								
    
	if s_cvcod = "" or isnull(s_cvcod) then 
		this.setitem(lrow, 'cvnam', snull)
		return 
	end if
	
   	SELECT 	"VNDMST"."CVNAS"  
     		INTO 	:get_nm  
     		FROM "VNDMST"  
    		WHERE "VNDMST"."CVCOD" = :s_cvcod  ;

	if sqlca.sqlcode = 0 then 
		this.setitem(lrow, 'cvnam', get_nm)
	else
		this.triggerevent(RbuttonDown!)
	   return 1
   	end if	
	
	lReturnRow = This.Find("cvcod = '"+s_cvcod+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
		messagebox('확 인','등록된 거래처입니다. 순번을 증가시켜야 합니다.') 
		RETURN  1
	END IF
END IF

IF 	this.GetColumnName() = "bunbr" THEN
	long    start_pos=1
	string  new_str, mystring

	mystring = this.GetText()		
	new_str = ""

	// Find the first occurrence of old_str.
	start_pos = Pos(mystring, '-', start_pos)

	// Only enter the loop if you find old_str.

	DO WHILE start_pos > 0

    		// Replace old_str with new_str.
    		mystring = Replace(mystring, start_pos,   Len('-'), new_str)

    		// Find the next occurrence of old_str.

    		start_pos = Pos(mystring, '-',  start_pos+Len(new_str))
	LOOP
	dw_insert.SetItem(lrow, "cunbr",mystring)
End If

end event

type p_delrow from w_inherite`p_delrow within w_pdm_t_00060
integer x = 4274
integer y = 336
end type

event p_delrow::clicked;call super::clicked;dw_insert.AcceptText()

IF dw_insert.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

dw_insert.DeleteRow(0)

//IF dw_insert.Update() = 1 THEN
//	ib_any_typing =False
//	w_mdi_frame.sle_msg.text ="자료를 삭제하였습니다!!"
//ELSE
//	ROLLBACK;
//	Return
//END IF
//
//COMMIT;
//ib_any_typing =False

dw_insert.ScrollToRow(dw_insert.RowCount())
dw_insert.Setfocus()

end event

type p_addrow from w_inherite`p_addrow within w_pdm_t_00060
integer x = 4009
integer y = 336
end type

event p_addrow::clicked;call super::clicked;Int    il_currow,il_RowCount, k

IF 	dw_insert.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow 		= dw_insert.GetRow()
	il_RowCount 	= dw_insert.RowCount()
	
	IF 	il_currow <=0 THEN
		il_currow = il_rowCount
	END IF
END IF

il_currow = il_rowCount + 1
dw_insert.InsertRow(il_currow)
dw_insert.SetItem(il_currow,"itnbr",is_itnbr)
dw_insert.ScrollToRow(il_currow)
dw_insert.SetColumn("cvcod")
dw_insert.SetFocus()

dw_insert.Modify("DataWindow.HorizontalScrollPosition = '0'")

end event

type p_search from w_inherite`p_search within w_pdm_t_00060
boolean visible = false
integer x = 2487
integer y = 3440
end type

type p_ins from w_inherite`p_ins within w_pdm_t_00060
boolean visible = false
integer x = 3008
integer y = 3440
end type

type p_exit from w_inherite`p_exit within w_pdm_t_00060
integer x = 4434
end type

type p_can from w_inherite`p_can within w_pdm_t_00060
integer x = 4251
end type

event p_can::clicked;call super::clicked;wf_reset()
ib_any_typing = FALSE

p_del.enabled 	= false
p_print.enabled 	= false

p_del.PictureName  	= "C:\erpman\image\삭제_d.gif"
p_print.PictureName  	= "C:\erpman\image\인쇄_d.gif"

dw_insert.SetFocus()


end event

type p_print from w_inherite`p_print within w_pdm_t_00060
integer x = 4069
boolean enabled = false
string picturename = "C:\erpman\image\인쇄_d.gif"
end type

event p_print::clicked;call super::clicked;

OpenWithParm(w_print_options, dw_insert)
end event

type p_inq from w_inherite`p_inq within w_pdm_t_00060
integer x = 3520
end type

event p_inq::clicked;call super::clicked;string ls_gritu, ls_porgu, ls_mdl_jijil

if dw_1.AcceptText() = -1 then return 

ls_gritu 		= dw_1.GetItemString(1,'gritu')
ls_porgu 		= dw_1.GetItemString(1,'porgu')
ls_mdl_jijil 	= dw_1.GetItemString(1,'mdl_jijil') 

if 	isnull(ls_mdl_jijil)	or	ls_mdl_jijil = "" then
	ls_mdl_jijil	=  "%"
End if

SetPointer(HourGlass!)

dw_1.setredraw(false)

if dw_list.Retrieve(ls_porgu, ls_gritu, ls_mdl_jijil) <= 0 then 
	f_message_chk(50,'[차종]')
	dw_1.setredraw(true)
	dw_1.Setfocus()
   dw_insert.setredraw(true)
	return
else
	dw_list.SetFocus()
end if	

ib_any_typing = FALSE

dw_1.setredraw(true)

end event

type p_del from w_inherite`p_del within w_pdm_t_00060
integer x = 3886
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::clicked;call super::clicked;long   ix

if dw_insert.rowcount() < 0 then return 

if is_itnbr = '' or isnull(is_itnbr) then return 

dw_insert.SetRedraw(FALSE)

For ix = 1 to dw_insert.rowcount()
	dw_insert.DeleteRow(ix)
Next


if dw_insert.Update() > 0 then
	COMMIT ;
	ib_any_typing =False
else
	rollback ;
	ib_any_typing =True
	return
end if

w_mdi_frame.sle_msg.text =	"자료를 삭제하였습니다!!"	

dw_insert.SetRedraw(TRUE)

wf_reset()

p_del.enabled 	= false
p_print.enabled 	= false

p_del.PictureName  	= "C:\erpman\image\삭제_d.gif"
p_print.PictureName   	= "C:\erpman\image\인쇄_d.gif"



end event

type p_mod from w_inherite`p_mod within w_pdm_t_00060
integer x = 3703
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 	

if f_msg_update() = -1 then return


// 필수입력사항 검사
if wf_required_chk() = -1 then return
/////////////////////////////////////////////////////////////////////////////

SetPointer(HourGlass!)
	
if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		
wf_all_retrieve(is_itnbr)
end event

type cb_exit from w_inherite`cb_exit within w_pdm_t_00060
boolean visible = false
integer x = 4005
integer y = 3244
integer taborder = 70
end type

type cb_mod from w_inherite`cb_mod within w_pdm_t_00060
boolean visible = false
integer x = 3301
integer y = 3244
integer taborder = 50
end type

event cb_mod::clicked;call super::clicked;//if dw_insert.AcceptText() = -1 then return 
//
//if dw_insert.rowcount() <= 0 then return 	
//
//if f_msg_update() = -1 then return
//
//SetPointer(HourGlass!)
//	
//if dw_insert.update() = 1 then
//	sle_msg.text = "자료가 저장되었습니다!!"
//	ib_any_typing= FALSE
//	commit ;
//else
//	rollback ;
//	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
//	return 
//end if	
//		
//cb_inq.TriggerEvent(Clicked!)
end event

type cb_ins from w_inherite`cb_ins within w_pdm_t_00060
boolean visible = false
integer x = 567
integer y = 2848
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_t_00060
boolean visible = false
integer x = 1170
integer y = 2768
end type

type cb_inq from w_inherite`cb_inq within w_pdm_t_00060
boolean visible = false
integer x = 73
integer y = 3232
integer taborder = 20
end type

event cb_inq::clicked;call super::clicked;//string s_ittyp, s_itcls, sfilter, newsort
//
//if dw_1.AcceptText() = -1 then return 
//
//s_ittyp = dw_1.GetItemString(1,'ittyp')
//s_itcls = dw_1.GetItemString(1,'itcls')
//
//if isnull(s_ittyp) or s_ittyp = "" then
//	f_message_chk(30,'[품목구분]')
//	dw_1.SetColumn('ittyp')
//	dw_1.SetFocus()
//	return
//end if	
//
//SetPointer(HourGlass!)
//
//dw_insert.setredraw(false)
//
//if isnull(s_itcls) or s_itcls = "" then 
//   sfilter = ""
//else
//	s_itcls = s_itcls + '%'
//   sfilter = " itemas_itcls  like '"+ s_itcls +"' "
//end if	
//
//dw_insert.SetFilter(sfilter)
//dw_insert.Filter( )
//
//if dw_insert.Retrieve(s_ittyp) <= 0 then 
//	dw_1.Setfocus()
//   dw_insert.setredraw(true)
//	return
//else
//	dw_insert.SetFocus()
//end if	
//
////wf_color_change()
//
//ib_any_typing = FALSE
//
//dw_insert.setredraw(true)
//
end event

type cb_print from w_inherite`cb_print within w_pdm_t_00060
boolean visible = false
integer x = 425
integer y = 3232
integer taborder = 30
end type

event cb_print::clicked;call super::clicked;//OpenWithParm(w_print_options, dw_insert)
end event

type st_1 from w_inherite`st_1 within w_pdm_t_00060
end type

type cb_can from w_inherite`cb_can within w_pdm_t_00060
boolean visible = false
integer x = 3653
integer y = 3244
end type

event cb_can::clicked;call super::clicked;//wf_reset()
//ib_any_typing = FALSE
//
//
//
end event

type cb_search from w_inherite`cb_search within w_pdm_t_00060
boolean visible = false
integer x = 2647
integer y = 2908
end type





type gb_10 from w_inherite`gb_10 within w_pdm_t_00060
integer y = 2960
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_t_00060
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_t_00060
end type

type rr_2 from roundrectangle within w_pdm_t_00060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2277
integer y = 296
integer width = 2331
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

type gb_3 from groupbox within w_pdm_t_00060
boolean visible = false
integer x = 3259
integer y = 3184
integer width = 1120
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type gb_2 from groupbox within w_pdm_t_00060
boolean visible = false
integer x = 27
integer y = 3172
integer width = 777
integer height = 204
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 79741120
end type

type dw_1 from datawindow within w_pdm_t_00060
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 27
integer y = 28
integer width = 2359
integer height = 232
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdm_t_00060_1"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;return 1
end event

type rr_1 from roundrectangle within w_pdm_t_00060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 18
integer y = 296
integer width = 2162
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_list from datawindow within w_pdm_t_00060
integer x = 37
integer y = 312
integer width = 2130
integer height = 1960
integer taborder = 50
string dataobject = "d_pdm_t_00060_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event clicked;SetPointer(HourGlass!)

this.SetRedraw(FALSE)

SetNull(is_itnbr)
If 	Row <= 0 then
	this.SelectRow(0,False)
ELSE

	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
	
//	b_flag = False
   	is_itnbr = dw_list.GetItemString(Row,"itnbr")
	
   	if 	dw_insert.Retrieve(is_itnbr) <= 0 then
		ib_any_typing 	= FALSE	
		p_del.enabled 	= FALSE
		p_print.enabled 	= FALSE
   	else
		wf_all_retrieve(is_itnbr)
	end if	
END IF

//CALL SUPER ::CLICKED 

this.SetRedraw(true)

end event

type rr_3 from roundrectangle within w_pdm_t_00060
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 3959
integer y = 316
integer width = 530
integer height = 184
integer cornerheight = 40
integer cornerwidth = 55
end type

