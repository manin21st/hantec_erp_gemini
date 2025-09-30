$PBExportHeader$w_qct_06650.srw
$PBExportComments$** 품질화일
forward
global type w_qct_06650 from w_standard_print
end type
type rr_2 from roundrectangle within w_qct_06650
end type
end forward

global type w_qct_06650 from w_standard_print
string title = "품질화일"
rr_2 rr_2
end type
global w_qct_06650 w_qct_06650

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string gubun, sym, eym, itnbr, itdsc
Long i, j, cnt

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

gubun = Trim(dw_ip.object.gubun[1])
sym = Trim(dw_ip.object.sym[1])
eym = Trim(dw_ip.object.eym[1])
itnbr = Trim(dw_ip.object.itnbr[1])
itdsc = Trim(dw_ip.object.itdsc[1])

if (IsNull(sym) or sym = "")  then sym = "100001"
if (IsNull(eym) or eym = "")  then eym = "999912"

//if (IsNull(itnbr) or itnbr = "")  then 
//	f_message_chk(30, "[품번]")
//	dw_ip.SetColumn("itnbr")
//	dw_ip.Setfocus()
//	return -1
//end if

if gubun <> Mid(itnbr,1,1) then
	MessageBox("품번 확인", "검색구분에 해당하는 품번을 입력하세요!")
	return -1
end if	

if gubun = "1" then //검색구분 = 완제품
   dw_list.DataObject = "d_qct_06650_02"
	dw_print.DataObject = "d_qct_06650_02_p"
elseif gubun = "2" then //검색구분 = 완제품
   dw_list.DataObject = "d_qct_06650_03"
	dw_print.DataObject = "d_qct_06650_03_p"
elseif gubun = "3" then //검색구분 = 완제품
   dw_list.DataObject = "d_qct_06650_04"
	dw_print.DataObject = "d_qct_06650_04_p"
end if

dw_list.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

//dw_list.object.txt_ymd.text = String(sym,"@@@@년@@월 - ") + String(eym,"@@@@년@@월") 

//if dw_list.Retrieve(gs_sabu, sym, eym, itnbr) <= 0 then
//	f_message_chk(50,'[품질화일]')
//	dw_ip.Setfocus()
//	return -1
//end if

IF dw_print.Retrieve(gs_sabu, sym, eym, itnbr) <= 0 then
	f_message_chk(50,'[품질화일]')
	dw_list.Reset()
	dw_ip.SetFocus()
	dw_list.SetRedraw(true)
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

dw_list.SetRedraw(False)
cnt = 1
dw_list.object.cnt[1] = cnt
for i = 2 to dw_list.RowCount()
	j = i - 1
	if not((dw_list.object.gubun[i] = dw_list.object.gubun[j]) and &
	       (dw_list.object.dat[i] = dw_list.object.dat[j]) and &
		    (dw_list.object.itdsc1[i] = dw_list.object.itdsc1[j]) and &
		    (dw_list.object.itdsc2[i] = dw_list.object.itdsc2[j])) then
		cnt = cnt + 1
		dw_list.object.cnt[i] = cnt
	end if	
next
dw_list.SetRedraw(True)

return 1
end function

on w_qct_06650.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_qct_06650.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

type p_preview from w_standard_print`p_preview within w_qct_06650
integer x = 4059
end type

type p_exit from w_standard_print`p_exit within w_qct_06650
integer x = 4407
end type

type p_print from w_standard_print`p_print within w_qct_06650
integer x = 4233
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_06650
integer x = 3886
end type







type st_10 from w_standard_print`st_10 within w_qct_06650
end type



type dw_print from w_standard_print`dw_print within w_qct_06650
integer x = 3694
string dataobject = "d_qct_06650_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_06650
integer x = 82
integer y = 24
integer width = 3483
integer height = 140
string dataobject = "d_qct_06650_01"
end type

event dw_ip::itemchanged;string  s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())

if this.GetColumnName() = "sym" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[시작년월]")
		this.object.sym[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "eym" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[끝년월]")
		this.object.eym[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "itnbr" then
	i_rtn = f_get_name2("품번", "Y", s_cod, s_nam1, s_nam2)
	this.object.itnbr[1] = s_cod
	this.object.itdsc[1] = s_nam1
	return i_rtn
end if



end event

event dw_ip::itemerror;return 1
end event

event dw_ip::ue_key;call super::ue_key;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

IF keydown(keyF2!) THEN
	if this.GetColumnName() = "itnbr" then
		open(w_itemas_popup2)
		this.object.itnbr[1] = gs_code
		this.object.itdsc[1] = gs_codename
	end if
END IF

return
end event

event dw_ip::rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

if this.GetColumnName() = "itnbr" then
   open(w_itemas_popup)
	if gs_code = '' or isnull(gs_code) then return 
	this.object.itnbr[1] = gs_code
	this.object.itdsc[1] = gs_codename
END IF


end event

type dw_list from w_standard_print`dw_list within w_qct_06650
integer x = 101
integer y = 188
integer width = 4462
integer height = 1976
string dataobject = "d_qct_06650_02"
boolean border = false
end type

type rr_2 from roundrectangle within w_qct_06650
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 87
integer y = 176
integer width = 4494
integer height = 2000
integer cornerheight = 40
integer cornerwidth = 55
end type

