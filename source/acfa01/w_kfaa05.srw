$PBExportHeader$w_kfaa05.srw
$PBExportComments$고정자산 회기 등록
forward
global type w_kfaa05 from w_inherite
end type
type em_year from editmask within w_kfaa05
end type
type st_2 from statictext within w_kfaa05
end type
type st_4 from statictext within w_kfaa05
end type
type st_5 from statictext within w_kfaa05
end type
type st_6 from statictext within w_kfaa05
end type
type st_3 from statictext within w_kfaa05
end type
type em_value from editmask within w_kfaa05
end type
type gb_1 from groupbox within w_kfaa05
end type
type rr_1 from roundrectangle within w_kfaa05
end type
end forward

global type w_kfaa05 from w_inherite
string title = "고정자산 회기 등록"
boolean controlmenu = false
boolean minbox = false
boolean resizable = true
em_year em_year
st_2 st_2
st_4 st_4
st_5 st_5
st_6 st_6
st_3 st_3
em_value em_value
gb_1 gb_1
rr_1 rr_1
end type
global w_kfaa05 w_kfaa05

event open;call super::open;Double   dAmount
String   sYear

sYear = left(f_today(), 4)
em_year.text = left(f_today(), 4)

select nvl(kfaras,0)		into :dAmount
	from kfa07om0
	where kfyear = :sYear;
	
em_value.text = String(dAmount)
	
em_year.SetFocus()
end event

on w_kfaa05.create
int iCurrent
call super::create
this.em_year=create em_year
this.st_2=create st_2
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_3=create st_3
this.em_value=create em_value
this.gb_1=create gb_1
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_year
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.em_value
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.rr_1
end on

on w_kfaa05.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_year)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_3)
destroy(this.em_value)
destroy(this.gb_1)
destroy(this.rr_1)
end on

type dw_insert from w_inherite`dw_insert within w_kfaa05
boolean visible = false
integer x = 46
integer y = 2572
integer taborder = 0
end type

type p_delrow from w_inherite`p_delrow within w_kfaa05
boolean visible = false
integer x = 3470
integer y = 2584
integer taborder = 0
end type

type p_addrow from w_inherite`p_addrow within w_kfaa05
boolean visible = false
integer x = 3296
integer y = 2584
integer taborder = 0
end type

type p_search from w_inherite`p_search within w_kfaa05
boolean visible = false
integer x = 2601
integer y = 2584
integer taborder = 0
end type

type p_ins from w_inherite`p_ins within w_kfaa05
boolean visible = false
integer x = 3122
integer y = 2584
integer taborder = 0
end type

type p_exit from w_inherite`p_exit within w_kfaa05
integer taborder = 50
end type

type p_can from w_inherite`p_can within w_kfaa05
integer taborder = 40
end type

event p_can::clicked;call super::clicked;string DYEAR

  SELECT "KFA07OM0"."KFYEAR"  
    INTO :DYEAR  
    FROM "KFA07OM0"  ;

if DYEAR  = "" then
   DYEAR  = String(Today(),"yyyy") 
end if

em_year.text = DYEAR 

w_mdi_frame.sle_msg.text = ""
end event

type p_print from w_inherite`p_print within w_kfaa05
boolean visible = false
integer x = 2775
integer y = 2584
integer taborder = 0
end type

type p_inq from w_inherite`p_inq within w_kfaa05
boolean visible = false
integer x = 2949
integer y = 2584
integer taborder = 0
end type

type p_del from w_inherite`p_del within w_kfaa05
boolean visible = false
integer x = 3662
integer y = 2592
integer taborder = 0
end type

type p_mod from w_inherite`p_mod within w_kfaa05
integer x = 4096
integer taborder = 30
end type

event p_mod::clicked;call super::clicked;string   DYEAR
Integer  iDses,iCount
Double   dAras

setpointer(hourglass!)
DYEAR = em_year.text
if isnull(DYEAR) or DYEAR < "1993" then
    F_MessageChk(1,'[고정자산회기]')
    w_mdi_frame.sle_msg.text = "회기는 보통 현재 년도입니다." 
	 em_year.SetFocus()
    return
end if

select nvl(d_ses,0) into :iDses from kfz08om0 where substr(dym00,1,4) = :Dyear;
if sqlca.sqlcode <> 0 or iDses = 0 or IsNull(iDses) then
	F_Messagechk(1,'[회기]')
	w_mdi_frame.sle_msg.text = "재무회계 회기를 등록하십시요." 
	em_year.SetFocus()
   return
end if

dAras = Double(em_value.text)
if isnull(dAras) or dAras < 0 then
    F_MessageChk(1,'[비망가액]')
    w_mdi_frame.sle_msg.text = "잔존가액은 현재 1000 으로 되어있습니다." 
	 em_value.SetFocus()
    return
end if

select Count(*) into :iCount from kfa07om0 ;
if sqlca.sqlcode = 0 then
	if IsNull(iCount) then iCount = 0
else
	iCount = 0
end if

if iCount = 0 then
	insert into kfa07om0
		(kfyear, 	kfaras,		kdses)
	values
		(:dYear,		:dAras,		:iDses);
else
	update kfa07om0
		set kfyear = :dYear,
			 kdses  = :iDses,
			 kfaras = :dAras;
end if
if SQLCA.SQLCODE <> 0 then
   F_MessageChk(13,'')
   return
end if
Commit;

w_mdi_frame.sle_msg.text = "저장되었습니다."
end event

type cb_exit from w_inherite`cb_exit within w_kfaa05
boolean visible = false
integer x = 3433
integer y = 2472
end type

type cb_mod from w_inherite`cb_mod within w_kfaa05
boolean visible = false
integer x = 2720
integer y = 2472
boolean default = true
end type

on cb_mod::clicked;call w_inherite`cb_mod::clicked;string DYEAR

setpointer(hourglass!)
DYEAR = em_year.text
if isnull(DYEAR) or DYEAR < "1993" then
    sle_msg.text = "회기는 보통 현재 년도입니다." 
    messagebox("확 인","고정자산 회기년도를 확인하시오. !!!")
    return
end if

  UPDATE "KFA07OM0"  
     SET "KFYEAR" = :DYEAR  ;

if SQLCA.SQLCODE <> 0 then
   messagebox("확 인",sqlca.sqlerrtext)
   return
end if

sle_msg.text = "수정이 완료되었습니다."
end on

type cb_ins from w_inherite`cb_ins within w_kfaa05
boolean visible = false
integer x = 562
integer y = 2748
boolean enabled = false
end type

type cb_del from w_inherite`cb_del within w_kfaa05
boolean visible = false
integer x = 914
integer y = 2748
boolean enabled = false
end type

type cb_inq from w_inherite`cb_inq within w_kfaa05
boolean visible = false
integer x = 1618
integer y = 2748
boolean enabled = false
end type

type cb_print from w_inherite`cb_print within w_kfaa05
boolean visible = false
integer x = 1266
integer y = 2748
boolean enabled = false
end type

type st_1 from w_inherite`st_1 within w_kfaa05
boolean visible = false
end type

type cb_can from w_inherite`cb_can within w_kfaa05
boolean visible = false
integer x = 3077
integer y = 2472
boolean cancel = true
end type

on cb_can::clicked;call w_inherite`cb_can::clicked;string DYEAR

  SELECT "KFA07OM0"."KFYEAR"  
    INTO :DYEAR  
    FROM "KFA07OM0"  ;

if DYEAR  = "" then
   DYEAR  = String(Today(),"yyyy") 
end if

em_year.text = DYEAR 

sle_msg.text = ""
end on

type cb_search from w_inherite`cb_search within w_kfaa05
boolean visible = false
integer x = 1774
integer y = 2960
boolean enabled = false
end type

type dw_datetime from w_inherite`dw_datetime within w_kfaa05
boolean visible = false
end type

type sle_msg from w_inherite`sle_msg within w_kfaa05
boolean visible = false
end type

type gb_10 from w_inherite`gb_10 within w_kfaa05
boolean visible = false
end type

type gb_button1 from w_inherite`gb_button1 within w_kfaa05
boolean visible = false
integer x = 2290
integer y = 2808
end type

type gb_button2 from w_inherite`gb_button2 within w_kfaa05
boolean visible = false
integer x = 2683
integer y = 2420
integer width = 1125
end type

type em_year from editmask within w_kfaa05
integer x = 1947
integer y = 724
integer width = 384
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type st_2 from statictext within w_kfaa05
integer x = 1431
integer y = 724
integer width = 507
integer height = 88
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
boolean enabled = false
string text = "고정자산회기"
alignment alignment = center!
long bordercolor = 128
boolean focusrectangle = false
end type

type st_4 from statictext within w_kfaa05
integer x = 1472
integer y = 1164
integer width = 1998
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
string text = "1. 고정자산에서 사용할 회기를 변경 저장한다.(년도로 입력한다.)"
boolean focusrectangle = false
end type

type st_5 from statictext within w_kfaa05
integer x = 1472
integer y = 1340
integer width = 1655
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
string text = "3. 고정자산 년이월처리시 자동변경된다."
boolean focusrectangle = false
end type

type st_6 from statictext within w_kfaa05
integer x = 1472
integer y = 1252
integer width = 1655
integer height = 52
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
string text = "2. 고정자산 등록 시 잔존년수계산의 기준이 된다."
boolean focusrectangle = false
end type

type st_3 from statictext within w_kfaa05
integer x = 2633
integer y = 724
integer width = 343
integer height = 60
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "비망가액"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_value from editmask within w_kfaa05
integer x = 2971
integer y = 724
integer width = 407
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 16777215
alignment alignment = right!
string mask = "##,##0"
end type

type gb_1 from groupbox within w_kfaa05
integer x = 891
integer y = 1040
integer width = 3099
integer height = 488
integer textsize = -10
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 28144969
long backcolor = 32106727
end type

type rr_1 from roundrectangle within w_kfaa05
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 581
integer y = 384
integer width = 3671
integer height = 1512
integer cornerheight = 40
integer cornerwidth = 55
end type

