$PBExportHeader$wp_pip3202.srw
$PBExportComments$** 국민/건강보험 현황
forward
global type wp_pip3202 from w_standard_print
end type
type dw_1 from datawindow within wp_pip3202
end type
type dw_2 from datawindow within wp_pip3202
end type
type p_2 from uo_picture within wp_pip3202
end type
type rr_1 from roundrectangle within wp_pip3202
end type
end forward

global type wp_pip3202 from w_standard_print
integer x = 0
integer y = 0
string title = "국민/건강보험 현황"
dw_1 dw_1
dw_2 dw_2
p_2 p_2
rr_1 rr_1
end type
global wp_pip3202 wp_pip3202

type variables

end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_saup, ls_deptcode, ls_jikjong, ls_kunmu, ls_date

w_mdi_frame.sle_msg.text = '조회중.....'

dw_ip.AcceptText()
ls_saup		= dw_ip.GetItemString(1,'saup')
ls_deptcode	= dw_ip.GetItemString(1,'deptcode')
ls_jikjong	= dw_ip.GetItemString(1,'jikjong')
ls_kunmu		= dw_ip.GetItemString(1,'kunmu')
ls_date		= dw_ip.GetItemString(1,'sdate')

IF f_datechk(ls_date) = -1 THEN
	Messagebox('확인','퇴직기준일자를 확인하세요!')
	dw_ip.SetColumn('sdate')
	dw_ip.SetFocus()
END IF

IF IsNull(ls_saup)		OR ls_saup = '' 		THEN ls_saup = '%'
IF IsNull(ls_deptcode)	OR ls_deptcode = ''	THEN ls_deptcode = '%'
IF IsNull(ls_jikjong)	OR ls_jikjong = ''	THEN ls_jikjong = '%'
IF IsNull(ls_kunmu)		OR ls_kunmu = ''		THEN ls_kunmu = '%'

IF dw_print.Retrieve(gs_company,ls_saup,ls_deptcode,ls_jikjong,ls_kunmu, ls_date) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!",StopSign!)
	Return -1
END IF

p_2.visible = true
w_mdi_frame.sle_msg.text = "조회를 완료하였습니다!!"
return 1
end function

on wp_pip3202.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.p_2=create p_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.p_2
this.Control[iCurrent+4]=this.rr_1
end on

on wp_pip3202.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.p_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

dw_ip.SetITem(1,"sdate",f_today())

/*사업장 정보 셋팅*/
//f_set_saupcd(dw_ip,'saupcd')
is_saupcd = '%'
p_retrieve.TriggerEvent(Clicked!)
end event

type p_preview from w_standard_print`p_preview within wp_pip3202
integer x = 4027
end type

type p_exit from w_standard_print`p_exit within wp_pip3202
integer x = 4375
end type

type p_print from w_standard_print`p_print within wp_pip3202
integer x = 4201
end type

type p_retrieve from w_standard_print`p_retrieve within wp_pip3202
integer x = 3854
end type

type st_window from w_standard_print`st_window within wp_pip3202
boolean visible = false
integer x = 2336
integer y = 2584
end type

type sle_msg from w_standard_print`sle_msg within wp_pip3202
boolean visible = false
integer x = 361
integer y = 2584
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip3202
boolean visible = false
integer x = 2830
integer y = 2584
end type

type st_10 from w_standard_print`st_10 within wp_pip3202
boolean visible = false
integer x = 0
integer y = 2584
end type



type dw_print from w_standard_print`dw_print within wp_pip3202
integer x = 3310
string dataobject = "dp_pip3202_1_p"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip3202
integer x = 521
integer y = 8
integer width = 2450
integer height = 216
string dataobject = "d_pip1004_2"
end type

event dw_ip::itemchanged;String sDeptno,sName,snull,sEmpNo,sEmpName

SetNull(snull)

This.AcceptText()

IF dw_ip.GetColumnName() = "saupcd" THEN
	is_saupcd = dw_ip.GetText()
	IF is_saupcd = '' OR ISNULL(is_saupcd) THEN is_saupcd = '%'
END IF	


IF dw_ip.GetColumnName() ="deptcode" THEN 
   sDeptno = dw_ip.GetText()
	IF sDeptno = '' OR ISNULL(sDeptno) THEN
		dw_ip.SetITem(1,"deptcode",snull)
		dw_ip.SetITem(1,"deptname",snull)
		Return 
	END IF	
	
	  SELECT  "P0_DEPT"."DEPTNAME"  
		INTO :sName  
		FROM "P0_DEPT"  
		WHERE ( "P0_DEPT"."COMPANYCODE" = :gs_company ) AND  
				( "P0_DEPT"."DEPTCODE" = :sDeptno ); 
	
	IF sName = '' OR ISNULL(sName) THEN
   	MessageBox("확 인","부서번호를 확인하세요!!") 
		dw_ip.SetITem(1,"deptcode",snull)
	   dw_ip.SetITem(1,"deptname",snull) 
		dw_ip.SetColumn("deptcode")
      Return 1
	END IF	
	   dw_ip.SetITem(1,"deptname",sName) 
END IF



end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF dw_ip.GetColumnName() = "deptcode" THEN
	gs_gubun = is_saupcd
	Open(w_dept_saup_popup)
	
	IF IsNull(Gs_code) THEN RETURN
	dw_ip.SetITem(1,"deptcode",gs_code)
	TriggerEvent(Itemchanged!)
END IF	

end event

type dw_list from w_standard_print`dw_list within wp_pip3202
integer x = 544
integer y = 236
integer width = 3557
integer height = 2100
string dataobject = "dp_pip3202_1"
boolean border = false
boolean hsplitscroll = false
end type

event dw_list::rowfocuschanged;return
end event

event dw_list::clicked;return
end event

type dw_1 from datawindow within wp_pip3202
boolean visible = false
integer x = 553
integer y = 2360
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(지급)"
string dataobject = "dp_pip3130_30"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within wp_pip3202
boolean visible = false
integer x = 1504
integer y = 2360
integer width = 914
integer height = 92
boolean bringtotop = true
boolean titlebar = true
string title = "TEXT 찍기용 데이타윈도우(공제)"
string dataobject = "dp_pip3130_40"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type p_2 from uo_picture within wp_pip3202
boolean visible = false
integer x = 3575
integer y = 24
integer width = 178
integer taborder = 90
boolean bringtotop = true
string picturename = "C:\erpman\image\excel_up.gif"
end type

event clicked;call super::clicked;integer fh, ret

blob Emp_pic
string txtname 
string dw_lists
string defext = "xls"
string Filter = "Excel Files (*.xls), *.xls"

ret = GetFileSaveName("Save Excel", txtname, dw_lists, defext, filter)

dw_list.SaveAsAscii(txtname)

end event

event ue_lbuttondown;call super::ue_lbuttondown;picturename = 'C:\erpman\image\excel_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;picturename = 'C:\erpman\image\excel_up.gif'
end event

type rr_1 from roundrectangle within wp_pip3202
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 530
integer y = 228
integer width = 3579
integer height = 2116
integer cornerheight = 40
integer cornerwidth = 55
end type

