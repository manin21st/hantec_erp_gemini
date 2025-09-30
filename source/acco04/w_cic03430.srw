$PBExportHeader$w_cic03430.srw
$PBExportComments$품목별 매출총원가
forward
global type w_cic03430 from w_standard_print
end type
type rr_1 from roundrectangle within w_cic03430
end type
end forward

global type w_cic03430 from w_standard_print
string title = "품목별 매출총원가"
rr_1 rr_1
end type
global w_cic03430 w_cic03430

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sWorkym, sToym, sGubn

dw_ip.Accepttext()

sWorkym = dw_ip.GetItemString(1,"workym")
sToym = dw_ip.GetItemString(1,"toym")
sGubn = dw_ip.GetItemString(1,"gubn")

if isnull(sWorkym) or sWorkym = '' then
	messagebox("확인","조회년월을 입력하세요.")
	dw_ip.SetColumn("workym")
	dw_ip.SetFocus()
	return 1
end if

sToym = dw_ip.GetItemString(1,"toym")
if isnull(sToym) or sToym = '' then
	messagebox("확인","조회년월을 입력하세요.")
	dw_ip.SetColumn("toym")
	dw_ip.SetFocus()
	return 1
end if

if sToym < sWorkym  then
	messagebox("확인","조회 범위를 확인하세요.")
	dw_ip.SetColumn("toym")
	dw_ip.SetFocus()
	return 1
end if

if isnull(sGubn) or sGubn = '' then
	sGubn = '%'
end if

dw_print.Object.hworkym_t.Text = String(sWorkym, '@@@@.@@') + '  -  ' + String(sToym, '@@@@.@@')

if dw_print.retrieve(sWorkym,sGubn,sToym) < 1 then
	messagebox("확인","조건에 해당하는 자료가 없습니다.")
	dw_ip.SetColumn("workym")
	dw_ip.SetFocus()	
end if

dw_print.sharedata(dw_list)
Return 1

end function

on w_cic03430.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_cic03430.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;String sWorkym

SELECT  nvl(max(workym),substr(to_char(sysdate,'yyyymmdd'),1,6))
   INTO  :sWorkym
   FROM  cic0100;
	
//dw_ip.SetItem(1, 'workym', f_aftermonth( Left(f_today(),6), -1))
//dw_ip.SetItem(1, 'toym', f_aftermonth( Left(f_today(),6), -1))

dw_ip.SetItem(1, 'workym', sWorkym)
dw_ip.SetItem(1, 'toym',  sWorkym   )


end event

type p_xls from w_standard_print`p_xls within w_cic03430
end type

type p_sort from w_standard_print`p_sort within w_cic03430
end type

type p_preview from w_standard_print`p_preview within w_cic03430
end type

type p_exit from w_standard_print`p_exit within w_cic03430
end type

type p_print from w_standard_print`p_print within w_cic03430
end type

type p_retrieve from w_standard_print`p_retrieve within w_cic03430
end type

event p_retrieve::clicked;IF wf_retrieve() = -1 THEN
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
	SetPointer(Arrow!)
	Return
Else
	p_print.Enabled =True
	p_print.PictureName =  'C:\erpman\image\인쇄_up.gif'
	p_preview.enabled = true
	p_preview.PictureName = 'C:\erpman\image\미리보기_up.gif'
END IF
dw_list.scrolltorow(1)
dw_list.SetFocus()
SetPointer(Arrow!)	
end event







type st_10 from w_standard_print`st_10 within w_cic03430
end type



type dw_print from w_standard_print`dw_print within w_cic03430
integer y = 48
string dataobject = "d_cic03430_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_cic03430
integer y = 28
integer width = 2976
integer height = 200
string dataobject = "d_cic03430_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string ls_status

dw_ip.accepttext()

if this.GetColumnName() = "status" then	
	ls_status = this.GetText()
	
	if ls_status = '1' then
		dw_list.DataObject = "d_cic03430_2"
		dw_print.DataObject = "d_cic03430_2_p"
		dw_list.SetTransobject(sqlca)
		dw_print.SetTransobject(sqlca)
	else
		dw_list.DataObject = "d_cic03430_3"
		dw_print.DataObject = "d_cic03430_3_p"
		dw_list.SetTransobject(sqlca)
		dw_print.SetTransobject(sqlca)
	end if
end if
		

end event

type dw_list from w_standard_print`dw_list within w_cic03430
integer x = 64
integer y = 264
integer width = 4526
integer height = 1892
string dataobject = "d_cic03430_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_cic03430
long linecolor = 28144969
integer linethickness = 4
long fillcolor = 32106727
integer x = 46
integer y = 252
integer width = 4567
integer height = 1948
integer cornerheight = 40
integer cornerwidth = 55
end type

