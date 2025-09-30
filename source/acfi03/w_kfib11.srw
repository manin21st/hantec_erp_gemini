$PBExportHeader$w_kfib11.srw
$PBExportComments$월별 차입금 상환계획 조회출력
forward
global type w_kfib11 from w_standard_print
end type
type rb_1 from radiobutton within w_kfib11
end type
type rb_2 from radiobutton within w_kfib11
end type
type rb_3 from radiobutton within w_kfib11
end type
type st_1 from statictext within w_kfib11
end type
type rr_1 from roundrectangle within w_kfib11
end type
type rr_2 from roundrectangle within w_kfib11
end type
end forward

global type w_kfib11 from w_standard_print
integer x = 0
integer y = 0
string title = "월별 차입금 상환계획 조회출력"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_1 st_1
rr_1 rr_1
rr_2 rr_2
end type
global w_kfib11 w_kfib11

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String lsyear ,lscd

IF dw_ip.AcceptText() = -1 THEN RETURN -1

lsyear = Trim(dw_ip.GetItemString(1, "gijun_year"))
lscd   = dw_ip.GetItemString(1, "lo_cd")

If lscd = '' or IsNull(lscd) then
	lscd = '%'
End If

lsyear = lsyear + "0100"	
	
IF dw_print.Retrieve(sabu_f, sabu_t, lsyear ,lscd) <= 0 THEN
	f_messagechk(14, "")
	dw_ip.SetFocus()
	dw_list.insertrow(0)
	//Return -1
END IF
dw_print.sharedata(dw_list)

Return 1

end function

on w_kfib11.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_1=create st_1
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
end on

on w_kfib11.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;call super::open;string s_gidate

s_gidate = left(f_today(), 4) 

dw_ip.setitem(1, "gijun_year", s_gidate)
end event

type p_preview from w_standard_print`p_preview within w_kfib11
end type

type p_exit from w_standard_print`p_exit within w_kfib11
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_kfib11
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfib11
end type







type st_10 from w_standard_print`st_10 within w_kfib11
end type



type dw_print from w_standard_print`dw_print within w_kfib11
string dataobject = "d_kfib11_3_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfib11
integer x = 46
integer y = 8
integer width = 1819
integer height = 216
string dataobject = "d_kfib11_1"
end type

event dw_ip::itemchanged;string ls_code, ls_name, snull, ls_gijun_date

SetNull(snull)

if this.GetColumnName() ='gijun_year' then
	ls_gijun_date = this.GetText()
	if trim(ls_gijun_date) = '' or isnull(ls_gijun_date) then
		F_MessageChk(1, "[기준년도]")
		return 1
	elseif f_datechk(ls_gijun_date+'0101') = -1 then
			 F_MessageChk(21, "[기준년도]")
			 return 1
	end if
end if

IF this.GetColumnName() = "lo_cd"  THEN
	ls_code = this.GetText()
	IF ls_code ="" OR IsNull(ls_code) THEN 
		this.SetItem(this.GetRow(), 'lo_name', snull)
		Return
	END IF
	
	SELECT "KFM03OT0"."LO_NAME"  
     INTO :ls_name
     FROM "KFM03OT0"  
    WHERE "KFM03OT0"."LO_CD" = :ls_code ;
   
	IF SQLCA.SQLCODE <> 0 THEN
//		MessageBox("확 인","등록된 차입금코드가 아닙니다!!")
//	   this.SetItem(this.GetRow(), 'lo_cd', snull)						
//	   this.SetItem(this.GetRow(), 'lo_name', snull)
//	   dw_ip.SetColumn('lo_cd')
//		dw_ip.SetFocus()
//		Return 1
	ELSE
		this.SetItem(this.GetRow(),"lo_name",ls_name)
	END IF
END IF


	
end event

event dw_ip::rbuttondown;string snull

SetNull(snull)
SetNull(gs_code)
SetNull(gs_codename)

this.accepttext()

IF this.GetColumnName() ="lo_cd" THEN
	gs_code = Trim(this.GetItemString(this.GetRow(),"lo_cd"))
	gs_codename = Trim(this.GetItemString(this.GetRow(),"lo_name"))
	IF IsNull(gs_code) THEN
		gs_code =""
   END IF
	OPEN(W_KFM03OT0_POPUP)
	IF NOT ISNULL(GS_CODE) THEN
		this.SetItem(1, "lo_cd", gs_code)
	   this.setitem(1, "lo_name", gs_codename)
	ELSE
      RETURN
   END IF
	THIS.TriggerEvent(ItemChanged!)    
END IF
end event

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;IF keydown(keytab!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type dw_list from w_standard_print`dw_list within w_kfib11
integer x = 59
integer y = 228
integer width = 4517
integer height = 1984
string dataobject = "d_kfib11_3"
boolean border = false
end type

type rb_1 from radiobutton within w_kfib11
integer x = 1906
integer y = 116
integer width = 206
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "원금"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN
	dw_list.dataObject='d_kfib11_3'
	dw_print.dataObject='d_kfib11_3_p'
//ElseIf rb_1.Checked = True and rb_5.Checked = True Then
//	dw_list.DataObject = 'd_kfib11_3_dot'
END IF

dw_list.title ="월별 차입금 상환계획(원금)"
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_2 from radiobutton within w_kfib11
integer x = 2130
integer y = 116
integer width = 206
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "이자"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.SetRedraw(False)
IF rb_2.Checked =True THEN
	dw_list.DataObject='d_kfib11_4'
	dw_print.DataObject='d_kfib11_4_p'
//ElseIf rb_2.Checked = True and rb_5.Checked = True Then
//	dw_list.DataObject = 'd_kfib11_4_dot'
END IF

dw_list.title ="월별 차입금 상환계획(이자)"
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_3 from radiobutton within w_kfib11
integer x = 2354
integer y = 116
integer width = 206
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "실적"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_list.SetRedraw(False)
IF rb_3.Checked =True THEN
	dw_list.dataObject='d_kfib11_2'
	dw_print.dataObject='d_kfib11_2_p'
//ElseIf rb_3.Checked = True and rb_5.Checked = True Then
//	dw_list.DataObject = 'd_kfib11_2_dot'
END IF

dw_list.title ="월별 차입금 상환계획(실적)"
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type st_1 from statictext within w_kfib11
integer x = 1902
integer y = 56
integer width = 402
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "출력구분"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfib11
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1865
integer y = 12
integer width = 750
integer height = 204
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfib11
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 224
integer width = 4544
integer height = 2004
integer cornerheight = 40
integer cornerwidth = 55
end type

