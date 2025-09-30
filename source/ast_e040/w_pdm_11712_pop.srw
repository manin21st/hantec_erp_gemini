$PBExportHeader$w_pdm_11712_pop.srw
$PBExportComments$BOM제조원가등록팝업(18.12.10)
forward
global type w_pdm_11712_pop from w_inherite_popup
end type
type rr_1 from roundrectangle within w_pdm_11712_pop
end type
end forward

global type w_pdm_11712_pop from w_inherite_popup
integer x = 640
integer y = 200
integer width = 2811
integer height = 1796
string title = "BOM 제조원가 등록"
rr_1 rr_1
end type
global w_pdm_11712_pop w_pdm_11712_pop

type variables
string is_visible
end variables

on w_pdm_11712_pop.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pdm_11712_pop.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

string 	sitdsc, sispec, sitnbr, sittyp
decimal	dwonfac

SELECT ITDSC, ITTYP, WONFAC
    INTO  :sitdsc, :sittyp, :dwonfac
  FROM ITEMAS
WHERE ITNBR = :gs_code;
//f_get_name2('품번', 'Y', gs_code, sitdsc, sispec)    //1이면 실패, 0이 성공	

dw_jogun.setitem(1, "itnbr", gs_code)	    // 품번 
dw_jogun.setitem(1, "itdsc", sitdsc)	    // 품명 
dw_jogun.setitem(1, "wonfac", dwonfac)	    // 2018-12-17 판매단가→제조원가로 수정

/* 2018-12-17 제조원가 추가소스 */
if sIttyp <> '1' then
	select distinct mpm
	into :dwonfac
	from pstruc
	where cinbr = :gs_code;
			
	dw_jogun.setitem(1, "wonfac", dwonfac)
end if

p_inq.PostEvent(Clicked!)
end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pdm_11712_pop
integer x = 23
integer y = 8
integer width = 2162
integer height = 140
string title = ""
string dataobject = "d_pdm_11712_pop_1"
end type

type p_exit from w_inherite_popup`p_exit within w_pdm_11712_pop
integer x = 2578
integer y = 0
string picturename = "C:\erpman\image\닫기_up.gif"
end type

event p_exit::clicked;call super::clicked;SetNull(gs_code)
SetNull(gs_codename)
SetNull(gs_gubun)

close( parent)
end event

event p_exit::ue_lbuttondown;PictureName = 'C:\erpman\image\닫기_dn.gif'
end event

event p_exit::ue_lbuttonup;PictureName = 'C:\erpman\image\닫기_up.gif'
end event

type p_inq from w_inherite_popup`p_inq within w_pdm_11712_pop
boolean visible = false
integer x = 2231
integer y = 0
boolean originalsize = false
end type

event p_inq::clicked;call super::clicked;String   ls_itnbr, ls_depot_no, ls_ymd
  
IF dw_jogun.AcceptText() = -1 THEN RETURN 

ls_itnbr = dw_jogun.Getitemstring(1, "itnbr" )
IF dw_1.Retrieve(ls_itnbr) <= 0 THEN
//   messagebox("확인", "조건에 맞는 자료가 없습니다!!")
//	dw_jogun.SetColumn("depot_no")
//	dw_jogun.SetFocus()
	Return
END IF

ls_ymd = f_today()

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()

end event

type p_choose from w_inherite_popup`p_choose within w_pdm_11712_pop
integer x = 2405
integer y = 0
string picturename = "C:\erpman\image\저장_up.gif"
end type

event p_choose::clicked;call super::clicked;if dw_1.accepttext() = -1 then return
if dw_jogun.accepttext() = -1 then return

if messagebox("저장확인", "저장하시겠읍니까?", question!, yesno!) = 2 then return

string		ls_itnbr
decimal	ld_wonsrc

ls_itnbr = dw_jogun.getitemstring(1, 'itnbr')
ld_wonsrc = dw_jogun.getitemnumber(1, 'wonfac')

UPDATE ITEMAS
      SET WONSRC = :ld_wonsrc
WHERE ITNBR = :ls_itnbr;

if dw_1.update() = -1 then
	rollback;
	Messagebox("저장실패", "저장중 오류발생", stopsign!)
	return
end if

commit;

Close(Parent)

end event

event p_choose::ue_lbuttondown;PictureName = 'C:\erpman\image\저장_dn.gif'
end event

event p_choose::ue_lbuttonup;PictureName = 'C:\erpman\image\저장_up.gif'
end event

type dw_1 from w_inherite_popup`dw_1 within w_pdm_11712_pop
integer x = 32
integer y = 184
integer width = 2706
integer height = 1408
string dataobject = "d_pdm_11712_pop_2"
boolean hscrollbar = true
end type

event dw_1::clicked;If Row <= 0 then
	dw_1.SelectRow(0,False)
//	b_flag =True
ELSE

	SelectRow(0, FALSE)
	SelectRow(Row,TRUE)
	
//	b_flag = False
END IF

//CALL SUPER ::CLICKED
end event

event dw_1::doubleclicked;IF Row <= 0 THEN
   MessageBox("확 인", "선택값이 없습니다. 다시 선택한후 선택버튼을 누르십시오 !")
   return
END IF

//gs_code = dw_1.GetItemString(Row, "kumno") 
Close(Parent)
end event

type sle_2 from w_inherite_popup`sle_2 within w_pdm_11712_pop
boolean visible = false
integer x = 549
integer y = 2440
end type

type cb_1 from w_inherite_popup`cb_1 within w_pdm_11712_pop
boolean visible = false
integer x = 1815
integer y = 2440
end type

type cb_return from w_inherite_popup`cb_return within w_pdm_11712_pop
boolean visible = false
integer x = 2427
integer y = 2440
integer taborder = 40
end type

type cb_inq from w_inherite_popup`cb_inq within w_pdm_11712_pop
boolean visible = false
integer x = 2121
integer y = 2440
integer taborder = 20
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pdm_11712_pop
boolean visible = false
integer x = 366
integer y = 2440
end type

type st_1 from w_inherite_popup`st_1 within w_pdm_11712_pop
boolean visible = false
integer x = 87
integer y = 2440
end type

type rr_1 from roundrectangle within w_pdm_11712_pop
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 23
integer y = 176
integer width = 2725
integer height = 1424
integer cornerheight = 40
integer cornerwidth = 55
end type

