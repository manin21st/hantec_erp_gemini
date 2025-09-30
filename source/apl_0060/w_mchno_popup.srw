$PBExportHeader$w_mchno_popup.srw
$PBExportComments$** 설비번호 조회 선택
forward
global type w_mchno_popup from w_inherite_popup
end type
type pb_1 from u_pb_cal within w_mchno_popup
end type
type pb_2 from u_pb_cal within w_mchno_popup
end type
type rr_1 from roundrectangle within w_mchno_popup
end type
end forward

global type w_mchno_popup from w_inherite_popup
integer x = 23
integer y = 248
integer width = 3653
integer height = 1852
string title = "설비번호 조회"
pb_1 pb_1
pb_2 pb_2
rr_1 rr_1
end type
global w_mchno_popup w_mchno_popup

type variables
//설비마스타에서 조회시 구입일자 없어도 나오게 함
String  is_filter
end variables

forward prototypes
public function integer wf_sort (string as_dwobject_name)
end prototypes

public function integer wf_sort (string as_dwobject_name);String ls_setsort, ls_lowered = '5', ls_raised = '6'

ls_setsort = Left(as_dwobject_name, Len(as_dwobject_name) - 2)

If ls_setsort = "" Then Return -1

If dw_1.Describe("type.border") = ls_lowered Then 
	ls_setsort = ls_setsort + " d"
end if

if Upper(Mid(ls_setsort,1,5)) <> "MCHNO" then
	ls_setsort = ls_setsort + ", mchno asc"
end if	

If dw_1.SetSort(ls_setsort) = -1 Then
	MessageBox("SetSort()", "Parameter : '" + ls_setsort + "'")
	Return -1
End If

dw_1.Sort()
dw_1.ScrollToRow(dw_1.GetSelectedRow(0))

Return 0
end function

on w_mchno_popup.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.pb_2=create pb_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.rr_1
end on

on w_mchno_popup.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.SetReDraw(False)
dw_jogun.Reset()
dw_jogun.InsertRow(0)
dw_jogun.SetReDraw(True)

IF gs_gubun = 'ALL' then //구매일자와 관계없을 때(설비마스타 등록/출력에서, 설비 미구매현황)
   is_filter = 'N'    
ELSE
   is_filter = 'Y'    
END IF 

IF gs_code = '계측기' then //계측기만 사용
   dw_jogun.setitem(1, 'gbn', 'Y')
	dw_jogun.Object.gbn.Visible = 0
	
	dw_jogun.Modify("mchnam_t.text = '기기명' " )
	dw_jogun.Modify("t_1.text = '관리번호'" )
	dw_1.DataObject = 'd_mchno_popup3' 
	dw_1.settransObject(sqlca)
else
	dw_jogun.setitem(1, 'gbn', 'N')
//	dw_jogun.Object.buncd.visible = false
//   dw_jogun.Object.buncd_t.visible = false
END IF 

dw_jogun.setitem(1, 'saupj', gs_saupj)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_mchno_popup
integer x = 27
integer y = 172
integer width = 3611
integer height = 292
string dataobject = "d_mchno_popup1"
end type

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::itemchanged;call super::itemchanged;String s_cod, sname, sname2, sbuncd, snull
int    ireturn,  count1

setnull(snull)

s_cod = Trim(this.GetText())

if this.GetColumnName() = "dptno" then
	if IsNull(s_cod) or s_cod = "" then 
		this.setitem(1, 'dptnm', '')
		return 
	end if
	ireturn = f_get_name2('부서', 'Y', s_cod, sname, sname2)  
	this.setitem(1, "dptno", s_cod)	
	this.setitem(1, "dptnm", sname)	
	return ireturn
elseif this.GetColumnName() = "sdate2" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
	   f_message_chk(35,"[시작일자]")
	   this.object.sdate2[1] = ""
	   return 1
	end if	
elseif this.GetColumnName() = "edate2" then
	if IsNull(s_cod) or s_cod = "" then return 
	if f_datechk(s_cod) = -1 then
	   f_message_chk(35,"[끝일자]")
	   this.object.edate2[1] = ""
	   return 1
	end if
//elseif Getcolumnname() = "buncd" then   // 분류코드 
//	Sbuncd = trim(GetText())
//	if IsNull(Sbuncd) or Sbuncd = '' then return
//	
//	SELECT COUNT(*)  
//	INTO :COUNT1
//   FROM MITNCT
//	WHERE KEGBN = 'Y'
//	AND   BUNCD = :Sbuncd ; 
//	
//	if count1 = 0 then
//		MessageBox('확인' , '등록되지않은 설비분류코드 입니다.')
//		setitem(1,'buncd',snull)
//		return 2
//	end if 
end if 	
end event

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(Gs_code)
SetNull(Gs_gubun)
SetNull(Gs_codename)


IF this.GetColumnName() = "dptno" THEN
	Open(w_vndmst_4_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then  return

	this.SetItem(1, "dptno", gs_Code)
	this.SetItem(1, "dptnm", gs_Codename)
//Elseif this.GetColumnname() = "buncd" then
//	gs_gubun = 'Y'
//	open(w_mittyp_popup) 
//	if IsNull(gs_code) or gs_code = '' then Return
//	
//	SetItem(1, "buncd", gs_code) 	
END IF
end event

event dw_jogun::ue_key;call super::ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

type p_exit from w_inherite_popup`p_exit within w_mchno_popup
integer x = 3438
integer y = 16
end type

event p_exit::clicked;call super::clicked;setnull(gs_code)
setnull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_mchno_popup
integer x = 3090
integer y = 16
end type

event p_inq::clicked;call super::clicked;String sdptno, sdate2, edate2, gbn, mchnam, mdlnm, sgrpcod, sSts, sFilter, buncd, ssaupj
int    ilen

if dw_jogun.AcceptText() = -1 then	return

sdptno  = Trim(dw_jogun.object.dptno[1])
sdate2  = Trim(dw_jogun.object.sdate2[1])
edate2  = Trim(dw_jogun.object.edate2[1])
gbn     = Trim(dw_jogun.object.gbn[1]) 
mchnam  = Trim(dw_jogun.object.mchnam[1])
mdlnm   = Trim(dw_jogun.object.mdlnm[1])
sgrpcod = Trim(dw_jogun.object.grpcod[1])
sSts    = dw_jogun.object.sts[1]
buncd   = Trim(dw_jogun.object.buncd[1])
ssaupj  = Trim(dw_jogun.object.saupj[1])

if sdptno  = '' or isnull(sdptno) then sdptno = '%'

if gbn = "Y" or gbn = "N" then
	gbn = gbn + "%"
else
	gbn = "%"
end if	

if IsNull(mchnam) or mchnam = "" then
	mchnam = "%"
else
	mchnam = mchnam + "%"
end if	

if IsNull(buncd) or buncd = "" then 
	buncd = '%'
else
	buncd = buncd + '%'
end if

if sgrpcod  = '' or isnull(sgrpcod) then sgrpcod = '%'

dw_1.setredraw(false)

if IsNull(mdlnm) or mdlnm = "" then  
	sFilter = ''
else 
	mdlnm = mdlnm + '%'
	sFilter = "( mdlnm like '"+ mdlnm +"') and"
end if	

IF is_filter = 'Y' THEN 
   sFilter =  sFilter + " ( gudat > '.' ) and"
END IF

if sSts = '1' then 
   sFilter =  sFilter + " ( sts = '정상' )"
elseif sSts = '2' then 
   sFilter =  sFilter + " ( sts = '사용중지' )"
elseif sSts = '3' then 
   sFilter =  sFilter + " ( sts = '폐기' )"
else
	iLen    = len(sFilter)
	if ilen > 3 then 
		sFilter = left(sFilter, ilen - 3)
	end if
end if

if ssaupj  = '' or isnull(ssaupj) then sdptno = gs_saupj

dw_1.SetFilter(sFilter)
dw_1.Filter()

if IsNull(sdate2) or sdate2 = "" then sdate2 = "10000101"
if IsNull(edate2) or edate2 = "" then edate2 = "99991231"

dw_1.Retrieve(gs_sabu, sdptno, sdate2, edate2, gbn, mchnam, sgrpcod, buncd, ssaupj )

dw_1.setredraw(true)
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_mchno_popup
integer x = 3264
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long crow

crow = dw_1.GetRow()

if crow < 1 or crow > dw_1.RowCount() then
	MessageBox("자료선택","해당  Row를 선택한 다음 진행하세요!")
   return
end if

if gs_codename = '계측기관리번호' then
	gs_code = dw_1.GetItemString(cRow, "mchmst_buncd" )
else
	gs_code = dw_1.GetItemString(cRow, "mchno")
	gs_codename = dw_1.GetItemString(cRow, "mchnam")
	gs_codename2 = dw_1.GetItemString(cRow, "mchmst_buncd" )
end if	

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_mchno_popup
integer x = 46
integer y = 476
integer width = 3547
integer height = 1256
integer taborder = 30
string dataobject = "d_mchno_popup2"
boolean hscrollbar = true
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False
END IF

CALL SUPER ::CLICKED


end event

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 or row > dw_1.RowCount() then
	MessageBox("자료선택","해당  Row를 선택한 다음 진행하세요!")
   return
end if

if gs_codename = '계측기관리번호' then
	gs_code = dw_1.GetItemString(Row, "mchmst_buncd" )
else
	gs_code = dw_1.GetItemString(Row, "mchno")
	gs_codename = dw_1.GetItemString(Row, "mchnam")
	gs_codename2 = dw_1.GetItemString(Row, "mchmst_buncd")
end if	

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_mchno_popup
boolean visible = false
integer x = 832
integer y = 1864
integer width = 1006
end type

type cb_1 from w_inherite_popup`cb_1 within w_mchno_popup
integer x = 155
integer y = 1896
integer height = 104
integer taborder = 40
end type

type cb_return from w_inherite_popup`cb_return within w_mchno_popup
integer x = 768
integer y = 1896
integer height = 104
end type

type cb_inq from w_inherite_popup`cb_inq within w_mchno_popup
integer x = 462
integer y = 1896
integer height = 104
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_mchno_popup
boolean visible = false
integer x = 389
integer y = 1876
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_mchno_popup
boolean visible = false
integer x = 91
integer y = 1888
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type pb_1 from u_pb_cal within w_mchno_popup
integer x = 1527
integer y = 268
integer taborder = 20
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('sdate2')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'sdate2', gs_code)
end event

type pb_2 from u_pb_cal within w_mchno_popup
integer x = 1961
integer y = 268
integer taborder = 30
boolean bringtotop = true
end type

event clicked;call super::clicked;dw_jogun.Setcolumn('edate2')
IF gs_code = '' Or IsNull(gs_code) THEN Return
dw_jogun.SetItem(1, 'edate2', gs_code)
end event

type rr_1 from roundrectangle within w_mchno_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 472
integer width = 3575
integer height = 1280
integer cornerheight = 40
integer cornerwidth = 55
end type

