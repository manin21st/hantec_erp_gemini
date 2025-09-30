$PBExportHeader$w_mat_03010.srw
$PBExportComments$** 주기 실사 등록
forward
global type w_mat_03010 from w_inherite
end type
type dw_1 from datawindow within w_mat_03010
end type
type pb_1 from u_pb_cal within w_mat_03010
end type
type pb_2 from u_pb_cal within w_mat_03010
end type
type pb_3 from u_pb_cal within w_mat_03010
end type
type pb_4 from u_pb_cal within w_mat_03010
end type
type cb_1 from commandbutton within w_mat_03010
end type
type cb_2 from commandbutton within w_mat_03010
end type
type pb_5 from picturebutton within w_mat_03010
end type
type gb_1 from groupbox within w_mat_03010
end type
type rr_1 from roundrectangle within w_mat_03010
end type
type cb_3 from commandbutton within w_mat_03010
end type
end forward

global type w_mat_03010 from w_inherite
string title = "주기 실사 등록"
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
pb_4 pb_4
cb_1 cb_1
cb_2 cb_2
pb_5 pb_5
gb_1 gb_1
rr_1 rr_1
cb_3 cb_3
end type
global w_mat_03010 w_mat_03010

type variables

end variables

forward prototypes
public subroutine wf_set ()
public subroutine wf_check (string arg_date, string arg_depot, integer seq)
public function integer wf_required_chk (integer i)
public subroutine wf_excel_down (datawindow adw_excel)
public subroutine wf_sijqty ()
end prototypes

public subroutine wf_set ();string s_sicdate, s_depot, s_sisdate, s_siedate, s_wandate, s_cycsts, snull, sittyp
int     inull
String	ls_dept

setnull(snull)

dw_1.setredraw(false)
dw_1.reset()
dw_1.insertrow(0)

dw_1.setitem(1, 'depot', snull)
dw_1.setitem(1, 'ittyp', snull)
dw_1.setitem(1, 'seq',  inull)
dw_1.setitem(1, 'cr_date', snull)
dw_1.setitem(1, 'fr_date', snull)
dw_1.setitem(1, 'to_date', snull)
dw_1.setitem(1, 'wan_date', snull)
dw_1.setitem(1, 'cycsts', snull)

p_print.enabled 		= False
p_search.enabled 	= False
p_addrow	.visible	= False
p_delrow	.visible	= False
//----------- 실사등록처리시 추가가능부서 확인하여 [행추가] 여부확인.
isNull(ls_dept)
select dataname
  into :ls_dept
  from syscnfg
 where sysgu = 'Y' and serial = 40 and lineno = '1';
If	ls_dept	= gs_dept		then
	p_addrow	.visible	= True
	p_delrow	.visible	= True
End If	
dw_1.setredraw(True)

end subroutine

public subroutine wf_check (string arg_date, string arg_depot, integer seq);string s_sisdate, s_siedate, s_wandate, s_cycsts, snull, get_date, s_gub, s_plant

setnull(snull)

SELECT "ITMCYC"."SISDAT", "ITMCYC"."SIEDAT", "ITMCYC"."CYCSTS", "ITMCYC"."WANDAT", 
		 "ITMCYC"."JEGO_GUB",  "ITMCYC"."LOTSNO"   
  INTO :s_sisdate,        :s_siedate,        :s_cycsts,          :s_wandate, 
		 :s_gub ,				:s_plant
  FROM "ITMCYC"  
 WHERE ( "ITMCYC"."SABU"   = :gs_sabu ) AND  
		 ( "ITMCYC"."DEPOT"  = :arg_depot ) AND  
		 ( "ITMCYC"."SICDAT" = :arg_date ) AND  
		 ( "ITMCYC"."SISEQ"  = :seq ) AND ROWNUM = 1  ;
									
IF SQLCA.SQLCODE = 0 THEN 
	dw_1.setitem(1, 'cr_date', arg_date)
	dw_1.setitem(1, 'fr_date', s_sisdate)
	dw_1.setitem(1, 'to_date', s_siedate)
	dw_1.setitem(1, 'wan_date', s_wandate)
	dw_1.setitem(1, 'cycsts', s_cycsts)
	dw_1.setitem(1, 'jego_gub', s_gub)
	dw_1.setitem(1, 'plant', s_plant)
	if s_cycsts = '1' then //상태가 생성이면
		p_print.enabled = true
		p_search.enabled = false
	else
		p_print.enabled = False
		p_search.enabled = True
	end if   
ELSE
	dw_1.setitem(1, 'fr_date', snull)
	dw_1.setitem(1, 'to_date', snull)
	dw_1.setitem(1, 'wan_date', snull)
	dw_1.setitem(1, 'cycsts', snull)
	dw_1.setitem(1, 'plant', snull)
	p_print.enabled = False
	p_search.enabled = False
END IF



end subroutine

public function integer wf_required_chk (integer i);//if dw_insert.AcceptText() = -1 then return -1
//
//if isnull(dw_insert.GetItemNumber(i,'sijqty')) then
//	f_message_chk(1400,'[ '+string(i)+' 행 실사수량]')
//	dw_insert.ScrollToRow(i)
//	dw_insert.SetColumn('sijqty')
//	dw_insert.SetFocus()
//	return -1		
//end if	
//
return 1
end function

public subroutine wf_excel_down (datawindow adw_excel);String	ls_quota_no
integer	li_rc
string	ls_filepath, ls_filename
boolean	lb_fileexist

li_rc = GetFileSaveName("저장할 파일명을 선택하세요." , ls_filepath , &
											  ls_filename , "XLS" , "Excel Files (*.xls),*.xls")												
IF li_rc = 1 THEN
	IF lb_fileexist THEN
		li_rc = MessageBox("파일저장" , ls_filepath + " 파일이 이미 존재합니다.~r~n" + &
												 "기존의 파일을 덮어쓰시겠습니까?" , Question! , YesNo! , 1)
		IF li_rc = 2 THEN 
			w_mdi_frame.sle_msg.text = "자료다운취소!!!"			
			RETURN
		END IF
	END IF
	
	Setpointer(HourGlass!)
	
 	If adw_excel.SaveAsAscii(ls_filepath) <> 1 Then
		w_mdi_frame.sle_msg.text = "자료다운실패!!!"
		return
	End If

END IF

w_mdi_frame.sle_msg.text = "자료다운완료!!!"
end subroutine

public subroutine wf_sijqty ();Decimal dgap, dqty

Long   i
For i = 1 To dw_insert.RowCount()
		
	dgap = dw_insert.getitemdecimal(i, 'dgap')
	
	String siogbn
	if 	dgap <> 0 then 
		IF dgap > 0 then
			siogbn    = 'I14'
		ELSE	
			siogbn    = 'O08'
		END IF	
		
		if isnull(dw_insert.getitemstring(i, 'bigo')) or &
			trim(dw_insert.getitemstring(i, 'bigo')) = '' then
			dw_insert.setitem(i, 'bigo', '병행가동 재고실사')
		end if
		dw_insert.setitem(i, 'crtgub', 'Y')
		dw_insert.setitem(i, 'scheck', 'Y')
		dw_insert.setitem(i, 'iogbn', siogbn)
	end if
	
Next
end subroutine

on w_mat_03010.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.pb_4=create pb_4
this.cb_1=create cb_1
this.cb_2=create cb_2
this.pb_5=create pb_5
this.gb_1=create gb_1
this.rr_1=create rr_1
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.pb_4
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.pb_5
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.rr_1
this.Control[iCurrent+11]=this.cb_3
end on

on w_mat_03010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.pb_4)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.pb_5)
destroy(this.gb_1)
destroy(this.rr_1)
destroy(this.cb_3)
end on

event open;call super::open;
dw_insert.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

String is_ispec, is_jijil
IF f_change_name('1') = 'Y' then 
	is_ispec = f_change_name('2')
	is_jijil = f_change_name('3')
	dw_insert.object.ispec_t.text = is_ispec
	dw_insert.object.jijil_t.text = is_jijil
END IF

//입고창고 
f_child_saupj(dw_1, 'depot', gs_saupj)

wf_set()


end event

event key;// Page Up & Page Down & Home & End Key 사용 정의
choose case key
	case keypageup!
		dw_insert.scrollpriorpage()
	case keypagedown!
		dw_insert.scrollnextpage()
	case keyhome!
		dw_insert.scrolltorow(1)
	case keyend!
		dw_insert.scrolltorow(dw_insert.rowcount())
	case KeyupArrow!
		dw_insert.scrollpriorrow()
	case KeyDownArrow!
		dw_insert.scrollnextrow()		
//	Case KeyW!
//		p_print.TriggerEvent(Clicked!)
	Case KeyQ!
		p_inq.TriggerEvent(Clicked!)
//	Case KeyT!
//		p_ins.TriggerEvent(Clicked!)
	Case KeyA!
		p_addrow.TriggerEvent(Clicked!)
	Case KeyE!
		p_delrow.TriggerEvent(Clicked!)
	Case KeyS!
		p_mod.TriggerEvent(Clicked!)
//	Case KeyD!
//		p_del.TriggerEvent(Clicked!)
	Case KeyC!
		p_can.TriggerEvent(Clicked!)
	Case KeyX!
		p_exit.TriggerEvent(Clicked!)
End Choose
end event

type dw_insert from w_inherite`dw_insert within w_mat_03010
integer x = 69
integer y = 456
integer width = 4526
integer height = 1840
integer taborder = 30
string dataobject = "d_mat_03010_1"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::ue_pressenter;Send(Handle(this),256,9,0)
Return 1

end event

event dw_insert::itemerror;return 1
end event

event dw_insert::itemchanged;decimal{3}  dgap, dqty
string   snull, siogbn, ls_itnbr, ls_ittyp, ls_chk, ls_f_ymd, ls_t_ymd, ls_cycsts, ls_jego_gu
String   sItdsc, sIspec, sIttyp, sItcls, sJijil, sIspeccode
long     lrow, ireturn, lCnt, ll_cunqty
integer	ix
str_itmcyc istr_itmcyc

dw_1.accepttext()
ls_f_ymd   = dw_1.GetItemString(1, "fr_date" )
ls_t_ymd   = dw_1.GetItemString(1, "to_date" )
ls_cycsts  = dw_1.GetItemString(1, "cycsts"  )
ls_jego_gu = dw_1.GetItemString(1, "jego_gub")

setnull(snull)

lrow = this.getrow()
this.accepttext()

Choose Case GetColumnName() 
	Case	"sijqty" 
		dgap 	= this.getitemdecimal(lrow, 'dgap')
		dqty 	= this.getitemdecimal(lrow, 'itmcyc_cujqty')
	
		if 	dgap <> 0 then 
			IF dgap > 0 then
				siogbn    = 'I14'
				gs_gubun  = siogbn
			ELSE	
				siogbn    = 'O08'
				gs_gubun  = siogbn
			END IF	

			istr_itmcyc.depot  	= dw_insert.getitemstring(lrow, 'itmcyc_depot')
			istr_itmcyc.sicdat 	= dw_insert.getitemstring(lrow, 'itmcyc_sicdat')
			istr_itmcyc.siseq  	= dw_insert.getitemnumber(lrow, 'itmcyc_siseq')
			istr_itmcyc.itnbr  	= dw_insert.getitemstring(lrow, 'itmcyc_itnbr')
			istr_itmcyc.pspec  	= dw_insert.getitemstring(lrow, 'itmcyc_pspec')
			ls_chk               = dw_insert.getitemstring(lrow, 'chk')
			ll_cunqty            = dw_insert.getitemnumber(lrow, 'stock_jego_qty')
			
			
			if ls_chk = 'N' then /* 행 추가면 먼저 ITMCYC에 Insert후 Window Open */
			   insert into itmcyc(sabu, depot, sicdat, siseq, sisdat, siedat, cycsts, itnbr, pspec, cujqty,
				                   sijqty, cycilsu, lascyc, wandat, bigo, crtgub, iogbn, iojpno, scheck, jego_gub)
										 
						 Values    (:gs_sabu, :istr_itmcyc.depot, :istr_itmcyc.sicdat, :istr_itmcyc.siseq, :ls_f_ymd,
						            :ls_t_ymd, :ls_cycsts, :istr_itmcyc.itnbr, :istr_itmcyc.pspec, :ll_cunqty, 0,
										null,	null, null, null, null, null, null, null, :ls_jego_gu)
						 Using sqlca;		
						 commit using sqlca;
			end if
				

//			this.setitem(lrow, 'bigo', '병행가동 재고실사')
			this.setitem(lrow, 'crtgub', 'Y')
			this.setitem(lrow, 'scheck', 'Y')
			this.setitem(lrow, 'iogbn', siogbn)
		end if

//			OpenWithParm(w_mat_03010_popup, istr_itmcyc)			
//			if gs_gubun = 'Y' then 
//				this.setitem(lrow, 'bigo', gs_code)
//				this.setitem(lrow, 'crtgub', gs_codename)
//				if 	gs_codename = 'Y' then 
//					this.setitem(lrow, 'iogbn', siogbn)
//				else
//					this.setitem(lrow, 'iogbn', snull)
//					this.setitem(lrow, 'sijqty', dqty)
//					return 1
//				end if
//			else
//				if ls_chk = 'N' then /* POPUP의 return(gs_gubun)값이 'N' 이고, 행추가(ls_chk='N')인경우 */
//					delete from itmcyc
//					      where sabu   = :gs_sabu
//							  and depot  = :istr_itmcyc.depot
//							  and sicdat = :istr_itmcyc.sicdat
//							  and siseq  = :istr_itmcyc.siseq
//							  and itnbr  = :istr_itmcyc.itnbr
//							  and pspec  = :istr_itmcyc.pspec
//							using sqlca;
//							commit using sqlca;
//				end if
//				this.setitem(lrow, 'sijqty', dqty)
//				return 1
//			end if	
//		else
//			this.setitem(lrow, 'bigo', snull)
//			this.setitem(lrow, 'crtgub', 'N')
//			this.setitem(lrow, 'iogbn', snull)
//		end if
		
		
	Case	"itmcyc_itnbr"
		ls_Itnbr = trim(GetText())
		// --- 기존입력되어있는 품번에 동일값이 존재하는지 여부 확인.
           For	ix = 1 to this.rowCount() -1
				if	ls_itnbr = this.GetItemString(ix, "itmcyc_itnbr") 	then
					MessageBox("품번", "동일품번이 존재를 하오니 확인바랍니다 ! ")
					//this.SetItem(ix, "itmcyc_itnbr", '')
					Return -1
				End if
	  	Next
		ireturn = f_get_name4_sale('품번', 'N', ls_Itnbr, sitdsc, sispec, sjijil, sispeccode)	
		setitem(lRow, "itmcyc_itnbr", ls_Itnbr)	
		setitem(lRow, "itemas_itdsc", sitdsc)	
		setitem(lRow, "itemas_ispec", sispec)
//		setitem(lRow, "ispec_code", sispeccode)
		setitem(lRow, "itemas_jijil", sjijil)
//		//품목구분확인하여 사양에 입력. -- 1:완제품, 2:반제품, 7:상품
//		SetNull(ls_ittyp)
//		Select 	ittyp  into :ls_ittyp    from itemas
//		  where    itnbr = :ls_itnbr;
//  		IF	(ls_ittyp = '1' or ls_ittyp = '2' or ls_ittyp = '7' ) and gs_saupj ='10' then
//			setitem(lRow, "itmcyc_pspec", 'OEM')
//		End If
End Choose

end event

event dw_insert::losefocus;this.accepttext()
end event

event dw_insert::clicked;call super::clicked;int  li_loc, li_i
String ls_raised = '6' , ls_lowered = '5' 
string ls_dwobject, ls_dwobject_name
String ls_modify, ls_rc, ls_col_no, ls_setsort

SetPointer(HourGlass!)

IF row <= 0 THEN 
	ls_dwobject = GetObjectAtPointer()
	li_loc = Pos(ls_dwobject, '~t')
	
	If li_loc = 0 Then Return
	
	ls_dwobject_name = Left(ls_dwobject, li_loc - 1)
		
	//유 상웅 추가(99.04) 헤드에 _t가 없으면 바로 RETURN  
	if '_t' = Right(ls_dwobject_name, 2) then 
		ls_setsort = Left(ls_dwobject_name, Len(ls_dwobject_name) - 2)
		ls_setsort = ls_setsort + ", itmcyc_itnbr"
		If this.SetSort(ls_setsort) = -1 Then
		//	MessageBox("SetSort()", "Parameter : '" + ls_setsort + "'")
			Return -1
		End If
		this.Sort()	
	Else
		return 0
	End If

End If

this.setrow(row)
this.trigger event rowfocuschanged(row)

end event

event dw_insert::rbuttondown;call super::rbuttondown;
Long   nRow

SetNull(Gs_Code)
SetNull(Gs_Gubun)
SetNull(Gs_CodeName)

nRow = GetRow()
If nRow <= 0 Then Return

Choose Case GetColumnName() 
	/* 거래처 */
	Case "itmcyc_itnbr"
		gs_gubun = '1'
		Open(w_itemas_popup)
		IF gs_code = "" OR IsNull(gs_code) THEN RETURN
		
		SetItem(nRow,"itmcyc_itnbr",gs_code)
		PostEvent(ItemChanged!)	 
END Choose

ib_any_typing = True
end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;this.SelectRow(0, FALSE)
if currentrow > 0 then
	this.SelectRow(currentrow, TRUE)
else
	return
end if

end event

type p_delrow from w_inherite`p_delrow within w_mat_03010
boolean visible = false
integer x = 3502
integer y = 292
integer taborder = 0
end type

event p_delrow::clicked;call super::clicked;String	ls_chk
long	lRow

dw_insert.AcceptText()

lRow	=	dw_insert.GetRow()

IF 	dw_insert.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

ls_chk	=	dw_insert.GetItemString(lRow, "chk")
if	ls_chk	 = 'Y'	then
  	f_message_chk(31,'[신규추가 품번]')
	Return	
End If

dw_insert.DeleteRow(0)

dw_insert.ScrollToRow(dw_insert.RowCount())
dw_insert.Setfocus()

end event

type p_addrow from w_inherite`p_addrow within w_mat_03010
boolean visible = false
integer x = 3323
integer y = 292
integer taborder = 0
end type

event p_addrow::clicked;call super::clicked;
Int    	il_currow,il_RowCount, d_siseq
string	ls_depot, ls_sicdat, ls_frdat, ls_todat, ls_sts, ls_jegogb

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

il_currow 	= il_rowCount + 1

ls_depot	 = dw_1.GetItemString(1,"depot") //창고
ls_sicdat = dw_1.GetItemString(1,"cr_date") //실사생성일
d_siseq	 = dw_1.GetItemNumber(1,"seq") //실사차수
ls_frdat  = dw_1.GetItemString(1,"fr_date") //실사기간
ls_todat  = dw_1.GetItemString(1,"to_date") //실사기간
ls_sts    = dw_1.GetItemString(1,"cycsts") //상태
ls_jegogb = dw_1.GetItemString(1,"jego_gub") //재고구분

dw_insert.InsertRow(il_currow)

dw_insert.SetItem(il_currow, "itmcyc_sabu", gs_sabu)
dw_insert.SetItem(il_currow, "itmcyc_depot", ls_depot)
dw_insert.SetItem(il_currow, "itmcyc_sicdat", ls_sicdat)
dw_insert.SetItem(il_currow, "itmcyc_siseq", d_siseq) 
dw_insert.SetItem(il_currow, "itmcyc_sisdat", ls_frdat)
dw_insert.SetItem(il_currow, "itmcyc_siedat", ls_todat)
dw_insert.SetItem(il_currow, "cycsts", ls_sts)
dw_insert.SetItem(il_currow, "itmcyc_jego_gub", ls_jegogb)
dw_insert.SetItem(il_currow, "itmcyc_pspec" , '.')
dw_insert.SetItem(il_currow, "itmcyc_lotsno" , '.')
dw_insert.SetItem(il_currow, "itmcyc_cujqty" , 0)
dw_insert.SetItem(il_currow, "stock_jego_qty", 0)
dw_insert.SetItem(il_currow, "sijqty", 0)
dw_insert.SetItem(il_currow, "dgap"  , 0)

dw_insert.SetItem(il_currow, "chk", 'N')
dw_INSERT.ScrollToRow (il_currow)
dw_insert.SetColumn("itmcyc_itnbr")
dw_insert.SetFocus()

dw_insert.Modify("DataWindow.HorizontalScrollPosition = '0'")


end event

type p_search from w_inherite`p_search within w_mat_03010
integer x = 3383
integer taborder = 70
boolean enabled = false
string picturename = "C:\erpman\image\완료취소_up.gif"
end type

event p_search::clicked;call super::clicked;String  s_date, s_depot, s_crdate, s_cycsts
int     iseq, lRtnValue

IF dw_1.AcceptText() = -1 THEN RETURN 
s_cycsts = dw_1.GetItemString(1, 'cycsts')
s_depot  = dw_1.GetItemString(1, 'depot')
s_crdate = trim(dw_1.GetItemString(1, 'cr_date'))
s_date   = trim(dw_1.GetItemString(1, 'wan_date'))

iseq     = dw_1.GetItemNumber(1, 'seq')

if s_cycsts <> '2' then 
	messagebox("확인", "완료취소 처리를 할 수 없는 자료입니다.")
	return 
end if	

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	return
end if	

if isnull(s_crdate) or s_crdate = "" then
	f_message_chk(30,'[생성일자]')
	dw_1.SetColumn('cr_date')
	dw_1.SetFocus()
	return
end if	

if isnull(s_date) or s_date = "" then
	f_message_chk(30,'[완료일자]')
	dw_1.SetColumn('wan_date')
	dw_1.SetFocus()
	return
end if	

IF Messagebox('확 인','취소 처리 하시겠습니까?',Question!,YesNo!,1) <> 1 THEN RETURN 

SetPointer(HourGlass!)

w_mdi_frame.sle_msg.text = "주기 실사 완료 취소 처리 中 ........."

lRtnValue = sqlca.erp000000210_1(gs_sabu, s_depot, s_crdate, iseq)

IF lRtnValue < 0 THEN	
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(32,'[완료 취소실패] ' + string(lRtnValue) )
	Return
else
	commit;
	w_mdi_frame.sle_msg.text = "주기 실사 자료 완료취소 처리되었습니다."
end if	

SetPointer(Arrow!)
p_can.TriggerEvent(Clicked!)

end event

event p_search::ue_lbuttondown;PictureName = "C:\erpman\image\완료취소_dn.gif"
end event

event p_search::ue_lbuttonup;PictureName = "C:\erpman\image\완료취소_up.gif"
end event

type p_ins from w_inherite`p_ins within w_mat_03010
integer x = 3730
integer taborder = 90
string pointer = "C:\erpman\cur\point.cur"
string picturename = "C:\erpman\image\사유조회_up.gif"
end type

event p_ins::clicked;call super::clicked;decimal  dgap, dqty
string   snull, siogbn, scycsts
long     lrow
str_itmcyc istr_itmcyc  

setnull(snull)

if dw_insert.accepttext() = -1 then return 

IF dw_insert.rowcount() < 1 then 
	messagebox("확 인", "조회 후 자료를 선택하세요!")
	return 
END IF	

lrow = dw_insert.GetRow()

IF lrow < 1 then 
	messagebox("확 인", "자료를 선택하세요!")
	return 
END IF	

dgap    = dw_insert.getitemdecimal(lrow, 'dgap')
dqty    = dw_insert.getitemdecimal(lrow, 'itmcyc_cujqty')
scycsts = dw_insert.getitemstring(lrow, 'cycsts')

if scycsts = '1' then 
	IF dgap > 0 then
		siogbn    = 'I14'
		gs_gubun  = siogbn
	ELSEIF dgap = 0 then 
		siogbn    = snull
		gs_gubun  = siogbn
	ELSE	
		siogbn    = 'O08'
		gs_gubun  = siogbn
	END IF	
else
	gs_gubun = 'Y'
end if

istr_itmcyc.depot  = dw_insert.getitemstring(lrow, 'itmcyc_depot')
istr_itmcyc.sicdat = dw_insert.getitemstring(lrow, 'itmcyc_sicdat')
istr_itmcyc.siseq  = dw_insert.getitemnumber(lrow, 'itmcyc_siseq')
istr_itmcyc.itnbr  = dw_insert.getitemstring(lrow, 'itmcyc_itnbr')
istr_itmcyc.pspec  = dw_insert.getitemstring(lrow, 'itmcyc_pspec')

OpenWithParm(w_mat_03010_popup, istr_itmcyc)

if scycsts = '1' then 
	if gs_gubun = 'Y' then 
		dw_insert.setitem(lrow, 'bigo', gs_code)
		dw_insert.setitem(lrow, 'crtgub', gs_codename)
		if gs_codename = 'Y' then 
			dw_insert.setitem(lrow, 'iogbn', siogbn)
		else
			dw_insert.setitem(lrow, 'iogbn', snull)
			dw_insert.setitem(lrow, 'sijqty', dqty)
		end if
	else
		dw_insert.setitem(lrow, 'bigo', snull)
		dw_insert.setitem(lrow, 'crtgub', 'N')
		dw_insert.setitem(lrow, 'iogbn', snull)
		dw_insert.setitem(lrow, 'sijqty', dqty)
	end if	
end if

end event

event p_ins::ue_lbuttondown;PictureName = "C:\erpman\image\사유조회_dn.gif"
end event

event p_ins::ue_lbuttonup;PictureName = "C:\erpman\image\사유조회_up.gif"
end event

type p_exit from w_inherite`p_exit within w_mat_03010
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_mat_03010
integer taborder = 50
end type

event p_can::clicked;call super::clicked;wf_set()

dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.setredraw(True)

ib_any_typing = FALSE



end event

type p_print from w_inherite`p_print within w_mat_03010
integer x = 3557
integer taborder = 80
string pointer = "C:\erpman\cur\point.cur"
boolean enabled = false
string picturename = "C:\erpman\image\실사완료_up.gif"
end type

event p_print::clicked;call super::clicked;String  s_date, s_depot, s_crdate, get_status, s_cycsts, sjpno
long    lrtnvalue
Integer iMaxOrderNo, iseq

IF dw_1.AcceptText() = -1 THEN RETURN 
s_cycsts = dw_1.GetItemString(1, 'cycsts')
s_depot  = dw_1.GetItemString(1, 'depot')
s_crdate = trim(dw_1.GetItemString(1, 'cr_date'))
s_date   = trim(dw_1.GetItemString(1, 'wan_date'))
iseq     = dw_1.GetItemNumber(1, 'seq')

if s_cycsts <> '1' then 
	messagebox("확인", "실사완료처리를 할 수 없는 자료입니다.")
	return 
end if	

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	return
end if	

if isnull(s_crdate) or s_crdate = "" then
	f_message_chk(30,'[생성일자]')
	dw_1.SetColumn('cr_date')
	dw_1.SetFocus()
	return
end if	

if isnull(iseq) or iseq = 0 then
	f_message_chk(30,'[순번]')
	dw_1.SetColumn('seq')
	dw_1.SetFocus()
	return
end if	

if isnull(s_date) or s_date = "" then
	f_message_chk(30,'[완료일자]')
	dw_1.SetColumn('wan_date')
	dw_1.SetFocus()
	return
end if	

IF Messagebox('확 인','완료 처리 하시겠습니까?',Question!,YesNo!,1) <> 1 THEN RETURN 

SetPointer(HourGlass!)
w_mdi_frame.sle_msg.text = "전표 채번 中 ........."

iMaxOrderNo = sqlca.fun_junpyo(gs_sabu, s_Date, 'C0')
IF iMaxOrderNo <= 0 THEN
   w_mdi_frame.sle_msg.text = ""
	f_message_chk(51,'')
	ROLLBACK;
END IF

sjpno = s_Date + String(iMaxOrderNo,'0000')

Commit;

w_mdi_frame.sle_msg.text = "실사 차이에 의한 전표 생성 中 ........."

lRtnValue = sqlca.erp000000210(gs_sabu, s_depot, s_crdate, iseq, s_date, sjpno )

IF lRtnValue = -1 THEN	
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(89,'[전표생성 실패]')
	Return
ELSEIF lRtnValue = -3 THEN	
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(32,'[완료처리 실패]')
	Return
ELSEIF lRtnValue = -9 THEN	
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(89,'[작업 실패]')
	Return
ELSEIF lRtnValue = -6 THEN	
	ROLLBACK;
	w_mdi_frame.sle_msg.text = ""
	f_message_chk(89,'[갱신 실패]')
	Return
END IF

commit;
if lrtnvalue = 0 then 	
	w_mdi_frame.sle_msg.text = "주기 실사 자료 완료 처리되었습니다."
	messagebox("완료확인", "주기실사 완료 처리 되었습니다.")
elseif lrtnvalue = 1 then 
	w_mdi_frame.sle_msg.text = "주기 실사 자료 완료 처리되었습니다. (" + &
	               string(lRtnValue) + '건에 전표가 생성처리)'
	messagebox("완료확인", sjpno + '001' + " 전표 생성")
elseif lrtnvalue > 1 then 
	w_mdi_frame.sle_msg.text = "주기 실사 자료 완료 처리되었습니다. (" + &
	               string(lRtnValue) + '건에 전표가 생성처리)'
	messagebox("완료확인", sjpno + '-001 부터' + sjpno + '-' + string(lRtnValue, '000') + " 까지 전표 생성")
end if

SetPointer(Arrow!)
p_can.TriggerEvent(Clicked!)
end event

event p_print::ue_lbuttondown;PictureName = "C:\erpman\image\실사완료_dn.gif"
end event

event p_print::ue_lbuttonup;PictureName = "C:\erpman\image\실사완료_up.gif"
end event

type p_inq from w_inherite`p_inq within w_mat_03010
integer x = 3922
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string s_depot, s_fritnbr, s_toitnbr, s_crdate, s_ittyp, s_itcls, s_plant
int    iseq

if dw_1.AcceptText() = -1 then return 

s_depot   = trim(dw_1.GetItemString(1,'depot'))
s_crdate  = trim(dw_1.GetItemString(1,'cr_date'))
iseq      = dw_1.GetItemNumber(1,'seq')
s_ittyp   = trim(dw_1.GetItemString(1,'ittyp'))
s_itcls   = trim(dw_1.GetItemString(1,'itcls'))
s_fritnbr = trim(dw_1.GetItemString(1,'fr_itnbr'))
s_toitnbr = trim(dw_1.GetItemString(1,'to_itnbr'))
s_plant = trim(dw_1.GetItemString(1,'plant'))

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	return
end if	


/*------------------------------------------------------------------------------------*/ 
/* 물류창고일 경우 */
String ls_jumae
SELECT JUMAECHUL
  INTO :ls_jumae
  FROM VNDMST
 WHERE CVCOD = :s_depot ;
If ls_jumae <> '4' Then
	s_plant = 'X'
End If
/*------------------------------------------------------------------------------------*/ 


if isnull(s_crdate) or s_crdate = "" then
	f_message_chk(30,'[생성일자]')
	dw_1.SetColumn('cr_date')
	dw_1.SetFocus()
	return
end if	

if isnull(iseq) or iseq = 0 then
	f_message_chk(30,'[순번]')
	dw_1.SetColumn('seq')
	dw_1.SetFocus()
	return
end if	

if isnull(s_ittyp) or s_ittyp = "" then
	s_ittyp = '%'
end if	

if isnull(s_itcls) or s_itcls = "" then 
	s_itcls = '%'
else
	s_itcls = s_itcls + '%'
end if	

if isnull(s_fritnbr) or s_fritnbr = "" then s_fritnbr = '.'
if isnull(s_toitnbr) or s_toitnbr = "" then s_toitnbr = 'zzzzzzzzzzzzzzz'

if s_fritnbr > s_toitnbr then 
	f_message_chk(34,'[품번]')
	dw_1.Setcolumn('fr_itnbr')
	dw_1.SetFocus()
	return
end if	

if dw_insert.Retrieve(gs_sabu, s_depot, s_crdate, s_fritnbr, s_toitnbr, s_ittyp, s_itcls, iseq, gs_saupj, s_plant) <= 0 then 
	dw_1.Setfocus()
	return
else
   dw_insert.SetColumn('sijqty')
	dw_insert.SetFocus()
end if	

ib_any_typing = FALSE


end event

type p_del from w_inherite`p_del within w_mat_03010
boolean visible = false
integer x = 3762
integer y = 3276
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_mat_03010
integer x = 4096
integer taborder = 40
end type

event p_mod::clicked;call super::clicked;long i

if dw_insert.AcceptText() = -1 then return 

if dw_insert.rowcount() <= 0 then return 	


//FOR i = 1 TO dw_insert.RowCount()
//	IF wf_required_chk(i) = -1 THEN RETURN
//NEXT
//
if f_msg_update() = -1 then return
	
if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text = "자료가 저장되었습니다!!"
	ib_any_typing= FALSE
	commit ;
else
	rollback ;
	messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
	return 
end if	
		

end event

type cb_exit from w_inherite`cb_exit within w_mat_03010
integer x = 2825
integer y = 3288
end type

type cb_mod from w_inherite`cb_mod within w_mat_03010
integer x = 2121
integer y = 3288
end type

type cb_ins from w_inherite`cb_ins within w_mat_03010
integer x = 462
integer y = 3288
string text = "사유조회"
end type

type cb_del from w_inherite`cb_del within w_mat_03010
integer x = 1143
integer y = 2392
end type

type cb_inq from w_inherite`cb_inq within w_mat_03010
integer x = 1774
integer y = 3288
end type

type cb_print from w_inherite`cb_print within w_mat_03010
integer x = 814
integer y = 3288
integer width = 462
boolean enabled = false
string text = "실사완료(&E)"
end type

type st_1 from w_inherite`st_1 within w_mat_03010
end type

type cb_can from w_inherite`cb_can within w_mat_03010
integer x = 2473
integer y = 3288
end type

type cb_search from w_inherite`cb_search within w_mat_03010
integer x = 1294
integer y = 3288
integer width = 462
boolean enabled = false
string text = "완료취소(&F)"
end type





type gb_10 from w_inherite`gb_10 within w_mat_03010
integer x = 9
integer y = 2968
integer height = 144
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_mat_03010
end type

type gb_button2 from w_inherite`gb_button2 within w_mat_03010
end type

type dw_1 from datawindow within w_mat_03010
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 41
integer y = 24
integer width = 3296
integer height = 412
integer taborder = 10
string dataobject = "d_mat_03010_a"
boolean border = false
boolean livescroll = true
end type

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event ue_key;setnull(gs_code)

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
ELSEIF keydown(keyF2!) THEN
	IF This.GetColumnName() = "fr_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"fr_itnbr",gs_code)
		RETURN 1
	ELSEIF This.GetColumnName() = "to_itnbr" Then
		open(w_itemas_popup2)
		if isnull(gs_code) or gs_code = "" then return
		
		this.SetItem(1,"to_itnbr",gs_code)
		RETURN 1
   END IF
END IF

end event

event itemchanged;string snull, sdate, sdepot, sittyp, sitcls, s_name
int    ireturn, iseq 

setnull(snull)
IF this.GetColumnName() ="depot" THEN
	sdepot = trim(this.GetText())
	sdate =  trim(this.getitemstring(1, 'cr_date'))
	iseq  =  this.getitemNumber(1, 'seq')
	
//	/* 물류창고일 경우 주기실사 제외 - 2006.11.24 By sHIngOOn */
//	String ls_jumae
//	SELECT JUMAECHUL
//	  INTO :ls_jumae
//	  FROM VNDMST
//	 WHERE CVCOD = :sdepot ;
//	If ls_jumae = '4' Then
//		MessageBox('창고 확인', '물류창고일 경우 주기실사 작업을 실행 할 수 없습니다.')
//		This.SetItem(1, 'depot', '')
//		Return
//	End If
//	/*------------------------------------------------------------------------------------*/ 
	 
	SELECT "VNDMST"."JUPROD" INTO :sittyp  FROM "VNDMST"  WHERE "VNDMST"."CVCOD" = :sdepot   ;

	dw_1.setitem(1, 'ittyp', sittyp)
	wf_check(sdate, sdepot, iseq)
	dw_insert.reset()
ELSEIF this.GetColumnName() ="cr_date" THEN
	sdate  =  trim(this.GetText())
	iseq   =  this.getitemNumber(1, 'seq')
	sdepot =  trim(this.getitemstring(1, 'depot'))
	
	if sdate = "" or isnull(sdate) then
   	wf_check(sdate, sdepot, iseq)
		return 
   end if
  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[생성일자]')
		this.setitem(1, "cr_date", sNull)
   	wf_check(sdate, sdepot, iseq)
		return 1
   ELSE
   	sdepot =  trim(this.getitemstring(1, 'depot'))
   	wf_check(sdate, sdepot, iseq)
   END IF
ELSEIF this.GetColumnName() ="seq" THEN
	sdate  =  trim(this.getitemstring(1, 'cr_date'))
	iseq   =  integer(this.GetText())
	sdepot =  trim(this.getitemstring(1, 'depot'))

  	wf_check(sdate, sdepot, iseq)
	
ELSEIF this.GetColumnName() ="wan_date" THEN
	sdate = trim(this.GetText())
	
	if sdate = "" or isnull(sdate) then	return 

  	IF f_datechk(sdate) = -1	then
      f_message_chk(35, '[완료일자]')
		this.setitem(1, "wan_date", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = "ittyp"	THEN
		This.setitem(1, 'itcls', snull)
		this.SetItem(1, 'titnm', snull)
ELSEIF this.GetColumnName() = "itcls"	THEN
	sitcls = this.gettext()
   IF sitcls = "" OR IsNull(sitcls) THEN 
		this.SetItem(1,'titnm', snull)
		return 
   ELSE
		sittyp  = this.getitemstring(1, 'ittyp')
		ireturn = f_get_name2('품목분류', 'Y', sitcls, s_name, sittyp)
		This.setitem(1, 'itcls', sitcls)
		This.setitem(1, 'titnm', s_name)
   END IF
	return ireturn 
END IF

end event

event itemerror;return 1
end event

event rbuttondown;string sname
str_itnct lstr_sitnct

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)

if this.GetColumnName() = 'fr_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"fr_itnbr",gs_code)
elseif this.GetColumnName() = 'to_itnbr' then
   gs_code = this.GetText()
	open(w_itemas_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"to_itnbr",gs_code)
elseif this.GetColumnName() = 'itcls' then
   this.accepttext()
	sname = this.GetItemString(1, 'ittyp')
	OpenWithParm(w_ittyp_popup4, sname)
	
   lstr_sitnct = Message.PowerObjectParm	
	
	if isnull(lstr_sitnct.s_ittyp) or lstr_sitnct.s_ittyp = "" then return 
	
	this.SetItem(1,"ittyp",lstr_sitnct.s_ittyp)
   
	this.SetItem(1,"itcls", lstr_sitnct.s_sumgub)
	this.SetItem(1,"titnm", lstr_sitnct.s_titnm)
elseif this.GetColumnName() = 'seq' then
   gs_code = this.GetItemstring(1, 'depot')
	open(w_itmcyc_popup)
	
	if isnull(gs_code) or gs_code = "" then return
	
	this.SetItem(1,"depot",  gs_gubun)
	this.SetItem(1,"cr_date", gs_code)
	this.SetItem(1,"seq",    integer(gs_codename))
	this.triggerevent(itemchanged!)
end if
end event

type pb_1 from u_pb_cal within w_mat_03010
integer x = 2331
integer y = 68
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('cr_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'cr_date', gs_code)



end event

type pb_2 from u_pb_cal within w_mat_03010
integer x = 2331
integer y = 152
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('wan_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'wan_date', gs_code)



end event

type pb_3 from u_pb_cal within w_mat_03010
integer x = 2286
integer y = 236
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('fr_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'fr_date', gs_code)



end event

type pb_4 from u_pb_cal within w_mat_03010
integer x = 2816
integer y = 236
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_1.SetColumn('to_date')
IF IsNull(gs_code) THEN Return
ll_row = dw_1.GetRow()
If ll_row < 1 Then Return
dw_1.SetItem(ll_row, 'to_date', gs_code)



end event

type cb_1 from commandbutton within w_mat_03010
integer x = 3735
integer y = 296
integer width = 402
integer height = 104
integer taborder = 100
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "DOWNLOAD"
end type

event clicked;If this.Enabled Then wf_excel_down(dw_insert)
end event

type cb_2 from commandbutton within w_mat_03010
integer x = 4151
integer y = 296
integer width = 402
integer height = 104
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "UPLOAD"
end type

event clicked;Long		lXlrow, lValue, lCnt, lQty[], lTotal, lRow
String		sDocname, sNamed, sPspec
String		sWcdsc,  sItemnum, sItemname, sIspec, sOpdsc, sKumno, sQty, sTotal, sayu		// 호기-품번-품명-공정-금형-수량...
uo_xlobject 		uo_xl
Integer 	i, j, k, iNotNullCnt
Decimal{3} dQty
string s_depot, s_crdate
int    iseq

if dw_1.AcceptText() = -1 then return 
if dw_insert.rowcount() <= 0 then
	messagebox('확인','자료를 조회한 후 처리하십시오!!!')
	return
end if

s_depot   = trim(dw_1.GetItemString(1,'depot'))
s_crdate  = trim(dw_1.GetItemString(1,'cr_date'))
iseq      = dw_1.GetItemNumber(1,'seq')

if isnull(s_depot) or s_depot = "" then
	f_message_chk(30,'[창고]')
	dw_1.SetColumn('depot')
	dw_1.SetFocus()
	return
end if	

if isnull(s_crdate) or s_crdate = "" then
	f_message_chk(30,'[생성일자]')
	dw_1.SetColumn('cr_date')
	dw_1.SetFocus()
	return
end if	

if isnull(iseq) or iseq = 0 then
	f_message_chk(30,'[순번]')
	dw_1.SetColumn('seq')
	dw_1.SetFocus()
	return
end if	

// 전체 대상자료 조회후 처리
select count(*) into :lCnt from itmcyc
 where sabu = :gs_sabu and depot = :s_depot and sicdat = :s_crdate and siseq = :iseq
   and itnbr >= '.' and itnbr <= 'ZZZZZZZZZZZZZZZZZZZZ' ;

if dw_insert.rowcount() <> lCnt then
	messagebox('확인','전체 자료를 조회한 후 처리하십시오!!!')
	return
end if

// 액셀 IMPORT ***************************************************************

lValue = GetFileOpenName("재고실사 가져오기", sDocname, sNamed, "XLS", "XLS Files (*.XLS),*.XLS,")
If lValue <> 1 Then Return -1

Setpointer(Hourglass!)

//수량 < 0 이면 Reset --------------------------------------------------------------------------------//
For i = 1 To dw_insert.RowCount()
	If dw_insert.GetItemNumber(i, 'sijqty') < 0 Then
		dw_insert.SetItem(i, 'sijqty', 0)
	End If
Next	

////===========================================================================================
////UserObject 생성
w_mdi_frame.sle_msg.text = "액셀 업로드 준비중..."
uo_xl = create uo_xlobject

//엑셀과 연결
uo_xl.uf_excel_connect(sDocname, false , 3)
uo_xl.uf_selectsheet(1)

//Data 시작 Row Setting (행)
// Excel 에서 A: 1 , B :2 로 시작 

lXlrow = 2		// 첫헤드를 제외하고 두번째행부터 진행
lCnt = 0 

Do While(True)
	
	// 사용자 ID(A,1)
	// Data를 읽을 경우 해당하는 셀서식을 지정해야만 글자가 깨지지 않음....이유는 모르겠음....
	// 총 36개 열로 구성
	For i =1 To 12
		uo_xl.uf_set_format(lXlrow,i, '@' + space(50))
	Next
	
	iNotNullCnt = 0		// 품번값이 NULL 이면 임포트 종료
	
	sItemnum = trim(uo_xl.uf_gettext(lXlrow,2))					// 품번
	if sItemnum > '.' then 
		iNotNullCnt++

		select itdsc, ispec into :sItemname, :sIspec from itemas where itnbr = :sItemnum ;
		if sqlca.sqlcode <> 0 then
			messagebox('확인',sItemnum+' 는 등록되지 않은 품번입니다!!!')
			return
		end if
		
		w_mdi_frame.sle_msg.text = "액셀 업로드 진행중 ("+String(lCnt)+") ..."+sItemnum+"  "+sItemname

		sPspec = trim(uo_xl.uf_gettext(lXlrow,5))					// 사양관리 하지 않음. - by shingoon 2009.06.02
		if isnull(sPspec) or trim(sPspec) = '' OR sPspec <> '.' then sPspec = '.'
		
		sQty = trim(uo_xl.uf_gettext(lXlrow,8))						// 실사수량
		if not IsNumber(sQty) then
			messagebox('확인','다운로드 양식이 변형되어 업로드가 불가능합니다!!!')
			return
		end if
		
		dQty = Dec(sQty)
		
		sayu = trim(uo_xl.uf_gettext(lXlrow,12))					// 사유
		
		lRow = dw_insert.Find("itmcyc_itnbr='"+sItemnum+"' and itmcyc_pspec='"+sPspec+"'",1,dw_insert.RowCount())
		if lRow <= 0 then 
			dw_insert.SetRow(dw_insert.rowcount())
			p_addrow.triggerevent(clicked!)
			lRow = dw_insert.rowcount()
			dw_insert.object.itmcyc_itnbr[lRow] = sItemnum 
			dw_insert.object.itemas_itdsc[lRow] = sItemname
			dw_insert.object.itemas_ispec[lRow] = sIspec
			dw_insert.object.itmcyc_pspec[lRow] = sPspec
		end if
			
		dw_insert.object.sijqty[lRow] = dQty
		dw_insert.object.bigo[lRow] = sayu
		dw_insert.Scrolltorow(lRow)	
		
		dw_insert.triggerevent(itemchanged!)
		
		lCnt++
	end if
	
	// 해당 행의 어떤 열에도 값이 지정되지 않았다면 파일 끝으로 인식해서 임포트 종료
	If iNotNullCnt = 0 Then Exit
	
	lXlrow ++
Loop
uo_xl.uf_excel_Disconnect()


//// 엘셀 IMPORT  END ***************************************************************
dw_insert.AcceptText()

wf_sijqty()
//dw_insert.Sort()

MessageBox('확인',String(lCnt)+' 건의 재고 DATA IMPORT 를 완료하였습니다.')
w_mdi_frame.sle_msg.text = ""
DESTROY uo_xl
end event

type pb_5 from picturebutton within w_mat_03010
boolean visible = false
integer x = 3369
integer y = 184
integer width = 274
integer height = 104
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "재고적용"
boolean originalsize = true
vtextalign vtextalign = vcenter!
end type

event clicked;Long   ll_cnt
ll_cnt = dw_insert.RowCount()
If ll_cnt < 1 Then Return

Integer i
Integer li_find
String  ls_itnbr
String  ls_pspec
For i = 1 To ll_cnt
	li_find = dw_insert.Find("itmcyc_itnbr = '" + ls_itnbr + "' and itmcyc_pspec = '" + ls_pspec + "'", i, ll_cnt)
	If li_find < 1 Then Exit
	
Next
end event

type gb_1 from groupbox within w_mat_03010
integer x = 3694
integer y = 224
integer width = 910
integer height = 204
integer taborder = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 32106727
string text = "EXCEL FILE"
end type

type rr_1 from roundrectangle within w_mat_03010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 50
integer y = 444
integer width = 4558
integer height = 1868
integer cornerheight = 40
integer cornerwidth = 55
end type

type cb_3 from commandbutton within w_mat_03010
integer x = 4297
integer y = 180
integer width = 302
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "One Shot!"
end type

event constructor;//If gs_empno = '1296' Then
//	This.Visible = True
//Else
//	This.Visible = False
//End If
end event

event clicked;Window	lw_window
String ls_window_id
ls_window_id = 'w_silsa'

OpenSheet(lw_window, ls_window_id, w_mdi_frame, 0, Layered!)
end event

