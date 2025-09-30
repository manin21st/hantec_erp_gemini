$PBExportHeader$wp_pip5033.srw
$PBExportComments$** 사업소득 원천징수영수증
forward
global type wp_pip5033 from w_standard_print
end type
type rb_1 from radiobutton within wp_pip5033
end type
type rb_2 from radiobutton within wp_pip5033
end type
type rb_3 from radiobutton within wp_pip5033
end type
type gb_1 from groupbox within wp_pip5033
end type
type rr_2 from roundrectangle within wp_pip5033
end type
end forward

global type wp_pip5033 from w_standard_print
integer x = 0
integer y = 0
string title = "사업소득 원천징수영수증"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
rr_2 rr_2
end type
global wp_pip5033 wp_pip5033

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sYm,ls_gubun,ls_Empno,ls_semu,ls_date

dw_ip.AcceptText()

sYm      = dw_ip.GetITemString(1,"l_ym")
//ls_gubun = dw_ip.GetITemString(1,"l_gubn")  /*급여,상여구분*/
ls_Empno = dw_ip.GetITemString(1,"l_empno") 
ls_semu  = dw_ip.GetITemString(1,"l_semu") 
ls_date  = dw_ip.GetITemString(1,"l_date") 

//IF sYm = "      " OR IsNull(sYm) THEN
//	MessageBox("확 인","조회년도를 입력하세요!!")
//	dw_ip.SetColumn("l_ym")
//	dw_ip.SetFocus()
//	Return -1
//ELSE
//  IF f_datechk(sYm + '01') = -1 THEN
//   MessageBox("확인","조회년도를 확인하세요!!")
//	dw_ip.SetColumn("l_ym")
//	dw_ip.SetFocus()
//	Return -1
//  END IF	
//END IF 

ls_gubun = 'P'

IF ls_Empno = '' OR ISNULL(ls_Empno) THEN
	ls_Empno = '%'
END IF	

IF dw_list.Retrieve(sYm,is_saupcd,ls_Empno,ls_semu) <=0 THEN
	MessageBox("확 인","조회한 자료가 없습니다!!")
	dw_list.InsertRow(0)
	Return -1
END IF

if rb_1.checked = true then
	dw_list.object.st_name.text = '(발행자 보관용)'
elseif rb_2.checked = true then
   dw_list.object.st_name.text = '(발행자 보고용)' 
else
	dw_list.object.st_name.text = '(소득자 보관용)' 
end if

dw_list.object.t_payyear.text  = sYm
dw_list.object.t_year.text  = left(ls_date,4)
dw_list.object.t_month.text = mid(ls_date,5,2)
dw_list.object.t_day.text   = right(ls_date,2)
dw_list.object.t_semu.text  = ls_semu
Return 1
end function

on wp_pip5033.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.rr_2
end on

on wp_pip5033.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
destroy(this.rr_2)
end on

event open;call super::open;dw_list.InsertRow(0)

dw_ip.SetITem(1,"l_ym",Left(f_today(),4))
dw_ip.SetITem(1,"l_date",f_today())

String semuName

SELECT "P0_SYSCNFG"."DATANAME" 
 INTO :semuName
 FROM "P0_SYSCNFG"  
WHERE ( "P0_SYSCNFG"."SERIAL" = 70 ) AND  
		( "P0_SYSCNFG"."LINENO" = '2' );
		
dw_ip.Setitem(1,'l_semu', semuName)

is_saupcd = '%'
end event

type p_preview from w_standard_print`p_preview within wp_pip5033
integer x = 4073
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_list)	

end event

type p_exit from w_standard_print`p_exit within wp_pip5033
integer x = 4421
end type

type p_print from w_standard_print`p_print within wp_pip5033
integer x = 4247
end type

event p_print::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)
end event

type p_retrieve from w_standard_print`p_retrieve within wp_pip5033
integer x = 3899
end type

type st_window from w_standard_print`st_window within wp_pip5033
integer x = 2418
integer y = 2960
end type

type sle_msg from w_standard_print`sle_msg within wp_pip5033
integer x = 439
integer y = 2972
end type

type dw_datetime from w_standard_print`dw_datetime within wp_pip5033
integer x = 2907
integer y = 2972
end type

type st_10 from w_standard_print`st_10 within wp_pip5033
integer x = 78
integer y = 2972
end type

type gb_10 from w_standard_print`gb_10 within wp_pip5033
integer x = 64
integer y = 2920
end type

type dw_print from w_standard_print`dw_print within wp_pip5033
string dataobject = "dp_pip5033_2"
end type

type dw_ip from w_standard_print`dw_ip within wp_pip5033
integer x = 315
integer y = 28
integer width = 2647
integer height = 272
string dataobject = "dp_pip5033_1"
end type

event dw_ip::itemchanged;String  SaupCode,sCode,sempname,sempno,snull
int il_count
SetNull(snull)

This.AcceptText()

IF dw_ip.GetColumnName() = "l_saup" THEN
   is_saupcd = dw_ip.GetText()
	IF is_saupcd = '' OR ISNULL(is_saupcd) THEN is_saupcd = '%'
END IF

if This.GetColumnName() = 'l_empno' then
	sempno = this.Gettext()

   IF sempno ="" OR IsNull(sempno) THEN RETURN   

	SELECT count(*) INTO :il_count
	  FROM "P3_SAUPMASTER"
	 WHERE "P3_SAUPMASTER"."EMPNO" = :sempno;

	IF il_Count > 0 THEN
		SELECT "EMPNAME" INTO :sempname
		  FROM "P3_SAUPMASTER"
		 WHERE "P3_SAUPMASTER"."EMPNO" = :sempno;
	ELSE
		Messagebox("확 인","등록되지 않은 코드이므로 조회할 수 없습니다!!")
		this.setitem(1,'l_empno', snull)
		this.setitem(1,'l_empname', snull)
		this.SetColumn('l_empno')
		this.SetFocus()
		return
	END IF
	
	this.Setitem(1,'l_empname', sempname)
	
end if

end event

event dw_ip::itemerror;Return 1
end event

event dw_ip::rbuttondown;call super::rbuttondown;string sempname, sempno, snull

SetNull(Gs_codename)
SetNull(Gs_code)
	
Gs_gubun = is_saupcd

if This.GetColumnName() = 'l_empno' then

	open(w_saupja_popup)
		
	IF IsNull(Gs_code) THEN RETURN
	 
	this.SetITem(1,"l_empno",Gs_code)
	this.SetITem(1,"l_empname",Gs_codename)
	
end if

end event

type dw_list from w_standard_print`dw_list within wp_pip5033
integer x = 325
integer y = 324
integer width = 3662
integer height = 1992
string dataobject = "dp_pip5033_2"
boolean border = false
end type

type rb_1 from radiobutton within wp_pip5033
integer x = 3040
integer y = 104
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "발행자 보관용"
boolean checked = true
end type

type rb_2 from radiobutton within wp_pip5033
boolean visible = false
integer x = 3552
integer y = 204
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "발행자 보고용"
end type

type rb_3 from radiobutton within wp_pip5033
integer x = 3040
integer y = 188
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "소득자 보관용"
end type

type gb_1 from groupbox within wp_pip5033
integer x = 2985
integer y = 32
integer width = 562
integer height = 256
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "출력구분"
end type

type rr_2 from roundrectangle within wp_pip5033
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 311
integer y = 312
integer width = 3694
integer height = 2016
integer cornerheight = 40
integer cornerwidth = 55
end type

