$PBExportHeader$w_qa06_00060_popup.srw
$PBExportComments$**검사성적서 측정치 등록_한텍(17.10.31)
forward
global type w_qa06_00060_popup from window
end type
type dw_ip from datawindow within w_qa06_00060_popup
end type
type p_2 from picture within w_qa06_00060_popup
end type
type p_1 from picture within w_qa06_00060_popup
end type
type dw_check from datawindow within w_qa06_00060_popup
end type
type rr_1 from roundrectangle within w_qa06_00060_popup
end type
type dw_view from datawindow within w_qa06_00060_popup
end type
end forward

global type w_qa06_00060_popup from window
integer width = 3954
integer height = 2428
boolean titlebar = true
string title = "검사성적서 측정치 등록(수입검사)"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
string icon = "AppIcon!"
boolean center = true
dw_ip dw_ip
p_2 p_2
p_1 p_1
dw_check dw_check
rr_1 rr_1
dw_view dw_view
end type
global w_qa06_00060_popup w_qa06_00060_popup

type variables
string		is_iojpno, is_gubun, is_old_iojpno,is_qc_gubun, is_itnbr
boolean	ib_dragflag
end variables

forward prototypes
public function integer wf_reset ()
public function integer wf_insert ()
public function integer wf_re ()
public function integer wf_save ()
public function integer wf_decision (long ar_row, string ar_col)
end prototypes

public function integer wf_reset ();string		sitnbr, sitdsc, scvcod, scvnas, sipdat, slotno
decimal	dipqty

dw_ip.Reset()
dw_ip.insertrow(0)

SELECT ITNBR, FUN_GET_ITDSC(ITNBR), CVCOD, FUN_GET_CVNAS(CVCOD), SUDAT, IOREQTY, LOTENO
  INTO :sitnbr, :sitdsc, :scvcod, :scvnas, :sipdat, :dipqty, :slotno
  FROM IMHIST
 WHERE SABU = :gs_sabu
     AND IOJPNO = :is_iojpno;

dw_ip.setitem(1, 'itnbr', sitnbr)
dw_ip.setitem(1, 'itdsc', sitdsc)
dw_ip.setitem(1, 'cvcod', scvcod)
dw_ip.setitem(1, 'cvnas', scvnas)
dw_ip.setitem(1, 'ipdat', sipdat)
dw_ip.setitem(1, 'ipqty', dipqty)
dw_ip.setitem(1, 'lotno', slotno)

wf_insert()

return 1
end function

public function integer wf_insert ();////////////////////////////////////////////////////////////
//// 자료 생성
////////////////////////////////////////////////////////////
string sitnbr, sEcono

long nCount, nRow

if dw_ip.AcceptText() <> 1 then
	return -1
end if

sitnbr = trim(dw_ip.GetItemString(1, "itnbr"))

/////////////////////////////////////////////////
//// 검사 자료 생성 (구분별)
/////////////////////////////////////////////////
INSERT INTO POP_QCINSP_SIL
					(SHPJPNO,
					 GUBUN,
					ITNBR, 
					CHECK_SEQ)
				SELECT  :is_iojpno, 
				             :is_qc_gubun,
							A.ITNBR, 
							CHECK_SEQ
						  FROM POP_QCINSP_CHECK A
						 WHERE A.ITNBR = :sitnbr 
						    AND A.GUBUN = :is_qc_gubun
							AND A.CHECK_SEQ NOT IN (SELECT B.CHECK_SEQ 
																FROM POP_QCINSP_SIL B 
																WHERE B.SHPJPNO = :is_iojpno
 																    AND B.GUBUN     =  :is_qc_gubun);

if sqlca.sqlcode <> 0 then
	rollback;
	messagebox("자료 검색 실패1", "다시 시도하세요")
	return -1
end if
																							
commit;

///////////////////////////////////////////////
//// 자료 조회
///////////////////////////////////////////////
wf_re()

return 1
end function

public function integer wf_re ();///////////////////////////////////////////////
//// 자료 조회
///////////////////////////////////////////////
dw_check.Reset()
if dw_check.Retrieve(is_iojpno,is_qc_gubun, is_old_iojpno) <= 0 then
	dw_check.Reset()
else	
//	dw_ip.SetItem(1, 'econo', dw_check.GetItemString(1, 'eono'))
end if

return 1

end function

public function integer wf_save ();if dw_check.accepttext( ) = -1 then return -1

long nCount, ii, nCheck_seq

nCount = dw_check.rowcount( )

for ii = 1 to nCount
	nCheck_seq = dw_check.getitemnumber(ii, 'check_seq')

	if nCheck_seq < 1 or isnull(nCheck_seq) then
		messagebox('순서 확인', string(ii) + 'Row 순서를 확인하세요')
		return -1
	end if
next

If MessageBox('저장','변경된 내용을 저장하시겠습니까?',Exclamation!, OKCancel!, 2 ) = 2  then return -1

if dw_check.update( ) <> 1 then
	rollback;
	messagebox('저장 실패', '저장에 실패하였습니다.')
	return -1
end if

commit;

return 1
end function

public function integer wf_decision (long ar_row, string ar_col);//칼럼등록 합불 판정
//value10_x setting 
//if( value1_1 = 'NG', 0, IF(value1_1 = 'OK', 1, IF( std_upper < dec(value1_1) or  std_lower > dec(value1_1), 0, 1))) or decision1x
string sGet_Data , sGet_Decison , sSet_Column,sSet_Column1,sTime
decimal std_upper , std_lower

sGet_Data = dw_check.getitemstring(ar_row,ar_col)
std_upper = dw_check.getitemdecimal(ar_row,"std_upper")
std_lower = dw_check.getitemdecimal(ar_row,"std_lower")
sSet_Column = "value10_"+string(mid(ar_col,6,1))
sSet_Column1 = "value"+string(mid(ar_col,6,1))+"_time"


SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MI')
  INTO :sTime
  FROM dual;

If sGet_Data = "" or isnull(sGet_Data) then
	return -1
End If

If sGet_data = 'NG' then
   sGet_Decison  = 'NG'
ElseIf sGet_data = 'OK' then
   sGet_Decison  = 'OK'
ElseIf  (std_upper < dec(sGet_data) or  std_lower > dec(sGet_data)) then
   sGet_Decison  = 'NG'	
Else
   sGet_Decison  = 'OK'
End If

dw_check.setitem(ar_row,sSet_Column,sGet_Decison)
dw_check.setitem(ar_row,sSet_Column1,sTime)

return 1
end function

on w_qa06_00060_popup.create
this.dw_ip=create dw_ip
this.p_2=create p_2
this.p_1=create p_1
this.dw_check=create dw_check
this.rr_1=create rr_1
this.dw_view=create dw_view
this.Control[]={this.dw_ip,&
this.p_2,&
this.p_1,&
this.dw_check,&
this.rr_1,&
this.dw_view}
end on

on w_qa06_00060_popup.destroy
destroy(this.dw_ip)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.dw_check)
destroy(this.rr_1)
destroy(this.dw_view)
end on

event open;f_window_center(this)

is_gubun   = gs_gubun
is_iojpno = gs_code
is_qc_gubun = gs_codename
is_itnbr		 = gs_codename3

setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)
setnull(gs_codename3)

dw_ip.SetTransObject(sqlca)
dw_check.SetTransObject(sqlca)

dw_view.SetTransObject(sqlca)
//dw_view.Retrieve(Left(is_itnbr,11))
dw_view.Retrieve(is_itnbr)

////////////////////////////////////////
wf_reset()

end event

type dw_ip from datawindow within w_qa06_00060_popup
integer x = 32
integer y = 4
integer width = 3310
integer height = 220
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa06_00060_popup_0"
boolean border = false
end type

event clicked;if row < 1 then
	return
end if

this.SetRedraw(false)
this.SetRow(row)
this.SetRedraw(true)

String sFilepath
if dwo.name = 'b_down' then			//검사표준서	
	
	if dw_view.visible then
		dw_view.visible = false
	else
		dw_view.visible = true
	end if
	
end if

end event

event itemerror;return 1
end event

type p_2 from picture within w_qa06_00060_popup
integer x = 3735
integer width = 178
integer height = 144
string pointer = "HyperLink!"
boolean originalsize = true
string picturename = "C:\erpman\image\취소_up.gif"
boolean focusrectangle = false
end type

event clicked;Close(Parent)
end event

type p_1 from picture within w_qa06_00060_popup
integer x = 3557
integer width = 178
integer height = 144
string pointer = "HyperLink!"
string picturename = "C:\erpman\image\저장_up.gif"
boolean focusrectangle = false
end type

event clicked;wf_save()
end event

type dw_check from datawindow within w_qa06_00060_popup
event ue_pressenter pbm_dwnprocessenter
integer x = 27
integer y = 240
integer width = 3872
integer height = 2064
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_qa06_00060_popup_1"
boolean border = false
end type

event itemerror;RETURN 1
end event

event itemchanged;if row < 1 then return

string	sName, sCheck_type
long	nNumber

sName = dwo.name
scheck_type = this.getitemstring(row, 'check_type')

if sName = 'check_spc' then
	if data = 'Y' then
		this.setitem(row, 'check_type', '2')
	end if
	
elseif left(sName, 5) = 'value' then
	sCheck_type = this.getitemstring(row, 'check_type')
	if sCheck_type = '2' then		
		SELECT TO_NUMBER(:data)
		  INTO :nNumber
		  FROM DUAL;
		  
		if sqlca.sqlcode <> 0 then
			messagebox('확인', '숫자로만 입력하여야 합니다.')
			return 2
		end if
		
	else
		
		if data <> 'OK' and data <> 'NG' then
			messagebox('확인', '대문자 OK/NG 로만 입력하여야 합니다.')
			return 2
		end if
		
	end if
	
	//ok ng판별
	wf_decision(row,sName)

end if

end event

event retrieveend;If rowcount > 0 Then Event RowFocusChanged(1)

end event

event rowfocuschanged;If currentrow < 1 Then
	return
end if

this.SetRedraw(false)
this.SelectRow(0, false)
//this.SelectRow(currentrow, true)
this.SetRow(currentrow)
this.SetRedraw(true)
end event

event clicked;if row < 1 then
	return
end if

this.SetRedraw(false)
this.SelectRow(0, false)
//this.SelectRow(row, true)
this.SetRow(row)
this.SetRedraw(true)

end event

type rr_1 from roundrectangle within w_qa06_00060_popup
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 33027312
integer x = 23
integer y = 232
integer width = 3890
integer height = 2076
integer cornerheight = 40
integer cornerwidth = 55
end type

type dw_view from datawindow within w_qa06_00060_popup
boolean visible = false
integer x = 46
integer y = 252
integer width = 3013
integer height = 1484
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "이미지 뷰어"
string dataobject = "d_qa06_00060_popup_2"
boolean controlmenu = true
boolean maxbox = true
boolean border = false
boolean livescroll = true
end type

