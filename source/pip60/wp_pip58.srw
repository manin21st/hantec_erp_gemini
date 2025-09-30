$PBExportHeader$wp_pip58.srw
$PBExportComments$** 국민/의보 년도별 명세서
forward
global type wp_pip58 from w_standard_print
end type
type rb_1 from radiobutton within wp_pip58
end type
type rb_2 from radiobutton within wp_pip58
end type
type rb_3 from radiobutton within wp_pip58
end type
type st_1 from statictext within wp_pip58
end type
type rr_1 from roundrectangle within wp_pip58
end type
type ln_1 from line within wp_pip58
end type
type rr_2 from roundrectangle within wp_pip58
end type
end forward

global type wp_pip58 from w_standard_print
string title = "년간 연금/보험 납입내역서"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_1 st_1
rr_1 rr_1
ln_1 ln_1
rr_2 rr_2
end type
global wp_pip58 wp_pip58

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_date, ls_yy, ls_empno, ls_sabu

dw_ip.accepttext()


ls_yy = trim(dw_ip.getitemstring(1, "s_date"))
ls_empno = dw_ip.GetitemString(1,'empno')
ls_sabu  = dw_ip.GetitemString(1,'saupcd')


IF isnull(ls_yy) or ls_yy = "" then 
	messagebox("확 인", "작업년도를 입력하세요.!!")
	dw_ip.SetColumn(1) 
   dw_ip.SetFocus( ) 
   return -1
END IF

if IsNull(ls_empno) or ls_empno = '' then ls_empno = '%'

ls_date = ls_yy + '0101'

IF f_datechk(ls_date) = -1 THEN
   MessageBox("확 인","작업년도를 확인하세요!!")
	dw_ip.SetColumn(1) 
   dw_ip.SetFocus( ) 
	Return -1
END IF		

SetPointer(HourGlass!)

dw_list.SetRedraw(False)		

IF dw_print.Retrieve(gs_company, ls_date, ls_empno, ls_sabu) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	sle_msg.text =""
   dw_list.SetRedraw(True)
	dw_ip.SetColumn(1) 
   dw_ip.SetFocus( ) 
   return -1
	
END IF

w_mdi_frame.sle_msg.text ="조회완료!"
 

dw_list.SetRedraw(True)

return 1







end function

on wp_pip58.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_1=create st_1
this.rr_1=create rr_1
this.ln_1=create ln_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.ln_1
this.Control[iCurrent+7]=this.rr_2
end on

on wp_pip58.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_1)
destroy(this.rr_1)
destroy(this.ln_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_ip.setitem( 1, "s_date", left(gs_today, 4))

f_set_saupcd(dw_ip,'saupcd','1')
is_saupcd = gs_saupcd

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)
end event

type p_preview from w_standard_print`p_preview within wp_pip58
end type

type p_exit from w_standard_print`p_exit within wp_pip58
end type

type p_print from w_standard_print`p_print within wp_pip58
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip58
end type







type st_10 from w_standard_print`st_10 within wp_pip58
end type



type dw_print from w_standard_print`dw_print within wp_pip58
string dataobject = "dp_pip58_2_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip58
event ue_keyenter pbm_keydown
integer x = 96
integer y = 44
integer width = 2158
integer height = 84
string dataobject = "dp_pip58_1"
end type

event ue_keyenter;if KeyDown(KeyEnter!) then
   Send( Handle(this), 256, 9, 0 )
   Return 1
end if
end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String snull,sEmpNo,sEmpName

SetNull(snull)


IF dw_ip.GetColumnName() = "empno" then
   sEmpNo = dw_ip.GetItemString(1,"empno")

	IF sEmpNo = '' or isnull(sEmpNo) THEN
	   dw_ip.SetITem(1,"empno",snull)
		dw_ip.SetITem(1,"empname",snull)
	ELSE	
			SELECT "P1_MASTER"."EMPNAME"  
				INTO :sEmpName  
				FROM "P1_MASTER"  
				WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
						( "P1_MASTER"."EMPNO" = :sEmpNo ) ;
			 
			 IF SQLCA.SQLCODE<>0 THEN
				 MessageBox("확 인","사원번호를 확인하세요!!") 
				 dw_ip.SetITem(1,"empno",snull)
				 dw_ip.SetITem(1,"empname",snull)
				 RETURN 1 
			 END IF
				dw_ip.SetITem(1,"empname",sEmpName  )
				
	 END IF
END IF

IF dw_ip.GetColumnName() = "saupcd" then
	is_saupcd = this.Gettext()
	
END IF	



end event

event dw_ip::rbuttondown;call super::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF dw_ip.GetColumnName() = "empno" THEN
   Open(w_employee_popup)

   if isnull(gs_code) or gs_code = '' then return
   dw_ip.SetITem(1,"empno",gs_code)
	dw_ip.SetITem(1,"empname",gs_codename)
  
END IF	
end event

type dw_list from w_standard_print`dw_list within wp_pip58
integer x = 32
integer y = 276
integer width = 4539
string dataobject = "dp_pip58_2"
end type

type rb_1 from radiobutton within wp_pip58
integer x = 370
integer y = 136
integer width = 361
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = " 국민연금"
end type

event clicked;dw_list.SetRedraw(False)

dw_list.dataObject='dp_pip58_2'
dw_print.dataObject='dp_pip58_2_p'

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_2 from radiobutton within wp_pip58
integer x = 745
integer y = 136
integer width = 361
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = " 건강보험"
end type

event clicked;dw_list.SetRedraw(False)

dw_list.dataObject='dp_pip58_3'
dw_print.dataObject='dp_pip58_3_p'

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_3 from radiobutton within wp_pip58
integer x = 1115
integer y = 136
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = " 고용보험"
end type

event clicked;dw_list.SetRedraw(False)

dw_list.dataObject='dp_pip58_4'
dw_print.dataObject='dp_pip58_4_p'

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


end event

type st_1 from statictext within wp_pip58
integer x = 119
integer y = 140
integer width = 233
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "구    분"
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within wp_pip58
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 46
integer y = 24
integer width = 2350
integer height = 200
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within wp_pip58
integer linethickness = 1
integer beginx = 370
integer beginy = 196
integer endx = 1541
integer endy = 196
end type

type rr_2 from roundrectangle within wp_pip58
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 16777215
integer x = 18
integer y = 264
integer width = 4571
integer height = 2044
integer cornerheight = 40
integer cornerwidth = 55
end type

