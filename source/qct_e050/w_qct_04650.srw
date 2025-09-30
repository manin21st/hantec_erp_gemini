$PBExportHeader$w_qct_04650.srw
$PBExportComments$**시리즈별A/S발생집계표
forward
global type w_qct_04650 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_04650
end type
end forward

global type w_qct_04650 from w_standard_print
string title = "시리즈별 A/S 발생 집계표"
rr_1 rr_1
end type
global w_qct_04650 w_qct_04650

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  sdate, edate, cym, pym, pym11, pym22, rcvlog, s_gu, lotno1, lotno2, ssilgu, sgubun
string  sxym11, sxym22, srcvlog

if dw_ip.AcceptText() = -1 then
   dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
rcvlog = trim(dw_ip.object.rcvlog[1])
lotno1 = trim(dw_ip.object.lotno1[1])
lotno2 = trim(dw_ip.object.lotno2[1])
ssilgu = trim(dw_ip.object.silgu[1])

if isnull(rcvlog) or rcvlog = '' then
	s_gu = "전체"
	srcvlog = '%'
else
	s_gu = Trim(dw_ip.Describe("Evaluate('LookUpDisplay(rcvlog) ', 1)"))
	srcvlog = rcvlog
end if	

if ssilgu = '1' then
	cym = mid(sDate, 1, 6)
	pym = f_aftermonth(Mid(sDate, 1, 6), -5)
	
	pym22 = f_aftermonth(cym,   	-1)
	pym11 = f_aftermonth(pym22,   -5)	
	
else
	cym = mid(sdate, 1, 6)
	pym = mid(edate, 1, 6)	
	
	pym22 = f_aftermonth(cym,   	-1)
	pym11 = f_aftermonth(cym,     -1)	
	
End if

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"
if (IsNull(lotno1) or lotno1 = "")  then lotno1 = "."
if (IsNull(lotno2) or lotno2 = "")  then lotno2 = "ZZZZZZZZZZ"

sxym11 = f_aftermonth(left(sdate, 6), -1) + '01'
sxym22 = f_aftermonth(left(sdate, 6), -1) + '99'

dw_list.SetReDraw(False)

//dw_list.object.txt_ymd.text = String(sdate,"@@@@.@@.@@") + " - " + String(edate,"@@@@.@@.@@")
//dw_list.object.txt_gu.text = s_gu
//dw_list.object.txt_lotno.text = lotno1 + " - " + lotno2

if sSilgu = '1' then
	//dw_list.object.siltext.text = '6개월평균'
	sgubun = '1'
else
	//dw_list.object.siltext.text = '접수기간'
	sgubun = '2'	
end if

IF dw_print.Retrieve(gs_sabu, sdate, edate, cym, pym, pym11, pym22, lotno1, lotno2, sgubun, &
						  srcvlog, sxym11, sxym22) <= 0 then
	f_message_chk(50,'[시리즈별 A/S 발생 집계표]')
	dw_list.Reset()
	dw_ip.SetFocus()
   dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

dw_list.SetReDraw(True)

return 1

end function

on w_qct_04650.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_04650.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_qct_04650
end type

type p_exit from w_standard_print`p_exit within w_qct_04650
end type

type p_print from w_standard_print`p_print within w_qct_04650
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_04650
end type







type st_10 from w_standard_print`st_10 within w_qct_04650
end type



type dw_print from w_standard_print`dw_print within w_qct_04650
string dataobject = "d_qct_04650_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_04650
integer x = 91
integer y = 36
integer width = 2633
integer height = 212
string dataobject = "d_qct_04650_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;call super::itemchanged;String  s_cod

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
end if

return
end event

type dw_list from w_standard_print`dw_list within w_qct_04650
integer x = 101
integer y = 264
integer width = 4453
integer height = 2040
string dataobject = "d_qct_04650_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_qct_04650
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 91
integer y = 256
integer width = 4480
integer height = 2064
integer cornerheight = 40
integer cornerwidth = 55
end type

