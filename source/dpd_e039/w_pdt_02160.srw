$PBExportHeader$w_pdt_02160.srw
$PBExportComments$비가동요인 등록-작업실적과 관련이 없는 내역만 저장
forward
global type w_pdt_02160 from w_inherite
end type
type dw_1 from datawindow within w_pdt_02160
end type
type pb_1 from u_pb_cal within w_pdt_02160
end type
type p_1 from uo_picture within w_pdt_02160
end type
type rr_4 from roundrectangle within w_pdt_02160
end type
end forward

global type w_pdt_02160 from w_inherite
integer height = 2476
string title = "비가동요인등록"
event ue_open pbm_custom01
dw_1 dw_1
pb_1 pb_1
p_1 p_1
rr_4 rr_4
end type
global w_pdt_02160 w_pdt_02160

type variables
datawindowchild dws
end variables

forward prototypes
public function integer wf_requiredchk ()
public function integer wf_recordcheck (integer nrow)
end prototypes

public function integer wf_requiredchk ();string sdate, sjocod, swkctr

if 	dw_1.accepttext() = -1 then return 0

sjocod 	= dw_1.getitemstring(1, "jocod")
sdate  	= dw_1.getitemstring(1, "sidat")
swkctr  	= dw_1.getitemstring(1, "wkctr")

If 	f_datechk(sdate) = -1 Then
   	f_message_chk(40,'[실적일자]')
	dw_1.setcolumn("sidat")
	dw_1.setfocus()
	Return 0
End If

If 	trim(sjocod) = '' Or IsNull(sjocod) Then 
   	f_message_chk(30, '[조코드]')
	dw_1.setcolumn("jocod")
	dw_1.setfocus()
	Return 0
end if

//If 	trim(swkctr) = '' Or IsNull(swkctr) Then 
//   	f_message_chk(30, '[작업장]')
//	dw_1.setcolumn("wkctr")
//	dw_1.setfocus()
//	Return 0
//end if

return 1


end function

public function integer wf_recordcheck (integer nrow);String 		sData,  sName, sName2

//작업장
sdata = dw_insert.getitemstring(nrow, "nttabl_wkctr")
if f_get_name2('작업장', 'Y', sdata, sname, sname2) <> 0 then
	dw_insert.SetColumn('nttabl_wkctr')
	return 1
End If
// 비가동 원인
sdata = dw_insert.getitemstring(nrow, "nttabl_ntcod")
if 	isnull(f_get_reffer('35', sdata)) then
	dw_insert.SetColumn('nttabl_ntcod')
	f_message_chk(33,'[비가동원인]')
	return 1
end if
 // 원인 제공거래처/부서
sdata = dw_insert.getitemstring(nrow, "nttabl_dptno")
If 	f_get_name2('V0', 'Y', sdata, sname, sname2) <> 0 then 
	f_message_chk(33,'[원인 제공거래처/부서]')
	dw_insert.SetColumn('nttabl_dptno')
	return 1
End if
 // 조치부서.
//sdata = dw_insert.getitemstring(nrow, "nttabl_sdptno")
//if  	f_get_name2('V0', 'Y', sdata, sname, sname2) <> 0 then 
//	f_message_chk(33,'[조치부서]')
//	dw_insert.SetColumn('nttabl_sdptno')
//	return 1 
//End if

if isnull(dw_insert.getitemdecimal(nrow, "nttabl_ntime")) or &
	dw_insert.getitemdecimal(nrow, "nttabl_ntime") = 0 then
	f_message_chk(40,' 비가동시간')		
	dw_insert.SetColumn('nttabl_ntime')
//	return 1
end if

Return 0 	
end function

on w_pdt_02160.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.p_1=create p_1
this.rr_4=create rr_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.rr_4
end on

on w_pdt_02160.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.p_1)
destroy(this.rr_4)
end on

event open;call super::open;dw_1.insertrow(0)
dw_insert.SetTransObject(sqlca)

dw_insert.getchild('nttabl_ntcod', dws)
dws.settransobject(sqlca)
dws.retrieve()

ib_any_typing =False
dw_1.setitem(1, "sidat", f_Today())

// 에이스디지텍 작업실적 등록
//If gs_gubun    = 'w_adt_00350' Then
//	dw_1.setitem(1, "wkctr", gs_code)
//	dw_1.setitem(1, "wcdsc", gs_codename)
//	dw_1.setitem(1, "jocod", gs_docno)
//	dw_1.setitem(1, "jonam", gs_codename2)
//End If

dw_1.setfocus()
end event

type dw_insert from w_inherite`dw_insert within w_pdt_02160
integer x = 59
integer y = 216
integer width = 4466
integer height = 2112
integer taborder = 40
string dataobject = "d_pdt_02160"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event dw_insert::itemchanged;String 	sData, s_jocod,s_jonam, snull, sName, sName2, stime, etime, sdate
long 		lrow, lfind
Integer 	ireturn

this.accepttext()
lrow = this.getrow()
setnull(snull)

Choose Case GetColumnName()
	Case 'nttabl_ntcod'
	 		sdata = this.getitemstring(lrow, "nttabl_ntcod")
			if isnull(f_get_reffer('35', sdata)) then
				f_message_chk(33,'[비가동원인]')
				this.setitem(lrow, "nttabl_ntcod", snull)
				this.setitem(lrow, "code_name", snull)				
				return 1
			else
				this.setitem(lrow, "code_name", dws.getitemstring(dws.getrow(), "rfna1"))
			end if
	Case 'nttabl_wkctr'       //작업장
 		sdata = this.getitemstring(lrow, "nttabl_wkctr")
		 
		ireturn = f_get_name2('작업장', 'N', sdata, sname, sname2)
		If 	sname2 <> dw_1.getitemstring(1, "jocod") then
			Messagebox("조코드", "조코드가 틀립니다", stopsign!)
			this.setitem(lrow, "nttabl_wkctr"	, snull)
			this.setitem(lrow, "wsdsc"        	, snull)
			return 1
		End If	

		this.SetItem(lrow,"nttabl_wkctr",sdata)
		this.SetItem(lrow,"wsdsc",sname)
   		return ireturn 
	Case 'nttabl_dptno'    // 원인 제공거래처/부서
 		sdata = this.getitemstring(lrow, "nttabl_dptno")

		ireturn = f_get_name2('V0', 'N', sdata, sname, sname2)
		this.SetItem(lrow,"nttabl_dptno",sdata)
		this.SetItem(lrow,"dptnm",sname)
   		return ireturn 
	Case 'nttabl_sdptno'  // 조치부서.
 		sdata = this.getitemstring(lrow, "nttabl_sdptno")

		ireturn = f_get_name2('V0', 'N', sdata, sname, sname2)
		this.SetItem(lrow,"nttabl_sdptno",sdata)
		this.SetItem(lrow,"sdptnm",sname)
   		return ireturn 
	Case 'nttabl_stime'
		sDate = dw_1.GetItemString(1, 'sidat')
		stime = Trim(GetText())
		etime = GetItemString(lrow, 'nttabl_etime')
		
		SetItem(lrow, 'nttabl_ntime', f_daytimeterm(sdate, sdate, stime,etime))
	Case 'nttabl_etime'
		sDate = dw_1.GetItemString(1, 'sidat')
		etime = Trim(GetText())
		stime = GetItemString(lrow, 'nttabl_stime')
		
		SetItem(lrow, 'nttabl_ntime', f_daytimeterm(sdate, sdate, stime,etime))
End Choose

end event

event dw_insert::rbuttondown;String sData
long lrow

SetNull(gs_code)
SetNull(gs_codename)

lrow = this.getrow()
if lrow < 0 then  return

Choose Case GetColumnName()
	Case 'nttabl_wkctr'
			Open(w_workplace_popup)
			SetItem(lrow,'nttabl_wkctr',gs_code)
			SetItem(lrow,'wsdsc',gs_codename)
			this.triggerevent(itemchanged!)
	Case 'nttabl_dptno'
			gs_gubun = '4'   
			gi_page = -1 
   			Open(w_vndmst_popup)
			gi_page = 0 

			IF isnull(gs_Code)  or  gs_Code = ''	then  return
			SetItem(lrow,'nttabl_dptno',gs_code)
			this.triggerevent(itemchanged!)
	Case 'nttabl_sdptno'
			Open(w_vndmst_4_popup)
			SetItem(lrow,'nttabl_sdptno',gs_code)
			SetItem(lrow,'sdptnm',gs_codename)
			this.triggerevent(itemchanged!)
End Choose

this.accepttext()
end event

event dw_insert::itemerror;return 1
end event

type p_delrow from w_inherite`p_delrow within w_pdt_02160
boolean visible = false
integer x = 4736
integer y = 640
integer taborder = 0
boolean enabled = false
end type

type p_addrow from w_inherite`p_addrow within w_pdt_02160
boolean visible = false
integer x = 4741
integer y = 792
integer taborder = 0
boolean enabled = false
end type

type p_search from w_inherite`p_search within w_pdt_02160
boolean visible = false
integer x = 4722
integer y = 328
integer taborder = 0
boolean enabled = false
end type

type p_ins from w_inherite`p_ins within w_pdt_02160
integer x = 3749
integer taborder = 30
end type

event p_ins::clicked;call super::clicked;string sdate, jocod, swkctr
int    rcnt,row

if 	dw_1.accepttext()  = -1 then return 

rcnt 	= dw_insert.getrow()

jocod 	= dw_1.getitemstring(1, "jocod")
sdate 	= trim(dw_1.getitemstring(1, "sidat"))
swkctr 	= trim(dw_1.getitemstring(1, "wkctr"))

if	wf_requiredchk() <> 1 	then return

If	rcnt > 0	then
	if 	wf_recordcheck(rcnt) <> 0 then
		dw_insert.SetRow(rcnt)
		dw_insert.setfocus()
		return
	End if
End If	

row 	= dw_insert.InsertRow(0)
dw_insert.SetItem(row,'nttabl_sabu',gs_sabu)
dw_insert.SetItem(row,'nttabl_ntdat',sdate)
dw_insert.SetItem(row,'nttabl_jocod',jocod)
//dw_insert.SetItem(row,'nttabl_wkctr',swkctr)
dw_insert.SetItem(row,'nttabl_shpjpno','.')

dw_insert.SetItemStatus(row, 0,Primary!, NotModified!)
dw_insert.SetItemStatus(row, 0,Primary!, New!)
dw_insert.SetFocus()
dw_insert.SetRow(row)
dw_insert.SetColumn('nttabl_wkctr')

dw_1.Enabled = False   // 추가중 일자변경 불가
end event

type p_exit from w_inherite`p_exit within w_pdt_02160
end type

type p_can from w_inherite`p_can within w_pdt_02160
end type

event p_can::clicked;call super::clicked;dw_1.Enabled = True
dw_1.setitem(1, "jocod", '')
dw_1.setitem(1, "jonam", '')
dw_1.setitem(1, "wkctr", '')
dw_1.setitem(1, "wcdsc", '')
dw_1.SetFocus()


dw_insert.Reset()
ib_any_typing = False
end event

type p_print from w_inherite`p_print within w_pdt_02160
boolean visible = false
integer x = 4741
integer y = 484
integer taborder = 0
boolean enabled = false
end type

type p_inq from w_inherite`p_inq within w_pdt_02160
integer x = 3401
integer taborder = 20
end type

event p_inq::clicked;call super::clicked;string sdate, sjonam, sjocod, sWkctr

if 	dw_1.accepttext() = -1 then return

sjocod 	= dw_1.getitemstring(1, "jocod")
sjonam 	= dw_1.getitemstring(1, "jonam")
sdate  	= dw_1.getitemstring(1, "sidat")
//sWkctr   = dw_1.getitemstring(1, "wkctr")

if	wf_requiredchk() <> 1 	then return

If 	dw_insert.Retrieve(gs_sabu,sdate, sJocod ) > 0 Then	
	dw_1.enabled = false
Else
	w_mdi_frame.sle_msg.text  = '조회된 건수가 없습니다.!!'
End If

end event

type p_del from w_inherite`p_del within w_pdt_02160
end type

event p_del::clicked;call super::clicked;string sdate,scurr, sWcdsc
int    row

sdate = dw_1.getitemstring(1, "sidat")
//sdate = Left(sdate,4) + Mid(sdate,6,2) + Right(sdate,2)

If 	dw_insert.RowCount() > 0 Then
	row   	= dw_insert.GetRow()
	scurr 	= Trim(dw_insert.GetItemSTring(row,'wsdsc'))
   	IF 	MessageBox("삭 제",sdate + "의 " + scurr +" 가 삭제됩니다." +"~n~n" +&
                     	 "삭제 하시겠습니까?",Question!, YesNo!, 2) = 2 THEN RETURN
     
	If 	dw_insert.DeleteRow(row)  = 1 Then
		If 	dw_insert.Update() = 1 Then
		   	commit;
		   	w_mdi_frame.sle_msg.text  =	"자료를 삭제하였습니다!!"	
	   Else
		   	Rollback ;
	   End If		
	End If	
End If
end event

type p_mod from w_inherite`p_mod within w_pdt_02160
end type

event p_mod::clicked;call super::clicked;int 	nRow, ix
String scidat
Long   nMax

if dw_1.AcceptText() = -1 then return 
if dw_insert.AcceptText() = -1 then return 

nRow  = dw_insert.RowCount()
If nRow <=0 Then Return
	  
For ix = 1 To nRow
	if	wf_recordcheck(ix) <> 0 	then
		dw_insert.SetRow(ix)
		dw_insert.setfocus()
		Return
	End if
	
	dw_insert.SetItem(ix,"nttabl_sloss", dw_insert.GetItemDecimal(ix,"nttabl_ntime") * dw_insert.GetItemDecimal(ix,"nttabl_sinwon") )
Next

// key select
sCidat = dw_1.GetItemString(1, 'sidat')
select max(ntseq) into :nmax from nttabl where sabu = :gs_sabu and ntdat = :scidat;
If IsNull(nmax) Then nMax = 0

For ix = 1 to dw_insert.RowCount()
	If dw_insert.GetItemNumber(ix, 'nttabl_ntseq') = 0 Then
		nMax = nMax + 1
		dw_insert.SetItem(ix, 'nttabl_ntseq', nmax)
	End If
Next

if dw_insert.update() = 1 then
	w_mdi_frame.sle_msg.text  =	"자료를 저장하였습니다!!"			
	ib_any_typing = false
	commit ;
else
	rollback ;
	return 
end if

end event

type cb_exit from w_inherite`cb_exit within w_pdt_02160
integer x = 3195
integer y = 2716
end type

type cb_mod from w_inherite`cb_mod within w_pdt_02160
integer x = 1701
integer y = 2716
end type

type cb_ins from w_inherite`cb_ins within w_pdt_02160
integer x = 393
integer y = 2716
string text = "추가(&I)"
end type

type cb_del from w_inherite`cb_del within w_pdt_02160
integer x = 2053
integer y = 2716
end type

type cb_inq from w_inherite`cb_inq within w_pdt_02160
integer x = 41
integer y = 2716
end type

type cb_print from w_inherite`cb_print within w_pdt_02160
integer x = 1742
integer y = 2716
end type

type st_1 from w_inherite`st_1 within w_pdt_02160
end type

type cb_can from w_inherite`cb_can within w_pdt_02160
integer x = 2405
integer y = 2716
end type

type cb_search from w_inherite`cb_search within w_pdt_02160
integer x = 4274
integer y = 592
integer width = 320
string text = "요약조회(&W) <=  나중에 해야함"
end type

event cb_search::clicked;call super::clicked;string sdate

if	wf_requiredchk() <> 1 	then return

OpenWithParm(w_pdt_02165, sdate)

end event







type gb_button1 from w_inherite`gb_button1 within w_pdt_02160
end type

type gb_button2 from w_inherite`gb_button2 within w_pdt_02160
end type

type dw_1 from datawindow within w_pdt_02160
event ue_key pbm_dwnkey
integer x = 50
integer y = 16
integer width = 3205
integer height = 180
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_pdt_02160_1"
boolean border = false
boolean livescroll = true
end type

event ue_key;if keydown(keyf1!) then
	triggerevent(rbuttondown!)
end if
end event

event rbuttondown;String sData
long lrow

SetNull(gs_code)
SetNull(gs_codename)

Choose Case GetColumnName()
	 Case 'jocod'
		Open(w_jomas_popup)
		SetItem(1,'jocod',gs_code)
		SetItem(1,'jonam',gs_codename)
	Case 'wkctr'
		SetNull(gs_code)
		open(w_workplace_popup)
		if isnull(gs_code) or gs_code = "" then return
		this.setitem(1, "wkctr", gs_code)
		this.triggerevent(itemchanged!)				
End Choose
end event

event itemerror;return 1
end event

event itemchanged;string sData, sName, sNull, sJocod

Setnull(sNull)

Choose Case GetColumnName()
		 Case 'sidat'
				If f_datechk(gettext()) = -1 Then
				   f_message_chk(40,'[실적일자]')
					dw_1.setitem(1, "sidat", f_today())
					dw_1.setcolumn("sidat")
					dw_1.setfocus()
					Return 1
				End If
				
		 Case 'jocod'
				sData = this.gettext()
				Select jonam into :sName From jomast
				 Where jocod = :sData;
				if sqlca.sqlcode <> 0 then
				   f_message_chk(33,'[조코드]')
					dw_1.setitem(1, "jocod", sNull)
					dw_1.setitem(1, "jonam", sNull)
					dw_1.setcolumn("jocod")
					dw_1.setfocus()
					Return 1					
				End if
				dw_1.setitem(1, "jonam", sName)
				cb_inq.triggerevent(clicked!)
	 Case 'wkctr'
		sData = trim(this.gettext())
		
		if isnull(sData) or sData = '' then
			this.setitem(1, "wcdsc", '')
			return 
		end if
		
		select a.wcdsc, a.jocod
		  into :sname, :sjocod
		  from wrkctr a
		 where a.wkctr = :sData;
	
		if sqlca.sqlcode <> 0 then
			f_message_chk(90,'[작업장]')
			this.setitem(1, "wkctr", snull)
			this.setitem(1, "wcdsc", snull)
			this.setitem(1, "jocod", snull)
			return  1
		end if	
		this.setitem(1, "wcdsc", sname)
		this.setitem(1, "jocod", sjocod)
End choose

end event

type pb_1 from u_pb_cal within w_pdt_02160
integer x = 704
integer y = 56
integer taborder = 40
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_1.Setcolumn('sidat')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_1.SetItem(1, 'sidat', gs_code)
end event

type p_1 from uo_picture within w_pdt_02160
integer x = 3575
integer y = 24
integer width = 178
boolean bringtotop = true
boolean originalsize = true
string picturename = "C:\erpman\image\일괄추가_up.gif"
end type

event clicked;call super::clicked;open(w_pdt_02160_popup)
end event

type rr_4 from roundrectangle within w_pdt_02160
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 41
integer y = 200
integer width = 4517
integer height = 2136
integer cornerheight = 40
integer cornerwidth = 55
end type

