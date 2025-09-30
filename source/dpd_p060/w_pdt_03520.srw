$PBExportHeader$w_pdt_03520.srw
$PBExportComments$** 수주접수 현황
forward
global type w_pdt_03520 from w_standard_print
end type
type rr_1 from roundrectangle within w_pdt_03520
end type
end forward

global type w_pdt_03520 from w_standard_print
string title = "수주접수 현황"
rr_1 rr_1
end type
global w_pdt_03520 w_pdt_03520

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string gubun, ym, yyyy, pymd, cymd, temp, spdtgu, sittyp, sAmtgu
Long i_rtn

SetPointer(HourGlass!)

if dw_ip.AcceptText() = -1 then
	dw_ip.SetFocus()
	return -1
end if	

gubun = Trim(dw_ip.object.gubun[1])

spdtgu = Trim(dw_ip.object.pdtgu[1])
sittyp = Trim(dw_ip.object.ittyp[1])

if spdtgu = '' or isnull(spdtgu) then spdtgu = '%'
if sittyp = '' or isnull(sittyp) then sittyp = '%'

if gubun = "4" then
   yyyy   = Trim(dw_ip.object.yyyy[1])
   samtgu = Trim(dw_ip.object.amtgu[1])
	
   if (IsNull(yyyy) or yyyy = "")  then 
      f_message_chk(30, "[기준년도]")
      dw_ip.SetColumn("yyyy")
      dw_ip.Setfocus()
      return -1
   end if
else	
   ym = Trim(dw_ip.object.ym[1])
   if (IsNull(ym) or ym = "")  then 
      f_message_chk(30, "[기준년월]")
      dw_ip.SetColumn("ym")
      dw_ip.Setfocus()
      return -1
   end if
end if

if gubun = "1" then
   dw_print.object.txt_title.text = String(ym,"@@@@년 @@월") + " 판매실적 및 수주접수현황"
	i_rtn = dw_print.Retrieve(gs_sabu, ym, spdtgu, sittyp)
elseif gubun = "2" then
	dw_print.object.txt_title.text = String(ym,"@@@@년 @@월 수주 미처리금액 현황")
	i_rtn = dw_print.Retrieve(gs_sabu, ym, spdtgu, sittyp)
elseif gubun = "3" then
   cymd = ym
   //수주미처리테이블에서 당월의 마지막 수주일자를 찾아낸다
   select max(order_date) into :temp from order_not_hold
    where order_date like :cymd||'%';
   if sqlca.sqlcode <> 0 then
	   cymd = f_last_date(cymd)
   else	
      cymd = temp
   end if

   //수주미처리테이블에서 전월의 마지막 수주일자를 찾아낸다
   pymd = f_aftermonth(cymd, -1)
   select max(order_date) into :temp from order_not_hold
    where order_date like :pymd||'%';
   if sqlca.sqlcode <> 0 then
	   pymd = f_last_date(pymd)
   else	
      pymd = temp
   end if

   i_rtn = dw_print.Retrieve(gs_sabu, pymd, cymd, spdtgu, sittyp)
elseif gubun = "4" then	
	if sAmtgu = "1" then	
		dw_list.DataObject = "d_pdt_03740_02"
		dw_print.DataObject = "d_pdt_03740_02_p"
		dw_list.SetTransObject(SQLCA)
		dw_print.SetTransObject(SQLCA)
		dw_print.object.txt_title.text = String(yyyy,"@@@@년 월말 기준 수주미처리금액 현황")
	else
		dw_list.DataObject = "d_pdt_03740_05"
		dw_list.SetTransObject(SQLCA)
		dw_print.DataObject = "d_pdt_03740_05"
		dw_print.SetTransObject(SQLCA)
		dw_print.object.txt_title.text = String(yyyy,"@@@@년 월말 기준 수주미처리금액(가중치) 현황")
	end if	
	
   i_rtn = dw_print.Retrieve(gs_sabu, yyyy, spdtgu, sittyp)
end if

if i_rtn <= 0 then
	f_message_chk(50,'')
	dw_ip.Setfocus()
	return -1
end if

dw_print.sharedata(dw_list)
return 1
end function

on w_pdt_03520.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdt_03520.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

type p_preview from w_standard_print`p_preview within w_pdt_03520
end type

type p_exit from w_standard_print`p_exit within w_pdt_03520
end type

type p_print from w_standard_print`p_print within w_pdt_03520
end type

type p_retrieve from w_standard_print`p_retrieve within w_pdt_03520
end type







type st_10 from w_standard_print`st_10 within w_pdt_03520
end type



type dw_print from w_standard_print`dw_print within w_pdt_03520
string dataobject = "d_pdt_03520_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_pdt_03520
integer x = 73
integer y = 32
integer width = 2423
integer height = 336
integer taborder = 20
string dataobject = "d_pdt_03520_00"
end type

event dw_ip::itemchanged;String gubun

gubun = Trim(this.GetText())

if this.GetColumnName() = "ym" then
	if f_datechk(gubun + '01') = -1 then
		f_message_chk(35, "[기준년월]")
		this.object.ym[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "yyyy" then
	if f_datechk(gubun + '0101') = -1 then
		f_message_chk(35, "[기준년도]")
		this.object.yyyy[1] = ""
		return 1
	end if
elseif this.GetColumnName() = "gubun" then
	dw_print.SetReDraw(False)
	if gubun = "1" then //월 판매실적 및 수주접수 현황	 
		dw_list.DataObject = "d_pdt_03520_02"
	   dw_print.DataObject = "d_pdt_03520_02_p"
   elseif gubun = "2" then	//월별 수주 미처리 금액 현황
		dw_list.DataObject = "d_pdt_03550_03"
	   dw_print.DataObject = "d_pdt_03550_03" 
   elseif gubun = "3" then	//수주 미처리 현황 
		dw_list.DataObject = "d_pdt_03600_02"
	   dw_print.DataObject = "d_pdt_03600_02"
   elseif gubun = "4" then	//월말기준 수주 미처리금액(가중치)현황
		dw_list.DataObject = "d_pdt_03740_02"
	   dw_print.DataObject = "d_pdt_03740_02"
   end if	
	
	dw_list.SetTransObject(SQLCA)
	dw_print.SetReDraw(True)
	
	p_print.Enabled =False
	p_print.PictureName = 'C:\erpman\image\인쇄_d.gif'

	p_preview.enabled = False
	p_preview.PictureName = 'C:\erpman\image\미리보기_d.gif'
end if



end event

event dw_ip::itemerror;return 1
end event

type dw_list from w_standard_print`dw_list within w_pdt_03520
integer x = 87
integer y = 392
integer width = 4512
integer height = 1908
string dataobject = "d_pdt_03520_02"
boolean hsplitscroll = false
end type

type rr_1 from roundrectangle within w_pdt_03520
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 73
integer y = 384
integer width = 4539
integer height = 1924
integer cornerheight = 40
integer cornerwidth = 55
end type

