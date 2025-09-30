$PBExportHeader$w_pdt_06050.srw
$PBExportComments$** 점검 및 수리 결과 내역 등록(메뉴에서 삭제)
forward
global type w_pdt_06050 from w_inherite
end type
type gb_4 from groupbox within w_pdt_06050
end type
type gb_3 from groupbox within w_pdt_06050
end type
type gb_1 from groupbox within w_pdt_06050
end type
type dw_ins1 from u_key_enter within w_pdt_06050
end type
end forward

global type w_pdt_06050 from w_inherite
WindowType WindowType=response!
boolean TitleBar=true
string Title=" 점검 및 수리 결과 내역 등록"
string MenuName=""
long BackColor=12632256
boolean MinBox=false
boolean MaxBox=false
gb_4 gb_4
gb_3 gb_3
gb_1 gb_1
dw_ins1 dw_ins1
end type
global w_pdt_06050 w_pdt_06050

on w_pdt_06050.create
int iCurrent
call super::create
this.gb_4=create gb_4
this.gb_3=create gb_3
this.gb_1=create gb_1
this.dw_ins1=create dw_ins1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_4
this.Control[iCurrent+2]=this.gb_3
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_ins1
end on

on w_pdt_06050.destroy
call super::destroy
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.dw_ins1)
end on

event open;call super::open;String s_param

dw_insert.SetTransObject(SQLCA)
dw_ins1.SetTransObject(SQLCA)

dw_insert.Setredraw(False)
dw_insert.ReSet()
//dw_insert.InsertRow(0)
dw_insert.Setredraw(True)

dw_ins1.Setredraw(False)
dw_ins1.ReSet()
dw_ins1.InsertRow(0)
dw_ins1.Setredraw(True)

s_param = Message.StringParm

if IsNull(s_param) or s_param = "" or s_param = "w_pdt_06050" then
	dw_ins1.SetColumn("sidat")
	dw_ins1.SetFocus()
else
	dw_ins1.object.sidat[1] = Mid(s_param,1,8)
	dw_ins1.object.mchno[1] = Trim(Mid(s_param,9,6))
	dw_ins1.object.mchnam[1] = Trim(Mid(s_param,15,30))
	cb_inq.TriggerEvent(Clicked!)
end if	


end event

type dw_insert from w_inherite`dw_insert within w_pdt_06050
int X=37
int Y=224
int Width=3552
int Height=1652
int TabOrder=30
string DataObject="d_pdt_06050_02"
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
end type

event dw_insert::itemerror;return 1
end event

event dw_insert::ue_pressenter;if this.GetColumnName() = "rmks" then return

Send(Handle(this),256,9,0)
Return 1
end event

event dw_insert::getfocus;call super::getfocus;f_toggle_kor(handle(this))
end event

event dw_insert::losefocus;call super::losefocus;f_toggle_eng(handle(this))
end event

type cb_exit from w_inherite`cb_exit within w_pdt_06050
int X=3227
int Y=1936
end type

type cb_mod from w_inherite`cb_mod within w_pdt_06050
int X=1623
int Y=1936
int TabOrder=40
end type

event cb_mod::clicked;call super::clicked;if f_msg_update() = -1 then return
if dw_insert.AcceptText() = -1 then return
IF dw_insert.Update() > 0 THEN
	COMMIT;
	sle_msg.Text = "저장 되었습니다!"
	cb_del.Enabled = True
ELSE
	ROLLBACK;
	f_message_chk(32, "[저장실패]")
	sle_msg.Text = "저장작업 실패!"
END IF

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_ins from w_inherite`cb_ins within w_pdt_06050
int X=503
int Y=2104
int TabOrder=60
boolean Visible=false
end type

type cb_del from w_inherite`cb_del within w_pdt_06050
int X=1275
int Y=1936
int TabOrder=70
end type

event cb_del::clicked;call super::clicked;if f_msg_delete() = -1 then return

dw_insert.Setredraw(False)
dw_insert.DeleteRow(1)

if dw_insert.Update() <> 1 then
   ROLLBACK;
   f_message_chk(31,'[삭제실패 : 점검/수리 결과 내역 등록]') 
   sle_msg.Text = "삭제 작업 실패!"
   dw_insert.Setredraw(True)
	Return
else
   COMMIT;
	dw_insert.InsertRow(0)
	dw_insert.object.sabu[1] = gs_sabu
	dw_insert.object.sidat[1] = dw_ins1.object.sidat[1]
	dw_insert.object.mchno[1] = dw_ins1.object.mchno[1]
end if

dw_insert.Setredraw(True)
sle_msg.Text = "삭제 되었습니다!"
cb_del.Enabled = False
dw_insert.SetColumn("rmks")
dw_insert.SetFocus()

end event

type cb_inq from w_inherite`cb_inq within w_pdt_06050
int X=73
int Y=1936
int TabOrder=20
end type

event cb_inq::clicked;call super::clicked;String sidat, mchno, s_stopdat

if dw_ins1.AcceptText() = -1 then return
sidat = dw_ins1.object.sidat[1]
mchno = dw_ins1.object.mchno[1]

if IsNull(sidat) or sidat = "" then
	f_message_chk(30, "[실시일자]")
	dw_ins1.SetColumn("sidat")
	dw_ins1.SetFocus()
   return
end if
if IsNull(mchno) or mchno = "" then
	f_message_chk(30, "[관리번호]")
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
   return
end if

//사용중지일자 확인
select stopdat into :s_stopdat from mchmst
 where sabu = :gs_sabu and mchno = :mchno;
if sqlca.sqlcode <> 0 or (not (IsNull(s_stopdat) or s_stopdat = "")) then
	MessageBox("사용중지일자 확인", String(s_stopdat,"@@@@.@@.@@") + " 일자로 사용 중지된 설비 입니다!")
	dw_ins1.object.mchno[1] = ""
   dw_ins1.object.mchnam[1] = ""
	dw_ins1.SetColumn("mchno")
	dw_ins1.SetFocus()
	return
end if	

dw_insert.Setredraw(False)
if dw_insert.Retrieve(gs_sabu, sidat, mchno) < 1 then
	cb_del.Enabled = False
	dw_insert.Setredraw(False)
	dw_insert.InsertRow(0)
	dw_insert.Setredraw(True)
	sle_msg.text = "신규로 등록하세요!"
	dw_insert.object.sabu[1] = gs_sabu
	dw_insert.object.sidat[1] = sidat
	dw_insert.object.mchno[1] = mchno
	dw_insert.SetColumn("rmks")
	dw_insert.SetFocus()
else
	cb_del.Enabled = True
	sle_msg.text = ""
	dw_insert.SetColumn("rmks")
	dw_insert.SetFocus()
end if	
dw_insert.Setredraw(True)
end event

type cb_print from w_inherite`cb_print within w_pdt_06050
int X=869
int Y=2096
int TabOrder=90
boolean Visible=false
end type

type st_1 from w_inherite`st_1 within w_pdt_06050
long BackColor=12632256
end type

type cb_can from w_inherite`cb_can within w_pdt_06050
int X=1970
int Y=1936
int TabOrder=50
end type

event cb_can::clicked;call super::clicked;sle_msg.text =""
IF wf_warndataloss("취소") = -1 THEN RETURN //변경된 자료 체크 

dw_insert.SetRedraw(False)
dw_insert.Reset()
dw_insert.InsertRow(0)
dw_insert.SetRedraw(True)

dw_ins1.SetRedraw(False)
dw_ins1.Reset()
dw_ins1.InsertRow(0)
dw_ins1.SetRedraw(True)
dw_ins1.SetFocus()

ib_any_typing = False //입력필드 변경여부 No
end event

type cb_search from w_inherite`cb_search within w_pdt_06050
int X=1920
int Y=2364
int Width=334
int TabOrder=100
boolean Visible=false
string Text="IMAGE"
end type

type sle_msg from w_inherite`sle_msg within w_pdt_06050
long BackColor=12632256
end type

type gb_10 from w_inherite`gb_10 within w_pdt_06050
long BackColor=12632256
end type

type gb_4 from groupbox within w_pdt_06050
int X=37
int Y=1868
int Width=407
int Height=200
int TabOrder=40
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_3 from groupbox within w_pdt_06050
int X=1243
int Y=1868
int Width=1088
int Height=200
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type gb_1 from groupbox within w_pdt_06050
int X=3195
int Y=1868
int Width=398
int Height=200
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=67108864
int TextSize=-12
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_ins1 from u_key_enter within w_pdt_06050
event ue_key pbm_dwnkey
int X=37
int Y=28
int Width=1509
int Height=192
int TabOrder=10
boolean BringToTop=true
string DataObject="d_pdt_06050_01"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
boolean LiveScroll=false
end type

event ue_key;IF keydown(keyF1!) THEN
	TriggerEvent(RbuttonDown!)
END IF
end event

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)

IF	this.getcolumnname() = "mchno" THEN		
	open(w_mchno_popup)
	this.SetItem(1, "mchno", gs_code)
	this.SetItem(1, "mchnam", gs_codename)
END IF
end event

event itemerror;return 1
end event

event itemchanged;String s_cod, s_nam

s_cod = Trim(this.GetText())

if	this.getcolumnname() = "mchno" then
	select mchnam into :s_nam from mchmst
	 where sabu = :gs_sabu and mchno = :s_cod;
	 
	if sqlca.sqlcode <> 0 then
		f_message_chk(33,"[관리번호]")
		this.object.mchnam[1] = ""
		return 1
	else	
		this.object.mchnam[1] = s_nam
	end if	
elseif this.getcolumnname() = "sidat" then	
	if f_datechk(s_cod) = -1 then
		f_message_chk(35, "[실시일자]")
		this.object.sidat[1] = ""
		return 1
	end if
end if

return
end event

event getfocus;call super::getfocus;dw_insert.SetReDraw(False)
dw_insert.ReSet()
dw_insert.SetReDraw(True)
end event

