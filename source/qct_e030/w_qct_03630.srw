$PBExportHeader$w_qct_03630.srw
$PBExportComments$중요업무활동보고서
forward
global type w_qct_03630 from w_standard_print
end type
type dw_as from datawindow within w_qct_03630
end type
type dw_claim from datawindow within w_qct_03630
end type
type pb_1 from u_pb_cal within w_qct_03630
end type
type pb_2 from u_pb_cal within w_qct_03630
end type
type rr_2 from roundrectangle within w_qct_03630
end type
end forward

global type w_qct_03630 from w_standard_print
integer width = 4640
integer height = 2440
string title = "중요업무활동보고서"
dw_as dw_as
dw_claim dw_claim
pb_1 pb_1
pb_2 pb_2
rr_2 rr_2
end type
global w_qct_03630 w_qct_03630

forward prototypes
public function integer wf_claim ()
public function integer wf_retrieve ()
public function integer wf_as ()
end prototypes

public function integer wf_claim ();string ls_cvnas
double ld_cl_count, ld_cl_clqty,  ld_cl_mount , ld_tot_count20 , ld_tot_clqty20, ld_tot_mount20, &
       ld_tot_count, ld_tot_clqty,  ld_tot_mount
integer i


for i= 1 to dw_claim.Rowcount()
      ls_cvnas     = dw_claim.getitemstring( i, "cust_name" ) 
      ld_cl_count  = dw_claim.getitemnumber( i, "cl_count"  )
      ld_cl_clqty  = dw_claim.getitemnumber( i, "cl_clqty"  )
		ld_cl_mount  = dw_claim.getitemnumber( i, "cl_mount" )
		
				
	if i < 20 then 
		dw_list.setitem( i ,  "cl_cvnas" , ls_cvnas ) 
		dw_list.setitem( i ,  "cl_count" , ld_cl_count  )
		dw_list.setitem( i ,  "cl_qty" , ld_cl_clqty  )
		dw_list.setitem( i ,  "cl_amt" , ld_cl_mount )
	end if
	   
	if i >= 20 then
		ld_tot_count20 = ld_tot_count20 + ld_cl_count 
		ld_tot_clqty20 = ld_tot_clqty20 + ld_cl_clqty
		ld_tot_mount20 = ld_tot_mount20 + ld_cl_mount 	   	
	end if
	
	ld_tot_count = ld_tot_count + ld_cl_count 
	ld_tot_clqty = ld_tot_clqty + ld_cl_clqty
	ld_tot_mount = ld_tot_mount + ld_cl_mount
		
next		
   
	
	 
	dw_list.setitem( 20 ,  "cl_count"  , ld_tot_count20  )
	dw_list.setitem( 20 ,  "cl_qty"    , ld_tot_clqty20 )
	dw_list.setitem( 20 ,  "cl_amt"    , ld_tot_mount20 )
	
	dw_list.setitem( 21 ,  "cl_count"  , ld_tot_count  )
	dw_list.setitem( 21 ,  "cl_qty"    , ld_tot_clqty )
	dw_list.setitem( 21 ,  "cl_amt"    , ld_tot_mount )
		
		
return 1




end function

public function integer wf_retrieve ();string ls_sdate, ls_edate, ls_name, ls_deptname, ls_title
long ll_row1 , ll_row2
integer i

if dw_ip.AcceptText() = -1 then return -1


ls_sdate = trim(dw_ip.GetItemString(1,'sdate'))
ls_edate = trim(dw_ip.GetItemString(1,'edate'))
ls_deptname   = dw_ip.GetItemString(1,'deptname')
ls_name  = trim(dw_ip.GetItemString(1,'name'))
ls_title  = trim(dw_ip.GetItemString(1,'title'))


if isnull(ls_sdate) or ls_sdate = "" then ls_sdate = '10000101'
if isnull(ls_edate) or ls_edate = "" then ls_edate = '99991231'
if isnull(ls_deptname) then ls_deptname = "" 
if isnull(ls_name ) then ls_name = ""
if isnull(ls_title) then ls_title = ""


dw_list.object.txt_deptname.text = ls_deptname
dw_list.object.txt_name.text = ls_name
dw_list.object.txt_title.text = ls_title
dw_list.object.txt_date.text = string( ls_sdate, '@@@@.@@.@@') + '  -  ' + string( ls_edate, '@@@@.@@.@@') 

ll_row1 = dw_claim.Retrieve(gs_sabu, ls_sdate, ls_edate) 
ll_row2 = dw_as.Retrieve(gs_sabu,  ls_sdate,  ls_edate)  

for i = 1 to  21
	dw_list.insertrow(i) 
next

If ( ll_Row1 > 1 and ll_Row2 > 1 )  then
	wf_as()
	wf_claim()  
ELSEif ( ll_Row1 > 1 and ll_Row2 <= 0 ) then 
	wf_claim()
elseif ( ll_Row1 <= 0 and ll_Row2 > 1 ) then
	wf_as()
elseif ( ll_Row1 <= 0 and ll_Row2 <= 0 ) then
	messagebox('처리일자 확인' , '처리일자에 맞는 자료가 없습니다.')
	dw_ip.setfocus()
	dw_ip.setcolumn("sdate")
END IF
      
return 1
end function

public function integer wf_as ();string ls_cust_name 
double ld_as_count, ld_as_okqty,  ld_as_rslamt , ld_tot_count20, ld_tot_okqty20, ld_tot_rslamt20,  &
       ld_tot_count, ld_tot_okqty, ld_tot_rslamt
integer i


for i= 1 to dw_as.Rowcount()
      ls_cust_name   = dw_as.getitemstring( i, "cust_name" ) 
      ld_as_count    = dw_as.getitemnumber( i, "as_count"  )
      ld_as_okqty    = dw_as.getitemnumber( i, "as_okqty"  )
		ld_as_rslamt   = dw_as.getitemnumber( i, "as_rslamt" )
		
   if i < 20 then 
		dw_list.setitem( i ,  "as_cvnas" , ls_cust_name ) 
		dw_list.setitem( i ,  "as_count" , ld_as_count  )
		dw_list.setitem( i ,  "as_qty" , ld_as_okqty  )
		dw_list.setitem( i ,  "as_amt" , ld_as_rslamt )
	end if
	   
	if i >= 20 then
		ld_tot_count20 = ld_tot_count20 + ld_as_count 
		ld_tot_okqty20 = ld_tot_okqty20 + ld_as_okqty
		ld_tot_rslamt20 = ld_tot_rslamt20 + ld_as_rslamt 	   	
	end if
	
	ld_tot_count = ld_tot_count + ld_as_count 
	ld_tot_okqty = ld_tot_okqty + ld_as_okqty
	ld_tot_rslamt = ld_tot_rslamt + ld_as_rslamt
		
next		
   

	dw_list.setitem( 20 ,  "as_count"  , ld_tot_count20  )
	dw_list.setitem( 20 ,  "as_qty"    , ld_tot_okqty20 )
	dw_list.setitem( 20 ,  "as_amt" , ld_tot_rslamt20 )
	
	dw_list.setitem( 21 ,  "as_count"  , ld_tot_count  )
	dw_list.setitem( 21 ,  "as_qty"    , ld_tot_okqty )
	dw_list.setitem( 21 ,  "as_amt" , ld_tot_rslamt )
		
		
return 1



end function

on w_qct_03630.create
int iCurrent
call super::create
this.dw_as=create dw_as
this.dw_claim=create dw_claim
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_as
this.Control[iCurrent+2]=this.dw_claim
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.rr_2
end on

on w_qct_03630.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_as)
destroy(this.dw_claim)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_2)
end on

event open;call super::open;dw_as.settransobject(sqlca)
dw_claim.settransobject(sqlca)

dw_list.SharedataOff()
end event

type p_preview from w_standard_print`p_preview within w_qct_03630
end type

event p_preview::clicked;OpenWithParm(w_print_preview, dw_list)	

end event

type p_exit from w_standard_print`p_exit within w_qct_03630
integer taborder = 70
end type

type p_print from w_standard_print`p_print within w_qct_03630
end type

event p_print::clicked;IF dw_list.rowcount() > 0 then 
	gi_page = dw_list.GetItemNumber(1,"last_page")
ELSE
	gi_page = 1
END IF
OpenWithParm(w_print_options, dw_list)


end event

type p_retrieve from w_standard_print`p_retrieve within w_qct_03630
end type

event p_retrieve::clicked;call super::clicked;//p_preview.triggerevent(clicked!)
end event







type st_10 from w_standard_print`st_10 within w_qct_03630
end type



type dw_print from w_standard_print`dw_print within w_qct_03630
integer x = 3781
integer y = 64
integer width = 133
integer height = 96
string dataobject = "d_qct_03630_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_qct_03630
integer y = 28
integer width = 3867
integer height = 184
string dataobject = "d_qct_03630_01"
end type

event dw_ip::itemerror;return 1 
end event

event dw_ip::itemchanged;String s_cod, s_nam1, s_nam2
Integer i_rtn

s_cod = Trim(this.GetText())


if this.getcolumnname() = "dept" then 
	i_rtn = f_get_name2("부서", "Y", s_cod, s_nam1, s_nam2)
	this.object.dept[1] = s_cod
	this.object.deptname[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "writer" then 
	i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
	this.object.writer[1] = s_cod
	this.object.name[1] = s_nam1
	return i_rtn
elseif this.getcolumnname() = "sdate" then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[처리일자 FROM]")
		this.object.sdate[1] = ""
		return 1
	end if
elseif this.getcolumnname() = "edate" then 
	if IsNull(s_cod) or s_cod = "" then return
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[처리일자 TO]")
		this.object.edate[1] = ""
		return 1
	end if
End If
end event

event dw_ip::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.getcolumnname() = "dept" then
	open(w_vndmst_4_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "dept", gs_code)
	this.SetItem(1, "deptname", gs_codename)
	return
elseif this.getcolumnname() = "writer" then
	open(w_sawon_popup)
	If IsNull(gs_code) Or gs_code = '' Then Return
	this.SetItem(1, "writer", gs_code)
	this.SetItem(1, "name", gs_codename)
	return
end if
end event

type dw_list from w_standard_print`dw_list within w_qct_03630
integer x = 69
integer y = 224
integer width = 4462
integer height = 1956
string dataobject = "d_qct_03630_02_p"
boolean border = false
end type

type dw_as from datawindow within w_qct_03630
boolean visible = false
integer x = 2345
integer y = 872
integer width = 1019
integer height = 360
integer taborder = 30
string dataobject = "d_qct_03630_02_2"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_claim from datawindow within w_qct_03630
boolean visible = false
integer x = 1696
integer y = 756
integer width = 818
integer height = 360
integer taborder = 30
string dataobject = "d_qct_03630_02_1"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_1 from u_pb_cal within w_qct_03630
integer x = 608
integer y = 68
integer taborder = 90
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_03630
integer x = 1033
integer y = 68
integer taborder = 100
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_ip.SetColumn('edate')
IF Isnull(gs_code) THEN Return
dw_ip.SetItem(dw_ip.getrow(), 'edate', gs_code)
end event

type rr_2 from roundrectangle within w_qct_03630
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 46
integer y = 216
integer width = 4562
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

