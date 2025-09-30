$PBExportHeader$w_qct_01100_m.srw
$PBExportComments$이상발생결과등록(voda)
forward
global type w_qct_01100_m from w_inherite
end type
type dw_detail from datawindow within w_qct_01100_m
end type
type pb_1 from u_pb_cal within w_qct_01100_m
end type
type pb_2 from u_pb_cal within w_qct_01100_m
end type
type rr_1 from roundrectangle within w_qct_01100_m
end type
end forward

global type w_qct_01100_m from w_inherite
integer width = 4640
string title = "이상발생 결과등록"
dw_detail dw_detail
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_qct_01100_m w_qct_01100_m

on w_qct_01100_m.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.rr_1
end on

on w_qct_01100_m.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;PostEvent('ue_open')
end event

event ue_open;call super::ue_open;dw_insert.settransobject(sqlca)
dw_detail.settransobject(sqlca)

String stoday
stoday = f_today()

dw_detail.insertrow(0)

/* User별 사업장 Setting */
//setnull(gs_code)
//If f_check_saupj() = 1 Then
//	dw_detail.SetItem(1, 'porgu', gs_code)
//	if gs_code <> '%' then
//     	dw_detail.Modify("porgu.protect=1")
//		dw_detail.Modify("porgu.background.color = 80859087")
//	End if
//End If

end event

type dw_insert from w_inherite`dw_insert within w_qct_01100_m
integer x = 32
integer y = 396
integer width = 4567
integer height = 1904
integer taborder = 20
string dataobject = "d_qct_01100_m_01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::doubleclicked;if row > 0 then
	gs_code = this.getitemstring(row, "occrpt_occjpno")
	OpenSheet(w_qct_01100, w_MDI_frame,1, Original!)
end if
setnull(gs_code)
end event

event dw_insert::clicked;call super::clicked;
if dw_insert.Rowcount() = 0 then return

if row < 1 then return

dw_insert.SelectRow(0, false)
dw_insert.SelectRow(row, true)

end event

event dw_insert::rowfocuschanged;call super::rowfocuschanged;if 	currentrow < 1 then return 
if 	this.rowcount() < 1 then return 

this.setredraw(false)

this.SelectRow(0,False)
this.SelectRow(currentrow,True)

this.ScrollToRow(currentrow)

this.setredraw(true)

end event

type p_delrow from w_inherite`p_delrow within w_qct_01100_m
boolean visible = false
integer x = 1888
integer y = 2420
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_qct_01100_m
boolean visible = false
integer x = 1714
integer y = 2420
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_qct_01100_m
boolean visible = false
integer x = 1385
integer y = 2424
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_qct_01100_m
boolean visible = false
integer x = 1541
integer y = 2420
boolean enabled = false
end type

type p_exit from w_inherite`p_exit within w_qct_01100_m
end type

event p_exit::clicked;//상속해제
close(parent)
end event

type p_can from w_inherite`p_can within w_qct_01100_m
end type

event p_can::clicked;call super::clicked;dw_insert.reset()
dw_detail.setfocus()
end event

type p_print from w_inherite`p_print within w_qct_01100_m
boolean visible = false
integer x = 3703
integer y = 28
end type

event p_print::clicked;call super::clicked;if dw_detail.accepttext() = -1 then return

gs_code  	 = dw_detail.getitemstring(1, "sdate")
gs_codename  = dw_detail.getitemstring(1, "edate")

if isnull(gs_code) or trim(gs_code) = '' then
	gs_code = '10000101'
end if

if isnull(gs_codename) or trim(gs_codename) = '' then
	gs_codename = '99991231'
end if

open(w_qct_01075_1)

Setnull(gs_code)
Setnull(gs_codename)
end event

type p_inq from w_inherite`p_inq within w_qct_01100_m
integer x = 4091
end type

event p_inq::clicked;call super::clicked;string ls_jpno, ls_sdate, ls_findate, ls_deptcode, ls_empno, ls_itnbr, ls_div, ls_route

dw_detail.accepttext()

if dw_detail.rowcount() < 1 then return 

//문서번호
ls_jpno = dw_detail.object.jpno[1] 
if trim(ls_jpno) = '' or isnull(ls_jpno) then 
	ls_jpno = '%'
End if 

//발생일자
ls_sdate = dw_detail.object.sdate[1] 
if trim(ls_sdate) = '' or isnull(ls_sdate) then 
	ls_sdate = '%'
End if 

//완료일자
ls_findate = dw_detail.object.findate[1] 
if trim(ls_findate) = '' or isnull(ls_findate) then 
	ls_findate = '%'
End if 

//발신부서
ls_deptcode = dw_detail.object.deptcode[1] 
if trim(ls_deptcode) = '' or isnull(ls_deptcode) then 
	ls_deptcode = '%'
End if 

//발신자
ls_empno = dw_detail.object.empno[1] 
if trim(ls_empno) = '' or isnull(ls_empno) then 
	ls_empno = '%'
End if 

//ls_itnbr
ls_itnbr = dw_detail.object.itnbr[1] 
if trim(ls_itnbr) = '' or isnull(ls_itnbr) then 
	ls_itnbr = '%'
End if 

//ls_div
ls_div = dw_detail.object.status[1] 
if trim(ls_div) = '' or isnull(ls_div) OR ls_div = '전체' then 
	ls_div = '%'
End if 

//ls_route
ls_route = dw_detail.object.route[1] 
if trim(ls_route) = '' or isnull(ls_route) then 
	ls_route = '%'
End if 

dw_insert.retrieve(gs_sabu, ls_jpno, ls_sdate, ls_findate, ls_deptcode, ls_empno, ls_itnbr, ls_div, ls_route)


end event

type p_del from w_inherite`p_del within w_qct_01100_m
boolean visible = false
integer x = 2235
integer y = 2420
boolean enabled = false
end type

type p_mod from w_inherite`p_mod within w_qct_01100_m
boolean visible = false
integer x = 2062
integer y = 2420
boolean enabled = false
end type

type cb_exit from w_inherite`cb_exit within w_qct_01100_m
end type

type cb_mod from w_inherite`cb_mod within w_qct_01100_m
integer x = 672
integer y = 2452
integer taborder = 40
end type

type cb_ins from w_inherite`cb_ins within w_qct_01100_m
integer x = 311
integer y = 2452
integer taborder = 30
end type

type cb_del from w_inherite`cb_del within w_qct_01100_m
integer x = 1033
integer y = 2452
integer taborder = 50
end type

type cb_inq from w_inherite`cb_inq within w_qct_01100_m
integer x = 1403
integer y = 2460
integer taborder = 60
end type

type cb_print from w_inherite`cb_print within w_qct_01100_m
integer x = 1755
integer y = 2452
integer taborder = 70
end type

type st_1 from w_inherite`st_1 within w_qct_01100_m
end type

type cb_can from w_inherite`cb_can within w_qct_01100_m
end type

type cb_search from w_inherite`cb_search within w_qct_01100_m
end type







type gb_button1 from w_inherite`gb_button1 within w_qct_01100_m
end type

type gb_button2 from w_inherite`gb_button2 within w_qct_01100_m
end type

type dw_detail from datawindow within w_qct_01100_m
integer x = 37
integer y = 24
integer width = 2990
integer height = 352
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_qct_01100_M_H"
boolean border = false
boolean livescroll = true
end type

event itemerror;return 1
end event

event rbuttondown;
SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)


if this.getcolumnname() = "jpno" then //문서번호
	open(w_occjpno_popup)
   this.object.jpno[1] = gs_code
elseif this.getcolumnname() = "deptcode" then //조치부서
	open(w_vndmst_4_popup)
   this.object.deptcode[1] = gs_code
	this.object.deptname[1] = gs_codename

elseif this.getcolumnname() = "empno" then //조치담당1
	open(w_sawon_popup)
   this.object.empno[1] = gs_code
	this.object.empname[1] = gs_codename

elseif this.getcolumnname() =  "itnbr" then

	  Open(w_itemas_popup)
	  IF gs_code = "" OR IsNull(gs_code) THEN RETURN

	  this.SetItem(1,"itnbr",gs_code)
	  this.SetFocus()
	  this.SetColumn('itnbr')
	  this.PostEvent(ItemChanged!)	

end if

return

end event

event itemchanged;String  sdata, ls_itdsc, ls_itnbr, ls_route
String  s_col, s_cod, s_nam1, s_nam2, snull,sname
Integer i_rtn

ib_any_typing = True //입력필드 변경여부 Yes

s_col = this.GetColumnName()
s_cod = Trim(this.GetText())

s_nam1 = ""
s_nam2 = ""  

setnull(snull)
CHOOSE CASE s_col
	CASE "jpno" //문서번호
		if IsNull(s_cod) or s_cod = "" then return
		select occjpno
		  into :s_nam1
		  from occrpt
		 where occjpno = :s_cod;
		if sqlca.sqlcode <> 0 then
			f_message_chk(33, "[문서번호]")
		   this.object.jpno[1] = ""
			return 1
		end if	
		p_inq.TriggerEvent(Clicked!) //조회버튼 
	CASE "deptcode" //조치부서
		i_rtn = f_get_name2("V0", "Y", s_cod, s_nam1, s_nam2)
		this.object.deptcode[1] = s_cod
		this.object.deptname[1] = s_nam1
		return i_rtn
	CASE "empno" //조치담당자1
		i_rtn = f_get_name2("사번", "Y", s_cod, s_nam1, s_nam2)
		this.object.empno[1] = s_cod
		this.object.empname[1] = s_nam1
		return i_rtn
	CASE 'sdate' 
		sdata = this.gettext()
		if f_datechk(sdata) = -1 then
			f_message_chk(35,'[발생일자]');
			this.setitem(1, "sdate", snull)
			return 1
		end if

	CASE  'findate' 
		sdata = this.gettext()	
		if f_datechk(sdata) = -1 then
			f_message_chk(35,'[완료일자]');
			this.setitem(1, "findate", snull)
			return 1		
		end if
	Case	"itnbr" 
		 ls_Itnbr = Trim(this.GetText())
		 IF ls_Itnbr ="" OR IsNull(ls_Itnbr) THEN
			SetItem(1,'itdsc',sNull)
			Return
		 END IF
		
		 SELECT  "ITDSC" 
			INTO :ls_itdsc
			FROM "ITEMAS"
		  WHERE "ITNBR" = :ls_Itnbr ;
		 
		 IF SQLCA.SQLCODE <> 0 THEN
			this.PostEvent(RbuttonDown!)
			Return 2
		 END IF
		
		 SetItem(1,"itdsc", ls_itdsc)
	Case	"route" 
		ls_route = this.GetText()
		if trim(ls_route) = '' or isnull(ls_route) then 
			this.SetItem(1,"routename",sNull)
		end if 		
		
		SELECT "REFFPF"."RFNA1"  
		  INTO :sname  
		  FROM "REFFPF"  
		 WHERE ( "REFFPF"."SABU" = '1' ) AND  
				 ( "REFFPF"."RFCOD" = '21' ) AND  
				 ( "REFFPF"."RFGUB" = :ls_route )   ;
	
		IF SQLCA.SQLCODE <> 0 THEN
			this.SetItem(1,"routename",sNull)
		ELSE	
			this.SetItem(1,"routename", left(sname, 20))
		END IF

END CHOOSE

return
	
end event

type pb_1 from u_pb_cal within w_qct_01100_m
integer x = 2162
integer y = 48
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_detail.SetColumn('sdate')
IF Isnull(gs_code) THEN Return
dw_detail.SetItem(dw_detail.getrow(), 'sdate', gs_code)
end event

type pb_2 from u_pb_cal within w_qct_01100_m
integer x = 2889
integer y = 48
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_detail.SetColumn('findate')
IF Isnull(gs_code) THEN Return
dw_detail.SetItem(dw_detail.getrow(), 'findate', gs_code)
end event

type rr_1 from roundrectangle within w_qct_01100_m
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 376
integer width = 4585
integer height = 1916
integer cornerheight = 40
integer cornerwidth = 55
end type

