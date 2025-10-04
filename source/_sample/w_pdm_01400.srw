$PBExportHeader$w_pdm_01400.srw
$PBExportComments$** 조 코드 등록
forward
global type w_pdm_01400 from w_inherite
end type
type rr_1 from roundrectangle within w_pdm_01400
end type
end forward

global type w_pdm_01400 from w_inherite
string title = "블럭 코드 등록"
rr_1 rr_1
end type
global w_pdm_01400 w_pdm_01400

forward prototypes
public function integer wf_required_chk ()
public function boolean wf_duplication_chk (integer crow)
public function integer wf_delete_chk (string sjocod)
end prototypes

public function integer wf_required_chk ();//필수입력항목 체크
Long i

for i = 1 to dw_insert.RowCount()
	if Isnull(dw_insert.object.jocod[i]) or dw_insert.object.jocod[i] =  "" then
	   f_message_chk(1400,'[조코드]')
	   dw_insert.SetColumn('jocod')
	   dw_insert.SetFocus()
	   return -1
   end if	
	
	if Isnull(dw_insert.object.jonam[i]) or dw_insert.object.jonam[i] =  "" then
	   f_message_chk(1400,'[조명]')
	   dw_insert.SetColumn('jonam')
	   dw_insert.SetFocus()
	   return -1
   end if
	
	if Isnull(dw_insert.object.pdtgu[i]) or dw_insert.object.pdtgu[i] =  "" then
	   f_message_chk(1400,'[생산팀]')
	   dw_insert.SetColumn('pdtgu')
	   dw_insert.SetFocus()
	   return -1
   end if
	if Isnull(dw_insert.object.dptno[i]) or dw_insert.object.dptno[i] =  "" then
	   f_message_chk(1400,'[부서]')
	   dw_insert.SetColumn('dptno')
	   dw_insert.SetFocus()
	   return -1
   end if
next

return 1
end function

public function boolean wf_duplication_chk (integer crow);String s1
long   ll_frow

dw_insert.AcceptText()

s1 = dw_insert.object.jocod[crow]

ll_frow = dw_insert.Find("jocod = '" + s1 + "'", 1, crow - 1)
if ll_frow = crow then
elseif not (IsNull(ll_frow) or ll_frow < 1) then
	f_message_chk(1, "[" + String(ll_Frow) + " 번째ROW]")
	return False
end if

ll_frow = dw_insert.Find("jocod = '" + s1 + "'", crow + 1, dw_insert.RowCount())

if ll_frow = crow then
elseif not (IsNull(ll_frow) or ll_frow < 1) then
	f_message_chk(1, "[" + String(ll_Frow) + " 번째ROW]")
	return False
end if

return true
end function

public function integer wf_delete_chk (string sjocod);long  l_cnt

l_cnt = 0
SELECT COUNT(*)
  INTO :l_cnt
  FROM JODETL
 WHERE JOCOD = :sjocod;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[조별인원]')
	return -1
end if

l_cnt = 0
SELECT COUNT(*)
  INTO :l_cnt  
  FROM WRKCTR  
 WHERE JOCOD = :sjocod   ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[작업장마스타]')
	return -1
end if

l_cnt = 0
SELECT COUNT(*)
  INTO :l_cnt  
  FROM MOROUT
 WHERE SABU = :gs_sabu AND JOCOD = :sjocod   ;

if sqlca.sqlcode <> 0 or l_cnt >= 1 then
	f_message_chk(38,'[작업공정]')
	return -1
end if

return 1
end function

on w_pdm_01400.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdm_01400.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_insert.SetTransObject(SQLCA)
dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Retrieve()
dw_insert.Setredraw(True)
dw_insert.SetFocus()
end event

type dw_insert from w_inherite`dw_insert within w_pdm_01400
integer x = 110
integer y = 200
integer width = 4416
integer height = 2064
integer taborder = 20
string dataobject = "d_pdm_01400_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemerror;RETURN 1
end event

event dw_insert::itemchanged;String sCol, s_dptno, s_name, s_name2
int    ireturn

sCol = this.GetColumnName()
if sCol = "jocod" then
	if wf_duplication_chk(row) = False then
		this.object.jocod[row] = ""
		this.object.jonam[row] = ""
		this.SetColumn("jocod")
		return 1
	end if	
//elseif sCol = "pdtgu" then
//	String  s_pdtgu, s_bucod, s_bunam
//		
//	s_pdtgu = this.object.pdtgu[row]
//	
//	SELECT R.RFNA2, V.CVNAS
//	INTO   :s_bucod, :s_bunam
//   FROM   REFFPF R, VNDMST V
//   WHERE  R.RFCOD = '03'
//   AND    R.RFGUB = :s_pdtgu
//   AND    R.RFNA2 = V.CVCOD (+); 
//
//   if sqlca.sqlcode <> -1 then
//		this.object.dptno[row] = s_bucod
//		this.object.cvnas[row] = s_bunam
//	else	
//		this.object.dptno[row] = " "
//		this.object.cvnas[row] = " "
//	end if	
//	this.AcceptText()
elseif sCol = "dptno" then
	s_dptno = this.gettext()
 
   ireturn = f_get_name2('부서', 'Y', s_dptno, s_name, s_name2)
	this.SetItem(Row, "dptno", s_dptno)
	this.SetItem(Row, "cvnas", s_name)
  	return ireturn 
end if	

end event

event dw_insert::getfocus;w_mdi_frame.sle_msg.Text = ""
end event

event dw_insert::itemfocuschanged;String ColName

ColName = this.GetColumnName()
if (ColName = "jocod") Then
	f_toggle_eng(Handle(this))
elseif (ColName = "jonam") Then
	f_toggle_kor(Handle(this))
end if	
end event

event dw_insert::rbuttondown;SetNull(Gs_code)
SetNull(Gs_codename)

IF this.GetColumnName() = "dptno" THEN
	
	Open(w_vndmst_4_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(this.getrow(), "dptno", gs_Code)
	this.SetItem(this.getrow(), "cvnas", gs_Codename)
END IF
end event

event dw_insert::updatestart;/* Update() function 호출시 user 설정 */
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

type p_delrow from w_inherite`p_delrow within w_pdm_01400
boolean visible = false
integer x = 2450
integer y = 2300
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_pdm_01400
boolean visible = false
integer x = 2263
integer y = 2300
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_pdm_01400
boolean visible = false
integer x = 1714
integer y = 2292
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_pdm_01400
integer x = 3680
integer taborder = 10
end type

event p_ins::clicked;call super::clicked;Long crow

dw_insert.Setredraw(False)
crow = dw_insert.InsertRow(dw_insert.GetRow() + 1)
if IsNull(crow) then 
	dw_insert.InsertRow(0)
end if	
dw_insert.ScrollToRow(crow)
dw_insert.Setredraw(True)
dw_insert.SetColumn("jocod") 
dw_insert.SetFocus()

end event

type p_exit from w_inherite`p_exit within w_pdm_01400
integer x = 4375
integer taborder = 60
end type

type p_can from w_inherite`p_can within w_pdm_01400
integer x = 4201
integer taborder = 50
end type

event p_can::clicked;call super::clicked;w_mdi_frame.sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_insert.Setredraw(False)
dw_insert.ReSet()
dw_insert.Retrieve()
dw_insert.Setredraw(True)

dw_insert.SetFocus()
w_mdi_frame.sle_msg.Text = "최종 저장 후의 작업을 취소 하였습니다!"
ib_any_typing = False //입력필드 변경여부 No


end event

type p_print from w_inherite`p_print within w_pdm_01400
boolean visible = false
integer x = 1888
integer y = 2292
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_pdm_01400
boolean visible = false
integer x = 2075
integer y = 2300
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_pdm_01400
integer x = 4027
integer taborder = 40
end type

event p_del::clicked;call super::clicked;long 	lcRow
String s_jocod

IF dw_insert.accepttext() = -1 then return 

lcRow = dw_insert.GetRow()
if lcRow <= 0 then return

s_jocod = dw_insert.object.jocod[lcRow]

if wf_delete_chk(s_jocod) = -1 then return 

if f_msg_delete() = -1 then return

dw_insert.SetRedraw(False)
dw_insert.DeleteRow(lcRow)
IF dw_insert.Update() = 1 THEN
	COMMIT;
	w_mdi_frame.sle_msg.Text = "삭제 되었습니다!"
ELSE
	ROLLBACK;
	f_message_chk(31,'[삭제실패]') 
	dw_insert.SetRedraw(True)
	Return
END IF

dw_insert.SetRedraw(True)
ib_any_typing = False //입력필드 변경여부 No
end event

type p_mod from w_inherite`p_mod within w_pdm_01400
integer x = 3854
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;if dw_insert.AcceptText() = -1 then return 

if wf_required_chk() = -1 then return //필수입력항목 체크 

if f_msg_update() = -1 then return  //저장 Yes/No ?

if dw_insert.Update() = 1 then
	COMMIT;
	w_mdi_frame.sle_msg.text = "저장 되었습니다!"	
	ib_any_typing = False //입력필드 변경여부 No
else
	f_message_chk(32,'[자료저장 실패]') 
	ROLLBACK;
   w_mdi_frame.sle_msg.text = "저장작업 실패 하였습니다!"
	return 
end if
 
end event

type cb_exit from w_inherite`cb_exit within w_pdm_01400
integer x = 4041
integer y = 2328
end type

type cb_mod from w_inherite`cb_mod within w_pdm_01400
integer x = 2999
integer y = 2328
end type

type cb_ins from w_inherite`cb_ins within w_pdm_01400
integer x = 2651
integer y = 2328
string text = "추가(&A)"
end type

type cb_del from w_inherite`cb_del within w_pdm_01400
integer x = 3346
integer y = 2328
end type

type cb_inq from w_inherite`cb_inq within w_pdm_01400
integer x = 393
integer y = 2320
end type

type cb_print from w_inherite`cb_print within w_pdm_01400
integer x = 1253
integer y = 2336
end type

type st_1 from w_inherite`st_1 within w_pdm_01400
end type

type cb_can from w_inherite`cb_can within w_pdm_01400
integer x = 3694
integer y = 2328
end type

type cb_search from w_inherite`cb_search within w_pdm_01400
integer x = 750
integer y = 2336
end type





type gb_10 from w_inherite`gb_10 within w_pdm_01400
integer x = 37
integer y = 2112
integer height = 140
integer textsize = -8
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

type gb_button1 from w_inherite`gb_button1 within w_pdm_01400
end type

type gb_button2 from w_inherite`gb_button2 within w_pdm_01400
end type

type rr_1 from roundrectangle within w_pdm_01400
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 96
integer y = 192
integer width = 4443
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

