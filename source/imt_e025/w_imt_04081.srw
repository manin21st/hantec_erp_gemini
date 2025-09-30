$PBExportHeader$w_imt_04081.srw
$PBExportComments$선급금 정리(B/L, 인수증조회 처리)
forward
global type w_imt_04081 from window
end type
type p_exit from uo_picture within w_imt_04081
end type
type p_cancel from uo_picture within w_imt_04081
end type
type p_save from uo_picture within w_imt_04081
end type
type rr_1 from roundrectangle within w_imt_04081
end type
type st_2 from statictext within w_imt_04081
end type
type st_set from statictext within w_imt_04081
end type
type st_lcno from statictext within w_imt_04081
end type
type st_1 from statictext within w_imt_04081
end type
type dw_1 from datawindow within w_imt_04081
end type
type dw_list from datawindow within w_imt_04081
end type
type ln_1 from line within w_imt_04081
end type
type ln_2 from line within w_imt_04081
end type
type rr_2 from roundrectangle within w_imt_04081
end type
end forward

global type w_imt_04081 from window
integer x = 626
integer y = 248
integer width = 2811
integer height = 1548
boolean titlebar = true
string title = "선급금 처리"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_exit p_exit
p_cancel p_cancel
p_save p_save
rr_1 rr_1
st_2 st_2
st_set st_set
st_lcno st_lcno
st_1 st_1
dw_1 dw_1
dw_list dw_list
ln_1 ln_1
ln_2 ln_2
rr_2 rr_2
end type
global w_imt_04081 w_imt_04081

type variables
string  is_lcno, is_setno, is_process



end variables

forward prototypes
public function integer wf_create ()
end prototypes

public function integer wf_create ();string sblno, slcno
dec{4} damt
long   lrow, lseq, lcount

lcount = dw_list.rowcount()

For Lrow = 1 to lcount 
	
	 sblno = dw_list.getitemstring(Lrow, "poblno")
	 lseq  = dw_list.getitemNumber(Lrow, "pobseq")
	 slcno = dw_list.getitemstring(Lrow, "polcno")	 
	 damt  = dw_list.getitemdecimal(Lrow, "pomulamt")
	 
	 if damt <= 0 then continue 
	 
	// B/L-HEAD에 결제번호 UPDATE
	update polcblhd
		set taxno = :is_setno
	 where sabu  = :gs_sabu and polcno = :sblno;	
	 
	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		Messagebox("수입B/L HEAD", "B/L HEAD 수정중 오류발생", stopsign!)
		return -1
	end if
	
	insert into polcsetdt
	 	(sabu,		setno,	  poblno,	polcno,	pobseq,  pomulamt,  gubun )
	 values
	  	(:gs_sabu,	:is_setno, :sblno,	:slcno,	:lseq,   :damt,	  '2');
		  
	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		Messagebox("구매결제-DETAIL", "구매결제 상세내역 작성중 오류발생", stopsign!)
		return -1
	end if
	
Next

return 1

end function

event open;dw_list.settransobject(sqlca)

is_lcno  = gs_gubun
is_setno = gs_code  
st_lcno.text = gs_gubun
st_set.text = gs_code

p_cancel.TriggerEvent("clicked")
end event

on w_imt_04081.create
this.p_exit=create p_exit
this.p_cancel=create p_cancel
this.p_save=create p_save
this.rr_1=create rr_1
this.st_2=create st_2
this.st_set=create st_set
this.st_lcno=create st_lcno
this.st_1=create st_1
this.dw_1=create dw_1
this.dw_list=create dw_list
this.ln_1=create ln_1
this.ln_2=create ln_2
this.rr_2=create rr_2
this.Control[]={this.p_exit,&
this.p_cancel,&
this.p_save,&
this.rr_1,&
this.st_2,&
this.st_set,&
this.st_lcno,&
this.st_1,&
this.dw_1,&
this.dw_list,&
this.ln_1,&
this.ln_2,&
this.rr_2}
end on

on w_imt_04081.destroy
destroy(this.p_exit)
destroy(this.p_cancel)
destroy(this.p_save)
destroy(this.rr_1)
destroy(this.st_2)
destroy(this.st_set)
destroy(this.st_lcno)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.dw_list)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.rr_2)
end on

type p_exit from uo_picture within w_imt_04081
integer x = 2583
integer y = 28
integer width = 178
integer taborder = 40
string pointer = "c:\ERPMAN\cur\close.cur"
string picturename = "C:\erpman\image\닫기_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\닫기_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\닫기_up.gif"
end event

event clicked;call super::clicked;if is_process = 'Y' then 
	gs_code = 'YES'
end if

close(parent)


end event

type p_cancel from uo_picture within w_imt_04081
integer x = 2409
integer y = 28
integer width = 178
integer taborder = 30
string pointer = "c:\ERPMAN\cur\cancel.cur"
string picturename = "C:\erpman\image\취소_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event clicked;call super::clicked;dw_list.Retrieve(gs_sabu, is_lcno)
end event

type p_save from uo_picture within w_imt_04081
integer x = 2235
integer y = 28
integer width = 178
integer taborder = 20
string pointer = "c:\ERPMAN\cur\update.cur"
string picturename = "C:\erpman\image\저장_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\저장_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\저장_up.gif"
end event

event clicked;call super::clicked;SetPointer(HourGlass!)

if dw_list.rowcount() < 1 then return
IF dw_list.AcceptText() = -1		THEN	RETURN

IF f_msg_update() = -1 		THEN	RETURN

if wf_create() = -1 then
	ROLLBACK;
	f_Rollback()
	return
END IF		
COMMIT;

is_process = 'Y'

p_cancel.TriggerEvent("clicked")	

SetPointer(Arrow!)


end event

type rr_1 from roundrectangle within w_imt_04081
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 36
integer width = 2167
integer height = 132
integer cornerheight = 40
integer cornerwidth = 55
end type

type st_2 from statictext within w_imt_04081
integer x = 1157
integer y = 80
integer width = 334
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "구매결제번호"
boolean focusrectangle = false
end type

type st_set from statictext within w_imt_04081
integer x = 1499
integer y = 68
integer width = 667
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
boolean focusrectangle = false
end type

type st_lcno from statictext within w_imt_04081
integer x = 283
integer y = 68
integer width = 837
integer height = 64
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
boolean focusrectangle = false
end type

type st_1 from statictext within w_imt_04081
integer x = 73
integer y = 80
integer width = 215
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "L/C No"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_imt_04081
boolean visible = false
integer x = 18
integer y = 2340
integer width = 983
integer height = 112
boolean titlebar = true
string dataobject = "d_lc_detail_popup1"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
boolean righttoleft = true
end type

type dw_list from datawindow within w_imt_04081
event ue_downenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 50
integer y = 188
integer width = 2693
integer height = 1224
integer taborder = 10
string dataobject = "d_imt_04081"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_downenter;Send( Handle(this), 256, 9, 0 )
Return 1
end event

event itemerror;return 1
end event

event itemchanged;dec {2} dOldAmt, dAmt, dblamt, dmulamt

// 미결제금액 + 기결제금액 > 인수금액 -> ERROR
IF this.getcolumnname() = "pomulamt" 	THEN
	dOldAmt   = this.GetITemDecimal(Row, "pomulamt")

 	dAmt  	 = dec(this.GetText())
	dblamt    = this.GetITemDecimal(Row, "blamt")
	dmulamt   = this.GetITemDecimal(Row, "mulamt")
	
	IF damt + dmulamt > dblamt		THEN
		MessageBox("확 인", "미결제금액 + 기결제금액 은  인수금액보다 클 수 없습니다.")
		this.SetItem(Row, "pomulamt", dOldAmt)
		RETURN 1
	END IF
	
END IF

end event

type ln_1 from line within w_imt_04081
integer linethickness = 1
integer beginx = 288
integer beginy = 132
integer endx = 1125
integer endy = 132
end type

type ln_2 from line within w_imt_04081
integer linethickness = 1
integer beginx = 1499
integer beginy = 132
integer endx = 2167
integer endy = 132
end type

type rr_2 from roundrectangle within w_imt_04081
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 180
integer width = 2715
integer height = 1240
integer cornerheight = 40
integer cornerwidth = 55
end type

