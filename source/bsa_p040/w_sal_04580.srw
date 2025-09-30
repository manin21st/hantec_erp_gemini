$PBExportHeader$w_sal_04580.srw
$PBExportComments$ ===> 장기 악성 채권 현황
forward
global type w_sal_04580 from w_standard_print
end type
type pb_1 from u_pb_cal within w_sal_04580
end type
type rr_1 from roundrectangle within w_sal_04580
end type
end forward

global type w_sal_04580 from w_standard_print
string title = "장기 악성 채권 현황"
pb_1 pb_1
rr_1 rr_1
end type
global w_sal_04580 w_sal_04580

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String  sSteam, sYyMm

dw_ip.AcceptText()

sYyMm = String(today(),"yyyymm")
sSteam = Trim(dw_ip.GetItemString(1,'ssteam'))
if isNull(sSteam) or (sSteam = '') then
	sSteam = ''
end if

//if	(sYear='') or isNull(sYear) then
//	f_Message_Chk(35, '[기준년도]')
//	dw_ip.setcolumn('syy')
//	dw_ip.setfocus()
//	Return -1
//END IF

//dw_list.object.r_yy.Text = sYear

sSteam = sSteam+'%'

string ls_silgu

SELECT DATANAME
INTO   :ls_silgu
FROM   SYSCNFG
WHERE  SYSGU = 'S'   AND
       SERIAL = '8'  AND
       LINENO = '40' ;

//if dw_list.Retrieve(sYyMm, sSteam ,ls_silgu) < 1 then
//	f_message_Chk(300, '[출력조건 CHECK]')
//	dw_ip.setcolumn('symd')
//	dw_ip.setfocus()
//	return -1
//end if

if dw_print.Retrieve(sYyMm, sSteam ,ls_silgu) < 1 then
	f_message_Chk(300, '[출력조건 CHECK]')
	dw_ip.setcolumn('symd')
	dw_ip.setfocus()
	return -1
end if

dw_print.ShareData(dw_list)

return 1
end function

on w_sal_04580.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.rr_1
end on

on w_sal_04580.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.rr_1)
end on

event open;call super::open;sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"

/* User별 관할구역 Setting */
String sarea, steam, saupj

If f_check_sarea(sarea, steam, saupj) = 1 Then
	dw_ip.SetItem(1, "ssteam", sarea)
	dw_ip.Modify("ssteam.protect=1")
	dw_ip.Modify("ssteam.background.color = 80859087")
End If

dw_Ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_sal_04580
end type

type p_exit from w_standard_print`p_exit within w_sal_04580
end type

type p_print from w_standard_print`p_print within w_sal_04580
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_04580
end type







type st_10 from w_standard_print`st_10 within w_sal_04580
end type



type dw_print from w_standard_print`dw_print within w_sal_04580
string dataobject = "d_sal_04580_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_04580
integer x = 18
integer y = 24
integer width = 2779
integer height = 144
string dataobject = "d_sal_04580_01"
end type

event dw_ip::itemchanged;String sCol_Name

dw_Ip.AcceptText()
sCol_Name = This.GetColumnName()

// 영업팀 버턴클릭시
if sCol_Name = "ssteam" then
	p_retrieve.SetFocus()
	return 1				
end if
end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_sal_04580
integer y = 200
integer width = 4539
integer height = 2112
string dataobject = "d_sal_04580"
boolean border = false
end type

type pb_1 from u_pb_cal within w_sal_04580
integer x = 759
integer y = 48
integer height = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;//해당 컬럼 지정
dw_ip.SetColumn('symd')

//GS코드가 Null 이면 리턴
IF IsNull(gs_code) THEN Return 

//Gs Code에 지정된 날짜 값 지정
dw_ip.SetItem(1, 'symd', gs_code)

end event

type rr_1 from roundrectangle within w_sal_04580
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 188
integer width = 4562
integer height = 2132
integer cornerheight = 40
integer cornerwidth = 55
end type

