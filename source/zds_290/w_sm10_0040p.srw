$PBExportHeader$w_sm10_0040p.srw
$PBExportComments$모비스 VAN 현황
forward
global type w_sm10_0040p from w_standard_print
end type
type p_search from uo_picture within w_sm10_0040p
end type
type p_delrow from uo_picture within w_sm10_0040p
end type
type p_delrow_all from uo_picture within w_sm10_0040p
end type
type pb_1 from u_pb_cal within w_sm10_0040p
end type
type st_state from statictext within w_sm10_0040p
end type
type pb_2 from u_pb_cal within w_sm10_0040p
end type
type st_ing from statictext within w_sm10_0040p
end type
type p_excel from uo_picture within w_sm10_0040p
end type
type p_1 from uo_picture within w_sm10_0040p
end type
type rr_1 from roundrectangle within w_sm10_0040p
end type
end forward

global type w_sm10_0040p from w_standard_print
integer width = 4677
integer height = 2508
string title = "MOBIS A/S  VAN 현황"
boolean resizable = true
p_search p_search
p_delrow p_delrow
p_delrow_all p_delrow_all
pb_1 pb_1
st_state st_state
pb_2 pb_2
st_ing st_ing
p_excel p_excel
p_1 p_1
rr_1 rr_1
end type
global w_sm10_0040p w_sm10_0040p

type variables
String is_custid , is_path
Long il_err , il_succeed
end variables

forward prototypes
public function integer wf_retrieve ()
public subroutine wf_error (string as_gubun, long al_line, string as_doccode, string as_factory, string as_itnbr, string as_errtext)
public subroutine wf_initial ()
end prototypes

public function integer wf_retrieve ();/*
Long i ,ll_rcnt
string ls_gubun ,ls_saupj , ls_cvcod ,ls_sdate  ,ls_edate, ls_saupj_cust , ls_itnbr
DataWindow ldw_x

if dw_ip.AcceptText() = -1 then return -1
if dw_ip.rowcount() <= 0 then return -1

ls_gubun = Trim(dw_ip.Object.gubun[1]) 
ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_cvcod = Trim(dw_ip.Object.mcvcod[1])

ls_sdate = Trim(dw_ip.Object.jisi_date[1])
ls_edate = Trim(dw_ip.Object.jisi_date2[1])

ls_itnbr = Trim(dw_ip.Object.itnbr[1])

If ls_itnbr = '' Or isNull(ls_itnbr) Then ls_itnbr = '%'

SetNull(ls_saupj_cust)
*/

//select fun_get_reffpf_value('AD',:ls_saupj,'4') Into :ls_saupj_cust
//  from dual ;
//If sqlca.sqlcode <> 0 Or ls_saupj_cust = '' Or isNull(ls_saupj_cust) Then
//	MessageBox('확인','사업장을 선택하세요')
//	Return -1
//End If

/*
Choose Case ls_gubun 
	Case 'AR'
		ldw_x = dw_ar
		ldw_x.Retrieve(ls_saupj, ls_itnbr )
	Case 'BR'
		ldw_x = dw_br
		ldw_x.Retrieve(ls_saupj, ls_itnbr )		
	Case 'ER'
		ldw_x = dw_er
		ldw_x.Retrieve(ls_saupj, ls_itnbr )		
	Case 'FR'
		ldw_x = dw_fr
		ldw_x.Retrieve(ls_saupj, ls_itnbr )		
	Case 'NR'
		ldw_x = dw_nr
		ldw_x.Retrieve(ls_saupj  , ls_sdate ,ls_edate, ls_itnbr )		
	Case 'OR'
		ldw_x = dw_or
		ldw_x.Retrieve(ls_saupj  , ls_sdate ,ls_edate, ls_itnbr )		
	Case 'HR'
		ldw_x = dw_hr
		ldw_x.Retrieve(ls_saupj  , ls_sdate ,ls_edate, ls_itnbr )		
End Choose
*/
Return 1
end function

public subroutine wf_error (string as_gubun, long al_line, string as_doccode, string as_factory, string as_itnbr, string as_errtext);Long ll_r

ll_r = dw_list.InsertRow(0)

dw_list.Object.saupj[ll_r] = Trim(dw_ip.Object.saupj[1])
dw_list.Object.err_date[ll_r] = Trim(dw_ip.Object.jisi_date[1])
dw_list.Object.err_time[ll_r] = f_totime()
dw_list.Object.doctxt[ll_r] = as_gubun
dw_list.Object.err_line[ll_r] = al_line
dw_list.Object.doccode[ll_r] = as_doccode
dw_list.Object.factory[ll_r] = as_factory
dw_list.Object.itnbr[ll_r] = as_itnbr
dw_list.Object.err_txt[ll_r] = as_errtext

dw_list.scrolltorow(ll_r)
end subroutine

public subroutine wf_initial ();dw_list.setredraw(false)
dw_list.reset()
dw_list.insertrow(0)
dw_list.setredraw(true)
/*
	p_print.enabled = False
	p_preview.enabled = False
	
	p_print.picturename = "c:\erpman\image\인쇄_d.gif"
	p_preview.picturename = "c:\erpman\image\미리보기_d.gif"

*/


end subroutine

on w_sm10_0040p.create
int iCurrent
call super::create
this.p_search=create p_search
this.p_delrow=create p_delrow
this.p_delrow_all=create p_delrow_all
this.pb_1=create pb_1
this.st_state=create st_state
this.pb_2=create pb_2
this.st_ing=create st_ing
this.p_excel=create p_excel
this.p_1=create p_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_search
this.Control[iCurrent+2]=this.p_delrow
this.Control[iCurrent+3]=this.p_delrow_all
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.st_state
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.st_ing
this.Control[iCurrent+8]=this.p_excel
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.rr_1
end on

on w_sm10_0040p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.p_search)
destroy(this.p_delrow)
destroy(this.p_delrow_all)
destroy(this.pb_1)
destroy(this.st_state)
destroy(this.pb_2)
destroy(this.st_ing)
destroy(this.p_excel)
destroy(this.p_1)
destroy(this.rr_1)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_window_id = this.ClassName()
is_today = f_today()
is_totime = f_totime()
w_mdi_frame.st_window.Text = Upper(is_window_id)

SELECT "SUB2_T"."OPEN_HISTORY"  
  INTO :is_usegub 
  FROM "SUB2_T"  
 WHERE "SUB2_T"."WINDOW_NAME" = :is_window_id   ;

IF is_usegub = 'Y' THEN
   INSERT INTO "PGM_HISTORY"  
	 		 ( "L_USERID",   "CDATE",       "STIME",      "WINDOW_NAME",   "EDATE",   
			   "ETIME",      "IPADD",       "USER_NAME" )  
   VALUES ( :gs_userid,   :is_today,     :is_totime,   :is_window_id,   NULL, 
	   		NULL,         :gs_ipaddress, :gs_comname )  ;

   IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF

dw_ip.SetTransObject(SQLCA)
dw_ip.Reset()
dw_ip.InsertRow(0)

dw_print.settransobject(sqlca)
dw_print.Reset()
dw_print.InsertRow(0)

dw_list.settransobject(sqlca)

dw_ip.Object.jisi_date[1] = f_today()
dw_ip.Object.jisi_date2[1] = f_today()

pb_1.visible = false
pb_2.visible = false	

setnull(gs_code)
If f_check_saupj() = 1 Then
	dw_ip.SetItem(1, 'saupj', gs_code)
   if gs_code <> '%' then
   	dw_ip.Modify("saupj.protect=1")
   End if
End If

// U904 구분 *********************//
Select rfna5 Into :is_custid
  From reffpf
  Where rfcod = 'AD'
    and rfcod != '00' 
	 and rfgub = :gs_code ;
If sqlca.sqlcode <> 0 Then
	f_message_chk(33 ,'[사업장]')
	Return
End If
//************************************

dw_ip.Object.gubun[1] = 'AR'








end event

type p_xls from w_standard_print`p_xls within w_sm10_0040p
integer x = 3369
end type

type p_sort from w_standard_print`p_sort within w_sm10_0040p
integer x = 3191
end type

type p_preview from w_standard_print`p_preview within w_sm10_0040p
integer x = 3877
end type

type p_exit from w_standard_print`p_exit within w_sm10_0040p
integer x = 4398
end type

event p_exit::clicked;close(parent)

end event

type p_print from w_standard_print`p_print within w_sm10_0040p
integer x = 4050
end type

event p_print::clicked;//IF dw_1.visible then
//	OpenWithParm(w_print_options,dw_1)
//	dw_1.visible = FALSE
//	dw_list.visible = TRUE
//
//	p_retrieve.triggerevent('clicked')
//ELSE
//	IF dw_print.rowcount() > 0 then 
//		gi_page = dw_print.GetItemNumber(1,"last_page")
//	ELSE
//		gi_page = 1
//	END IF
//	OpenWithParm(w_print_options, dw_print)
//END IF
end event

type p_retrieve from w_standard_print`p_retrieve within w_sm10_0040p
integer x = 4224
end type

event p_retrieve::clicked;string ls_saupj, ls_itnbr, ls_gubun, ls_sdate, ls_edate, ls_gubun_hk
dw_ip.AcceptText()

ls_gubun_hk = '%' + trim(dw_ip.getitemstring(1,'gubun_hk')) + '%'
ls_gubun 	= trim(dw_ip.getitemstring(1,'gubun'))
ls_saupj		= trim(dw_ip.getitemstring(1,'saupj'))
ls_itnbr 	= trim(dw_ip.getitemstring(1,'itnbr'))
ls_sdate 	= trim(dw_ip.getitemstring(1,'jisi_date'))
ls_edate 	= trim(dw_ip.getitemstring(1,'jisi_date2'))

//messagebox(ls_saupj, ls_saupj)

if ls_gubun = 'AR' then 
	dw_list.Retrieve(ls_saupj, ls_itnbr, ls_gubun_hk )
	dw_list.ShareData(dw_print)		
elseif ls_gubun = 'BR' then 
	dw_list.Retrieve(ls_saupj, ls_itnbr, ls_gubun_hk  )
elseif ls_gubun = 'ER' then 
	dw_list.Retrieve(ls_saupj, ls_itnbr, ls_gubun_hk  )
elseif ls_gubun = 'FR' then 
	dw_list.Retrieve(ls_saupj, ls_itnbr, ls_gubun_hk  )
	dw_list.ShareData(dw_print)		
elseif ls_gubun = 'NR' then 
	dw_list.Retrieve(ls_saupj, ls_sdate ,ls_edate, ls_itnbr, '1', ls_gubun_hk )
	dw_list.ShareData(dw_print)			
elseif ls_gubun = 'OR' then 
	dw_list.Retrieve(ls_saupj, ls_sdate ,ls_edate, ls_itnbr, '2', ls_gubun_hk )
	dw_list.ShareData(dw_print)			
elseif ls_gubun = 'HR' then 
	dw_list.Retrieve(ls_saupj, ls_sdate ,ls_edate, ls_itnbr )
end if

IF dw_list.rowcount() = 0 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	if ls_gubun = 'BR' or ls_gubun = 'ER' or ls_gubun ='HR' then //
	else
		p_print.Enabled =True
		p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
		p_preview.enabled = true
		p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
	end if
END IF
//dw_list.scrolltorow(1)
dw_ip.SetFocus()
//SetPointer(Arrow!)	

end event







type st_10 from w_standard_print`st_10 within w_sm10_0040p
end type



type dw_print from w_standard_print`dw_print within w_sm10_0040p
integer x = 3429
integer y = 64
integer width = 219
integer height = 160
string dataobject = "d_sm10_0040p_ar_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sm10_0040p
integer x = 9
integer y = 20
integer width = 3314
integer height = 456
string dataobject = "d_sm10_0040p_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String ls_col , ls_value

ls_col = GetColumnName()
ls_value = Trim(GetText())
//ls_value = trim(dw_ip.getitemstring(1,'gubun'))
//AR 품목정보, BR 발주정보, ER 긴급발주, FR 포장스팩, NR 일일입고, OR 월마감, HR 클레임 
if ls_value = 'AR' then   
	dw_list.DataObject = 'd_sm10_0040p_ar'
	dw_print.DataObject = 'd_sm10_0040p_ar_p'	
	pb_1.visible = false 			
	pb_2.visible = false	
elseif ls_value = 'BR' then 
	dw_list.DataObject = 'd_sm10_0040p_br'
	pb_1.visible = false
	pb_2.visible = false	
elseif ls_value = 'ER' then 
	dw_list.DataObject = 'd_sm10_0040p_er'
	pb_1.visible = false
	pb_2.visible = false
elseif ls_value = 'FR' then
	dw_list.DataObject = 'd_sm10_0040p_fr'
	dw_print.DataObject = 'd_sm10_0040p_fr_p'		
	pb_1.visible = false
	pb_2.visible = false	
elseif ls_value = 'NR' then 
	dw_list.DataObject = 'd_sm10_0040p_or'
	dw_print.DataObject = 'd_sm10_0040p_or_p'			
	pb_1.visible = true
	pb_2.visible = true
elseif ls_value = 'OR' then 
	dw_list.DataObject = 'd_sm10_0040p_or'
	dw_print.DataObject = 'd_sm10_0040p_or_p'			
	pb_1.visible = true
	pb_2.visible = true
elseif ls_value = 'HR' then 
	dw_list.DataObject = 'd_sm10_0040p_hr'
	pb_1.visible = true
	pb_2.visible = true
end if

dw_list.settransobject(sqlca)	
dw_print.settransobject(sqlca)	

p_preview.enabled = false
p_print.enabled = false	
p_print.picturename = "c:\erpman\image\인쇄_d.gif"
p_preview.picturename = "c:\erpman\image\미리보기_d.gif"	

end event

type dw_list from w_standard_print`dw_list within w_sm10_0040p
integer x = 18
integer y = 548
integer width = 4503
integer height = 1688
string dataobject = "d_sm10_0040p_ar"
boolean border = false
end type

event dw_list::clicked;//f_multi_select(this)
end event

type p_search from uo_picture within w_sm10_0040p
boolean visible = false
integer x = 3543
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\생성_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\생성_up.gif"
end event

type p_delrow from uo_picture within w_sm10_0040p
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 3890
integer y = 24
integer width = 178
integer taborder = 40
boolean bringtotop = true
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_delrow_all from uo_picture within w_sm10_0040p
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
boolean visible = false
integer x = 3717
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string pointer = "C:\erpman\cur\create2.cur"
string picturename = "C:\erpman\image\전체삭제_up.gif"
end type

type pb_1 from u_pb_cal within w_sm10_0040p
integer x = 2519
integer y = 160
integer height = 76
integer taborder = 60
boolean bringtotop = true
end type

event clicked;call super::clicked;
//해당 컬럼 지정
dw_ip.SetColumn('jisi_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'jisi_date', gs_code)

end event

type st_state from statictext within w_sm10_0040p
boolean visible = false
integer x = 1691
integer y = 936
integer width = 1440
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "데이타를 읽는 중입니다..."
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from u_pb_cal within w_sm10_0040p
integer x = 2999
integer y = 164
integer height = 76
integer taborder = 70
boolean bringtotop = true
end type

event clicked;call super::clicked;
//해당 컬럼 지정
dw_ip.SetColumn('jisi_date2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'jisi_date2', gs_code)

end event

type st_ing from statictext within w_sm10_0040p
boolean visible = false
integer x = 3758
integer y = 312
integer width = 818
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "Disconnect......"
boolean focusrectangle = false
end type

type p_excel from uo_picture within w_sm10_0040p
boolean visible = false
integer x = 3287
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\엑셀변환_up.gif"
end type

event clicked;call super::clicked;/*
If dw_list.RowCount() < 1 Then Return
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", ls_path, ls_file, "XLS", "Excel Files (*.xls),*.xls",'C:\', 32770)
dw_list.SaveAs(ls_path, Excel!, FALSE)
*/

end event

type p_1 from uo_picture within w_sm10_0040p
boolean visible = false
integer x = 4064
integer y = 24
boolean bringtotop = true
string picturename = "C:\erpman\image\저장_up.gif"
end type

type rr_1 from roundrectangle within w_sm10_0040p
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 9
integer y = 544
integer width = 4535
integer height = 1708
integer cornerheight = 40
integer cornerwidth = 55
end type

