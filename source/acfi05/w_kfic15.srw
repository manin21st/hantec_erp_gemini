$PBExportHeader$w_kfic15.srw
$PBExportComments$월별 리스료 현황 조회출력
forward
global type w_kfic15 from w_standard_print
end type
type gb_4 from groupbox within w_kfic15
end type
type rb_1 from radiobutton within w_kfic15
end type
type rb_2 from radiobutton within w_kfic15
end type
type rr_1 from roundrectangle within w_kfic15
end type
end forward

global type w_kfic15 from w_standard_print
integer x = 0
integer y = 0
string title = "월별 리스료 현황 조회출력"
gb_4 gb_4
rb_1 rb_1
rb_2 rb_2
rr_1 rr_1
end type
global w_kfic15 w_kfic15

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_ym1, ls_lscono, ls_lsco, ls_lsno, snull, ls_ym2, ls_ym3, ls_ym4, ls_ym5, &
       ls_ym6, ls_ym7, ls_ym8, ls_ym9, ls_ym10, ls_ym11, ls_ym12, sClosing_date


if dw_ip.accepttext() = -1 then return -1

setnull(snull)

ls_ym1 = dw_ip.getitemstring(dw_ip.getrow(), "ym1")
ls_lscono = dw_ip.getitemstring(dw_ip.getrow(), "lscono")
ls_lsno = dw_ip.getitemstring(dw_ip.getrow(), "lsno")
ls_lsco = dw_ip.getitemstring(dw_ip.getrow(), "lsco")

if ls_ym1 = "" or isnull(ls_ym1) then
	f_messagechk(1, "[기준년도]")
	dw_ip.setcolumn("ym1")
	dw_ip.setfocus()
	return -1
end if

SELECT CLOSING_DATE
  into :sClosing_date
  FROM KFZ34OT1
 WHERE CLOSING_DATE <= :ls_ym1||'1231'
   AND ROWNUM = 1;

if sqlca.sqlcode <> 0 then
	messagebox("확인", "적용할 환율이 없습니다. 먼저 환율을 등록하십시오!!")
	dw_ip.setfocus()
	return -1
end if 

if ls_lscono = "" or isnull(ls_lscono) then
	ls_lscono = '%'
end if

if ls_lsco = "" or isnull(ls_lsco) then
	ls_lsco = '%'
end if
	
if ls_lsno = "" or isnull(ls_lsno) then
	ls_lsno = '%'
end if

dw_list.object.txt_1.text = string(left(ls_ym1, 4), '@@@@') 
dw_list.object.t_1.text = '1 월' 
dw_list.object.t_2.text = '2 월'  
dw_list.object.t_3.text = '3 월'
dw_list.object.t_4.text = '4 월' 
dw_list.object.t_5.text = '5 월' 
dw_list.object.t_6.text = '6 월'
dw_list.object.t_7.text = '7 월'   
dw_list.object.t_8.text = '8 월' 
dw_list.object.t_9.text = '9 월' 
dw_list.object.t_10.text = '10 월' 
dw_list.object.t_11.text = '11 월' 
dw_list.object.t_12.text = '12 월'

dw_print.object.txt_1.text = string(left(ls_ym1, 4), '@@@@') 
dw_print.object.t_1.text = '1 월' 
dw_print.object.t_2.text = '2 월'  
dw_print.object.t_3.text = '3 월'
dw_print.object.t_4.text = '4 월' 
dw_print.object.t_5.text = '5 월' 
dw_print.object.t_6.text = '6 월'
dw_print.object.t_7.text = '7 월'   
dw_print.object.t_8.text = '8 월' 
dw_print.object.t_9.text = '9 월' 
dw_print.object.t_10.text = '10 월' 
dw_print.object.t_11.text = '11 월' 
dw_print.object.t_12.text = '12 월'

ls_ym1 = string(left(ls_ym1, 4))+'01'
ls_ym2 = string(left(ls_ym1, 4))+'02'
ls_ym3 = string(left(ls_ym1, 4))+'03'
ls_ym4 = string(left(ls_ym1, 4))+'04'
ls_ym5 = string(left(ls_ym1, 4))+'05'
ls_ym6 = string(left(ls_ym1, 4))+'06'
ls_ym7 = string(left(ls_ym1, 4))+'07'
ls_ym8 = string(left(ls_ym1, 4))+'08'
ls_ym9 = string(left(ls_ym1, 4))+'09'
ls_ym10 = string(left(ls_ym1, 4))+'10'
ls_ym11 = string(left(ls_ym1, 4))+'11'
ls_ym12 = string(left(ls_ym1, 4))+'12'

//if dw_list.retrieve(ls_ym1, ls_ym2, ls_ym3, ls_ym4, ls_ym5, ls_ym6, ls_ym7, ls_ym8, ls_ym9, &
//                    ls_ym10, ls_ym11, ls_ym12, ls_lscono, ls_lsco, ls_lsno) <= 0 then
//   messagebox("확인", "조회된 자료가 없습니다.")
//	return -1 
//end if 

IF dw_print.retrieve(ls_ym1, ls_ym2, ls_ym3, ls_ym4, ls_ym5, ls_ym6, ls_ym7, ls_ym8, ls_ym9, &
                    ls_ym10, ls_ym11, ls_ym12, ls_lscono, ls_lsco, ls_lsno) <= 0 then
   messagebox("확인", "조회된 자료가 없습니다.")
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1

end function

on w_kfic15.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_kfic15.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rr_1)
end on

event open;call super::open;string ls_ym1, ls_ym12

ls_ym1 = left(f_today(), 4) 

dw_ip.setitem(dw_ip.getrow(), "ym1", ls_ym1)

end event

type p_preview from w_standard_print`p_preview within w_kfic15
end type

type p_exit from w_standard_print`p_exit within w_kfic15
end type

type p_print from w_standard_print`p_print within w_kfic15
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfic15
end type







type st_10 from w_standard_print`st_10 within w_kfic15
end type



type dw_print from w_standard_print`dw_print within w_kfic15
string dataobject = "d_kfic15_1_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfic15
integer x = 9
integer y = 8
integer width = 2373
integer height = 260
string dataobject = "d_kfic15"
end type

event dw_ip::rbuttondown;call super::rbuttondown;setnull(gs_code)
setnull(gs_codename)

this.accepttext()

if this.getcolumnname() = "lsno" then
   gs_code = dw_ip.getitemstring(dw_ip.getrow(), "lsno")
	if isnull(gs_code) then gs_code = ""
	
	open(w_kfic10_popup)
	
	if isnull(gs_code) then return
	
	dw_ip.setitem(dw_ip.getrow(), "lsno", gs_code)
//	p_retrieve.TriggerEvent(clicked!)
	
end if
	
if this.getcolumnname() = "lscono" then
	gs_code = dw_ip.getitemstring(dw_ip.getrow(), "lscono")
   gs_codename = dw_ip.getitemstring(dw_ip.getrow(), "lsco")
	
	if isnull(gs_code) then gs_code = ""
	
	open(w_kfic10_popup1)
	
	if isnull(gs_code) then return
	
	dw_ip.setitem(dw_ip.getrow(), "lscono", gs_code)
	dw_ip.setitem(dw_ip.getrow(), "lsco", gs_codename)
//	p_retrieve.TriggerEvent(clicked!)
	
end if	
	
	
	
end event

event dw_ip::itemchanged;call super::itemchanged;string ls_lscono, ls_lsco, snull

setnull(snull)

if this.getcolumnname() = "lscono" then
	ls_lscono = this.gettext()
	if ls_lscono = "" or isnull(ls_lscono) then
		this.setitem(dw_ip.getrow(), "lscono", snull)
		this.setitem(dw_ip.getrow(), "lsco", snull)
	end if

	SELECT "LSCO"
  	INTO :ls_lsco
 	FROM "KFM20M"
 	WHERE "LSCONO" = :ls_lscono ;
	 
 	if sqlca.sqlcode <> 0 then
//	 	dw_ip.setitem(dw_ip.getrow(), "lscono", snull)
//		 dw_ip.setitem(dw_ip.getrow(), "lsco", snull)		 
//   	 dw_ip.setcolumn("lscono")
//		 dw_ip.setfocus()
//		 return 
	else
 	 	dw_ip.setitem(dw_ip.getrow(), "lsco", ls_lsco)
	end if
end if
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfic15
integer x = 23
integer y = 280
integer width = 4599
integer height = 2048
string dataobject = "d_kfic15_1"
boolean border = false
end type

type gb_4 from groupbox within w_kfic15
boolean visible = false
integer x = 2455
integer y = 9000
integer width = 773
integer height = 256
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
string text = "출력구분"
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_kfic15
boolean visible = false
integer x = 2523
integer y = 9000
integer width = 480
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "일반용지(A4)"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.SetRedraw(False)

IF rb_1.Checked =True THEN
	dw_list.dataObject='d_kfic15_1'
END IF

dw_list.title = "월별 리스료 현황"
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)

end event

type rb_2 from radiobutton within w_kfic15
boolean visible = false
integer x = 2523
integer y = 9000
integer width = 352
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 67108864
string text = "연속용지"
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;dw_list.SetRedraw(False)

IF rb_2.Checked = True Then
	dw_list.DataObject = 'd_kfic15_1_dot'
END IF

dw_list.title = "월별 리스료 현황"
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)

end event

type rr_1 from roundrectangle within w_kfic15
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 272
integer width = 4626
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

