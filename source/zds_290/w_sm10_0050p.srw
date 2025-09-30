$PBExportHeader$w_sm10_0050p.srw
$PBExportComments$MOBIS AUTO 주간 소요 현황
forward
global type w_sm10_0050p from w_inherite
end type
type p_1 from uo_picture within w_sm10_0050p
end type
type p_dellrow_all from uo_picture within w_sm10_0050p
end type
type rr_1 from roundrectangle within w_sm10_0050p
end type
type dw_1 from datawindow within w_sm10_0050p
end type
type pb_1 from u_pb_cal within w_sm10_0050p
end type
type pb_2 from u_pb_cal within w_sm10_0050p
end type
type p_preview from picture within w_sm10_0050p
end type
type dw_print from datawindow within w_sm10_0050p
end type
end forward

global type w_sm10_0050p from w_inherite
string title = "MOBIS AUTO주간소요 현황"
p_1 p_1
p_dellrow_all p_dellrow_all
rr_1 rr_1
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
p_preview p_preview
dw_print dw_print
end type
global w_sm10_0050p w_sm10_0050p

type variables
Long il_succeed , il_err
end variables

forward prototypes
public subroutine wf_init ()
end prototypes

public subroutine wf_init ();dw_1.SetTransObject(SQLCA)
dw_insert.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_1.Reset()
dw_1.InsertRow(0)
dw_1.Object.jisi_date[1] = is_today
dw_1.Object.jisi_date2[1] = is_today

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_1.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_1.Modify("saupj.protect=1")
   End if
End If
end subroutine

on w_sm10_0050p.create
int iCurrent
call super::create
this.p_1=create p_1
this.p_dellrow_all=create p_dellrow_all
this.rr_1=create rr_1
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.p_preview=create p_preview
this.dw_print=create dw_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.p_dellrow_all
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.p_preview
this.Control[iCurrent+8]=this.dw_print
end on

on w_sm10_0050p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_1)
destroy(this.p_dellrow_all)
destroy(this.rr_1)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.p_preview)
destroy(this.dw_print)
end on

event open;call super::open;wf_init()




end event

type dw_insert from w_inherite`dw_insert within w_sm10_0050p
integer x = 55
integer y = 360
integer width = 4530
integer height = 1900
string dataobject = "d_sm10_0050p_2"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::clicked;call super::clicked;f_multi_select(dw_insert)
end event

type p_delrow from w_inherite`p_delrow within w_sm10_0050p
boolean visible = false
integer x = 4096
boolean enabled = false
end type

event p_delrow::clicked;call super::clicked;Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust
DataWindow ldw_x

ldw_x = dw_insert

ll_rcnt = ldw_x.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
	Return
End IF
if f_msg_delete() = -1 then return

ldw_x.SetRedraw(FALSE)

For i = ll_rcnt To 1 Step -1
	If ldw_x.isSelected(i) Then
		ldw_x.ScrollToRow(i)
		ldw_x.DeleteRow(i)
	End iF
Next


if ldw_x.Update() = 1 then
	
	commit ;
	sle_msg.text =	"모든자료를 삭제하였습니다!!"	
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
ldw_x.SetRedraw(TRUE)






end event

type p_addrow from w_inherite`p_addrow within w_sm10_0050p
boolean visible = false
end type

type p_search from w_inherite`p_search within w_sm10_0050p
boolean visible = false
integer x = 3342
integer y = 56
end type

type p_ins from w_inherite`p_ins within w_sm10_0050p
boolean visible = false
integer x = 3749
end type

type p_exit from w_inherite`p_exit within w_sm10_0050p
end type

event p_exit::clicked;//
Close(parent)
end event

type p_can from w_inherite`p_can within w_sm10_0050p
boolean visible = false
end type

type p_print from w_inherite`p_print within w_sm10_0050p
integer x = 4096
string picturename = "C:\erpman\image\인쇄_d.gif"
end type

event p_print::clicked;call super::clicked;IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_inq from w_inherite`p_inq within w_sm10_0050p
integer x = 3922
end type

event p_inq::clicked;call super::clicked;String ls_ymd , ls_ymd2 , ls_saupj , ls_factory ,ls_gubun, tx_saupj, tx_mcvcod
String ls_itnbr_from, ls_itnbr_to, ls_from, ls_to
Integer li_no

dw_1.AcceptText() 

ls_saupj = Trim(dw_1.Object.saupj[1])
ls_factory =Trim(dw_1.Object.factory[1])
ls_itnbr_from = Trim(dw_1.Object.itnbr_from[1])
if IsNull(ls_itnbr_from) or ls_itnbr_from = '' then ls_itnbr_from = ''
ls_itnbr_to = Trim(dw_1.Object.itnbr_to[1])
if IsNull(ls_itnbr_to) or ls_itnbr_to = '' then ls_itnbr_to = ''

ls_ymd = Trim(dw_1.Object.jisi_date[1])
ls_ymd2 = Trim(dw_1.Object.jisi_date2[1])

// 품번 전체를 검색 할 때에 ITEMAS의 최소, 최고 품번을 조회한다.	
IF ls_itnbr_from = '' and ls_itnbr_to = '' THEN	
	SELECT MIN(ITNBR), MAX(ITNBR) 
	INTO   :ls_from, :ls_to
	FROM   ITEMAS;
	
	If sqlca.sqlcode <> 0 Then
		MessageBox('에러','품번마스터를 조회할 수 없습니다.~n전산실에 문의 바랍니다.')
		Return -1
	End If
	li_no = 1
ELSE
	ls_from = ls_itnbr_from
	ls_to = ls_itnbr_to
	li_no = 2
END IF

if dw_insert.Retrieve(ls_saupj , ls_ymd , ls_ymd2, ls_from, ls_to , ls_factory, li_no) < 1 then
	p_print.enabled = False
	p_preview.enabled = False	
	
	p_print.picturename = "c:\erpman\image\인쇄_d.gif"
	p_preview.picturename = "c:\erpman\image\미리보기_d.gif"
	f_message_chk(50,"")
	return -1
end if

//dw_insert.sharedata(dw_print)
if dw_print.Retrieve(ls_saupj , ls_ymd , ls_ymd2, ls_from, ls_to , ls_factory, li_no) < 1 then
	f_message_chk(50,"")
	return -1
end if

p_print.enabled = True
p_preview.enabled = True	

p_print.picturename = "c:\erpman\image\인쇄_up.gif"
p_preview.picturename = "c:\erpman\image\미리보기_up.gif"
	
//Report   검색조건 값 Display
dw_print.Modify("t_sdate.text = '"+String(ls_ymd,'@@@@.@@.@@')+"'")
dw_print.Modify("t_tdate.text = '"+String(ls_ymd2,'@@@@.@@.@@')+"'")

tx_saupj = Trim(dw_1.Describe("Evaluate('LookUpDisplay(saupj)', 1)"))
tx_mcvcod = Trim(dw_1.Describe("Evaluate('LookUpDisplay(mcvcod)', 1)"))

If IsNull(tx_saupj) Or tx_saupj = '' Then tx_saupj = '전체'
dw_print.Modify("tx_saupj.text = '"+tx_saupj+"'")
dw_print.Modify("tx_cvcod.text = '"+tx_mcvcod+"'")

if ls_factory = '' or ls_factory = '%' then 
	dw_print.Modify("tx_factory.text = '전체'")
else
	dw_print.Modify("tx_factory.text = '"+ls_factory+"'")
end if

dw_print.Modify("tx_itnbr_from.text = '"+ls_itnbr_from+"'")
dw_print.Modify("tx_itnbr_to.text = '"+ls_itnbr_to+"'")
end event

type p_del from w_inherite`p_del within w_sm10_0050p
boolean visible = false
end type

type p_mod from w_inherite`p_mod within w_sm10_0050p
boolean visible = false
end type

type cb_exit from w_inherite`cb_exit within w_sm10_0050p
end type

type cb_mod from w_inherite`cb_mod within w_sm10_0050p
end type

type cb_ins from w_inherite`cb_ins within w_sm10_0050p
end type

type cb_del from w_inherite`cb_del within w_sm10_0050p
end type

type cb_inq from w_inherite`cb_inq within w_sm10_0050p
end type

type cb_print from w_inherite`cb_print within w_sm10_0050p
end type

type st_1 from w_inherite`st_1 within w_sm10_0050p
end type

type cb_can from w_inherite`cb_can within w_sm10_0050p
end type

type cb_search from w_inherite`cb_search within w_sm10_0050p
end type







type gb_button1 from w_inherite`gb_button1 within w_sm10_0050p
end type

type gb_button2 from w_inherite`gb_button2 within w_sm10_0050p
end type

type p_1 from uo_picture within w_sm10_0050p
boolean visible = false
integer x = 3680
integer y = 24
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\생성_up.gif"
end type

event clicked;call super::clicked;String ls_saupj , ls_cvcod , ls_ymd ,ls_gubun ,ls_itnbr , ls_mitnbr , ls_filename , ls_itdsc
uo_xlobject uo_xl
string ls_docname, ls_named ,ls_line 
Long   ll_xl_row , ll_r , i , ll_cnt=0

String ls_crt_date , ls_crt_time , ls_crt_user

If dw_1.AcceptText() <> 1 Then Return

ls_ymd   = Trim(dw_1.Object.jisi_date[1]) 
ls_cvcod = Trim(dw_1.Object.mcvcod[1]) 
ls_saupj = Trim(dw_1.Object.saupj[1]) 
ls_gubun = Trim(dw_1.Object.gubun[1])
ls_filename = Trim(dw_1.Object.filename[1])

If IsNull(ls_ymd) Or ls_ymd = '' Then
	f_message_chk(1400,'[등록일자]')
	Return
End If


//Choose Case ls_gubun 
//	Case '1' // 일납품 계획 
//		wf_sch(ls_filename)
//	Case '2'
//		wf_sil(ls_filename)
//End Choose 
end event

type p_dellrow_all from uo_picture within w_sm10_0050p
boolean visible = false
integer x = 3936
integer y = 24
boolean bringtotop = true
boolean enabled = false
string picturename = "C:\erpman\image\전체삭제_up.gif"
end type

event clicked;call super::clicked;Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_date , ls_saupj_cust
DataWindow ldw_x

ldw_x = dw_insert

ll_rcnt = ldw_x.RowCount()

If ll_rcnt < 1 Then 
	MessageBox('확인','삭제할 데이타가 존재하지 않습니다.')
	Return
End IF
if f_msg_delete() = -1 then return

ldw_x.SetRedraw(FALSE)

For i = ll_rcnt To 1 Step -1
	
	ldw_x.ScrollToRow(i)
	ldw_x.DeleteRow(i)
	
Next

if ldw_x.Update() = 1 then
	
	commit ;
	sle_msg.text =	"모든자료를 삭제하였습니다!!"	
else
	rollback ;
   messagebox("저장실패", "자료에 대한 갱신이 실패하였읍니다")
end if	
ldw_x.SetRedraw(TRUE)
end event

type rr_1 from roundrectangle within w_sm10_0050p
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 32
integer y = 352
integer width = 4576
integer height = 1920
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from datawindow within w_sm10_0050p
integer x = 27
integer y = 12
integer width = 3035
integer height = 336
integer taborder = 50
string title = "none"
string dataobject = "d_sm10_0050p_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String ls_col , ls_value, ls_itnbr_t, ls_itnbr_f

ls_col = GetColumnName()
ls_value = Trim(GetText())

Choose Case ls_col
	Case "itnbr_from"
		ls_itnbr_t = Trim(This.GetItemString(row, 'itnbr_to'))
		if IsNull(ls_itnbr_t) or ls_itnbr_t = '' then
			This.SetItem(row, 'itnbr_to', ls_value)
	   end if
	Case "itnbr_to"
		ls_itnbr_f = Trim(This.GetItemString(row, 'itnbr_from'))
		if IsNull(ls_itnbr_f) or ls_itnbr_f = '' then
			This.SetItem(row, 'itnbr_from', ls_value)
	   end if
END CHOOSE
end event

type pb_1 from u_pb_cal within w_sm10_0050p
integer x = 818
integer y = 144
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('jisi_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'jisi_date', gs_code)

end event

type pb_2 from u_pb_cal within w_sm10_0050p
integer x = 1321
integer y = 144
integer height = 76
integer taborder = 80
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_1.SetColumn('jisi_date2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_1.SetItem(1, 'jisi_date2', gs_code)

end event

type p_preview from picture within w_sm10_0050p
event ue_lbuttonup pbm_lbuttonup
event ue_lbuttondown pbm_lbuttondown
integer x = 4270
integer y = 24
integer width = 178
integer height = 144
boolean bringtotop = true
string pointer = "C:\erpman\cur\preview.cur"
boolean enabled = false
string picturename = "C:\erpman\image\미리보기_d.gif"
boolean focusrectangle = false
end type

event ue_lbuttonup;IF This.Enabled = True THEN
	PictureName =  'C:\erpman\image\미리보기_up.gif'
END IF
end event

event ue_lbuttondown;IF This.Enabled = True THEN
	PictureName = 'C:\erpman\image\미리보기_dn.gif'
END IF

end event

event clicked;OpenWithParm(w_print_preview, dw_print)	
end event

type dw_print from datawindow within w_sm10_0050p
boolean visible = false
integer x = 3634
integer y = 32
integer width = 174
integer height = 148
integer taborder = 100
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm10_0050p_p"
boolean border = false
boolean livescroll = true
end type

