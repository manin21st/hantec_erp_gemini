$PBExportHeader$w_voda_activity_flow_notice.srw
$PBExportComments$조회 선택 계승윈도우
forward
global type w_voda_activity_flow_notice from window
end type
type rr_1 from roundrectangle within w_voda_activity_flow_notice
end type
type dw_2 from u_d_popup_sort within w_voda_activity_flow_notice
end type
type st_3 from statictext within w_voda_activity_flow_notice
end type
type dw_1 from u_d_popup_sort within w_voda_activity_flow_notice
end type
type em_1 from editmask within w_voda_activity_flow_notice
end type
type p_ins from uo_picture within w_voda_activity_flow_notice
end type
type p_del from uo_picture within w_voda_activity_flow_notice
end type
type p_mod from uo_picture within w_voda_activity_flow_notice
end type
type p_exit from uo_picture within w_voda_activity_flow_notice
end type
type p_inq from uo_picture within w_voda_activity_flow_notice
end type
type sle_1 from singlelineedit within w_voda_activity_flow_notice
end type
type st_1 from statictext within w_voda_activity_flow_notice
end type
end forward

global type w_voda_activity_flow_notice from window
integer x = 1577
integer y = 224
integer width = 3945
integer height = 2232
boolean titlebar = true
windowtype windowtype = response!
long backcolor = 32106727
rr_1 rr_1
dw_2 dw_2
st_3 st_3
dw_1 dw_1
em_1 em_1
p_ins p_ins
p_del p_del
p_mod p_mod
p_exit p_exit
p_inq p_inq
sle_1 sle_1
st_1 st_1
end type
global w_voda_activity_flow_notice w_voda_activity_flow_notice

type variables
string 	is_proj_code
long 		il_proj_seq, il_gateway_seq, il_activity_seq
end variables

event open;string ls_filepath, ls_file_name
wstr_parm ls_str_parm

f_window_center(this)

ls_str_parm = message.powerobjectparm

is_proj_code 		= ls_str_parm.s_parm[1]
il_proj_seq  		= long(ls_str_parm.s_parm[2] )
il_gateway_seq 	= long(ls_str_parm.s_parm[3] )
il_activity_seq 	= long(ls_str_parm.s_parm[4] )

dw_1.settransobject(sqlca)
dw_2.settransobject(sqlca)
em_1.text = mid(f_today(), 1, 4)+ '/' + mid(f_today(), 5, 2)
 p_inq.triggerevent('clicked')

end event

on w_voda_activity_flow_notice.create
this.rr_1=create rr_1
this.dw_2=create dw_2
this.st_3=create st_3
this.dw_1=create dw_1
this.em_1=create em_1
this.p_ins=create p_ins
this.p_del=create p_del
this.p_mod=create p_mod
this.p_exit=create p_exit
this.p_inq=create p_inq
this.sle_1=create sle_1
this.st_1=create st_1
this.Control[]={this.rr_1,&
this.dw_2,&
this.st_3,&
this.dw_1,&
this.em_1,&
this.p_ins,&
this.p_del,&
this.p_mod,&
this.p_exit,&
this.p_inq,&
this.sle_1,&
this.st_1}
end on

on w_voda_activity_flow_notice.destroy
destroy(this.rr_1)
destroy(this.dw_2)
destroy(this.st_3)
destroy(this.dw_1)
destroy(this.em_1)
destroy(this.p_ins)
destroy(this.p_del)
destroy(this.p_mod)
destroy(this.p_exit)
destroy(this.p_inq)
destroy(this.sle_1)
destroy(this.st_1)
end on

event key;//call super::key;choose case key
//	case keypageup!
//		dw_1.scrollpriorpage()
//	case keypagedown!
//		dw_1.scrollnextpage()
//	case keyhome!
//		dw_1.scrolltorow(1)
//	case keyend!
//		dw_1.scrolltorow(dw_1.rowcount())
//end choose
//
//If keyDown(keyQ!) And keyDown(keyAlt!) Then
//	p_inq.TriggerEvent(Clicked!)
//End If
//
//If keyDown(keyV!) And keyDown(keyAlt!) Then
//	p_choose.TriggerEvent(Clicked!)
//End If
//
//If keyDown(keyC!) And keyDown(keyAlt!) Then
//	p_exit.TriggerEvent(Clicked!)
//End If
end event

type rr_1 from roundrectangle within w_voda_activity_flow_notice
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 5
integer y = 108
integer width = 745
integer height = 112
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_2 from u_d_popup_sort within w_voda_activity_flow_notice
integer y = 1000
integer width = 3918
integer height = 1140
integer taborder = 50
string dataobject = "d_voda_flow_activity_notice_detail"
boolean resizable = true
end type

event itemchanged;call super::itemchanged;

if row < 1 then return 

if dwo.name = 'chk' then 
	if data = 'Y' then
		DW_2.OBJECT.TO_NM[1] = '전체'
	End if 

End if 
end event

type st_3 from statictext within w_voda_activity_flow_notice
integer x = 14
integer y = 136
integer width = 347
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "[ 년월 ]"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_1 from u_d_popup_sort within w_voda_activity_flow_notice
integer y = 240
integer width = 3913
integer height = 736
integer taborder = 40
string dataobject = "d_voda_flow_activity_notice_head"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dberror;String  sMsg, sErrorcode, sErrorsyntax, sReturn, sNewline
Integer iPos, iCount

iCount			= 0
sNewline			= '~r'
sReturn			= '~n'
sErrorcode 		= Left(sqlerrtext, 9)
iPos 		  		= Len(sqlerrtext) - Pos(sqlerrtext, "No changes made to database.", 1)
sErrorSyntax	= tRIM(Mid(sqlerrtext, 11, Len(sqlerrtext) - iPos - 11))

For iPos = Len(sErrorSyntax) to 1 STEP -1
	 sMsg = Mid(sErrorSyntax, ipos, 1)
	 If sMsg   = sReturn or sMsg = sNewline Then
		 iCount++
	 End if
Next

sErrorSynTax  	= Left(sErrorSyntax, Len(sErrorsyntax) - iCount)


str_db_error db_error_msg
db_error_msg.rowno 	 				= row
db_error_msg.errorcode 				= sErrorCode
db_error_msg.errorsyntax_system	= sErrorSyntax
db_error_msg.errorsyntax_user		= sErrorSyntax
db_error_msg.errorsqlsyntax			= sqlsyntax
OpenWithParm(w_error, db_error_msg)


/*sMsg = "Row No       -> " + String(row) 			 + '~n' + &
		 "Error Code   -> " + sErrorcode			    + '~n' + &
		 "Error Syntax -> " + sErrorSyntax			 + '~n' + &
		 "SqlSyntax    -> " + Sqlsyntax
	MESSAGEBOX("자료처리중 오류발생", sMsg) */

RETURN 1
end event

event itemerror;Return 1
end event

event clicked;long ll_notice_seq 

IF ROW < 1 THEN RETURN 

If Row <= 0 then
	this.SelectRow(0, FALSE)
	this.SelectRow(1,TRUE)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(Row,TRUE)
	//권한
	if dw_1.object.write_id[row] = gs_empno then 
		p_mod.enabled = true 
		p_del.enabled = true 
	else 
		p_mod.enabled = false 
		p_del.enabled = false
	End if 
End if 

ll_notice_seq = dw_1.object.notice_seq[row]
dw_2.reset() 
dw_2.insertrow(0)
dw_2.retrieve(is_proj_code, il_proj_seq, il_gateway_seq, il_activity_seq, ll_notice_seq) 
end event

event rowfocuschanged;call super::rowfocuschanged;Long ll_notice_seq

IF currentrow < 1 THEN RETURN 
If currentrow <= 0 then
	this.SelectRow(0, FALSE)
	this.SelectRow(1,TRUE)
ELSE
	this.SelectRow(0, FALSE)
	this.SelectRow(currentrow,TRUE)
End if 

ll_notice_seq = dw_1.object.notice_seq[currentrow]
dw_2.reset() 
dw_2.insertrow(0)
dw_2.retrieve(is_proj_code, il_proj_seq, il_gateway_seq, il_activity_seq, ll_notice_seq) 

end event

type em_1 from editmask within w_voda_activity_flow_notice
integer x = 366
integer y = 136
integer width = 338
integer height = 64
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "none"
boolean border = false
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm"
boolean spin = true
end type

type p_ins from uo_picture within w_voda_activity_flow_notice
integer x = 3223
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\add.cur"
string picturename = "C:\erpman\image\추가_up.gif"
end type

event clicked;call super::clicked;Long il_max_notice_no 

dw_2.reset() 

dw_2.insertrow(0)

dw_2.object.PROJ_CODE[1] = is_proj_code
dw_2.object.PROJ_seq[1]  = il_proj_seq
dw_2.object.gateway_seq[1]  = il_gateway_seq
dw_2.object.activity_seq[1]  = il_activity_seq
dw_2.object.WRITE_ID[1]  = gs_empno
dw_2.object.WRITE_NM[1]  = gs_username
dw_2.object.ENTER_DT[1]  = today()
dw_2.object.prty[1]  = '2'
dw_2.object.chk[1]  = 'Y'
dw_2.object.to_nm[1]  = '전체'


select max(NOTICE_SEQ) 
  into :il_max_notice_no
  from FLOW_ACTIVITY_NOTICE
 where PROJ_CODE = :is_proj_code 
   and PROJ_seq = :il_proj_seq
	and gateway_seq = :il_gateway_seq
	and activity_seq = :il_activity_seq ;

if sqlca.sqlcode = -1 then 
	messagebox('확인', '순번에러!' +  sqlca.sqlerrtext) 
	Return -1 
end if 
	
if il_max_notice_no = 0 or isnull(	il_max_notice_no ) then 
	il_max_notice_no = 1 
else 
	il_max_notice_no = il_max_notice_no + 1  
end if 
	
dw_2.object.Notice_seq[1]  = il_max_notice_no
p_mod.enabled = true
dw_1.setcolumn('subject')
//dw_1.setrow(1)
//dw_1.setfocus()
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\추가_up.gif"

end event

type p_del from uo_picture within w_voda_activity_flow_notice
integer x = 3397
integer y = 8
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\delete.cur"
string picturename = "C:\erpman\image\삭제_up.gif"
end type

event clicked;call super::clicked;Long ls_row 

ls_row = dw_1.getrow() 
if ls_row < 1 then Return 
dw_1.deleterow(ls_Row)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\삭제_up.gif"
end event

type p_mod from uo_picture within w_voda_activity_flow_notice
integer x = 3570
integer y = 8
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;if dw_1.update() = -1 then 
	messagebox('확인', '저장 실패!') 
End if 

IF dw_2.update() = -1 THEN 
	messagebox('확인', '저장 실패!') 
END IF 
commit;

p_inq.triggerevent('Clicked')


w_mdi_frame.sle_msg.text =""
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_exit from uo_picture within w_voda_activity_flow_notice
event ue_key pbm_keydown
integer x = 3744
integer y = 8
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event ue_key;Parent.event key(key, keyflags)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\취소_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\취소_up.gif'
end event

event clicked;call super::clicked;string ls_message
Long 	 ll_row
wstr_parm ls_str_parm

if dw_1.rowcount() < 1 then
	ls_message = ' ' 
else
	ls_message = ' ' 
	For ll_row = 1 to dw_1.rowcount() 
		 ls_message = trim(ls_message) + dw_1.object.write_nm[ll_row] + ' : ' + dw_1.object.subject[ll_row] + '~n'
	Next
End if 
ls_str_parm.s_parm[1] = ls_message
closewithreturn(parent, ls_str_parm)
end event

type p_inq from uo_picture within w_voda_activity_flow_notice
event ue_key pbm_keydown
integer x = 3049
integer y = 8
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event ue_key;Parent.event key(key, keyflags)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\조회_dn.gif'


end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\조회_up.gif'
end event

event clicked;call super::clicked;long ll_notice_seq, ll_return, il_max_notice_no
string ls_date, 	ls_manager_empno

ls_date = em_1.text

ll_return = dw_1.retrieve(is_proj_code, il_proj_seq, il_gateway_seq, il_activity_seq, gs_empno, gs_username, ls_date)

if ll_return < 1 then 
//	dw_2.reset()
//	dw_2.insertrow(0) 
//	dw_2.object.PROJ_CODE[1] = is_proj_code
//	dw_2.object.PROJ_seq[1]  = il_proj_seq
//	dw_2.object.gateway_seq[1]  = il_gateway_seq
//	dw_2.object.activity_seq[1]  = il_activity_seq
//	dw_2.object.WRITE_ID[1]  = gs_empno
//	dw_2.object.WRITE_NM[1]  = gs_username
//	dw_2.object.ENTER_DT[1]  = today()
//	
//	select max(NOTICE_SEQ) 
//	  into :il_max_notice_no
//	  from FLOW_ACTIVITY_NOTICE
//	 where PROJ_CODE = :is_proj_code 
//		and PROJ_seq = :il_proj_seq
//		and gateway_seq = :il_gateway_seq
//		and activity_seq = :il_activity_seq ;
//	
//	if sqlca.sqlcode = -1 then 
//		messagebox('확인', '순번에러!' +  sqlca.sqlerrtext) 
//		Return -1 
//	end if 
//		
//	if il_max_notice_no = 0 or isnull(	il_max_notice_no ) then 
//		il_max_notice_no = 1 
//	else 
//		il_max_notice_no = il_max_notice_no + 1  
//	end if 
//		
//	dw_2.object.Notice_seq[1]  = il_max_notice_no
	p_ins.triggerevent('clicked')
ELSE 
	DW_1.SETROW(1)
	DW_1.SelectRow(1,TRUE)
	ll_notice_seq = dw_1.object.notice_seq[1]
	dw_2.reset() 
	dw_2.insertrow(0)
	dw_2.retrieve(is_proj_code, il_proj_seq, il_gateway_seq, il_activity_seq, ll_notice_seq) 
	//총괄담당자
	select max(manager_empno) 
	  into :ls_manager_empno
	  from flow_activity_code ; 
	
	if dw_1.object.write_id[1] = gs_empno or gs_empno = ls_manager_empno  then 
		p_mod.enabled = true 
		p_del.enabled = true 
	else 
		p_mod.enabled = false 
		p_del.enabled = false
	End if 

end if 
end event

type sle_1 from singlelineedit within w_voda_activity_flow_notice
integer x = 279
integer y = 2248
integer width = 178
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean border = false
boolean autohscroll = false
textcase textcase = upper!
integer limit = 5
end type

event getfocus;
f_toggle_eng(Handle(this))
end event

type st_1 from statictext within w_voda_activity_flow_notice
integer y = 2260
integer width = 279
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

