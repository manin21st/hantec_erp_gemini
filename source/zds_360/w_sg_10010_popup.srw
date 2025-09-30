$PBExportHeader$w_sg_10010_popup.srw
forward
global type w_sg_10010_popup from window
end type
type p_2 from picture within w_sg_10010_popup
end type
type p_1 from picture within w_sg_10010_popup
end type
type cb_2 from commandbutton within w_sg_10010_popup
end type
type rb_2 from radiobutton within w_sg_10010_popup
end type
type rb_1 from radiobutton within w_sg_10010_popup
end type
type cb_1 from commandbutton within w_sg_10010_popup
end type
type st_3 from statictext within w_sg_10010_popup
end type
type sle_2 from singlelineedit within w_sg_10010_popup
end type
type st_2 from statictext within w_sg_10010_popup
end type
type st_1 from statictext within w_sg_10010_popup
end type
type sle_1 from singlelineedit within w_sg_10010_popup
end type
type gb_1 from groupbox within w_sg_10010_popup
end type
type gb_2 from groupbox within w_sg_10010_popup
end type
type gb_3 from groupbox within w_sg_10010_popup
end type
end forward

global type w_sg_10010_popup from window
integer width = 1426
integer height = 836
boolean titlebar = true
string title = "사용자 변경 및 복사"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
string icon = "AppIcon!"
boolean center = true
p_2 p_2
p_1 p_1
cb_2 cb_2
rb_2 rb_2
rb_1 rb_1
cb_1 cb_1
st_3 st_3
sle_2 sle_2
st_2 st_2
st_1 st_1
sle_1 sle_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_sg_10010_popup w_sg_10010_popup

forward prototypes
public subroutine wf_copy ()
public subroutine wf_chg ()
end prototypes

public subroutine wf_copy ();String ls_old
String ls_new

ls_old = sle_1.Text
ls_new = sle_2.Text

//기본정보 복사
INSERT INTO SG_EMPPC
  SELECT :ls_new, 
			DEPT, 
			WINPW, 
			HOT_LINE, 
			IP_ADD, 
			ERPPW, 
			GWPW, 
			CMOSPW, 
			CMOSCPW, 
			ADMINPW, 
			NET_ID, 
			GW_ID, 
			CRT_DATE, 
			CRT_TIME, 
			CRT_USER, 
			UPD_DATE, 
			UPD_TIME, 
			UPD_USER
    FROM SG_EMPPC
	WHERE EMPNO = :ls_old ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('복사 오류 : sg_emppc', '자료 복사 중 오류 발생')
	Return
End If

//소프트웨어 정보 복사
INSERT INTO SG_SW
  SELECT	:ls_new, 
			SEQ, 
			SERKEY, 
			SWNAM, 
			MAKER, 
			USED, 
			LIMIT, 
			SET_DATE, 
			CRT_DATE, 
			CRT_TIME, 
			CRT_USER, 
			UPD_DATE, 
			UPD_TIME, 
			UPD_USER
    FROM SG_SW
	WHERE EMPNO = :ls_old ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('복사 오류 : sg_sw', '자료 복사 중 오류 발생')
	Return
End If

//하드웨어 정보 복사
INSERT INTO SG_HW
  SELECT	:ls_new, 
			SEQ, 
			JASAN, 
			HWNAM, 
			MAKER, 
			SPEC, 
			LIMIT, 
			SET_DATE, 
			CRT_DATE, 
			CRT_TIME, 
			CRT_USER, 
			UPD_DATE, 
			UPD_TIME, 
			UPD_USER
    FROM SG_HW
	WHERE EMPNO = :ls_old ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('복사 오류 : sg_hw', '자료 복사 중 오류 발생')
	Return
End If


If SQLCA.SQLCODE = 0 Then
	COMMIT USING SQLCA;
	MessageBox('복사 성공', ls_old + '에서 ' + ls_new + '로(으로) 복사 되었습니다.')
Else
	MessageBox('SQLCA.SQLERRCODE : ' + String(SQLCA.SQLCODE), SQLCA.SQLERRTEXT)
	ROLLBACK USING SQLCA;
	MessageBox('복사 오류', '자료 복사 중 오류 발생')
	Return
End If





end subroutine

public subroutine wf_chg ();String ls_old
String ls_new

ls_old = sle_1.Text
ls_new = sle_2.Text

//기존 사번을 임의의 사번으로 변경
UPDATE SG_EMPPC
   SET EMPNO = '9999'
 WHERE EMPNO = :ls_old ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('변경실패', '자료 변경 중 오류가 발생했습니다.')
	Return
End If

UPDATE SG_SW
   SET EMPNO = '9999'
 WHERE EMPNO = :ls_old ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('변경실패', '자료 변경 중 오류가 발생했습니다.')
	Return
End If

UPDATE SG_HW
   SET EMPNO = '9999'
 WHERE EMPNO = :ls_old ;
If SQLCA.SQLCODE <> 0 Then
	ROLLBACK USING SQLCA;
	MessageBox('변경실패', '자료 변경 중 오류가 발생했습니다.')
	Return
End If

end subroutine

on w_sg_10010_popup.create
this.p_2=create p_2
this.p_1=create p_1
this.cb_2=create cb_2
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_1=create cb_1
this.st_3=create st_3
this.sle_2=create sle_2
this.st_2=create st_2
this.st_1=create st_1
this.sle_1=create sle_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.Control[]={this.p_2,&
this.p_1,&
this.cb_2,&
this.rb_2,&
this.rb_1,&
this.cb_1,&
this.st_3,&
this.sle_2,&
this.st_2,&
this.st_1,&
this.sle_1,&
this.gb_1,&
this.gb_2,&
this.gb_3}
end on

on w_sg_10010_popup.destroy
destroy(this.p_2)
destroy(this.p_1)
destroy(this.cb_2)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.sle_2)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

type p_2 from picture within w_sg_10010_popup
integer x = 937
integer y = 420
integer width = 59
integer height = 56
string picturename = "C:\ERPMAN\image\pop_3.jpg"
boolean focusrectangle = false
end type

type p_1 from picture within w_sg_10010_popup
integer x = 192
integer y = 420
integer width = 59
integer height = 56
string picturename = "C:\ERPMAN\image\pop_3.jpg"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_sg_10010_popup
integer x = 1125
integer y = 604
integer width = 247
integer height = 108
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "닫기"
end type

event clicked;Close(Parent)
end event

type rb_2 from radiobutton within w_sg_10010_popup
integer x = 654
integer y = 124
integer width = 457
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
boolean enabled = false
string text = "사용자 변경"
end type

type rb_1 from radiobutton within w_sg_10010_popup
integer x = 119
integer y = 124
integer width = 457
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 32106727
string text = "사용자 복사"
boolean checked = true
end type

type cb_1 from commandbutton within w_sg_10010_popup
integer x = 878
integer y = 604
integer width = 247
integer height = 108
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "처리"
end type

event clicked;If rb_1.Checked Then
	If MessageBox('복사확인', '복사 대상의 사번은 미 등록된 사용자만 가능 합니다.~r~n자료를 복사 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return
	wf_copy()
Else
	If MessageBox('변경확인', '변경 대상의 사번은 등록된 사용자만 가능 합니다.~r~n자료를 변경 하시겠습니까?', Question!, YesNo!, 2) <> 1 Then Return
	//wf_chg()
End If




end event

type st_3 from statictext within w_sg_10010_popup
integer x = 658
integer y = 424
integer width = 119
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8421504
long backcolor = 32106727
string text = "》》"
boolean focusrectangle = false
end type

type sle_2 from singlelineedit within w_sg_10010_popup
integer x = 1001
integer y = 412
integer width = 302
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
end type

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

String ls_data

Open(w_sawon_popup)
If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
SELECT DEPTCODE
  INTO :ls_data
  FROM P1_MASTER
 WHERE EMPNO = :gs_code ;
			
This.Text = gs_code

end event

type st_2 from statictext within w_sg_10010_popup
integer x = 818
integer y = 428
integer width = 165
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "사번"
boolean focusrectangle = false
end type

type st_1 from statictext within w_sg_10010_popup
integer x = 73
integer y = 428
integer width = 165
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "사번"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_sg_10010_popup
integer x = 261
integer y = 412
integer width = 302
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
end type

event rbuttondown;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

String ls_data

Open(w_sawon_popup)
If Trim(gs_code) = '' OR IsNull(gs_code) Then Return
	
SELECT DEPTCODE
  INTO :ls_data
  FROM P1_MASTER
 WHERE EMPNO = :gs_code ;
			
This.Text = gs_code

end event

type gb_1 from groupbox within w_sg_10010_popup
integer x = 37
integer y = 324
integer width = 603
integer height = 224
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "기존 사용자"
end type

type gb_2 from groupbox within w_sg_10010_popup
integer x = 777
integer y = 324
integer width = 603
integer height = 224
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 32106727
string text = "변경＆복사 사용자"
end type

type gb_3 from groupbox within w_sg_10010_popup
integer x = 37
integer y = 32
integer width = 1344
integer height = 208
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388608
long backcolor = 32106727
string text = "구분"
end type

