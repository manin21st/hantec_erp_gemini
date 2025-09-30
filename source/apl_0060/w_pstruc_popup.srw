$PBExportHeader$w_pstruc_popup.srw
$PBExportComments$** 하위품번(BOM) 조회 선택
forward
global type w_pstruc_popup from w_inherite_popup
end type
type p_2 from uo_picture within w_pstruc_popup
end type
type rr_1 from roundrectangle within w_pstruc_popup
end type
end forward

global type w_pstruc_popup from w_inherite_popup
integer x = 530
integer y = 236
integer width = 2779
integer height = 2060
string title = "하위품번 조회 선택"
p_2 p_2
rr_1 rr_1
end type
global w_pstruc_popup w_pstruc_popup

on w_pstruc_popup.create
int iCurrent
call super::create
this.p_2=create p_2
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_2
this.Control[iCurrent+2]=this.rr_1
end on

on w_pstruc_popup.destroy
call super::destroy
destroy(this.p_2)
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)

if isnull(gs_code) then 
	gs_code = "" 
end if

string get_itdsc, get_ispec

  SELECT "ITEMAS"."ITDSC", "ITEMAS"."ISPEC"  
    INTO :get_itdsc, :get_ispec
    FROM "ITEMAS"  
   WHERE "ITEMAS"."ITNBR" = :gs_code   ;

dw_jogun.insertrow(0)
dw_jogun.setitem(1, 'ptnbr', gs_code)
dw_jogun.setitem(1, 'ptdsc', get_itdsc)
dw_jogun.setitem(1, 'pspec', get_ispec)

dw_1.Retrieve(gs_code)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pstruc_popup
integer x = 27
integer y = 180
integer width = 2729
integer height = 204
string dataobject = "d_pstruc_popup"
end type

type p_exit from w_inherite_popup`p_exit within w_pstruc_popup
integer x = 2583
integer y = 24
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pstruc_popup
integer x = 2062
integer y = 24
string pointer = "C:\erpman\cur\point.cur"
boolean originalsize = false
string picturename = "C:\erpman\image\bom조회_up.gif"
end type

event p_inq::clicked;call super::clicked;String scode

IF dw_jogun.AcceptText() = -1 THEN RETURN 

dw_1.DataObject = "d_pstruc_popup1"
dw_1.SetTransObject(SQLCA)

sCode = dw_jogun.GetItemString(1,'ptnbr')

IF scode = '' or isnull(scode) THEN
   MessageBox("확 인", "BOM조회시 상위품번을 입력하세요 !")
   return
END IF

dw_1.Retrieve(scode)


end event

event p_inq::ue_lbuttondown;PictureName = 'C:\erpman\image\BOM조회_dn.gif'
end event

event p_inq::ue_lbuttonup;PictureName = 'C:\erpman\image\BOM조회_up.gif'
end event

type p_choose from w_inherite_popup`p_choose within w_pstruc_popup
integer x = 2409
integer y = 24
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_Code = dw_1.getitemstring(ll_row, "cinbr")
gs_CodeName= dw_1.getitemstring(ll_row, "itdsc")
gs_gubun= dw_1.getitemstring(ll_row, "ispec")

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_pstruc_popup
integer x = 46
integer y = 392
integer width = 2683
integer height = 1556
integer taborder = 20
string dataobject = "d_pstruc_popup2"
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

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

gs_Code = this.getitemstring(ROW, "cinbr")
gs_CodeName= this.getitemstring(ROW, "itdsc")
gs_gubun= this.getitemstring(ROW, "ispec")

Close(Parent)

end event

event dw_1::dberror;call super::dberror;return 1
end event

event dw_1::error;call super::error;return
end event

type sle_2 from w_inherite_popup`sle_2 within w_pstruc_popup
boolean visible = false
integer x = 585
integer y = 2200
integer width = 960
integer limit = 30
end type

type cb_1 from w_inherite_popup`cb_1 within w_pstruc_popup
end type

type cb_return from w_inherite_popup`cb_return within w_pstruc_popup
end type

type cb_inq from w_inherite_popup`cb_inq within w_pstruc_popup
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pstruc_popup
boolean visible = false
integer x = 681
integer y = 2148
integer width = 187
integer limit = 4
end type

type st_1 from w_inherite_popup`st_1 within w_pstruc_popup
boolean visible = false
integer x = 329
integer y = 2216
integer width = 256
string text = "공정코드"
alignment alignment = left!
end type

type p_2 from uo_picture within w_pstruc_popup
integer x = 2235
integer y = 24
integer width = 178
boolean bringtotop = true
string picturename = "C:\erpman\image\품목조회_up.gif"
end type

event clicked;call super::clicked;String scode, sname, sspec
String sold_sql, swhere_clause, snew_sql

IF dw_jogun.AcceptText() = -1 THEN RETURN 

dw_1.DataObject = "d_pstruc_popup2"
dw_1.SetTransObject(SQLCA)

sname = dw_jogun.GetItemString(1,'itdsc')
sspec = dw_jogun.GetItemString(1,'ispec')

IF IsNull(sname)  THEN sname  = ""
IF IsNull(sspec)  THEN sspec  = ""

sold_sql = "SELECT ITNBR, ITDSC, ISPEC, JIJIL " + &  
           "  FROM ITEMAS "                      + & 
           " WHERE GBWAN = 'Y' "      
swhere_clause = ""

IF sname <> "" THEN
	sname = '%' + sname +'%'
	swhere_clause = swhere_clause + "AND ITDSC LIKE '"+sname+"'"
END IF
IF sspec <> "" THEN
	sspec = '%' + sspec +'%'
	swhere_clause = swhere_clause + "AND ISPEC LIKE '"+sspec+"'"
END IF

snew_sql = sold_sql + swhere_clause
dw_1.SetSqlSelect(snew_sql)
	
dw_1.Retrieve()
	
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\품목조회_up.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\품목조회_dn.gif'
end event

type rr_1 from roundrectangle within w_pstruc_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 37
integer y = 388
integer width = 2706
integer height = 1568
integer cornerheight = 40
integer cornerwidth = 55
end type

