$PBExportHeader$w_pu05_00030_popup01.srw
$PBExportComments$** 외주불출(외주발주검토) 처리
forward
global type w_pu05_00030_popup01 from w_inherite_popup
end type
type rr_1 from roundrectangle within w_pu05_00030_popup01
end type
end forward

global type w_pu05_00030_popup01 from w_inherite_popup
integer x = 46
integer y = 160
integer width = 3538
integer height = 2112
string title = "발주품목정보 조회 선택"
rr_1 rr_1
end type
global w_pu05_00030_popup01 w_pu05_00030_popup01

on w_pu05_00030_popup01.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_pu05_00030_popup01.destroy
call super::destroy
destroy(this.rr_1)
end on

event open;call super::open;dw_jogun.SetTransObject(SQLCA)
dw_jogun.Reset()
dw_jogun.InsertRow(0)

//if gs_gubun = "" or isnull(gs_gubun) then gs_gubun = '1'    


dw_jogun.setitem(1, 'fr_date', left(f_today(), 6) + '01' )
dw_jogun.setitem(1, 'to_date', f_today())

IF gs_code = '3' then 
	dw_jogun.setitem(1, 'gubun', gs_code)
END IF
dw_jogun.SetFocus()

///////////////////////////////////////////////////////////////////////////////////
// 발주단위 사용에 따른 화면 변경
//sTring sCnvgu, sCnvart
//
///* 발주단위 사용여부를 환경설정에서 검색함 */
//select dataname
//  into :sCnvgu
//  from syscnfg
// where sysgu = 'Y' and serial = '12' and lineno = '3';
//If isNull(sCnvgu) or Trim(sCnvgu) = '' then
//	sCnvgu = 'N'
//End if

//if sCnvgu = 'Y' then // 발주단위 사용시
//	dw_1.dataobject = 'd_poblkt_popup1_1'
//Else						// 발주단위 사용안함
//	dw_1.dataobject = 'd_poblkt_popup1'	
//End if

dw_1.SetTransObject(sqlca)
dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)


end event

type dw_jogun from w_inherite_popup`dw_jogun within w_pu05_00030_popup01
integer x = 23
integer y = 164
integer width = 3497
integer height = 192
string dataobject = "d_pu05_00030_popup01_a"
end type

event dw_jogun::rbuttondown;call super::rbuttondown;String sNull

setnull(gs_code)
setnull(gs_gubun)
setnull(gs_codename)
setnull(snull)

IF this.GetColumnName() = "cvcod" THEN
	gs_gubun ='1'
	Open(w_vndmst_popup)

	IF isnull(gs_Code)  or  gs_Code = ''	then
		return
   ELSEIF gs_gubun = '3' or gs_gubun = '4' or gs_gubun = '5' then  //3:은행,4:부서,5:창고   
      f_message_chk(70, '[발주처]')
		this.SetItem(1, "cvcod", snull)
		this.SetItem(1, "vndmst_cvnas2", snull)
      return 1  		
   END IF
	this.SetItem(1, "cvcod", gs_Code)
	this.triggerevent(itemchanged!)
	
ELSEIF this.GetColumnName() = 'itnbr'	THEN
	open(w_itemas_popup)
	
	if Isnull(gs_code) or Trim(gs_code) = "" then return
	
	SetItem(1,"itnbr",gs_code)
	this.triggerevent(itemchanged!)
END IF


end event

event dw_jogun::itemerror;call super::itemerror;return 1
end event

event dw_jogun::itemchanged;call super::itemchanged;String ls_col ,ls_cod , ls_cvnas , snull
Long   ll_cnt ,ll_row

setnull(snull)
ls_col = Lower(This.GetColumnName())
ls_cod = Trim(This.GetText())   

Choose Case ls_col
	Case "cvcod" 
		If ls_cod = '' Or isNull(ls_cod)  Then
			f_message_chk(33 , '[거래처]')
			SetColumn(ls_col)
			Return 1
		End If
		Select cvnas 
		  Into :ls_cvnas 
		  From vndmst
		  Where cvcod = :ls_cod ;
		
		If sqlca.sqlcode <> 0 Then
			f_message_chk(33, "[거래처]")
			This.Object.cvnas[1] = ""
			Return 1
		End If
		
		This.Object.cvnas[1] = ls_cvnas
		
		
	Case "itnbr"
		string	sitdsc, sispec
		
		select itdsc, ispec into :sitdsc, :sispec from itemas
		 where itnbr = :ls_cod ;
		
		if sqlca.sqlcode = 0 then
			this.setitem(1,'itdsc',sitdsc)
			this.setitem(1,'ispec',sispec)
		else
			this.setitem(1,'itnbr',snull)
			this.setitem(1,'itdsc',snull)
			this.setitem(1,'ispec',snull)
			return 1
		end if
		
End Choose


	

end event

type p_exit from w_inherite_popup`p_exit within w_pu05_00030_popup01
integer x = 3291
integer y = 16
end type

event p_exit::clicked;call super::clicked;SetNull(gs_gubun)
SetNull(gs_code)
SetNull(gs_codename)

Close(Parent)
end event

type p_inq from w_inherite_popup`p_inq within w_pu05_00030_popup01
integer x = 2944
integer y = 16
end type

event p_inq::clicked;call super::clicked;String sdatef,sdatet, sempno, sgubun, sbalsts, scvcod, sitnbr

IF dw_jogun.AcceptText() = -1 THEN RETURN 

sdatef = TRIM(dw_jogun.GetItemString(1,"fr_date"))
sdatet = TRIM(dw_jogun.GetItemString(1,"to_date"))
sempno = dw_jogun.GetItemString(1,"sempno")
sgubun = dw_jogun.GetItemString(1,"gubun")
sbalsts = dw_jogun.GetItemString(1,"balsts")
scvcod = dw_jogun.GetItemString(1,"cvcod")
sitnbr = dw_jogun.GetItemString(1,"itnbr")

IF sdatef ="" OR IsNull(sdatef) THEN
	sdatef ='.'
END IF

IF sdatet = "" OR IsNull(sdatet) THEN
	sdatet ='99999999'
END IF

IF sempno ="" OR IsNull(sempno) THEN
	sempno ='%'
END IF

IF sgubun ="" OR IsNull(sgubun) THEN
	sgubun ='%'
END IF

IF sbalsts ="" OR IsNull(sbalsts) THEN
	sbalsts ='%'
END IF

IF scvcod ="" OR IsNull(scvcod) THEN
	scvcod ='%'
END IF

IF sitnbr ="" OR IsNull(sitnbr) THEN
	sitnbr ='%'
END IF

IF sdatet < sdatef THEN
	f_message_chk(34,'[기간]')
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

IF dw_1.Retrieve(gs_saupj,sdatef,sdatet,sempno, sgubun,sbalsts,sitnbr, scvcod) <= 0 THEN
	dw_jogun.SetColumn("fr_date")
	dw_jogun.SetFocus()
	Return
END IF

dw_1.SelectRow(0,False)
dw_1.SelectRow(1,True)
dw_1.ScrollToRow(1)
dw_1.SetFocus()
end event

type p_choose from w_inherite_popup`p_choose within w_pu05_00030_popup01
integer x = 3118
integer y = 16
end type

event p_choose::clicked;call super::clicked;Long ll_row

ll_Row = dw_1.GetSelectedRow(0)

IF ll_Row <= 0 THEN
   f_message_chk(36,'')
   return
END IF

gs_code= dw_1.GetItemString(ll_Row, "baljpno")
gs_codename= string(dw_1.GetItemNumber(ll_Row, "poblkt_balseq"))

Close(Parent)

end event

type dw_1 from w_inherite_popup`dw_1 within w_pu05_00030_popup01
integer x = 37
integer y = 376
integer width = 3447
integer height = 1596
string dataobject = "d_pu05_00030_popup01_b"
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

gs_code= dw_1.GetItemString(Row, "baljpno")
gs_codename= string(dw_1.GetItemNumber(Row, "poblkt_balseq"))

Close(Parent)

end event

type sle_2 from w_inherite_popup`sle_2 within w_pu05_00030_popup01
boolean visible = false
integer x = 1038
integer y = 2044
integer width = 1001
end type

type cb_1 from w_inherite_popup`cb_1 within w_pu05_00030_popup01
boolean visible = false
integer x = 1170
integer y = 2052
boolean enabled = false
end type

type cb_return from w_inherite_popup`cb_return within w_pu05_00030_popup01
boolean visible = false
integer x = 1792
integer y = 2052
integer taborder = 40
boolean enabled = false
end type

type cb_inq from w_inherite_popup`cb_inq within w_pu05_00030_popup01
boolean visible = false
integer x = 1481
integer y = 2052
integer taborder = 20
boolean enabled = false
boolean default = false
end type

type sle_1 from w_inherite_popup`sle_1 within w_pu05_00030_popup01
boolean visible = false
integer x = 375
integer y = 2044
integer width = 425
integer limit = 15
end type

type st_1 from w_inherite_popup`st_1 within w_pu05_00030_popup01
boolean visible = false
integer x = 105
integer y = 2064
integer width = 251
string text = "품목코드"
alignment alignment = left!
end type

type rr_1 from roundrectangle within w_pu05_00030_popup01
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 27
integer y = 368
integer width = 3470
integer height = 1624
integer cornerheight = 40
integer cornerwidth = 55
end type

