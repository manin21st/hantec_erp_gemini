$PBExportHeader$w_itemas_popup10_cic.srw
$PBExportComments$** 품목코드 조회 [ 멀티 선택 ] 조
forward
global type w_itemas_popup10_cic from w_inherite_popup
end type
type dw_choose from datawindow within w_itemas_popup10_cic
end type
type cbx_all from checkbox within w_itemas_popup10_cic
end type
type rr_2 from roundrectangle within w_itemas_popup10_cic
end type
end forward

global type w_itemas_popup10_cic from w_inherite_popup
integer x = 357
integer y = 236
integer width = 3557
integer height = 1932
string title = "품목코드 조회(다중선택)"
dw_choose dw_choose
cbx_all cbx_all
rr_2 rr_2
end type
global w_itemas_popup10_cic w_itemas_popup10_cic

type variables
string is_itcls
end variables

on w_itemas_popup10_cic.create
int iCurrent
call super::create
this.dw_choose=create dw_choose
this.cbx_all=create cbx_all
this.rr_2=create rr_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_choose
this.Control[iCurrent+2]=this.cbx_all
this.Control[iCurrent+3]=this.rr_2
end on

on w_itemas_popup10_cic.destroy
call super::destroy
destroy(this.dw_choose)
destroy(this.cbx_all)
destroy(this.rr_2)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_choose.SetTransObject(SQLCA)
dw_jogun.insertrow(0)

dw_jogun.setitem(1, 'ittyp', gs_gubun)

	


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_itemas_popup10_cic
integer x = 0
integer y = 32
integer width = 2770
integer height = 300
string dataobject = "d_itemas_popup10_head_cic"
end type

event dw_jogun::itemchanged;call super::itemchanged;string snull, s_name

setnull(snull)

IF this.GetColumnName() = 'ittyp' THEN
	s_name = this.gettext()
 
   IF s_name = "" OR IsNull(s_name) THEN 
		RETURN
   END IF
	
	s_name = f_get_reffer('05', s_name)
	if isnull(s_name) or s_name="" then
		f_message_chk(33,'[품목구분]')
		this.SetItem(1,'ittyp', snull)
		return 1
   end if	
END IF
end event

event dw_jogun::itemerror;call super::itemerror;RETURN 1
end event

event dw_jogun::rbuttondown;call super::rbuttondown;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

if this.GetColumnName() = 'itcls' then 
	
	gs_gubun = '1' //완제품 
//	Open(w_itnct_lm_popup)
	
	if isNull(gs_code) or gs_code = '' then Return 1
	
	this.SetItem(1,'itcls',gs_code)
	
end if
end event

type p_exit from w_inherite_popup`p_exit within w_itemas_popup10_cic
integer x = 3337
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)
Clipboard("")

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_itemas_popup10_cic
integer x = 2990
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String scode, sname, sspec, sgu, sitcls, sJijil, sPdtgu
String sold_sql, swhere_clause, snew_sql

if dw_jogun.AcceptText() = -1 then return 

sgu = dw_jogun.GetItemString(1,'ittyp')

IF IsNull(sgu) THEN sgu = ""

scode  = trim(dw_jogun.GetItemString(1,'itnbr'))
sname  = trim(dw_jogun.GetItemString(1,'itdsc'))
sspec  = trim(dw_jogun.GetItemString(1,'ispec'))
sitcls = trim(dw_jogun.GetItemString(1,'itcls'))
sJijil = trim(dw_jogun.GetItemString(1,'jijil'))
sPdtgu = trim(dw_jogun.GetItemString(1,'pdtgu'))

IF IsNull(scode)  THEN scode  = ""
IF IsNull(sname)  THEN sname  = ""
IF IsNull(sspec)  THEN sspec  = ""
IF IsNull(sitcls) THEN sitcls = ""
IF IsNull(sJijil) THEN sJijil = ""
IF IsNull(sPdtgu) THEN sPdtgu = ""

			  
sold_sql =  "SELECT 'N' Flag,   a.ITNBR,    a.ITDSC,    a.ISPEC,    a.JIJIL,      ITNCT.TITNM,          a.USEYN " + &
				"FROM CIC_ITEMAS_VW a ,  ITNCT "  + &
				"WHERE a.ITTYP = ITNCT.ITTYP(+)  and "   + &
				"      a.ITCLS = ITNCT.ITCLS(+) "  
			
swhere_clause = ""

IF sgu <> ""  THEN 
   swhere_clause = swhere_clause + "AND A.ITTYP ='"+sgu+"'"
END IF
IF scode <> "" THEN
	scode = '%' + scode +'%'
	swhere_clause = swhere_clause + "AND A.ITNBR LIKE '"+scode+"'"
END IF
IF sname <> "" THEN
	sname = '%' + sname +'%'
	swhere_clause = swhere_clause + "AND A.ITDSC LIKE '"+sname+"'"
END IF
IF sspec <> "" THEN
	sspec = '%' + sspec +'%'
	swhere_clause = swhere_clause + "AND A.ISPEC LIKE '"+sspec+"'"
END IF
IF sitcls <> "" THEN
	sitcls = sitcls +'%'
	swhere_clause = swhere_clause + "AND A.ITCLS LIKE '"+sitcls+"'"
END IF
IF sJijil <> "" THEN
	sJijil = '%' + sJijil +'%'
	swhere_clause = swhere_clause + "AND A.JIJIL LIKE '"+sJijil+"'"
END IF
IF sPdtgu <> "" THEN
	sPdtgu = '%' + sPdtgu +'%'
	swhere_clause = swhere_clause + "AND NVL(B.PDTGU,'.') LIKE '"+sPdtgu+"'"
END IF

snew_sql = sold_sql + swhere_clause
dw_1.SetSqlSelect(snew_sql)
	
dw_1.Retrieve()
	
dw_1.ScrollToRow(1)
dw_1.SetFocus()


end event

type p_choose from w_inherite_popup`p_choose within w_itemas_popup10_cic
integer x = 3163
end type

event p_choose::clicked;call super::clicked;Long ll_row, ll_mrow, iRtn

if dw_1.acceptText() < 1 then Return 
// Clear Clipboard !!!
//Clipboard("")
//
dw_choose.Reset()
for ll_row = 1 to dw_1.RowCount()
	
	if dw_1.GetItemString(ll_row, 'flag' ) = 'N' then Continue
	ll_mrow = dw_choose.InsertRow(0)
	
	dw_choose.SetItem(ll_mrow,'itnbr',dw_1.GetItemString(ll_row,'itemas_itnbr'))
	
next

iRtn = dw_1.SaveAs("", Clipboard!, False)

if iRtn <> 1 then 
	MessageBox(' 선택 오류! ', '선택시 오류가 발생하였습니다. 재선택 하세요!! ')
	Return 
End if

gs_gubun = 'Y'

Close(Parent)



end event

type dw_1 from w_inherite_popup`dw_1 within w_itemas_popup10_cic
integer x = 27
integer y = 360
integer width = 3479
integer height = 1436
integer taborder = 100
string dataobject = "d_itemas_popup10_detail_cic"
boolean hscrollbar = true
end type

event dw_1::itemchanged;call super::itemchanged;//String sData
//
//if Row < 1 then Return 
//
//sData = Trim(this.GetText())
//
//if this.GetColumnName() = 'flag' then 
//	
//	if sData = 'Y' then 
//		IF dw_1.GetItemString(Row, "itemas_useyn") = '2' then
//			f_message_chk(54, "[품번]")
//			Return 1
//		END IF
//	end if
//	
//end if
end event

event dw_1::rowfocuschanged;//REturn 
end event

event dw_1::clicked;Return
end event

type sle_2 from w_inherite_popup`sle_2 within w_itemas_popup10_cic
end type

type cb_1 from w_inherite_popup`cb_1 within w_itemas_popup10_cic
end type

type cb_return from w_inherite_popup`cb_return within w_itemas_popup10_cic
end type

type cb_inq from w_inherite_popup`cb_inq within w_itemas_popup10_cic
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_itemas_popup10_cic
end type

type st_1 from w_inherite_popup`st_1 within w_itemas_popup10_cic
end type

type dw_choose from datawindow within w_itemas_popup10_cic
boolean visible = false
integer x = 2583
integer y = 52
integer width = 82
integer height = 60
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_itemas_popup10_choose_cic"
boolean border = false
boolean livescroll = true
end type

type cbx_all from checkbox within w_itemas_popup10_cic
integer x = 2811
integer y = 276
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
string text = "전체선택"
end type

event clicked;Integer i

w_mdi_frame.sle_msg.text = '자료 선택 중...'
if cbx_all.Checked = True then
	FOR i =1 TO dw_1.Rowcount()
		dw_1.SetItem(i,"flag",'Y')
	NEXT
else
	FOR i =1 TO dw_1.Rowcount()
		dw_1.SetItem(i,"flag",'N')
	NEXT	
end if

w_mdi_frame.sle_msg.text = ''
end event

type rr_2 from roundrectangle within w_itemas_popup10_cic
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 14
integer y = 356
integer width = 3502
integer height = 1464
integer cornerheight = 40
integer cornerwidth = 55
end type

