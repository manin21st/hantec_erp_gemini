$PBExportHeader$w_qct_01700.srw
$PBExportComments$** 이상발생진행현황
forward
global type w_qct_01700 from w_standard_print
end type
type rr_1 from roundrectangle within w_qct_01700
end type
end forward

global type w_qct_01700 from w_standard_print
string title = "이상발생진행현황"
boolean maxbox = true
rr_1 rr_1
end type
global w_qct_01700 w_qct_01700

type variables
string is_gubun
end variables

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();string sdate, edate, sgubun, sdocno, sgijun, sjoch, snull

Setnull(snull)
dw_list.Reset()
dw_print.Reset()

dw_ip.AcceptText()

sdate  = trim(dw_ip.GetItemString(1,'sdate'))
edate  = trim(dw_ip.GetItemString(1,'edate'))
sgubun = trim(dw_ip.GetItemString(1,'gubun'))
sdocno = trim(dw_ip.GetItemString(1,'docno'))
sjoch  = trim(dw_ip.GetItemString(1,'jo'))
sgijun = trim(dw_ip.GetItemString(1,'gijun'))

dw_list.SetFilter("")
dw_list.Filter( )

if (IsNull(sdate) or sdate = "")  then sdate = "11111111"
if (IsNull(edate) or edate = "")  then edate = "99999999"

if dw_ip.getitemstring(1, "gijun") = '1' then
	dw_print.object.txt_ymd.text = String(trim(dw_ip.object.sdate[1]), "@@@@.@@.@@") + " - " + &
	 										 String(trim(dw_ip.object.edate[1]),"@@@@.@@.@@") 
end if

if sgijun = '1' then	
	dw_print.Retrieve(gs_sabu, sdate, edate, sgubun)
	
	if sjoch = "1" then     //조치완료
	   dw_print.SetFilter("Not IsNull(jochdat)")
	   dw_print.Filter( )
   elseif sjoch = "2" then //조치미완료	
	   dw_print.SetFilter("IsNull(jochdat)")
	   dw_print.Filter( )
   end if
	
	if dw_print.rowcount() <= 0 then		
		f_message_chk(50,'[진행현황]')
		dw_list.Reset()
		dw_ip.SetFocus()
	end if
else	
	if (IsNull(sdocno) or sdocno = "")  then 
		f_message_chk(30, "[문서번호]")
		dw_list.Reset()
		dw_ip.setcolumn('docno')
		dw_ip.SetFocus()
		dw_print.insertrow(0)
		dw_print.ShareData(dw_list)
		return -1
	end if
	
	dw_print.Retrieve(gs_sabu, sdocno, sgubun)
	if sjoch = "1" then     //조치완료
	   dw_print.SetFilter("Not IsNull(jochdat)")
	   dw_print.Filter( )
   elseif sjoch = "2" then //조치미완료	
	   dw_print.SetFilter("IsNull(jochdat)")
	   dw_print.Filter( )
   end if
	
	if dw_print.rowcount() <= 0 then
		f_message_chk(50,'[보고서]')
		dw_list.Reset()
		dw_ip.SetFocus()
		dw_print.insertrow(0)
	end if	
end if

dw_print.ShareData(dw_list)

if sjoch = "1" then     //조치완료
	dw_list.SetFilter("Not IsNull(jochdat)")
	dw_list.Filter( )
	if sgijun = '2' then	
		if dw_list.rowcount() <= 0 then
			dw_list.insertrow(0)
		end if	
	end if	
elseif sjoch = "2" then //조치미완료	
	dw_list.SetFilter("IsNull(jochdat)")
	dw_list.Filter( )
	if sgijun = '2' then	
   	if dw_list.rowcount() <= 0 then
	   	dw_list.insertrow(0)
	   end if	
	end if	
end if

return 1
end function

on w_qct_01700.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_qct_01700.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'sdate',left(f_today(),6) + '01' ) 
dw_ip.setitem(1,'edate',left(f_today(),8))
is_gubun = '1'
end event

type p_preview from w_standard_print`p_preview within w_qct_01700
integer y = 28
end type

type p_exit from w_standard_print`p_exit within w_qct_01700
integer y = 28
end type

type p_print from w_standard_print`p_print within w_qct_01700
integer y = 28
end type

type p_retrieve from w_standard_print`p_retrieve within w_qct_01700
integer y = 28
end type







type st_10 from w_standard_print`st_10 within w_qct_01700
end type



type dw_print from w_standard_print`dw_print within w_qct_01700
integer x = 3511
integer y = 48
integer width = 206
integer height = 156
string dataobject = "d_qct_01700_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_01700
integer x = 23
integer y = 20
integer width = 2519
integer height = 296
string dataobject = "d_qct_01700_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String  s_cod, s_nam1, s_nam2
integer i_rtn

if this.GetColumnName() = "docno" then  //문서번호
   s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then return
	 select gubun
	  into :s_nam1
	  from occrpt
	 where sabu = :gs_sabu and occjpno = :s_cod;
	if sqlca.sqlcode <> 0 then
		f_message_chk(33, "[문서번호]")
		this.object.docno[1] = ""
		return 1
	end if		
elseif this.GetColumnName() = "gijun" then 
	s_cod = Trim(this.GetText())
	if IsNull(s_cod) or s_cod = "" then return 
	if s_cod = '1' then
		is_gubun = '1'
	   dw_list.dataobject  = 'd_qct_01700_02'
	   dw_print.dataobject = 'd_qct_01700_02_p'
		dw_list.settransobject(sqlca)
      dw_print.settransobject(sqlca)
	else
		is_gubun = '2'
		dw_list.dataobject  = 'd_qct_01548_01'	
		dw_print.dataobject = 'd_qct_01548_01'	
		dw_list.settransobject(sqlca)
      dw_print.settransobject(sqlca)
		dw_print.insertrow(0)
		dw_list.insertrow(0)
	end if	
elseif this.GetColumnName() = "sdate" then 
	s_cod = Trim(this.GetText())
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




end event

event dw_ip::rbuttondown;setnull(gs_code)

if this.getcolumnname() = "docno" then //문서번호
	open(w_occjpno_popup)
	
	if gs_code = '' or isnull(gs_code) then return 
	
   this.object.docno[1] = gs_code
	this.triggerevent(itemchanged!)
end if
end event

type dw_list from w_standard_print`dw_list within w_qct_01700
integer x = 41
integer y = 348
integer width = 4567
integer height = 1928
string dataobject = "d_qct_01700_02"
boolean border = false
end type

event dw_list::rowfocuschanged;if is_gubun = '1' then
	if currentrow <=0 then return
	
	this.SelectRow(0,False)
	this.SelectRow(currentrow,True)
end if	
end event

event dw_list::clicked;if is_gubun = '1' then
	if row <=0 then return
	
	this.SelectRow(0,False)
	this.SelectRow(row,True)
end if	
end event

type rr_1 from roundrectangle within w_qct_01700
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 332
integer width = 4599
integer height = 1960
integer cornerheight = 40
integer cornerwidth = 55
end type

