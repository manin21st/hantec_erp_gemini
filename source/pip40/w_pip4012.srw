$PBExportHeader$w_pip4012.srw
$PBExportComments$** 소급(급여)계산
forward
global type w_pip4012 from w_inherite_standard
end type
type st_7 from statictext within w_pip4012
end type
type dw_insert_child from datawindow within w_pip4012
end type
type em_rate from editmask within w_pip4012
end type
type p_5 from picture within w_pip4012
end type
type p_4 from picture within w_pip4012
end type
type st_9 from statictext within w_pip4012
end type
type st_8 from statictext within w_pip4012
end type
type st_15 from statictext within w_pip4012
end type
type pbgubn from dropdownlistbox within w_pip4012
end type
type st_12 from statictext within w_pip4012
end type
type st_10 from statictext within w_pip4012
end type
type todate from editmask within w_pip4012
end type
type frdate from editmask within w_pip4012
end type
type rb_2 from radiobutton within w_pip4012
end type
type rb_1 from radiobutton within w_pip4012
end type
type st_6 from statictext within w_pip4012
end type
type uo_progress from u_progress_bar within w_pip4012
end type
type rb_per from radiobutton within w_pip4012
end type
type sle_end from singlelineedit within w_pip4012
end type
type sle_start from singlelineedit within w_pip4012
end type
type st_4 from statictext within w_pip4012
end type
type rb_all from radiobutton within w_pip4012
end type
type st_3 from statictext within w_pip4012
end type
type st_2 from statictext within w_pip4012
end type
type em_date from editmask within w_pip4012
end type
type st_5 from statictext within w_pip4012
end type
type st_11 from statictext within w_pip4012
end type
type pb_2 from picturebutton within w_pip4012
end type
type pb_1 from picturebutton within w_pip4012
end type
type st_21 from statictext within w_pip4012
end type
type st_20 from statictext within w_pip4012
end type
type dw_personal from u_d_select_sort within w_pip4012
end type
type dw_total from u_d_select_sort within w_pip4012
end type
type p_do from uo_picture within w_pip4012
end type
type rr_3 from roundrectangle within w_pip4012
end type
type rr_4 from roundrectangle within w_pip4012
end type
type rr_1 from roundrectangle within w_pip4012
end type
type ln_1 from line within w_pip4012
end type
type ln_2 from line within w_pip4012
end type
type ln_3 from line within w_pip4012
end type
type rr_5 from roundrectangle within w_pip4012
end type
type rr_2 from roundrectangle within w_pip4012
end type
type rr_6 from roundrectangle within w_pip4012
end type
type rr_7 from roundrectangle within w_pip4012
end type
type dw_1 from u_key_enter within w_pip4012
end type
end forward

global type w_pip4012 from w_inherite_standard
string title = "소급분급여계산"
boolean resizable = false
st_7 st_7
dw_insert_child dw_insert_child
em_rate em_rate
p_5 p_5
p_4 p_4
st_9 st_9
st_8 st_8
st_15 st_15
pbgubn pbgubn
st_12 st_12
st_10 st_10
todate todate
frdate frdate
rb_2 rb_2
rb_1 rb_1
st_6 st_6
uo_progress uo_progress
rb_per rb_per
sle_end sle_end
sle_start sle_start
st_4 st_4
rb_all rb_all
st_3 st_3
st_2 st_2
em_date em_date
st_5 st_5
st_11 st_11
pb_2 pb_2
pb_1 pb_1
st_21 st_21
st_20 st_20
dw_personal dw_personal
dw_total dw_total
p_do p_do
rr_3 rr_3
rr_4 rr_4
rr_1 rr_1
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
rr_5 rr_5
rr_2 rr_2
rr_6 rr_6
rr_7 rr_7
dw_1 dw_1
end type
global w_pip4012 w_pip4012

type variables
DataWindow dw_Process

Integer           il_RowCount,iAry_EditChild =0
String             Is_PbTag = 'P' ,lcalc_gubun
Double          Id_NoTax_Sub = 0                     //비과세공제


end variables

forward prototypes
public function string wf_proceduresql (string gubun)
public subroutine wf_sqlsyntax (string sym, string scalc_gubun)
end prototypes

public function string wf_proceduresql (string gubun);
Int    k 
String sGetSqlSyntax,sEmpNo
Long   lSyntaxLength


IF gubun = '1' THEN
	sGetSqlSyntax = ' select empno,deptcode,enterdate,retiredate,levelcode,salary,jikjonggubn from p1_master ' 
ELSEIF gubun = '2' THEN
	sGetSqlSyntax = ' select empno from p1_master ' 
ELSEIF gubun = '3' THEN
	sGetSqlSyntax = ' select empno,enterdate,retiredate,ssfdate,sstdate,jikjonggubn from p1_master '  	
ELSEIF gubun = '4' THEN
	sGetSqlSyntax = 'select empno,jikjonggubn,enterdate,retiredate,jhgubn,paygubn,consmatgubn,kmgubn,engineergubn from p1_master'
END IF

dw_Process.AcceptText()

sGetSqlSyntax = sGetSqlSyntax + ' WHERE ('

FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_Process.GetItemString(k,"empno")
	
	sGetSqlSyntax = sGetSqlSyntax + ' (p1_master.empno =' + "'"+ sEmpNo +"')"+ ' OR'
	
NEXT

lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax    = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)

sGetSqlSyntax = sGetSqlSyntax + ")"

Return sGetSqlSynTax


//
//String  sSqlSyntax,sEmpNo,sSpace
//Integer k,lSyntaxLength
//
//sSpace = ' '
//
//IF gubun = '1' THEN
//	sSqlSyntax = ' select empno,deptcode,enterdate,retiredate,levelcode,salary,jikjonggubn from p1_master ' 
//ELSEIF gubun = '2' THEN
//	sSqlSyntax = ' select empno from p1_master ' 
//ELSEIF gubun = '3' THEN
//	sSqlSyntax = ' select empno,enterdate,retiredate,ssfdate,sstdate,jikjonggubn from p1_master '  	
//	
//END IF
//
////sSqlSyntax = sSqlSyntax + ' ("P1_MASTER"."RETIREDATE" = '+ "'"+sSpace +"'"+" ) OR "
////sSqlSyntax = sSqlSyntax + ' (SUBSTR("P1_MASTER"."RETIREDATE",1,6) >= '+ "'"+sprocyearmonth +"'"+" )) AND "
////
//sSqlSyntax = sSqlSyntax + 'where '
//
//FOR k = 1 TO il_rowcount
//	
//	sEmpNo = dw_Process.GetItemString(k,"empno")
//	
//	sSqlSyntax = sSqlSyntax + ' empno =' + "'"+ sEmpNo +"' "+' or'
//	
//NEXT
//
//lSyntaxLength = len(sSqlSyntax)
//sSqlSyntax    = Mid(sSqlSyntax,1,lSyntaxLength - 2)
//
////sSqlSyntax = sSqlSyntax 
//
////sSqlSyntax = sSqlSyntax + ' AND ("P1_MASTER"."COMPANYCODE" = ' + "'" + gs_company +"'"+") "
////sSqlSyntax = sSqlSyntax + ' AND ( SUBSTR("P1_MASTER"."ENTERDATE",1,6) <= ' + "'"+sprocyearmonth +"'"+" )"  
//
//IF rb_7.Checked = True THEN
//	String sJikGbn = '2'
//	
////	sSqlSyntax = sSqlSyntax + ' AND ("P1_MASTER"."JIKJONGGUBN" <> ' + "'"+sJikGbn +"'"+")"
////	+' ORDER BY "P1_MASTER"."RETIREDATE" DSC'  
//END IF
//
//Return sSqlSyntax
//
//
//
end function

public subroutine wf_sqlsyntax (string sym, string scalc_gubun);
Int    k 
String sGetSqlSyntax,sEmpNo,sProcPos
Long   lSyntaxLength

dw_insert.DataObject ='d_pip4009_3'
dw_insert.SetTransObject(SQLCA)
dw_insert.Reset()
	
sGetSqlSyntax = dw_insert.GetSqlSelect()

sGetSqlSyntax = sGetSqlSyntax + "WHERE ("
	
dw_Process.AcceptText()
	
FOR k = 1 TO il_rowcount
	
	sEmpNo = dw_Process.GetItemString(k,"empno")
	
	sGetSqlSyntax = sGetSqlSyntax + ' ("P8_EEDITDATA"."EMPNO" =' + "'"+ sEmpNo +"'"+ ') OR'
		
NEXT
	
lSyntaxLength = len(sGetSqlSyntax)
sGetSqlSyntax = Mid(sGetSqlSyntax,1,lSyntaxLength - 2)
	
sGetSqlSyntax = sGetSqlSyntax + ")"
	
sGetSqlSyntax = sGetSqlSyntax + ' AND ("P8_EEDITDATA"."COMPANYCODE" = ' + "'" + gs_company +"'"+")"
sGetSqlSyntax = sGetSqlSyntax + ' AND ("P8_EEDITDATA"."WORKYM" = ' + "'" + sYm +"'"+")"
sGetSqlSyntax = sGetSqlSyntax + ' AND ("P8_EEDITDATA"."PBTAG" = ' + "'" + Is_PbTag +"'"+")"
sGetSqlSyntax = sGetSqlSyntax + ' AND ("P8_EEDITDATA"."CALC_GUBUN" = ' + "'" + scalc_gubun +"'"+")"

dw_insert.SetSQLSelect(sGetSqlSyntax)	

end subroutine

event open;call super::open;
dw_datetime.SetTransObject(SQLCA)
dw_datetime.Reset()
dw_datetime.InsertRow(0)
dw_1.Settransobject(sqlca)
dw_1.insertrow(0)
dw_total.settransobject(SQLCA)
dw_personal.settransobject(SQLCA)


dw_insert.settransobject(SQLCA)
dw_insert_child.settransobject(SQLCA)

uo_progress.Hide()

em_date.text    = String(Left(gs_today,6),"@@@@.@@")
em_rate.text = '100'

em_date.TriggerEvent(Modified!)

em_date.Setfocus()

pbgubn.text = '급여'


end event

on w_pip4012.create
int iCurrent
call super::create
this.st_7=create st_7
this.dw_insert_child=create dw_insert_child
this.em_rate=create em_rate
this.p_5=create p_5
this.p_4=create p_4
this.st_9=create st_9
this.st_8=create st_8
this.st_15=create st_15
this.pbgubn=create pbgubn
this.st_12=create st_12
this.st_10=create st_10
this.todate=create todate
this.frdate=create frdate
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_6=create st_6
this.uo_progress=create uo_progress
this.rb_per=create rb_per
this.sle_end=create sle_end
this.sle_start=create sle_start
this.st_4=create st_4
this.rb_all=create rb_all
this.st_3=create st_3
this.st_2=create st_2
this.em_date=create em_date
this.st_5=create st_5
this.st_11=create st_11
this.pb_2=create pb_2
this.pb_1=create pb_1
this.st_21=create st_21
this.st_20=create st_20
this.dw_personal=create dw_personal
this.dw_total=create dw_total
this.p_do=create p_do
this.rr_3=create rr_3
this.rr_4=create rr_4
this.rr_1=create rr_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.rr_5=create rr_5
this.rr_2=create rr_2
this.rr_6=create rr_6
this.rr_7=create rr_7
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_7
this.Control[iCurrent+2]=this.dw_insert_child
this.Control[iCurrent+3]=this.em_rate
this.Control[iCurrent+4]=this.p_5
this.Control[iCurrent+5]=this.p_4
this.Control[iCurrent+6]=this.st_9
this.Control[iCurrent+7]=this.st_8
this.Control[iCurrent+8]=this.st_15
this.Control[iCurrent+9]=this.pbgubn
this.Control[iCurrent+10]=this.st_12
this.Control[iCurrent+11]=this.st_10
this.Control[iCurrent+12]=this.todate
this.Control[iCurrent+13]=this.frdate
this.Control[iCurrent+14]=this.rb_2
this.Control[iCurrent+15]=this.rb_1
this.Control[iCurrent+16]=this.st_6
this.Control[iCurrent+17]=this.uo_progress
this.Control[iCurrent+18]=this.rb_per
this.Control[iCurrent+19]=this.sle_end
this.Control[iCurrent+20]=this.sle_start
this.Control[iCurrent+21]=this.st_4
this.Control[iCurrent+22]=this.rb_all
this.Control[iCurrent+23]=this.st_3
this.Control[iCurrent+24]=this.st_2
this.Control[iCurrent+25]=this.em_date
this.Control[iCurrent+26]=this.st_5
this.Control[iCurrent+27]=this.st_11
this.Control[iCurrent+28]=this.pb_2
this.Control[iCurrent+29]=this.pb_1
this.Control[iCurrent+30]=this.st_21
this.Control[iCurrent+31]=this.st_20
this.Control[iCurrent+32]=this.dw_personal
this.Control[iCurrent+33]=this.dw_total
this.Control[iCurrent+34]=this.p_do
this.Control[iCurrent+35]=this.rr_3
this.Control[iCurrent+36]=this.rr_4
this.Control[iCurrent+37]=this.rr_1
this.Control[iCurrent+38]=this.ln_1
this.Control[iCurrent+39]=this.ln_2
this.Control[iCurrent+40]=this.ln_3
this.Control[iCurrent+41]=this.rr_5
this.Control[iCurrent+42]=this.rr_2
this.Control[iCurrent+43]=this.rr_6
this.Control[iCurrent+44]=this.rr_7
this.Control[iCurrent+45]=this.dw_1
end on

on w_pip4012.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_7)
destroy(this.dw_insert_child)
destroy(this.em_rate)
destroy(this.p_5)
destroy(this.p_4)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_15)
destroy(this.pbgubn)
destroy(this.st_12)
destroy(this.st_10)
destroy(this.todate)
destroy(this.frdate)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_6)
destroy(this.uo_progress)
destroy(this.rb_per)
destroy(this.sle_end)
destroy(this.sle_start)
destroy(this.st_4)
destroy(this.rb_all)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_date)
destroy(this.st_5)
destroy(this.st_11)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.st_21)
destroy(this.st_20)
destroy(this.dw_personal)
destroy(this.dw_total)
destroy(this.p_do)
destroy(this.rr_3)
destroy(this.rr_4)
destroy(this.rr_1)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.rr_5)
destroy(this.rr_2)
destroy(this.rr_6)
destroy(this.rr_7)
destroy(this.dw_1)
end on

type p_mod from w_inherite_standard`p_mod within w_pip4012
boolean visible = false
integer x = 2075
integer y = 2384
end type

type p_del from w_inherite_standard`p_del within w_pip4012
boolean visible = false
integer x = 2249
integer y = 2384
end type

type p_inq from w_inherite_standard`p_inq within w_pip4012
integer x = 3863
end type

event p_inq::clicked;call super::clicked;String sStartDate,sEndDate,sgbn, slevel

dw_total.Reset()
dw_personal.Reset()


sStartDate = Left(em_date.text,4)+Right(em_date.text,2) + "01"
sEndDate   = f_Last_Date(Left(em_date.text,4)+Right(em_date.text,2))
if dw_1.Accepttext() = -1 then return
sgbn = dw_1.getitemstring(1,'jikjonggubn')
slevel = dw_1.getitemstring(1,'levelcode')

if IsNull(sgbn) or sgbn = '' then sgbn = '%'
if IsNull(slevel) or slevel = '' then slevel = '%'

IF dw_total.Retrieve(Gs_Company,sStartDate,sEndDate,sgbn,slevel) <=0 THEN
	MessageBox("확 인","처리할 자료가 없습니다!!",StopSign!)
	em_date.SetFocus()
	Return
END IF


end event

type p_print from w_inherite_standard`p_print within w_pip4012
boolean visible = false
integer x = 1381
integer y = 2384
end type

type p_can from w_inherite_standard`p_can within w_pip4012
end type

type p_exit from w_inherite_standard`p_exit within w_pip4012
end type

type p_ins from w_inherite_standard`p_ins within w_pip4012
boolean visible = false
integer x = 1554
integer y = 2384
end type

type p_search from w_inherite_standard`p_search within w_pip4012
boolean visible = false
integer x = 1202
integer y = 2384
end type

type p_addrow from w_inherite_standard`p_addrow within w_pip4012
boolean visible = false
integer x = 1728
integer y = 2384
end type

type p_delrow from w_inherite_standard`p_delrow within w_pip4012
boolean visible = false
integer x = 1902
integer y = 2384
end type

type dw_insert from w_inherite_standard`dw_insert within w_pip4012
boolean visible = false
integer x = 110
integer y = 2752
integer width = 864
integer height = 100
boolean titlebar = true
string title = "급여계산자료 저장"
string dataobject = "d_pip4009_3"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

event dw_insert::dberror;call super::dberror;IF sqldbcode = 1438 THEN
	MessageBox("에러","계산한 값이 TABLE의 길이보다 큽니다.~n"+&
							"["+this.GetItemString(row,"empno")+"] 의 인사 마스타 자료를 확인하십시요!!")
	Return 1
END IF
end event

type st_window from w_inherite_standard`st_window within w_pip4012
boolean visible = false
end type

type cb_exit from w_inherite_standard`cb_exit within w_pip4012
boolean visible = false
end type

type cb_update from w_inherite_standard`cb_update within w_pip4012
boolean visible = false
end type

type cb_insert from w_inherite_standard`cb_insert within w_pip4012
boolean visible = false
end type

type cb_delete from w_inherite_standard`cb_delete within w_pip4012
boolean visible = false
end type

type cb_retrieve from w_inherite_standard`cb_retrieve within w_pip4012
boolean visible = false
end type

type st_1 from w_inherite_standard`st_1 within w_pip4012
boolean visible = false
end type

type cb_cancel from w_inherite_standard`cb_cancel within w_pip4012
boolean visible = false
end type

type dw_datetime from w_inherite_standard`dw_datetime within w_pip4012
boolean visible = false
end type

type sle_msg from w_inherite_standard`sle_msg within w_pip4012
boolean visible = false
end type

type gb_2 from w_inherite_standard`gb_2 within w_pip4012
boolean visible = false
end type

type gb_1 from w_inherite_standard`gb_1 within w_pip4012
boolean visible = false
end type

type gb_10 from w_inherite_standard`gb_10 within w_pip4012
boolean visible = false
end type

type st_7 from statictext within w_pip4012
boolean visible = false
integer x = 2167
integer y = 2828
integer width = 443
integer height = 104
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 12632256
boolean enabled = false
string text = "수습사원지급율"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_insert_child from datawindow within w_pip4012
boolean visible = false
integer x = 1024
integer y = 2748
integer width = 1088
integer height = 100
integer taborder = 70
boolean bringtotop = true
boolean titlebar = true
string title = "급여계산 자료(수당항목) 저장"
string dataobject = "d_pip4009_4"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
end type

event dberror;
IF sqldbcode = 1438 THEN
	MessageBox("에러","계산한 값이 TABLE의 길이보다 큽니다.~n"+&
							"["+this.GetItemString(row,"empno")+"] 의 인사 마스타 자료를 확인하십시요!!")
	Return 1
END IF
end event

type em_rate from editmask within w_pip4012
boolean visible = false
integer x = 2615
integer y = 2828
integer width = 311
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "###"
boolean spin = true
string minmax = "10~~100"
end type

type p_5 from picture within w_pip4012
boolean visible = false
integer x = 3767
integer y = 2560
integer width = 101
integer height = 80
boolean bringtotop = true
string picturename = "C:\erpman\image\next.gif"
boolean focusrectangle = false
end type

event clicked;String sEmpNo,sEmpName,sLevel, sSalary,sEnterDate,sGrade,sProjectDept,sDeptCode,&
       sJhGbn,sConsGbn,sPayGbn,sJhtGbn,sJikGbn,sRetireDate
Long   totRow , sRow,rowcnt
int i

totrow =dw_total.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_total.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo       = dw_total.GetItemString(sRow, "empno")
   sEmpName     = dw_total.GetItemString(sRow, "empname")
	sEnterDate   = dw_total.GetItemString(sRow, "enterdate")
	sRetireDate  = dw_total.GetItemString(sRow, "retiredate")
//	sLevel       = dw_total.GetItemString(sRow, "levelcode")
//	sSalary      = dw_total.GetItemString(sRow, "salary")
	sProjectDept = dw_total.GetItemString(sRow, "projectcode")
//	sDeptCode    = dw_total.GetItemString(sRow, "deptcode")
	sConsGbn     = dw_total.GetItemString(sRow, "consmatgubn")
	sJhtGbn      = dw_total.GetItemString(sRow, "jhtgubn")
	sJhGbn       = dw_total.GetItemString(sRow, "jhgubn")
	sPayGbn      = dw_total.GetItemString(sRow, "paygubn")
	sJikGbn      = dw_total.GetItemString(sRow, "jikjonggubn")
	
	rowcnt = dw_personal.RowCount() + 1
	
	dw_personal.insertrow(rowcnt)
	dw_personal.setitem(rowcnt, "empname",     sEmpName)
	dw_personal.setitem(rowcnt, "empno",       sEmpNo)
	dw_personal.setitem(rowcnt, "enterdate",   sEnterDate)
	dw_personal.setitem(rowcnt, "retiredate",  sRetireDate)
//	dw_personal.setitem(rowcnt, "levelcode",   sLevel)
//	dw_personal.setitem(rowcnt, "salary",      sSalary)
	dw_personal.setitem(rowcnt, "projectcode", sProjectDept)
//	dw_personal.setitem(rowcnt, "deptcode",    sDeptCode)
	dw_personal.setitem(rowcnt, "consmatgubn", sConsGbn)
	dw_personal.setitem(rowcnt, "jhtgubn",     sJhtGbn)
	dw_personal.setitem(rowcnt, "jhgubn",      sJhGbn)
	dw_personal.setitem(rowcnt, "paygubn",     sPayGbn)
	dw_personal.setitem(rowcnt, "jikjonggubn", sJikGbn)
	
	dw_total.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_per.Checked = True
ELSE
	rb_all.Checked = True
END IF	
end event

type p_4 from picture within w_pip4012
boolean visible = false
integer x = 3767
integer y = 2668
integer width = 101
integer height = 80
boolean bringtotop = true
string picturename = "C:\erpman\image\prior.gif"
boolean focusrectangle = false
end type

event clicked;String sEmpNo,sEmpName,sLevel, sSalary,sEnterDate,sGrade,sProjectDept,sDeptCode,&
		 sJhGbn,sConsGbn,sPayGbn,sJhtGbn,sJikGbn,sRetireDate
Long   totRow , sRow,rowcnt
int i

totrow =dw_personal.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_personal.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo       = dw_personal.GetItemString(sRow, "empno")
   sEmpName     = dw_personal.GetItemString(sRow, "empname")
	sEnterDate   = dw_personal.GetItemString(sRow, "enterdate")
	sRetireDate  = dw_personal.GetItemString(sRow, "retiredate")
//	sLevel       = dw_personal.GetItemString(sRow, "levelcode")
//	sSalary      = dw_personal.GetItemString(sRow, "salary")
	sProjectDept = dw_personal.GetItemString(sRow, "projectcode")
//	sDeptCode    = dw_personal.GetItemString(sRow, "deptcode")
	sConsGbn     = dw_personal.GetItemString(sRow, "consmatgubn")
	sJhtGbn      = dw_personal.GetItemString(sRow, "jhtgubn")
	sJhGbn       = dw_personal.GetItemString(sRow, "jhgubn")
	sPayGbn      = dw_personal.GetItemString(sRow, "paygubn")
	sJikGbn      = dw_personal.GetItemString(sRow, "jikjonggubn")
	
	rowcnt = dw_total.RowCount() + 1
	
	dw_total.insertrow(rowcnt)
	dw_total.setitem(rowcnt, "empname",     sEmpName)
	dw_total.setitem(rowcnt, "empno",       sEmpNo)
	dw_total.setitem(rowcnt, "enterdate",   sEnterDate)
	dw_total.setitem(rowcnt, "retiredate",  sRetireDate)
//	dw_total.setitem(rowcnt, "levelcode",   sLevel)
//	dw_total.setitem(rowcnt, "salary",      sSalary)
	dw_total.setitem(rowcnt, "projectcode", sProjectDept)
//	dw_total.setitem(rowcnt, "deptcode",    sDeptCode)
	dw_total.setitem(rowcnt, "consmatgubn", sConsGbn)
	dw_total.setitem(rowcnt, "jhtgubn",     sJhtGbn)
	dw_total.setitem(rowcnt, "jhgubn",      sJhGbn)
	dw_total.setitem(rowcnt, "paygubn",     sPayGbn)
	dw_total.setitem(rowcnt, "jikjonggubn", sJikGbn)
	
	dw_personal.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_per.Checked = True
ELSE
	rb_all.Checked = True
END IF	
end event

type st_9 from statictext within w_pip4012
integer x = 567
integer y = 1060
integer width = 238
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
string text = "처리조건"
boolean focusrectangle = false
end type

type st_8 from statictext within w_pip4012
integer x = 567
integer y = 488
integer width = 613
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
string text = "적용연월 및 대상설정"
boolean focusrectangle = false
end type

type st_15 from statictext within w_pip4012
integer x = 608
integer y = 624
integer width = 315
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "급여구분"
alignment alignment = center!
boolean focusrectangle = false
end type

type pbgubn from dropdownlistbox within w_pip4012
integer x = 1024
integer y = 604
integer width = 480
integer height = 288
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
boolean border = false
string item[] = {"급여","상여"}
end type

type st_12 from statictext within w_pip4012
integer x = 1285
integer y = 748
integer width = 50
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "-"
boolean focusrectangle = false
end type

type st_10 from statictext within w_pip4012
integer x = 617
integer y = 740
integer width = 411
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "소급적용년월"
alignment alignment = center!
boolean focusrectangle = false
end type

type todate from editmask within w_pip4012
integer x = 1330
integer y = 736
integer width = 238
integer height = 60
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
end type

type frdate from editmask within w_pip4012
integer x = 1033
integer y = 736
integer width = 233
integer height = 60
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
end type

type rb_2 from radiobutton within w_pip4012
integer x = 1417
integer y = 1164
integer width = 224
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "기타"
end type

event clicked;//
rb_1.checked = false
//
//
end event

type rb_1 from radiobutton within w_pip4012
integer x = 1193
integer y = 1164
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
string text = "소급"
boolean checked = true
end type

event clicked;//

rb_2.checked = false
end event

type st_6 from statictext within w_pip4012
integer x = 855
integer y = 1164
integer width = 334
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "자료구분"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_progress from u_progress_bar within w_pip4012
integer x = 581
integer y = 1408
integer width = 1083
integer height = 72
integer taborder = 80
boolean bringtotop = true
end type

on uo_progress.destroy
call u_progress_bar::destroy
end on

type rb_per from radiobutton within w_pip4012
integer x = 1312
integer y = 852
integer width = 224
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "개인"
end type

event clicked;//
//rb_all.checked = false
//
//
end event

type sle_end from singlelineedit within w_pip4012
integer x = 1234
integer y = 1692
integer width = 407
integer height = 80
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
boolean displayonly = true
end type

type sle_start from singlelineedit within w_pip4012
integer x = 1234
integer y = 1588
integer width = 407
integer height = 80
integer taborder = 90
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
boolean displayonly = true
end type

type st_4 from statictext within w_pip4012
integer x = 905
integer y = 1600
integer width = 306
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "시작시간"
boolean focusrectangle = false
end type

type rb_all from radiobutton within w_pip4012
integer x = 1015
integer y = 852
integer width = 256
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "전체"
boolean checked = true
end type

event clicked;//
////String ldt_workdate
////
////ldt_workdate = Left(em_date.text,4) + Right(em_date.text,2)+ '31'
////
//mm = integer(mid(em_date.text,6,2))
//
//startdate = Left(em_date.text,4)+Right(em_date.text,2) + "01"
//enddate = Left(em_date.text,4)+Right(em_date.text,2)  + STRING(idd_dd[mm])
//
//st_info.Visible = True
//
//dw_1.retrieve(gs_company,startdate,enddate)
//dw_2.Reset()
//dw_err.Reset()
//
//rb_per.checked = false
end event

type st_3 from statictext within w_pip4012
integer x = 599
integer y = 856
integer width = 334
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "작업대상"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pip4012
integer x = 1038
integer y = 116
integer width = 165
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "현재"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_date from editmask within w_pip4012
event ue_keydown pbm_keydown
integer x = 786
integer y = 120
integer width = 247
integer height = 60
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy.mm"
end type

event ue_keydown;if KeyDown(KeyEnter!) then
   Send( Handle(this), 256, 9, 0 )
   Return 1
end if
end event

event modified;
cb_retrieve.TriggerEvent(Clicked!)
end event

type st_5 from statictext within w_pip4012
integer x = 448
integer y = 120
integer width = 334
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "작업년월"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_11 from statictext within w_pip4012
integer x = 905
integer y = 1704
integer width = 306
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "완료시간"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pip4012
integer x = 3168
integer y = 940
integer width = 101
integer height = 88
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\prior.gif"
end type

event clicked;String sEmpNo,sEmpName,sLevel, sSalary,sEnterDate,sGrade,sProjectDept,sDeptCode,&
		 sJhGbn,sConsGbn,sPayGbn,sJhtGbn,sJikGbn,sRetireDate
Long   totRow , sRow,rowcnt
int i

totrow =dw_personal.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_personal.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo       = dw_personal.GetItemString(sRow, "empno")
   sEmpName     = dw_personal.GetItemString(sRow, "empname")
	sEnterDate   = dw_personal.GetItemString(sRow, "enterdate")
	sRetireDate  = dw_personal.GetItemString(sRow, "retiredate")
//	sLevel       = dw_personal.GetItemString(sRow, "levelcode")
//	sSalary      = dw_personal.GetItemString(sRow, "salary")
	sProjectDept = dw_personal.GetItemString(sRow, "projectcode")
//	sDeptCode    = dw_personal.GetItemString(sRow, "deptcode")
	sConsGbn     = dw_personal.GetItemString(sRow, "consmatgubn")
	sJhtGbn      = dw_personal.GetItemString(sRow, "jhtgubn")
	sJhGbn       = dw_personal.GetItemString(sRow, "jhgubn")
	sPayGbn      = dw_personal.GetItemString(sRow, "paygubn")
	sJikGbn      = dw_personal.GetItemString(sRow, "jikjonggubn")
	
	rowcnt = dw_total.RowCount() + 1
	
	dw_total.insertrow(rowcnt)
	dw_total.setitem(rowcnt, "empname",     sEmpName)
	dw_total.setitem(rowcnt, "empno",       sEmpNo)
	dw_total.setitem(rowcnt, "enterdate",   sEnterDate)
	dw_total.setitem(rowcnt, "retiredate",  sRetireDate)
//	dw_total.setitem(rowcnt, "levelcode",   sLevel)
//	dw_total.setitem(rowcnt, "salary",      sSalary)
	dw_total.setitem(rowcnt, "projectcode", sProjectDept)
//	dw_total.setitem(rowcnt, "deptcode",    sDeptCode)
	dw_total.setitem(rowcnt, "consmatgubn", sConsGbn)
	dw_total.setitem(rowcnt, "jhtgubn",     sJhtGbn)
	dw_total.setitem(rowcnt, "jhgubn",      sJhGbn)
	dw_total.setitem(rowcnt, "paygubn",     sPayGbn)
	dw_total.setitem(rowcnt, "jikjonggubn", sJikGbn)
	
	dw_personal.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_per.Checked = True
ELSE
	rb_all.Checked = True
END IF	
end event

type pb_1 from picturebutton within w_pip4012
integer x = 3168
integer y = 840
integer width = 101
integer height = 88
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "C:\erpman\Image\next.gif"
end type

event clicked;String sEmpNo,sEmpName,sLevel, sSalary,sEnterDate,sGrade,sProjectDept,sDeptCode,&
       sJhGbn,sConsGbn,sPayGbn,sJhtGbn,sJikGbn,sRetireDate
Long   totRow , sRow,rowcnt
int i

totrow =dw_total.Rowcount()

FOR i = 1 TO totrow 
	sRow = dw_total.getselectedrow(0)
	
	IF sRow <=0 THEN EXIT
	
	sEmpNo       = dw_total.GetItemString(sRow, "empno")
   sEmpName     = dw_total.GetItemString(sRow, "empname")
	sEnterDate   = dw_total.GetItemString(sRow, "enterdate")
	sRetireDate  = dw_total.GetItemString(sRow, "retiredate")
//	sLevel       = dw_total.GetItemString(sRow, "levelcode")
//	sSalary      = dw_total.GetItemString(sRow, "salary")
	sProjectDept = dw_total.GetItemString(sRow, "projectcode")
//	sDeptCode    = dw_total.GetItemString(sRow, "deptcode")
	sConsGbn     = dw_total.GetItemString(sRow, "consmatgubn")
	sJhtGbn      = dw_total.GetItemString(sRow, "jhtgubn")
	sJhGbn       = dw_total.GetItemString(sRow, "jhgubn")
	sPayGbn      = dw_total.GetItemString(sRow, "paygubn")
	sJikGbn      = dw_total.GetItemString(sRow, "jikjonggubn")
	
	rowcnt = dw_personal.RowCount() + 1
	
	dw_personal.insertrow(rowcnt)
	dw_personal.setitem(rowcnt, "empname",     sEmpName)
	dw_personal.setitem(rowcnt, "empno",       sEmpNo)
	dw_personal.setitem(rowcnt, "enterdate",   sEnterDate)
	dw_personal.setitem(rowcnt, "retiredate",  sRetireDate)
//	dw_personal.setitem(rowcnt, "levelcode",   sLevel)
//	dw_personal.setitem(rowcnt, "salary",      sSalary)
	dw_personal.setitem(rowcnt, "projectcode", sProjectDept)
//	dw_personal.setitem(rowcnt, "deptcode",    sDeptCode)
	dw_personal.setitem(rowcnt, "consmatgubn", sConsGbn)
	dw_personal.setitem(rowcnt, "jhtgubn",     sJhtGbn)
	dw_personal.setitem(rowcnt, "jhgubn",      sJhGbn)
	dw_personal.setitem(rowcnt, "paygubn",     sPayGbn)
	dw_personal.setitem(rowcnt, "jikjonggubn", sJikGbn)
	
	dw_total.deleterow(sRow)
NEXT	

IF dw_personal.RowCount() > 0 THEN
	rb_per.Checked = True
ELSE
	rb_all.Checked = True
END IF	
end event

type st_21 from statictext within w_pip4012
integer x = 3346
integer y = 480
integer width = 142
integer height = 48
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "개인"
boolean focusrectangle = false
end type

type st_20 from statictext within w_pip4012
integer x = 2286
integer y = 480
integer width = 137
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "전체"
boolean focusrectangle = false
end type

type dw_personal from u_d_select_sort within w_pip4012
integer x = 3319
integer y = 532
integer width = 878
integer height = 1452
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_pip4012_1"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type dw_total from u_d_select_sort within w_pip4012
integer x = 2249
integer y = 532
integer width = 878
integer height = 1452
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pip4012_1"
boolean border = false
end type

event clicked;If Row <= 0 then
	b_flag =True
ELSE
	b_flag = False
END IF

CALL SUPER ::CLICKED
end event

type p_do from uo_picture within w_pip4012
integer x = 4037
integer y = 24
integer width = 178
boolean bringtotop = true
string pointer = ""
string picturename = "C:\erpman\image\처리_up.gif"
end type

event clicked;call super::clicked;string  sYearMonth,sYearMonthDay,sMasterSql,allgubn, sdate, tdate
Integer iPayRate,il_RetrieveRow,il_meterPosition,il_currow,il_SearchRow,il_BefCount =0,k,iRtnValue
int rtn, i, scnt
long samt

/*인사 마스타 자료*/
String  Master_EmpNo,   Master_EmpName

/*급여 계산 flag*/
String  Except_sUseGbn

sYearMonth    = Left(em_date.text,4)+Right(em_date.text,2) 
sdate = Left(frdate.text,4)+Right(frdate.text,2) 
tdate = Left(todate.text,4)+Right(todate.text,2) 

i = long(Right(todate.text,2)) - long(Right(frdate.text,2)) + 1

iPayRate   = Integer(Trim(em_rate.text))
IF iPayRate = 0 OR IsNull(iPayRate) THEN iPayRate = 0

IF rb_all.Checked = True THEN
	dw_Process = dw_Total
	il_RowCount = dw_Total.RowCount()
	allgubn = 'A'	
ELSE
	dw_Process = dw_personal
	il_RowCount = dw_personal.RowCount()
	allgubn = 'P'	
END IF

IF il_RowCount <=0 THEN
	MessageBox("확 인","처리 선택한 자료가 없습니다!!")
	Return
END IF

if pbgubn.text = '급여' then
   is_pbtag = 'P'
else
	is_pbtag = 'B'
end if

IF rb_1.checked = TRUE THEN
	lcalc_gubun = '1'
ELSE
	lcalc_gubun = '2'
END IF	
/* 처리년월의 급여자료가 있는지 확인*/
SELECT Count("WORKYM")
	INTO :il_BefCount
   FROM "P8_EEDITDATA"
   WHERE ("COMPANYCODE" = :gs_company) and  "WORKYM" = :sYearMonth AND "PBTAG" = :Is_PbTag AND
			"CALC_GUBN" = :lcalc_gubun ;
IF SQLCA.SQLCODE = 0 AND il_BefCount <> 0 AND Not IsNull(il_BefCount) THEN
	IF Messagebox ("작업 확인", "이전 소급급여 계산 자료가 존재합니다. 다시 작업하시겠습니까?",&
																Question!,YesNo!) = 2 THEN Return
END IF

w_mdi_frame.sle_msg.text = '소급 급여 계산 중......'
SetPointer(HourGlass!)

sle_start.text = String(Now(),'hh:mm:ss AM/PM')




if i > 0 then
DECLARE start_sp_create_fixdata procedure for sp_create_fixdata(:sYearMonth,'%',&
					'%','%','%',:sMasterSql, :gs_company) ;


	w_mdi_frame.sle_msg.text = '급여 고정자료 생성 중......'
	sMasterSql = wf_ProcedureSql('1')											/*처리대상 인원 sql*/
	SetPointer(HourGlass!)
	execute start_sp_create_fixdata ;
	
	w_mdi_frame.sle_msg.text ='급여 고정자료 생성 완료......!!'
	
end if                                              					     /*예외자료 생성*/
	


sMasterSql = wf_ProcedureSql('4')
scnt = 1
if is_pbtag = 'P' then
for scnt = 1 to i
	


iRtnValue = SQLCA.SP_CALCULATION_PAYAMOUNT_SOKUB(sdate,sYearMonth,is_pbtag,iPayRate,sMasterSql,gs_company,lcalc_gubun);

sdate = left(sdate,4)+string(long(right(sdate,2)) + 1,'00')


IF iRtnValue <> 1 then
	MessageBox("확 인","소급 급여 계산 실패!!")
	Rollback;
	SetPointer(Arrow!)
	sle_msg.text =''
	Return
END IF
commit;

Next

w_mdi_frame.sle_msg.text = '소급 급여 계산 완료!!'
SetPointer(Arrow!)
else
	for scnt = 1 to i
	
//	iRtnValue = SQLCA.SP_CALCULATION_BONUS_SOKUB(sdate,sYearMonth,is_pbtag,iPayRate,sMasterSql,gs_company,lcalc_gubun);
	sdate = left(sdate,4)+string(long(right(sdate,2)) + 1,'00')
	
	IF iRtnValue <> 1 then
		MessageBox("확 인","소급 상여 계산 실패!!")
		Rollback;
		SetPointer(Arrow!)
		sle_msg.text =''
		Return
	END IF
	commit;

Next
w_mdi_frame.sle_msg.text = '소급 상여 계산 완료!!'
SetPointer(Arrow!)	
end if

sle_end.text = String(Now(),'hh:mm:ss AM/PM')

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\자료생성_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\자료생성_up.gif"
end event

type rr_3 from roundrectangle within w_pip4012
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 398
integer y = 412
integer width = 1417
integer height = 1460
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_4 from roundrectangle within w_pip4012
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 503
integer y = 504
integer width = 1202
integer height = 488
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_1 from roundrectangle within w_pip4012
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 389
integer y = 32
integer width = 1774
integer height = 304
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_pip4012
integer linethickness = 1
integer beginx = 786
integer beginy = 180
integer endx = 1033
integer endy = 180
end type

type ln_2 from line within w_pip4012
integer linethickness = 1
integer beginx = 1033
integer beginy = 796
integer endx = 1271
integer endy = 796
end type

type ln_3 from line within w_pip4012
integer linethickness = 1
integer beginx = 1335
integer beginy = 796
integer endx = 1573
integer endy = 796
end type

type rr_5 from roundrectangle within w_pip4012
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 503
integer y = 1076
integer width = 1202
integer height = 208
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_pip4012
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2080
integer y = 408
integer width = 2213
integer height = 1688
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_6 from roundrectangle within w_pip4012
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 2235
integer y = 500
integer width = 896
integer height = 1508
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_7 from roundrectangle within w_pip4012
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 3305
integer y = 500
integer width = 896
integer height = 1508
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_1 from u_key_enter within w_pip4012
integer x = 581
integer y = 192
integer width = 1513
integer height = 112
integer taborder = 11
string title = "none"
string dataobject = "d_pip4012_2"
boolean border = false
end type

event itemchanged;call super::itemchanged;cb_retrieve.triggerevent(Clicked!)
end event

