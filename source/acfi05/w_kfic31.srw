$PBExportHeader$w_kfic31.srw
$PBExportComments$회사채발행명세서
forward
global type w_kfic31 from w_standard_print
end type
type rr_1 from roundrectangle within w_kfic31
end type
end forward

global type w_kfic31 from w_standard_print
integer x = 0
integer y = 0
string title = "회사채발행명세서"
rr_1 rr_1
end type
global w_kfic31 w_kfic31

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sCb_Baldate,syy,smm,sdd,symd_text

dw_ip.AcceptText()

sCb_Baldate = Trim(dw_ip.GetItemString(1,"cb_baldate"))

IF sCb_Baldate = "" OR IsNull(sCb_Baldate) THEN
	F_MessageChk(1,'[발행기준일자]')
	dw_ip.SetColumn("Cb_Baldate")
	dw_ip.SetFocus()
	Return -1
ELSE
	IF f_datechk(sCb_Baldate) = -1 THEN
		f_messagechk(23, "")
		dw_ip.SetColumn("Cb_Baldate")
		dw_ip.SetFocus()
		Return -1
	END IF
END IF

//날짜 출력물 헤드에 modify
syy = left(sCb_Baldate, 4)
smm = mid(sCb_Baldate,5,2)
sdd = right(sCb_Baldate,2)
symd_text = syy + '.'+ smm + '.' + sdd

//dw_list.modify("symd.text ='"+symd_text+"'")

dw_print.modify("symd.text ='"+symd_text+"'")

setpointer(hourglass!)

//if dw_list.retrieve(scb_baldate) <= 0 then
//	messagebox("확인","조회한 자료가 없습니다.!!") 
//	return -1
//end if 

IF dw_print.retrieve(scb_baldate) <= 0 then
	dw_list.Reset()
	dw_print.insertrow(0)
//	Return -1
END IF

dw_print.ShareData(dw_list)

dw_ip.SetFocus()
setpointer(arrow!)

Return 1
end function

on w_kfic31.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_kfic31.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_kfic31
end type

type p_exit from w_standard_print`p_exit within w_kfic31
end type

type p_print from w_standard_print`p_print within w_kfic31
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfic31
end type







type st_10 from w_standard_print`st_10 within w_kfic31
end type



type dw_print from w_standard_print`dw_print within w_kfic31
string dataobject = "dw_kfic31_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfic31
integer x = 9
integer y = 44
integer width = 832
integer height = 168
string dataobject = "dw_kfic31_1"
end type

type dw_list from w_standard_print`dw_list within w_kfic31
integer x = 37
integer y = 276
integer width = 4562
integer height = 2044
string dataobject = "dw_kfic31"
boolean border = false
end type

type rr_1 from roundrectangle within w_kfic31
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 260
integer width = 4613
integer height = 2084
integer cornerheight = 40
integer cornerwidth = 55
end type

