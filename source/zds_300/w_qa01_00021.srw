$PBExportHeader$w_qa01_00021.srw
$PBExportComments$** 입하품질검사 내역 등록(팝업)
forward
global type w_qa01_00021 from window
end type
type p_del from picture within w_qa01_00021
end type
type p_ins from picture within w_qa01_00021
end type
type p_exit from picture within w_qa01_00021
end type
type p_mod from picture within w_qa01_00021
end type
type st_1 from statictext within w_qa01_00021
end type
type dw_1 from datawindow within w_qa01_00021
end type
type cb_exit from commandbutton within w_qa01_00021
end type
type cb_delete from commandbutton within w_qa01_00021
end type
type cb_insert from commandbutton within w_qa01_00021
end type
type cb_save from commandbutton within w_qa01_00021
end type
type dw_list from datawindow within w_qa01_00021
end type
type rr_2 from roundrectangle within w_qa01_00021
end type
end forward

global type w_qa01_00021 from window
integer x = 379
integer y = 312
integer width = 3072
integer height = 1628
boolean titlebar = true
string title = "입하 품질검사 내역등록"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_del p_del
p_ins p_ins
p_exit p_exit
p_mod p_mod
st_1 st_1
dw_1 dw_1
cb_exit cb_exit
cb_delete cb_delete
cb_insert cb_insert
cb_save cb_save
dw_list dw_list
rr_2 rr_2
end type
global w_qa01_00021 w_qa01_00021

type variables
char c_status

// 자료변경여부 검사
Boolean ib_any_typing 

String     is_today              //시작일자
String     is_totime             //시작시간
String     is_window_id      //윈도우 ID
String     is_usegub           //이력관리 여부

str_qct_01040 str_01040
str_qa01_00020 str_00020

Datawindow  idw_imhfat
end variables

forward prototypes
public function integer wf_warndataloss (string as_titletext)
public subroutine wf_initial ()
public function integer wf_checkrequiredfield ()
end prototypes

public function integer wf_warndataloss (string as_titletext);/*===================================================================
 1. window-level user function : 종료, 등록, 조회시 호출됨
    dw_detail, dw_list 의 typing(datawindow) 변경사항 검사

 2. 계속진행할 경우 변경사항이 저장되지 안음을 경고                                                               

 3. Argument:  as_titletext (warning messagebox)                                                                          
    Return values:                                                   
                                                                  
      *  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
		* -1 : 진행을 중단할 경우.                      
=====================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : " + as_titletext , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		dw_list.SetFocus()						// yes 일 경우: focus 'dw_detail' 
		RETURN -1									

	END IF

END IF
																
RETURN 1																// (dw_detail) 에 변경사항이 없거나 no일 경우
																		// 변경사항을 저장하지 않고 계속진행 


end function

public subroutine wf_initial ();
string	sDateFrom,	&
			sDateTo,		&
			sRemark,		&
			sRemark2, sItnbr, sGrpno1, sIttyp, sjijil, sispec_code 
			
		
/* 기본내역 */
dw_1.Reset()
dw_1.insertrow(0)
dw_1.setitem(1, "iojpno", str_00020.iojpno)
dw_1.setitem(1, "itnbr",  str_00020.itnbr)
dw_1.setitem(1, "itdsc",  str_00020.itdsc)
dw_1.setitem(1, "ispec",  str_00020.ispec)
dw_1.setitem(1, "ioqty",  str_00020.ioqty)
dw_1.setitem(1, "buqty",  str_00020.buqty)

/* 검사항목 */
sItnbr = str_00020.itnbr;

Select a.ittyp, b.grpno1, a.jijil, a.ispec_code 
  into :sIttyp, :sgrpno1, :sjijil, :sispec_code 
  from itemas a,  itemas_inspection b
 where a.itnbr = :sItnbr and a.itnbr = b.itnbr;

dw_1.setitem(1, "ittyp",  sIttyp)
dw_1.setitem(1, "insgbn", sGrpno1)
dw_1.setitem(1, "jijil",  sjijil)
dw_1.setitem(1, "ispec_code", sispec_code)

/* 검사상세항목 */
datawindowchild dws1
dw_list.getchild("bulcod", dws1)
dws1.settransobject(sqlca)

if dws1.retrieve('%')	  < 1 then
//	Messagebox("검사항목", "품목에 대한 검사항목이 없읍니다" + '~n' + &
//								  "전체검사항목이 출력됩니다")
	dws1.retrieve('%')
end if

dw_list.Retrieve(gs_sabu, str_00020.iojpno)


end subroutine

public function integer wf_checkrequiredfield ();string	sCode
long		lRow
dec{3}	dQty

FOR lRow = 1	TO		dw_list.RowCount()
	
	// 불량코드
	sCode = dw_list.GetitemString(lRow, "bulcod")
	IF IsNull(sCode)	or   trim(sCode) = ''	THEN
		f_message_chk(30,'[불량코드]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("bulcod")
		dw_list.setfocus()
		RETURN -1
	END IF

	// 불량수량
	dQty = dw_list.GetitemDecimal(lRow, "bulqty")
	IF IsNull(dQty)	or   dQty = 0	THEN
		f_message_chk(30,'[불량수량]')
		dw_list.ScrollToRow(lrow)
		dw_list.Setcolumn("bulqty")
		dw_list.setfocus()
		RETURN -1
	END IF
	
	dw_list.setitem(lrow, "iojpno", str_00020.iojpno)

NEXT


RETURN 1
end function

event open;f_window_center_response(This)

/* 검사상세항목 */
dw_1.SetTransObject(SQLCA)
dw_list.SetTransObject(SQLCA)	

DataWindowChild dws1
dw_list.GetChild("bulcod", dws1)
dws1.SetTransObject(SQLCA)
dws1.Retrieve('%')	

str_00020 = Message.PowerObjectParm

IF IsValid(str_00020) = FALSE THEN Close(This)

wf_initial()


end event

on w_qa01_00021.create
this.p_del=create p_del
this.p_ins=create p_ins
this.p_exit=create p_exit
this.p_mod=create p_mod
this.st_1=create st_1
this.dw_1=create dw_1
this.cb_exit=create cb_exit
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.cb_save=create cb_save
this.dw_list=create dw_list
this.rr_2=create rr_2
this.Control[]={this.p_del,&
this.p_ins,&
this.p_exit,&
this.p_mod,&
this.st_1,&
this.dw_1,&
this.cb_exit,&
this.cb_delete,&
this.cb_insert,&
this.cb_save,&
this.dw_list,&
this.rr_2}
end on

on w_qa01_00021.destroy
destroy(this.p_del)
destroy(this.p_ins)
destroy(this.p_exit)
destroy(this.p_mod)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.cb_exit)
destroy(this.cb_delete)
destroy(this.cb_insert)
destroy(this.cb_save)
destroy(this.dw_list)
destroy(this.rr_2)
end on

type p_del from picture within w_qa01_00021
integer x = 2665
integer y = 32
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
boolean focusrectangle = false
end type

event clicked;long	lrow ,i
Dec{3} dSum_Qty = 0 
String ls_new

dw_list.AcceptText()

lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN

ls_new = Trim(dw_list.Object.is_new[lRow])

dw_list.DeleteRow(lRow)
dw_list.AcceptText()
IF dw_list.RowCount() > 0	THEN
	For i = 1 To dw_list.RowCount()
		dSum_Qty = dSum_Qty + dw_list.GetItemDecimal(i, "buqty")
	Next
//	dw_1.Object.buqty[1] = dSum_Qty
END IF

ib_any_typing = 	False

If ls_new = 'Y' Then Return

IF dw_list.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
	Return
Else
	Commit ;
END IF



SetPointer(Arrow!)


end event

type p_ins from picture within w_qa01_00021
integer x = 2491
integer y = 32
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\추가_up.gif"
boolean focusrectangle = false
end type

event clicked;
IF f_CheckRequired(dw_list) = -1	THEN	RETURN

ib_any_typing = 	True
//////////////////////////////////////////////////////////////////////////	
long	lRow
lRow = dw_list.InsertRow(0)

dw_list.setitem(lrow, "silyoq", str_00020.siqty)
dw_list.ScrollToRow(lRow)
dw_list.SetColumn("bulcod")
dw_list.SetFocus()




end event

type p_exit from picture within w_qa01_00021
integer x = 2839
integer y = 32
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean focusrectangle = false
end type

event clicked;

If wf_warndataloss("입하품질검하 내역") < 1 Then Return

CloseWithReturn(parent,"OK")

end event

type p_mod from picture within w_qa01_00021
integer x = 2318
integer y = 32
integer width = 178
integer height = 144
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event clicked;//SetPointer(HourGlass!)

If f_msg_update() < 1 Then Return

IF dw_list.AcceptText() = -1 THEN RETURN 

IF	wf_CheckRequiredField() = -1		THEN		RETURN

dec{3} dSum_Qty = 0 ,ld_reqty
Long  i

IF dw_list.RowCount() > 0	THEN
	
	For i = 1 To dw_list.RowCount()
		dSum_Qty = dSum_Qty + dw_list.GetItemDecimal(i, "bulqty")
	Next

	ld_reqty = dw_1.Object.ioqty[1]

	If ld_reqty < dSum_qty Then
		MessageBox('확인','입고 수량보다 불량수량이 더 많을 수 없습니다.')
		Return
	End If
	
END IF

// 불량수량 확인
IF	dw_1.Object.buqty[1] <> dSum_Qty THEN
	MessageBox('확인','총 불량수량이 틀립니다!!!')
	Return
End If


st_1.TEXT = '자료를 저장중.......'

////////////////////////////////////////////////////////////////////////
IF dw_list.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
Else
	Commit ;
END IF

ib_any_typing = 	False

SetPointer(Arrow!)

p_exit.TriggerEvent(Clicked!)

/////////////////////////////////////////////////////////////////////////


end event

type st_1 from statictext within w_qa01_00021
boolean visible = false
integer x = 987
integer y = 1624
integer width = 1225
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 79741120
boolean enabled = false
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_qa01_00021
integer y = 192
integer width = 3035
integer height = 264
integer taborder = 10
string dataobject = "d_qa01_00021_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;
if getcolumnname() = 'ittyp' then
	
	String sNull
	
	datawindowchild dws
	this.getchild("insgbn", dws)
	dws.settransobject(sqlca)
	dws.retrieve(data)	
	
end if

if getcolumnname() = 'insgbn' then
	
	/* 검사상세항목 */
	datawindowchild dws1
	dw_list.getchild("bulcod", dws1)
	dws1.settransobject(sqlca)
	dws1.retrieve(data+'%')	
	
end if
end event

type cb_exit from commandbutton within w_qa01_00021
boolean visible = false
integer x = 2688
integer y = 1604
integer width = 329
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;If Messagebox("불량요인", "해당 전표에 대한 불량내역은 자동으로 삭제됩니다" + '~n' + &
								  "계속하시겠읍니까?", question!, yesno!) = 2 then
	Return										  
end if

SetPointer(HourGlass!)

String iojpno
Long   lrow
Datawindow dwname

iojpno = str_01040.iojpno
Lrow	 = str_01040.rowno
dwname = str_01040.dwname
/* 불량 및 조건부 내역 */
Delete from imhfat
 Where sabu = :gs_sabu and iojpno = :iojpno;

IF sqlca.sqlcode < 0		THEN
	ROLLBACK;
	f_Rollback()
	close(parent)
END IF

/* 입고이력에 불량,조건부를 0로 setting */
dwname.setitem(lrow, "imhist_iofaqty", 0)
dwname.setitem(lrow, "imhist_iocdqty", 0)

if str_01040.gubun = 'Y' then  //수입검사에서 open한 경우만 공제와 변환쪽에 0 셋팅
	dwname.setitem(lrow, "imhist_cnviofa", 0)
	dwname.setitem(lrow, "imhist_cnviocd", 0)
	dwname.setitem(lrow, "imhist_gongqty", 0)
	dwname.setitem(lrow, "imhist_cnvgong", 0)
	dwname.setitem(lrow, "imhist_gongprc", 0)
end if

/* 원자재 이상 통지 내역 */
Delete from imhfag
 Where sabu = :gs_sabu and iojpno = :iojpno; 

IF sqlca.sqlcode < 0		THEN
	ROLLBACK;
	f_Rollback()
END IF

SetPointer(Arrow!)
 
close(parent)

end event

type cb_delete from commandbutton within w_qa01_00021
boolean visible = false
integer x = 475
integer y = 1604
integer width = 407
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "행삭제(&L)"
end type

event clicked;long	lrow
lRow = dw_list.GetRow()

IF lRow < 1		THEN	RETURN

IF f_msg_delete() = -1 THEN	RETURN
	
dw_list.DeleteRow(0)




end event

type cb_insert from commandbutton within w_qa01_00021
boolean visible = false
integer x = 50
integer y = 1604
integer width = 407
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "행추가(&A)"
end type

event clicked;
IF f_CheckRequired(dw_list) = -1	THEN	RETURN


//////////////////////////////////////////////////////////////////////////
long	lRow
lRow = dw_list.InsertRow(0)

dw_list.setitem(lrow, "silyoq", str_01040.siqty)
dw_list.ScrollToRow(lRow)
dw_list.SetColumn("bulcod")
dw_list.SetFocus()


end event

type cb_save from commandbutton within w_qa01_00021
boolean visible = false
integer x = 2336
integer y = 1604
integer width = 329
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;SetPointer(HourGlass!)

if str_01040.buqty > 0 or str_01040.joqty > 0 then
	if dw_list.rowcount() = 0 then
		MessageBox("확인", "자료를 입력하시기 바랍니다.")
		dw_list.SetFocus()
		RETURN
	END IF	
end if

IF dw_list.AcceptText() = -1 THEN RETURN 

IF	wf_CheckRequiredField() = -1		THEN		RETURN

dec{3} dSum_Qty

IF dw_list.RowCount() > 0	THEN
	dSum_Qty = dw_list.GetItemDecimal(1, "buqty")
	if str_01040.buqty > 0 then
		IF dSum_qty < 1	THEN
			MessageBox("확인", "불량수량은 0이상이어야 합니다.")
			dw_list.SetFocus()
			RETURN
		END IF
	end if
	
	dSum_Qty = dw_list.GetItemDecimal(1, "joqty")	
	IF dSum_qty <> str_01040.joqty	THEN
		MessageBox("확인", "조건부수량이 같지 않습니다.")
		dw_list.SetFocus()
		RETURN
	END IF	

END IF

IF f_msg_update() = -1 	THEN	RETURN

st_1.TEXT = '자료를 저장중.......'

////////////////////////////////////////////////////////////////////////
IF dw_list.Update() <= 0		THEN
	ROLLBACK;
	f_Rollback()
END IF

SetPointer(Arrow!)

close(parent)

/////////////////////////////////////////////////////////////////////////


end event

type dw_list from datawindow within w_qa01_00021
event ue_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 18
integer y = 472
integer width = 2976
integer height = 992
integer taborder = 20
string dataobject = "d_qa01_00021_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;
RETURN 1
end event

on editchanged; ib_any_typing = true
end on

on rowfocuschanged;this.setrowfocusindicator ( HAND! )
end on

event itemchanged;
string	ls_code, ls_name,	&
			ls_Null
long		lReturnRow
Dec      ld_bulqty , ld_sum_bulqty

SetNull(ls_null)

// 불량코드
IF Lower(GetColumnName()) = 'bulcod' THEN

	ls_code = this.GetText()
	
	/////////////////////////////////////////////////////////////////////////
	//  1. 중복될 경우 RETURN
	/////////////////////////////////////////////////////////////////////////
	lReturnRow = This.Find("bulcod = '"+ls_code+"' ", 1, This.RowCount())

	IF (row <> lReturnRow) and (lReturnRow <> 0)		THEN
		f_message_chk(33,'[불량코드]')
		this.SetItem(Row, "bulcod", ls_null)
		RETURN  1
	END IF
	
	
//  SELECT "REFFPF"."RFNA1"  
//    INTO :ls_name  
//    FROM "REFFPF"  
//   WHERE ( "REFFPF"."RFCOD" = '32' ) AND  
//         ( "REFFPF"."RFGUB" = :ls_code )   ;
//	 
//	if sqlca.sqlcode <> 0 	then
//		f_message_chk(33,'[불량코드]')
//		this.setitem(row, "bulcod", ls_null)
//		return 1
//	end if

ElseIF Lower(GetColumnName()) = 'bulqty' THEN
	
	 ld_bulqty     = dw_1.Object.ioqty[1]
	 ld_sum_bulqty = This.Object.c_buqty[1]
	 
	If ld_bulqty < ld_sum_bulqty Then
		MessageBox('확인','등록한 불량수량은 입고수량보다 많습니다.') 
		Return 1
	End If
	 	 
END IF
end event

type rr_2 from roundrectangle within w_qa01_00021
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 464
integer width = 2999
integer height = 1012
integer cornerheight = 40
integer cornerwidth = 55
end type

