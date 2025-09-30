$PBExportHeader$w_pip5021.srw
$PBExportComments$연말/중도 정산 계산
forward
global type w_pip5021 from w_inherite_standard
end type
type dw_pay_personal from datawindow within w_pip5021
end type
type st_5 from statictext within w_pip5021
end type
type dw_taxcal_data from datawindow within w_pip5021
end type
type em_cnt from editmask within w_pip5021
end type
type st_10 from statictext within w_pip5021
end type
type st_percent from statictext within w_pip5021
end type
type p_2 from picture within w_pip5021
end type
type p_1 from picture within w_pip5021
end type
type cb_calcu from commandbutton within w_pip5021
end type
type dw_domain2 from u_d_select_sort within w_pip5021
end type
type st_3 from statictext within w_pip5021
end type
type st_2 from statictext within w_pip5021
end type
type pb_1 from picturebutton within w_pip5021
end type
type pb_2 from picturebutton within w_pip5021
end type
type dw_domain1 from u_d_select_sort within w_pip5021
end type
type rb_3 from radiobutton within w_pip5021
end type
type rb_2 from radiobutton within w_pip5021
end type
type rb_1 from radiobutton within w_pip5021
end type
type rb_all from radiobutton within w_pip5021
end type
type rb_per from radiobutton within w_pip5021
end type
type st_7 from statictext within w_pip5021
end type
type sle_start from singlelineedit within w_pip5021
end type
type sle_end from singlelineedit within w_pip5021
end type
type st_8 from statictext within w_pip5021
end type
type p_compute from uo_picture within w_pip5021
end type
type gb_4 from groupbox within w_pip5021
end type
type rr_1 from roundrectangle within w_pip5021
end type
type rr_5 from roundrectangle within w_pip5021
end type
type rr_4 from roundrectangle within w_pip5021
end type
type rr_3 from roundrectangle within w_pip5021
end type
type rr_7 from roundrectangle within w_pip5021
end type
type rr_6 from roundrectangle within w_pip5021
end type
type dw_ip from u_key_enter within w_pip5021
end type
type dw_domain3 from u_d_select_sort within w_pip5021
end type
end forward

shared variables

end variables

global type w_pip5021 from w_inherite_standard
integer x = 5
integer y = 4
string title = "연말/중도 정산 계산"
dw_pay_personal dw_pay_personal
st_5 st_5
dw_taxcal_data dw_taxcal_data
em_cnt em_cnt
st_10 st_10
st_percent st_percent
p_2 p_2
p_1 p_1
cb_calcu cb_calcu
dw_domain2 dw_domain2
st_3 st_3
st_2 st_2
pb_1 pb_1
pb_2 pb_2
dw_domain1 dw_domain1
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
rb_all rb_all
rb_per rb_per
st_7 st_7
sle_start sle_start
sle_end sle_end
st_8 st_8
p_compute p_compute
gb_4 gb_4
rr_1 rr_1
rr_5 rr_5
rr_4 rr_4
rr_3 rr_3
rr_7 rr_7
rr_6 rr_6
dw_ip dw_ip
dw_domain3 dw_domain3
end type
global w_pip5021 w_pip5021

type variables
string       iv_empno,      iv_tag,     iv_empname,   &
               iv_startdate,       iv_enddate,                  &
               iv_fromdate,       iv_todate , iv_jikjonggubn , &
               iv_enterdate , iv_syymm
 
Boolean    iv_is_changed = False


integer      iv_workcoupletag,      iv_wifetag,         &
                 iv_womanhousetag,                             &
                 iv_dependent,            iv_rubber,           &
                 iv_respect,                 iv_child

long d1_CurrentRow, d2_CurrentRow
string gubun

DataWindow dw_Process

integer il_rowcount

String print_gu                 //window가 조회인지 인쇄인지  

String     is_preview        // dw상태가 preview인지
Integer   ii_factor = 100           // 프린트 확대축소
boolean   iv_b_down = false


end variables

forward prototypes
public function string wf_proceduresql ()
end prototypes

public function string wf_proceduresql ();
Int    k 
String sGetSqlSyntax,sEmpNo
Long   lSyntaxLength

sGetSqlSyntax = 'select empno,jikjonggubn,enterdate,retiredate,jhgubn,paygubn,consmatgubn,kmgubn,engineergubn,'+ "'%'" +' from p1_master'

dw_Process.AcceptText()

sGetSqlSyntax = sGetSqlSyntax + ' where ('

FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_Process.GetItemString(k,"empno")
	
	sGetSqlSyntax = sGetSqlSyntax + ' (empno =' + "'"+ sEmpNo +"')"+ ' or'
	
NEXT

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax    = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ")"

Return sGetSqlSynTax


end function

on w_pip5021.create
int iCurrent
call super::create
this.dw_pay_personal=create dw_pay_personal
this.st_5=create st_5
this.dw_taxcal_data=create dw_taxcal_data
this.em_cnt=create em_cnt
this.st_10=create st_10
this.st_percent=create st_percent
this.p_2=create p_2
this.p_1=create p_1
this.cb_calcu=create cb_calcu
this.dw_domain2=create dw_domain2
this.st_3=create st_3
this.st_2=create st_2
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_domain1=create dw_domain1
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.rb_all=create rb_all
this.rb_per=create rb_per
this.st_7=create st_7
this.sle_start=create sle_start
this.sle_end=create sle_end
this.st_8=create st_8
this.p_compute=create p_compute
this.gb_4=create gb_4
this.rr_1=create rr_1
this.rr_5=create rr_5
this.rr_4=create rr_4
this.rr_3=create rr_3
this.rr_7=create rr_7
this.rr_6=create rr_6
this.dw_ip=create dw_ip
this.dw_domain3=create dw_domain3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pay_personal
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.dw_taxcal_data
this.Control[iCurrent+4]=this.em_cnt
this.Control[iCurrent+5]=this.st_10
this.Control[iCurrent+6]=this.st_percent
this.Control[iCurrent+7]=this.p_2
this.Control[iCurrent+8]=this.p_1
this.Control[iCurrent+9]=this.cb_calcu
this.Control[iCurrent+10]=this.dw_domain2
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.pb_1
this.Control[iCurrent+14]=this.pb_2
this.Control[iCurrent+15]=this.dw_domain1
this.Control[iCurrent+16]=this.rb_3
this.Control[iCurrent+17]=this.rb_2
this.Control[iCurrent+18]=this.rb_1
this.Control[iCurrent+19]=this.rb_all
this.Control[iCurrent+20]=this.rb_per
this.Control[iCurrent+21]=this.st_7
this.Control[iCurrent+22]=this.sle_start
this.Control[iCurrent+23]=this.sle_end
this.Control[iCurrent+24]=this.st_8
this.Control[iCurrent+25]=this.p_compute
this.Control[iCurrent+26]=this.gb_4
this.Control[iCurrent+27]=this.rr_1
this.Control[iCurrent+28]=this.rr_5
this.Control[iCurrent+29]=this.rr_4
this.Control[iCurrent+30]=this.rr_3
this.Control[iCurrent+31]=this.rr_7
this.Control[iCurrent+32]=this.rr_6
this.Control[iCurrent+33]=this.dw_ip
this.Control[iCurrent+34]=this.dw_domain3
end on

on w_pip5021.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_pay_personal)
destroy(this.st_5)
destroy(this.dw_taxcal_data)
destroy(this.em_cnt)
destroy(this.st_10)
destroy(this.st_percent)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.cb_calcu)
destroy(this.dw_domain2)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_domain1)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.rb_all)
destroy(this.rb_per)
destroy(this.st_7)
destroy(this.sle_start)
destroy(this.sle_end)
destroy(this.st_8)
destroy(this.p_compute)
destroy(this.gb_4)
destroy(this.rr_1)
destroy(this.rr_5)
destroy(this.rr_4)
destroy(this.rr_3)
destroy(this.rr_7)
destroy(this.rr_6)
destroy(this.dw_ip)
destroy(this.dw_domain3)
end on

event open;call super::open;
dw_datetime.InsertRow(0)

w_mdi_frame.sle_msg.text =""

ib_any_typing=False


string ls_last

dw_domain1.settransobject(SQLCA)
dw_domain3.settransobject(SQLCA)
dw_taxcal_data.settransobject(SQLCA)
dw_pay_personal.settransobject(SQLCA)
dw_datetime.settransobject(sqlca)
dw_datetime.insertrow(0)
dw_ip.settransobject(SQLCA)
dw_ip.insertrow(0)
dw_ip.setitem( 1, "syymm",  left(gs_today, 6) )

f_set_saupcd(dw_ip, 'saup', '1')
is_saupcd = gs_saupcd

iv_startdate = left(gs_today, 4) + '0101'
iv_enddate = left(gs_today, 4) + "1231"

rb_2.Triggerevent(Clicked!)
end event

type p_mod from w_inherite_standard`p_mod within w_pip5021
boolean visible = false
integer x = 2299
integer y = 2384
end type

type p_del from w_inherite_standard`p_del within w_pip5021
boolean visible = false
integer x = 2473
integer y = 2384
end type

type p_inq from w_inherite_standard`p_inq within w_pip5021
integer x = 4041
end type

event p_inq::clicked;call super::clicked;string ls_fromdate, ls_todate , ls_yymm, snull, sSaup, sKunmu

dw_ip.accepttext()

setnull(snull)

iv_syymm = trim(dw_ip.getitemstring(1, 'syymm'))
sSaup = trim(dw_ip.GetItemString(1,"saup"))
sKunmu = trim(dw_ip.GetitemString(1,'kunmu'))

IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'

if iv_syymm= "" or isnull(iv_syymm) then 
	messagebox("확 인", "작업년월을  입력하세요!!")
	dw_ip.setfocus()
	return 
end if	

IF f_datechk(iv_syymm + "01") = -1 THEN
	messagebox('확 인','작업년월을 확인하세요!!')
	dw_ip.SetItem(1,"syymm",snull)
	dw_ip.Setfocus()
END IF

If rb_2.Checked Then                        //연말정산

	iv_startdate = left(iv_syymm, 4) + "0101"	
   iv_enddate = left(iv_syymm, 4) + "1231"

  if dw_domain1.retrieve(gs_company, iv_enddate, sSaup, sKunmu) < 1 then
	  messagebox("확 인", "조회한 자료가 없습니다.!!")
	  return 1
  end if	  

  dw_domain2.reset()
  rb_per.checked = false
  rb_all.checked = true
ELSE                   						     //중도정산
   IF f_datechk(iv_fromdate) = -1 THEN
      MessageBox("확 인","일자를 확인하세요!!")
      dw_ip.setcolumn('sdate')
		dw_ip.setfocus()
	   Return 1
   END IF		

   IF f_datechk(iv_todate) = -1 THEN
      MessageBox("확 인","일자를 확인하세요!!")
      dw_ip.setcolumn('edate')
		dw_ip.setfocus() 
	   Return 1
   END IF		

   if iv_fromdate > iv_todate then
		MessageBox("확 인","대상기간 범위를 확인하세요!!")
      dw_ip.setcolumn('sdate')
		dw_ip.setfocus()
	   Return 1
   END IF		

  if dw_domain3.retrieve(gs_company, iv_fromdate, iv_todate, sSaup, sKunmu) < 1 then
	  messagebox("확 인", "조회한 자료가 없습니다.!!")
	  return 1
  end if	  

END IF	
end event

type p_print from w_inherite_standard`p_print within w_pip5021
boolean visible = false
integer x = 1605
integer y = 2384
end type

type p_can from w_inherite_standard`p_can within w_pip5021
boolean visible = false
integer x = 2647
integer y = 2384
end type

type p_exit from w_inherite_standard`p_exit within w_pip5021
integer x = 4398
end type

type p_ins from w_inherite_standard`p_ins within w_pip5021
boolean visible = false
integer x = 1778
integer y = 2384
end type

type p_search from w_inherite_standard`p_search within w_pip5021
boolean visible = false
integer x = 1426
integer y = 2384
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip5021
boolean visible = false
integer x = 1952
integer y = 2384
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip5021
boolean visible = false
integer x = 2126
integer y = 2384
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip5021
boolean visible = false
integer x = 1166
integer y = 2384
end type

type st_window from w_inherite_standard`st_window within w_pip5021
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip5021
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pip5021
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip5021
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip5021
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip5021
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pip5021
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip5021
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip5021
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip5021
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip5021
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip5021
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip5021
boolean visible = false
end type

type dw_pay_personal from datawindow within w_pip5021
boolean visible = false
integer x = 475
integer y = 3092
integer width = 1915
integer height = 92
integer taborder = 80
boolean bringtotop = true
boolean titlebar = true
string title = "dw_pay_personal"
string dataobject = "d_pip5021_5"
boolean livescroll = true
end type

type st_5 from statictext within w_pip5021
boolean visible = false
integer x = 2661
integer y = 3204
integer width = 325
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean enabled = false
string text = "처리인원"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_taxcal_data from datawindow within w_pip5021
boolean visible = false
integer x = 503
integer y = 3224
integer width = 1970
integer height = 96
integer taborder = 90
boolean bringtotop = true
boolean titlebar = true
string title = "dw_taxcal_data"
string dataobject = "d_pip5021_4"
boolean resizable = true
boolean livescroll = true
end type

type em_cnt from editmask within w_pip5021
boolean visible = false
integer x = 2994
integer y = 3216
integer width = 201
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 79741120
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "#,##0"
end type

type st_10 from statictext within w_pip5021
boolean visible = false
integer x = 3525
integer y = 3212
integer width = 87
integer height = 104
boolean bringtotop = true
integer textsize = -20
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
string text = "%"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_percent from statictext within w_pip5021
boolean visible = false
integer x = 3227
integer y = 3232
integer width = 265
integer height = 108
boolean bringtotop = true
integer textsize = -20
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 12632256
boolean enabled = false
string text = "0"
alignment alignment = right!
boolean focusrectangle = false
end type

type p_2 from picture within w_pip5021
boolean visible = false
integer x = 4123
integer y = 2896
integer width = 101
integer height = 80
boolean bringtotop = true
string picturename = "C:\erpman\image\prior.gif"
boolean focusrectangle = false
end type

event clicked;Long rowcnt , totRow , sRow
int i

totRow =dw_domain2.Rowcount()

FOR i = 1 TO totRow
	sRow = dw_domain2.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
   iv_empno = dw_domain2.getitemstring(sRow, "empno")
   iv_empname = dw_domain2.getitemstring(sRow, "empname")
	iv_enterdate = dw_domain2.getitemstring(sRow, "enterdate")
	iv_jikjonggubn = dw_domain2.getitemstring(sRow, "jikjonggubn")

	rowcnt = dw_domain1.rowcount() + 1
	dw_domain1.insertrow(rowcnt)
   dw_domain1.setitem(rowcnt, "empno", iv_empno)
   dw_domain1.setitem(rowcnt, "empname", iv_empname)
	dw_domain1.setitem(rowcnt, "enterdate", iv_enterdate)
	dw_domain1.setitem(rowcnt, "jikjonggubn", iv_jikjonggubn)
	
	dw_domain2.deleterow(sRow)
NEXT	

IF dw_domain2.RowCount() > 0 THEN
	rb_all.checked = false
   rb_per.checked = true
ELSE
	rb_all.checked = true
   rb_per.checked = false
END IF	
end event

type p_1 from picture within w_pip5021
boolean visible = false
integer x = 4123
integer y = 2808
integer width = 101
integer height = 80
boolean bringtotop = true
string picturename = "C:\erpman\image\next.gif"
boolean focusrectangle = false
end type

event clicked;Long rowcnt , totRow , sRow
int i

totRow =dw_domain1.Rowcount()

FOR i = 1 TO totRow
	sRow = dw_domain1.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
   iv_empno = dw_domain1.getitemstring(sRow, "empno")
   iv_empname = dw_domain1.getitemstring(sRow, "empname")
	iv_enterdate = dw_domain1.getitemstring(sRow, "enterdate")
	iv_jikjonggubn = dw_domain1.getitemstring(sRow, "jikjonggubn")

	rowcnt = dw_domain2.rowcount() + 1
	dw_domain2.insertrow(rowcnt)
   dw_domain2.setitem(rowcnt, "empno", iv_empno)
   dw_domain2.setitem(rowcnt, "empname", iv_empname)
	dw_domain2.setitem(rowcnt, "enterdate", iv_enterdate)
	dw_domain2.setitem(rowcnt, "jikjonggubn", iv_jikjonggubn)
	
	dw_domain1.deleterow(sRow)
NEXT	

IF dw_domain2.RowCount() > 0 THEN
	rb_all.checked = false
   rb_per.checked = true
END IF	
end event

type cb_calcu from commandbutton within w_pip5021
event clicked pbm_bnclicked
boolean visible = false
integer x = 3150
integer y = 2752
integer width = 411
integer height = 100
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "계산(&E)"
end type

type dw_domain2 from u_d_select_sort within w_pip5021
integer x = 1490
integer y = 524
integer width = 891
integer height = 1544
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_pip5021_2"
boolean border = false
end type

event itemchanged;call super::itemchanged;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type st_3 from statictext within w_pip5021
integer x = 2615
integer y = 376
integer width = 462
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "중도정산대상자"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pip5021
integer x = 375
integer y = 376
integer width = 462
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "연말정산대상자"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_pip5021
integer x = 1335
integer y = 820
integer width = 101
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\next.gif"
end type

event clicked;Long rowcnt , totRow , sRow
int i

totRow =dw_domain1.Rowcount()

FOR i = 1 TO totRow
	sRow = dw_domain1.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
   iv_empno = dw_domain1.getitemstring(sRow, "empno")
   iv_empname = dw_domain1.getitemstring(sRow, "empname")
	iv_enterdate = dw_domain1.getitemstring(sRow, "enterdate")
	iv_jikjonggubn = dw_domain1.getitemstring(sRow, "jikjonggubn")

	rowcnt = dw_domain2.rowcount() + 1
	dw_domain2.insertrow(rowcnt)
   dw_domain2.setitem(rowcnt, "empno", iv_empno)
   dw_domain2.setitem(rowcnt, "empname", iv_empname)
	dw_domain2.setitem(rowcnt, "enterdate", iv_enterdate)
	dw_domain2.setitem(rowcnt, "jikjonggubn", iv_jikjonggubn)
	
	dw_domain1.deleterow(sRow)
NEXT	

IF dw_domain2.RowCount() > 0 THEN
	rb_all.checked = false
   rb_per.checked = true
END IF	
end event

type pb_2 from picturebutton within w_pip5021
integer x = 1335
integer y = 944
integer width = 101
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\prior.gif"
end type

event clicked;Long rowcnt , totRow , sRow
int i

totRow =dw_domain2.Rowcount()

FOR i = 1 TO totRow
	sRow = dw_domain2.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
   iv_empno = dw_domain2.getitemstring(sRow, "empno")
   iv_empname = dw_domain2.getitemstring(sRow, "empname")
	iv_enterdate = dw_domain2.getitemstring(sRow, "enterdate")
	iv_jikjonggubn = dw_domain2.getitemstring(sRow, "jikjonggubn")

	rowcnt = dw_domain1.rowcount() + 1
	dw_domain1.insertrow(rowcnt)
   dw_domain1.setitem(rowcnt, "empno", iv_empno)
   dw_domain1.setitem(rowcnt, "empname", iv_empname)
	dw_domain1.setitem(rowcnt, "enterdate", iv_enterdate)
	dw_domain1.setitem(rowcnt, "jikjonggubn", iv_jikjonggubn)
	
	dw_domain2.deleterow(sRow)
NEXT	

IF dw_domain2.RowCount() > 0 THEN
	rb_all.checked = false
   rb_per.checked = true
ELSE
	rb_all.checked = true
   rb_per.checked = false
END IF	
end event

type dw_domain1 from u_d_select_sort within w_pip5021
integer x = 389
integer y = 524
integer width = 891
integer height = 1544
integer taborder = 90
boolean bringtotop = true
string dataobject = "d_pip5021_1"
boolean border = false
end type

event itemchanged;call super::itemchanged;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type rb_3 from radiobutton within w_pip5021
integer x = 3127
integer y = 152
integer width = 379
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "중도정산"
end type

event clicked;	String sSaup, sKunmu

	dw_ip.AcceptText()
	sSaup = trim(dw_ip.GetItemString(1,"saup"))
	sKunmu = trim(dw_ip.GetitemString(1,'kunmu'))
	iv_fromdate = dw_ip.GetitemString(1,'syymm')

	IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
	IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
	
	IF f_datechk(iv_fromdate + '01') = -1 THEN
		MessageBox('확인','작업년월을 확인하세요!!')
	END IF
	
	iv_todate = f_last_date(iv_fromdate)
	iv_fromdate = iv_fromdate + '01'
	dw_ip.SetItem(1, 'sdate', iv_fromdate)
	dw_ip.SetItem(1, 'edate', iv_todate)

	iv_tag = "2"
	dw_domain1.enabled = false
	dw_domain2.enabled = false
	dw_domain3.enabled = true

	dw_ip.object.t_1.visible = true
	dw_ip.object.t_2.visible = true
	dw_ip.object.sdate.visible = true
	dw_ip.object.edate.visible = true
   dw_domain3.reset()
	dw_domain1.reset()
	dw_domain2.reset()
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()

  dw_domain3.retrieve(gs_company, iv_fromdate, iv_todate, sSaup, sKunmu)
end event

type rb_2 from radiobutton within w_pip5021
integer x = 2679
integer y = 152
integer width = 379
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "연말정산"
boolean checked = true
end type

event clicked; string is_year, sSaup, sKunmu
 
	iv_tag = "1"
	dw_domain1.enabled = true
	dw_domain2.enabled = true
	dw_domain3.enabled = false

	dw_ip.object.t_1.visible = false
	dw_ip.object.t_2.visible = false
	dw_ip.object.sdate.visible = false
	dw_ip.object.edate.visible = false

   dw_ip.accepttext()
	
	is_year = left(dw_ip.getitemstring(1, 'syymm'), 4)
	sSaup = trim(dw_ip.GetItemString(1,"saup"))
	sKunmu = trim(dw_ip.GetitemString(1,'kunmu'))
	
	IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
	IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
	
	iv_enddate = is_year + "1231"
	iv_startdate = is_year + "0101"

	dw_domain1.retrieve(gs_company, iv_enddate, sSaup, sKunmu)
	dw_domain2.reset()
	dw_domain3.reset()
	
	dw_ip.Setcolumn('syymm')
	dw_ip.setfocus()
end event

type rb_1 from radiobutton within w_pip5021
integer x = 2624
integer y = 456
integer width = 256
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체"
end type

event clicked; string sSaup, sKunmu
 
 dw_ip.AcceptText()
	sSaup = trim(dw_ip.GetItemString(1,"saup"))
	sKunmu = trim(dw_ip.GetitemString(1,'kunmu'))

	IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
	IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'
 
 IF f_datechk(iv_fromdate) = -1 THEN
      MessageBox("확 인","일자를 확인하세요!!")
      dw_ip.setcolumn('sdate')
		dw_ip.setfocus()
	   Return 1
   END IF		

   IF f_datechk(iv_todate) = -1 THEN
      MessageBox("확 인","일자를 확인하세요!!")
      dw_ip.setcolumn('edate')
		dw_ip.setfocus()
	   Return 1
   END IF		

   if iv_fromdate > iv_todate then
		MessageBox("확 인","대상기간 범위를 확인하세요!!")
      dw_ip.setcolumn('sdate')
		dw_ip.setfocus()
	   Return 1
   END IF		

dw_domain3.retrieve(gs_company, iv_fromdate, iv_todate, sSaup, sKunmu)
 
end event

type rb_all from radiobutton within w_pip5021
integer x = 375
integer y = 456
integer width = 256
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "전체"
boolean checked = true
end type

event clicked;string is_year, sSaup, sKunmu

dw_ip.accepttext()

is_year = left(dw_ip.getitemstring(1, 'syymm'), 4)
sSaup = trim(dw_ip.GetItemString(1,"saup"))
sKunmu = trim(dw_ip.GetitemString(1,'kunmu'))

IF sSaup = '' OR IsNull(sSaup) THEN sSaup = '%'
IF sKunmu = '' OR IsNull(sKunmu) THEN sKunmu = '%'

iv_enddate = is_year + "1231"
iv_startdate = is_year + "0101"

dw_domain1.retrieve(gs_company, iv_enddate, sSaup, sKunmu)
dw_domain2.reset()
rb_per.checked = false



end event

type rb_per from radiobutton within w_pip5021
integer x = 1486
integer y = 456
integer width = 256
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "개인"
end type

event clicked;
rb_all.checked = false


end event

type st_7 from statictext within w_pip5021
integer x = 3022
integer y = 2152
integer width = 325
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "작업시간"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type sle_start from singlelineedit within w_pip5021
integer x = 3360
integer y = 2140
integer width = 270
integer height = 60
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
end type

type sle_end from singlelineedit within w_pip5021
integer x = 3689
integer y = 2140
integer width = 274
integer height = 60
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
end type

type st_8 from statictext within w_pip5021
integer x = 3625
integer y = 2144
integer width = 78
integer height = 52
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "~~"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_compute from uo_picture within w_pip5021
integer x = 4219
integer y = 24
integer width = 178
integer taborder = 50
boolean bringtotop = true
string pointer = "C:\erpman\cur\update.cur"
string picturename = "C:\erpman\image\계산_up.gif"
end type

event clicked;call super::clicked;long i,rowcnt,findrow 
integer wrtcnt,iRtnValue
string snull, sqltext

dw_ip.accepttext()

setnull(snull)

iv_syymm = trim(dw_ip.getitemstring(1, 'syymm'))

IF iv_syymm = "" or isnull(iv_syymm) then 
	messagebox("확 인", "작업년월을  입력하세요!!")
	dw_ip.setfocus()
	return 
END IF	

IF f_datechk(iv_syymm+"01") = -1 THEN
	messagebox('확 인','작업년월을 확인하세요!!')
	dw_ip.SetItem(1,"syymm",snull)
	dw_ip.Setfocus()
END IF

IF messagebox("확 인", "계산작업을 하면 해당 사원의 이전 데이터는 사라집니다.  ~r~r계산작업을 하시겠습니까?",&
                     exclamation!,yesno!,2) = 2 then
	dw_ip.setfocus()
   return 
END IF

setpointer(hourglass!)
sle_msg.text = '계산중.............!!'
sle_start.text = string(now())
//st_percent.visible = false
st_percent.text = "0"    // 퍼센트.....
//st_10.visible = false    // 퍼센트(%) 기호......

if rb_2.checked then              //연말정산
	iv_tag = '1'	
	IF rb_all.Checked = True THEN      // (전체)
		dw_Process = dw_domain1
		il_RowCount = dw_domain1.RowCount()
	ELSEIF rb_per.Checked = true THEN  // (개인)
		dw_Process = dw_domain2
		il_RowCount = dw_domain2.RowCount()
	END IF
else                              //중도정산
	iv_tag = '2'
	dw_Process = dw_domain3
	il_RowCount = dw_domain3.RowCount()
end if

IF il_RowCount <=0 THEN
	MessageBox("확 인","처리 선택한 자료가 없습니다!!")
	Return
END IF

sqltext = wf_proceduresql()


iRtnValue = sqlca.sp_calc_endtaxadjustment(gs_company,iv_syymm,iv_tag,sqltext);

IF iRtnValue <> 1 then
	MessageBox("확 인","정산 계산 실패!!")
	Rollback;
	SetPointer(Arrow!)
	sle_msg.text =''
	Return
END IF
commit;

sle_end.text = string(now())
w_mdi_frame.sle_msg.text = '정산 계산 완료!!'
MessageBox("확 인","정산 계산 완료!!")
SetPointer(Arrow!)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\계산_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\계산_up.gif"
end event

type gb_4 from groupbox within w_pip5021
integer x = 2578
integer y = 72
integer width = 974
integer height = 208
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
string text = "작업조건"
end type

type rr_1 from roundrectangle within w_pip5021
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 320
integer y = 48
integer width = 3291
integer height = 256
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_5 from roundrectangle within w_pip5021
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 320
integer y = 396
integer width = 2149
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pip5021
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 1477
integer y = 516
integer width = 942
integer height = 1564
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_3 from roundrectangle within w_pip5021
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 370
integer y = 516
integer width = 923
integer height = 1564
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_7 from roundrectangle within w_pip5021
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2560
integer y = 396
integer width = 1408
integer height = 1712
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pip5021
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2610
integer y = 516
integer width = 1312
integer height = 1564
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_ip from u_key_enter within w_pip5021
integer x = 366
integer y = 72
integer width = 2144
integer height = 216
integer taborder = 11
string dataobject = "d_pip5021"
boolean border = false
end type

event itemchanged;call super::itemchanged;String  snull

SetNull(snull)

this.AcceptText()

IF this.GetColumnName() = 'saup' THEN
	is_saupcd = this.GetText()
	
	IF is_saupcd = '' OR IsNull(is_saupcd) THEN is_saupcd = '%'
END IF

IF this.GetcolumnName() ="syymm" THEN
	iv_syymm = Trim(this.GetText())
   
	iv_startdate = left(iv_syymm, 4) + '0101'
   iv_enddate = left(iv_syymm, 4) + "1231"
	
	IF iv_syymm ="" OR IsNull(iv_syymm) THEN RETURN
	
	IF f_datechk(iv_syymm +"01") = -1 THEN
		messagebox('확 인','작업년월을 확인하세요!!')
		this.SetItem(1,"syymm",snull)
		this.Setfocus()
		Return 1
   ELSE
		p_inq.TriggerEvent(Clicked!)
   END IF
END IF

IF dwo.Name = "saup" OR dwo.Name ="kunmu" THEN
		p_inq.TriggerEvent(Clicked!)
END IF

IF this.GetcolumnName() ="sdate" THEN
	iv_fromdate = Trim(this.GetText())
END IF

IF this.GetcolumnName() ="edate" THEN
	iv_todate = Trim(this.GetText())
END IF

end event

event itemerror;call super::itemerror;Return 1
end event

type dw_domain3 from u_d_select_sort within w_pip5021
event ue_pressenter pbm_dwnprocessenter
integer x = 2624
integer y = 524
integer width = 1285
integer height = 1544
integer taborder = 11
string dataobject = "d_pip5021_3"
boolean hscrollbar = false
boolean border = false
end type

event type long ue_pressenter();Send(Handle(this), 256, 9, 0)
Return 1
end event

event doubleclicked;call super::doubleclicked;
long current_row

current_row = dw_domain3.getrow()

if current_row  > 0 then
	dw_domain3.deleterow(current_row)
end if

rb_1.checked = false

end event

