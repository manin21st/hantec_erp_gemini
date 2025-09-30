$PBExportHeader$w_kfia70a.srw
$PBExportComments$월자금 소요계획 자동생성-기준환율 적용
forward
global type w_kfia70a from window
end type
type st_title from statictext within w_kfia70a
end type
type p_exit from uo_picture within w_kfia70a
end type
type dw_rate from u_key_enter within w_kfia70a
end type
type em_ym from editmask within w_kfia70a
end type
type st_1 from statictext within w_kfia70a
end type
type ln_1 from line within w_kfia70a
end type
type rr_1 from roundrectangle within w_kfia70a
end type
end forward

global type w_kfia70a from window
integer x = 709
integer y = 836
integer width = 2674
integer height = 868
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 32106727
st_title st_title
p_exit p_exit
dw_rate dw_rate
em_ym em_ym
st_1 st_1
ln_1 ln_1
rr_1 rr_1
end type
global w_kfia70a w_kfia70a

forward prototypes
public subroutine wf_setting_rate (string scurym)
end prototypes

public subroutine wf_setting_rate (string scurym);String   sCurr,sCurrName
Integer  iCurRow,iFindRow

dw_rate.SetRedraw(False)

DECLARE Cur_Curr CURSOR FOR  
	SELECT "RFGUB",   "RFNA1"  
	   FROM "REFFPF"  
  		WHERE ("SABU" = '1' ) AND  ( "RFCOD" = '10' ) AND 
				("RFGUB" <> '00' AND "RFGUB" <> 'WON')  ;

Open Cur_Curr;
Do While True
	Fetch Cur_Curr INTO :sCurr, :sCurrName;
	IF Sqlca.Sqlcode <> 0 THEN exit
	
	iFindRow = dw_rate.Find("curr = '" + sCurr + "'",1, dw_rate.RowCount())
	IF iFindRow <= 0 THEN
		iCurRow = dw_rate.InsertRow(0)
		
		dw_rate.SetItem(iCurRow,"accym",sCurYm)
		dw_rate.SetItem(iCurRow,"curr", sCurr)
		
	END IF
Loop
Close Cur_Curr;	
dw_rate.SetRedraw(True)

dw_rate.SetSort("curr a")
dw_rate.Sort()

end subroutine

on w_kfia70a.create
this.st_title=create st_title
this.p_exit=create p_exit
this.dw_rate=create dw_rate
this.em_ym=create em_ym
this.st_1=create st_1
this.ln_1=create ln_1
this.rr_1=create rr_1
this.Control[]={this.st_title,&
this.p_exit,&
this.dw_rate,&
this.em_ym,&
this.st_1,&
this.ln_1,&
this.rr_1}
end on

on w_kfia70a.destroy
destroy(this.st_title)
destroy(this.p_exit)
destroy(this.dw_rate)
destroy(this.em_ym)
destroy(this.st_1)
destroy(this.ln_1)
destroy(this.rr_1)
end on

event open;String sYm

F_Window_Center_Response(This)

if Left(Message.StringParm,2) = 'CH' then
	st_title.Text = '차입금 상환계획'
else
	st_title.Text = '리스 상환계획'
end if

sYm = Mid(Message.StringParm,3,6)
em_ym.text = Left(sYm,4)+'.'+Mid(sYm,5,2)

dw_rate.SetTransObject(Sqlca)
dw_rate.Reset()
dw_rate.Retrieve(sYm)

Wf_Setting_Rate(sYm)
//em_rate.SetFocus()
end event

type st_title from statictext within w_kfia70a
integer x = 55
integer y = 164
integer width = 736
integer height = 56
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean underline = true
long textcolor = 8388608
long backcolor = 32106727
boolean focusrectangle = false
end type

type p_exit from uo_picture within w_kfia70a
integer x = 2441
integer width = 178
integer taborder = 20
string pointer = "C:\erpman\cur\close.cur"
string picturename = "C:\erpman\image\확인_up.gif"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;Double  dRate
Integer iCount,k
STring  sMod

iCount = dw_rate.RowCount()
IF iCount > 0 THEN 
	dw_rate.AcceptText()
	dRate = dw_rate.GetItemNumber(1,"sum_rate")
	IF dRate = 0 OR IsNull(dRate) THEN
		sMod = '0'
	ELSE
		dw_rate.SetRedraw(False)
		FOR k = iCount TO 1 Step -1
			IF dw_rate.GetItemNumber(k,"yrate") = 0 OR IsNull(dw_rate.GetItemNumber(k,"yrate")) THEN
				dw_rate.DeleteRow(k)
			END IF
		NEXT
		
		IF dw_rate.Update() <> 1 THEN
			F_MessageChk(13,'')
			Rollback;
			
			Wf_Setting_Rate(Left(em_ym.text,4)+Right(em_ym.text,2))
			
			dw_rate.SetRedraw(True)
			Return
		END IF
		Commit;
		dw_rate.SetRedraw(True)
	END IF
	sMod = '1'
ELSE
	sMod = '0'
END IF
CloseWithReturn(w_kfia70a,sMod)
end event

event ue_lbuttondown;call super::ue_lbuttondown;PictureName = "C:\erpman\image\확인_dn.gif"
end event

event ue_lbuttonup;call super::ue_lbuttonup;PictureName = "C:\erpman\image\확인_up.gif"
end event

type dw_rate from u_key_enter within w_kfia70a
integer x = 46
integer y = 228
integer width = 2551
integer height = 516
integer taborder = 10
string dataobject = "dw_kfia70a1"
boolean vscrollbar = true
boolean border = false
end type

type em_ym from editmask within w_kfia70a
integer x = 283
integer y = 36
integer width = 325
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
maskdatatype maskdatatype = datemask!
string mask = "yyyy.mm"
end type

type st_1 from statictext within w_kfia70a
integer x = 27
integer y = 40
integer width = 256
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 32106727
boolean enabled = false
string text = "생성년월"
alignment alignment = center!
boolean focusrectangle = false
end type

type ln_1 from line within w_kfia70a
integer linethickness = 1
integer beginx = 274
integer beginy = 92
integer endx = 617
integer endy = 92
end type

type rr_1 from roundrectangle within w_kfia70a
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 32
integer y = 156
integer width = 2583
integer height = 596
integer cornerheight = 40
integer cornerwidth = 55
end type

