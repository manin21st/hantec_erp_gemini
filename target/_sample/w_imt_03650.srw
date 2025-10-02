$PBExportHeader$w_imt_03650.srw
$PBExportComments$** 발주서(영문)
forward
global type w_imt_03650 from w_standard_print
end type
type pb_1 from u_pic_cal within w_imt_03650
end type
type pb_2 from u_pic_cal within w_imt_03650
end type
end forward

global type w_imt_03650 from w_standard_print
string title = "발주서"
pb_1 pb_1
pb_2 pb_2
end type
global w_imt_03650 w_imt_03650

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, gubun, scvcod1, scvcod2, sbaljpno

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
gubun = trim(dw_ip.object.gubun[1])
scvcod1 = trim(dw_ip.object.cvcod1[1])
scvcod2 = trim(dw_ip.object.cvcod2[1])
sbaljpno = trim(dw_ip.object.baljpno[1])

if (IsNull(sdate) or sdate = "")  then sdate = "00000000"
if (IsNull(edate) or edate = "")  then edate = "99999999"
if (IsNull(scvcod1) or scvcod1 = "")  then scvcod1 = "."
if (IsNull(scvcod2) or scvcod2 = "")  then scvcod2 = "zzzzzzzzzzzz"
if (IsNull(sbaljpno) or sbaljpno = "")  then sbaljpno = "%"

//if dw_list.Retrieve(gs_sabu, sdate, edate, gubun, scvcod1, scvcod2, sbaljpno, sbaljpno) <= 0 then
//	f_message_chk(50,'[발주서(영문)]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, gubun, scvcod1, scvcod2, sbaljpno, sbaljpno) <= 0 then
	f_message_chk(50,'[발주서(영문)]')
	dw_ip.Setfocus()
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

String sName
// 발주회사 명칭
SELECT DATANAME into :sName
 FROM SYSCNFG 
 WHERE SYSGU 	= 'C' 
	AND SERIAL	= 9
	AND LINENO	= '12';
	
IF isnull(sname) then sname = ''	
dw_list.object.head1.text = sName

SELECT DATANAME into :sName
 FROM SYSCNFG 
 WHERE SYSGU 	= 'C' 
	AND SERIAL	= 9
	AND LINENO	= '13';

IF isnull(sname) then sname = ''	
dw_list.object.head2.text = sName

SELECT DATANAME into :sName
 FROM SYSCNFG 
 WHERE SYSGU 	= 'C' 
	AND SERIAL	= 9
	AND LINENO	= '14';
	
IF isnull(sname) then sname = ''	
dw_list.object.head3.text = sName

// 담당자
sName = Trim(dw_ip.GetItemstring(1, 'head4'))
If IsNull(sName) Or sName = '' Then
	SELECT DATANAME into :sName
	 FROM SYSCNFG 
	 WHERE SYSGU 	= 'C' 
		AND SERIAL	= 9
		AND LINENO	= '15';
End If
	
IF isnull(sname) then sname = ''	
dw_list.object.head4.text = sName

SELECT DATANAME into :sName
 FROM SYSCNFG 
 WHERE SYSGU 	= 'C' 
	AND SERIAL	= 9
	AND LINENO	= '9';
	
IF isnull(sname) then sname = ''	
dw_list.object.head9.text = sName

//회사영문 주소
SELECT DATANAME into :sName
 FROM SYSCNFG 
 WHERE SYSGU 	= 'C' 
	AND SERIAL	= 1
	AND LINENO	= '11';
	
IF isnull(sname) then sname = ''	
dw_list.object.head10.text = sName
//tel
SELECT DATANAME into :sName
 FROM SYSCNFG 
 WHERE SYSGU 	= 'C' 
	AND SERIAL	= 9
	AND LINENO	= '10';
	
IF isnull(sname) then sname = ''	
dw_list.object.head11.text = sName
//fax
SELECT DATANAME into :sName
 FROM SYSCNFG 
 WHERE SYSGU 	= 'C' 
	AND SERIAL	= 9
	AND LINENO	= '11';
	
IF isnull(sname) then sname = ''	
dw_list.object.head12.text = sName
return 1
end function

on w_imt_03650.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_imt_03650.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;dw_list.object.datawindow.print.preview = "yes"	
end event

type dw_list from w_standard_print`dw_list within w_imt_03650
integer width = 3489
integer height = 1964
string dataobject = "d_imt_03650_02"
end type

type cb_print from w_standard_print`cb_print within w_imt_03650
end type

type cb_excel from w_standard_print`cb_excel within w_imt_03650
end type

type cb_preview from w_standard_print`cb_preview within w_imt_03650
end type

type cb_1 from w_standard_print`cb_1 within w_imt_03650
end type

type dw_print from w_standard_print`dw_print within w_imt_03650
string dataobject = "d_imt_03650_02"
end type

type dw_ip from w_standard_print`dw_ip within w_imt_03650
integer y = 56
integer width = 3489
integer height = 188
string dataobject = "d_imt_03650_01"
end type

event dw_ip::itemchanged;String s_cod, s_nam1, s_nam2, snull
integer i_rtn

setnull(snull)

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sdate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[시작일자]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "edate" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[끝일자]")
		this.object.edate[1] = ""
		return 1
	end if
elseif this.getcolumnname() = 'cvcod1' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod1",s_cod)	
	this.SetItem(1,"cvnam1",s_nam1)	
	return i_rtn
elseif this.getcolumnname() = 'cvcod2' then   
	i_rtn = f_get_name2("V0", "N", s_cod, s_nam1, s_nam2)
	this.SetItem(1,"cvcod2",s_cod)	
	this.SetItem(1,"cvnam2",s_nam1)	
	return i_rtn
	
elseIF this.GetColumnName() ="baljpno" THEN
  SELECT "POMAST"."BALJPNO", 
  			"POMAST"."BALGU" 
    INTO :s_nam1, :s_nam2
    FROM "POMAST"  
   WHERE ( "POMAST"."SABU" = :gs_sabu ) AND  
         ( "POMAST"."BALJPNO" = :s_cod )   ;

	IF SQLCA.SQLCODE <> 0 then 
		setitem(1, "baljpno", snull)
      RETURN 1
	Elseif s_nam2 = '3' then
		Messagebox("발주내역", "외주발주 내역은 출력할 수 없읍니다", stopsign!)
		setitem(1, "baljpno", snull)
		return 1
	END IF	
end if


end event

event dw_ip::itemerror;return 1
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF this.getcolumnname() = "cvcod1"	THEN		
	gs_gubun = '1' 
	open(w_vndmst_popup)
	if gs_code = '' and  isnull(gs_code) then return 
	this.SetItem(1, "cvcod1", gs_code)
	this.SetItem(1, "cvnam1", gs_codename)
	return
ELSEIF this.getcolumnname() = "cvcod2"	THEN		
	gs_gubun = '1' 
	open(w_vndmst_popup)
	if gs_code = '' and  isnull(gs_code) then return 
	this.SetItem(1, "cvcod2", gs_code)
	this.SetItem(1, "cvnam2", gs_codename)
	return
elseIF this.GetColumnName() = "baljpno" THEN
	gs_gubun = '1' //발주지시상태 => 1:의뢰
	open(w_poblkt_popup)
	this.setitem(1, "baljpno", left(gs_code, 12))
END IF
end event

type r_1 from w_standard_print`r_1 within w_imt_03650
end type

type r_2 from w_standard_print`r_2 within w_imt_03650
end type

type pb_1 from u_pic_cal within w_imt_03650
integer x = 722
integer y = 72
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('sdate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'sdate', gs_code)



end event

type pb_2 from u_pic_cal within w_imt_03650
integer x = 1198
integer y = 72
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;Long ll_row

dw_ip.SetColumn('edate')
IF IsNull(gs_code) THEN Return
ll_row = dw_ip.GetRow()
If ll_row < 1 Then Return
dw_ip.SetItem(ll_row, 'edate', gs_code)



end event

