$PBExportHeader$w_lot_01510.srw
$PBExportComments$** LOT 대장
forward
global type w_lot_01510 from w_standard_print
end type
type rr_2 from roundrectangle within w_lot_01510
end type
end forward

global type w_lot_01510 from w_standard_print
string title = "LOT 대장"
rr_2 rr_2
end type
global w_lot_01510 w_lot_01510

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String yymm, depot, sGub1, sGub2, sitnbr, eitnbr, sMagam_yymm

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

sgub1  = dw_ip.object.gubun[1]
yymm   = trim(dw_ip.object.yymm[1])
depot  = dw_ip.object.depot[1]
sgub2  = dw_ip.object.gubun2[1]
sitnbr  = dw_ip.object.sitnbr[1]
eitnbr  = dw_ip.object.eitnbr[1]

if IsNull(yymm) or yymm = "" then 
   f_message_chk(30, "[마감년월]")
	return -1
end if

if IsNull(depot)  or depot  = "" then depot = "%"
if IsNull(sitnbr) or sitnbr = "" then sitnbr = "."
if IsNull(eitnbr) or eitnbr = "" then eitnbr = "zzzzzzzzzzzzzz"

//최종 마감 년월
  SELECT MAX("JUNPYO_CLOSING"."JPDAT")  
    INTO :sMagam_yymm
    FROM "JUNPYO_CLOSING"  
   WHERE ( "JUNPYO_CLOSING"."SABU" = :gs_sabu ) AND  
         ( "JUNPYO_CLOSING"."JPGU" = 'C0' )   ;

dw_list.SetFilter("")
dw_list.filter()

if sGub1 = '2' then 
	if sGub2 = '1' then //전체
		dw_list.SetFilter("")
	else                //오류
		dw_list.SetFilter("difqty <> 0")
	end if
	dw_list.filter()
end if

if sGub1 = '4' then 
	if sGub2 = '1' then //전체
		dw_list.SetFilter("")
	else                //오류
		dw_list.SetFilter("lotip_ioamt <> 0")
	end if
	dw_list.filter()
end if

if dw_list.Retrieve(gs_sabu, yymm, depot, sitnbr, eitnbr, sMagam_yymm) < 1 then
	f_message_chk(50, "[LOT관리]")
	dw_ip.Setfocus()
	return -1
end if	

return 1
end function

on w_lot_01510.create
int iCurrent
call super::create
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_2
end on

on w_lot_01510.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_2)
end on

type p_preview from w_standard_print`p_preview within w_lot_01510
end type

type p_exit from w_standard_print`p_exit within w_lot_01510
end type

type p_print from w_standard_print`p_print within w_lot_01510
end type

type p_retrieve from w_standard_print`p_retrieve within w_lot_01510
end type







type st_10 from w_standard_print`st_10 within w_lot_01510
end type



type dw_print from w_standard_print`dw_print within w_lot_01510
integer x = 3968
integer y = 180
string dataobject = "d_lot_01510_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_lot_01510
integer y = 192
integer width = 4311
integer height = 232
string dataobject = "d_lot_01510_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod

s_cod = Trim(this.GetText())

if this.GetColumnName() = "gubun" then
	if s_cod = "1" then 						//LOT대장
	   dw_list.DataObject = "d_lot_01510_02"
   elseif s_cod = "2" then 				//LOT출고이력현황
		dw_list.DataObject = "d_lot_01510_03"
	elseif s_cod = "3" then        		//LOT입고이력현황
		dw_list.DataObject = "d_lot_01510_04"
	else                                //창고별 재고현황
		dw_list.DataObject = "d_lot_01510_05"
	end if
	
	dw_list.SetTransObject(SQLCA)
	
	p_print.Enabled =False
	p_preview.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'

elseif this.GetColumnName() = "yymm" then
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.yymm[1] = ""
		return 1
	end if	
elseif this.GetColumnName() = "gubun2" then
	if s_cod = '1' then //전체
	   dw_list.SetFilter("")
	else                //오류
	   dw_list.SetFilter("difqty <> 0")
	end if
	dw_list.filter()
elseif this.GetColumnName() = "amtgu" then
	if s_cod = '1' then //전체
	   dw_list.SetFilter("")
	else                //오류
	   dw_list.SetFilter("lotip_ioamt <> 0")
	end if
	dw_list.filter()	
end if	

end event

event dw_ip::rbuttondown;call super::rbuttondown;string snull

setnull(snull)
setnull(gs_gubun)
setnull(gs_code)
setnull(gs_codename)

IF this.GetColumnName() ="sitnbr" THEN
	open(w_itemas_popup)
	if gs_code = "" or isnull(gs_code) then	return 

	this.setitem(1, "sitnbr", gs_code)
ELSEIF this.GetColumnName() ="eitnbr" THEN
	open(w_itemas_popup)
	if gs_code = "" or isnull(gs_code) then	return 

	this.setitem(1, "eitnbr", gs_code)
END IF

end event

type dw_list from w_standard_print`dw_list within w_lot_01510
integer x = 50
integer y = 432
integer width = 4539
integer height = 1828
string dataobject = "d_lot_01510_02"
boolean border = false
end type

type rr_2 from roundrectangle within w_lot_01510
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 424
integer width = 4562
integer height = 1848
integer cornerheight = 40
integer cornerwidth = 55
end type

