$PBExportHeader$w_sal_06690.srw
$PBExportComments$ ===> 수주 및 선적 현황
forward
global type w_sal_06690 from w_standard_print
end type
type rr_1 from roundrectangle within w_sal_06690
end type
end forward

global type w_sal_06690 from w_standard_print
string title = "수주 및 선적 현황"
rr_1 rr_1
end type
global w_sal_06690 w_sal_06690

forward prototypes
public function integer wf_retrieve ()
end prototypes

public function integer wf_retrieve ();String sSel, sGubun, yy, sS, sS_Name, sToDate, sCvstatus ,ls_magam

If dw_ip.AcceptText() <> 1 Then Return -1

sToDate = Trim(dw_ip.GetItemString(1,'syy'))

yy = Left(sToDate,4)

if	(yy = '') or isNull(yy) then
	f_Message_Chk(35, '[기준년월]')
	dw_ip.setcolumn('syy')
	dw_ip.setfocus()
	Return -1
end if

sSel   = Trim(dw_ip.GetItemString(1,'sel'))
sGubun = Trim(dw_ip.GetItemString(1,'gubun'))

sCvstatus = Trim(dw_ip.GetItemString(1,'cvstatus'))
If IsNull(sCvstatus) or sCvstatus = '3' Then sCvstatus = ''

// 관할구역 선택
sS = Trim(dw_ip.GetItemString(1,'sarea'))
if isNull(sS) or (sS = '') then
	sS = ''
	sS_Name = '전  체'
else
	Select sareanm Into :sS_Name 
	From sarea
	Where sarea = :sS;
	if isNull(sS_Name) then
		sS_Name = ''
	end if
end if
sS = sS + '%'

dw_print.object.r_yy.Text = yy + '년'

If sSel = '1' then
	/* Buyer별 */
   dw_print.object.r_sarea.Text = sS_Name		
   If dw_print.Retrieve(gs_sabu, sS, yy+'01',sToDate, sCvstatus+'%') < 1 then
      f_message_Chk(300, '[출력조건 CHECK]')
    	dw_ip.setcolumn('syy')
      dw_ip.setfocus()
		//return -1
	End if
	dw_print.sharedata(dw_list)
Else
   If dw_print.Retrieve(gs_sabu, yy+'01', sToDate) < 1 then
      f_message_Chk(300, '[출력조건 CHECK]')
    	dw_ip.setcolumn('syy')
      dw_ip.setfocus()
		dw_list.insertrow(0)
    	//return -1
	end if
	dw_print.sharedata(dw_list)
end if

SELECT MAX(JPDAT)
INTO :ls_magam
FROM JUNPYO_CLOSING 
WHERE JPGU = 'X3' ;

if ls_magam = '' or isnull(ls_magam) then
	dw_print.object.tx_magam.text ='전체'
else
	dw_print.object.tx_magam.text = left(ls_magam,4) +'.' + mid(ls_magam,5,2)
end if

return 1
end function

on w_sal_06690.create
int iCurrent
call super::create
this.rr_1=create rr_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
end on

on w_sal_06690.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
end on

event open;call super::open;dw_ip.setitem(1,'syy',left(f_today(),6))

//관할 구역
f_child_saupj(dw_ip, 'sarea', gs_saupj) 


sle_msg.text = "출력조건을 입력하고 조회버턴을 누르세요"
end event

type p_xls from w_standard_print`p_xls within w_sal_06690
end type

type p_sort from w_standard_print`p_sort within w_sal_06690
end type

type p_preview from w_standard_print`p_preview within w_sal_06690
end type

type p_exit from w_standard_print`p_exit within w_sal_06690
end type

type p_print from w_standard_print`p_print within w_sal_06690
end type

type p_retrieve from w_standard_print`p_retrieve within w_sal_06690
end type







type st_10 from w_standard_print`st_10 within w_sal_06690
end type



type dw_print from w_standard_print`dw_print within w_sal_06690
string dataobject = "d_sal_06690_02_p"
end type

type dw_ip from w_standard_print`dw_ip within w_sal_06690
integer x = 0
integer y = 8
integer width = 3287
string dataobject = "d_sal_06690_01"
end type

event dw_ip::itemerror;return 1
end event

event dw_ip::itemchanged;String sCol_Name, sNull, sSel, sGubun

sCol_Name = This.GetColumnName()
SetNull(sNull)

dw_list.SetRedraw(False)

Choose Case sCol_Name
	Case "sel"
		sSel = this.GetText()
		sGubun = this.GetItemString(1, "gubun")

		if sSel = '1' and sGubun = '1' then     // BUYER별이면서 원화를 Click 했을 경우
			dw_list.DataObject = "d_sal_06690_02"
			dw_print.dataobject = 'd_sal_06690_02_p'
		elseif sSel = '1' and sGubun = '2' then // BUYER별이면서 달러를 Click 했을 경우
			dw_list.DataObject = "d_sal_06690_03"
			dw_print.dataobject = 'd_sal_06690_03_p'
		elseif sSel = '2' and sGubun = '1' then // 관할구역별이면서 원화를 Click 했을 경우
			dw_list.DataObject = "d_sal_06680_02"	
			dw_print.dataobject = "d_sal_06680_02"
		else                                    // 관할구역별이면서 달러를 Click 했을 경우
			dw_list.DataObject = "d_sal_06680_03"
			dw_print.dataobject = "d_sal_06680_03"
		end if
		dw_list.Settransobject(sqlca)
		dw_print.settransobject(sqlca)
		this.Setitem(1, "sarea", sNull)

	Case "gubun"
		sGubun = this.GetText()
		sSel = this.GetItemString(1, "sel")
		if sSel = '1' and sGubun = '1' then     // BUYER별이면서 원화를 Click 했을 경우
			dw_list.DataObject = "d_sal_06690_02"
			dw_print.DataObject = "d_sal_06690_02_p"
		elseif sSel = '1' and sGubun = '2' then // BUYER별이면서 달러를 Click 했을 경우
			dw_list.DataObject = "d_sal_06690_03"
			dw_print.DataObject = "d_sal_06690_03_p"
		elseif sSel = '2' and sGubun = '1' then // 관할구역별이면서 원화를 Click 했을 경우
			dw_list.DataObject = "d_sal_06680_02"
			dw_print.DataObject = "d_sal_06680_02"
		else                                    // 관할구역별이면서 달러를 Click 했을 경우
			dw_list.DataObject = "d_sal_06680_03"
			dw_print.DataObject = "d_sal_06680_03"
		end if	
		dw_list.Settransobject(sqlca)
		dw_print.Settransobject(sqlca)
end Choose

dw_list.SetRedraw(True)
end event

type dw_list from w_standard_print`dw_list within w_sal_06690
integer x = 23
integer y = 288
integer height = 2036
string dataobject = "d_sal_06690_02"
boolean border = false
end type

type rr_1 from roundrectangle within w_sal_06690
long linecolor = 28144969
integer linethickness = 1
long fillcolor = 32106727
integer x = 9
integer y = 276
integer width = 4622
integer height = 2060
integer cornerheight = 40
integer cornerwidth = 55
end type

