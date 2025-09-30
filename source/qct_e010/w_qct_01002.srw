$PBExportHeader$w_qct_01002.srw
$PBExportComments$검사코드등록
forward
global type w_qct_01002 from window
end type
type p_exit from uo_picture within w_qct_01002
end type
type p_can from uo_picture within w_qct_01002
end type
type p_print from uo_picture within w_qct_01002
end type
type p_mod from uo_picture within w_qct_01002
end type
type p_delrow from uo_picture within w_qct_01002
end type
type p_addrow from uo_picture within w_qct_01002
end type
type p_inq from uo_picture within w_qct_01002
end type
type cb_1 from commandbutton within w_qct_01002
end type
type dw_detail from datawindow within w_qct_01002
end type
type dw_list from datawindow within w_qct_01002
end type
type rr_1 from roundrectangle within w_qct_01002
end type
end forward

global type w_qct_01002 from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "불량요인 등록"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
p_exit p_exit
p_can p_can
p_print p_print
p_mod p_mod
p_delrow p_delrow
p_addrow p_addrow
p_inq p_inq
cb_1 cb_1
dw_detail dw_detail
dw_list dw_list
rr_1 rr_1
end type
global w_qct_01002 w_qct_01002

type variables
char c_status
string is_key, is_rfcod = '14'

// 자료변경여부 검사
boolean  ib_any_typing
String	is_today, is_totime, is_window_id, is_usegub
end variables

forward prototypes
public function integer err_check ()
public subroutine cb_check ()
end prototypes

public function integer err_check ();string srfgub, rfgub_check
long row_count, find_count, seek_count

if dw_list.accepttext() = -1 then return -1

for row_count = 1 to dw_list.rowcount()
//	//그룹코드 체크
//	if dw_list.getitemstring(row_count, "t_code1") = "" or &
//		isnull(dw_list.getitemstring(row_count, "t_code1")) then
//		dw_list.setcolumn("t_code1")
//		dw_list.setrow(row_count)
//		messagebox("검사코드","검사코드를 입력하세요",stopsign!)
//		dw_list.setfocus()
//		return -1
//	else
		dw_list.setitem(row_count,'rfna2',is_key)
//		srfgub = trim(dw_list.getitemstring(row_count,"t_code")) + &
//				   trim(dw_list.getitemstring(row_count,"t_code1"))
//		dw_list.setitem(row_count,'rfgub',srfgub)
//	end if
	
				
	//그룹명 체크
	if dw_list.getitemstring(row_count, "rfna1") = "" or &
		isnull(dw_list.getitemstring(row_count, "rfna1")) then
		dw_list.setcolumn("rfna1")
		dw_list.setrow(row_count)
		messagebox("불량명","불량명을 입력하세요1",stopsign!)
		dw_list.setfocus()
		return -1
	end if
next

for row_count = 1 to dw_list.rowcount() - 1
	
	seek_count = row_count + 1
	rfgub_check = dw_list.getitemstring(row_count,"rfgub")
	find_count = dw_list.find("rfgub = '" + rfgub_check + "'", seek_count, dw_list.rowcount())
	
	if find_count > 0 then 
		messagebox("그룹코드","동일한 코드가 발생하였습니다", stopsign!)
		dw_list.setcolumn("rfgub")
		dw_list.setrow(find_count)
		dw_list.setfocus()
		return -1
	end if
	
next

return 0

	
end function

public subroutine cb_check ();p_addrow.enabled = False
p_delrow.enabled = False
p_print.enabled  = False
p_mod.enabled     = False

dw_list.reset()
dw_list.enabled = false
dw_detail.enabled = true
dw_detail.setfocus()

end subroutine

on w_qct_01002.create
this.p_exit=create p_exit
this.p_can=create p_can
this.p_print=create p_print
this.p_mod=create p_mod
this.p_delrow=create p_delrow
this.p_addrow=create p_addrow
this.p_inq=create p_inq
this.cb_1=create cb_1
this.dw_detail=create dw_detail
this.dw_list=create dw_list
this.rr_1=create rr_1
this.Control[]={this.p_exit,&
this.p_can,&
this.p_print,&
this.p_mod,&
this.p_delrow,&
this.p_addrow,&
this.p_inq,&
this.cb_1,&
this.dw_detail,&
this.dw_list,&
this.rr_1}
end on

on w_qct_01002.destroy
destroy(this.p_exit)
destroy(this.p_can)
destroy(this.p_print)
destroy(this.p_mod)
destroy(this.p_delrow)
destroy(this.p_addrow)
destroy(this.p_inq)
destroy(this.cb_1)
destroy(this.dw_detail)
destroy(this.dw_list)
destroy(this.rr_1)
end on

event open;Integer  li_idx

li_idx = w_mdi_frame.dw_listbar.InsertRow(0)
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_id',Upper(This.ClassName()))
w_mdi_frame.dw_listbar.SetItem(li_idx,'window_name',Upper(This.Title))
w_mdi_frame.Postevent("ue_barrefresh")

is_today = f_today()
is_totime = f_totime()
is_window_id = this.ClassName()

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

dw_detail.settransobject(sqlca)
dw_detail.insertrow(0)
dw_list.settransobject(sqlca)

dw_detail.SetFocus()
end event

event closequery;string s_frday, s_frtime

IF is_usegub = 'Y' THEN
	s_frday = f_today()
	
	s_frtime = f_totime()

   UPDATE "PGM_HISTORY"  
      SET "EDATE" = :s_frday,   
          "ETIME" = :s_frtime  
    WHERE ( "PGM_HISTORY"."L_USERID" = :gs_userid ) AND  
          ( "PGM_HISTORY"."CDATE" = :is_today ) AND  
          ( "PGM_HISTORY"."STIME" = :is_totime ) AND  
          ( "PGM_HISTORY"."WINDOW_NAME" = :is_window_id )   ;

	IF SQLCA.SQLCODE = 0 THEN 
	   COMMIT;
   ELSE 	  
	   ROLLBACK;
   END IF	  
END IF	  

w_mdi_frame.st_window.Text = ''

long li_index

li_index = w_mdi_frame.dw_listbar.Find("window_id = '" + Upper(This.ClassName()) + "'", 1, w_mdi_frame.dw_listbar.RowCount())

w_mdi_frame.dw_listbar.DeleteRow(li_index)
w_mdi_frame.Postevent("ue_barrefresh")
end event

type p_exit from uo_picture within w_qct_01002
integer x = 3767
integer y = 16
integer width = 178
integer taborder = 100
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;call super::clicked;close(parent)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

type p_can from uo_picture within w_qct_01002
integer x = 3593
integer y = 16
integer width = 178
integer taborder = 80
string pointer = "C:\erpman\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

dw_detail.reset()
dw_detail.insertrow(0)
dw_detail.setfocus()

cb_check()

cb_1.postevent(clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

type p_print from uo_picture within w_qct_01002
integer x = 3419
integer y = 16
integer width = 178
integer taborder = 70
string pointer = "C:\erpman\cur\print.cur"
string picturename = "C:\erpman\image\인쇄_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

if messagebox('확인','출력하시겠습니까?', question!, yesno!) = 2 then return
dw_list.print()

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\인쇄_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\인쇄_up.gif"
end event

type p_mod from uo_picture within w_qct_01002
integer x = 3246
integer y = 16
integer width = 178
integer taborder = 60
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

integer r_c, r_c1, f_check

dw_detail.accepttext()
dw_list.accepttext()

if err_check() = -1 then return

if dw_list.update() = 1 then
	commit;
else
	rollback;
	f_rollback()
end if

cb_check()
cb_1.postevent(clicked!)

//저장삭제시 다시 retrieve
datawindowchild dw_child

dw_detail.getchild("rfcod", dw_child)
dw_child.settransobject(sqlca)
dw_child.retrieve()

p_inq.TriggerEvent(Clicked!)

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

type p_delrow from uo_picture within w_qct_01002
integer x = 3072
integer y = 16
integer width = 178
integer taborder = 50
string pointer = "C:\erpman\cur\delrow.cur"
string picturename = "C:\erpman\image\행삭제_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

long curr_row

curr_row = dw_list.getrow()

if curr_row > 0 then
	dw_list.deleterow(curr_row)
	dw_list.setcolumn(2)
	dw_list.setfocus()
end if

if dw_list.rowcount() = 0 then  //전부삭제된경우
	 messagebox('확인',"삭제할자료가없습니다", &
					exclamation!,ok!) 
end if
	
	
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행삭제_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행삭제_up.gif"
end event

type p_addrow from uo_picture within w_qct_01002
integer x = 2898
integer y = 16
integer width = 178
integer taborder = 40
string pointer = "C:\erpman\cur\addrow.cur"
string picturename = "C:\erpman\image\행추가_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

long IcurrentRow

if dw_list.accepttext() = -1 then return 

if dw_list.rowcount() > 0 then
	icurrentrow = dw_list.getrow() + 1
	dw_list.insertrow(icurrentrow)
else
	icurrentrow = dw_list.insertrow(0)
end if

dw_list.setitem(icurrentrow,'sabu',gs_sabu)
dw_list.setitem(icurrentrow,'rfcod',is_rfcod)
dw_list.setitem(icurrentrow,'rfna2',is_key)
dw_list.scrolltorow(icurrentrow)
dw_list.setcolumn('rfgub')
dw_list.setfocus()



end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\행추가_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\행추가_up.gif"
end event

type p_inq from uo_picture within w_qct_01002
integer x = 2725
integer y = 16
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\retrieve.cur"
string picturename = "C:\erpman\image\조회_up.gif"
end type

event clicked;call super::clicked;w_mdi_frame.sle_msg.text =""

long row_count

if dw_detail.accepttext() = -1 then return

is_key = dw_detail.getitemstring(1,'spum')

if isnull(is_key) or is_key = '' then
	messagebox('확인','공정그룹을 선택하세요')
	dw_detail.setfocus()
	return 
end if

select count(*) into :row_count 
from reffpf 
where sabu = :gs_sabu and 
		rfcod = :is_rfcod and
		rfna2 = :is_key;

	if row_count = 0 or isnull(row_count) then
		if dw_list.rowcount() <= 0 then
			dw_detail.enabled = false
			dw_list.enabled = true
			
			p_addrow.enabled = true
			p_delrow.enabled = true
			p_print.enabled = true
			p_mod.enabled = true
			p_addrow.triggerevent(clicked!)
			
			dw_list.setitem(1,'rfna2',is_key)
			dw_list.setfocus()
		end if
	else
		dw_list.retrieve(is_key)
		dw_detail.enabled = false
		dw_list.enabled = true
		
		p_addrow.enabled = true
		p_delrow.enabled = true
		p_print.enabled = true
		p_mod.enabled = true
		
		dw_list.scrolltorow(dw_list.rowcount())
		dw_list.setfocus()
	end if

		


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

type cb_1 from commandbutton within w_qct_01002
boolean visible = false
integer x = 809
integer y = 2304
integer width = 261
integer height = 92
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
end type

event clicked;dw_detail.setredraw(false)
dw_detail.insertrow(0)
dw_detail.setredraw(true)

dw_detail.setcolumn(1)
dw_detail.setrow(1)
dw_detail.setfocus()

end event

type dw_detail from datawindow within w_qct_01002
integer x = 32
integer y = 32
integer width = 1134
integer height = 136
integer taborder = 10
string title = "none"
string dataobject = "d_qct_01002_2"
boolean border = false
boolean livescroll = true
end type

type dw_list from datawindow within w_qct_01002
event dw_detail_key pbm_dwnkey
event ue_downenter pbm_dwnprocessenter
integer x = 59
integer y = 200
integer width = 4517
integer height = 2068
integer taborder = 30
boolean enabled = false
string dataobject = "d_qct_01002_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event dw_detail_key;//if keydown(keytab!) and dw_list.getcolumname() = '
end event

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemchanged;ib_any_typing = true

end event

event itemerror;return -1

end event

event rowfocuschanged;if 	currentrow < 1 then return 
if 	this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

this.setredraw(true)

end event

type rr_1 from roundrectangle within w_qct_01002
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 192
integer width = 4549
integer height = 2088
integer cornerheight = 40
integer cornerwidth = 55
end type

