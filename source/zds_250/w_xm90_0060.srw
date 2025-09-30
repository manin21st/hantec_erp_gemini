$PBExportHeader$w_xm90_0060.srw
$PBExportComments$납품실적 현황
forward
global type w_xm90_0060 from w_standard_print
end type
type pb_1 from u_pb_cal within w_xm90_0060
end type
type pb_2 from u_pb_cal within w_xm90_0060
end type
type rr_1 from roundrectangle within w_xm90_0060
end type
end forward

global type w_xm90_0060 from w_standard_print
integer width = 4667
integer height = 2480
string title = "납품실적 현황"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_xm90_0060 w_xm90_0060

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String ls_saupj , ls_sdate , ls_edate , ls_itnbr_fr , ls_itnbr_to , ls_empno , ls_factory ,ls_gubun
Long   ll_rcnt , i
dw_ip.AcceptText() 
dw_print.AcceptText() 

ls_saupj = Trim(dw_ip.Object.saupj[1])
ls_sdate = Trim(dw_ip.Object.jisi_date[1])
ls_edate = Trim(dw_ip.Object.jisi_date2[1])

ls_gubun = Trim(dw_ip.Object.mdepot[1])

If f_datechk(ls_sdate) < 1 Then
	f_message_chk(35,'[기준일자(시작)]')
	dw_ip.setitem(1, "jisi_date", '')
	dw_ip.SetFocus()
	return -1
end if

If f_datechk(ls_edate) < 1 Then
	f_message_chk(35,'[기준일자(끝)]')
	dw_ip.setitem(1, "jisi_date", '')
	dw_ip.SetFocus()
	return -1
end if
	
ls_itnbr_fr = Trim(dw_ip.Object.itnbr_from[1])
ls_itnbr_to = Trim(dw_ip.Object.itnbr_from[1])

ls_factory = Trim(dw_ip.Object.factory[1])
ls_empno = Trim(dw_ip.Object.empno[1])

If ls_itnbr_fr = '' or isNull(ls_itnbr_fr) then ls_itnbr_fr = '.'
If ls_itnbr_to = '' or isNull(ls_itnbr_to) then ls_itnbr_to = 'z'
If ls_factory = '' or isNull(ls_factory) or ls_factory= '.'  then ls_factory = '%'
If ls_empno = '' or isNull(ls_empno) then ls_empno = '%'

dw_list.SetRedraw(False)
ll_rcnt = dw_print.Retrieve( ls_saupj , ls_sdate , ls_edate , ls_factory ,ls_itnbr_fr , ls_itnbr_to, ls_gubun  ) 
	
If ll_rcnt > 0 Then

	
Else
	Messagebox('확인','조건에 해당하는 데이타가 없습니다.')

End iF
dw_list.SetRedraw(True)

Return 1
end function

on w_xm90_0060.create
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

on w_xm90_0060.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;
dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 
dw_ip.Object.mdepot[1] = gs_userid

dw_ip.Object.jisi_date[1] = is_today
dw_ip.Object.jisi_date2[1] = is_today


end event

type p_xls from w_standard_print`p_xls within w_xm90_0060
boolean visible = true
integer x = 3922
integer y = 24
end type

type p_sort from w_standard_print`p_sort within w_xm90_0060
end type

type p_preview from w_standard_print`p_preview within w_xm90_0060
end type

type p_exit from w_standard_print`p_exit within w_xm90_0060
end type

type p_print from w_standard_print`p_print within w_xm90_0060
end type

type p_retrieve from w_standard_print`p_retrieve within w_xm90_0060
integer x = 3749
end type







type st_10 from w_standard_print`st_10 within w_xm90_0060
end type



type dw_print from w_standard_print`dw_print within w_xm90_0060
string dataobject = "d_sm90_0060_a"
end type

type dw_ip from w_standard_print`dw_ip within w_xm90_0060
integer x = 23
integer y = 20
integer width = 2775
integer height = 332
string dataobject = "d_xm90_0060_1"
end type

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_xm90_0060
integer y = 368
integer width = 4567
integer height = 1916
string dataobject = "d_sm90_0060_a"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_xm90_0060
integer x = 814
integer y = 152
integer width = 91
integer height = 80
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('jisi_date')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'jisi_date', gs_code)

end event

type pb_2 from u_pb_cal within w_xm90_0060
integer x = 1298
integer y = 152
integer width = 91
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('jisi_date2')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'jisi_date2', gs_code)

end event

type rr_1 from roundrectangle within w_xm90_0060
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 360
integer width = 4581
integer height = 1936
integer cornerheight = 40
integer cornerwidth = 55
end type

