$PBExportHeader$w_ktxa30.srw
$PBExportComments$부가세 신고 명세서 조회출력
forward
global type w_ktxa30 from w_standard_print
end type
type rr_1 from roundrectangle within w_ktxa30
end type
end forward

global type w_ktxa30 from w_standard_print
string title = "부가세 신고 명세서"
rr_1 rr_1
end type
global w_ktxa30 w_ktxa30

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string ls_io, ls_sdate, ls_edate, ls_jasa, ls_text

if dw_ip.accepttext() = -1 then return -1

ls_io = dw_ip.getitemstring(1, "sselect_gu")
ls_sdate = dw_ip.getitemstring(1, "datef")
ls_edate = dw_ip.getitemstring(1, "datet")
ls_jasa = dw_ip.getitemstring(1, "sjasa")

if ls_jasa = "" or isnull(ls_jasa) then
	ls_jasa = '%'
end if

//if f_datechk(ls_sdate) = -1 or f_datechk(ls_edate) = -1 then
//	messagebox("확  인", "부가세일자를 확인하세요.")
//	dw_ip.setfocus()
//	return -1
//end if
//
//IF DaysAfter(Date(Left(ls_sdate,4)+"/"+Mid(ls_sdate,5,2)+"/"+Right(ls_sdate,2)),&
//				 Date(Left(ls_edate,4)+"/"+Mid(ls_edate,5,2)+"/"+Right(ls_edate,2))) < 0 THEN
//	MessageBox("확  인","날짜 범위가 잘못 지정되었습니다. 확인하세요.!!!")
//	dw_ip.SetColumn("sdate")
//	dw_ip.SetFocus()
//	Return -1
//END IF

ls_text = mid(ls_sdate, 5, 2)

dw_list.object.t_11.text = ls_text + ' 월'
dw_list.object.t_12.text = string(long(ls_text) + 1, '00') + ' 월'
dw_list.object.t_13.text = string(long(ls_text) + 2, '00') + ' 월'

if dw_print.retrieve(ls_io, ls_sdate, ls_edate, ls_jasa) < 1 then
	f_messagechk(14, "")
	dw_ip.setfocus()
	return -1
end if

return 1
end function

on w_ktxa30.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_ktxa30.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;
dw_ip.SetItem(dw_ip.Getrow(),"sselect_gu",'1')

dw_ip.SetColumn("vatgisu")
dw_ip.SetFocus()
end event

type p_preview from w_standard_print`p_preview within w_ktxa30
integer taborder = 40
end type

type p_exit from w_standard_print`p_exit within w_ktxa30
integer taborder = 60
end type

type p_print from w_standard_print`p_print within w_ktxa30
integer taborder = 50
end type

type p_retrieve from w_standard_print`p_retrieve within w_ktxa30
integer taborder = 20
end type







type st_10 from w_standard_print`st_10 within w_ktxa30
end type



type dw_print from w_standard_print`dw_print within w_ktxa30
integer x = 3575
integer y = 132
string dataobject = "d_ktxa30_2_p"
end type

type dw_ip from w_standard_print`dw_ip within w_ktxa30
integer y = 28
integer width = 3849
integer height = 148
integer taborder = 10
string dataobject = "d_ktxa30_1"
end type

event dw_ip::itemchanged;call super::itemchanged;string svatgisu, sjasacode, sStartDate, sEndDate, snull

setnull(snull)

IF this.GetColumnName() = "vatgisu" THEN
	sVatGiSu = this.GetText()
	IF sVatGisu = "" OR IsNull(sVatGiSu) THEN Return
	
	IF IsNull(F_Get_Refferance('AV',sVatGiSu)) THEN
		F_MessageChk(20,'[부가세기수]')
		this.SetItem(this.getrow(),"vatgisu",snull)
		Return 1
	ELSE
		SELECT SUBSTR("REFFPF"."RFNA2",1,4),SUBSTR("REFFPF"."RFNA2",5,4)   
    		INTO :sStartDate,						:sEndDate  
		   FROM "REFFPF"  
   		WHERE ( "REFFPF"."RFCOD" = 'AV' AND  
         		 "REFFPF"."RFGUB" = :sVatGisu )   ;
		this.SetItem(this.getrow(),"datef",Left(f_Today(),4)+sStartDate)
		this.SetItem(this.getrow(),"datet",Left(f_Today(),4)+sEndDate)
	END IF
END IF


end event

event dw_ip::itemerror;call super::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_ktxa30
integer x = 55
integer y = 188
integer width = 4544
integer height = 2036
integer taborder = 30
string dataobject = "d_ktxa30_2"
boolean border = false
end type

event dw_list::rowfocuschanged;call super::rowfocuschanged;
IF currentrow <=0 then return

selectRow(0,False)
selectrow(currentrow,True)
end event
event dw_list::clicked;call super::clicked;IF row <=0 then return

selectRow(0,False)
selectrow(row,True)
end event
type rr_1 from roundrectangle within w_ktxa30
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 180
integer width = 4567
integer height = 2056
integer cornerheight = 40
integer cornerwidth = 55
end type

