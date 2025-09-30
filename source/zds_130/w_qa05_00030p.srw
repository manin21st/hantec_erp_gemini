$PBExportHeader$w_qa05_00030p.srw
$PBExportComments$계측기기 검사 성적서
forward
global type w_qa05_00030p from w_standard_print
end type
type pb_1 from u_pb_cal within w_qa05_00030p
end type
type pb_2 from u_pb_cal within w_qa05_00030p
end type
type rr_1 from roundrectangle within w_qa05_00030p
end type
end forward

global type w_qa05_00030p from w_standard_print
integer height = 2516
string title = "계측기기 검사성적서"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qa05_00030p w_qa05_00030p

type variables
boolean lb_src_down, lb_dsc_down
String s_row
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_sdate ,ls_edate ,ls_dept , ls_status


if dw_ip.AcceptText() = -1 then 
	dw_ip.SetFocus()
	return -1
end if	

ls_sdate = trim(dw_ip.object.sdate[1])
ls_edate = trim(dw_ip.object.edate[1])
ls_dept  = trim(dw_ip.object.deptcode[1])
ls_status = trim(dw_ip.object.status[1])

if (IsNull(ls_sdate) or ls_sdate = "") then ls_sdate = "19000101"
if (IsNull(ls_edate) or ls_edate = "") then ls_edate = is_today
if (IsNull(ls_dept) or ls_dept = "") then ls_dept = "%%"

if dw_list.Retrieve(gs_sabu, ls_sdate, ls_edate , ls_status ,ls_dept) <= 0 then
	f_message_chk(50,"[계측기기 검사 성적서]")
	dw_ip.Setfocus()
	return -1

end if

Return 1
	
end function

on w_qa05_00030p.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_qa05_00030p.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_print.ShareDataOff()

dw_ip.object.sdate[1] = f_afterday(is_today , -30)
dw_ip.object.edate[1] = is_today

end event

type p_xls from w_standard_print`p_xls within w_qa05_00030p
end type

type p_preview from w_standard_print`p_preview within w_qa05_00030p
integer x = 4046
integer y = 32
end type

event p_preview::clicked;If dw_list.RowCount() < 1 Then Return

String ls_mchno
Long   i , seq

i = dw_list.getselectedrow(0)
if i < 1 then
	MessageBox('확인','조회된 리스트 중에서 해당 관리번호를 선택하세요.')
	Return
End If

ls_mchno = Trim(dw_list.Object.mchno[i])
seq		= dw_list.Object.seq[i]

If dw_print.Retrieve(gs_sabu , ls_mchno, seq) > 0 Then

	
	OpenWithParm(w_print_preview, dw_print)
Else
   
End If
end event

type p_exit from w_standard_print`p_exit within w_qa05_00030p
integer x = 4389
integer y = 32
integer taborder = 110
end type

type p_print from w_standard_print`p_print within w_qa05_00030p
integer x = 4219
integer y = 32
integer taborder = 70
end type

event p_print::clicked;If dw_list.RowCount() < 1 Then Return

String ls_mchno
Long   i , seq

i = dw_list.getselectedrow(0)
if i < 1 then
	MessageBox('확인','조회된 리스트 중에서 해당 관리번호를 선택하세요.')
	Return
End If

ls_mchno = Trim(dw_list.Object.mchno[i])
seq		= dw_list.Object.seq[i]

If dw_print.Retrieve(gs_sabu , ls_mchno, seq) < 1 Then
	return
   
End If

IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within w_qa05_00030p
integer x = 3877
integer y = 32
end type



type sle_msg from w_standard_print`sle_msg within w_qa05_00030p
boolean displayonly = true
end type



type st_10 from w_standard_print`st_10 within w_qa05_00030p
end type



type dw_print from w_standard_print`dw_print within w_qa05_00030p
string dataobject = "d_qa05_00030p_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qa05_00030p
integer x = 37
integer y = 32
integer width = 3456
integer height = 168
string dataobject = "d_qa05_00030p_1"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod, s_name , s_null
integer i_rtn

s_cod = Trim(this.GetText())
SetNull(s_null)

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
	
elseif this.GetColumnName() = "deptcode" then 
		If s_cod = '' Or isNull(s_cod) Then
			this.setitem(1,'deptcode',s_null)
			this.setitem(1,'deptname',s_null)
			Return 
		End If
		
		select cvnas into :s_name 
		  from vndmst
	 	 where cvcod = :s_cod ;
	 
		if sqlca.sqlcode = 0 then
			this.setitem(1,'deptname',s_name)
		else
			f_message_chk(33, "[관리부서]")
			this.setitem(1,'deptcode',s_null)
			this.setitem(1,'deptname',s_null)
			return 1
		end if
		
end if


end event

event dw_ip::rbuttondown;call super::rbuttondown;String ls_col

setnull(gs_code)
setnull(gs_codename)
setnull(gs_gubun)
ls_col = Lower(GetColumnName())

Choose Case ls_col
	
	Case 'deptcode' 
		open(w_vndmst_4_popup)
		if isnull(gs_code) or gs_code = '' then return
		
		This.setitem(1,ls_col,gs_code)
	   This.TriggerEvent(itemchanged!)	
End Choose
end event

type dw_list from w_standard_print`dw_list within w_qa05_00030p
integer x = 50
integer y = 220
integer width = 4498
integer height = 2076
string dataobject = "d_qa05_00030p_a"
boolean border = false
end type

event dw_list::clicked;call super::clicked;If Row <= 0 then
	SelectRow(0,False)
ELSE
	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
END IF
end event

type pb_1 from u_pb_cal within w_qa05_00030p
integer x = 695
integer y = 76
integer height = 76
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('sdate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'sdate', gs_code)

end event

type pb_2 from u_pb_cal within w_qa05_00030p
integer x = 1152
integer y = 76
integer height = 76
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('edate')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'edate', gs_code)

end event

type rr_1 from roundrectangle within w_qa05_00030p
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 212
integer width = 4521
integer height = 2096
integer cornerheight = 40
integer cornerwidth = 55
end type

