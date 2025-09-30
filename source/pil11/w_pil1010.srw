$PBExportHeader$w_pil1010.srw
$PBExportComments$월상환내역출력(출력)
forward
global type w_pil1010 from w_standard_print
end type
type rr_1 from roundrectangle within w_pil1010
end type
end forward

global type w_pil1010 from w_standard_print
integer x = 0
integer y = 0
string title = "상환내역 출력"
rr_1 rr_1
end type
global w_pil1010 w_pil1010

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();int row
string ls_lenddate, ls_lenddate1, ls_paygbn, ls_restdate

if dw_ip.AcceptText() = -1 then return -1

row = dw_ip.GetRow()

If row <= 0 Then Return -1

ls_lenddate = Trim(dw_ip.GetItemString(row,'lenddate'))
ls_lenddate1 = trim(dw_ip.getitemstring(row, 'lenddate1'))
ls_paygbn   = Trim(dw_ip.GetItemString(row,'paygbn'))
ls_restdate = Trim(dw_ip.GetItemString(row,'restdate'))

//dw_list.object.t_lenddate.text = string(ls_lenddate, '@@@@.@@')
//dw_list.object.t_lenddate1.text = string(ls_lenddate1, '@@@@.@@')

if ls_paygbn = 'A' then
	ls_paygbn = '%'
end if

dw_list.setredraw(false)

If dw_print.Retrieve(ls_lenddate,ls_lenddate1, ls_paygbn, ls_restdate) < 1 then
   messagebox("자료 확인", "해당 자료가 없습니다.!", stopsign!)
   dw_list.setredraw(true)	
   p_print.enabled = false		
  	return -1
End if	
dw_print.setredraw(true)	

//cb_print.enabled = true
return 1

end function

on w_pil1010.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pil1010.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;w_mdi_frame.sle_msg.text=""
w_mdi_frame.sle_msg.text = "출력물 - 용지크기 : A4, 출력방향 : 세로방향"
dw_ip.SetTransObject(sqlca)
dw_list.SetTransObject(sqlca)

dw_ip.reset()
dw_ip.insertrow(0)
dw_ip.setItem(1, 'lenddate', string(today(),'yyyymm'))
dw_ip.setItem(1, 'lenddate1', string(today(),'yyyymm'))
dw_ip.setItem(1, 'restdate', string(today(),'yyyymmdd'))
dw_ip.setcolumn('lenddate')
end event

type p_preview from w_standard_print`p_preview within w_pil1010
end type

event p_preview::clicked;string ls_lenddate, ls_lenddate1, ls_paygbn, ls_restdate

if dw_ip.AcceptText() = -1 then return -1

ls_lenddate = Trim(dw_ip.GetItemString(1,'lenddate'))
ls_lenddate1 = trim(dw_ip.getitemstring(1, 'lenddate1'))
ls_paygbn   = Trim(dw_ip.GetItemString(1,'paygbn'))
ls_restdate = Trim(dw_ip.GetItemString(1,'restdate'))

dw_print.object.t_lenddate.text = string(ls_lenddate, '@@@@.@@')
dw_print.object.t_lenddate1.text = string(ls_lenddate1, '@@@@.@@')

if ls_paygbn = 'A' then
	ls_paygbn = '%'
end if

dw_print.Retrieve(ls_lenddate,ls_lenddate1, ls_paygbn, ls_restdate) 

OpenWithParm(w_print_preview, dw_print)	
end event

type p_exit from w_standard_print`p_exit within w_pil1010
end type

type p_print from w_standard_print`p_print within w_pil1010
end type

event p_print::clicked;string ls_lenddate, ls_lenddate1, ls_paygbn, ls_restdate

if dw_ip.AcceptText() = -1 then return -1

ls_lenddate = Trim(dw_ip.GetItemString(1,'lenddate'))
ls_lenddate1 = trim(dw_ip.getitemstring(1, 'lenddate1'))
ls_paygbn   = Trim(dw_ip.GetItemString(1,'paygbn'))
ls_restdate = Trim(dw_ip.GetItemString(1,'restdate'))

dw_print.object.t_lenddate.text = string(ls_lenddate, '@@@@.@@')
dw_print.object.t_lenddate1.text = string(ls_lenddate1, '@@@@.@@')

if ls_paygbn = 'A' then
	ls_paygbn = '%'
end if

dw_print.Retrieve(ls_lenddate,ls_lenddate1, ls_paygbn, ls_restdate) 

IF dw_print.rowcount() > 0 then 
	gi_page = dw_print.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_print)
end event

type p_retrieve from w_standard_print`p_retrieve within w_pil1010
end type

type st_window from w_standard_print`st_window within w_pil1010
boolean visible = false
end type

type sle_msg from w_standard_print`sle_msg within w_pil1010
boolean visible = false
end type

type dw_datetime from w_standard_print`dw_datetime within w_pil1010
boolean visible = false
end type

type st_10 from w_standard_print`st_10 within w_pil1010
boolean visible = false
end type

type gb_10 from w_standard_print`gb_10 within w_pil1010
boolean visible = false
end type

type dw_print from w_standard_print`dw_print within w_pil1010
integer x = 3726
integer y = 40
string dataobject = "d_pil1010_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pil1010
integer x = 594
integer y = 44
integer width = 3035
integer height = 192
string dataobject = "d_pil1010_1"
end type

event dw_ip::itemchanged;

Choose Case dwo.name
   Case 'lenddate'
		if isnull(data) or data = "" then return
		If f_datechk(data + "01") = -1 Then
			MessageBox("확 인", "유효한 년월이 아닙니다.")
			Return 1
		end if
	Case 'lenddate1'
		if isnull(data) or data = "" then return
		If f_datechk(data + "01") = -1 Then
			MessageBox("확 인", "유효한 년월이 아닙니다.")
			Return 1
		end if	
   case 'restdate'
		If f_datechk(data) = -1 Then
			MessageBox("확 인", "유효한 일자가 아닙니다.")
			Return 1
		end if
end choose 

end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pil1010
integer x = 626
integer y = 264
integer width = 3118
integer height = 1960
string title = "상환내역출력"
string dataobject = "d_pil1010_2"
boolean border = false
end type

type rr_1 from roundrectangle within w_pil1010
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 603
integer y = 252
integer width = 3168
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

