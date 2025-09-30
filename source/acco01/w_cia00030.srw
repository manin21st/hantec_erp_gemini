$PBExportHeader$w_cia00030.srw
$PBExportComments$기초재공재고 등록(공정수불)
forward
global type w_cia00030 from w_inherite
end type
type dw_1 from datawindow within w_cia00030
end type
type dw_2 from u_d_select_sort within w_cia00030
end type
type dw_cond from u_key_enter within w_cia00030
end type
type rr_2 from roundrectangle within w_cia00030
end type
type rr_3 from roundrectangle within w_cia00030
end type
end forward

global type w_cia00030 from w_inherite
string title = "기초재공재고등록"
dw_1 dw_1
dw_2 dw_2
dw_cond dw_cond
rr_2 rr_2
rr_3 rr_3
end type
global w_cia00030 w_cia00030

forward prototypes
public function integer wf_warndataloss (string as_titletext)
public function integer wf_reqchk (integer curr_row)
end prototypes

public function integer wf_warndataloss (string as_titletext);/*=============================================================================================
		 1. window-level user function : 종료, 등록시 호출됨
		    dw_detail 의 typing(datawindow) 변경사항 검사

		 2. 계속진행할 경우 변경사항이 저장되지 않음을 경고                                                               

		 3. Argument:  as_titletext (warning messagebox)                                                                          
		    Return values:                                                   
                                                                  
      	*  1 : 변경사항을 저장하지 않고 계속 진행할 경우.
			* -1 : 진행을 중단할 경우.                      
=============================================================================================*/

IF ib_any_typing = true THEN  				// EditChanged event(dw_detail)의 typing 상태확인

	Beep(1)
	IF MessageBox("확인 : " + as_titletext , &
		 "저장하지 않은 값이 있습니다. ~r변경사항을 저장하시겠습니까", &
		 question!, yesno!) = 1 THEN

		dw_2.SetFocus()						// yes 일 경우: focus 'dw_detail' 
		RETURN -1									

	END IF

END IF
																
RETURN 1												// (dw_detail) 에 변경사항이 없거나 no일 경우
														// 변경사항을 저장하지 않고 계속진행 


end function

public function integer wf_reqchk (integer curr_row);String sItnbr,sNo,sOpseq,sRoslt

dw_1.AcceptText()

sItnbr = dw_1.GetItemString(curr_row,"itnbr")  /*품번*/
sNo    = dw_1.GetItemString(curr_row,"pordno") /*작업지시번호*/
sOpseq = dw_1.GetItemString(curr_row,"opseq") /*공정순서*/
sRoslt = dw_1.GetItemString(curr_row,"roslt") /*공정코드*/

IF sItnbr = '' OR ISNULL(sItnbr) THEN
	f_messagechk(1,'[품번]')
	dw_1.SetColumn("itnbr")
	dw_1.SetFocus()
	Return -1
END IF
IF sNo = '' OR ISNULL(sNo) THEN
	f_messagechk(1,'[작업지시번호]')
	dw_1.SetColumn("pordno")
	dw_1.SetFocus()
	Return -1
END IF
IF sOpseq = '' OR ISNULL(sOpseq) THEN
	f_messagechk(1,'[공정순서]')
	dw_1.SetColumn("opseq")
	dw_1.SetFocus()
	Return -1
END IF
IF sRoslt = '' OR ISNULL(sRoslt) THEN
	f_messagechk(1,'[공정코드]')
	dw_1.SetColumn("roslt")
	dw_1.SetFocus()
	Return -1
END IF


Return  1


end function

on w_cia00030.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_cond=create dw_cond
this.rr_2=create rr_2
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_cond
this.Control[iCurrent+4]=this.rr_2
this.Control[iCurrent+5]=this.rr_3
end on

on w_cia00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_cond)
destroy(this.rr_2)
destroy(this.rr_3)
end on

event open;call super::open;String sYm

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_cond.SetTransObject(sqlca)

dw_cond.Reset()
dw_cond.InsertRow(0)

dw_cond.SetItem(1,"io_yymm", Left(F_Today(),6))
dw_cond.SetItem(1,"to_yymm", Left(F_Today(),6))

//dw_2.Retrieve(Left(F_Today(),6))
end event

type dw_insert from w_inherite`dw_insert within w_cia00030
boolean visible = false
integer x = 123
integer y = 2652
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_cia00030
integer x = 3922
integer y = 0
integer taborder = 60
end type

event p_delrow::clicked;call super::clicked;
IF F_DbConFirm('삭제') = 2 THEN RETURN

dw_1.DeleteRow(dw_1.GetRow())

IF dw_1.Update() = 1 THEN
	commit;
	ib_any_typing = False
	w_mdi_frame.sle_msg.text ="자료가 삭제되었습니다.!!!"
	dw_2.Retrieve(dw_cond.GetItemString(1,"io_yymm"),dw_cond.GetItemString(1,"saupgubn"))
	dw_1.SetColumn("itnbr")
   dw_1.SetFocus()
ELSE
	ROLLBACK;
	f_messagechk(12,'')
END IF

end event

type p_addrow from w_inherite`p_addrow within w_cia00030
integer x = 3749
integer y = 0
integer taborder = 40
end type

event p_addrow::clicked;call super::clicked;Long sTotalRow
Long wfReturn

sTotalRow = dw_1.RowCount()
IF sTotalRow = 0 THEN
	sTotalRow = 1
   wfReturn = 1
ELSE
   sTotalRow = sTotalRow + 1 
	wfReturn  = wf_reqchk(dw_1.GetRow())
END IF	

IF wfReturn = -1 THEN
	Return 
END IF

dw_1.InsertRow(sTotalRow)
dw_1.ScrollToRow(sTotalRow)

dw_1.SetItem(sTotalRow,"flag",  '1')
dw_1.SetItem(sTotalRow,"cia22t_pdtgu", dw_cond.GetItemString(1,"saupgubn"))
dw_1.SetColumn("itnbr")
dw_1.SetFocus()
end event

type p_search from w_inherite`p_search within w_cia00030
boolean visible = false
integer x = 3003
integer y = 3216
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_cia00030
boolean visible = false
integer x = 3525
integer y = 3216
integer taborder = 0
string pointer = "C:\erpman\cur\new.cur"
end type

type p_exit from w_inherite`p_exit within w_cia00030
integer y = 0
integer taborder = 100
end type

type p_can from w_inherite`p_can within w_cia00030
integer y = 0
integer taborder = 90
end type

event p_can::clicked;call super::clicked;
dw_1.Reset()
dw_2.Retrieve(dw_cond.GetItemString(1,"io_yymm"),dw_cond.GetItemString(1,"to_yymm"),dw_cond.GetItemString(1,"saupgubn"))

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"
p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\저장_up.gif"

ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_cia00030
boolean visible = false
integer x = 3177
integer y = 3216
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_cia00030
integer x = 3575
integer y = 0
end type

event p_inq::clicked;call super::clicked;String sYm,sPdtgu,sYmt

dw_cond.AcceptText()
sYm    = dw_cond.GetItemString(1,"io_yymm")
sYmt   = dw_cond.GetItemString(1,"to_yymm")
sPdtgu = dw_cond.GetItemString(1,"saupgubn")

dw_1.Reset()
if dw_2.Retrieve(sYm,sYmt,sPdtGu) <= 0  then
	f_messagechk(14,"") 
	dw_cond.SetFocus()
end if

end event

type p_del from w_inherite`p_del within w_cia00030
boolean visible = false
integer x = 4219
integer y = 3216
integer taborder = 80
end type

type p_mod from w_inherite`p_mod within w_cia00030
integer x = 4096
integer y = 0
integer taborder = 70
end type

event p_mod::clicked;call super::clicked;String  sYm,sPdtGu,sYmt
Long    ll_Row,K,sZero

IF F_DbConFirm('저장') = 2  THEN RETURN

sYm    = dw_cond.GetItemString(1,"io_yymm")
sYmt   = dw_cond.GetItemString(1,"to_yymm")
sPdtgu = dw_cond.GetItemString(1,"saupgubn")

IF sYm = '' OR ISNULL(sYm) THEN
	f_messagechk(1,'[년월]')
	dw_cond.SetFocus()
	Return 
END IF	
IF sPdtgu = '' OR ISNULL(sPdtgu) THEN
	f_messagechk(1,'[생산팀]')
	dw_cond.SetFocus()
	Return 
END IF

ll_Row = dw_1.RowCount()
IF ll_Row = 0 THEN RETURN

FOR K = 1  TO  ll_Row
	 dw_1.SetITem(K,"cia22t_io_yymm", sYm)
	 dw_1.SetITem(K,"cia22t_io_yymmt",sYmt)
	 dw_1.SetITem(K,"cia22t_pdtgu",   sPdtGu)
NEXT	

IF wf_reqchk(dw_1.GetRow()) = -1 THEN
	Return 
END IF	

IF dw_1.Update() <> 1	THEN
	ROLLBACK;
	f_messagechk(13,'')
	Return 
END IF
Commit;

w_mdi_frame.sle_msg.text = '자료를 저장하였습니다!!'
ib_any_typing = False
dw_1.Reset()
dw_1.SelectRow(0,False)
dw_2.Retrieve(sYm,sPdtGu)

end event

type cb_exit from w_inherite`cb_exit within w_cia00030
integer x = 3237
integer y = 2776
end type

type cb_mod from w_inherite`cb_mod within w_cia00030
integer x = 2542
integer y = 2776
end type

type cb_ins from w_inherite`cb_ins within w_cia00030
integer x = 1774
integer y = 2776
integer width = 370
string text = "행추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_cia00030
integer x = 2158
integer y = 2776
integer width = 370
string text = "행삭제(&D)"
end type

type cb_inq from w_inherite`cb_inq within w_cia00030
integer x = 165
integer y = 2776
end type

type cb_print from w_inherite`cb_print within w_cia00030
integer y = 2636
end type

type st_1 from w_inherite`st_1 within w_cia00030
end type

type cb_can from w_inherite`cb_can within w_cia00030
integer x = 2889
integer y = 2776
end type

type cb_search from w_inherite`cb_search within w_cia00030
integer y = 2636
end type

type dw_datetime from w_inherite`dw_datetime within w_cia00030
integer x = 2871
end type

type sle_msg from w_inherite`sle_msg within w_cia00030
integer width = 2487
end type



type gb_button1 from w_inherite`gb_button1 within w_cia00030
integer x = 128
integer y = 2720
integer width = 407
end type

type gb_button2 from w_inherite`gb_button2 within w_cia00030
integer x = 1742
integer y = 2720
integer width = 1865
end type

type dw_1 from datawindow within w_cia00030
event ue_enter pbm_dwnprocessenter
integer x = 64
integer y = 156
integer width = 4521
integer height = 1128
integer taborder = 50
boolean bringtotop = true
string dataobject = "dw_cia00030_2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_enter;Send(Handle(This),256,9,0)
Return 1
end event

event itemerror;Return 1
end event

event rbuttondown;String l_pordno,sYm

SetNull(gs_code)
SetNull(gs_codename)


if This.GetColumnName() = "itnbr" then //품번
	open(w_itemas_popup)
	
	if gs_code = '' or isnull(gs_code) then return
	this.SetITem(Row,"itnbr",gs_code)
	this.SetITem(Row,"itemas_itdsc",gs_codename)
	
	SELECT "CIA22T"."PORDNO"  /*작업지시번호*/
    	INTO :l_pordno  
       	FROM "CIA22T"
		WHERE "CIA22T"."IO_YYMM" =:sYm AND
        	  "CIA22T"."ITNBR"=:gs_code ;  

	dw_1.Retrieve(dw_cond.GetItemString(1,"io_yymm"),gs_code,l_pordno)	
end if

end event

event itemchanged;String sItnbr,sName,snull,sRoslt,sYm
Int sCnt
String sPordno,sOpseq

this.AcceptText()
SetNull(snull)

sYm = dw_cond.GetItemString(1,"io_yymm")

p_ins.Enabled = True
p_ins.PictureName = "C:\erpman\image\추가_up.gif"
p_mod.Enabled = True
p_mod.PictureName = "C:\erpman\image\저장_up.gif"


IF THIS.GetColumnName() = "itnbr" THEN
   sItnbr = this.GetItemString(dw_1.GetRow(),"itnbr")
	IF sItnbr = '' OR ISNULL(sItnbr) THEN RETURN
	
	SELECT "ITEMAS"."ITDSC"  		 INTO :sName  
		FROM "ITEMAS"  
		WHERE "ITEMAS"."ITNBR" = :sItnbr   ;
		
	IF SQLCA.SQLCODE = 0 THEN
		this.SetITem(Row,"itemas_itdsc",sName)
	ELSE
		f_messagechk(20,'[품번]')
		this.SetItem(Row,"itnbr",snull)
		this.SetItem(Row,"itemas_itdsc",snull)
		Return 1
	END IF	
END IF	  

IF this.GetColumnName() = "roslt" THEN
	sRoslt = this.GetText()
	IF sRoslt = '' OR ISNULL(sRoslt) THEN RETURN 
	
	SELECT COUNT("REFFPF"."RFCOD")        INTO :sCnt  
		FROM "REFFPF"  
      WHERE ( "REFFPF"."RFCOD" = '21' ) AND  ( "REFFPF"."RFGUB" = :sRoslt )   ;
	IF sCnt = 0 THEN
		f_messagechk(20,'[공정코드]') 
		this.SetITem(Row,"roslt",snull)
		Return 1
	END IF	
	
   sItnbr  = this.GetItemString(Row,"itnbr")  
	sPordno = this.GetItemString(Row,"pordno")   
	sOpseq = this.GetItemString(Row,"opseq")   
   sCnt = 0
	
	SELECT count("CIA22T"."ITNBR")   INTO :sCnt
		FROM "CIA22T"  
     	WHERE ( "CIA22T"."IO_YYMM" =:sYm ) AND      ( "CIA22T"."ITNBR"   =:sItnbr ) AND  
            ( "CIA22T"."PORDNO"  =:sPordno ) AND  ( "CIA22T"."OPSEQ"   =:sOpseq ) AND
				( "CIA22T"."ROSLT"   =:sRoslt ) ;
	IF sCnt <> 0  THEN
		f_messagechk(10,'')
		this.SetItem(Row,"roslt",snull)
		p_ins.Enabled = False
		p_ins.PictureName = "C:\erpman\image\추가_d.gif"
		p_mod.Enabled = False
		p_mod.PictureName = "C:\erpman\image\저장_d.gif"
		Return 1
	END IF
	
	Long lReturnRow,lRow
	  
	lReturnRow = this.find("itnbr = '" + sItnbr + "' and pordno ='" + sPordno +"' and opseq ='" + sOpseq +"'  and roslt ='" + sRoslt +"'",1,this.rowcount())
	
	IF (Row <> lReturnRow) and (lReturnRow <> 0) then 
		messagebox("확 인","입력하신 코드로 이미 자료가 저장되어 있습니다!!")
	   THIS.SetItem(Row, "roslt", snull)
	   Return 1
	END IF
END IF	

this.SetItem(this.GetRow(),"cia22t_wp_qty", this.GetItemNumber(this.GetRow(),"iwol_qty"))
this.SetItem(this.GetRow(),"cia22t_wp_mat", this.GetItemNumber(this.GetRow(),"iwol_mat"))
this.SetItem(this.GetRow(),"cia22t_wp_lab", this.GetItemNumber(this.GetRow(),"iwol_lab"))
this.SetItem(this.GetRow(),"cia22t_wp_over", this.GetItemNumber(this.GetRow(),"iwol_over"))
	  
	
 
  
  
  
  
end event

event editchanged;ib_any_typing = True
end event

type dw_2 from u_d_select_sort within w_cia00030
integer x = 64
integer y = 1324
integer width = 3264
integer height = 896
integer taborder = 30
string dataobject = "dw_cia00030_1"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;String sItnbr,sYm,sPordNo,sYmt

int  li_loc, li_i
String ls_raised = '6' , ls_lowered = '5' 
string ls_dwobject, ls_dwobject_name
String ls_modify, ls_rc, ls_col_no

SetPointer(HourGlass!)

IF row <= 0 THEN 
	ls_dwobject = GetObjectAtPointer()
	li_loc = Pos(ls_dwobject, '~t')
	
	If li_loc = 0 Then Return
	
	ls_dwobject_name = Left(ls_dwobject, li_loc - 1)
		
	IF b_flag =False THEN 
		b_flag =True
		RETURN
	END IF 
	
	If ls_dwobject_name = 'type'  Then
		If Describe(ls_dwobject_name + ".border") = ls_lowered Then
			ls_modify = ls_dwobject_name + ".border=" + ls_raised
			ls_modify = ls_modify + " " + ls_dwobject_name + &
			 ".text=" + "'오름차순'"
		Else
			ls_modify = ls_dwobject_name + ".border=" + ls_lowered
			ls_modify = ls_modify + " " + ls_dwobject_name + &
			 ".text=" + "'내림차순'"
		End If
	
		ls_rc = Modify(ls_modify)
		If ls_rc <> "" Then
			//MessageBox("dwModify", ls_rc + " : " + ls_modify)
			Return
		End If
		//uf_sort(is_old_dwobject_name)
		Return
	End If
	
	If is_old_dwobject_name <> ls_dwobject_name Then 
		If uf_sort(ls_dwobject_name) = -1 Then Return
		If is_old_dwobject_name = "" Then
			ls_col_no = String(Describe("datawindow.column.count"))
			For li_i = 1 To Integer(ls_col_no)
				If Describe("#" + ls_col_no + ".border") = ls_lowered Then
					is_old_dwobject_name = Describe("#" + ls_col_no + &
					 + ".name") + "_t"
					is_old_color = Describe(is_old_dwobject_name + ".color")
					Exit
				End If
			Next
		End If
		If is_old_dwobject_name <> "" Then
			ls_modify = is_old_dwobject_name + ".border=" + ls_raised
			ls_modify = ls_modify + " " + &
			 is_old_dwobject_name + ".color=" + is_old_color
			ls_rc = Modify(ls_modify)
			If ls_rc <> "" Then
				//MessageBox("dwModify", ls_rc + " : " + ls_modify)
				Return
			End If
		End If
		is_old_color = Describe(ls_dwobject_name + ".color")
		ls_modify = ls_dwobject_name + ".border=" + ls_lowered
		ls_modify = ls_modify + " " + &
		 ls_dwobject_name + ".color=" + String(RGB(0, 0, 128))
		ls_rc = Modify(ls_modify)
		If ls_rc <> "" Then
			//MessageBox("Modify", ls_rc + " : " + ls_modify)
			Return
		End If
	
		is_old_dwobject_name = ls_dwobject_name
	End If

ELSE
	IF Keydown(KeyShift!) THEN
		ufi_shift_highlight(ROW)
	
	ELSEIF this.IsSelected(ROW) THEN
		il_lastclickedrow = ROW
		ib_action_on_buttonup = TRUE
	ELSEIF Keydown(KeyControl!) THEN
		il_lastclickedrow = ROW
		this.SelectRow(ROW, TRUE)
	ELSE
		il_lastclickedrow = ROW
		this.SelectRow(0, FALSE)
		this.SelectRow(ROW, TRUE)
	END IF 
END IF

this.AcceptText()

sYm     = dw_cond.GetItemString(1,"io_yymm")           /*년월*/
sYmt    = dw_cond.GetItemString(1,"to_yymm")           /*년월*/
sItnbr  = this.GetItemString(dw_2.GetClickedRow(),"cia22t_itnbr")  /*품번*/
sPordNo = this.GetItemString(dw_2.GetClickedRow(),"cia22t_pordno") /*작업지시번호*/
			
IF sItnbr = '' OR ISNULL(sItnbr) THEN
	Return 
END IF	

dw_1.Retrieve(sYm,sYmt,dw_cond.GetItemString(1,"saupgubn"),sItnbr,sPordNo)
dw_1.SetColumn("iwol_qty")
dw_1.SetFocus()

end event

type dw_cond from u_key_enter within w_cia00030
integer x = 50
integer y = 4
integer width = 2130
integer height = 140
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_cia00030_0"
boolean border = false
end type

type rr_2 from roundrectangle within w_cia00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 152
integer width = 4553
integer height = 1160
integer cornerheight = 40
integer cornerwidth = 46
end type

type rr_3 from roundrectangle within w_cia00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 1320
integer width = 3301
integer height = 908
integer cornerheight = 40
integer cornerwidth = 46
end type

