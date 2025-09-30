$PBExportHeader$w_edus_popup.srw
$PBExportComments$교육계획 조회 선택
forward
global type w_edus_popup from window
end type
type p_5 from uo_picture within w_edus_popup
end type
type p_4 from uo_picture within w_edus_popup
end type
type p_3 from uo_picture within w_edus_popup
end type
type p_2 from uo_picture within w_edus_popup
end type
type p_1 from uo_picture within w_edus_popup
end type
type sle_empname from singlelineedit within w_edus_popup
end type
type st_4 from statictext within w_edus_popup
end type
type em_seq from editmask within w_edus_popup
end type
type dw_1 from u_d_popup_sort within w_edus_popup
end type
type st_2 from statictext within w_edus_popup
end type
type sle_empno from singlelineedit within w_edus_popup
end type
type st_1 from statictext within w_edus_popup
end type
type em_year from editmask within w_edus_popup
end type
type rr_1 from roundrectangle within w_edus_popup
end type
type rr_2 from roundrectangle within w_edus_popup
end type
end forward

global type w_edus_popup from window
integer x = 1294
integer y = 160
integer width = 2542
integer height = 2008
boolean titlebar = true
string title = "교육계획 조회 선택"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
p_5 p_5
p_4 p_4
p_3 p_3
p_2 p_2
p_1 p_1
sle_empname sle_empname
st_4 st_4
em_seq em_seq
dw_1 dw_1
st_2 st_2
sle_empno sle_empno
st_1 st_1
em_year em_year
rr_1 rr_1
rr_2 rr_2
end type
global w_edus_popup w_edus_popup

type variables
str_edu  istr_edu
end variables

on w_edus_popup.create
this.p_5=create p_5
this.p_4=create p_4
this.p_3=create p_3
this.p_2=create p_2
this.p_1=create p_1
this.sle_empname=create sle_empname
this.st_4=create st_4
this.em_seq=create em_seq
this.dw_1=create dw_1
this.st_2=create st_2
this.sle_empno=create sle_empno
this.st_1=create st_1
this.em_year=create em_year
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.p_5,&
this.p_4,&
this.p_3,&
this.p_2,&
this.p_1,&
this.sle_empname,&
this.st_4,&
this.em_seq,&
this.dw_1,&
this.st_2,&
this.sle_empno,&
this.st_1,&
this.em_year,&
this.rr_1,&
this.rr_2}
end on

on w_edus_popup.destroy
destroy(this.p_5)
destroy(this.p_4)
destroy(this.p_3)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.sle_empname)
destroy(this.st_4)
destroy(this.em_seq)
destroy(this.dw_1)
destroy(this.st_2)
destroy(this.sle_empno)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.rr_1)
destroy(this.rr_2)
end on

event open;
f_Window_Center_Response(This)

string sgbn, ls_empname

istr_edu = Message.PowerObjectParm

sgbn = istr_edu.str_gbn

sle_empno.text = istr_edu.str_empno
em_year.text = istr_edu.str_eduyear
em_seq.text = string(istr_edu.str_empseq)
 


dw_1.SetTransObject(SQLCA)
dw_1.Reset()

end event

event key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

type p_5 from uo_picture within w_edus_popup
integer x = 2286
integer width = 178
boolean originalsize = true
string picturename = "C:\Erpman\image\취소_up.gif"
end type

event clicked;call super::clicked;SetNull(gs_code)
SetNull(istr_edu.str_empno)
SetNull(istr_edu.str_eduyear)
SetNull(istr_edu.str_empseq)
SetNull(istr_edu.str_gbn)

Closewithreturn(Parent, istr_edu)
//close(Parent)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\취소_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\취소_dn.gif"
end event

type p_4 from uo_picture within w_edus_popup
integer x = 2112
integer width = 178
boolean originalsize = true
string picturename = "C:\Erpman\image\조회_up.gif"
end type

event clicked;String ls_empno, ls_eduyear, ls_gbn
long ll_seq1, ll_seq2, ls_empseq

ls_empno = sle_empno.text      // 사원번호
ls_eduyear = trim(em_year.text) +'%'  // 계획년도
ls_empseq = long(trim(em_seq.text))
ls_gbn = istr_edu.str_gbn

if ls_empno = '' or IsNull(ls_empno) then ls_empno = '%'
if IsNull(ls_empseq) or ls_empseq = 0 then
	ll_seq1 = 1
	ll_seq2 = 9999
else
	ll_seq1 = ls_empseq
	ll_seq2 = ls_empseq
end if

IF dw_1.Retrieve(gs_company, ls_empno , ls_eduyear, ll_seq1, ll_seq2) <=0 THEN
	MessageBox("확 인", "검색된 자료가 존재하지 ~r않습니다.!!")
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\조회_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\조회_dn.gif"
end event

type p_3 from uo_picture within w_edus_popup
integer x = 338
integer y = 1936
end type

type p_2 from uo_picture within w_edus_popup
integer x = 338
integer y = 1936
end type

type p_1 from uo_picture within w_edus_popup
integer x = 1938
integer width = 178
boolean originalsize = true
string picturename = "C:\Erpman\image\선택_up.gif"
end type

event clicked;call super::clicked;Long ll_row	

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. ~r 다시 선택한후 선택버튼을 누르십시오 !!")
   return
END IF

//gs_code          =      dw_1.GetItemString(ll_Row,"p5_educations_p_companycode")        // 계획년도
istr_edu.str_empno   = dw_1.GetItemString(ll_Row, "empno")
istr_edu.str_eduyear = dw_1.GetItemString(ll_Row,"eduyear")
istr_edu.str_empseq  = dw_1.GetItemNumber(ll_Row,"empseq")
istr_edu.str_sdate   = dw_1.GetItemString(ll_Row,"restartdate")
istr_edu.str_edate   = dw_1.GetItemString(ll_Row,"reenddate")

istr_edu.str_gbn     = dw_1.GetItemString(ll_Row,"bgubn")
istr_edu.str_prostate= dw_1.GetItemString(ll_Row,"prostate")
istr_edu.str_empname   = dw_1.GetItemString(ll_row,"empname")

Closewithreturn(Parent, istr_edu)
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\선택_up.gif"
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\선택_dn.gif"
end event

type sle_empname from singlelineedit within w_edus_popup
boolean visible = false
integer x = 1518
integer y = 80
integer width = 283
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
integer limit = 20
boolean displayonly = true
end type

type st_4 from statictext within w_edus_popup
integer x = 713
integer y = 60
integer width = 247
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "일련번호"
boolean focusrectangle = false
end type

type em_seq from editmask within w_edus_popup
integer x = 960
integer y = 52
integer width = 283
integer height = 56
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = stringmask!
string mask = "####"
end type

type dw_1 from u_d_popup_sort within w_edus_popup
event ue_pressenter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 46
integer y = 176
integer width = 2414
integer height = 1684
integer taborder = 30
string dataobject = "d_edus_popup"
boolean vscrollbar = true
boolean border = false
end type

event ue_pressenter;
p_1.TriggerEvent(Clicked!)
end event

event ue_key;choose case key
	case keypageup!
		dw_1.scrollpriorpage()
	case keypagedown!
		dw_1.scrollnextpage()
	case keyhome!
		dw_1.scrolltorow(1)
	case keyend!
		dw_1.scrolltorow(dw_1.rowcount())
end choose
end event

event rowfocuschanged;
dw_1.SelectRow(0,False)
dw_1.SelectRow(currentrow,True)

dw_1.ScrollToRow(currentrow)
end event

event clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
	b_flag = False

   em_year.text = dw_1.GetItemString(row,"eduyear")        // 계획년도	
	em_seq.text = string(dw_1.GetItemNumber(row, "empseq"))
	
END IF

CALL SUPER ::CLICKED


end event

event doubleclicked;IF Row = 0 THEN
   MessageBox("확 인", "선택값이 없습니다. ~r다시 선택한후 ok 버튼을 누르십시오 !")
   return
END IF

//gs_code     = dw_1.GetItemString(row,"p5_educations_p_companycode")        // 계획년도
istr_edu.str_empno  = dw_1.GetItemString(row,"empno")
istr_edu.str_eduyear   = dw_1.GetItemString(row,"eduyear")
istr_edu.str_empseq    = dw_1.GetItemNumber(row,"empseq")
istr_edu.str_sdate     = dw_1.GetItemString(row,"restartdate")
istr_edu.str_edate     = dw_1.GetItemString(row,"reenddate")

istr_edu.str_gbn       = dw_1.GetItemString(row,"bgubn")
istr_edu.str_eduno     = dw_1.GetItemString(row,"eduno")
istr_edu.str_eduamt    = dw_1.GetItemNumber(row,"eduamt")
istr_edu.str_cjamt     = dw_1.GetItemNumber(row,"rebackamt")

istr_edu.str_prostate  = dw_1.GetItemString(row,"prostate")
istr_edu.str_empname   = dw_1.GetItemString(row,"empname")

Closewithreturn(Parent, istr_edu)

end event

type st_2 from statictext within w_edus_popup
boolean visible = false
integer x = 1403
integer y = 208
integer width = 142
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
string text = "사번"
boolean focusrectangle = false
end type

type sle_empno from singlelineedit within w_edus_popup
boolean visible = false
integer x = 1545
integer y = 204
integer width = 283
integer height = 56
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
boolean autohscroll = false
integer limit = 6
boolean displayonly = true
end type

event modified;string sempno, ls_empname

sempno = this.text

 SELECT "P1_MASTER"."EMPNAME"  
    INTO :ls_empname  
    FROM "P1_MASTER"  
   WHERE ( "P1_MASTER"."COMPANYCODE" = :gs_company ) AND  
         ( "P1_MASTER"."EMPNO" = :sempno )   ;
if sqlca.sqlcode = 0 then
	sle_empname.text = ls_empname
else
	sle_empname.text = ""
end if
end event

type st_1 from statictext within w_edus_popup
integer x = 128
integer y = 60
integer width = 242
integer height = 64
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 33027312
boolean enabled = false
string text = "계획년도"
boolean focusrectangle = false
end type

type em_year from editmask within w_edus_popup
integer x = 370
integer y = 52
integer width = 251
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 16777215
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
string mask = "####"
end type

type rr_1 from roundrectangle within w_edus_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 37
integer y = 12
integer width = 1330
integer height = 144
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_edus_popup
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 168
integer width = 2441
integer height = 1708
integer cornerheight = 40
integer cornerwidth = 55
end type

