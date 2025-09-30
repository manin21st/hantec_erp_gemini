$PBExportHeader$w_qct_02551.srw
$PBExportComments$** 제안현황 및 시상내역(요약/상세)
forward
global type w_qct_02551 from w_standard_print
end type
type pb_1 from u_pb_cal within w_qct_02551
end type
type pb_2 from u_pb_cal within w_qct_02551
end type
end forward

global type w_qct_02551 from w_standard_print
string title = "제안현황 및 시상내역"
pb_1 pb_1
pb_2 pb_2
end type
global w_qct_02551 w_qct_02551

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_sdate, ls_edate, sGub, sGub2, simdpt , ls_pgubun
long   lCount

if dw_ip.accepttext() <> 1 then return -1

ls_sdate = Trim(dw_ip.getitemstring(1,'sdate'))
ls_edate = Trim(dw_ip.getitemstring(1,'edate'))
simdpt   = Trim(dw_ip.getitemstring(1,'simdpt'))
sGub     = Trim(dw_ip.getitemstring(1,'jgubun'))
ls_pgubun = Trim(dw_ip.getitemstring(1,'pgubun'))


if ls_sdate = "" or isnull(ls_sdate) then
	f_message_chk(30,'[제안일자 FROM]')
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	return -1
end if

if ls_edate = "" or isnull(ls_edate) then
	f_message_chk(30,'[제안일자 TO]')
	dw_ip.setcolumn('edate')
	dw_ip.setfocus()
	return -1
end if

if simdpt = "" or isnull(simdpt) then simdpt = '%'

//if sgub = '1' then 
//	sGub2    = Trim(dw_ip.getitemstring(1,'gubun')) //심사구분
//	lCount = dw_list.retrieve(gs_sabu, ls_sdate, ls_edate, simdpt, sGub2)
//elseif sgub = '3' then
//	if ls_pgubun = '1' then
//		ls_pgubun = '%' 
//	elseif ls_pgubun = '2' then
//		ls_pgubun = 'Y'
//	else
//		ls_pgubun = 'N'
//	end if
//	lCount = dw_list.retrieve(gs_sabu, ls_sdate, ls_edate, simdpt, ls_pgubun)
//else
//	lCount = dw_list.retrieve(gs_sabu, ls_sdate, ls_edate, simdpt)
//end if
//
//if lCount < 1 then
//	f_message_chk(50,'')
//	dw_ip.setcolumn('sdate')
//	dw_ip.setfocus()
//	return -1
//end if

if sgub = '1' then 
	sGub2    = Trim(dw_ip.getitemstring(1,'gubun')) //심사구분
	lCount = dw_print.retrieve(gs_sabu, ls_sdate, ls_edate, simdpt, sGub2)
elseif sgub = '3' then
	if ls_pgubun = '1' then
		ls_pgubun = '%' 
	elseif ls_pgubun = '2' then
		ls_pgubun = 'Y'
	else
		ls_pgubun = 'N'
	end if
	lCount = dw_print.retrieve(gs_sabu, ls_sdate, ls_edate, simdpt, ls_pgubun)
else
	lCount = dw_print.retrieve(gs_sabu, ls_sdate, ls_edate, simdpt)
end if

if lCount < 1 then
	f_message_chk(50,'제안현황 및 시상내역')
	dw_ip.setcolumn('sdate')
	dw_ip.setfocus()
	dw_print.insertrow(0)
//	return -1
end if

dw_print.ShareData(dw_list)

return 1

end function

on w_qct_02551.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_qct_02551.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event open;call super::open;dw_ip.setitem(1,'sdate',left(f_today(),6) + '01' )
dw_ip.setitem(1,'edate',left(f_today(),8))
end event

type p_preview from w_standard_print`p_preview within w_qct_02551
end type

type p_exit from w_standard_print`p_exit within w_qct_02551
end type

type p_print from w_standard_print`p_print within w_qct_02551
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_02551
end type







type st_10 from w_standard_print`st_10 within w_qct_02551
end type



type dw_print from w_standard_print`dw_print within w_qct_02551
string dataobject = "d_qct_02551_0"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_02551
integer width = 3127
integer height = 236
string dataobject = "d_qct_02551"
end type

event dw_ip::itemchanged;string ls_sdate, ls_edate, snull, ls_jgubun

setnull(snull)

Choose Case GetColumnName()
	Case"sdate"
	   ls_sdate = Trim(this.GetText())
	
	   IF ls_sdate ="" OR IsNull(ls_sdate) THEN RETURN
	
		IF f_datechk(ls_sdate) = -1 THEN
			f_message_chk(35,'[제안일자 FROM]')
			this.SetItem(1,"sdate",snull)
			Return 1
		END IF
	Case"edate"
	   ls_edate = Trim(this.GetText())
	
	   IF ls_edate ="" OR IsNull(ls_edate) THEN RETURN
	
		IF f_datechk(ls_edate) = -1 THEN
			f_message_chk(35,'[제안일자 TO]')
			this.SetItem(1,"edate",snull)
			Return 1
		END IF
	Case 'jgubun'
		ls_jgubun = trim(gettext())

      if ls_jgubun = '0' then
			dw_list.dataobject = 'd_qct_02551_0'
			dw_print.dataobject = 'd_qct_02551_0'
      elseif ls_jgubun = '1' then
			dw_list.dataobject = 'd_qct_02551_1'
			dw_print.dataobject = 'd_qct_02551_1'
		elseif ls_jgubun ='2' then
			dw_list.dataobject = 'd_qct_02551_2'
			dw_print.dataobject = 'd_qct_02551_2'
		elseif ls_jgubun ='3' then
			dw_list.dataobject = 'd_qct_02551_3'
			dw_print.dataobject = 'd_qct_02551_3'
		end if
		dw_list.settransobject(sqlca)
		dw_print.settransobject(sqlca)
		
		p_print.Enabled =False
		p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	
		p_preview.enabled = False
		p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
End Choose

end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_qct_02551
string dataobject = "d_qct_02551_0"
end type

type pb_1 from u_pb_cal within w_qct_02551
integer x = 357
integer y = 80
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_02551
integer x = 809
integer y = 80
integer taborder = 50
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

