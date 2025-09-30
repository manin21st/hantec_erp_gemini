$PBExportHeader$w_modify_pass.srw
$PBExportComments$비밀번호 변경등록
forward
global type w_modify_pass from window
end type
type st_5 from statictext within w_modify_pass
end type
type p_exit from uo_picture within w_modify_pass
end type
type p_ok from uo_picture within w_modify_pass
end type
type sle_4 from singlelineedit within w_modify_pass
end type
type st_4 from statictext within w_modify_pass
end type
type sle_3 from singlelineedit within w_modify_pass
end type
type st_3 from statictext within w_modify_pass
end type
type sle_2 from singlelineedit within w_modify_pass
end type
type st_2 from statictext within w_modify_pass
end type
type st_1 from statictext within w_modify_pass
end type
type em_1 from editmask within w_modify_pass
end type
type rr_1 from roundrectangle within w_modify_pass
end type
type rr_2 from roundrectangle within w_modify_pass
end type
end forward

global type w_modify_pass from window
integer width = 4658
integer height = 2440
boolean titlebar = true
string title = "비밀번호 변경"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 32106727
st_5 st_5
p_exit p_exit
p_ok p_ok
sle_4 sle_4
st_4 st_4
sle_3 sle_3
st_3 st_3
sle_2 sle_2
st_2 st_2
st_1 st_1
em_1 em_1
rr_1 rr_1
rr_2 rr_2
end type
global w_modify_pass w_modify_pass

event open;//f_window_center(this)

em_1.Text = gs_userid

SetNull(sle_2.text)
SetNull(sle_3.text)
SetNull(sle_4.text)

sle_2.SetFocus()
end event

on w_modify_pass.create
this.st_5=create st_5
this.p_exit=create p_exit
this.p_ok=create p_ok
this.sle_4=create sle_4
this.st_4=create st_4
this.sle_3=create sle_3
this.st_3=create st_3
this.sle_2=create sle_2
this.st_2=create st_2
this.st_1=create st_1
this.em_1=create em_1
this.rr_1=create rr_1
this.rr_2=create rr_2
this.Control[]={this.st_5,&
this.p_exit,&
this.p_ok,&
this.sle_4,&
this.st_4,&
this.sle_3,&
this.st_3,&
this.sle_2,&
this.st_2,&
this.st_1,&
this.em_1,&
this.rr_1,&
this.rr_2}
end on

on w_modify_pass.destroy
destroy(this.st_5)
destroy(this.p_exit)
destroy(this.p_ok)
destroy(this.sle_4)
destroy(this.st_4)
destroy(this.sle_3)
destroy(this.st_3)
destroy(this.sle_2)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_1)
destroy(this.rr_1)
destroy(this.rr_2)
end on

type st_5 from statictext within w_modify_pass
integer x = 1513
integer y = 536
integer width = 1586
integer height = 64
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 32106727
string text = "※ 비밀번호는 대/소문자에 유의 하십시오."
boolean focusrectangle = false
end type

type p_exit from uo_picture within w_modify_pass
integer x = 2816
integer y = 1312
integer width = 178
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event clicked;CLOSE(PARENT)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

type p_ok from uo_picture within w_modify_pass
integer x = 2629
integer y = 1312
integer width = 178
boolean originalsize = true
string picturename = "C:\erpman\image\확인_up.gif"
end type

event clicked;call super::clicked;String    pass,ls_sle_1, ls_sle_2, ls_sle_3, ls_sle_4
Long      lMaxNo
DateTime  dt_Cur

ls_sle_1 = Trim(em_1.TEXT)
ls_sle_2 = Trim(sle_2.TEXT)
ls_sle_3 = Trim(sle_3.TEXT)
ls_sle_4 = Trim(sle_4.TEXT)

IF ls_sle_1 = "" OR IsNull(ls_sle_1) THEN
	F_Message_Chk(30,'[사용자번호]')
	em_1.SetFocus()
	Return
END IF

IF ls_sle_2 = "" OR IsNull(ls_sle_2) THEN
	F_Message_Chk(30,'[비밀번호]')
	sle_2.SetFocus()
	Return	
ELSE
	SELECT "LOGIN_T"."L_PASSWORD"  
  	  INTO :pass  
  	  FROM "LOGIN_T"  
 	 WHERE "LOGIN_T"."L_USERID"  = :ls_sle_1   ;
		 
	if SQLCA.SQLCode <> 0 then
		F_Message_Chk(33,'[사용자번호]')
		em_1.Text = ""	
		em_1.SetFocus()
		return
	else	
		if pass <> ls_sle_2 then 
			F_Message_Chk(33,'[비밀번호]')
			sle_2.Text = ""	
			sle_2.SetFocus()
			return
		end if
	END IF
END IF

IF ls_sle_3 = "" OR IsNull(ls_sle_3) THEN
	F_Message_Chk(30,'[새 비밀번호]')
	sle_3.SetFocus()
	Return	
END IF

IF ls_sle_4 = "" OR IsNull(ls_sle_4) THEN
	F_Message_Chk(30,'[확 인]')
	sle_4.SetFocus()
	Return	
END IF

IF ls_sle_3 <> ls_sle_4 THEN
	MessageBox("확 인","비밀번호가 틀렸습니다. 다시 입력하십시요!!")
	sle_4.text = ''
	sle_4.SetFocus()
	Return	
END IF

SELECT SYSDATE INTO :dt_cur FROM DUAL;

IF ls_sle_2 <> ls_sle_3 THEN						/*비밀번호 변경시*/
	SELECT MAX("PASSHST"."SEQNO")  
     INTO :lMaxNo  
     FROM "PASSHST"  
    WHERE "PASSHST"."USERID" = :ls_sle_1    ;
	 
	IF SQLCA.SQLCODE <> 0 THEN 
		lMaxNo = 0
	ELSE
		IF IsNull(lMaxNo) THEN lMaxNo = 0	
	END IF
	lMaxNo = lMaxNo + 1
	
	INSERT INTO "PASSHST"  
   	( "USERID",          "SEQNO",   	"PASSWORDOLD",   	"PASSWORDNEW",   "CHGDATE" )  	
 	VALUES 
	 	( :ls_sle_1,			:lMaxNo,		:ls_sle_2,   		:ls_sle_4,   	  :dt_cur)  ;
		 
	IF SQLCA.SQLCODE <> 0 THEN
		F_Message_Chk(32,'[비밀번호변경내역]')
		Rollback;
		Return
	ELSE
		UPDATE "LOGIN_T"  
		   SET "L_PASSWORD" = :ls_sle_4  
		 WHERE "L_USERID" = :ls_sle_1   ;
	END IF
END IF
COMMIT;

close(parent)	

end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = 'C:\erpman\image\확인_dn.gif'
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = 'C:\erpman\image\확인_up.gif'
end event

type sle_4 from singlelineedit within w_modify_pass
event ue_key pbm_keydown
integer x = 2290
integer y = 1116
integer width = 549
integer height = 88
integer taborder = 30
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 12639424
boolean autohscroll = false
boolean password = true
integer limit = 20
end type

event ue_key;if key = KeyEnter! then
	p_ok.setfocus()
end if
end event

event modified;string sPassNew,sPassOk

if isnull(trim(em_1.text)) or trim(em_1.text) = "" then
	F_Message_Chk(30,'[사용자번호]')
	sle_4.text = ''
	em_1.SetFocus()
	Return 1
end if	

sPassNew = Trim(sle_3.Text)
IF sPassNew = "" OR IsNull(sPassNew) THEN
	F_Message_Chk(30,'[새 비밀번호]')
	sle_4.text = ''
	sle_3.SetFocus()
	Return 1
END IF

sPassOk = Trim(sle_4.Text)
IF sPassOk = "" OR IsNull(sPassOk) THEN
	F_Message_Chk(30,'[확 인]')
	sle_4.SetFocus()
	Return 1
ELSE
	IF sPassNew <> sPassOk THEN
		MessageBox("확 인","비밀번호가 틀렸습니다. 다시 입력하십시요!!")
		sle_4.text = ''
		sle_4.SetFocus()
		Return 1	 
	END IF
END IF

end event

type st_4 from statictext within w_modify_pass
integer x = 1723
integer y = 1128
integer width = 448
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "확        인"
alignment alignment = center!
long bordercolor = 25231232
boolean focusrectangle = false
end type

type sle_3 from singlelineedit within w_modify_pass
event ue_key pbm_keydown
integer x = 2290
integer y = 1004
integer width = 549
integer height = 88
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 12639424
boolean autohscroll = false
boolean password = true
integer limit = 20
end type

event ue_key;if key = KeyEnter! then
	sle_4.setfocus()
end if
end event

event modified;string sPassOld

if isnull(trim(em_1.text)) or trim(em_1.text) = "" then
	F_Message_Chk(30,'[사용자번호]')
	sle_3.Text = ""	
	em_1.SetFocus()
	Return 1
end if	

sPassOld = Trim(sle_2.Text)
IF sPassOld = "" OR IsNull(sPassOld) THEN
	F_Message_Chk(30,'[비밀번호]')
	sle_3.Text = ""	
	sle_2.SetFocus()
	Return 1
END IF
end event

type st_3 from statictext within w_modify_pass
integer x = 1723
integer y = 1016
integer width = 443
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "새  비밀번호"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_2 from singlelineedit within w_modify_pass
event ue_key pbm_keydown
integer x = 2290
integer y = 892
integer width = 549
integer height = 88
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 12639424
boolean password = true
integer limit = 20
end type

event ue_key;if key = KeyEnter! then
	sle_3.setfocus()
end if
end event

event modified;string pass, ls_sle_2, sUser 

sUser = trim(em_1.text)

if isnull(sUser) or trim(sUser) = "" then
	F_Message_Chk(30,'[사용자번호]')
	sle_2.Text = ""	
	em_1.SetFocus()
	Return 1
end if	

ls_sle_2 = trim(sle_2.text)

SELECT "L_PASSWORD"  
  INTO :pass  
  FROM "LOGIN_T"  
 WHERE "L_USERID" = :sUser  ;

if SQLCA.SQLCode <> 0 then
	F_Message_Chk(33,'[사용자번호]')
	sle_2.Text = ""	
	em_1.SetFocus()
	return 1
else
   if pass <> ls_sle_2 then 
		F_Message_Chk(33,'[비밀번호]')
		sle_2.Text = ""	
		sle_2.SetFocus()
		return 1
	end if
end if
end event

type st_2 from statictext within w_modify_pass
integer x = 1723
integer y = 904
integer width = 443
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "이전비밀번호"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_modify_pass
integer x = 1723
integer y = 700
integer width = 443
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 33027312
boolean enabled = false
string text = "사용자  ID"
alignment alignment = center!
long bordercolor = 25231232
boolean focusrectangle = false
end type

type em_1 from editmask within w_modify_pass
integer x = 2290
integer y = 684
integer width = 549
integer height = 100
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16777215
long backcolor = 8421504
alignment alignment = center!
textcase textcase = upper!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
string mask = "!!!!!!!!!!!!!!!!!!!!"
end type

event modified;//string pass, sUser 
//
//sUser = trim(em_1.text)
//
//if isnull(sUser) or trim(sUser) = "" then
//	Return
//end if	
//
//SELECT "L_PASSWORD"  
//  INTO :pass  
//  FROM "LOGIN_T"  
// WHERE "L_USERID" = :sUser  ;
//
//if SQLCA.SQLCode <> 0 then
//	F_Message_Chk(33,'[사용자번호]')
//	em_1.Text = ""	
//	em_1.SetFocus()
//	return
//end if
//
//
end event

type rr_1 from roundrectangle within w_modify_pass
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1531
integer y = 620
integer width = 1504
integer height = 216
integer cornerheight = 40
integer cornerwidth = 55
end type

type rr_2 from roundrectangle within w_modify_pass
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 33027312
integer x = 1531
integer y = 852
integer width = 1504
integer height = 436
integer cornerheight = 40
integer cornerwidth = 55
end type

