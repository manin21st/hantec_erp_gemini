$PBExportHeader$w_imt_04680.srw
$PBExportComments$** 거래처별 매입원장
forward
global type w_imt_04680 from w_standard_print
end type
type pb_1 from u_pb_cal within w_imt_04680
end type
type pb_2 from u_pb_cal within w_imt_04680
end type
type rr_1 from roundrectangle within w_imt_04680
end type
type rr_2 from roundrectangle within w_imt_04680
end type
end forward

global type w_imt_04680 from w_standard_print
integer height = 2500
string title = "거래처별 매입원장"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
rr_2 rr_2
end type
global w_imt_04680 w_imt_04680

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string fdate, tdate, sHouse, sgubun, scvcod, sittyp, sgub, swaigu, ssaupj, smro

IF dw_ip.AcceptText() = -1 THEN RETURN -1

sgub   	= dw_ip.GetItemString(1,"dategubun")
fdate  	= trim(dw_ip.GetItemString(1, "sdate"))
tdate  	= trim(dw_ip.GetItemString(1, "edate"))
shouse 	= dw_ip.GetItemString(1, "house")
sgubun 	= dw_ip.GetItemString(1, "gubun")
scvcod 	= dw_ip.GetItemString(1, "scvcod")
sittyp 	= dw_ip.GetItemString(1, "sittyp")
swaigu 	= dw_ip.GetItemString(1, "maip")
smro 		= dw_ip.GetItemString(1, "mro")
ssaupj 	= dw_ip.GetItemString(1, "saupj")

if 	IsNull(sHouse) or trim(sHouse) = ''	THEN sHouse = '%'
if 	IsNull(sCvcod) or trim(sCvcod) = '' THEN scvcod = '%'
if 	sGubun = '3' then sGubun = '%'
if 	IsNull(sittyp) or trim(sittyp) = '' THEN sittyp = '%'
if 	IsNull(fdate) or fdate = ''	THEN fdate = '10000101'
if	IsNull(tdate) or tdate = ''	THEN tdate = '99991231'

If sgub = '1' then  //승인일자 기준
   	dw_list.DataObject = 'd_imt_04680_2'
	dw_print.DataObject = 'd_imt_04680_2_p'
Else                //검사일자 기준
   dw_list.DataObject = 'd_imt_04680_1'
	dw_print.DataObject = 'd_imt_04680_1_p'
End if
dw_list.settransobject(sqlca)
dw_print.settransobject(sqlca)

if dw_print.Retrieve(gs_sabu, fdate, tdate, scvcod, sgubun, shouse, sittyp, swaigu, ssaupj, smro) <= 0 then
	f_message_chk(50,'[거래처별 매입원장]')
	dw_ip.Setfocus()
	return -1
else
	dw_print.sharedata(dw_list)
end if

Return 1


end function

on w_imt_04680.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
this.Control[iCurrent+4]=this.rr_2
end on

on w_imt_04680.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event ue_open;call super::ue_open;is_today = f_today()

//사업장별 창고
f_child_saupj(dw_ip,'house',gs_saupj)

dw_ip.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)
dw_print.SetTransObject(sqlca)

dw_ip.InsertRow(0)
dw_ip.SetItem(1, 1, Left(is_today,6) + '01')
dw_ip.SetItem(1, 2, is_today)

/* 부가 사업장 */
f_mod_saupj(dw_ip,'saupj')

/* MRO 부서인 경우 */
string sdepot

select cvcod into :sdepot from vndmst
 where cvgu = '5' and juprod = 'Z' and deptcode in ( Select deptcode  from p1_master where empno = :gs_empno ) and rownum = 1;

if sqlca.sqlcode = 0 then
	dw_ip.setitem(1,'house',sdepot)
	dw_ip.Object.house.protect = '1'
end if

dw_ip.SetFocus()
dw_ip.SetColumn('dategubun')
end event

type p_xls from w_standard_print`p_xls within w_imt_04680
end type

type p_sort from w_standard_print`p_sort within w_imt_04680
end type

type p_preview from w_standard_print`p_preview within w_imt_04680
end type

type p_exit from w_standard_print`p_exit within w_imt_04680
end type

type p_print from w_standard_print`p_print within w_imt_04680
end type

type p_retrieve from w_standard_print`p_retrieve within w_imt_04680
end type







type st_10 from w_standard_print`st_10 within w_imt_04680
end type



type dw_print from w_standard_print`dw_print within w_imt_04680
string dataobject = "d_imt_04680_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_04680
integer y = 40
integer width = 3118
integer height = 368
string dataobject = "d_imt_04680"
end type

event dw_ip::rbuttondown;SetNull(Gs_Code)
SetNull(Gs_CodeName)
SetNull(Gs_CodeName2)

Choose Case this.GetColumnName() 
 Case "scvcod"
	Gs_gubun = '1'
	Gs_CodeName2 = 'Y'  //거래중지 업체 선택 가능 여부(Y:거래중지 업체 선택 가능, N:거래중지 업체 선택 불가) - by shingoon 2015.09.10
	
	Open(w_vndmst_popup)
	
	IF gs_code ="" OR IsNull(gs_code) THEN RETURN
	
	this.SetItem(1,"scvcod",gs_code)
	this.SetItem(1,"cvname",gs_codename)
end choose
end event

event itemerror;
Return 1
end event

event dw_ip::itemchanged;string	sDate, sNull, sname, sname2 
Int      iReturn

SetNull(sNull)

IF this.GetColumnName() = 'sdate' THEN
	sDate  = TRIM(this.gettext())
	
	IF sdate = '' or isnull(sdate) then return
	IF f_datechk(sDate) = -1	then
		this.setitem(1, "sdate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'edate' THEN
	sDate  = TRIM(this.gettext())

	IF sdate = '' or isnull(sdate) then return 

	IF f_datechk(sDate) = -1	then
		this.setitem(1, "edate", sNull)
		return 1
	END IF
ELSEIF this.GetColumnName() = 'scvcod' THEN
	sdate = trim(this.GetText())
	
	if sdate = '' or isnull(sdate) then 
		this.setitem(1, "cvname", sNull)	
		return
	end if	
	
//	ireturn = f_get_name2('V1', 'Y', sdate, sname, sname2)
	SELECT CVNAS INTO :sname FROM VNDMST WHERE CVCOD = :sdate ;
	this.SetItem(1,"scvcod",sdate)
	this.SetItem(1,"cvname",sname)
	RETURN ireturn
elseif getcolumnname() = 'saupj' then
	sdate = gettext()
	f_child_saupj(dw_ip,'house',sdate)
END IF

end event

type dw_list from w_standard_print`dw_list within w_imt_04680
integer x = 32
integer y = 444
integer width = 4549
integer height = 1856
string dataobject = "d_imt_04680_2"
boolean border = false
end type

type pb_1 from u_pb_cal within w_imt_04680
integer x = 846
integer y = 212
integer taborder = 10
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pb_cal within w_imt_04680
integer x = 1298
integer y = 212
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

type rr_1 from roundrectangle within w_imt_04680
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 18
integer y = 32
integer width = 3173
integer height = 384
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_imt_04680
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 432
integer width = 4585
integer height = 1884
integer cornerheight = 40
integer cornerwidth = 55
end type

