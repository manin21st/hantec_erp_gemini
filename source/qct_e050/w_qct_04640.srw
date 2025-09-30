$PBExportHeader$w_qct_04640.srw
$PBExportComments$**대리점별A/S접수순위
forward
global type w_qct_04640 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_04640
end type
end forward

global type w_qct_04640 from w_standard_print
string title = "대리점별 A/S 접수순위"
boolean maxbox = true
rr_1 rr_1
end type
global w_qct_04640 w_qct_04640

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string  sdate, edate, pym, cym, gubun
integer rank
Long    i, j

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sdate = trim(dw_ip.object.sdate[1])
edate = trim(dw_ip.object.edate[1])
rank = dw_ip.object.rank[1]
cym = Mid(f_today(),1,6)
pym = f_aftermonth(cym, -5)
gubun = dw_ip.object.gubun[1]

if rank < 1 or rank > 9999 then
   f_message_chk(34,"[순위 : 1 - 9999]")
	dw_ip.SetColumn("rank")
	dw_ip.SetFocus()
	return -1
end if

if (IsNull(sdate) or sdate = "")  then sdate = "10000101"
if (IsNull(edate) or edate = "")  then edate = "99991231"


if gubun = '1' then 
	IF dw_print.Retrieve(gs_sabu, sdate, edate, pym, cym) <= 0 then
		f_message_chk(50,'[ 대리점별 A/S 접수 순위 ]')
		dw_list.Reset()
		dw_ip.SetFocus()
		dw_list.SetRedraw(true)
		dw_print.insertrow(0)
//		Return -1
	END IF
else 
	IF dw_print.Retrieve(gs_sabu, sdate, edate ) <= 0 then
		f_message_chk(50,'[ 업체별 A/S 처리 순위 ]')
		dw_list.Reset()
		dw_ip.SetFocus()
		dw_list.SetRedraw(true)
		dw_print.insertrow(0)
//		Return -1
	END IF
end if

dw_print.object.txt_ymd.text = String(sdate,"@@@@.@@.@@") + " - " + String(edate,"@@@@.@@.@@")
dw_print.ShareData(dw_list)

//dw_list.object.txt_ymd.text = String(sdate,"@@@@.@@.@@") + " - " + String(edate,"@@@@.@@.@@")
//
//if gubun = '1' then 
//	if dw_list.Retrieve(gs_sabu, sdate, edate, pym, cym) <= 0 then
//		f_message_chk(50,'[ 대리점별 A/S 접수 순위 ]')
//		dw_ip.Setfocus()
//		return -1
//	end if
//else 
//   if dw_list.Retrieve(gs_sabu, sdate, edate ) <= 0 then
//		f_message_chk(50,'[ 업체별 A/S 처리 순위 ]')
//		dw_ip.Setfocus()
//		return -1
//	end if
//end if

dw_list.SetReDraw(False)
dw_list.object.rank[1] = 1

IF gubun = '1' then
	for i = 2 to dw_list.RowCount()
		j = i - 1
		if dw_list.object.asqty[i] = dw_list.object.asqty[j] then
			dw_list.object.rank[i] = dw_list.object.rank[j]
		else
			dw_list.object.rank[i] = i
		end if
		if dw_list.object.rank[i] > rank then 
			j = i
			Exit
		end if	
	next	
else
	for i= 2 to dw_list.Rowcount()
	    dw_list.object.rank[i] = i
   next
end if


For i = 1 to dw_list.rowcount()
	if  dw_list.object.rank[i] = 0 or dw_list.object.rank[i] > rank then 
	    dw_list.DeleteRow(i)		
		 i = i - 1
	end if
Next

dw_list.SetReDraw(True)

return 1
end function

on w_qct_04640.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_04640.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_qct_04640
end type

type p_exit from w_standard_print`p_exit within w_qct_04640
end type

type p_print from w_standard_print`p_print within w_qct_04640
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_04640
end type







type st_10 from w_standard_print`st_10 within w_qct_04640
end type



type dw_print from w_standard_print`dw_print within w_qct_04640
string dataobject = "d_qct_04640_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_04640
integer x = 101
integer y = 64
integer width = 2693
integer height = 152
string dataobject = "d_qct_04640_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod

this.AcceptText() 

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

elseif this.GetColumnName() = "gubun" then 
	if s_cod = '1' then
		dw_list.DataObject = "d_qct_04640_02" 
		dw_print.DataObject = "d_qct_04640_02_p" 
	else 
	   dw_list.DataObject = "d_qct_04640_03"      
		dw_print.DataObject = "d_qct_04640_03_p" 
	end if
   dw_list.settransobject(sqlca)	
   dw_print.settransobject(sqlca)	
end if

return
end event

type dw_list from w_standard_print`dw_list within w_qct_04640
integer x = 137
integer y = 240
integer width = 4366
integer height = 2052
string dataobject = "d_qct_04640_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_qct_04640
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 110
integer y = 228
integer width = 4411
integer height = 2080
integer cornerheight = 40
integer cornerwidth = 55
end type

