$PBExportHeader$w_pdm_t_00030.srw
$PBExportComments$원가계산서입력 (제품)
forward
global type w_pdm_t_00030 from w_inherite
end type
type dw_list from datawindow within w_pdm_t_00030
end type
type dw_list2 from datawindow within w_pdm_t_00030
end type
type st_2 from statictext within w_pdm_t_00030
end type
type st_3 from statictext within w_pdm_t_00030
end type
type dw_1 from datawindow within w_pdm_t_00030
end type
type p_1 from uo_picture within w_pdm_t_00030
end type
type p_2 from uo_picture within w_pdm_t_00030
end type
type p_3 from uo_picture within w_pdm_t_00030
end type
type p_4 from uo_picture within w_pdm_t_00030
end type
type rb_insert from radiobutton within w_pdm_t_00030
end type
type rb_delete from radiobutton within w_pdm_t_00030
end type
type pb_1 from u_pb_cal within w_pdm_t_00030
end type
type rr_3 from roundrectangle within w_pdm_t_00030
end type
type rr_2 from roundrectangle within w_pdm_t_00030
end type
type rr_1 from roundrectangle within w_pdm_t_00030
end type
type rr_4 from roundrectangle within w_pdm_t_00030
end type
type rr_5 from roundrectangle within w_pdm_t_00030
end type
type rr_6 from roundrectangle within w_pdm_t_00030
end type
end forward

global type w_pdm_t_00030 from w_inherite
string title = "설계원가계산서 등록 (제품)"
dw_list dw_list
dw_list2 dw_list2
st_2 st_2
st_3 st_3
dw_1 dw_1
p_1 p_1
p_2 p_2
p_3 p_3
p_4 p_4
rb_insert rb_insert
rb_delete rb_delete
pb_1 pb_1
rr_3 rr_3
rr_2 rr_2
rr_1 rr_1
rr_4 rr_4
rr_5 rr_5
rr_6 rr_6
end type
global w_pdm_t_00030 w_pdm_t_00030

type variables
string  ls_gub ='Y'
//str_itnct lstr_sitnct

end variables

forward prototypes
public function integer wf_common ()
public subroutine wf_reset ()
public subroutine wf_all_retrieve (string s_code, string s_code2)
public function integer wf_init ()
public function integer wf_chk ()
public function integer wf_delete_chk (string seco_no, string sitnbr)
end prototypes

public function integer wf_common ();/*
string	seco_no, sitnbr

seco_no = dw_1.GetItemString(1, "eco_no")
sitnbr = dw_1.GetItemString(1, "itnbr")


dw_insert.SetItem(1, "eco_no", seco_no)
dw_insert.SetItem(1, "itnbr", sitnbr)

*/

RETURN 1
end function

public subroutine wf_reset ();dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.setredraw(true)

dw_list.setredraw(false)
dw_list.reset()
dw_list.setredraw(true)

dw_list2.setredraw(false)
dw_list2.reset()
dw_list2.setredraw(true)

end subroutine

public subroutine wf_all_retrieve (string s_code, string s_code2);Integer   ix
Decimal {3} d_calc

dw_list.retrieve(gs_sabu, s_code,s_code2)
dw_list2.retrieve(gs_sabu,s_code,s_code2)


IF 	dw_insert.retrieve(gs_sabu, s_code,s_code2) <= 0 THEN
	dw_insert.InsertRow(0)
	dw_insert.SetItem(1, 'start_date', f_today())
END IF

// -- 여유율 입력(temp 계산위해)
For ix = 1 To dw_list2.RowCount()
	d_calc  = dw_insert.GetItemDecimal(1, 'margin_rate')
     dw_list2.SetITem(ix, 'temp', d_calc)	
Next
//
p_del.enabled = true

p_del.PictureName  = "C:\erpman\image\삭제_up.gif"

ls_gub = 'N'    //'N'이면 수정모드


ib_any_typing = FALSE
end subroutine

public function integer wf_init ();dw_1.SetRedraw(false)
dw_insert.SetRedraw(false)
dw_list.SetRedraw(false)
dw_list2.SetRedraw(false)

ib_any_typing = FALSE

p_del.enabled = false
p_del.picturename = "C:\erpman\image\삭제_d.gif"
dw_1.enabled = TRUE

//
dw_1.Reset()
dw_insert.Reset()
dw_list.reset()
dw_list2.reset()

dw_1.insertRow(0)
dw_insert.insertRow(0)
//


////////////////////////////////////////////////////////////////////////

IF ls_gub = 'Y'	then

	// 등록시
	p_inq.enabled = false
	p_inq.picturename = "C:\erpman\image\조회_d.gif"
	w_mdi_frame.sle_msg.text = "등록"

ELSE
	p_inq.enabled = true
	p_inq.picturename = "C:\erpman\image\조회_up.gif"
	w_mdi_frame.sle_msg.text = "삭제"
	
END IF

//
//dw_1.SetTaborder('eco_no',1)
dw_1.SetColumn('eco_no')
dw_1.SetFocus()

dw_insert.SetItem(1,"start_date",is_today)
//
dw_list.SetRedraw(true)
dw_list2.SetRedraw(true)

dw_insert.SetRedraw(true)
dw_1.SetRedraw(true)

return 1



end function

public function integer wf_chk ();String  sSdate, sEdate, sItnbr, sEco_no
Long   ix
Decimal {3} d_calc , d_sum1 , d_sum2 , d_sum3

If dw_insert.AcceptText() <> 1 Then Return -1
dw_1.AcceptText()
dw_list.AcceptText()
dw_list2.AcceptText()

sSdate	= Trim(dw_insert.GetItemString(1,'start_date'))
sEdate	= Trim(dw_insert.GetItemString(1,'end_date'))

If f_datechk(sSdate) <> 1 Then
	f_message_chk(40,'[시작일자]')
	dw_insert.SetColumn('start_date')
	dw_insert.SetFocus()
	Return -1
End If

If f_datechk(sEdate) <> 1 and  Not(isnull(sEdate)) Then
	f_message_chk(40,'[완료일자]')
	dw_insert.SetColumn('end_date')
	dw_insert.SetFocus()
	Return -1
End If


/*                                                  // 추후에 업무시작할때 해제하여야 함.
dw_list.SetFocus()
For ix = 1 To dw_list.RowCount()
	sItnbr  = Trim(dw_list.GetItemString(ix, 'itnbr'))
	
	If IsNull(sItnbr) or sItnbr = '' Then
		f_message_chk(40,'[품번]')
		dw_list.ScrollToRow(ix)
		dw_list.SetColumn('itnbr')
		dw_list.SetFocus()
		Return -1
	End If
Next
*/

//--------------------------------------------------------------------//
d_calc = 0 ; d_sum1 = 0 ; d_sum2 =0 ;

// -- Master 계산 값 및 금액 구하기.(재료비)
For ix = 1 To dw_list.RowCount()
	d_calc  = dw_list.GetItemDecimal(ix, 'wonfac_1')
	If dw_list.GetItemString(ix, 'itgu') = '2' then 
        d_sum1  = d_sum1 + d_calc
	else
        d_sum2  = d_sum2 + d_calc
	End if
	dw_list.SetItem(ix, 'wonfac', d_calc)
Next
//
dw_insert.SetItem(1, 'material_amount1', d_sum1)
dw_insert.SetItem(1, 'material_amount2', d_sum2)



d_calc = 0 ; d_sum1 = 0 ; d_sum2 =0 ; d_sum3 =0 ;

// -- Master 계산 값 및 금액 구하기.(노무비,경비,가공비)
For ix = 1 To dw_list2.RowCount()
	d_calc  = dw_list2.GetItemDecimal(ix, 'labor_cost_1')   //노무비
	dw_list2.SetItem(ix, 'labor_cost', d_calc)
     d_sum1  = d_sum1 + d_calc
	d_calc  = dw_list2.GetItemDecimal(ix, 'amount_cost_1')   // 경비
	dw_list2.SetItem(ix, 'amount_cost', d_calc)
     d_sum2  = d_sum2 + d_calc
	d_calc  = dw_list2.GetItemDecimal(ix, 'work_cost_1')   // 가공비
	dw_list2.SetItem(ix, 'work_cost', d_calc)
     d_sum3  = d_sum3 + d_calc
Next
//
dw_insert.SetItem(1, 'manage_cost1', d_sum1)
dw_insert.SetItem(1, 'manage_cost2', d_sum2)
dw_insert.SetItem(1, 'manage_cost3', d_sum3)

d_calc  = dw_insert.GetItemDecimal(1, 'profit_1')   //이윤
dw_insert.SetItem(1, 'profit', d_calc)
d_calc  = dw_insert.GetItemDecimal(1, 'rd_cost_1')   //투자개발비
dw_insert.SetItem(1, 'rd_cost', d_calc)
d_calc  = dw_insert.GetItemDecimal(1, 'esti_amount_1')   //자체견적가
dw_insert.SetItem(1, 'esti_amount', d_calc)

// Key Value Move
sEco_no = dw_1.GetItemString(1,'eco_no')
sItnbr      = dw_1.GetItemString(1,'itnbr')
dw_insert.SetItem(1, 'sabu', gs_sabu)
dw_insert.SetItem(1, 'itnbr', sItnbr)
dw_insert.SetItem(1, 'eco_no', sEco_no)

//확정일자 는 확정금액 입력으로 현재일자 입력
d_calc = dw_insert.GetItemDecimal(1, 'forfac')   // 확정금액
IF 	d_calc > 0 then
	dw_insert.SetItem(1, 'for_date', f_today())
End if

dw_insert.SetItem(1, 'gritu', dw_1.GetItemString(1, 'gritu') )

Return 1

end function

public function integer wf_delete_chk (string seco_no, string sitnbr);Long icnt = 0

  SELECT COUNT(*)
    INTO :icnt  
    FROM ESTILIST_MATERMST
   WHERE ECO_NO  = :sEco_no
       AND  ITNBR      = :sItnbr
	  AND  ROWNUM = 1  ;

if sqlca.sqlcode <> 0 or icnt >= 1 then
	f_message_chk(38,'[설계원가계산서(사출,PRESS]')
	return -1
end if


return 1
end function

on w_pdm_t_00030.create
int iCurrent
call super::create
this.dw_list=create dw_list
this.dw_list2=create dw_list2
this.st_2=create st_2
this.st_3=create st_3
this.dw_1=create dw_1
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.p_4=create p_4
this.rb_insert=create rb_insert
this.rb_delete=create rb_delete
this.pb_1=create pb_1
this.rr_3=create rr_3
this.rr_2=create rr_2
this.rr_1=create rr_1
this.rr_4=create rr_4
this.rr_5=create rr_5
this.rr_6=create rr_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list
this.Control[iCurrent+2]=this.dw_list2
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.p_2
this.Control[iCurrent+8]=this.p_3
this.Control[iCurrent+9]=this.p_4
this.Control[iCurrent+10]=this.rb_insert
this.Control[iCurrent+11]=this.rb_delete
this.Control[iCurrent+12]=this.pb_1
this.Control[iCurrent+13]=this.rr_3
this.Control[iCurrent+14]=this.rr_2
this.Control[iCurrent+15]=this.rr_1
this.Control[iCurrent+16]=this.rr_4
this.Control[iCurrent+17]=this.rr_5
this.Control[iCurrent+18]=this.rr_6
end on

on w_pdm_t_00030.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_list)
destroy(this.dw_list2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.dw_1)
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.rb_insert)
destroy(this.rb_delete)
destroy(this.pb_1)
destroy(this.rr_3)
destroy(this.rr_2)
destroy(this.rr_1)
destroy(this.rr_4)
destroy(this.rr_5)
destroy(this.rr_6)
end on

event open;call super::open;dw_insert.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_list2.SetTransObject(sqlca)

dw_insert.setredraw(false)
dw_insert.reset()
dw_insert.insertrow(0)
dw_insert.setredraw(true)

dw_1.SetTransObject(sqlca)

Wf_init()


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

type dw_insert from w_inherite`dw_insert within w_pdm_t_00030
integer x = 59
integer y = 344
integer width = 1577
integer height = 1920
string dataobject = "d_dpm_t_00030_1"
boolean border = false
end type

event dw_insert::editchanged;RETURN 1
end event

event dw_insert::itemerror;call super::itemerror;return 1
end event

event dw_insert::updatestart;call super::updatestart;/* Update() function 호출시 user 설정 */
long k, lRowCount

lRowCount = this.RowCount()

FOR k = 1 TO lRowCount
   IF NewModified! = this.GetItemStatus(k, 0, Primary!) THEN
 	   This.SetItem(k,'crt_user',gs_userid)
   ELSEIF DataModified! = this.GetItemStatus(k, 0, Primary!) THEN 		
	   This.SetItem(k,'upd_user',gs_userid)
   END IF	  
NEXT


end event

type p_delrow from w_inherite`p_delrow within w_pdm_t_00030
boolean visible = false
integer x = 5051
integer y = 172
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdm_t_00030
boolean visible = false
integer x = 4878
integer y = 172
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdm_t_00030
boolean visible = false
integer x = 4873
integer y = 316
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdm_t_00030
boolean visible = false
integer x = 4704
integer y = 172
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_pdm_t_00030
end type

type p_can from w_inherite`p_can within w_pdm_t_00030
integer x = 4261
end type

event p_can::clicked;call super::clicked;wf_init()


end event

type p_print from w_inherite`p_print within w_pdm_t_00030
boolean visible = false
integer x = 5047
integer y = 316
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdm_t_00030
integer x = 3712
end type

event p_inq::clicked;call super::clicked;String seco_no, sitnbr

dw_1.AcceptText()
seco_no = dw_1.object.eco_no[1]
sitnbr      = dw_1.object.itnbr[1]
IF IsNull(seco_no)	 or  seco_no = ''	THEN
	MessageBox("확 인", "ECO NO. 를 먼저 입력하세요.")
	dw_1.SetColumn("eco_no")
	dw_1.SetFocus()
	RETURN
END IF

dw_1.enabled = false
p_del.enabled = true
p_del.picturename = "C:\erpman\image\삭제_up.gif"

dw_insert.SetColumn("start_date")
dw_insert.SetFocus()


wf_all_retrieve(sitnbr, seco_no)


end event

type p_del from w_inherite`p_del within w_pdm_t_00030
integer x = 4078
boolean enabled = false
string picturename = "C:\erpman\image\삭제_d.gif"
end type

event p_del::ue_lbuttondown;call super::ue_lbuttondown;pictureName = "C:\erpman\image\삭제_dn.gif"
end event

event p_del::ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\erpman\image\삭제_up.gif"
end event

event p_del::clicked;call super::clicked;String sEco_no , sItnbr

sEco_no	= Trim(dw_1.GetItemString(1,'eco_no'))
sItnbr  	= Trim(dw_1.GetItemString(1,'itnbr'))

If f_msg_delete() = -1 then return

//삭제 가능여부 체크가 있어야 함 
if wf_delete_chk(sEco_no, sItnbr) = -1 then return 

// 노무비
DELETE FROM ESTILIST_LABOR 
    WHERE SABU = :gs_sabu AND ECO_NO = :sEco_no AND ITNBR = :sItnbr;
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'ESTILIST_LABOR')
	wf_init()
	Return
End If

// 재료비
DELETE FROM ESTILIST_MATERIAL
    WHERE SABU = :gs_sabu AND ECO_NO = :sEco_no AND ITNBR = :sItnbr;
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'ESTILIST_MATERIAL')
	wf_init()
	Return
End If

//MASTER
DELETE FROM ESTILIST 
    WHERE SABU = :gs_sabu AND ECO_NO = :sEco_no AND ITNBR = :sItnbr;
If sqlca.sqlcode <> 0 Then
	RollBack;
	f_message_chk(31,'ESTILIST')
	wf_init()
	Return
End If


COMMIT;
wf_init()

w_mdi_frame.sle_msg.text = '자료를 삭제하였습니다!!'
end event

type p_mod from w_inherite`p_mod within w_pdm_t_00030
integer x = 3895
end type

event p_mod::clicked;call super::clicked;
string sValue

//----- DATA 입력부분  확인....

If wf_chk() <> 1 Then Return 

IF MessageBox("확인", "저장 하시겠습니까?", question!, yesno!) = 2	THEN	RETURN

// key 값 Move

IF dw_list.update() <= 0 	THEN
	ROLLBACK;
	RETURN
END IF
		
IF dw_list2.update() <= 0	THEN
	ROLLBACK;
	RETURN
END IF


// 원가계산서 Master 저장	
IF 	dw_insert.update() > 0 	THEN
	COMMIT USING sqlca;
	p_inq.triggerevent(clicked!)
	w_mdi_frame.sle_msg.text ="자료를 저장하였습니다!!"
ELSE
	ROLLBACK USING sqlca;
	f_message_chk(32,'')
	Return
END IF
ib_any_typing = FALSE
p_inq.triggerevent(clicked!)
	

end event

type cb_exit from w_inherite`cb_exit within w_pdm_t_00030
end type

type cb_mod from w_inherite`cb_mod within w_pdm_t_00030
end type

type cb_ins from w_inherite`cb_ins within w_pdm_t_00030
end type

type cb_del from w_inherite`cb_del within w_pdm_t_00030
end type

type cb_inq from w_inherite`cb_inq within w_pdm_t_00030
end type

type cb_print from w_inherite`cb_print within w_pdm_t_00030
end type

type st_1 from w_inherite`st_1 within w_pdm_t_00030
end type

type cb_can from w_inherite`cb_can within w_pdm_t_00030
end type

type cb_search from w_inherite`cb_search within w_pdm_t_00030
end type







type gb_button1 from w_inherite`gb_button1 within w_pdm_t_00030
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_t_00030
end type

type dw_list from datawindow within w_pdm_t_00030
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 1714
integer y = 492
integer width = 2875
integer height = 724
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_dpm_t_00030_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;if keydown(KeyEnter!) AND this.getcolumnname() = "wonfac" then
   if this.rowcount() = this.getrow() then
      postevent(clicked!)
      return 1
   end if
end if

IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event editchanged;ib_any_typing =True
end event

event itemchanged;Int lRow, lReturnRow
string s_citnbr, sNull, get_itdsc, get_jijil, get_ispec, get_unmsr, get_wonprc, get_itgu
decimal {3} d_wonfac , d_calc

SetNull(snull)
dw_list.AcceptText()
lRow  = this.GetRow()	
IF this.GetColumnName() = "citnbr" THEN
	s_citnbr = this.GetText()								
    
	if s_citnbr = "" or isnull(s_citnbr) then 
		this.setitem(lrow, 'itdsc', snull)
		this.setitem(lrow, 'jijil'    , snull)
		this.setitem(lrow, 'ispec', snull)
		this.setitem(lrow, 'unmsr', snull)
		this.setitem(lrow, 'wonprc', 0)
		this.setitem(lrow, 'itgu', snull)
		return 
	end if
	
   SELECT "ITEMAS"."ITDSC"  ,  "ITEMAS"."JIJIL"  ,  "ITEMAS"."ISPEC"  ,  "ITEMAS"."UNMSR"  , 
	            "ITEMAS"."WONPRC"  , "ITEMAS"."ITGU"   
     INTO :get_itdsc, :get_jijil, :get_ispec, :get_unmsr, :get_wonprc, :get_itgu
     FROM "ITEMAS"  
    WHERE "ITEMAS"."ITNBR" = :s_citnbr  ;

	if sqlca.sqlcode = 0 then 
		this.setitem(lrow, 'itdsc'    , get_itdsc)
		this.setitem(lrow, 'jijil'        , get_jijil)
		this.setitem(lrow, 'ispec'   , get_ispec)
		this.setitem(lrow, 'unmsr'  , get_unmsr)
		this.setitem(lrow, 'wonprc', get_wonprc)
		this.setitem(lrow, 'itgu'      , get_itgu)
	else
		this.triggerevent(RbuttonDown!)
	   return 1
   end if	
	
	lReturnRow = This.Find("citnbr = '"+s_citnbr+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
		messagebox('확 인','등록된 소요품번입니다.') 
		RETURN  1
	END IF
END IF


Choose Case GetColumnName()
	Case	"wonfac_1" 
		d_wonfac = this.GetItemDecimal(lrow, "wonfac_1")	
		this.setitem(lrow, 'wonfac', d_wonfac)
	Case	"minqt_1" 
		d_wonfac = this.GetItemDecimal(lrow, "minqt_1")	
		this.setitem(lrow, 'minqt', d_wonfac)
End Choose



end event

event itemerror;return 1
end event

event rbuttondown;int lreturnrow, lrow
string snull 

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
setnull(snull)

lrow = this.getrow()

IF this.GetColumnName() = "citnbr" THEN
	gs_code = this.GetText()
	IF Gs_code ="" OR IsNull(gs_code) THEN 
		gs_code =""
	END IF
	
//	gs_gubun = '2'
	Open(w_itemas_popup3)
	
	IF isnull(gs_Code)  or  gs_Code = ''	then  
		this.SetItem(lrow, "citnbr", snull)
		this.SetItem(lrow, "itdsc", snull)
		this.SetItem(lrow, "ispec", snull)
   	return
   ELSE
		lReturnRow = This.Find("citnbr = '"+gs_code+"' ", 1, This.RowCount())
		IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
			f_message_chk(37,'[소요품번]') 
			this.SetItem(lRow, "citnbr", sNull)
                this.SetItem(lRow, "itdsc", sNull)
                this.SetItem(lRow, "ispec", sNull)
			RETURN  1
		END IF
   END IF	
	this.SetItem(lrow, "citnbr", gs_Code)
	this.SetItem(lrow, "itdsc" , gs_Codename)
	this.SetItem(lrow, "ispec", gs_gubun)
END IF

end event

type dw_list2 from datawindow within w_pdm_t_00030
event ue_key pbm_dwnkey
event ue_pressenter pbm_dwnprocessenter
integer x = 1714
integer y = 1492
integer width = 2875
integer height = 784
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_dpm_t_00030_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_key;if keydown(KeyEnter!) AND this.getcolumnname() = "work_cost" then
   if this.rowcount() = this.getrow() then
      postevent(clicked!)
      return 1
   end if
end if


end event

event ue_pressenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;Int lRow, lReturnRow
string s_roslt, sNull, get_rfna1
decimal {3} d_decimal

SetNull(snull)

IF this.GetColumnName() = "roslt" THEN
	lRow  = this.GetRow()	
	s_roslt = this.GetText()								
    
	if s_roslt = "" or isnull(s_roslt) then 
		this.setitem(lrow, 'opdsc', snull)
		return 
	end if
	 
    	SELECT  "REFFPF"."RFNA1"
	INTO      :get_rfna1
    	FROM    "REFFPF"  
   	WHERE ( "REFFPF"."RFCOD" = '21' ) AND  
                  ( "REFFPF"."RFGUB" =  :s_roslt ) AND  
                  ( "REFFPF"."SABU" = :gs_sabu ) ;

	if sqlca.sqlcode = 0 then 
		this.setitem(lrow, 'labor_opdsc', get_rfna1)
     end if	
	
	lReturnRow = This.Find("roslt = '"+s_roslt+"' ", 1, This.RowCount())
	IF (lRow <> lReturnRow) and (lReturnRow <> 0) THEN
		messagebox('확 인','등록된 공정코드입니다. ') 
		RETURN  1
	END IF
END IF

// - 노무비
IF 	this.GetColumnName() = "labor_cost_1" THEN
	d_decimal = this.GetItemDecimal(lrow, "labor_cost_1")	
	this.setitem(lrow, 'labor_cost', d_decimal)
//	RETURN  
END IF

// - 경비금액
IF 	this.GetColumnName() = "amount_cost_1" THEN
	d_decimal = this.GetItemDecimal(lrow, "amount_cost_1")	
	this.setitem(lrow, 'amount_cost', d_decimal)
//	RETURN  
END IF

// - 가공비
IF	this.GetColumnName() = "work_cost_1" THEN
	d_decimal = this.GetItemDecimal(lrow, "work_cost_1")	
	this.setitem(lrow, 'work_cost', d_decimal)
//	RETURN  
END IF

end event

event dberror;Beep(1)
IF f_message_chk(sqldbcode,'['+String(row)+'라인 ]') = -1 THEN
	Return
ELSE
	Return -1
END IF
end event

event editchanged;ib_any_typing =True
end event

event itemerror;return 1
end event

type st_2 from statictext within w_pdm_t_00030
integer x = 1714
integer y = 292
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "1) 재료비"
long bordercolor = 16711680
boolean focusrectangle = false
end type

type st_3 from statictext within w_pdm_t_00030
integer x = 1714
integer y = 1292
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 32106727
string text = "2) 노무비"
long bordercolor = 16711680
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_pdm_t_00030
event ue_key pbm_dwnkey
integer x = 37
integer y = 28
integer width = 2167
integer height = 208
integer taborder = 90
boolean bringtotop = true
string title = "none"
string dataobject = "d_dpm_t_00030_0"
boolean border = false
boolean livescroll = true
boolean righttoleft = true
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event itemchanged;
String	ls_eco_no, ls_itnbr, ls_sub1, ls_sub2, ls_nm
this.AcceptText()
//------------------------------------------Eco No
IF GetColumnName() = 'eco_no' THEN
	
	ls_eco_no = this.GetText()
	
	IF ls_eco_no = '' Or IsNull(ls_eco_no) THEN
		SetItem(1, 'itdsc','')
		SetItem(1, 'rfna1','')
		SetITem(1, 'gritu', '')	
		SetItem(1, 'itnbr','')
		Return
	END IF
	
	ls_itnbr =  Trim(dw_1.getitemstring(1,'itnbr'))
	

	Select	     b.itdsc  ,    b.gritu , c.rfna1      
	Into		:ls_sub1,  :ls_sub2, :ls_nm
	From		ecomst a , itemas b, reffpf c
	Where		a.eco_no =  :ls_eco_no
	and		a.itnbr =  :ls_itnbr
	and		a.itnbr = b.itnbr
	and		b.useyn = '0'	
	and		b.gritu = c.rfgub
	and		c.rfcod = '01' ;

	IF sqlca.SqlCode <> 0 THEN
		MessageBox('확인', '등록되지 않은 ECO NO. 입니다.')
		SetItem(1, 'itdsc','')
		SetItem(1, 'rfna1','')
		SetITem(1, 'gritu', '')	
		SetItem(1, 'itnbr','')
		SetItem(1, 'eco_no','')
		Return 1
	END IF

	SetITem(1, 'itdsc', ls_sub1)
	SetITem(1, 'gritu',  ls_sub2)	
	SetITem(1, 'rfna1',  ls_nm)	
	
//------------------------------------------참조명 (차종)

	wf_all_retrieve(ls_itnbr, ls_eco_no)
END IF

end event

event itemerror;return 1
end event

event rbuttondown;String seco_no, snull

SetNull(snull)

this.AcceptText()

//++ ECO NO  +++++++++++++++++++++++++++++++++++++++++++++++++++
IF this.GetColumnName() = "eco_no" THEN
	
     SetNull(gs_code)
	SetNull(gs_codename)
	
	Open(W_Ecomst_PopUp)
	
	IF IsNull(gs_code) THEN Return
	
	this.SetItem(1,"eco_no",gs_code)
	this.SetItem(1,"itnbr",     gs_codename)
	
	this.TriggerEvent(ItemChanged!)
ELSEIF this.GetColumnName() = "itnbr" THEN

     SetNull(gs_code)
	SetNull(gs_codename)
	
	Open(w_itemas_popup)
	
	this.SetItem(this.GetRow(),"itnbr",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF

ib_any_typing = True
end event

event losefocus;if this.accepttext() = -1 then return 
end event

type p_1 from uo_picture within w_pdm_t_00030
integer x = 4064
integer y = 308
integer width = 178
integer taborder = 10
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\행추가2_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\행추가2_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행추가2_dn.gif'
end event

event clicked;call super::clicked;Int    il_currow,il_RowCount  
String s_code, s_nm, s_Itnbr, s_Eco_no

dw_1.accepttext()

s_Eco_no = dw_1.GetItemString(1,"eco_no")
s_Itnbr      = dw_1.GetItemString(1,"itnbr")
s_nm        =  dw_1.GetItemString(1,"itdsc")

IF (IsNull(s_Eco_no) OR s_Eco_no = "" ) and   (IsNull(s_nm)    OR s_nm = "" )    THEN
	f_message_chk(30,'[ECO NO.]')
     dw_1.SetColumn("eco_no")
	dw_1.SetFocus()
	Return
END IF

IF dw_list.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = dw_list.GetRow()
	il_RowCount = dw_list.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_rowCount
	END IF

END IF

il_currow = il_rowCount + 1

s_code = string(il_currow)

dw_list.InsertRow(il_currow)
dw_list.SetItem(il_currow,"usseq",s_code)
// Key Value Move
dw_list.SetItem(1, 'sabu', gs_sabu)
dw_list.SetItem(1, 'itnbr', s_Itnbr)
dw_list.SetItem(1, 'eco_no', s_Eco_no)

dw_list.ScrollToRow(il_currow)
dw_list.SetColumn("citnbr")
dw_list.SetFocus()

end event

type p_2 from uo_picture within w_pdm_t_00030
integer x = 4261
integer y = 308
integer width = 178
integer taborder = 10
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\행삭제2_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\erpman\image\행삭제2_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행삭제2_dn.gif'
end event

event clicked;call super::clicked;dw_list.AcceptText()

IF dw_list.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

dw_list.DeleteRow(0)

dw_list.ScrollToRow(dw_list.RowCount())
dw_list.Setfocus()

end event

type p_3 from uo_picture within w_pdm_t_00030
integer x = 4064
integer y = 1308
integer width = 178
integer taborder = 10
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\행추가2_up.gif"
end type

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\행추가2_up.gif'
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행추가2_dn.gif'
end event

event clicked;call super::clicked;Int    il_currow,il_RowCount  
String s_code, s_nm, s_Eco_no, s_Itnbr
Decimal {3} d_calc

dw_1.accepttext()

s_Eco_no = dw_1.GetItemString(1,"eco_no")
s_Itnbr      = dw_1.GetItemString(1,"itnbr")
s_nm        =  dw_1.GetItemString(1,"itdsc")

IF (IsNull(s_Eco_no) OR s_Eco_no = "" ) and   (IsNull(s_nm)    OR s_nm = "" )    THEN
	f_message_chk(30,'[ECO NO.]')
     dw_1.SetColumn("eco_no")
	dw_1.SetFocus()
	Return
END IF

D_calc           =  dw_insert.GetItemDecimal(1,"margin_rate")
IF  d_calc <= 0     THEN
	MessageBox("확 인", "여유율을 먼저 입력하세요.")
     dw_insert.SetColumn("margin_rate")
	dw_insert.SetFocus()
	Return
END IF

IF dw_list2.RowCount() <=0 THEN
	il_currow = 0
	il_rowCount = 0
ELSE
	il_currow = dw_list2.GetRow()
	il_RowCount = dw_list2.RowCount()
	
	IF il_currow <=0 THEN
		il_currow = il_rowCount
	END IF

END IF

il_currow = il_rowCount + 1
s_code = string(il_currow)

d_calc = dw_insert.GetItemDecimal(1,"margin_rate")
dw_list2.InsertRow(il_currow)
dw_list2.SetItem(il_currow,"opseq",s_code)
dw_list2.SetItem(1, 'temp', d_calc)   // 여유율(계산공식위해)
// Key Value Move
dw_list2.SetItem(1, 'sabu', gs_sabu)
dw_list2.SetItem(1, 'itnbr', s_Itnbr)
dw_list2.SetItem(1, 'eco_no', s_Eco_no)

dw_list2.ScrollToRow(il_currow)
dw_list2.SetColumn("roslt")
dw_list2.SetFocus()

end event

type p_4 from uo_picture within w_pdm_t_00030
integer x = 4261
integer y = 1308
integer width = 178
integer taborder = 10
boolean bringtotop = true
string pointer = "C:\erpman\cur\retrieve.cur"
boolean originalsize = true
string picturename = "C:\erpman\image\행삭제2_up.gif"
end type

event clicked;call super::clicked;dw_list2.AcceptText()

IF dw_list2.GetRow() <=0 THEN
	f_message_chk(36,'')
	Return
END IF

dw_list2.DeleteRow(0)

dw_list2.ScrollToRow(dw_list2.RowCount())
dw_list2.Setfocus()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\행삭제2_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;pictureName = "C:\erpman\image\행삭제2_up.gif"
end event

type rb_insert from radiobutton within w_pdm_t_00030
boolean visible = false
integer x = 2240
integer y = 136
integer width = 251
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "등록"
boolean checked = true
end type

event clicked;
ls_gub = 'Y'	// 등록

wf_Init()
end event

type rb_delete from radiobutton within w_pdm_t_00030
boolean visible = false
integer x = 2514
integer y = 136
integer width = 251
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "수정"
end type

event clicked;ls_gub = 'N'	// 수정

wf_Init()
end event

type pb_1 from u_pb_cal within w_pdm_t_00030
integer x = 1554
integer y = 336
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_insert.SetColumn('end_date')
IF Isnull(gs_code) THEN Return
dw_insert.SetItem(dw_insert.getrow(), 'end_date', gs_code)
end event

type rr_3 from roundrectangle within w_pdm_t_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 280
integer width = 1623
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pdm_t_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1701
integer y = 284
integer width = 2903
integer height = 972
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pdm_t_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1701
integer y = 1284
integer width = 2903
integer height = 1008
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pdm_t_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4027
integer y = 296
integer width = 439
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_pdm_t_00030
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 4027
integer y = 1296
integer width = 439
integer height = 176
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pdm_t_00030
boolean visible = false
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2213
integer y = 104
integer width = 567
integer height = 116
integer cornerheight = 40
integer cornerwidth = 55
end type

