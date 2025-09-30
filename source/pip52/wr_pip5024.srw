$PBExportHeader$wr_pip5024.srw
$PBExportComments$정산자료 check list
forward
global type wr_pip5024 from w_standard_print
end type
type rr_2 from roundrectangle within wr_pip5024
end type
type rb_1 from radiobutton within wr_pip5024
end type
type rb_2 from radiobutton within wr_pip5024
end type
type st_2 from statictext within wr_pip5024
end type
type dw_saup from datawindow within wr_pip5024
end type
type rr_1 from roundrectangle within wr_pip5024
end type
type rr_3 from roundrectangle within wr_pip5024
end type
end forward

global type wr_pip5024 from w_standard_print
string title = "정산자료 Check List"
rr_2 rr_2
rb_1 rb_1
rb_2 rb_2
st_2 st_2
dw_saup dw_saup
rr_1 rr_1
rr_3 rr_3
end type
global wr_pip5024 wr_pip5024

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string syear, ssaup, sdept


if dw_ip.Accepttext() = -1 then return -1
if dw_saup.Accepttext() = -1 then return -1

syear = dw_ip.GetitemString(1,'syear')
ssaup = dw_saup.GetitemString(1,'saupcd')
sdept = dw_saup.GetitemString(1,'deptcode')		

if trim(ssaup) = '' or isnull(ssaup) then ssaup = '%'
if trim(sdept) = '' or isnull(sdept) then sdept = '%'

IF dw_print.Retrieve(gs_company, syear, ssaup, sdept) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	sle_msg.text =""
   return -1
ELSE
	sle_msg.text ="조 회"
END IF

   dw_print.sharedata(dw_list)

return 1
end function

on wr_pip5024.create
int iCurrent
call super::create
this.rr_2=create rr_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_2=create st_2
this.dw_saup=create dw_saup
this.rr_1=create rr_1
this.rr_3=create rr_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.dw_saup
this.Control[iCurrent+6]=this.rr_1
this.Control[iCurrent+7]=this.rr_3
end on

on wr_pip5024.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_2)
destroy(this.dw_saup)
destroy(this.rr_1)
destroy(this.rr_3)
end on

event open;call super::open;dw_saup.SetTransObject(sqlca)
dw_saup.insertrow(0)

f_set_saupcd(dw_saup, 'saupcd', '1')
is_saupcd = gs_saupcd

dw_ip.insertrow(0)
dw_ip.setitem(1,'syear', left(f_today(),4))

rb_1.Checked =True
rb_1.TriggerEvent(Clicked!)
//p_retrieve.TriggerEvent(Clicked!)
end event

type p_preview from w_standard_print`p_preview within wr_pip5024
end type

type p_exit from w_standard_print`p_exit within wr_pip5024
end type

type p_print from w_standard_print`p_print within wr_pip5024
end type

type p_retrieve from w_standard_print`p_retrieve within wr_pip5024
end type







type st_10 from w_standard_print`st_10 within wr_pip5024
end type



type dw_print from w_standard_print`dw_print within wr_pip5024
string dataobject = "dr_pip5024_1_p"
end type

type dw_ip from w_standard_print`dw_ip within wr_pip5024
integer x = 174
integer y = 56
integer width = 507
integer height = 84
string dataobject = "dr_pip5024_3"
end type

type dw_list from w_standard_print`dw_list within wr_pip5024
integer x = 50
integer y = 268
integer width = 4558
integer height = 1948
string dataobject = "dr_pip5024_1"
boolean border = false
end type

type rr_2 from roundrectangle within wr_pip5024
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 114
integer y = 44
integer width = 2126
integer height = 192
integer cornerheight = 40
integer cornerwidth = 55
end type

type rb_1 from radiobutton within wr_pip5024
integer x = 2674
integer y = 72
integer width = 539
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = " 정산추가자료"
end type

event clicked;dw_list.SetRedraw(False)
IF rb_1.Checked =True THEN	
	dw_list.dataObject='dr_pip5024_1'
END IF
dw_list.SetRedraw(True)
dw_list.SetTransObject(SQLCA)


dw_print.SetRedraw(False)
IF rb_1.Checked =True THEN	
	dw_print.dataObject='dr_pip5024_1_p'
END IF
dw_print.title ="정산추가자료 LIST"
//w_mdi_frame.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

dw_print.SetRedraw(True)

dw_print.SetTransObject(SQLCA)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

end event

type rb_2 from radiobutton within wr_pip5024
integer x = 2674
integer y = 144
integer width = 539
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = " 전근무지자료"
end type

event clicked;dw_list.SetRedraw(False)
IF rb_2.Checked =True THEN
	
	dw_list.dataObject='dr_pip5024_2'
END IF
dw_list.title ="전근무지자료 LIST"
//sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

dw_list.SetRedraw(True)

dw_list.SetTransObject(SQLCA)


dw_print.SetRedraw(False)
IF rb_2.Checked =True THEN
	
	dw_print.dataObject='dr_pip5024_2_p'
END IF
dw_print.title ="정산추가자료 LIST"
//w_mdi_frame.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"

dw_print.SetRedraw(True)

dw_print.SetTransObject(SQLCA)

p_print.Enabled =False
p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

p_preview.enabled = False
p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
end event

type st_2 from statictext within wr_pip5024
integer x = 2345
integer y = 84
integer width = 261
integer height = 44
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "출력형태"
boolean focusrectangle = false
end type

type dw_saup from datawindow within wr_pip5024
integer x = 247
integer y = 140
integer width = 1947
integer height = 80
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_saupcd_1"
boolean border = false
boolean livescroll = true
end type

event itemchanged;String sDeptno,SetNull,sName

setnull(SetNull)

this.AcceptText()

IF this.GetColumnName() = 'saupcd' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF this.GetColumnName() ="deptcode" THEN 
   sDeptno = this.GetText()
	IF sDeptno = '' OR ISNULL(sDeptno) THEN
		this.SetITem(1,"deptcode",SetNull)
		this.SetITem(1,"deptname",SetNull)
		p_retrieve.TriggerEvent(Clicked!)
		return
	END IF	
	
	  SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :sDeptno ); 
	
	IF sName = '' OR ISNULL(sName) THEN
   	MessageBox("확 인","부서번호를 확인하세요!!") 
		this.SetITem(1,"deptcode",SetNull)
	   this.SetITem(1,"deptname",SetNull) 
		this.SetColumn("deptcode")
		return 1
	END IF	
	   this.SetITem(1,"deptname",sName) 
END IF

p_retrieve.TriggerEvent(Clicked!)
end event

event rbuttondown;IF this.GetColumnName() = "deptcode" THEN
	SetNull(gs_code)
	SetNull(gs_codename)
	SetNull(Gs_gubun)
	
	GS_gubun = is_saupcd
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	this.SetITem(1,"deptcode",gs_code)
	this.TriggerEvent(ItemChanged!)
END IF
end event

type rr_1 from roundrectangle within wr_pip5024
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 2258
integer y = 48
integer width = 978
integer height = 188
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within wr_pip5024
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 264
integer width = 4590
integer height = 1984
integer cornerheight = 40
integer cornerwidth = 55
end type

