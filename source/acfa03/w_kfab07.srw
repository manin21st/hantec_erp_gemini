$PBExportHeader$w_kfab07.srw
$PBExportComments$감가상각충당금명세서 조회 출력
forward
global type w_kfab07 from w_standard_print
end type
type st_wait from statictext within w_kfab07
end type
type em_yearmmdd from editmask within w_kfab07
end type
type st_1 from statictext within w_kfab07
end type
type st_2 from statictext within w_kfab07
end type
type rr_1 from roundrectangle within w_kfab07
end type
type rr_2 from roundrectangle within w_kfab07
end type
type ln_1 from line within w_kfab07
end type
end forward

global type w_kfab07 from w_standard_print
integer x = 0
integer y = 0
string title = "감가상각충당금명세서 조회 출력"
st_wait st_wait
em_yearmmdd em_yearmmdd
st_1 st_1
st_2 st_2
rr_1 rr_1
rr_2 rr_2
ln_1 ln_1
end type
global w_kfab07 w_kfab07

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String   sBaseYmd,sKfYear

w_mdi_frame.sle_msg.text =""

if NOT ISDATE(em_yearmmdd.text) Then
   F_MessageChk(21,'[기준일자]')
   em_yearmmdd.SetFocus()
   return -1
else
	sBaseYmd = Left(em_yearmmdd.text,4) + Mid(em_yearmmdd.text,6,2) + Right(em_yearmmdd.text,2)
end if

select kfyear		into :sKfYear		from kfa07om0;

dw_list.Reset()
if dw_print.Retrieve(sBaseYmd) <= 0 then
	F_MessageChk(14,'')
	em_yearmmdd.SetFocus()   
   return -1
end if
dw_print.sharedata(dw_list)
Return 1
end function

on w_kfab07.create
int iCurrent
call super::create
this.st_wait=create st_wait
this.em_yearmmdd=create em_yearmmdd
this.st_1=create st_1
this.st_2=create st_2
this.rr_1=create rr_1
this.rr_2=create rr_2
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_wait
this.Control[iCurrent+2]=this.em_yearmmdd
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.rr_1
this.Control[iCurrent+6]=this.rr_2
this.Control[iCurrent+7]=this.ln_1
end on

on w_kfab07.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_wait)
destroy(this.em_yearmmdd)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.rr_1)
destroy(this.rr_2)
destroy(this.ln_1)
end on

event open;call super::open;
dw_list.settransobject(sqlca)

em_yearmmdd.text = f_today()

end event

type p_preview from w_standard_print`p_preview within w_kfab07
end type

type p_exit from w_standard_print`p_exit within w_kfab07
end type

type p_print from w_standard_print`p_print within w_kfab07
end type

type p_retrieve from w_standard_print`p_retrieve within w_kfab07
end type





type dw_datetime from w_standard_print`dw_datetime within w_kfab07
integer taborder = 60
end type

type st_10 from w_standard_print`st_10 within w_kfab07
end type



type dw_print from w_standard_print`dw_print within w_kfab07
string dataobject = "dw_kfab07_p"
end type

type dw_ip from w_standard_print`dw_ip within w_kfab07
boolean visible = false
integer x = 1915
integer y = 2468
integer width = 41
integer height = 160
boolean enabled = false
string dataobject = "dw_kfab06_2"
boolean livescroll = false
end type

type dw_list from w_standard_print`dw_list within w_kfab07
integer x = 64
integer y = 232
integer width = 4503
integer height = 1952
string dataobject = "dw_kfab07"
boolean border = false
end type

type st_wait from statictext within w_kfab07
boolean visible = false
integer x = 37
integer y = 2208
integer width = 1952
integer height = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 32106727
long backcolor = 28144969
boolean enabled = false
string text = "마스타파일,  잔고파일, 변동파일을 읽어 계산을 수행하고 있습니다. 잠시만 기다리십시오 ! "
alignment alignment = center!
boolean border = true
long bordercolor = 255
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type em_yearmmdd from editmask within w_kfab07
integer x = 375
integer y = 88
integer width = 398
integer height = 56
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = stringmask!
string mask = "####.##.##"
boolean autoskip = true
end type

type st_1 from statictext within w_kfab07
integer x = 119
integer y = 88
integer width = 261
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 33027312
boolean enabled = false
string text = "기준일자"
alignment alignment = center!
long bordercolor = 65535
boolean focusrectangle = false
end type

type st_2 from statictext within w_kfab07
integer x = 69
integer y = 84
integer width = 73
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 33027312
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_kfab07
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 59
integer y = 32
integer width = 759
integer height = 168
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_kfab07
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 55
integer y = 224
integer width = 4567
integer height = 1996
integer cornerheight = 40
integer cornerwidth = 55
end type

type ln_1 from line within w_kfab07
integer linethickness = 1
integer beginx = 375
integer beginy = 152
integer endx = 777
integer endy = 152
end type

