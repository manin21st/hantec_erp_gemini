$PBExportHeader$w_xm90_0070.srw
$PBExportComments$월 납품실적 집계현황
forward
global type w_xm90_0070 from w_standard_print
end type
type pb_1 from u_pb_cal within w_xm90_0070
end type
type rr_1 from roundrectangle within w_xm90_0070
end type
end forward

global type w_xm90_0070 from w_standard_print
integer width = 4631
integer height = 2480
string title = "월 납품실적 집계현황"
pb_1 pb_1
rr_1 rr_1
end type
global w_xm90_0070 w_xm90_0070

type variables
str_itnct str_sitnct
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  s_depot, s_fritnbr, s_toitnbr, s_frdate, s_todate, s_yymm, s_maxym, s_gub

String ls_saupj
String ls_yymm , ls_sdate , ls_edate , ls_depot , ls_itnbr_fr , ls_itnbr_to

IF dw_ip.AcceptText() = -1 THEN RETURN -1

ls_saupj = Trim(dw_ip.object.saupj[1]) 
ls_yymm  = Trim(dw_ip.object.jisi_date[1]) 

If f_datechk(ls_yymm+'01') < 1 Then
	f_message_chk(34,'[기준년월]')
	Return -1
End If

ls_sdate = ls_yymm + '01'
ls_edate = ls_yymm + '31'

ls_depot  = Trim(dw_ip.object.mdepot[1])

ls_itnbr_fr = Trim(dw_ip.object.itnbr_from[1])
ls_itnbr_to = Trim(dw_ip.object.itnbr_to[1])

If ls_itnbr_fr = '' or isNull(ls_itnbr_fr) Then ls_itnbr_fr = '.'
If ls_itnbr_to = '' or isNull(ls_itnbr_to) Then ls_itnbr_to = 'zzzzzzzzzzzzzzzzzzz'

SELECT MAX(JPDAT)  
  INTO :s_maxym
  FROM JUNPYO_CLOSING  
 WHERE SABU = :gs_sabu AND JPGU = 'C0' ;
 
IF s_maxym = '' or isNull( s_maxym) Then s_maxym = '20060101'

IF dw_print.Retrieve(gs_sabu,ls_yymm ,ls_sdate,ls_edate,ls_depot,ls_itnbr_fr,ls_itnbr_to,s_maxym, ls_saupj ) < 1 THEN
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

return 1
end function

on w_xm90_0070.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_xm90_0070.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event ue_open;call super::ue_open;
dw_ip.reset() 
dw_ip.insertrow(0) 
dw_ip.setitem(1, 'saupj', gs_saupj ) 
dw_ip.Object.mdepot[1] = gs_userid

dw_ip.Object.jisi_date[1] = left( is_today , 6)
dw_ip.Object.jisi_date2[1] =left( is_today , 6)


end event

type p_xls from w_standard_print`p_xls within w_xm90_0070
boolean visible = true
integer x = 3913
integer y = 24
end type

type p_sort from w_standard_print`p_sort within w_xm90_0070
end type

type p_preview from w_standard_print`p_preview within w_xm90_0070
integer x = 4087
end type

type p_exit from w_standard_print`p_exit within w_xm90_0070
integer x = 4434
end type

type p_print from w_standard_print`p_print within w_xm90_0070
integer x = 4261
end type

type p_retrieve from w_standard_print`p_retrieve within w_xm90_0070
integer x = 3739
end type







type st_10 from w_standard_print`st_10 within w_xm90_0070
end type



type dw_print from w_standard_print`dw_print within w_xm90_0070
string dataobject = "d_sm90_0070_a"
end type

type dw_ip from w_standard_print`dw_ip within w_xm90_0070
integer x = 23
integer y = 20
integer width = 2775
integer height = 260
string dataobject = "d_xm90_0070_1"
end type

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_xm90_0070
integer y = 296
integer width = 4539
integer height = 1988
string dataobject = "d_sm90_0070_a"
boolean border = false
boolean hsplitscroll = false
end type

type pb_1 from u_pb_cal within w_xm90_0070
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
dw_ip.SetItem(1, 'jisi_date', LEFT(gs_code,6))

end event

type rr_1 from roundrectangle within w_xm90_0070
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 288
integer width = 4567
integer height = 2008
integer cornerheight = 40
integer cornerwidth = 55
end type

